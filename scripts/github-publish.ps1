param(
    [string]$RepoName = "address-book-cangjie",
    [ValidateSet("public", "private", "internal")]
    [string]$Visibility = "public"
)

$ErrorActionPreference = "Stop"

$toolPaths = @(
    "E:\tools\PortableGit\cmd",
    "E:\tools\PortableGit\usr\bin",
    "E:\tools\gh\bin"
)

foreach ($toolPath in $toolPaths) {
    if ((Test-Path $toolPath) -and ($env:Path -notlike "*$toolPath*")) {
        $env:Path = "$toolPath;$env:Path"
    }
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "git command was not found. Please restart PowerShell or check PATH."
}

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    throw "gh command was not found. Please restart PowerShell or check PATH."
}

gh auth status | Out-Null

$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

$hasRemote = git remote | Where-Object { $_ -eq "origin" }
if (-not $hasRemote) {
    gh repo create $RepoName --source . --remote origin --push "--$Visibility"
} else {
    git push -u origin main
}

Write-Host ""
Write-Host "Publish finished."
gh repo view --web
