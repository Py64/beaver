# Beaver
Package manager written in Haskell.

# Warning! Chameleon included!
Chameleon is used to add (or remove) repositories.

# ...and with uncomplete Hummingbird!
Hummingbird in its current state probably won't build.

What it will do? Simple task: build package and pack it.

# Requirements
- ghc (make)
- haskell-split (make)
- haskell-missingh (make)
- tar

# Building
```
mkdir out src/.o src/.hi
cd out
ghc --make ../src/chameleon.hs -o ./chameleon -odir ../src/.o -hidir ../src/.hi
ghc --make ../src/beaver.hs -o ./beaver -odir ../src/.o -hidir ../src/.hi
g++ ../src/beaver-parse.cpp -o ./beaver-parse
g++ ../src/beaver-pkgname.cpp -o ./beaver-pkgname
```

# Installing
EXECUTE AS ROOT IN out DIRECTORY
```
cp beaver-parse beaver chameleon beaver-pkgname /usr/bin/
```

# TODO
- Add some new entries to .META files (planned: maintainer, build date & time (will be used to check which one is newer))
- If option MD5Checking = yes download also <pkgname>.md5 and check sums before install.
- Implement package installation
- Implement package uninstalling
- Implement database synchronizing
- Implement package downloading
- Expand hummingbird tool.
- Add repo_maintaine (top secret name) tool.
- Introduce .tama (from polish: dam) extension.
