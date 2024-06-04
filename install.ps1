# Set the execution policy to allow scripts to run
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted

# Install latest Powershell version
winget install --id Microsoft.Powershell --source winget

Write-Host ""
Write-Host "🤚  This script will setup .dotfiles for you."
Read-Host "    Press any key to continue or Ctrl+C to abort...`n`n"

# Install chezmoi
if (!(Get-Command -Name chezmoi)) {
  Write-Host "👊  Installing chezmoi"
  winget install chezmoi
}

$chezmoiDir = "$HOME\.local\share\chezmoi\.git"
if (Test-Path $chezmoiDir) {
  Write-Host "🚸  chezmoi already initialized"
  Write-Host "    Reinitialize with: 'chezmoi init git@github.com:caycehouse/dotfiles.git'"
} else {
  Write-Host "🚀  Initialize dotfiles with:"
  Write-Host "    chezmoi init git@github.com:caycehouse/dotfiles.git"
}

Write-Host ""
Write-Host "Done."
