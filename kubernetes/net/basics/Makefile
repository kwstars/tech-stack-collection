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
