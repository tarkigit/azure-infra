using './main.bicep'

param apimServiceName = 'apim-myapp-dev'
param publisherEmail = 'admin@example.com'
param publisherName = 'My Organization'
param location = 'eastus'
param sku = 'Developer'
param skuCount = 1
param tags = {
  environment: 'dev'
  project: 'myapp'
  managedBy: 'bicep'
}
param virtualNetworkType = 'None'
param subnetResourceId = ''
param enableSystemAssignedIdentity = false
param hostnameConfigurations = []
