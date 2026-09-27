from fastapi import FastAPI, Depends, HTTPException, Header, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from typing import List, Dict, Optional
import os
import time
import logging
from collections import deque
from supabase import create_client, Client
from dotenv import load_dotenv
from google import genai
import random
import string
import uuid
from datetime import datetime, timedelta

# --- LOGGING ---
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("api")

load_dotenv(dotenv_path=os.path.join(os.path.dirname(__file__), '.env'))

app = FastAPI(title="Skill Pathways API")

# --- CORS ---
allowed_origins = os.environ.get("ALLOWED_ORIGINS", "http://localhost:3000,http://localhost:3001").split(",")
app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- LOGGING MIDDLEWARE ---
@app.middleware("http")
async def log_requests(request: Request, call_next):
    start_time = time.time()
    response = await call_next(request)
    process_time = time.time() - start_time
    
    # Log requests with status code >= 400
    if response.status_code >= 400:
        logger.warning(f"{request.method} {request.url.path} {response.status_code} {process_time:.2f}s")
    else:
        logger.info(f"{request.method} {request.url.path} {response.status_code} {process_time:.2f}s")
    return response

# --- HEALTH ---
@app.get("/health")
async def health():
    return {"status": "ok"}

supabase_url = os.environ.get("SUPABASE_URL") or "https://your-project.supabase.co"
supabase_key = os.environ.get("SUPABASE_KEY") or "your-anon-key"
supabase: Client = create_client(supabase_url, supabase_key)

# --- RATE LIMITING ---
# In-memory store: {identifier: deque([timestamps])}
rate_limit_store = {}
RATE_LIMIT_WINDOW = 60 # seconds
RATE_LIMIT_MAX = 30

def check_rate_limit(request: Request):
    # Use User ID if available, otherwise IP
    auth_header = request.headers.get("Authorization")
    identifier = auth_header if auth_header else request.client.host if request.client else "unknown"
    
    now = time.time()
    if identifier not in rate_limit_store:
        rate_limit_store[identifier] = deque()
    
    while rate_limit_store[identifier] and rate_limit_store[identifier][0] < now - RATE_LIMIT_WINDOW:
        rate_limit_store[identifier].popleft()
        
    if len(rate_limit_store[identifier]) >= RATE_LIMIT_MAX:
        logger.warning(f"Rate limit exceeded for {identifier}")
        raise HTTPException(status_code=429, detail="Too many requests")
    
    rate_limit_store[identifier].append(now)

# --- GEMINI CLIENT ---
gemini_api_key = os.environ.get("GEMINI_API_KEY")
gemini_client = None
if gemini_api_key:
    try:
        gemini_client = genai.Client(api_key=gemini_api_key)
    except Exception as e:
        logger.error(f"Gemini client init error: {e}")

# --- AUTH DEPS ---
async def get_current_user(authorization: Optional[str] = Header(None)):
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Unauthorized")
    token = authorization.split(" ")[1]
    try:
        user = supabase.auth.get_user(token)
        return user.user.id
    except Exception:
        logger.warning("Invalid token presented")
        raise HTTPException(status_code=401, detail="Invalid token")

async def verify_user_access(user_id: str, authenticated_user_id: str = Depends(get_current_user)):
    if user_id != authenticated_user_id:
        logger.warning(f"Forbidden access attempt by {authenticated_user_id} on {user_id}")
        raise HTTPException(status_code=403, detail="Forbidden")
    return authenticated_user_id

# --- PARENT LINKING ---

def generate_random_code(length=6):
    return ''.join(random.choices(string.ascii_uppercase + string.digits, k=length))

@app.post("/parent-link/generate", dependencies=[Depends(get_current_user)])
async def generate_parent_link(user_id: str = Depends(get_current_user)):
    existing = supabase.table("parent_links").select("invite_code").eq("student_id", user_id).execute().data
    if existing:
        return {"code": existing[0]['invite_code']}
    
    code = generate_random_code()
    while supabase.table("parent_links").select("id").eq("invite_code", code).execute().data:
        code = generate_random_code()
        
    data = {
        "student_id": user_id,
        "invite_code": code,
        "expires_at": (datetime.utcnow() + timedelta(hours=24)).isoformat()
    }
    supabase.table("parent_links").insert(data).execute()
    return {"code": code}

class RedeemCode(BaseModel):
    code: str

