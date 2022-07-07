Function Invoke-AnkhSave {
  <#
  .SYNOPSIS
    This script will save files specified in the config.json file to the given location

  .NOTES
    Name: Invoke-AnkhSave
    Author: JL
    Version: 1.1
    LastUpdated: 2022-Mar-15

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
    [object[]]  $Locations
  )

  BEGIN {
    Write-Host $banner -f Blue

    $day, $time = ((Get-Date -format 'u') -split ' ')
    $copiedFiles, $errors = 0

    Write-Host "Copying files from $($Locations.length) directories..."
  }

  PROCESS {
    # Copying files from every location
    foreach ($save in $Locations) {
      # Test for necessary keys in save object
      if ($save.name -and $save.path -and $save.destination) {
        $fullPath = "$($save.path)/$($save.name)"
        if (Test-Path $fullPath) {
          [array]$files = Get-ChildItem -Path $fullPath -Recurse:($save.recurse ?? $false)

          # Saving files to given location
          foreach ($file in $files) {
            # Progress
            $percent = [math]::Round($files.IndexOf($file) / $Locations.length * 100, 2)
            Write-Progress -Activity "Saving files to $($save.destination)..." -Status "$percent% completed..." -CurrentOperation "Saving $($file.name)" -PercentComplete $percent

            # Copy file to destination
            $copied = Copy-File -File $file -Destination $save.destination -Suffix "_$($day.Replace('-', ''))" -Overwrite
            if ($copied) { $copiedFiles++ } else { $errors++ }
          }

          Write-Progress -Activity "Saving files to $($save.destination)..." -Status "100% completed..." -Completed

        } else { Write-Host "$fullPath is not a valid path !" -f Red }
      } else { Write-Host "Missing properties for this save !" -f Red }
    }
  }

  END {
    Write-Host "Saving took $(Get-TimeDiff $startTime $endTime)"
    Write-Host "$copiedFiles were copied; $errors errors occured !"
  }
}