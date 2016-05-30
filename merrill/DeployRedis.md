## Get Redis BOSH release file
Follow the instructions to download PCF Redis from PivNet
Change to the folder that contains the 'redis.pivotal' file and unzip it. For example:
```
unzip p-redis-1.4.9.0.pivotal
```
After you unzip said file, you will get the 'releases/cf-redis-<version>.tgz' file
Upload that release to BOSH:
```
bosh upload release releases/cf-redis-<version>.tgz
```

## Edit Redis BOSH manifest file
Edit the **redis/redis_deployment.yml** and change the following properties based on your BOSH and Azure settings:
* **director_uuid**: Use your BOSH director UUID
* **instance_type**: Use the appropriate Azure instance type. Use at least D-series instances. For best performance, use Dv2-series instances; keep in mind that they are more expensive
* **networks**: Use your Azure network settings (virtual network name, subnet name, CIDR, gateway, dns, reserved IPs, static IPs, etc) 
  * All occurrences of **syslog_daemon_config's address and port** with the IP address and port of your SYSLOG-based server, respectively
```
    syslog_aggregator:
      address: 10.0.16.XYZ
      port: ABC
```    
* Review all Redis **jobs** to make sure they have the right IP address, resource pool, number of instances, etc

## Deploy Redis BOSH manifest file
Set the Redis deployment manifest:
```
bosh deployment redis/redis_deployment.yml
```
Execute the deployment command:
```
bosh deploy
```
## Register the Redis broker
```
bosh run errand broker-registrar
```
**WORKAROUND**: If the errand fails, try these commands using the CF CLI program:
```
cf api --skip-ssl-validation https://api.<YOUR_DOMAIN>
cf auth admin YOUR_ADMIN_PASSWORD
cf enable-service-access p-redis
```
