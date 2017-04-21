Main tasks : Clean, Build, Sign, BuildHelp, Install, Test,Publish
Tasks can be declared several times but are executed only once

**Clean**

- Executing Init
- Executing Clean



**Build**

- Executing Init
- Executing Clean
- Executing BeforeBuild
- Executing BeforeStageFiles
- Executing CoreStageFiles
- Executing AfterStageFiles
- Executing StageFiles
- Executing Analyze
- Executing Sign
- Executing AfterBuild
- Executing Build



**BuildHelp**
- Executing BeforeBuildHelp
- Executing GenerateMarkdown
- Executing GenerateHelpFiles
- Executing AfterBuildHelp
- Executing BuildHelp


**Test**
- Executing Init
- Executing Clean
- Executing BeforeBuild
- Executing BeforeStageFiles
- Executing CoreStageFiles
- Executing AfterStageFiles
- Executing StageFiles
- Executing Analyze
- Executing Sign
- Executing AfterBuild
- Executing Build
- Executing Test


**Sign**
- Executing Init
- Executing Clean
- Executing BeforeStageFiles
- Executing CoreStageFiles
- Executing AfterStageFiles
- Executing StageFiles
- Executing Sign


**Install**
- Executing Init
- Executing Clean
- Executing BeforeBuild
- Executing BeforeStageFiles
- Executing CoreStageFiles
- Executing AfterStageFiles
- Executing StageFiles
- Executing Analyze
- Executing Sign
- Executing AfterBuild
- Executing Build
- Executing BeforeBuildHelp
- Executing GenerateMarkdown
- Executing GenerateHelpFiles
- Executing AfterBuildHelp
- Executing BuildHelp
- Executing BeforeGenerateFileCatalog
- Executing CoreGenerateFileCatalog
- Executing AfterGenerateFileCatalog
- Executing GenerateFileCatalog
- Executing BeforeInstall
- Executing CoreInstall
- Executing AfterInstall
- Executing Install


**Publish**
- Executing Init
- Executing Clean
- Executing BeforeBuild
- Executing BeforeStageFiles
- Executing CoreStageFiles
- Executing AfterStageFiles
- Executing StageFiles
- Executing Analyze
- Executing Sign
- Executing AfterBuild
- Executing Build
- Executing Test
- Executing BeforeBuildHelp
- Executing GenerateMarkdown
- Executing GenerateHelpFiles
- Executing AfterBuildHelp
- Executing BuildHelp
- Executing BeforeGenerateFileCatalog
- Executing CoreGenerateFileCatalog
- Executing AfterGenerateFileCatalog
- Executing GenerateFileCatalog
- Executing BeforePublish
- Executing CorePublish
- Executing AfterPublish
- Executing Publish
