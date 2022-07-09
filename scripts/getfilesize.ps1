param(
  [Parameter(Mandatory=$true, HelpMessage="Enter the file path.")]
  [String]$FilePath,
  [Parameter(Mandatory=$true, HelpMessage="Enter the file path.")]
  [int]$SizeInMB
)

$objFile = Get-ItemProperty -Path "$FilePath"
$filesize = $objFile.Length / 1MB
if ($filesize -gt $SizeInMB) {
  $instanceid = (invoke-webrequest http://169.254.169.254/latest/meta-data/instance-id -UseBasicParsing).content
  Write-Host ">>>> $('{0,-15} {1,-20} {2,-10} {3,-40}' -f $(hostname), $instanceid, $('{0:n2} MB' -f $filesize), $objFile.FullName)"
}

