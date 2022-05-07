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
import Data.Either (hush)
import Data.Maybe (Maybe, fromMaybe)
import Data.String (trim)
import Data.String.Regex (Regex)
import Data.String.Regex (regex, replace, test) as RE
import Data.String.Regex.Flags (multiline) as RE

-- | Union type representing the possible description of a TV show.
-- | Construct a `Description` with `fromString`.
data Description
  = NoDescription
  | Description String
  | RepeatDescription String

derive instance eqDescription :: Eq Description

derive instance ordDescription :: Ord Description

instance decodeJsonDescription :: DecodeJson Description where
  decodeJson = decodeJson >=> fromString >>> pure

instance showDescription :: Show Description where
  show = case _ of
    NoDescription -> "NoDescription"
    Description s -> "(Description " <> show s <> ")"
    RepeatDescription s -> "(RepeatDescription " <> show s <> ")"

-- | Constructs a `Description` from the given `String`.
fromString :: String -> Description
fromString = trim >>> case _ of
  "" -> NoDescription
  s ->
    if hasSuffix s then RepeatDescription (strip s)
    else Description s
  where
    strip s =
      trim $ fromMaybe s $ RE.replace <$> re <@> "$1" <@> s

-- Returns `true` if the repeat broadcast regex matches the given string.
hasSuffix :: String -> Boolean
hasSuffix s = fromMaybe false $ RE.test <$> re <@> s

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

-- Regular expression which identifies a repeat broadcast.
re :: Maybe Regex
re = hush $ RE.regex """(\W+)e.?\s*$""" RE.multiline

-- | Converts a `Description` to a plain `String`.
toString :: Description -> String
toString = case _ of
  NoDescription -> mempty
  Description s -> s
  RepeatDescription s -> s
