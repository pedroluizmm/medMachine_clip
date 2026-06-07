param(
    [string]$Path
)

$ErrorActionPreference = "Stop"

function Import-EnvFile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$EnvPath
    )

    if (-not (Test-Path -LiteralPath $EnvPath -PathType Leaf)) {
        return
    }

    $lineNumber = 0
    foreach ($rawLine in Get-Content -LiteralPath $EnvPath) {
        $lineNumber += 1
        $line = $rawLine.Trim()

        if ($line.Length -eq 0 -or $line.StartsWith("#")) {
            continue
        }

        $separator = $line.IndexOf("=")
        if ($separator -le 0) {
            throw "Arquivo de ambiente malformado em '$EnvPath' na linha $lineNumber."
        }

        $key = $line.Substring(0, $separator).Trim()
        $value = $line.Substring($separator + 1).Trim()

        if ($key -notmatch '^[A-Za-z_][A-Za-z0-9_]*$') {
            throw "Nome de variavel invalido em '$EnvPath' na linha $lineNumber."
        }

        if (($value.StartsWith('"') -and $value.EndsWith('"')) -or ($value.StartsWith("'") -and $value.EndsWith("'"))) {
            if ($value.Length -lt 2) {
                throw "Valor malformado em '$EnvPath' na linha $lineNumber."
            }
            $value = $value.Substring(1, $value.Length - 2)
        }

        Set-Item -Path "Env:$key" -Value $value
    }
}

if ($Path) {
    Import-EnvFile -EnvPath $Path
    return
}

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Import-EnvFile -EnvPath (Join-Path $ProjectRoot ".env")
Import-EnvFile -EnvPath (Join-Path $ProjectRoot ".env.local")
