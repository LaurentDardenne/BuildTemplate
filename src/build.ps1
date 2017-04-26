#Requires -Modules psake
 [CmdletBinding(DefaultParameterSetName = "PowershellGallery")]
 Param(
      #see appveyor.yml
     [Parameter(ParameterSetName="Other")]
     $RepositoryName
 )

 if (! $PSBoundParameters.ContainsKey('RepositoryName'))
 { $RepositoryName=$null }

# Builds the module by invoking psake on the build.psake.ps1 script.
Invoke-PSake $PSScriptRoot\build.psake.ps1 -taskList Build -parameters @{"RepositoryName"=$RepositoryName}
