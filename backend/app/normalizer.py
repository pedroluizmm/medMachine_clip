from __future__ import annotations

import uuid


def make_patient_id(request_id: str | None = None) -> str:
    raw = request_id or str(uuid.uuid4())
    return f"patient-{raw.replace('-', '')[:8]}"
