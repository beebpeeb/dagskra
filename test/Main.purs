module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (runSpec)

import Test.Data.Description.Spec as Description
import Test.Data.Listing.Spec as Listing
import Test.Data.StartTime.Spec as StartTime

-- | Execute all `Spec` tests.
main :: Effect Unit
main = launchAff_ $ runSpec [ consoleReporter ] specs
  where
  specs = do
    Description.spec
    Listing.spec
    StartTime.spec
