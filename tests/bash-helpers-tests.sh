#!/usr/bin/env bash
#
# Make the dev sites exist: a WordPress installed in each, and nothing of ours.
#
# The dev sites are builds. Nothing in them is authored, so any of them can be
# thrown away and made again -- and a site rebuilt from scratch is the only
# proof that what it runs comes from the sources we think it does. Which is why
# none of them is in the repository.
#
# Everything here works offline: wp-cli talks to the filesystem and to the
# database, never to the site over HTTP. Serving them is a separate concern and
# the developer's business -- lerd here, something else elsewhere. Once they are
# served, dev/refresh-dev-sites puts our sources on them.

set -u

# OPTS="hqv"
LONGOPTS="clean,allow-root"
HELP="
   --clean        throw each site away first, keeping its local configuration
   --allow-root   pass --allow-root to wp-cli

   --testing      the tests environment rather than the development one
                  (or APP_ENV=testing; it defaults to dev)

   --quiet        less chatty
   --verbose      more chatty (debug mode)
   --help         this help"

HELPERS_DIR="$(dirname $(cd "$(dirname "$0")" && pwd))/bin"
source "$HELPERS_DIR/bash-helpers"
debug "DEBUG $HELPERS_DIR/bash-helpers" sourced

clean=
allow_root=

for o; do
	case $o in
	--clean)
		debug "opt --clean"
		clean=yes
		shift
		;;
	--allow-root)
		debug "opt --allow-root"
		allow_root="--allow-root"
		shift
		;;
	--)
		shift
		break
		;;
	-*)
		usage
		die "invalid option: $o"
		;;
	# *) die "additional parameters not allowed: $*"
	# 	;;
	esac
done
[ "$#" -eq 0 ] || debug "unprocessed args $@"

log "BASH_HELPERS=${BASH_HELPERS}"
log "PID=${PID}"
log "PGM=${PGM}"
log "TMP=${TMP}"
log "LOCK=${LOCK}"
log "BINDIR=${BINDIR}"
log "BASEDIR=${BASEDIR}"
log "DEVDIR=${DEVDIR}"
log "DEBUG=${DEBUG}"

log "STD=${STD}STD${STD}"
log "BLACK=${BLACK}BLACK${STD}"
log "RED=${RED}RED${STD}"
log "GREEN=${GREEN}GREEN${STD}"
log "YELLOW=${YELLOW}YELLOW${STD}"
log "BLUE=${BLUE}BLUE${STD}"
log "PURPLE=${PURPLE}PURPLE${STD}"
log "CYAN=${CYAN}CYAN${STD}"
log "WHITE=${WHITE}WHITE${STD}"

log "BG_BLACK=${BG_BLACK}BG_BLACK${STD}"
log "BG_RED=${BG_RED}BG_RED${STD}"
log "BG_GREEN=${BG_GREEN}BG_GREEN${STD}"
log "BG_YELLOW=${BG_YELLOW}BG_YELLOW${STD}"
log "BG_BLUE=${BG_BLUE}BG_BLUE${STD}"
log "BG_PURPLE=${BG_PURPLE}BG_PURPLE${STD}"
log "BG_CYAN=${BG_CYAN}BG_CYAN${STD}"
log "BG_WHITE=${BG_WHITE}BG_WHITE${STD}"
log "COLOR_HIGHLIGHT=${COLOR_HIGHLIGHT}COLOR_HIGHLIGHT${STD}"
log "COLOR_NORMAL=${COLOR_NORMAL}COLOR_NORMAL${STD}"

log "$(ansi_color red)red${STD}"
log "$(ansi_color red high)red high${STD}"
log "$(ansi_color red background)red background${STD}"
log "$(ansi_color red background high)red background high${STD}"
log "$(ansi_color background yellow)ansi_color background yellow${STD}"
log "$(ansi_color background high yellow)ansi_color background high yellow${STD}"
log "$(ansi_color bold yellow)ansi_color bold yellow${STD}"
log "$(ansi_color bold high yellow)ansi_color bold high yellow${STD}"

log "ENDSUCCESS=${ENDSUCCESS}"
log "ENDFAILED=${ENDFAILED}"
log "COLOR=${COLOR}"

# log "PATH=${PATH}"
# log "USAGE=${USAGE}"
log "APP_ENV=${APP_ENV}"
log "ENV_SUFFIX=${ENV_SUFFIX}"

log "OPTS=${OPTS}"
log "LONGOPTS=${LONGOPTS}"
log "SYNTAX=${SYNTAX}"

log "STDOUT=${STDOUT}"
log "QUIET=${QUIET}"
log "STDERR=${STDERR}"

log "TTS_ENABLED=${TTS_ENABLED}"
log "ENV_FILE=${ENV_FILE}"
log "TTS_LANG=${TTS_LANG}"
log "SAY=${SAY}"

for string in "Hello, World!" HelloWorld hello-world HELLO_WORLD HelloWORLD "Héllô / Âccèñts + other @stuff"; do
	log "$string"
	log "  kebab_case:           $(kebab_case "$string")"
	log "  snake_case:           $(snake_case "$string")"
	log "  screaming_snake_case: $(screaming_snake_case "$string")"
	log "  camel_case:           $(camel_case "$string")"
	log "  pascal_case:          $(pascal_case "$string")"
	log "  lower_case:           $(lower_case "$string")"
	log "  upper_case:           $(upper_case "$string")"
	log "  ucfirst:              $(ucfirst "$string")"
	log "  transliterate:        $(transliterate "$string")"
	log "  webnormalize:         $(webnormalize "$string")"
	log "  webnormalize -d:      $(webnormalize -d "$string")"
	log "  webnormalize -u:      $(webnormalize -u "$string")"
	log "  webnormalize -k:      $(webnormalize -k "$string")"
	log "  dot_var:              $(dot_var "$string")"
	log "  urlencode:            $(urlencode "$string")"
	log "  urldecode:            $(urldecode "$(urlencode "$string")")"
done
