module Test.Data.StartTime.Spec where

import Prelude

import Data.Either (isRight)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

import TV.Data.StartTime (fromString, toDateString, toTimeString, toTimestamp)

-- | Tests the properties of functions in `TV.Data.StartTime`
spec :: Spec Unit
spec =
  describe "StartTime" do
    it "can be constructed from a correctly formatted string"
      $ isRight (fromString input) `shouldEqual` true
    it "cannot be constructed from an incorrect string"
      $ isRight (fromString "2021-01 99:99") `shouldEqual` false
    it "can be converted to a date string"
      $ (toDateString <$> fromString input) `shouldEqual` pure "01.01.2021"
    it "can be converted to a time string"
      $ (toTimeString <$> fromString input) `shouldEqual` pure "09:00"
    it "can be converted to a Unix timestamp"
      $ (toTimestamp <$> fromString input) `shouldEqual` pure "1609491600"
    where
    input = "2021-01-01 09:00:00"
