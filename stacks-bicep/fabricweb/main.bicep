// ============================================================
// fabricweb — fabric.acestus.com
// ACE-20: Hugo SWA landing page for Fabric CI/CD readiness review
// Subscription: df64929f-810d-4176-8097-35cd05cae10d (acestus personal)
// ============================================================

targetScope = 'resourceGroup'

@description('Environment short code')
@allowed(['dev', 'prd'])
param environment string

@description('Azure region short code')
param regionCode string = 'usw2'

@description('Instance number')
param instanceNumber string = '001'

@description('Azure region location')
param location string = 'westus2'

@description('Resource tags')
param tags object = {
  Environment: environment
  Application: 'fabricweb'
  ManagedBy: 'bicep'
  Purpose: 'marketing-landing-page'
  Project: 'ACE-20'
}

var projectName = 'fabricweb'
var swaName = 'swa-${projectName}-${environment}-${regionCode}-${instanceNumber}'

resource staticWebApp 'Microsoft.Web/staticSites@2022-09-01' = {
  name: swaName
  location: location
  tags: tags
  sku: {
    name: 'Free'
    tier: 'Free'
  }
  properties: {
    stagingEnvironmentPolicy: 'Enabled'
    enterpriseGradeCdnStatus: 'Disabled'
  }
}

output swaName string = staticWebApp.name
output swaHostname string = staticWebApp.properties.defaultHostname
output deploymentToken string = staticWebApp.listSecrets().properties.apiKey
