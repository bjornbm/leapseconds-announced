-- This file was automatically generated.

{- |
   Copyright  : Copyright (C) 2009 Bjorn Buckwalter
   License    : BSD3

   Maintainer : bjorn.buckwalter@gmail.com
   Stability  : stable
   Portability: full

Provides a static 'Data.Time.Clock.TAI.LeapSecondTable' \"containing\"
the leap seconds announced at library release time. This version
will become invalidated when/if the International Earth Rotation
and Reference Systems Service (IERS) announces a new leap second at
<http://hpiers.obspm.fr/eoppc/bul/bulc/bulletinc.dat>.
At that time a new version of the library will be released, against
which any code wishing to remain up to date should be recompiled.

This module is intended to provide a quick-and-dirty leap second solution
for one-off analyses concerned only with the past and present (i.e. up
until the next as of yet unannounced leap second), or for applications
which can afford to be recompiled against an updated library as often
as every six months.
-}

module Data.Time.Clock.AnnouncedLeapSeconds (lst) where

import Data.Time (Day, fromGregorian)
import Data.Time.Clock.TAI (LeapSecondTable)

leapSeconds :: [(Day, Integer)]
leapSeconds = (fromGregorian 2009 01 01, 34)
  : (fromGregorian 2006 01 01, 33)
  : (fromGregorian 1999 01 01, 32)
  : (fromGregorian 1997 07 01, 31)
  : (fromGregorian 1996 01 01, 30)
  : (fromGregorian 1994 07 01, 29)
  : (fromGregorian 1993 07 01, 28)
  : (fromGregorian 1992 07 01, 27)
  : (fromGregorian 1991 01 01, 26)
  : (fromGregorian 1990 01 01, 25)
  : (fromGregorian 1988 01 01, 24)
  : (fromGregorian 1985 07 01, 23)
  : (fromGregorian 1983 07 01, 22)
  : (fromGregorian 1982 07 01, 21)
  : (fromGregorian 1981 07 01, 20)
  : (fromGregorian 1980 01 01, 19)
  : (fromGregorian 1979 01 01, 18)
  : (fromGregorian 1978 01 01, 17)
  : (fromGregorian 1977 01 01, 16)
  : (fromGregorian 1976 01 01, 15)
  : (fromGregorian 1975 01 01, 14)
  : (fromGregorian 1974 01 01, 13)
  : (fromGregorian 1973 01 01, 12)
  : (fromGregorian 1972 07 01, 11)
  : (fromGregorian 1972 01 01, 10)
  : (fromGregorian 1966 01 01, 4)
  : (fromGregorian 1964 01 01, 3)
  : (fromGregorian 1962 01 01, 1)
  : []

-- | 'Data.Time.Clock.TAI.LeapSecondTable' containing all leap seconds
-- up to 2009-01-01.
lst :: LeapSecondTable
lst d = snd $ headDef (undefined,0) $ dropWhile ((>d).fst) leapSeconds
  where headDef def xs = if null xs then def else head xs  -- Inspired by Safe.

