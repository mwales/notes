# Digilent Analog Discovery

Install the following packages, on really fresh Ubuntu probably won't start due
to Qt dependencies, but on the next usage of apt you will get prompted to fix
all the missing packages (and will then install Qt)

```
sudo dpkg -i digilent.adept.utilities_2.6.1-amd64.deb digilent.adept.runtime_2.30.1_amd64.deb digilent.waveforms_3.25.1_amd64.deb
```

# DSLogic Plus Logic Analyzer

Install the following packages:

```
sudo apt install sigrok-firmware-fx2lafw sigrok pulseview libsigrokdecode4 libsigrok4t64
```

I needed to make the following udev rule in /etc/udev/rules.d/60-libsigrok.rules

```
# DreamSourceLab DSLogic
ATTRS{idVendor}=="2a0e", ATTRS{idProduct}=="0001", MODE="0666", GROUP="plugdev"
ATTRS{idVendor}=="2a0e", ATTRS{idProduct}=="0003", MODE="0666", GROUP="plugdev"
ATTRS{idVendor}=="2a0e", ATTRS{idProduct}=="0020", MODE="0666", GROUP="plugdev"
```

Reread the udev rules

```
udo udevadm control --reload-rules
sudo udevadm trigger
```

The following should return the device without error now:

```
sigrok-cli --driver=dreamsourcelab-dslogic:conn=2a0e.0020 --scan
```

In PulseView:

1. Click on device (defaults to demo device)
2. Select dreasourcelab-dslogic entry
3. Select USB
4. Scan
5. Select the device

I don't think was required anymore, but I did install it

* sigrok-firmware-fx2lafw
