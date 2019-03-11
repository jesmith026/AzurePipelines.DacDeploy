param(
    [switch] $IncrementVersion
)


function checkAddRevVersion([parameter(ValueFromPipeline)]$cmd) {
    if ($PSBoundParameters.ContainsKey('IncrementVersion')) {
        $cmd += ' --rev-version';
    }
    $cmd;
}


$cmd = 'tfx extension create' | checkAddRevVersion;
$cmd += " --output-path $PSScriptRoot\..\artifacts\ --manifest-globs $PSScriptRoot\..\vss-extension.json";

Invoke-Expression $cmd;