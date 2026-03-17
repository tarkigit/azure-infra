using './apim.bicep'

param apimName        = 'apim-myapp-dev'
param location        = 'eastus'
param skuName         = 'Developer'
param skuCapacity     = 1
param publisherName   = 'My Organisation'
param publisherEmail  = 'apim-admin@example.com'
param tags            = {
  environment: 'dev'
  project:     'myapp'
}
param virtualNetworkType = 'None'
param subnetResourceId   = ''
