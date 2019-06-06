XARGS_CMD ?= xargs -I {}
BIN_DIR ?= ${HOME}/bin
PATH := $(BIN_DIR):${PATH}

SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c

.PHONY: %/install %/lint release/%

guard/program/%:
	@ which $* > /dev/null || $(MAKE) $*/install

$(BIN_DIR):
				@ echo "[make]: Creating directory '$@'..."
				mkdir -p $@

zip/install:
				@ echo "[$@]: Installing $(@D)..."
				apt-get install zip -y
				@ echo "[$@]: Completed successfully!"

terraform/install: TERRAFORM_VERSION ?= $(shell curl -sSL https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')
terraform/install: TERRAFORM_URL ?= https://releases.hashicorp.com/terraform/$(TERRAFORM_VERSION)/terraform_$(TERRAFORM_VERSION)_linux_amd64.zip
terraform/install: | $(BIN_DIR)
				@ echo "[$@]: Installing $(@D)..."
				@ echo "[$@]: TERRAFORM_URL=$(TERRAFORM_URL)"
				curl -sSL -o terraform.zip "$(TERRAFORM_URL)"
				unzip terraform.zip && rm -f terraform.zip && chmod +x terraform
				mv terraform "$(BIN_DIR)"
				terraform --version
				@ echo "[$@]: Completed successfully!"

terraform-docs/install: TFDOCS_VERSION ?= $(shell curl -sSL https://api.github.com/repos/segmentio/terraform-docs/releases/latest?access_token=4224d33b8569bec8473980bb1bdb982639426a92 | jq --raw-output  .tag_name)
terraform-docs/install: TFDOCS_URL ?= $(shell curl -sSL https://api.github.com/repos/segmentio/terraform-docs/releases/latest?access_token=4224d33b8569bec8473980bb1bdb982639426a92 | jq --raw-output  '.assets[] | select(.name=="terraform-docs-$(TFDOCS_VERSION)-linux-amd64") | .browser_download_url')
terraform-docs/install: | $(BIN_DIR)
				@ echo "[$@]: Installing $(@D)..."
				@ echo "[$@]: TFDOCS_URL=$(TFDOCS_URL)"
				curl -sSL -o terraform-docs "$(TFDOCS_URL)"
				chmod +x terraform-docs
				mv terraform-docs "$(BIN_DIR)"
				terraform-docs --version
				@ echo "[$@]: Completed successfully!"

pandoc/install: PANDOC_VERSION ?= $(shell curl -sSL https://api.github.com/repos/jgm/pandoc/releases/latest?access_token=4224d33b8569bec8473980bb1bdb982639426a92 | jq --raw-output  .tag_name)
pandoc/install: PANDOC_URL ?= $(shell curl -sSL https://api.github.com/repos/jgm/pandoc/releases/latest?access_token=4224d33b8569bec8473980bb1bdb982639426a92 | jq --raw-output  '.assets[] | select(.name=="pandoc-$(PANDOC_VERSION)-linux.tar.gz") | .browser_download_url')
pandoc/install: | $(BIN_DIR)
				@ echo "[$@]: Installing $(@D)..."
				@ echo "[$@]: PANDOC_URL=$(PANDOC_URL)"
				curl -sSL -o pandoc.tar.gz "$(PANDOC_URL)"
				tar xvzf pandoc.tar.gz -C "$(BIN_DIR)" --strip-components 2 --wildcards */pandoc
				rm -f pandoc.tar.gz
				chmod +x "$(BIN_DIR)/pandoc"
				pandoc --version
				@ echo "[$@]: Completed successfully!"

terraform/lint: | guard/program/terraform
				@ echo "[$@]: Linting Terraform files..."
				terraform fmt -check=true -diff=true
				@ echo "[$@]: Terraform files PASSED lint test!"

docs/lint: | guard/program/pandoc
docs/lint: | guard/program/terraform-docs
				@ echo "[$@]: Linting documentation files.."
				terraform-docs markdown table . > ./_docs/TF_MODULE.md
				pandoc -f gfm -t gfm ./_docs/MAIN.md -A ./_docs/TF_MODULE.md > TEST.md
				sed -i -e '/<!-- end list -->/d' TEST.md  # quirk of pandoc
				diff "TEST.md" "README.md" > /dev/null 2>&1 || (\
				echo "Changes found in the docs directory that are not present in README.md!"; exit 1)
				rm -f TEST.md
				echo "No changes detected"
				@ echo "[$@]: Documentation files PASSED lint test!"

docs/generate: | guard/program/pandoc
docs/generate: | guard/program/terraform-docs
				@ echo "[$@]: Creating documentation files.."
				terraform-docs markdown table . > ./_docs/TF_MODULE.md
				pandoc -f gfm -t gfm ./_docs/MAIN.md -A ./_docs/TF_MODULE.md > README.md
				sed -i -e '/<!-- end list -->/d' README.md  # quirk of pandoc
				@ echo "[$@]: Documentation files creation complete!"
