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
import Data.Maybe (Maybe, maybe)
import Data.String (Pattern(..), stripSuffix, trim)

-- | Union type representing the possible description of a listing
-- | which may, additionally, identify a repeat transmission.
-- | Construct a `Description` with `fromString`.
data Description
  = NoDescription
  | StandardDescription String
  | RepeatDescription String

derive instance eqDescription :: Eq Description

derive instance ordDescription :: Ord Description

instance decodeJsonDescription :: DecodeJson Description where
  decodeJson = decodeJson >=> fromString >>> pure

instance showDescription :: Show Description where
  show = case _ of
    NoDescription -> "NoDescription"
    StandardDescription s -> "(StandardDescription " <> show s <> ")"
    RepeatDescription s -> "(RepeatDescription " <> show s <> ")"

-- | Constructs a `Description` from the given, plain string.
fromString :: String -> Description
fromString = trim >>> case _ of
  "" -> NoDescription
  s -> maybe (StandardDescription s) RepeatDescription (removeSuffix s)

-- | Returns `true` if the given `Description` has text.
hasText :: Description -> Boolean
hasText = not isEmpty

-- | Returns `true` if the given `Description` has no text.
isEmpty :: Description -> Boolean
isEmpty = case _ of
  NoDescription -> true
  _ -> false

-- | Returns `true` if the given `Description` represents a repeat transmission.
isRepeat :: Description -> Boolean
isRepeat = case _ of
  RepeatDescription _ -> true
  _ -> false

removeSuffix :: String -> Maybe String
removeSuffix = stripSuffix suffix >=> trim >>> pure

suffix :: Pattern
suffix = Pattern " e."

-- | Converts a `Description` into a plain string.
toString :: Description -> String
toString = case _ of
  NoDescription -> mempty
  StandardDescription s -> s
  RepeatDescription s -> s
