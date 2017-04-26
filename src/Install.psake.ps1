#Install.psake.ps1
# J'installe un nouveau poste (IC ou nouveau poste de dev)
# ou je met à jour le poste local déjà installé

# Les versions des modules installées sur l'IC (Appveyor) et celles installées sur le poste de dev peuvent 
#ne pas correspondre et casser le build.

#Install ou met à jour les prérequis
#Appveyor utilisera tjr la dernière version

###############################################################################
# Dot source the user's customized properties and extension tasks.
###############################################################################
. $PSScriptRoot\Install.settings.ps1

Task default -Depends Install,Update

Task Install -Depends RegisterPSRepository -Precondition { $Mode -eq  'Install'}  {
  
  #Suppose : PowershellGet à jour     
   
   #On précise le repository car Pester est également sur Nuget 
  PowershellGet\Install-Module -Name $PSGallery.Modules -Repository PSGallery -Scope AllUsers -Force -AllowClobber -SkipPublisherCheck
  PowershellGet\Install-Module -Name $MyGet.Modules -Repository OttoMatt -Scope AllUsers -Force -AllowClobber  

  Set-location $Env:Temp
  nuget install ReportUnit
  #&"$Env:Temp\ReportUnit.1.2.1\tools\ReportUnit.exe"
}

Task RegisterPSRepository {

 try{
  Get-PSRepository OttoMatt -EA Stop >$null   
 } catch {
   if ($_.CategoryInfo.Category -ne 'ObjectNotFound')
   { throw $_ }
   else
   {   
     Register-PSRepository -Name OttoMatt -SourceLocation $MyGetSourceUri -PublishLocation $MyGetPublishUri `
                           -ScriptSourceLocation "$MyGetSourceUri\" -ScriptPublishLocation $MyGetSourceUri -InstallationPolicy Trusted 
    }
 }
    
 try{
  Get-PSRepository DevOttoMatt -EA Stop >$null   
 } catch {
   if ($_.CategoryInfo.Category -ne 'ObjectNotFound')
   { throw $_ }
   else
   { Register-PSRepository -Name DevOttoMatt -SourceLocation $DEV_MyGetSourceUri -PublishLocation $DEV_MyGetPublishUri `
                           -ScriptSourceLocation "$DEV_MyGetSourceUri\" -ScriptPublishLocation $DEV_MyGetPublishUri -InstallationPolicy Trusted 
   }
 }
}

Task Update -Precondition { $Mode -eq 'Update'}  {     
  $sbUpdate={
      $ModuleName=$_
      try {
        Write-host "Update $ModuleName"
        Update-module -name $ModuleName -Force
      }
      catch [Microsoft.PowerShell.Commands.WriteErrorException]{
        if ($_.FullyQualifiedErrorId -match ('^ModuleNotInstalledOnThisMachine'))
        {
          Write-host "`tInstall $ModuleName"
          install-module -Name $ModuleName -Repository $CurrentRepository -Scope AllUsers 
        }
        else 
        { throw $_ }
      }
  }     
  $CurrentRepository='PSGallery'
   $PSGallery.Modules|Foreach-Object $sbUpdate

  $CurrentRepository='OttoMatt'  
   $MyGet.Modules|Foreach-Object $sbUpdate  
}
