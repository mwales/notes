# Quick list of the commands I used to connect Raspberry Pi to Wi-Fi

Some nice fellow made a CLI program to interface to WPA supplicant.

    wpa_cli

The scanning for a network was very straightforward:

    scan
    scan_results

Configuing the network and setting up the password was a bit weird. There are 
several methods to enter a password/passphrase/key, I tried many of them before 
finally trying enable_network, which is what got the connection going in the
end.

    add_network

This returns a network enumeration/ID that use for all the following commands.

   set_network 0 ssid "WifiSSID"
   
   # I have no idea which is the correct one of the following:
   set_network 0 psk "password"
   set_passphrase 0 "password"

   enable_network 0

   save_config

   status

