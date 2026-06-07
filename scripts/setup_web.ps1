$ErrorActionPreference = "Stop"

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$BackendDir = Join-Path $ProjectRoot "backend"
$FrontendDir = Join-Path $ProjectRoot "frontend"
$VenvDir = Join-Path $BackendDir ".venv"
$EnvExample = Join-Path $ProjectRoot ".env.example"
$EnvLocal = Join-Path $ProjectRoot ".env.local"
$DefaultClips = "C:\Program Files\SSS\CLIPS 6.4.2\CLIPSDOS.exe"

if (-not (Test-Path -LiteralPath $EnvLocal -PathType Leaf)) {
    if (Test-Path -LiteralPath $DefaultClips -PathType Leaf) {
        @"
CLIPS_EXE=$DefaultClips
API_HOST=127.0.0.1
API_PORT=8000
FRONT_HOST=127.0.0.1
FRONT_PORT=5173
"@ | Set-Content -LiteralPath $EnvLocal -Encoding UTF8
        Write-Host ".env.local criado com o caminho padrao do CLIPS."
    }
    else {
        Copy-Item -LiteralPath $EnvExample -Destination $EnvLocal
        Write-Host ".env.local criado a partir de .env.example. Corrija CLIPS_EXE se necessario."
    }
}

. (Join-Path $PSScriptRoot "load_env.ps1")

if (-not ($env:CLIPS_EXE -and (Test-Path -LiteralPath $env:CLIPS_EXE -PathType Leaf))) {
    Write-Host "Aviso: CLIPS_EXE em .env.local nao aponta para um arquivo valido."
}

if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Error "Python nao encontrado. Instale Python 3 e tente novamente."
}

if (-not (Test-Path $VenvDir)) {
    python -m venv $VenvDir
}

$PythonExe = Join-Path $VenvDir "Scripts\python.exe"
& $PythonExe -m pip install --upgrade pip
& $PythonExe -m pip install -r (Join-Path $BackendDir "requirements.txt")

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Error "Node.js nao encontrado. Instale Node.js e tente novamente."
}

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Error "npm nao encontrado. Instale Node.js com npm e tente novamente."
}

Push-Location $FrontendDir
try {
    npm install
}
finally {
    Pop-Location
}

Write-Host "Ambiente web configurado."
Write-Host "O CLIPS nao foi instalado automaticamente."
Write-Host "Para execucoes futuras, use .\scripts\run_web.ps1."
