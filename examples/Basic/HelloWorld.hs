{-
   HelloWorld.hs (adapted from hello_world.c in freealut)
   Copyright (c) Sven Panne 2005-2013
   This file is part of the ALUT package & distributed under a BSD-style license.
   See the file LICENSE.
-}

import Sound.ALUT

-- This is the Haskell version of the 'Hello World' program from the ALUT
-- reference manual.

main :: IO ()
main =
   withProgNameAndArgs runALUT $ \_progName _args -> do
      helloBuffer <- createBuffer HelloWorld
      helloSource <- genObjectName
      buffer helloSource $= Just helloBuffer
      play [helloSource]
      sleep 1
