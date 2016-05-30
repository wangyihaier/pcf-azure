# Pivotal Cloud Foundry on Azure

**VERY IMPORTANT:**     
Even though Microsoft provides instructions to deploy both BOSH and CloudFoundry, please use **the instructions
on this document** to do so    

## FIRST THINGS FIRST: Prepare your Azure environment
Please follow this [guide to prepare your Azure environment](Prepare.md)

## Managing your Azure environment
* To manage Azure resources, log into the [Azure Portal](https://portal.azure.com) with your credentials. For example:
  * username: user@mydomain.onmicrosoft.com
  * password: Cl0udF0undry
* To manage the Azure account, log into the [Azure Management site](http://manage.windowsazure.com) with your credentials. For example: 
  * username: admin@mydomain.onmicrosoft.com
  * password: Cl0udF0undry

## Log into the Azure jumpbox    
Login using the credentials you created via the Azure template. For example:
```
ssh YOUR_USERNAME@23.99.199.36    
    
# password: YOUR_PASSWORD
```

## Downloading binaries from PivNet
To download binaries from the command line you will need an authorization token and the URL of the binary:
* Go to PivNet at https://network.pivotal.io
* Login with your account, click your username at the top of the page and select 'Edit Profile' 
* To obtain your authorization token, go to the bottom of the page and copy the value of 'API TOKEN'
* Go back to PivNet home page
* To obtain the URL of the binary, choose the product, select the file you want to download, click the 'i' button and copy the 'API Download' URL
* Use 'wget' to get the product. For example, to get Redis from the command line use this command. Use your authorization token and URL instead
```
wget -O "p-redis-A.B.C.D.pivotal"  --post-data="" --header="Authorization: Token YOUR_TOKEN_GOES_HERE" https://network.pivotal.io/api/v2/products/YOUR_PRODUCT_URL_GOES_HERE
```

## Deploying BOSH and Elastic Runtime
The sections below describe the steps necessary to deploy Pivotal Cloud Foundry to Azure.
* [Deploy BOSH](DeployBosh.md)
* [Deploy Elastic Runtime](DeployPCF.md)

## Running Elastic Runtime smoke tests continuously
Test your work. To determine whether PCF is working properly or not, please use [**this script**](scripts/smoke-test-loop.bash) to run PCF's smoke tests continuously:    
     
* Edit the aforementioned script and change this line with the date and time (in milliseconds) when you want to stop this script. You can use [this website to convert](http://www.epochconverter.com) a given date/time combination to milliseconds
```
STOP_AFTER=1441294049 
```
* If necessary, execute 'chmod 755' to make sure you can execute it
* Use the command below to run it as a background process:
```
smoke-test-loop.bash &
```

## Deploying PCF Services
The sections below describe the steps necessary to deploy Pivotal Cloud Foundry Services to Azure.
* [Deploy RabbitMQ](DeployRabbitMq.md)

## Monitoring tools for PCF on Azure
You can use these 3rd-party tools to monitor PCF on Azure: DataDog and LogSearch.    
* [Deploy LogSearch and LogSearch for Cloud Foundry](DeployLogsearch.md)
* [Deploy Datadog Firehose nozzle](DeployDatadogFirehoseNozzle.md)
* [Pivotal's Cloud Ops team’s custom configuration of Datadog’s dashboards, alerts, and screenboards can be found in the Datadog Config repository](https://github.com/pivotal-cf-experimental/datadog-config-oss)
