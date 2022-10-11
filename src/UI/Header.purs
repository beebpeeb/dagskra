module TV.UI.Header where

import Prelude

import Data.Maybe (fromMaybe)
import Halogen (ComponentHTML)
import Halogen.HTML as H
import Network.RemoteData (RemoteData(..))

import TV.UI.Common (State, css)

render :: ∀ a m. State -> ComponentHTML a () m
render { date, response } =
  H.header [ css "my-4" ]
    [ H.div [ css "container" ]
        [ H.div [ css "row" ]
            [ H.h1 [ css "display-3" ]
                [ H.text "Dagskrá RÚV" ]
            , H.p [ css "fs-5 text-info" ]
                [ H.text case response of
                    Failure e -> "Eitthvað fór úrskeiðis: " <> e
                    _ -> fromMaybe mempty date
                ]
            ]
        ]
    ]
