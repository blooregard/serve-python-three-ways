# serve-python-three-ways

## Create a virtual environment and install the required python packages
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

## Build the docker image and test it
docker build -t serve_python_3_ways -f Dockerfile.aks . 
docker run -d -p 80:80 --name serve_python_3_ways serve_python_3_ways
curl http://localhost/lotto

## Login to your Azure account (https://azure.microsoft.com/en-us/free/ if you need a free one)
az login

## Run the Terraform to create the Azure Infrastructure
terraform init
terraform plan
terraform apply

## Get the AKS credentials and test that it was setup
az aks get-credentials --resource-group python-served-three-ways-rg --name python-aks
kubectl get nodes

## Login to the ACR and push your docker image into it
az acr login --name servepythonthreeways
az acr build --image serve-python-three-ways:v1 --registry servepythonthreeways --file Dockerfile.aks .

## Attach the ACR to the AKS cluster
az aks update -n python-aks -g python-served-three-ways-rg --attach-acr servepythonthreeways

## Create the Helm Chart and modify values (already done for you here)
helm create serve-python-aks-chart

## Package up the Chart and install it
helm package serve-python-aks-chart
helm install aks-release-1 serve-python-aks-chart-0.1.0.tgz

## Get the IP and Status
kubectl get svc
kubectl get pods

curl -X POST -v http://52.149.238.52/lotto

