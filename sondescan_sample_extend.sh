#!/bin/bash
#===================================================================================
#
# dxlSonde Client Toolchain - Automated scan script
# -------------------------------------------------
# Credits: Wolfgang Hallmann
# https://github.com/whallmann/SondenUtils/tree/master/ScannerList
# 
# Adapted by: Meinhard Guenther, DL2MF - 2017, 2018
#
#===================================================================================

# system path settings
RTLDIR=/usr/local/bin/
# progdir is the path to ws-starter / dxlclient.sh / RTLSDR script  - no trailing "/"!!!
PROGDIR=${HOME}/ws-starter
WORKDIR="$( cd "$(dirname "$0")" ; pwd -P )"
# tempdir is the path to temporary logfile folder  - no trailing "/"!!!
TEMPDIR=/tmp

# device number on bus used for scanner, use rtl_test to check
#Found 3 device(s):
#  0:  RTL-SDR, RTL2838UHIDIR, SN: RTL00002
#  1:  RTL-SDR, RTL2838UHIDIR, SN: RTL00003
#  2:  RTL-SDR, RTL2838UHIDIR, SN: RTL00001
#
SCAN_DEVNUM=2

# set blacklist for ALL ranges - only one blacklist!
EXCLUDE0=${WORKDIR}/blacklist_0.txt
EXCLUDE1=${WORKDIR}/blacklist_1.txt
EXCLUDE2=${WORKDIR}/blacklist_2.txt

# set freq include files for each scanning range
INCLUDE0=${WORKDIR}/whitelist_0.txt
INCLUDE1=${WORKDIR}/whitelist_1.txt
INCLUDE2=${WORKDIR}/whitelist_2.txt

# temporary files for frequency handling
TMP_HOLD0=${TEMPDIR}/chan_hold_0.txt
TMP_HOLD1=${TEMPDIR}/chan_hold_1.txt
TMP_HOLD2=${TEMPDIR}/chan_hold_2.txt
TMP_CSV0=${TEMPDIR}/scan_0.csv
TMP_CSV1=${TEMPDIR}/scan_1.csv
TMP_CSV2=${TEMPDIR}/scan_2.csv
TMP_CHAN0=${TEMPDIR}/chan_0.txt
TMP_CHAN1=${TEMPDIR}/chan_1.txt
TMP_CHAN2=${TEMPDIR}/chan_2.txt
CHANNEL0=${PROGDIR}/sdrcfg-rtl0.txt
CHANNEL1=${PROGDIR}/sdrcfg-rtl1.txt
CHANNEL2=${PROGDIR}/sdrcfg-rtl2.txt

LOGFILE=/tmp/DL2623_scanner.log

echo "================================================================================" > ${LOGFILE}
echo " DL2623_scan.sh - Logfile" >> ${LOGFILE}
echo "================================================================================" >> ${LOGFILE}
echo " " >> ${LOGFILE}
echo " `date +%Y-%m-%d''_''%H:%M:%S` " >> ${LOGFILE}
echo " " >> ${LOGFILE}
echo "-------------------------------------------" >> ${LOGFILE}

echo "Files and directories: " >> ${LOGFILE}
echo "RTL path: " >> ${LOGFILE}
echo ${RTLDIR} >> ${LOGFILE}
echo "-" >> ${LOGFILE}
echo "Exclude: " >> ${LOGFILE}
echo ${EXCLUDE0} >> ${LOGFILE}
echo ${EXCLUDE1} >> ${LOGFILE}
echo ${EXCLUDE2} >> ${LOGFILE}
echo "-" >> ${LOGFILE}
echo "Include: " >> ${LOGFILE}
echo ${INCLUDE0} >> ${LOGFILE}
echo ${INCLUDE1} >> ${LOGFILE}
echo ${INCLUDE2} >> ${LOGFILE}
echo "-" >> ${LOGFILE}
echo "Temp: " >> ${LOGFILE}
echo ${TMP_HOLD0} >> ${LOGFILE}
echo ${TMP_HOLD1} >> ${LOGFILE}
echo ${TMP_HOLD2} >> ${LOGFILE}
echo ${TMP_CSV0} >> ${LOGFILE}
echo ${TMP_CSV1} >> ${LOGFILE}
echo ${TMP_CSV2} >> ${LOGFILE}
echo "-" >> ${LOGFILE}
echo "Channels: " >> ${LOGFILE}
echo ${TMP_CHAN0} >> ${LOGFILE}
echo ${TMP_CHAN1} >> ${LOGFILE}
echo ${TMP_CHAN2} >> ${LOGFILE}
echo ${CHANNEL0} >> ${LOGFILE}
echo ${CHANNEL1} >> ${LOGFILE}
echo ${CHANNEL2} >> ${LOGFILE}
echo "-------------------------------------------" >> ${LOGFILE}
echo "-" >> ${LOGFILE}


