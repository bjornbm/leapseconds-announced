{- |
Use this applicaton to generate the 'Data.Time.Clock.AnnouncedLeapSeconds'
module. Compile and pipe an EOP file from Celestrak through the binary,
e.g.:

  curl http://www.celestrak.com/SpaceData/eop19620101.txt | ./MakeLeapSecondTable > Data/Time/Clock/AnnouncedLeapSeconds.hs

-}

import Astro.Celestrak
import Data.List (intercalate)
import Data.Time (Day)
import Data.Time.Format (formatTime)
import System.Locale (defaultTimeLocale)


-- | Converts an 'EOPList' into a minimal list of (day, leapsecond) pairs
-- in reverse chronological order.
eopToLS :: EOPList a -> [(Day, Integer)]
eopToLS = reverse . keepInitial . fmap (fmap deltaAT)

-- | Keeps the first pair with a given snd value while dropping the
-- following pairs with the same snd value.
keepInitial :: Eq a => [(b,a)] -> [(b,a)]
keepInitial (x:xs) = x : keepInitial (dropWhile (sndEq x) xs) where sndEq (_,x) (_,y) = x == y
keepInitial [] = []

{- 
The above and this function are candidates for moving to "Astro.Celestrak":

-- | Converts an 'EOPList' to a light weight 'LeapSecondTable' (its internal
-- data is a short list as opposed to a huge array for the 'LeapSecondTable'
-- provided by "Astro.Celestrak".
eopToLST :: EOPList a -> LeapSecondTable
eopToLST eops d = snd $ headDef (undefined,0) $ dropWhile ((>d).fst) $ eopToLS eops
-}

-- | Convert a day/leapsecond pair into a compilable string.
lsToString :: (Day, Integer) -> String
lsToString (d,s) = formatTime defaultTimeLocale fmt d
  where fmt = "(fromGregorian %Y %m %d, " ++ show s ++ ")"

-- | Shows a list in compilable format using the passed function to display
-- the elements of the list.
showL :: (a -> String) -> [a] -> String
showL showf xs = intercalate "\n  : " (map showf xs) ++ "\n  : []"

-- | Compilable leapsecond module.
showModule :: EOPList a -> String
showModule eops = unlines
  [ "-- This file was automatically generated."
  , ""
  , "{- |"
  , "   Copyright  : Copyright (C) 2009 Bjorn Buckwalter"
  , "   License    : BSD3"
  , ""
  , "   Maintainer : bjorn.buckwalter@gmail.com"
  , "   Stability  : stable"
  , "   Portability: full"
  , ""
  , "Provides a static 'Data.Time.Clock.TAI.LeapSecondTable' \\\"containing\\\""
  , "the leap seconds announced at library release time. This version"
  , "will become invalidated when/if the International Earth Rotation"
  , "and Reference Systems Service (IERS) announces a new leap second at"
  , "<http://hpiers.obspm.fr/eoppc/bul/bulc/bulletinc.dat>."
  , "At that time a new version of the library will be released, against"
  , "which any code wishing to remain up to date should be recompiled."
  , ""
  , "This module is intended to provide a quick-and-dirty leap second solution"
  , "for one-off analyses concerned only with the past and present (i.e. up"
  , "until the next as of yet unannounced leap second), or for applications"
  , "which can afford to be recompiled against an updated library as often"
  , "as every six months."
  , "-}"
  , ""
  , "module Data.Time.Clock.AnnouncedLeapSeconds (lst) where"
  , ""
  , "import Data.Time (Day, fromGregorian)"
  , "import Data.Time.Clock.TAI (LeapSecondTable)"
  , ""
  , "leapSeconds :: [(Day, Integer)]"
  , "leapSeconds = " ++ showL lsToString ls
  , ""
  , "-- | 'Data.Time.Clock.TAI.LeapSecondTable' containing all leap seconds"
  , "-- up to " ++ (show.fst.head) ls ++ "."
  , "lst :: LeapSecondTable"
  , "lst d = snd $ headDef (undefined,0) $ dropWhile ((>d).fst) leapSeconds"
  , "  where headDef def xs = if null xs then def else head xs  -- Inspired by Safe."
  , ""
  ] where ls = eopToLS eops

main = do
  interact (showModule . parseEOPData)



