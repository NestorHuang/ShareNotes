param(
    [string]$Title = "Untitled note",
    [string]$NotesDir = "notes",
    [string]$PageBaseUrl = "https://nestorhuang.github.io/ShareNotes"
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
$frontMatterTitle = $Title.Replace("'", "''")
$content = @"
---
title: '$frontMatterTitle'
---

# $Title

Created: $createdAt

"@

Set-Content -LiteralPath $path -Value $content -Encoding UTF8NoBOM

$relativePath = Resolve-Path -LiteralPath $path -Relative
$repoPath = $relativePath.TrimStart(".", "\", "/").Replace("\", "/")
$pagePath = [System.IO.Path]::ChangeExtension($repoPath, ".html")
$segments = $pagePath.Split("/") | ForEach-Object {
    [System.Uri]::EscapeDataString($_)
}
$url = "$($PageBaseUrl.TrimEnd("/"))/$($segments -join "/")"

[pscustomobject]@{
    Path = $path
    Url = $url
}
