#Install.ps1
#Install or update the dependencies (Modules, scripts, binaries)
 [CmdletBinding(DefaultParameterSetName = "Install")]
 Param(
     [Parameter(ParameterSetName="Update")]
   [switch] $Update
 )
#By default we install, otherwise we update
#And we force the install for the CI
if (Test-Path env:APPVEYOR)
{ Invoke-Psake "$PSScriptAnalyzerRulesVcs\Tools\Dependencies.ps1" -parameters @{"Mode"="Install"} -nologo }
else
{ Invoke-Psake "$PSScriptAnalyzerRulesVcs\Tools\Dependencies.ps1" -parameters @{"Mode"="$($PsCmdlet.ParameterSetName)"} -nologo }

