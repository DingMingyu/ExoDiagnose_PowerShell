if (-not (Get-Command Get-Connection -ErrorAction Ignore))
{
  . (Join-Path -Path $PSScriptRoot -ChildPath "shared.ps1")
}

function Get-Object($obj)
{
  if ($obj)
  {
    return $obj
  }
  return $null
}

class CASMailboxSource
{
  [string]$name = "CASMailbox"
  [string]$email
  CASMailboxSource([string]$email)
  {
    $this.email = $email
  }
  [object]GetSettings()
  {
    return Get-Object(Get-CASMailbox -Identity $this.email)
  }
}

class MobileDeviceSource
{
  [string]$name = "Mobile Device"
  [string]$email
  MobileDeviceSource([string]$email)
  {
    $this.email = $email
  }  
  [object]GetSettings()
  {
    return Get-Object(Get-MobileDevice -Mailbox $this.email)
  }
}

class MobileDeviceStatisticsSource
{
  [string]$name = "Mobile Device Statistics"
  [string]$email
  MobileDeviceStatisticsSource([string]$email)
  {
    $this.email = $email
  }  
  [object]GetSettings()
  {
    return Get-Object(Get-MobileDeviceStatistics -Mailbox $this.email)
  }
}

class MobileDeviceMailboxPolicySource
{
  [string]$name = "Mobile Device Mailbox Policy"
  [object]GetSettings()
  {
    return Get-Object(Get-MobileDeviceMailboxPolicy)
  }
}

class AccessRuleSource
{
  [string]$name = "ActiveSync Device Access Rule"
  [object]GetSettings()
  {
    return Get-Object(Get-ActiveSyncDeviceAccessRule)
  }
}

class OrganizationSettingsSource
{
  [string]$name = "ActiveSync Organization Settings"
  [object]GetSettings()
  {
    return Get-Object(Get-ActiveSyncOrganizationSettings)
  }
}

function Get-Settings($source, [string]$logPath)
{
  $sw = [System.Diagnostics.StopWatch]::new()
  $sw.Start()
  $settings = $source.GetSettings()
  $totalMs = $sw.ElapsedMilliseconds
  $sw.Stop()
  if (-not $settings)
  {
    $cnt = 0
  }
  elseif (-not $settings.Count)
  {
    $cnt = 1
  }
  else
  {
    $cnt = $settings.Count
  }
  $text = "It takes {0}ms to fetch {1} {2}." -f $totalMs, $cnt, $source.name
  Write-Log -obj $text -path $logPath
  Write-Log -obj $settings -path $logPath
  return $settings
}

<#
.SYNOPSIS
    Get Mobile Device Access Rule relevant settings.
.DESCRIPTION
    This cmdlet returns Mobile Device Access Rule relevant settings.
.EXAMPLE
    PS C:\>Get-AbqSettings -Mailbox user@contoso.com
    PS C:\>Get-AbqSettings -Mailbox user@contoso.com -LogPath d:\logs\abq.log
#>
function Get-AbqSettings
{
  param
  (
    [Parameter(Mandatory=$true)] [string]$Mailbox,
    [string]$LogPath = "logs\abq.log"
  )
  process
  {
    $text = "{0}: collecing ABQ settings for user {1}." -f (Get-Date).ToString("O"), $Mailbox
    Write-Log -obj $text -path $LogPath -toConsole
    $LogPath = (Resolve-Path -Path $LogPath).Path
    Get-ExoConnection
    $cas = Get-Settings -source ([CASMailboxSource]::new($Mailbox)) -logPath $LogPath
    if (-not $cas)
    {
      $text = "The mailbox {0} is not found." -f $Mailbox
      Write-Log -obj $text -path $LogPath -toConsole
    }
    $null = Get-Settings -source ([MobileDeviceSource]::new($Mailbox)) -logPath $LogPath
    $null = Get-Settings -source ([MobileDeviceStatisticsSource]::new($Mailbox)) -logPath $LogPath
    $null = Get-Settings -source ([MobileDeviceMailboxPolicySource]::new()) -logPath $LogPath
    $null = Get-Settings -source ([AccessRuleSource]::new()) -logPath $LogPath
    $null = Get-Settings -source ([OrganizationSettingsSource]::new()) -logPath $LogPath
    Write-Log -obj "ABQ settings successfully collected and stored at $LogPath." -path $LogPath -toConsole
  }
}
