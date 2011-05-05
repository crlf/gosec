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
    
lynx -dump $URI > gone.tmp
if [ $? -gt 0 ]
then
 echo "ERROR: Execution error. Check if 'lynx' package is installed."
 exit 127
fi
sed 's/http/\^http/g' gone.tmp | tr -s "^" "\n" | grep http| sed 's/\ .*//g' > gtwo.tmp
rm gone.tmp
sed '/google.com/d' gtwo.tmp > URLS_$SEARCHF
rm gtwo.tmp
    
echo "SUCCESS: Extracted '`wc -l URLS_$SEARCHF | awk '{print $1}'` links' and listed them in '`pwd`/URLS_$SEARCHF' file for reference."
echo ""
echo "-------------------------------- URL RESULTS --------------------------------"
cat URLS_$SEARCHF
echo "-----------------------------------------------------------------------------"
echo ""

#EOF
