import pytest
from fastapi.testclient import TestClient
import sys
import os

# Add the parent directory to sys.path so 'main' can be imported
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from main import app
from unittest.mock import patch, MagicMock

client = TestClient(app)

def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "ok"
    assert "service" in data

def test_public_endpoints():
    response = client.get("/pathways")
    assert response.status_code == 200
    assert isinstance(response.json(), list)

    response = client.get("/quiz/questions")
    assert response.status_code == 200

    response = client.get("/universities")
    assert response.status_code == 200
    assert isinstance(response.json(), list)

    response = client.get("/scholarships")
    assert response.status_code == 200
    assert isinstance(response.json(), list)

    response = client.get("/learning-material")
    assert response.status_code == 200

def test_unauthorized_access():
    # Accessing protected endpoint without token
    response = client.get("/dashboard/user123")
    assert response.status_code == 401

def test_invalid_token():
    # Accessing protected endpoint with invalid token
    response = client.get("/dashboard/user123", headers={"Authorization": "Bearer invalidtoken"})
    assert response.status_code == 401

@patch("main.supabase")
def test_quiz_submit(mock_supabase):
    mock_supabase.table.return_value.select.return_value.in_.return_value.execute.return_value.data = [
        {"id": 1, "maps_to_pathway_id": 1, "weight": 10},
        {"id": 2, "maps_to_pathway_id": 2, "weight": 5}
    ]

    response = client.post("/quiz/submit", json={"option_ids": [1, 2]})
    assert response.status_code == 200
    assert "pathway_id" in response.json()

def test_rate_limit():
    # Rapid requests to trigger rate limit on chatbot endpoint
    for _ in range(30):
        client.post("/chatbot/message", json={"text": "hello"}, headers={"Authorization": "Bearer mocktoken"})
    
    response = client.post("/chatbot/message", json={"text": "hello"}, headers={"Authorization": "Bearer mocktoken"})
    assert response.status_code == 429
