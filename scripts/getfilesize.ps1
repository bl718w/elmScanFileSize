param(
  [Parameter(Mandatory=$true, HelpMessage="Enter the file path.")]
  [String]$filepath
)

$objFile = Get-ItemProperty -Path "$filepath"
$filesize = $objFile.Length / 1GB
if ($filesize -gt 0.5) {
  $instanceid = (invoke-webrequest http://169.254.169.254/latest/meta-data/instance-id -UseBasicParsing).content
  Write-Host ">>>> $('{0,-15} {1,-20} {2,-10} {3,-40}' -f $(hostname), $instanceid, $('{0:n2} GB' -f $filesize), $objFile.FullName)"
}

