# bbmod
## Helper script for battle brother modding tools

Battle Brothers modding tools are Windows only, but their binary runs in wine. They are however a bit akward to use and the batch scripts were reported to not work well in wine.

`bbmod.sh` is a Linux-friendly replacement for the batch scripts.

## Instructions
Simply copy the `bbmod.sh` into the directory where the modding tools are located, typically: `bbros/bin`.

Then make the `bbmod.sh` executable:
```
chmod +x bbmod.sh
```

Now you can run `bbmod.sh` to convert encrypted `.cnut` files to `.nut` files and back. See the help file (`bbmod.sh -h`) for more instructions.

## Dependencies
`bbmod.sh` calls two binaries from the mod pack: `bbsq.exe` and `nutcracker.exe` and thus depends on them. They are windows programs so `wine` is required to execute them.

## Useful links

* [Adam Milazzo's modkit](http://www.adammil.net/blog/v133_Battle_Brothers_mod_kit.html#modkit) -- required for `bbmod.sh`, required to decrypt and decompile `.cnut` files
* [Squirrel language reference](https://developer.electricimp.com/squirrel) -- learn the Squirrel programming language
* [Script hooks](https://www.nexusmods.com/battlebrothers/mods/42) and [their documentation](https://docs.google.com/document/d/17oTdGmKLOvYrq6abFheuQqhPYnbtXqUgTWxjJTXAceY/edit) to make mods more portable by not overwritting the original functions, but *hooking* on them instead.
* [Basic modding tutorial on adding items](https://battlebrothers.fandom.com/wiki/Mods_and_Modding)
