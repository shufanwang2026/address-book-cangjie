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

Write-Host "This script will open GitHub login in your browser."
Write-Host "After login finishes, you can run scripts\\github-publish.ps1."

gh auth login --hostname github.com --git-protocol https --web

Write-Host ""
Write-Host "Login status:"
gh auth status
