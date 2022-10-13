module TV.UI.Header where

import Prelude

import Data.Maybe (fromMaybe)
import Halogen (ComponentHTML)
import Halogen.HTML as H
import Halogen.HTML.Properties as P
import Halogen.Themes.Bootstrap5 as B
import Network.RemoteData (RemoteData(..))

import TV.UI.Common (State)

render :: ∀ a m. State -> ComponentHTML a () m
render { date, response } =
  H.header [ P.class_ B.my4 ]
    [ H.div [ P.class_ B.container ]
        [ H.div [ P.class_ B.row ]
            [ H.h1 [ P.class_ B.display3 ]
                [ H.text "Dagskrá RÚV" ]
            , H.p [ P.classes [ B.fs5, B.textInfo ] ]
                [ H.text case response of
                    Failure e -> "Eitthvað fór úrskeiðis: " <> e
                    _ -> fromMaybe mempty date
                ]
            ]
        ]
    ]
