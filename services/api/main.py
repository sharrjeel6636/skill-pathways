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
    for q in questions:
        options = supabase.table("quiz_options").select("*").eq("question_id", q['id']).execute().data
        q['options'] = options
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
    steps = supabase.table("pathway_steps").select("id").eq("pathway_id", pathway['pathway_id']).execute().data
    progress = supabase.table("user_progress").select("status").eq("user_id", user_id).execute().data
    total = len(steps)
    done = sum(1 for p in progress if p['status'] == 'mastered')
    percent = (done / total * 100) if total > 0 else 0
    return {"pathway_title": pathway['pathways']['title'], "progress_percent": percent, "steps_done": done, "total_steps": total, "next_step": "..."}

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
