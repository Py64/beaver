{-# LANGUAGE OverloadedStrings #-}
import System.Environment
import System.Exit
import System.IO
import Data.List
import System.Posix.User
import System.Process
import Data.List.Split
import Database.SQLite.Simple
import Control.Monad
import System.Directory
import System.FilePath
import qualified Data.Text as T
import Database.SQLite.Simple.FromRow
import Control.Applicative
main = do
        continueIfRoot
        args <- getArgs
        if (length args) == 0
        then usage        >> exit
        else parse (args !! 0)

parse "help"       = usage   >> exit
parse "version"    = version >> exit
parse ""           = usage   >> exit
parse "install-local" = installpkg >> exit
parse "info-local" = infolocal >> exit
parse "list-installed" = listinstalled >> exit

continueIfRoot = do
                  isRoot <- fmap (== 0) getRealUserID
                  if isRoot then return ()
                  else putStrLn "Beaver must be runned as root." >> exit
usage      = do
              putStrLn "Usage: beaver <operation> [...]"
              putStrLn "\thelp\t\t\tdisplays this message"
              putStrLn "\tversion\t\t\tdisplays version"
              putStrLn "\tsync\t\t\tsynchronizes databases"
              putStrLn "\tinstall <package>\tinstalls package"
              putStrLn "\tlist\t\t\tlists packages from all repositories"
              putStrLn "\tinfo <package>\t\tdisplays informations about package"
              putStrLn "\tinfo-local <file>\tdisplays informations about local package"
              putStrLn "\tinstall-local <file>\tinstalls local package"
              putStrLn "\tlist-installed\t\tlists installed packages"
version    = putStrLn "beaver 0.1"
listinstalled = do
                dbcon <- open "/var/lib/beaver/pkgs.db"
                res <- query_ dbcon "SELECT name,repo,version,revision FROM installed_pkgs"
                when (null res) (putStrLn "No packages installed." >> exit)
                mapM_ printpkgentry (res :: [[String]])
                close dbcon
                exit
printpkgentry r = putStrLn ((r !! 1) ++ " " ++ (r !! 0) ++ " " ++ (r !! 2) ++ "-" ++ (r !! 3))
infolocal  = do
              args <- getArgs
              pkgname <- readProcess "beaver-pkgname" [(args !! 1)] ""
              extractpkg pkgname
              architecture <- metaprop "arch" pkgname
              version <- metaprop "version" pkgname
              revision <- metaprop "revision" pkgname
              files <- metaprop "files" pkgname
              depends <- metaprop "depends" pkgname
              optionaldepends <- metaprop "optional-depends" pkgname
              conflicts <- metaprop "conflicts" pkgname
              putStrLn ("Name: " ++ pkgname ++ "\nArchitecture: " ++ architecture ++ "\nVersion: " ++ version ++ "\nRevision: " ++ revision ++ "\nDependencies: " ++ depends ++ "\nOptional dependencies: " ++ optionaldepends ++ "\nConflicts: " ++ conflicts ++ "\nFiles: " ++ files)
installpkg = do
              args <- getArgs
              pkgname <- readProcess "beaver-pkgname" [(args !! 1)] ""
              extractpkg pkgname
              files <- metaprop "files" pkgname
              mapM isFileInstalled (splitOn " " files)
              mapM fileExist (splitOn " " files)
fileExist p = do
             res <- doesFileExist p
             if res == True then do
                        putStrLn ("File " ++ p ++ " already exists.") >> exit
             else return ()
isPkgInstalled p = do
                dbcon <- open "/var/lib/beaver/pkgs.db"
                res <- queryNamed dbcon "SELECT * FROM installed_pkgs WHERE name = :name" [":name" := (p :: String)]
                when (null res) (return ())
                let row = ((res :: [[String]]) !! 0)
                putStrLn ("File " ++ (row !! 1) ++ " is already installed and comes from " ++ (row !! 0) ++ ".")
                close dbcon
                exit
isFileInstalled f = do
                dbcon <- open "/var/lib/beaver/pkgs.db"
                res <- queryNamed dbcon "SELECT * FROM files WHERE path = :path" [":path" := (f :: String)]
                when (null res) (return ())
                let row = ((res :: [[String]]) !! 0)
                putStrLn ("File " ++ (row !! 1) ++ " is already installed and comes from " ++ (row !! 0) ++ ".")
                close dbcon
                exit
extractpkg p = do
              args <- getArgs
              system ("mkdir /tmp/" ++ p ++ " && tar xJf " ++ (args !! 1) ++ " -C /tmp/" ++ p)
metaprop s p = do
                r <- getprop s ("/tmp/" ++ p ++ "/.META")
                return (r)
getprop s f = do
               r <- readProcess "beaver-parse" [s, f] ""
               return (r)
exit = exitWith ExitSuccess
