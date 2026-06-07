from __future__ import annotations

import shutil
import subprocess
import uuid
from pathlib import Path

from .config import CLIPS_DIR, CLIPS_TIMEOUT_SECONDS, RUNTIME_TMP_DIR, clips_path, resolve_clips_executable
from .facts_builder import build_dynamic_facts
from .output_parser import ParsedClipsOutput, parse_structured_output
from .schemas import AnalyzeRequest


class ClipsUnavailableError(RuntimeError):
    pass


class ClipsExecutionError(RuntimeError):
    pass


def run_health_check() -> tuple[bool, str | None]:
    executable = resolve_clips_executable()
    if executable is None:
        return False, None
    try:
        completed = subprocess.run(
            [executable, "-f2"],
            input="(exit)\n",
            capture_output=True,
            text=True,
            timeout=5,
        )
    except (OSError, subprocess.TimeoutExpired):
        return False, executable
    return completed.returncode == 0, executable


def analyze_with_clips(request: AnalyzeRequest, request_id: str, patient_id: str) -> ParsedClipsOutput:
    executable = resolve_clips_executable()
    if executable is None:
        raise ClipsUnavailableError("CLIPS nao encontrado")

    request_dir = RUNTIME_TMP_DIR / request_id
    facts_file = request_dir / "input_facts.clp"
    run_file = request_dir / "run.clp"
    request_dir.mkdir(parents=True, exist_ok=True)

    try:
        facts_file.write_text(build_dynamic_facts(patient_id, request), encoding="utf-8")
        run_file.write_text(_build_run_file(facts_file), encoding="utf-8")

        completed = subprocess.run(
            [executable, "-f2", str(run_file)],
            cwd=str(CLIPS_DIR.parent),
            capture_output=True,
            text=True,
            timeout=CLIPS_TIMEOUT_SECONDS,
        )
        if completed.returncode != 0:
            raise ClipsExecutionError("CLIPS retornou erro ao executar a analise")
        return parse_structured_output(completed.stdout, patient_id)
    except subprocess.TimeoutExpired as exc:
        raise ClipsExecutionError("Tempo limite excedido ao executar o CLIPS") from exc
    finally:
        shutil.rmtree(request_dir, ignore_errors=True)


def analyze_facts_file_with_clips(facts_file: Path, request_id: str, patient_id: str) -> ParsedClipsOutput:
    executable = resolve_clips_executable()
    if executable is None:
        raise ClipsUnavailableError("CLIPS nao encontrado")

    request_dir = RUNTIME_TMP_DIR / request_id
    run_file = request_dir / "run.clp"
    request_dir.mkdir(parents=True, exist_ok=True)
    try:
        run_file.write_text(_build_run_file(facts_file), encoding="utf-8")
        completed = subprocess.run(
            [executable, "-f2", str(run_file)],
            cwd=str(CLIPS_DIR.parent),
            capture_output=True,
            text=True,
            timeout=CLIPS_TIMEOUT_SECONDS,
        )
        if completed.returncode != 0:
            raise ClipsExecutionError("CLIPS retornou erro ao reexecutar o caso salvo")
        return parse_structured_output(completed.stdout, patient_id)
    except subprocess.TimeoutExpired as exc:
        raise ClipsExecutionError("Tempo limite excedido ao executar o CLIPS") from exc
    finally:
        shutil.rmtree(request_dir, ignore_errors=True)


def read_demo_cases_output() -> str:
    executable = resolve_clips_executable()
    if executable is None:
        raise ClipsUnavailableError("CLIPS nao encontrado")
    completed = subprocess.run(
        [executable, "-f2", str(CLIPS_DIR / "output_demo_cases.clp")],
        cwd=str(CLIPS_DIR.parent),
        capture_output=True,
        text=True,
        timeout=CLIPS_TIMEOUT_SECONDS,
    )
    if completed.returncode != 0:
        raise ClipsExecutionError("CLIPS retornou erro ao ler casos demo")
    return completed.stdout


def new_request_id() -> str:
    return str(uuid.uuid4())


def _build_run_file(facts_file: Path) -> str:
    files = [
        CLIPS_DIR / "templates.clp",
        facts_file,
        CLIPS_DIR / "rules_classification.clp",
        CLIPS_DIR / "rules_epidemiology.clp",
        CLIPS_DIR / "rules_suspicion.clp",
        CLIPS_DIR / "rules_risk.clp",
        CLIPS_DIR / "explanation.clp",
        CLIPS_DIR / "output_structured.clp",
    ]
    lines = ["(clear)"]
    lines.extend(f'(batch* "{clips_path(path)}")' for path in files)
    lines.extend(["(reset)", "(run)", "(imprimir-resultado-estruturado)", "(exit)"])
    return "\n".join(lines) + "\n"
