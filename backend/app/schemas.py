from __future__ import annotations

from typing import Literal

from pydantic import BaseModel, Field, field_validator, model_validator


VALID_SYMPTOMS = {
    "dor-no-corpo",
    "dor-retrorbital",
    "dor-abdominal",
    "dor-articular-incapacitante",
    "exantema-com-coceira",
    "conjuntivite",
    "cefaleia-intensa",
    "fotofobia",
}

VALID_HISTORY = {"gestante"}
VALID_PHASES = {"aguda", "critica", "subaguda", "recidiva"}
VALID_EXPOSURES = {
    ("vetor", "aedes"),
    ("vetor", "maruim"),
    ("viagem", "area-endemica-dengue"),
    ("surto-local", "chikungunya"),
}


class Exposure(BaseModel):
    type: Literal["vetor", "viagem", "surto-local"]
    value: str

    @model_validator(mode="after")
    def validate_pair(self) -> "Exposure":
        if (self.type, self.value) not in VALID_EXPOSURES:
            raise ValueError("exposicao invalida")
        return self


class AnalyzeRequest(BaseModel):
    name: str = Field(min_length=1, max_length=80)
    temperature: float = Field(ge=35.0, le=41.5)
    joint_pain: int = Field(ge=0, le=10)
    symptoms: list[str] = Field(default_factory=list)
    history: list[str] = Field(default_factory=list)
    exposure: Exposure | None = None
    phase: str | None = None

    @field_validator("temperature")
    @classmethod
    def validate_temperature_precision(cls, value: float) -> float:
        if round(value, 1) != value:
            raise ValueError("temperatura deve ter no maximo uma casa decimal")
        return value

    @field_validator("symptoms")
    @classmethod
    def validate_symptoms(cls, values: list[str]) -> list[str]:
        invalid = sorted(set(values) - VALID_SYMPTOMS)
        if invalid:
            raise ValueError(f"sintomas invalidos: {', '.join(invalid)}")
        return list(dict.fromkeys(values))

    @field_validator("history")
    @classmethod
    def validate_history(cls, values: list[str]) -> list[str]:
        invalid = sorted(set(values) - VALID_HISTORY)
        if invalid:
            raise ValueError(f"historico invalido: {', '.join(invalid)}")
        return list(dict.fromkeys(values))

    @field_validator("phase")
    @classmethod
    def validate_phase(cls, value: str | None) -> str | None:
        if value is not None and value not in VALID_PHASES:
            raise ValueError("fase invalida")
        return value


class PatientResponse(BaseModel):
    id: str
    name: str
    temperature: float
    joint_pain: int
    symptoms: list[str]
    history: list[str]
    exposure: Exposure | None
    phase: str | None


class AlertResponse(BaseModel):
    type: str
    level: str
    justification: str


class InferenceStep(BaseModel):
    stage: str
    rule: str
    title: str
    detail: str


class EngineInfo(BaseModel):
    name: str = "CLIPS"
    execution: str = "subprocess"
    strategy: str = "encadeamento-para-frente"


class Intensities(BaseModel):
    temperature: str | None = None
    joint_pain: str | None = None


class AnalyzeResponse(BaseModel):
    request_id: str
    patient: PatientResponse
    intensities: Intensities
    clinical_suspicions: list[str]
    epidemiological_links: list[str]
    reinforced_suspicions: list[str]
    alerts: list[AlertResponse]
    inference_steps: list[InferenceStep]
    engine: EngineInfo = Field(default_factory=EngineInfo)


class AnalysisSummary(BaseModel):
    reinforced_suspicions: list[str] = Field(default_factory=list)
    alerts: list[str] = Field(default_factory=list)


class SaveCaseRequest(BaseModel):
    request_id: str = Field(min_length=1, max_length=80)
    patient: AnalyzeRequest
    analysis_summary: AnalysisSummary = Field(default_factory=AnalysisSummary)


class SavedCaseSummary(BaseModel):
    id: str
    display_name: str
    created_at: str
    filename: str
    source: str
    reinforced_suspicions: list[str] = Field(default_factory=list)
    alerts: list[str] = Field(default_factory=list)
    download_url: str | None = None


class SavedCaseDetail(SavedCaseSummary):
    patient: PatientResponse
    content: str


class DemoCase(BaseModel):
    id: str
    name: str
    temperature: float
    joint_pain: int
    symptoms: list[str] = Field(default_factory=list)
    history: list[str] = Field(default_factory=list)
    exposure: Exposure | None = None
    phase: str | None = None
    source: str = "facts_demo.clp"
