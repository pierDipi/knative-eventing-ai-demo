## Installing on KinD

```shell
./infra/kind-deploy.sh
```

## Connect to Superset Dashboard UI

```shell
kubectl port-forward service/superset 8088:8088 --namespace superset
# Open http://127.0.0.1:8088/
```