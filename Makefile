CHECKOV_SKIP_CHECKS := CKV_AWS_260,CKV_AWS_382,CKV_AWS_23,CKV_AWS_79,CKV_AWS_88,CKV_AWS_8,CKV_AWS_126,CKV_AWS_135,CKV2_AWS_41,CKV_AWS_130,CKV2_AWS_11,CKV2_AWS_12,CKV_AWS_158,CKV_AWS_18,CKV_AWS_144,CKV2_AWS_61,CKV2_AWS_62,CKV_AWS_145,CKV_AWS_226,CKV_AWS_353,CKV_AWS_157,CKV_AWS_293,CKV_AWS_118,CKV_AWS_161,CKV_AWS_129,CKV2_AWS_60

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
	checkov -d . --framework terraform --quiet --skip-check "$(CHECKOV_SKIP_CHECKS)"

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
