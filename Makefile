include lib.mk

terraform=$(call which, terraform)

apply: plan $(terraform) ## Make the changes
	$(terraform) apply plan

plan: lint .terraform/ready $(terraform) ## Check terraform plan for obvious errors
	$(terraform) plan -out=$@

lint: $(terraform) ## Make your terraform look nice
	$(terraform) fmt -check -diff

.terraform/ready: $(terraform)
	$(terraform) init
	@touch $@
