# Bash helpers

A couple of useful tools for bash scripting.

## helpers

With composer:

```
composer config repositories.magicoli/bash-tools vcs git@github.com:magicoli/bash-tools.git &&
composer require magicoli/bash-tools:@dev
```

Globally:

```
composer global config repositories.magicoli/bash-tools vcs git@git.magiiic.com:magicoli/bash-tools.git &&
composer global require magicoli/bash-tools:dev-master"
```

Put this line at the beginning of your script (_do not run the file directly, source it_):

```
source /path/to/helpers
```

and use these functions inside the script

```
end [errornumber] [message]
log [errornumber] [message]
readvar [var]
yesno [-y] ["message"]
ucfirst [string]
```

## ini_parser

A tool to read .ini config in bash scripts

let's say you have a .ini file with this content

```
[Default]
	name = "Albert"
[Smart]
	name = "Einstein"
```

Put this line at the beginning of your script (_do not run the file directly, source it_):

```
. /path/to/ini_parser
```

And, where you need it

```
ini.parse /path/to/config/file.ini
ini.section.Default
echo $name
```

Output: `Albert`

Then, later... (no need to repeat ini.parse /path/to/config/file.ini)

```
ini.section.Smart
echo $name
```

Output: `Einstein`

Voilà ! (en français dans le texte)

More details inside ini_parser
