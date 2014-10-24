--------------------------------------------------------------------------------
-- |
-- Module      :  Sound.ALUT.Sleep
-- Copyright   :  (c) Sven Panne 2005-2013
-- License     :  BSD3
--
-- Maintainer  :  Sven Panne <svenpanne@gmail.com>
-- Stability   :  stable
-- Portability :  portable
--
--------------------------------------------------------------------------------

module Sound.ALUT.Sleep (
   sleep
)  where

import Sound.ALUT.Config ( alut_Sleep )
import Sound.ALUT.Errors ( throwIfALfalse )
import Sound.ALUT.Loaders ( Duration )

--------------------------------------------------------------------------------

sleep :: Duration -> IO ()
sleep = throwIfALfalse "sleep" . alut_Sleep . realToFrac
