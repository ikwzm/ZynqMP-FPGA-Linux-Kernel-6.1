patches/microchip-wilc-driver
------------------------------------------------------------------------------------

This directory provides the Linux Kernel Driver for the WiFi module in the Ultra96-V2.

### WiFi Module Details

 * Manufacturer Part Number: ATWILC3000-MR110CA
 * Manufacturer            : MICROCHIP
 * URL                     : https://www.microchip.com/en-us/product/atwilc3000
 
### Linux Kernel Driver

#### Original Version provided by microchip

The Linux Kernel Driver published by Microchip on github can be found at the following URL.

 * https://github.com/linux4microchip/linux

The branch for Linux Kernel 6.1 is ```linux-6.1-mchp```.

**The Linux Kernel Driver provided here did not work with Ultra96-V2. Please use the Linux Kernel Driver provided by Tosainu to run on Ultra96-V2.**

#### Tosainu Version 

Tosainu has modified microchip's Linux Kernel to work with Ultra96-V2 on github.

 * https://github.com/Tosainu/linux-at91

The branch for linux kernel 6.1 is ```wilc3000-ultra96-6.1```.

```Kconfig```, ```Makefile```, and ```wilc1000/``` in this directory were obtained as follows

```console
shell$ git clone --depth 1 --branch wilc3000-ultra96-6.1 https://github.com/Tosainu/linux-at91 linux-at91-tosainu
shell$ cp -r linux-at91-tosainu/drivers/net/wireless/microchip/* .
```

If you want to modify the original version made by microchip, we have prepared a patch file which you can use as follows

```console
shell$ git clone --depth 1 --branch linux-6.1-mchp https://github.com/linux4microchip/linux linux-6.1-mchp
shell$ cd linux-6.1-mchp
shell$ git checkout linux-6.1-mchp
shell$ git checkout -b wilc3000-ultra96-6.1
Switched to a new branch 'wilc3000-ultra96-6.1'
shell$ patch -p1 < ../0001-ultra96-modifications-16.1.patch
patching file drivers/net/wireless/microchip/wilc1000/Makefile
patching file drivers/net/wireless/microchip/wilc1000/debugfs.h
patching file drivers/net/wireless/microchip/wilc1000/netdev.c
patching file drivers/net/wireless/microchip/wilc1000/power.c
patching file drivers/net/wireless/microchip/wilc1000/sdio.c
patching file drivers/net/wireless/microchip/wilc1000/wlan.c
patching file drivers/net/wireless/microchip/wilc1000/wlan.h
shell$ git add --all
shell$ git commit -m "[patch] for ultra96v2"
[wilc3000-ultra96-6.1 f59ebf35c] [patch] for ultra96v2
 7 files changed, 85 insertions(+), 64 deletions(-)
shell$ cd ..
shell$ cp -r linux-6.1-mchp/drivers/net/wireless/microchip/* .
```

### Thanks

Thanks to Tosainu and microchip.


