{-
   TestErrorStuff.hs (adapted from test_errorstuff.c in freealut)
   Copyright (c) Sven Panne 2005-2016
   This file is part of the ALUT package & distributed under a BSD-style license.
   See the file LICENSE.
-}

import Control.Exception ( onException )
import Control.Monad ( void )
import Sound.ALUT
import System.Exit ( exitFailure, exitWith, ExitCode(ExitSuccess) )
import System.IO ( hPutStrLn, stderr )

-- This is a minimal test for error handling.

main :: IO ()
main = do
   void $ withProgNameAndArgs runALUT $ \_progName _args ->
     createBuffer (File "no_such_file_in_existance.wav")
       `onException` (exitWith ExitSuccess)
   hPutStrLn stderr "expected an I/O error"
   exitFailure
