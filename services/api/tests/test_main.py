import pytest
from fastapi.testclient import TestClient
import sys
import os

# Add the parent directory to sys.path so 'main' can be imported
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

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
    # Rapid requests to trigger rate limit
    # Using the chatbot endpoint for testing rate limit
    for _ in range(30):
        client.post("/chatbot/message", json={"text": "hello"})
    
    response = client.post("/chatbot/message", json={"text": "hello"})
    assert response.status_code == 429
