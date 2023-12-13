# Dagskrá RÚV

## Install

```shell
npm install
```

## Run

```shell
npm start
```

## Test

```shell
npm test
```

## REPL

```shell
npm run repl
```

---

## PureScript

### Runtime

PureScript has **no runtime**, so you will notice that source files start off
with quite a lot of import statements. Unlike Haskell, the [Prelude][] is not
automatically imported.

Source files may at first appear to be quite large, but if you ignore imports
and type signatures, the amount of functional code is actually quite small.

Since it is idiomatic to define custom types for your domain, functions
which operate on these types tend to be small, concise and unambiguous.

PureScript does not support variadic functions. Instead, just write another
function to capture the intent of your API. You might notice this in the
UI component modules where, for example, `div_` is a "primed" version of `div`
that does not take the latter's first argument.

Functions are cheap. It's better to be unambiguous.

PureScript is isomporphic and compiles to JavaScript which can be run both
in the browser and on NodeJS.

---

### Layout

The modules in [Data](src/Data/) are where our types are defined, along with
the functions that operate on these types. It is idiomatic in both PureScript
and Haskell (and other such languages) to begin a project by carefully
designing the types which describe your domain.

The modules in [UI](src/UI/) are where the [Halogen][] UI rendering functions
live.

You can see how the application is mounted into the DOM in the
[`Main`](src/Main.purs) module.

---

### Libraries

This application makes use of the [Halogen][] UI library, entirely written in
PureScript. Halogen is conceptually similar to React.

See an example of an AJAX request (and subsequent JSON decoding) in the
[`API`](src/API.purs) module.

JSON decoding is provided by [Argonaut][].

---

### Testing

The test modules in the `test` directory demonstrate some approaches to
testing. This application is small enough that we can use [Spec][] tests, but
[QuickCheck][] can often be valuable for larger projects.


[argonaut]: https://github.com/purescript-contrib/purescript-argonaut
[halogen]: https://purescript-halogen.github.io/purescript-halogen/
[prelude]: https://github.com/purescript/purescript-prelude
[quickcheck]: https://github.com/purescript/purescript-quickcheck
[spec]: https://purescript-spec.github.io/purescript-spec/
