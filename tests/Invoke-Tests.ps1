$testFiles = [System.IO.Directory]::GetFiles($PSScriptRoot, "*.tests.ps1", "AllDirectories")                                                                                         
foreach ($testFile in $testFiles)
{
  "Testing $testFile"
  Invoke-Pester $testFile
}
