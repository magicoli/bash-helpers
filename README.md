# Bash helpers

A couple useful tools for bash scripting

Special mention for

## helpers

Put this line at the beginning of your script

`. /path/to/helpers`

and use these functions inside the script

`
end [errornumber] [message]
log [errornumber] [message]
readvar [var]
yesno [-y] ["message"]
ucfirst [string]
`

## ini_parser

A tool to read .ini config in bash scripts

let's say you have a .ini file with this content

```
[Default]
	name = "Albert"
[Smart]
	name = "Einstein"
```

Put this line at the beginning of your script

`. /path/to/ini_parser`

And, where you need it

`
ini.parse /path/to/config/file.ini
ini.section.Default
echo $name
`

Output: `Albert`

And later...

`
ini.section.Smart
echo $name
`

Output: `Einstein`

Voilà ! (en français dans le texte)
