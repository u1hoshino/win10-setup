
$buckets = @(
    'extras'
    'versions'
    'java'
    # 'nerd-fonts'
)

$apps = @(
    'aria2'
    'git'
    
    'googlechrome'
    'windows-terminal'
    'winscp'
    
    'vscode'
    'adoptopenjdk-lts-hotspot'

    'zoom'
)



Set-ExecutionPolicy Bypass -Scope Process -Force

Write-Host "Checking for Scoop"
if (!(Test-Path -Path "$HOME\scoop")) {
    Write-Host "Scoop not found, installing"
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
    scoop update    
}
else {
    Write-Host "Scoop found"
    scoop update
    scoop update *
}

Write-Host "Configuring Scoop buckets"
foreach ( $bucket in $buckets ) {
    $bucket_registered = scoop bucket list | Select-String -Pattern $bucket -quiet 
    if ($bucket_registered -ne "True") {
        Write-Host "Bucket register: $bucket"
        scoop bucket $bucket
    } 
}


Write-Host "Install application"
foreach ( $app in $apps ) {
    $scoop_installed = scoop info $app | Select-String -Pattern "Installed: No" -quiet 
    if ($scoop_installed -eq "True") {
        Write-Host "Install: $app"
        scoop install $app
    }
}
