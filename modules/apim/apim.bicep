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

@description('Number of scale units for the API Management service. Consumption SKU must be 0.')
@minValue(0)
@maxValue(12)
param skuCapacity int = 1

@description('Publisher name shown in the developer portal.')
param publisherName string

@description('Publisher e-mail address used for notifications.')
param publisherEmail string

@description('Resource tags to apply to all resources.')
param tags object = {}

@description('Optional virtual network type: None, External, or Internal.')
@allowed([
  'None'
  'External'
  'Internal'
])
param virtualNetworkType string = 'None'

@description('Resource ID of the subnet to use when virtualNetworkType is External or Internal. Leave empty for None.')
param subnetResourceId string = ''

// ---------------------------------------------------------------------------
// API Management Service
// ---------------------------------------------------------------------------

resource apim 'Microsoft.ApiManagement/service@2023-05-01-preview' = {
  name: apimName
  location: location
  tags: tags
  sku: {
    name: skuName
    capacity: skuCapacity
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    publisherName: publisherName
    publisherEmail: publisherEmail
    virtualNetworkType: virtualNetworkType
    virtualNetworkConfiguration: (virtualNetworkType != 'None' && !empty(subnetResourceId))
      ? {
          subnetResourceId: subnetResourceId
        }
      : null
  }
}

// ---------------------------------------------------------------------------
// Outputs
// ---------------------------------------------------------------------------

@description('Resource ID of the API Management service.')
output apimId string = apim.id

@description('Name of the API Management service.')
output apimName string = apim.name

@description('Gateway URL of the API Management service.')
output gatewayUrl string = apim.properties.gatewayUrl

@description('Developer portal URL of the API Management service.')
output developerPortalUrl string = apim.properties.developerPortalUrl

@description('Principal ID of the system-assigned managed identity.')
output principalId string = apim.identity.principalId
