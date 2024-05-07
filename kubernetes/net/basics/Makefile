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

ssh:
	vagrant ssh

status:
	vagrant status

destroy:
	vagrant destroy

bridge:
	sudo brctl addbr br-poo10
	sudo ifconfig br-poo10 up
	sudo clab deploy -t bridge.yaml

routing:
	sudo clab deploy -t routing.yaml

host-gw:
	sudo clab deploy -t host-gw.yaml

bridge-check:
	brctl showmacs

veth-check:
	sudo ethtools -S net0

tcpdump:
	@echo "Available interfaces:"
	@ip -o link show | awk -F': ' '{print $$1,$$2}'
	@read -p "Enter interface name: " interface; \
	read -p "Enter output file name: " filename; \
	sudo tcpdump -pne -i $$interface -w ./$$filename.pcap

clean-bridge:
	sudo clab destroy -t bridge.yaml
	sudo ifconfig br-poo10 down
	sudo brctl delbr br-poo10

clean-routing:
	sudo clab destroy -t routing.yaml

clean-veth-pair:
	sudo clab destroy -t veth-pair.yaml

clean-manual-veth-pair:
	sudo ip netns del ns1
	sudo ip netns del ns2

clean: clean-bridge clean-veth-pair clean-manual-veth-pair
