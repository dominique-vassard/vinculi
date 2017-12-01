"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = y[op[0] & 2 ? "return" : op[0] ? "throw" : "next"]) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [0, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
Object.defineProperty(exports, "__esModule", { value: true });
var cytoscape = require("cytoscape");
var Ports = require("./ports");
/**
 * Class responsible for all graph operations, comunication with Elm ports
 */
var GraphManager = /** @class */ (function () {
    /**
     * Constructs the graphManager
     *
     * @param {any}       ElmApp       The elm application to use (for ports init)
     * @param {string}    serverUrl    The server url to use to get sylesheet
     */
    function GraphManager(elmApp, serverUrl) {
        var _this = this;
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
        this._portCallbacks = {
            "init": {
                "initGraph": function (initialGraph) {
                    _this.initGraph(initialGraph);
                },
            },
            "runtime": {
                "addToGraph": function (localGraph) {
                    _this.addData(localGraph);
                }
            }
        };
        this._serverUrl = serverUrl;
        this._cy = cytoscape();
        this._ports = new Ports.Ports(elmApp, this._portCallbacks);
        this._currentNode = undefined;
    }
    /**
     *  Initiliaze graph Manager: get style and initial graph data
     *
     * @return {Promise<GraphManager>}   The initialized graph Manager
     */
    GraphManager.prototype.init = function () {
        return __awaiter(this, void 0, void 0, function () {
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0: return [4 /*yield*/, this._ports.initGraphPort(this._portCallbacks["init"]["initGraph"])];
                    case 1:
                        _a.sent();
                        return [2 /*return*/, this];
                }
            });
        });
    };
    /**
     * Handlers intialization
     *
     * TODO: Manage modes
     *
     */
    GraphManager.prototype.initHandlers = function () {
        var _this = this;
        // Double tap: deploy node
        this._cy.on('doubleTap', 'node', function (event) { _this.nodeDeploymentHandler(event); });
        // Tap on canvas: unpin node infos
        this._cy.on('tap', function (event) { _this.unpinNodeInfosHandler(event); });
        // Tap on node: pin node infos
        this._cy.on('tap', 'node', function (event) { _this.pinNodeInfosHandler(event); });
        // Mouseover node: display node infos
        this._cy.on('mouseover', 'node', function (event) { _this.showNodeInfosHandler(event); });
        // Mouseout node :hide node infos
        this._cy.on('mouseout', 'node', function (event) { _this.hideNodeInfosHandler(event); });
        return this;
    };
    /**
     * Computes the current bounding box
     * in order to display new data elegantly
     *
     * @returns  {cytoscape.BoundingBox12}  A valid bound box where to dispaly new data
     *
     */
    GraphManager.prototype.getBoundingBox = function () {
        //Padding around deployed node
        var padding = 400;
        //Determine node position from border
        var node = this._currentNode;
        if (node == undefined) {
            return;
        }
        var bbox = this._cy.elements().boundingBox({});
        var nodePos = node.position();
        var distR, distL, distT, distB, minDist, bb;
        distR = nodePos.x - bbox.x1;
        distL = bbox.x2 - nodePos.x;
        distT = nodePos.y - bbox.y1;
        distB = bbox.y2 - nodePos.y;
        //Detach node from original circle
        minDist = Math.min(distR, distL, distT, distB);
        if (distR == minDist) {
            node.position('x', nodePos.x - padding);
        }
        else if (distL == minDist) {
            node.position('x', nodePos.x + padding);
        }
        else if (distT == minDist) {
            node.position('y', nodePos.y - padding);
        }
        else {
            node.position('y', nodePos.y + padding);
        }
        //Define new node bounding box
        bb = {
            "x1": node.position().x - padding / 2,
            "y1": node.position().y - padding / 2,
            "w": padding,
            "h": padding
        };
        return bb;
    };
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
     * @param  cytoscape.EventObject   event    Event attached to this method (double on node)
     * @return void
     */
    GraphManager.prototype.nodeDeploymentHandler = function (event) {
        var node = event.target;
        var data = {
            "uuid": node.id(),
            "labels": node.data()["labels"]
        };
        this._currentNode = node;
        this._ports.getLocalGraph(data);
    };
    /**
     * Manage node infos displaying
     * Send node uuid to Elm for displaying
     *
     * @param  cytoscape.EventObject   event    Event attached to this method (mouseover node)
     * @return void
     */
    GraphManager.prototype.showNodeInfosHandler = function (event) {
        var node = event.target;
        this._ports.sendNodeIdToDisplay(node.id());
    };
    /**
     * Manage node infos hiding
     * Send command to Elm for hiding node infos
     *
     * @param  cytoscape.EventObject   event    Event attached to this method (mouseout node)
     * @return void
     */
    GraphManager.prototype.hideNodeInfosHandler = function (event) {
        this._ports.sendHideNodeCommand();
    };
    /**
     * Manage node infos pinning
     * Send command to Elm for pinning
     *
     * @param  cytoscape.EventObject   event    Event attached to this method (click/tap on node)
     * @return void
     */
    GraphManager.prototype.pinNodeInfosHandler = function (event) {
        var node = event.target;
        this._ports.sendPinNodeCommand(true);
    };
    /**
     * Manage node infos unpinning
     * Send command to Elm for unpinning
     *
     * @param  cytoscape.EventObject   event    Event attached to this method (click/tap on canvas)
     * @return void
     */
    GraphManager.prototype.unpinNodeInfosHandler = function (event) {
        var target = event.target;
        if (target === this._cy) {
            this._ports.sendPinNodeCommand(false);
        }
    };
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
    GraphManager.prototype.initGraph = function (initialGraph) {
        this._cy = cytoscape({
            container: document.getElementById('cy'),
            elements: initialGraph,
            style: this.getStyleSheet(),
            layout: {
                name: 'concentric',
                // fit: false,
                animate: true,
                avoidOverlap: true,
                spacingFactor: 3
            }
        });
        this._currentNode = undefined;
        // InitGraphPort is not useful anymore
        // Then unsuscribe
        this._ports.postInit();
        this._registerDoubleTapEvent();
        this.initHandlers();
        // for some reason, this._cy.elements is not yet accessbile
        // Then we don't send graph state, it will be with the first action on graph
        // this.sendNewGraphState()
    };
    /**
     * Retrieves stylesheet from server
     *
     * @return {Promise<string>}  The promise with the retrieved stylesheet
     */
    GraphManager.prototype.getStyleSheet = function () {
        var _this = this;
        var promise = new Promise(function (resolve, reject) {
            var request = new XMLHttpRequest();
            request.open('GET', _this._serverUrl + '/graph_style/graph.css');
            request.onload = function () {
                if (request.status >= 200 && request.status < 400) {
                    resolve(request.responseText);
                }
                else {
                    reject("Cannot retrieve stylesheet");
                }
            };
            request.onerror = function () { reject("Cannot retrieve stylesheet"); };
            request.send();
        });
        return promise;
    };
    /**
     * Add new local graph to current graph
     * If ther is some:
     *     - display lcoal graph nodes and edges
     *     - focus on them
     *
     * @param {cytoscape.ElementDefinition[]}    localGaph    The received local graph data
     */
    GraphManager.prototype.addData = function (localGraph) {
        var layout_config = {
            name: 'concentric',
            boundingBox: this.getBoundingBox(),
            animate: true,
            spacingFactor: 3
        };
        this._cy.add(localGraph).layout(layout_config).run();
        this.sendNewGraphState();
    };
    /**
     * Send new graph state to Elm
     *
     * @returns void
     */
    GraphManager.prototype.sendNewGraphState = function () {
        this._ports.sendNewGraphState(this._cy.elements().jsons());
    };
    /**
     * Add event "doubleTap" to cy
     *
     */
    GraphManager.prototype._registerDoubleTapEvent = function () {
        var tappedBefore;
        var tappedTimeout;
        this._cy.on('tap', function (event) {
            var tappedNow = event.target;
            if (tappedTimeout && tappedBefore) {
                clearTimeout(tappedTimeout);
            }
            if (tappedBefore == tappedNow) {
                tappedNow.emit('doubleTap');
                tappedBefore = null;
            }
            else {
                tappedTimeout = setTimeout(function () { return tappedBefore = null; }, 300);
                tappedBefore = tappedNow;
            }
        });
    };
    return GraphManager;
}());
exports.GraphManager = GraphManager;
