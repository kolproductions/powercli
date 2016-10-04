#@(#) Author: Daniel R. Pratt  - KoL Productions Inc, (c)1990. - 
#@(#) Program: $Id$
#@(#) Created: Tue Oct  4 10:07:31 EDT 2016
#@(#) Last: $Date$
#@(#) Notes: PowerCLI script to report shared disks by cluster
#==================================================================================
#  Modification History
# Init  Date        Change
# ----  --------    ------------------------------------------------------------
# $Log$
#==================================================================================
VERSION="$Revision$"

$array = @()
$clusters = Get-Cluster 

 foreach ($cluster in $clusters ) { 
         foreach ($vm in $cluster | Get-VM ) {
         $disks = get-advancedsetting -Entity $vm | ? { $_.Value -like “*multi-writer*”  }
             foreach ($disk in $disks) {
                 $REPORT = New-Object -TypeName PSObject
                 $REPORT | Add-Member -type NoteProperty -name Cluster -Value $cluster.Name 
                 $REPORT | Add-Member -type NoteProperty -name VMName -Value $vm.Name
                 $REPORT | Add-Member -type NoteProperty -name DiskMode -Value $disk.Name

                 $array += $REPORT 
             }
         }
}

$array | Sort-Object Cluster,VMName,DiskMode | Export-Csv -Path c:\TEMP\cluster-shared-disks.csv -NoTypeInformation


