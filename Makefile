.DEFAULT_GOAL := site

prechecks:
ifndef TARGET
  $(warning TARGET was not set, defaulting to all)
  TARGET=all
endif

vault:
	@ansible-vault edit \
	--vault-password-file pass-client.sh \
	files/vault.yml

loadkey:
	@ansible-vault view \
	--vault-password-file pass-client.sh \
	files/vault_ssh_key | \
	ssh-add -q -t 600 -

bootstrap: prechecks
	@ansible-playbook \
	--inventory inventory-bootstrap.yml \
	--limit $(TARGET) \
	--vault-password-file pass-client.sh \
	--extra-vars @files/vault.yml \
	bootstrap.yml

site: prechecks loadkey bootstrap
	@ansible-playbook \
	--inventory inventory.yml \
	--user ansible \
	--limit $(TARGET) \
	--vault-password-file pass-client.sh \
	--extra-vars @files/vault.yml \
	site.yml
