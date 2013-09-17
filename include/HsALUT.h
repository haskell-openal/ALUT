/* include/HsALUT.h.  Generated from HsALUT.h.in by configure.  */
/* -----------------------------------------------------------------------------
 *
 * Module      :  C support for Sound.ALUT
 * Copyright   :  (c) Sven Panne 2005-2009
 * License     :  BSD-style (see the file libraries/ALUT/LICENSE)
 * 
 * Maintainer  :  sven.panne@aedion.de
 * Stability   :  provisional
 * Portability :  portable
 *
 * -------------------------------------------------------------------------- */

#ifndef HSALUT_H
#define HSALUT_H

/* Define to 1 if you have the <AL/alut.h> header file. */
#define HAVE_AL_ALUT_H 1

/* Define to 1 if you have the <OpenAL/alut.h> header file. */
/* #undef HAVE_OPENAL_ALUT_H */

#if HAVE_AL_ALUT_H
#include <AL/alut.h>
#elif HAVE_OPENAL_ALUT_H
#include <OpenAL/alut.h>
#endif

#endif
