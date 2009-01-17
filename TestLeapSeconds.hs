import Data.Time
import Data.Time.Clock.AnnouncedLeapSeconds
import Test.QuickCheck

onceCheck = check (defaultConfig {configMaxTest = 1})

-- A few trivial tests.
main = do
  onceCheck $ lst (fromGregorian 1111 12 31) ==  0  -- Before first leap second.
  onceCheck $ lst (fromGregorian 2008 12 31) == 33  -- Prior to last leap second.
  onceCheck $ lst (fromGregorian 2009 01 01) == 34  -- Last leap second.
  onceCheck $ lst (fromGregorian 2009 12 31) == 34  -- Beyond last leap second.

