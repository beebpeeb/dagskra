# Dagskrá RÚV

PureScript app to accompany the BBC Academy talk "Abandon Hope!".

This app requires Node version 17 or higher.

---

## Install

```
npm install
```

## Run

```
npm start
```

## Test

```
npm test
```

## REPL

```
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

---

### Libraries

This application makes use of the [Halogen][] UI library.

You can see how the application is mounted into the DOM in the
[`Main.purs`](src/Main.purs) module.

See an example of an AJAX request (and subsequent JSON decoding) in the
[`API.purs`](src/API.purs) module.

---

### Testing

The test modules in the `test` directory demonstrate some approaches to
testing. This application is small enough that we can use [Spec][] tests, but
[QuickCheck] can often be valuable for larger projects.


[halogen]: https://purescript-halogen.github.io/purescript-halogen/
[prelude]: https://github.com/purescript/purescript-prelude
[quickcheck]: https://github.com/purescript/purescript-quickcheck
[spec]: https://purescript-spec.github.io/purescript-spec/
