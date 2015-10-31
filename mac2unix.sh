#!/bin/sh

VTAB='<\\\n>'

cat "$@" |tr "" "\n"|sed "s//$VTAB/g"
