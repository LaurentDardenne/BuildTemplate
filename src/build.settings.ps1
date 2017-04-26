###############################################################################
# Customize these properties and tasks for your module.
###############################################################################

function GetPowershellGetPath {
 #extracted from PowerShellGet/PSModule.psm1 

  $IsInbox = $PSHOME.EndsWith('\WindowsPowerShell\v1.0', [System.StringComparison]::OrdinalIgnoreCase)
  if($IsInbox)
  {
      $ProgramFilesPSPath = Microsoft.PowerShell.Management\Join-Path -Path $env:ProgramFiles -ChildPath "WindowsPowerShell"
  }
  else
  {
      $ProgramFilesPSPath = $PSHome
  }
  
  if($IsInbox)
  {
      try
      {
          $MyDocumentsFolderPath = [Environment]::GetFolderPath("MyDocuments")
      }
      catch
      {
          $MyDocumentsFolderPath = $null
      }
  
      $MyDocumentsPSPath = if($MyDocumentsFolderPath)
                                  {
                                      Microsoft.PowerShell.Management\Join-Path -Path $MyDocumentsFolderPath -ChildPath "WindowsPowerShell"
                                  } 
                                  else
                                  {
                                      Microsoft.PowerShell.Management\Join-Path -Path $env:USERPROFILE -ChildPath "Documents\WindowsPowerShell"
                                  }
  }
  elseif($IsWindows)
  {
      $MyDocumentsPSPath = Microsoft.PowerShell.Management\Join-Path -Path $HOME -ChildPath 'Documents\PowerShell'
  }
  else
  {
      $MyDocumentsPSPath = Microsoft.PowerShell.Management\Join-Path -Path $HOME -ChildPath ".local/share/powershell"
  }
  
  $Result=@{}

  $Result.AllUsersModules = Microsoft.PowerShell.Management\Join-Path -Path $ProgramFilesPSPath -ChildPath "Modules"
  $Result.AllUsersScripts = Microsoft.PowerShell.Management\Join-Path -Path $ProgramFilesPSPath -ChildPath "Scripts"
   
  $Result.CurrentUserModules = Microsoft.PowerShell.Management\Join-Path -Path $MyDocumentsPSPath -ChildPath "Modules"
  $Result.CurrentUserScripts = Microsoft.PowerShell.Management\Join-Path -Path $MyDocumentsPSPath -ChildPath "Scripts"
  return $Result         
}

function GetModulePath {
 param($Name)
  $List=@(Get-Module $Name -ListAvailable)
  if ($List.Count -eq 0)
  { Throw "Module '$Name' not found."} 
   #Last version
  $Llist[0].Modulebase
}

