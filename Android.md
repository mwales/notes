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

