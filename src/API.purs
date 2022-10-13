module TV.API
  ( APIError
  , APIResponse
  , fetchSchedule
  , url
  ) where

import Prelude

import Affjax.ResponseFormat (json)
import Affjax.Web (Response, URL, get, printError)
import Data.Argonaut (Json, printJsonDecodeError)
import Data.Bifunctor (lmap)
import Data.Either (Either)
import Effect.Aff (Aff)
import Network.RemoteData (RemoteData, fromEither)

import TV.Data.Listing (Schedule, decodeSchedule)

type APIError = String

type APIResponse = RemoteData APIError Schedule

fetchSchedule :: Aff APIResponse
fetchSchedule = do
  response <- get json url
  pure $ fromEither $ decodeResponse =<< lmap printError response

decodeResponse :: Response Json -> Either APIError Schedule
decodeResponse { body } = lmap printJsonDecodeError $ decodeSchedule body

url :: URL
url = "https://apis.is/tv/ruv"
