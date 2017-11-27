import Elm = require("./../../js/vinculi-explorer/elm-vinculi-explorer")
// import $ = require("jquery")
import {GraphManager} from "./graph-manager"


let elmApp;
const elmDiv = document.getElementById("elm-vinculi-explorer")
if (elmDiv) {
    elmApp = Elm.Main.embed(elmDiv, {
        socketUrl: <string>window.socketUrl,
        originNodeUuid: <string>window.nodeUuid,
        originNodeLabels: <string[]>window.nodeLabels,
        userToken: <string>window.userToken
    })
}


function nextOperation(graphManager) {
    // console.log("Next Operation")
    // console.log(graphManager)
}

async function initGraphManager(elmApp, serverUrl:string) {
    const graphManager = new GraphManager(elmApp, serverUrl)
    await graphManager.init()
    nextOperation(graphManager)
}


initGraphManager(elmApp, window.serverUrl)
