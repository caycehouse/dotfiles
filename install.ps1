# Set the execution policy to allow scripts to run
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted

if (-not $env:CODESPACES -or $env:CODESPACES -eq 'false') {
  # Install latest Powershell version
  winget install --accept-package-agreements --accept-source-agreements --disable-interactivity --id Microsoft.Powershell --source winget
}

# Install chezmoi if necessary
if (Get-Command -Name chezmoi) {
  Write-Host "Chezmoi is already installed."
} else {
  winget install --accept-package-agreements --accept-source-agreements --disable-interactivity chezmoi
}

# Apply dotfiles
Write-Host "Applying Chezmoi configuration."
chezmoi init caycehouse/dotfiles
chezmoi apply
