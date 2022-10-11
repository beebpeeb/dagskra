module TV.UI.Schedule where

import Prelude

import Data.Array (fromFoldable)
import Halogen (ComponentHTML)
import Halogen.HTML as H

import TV.Data.Listing (Status(..))
import TV.Data.Listing as Listing
import TV.UI.Common (State, css, empty, whenElem, withSpinner)

render :: ∀ a m. State -> ComponentHTML a () m
render { response } =
  H.section [ css "container" ]
    [ withSpinner response schedule ]
  where
  schedule = H.html_ <<< map listing <<< fromFoldable

  listing l =
    H.div [ css "row mb-3" ]
      [ H.div [ css "col-2" ]
          [ H.h4 [ css "text-info" ]
              [ H.text $ Listing.startTimeString l ]
          ]
      , H.div [ css "col-10" ]
          [ H.h4 [ css "text-primary text-uppercase" ]
              [ H.text $ Listing.titleString l ]
          , whenElem (Listing.hasDescription l) \_ ->
              H.p [ css "text-muted" ]
                [ H.text $ Listing.descriptionString l ]
          , statusBadge $ Listing.status l
          ]
      ]

  statusBadge = case _ of
    Live ->
      H.p [ css "badge bg-danger" ]
        [ H.text "bein útsending" ]
    Repeat ->
      H.p [ css "badge bg-success" ]
        [ H.text "endurtekinn" ]
    _ -> empty
