
# Clear le Terminal 
  

# Bannière et date/heure
Write-Host ""
Write-Host "============================================="
Write-Host "            POWERSHELL-AUDIT               "
Write-Host "============================================="

# Récupérer la date et l'heure actuelles
$currentDateTime = Get-Date
Write-Host "Date et Heure de l'audit: $currentDateTime"
Write-Host "============================================="
Write-Host ""

# Section: Informations sur le système d'exploitation

$osInfo = Get-CimInstance Win32_OperatingSystem
Write-Host "Audit du Système d'exploitation : $($osInfo.Caption) Version $($osInfo.Version)"
Write-Host "--------------------------------------------------"
Write-Host "=== Informations sur le système d'exploitation ==="
Write-Host "--------------------------------------------------"
Write-Host "Système d'exploitation : $($osInfo.Caption) Version $($osInfo.Version)"
Write-Host "Architecture           : $($osInfo.OSArchitecture)"
Write-Host "Installé le            : $($osInfo.InstallDate)"
Write-Host "Nom de l'ordinateur    : $($osInfo.CSName)"
Write-Host "------------------------------------------"
Write-Host ""

# Section: Informations sur le matériel
Write-Host "--------------------------------------------------"
Write-Host "=== Informations sur le matériel ==="
Write-Host "--------------------------------------------------"
$hardwareInfo = Get-CimInstance Win32_ComputerSystem
Write-Host "Fabricant du PC        : $($hardwareInfo.Manufacturer)"
Write-Host "Modèle du PC           : $($hardwareInfo.Model)"
Write-Host "Nombre de processeurs  : $($hardwareInfo.NumberOfProcessors)"
Write-Host "Nombre de coeurs       : $($hardwareInfo.NumberOfLogicalProcessors)"
Write-Host ""

# Informations sur la RAM
Write-Host "--------------------------------------------------"
Write-Host "=== Informations sur la RAM ==="
Write-Host "--------------------------------------------------"
$ramModules = Get-CimInstance Win32_PhysicalMemory
foreach ($ram in $ramModules) {
    $ramSizeGB = [math]::round($ram.Capacity / 1GB, 2)
    Write-Host "Module RAM             : $($ram.DeviceLocator)"
    Write-Host "  Capacité             : $ramSizeGB GB"
    Write-Host "  Vitesse              : $($ram.Speed) MHz"
    Write-Host "------------------------------------------"
}
Write-Host ""

# Section: Informations sur le stockage
Write-Host "--------------------------------------------------"
Write-Host "=== Informations sur le stockage ==="
Write-Host "--------------------------------------------------"
$drives = Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } # 3 corresponds to local disks
foreach ($drive in $drives) {
    $sizeGB = [math]::round($drive.Size / 1GB, 2)
    $freeSpaceGB = [math]::round($drive.FreeSpace / 1GB, 2)
    Write-Host "Lecteur: $($drive.DeviceID)"
    Write-Host "  Taille: $sizeGB GB"
    Write-Host "  Espace libre: $freeSpaceGB GB"
    Write-Host "------------------------------------------"
}
Write-Host ""

# Informations sur la carte graphique
Write-Host "--------------------------------------------------"
Write-Host "=== Informations sur la carte graphique ==="
Write-Host "--------------------------------------------------"
$videoControllers = Get-CimInstance Win32_VideoController
foreach ($controller in $videoControllers) {
    $controllerRAMGB = [math]::round($controller.AdapterRAM / 1GB, 2)
    Write-Host "Carte graphique        : $($controller.Name)"
    Write-Host "  Mémoire vidéo        : $controllerRAMGB GB"
    Write-Host "  Processeur vidéo     : $($controller.VideoProcessor)"
    Write-Host "------------------------------------------"
}
Write-Host ""

# Section: Utilisateurs locaux et leurs rôles
Write-Host "--------------------------------------------------"
Write-Host "=== Utilisateurs locaux et leurs rôles ==="
Write-Host "--------------------------------------------------"
$users = Get-LocalUser
foreach ($user in $users) {
    $userGroups = Get-LocalGroup | ForEach-Object {
        try {
            Get-LocalGroupMember -Group $_.Name | Where-Object { $_.Name -eq $user.Name }
        }
        catch {
            # Ignore errors for groups where the user is not a member
        }
    }
    $groupNames = $userGroups | ForEach-Object { $_.Group }
    Write-Host "Utilisateur            : $($user.Name)"
    Write-Host "  Description          : $($user.Description)"
    Write-Host "  Activé               : $($user.Enabled)"
    Write-Host "  Expire               : $($user.AccountExpires)"
    Write-Host "  Membre des groupes   : $($groupNames -join ', ')"
    Write-Host "------------------------------------------"
}
Write-Host ""

