import Elm from "./elm-vinculi-explorer.js"
const elmDiv = document.getElementById("elm-vinculi-explorer")
if (elmDiv) {
    const elmApp = Elm.Main.embed(elmDiv)
}