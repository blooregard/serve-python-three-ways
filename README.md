# serve-python-three-ways
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

docker build -t serve_python_3_ways -f Dockerfile.aks . 
docker run -d -p 80:80 --name serve_python_3_ways serve_python_3_ways
curl http://localhost/lotto

az login

terraform init
terraform plan
terraform apply

az aks get-credentials --resource-group python-served-three-ways-rg --name python-aks
kubectl get nodes

az acr login --name servepythonthreeways
az acr build --image serve-python-three-ways:v1 --registry servepythonthreeways --file Dockerfile.aks .