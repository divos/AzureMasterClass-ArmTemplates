param virtualMachineName string
@allowed([
  'vn2501'
  'vn25019'
])
param virtualNetwork string = 'vn25019'
param subnetName string = 'sub-private-vm1'
@allowed([
  'No'
  'Yes'
])
@description('Adding a public IP when it is allowed in the vNet')
param addPublicIP string = 'No'
@description('Leave blank to use no DNS.')
param DNS string
@allowed([
  'Spot'
  'Regular'
])
@description('Spot may turn off VM unexpectedly')
param priority string = 'Regular'
@allowed([
  'Windows2019'
  'Windows2016'
  'Windows2012R2'
  'Windows2022'
])
param OS string
@allowed([
  'AutomaticByOS'
  'Manual'
])
param patchMode string = 'AutomaticByOS'
@allowed([
  'Standard_LRS'
  'StardardSSD_LRS'
  'Premium_LRS'
])
param osDiskType string = 'Standard_LRS'
@allowed([
  'Standard_D2s_v4'
  'Standard_E2ds_v4'
  'Standard_D4s_v4'
  'Standard_E4ds_v4'
  'Standard_D8s_v4'
])
param virtualMachineSize string = 'Standard_D2s_v4'
param adminUsername string = 'sysadm'
@secure()
param adminPassword string
@description('Path to the nested templates used in this deployment')
param _artifactsLocation string = 'https://sadevtesthub.blob.core.windows.net/private/AD-3VM-Env'
@secure()
@description('SAS token to access artifacts locatin, if required')
param _artifactsLocationSasToken string

var location = 'westus2'
var vn2501 = '/subscriptions/482b137d-9da8-4c50-8a34-5d853e66c023/resourcegroups/rg-vn250-1/providers/microsoft.network/virtualnetworks/vn250-1'
var vn25019 = '/subscriptions/482b137d-9da8-4c50-8a34-5d853e66c023/resourcegroups/rg-vn250-19/providers/microsoft.network/virtualnetworks/vn250-19'
var vnetId = virtualNetwork
var subnetRef = '${vnetId}subnetName'
var networkinterfaceName = '{virtualMachineName}'
