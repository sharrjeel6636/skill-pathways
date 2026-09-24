from fastapi import FastAPI, Depends, HTTPException, Header, Request
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Dict, Optional
import os
import time
from collections import deque
from supabase import create_client, Client
from dotenv import load_dotenv
from google import genai

load_dotenv(dotenv_path=os.path.join(os.path.dirname(__file__), '.env'))

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

supabase_url = os.environ.get("SUPABASE_URL") or "https://your-project.supabase.co"
supabase_key = os.environ.get("SUPABASE_KEY") or "your-anon-key"
supabase: Client = create_client(supabase_url, supabase_key)

# --- RATE LIMITING ---
rate_limit_store = {}
RATE_LIMIT_WINDOW = 60 # seconds
RATE_LIMIT_MAX = 5 # requests

def check_rate_limit(request: Request):
    client_ip = request.client.host
    now = time.time()
    if client_ip not in rate_limit_store:
        rate_limit_store[client_ip] = deque()
    while rate_limit_store[client_ip] and rate_limit_store[client_ip][0] < now - RATE_LIMIT_WINDOW:
        rate_limit_store[client_ip].popleft()
    if len(rate_limit_store[client_ip]) >= RATE_LIMIT_MAX:
        raise HTTPException(status_code=429, detail="Too many requests")
    rate_limit_store[client_ip].append(now)

# --- GEMINI CLIENT ---
gemini_client = genai.Client(api_key=os.environ.get("GEMINI_API_KEY"))

# --- AUTH DEPS ---
async def get_current_user(authorization: Optional[str] = Header(None)):
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Unauthorized")
    token = authorization.split(" ")[1]
    try:
        user = supabase.auth.get_user(token)
        return user.user.id
    except Exception:
        raise HTTPException(status_code=401, detail="Invalid token")

async def verify_user_access(user_id: str, current_user: str = Depends(get_current_user)):
    if current_user != user_id:
        raise HTTPException(status_code=403, detail="Forbidden")
    return current_user

# --- ENDPOINTS ---

@app.get("/pathways")
async def get_pathways():
    return supabase.table("pathways").select("*").execute().data

@app.get("/pathways/{pathway_id}/steps")
async def get_pathway_steps(pathway_id: int, user_id: Optional[str] = None):
    steps = supabase.table("pathway_steps").select("*").eq("pathway_id", pathway_id).order("step_order").execute().data
    if user_id:
        progress = supabase.table("user_progress").select("step_id, status").eq("user_id", user_id).execute().data
        progress_map = {p['step_id']: p['status'] for p in progress}
        for i, step in enumerate(steps):
            if step['id'] in progress_map:
                step['status'] = progress_map[step['id']]
            elif i == 0:
                step['status'] = 'active'
            else:
                step['status'] = 'locked'
    return steps

@app.get("/quiz/questions")
async def get_quiz_questions():
    questions = supabase.table("quiz_questions").select("*").execute().data
    if not questions:
        return []
    question_ids = [q['id'] for q in questions]
    all_options = supabase.table("quiz_options").select("*").in_("question_id", question_ids).execute().data
    options_by_question = {}
    for opt in all_options:
        options_by_question.setdefault(opt['question_id'], []).append(opt)
    for q in questions:
        q['options'] = options_by_question.get(q['id'], [])
    return questions

class QuizSubmit(BaseModel):
    option_ids: List[int]

@app.post("/quiz/submit", dependencies=[Depends(get_current_user)])
async def submit_quiz(submission: QuizSubmit):
    options = supabase.table("quiz_options").select("id, maps_to_pathway_id, weight").in_("id", submission.option_ids).execute().data
    scores = {}
    for opt in options:
        pid = opt['maps_to_pathway_id']
        scores[pid] = scores.get(pid, 0) + opt['weight']
    recommended_pathway_id = max(scores, key=scores.get) if scores else None
    return {"pathway_id": recommended_pathway_id}

@app.get("/dashboard/{user_id}")
async def get_dashboard(user_id: str, _ = Depends(verify_user_access)):
    up = supabase.table("user_pathways").select("*, pathways(title)").eq("user_id", user_id).execute().data
    if not up: return {"message": "No active pathway"}
    pathway = up[0]
    steps = supabase.table("pathway_steps").select("id, title, step_order").eq("pathway_id", pathway['pathway_id']).order("step_order").execute().data
    progress = supabase.table("user_progress").select("step_id, status").eq("user_id", user_id).execute().data
    
    completed_step_ids = {p['step_id'] for p in progress if p['status'] == 'mastered'}
    
    next_step_title = "All steps completed!"
    for step in steps:
        if step['id'] not in completed_step_ids:
            next_step_title = step['title']
            break
            
    total = len(steps)
    done = len(completed_step_ids)
    percent = (done / total * 100) if total > 0 else 0
    return {"pathway_title": pathway['pathways']['title'], "progress_percent": percent, "steps_done": done, "total_steps": total, "next_step": next_step_title}


