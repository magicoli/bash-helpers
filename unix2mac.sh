#!/bin/sh
#
# Copyright 2015 Olivier van Helden <olivier@van-helden.net>
# Released under GNU Affero GPL v3.0 license
#    http://www.gnu.org/licenses/agpl-3.0.html

VTAB='<\\\n>'

cat $@ |tr "\n" "" 
