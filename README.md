# README

- this shows two bugs / issues with signoz

## Issues

### Want 1

- A golang sample application creates json logs (using logrus)
- What we want in SigNoz
- customer_id, database, level, product_id stripped from body and put into attributes

```json
{"customer_id":"d2c1ad43-70a5-4e8b-aa3d-d92d0cc4eb49","database":"DC/EU/WEST","level":"debug","message":"debug message","product_id":"de733801-0f7a-45fa-a5d3-e9e6ae0b859a"}
{"customer_id":"d2c1ad43-70a5-4e8b-aa3d-d92d0cc4eb49","database":"DC/EU/WEST","level":"info","message":"info message","product_id":"de733801-0f7a-45fa-a5d3-e9e6ae0b859a"}
{"customer_id":"d2c1ad43-70a5-4e8b-aa3d-d92d0cc4eb49","database":"DC/EU/WEST","level":"error","message":"Error message","product_id":"de733801-0f7a-45fa-a5d3-e9e6ae0b859a"}
```

I am providing a `values-with-operators.yaml` file, that can extract `level` in order to work, that will need an insane chain of operators. What I learned from slack, "pipeline" is much better than operators, but there is no pipeline section (yet) supported by signoz.

Reference Links so far:

- <https://signoz.io/docs/userguide/logs/#operators-for-parsing-and-manipulating-logs>
- <https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/pkg/stanza/docs/operators/json_parser.md>
- <https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/pkg/stanza/docs/types/pipeline.md>

**Very important!** It is irrelevant for us if we parse this from the stdout in k8s  (via operators or pipeline). If there is a way to send from logrus directly to OTEL - in a nice format - that would also solve the problem. I repeat this again...

### Want 2

- Check the Makefile sometimes the helm installation is unstable and it takes up to 30min.
- There is a chicken / egg issue in pods waiting and creating a rare deadlock.
- Want 1 is much more important.

## What do you need?

- kind
- go
- kubectl
- make

## How to us es this?

```bash
# creates a cluster (including local registry for the test deployment)
make create-cluster
# install signoz in the cluster
make install-signoz
# install hello world deployment that makes log noise
make deployment
# open web ui
make connect-web
```

## Run Kubectl

```bash
export KUBECONFIG=./kubeconfig
kubectl cluster-info --context kind-signoz-test
```

## Cleanup

```bash
make destroy-cluster
```
