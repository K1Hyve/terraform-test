.PHONY: gen
gen: gen-chart-doc

.PHONY: gen-chart-doc
gen-chart-doc:
	@echo "Generate docs"
	@terraform-docs markdown table terraform
