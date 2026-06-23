param(
    [Parameter(Mandatory = $true)]
    [string]$Path,
    [string]$PageBaseUrl = "https://nestorhuang.github.io/ShareNotes"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$resolved = Resolve-Path -LiteralPath $Path
$source = Get-Item -LiteralPath $resolved

if ($source.Extension -ne ".md") {
    throw "Only Markdown files can be protected: $($source.FullName)"
}

if ($source.BaseName -match "^[0-9a-f]{32}$") {
    $target = $source
} else {
    function New-RandomHexName {
        $bytes = [byte[]]::new(16)
        [System.Security.Cryptography.RandomNumberGenerator]::Fill($bytes)
        return (($bytes | ForEach-Object { $_.ToString("x2") }) -join "")
    }

    do {
        $name = "$(New-RandomHexName).md"
        $targetPath = Join-Path $source.DirectoryName $name
    } while (Test-Path -LiteralPath $targetPath)

    Move-Item -LiteralPath $source.FullName -Destination $targetPath
    $target = Get-Item -LiteralPath $targetPath
}

$relativePath = Resolve-Path -LiteralPath $target.FullName -Relative
$repoPath = $relativePath.TrimStart(".", "\", "/").Replace("\", "/")
$pagePath = [System.IO.Path]::ChangeExtension($repoPath, ".html")
$segments = $pagePath.Split("/") | ForEach-Object {
    [System.Uri]::EscapeDataString($_)
}
$url = "$($PageBaseUrl.TrimEnd("/"))/$($segments -join "/")"

[pscustomobject]@{
    Path = $target.FullName
    Url = $url
}
