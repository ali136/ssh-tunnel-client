#!/bin/bash

# Set the proxy to use the SOCKS tunnel
set_proxy() {
    gsettings set org.gnome.system.proxy mode 'manual'
    gsettings set org.gnome.system.proxy.socks host '127.0.0.1'
    gsettings set org.gnome.system.proxy.socks port $socks
}

# Unset the proxy
unset_proxy() {
    gsettings set org.gnome.system.proxy mode 'none'
}

# Start the SSH tunnel
start_tunnel() {
    ssh -p $port -f -N -D $socks $username@$address
}

# Get the status of the SSH tunnel and proxy settings
 get_status() {
    ps_output=$(ps aux | grep -i "[s]sh -p $port -f")
    if [ -n "$ps_output" ]; then
        echo "SSH Tunnel is running:"
        echo "$ps_output"
    else
        echo "SSH Tunnel is not running."
    fi

    proxy_status=$(gsettings list-recursively org.gnome.system.proxy | grep -E 'mode|socks')
    echo "Proxy Settings:"
    echo "$proxy_status"
}

# Kill the SSH tunnel
kill_tunnel() {
    pids=$(pgrep -f "ssh -p $port -f")
    if [ -n "$pids" ]; then
        echo "Killing SSH Tunnel PIDs: $pids"
        kill $pids
    else
        echo "No SSH Tunnel process found."
    fi
}
configfile() {
    echo "setup sshtun!"
    echo ""
    echo "by generating ssh key you won'n need to enter your password every time"
    read -p 'Do you want to generate ssh key (y/n) ?' sshkey
    if [[ "$sshkey" == [yY] ]]; then
        ssh-keygen -t rsa
        message="you should upload generated .pub file into your ssh server otherwise you will be asked for password every time you run the tunnel"
    fi
    read -p 'ssh username: ' username
    read -p 'ssh server ip address or domain name: ' address
    read -p 'ssh server port number: ' port
    read -p 'local socks port default [1080]: ' socksport
    read -p 'is your answers correct (y/n): ' q
    if [[ "$q" == [yY] ]]; then
        echo "username='$username'" > $conffile
        echo "address='$address'" >> $conffile
        echo "port='$port'" >> $conffile
        if [ -z "${socksport}" ]; then
            socksport=1080
        fi
        echo "socks='$socksport'" >> $conffile
    else
        configfile
    fi
    curdir="${BASH_SOURCE[0]}"
    if [ ! -f $HOME/.bash_aliases ]; then
        echo "alias sshtun='source curdir'" > $HOME/.bash_aliases
        alias sshtun='source $curdir'
    else
        curconf=$(grep sshtun $HOME/.bash_aliases)
        if [ -z "${curconf}" ]; then
            echo "alias sshtun='source curdir'" >> $HOME/.bash_aliases
            alias sshtun='source curdir'
        fi
    fi
    if [ -n $message ]; then
        echo $message
    fi
}
conffile='.sshtun.conf'
if [ ! -f "$conffile" ]; then
    echo 'not configed'
    configfile
    exit;
fi
# Handle operations
operation=$1
source $conffile

case $operation in
    status)
        get_status
        ;;
    start)
        start_tunnel
        set_proxy
        ;;
    stop)
        kill_tunnel
        unset_proxy
        ;;
    restart)
        kill_tunnel
        start_tunnel
        set_proxy
        ;;
    config)
        configfile
        ;;
    *)
        echo "Usage: sshtun {status|start|stop|restart|config}"
        get_status
        ;;
esac

