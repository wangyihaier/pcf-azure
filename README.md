# pcf-azure
Pivotal Cloud Foundry Manifests for MS Azure

PLEASE DO NOT MAKE PUBLIC yet as the passwords aren't templated.... just feel free to use it for yours and muck with passwords if you'd like

Currently supports PCF v1.6.15 - Now includes MySQL, RabbitMQ, and Spring Cloud!

to deploy
- setup BOSH via the Azure CPI guidelines with a Resource Manager template (you may need to file a ticket to increase your quota on the Azure Resource Manager side, particularly A-series and D-series CPUs)
- generate a new RSA TLS keypair for your domain
- modify the templates to change pcfazure.com to a different domain along with the ssl_pem for HAproxy 
- upload the .yml from this repo to your dev box
- upload the cf-1.6.x.pivotal , p-mysql-1.7.2.pivotal, p-rabbitmq-1.5.4.pivotal, and p-spring-cloud-services-1.0.3.pivotal
- ssh to your dev box and target your bosh director

```
unzip cf-1.6.15.pivotal
bosh upload stemcell https://s3.amazonaws.com/bosh-azure-stemcells/bosh-stemcell-3184-azure-hyperv-ubuntu-trusty-go_agent.tgz
bosh upload release releases/cf-225.12.tgz
bosh upload release releases/cf-autoscaling-28.tgz
bosh upload release releases/cf-mysql-23.tgz 
bosh upload release releases/diego-0.1446.1.tgz
bosh upload release releases/etcd-release-18.tgz  
bosh upload release releases/garden-linux-0.330.0.tgz  
bosh upload release releases/push-apps-manager-release-397.tgz
bosh deployment pcf-1.6.yml
bosh deploy
bosh run errand smoke-tests
bosh run errand push-apps-manager
bosh run errand push-app-usage-service
bosh run errand autoscaling
bosh run errand autoscaling-register-broker
bosh run errand autoscaling-tests

unzip p-mysql-1.7.2.pivotal
bosh upload release releases/cf-mysql-24.tgz
bosh upload release releases/mysql-backup-1.tgz
bosh upload release releases/service-backup-1.tgz
bosh deployment p-mysql-1.7.2.yml
bosh deploy
bosh run errand broker-registrar

unzip p-rabbitmq-1.5.4.pivotal
bosh upload release releases/cf-rabbitmq-210.4.0.tgz
bosh deployment rabbitmq-1.5.4.yml
bosh deploy
bosh run errand broker-registrar

unzip p-spring-cloud-services-1.0.3.pivotal
bosh upload release releases/spring-cloud-broker-1.0.3-build.13.tgz
bosh deployment p-spring-1.0.3.pivotal
bosh deploy
bosh run errand deploy-service-broker
bosh run errand register-service-broker

```

