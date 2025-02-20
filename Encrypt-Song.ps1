<#
.SYNOPSIS
This scripts encrypts custom songs for Synth Riders to prevent drafts from being modified.

.DESCRIPTION
This script uses 7-Zip to create an encrypted ZIP file containing a custom song for Synth Riders.

.NOTES
No part of this script is in any form associated with Synth Riders or Kluge Interactive. Use at your own risk.

.LICENSE
MIT

.Parameter SongFile
Name of the song file to encrypt.

.Parameter Password
Passwort for encrypt the song. Must be a special password that no one knows. One can only try a few ¯\_(ツ)_/¯

.Parameter 7ZipPath
Path to 7-Zip executable. Default is "C:\Program Files\7-Zip\7z.exe".

.Parameter OutputDirectory
Directory to output the encrypted *.synth file. By default, it creates a directory "EncryptedSongs" in the current working directory.

.Parameter AppendEncrypted
Append ".encrypted" to the output file name. Default is false(since they get saved into a seperate directory).

.Parameter OverwriteExistingOutputFile
Overwrite the output file if it already exists. Default is false.

.EXAMPLE
Encrypt-Song.ps1 -Password nobodyknows -SongFile .\unencryptedDraft.synth

#>
[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [string]$SongFile,
    [Parameter(Mandatory = $true)]
    [string]$Password,
    [string]$7ZipPath = "C:\Program Files\7-Zip\7z.exe",
    [string]$OutputDirectory = "EncryptedSongs",
    [switch]$AppendEncrypted = $false,
    [switch]$OverwriteExistingOutputFile = $false
)
# Check Input File
$SongFile = $SongFile -replace '^[.\/\\]+', '' -replace '[\/\\]+$', ''
$FilePath = Resolve-Path $SongFile
if (-not (Test-Path $FilePath -PathType Leaf))
{
    Write-Host "Error: File '$FilePath' not found." -ForegroundColor Red
    exit 1
}
if (-not (Test-Path $7ZipPath))
{
    Write-Host "Error: 7-Zip not found at '$7ZipPath'. Install it first: winget install -e --id 7zip.7zip" -ForegroundColor Red
    exit 1
}
# Use SongFile name as default output file name if not specified
if (-not $OutputFileName)
{
    $OutputFileName = $FilePath | Split-Path -Leaf
    if ($AppendEncrypted)
    {
        $OutputFileName = "$OutputFileName.encrypted"
    }
}
# create OutputDirectory if not exists
if (-not (Test-Path $OutputDirectory -PathType Container))
{
    New-Item -Path $OutputDirectory -ItemType Directory | Out-Null
}
$OutputFileName = Join-Path $OutputDirectory $OutputFileName

# Check if output file exists
if (-not $OverwriteExistingOutputFile -and (Test-Path $OutputFileName -PathType Leaf))
{
    Write-Host "Error: Output file '$OutputFileName' already exists. Use -OverwriteExistingOutputFile to overwrite." -ForegroundColor Red
    exit 1
}


# Define temporary extraction folder
$TempExtractPath = "$env:TEMP\ExtractedSynth"
if (Test-Path $TempExtractPath)
{
    Remove-Item -Recurse -Force $TempExtractPath
}
New-Item -Path $TempExtractPath -ItemType Directory | Out-Null

Write-Host "Extracting '$FilePath' to '$TempExtractPath'..." -ForegroundColor Yellow
& $7ZipPath x "$FilePath" -o"$TempExtractPath" -y



Write-Host "Encrypting files inside the archive..." -ForegroundColor Yellow
& $7ZipPath a -tzip "$OutputFileName" "$TempExtractPath\*" -mm=Deflate -mem=AES256 -p"$Password" -mtm-

Remove-Item -Recurse -Force $TempExtractPath

Write-Host "Encrypted file created: $OutputFileName" -ForegroundColor Green