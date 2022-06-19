module Test.Data.Description.Spec (spec) where

import Prelude

import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

import TV.Data.Description (fromString, isEmpty, isRepeat, toString)

-- | Tests the properties of functions in `TV.Data.Description`.
spec :: Spec Unit
spec =
  describe "Description" do
    it "has expected text"
      $ toString (fromString "abcde") `shouldEqual` "abcde"
    it "represents a repeat broadcast"
      $ isRepeat (fromString "abcde. e.") `shouldEqual` true
    it "is empty"
      $ isEmpty (fromString "  ") `shouldEqual` true
