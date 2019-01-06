# SondenUtils/Sondescan.sh based on ScannerList
Configurable script for more flexible ScannerList setup (tested on Ubuntu 16.04LTS).

ScannerList supports the dxlAPRS Toolchain written by OE5DXL for finding any active frequency. You will not know where to listen by fixed frequency list anymore.

It uses the csv output from already installed RTL_POWER and creates a sdrcfg_rtl#.txt file with current used frequencies for dxlSondemonitoring Software. Look for the documentation in the depending projects.

All credits to Wolfgang Hallmann, DF7PN for his excellent scannerprogramm:
https://github.com/whallmann/SondenUtils

Using this script for a long time with several different setups, I made it fully configurable in the same way the config file from ws-starter used by https://wetterson.de is being organized.
In most usecases both tools will be used together to generate the channel list for ws-starter by the ws-scanner.

<b><u>Supporting up to 4x SDR, several different setups can be easily configured:</u></b>:
```
+----------+----------+----------+
! Fixed CH ! Variable ! ScanSDR  !
+----------+----------+----------+
!  RTL1-4  !  none    !  none    !
!----------+----------+----------+
!  none    !  RTL0-2  !  RTL3    !
+----------+----------+----------+
!  RTL0    !  RTL1    !  RTL3    !
+----------+----------+----------+
```

or any other valid configuration for up to 4 SDR-Receiver.

Sample config with 4 SDR:
=========================
```
Sample configuration with 4x SDR, 1x assigned to a fix CH table, 2x with scanned CH, 1x used only for scanning task

declare -A rtl0=( [device]=0 [ppm]=0 [gain]=38.6 [scan_start]=401M [scan_stop]=403M [scan_step]=1000 )
declare -A rtl1=( [device]=1 [ppm]=0 [gain]=38.6 [scan_start]=403M [scan_stop]=405M [scan_step]=1000 )

Number of active RX RTL-SDR must be added to array:
 - caution: in this config rtl0 is assigned to a fixed channel configuration!!!
receive_sdr=( rtl1 rtl2 )

Assign RTL-SDR for scanner task
declare -A rtl3=( [device]=3 [ppm]=0 [gain]=38.6 [afc]=10 [auto_snlevel]=5 [band_width]=15000 [hold_timer]=15 )
scanner_sdr=( rtl3 )
```

Parameters:
===========
* declare -A name  - add a RTLSDR receiver to the config array, assigned name is being used in receive_/scanner_sdr param
 - device - physical device number on the USB bus (use rtl_test to check your present devices)
 - ppm - frequency correction value
 - gain - supported RX gain value (different gains ar e used by RTL820 / E4000!)
 - scan_start = full MHz scan start frequency
 - scan_stop = full MHz scan stop frequency (take care of the maximum support bandwidth of your SDR)
 - band_width = demodulation bandwidth
 - scan_step = scanning steps in Hz

* receive_sdr ( n1, n2) - defines the RTL-RX used to be assigned by the scan results CH tables 

* scanner_sdr ( n1 ) - define the RTL-RX used for scanprocess exclusively

The paramters inside the ws-scanner.config are self-explaining, support is not available. Use the script if you find it may be helpful for your SDR-RX gateway setup.


