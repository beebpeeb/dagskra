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
  , "halogen-bootstrap5"
  , "lists"
  , "maybe"
  , "prelude"
  , "remotedata"
  , "spec"
  , "spec-discovery"
  , "strings"
  , "transformers"
  ]
, packages = ./packages.dhall
}
