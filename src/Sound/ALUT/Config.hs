{-# LANGUAGE ForeignFunctionInterface, CPP #-}
{-# OPTIONS_HADDOCK hide #-}
--------------------------------------------------------------------------------
-- |
-- Module      :  Sound.ALUT.Config
-- Copyright   :  (c) Sven Panne 2006-2013
-- License     :  BSD3
--
-- Maintainer  :  Sven Panne <svenpanne@gmail.com>
-- Stability   :  stable
-- Portability :  portable
--
-- This purely internal module defines the platform-specific stuff which has
-- been figured out by configure.
--
--------------------------------------------------------------------------------

module Sound.ALUT.Config (
   alut_Init,
   alut_InitWithoutContext,
   alut_Exit,

   alut_GetError,
   alut_GetErrorString,

   alut_CreateBufferFromFile,
   alut_CreateBufferFromFileImage,
   alut_CreateBufferHelloWorld,
   alut_CreateBufferWaveform,

   alut_LoadMemoryFromFile,
   alut_LoadMemoryFromFileImage,
   alut_LoadMemoryHelloWorld,
   alut_LoadMemoryWaveform,

   alut_GetMIMETypes,

   alut_GetMajorVersion,
   alut_GetMinorVersion,

   alut_Sleep
) where

--------------------------------------------------------------------------------

import Foreign.C
import Foreign.Ptr
import Sound.OpenAL.AL.BasicTypes

--------------------------------------------------------------------------------

foreign import CALLCONV unsafe "alutInit"
   alut_Init :: Ptr CInt -> Ptr CString -> IO ALboolean

--------------------------------------------------------------------------------

foreign import CALLCONV unsafe "alutInitWithoutContext"
   alut_InitWithoutContext :: Ptr CInt -> Ptr CString -> IO ALboolean

--------------------------------------------------------------------------------

foreign import CALLCONV unsafe "alutExit"
   alut_Exit :: IO ALboolean

--------------------------------------------------------------------------------

foreign import CALLCONV unsafe "alutGetError"
   alut_GetError :: IO ALenum

--------------------------------------------------------------------------------

alut_GetErrorString :: ALenum -> IO String
alut_GetErrorString e = peekCString =<< alutGetErrorString e

foreign import CALLCONV unsafe "alutGetErrorString"
   alutGetErrorString :: ALenum -> IO CString

--------------------------------------------------------------------------------

foreign import CALLCONV unsafe "alutCreateBufferFromFile"
   alut_CreateBufferFromFile :: CString -> IO ALuint

--------------------------------------------------------------------------------

foreign import CALLCONV unsafe "alutCreateBufferFromFileImage"
   alut_CreateBufferFromFileImage :: Ptr a -> ALsizei -> IO ALuint

--------------------------------------------------------------------------------

foreign import CALLCONV unsafe "alutCreateBufferHelloWorld"
   alut_CreateBufferHelloWorld :: IO ALuint

--------------------------------------------------------------------------------

foreign import CALLCONV unsafe "alutCreateBufferWaveform"
   alut_CreateBufferWaveform :: ALenum
                             -> ALfloat
                             -> ALfloat
                             -> ALfloat
                             -> IO ALuint

--------------------------------------------------------------------------------

foreign import CALLCONV unsafe "alutLoadMemoryFromFile"
   alut_LoadMemoryFromFile :: CString
                           -> Ptr ALenum
                           -> Ptr ALsizei
                           -> Ptr ALfloat
                           -> IO (Ptr b)

--------------------------------------------------------------------------------

foreign import CALLCONV unsafe "alutLoadMemoryFromFileImage"
   alut_LoadMemoryFromFileImage :: Ptr a
                                -> ALsizei
                                -> Ptr ALenum
                                -> Ptr ALsizei
                                -> Ptr ALfloat
                                -> IO (Ptr b)

--------------------------------------------------------------------------------

foreign import CALLCONV unsafe "alutLoadMemoryHelloWorld"
   alut_LoadMemoryHelloWorld :: Ptr ALenum
                             -> Ptr ALsizei
                             -> Ptr ALfloat
                             -> IO (Ptr b)

--------------------------------------------------------------------------------

foreign import CALLCONV unsafe "alutLoadMemoryWaveform"
   alut_LoadMemoryWaveform :: ALenum
                           -> ALfloat
                           -> ALfloat
                           -> ALfloat
                           -> Ptr ALenum
                           -> Ptr ALsizei
                           -> Ptr ALfloat
                           -> IO (Ptr b)

--------------------------------------------------------------------------------

foreign import CALLCONV unsafe "alutGetMIMETypes"
   alut_GetMIMETypes :: ALenum -> IO CString

--------------------------------------------------------------------------------

foreign import CALLCONV unsafe "alutGetMajorVersion"
   alut_GetMajorVersion :: IO ALint

--------------------------------------------------------------------------------

foreign import CALLCONV unsafe "alutGetMinorVersion"
   alut_GetMinorVersion :: IO ALint

--------------------------------------------------------------------------------

foreign import CALLCONV unsafe "alutSleep"
   alut_Sleep :: ALfloat -> IO ALboolean
