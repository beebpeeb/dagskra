module TV.API where

import Prelude

import Affjax.ResponseFormat (json)
import Affjax.Web (get, printError)
import Control.Monad.Error.Class (throwError)
import Data.Argonaut (printJsonDecodeError)
import Data.Either (Either(..), either)
import Effect.Aff (Aff)
import Network.RemoteData (RemoteData)

import TV.Data.TVShow (TVShows, decodeTVShows)

type APIResponse = RemoteData String TVShows

-- | Fetch a schedule of TV shows from the remote API.
-- |
-- | This function demonstrates how potentially unsuccessful, side-effecting
-- | computations can be expressed safely by the type system.
-- |
-- | The return type is a union type (`RemoteData`) which encodes four possible
-- | states for a remote data fetch, capturing `Success a` or `Failure e` where
-- | `a` and `e` are "open" (universally quantified) types representing any
-- | possible result, successful or otherwise. In our case, the open type `a`
-- | is reified as `TVShows` and `e` as an error message string.
-- |
-- | By pattern matching on this result type, calling code is forced to handle
-- | all possible outcomes and the totality of the computation can be proved
-- | to the compiler.
-- |
-- | Observe that the Halogen UI code makes extensive use of this result type
-- | in order to represent the runtime state of the application. For example:
-- |
-- |   ```
-- |   case response of
-- |     Success tvShows -> render tvShows
-- |     Failure e -> renderErrorMessage e
-- |   ```
-- |
-- | Here we are taking advantage of the fact that `RemoteData` has both
-- | `Applicative` and `MonadThrow` type class instances (via the `pure`
-- | and `throwError` functions respectively) to construct a result that has
-- | been safely "lifted" into the pure, monadic context of `RemoteData`.
-- |
-- | This is a good motivating example of how PureScript forces you to always
-- | consider the "unhappy path". There is no way to achieve an AJAX fetch
-- | and "hope for the best".
-- |
-- | The function then returns either `Success TVShows` or `Failure String`.
-- | The string constructed by `Failure` will be either an HTTP error or a
-- | JSON decode error.
-- |
-- | In this sense, `RemoteData` is then also a `Bifunctor` i.e. both "sides"
-- | of the result type are `Functor`s.
-- |
-- | This result is then lifted into the `Aff` (asynchronous effect) context.
-- | This small function then expresses, in totality, all outcomes of an
-- | asynchronous data fetch and can be reasonably proved to do so.
fetchTVShows :: Aff APIResponse
fetchTVShows = do
  response <- get json "https://apis.is/tv/ruv"
  pure case response of
    Left error ->
      throwError (printError error)
    Right { body } ->
      either (throwError <<< printJsonDecodeError) pure (decodeTVShows body)
