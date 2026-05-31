using '../main.bicep'

// deploy-rg: rg-fabricweb-prd-id

param projectName  = 'fabricweb'
param environment  = 'prd'
param regionCode   = 'usw2'
param location     = 'westus2'
param githubRepo   = 'Acestus/fabricweb'

param tags = {
  ManagedBy:   'https://github.com/Acestus/fabricweb'
  CreatedBy:   'wweeks'
  Project:     'fabricweb Identity'
  Environment: 'prd'
  Purpose:     'github-oidc'
}
