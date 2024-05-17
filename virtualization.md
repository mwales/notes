# Virtualization notes

## Trying out QEMU-KVM

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

## VM-tools equivalent tool for qemu

In your guest VM, install the qemu-guest-agent tools.  According to proxmox
wiki, the guest agent does the following

* Allows the host OS to properly shutdown the guest
* Freeze the guest filesystem while a snapshot is being taken
* Helps guest sync time after a snapshot is restored
