bootstrap:
	@ansible-playbook \
	--inventory inventory-bootstrap.yml \
	--ask-become-pass \
	bootstrap.yml

site:
	@ansible-playbook \
	--inventory inventory.yml \
	--private-key ~/.ssh/ansible \
	--user ansible \
	site.yml