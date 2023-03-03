# Idempotent script to set up a staging environment for a project using vagrant
# and virtualbox.  This script is intended to be run from the project root.

# First check that we are in the project root
if [ ! -f "Vagrantfile" ]; then
    echo "This script must be run from the project root"
    exit 1
fi

# Check that we have vagrant and virtualbox installed
if ! which vagrant > /dev/null; then
    echo "Vagrant is not installed"
    echo "Install Vagrant from https://www.vagrantup.com/downloads.html"
    exit 1
fi

# If we are on Windows, check that we have virtualbox installed
if [ "$(uname -s)" = "MINGW64_NT-10.0" ]; then
    if ! which virtualbox > /dev/null; then
        echo "Virtualbox is not installed"
        echo "Install Virtualbox from https://www.virtualbox.org/wiki/Downloads"
        exit 1
    fi
elif [ "$(uname -s)" = "Darwin" ]; then
    # If we are on MacOS, check that we have parallels installed
    if ! which parallels > /dev/null; then
        echo "Parallels is not installed"
        echo "Install Parallels from https://www.parallels.com/products/desktop/"
        exit 1
    fi
else
    # If we are on Linux, check that we have kvm/qemu installed
    if ! which qemu-kvm > /dev/null; then
        echo "QEMU/KVM is not installed"
        echo "Install QEMU/KVM from your package manager"
        exit 1
    fi
fi

# Check if control-plane, worker, or nas boxes are already running
if vagrant status | grep -Eq "(control-plane|worker|nas)"; then
    echo "One or more boxes are already running"
    echo "Run 'vagrant destroy' to destroy all boxes"
    exit 1
fi

# Start the vagrant box
vagrant up
