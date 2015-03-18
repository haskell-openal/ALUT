--------------------------------------------------------------------------------
-- |
-- Module      :  Sound.ALUT.Sleep
-- Copyright   :  (c) Sven Panne 2005-2015
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

import Control.Monad.IO.Class ( MonadIO(..) )

import Sound.ALUT.Config
import Sound.ALUT.Errors
import Sound.ALUT.Loaders

--------------------------------------------------------------------------------

sleep :: MonadIO m => Duration -> m ()
sleep = liftIO . throwIfALfalse "sleep" . alut_Sleep . realToFrac
