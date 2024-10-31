# nominatim tests chart

## deploy KIND cluster

```console
kind create cluster --name mycc --config kind-cluster.yaml
```

## deploy ingress

```console
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
```

## add dns nominatim.local

```console
# run as sudo
echo "127.0.0.1 nominatim" >> /etc/hosts
```

## install helm

```console
helm upgrade -i nominatim chart -n nominatim --create-namespace
```
