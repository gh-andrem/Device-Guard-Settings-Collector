# Device-Guard-Settings-Collector
Powershell script that collects the Device Guard properties and running services (e.g. Credential Guard) from a system and maps it as CSV format

## Issue:
After we activated Credential Guard via GPO in the company I work for, we discovered that this does not work on all systems for various reasons, for example not activated Secure Boot, to name one.

## Solution:
In order to find out which systems are affected, I wrote a Powershell script that collects all the properties that I thought were needed and mapped them into a CSV format and wrote them to a file share. For example, the script can also be distributed to the desired target group of devices via GPO. Setting a registry key ensures that the script is only executed once on the corresponding target system. After subsequent data collection, the data can be imported into the XLSX template and evaluated for security configuration gaps. The meaning of the different keys and their values ​​was taken from the following Microsoft documentation. https://learn.microsoft.com/en-us/windows/security/hardware-security/enable-virtualization-based-protection-of-code-integrity
