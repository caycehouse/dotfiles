# Set the execution policy to allow scripts to run
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted

# Install latest Powershell version
winget install --id Microsoft.Powershell --source winget

# Install chezmoi if necessary
if (Get-Command -Name chezmoi) {
  Write-Host "Chezmoi is already installed."
} else {
  winget install chezmoi
}

# Apply dotfiles
Write-Host "Applying Chezmoi configuration."
chezmoi init caycehouse/dotfiles
chezmoi apply
