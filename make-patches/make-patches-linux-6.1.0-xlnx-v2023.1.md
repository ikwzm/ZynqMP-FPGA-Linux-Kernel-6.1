Make ./paches/linux-6.1.0-xlnx-v2023.1/
------------------------------------------------------------------------------------

### Get linux-6.1.0

```console
shell$ git clone --depth 1 -b v6.1 git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.1.0
```

### Get linux-xlnx-2023.1

```console
shell$ git clone --depth 1 -b xilinx-v2023.1 https://github.com/Xilinx/linux-xlnx.git linux-xlnx-2023.1
```

### Make diff-linux-6.1.0-xlnx-v2023.1.txt

```console
shell$ ruby ./make-patches/source-tree-diff-list.rb -t linux-6.1.0-xlnx-v2023.1 -A linux-6.1.0 -B linux-xlnx-2023.1 -o ./make-patches/diff-linux-6.1.0-xlnx-v2023.1.txt linux-6.1.0 linux-xlnx-2023.1 -v
## source-tree-diff-list.rb 0.1.0
## NAME: linux-6.1.0-xlnx-v2023.1
## A   : {name: linux-6.1.0, path: linux-6.1.0}
## B   : {name: linux-xlnx-2023.1, path: linux-xlnx-2023.1}
## OUT : ./make-patches/diff-linux-6.1.0-xlnx-v2023.1.txt
```

### Make make-patches-linux-6.1.0-xlnx-v2023.1.sh

```console
shell$ ruby ./make-patches/make-patch-shell.rb -d ./make-patches/diff-linux-6.1.0-xlnx-v2023.1.txt -g make-patches/patch-group-linux-6.1.0-xlnx-v2023.1.yml -s ./make-patches/make-patches-linux-6.1.0-xlnx-v2023.1.sh
```

### Run make-patches-linux-6.1.0-xlnx-v2023.1.sh

```console
shell$ sh ./make-patches/make-patches-linux-6.1.0-xlnx-v2023.1.sh
shell$ ls -1 ./patches/linux-6.1.0-xlnx-v2023.1/
010_arch-arm-mach-zynq.patch
011_arch-arm-configs.patch
012_arch-arm-boot-dts.patch
020_arch-arm64.patch
021_arch-arm64-configs.patch
022_arch-arm64-boot-dts.patch
030_arch-microblaze.patch
040_arch-powerpc.patch
100_kernel-irq.patch
101_net-ipv4.patch
200_drivers-bluetooth.patch
201_drivers-cdx.patch
202_drivers-clk.patch
203_drivers-clocksource.patch
204_drivers-crypto.patch
205_drivers-dma.patch
206_drivers-edac.patch
207_drivers-firmware.patch
208_drivers-fpga.patch
209_drivers-gpio.patch
210_drivers-gpu-drm.patch
211_drivers-hwmon.patch
212_drivers-i2c.patch
213_drivers-i3c.patch
214_drivers-iio.patch
215_drivers-iommu.patch
216_drivers-irqchip.patch
217_drivers-mailbox.patch
218_drivers-media-common.patch
219_drivers-media-i2c.patch
220_drivers-media-mc.patch
221_drivers-media-platform.patch
222_drivers-media-test-drivers.patch
223_drivers-media-usb.patch
224_drivers-media-v4l2.patch
225_drivers-mfd.patch
226_drivers-misc.patch
227_drivers-mmc.patch
228_drivers-mtd.patch
229_drivers-net-ethernet.patch
230_drivers-net-phy.patch
231_drivers-net-wan.patch
232_drivers-net-wireless.patch
233_drivers-nvmem.patch
234_drivers-of.patch
235_drivers-pci.patch
236_drivers-phy.patch
237_drivers-pinctrl.patch
238_drivers-platform.patch
239_drivers-ptp.patch
240_drivers-pwm.patch
241_drivers-remoteproc.patch
242_drivers-reset.patch
243_drivers-soc-xilinx.patch
244_drivers-spi.patch
245_drivers-staging.patch
246_drivers-tty.patch
247_drivers-uio.patch
248_drivers-usb-chipidea.patch
249_drivers-usb-dwc3.patch
250_drivers-usb-gadget.patch
251_drivers-usb-host.patch
252_drivers-usb-misc.patch
253_drivers-usb-phy.patch
254_drivers-usb-storage.patch
255_drivers-vfio-cdx.patch
256_drivers-virtio.patch
257_drivers-watchdog.patch
258_drivers-xen.patch
300_sound-pci.patch
301_sound-soc-xilinx.patch
999_other-document.patch
xxx_patch.sh
```

