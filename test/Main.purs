module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import Test.Spec.Discovery (discover)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (runSpec)

-- | Discover and execute all `Spec` tests.
main :: Effect Unit
main = launchAff_ do
  modules <- discover """Test\..*\.Spec"""
  runSpec [ consoleReporter ] modules
