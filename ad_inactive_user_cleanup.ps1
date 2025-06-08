<#
.SYNOPSIS
    Identifies and optionally disables inactive Active Directory user accounts.
.DESCRIPTION
    This script searches for user accounts that have not logged in for a specified number of days.
    It can generate a CSV report of these users and, if not in DryRun mode, disable them.
    The LastLogonTimestamp attribute is used for determining inactivity.
.PARAMETER DaysInactive
    Specifies the number of days of inactivity after which a user is considered inactive. Default is 90.
.PARAMETER CsvOutputPath
    Specifies the path for the CSV report of inactive users. Default is "InactiveADUsers.csv".
.PARAMETER DryRun
    If specified, the script will report actions it would take but not execute them (e.g., not disable accounts).
.EXAMPLE
    .d_inactive_user_cleanup.ps1 -Verbose
    Runs the script with default settings and shows verbose output.
.EXAMPLE
    .d_inactive_user_cleanup.ps1 -DaysInactive 120 -CsvOutputPath "C:	emp\OldUsers.csv"
    Finds users inactive for 120 days and saves the report to C:	emp\OldUsers.csv.
.EXAMPLE
    .d_inactive_user_cleanup.ps1 -DryRun
    Lists users that would be disabled but does not disable them.
.NOTES
    Requires the Active Directory PowerShell module.
    Run with Administrator privileges, or at least privileges to read user attributes and disable accounts.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory=$false)]
    [int]$DaysInactive = 90,

    [Parameter(Mandatory=$false)]
    [string]$CsvOutputPath = "InactiveADUsers.csv",

    [Parameter(Mandatory=$false)]
    [switch]$DryRun
)

# ADUC Cleanup Script - Disable Inactive AD Users and Generate Report

# Import AD Module (Windows Server/RSAT required)
try {
    # Load necessary Active Directory module.
    Import-Module ActiveDirectory -ErrorAction Stop
    Write-Verbose "Active Directory module loaded successfully."
}
catch {
    Write-Error "Error: Active Directory module could not be loaded. Please ensure it is installed."
    exit 1
}

# Calculate the date threshold for inactivity.
$Time = (Get-Date).AddDays(-$DaysInactive)
Write-Verbose "Inactivity threshold date set to: $Time"

# Find inactive users
Write-Verbose "Querying Active Directory for inactive users..."
# LastLogonTimestamp is replicated and generally preferred over LastLogonDate, but it's not updated in real-time. LastLogonDate is included for informational comparison if needed.
# Retrieve AD users who are enabled and whose LastLogonTimestamp is older than the calculated threshold.
$InactiveUsers = Get-ADUser -Filter {Enabled -eq $True -and LastLogonTimestamp -lt $Time} -Properties LastLogonTimestamp,LastLogonDate
Write-Verbose "Found $($InactiveUsers.Count) inactive user(s)."

# Output report of users to be disabled
# Export the list of inactive users to a CSV file.
Write-Verbose "Exporting inactive user list to $CsvOutputPath..."
$InactiveUsers | Select-Object Name, SamAccountName, LastLogonTimestamp, LastLogonDate | Export-Csv $CsvOutputPath -NoTypeInformation
Write-Verbose "Inactive user list exported successfully."

# Action: Disable inactive accounts if not in DryRun mode and confirmed.
# Disable accounts (Uncomment the ForEach-Object line and ensure -DryRun is not specified for production use!)
# $InactiveUsers | ForEach-Object {
#     if ($DryRun) {
#         Write-Warning "DryRun: Would disable user $($_.SamAccountName)."
#     } elseif ($PSCmdlet.ShouldProcess($_.SamAccountName, "Disable Account")) {
#         Disable-ADAccount $_
#         Write-Verbose "Action: Successfully disabled user $($_.SamAccountName)."
#     }
# }

Write-Host "$($InactiveUsers.Count) inactive user accounts found and reported."
Write-Host "Report saved to $CsvOutputPath"
# (You can also email the report or add notification steps)
