from pathlib import Path

from app.case_exporter import export_case, slugify
from app.saved_cases import list_saved_cases, read_case_detail
from app.schemas import AnalyzeRequest, Exposure, SaveCaseRequest


def _payload(name: str = "Lucia Araujo") -> SaveCaseRequest:
    return SaveCaseRequest(
        request_id="req-1",
        patient=AnalyzeRequest(
            name=name,
            temperature=38.7,
            joint_pain=5,
            symptoms=["dor-no-corpo", "dor-retrorbital", "dor-abdominal"],
            exposure=Exposure(type="viagem", value="area-endemica-dengue"),
            phase="critica",
        ),
        analysis_summary={"reinforced_suspicions": ["dengue"], "alerts": ["sinal-alarme-dengue"]},
    )


def test_slugify_accents_and_spaces():
    assert slugify("Lucia Araujo") == "lucia-araujo"


def test_export_case_writes_initial_facts_only(tmp_path: Path):
    summary = export_case(_payload(), tmp_path)
    path = tmp_path / summary.filename
    content = path.read_text(encoding="utf-8")

    assert summary.id.startswith("case-")
    assert "source: react-form" in content
    assert "display-name: Lucia Araujo" in content
    assert "(paciente" in content
    assert "(sintoma" in content
    assert "(alerta" not in content
    assert "(suspeita-reforcada" not in content


def test_list_and_detail_ignore_invalid_files(tmp_path: Path):
    export_case(_payload("Carlos Silva"), tmp_path)
    (tmp_path / "invalid.clp").write_text("(deffacts lixo)", encoding="utf-8")

    cases = list_saved_cases(tmp_path)
    detail = read_case_detail(cases[0].id, tmp_path)

    assert len(cases) == 1
    assert detail.patient.name == "Carlos Silva"
    assert detail.patient.exposure is not None
