@description('The name of the API Management service instance.')
param apimServiceName string

@description('The email address of the owner of the API Management service.')
@minLength(1)
param publisherEmail string

@description('The name of the owner of the API Management service.')
@minLength(1)
param publisherName string

@description('The Azure region where the API Management service will be deployed.')
param location string = resourceGroup().location

@description('The pricing tier of the API Management service.')
@allowed([
  'Consumption'
  'Developer'
  'Basic'
  'Standard'
  'Premium'
])
param sku string = 'Developer'

@description('The instance size of the API Management service. Consumption SKU ignores this value (always 0). Developer and Basic support 1 unit. Standard supports 1–4. Premium supports 1–12.')
@minValue(0)
@maxValue(12)
param skuCount int = 1

@description('Tags to apply to all resources.')
param tags object = {}

@description('Virtual network type for the API Management service.')
@allowed([
  'None'
  'External'
  'Internal'
])
param virtualNetworkType string = 'None'

@description('The resource ID of the subnet to use when virtualNetworkType is External or Internal. Required when virtualNetworkType is not None.')
param subnetResourceId string = ''

@description('Enable system-assigned managed identity.')
param enableSystemAssignedIdentity bool = false

@description('Custom hostname configurations for the API Management service.')
param hostnameConfigurations array = []

resource apimService 'Microsoft.ApiManagement/service@2023-05-01-preview' = {
  name: apimServiceName
  location: location
  tags: tags
  sku: {
    name: sku
    capacity: sku == 'Consumption' ? 0 : skuCount
  }
  identity: enableSystemAssignedIdentity ? {
    type: 'SystemAssigned'
  } : {
    type: 'None'
  }
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
    virtualNetworkType: virtualNetworkType
    virtualNetworkConfiguration: (virtualNetworkType != 'None') ? {
      subnetResourceId: subnetResourceId
    } : null
    hostnameConfigurations: !empty(hostnameConfigurations) ? hostnameConfigurations : null
  }
}

@description('The resource ID of the API Management service.')
output apimServiceId string = apimService.id

@description('The name of the API Management service.')
output apimServiceName string = apimService.name

@description('The gateway URL of the API Management service.')
output gatewayUrl string = apimService.properties.gatewayUrl

@description('The portal URL of the API Management service.')
output portalUrl string = apimService.properties.portalUrl

@description('The management API URL of the API Management service.')
output managementApiUrl string = apimService.properties.managementApiUrl

@description('The principal ID of the system-assigned managed identity, if enabled.')
output systemAssignedPrincipalId string = enableSystemAssignedIdentity ? apimService.identity.principalId : ''
