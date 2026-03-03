# PowerShell helper to compile Asymptote drawings
# Usage: .\build-asy.ps1 [-File <filename.asy>] [-NoView]

param(
    [string]$File = "fig.asy",
    [switch]$NoView
)

$cwd = Get-Location
if (-not (Test-Path $File)) {
    Write-Error "Asymptote file '$File' not found in $cwd"
    exit 1
}

$flag = ""
if ($NoView) { $flag = "-noView" }

Write-Host "Building $File..." -ForegroundColor Cyan
asy -f pdf $flag $File

if ($LASTEXITCODE -ne 0) {
    Write-Error "asy failed (exit code $LASTEXITCODE)"
} else {
    Write-Host "Done: $(Get-Item ($File -replace '\.asy$','.pdf')).FullName" -ForegroundColor Green
}
