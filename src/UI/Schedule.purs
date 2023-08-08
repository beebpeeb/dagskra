module TV.UI.Schedule where

import Prelude

import Data.Array (fromFoldable)
import Halogen (ComponentHTML)
import Halogen.HTML as H
import Halogen.HTML.Properties as P
import Halogen.Themes.Bootstrap5 as B

import TV.Data.Listing (Status(..))
import TV.Data.Listing as Listing
import TV.UI.Common (State, empty, whenElem, withSpinner)

render :: forall a m. State -> ComponentHTML a () m
render { response } =
  H.section [ P.class_ B.container ]
    [ withSpinner response schedule ]
  where
  listing l =
    H.div [ P.classes [ B.row, B.mb3 ] ]
      [ H.div [ P.class_ B.col2 ]
          [ H.h4 [ P.class_ B.textInfo ]
              [ H.text $ Listing.startTimeString l ]
          ]
      , H.div [ P.class_ B.col10 ]
          [ H.h4 [ P.classes [ B.textPrimary, B.textUppercase ] ]
              [ H.text $ Listing.titleString l ]
          , whenElem (Listing.hasDescription l) \_ ->
              H.p [ P.class_ B.textMuted ]
                [ H.text $ Listing.descriptionString l ]
          , statusBadge $ Listing.status l
          ]
      ]

  schedule = H.html_ <<< map listing <<< fromFoldable

  statusBadge = case _ of
    Live ->
      H.p [ P.classes [ B.badge, B.bgDanger ] ]
        [ H.text "bein útsending" ]
    Repeat ->
      H.p [ P.classes [ B.badge, B.bgSuccess ] ]
        [ H.text "endursýning" ]
    _ -> empty
