## ExoDiagnose
The project creates a PowerShell module that helps user/admin troubleshoot EXO issues.
The project has just started and more functionalities are supposed to be added soon.
So far only Mobile Device Access Rules relevant settings auto-collection is available. 

## Dependencies
ExchangeOnlineManagement is highly suggested, but not a necessary dependency. You can still use the old basic auth to connect EXO.

## Getting Started
Run the below command to install the module.
  Install-Module -Name ExoDiagnose
Please go through the scripts under .\scr\examples and you'll know how to use the module. 

## Test
.\tests\Invoke-Tests.ps1

## Build
.\build\Build-Package.ps1
