# Beaver
Package manager written in Haskell.

# Requirements
- haskell-split
- haskell-missingh

# Building
```
mkdir out src/.o src/.hi
cd out
ghc --make ../src/chameleon.hs -o ./chameleon -odir ../src/.o -hidir ../src/.hi
ghc --make ../src/beaver.hs -o ./beaver -odir ../src/.o -hidir ../src/.hi
g++ ../src/beaver-config.cpp -o ./beaver-config
```
