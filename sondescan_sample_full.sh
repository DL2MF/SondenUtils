echo ==============================================  >> /tmp/scannerlist.log
echo ---Start SCAN script -------------------------  >> /tmp/scannerlist.log
echo ==============================================  >> /tmp/scannerlist.log
rtl_power -f 401M:403M:1000 -d2 -g 38 -p 28 /tmp/scan401403.csv -1 2>&1 > /dev/null
cd /home/mg/ws-scanner/
sudo ./scannerlist -L -30 -H /tmp/holding401403.txt -o /tmp/outlist401403.txt -f /tmp/scan401403.csv -v -d /home/mg/ws-scanner/scannerblacklist.txt -w /home/mg/ws-scanner/scannerwhitelist401403.txt  > /tmp/scannerlist.log
echo TODO: scp /tmp/outlist401403.txt pi@10.10.62.123:/home/mg/ws-scanner/sdrcfg-rtl0.txt
echo ---SCAN 401 to 403 complete ----------------  >> /tmp/scannerlist.log
sleep 3

rtl_power -f 403M:405M:1000 -d0 -g 38 -p 28 /tmp/scan403405.csv -1 2>&1 > /dev/null
cd /home/mg/ws-scanner/
sudo ./scannerlist -L -30 -H /tmp/holding403405.txt -o /tmp/outlist403405.txt -f /tmp/scan403405.csv -v -d /home/mg/ws-scanner/scannerblacklist.txt -w /home/mg/ws-scanner/scannerwhitelist403405.txt  >> /tmp/scannerlist.log
echo TODO: scp /tmp/outlist403405.txt pi@192.168.2.118:/home/mg/scanner/sdrcfg-rtl0.txt >> /tmp/scannerlist.log
echo ---SCAN 403 to 405 complete ----------------  >> /tmp/scannerlist.log
echo ---Reset USB Device ---
/usr/sbin/usb_modeswitch -b 4 -g 2 -R -v 0bda -p 2838 >> /tmp/scannerlist.log
echo ==============================================  >> /tmp/scannerlist.log
echo ---Done---
echo ---Done--- >> /tmp/scannerlist.log
echo ==============================================  >> /tmp/scannerlist.log

