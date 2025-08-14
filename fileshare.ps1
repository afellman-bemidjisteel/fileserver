Import-Module Microsoft.PowerShell.SecretManagement
Import-Module Microsoft.PowerShell.SecretStore

if (Get-PSDrive -Name 'Z' -ErrorAction SilentlyContinue) {
    Write-Warning "Drive letter 'Z' is already in use."
    exit 1
}
try {
    $pass = Get-Secret -Name 'FilePass'
    $user = Get-Secret -Name 'FileUser' -AsPlainText
} catch {
    Write-Error "Failed to retrieve the password or username from SecretStore. Ensure the 'FilePass' and 'FileUser' secrets exist and are accessible to the Local Administrator account."
    exit 1
}

New-PSDrive -Name 'Z' -PSProvider FileSystem -Root '' -Credential (New-Object System.Management.Automation.PSCredential $user, $pass) -Persist -Scope Global

if ($securePassword) {
    $securePassword | Out-Null # Attempt to clear the SecureString from memory (best effort)
}

exit 1
