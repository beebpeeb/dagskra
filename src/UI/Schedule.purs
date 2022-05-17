module TV.UI.Schedule where

import Prelude

import Data.Array.NonEmpty (sort, toArray)
import Halogen (ComponentHTML)
import Halogen.HTML as HH

import TV.Data.TVShow (Status(..))
import TV.Data.TVShow as TVShow
import TV.UI.Common (State, css, empty, whenElem, withSpinner)

render :: ∀ action m. State -> ComponentHTML action () m
render { response } =
  HH.section [ css "container" ]
    [ withSpinner response schedule ]
  where
  schedule = HH.html_ <<< map tvShow <<< toArray <<< sort

  statusBadge = case _ of
    Live label ->
      HH.p [ css "badge bg-danger" ]
        [ HH.text label ]
    Repeat label ->
      HH.p [ css "badge bg-success" ]
        [ HH.text label ]
    _ -> empty

  tvShow t =
    HH.div [ css "row mb-3" ]
      [ HH.div [ css "col-2" ]
          [ HH.h4 [ css "text-info" ]
              [ HH.text $ TVShow.startTimeString t ]
          ]
      , HH.div [ css "col-10" ]
          [ HH.h4 [ css "text-primary" ]
              [ HH.text $ TVShow.titleString t ]
          , whenElem (TVShow.hasDescription t) \_ ->
              HH.p [ css "text-muted" ]
                [ HH.text $ TVShow.descriptionString t ]
          , statusBadge $ TVShow.status t
          ]
      ]
