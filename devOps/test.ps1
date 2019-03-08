# $env:BUILD_SOURCEBRANCHNAME = 'dev';
# $env:BUILD_BUILDNUMBER = '2018.12.13.1';

Import-Module "$PSScriptRoot\..\DacDeploy\ps_modules\VstsTaskSdk\VstsTaskSdk.psd1";
& "$PSScriptRoot\..\DacDeploy\task.ps1";
Remove-Module "VstsTaskSdk";