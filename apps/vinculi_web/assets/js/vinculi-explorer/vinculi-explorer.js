import Elm from "./elm-vinculi-explorer.js"
const elmDiv = document.getElementById("elm-vinculi-explorer")
var elmApp
if (elmDiv) {
    elmApp = Elm.Main.embed(elmDiv, {socketUrl: socket_url,
                                     originNodeUuid: node_uuid,
                                     originNodeLabels: node_labels})
}

var cytoscape = require('cytoscape');


class GraphManager {

  constructor(styleString, initialGraph) {
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

    //Manage handlers
    this.cy.on('click', 'node', this.nodeDeploymentHandler)
  }

  addData(graphData) {
    this.cy.add(graphData)
  }

  nodeDeploymentHandler(event) {
    let node = event.target
    console.log(node.id())
    console.log(node.data()["labels"])
    let data = {
      "uuid": node.id(),
      "labels": node.data()["labels"]
    }
    elmApp.ports.getLocalGraph.send(data)
  }

}


var ports_init = function(elmApp, cy) {
  elmApp.ports.addToGraph.subscribe(function(localGraph) {
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
    getStyleAndInitGraph(newGraph)
  })

});

