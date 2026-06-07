from app.facts_builder import build_dynamic_facts
from app.schemas import AnalyzeRequest, Exposure


def test_build_dynamic_facts_with_optional_values():
    request = AnalyzeRequest(
        name="Carlos Silva",
        temperature=38.7,
        joint_pain=8,
        symptoms=["dor-no-corpo", "dor-retrorbital"],
        history=["gestante"],
        exposure=Exposure(type="viagem", value="area-endemica-dengue"),
        phase="critica",
    )

    facts = build_dynamic_facts("patient-a1b2c3d4", request)

    assert "(nome patient-a1b2c3d4)" in facts
    assert "(temperatura 38.7)" in facts
    assert "(dor-articular 8)" in facts
    assert "(nome dor-no-corpo)" in facts
    assert "(condicao gestante)" in facts
    assert "(tipo viagem)" in facts
    assert "(valor area-endemica-dengue)" in facts
    assert "(nome critica)" in facts


def test_build_dynamic_facts_omits_empty_optional_values():
    request = AnalyzeRequest(name="Pedro", temperature=36.8, joint_pain=1)

    facts = build_dynamic_facts("patient-12345678", request)

    assert "(paciente" in facts
    assert "(sintoma" not in facts
    assert "(historico" not in facts
    assert "(exposicao" not in facts
    assert "(fase" not in facts
