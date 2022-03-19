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
