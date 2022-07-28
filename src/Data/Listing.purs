module TV.Data.Listing
  ( Listing
  , Listings
  , Status(..)
  , date
  , decodeListings
  , descriptionString
  , hasDescription
  , isLive
  , isRepeat
  , scheduleDate
  , startTimeString
  , status
  , timestamp
  , titleString
  ) where

import Prelude

import Data.Argonaut (class DecodeJson, Json, JsonDecodeError, (.:), decodeJson)
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NEA
import Data.Either (Either)
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NES
import Data.Traversable (traverse)

import TV.Data.Description (Description)
import TV.Data.Description as Description
import TV.Data.StartTime (StartTime)
import TV.Data.StartTime as StartTime

-- | Union type representing the transmission status of a TV show.
data Status
  = Live String
  | Repeat String
  | Standard

-- | Sum type representing a TV show listing.
-- | A `Listing` is constructed from a JSON object only.
-- |
-- | This type represents only the data needed from the external API.
-- | Everything else is derived from this data by functions in this module.
newtype Listing = Listing
  { description :: Description
  , live :: Boolean
  , startTime :: StartTime
  , title :: NonEmptyString
  }

derive instance eqListing :: Eq Listing

instance decodeJsonListing :: DecodeJson Listing where
  decodeJson json = do
    obj <- decodeJson json
    description <- obj .: "description"
    live <- obj .: "live"
    startTime <- obj .: "startTime"
    title <- obj .: "title"
    pure $ Listing { description, live, startTime, title }

instance ordListing :: Ord Listing where
  compare (Listing a) (Listing b) = compare a.startTime b.startTime

instance showListing :: Show Listing where
  show (Listing { title }) = "(Listing " <> show title <> ")"

type Listings = NonEmptyArray Listing

date :: Listing -> String
date (Listing { startTime }) = StartTime.toDateString startTime

decodeListings :: Json -> Either JsonDecodeError Listings
decodeListings = decodeJson >=> (_ .: "results") >=> traverse decodeJson

-- | Returns the description of a `TVShow` as a plain `String`.
descriptionString :: Listing -> String
descriptionString (Listing { description }) = Description.toString description

-- | Returns `true` if the given `TVShow` has a description.
hasDescription :: Listing -> Boolean
hasDescription (Listing { description }) = Description.hasText description

-- | Returns `true` if the given `TVShow` is a live transmission.
isLive :: Listing -> Boolean
isLive (Listing { live }) = live

-- | Returns `true` if the given `TVShow` is a repeat transmission.
isRepeat :: Listing -> Boolean
isRepeat (Listing { description }) = Description.isRepeat description

scheduleDate :: Listings -> String
scheduleDate = date <<< NEA.head

-- | Returns the start time of a `TVShow` as a `String`.
startTimeString :: Listing -> String
startTimeString (Listing { startTime }) = StartTime.toTimeString startTime

-- | Returns the derived transmission `Status` of the given `TVShow`.
status :: Listing -> Status
status = flap [ isLive, isRepeat ] >>> case _ of
  [ true, _ ] -> Live "bein útsending"
  [ false, true ] -> Repeat "endurtekinn"
  _ -> Standard

-- | Returns the timestamp of the given `TVShow`.
timestamp :: Listing -> String
timestamp (Listing { startTime }) = StartTime.toTimestamp startTime

-- | Returns the title of the given `TVShow` as a plain `String`.
titleString :: Listing -> String
titleString (Listing { title }) = NES.toString title
