module TV.API where

import Prelude

import Affjax.ResponseFormat (json)
import Affjax.Web (get, printError)
import Control.Monad.Error.Class (throwError)
import Data.Argonaut (printJsonDecodeError)
import Data.Bifunctor (lmap)
import Data.Either (Either(..))
import Effect.Aff (Aff)
import Network.RemoteData (RemoteData, fromEither)

import TV.Data.Listing (Schedule, decodeSchedule)

type APIError = String

type APIResponse = RemoteData APIError Schedule

fetchListings :: Aff APIResponse
fetchListings = do
  response <- get json "https://apis.is/tv/ruv"
  pure $ fromEither case response of
    Left error -> throwError (printError error)
    Right { body } -> lmap printJsonDecodeError (decodeSchedule body)
