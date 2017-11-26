# About Typescript & brunch

Problem is:
    - typescript-brunch compile without lib options (which is required for Promise, async, etc)

Therefore, when a wathcer is set on typscript dir, it doesn't compile. It only pops "Cannot use lib with --noLib"

Solution:
    - get in typescript dir: `cd typescript/src`
    - Launch tsc watcher: `tsc --diagnostics --watch -p ../tsconfig.json`
    - let the js/ watcher do its job and aggregate eveything in app.js

Warning:
There is a strange import: `import Elm = require("./../../js/vinculi-explorer/elm-vinculi-explorer")`
It only works because `js/vinculi-explorer` and `typescript/src` have the same directory depth.....

It is worth considering using Webpack.....
