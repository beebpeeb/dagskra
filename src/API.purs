module TV.API where

import Prelude

import Affjax.ResponseFormat (json)
import Affjax.Web (URL, get, printError)
import Data.Argonaut (printJsonDecodeError)
import Data.Bifunctor (bimap, lmap)
import Data.List.NonEmpty (sort)
import Effect.Aff (Aff)
import Network.RemoteData (RemoteData, fromEither)

import TV.Data.Listing (Listings, decodeListings)

type APIResponse = RemoteData String Listings

fetchSchedule :: Aff APIResponse
fetchSchedule = get json url >>= decodeResponse >>> fromEither >>> pure
  where
  decodeResponse =
    lmap printError
      >=> _.body
        >>> decodeListings
        >>> bimap printJsonDecodeError sort

url :: URL
url = "https://apis.is/tv/ruv"
