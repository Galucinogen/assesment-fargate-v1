.EXPORT_ALL_VARIABLES:

.NOTPARALLEL:

.PHONY: help terraform

DIR=terraform/aws

help:
	@cat Makefile* | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

plan: ## Plan Infrastructure
	@echo "Plan infrastructure" && cd $(DIR) && terraform init && terraform plan -out=plan.out

deploy: ## Deploy Infrastructure
	@echo "Deploy infrastructure" && cd $(DIR) && terraform apply

tests: ## Test infrastructure
	@echo "Run the tests" && cd $(DIR) && terraform-compliance --features tests/ --planfile terraform/aws/plan.out

cleanup: ## Cleanup Infrastructure
	@echo "Cleanup infrastructure" && cd $(DIR) && terraform destroy