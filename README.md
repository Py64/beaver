# Beaver
Package manager written in Haskell.

# Requirements
- haskell-split
- haskell-missingh

# Building
``` mkdir out
 ghc --make src/chameleon.hs -o out/chameleon -odir src/.o -hidir src/.hi
 ghc --make src/beaver.hs -o out/beaver -odir src/.o -hidir src/.hi
