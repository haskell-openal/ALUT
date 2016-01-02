{-# OPTIONS_HADDOCK hide #-}
--------------------------------------------------------------------------------
-- |
-- Module      :  Sound.ALUT.Constants
-- Copyright   :  (c) Sven Panne 2005-2016
-- License     :  BSD3
--
-- Maintainer  :  Sven Panne <svenpanne@gmail.com>
-- Stability   :  stable
-- Portability :  portable
--
--------------------------------------------------------------------------------

module Sound.ALUT.Constants where

import Sound.OpenAL.AL.BasicTypes ( ALint, ALenum )

--------------------------------------------------------------------------------

alut_API_MAJOR_VERSION, alut_API_MINOR_VERSION :: ALint
alut_API_MAJOR_VERSION               = 1
alut_API_MINOR_VERSION               = 1

--------------------------------------------------------------------------------

alut_WAVEFORM_SINE, alut_WAVEFORM_SQUARE, alut_WAVEFORM_SAWTOOTH,
   alut_WAVEFORM_IMPULSE, alut_WAVEFORM_WHITENOISE :: ALenum
alut_WAVEFORM_SINE                   = 0x100
alut_WAVEFORM_SQUARE                 = 0x101
alut_WAVEFORM_SAWTOOTH               = 0x102
alut_WAVEFORM_WHITENOISE             = 0x103
alut_WAVEFORM_IMPULSE                = 0x104

--------------------------------------------------------------------------------

alut_LOADER_BUFFER, alut_LOADER_MEMORY :: ALenum
alut_LOADER_BUFFER                   = 0x300
alut_LOADER_MEMORY                   = 0x301
