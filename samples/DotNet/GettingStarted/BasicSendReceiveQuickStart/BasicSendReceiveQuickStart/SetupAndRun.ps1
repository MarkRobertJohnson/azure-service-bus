
if(!$subs) {
    # 1) Install the Service Bus PowerShell module:
    Install-Module AzureRM.ServiceBus -Force

    # 2) Run the following command to log in to Azure:
    $subs = Login-AzureRmAccount

    # 3) Set the current subscription context, or see the currently active subscription:

    Select-AzureRmSubscription -SubscriptionObject $subs.Context.Subscription

}

# Set your name or initials to uniquely identify your resources
$uniqueName = "mjohnson"

# Set the resource group nam
$resourceGroupName = "{0}-sb-ffthh-rg" -f $uniqueName

# Set the namespace name
$namespaceName = "inventory-{0}" -f $uniqueName

# Set the queue name
$queueName= "update"

Write-Host "NAMESPACE NAME: $namespaceName"
Write-Host "RESOURCE GROUP NAME: $resourceGroupName"
Write-Host "QUEUE NAME: $namespaceName"

# Create a resource group 
$sbrg = New-AzureRmResourceGroup –Name $resourceGroupName –Location westus2 -Verbose -Force

# Create a Messaging namespace
$sbns = New-AzureRmServiceBusNamespace -ResourceGroupName $resourceGroupName -NamespaceName $namespaceName -Location westus2 -Verbose

# Create a queue 
$sbq = New-AzureRmServiceBusQueue -ResourceGroupName $resourceGroupName -NamespaceName $namespaceName -Name $queueName -EnablePartitioning $False -Verbose

# Get primary connection string (required in next step)
Get-AzureRmServiceBusKey -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Name RootManageSharedAccessKey -Verbose | Tee-Object -Variable sbkey


dotnet $PSScriptRoot\bin\Debug\netcoreapp2.0\BasicSendReceiveQuickStart.dll -ConnectionString "$($sbkey.PrimaryConnectionString)" -QueueName "$queueName"