# Author: Dennis Barnekow
# Date: 11.01.2024
# Definition Win32_DeviceGuard keys and values: https://learn.microsoft.com/en-us/windows/security/hardware-security/enable-virtualization-based-protection-of-code-integrity

###############
### Control ###
###############
$versionRun = 1 # increase value by one to run once more

# check if regkey exist or create it for execute script only one time
try{$_ = Get-ItemPropertyValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -name "CollectDeviceGuardData" -ErrorAction Stop}
catch{Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "CollectDeviceGuardData" -Value 0}

# exit if already run once 
if((Get-ItemPropertyValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -name "CollectDeviceGuardData") -ge $versionRun){exit}


#############################
### Collect and send data ###
#############################
$settings = ""
$settings += (hostname)

$DeviceGuard = (Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard)


# AvailableSecurityProperties (This field helps to enumerate and report state on the relevant security properties for VBS and memory integrity.)
if($DeviceGuard.AvailableSecurityProperties -contains 0){$settings+=",1"}Else{$settings+=",0"} 	# 0.If present, no relevant properties exist on the device.								
if($DeviceGuard.AvailableSecurityProperties -contains 1){$settings+=",1"}Else{$settings+=",0"} 	# 1.If present, hypervisor support is available.
if($DeviceGuard.AvailableSecurityProperties -contains 2){$settings+=",1"}Else{$settings+=",0"}	# 2.If present, Secure Boot is available.
if($DeviceGuard.AvailableSecurityProperties -contains 3){$settings+=",1"}Else{$settings+=",0"}	# 3.If present, DMA protection is available.
if($DeviceGuard.AvailableSecurityProperties -contains 4){$settings+=",1"}Else{$settings+=",0"}	# 4.If present, Secure Memory Overwrite is available.
if($DeviceGuard.AvailableSecurityProperties -contains 5){$settings+=",1"}Else{$settings+=",0"}	# 5.If present, NX protections are available.
if($DeviceGuard.AvailableSecurityProperties -contains 6){$settings+=",1"}Else{$settings+=",0"} 	# 6.If present, SMM mitigations are available.
if($DeviceGuard.AvailableSecurityProperties -contains 7){$settings+=",1"}Else{$settings+=",0"}	# 7.If present, MBEC/GMET is available.
if($DeviceGuard.AvailableSecurityProperties -contains 8){$settings+=",1"}Else{$settings+=",0"}	# 8.If present, APIC virtualization is available.

# RequiredSecurityProperties (This field describes the required security properties to enable VBS.)
if($DeviceGuard.RequiredSecurityProperties -contains 0){$settings+=",1"}Else{$settings+=",0"}	# 0.Nothing is required.
if($DeviceGuard.RequiredSecurityProperties -contains 1){$settings+=",1"}Else{$settings+=",0"}	# 1.If present, hypervisor support is needed.
if($DeviceGuard.RequiredSecurityProperties -contains 2){$settings+=",1"}Else{$settings+=",0"}	# 2.If present, Secure Boot is needed.
if($DeviceGuard.RequiredSecurityProperties -contains 3){$settings+=",1"}Else{$settings+=",0"}	# 3.If present, DMA protection is needed.
if($DeviceGuard.RequiredSecurityProperties -contains 4){$settings+=",1"}Else{$settings+=",0"}	# 4.If present, Secure Memory Overwrite is needed.
if($DeviceGuard.RequiredSecurityProperties -contains 5){$settings+=",1"}Else{$settings+=",0"}	# 5.If present, NX protections are needed.
if($DeviceGuard.RequiredSecurityProperties -contains 6){$settings+=",1"}Else{$settings+=",0"}	# 6.If present, SMM mitigations are needed.
if($DeviceGuard.RequiredSecurityProperties -contains 7){$settings+=",1"}Else{$settings+=",0"}	# 7.If present, MBEC/GMET is needed.

# SecurityServicesConfigured (This field indicates whether Credential Guard or memory integrity has been configured.)
if($DeviceGuard.SecurityServicesConfigured -contains 0){$settings+=",1"}Else{$settings+=",0"}	# 0.No services are configured.
if($DeviceGuard.SecurityServicesConfigured -contains 1){$settings+=",1"}Else{$settings+=",0"} 	# 1.If present, Credential Guard is configured.
if($DeviceGuard.SecurityServicesConfigured -contains 2){$settings+=",1"}Else{$settings+=",0"}	# 2.If present, memory integrity is configured.
if($DeviceGuard.SecurityServicesConfigured -contains 3){$settings+=",1"}Else{$settings+=",0"}	# 3.If present, System Guard Secure Launch is configured.
if($DeviceGuard.SecurityServicesConfigured -contains 4){$settings+=",1"}Else{$settings+=",0"}	# 4.If present, SMM Firmware Measurement is configured.

# SecurityServicesRunning (This field indicates whether Credential Guard or memory integrity is running.)
if($DeviceGuard.SecurityServicesRunning -contains 1){$settings+=",1"}Else{$settings+=",0"}	# 1.If present, Credential Guard is running.
if($DeviceGuard.SecurityServicesRunning -contains 2){$settings+=",1"}Else{$settings+=",0"}	# 2.If present, memory integrity is running.
if($DeviceGuard.SecurityServicesRunning -contains 3){$settings+=",1"}Else{$settings+=",0"}	# 3.If present, System Guard Secure Launch is running.
if($DeviceGuard.SecurityServicesRunning -contains 4){$settings+=",1"}Else{$settings+=",0"} 	# 4.If present, SMM Firmware Measurement is running.

# VirtualizationBasedSecurityStatus (This field indicates whether VBS is enabled and running.)
# Value	Description
# 0.	VBS isn't enabled.
# 1.	VBS is enabled but not running.
# 2.	VBS is enabled and running.
$settings += ",$($DeviceGuard.VirtualizationBasedSecurityStatus)" 


# e.g. send data to SMB-Share
echo $settings >> \\srvXYZ\Collect-Data-Networkshare\deviceGuardSettings.txt


# increase regkey value for not running again  
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "CollectDeviceGuardData" -Value $versionRun