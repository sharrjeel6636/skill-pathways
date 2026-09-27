import pytest
from fastapi.testclient import TestClient
from main import app
from unittest.mock import patch
import time

client = TestClient(app)

def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}

def test_unauthorized_access():
    # Accessing protected endpoint without token
    response = client.get("/dashboard/user123")
    assert response.status_code == 401

def test_invalid_token():
    # Accessing protected endpoint with invalid token
    response = client.get("/dashboard/user123", headers={"Authorization": "Bearer invalidtoken"})
    assert response.status_code == 401

def test_rate_limit():
    # Rapid requests to trigger rate limit (mocking time if needed, 
    # but 30 requests is small enough to hit if we call it quickly)
    # Using the chatbot endpoint for testing rate limit
    for _ in range(30):
        client.post("/chatbot/message", json={"text": "hello"})
    
    response = client.post("/chatbot/message", json={"text": "hello"})
    assert response.status_code == 429
