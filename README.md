# ssh-tunnel-client

This Bash script is designed to create and manage SSH tunnels with SOCKS proxy on a Linux system. It provides a simple way to configure, start, stop, and check the status of an SSH tunnel, and automatically sets the system proxy settings to route traffic through the tunnel.
written and teste on ubuntu 22.04 desktop
Features

    Start SSH Tunnel: Establishes an SSH tunnel with a SOCKS proxy.
    Stop SSH Tunnel: Terminates the SSH tunnel and resets proxy settings.
    Status Check: Provides the current status of the SSH tunnel and proxy settings.
    Configuration: Allows easy setup and reconfiguration of the SSH connection details.

# Installation

Clone the repository:

    git clone https://github.com/ali136/ssh-tunnel-client.git

Make the script executable:

    chmod +x sshtunnel.sh

Run the script with the config option to set up your SSH tunnel:

    ./sshtunnel.sh config

# Usage

After configuring the script, you can use the following commands:

Start the SSH tunnel and set the proxy:

    sshtun start

Stop the SSH tunnel and unset the proxy:

    sshtun stop

Restart the SSH tunnel:

    sshtun restart

Check the status of the SSH tunnel and proxy settings:

    sshtun status

Reconfigure the SSH tunnel settings:

    sshtun config

# Configuration

During the initial setup, the script will prompt you to enter:

    SSH username
    SSH server IP address or domain name
    SSH server port number
    Local SOCKS port (default: 1080)

You can also choose to generate an SSH key pair to avoid entering your password every time you start the tunnel. If you opt to generate a key, remember to upload the .pub file to your SSH server.
Alias Setup

The script automatically adds an alias to your .bash_aliases file, allowing you to use the **sshtun** command from any terminal session.

Feel free to submit issues or pull requests. Contributions are welcome!
Author

Ali
