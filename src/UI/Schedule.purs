module TV.UI.Schedule where

import Prelude

import Data.Array.NonEmpty (sort, toArray)
import Halogen (ComponentHTML)
import Halogen.HTML as HH

import TV.Data.Listing (Status(..))
import TV.Data.Listing as Listing
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
              [ HH.text $ Listing.startTimeString t ]
          ]
      , HH.div [ css "col-10" ]
          [ HH.h4 [ css "text-primary text-uppercase" ]
              [ HH.text $ Listing.titleString t ]
          , whenElem (Listing.hasDescription t) \_ ->
              HH.p [ css "text-muted" ]
                [ HH.text $ Listing.descriptionString t ]
          , statusBadge $ Listing.status t
          ]
      ]
