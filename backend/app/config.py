from __future__ import annotations

import os
import shutil
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parents[2]
CLIPS_DIR = PROJECT_ROOT / "clips"
RUNTIME_TMP_DIR = PROJECT_ROOT / "runtime" / "tmp"
EXPORTS_ROOT = PROJECT_ROOT / "runtime" / "exports" / "react-generated"
DEFAULT_CLIPS_EXE = Path(r"C:\Program Files\SSS\CLIPS 6.4.2\CLIPSDOS.exe")
CLIPS_TIMEOUT_SECONDS = 10


def resolve_clips_executable() -> str | None:
    env_path = os.environ.get("CLIPS_EXE")
    if env_path and Path(env_path).is_file():
        return env_path

    path_command = shutil.which("CLIPSDOS.exe")
    if path_command:
        return path_command

    if DEFAULT_CLIPS_EXE.is_file():
        return str(DEFAULT_CLIPS_EXE)

    return None


def clips_path(path: Path) -> str:
    return path.resolve().as_posix()
