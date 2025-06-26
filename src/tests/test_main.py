from fastapi.testclient import TestClient
from src.main import app

client = TestClient(app)

def test_home_redirects_to_docs():
    response = client.get("/", follow_redirects=False)
    assert response.status_code == 307 or response.status_code == 302
    assert response.headers["location"] == "/docs"

def test_glow_check():
    response = client.get("/glow-check")
    assert response.status_code == 200
    assert response.json() == {"blacklight": "ON"}
