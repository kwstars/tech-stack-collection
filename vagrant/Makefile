change-vbox-path:
	@read -p "Enter virtualbox path: " path; \
	current_path=$$(VBoxManage list systemproperties | grep "Default machine folder" | cut -d ':' -f 2 | xargs); \
	if [ ! -d $$path ]; then sudo mkdir -p $$path; sudo chown $(shell id -un):$(shell id -un) $$path; fi; \
	if [ "$$current_path" != "$$path" ]; then \
		VBoxManage setproperty machinefolder $$path; \
		sudo systemctl restart virtualbox; \
	fi
	VBoxManage list systemproperties | grep "Default machine folder"

up:
	vagrant up
	vagrant reload

ssh:
	vagrant ssh

status:
	vagrant status

destroy:
	vagrant destroy
