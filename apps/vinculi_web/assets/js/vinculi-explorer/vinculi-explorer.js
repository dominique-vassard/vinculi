import Elm from "./elm-vinculi-explorer.js"
const elmDiv = document.getElementById("elm-vinculi-explorer")
var elmApp
if (elmDiv) {
    elmApp = Elm.Main.embed(elmDiv, {socketUrl: socket_url,
                                     originNodeUuid: node_uuid,
                                     originNodeLabels: node_labels})
}

var cytoscape = require('cytoscape');

// Awful hack to make class propertry working
// this.currentNode is reinitialized between addData and nodeDeploymentHandler
var currentNode = null

class GraphManager {

  constructor(styleString, initialGraph) {
    console.log("New GraphManager")
    this.cy = cytoscape({

      container: document.getElementById('cy'), // container to render in

      elements : initialGraph,

      style: styleString,

      layout: {
          name: 'concentric',
          animate: true,
          avoidOverlap: true
      },

    })

    this.currentNode = null

    //Manage handlers
    this.cy.on('click', 'node', this.nodeDeploymentHandler)
  }

  addData(graphData) {
    let layout_config =
      {"name": 'concentric',
       "boundingBox": this.getBoundingBox(),
       "animate": true}
       console.log(layout_config)
    this.cy.add(graphData).layout(layout_config).run()
    console.log(this.cy.elements().jsons())
  }

  getBoundingBox() {
    //Padding around deployed node
    let padding = 400

    //Determine node position from border
    let node = currentNode
    let bbox = this.cy.elements().boundingBox()
    let nodePos = node.position()
    let distR, distL, distT, distB, minDist, bb
    distR = nodePos.x - bbox.x1
    distL = bbox.x2 - nodePos.x
    distT = nodePos.y - bbox.y1
    distB = bbox.y2 - nodePos.y

    //Detach node from original circle
    minDist = Math.min(distR, distL, distT, distB)
    if (distR == minDist) {
        node.position('x', nodePos.x - padding)
    } else if (distL == minDist) {
        node.position('x', nodePos.x + padding)
    } else if (distT == minDist) {
        node.position('y', nodePos.y - padding)
    } else {
        node.position('y', nodePos.y + padding)
    }

    //Define new node bounding box
    bb = {"x1": node.position('x') - padding/2,
          "y1": node.position('y') - padding/2,
          "w": padding,
          "h": padding}

    return bb
  }

  nodeDeploymentHandler(event) {
    let node = event.target
    console.log(node.id())
    console.log(node.data()["labels"])
    let data = {
      "uuid": node.id(),
      "labels": node.data()["labels"]
    }
    this.currentNode = node
    currentNode = node
    elmApp.ports.getLocalGraph.send(data)
  }

}


var ports_init = function(elmApp, cy) {
  elmApp.ports.addToGraph.subscribe(function(localGraph) {
    console.log("Send new data")
    cy.addData(localGraph);
  })

}

var getStyleAndInitGraph = function(elements) {
  //Loading style and init graph
  $.ajax({
      url: 'http://localhost:4000/graph_style/graph.css',
      type: 'GET',

      dataType: 'text',
      // async: false //ASync then we can wait for the treatment to be done in code process
  })
  .done(function(styleString) {
      let graphManager = new GraphManager(styleString, elements)
      ports_init(elmApp, graphManager)
  })
  .fail(function(json) {
      throw "Can't retrieve style string from file";
  });
}

$( document ).ready(function() {
  elmApp.ports.initGraph.subscribe(function(newGraph) {
    console.log("Init data")
    getStyleAndInitGraph(newGraph)
  })

});

