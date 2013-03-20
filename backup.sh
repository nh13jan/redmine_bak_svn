#!/bin/bash

#----------------------------------------------------------------------------
# Set your value here

DIR_DATA=
SUBDIR_FILES=files/
SUBDIR_DUMP=dump/

SVN_REPO=
SVN_USER=
SVN_PASS=

DB_NAME=
DB_USER=
DB_PASS=

LOG_DIR=
LOG_LEVEL=	#0=none, 1=error, 2=warn, 3[default]=info, 4=debug


#----------------------------------------------------------------------------
# Do not change anything below this line

add_path_delimiter() {

  local str = $1
  local last = `echo $str | sed 's#\(.*\)\(.\)$#\2#'`
  [ $last != '/' ] && echo "$str"/ || echo $str

}

init_log() {

  [ $LOG_LEVEL ] || LOG_LEVEL=3
  [ $LOG_LEVEL -lt 0 || $LOG_LEVEL -gt 4 ] && LOG_LEVEL=3

  [ $LOG_DIR ] && LOG_DIR=`add_path_delimiter $LOGDIR` || LOG_DIR=/var/log/redmine_bak_svn/}
  if [ $LOG_LEVEL -gt 0 ] 
  then
    [ ! -e $LOG_DIR ] && mkdir -p $LOG_DIR
    LOG_FILE="$LOG_PATH"redminebak_`date +%Y%m%d_%H%M%S`
  fi



[ `echo /var/log/uschi/ | sed 's#\(.*\)\(.\)$#\2#'` = '/' ] && echo yo || echo nope

}



