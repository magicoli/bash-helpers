#!/bin/sh

ssh -fN colorado.spekuloos.be -L 5003:192.168.123.99:5003

ERRORCODE=$?
if [ $ERRORCODE ]
then
    echo Probleme de connection (errorcode $ERRORCODE)
else
    echo Connexion etablie
    open "Lemaire Connect.fp5"
fi

