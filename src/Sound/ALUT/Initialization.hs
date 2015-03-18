--------------------------------------------------------------------------------
-- |
-- Module      :  Sound.ALUT.Initialization
-- Copyright   :  (c) Sven Panne 2005-2015
-- License     :  BSD3
--
-- Maintainer  :  Sven Panne <svenpanne@gmail.com>
-- Stability   :  stable
-- Portability :  portable
--
--------------------------------------------------------------------------------

module Sound.ALUT.Initialization (
   ArgumentConsumer, Runner, runALUT, runALUTUsingCurrentContext,
   withProgNameAndArgs
)  where

import Control.Exception ( finally )
import Control.Monad.IO.Class ( MonadIO(..) )
import Data.List ( genericLength )
import Foreign.C.String ( CString, withCString, peekCString )
import Foreign.C.Types ( CInt )
import Foreign.Marshal.Array ( withArray0, peekArray )
import Foreign.Marshal.Utils ( with, withMany )
import Foreign.Ptr ( Ptr, nullPtr )
import Foreign.Storable ( Storable(peek) )
import Sound.OpenAL.AL.BasicTypes ( ALboolean )
import Sound.OpenAL.AL.Extensions ( unmarshalALboolean )
import System.Environment ( getProgName, getArgs )

import Sound.ALUT.Config
import Sound.ALUT.Errors

--------------------------------------------------------------------------------

type ArgumentConsumer a = String -> [String] -> a

type Runner m a = ArgumentConsumer (m a) -> m a

--------------------------------------------------------------------------------

runALUT :: MonadIO m => ArgumentConsumer (Runner m a)
runALUT = runner "runALUT" alut_Init

--------------------------------------------------------------------------------

runALUTUsingCurrentContext :: MonadIO m => ArgumentConsumer (Runner m a)
runALUTUsingCurrentContext =
   runner "runALUTUsingCurrentContext" alut_InitWithoutContext

--------------------------------------------------------------------------------

runner :: MonadIO m => String -> (Ptr CInt -> Ptr CString -> IO ALboolean) -> String
       -> [String] -> Runner m a
runner name initAction progName args action = do
   argv <- liftIO $ foo name initAction progName args
   result <- action (head argv) (tail argv)
   liftIO $ throwIfALfalse name alut_Exit
   return result

foo :: String -> (Ptr CInt -> Ptr CString -> IO ALboolean) -> String -> [String] -> IO [String]
foo name initAction progName args =
   with (1 + genericLength args) $ \argcBuf ->
      withMany withCString (progName : args) $ \argvPtrs ->
         withArray0 nullPtr argvPtrs $ \argvBuf -> do
            throwIfALfalse name $ initAction argcBuf argvBuf
            newArgc <- peek argcBuf
            newArgvPtrs <- peekArray (fromIntegral newArgc) argvBuf
            mapM peekCString newArgvPtrs

--------------------------------------------------------------------------------

withProgNameAndArgs :: MonadIO m => (ArgumentConsumer (Runner m a)) -> Runner m a
withProgNameAndArgs alutRunner action = do
   n <- liftIO getProgName
   a <- liftIO getArgs
   alutRunner n a action
