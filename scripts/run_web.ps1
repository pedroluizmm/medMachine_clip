$ErrorActionPreference = "Stop"

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$ApiScript = Join-Path $ProjectRoot "scripts\run_api.ps1"
$FrontScript = Join-Path $ProjectRoot "scripts\run_front.ps1"
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

$ClipsExe = Resolve-ClipsExe
if (-not $ClipsExe) {
    Write-Error "CLIPS nao encontrado.`n`nVerifique CLIPS_EXE em .env.local.`nCaminho esperado:`n$DefaultClips"
}
$env:CLIPS_EXE = $ClipsExe

$ApiHost = if ($env:API_HOST) { $env:API_HOST } else { "127.0.0.1" }
$ApiPort = if ($env:API_PORT) { $env:API_PORT } else { "8000" }
$FrontHost = if ($env:FRONT_HOST) { $env:FRONT_HOST } else { "127.0.0.1" }
$FrontPort = if ($env:FRONT_PORT) { $env:FRONT_PORT } else { "5173" }

Start-Process powershell -WindowStyle Normal -ArgumentList "-NoExit", "-ExecutionPolicy", "Bypass", "-Command", "`$Host.UI.RawUI.WindowTitle='AV3 IA - API FastAPI'; & '$ApiScript'"
Start-Process powershell -WindowStyle Normal -ArgumentList "-NoExit", "-ExecutionPolicy", "Bypass", "-Command", "`$Host.UI.RawUI.WindowTitle='AV3 IA - Front Vite'; & '$FrontScript'"

Write-Host "CLIPS encontrado."
Write-Host "API:   http://$ApiHost`:$ApiPort"
Write-Host "Front: http://$FrontHost`:$FrontPort"
