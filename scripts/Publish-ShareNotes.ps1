param(
    [string]$Message = "",
    [string]$PageBaseUrl = "https://nestorhuang.github.io/ShareNotes"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

function ConvertTo-PageUrl {
    param([string]$RepoPath)

    $normalized = $RepoPath.Replace("\", "/")
    $withoutExtension = [System.IO.Path]::ChangeExtension($normalized, ".html")
    $segments = $withoutExtension.Split("/") | ForEach-Object {
        [System.Uri]::EscapeDataString($_)
    }

    return "$($PageBaseUrl.TrimEnd("/"))/$($segments -join "/")"
}

$markdownFiles = Get-ChildItem -Path (Join-Path $root "notes") -Recurse -File -Filter "*.md" |
    Where-Object { $_.FullName -notmatch "\\\.obsidian\\" }

$unsafeNameFiles = $markdownFiles | Where-Object { $_.BaseName -notmatch "^[0-9a-f]{32}$" }
if ($unsafeNameFiles) {
    Write-Output "Refusing to publish Markdown files with predictable names:"
    foreach ($file in $unsafeNameFiles) {
        Write-Output "  $($file.FullName)"
    }
    Write-Output ""
    Write-Output "Rename each file first, for example:"
    Write-Output "  .\scripts\Protect-ShareNoteName.ps1 -Path `"notes\example.md`""
    exit 1
}

foreach ($file in $markdownFiles) {
    git add -- $file.FullName
}

$stagedDocs = git diff --cached --name-only --diff-filter=AM -- notes |
    Where-Object { $_ -like "*.md" }
if (-not $stagedDocs) {
    Write-Output "No new or modified Markdown notes to publish."
    exit 0
}

if ([string]::IsNullOrWhiteSpace($Message)) {
    $stamp = Get-Date -Format "yyyy-MM-dd HH:mm"
    $Message = "Publish notes $stamp"
}

git commit -m $Message | Write-Output
git push | Write-Output

Write-Output ""
Write-Output "Published URLs:"
foreach ($doc in $stagedDocs) {
    Write-Output (ConvertTo-PageUrl -RepoPath $doc)
}
