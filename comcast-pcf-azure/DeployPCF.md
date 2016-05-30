## Install GIT
* Get GIT binaries
```
sudo apt-get install git
```
* Create folder and clone repository
```
mkdir workspace
cd workspace
git clone https://github.com/<THIS_REPO>
```


## Upload Azure stemcell
* Get the value of **resource_pools.name[vms].stemcell.url** in your **bosh.yml**. Use it to replace **STEMCELL-FOR-AZURE-URL** in below command:
```
	bosh upload stemcell <STEMCELL-FOR-AZURE-URL>
```

## Upload Pivotal Cloud Foundry releases
Note: Please keep in mind that this step will take a while. So while you are waiting for it to complete, proceed to the next section.    
     
* Download the latest GA version of Pivotal Elastic Runtime from PivNet. Unzip it
* Change to the folder where you unzipped it
* Change to **/releases** folder
* Upload ALL Elastic Runtime releases. Here is one way to do it:
```
for i in *.tgz; do bosh upload release $i; done
```

## Customize Cloud Foundry manifest file

* Edit the **ert_1.6/pcf_1_6_azure.yaml** file
* If you want to use your domain name, you can replace all ‘**MY_DOMAIN.COM**’ references in the YAML file
* Replace **8.8.8.8** with the IP address of your Azure DNS server(s)
* Generate an [SSL cert and private key based on the "Security Requirements" section of Spring Cloud services online docs](http://docs.pivotal.io/spring-cloud-services/prerequisites.html)
* Replace the value of the these properties:
  * **director_uuid** with the UUID of your BOSH Director as shownn in the output of 'bosh status'
  * **virtual_network_name** with the name of your virtual network
  * **subnet_name** with the name of the Cloud Foundry subnet
  * **instance_type**: Use the appropriate Azure instance type. Use at least D-series instances. For best performance, use Dv2-series instances; keep in mind that they are more expensive
  * **static_ips** of the HAPRoxy job with the value of your CF public IP address. To find out the IP address, log into the [Azure Portal](https://portal.azure.com) and look for a *Public IP address* object with the **-cf** suffix
  * **ssl_pem** with your the SSL cert and RSA private key
  * **storage_account_name** and **storage_access_key** with the storage account you created for Elastic Runtime

## Deploy Pivotal Cloud Foundry
* Set the deployment with our **deployments/cf-deployment.yml** file
```
bosh deployment ert_1.6/pcf_1_6_azure.yaml
```
* Deploy Elastic Runtime
```
bosh deploy
```
* After your deployment completes, use the CF CLI to verify you can log into your newly-created PCF instance     
      
##Run Cloud Foundry Errands
* Check the available errands
```
bosh errands
```
* At a minimum, run the following errands:
```
bosh run errand smoke-tests
bosh run errand push-apps-manager
bosh run errand push-app-usage-service
```
* To run any additional errands, replace the <ERRAND_NAME> value with the name of the errand you want to run
```
bosh run errand <ERRAND_NAME>
```

* Troubleshooting:
  * If for some reason the errand fails, re-run the 'bosh run errand' command

##Send Elastic Runtime's system logs to Logging Aggregation tool
Once you have setup your Logging Aggregation tool, edit the **ert_1.6/pcf_1_6_azure.yaml** file and replace all occurrences of **syslog_daemon_config or syslog_aggregator: address, port and transport** with the IP address, port and transport of your SYSLOG-based server, respectively
```
    syslog_daemon_config:
      address: <YOUR_IP_address>
      port: <YOUR_PORT>
      transport: tcp
```    
```    
    syslog_aggregator:
      address: <YOUR_IP_address>
      port: <YOUR_PORT>
      transport: tcp
```    
  
