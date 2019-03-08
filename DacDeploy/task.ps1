[CmdletBinding()]
param()

Set-PSDebug -Trace 0;

$dacpac = Get-VstsInput -Name 'dacpac' -Require;
$server = Get-VstsInput -Name 'server' -Require;
$username = Get-VstsInput -Name 'username' -Require;
$password = Get-VstsInput -Name 'password' -Require;

Write-Host "DACPAC File: $dacpac";
Write-Host "Server: $server";
Write-Host "Username: $username";

$dbName = (Get-ChildItem $dacpac).BaseName;

Write-Host "Database Name: $dbName";

add-type -path "C:\Program Files (x86)\Microsoft SQL Server\140\DAC\bin\Microsoft.SqlServer.Dac.dll"

$dacService = new-object Microsoft.SqlServer.Dac.DacServices "Data Source=$server;User Id=$username;Password=$password;"

$deployOptions = New-Object Microsoft.SqlServer.Dac.DacDeployOptions
$deployOptions.RegisterDataTierApplication = $true
$deployOptions.BlockOnPossibleDataLoss = $true
$deployOptions.BlockWhenDriftDetected = $false

$dp = [Microsoft.SqlServer.Dac.DacPackage]::Load($dacpac)

$dacService.deploy($dp, $dbName, "True", $deployOptions) 