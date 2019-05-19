include lib.mk

.PRECIOUS: terraform.tfstate
terraform=$(call which, terraform)
SOURCES=$(wildcard *.tf) terraform.tfvars provision.sh

deploy: terraform.tfstate ## Deploy changes
	$(terraform) output -state=$<

terraform.tfstate: terraform.plan $(terraform)
	$(terraform) apply $<

terraform.plan: .terraform/ready $(terraform) $(SOURCES)
	$(terraform) plan -out=$@

plan: .terraform/ready $(terraform) ## Review the plan
	$(terraform) plan

lint: $(terraform) ## Make sure your terraform looks nice
	$(terraform) fmt -check -diff

.terraform/ready: $(terraform)
	$(terraform) init
	@touch $@
