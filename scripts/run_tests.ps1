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
$Entry = Join-Path $ProjectRoot "clips\tests_cli.clp"

Push-Location $ProjectRoot
try {
    $Output = & $ClipsExe -f2 $Entry 2>&1
    $Output | ForEach-Object { Write-Host $_ }
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
    if ($Output -match "\[FALHOU\]" -or $Output -match "TESTES REPROVADOS: [1-9]") {
        exit 1
    }
}
finally {
    Pop-Location
}
