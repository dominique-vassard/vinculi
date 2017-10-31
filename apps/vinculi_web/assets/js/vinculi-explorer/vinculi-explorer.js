import Elm from "./elm-vinculi-explorer.js"
const elmDiv = document.getElementById("elm-vinculi-explorer")
var elmApp
if (elmDiv) {
    elmApp = Elm.Main.embed(elmDiv, {socket_url: socket_url,
                                     source_node_uuid: source_node_uuid})
}

var cytoscape = require('cytoscape');

$( document ).ready(function() {
  //Loading style and init graph
  $.ajax({
      url: 'http://localhost:4000/css/graph.css',
      type: 'GET',
      dataType: 'text',
      // async: false //ASync then we can wait for the treatment to be done in code process
  })
  .done(function(styleString) {
      // init(styleString);
      var cy = init_graph(styleString)
      cy.$("#a").style("background-color", "#EE4444")

      elmApp.ports.currentStyle.send(cy.$("#a").style("background-color"))

      $("#reset-style").click(function() {

        elmApp.ports.resetStyle.send({obj: "#11FF22"})
      })

      ports_init(elmApp, cy);
  })
  .fail(function(json) {
      throw "Can't retrieve style string from file";
  });

});


var init_graph = function(styleString) {
  var cy = cytoscape({

    container: document.getElementById('cy'), // container to render in

    // elements: [ // list of graph elements to start with
    //   { // node a
    //     data: { id: 'a' }
    //   },
    //   { // node b
    //     data: { id: 'b' }
    //   },
    //   { // edge ab
    //     data: { id: 'ab', source: 'a', target: 'b' }
    //   }
    // ],

    elements : {
      "nodes" : [
        { // node a
        data: { id: 'hello' }
        , classes: 'person'
        },
        { // node b
          data: { id: 'you' }
        }
      ],
      "edges": [
        { // edge ab
          data: { id: 'ab', source: 'hello', target: 'you', classes: "employed_to" }
        }
      ]
    },
    style: styleString,
    // style: [ // the stylesheet for the graph
    //   {
    //     selector: 'node',
    //     style: {
    //       'background-color': '#666',
    //       'label': 'data(id)'
    //     }
    //   },

    //   {
    //     selector: 'edge',
    //     style: {
    //       'width': 3,
    //       'line-color': '#ccc',
    //       'target-arrow-color': '#ccc',
    //       'target-arrow-shape': 'triangle'
    //     }
    //   }
    // ],

    layout: {
        name: 'concentric',
        animate: true,
        avoidOverlap: true
    },

  });

  // cy.$("#hello").addClass("person")
  console.log(cy.$("#hello"))
  return cy;
}

var ports_init = function(elmApp, cy) {
  elmApp.ports.changeStyle.subscribe(function(newStyle) {
    console.log("newStyle: " + newStyle)
    cy.$("#a").style("background-color", newStyle)
  })

  elmApp.ports.newGraph.subscribe(function(newGraph) {
    console.log(JSON.stringify(newGraph));
    console.log(newGraph);
    cy.add(newGraph);
  })

}
