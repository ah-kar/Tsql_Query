$backupFolder = "E:\Backups"
$daysOld = 7

Get-ChildItem -Path $backupFolder -Filter *.bak -Recurse | Where-Object {
    $_.LastWriteTime -lt (Get-Date).AddDays(-$daysOld)
} | Remove-Item -Force
