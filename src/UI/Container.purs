module TV.UI.Container where

import Prelude

import Data.Maybe (Maybe(..))
import Effect.Aff.Class (class MonadAff)
import Halogen (Component)
import Halogen as Halogen
import Halogen.HTML as HTML
import Network.RemoteData (RemoteData(..))
import Network.RemoteData as RD

import TV.API (fetchTVShows)
import TV.Data.TVShow as TVShow
import TV.UI.Common (Action(..))
import TV.UI.Header as Header
import TV.UI.Schedule as Schedule

component :: ∀ q i o m. MonadAff m => Component q i o m
component =
  Halogen.mkComponent
    { initialState
    , render
    , eval:
        Halogen.mkEval
          $ Halogen.defaultEval
              { handleAction = handleAction
              , initialize = initialize
              }
    }
  where
    handleAction FetchSchedule = do
      response <- Halogen.liftAff fetchTVShows
      let date = TVShow.scheduleDate <$> RD.toMaybe response
      Halogen.modify_ _ { date = date, response = response }

    initialState _ = { date: Nothing, response: Loading }

    initialize = Just FetchSchedule

    render = HTML.html_ <<< flap [ Header.render, Schedule.render ]
