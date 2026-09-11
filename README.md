# Bash Tools

![Version](https://img.shields.io/badge/Version-1.0.0--beta--1-orange)
![Stable](https://img.shields.io/badge/Stable----lightgrey)
![bash](https://img.shields.io/badge/bash-5.x+-red)

A couple of useful tools for bash scripting. Available either directly from the repo clone, or as a composer package.

## Features

**Functions** (source `bash-helpers` to make them available in your script):

- **ui**: error, help, log, readvar, success, usage, yesno
- **colors**: ansi_color $color $style $scope, ansi_reset
- **colors shortcuts**: ($BLACK, $RED, $GREEN, $BG_BLACK, $BG_RED...)
- **path manipulation**: append_path, prepend_path, add_path, clean_path
- **strings conversion**: transliterate, words, ucfirst, camel_case, constant_case, kebab_case, lower_case, upper_case, pascal_case, screaming_snake_case, snake_case, dot_var
- **boolean conversion** (y/n, yes/no, true/false, ...): is_false, is_true
- **time**: convertsecs, countdown
- **dev**: debug, debug_mode, die, end, get_config, update_env, update_env_keys, urldecode, urlencode

**Common scripts**, added to vendor binaries (`vendor/bin`)

- cpuinfo
- ini_parser
- mail-report
- randompassword
- stamp
- stampfile
- tildelete
- titlecase
- trash
- tts

**Other scripts** available from `bash-helpers/bin` directory (mostly backwards-compatibility wrappers for tools available in bash-helpers functions):

- bin/ucfirst
- bin/urlcoder
- bin/urldecoder
- bin/urlencoder
- bin/webnormalize

## Installation in your project

With composer:

```bash
composer require magicoli/bash-tools
```

### Use bash-helpers functions

Put this line at the beginning of your script (_do not run the file directly, source it_), to provide the most common functions to your script.

```bash
#!/usr/bin/env bash
source vendor/bin/bash-helpers
# or source <path-to-repo>/bin/bash-helpers
```

## Global installation (for use from terminal or any script)

### With composer:

```bash
composer global require magicoli/bash-tools"
```

Insert in `~/.bashrc` or `~/.profile`, according to your system:

```bash
# Verify your composer home (usually ~/.composer or ~/.config/composer)
composer config data-dir
composer config -l | grep /bin

# Add composer bin dir to your profile file
# 	export PATH="<composer-home-dir>/vendor/bin:$PATH"
# E.g. one of:
export PATH="~/.composer/vendor/bin:$PATH"
export PATH="~/.config/composer/vendor/bin:$PATH"
```

### Directly from repo directory

Insert in `~/.bashrc` or `~/.profile`, according to your system:

```bash
export PATH="<path-to-repo>/bin:$PATH"
```
