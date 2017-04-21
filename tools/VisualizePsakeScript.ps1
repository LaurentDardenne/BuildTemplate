param($Path,$Keyname)
#adapted from https://github.com/fschwiet/PsakeViz

 $Result=[System.Collections.Arraylist]::New()

 function LoadTasks([System.IO.FileInfo] $psakeScript) {
  #Redéfini les fonctions de base de PSake
    
    $tasks = @{};
    
    function Include {
	}

    function Properties {
    }

    function Task {
      #Constructs the list of tasks according to the call lines contained in the script to be analyzed
      #No code is executed
      [CmdletBinding()]
      param(
          [Parameter(Position=0,Mandatory=1)][string]$name = $null,
          [Parameter(Position=1,Mandatory=0)][scriptblock]$action = $null,
          [Parameter(Position=2,Mandatory=0)][scriptblock]$preaction = $null,
          [Parameter(Position=3,Mandatory=0)][scriptblock]$postaction = $null,
          [Parameter(Position=4,Mandatory=0)][scriptblock]$precondition = {$true},
          [Parameter(Position=5,Mandatory=0)][scriptblock]$postcondition = {$true},
          [Parameter(Position=6,Mandatory=0)][switch]$continueOnError = $false,
          [Parameter(Position=7,Mandatory=0)][string[]]$depends = @(),
          [Parameter(Position=8,Mandatory=0)][string[]]$requiredVariables = @(),
          [Parameter(Position=9,Mandatory=0)][string]$description = $null,
          [Parameter(Position=10,Mandatory=0)][string]$alias = $null
      )   
		
        Write-debug "Create Task[$name]" 
		$name = $name.Replace("-", "");
        
        if ( $depends.Count -gt 0) 
        { $depends=@($depends | % { $_.Replace("-", "") }) }
        $tasks[$name] = @{
            name = $name
            depends = $depends
        };
    }
	
	function FormatTaskName {
	}
    
    $originalLocation = get-location
    set-location $psakeScript.Directory
    
    try {
         #run the Psake code
        & (gi $psakeScript)
    } finally {
        set-location $originalLocation
    }
   $tasks
 }#LoadTasks

 function VisitTask {
  param($TaskName)
  
  Write-debug "Visit Task[$TaskName]" 
  Foreach ($CurrentTaskName in $Tasks.$TaskName) #todo name scope
  {
    if ($CurrentTaskName.Depends -is [String[]])
    {
      Foreach ($DependTask in $CurrentTaskName.Depends)
      { 
        VisitTask $DependTask 
        if (! $Result.Contains($DependTask))
        {
         Write-Debug "Add $DependTask" 
         $Result.Add($DependTask)> $null 
        }

      } 
    }
    else {write-error "Type unknown ?  $($CurrentTaskName.Depends.gettype().Fullname)"} 
  } 
 }#VisitTask  

$psakeScriptFileinfo = (New-Object -TypeName "System.IO.FileInfo" -ArgumentList (gi $Path))
$Tasks=LoadTasks $psakeScriptFileinfo
if (! $Tasks.Contains($TaskName))
{ Write-Error "The key '$TaskName' does not exist." }
else 
{
  VisitTask $MainTaskName
  $Result.Add($MainTaskName)  >$null
  return ,$Result
}
#.\VisualizePsakeScript.ps1  -Path 'C:\Temp\Plaster-master\examples\NewModule\build.psake.ps1' -MainTaskName 'Build'  

