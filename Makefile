.DEFAULT_GOAL := site

prechecks:

ifndef ENV
  $(warning ENV was not set, defaulting to all)
  ENV=all
endif

BECOME := $(@pass linux/melvyn)

bootstrap: prechecks
	@ansible-playbook \
	--inventory inventory-bootstrap.yml \
	--limit $(ENV) \
	--vault-password-file pass-client.sh \
	--extra-vars @vault.yml \
	bootstrap.yml

site: prechecks bootstrap
	@ansible-playbook \
	--inventory inventory.yml \
	--private-key ~/.ssh/ansible \
	--user ansible \
	--limit $(ENV) \
	--vault-password-file pass-client.sh \
	--extra-vars @vault.yml \
	site.yml

vault:
	@ansible-vault edit \
	--vault-password-file ./pass-client.sh \
	vault.yml