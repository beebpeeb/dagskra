module Main where

import Prelude

import Effect (Effect)
import Halogen.Aff (awaitBody, runHalogenAff)
import Halogen.VDom.Driver (runUI)

import TV.UI.Container (component)

-- | Mount the Halogen container component into the DOM.
main :: Effect Unit
main = runHalogenAff $ runUI component unit =<< awaitBody
