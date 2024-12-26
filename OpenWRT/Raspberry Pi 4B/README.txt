# welcometo1984.com

Thank you to everyone at RaspberryPi.org and OpenWRT.org. Amazing fun
projects that help people learn valuable skills!

You need to make sure the following packages are installed:

luci luci-app-commands nano openvpn-openssl luci-app-openvpn kmod-usb-net-rtl8152 kmod-usb-net-asix-ax88179

You can do that via the Image Builders or via the Custom Image 
Request in the firmware selector on OpenWRT.org

The UCI defaults file can be used when using the OpenWRT firmware builder. 
Otherwise you can just manually modify your files to match the content in these. 
Basically, SSH into the router and modify the /etc/config/<service name> file
to match the contents of the section in 99_custom_uci_defaults file.

The scripts need to be placed in the root directory and you must also 
modify the LUCI Commands config file as shown in the 99_custom_uci_defaults file. 
LUCI Commands will look for the scripts in the root directory.

Have fun!
