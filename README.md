# SondenUtils
Programme zur Auswertung von Wettersonden nach dxlChain based on whallmann/SondenUtils

Credits to Wolfgang Hallmann, DF7PN for his excellent scannerprogramm:
https://github.com/whallmann/SondenUtils

Using this script for a long time with several different setups, I made it fully configurable in the same way the config file from ws-starter is being organized.
In most usecases both will be used together to generate the channel list for ws-starter by the ws-scanner.

Supporting up to 4x SDR, several different setups can be easily configured:

+----------+----------+----------+

! Fixed CH ! Variable ! ScanSDR  ! 

+----------+----------+----------+

!  RTL1-4  !  none    !  none    !

+----------+----------+----------+

!  none    !  RTL0-2  !  RTL3    !

+----------+----------+----------+

!  RTL0    !  RTL1    !  RTL3    !

+----------+----------+----------+

or any other valid configuration for up to 4 SDR-Receiver. 

#Sample configuration with 4x SDR, 1x assigned to a fix CH table, 2x with scanned CH, 1x used only for scanning task:

declare -A rtl0=( [device]=0 [ppm]=0 [gain]=38.6 [scan_start]=90M [scan_stop]=92M [scan_step]=1000 )
declare -A rtl1=( [device]=1 [ppm]=0 [gain]=38.6 [scan_start]=92M [scan_stop]=94M [scan_step]=1000 )

*Number of active RX RTL-SDR must be added to array:
 -- caution: in this config rtl0 is assigned to a fixed channel configuration!!!
receive_sdr=( rtl1 rtl2 )

* Assign RTL-SDR for scanner task:
declare -A rtl3=( [device]=3 [ppm]=0 [gain]=38.6 [afc]=10 [auto_snlevel]=5 [band_width]=15000 [hold_timer]=15 )
scanner_sdr=( rtl3 )
