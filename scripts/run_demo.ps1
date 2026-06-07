$ErrorActionPreference = "Stop"

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$DefaultClips = "C:\Program Files\SSS\CLIPS 6.4.2\CLIPSDOS.exe"

function Resolve-ClipsExe {
    if ($env:CLIPS_EXE -and (Test-Path -LiteralPath $env:CLIPS_EXE -PathType Leaf)) {
        return $env:CLIPS_EXE
    }

    $command = Get-Command CLIPSDOS.exe -ErrorAction SilentlyContinue
    if ($command) {
        return $command.Source
    }

    if (Test-Path -LiteralPath $DefaultClips -PathType Leaf) {
        return $DefaultClips
    }

    Write-Error "CLIPS nao encontrado.`n`nDefina a variavel CLIPS_EXE com o caminho completo para CLIPSDOS.exe`nou instale o CLIPS 6.4.2."
}

$ClipsExe = Resolve-ClipsExe
$Entry = Join-Path $ProjectRoot "clips\main_cli.clp"

Push-Location $ProjectRoot
try {
    & $ClipsExe -f2 $Entry
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}
finally {
    Pop-Location
}
