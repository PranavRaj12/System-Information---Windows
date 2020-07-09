     
     $MajorVersion= (Get-Host).Version.Major
     $filepath ="C:\SYS_INFO\SYSTEM_INFORMATION.txt"
     $dirpath ="C:\SYS_INFO"
     $PrintVersion= "PowerShell Version: " + $MajorVersion
     $UpdateNotification = "WARNING: Seems like you are running a lower version of PowerShell, Some of the commands might not work. Upgrade to verison 5 and above to get all the system details."
     $PrintVersion

     ## Checking if verison is less than required

     if($MajorVersion -lt 5)
     {
            $UpdateNotification
     }

     ""
     #Check for the directory

     if(![System.IO.Directory]::Exists($dirpath))
     {
            "Creating directory"     
            New-Item -Path "C:\" -Name "SYS_INFO" -ItemType "directory"
     }

    #Checking for the file

    if(![System.IO.File]::Exists($filepath))
    {
                "Creating file"        
            New-Item -path 'C:\SYS_INFO' -name SYSTEM_INFORMATION.txt -type file -Force
    }

    if([System.IO.Directory]::Exists($dirpath) -and [System.IO.File]::Exists($filepath))
    {
        
         try
          {

            $SysInfo ="C:\SYS_INFO\SYSTEM_INFORMATION.txt"
            $Start ="Fetching system details:"
            $Done= "Script execution completed. You can find the file here:"

            #Writing contents to the file

            ""
            $Start

            ""
            "RAM"

            "-----------RAM--------------" | Out-File $SysInfo

            Get-WmiObject win32_physicalmemory | Format-List Manufacturer,Name,PartNumber,Speed, @{n="Capacity(GB)";e={[math]::Round($_.Capacity/1GB,2)}} ,BankLabel,MaxVoltage,MinVoltage | Out-File $SysInfo -Append

            Add-Content $SysInfo "-----------BIOS--------------"

            "BIOS"

            Get-WmiObject -Class Win32_BIOS | Format-List Name,BIOSVersion,CurrentLanguage,Manufacturer,Version | Out-File $SysInfo -Append

            Add-Content $SysInfo "-----------CPU--------------"

            "CPU"

            Get-WmiObject Win32_Processor | Format-List Manufacturer,Name,NumberOfCores,NumberOfEnabledCore,NumberOfLogicalProcessors,ThreadCount,VirtualizationFirmwareEnabled,
            DeviceID,LoadPercentage,Status,AddressWidth,DataWidth,L2CacheSize,L3CacheSize,MaxClockSpeed,Caption| Out-File $SysInfo -Append

            Add-Content $SysInfo "-----------GPU--------------"

            "GPU"

            Get-CimInstance CIM_VideoController | Format-List Caption,Description,DeviceID,SystemName,VideoMemoryType,VideoProcessor,AdapterCompatibility,
            AdapterDACType,@{n="Capacity(GB)";e={[math]::Round($_.AdapterRAM/1GB,2)}},DriverDate,DriverVersion |Out-File $SysInfo -Append

            Add-Content $SysInfo "-----------COMPUTER--------------"

            "COMPUTER SYSTEM"

            Get-CimInstance CIM_ComputerSystem | Format-List BootupState,Status,PrimaryOwnerName,Manufacturer,Model,UserName,Roles,Domain,HypervisorPresent,InfraredSupported | Out-File $SysInfo -Append

            Add-Content $SysInfo "-----------STORAGE--------------"

            "STORAGE"

            Get-PhysicalDisk | Format-List UniqueId,FriendlyName,HealthStatus,Model,OperationalStatus,@{n="AllocatedSize(GB)";e={[math]::Round($_.AllocatedSize/1GB,3)}},
            MediaType,BusType,@{n="Capacity(GB)";e={[math]::Round($_.Size/1GB,3)}},ClassName | Out-File $SysInfo -Append
        

            Get-PSDrive | Out-File $SysInfo -Append

            "OPERATING SYSTEM"

            Add-Content $SysInfo "-----------OPERATING SYSTEM--------------"

            Get-CimInstance Win32_OperatingSystem | Format-List Status,Name,FreePhysicalMemory,FreeSpaceInPagingFiles,Caption,InstallDate,LastBootUpTime,NumberOfUsers,BuildNumber,
            BuildType,EncryptionLevel,OSArchitecture,RegisteredUser,SerialNumber | Out-File $SysInfo -Append

            Add-Content $SysInfo "-----------NETWORK ADAPTERS--------------"

            "NETWORK ADAPTERS"

            Get-NetAdapter -Name ethernet |Format-List MacAddress,Status,LinkSpeed,DriverInformation,InterfaceAlias,DeviceID,DriverDate,DriverName,DriverProvider,InterfaceDescription,
            InterfaceType | Out-File $SysInfo -Append

            Add-Content $SysInfo "-----------BATTERY DETAILS--------------"
    
            "BATTERY"

            Get-WmiObject -class Win32_Battery |Format-List Caption,Chemistry,Description,Status,PowerManagementSupported,EstimatedRunTime,EstimatedChargeRemaining | Out-File $SysInfo -Append

            Add-Content $SysInfo "-----------DISPLAY DETAILS--------------"
    
            "DISPLAY"

            Get-WmiObject win32_desktopmonitor | Out-File $SysInfo -Append

            
            Invoke-Item $filepath

            }
        
       catch [Exception]
       {
          echo $_.Exception.GetType().FullName, $_.Exception.Message
          Write-Host "Press any key to exit."
            $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
       }

    }
