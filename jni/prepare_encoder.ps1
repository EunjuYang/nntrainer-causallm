# SPDX-License-Identifier: Apache-2.0
##
# @file prepare_encoder.ps1
# @brief Download the encoder archive and place json.hpp at the project root.
# @usage ./prepare_encoder.ps1 <build_dir> <version>

param (
    [string]$Target,
    [string]$TargetVersion
)

$TarPrefix = "encoder"
$TarName = "$TarPrefix-$TargetVersion.tar.gz"
$Url = "https://github.com/nnstreamer/nnstreamer-android-resource/raw/main/external/$TarName"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$ProjectRoot = Resolve-Path (Join-Path $ScriptDir "..")

Write-Output "PREPARING Encoder at $Target"

if (-Not (Test-Path $Target)) {
    New-Item -ItemType Directory -Path $Target | Out-Null
}

Push-Location $Target

function Download-Encoder {
    if (Test-Path $TarName) {
        Write-Output "$TarName exists, skip downloading"
        return
    }

    Write-Output "[Encoder] downloading $TarName"
    try {
        Invoke-WebRequest -Uri $Url -OutFile $TarName
        Write-Output "[Encoder] Finish downloading encoder"
    } catch {
        Write-Output "[Encoder] Download failed, please check url"
        exit 1
    }
}

function Untar-Encoder {
    Write-Output "[Encoder] untar encoder"
    tar -zxvf $TarName
    Remove-Item $TarName

    if ($TargetVersion -eq "0.2") {
        Copy-Item -Path "json.hpp" -Destination (Join-Path $ProjectRoot "json.hpp") -Force
        Write-Output "[Encoder] Copied json.hpp to $ProjectRoot"
    }
}

if (-Not (Test-Path "$TarPrefix")) {
    Download-Encoder
    Untar-Encoder
}

Pop-Location
