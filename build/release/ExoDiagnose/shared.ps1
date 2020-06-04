<#
.SYNOPSIS
    Connect EXO with user name and password.
    It is not suggested to use basic auth as it explicitly write user name and password, which is unsafe. If possible, use Connect-ExchangeOnline instead.

.DESCRIPTION
    Start EXO PowerShell session.
.EXAMPLE
    PS C:\>Connect-ExoWithBasicAuth -User "admin@contoso.com" -Pass "_password_"
#>
function Connect-ExoWithBasicAuth
{
  param
  (
    [Parameter(Mandatory=$true)] [string]$User,
    [Parameter(Mandatory=$true)] [string][string]$Pass
  )
  process
  {
    $p = ConvertTo-SecureString -String $Pass -AsPlainText -Force
    $Creds = [System.Management.Automation.PSCredential]::new($User, $p)
    $PsUrl = "https://outlook.office365.com/powershell-liveid/"
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $PsUrl -Credential $Creds -Authentication Basic -AllowRedirection
    Import-PSSession $Session
  }
}

function Get-ExoConnection()
{
  if (!(Get-Command "Get-Mailbox*"))
  {
    if (!(Get-Module ExchangeOnlineManagement))
    {
      Import-Module ExchangeOnlineManagement
    }
    Connect-ExchangeOnline
  }
}

function Write-Log($obj, [string]$path, [switch]$toConsole)
{
  if (-not $obj) 
  {
    return
  }
  $folder = Split-Path -Path $path
  if ($folder -and !(Test-Path -Path $folder))
  {
    $null = New-Item -ItemType Directory -Path $folder
  }

  if ($obj.GetType() -eq [string])
  {    
    $text = $obj
  }
  else
  {
    $text = $obj|Format-List *|Out-String
  }
  Add-Content -Path $path -Value $text
  if ($toConsole)
  {
    Write-Host $text
  }
}