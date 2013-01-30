#!/bin/sh

BASEDIR=$HOME/Desktop
REMOTE_SERVER=duke
REMOTE_DIR=tmp
REMOTE_APP=lemaire-import-fm-data.sh

PGM=`basename $0 .sh`
echo "$PGM: started" `date`
echo "$PGM: Convert and send exports"

cd $BASEDIR

ls lem*.tab | while read file
  do
  printf "   $file: "
  cat $file \
      | tr "" "\n" \
      | sed "s//$VTAB/g" \
      | sed "s/\"\"//g" \
      | grep -v "^$" \
      > cnv-$file 
  if [ "$?" = "0" ]
      then
      printf "converted "
      echo
      scp cnv-$file $REMOTE_SERVER:$REMOTE_DIR
  else 
      echo "error"
  fi
done


echo "$PGM: finished my own tasks" `date`
echo "$PGM: processing server-side scripts"

ssh $REMOTE_SERVER $REMOTE_APP

