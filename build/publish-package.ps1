$modulePath = [System.IO.Path]::GetFullPath((Join-Path -Path $PSScriptRoot -ChildPath "release\ExoDiagnose\"))
Import-Module "$modulePath\ExoDiagnose.psd1"

$userdataModulePath = [System.IO.Path]::GetFullPath((Join-Path -Path $PSScriptRoot -ChildPath "..\data\MyUserData.psm1"))
Import-Module $userdataModulePath
$userData = Get-UserData

Publish-Module -Path $modulePath -NuGetApiKey $userData.nuGetApiKey
