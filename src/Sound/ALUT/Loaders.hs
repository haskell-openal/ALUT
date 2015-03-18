--------------------------------------------------------------------------------
-- |
-- Module      :  Sound.ALUT.Loaders
-- Copyright   :  (c) Sven Panne 2005-2015
-- License     :  BSD3
--
-- Maintainer  :  Sven Panne <svenpanne@gmail.com>
-- Stability   :  stable
-- Portability :  portable
--
--------------------------------------------------------------------------------

module Sound.ALUT.Loaders (
   Phase, Duration, SoundDataSource(..),
   createBuffer, createBufferData,
   bufferMIMETypes, bufferDataMIMETypes
)  where

import Control.Monad.IO.Class ( MonadIO(..) )
import Data.StateVar ( GettableStateVar, makeGettableStateVar )
import Foreign.C.String ( peekCString, withCString )
import Foreign.Marshal.Alloc ( alloca )
import Foreign.Ptr ( Ptr )
import Foreign.Storable ( peek )
import Sound.OpenAL.AL.BasicTypes
import Sound.OpenAL.AL.Buffer ( Buffer, MemoryRegion(..), BufferData(..) )
import Sound.OpenAL.AL.Extensions ( unmarshalFormat )
import Sound.OpenAL.ALC.Context ( Frequency )

import Sound.ALUT.Config
import Sound.ALUT.Constants
import Sound.ALUT.Errors

--------------------------------------------------------------------------------

type Phase = Float

type Duration = Float

data SoundDataSource a =
     File FilePath
   | FileImage (MemoryRegion a)
   | HelloWorld
   | Sine Frequency Phase Duration
   | Square Frequency Phase Duration
   | Sawtooth Frequency Phase Duration
   | Impulse Frequency Phase Duration
   | WhiteNoise Duration
   deriving ( Eq, Ord, Show )

--------------------------------------------------------------------------------

createBuffer :: MonadIO m => SoundDataSource a -> m Buffer
createBuffer src = liftIO $ makeBuffer "createBuffer" $ case src of
   File filePath -> withCString filePath alut_CreateBufferFromFile
   FileImage (MemoryRegion buf size) -> alut_CreateBufferFromFileImage buf size
   HelloWorld -> alut_CreateBufferHelloWorld
   Sine f p d -> createBufferWaveform alut_WAVEFORM_SINE f p d
   Square f p d -> createBufferWaveform alut_WAVEFORM_SQUARE f p d
   Sawtooth f p d -> createBufferWaveform alut_WAVEFORM_SAWTOOTH f p d
   Impulse f p d -> createBufferWaveform alut_WAVEFORM_IMPULSE f p d
   WhiteNoise d -> createBufferWaveform alut_WAVEFORM_WHITENOISE 1 0 d

createBufferWaveform :: ALenum -> Float -> Float -> Float -> IO ALuint
createBufferWaveform w f p d =
   alut_CreateBufferWaveform w (realToFrac f) (realToFrac p) (realToFrac d)

--------------------------------------------------------------------------------

createBufferData :: MonadIO m => SoundDataSource a -> m (BufferData b)
createBufferData src = liftIO $ case src of
   File filePath -> withCString filePath $ \fp -> loadWith (alut_LoadMemoryFromFile fp)
   FileImage (MemoryRegion buf size) -> loadWith (alut_LoadMemoryFromFileImage buf size)
   HelloWorld -> loadWith alut_LoadMemoryHelloWorld
   Sine f p d -> loadWith (loadMemoryWaveform alut_WAVEFORM_SINE f p d)
   Square f p d -> loadWith (loadMemoryWaveform alut_WAVEFORM_SQUARE f p d)
   Sawtooth f p d -> loadWith (loadMemoryWaveform alut_WAVEFORM_SAWTOOTH f p d)
   Impulse f p d -> loadWith (loadMemoryWaveform alut_WAVEFORM_IMPULSE f p d)
   WhiteNoise d -> loadWith (loadMemoryWaveform alut_WAVEFORM_WHITENOISE 1 0 d)

loadMemoryWaveform :: ALenum -> Float -> Float -> Float -> Ptr ALenum -> Ptr ALsizei -> Ptr ALfloat -> IO (Ptr b)
loadMemoryWaveform w f p d =
   alut_LoadMemoryWaveform w (realToFrac f) (realToFrac p) (realToFrac d)

loadWith :: (Ptr ALenum -> Ptr ALsizei -> Ptr ALfloat -> IO (Ptr b)) -> IO (BufferData b)
loadWith loader =
   alloca $ \formatBuf ->
      alloca $ \sizeBuf ->
         alloca $ \frequencyBuf -> do
            buf <- throwIfNullPtr "createBufferData" $
                      loader formatBuf sizeBuf frequencyBuf
            format <- peek formatBuf
            size <- peek sizeBuf
            frequency <- peek frequencyBuf
            return $ BufferData (MemoryRegion buf size) (unmarshalFormat format) (realToFrac frequency)

--------------------------------------------------------------------------------

bufferMIMETypes :: GettableStateVar [String]
bufferMIMETypes = mimeTypes "bufferMIMETypes" alut_LOADER_BUFFER

bufferDataMIMETypes :: GettableStateVar [String]
bufferDataMIMETypes = mimeTypes "bufferDataMIMETypes" alut_LOADER_MEMORY

mimeTypes :: String -> ALenum -> GettableStateVar [String]
mimeTypes name loaderType =
   makeGettableStateVar $ do
      ts <- throwIfNullPtr name $ alut_GetMIMETypes loaderType
      fmap (splitBy (== ',')) $ peekCString ts

splitBy :: (a -> Bool) -> [a] -> [[a]]
splitBy _ [] = []
splitBy p xs = case break p xs of
                (ys, []  ) -> [ys]
                (ys, _:zs) -> ys : splitBy p zs