# Section: Logiciels installés
Write-Host "=== Logiciels installés ==="
$software = Get-CimInstance -ClassName Win32_Product
foreach ($app in $software) {
    Write-Host " - $($app.Name)"
}
Write-Host "------------------------------------------"
Write-Host ""


# Temps de d'exécution du script



# Stocker les résultats dans un fichier texte
$auditResults = @"
# Bannière et date/heure
Write-Host "============================================="
Write-Host "            POWERSHELL-AUDIT               "
Write-Host "============================================="

# Récupérer la date et l'heure actuelles
$currentDateTime = Get-Date
Write-Host "Date et Heure de l'audit: $currentDateTime"
Write-Host "============================================="
Write-Host ""

# Section: Informations sur le système d'exploitation

$osInfo = Get-CimInstance Win32_OperatingSystem
Audit du Système d'exploitation : $($osInfo.Caption) Version $($osInfo.Version)
 
=== Informations sur le système d'exploitation ===
Système d'exploitation : $($osInfo.Caption) Version $($osInfo.Version)
Architecture           : $($osInfo.OSArchitecture)
Installé le            : $($osInfo.InstallDate)
Nom de l'ordinateur    : $($osInfo.CSName)
------------------------------------------
------------------------------------------

=== Informations sur le matériel ===
Fabricant du PC        : $($hardwareInfo.Manufacturer)
Modèle du PC           : $($hardwareInfo.Model)
Nombre de processeurs  : $($hardwareInfo.NumberOfProcessors)
Nombre de coeurs       : $($hardwareInfo.NumberOfLogicalProcessors)
------------------------------------------

=== Informations sur la RAM ===
"@

foreach ($ram in $ramModules) {
    $ramSizeGB = [math]::round($ram.Capacity / 1GB, 2)
    $auditResults += "Module RAM             : $($ram.DeviceLocator)`n"
    $auditResults += "  Capacité             : $ramSizeGB GB`n"
    $auditResults += "  Vitesse              : $($ram.Speed) MHz`n"
    $auditResults += "------------------------------------------`n"
}

$auditResults += "=== Informations sur la carte graphique ===`n"
foreach ($controller in $videoControllers) {
    $controllerRAMGB = [math]::round($controller.AdapterRAM / 1GB, 2)
    $auditResults += "Carte graphique        : $($controller.Name)`n"
    $auditResults += "  Mémoire vidéo        : $controllerRAMGB GB`n"
    $auditResults += "  Processeur vidéo     : $($controller.VideoProcessor)`n"
    $auditResults += "------------------------------------------`n"
}

$auditResults += "=== Logiciels installés ===`n"
foreach ($app in $software) {
    $auditResults += " - $($app.Name)`n"
}
$auditResults += "------------------------------------------`n"

$auditResults += "=== Informations sur le stockage ===`n"
foreach ($drive in $drives) {
    $sizeGB = [math]::round($drive.Size / 1GB, 2)
    $freeSpaceGB = [math]::round($drive.FreeSpace / 1GB, 2)
    $auditResults += "Lecteur: $($drive.DeviceID)`n"
    $auditResults += "  Taille: $sizeGB GB`n"
    $auditResults += "  Espace libre: $freeSpaceGB GB`n"
    $auditResults += "------------------------------------------`n"
}

$auditResults += "=== Utilisateurs locaux et leurs rôles ===`n"
foreach ($user in $users) {
    $userGroups = Get-LocalGroup | ForEach-Object {
        try {
            Get-LocalGroupMember -Group $_.Name | Where-Object { $_.Name -eq $user.Name }
        }
        catch {
            # Ignore errors for groups where the user is not a member
        }
    }
    $groupNames = $userGroups | ForEach-Object { $_.Group }
    $auditResults += "Utilisateur            : $($user.Name)`n"
    $auditResults += "  Description          : $($user.Description)`n"
    $auditResults += "  Activé               : $($user.Enabled)`n"
    $auditResults += "  Expire               : $($user.AccountExpires)`n"
    $auditResults += "  Membre des groupes   : $($groupNames -join ', ')`n"
    $auditResults += "------------------------------------------`n"
}

# Définir le chemin du fichier de sortie dans le même dossier que le script
$outputFilePath = Join-Path -Path $PSScriptRoot -ChildPath "audit_results.txt"

# Enregistrer les résultats de l'audit dans le fichier texte
Set-Content -Path $outputFilePath -Value $auditResults

Write-Host "Les résultats de l'audit ont été enregistrés dans le fichier: $outputFilePath"
Write-Host "By H@ckthus, Email: hackthus@gmail.com"
