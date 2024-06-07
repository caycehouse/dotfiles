$Packages = @(
    "7zip.7zip"
    "AgileBits.1Password"
    "AgileBits.1Password.CLI"
    "Armin2208.WindowsAutoNightMode"
    "Balena.Etcher"
    "calibre.calibre"
    "dbeaver.dbeaver"
    "Discord.Discord"
    "Docker.DockerDesktop"
    "Easeware.DriverEasy"
    "ebkr.r2modman"
    "ElectronicArts.EADesktop"
    "EpicGames.EpicGamesLauncher"
    "Git.Git"
    "GitHub.GitHubDesktop"
    "GOG.Galaxy"
    "Google.Chrome"
    "HandBrake.HandBrake"
    "HumbleBundle.HumbleApp"
    "ItchIo.Itch"
    "Iterate.Cyberduck"
    "Microsoft.DevHome"
    "Microsoft.Office"
    "Microsoft.PowerToys"
    "Microsoft.Teams"
    "Microsoft.VisualStudioCode"
    "Microsoft.WindowsTerminal"
    "Microsoft.WSL"
    "Mirantis.Lens"
    "Mozilla.Firefox"
    "Nextcloud.NextcloudDesktop"
    "NexusMods.Vortex"
    "Nvidia.Broadcast"
    "Nvidia.GeForceExperience"
    "Nvidia.PhysX"
    "Parsec.Parsec"
    "PathofBuildingCommunity.PathofBuildingCommunity"
    "Playnite.Playnite"
    "Postman.Postman"
    "Prusa3D.PrusaSlicer"
    "RaspberryPiFoundation.RaspberryPiImager"
    "RealVNC.VNCViewer"
    "Samsung.SamsungMagician"
    "SatoshiLabs.trezor-suite"
    "SideQuestVR.SideQuest"
    "tailscale.tailscale"
    "topgrade-rs.topgrade"
    "twpayne.chezmoi"
    "Ubisoft.Connect"
    "Valve.Steam"
    "VirtualDesktop.Streamer"
    "WinDirStat.WinDirStat"
    "WinSCP.WinSCP"
    "WiresharkFoundation.Wireshark"
    "xpipe-io.xpipe"
)

$Base = @{
    '$schema'       = "https://aka.ms/winget-packages.schema.2.0.json"
    "Sources"       = @(
        @{
            "Packages"      = @(
                foreach ($Package in $Packages) {
                    @{
                        PackageIdentifier = $Package
                    }
                }
            )
            "SourceDetails" = @{
                "Argument"   = "https://cdn.winget.microsoft.com/cache"
                "Identifier" = "Microsoft.Winget.Source_8wekyb3d8bbwe"
                "Name"       = "winget"
                "Type"       = "Microsoft.PreIndexed.Package"
            }
        }
    )
    "WinGetVersion" = "1.7.11261"
}

$TempFile = $(Get-Item ([System.IO.Path]::GetTempFilename())).FullName # https://github.com/PowerShell/PowerShell/issues/14100#issuecomment-1236428024

Set-Content -Path $TempFile -Value $($Base | ConvertTo-Json -Depth 6)

winget import --accept-package-agreements --accept-source-agreements -i $TempFile

Remove-Item -Path $TempFile -Force
