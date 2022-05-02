module TV.UI.Component.Header where

import Prelude

import Data.Maybe (fromMaybe)
import Halogen (ComponentHTML)
import Halogen.HTML as HTML
import Network.RemoteData (RemoteData(..))

import TV.UI.Component.Common (State, css)

render :: ∀ action m. State -> ComponentHTML action () m
render state =
  HTML.header [ css "my-4" ]
    [ HTML.div [ css "container" ]
        [ HTML.div [ css "row" ]
            [ titleCol state
            , messageCol state
            ]
        ]
    ]
  where
  messageCol { date, response } =
    HTML.div [ css "col-6" ]
      [ HTML.p [ css "text-end text-info" ]
          [ HTML.text $ case response of
              Loading -> "Hleð..."
              Failure e -> "Eitthvað fór úrskeiðis! " <> e
              Success _ -> fromMaybe mempty date
              _ -> mempty
          ]
      ]

  statusEmoji =
    case _ of
      NotAsked -> "🥱"
      Loading -> "🤞"
      Failure _ -> "😱"
      Success _ -> "😃"

  titleCol { response } =
    HTML.div [ css "col-6" ]
      [ HTML.h1 [ css "display-5" ]
          [ HTML.text "Dagskrá RÚV" ]
      , HTML.p [ css "display-5" ]
          [ HTML.text $ statusEmoji response ]
      ]
