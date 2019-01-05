#!/bin/bash
#===================================================================================
# SondeScan.sh - dxlSonde Client Toolchain - Automated Scannerscript
#===================================================================================
# Credits: Wolfgang Hallmann
# https://github.com/whallmann/SondenUtils/tree/master/ScannerList
# 
# Adapted by: Meinhard Guenther, DL2MF - 2017, 2018
# -------------------------------------------------
# Changelog:
# 2017-06-07 - DL2MF - first implementation with config variables
# 2017-09-01 - DL2MF - make all filenames and pathnames variables
# 2018-06-10 - DL2MF - better naming conventions for files and variables
# 2018-11-17 - DL2MF - Mods for usage of 4x RTL_SDR
# 2018-12-30 - DL2MF - make better configuration of script and number of SDR
#
#===================================================================================

# system path settings
RTLDIR=/usr/local/bin/
PROGDIR=${HOME}/ws-starter
WORKDIR="$( cd "$(dirname "$0")" ; pwd -P )"
# tempdir is the path to temporary logfile folder  - no trailing "/"!!!
TEMPDIR=/tmp
source ${WORKDIR}/ws-scanner.conf

# Example output from rtl_test to check your assigned USB RTL-SDR:
#
# Found 3 device(s):
#  0:  RTL-SDR, RTL2838UHIDIR, SN: RTL00002  <--- will be used for 405-406MHz
#  1:  RTL-SDR, RTL2838UHIDIR, SN: RTL00003  <--- will be used for 403-405MHz 
#  2:  RTL-SDR, RTL2838UHIDIR, SN: RTL00001  <--- will be used for 401-403MHz
#  3:  RTL-SDR, RTL2838UHIDIR, SN: RTL00004  <--- scanner device configure in conf!

echo "Files and directories: "
echo "Workdir : " ${WORKDIR}
echo "Config  : " ${WORKDIR}/ws-scanner.conf
echo ""
echo "RTL path: " ${RTLDIR}

function start_scanner {

  	LOGFILE=/tmp/sondescan-${i}.log
	tnow=`date "+%x_%X"`
	echo $tnow

	echo "================================================================================" > ${LOGFILE}
	echo " sondescan.sh - Logfile" >> ${LOGFILE}
	echo "================================================================================" >> ${LOGFILE}
	echo " `date +%Y-%m-%d''_''%H:%M:%S` ---Scan started----" >> ${LOGFILE}
	echo "--------------------------------------------------------------------------------" >> ${LOGFILE}
	echo "---[Scan $i] - ${rx_start}Hz-${rx_stop}Hz -----------------------------------------------" >> ${LOGFILE}
	echo " `date +%Y-%m-%d''_''%H:%M:%S` " >> ${LOGFILE}

	# set blacklist for ALL ranges - only one blacklist!
	EXCLUDE=${WORKDIR}/${i}-blacklist.txt
	# set freq include files for each scanning range
	INCLUDE=${WORKDIR}/${i}-whitelist.txt

	# temporary files for frequency handling
	TMP_HOLD=${TEMPDIR}/${i}-tmphold.txt
	TMP_CSV=${TEMPDIR}/${i}-scandata.csv
	TMP_CHAN=${TEMPDIR}/${i}-channel.tmp

	# final channel files for decoding
	CHANNEL=${PROGDIR}/sdrcfg-${i}.txt

	echo "Logfile: " ${LOGFILE}
	echo "Exclude: " ${EXCLUDE}
	echo "Include: " ${INCLUDE}
	echo "Temp:    " ${TMP_HOLD} ${TMP_CSV}

	echo "Calling rtl_power ..." >> ${LOGFILE}
	${RTLDIR}rtl_power -f ${rx_start}:${rx_stop}:${rx_step} -d ${scan_device} -g ${rx_gain} -p ${rx_ppm} ${TMP_CSV} -1 2>> ${LOGFILE}
	cd ${WORKDIR}

	./scannerlist -a ${afc} -b ${band_width} -h ${hold_timer} -n ${auto_snlevel} -H ${TMP_HOLD} -o ${TMP_CHAN} -f ${TMP_CSV} -d ${EXCLUDE} -w ${INCLUDE} -v >> ${LOGFILE}
	cp ${TMP_CHAN} ${CHANNEL} >> ${LOGFILE}

	sleep 5

	echo "... Reset USB Scan Device " ${scan_device} >> ${LOGFILE}
	echo ---Reset USB Scan Device ${scan_device} ---
	/usr/sbin/usb_modeswitch -b 4 -g ${scan_device} -R -v 0bda -p 2838 >> ${LOGFILE}
	echo "--------------------------------------------------------------------------------" >> ${LOGFILE}
	echo "-" >> ${LOGFILE}
	echo "--------------------------------------------------------------------------------" >> ${LOGFILE}
	echo ---Scan $i completed---
	echo " `date +%Y-%m-%d''_''%H:%M:%S` ---Scan complete---"     >> ${LOGFILE}
	echo "================================================================================" >> ${LOGFILE}
}

for i in ${scanner_sdr[@]}; do
  ## get scan config
  echo "--------------------------------------------------------------------------------" >> ${LOGFILE}
  echo "Get Scanner config:"
  eval scan_device="\${$i[device]}" 
  eval scan_ppm="\${$i[ppm]}" 
  eval scan_gain="\${$i[gain]}" 
  eval acf="\${$i[afc]}"
  eval auto_snlevel="\${$i[auto_snlevel]}" 
  eval band_width="\${$i[band_width]}" 
  eval hold_timer="\${$i[hold_timer]}"

  echo "scan_device= " ${scan_device}
  echo "scan_gain  = " ${scan_gain}
  echo "hold_timer = " ${hold_timer}
done


for i in ${receive_sdr[@]}; do
  ## get sdr config
  echo "Get SDR config:"
  eval rx_device="\${$i[device]}" 
  eval rx_ppm="\${$i[ppm]}" 
  eval rx_gain="\${$i[gain]}" 
  eval rx_start="\${$i[scan_start]}" 
  eval rx_stop="\${$i[scan_stop]}"
  eval rx_step="\${$i[scan_step]}"

  echo "rx_device= " ${rx_device}
  echo "rx_start = " ${rx_start}
  echo "rx_stop  = " ${rx_stop}  

  echo "Start scanner task ..."
  start_scanner
done

