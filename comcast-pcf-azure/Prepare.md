## TL;DR
1) To prepare your Azure environment, Microsoft has these detailed step-by-step instructions: 
* [Creating an Azure account](https://azure.microsoft.com/en-us/pricing/free-trial/)
* [Create a Service Principal](https://github.com/cloudfoundry-incubator/bosh-azure-cpi-release/blob/master/docs/get-started/create-service-principal.md)
* [Configure Azure networking, jumpbox, public IPs and storage account] (https://github.com/cloudfoundry-incubator/bosh-azure-cpi-release/blob/master/docs/get-started/via-arm-templates/deploy-bosh-via-arm-templates.md)     
**IMPORTANT**: Please only follow instructions from Sections 1 AND 2.     
**DO NOT** deploy Bosh Director automatically      
**DO NOT FOLLOW** the instructions from other sections      

2) [Create an individual storage account for each PCF deployment. See this section: "Multiple Storage Accounts" ](https://github.com/cloudfoundry-incubator/bosh-azure-cpi-release/tree/master/docs/advanced/deploy-cloudfoundry-for-enterprise)
Optionally, you can use [**this Azure CLI script**](scripts/createStorageAccount.sh) to create an individual storage account

3) Ensure you have enough Azure ARM cores for each region you plan to deploy PCF to. Read the next section for more details    

## Got enough cores to deploy Cloud Foundry?
Just like AWS, Azure has default limits on number of cores (among other things) for **each Azure region**. **Before** you deploy Cloud Foundry, make sure you have enough cores in your **Azure region** to support all your BOSH deployments. We recommend 400 ARM cores. If not, request a quota increase for **each Azure Region** to the Azure Support team.      

**IMPORTANT:**  Mention that you want to increase the **ARM (Azure Resource Manager)** core limits. Otherwise, there will be some back and forth between Azure support and you. Believe me, I know :-)     
**Also note** that after entering the ticket, there's a non-obvious `create` button, and that you can navigate from the page without warning, losing your ticket.
     
Please review the [Azure Subscription and Service Limits, Quotas, and Constraints](https://azure.microsoft.com/en-us/documentation/articles/azure-subscription-service-limits). 
Review this guide to [submit a request a quota increase](http://azure.microsoft.com/blog/2014/06/04/azure-limits-quotas-increase-requests)
