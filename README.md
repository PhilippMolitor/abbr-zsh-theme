# ABBR ZSH theme

### Current segements:
* Exit code (tick on 0, else exit code) with colorization
* hostname/username
* Abbreviated PWD
* $ or # (privilege)


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
* `/home/phil_butnotphil` -> `/h/p`
* `/home/linus/Projects` -> `/h/l/P`

