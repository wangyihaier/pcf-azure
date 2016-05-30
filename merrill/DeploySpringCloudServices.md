## Get SCS BOSH release file
* Follow the instructions to download it from PivNet
* Change to the folder that contains the 'scs*.pivotal' file and unzip it. For example:
```
unzip p-scs-<version>.pivotal
```
After you unzip said file, Upload to BOSH all files under the "/release" folder. Here is one way to do it:
```
for i in *.tgz; do bosh upload release $i; done
```

## Edit SCS BOSH manifest file
Edit the **scs/scs.yml** file and change the following properties based on your BOSH and Azure settings:
* **director_uuid**: Use your BOSH director UUID
* **instance_type**: Use the appropriate Azure instance type. Use at least D-series instances. For best performance, use Dv2-series instances; keep in mind that they are more expensive
* **storage_account_name** and **storage_access_key** with the storage account you created for MySQL
* **networks**: Use your Azure network settings (virtual network name, subnet name, CIDR, gateway, dns, reserved IPs, static IPs, etc) 
* Replace **javelinmc.com** with your main domain 
* Review all SCS **jobs** in your manifest to make sure they have the right IP address, resource pool, number of instances, etc

## Deploy SCS BOSH manifest file
Set the deployment manifest:
```
bosh deployment scs/scs.yml
```
Execute the deployment command:
```
bosh deploy
```
## Deploy and register the broker
```
bosh run errand deploy-service-broker
bosh run errand register-service-broker
```
