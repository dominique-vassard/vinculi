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
/**
 * Class which manages ports: Communication with Elm
 */
var Ports = /** @class */ (function () {
    /**
     * Cosntrucs the Ports object
     *
     * @param {any}         ElmApp       The elm application to use (for ports init)
     * @param {Callbacks}   callbacks    The callbacks to use for each ports
     */
    function Ports(elmApp, callbacks) {
        this._callbacks = callbacks;
        this._elmApp = elmApp;
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
    Ports.prototype.initGraphPort = function (callback) {
        return __awaiter(this, void 0, void 0, function () {
            var res;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0: return [4 /*yield*/, this._initGraphPort(callback)];
                    case 1:
                        res = _a.sent();
                        return [2 /*return*/, res];
                }
            });
        });
    };
    /**
     * Port to receive initial graph data
     *
     * @param  {Function}                                 callback    The function to call when adata is received
     * @return {Promise<cytoscape.ElementDefinition[]>}               The initial graph data
     */
    Ports.prototype._initGraphPort = function (callback) {
        var _this = this;
        return new Promise(function (resolve) {
            _this._elmApp.ports.initGraph.subscribe(function (newGraph) {
                resolve(callback(newGraph));
            });
        });
    };
    /**
     * Deactivate init ports
     * Activate runtime ports
     *
     * @returns void
     *
     */
    Ports.prototype.postInit = function () {
        // Deactivate now useless init ports
        for (var _i = 0, _a = Object.entries(this._callbacks["init"]); _i < _a.length; _i++) {
            var _b = _a[_i], callbackName = _b[0], callbackFunc = _b[1];
            this._elmApp.ports[callbackName].unsubscribe(callbackFunc);
        }
        // Activate all ports required at runtime
        for (var _c = 0, _d = Object.entries(this._callbacks["runtime"]); _c < _d.length; _c++) {
            var _e = _d[_c], callbackName = _e[0], callbackFunc = _e[1];
            this._elmApp.ports[callbackName].subscribe(callbackFunc);
        }
    };
    /////////////////////////////////////////////////////////////////
    //                         >OUT PORTS                          //
    /////////////////////////////////////////////////////////////////
    /**
     * @param {NodeSearchData}   data    The node to search for which ask for data
     *
     * @returns void
     */
    Ports.prototype.getLocalGraph = function (data) {
        this._elmApp.ports.getLocalGraph.send(data);
    };
    /**
     * Send new graph state to Elm for further computations / displays / etc.
     *
     * @param {GraphState}   data     The actualized graph state and a description
     *
     * @returns void
     */
    Ports.prototype.sendNewGraphState = function (data) {
        this._elmApp.ports.newGraphState.send(data);
    };
    /**
     * Send Elm a command in order to pin its infos
     *
     * @param {boolean}   pin         True to tpin, False to unpin
     *
     * @returns void
     */
    Ports.prototype.sendPinNodeCommand = function (pin) {
        this._elmApp.ports.pinNodeInfos.send(pin);
    };
    /**
     * Send Elm a element uuid in order to display its infos
     *
     * @param {string} elementId       The id of the element to display
     * @param {string} elementType     The type of the element to display
     */
    Ports.prototype.sendElementIdToDisplay = function (elementId, elementType) {
        var params = {
            "id": elementId,
            "elementType": elementType
        };
        this._elmApp.ports.displayElementInfos.send(params);
    };
    /**
     * Send Elm a command in order to hide an elment's infos
     *
     * @param {string} elementType     The type of the element to display
     *
     * @returns void
     */
    Ports.prototype.hideElementInfos = function (elementType) {
        this._elmApp.ports.hideElementInfos.send(elementType);
    };
    /**
     * Send Elm a command in order to pin an elment's infos
     *
     * @param {string} elementType     The type of the element to display
     * @param {boolean}   pin         True to tpin, False to unpin
     *
     * @returns void
     */
    Ports.prototype.sendElementIdToPin = function (elementType, pin) {
        var params = {
            "elementType": elementType,
            "pin": pin
        };
        this._elmApp.ports.pinElementInfos.send(params);
    };
    return Ports;
}());
exports.Ports = Ports;
