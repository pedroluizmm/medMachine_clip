from fastapi.testclient import TestClient

from app import main
from app.output_parser import ParsedClipsOutput


client = TestClient(main.app)


def test_options_endpoint():
    response = client.get("/api/options")
    assert response.status_code == 200
    body = response.json()
    assert body["temperature"]["min"] == 35.0
    assert any(item["value"] == "dor-no-corpo" for item in body["symptoms"])


def test_health_endpoint_mocked(monkeypatch):
    monkeypatch.setattr(main, "run_health_check", lambda: (True, "CLIPSDOS.exe"))
    response = client.get("/api/health")
    assert response.status_code == 200
    assert response.json()["clips"]["available"] is True


def test_analyze_endpoint_with_mocked_subprocess(monkeypatch):
    def fake_analyze(payload, request_id, patient_id):
        return ParsedClipsOutput(
            temperature_intensity="moderada",
            joint_pain_intensity="moderada",
            clinical_suspicions=["dengue"],
            epidemiological_links=["dengue"],
            reinforced_suspicions=["dengue"],
            alerts=[{"type": "sinal-alarme-dengue", "level": "vermelho", "justification": "Dor abdominal."}],
            inference_steps=[{"stage": "alerta", "rule": "alerta-sinal-alarme-dengue", "title": "Alerta", "detail": "Dor abdominal."}],
        )

    monkeypatch.setattr(main, "new_request_id", lambda: "a1b2c3d4-1111-2222-3333-444455556666")
    monkeypatch.setattr(main, "analyze_with_clips", fake_analyze)
    response = client.post(
        "/api/analyze",
        json={
            "name": "Carlos Silva",
            "temperature": 38.7,
            "joint_pain": 5,
            "symptoms": ["dor-no-corpo", "dor-retrorbital", "dor-abdominal"],
            "history": [],
            "exposure": {"type": "viagem", "value": "area-endemica-dengue"},
            "phase": "critica",
        },
    )

    assert response.status_code == 200
    body = response.json()
    assert body["patient"]["id"] == "patient-a1b2c3d4"
    assert body["clinical_suspicions"] == ["dengue"]
    assert body["alerts"][0]["level"] == "vermelho"


def test_analyze_rejects_invalid_symptom():
    response = client.post(
        "/api/analyze",
        json={"name": "Teste", "temperature": 38.0, "joint_pain": 1, "symptoms": ["invalido"]},
    )
    assert response.status_code == 422


def test_analyze_rejects_invalid_exposure_pair():
    response = client.post(
        "/api/analyze",
        json={
            "name": "Teste",
            "temperature": 38.0,
            "joint_pain": 1,
            "exposure": {"type": "viagem", "value": "aedes"},
        },
    )
    assert response.status_code == 422


def test_demo_cases_endpoint():
    response = client.get("/api/demo-cases")
    assert response.status_code == 200
    body = response.json()
    assert len(body) == 4
    assert {item["name"] for item in body} == {"Joao", "Maria", "Ana", "Lucia"}
