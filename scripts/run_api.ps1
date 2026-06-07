$ErrorActionPreference = "Stop"

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$BackendDir = Join-Path $ProjectRoot "backend"
$PythonExe = Join-Path $BackendDir ".venv\Scripts\python.exe"
$DefaultClips = "C:\Program Files\SSS\CLIPS 6.4.2\CLIPSDOS.exe"

. (Join-Path $PSScriptRoot "load_env.ps1")

function Resolve-ClipsExe {
    if ($env:CLIPS_EXE -and (Test-Path -LiteralPath $env:CLIPS_EXE -PathType Leaf)) {
        return $env:CLIPS_EXE
    }

    $command = Get-Command CLIPSDOS.exe -ErrorAction SilentlyContinue
    if ($command -and (Test-Path -LiteralPath $command.Source -PathType Leaf)) {
        return $command.Source
    }

    if (Test-Path -LiteralPath $DefaultClips -PathType Leaf) {
        return $DefaultClips
    }

    return $null
}

if (-not (Test-Path $PythonExe)) {
    Write-Error "Ambiente virtual nao encontrado. Execute .\scripts\setup_web.ps1 primeiro."
}

$ClipsExe = Resolve-ClipsExe
if (-not $ClipsExe) {
    Write-Error "CLIPS nao encontrado.`n`nVerifique CLIPS_EXE em .env.local.`nCaminho esperado:`n$DefaultClips"
}
$env:CLIPS_EXE = $ClipsExe

$ApiHost = if ($env:API_HOST) { $env:API_HOST } else { "127.0.0.1" }
$ApiPort = if ($env:API_PORT) { $env:API_PORT } else { "8000" }

Push-Location $BackendDir
try {
    & $PythonExe -m uvicorn app.main:app --host $ApiHost --port $ApiPort
}
finally {
    Pop-Location
}
