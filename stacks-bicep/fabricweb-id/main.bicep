targetScope = 'resourceGroup'

// ============================================================
// fabricweb-id — per-workload data-plane UMI
// ACE-20: GitHub Actions OIDC identity for fabric.acestus.com
//
// Convention (from iac-infra/stacks-bicep/skpinfra-identity):
//   • UMI name:  umi-{project}-{env}-{region}-dat
//   • Hosted in: rg-fabricweb-{env}-id (personal acestus sub)
//   • Federated credential: GitHub Actions environment:{env}
//   • No control-plane UMI needed — personal sub, single workload
// ============================================================

@description('Project short code.')
param projectName string = 'fabricweb'

@allowed(['dev', 'prd'])
param environment string

@minLength(3)
@maxLength(8)
param regionCode string = 'usw2'

@description('Azure region for the UMI.')
param location string = 'westus2'

@description('GitHub org/repo for federated credential (e.g. Acestus/fabricweb).')
param githubRepo string

@description('Tags applied to the UMI.')
param tags object

// ── Naming ───────────────────────────────────────────────────────────────────
var umiName = 'umi-${projectName}-${environment}-${regionCode}-dat'

// ── Data-plane UMI with GitHub OIDC federated credential ────────────────────
module datUmi 'br/public:avm/res/managed-identity/user-assigned-identity:0.5.0' = {
  name: 'deploy-${umiName}'
  params: {
    name: umiName
    location: location
    tags: tags
    federatedIdentityCredentials: [
      {
        name: 'gh-${projectName}-${environment}'
        issuer: 'https://token.actions.githubusercontent.com'
        subject: 'repo:${githubRepo}:environment:${environment}'
        audiences: ['api://AzureADTokenExchange']
      }
    ]
  }
}

// ── Outputs ──────────────────────────────────────────────────────────────────
output umiName        string = umiName
output umiResourceId  string = datUmi.outputs.resourceId
output umiPrincipalId string = datUmi.outputs.principalId
output umiClientId    string = datUmi.outputs.clientId
