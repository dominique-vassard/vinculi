import * as cytoscape from "cytoscape"
import * as Ports from "./ports"

/**
 * Class responsible for all graph operations, comunication with Elm ports
 */
export class GraphManager {
    /**
     * The cytoscape object (manage the graph)
     * @type {cytoscape.Core}
     */
    private _cy: cytoscape.Core

    /**
     * Object which manages the ports (communication with Elm)
     * @type {Ports.Ports}
     */
    private readonly _ports: Ports.Ports

    /**
     * The current node
     *
     * @type cytoscape.NodeSingular | undefined
     */
    private _currentNode: cytoscape.NodeSingular | undefined

    /**
     * List of port callbacks, formated as:
     *     {
     *         "init": {
     *             // List of ports used during initialsiation
     *             portName : port Function,
     *             ...
     *         },
     *         "runtime": {
     *             // List of ports used during runtime
     *             portName : port Function,
     *             ...
     *         }
     *     }
     *
     * IMPORTANT: portName must match the Elm port name
     * Example:
     *     if (un)subscription use: `Elm.ports.initGraph.subscribe`
     *     Then portName must be ` initGraph`
     *
     * Init port will be deactived post initialisation.
     * @type {Ports.Callbacks}
     */
    private readonly _portCallbacks: Ports.Callbacks = {
        "init": {
            "initGraph": (initialGraph: cytoscape.ElementDefinition[]) => {
                this.initGraph(initialGraph)
            },
        },
        "runtime": {
            "addToGraph": (localGraph: cytoscape.ElementDefinition[]) => {
                this.addData(localGraph)
            }
        }
    }

    /**
     * Constructs the graphManager
     *
     * @param {any}   ElmApp   The elm application to use (for ports init)
     */
    constructor(elmApp: any) {
        this._ports = new Ports.Ports(elmApp, this._portCallbacks)
        this._cy = cytoscape()
        this._currentNode = undefined
    }

    /**
     *  Initiliaze graph Manager: get style and initial graph data
     *
     * @return {Promise<GraphManager>}   The initialized graph Manager
     */
    async init(): Promise<GraphManager> {
        await this._ports.initGraphPort(this._portCallbacks["init"]["initGraph"])
        return this
    }


    /**
     * Handlers intialization
     *
     * TODO: Manage modes
     *
     */
    initHandlers(): GraphManager {
        this._cy.on('click', 'node',
            (event) => { this.nodeDeploymentHandler(event) }
        )
        return this
    }

    /**
     * Computes the current bounding box
     * in order to display new data elegantly
     *
     * @returns  {cytoscape.BoundingBox12}  A valid bound box where to dispaly new data
     *
     */
    getBoundingBox() {
        //Padding around deployed node
        let padding = 400

        //Determine node position from border
        let node = this._currentNode
        if (node == undefined) {
            return
        }

        let bbox = <cytoscape.BoundingBox12>this._cy.elements().boundingBox({})
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
            "y1": node.position().y - padding / 2,
            "w": padding,
            "h": padding
        }

        return bb
    }

    /////////////////////////////////////////////////////////////////
    //                         HANDLERS                            //
    /////////////////////////////////////////////////////////////////
    /**
     * Manage node deployment
     * TODO: Hide/show children if node data has yet been retrieved
     *       Else call the deploy method
     *
     * TODO: Update filters when done
     *
     * @param  cytoscape.EventObject   event    Event attached to this method (click/tap on node)
     * @return void
     */
    nodeDeploymentHandler(event: cytoscape.EventObject): void {
        let node = event.target
        let data = {
            "uuid": node.id(),
            "labels": node.data()["labels"]
        }
        this._currentNode = node
        this._ports.getLocalGraph(data)
    }

    /////////////////////////////////////////////////////////////////
    //                       PORTS CALLBACKS                       //
    /////////////////////////////////////////////////////////////////

    /**
     *   Graph initialization:
     *       - Perform the cytoscape object initialisation
     *       - Deactivate init ports
     *        Initialize default handlers
     *
     * @param {cytoscape.ElementDefinition[]}
     */
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
        this._currentNode = undefined

        // InitGraphPort is not useful anymore
        // Then unsuscribe
        this._ports.postInit()
        this.initHandlers()
    }

    /**
     * Add new local graph to current graph
     * If ther is some:
     *     - display lcoal graph nodes and edges
     *     - focus on them
     *
     * @param {cytoscape.ElementDefinition[]}    localGaph    The received local graph data
     */
    addData(localGraph: cytoscape.ElementDefinition[]) {
        let layout_config =
            {
                "name": 'concentric',
                "boundingBox": this.getBoundingBox(),
                "animate": true
            }
        const l = this._cy.add(localGraph).layout(layout_config).run()
    }
}