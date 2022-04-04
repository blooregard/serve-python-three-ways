# serve-python-three-ways

docker build -f Dockerfile.aks .

az login

terraform init
terraform plan
terraform apply

az aks get-credentials --resource-group python-served-three-ways-rg --name python-aks
kubectl get nodes

az acr login --name servepythonthreeways
az acr build --image serve-python-three-ways:v1 --registry servepythonthreeways --file Dockerfile.aks .