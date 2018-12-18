#!/bin/bash
#    |\__/|
#    - ● ● -
#   /|  ³ |  🌮 Want a taco?
# _/ |_  _|_/¯
###   _||_
###  (____)
###   UPVD 


[ "$#" -ne 1 ] && exit 1

if [[ ! "$1" =~ [0-9A-Z]{4} ]]; then
    echo Usage : $0  CODE_METAR 
    exit
fi


# URL("RAW" format)  
URL="https://www.aviationweather.gov/metar/data?ids=" 

# METAR de $1
wget -q -O "metar$1".txt  "${URL}${1}"  

#Exemple
# wget -O metar.html 'https://www.aviationweather.gov/metar/data?ids=LFMP&format=raw&date=&hours=0&taf=on'
 
[ $? -ne 0 ] && exit 2

#curl "${URL}${1}"

#fichier d'info raw 
cat "metar$1".txt | grep '<code>' | sed 's/^[<code>'$1' ]*//;s/[</code><br/>]*$//' > $1.info 
DATA=$(cat $1.info) 

#methode 1
#cat $1.info  | cut -d: -f1 --> RAWTIME = first field
#RAWTIME=$(echo $DATA | cut -d ' ' -f1)
#RAWTEMP=$(echo $DATA | cut -d ' ' -f8)
#RAWPRES=$(echo $DATA | cut -d ' ' -f9) 

#methode 2
RAWTIME=$(echo $DATA | cut -d ' ' -f1)
RAWTEMP=$(echo $DATA | sed -n -e 's/^.* \(M\{0,1\}[0-9]\{2\}\\/M\{0,1\}[0-9]\{2\}) .*$/\1/p')
RAWTEMP=$(echo $RAWTEMP | sed -e 's/M/-/g')
RAWPRES=$(echo $DATA | cut -d ' ' -f9) 

RAWTEMP=$(echo $RAWTEMP | sed -e 's/^.* Q\([0-9]\{4\}\) .*$/\1/p')

# DATE DECODAGE
JOUR=${RAWTIME:0:2}
HEUR=${RAWTIME:2:2}
MINUTES=${RAWTIME:4:2}
DATEISO="$(date +'%Y-%m-')$JOUR $HEUR:$MINUTES"

echo "##################   _  RAW DATA   _   ##################"
echo " $DATA"
echo " _______________________________________________________________"
echo "|______________________CONCERNED DATA___________________________|"
echo "   RAW_TIME : $RAWTIME | RAW_TEMP : $RAWTEMP | RAW_PRES : $RAWPRES  "
echo "|_______________________________________________________________|"
echo "> _ DECODE DATE      ∇"
echo "	=>   $RAWTIME ($DATEISO)"


# DECODAGE TEMPRATURE
TEMPM=$(echo $RAWTEMP | cut -d'/' -f1)
TEMPR=$(echo $RAWTEMP | cut -d'/' -f2)

echo ">_ DECODE TEMPRATURE ∇ "
echo "	=>   ¯\_($TEMPM >< $TEMPR)_/¯"


# DECODAGE PRESSION
PRESSION=$(echo $RAWPRES | tr -d 'Q') 

echo "> _ DECODE PRESSION  ∇"
echo "	=>   $PRESSION°"
