# Virtualization notes

I quit using VMWare emulators on Linux because:

* Poor performance.  Would often get really laggy when running for a long period
* Network stack goes up and down in the VM constantly
* Every kernel update requires a bunch of shim stuff to get recompiled
* Some kernel updates just break it / have to hunt for correct version that works
* Snapshots aren't like forever save states and aren't in all versions

I've quit using VMWare, my [old notes on using VMWare virtualization](virtualization_vmware.md)


# Linux KVM / QEMU / Virt-manager

Linux actually has a tier-1 hypervisor built into the Linux kernel, and it's
fantastic.  Install virt-manager to help you easily manager it from the desktop.

# Checking CPU support

```
cat /proc/cpuinfo | grep -E '(svm|vmx)'
```

* vmx = Intel virtualization support
* svm = AMD virtualization support

# Install software

```
sudo apt-get install qemu-kvm virt-manager bridge-utils
```

Other tools that sites list (that get automatically included) include: virtinst, libvirt-clients, libvirt-daemon-system

Some guides say to turn on the daemon manually after installing, but it seems like it is started automatically...

# Add the current user to the proper groups

```
sudo adduser $USER kvm
sudo adduser $USER libvirt
```

Need to log out and then back in to get the desktop applications to get the new group permissions

There is a newgrp command you can use to get the shell to support the new group if you can't
log out.

# Converting vmdk to qcow2

```
qemu-img convert -f vmdk -O qcow vmware_image.vmdk qemu_img.qcow2
sudo cp qemu_img.qcow2 /var/lib/libvirt/images
sudo chown libvirt-qemu:kvm /var/lib/libvirt/images/qemu_img.qcow2
```

Don't want to run the conversion as root, cause that is poor practice.  So
convert vmdk to qcow2 somewhere as local user.  Then copy it to the storage
pool that kvm and virt-manager use (and update ownership).

# Virsh disk management

Run virsh to get into the CLI interface for managing VMs.  Or you can type
all of the following on Linux shell preceded by virsh command.

|   command        | desc                           |
|------------------|--------------------------------|
| list --all       | Lists all VMs                  |
| domblklist vm    | Lists storage devices on VM    |

## Attaching raw device

```
attach-disk vm_name /dev/sdX vdX --config
```

sdX is the block device name on host.  vdX is the block device name (vda, vdb,
etc) inside guest. The config option is cause the VM isn't running, and the
change will be made at the next boot.

You can also update XML and attach the disk by device ID (so even if it changes
it's drive number it stays with the correct VM).

```
<disk type="block" device="disk">
  <driver name="qemu" type="raw" cache="directsync" io="native"/>
  <source dev="/dev/disk/by-id/wwn-blahblahblah"/>
  <target dev="vdc" bus="virtio"/>
  <address type="pci" domain="0x0000" bus="0x09" slot="0x00" function="0x0"/>
</disk>
```

## VM-tools equivalent tool for qemu

In your guest VM, install the qemu-guest-agent tools.  According to proxmox
wiki, the guest agent does the following

* Allows the host OS to properly shutdown the guest
* Freeze the guest filesystem while a snapshot is being taken
* Helps guest sync time after a snapshot is restored

# VMWare Notes

My notes for getting the most out of VMWare. This sometimes works, but it's
still inferior to KVM virtualization.

## Slowdowns

Around version 16 or 17 I've found that the VMs (mine are typically Ubuntu
based) are very slow after the computer has been on a few days (and typically
emulated other systems for a few hours).  CPU utilization goes really high, but
nothing seems obviously wrong / overwhelming the CPU.  Problem goes away as soon
as your reboot the host.

Someone suggested the following, and I think it might have helped a little bit,
but not completely.

Disabling the use of swap for VM RAM memory.  It's a setting available in the
VMWare Workstation GUI, but it's not available in the GUI for the VMPlayer.

You can manually force the config by adding the following to /etc/vmware/config:

```
prefvmx.minVmMemPct = "100"
```

## Freezing / Rejecting mouse and keyboard inputs

After about 5 minutes a VM will sorta freeze / and reject all mouse and keyboard
inputs.  If it's plyaing a video, it will typically continue playing the video
until it ends. This started happening after migrating to VMPlayer 17.5.0.

Reddit user jjvanier suggested this fix in the vmware subreddit, and I think it
may have fixed the issue for me completely.

Edit your .vmx file for the individual guest and add the following to the end of
the .vmx file

```
keyboard.allowBothIRQs = "FALSE"
keyboard.vusb.enable = "TRUE"
```

