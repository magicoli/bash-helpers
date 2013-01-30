#!/bin/sh

SRCDIR=$HOME/tmp
DUMPDIR=$SRCDIR

PGM=`basename $0 .sh`
STAMP=`date +"%Y%m%d-%H%M%S"`

echo "$PGM: started" `date`

echo "$PGM: dumping current database"
pg_dump -a lemaire > $SRCDIR/lemaire-$STAMP.pgdump \
    && echo "$PGM:   dumped to $SRCDIR/lemaire-$STAMP.pgdump"

echo "$PGM: remove old datas from sql database"
psql -c "DELETE FROM restos;" lemaire

echo "$PGM: import new datas into sql database"
cp $SRCDIR/cnv-lem-restos.tab /tmp/lemaire-$STAMP.tab

psql -c "
	SET DateStyle TO DMY ; 
	COPY restos (id, place_id, city_id, prov_id, id_gidsnummer, name, publication, toque, hotel, hotel_stars, points, crowns, diamonds, nounours, address, zip, city, state, country, ref_derouck, weblink, web, email, web_infos, moduser, moddate, modtime) FROM '/tmp/lemaire-$STAMP.tab'
	with delimiter '\|' null as '';" lemaire

rm /tmp/lemaire-$STAMP.tab

echo "$PGM: update points_order values"
psql -c "UPDATE restos SET points_order = points where points > 0;" lemaire
psql -c "UPDATE restos SET publication  = 2004;" lemaire

echo "$PGM: finished, archiving"
mv $SRCDIR/cnv-lem-restos.tab $SRCDIR/lemaire-$STAMP.tab

