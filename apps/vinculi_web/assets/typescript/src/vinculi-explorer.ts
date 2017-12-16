import Elm = require("./../../js/vinculi-explorer/elm-vinculi-explorer")
// import $ = require("jquery")
import {GraphManager} from "./graph-manager"

interface WindowInterface extends Window {
  socketUrl: string
  nodeUuid: string
  nodeLabels: string[]
  userToken: string
  serverUrl: string
}


let elmApp;
const elmDiv = document.getElementById("elm-vinculi-explorer")
if (elmDiv) {
    elmApp = Elm.Main.embed(elmDiv, {
        socketUrl: (window as WindowInterface).socketUrl,
        originNodeUuid: (window as WindowInterface).nodeUuid,
        originNodeLabels: (window as WindowInterface).nodeLabels,
        userToken: (window as WindowInterface).userToken
    })

    initGraphManager(elmApp, (window as WindowInterface).serverUrl)
}

function nextOperation(graphManager) {
    console.log("Next Operation")
    console.log(graphManager)
}

async function initGraphManager(elmApp, serverUrl: string) {
    const graphManager = new GraphManager(elmApp, serverUrl)
    await graphManager.init()
    nextOperation(graphManager)
}
