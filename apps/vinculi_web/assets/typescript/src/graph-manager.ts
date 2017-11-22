import * as cytoscape from "cytoscape"
import Ports from "./ports"

export class GraphManager {
    private _cy: cytoscape.Core
    private _ports: Ports
    private _currentNode: cytoscape.NodeSingular | null
    // currentNode: cytoscape.NodeSingular | null

    constructor(ports: Ports) {
        this._ports = ports
        this._cy = cytoscape()
        this._currentNode = null

        ports.addCallback("initGraphPort",
            (initialGraph: cytoscape.ElementDefinition[]) => {
                this.initGraph(initialGraph)
            }
        )

        ports.addCallback("getLocalGraph",
            (localGraph: cytoscape.ElementDefinition[]) => {
                this.addData(localGraph)
            }
        )
    }

    async init(): Promise<GraphManager> {
        await this._ports.initGraphPort((newGraph) => {
            this.initGraph(newGraph)
        })
        return this
    }

    initGraph(initialGraph: cytoscape.ElementDefinition[]): void {
        this._cy = cytoscape({
            container: document.getElementById('cy'),

            elements: initialGraph,

            style: $.ajax({
                url: 'http://localhost:4000/graph_style/graph.css',
                type: 'GET',
                dataType: 'text',
            }),

            layout: <cytoscape.ConcentricLayoutOptions>{
                name: 'concentric',
                animate: true,
                avoidOverlap: true
            }

        })
        this._currentNode = null

        // InitGraphPort is not useful anymore
        // Then unsuscribe
        this._ports.postInit()
        this.initHandlers()
    }

    initHandlers() {
        this._cy.on('click', 'node',
            (event) => { this.nodeDeploymentHandler(event) }
        )
    }

    nodeDeploymentHandler(event) {
        console.log(this)
        let node = event.target
        console.log(node.id())
        console.log(node.data()["labels"])
        let data = {
            "uuid": node.id(),
            "labels": node.data()["labels"]
        }
        this._currentNode = node
        this._ports.getLocalGraph(data)
        // elmApp.ports.getLocalGraph.send(data)
    }

    addData(localGraph) {
        console.log("Add data")
        console.log(localGraph)
        let layout_config =
          {"name": 'concentric',
           "boundingBox": this.getBoundingBox(),
           "animate": true}
           console.log(layout_config)
        this._cy.add(localGraph).layout(layout_config).run()
        console.log(this.cy.elements().jsons())
    }

    getBoundingBox() {
        //Padding around deployed node
        let padding = 400

        //Determine node position from border
        let node = this._currentNode
        if (!node) {
            return
        }

        let bbox = this._cy.elements().boundingBox()
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
        bb = {
            "x1": node.position().x - padding / 2,
            "y1": node.position('y') - padding / 2,
            "w": padding,
            "h": padding
        }

        return bb
    }

    get cy(): cytoscape.Core {
        return this._cy
    }

    get currentNode(): (cytoscape.NodeSingular | null) {
        return this._currentNode
    }
}