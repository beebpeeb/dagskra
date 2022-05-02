module TV.UI.Component.Schedule where

import Prelude

import Data.Array.NonEmpty as NEA
import Halogen (ComponentHTML)
import Halogen.HTML as HTML
import Network.RemoteData (RemoteData(..))

import TV.Data.TVShow (Status(..))
import TV.Data.TVShow as TVShow
import TV.UI.Component.Common (State, css, empty, renderWhen)

render :: ∀ action m. State -> ComponentHTML action () m
render state =
  HTML.section [ css "container" ]
    [ case state.response of
        Success shows -> renderSchedule shows
        Loading -> HTML.div [ css "spinner-border text-muted " ] []
        _ -> empty
    ]
  where
  renderSchedule = HTML.html_ <<< map renderTVShow <<< NEA.toArray <<< NEA.sort

  renderStatusBadge =
    case _ of
      Standard -> empty
      Live ->
        HTML.p [ css "badge bg-danger" ]
          [ HTML.text "bein útsending" ]
      Repeat ->
        HTML.p [ css "badge bg-success" ]
          [ HTML.text "endurtekinn" ]

  renderTVShow t =
    HTML.div [ css "row mb-3" ]
      [ HTML.div [ css "col-2" ]
          [ HTML.h3 [ css "text-info" ]
              [ HTML.text $ TVShow.startTimeString t ]
          ]
      , HTML.div [ css "col-10" ]
          [ HTML.h3 [ css "text-primary" ]
              [ HTML.text $ TVShow.titleString t ]
          , renderWhen (TVShow.hasDescription t) \_ ->
              HTML.p [ css "text-muted" ]
                [ HTML.text $ TVShow.descriptionString t ]
          , renderStatusBadge $ TVShow.status t
          ]
      ]
