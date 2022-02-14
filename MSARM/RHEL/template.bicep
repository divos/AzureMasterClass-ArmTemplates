@secure()
param extensions_PostDeploy_storageAccountName string

@secure()
param extensions_PostDeploy_storageAccountKey string

@secure()
param extensions_PostDeploy_commandToExecute string
param virtualMachines_lgsys1_name string = 'lgsys1'
param networkInterfaces_lgsys1_0df49c42_name string = 'lgsys1-0df49c42'
param virtualNetworks_vn250_19_externalid string = '/subscriptions/482b137d-9da8-4c50-8a34-5d853e66c023/resourceGroups/rg-vn250-19/providers/Microsoft.Network/virtualNetworks/vn250-19'

resource networkInterfaces_lgsys1_0df49c42_name_resource 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: networkInterfaces_lgsys1_0df49c42_name
  location: 'westus2'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: '10.250.19.28'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '${virtualNetworks_vn250_19_externalid}/subnets/sub-private-vm1'
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
  }
}

resource virtualMachines_lgsys1_name_resource 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: virtualMachines_lgsys1_name
  location: 'westus2'
  tags: {
    'hidden-DevTestLabs-LogicalResourceUId': '86a1560d-c2b6-41d8-a45c-bf938c786333'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v4'
    }
    storageProfile: {
      imageReference: {
        publisher: 'RedHat'
        offer: 'RHEL'
        sku: '8_5'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${virtualMachines_lgsys1_name}_OsDisk_1_1056aa0515c345949d7109baef9cf0e3'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
          id: resourceId('Microsoft.Compute/disks', '${virtualMachines_lgsys1_name}_OsDisk_1_1056aa0515c345949d7109baef9cf0e3')
        }
        deleteOption: 'Detach'
        diskSizeGB: 64
      }
      dataDisks: []
    }
    osProfile: {
      computerName: virtualMachines_lgsys1_name
      adminUsername: 'sysadm'
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_lgsys1_0df49c42_name_resource.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
    priority: 'Regular'
  }
}

resource virtualMachines_lgsys1_name_PostDeploy 'Microsoft.Compute/virtualMachines/extensions@2021-07-01' = {
  parent: virtualMachines_lgsys1_name_resource
  name: 'PostDeploy'
  location: 'westus2'
  properties: {
    autoUpgradeMinorVersion: true
    publisher: 'Microsoft.Azure.Extensions'
    type: 'CustomScript'
    typeHandlerVersion: '2.1'
    settings: {
      fileUris: [
        'https://aoneidentitynaidm23839.blob.core.windows.net/artifacts/Redhat8-ProductInstall.132893332375057693/Redhat8-Product52319928/PostDeploy.sh?sv=2019-07-07&st=2022-02-14T17%3A12%3A21Z&se=2022-02-15T17%3A27%3A21Z&sr=c&sp=rl&sig=5ri0lATZMhqd0qpcGEqQQ7ES3p52A0GM%2B4BhKma7ShA%3D'
      ]
    }
    protectedSettings: {
      storageAccountName: extensions_PostDeploy_storageAccountName
      storageAccountKey: extensions_PostDeploy_storageAccountKey
      commandToExecute: extensions_PostDeploy_commandToExecute
    }
  }
}