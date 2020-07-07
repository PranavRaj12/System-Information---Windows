    
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

            Get-WmiObject win32_physicalmemory | Format-List * | Out-File $SysInfo -Append

            Add-Content $SysInfo "-----------BIOS--------------"

            "BIOS"

            Get-WmiObject -Class Win32_BIOS | Format-List * | Out-File $SysInfo -Append

            Add-Content $SysInfo "-----------CPU--------------"

            "CPU"

            Get-WmiObject Win32_Processor | Format-List * | Out-File $SysInfo -Append

            Add-Content $SysInfo "-----------GPU--------------"

            "GPU"

            Get-CimInstance CIM_VideoController | Format-List Caption,Description,DeviceID,SystemName,VideoMemoryType,VideoProcessor,AdapterCompatibility,AdapterDACType,AdapterRAM,DriverDate,DriverVersion |Out-File $SysInfo -Append

            Add-Content $SysInfo "-----------COMPUTER--------------"

            "COMPUTER SYSTEM"

            Get-CimInstance CIM_ComputerSystem | Format-List * | Out-File $SysInfo -Append

            Add-Content $SysInfo "-----------STORAGE--------------"

            "STORAGE"

            Get-PhysicalDisk | Format-List * | Out-File $SysInfo -Append

            "OPERATING SYSTEM"

            Add-Content $SysInfo "-----------OPERATING SYSTEM--------------"

            Get-CimInstance Win32_OperatingSystem | Format-List * | Out-File $SysInfo -Append

            Add-Content $SysInfo "-----------INSTALLED APPLICATIONS--------------"

            "INSTALLED APPLICATION"

            Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Format-Table –AutoSize | Out-File $SysInfo -Append

            Add-Content $SysInfo "-----------NETWORK ADAPTERS--------------"

            "NETWORK ADAPTERS"

            Get-NetAdapter -Name ethernet |Format-List * | Out-File $SysInfo -Append

            Add-Content $SysInfo "-----------PC FAN DETAILS--------------"
        
            "SYSTEM FANS"

            Get-CimInstance -ClassName Win32_Fan -Property * | Out-File $SysInfo -Append

            Add-Content $SysInfo "-----------BATTERY DETAILS--------------"
    
            "BATTERY"

            Get-WmiObject -class Win32_Battery |Format-List * | Out-File $SysInfo -Append

            Add-Content $SysInfo "-----------DEVICE DRIVERS--------------"

            "DEVICE DRIVERS"

            Get-WmiObject Win32_PnPSignedDriver| select DeviceName, Manufacturer, DriverVersion |Format-List * | Out-File $SysInfo -Append

           ""
            $Done
            $SysInfo
            Write-Host "Press any key to exit."
            $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

            }
        
       catch [Exception]
       {
          echo $_.Exception.GetType().FullName, $_.Exception.Message
          Write-Host "Press any key to exit."
            $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
       }

    }
