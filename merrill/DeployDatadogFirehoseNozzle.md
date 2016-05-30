# Upload DataDog Firehose Nozzle release
```
bosh upload release https://bosh.io/d/github.com/cloudfoundry-incubator/datadog-firehose-nozzle-release?v=7
```
    
# Deploy DataDog Firehose Nozzle
* Edit the **nozzle/datadog-firehose-nozzle.yml** file
* Replace the following properties:
  * **director_uuid** with the BOSH Director UUID from the 'bosh status' command 
  * **reserved** with the reserved range of your network
  * **static** with the static range of your network
  * **dns** with your DNS
  * Replace text **javelinmc.com** with your PCF system domain
  * Replace DataDog settings with your own API key
```
  datadog:
    api_key: bc4444dfa2245c5ced97336cfb2f6699
    api_url: https://app.datadoghq.com/api/v1/series  
```
* Set the BOSH deployment to **nozzle/datadog-firehose-nozzle.yml**
```
bosh deployment logsearch/logsearch.yml
```
* Deploy it
```
bosh deploy 
```
