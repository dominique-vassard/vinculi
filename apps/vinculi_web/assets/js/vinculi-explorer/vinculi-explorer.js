import Elm from "./elm-vinculi-explorer.js"
const elmDiv = document.getElementById("elm-vinculi-explorer")
var elmApp
if (elmDiv) {
    elmApp = Elm.Main.embed(elmDiv, {socket_url: socket_url,
                                     source_node_uuid: source_node_uuid})
}

var cytoscape = require('cytoscape');

$( document ).ready(function() {
  var cy = init_graph()
  cy.$("#a").style("background-color", "#EE4444")

  elmApp.ports.currentStyle.send(cy.$("#a").style("background-color"))

  $("#reset-style").click(function() {

    elmApp.ports.resetStyle.send({obj: "#11FF22"})
  })

  ports_init(elmApp, cy);
});


var init_graph = function() {
  var cy = cytoscape({

    container: document.getElementById('cy'), // container to render in

    elements: [ // list of graph elements to start with
      { // node a
        data: { id: 'a' }
      },
      { // node b
        data: { id: 'b' }
      },
      { // edge ab
        data: { id: 'ab', source: 'a', target: 'b' }
      }
    ],

    style: [ // the stylesheet for the graph
      {
        selector: 'node',
        style: {
          'background-color': '#666',
          'label': 'data(id)'
        }
      },

      {
        selector: 'edge',
        style: {
          'width': 3,
          'line-color': '#ccc',
          'target-arrow-color': '#ccc',
          'target-arrow-shape': 'triangle'
        }
      }
    ],

    layout: {
      name: 'grid',
      rows: 1
    }

  });

  return cy;
}

var ports_init = function(elmApp, cy) {
  elmApp.ports.changeStyle.subscribe(function(newStyle) {
    console.log("newStyle: " + newStyle)
    cy.$("#a").style("background-color", newStyle)
  })

}