Properties {
    # ----------------------- Basic properties --------------------------------
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $ProjectName= 'Log4Posh'
    
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $ProjectUrl= 'https://github.com/LaurentDardenne/Log4Posh.git'

    # The root directories for the module's docs, src and test.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $DocsRootDir = "$PSScriptRoot\docs"
    $SrcRootDir  = "$PSScriptRoot\src"
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $TestRootDir = "$PSScriptRoot\test"

    # The name of your module should match the basename of the PSD1 file.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $ModuleName = Get-Item $SrcRootDir/*.psd1 |
                      Where-Object { $null -ne (Test-ModuleManifest -Path $_ -ErrorAction SilentlyContinue) } |
                      Select-Object -First 1 | Foreach-Object BaseName

    # The $OutDir is where module files and updatable help files are staged for signing, install and publishing.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $OutDir = "$PSScriptRoot\Release"

    # The local installation directory for the install task. Defaults to your home Modules location.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $InstallPath = Join-Path (Split-Path $profile.CurrentUserAllHosts -Parent) `
                             "Modules\$ModuleName\$((Test-ModuleManifest -Path $SrcRootDir\$ModuleName.psd1).Version.ToString())"

    # Default Locale used for help generation, defaults to en-US.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $DefaultLocale = 'en-US'

    # Items in the $Exclude array will not be copied to the $OutDir e.g. $Exclude = @('.gitattributes')
    # Typically you wouldn't put any file under the src dir unless the file was going to ship with
    # the module. However, if there are such files, add their $SrcRootDir relative paths to the exclude list.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $Exclude = @()

    # ------------------ Script analysis properties ---------------------------

    # Enable/disable use of PSScriptAnalyzer to perform script analysis.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $ScriptAnalysisEnabled = $false

    # When PSScriptAnalyzer is enabled, control which severity level will generate a build failure.
    # Valid values are Error, Warning, Information and None.  "None" will report errors but will not
    # cause a build failure.  "Error" will fail the build only on diagnostic records that are of
    # severity error.  "Warning" will fail the build on Warning and Error diagnostic records.
    # "Any" will fail the build on any diagnostic record, regardless of severity.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    [ValidateSet('Error', 'Warning', 'Any', 'None')]
    $ScriptAnalysisFailBuildOnSeverityLevel = 'Error'

    # Path to the PSScriptAnalyzer settings file.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $ScriptAnalyzerSettingsPath = "$PSScriptRoot\ScriptAnalyzerSettings.psd1"

    # Module names for additionnale custom rule
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    [String[]]$PSSACustomRules=@(
      GetModulelePath -Name OptimizationRules
      GetModulelePath -Name PSParameterSetRules
    ) 

    #MeasureLocalizedData
     #Full path of the module to control
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $LocalizedDataModule="$SrcRootDir\Log4Posh.psm1"

     #Full path of the function  to control. If $null is specified only the primary module is analyzed. 
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $LocalizedDataFunctions=$null

    #Cultures names to test the localized resources file.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $CulturesLocalizedData='en-US','fr-FR' 

      # ------------------- Controls files encoding ---------------------------
    #todo modifier Test-BomFile.ps1
    # Cmds.Template.ps1 -> Helps module
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
     $Params=@{
      Include=@('*.ps1','*.psm1','*.psd1','*.ps1xml','*.xml','*.txt');
      Exclude=@('*.bak','*.exe','*.dll','*.Cmds.Template.ps1','*.Datas.Template.ps1','*.csproj.FileListAbsolute.txt')
     }
 
    # ------------------- Script signing properties ---------------------------

    # Set to $true if you want to sign your scripts. You will need to have a code-signing certificate.
    # You can specify the certificate's subject name below. If not specified, you will be prompted to
    # provide either a subject name or path to a PFX file.  After this one time prompt, the value will
    # saved for future use and you will no longer be prompted.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $ScriptSigningEnabled = $false

    # Specify the Subject Name of the certificate used to sign your scripts.  Leave it as $null and the
    # first time you build, you will be prompted to enter your code-signing certificate's Subject Name.
    # This variable is used only if $SignScripts is set to $true.
    #
    # This does require the code-signing certificate to be installed to your certificate store.  If you
    # have a code-signing certificate in a PFX file, install the certificate to your certificate store
    # with the command below. You may be prompted for the certificate's password.
    #
    # Import-PfxCertificate -FilePath .\myCodeSigingCert.pfx -CertStoreLocation Cert:\CurrentUser\My
    #
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $CertSubjectName = $null

    # Certificate store path.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $CertPath = "Cert:\"

    # -------------------- File catalog properties ----------------------------

    # Enable/disable generation of a catalog (.cat) file for the module.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $CatalogGenerationEnabled = $true

    # Select the hash version to use for the catalog file: 1 for SHA1 (compat with Windows 7 and
    # Windows Server 2008 R2), 2 for SHA2 to support only newer Windows versions.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $CatalogVersion = 2

    # ---------------------- Testing properties -------------------------------

    # Enable/disable Pester code coverage reporting.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $CodeCoverageEnabled = $true

    # CodeCoverageFiles specifies the files to perform code coverage analysis on. This property
    # acts as a direct input to the Pester -CodeCoverage parameter, so will support constructions
    # like the ones found here: https://github.com/pester/Pester/wiki/Code-Coverage.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $CodeCoverageFiles = "$SrcRootDir\*.ps1", "$SrcRootDir\*.psm1"

    # -------------------- Publishing properties ------------------------------

    # Your NuGet API key for the nuget feed (PSGallery, Myget, Private).  Leave it as $null and the first time you publish,
    # you will be prompted to enter your API key.  The build will store the key encrypted in the
    # $NuGetApiKeyPath file, so that on subsequent publishes you will no longer be prompted for the API key.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $NuGetApiKey = $null

    # Name of the repository you wish to publish to.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $PublishRepository = $RepositoryName

    # Path to encrypted APIKey file.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $NuGetApiKeyPath = "$env:LOCALAPPDATA\Plaster\SecuredBuildSettings\$PublishRepository-ApiKey.clixml"
                                        
    # Path to the release notes file.  Set to $null if the release notes reside in the manifest file.
    # The contents of this file are used during publishing for the ReleaseNotes parameter.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $ReleaseNotesPath = "$PSScriptRoot\ReleaseNotes.md"
    
  
    # ----------------------- Misc properties ---------------------------------

    # In addition, PFX certificates are supported in an interactive scenario only,
    # as a way to import a certificate into the user personal store for later use.
    # This can be provided using the CertPfxPath parameter. PFX passwords will not be stored.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $SettingsPath = "$env:LOCALAPPDATA\Plaster\SecuredBuildSettings\$ProjectName.clixml"

    # Specifies an output file path to send to Invoke-Pester's -OutputFile parameter.
    # This is typically used to write out test results so that they can be sent to a CI
    # system like AppVeyor.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $TestOutputFile = $null

    # Specifies the test output format to use when the TestOutputFile property is given
    # a path.  This parameter is passed through to Invoke-Pester's -OutputFormat parameter.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $TestOutputFormat = "NUnitXml"
    
    # Specifies the paths of the installed scripts
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $PSGetPath=GetPowershellGetPath
    
    # Execute or nor 'TestBOM' task
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $isTestBom=$true
}

