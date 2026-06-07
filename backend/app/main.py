from __future__ import annotations

from fastapi import FastAPI, HTTPException
from fastapi.responses import FileResponse
from fastapi.middleware.cors import CORSMiddleware

from .clips_runner import (
    ClipsExecutionError,
    ClipsUnavailableError,
    analyze_with_clips,
    analyze_facts_file_with_clips,
    new_request_id,
    run_health_check,
)
from .case_exporter import export_case
from .demo_cases import get_demo_cases
from .normalizer import make_patient_id
from .saved_cases import delete_saved_case, get_case_path, list_saved_cases, read_case_detail
from .schemas import AnalyzeRequest, AnalyzeResponse, Intensities, PatientResponse, SaveCaseRequest
from .schemas import VALID_HISTORY, VALID_PHASES, VALID_SYMPTOMS


app = FastAPI(title="Sistema Especialista de Arboviroses")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173", "http://127.0.0.1:5173"],
    allow_credentials=False,
    allow_methods=["GET", "POST", "DELETE"],
    allow_headers=["*"],
)


@app.get("/api/health")
def health() -> dict:
    available, executable = run_health_check()
    return {"status": "ok" if available else "unavailable", "clips": {"available": available, "executable": executable}}


@app.get("/api/options")
def options() -> dict:
    return {
        "symptoms": [
            {"value": value, "label": _label(value)}
            for value in sorted(VALID_SYMPTOMS)
        ],
        "history": [{"value": value, "label": _label(value)} for value in sorted(VALID_HISTORY)],
        "exposures": [
            {"label": "Exposicao ao Aedes", "type": "vetor", "value": "aedes"},
            {"label": "Exposicao ao maruim", "type": "vetor", "value": "maruim"},
            {"label": "Viagem para area endemica de dengue", "type": "viagem", "value": "area-endemica-dengue"},
            {"label": "Surto local de chikungunya", "type": "surto-local", "value": "chikungunya"},
        ],
        "phases": [{"value": value, "label": _label(value)} for value in sorted(VALID_PHASES)],
        "temperature": {"min": 35.0, "max": 41.5, "step": 0.1},
        "joint_pain": {"min": 0, "max": 10, "step": 1},
    }


@app.get("/api/demo-cases")
def demo_cases() -> list:
    try:
        return get_demo_cases()
    except (ClipsUnavailableError, ClipsExecutionError, ValueError) as exc:
        raise HTTPException(status_code=502, detail="Nao foi possivel carregar os casos demo") from exc


@app.post("/api/analyze", response_model=AnalyzeResponse)
def analyze(payload: AnalyzeRequest) -> AnalyzeResponse:
    request_id = new_request_id()
    patient_id = make_patient_id(request_id)
    try:
        parsed = analyze_with_clips(payload, request_id, patient_id)
    except ClipsUnavailableError as exc:
        raise HTTPException(status_code=503, detail="CLIPS nao encontrado ou indisponivel") from exc
    except ClipsExecutionError as exc:
        raise HTTPException(status_code=502, detail=str(exc)) from exc
    except ValueError as exc:
        raise HTTPException(status_code=502, detail="Saida estruturada invalida do CLIPS") from exc

    return AnalyzeResponse(
        request_id=request_id,
        patient=PatientResponse(id=patient_id, name=payload.name, temperature=payload.temperature, joint_pain=payload.joint_pain, symptoms=payload.symptoms, history=payload.history, exposure=payload.exposure, phase=payload.phase),
        intensities=Intensities(temperature=parsed.temperature_intensity, joint_pain=parsed.joint_pain_intensity),
        clinical_suspicions=parsed.clinical_suspicions,
        epidemiological_links=parsed.epidemiological_links,
        reinforced_suspicions=parsed.reinforced_suspicions,
        alerts=parsed.alerts,
        inference_steps=parsed.inference_steps,
    )


@app.get("/api/saved-cases")
def saved_cases() -> list:
    return list_saved_cases()


@app.post("/api/saved-cases")
def save_case(payload: SaveCaseRequest) -> dict:
    try:
        return export_case(payload).model_dump()
    except Exception as exc:
        raise HTTPException(status_code=500, detail="Nao foi possivel salvar o caso em CLP") from exc


@app.get("/api/saved-cases/{case_id}")
def saved_case_detail(case_id: str) -> dict:
    try:
        return read_case_detail(case_id).model_dump()
    except (FileNotFoundError, ValueError) as exc:
        raise HTTPException(status_code=404, detail="Caso salvo nao encontrado") from exc


@app.get("/api/saved-cases/{case_id}/download")
def download_saved_case(case_id: str) -> FileResponse:
    try:
        path = get_case_path(case_id)
    except (FileNotFoundError, ValueError) as exc:
        raise HTTPException(status_code=404, detail="Caso salvo nao encontrado") from exc
    return FileResponse(path, media_type="application/octet-stream", filename=path.name)


@app.post("/api/saved-cases/{case_id}/analyze", response_model=AnalyzeResponse)
def analyze_saved_case(case_id: str) -> AnalyzeResponse:
    try:
        detail = read_case_detail(case_id)
        request_id = new_request_id()
        parsed = analyze_facts_file_with_clips(get_case_path(case_id), request_id, detail.patient.id)
    except FileNotFoundError as exc:
        raise HTTPException(status_code=404, detail="Caso salvo nao encontrado") from exc
    except (ValueError, ClipsUnavailableError, ClipsExecutionError) as exc:
        raise HTTPException(status_code=502, detail="Nao foi possivel reexecutar o caso salvo") from exc
    return AnalyzeResponse(
        request_id=request_id,
        patient=detail.patient,
        intensities=Intensities(temperature=parsed.temperature_intensity, joint_pain=parsed.joint_pain_intensity),
        clinical_suspicions=parsed.clinical_suspicions,
        epidemiological_links=parsed.epidemiological_links,
        reinforced_suspicions=parsed.reinforced_suspicions,
        alerts=parsed.alerts,
        inference_steps=parsed.inference_steps,
    )


@app.delete("/api/saved-cases/{case_id}")
def remove_saved_case(case_id: str) -> dict:
    try:
        delete_saved_case(case_id)
    except (FileNotFoundError, ValueError) as exc:
        raise HTTPException(status_code=404, detail="Caso salvo nao encontrado") from exc
    return {"deleted": True}


def _label(value: str) -> str:
    return value.replace("-", " ").capitalize()
