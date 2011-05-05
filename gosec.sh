#!/bin/bash

clear
echo ""
echo "#################################################################"
echo "#                                                               #"
echo "# .-----.-----.-----.-----.----.                                #"
echo "# |  _  |  _  |__ --|  -__|  __|  author: Rishi Narang          #"
echo "# |___  |_____|_____|_____|____|  e.mail: code[at]wtfuzz.com    #"
echo "# |_____|                                                       #"
echo "#                                                               #"
echo "# gosec: [GO]ogle [SE]arch [C]ommand - A Linux Bash Script      #"
echo "#                                                               #"
echo "#################################################################"
echo ""

if [ -z $1 ]
then
 echo "ERROR: No search string supplied. Check the README file."
 echo "USAGE: ./gosec.sh <search srting>"
 echo ""
 echo -n "Anyways for now, supply the search string here: "
 read SEARCH
else
 SEARCH=$@
fi
    
SEARCHF=`echo $SEARCH | sed -e 's/ /./g'`

URL="http://google.com/search?hl=en&safe=off&q="
STRING=`echo $SEARCH | sed 's/ /%20/g'`
URI="$URL%22$STRING%22"

lynx -dump $URI > g1.tmp
if [ $? -gt 0 ]
then
 echo "ERROR: Execution error. Check if 'lynx' package is installed."
 exit 127
fi
sed 's/http/\^http/g' g1.tmp | tr -s "^" "\n" | grep http| sed 's/\ .*//g' > g2.tmp
sed '/google.com/d; /webcache/d' g2.tmp > URLS

echo "" > URLS_$SEARCHF
echo "------------------------------- URL RESULTS --------------------------------" >> URLS_$SEARCHF
echo "" >> URLS_$SEARCHF
sed = URLS | sed 'N;s/\n/. /' >> URLS_$SEARCHF
echo "" >> URLS_$SEARCHF
echo "----------------------------------------------------------------------------" >> URLS_$SEARCHF
rm g1.tmp g2.tmp URLS

NUM=`wc -l URLS_$SEARCHF | awk '{print $1}'`
LOC=`expr $NUM - 5`

echo "SUCCESS: Extracted '$LOC links' and listed them in '`pwd`/URLS_$SEARCHF' file for reference."
cat URLS_$SEARCHF
echo ""

#EOF