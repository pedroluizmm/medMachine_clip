from __future__ import annotations

from .clips_runner import read_demo_cases_output
from .schemas import DemoCase, Exposure


def get_demo_cases() -> list[DemoCase]:
    lines = [line.strip() for line in read_demo_cases_output().splitlines()]
    start = lines.index("@@DEMO_CASES_START")
    end = lines.index("@@DEMO_CASES_END")
    cases: dict[str, dict] = {}
    for line in lines[start + 1 : end]:
        if not line:
            continue
        parts = line.split("|")
        kind = parts[0]
        name = parts[1]
        entry = cases.setdefault(name, {"name": name, "symptoms": [], "history": [], "exposure": None, "phase": None})
        if kind == "PATIENT":
            entry["temperature"] = float(parts[2])
            entry["joint_pain"] = int(parts[3])
        elif kind == "SYMPTOM":
            entry["symptoms"].append(parts[2])
        elif kind == "HISTORY":
            entry["history"].append(parts[2])
        elif kind == "EXPOSURE":
            entry["exposure"] = Exposure(type=parts[2], value=parts[3])
        elif kind == "PHASE":
            entry["phase"] = parts[2]
    return [
        DemoCase(
            id=f"demo-{name.lower()}",
            name=data["name"],
            temperature=data["temperature"],
            joint_pain=data["joint_pain"],
            symptoms=data["symptoms"],
            history=data["history"],
            exposure=data["exposure"],
            phase=data["phase"],
        )
        for name, data in cases.items()
    ]
