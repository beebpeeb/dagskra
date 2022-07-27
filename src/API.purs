module TV.API where

import Prelude

import Affjax.ResponseFormat (json)
import Affjax.Web (get, printError)
import Control.Monad.Error.Class (throwError)
import Data.Argonaut (printJsonDecodeError)
import Data.Either (Either(..), either)
import Effect.Aff (Aff)
import Network.RemoteData (RemoteData)

import TV.Data.Listing (Listings, decodeListings)

type APIResponse = RemoteData String Listings

fetchListings :: Aff APIResponse
fetchListings = do
  response <- get json "https://apis.is/tv/ruv"
  pure case response of
    Left error ->
      throwError (printError error)
    Right { body } ->
      either (throwError <<< printJsonDecodeError) pure (decodeListings body)
