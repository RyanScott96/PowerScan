#Config Variables
$PSEmailServer = "localhost"
$Domain = "localhost"
$FromId = "power_scan@$Domain"
$ToId = "rlscott@$Domain"

#Set date time to current time
$Date = Get-Date -Format "dd-mm-yyyy"
$Time = Get-Date -Format "HH:mm:ss"
$DateTime = "$Date|$Time"

#Find all .pdfs that follow the format build#.pdf in the $PATH
$ScannedItems = Get-ChildItem -Path ./tests | Where-Object -Property Name -Match "build\d+.pdf"

#For each .pdf create an email with the # as the ISSUE NUMBER
#and .pdf file as the attachment
$ScannedItems | ForEach-Object -Process {

    #Ticket number should be in the file name 
    $Number = $_.Name -replace '\D+(\d+).pdf', '$1'
    $Subject = "Attach ISSUE=545-$Number"
    $Body = "Scanned build sheets batch uploaded at $DateTime"
    $_ | Send-MailMessage -From $FromId -To $ToId -Subject $Subject -Body $Body
}

$ScannedItems | Remove-Item