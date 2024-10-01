# Define parameters
$Directory = "C:\Path\To\Directory"  # Replace with the path to your target directory
$LogFile = "C:\Path\To\DeletionLog.txt"  # Replace with the path to your log file
$AuditLogFile = "C:\Path\To\AuditLog.txt"  # Replace with the path to your audit log file

$DaysOldToDelete = 90 # At how many days old should the files be deleted

# Check if the directory exists
if (!(Test-Path -Path $Directory)) {
    Write-Output "The directory $Directory does not exist. Exiting script."
    Exit 1
}

# Get the current date and time for logging
$CurrentDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Add a header to the log and audit files for this run
$LogHeader = "`n--- Deletion Run: $CurrentDateTime ---`n"
$AuditHeader = "`n--- Audit Run: $CurrentDateTime ---`n"

# Log headers
Add-Content -Path $LogFile -Value $LogHeader
Add-Content -Path $AuditLogFile -Value $AuditHeader

# Find and delete files older than 90 days
$Files = Get-ChildItem -Path $Directory -File -Recurse | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(0 - $DaysOldToDelete) }

foreach ($File in $Files) {
    try {
        # Log file details before deletion (audit)
        $AuditLogEntry = "$CurrentDateTime - File: $($File.FullName) - LastWriteTime: $($File.LastWriteTime)"
        Add-Content -Path $AuditLogFile -Value $AuditLogEntry

        # Delete the file
        Remove-Item -Path $File.FullName -Force

        # Log deletion (primary log)
        $LogEntry = "$CurrentDateTime - Deleted: $($File.FullName)"
        Add-Content -Path $LogFile -Value $LogEntry

        # Console output
        Write-Output "Deleted: $($File.FullName)"
    }
    catch {
        # Log errors to audit file
        $ErrorLogEntry = "$CurrentDateTime - Error Deleting: $($File.FullName) - Error: $_"
        Add-Content -Path $AuditLogFile -Value $ErrorLogEntry

        # Console output for errors
        Write-Warning "Failed to delete: $($File.FullName). Error: $_"
    }
}

Write-Output "Deletion process completed."
