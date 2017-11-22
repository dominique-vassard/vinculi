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
var GraphManager = /** @class */ (function () {
    // currentNode: cytoscape.NodeSingular | null
    function GraphManager(ports) {
        var _this = this;
        this._ports = ports;
        this._cy = cytoscape();
        this._currentNode = null;
        ports.addCallback("initGraphPort", function (initialGraph) {
            _this.initGraph(initialGraph);
        });
        ports.addCallback("getLocalGraph", function (localGraph) {
            _this.addData(localGraph);
        });
    }
    GraphManager.prototype.init = function () {
        return __awaiter(this, void 0, void 0, function () {
            var _this = this;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0: return [4 /*yield*/, this._ports.initGraphPort(function (newGraph) {
                            _this.initGraph(newGraph);
                        })];
                    case 1:
                        _a.sent();
                        return [2 /*return*/, this];
                }
            });
        });
    };
    GraphManager.prototype.initGraph = function (initialGraph) {
        this._cy = cytoscape({
            container: document.getElementById('cy'),
            elements: initialGraph,
            style: $.ajax({
                url: 'http://localhost:4000/graph_style/graph.css',
                type: 'GET',
                dataType: 'text',
            }),
            layout: {
                name: 'concentric',
                animate: true,
                avoidOverlap: true
            }
        });
        this._currentNode = null;
        // InitGraphPort is not useful anymore
        // Then unsuscribe
        this._ports.postInit();
        this.initHandlers();
    };
    GraphManager.prototype.initHandlers = function () {
        var _this = this;
        this._cy.on('click', 'node', function (event) { _this.nodeDeploymentHandler(event); });
    };
    GraphManager.prototype.nodeDeploymentHandler = function (event) {
        console.log(this);
        var node = event.target;
        console.log(node.id());
        console.log(node.data()["labels"]);
        var data = {
            "uuid": node.id(),
            "labels": node.data()["labels"]
        };
        this._currentNode = node;
        this._ports.getLocalGraph(data);
        // elmApp.ports.getLocalGraph.send(data)
    };
    GraphManager.prototype.addData = function (localGraph) {
        console.log("Add data");
        console.log(localGraph);
        var layout_config = { "name": 'concentric',
            "boundingBox": this.getBoundingBox(),
            "animate": true };
        console.log(layout_config);
        this._cy.add(localGraph).layout(layout_config).run();
        console.log(this.cy.elements().jsons());
    };
    GraphManager.prototype.getBoundingBox = function () {
        //Padding around deployed node
        var padding = 400;
        //Determine node position from border
        var node = this._currentNode;
        if (!node) {
            return;
        }
        var bbox = this._cy.elements().boundingBox();
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
            "y1": node.position('y') - padding / 2,
            "w": padding,
            "h": padding
        };
        return bb;
    };
    Object.defineProperty(GraphManager.prototype, "cy", {
        get: function () {
            return this._cy;
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(GraphManager.prototype, "currentNode", {
        get: function () {
            return this._currentNode;
        },
        enumerable: true,
        configurable: true
    });
    return GraphManager;
}());
exports.GraphManager = GraphManager;
