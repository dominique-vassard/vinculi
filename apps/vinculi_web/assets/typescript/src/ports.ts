interface Callbacks {
    [callbackName: string]: Function
}

export default class Ports {
    callbacks: Callbacks
    private readonly _elmApp: any

    constructor(elmApp: any) {
        this.callbacks = {}
        this._elmApp = elmApp
    }

    addCallback(callbackName: string, callbackFn: Function): Ports {
        this.callbacks[callbackName] = callbackFn
        return this
    }

    async initGraphPort(callback: Function): Promise<cytoscape.ElementDefinition[]> {
        const res = await this._initGraphPort(callback)
        return res
    }

    private _initGraphPort(callback): Promise<cytoscape.ElementDefinition[]> {
        return new Promise((resolve) => {
            this._elmApp.ports.initGraph.subscribe(function(newGraph) {
                resolve(callback(newGraph))
            })
        })
    }

    getLocalGraph(data) {
        console.log("Send data")
        this._elmApp.ports.getLocalGraph.send(data)
    }

    // initPorts(): void {
    //     this.initGraphPort(this.callbacks["initGraphPort"])
    // }

    postInit(): void {
        this._elmApp.ports.initGraph.unsubscribe(this.callbacks["initGraphPort"])

        // Ports that send back a local graph
        this._elmApp.ports.addToGraph.subscribe(this.callbacks["getLocalGraph"])
    }
}