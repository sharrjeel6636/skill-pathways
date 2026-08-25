from fastapi import FastAPI, Depends, HTTPException, Header
from fastapi.middleware.cors import CORSMiddleware
import os

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

def get_current_user(authorization: str = Header(...)):
    # Simple placeholder: In production, verify JWT using Supabase public key
    if not authorization.startswith("Bearer "):
        raise HTTPException(status_code=403, detail="Invalid token")
    return {"user_id": "mock-user-id"}

@app.get("/api/profile")
async def get_profile(user: dict = Depends(get_current_user)):
    return {"message": "Empty dashboard placeholder", "user": user}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
