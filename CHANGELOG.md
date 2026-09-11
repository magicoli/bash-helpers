## Changelog

### 1.0.0-beta-1

- Functions:
    - **path manipulation**: append_path, prepend_path, add_path, clean_path
    - **colors**: ansi_color $color $style $scope, ansi_reset
    - **colors shortcuts**: ($BLACK, $RED, $GREEN, $BG_BLACK, $BG_RED...)
    - **strings conversion**: transliterate, words, ucfirst, camel_case, constant_case, kebab_case, lower_case, upper_case, pascal_case, screaming_snake_case, snake_case, dot_var
    - **boolean** (understand y/n, yes/no, true/false, ...): is_false, is_true
    - **time**: convertsecs, countdown
    - **ui**: error, help, log, readvar, success, usage, yesno
    - **dev**: debug, debug_mode, die, end, get_config, update_env, update_env_keys, urldecode, urlencode
- **Common scripts**, added to vendor binaries: cpuinfo, ini_parser, mail-report, randompassword, stamp, stampfile, tildelete, titlecase, trash, tts
- **Other scripts**, available from repo bin/ directory (mostly backwards-compatibility wrappers for tools available in bash-helpers functions): ucfirst, urlcoder, urldecoder, urlencoder, webnormalize