@app.post("/user/{user_id}/skills", dependencies=[Depends(verify_user_access)])
async def update_user_skills(user_id: str, skills: List[str]):
    supabase.table("user_skills").upsert({"user_id": user_id, "skills": skills}).execute()
    return {"message": "Skills updated"}

@app.get("/skill-gap-analysis/{user_id}", dependencies=[Depends(verify_user_access)])
async def get_skill_gap_analysis(user_id: str, target_role: str):
    # Fetch target role skills
    role_data = supabase.table("role_skills").select("*").eq("role_name", target_role).single().execute().data
    if not role_data:
        raise HTTPException(status_code=404, detail="Role not found")
    
    required = set(role_data['required_skills'])
    
    # Fetch user skills
    user_skills_data = supabase.table("user_skills").select("skills").eq("user_id", user_id).maybe_single().execute().data
    current_skills = set(user_skills_data['skills']) if user_skills_data else set()
    
    have_skills = list(required.intersection(current_skills))
    missing_skills = list(required.difference(current_skills))
    
    # Recommended order based on role config
    recommended_order = [s for s in role_data['recommended_order'] if s in missing_skills]
    
    # Suggested courses (simple match on skill name in learning_materials title/tag)
    suggested_courses = {}
    for skill in missing_skills:
        courses = supabase.table("learning_materials").select("id, title").ilike("pathway_tag", f"%{skill}%").execute().data
        suggested_courses[skill] = courses
        
    return {
        "target_role": target_role,
        "have_skills": have_skills,
        "missing_skills": missing_skills,
        "recommended_order": recommended_order,
        "suggested_courses": suggested_courses
    }

@app.get("/user/{user_id}/skill-gap", dependencies=[Depends(verify_user_access)])
async def get_skill_gap(user_id: str):
    user_pathway = supabase.table("user_pathways").select("pathway_id, pathways(title)").eq("user_id", user_id).execute().data
    if not user_pathway:
        return {"error": "No active pathway found"}
    
    pathway_id = user_pathway[0]['pathway_id']
    pathway_title = user_pathway[0]['pathways']['title']
    
    steps = supabase.table("pathway_steps").select("*").eq("pathway_id", pathway_id).order("step_order").execute().data
    progress = supabase.table("user_progress").select("step_id, status").eq("user_id", user_id).execute().data
    progress_map = {p['step_id']: p['status'] for p in progress}
    
    mastered = []
    gaps = []
    
    for step in steps:
        if progress_map.get(step['id']) == 'mastered':
            mastered.append(step['title'])
        else:
            gaps.append({"step_id": step['id'], "title": step['title'], "difficulty": step.get('difficulty', 'medium')})
    
    return {
        "target_role": pathway_title,
        "current_skills": mastered,
        "skill_gaps": gaps,
        "recommended_steps": gaps
    }

@app.get("/learning-material", dependencies=[Depends(get_current_user)])
async def get_learning_material(pathway_tag: Optional[str] = None):
    query = supabase.table("learning_materials").select("*")
    if pathway_tag:
        query = query.eq("pathway_tag", pathway_tag)
    return query.execute().data

class ChatMessage(BaseModel):
    text: str
    context: Optional[dict] = None

@app.post("/chatbot/message", dependencies=[Depends(get_current_user), Depends(check_rate_limit)])
async def chatbot_message(message: ChatMessage):
    ctx = message.context or {}
    mode = ctx.get("mode", "student")
    
    system_prompt = """You are a helpful career/education guidance assistant for Pakistani students and parents using the Skill Pathway app.
    - Give concise, encouraging, jargon-free answers (2-4 sentences typically).
    - Reference Pakistan-specific context when relevant (HEC, TEVTA, PPSC/FPSC, MDCAT/ECAT/NUST NET, local scholarships).
    - Never fabricate specific numbers (fees, dates, percentages). If you don't know, suggest checking relevant in-app screens (University Detail, Scholarship Info).
    """
    
    if mode == "parent":
        system_prompt += f"\nYou are advising a parent. Answer in a reassuring, non-jargon tone. The child's name is {ctx.get('student_name', 'your child')}."
    elif mode == "mock_interview":
        system_prompt += "\nYou are conducting a mock job interview. Ask one interview question at a time, wait for the user's answer, then provide brief constructive feedback before asking the next question. Do not answer general guidance questions."
    
    if ctx.get("field_of_interest") or ctx.get("quiz_top_field"):
        system_prompt += f"\nPersonalization: The student is interested in or identified as a good fit for: {ctx.get('field_of_interest') or ctx.get('quiz_top_field')}."

    response = gemini_client.models.generate_content(
        model='gemini-2.0-flash',
        contents=message.text,
        config=genai.types.GenerateContentConfig(
            system_instruction=system_prompt,
        )
    )
    return {"reply": response.text}
