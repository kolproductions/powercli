#Create the array
$array = @()

$host_cluster = get-cluster 
$vms =  get-vm

#foreach ($vm in $vms)
foreach ($cluster in $host_cluster)
{

$disks = get-advancedsetting -Entity $vm | ? { $_.Value -like “*multi-writer*”  }

foreach ($disk in $disks) {
   $REPORT = New-Object -TypeName PSObject
   $REPORT | Add-Member -type NoteProperty -name Cluster -Value $vm.Name
   $REPORT | Add-Member -type NoteProperty -name Name -Value $vm.Name
   $REPORT | Add-Member -type NoteProperty -name VMHost -Value $vm.Host
   $REPORT | Add-Member -type NoteProperty -name Mode -Value $disk.Name
   $array += $REPORT
   }
}

$array | Sort-Object Name,VMHost,Mode | Export-Csv -Path C:\multi.csv -NoTypeInformation
