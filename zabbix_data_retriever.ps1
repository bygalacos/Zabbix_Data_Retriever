#  Version:        1.0
#  Author:         bygalacos
#  Github:         github.com/bygalacos
#  Creation Date:  05.02.2023
#  Purpose/Change: Initial script development

$zabbixURL = "http://your_zabbix_ip_adress/zabbix"
$userName = "your_zabbix_username"
$userPassword = "your_zabbix_password"

$loginPostData = @{name=$userName;password=$userPassword;enter="Enter"}
$login = Invoke-WebRequest -Uri "$zabbixURL/index.php" -Method Post -Body $loginPostData -SessionVariable sessionZabbix

function getDataValue($itemId) {
  $zabbixDataUrl = "$zabbixURL/history.php?itemids%5B0%5D=$itemId&action=showvalues&plaintext=As+plain+text"
  $data = Invoke-WebRequest -Uri $zabbixDataUrl -WebSession $sessionZabbix

  $dataContent = $data.Content  
  $startValue = $dataContent.IndexOf("<br><pre>") + "<br><pre>".Length
  $endValue = $dataContent.IndexOf("<br>", $startValue)
  $getValue = $dataContent.Substring($startValue, $endValue - $startValue)
  $getValueArray = $getValue.Split(" ")
  $getOnlyValue = $getValueArray[3]

  return $getOnlyValue
}

function createObjectWithValues {
    param(
        [string]$Name,
        $CpuMin,
        $CpuMax,
        $CpuAvg,
        $RamMin,
        $RamMax,
        $RamAvg
    )

    $object = New-Object -TypeName PSObject
    $object | Add-Member -MemberType NoteProperty -Name "VM Name" -Value $Name
    $object | Add-Member -MemberType NoteProperty -Name "CPU Min" -Value $CpuMin
    $object | Add-Member -MemberType NoteProperty -Name "CPU Max" -Value $CpuMax
    $object | Add-Member -MemberType NoteProperty -Name "CPU Avg" -Value $CpuAvg
    $object | Add-Member -MemberType NoteProperty -Name "RAM Min" -Value $RamMin
    $object | Add-Member -MemberType NoteProperty -Name "RAM Max" -Value $RamMax
    $object | Add-Member -MemberType NoteProperty -Name "RAM Avg" -Value $RamAvg

    return $object
}

function customer1 {
    clear
    $currentCustomer = $($MyInvocation.MyCommand.Name)
    Write-Host "Listing Values for $currentCustomer"

    $VMs = @()
    $VMs += createObjectWithValues -Name "" -CpuMin (getDataValue -itemId ) -CpuMax (getDataValue -itemId ) -CpuAvg (getDataValue -itemId ) -RamMin (getDataValue -itemId ) -RamMax (getDataValue -itemId ) -RamAvg (getDataValue -itemId )
    
    $VMs | Format-Table -AutoSize

    Write-Host "Press 9 to view Customers again or press any key to exit."
    $input = Read-Host "Enter your selection"

    if ($input -eq 9) {
        $saveToFile = Read-Host "`nDo you want to save the output to a file? (y/n)"
        if ($saveToFile -eq 'y') {
            saveOutput
        }
    mainMenu
}
    else {
        $saveToFile = Read-Host "`nDo you want to save the output to a file? (y/n)"
        if ($saveToFile -eq 'y') {
            saveOutput
        }
    Write-Host "`nExiting the script...`n"
    exit 0
    }
}

function customer2 {
    clear
    $currentCustomer = $($MyInvocation.MyCommand.Name)
    Write-Host "Listing Values for $currentCustomer"

    $VMs = @()
    $VMs += createObjectWithValues -Name "" -CpuMin (getDataValue -itemId ) -CpuMax (getDataValue -itemId ) -CpuAvg (getDataValue -itemId ) -RamMin (getDataValue -itemId ) -RamMax (getDataValue -itemId ) -RamAvg (getDataValue -itemId )
    
    $VMs | Format-Table -AutoSize

    Write-Host "Press 9 to view Customers again or press any key to exit."
    $input = Read-Host "Enter your selection"

    if ($input -eq 9) {
        $saveToFile = Read-Host "`nDo you want to save the output to a file? (y/n)"
        if ($saveToFile -eq 'y') {
            saveOutput
        }
    mainMenu
}
    else {
        $saveToFile = Read-Host "`nDo you want to save the output to a file? (y/n)"
        if ($saveToFile -eq 'y') {
            saveOutput
        }
    Write-Host "`nExiting the script...`n"
    exit 0
    }
}

function saveOutput {
    $currentDate = Get-Date -Format "dd.MM.yyyy_HH.mm"
    $filePath = "$env:userprofile\Desktop\$($currentCustomer)_$($currentDate).txt"
    $VMs | Format-Table -AutoSize | Out-File -FilePath $filePath
    Write-Host "`nOutput saved to $($currentCustomer)_$($currentDate).txt`n"
}

function mainMenu {
    clear
    Write-Host "`nWelcome to bygalacos's Zabbix Data Retriever Script`n" -ForegroundColor Green
    Write-Host "`nListing Current Customers...`n"
    Write-Host "1) Customer1`n"
    Write-Host "2) Customer2`n"

    $customerSelection = Read-Host "`nPlease Select Customer"

    if ($customerSelection -eq 1) {
        customer1
    } elseif ($customerSelection -eq 2) {
        customer2
    } else {
        Write-Host "Invalid selection. Please try again."
        Write-Host "`Exiting the script..."
        exit 0
    }
}

mainMenu