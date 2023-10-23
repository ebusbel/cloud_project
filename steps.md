Step 1: Provisioning Ubuntu-based Servers with Vagrant
1. I Installed Vagrant on my local machine
2. Created a new directory for project (called cloud_exam) and navigate to it in the terminal.
3. Create a Vagrantfile with the following configuration:

   config.vm.boot_timeout = 900

  config.vm.define "master" do |master|
    master.vm.box = "scotch/box"
    master.vm.hostname = "master"
    master.vm.network "private_network", ip: "192.168.56.4"
  end

  config.vm.define "slave" do |slave|
    slave.vm.box = "scotch/box"
    slave.vm.hostname = "slave"
    slave.vm.network "private_network", ip: "192.168.56.5"
  end
end


   I Created a bash script called provsision.sh to start provisioning the two Ubuntu-based servers. The reason is to help me automate and make sure there is internode commmunication between the master and slave machine.

Step 2: Created another Bash Script for LAMP Stack Deployment on the master Node
1. SSH into the Master node using vagrant ssh Master.
2. Created a bash script file called deploy_lamp.sh, and open it for editing.
3. Wrote the following code in the deploy_lamp.sh script: 
4. 
5. (installed apache, mysql, php and other neccessary packages). I also cloned the php application from gihub.

#!/bin/bash

# Update the system
sudo apt-get update

# Install Apache, MySQL, PHP, and other necessary packages
sudo apt-get install -y apache2 mysql-server php libapache2-mod-php php-mysql

# Clone the PHP application from GitHub
git clone https://github.com/laravel/laravel.git

# Configure Apache web server
sudo mv laravel /var/www/html/
sudo chown -R www-data:www-data /var/www/html/laravel
sudo chmod -R 755 /var/www/html/laravel

# Configure MySQL
sudo mysql -e "CREATE DATABASE laravel;"
sudo mysql -e "CREATE USER 'laravel'@'localhost' IDENTIFIED BY 'password';"
sudo mysql -e "GRANT ALL PRIVILEGES ON laravel.* TO 'laravel'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Restart Apache
sudo systemctl restart apache2

4. Save and exit the file.
5. ![my lampstack script](screenshots/lamp%20stack%20Screenshot%202023-10-18%20033548%20i%20wrote%20my%20bash%20script.jpg)

Step 3: Executing the Bash Script on the Slave Node Using Ansible
1. I Installed Ansible on my local machine.
2. Created my inventory file, where i targeted my slave node for deployment of the lamp stack, after that i then wrote my ansible playbook deploy.yml, and open it for editing.
3. Wrote the following code in the deploy.yml playbook:

yaml
---
- hosts: Slave
  become: yes
  tasks:
    - name: Copy and execute the bash script
      copy:
        src: deploy_lamp.sh
        dest: /tmp/deploy_lamp.sh
        mode: 0755
      shell: /tmp/deploy_lamp.sh


4. Save and exit the file.
5. ![ansible running on slave node](screenshots/ansible%20Screenshot%202023-10-22%20162931%20deployed%20my%20ansible%20to%20run%20on%20slave%20node%20from%20master.png)

Step 4: Verifying PHP Application Accessibility
1. I took note of the Slave node's IP address.
2. Run the Ansible playbook using the command ansible-playbook -i "Slave," deploy.yml.
3. After the playbook finishes executing, i opened my web browser and enter the Slave node's IP address to access the PHP application.
4. Take a screenshot as evidence.
5. ![php verification](screenshots/php%20Screenshot%202023-10-23%20015120%20my%20apache%20verification%20page.png)

Step 5: Creating a Cron Job to Check Server Uptime
1. I SSH into the Slave node using vagrant ssh Slave.
2. Run crontab -e to open the cron table for editing.
3. Add the following line to the file to check server uptime every day at 12 am:


0 0 * * * uptime >> /var/log/uptime.log


4. Save and exit the file.
5. ![cron job image](screenshots/cron%20job%20Screenshot%202023-10-22%20203158.png)

# For submission
Step 6: GitHub Repository and Documentation
1. I Created a new public repository on GitHub.
2. Push the deploy_lamp.sh script and deploy.yml playbook to the GitHub repository.
3. Create Markdown files (.md) for each step, including screenshots where necessary, to document my work.
4. I Added the Markdown files to my GitHub repository, providing a clear description of each step and the corresponding evidence screenshots.