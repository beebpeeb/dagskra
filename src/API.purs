module TV.API where

import Prelude

import Affjax.ResponseFormat (json)
import Affjax.Web (URL, get, printError)
import Data.Argonaut (printJsonDecodeError)
import Data.Bifunctor (lmap)
import Effect.Aff (Aff)
import Network.RemoteData (RemoteData, fromEither)

import TV.Data.Listing (Schedule, decodeSchedule)

type APIResponse = RemoteData String Schedule

fetchSchedule :: Aff APIResponse
fetchSchedule = get json url >>= \res -> pure $ fromEither $ parse res
  where
  parse =
    lmap printError
      >=> _.body
        >>> decodeSchedule
        >>> lmap printJsonDecodeError

url :: URL
url = "https://apis.is/tv/ruv"
