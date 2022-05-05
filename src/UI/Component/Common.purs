module TV.UI.Component.Common where

import Prelude

import Data.Maybe (Maybe)
import Data.Newtype (wrap)
import Halogen.HTML (HTML, IProp)
import Halogen.HTML as HTML
import Halogen.HTML.Properties (class_)
import Network.RemoteData (RemoteData(..))
import Network.RemoteData as RD
import TV.API (APIResponse)

-- | Sum type representing the possible actions the application component can perform.
data Action = FetchSchedule

-- | Type synonym representing the application component's state record.
type State =
  { date :: Maybe String
  , response :: APIResponse
  }

-- | Returns a Halogen `IProp` for the given CSS class(es).
css :: ∀ r i. String -> IProp (class :: String | r) i
css = class_ <<< wrap

-- | Renders an empty `HTML` element.
empty :: ∀ w i. HTML w i
empty = HTML.text mempty

-- | Render some HTML if the given `RemoteData`` was constructed with `Success`
-- | otherwise render a spinner.
renderSpinner :: ∀ e a w i. RemoteData e a -> (a -> HTML w i) -> HTML w i
renderSpinner remoteData f = case remoteData of
  Success a -> f a
  Loading -> HTML.div [ css "spinner-border text-muted" ] []
  _ -> empty

-- | Lazily renders `HTML` only if the given `RemoteData` was constructed with `Success`.
renderSuccess :: ∀ e a w i. RemoteData e a -> (a -> HTML w i) -> HTML w i
renderSuccess a f = RD.maybe empty f a

-- | Lazily renders an `HTML` element only if the given condition is `true`.
renderWhen :: ∀ w i. Boolean -> (Unit -> HTML w i) -> HTML w i
renderWhen cond f = if cond then f unit else empty
