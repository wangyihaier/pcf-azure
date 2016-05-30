## Deploy BOSH
* Click the link to learn more about the [BOSH Azure CPI](https://github.com/cloudfoundry-incubator/bosh-azure-cpi-release)
* To enable the BOSH Resurrector, add the following properties:
```
    hm:
    ...
      resurrector_enabled: true
      resurrector:
        minimum_down_jobs: 5
        percent_threshold: 0.2
        time_threshold: 600
```
* To enable DataDog, add the following properties:
```
    hm:
    ...
      datadog_enabled: true
      datadog:
        api_key: <your Datadog API key>
        application_key: <DataDog application key>
```
* Please click the following links to get the latest version of [BOSH release](https://bosh.io/releases/github.com/cloudfoundry/bosh?all=1), [Azure CPI](https://bosh.io/releases/github.com/cloudfoundry-incubator/bosh-azure-cpi-release?all=1) and [Azure Hyper-V stemcell (under the LATEST STEMCELLS section)](https://bosh.io). 
* Listed below is an example of how to define releases in your BOSH.YML. Please replace the "url" and "sha1" properties accordingly.
```
releases:
- name: bosh
  url: https://bosh.io/d/github.com/cloudfoundry/bosh?v=251
  sha1: 649fca64ac878476c6d68fc5e7ff86c2d879be16
- name: bosh-azure-cpi
  url: https://bosh.io/d/github.com/cloudfoundry-incubator/bosh-azure-cpi-release?v=6
  sha1: 5bad0885c1107ea86bf6584b7492d48ac755d3f2...
...
resource_pools:
- name: vms
  network: private
  stemcell:
    url: https://bosh.io/d/stemcells/bosh-azure-hyperv-ubuntu-trusty-go_agent?v=3169
    sha1: ff13c47ac7ce121dee6153c1564bd8965edf9f59
  cloud_properties:
    instance_type: Standard_D1
...
```

* Run the following commands in your home directory to deploy bosh:
```
./deploy_bosh.sh
```
* To get more verbose logs, please look at the **~/run.log** file

## Check status of BOSH Director
* Log into BOSH Director with credentials: admin / admin
```
bosh target 10.0.0.4 
username: admin
password: admin
```
* Check the status of BOSH director
```
bosh status
```
