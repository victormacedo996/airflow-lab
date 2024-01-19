.PHONY: all check-dependencies

.DEFAULT_GOAL := help 

help: ## Show this help
		@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?# "}; {printf "\033[36m%-40s\033[0m %s\n", $$1, $$2}'

check-dependencies: ## Check dependencies
	@helm version

	@kubectl version

install-postgres: check-dependencies ## install postgres 
	@kubectl apply -f ./apps/airflow/manifests/namespace.yaml
	@kubectl apply -f ./apps/airflow/postgres/deployment.yaml
	@kubectl apply -f ./apps/airflow/postgres/service.yaml

install-airflow: check-dependencies install-postgres  ## Install Airflow

	@kubectl apply -f ./apps/airflow/manifests/namespace.yaml
	@kubectl apply -f ./apps/airflow/manifests/airflow-secrets.yaml
	@kubectl apply -f ./apps/airflow/manifests/secret-gitsync.yaml

	@helm upgrade --install airflow --repo=https://airflow.apache.org/ \
		--namespace=airflow \
		--version 1.11.0 \
		--values ./apps/airflow/manifests/values.yaml \
		--create-namespace \
		airflow
