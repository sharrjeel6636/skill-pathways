from fastapi import FastAPI, Depends, HTTPException, Header
from pydantic import BaseModel
from typing import List, Dict, Optional
import os
from supabase import create_client, Client
from dotenv import load_dotenv

load_dotenv()

app = FastAPI()

supabase_url = os.environ.get("SUPABASE_URL")
supabase_key = os.environ.get("SUPABASE_KEY")
supabase: Client = create_client(supabase_url, supabase_key)

@app.get("/learning-material")
async def list_learning_materials(pathway_tag: Optional[str] = None):
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
    # Placeholder for analytics logic
    total_users = supabase.table("profiles").select("id", count='exact').execute().count

    # Query pathways and counts (simplified)
    pathways = supabase.table("user_pathways").select("pathway_id").execute().data

    # Simple logic for most popular
    counts = {}
    for p in pathways:
        pid = p["pathway_id"]
        counts[pid] = counts.get(pid, 0) + 1

    most_popular = max(counts, key=counts.get) if counts else None

    return {
        "active_users": total_users,
        "most_popular_pathway_id": most_popular,
        "completion_rate": "15%" # Placeholder
    }
