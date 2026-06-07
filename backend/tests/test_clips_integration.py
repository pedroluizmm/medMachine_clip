import pytest

from app.clips_runner import analyze_with_clips, new_request_id, run_health_check
from app.normalizer import make_patient_id
from app.schemas import AnalyzeRequest, Exposure


def test_real_clips_integration_when_available():
    available, _ = run_health_check()
    if not available:
        pytest.skip("CLIPS_EXE indisponivel para teste de integracao real")

    request_id = new_request_id()
    patient_id = make_patient_id(request_id)
    request = AnalyzeRequest(
        name="Carlos",
        temperature=38.7,
        joint_pain=5,
        symptoms=["dor-no-corpo", "dor-retrorbital", "dor-abdominal"],
        exposure=Exposure(type="viagem", value="area-endemica-dengue"),
        phase="critica",
    )

    parsed = analyze_with_clips(request, request_id, patient_id)

    assert parsed.temperature_intensity == "moderada"
    assert "dengue" in parsed.clinical_suspicions
    assert "dengue" in parsed.reinforced_suspicions
    assert any(alert["level"] == "vermelho" for alert in parsed.alerts)