###############################################################################
# Customize these tasks for performing operations before and/or after file staging.
###############################################################################

Task RemoveConditionnal {
#todo copy de VCS vers temp puis vers Outdir
#1- Liste des fichiers traités , dans ce cas exclue de la copy (déjà fait)
#2- on traite tous les fichiers dans ce cas $OutDir est le répertoire temporaire servant à cette tâche ?
#Traite les pseudo directives de parsing conditionnelle   
  
   $VerbosePreference='Continue'
   ."${env:ProgramFiles}\WindowsPowerShell\Scripts\Remove-Conditionnal.ps1"
   Write-debug "Configuration=$Configuration"
   Write-Warning "Traite la configuration $Configuration"
   Get-ChildItem  "$PSScriptAnalyzerRulesVcs\Modules\ParameterSetRules\ParameterSetRules.psm1",
       "$PSScriptAnalyzerRulesVcs\Modules\ParameterSetRules\ParameterSetRules.psd1"|
    Foreach-Object {
      $Source=$_
      Write-Verbose "Parse :$($_.FullName)"
      $CurrentFileName="$PSScriptAnalyzerRulesDelivery\$($_.Name)"
      Write-Warning "CurrentFileName=$CurrentFileName"
      if ($Configuration -eq "Release")
      { 
         #Supprime les lignes de code de Debug et de test
         #On traite une directive et supprime les lignes demandées. 
         #On inclut les fichiers.       
        Get-Content -Path $_ -ReadCount 0 -Encoding UTF8|
         Remove-Conditionnal -ConditionnalsKeyWord 'DEBUG' -Include -Remove -Container $Source|
         Remove-Conditionnal -Clean| 
         Set-Content -Path $CurrentFileName -Force -Encoding UTF8        
      }
      else
      { 
         #On ne traite aucune directive et on ne supprime rien. 
         #On inclut uniquement les fichiers.

         #Directive inexistante et on ne supprime pas les directives
         #sinon cela génére trop de différences en cas de comparaison de fichier
        Get-Content -Path $_ -ReadCount 0 -Encoding UTF8|
         Remove-Conditionnal -ConditionnalsKeyWord 'NODEBUG' -Include -Container $Source|
         Set-Content -Path $CurrentFileName -Force -Encoding UTF8       
      }
    }#foreach
}


# Executes before the StageFiles task.
Task BeforeStageFiles -Depends RemoveConditionnal{
}

