#!/bin/bash
#set -x

########## THIS IS A SCRIPT TO REQUEST THE OPENSUSE MAIL SPIDER IN A SCRAPYD SERVER
##### BASED ON ANY YEAR

# Variable Assignments
YEAR='2018'
# Scrapyd variable assignment, modify according to your needs
SCRAPYD_SERVER='172.168.3.21:6800'
DATADIR='/opt/scrapyd/data/'
PROJECT_NAME='opensuse_mail'
SPIDER='mail_spider'
MAIL_LIST=('opensuse-announce' 'opensuse-bugs' 'opensuse-security-announce' 'opensuse-updates')

# The actual script, 
# Touch this part with care
get_mail () {
    curl http://$SCRAPYD_SERVER/schedule.json -d project=$PROJECT_NAME -d spider=$SPIDER -d setting=FEED_URI="$DATADIR/$1/$2/$3.json" -d category=$1 -d date="$2-$3"
    #echo $1 $2 $3
} 

for i in {1..12}
do
    for MAILNAME in "${MAIL_LIST[@]}"
    do
        if [ $i -lt 10 ]
        then
            get_mail $MAILNAME $YEAR "0$i"
        else
            get_mail $MAILNAME $YEAR $i
        fi
    done
done