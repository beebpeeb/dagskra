module TV.UI.Schedule where

import Prelude

import Data.Array.NonEmpty (sort, toArray)
import Halogen (ComponentHTML)
import Halogen.HTML as HTML

import TV.Data.TVShow (Status(..))
import TV.Data.TVShow as TVShow
import TV.UI.Common (State, css, empty, success', when')

render :: ∀ action m. State -> ComponentHTML action () m
render { response } =
  HTML.section [ css "container" ]
    [ success' response schedule ]
  where
    schedule = HTML.html_ <<< map tvShow <<< toArray <<< sort

    statusBadge = case _ of
      Live label ->
        HTML.p [ css "badge bg-danger" ]
          [ HTML.text label ]
      Repeat label ->
        HTML.p [ css "badge bg-success" ]
          [ HTML.text label ]
      _ -> empty

    tvShow t =
      HTML.div [ css "row mb-3" ]
        [ HTML.div [ css "col-2" ]
            [ HTML.h4 [ css "text-info" ]
                [ HTML.text $ TVShow.startTimeString t ]
            ]
        , HTML.div [ css "col-10" ]
            [ HTML.h4 [ css "text-primary" ]
                [ HTML.text $ TVShow.titleString t ]
            , when' (TVShow.hasDescription t) \_ ->
                HTML.p [ css "text-muted" ]
                  [ HTML.text $ TVShow.descriptionString t ]
            , statusBadge $ TVShow.status t
            ]
        ]
