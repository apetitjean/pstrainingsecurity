<#
.SYNOPSIS
   Retourne des informations système en allant chercher les données dans le sous-système WMI.

.DESCRIPTION
   Retourne les informations suivantes : 
      - Nom du constructeur,
      - Quantité de mémoire installée en Go,
      - Nom du système d'exploitation,
      - Version de l'OS,
      - Date d'installation du système.
      
.EXAMPLE
   ./Get-SysInfo.ps1

.NOTES
   Version 1.0, par Arnaud PETITJEAN - Start-Scripting.io
#>

$CIMComputerSystem  = Get-CimInstance -ClassName Win32_ComputerSystem
$CIMOperatingSystem = Get-CimInstance -ClassName Win32_operatingSystem

[PSCustomObject]@{
    Manufacturer = $CIMComputerSystem.Manufacturer
    Memory       = [int]($CIMComputerSystem.TotalPhysicalMemory / 1GB)
    OS           = $CIMOperatingSystem.Caption
    Version      = $CIMOperatingSystem.Version
    InstallDate  = $CIMOperatingSystem.InstallDate
}