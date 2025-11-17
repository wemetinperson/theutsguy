#!/bin/sh

  
# www.theutsguy.com
# www.youtube.com/@theutsguy


# This is meant to help you setup an OpenWRT router with multiple wireguard
# configs and have it randomly pick one every time you reboot and at
# predefined intervals using crontab

# ZERO AI WAS USED IN THE MAKING OF THIS. 100% GENUINE HUMAN SLOPPY CODE!
# YES, THIS IS INEFFICIENT AND SLOPPY CODE. I GUARANTEE YOU CAN DO THIS
# BETTER THAN ME. I JUST BUILT THIS FOR MYSELF TO LEARN AND AM GIVING 
# IT OUT TO ANYONE FOR FREE. FIX THE PROBLEMS, MAKE IT BETTER, AND SHARE 
# WITH THE COMMUNITY.  
# CAN ALL THIS BE AUTOMATED? CAN I JUST BUILD THIS INTO CUSTOM FIRMWARE? SURE!
# BUT I HAVE A JOB SO I DON'T HAVE TIME.



# INSTRUCTIONS:
# NOTE: DO NOT configure wireguard through LUCI as it will cause conflicts with WIREHARD
# LOGS: /root/wg.log contains some basic log info and purges after 300 entries. You can modify
#       this manually below in the final IF clause if you know what you're doing.
#
# The KILL SWITCH is enabled by default and will be re-enabled after every reboot unless
# you modify the behavior as indicated below in the rc.local section.
#
# To disable WIREHARD and just browse normally, log into the GUI via a web browser
# Go to "System -> Custom Commands" and you will see the DISABLE button I made.
# To re-enable it, you can just reboot by power cycling the device or pressing the button
# in the Custom Commands section of the GUI.


# IMPORTANT:
# If you have downstream conflicts, essentially the WAN router connected
# to this router has the same IP address as this router's LAN (192.168.1.1).
# You will need to change this router's default LAN IP. Conduct an internet
# search or use AI to help you accomplish this prior to proceeding.

# Before you begin, ensure that the router is connected to the internet and you 
# do not have any downstream conflicts as noted above.

#-----NEXT STEP------>

# SCP the file wirehard2026.sh into the /root directory of the router using your computer's
# command line utility. This works on Windows, Mac, or Linux.
#
# 	COMMAND: scp -O /path/to/wirehard2026.sh root@192.168.1.1:/root

#-----NEXT STEP------>

# SCP your wireguard config files into the /root/wg_configs directory using your computer's
# command line utility. This works on Windows, Mac, or Linux
#
# IMPORTANT: Your configs MUST be in a directory called wg_configs AND they must be in standard
#            wireguard format. No extraneous comments, or fancy stuff from the provider.
#
# 	COMMAND: scp -Or /path/to/wg_configs root@192.168.1.1:/root

#-----NEXT STEP------>

# SSH into the router using your computer's command line utility. 
# This works on Windows, Mac, or Linux
#
# 	COMMAND: ssh root@192.168.1.1

#-----NEXT STEP------>

# Modify the script permissions of wirehard2026.sh and your config files to ensure everything can work
# COMMAND: chmod +x wirehard2026.sh
# COMMAND: chmod 755 wg_configs/*

#-----NEXT STEP------>

# Install the necessary packages
# 	COMMAND: opkg update && opkg install coreutils-shuf wireguard-tools luci-proto-wireguard luci-app-wireguard nano luci-app-commands

#-----NEXT STEP------>

# Reboot the router
#	COMMAND: reboot
#	*You can also just turn the router off then back on
#

#-----NEXT STEP------>

# SSH into the router again once it boots back up. 
#
# 	COMMAND: ssh root@192.168.1.1

#-----NEXT STEP------>

# Modify crontab to randomize your connection and desired intervals. Skip this if you don't want this function.
# 	COMMAND: EDITOR=nano crontab -e
# 	TYPE: <YOUR DESIRED INTERVAL IN CRONTAB NOTATION> /root/wirehard2026.sh
# 		E.g.: 3 7 * * MON /root/wirehard2026.sh
# 		Every Monday at 7:03am
# 	COMMAND: CTRL+o
# 	COMMAND: ENTER
# 	COMMAND: CTRL+x

#-----NEXT STEP------>

# Modify the rc.local file so WIREHARD starts automatically on boot. Skip this if you don't want this function.
# 	COMMAND: nano /etc/rc.local
# 	BEFORE "exit 0" on a SEPARATE LINE add the text: ./root/wirehard2026.sh
# 	COMMAND: CTRL+o
# 	COMMAND: ENTER
# 	COMMAND: CTRL+x

#-----NEXT STEP------>

# Reboot and WIREHARD will start automatically
# 	COMMAND: reboot

