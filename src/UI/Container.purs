module TV.UI.Container where

import Prelude

import Data.Maybe (Maybe(..))
import Effect.Aff.Class (class MonadAff)
import Halogen (Component)
import Halogen as H
import Halogen.HTML as HH
import Network.RemoteData (RemoteData(..))
import Network.RemoteData as RD

import TV.API (fetchListings)
import TV.Data.Listing as Listing
import TV.UI.Common (Action(..))
import TV.UI.Header as Header
import TV.UI.Schedule as Schedule

component :: ∀ q i o m. MonadAff m => Component q i o m
component =
  H.mkComponent
    { initialState
    , render
    , eval:
        H.mkEval
          $ H.defaultEval
              { handleAction = handleAction
              , initialize = initialize
              }
    }
  where
  handleAction = case _ of
    FetchSchedule -> do
      response <- H.liftAff fetchListings
      let date = Listing.scheduleDate <$> RD.toMaybe response
      H.modify_ _ { date = date, response = response }

  initialState _ = { date: Nothing, response: Loading }

  initialize = Just FetchSchedule

  render = HH.html_ <<< flap [ Header.render, Schedule.render ]
