#!/bin/bash

# Deploying the Master node
echo "Deploying Master node..."
vagrant up master

# Deploying the Slave node
echo "Deploying Slave node..."
vagrant up slave

# Installing net-tools on the master node
echo "Installing on master node"
sudo apt-get install -y avahi-dameon net-tools

# Installing net-tools on the slave node
echo "Installing on slave node"
sudo apt-get install -y avahi-dameon net-tools

# Enable SSH key-based authentication
echo "Configuring SSH key-based authentication..."
vagrant ssh master -c "ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa"
vagrant ssh master -c "ssh-copy-id vagrant@192.168.56.5"

# Testing SSH connection
echo "Testing SSH connection..."
vagrant ssh master -c "ssh vagrant@192.168.56.5 'echo SSH connection successful!'"

echo "Deployment complete!"