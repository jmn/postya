all: build deploy
.PHONY: all

build:
	cd .ansible && ansible-playbook -i apps/build/inventory apps/build/build.yml -vvv
	
deploy:
	cd .ansible && ansible-playbook -i apps/production/inventory apps/production/deploy.yml -vvv

secret:
	ansible-vault encrypt_string --vault-password-file ".ansible/.vault_pass.txt" --stdin-name "$name"
