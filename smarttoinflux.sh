#!/bin/bash

# ESXi SSH
esxiserver="esxi.local.domain"
esxiuser="root"
esxipass="yourpasswdhere"

# InfluxDB
influxserver="influxdb.local.domain"
influxuser="user"
influxpass="pass"
influxdb="hddsmart"

disks=$(sshpass -p "$esxipass" ssh -o StrictHostKeyCHecking=no $esxiuser@$esxiserver "ls /vmfs/devices/disks | sed '/^vml/ d' | sed '/:.*/ d'")

for disk in $disks
do
    smart=$(sshpass -p "$esxipass" ssh -o StrictHostKeyCHecking=no $esxiuser@$esxiserver "esxcli storage core device smart get -d $disk")
    health=(`echo $smart | sed 's/.*Health Status\(.*\)Media Wearout.*/\1/'`)
    temp=(`echo $smart | sed 's/.*Drive Temperature\(.*\)Driver Rated Max Temperature.*/\1/'`)
    diskserial=(`echo $disk | sed 's/.*_//'`)
    curl -i -XPOST "http://$influxserver:8086/write?db=$influxdb" --data-binary "health,hdd=$diskserial status=\"${health[0]}\",temp=${temp[0]}" > /dev/null 2>&1
#    curl -i -XPOST "http://$influxserver:8086/write?db=$influxdb&u=$influxuser&p=$influxpass" --data-binary "health,hdd=$diskserial status=\"${health[0]}\",temp=${temp[0]}" > /dev/null 2>&1
#    echo $diskserial ${health[0]} ${temp[0]}
done





























 1Hilfe                 2Speichern             3Markieren              4Ersetzen               5Kopieren               6Verschieben           7Suchen                 8Löschen                9Menüs                 10Beenden
