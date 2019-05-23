include lib.mk

.PRECIOUS: terraform.tfstate
terraform=$(call which, terraform)
SOURCES=$(wildcard *.tf) terraform.tfvars provision.sh

all: deploy
	git push doordown

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

build: webserver.exe webapp.door ## Compile and run the doordown server
	LD_LIBRARY_PATH=/opt/local/lib:$$LD_LIBRARY_PATH ./webserver.exe 3000

webapp.door: webapp.exe
	./webapp.exe &
	sleep 1

webserver.exe: main.c
	gcc -I/opt/local/include -L/opt/local/lib -lmicrohttpd $< -o $@

webapp.exe: application.c
	gcc $< -o $@

.terraform/ready: $(terraform)
	$(terraform) init
	@touch $@
