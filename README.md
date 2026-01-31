# Instarch

## Warning

Please note I have only tested this on virtual machines and not actual hardware. Be careful.

---

Instarch is a tool that automates pretty much all of the Arch Linux installation process.
I made this because in my opinion Archinstall is bloated. All you need to do after running Instarch is:

* Reboot
* Install some needed packages (e.g doas, git, nvim, etc)
* Install a DM or WM
* Done!

## How to Use

Instarch is slightly harder than Archinstall to use as you have to get your hands dirty and
play with some of the code and adjust it to match your partitions and stuff.

The most important thing: **GO THROUGH THE WHOLE SOURCE!!** Otherwise you will most likely
have unconfigured things that need to be configured, which will result in your setup not working and
potentially erasing data off some disks. 

## Configuring

There isn't much to be configured other than the stuff covered earlier to make the installer work.
The only real thing I can think about is changing the kernel flavour to Zen, LTS or Hardened. The kernel flavour
is the boring, regular kernel by default.

## Licensing

See [LICENSE](LICENSE.md)
