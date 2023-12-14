module TV.UI.Container where

import Prelude

import Data.Maybe (Maybe(..))
import Effect.Aff.Class (class MonadAff, liftAff)
import Halogen (Component, defaultEval, mkComponent, mkEval, modify_)
import Halogen.HTML (html_)
import Network.RemoteData (RemoteData(..))

import TV.API (fetchSchedule)
import TV.UI.Header as Header
import TV.UI.Schedule as Schedule

data Action = FetchSchedule

component :: forall q i o m. MonadAff m => Component q i o m
component =
  mkComponent
    { initialState
    , render
    , eval:
        mkEval
          $ defaultEval
              { handleAction = handleAction
              , initialize = initialize
              }
    }
  where
  handleAction action = case action of
    FetchSchedule -> do
      response <- liftAff fetchSchedule
      modify_ _ { response = response }

  initialState _ = { response: Loading }

  initialize = Just FetchSchedule

  render = html_ <<< flap [ Header.render, Schedule.render ]
