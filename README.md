# nominatim tests chart

## deploy KIND cluster

```console
kind create cluster --name dev --config kind-cluster.yaml
```

## deploy ingress

```console
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
```

## add dns nominatim.local

```console
# run as sudo
echo "127.0.0.1 nominatim.local" >> /etc/hosts
```

## install metrics-server

```console
helm upgrade -i metrics-server metrics-server/metrics-server -n metrics-server --create-namespace
```

## install helm

```console
helm upgrade -i nominatim-api charts/nominatim-api -n nominatim --create-namespace
helm upgrade -i nominatim-db charts/nominatim-db -n nominatim --create-namespace
```
