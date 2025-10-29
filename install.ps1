# Set the execution policy to allow scripts to run
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted

# Install latest Powershell version
winget install --accept-package-agreements --accept-source-agreements --disable-interactivity --silent --id Microsoft.Powershell --source winget

# Install chezmoi if necessary
if (Get-Command -Name chezmoi -ErrorAction SilentlyContinue) {
  Write-Host "Chezmoi is already installed."
} else {
  winget install --accept-package-agreements --accept-source-agreements --disable-interactivity --silent chezmoi
}

# Ensure chezmoi is in PATH
$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","User") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","Machine")

# Apply dotfiles
Write-Host "Applying Chezmoi configuration."
chezmoi.exe init caycehouse/dotfiles
chezmoi.exe apply
