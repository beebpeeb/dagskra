module TV.UI.Component.Schedule where

import Prelude

import Data.Array.NonEmpty (sort, toArray)
import Halogen (ComponentHTML)
import Halogen.HTML as HTML

import TV.Data.TVShow (Status(..))
import TV.Data.TVShow as TVShow
import TV.UI.Component.Common (State, css, empty, renderSpinner, renderWhen)

render :: ∀ action m. State -> ComponentHTML action () m
render state =
  HTML.section [ css "container" ]
    [ renderSpinner state.response renderSchedule ]
  where
  renderSchedule = HTML.html_ <<< map renderTVShow <<< toArray <<< sort

  renderStatusBadge = case _ of
    Live label ->
      HTML.p [ css "badge bg-danger" ]
        [ HTML.text label ]
    Repeat label ->
      HTML.p [ css "badge bg-success" ]
        [ HTML.text label ]
    _ -> empty

  renderTVShow t =
    HTML.div [ css "row mb-3" ]
      [ HTML.div [ css "col-2" ]
          [ HTML.h4 [ css "text-info" ]
              [ HTML.text $ TVShow.startTimeString t ]
          ]
      , HTML.div [ css "col-10" ]
          [ HTML.h4 [ css "text-primary" ]
              [ HTML.text $ TVShow.titleString t ]
          , renderWhen (TVShow.hasDescription t) \_ ->
              HTML.p [ css "text-muted" ]
                [ HTML.text $ TVShow.descriptionString t ]
          , renderStatusBadge $ TVShow.status t
          ]
      ]
