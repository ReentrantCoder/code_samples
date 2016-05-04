#! /bin/bash
STR=~/Documents/cpm/project/data/x62.5y37.5.data
echo 'RSSI' > $STR
for i in `seq 1 20`; do /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep CtlRSSI | awk '{print $2}' >> $STR; sleep 15.; done