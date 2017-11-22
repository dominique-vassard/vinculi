// import * as cytoscape from "cytoscape"
// import fp from "lodash/fp"
// import * as _ from "lodash";


// export namespace GraphManagerFn {
//     interface Model {
//         readonly cy: cytoscape.Core
//         readonly currentNode: string | null
//         readonly elmApp: any
//     }

//     let model_:Model

//     function setModel(model:Model):void {
//         model_ = model
//     }

//     export function getModel(): Model {
//         return _.clone(model_)
//     }

//     export function getModel_():Model {
//         return model_;
//     }

//     function setCy(newCy: cytoscape.Core) {
//         const model = {
//             cy: newCy,
//             currentNode: getCurrentNode(),
//             elmApp: getElmApp()
//         }
//         setModel(model)
//     }

//     function getCy():cytoscape.Core {
//         return _.clone(model_.cy)
//     }

//     function setCurrentNode(newNode: string|null):void {
//         const model = {
//             cy: getCy(),
//             currentNode: newNode,
//             elmApp: getElmApp()
//         }

//         setModel(model)
//     }

//     function getCurrentNode(): (string | null) {
//         return _.clone(model_.currentNode)
//     }

//     function setElmApp(elmApp:any):void {
//         const model = {
//             cy: getCy(),
//             currentNode: getCurrentNode(),
//             elmApp: elmApp
//         }

//         setModel(model)
//     }

//     function getElmApp(): any {
//         return _.clone(model_.elmApp)
//     }

//     export function build(elmApp: any) {
//         const model = {
//             cy: cytoscape(),
//             currentNode: null,
//             elmApp: elmApp
//         }

//         setModel(model)
//         return getModel()
//     }

//     export function init() {
//         return Promise.resolve(initGraphPort())
//         // initGraphPort()
//         // .then(
//         //     () => console.log("result received")
//         // )
//         // .catch(
//         //     (error) => console.error(error)
//         // )
//         // return getModel()
//     }

//     function initGraphPort() {
//         const promise = new Promise((resolve) => {
//             getElmApp().ports.initGraph.subscribe((newGraph: any) => {
//                 resolve(initGraph(newGraph))
//             })
//         })

//         return promise
//     }

//     function initGraph(initialGraph: cytoscape.ElementDefinition[]) {
//         const cy = cytoscape({
//             container: document.getElementById('cy'),

//             elements: initialGraph,

//             style: $.ajax({
//                 url: 'http://localhost:4000/graph_style/graph.css',
//                 type: 'GET',
//                 dataType: 'text',
//             }),

//             layout: <cytoscape.ConcentricLayoutOptions>{
//                 name: 'concentric',
//                 animate: true,
//                 avoidOverlap: true
//             }

//         })
//         setCy(cy)
//         setCurrentNode(null)
//     }


// }