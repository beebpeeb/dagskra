module Main where

import Prelude

import Effect (Effect)
import Halogen.Aff (awaitBody, runHalogenAff)
import Halogen.VDom.Driver (runUI)

import TV.UI.Container as Container

-- | Mount the main container component into the DOM.
main :: Effect Unit
main = runHalogenAff do
  body <- awaitBody
  runUI Container.component unit body
