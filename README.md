# Device Guard Settings Collector (v2)
PowerShell script that collects the Device Guard properties and running services (e.g. Credential Guard, Memory Integrity, Firmware Protection, Secure Boot, TPM) from a system and maps it as CSV format.

## Solution:
The solution was initially created by [barneee](https://github.com/Barneee/Device-Guard-Settings-Collector) for delivery via group policy. The script collects all the necessary information and the results from each device are written to a file on a file share. That file can then be imported into the Excel template (found in the repository).

As I have quite a few devices enrolled to Intune without a connection to an on-prem file share, I needed this to work natively with Intune. The script runs as a remediation script (Intune > Devices > Windows > Scripts and remediations) once at a specific time. It returns the results from each device into the `Pre-remediation detection output` column (device status menu of the remediation script). These results can then be exported from Intune and imported into the Excel template.  

See the different values for each setting at [Validate enabled VBS and memory integrity features | Microsoft Docs](https://learn.microsoft.com/en-us/windows/security/hardware-security/enable-virtualization-based-protection-of-code-integrity#validate-enabled-vbs-and-memory-integrity-features)