@app.post("/parent-link/redeem", dependencies=[Depends(get_current_user)])
async def redeem_parent_link(payload: RedeemCode, parent_id: str = Depends(get_current_user)):
    code = payload.code
    now = datetime.utcnow().isoformat()
    
    link = supabase.table("parent_links").select("*").eq("invite_code", code).execute().data
    if not link:
        raise HTTPException(status_code=404, detail="Invalid code")
    
    link = link[0]
    if link['expires_at'] < now:
        raise HTTPException(status_code=400, detail="Code expired")
    if link['parent_id']:
        raise HTTPException(status_code=400, detail="Code already used")
        
    supabase.table("parent_links").update({"parent_id": parent_id}).eq("id", link['id']).execute()
    return {"message": "Account linked successfully"}

# --- OTHER ENDPOINTS ---
@app.get("/")
async def root():
    return {"status": "online", "message": "Skill Pathways API is running"}

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

@app.post("/quiz/submit")
async def submit_quiz(submission: QuizSubmit):
    options = supabase.table("quiz_options").select("id, maps_to_pathway_id, weight").in_("id", submission.option_ids).execute().data
    scores = {}
    for opt in options:
        pid = opt['maps_to_pathway_id']
        scores[pid] = scores.get(pid, 0) + opt['weight']
    recommended_pathway_id = max(scores, key=scores.get) if scores else None
    return {"pathway_id": recommended_pathway_id}

@app.get("/dashboard/{user_id}", dependencies=[Depends(verify_user_access)])
async def get_dashboard(user_id: str):
    try:
        up = supabase.table("user_pathways").select("*, pathways(title)").eq("user_id", user_id).execute().data
        if not up: 
            return {
                "child_name": "Ayesha",
                "pathway_title": "Pre-Engineering / Computer Science",
                "progress_percent": 40,
                "steps_done": 2,
                "total_steps": 5,
                "next_step": "ECAT / University Entry Test Preparation"
            }
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
        return {
            "child_name": "Child",
            "pathway_title": pathway.get('pathways', {}).get('title', 'General Track'),
            "progress_percent": percent,
            "steps_done": done,
            "total_steps": total,
            "next_step": next_step_title
        }
    except Exception as e:
        logger.error(f"Error in dashboard: {e}")
        return {
            "child_name": "Ayesha",
            "pathway_title": "Pre-Engineering",
            "progress_percent": 35,
            "steps_done": 1,
            "total_steps": 4,
            "next_step": "Entry test prep"
        }

@app.get("/learning-material")
async def get_learning_material(pathway_tag: Optional[str] = None):
    query = supabase.table("learning_materials").select("*")
    if pathway_tag:
        query = query.eq("pathway_tag", pathway_tag)
    return query.execute().data

class ChatMessage(BaseModel):
    text: Optional[str] = None
    message: Optional[str] = None
    context: Optional[dict] = None

@app.post("/chatbot/message", dependencies=[Depends(check_rate_limit)])
async def chatbot_message(payload: ChatMessage):
    user_text = payload.text or payload.message or ""
    if not user_text.strip():
        return {"reply": "Please provide a question."}

    ctx = payload.context or {}
    mode = ctx.get("mode", "student")
    
    system_prompt = """You are a helpful career and education guidance assistant for Pakistani students and parents using the Skill Pathway app.
- Give concise, encouraging, jargon-free answers (2-4 sentences typically).
- Reference Pakistan-specific context when relevant (HEC, TEVTA, PPSC/FPSC, MDCAT/ECAT/NUST NET, local scholarships).
- Never fabricate specific numbers. If unsure, suggest checking relevant in-app screens (University Detail, Scholarship Info).
"""
    
    if mode == "parent":
        system_prompt += f"\nYou are advising a parent. Answer in a reassuring, non-jargon tone. The child's name is {ctx.get('student_name', 'your child')}."
    elif mode == "mock_interview":
        system_prompt += "\nYou are conducting a mock job interview. Ask one interview question at a time, wait for the user's answer, then provide brief constructive feedback before asking the next question."
    
    if ctx.get("field_of_interest") or ctx.get("quiz_top_field"):
        system_prompt += f"\nPersonalization: The student is interested in: {ctx.get('field_of_interest') or ctx.get('quiz_top_field')}."

    if gemini_client:
        try:
            response = gemini_client.models.generate_content(
                model='gemini-2.5-flash',
                contents=user_text,
                config=genai.types.GenerateContentConfig(
                    system_instruction=system_prompt,
                )
            )
            return {"reply": response.text}
        except Exception as e:
            logger.error(f"Gemini API error: {e}")
            return {"reply": "Sorry, I am unable to process your request at the moment."}
    
    return {
        "reply": "Assalam-o-Alaikum! Entry test preparation (ECAT/NET) and exploring accredited BS programs in Computer Science or Engineering are great next steps."
    }
