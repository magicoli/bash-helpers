#\!/bin/sh

DEFAULTSITE=www.millyfilms.be

PGM=`basename "$0"`
TMP=/tmp/$PGM

if [ ! $0 ]
	then
	echo usage: $PGM page
	exit 1
fi

page="$1"

GIVENSITE=`
	echo "$page" \
		| grep "^http://[a-zA-Z0-9\.]*/" \
		| sed "s/http:\/\/\([a-zA-Z0-9\.]*\)\/.*/\\1/" \
		`
if [ "$GIVENSITE" ]
	then
	site=$GIVENSITE
	page=`
		echo "$page" \
		| sed "s/\(http:\/\/[a-zA-Z0-9\.]*\)\///"
	`
else
	site=$DEFAULTSITE
fi

printf "" > $TMP.delete
printf "" > $TMP.processed
filetype=`echo "$page" | grep "\." | sed "s/.*\.\([a-zA-Z0-9]*\)$/\\1/"`
if [ "$filetype" = "html" -o "$filetype" = "htm"  ]
	then
	echo "$page" > $TMP.deletepages
else
	echo "$page/index.html" | sed "s/\/\//\//g" > $TMP.deletepages
fi
echo "http://$site/$page" > $TMP.pages

while [ `cat $TMP.pages 2>/dev/null | wc -l` -gt 0 ]
	do
	[ -f "$TMP.process" ] && cat $TMP.process >> $TMP.processed
	cp $TMP.pages $TMP.process
	printf "" > $TMP.pages
	cat $TMP.process \
		| while read url
		do
		echo "# $url"
		lynx -dump "$url" > $TMP.html
		cat $TMP.html \
			| grep -A 1000 "^References" \
			| grep "http:\/\/$site\/" \
			| sed "s/.*http:\/\/$site\///" \
			| while read file
			do
			filetype=`echo "$file" | grep "\." | sed "s/.*\.\([a-zA-Z0-9]*\)$/\\1/"`
			if [ "$filetype" = "html" -o "$filetype" = "htm"  ]
				then
				exists=`grep "^http://$site/$file$" $TMP.pages $TMP.process*`
				if [ ! "$exists" ]
					then
					echo "http://$site/$file" >> $TMP.pages
					echo "$file" >> $TMP.deletepages
				fi
			elif [ "$filetype" != "" ]
				then
				echo "  delete $file"
				echo "$file" >> $TMP.delete
			fi
		done
	done
done

filestodelete=$(echo `cat $TMP.delete 2>/dev/null | wc -l`)
pagestodelete=$(echo `cat $TMP.deletepages 2>/dev/null | wc -l`)
if [ $filestodelete -gt 0 ]
	then
	read -p "process delete $filestodelete files and $pagestodelete pages? [y/N] " answer
	if [ "$answer" = "y" -o "$answer" = "Y" -o "$answer" = "o" -o "$answer" = "O" ]
		then
		cat $TMP.deletepages $TMP.delete | sort -u | while read file
			do
			echo "delete \"$file\"" 
		done | ftp $site | grep "^.5"
	fi
else
	echo "# no files to delete"
fi


# | ftp www.millyfilms.be

