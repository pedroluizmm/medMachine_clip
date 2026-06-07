from __future__ import annotations

import os
import re
import unicodedata
import uuid
from datetime import datetime, timezone
from pathlib import Path

from .config import EXPORTS_ROOT
from .facts_builder import build_dynamic_facts
from .normalizer import make_patient_id
from .schemas import SaveCaseRequest, SavedCaseSummary


def slugify(value: str) -> str:
    normalized = unicodedata.normalize("NFKD", value)
    ascii_value = normalized.encode("ascii", "ignore").decode("ascii").lower()
    slug = re.sub(r"[^a-z0-9]+", "-", ascii_value).strip("-")
    return slug[:48] or "caso"


def export_case(payload: SaveCaseRequest, exports_root: Path = EXPORTS_ROOT) -> SavedCaseSummary:
    exports_root.mkdir(parents=True, exist_ok=True)
    now = datetime.now().astimezone()
    short_id = uuid.uuid4().hex[:8]
    case_id = f"case-{short_id}"
    patient_id = make_patient_id(short_id)
    name_slug = slugify(payload.patient.name)
    timestamp = now.strftime("%Y-%m-%d_%H-%M-%S")
    filename = f"{timestamp}_{name_slug}_{short_id}.clp"
    final_path = _safe_export_path(exports_root, filename)
    temp_path = final_path.with_suffix(".tmp")

    content = build_export_content(payload, case_id, patient_id, filename, now)
    if final_path.exists():
        raise FileExistsError("arquivo de exportacao ja existe")

    try:
        temp_path.write_text(content, encoding="utf-8")
        if not temp_path.is_file() or temp_path.stat().st_size == 0:
            raise OSError("arquivo temporario de exportacao invalido")
        os.replace(temp_path, final_path)
    except Exception:
        temp_path.unlink(missing_ok=True)
        raise

    return SavedCaseSummary(
        id=case_id,
        display_name=payload.patient.name,
        created_at=now.isoformat(timespec="seconds"),
        filename=filename,
        source="react-form",
        reinforced_suspicions=payload.analysis_summary.reinforced_suspicions,
        alerts=payload.analysis_summary.alerts,
        download_url=f"/api/saved-cases/{case_id}/download",
    )


def build_export_content(payload: SaveCaseRequest, case_id: str, patient_id: str, filename: str, created_at: datetime) -> str:
    facts = build_dynamic_facts(patient_id, payload.patient).replace("(deffacts entrada-dinamica", f"(deffacts caso-{case_id}")
    reinforced = ", ".join(payload.analysis_summary.reinforced_suspicions) or "nenhuma"
    alerts = ", ".join(payload.analysis_summary.alerts) or "nenhum"
    return "\n".join(
        [
            "; =========================================================",
            "; CASO GERADO PELO FRONT-END REACT",
            "; =========================================================",
            "; export-version: 1",
            "; source: react-form",
            f"; case-id: {case_id}",
            f"; request-id: {payload.request_id}",
            f"; display-name: {payload.patient.name}",
            f"; created-at: {created_at.isoformat(timespec='seconds')}",
            f"; filename: {filename}",
            ";",
            "; Resumo da analise no momento da exportacao:",
            f"; reinforced-suspicions: {reinforced}",
            f"; alerts: {alerts}",
            ";",
            "; Aviso:",
            "; Os resultados acima sao metadados informativos.",
            "; As conclusoes oficiais devem ser recalculadas pelo CLIPS.",
            "; =========================================================",
            "",
            facts.rstrip(),
            "",
        ]
    )


def _safe_export_path(exports_root: Path, filename: str) -> Path:
    if filename != Path(filename).name or not filename.endswith(".clp"):
        raise ValueError("nome de arquivo invalido")
    path = (exports_root / filename).resolve()
    root = exports_root.resolve()
    if root not in path.parents:
        raise ValueError("caminho fora da pasta de exportacao")
    return path
