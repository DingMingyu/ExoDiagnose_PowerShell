$modulePath = [System.IO.Path]::GetFullPath((Join-Path -Path $PSScriptRoot -ChildPath "release\ExoDiagnose"))

if (Test-Path $modulePath)
{
  Remove-Item $modulePath -Force -Recurse
}
New-Item -Path $modulePath -ItemType Directory -Force

$srcPath = [System.IO.Path]::GetFullPath((Join-Path -Path $PSScriptRoot -ChildPath "..\src\ExoDiagnose")) + "\*"
Copy-Item -Path $srcPath -Destination $modulePath -Recurse