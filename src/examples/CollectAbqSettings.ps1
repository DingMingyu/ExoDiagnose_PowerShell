# Set-Location D:\dev\work\Exchange\ExoDiagnose
Set-Location (Join-Path -Path $PSScriptRoot -ChildPath "..\..\")

# MyUserData.psm1 is not included in the project source control. Its content is similar to that of .\Data\UserData.psm1.
Import-Module .\Data\MyUserData.psm1
$userData = Get-UserData

Import-Module .\src\ExoDiagnose\ExoDiagnose.psd1

Get-AbqSettings -mailbox $userData.user