#
#-----SCRIPT BEGINS NOTHING FOR YOU TO DO HERE UNLESS YOU KNOW WHAT YOU'RE DOING------>
#

# Automatically add ENABLE and DISABLE buttons to GUI
if [ "$(cat /etc/config/luci | grep WIREHARD)" == "" ]
then
	cat << "EOF" >> /etc/config/luci
	config command
		option name 'START WIREHARD and ENABLE KILL SWITCH'
		option command 'reboot'

	config command
		option name 'STOP WIREHARD and DISABLE KILL SWITCH'
		option command '/root/stopWirehard2026.sh'

EOF
	
	cat << "EOF" >> /root/stopWirehard2026.sh
	
	
	uci -q delete network.wirehard_vpn
	uci -q delete network.wgserver
	uci commit network
	service network restart 

	uci del_list firewall.wan.network="wirehard_vpn"
	uci commit firewall
	service firewall restart
	
	exit 0

EOF
	
chmod +x /root/stopWirehard2026.sh

fi


# SLEEP command here to allow any previous iterations of wirehard2026.sh to complete.
sleep 10s

# The code below will extract configuration info from a random wireguard configuration file in the /root/wg_configs directory.
# It is assumed ALL files in this directory are valid wireguard configuration files.

# IMPORTANT: ALL files should be CLEAN and without extraneous comments that are often added by VPN providers.
#            No comments, no ASCII art, nothing outside of the standard wireguard fields!    

# The command below chooses random file in the /root/wg_configs directory

currentConfig="/root/wg_configs/"$(ls /root/wg_configs | shuf | head -1)

# The commands below extract pertinent info from the current configuration file and assigns to corresponding variables.

		WG_IF="wirehard_vpn"
		#server public ip (Endpoint)
		WG_SERV=$(cat $currentConfig | grep Endpoint | awk '{print $3}' | awk 'BEGIN{FS=":"}{print $1}')

		#server port (extracted from Endpoint)
		WG_PORT=$(cat $currentConfig | grep Endpoint | awk '{print $3}' | awk 'BEGIN{FS=":"}{print $2}')
		
		#client private IP (Address)
		WG_ADDR=$(cat $currentConfig | grep Address | awk '{print $3}')
		
		#client private key (PrivateKey)
		WG_KEY=$(cat $currentConfig | grep PrivateKey | awk '{print $3}')
		
		#preshared key (optional)
		WG_PSK=$(cat $currentConfig | grep PresharedKey | awk '{print $3}')
		
		#server public key (Public Key)
		WG_PUB=$(cat $currentConfig | grep PublicKey | awk '{print $3}')


# Creates the necessary firewall rules to run all traffic through the wireguard connection

		uci rename firewall.@zone[0]="lan"
		uci rename firewall.@zone[1]="wan"
		uci rename firewall.@forwarding[0]="lan_wan"
		uci del_list firewall.wan.network="${WG_IF}"
		uci add_list firewall.wan.network="${WG_IF}"
		uci commit firewall
		/etc/init.d/firewall restart

		uci -q delete network.${WG_IF}
		uci set network.${WG_IF}="interface"
		uci set network.${WG_IF}.proto="wireguard"
		uci set network.${WG_IF}.private_key="${WG_KEY}"
		uci add_list network.${WG_IF}.addresses="${WG_ADDR}"
		uci -q delete network.wgserver
		uci set network.wgserver="wireguard_${WG_IF}"
		uci set network.wgserver.public_key="${WG_PUB}"

		uci set network.wgserver.preshared_key="${WG_PSK}"
		

		uci set network.wgserver.endpoint_host="${WG_SERV}"
		uci set network.wgserver.endpoint_port="${WG_PORT}"
		uci set network.wgserver.route_allowed_ips="1"
		uci set network.wgserver.persistent_keepalive="25"
		uci add_list network.wgserver.allowed_ips="0.0.0.0/0"
		uci commit network

		/etc/init.d/network restart
	


# Wait 30 seconds to let wireguard connect
sleep 15s

# Check to see if connection was successful
# If successful it finishes, otherwise it runs again.
# The result is logged.


# Empty log if more than 1000 lines
if [ "$(cat /root/wg.log | wc -l)" -gt 1000 ]; then
        rm /root/wg.log
fi

  
pingStatus=$(ping 8.8.8.8 -c 3 | grep "100% packet loss")
vpnStatus=$(ifconfig | grep wirehard_vpn)

if [ "$pingStatus" == "" ] && [ "$vpnStatus" != "" ]
then
	
  date >> /root/wg.log
  echo $currentConfig >> /root/wg.log
  echo "Status: OK." >> /root/wg.log
  
  exit 0
    
else
  
  date >> /root/wg.log
  echo $currentConfig >> /root/wg.log
  echo "Status: FAILED!" >> /root/wg.log

  /root/wirehard2026.sh &
  exit 0
  
fi

		
exit 0

