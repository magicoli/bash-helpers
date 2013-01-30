#!/bin/sh

# This scripts gets files from ftp server and put them in the right directory
# on the production database server
# It mut be run from the production database server
#
# Change Log
# 15.10.2002 - ovh
#

LISTMAIL='ovh@clpb.be jpp@clpb.be  ppl@clpb.be clpb@sgs.be.sema.com kle@clpb.be'
WORKINGDIR=/gaelle/parking/xyz/ftp

PATH=.:/usr/sopres:/bin/:/usr/bin:/opt/clpb/bin
export PATH

PGM=`basename $0`
TMP=/tmp/$PGM.$$
LOG=/tmp/$PGM
LOGGING=yes
DEBUG=yes
ERROR=$LOG.error.2t 

log() {
    LOGLINE=`date +"%b %e %H:%M:%S"`" $PGM[$$]: $@"
    [ "$LOGGING" ] && (echo $LOGLINE >> $LOG.log)
    [ "$DEBUG" ] && (echo $LOGLINE )|| A=
    [ $ERRNUM ] && (echo $LOGLINE >> $ERROR ) || A=
}

end() {
    ERRNUM=$1
    if [ "$ERRNUM" -a "$ERRNUM" = "`echo $ERRNUM|sed 's/[^0-9]//g'`" ]
	then
	ERRNUM=`expr $ERRNUM + 0`
	shift
	[ "$@" ]  && log "<$ERRNUM>" $@
    else
	ERRNUM=
	[ "$@" ]  && log $@
    fi
    rm -f $TMP*
    rm -f $LOG.lock
    log "Stopped"
    exit $ERRNUM
}

log Started

touch $ERROR && log trace file $ERROR created || end 10 Could not write to $ERROR

# echo 'OK:' > $ERROR

WORKINGDIR=/maryse/parking/ovh

if [ -d "$WORKINGDIR" ]
    then
    cd $WORKINGDIR  && log working in $WORKINGDIR || end 11 Could not cd to $WORKINGDIR
else
    end 12 "Directory $WORKINGDIR does not exist"
fi


RO=$#
# if one argument then read only

log Given $RO arguments

# ONLY_ONE=only_one_cron_get_from_ftp.txt.t

if [ -f $LOG.lock ]
	then
	end "Someone else is using the file '$LOG.lock' since `cat $LOG.lock`"
        end "this cron_get_from_ftp of `date ` is abandoned !!"
	fi

date > $LOG.lock && log "Locking file $LOG.lock" || end "Could not use $LOG.lock"

end

# remove the file if ^C or hangup or exit !!

trap "rm -f $LOG.lock" 0 1 2 3

TMP1=/tmp/partn.txt.t
CONFIG=list_partner.txt
LISTE=list_file_to_get.lst
COLLISION=collision.txt.10t

echo "first install config on ftp copying :"
install_config_on_calmar.sh

#first get collision and if not empty the wait ...
echo "quote site exec sh -c /export/home/ftpclpb/cron_collect_file_ready.sh"
echo "get $COLLISION and LISTE"
ftp -i calmar <<!
quote site exec sh -c /export/home/ftpclpb/cron_collect_file_ready.sh
get $COLLISION
get $LISTE
bye
!
if [ -s $COLLISION ]
	then
	cat $COLLISION >> trace_get_from_ftp.trace 
	exit 0
	fi
#OK , we can get the liste !!
LOG=get_ftp.log

if [ ! -s $LISTE ]
	then
	echo "super , nothing to do !!"
	exit 0
	fi

if [ "$RO" = 1 ]
	then
	echo "Liste of file to get :"
	cat $LISTE
	echo "Nothing treated because read only"
	exit 0
	fi

CIFS="$IFS"

ACUMAIL=`pwd`/mailtrace/accu.mail.ftp_in.$$.txt.4t
echo "`date` : this is the list of files we collect from FTP" > $ACUMAIL

