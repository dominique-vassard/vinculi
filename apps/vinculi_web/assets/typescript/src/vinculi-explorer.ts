import Elm = require("./../../js/vinculi-explorer/elm-vinculi-explorer")
// import $ = require("jquery")
import {GraphManager} from "./graph-manager"


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

async function initGraphManager(elmApp, serverUrl:string) {
    const graphManager = new GraphManager(elmApp, serverUrl)
    await graphManager.init()
    nextOperation(graphManager)
}


initGraphManager(elmApp, server_url)
