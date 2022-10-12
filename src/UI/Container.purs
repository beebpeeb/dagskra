module TV.UI.Container where

import Prelude

import Data.Maybe (Maybe(..))
import Effect.Aff.Class (class MonadAff, liftAff)
import Halogen (Component, defaultEval, mkComponent, mkEval, modify_)
import Halogen.HTML as H
import Network.RemoteData (RemoteData(..), toMaybe)

import TV.API (fetchSchedule)
import TV.Data.Listing as Listing
import TV.UI.Common (Action(..))
import TV.UI.Header as Header
import TV.UI.Schedule as Schedule

component :: ∀ q i o m. MonadAff m => Component q i o m
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
  handleAction FetchSchedule = do
    response <- liftAff fetchSchedule
    let date = Listing.scheduleDate <$> toMaybe response
    modify_ _ { date = date, response = response }

  initialState _ = { date: Nothing, response: Loading }

  initialize = Just FetchSchedule

  render = H.html_ <<< flap [ Header.render, Schedule.render ]
