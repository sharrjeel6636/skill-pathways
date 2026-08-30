from fastapi import FastAPI, Depends, HTTPException, Header
from pydantic import BaseModel
from typing import List, Dict, Optional
import os
from supabase import create_client, Client
from dotenv import load_dotenv

load_dotenv(dotenv_path=os.path.join(os.path.dirname(__file__), '.env'))

app = FastAPI()

supabase_url = os.environ.get("SUPABASE_URL") or "https://your-project.supabase.co"
supabase_key = os.environ.get("SUPABASE_KEY") or "your-anon-key"
print(f"DEBUG: SUPABASE_URL={supabase_url}")
supabase: Client = create_client(supabase_url, supabase_key)

# --- PATHWAYS & ROADMAP ---

@app.get("/pathways")
async def get_pathways():
    try:
        return supabase.table("pathways").select("*").execute().data
    except Exception as e:
        print(f"Error fetching pathways: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/pathways/{pathway_id}/steps")
async def get_pathway_steps(pathway_id: int, user_id: Optional[str] = None):
    # Fetch ordered steps
    steps = supabase.table("pathway_steps").select("*").eq("pathway_id", pathway_id).order("step_order").execute().data

    if user_id:
        # Get progress
        progress = supabase.table("user_progress").select("step_id, status").eq("user_id", user_id).execute().data
        progress_map = {p['step_id']: p['status'] for p in progress}

        # Mark steps based on progress
        for i, step in enumerate(steps):
            if step['id'] in progress_map:
                step['status'] = progress_map[step['id']]
            elif i == 0:
                step['status'] = 'active'
            else:
                step['status'] = 'locked'
    return steps

# --- QUIZ ---

@app.get("/quiz/questions")
async def get_quiz_questions():
    questions = supabase.table("quiz_questions").select("*").execute().data
    for q in questions:
        options = supabase.table("quiz_options").select("*").eq("question_id", q['id']).execute().data
        q['options'] = options
    return questions

class QuizSubmit(BaseModel):
    option_ids: List[int]

@app.post("/quiz/submit")
async def submit_quiz(submission: QuizSubmit):
    # Tally votes per pathway
    options = supabase.table("quiz_options").select("id, maps_to_pathway_id, weight").in_("id", submission.option_ids).execute().data
    scores = {}
    for opt in options:
        pid = opt['maps_to_pathway_id']
        scores[pid] = scores.get(pid, 0) + opt['weight']

    recommended_pathway_id = max(scores, key=scores.get) if scores else None
    return {"pathway_id": recommended_pathway_id}

# --- DASHBOARD ---

@app.get("/dashboard/{user_id}")
async def get_dashboard(user_id: str):
    # Get active pathway
    up = supabase.table("user_pathways").select("*, pathways(title)").eq("user_id", user_id).execute().data
    if not up: return {"message": "No active pathway"}

    pathway = up[0]
    steps = supabase.table("pathway_steps").select("id").eq("pathway_id", pathway['pathway_id']).execute().data
    progress = supabase.table("user_progress").select("status").eq("user_id", user_id).execute().data

    total = len(steps)
    done = sum(1 for p in progress if p['status'] == 'mastered')
    percent = (done / total * 100) if total > 0 else 0

    return {
        "pathway_title": pathway['pathways']['title'],
        "progress_percent": percent,
        "steps_done": done,
        "total_steps": total,
        "next_step": "..."
    }

# --- EXISTING ENDPOINTS ---

@app.get("/learning-material")
async def get_learning_material(pathway_tag: Optional[str] = None):
    query = supabase.table("learning_materials").select("*")
    if pathway_tag:
        query = query.eq("pathway_tag", pathway_tag)
    return query.execute().data

@app.post("/learning-material")
async def create_learning_material(material: dict):
    response = supabase.table("learning_materials").insert(material).execute()
    return response.data

@app.patch("/learning-material/{id}/verify")
async def verify_learning_material(id: int):
    response = supabase.table("learning_materials").update({"is_verified": True}).eq("id", id).execute()
    return response.data

@app.post("/chatbot/message")
async def chatbot_message(message: dict):
    user_text = message.get("text", "").lower()
    if "internship" in user_text:
        return {"reply": "Internships are a great way to gain experience! Check the Opportunities tab for listings."}
    elif "scholarship" in user_text:
        return {"reply": "Scholarships can help fund your journey. We track many here; check Opportunities for deadlines."}
    elif "next step" in user_text:
        return {"reply": "To identify your next step, go to your Roadmap and look for the 'active' node."}
    return {"reply": "I'm not sure, but I can help you with internships, scholarships, or navigating your roadmap."}

@app.get("/admin/analytics")
async def get_analytics():
    total_users = supabase.table("profiles").select("id", count='exact').execute().count
    pathways = supabase.table("user_pathways").select("pathway_id").execute().data

    counts = {}
    for p in pathways:
        pid = p["pathway_id"]
        counts[pid] = counts.get(pid, 0) + 1

    most_popular = max(counts, key=counts.get) if counts else None

    return {
        "active_users": total_users,
        "most_popular_pathway_id": most_popular,
        "completion_rate": "15%"
    }
