# Script to install PowerShell SecretManagement modules and set up required secrets
# This script must be run with administrative privileges

# Check if running as administrator
#$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
#if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
#    Write-Error "This script must be run as Administrator. Please restart PowerShell as Administrator and try again."
#    exit 1
#}

# Install required modules if not already present

$modulesToInstall = @(
    'Microsoft.PowerShell.SecretManagement',
    'Microsoft.PowerShell.SecretStore'
)

foreach ($module in $modulesToInstall) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Host "Installing module: $module"
        Install-Module -Name $module -Force -AllowClobber -Scope AllUsers
    } else {
        Write-Host "Module already installed: $module"
    }
}
