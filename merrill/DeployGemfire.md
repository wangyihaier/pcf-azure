## Get Gemfire BOSH release file
* Follow the instructions to download PCF Gemfire from PivNet
* Change to the folder that contains the 'p-gemfire*.pivotal' file and unzip it. For example:
```
unzip p-gemfire-1.1.1.0.pivotal
```
* After you unzip said file, you will get several 'releases/GemFire-*-<version>.tgz' files. Upload each release to BOSH:
```
bosh upload release releases/GemFire-<version>.tgz
bosh upload release releases/GemFire-Broker-<version>.tgz
bosh upload release releases/GemFire-Broker-Registrar-<version>.tgz
```

## Create Gemfire BOSH manifest file
Edit the [Gemfire manifest file](deployments/gemfire/gemfire_deployment.yml) and change the following properties based on your BOSH and Azure settings:
* **director_uuid**: Use your BOSH director UUID
* **instance_type**: Use the appropriate Azure instance type
* All occurrences of **ssl_rsa_certificate**: Use the same SSL cert and private key from PCF Elastic Runtime's HAProxy
* **system_domain**: Use Elastic Runtime's system domain (e.g.: cl-dev01.cf.ford.com)
* **app_domain**: Use Elastic Runtime's app domain (e.g.: cl-dev01.cf.ford.com)
* **networks**: Use your Azure network settings (virtual network name, subnet name, CIDR, gateway, dns, reserved IPs, static IPs, etc) 
* Review **all Gemfire jobs** to make sure they have the right IP address, resource pool, number of instances, etc
* Set **all NATS-related properties** with the values that correspond to your deployment. You can find those values in the PCF Elastic runtime manifest file. For instance:
```
      nats:
        username: nats
        password: f38mdje7b3a3
        port: 4222
        machines:
        - 10.0.16.A
        - 10.0.16.B
```

* All occurrences of **url, username and password** properties and set them with the values that correspond to your deployment. You can find both admin_username and admin_password value in the PCF Elastic runtime manifest file. For instance:
```
      api:
        url: https://api.<system_domain>
        username: admin
        password: abcde1
```
* All occurrences of **api_url, admin_username and admin_password** properties and set them with the values that correspond to your deployment. You can find both admin_username and admin_password value in the PCF Elastic runtime manifest file. For instance:
```
...
      api_url: https://api.<system_domain>
      admin_username: admin
      admin_password: abcde1
```
* All occurrences of **uaa_url, admin_client_username and admin_client_password** properties and set them with the values that correspond to your deployment. You can find both admin_client_username and admin_client_password value in the PCF Elastic runtime manifest file. For instance:
```
...
  properties:
...
    uaac:
      uaa_url: https://uaa.cl-dev01.cf.ford.com
      admin_client_username: admin
      admin_client_password: c2234sdf3a1ec
```

## Configure Gemfire service plans
GemFire for Pivotal Cloud Foundry® provides three different service plans that you can configure to provide different GemFire cluster sizes. For **each of the three** service plan configurations, you need to:
* Replace all occurrences of the **cluster_topology** property to specify the number of locators per cluster (**number_of_locators**) to create in the GemFire cluster for the plan, as well as the number of cache servers (**number_of_servers**) per cluster. In the example below, this service plan specifies a minimum of two locators and three cache servers *per GemFire cluster*
```
        cluster_topology:
          number_of_locators: 2
          number_of_servers: 3
```
* Change the **instances** property of the all **locators** and **servers** Gemfire jobs. Enter the total number of GemFire locator and server instances that you want to create for each of the available service plans. **For example**, if you configured GemFire Service Plan 1 to provide a small GemFire cluster using the minimum of 2 locators and 3 servers, but you want to wanted to make four (4) instances of this plan available in the marketplace, you would set GemFire locator (Plan 1) to 8 instances and set GemFire server (Plan 1) to 12 instances as shown below:
```
- name: gemfire-locator-plan-1-partition-23667487364d2711ed4f
...
  instances: 8
```
```
- name: gemfire-server-plan-1-partition-23667487364d2711ed4f
...
  instances: 12
```
 
## Deploy Gemfire BOSH manifest file
Set the Gemfire deployment manifest:
```
bosh deployment deployments/gemfire/gemfire_deployment.yml
```
Execute the deployment command:
```
bosh deploy
```

## Register the Gemfire broker
```
bosh run errand broker-registrar
```

## Run the errand that tests the cluster health
```
bosh run errand test_cluster_health
```
