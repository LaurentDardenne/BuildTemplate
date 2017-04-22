
$PSGalleryPublishUri = 'https://www.myget.org/F/ottomatt/api/v2/package'
$PSGallerySourceUri = 'https://www.myget.org/F/ottomatt/api/v2'
function Set-CommonDependency{
  param()
  try{
  Get-PSRepository OttoMatt -EA Stop >$null   
  }catch {
    if ($_.CategoryInfo.Category -ne 'ObjectNotFound')
    { throw $_ }
    else
    { Register-PSRepository -Name OttoMatt -SourceLocation $PSGallerySourceUri -PublishLocation $PSGalleryPublishUri -InstallationPolicy Trusted }
  }

  #On paramètre le projet sur le poste de travail
  #On installe les prérequis sur le poste et pas dans le référentiel projet
  # La tâche de build doit pointer sur ces scripts 
  #user : "${env:USERPROFILE}\Documents\WindowsPowerShell\Scripts"
  #all : "${env:ProgramFiles}\WindowsPowerShell\Scripts
  'Replace-String','Lock-File','Remove-Conditionnal',
  'Show-BalloonTip','Test-BOMFile','Using-Culture'|
    Foreach {
      #Install-Script ne fonctionne pas avec Myget
      #Mais Install-Module installe le script %-)
    Install-Module -name "$_" -Repository OttoMatt -Scope AllUsers 
    }
  #Nuspec posséde une dépendance sur XMLObject
  'Log4Posh','DTW.PS.FileSystem','MeasureLocalizedData','PSNuspec' |
  Foreach {
    Install-Module -name $_ -Repository OttoMatt -Scope AllUsers
  }
}
Set-CommonDependency
$PSGalleryPublishUri = 'https://www.myget.org/F/ottomatt/api/v2/package'
$PSGallerySourceUri = 'https://www.myget.org/F/ottomatt/api/v2'
