from __future__ import annotations

from dataclasses import dataclass, field


class StructuredOutputError(ValueError):
    pass


@dataclass
class ParsedClipsOutput:
    temperature_intensity: str | None = None
    joint_pain_intensity: str | None = None
    clinical_suspicions: list[str] = field(default_factory=list)
    epidemiological_links: list[str] = field(default_factory=list)
    reinforced_suspicions: list[str] = field(default_factory=list)
    alerts: list[dict[str, str]] = field(default_factory=list)
    inference_steps: list[dict[str, str]] = field(default_factory=list)


def parse_structured_output(stdout: str, patient_id: str) -> ParsedClipsOutput:
    lines = [line.strip() for line in stdout.splitlines()]
    try:
        start = lines.index("@@RESULT_START")
        end = lines.index("@@RESULT_END")
    except ValueError as exc:
        raise StructuredOutputError("marcadores de resultado ausentes") from exc

    if end <= start:
        raise StructuredOutputError("marcadores de resultado invalidos")

    parsed = ParsedClipsOutput()
    for line in lines[start + 1 : end]:
        if not line:
            continue
        parts = line.split("|")
        kind = parts[0]
        if len(parts) < 3 or parts[1] != patient_id:
            continue

        if kind == "TEMPERATURE_INTENSITY" and len(parts) == 3:
            parsed.temperature_intensity = parts[2]
        elif kind == "JOINT_PAIN_INTENSITY" and len(parts) == 3:
            parsed.joint_pain_intensity = parts[2]
        elif kind == "CLINICAL_SUSPICION" and len(parts) == 3:
            parsed.clinical_suspicions.append(parts[2])
        elif kind == "EPIDEMIOLOGICAL_LINK" and len(parts) == 3:
            parsed.epidemiological_links.append(parts[2])
        elif kind == "REINFORCED_SUSPICION" and len(parts) == 3:
            parsed.reinforced_suspicions.append(parts[2])
        elif kind == "ALERT" and len(parts) >= 5:
            parsed.alerts.append(
                {"type": parts[2], "level": parts[3], "justification": "|".join(parts[4:])}
            )
        elif kind == "EXPLANATION" and len(parts) >= 6:
            parsed.inference_steps.append(
                {
                    "stage": parts[2],
                    "rule": parts[3],
                    "title": parts[4],
                    "detail": "|".join(parts[5:]),
                }
            )

    return parsed
