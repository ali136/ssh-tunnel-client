# Setting Up SSH Tunnel Server on MikroTik

To use this SSH tunnel client script, you need to set up an SSH tunnel server on your MikroTik router. Follow the steps below to configure your MikroTik router:
### 1. Enable SSH Service

First, enable the SSH service on your MikroTik router and set a custom port number:

    /ip service set disabled=no port=<port number>

Replace <port number> with the port number you want to use for the SSH service.
### 2. Enable SSH Forwarding

Next, enable SSH forwarding on your router:

    /ip ssh set forwarding-enabled=local

This setting allows your MikroTik router to forward traffic from the SSH tunnel.
### 3. Create a User Group for SSH Access

Create a new user group with SSH access policies:

    /user group add name=ssh policy=ssh

### 4. Add a New User

Add a new user to the router and assign it to the SSH group:

    /user add name=yourname password=yourpass group=ssh

Replace yourname with your desired username and yourpass with your desired password.
### 5. Import SSH Public Key (Optional)

If you have generated an SSH key pair and uploaded the .pub file to your router, you need to import it for your user:

    /user ssh-keys import user=yourname public-key-file=id_rsa.pub

Replace yourname with your username and id_rsa.pub with the name of your public key file.

This step allows passwordless authentication using your SSH key, enhancing security and convenience when connecting to the SSH tunnel server.


# Setting Up SSH Tunnel Server on Ubuntu (Restricted Access)

To use the SSH tunnel client script, you need to set up an SSH tunnel server on an Ubuntu server with restricted access so that clients can only use it for tunneling and not for logging into the server’s shell. Below are the step-by-step instructions to configure your Ubuntu server:
### 1. Install OpenSSH Server

If you don't already have the OpenSSH server installed, you'll need to install it:

    sudo apt update
    sudo apt install openssh-server

### 2. Enable and Start the SSH Service

After installation, make sure the SSH service is enabled and running:

    sudo systemctl enable ssh
    sudo systemctl start ssh

### 3. Configure the SSH Server

Edit the SSH configuration file to set up the custom port, disable root login, enable TCP forwarding, and restrict the shell access:

    sudo nano /etc/ssh/sshd_config

In the configuration file:

Change the default port: Find the line #Port 22 and replace it with your desired port number, for example:

    Port 2200

Enable SSH forwarding: Find the line AllowTcpForwarding and ensure it is set to yes:

    AllowTcpForwarding local

Save the changes and exit the editor.
### 4. Restart the SSH Service

Apply the configuration changes by restarting the SSH service:

    sudo systemctl restart ssh

### 5. Create a New User with Restricted Access

Add a new user that will be used for SSH tunnel access and restrict its shell:

    sudo adduser --shell /usr/sbin/nologin yourname

Replace yourname with your desired username. This command sets the user's shell to /usr/sbin/nologin, preventing them from logging into the server's shell.
### 6. (Optional) Set Up SSH Key-Based Authentication
run these commands from your local machine!

For enhanced security, you can set up SSH key-based authentication. First, generate an SSH key pair on your local machine if you haven't already:

    ssh-keygen -t rsa

Next, copy the public key to your Ubuntu server:

    ssh-copy-id -i ~/.ssh/id_rsa.pub yourname@server_ip_address

Replace yourname with your username and server_ip_address with your server's IP address. This allows you to log in without a password.
