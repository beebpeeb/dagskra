module TV.Data.StartTime
  ( StartTime
  , fromString
  , toDateString
  , toTimeString
  , toTimestamp
  ) where

import Prelude

import Data.Argonaut (class DecodeJson, JsonDecodeError(..), decodeJson)
import Data.Argonaut as Json
import Data.Bifunctor (lmap)
import Data.DateTime (DateTime)
import Data.Either (Either)
import Data.Formatter.DateTime (Formatter, FormatterCommand(..), format, unformat)
import Data.List (List(..), (:))

-- | Custom type representing the start time of a TV show.
newtype StartTime = StartTime DateTime

derive instance eqStartTime :: Eq StartTime

derive instance ordStartTime :: Ord StartTime

instance decodeJsonStartTime :: DecodeJson StartTime where
  decodeJson =
    decodeJson
      >=> fromString
        >>> lmap (Json.fromString >>> UnexpectedValue)

instance showStartTime :: Show StartTime where
  show (StartTime dt) = "(StartTime " <> show dt <> ")"

fromString :: String -> Either String StartTime
fromString = unformat dateTimeFormatter >=> StartTime >>> pure

toDateString :: StartTime -> String
toDateString (StartTime dt) = format dateFormatter dt

toTimeString :: StartTime -> String
toTimeString (StartTime dt) = format timeFormatter dt

toTimestamp :: StartTime -> String
toTimestamp (StartTime dt) = format timestampFormatter dt

dateFormatter :: Formatter
dateFormatter =
  DayOfMonthTwoDigits
    : Placeholder "."
    : MonthTwoDigits
    : Placeholder "."
    : YearTwoDigits
    : Nil

dateTimeFormatter :: Formatter
dateTimeFormatter =
  YearFull
    : Placeholder "-"
    : MonthTwoDigits
    : Placeholder "-"
    : DayOfMonthTwoDigits
    : Placeholder " "
    : Hours24
    : Placeholder ":"
    : MinutesTwoDigits
    : Placeholder ":"
    : SecondsTwoDigits
    : Nil

timeFormatter :: Formatter
timeFormatter = Hours24 : Placeholder ":" : MinutesTwoDigits : Nil

timestampFormatter :: Formatter
timestampFormatter = UnixTimestamp : Nil
