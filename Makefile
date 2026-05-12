.PHONY: setup fmt fmt-check validate lint security docs init-dev init-staging init-production plan-dev plan-staging plan-production cost-dev cost-staging cost-production

setup:
	pre-commit install
	tflint --init

fmt:
	terraform fmt -recursive

fmt-check:
	terraform fmt -check -recursive

validate:
	TF_DATA_DIR=$(CURDIR)/.terraform-validate/dev terraform -chdir=dev init -backend=false -input=false -reconfigure
	TF_DATA_DIR=$(CURDIR)/.terraform-validate/dev terraform -chdir=dev validate
	TF_DATA_DIR=$(CURDIR)/.terraform-validate/staging terraform -chdir=staging init -backend=false -input=false -reconfigure
	TF_DATA_DIR=$(CURDIR)/.terraform-validate/staging terraform -chdir=staging validate
	TF_DATA_DIR=$(CURDIR)/.terraform-validate/production terraform -chdir=production init -backend=false -input=false -reconfigure
	TF_DATA_DIR=$(CURDIR)/.terraform-validate/production terraform -chdir=production validate

lint:
	tflint --recursive

security:
	checkov -d . --config-file .checkov.yml

docs:
	terraform-docs markdown table --output-file README.md --output-mode inject .

init-dev:
	terraform -chdir=dev init -backend-config=backend.hcl

init-staging:
	terraform -chdir=staging init -backend-config=backend.hcl

init-production:
	terraform -chdir=production init -backend-config=backend.hcl

plan-dev:
	terraform -chdir=dev plan

plan-staging:
	terraform -chdir=staging plan

plan-production:
	terraform -chdir=production plan

cost-dev:
	infracost breakdown --path dev

cost-staging:
	infracost breakdown --path staging

cost-production:
	infracost breakdown --path production
