param(
  [Parameter(Mandatory=$true, HelpMessage="Enter the full path to the file or folder.")]
  [String]$FilePath,
  [Parameter(Mandatory=$true, HelpMessage="Enter the file or folder size to track.")]
  [int]$SizeInMB
)

if (Test-Path -Path "$FilePath") {
  if ((Get-Item "$FilePath") -is [System.IO.DirectoryInfo]) {
    $objPath = Get-ChildItem -Path "$FilePath" -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum | Select-Object Sum, Count
    $pathsize = $objPath.Sum / 1MB
    $filecount = $objPath.Count
  } else {
    $objPath = Get-ItemProperty -Path "$FilePath"
    $pathsize = $objPath.Length / 1MB
    $filecount = 1
  }

  if ($pathsize -gt $SizeInMB) {
    $instanceid = (invoke-webrequest http://169.254.169.254/latest/meta-data/instance-id -UseBasicParsing).content
    Write-Host ">>>> $('{0,-15} {1,-20} {2,-12} {3,-7} {4,-40}' -f $(hostname), $instanceid, $('{0:n2} MB' -f $pathsize), $('{0:n0}' -f $filecount), $FilePath)"
  }
} 