echo "---[Scan 1]---------------------------------------------------------------------" >> ${LOGFILE}
echo " `date +%Y-%m-%d''_''%H:%M:%S` " >> ${LOGFILE}
echo "Calling rtl_power ..." >> ${LOGFILE}
${RTLDIR}rtl_power -f 404M:406M:1000 -d ${SCAN_DEVNUM} -g 38.6 -p 0 ${TMP_CSV0} -1 2>> ${LOGFILE}
cd ${WORKDIR}
./scannerlist -a 10 -b 8000 -h 15 -n 5 -H ${TMP_HOLD0} -o ${TMP_CHAN0} -f ${TMP_CSV0} -d ${EXCLUDE0} -w ${INCLUDE0} -v >> ${LOGFILE}
cp ${TMP_CHAN0} ${CHANNEL0} >> ${LOGFILE}
echo ---SCAN_LIST SDR -d0 complete ----------------  >> ${LOGFILE}
sleep 5
echo "... Reset USB Scan Device " ${SCAN_DEVNUM} >> ${LOGFILE}
echo ---Reset USB Scan Device ${SCAN_DEVNUM} ---
/usr/sbin/usb_modeswitch -b 4 -g ${SCAN_DEVNUM} -R -v 0bda -p 2838 >> ${LOGFILE}
echo "--------------------------------------------------------------------------------" >> ${LOGFILE}
echo "-" >> ${LOGFILE}

echo "---[Scan 2]---------------------------------------------------------------------" >> ${LOGFILE}
echo " `date +%Y-%m-%d''_''%H:%M:%S` " >> ${LOGFILE}
echo "Calling rtl_power ..." >> ${LOGFILE}
${RTLDIR}rtl_power -f 402M:404M:1000 -d ${SCAN_DEVNUM} -g 38.6 -p 0 ${TMP_CSV1} -1 2>> ${LOGFILE}
cd ${WORKDIR}
./scannerlist -a 10 -b 8000 -h 15 -n 5 -H ${TMP_HOLD1} -o ${TMP_CHAN1} -f ${TMP_CSV1} -d ${EXCLUDE1} -w ${INCLUDE1} -v >> ${LOGFILE}
cp ${TMP_CHAN1} ${CHANNEL1} >> ${LOGFILE}
echo ---SCAN_LIST SDR -d1 complete ----------------  >> ${LOGFILE}
sleep 5
echo "... Reset USB Scan Device " ${SCAN_DEVNUM} >> ${LOGFILE}
echo ---Reset USB Scan Device ${SCAN_DEVNUM} ---
/usr/sbin/usb_modeswitch -b 4 -g ${SCAN_DEVNUM} -R -v 0bda -p 2838 >> ${LOGFILE}
echo "--------------------------------------------------------------------------------" >> ${LOGFILE}
echo "-" >> ${LOGFILE}
echo " `date +%Y-%m-%d''_''%H:%M:%S` " >> ${LOGFILE}

#echo "---[Scan 3]---------------------------------------------------------------------" >> ${LOGFILE}
#echo "Calling rtl_power ..." >> ${LOGFILE}
# old: ${RTLDIR}rtl_power -f 401M:402M:1000 -d ${SCAN_DEVNUM} -g 38.6 -p 0 ${TMP_CSV2} -1 2>&1
#${RTLDIR}rtl_power -f 401M:402M:1000 -d ${SCAN_DEVNUM} -g 38.6 -p 0 ${TMP_CSV2} -1 2>> ${LOGFILE}
#cd ${WORKDIR}
#./scannerlist -a 10 -b 8000 -h 15 -n 5 -H ${TMP_HOLD2} -o ${TMP_CHAN2} -f ${TMP_CSV2} -d ${EXCLUDE2} -w ${INCLUDE2} -v >> ${LOGFILE}
#cp ${TMP_CHAN2} ${CHANNEL2} >> ${LOGFILE}
#echo ---SCAN_LIST SDR -d2 complete ----------------  >> ${LOGFILE}
#sleep 5
#echo "... Reset USB Scan Device d3 " >> ${LOGFILE}
#echo ---Reset USB Scan Device d3 ---
#/usr/sbin/usb_modeswitch -b 4 -g ${SCAN_DEVNUM} -R -v 0bda -p 2838 >> ${LOGFILE}

echo "--------------------------------------------------------------------------------" >> ${LOGFILE}
echo ---Scan completed---
echo " `date +%Y-%m-%d''_''%H:%M:%S` ---Scan complete---"     >> ${LOGFILE}
echo "================================================================================" >> ${LOGFILE}

