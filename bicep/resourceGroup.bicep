targetScope = 'subscription'

param resourceGroups object = {
  build: {
    name: 'global-rg-eastus-build'
    location: 'eastus'
  }
  deploy: {
    name: 'global-rg-eastus-deploy'
    location: 'eastus'
  }
}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = [
  for item in items(resourceGroups): {
    name: item.value.name
    location: item.value.location
  }
]
