.DEFAULT_GOAL := site

prechecks:
ifndef ENV
  $(warning ENV was not set, defaulting to all)
  ENV=all
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
	--limit $(ENV) \
	--vault-password-file pass-client.sh \
	--extra-vars @files/vault.yml \
	bootstrap.yml

site: prechecks loadkey bootstrap
	@ansible-playbook \
	--inventory inventory.yml \
	--user ansible \
	--limit $(ENV) \
	--vault-password-file pass-client.sh \
	--extra-vars @files/vault.yml \
	site.yml