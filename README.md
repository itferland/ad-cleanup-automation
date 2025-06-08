# Active Directory Cleanup Automation (PowerShell)

## Overview

This PowerShell script automates the cleanup of Active Directory user accounts, helping organizations quickly identify and remediate inactive or orphaned accounts. Designed for IT administrators, the script improves security posture, streamlines compliance audits, and reduces manual AD maintenance effort.

## Features

- Finds and reports inactive user accounts (configurable inactivity threshold, default 90 days)
- Exports results to a CSV report for review or audit purposes
- Optionally disables (or deletes) accounts directly from the script
- Supports dry-run (test) mode to prevent accidental changes
- Easily extensible for group cleanup, OU management, or email notifications

## Parameters

The script supports the following parameters:

- `DaysInactive` (Integer): Number of days a user must be inactive to be flagged. Default: `90`.
- `CsvOutputPath` (String): Path to save the CSV report. Default: `InactiveADUsers.csv` in the script's directory.
- `DryRun` (Switch): If present, the script will only report what actions it would take, without making changes.
- `Verbose` (Switch): Enables detailed operational output.
- `Confirm` (Switch): Prompts for confirmation before performing actions like disabling an account (if the disable logic is uncommented).

## Usage

1. Clone this repo or copy the script to your management workstation.
2. Ensure the ActiveDirectory PowerShell module is installed.
3. Run the script. By default, it runs in a "safe" mode where it only reports inactive users.
   To see what actions it would take (like disabling accounts), use the -DryRun switch:
   ```powershell
   .d_inactive_user_cleanup.ps1 -DryRun -Verbose
   ```
   To specify a different inactivity period, for example 120 days:
   ```powershell
   .d_inactive_user_cleanup.ps1 -DaysInactive 120
   ```
   To change the output file path:
   ```powershell
   .d_inactive_user_cleanup.ps1 -CsvOutputPath "C:	emp\InactiveReport.csv"
   ```
4. Review the `InactiveADUsers.csv` report.  
5. To actually disable the accounts, you must:
   a. Uncomment the `ForEach-Object` block containing the `Disable-ADAccount` cmdlet within the `ad_inactive_user_cleanup.ps1` script.
   b. Run the script *without* the `-DryRun` switch.
   It's highly recommended to use the `-Confirm` switch (which works due to `SupportsShouldProcess`) to get prompted for each account:
   ```powershell
   .d_inactive_user_cleanup.ps1 -Confirm
   ```
   Or, to proceed without individual confirmation (use with extreme caution):
   ```powershell
   .d_inactive_user_cleanup.ps1
   ```

> **Important:**
> - Always test this script in a non-production environment or on a limited, non-critical OU first.
> - By default, the account disabling logic is commented out in the script. You must edit the script to enable it.
> - Use the `-DryRun` parameter to understand potential changes before making them.
> - Consider using the `-Confirm` parameter when enabling accounts to review each action.

## Why Automate AD Cleanup?

Inactive and orphaned accounts present security risks and compliance challenges. Automating their identification and remediation:
- Reduces attack surface
- Satisfies audit requirements (PCI, CJIS, etc.)
- Saves time for IT staff

## Author

Eric Ferland  
[LinkedIn](https://www.linkedin.com/in/eferland) | [GitHub](https://github.com/itferland)

---

Feel free to fork, modify, or use this script for your own environment.
