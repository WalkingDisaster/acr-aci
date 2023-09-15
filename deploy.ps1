function Get-Timestamp {
    Write-Output (Get-Date -Format "yyyyMMddHHmmss")
}


# Prerequisites
Set-Location -Path ./0.prerequisites
Write-Host $pwd
Set-Location -Path  ..

# Network & ACR
Set-Location -Path  ./1.network-and-acr
Write-Host $pwd
$deploymentName = "networkandacr-$(Get-Timestamp)"
$output = (az deployment group create -g $rg -f ./azuredeploy.json -p @sandbox-parameters.json -n $deploymentName)
$outputObj = ($output | ConvertFrom-Json) 
$acrName = $outputObj.properties.outputs.acrName.value
$aciIdentity = $outputObj.properties.outputs.aciIdentity.value
Set-Location -Path  ..

# Interim Setup
Set-Location -Path  ./2.interim-setup
# Read the readme in this folder
Write-Host $pwd
. ./setup.ps1 -ResourceGroup $rg -AcrName $acrName -AciIdentity $aciIdentity
Set-Location -Path  ..

# Services
Set-Location -Path  ./3.services
Write-Host $pwd
$deploymentName = "networkandacr-$(Get-Timestamp)"
az deployment group create -g $rg -f ./azuredeploy.json -p @sandbox-parameters.json -n $deploymentName
Set-Location -Path  ..
