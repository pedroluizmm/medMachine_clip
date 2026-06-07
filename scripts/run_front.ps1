$ErrorActionPreference = "Stop"

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$FrontendDir = Join-Path $ProjectRoot "frontend"

. (Join-Path $PSScriptRoot "load_env.ps1")

if (-not (Test-Path (Join-Path $FrontendDir "node_modules"))) {
    Write-Error "Dependencias do front-end nao encontradas. Execute .\scripts\setup_web.ps1 primeiro."
}

$FrontHost = if ($env:FRONT_HOST) { $env:FRONT_HOST } else { "127.0.0.1" }
$FrontPort = if ($env:FRONT_PORT) { $env:FRONT_PORT } else { "5173" }

Push-Location $FrontendDir
try {
    npm run dev -- "--host=$FrontHost" "--port=$FrontPort"
}
finally {
    Pop-Location
}
