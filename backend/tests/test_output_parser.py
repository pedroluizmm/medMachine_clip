import pytest

from app.output_parser import StructuredOutputError, parse_structured_output


def test_parse_structured_output_with_alerts_and_multiple_links():
    stdout = """
noise
@@RESULT_START
TEMPERATURE_INTENSITY|patient-abcd1234|baixa
JOINT_PAIN_INTENSITY|patient-abcd1234|leve
EPIDEMIOLOGICAL_LINK|patient-abcd1234|dengue
EPIDEMIOLOGICAL_LINK|patient-abcd1234|chikungunya
EPIDEMIOLOGICAL_LINK|patient-abcd1234|zika
ALERT|patient-abcd1234|sinal-alarme-dengue|vermelho|Justificativa
EXPLANATION|patient-abcd1234|alerta|alerta-sinal-alarme-dengue|Alerta|Detalhe
@@RESULT_END
after
"""

    parsed = parse_structured_output(stdout, "patient-abcd1234")

    assert parsed.temperature_intensity == "baixa"
    assert parsed.joint_pain_intensity == "leve"
    assert parsed.epidemiological_links == ["dengue", "chikungunya", "zika"]
    assert parsed.clinical_suspicions == []
    assert parsed.alerts[0]["level"] == "vermelho"
    assert parsed.inference_steps[0]["stage"] == "alerta"


def test_parse_structured_output_requires_markers():
    with pytest.raises(StructuredOutputError):
        parse_structured_output("TEMPERATURE_INTENSITY|patient|baixa", "patient")