while read LINE
	do
	IFS=:
	set $LINE
	# restore
	IFS="$CIFS" 
	# real filename basename
	FN="$1"
	#source file
	FS="$2"
	# trigger file to remove OR NO !!
	FRM="$3"

	# trigger file to create OR OR archive to do ( depend of NO or else on $FRM )
	FTC="$5"

	# date note
	DFILE="$4"
	# get crypt
	CRYP="$6"
	# get mail adress
	ADMAIL="$7"
	# 
	PARTNER="$8"
		ASC="$9"
	#echo "YYYY PARTNER=$PARTNER:  ASC=$ASC:"
		IFS=,
		set $ASC
		POSTIN="$2"
		if [ "$POSTIN" = "" ]
			then
			POSTIN="mv" # the default program for postin
			fi
		IFS="$CIFS"
	#echo "XXXXXX POSTIN = :$POSTIN:"
	#note that $1 $2 are saboted !!

	# we get it 
	echo "get $FS download/$FN"
	ftp -i calmar <<-!
	bin
	get $FS download/$FN
	bye
	!
	# Here we do a security copy 
	cp download/$FN archive/$FN.$$.10t

	# here we had to unzip or uncompress the file 
	# unzip or gzip etc..
	cd download

	echo1 -n "FTP get '$FS' " >> $ACUMAIL
	 

	if [ "$CRYP" = NONE ]
		then
		echo "testing if $FN is a zip or .Z or ... file ? "
		case "$FN" in
			*.ZTP) NEWF=`basename $FN .ZIP`
			       echo "unzip -p $FN > $NEWF"
			       unzip -p "$FN" > $NEWF 
			       mv $FN $FN.$$.3t
			       FN=$NEWF ;;
			*.zUi) NEWF=`basename $FN .zip`
			       echo "unzip -p $FN > $NEWF"
			       unzip -p "$FN" > $NEWF 
			       mv $FN $FN.$$.3t 
			       FN=$NEWF ;;
			*) echo "$FN is not a zip file( no more application)" ;;
		esac
		ERR=0
		else
		echo "This a PGP partner...uncrypt with key $CRYP"
		NEWF=$FN.after_decrypt
		../pgp_decrypt.sh dummy < $FN > $NEWF
		ERR=$?
		if [ $ERR != 0 ]
			then
			echo "Something crash with pgp_decrypt < $FN > $NEWF"
			echo "see gags/$FN file control stay on ftp !!"
			mv $NEWF ../gags
			mv $FN ../gags
			cd ..
			echo "ERROR!"  > $ERROR
			echo " pgp_decrypt failed with error $ERR FILE is gags/$FN">> $ACUMAIL
			echo " Mail is now send to partner : $ADMAIL ">> $ACUMAIL
			echo " Dear partner , we have a permanent decrypt error ($ERR) 
			       with your file $FN.. 
			       Please replace it or delete it" | ftp_mail.sh "FTP CLPB ERROR on DOWNLOAD" $ADMAIL

			continue
			fi
		mv $FN $FN.$$."$CRYP".pgp.3t
		mv $NEWF $FN
		fi
	# ERR is 0 if all OK ..
	cd ..
	if [ $ERR = 0 ]
		then
		# remove  the eventual gag crypt and decrypt ..
		NEWF=$FN.after_decrypt
		if [ -f "gags/$NEWF" ]
			then
			mv gags/$NEWF gags/$NEWF.3t
			fi
		if [ -f "gags/$FN" ]
			then
			mv gags/$FN gags/$FN.3t
			fi
		fi


	INFO=`extract_info.sh download/$FN`
	if [ $? -ne 0 ]
		then
		echo "perhaps not a card link file or unknow type :see file  download/GAG.$FN.10t"
		mv download/$FN gags/GAG.$FN
		echo "extract_info.sh failed.. files is kept in gags/GAG.$$.$FN" >> $ACUMAIL
		echo "ERROR!"  > $ERROR
		echo " Dear partner , we have a problem with your file $FN 
		       perhaps not a card link file or unknown type or no unknown structure...
		       Please replace it or delete it" | ftp_mail.sh "FTP CLPB ERROR on DOWNLOAD" $ADMAIL
		# mail to operator 
	else
		# rm the eventually old version files
		if [ -f "../gags/GAG.$FN" ]
			then
			mv "../gags/GAG.$FN" "../gags/GAG.$FN.3t"
			fi
		# APPLNL:41:47:applnl:app:applnl:
		IFS=:
		set $INFO
		IFS="$CIFS"
		echo "INFO = $INFO"
		# $1 is type   $2 = from   $3 = to  $4=dest $5=suffix
		# $8 is RESEND|NO
		# here the type is important
		# OLD VERSION DEST=/work/data/`cat current_database.txt`/data/$4/$2_$FN.$5
		# now we copy the file SO !!
		if [ `s_expr substr $4 1 1 ` = / ]
			then
			DEST="$4/$FN" 
			else
			DEST=/work/data/`cat current_database.txt`/data/$4/$FN
			fi
			
		echo "$POSTIN :download/$FN: :$DEST:"
		$POSTIN "download/$FN" "$DEST"
		echo "`date`:$FS:$DEST:$POSTIN:" >> $LOG
		echo "File has been set to '$DEST'" >> $ACUMAIL
		if [ "$9" != NO ]
			then # brico ds extract_info for special suffix
			STDERROR=/prov/tmp/dev_cron_get_from_ftp.$$.3t
			echo "Now I execute $9 '$DEST' ( stderr=$STDERROR) " >> $ACUMAIL
			"$9" "$DEST" >> $ACUMAIL 2>> $STDERROR
			fi
		fi	

	if [ "$FRM" != NO ]
		then
		echo "Now on the ftp, I delete $FRM "
		echo "   and create $FTC"
		OKF=OK_F.txt.t
		echo "OK" > $OKF

		ftp -i calmar <<-!
		delete $FRM
		bin
		put $OKF $FTC
		bye
		!
	   else
		echo "Now on ftp .. just mv $FS $FTC"
		ftp -i calmar <<-!
		rename  $FS $FTC
		bye
		!
		fi
	done < $LISTE
echo "FINAL : and now erase $LISTE on calmar"
# say to calmar , it is now OK !!

> $LISTE

ftp -i calmar <<!
put $LISTE
bye
!
echo "----------- END ----------------" >> $ACUMAIL
ftp_mail.sh "`cat $ERROR` FTP CLPB : FILES COMING in" $LISTMAIL < $ACUMAIL
rm -f $ERROR
