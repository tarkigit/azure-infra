@description('Name of the API Management service instance.')
param apimName string

@description('Azure region for all resources.')
param location string = resourceGroup().location

@description('SKU name for the API Management service.')
@allowed([
  'Developer'
  'Basic'
  'Standard'
  'Premium'
  'Consumption'
])
param skuName string = 'Developer'

@description('Number of scale units. Consumption SKU must be 0.')
@minValue(0)
@maxValue(12)
param skuCapacity int = 1

@description('Publisher name shown in the developer portal.')
param publisherName string

@description('Publisher e-mail address used for notifications.')
param publisherEmail string

@description('Resource tags to apply to all resources.')
param tags object = {}

@description('Virtual network integration type: None, External, or Internal.')
@allowed([
  'None'
  'External'
  'Internal'
])
param virtualNetworkType string = 'None'

@description('Subnet resource ID when virtualNetworkType is External or Internal.')
param subnetResourceId string = ''

// ---------------------------------------------------------------------------
// APIM module
// ---------------------------------------------------------------------------

module apim 'modules/apim/apim.bicep' = {
  name: 'apimDeploy'
  params: {
    apimName:            apimName
    location:            location
    skuName:             skuName
    skuCapacity:         skuCapacity
    publisherName:       publisherName
    publisherEmail:      publisherEmail
    tags:                tags
    virtualNetworkType:  virtualNetworkType
    subnetResourceId:    subnetResourceId
  }
}

// ---------------------------------------------------------------------------
// Outputs
// ---------------------------------------------------------------------------

@description('Resource ID of the deployed API Management service.')
output apimId string = apim.outputs.apimId

@description('Name of the deployed API Management service.')
output apimName string = apim.outputs.apimName

@description('Gateway URL of the deployed API Management service.')
output gatewayUrl string = apim.outputs.gatewayUrl

@description('Developer portal URL of the deployed API Management service.')
output developerPortalUrl string = apim.outputs.developerPortalUrl

@description('Principal ID of the system-assigned managed identity on the API Management service.')
output principalId string = apim.outputs.principalId
