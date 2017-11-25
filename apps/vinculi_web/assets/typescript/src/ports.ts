/**
 * Callbacks interface definition
 */
export interface Callbacks {
    [category:string]: {
        [callbackName: string]: Function
    }
}

/**
 * NodeSearchData type definition
 * @type {Object}
 */
export type NodeSearchData = {
    uuid: string
    labels: string[]
}

/**
 * Class which manages ports: Communication with Elm
 */
export class Ports {
    /**
     * List of port callbacks, formated as:
     * {
     *         "init": {
     *             // List of ports used during initialsiation
     *             portName : port Function,
     *             ...
     *         },
     * "runtime": {
     *             // List of ports used during runtime
     * portName : port Function,
     *             ...
     *         }
     *     }
     *
     * IMPORTANT: portName must match the Elm port name
     * Example:
     *     if (un) subscription use: `Elm.ports.initGraph.subscribe`
     * Then portName must be` initGraph`
     *
     * Init port will be deactived post initialisation.
     * @type {Callbacks}
     */
    private _callbacks: Callbacks

    /**
     * The Elm application to communicate with
     * @type {any}
     */
    private readonly _elmApp: any

    /**
     * Cosntrucs the Ports object
     *
     * @param {any}         ElmApp       The elm application to use (for ports init)
     * @param {Callbacks}   callbacks    The callbacks to use for each ports
     */
    constructor(elmApp: any, callbacks:Callbacks) {
        this._callbacks = callbacks
        this._elmApp = elmApp
    }

    /////////////////////////////////////////////////////////////////
    //                            INITS                            //
    /////////////////////////////////////////////////////////////////

    /**
     * Async function which fetch/wait for initial graph data
     *
     * @param  {Function}                                 callback    The function to call when adata is received
     * @return {Promise<cytoscape.ElementDefinition[]>}               The initial graph data
     */
    async initGraphPort(callback: Function): Promise<cytoscape.ElementDefinition[]> {
        const res = await this._initGraphPort(callback)
        return res
    }

    /**
     * Port to receive initial graph data
     *
     * @param  {Function}                                 callback    The function to call when adata is received
     * @return {Promise<cytoscape.ElementDefinition[]>}               The initial graph data
     */
    private _initGraphPort(callback: Function): Promise<cytoscape.ElementDefinition[]> {
        return new Promise((resolve) => {
            this._elmApp.ports.initGraph.subscribe(function(newGraph) {
                resolve(callback(newGraph))
            })
        })
    }

    /**
     * Deactivate init ports
     * Activate runtime ports
     *
     * @returns void
     *
     */
    postInit(): void {
        // Deactivate now useless init ports
        for (let [callbackName, callbackFunc] of Object.entries(this._callbacks["init"])) {
            this._elmApp.ports[callbackName].unsubscribe(callbackFunc)
        }

        // Activate all ports required at runtile
        for (let [callbackName, callbackFunc] of Object.entries(this._callbacks["runtime"])) {
            this._elmApp.ports[callbackName].subscribe(callbackFunc)
        }
    }

    /////////////////////////////////////////////////////////////////
    //                         >OUT PORTS                          //
    /////////////////////////////////////////////////////////////////
    /**
     * @param {NodeSearchData}   data    The node to search for which ask for data
     *
     * @returns void
     */
    getLocalGraph(data: NodeSearchData):void {
        this._elmApp.ports.getLocalGraph.send(data)
    }


}