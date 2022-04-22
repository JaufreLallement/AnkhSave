function Copy-File {
  <#
  .SYNOPSIS
    This script will copy the given file to the provided location

  .NOTES
    Name: Copy-File
    Author: JL
    Version: 1.0
    LastUpdated: 2022-Apr-21

  .EXAMPLE

  #>

  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [object]  $File,

    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [string]  $Destination,

    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [string]  $Prefix = $null,

    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [string]  $Suffix = $null,

    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [switch]  $Overwrite = $false
  )

  BEGIN {
    # Split file name into actual name and extension
    $fileName, $fileExtension = $File.BaseName, $File.Extension
    $copied = $false
  }

  PROCESS {
    if (Test-Path $Destination) {
      try {
        $File | Copy-Item -Destination "$Destination\$Prefix$fileName$Suffix$fileExtension" -Force:$Overwrite
        $copied = $true
      } catch { Write-Error "Failed to copy $fileName : `n$_" }
    } else { Write-Host "$Destination is not a valid Destination !" -f Red }

    if ($copied) { Write-Host "$fileName was copied successfully !" -f Green }
    else { Write-Host "Could not copy $fileName" -f Red }
  }

  END { return $copied }
}