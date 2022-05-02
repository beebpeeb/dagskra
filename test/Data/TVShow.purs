module Test.Data.TVShow.Spec (spec) where

import Prelude

import Data.Argonaut (Json)
import Data.Either (isRight)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

import TV.Data.TVShow (decodeTVShows)

foreign import response :: Json

-- | Tests decoding of API response data.
spec :: Spec Unit
spec =
  describe "TVShows" do
    it "can be decoded successfully"
      $ isRight decoded `shouldEqual` true
  where
  decoded = decodeTVShows response
