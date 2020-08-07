#!/bin/bash

VBoxManage createvm --name Thinox1 --ostype Ubuntu_64 -register

VBoxManage modifyvm Thinox1 --memory 1024 --nic2 hostonly --nictype2 82540EM --hostonlyadapter2 "VirtualBox Host-Only Ethernet Adapter" --nicpromisc2 allow-vms --graphicscontroller vmsvga --vram 16

#VBoxManage internalcommands createrawvmdk -filename thinox1.vmdk -rawdisk C:\Users\lkrei\VirtualBox VMs\Thinox1\thinox.raw

VBoxManage createmedium  disk --filename "c:/Users/lkrei/VirtualBox VMs/Thinox1/thinox.vdi" --size 40960

#Before adding a virtual hard disk to a machine we need to add a virtual hard disk controller:
#VBoxManage storagectl Thinox1 --name "IDE Controller" --add ide --controller PIIX4 --portcount 2 --bootable on

#Before adding a virtual hard disk to a machine we need to add a virtual hard disk controller:
VBoxManage storagectl Thinox1 --name "SATA" --add sata --controller PIIX4 --portcount 2 --bootable on

#Now we can attach the vmdk hard disk to the virtual machine:
VBoxManage storageattach Thinox1 --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium  "c:/Users/lkrei/VirtualBox VMs/Thinox1/thinox.vdi"

VBoxManage storageattach Thinox1 --storagectl "SATA" --port 1 --device 0 --type dvddrive --medium "c:/Users/lkrei/Downloads/ubuntu-18.04.3-live-server-amd64.iso"


VBoxManage startvm Thinox1 --type headless

VBoxManage metrics query Thinox1 CPU/Load/User,CPU/Load/Kernel
