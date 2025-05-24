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