#Verifying file encoding BEFORE generation
Task TestBOM -Precondition { $isTestBom } -requiredVariables PSGetPath {

#La régle 'UseBOMForUnicodeEncodedFile' de PSScripAnalyzer s'assure que les fichiers qui
# ne sont pas encodés ASCII ont un BOM (cette régle est trop 'permissive' ici).
#On ne veut livrer que des fichiers UTF-8.

  Write-Host "Validation de l'encodage des fichiers du répertoire : $OutDir" #todo nom du projet ou nom du module ?
  
  Import-Module DTW.PS.FileSystem
  
  $InvalidFiles=@(&"$($PSGetPath.AllUsersScripts)\Test-BOMFile.ps1" $OutDir)  
  if ($InvalidFiles.Count -ne 0)
  { 
     $InvalidFiles |Format-List *
     Throw "Des fichiers ne sont pas encodés en UTF8 ou sont codés BigEndian."
  }
} 

Task TestLocalizedData -ContinueOnError {
    Write-warning "Todo TestLocalizedData"
    return
    Import-module MeasureLocalizedData

    $Module='.\Plaster.psm1' #todo
    $Functions=@(
    '.\InvokePlaster.ps1',
    '.\TestPlasterManifest.ps1'
    '.\NewPlasterManifest.ps1'
    )
    if ($null -eq $LocalizedDataFunctions)
    {$Result ='en-US','fr-FR'|Measure-ImportLocalizedData -Primary $LocalizedDataModule }
    else
    {$Result ='en-US','fr-FR'|Measure-ImportLocalizedData -Primary $LocalizedDataModule -Secondary $LocalizedDataFunctions}
    if ($Result.Count -ne 0)
    { throw 'One or more MeasureLocalizedData errors were found. Build cannot continue!' }
}     

# Executes after the StageFiles task.
Task AfterStageFiles -Depends TestBOM, TestLocalizedData {
}

###############################################################################
# Customize these tasks for performing operations before and/or after Build.
###############################################################################

# Executes before the BeforeStageFiles phase of the Build task.
Task BeforeBuild {
}

# #Verifying file encoding AFTER generation
Task TestBOMAfterAll -Precondition { $isTestBom } -requiredVariables PSGetPath { {
#   Import-Module DTW.PS.FileSystem

#   Write-Host "Validation de l'encodage des fichiers du répertoire : $OutDir""
#   $InvalidFiles=@(&"$($PSGetPath.AllUsersScripts)\Test-BOMFile.ps1" $OutDir)
#   if ($InvalidFiles.Count -ne 0)
#   { 
#      $InvalidFiles |Format-List *
#      Throw "Des fichiers ne sont pas encodés en UTF8 ou sont codés BigEndian."
#   }
# } #TestBOMFinal

# Executes after the Build task.
Task AfterBuild  -Depends TestBOMAfterAll {
}

###############################################################################
# Customize these tasks for performing operations before and/or after BuildHelp.
###############################################################################

# Executes before the BuildHelp task.
Task BeforeBuildHelp {
}

# Executes after the BuildHelp task.
Task AfterBuildHelp {
}

###############################################################################
# Customize these tasks for performing operations before and/or after BuildUpdatableHelp.
###############################################################################

# Executes before the BuildUpdatableHelp task.
Task BeforeBuildUpdatableHelp {
}

# Executes after the BuildUpdatableHelp task.
Task AfterBuildUpdatableHelp {
}

###############################################################################
# Customize these tasks for performing operations before and/or after GenerateFileCatalog.
###############################################################################

# Executes before the GenerateFileCatalog task.
Task BeforeGenerateFileCatalog {
}

# Executes after the GenerateFileCatalog task.
Task AfterGenerateFileCatalog {
}

###############################################################################
# Customize these tasks for performing operations before and/or after Install.
###############################################################################

# Executes before the Install task.
Task BeforeInstall {
}

# Executes after the Install task.
Task AfterInstall {
}

###############################################################################
# Customize these tasks for performing operations before and/or after Publish.
###############################################################################

# Executes before the Publish task.
Task BeforePublish {
}

# Executes after the Publish task.
Task AfterPublish {
}

#todo
#  publier les test : Update-AppveyorTest -Name "PsScriptAnalyzer" -Outcome Passed
#  publier le résultat du build sur devOttoMatt ( Push-AppveyorArtifact $_.FullName }