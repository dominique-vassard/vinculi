// import Elm  from "./../../js/vinculi-explorer/elm-vinculi-explorer"
// import $ from "jquery"
import Elm = require("./../../js/vinculi-explorer/elm-vinculi-explorer")
// import Elm = require("elm-vinculi-explorer")
// import Elm from "elm-vinculi-explorer"
import $ = require("jquery")
import {GraphManager} from "./graph-manager"
// import { GraphManagerFn } from "./graph-manager-fn"


let elmApp;
const elmDiv = document.getElementById("elm-vinculi-explorer")
if (elmDiv) {
    elmApp = Elm.Main.embed(elmDiv, {
        socketUrl: <string>socket_url,
        originNodeUuid: <string>node_uuid,
        originNodeLabels: <string[]>node_labels
    })
}


function nextOperation(graphManager) {
    console.log("Next Operation")
    console.log(graphManager)
}

async function initGraphManager(elmApp) {
    const graphManager = new GraphManager(elmApp)
    await graphManager.init()
    nextOperation(graphManager)
}


initGraphManager(elmApp)
