New-AzResourceGroupDeployment -Name $deploymentName -TemplateFile $templateFile -storageName lgtestdisk -storageSKU Standard_GRS



New-AzResourceGroupDeployment -Name $deploymentName -TemplateFile $templateFile -storageName lgtestdisk -storageSKU Basic

$today=Get-Date -Format "MM-dd-yyyy"
$deploymentName="addOutputs-"+"$today"
New-AzResourceGroupDeployment -Name $deploymentName -TemplateFile $templateFile -storageName lgtestdisk -storageSKU Standard_LRS