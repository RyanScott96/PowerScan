#Config Variables
$PSEmailServer = "localhost"
$Path = "./test"
#Insecure so keep messaging to an internal network
$Domain = "localhost"
$FromId = "power_scan"
$ToId = "rlscott"

#Set date time to current time
$Date = Get-Date -Format "dd-mm-yyyy"
$Time = Get-Date -Format "HH:mm:ss"
$DateTime = "$Date|$Time"

#Find all .pdfs that follow the format build#.pdf in the $PATH
$ScannedItems = Get-ChildItem -Path $Path | Where-Object -Property FullName -Match ".*\d+.*.pdf"

#For each .pdf create an email with the # as the ISSUE NUMBER
#and .pdf file as the attachment
$ScannedItems | ForEach-Object -Process {

    #Ticket number should be in the file name 
    $Number = $_.FullName -replace '\D+(\d+).pdf', '$1'
    $Subject = "Attach ISSUE=545-$Number"
    $Body = "Scanned build sheets batch uploaded at $DateTime"
    $_ | Send-MailMessage -From "$FromId@$Domain" -To "$ToId@$Domain" -Subject $Subject -Body $Body
}

#Delete the .pdfs
$ScannedItems | Remove-Item