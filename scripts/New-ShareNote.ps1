param(
    [string]$Title = "Untitled note",
    [string]$NotesDir = "notes"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$targetDir = Join-Path $root $NotesDir
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

function New-RandomHexName {
    $bytes = [byte[]]::new(16)
    [System.Security.Cryptography.RandomNumberGenerator]::Fill($bytes)
    return (($bytes | ForEach-Object { $_.ToString("x2") }) -join "")
}

do {
    $name = "$(New-RandomHexName).md"
    $path = Join-Path $targetDir $name
} while (Test-Path -LiteralPath $path)

$createdAt = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
$content = @"
# $Title

Created: $createdAt

"@

Set-Content -LiteralPath $path -Value $content -Encoding UTF8NoBOM

$path
