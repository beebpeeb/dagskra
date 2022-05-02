{ sources = [ "src/**/*.purs", "test/**/*.purs" ]
, name = "dagskra-ruv"
, dependencies =
  [ "aff"
  , "affjax"
  , "affjax-web"
  , "argonaut"
  , "arrays"
  , "bifunctors"
  , "datetime"
  , "effect"
  , "either"
  , "foldable-traversable"
  , "formatters"
  , "halogen"
  , "lists"
  , "maybe"
  , "newtype"
  , "prelude"
  , "remotedata"
  , "strings"
  , "transformers"
  ]
, packages = ./packages.dhall
}
