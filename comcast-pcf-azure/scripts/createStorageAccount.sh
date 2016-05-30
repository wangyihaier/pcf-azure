#!/bin/bash

if [ "$#" -ne 4 ]; then
      echo "Illegal number of parameters $#"

      echo "Usage createStorageAccount.sh <Resource Group> <MainStorageAccount> <NewStorageAccount> <location>"
      exit 0
fi

#Get main storage account key
echo Getting Main Storage Key....

mainkey=$(azure storage account keys list --resource-group $1 $2 | grep --line-buffered Primary | awk -F " " '{print $3}')
echo $mainkey
#Create table if not exists
azure storage table create --table stemcells --account-name $2 --account-key $mainkey

#Create new Storage account
azure storage account create --location $4 --type LRS --resource-group $1 $3

#Get Keys from storage account
echo Getting New Storage Account key
newkey=$(azure storage account keys list --resource-group $1 $3 | grep --line-buffered Primary | awk -F " " '{print $3}')
echo $newkey
#create containers in new storage account
azure storage container create --account-name $3 --account-key $newkey bosh
azure storage container create --account-name $3 --account-key $newkey stemcell

echo
echo Add to your manifest in the cloud_properties section:
echo storage_account_name: $3
echo storage_access_key: $newkey
