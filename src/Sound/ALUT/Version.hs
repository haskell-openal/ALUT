--------------------------------------------------------------------------------
-- |
-- Module      :  Sound.ALUT.Version
-- Copyright   :  (c) Sven Panne 2005-2015
-- License     :  BSD3
--
-- Maintainer  :  Sven Panne <svenpanne@gmail.com>
-- Stability   :  stable
-- Portability :  portable
--
--------------------------------------------------------------------------------

module Sound.ALUT.Version (
   alutAPIVersion, alutVersion
)  where

import Control.Monad ( liftM2 )
import Data.StateVar ( GettableStateVar, makeGettableStateVar )
import Sound.OpenAL.AL.BasicTypes ( ALint )

import Sound.ALUT.Config
import Sound.ALUT.Constants

--------------------------------------------------------------------------------

alutAPIVersion :: String
alutAPIVersion = makeVersionString alut_API_MAJOR_VERSION alut_API_MINOR_VERSION

makeVersionString :: ALint -> ALint -> String
makeVersionString major minor = show major ++ "." ++ show minor

--------------------------------------------------------------------------------

alutVersion :: GettableStateVar String
alutVersion =
   makeGettableStateVar $
      liftM2 makeVersionString alut_GetMajorVersion alut_GetMinorVersion
