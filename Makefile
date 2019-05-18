include lib.mk

terraform=$(call which, terraform)

plan: $(terraform) ## Check terraform plan for obvious errors
	$(terraform) plan
