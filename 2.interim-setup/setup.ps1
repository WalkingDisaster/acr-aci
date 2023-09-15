param (
    [Parameter(Mandatory = $true)]
    [string]
    $ResourceGroup,

    [Parameter(Mandatory = $true)]
    [string]
    $AcrName,

    [Parameter(Mandatory = $true)]
    [string]
    $AciIdentity
)

az acr login -n $AcrName
docker login "$AcrName.azurecr.io"
docker pull nginx
docker tag nginx "$AcrName.azurecr.io/samples/nginx"
docker push "$AcrName.azurecr.io/samples/nginx"

# Get service principal ID of the user-assigned identity
$spId = $(az identity show --resource-group $ResourceGroup --name $AciIdentity --query principalId --output tsv)

$acrId = (az resource show -g $rg -n $acrName --resource-type "Microsoft.ContainerRegistry/registries" --query "id")
az role assignment create --assignee $spId --scope $acrId --role AcrPull