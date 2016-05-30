## Get RabbitMQ BOSH release file
* Follow the instructions to download PCF RabbitMQ from PivNet
* Change to the folder that contains the 'p-rabbitmq*.pivotal' file and unzip it. For example:
```
unzip p-rabbitmq-1.4.9.0.pivotal
```
After you unzip said file, you will get the 'releases/cf-rabbitmq-<version>.tgz' file. Upload that release to BOSH:
```
bosh upload release releases/cf-rabbitmq-<version>.tgz
```

## Edit Rabbit BOSH manifest file
Edit the **rabbit/rabbit.yml** file and change the following properties based on your BOSH and Azure settings:
* **director_uuid**: Use your BOSH director UUID
* **instance_type**: Use the appropriate Azure instance type. Use at least D-series instances. For best performance, use Dv2-series instances; keep in mind that they are more expensive
* **storage_account_name** and **storage_access_key** with the storage account you created for RabbitMQ
* **networks**: Use your Azure network settings (virtual network name, subnet name, CIDR, gateway, dns, reserved IPs, static IPs, etc) 
* Replace **javelinmc.com** with your main domain 
* All occurrences of **syslog_aggregator's address and port** with the IP address and port of your SYSLOG-based server, respectively
```
    syslog_aggregator:
      address: 10.0.16.ABC
      port: 55AA
```
* Review all RabbitMQ **jobs** in your manifest to make sure they have the right IP address, resource pool, number of instances, etc

## Deploy RabbitMQ BOSH manifest file
Set the RabbitMQ deployment manifest:
```
bosh deployment deployments/rabbit/rabbit.yml
```
Execute the deployment command:
```
bosh deploy
```
## Register the RabbitMQ broker
```
bosh run errand broker-registrar
```
## Troubleshooting
If the errand fails, execute these commands via CF CLI
```
cf create-service-broker p-rabbitmq admin d434238c7f2c277e7154 http://10.0.16.99:4567
cf enable-service-access p-rabbitmq
```
