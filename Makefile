export KUBECONFIG=.kubeconfig
export KIND_CLUSTER_NAME=signoz-test

all:
	@echo "all"

create-registry:
	./scripts/createregistry.sh

destroy-registry:
	./scripts/destroyregistry.sh

create-cluster: create-registry
	kind create cluster --config=./kind-config.yaml
	./scripts/connectregistry.sh
	kubectl cluster-info --context kind-signoz-test

destroy-cluster: destroy-registry
	kind delete cluster

helm-prepare:
	helm repo add signoz https://charts.signoz.io
	helm repo update

install-signoz:
	kubectl create ns platform
	helm --namespace platform install my-release signoz/signoz
	sleep 30
	kubectl -n platform wait --for=condition=ready \
      pod -l "app.kubernetes.io/component=frontend" --timeout=30m

uninstall-signoz:
	helm uninstall --namespace platform my-release
	kubectl -n platform patch clickhouseinstallations.clickhouse.altinity.com/my-release-clickhouse -p '{"metadata":{"finalizers":[]}}' --type=merge
	kubectl -n platform delete pvc -l app.kubernetes.io/instance=my-release
	kubectl delete namespace platform

connect-web:
	echo "Visit http://127.0.0.1:3301 to use your application"
	kubectl --namespace platform port-forward `kubectl get pods --namespace platform -l "app.kubernetes.io/name=signoz,app.kubernetes.io/instance=my-release,app.kubernetes.io/component=frontend" -o jsonpath="{.items[0].metadata.name}"` 3301:3301



