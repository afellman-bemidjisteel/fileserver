# Script to install PowerShell SecretManagement modules and set up required secrets
# This script must be run with administrative privileges

# Install required modules if not already present
# Import modules

Import-Module Microsoft.PowerShell.SecretManagement
Import-Module Microsoft.PowerShell.SecretStore

# Check if SecretStore vault exists, if not create it
$vaultName = "SystemSecretStore"
$vaults = Get-SecretVault

if (-not ($vaults | Where-Object { $_.Name -eq $vaultName })) {
    Write-Host "Creating SecretStore vault: $vaultName"
    
    # Create the vault without a password (for SYSTEM use)
    Register-SecretVault -Name $vaultName -ModuleName Microsoft.PowerShell.SecretStore
    
    # Configure SecretStore to not require a password
    Set-SecretStoreConfiguration -Authentication None -Interaction None -Confirm:$false

} else {
    Write-Host "Secret vault already exists: $vaultName"
}

# Prompt for the credentials to store
$fileUser = ''
$filePassword = ''

# Store credentials in the vault
try {
    Set-Secret -Name 'FileUser' -Secret $fileUser -Vault $vaultName
    Set-Secret -Name 'FilePass' -Secret $filePassword -Vault $vaultName
    
    Write-Host "Secrets stored successfully."
    
    # Test that secrets can be retrieved
    try {
        $testUser = Get-Secret -Name 'FileUser' -AsPlainText -Vault $vaultName
        $testPass = Get-Secret -Name 'FilePass' -Vault $vaultName
        
        if ($testUser -and $testPass) {
            Write-Host "Secret verification successful." -ForegroundColor Green
            Write-Host "Your secrets are ready to be used by the drive mapping script."
        }
    } catch {
        Write-Error "Failed to verify secrets. Error: $_"
    }
} catch {
    Write-Error "Failed to store secrets. Error: $_"
    exit 1
}

Write-Host "Setup complete!"
