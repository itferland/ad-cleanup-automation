# Active Directory Cleanup Automation (PowerShell)

## Overview

This PowerShell script automates the cleanup of Active Directory user accounts, helping organizations quickly identify and remediate inactive or orphaned accounts. Designed for IT administrators, the script improves security posture, streamlines compliance audits, and reduces manual AD maintenance effort.

## Features

- Finds and reports inactive user accounts (configurable inactivity threshold, default 90 days)
- Exports results to a CSV report for review or audit purposes
- Optionally disables (or deletes) accounts directly from the script
- Supports dry-run (test) mode to prevent accidental changes
- Easily extensible for group cleanup, OU management, or email notifications

## Usage

1. Clone this repo or copy the script to your management workstation.
2. Ensure the ActiveDirectory PowerShell module is installed.
3. Run the script in test mode to generate an audit report:
    ```powershell
    .\ADUC_Cleanup.ps1
    ```
4. Review the `InactiveADUsers.csv` report.  
5. Uncomment the `Disable-ADAccount` line to enforce remediation.

> **Note:** Always test in a lab or on a small subset before applying to production.

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
