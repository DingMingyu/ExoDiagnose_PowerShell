# Set-Location D:\dev\work\Exchange\ExoDiagnose
Set-Location (Join-Path -Path $PSScriptRoot -ChildPath "..\..\")

# MyUserData.psm is not included in the project source control. Its content is similar to that of .\Data\UserData.psm1.
Import-Module .\Data\MyUserData.psm1
$userData = Get-UserData

Import-Module .\src\ExoDiagnose\ExoDiagnose.psd1

# it is not suggested to use basic auth as it explicitly write user name and password, which is unsafe. If possible, remove this line and then the tool will automaticlaly try to logon interactively through OAuth.
Connect-ExoWithBasicAuth -User $userData.user -Pass $userData.password
Get-AbqSettings -mailbox $userData.user
