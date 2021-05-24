function Space {
    $drivespace = gwmi win32_logicaldisk | where DeviceID -eq "C:" | Select FreeSpace
    $getfullproperty = $drivespace | Select -ExpandProperty "FreeSpace"
    $getnumber = ($getfullproperty/1GB)
    $freespace = [math]::Round($getnumber, 2)
    
    return $freespace
    }