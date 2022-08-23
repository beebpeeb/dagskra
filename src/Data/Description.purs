module TV.Data.Description
  ( Description
  , fromString
  , hasText
  , isEmpty
  , isRepeat
  , toString
  ) where

import Prelude

import Data.Argonaut (class DecodeJson, decodeJson)
import Data.Maybe (maybe)
import Data.String (Pattern(..), stripSuffix, trim)

-- | Union type representing the possible description of a listing
-- | which may additionally identify a repeat transmission.
-- | Construct a `Description` with `fromString`.
data Description
  = None
  | Description String
  | Repeat String

derive instance eqDescription :: Eq Description

derive instance ordDescription :: Ord Description

instance decodeJsonDescription :: DecodeJson Description where
  decodeJson = decodeJson >=> fromString >>> pure

instance showDescription :: Show Description where
  show = case _ of
    None -> "None"
    Description s -> "(Description " <> show s <> ")"
    Repeat s -> "(Repeat " <> show s <> ")"

-- | Constructs a `Description` from the given `String`.
fromString :: String -> Description
fromString = trim >>> case _ of
  "" -> None
  s -> maybe (Description s) Repeat $ trim <$> stripSuffix (Pattern " e.") s

-- | Returns `true` if the given `Description` has text.
hasText :: Description -> Boolean
hasText = not isEmpty

-- | Returns `true` if the given `Description` has no text.
isEmpty :: Description -> Boolean
isEmpty = case _ of
  None -> true
  _ -> false

-- | Returns `true` if the given `Description` represents a repeat transmission.
isRepeat :: Description -> Boolean
isRepeat = case _ of
  Repeat _ -> true
  _ -> false

-- | Converts a `Description` into a plain `String`.
toString :: Description -> String
toString = case _ of
  None -> mempty
  Description s -> s
  Repeat s -> s
