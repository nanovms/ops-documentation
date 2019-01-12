.PHONY: test clean

# test that we can spin up an OS and install ops and run a basic command
test:
	vagrant up ${OS} && vagrant ssh ${OS} -- -t /home/vagrant/.ops/bin/ops list

# clean up vagrant
clean:
	vagrant destroy -f
