﻿#https://www.fosshub.com/IrfanView.html
$packageName    = 'irfanview'
$installerType  = 'exe'
$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url            = "$toolsDir\iview444_setup.exe"
$checksum       = '71B44CD3D14376BBB619B2FE8A632D29200385738DD186680E988CE32662B3D6'
$checksumType   = 'sha256'
$url64          = "$toolsDir\iview444_x64_setup.exe"
$checksum64     = '38C9AC7B8C7C4342ECABD139E5CA4E9BD9460F0B541C00DFCD3E9D76CC125888'
$checksumType64 = 'sha256'
$validExitCodes = @(0)
$arguments      = @{}
$packageParameters = $env:chocolateyPackageParameters

Write-Debug "Default values for package parameters: 0=off, 1=on"
$desktop = 0
$thumbs = 0
$group = 0
$allusers = 1
$assoc = 0
$ini = "%APPDATA%\IrfanView"
$folder = $null

if ($packageParameters) {
    $match_pattern = "\/(?<option>([a-zA-Z]+))=(?<value>([`"'])?([a-zA-Z0-9- _\\:%\.]+)([`"'])?)|\/(?<option>([a-zA-Z]+))"
    $option_name = 'option'
    $value_name = 'value'

    if ($packageParameters -match $match_pattern ){
        $results = $packageParameters | Select-String $match_pattern -AllMatches
        $results.matches | ForEach-Object {
          $arguments.Add(
              $_.Groups[$option_name].Value.Trim(),
              $_.Groups[$value_name].Value.Trim())
      }
    } else {
        Throw "Package Parameters were found but were invalid (REGEX failure)"
    }

    if ($arguments.ContainsKey("desktop")) {
        Write-Verbose "Adding desktop shortcut to IrfanView"
        $desktop = 1
    }

    if ($arguments.ContainsKey("thumbs")) {
        Write-Verbose "Adding desktop shortcut to IrfanView Thumbnails"
        $thumbs = 1
    }

    if ($arguments.ContainsKey("group")) {
        Write-Verbose "Adding IrfanView group to start menu"
        $group = 1
    }
    
    if ($arguments.ContainsKey("allusers")) {
        Write-Verbose "Installing IrfanView for only current user"
        $allusers = 0
    }
    
    if ($arguments.ContainsKey("assoc")) {
        Write-Verbose "Associating IrfanView to file types"
        $assoc = $arguments["assoc"]
    }

    if ($arguments.ContainsKey("ini")) {
        Write-Verbose "You want to use a custom configuration Path"
        $ini = $arguments["ini"]
    }
    
    if ($arguments.ContainsKey("folder")) {
        Write-Verbose "You want to use a custom configuration Path"
        $folder = $arguments["folder"]
    }

} else {
    Write-Debug "No package parameters passed in"
}

$silentArgs = "/silent" + 
              " /desktop=" + $desktop + 
              " /thumbs=" + $thumbs + 
              " /group=" + $group + 
              " /allusers=" + $allusers +
              " /assoc=" + $assoc
if ($ini) { $silentArgs += " /ini=" + $ini }
if ($folder) { $silentArgs += " /folder=" + $folder }
Write-Debug "Silent arguments Chocolatey will use are: $silentArgs"

$packageArgs = @{
  packageName   = $packageName
  fileType      = $installerType
  url           = $url
  url64bit      = $url64
  validExitCodes= $validExitCodes
  silentArgs    = $silentArgs
  softwareName  = 'IrfanView*'
  checksum      = $checksum
  checksumType  = $checksumType
  Checksum64    = $checksum64
  ChecksumType64= $checksumType64
}

Install-ChocolateyPackage @packageArgs 	

Remove-Item $url 
Remove-Item $url64					  