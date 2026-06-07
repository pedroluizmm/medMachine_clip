from __future__ import annotations

from .schemas import AnalyzeRequest


def build_dynamic_facts(patient_id: str, request: AnalyzeRequest) -> str:
    lines = [
        "(deffacts entrada-dinamica",
        "    (paciente",
        f"        (nome {patient_id})",
        f"        (temperatura {request.temperature:.1f})",
        f"        (dor-articular {request.joint_pain})",
        "    )",
        "",
    ]

    for symptom in request.symptoms:
        lines.extend(
            [
                "    (sintoma",
                f"        (paciente {patient_id})",
                f"        (nome {symptom})",
                "    )",
                "",
            ]
        )

    for condition in request.history:
        lines.extend(
            [
                "    (historico",
                f"        (paciente {patient_id})",
                f"        (condicao {condition})",
                "    )",
                "",
            ]
        )

    if request.exposure is not None:
        lines.extend(
            [
                "    (exposicao",
                f"        (paciente {patient_id})",
                f"        (tipo {request.exposure.type})",
                f"        (valor {request.exposure.value})",
                "    )",
                "",
            ]
        )

    if request.phase is not None:
        lines.extend(
            [
                "    (fase",
                f"        (paciente {patient_id})",
                f"        (nome {request.phase})",
                "    )",
                "",
            ]
        )

    lines.append(")")
    return "\n".join(lines) + "\n"
