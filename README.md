# MyContacts - Frontend

> 🌳  built with [elm-spa](https://elm-spa.dev)

Built alongside the [JStack course](https://jstack.com.br/).
This is the frontend for [MyContacts - Backend](https://github.com/NeoVier/mycontacts-backend).

The course teaches React on the frontend, and this is the Elm version of the same app.

This project is mainly a sandbox to test some Elm packages, specifically
[rtfeldman/elm-css](https://package.elm-lang.org/packages/rtfeldman/elm-css/latest/)
and [hecrj/composable-form](https://package.elm-lang.org/packages/hecrj/composable-form/latest/).

The main take-aways from those packages are:

## elm-css

- Having typed CSS is awesome
- Since it's all Elm, we get some nice autocompletion
- It can be a little confusing at first, but then you realize you can pretty much just write css and it will work
- Using selectors (such as `>`, or all the children, etc) feels a little clunky, but you can usually do stuff without them
- Paired with [matheus23/elm-tailwind-modules](https://github.com/matheus23/elm-tailwind-modules), we can have type-safe Tailwind!! (not used in this project)
- It's really easy to use functionalities that the package doesn't provide (such as properties it doesn't have)

## composable-form

- The abstraction of having a "dirty" model and a "parsed" model is really nice, and follows "parse, don't validate"
- Defining custom view functions doesn't feel great, but it's doable. Maybe it would be easier if the project used the standard `elm/html` Html instead of `elm-css`'s
- We don't need a bunch of `Msg`s just to deal with form fields, so the form logic can be "hidden away", in a sense
- We can have the same form on different pages, starting with different data (awesome for "Create" and "Edit" pages that need the same info)
- The docs could be better

## dependencies

This project requires the latest LTS version of [Node.js](https://nodejs.org/)

```bash
npm install -g elm elm-spa
```

## running locally

```bash
elm-spa server  # starts this app at http:/localhost:1234
```

### other commands

```bash
elm-spa add    # add a new page to the application
elm-spa build  # production build
elm-spa watch  # runs build as you code (without the server)
```

## learn more

You can learn more at [elm-spa.dev](https://elm-spa.dev)
