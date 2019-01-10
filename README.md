# scrapyd-opensuse-scheduler

## Author : Hardika Gutama

This project contains scripts and unit files necessary for automatically schedule the opensuse mail scraper inside a scrapyd server. Lets break it down on what each files will do :

- crawl-current.sh

    This is the script that will schedule the opensuse mail spider to get any mails from the **current, next, and previous** month. 
    
    Why? you might ask. Since the current date is generated from the system, I create the script like this so the spider won't miss any data even if there is a timezone mismatch between your server and the openSUSE page. It also doesn't take too much time or processing power as the spider will immidiately closes if it can't access the page **OR** the page have been parsed.

- crawl-year.sh

    This is the script that will get you all the mails from a category, **for a given year**.

- opensuse-crawler.service
    
    This is the systemd unit file that will watch the `crawl-current.sh` and restart it if necessary

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for production, development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

First and foremost, you must have the server running in the correct timezone. check `date` :

```
$ date
```

You need `curl` installed on your scrapyd server using the appropriate package manager

```
$ sudo zypper in -y curl
```

### Installing

A step by step series of examples that tell you have to get a development env running

Clone this repo

```
$ git clone https://gitlab.s8i.io/hrdkgtm/scrapyd-opensuse-scheduler.git
```

Modify the script accordingly to your needs, I suggest use the `crawl-year.sh` script for testing as it will only crawl one section and is not complex

These scripts are designed to be easily modified through variables. And they are pretty straightforward

```
YEAR='2018'
SCRAPYD_SERVER='172.168.3.21:6800'
DATADIR='/opt/scrapyd/data/'
PROJECT_NAME='opensuse_mail'
SPIDER='mail_spider'
MAIL_LIST=('opensuse-announce' 'opensuse-bugs' 'opensuse-security-announce' 'opensuse-updates')
```

The script should not output any data to stdout, but for testing you can uncomment the `echo` command inside `get_mail` function

```
get_mail () {
    curl http://$SCRAPYD_SERVER/schedule.json -d project=$PROJECT_NAME -d spider=$SPIDER -d setting=FEED_URI="$DATADIR/$1/$2/$3.json" -d category=$1 -d date="$2-$3"
    #echo $1 $2 $3
}
```

## Deployment

Deploying to a live system should be as simple as copying the `crawl-year.sh` script to the scrapyd server. If you want absolute minimal change to the code, and get it running as fast as possible, follow these steps

- copy the `crawl-current.sh` script to your `/root/bin/` directory
- copy the `opensuse-crawler.service` unit file to `/etc/systemd/system/`
- run systemctl `daemon-reload`
- `systemctl start opensuse-crawler`

## Built With

* Bash
* cURL
* SystemD Unit FIle

## Versioning
   
Semantic Versioning

## Known issues
   
* All the known problems, bugs listed here. Add link to issues if any.

## License

This project is licensed under the Apache License 2.0 - see the LICENSE.md file for details
