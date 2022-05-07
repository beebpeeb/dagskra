module TV.UI.Common where

import Prelude

import Data.Maybe (Maybe)
import Data.Newtype (wrap)
import Halogen.HTML (HTML, IProp)
import Halogen.HTML as HTML
import Halogen.HTML.Properties (class_)
import Network.RemoteData (RemoteData(..))
import Network.RemoteData as RD

import TV.API (APIResponse)

-- | Union type representing the possible actions the application component can perform.
data Action = FetchSchedule

-- | Sum type representing the application component's state record.
type State =
  { date :: Maybe String
  , response :: APIResponse
  }

-- | Constructs a Halogen `IProp` for the given CSS class(es).
css :: ∀ r i. String -> IProp (class :: String | r) i
css = class_ <<< wrap

-- | Constructs an empty `HTML` element.
empty :: ∀ w i. HTML w i
empty = HTML.text mempty

-- | Constructs `HTML` only if the given `RemoteData` was constructed with `Success`
-- | otherwise render `empty`.
success :: ∀ e a w i. RemoteData e a -> (a -> HTML w i) -> HTML w i
success a f = RD.maybe empty f a

-- | Constructs `HTML` if the given `RemoteData` was constructed with `Success`
-- | otherwise render a spinner.
success' :: ∀ e a w i. RemoteData e a -> (a -> HTML w i) -> HTML w i
success' remoteData f = case remoteData of
  Success a -> f a
  Loading -> HTML.div [ css "spinner-border text-muted" ] []
  _ -> empty

-- | Constructs `HTML` only if the given condition is `true`.
when' :: ∀ w i. Boolean -> (Unit -> HTML w i) -> HTML w i
when' cond f = if cond then f unit else empty
