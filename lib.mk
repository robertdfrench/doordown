SHELL=bash
.DEFAULT: help

which=$(shell which $(1) || echo ".missing.$(1)")

.missing.%:
	$(error You need to install $*)

help: Makefile ## Pretty-print the labelled targets
	@cat $< \
		| awk '/:/ && /## /' \
		| sed 's/:/:|/' | sed 's/## /|/' \
		| awk -F "|" '{ print "-",$$1,$$3 }' OFS='\t'
