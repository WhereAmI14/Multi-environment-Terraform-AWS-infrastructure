.PHONY: setup fmt fmt-check validate lint security init-dev init-staging init-production plan-dev plan-staging plan-production cost-dev cost-staging cost-production

setup:
	pre-commit install
	tflint --init

fmt:
	terraform fmt -recursive

fmt-check:
	terraform fmt -check -recursive

validate:
	terraform -chdir=dev init -backend=false
	terraform -chdir=dev validate
	terraform -chdir=staging init -backend=false
	terraform -chdir=staging validate
	terraform -chdir=production init -backend=false
	terraform -chdir=production validate

lint:
	tflint --recursive

security:
	checkov -d . --framework terraform --quiet

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
