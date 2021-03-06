import * as cytoscape from "cytoscape"
import * as Ports from "./ports"

/**
 * Class responsible for all graph operations, comunication with Elm ports
 */
export class GraphManager {
    /**
     * The server url (used to get stylesheet)
     *
     * @type {string}
     */
    private _serverUrl: string
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
            },
            "setVisibleElements": (visibleElements: Ports.VisibleElements) => {
                this.setVisibleElements(visibleElements)
            }
        }
    }

    /**
     * Constructs the graphManager
     *
     * @param {any}       ElmApp       The elm application to use (for ports init)
     * @param {string}    serverUrl    The server url to use to get sylesheet
     */
    constructor(elmApp: any, serverUrl: string) {
        this._serverUrl = serverUrl
        this._cy = cytoscape()
        this._ports = new Ports.Ports(elmApp, this._portCallbacks)
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
        // Double tap: deploy node
        this._cy.on('doubleTap', 'node',
            (event) => { this.nodeDeploymentHandler(event) }
        )

        // Tap on canvas: unpin node infos
        this._cy.on('tap',
            (event) => { this.unpinNodeInfosHandler(event) }
        )

        // Tap on node: pin node infos
        this._cy.on('tap', 'node',
            (event) => { this.pinNodeInfosHandler(event) }
        )

        // Mouseover node: display node infos
        this._cy.on('mouseover', 'node',
            (event) => {
                this.showNodeInfosHandler(event)
                this.highlightNodeNeighboursOnHandler(event)
            }
        )

        // Mouseout node :hide node infos
        this._cy.on('mouseout', 'node',
            (event) => {
                this.hideNodeInfosHandler(event)
                this.deActivateHighlight(event)
            }
        )

        // Tap on node: pin node infos
        this._cy.on('tap', 'edge',
            (event) => { this.pinEdgeInfosHandler(event) }
        )

        // Mouseover edge: display edge infos
        this._cy.on('mouseover', 'edge',
            (event) => {
                this.showEdgeInfosHandler(event)
                this.highlightEdgeNeighboursOnHandler(event)
            }
        )

        // Mouseout edge :hide edge infos
        this._cy.on('mouseout', 'edge',
            (event) => {
                this.hideEdgeInfosHandler(event)
                this.deActivateHighlight(event)
            }
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
     * Hide/show children if node data has yet been retrieved
     * Else call the deploy method
     *
     * TODO: Update filters when done
     *
     * @param  cytoscape.EventObject   event    Event attached to this method (double on node)
     * @return void
     */
    nodeDeploymentHandler(event: cytoscape.EventObject): void {
        let node = event.target
        let data = {
            "uuid": node.id(),
            "labels": node.data()["labels"]
        }
        this._currentNode = node

        const children = this._cy.elements("node[parent-node = '" + node.id() + "']")
        if (children.length > 0) {
            const visible = children.some((node, _) => node.visible() == true)
            if (visible) {
                children.hide()
            } else {
                children.show()
            }
        } else {
            this._ports.getLocalGraph(data)

        }

    }

    /**
     * Manage node infos displaying
     * Send node uuid to Elm for displaying
     *
     * @param  cytoscape.EventObject   event    Event attached to this method (mouseover node)
     * @return void
     */
    showNodeInfosHandler(event: cytoscape.EventObject): void {
        const node = event.target
        this._ports.sendElementIdToDisplay(node.id(), "node")
    }

    /**
     * Manage node infos hiding
     * Send command to Elm for hiding node infos
     *
     * @param  cytoscape.EventObject   event    Event attached to this method (mouseout node)
     * @return void
     */
    hideNodeInfosHandler(event: cytoscape.EventObject): void {
        this._ports.hideElementInfos("node")
    }

    /**
     * Manage node infos pinning
     * Send command to Elm for pinning
     *
     * @param  cytoscape.EventObject   event    Event attached to this method (click/tap on node)
     * @return void
     */
    pinNodeInfosHandler(event: cytoscape.EventObject): void {
        const node = event.target
        this._ports.sendElementIdToPin("node", true)
    }

    /**
     * Manage edge infos pinning
     * Send command to Elm for pinning
     *
     * @param  cytoscape.EventObject   event    Event attached to this method (click/tap on node)
     * @return void
     */
    pinEdgeInfosHandler(event: cytoscape.EventObject): void {
        const edge = event.target
        this._ports.sendElementIdToPin("edge", true)
    }

    /**
     * Manage node infos unpinning
     * Send command to Elm for unpinning
     *
     * @param  cytoscape.EventObject   event    Event attached to this method (click/tap on canvas)
     * @return void
     */
    unpinNodeInfosHandler(event: cytoscape.EventObject): void {
        const target = event.target
        if (target === this._cy) {
            this._ports.sendElementIdToPin("node", false)
            this._ports.sendElementIdToPin("edge", false)
        }
    }

    /**
     * Manage edge infos displaying
     * Send edge uuid to Elm for displaying
     *
     * @param  cytoscape.EventObject   event    Event attached to this method (mouseover node)
     * @return void
     */
    showEdgeInfosHandler(event: cytoscape.EventObject): void {
        const edge = event.target
        this._ports.sendElementIdToDisplay(edge.id(), "edge")
    }

    /**
     * Manage edge infos displaying
     * Send edge uuid for Elm to hide its infos
     *
     * @param  cytoscape.EventObject   event    Event attached to this method (mouseover node)
     * @return void
     */
    hideEdgeInfosHandler(event: cytoscape.EventObject): void {
        this._ports.hideElementInfos("edge")
    }

    /**
     * Highlight overed node for better visualisation
     *
     * @param  cytoscape.EventObject   event    Event attached to this method (mouseover node)
     * @return void
     */
    highlightNodeNeighboursOnHandler(event: cytoscape.EventObject): void {
        const node = event.target
        const neighborhood = node.closedNeighborhood()
        this._cy.elements().addClass('faded')
        neighborhood.removeClass('faded')
    }

    /**
     * Highlight overed edge for better visualisation
     *
     * @param  cytoscape.EventObject   event    Event attached to this method (mouseover edge)
     * @return void
     */
    highlightEdgeNeighboursOnHandler(event: cytoscape.EventObject): void {
        const edge = event.target
        const neighborhood = edge.closedNeighborhood().add(edge.source()).add(edge.target())
        this._cy.elements().addClass('faded')
        neighborhood.removeClass('faded')
    }

    /**
     * De-activate highlighting
     *
     * @param  cytoscape.EventObject   event    Event attached to this method (mouseout node / edge)
     * @return void
     */
    deActivateHighlight(event: cytoscape.EventObject): void {
        this._cy.elements().removeClass('faded');
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

            style: this.getStyleSheet(),

            layout: <cytoscape.ConcentricLayoutOptions>{
                name: 'concentric',
                // fit: false,
                animate: true,
                avoidOverlap: true,
                spacingFactor: 4,
                animationDuration: 300
            }
        })
        this._currentNode = undefined

        // Hack to allow this._cy.elements to rellay hold elements data
        this._cy.add(initialGraph)

        // InitGraphPort is not useful anymore
        // Then unsuscribe
        this._ports.postInit()
        this._registerDoubleTapEvent()
        this.initHandlers()
        this.sendNewGraphState("Init")
    }

    /**
     * Retrieves stylesheet from server
     *
     * @return {Promise<string>}  The promise with the retrieved stylesheet
     */
    getStyleSheet():Promise<string> {
        const promise = new Promise((resolve, reject) => {
            const request = new XMLHttpRequest()
            request.open('GET', this._serverUrl + '/graph_style/graph.css')
            request.onload = () => {
                if (request.status >= 200 && request.status < 400) {
                    resolve(request.responseText)
                }  else {
                    reject("Cannot retrieve stylesheet")
                }
            }

            request.onerror = () => { reject("Cannot retrieve stylesheet") }

            request.send()
        })

        return <Promise<string>>promise

    }

    /**
     * Add new local graph to current graph
     * If there is some:
     *     - display lcoal graph nodes and edges
     *     - focus on them
     *
     * @param {cytoscape.ElementDefinition[]}    localGaph    The received local graph data
     */
    addData(localGraph: cytoscape.ElementDefinition[]) {
        let layout_config =
            {
                name: 'concentric',
                boundingBox: this.getBoundingBox(),
                animate: true,
                spacingFactor: 3,
                animationDuration: 300,
            }
        this._cy.add(localGraph).layout(layout_config).run()
        this.sendNewGraphState("Expand node")
    }

    /**
     * Send new graph state to Elm
     *
     * WARNING: Data must be send AFTER the animation has finished
     * otherwise elements postion won't be the right ones!
     *
     * @param  {string}       The action related to the new graph state
     *
     * @returns void
     */
    sendNewGraphState(description: string): void {
        setTimeout(()=>{
            const data = {
                data: this._cy.elements().jsons(),
                description: description
            }
            this._ports.sendNewGraphState(data)
        }, 300)
    }

    /**
     * Hide / show elements
     * if send elementIds is ["all"], all elements of the given type should be hidden / shown.
     *
     * @param {Ports.VisibleElements} elements    Data about elements to show/hide
     */
    setVisibleElements(elements:Ports.VisibleElements): void {
        if (elements.elementIds.length == 0) {
            return
        }

        // Manage collections
        let selectors
        // Get all element of a type
        if (elements.elementIds.toString() == "all") {
            selectors = elements.elementType
        }
        // Get only those with the given ids
        else {
            selectors = elements.elementIds.map(x => elements.elementType + '[id="' + x + '"]').join(", ")
        }
        let elts = this._cy.elements(selectors)
        if (elements.visible) {
            elts.style('display', 'element')
        } else {
            elts.style('display', 'none')
        }

        this.sendNewGraphState("Filter")
    }

    /**
     * Add event "doubleTap" to cy
     *
     */
    _registerDoubleTapEvent() {
        let tappedBefore
        let tappedTimeout
        this._cy.on('tap', (event) => {
            let tappedNow = event.target
            if (tappedTimeout && tappedBefore) {
                clearTimeout(tappedTimeout)
            }

            if (tappedBefore == tappedNow) {
                tappedNow.emit('doubleTap')
                tappedBefore = null
            } else {
                tappedTimeout = setTimeout( () => tappedBefore = null, 300)
                tappedBefore = tappedNow
            }
        })
    }
}