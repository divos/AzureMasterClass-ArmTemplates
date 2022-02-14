$templateFile="azuredeploy.json"
$today=Get-Date -Format "MM-dd-yyyy"
 $deploymentName="addfunction-"+"$today"
Connect-AzAccount
Set-AzContext -Subscription devtest-support
Set-azdefault -ResourceGroupName OneIdentity-NA-IDM2

New-AzResourceGroupDeployment -Name $deploymentName -TemplateFile $templateFile -storagePrefix {lgsto}