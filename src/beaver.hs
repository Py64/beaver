import System.Environment
import System.Exit
import System.IO
import Data.List
import System.Posix.User
import System.Process
main = do
        continueIfRoot
        args <- getArgs
        if (length args) == 0
        then usage        >> exit
        else parse (args !! 0)

parse "help"       = usage   >> exit
parse "version"    = version >> exit
parse ""           = usage   >> exit
parse "installpkg" = installpkg >> exit

continueIfRoot = do
                  isRoot <- fmap (== 0) getRealUserID
                  if isRoot then return ()
                  else putStrLn "Beaver must be runned as root." >> exit
usage      = do
              putStrLn "Usage: beaver <operation> [...]"
              putStrLn "\thelp\t\t\tdisplays this message"
              putStrLn "\tversion\t\t\tdisplays version"
              putStrLn "\tsync\t\t\tsynchronizes databases"
              putStrLn "\tinstall\t\t\tinstalls package"
              putStrLn "\tlist\t\t\tlists packages from all repositories"
              putStrLn "\tinstallpkg\t\tinstalls local package"
version    = putStrLn "beaver 0.1"
installpkg = do
              args <- getArgs
              pkgname <- (readProcess "beaver-pkgname" [(args !! 1)] "")
              system ("tar xJf " ++ (args !! 1) ++ " -C /tmp/")
              meta <- readFile ("/tmp/" ++ pkgname ++ "/.META")
              -- not implemented
getprop s f = return (readProcess "beaver-parse" [s, f] "")
exit = exitWith ExitSuccess
