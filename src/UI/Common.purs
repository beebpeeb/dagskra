module TV.UI.Common where

import Prelude

import Halogen.HTML (HTML)
import Halogen.HTML as H
import Halogen.HTML.Properties as P
import Halogen.Themes.Bootstrap5 as B
import Network.RemoteData (RemoteData(..))

import TV.API (APIResponse)

-- | Union type representing the possible actions the application component can perform.
data Action = FetchSchedule

-- | Sum type representing the application component's state record.
type State = { response :: APIResponse }

-- | Constructs an empty `HTML` element.
empty :: forall w i. HTML w i
empty = H.text mempty

-- | Constructs `HTML` when the given condition is `true`.
whenElem :: forall w i. Boolean -> (Unit -> HTML w i) -> HTML w i
whenElem cond f = if cond then f unit else empty

-- | Constructs `HTML` when the given `RemoteData` was constructed with `Success`
-- | otherwise renders a spinner.
withSpinner :: forall e a w i. RemoteData e a -> (a -> HTML w i) -> HTML w i
withSpinner remoteData f = case remoteData of
  Success a -> f a
  Loading -> H.div [ P.classes [ B.spinnerBorder, B.textMuted ] ] []
  _ -> empty
