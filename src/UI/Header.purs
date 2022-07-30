module TV.UI.Header where

import Prelude

import Data.Maybe (fromMaybe)
import Halogen (ComponentHTML)
import Halogen.HTML as HH
import Network.RemoteData (RemoteData(..))

import TV.UI.Common (State, css)

render :: ∀ action m. State -> ComponentHTML action () m
render { date, response } =
  HH.header [ css "my-4" ]
    [ HH.div [ css "container" ]
        [ HH.div [ css "row" ]
            [ HH.h1 [ css "display-3" ]
                [ HH.text "Dagskrá RÚV"
                , HH.span [ css "fs-5 text-info" ]
                    [ HH.text case response of
                        Loading -> "Hleð..."
                        Failure e -> "Eitthvað fór úrskeiðis: " <> e
                        Success _ -> fromMaybe mempty date
                        _ -> mempty
                    ]
                ]
            ]
        ]
    ]
