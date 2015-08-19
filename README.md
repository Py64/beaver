# Beaver
Package manager written in Haskell.

# Warning! Chameleon included!
Chameleon is used to add (or remove) repositories.

# Dependencies
- ghc (make)
- haskell-split (make)
- haskell-missingh (make)
- tar
- sqlite
- haskell-sqlite-simple (make)
- haskell-text

In shortcut:
```
pacman -Sy ghc haskell-split haskell-missingh tar sqlite
cabal install sqlite-simple
```

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
mkdir /var/lib/beaver /var/cache/beaver /var/cache/beaver/db /var/cache/beaver/pkg
sqlite3 /var/lib/beaver/pkgs.db "CREATE TABLE installed_pkgs(name varchar(200), desc varchar(10000), repo varchar(200), arch varchar(100), version varchar(200), revision varchar(200), conflicts varchar(25000), depends varchar(25000));CREATE TABLE files (owner varchar(200), path varchar(25000));"
```

# TODO
- Add some new entries to .META files (planned: maintainer, build date & time (will be used to check which one is newer))
- If option MD5Checking = yes download also <pkgname>.md5 and check sums before install.
- Implement package installation
- Implement package uninstalling
- Implement database synchronizing
- Implement package downloading
- Add repo_maintaine (top secret name) tool.
- Introduce .hollow extension.
