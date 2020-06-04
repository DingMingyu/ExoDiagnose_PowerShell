$rootDir = [System.IO.Path]::GetFullPath((Join-Path -Path $PSScriptRoot -ChildPath "..\"))
. (Join-Path -Path $rootDir -ChildPath "src\ExoDiagnose\shared.ps1")

Describe "Write-Log" -Tag "Unit" {
  It "write a string to a log file" {
    $str = "some text"
    $fileName = "logs\{0}.log" -f [guid]::NewGuid()
    Write-Log -obj $str -path $fileName
    Test-Path $fileName | Should Be $true
    Get-Content -Path $fileName | Should Be $str
    Remove-Item -Path $fileName
  }
  It "write a complex object to a log file" {
    $fileName = "logs\{0}.log" -f [guid]::NewGuid()
    $items = Get-ChildItem
    Write-Log -obj $items -path $fileName
    Test-Path $fileName | Should Be $true
    $expected = ($items | Format-List * | Out-String) + "`r`n"
    $actual = [io.file]::ReadAllText((Resolve-Path -Path $fileName).Path)
    $actual | Should Be $expected
    Remove-Item -Path $fileName
  }
}
