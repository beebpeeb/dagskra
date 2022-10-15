module TV.API where

import Prelude

import Affjax.ResponseFormat (json)
import Affjax.Web (get, printError)
import Data.Argonaut (printJsonDecodeError)
import Data.Bifunctor (lmap)
import Effect.Aff (Aff)
import Network.RemoteData (RemoteData, fromEither)

import TV.Data.Listing (Schedule, decodeSchedule)

type APIResponse = RemoteData String Schedule

fetchSchedule :: Aff APIResponse
fetchSchedule = do
  res <- get json "https://apis.is/tv/ruv"
  pure $ fromEither $ decode =<< lmap printError res
  where
  decode { body } = lmap printJsonDecodeError $ decodeSchedule body
