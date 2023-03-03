VAGRANT_PROJECT_ROOT := $(shell pwd)
VAGRANTFILE := $(VAGRANT_PROJECT_ROOT)/Vagrantfile

# Check that we are in the project root
.PHONY: check-project-root
check-project-root:
ifeq ($(wildcard $(VAGRANTFILE)),)
	@echo "This script must be run from the project root"
	@exit 1
endif

# Check that Vagrant is installed
.PHONY: check-vagrant
check-vagrant:
ifeq ($(shell which vagrant),)
	@echo "Vagrant is not installed"
	@echo "Install Vagrant from https://www.vagrantup.com/downloads.html"
	@exit 1
endif

# Check that the appropriate virtualization software is installed
.PHONY: check-virtualization-software
check-virtualization-software:
ifeq ($(shell uname -s),MINGW64_NT-10.0)
	ifeq ($(shell which virtualbox),)
		@echo "VirtualBox is not installed"
		@echo "Install VirtualBox from https://www.virtualbox.org/wiki/Downloads"
		@exit 1
	endif
else ifeq ($(shell uname -s),Darwin)
	ifeq ($(wildcard /Applications/Parallels\ Desktop.app),)
		@echo "Parallels Desktop is not installed"
		@echo "Install Parallels Desktop from https://www.parallels.com/products/desktop/"
		@exit 1
	endif
else
	ifeq ($(shell which qemu-kvm),)
		@echo "QEMU/KVM is not installed"
		@echo "Install QEMU/KVM from your package manager"
		@exit 1
	endif
endif

# Check that no boxes are already running
.PHONY: check-no-boxes-running
check-no-boxes-running:
ifneq ($(shell vagrant status | grep "running"),)
	@echo "One or more boxes are already running"
	@echo "Run 'make destroy-all-boxes' to destroy all boxes"
	@exit 1
endif

# Start the vagrant staging environment
.PHONY: start-staging-environment
start-staging-environment: check-project-root check-vagrant check-virtualization-software check-no-boxes-running
	vagrant up nas
	vagrant ssh nas -c "exit"
	vagrant up worker
	vagrant ssh worker -c "exit"
	vagrant up control-plane

# Stop and destroy all running boxes
.PHONY: destroy-all-boxes
destroy-all-boxes:
	vagrant destroy -f