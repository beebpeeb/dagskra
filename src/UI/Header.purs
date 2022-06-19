module TV.UI.Header where

import Prelude

import Data.Maybe (fromMaybe)
import Halogen (ComponentHTML)
import Halogen.HTML as HH
import Network.RemoteData (RemoteData(..))

import TV.UI.Common (State, css)

render :: ∀ action m. State -> ComponentHTML action () m
render state =
  HH.header [ css "my-4" ]
    [ HH.div [ css "container" ]
        [ HH.div [ css "row" ] $ [ titleCol, messageCol ] <@> state ]
    ]
  where
  messageCol { date, response } =
    HH.div [ css "col-6" ]
      [ HH.p [ css "text-end text-info" ]
          [ HH.text case response of
              Loading -> "Hleð..."
              Failure e -> "Eitthvað fór úrskeiðis: " <> e
              Success _ -> fromMaybe mempty date
              _ -> mempty
          ]
      ]

  statusEmoji = case _ of
    NotAsked -> "🥱"
    Loading -> "🤞"
    Failure _ -> "😱"
    Success _ -> "😃"

  titleCol { response } =
    HH.div [ css "col-6" ]
      [ HH.h1 [ css "display-5 text-uppercase" ]
          [ HH.text "Dagskrá RÚV" ]
      , HH.h2_ [ HH.text $ statusEmoji response ]
      ]
