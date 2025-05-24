# Notes on Android stuff

# Adb permissions crap

Often if the adb application doesn't ahve setuid bit set, you can have permission problems like the following:

```
mwales@Halo:~/Android/Sdk/platform-tools$ ./adb devices
List of devices attached
adb server version (32) doesn't match this client (39); killing...
* daemon started successfully
XXXXXXXXXXXXXXXX        no permissions (user in plugdev group; are your udev rules wrong?); see [http://developer.android.com/tools/device.html]

```

Fix:

```bash
sudo chown root:root adb
sudo chmod +s ./adb
./adb kill-server
```

## udev and Android Debug Bridge notes

A blog entry with some good notes about this:

https://androidonlinux.wordpress.com/2013/05/12/setting-up-adb-on-linux/

### udev rule format:

```
#ZTE (Ubuntu community rule format)
SUBSYSTEM==usb, SYSFS{idVendor}==19d2, MODE=0664, GROUP=plugdev
#DJI (Andorid dev documentation rule format)
SUBSYSTEM==usb, ATTR{idVendor}==2ca3, ATTR{idProduct}==001f, MODE=0666, GROUP=plugdev
```

### Restarting udev

I'm wondering now if this stuff still works with systemd

```
sudo service udev restart
sudo udevadm contorl --reload-rules
```

### ADB commands

Sometimes I have different success with the Ubuntu pre-packaged adb versus the Android tools binary

```
./adb kill-server
./adb start-server
./adb devices
```