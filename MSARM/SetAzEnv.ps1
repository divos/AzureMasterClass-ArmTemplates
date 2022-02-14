az login
az account set --subscription devtest-support


$context = Get-AzSubscription -SubscriptionId {482b137d-9da8-4c50-8a34-5d853e66c023}
Set-AzContext $context