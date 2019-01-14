#!/bin/bash
#set -x

########## THIS IS A SCRIPT TO REQUEST THE OPENSUSE MAIL SPIDER IN A SCRAPYD SERVER
##### BASED ON CURRENT YEAR, SCRAPING THE CURRENT, PREVIOUS, AND NEXT MONTH

# Variable Assignments
THIS_YEAR=`date +'%Y' -d 'now'`
PREV_YEAR=$THIS_YEAR
NEXT_YEAR=$THIS_YEAR

THIS_DAY=`date +'%d' -d 'now'`

THIS_MONTH=`date +'%m' -d 'now'`
PREV_MONTH=`date +'%m' -d 'last month'`
NEXT_MONTH=`date +'%m' -d 'next month'`
# Scrapyd server variable assignment, modify according to your needs
SCRAPYD_SERVER='localhost:6800'
DATADIR='/opt/scrapyd/data/'
PROJECT_NAME='opensuse_mail'
SPIDER='mail_spider'
MAIL_LIST=('opensuse-announce' 'opensuse-bugs' 'opensuse-security-announce' 'opensuse-updates')

# Conditionals on January and December to change the previous year and next year
if [ $THIS_MONTH -eq '01' ]
then
    PREV_YEAR=`date +'%Y' -d 'last year'`
elif [ $THIS_MONTH -eq '12' ]
then
    NEXT_YEAR=`date +'%Y' -d 'next year'`
fi

# The actual script, 
# Touch this part with care

#Functions
get_mail () {
    #curl http://$SCRAPYD_SERVER/schedule.json -d project=$PROJECT_NAME -d spider=$SPIDER -d setting=FEED_URI="$DATADIR/$1/$2/$3.json" -d category=$1 -d date="$2-$3" > /dev/null
    echo $1 $2 $3
}
make_request_prev () {
    for MAILNAME in "${MAIL_LIST[@]}"
    do
        get_mail $MAILNAME $PREV_YEAR $PREV_MONTH
        get_mail $MAILNAME $THIS_YEAR $THIS_MONTH
    done
}

make_request_current () {
    for MAILNAME in "${MAIL_LIST[@]}"
    do
        get_mail $MAILNAME $THIS_YEAR $THIS_MONTH
    done
}

make_request_next () {
    for MAILNAME in "${MAIL_LIST[@]}"
    do
        get_mail $MAILNAME $THIS_YEAR $THIS_MONTH
        get_mail $MAILNAME $NEXT_YEAR $NEXT_MONTH
    done
}

# The forever loop until it fails, sleep for 60s
while true
do
    if [ $THIS_DAY -eq '1' ]
    then
        make_request_prev
    elif [ $THIS_DAY -gt '27' ]
    then
        make_request_next
    else
        make_request_current
    fi
    
    if [ $? -eq 0 ]
    then
        sleep 60
    else
        exit 99
    fi
done
