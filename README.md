# Bash helpers

>  Copyright 2015 Olivier van Helden <olivier@van-helden.net>.
>  Released under GNU Affero GPL v3.0 license, unless otherwise stated.
>  http://www.gnu.org/licenses/agpl-3.0.html

A couple of useful tools for bash scripting.

## helpers

Put this line at the beginning of your script (*do not run the file directly, source it*):

```
. /path/to/helpers
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

Put this line at the beginning of your script (*do not run the file directly, source it*):

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
