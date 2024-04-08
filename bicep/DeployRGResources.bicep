targetScope = 'resourceGroup'

param storage object = {
  tfstate: {
    storageAccount: {
      name: 'hhrgglobalterraformeastus'
      location: 'eastus'
      sku: 'Standard_RAGRS'
      kind: 'StorageV2'
    }
    blobService: {
      name: 'default'
    }
    storageContainer: {
      name: 'terraform-state'
    }
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = [
  for item in items(storage): {
    name: item.value.storageAccount.name
    location: item.value.storageAccount.location
    sku: {
      name: item.value.storageAccount.sku
    }
    kind: item.value.storageAccount.kind
  }
]

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = [
  for (item, i) in items(storage): {
    parent: storageAccount[i]
    name: 'default'
  }
]

resource storageContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = [
  for (item, i) in items(storage): {
    parent: blobService[i]
    name: item.value.storageContainer.name
  }
]
