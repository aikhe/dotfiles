# PowerShell Profile for oh-my-posh
# This profile suppresses Get-PSReadLineKeyHandler errors that occur with older PSReadLine versions

# Ensure profile directory exists
if (!(Test-Path $PROFILE)) {
  New-Item -Type File -Path $PROFILE -Force | Out-Null
}

# Create a wrapper function for Get-PSReadLineKeyHandler that handles old PSReadLine syntax
# This prevents parameter binding errors when oh-my-posh calls it with positional parameters
function Get-PSReadLineKeyHandler {
  [CmdletBinding()]
  param(
    [Parameter(Position=0)]
    [string]$Key
  )
  
  # For PSReadLine 2.0.0, the cmdlet doesn't support positional parameters
  # Return a dummy object that oh-my-posh expects to prevent errors
  # The Function property is what oh-my-posh checks
  return [PSCustomObject]@{
    Function = 'SelfInsert'
    Key = $Key
    Description = ''
  }
}

# Initialize oh-my-posh
$oldErrorAction = $ErrorActionPreference
$ErrorActionPreference = 'SilentlyContinue'

try {
  oh-my-posh init pwsh --config 'C:\Users\aikhe\Desktop\ike\local\dotfiles\ohmyposh\aikhe.omp.json' | Invoke-Expression
} catch {
  # Suppress any errors
}

# Restore original error action preference
$ErrorActionPreference = $oldErrorAction

