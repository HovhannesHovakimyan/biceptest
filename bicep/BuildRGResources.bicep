param storage object = {
  frontend: {
    storageAccount: {
      name: 'hhrgglobalfrontendeastus'
      location: 'eastus'
      sku: 'Standard_RAGRS'
      kind: 'StorageV2'
    }
    blobService: {
      name: 'default'
    }
    storageContainer: {
      name: 'frontend'
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

param acr object = {
  // backend: {
  //   name: 'devglobalacruseastfrontend'
  //   location: 'eastus'
  //   sku: 'Basic'
  // }
}

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' = [
  for item in items(acr): {
    name: item.value.name
    location: item.value.location
    sku: {
      name: item.value.sku
    }
  }
]
