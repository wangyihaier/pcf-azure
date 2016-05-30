# Azure issues while deploying PCF - VM count limit per storage account

While deploying Gemfire, it seems that we hit a VM count limit on Azure and we could not create more VMs. So the solution 
seems to be to create an additional Azure storage account, blob containers and a table.
Here is an excerpt of the problem:    
     
*Because VM VHDs are stored in a storage account, there is a recommended number of VM disks per storage account in order to avoid the 20,000 total requests limit and potential throttling: for Basic tier VMs up to 66 heavy used VHDs in a single storage account (20,000 request rate limit /300 8 KB IOPS per persistent disk); for Standard tier VMs up to 40 heavy used VHDs in a storage account (20,000 request rate limit /500 8 KB IOPS per persistent disk).*

For more details please see: http://blogs.msdn.com/b/kdot/archive/2014/10/09/designing-for-big-scale-in-azure.aspx

# Azure CPI workaround
To workaround this issue, we are going to use not only the default storage accounts but a new storage account. Here is the Azure CPI documentation:

From Microsoft:
*These options are specified under cloud_properties in the resource_pools section of a BOSH deployment manifest.*    
    
**storage_account_name (optional)** which storage account the VMs should be created in. 
If this is not set, the VMs will be created in the default storage account. 
If you use a different storage account which must be in the same resource group, please make sure:     
      
1) the permissions for the container 'stemcell' in the default storage account is set to Public read access for blobs only.     
2) a table 'stemcells' is created in the default storage account.      
3) two containers 'bosh' and 'stemcell' are created in the new storage account. 
(If you use DS-series or GS-series as instance_type, you should set this to a premiumstorage account. See more information about Azure premium storage See avaliable regions here where you can create premium storage accounts.)

# Implement step 1
Set permissions for the 'stemcell' container in the default storage account to Public read access for blobs only.      

*Via Preview Azure Portal:*  Go to the "Access Policy" in the stemcell container in the default storage account and change it to "Set Access Type to blob"

# Implement step 2 use DEFAULT Storage account
You can use AZURE CLI to create a table in the default storage account

Note: Use the original storage account here listed in bosh.yml

```
export AZURE_STORAGE_ACCOUNT=storage1fordga
export AZURE_STORAGE_ACCESS_KEY=Yl1vnEU5zp1DuTlWB5OPX/V5spYBSPD9NWR9dTDXm6JvTycImM/8VT+sxICo9Hp7siSud0lSRZ5czS46c9S7tw==

azure storage table create
info:    Executing command storage table create
Table name: stemcells
+ Creating storage table stemcells
+ Getting Storage table information
info:    No information is found for table stemcells
info:    storage table create command OK
```

# Implement step 3 to use NEW storage account

You can use the AZURE CLI To create a blob container in an existing storage account

Note: Use the new storage account here - ie not the one that stores your stemcells.
```
export AZURE_STORAGE_ACCOUNT=pcfstorage
export AZURE_STORAGE_ACCESS_KEY=RPT2Qvuayu12eVz8KIhVrfiEJvYybELzvGzavnfIr65WglhWR5oWo90yD+vQu1WN2rENbooTklzxU0tZMbL6QQ==

azure storage container create
info:    Executing command storage container create
Container name: stemcell
+ Creating storage container stemcell
+ Getting Storage container information
data:    {
data:        name: 'stemcell',
data:        metadata: {},
data:        etag: '"0x8D2E5803D044521"',
data:        lastModified: 'Thu, 05 Nov 2015 01:27:15 GMT',
data:        leaseStatus: 'unlocked',
data:        leaseState: 'available',
data:        requestId: '3f7b791f-0001-012b-4469-17fe80000000',
data:        publicAccessLevel: 'Off'
data:    }
info:    storage container create command OK
```
