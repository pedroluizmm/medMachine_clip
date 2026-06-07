from __future__ import annotations

import re
from pathlib import Path

from .config import EXPORTS_ROOT
from .schemas import AnalyzeRequest, Exposure, PatientResponse, SavedCaseDetail, SavedCaseSummary

MAX_CASE_SIZE = 256_000


def list_saved_cases(exports_root: Path = EXPORTS_ROOT) -> list[SavedCaseSummary]:
    exports_root.mkdir(parents=True, exist_ok=True)
    cases: list[SavedCaseSummary] = []
    for path in exports_root.glob("*.clp"):
        try:
            cases.append(read_saved_case(path, include_content=False, exports_root=exports_root))
        except Exception as exc:
            print(f"Ignorando caso salvo invalido {path.name}: {exc}")
    return sorted(cases, key=lambda item: item.created_at, reverse=True)


def get_case_path(case_id: str, exports_root: Path = EXPORTS_ROOT) -> Path:
    _validate_case_id(case_id)
    for path in exports_root.glob("*.clp"):
        try:
            metadata = _read_metadata(path)
        except Exception:
            continue
        if metadata.get("case-id") == case_id:
            return _assert_safe_path(path, exports_root)
    raise FileNotFoundError(case_id)


def read_case_detail(case_id: str, exports_root: Path = EXPORTS_ROOT) -> SavedCaseDetail:
    return read_saved_case(get_case_path(case_id, exports_root), include_content=True, exports_root=exports_root)


def read_saved_case(path: Path, include_content: bool, exports_root: Path = EXPORTS_ROOT) -> SavedCaseDetail:
    path = _assert_safe_path(path, exports_root)
    if path.stat().st_size > MAX_CASE_SIZE:
        raise ValueError("arquivo muito grande")
    content = path.read_text(encoding="utf-8")
    metadata = _parse_metadata(content)
    if metadata.get("source") != "react-form":
        raise ValueError("origem invalida")
    patient = _parse_patient(content, metadata["display-name"])
    return SavedCaseDetail(
        id=metadata["case-id"],
        display_name=metadata["display-name"],
        created_at=metadata["created-at"],
        filename=path.name,
        source=metadata["source"],
        reinforced_suspicions=_split_summary(metadata.get("reinforced-suspicions", "")),
        alerts=_split_summary(metadata.get("alerts", "")),
        download_url=f"/api/saved-cases/{metadata['case-id']}/download",
        patient=patient,
        content=content if include_content else "",
    )


def delete_saved_case(case_id: str, exports_root: Path = EXPORTS_ROOT) -> None:
    path = get_case_path(case_id, exports_root)
    path.unlink()


def _read_metadata(path: Path) -> dict[str, str]:
    return _parse_metadata(path.read_text(encoding="utf-8"))


def _parse_metadata(content: str) -> dict[str, str]:
    metadata: dict[str, str] = {}
    for line in content.splitlines():
        if not line.startswith(";"):
            continue
        body = line[1:].strip()
        if ":" in body:
            key, value = body.split(":", 1)
            metadata[key.strip()] = value.strip()
    required = {"export-version", "source", "case-id", "display-name", "created-at", "filename"}
    missing = required - metadata.keys()
    if missing:
        raise ValueError(f"metadados ausentes: {missing}")
    _validate_case_id(metadata["case-id"])
    return metadata


def _parse_patient(content: str, display_name: str) -> PatientResponse:
    patient_match = re.search(r"\(paciente\s+\(nome\s+([^)]+)\)\s+\(temperatura\s+([0-9.]+)\)\s+\(dor-articular\s+([0-9]+)\)", content, re.S)
    if not patient_match:
        raise ValueError("paciente ausente")
    patient_id = patient_match.group(1)
    symptoms = re.findall(r"\(sintoma\s+\(paciente\s+" + re.escape(patient_id) + r"\)\s+\(nome\s+([^)]+)\)", content, re.S)
    history = re.findall(r"\(historico\s+\(paciente\s+" + re.escape(patient_id) + r"\)\s+\(condicao\s+([^)]+)\)", content, re.S)
    exposure_match = re.search(r"\(exposicao\s+\(paciente\s+" + re.escape(patient_id) + r"\)\s+\(tipo\s+([^)]+)\)\s+\(valor\s+([^)]+)\)", content, re.S)
    phase_match = re.search(r"\(fase\s+\(paciente\s+" + re.escape(patient_id) + r"\)\s+\(nome\s+([^)]+)\)", content, re.S)
    exposure = Exposure(type=exposure_match.group(1), value=exposure_match.group(2)) if exposure_match else None
    request = AnalyzeRequest(name=display_name, temperature=float(patient_match.group(2)), joint_pain=int(patient_match.group(3)), symptoms=symptoms, history=history, exposure=exposure, phase=phase_match.group(1) if phase_match else None)
    return PatientResponse(id=patient_id, name=request.name, temperature=request.temperature, joint_pain=request.joint_pain, symptoms=request.symptoms, history=request.history, exposure=request.exposure, phase=request.phase)


def _split_summary(value: str) -> list[str]:
    if not value or value in {"nenhum", "nenhuma"}:
        return []
    return [item.strip() for item in value.split(",") if item.strip()]


def _validate_case_id(case_id: str) -> None:
    if not re.fullmatch(r"case-[a-f0-9]{8}", case_id):
        raise ValueError("case_id invalido")


def _assert_safe_path(path: Path, exports_root: Path) -> Path:
    resolved = path.resolve()
    root = exports_root.resolve()
    if root not in resolved.parents or resolved.suffix != ".clp":
        raise ValueError("caminho invalido")
    return resolved
