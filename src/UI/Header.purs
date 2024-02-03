module TV.UI.Header where

import Prelude

import Halogen (ComponentHTML)
import Halogen.HTML as H
import Halogen.HTML.Properties as P
import Halogen.Themes.Bootstrap5 as B
import Network.RemoteData (RemoteData(..), maybe)

import TV.Data.Listing (scheduleDate)
import TV.UI.Common (State)

render :: forall a m. State -> ComponentHTML a () m
render { response } =
  H.header [ P.class_ B.my4 ]
    [ H.div [ P.class_ B.container ]
        [ H.div [ P.class_ B.row ]
            [ H.h1 [ P.class_ B.display3 ]
                [ H.text "Dagskrá RÚV" ]
            , H.h4 [ P.classes [ B.fs5, B.textInfo ] ]
                [ H.text case response of
                    Failure msg -> "Eitthvað fór úrskeiðis: " <> msg
                    Success _ -> maybe mempty scheduleDate response
                    _ -> "..."
                ]
            ]
        ]
    ]
