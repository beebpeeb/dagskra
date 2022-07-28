module Test.Data.Listing.Spec (spec) where

import Prelude

import Data.Argonaut (Json)
import Data.Either (isRight)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

import TV.Data.Listing (decodeListings)

foreign import response :: Json

-- | Tests decoding of API response data.
spec :: Spec Unit
spec =
  describe "Listings" do
    it "can be decoded successfully"
      $ isRight decoded `shouldEqual` true
  where
  decoded = decodeListings response
