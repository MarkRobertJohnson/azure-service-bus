#### LAB2 
$topicName = 'inventoryupdated'
New-AzureRmServiceBusTopic -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Name $topicName -Verbose -EnablePartitioning:$false




#Get-AzureRmServiceBusKey -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Name default -Verbose -TopicName $topicName | Tee-Object -Variable sbtopickey

New-AzureRmServiceBusSubscription -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Topic $topicName -Name s1
New-AzureRmServiceBusSubscription -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Topic $topicName -Name s2
New-AzureRmServiceBusSubscription -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Topic $topicName -Name s3

# Create acces policy
New-AzureRmServiceBusAuthorizationRule -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Topic $topicName -Name default -Rights @("Listen","manage","send") -Verbose


Get-AzureRmServiceBusKey -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Name RootManageSharedAccessKey -Verbose | Tee-Object -Variable sbkey


dotnet build

dotnet BasicSendReceiveTutorialwithFilters\bin\Debug\netcoreapp2.0\BasicSendReceiveTutorialwithFilters.dll -ConnectionString "$($sbkey.PrimaryConnectionString)" -TopicName $topicName