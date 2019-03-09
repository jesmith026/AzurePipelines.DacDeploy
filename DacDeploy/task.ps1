[CmdletBinding()]
param()

Set-PSDebug -Trace 0;

$dacpac = Get-VstsInput -Name 'dacpac' -Require;
$server = Get-VstsInput -Name 'server' -Require;
$username = Get-VstsInput -Name 'username' -Require;
$password = Get-VstsInput -Name 'password' -Require;
$blockOnDataLoss = Get-VstsInput -Name 'blockOnDataLoss' -Require;
$dacdll = Get-VstsInput -Name "dacdll";

if ([string]::IsNullOrEmpty($dacdll)) {
    $dacdll = "C:\Program Files (x86)\Microsoft SQL Server\140\DAC\bin\Microsoft.SqlServer.Dac.dll";
}

Write-Host "DACPAC File: $dacpac";
Write-Host "Server: $server";
Write-Host "Username: $username";

. {
    trap { Write-Host "Error loading database project: $dacpac"; Break; }
    
    Write-Host "Loading database project";
    $dbName = (Get-ChildItem $dacpac).BaseName;
}

Write-Host "Database Name: $dbName";

. {
    trap { Write-Host "Error loading dac dll"; Break; }

    Write-Host "Loading dac dll"
    add-type -path $dacdll;
}

. {
    trap { Write-Host "Error creating dac service"; Break; }

    Write-Host "Creating dac service"
    $dacService = new-object Microsoft.SqlServer.Dac.DacServices "Data Source=$server;User Id=$username;Password=$password;";
}

. {
    trap { Write-Host "Error configuring deployment options"; Break; }

    Write-Host "Configuring deployment options...";

    $deployOptions = New-Object Microsoft.SqlServer.Dac.DacDeployOptions;
    $deployOptions.RegisterDataTierApplication = $true;
    $deployOptions.BlockOnPossibleDataLoss = $blockOnDataLoss;
    $deployOptions.BlockWhenDriftDetected = $false;
}

. {
    trap { Write-Host "Error deploying changes for server: ($server) and database: ($dbName)"}

    Write-Host "Deploying database changes for server: ($server) and database: ($dbName)...";
    $dp = [Microsoft.SqlServer.Dac.DacPackage]::Load($dacpac);
    $dacService.deploy($dp, $dbName, "True", $deployOptions);
}

Write-Host "Deployment complete"