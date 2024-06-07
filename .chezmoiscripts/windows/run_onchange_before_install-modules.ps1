$Modules = @(
  "PSWindowsUpdate"
)

Set-PSResourceRepository -Name PSGallery -Trusted | Out-Null

$Modules | ForEach-Object {
  Install-PSResource -Name $_
}
