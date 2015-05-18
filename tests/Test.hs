import Data.Time
import Data.Time.Clock.AnnouncedLeapSeconds
import Test.QuickCheck

onceCheck = quickCheckWith (stdArgs {maxSuccess = 1})

-- A few trivial tests.
main = do
  onceCheck $ lst (fromGregorian 1111 12 31) ==  0  -- Before first leap second.
  onceCheck $ lst (fromGregorian 2008 12 31) == 33
  onceCheck $ lst (fromGregorian 2009 01 01) == 34
  onceCheck $ lst (fromGregorian 2009 12 31) == 34
  onceCheck $ lst (fromGregorian 2012 06 30) == 34  -- Prior to last leap second.
  onceCheck $ lst (fromGregorian 2012 07 01) == 35  -- Last leap second.
  onceCheck $ lst (fromGregorian 2012 12 31) == 35  -- Beyond last leap second.

