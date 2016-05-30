# Upload LogSearch releases
* Upload the Logsearch release
```
bosh upload release https://bosh.io/d/github.com/logsearch/logsearch-boshrelease?v=23.0.0
```
* Upload the Logsearch for CloudFoundry release
```
bosh upload release https://logsearch-for-cloudfoundry-boshrelease.s3.amazonaws.com/boshrelease-logsearch-for-cloudfoundry-7.tgz
```
    
# Deploy Logsearch
* Edit the **logsearch/logsearch.yml** file
* Replace the following properties:
  * **director_uuid** with the BOSH Director UUID from the 'bosh status' command 
  * **reserved** with the reserved range of your network
  * **static** with the static range of your network
  * **dns** with your DNS
  * **static_ips** with the IP address of the VM that hosts all components
  * **system_domain**: with your PCF system domain (e.g.:cl-dev01.cf.ford.com)
* Set the BOSH deployment to **logsearch/logsearch.yml**
```
bosh deployment logsearch/logsearch.yml
```
* Deploy Logsearch
```
bosh deploy 
```

# Run Kibana errand
```
bosh run errand push-kibana
```
