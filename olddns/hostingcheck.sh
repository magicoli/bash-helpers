LIST=`cat $@`
for SITE in $LIST
do 
#	echo -n $SITE -
	A=$(host $SITE | grep "has address" | cut -d " " -f 4)
#	echo -n www.$SITE
	B=$(host www.$SITE | grep "has address" | cut -d " " -f 4)
done