# welcometo1984.com

The UCI defaults file can be used when using the OpenWRT firmware builder. 
Otherwise you can just manually modify your files to match the content in these. 
Basically, SSH into the router and modify the /etc/config/<service name> file
to match the contents of the section in 99_custom_uci_defaults file.

The scripts need to be placed in the root directory and you must also 
modify the LUCI Commands config file as shown in the 99_custom_uci_defaults file. 
LUCI Commands will look for the scripts in the root directory.

Have fun!
