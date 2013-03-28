#!/bin/sh

#-----------------------------------------------------------------------------
# Set your values here

DIR_DATA=
SUBDIR_FILES=
SUBDIR_DUMP=

SVN_REPO=
SVN_USER=
SVN_PASS=

DB_NAME=
DB_USER=
DB_PASS=

LOG_DIR=
LOG_LEVEL=	#0=none, 1=error, 2=warn, 3[default]=info, 4=debug


#-----------------------------------------------------------------------------
# Do not change anything below this line

add_path_delimiter() {
    local str=$1
    local last=`echo $str | sed 's#\(.*\)\(.\)$#\2#'`
    [ $last != '/' ] && echo "$str"/ || echo $str
}

init_log() {
    [ $LOG_LEVEL ] || LOG_LEVEL=3
    [ $LOG_LEVEL -lt 0 || $LOG_LEVEL -gt 4 ] && LOG_LEVEL=3
    [ $LOG_DIR ] && LOG_DIR=`add_path_delimiter $LOGDIR` || LOG_DIR=/var/log/redmine_bak_svn/
    if [ $LOG_LEVEL -gt 0 ] 
    then
	[ ! -e $LOG_DIR ] && mkdir -p $LOG_DIR
	LOG_FILE="$LOG_PATH"redminebak_$timestamp
    fi
}

#-----------------------------------------------------------------------------
# Main

#set -x

timestamp=`date +%Y%m%d_%H%M%S`

[ $DIR_DATA ] && DIR_DATA=`add_path_delimiter $DIR_DATA` || DIR_DATA="./" 
dir_files=$DIR_DATA`add_path_delimiter $SUBDIR_FILES`
dir_dump=$DIR_DATA`add_path_delimiter $SUBDIR_DUMP`

mysqldump -u$DB_USER -p$DB_PASS $DB_NAME > $dir_dump"dump.sql"
echo dumping $DB_NAME with $DB_USER $DB_PASS

addcount=0
for add_file in `svn status $DIR_DATA | grep ^\? | awk '{print $2}'`
do
    echo $addcount: adding $add_file 
    let addcount=$addcount+1    
    svn add $add_file 2>&1
done

delcount=0
for del_file in  `svn status $DIR_DATA | grep ^! | awk '{print $2}'` 
do 
    echo $delcount: deleting $del_file 
    let delcount=$delcount+1    
    svn delete $del_file 2>&1
done

commit_msg="Automated Backup $timestamp
attachment(s) added:   $addcount
attachment(s) deleted: $delcount
"

echo commiting
svn commit --message "$commit_msg" --username $SVN_USER --password $SVN_PASS \
    --quiet --no-auth-cache --non-interactive --trust-server-cert $DIR_DATA


