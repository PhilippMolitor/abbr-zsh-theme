# ABBR ZSH theme

### Current segments
* Exit code (tick on 0, else exit code) with colorization
* hostname/username
* Abbreviated PWD
* $ or # (privilege)


### Variables
|Variable               |Default          |Type      |
|-----------------------|-----------------|----------|
|ABBR_FG_RETVAL_GOOD    |white            |zsh color |
|ABBR_BG_RETVAL_GOOD    |green            |zsh color |
|ABBR_FG_RETVAL_BAD     |yellow           |zsh color |
|ABBR_BG_RETVAL_BAD     |black            |zsh color |
|ABBR_FG_LOGON          |black            |zsh color |
|ABBR_BG_LOGON          |cyan             |zsh color |
|ABBR_FG_PWD            |white            |zsh color |
|ABBR_BG_PWD            |none             |zsh color |
|ABBR_FG_PROMPT_ROOT    |red              |zsh color |
|ABBR_BG_PROMPT_ROOT    |none             |zsh color |
|ABBR_FG_PROMPT_DEFAULT |`$ABBR_BG_LOGON` |zsh color |
|ABBR_BG_PROMPT_DEFAULT |none             |zsh color |


### How does the path abbreviation work?
Basically, similar to the one you find in `vim`.
Every path inside the home directory will start with `~` rather than the absolute path.
Each directory in the current PWD will be shortened to one character,
execept it starts with a `.`, then, two characters will be displayed.
The current folder will not be abbreviated.

Examples (username is phil):
* `/home/phil` -> `~`
* `/home/phil/test/abc` -> `~/t/abc`
* `/home/phil/.local/share/nano` -> `~/.l/s/nano`
* `/home/phil_butnotphil/test` -> `/h/p/test`
* `/home/linus` -> `/h/linus`

