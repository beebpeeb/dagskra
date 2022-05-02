module Test.Data.Description.Spec (spec) where

import Prelude

import Data.String.Gen (genAlphaString)
import Test.QuickCheck ((===))
import Test.QuickCheck.Gen (Gen)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.QuickCheck (quickCheck)

import TV.Data.Description (fromString, isEmpty, isRepeat, toString)

arbitraryString :: Gen String
arbitraryString = genAlphaString

-- | Tests the properties of functions in `TV.Data.Description`
spec :: Spec Unit
spec =
  describe "Description" do
    it "has expected text"
      $ quickCheck do
          s <- arbitraryString
          pure $ toString (fromString s) === s
    it "represents a repeat broadcast"
      $ quickCheck do
          s <- arbitraryString <#> flip append ". e."
          pure $ isRepeat (fromString s) === true
    it "is empty"
      $ isEmpty (fromString "  ") `shouldEqual` true
