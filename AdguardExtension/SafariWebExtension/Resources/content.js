/******/ (() => { // webpackBootstrap
/******/ 	var __webpack_modules__ = ({

/***/ "./node_modules/@babel/runtime/helpers/esm/arrayLikeToArray.js":
/*!*********************************************************************!*\
  !*** ./node_modules/@babel/runtime/helpers/esm/arrayLikeToArray.js ***!
  \*********************************************************************/
/***/ ((__unused_webpack___webpack_module__, __webpack_exports__, __webpack_require__) => {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": () => (/* binding */ _arrayLikeToArray)
/* harmony export */ });
function _arrayLikeToArray(arr, len) {
  if (len == null || len > arr.length) len = arr.length;

  for (var i = 0, arr2 = new Array(len); i < len; i++) {
    arr2[i] = arr[i];
  }

  return arr2;
}

/***/ }),

/***/ "./node_modules/@babel/runtime/helpers/esm/arrayWithoutHoles.js":
/*!**********************************************************************!*\
  !*** ./node_modules/@babel/runtime/helpers/esm/arrayWithoutHoles.js ***!
  \**********************************************************************/
/***/ ((__unused_webpack___webpack_module__, __webpack_exports__, __webpack_require__) => {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": () => (/* binding */ _arrayWithoutHoles)
/* harmony export */ });
/* harmony import */ var _arrayLikeToArray_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./arrayLikeToArray.js */ "./node_modules/@babel/runtime/helpers/esm/arrayLikeToArray.js");

function _arrayWithoutHoles(arr) {
  if (Array.isArray(arr)) return (0,_arrayLikeToArray_js__WEBPACK_IMPORTED_MODULE_0__.default)(arr);
}

/***/ }),

/***/ "./node_modules/@babel/runtime/helpers/esm/asyncToGenerator.js":
/*!*********************************************************************!*\
  !*** ./node_modules/@babel/runtime/helpers/esm/asyncToGenerator.js ***!
  \*********************************************************************/
/***/ ((__unused_webpack___webpack_module__, __webpack_exports__, __webpack_require__) => {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": () => (/* binding */ _asyncToGenerator)
/* harmony export */ });
function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) {
  try {
    var info = gen[key](arg);
    var value = info.value;
  } catch (error) {
    reject(error);
    return;
  }

  if (info.done) {
    resolve(value);
  } else {
    Promise.resolve(value).then(_next, _throw);
  }
}

function _asyncToGenerator(fn) {
  return function () {
    var self = this,
        args = arguments;
    return new Promise(function (resolve, reject) {
      var gen = fn.apply(self, args);

      function _next(value) {
        asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value);
      }

      function _throw(err) {
        asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err);
      }

      _next(undefined);
    });
  };
}

/***/ }),

/***/ "./node_modules/@babel/runtime/helpers/esm/iterableToArray.js":
/*!********************************************************************!*\
  !*** ./node_modules/@babel/runtime/helpers/esm/iterableToArray.js ***!
  \********************************************************************/
/***/ ((__unused_webpack___webpack_module__, __webpack_exports__, __webpack_require__) => {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": () => (/* binding */ _iterableToArray)
/* harmony export */ });
function _iterableToArray(iter) {
  if (typeof Symbol !== "undefined" && iter[Symbol.iterator] != null || iter["@@iterator"] != null) return Array.from(iter);
}

/***/ }),

/***/ "./node_modules/@babel/runtime/helpers/esm/nonIterableSpread.js":
/*!**********************************************************************!*\
  !*** ./node_modules/@babel/runtime/helpers/esm/nonIterableSpread.js ***!
  \**********************************************************************/
/***/ ((__unused_webpack___webpack_module__, __webpack_exports__, __webpack_require__) => {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": () => (/* binding */ _nonIterableSpread)
/* harmony export */ });
function _nonIterableSpread() {
  throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.");
}

/***/ }),

/***/ "./node_modules/@babel/runtime/helpers/esm/toConsumableArray.js":
/*!**********************************************************************!*\
  !*** ./node_modules/@babel/runtime/helpers/esm/toConsumableArray.js ***!
  \**********************************************************************/
/***/ ((__unused_webpack___webpack_module__, __webpack_exports__, __webpack_require__) => {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": () => (/* binding */ _toConsumableArray)
/* harmony export */ });
/* harmony import */ var _arrayWithoutHoles_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./arrayWithoutHoles.js */ "./node_modules/@babel/runtime/helpers/esm/arrayWithoutHoles.js");
/* harmony import */ var _iterableToArray_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./iterableToArray.js */ "./node_modules/@babel/runtime/helpers/esm/iterableToArray.js");
/* harmony import */ var _unsupportedIterableToArray_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./unsupportedIterableToArray.js */ "./node_modules/@babel/runtime/helpers/esm/unsupportedIterableToArray.js");
/* harmony import */ var _nonIterableSpread_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./nonIterableSpread.js */ "./node_modules/@babel/runtime/helpers/esm/nonIterableSpread.js");




function _toConsumableArray(arr) {
  return (0,_arrayWithoutHoles_js__WEBPACK_IMPORTED_MODULE_0__.default)(arr) || (0,_iterableToArray_js__WEBPACK_IMPORTED_MODULE_1__.default)(arr) || (0,_unsupportedIterableToArray_js__WEBPACK_IMPORTED_MODULE_2__.default)(arr) || (0,_nonIterableSpread_js__WEBPACK_IMPORTED_MODULE_3__.default)();
}

/***/ }),

/***/ "./node_modules/@babel/runtime/helpers/esm/unsupportedIterableToArray.js":
/*!*******************************************************************************!*\
  !*** ./node_modules/@babel/runtime/helpers/esm/unsupportedIterableToArray.js ***!
  \*******************************************************************************/
/***/ ((__unused_webpack___webpack_module__, __webpack_exports__, __webpack_require__) => {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": () => (/* binding */ _unsupportedIterableToArray)
/* harmony export */ });
/* harmony import */ var _arrayLikeToArray_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./arrayLikeToArray.js */ "./node_modules/@babel/runtime/helpers/esm/arrayLikeToArray.js");

function _unsupportedIterableToArray(o, minLen) {
  if (!o) return;
  if (typeof o === "string") return (0,_arrayLikeToArray_js__WEBPACK_IMPORTED_MODULE_0__.default)(o, minLen);
  var n = Object.prototype.toString.call(o).slice(8, -1);
  if (n === "Object" && o.constructor) n = o.constructor.name;
  if (n === "Map" || n === "Set") return Array.from(o);
  if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return (0,_arrayLikeToArray_js__WEBPACK_IMPORTED_MODULE_0__.default)(o, minLen);
}

/***/ }),

/***/ "./node_modules/@babel/runtime/regenerator/index.js":
/*!**********************************************************!*\
  !*** ./node_modules/@babel/runtime/regenerator/index.js ***!
  \**********************************************************/
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

module.exports = __webpack_require__(/*! regenerator-runtime */ "./node_modules/regenerator-runtime/runtime.js");


/***/ }),

/***/ "./src/pages/common/constants.ts":
/*!***************************************!*\
  !*** ./src/pages/common/constants.ts ***!
  \***************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "MessagesToNativeApp": () => (/* binding */ MessagesToNativeApp),
/* harmony export */   "MessagesToBackgroundPage": () => (/* binding */ MessagesToBackgroundPage),
/* harmony export */   "MessagesToContentScript": () => (/* binding */ MessagesToContentScript),
/* harmony export */   "AppearanceTheme": () => (/* binding */ AppearanceTheme),
/* harmony export */   "APPEARANCE_THEME_DEFAULT": () => (/* binding */ APPEARANCE_THEME_DEFAULT),
/* harmony export */   "WEB_EXTENSION_MORE_URL": () => (/* binding */ WEB_EXTENSION_MORE_URL),
/* harmony export */   "Platforms": () => (/* binding */ Platforms)
/* harmony export */ });
var MessagesToNativeApp;

(function (MessagesToNativeApp) {
  MessagesToNativeApp["WriteInNativeLog"] = "writeInNativeLog";
  MessagesToNativeApp["GetAdvancedRulesText"] = "get_advanced_rules_text";
  MessagesToNativeApp["GetInitData"] = "get_init_data";
  MessagesToNativeApp["ShouldUpdateAdvancedRules"] = "should_update_advanced_rules";
})(MessagesToNativeApp || (MessagesToNativeApp = {}));

var MessagesToBackgroundPage;

(function (MessagesToBackgroundPage) {
  MessagesToBackgroundPage["OpenAssistant"] = "open_assistant";
  MessagesToBackgroundPage["GetScriptsAndSelectors"] = "get_scripts_and_selectors";
  MessagesToBackgroundPage["AddRule"] = "add_rule";
  MessagesToBackgroundPage["GetPopupData"] = "get_popup_data";
  MessagesToBackgroundPage["SetPermissionsModalViewed"] = "set_permissions_modal_viewed";
  MessagesToBackgroundPage["SetProtectionStatus"] = "set_protection_status";
  MessagesToBackgroundPage["DeleteUserRulesByUrl"] = "delete_user_rules_by_url";
  MessagesToBackgroundPage["ReportProblem"] = "report_problem";
  MessagesToBackgroundPage["UpgradeClicked"] = "upgrade_clicked";
  MessagesToBackgroundPage["EnableAdvancedBlocking"] = "enable_advanced_blocking";
})(MessagesToBackgroundPage || (MessagesToBackgroundPage = {}));

var MessagesToContentScript;

(function (MessagesToContentScript) {
  MessagesToContentScript["InitAssistant"] = "init_assistant";
})(MessagesToContentScript || (MessagesToContentScript = {}));

var AppearanceTheme;

(function (AppearanceTheme) {
  AppearanceTheme["System"] = "system";
  AppearanceTheme["Dark"] = "dark";
  AppearanceTheme["Light"] = "light";
})(AppearanceTheme || (AppearanceTheme = {}));

var APPEARANCE_THEME_DEFAULT = AppearanceTheme.System;
var WEB_EXTENSION_MORE_URL = 'https://adguard.com/forward.html?action=web_extension_more&from=popup&app=ios';
var Platforms;

(function (Platforms) {
  Platforms["IPad"] = "ipad";
  Platforms["IPhone"] = "iphone";
})(Platforms || (Platforms = {}));

/***/ }),

/***/ "./src/pages/content/content.ts":
/*!**************************************!*\
  !*** ./src/pages/content/content.ts ***!
  \**************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "content": () => (/* binding */ content)
/* harmony export */ });
/* harmony import */ var _babel_runtime_helpers_toConsumableArray__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @babel/runtime/helpers/toConsumableArray */ "./node_modules/@babel/runtime/helpers/esm/toConsumableArray.js");
/* harmony import */ var _babel_runtime_helpers_asyncToGenerator__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @babel/runtime/helpers/asyncToGenerator */ "./node_modules/@babel/runtime/helpers/esm/asyncToGenerator.js");
/* harmony import */ var _babel_runtime_regenerator__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! @babel/runtime/regenerator */ "./node_modules/@babel/runtime/regenerator/index.js");
/* harmony import */ var _babel_runtime_regenerator__WEBPACK_IMPORTED_MODULE_2___default = /*#__PURE__*/__webpack_require__.n(_babel_runtime_regenerator__WEBPACK_IMPORTED_MODULE_2__);
/* harmony import */ var webextension_polyfill__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! webextension-polyfill */ "./node_modules/webextension-polyfill/dist/browser-polyfill.js");
/* harmony import */ var webextension_polyfill__WEBPACK_IMPORTED_MODULE_3___default = /*#__PURE__*/__webpack_require__.n(webextension_polyfill__WEBPACK_IMPORTED_MODULE_3__);
/* harmony import */ var extended_css__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! extended-css */ "./node_modules/extended-css/dist/extended-css.esm.js");
/* harmony import */ var _common_constants__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ../common/constants */ "./src/pages/common/constants.ts");




/* eslint-disable no-console */




/**
 * Logs a message if verbose is true
 *
 * @param verbose
 * @param message
 */
var logMessage = function logMessage(verbose, message) {
  if (verbose) {
    console.log("(AG) ".concat(message));
  }
};

var getSelectorsAndScripts = /*#__PURE__*/function () {
  var _ref = (0,_babel_runtime_helpers_asyncToGenerator__WEBPACK_IMPORTED_MODULE_1__.default)( /*#__PURE__*/_babel_runtime_regenerator__WEBPACK_IMPORTED_MODULE_2___default().mark(function _callee() {
    var response;
    return _babel_runtime_regenerator__WEBPACK_IMPORTED_MODULE_2___default().wrap(function _callee$(_context) {
      while (1) {
        switch (_context.prev = _context.next) {
          case 0:
            _context.next = 2;
            return webextension_polyfill__WEBPACK_IMPORTED_MODULE_3___default().runtime.sendMessage({
              type: _common_constants__WEBPACK_IMPORTED_MODULE_5__.MessagesToBackgroundPage.GetScriptsAndSelectors,
              data: {
                url: window.location.href
              }
            });

          case 2:
            response = _context.sent;

            if (!(response === null)) {
              _context.next = 6;
              break;
            }

            console.log('AG: no scripts and selectors received');
            return _context.abrupt("return", null);

          case 6:
            return _context.abrupt("return", response);

          case 7:
          case "end":
            return _context.stop();
        }
      }
    }, _callee);
  }));

  return function getSelectorsAndScripts() {
    return _ref.apply(this, arguments);
  };
}();
/**
 * Execute scripts in a page context and cleanup itself when execution completes
 * @param scripts Scripts array to execute
 */


var executeScripts = function executeScripts(scripts) {
  // Wrap with try catch
  var start = '( function () { try {';
  var end = "} catch (ex) { console.error('Error executing AG js: ' + ex); } })();";
  var updated = [start].concat((0,_babel_runtime_helpers_toConsumableArray__WEBPACK_IMPORTED_MODULE_0__.default)(scripts), [end]);
  var scriptTag = document.createElement('script');
  scriptTag.setAttribute('type', 'text/javascript');
  scriptTag.textContent = updated.join('\r\n');
  var parent = document.head || document.documentElement;
  parent.appendChild(scriptTag);

  if (scriptTag.parentNode) {
    scriptTag.parentNode.removeChild(scriptTag);
  }
};
/**
 * Applies JS injections.
 * @param scripts Array with JS scripts
 * @param verbose logging
 */


var applyScripts = function applyScripts(scripts, verbose) {
  if (!scripts || scripts.length === 0) {
    return;
  }

  logMessage(verbose, "scripts length: ".concat(scripts.length));
  executeScripts(scripts.reverse());
};
/**
 * Protects specified style element from changes to the current document
 * Add a mutation observer, which is adds our rules again if it was removed
 *
 * @param protectStyleEl protected style element
 */


var protectStyleElementContent = function protectStyleElementContent(protectStyleEl) {
  // @ts-ignore
  var MutationObserver = window.MutationObserver || window.WebKitMutationObserver;

  if (!MutationObserver) {
    return;
  }
  /* observer, which observe protectStyleEl inner changes, without deleting styleEl */


  var innerObserver = new MutationObserver(function (mutations) {
    for (var i = 0; i < mutations.length; i += 1) {
      var m = mutations[i]; // @ts-ignore

      if (protectStyleEl.hasAttribute('mod') && protectStyleEl.getAttribute('mod') === 'inner') {
        // @ts-ignore
        protectStyleEl.removeAttribute('mod');
        break;
      } // @ts-ignore


      protectStyleEl.setAttribute('mod', 'inner');
      var isProtectStyleElModified = false;
      /**
       * further, there are two mutually exclusive situations: either there were changes
       * the text of protectStyleEl, either there was removes a whole child "text"
       * element of protectStyleEl we'll process both of them
       */

      if (m.removedNodes.length > 0) {
        for (var j = 0; j < m.removedNodes.length; j += 1) {
          isProtectStyleElModified = true;
          protectStyleEl.appendChild(m.removedNodes[j]);
        }
      } else if (m.oldValue) {
        isProtectStyleElModified = true; // eslint-disable-next-line no-param-reassign

        protectStyleEl.textContent = m.oldValue;
      }

      if (!isProtectStyleElModified) {
        // @ts-ignore
        protectStyleEl.removeAttribute('mod');
      }
    }
  });
  innerObserver.observe(protectStyleEl, {
    childList: true,
    characterData: true,
    subtree: true,
    characterDataOldValue: true
  });
};
/**
 * Applies css stylesheet
 * @param styleSelectors Array of stylesheets or selectors
 * @param verbose logging
 */


var applyCss = function applyCss(styleSelectors, verbose) {
  if (!styleSelectors || !styleSelectors.length) {
    return;
  }

  logMessage(verbose, "css length: ".concat(styleSelectors.length));
  var styleElement = document.createElement('style');
  styleElement.setAttribute('type', 'text/css');
  (document.head || document.documentElement).appendChild(styleElement);
  var selectors = styleSelectors.map(function (s) {
    return s.trim();
  });
  selectors.forEach(function (selector) {
    try {
      var _styleElement$sheet;

      (_styleElement$sheet = styleElement.sheet) === null || _styleElement$sheet === void 0 ? void 0 : _styleElement$sheet.insertRule(selector);
    } catch (e) {
      logMessage(verbose, "Was unable to inject selector: ".concat(selector, ", due to error: ").concat(e));
    }
  });
  protectStyleElementContent(styleElement);
};
/**
 * Applies Extended Css stylesheet
 *
 * @param extendedCss Array with ExtendedCss stylesheets
 * @param verbose logging
 */


var applyExtendedCss = function applyExtendedCss(extendedCss, verbose) {
  if (!extendedCss || !extendedCss.length) {
    return;
  }

  logMessage(verbose, "extended css length: ".concat(extendedCss.length));
  var extcss = new extended_css__WEBPACK_IMPORTED_MODULE_4__.default({
    styleSheet: extendedCss.filter(function (s) {
      return s.length > 0;
    }).map(function (s) {
      return s.trim();
    }).map(function (s) {
      return s[s.length - 1] !== '}' ? "".concat(s, " {display:none!important;}") : s;
    }).join('\n')
  });
  extcss.apply();
};
/**
 * Applies injected script and css
 *
 * @param selectorsAndScripts
 * @param verbose
 */


var applyAdvancedBlockingData = function applyAdvancedBlockingData(selectorsAndScripts) {
  var verbose = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : true;
  logMessage(verbose, 'Applying scripts and css..');
  logMessage(verbose, "Frame url: ".concat(window.location.href));
  applyScripts(selectorsAndScripts.scripts, verbose);
  applyCss(selectorsAndScripts.cssInject, verbose);
  applyExtendedCss(selectorsAndScripts.cssExtended, verbose);
  logMessage(verbose, 'Applying scripts and css - done');
};

var init = /*#__PURE__*/function () {
  var _ref2 = (0,_babel_runtime_helpers_asyncToGenerator__WEBPACK_IMPORTED_MODULE_1__.default)( /*#__PURE__*/_babel_runtime_regenerator__WEBPACK_IMPORTED_MODULE_2___default().mark(function _callee2() {
    var startGettingScripts, selectorsAndScripts;
    return _babel_runtime_regenerator__WEBPACK_IMPORTED_MODULE_2___default().wrap(function _callee2$(_context2) {
      while (1) {
        switch (_context2.prev = _context2.next) {
          case 0:
            if (!(document instanceof HTMLDocument)) {
              _context2.next = 14;
              break;
            }

            if (!(window.location.href && window.location.href.indexOf('http') === 0)) {
              _context2.next = 14;
              break;
            }

            startGettingScripts = Date.now();
            _context2.prev = 3;
            _context2.next = 6;
            return getSelectorsAndScripts();

          case 6:
            selectorsAndScripts = _context2.sent;
            _context2.next = 12;
            break;

          case 9:
            _context2.prev = 9;
            _context2.t0 = _context2["catch"](3);
            console.log(_context2.t0);

          case 12:
            console.log("Time to get selectors and scripts from native page to content script: ".concat(Date.now() - startGettingScripts, " ms"));

            if (selectorsAndScripts) {
              applyAdvancedBlockingData(selectorsAndScripts, false);
            }

          case 14:
          case "end":
            return _context2.stop();
        }
      }
    }, _callee2, null, [[3, 9]]);
  }));

  return function init() {
    return _ref2.apply(this, arguments);
  };
}();

var content = {
  init: init
};

/***/ }),

/***/ "./src/pages/content/index.ts":
/*!************************************!*\
  !*** ./src/pages/content/index.ts ***!
  \************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "content": () => (/* reexport safe */ _content__WEBPACK_IMPORTED_MODULE_0__.content)
/* harmony export */ });
/* harmony import */ var _content__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./content */ "./src/pages/content/content.ts");


/***/ }),

/***/ "./node_modules/extended-css/dist/extended-css.esm.js":
/*!************************************************************!*\
  !*** ./node_modules/extended-css/dist/extended-css.esm.js ***!
  \************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/*! extended-css - v1.3.12 - Mon May 31 2021
* https://github.com/AdguardTeam/ExtendedCss
* Copyright (c) 2021 AdGuard. Licensed LGPL-3.0
*/
function _typeof(obj) {
  "@babel/helpers - typeof";

  if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") {
    _typeof = function (obj) {
      return typeof obj;
    };
  } else {
    _typeof = function (obj) {
      return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj;
    };
  }

  return _typeof(obj);
}

function _slicedToArray(arr, i) {
  return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest();
}

function _toConsumableArray(arr) {
  return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _unsupportedIterableToArray(arr) || _nonIterableSpread();
}

function _arrayWithoutHoles(arr) {
  if (Array.isArray(arr)) return _arrayLikeToArray(arr);
}

function _arrayWithHoles(arr) {
  if (Array.isArray(arr)) return arr;
}

function _iterableToArray(iter) {
  if (typeof Symbol !== "undefined" && Symbol.iterator in Object(iter)) return Array.from(iter);
}

function _iterableToArrayLimit(arr, i) {
  if (typeof Symbol === "undefined" || !(Symbol.iterator in Object(arr))) return;
  var _arr = [];
  var _n = true;
  var _d = false;
  var _e = undefined;

  try {
    for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) {
      _arr.push(_s.value);

      if (i && _arr.length === i) break;
    }
  } catch (err) {
    _d = true;
    _e = err;
  } finally {
    try {
      if (!_n && _i["return"] != null) _i["return"]();
    } finally {
      if (_d) throw _e;
    }
  }

  return _arr;
}

function _unsupportedIterableToArray(o, minLen) {
  if (!o) return;
  if (typeof o === "string") return _arrayLikeToArray(o, minLen);
  var n = Object.prototype.toString.call(o).slice(8, -1);
  if (n === "Object" && o.constructor) n = o.constructor.name;
  if (n === "Map" || n === "Set") return Array.from(o);
  if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen);
}

function _arrayLikeToArray(arr, len) {
  if (len == null || len > arr.length) len = arr.length;

  for (var i = 0, arr2 = new Array(len); i < len; i++) arr2[i] = arr[i];

  return arr2;
}

function _nonIterableSpread() {
  throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.");
}

function _nonIterableRest() {
  throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.");
}

/**
 * Copyright 2016 Adguard Software Ltd
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/* eslint-disable no-console */
var utils = {};
utils.MutationObserver = window.MutationObserver || window.WebKitMutationObserver;
/**
 * Stores native Node textContent getter to be used for contains pseudo-class
 * because elements' 'textContent' and 'innerText' properties might be mocked
 * https://github.com/AdguardTeam/ExtendedCss/issues/127
 */

utils.nodeTextContentGetter = function () {
  var nativeNode = window.Node || Node;
  return Object.getOwnPropertyDescriptor(nativeNode.prototype, 'textContent').get;
}();

utils.isSafariBrowser = function () {
  var isChrome = navigator.userAgent.indexOf('Chrome') > -1;
  var isSafari = navigator.userAgent.indexOf('Safari') > -1;

  if (isSafari) {
    if (isChrome) {
      // Chrome seems to have both Chrome and Safari userAgents
      return false;
    }

    return true;
  }

  return false;
}();
/**
 * Converts regular expressions passed as pseudo class arguments into RegExp instances.
 * Have to unescape doublequote " as well, because we escape them while enclosing such
 * arguments with doublequotes, and sizzle does not automatically unescapes them.
 */


utils.pseudoArgToRegex = function (regexSrc, flag) {
  flag = flag || 'i';
  regexSrc = regexSrc.trim().replace(/\\(["\\])/g, '$1');
  return new RegExp(regexSrc, flag);
};
/**
 * Converts string to the regexp
 * @param {string} str
 * @returns {RegExp}
 */


utils.toRegExp = function (str) {
  if (str[0] === '/' && str[str.length - 1] === '/') {
    return new RegExp(str.slice(1, -1));
  }

  var escaped = str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  return new RegExp(escaped);
};

utils.startsWith = function (str, prefix) {
  // if str === '', (str && false) will return ''
  // that's why it has to be !!str
  return !!str && str.indexOf(prefix) === 0;
};

utils.endsWith = function (str, postfix) {
  if (!str || !postfix) {
    return false;
  }

  if (str.endsWith) {
    return str.endsWith(postfix);
  }

  var t = String(postfix);
  var index = str.lastIndexOf(t);
  return index >= 0 && index === str.length - t.length;
};
/**
 * Helper function for creating regular expression from a url filter rule syntax.
 */


utils.createURLRegex = function () {
  // Constants
  var regexConfiguration = {
    maskStartUrl: '||',
    maskPipe: '|',
    maskSeparator: '^',
    maskAnySymbol: '*',
    regexAnySymbol: '.*',
    regexSeparator: '([^ a-zA-Z0-9.%_-]|$)',
    regexStartUrl: '^(http|https|ws|wss)://([a-z0-9-_.]+\\.)?',
    regexStartString: '^',
    regexEndString: '$'
  }; // https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/regexp
  // should be escaped . * + ? ^ $ { } ( ) | [ ] / \
  // except of * | ^

  var specials = ['.', '+', '?', '$', '{', '}', '(', ')', '[', ']', '\\', '/'];
  var specialsRegex = new RegExp("[".concat(specials.join('\\'), "]"), 'g');
  /**
   * Escapes regular expression string
   */

  var escapeRegExp = function escapeRegExp(str) {
    return str.replace(specialsRegex, '\\$&');
  };

  var replaceAll = function replaceAll(str, find, replace) {
    if (!str) {
      return str;
    }

    return str.split(find).join(replace);
  };
  /**
   * Main function that converts a url filter rule string to a regex.
   * @param {string} str
   * @return {RegExp}
   */


  var createRegexText = function createRegexText(str) {
    var regex = escapeRegExp(str);

    if (utils.startsWith(regex, regexConfiguration.maskStartUrl)) {
      regex = regex.substring(0, regexConfiguration.maskStartUrl.length) + replaceAll(regex.substring(regexConfiguration.maskStartUrl.length, regex.length - 1), '\|', '\\|') + regex.substring(regex.length - 1);
    } else if (utils.startsWith(regex, regexConfiguration.maskPipe)) {
      regex = regex.substring(0, regexConfiguration.maskPipe.length) + replaceAll(regex.substring(regexConfiguration.maskPipe.length, regex.length - 1), '\|', '\\|') + regex.substring(regex.length - 1);
    } else {
      regex = replaceAll(regex.substring(0, regex.length - 1), '\|', '\\|') + regex.substring(regex.length - 1);
    } // Replacing special url masks


    regex = replaceAll(regex, regexConfiguration.maskAnySymbol, regexConfiguration.regexAnySymbol);
    regex = replaceAll(regex, regexConfiguration.maskSeparator, regexConfiguration.regexSeparator);

    if (utils.startsWith(regex, regexConfiguration.maskStartUrl)) {
      regex = regexConfiguration.regexStartUrl + regex.substring(regexConfiguration.maskStartUrl.length);
    } else if (utils.startsWith(regex, regexConfiguration.maskPipe)) {
      regex = regexConfiguration.regexStartString + regex.substring(regexConfiguration.maskPipe.length);
    }

    if (utils.endsWith(regex, regexConfiguration.maskPipe)) {
      regex = regex.substring(0, regex.length - 1) + regexConfiguration.regexEndString;
    }

    return new RegExp(regex, 'i');
  };

  return createRegexText;
}();
/**
 * Creates an object implementing Location interface from a url.
 * An alternative to URL.
 * https://github.com/AdguardTeam/FingerprintingBlocker/blob/master/src/shared/url.ts#L64
 */


utils.createLocation = function (href) {
  var anchor = document.createElement('a');
  anchor.href = href;

  if (anchor.host === '') {
    anchor.href = anchor.href; // eslint-disable-line no-self-assign
  }

  return anchor;
};
/**
 * Checks whether A has the same origin as B.
 * @param {string} urlA location.href of A.
 * @param {Location} locationB location of B.
 * @param {string} domainB document.domain of B.
 * @return {boolean}
 */


utils.isSameOrigin = function (urlA, locationB, domainB) {
  var locationA = utils.createLocation(urlA); // eslint-disable-next-line no-script-url

  if (locationA.protocol === 'javascript:' || locationA.href === 'about:blank') {
    return true;
  }

  if (locationA.protocol === 'data:' || locationA.protocol === 'file:') {
    return false;
  }

  return locationA.hostname === domainB && locationA.port === locationB.port && locationA.protocol === locationB.protocol;
};
/**
 * A helper class to throttle function calls with setTimeout and requestAnimationFrame.
 */


utils.AsyncWrapper = function () {
  /**
   * PhantomJS passes a wrong timestamp to the requestAnimationFrame callback and that breaks the AsyncWrapper logic
   * https://github.com/ariya/phantomjs/issues/14832
   */
  var supported = typeof window.requestAnimationFrame !== 'undefined' && !/phantom/i.test(navigator.userAgent);
  var rAF = supported ? requestAnimationFrame : setTimeout;
  var cAF = supported ? cancelAnimationFrame : clearTimeout;
  var perf = supported ? performance : Date;
  /**
   * @param {Function} callback
   * @param {number} throttle number, the provided callback should be executed twice
   * in this time frame.
   * @constructor
   */

  function AsyncWrapper(callback, throttle) {
    this.callback = callback;
    this.throttle = throttle;
    this.wrappedCallback = this.wrappedCallback.bind(this);

    if (this.wrappedAsapCallback) {
      this.wrappedAsapCallback = this.wrappedAsapCallback.bind(this);
    }
  }
  /** @private */


  AsyncWrapper.prototype.wrappedCallback = function (ts) {
    this.lastRun = isNumber(ts) ? ts : perf.now();
    delete this.rAFid;
    delete this.timerId;
    delete this.asapScheduled;
    this.callback();
  };
  /** @private Indicates whether there is a scheduled callback. */


  AsyncWrapper.prototype.hasPendingCallback = function () {
    return isNumber(this.rAFid) || isNumber(this.timerId);
  };
  /**
   * Schedules a function call before the next animation frame.
   */


  AsyncWrapper.prototype.run = function () {
    if (this.hasPendingCallback()) {
      // There is a pending execution scheduled.
      return;
    }

    if (typeof this.lastRun !== 'undefined') {
      var elapsed = perf.now() - this.lastRun;

      if (elapsed < this.throttle) {
        this.timerId = setTimeout(this.wrappedCallback, this.throttle - elapsed);
        return;
      }
    }

    this.rAFid = rAF(this.wrappedCallback);
  };
  /**
   * Schedules a function call in the most immenent microtask.
   * This cannot be canceled.
   */


  AsyncWrapper.prototype.runAsap = function () {
    if (this.asapScheduled) {
      return;
    }

    this.asapScheduled = true;
    cAF(this.rAFid);
    clearTimeout(this.timerId);

    if (utils.MutationObserver) {
      /**
       * Using MutationObservers to access microtask queue is a standard technique,
       * used in ASAP library
       * {@link https://github.com/kriskowal/asap/blob/master/browser-raw.js#L140}
       */
      if (!this.mo) {
        this.mo = new utils.MutationObserver(this.wrappedCallback);
        this.node = document.createTextNode(1);
        this.mo.observe(this.node, {
          characterData: true
        });
      }

      this.node.nodeValue = -this.node.nodeValue;
    } else {
      setTimeout(this.wrappedCallback);
    }
  };
  /**
   * Runs scheduled execution immediately, if there were any.
   */


  AsyncWrapper.prototype.runImmediately = function () {
    if (this.hasPendingCallback()) {
      cAF(this.rAFid);
      clearTimeout(this.timerId);
      delete this.rAFid;
      delete this.timerId;
      this.wrappedCallback();
    }
  };

  AsyncWrapper.now = function () {
    return perf.now();
  };

  return AsyncWrapper;
}();
/**
 * Stores native OdP to be used in WeakMap and Set polyfills.
 */


utils.defineProperty = Object.defineProperty;
utils.WeakMap = typeof WeakMap !== 'undefined' ? WeakMap : function () {
  /** Originally based on {@link https://github.com/Polymer/WeakMap} */
  var counter = Date.now() % 1e9;

  var WeakMap = function WeakMap() {
    this.name = "__st".concat(Math.random() * 1e9 >>> 0).concat(counter++, "__");
  };

  WeakMap.prototype = {
    set: function set(key, value) {
      var entry = key[this.name];

      if (entry && entry[0] === key) {
        entry[1] = value;
      } else {
        utils.defineProperty(key, this.name, {
          value: [key, value],
          writable: true
        });
      }

      return this;
    },
    get: function get(key) {
      var entry = key[this.name];
      return entry && entry[0] === key ? entry[1] : undefined;
    },
    delete: function _delete(key) {
      var entry = key[this.name];

      if (!entry) {
        return false;
      }

      var hasValue = entry[0] === key;
      delete entry[0];
      delete entry[1];
      return hasValue;
    },
    has: function has(key) {
      var entry = key[this.name];

      if (!entry) {
        return false;
      }

      return entry[0] === key;
    }
  };
  return WeakMap;
}();
utils.Set = typeof Set !== 'undefined' ? Set : function () {
  var counter = Date.now() % 1e9;
  /**
   * A polyfill which covers only the basic usage.
   * Only supports methods that are supported in IE11.
   * {@link https://docs.microsoft.com/en-us/scripting/javascript/reference/set-object-javascript}
   * Assumes that 'key's are all objects, not primitives such as a number.
   *
   * @param {Array} items Initial items in this set
   */

  var Set = function Set(items) {
    this.name = "__st".concat(Math.random() * 1e9 >>> 0).concat(counter++, "__");
    this.keys = [];

    if (items && items.length) {
      var iItems = items.length;

      while (iItems--) {
        this.add(items[iItems]);
      }
    }
  };

  Set.prototype = {
    add: function add(key) {
      if (!isNumber(key[this.name])) {
        var index = this.keys.push(key) - 1;
        utils.defineProperty(key, this.name, {
          value: index,
          writable: true
        });
      }
    },
    delete: function _delete(key) {
      if (isNumber(key[this.name])) {
        var index = key[this.name];
        delete this.keys[index];
        key[this.name] = undefined;
      }
    },
    has: function has(key) {
      return isNumber(key[this.name]);
    },
    clear: function clear() {
      this.keys.forEach(function (key) {
        key[this.name] = undefined;
      });
      this.keys.length = 0;
    },
    forEach: function forEach(cb) {
      var that = this;
      this.keys.forEach(function (value) {
        cb(value, value, that);
      });
    }
  };
  utils.defineProperty(Set.prototype, 'size', {
    get: function get() {
      // Skips holes.
      return this.keys.reduce(function (acc) {
        return acc + 1;
      }, 0);
    }
  });
  return Set;
}();
/**
 * Vendor-specific Element.prototype.matches
 */

utils.matchesPropertyName = function () {
  var props = ['matches', 'matchesSelector', 'mozMatchesSelector', 'msMatchesSelector', 'oMatchesSelector', 'webkitMatchesSelector'];

  for (var i = 0; i < 6; i++) {
    if (Element.prototype.hasOwnProperty(props[i])) {
      return props[i];
    }
  }
}();
/**
 * Provides stats information
 */


utils.Stats = function () {
  /** @member {Array<number>} */
  this.array = [];
  /** @member {number} */

  this.length = 0;
  var zeroDescriptor = {
    value: 0,
    writable: true
  };
  /** @member {number} @private */

  Object.defineProperty(this, 'sum', zeroDescriptor);
  /** @member {number} @private */

  Object.defineProperty(this, 'squaredSum', zeroDescriptor);
};
/**
 * @param {number} dataPoint data point
 */


utils.Stats.prototype.push = function (dataPoint) {
  this.array.push(dataPoint);
  this.length++;
  this.sum += dataPoint;
  this.squaredSum += dataPoint * dataPoint;
  /** @member {number} */

  this.mean = this.sum / this.length;
  /** @member {number} */
  // eslint-disable-next-line no-restricted-properties

  this.stddev = Math.sqrt(this.squaredSum / this.length - Math.pow(this.mean, 2));
};
/** Safe console.error version */


utils.logError = typeof console !== 'undefined' && console.error && Function.prototype.bind && console.error.bind ? console.error.bind(window.console) : console.error;
/** Safe console.info version */

utils.logInfo = typeof console !== 'undefined' && console.info && Function.prototype.bind && console.info.bind ? console.info.bind(window.console) : console.info;

function isNumber(obj) {
  return typeof obj === 'number';
}
/**
 * Returns path to element we will use as element identifier
 * @param {Element} inputEl
 * @returns {string} - path to the element
 */


utils.getNodeSelector = function (inputEl) {
  if (!(inputEl instanceof Element)) {
    throw new Error('Function received argument with wrong type');
  }

  var el = inputEl;
  var path = []; // we need to check '!!el' first because it is possible
  // that some ancestor of the inputEl was removed before it

  while (!!el && el.nodeType === Node.ELEMENT_NODE) {
    var selector = el.nodeName.toLowerCase();

    if (el.id && typeof el.id === 'string') {
      selector += "#".concat(el.id);
      path.unshift(selector);
      break;
    } else {
      var sibling = el;
      var nth = 1;

      while (sibling.previousSibling) {
        sibling = sibling.previousSibling;

        if (sibling.nodeType === Node.ELEMENT_NODE && sibling.nodeName.toLowerCase() === selector) {
          nth++;
        }
      }

      if (nth !== 1) {
        selector += ":nth-of-type(".concat(nth, ")");
      }
    }

    path.unshift(selector);
    el = el.parentNode;
  }

  return path.join(' > ');
};

/**
 * Copyright 2016 Adguard Software Ltd
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * Helper class css utils
 *
 * @type {{normalize}}
 */
var cssUtils = function () {
  /**
   * Regex that matches AdGuard's backward compatible syntaxes.
   */
  var reAttrFallback = /\[-(?:ext|abp)-([a-z-_]+)=(["'])((?:(?=(\\?))\4.)*?)\2\]/g;
  /**
   * Complex replacement function.
   * Unescapes quote characters inside of an extended selector.
   *
   * @param match     Whole matched string
   * @param name      Group 1
   * @param quoteChar Group 2
   * @param value     Group 3
   */

  var evaluateMatch = function evaluateMatch(match, name, quoteChar, value) {
    // Unescape quotes
    var re = new RegExp("([^\\\\]|^)\\\\".concat(quoteChar), 'g');
    value = value.replace(re, "$1".concat(quoteChar));
    return ":".concat(name, "(").concat(value, ")");
  }; // Sizzle's parsing of pseudo class arguments is buggy on certain circumstances
  // We support following form of arguments:
  // 1. for :matches-css, those of a form {propertyName}: /.*/
  // 2. for :contains, those of a form /.*/
  // We transform such cases in a way that Sizzle has no ambiguity in parsing arguments.


  var reMatchesCss = /\:(matches-css(?:-after|-before)?)\(([a-z-\s]*\:\s*\/(?:\\.|[^\/])*?\/\s*)\)/g;
  var reContains = /:(?:-abp-)?(contains|has-text)\((\s*\/(?:\\.|[^\/])*?\/\s*)\)/g;
  var reScope = /\(\:scope >/g; // Note that we require `/` character in regular expressions to be escaped.

  /**
   * Used for pre-processing pseudo-classes values with above two regexes.
   */

  var addQuotes = function addQuotes(_, c1, c2) {
    return ":".concat(c1, "(\"").concat(c2.replace(/["\\]/g, '\\$&'), "\")");
  };

  var SCOPE_REPLACER = '(>';
  /**
   * Normalizes specified css text in a form that can be parsed by the
   * Sizzle engine.
   * Normalization means
   *  1. transforming [-ext-*=""] attributes to pseudo classes
   *  2. enclosing possibly ambiguous arguments of `:contains`,
   *     `:matches-css` pseudo classes with quotes.
   * @param {string} cssText
   * @return {string}
   */

  var normalize = function normalize(cssText) {
    var normalizedCssText = cssText.replace(reAttrFallback, evaluateMatch).replace(reMatchesCss, addQuotes).replace(reContains, addQuotes).replace(reScope, SCOPE_REPLACER);
    return normalizedCssText;
  };

  var isSimpleSelectorValid = function isSimpleSelectorValid(selector) {
    try {
      document.querySelectorAll(selector);
    } catch (e) {
      return false;
    }

    return true;
  };

  return {
    normalize: normalize,
    isSimpleSelectorValid: isSimpleSelectorValid
  };
}();

/*!
 * Sizzle CSS Selector Engine v2.3.4-pre-adguard
 * https://sizzlejs.com/
 *
 * Copyright JS Foundation and other contributors
 * Released under the MIT license
 * https://js.foundation/
 *
 * Date: 2020-08-04
 */

/**
 * Version of Sizzle patched by AdGuard in order to be used in the ExtendedCss module.
 * https://github.com/AdguardTeam/sizzle-extcss
 *
 * Look for [AdGuard Patch] and ADGUARD_EXTCSS markers to find out what exactly was changed by us.
 *
 * Global changes:
 * 1. Added additional parameters to the "Sizzle.tokenize" method so that it can be used for stylesheets parsing and validation.
 * 2. Added tokens re-sorting mechanism forcing slow pseudos to be matched last  (see sortTokenGroups).
 * 3. Fix the nonnativeSelectorCache caching -- there was no value corresponding to a key.
 * 4. Added Sizzle.compile call to the `:has` pseudo definition.
 *
 * Changes that are applied to the ADGUARD_EXTCSS build only:
 * 1. Do not expose Sizzle to the global scope. Initialize it lazily via initializeSizzle().
 * 2. Removed :contains pseudo declaration -- its syntax is changed and declared outside of Sizzle.
 * 3. Removed declarations for the following non-standard pseudo classes:
 * :parent, :header, :input, :button, :text, :first, :last, :eq,
 * :even, :odd, :lt, :gt, :nth, :radio, :checkbox, :file,
 * :password, :image, :submit, :reset
 * 4. Added es6 module export
 */
var Sizzle;
/**
 * Initializes Sizzle object.
 * In the case of AdGuard ExtendedCss we want to avoid initializing Sizzle right away
 * and exposing it to the global scope.
 */

var initializeSizzle = function initializeSizzle() {
  // jshint ignore:line
  if (!Sizzle) {
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    Sizzle = function (window) {
      var support,
          Expr,
          getText,
          isXML,
          tokenize,
          compile,
          select,
          outermostContext,
          sortInput,
          hasDuplicate,
          // Local document vars
      setDocument,
          document,
          docElem,
          documentIsHTML,
          rbuggyQSA,
          rbuggyMatches,
          matches,
          contains,
          // Instance-specific data
      expando = "sizzle" + 1 * new Date(),
          preferredDoc = window.document,
          dirruns = 0,
          done = 0,
          classCache = createCache(),
          tokenCache = createCache(),
          compilerCache = createCache(),
          nonnativeSelectorCache = createCache(),
          sortOrder = function sortOrder(a, b) {
        if (a === b) {
          hasDuplicate = true;
        }

        return 0;
      },
          // Instance methods
      hasOwn = {}.hasOwnProperty,
          arr = [],
          pop = arr.pop,
          push_native = arr.push,
          push = arr.push,
          slice = arr.slice,
          // Use a stripped-down indexOf as it's faster than native
      // https://jsperf.com/thor-indexof-vs-for/5
      indexOf = function indexOf(list, elem) {
        var i = 0,
            len = list.length;

        for (; i < len; i++) {
          if (list[i] === elem) {
            return i;
          }
        }

        return -1;
      },
          booleans = "checked|selected|async|autofocus|autoplay|controls|defer|disabled|hidden|ismap|loop|multiple|open|readonly|required|scoped",
          // Regular expressions
      // http://www.w3.org/TR/css3-selectors/#whitespace
      whitespace = "[\\x20\\t\\r\\n\\f]",
          // http://www.w3.org/TR/CSS21/syndata.html#value-def-identifier
      identifier = "(?:\\\\.|[\\w-]|[^\0-\\xa0])+",
          // Attribute selectors: http://www.w3.org/TR/selectors/#attribute-selectors
      attributes = "\\[" + whitespace + "*(" + identifier + ")(?:" + whitespace + // Operator (capture 2)
      "*([*^$|!~]?=)" + whitespace + // "Attribute values must be CSS identifiers [capture 5] or strings [capture 3 or capture 4]"
      "*(?:'((?:\\\\.|[^\\\\'])*)'|\"((?:\\\\.|[^\\\\\"])*)\"|(" + identifier + "))|)" + whitespace + "*\\]",
          pseudos = ":(" + identifier + ")(?:\\((" + // To reduce the number of selectors needing tokenize in the preFilter, prefer arguments:
      // 1. quoted (capture 3; capture 4 or capture 5)
      "('((?:\\\\.|[^\\\\'])*)'|\"((?:\\\\.|[^\\\\\"])*)\")|" + // 2. simple (capture 6)
      "((?:\\\\.|[^\\\\()[\\]]|" + attributes + ")*)|" + // 3. anything else (capture 2)
      ".*" + ")\\)|)",
          // Leading and non-escaped trailing whitespace, capturing some non-whitespace characters preceding the latter
      rwhitespace = new RegExp(whitespace + "+", "g"),
          rtrim = new RegExp("^" + whitespace + "+|((?:^|[^\\\\])(?:\\\\.)*)" + whitespace + "+$", "g"),
          rcomma = new RegExp("^" + whitespace + "*," + whitespace + "*"),
          rcombinators = new RegExp("^" + whitespace + "*([>+~]|" + whitespace + ")" + whitespace + "*"),
          rpseudo = new RegExp(pseudos),
          ridentifier = new RegExp("^" + identifier + "$"),
          matchExpr = {
        "ID": new RegExp("^#(" + identifier + ")"),
        "CLASS": new RegExp("^\\.(" + identifier + ")"),
        "TAG": new RegExp("^(" + identifier + "|[*])"),
        "ATTR": new RegExp("^" + attributes),
        "PSEUDO": new RegExp("^" + pseudos),
        "CHILD": new RegExp("^:(only|first|last|nth|nth-last)-(child|of-type)(?:\\(" + whitespace + "*(even|odd|(([+-]|)(\\d*)n|)" + whitespace + "*(?:([+-]|)" + whitespace + "*(\\d+)|))" + whitespace + "*\\)|)", "i"),
        "bool": new RegExp("^(?:" + booleans + ")$", "i"),
        // For use in libraries implementing .is()
        // We use this for POS matching in `select`
        "needsContext": new RegExp("^" + whitespace + "*[>+~]|:(even|odd|eq|gt|lt|nth|first|last)(?:\\(" + whitespace + "*((?:-\\d)?\\d*)" + whitespace + "*\\)|)(?=[^-]|$)", "i")
      },
          rnative = /^[^{]+\{\s*\[native \w/,
          // Easily-parseable/retrievable ID or TAG or CLASS selectors
      rquickExpr = /^(?:#([\w-]+)|(\w+)|\.([\w-]+))$/,
          rsibling = /[+~]/,
          // CSS escapes
      // http://www.w3.org/TR/CSS21/syndata.html#escaped-characters
      runescape = new RegExp("\\\\([\\da-f]{1,6}" + whitespace + "?|(" + whitespace + ")|.)", "ig"),
          funescape = function funescape(_, escaped, escapedWhitespace) {
        var high = "0x" + escaped - 0x10000; // NaN means non-codepoint
        // Support: Firefox<24
        // Workaround erroneous numeric interpretation of +"0x"

        return high !== high || escapedWhitespace ? escaped : high < 0 ? // BMP codepoint
        String.fromCharCode(high + 0x10000) : // Supplemental Plane codepoint (surrogate pair)
        String.fromCharCode(high >> 10 | 0xD800, high & 0x3FF | 0xDC00);
      },
          // CSS string/identifier serialization
      // https://drafts.csswg.org/cssom/#common-serializing-idioms
      rcssescape = /([\0-\x1f\x7f]|^-?\d)|^-$|[^\0-\x1f\x7f-\uFFFF\w-]/g,
          fcssescape = function fcssescape(ch, asCodePoint) {
        if (asCodePoint) {
          // U+0000 NULL becomes U+FFFD REPLACEMENT CHARACTER
          if (ch === "\0") {
            return "\uFFFD";
          } // Control characters and (dependent upon position) numbers get escaped as code points


          return ch.slice(0, -1) + "\\" + ch.charCodeAt(ch.length - 1).toString(16) + " ";
        } // Other potentially-special ASCII characters get backslash-escaped


        return "\\" + ch;
      },
          // Used for iframes
      // See setDocument()
      // Removing the function wrapper causes a "Permission Denied"
      // error in IE
      unloadHandler = function unloadHandler() {
        setDocument();
      },
          inDisabledFieldset = addCombinator(function (elem) {
        return elem.disabled === true && elem.nodeName.toLowerCase() === "fieldset";
      }, {
        dir: "parentNode",
        next: "legend"
      }); // Optimize for push.apply( _, NodeList )


      try {
        push.apply(arr = slice.call(preferredDoc.childNodes), preferredDoc.childNodes); // Support: Android<4.0
        // Detect silently failing push.apply

        arr[preferredDoc.childNodes.length].nodeType;
      } catch (e) {
        push = {
          apply: arr.length ? // Leverage slice if possible
          function (target, els) {
            push_native.apply(target, slice.call(els));
          } : // Support: IE<9
          // Otherwise append directly
          function (target, els) {
            var j = target.length,
                i = 0; // Can't trust NodeList.length

            while (target[j++] = els[i++]) {}

            target.length = j - 1;
          }
        };
      }

      function Sizzle(selector, context, results, seed) {
        var m,
            i,
            elem,
            nid,
            match,
            groups,
            newSelector,
            newContext = context && context.ownerDocument,
            // nodeType defaults to 9, since context defaults to document
        nodeType = context ? context.nodeType : 9;
        results = results || []; // Return early from calls with invalid selector or context

        if (typeof selector !== "string" || !selector || nodeType !== 1 && nodeType !== 9 && nodeType !== 11) {
          return results;
        } // Try to shortcut find operations (as opposed to filters) in HTML documents


        if (!seed) {
          if ((context ? context.ownerDocument || context : preferredDoc) !== document) {
            setDocument(context);
          }

          context = context || document;

          if (documentIsHTML) {
            // If the selector is sufficiently simple, try using a "get*By*" DOM method
            // (excepting DocumentFragment context, where the methods don't exist)
            if (nodeType !== 11 && (match = rquickExpr.exec(selector))) {
              // ID selector
              if (m = match[1]) {
                // Document context
                if (nodeType === 9) {
                  if (elem = context.getElementById(m)) {
                    // Support: IE, Opera, Webkit
                    // TODO: identify versions
                    // getElementById can match elements by name instead of ID
                    if (elem.id === m) {
                      results.push(elem);
                      return results;
                    }
                  } else {
                    return results;
                  } // Element context

                } else {
                  // Support: IE, Opera, Webkit
                  // TODO: identify versions
                  // getElementById can match elements by name instead of ID
                  if (newContext && (elem = newContext.getElementById(m)) && contains(context, elem) && elem.id === m) {
                    results.push(elem);
                    return results;
                  }
                } // Type selector

              } else if (match[2]) {
                push.apply(results, context.getElementsByTagName(selector));
                return results; // Class selector
              } else if ((m = match[3]) && support.getElementsByClassName && context.getElementsByClassName) {
                push.apply(results, context.getElementsByClassName(m));
                return results;
              }
            } // Take advantage of querySelectorAll


            if (support.qsa && !nonnativeSelectorCache[selector + " "] && (!rbuggyQSA || !rbuggyQSA.test(selector))) {
              if (nodeType !== 1) {
                newContext = context;
                newSelector = selector; // qSA looks outside Element context, which is not what we want
                // Thanks to Andrew Dupont for this workaround technique
                // Support: IE <=8
                // Exclude object elements
              } else if (context.nodeName.toLowerCase() !== "object") {
                // Capture the context ID, setting it first if necessary
                if (nid = context.getAttribute("id")) {
                  nid = nid.replace(rcssescape, fcssescape);
                } else {
                  context.setAttribute("id", nid = expando);
                } // Prefix every selector in the list


                groups = tokenize(selector);
                i = groups.length;

                while (i--) {
                  groups[i] = "#" + nid + " " + toSelector(groups[i]);
                }

                newSelector = groups.join(","); // Expand context for sibling selectors

                newContext = rsibling.test(selector) && testContext(context.parentNode) || context;
              }

              if (newSelector) {
                try {
                  push.apply(results, newContext.querySelectorAll(newSelector));
                  return results;
                } catch (qsaError) {
                  // [AdGuard Path]: Fix the cache value
                  nonnativeSelectorCache(selector, true);
                } finally {
                  if (nid === expando) {
                    context.removeAttribute("id");
                  }
                }
              }
            }
          }
        } // All others


        return select(selector.replace(rtrim, "$1"), context, results, seed);
      }
      /**
       * Create key-value caches of limited size
       * @returns {function(string, object)} Returns the Object data after storing it on itself with
       *	property name the (space-suffixed) string and (if the cache is larger than Expr.cacheLength)
       *	deleting the oldest entry
       */


      function createCache() {
        var keys = [];

        function cache(key, value) {
          // Use (key + " ") to avoid collision with native prototype properties (see Issue #157)
          if (keys.push(key + " ") > Expr.cacheLength) {
            // Only keep the most recent entries
            delete cache[keys.shift()];
          }

          return cache[key + " "] = value;
        }

        return cache;
      }
      /**
       * Mark a function for special use by Sizzle
       * @param {Function} fn The function to mark
       */


      function markFunction(fn) {
        fn[expando] = true;
        return fn;
      }
      /**
       * Support testing using an element
       * @param {Function} fn Passed the created element and returns a boolean result
       */


      function assert(fn) {
        var el = document.createElement("fieldset");

        try {
          return !!fn(el);
        } catch (e) {
          return false;
        } finally {
          // Remove from its parent by default
          if (el.parentNode) {
            el.parentNode.removeChild(el);
          } // release memory in IE


          el = null;
        }
      }
      /**
       * Adds the same handler for all of the specified attrs
       * @param {String} attrs Pipe-separated list of attributes
       * @param {Function} handler The method that will be applied
       */


      function addHandle(attrs, handler) {
        var arr = attrs.split("|"),
            i = arr.length;

        while (i--) {
          Expr.attrHandle[arr[i]] = handler;
        }
      }
      /**
       * Checks document order of two siblings
       * @param {Element} a
       * @param {Element} b
       * @returns {Number} Returns less than 0 if a precedes b, greater than 0 if a follows b
       */


      function siblingCheck(a, b) {
        var cur = b && a,
            diff = cur && a.nodeType === 1 && b.nodeType === 1 && a.sourceIndex - b.sourceIndex; // Use IE sourceIndex if available on both nodes

        if (diff) {
          return diff;
        } // Check if b follows a


        if (cur) {
          while (cur = cur.nextSibling) {
            if (cur === b) {
              return -1;
            }
          }
        }

        return a ? 1 : -1;
      }
      /**
       * Returns a function to use in pseudos for :enabled/:disabled
       * @param {Boolean} disabled true for :disabled; false for :enabled
       */


      function createDisabledPseudo(disabled) {
        // Known :disabled false positives: fieldset[disabled] > legend:nth-of-type(n+2) :can-disable
        return function (elem) {
          // Only certain elements can match :enabled or :disabled
          // https://html.spec.whatwg.org/multipage/scripting.html#selector-enabled
          // https://html.spec.whatwg.org/multipage/scripting.html#selector-disabled
          if ("form" in elem) {
            // Check for inherited disabledness on relevant non-disabled elements:
            // * listed form-associated elements in a disabled fieldset
            //   https://html.spec.whatwg.org/multipage/forms.html#category-listed
            //   https://html.spec.whatwg.org/multipage/forms.html#concept-fe-disabled
            // * option elements in a disabled optgroup
            //   https://html.spec.whatwg.org/multipage/forms.html#concept-option-disabled
            // All such elements have a "form" property.
            if (elem.parentNode && elem.disabled === false) {
              // Option elements defer to a parent optgroup if present
              if ("label" in elem) {
                if ("label" in elem.parentNode) {
                  return elem.parentNode.disabled === disabled;
                } else {
                  return elem.disabled === disabled;
                }
              } // Support: IE 6 - 11
              // Use the isDisabled shortcut property to check for disabled fieldset ancestors


              return elem.isDisabled === disabled || // Where there is no isDisabled, check manually

              /* jshint -W018 */
              elem.isDisabled !== !disabled && inDisabledFieldset(elem) === disabled;
            }

            return elem.disabled === disabled; // Try to winnow out elements that can't be disabled before trusting the disabled property.
            // Some victims get caught in our net (label, legend, menu, track), but it shouldn't
            // even exist on them, let alone have a boolean value.
          } else if ("label" in elem) {
            return elem.disabled === disabled;
          } // Remaining elements are neither :enabled nor :disabled


          return false;
        };
      }
      /**
       * Checks a node for validity as a Sizzle context
       * @param {Element|Object=} context
       * @returns {Element|Object|Boolean} The input node if acceptable, otherwise a falsy value
       */


      function testContext(context) {
        return context && typeof context.getElementsByTagName !== "undefined" && context;
      } // Expose support vars for convenience


      support = Sizzle.support = {};
      /**
       * Detects XML nodes
       * @param {Element|Object} elem An element or a document
       * @returns {Boolean} True iff elem is a non-HTML XML node
       */

      isXML = Sizzle.isXML = function (elem) {
        // documentElement is verified for cases where it doesn't yet exist
        // (such as loading iframes in IE - #4833)
        var documentElement = elem && (elem.ownerDocument || elem).documentElement;
        return documentElement ? documentElement.nodeName !== "HTML" : false;
      };
      /**
       * Sets document-related variables once based on the current document
       * @param {Element|Object} [doc] An element or document object to use to set the document
       * @returns {Object} Returns the current document
       */


      setDocument = Sizzle.setDocument = function (node) {
        var hasCompare,
            subWindow,
            doc = node ? node.ownerDocument || node : preferredDoc; // Return early if doc is invalid or already selected

        if (doc === document || doc.nodeType !== 9 || !doc.documentElement) {
          return document;
        } // Update global variables


        document = doc;
        docElem = document.documentElement;
        documentIsHTML = !isXML(document); // Support: IE 9-11, Edge
        // Accessing iframe documents after unload throws "permission denied" errors (jQuery #13936)

        if (preferredDoc !== document && (subWindow = document.defaultView) && subWindow.top !== subWindow) {
          // Support: IE 11, Edge
          if (subWindow.addEventListener) {
            subWindow.addEventListener("unload", unloadHandler, false); // Support: IE 9 - 10 only
          } else if (subWindow.attachEvent) {
            subWindow.attachEvent("onunload", unloadHandler);
          }
        }
        /* Attributes
        ---------------------------------------------------------------------- */
        // Support: IE<8
        // Verify that getAttribute really returns attributes and not properties
        // (excepting IE8 booleans)


        support.attributes = assert(function (el) {
          el.className = "i";
          return !el.getAttribute("className");
        });
        /* getElement(s)By*
        ---------------------------------------------------------------------- */
        // Check if getElementsByTagName("*") returns only elements

        support.getElementsByTagName = assert(function (el) {
          el.appendChild(document.createComment(""));
          return !el.getElementsByTagName("*").length;
        }); // Support: IE<9

        support.getElementsByClassName = rnative.test(document.getElementsByClassName); // Support: IE<10
        // Check if getElementById returns elements by name
        // The broken getElementById methods don't pick up programmatically-set names,
        // so use a roundabout getElementsByName test

        support.getById = assert(function (el) {
          docElem.appendChild(el).id = expando;
          return !document.getElementsByName || !document.getElementsByName(expando).length;
        }); // ID filter and find

        if (support.getById) {
          Expr.filter["ID"] = function (id) {
            var attrId = id.replace(runescape, funescape);
            return function (elem) {
              return elem.getAttribute("id") === attrId;
            };
          };

          Expr.find["ID"] = function (id, context) {
            if (typeof context.getElementById !== "undefined" && documentIsHTML) {
              var elem = context.getElementById(id);
              return elem ? [elem] : [];
            }
          };
        } else {
          Expr.filter["ID"] = function (id) {
            var attrId = id.replace(runescape, funescape);
            return function (elem) {
              var node = typeof elem.getAttributeNode !== "undefined" && elem.getAttributeNode("id");
              return node && node.value === attrId;
            };
          }; // Support: IE 6 - 7 only
          // getElementById is not reliable as a find shortcut


          Expr.find["ID"] = function (id, context) {
            if (typeof context.getElementById !== "undefined" && documentIsHTML) {
              var node,
                  i,
                  elems,
                  elem = context.getElementById(id);

              if (elem) {
                // Verify the id attribute
                node = elem.getAttributeNode("id");

                if (node && node.value === id) {
                  return [elem];
                } // Fall back on getElementsByName


                elems = context.getElementsByName(id);
                i = 0;

                while (elem = elems[i++]) {
                  node = elem.getAttributeNode("id");

                  if (node && node.value === id) {
                    return [elem];
                  }
                }
              }

              return [];
            }
          };
        } // Tag


        Expr.find["TAG"] = support.getElementsByTagName ? function (tag, context) {
          if (typeof context.getElementsByTagName !== "undefined") {
            return context.getElementsByTagName(tag); // DocumentFragment nodes don't have gEBTN
          } else if (support.qsa) {
            return context.querySelectorAll(tag);
          }
        } : function (tag, context) {
          var elem,
              tmp = [],
              i = 0,
              // By happy coincidence, a (broken) gEBTN appears on DocumentFragment nodes too
          results = context.getElementsByTagName(tag); // Filter out possible comments

          if (tag === "*") {
            while (elem = results[i++]) {
              if (elem.nodeType === 1) {
                tmp.push(elem);
              }
            }

            return tmp;
          }

          return results;
        }; // Class

        Expr.find["CLASS"] = support.getElementsByClassName && function (className, context) {
          if (typeof context.getElementsByClassName !== "undefined" && documentIsHTML) {
            return context.getElementsByClassName(className);
          }
        };
        /* QSA/matchesSelector
        ---------------------------------------------------------------------- */
        // QSA and matchesSelector support
        // matchesSelector(:active) reports false when true (IE9/Opera 11.5)


        rbuggyMatches = []; // qSa(:focus) reports false when true (Chrome 21)
        // We allow this because of a bug in IE8/9 that throws an error
        // whenever `document.activeElement` is accessed on an iframe
        // So, we allow :focus to pass through QSA all the time to avoid the IE error
        // See https://bugs.jquery.com/ticket/13378

        rbuggyQSA = [];

        if (support.qsa = rnative.test(document.querySelectorAll)) {
          // Build QSA regex
          // Regex strategy adopted from Diego Perini
          assert(function (el) {
            // Select is set to empty string on purpose
            // This is to test IE's treatment of not explicitly
            // setting a boolean content attribute,
            // since its presence should be enough
            // https://bugs.jquery.com/ticket/12359
            docElem.appendChild(el).innerHTML = AGPolicy.createHTML("<a id='" + expando + "'></a>" + "<select id='" + expando + "-\r\\' msallowcapture=''>" + "<option selected=''></option></select>"); // Support: IE8, Opera 11-12.16
            // Nothing should be selected when empty strings follow ^= or $= or *=
            // The test attribute must be unknown in Opera but "safe" for WinRT
            // https://msdn.microsoft.com/en-us/library/ie/hh465388.aspx#attribute_section

            if (el.querySelectorAll("[msallowcapture^='']").length) {
              rbuggyQSA.push("[*^$]=" + whitespace + "*(?:''|\"\")");
            } // Support: IE8
            // Boolean attributes and "value" are not treated correctly


            if (!el.querySelectorAll("[selected]").length) {
              rbuggyQSA.push("\\[" + whitespace + "*(?:value|" + booleans + ")");
            } // Support: Chrome<29, Android<4.4, Safari<7.0+, iOS<7.0+, PhantomJS<1.9.8+


            if (!el.querySelectorAll("[id~=" + expando + "-]").length) {
              rbuggyQSA.push("~=");
            } // Webkit/Opera - :checked should return selected option elements
            // http://www.w3.org/TR/2011/REC-css3-selectors-20110929/#checked
            // IE8 throws error here and will not see later tests


            if (!el.querySelectorAll(":checked").length) {
              rbuggyQSA.push(":checked");
            } // Support: Safari 8+, iOS 8+
            // https://bugs.webkit.org/show_bug.cgi?id=136851
            // In-page `selector#id sibling-combinator selector` fails


            if (!el.querySelectorAll("a#" + expando + "+*").length) {
              rbuggyQSA.push(".#.+[+~]");
            }
          });
          assert(function (el) {
            el.innerHTML = AGPolicy.createHTML("<a href='' disabled='disabled'></a>" + "<select disabled='disabled'><option/></select>"); // Support: Windows 8 Native Apps
            // The type and name attributes are restricted during .innerHTML assignment

            var input = document.createElement("input");
            input.setAttribute("type", "hidden");
            el.appendChild(input).setAttribute("name", "D"); // Support: IE8
            // Enforce case-sensitivity of name attribute

            if (el.querySelectorAll("[name=d]").length) {
              rbuggyQSA.push("name" + whitespace + "*[*^$|!~]?=");
            } // FF 3.5 - :enabled/:disabled and hidden elements (hidden elements are still enabled)
            // IE8 throws error here and will not see later tests


            if (el.querySelectorAll(":enabled").length !== 2) {
              rbuggyQSA.push(":enabled", ":disabled");
            } // Support: IE9-11+
            // IE's :disabled selector does not pick up the children of disabled fieldsets


            docElem.appendChild(el).disabled = true;

            if (el.querySelectorAll(":disabled").length !== 2) {
              rbuggyQSA.push(":enabled", ":disabled");
            } // Opera 10-11 does not throw on post-comma invalid pseudos


            el.querySelectorAll("*,:x");
            rbuggyQSA.push(",.*:");
          });
        }

        if (support.matchesSelector = rnative.test(matches = docElem.matches || docElem.webkitMatchesSelector || docElem.mozMatchesSelector || docElem.oMatchesSelector || docElem.msMatchesSelector)) {
          assert(function (el) {
            // Check to see if it's possible to do matchesSelector
            // on a disconnected node (IE 9)
            support.disconnectedMatch = matches.call(el, "*"); // This should fail with an exception
            // Gecko does not error, returns false instead

            matches.call(el, "[s!='']:x");
            rbuggyMatches.push("!=", pseudos);
          });
        }

        rbuggyQSA = rbuggyQSA.length && new RegExp(rbuggyQSA.join("|"));
        rbuggyMatches = rbuggyMatches.length && new RegExp(rbuggyMatches.join("|"));
        /* Contains
        ---------------------------------------------------------------------- */

        hasCompare = rnative.test(docElem.compareDocumentPosition); // Element contains another
        // Purposefully self-exclusive
        // As in, an element does not contain itself

        contains = hasCompare || rnative.test(docElem.contains) ? function (a, b) {
          var adown = a.nodeType === 9 ? a.documentElement : a,
              bup = b && b.parentNode;
          return a === bup || !!(bup && bup.nodeType === 1 && (adown.contains ? adown.contains(bup) : a.compareDocumentPosition && a.compareDocumentPosition(bup) & 16));
        } : function (a, b) {
          if (b) {
            while (b = b.parentNode) {
              if (b === a) {
                return true;
              }
            }
          }

          return false;
        };
        /* Sorting
        ---------------------------------------------------------------------- */
        // Document order sorting

        sortOrder = hasCompare ? function (a, b) {
          // Flag for duplicate removal
          if (a === b) {
            hasDuplicate = true;
            return 0;
          } // Sort on method existence if only one input has compareDocumentPosition


          var compare = !a.compareDocumentPosition - !b.compareDocumentPosition;

          if (compare) {
            return compare;
          } // Calculate position if both inputs belong to the same document


          compare = (a.ownerDocument || a) === (b.ownerDocument || b) ? a.compareDocumentPosition(b) : // Otherwise we know they are disconnected
          1; // Disconnected nodes

          if (compare & 1 || !support.sortDetached && b.compareDocumentPosition(a) === compare) {
            // Choose the first element that is related to our preferred document
            if (a === document || a.ownerDocument === preferredDoc && contains(preferredDoc, a)) {
              return -1;
            }

            if (b === document || b.ownerDocument === preferredDoc && contains(preferredDoc, b)) {
              return 1;
            } // Maintain original order


            return sortInput ? indexOf(sortInput, a) - indexOf(sortInput, b) : 0;
          }

          return compare & 4 ? -1 : 1;
        } : function (a, b) {
          // Exit early if the nodes are identical
          if (a === b) {
            hasDuplicate = true;
            return 0;
          }

          var cur,
              i = 0,
              aup = a.parentNode,
              bup = b.parentNode,
              ap = [a],
              bp = [b]; // Parentless nodes are either documents or disconnected

          if (!aup || !bup) {
            return a === document ? -1 : b === document ? 1 : aup ? -1 : bup ? 1 : sortInput ? indexOf(sortInput, a) - indexOf(sortInput, b) : 0; // If the nodes are siblings, we can do a quick check
          } else if (aup === bup) {
            return siblingCheck(a, b);
          } // Otherwise we need full lists of their ancestors for comparison


          cur = a;

          while (cur = cur.parentNode) {
            ap.unshift(cur);
          }

          cur = b;

          while (cur = cur.parentNode) {
            bp.unshift(cur);
          } // Walk down the tree looking for a discrepancy


          while (ap[i] === bp[i]) {
            i++;
          }

          return i ? // Do a sibling check if the nodes have a common ancestor
          siblingCheck(ap[i], bp[i]) : // Otherwise nodes in our document sort first
          ap[i] === preferredDoc ? -1 : bp[i] === preferredDoc ? 1 : 0;
        };
        return document;
      };

      Sizzle.matches = function (expr, elements) {
        return Sizzle(expr, null, null, elements);
      };

      Sizzle.matchesSelector = function (elem, expr) {
        // Set document vars if needed
        if ((elem.ownerDocument || elem) !== document) {
          setDocument(elem);
        }

        if (support.matchesSelector && documentIsHTML && !nonnativeSelectorCache[expr + " "] && (!rbuggyMatches || !rbuggyMatches.test(expr)) && (!rbuggyQSA || !rbuggyQSA.test(expr))) {
          try {
            var ret = matches.call(elem, expr); // IE 9's matchesSelector returns false on disconnected nodes

            if (ret || support.disconnectedMatch || // As well, disconnected nodes are said to be in a document
            // fragment in IE 9
            elem.document && elem.document.nodeType !== 11) {
              return ret;
            }
          } catch (e) {
            // [AdGuard Path]: Fix the cache value
            nonnativeSelectorCache(expr, true);
          }
        }

        return Sizzle(expr, document, null, [elem]).length > 0;
      };

      Sizzle.contains = function (context, elem) {
        // Set document vars if needed
        if ((context.ownerDocument || context) !== document) {
          setDocument(context);
        }

        return contains(context, elem);
      };

      Sizzle.attr = function (elem, name) {
        // Set document vars if needed
        if ((elem.ownerDocument || elem) !== document) {
          setDocument(elem);
        }

        var fn = Expr.attrHandle[name.toLowerCase()],
            // Don't get fooled by Object.prototype properties (jQuery #13807)
        val = fn && hasOwn.call(Expr.attrHandle, name.toLowerCase()) ? fn(elem, name, !documentIsHTML) : undefined;
        return val !== undefined ? val : support.attributes || !documentIsHTML ? elem.getAttribute(name) : (val = elem.getAttributeNode(name)) && val.specified ? val.value : null;
      };

      Sizzle.escape = function (sel) {
        return (sel + "").replace(rcssescape, fcssescape);
      };

      Sizzle.error = function (msg) {
        throw new Error("Syntax error, unrecognized expression: " + msg);
      };
      /**
       * Document sorting and removing duplicates
       * @param {ArrayLike} results
       */


      Sizzle.uniqueSort = function (results) {
        var elem,
            duplicates = [],
            j = 0,
            i = 0; // Unless we *know* we can detect duplicates, assume their presence

        hasDuplicate = !support.detectDuplicates;
        sortInput = !support.sortStable && results.slice(0);
        results.sort(sortOrder);

        if (hasDuplicate) {
          while (elem = results[i++]) {
            if (elem === results[i]) {
              j = duplicates.push(i);
            }
          }

          while (j--) {
            results.splice(duplicates[j], 1);
          }
        } // Clear input after sorting to release objects
        // See https://github.com/jquery/sizzle/pull/225


        sortInput = null;
        return results;
      };
      /**
       * Utility function for retrieving the text value of an array of DOM nodes
       * @param {Array|Element} elem
       */


      getText = Sizzle.getText = function (elem) {
        var node,
            ret = "",
            i = 0,
            nodeType = elem.nodeType;

        if (!nodeType) {
          // If no nodeType, this is expected to be an array
          while (node = elem[i++]) {
            // Do not traverse comment nodes
            ret += getText(node);
          }
        } else if (nodeType === 1 || nodeType === 9 || nodeType === 11) {
          // Use textContent for elements
          // innerText usage removed for consistency of new lines (jQuery #11153)
          if (typeof elem.textContent === "string") {
            return elem.textContent;
          } else {
            // Traverse its children
            for (elem = elem.firstChild; elem; elem = elem.nextSibling) {
              ret += getText(elem);
            }
          }
        } else if (nodeType === 3 || nodeType === 4) {
          return elem.nodeValue;
        } // Do not include comment or processing instruction nodes


        return ret;
      };

      Expr = Sizzle.selectors = {
        // Can be adjusted by the user
        cacheLength: 50,
        createPseudo: markFunction,
        match: matchExpr,
        attrHandle: {},
        find: {},
        relative: {
          ">": {
            dir: "parentNode",
            first: true
          },
          " ": {
            dir: "parentNode"
          },
          "+": {
            dir: "previousSibling",
            first: true
          },
          "~": {
            dir: "previousSibling"
          }
        },
        preFilter: {
          "ATTR": function ATTR(match) {
            match[1] = match[1].replace(runescape, funescape); // Move the given value to match[3] whether quoted or unquoted

            match[3] = (match[3] || match[4] || match[5] || "").replace(runescape, funescape);

            if (match[2] === "~=") {
              match[3] = " " + match[3] + " ";
            }

            return match.slice(0, 4);
          },
          "CHILD": function CHILD(match) {
            /* matches from matchExpr["CHILD"]
            	1 type (only|nth|...)
            	2 what (child|of-type)
            	3 argument (even|odd|\d*|\d*n([+-]\d+)?|...)
            	4 xn-component of xn+y argument ([+-]?\d*n|)
            	5 sign of xn-component
            	6 x of xn-component
            	7 sign of y-component
            	8 y of y-component
            */
            match[1] = match[1].toLowerCase();

            if (match[1].slice(0, 3) === "nth") {
              // nth-* requires argument
              if (!match[3]) {
                Sizzle.error(match[0]);
              } // numeric x and y parameters for Expr.filter.CHILD
              // remember that false/true cast respectively to 0/1


              match[4] = +(match[4] ? match[5] + (match[6] || 1) : 2 * (match[3] === "even" || match[3] === "odd"));
              match[5] = +(match[7] + match[8] || match[3] === "odd"); // other types prohibit arguments
            } else if (match[3]) {
              Sizzle.error(match[0]);
            }

            return match;
          },
          "PSEUDO": function PSEUDO(match) {
            var excess,
                unquoted = !match[6] && match[2];

            if (matchExpr["CHILD"].test(match[0])) {
              return null;
            } // Accept quoted arguments as-is


            if (match[3]) {
              match[2] = match[4] || match[5] || ""; // Strip excess characters from unquoted arguments
            } else if (unquoted && rpseudo.test(unquoted) && ( // Get excess from tokenize (recursively)
            excess = tokenize(unquoted, true)) && ( // advance to the next closing parenthesis
            excess = unquoted.indexOf(")", unquoted.length - excess) - unquoted.length)) {
              // excess is a negative index
              match[0] = match[0].slice(0, excess);
              match[2] = unquoted.slice(0, excess);
            } // Return only captures needed by the pseudo filter method (type and argument)


            return match.slice(0, 3);
          }
        },
        filter: {
          "TAG": function TAG(nodeNameSelector) {
            var nodeName = nodeNameSelector.replace(runescape, funescape).toLowerCase();
            return nodeNameSelector === "*" ? function () {
              return true;
            } : function (elem) {
              return elem.nodeName && elem.nodeName.toLowerCase() === nodeName;
            };
          },
          "CLASS": function CLASS(className) {
            var pattern = classCache[className + " "];
            return pattern || (pattern = new RegExp("(^|" + whitespace + ")" + className + "(" + whitespace + "|$)")) && classCache(className, function (elem) {
              return pattern.test(typeof elem.className === "string" && elem.className || typeof elem.getAttribute !== "undefined" && elem.getAttribute("class") || "");
            });
          },
          "ATTR": function ATTR(name, operator, check) {
            return function (elem) {
              var result = Sizzle.attr(elem, name);

              if (result == null) {
                return operator === "!=";
              }

              if (!operator) {
                return true;
              }

              result += "";
              return operator === "=" ? result === check : operator === "!=" ? result !== check : operator === "^=" ? check && result.indexOf(check) === 0 : operator === "*=" ? check && result.indexOf(check) > -1 : operator === "$=" ? check && result.slice(-check.length) === check : operator === "~=" ? (" " + result.replace(rwhitespace, " ") + " ").indexOf(check) > -1 : operator === "|=" ? result === check || result.slice(0, check.length + 1) === check + "-" : false;
            };
          },
          "CHILD": function CHILD(type, what, argument, first, last) {
            var simple = type.slice(0, 3) !== "nth",
                forward = type.slice(-4) !== "last",
                ofType = what === "of-type";
            return first === 1 && last === 0 ? // Shortcut for :nth-*(n)
            function (elem) {
              return !!elem.parentNode;
            } : function (elem, context, xml) {
              var cache,
                  uniqueCache,
                  outerCache,
                  node,
                  nodeIndex,
                  start,
                  dir = simple !== forward ? "nextSibling" : "previousSibling",
                  parent = elem.parentNode,
                  name = ofType && elem.nodeName.toLowerCase(),
                  useCache = !xml && !ofType,
                  diff = false;

              if (parent) {
                // :(first|last|only)-(child|of-type)
                if (simple) {
                  while (dir) {
                    node = elem;

                    while (node = node[dir]) {
                      if (ofType ? node.nodeName.toLowerCase() === name : node.nodeType === 1) {
                        return false;
                      }
                    } // Reverse direction for :only-* (if we haven't yet done so)


                    start = dir = type === "only" && !start && "nextSibling";
                  }

                  return true;
                }

                start = [forward ? parent.firstChild : parent.lastChild]; // non-xml :nth-child(...) stores cache data on `parent`

                if (forward && useCache) {
                  // Seek `elem` from a previously-cached index
                  // ...in a gzip-friendly way
                  node = parent;
                  outerCache = node[expando] || (node[expando] = {}); // Support: IE <9 only
                  // Defend against cloned attroperties (jQuery gh-1709)

                  uniqueCache = outerCache[node.uniqueID] || (outerCache[node.uniqueID] = {});
                  cache = uniqueCache[type] || [];
                  nodeIndex = cache[0] === dirruns && cache[1];
                  diff = nodeIndex && cache[2];
                  node = nodeIndex && parent.childNodes[nodeIndex];

                  while (node = ++nodeIndex && node && node[dir] || ( // Fallback to seeking `elem` from the start
                  diff = nodeIndex = 0) || start.pop()) {
                    // When found, cache indexes on `parent` and break
                    if (node.nodeType === 1 && ++diff && node === elem) {
                      uniqueCache[type] = [dirruns, nodeIndex, diff];
                      break;
                    }
                  }
                } else {
                  // Use previously-cached element index if available
                  if (useCache) {
                    // ...in a gzip-friendly way
                    node = elem;
                    outerCache = node[expando] || (node[expando] = {}); // Support: IE <9 only
                    // Defend against cloned attroperties (jQuery gh-1709)

                    uniqueCache = outerCache[node.uniqueID] || (outerCache[node.uniqueID] = {});
                    cache = uniqueCache[type] || [];
                    nodeIndex = cache[0] === dirruns && cache[1];
                    diff = nodeIndex;
                  } // xml :nth-child(...)
                  // or :nth-last-child(...) or :nth(-last)?-of-type(...)


                  if (diff === false) {
                    // Use the same loop as above to seek `elem` from the start
                    while (node = ++nodeIndex && node && node[dir] || (diff = nodeIndex = 0) || start.pop()) {
                      if ((ofType ? node.nodeName.toLowerCase() === name : node.nodeType === 1) && ++diff) {
                        // Cache the index of each encountered element
                        if (useCache) {
                          outerCache = node[expando] || (node[expando] = {}); // Support: IE <9 only
                          // Defend against cloned attroperties (jQuery gh-1709)

                          uniqueCache = outerCache[node.uniqueID] || (outerCache[node.uniqueID] = {});
                          uniqueCache[type] = [dirruns, diff];
                        }

                        if (node === elem) {
                          break;
                        }
                      }
                    }
                  }
                } // Incorporate the offset, then check against cycle size


                diff -= last;
                return diff === first || diff % first === 0 && diff / first >= 0;
              }
            };
          },
          "PSEUDO": function PSEUDO(pseudo, argument) {
            // pseudo-class names are case-insensitive
            // http://www.w3.org/TR/selectors/#pseudo-classes
            // Prioritize by case sensitivity in case custom pseudos are added with uppercase letters
            // Remember that setFilters inherits from pseudos
            var args,
                fn = Expr.pseudos[pseudo] || Expr.setFilters[pseudo.toLowerCase()] || Sizzle.error("unsupported pseudo: " + pseudo); // The user may use createPseudo to indicate that
            // arguments are needed to create the filter function
            // just as Sizzle does

            if (fn[expando]) {
              return fn(argument);
            } // But maintain support for old signatures


            if (fn.length > 1) {
              args = [pseudo, pseudo, "", argument];
              return Expr.setFilters.hasOwnProperty(pseudo.toLowerCase()) ? markFunction(function (seed, matches) {
                var idx,
                    matched = fn(seed, argument),
                    i = matched.length;

                while (i--) {
                  idx = indexOf(seed, matched[i]);
                  seed[idx] = !(matches[idx] = matched[i]);
                }
              }) : function (elem) {
                return fn(elem, 0, args);
              };
            }

            return fn;
          }
        },
        pseudos: {
          // Potentially complex pseudos
          "not": markFunction(function (selector) {
            // Trim the selector passed to compile
            // to avoid treating leading and trailing
            // spaces as combinators
            var input = [],
                results = [],
                matcher = compile(selector.replace(rtrim, "$1"));
            return matcher[expando] ? markFunction(function (seed, matches, context, xml) {
              var elem,
                  unmatched = matcher(seed, null, xml, []),
                  i = seed.length; // Match elements unmatched by `matcher`

              while (i--) {
                if (elem = unmatched[i]) {
                  seed[i] = !(matches[i] = elem);
                }
              }
            }) : function (elem, context, xml) {
              input[0] = elem;
              matcher(input, null, xml, results); // Don't keep the element (issue #299)

              input[0] = null;
              return !results.pop();
            };
          }),
          "has": markFunction(function (selector) {
            if (typeof selector === "string") {
              Sizzle.compile(selector);
            }

            return function (elem) {
              return Sizzle(selector, elem).length > 0;
            };
          }),
          // Removed :contains pseudo-class declaration
          // "Whether an element is represented by a :lang() selector
          // is based solely on the element's language value
          // being equal to the identifier C,
          // or beginning with the identifier C immediately followed by "-".
          // The matching of C against the element's language value is performed case-insensitively.
          // The identifier C does not have to be a valid language name."
          // http://www.w3.org/TR/selectors/#lang-pseudo
          "lang": markFunction(function (lang) {
            // lang value must be a valid identifier
            if (!ridentifier.test(lang || "")) {
              Sizzle.error("unsupported lang: " + lang);
            }

            lang = lang.replace(runescape, funescape).toLowerCase();
            return function (elem) {
              var elemLang;

              do {
                if (elemLang = documentIsHTML ? elem.lang : elem.getAttribute("xml:lang") || elem.getAttribute("lang")) {
                  elemLang = elemLang.toLowerCase();
                  return elemLang === lang || elemLang.indexOf(lang + "-") === 0;
                }
              } while ((elem = elem.parentNode) && elem.nodeType === 1);

              return false;
            };
          }),
          // Miscellaneous
          "target": function target(elem) {
            var hash = window.location && window.location.hash;
            return hash && hash.slice(1) === elem.id;
          },
          "root": function root(elem) {
            return elem === docElem;
          },
          "focus": function focus(elem) {
            return elem === document.activeElement && (!document.hasFocus || document.hasFocus()) && !!(elem.type || elem.href || ~elem.tabIndex);
          },
          // Boolean properties
          "enabled": createDisabledPseudo(false),
          "disabled": createDisabledPseudo(true),
          "checked": function checked(elem) {
            // In CSS3, :checked should return both checked and selected elements
            // http://www.w3.org/TR/2011/REC-css3-selectors-20110929/#checked
            var nodeName = elem.nodeName.toLowerCase();
            return nodeName === "input" && !!elem.checked || nodeName === "option" && !!elem.selected;
          },
          "selected": function selected(elem) {
            // Accessing this property makes selected-by-default
            // options in Safari work properly
            if (elem.parentNode) {
              elem.parentNode.selectedIndex;
            }

            return elem.selected === true;
          },
          // Contents
          "empty": function empty(elem) {
            // http://www.w3.org/TR/selectors/#empty-pseudo
            // :empty is negated by element (1) or content nodes (text: 3; cdata: 4; entity ref: 5),
            //   but not by others (comment: 8; processing instruction: 7; etc.)
            // nodeType < 6 works because attributes (2) do not appear as children
            for (elem = elem.firstChild; elem; elem = elem.nextSibling) {
              if (elem.nodeType < 6) {
                return false;
              }
            }

            return true;
          } // Removed custom pseudo-classes

        }
      }; // Removed custom pseudo-classes
      // Easy API for creating new setFilters

      function setFilters() {}

      setFilters.prototype = Expr.filters = Expr.pseudos;
      Expr.setFilters = new setFilters();
      /**
       * [AdGuard Patch]:
       * Sorts the tokens in order to mitigate the performance issues caused by matching slow pseudos first:
       * https://github.com/AdguardTeam/ExtendedCss/issues/55#issuecomment-364058745
       */

      var sortTokenGroups = function () {
        /**
         * Splits compound selector into a list of simple selectors
         *
         * @param {*} tokens Tokens to split into groups
         * @returns an array consisting of token groups (arrays) and relation tokens.
         */
        var splitCompoundSelector = function splitCompoundSelector(tokens) {
          var groups = [];
          var currentTokensGroup = [];
          var maxIdx = tokens.length - 1;

          for (var i = 0; i <= maxIdx; i++) {
            var token = tokens[i];
            var relative = Sizzle.selectors.relative[token.type];

            if (relative) {
              groups.push(currentTokensGroup);
              groups.push(token);
              currentTokensGroup = [];
            } else {
              currentTokensGroup.push(token);
            }

            if (i === maxIdx) {
              groups.push(currentTokensGroup);
            }
          }

          return groups;
        };

        var TOKEN_TYPES_VALUES = {
          // nth-child, etc, always go last
          "CHILD": 100,
          "ID": 90,
          "CLASS": 80,
          "TAG": 70,
          "ATTR": 70,
          "PSEUDO": 60
        };
        var POSITIONAL_PSEUDOS = ["nth", "first", "last", "eq", "even", "odd", "lt", "gt", "not"];
        /**
         * A function that defines the sort order.
         * Returns a value lesser than 0 if "left" is less than "right".
         */

        var compareFunction = function compareFunction(left, right) {
          var leftValue = TOKEN_TYPES_VALUES[left.type];
          var rightValue = TOKEN_TYPES_VALUES[right.type];
          return leftValue - rightValue;
        };
        /**
         * Checks if the specified tokens group is sortable.
         * We do not re-sort tokens in case of any positional or child pseudos in the group
         */


        var isSortable = function isSortable(tokens) {
          var iTokens = tokens.length;

          while (iTokens--) {
            var token = tokens[iTokens];

            if (token.type === "PSEUDO" && POSITIONAL_PSEUDOS.indexOf(token.matches[0]) !== -1) {
              return false;
            }

            if (token.type === "CHILD") {
              return false;
            }
          }

          return true;
        };
        /**
         * Sorts the tokens in order to mitigate the issues caused by the left-to-right matching.
         * The idea is change the tokens order so that Sizzle was matching fast selectors first (id, class),
         * and slow selectors after that (and here I mean our slow custom pseudo classes).
         *
         * @param {Array} tokens An array of tokens to sort
         * @returns {Array} A new re-sorted array
         */


        var sortTokens = function sortTokens(tokens) {
          if (!tokens || tokens.length === 1) {
            return tokens;
          }

          var sortedTokens = [];
          var groups = splitCompoundSelector(tokens);

          for (var i = 0; i < groups.length; i++) {
            var group = groups[i];

            if (group instanceof Array) {
              if (isSortable(group)) {
                group.sort(compareFunction);
              }

              sortedTokens = sortedTokens.concat(group);
            } else {
              sortedTokens.push(group);
            }
          }

          return sortedTokens;
        };
        /**
         * Sorts every tokens array inside of the specified "groups" array.
         * See "sortTokens" methods for more information on how tokens are sorted.
         *
         * @param {Array} groups An array of tokens arrays.
         * @returns {Array} A new array that consists of the same tokens arrays after sorting
         */


        var sortTokenGroups = function sortTokenGroups(groups) {
          var sortedGroups = [];
          var len = groups.length;
          var i = 0;

          for (; i < len; i++) {
            sortedGroups.push(sortTokens(groups[i]));
          }

          return sortedGroups;
        }; // Expose


        return sortTokenGroups;
      }();
      /**
       * Creates custom policy to use TrustedTypes CSP policy
       * https://w3c.github.io/webappsec-trusted-types/dist/spec/
       */


      var AGPolicy = function createPolicy() {
        var defaultPolicy = {
          createHTML: function createHTML(input) {
            return input;
          },
          createScript: function createScript(input) {
            return input;
          },
          createScriptURL: function createScriptURL(input) {
            return input;
          }
        };

        if (window.trustedTypes && window.trustedTypes.createPolicy) {
          return window.trustedTypes.createPolicy("AGPolicy", defaultPolicy);
        }

        return defaultPolicy;
      }();
      /**
       * [AdGuard Patch]:
       * Removes trailing spaces from the tokens list
       *
       * @param {*} tokens An array of Sizzle tokens to post-process
       */


      function removeTrailingSpaces(tokens) {
        var iTokens = tokens.length;

        while (iTokens--) {
          var token = tokens[iTokens];

          if (token.type === " ") {
            tokens.length = iTokens;
          } else {
            break;
          }
        }
      }
      /**
       * [AdGuard Patch]:
       * An object with the information about selectors and their token representation
       * @typedef {{selectorText: string, groups: Array}} SelectorData
       * @property {string} selectorText A CSS selector text
       * @property {Array} groups An array of token groups corresponding to that selector
       */

      /**
       * [AdGuard Patch]:
       * This method processes parsed token groups, divides them into a number of selectors
       * and makes sure that each selector's tokens are cached properly in Sizzle.
       *
       * @param {*} groups Token groups (see {@link Sizzle.tokenize})
       * @returns {Array.<SelectorData>} An array of selectors data we got from the groups
       */


      function tokenGroupsToSelectors(groups) {
        // Remove trailing spaces which we can encounter in tolerant mode
        // We're doing it in tolerant mode only as this is the only case when
        // encountering trailing spaces is expected
        removeTrailingSpaces(groups[groups.length - 1]); // We need sorted tokens to make cache work properly

        var sortedGroups = sortTokenGroups(groups);
        var selectors = [];

        for (var i = 0; i < groups.length; i++) {
          var tokenGroups = groups[i];
          var selectorText = toSelector(tokenGroups);
          selectors.push({
            // Sizzle expects an array of token groups when compiling a selector
            groups: [tokenGroups],
            selectorText: selectorText
          }); // Now make sure that selector tokens are cached

          var tokensCacheItem = {
            groups: tokenGroups,
            sortedGroups: [sortedGroups[i]]
          };
          tokenCache(selectorText, tokensCacheItem);
        }

        return selectors;
      }
      /**
       * [AdGuard Patch]:
       * Add an additional argument for Sizzle.tokenize which indicates that it
       * should not throw on invalid tokens, and instead should return tokens
       * that it has produced so far.
       *
       * One more additional argument that allow to choose if you want to receive sorted or unsorted tokens
       * The problem is that the re-sorted selectors are valid for Sizzle, but not for the browser.
       * options.returnUnsorted -- return unsorted tokens if true.
       * options.cacheOnly -- return cached result only. Required for unit-tests.
       *
       * @param {*} options Optional configuration object with two additional flags
       * (options.tolerant, options.returnUnsorted, options.cacheOnly) -- see patches #5 and #6 notes
       */


      tokenize = Sizzle.tokenize = function (selector, parseOnly, options) {
        var matched,
            match,
            tokens,
            type,
            soFar,
            groups,
            preFilters,
            cached = tokenCache[selector + " "];
        var tolerant = options && options.tolerant;
        var returnUnsorted = options && options.returnUnsorted;
        var cacheOnly = options && options.cacheOnly;

        if (cached) {
          if (parseOnly) {
            return 0;
          } else {
            return (returnUnsorted ? cached.groups : cached.sortedGroups).slice(0);
          }
        }

        if (cacheOnly) {
          return null;
        }

        soFar = selector;
        groups = [];
        preFilters = Expr.preFilter;

        while (soFar) {
          // Comma and first run
          if (!matched || (match = rcomma.exec(soFar))) {
            if (match) {
              // Don't consume trailing commas as valid
              soFar = soFar.slice(match[0].length) || soFar;
            }

            groups.push(tokens = []);
          }

          matched = false; // Combinators

          if (match = rcombinators.exec(soFar)) {
            matched = match.shift();
            tokens.push({
              value: matched,
              // Cast descendant combinators to space
              type: match[0].replace(rtrim, " ")
            });
            soFar = soFar.slice(matched.length);
          } // Filters


          for (type in Expr.filter) {
            if ((match = matchExpr[type].exec(soFar)) && (!preFilters[type] || (match = preFilters[type](match)))) {
              matched = match.shift();
              tokens.push({
                value: matched,
                type: type,
                matches: match
              });
              soFar = soFar.slice(matched.length);
            }
          }

          if (!matched) {
            break;
          }
        } // Return the length of the invalid excess
        // if we're just parsing
        // Otherwise, throw an error or return tokens


        var invalidLen = soFar.length;

        if (parseOnly) {
          return invalidLen;
        }

        if (invalidLen !== 0 && !tolerant) {
          Sizzle.error(selector); // Throws an error.
        }

        if (tolerant) {
          /**
           * [AdGuard Patch]:
           * In tolerant mode we return a special object that constists of
           * an array of parsed selectors (and their tokens) and a "nextIndex" field
           * that points to an index after which we're not able to parse selectors farther.
           */
          var nextIndex = selector.length - invalidLen;
          var selectors = tokenGroupsToSelectors(groups);
          return {
            selectors: selectors,
            nextIndex: nextIndex
          };
        }
        /** [AdGuard Patch]: Sorting tokens */


        var sortedGroups = sortTokenGroups(groups);
        /** [AdGuard Patch]: Change the way tokens are cached */

        var tokensCacheItem = {
          groups: groups,
          sortedGroups: sortedGroups
        };
        tokensCacheItem = tokenCache(selector, tokensCacheItem);
        return (returnUnsorted ? tokensCacheItem.groups : tokensCacheItem.sortedGroups).slice(0);
      };

      function toSelector(tokens) {
        var i = 0,
            len = tokens.length,
            selector = "";

        for (; i < len; i++) {
          selector += tokens[i].value;
        }

        return selector;
      }

      function addCombinator(matcher, combinator, base) {
        var dir = combinator.dir,
            skip = combinator.next,
            key = skip || dir,
            checkNonElements = base && key === "parentNode",
            doneName = done++;
        return combinator.first ? // Check against closest ancestor/preceding element
        function (elem, context, xml) {
          while (elem = elem[dir]) {
            if (elem.nodeType === 1 || checkNonElements) {
              return matcher(elem, context, xml);
            }
          }

          return false;
        } : // Check against all ancestor/preceding elements
        function (elem, context, xml) {
          var oldCache,
              uniqueCache,
              outerCache,
              newCache = [dirruns, doneName]; // We can't set arbitrary data on XML nodes, so they don't benefit from combinator caching

          if (xml) {
            while (elem = elem[dir]) {
              if (elem.nodeType === 1 || checkNonElements) {
                if (matcher(elem, context, xml)) {
                  return true;
                }
              }
            }
          } else {
            while (elem = elem[dir]) {
              if (elem.nodeType === 1 || checkNonElements) {
                outerCache = elem[expando] || (elem[expando] = {}); // Support: IE <9 only
                // Defend against cloned attroperties (jQuery gh-1709)

                uniqueCache = outerCache[elem.uniqueID] || (outerCache[elem.uniqueID] = {});

                if (skip && skip === elem.nodeName.toLowerCase()) {
                  elem = elem[dir] || elem;
                } else if ((oldCache = uniqueCache[key]) && oldCache[0] === dirruns && oldCache[1] === doneName) {
                  // Assign to newCache so results back-propagate to previous elements
                  return newCache[2] = oldCache[2];
                } else {
                  // Reuse newcache so results back-propagate to previous elements
                  uniqueCache[key] = newCache; // A match means we're done; a fail means we have to keep checking

                  if (newCache[2] = matcher(elem, context, xml)) {
                    return true;
                  }
                }
              }
            }
          }

          return false;
        };
      }

      function elementMatcher(matchers) {
        return matchers.length > 1 ? function (elem, context, xml) {
          var i = matchers.length;

          while (i--) {
            if (!matchers[i](elem, context, xml)) {
              return false;
            }
          }

          return true;
        } : matchers[0];
      }

      function multipleContexts(selector, contexts, results) {
        var i = 0,
            len = contexts.length;

        for (; i < len; i++) {
          Sizzle(selector, contexts[i], results);
        }

        return results;
      }

      function condense(unmatched, map, filter, context, xml) {
        var elem,
            newUnmatched = [],
            i = 0,
            len = unmatched.length,
            mapped = map != null;

        for (; i < len; i++) {
          if (elem = unmatched[i]) {
            if (!filter || filter(elem, context, xml)) {
              newUnmatched.push(elem);

              if (mapped) {
                map.push(i);
              }
            }
          }
        }

        return newUnmatched;
      }

      function setMatcher(preFilter, selector, matcher, postFilter, postFinder, postSelector) {
        if (postFilter && !postFilter[expando]) {
          postFilter = setMatcher(postFilter);
        }

        if (postFinder && !postFinder[expando]) {
          postFinder = setMatcher(postFinder, postSelector);
        }

        return markFunction(function (seed, results, context, xml) {
          var temp,
              i,
              elem,
              preMap = [],
              postMap = [],
              preexisting = results.length,
              // Get initial elements from seed or context
          elems = seed || multipleContexts(selector || "*", context.nodeType ? [context] : context, []),
              // Prefilter to get matcher input, preserving a map for seed-results synchronization
          matcherIn = preFilter && (seed || !selector) ? condense(elems, preMap, preFilter, context, xml) : elems,
              matcherOut = matcher ? // If we have a postFinder, or filtered seed, or non-seed postFilter or preexisting results,
          postFinder || (seed ? preFilter : preexisting || postFilter) ? // ...intermediate processing is necessary
          [] : // ...otherwise use results directly
          results : matcherIn; // Find primary matches

          if (matcher) {
            matcher(matcherIn, matcherOut, context, xml);
          } // Apply postFilter


          if (postFilter) {
            temp = condense(matcherOut, postMap);
            postFilter(temp, [], context, xml); // Un-match failing elements by moving them back to matcherIn

            i = temp.length;

            while (i--) {
              if (elem = temp[i]) {
                matcherOut[postMap[i]] = !(matcherIn[postMap[i]] = elem);
              }
            }
          }

          if (seed) {
            if (postFinder || preFilter) {
              if (postFinder) {
                // Get the final matcherOut by condensing this intermediate into postFinder contexts
                temp = [];
                i = matcherOut.length;

                while (i--) {
                  if (elem = matcherOut[i]) {
                    // Restore matcherIn since elem is not yet a final match
                    temp.push(matcherIn[i] = elem);
                  }
                }

                postFinder(null, matcherOut = [], temp, xml);
              } // Move matched elements from seed to results to keep them synchronized


              i = matcherOut.length;

              while (i--) {
                if ((elem = matcherOut[i]) && (temp = postFinder ? indexOf(seed, elem) : preMap[i]) > -1) {
                  seed[temp] = !(results[temp] = elem);
                }
              }
            } // Add elements to results, through postFinder if defined

          } else {
            matcherOut = condense(matcherOut === results ? matcherOut.splice(preexisting, matcherOut.length) : matcherOut);

            if (postFinder) {
              postFinder(null, results, matcherOut, xml);
            } else {
              push.apply(results, matcherOut);
            }
          }
        });
      }

      function matcherFromTokens(tokens) {
        var checkContext,
            matcher,
            j,
            len = tokens.length,
            leadingRelative = Expr.relative[tokens[0].type],
            implicitRelative = leadingRelative || Expr.relative[" "],
            i = leadingRelative ? 1 : 0,
            // The foundational matcher ensures that elements are reachable from top-level context(s)
        matchContext = addCombinator(function (elem) {
          return elem === checkContext;
        }, implicitRelative, true),
            matchAnyContext = addCombinator(function (elem) {
          return indexOf(checkContext, elem) > -1;
        }, implicitRelative, true),
            matchers = [function (elem, context, xml) {
          var ret = !leadingRelative && (xml || context !== outermostContext) || ((checkContext = context).nodeType ? matchContext(elem, context, xml) : matchAnyContext(elem, context, xml)); // Avoid hanging onto element (issue #299)

          checkContext = null;
          return ret;
        }];

        for (; i < len; i++) {
          if (matcher = Expr.relative[tokens[i].type]) {
            matchers = [addCombinator(elementMatcher(matchers), matcher)];
          } else {
            matcher = Expr.filter[tokens[i].type].apply(null, tokens[i].matches); // Return special upon seeing a positional matcher

            if (matcher[expando]) {
              // Find the next relative operator (if any) for proper handling
              j = ++i;

              for (; j < len; j++) {
                if (Expr.relative[tokens[j].type]) {
                  break;
                }
              }

              return setMatcher(i > 1 && elementMatcher(matchers), i > 1 && toSelector( // If the preceding token was a descendant combinator, insert an implicit any-element `*`
              tokens.slice(0, i - 1).concat({
                value: tokens[i - 2].type === " " ? "*" : ""
              })).replace(rtrim, "$1"), matcher, i < j && matcherFromTokens(tokens.slice(i, j)), j < len && matcherFromTokens(tokens = tokens.slice(j)), j < len && toSelector(tokens));
            }

            matchers.push(matcher);
          }
        }

        return elementMatcher(matchers);
      }

      function matcherFromGroupMatchers(elementMatchers, setMatchers) {
        var bySet = setMatchers.length > 0,
            byElement = elementMatchers.length > 0,
            superMatcher = function superMatcher(seed, context, xml, results, outermost) {
          var elem,
              j,
              matcher,
              matchedCount = 0,
              i = "0",
              unmatched = seed && [],
              setMatched = [],
              contextBackup = outermostContext,
              // We must always have either seed elements or outermost context
          elems = seed || byElement && Expr.find["TAG"]("*", outermost),
              // Use integer dirruns iff this is the outermost matcher
          dirrunsUnique = dirruns += contextBackup == null ? 1 : Math.random() || 0.1,
              len = elems.length;

          if (outermost) {
            outermostContext = context === document || context || outermost;
          } // Add elements passing elementMatchers directly to results
          // Support: IE<9, Safari
          // Tolerate NodeList properties (IE: "length"; Safari: <number>) matching elements by id


          for (; i !== len && (elem = elems[i]) != null; i++) {
            if (byElement && elem) {
              j = 0;

              if (!context && elem.ownerDocument !== document) {
                setDocument(elem);
                xml = !documentIsHTML;
              }

              while (matcher = elementMatchers[j++]) {
                if (matcher(elem, context || document, xml)) {
                  results.push(elem);
                  break;
                }
              }

              if (outermost) {
                dirruns = dirrunsUnique;
              }
            } // Track unmatched elements for set filters


            if (bySet) {
              // They will have gone through all possible matchers
              if (elem = !matcher && elem) {
                matchedCount--;
              } // Lengthen the array for every element, matched or not


              if (seed) {
                unmatched.push(elem);
              }
            }
          } // `i` is now the count of elements visited above, and adding it to `matchedCount`
          // makes the latter nonnegative.


          matchedCount += i; // Apply set filters to unmatched elements
          // NOTE: This can be skipped if there are no unmatched elements (i.e., `matchedCount`
          // equals `i`), unless we didn't visit _any_ elements in the above loop because we have
          // no element matchers and no seed.
          // Incrementing an initially-string "0" `i` allows `i` to remain a string only in that
          // case, which will result in a "00" `matchedCount` that differs from `i` but is also
          // numerically zero.

          if (bySet && i !== matchedCount) {
            j = 0;

            while (matcher = setMatchers[j++]) {
              matcher(unmatched, setMatched, context, xml);
            }

            if (seed) {
              // Reintegrate element matches to eliminate the need for sorting
              if (matchedCount > 0) {
                while (i--) {
                  if (!(unmatched[i] || setMatched[i])) {
                    setMatched[i] = pop.call(results);
                  }
                }
              } // Discard index placeholder values to get only actual matches


              setMatched = condense(setMatched);
            } // Add matches to results


            push.apply(results, setMatched); // Seedless set matches succeeding multiple successful matchers stipulate sorting

            if (outermost && !seed && setMatched.length > 0 && matchedCount + setMatchers.length > 1) {
              Sizzle.uniqueSort(results);
            }
          } // Override manipulation of globals by nested matchers


          if (outermost) {
            dirruns = dirrunsUnique;
            outermostContext = contextBackup;
          }

          return unmatched;
        };

        return bySet ? markFunction(superMatcher) : superMatcher;
      }

      compile = Sizzle.compile = function (selector, match
      /* Internal Use Only */
      ) {
        var i,
            setMatchers = [],
            elementMatchers = [],
            cached = compilerCache[selector + " "];

        if (!cached) {
          // Generate a function of recursive functions that can be used to check each element
          if (!match) {
            match = tokenize(selector);
          }

          i = match.length;

          while (i--) {
            cached = matcherFromTokens(match[i]);

            if (cached[expando]) {
              setMatchers.push(cached);
            } else {
              elementMatchers.push(cached);
            }
          } // Cache the compiled function


          cached = compilerCache(selector, matcherFromGroupMatchers(elementMatchers, setMatchers)); // Save selector and tokenization

          cached.selector = selector;
        }

        return cached;
      };
      /**
       * A low-level selection function that works with Sizzle's compiled
       *  selector functions
       * @param {String|Function} selector A selector or a pre-compiled
       *  selector function built with Sizzle.compile
       * @param {Element} context
       * @param {Array} [results]
       * @param {Array} [seed] A set of elements to match against
       */


      select = Sizzle.select = function (selector, context, results, seed) {
        var i,
            tokens,
            token,
            type,
            find,
            compiled = typeof selector === "function" && selector,
            match = !seed && tokenize(selector = compiled.selector || selector);
        results = results || []; // Try to minimize operations if there is only one selector in the list and no seed
        // (the latter of which guarantees us context)

        if (match.length === 1) {
          // Reduce context if the leading compound selector is an ID
          tokens = match[0] = match[0].slice(0);

          if (tokens.length > 2 && (token = tokens[0]).type === "ID" && context.nodeType === 9 && documentIsHTML && Expr.relative[tokens[1].type]) {
            context = (Expr.find["ID"](token.matches[0].replace(runescape, funescape), context) || [])[0];

            if (!context) {
              return results; // Precompiled matchers will still verify ancestry, so step up a level
            } else if (compiled) {
              context = context.parentNode;
            }

            selector = selector.slice(tokens.shift().value.length);
          } // Fetch a seed set for right-to-left matching


          i = matchExpr["needsContext"].test(selector) ? 0 : tokens.length;

          while (i--) {
            token = tokens[i]; // Abort if we hit a combinator

            if (Expr.relative[type = token.type]) {
              break;
            }

            if (find = Expr.find[type]) {
              // Search, expanding context for leading sibling combinators
              if (seed = find(token.matches[0].replace(runescape, funescape), rsibling.test(tokens[0].type) && testContext(context.parentNode) || context)) {
                // If seed is empty or no tokens remain, we can return early
                tokens.splice(i, 1);
                selector = seed.length && toSelector(tokens);

                if (!selector) {
                  push.apply(results, seed);
                  return results;
                }

                break;
              }
            }
          }
        } // Compile and execute a filtering function if one is not provided
        // Provide `match` to avoid retokenization if we modified the selector above


        (compiled || compile(selector, match))(seed, context, !documentIsHTML, results, !context || rsibling.test(selector) && testContext(context.parentNode) || context);
        return results;
      }; // One-time assignments
      // Sort stability


      support.sortStable = expando.split("").sort(sortOrder).join("") === expando; // Support: Chrome 14-35+
      // Always assume duplicates if they aren't passed to the comparison function

      support.detectDuplicates = !!hasDuplicate; // Initialize against the default document

      setDocument(); // Support: Webkit<537.32 - Safari 6.0.3/Chrome 25 (fixed in Chrome 27)
      // Detached nodes confoundingly follow *each other*

      support.sortDetached = assert(function (el) {
        // Should return 1, but returns 4 (following)
        return el.compareDocumentPosition(document.createElement("fieldset")) & 1;
      }); // Support: IE<8
      // Prevent attribute/property "interpolation"
      // https://msdn.microsoft.com/en-us/library/ms536429%28VS.85%29.aspx

      if (!assert(function (el) {
        el.innerHTML = AGPolicy.createHTML("<a href='#'></a>");
        return el.firstChild.getAttribute("href") === "#";
      })) {
        addHandle("type|href|height|width", function (elem, name, isXML) {
          if (!isXML) {
            return elem.getAttribute(name, name.toLowerCase() === "type" ? 1 : 2);
          }
        });
      } // Support: IE<9
      // Use defaultValue in place of getAttribute("value")


      if (!support.attributes || !assert(function (el) {
        el.innerHTML = AGPolicy.createHTML("<input/>");
        el.firstChild.setAttribute("value", "");
        return el.firstChild.getAttribute("value") === "";
      })) {
        addHandle("value", function (elem, name, isXML) {
          if (!isXML && elem.nodeName.toLowerCase() === "input") {
            return elem.defaultValue;
          }
        });
      } // Support: IE<9
      // Use getAttributeNode to fetch booleans when getAttribute lies


      if (!assert(function (el) {
        return el.getAttribute("disabled") == null;
      })) {
        addHandle(booleans, function (elem, name, isXML) {
          var val;

          if (!isXML) {
            return elem[name] === true ? name.toLowerCase() : (val = elem.getAttributeNode(name)) && val.specified ? val.value : null;
          }
        });
      } // EXPOSE
      // Do not expose Sizzle to the global scope in the case of AdGuard ExtendedCss build


      return Sizzle; // EXPOSE
    }(window); //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  }

  return Sizzle;
};

/* jshint ignore:end */

/**
 * Copyright 2016 Adguard Software Ltd
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/**
 * Class that extends Sizzle and adds support for "matches-css" pseudo element.
 */

var StylePropertyMatcher = function (window) {
  var isPhantom = !!window._phantom;
  var useFallback = isPhantom && !!window.getMatchedCSSRules;
  /**
   * Unquotes specified value
   * Webkit-based browsers singlequotes <string> content property values
   * Other browsers doublequotes content property values.
   */

  var removeContentQuotes = function removeContentQuotes(value) {
    if (typeof value === 'string') {
      return value.replace(/^(["'])([\s\S]*)\1$/, '$2');
    }

    return value;
  };

  var getComputedStyle = window.getComputedStyle.bind(window);
  var getMatchedCSSRules = useFallback ? window.getMatchedCSSRules.bind(window) : null;
  /**
   * There is an issue in browsers based on old webkit:
   * getComputedStyle(el, ":before") is empty if element is not visible.
   *
   * To circumvent this issue we use getMatchedCSSRules instead.
   *
   * It appears that getMatchedCSSRules sorts the CSS rules
   * in increasing order of specifities of corresponding selectors.
   * We pick the css rule that is being applied to an element based on this assumption.
   *
   * @param element       DOM node
   * @param pseudoElement Optional pseudoElement name
   * @param propertyName  CSS property name
   */

  var getComputedStylePropertyValue = function getComputedStylePropertyValue(element, pseudoElement, propertyName) {
    var value = '';

    if (useFallback && pseudoElement) {
      var cssRules = getMatchedCSSRules(element, pseudoElement) || [];
      var i = cssRules.length;

      while (i-- > 0 && !value) {
        value = cssRules[i].style.getPropertyValue(propertyName);
      }
    } else {
      var style = getComputedStyle(element, pseudoElement);

      if (style) {
        value = style.getPropertyValue(propertyName); // https://bugs.webkit.org/show_bug.cgi?id=93445

        if (propertyName === 'opacity' && utils.isSafariBrowser) {
          value = (Math.round(parseFloat(value) * 100) / 100).toString();
        }
      }
    }

    if (propertyName === 'content') {
      value = removeContentQuotes(value);
    }

    return value;
  };
  /**
   * Adds url parameter quotes for non-regex pattern
   * @param {string} pattern
   */


  var addUrlQuotes = function addUrlQuotes(pattern) {
    // for regex patterns
    if (pattern[0] === '/' && pattern[pattern.length - 1] === '/' && pattern.indexOf('\\"') < 10) {
      // e.g. /^url\\([a-z]{4}:[a-z]{5}/
      // or /^url\\(data\\:\\image\\/gif;base64.+/
      var re = /(\^)?url(\\)?\\\((\w|\[\w)/g;
      return pattern.replace(re, '$1url$2\\\(\\"?$3');
    } // for non-regex patterns


    if (pattern.indexOf('url("') === -1) {
      var _re = /url\((.*?)\)/g;
      return pattern.replace(_re, 'url("$1")');
    }

    return pattern;
  };
  /**
   * Class that matches element style against the specified expression
   * @member {string} propertyName
   * @member {string} pseudoElement
   * @member {RegExp} regex
   */


  var Matcher = function Matcher(propertyFilter, pseudoElement) {
    this.pseudoElement = pseudoElement;

    try {
      var index = propertyFilter.indexOf(':');
      this.propertyName = propertyFilter.substring(0, index).trim();
      var pattern = propertyFilter.substring(index + 1).trim();
      pattern = addUrlQuotes(pattern); // Unescaping pattern
      // For non-regex patterns, (,),[,] should be unescaped, because we require escaping them in filter rules.
      // For regex patterns, ",\ should be escaped, because we manually escape those in extended-css-selector.js.

      if (/^\/.*\/$/.test(pattern)) {
        pattern = pattern.slice(1, -1);
        this.regex = utils.pseudoArgToRegex(pattern);
      } else {
        pattern = pattern.replace(/\\([\\()[\]"])/g, '$1');
        this.regex = utils.createURLRegex(pattern);
      }
    } catch (ex) {
      utils.logError("StylePropertyMatcher: invalid match string ".concat(propertyFilter));
    }
  };
  /**
   * Function to check if element CSS property matches filter pattern
   * @param {Element} element to check
   */


  Matcher.prototype.matches = function (element) {
    if (!this.regex || !this.propertyName) {
      return false;
    }

    var value = getComputedStylePropertyValue(element, this.pseudoElement, this.propertyName);
    return value && this.regex.test(value);
  };
  /**
   * Creates a new pseudo-class and registers it in Sizzle
   */


  var extendSizzle = function extendSizzle(sizzle) {
    // First of all we should prepare Sizzle engine
    sizzle.selectors.pseudos['matches-css'] = sizzle.selectors.createPseudo(function (propertyFilter) {
      var matcher = new Matcher(propertyFilter);
      return function (element) {
        return matcher.matches(element);
      };
    });
    sizzle.selectors.pseudos['matches-css-before'] = sizzle.selectors.createPseudo(function (propertyFilter) {
      var matcher = new Matcher(propertyFilter, ':before');
      return function (element) {
        return matcher.matches(element);
      };
    });
    sizzle.selectors.pseudos['matches-css-after'] = sizzle.selectors.createPseudo(function (propertyFilter) {
      var matcher = new Matcher(propertyFilter, ':after');
      return function (element) {
        return matcher.matches(element);
      };
    });
  }; // EXPOSE


  return {
    extendSizzle: extendSizzle
  };
}(window);

/**
 * Copyright 2016 Adguard Software Ltd
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
var matcherUtils = {};
matcherUtils.MutationObserver = window.MutationObserver || window.WebKitMutationObserver;
/**
 * Parses argument of matcher pseudo (for matches-attr and matches-property)
 * @param {string} matcherFilter argument of pseudo class
 * @returns {Array}
 */

matcherUtils.parseMatcherFilter = function (matcherFilter) {
  var FULL_MATCH_MARKER = '"="';
  var rawArgs = [];

  if (matcherFilter.indexOf(FULL_MATCH_MARKER) === -1) {
    // if there is only one pseudo arg
    // e.g. :matches-attr("data-name") or :matches-property("inner.prop")
    // Sizzle will parse it and get rid of quotes
    // so it might be valid arg already without them
    rawArgs.push(matcherFilter);
  } else {
    matcherFilter.split('=').forEach(function (arg) {
      if (arg[0] === '"' && arg[arg.length - 1] === '"') {
        rawArgs.push(arg.slice(1, -1));
      }
    });
  }

  return rawArgs;
};
/**
 * @typedef {Object} ArgData
 * @property {string} arg
 * @property {boolean} isRegexp
 */

/**
 * Parses raw matcher arg
 * @param {string} rawArg
 * @returns {ArgData}
 */


matcherUtils.parseRawMatcherArg = function (rawArg) {
  var arg = rawArg;
  var isRegexp = !!rawArg && rawArg[0] === '/' && rawArg[rawArg.length - 1] === '/';

  if (isRegexp) {
    // to avoid at least such case — :matches-property("//")
    if (rawArg.length > 2) {
      arg = utils.toRegExp(rawArg);
    } else {
      throw new Error("Invalid regexp: ".concat(rawArg));
    }
  }

  return {
    arg: arg,
    isRegexp: isRegexp
  };
};
/**
 * @typedef Chain
 * @property {Object} base
 * @property {string} prop
 * @property {string} value
 */

/**
 * Checks if the property exists in the base object (recursively).
 * @param {Object} base
 * @param {ArgData[]} chain array of objects - parsed string property chain
 * @param {Array} [output=[]] result acc
 * @returns {Chain[]} array of objects
 */


matcherUtils.filterRootsByRegexpChain = function (base, chain) {
  var output = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : [];
  var tempProp = chain[0];

  if (chain.length === 1) {
    // eslint-disable-next-line no-restricted-syntax
    for (var key in base) {
      if (tempProp.isRegexp) {
        if (tempProp.arg.test(key)) {
          output.push({
            base: base,
            prop: key,
            value: base[key]
          });
        }
      } else if (tempProp.arg === key) {
        output.push({
          base: base,
          prop: tempProp.arg,
          value: base[key]
        });
      }
    }

    return output;
  } // if there is a regexp prop in input chain
  // e.g. 'unit./^ad.+/.src' for 'unit.ad-1gf2.src unit.ad-fgd34.src'),
  // every base keys should be tested by regexp and it can be more that one results


  if (tempProp.isRegexp) {
    var nextProp = chain.slice(1);
    var baseKeys = []; // eslint-disable-next-line no-restricted-syntax

    for (var _key in base) {
      if (tempProp.arg.test(_key)) {
        baseKeys.push(_key);
      }
    }

    baseKeys.forEach(function (key) {
      var item = base[key];
      matcherUtils.filterRootsByRegexpChain(item, nextProp, output);
    });
  } // avoid TypeError while accessing to null-prop's child


  if (base === null) {
    return;
  }

  var nextBase = base[tempProp.arg];
  chain = chain.slice(1);

  if (nextBase !== undefined) {
    matcherUtils.filterRootsByRegexpChain(nextBase, chain, output);
  }

  return output;
};
/**
 * Validates parsed args of matches-property pseudo
 * @param {...ArgData} args
 */


matcherUtils.validatePropMatcherArgs = function () {
  for (var _len = arguments.length, args = new Array(_len), _key2 = 0; _key2 < _len; _key2++) {
    args[_key2] = arguments[_key2];
  }

  for (var i = 0; i < args.length; i += 1) {
    if (args[i].isRegexp) {
      if (!utils.startsWith(args[i].arg.toString(), '/') || !utils.endsWith(args[i].arg.toString(), '/')) {
        return false;
      } // simple arg check if it is not a regexp

    } else if (!/^[\w-]+$/.test(args[i].arg)) {
      return false;
    }
  }

  return true;
};

/**
 * Class that extends Sizzle and adds support for "matches-attr" pseudo element.
 */

var AttributesMatcher = function () {
  /**
   * Class that matches element attributes against the specified expressions
   * @param {ArgData} nameArg - parsed name argument
   * @param {ArgData} valueArg - parsed value argument
   * @param {string} pseudoElement
   * @constructor
   *
   * @member {string|RegExp} attrName
   * @member {boolean} isRegexpName
   * @member {string|RegExp} attrValue
   * @member {boolean} isRegexpValue
   */
  var AttrMatcher = function AttrMatcher(nameArg, valueArg, pseudoElement) {
    this.pseudoElement = pseudoElement;
    this.attrName = nameArg.arg;
    this.isRegexpName = nameArg.isRegexp;
    this.attrValue = valueArg.arg;
    this.isRegexpValue = valueArg.isRegexp;
  };
  /**
   * Function to check if element attributes matches filter pattern
   * @param {Element} element to check
   */


  AttrMatcher.prototype.matches = function (element) {
    var elAttrs = element.attributes;

    if (elAttrs.length === 0 || !this.attrName) {
      return false;
    }

    var i = 0;

    while (i < elAttrs.length) {
      var attr = elAttrs[i];
      var matched = false;
      var attrNameMatched = this.isRegexpName ? this.attrName.test(attr.name) : this.attrName === attr.name;

      if (!this.attrValue) {
        // for :matches-attr("/regex/") or :matches-attr("attr-name")
        matched = attrNameMatched;
      } else {
        var attrValueMatched = this.isRegexpValue ? this.attrValue.test(attr.value) : this.attrValue === attr.value;
        matched = attrNameMatched && attrValueMatched;
      }

      if (matched) {
        return true;
      }

      i += 1;
    }
  };
  /**
   * Creates a new pseudo-class and registers it in Sizzle
   */


  var extendSizzle = function extendSizzle(sizzle) {
    // First of all we should prepare Sizzle engine
    sizzle.selectors.pseudos['matches-attr'] = sizzle.selectors.createPseudo(function (attrFilter) {
      var _matcherUtils$parseMa = matcherUtils.parseMatcherFilter(attrFilter),
          _matcherUtils$parseMa2 = _slicedToArray(_matcherUtils$parseMa, 2),
          rawName = _matcherUtils$parseMa2[0],
          rawValue = _matcherUtils$parseMa2[1];

      var nameArg = matcherUtils.parseRawMatcherArg(rawName);
      var valueArg = matcherUtils.parseRawMatcherArg(rawValue);

      if (!attrFilter || !matcherUtils.validatePropMatcherArgs(nameArg, valueArg)) {
        throw new Error("Invalid argument of :matches-attr pseudo class: ".concat(attrFilter));
      }

      var matcher = new AttrMatcher(nameArg, valueArg);
      return function (element) {
        return matcher.matches(element);
      };
    });
  }; // EXPOSE


  return {
    extendSizzle: extendSizzle
  };
}();

/**
 * Parses raw property arg
 * @param {string} input
 * @returns {ArgData[]} array of objects
 */

var parseRawPropChain = function parseRawPropChain(input) {
  var PROPS_DIVIDER = '.';
  var REGEXP_MARKER = '/';
  var propsArr = [];
  var str = input;

  while (str.length > 0) {
    if (utils.startsWith(str, PROPS_DIVIDER)) {
      // for cases like '.prop.id' and 'nested..test'
      throw new Error("Invalid chain property: ".concat(input));
    }

    if (!utils.startsWith(str, REGEXP_MARKER)) {
      var isRegexp = false;
      var dividerIndex = str.indexOf(PROPS_DIVIDER);

      if (str.indexOf(PROPS_DIVIDER) === -1) {
        // if there is no '.' left in str
        // take the rest of str as prop
        propsArr.push({
          arg: str,
          isRegexp: isRegexp
        });
        return propsArr;
      } // else take prop from str


      var prop = str.slice(0, dividerIndex); // for cases like 'asadf.?+/.test'

      if (prop.indexOf(REGEXP_MARKER) > -1) {
        // prop is '?+/'
        throw new Error("Invalid chain property: ".concat(prop));
      }

      propsArr.push({
        arg: prop,
        isRegexp: isRegexp
      }); // delete prop from str

      str = str.slice(dividerIndex);
    } else {
      // deal with regexp
      var propChunks = [];
      propChunks.push(str.slice(0, 1)); // if str starts with '/', delete it from str and find closing regexp slash.
      // note that chained property name can not include '/' or '.'
      // so there is no checking for escaped characters

      str = str.slice(1);
      var regexEndIndex = str.indexOf(REGEXP_MARKER);

      if (regexEndIndex < 1) {
        // regexp should be at least === '/./'
        // so we should avoid args like '/id' and 'test.//.id'
        throw new Error("Invalid regexp: ".concat(REGEXP_MARKER).concat(str));
      }

      var _isRegexp = true; // take the rest regexp part

      propChunks.push(str.slice(0, regexEndIndex + 1));

      var _prop = utils.toRegExp(propChunks.join(''));

      propsArr.push({
        arg: _prop,
        isRegexp: _isRegexp
      }); // delete prop from str

      str = str.slice(regexEndIndex + 1);
    }

    if (!str) {
      return propsArr;
    } // str should be like '.nextProp' now
    // so 'zx.prop' or '.' is invalid


    if (!utils.startsWith(str, PROPS_DIVIDER) || utils.startsWith(str, PROPS_DIVIDER) && str.length === 1) {
      throw new Error("Invalid chain property: ".concat(input));
    }

    str = str.slice(1);
  }
};

var convertTypeFromStr = function convertTypeFromStr(value) {
  var numValue = Number(value);
  var output;

  if (!Number.isNaN(numValue)) {
    output = numValue;
  } else {
    switch (value) {
      case 'undefined':
        output = undefined;
        break;

      case 'null':
        output = null;
        break;

      case 'true':
        output = true;
        break;

      case 'false':
        output = false;
        break;

      default:
        output = value;
    }
  }

  return output;
};

var convertTypeIntoStr = function convertTypeIntoStr(value) {
  var output;

  switch (value) {
    case undefined:
      output = 'undefined';
      break;

    case null:
      output = 'null';
      break;

    default:
      output = value.toString();
  }

  return output;
};
/**
 * Class that extends Sizzle and adds support for "matches-property" pseudo element.
 */


var ElementPropertyMatcher = function () {
  /**
   * Class that matches element properties against the specified expressions
   * @param {ArgData[]} propsChainArg - array of parsed props chain objects
   * @param {ArgData} valueArg - parsed value argument
   * @param {string} pseudoElement
   * @constructor
   *
   * @member {Array} chainedProps
   * @member {boolean} isRegexpName
   * @member {string|RegExp} propValue
   * @member {boolean} isRegexpValue
   */
  var PropMatcher = function PropMatcher(propsChainArg, valueArg, pseudoElement) {
    this.pseudoElement = pseudoElement;
    this.chainedProps = propsChainArg;
    this.propValue = valueArg.arg;
    this.isRegexpValue = valueArg.isRegexp;
  };
  /**
   * Function to check if element properties matches filter pattern
   * @param {Element} element to check
   */


  PropMatcher.prototype.matches = function (element) {
    var ownerObjArr = matcherUtils.filterRootsByRegexpChain(element, this.chainedProps);

    if (ownerObjArr.length === 0) {
      return false;
    }

    var matched = true;

    if (this.propValue) {
      for (var i = 0; i < ownerObjArr.length; i += 1) {
        var realValue = ownerObjArr[i].value;

        if (this.isRegexpValue) {
          matched = this.propValue.test(convertTypeIntoStr(realValue));
        } else {
          // handle 'null' and 'undefined' property values set as string
          if (realValue === 'null' || realValue === 'undefined') {
            matched = this.propValue === realValue;
            break;
          }

          matched = convertTypeFromStr(this.propValue) === realValue;
        }

        if (matched) {
          break;
        }
      }
    }

    return matched;
  };
  /**
   * Creates a new pseudo-class and registers it in Sizzle
   */


  var extendSizzle = function extendSizzle(sizzle) {
    // First of all we should prepare Sizzle engine
    sizzle.selectors.pseudos['matches-property'] = sizzle.selectors.createPseudo(function (propertyFilter) {
      if (!propertyFilter) {
        throw new Error('No argument is given for :matches-property pseudo class');
      }

      var _matcherUtils$parseMa = matcherUtils.parseMatcherFilter(propertyFilter),
          _matcherUtils$parseMa2 = _slicedToArray(_matcherUtils$parseMa, 2),
          rawProp = _matcherUtils$parseMa2[0],
          rawValue = _matcherUtils$parseMa2[1]; // chained property name can not include '/' or '.'
      // so regex prop names with such escaped characters are invalid


      if (rawProp.indexOf('\\/') > -1 || rawProp.indexOf('\\.') > -1) {
        throw new Error("Invalid property name: ".concat(rawProp));
      }

      var propsChainArg = parseRawPropChain(rawProp);
      var valueArg = matcherUtils.parseRawMatcherArg(rawValue);
      var propsToValidate = [].concat(_toConsumableArray(propsChainArg), [valueArg]);

      if (!matcherUtils.validatePropMatcherArgs(propsToValidate)) {
        throw new Error("Invalid argument of :matches-property pseudo class: ".concat(propertyFilter));
      }

      var matcher = new PropMatcher(propsChainArg, valueArg);
      return function (element) {
        return matcher.matches(element);
      };
    });
  }; // EXPOSE


  return {
    extendSizzle: extendSizzle
  };
}();

/**
 * Copyright 2020 Adguard Software Ltd
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/**
 * Class that extends Sizzle and adds support for :is() pseudo element.
 */

var IsAnyMatcher = function () {
  /**
   * Class that matches element by one of the selectors
   * https://developer.mozilla.org/en-US/docs/Web/CSS/:is
   * @param {Array} selectors
   * @param {string} pseudoElement
   * @constructor
   */
  var IsMatcher = function IsMatcher(selectors, pseudoElement) {
    this.selectors = selectors;
    this.pseudoElement = pseudoElement;
  };
  /**
   * Function to check if element can be matched by any passed selector
   * @param {Element} element to check
   */


  IsMatcher.prototype.matches = function (element) {
    var isMatched = !!this.selectors.find(function (selector) {
      var nodes = document.querySelectorAll(selector);
      return Array.from(nodes).find(function (node) {
        return node === element;
      });
    });
    return isMatched;
  };
  /**
   * Creates a new pseudo-class and registers it in Sizzle
   */


  var extendSizzle = function extendSizzle(sizzle) {
    // First of all we should prepare Sizzle engine
    sizzle.selectors.pseudos['is'] = sizzle.selectors.createPseudo(function (input) {
      if (input === '') {
        throw new Error("Invalid argument of :is pseudo-class: ".concat(input));
      }

      var selectors = input.split(',').map(function (s) {
        return s.trim();
      }); // collect valid selectors and log about invalid ones

      var validSelectors = selectors.reduce(function (acc, selector) {
        if (cssUtils.isSimpleSelectorValid(selector)) {
          acc.push(selector);
        } else {
          utils.logInfo("Invalid selector passed to :is() pseudo-class: '".concat(selector, "'"));
        }

        return acc;
      }, []);
      var matcher = new IsMatcher(validSelectors);
      return function (element) {
        return matcher.matches(element);
      };
    });
  };

  return {
    extendSizzle: extendSizzle
  };
}();

/**
 * Copyright 2021 Adguard Software Ltd
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/**
 * Extended selector factory module, for creating extended selector classes.
 *
 * Extended selection capabilities description:
 * https://github.com/AdguardTeam/ExtendedCss/blob/master/README.md
 */

var ExtendedSelectorFactory = function () {
  // while adding new markers, constants in other AdGuard repos should be corrected
  // AdGuard browser extension : CssFilterRule.SUPPORTED_PSEUDO_CLASSES and CssFilterRule.EXTENDED_CSS_MARKERS
  // tsurlfilter, SafariConverterLib : EXT_CSS_PSEUDO_INDICATORS
  var PSEUDO_EXTENSIONS_MARKERS = [':has', ':contains', ':has-text', ':matches-css', ':-abp-has', ':-abp-has-text', ':if', ':if-not', ':xpath', ':nth-ancestor', ':upward', ':remove', ':matches-attr', ':matches-property', ':-abp-contains', ':is'];
  var initialized = false;
  var Sizzle;
  /**
   * Lazy initialization of the ExtendedSelectorFactory and objects that might be necessary for creating and applying styles.
   * This method extends Sizzle engine that we use under the hood with our custom pseudo-classes.
   */

  function initialize() {
    if (initialized) {
      return;
    }

    initialized = true; // Our version of Sizzle is initialized lazily as well

    Sizzle = initializeSizzle(); // Add :matches-css-*() support

    StylePropertyMatcher.extendSizzle(Sizzle); // Add :matches-attr() support

    AttributesMatcher.extendSizzle(Sizzle); // Add :matches-property() support

    ElementPropertyMatcher.extendSizzle(Sizzle); // Add :is() support

    IsAnyMatcher.extendSizzle(Sizzle); // Add :contains, :has-text, :-abp-contains support

    var containsPseudo = Sizzle.selectors.createPseudo(function (text) {
      if (/^\s*\/.*\/[gmisuy]*\s*$/.test(text)) {
        text = text.trim();
        var flagsIndex = text.lastIndexOf('/');
        var flags = text.substring(flagsIndex + 1);
        text = text.substr(0, flagsIndex + 1).slice(1, -1).replace(/\\([\\"])/g, '$1');
        var regex;

        try {
          regex = new RegExp(text, flags);
        } catch (e) {
          throw new Error("Invalid argument of :contains pseudo class: ".concat(text));
        }

        return function (elem) {
          var elemTextContent = utils.nodeTextContentGetter.apply(elem);
          return regex.test(elemTextContent);
        };
      }

      text = text.replace(/\\([\\()[\]"])/g, '$1');
      return function (elem) {
        var elemTextContent = utils.nodeTextContentGetter.apply(elem);
        return elemTextContent.indexOf(text) > -1;
      };
    });
    Sizzle.selectors.pseudos['contains'] = containsPseudo;
    Sizzle.selectors.pseudos['has-text'] = containsPseudo;
    Sizzle.selectors.pseudos['-abp-contains'] = containsPseudo; // Add :if, :-abp-has support

    Sizzle.selectors.pseudos['if'] = Sizzle.selectors.pseudos['has'];
    Sizzle.selectors.pseudos['-abp-has'] = Sizzle.selectors.pseudos['has']; // Add :if-not support

    Sizzle.selectors.pseudos['if-not'] = Sizzle.selectors.createPseudo(function (selector) {
      if (typeof selector === 'string') {
        Sizzle.compile(selector);
      }

      return function (elem) {
        return Sizzle(selector, elem).length === 0;
      };
    });
    registerParserOnlyTokens();
  }
  /**
   * Registrate custom tokens for parser.
   * Needed for proper work of pseudos:
   * for checking if the token is last and pseudo-class arguments validation
   */


  function registerParserOnlyTokens() {
    Sizzle.selectors.pseudos['xpath'] = Sizzle.selectors.createPseudo(function (selector) {
      try {
        document.createExpression(selector, null);
      } catch (e) {
        throw new Error("Invalid argument of :xpath pseudo class: ".concat(selector));
      }

      return function () {
        return true;
      };
    });
    Sizzle.selectors.pseudos['nth-ancestor'] = Sizzle.selectors.createPseudo(function (selector) {
      var deep = Number(selector);

      if (Number.isNaN(deep) || deep < 1 || deep >= 256) {
        throw new Error("Invalid argument of :nth-ancestor pseudo class: ".concat(selector));
      }

      return function () {
        return true;
      };
    });
    Sizzle.selectors.pseudos['upward'] = Sizzle.selectors.createPseudo(function (input) {
      if (input === '') {
        throw new Error("Invalid argument of :upward pseudo class: ".concat(input));
      } else if (Number.isInteger(+input) && (+input < 1 || +input >= 256)) {
        throw new Error("Invalid argument of :upward pseudo class: ".concat(input));
      }

      return function () {
        return true;
      };
    });
    Sizzle.selectors.pseudos['remove'] = Sizzle.selectors.createPseudo(function (input) {
      if (input !== '') {
        throw new Error("Invalid argument of :remove pseudo class: ".concat(input));
      }

      return function () {
        return true;
      };
    });
  }
  /**
   * Checks if specified token can be used by document.querySelectorAll.
   */


  function isSimpleToken(token) {
    var type = token.type;

    if (type === 'ID' || type === 'CLASS' || type === 'ATTR' || type === 'TAG' || type === 'CHILD') {
      // known simple tokens
      return true;
    }

    if (type === 'PSEUDO') {
      // check if value contains any of extended pseudo classes
      var i = PSEUDO_EXTENSIONS_MARKERS.length;

      while (i--) {
        if (token.value.indexOf(PSEUDO_EXTENSIONS_MARKERS[i]) >= 0) {
          return false;
        }
      }

      return true;
    } // all others aren't simple


    return false;
  }
  /**
   * Checks if specified token is a combinator
   */


  function isRelationToken(token) {
    var type = token.type;
    return type === ' ' || type === '>' || type === '+' || type === '~';
  }
  /**
   * ExtendedSelectorParser is a helper class for creating various selector instances which
   * all shares a method `querySelectorAll()` and `matches()` implementing different search strategies
   * depending on a type of selector.
   *
   * Currently, there are 3 types:
   *  A trait-less extended selector
   *    - we directly feed selector strings to Sizzle.
   *  A splitted extended selector
   *    - such as #container #feedItem:has(.ads), where it is splitted to `#container` and `#feedItem:has(.ads)`.
   */


  function ExtendedSelectorParser(selectorText, tokens, debug) {
    initialize();

    if (typeof tokens === 'undefined') {
      this.selectorText = cssUtils.normalize(selectorText); // Passing `returnUnsorted` in order to receive tokens in the order that's valid for the browser
      // In Sizzle internally, the tokens are re-sorted: https://github.com/AdguardTeam/ExtendedCss/issues/55

      this.tokens = Sizzle.tokenize(this.selectorText, false, {
        returnUnsorted: true
      });
    } else {
      this.selectorText = selectorText;
      this.tokens = tokens;
    }

    if (debug === true) {
      this.debug = true;
    }
  }

  ExtendedSelectorParser.prototype = {
    /**
     * The main method, creates a selector instance depending on the type of a selector.
     * @public
     */
    createSelector: function createSelector() {
      var debug = this.debug;
      var tokens = this.tokens;
      var selectorText = this.selectorText;

      if (tokens.length !== 1) {
        // Comma-separate selector - can't optimize further
        return new TraitLessSelector(selectorText, debug);
      }

      var xpathPart = this.getXpathPart();

      if (typeof xpathPart !== 'undefined') {
        return new XpathSelector(selectorText, xpathPart, debug);
      }

      var upwardPart = this.getUpwardPart();

      if (typeof upwardPart !== 'undefined') {
        var output;
        var upwardDeep = parseInt(upwardPart, 10); // if upward parameter is not a number, we consider it as a selector

        if (Number.isNaN(upwardDeep)) {
          output = new UpwardSelector(selectorText, upwardPart, debug);
        } else {
          // upward works like nth-ancestor
          var xpath = this.convertNthAncestorToken(upwardDeep);
          output = new XpathSelector(selectorText, xpath, debug);
        }

        return output;
      } // argument of pseudo-class remove;
      // it's defined only if remove is parsed as last token
      // and it's valid only if remove arg is empty string


      var removePart = this.getRemovePart();

      if (typeof removePart !== 'undefined') {
        var hasValidRemovePart = removePart === '';
        return new RemoveSelector(selectorText, hasValidRemovePart, debug);
      }

      tokens = tokens[0];
      var l = tokens.length;
      var lastRelTokenInd = this.getSplitPoint();

      if (typeof lastRelTokenInd === 'undefined') {
        try {
          document.querySelector(selectorText);
        } catch (e) {
          return new TraitLessSelector(selectorText, debug);
        }

        return new NotAnExtendedSelector(selectorText, debug);
      }

      var simple = '';
      var relation = null;
      var complex = '';
      var i = 0;

      for (; i < lastRelTokenInd; i++) {
        // build simple part
        simple += tokens[i].value;
      }

      if (i > 0) {
        // build relation part
        relation = tokens[i++].type;
      } // i is pointing to the start of a complex part.


      for (; i < l; i++) {
        complex += tokens[i].value;
      }

      return lastRelTokenInd === -1 ? new TraitLessSelector(selectorText, debug) : new SplittedSelector(selectorText, simple, relation, complex, debug);
    },

    /**
     * @private
     * @return {number|undefined} An index of a token that is split point.
     * returns undefined if the selector does not contain any complex tokens
     * or it is not eligible for splitting.
     * Otherwise returns an integer indicating the index of the last relation token.
     */
    getSplitPoint: function getSplitPoint() {
      var tokens = this.tokens[0]; // We split selector only when the last compound selector
      // is the only extended selector.

      var latestRelationTokenIndex = -1;
      var haveMetComplexToken = false;

      for (var i = 0, l = tokens.length; i < l; i++) {
        var token = tokens[i];

        if (isRelationToken(token)) {
          if (haveMetComplexToken) {
            return;
          }

          latestRelationTokenIndex = i;
        } else if (!isSimpleToken(token)) {
          haveMetComplexToken = true;
        }
      }

      if (!haveMetComplexToken) {
        return;
      }

      return latestRelationTokenIndex;
    },

    /**
     * @private
     * @return {string|undefined} xpath selector part if exists
     * returns undefined if the selector does not contain xpath tokens
     */
    getXpathPart: function getXpathPart() {
      var tokens = this.tokens[0];

      for (var i = 0, tokensLength = tokens.length; i < tokensLength; i++) {
        var token = tokens[i];

        if (token.type === 'PSEUDO') {
          var matches = token.matches;

          if (matches && matches.length > 1) {
            if (matches[0] === 'xpath') {
              if (this.isLastToken(tokens, i)) {
                throw new Error('Invalid pseudo: \':xpath\' should be at the end of the selector');
              }

              return matches[1];
            }

            if (matches[0] === 'nth-ancestor') {
              if (this.isLastToken(tokens, i)) {
                throw new Error('Invalid pseudo: \':nth-ancestor\' should be at the end of the selector');
              }

              var deep = matches[1];

              if (deep > 0 && deep < 256) {
                return this.convertNthAncestorToken(deep);
              }
            }
          }
        }
      }
    },

    /**
     * converts nth-ancestor/upward deep value to xpath equivalent
     * @param {number} deep
     * @return {string}
     */
    convertNthAncestorToken: function convertNthAncestorToken(deep) {
      var result = '..';

      while (deep > 1) {
        result += '/..';
        deep--;
      }

      return result;
    },

    /**
     * Checks if the token is last,
     * except of remove pseudo-class
     * @param {Array} tokens
     * @param {number} i index of token
     * @returns {boolean}
     */
    isLastToken: function isLastToken(tokens, i) {
      // check id the next parsed token is remove pseudo
      var isNextRemoveToken = tokens[i + 1] && tokens[i + 1].type === 'PSEUDO' && tokens[i + 1].matches && tokens[i + 1].matches[0] === 'remove'; // check if the token is last
      // and if it is not check if it is remove one
      // which should be skipped

      return i + 1 !== tokens.length && !isNextRemoveToken;
    },

    /**
     * @private
     * @return {string|undefined} upward parameter
     * or undefined if the input does not contain upward tokens
     */
    getUpwardPart: function getUpwardPart() {
      var tokens = this.tokens[0];

      for (var i = 0, tokensLength = tokens.length; i < tokensLength; i++) {
        var token = tokens[i];

        if (token.type === 'PSEUDO') {
          var matches = token.matches;

          if (matches && matches.length > 1) {
            if (matches[0] === 'upward') {
              if (this.isLastToken(tokens, i)) {
                throw new Error('Invalid pseudo: \':upward\' should be at the end of the selector');
              }

              return matches[1];
            }
          }
        }
      }
    },

    /**
     * @private
     * @return {string|undefined} remove parameter
     * or undefined if the input does not contain remove tokens
     */
    getRemovePart: function getRemovePart() {
      var tokens = this.tokens[0];

      for (var i = 0, tokensLength = tokens.length; i < tokensLength; i++) {
        var token = tokens[i];

        if (token.type === 'PSEUDO') {
          var matches = token.matches;

          if (matches && matches.length > 1) {
            if (matches[0] === 'remove') {
              if (i + 1 !== tokensLength) {
                throw new Error('Invalid pseudo: \':remove\' should be at the end of the selector');
              }

              return matches[1];
            }
          }
        }
      }
    }
  };
  var globalDebuggingFlag = false;

  function isDebugging() {
    return globalDebuggingFlag || this.debug;
  }
  /**
   * This class represents a selector which is not an extended selector.
   * @param {string} selectorText
   * @param {boolean=} debug
   * @final
   */


  function NotAnExtendedSelector(selectorText, debug) {
    this.selectorText = selectorText;
    this.debug = debug;
  }

  NotAnExtendedSelector.prototype = {
    querySelectorAll: function querySelectorAll() {
      return document.querySelectorAll(this.selectorText);
    },
    matches: function matches(element) {
      return element[utils.matchesPropertyName](this.selectorText);
    },
    isDebugging: isDebugging
  };
  /**
   * A trait-less extended selector class.
   * @param {string} selectorText
   * @param {boolean=} debug
   * @constructor
   */

  function TraitLessSelector(selectorText, debug) {
    this.selectorText = selectorText;
    this.debug = debug;
    Sizzle.compile(selectorText);
  }

  TraitLessSelector.prototype = {
    querySelectorAll: function querySelectorAll() {
      return Sizzle(this.selectorText);
    },

    /** @final */
    matches: function matches(element) {
      return Sizzle.matchesSelector(element, this.selectorText);
    },

    /** @final */
    isDebugging: isDebugging
  };
  /**
   * Parental class for such pseudo-classes as xpath, upward, remove
   * which are limited to be the last one token in selector
   *
   * @param {string} selectorText
   * @param {string} pseudoClassArg pseudo-class arg
   * @param {boolean=} debug
   * @constructor
   */

  function BaseLastArgumentSelector(selectorText, pseudoClassArg, debug) {
    this.selectorText = selectorText;
    this.pseudoClassArg = pseudoClassArg;
    this.debug = debug;
    Sizzle.compile(this.selectorText);
  }

  BaseLastArgumentSelector.prototype = {
    querySelectorAll: function querySelectorAll() {
      var _this = this;

      var resultNodes = [];
      var simpleNodes;

      if (this.selectorText) {
        simpleNodes = Sizzle(this.selectorText);

        if (!simpleNodes || !simpleNodes.length) {
          return resultNodes;
        }
      } else {
        simpleNodes = [document];
      }

      simpleNodes.forEach(function (node) {
        _this.searchResultNodes(node, _this.pseudoClassArg, resultNodes);
      });
      return Sizzle.uniqueSort(resultNodes);
    },

    /** @final */
    matches: function matches(element) {
      var results = this.querySelectorAll();
      return results.indexOf(element) > -1;
    },

    /** @final */
    isDebugging: isDebugging,

    /**
     * Primitive method that returns all nodes if pseudo-class arg is defined.
     * That logic works for remove pseudo-class,
     * but for others it should be overridden.
     * @param {Object} node context element
     * @param {string} pseudoClassArg pseudo-class argument
     * @param {Array} result
     */
    searchResultNodes: function searchResultNodes(node, pseudoClassArg, result) {
      if (pseudoClassArg) {
        result.push(node);
      }
    }
  };
  /**
   * Xpath selector class
   * Limited to support 'xpath' to be only the last one token in selector
   * @param {string} selectorText
   * @param {string} xpath value
   * @param {boolean=} debug
   * @constructor
   * @augments BaseLastArgumentSelector
   */

  function XpathSelector(selectorText, xpath, debug) {
    var NO_SELECTOR_MARKER = ':xpath(//';
    var BODY_SELECTOR_REPLACER = 'body:xpath(//';
    var modifiedSelectorText = selectorText; // Normally, a pseudo-class is applied to nodes selected by a selector -- selector:xpath(...).
    // However, :xpath is special as the selector can be ommited.
    // For any other pseudo-class that would mean "apply to ALL DOM nodes",
    // but in case of :xpath it just means "apply me to the document".

    if (utils.startsWith(selectorText, NO_SELECTOR_MARKER)) {
      modifiedSelectorText = selectorText.replace(NO_SELECTOR_MARKER, BODY_SELECTOR_REPLACER);
    }

    BaseLastArgumentSelector.call(this, modifiedSelectorText, xpath, debug);
  }

  XpathSelector.prototype = Object.create(BaseLastArgumentSelector.prototype);
  XpathSelector.prototype.constructor = XpathSelector;
  /**
   * Applies xpath pseudo-class to provided context node
   * @param {Object} node context element
   * @param {string} pseudoClassArg xpath
   * @param {Array} result
   * @override
   */

  XpathSelector.prototype.searchResultNodes = function (node, pseudoClassArg, result) {
    var xpathResult = document.evaluate(pseudoClassArg, node, null, XPathResult.UNORDERED_NODE_ITERATOR_TYPE, null);
    var iNode; // eslint-disable-next-line no-cond-assign

    while (iNode = xpathResult.iterateNext()) {
      result.push(iNode);
    }
  };
  /**
   * Upward selector class
   * Limited to support 'upward' to be only the last one token in selector
   * @param {string} selectorText
   * @param {string} upwardSelector value
   * @param {boolean=} debug
   * @constructor
   * @augments BaseLastArgumentSelector
   */


  function UpwardSelector(selectorText, upwardSelector, debug) {
    BaseLastArgumentSelector.call(this, selectorText, upwardSelector, debug);
  }

  UpwardSelector.prototype = Object.create(BaseLastArgumentSelector.prototype);
  UpwardSelector.prototype.constructor = UpwardSelector;
  /**
   * Applies upward pseudo-class to provided context node
   * @param {Object} node context element
   * @param {string} upwardSelector upward selector
   * @param {Array} result
   * @override
   */

  UpwardSelector.prototype.searchResultNodes = function (node, upwardSelector, result) {
    if (upwardSelector !== '') {
      var parent = node.parentElement;

      if (parent === null) {
        return;
      }

      node = parent.closest(upwardSelector);

      if (node === null) {
        return;
      }
    }

    result.push(node);
  };
  /**
   * Remove selector class
   * Limited to support 'remove' to be only the last one token in selector
   * @param {string} selectorText
   * @param {boolean} hasValidRemovePart
   * @param {boolean=} debug
   * @constructor
   * @augments BaseLastArgumentSelector
   */


  function RemoveSelector(selectorText, hasValidRemovePart, debug) {
    var REMOVE_PSEUDO_MARKER = ':remove()';
    var removeMarkerIndex = selectorText.indexOf(REMOVE_PSEUDO_MARKER); // deleting remove part of rule instead of which
    // pseudo-property property 'remove' will be added by ExtendedCssParser

    var modifiedSelectorText = selectorText.slice(0, removeMarkerIndex);
    BaseLastArgumentSelector.call(this, modifiedSelectorText, hasValidRemovePart, debug); // mark extendedSelector as Remove one for ExtendedCssParser

    this.isRemoveSelector = true;
  }

  RemoveSelector.prototype = Object.create(BaseLastArgumentSelector.prototype);
  RemoveSelector.prototype.constructor = RemoveSelector;
  /**
   * A splitted extended selector class.
   *
   * #container #feedItem:has(.ads)
   * +--------+                     simple
   *           +                    relation
   *            +-----------------+ complex
   * We split selector only when the last selector is complex
   * @param {string} selectorText
   * @param {string} simple
   * @param {string} relation
   * @param {string} complex
   * @param {boolean=} debug
   * @constructor
   * @extends TraitLessSelector
   */

  function SplittedSelector(selectorText, simple, relation, complex, debug) {
    TraitLessSelector.call(this, selectorText, debug);
    this.simple = simple;
    this.relation = relation;
    this.complex = complex;
    Sizzle.compile(complex);
  }

  SplittedSelector.prototype = Object.create(TraitLessSelector.prototype);
  SplittedSelector.prototype.constructor = SplittedSelector;
  /** @override */

  SplittedSelector.prototype.querySelectorAll = function () {
    var _this2 = this;

    var resultNodes = [];
    var simpleNodes;
    var simple = this.simple;
    var relation;

    if (simple) {
      // First we use simple selector to narrow our search
      simpleNodes = document.querySelectorAll(simple);

      if (!simpleNodes || !simpleNodes.length) {
        return resultNodes;
      }

      relation = this.relation;
    } else {
      simpleNodes = [document];
      relation = ' ';
    }

    switch (relation) {
      case ' ':
        simpleNodes.forEach(function (node) {
          _this2.relativeSearch(node, resultNodes);
        });
        break;

      case '>':
        {
          simpleNodes.forEach(function (node) {
            Object.values(node.children).forEach(function (childNode) {
              if (_this2.matches(childNode)) {
                resultNodes.push(childNode);
              }
            });
          });
          break;
        }

      case '+':
        {
          simpleNodes.forEach(function (node) {
            var parentNode = node.parentNode;
            Object.values(parentNode.children).forEach(function (childNode) {
              if (_this2.matches(childNode) && childNode.previousElementSibling === node) {
                resultNodes.push(childNode);
              }
            });
          });
          break;
        }

      case '~':
        {
          simpleNodes.forEach(function (node) {
            var parentNode = node.parentNode;
            Object.values(parentNode.children).forEach(function (childNode) {
              if (_this2.matches(childNode) && node.compareDocumentPosition(childNode) === 4) {
                resultNodes.push(childNode);
              }
            });
          });
          break;
        }
    }

    return Sizzle.uniqueSort(resultNodes);
  };
  /**
   * Performs a search of "complex" part relative to results for the "simple" part.
   * @param {Node} node a node matching the "simple" part.
   * @param {Node[]} result an array to append search result.
   */


  SplittedSelector.prototype.relativeSearch = function (node, results) {
    Sizzle(this.complex, node, results);
  };

  return {
    /**
     * Wraps the inner class so that the instance is not exposed.
     */
    createSelector: function createSelector(selector, tokens, debug) {
      return new ExtendedSelectorParser(selector, tokens, debug).createSelector();
    },

    /**
     * Mark every selector as a selector being debugged, so that timing information
     * for the selector is printed to the console.
     */
    enableGlobalDebugging: function enableGlobalDebugging() {
      globalDebuggingFlag = true;
    }
  };
}();

/**
 * Copyright 2016 Adguard Software Ltd
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/**
 * A helper class that parses stylesheets containing extended selectors
 * into ExtendedSelector instances and key-value maps of style declarations.
 * Please note, that it does not support any complex things like media queries and such.
 */

var ExtendedCssParser = function () {
  var reDeclEnd = /[;}]/g;
  var reDeclDivider = /[;:}]/g;
  var reNonWhitespace = /\S/g;
  var Sizzle;
  /**
   * @param {string} cssText
   * @constructor
   */

  function Parser(cssText) {
    this.cssText = cssText;
  }

  Parser.prototype = {
    error: function error(position) {
      throw new Error("CssParser: parse error at position ".concat(this.posOffset + position));
    },

    /**
     * Validates that the tokens correspond to a valid selector.
     * Sizzle is different from browsers and some selectors that it tolerates aren't actually valid.
     * For instance, "div >" won't work in a browser, but it will in Sizzle (it'd be the same as "div > *").
     *
     * @param {*} selectors An array of SelectorData (selector, groups)
     * @returns {boolean} false if any of the groups are invalid
     */
    validateSelectors: function validateSelectors(selectors) {
      var iSelectors = selectors.length;

      while (iSelectors--) {
        var groups = selectors[iSelectors].groups;
        var iGroups = groups.length;

        while (iGroups--) {
          var tokens = groups[iGroups];
          var lastToken = tokens[tokens.length - 1];

          if (Sizzle.selectors.relative[lastToken.type]) {
            return false;
          }
        }
      }

      return true;
    },

    /**
     * Parses a stylesheet and returns a list of pairs of an ExtendedSelector and a styles map.
     * This method will throw an error in case of an obviously invalid input.
     * If any of the selectors used in the stylesheet cannot be compiled into an ExtendedSelector,
     * it will be ignored.
     *
     * @typedef {Object} ExtendedStyle
     * @property {Object} selector An instance of the {@link ExtendedSelector} class
     * @property {Object} styleMap A map of styles parsed
     *
     * @returns {Array.<ExtendedStyle>} An array of the styles parsed
     */
    parseCss: function parseCss() {
      this.posOffset = 0;

      if (!this.cssText) {
        this.error(0);
      }

      var results = [];

      while (this.cssText) {
        // Apply tolerant tokenization.
        var parseResult = Sizzle.tokenize(this.cssText, false, {
          tolerant: true,
          returnUnsorted: true
        });
        var selectorData = parseResult.selectors;
        this.nextIndex = parseResult.nextIndex;

        if (this.cssText.charCodeAt(this.nextIndex) !== 123 ||
        /* charCode of '{' */
        !this.validateSelectors(selectorData)) {
          this.error(this.nextIndex);
        }

        this.nextIndex++; // Move the pointer to the start of style declaration.

        var styleMap = this.parseNextStyle();
        var debug = false; // If there is a style property 'debug', mark the selector
        // as a debuggable selector, and delete the style declaration.

        var debugPropertyValue = styleMap['debug'];

        if (typeof debugPropertyValue !== 'undefined') {
          if (debugPropertyValue === 'global') {
            ExtendedSelectorFactory.enableGlobalDebugging();
          }

          debug = true;
          delete styleMap['debug'];
        } // Creating an ExtendedSelector instance for every selector we got from Sizzle.tokenize.
        // This is quite important as Sizzle does a poor job at executing selectors like "selector1, selector2".


        for (var i = 0, l = selectorData.length; i < l; i++) {
          var data = selectorData[i];

          try {
            var extendedSelector = ExtendedSelectorFactory.createSelector(data.selectorText, data.groups, debug);

            if (extendedSelector.pseudoClassArg && extendedSelector.isRemoveSelector) {
              // if there is remove pseudo-class in rule,
              // the element will be removed and no other styles will be applied
              styleMap['remove'] = 'true';
            }

            results.push({
              selector: extendedSelector,
              style: styleMap
            });
          } catch (ex) {
            utils.logError("ExtendedCssParser: ignoring invalid selector ".concat(data.selectorText));
          }
        }
      }

      return results;
    },
    parseNextStyle: function parseNextStyle() {
      var styleMap = Object.create(null);
      var bracketPos = this.parseUntilClosingBracket(styleMap); // Cut out matched portion from cssText.

      reNonWhitespace.lastIndex = bracketPos + 1;
      var match = reNonWhitespace.exec(this.cssText);

      if (match === null) {
        this.cssText = '';
        return styleMap;
      }

      var matchPos = match.index;
      this.cssText = this.cssText.slice(matchPos);
      this.posOffset += matchPos;
      return styleMap;
    },

    /**
     * @return {number} an index of the next '}' in `this.cssText`.
     */
    parseUntilClosingBracket: function parseUntilClosingBracket(styleMap) {
      // Expects ":", ";", and "}".
      reDeclDivider.lastIndex = this.nextIndex;
      var match = reDeclDivider.exec(this.cssText);

      if (match === null) {
        this.error(this.nextIndex);
      }

      var matchPos = match.index;
      var matched = match[0];

      if (matched === '}') {
        return matchPos;
      }

      if (matched === ':') {
        var colonIndex = matchPos; // Expects ";" and "}".

        reDeclEnd.lastIndex = colonIndex;
        match = reDeclEnd.exec(this.cssText);

        if (match === null) {
          this.error(colonIndex);
        }

        matchPos = match.index;
        matched = match[0]; // Populates the `styleMap` key-value map.

        var property = this.cssText.slice(this.nextIndex, colonIndex).trim();
        var value = this.cssText.slice(colonIndex + 1, matchPos).trim();
        styleMap[property] = value; // If found "}", re-run the outer loop.

        if (matched === '}') {
          return matchPos;
        }
      } // matchPos is the position of the next ';'.
      // Increase 'nextIndex' and re-run the loop.


      this.nextIndex = matchPos + 1;
      return this.parseUntilClosingBracket(styleMap); // Should be a subject of tail-call optimization.
    }
  };
  return {
    parseCss: function parseCss(cssText) {
      Sizzle = initializeSizzle();
      return new Parser(cssUtils.normalize(cssText)).parseCss();
    }
  };
}();

/**
 * This callback is used to get affected node elements and handle style properties
 * before they are applied to them if it is necessary
 * @callback beforeStyleApplied
 * @param {object} affectedElement - Object containing DOM node and rule to be applied
 * @return {object} affectedElement - Same or modified object containing DOM node and rule to be applied
 */

/**
 * Extended css class
 *
 * @param {Object} configuration
 * @param {string} configuration.styleSheet - the CSS stylesheet text
 * @param {beforeStyleApplied} [configuration.beforeStyleApplied] - the callback that handles affected elements
 * @constructor
 */

function ExtendedCss(configuration) {
  if (!configuration) {
    throw new Error('Configuration is not provided.');
  }

  var styleSheet = configuration.styleSheet;
  var beforeStyleApplied = configuration.beforeStyleApplied;

  if (beforeStyleApplied && typeof beforeStyleApplied !== 'function') {
    // eslint-disable-next-line max-len
    throw new Error("Wrong configuration. Type of 'beforeStyleApplied' field should be a function, received: ".concat(_typeof(beforeStyleApplied)));
  } // We use EventTracker to track the event that is likely to cause the mutation.
  // The problem is that we cannot use `window.event` directly from the mutation observer call
  // as we're not in the event handler context anymore.


  var EventTracker = function () {
    var ignoredEventTypes = ['mouseover', 'mouseleave', 'mouseenter', 'mouseout'];
    var LAST_EVENT_TIMEOUT_MS = 10;
    var EVENTS = [// keyboard events
    'keydown', 'keypress', 'keyup', // mouse events
    'auxclick', 'click', 'contextmenu', 'dblclick', 'mousedown', 'mouseenter', 'mouseleave', 'mousemove', 'mouseover', 'mouseout', 'mouseup', 'pointerlockchange', 'pointerlockerror', 'select', 'wheel']; // 'wheel' event makes scrolling in Safari twitchy
    // https://github.com/AdguardTeam/ExtendedCss/issues/120

    var safariProblematicEvents = ['wheel'];
    var trackedEvents = utils.isSafariBrowser ? EVENTS.filter(function (el) {
      return !(safariProblematicEvents.indexOf(el) > -1);
    }) : EVENTS;
    var lastEventType;
    var lastEventTime;

    var trackEvent = function trackEvent(e) {
      lastEventType = e.type;
      lastEventTime = Date.now();
    };

    trackedEvents.forEach(function (evName) {
      document.documentElement.addEventListener(evName, trackEvent, true);
    });

    var getLastEventType = function getLastEventType() {
      return lastEventType;
    };

    var getTimeSinceLastEvent = function getTimeSinceLastEvent() {
      return Date.now() - lastEventTime;
    };

    return {
      isIgnoredEventType: function isIgnoredEventType() {
        return ignoredEventTypes.indexOf(getLastEventType()) > -1 && getTimeSinceLastEvent() < LAST_EVENT_TIMEOUT_MS;
      }
    };
  }();

  var rules = [];
  var affectedElements = [];
  var removalsStatistic = {};
  var domObserved;
  var eventListenerSupported = window.addEventListener;
  var domMutationObserver;

  function observeDocument(callback) {
    // We are trying to limit the number of callback calls by not calling it on all kind of "hover" events.
    // The rationale behind this is that "hover" events often cause attributes modification,
    // but re-applying extCSS rules will be useless as these attribute changes are usually transient.
    var isIgnoredMutation = function isIgnoredMutation(mutations) {
      for (var i = 0; i < mutations.length; i += 1) {
        if (mutations.type !== 'attributes') {
          return false;
        }
      }

      return true;
    };

    if (utils.MutationObserver) {
      domMutationObserver = new utils.MutationObserver(function (mutations) {
        if (!mutations || mutations.length === 0) {
          return;
        }

        if (EventTracker.isIgnoredEventType() && isIgnoredMutation(mutations)) {
          return;
        }

        callback();
      });
      domMutationObserver.observe(document, {
        childList: true,
        subtree: true,
        attributes: true,
        attributeFilter: ['id', 'class']
      });
    } else if (eventListenerSupported) {
      document.addEventListener('DOMNodeInserted', callback, false);
      document.addEventListener('DOMNodeRemoved', callback, false);
      document.addEventListener('DOMAttrModified', callback, false);
    }
  }

  function disconnectDocument(callback) {
    if (domMutationObserver) {
      domMutationObserver.disconnect();
    } else if (eventListenerSupported) {
      document.removeEventListener('DOMNodeInserted', callback, false);
      document.removeEventListener('DOMNodeRemoved', callback, false);
      document.removeEventListener('DOMAttrModified', callback, false);
    }
  }

  var MAX_STYLE_PROTECTION_COUNT = 50;
  var protectionObserverOption = {
    attributes: true,
    attributeOldValue: true,
    attributeFilter: ['style']
  };
  /**
   * Creates MutationObserver protection function
   *
   * @param styles
   * @return {protectionFunction}
   */

  function createProtectionFunction(styles) {
    function protectionFunction(mutations, observer) {
      if (!mutations.length) {
        return;
      }

      var mutation = mutations[0];
      var target = mutation.target;
      observer.disconnect();
      styles.forEach(function (style) {
        setStyleToElement(target, style);
      });

      if (++observer.styleProtectionCount < MAX_STYLE_PROTECTION_COUNT) {
        observer.observe(target, protectionObserverOption);
      } else {
        utils.logError('ExtendedCss: infinite loop protection for style');
      }
    }

    return protectionFunction;
  }
  /**
   * Sets up a MutationObserver which protects style attributes from changes
   * @param node DOM node
   * @param rules rules
   * @returns Mutation observer used to protect attribute or null if there's nothing to protect
   */


  function protectStyleAttribute(node, rules) {
    if (!utils.MutationObserver) {
      return null;
    }

    var styles = rules.map(function (r) {
      return r.style;
    });
    var protectionObserver = new utils.MutationObserver(createProtectionFunction(styles));
    protectionObserver.observe(node, protectionObserverOption); // Adds an expando to the observer to keep 'style fix counts'.

    protectionObserver.styleProtectionCount = 0;
    return protectionObserver;
  }

  function removeSuffix(str, suffix) {
    var index = str.indexOf(suffix, str.length - suffix.length);

    if (index >= 0) {
      return str.substring(0, index);
    }

    return str;
  }
  /**
   * Finds affectedElement object for the specified DOM node
   * @param node  DOM node
   * @returns     affectedElement found or null
   */


  function findAffectedElement(node) {
    for (var i = 0; i < affectedElements.length; i += 1) {
      if (affectedElements[i].node === node) {
        return affectedElements[i];
      }
    }

    return null;
  }

  function removeElement(affectedElement) {
    var node = affectedElement.node;
    affectedElement.removed = true;
    var elementSelector = utils.getNodeSelector(node); // check if the element has been already removed earlier

    var elementRemovalsCounter = removalsStatistic[elementSelector] || 0; // if removals attempts happened more than specified we do not try to remove node again

    if (elementRemovalsCounter > MAX_STYLE_PROTECTION_COUNT) {
      utils.logError('ExtendedCss: infinite loop protection for SELECTOR', elementSelector);
      return;
    }

    if (node.parentNode) {
      node.parentNode.removeChild(node);
      removalsStatistic[elementSelector] = elementRemovalsCounter + 1;
    }
  }
  /**
   * Applies style to the specified DOM node
   * @param affectedElement Object containing DOM node and rule to be applied
   */


  function applyStyle(affectedElement) {
    if (affectedElement.protectionObserver) {
      // Style is already applied and protected by the observer
      return;
    }

    if (beforeStyleApplied) {
      affectedElement = beforeStyleApplied(affectedElement);

      if (!affectedElement) {
        return;
      }
    }

    var _affectedElement = affectedElement,
        node = _affectedElement.node;

    for (var i = 0; i < affectedElement.rules.length; i++) {
      var style = affectedElement.rules[i].style;

      if (style['remove'] === 'true') {
        removeElement(affectedElement);
        return;
      }

      setStyleToElement(node, style);
    }
  }
  /**
   * Sets style to the specified DOM node
   * @param node element
   * @param style style
   */


  function setStyleToElement(node, style) {
    Object.keys(style).forEach(function (prop) {
      // Apply this style only to existing properties
      // We can't use hasOwnProperty here (does not work in FF)
      if (typeof node.style.getPropertyValue(prop) !== 'undefined') {
        var value = style[prop]; // First we should remove !important attribute (or it won't be applied')

        value = removeSuffix(value.trim(), '!important').trim();
        node.style.setProperty(prop, value, 'important');
      }
    });
  }
  /**
   * Reverts style for the affected object
   */


  function revertStyle(affectedElement) {
    if (affectedElement.protectionObserver) {
      affectedElement.protectionObserver.disconnect();
    }

    affectedElement.node.style.cssText = affectedElement.originalStyle;
  }
  /**
   * Applies specified rule and returns list of elements affected
   * @param rule Rule to apply
   * @returns List of elements affected by this rule
   */


  function applyRule(rule) {
    var debug = rule.selector.isDebugging();
    var start;

    if (debug) {
      start = utils.AsyncWrapper.now();
    }

    var selector = rule.selector;
    var nodes = selector.querySelectorAll();
    nodes.forEach(function (node) {
      var affectedElement = findAffectedElement(node);

      if (affectedElement) {
        affectedElement.rules.push(rule);
        applyStyle(affectedElement);
      } else {
        // Applying style first time
        var originalStyle = node.style.cssText;
        affectedElement = {
          node: node,
          // affected DOM node
          rules: [rule],
          // rules to be applied
          originalStyle: originalStyle,
          // original node style
          protectionObserver: null // style attribute observer

        };
        applyStyle(affectedElement);
        affectedElements.push(affectedElement);
      }
    });

    if (debug) {
      var elapsed = utils.AsyncWrapper.now() - start;

      if (!('timingStats' in rule)) {
        rule.timingStats = new utils.Stats();
      }

      rule.timingStats.push(elapsed);
    }

    return nodes;
  }
  /**
   * Applies filtering rules
   */


  function applyRules() {
    var elementsIndex = []; // some rules could make call - selector.querySelectorAll() temporarily to change node id attribute
    // this caused MutationObserver to call recursively
    // https://github.com/AdguardTeam/ExtendedCss/issues/81

    stopObserve();
    rules.forEach(function (rule) {
      var nodes = applyRule(rule);
      Array.prototype.push.apply(elementsIndex, nodes);
    }); // Now revert styles for elements which are no more affected

    var l = affectedElements.length; // do nothing if there is no elements to process

    if (elementsIndex.length > 0) {
      while (l--) {
        var obj = affectedElements[l];

        if (elementsIndex.indexOf(obj.node) === -1) {
          // Time to revert style
          revertStyle(obj);
          affectedElements.splice(l, 1);
        } else if (!obj.removed) {
          // Add style protection observer
          // Protect "style" attribute from changes
          if (!obj.protectionObserver) {
            obj.protectionObserver = protectStyleAttribute(obj.node, obj.rules);
          }
        }
      }
    } // After styles are applied we can start observe again


    observe();
    printTimingInfo();
  }

  var APPLY_RULES_DELAY = 150;
  var applyRulesScheduler = new utils.AsyncWrapper(applyRules, APPLY_RULES_DELAY);
  var mainCallback = applyRulesScheduler.run.bind(applyRulesScheduler);

  function observe() {
    if (domObserved) {
      return;
    } // Handle dynamically added elements


    domObserved = true;
    observeDocument(mainCallback);
  }

  function stopObserve() {
    if (!domObserved) {
      return;
    }

    domObserved = false;
    disconnectDocument(mainCallback);
  }

  function apply() {
    applyRules();

    if (document.readyState !== 'complete') {
      document.addEventListener('DOMContentLoaded', applyRules);
    }
  }
  /**
   * Disposes ExtendedCss and removes our styles from matched elements
   */


  function dispose() {
    stopObserve();
    affectedElements.forEach(function (obj) {
      revertStyle(obj);
    });
  }

  var timingsPrinted = false;
  /**
   * Prints timing information for all selectors marked as "debug"
   */

  function printTimingInfo() {
    if (timingsPrinted) {
      return;
    }

    timingsPrinted = true;
    var timings = rules.filter(function (rule) {
      return rule.selector.isDebugging();
    }).map(function (rule) {
      return {
        selectorText: rule.selector.selectorText,
        timingStats: rule.timingStats
      };
    });

    if (timings.length === 0) {
      return;
    } // Add location.href to the message to distinguish frames


    utils.logInfo('[ExtendedCss] Timings for %o:\n%o (in milliseconds)', window.location.href, timings);
  } // First of all parse the stylesheet


  rules = ExtendedCssParser.parseCss(styleSheet); // EXPOSE

  this.dispose = dispose;
  this.apply = apply;
  /** Exposed for testing purposes only */

  this._getAffectedElements = function () {
    return affectedElements;
  };
}
/**
 * Expose querySelectorAll for debugging and validating selectors
 *
 * @param {string} selectorText selector text
 * @param {boolean} noTiming if true -- do not print the timing to the console
 * @returns {Array<Node>|NodeList} a list of elements found
 * @throws Will throw an error if the argument is not a valid selector
 */


ExtendedCss.query = function (selectorText, noTiming) {
  if (typeof selectorText !== 'string') {
    throw new Error('Selector text is empty');
  }

  var now = utils.AsyncWrapper.now;
  var start = now();

  try {
    return ExtendedSelectorFactory.createSelector(selectorText).querySelectorAll();
  } finally {
    var end = now();

    if (!noTiming) {
      utils.logInfo("[ExtendedCss] Elapsed: ".concat(Math.round((end - start) * 1000), " \u03BCs."));
    }
  }
};

/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = (ExtendedCss);


/***/ }),

/***/ "./node_modules/regenerator-runtime/runtime.js":
/*!*****************************************************!*\
  !*** ./node_modules/regenerator-runtime/runtime.js ***!
  \*****************************************************/
/***/ ((module) => {

/**
 * Copyright (c) 2014-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

var runtime = (function (exports) {
  "use strict";

  var Op = Object.prototype;
  var hasOwn = Op.hasOwnProperty;
  var undefined; // More compressible than void 0.
  var $Symbol = typeof Symbol === "function" ? Symbol : {};
  var iteratorSymbol = $Symbol.iterator || "@@iterator";
  var asyncIteratorSymbol = $Symbol.asyncIterator || "@@asyncIterator";
  var toStringTagSymbol = $Symbol.toStringTag || "@@toStringTag";

  function define(obj, key, value) {
    Object.defineProperty(obj, key, {
      value: value,
      enumerable: true,
      configurable: true,
      writable: true
    });
    return obj[key];
  }
  try {
    // IE 8 has a broken Object.defineProperty that only works on DOM objects.
    define({}, "");
  } catch (err) {
    define = function(obj, key, value) {
      return obj[key] = value;
    };
  }

  function wrap(innerFn, outerFn, self, tryLocsList) {
    // If outerFn provided and outerFn.prototype is a Generator, then outerFn.prototype instanceof Generator.
    var protoGenerator = outerFn && outerFn.prototype instanceof Generator ? outerFn : Generator;
    var generator = Object.create(protoGenerator.prototype);
    var context = new Context(tryLocsList || []);

    // The ._invoke method unifies the implementations of the .next,
    // .throw, and .return methods.
    generator._invoke = makeInvokeMethod(innerFn, self, context);

    return generator;
  }
  exports.wrap = wrap;

  // Try/catch helper to minimize deoptimizations. Returns a completion
  // record like context.tryEntries[i].completion. This interface could
  // have been (and was previously) designed to take a closure to be
  // invoked without arguments, but in all the cases we care about we
  // already have an existing method we want to call, so there's no need
  // to create a new function object. We can even get away with assuming
  // the method takes exactly one argument, since that happens to be true
  // in every case, so we don't have to touch the arguments object. The
  // only additional allocation required is the completion record, which
  // has a stable shape and so hopefully should be cheap to allocate.
  function tryCatch(fn, obj, arg) {
    try {
      return { type: "normal", arg: fn.call(obj, arg) };
    } catch (err) {
      return { type: "throw", arg: err };
    }
  }

  var GenStateSuspendedStart = "suspendedStart";
  var GenStateSuspendedYield = "suspendedYield";
  var GenStateExecuting = "executing";
  var GenStateCompleted = "completed";

  // Returning this object from the innerFn has the same effect as
  // breaking out of the dispatch switch statement.
  var ContinueSentinel = {};

  // Dummy constructor functions that we use as the .constructor and
  // .constructor.prototype properties for functions that return Generator
  // objects. For full spec compliance, you may wish to configure your
  // minifier not to mangle the names of these two functions.
  function Generator() {}
  function GeneratorFunction() {}
  function GeneratorFunctionPrototype() {}

  // This is a polyfill for %IteratorPrototype% for environments that
  // don't natively support it.
  var IteratorPrototype = {};
  IteratorPrototype[iteratorSymbol] = function () {
    return this;
  };

  var getProto = Object.getPrototypeOf;
  var NativeIteratorPrototype = getProto && getProto(getProto(values([])));
  if (NativeIteratorPrototype &&
      NativeIteratorPrototype !== Op &&
      hasOwn.call(NativeIteratorPrototype, iteratorSymbol)) {
    // This environment has a native %IteratorPrototype%; use it instead
    // of the polyfill.
    IteratorPrototype = NativeIteratorPrototype;
  }

  var Gp = GeneratorFunctionPrototype.prototype =
    Generator.prototype = Object.create(IteratorPrototype);
  GeneratorFunction.prototype = Gp.constructor = GeneratorFunctionPrototype;
  GeneratorFunctionPrototype.constructor = GeneratorFunction;
  GeneratorFunction.displayName = define(
    GeneratorFunctionPrototype,
    toStringTagSymbol,
    "GeneratorFunction"
  );

  // Helper for defining the .next, .throw, and .return methods of the
  // Iterator interface in terms of a single ._invoke method.
  function defineIteratorMethods(prototype) {
    ["next", "throw", "return"].forEach(function(method) {
      define(prototype, method, function(arg) {
        return this._invoke(method, arg);
      });
    });
  }

  exports.isGeneratorFunction = function(genFun) {
    var ctor = typeof genFun === "function" && genFun.constructor;
    return ctor
      ? ctor === GeneratorFunction ||
        // For the native GeneratorFunction constructor, the best we can
        // do is to check its .name property.
        (ctor.displayName || ctor.name) === "GeneratorFunction"
      : false;
  };

  exports.mark = function(genFun) {
    if (Object.setPrototypeOf) {
      Object.setPrototypeOf(genFun, GeneratorFunctionPrototype);
    } else {
      genFun.__proto__ = GeneratorFunctionPrototype;
      define(genFun, toStringTagSymbol, "GeneratorFunction");
    }
    genFun.prototype = Object.create(Gp);
    return genFun;
  };

  // Within the body of any async function, `await x` is transformed to
  // `yield regeneratorRuntime.awrap(x)`, so that the runtime can test
  // `hasOwn.call(value, "__await")` to determine if the yielded value is
  // meant to be awaited.
  exports.awrap = function(arg) {
    return { __await: arg };
  };

  function AsyncIterator(generator, PromiseImpl) {
    function invoke(method, arg, resolve, reject) {
      var record = tryCatch(generator[method], generator, arg);
      if (record.type === "throw") {
        reject(record.arg);
      } else {
        var result = record.arg;
        var value = result.value;
        if (value &&
            typeof value === "object" &&
            hasOwn.call(value, "__await")) {
          return PromiseImpl.resolve(value.__await).then(function(value) {
            invoke("next", value, resolve, reject);
          }, function(err) {
            invoke("throw", err, resolve, reject);
          });
        }

        return PromiseImpl.resolve(value).then(function(unwrapped) {
          // When a yielded Promise is resolved, its final value becomes
          // the .value of the Promise<{value,done}> result for the
          // current iteration.
          result.value = unwrapped;
          resolve(result);
        }, function(error) {
          // If a rejected Promise was yielded, throw the rejection back
          // into the async generator function so it can be handled there.
          return invoke("throw", error, resolve, reject);
        });
      }
    }

    var previousPromise;

    function enqueue(method, arg) {
      function callInvokeWithMethodAndArg() {
        return new PromiseImpl(function(resolve, reject) {
          invoke(method, arg, resolve, reject);
        });
      }

      return previousPromise =
        // If enqueue has been called before, then we want to wait until
        // all previous Promises have been resolved before calling invoke,
        // so that results are always delivered in the correct order. If
        // enqueue has not been called before, then it is important to
        // call invoke immediately, without waiting on a callback to fire,
        // so that the async generator function has the opportunity to do
        // any necessary setup in a predictable way. This predictability
        // is why the Promise constructor synchronously invokes its
        // executor callback, and why async functions synchronously
        // execute code before the first await. Since we implement simple
        // async functions in terms of async generators, it is especially
        // important to get this right, even though it requires care.
        previousPromise ? previousPromise.then(
          callInvokeWithMethodAndArg,
          // Avoid propagating failures to Promises returned by later
          // invocations of the iterator.
          callInvokeWithMethodAndArg
        ) : callInvokeWithMethodAndArg();
    }

    // Define the unified helper method that is used to implement .next,
    // .throw, and .return (see defineIteratorMethods).
    this._invoke = enqueue;
  }

  defineIteratorMethods(AsyncIterator.prototype);
  AsyncIterator.prototype[asyncIteratorSymbol] = function () {
    return this;
  };
  exports.AsyncIterator = AsyncIterator;

  // Note that simple async functions are implemented on top of
  // AsyncIterator objects; they just return a Promise for the value of
  // the final result produced by the iterator.
  exports.async = function(innerFn, outerFn, self, tryLocsList, PromiseImpl) {
    if (PromiseImpl === void 0) PromiseImpl = Promise;

    var iter = new AsyncIterator(
      wrap(innerFn, outerFn, self, tryLocsList),
      PromiseImpl
    );

    return exports.isGeneratorFunction(outerFn)
      ? iter // If outerFn is a generator, return the full iterator.
      : iter.next().then(function(result) {
          return result.done ? result.value : iter.next();
        });
  };

  function makeInvokeMethod(innerFn, self, context) {
    var state = GenStateSuspendedStart;

    return function invoke(method, arg) {
      if (state === GenStateExecuting) {
        throw new Error("Generator is already running");
      }

      if (state === GenStateCompleted) {
        if (method === "throw") {
          throw arg;
        }

        // Be forgiving, per 25.3.3.3.3 of the spec:
        // https://people.mozilla.org/~jorendorff/es6-draft.html#sec-generatorresume
        return doneResult();
      }

      context.method = method;
      context.arg = arg;

      while (true) {
        var delegate = context.delegate;
        if (delegate) {
          var delegateResult = maybeInvokeDelegate(delegate, context);
          if (delegateResult) {
            if (delegateResult === ContinueSentinel) continue;
            return delegateResult;
          }
        }

        if (context.method === "next") {
          // Setting context._sent for legacy support of Babel's
          // function.sent implementation.
          context.sent = context._sent = context.arg;

        } else if (context.method === "throw") {
          if (state === GenStateSuspendedStart) {
            state = GenStateCompleted;
            throw context.arg;
          }

          context.dispatchException(context.arg);

        } else if (context.method === "return") {
          context.abrupt("return", context.arg);
        }

        state = GenStateExecuting;

        var record = tryCatch(innerFn, self, context);
        if (record.type === "normal") {
          // If an exception is thrown from innerFn, we leave state ===
          // GenStateExecuting and loop back for another invocation.
          state = context.done
            ? GenStateCompleted
            : GenStateSuspendedYield;

          if (record.arg === ContinueSentinel) {
            continue;
          }

          return {
            value: record.arg,
            done: context.done
          };

        } else if (record.type === "throw") {
          state = GenStateCompleted;
          // Dispatch the exception by looping back around to the
          // context.dispatchException(context.arg) call above.
          context.method = "throw";
          context.arg = record.arg;
        }
      }
    };
  }

  // Call delegate.iterator[context.method](context.arg) and handle the
  // result, either by returning a { value, done } result from the
  // delegate iterator, or by modifying context.method and context.arg,
  // setting context.delegate to null, and returning the ContinueSentinel.
  function maybeInvokeDelegate(delegate, context) {
    var method = delegate.iterator[context.method];
    if (method === undefined) {
      // A .throw or .return when the delegate iterator has no .throw
      // method always terminates the yield* loop.
      context.delegate = null;

      if (context.method === "throw") {
        // Note: ["return"] must be used for ES3 parsing compatibility.
        if (delegate.iterator["return"]) {
          // If the delegate iterator has a return method, give it a
          // chance to clean up.
          context.method = "return";
          context.arg = undefined;
          maybeInvokeDelegate(delegate, context);

          if (context.method === "throw") {
            // If maybeInvokeDelegate(context) changed context.method from
            // "return" to "throw", let that override the TypeError below.
            return ContinueSentinel;
          }
        }

        context.method = "throw";
        context.arg = new TypeError(
          "The iterator does not provide a 'throw' method");
      }

      return ContinueSentinel;
    }

    var record = tryCatch(method, delegate.iterator, context.arg);

    if (record.type === "throw") {
      context.method = "throw";
      context.arg = record.arg;
      context.delegate = null;
      return ContinueSentinel;
    }

    var info = record.arg;

    if (! info) {
      context.method = "throw";
      context.arg = new TypeError("iterator result is not an object");
      context.delegate = null;
      return ContinueSentinel;
    }

    if (info.done) {
      // Assign the result of the finished delegate to the temporary
      // variable specified by delegate.resultName (see delegateYield).
      context[delegate.resultName] = info.value;

      // Resume execution at the desired location (see delegateYield).
      context.next = delegate.nextLoc;

      // If context.method was "throw" but the delegate handled the
      // exception, let the outer generator proceed normally. If
      // context.method was "next", forget context.arg since it has been
      // "consumed" by the delegate iterator. If context.method was
      // "return", allow the original .return call to continue in the
      // outer generator.
      if (context.method !== "return") {
        context.method = "next";
        context.arg = undefined;
      }

    } else {
      // Re-yield the result returned by the delegate method.
      return info;
    }

    // The delegate iterator is finished, so forget it and continue with
    // the outer generator.
    context.delegate = null;
    return ContinueSentinel;
  }

  // Define Generator.prototype.{next,throw,return} in terms of the
  // unified ._invoke helper method.
  defineIteratorMethods(Gp);

  define(Gp, toStringTagSymbol, "Generator");

  // A Generator should always return itself as the iterator object when the
  // @@iterator function is called on it. Some browsers' implementations of the
  // iterator prototype chain incorrectly implement this, causing the Generator
  // object to not be returned from this call. This ensures that doesn't happen.
  // See https://github.com/facebook/regenerator/issues/274 for more details.
  Gp[iteratorSymbol] = function() {
    return this;
  };

  Gp.toString = function() {
    return "[object Generator]";
  };

  function pushTryEntry(locs) {
    var entry = { tryLoc: locs[0] };

    if (1 in locs) {
      entry.catchLoc = locs[1];
    }

    if (2 in locs) {
      entry.finallyLoc = locs[2];
      entry.afterLoc = locs[3];
    }

    this.tryEntries.push(entry);
  }

  function resetTryEntry(entry) {
    var record = entry.completion || {};
    record.type = "normal";
    delete record.arg;
    entry.completion = record;
  }

  function Context(tryLocsList) {
    // The root entry object (effectively a try statement without a catch
    // or a finally block) gives us a place to store values thrown from
    // locations where there is no enclosing try statement.
    this.tryEntries = [{ tryLoc: "root" }];
    tryLocsList.forEach(pushTryEntry, this);
    this.reset(true);
  }

  exports.keys = function(object) {
    var keys = [];
    for (var key in object) {
      keys.push(key);
    }
    keys.reverse();

    // Rather than returning an object with a next method, we keep
    // things simple and return the next function itself.
    return function next() {
      while (keys.length) {
        var key = keys.pop();
        if (key in object) {
          next.value = key;
          next.done = false;
          return next;
        }
      }

      // To avoid creating an additional object, we just hang the .value
      // and .done properties off the next function object itself. This
      // also ensures that the minifier will not anonymize the function.
      next.done = true;
      return next;
    };
  };

  function values(iterable) {
    if (iterable) {
      var iteratorMethod = iterable[iteratorSymbol];
      if (iteratorMethod) {
        return iteratorMethod.call(iterable);
      }

      if (typeof iterable.next === "function") {
        return iterable;
      }

      if (!isNaN(iterable.length)) {
        var i = -1, next = function next() {
          while (++i < iterable.length) {
            if (hasOwn.call(iterable, i)) {
              next.value = iterable[i];
              next.done = false;
              return next;
            }
          }

          next.value = undefined;
          next.done = true;

          return next;
        };

        return next.next = next;
      }
    }

    // Return an iterator with no values.
    return { next: doneResult };
  }
  exports.values = values;

  function doneResult() {
    return { value: undefined, done: true };
  }

  Context.prototype = {
    constructor: Context,

    reset: function(skipTempReset) {
      this.prev = 0;
      this.next = 0;
      // Resetting context._sent for legacy support of Babel's
      // function.sent implementation.
      this.sent = this._sent = undefined;
      this.done = false;
      this.delegate = null;

      this.method = "next";
      this.arg = undefined;

      this.tryEntries.forEach(resetTryEntry);

      if (!skipTempReset) {
        for (var name in this) {
          // Not sure about the optimal order of these conditions:
          if (name.charAt(0) === "t" &&
              hasOwn.call(this, name) &&
              !isNaN(+name.slice(1))) {
            this[name] = undefined;
          }
        }
      }
    },

    stop: function() {
      this.done = true;

      var rootEntry = this.tryEntries[0];
      var rootRecord = rootEntry.completion;
      if (rootRecord.type === "throw") {
        throw rootRecord.arg;
      }

      return this.rval;
    },

    dispatchException: function(exception) {
      if (this.done) {
        throw exception;
      }

      var context = this;
      function handle(loc, caught) {
        record.type = "throw";
        record.arg = exception;
        context.next = loc;

        if (caught) {
          // If the dispatched exception was caught by a catch block,
          // then let that catch block handle the exception normally.
          context.method = "next";
          context.arg = undefined;
        }

        return !! caught;
      }

      for (var i = this.tryEntries.length - 1; i >= 0; --i) {
        var entry = this.tryEntries[i];
        var record = entry.completion;

        if (entry.tryLoc === "root") {
          // Exception thrown outside of any try block that could handle
          // it, so set the completion value of the entire function to
          // throw the exception.
          return handle("end");
        }

        if (entry.tryLoc <= this.prev) {
          var hasCatch = hasOwn.call(entry, "catchLoc");
          var hasFinally = hasOwn.call(entry, "finallyLoc");

          if (hasCatch && hasFinally) {
            if (this.prev < entry.catchLoc) {
              return handle(entry.catchLoc, true);
            } else if (this.prev < entry.finallyLoc) {
              return handle(entry.finallyLoc);
            }

          } else if (hasCatch) {
            if (this.prev < entry.catchLoc) {
              return handle(entry.catchLoc, true);
            }

          } else if (hasFinally) {
            if (this.prev < entry.finallyLoc) {
              return handle(entry.finallyLoc);
            }

          } else {
            throw new Error("try statement without catch or finally");
          }
        }
      }
    },

    abrupt: function(type, arg) {
      for (var i = this.tryEntries.length - 1; i >= 0; --i) {
        var entry = this.tryEntries[i];
        if (entry.tryLoc <= this.prev &&
            hasOwn.call(entry, "finallyLoc") &&
            this.prev < entry.finallyLoc) {
          var finallyEntry = entry;
          break;
        }
      }

      if (finallyEntry &&
          (type === "break" ||
           type === "continue") &&
          finallyEntry.tryLoc <= arg &&
          arg <= finallyEntry.finallyLoc) {
        // Ignore the finally entry if control is not jumping to a
        // location outside the try/catch block.
        finallyEntry = null;
      }

      var record = finallyEntry ? finallyEntry.completion : {};
      record.type = type;
      record.arg = arg;

      if (finallyEntry) {
        this.method = "next";
        this.next = finallyEntry.finallyLoc;
        return ContinueSentinel;
      }

      return this.complete(record);
    },

    complete: function(record, afterLoc) {
      if (record.type === "throw") {
        throw record.arg;
      }

      if (record.type === "break" ||
          record.type === "continue") {
        this.next = record.arg;
      } else if (record.type === "return") {
        this.rval = this.arg = record.arg;
        this.method = "return";
        this.next = "end";
      } else if (record.type === "normal" && afterLoc) {
        this.next = afterLoc;
      }

      return ContinueSentinel;
    },

    finish: function(finallyLoc) {
      for (var i = this.tryEntries.length - 1; i >= 0; --i) {
        var entry = this.tryEntries[i];
        if (entry.finallyLoc === finallyLoc) {
          this.complete(entry.completion, entry.afterLoc);
          resetTryEntry(entry);
          return ContinueSentinel;
        }
      }
    },

    "catch": function(tryLoc) {
      for (var i = this.tryEntries.length - 1; i >= 0; --i) {
        var entry = this.tryEntries[i];
        if (entry.tryLoc === tryLoc) {
          var record = entry.completion;
          if (record.type === "throw") {
            var thrown = record.arg;
            resetTryEntry(entry);
          }
          return thrown;
        }
      }

      // The context.catch method must only be called with a location
      // argument that corresponds to a known catch block.
      throw new Error("illegal catch attempt");
    },

    delegateYield: function(iterable, resultName, nextLoc) {
      this.delegate = {
        iterator: values(iterable),
        resultName: resultName,
        nextLoc: nextLoc
      };

      if (this.method === "next") {
        // Deliberately forget the last sent value so that we don't
        // accidentally pass it on to the delegate.
        this.arg = undefined;
      }

      return ContinueSentinel;
    }
  };

  // Regardless of whether this script is executing as a CommonJS module
  // or not, return the runtime object so that we can declare the variable
  // regeneratorRuntime in the outer scope, which allows this module to be
  // injected easily by `bin/regenerator --include-runtime script.js`.
  return exports;

}(
  // If this script is executing as a CommonJS module, use module.exports
  // as the regeneratorRuntime namespace. Otherwise create a new empty
  // object. Either way, the resulting object will be used to initialize
  // the regeneratorRuntime variable at the top of this file.
   true ? module.exports : 0
));

try {
  regeneratorRuntime = runtime;
} catch (accidentalStrictMode) {
  // This module should not be running in strict mode, so the above
  // assignment should always work unless something is misconfigured. Just
  // in case runtime.js accidentally runs in strict mode, we can escape
  // strict mode using a global Function call. This could conceivably fail
  // if a Content Security Policy forbids using Function, but in that case
  // the proper solution is to fix the accidental strict mode problem. If
  // you've misconfigured your bundler to force strict mode and applied a
  // CSP to forbid Function, and you're not willing to fix either of those
  // problems, please detail your unique predicament in a GitHub issue.
  Function("r", "regeneratorRuntime = r")(runtime);
}


/***/ }),

/***/ "./node_modules/webextension-polyfill/dist/browser-polyfill.js":
/*!*********************************************************************!*\
  !*** ./node_modules/webextension-polyfill/dist/browser-polyfill.js ***!
  \*********************************************************************/
/***/ (function(module, exports) {

var __WEBPACK_AMD_DEFINE_FACTORY__, __WEBPACK_AMD_DEFINE_ARRAY__, __WEBPACK_AMD_DEFINE_RESULT__;(function (global, factory) {
  if (true) {
    !(__WEBPACK_AMD_DEFINE_ARRAY__ = [module], __WEBPACK_AMD_DEFINE_FACTORY__ = (factory),
		__WEBPACK_AMD_DEFINE_RESULT__ = (typeof __WEBPACK_AMD_DEFINE_FACTORY__ === 'function' ?
		(__WEBPACK_AMD_DEFINE_FACTORY__.apply(exports, __WEBPACK_AMD_DEFINE_ARRAY__)) : __WEBPACK_AMD_DEFINE_FACTORY__),
		__WEBPACK_AMD_DEFINE_RESULT__ !== undefined && (module.exports = __WEBPACK_AMD_DEFINE_RESULT__));
  } else { var mod; }
})(typeof globalThis !== "undefined" ? globalThis : typeof self !== "undefined" ? self : this, function (module) {
  /* webextension-polyfill - v0.8.0 - Tue Apr 20 2021 11:27:38 */

  /* -*- Mode: indent-tabs-mode: nil; js-indent-level: 2 -*- */

  /* vim: set sts=2 sw=2 et tw=80: */

  /* This Source Code Form is subject to the terms of the Mozilla Public
   * License, v. 2.0. If a copy of the MPL was not distributed with this
   * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
  "use strict";

  if (typeof browser === "undefined" || Object.getPrototypeOf(browser) !== Object.prototype) {
    const CHROME_SEND_MESSAGE_CALLBACK_NO_RESPONSE_MESSAGE = "The message port closed before a response was received.";
    const SEND_RESPONSE_DEPRECATION_WARNING = "Returning a Promise is the preferred way to send a reply from an onMessage/onMessageExternal listener, as the sendResponse will be removed from the specs (See https://developer.mozilla.org/docs/Mozilla/Add-ons/WebExtensions/API/runtime/onMessage)"; // Wrapping the bulk of this polyfill in a one-time-use function is a minor
    // optimization for Firefox. Since Spidermonkey does not fully parse the
    // contents of a function until the first time it's called, and since it will
    // never actually need to be called, this allows the polyfill to be included
    // in Firefox nearly for free.

    const wrapAPIs = extensionAPIs => {
      // NOTE: apiMetadata is associated to the content of the api-metadata.json file
      // at build time by replacing the following "include" with the content of the
      // JSON file.
      const apiMetadata = {
        "alarms": {
          "clear": {
            "minArgs": 0,
            "maxArgs": 1
          },
          "clearAll": {
            "minArgs": 0,
            "maxArgs": 0
          },
          "get": {
            "minArgs": 0,
            "maxArgs": 1
          },
          "getAll": {
            "minArgs": 0,
            "maxArgs": 0
          }
        },
        "bookmarks": {
          "create": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "get": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "getChildren": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "getRecent": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "getSubTree": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "getTree": {
            "minArgs": 0,
            "maxArgs": 0
          },
          "move": {
            "minArgs": 2,
            "maxArgs": 2
          },
          "remove": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "removeTree": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "search": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "update": {
            "minArgs": 2,
            "maxArgs": 2
          }
        },
        "browserAction": {
          "disable": {
            "minArgs": 0,
            "maxArgs": 1,
            "fallbackToNoCallback": true
          },
          "enable": {
            "minArgs": 0,
            "maxArgs": 1,
            "fallbackToNoCallback": true
          },
          "getBadgeBackgroundColor": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "getBadgeText": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "getPopup": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "getTitle": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "openPopup": {
            "minArgs": 0,
            "maxArgs": 0
          },
          "setBadgeBackgroundColor": {
            "minArgs": 1,
            "maxArgs": 1,
            "fallbackToNoCallback": true
          },
          "setBadgeText": {
            "minArgs": 1,
            "maxArgs": 1,
            "fallbackToNoCallback": true
          },
          "setIcon": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "setPopup": {
            "minArgs": 1,
            "maxArgs": 1,
            "fallbackToNoCallback": true
          },
          "setTitle": {
            "minArgs": 1,
            "maxArgs": 1,
            "fallbackToNoCallback": true
          }
        },
        "browsingData": {
          "remove": {
            "minArgs": 2,
            "maxArgs": 2
          },
          "removeCache": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "removeCookies": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "removeDownloads": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "removeFormData": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "removeHistory": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "removeLocalStorage": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "removePasswords": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "removePluginData": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "settings": {
            "minArgs": 0,
            "maxArgs": 0
          }
        },
        "commands": {
          "getAll": {
            "minArgs": 0,
            "maxArgs": 0
          }
        },
        "contextMenus": {
          "remove": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "removeAll": {
            "minArgs": 0,
            "maxArgs": 0
          },
          "update": {
            "minArgs": 2,
            "maxArgs": 2
          }
        },
        "cookies": {
          "get": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "getAll": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "getAllCookieStores": {
            "minArgs": 0,
            "maxArgs": 0
          },
          "remove": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "set": {
            "minArgs": 1,
            "maxArgs": 1
          }
        },
        "devtools": {
          "inspectedWindow": {
            "eval": {
              "minArgs": 1,
              "maxArgs": 2,
              "singleCallbackArg": false
            }
          },
          "panels": {
            "create": {
              "minArgs": 3,
              "maxArgs": 3,
              "singleCallbackArg": true
            },
            "elements": {
              "createSidebarPane": {
                "minArgs": 1,
                "maxArgs": 1
              }
            }
          }
        },
        "downloads": {
          "cancel": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "download": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "erase": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "getFileIcon": {
            "minArgs": 1,
            "maxArgs": 2
          },
          "open": {
            "minArgs": 1,
            "maxArgs": 1,
            "fallbackToNoCallback": true
          },
          "pause": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "removeFile": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "resume": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "search": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "show": {
            "minArgs": 1,
            "maxArgs": 1,
            "fallbackToNoCallback": true
          }
        },
        "extension": {
          "isAllowedFileSchemeAccess": {
            "minArgs": 0,
            "maxArgs": 0
          },
          "isAllowedIncognitoAccess": {
            "minArgs": 0,
            "maxArgs": 0
          }
        },
        "history": {
          "addUrl": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "deleteAll": {
            "minArgs": 0,
            "maxArgs": 0
          },
          "deleteRange": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "deleteUrl": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "getVisits": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "search": {
            "minArgs": 1,
            "maxArgs": 1
          }
        },
        "i18n": {
          "detectLanguage": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "getAcceptLanguages": {
            "minArgs": 0,
            "maxArgs": 0
          }
        },
        "identity": {
          "launchWebAuthFlow": {
            "minArgs": 1,
            "maxArgs": 1
          }
        },
        "idle": {
          "queryState": {
            "minArgs": 1,
            "maxArgs": 1
          }
        },
        "management": {
          "get": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "getAll": {
            "minArgs": 0,
            "maxArgs": 0
          },
          "getSelf": {
            "minArgs": 0,
            "maxArgs": 0
          },
          "setEnabled": {
            "minArgs": 2,
            "maxArgs": 2
          },
          "uninstallSelf": {
            "minArgs": 0,
            "maxArgs": 1
          }
        },
        "notifications": {
          "clear": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "create": {
            "minArgs": 1,
            "maxArgs": 2
          },
          "getAll": {
            "minArgs": 0,
            "maxArgs": 0
          },
          "getPermissionLevel": {
            "minArgs": 0,
            "maxArgs": 0
          },
          "update": {
            "minArgs": 2,
            "maxArgs": 2
          }
        },
        "pageAction": {
          "getPopup": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "getTitle": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "hide": {
            "minArgs": 1,
            "maxArgs": 1,
            "fallbackToNoCallback": true
          },
          "setIcon": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "setPopup": {
            "minArgs": 1,
            "maxArgs": 1,
            "fallbackToNoCallback": true
          },
          "setTitle": {
            "minArgs": 1,
            "maxArgs": 1,
            "fallbackToNoCallback": true
          },
          "show": {
            "minArgs": 1,
            "maxArgs": 1,
            "fallbackToNoCallback": true
          }
        },
        "permissions": {
          "contains": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "getAll": {
            "minArgs": 0,
            "maxArgs": 0
          },
          "remove": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "request": {
            "minArgs": 1,
            "maxArgs": 1
          }
        },
        "runtime": {
          "getBackgroundPage": {
            "minArgs": 0,
            "maxArgs": 0
          },
          "getPlatformInfo": {
            "minArgs": 0,
            "maxArgs": 0
          },
          "openOptionsPage": {
            "minArgs": 0,
            "maxArgs": 0
          },
          "requestUpdateCheck": {
            "minArgs": 0,
            "maxArgs": 0
          },
          "sendMessage": {
            "minArgs": 1,
            "maxArgs": 3
          },
          "sendNativeMessage": {
            "minArgs": 2,
            "maxArgs": 2
          },
          "setUninstallURL": {
            "minArgs": 1,
            "maxArgs": 1
          }
        },
        "sessions": {
          "getDevices": {
            "minArgs": 0,
            "maxArgs": 1
          },
          "getRecentlyClosed": {
            "minArgs": 0,
            "maxArgs": 1
          },
          "restore": {
            "minArgs": 0,
            "maxArgs": 1
          }
        },
        "storage": {
          "local": {
            "clear": {
              "minArgs": 0,
              "maxArgs": 0
            },
            "get": {
              "minArgs": 0,
              "maxArgs": 1
            },
            "getBytesInUse": {
              "minArgs": 0,
              "maxArgs": 1
            },
            "remove": {
              "minArgs": 1,
              "maxArgs": 1
            },
            "set": {
              "minArgs": 1,
              "maxArgs": 1
            }
          },
          "managed": {
            "get": {
              "minArgs": 0,
              "maxArgs": 1
            },
            "getBytesInUse": {
              "minArgs": 0,
              "maxArgs": 1
            }
          },
          "sync": {
            "clear": {
              "minArgs": 0,
              "maxArgs": 0
            },
            "get": {
              "minArgs": 0,
              "maxArgs": 1
            },
            "getBytesInUse": {
              "minArgs": 0,
              "maxArgs": 1
            },
            "remove": {
              "minArgs": 1,
              "maxArgs": 1
            },
            "set": {
              "minArgs": 1,
              "maxArgs": 1
            }
          }
        },
        "tabs": {
          "captureVisibleTab": {
            "minArgs": 0,
            "maxArgs": 2
          },
          "create": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "detectLanguage": {
            "minArgs": 0,
            "maxArgs": 1
          },
          "discard": {
            "minArgs": 0,
            "maxArgs": 1
          },
          "duplicate": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "executeScript": {
            "minArgs": 1,
            "maxArgs": 2
          },
          "get": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "getCurrent": {
            "minArgs": 0,
            "maxArgs": 0
          },
          "getZoom": {
            "minArgs": 0,
            "maxArgs": 1
          },
          "getZoomSettings": {
            "minArgs": 0,
            "maxArgs": 1
          },
          "goBack": {
            "minArgs": 0,
            "maxArgs": 1
          },
          "goForward": {
            "minArgs": 0,
            "maxArgs": 1
          },
          "highlight": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "insertCSS": {
            "minArgs": 1,
            "maxArgs": 2
          },
          "move": {
            "minArgs": 2,
            "maxArgs": 2
          },
          "query": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "reload": {
            "minArgs": 0,
            "maxArgs": 2
          },
          "remove": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "removeCSS": {
            "minArgs": 1,
            "maxArgs": 2
          },
          "sendMessage": {
            "minArgs": 2,
            "maxArgs": 3
          },
          "setZoom": {
            "minArgs": 1,
            "maxArgs": 2
          },
          "setZoomSettings": {
            "minArgs": 1,
            "maxArgs": 2
          },
          "update": {
            "minArgs": 1,
            "maxArgs": 2
          }
        },
        "topSites": {
          "get": {
            "minArgs": 0,
            "maxArgs": 0
          }
        },
        "webNavigation": {
          "getAllFrames": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "getFrame": {
            "minArgs": 1,
            "maxArgs": 1
          }
        },
        "webRequest": {
          "handlerBehaviorChanged": {
            "minArgs": 0,
            "maxArgs": 0
          }
        },
        "windows": {
          "create": {
            "minArgs": 0,
            "maxArgs": 1
          },
          "get": {
            "minArgs": 1,
            "maxArgs": 2
          },
          "getAll": {
            "minArgs": 0,
            "maxArgs": 1
          },
          "getCurrent": {
            "minArgs": 0,
            "maxArgs": 1
          },
          "getLastFocused": {
            "minArgs": 0,
            "maxArgs": 1
          },
          "remove": {
            "minArgs": 1,
            "maxArgs": 1
          },
          "update": {
            "minArgs": 2,
            "maxArgs": 2
          }
        }
      };

      if (Object.keys(apiMetadata).length === 0) {
        throw new Error("api-metadata.json has not been included in browser-polyfill");
      }
      /**
       * A WeakMap subclass which creates and stores a value for any key which does
       * not exist when accessed, but behaves exactly as an ordinary WeakMap
       * otherwise.
       *
       * @param {function} createItem
       *        A function which will be called in order to create the value for any
       *        key which does not exist, the first time it is accessed. The
       *        function receives, as its only argument, the key being created.
       */


      class DefaultWeakMap extends WeakMap {
        constructor(createItem, items = undefined) {
          super(items);
          this.createItem = createItem;
        }

        get(key) {
          if (!this.has(key)) {
            this.set(key, this.createItem(key));
          }

          return super.get(key);
        }

      }
      /**
       * Returns true if the given object is an object with a `then` method, and can
       * therefore be assumed to behave as a Promise.
       *
       * @param {*} value The value to test.
       * @returns {boolean} True if the value is thenable.
       */


      const isThenable = value => {
        return value && typeof value === "object" && typeof value.then === "function";
      };
      /**
       * Creates and returns a function which, when called, will resolve or reject
       * the given promise based on how it is called:
       *
       * - If, when called, `chrome.runtime.lastError` contains a non-null object,
       *   the promise is rejected with that value.
       * - If the function is called with exactly one argument, the promise is
       *   resolved to that value.
       * - Otherwise, the promise is resolved to an array containing all of the
       *   function's arguments.
       *
       * @param {object} promise
       *        An object containing the resolution and rejection functions of a
       *        promise.
       * @param {function} promise.resolve
       *        The promise's resolution function.
       * @param {function} promise.reject
       *        The promise's rejection function.
       * @param {object} metadata
       *        Metadata about the wrapped method which has created the callback.
       * @param {boolean} metadata.singleCallbackArg
       *        Whether or not the promise is resolved with only the first
       *        argument of the callback, alternatively an array of all the
       *        callback arguments is resolved. By default, if the callback
       *        function is invoked with only a single argument, that will be
       *        resolved to the promise, while all arguments will be resolved as
       *        an array if multiple are given.
       *
       * @returns {function}
       *        The generated callback function.
       */


      const makeCallback = (promise, metadata) => {
        return (...callbackArgs) => {
          if (extensionAPIs.runtime.lastError) {
            promise.reject(new Error(extensionAPIs.runtime.lastError.message));
          } else if (metadata.singleCallbackArg || callbackArgs.length <= 1 && metadata.singleCallbackArg !== false) {
            promise.resolve(callbackArgs[0]);
          } else {
            promise.resolve(callbackArgs);
          }
        };
      };

      const pluralizeArguments = numArgs => numArgs == 1 ? "argument" : "arguments";
      /**
       * Creates a wrapper function for a method with the given name and metadata.
       *
       * @param {string} name
       *        The name of the method which is being wrapped.
       * @param {object} metadata
       *        Metadata about the method being wrapped.
       * @param {integer} metadata.minArgs
       *        The minimum number of arguments which must be passed to the
       *        function. If called with fewer than this number of arguments, the
       *        wrapper will raise an exception.
       * @param {integer} metadata.maxArgs
       *        The maximum number of arguments which may be passed to the
       *        function. If called with more than this number of arguments, the
       *        wrapper will raise an exception.
       * @param {boolean} metadata.singleCallbackArg
       *        Whether or not the promise is resolved with only the first
       *        argument of the callback, alternatively an array of all the
       *        callback arguments is resolved. By default, if the callback
       *        function is invoked with only a single argument, that will be
       *        resolved to the promise, while all arguments will be resolved as
       *        an array if multiple are given.
       *
       * @returns {function(object, ...*)}
       *       The generated wrapper function.
       */


      const wrapAsyncFunction = (name, metadata) => {
        return function asyncFunctionWrapper(target, ...args) {
          if (args.length < metadata.minArgs) {
            throw new Error(`Expected at least ${metadata.minArgs} ${pluralizeArguments(metadata.minArgs)} for ${name}(), got ${args.length}`);
          }

          if (args.length > metadata.maxArgs) {
            throw new Error(`Expected at most ${metadata.maxArgs} ${pluralizeArguments(metadata.maxArgs)} for ${name}(), got ${args.length}`);
          }

          return new Promise((resolve, reject) => {
            if (metadata.fallbackToNoCallback) {
              // This API method has currently no callback on Chrome, but it return a promise on Firefox,
              // and so the polyfill will try to call it with a callback first, and it will fallback
              // to not passing the callback if the first call fails.
              try {
                target[name](...args, makeCallback({
                  resolve,
                  reject
                }, metadata));
              } catch (cbError) {
                console.warn(`${name} API method doesn't seem to support the callback parameter, ` + "falling back to call it without a callback: ", cbError);
                target[name](...args); // Update the API method metadata, so that the next API calls will not try to
                // use the unsupported callback anymore.

                metadata.fallbackToNoCallback = false;
                metadata.noCallback = true;
                resolve();
              }
            } else if (metadata.noCallback) {
              target[name](...args);
              resolve();
            } else {
              target[name](...args, makeCallback({
                resolve,
                reject
              }, metadata));
            }
          });
        };
      };
      /**
       * Wraps an existing method of the target object, so that calls to it are
       * intercepted by the given wrapper function. The wrapper function receives,
       * as its first argument, the original `target` object, followed by each of
       * the arguments passed to the original method.
       *
       * @param {object} target
       *        The original target object that the wrapped method belongs to.
       * @param {function} method
       *        The method being wrapped. This is used as the target of the Proxy
       *        object which is created to wrap the method.
       * @param {function} wrapper
       *        The wrapper function which is called in place of a direct invocation
       *        of the wrapped method.
       *
       * @returns {Proxy<function>}
       *        A Proxy object for the given method, which invokes the given wrapper
       *        method in its place.
       */


      const wrapMethod = (target, method, wrapper) => {
        return new Proxy(method, {
          apply(targetMethod, thisObj, args) {
            return wrapper.call(thisObj, target, ...args);
          }

        });
      };

      let hasOwnProperty = Function.call.bind(Object.prototype.hasOwnProperty);
      /**
       * Wraps an object in a Proxy which intercepts and wraps certain methods
       * based on the given `wrappers` and `metadata` objects.
       *
       * @param {object} target
       *        The target object to wrap.
       *
       * @param {object} [wrappers = {}]
       *        An object tree containing wrapper functions for special cases. Any
       *        function present in this object tree is called in place of the
       *        method in the same location in the `target` object tree. These
       *        wrapper methods are invoked as described in {@see wrapMethod}.
       *
       * @param {object} [metadata = {}]
       *        An object tree containing metadata used to automatically generate
       *        Promise-based wrapper functions for asynchronous. Any function in
       *        the `target` object tree which has a corresponding metadata object
       *        in the same location in the `metadata` tree is replaced with an
       *        automatically-generated wrapper function, as described in
       *        {@see wrapAsyncFunction}
       *
       * @returns {Proxy<object>}
       */

      const wrapObject = (target, wrappers = {}, metadata = {}) => {
        let cache = Object.create(null);
        let handlers = {
          has(proxyTarget, prop) {
            return prop in target || prop in cache;
          },

          get(proxyTarget, prop, receiver) {
            if (prop in cache) {
              return cache[prop];
            }

            if (!(prop in target)) {
              return undefined;
            }

            let value = target[prop];

            if (typeof value === "function") {
              // This is a method on the underlying object. Check if we need to do
              // any wrapping.
              if (typeof wrappers[prop] === "function") {
                // We have a special-case wrapper for this method.
                value = wrapMethod(target, target[prop], wrappers[prop]);
              } else if (hasOwnProperty(metadata, prop)) {
                // This is an async method that we have metadata for. Create a
                // Promise wrapper for it.
                let wrapper = wrapAsyncFunction(prop, metadata[prop]);
                value = wrapMethod(target, target[prop], wrapper);
              } else {
                // This is a method that we don't know or care about. Return the
                // original method, bound to the underlying object.
                value = value.bind(target);
              }
            } else if (typeof value === "object" && value !== null && (hasOwnProperty(wrappers, prop) || hasOwnProperty(metadata, prop))) {
              // This is an object that we need to do some wrapping for the children
              // of. Create a sub-object wrapper for it with the appropriate child
              // metadata.
              value = wrapObject(value, wrappers[prop], metadata[prop]);
            } else if (hasOwnProperty(metadata, "*")) {
              // Wrap all properties in * namespace.
              value = wrapObject(value, wrappers[prop], metadata["*"]);
            } else {
              // We don't need to do any wrapping for this property,
              // so just forward all access to the underlying object.
              Object.defineProperty(cache, prop, {
                configurable: true,
                enumerable: true,

                get() {
                  return target[prop];
                },

                set(value) {
                  target[prop] = value;
                }

              });
              return value;
            }

            cache[prop] = value;
            return value;
          },

          set(proxyTarget, prop, value, receiver) {
            if (prop in cache) {
              cache[prop] = value;
            } else {
              target[prop] = value;
            }

            return true;
          },

          defineProperty(proxyTarget, prop, desc) {
            return Reflect.defineProperty(cache, prop, desc);
          },

          deleteProperty(proxyTarget, prop) {
            return Reflect.deleteProperty(cache, prop);
          }

        }; // Per contract of the Proxy API, the "get" proxy handler must return the
        // original value of the target if that value is declared read-only and
        // non-configurable. For this reason, we create an object with the
        // prototype set to `target` instead of using `target` directly.
        // Otherwise we cannot return a custom object for APIs that
        // are declared read-only and non-configurable, such as `chrome.devtools`.
        //
        // The proxy handlers themselves will still use the original `target`
        // instead of the `proxyTarget`, so that the methods and properties are
        // dereferenced via the original targets.

        let proxyTarget = Object.create(target);
        return new Proxy(proxyTarget, handlers);
      };
      /**
       * Creates a set of wrapper functions for an event object, which handles
       * wrapping of listener functions that those messages are passed.
       *
       * A single wrapper is created for each listener function, and stored in a
       * map. Subsequent calls to `addListener`, `hasListener`, or `removeListener`
       * retrieve the original wrapper, so that  attempts to remove a
       * previously-added listener work as expected.
       *
       * @param {DefaultWeakMap<function, function>} wrapperMap
       *        A DefaultWeakMap object which will create the appropriate wrapper
       *        for a given listener function when one does not exist, and retrieve
       *        an existing one when it does.
       *
       * @returns {object}
       */


      const wrapEvent = wrapperMap => ({
        addListener(target, listener, ...args) {
          target.addListener(wrapperMap.get(listener), ...args);
        },

        hasListener(target, listener) {
          return target.hasListener(wrapperMap.get(listener));
        },

        removeListener(target, listener) {
          target.removeListener(wrapperMap.get(listener));
        }

      });

      const onRequestFinishedWrappers = new DefaultWeakMap(listener => {
        if (typeof listener !== "function") {
          return listener;
        }
        /**
         * Wraps an onRequestFinished listener function so that it will return a
         * `getContent()` property which returns a `Promise` rather than using a
         * callback API.
         *
         * @param {object} req
         *        The HAR entry object representing the network request.
         */


        return function onRequestFinished(req) {
          const wrappedReq = wrapObject(req, {}
          /* wrappers */
          , {
            getContent: {
              minArgs: 0,
              maxArgs: 0
            }
          });
          listener(wrappedReq);
        };
      }); // Keep track if the deprecation warning has been logged at least once.

      let loggedSendResponseDeprecationWarning = false;
      const onMessageWrappers = new DefaultWeakMap(listener => {
        if (typeof listener !== "function") {
          return listener;
        }
        /**
         * Wraps a message listener function so that it may send responses based on
         * its return value, rather than by returning a sentinel value and calling a
         * callback. If the listener function returns a Promise, the response is
         * sent when the promise either resolves or rejects.
         *
         * @param {*} message
         *        The message sent by the other end of the channel.
         * @param {object} sender
         *        Details about the sender of the message.
         * @param {function(*)} sendResponse
         *        A callback which, when called with an arbitrary argument, sends
         *        that value as a response.
         * @returns {boolean}
         *        True if the wrapped listener returned a Promise, which will later
         *        yield a response. False otherwise.
         */


        return function onMessage(message, sender, sendResponse) {
          let didCallSendResponse = false;
          let wrappedSendResponse;
          let sendResponsePromise = new Promise(resolve => {
            wrappedSendResponse = function (response) {
              if (!loggedSendResponseDeprecationWarning) {
                console.warn(SEND_RESPONSE_DEPRECATION_WARNING, new Error().stack);
                loggedSendResponseDeprecationWarning = true;
              }

              didCallSendResponse = true;
              resolve(response);
            };
          });
          let result;

          try {
            result = listener(message, sender, wrappedSendResponse);
          } catch (err) {
            result = Promise.reject(err);
          }

          const isResultThenable = result !== true && isThenable(result); // If the listener didn't returned true or a Promise, or called
          // wrappedSendResponse synchronously, we can exit earlier
          // because there will be no response sent from this listener.

          if (result !== true && !isResultThenable && !didCallSendResponse) {
            return false;
          } // A small helper to send the message if the promise resolves
          // and an error if the promise rejects (a wrapped sendMessage has
          // to translate the message into a resolved promise or a rejected
          // promise).


          const sendPromisedResult = promise => {
            promise.then(msg => {
              // send the message value.
              sendResponse(msg);
            }, error => {
              // Send a JSON representation of the error if the rejected value
              // is an instance of error, or the object itself otherwise.
              let message;

              if (error && (error instanceof Error || typeof error.message === "string")) {
                message = error.message;
              } else {
                message = "An unexpected error occurred";
              }

              sendResponse({
                __mozWebExtensionPolyfillReject__: true,
                message
              });
            }).catch(err => {
              // Print an error on the console if unable to send the response.
              console.error("Failed to send onMessage rejected reply", err);
            });
          }; // If the listener returned a Promise, send the resolved value as a
          // result, otherwise wait the promise related to the wrappedSendResponse
          // callback to resolve and send it as a response.


          if (isResultThenable) {
            sendPromisedResult(result);
          } else {
            sendPromisedResult(sendResponsePromise);
          } // Let Chrome know that the listener is replying.


          return true;
        };
      });

      const wrappedSendMessageCallback = ({
        reject,
        resolve
      }, reply) => {
        if (extensionAPIs.runtime.lastError) {
          // Detect when none of the listeners replied to the sendMessage call and resolve
          // the promise to undefined as in Firefox.
          // See https://github.com/mozilla/webextension-polyfill/issues/130
          if (extensionAPIs.runtime.lastError.message === CHROME_SEND_MESSAGE_CALLBACK_NO_RESPONSE_MESSAGE) {
            resolve();
          } else {
            reject(new Error(extensionAPIs.runtime.lastError.message));
          }
        } else if (reply && reply.__mozWebExtensionPolyfillReject__) {
          // Convert back the JSON representation of the error into
          // an Error instance.
          reject(new Error(reply.message));
        } else {
          resolve(reply);
        }
      };

      const wrappedSendMessage = (name, metadata, apiNamespaceObj, ...args) => {
        if (args.length < metadata.minArgs) {
          throw new Error(`Expected at least ${metadata.minArgs} ${pluralizeArguments(metadata.minArgs)} for ${name}(), got ${args.length}`);
        }

        if (args.length > metadata.maxArgs) {
          throw new Error(`Expected at most ${metadata.maxArgs} ${pluralizeArguments(metadata.maxArgs)} for ${name}(), got ${args.length}`);
        }

        return new Promise((resolve, reject) => {
          const wrappedCb = wrappedSendMessageCallback.bind(null, {
            resolve,
            reject
          });
          args.push(wrappedCb);
          apiNamespaceObj.sendMessage(...args);
        });
      };

      const staticWrappers = {
        devtools: {
          network: {
            onRequestFinished: wrapEvent(onRequestFinishedWrappers)
          }
        },
        runtime: {
          onMessage: wrapEvent(onMessageWrappers),
          onMessageExternal: wrapEvent(onMessageWrappers),
          sendMessage: wrappedSendMessage.bind(null, "sendMessage", {
            minArgs: 1,
            maxArgs: 3
          })
        },
        tabs: {
          sendMessage: wrappedSendMessage.bind(null, "sendMessage", {
            minArgs: 2,
            maxArgs: 3
          })
        }
      };
      const settingMetadata = {
        clear: {
          minArgs: 1,
          maxArgs: 1
        },
        get: {
          minArgs: 1,
          maxArgs: 1
        },
        set: {
          minArgs: 1,
          maxArgs: 1
        }
      };
      apiMetadata.privacy = {
        network: {
          "*": settingMetadata
        },
        services: {
          "*": settingMetadata
        },
        websites: {
          "*": settingMetadata
        }
      };
      return wrapObject(extensionAPIs, staticWrappers, apiMetadata);
    };

    if (typeof chrome != "object" || !chrome || !chrome.runtime || !chrome.runtime.id) {
      throw new Error("This script should only be loaded in a browser extension.");
    } // The build process adds a UMD wrapper around this file, which makes the
    // `module` variable available.


    module.exports = wrapAPIs(chrome);
  } else {
    module.exports = browser;
  }
});
//# sourceMappingURL=browser-polyfill.js.map


/***/ })

/******/ 	});
/************************************************************************/
/******/ 	// The module cache
/******/ 	var __webpack_module_cache__ = {};
/******/ 	
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/ 		// Check if module is in cache
/******/ 		var cachedModule = __webpack_module_cache__[moduleId];
/******/ 		if (cachedModule !== undefined) {
/******/ 			return cachedModule.exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = __webpack_module_cache__[moduleId] = {
/******/ 			// no module.id needed
/******/ 			// no module.loaded needed
/******/ 			exports: {}
/******/ 		};
/******/ 	
/******/ 		// Execute the module function
/******/ 		__webpack_modules__[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/ 	
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/ 	
/************************************************************************/
/******/ 	/* webpack/runtime/compat get default export */
/******/ 	(() => {
/******/ 		// getDefaultExport function for compatibility with non-harmony modules
/******/ 		__webpack_require__.n = (module) => {
/******/ 			var getter = module && module.__esModule ?
/******/ 				() => (module['default']) :
/******/ 				() => (module);
/******/ 			__webpack_require__.d(getter, { a: getter });
/******/ 			return getter;
/******/ 		};
/******/ 	})();
/******/ 	
/******/ 	/* webpack/runtime/define property getters */
/******/ 	(() => {
/******/ 		// define getter functions for harmony exports
/******/ 		__webpack_require__.d = (exports, definition) => {
/******/ 			for(var key in definition) {
/******/ 				if(__webpack_require__.o(definition, key) && !__webpack_require__.o(exports, key)) {
/******/ 					Object.defineProperty(exports, key, { enumerable: true, get: definition[key] });
/******/ 				}
/******/ 			}
/******/ 		};
/******/ 	})();
/******/ 	
/******/ 	/* webpack/runtime/hasOwnProperty shorthand */
/******/ 	(() => {
/******/ 		__webpack_require__.o = (obj, prop) => (Object.prototype.hasOwnProperty.call(obj, prop))
/******/ 	})();
/******/ 	
/******/ 	/* webpack/runtime/make namespace object */
/******/ 	(() => {
/******/ 		// define __esModule on exports
/******/ 		__webpack_require__.r = (exports) => {
/******/ 			if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 				Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 			}
/******/ 			Object.defineProperty(exports, '__esModule', { value: true });
/******/ 		};
/******/ 	})();
/******/ 	
/************************************************************************/
var __webpack_exports__ = {};
// This entry need to be wrapped in an IIFE because it need to be in strict mode.
(() => {
"use strict";
/*!**************************************!*\
  !*** ./src/targets/content/index.ts ***!
  \**************************************/
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _pages_content__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../../pages/content */ "./src/pages/content/index.ts");

_pages_content__WEBPACK_IMPORTED_MODULE_0__.content.init();
})();

/******/ })()
;
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIndlYnBhY2s6Ly9hZHZhbmNlZC1hZGJsb2NrZXItd2ViLWV4dGVuc2lvbi8uL25vZGVfbW9kdWxlcy9AYmFiZWwvcnVudGltZS9oZWxwZXJzL2VzbS9hcnJheUxpa2VUb0FycmF5LmpzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vbm9kZV9tb2R1bGVzL0BiYWJlbC9ydW50aW1lL2hlbHBlcnMvZXNtL2FycmF5V2l0aG91dEhvbGVzLmpzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vbm9kZV9tb2R1bGVzL0BiYWJlbC9ydW50aW1lL2hlbHBlcnMvZXNtL2FzeW5jVG9HZW5lcmF0b3IuanMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vLi9ub2RlX21vZHVsZXMvQGJhYmVsL3J1bnRpbWUvaGVscGVycy9lc20vaXRlcmFibGVUb0FycmF5LmpzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vbm9kZV9tb2R1bGVzL0BiYWJlbC9ydW50aW1lL2hlbHBlcnMvZXNtL25vbkl0ZXJhYmxlU3ByZWFkLmpzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vbm9kZV9tb2R1bGVzL0BiYWJlbC9ydW50aW1lL2hlbHBlcnMvZXNtL3RvQ29uc3VtYWJsZUFycmF5LmpzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vbm9kZV9tb2R1bGVzL0BiYWJlbC9ydW50aW1lL2hlbHBlcnMvZXNtL3Vuc3VwcG9ydGVkSXRlcmFibGVUb0FycmF5LmpzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vbm9kZV9tb2R1bGVzL0BiYWJlbC9ydW50aW1lL3JlZ2VuZXJhdG9yL2luZGV4LmpzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vc3JjL3BhZ2VzL2NvbW1vbi9jb25zdGFudHMudHMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vLi9zcmMvcGFnZXMvY29udGVudC9jb250ZW50LnRzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vbm9kZV9tb2R1bGVzL2V4dGVuZGVkLWNzcy9kaXN0L2V4dGVuZGVkLWNzcy5lc20uanMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vLi9ub2RlX21vZHVsZXMvcmVnZW5lcmF0b3ItcnVudGltZS9ydW50aW1lLmpzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vbm9kZV9tb2R1bGVzL3dlYmV4dGVuc2lvbi1wb2x5ZmlsbC9kaXN0L2Jyb3dzZXItcG9seWZpbGwuanMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vd2VicGFjay9ib290c3RyYXAiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vd2VicGFjay9ydW50aW1lL2NvbXBhdCBnZXQgZGVmYXVsdCBleHBvcnQiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vd2VicGFjay9ydW50aW1lL2RlZmluZSBwcm9wZXJ0eSBnZXR0ZXJzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uL3dlYnBhY2svcnVudGltZS9oYXNPd25Qcm9wZXJ0eSBzaG9ydGhhbmQiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vd2VicGFjay9ydW50aW1lL21ha2UgbmFtZXNwYWNlIG9iamVjdCIsIndlYnBhY2s6Ly9hZHZhbmNlZC1hZGJsb2NrZXItd2ViLWV4dGVuc2lvbi8uL3NyYy90YXJnZXRzL2NvbnRlbnQvaW5kZXgudHMiXSwibmFtZXMiOlsiTWVzc2FnZXNUb05hdGl2ZUFwcCIsIk1lc3NhZ2VzVG9CYWNrZ3JvdW5kUGFnZSIsIk1lc3NhZ2VzVG9Db250ZW50U2NyaXB0IiwiQXBwZWFyYW5jZVRoZW1lIiwiQVBQRUFSQU5DRV9USEVNRV9ERUZBVUxUIiwiU3lzdGVtIiwiV0VCX0VYVEVOU0lPTl9NT1JFX1VSTCIsIlBsYXRmb3JtcyIsImxvZ01lc3NhZ2UiLCJ2ZXJib3NlIiwibWVzc2FnZSIsImNvbnNvbGUiLCJsb2ciLCJnZXRTZWxlY3RvcnNBbmRTY3JpcHRzIiwiYnJvd3NlciIsInR5cGUiLCJkYXRhIiwidXJsIiwid2luZG93IiwibG9jYXRpb24iLCJocmVmIiwicmVzcG9uc2UiLCJleGVjdXRlU2NyaXB0cyIsInNjcmlwdHMiLCJzdGFydCIsImVuZCIsInVwZGF0ZWQiLCJzY3JpcHRUYWciLCJkb2N1bWVudCIsImNyZWF0ZUVsZW1lbnQiLCJzZXRBdHRyaWJ1dGUiLCJ0ZXh0Q29udGVudCIsImpvaW4iLCJwYXJlbnQiLCJoZWFkIiwiZG9jdW1lbnRFbGVtZW50IiwiYXBwZW5kQ2hpbGQiLCJwYXJlbnROb2RlIiwicmVtb3ZlQ2hpbGQiLCJhcHBseVNjcmlwdHMiLCJsZW5ndGgiLCJyZXZlcnNlIiwicHJvdGVjdFN0eWxlRWxlbWVudENvbnRlbnQiLCJwcm90ZWN0U3R5bGVFbCIsIk11dGF0aW9uT2JzZXJ2ZXIiLCJXZWJLaXRNdXRhdGlvbk9ic2VydmVyIiwiaW5uZXJPYnNlcnZlciIsIm11dGF0aW9ucyIsImkiLCJtIiwiaGFzQXR0cmlidXRlIiwiZ2V0QXR0cmlidXRlIiwicmVtb3ZlQXR0cmlidXRlIiwiaXNQcm90ZWN0U3R5bGVFbE1vZGlmaWVkIiwicmVtb3ZlZE5vZGVzIiwiaiIsIm9sZFZhbHVlIiwib2JzZXJ2ZSIsImNoaWxkTGlzdCIsImNoYXJhY3RlckRhdGEiLCJzdWJ0cmVlIiwiY2hhcmFjdGVyRGF0YU9sZFZhbHVlIiwiYXBwbHlDc3MiLCJzdHlsZVNlbGVjdG9ycyIsInN0eWxlRWxlbWVudCIsInNlbGVjdG9ycyIsIm1hcCIsInMiLCJ0cmltIiwiZm9yRWFjaCIsInNlbGVjdG9yIiwic2hlZXQiLCJpbnNlcnRSdWxlIiwiZSIsImFwcGx5RXh0ZW5kZWRDc3MiLCJleHRlbmRlZENzcyIsImV4dGNzcyIsIkV4dGVuZGVkQ3NzIiwic3R5bGVTaGVldCIsImZpbHRlciIsImFwcGx5IiwiYXBwbHlBZHZhbmNlZEJsb2NraW5nRGF0YSIsInNlbGVjdG9yc0FuZFNjcmlwdHMiLCJjc3NJbmplY3QiLCJjc3NFeHRlbmRlZCIsImluaXQiLCJIVE1MRG9jdW1lbnQiLCJpbmRleE9mIiwic3RhcnRHZXR0aW5nU2NyaXB0cyIsIkRhdGUiLCJub3ciLCJjb250ZW50Il0sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7Ozs7OztBQUFlO0FBQ2Y7O0FBRUEsd0NBQXdDLFNBQVM7QUFDakQ7QUFDQTs7QUFFQTtBQUNBLEM7Ozs7Ozs7Ozs7Ozs7Ozs7QUNScUQ7QUFDdEM7QUFDZixpQ0FBaUMsNkRBQWdCO0FBQ2pELEM7Ozs7Ozs7Ozs7Ozs7OztBQ0hBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsR0FBRztBQUNIO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0EsR0FBRztBQUNIO0FBQ0E7QUFDQTs7QUFFZTtBQUNmO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBLEtBQUs7QUFDTDtBQUNBLEM7Ozs7Ozs7Ozs7Ozs7OztBQ2xDZTtBQUNmO0FBQ0EsQzs7Ozs7Ozs7Ozs7Ozs7O0FDRmU7QUFDZjtBQUNBLEM7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7QUNGdUQ7QUFDSjtBQUNzQjtBQUNsQjtBQUN4QztBQUNmLFNBQVMsOERBQWlCLFNBQVMsNERBQWUsU0FBUyx1RUFBMEIsU0FBUyw4REFBaUI7QUFDL0csQzs7Ozs7Ozs7Ozs7Ozs7OztBQ05xRDtBQUN0QztBQUNmO0FBQ0Esb0NBQW9DLDZEQUFnQjtBQUNwRDtBQUNBO0FBQ0E7QUFDQSxzRkFBc0YsNkRBQWdCO0FB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QUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsS0FBSztBQUNMO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsSUFBSTtBQUNKO0FBQ0EsMkNBQTJDLGFBQWE7QUFDeEQ7QUFDQTs7O0FBR0E7QUFDQTtBQUNBLCtCQUErQjs7QUFFL0I7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsYUFBYSxPQUFPO0FBQ3BCLGNBQWM7QUFDZDs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQSxLQUFLO0FBQ0w7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsQ0FBQzs7QUFFRDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFD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QTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQSxtQkFBbUIsa0NBQWtDO0FBQ3JEOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxnQ0FBZ0M7O0FBRWhDO0FBQ0E7QUFDQTtBQUNBLEtBQUs7QUFDTDtBQUNBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0EsT0FBTztBQUNQO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsS0FBSzs7QUFFTDtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0EsMkJBQTJCO0FBQzNCO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQSxLQUFLLEVBQUU7O0FBRVAsb0NBQW9DOztBQUVwQztBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxLQUFLOzs7QUFHTDtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLEtBQUs7OztBQUdMO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxLQUFLO0FBQ0w7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0EsS0FBSztBQUNMO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsS0FBSzs7QUFFTDtBQUNBO0FBQ0EsS0FBSzs7O0FBR0w7QUFDQSxHQUFHOzs7QUFHSCxpREFBaUQ7O0FBRWpEO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVcsT0FBTztBQUNsQixXQUFXLFFBQVE7QUFDbkIsYUFBYSxxQkFBcUI7QUFDbEM7QUFDQTs7O0FBR0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0EsR0FBRztBQUNIOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUEsaUVBQWUsV0FBVyxFQUFDOzs7Ozs7Ozs7OztBQ3BySzNCO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQSxnQkFBZ0I7QUFDaEI7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsS0FBSztBQUNMO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsYUFBYTtBQUNiLEdBQUc7QUFDSDtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsY0FBYztBQUNkLEtBQUs7QUFDTCxjQUFjO0FBQ2Q7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSx5REFBeUQ7QUFDekQ7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxPQUFPO0FBQ1AsS0FBSztBQUNMOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQSxLQUFLO0FBQ0w7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxZQUFZO0FBQ1o7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLE9BQU87QUFDUDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBLFdBQVc7QUFDWDs7QUFFQTtBQUNBO0FBQ0Esd0NBQXdDLFdBQVc7QUFDbkQ7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBOztBQUVBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBLDJCQUEyQjtBQUMzQjtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7O0FBRUEsU0FBUztBQUNUO0FBQ0E7O0FBRUE7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQSxvQ0FBb0MsY0FBYztBQUNsRDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBLEtBQUs7QUFDTDtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQSxpQ0FBaUMsa0JBQWtCO0FBQ25EO0FBQ0E7O0FBRUE7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQSxpQkFBaUI7O0FBRWpCO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLHdCQUF3QixpQkFBaUI7QUFDekM7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFD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QUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsYUFBYTtBQUNiO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLGFBQWE7QUFDYjtBQUNBO0FBQ0E7QUFDQSxhQUFhO0FBQ2I7QUFDQTtBQUNBO0FBQ0EsYUFBYTtBQUNiO0FBQ0E7QUFDQTtBQUNBLGFBQWE7QUFDYjtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLGFBQWE7QUFDYjtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLGFBQWE7QUFDYjtBQUNBO0FBQ0E7QUFDQSxhQUFhO0FBQ2I7QUFDQTtBQUNBO0FBQ0EsYUFBYTtBQUNiO0FBQ0E7QUFDQTtBQUNBLGFBQWE7QUFDYjtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtB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Q0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0EsS0FBSztBQUNMOzs7QUFHQTtBQUNBLEdBQUc7QUFDSDtBQUNBO0FBQ0EsQ0FBQztBQUNEOzs7Ozs7O1VDNXZDQTtVQUNBOztVQUVBO1VBQ0E7VUFDQTtVQUNBO1VBQ0E7VUFDQTtVQUNBO1VBQ0E7VUFDQTtVQUNBO1VBQ0E7VUFDQTtVQUNBOztVQUVBO1VBQ0E7O1VBRUE7VUFDQTtVQUNBOzs7OztXQ3RCQTtXQUNBO1dBQ0E7V0FDQTtXQUNBO1dBQ0EsZ0NBQWdDLFlBQVk7V0FDNUM7V0FDQSxFOzs7OztXQ1BBO1dBQ0E7V0FDQTtXQUNBO1dBQ0Esd0NBQXdDLHlDQUF5QztXQUNqRjtXQUNBO1dBQ0EsRTs7Ozs7V0NQQSx3Rjs7Ozs7V0NBQTtXQUNBO1dBQ0E7V0FDQSxzREFBc0Qsa0JBQWtCO1dBQ3hFO1dBQ0EsK0NBQStDLGNBQWM7V0FDN0QsRTs7Ozs7Ozs7Ozs7OztBQ05BO0FBRUFNLHdEQUFBLEciLCJmaWxlIjoiY29udGVudC5qcyIsInNvdXJjZXNDb250ZW50IjpbImV4cG9ydCBkZWZhdWx0IGZ1bmN0aW9uIF9hcnJheUxpa2VUb0FycmF5KGFyciwgbGVuKSB7XG4gIGlmIChsZW4gPT0gbnVsbCB8fCBsZW4gPiBhcnIubGVuZ3RoKSBsZW4gPSBhcnIubGVuZ3RoO1xuXG4gIGZvciAodmFyIGkgPSAwLCBhcnIyID0gbmV3IEFycmF5KGxlbik7IGkgPCBsZW47IGkrKykge1xuICAgIGFycjJbaV0gPSBhcnJbaV07XG4gIH1cblxuICByZXR1cm4gYXJyMjtcbn0iLCJpbXBvcnQgYXJyYXlMaWtlVG9BcnJheSBmcm9tIFwiLi9hcnJheUxpa2VUb0FycmF5LmpzXCI7XG5leHBvcnQgZGVmYXVsdCBmdW5jdGlvbiBfYXJyYXlXaXRob3V0SG9sZXMoYXJyKSB7XG4gIGlmIChBcnJheS5pc0FycmF5KGFycikpIHJldHVybiBhcnJheUxpa2VUb0FycmF5KGFycik7XG59IiwiZnVuY3Rpb24gYXN5bmNHZW5lcmF0b3JTdGVwKGdlbiwgcmVzb2x2ZSwgcmVqZWN0LCBfbmV4dCwgX3Rocm93LCBrZXksIGFyZykge1xuICB0cnkge1xuICAgIHZhciBpbmZvID0gZ2VuW2tleV0oYXJnKTtcbiAgICB2YXIgdmFsdWUgPSBpbmZvLnZhbHVlO1xuICB9IGNhdGNoIChlcnJvcikge1xuICAgIHJlamVjdChlcnJvcik7XG4gICAgcmV0dXJuO1xuICB9XG5cbiAgaWYgKGluZm8uZG9uZSkge1xuICAgIHJlc29sdmUodmFsdWUpO1xuICB9IGVsc2Uge1xuICAgIFByb21pc2UucmVzb2x2ZSh2YWx1ZSkudGhlbihfbmV4dCwgX3Rocm93KTtcbiAgfVxufVxuXG5leHBvcnQgZGVmYXVsdCBmdW5jdGlvbiBfYXN5bmNUb0dlbmVyYXRvcihmbikge1xuICByZXR1cm4gZnVuY3Rpb24gKCkge1xuICAgIHZhciBzZWxmID0gdGhpcyxcbiAgICAgICAgYXJncyA9IGFyZ3VtZW50cztcbiAgICByZXR1cm4gbmV3IFByb21pc2UoZnVuY3Rpb24gKHJlc29sdmUsIHJlamVjdCkge1xuICAgICAgdmFyIGdlbiA9IGZuLmFwcGx5KHNlbGYsIGFyZ3MpO1xuXG4gICAgICBmdW5jdGlvbiBfbmV4dCh2YWx1ZSkge1xuICAgICAgICBhc3luY0dlbmVyYXRvclN0ZXAoZ2VuLCByZXNvbHZlLCByZWplY3QsIF9uZXh0LCBfdGhyb3csIFwibmV4dFwiLCB2YWx1ZSk7XG4gICAgICB9XG5cbiAgICAgIGZ1bmN0aW9uIF90aHJvdyhlcnIpIHtcbiAgICAgICAgYXN5bmNHZW5lcmF0b3JTdGVwKGdlbiwgcmVzb2x2ZSwgcmVqZWN0LCBfbmV4dCwgX3Rocm93LCBcInRocm93XCIsIGVycik7XG4gICAgICB9XG5cbiAgICAgIF9uZXh0KHVuZGVmaW5lZCk7XG4gICAgfSk7XG4gIH07XG59IiwiZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24gX2l0ZXJhYmxlVG9BcnJheShpdGVyKSB7XG4gIGlmICh0eXBlb2YgU3ltYm9sICE9PSBcInVuZGVmaW5lZFwiICYmIGl0ZXJbU3ltYm9sLml0ZXJhdG9yXSAhPSBudWxsIHx8IGl0ZXJbXCJAQGl0ZXJhdG9yXCJdICE9IG51bGwpIHJldHVybiBBcnJheS5mcm9tKGl0ZXIpO1xufSIsImV4cG9ydCBkZWZhdWx0IGZ1bmN0aW9uIF9ub25JdGVyYWJsZVNwcmVhZCgpIHtcbiAgdGhyb3cgbmV3IFR5cGVFcnJvcihcIkludmFsaWQgYXR0ZW1wdCB0byBzcHJlYWQgbm9uLWl0ZXJhYmxlIGluc3RhbmNlLlxcbkluIG9yZGVyIHRvIGJlIGl0ZXJhYmxlLCBub24tYXJyYXkgb2JqZWN0cyBtdXN0IGhhdmUgYSBbU3ltYm9sLml0ZXJhdG9yXSgpIG1ldGhvZC5cIik7XG59IiwiaW1wb3J0IGFycmF5V2l0aG91dEhvbGVzIGZyb20gXCIuL2FycmF5V2l0aG91dEhvbGVzLmpzXCI7XG5pbXBvcnQgaXRlcmFibGVUb0FycmF5IGZyb20gXCIuL2l0ZXJhYmxlVG9BcnJheS5qc1wiO1xuaW1wb3J0IHVuc3VwcG9ydGVkSXRlcmFibGVUb0FycmF5IGZyb20gXCIuL3Vuc3VwcG9ydGVkSXRlcmFibGVUb0FycmF5LmpzXCI7XG5pbXBvcnQgbm9uSXRlcmFibGVTcHJlYWQgZnJvbSBcIi4vbm9uSXRlcmFibGVTcHJlYWQuanNcIjtcbmV4cG9ydCBkZWZhdWx0IGZ1bmN0aW9uIF90b0NvbnN1bWFibGVBcnJheShhcnIpIHtcbiAgcmV0dXJuIGFycmF5V2l0aG91dEhvbGVzKGFycikgfHwgaXRlcmFibGVUb0FycmF5KGFycikgfHwgdW5zdXBwb3J0ZWRJdGVyYWJsZVRvQXJyYXkoYXJyKSB8fCBub25JdGVyYWJsZVNwcmVhZCgpO1xufSIsImltcG9ydCBhcnJheUxpa2VUb0FycmF5IGZyb20gXCIuL2FycmF5TGlrZVRvQXJyYXkuanNcIjtcbmV4cG9ydCBkZWZhdWx0IGZ1bmN0aW9uIF91bnN1cHBvcnRlZEl0ZXJhYmxlVG9BcnJheShvLCBtaW5MZW4pIHtcbiAgaWYgKCFvKSByZXR1cm47XG4gIGlmICh0eXBlb2YgbyA9PT0gXCJzdHJpbmdcIikgcmV0dXJuIGFycmF5TGlrZVRvQXJyYXkobywgbWluTGVuKTtcbiAgdmFyIG4gPSBPYmplY3QucHJvdG90eXBlLnRvU3RyaW5nLmNhbGwobykuc2xpY2UoOCwgLTEpO1xuICBpZiAobiA9PT0gXCJPYmplY3RcIiAmJiBvLmNvbnN0cnVjdG9yKSBuID0gby5jb25zdHJ1Y3Rvci5uYW1lO1xuICBpZiAobiA9PT0gXCJNYXBcIiB8fCBuID09PSBcIlNldFwiKSByZXR1cm4gQXJyYXkuZnJvbShvKTtcbiAgaWYgKG4gPT09IFwiQXJndW1lbnRzXCIgfHwgL14oPzpVaXxJKW50KD86OHwxNnwzMikoPzpDbGFtcGVkKT9BcnJheSQvLnRlc3QobikpIHJldHVybiBhcnJheUxpa2VUb0FycmF5KG8sIG1pbkxlbik7XG59IiwibW9kdWxlLmV4cG9ydHMgPSByZXF1aXJlKFwicmVnZW5lcmF0b3ItcnVudGltZVwiKTtcbiIsImV4cG9ydCBlbnVtIE1lc3NhZ2VzVG9OYXRpdmVBcHAge1xuICAgIFdyaXRlSW5OYXRpdmVMb2cgPSAnd3JpdGVJbk5hdGl2ZUxvZycsXG4gICAgR2V0QWR2YW5jZWRSdWxlc1RleHQgPSAnZ2V0X2FkdmFuY2VkX3J1bGVzX3RleHQnLFxuICAgIEdldEluaXREYXRhID0gJ2dldF9pbml0X2RhdGEnLFxuICAgIFNob3VsZFVwZGF0ZUFkdmFuY2VkUnVsZXMgPSAnc2hvdWxkX3VwZGF0ZV9hZHZhbmNlZF9ydWxlcycsXG59XG5cbmV4cG9ydCBlbnVtIE1lc3NhZ2VzVG9CYWNrZ3JvdW5kUGFnZSB7XG4gICAgT3BlbkFzc2lzdGFudCA9ICdvcGVuX2Fzc2lzdGFudCcsXG4gICAgR2V0U2NyaXB0c0FuZFNlbGVjdG9ycyA9ICdnZXRfc2NyaXB0c19hbmRfc2VsZWN0b3JzJyxcbiAgICBBZGRSdWxlID0gJ2FkZF9ydWxlJyxcbiAgICBHZXRQb3B1cERhdGEgPSAnZ2V0X3BvcHVwX2RhdGEnLFxuICAgIFNldFBlcm1pc3Npb25zTW9kYWxWaWV3ZWQgPSAnc2V0X3Blcm1pc3Npb25zX21vZGFsX3ZpZXdlZCcsXG4gICAgU2V0UHJvdGVjdGlvblN0YXR1cyA9ICdzZXRfcHJvdGVjdGlvbl9zdGF0dXMnLFxuICAgIERlbGV0ZVVzZXJSdWxlc0J5VXJsID0gJ2RlbGV0ZV91c2VyX3J1bGVzX2J5X3VybCcsXG4gICAgUmVwb3J0UHJvYmxlbSA9ICdyZXBvcnRfcHJvYmxlbScsXG4gICAgVXBncmFkZUNsaWNrZWQgPSAndXBncmFkZV9jbGlja2VkJyxcbiAgICBFbmFibGVBZHZhbmNlZEJsb2NraW5nID0gJ2VuYWJsZV9hZHZhbmNlZF9ibG9ja2luZycsXG59XG5cbmV4cG9ydCBlbnVtIE1lc3NhZ2VzVG9Db250ZW50U2NyaXB0IHtcbiAgICBJbml0QXNzaXN0YW50ID0gJ2luaXRfYXNzaXN0YW50Jyxcbn1cblxuZXhwb3J0IGVudW0gQXBwZWFyYW5jZVRoZW1lIHtcbiAgICBTeXN0ZW0gPSAnc3lzdGVtJyxcbiAgICBEYXJrID0gJ2RhcmsnLFxuICAgIExpZ2h0ID0gJ2xpZ2h0Jyxcbn1cblxuZXhwb3J0IGNvbnN0IEFQUEVBUkFOQ0VfVEhFTUVfREVGQVVMVCA9IEFwcGVhcmFuY2VUaGVtZS5TeXN0ZW07XG5cbmV4cG9ydCBjb25zdCBXRUJfRVhURU5TSU9OX01PUkVfVVJMID0gJ2h0dHBzOi8vYWRndWFyZC5jb20vZm9yd2FyZC5odG1sP2FjdGlvbj13ZWJfZXh0ZW5zaW9uX21vcmUmZnJvbT1wb3B1cCZhcHA9aW9zJztcblxuZXhwb3J0IGVudW0gUGxhdGZvcm1zIHtcbiAgICBJUGFkID0gJ2lwYWQnLFxuICAgIElQaG9uZSA9ICdpcGhvbmUnLFxufVxuIiwiLyogZXNsaW50LWRpc2FibGUgbm8tY29uc29sZSAqL1xuaW1wb3J0IGJyb3dzZXIgZnJvbSAnd2ViZXh0ZW5zaW9uLXBvbHlmaWxsJztcbmltcG9ydCBFeHRlbmRlZENzcyBmcm9tICdleHRlbmRlZC1jc3MnO1xuXG5pbXBvcnQgeyBNZXNzYWdlc1RvQmFja2dyb3VuZFBhZ2UgfSBmcm9tICcuLi9jb21tb24vY29uc3RhbnRzJztcbmltcG9ydCB7IFNlbGVjdG9yc0FuZFNjcmlwdHMgfSBmcm9tICcuLi9jb21tb24vaW50ZXJmYWNlcyc7XG5cbi8qKlxuICogTG9ncyBhIG1lc3NhZ2UgaWYgdmVyYm9zZSBpcyB0cnVlXG4gKlxuICogQHBhcmFtIHZlcmJvc2VcbiAqIEBwYXJhbSBtZXNzYWdlXG4gKi9cbmNvbnN0IGxvZ01lc3NhZ2UgPSAodmVyYm9zZTogYm9vbGVhbiwgbWVzc2FnZTogc3RyaW5nKSA9PiB7XG4gICAgaWYgKHZlcmJvc2UpIHtcbiAgICAgICAgY29uc29sZS5sb2coYChBRykgJHttZXNzYWdlfWApO1xuICAgIH1cbn07XG5cbmNvbnN0IGdldFNlbGVjdG9yc0FuZFNjcmlwdHMgPSBhc3luYyAoKTogUHJvbWlzZTxTZWxlY3RvcnNBbmRTY3JpcHRzIHwgbnVsbD4gPT4ge1xuICAgIGNvbnN0IHJlc3BvbnNlID0gYXdhaXQgYnJvd3Nlci5ydW50aW1lLnNlbmRNZXNzYWdlKHtcbiAgICAgICAgdHlwZTogTWVzc2FnZXNUb0JhY2tncm91bmRQYWdlLkdldFNjcmlwdHNBbmRTZWxlY3RvcnMsXG4gICAgICAgIGRhdGE6IHtcbiAgICAgICAgICAgIHVybDogd2luZG93LmxvY2F0aW9uLmhyZWYsXG4gICAgICAgIH0sXG4gICAgfSk7XG5cbiAgICBpZiAocmVzcG9uc2UgPT09IG51bGwpIHtcbiAgICAgICAgY29uc29sZS5sb2coJ0FHOiBubyBzY3JpcHRzIGFuZCBzZWxlY3RvcnMgcmVjZWl2ZWQnKTtcbiAgICAgICAgcmV0dXJuIG51bGw7XG4gICAgfVxuXG4gICAgcmV0dXJuIHJlc3BvbnNlIGFzIFNlbGVjdG9yc0FuZFNjcmlwdHM7XG59O1xuXG4vKipcbiAqIEV4ZWN1dGUgc2NyaXB0cyBpbiBhIHBhZ2UgY29udGV4dCBhbmQgY2xlYW51cCBpdHNlbGYgd2hlbiBleGVjdXRpb24gY29tcGxldGVzXG4gKiBAcGFyYW0gc2NyaXB0cyBTY3JpcHRzIGFycmF5IHRvIGV4ZWN1dGVcbiAqL1xuY29uc3QgZXhlY3V0ZVNjcmlwdHMgPSAoc2NyaXB0czogc3RyaW5nW10pID0+IHtcbiAgICAvLyBXcmFwIHdpdGggdHJ5IGNhdGNoXG4gICAgY29uc3Qgc3RhcnQgPSAnKCBmdW5jdGlvbiAoKSB7IHRyeSB7JztcbiAgICBjb25zdCBlbmQgPSBcIn0gY2F0Y2ggKGV4KSB7IGNvbnNvbGUuZXJyb3IoJ0Vycm9yIGV4ZWN1dGluZyBBRyBqczogJyArIGV4KTsgfSB9KSgpO1wiO1xuXG4gICAgY29uc3QgdXBkYXRlZCA9IFtzdGFydCwgLi4uc2NyaXB0cywgZW5kXTtcblxuICAgIGNvbnN0IHNjcmlwdFRhZyA9IGRvY3VtZW50LmNyZWF0ZUVsZW1lbnQoJ3NjcmlwdCcpO1xuICAgIHNjcmlwdFRhZy5zZXRBdHRyaWJ1dGUoJ3R5cGUnLCAndGV4dC9qYXZhc2NyaXB0Jyk7XG4gICAgc2NyaXB0VGFnLnRleHRDb250ZW50ID0gdXBkYXRlZC5qb2luKCdcXHJcXG4nKTtcblxuICAgIGNvbnN0IHBhcmVudCA9IGRvY3VtZW50LmhlYWQgfHwgZG9jdW1lbnQuZG9jdW1lbnRFbGVtZW50O1xuICAgIHBhcmVudC5hcHBlbmRDaGlsZChzY3JpcHRUYWcpO1xuICAgIGlmIChzY3JpcHRUYWcucGFyZW50Tm9kZSkge1xuICAgICAgICBzY3JpcHRUYWcucGFyZW50Tm9kZS5yZW1vdmVDaGlsZChzY3JpcHRUYWcpO1xuICAgIH1cbn07XG5cbi8qKlxuICogQXBwbGllcyBKUyBpbmplY3Rpb25zLlxuICogQHBhcmFtIHNjcmlwdHMgQXJyYXkgd2l0aCBKUyBzY3JpcHRzXG4gKiBAcGFyYW0gdmVyYm9zZSBsb2dnaW5nXG4gKi9cbmNvbnN0IGFwcGx5U2NyaXB0cyA9IChzY3JpcHRzOiBzdHJpbmdbXSwgdmVyYm9zZTogYm9vbGVhbikgPT4ge1xuICAgIGlmICghc2NyaXB0cyB8fCBzY3JpcHRzLmxlbmd0aCA9PT0gMCkge1xuICAgICAgICByZXR1cm47XG4gICAgfVxuXG4gICAgbG9nTWVzc2FnZSh2ZXJib3NlLCBgc2NyaXB0cyBsZW5ndGg6ICR7c2NyaXB0cy5sZW5ndGh9YCk7XG4gICAgZXhlY3V0ZVNjcmlwdHMoc2NyaXB0cy5yZXZlcnNlKCkpO1xufTtcblxuLyoqXG4gKiBQcm90ZWN0cyBzcGVjaWZpZWQgc3R5bGUgZWxlbWVudCBmcm9tIGNoYW5nZXMgdG8gdGhlIGN1cnJlbnQgZG9jdW1lbnRcbiAqIEFkZCBhIG11dGF0aW9uIG9ic2VydmVyLCB3aGljaCBpcyBhZGRzIG91ciBydWxlcyBhZ2FpbiBpZiBpdCB3YXMgcmVtb3ZlZFxuICpcbiAqIEBwYXJhbSBwcm90ZWN0U3R5bGVFbCBwcm90ZWN0ZWQgc3R5bGUgZWxlbWVudFxuICovXG5jb25zdCBwcm90ZWN0U3R5bGVFbGVtZW50Q29udGVudCA9IChwcm90ZWN0U3R5bGVFbDogTm9kZSkgPT4ge1xuICAgIC8vIEB0cy1pZ25vcmVcbiAgICBjb25zdCBNdXRhdGlvbk9ic2VydmVyID0gd2luZG93Lk11dGF0aW9uT2JzZXJ2ZXIgfHwgd2luZG93LldlYktpdE11dGF0aW9uT2JzZXJ2ZXI7XG4gICAgaWYgKCFNdXRhdGlvbk9ic2VydmVyKSB7XG4gICAgICAgIHJldHVybjtcbiAgICB9XG4gICAgLyogb2JzZXJ2ZXIsIHdoaWNoIG9ic2VydmUgcHJvdGVjdFN0eWxlRWwgaW5uZXIgY2hhbmdlcywgd2l0aG91dCBkZWxldGluZyBzdHlsZUVsICovXG4gICAgY29uc3QgaW5uZXJPYnNlcnZlciA9IG5ldyBNdXRhdGlvbk9ic2VydmVyKCgobXV0YXRpb25zKSA9PiB7XG4gICAgICAgIGZvciAobGV0IGkgPSAwOyBpIDwgbXV0YXRpb25zLmxlbmd0aDsgaSArPSAxKSB7XG4gICAgICAgICAgICBjb25zdCBtID0gbXV0YXRpb25zW2ldO1xuICAgICAgICAgICAgLy8gQHRzLWlnbm9yZVxuICAgICAgICAgICAgaWYgKHByb3RlY3RTdHlsZUVsLmhhc0F0dHJpYnV0ZSgnbW9kJykgJiYgcHJvdGVjdFN0eWxlRWwuZ2V0QXR0cmlidXRlKCdtb2QnKSA9PT0gJ2lubmVyJykge1xuICAgICAgICAgICAgICAgIC8vIEB0cy1pZ25vcmVcbiAgICAgICAgICAgICAgICBwcm90ZWN0U3R5bGVFbC5yZW1vdmVBdHRyaWJ1dGUoJ21vZCcpO1xuICAgICAgICAgICAgICAgIGJyZWFrO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAvLyBAdHMtaWdub3JlXG4gICAgICAgICAgICBwcm90ZWN0U3R5bGVFbC5zZXRBdHRyaWJ1dGUoJ21vZCcsICdpbm5lcicpO1xuICAgICAgICAgICAgbGV0IGlzUHJvdGVjdFN0eWxlRWxNb2RpZmllZCA9IGZhbHNlO1xuXG4gICAgICAgICAgICAvKipcbiAgICAgICAgICAgICAqIGZ1cnRoZXIsIHRoZXJlIGFyZSB0d28gbXV0dWFsbHkgZXhjbHVzaXZlIHNpdHVhdGlvbnM6IGVpdGhlciB0aGVyZSB3ZXJlIGNoYW5nZXNcbiAgICAgICAgICAgICAqIHRoZSB0ZXh0IG9mIHByb3RlY3RTdHlsZUVsLCBlaXRoZXIgdGhlcmUgd2FzIHJlbW92ZXMgYSB3aG9sZSBjaGlsZCBcInRleHRcIlxuICAgICAgICAgICAgICogZWxlbWVudCBvZiBwcm90ZWN0U3R5bGVFbCB3ZSdsbCBwcm9jZXNzIGJvdGggb2YgdGhlbVxuICAgICAgICAgICAgICovXG4gICAgICAgICAgICBpZiAobS5yZW1vdmVkTm9kZXMubGVuZ3RoID4gMCkge1xuICAgICAgICAgICAgICAgIGZvciAobGV0IGogPSAwOyBqIDwgbS5yZW1vdmVkTm9kZXMubGVuZ3RoOyBqICs9IDEpIHtcbiAgICAgICAgICAgICAgICAgICAgaXNQcm90ZWN0U3R5bGVFbE1vZGlmaWVkID0gdHJ1ZTtcbiAgICAgICAgICAgICAgICAgICAgcHJvdGVjdFN0eWxlRWwuYXBwZW5kQ2hpbGQobS5yZW1vdmVkTm9kZXNbal0pO1xuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH0gZWxzZSBpZiAobS5vbGRWYWx1ZSkge1xuICAgICAgICAgICAgICAgIGlzUHJvdGVjdFN0eWxlRWxNb2RpZmllZCA9IHRydWU7XG4gICAgICAgICAgICAgICAgLy8gZXNsaW50LWRpc2FibGUtbmV4dC1saW5lIG5vLXBhcmFtLXJlYXNzaWduXG4gICAgICAgICAgICAgICAgcHJvdGVjdFN0eWxlRWwudGV4dENvbnRlbnQgPSBtLm9sZFZhbHVlO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICBpZiAoIWlzUHJvdGVjdFN0eWxlRWxNb2RpZmllZCkge1xuICAgICAgICAgICAgICAgIC8vIEB0cy1pZ25vcmVcbiAgICAgICAgICAgICAgICBwcm90ZWN0U3R5bGVFbC5yZW1vdmVBdHRyaWJ1dGUoJ21vZCcpO1xuICAgICAgICAgICAgfVxuICAgICAgICB9XG4gICAgfSkpO1xuXG4gICAgaW5uZXJPYnNlcnZlci5vYnNlcnZlKHByb3RlY3RTdHlsZUVsLCB7XG4gICAgICAgIGNoaWxkTGlzdDogdHJ1ZSxcbiAgICAgICAgY2hhcmFjdGVyRGF0YTogdHJ1ZSxcbiAgICAgICAgc3VidHJlZTogdHJ1ZSxcbiAgICAgICAgY2hhcmFjdGVyRGF0YU9sZFZhbHVlOiB0cnVlLFxuICAgIH0pO1xufTtcblxuLyoqXG4gKiBBcHBsaWVzIGNzcyBzdHlsZXNoZWV0XG4gKiBAcGFyYW0gc3R5bGVTZWxlY3RvcnMgQXJyYXkgb2Ygc3R5bGVzaGVldHMgb3Igc2VsZWN0b3JzXG4gKiBAcGFyYW0gdmVyYm9zZSBsb2dnaW5nXG4gKi9cbmNvbnN0IGFwcGx5Q3NzID0gKHN0eWxlU2VsZWN0b3JzOiBzdHJpbmdbXSwgdmVyYm9zZTogYm9vbGVhbikgPT4ge1xuICAgIGlmICghc3R5bGVTZWxlY3RvcnMgfHwgIXN0eWxlU2VsZWN0b3JzLmxlbmd0aCkge1xuICAgICAgICByZXR1cm47XG4gICAgfVxuXG4gICAgbG9nTWVzc2FnZSh2ZXJib3NlLCBgY3NzIGxlbmd0aDogJHtzdHlsZVNlbGVjdG9ycy5sZW5ndGh9YCk7XG5cbiAgICBjb25zdCBzdHlsZUVsZW1lbnQgPSBkb2N1bWVudC5jcmVhdGVFbGVtZW50KCdzdHlsZScpO1xuICAgIHN0eWxlRWxlbWVudC5zZXRBdHRyaWJ1dGUoJ3R5cGUnLCAndGV4dC9jc3MnKTtcbiAgICAoZG9jdW1lbnQuaGVhZCB8fCBkb2N1bWVudC5kb2N1bWVudEVsZW1lbnQpLmFwcGVuZENoaWxkKHN0eWxlRWxlbWVudCk7XG5cbiAgICBjb25zdCBzZWxlY3RvcnMgPSBzdHlsZVNlbGVjdG9ycy5tYXAoKHMpID0+IHMudHJpbSgpKTtcblxuICAgIHNlbGVjdG9ycy5mb3JFYWNoKChzZWxlY3RvcikgPT4ge1xuICAgICAgICB0cnkge1xuICAgICAgICAgICAgc3R5bGVFbGVtZW50LnNoZWV0Py5pbnNlcnRSdWxlKHNlbGVjdG9yKTtcbiAgICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICAgICAgbG9nTWVzc2FnZSh2ZXJib3NlLCBgV2FzIHVuYWJsZSB0byBpbmplY3Qgc2VsZWN0b3I6ICR7c2VsZWN0b3J9LCBkdWUgdG8gZXJyb3I6ICR7ZX1gKTtcbiAgICAgICAgfVxuICAgIH0pO1xuXG4gICAgcHJvdGVjdFN0eWxlRWxlbWVudENvbnRlbnQoc3R5bGVFbGVtZW50KTtcbn07XG5cbi8qKlxuICogQXBwbGllcyBFeHRlbmRlZCBDc3Mgc3R5bGVzaGVldFxuICpcbiAqIEBwYXJhbSBleHRlbmRlZENzcyBBcnJheSB3aXRoIEV4dGVuZGVkQ3NzIHN0eWxlc2hlZXRzXG4gKiBAcGFyYW0gdmVyYm9zZSBsb2dnaW5nXG4gKi9cbmNvbnN0IGFwcGx5RXh0ZW5kZWRDc3MgPSAoZXh0ZW5kZWRDc3M6IHN0cmluZ1tdLCB2ZXJib3NlOiBib29sZWFuKSA9PiB7XG4gICAgaWYgKCFleHRlbmRlZENzcyB8fCAhZXh0ZW5kZWRDc3MubGVuZ3RoKSB7XG4gICAgICAgIHJldHVybjtcbiAgICB9XG5cbiAgICBsb2dNZXNzYWdlKHZlcmJvc2UsIGBleHRlbmRlZCBjc3MgbGVuZ3RoOiAke2V4dGVuZGVkQ3NzLmxlbmd0aH1gKTtcbiAgICBjb25zdCBleHRjc3MgPSBuZXcgRXh0ZW5kZWRDc3Moe1xuICAgICAgICBzdHlsZVNoZWV0OiBleHRlbmRlZENzc1xuICAgICAgICAgICAgLmZpbHRlcigocykgPT4gcy5sZW5ndGggPiAwKVxuICAgICAgICAgICAgLm1hcCgocykgPT4gcy50cmltKCkpXG4gICAgICAgICAgICAubWFwKChzKSA9PiAoc1tzLmxlbmd0aCAtIDFdICE9PSAnfScgPyBgJHtzfSB7ZGlzcGxheTpub25lIWltcG9ydGFudDt9YCA6IHMpKVxuICAgICAgICAgICAgLmpvaW4oJ1xcbicpLFxuICAgIH0pO1xuICAgIGV4dGNzcy5hcHBseSgpO1xufTtcblxuLyoqXG4gKiBBcHBsaWVzIGluamVjdGVkIHNjcmlwdCBhbmQgY3NzXG4gKlxuICogQHBhcmFtIHNlbGVjdG9yc0FuZFNjcmlwdHNcbiAqIEBwYXJhbSB2ZXJib3NlXG4gKi9cbmNvbnN0IGFwcGx5QWR2YW5jZWRCbG9ja2luZ0RhdGEgPSAoc2VsZWN0b3JzQW5kU2NyaXB0czogU2VsZWN0b3JzQW5kU2NyaXB0cywgdmVyYm9zZSA9IHRydWUpID0+IHtcbiAgICBsb2dNZXNzYWdlKHZlcmJvc2UsICdBcHBseWluZyBzY3JpcHRzIGFuZCBjc3MuLicpO1xuICAgIGxvZ01lc3NhZ2UodmVyYm9zZSwgYEZyYW1lIHVybDogJHt3aW5kb3cubG9jYXRpb24uaHJlZn1gKTtcblxuICAgIGFwcGx5U2NyaXB0cyhzZWxlY3RvcnNBbmRTY3JpcHRzLnNjcmlwdHMsIHZlcmJvc2UpO1xuICAgIGFwcGx5Q3NzKHNlbGVjdG9yc0FuZFNjcmlwdHMuY3NzSW5qZWN0LCB2ZXJib3NlKTtcbiAgICBhcHBseUV4dGVuZGVkQ3NzKHNlbGVjdG9yc0FuZFNjcmlwdHMuY3NzRXh0ZW5kZWQsIHZlcmJvc2UpO1xuXG4gICAgbG9nTWVzc2FnZSh2ZXJib3NlLCAnQXBwbHlpbmcgc2NyaXB0cyBhbmQgY3NzIC0gZG9uZScpO1xufTtcblxuY29uc3QgaW5pdCA9IGFzeW5jICgpID0+IHtcbiAgICBpZiAoZG9jdW1lbnQgaW5zdGFuY2VvZiBIVE1MRG9jdW1lbnQpIHtcbiAgICAgICAgaWYgKHdpbmRvdy5sb2NhdGlvbi5ocmVmICYmIHdpbmRvdy5sb2NhdGlvbi5ocmVmLmluZGV4T2YoJ2h0dHAnKSA9PT0gMCkge1xuICAgICAgICAgICAgY29uc3Qgc3RhcnRHZXR0aW5nU2NyaXB0cyA9IERhdGUubm93KCk7XG4gICAgICAgICAgICBsZXQgc2VsZWN0b3JzQW5kU2NyaXB0cztcbiAgICAgICAgICAgIHRyeSB7XG4gICAgICAgICAgICAgICAgc2VsZWN0b3JzQW5kU2NyaXB0cyA9IGF3YWl0IGdldFNlbGVjdG9yc0FuZFNjcmlwdHMoKTtcbiAgICAgICAgICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhlKTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgY29uc29sZS5sb2coYFRpbWUgdG8gZ2V0IHNlbGVjdG9ycyBhbmQgc2NyaXB0cyBmcm9tIG5hdGl2ZSBwYWdlIHRvIGNvbnRlbnQgc2NyaXB0OiAke0RhdGUubm93KCkgLSBzdGFydEdldHRpbmdTY3JpcHRzfSBtc2ApO1xuXG4gICAgICAgICAgICBpZiAoc2VsZWN0b3JzQW5kU2NyaXB0cykge1xuICAgICAgICAgICAgICAgIGFwcGx5QWR2YW5jZWRCbG9ja2luZ0RhdGEoc2VsZWN0b3JzQW5kU2NyaXB0cywgZmFsc2UpO1xuICAgICAgICAgICAgfVxuICAgICAgICB9XG4gICAgfVxufTtcblxuZXhwb3J0IGNvbnN0IGNvbnRlbnQgPSB7XG4gICAgaW5pdCxcbn07XG4iLCIvKiEgZXh0ZW5kZWQtY3NzIC0gdjEuMy4xMiAtIE1vbiBNYXkgMzEgMjAyMVxuKiBodHRwczovL2dpdGh1Yi5jb20vQWRndWFyZFRlYW0vRXh0ZW5kZWRDc3NcbiogQ29weXJpZ2h0IChjKSAyMDIxIEFkR3VhcmQuIExpY2Vuc2VkIExHUEwtMy4wXG4qL1xuZnVuY3Rpb24gX3R5cGVvZihvYmopIHtcbiAgXCJAYmFiZWwvaGVscGVycyAtIHR5cGVvZlwiO1xuXG4gIGlmICh0eXBlb2YgU3ltYm9sID09PSBcImZ1bmN0aW9uXCIgJiYgdHlwZW9mIFN5bWJvbC5pdGVyYXRvciA9PT0gXCJzeW1ib2xcIikge1xuICAgIF90eXBlb2YgPSBmdW5jdGlvbiAob2JqKSB7XG4gICAgICByZXR1cm4gdHlwZW9mIG9iajtcbiAgICB9O1xuICB9IGVsc2Uge1xuICAgIF90eXBlb2YgPSBmdW5jdGlvbiAob2JqKSB7XG4gICAgICByZXR1cm4gb2JqICYmIHR5cGVvZiBTeW1ib2wgPT09IFwiZnVuY3Rpb25cIiAmJiBvYmouY29uc3RydWN0b3IgPT09IFN5bWJvbCAmJiBvYmogIT09IFN5bWJvbC5wcm90b3R5cGUgPyBcInN5bWJvbFwiIDogdHlwZW9mIG9iajtcbiAgICB9O1xuICB9XG5cbiAgcmV0dXJuIF90eXBlb2Yob2JqKTtcbn1cblxuZnVuY3Rpb24gX3NsaWNlZFRvQXJyYXkoYXJyLCBpKSB7XG4gIHJldHVybiBfYXJyYXlXaXRoSG9sZXMoYXJyKSB8fCBfaXRlcmFibGVUb0FycmF5TGltaXQoYXJyLCBpKSB8fCBfdW5zdXBwb3J0ZWRJdGVyYWJsZVRvQXJyYXkoYXJyLCBpKSB8fCBfbm9uSXRlcmFibGVSZXN0KCk7XG59XG5cbmZ1bmN0aW9uIF90b0NvbnN1bWFibGVBcnJheShhcnIpIHtcbiAgcmV0dXJuIF9hcnJheVdpdGhvdXRIb2xlcyhhcnIpIHx8IF9pdGVyYWJsZVRvQXJyYXkoYXJyKSB8fCBfdW5zdXBwb3J0ZWRJdGVyYWJsZVRvQXJyYXkoYXJyKSB8fCBfbm9uSXRlcmFibGVTcHJlYWQoKTtcbn1cblxuZnVuY3Rpb24gX2FycmF5V2l0aG91dEhvbGVzKGFycikge1xuICBpZiAoQXJyYXkuaXNBcnJheShhcnIpKSByZXR1cm4gX2FycmF5TGlrZVRvQXJyYXkoYXJyKTtcbn1cblxuZnVuY3Rpb24gX2FycmF5V2l0aEhvbGVzKGFycikge1xuICBpZiAoQXJyYXkuaXNBcnJheShhcnIpKSByZXR1cm4gYXJyO1xufVxuXG5mdW5jdGlvbiBfaXRlcmFibGVUb0FycmF5KGl0ZXIpIHtcbiAgaWYgKHR5cGVvZiBTeW1ib2wgIT09IFwidW5kZWZpbmVkXCIgJiYgU3ltYm9sLml0ZXJhdG9yIGluIE9iamVjdChpdGVyKSkgcmV0dXJuIEFycmF5LmZyb20oaXRlcik7XG59XG5cbmZ1bmN0aW9uIF9pdGVyYWJsZVRvQXJyYXlMaW1pdChhcnIsIGkpIHtcbiAgaWYgKHR5cGVvZiBTeW1ib2wgPT09IFwidW5kZWZpbmVkXCIgfHwgIShTeW1ib2wuaXRlcmF0b3IgaW4gT2JqZWN0KGFycikpKSByZXR1cm47XG4gIHZhciBfYXJyID0gW107XG4gIHZhciBfbiA9IHRydWU7XG4gIHZhciBfZCA9IGZhbHNlO1xuICB2YXIgX2UgPSB1bmRlZmluZWQ7XG5cbiAgdHJ5IHtcbiAgICBmb3IgKHZhciBfaSA9IGFycltTeW1ib2wuaXRlcmF0b3JdKCksIF9zOyAhKF9uID0gKF9zID0gX2kubmV4dCgpKS5kb25lKTsgX24gPSB0cnVlKSB7XG4gICAgICBfYXJyLnB1c2goX3MudmFsdWUpO1xuXG4gICAgICBpZiAoaSAmJiBfYXJyLmxlbmd0aCA9PT0gaSkgYnJlYWs7XG4gICAgfVxuICB9IGNhdGNoIChlcnIpIHtcbiAgICBfZCA9IHRydWU7XG4gICAgX2UgPSBlcnI7XG4gIH0gZmluYWxseSB7XG4gICAgdHJ5IHtcbiAgICAgIGlmICghX24gJiYgX2lbXCJyZXR1cm5cIl0gIT0gbnVsbCkgX2lbXCJyZXR1cm5cIl0oKTtcbiAgICB9IGZpbmFsbHkge1xuICAgICAgaWYgKF9kKSB0aHJvdyBfZTtcbiAgICB9XG4gIH1cblxuICByZXR1cm4gX2Fycjtcbn1cblxuZnVuY3Rpb24gX3Vuc3VwcG9ydGVkSXRlcmFibGVUb0FycmF5KG8sIG1pbkxlbikge1xuICBpZiAoIW8pIHJldHVybjtcbiAgaWYgKHR5cGVvZiBvID09PSBcInN0cmluZ1wiKSByZXR1cm4gX2FycmF5TGlrZVRvQXJyYXkobywgbWluTGVuKTtcbiAgdmFyIG4gPSBPYmplY3QucHJvdG90eXBlLnRvU3RyaW5nLmNhbGwobykuc2xpY2UoOCwgLTEpO1xuICBpZiAobiA9PT0gXCJPYmplY3RcIiAmJiBvLmNvbnN0cnVjdG9yKSBuID0gby5jb25zdHJ1Y3Rvci5uYW1lO1xuICBpZiAobiA9PT0gXCJNYXBcIiB8fCBuID09PSBcIlNldFwiKSByZXR1cm4gQXJyYXkuZnJvbShvKTtcbiAgaWYgKG4gPT09IFwiQXJndW1lbnRzXCIgfHwgL14oPzpVaXxJKW50KD86OHwxNnwzMikoPzpDbGFtcGVkKT9BcnJheSQvLnRlc3QobikpIHJldHVybiBfYXJyYXlMaWtlVG9BcnJheShvLCBtaW5MZW4pO1xufVxuXG5mdW5jdGlvbiBfYXJyYXlMaWtlVG9BcnJheShhcnIsIGxlbikge1xuICBpZiAobGVuID09IG51bGwgfHwgbGVuID4gYXJyLmxlbmd0aCkgbGVuID0gYXJyLmxlbmd0aDtcblxuICBmb3IgKHZhciBpID0gMCwgYXJyMiA9IG5ldyBBcnJheShsZW4pOyBpIDwgbGVuOyBpKyspIGFycjJbaV0gPSBhcnJbaV07XG5cbiAgcmV0dXJuIGFycjI7XG59XG5cbmZ1bmN0aW9uIF9ub25JdGVyYWJsZVNwcmVhZCgpIHtcbiAgdGhyb3cgbmV3IFR5cGVFcnJvcihcIkludmFsaWQgYXR0ZW1wdCB0byBzcHJlYWQgbm9uLWl0ZXJhYmxlIGluc3RhbmNlLlxcbkluIG9yZGVyIHRvIGJlIGl0ZXJhYmxlLCBub24tYXJyYXkgb2JqZWN0cyBtdXN0IGhhdmUgYSBbU3ltYm9sLml0ZXJhdG9yXSgpIG1ldGhvZC5cIik7XG59XG5cbmZ1bmN0aW9uIF9ub25JdGVyYWJsZVJlc3QoKSB7XG4gIHRocm93IG5ldyBUeXBlRXJyb3IoXCJJbnZhbGlkIGF0dGVtcHQgdG8gZGVzdHJ1Y3R1cmUgbm9uLWl0ZXJhYmxlIGluc3RhbmNlLlxcbkluIG9yZGVyIHRvIGJlIGl0ZXJhYmxlLCBub24tYXJyYXkgb2JqZWN0cyBtdXN0IGhhdmUgYSBbU3ltYm9sLml0ZXJhdG9yXSgpIG1ldGhvZC5cIik7XG59XG5cbi8qKlxuICogQ29weXJpZ2h0IDIwMTYgQWRndWFyZCBTb2Z0d2FyZSBMdGRcbiAqXG4gKiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2Vuc2UsIFZlcnNpb24gMi4wICh0aGUgXCJMaWNlbnNlXCIpO1xuICogeW91IG1heSBub3QgdXNlIHRoaXMgZmlsZSBleGNlcHQgaW4gY29tcGxpYW5jZSB3aXRoIHRoZSBMaWNlbnNlLlxuICogWW91IG1heSBvYnRhaW4gYSBjb3B5IG9mIHRoZSBMaWNlbnNlIGF0XG4gKlxuICogaHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wXG4gKlxuICogVW5sZXNzIHJlcXVpcmVkIGJ5IGFwcGxpY2FibGUgbGF3IG9yIGFncmVlZCB0byBpbiB3cml0aW5nLCBzb2Z0d2FyZVxuICogZGlzdHJpYnV0ZWQgdW5kZXIgdGhlIExpY2Vuc2UgaXMgZGlzdHJpYnV0ZWQgb24gYW4gXCJBUyBJU1wiIEJBU0lTLFxuICogV0lUSE9VVCBXQVJSQU5USUVTIE9SIENPTkRJVElPTlMgT0YgQU5ZIEtJTkQsIGVpdGhlciBleHByZXNzIG9yIGltcGxpZWQuXG4gKiBTZWUgdGhlIExpY2Vuc2UgZm9yIHRoZSBzcGVjaWZpYyBsYW5ndWFnZSBnb3Zlcm5pbmcgcGVybWlzc2lvbnMgYW5kXG4gKiBsaW1pdGF0aW9ucyB1bmRlciB0aGUgTGljZW5zZS5cbiAqL1xuXG4vKiBlc2xpbnQtZGlzYWJsZSBuby1jb25zb2xlICovXG52YXIgdXRpbHMgPSB7fTtcbnV0aWxzLk11dGF0aW9uT2JzZXJ2ZXIgPSB3aW5kb3cuTXV0YXRpb25PYnNlcnZlciB8fCB3aW5kb3cuV2ViS2l0TXV0YXRpb25PYnNlcnZlcjtcbi8qKlxuICogU3RvcmVzIG5hdGl2ZSBOb2RlIHRleHRDb250ZW50IGdldHRlciB0byBiZSB1c2VkIGZvciBjb250YWlucyBwc2V1ZG8tY2xhc3NcbiAqIGJlY2F1c2UgZWxlbWVudHMnICd0ZXh0Q29udGVudCcgYW5kICdpbm5lclRleHQnIHByb3BlcnRpZXMgbWlnaHQgYmUgbW9ja2VkXG4gKiBodHRwczovL2dpdGh1Yi5jb20vQWRndWFyZFRlYW0vRXh0ZW5kZWRDc3MvaXNzdWVzLzEyN1xuICovXG5cbnV0aWxzLm5vZGVUZXh0Q29udGVudEdldHRlciA9IGZ1bmN0aW9uICgpIHtcbiAgdmFyIG5hdGl2ZU5vZGUgPSB3aW5kb3cuTm9kZSB8fCBOb2RlO1xuICByZXR1cm4gT2JqZWN0LmdldE93blByb3BlcnR5RGVzY3JpcHRvcihuYXRpdmVOb2RlLnByb3RvdHlwZSwgJ3RleHRDb250ZW50JykuZ2V0O1xufSgpO1xuXG51dGlscy5pc1NhZmFyaUJyb3dzZXIgPSBmdW5jdGlvbiAoKSB7XG4gIHZhciBpc0Nocm9tZSA9IG5hdmlnYXRvci51c2VyQWdlbnQuaW5kZXhPZignQ2hyb21lJykgPiAtMTtcbiAgdmFyIGlzU2FmYXJpID0gbmF2aWdhdG9yLnVzZXJBZ2VudC5pbmRleE9mKCdTYWZhcmknKSA+IC0xO1xuXG4gIGlmIChpc1NhZmFyaSkge1xuICAgIGlmIChpc0Nocm9tZSkge1xuICAgICAgLy8gQ2hyb21lIHNlZW1zIHRvIGhhdmUgYm90aCBDaHJvbWUgYW5kIFNhZmFyaSB1c2VyQWdlbnRzXG4gICAgICByZXR1cm4gZmFsc2U7XG4gICAgfVxuXG4gICAgcmV0dXJuIHRydWU7XG4gIH1cblxuICByZXR1cm4gZmFsc2U7XG59KCk7XG4vKipcbiAqIENvbnZlcnRzIHJlZ3VsYXIgZXhwcmVzc2lvbnMgcGFzc2VkIGFzIHBzZXVkbyBjbGFzcyBhcmd1bWVudHMgaW50byBSZWdFeHAgaW5zdGFuY2VzLlxuICogSGF2ZSB0byB1bmVzY2FwZSBkb3VibGVxdW90ZSBcIiBhcyB3ZWxsLCBiZWNhdXNlIHdlIGVzY2FwZSB0aGVtIHdoaWxlIGVuY2xvc2luZyBzdWNoXG4gKiBhcmd1bWVudHMgd2l0aCBkb3VibGVxdW90ZXMsIGFuZCBzaXp6bGUgZG9lcyBub3QgYXV0b21hdGljYWxseSB1bmVzY2FwZXMgdGhlbS5cbiAqL1xuXG5cbnV0aWxzLnBzZXVkb0FyZ1RvUmVnZXggPSBmdW5jdGlvbiAocmVnZXhTcmMsIGZsYWcpIHtcbiAgZmxhZyA9IGZsYWcgfHwgJ2knO1xuICByZWdleFNyYyA9IHJlZ2V4U3JjLnRyaW0oKS5yZXBsYWNlKC9cXFxcKFtcIlxcXFxdKS9nLCAnJDEnKTtcbiAgcmV0dXJuIG5ldyBSZWdFeHAocmVnZXhTcmMsIGZsYWcpO1xufTtcbi8qKlxuICogQ29udmVydHMgc3RyaW5nIHRvIHRoZSByZWdleHBcbiAqIEBwYXJhbSB7c3RyaW5nfSBzdHJcbiAqIEByZXR1cm5zIHtSZWdFeHB9XG4gKi9cblxuXG51dGlscy50b1JlZ0V4cCA9IGZ1bmN0aW9uIChzdHIpIHtcbiAgaWYgKHN0clswXSA9PT0gJy8nICYmIHN0cltzdHIubGVuZ3RoIC0gMV0gPT09ICcvJykge1xuICAgIHJldHVybiBuZXcgUmVnRXhwKHN0ci5zbGljZSgxLCAtMSkpO1xuICB9XG5cbiAgdmFyIGVzY2FwZWQgPSBzdHIucmVwbGFjZSgvWy4qKz9eJHt9KCl8W1xcXVxcXFxdL2csICdcXFxcJCYnKTtcbiAgcmV0dXJuIG5ldyBSZWdFeHAoZXNjYXBlZCk7XG59O1xuXG51dGlscy5zdGFydHNXaXRoID0gZnVuY3Rpb24gKHN0ciwgcHJlZml4KSB7XG4gIC8vIGlmIHN0ciA9PT0gJycsIChzdHIgJiYgZmFsc2UpIHdpbGwgcmV0dXJuICcnXG4gIC8vIHRoYXQncyB3aHkgaXQgaGFzIHRvIGJlICEhc3RyXG4gIHJldHVybiAhIXN0ciAmJiBzdHIuaW5kZXhPZihwcmVmaXgpID09PSAwO1xufTtcblxudXRpbHMuZW5kc1dpdGggPSBmdW5jdGlvbiAoc3RyLCBwb3N0Zml4KSB7XG4gIGlmICghc3RyIHx8ICFwb3N0Zml4KSB7XG4gICAgcmV0dXJuIGZhbHNlO1xuICB9XG5cbiAgaWYgKHN0ci5lbmRzV2l0aCkge1xuICAgIHJldHVybiBzdHIuZW5kc1dpdGgocG9zdGZpeCk7XG4gIH1cblxuICB2YXIgdCA9IFN0cmluZyhwb3N0Zml4KTtcbiAgdmFyIGluZGV4ID0gc3RyLmxhc3RJbmRleE9mKHQpO1xuICByZXR1cm4gaW5kZXggPj0gMCAmJiBpbmRleCA9PT0gc3RyLmxlbmd0aCAtIHQubGVuZ3RoO1xufTtcbi8qKlxuICogSGVscGVyIGZ1bmN0aW9uIGZvciBjcmVhdGluZyByZWd1bGFyIGV4cHJlc3Npb24gZnJvbSBhIHVybCBmaWx0ZXIgcnVsZSBzeW50YXguXG4gKi9cblxuXG51dGlscy5jcmVhdGVVUkxSZWdleCA9IGZ1bmN0aW9uICgpIHtcbiAgLy8gQ29uc3RhbnRzXG4gIHZhciByZWdleENvbmZpZ3VyYXRpb24gPSB7XG4gICAgbWFza1N0YXJ0VXJsOiAnfHwnLFxuICAgIG1hc2tQaXBlOiAnfCcsXG4gICAgbWFza1NlcGFyYXRvcjogJ14nLFxuICAgIG1hc2tBbnlTeW1ib2w6ICcqJyxcbiAgICByZWdleEFueVN5bWJvbDogJy4qJyxcbiAgICByZWdleFNlcGFyYXRvcjogJyhbXiBhLXpBLVowLTkuJV8tXXwkKScsXG4gICAgcmVnZXhTdGFydFVybDogJ14oaHR0cHxodHRwc3x3c3x3c3MpOi8vKFthLXowLTktXy5dK1xcXFwuKT8nLFxuICAgIHJlZ2V4U3RhcnRTdHJpbmc6ICdeJyxcbiAgICByZWdleEVuZFN0cmluZzogJyQnXG4gIH07IC8vIGh0dHBzOi8vZGV2ZWxvcGVyLm1vemlsbGEub3JnL2VuL0phdmFTY3JpcHQvUmVmZXJlbmNlL0dsb2JhbF9PYmplY3RzL3JlZ2V4cFxuICAvLyBzaG91bGQgYmUgZXNjYXBlZCAuICogKyA/IF4gJCB7IH0gKCApIHwgWyBdIC8gXFxcbiAgLy8gZXhjZXB0IG9mICogfCBeXG5cbiAgdmFyIHNwZWNpYWxzID0gWycuJywgJysnLCAnPycsICckJywgJ3snLCAnfScsICcoJywgJyknLCAnWycsICddJywgJ1xcXFwnLCAnLyddO1xuICB2YXIgc3BlY2lhbHNSZWdleCA9IG5ldyBSZWdFeHAoXCJbXCIuY29uY2F0KHNwZWNpYWxzLmpvaW4oJ1xcXFwnKSwgXCJdXCIpLCAnZycpO1xuICAvKipcbiAgICogRXNjYXBlcyByZWd1bGFyIGV4cHJlc3Npb24gc3RyaW5nXG4gICAqL1xuXG4gIHZhciBlc2NhcGVSZWdFeHAgPSBmdW5jdGlvbiBlc2NhcGVSZWdFeHAoc3RyKSB7XG4gICAgcmV0dXJuIHN0ci5yZXBsYWNlKHNwZWNpYWxzUmVnZXgsICdcXFxcJCYnKTtcbiAgfTtcblxuICB2YXIgcmVwbGFjZUFsbCA9IGZ1bmN0aW9uIHJlcGxhY2VBbGwoc3RyLCBmaW5kLCByZXBsYWNlKSB7XG4gICAgaWYgKCFzdHIpIHtcbiAgICAgIHJldHVybiBzdHI7XG4gICAgfVxuXG4gICAgcmV0dXJuIHN0ci5zcGxpdChmaW5kKS5qb2luKHJlcGxhY2UpO1xuICB9O1xuICAvKipcbiAgICogTWFpbiBmdW5jdGlvbiB0aGF0IGNvbnZlcnRzIGEgdXJsIGZpbHRlciBydWxlIHN0cmluZyB0byBhIHJlZ2V4LlxuICAgKiBAcGFyYW0ge3N0cmluZ30gc3RyXG4gICAqIEByZXR1cm4ge1JlZ0V4cH1cbiAgICovXG5cblxuICB2YXIgY3JlYXRlUmVnZXhUZXh0ID0gZnVuY3Rpb24gY3JlYXRlUmVnZXhUZXh0KHN0cikge1xuICAgIHZhciByZWdleCA9IGVzY2FwZVJlZ0V4cChzdHIpO1xuXG4gICAgaWYgKHV0aWxzLnN0YXJ0c1dpdGgocmVnZXgsIHJlZ2V4Q29uZmlndXJhdGlvbi5tYXNrU3RhcnRVcmwpKSB7XG4gICAgICByZWdleCA9IHJlZ2V4LnN1YnN0cmluZygwLCByZWdleENvbmZpZ3VyYXRpb24ubWFza1N0YXJ0VXJsLmxlbmd0aCkgKyByZXBsYWNlQWxsKHJlZ2V4LnN1YnN0cmluZyhyZWdleENvbmZpZ3VyYXRpb24ubWFza1N0YXJ0VXJsLmxlbmd0aCwgcmVnZXgubGVuZ3RoIC0gMSksICdcXHwnLCAnXFxcXHwnKSArIHJlZ2V4LnN1YnN0cmluZyhyZWdleC5sZW5ndGggLSAxKTtcbiAgICB9IGVsc2UgaWYgKHV0aWxzLnN0YXJ0c1dpdGgocmVnZXgsIHJlZ2V4Q29uZmlndXJhdGlvbi5tYXNrUGlwZSkpIHtcbiAgICAgIHJlZ2V4ID0gcmVnZXguc3Vic3RyaW5nKDAsIHJlZ2V4Q29uZmlndXJhdGlvbi5tYXNrUGlwZS5sZW5ndGgpICsgcmVwbGFjZUFsbChyZWdleC5zdWJzdHJpbmcocmVnZXhDb25maWd1cmF0aW9uLm1hc2tQaXBlLmxlbmd0aCwgcmVnZXgubGVuZ3RoIC0gMSksICdcXHwnLCAnXFxcXHwnKSArIHJlZ2V4LnN1YnN0cmluZyhyZWdleC5sZW5ndGggLSAxKTtcbiAgICB9IGVsc2Uge1xuICAgICAgcmVnZXggPSByZXBsYWNlQWxsKHJlZ2V4LnN1YnN0cmluZygwLCByZWdleC5sZW5ndGggLSAxKSwgJ1xcfCcsICdcXFxcfCcpICsgcmVnZXguc3Vic3RyaW5nKHJlZ2V4Lmxlbmd0aCAtIDEpO1xuICAgIH0gLy8gUmVwbGFjaW5nIHNwZWNpYWwgdXJsIG1hc2tzXG5cblxuICAgIHJlZ2V4ID0gcmVwbGFjZUFsbChyZWdleCwgcmVnZXhDb25maWd1cmF0aW9uLm1hc2tBbnlTeW1ib2wsIHJlZ2V4Q29uZmlndXJhdGlvbi5yZWdleEFueVN5bWJvbCk7XG4gICAgcmVnZXggPSByZXBsYWNlQWxsKHJlZ2V4LCByZWdleENvbmZpZ3VyYXRpb24ubWFza1NlcGFyYXRvciwgcmVnZXhDb25maWd1cmF0aW9uLnJlZ2V4U2VwYXJhdG9yKTtcblxuICAgIGlmICh1dGlscy5zdGFydHNXaXRoKHJlZ2V4LCByZWdleENvbmZpZ3VyYXRpb24ubWFza1N0YXJ0VXJsKSkge1xuICAgICAgcmVnZXggPSByZWdleENvbmZpZ3VyYXRpb24ucmVnZXhTdGFydFVybCArIHJlZ2V4LnN1YnN0cmluZyhyZWdleENvbmZpZ3VyYXRpb24ubWFza1N0YXJ0VXJsLmxlbmd0aCk7XG4gICAgfSBlbHNlIGlmICh1dGlscy5zdGFydHNXaXRoKHJlZ2V4LCByZWdleENvbmZpZ3VyYXRpb24ubWFza1BpcGUpKSB7XG4gICAgICByZWdleCA9IHJlZ2V4Q29uZmlndXJhdGlvbi5yZWdleFN0YXJ0U3RyaW5nICsgcmVnZXguc3Vic3RyaW5nKHJlZ2V4Q29uZmlndXJhdGlvbi5tYXNrUGlwZS5sZW5ndGgpO1xuICAgIH1cblxuICAgIGlmICh1dGlscy5lbmRzV2l0aChyZWdleCwgcmVnZXhDb25maWd1cmF0aW9uLm1hc2tQaXBlKSkge1xuICAgICAgcmVnZXggPSByZWdleC5zdWJzdHJpbmcoMCwgcmVnZXgubGVuZ3RoIC0gMSkgKyByZWdleENvbmZpZ3VyYXRpb24ucmVnZXhFbmRTdHJpbmc7XG4gICAgfVxuXG4gICAgcmV0dXJuIG5ldyBSZWdFeHAocmVnZXgsICdpJyk7XG4gIH07XG5cbiAgcmV0dXJuIGNyZWF0ZVJlZ2V4VGV4dDtcbn0oKTtcbi8qKlxuICogQ3JlYXRlcyBhbiBvYmplY3QgaW1wbGVtZW50aW5nIExvY2F0aW9uIGludGVyZmFjZSBmcm9tIGEgdXJsLlxuICogQW4gYWx0ZXJuYXRpdmUgdG8gVVJMLlxuICogaHR0cHM6Ly9naXRodWIuY29tL0FkZ3VhcmRUZWFtL0ZpbmdlcnByaW50aW5nQmxvY2tlci9ibG9iL21hc3Rlci9zcmMvc2hhcmVkL3VybC50cyNMNjRcbiAqL1xuXG5cbnV0aWxzLmNyZWF0ZUxvY2F0aW9uID0gZnVuY3Rpb24gKGhyZWYpIHtcbiAgdmFyIGFuY2hvciA9IGRvY3VtZW50LmNyZWF0ZUVsZW1lbnQoJ2EnKTtcbiAgYW5jaG9yLmhyZWYgPSBocmVmO1xuXG4gIGlmIChhbmNob3IuaG9zdCA9PT0gJycpIHtcbiAgICBhbmNob3IuaHJlZiA9IGFuY2hvci5ocmVmOyAvLyBlc2xpbnQtZGlzYWJsZS1saW5lIG5vLXNlbGYtYXNzaWduXG4gIH1cblxuICByZXR1cm4gYW5jaG9yO1xufTtcbi8qKlxuICogQ2hlY2tzIHdoZXRoZXIgQSBoYXMgdGhlIHNhbWUgb3JpZ2luIGFzIEIuXG4gKiBAcGFyYW0ge3N0cmluZ30gdXJsQSBsb2NhdGlvbi5ocmVmIG9mIEEuXG4gKiBAcGFyYW0ge0xvY2F0aW9ufSBsb2NhdGlvbkIgbG9jYXRpb24gb2YgQi5cbiAqIEBwYXJhbSB7c3RyaW5nfSBkb21haW5CIGRvY3VtZW50LmRvbWFpbiBvZiBCLlxuICogQHJldHVybiB7Ym9vbGVhbn1cbiAqL1xuXG5cbnV0aWxzLmlzU2FtZU9yaWdpbiA9IGZ1bmN0aW9uICh1cmxBLCBsb2NhdGlvbkIsIGRvbWFpbkIpIHtcbiAgdmFyIGxvY2F0aW9uQSA9IHV0aWxzLmNyZWF0ZUxvY2F0aW9uKHVybEEpOyAvLyBlc2xpbnQtZGlzYWJsZS1uZXh0LWxpbmUgbm8tc2NyaXB0LXVybFxuXG4gIGlmIChsb2NhdGlvbkEucHJvdG9jb2wgPT09ICdqYXZhc2NyaXB0OicgfHwgbG9jYXRpb25BLmhyZWYgPT09ICdhYm91dDpibGFuaycpIHtcbiAgICByZXR1cm4gdHJ1ZTtcbiAgfVxuXG4gIGlmIChsb2NhdGlvbkEucHJvdG9jb2wgPT09ICdkYXRhOicgfHwgbG9jYXRpb25BLnByb3RvY29sID09PSAnZmlsZTonKSB7XG4gICAgcmV0dXJuIGZhbHNlO1xuICB9XG5cbiAgcmV0dXJuIGxvY2F0aW9uQS5ob3N0bmFtZSA9PT0gZG9tYWluQiAmJiBsb2NhdGlvbkEucG9ydCA9PT0gbG9jYXRpb25CLnBvcnQgJiYgbG9jYXRpb25BLnByb3RvY29sID09PSBsb2NhdGlvbkIucHJvdG9jb2w7XG59O1xuLyoqXG4gKiBBIGhlbHBlciBjbGFzcyB0byB0aHJvdHRsZSBmdW5jdGlvbiBjYWxscyB3aXRoIHNldFRpbWVvdXQgYW5kIHJlcXVlc3RBbmltYXRpb25GcmFtZS5cbiAqL1xuXG5cbnV0aWxzLkFzeW5jV3JhcHBlciA9IGZ1bmN0aW9uICgpIHtcbiAgLyoqXG4gICAqIFBoYW50b21KUyBwYXNzZXMgYSB3cm9uZyB0aW1lc3RhbXAgdG8gdGhlIHJlcXVlc3RBbmltYXRpb25GcmFtZSBjYWxsYmFjayBhbmQgdGhhdCBicmVha3MgdGhlIEFzeW5jV3JhcHBlciBsb2dpY1xuICAgKiBodHRwczovL2dpdGh1Yi5jb20vYXJpeWEvcGhhbnRvbWpzL2lzc3Vlcy8xNDgzMlxuICAgKi9cbiAgdmFyIHN1cHBvcnRlZCA9IHR5cGVvZiB3aW5kb3cucmVxdWVzdEFuaW1hdGlvbkZyYW1lICE9PSAndW5kZWZpbmVkJyAmJiAhL3BoYW50b20vaS50ZXN0KG5hdmlnYXRvci51c2VyQWdlbnQpO1xuICB2YXIgckFGID0gc3VwcG9ydGVkID8gcmVxdWVzdEFuaW1hdGlvbkZyYW1lIDogc2V0VGltZW91dDtcbiAgdmFyIGNBRiA9IHN1cHBvcnRlZCA/IGNhbmNlbEFuaW1hdGlvbkZyYW1lIDogY2xlYXJUaW1lb3V0O1xuICB2YXIgcGVyZiA9IHN1cHBvcnRlZCA/IHBlcmZvcm1hbmNlIDogRGF0ZTtcbiAgLyoqXG4gICAqIEBwYXJhbSB7RnVuY3Rpb259IGNhbGxiYWNrXG4gICAqIEBwYXJhbSB7bnVtYmVyfSB0aHJvdHRsZSBudW1iZXIsIHRoZSBwcm92aWRlZCBjYWxsYmFjayBzaG91bGQgYmUgZXhlY3V0ZWQgdHdpY2VcbiAgICogaW4gdGhpcyB0aW1lIGZyYW1lLlxuICAgKiBAY29uc3RydWN0b3JcbiAgICovXG5cbiAgZnVuY3Rpb24gQXN5bmNXcmFwcGVyKGNhbGxiYWNrLCB0aHJvdHRsZSkge1xuICAgIHRoaXMuY2FsbGJhY2sgPSBjYWxsYmFjaztcbiAgICB0aGlzLnRocm90dGxlID0gdGhyb3R0bGU7XG4gICAgdGhpcy53cmFwcGVkQ2FsbGJhY2sgPSB0aGlzLndyYXBwZWRDYWxsYmFjay5iaW5kKHRoaXMpO1xuXG4gICAgaWYgKHRoaXMud3JhcHBlZEFzYXBDYWxsYmFjaykge1xuICAgICAgdGhpcy53cmFwcGVkQXNhcENhbGxiYWNrID0gdGhpcy53cmFwcGVkQXNhcENhbGxiYWNrLmJpbmQodGhpcyk7XG4gICAgfVxuICB9XG4gIC8qKiBAcHJpdmF0ZSAqL1xuXG5cbiAgQXN5bmNXcmFwcGVyLnByb3RvdHlwZS53cmFwcGVkQ2FsbGJhY2sgPSBmdW5jdGlvbiAodHMpIHtcbiAgICB0aGlzLmxhc3RSdW4gPSBpc051bWJlcih0cykgPyB0cyA6IHBlcmYubm93KCk7XG4gICAgZGVsZXRlIHRoaXMuckFGaWQ7XG4gICAgZGVsZXRlIHRoaXMudGltZXJJZDtcbiAgICBkZWxldGUgdGhpcy5hc2FwU2NoZWR1bGVkO1xuICAgIHRoaXMuY2FsbGJhY2soKTtcbiAgfTtcbiAgLyoqIEBwcml2YXRlIEluZGljYXRlcyB3aGV0aGVyIHRoZXJlIGlzIGEgc2NoZWR1bGVkIGNhbGxiYWNrLiAqL1xuXG5cbiAgQXN5bmNXcmFwcGVyLnByb3RvdHlwZS5oYXNQZW5kaW5nQ2FsbGJhY2sgPSBmdW5jdGlvbiAoKSB7XG4gICAgcmV0dXJuIGlzTnVtYmVyKHRoaXMuckFGaWQpIHx8IGlzTnVtYmVyKHRoaXMudGltZXJJZCk7XG4gIH07XG4gIC8qKlxuICAgKiBTY2hlZHVsZXMgYSBmdW5jdGlvbiBjYWxsIGJlZm9yZSB0aGUgbmV4dCBhbmltYXRpb24gZnJhbWUuXG4gICAqL1xuXG5cbiAgQXN5bmNXcmFwcGVyLnByb3RvdHlwZS5ydW4gPSBmdW5jdGlvbiAoKSB7XG4gICAgaWYgKHRoaXMuaGFzUGVuZGluZ0NhbGxiYWNrKCkpIHtcbiAgICAgIC8vIFRoZXJlIGlzIGEgcGVuZGluZyBleGVjdXRpb24gc2NoZWR1bGVkLlxuICAgICAgcmV0dXJuO1xuICAgIH1cblxuICAgIGlmICh0eXBlb2YgdGhpcy5sYXN0UnVuICE9PSAndW5kZWZpbmVkJykge1xuICAgICAgdmFyIGVsYXBzZWQgPSBwZXJmLm5vdygpIC0gdGhpcy5sYXN0UnVuO1xuXG4gICAgICBpZiAoZWxhcHNlZCA8IHRoaXMudGhyb3R0bGUpIHtcbiAgICAgICAgdGhpcy50aW1lcklkID0gc2V0VGltZW91dCh0aGlzLndyYXBwZWRDYWxsYmFjaywgdGhpcy50aHJvdHRsZSAtIGVsYXBzZWQpO1xuICAgICAgICByZXR1cm47XG4gICAgICB9XG4gICAgfVxuXG4gICAgdGhpcy5yQUZpZCA9IHJBRih0aGlzLndyYXBwZWRDYWxsYmFjayk7XG4gIH07XG4gIC8qKlxuICAgKiBTY2hlZHVsZXMgYSBmdW5jdGlvbiBjYWxsIGluIHRoZSBtb3N0IGltbWVuZW50IG1pY3JvdGFzay5cbiAgICogVGhpcyBjYW5ub3QgYmUgY2FuY2VsZWQuXG4gICAqL1xuXG5cbiAgQXN5bmNXcmFwcGVyLnByb3RvdHlwZS5ydW5Bc2FwID0gZnVuY3Rpb24gKCkge1xuICAgIGlmICh0aGlzLmFzYXBTY2hlZHVsZWQpIHtcbiAgICAgIHJldHVybjtcbiAgICB9XG5cbiAgICB0aGlzLmFzYXBTY2hlZHVsZWQgPSB0cnVlO1xuICAgIGNBRih0aGlzLnJBRmlkKTtcbiAgICBjbGVhclRpbWVvdXQodGhpcy50aW1lcklkKTtcblxuICAgIGlmICh1dGlscy5NdXRhdGlvbk9ic2VydmVyKSB7XG4gICAgICAvKipcbiAgICAgICAqIFVzaW5nIE11dGF0aW9uT2JzZXJ2ZXJzIHRvIGFjY2VzcyBtaWNyb3Rhc2sgcXVldWUgaXMgYSBzdGFuZGFyZCB0ZWNobmlxdWUsXG4gICAgICAgKiB1c2VkIGluIEFTQVAgbGlicmFyeVxuICAgICAgICoge0BsaW5rIGh0dHBzOi8vZ2l0aHViLmNvbS9rcmlza293YWwvYXNhcC9ibG9iL21hc3Rlci9icm93c2VyLXJhdy5qcyNMMTQwfVxuICAgICAgICovXG4gICAgICBpZiAoIXRoaXMubW8pIHtcbiAgICAgICAgdGhpcy5tbyA9IG5ldyB1dGlscy5NdXRhdGlvbk9ic2VydmVyKHRoaXMud3JhcHBlZENhbGxiYWNrKTtcbiAgICAgICAgdGhpcy5ub2RlID0gZG9jdW1lbnQuY3JlYXRlVGV4dE5vZGUoMSk7XG4gICAgICAgIHRoaXMubW8ub2JzZXJ2ZSh0aGlzLm5vZGUsIHtcbiAgICAgICAgICBjaGFyYWN0ZXJEYXRhOiB0cnVlXG4gICAgICAgIH0pO1xuICAgICAgfVxuXG4gICAgICB0aGlzLm5vZGUubm9kZVZhbHVlID0gLXRoaXMubm9kZS5ub2RlVmFsdWU7XG4gICAgfSBlbHNlIHtcbiAgICAgIHNldFRpbWVvdXQodGhpcy53cmFwcGVkQ2FsbGJhY2spO1xuICAgIH1cbiAgfTtcbiAgLyoqXG4gICAqIFJ1bnMgc2NoZWR1bGVkIGV4ZWN1dGlvbiBpbW1lZGlhdGVseSwgaWYgdGhlcmUgd2VyZSBhbnkuXG4gICAqL1xuXG5cbiAgQXN5bmNXcmFwcGVyLnByb3RvdHlwZS5ydW5JbW1lZGlhdGVseSA9IGZ1bmN0aW9uICgpIHtcbiAgICBpZiAodGhpcy5oYXNQZW5kaW5nQ2FsbGJhY2soKSkge1xuICAgICAgY0FGKHRoaXMuckFGaWQpO1xuICAgICAgY2xlYXJUaW1lb3V0KHRoaXMudGltZXJJZCk7XG4gICAgICBkZWxldGUgdGhpcy5yQUZpZDtcbiAgICAgIGRlbGV0ZSB0aGlzLnRpbWVySWQ7XG4gICAgICB0aGlzLndyYXBwZWRDYWxsYmFjaygpO1xuICAgIH1cbiAgfTtcblxuICBBc3luY1dyYXBwZXIubm93ID0gZnVuY3Rpb24gKCkge1xuICAgIHJldHVybiBwZXJmLm5vdygpO1xuICB9O1xuXG4gIHJldHVybiBBc3luY1dyYXBwZXI7XG59KCk7XG4vKipcbiAqIFN0b3JlcyBuYXRpdmUgT2RQIHRvIGJlIHVzZWQgaW4gV2Vha01hcCBhbmQgU2V0IHBvbHlmaWxscy5cbiAqL1xuXG5cbnV0aWxzLmRlZmluZVByb3BlcnR5ID0gT2JqZWN0LmRlZmluZVByb3BlcnR5O1xudXRpbHMuV2Vha01hcCA9IHR5cGVvZiBXZWFrTWFwICE9PSAndW5kZWZpbmVkJyA/IFdlYWtNYXAgOiBmdW5jdGlvbiAoKSB7XG4gIC8qKiBPcmlnaW5hbGx5IGJhc2VkIG9uIHtAbGluayBodHRwczovL2dpdGh1Yi5jb20vUG9seW1lci9XZWFrTWFwfSAqL1xuICB2YXIgY291bnRlciA9IERhdGUubm93KCkgJSAxZTk7XG5cbiAgdmFyIFdlYWtNYXAgPSBmdW5jdGlvbiBXZWFrTWFwKCkge1xuICAgIHRoaXMubmFtZSA9IFwiX19zdFwiLmNvbmNhdChNYXRoLnJhbmRvbSgpICogMWU5ID4+PiAwKS5jb25jYXQoY291bnRlcisrLCBcIl9fXCIpO1xuICB9O1xuXG4gIFdlYWtNYXAucHJvdG90eXBlID0ge1xuICAgIHNldDogZnVuY3Rpb24gc2V0KGtleSwgdmFsdWUpIHtcbiAgICAgIHZhciBlbnRyeSA9IGtleVt0aGlzLm5hbWVdO1xuXG4gICAgICBpZiAoZW50cnkgJiYgZW50cnlbMF0gPT09IGtleSkge1xuICAgICAgICBlbnRyeVsxXSA9IHZhbHVlO1xuICAgICAgfSBlbHNlIHtcbiAgICAgICAgdXRpbHMuZGVmaW5lUHJvcGVydHkoa2V5LCB0aGlzLm5hbWUsIHtcbiAgICAgICAgICB2YWx1ZTogW2tleSwgdmFsdWVdLFxuICAgICAgICAgIHdyaXRhYmxlOiB0cnVlXG4gICAgICAgIH0pO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gdGhpcztcbiAgICB9LFxuICAgIGdldDogZnVuY3Rpb24gZ2V0KGtleSkge1xuICAgICAgdmFyIGVudHJ5ID0ga2V5W3RoaXMubmFtZV07XG4gICAgICByZXR1cm4gZW50cnkgJiYgZW50cnlbMF0gPT09IGtleSA/IGVudHJ5WzFdIDogdW5kZWZpbmVkO1xuICAgIH0sXG4gICAgZGVsZXRlOiBmdW5jdGlvbiBfZGVsZXRlKGtleSkge1xuICAgICAgdmFyIGVudHJ5ID0ga2V5W3RoaXMubmFtZV07XG5cbiAgICAgIGlmICghZW50cnkpIHtcbiAgICAgICAgcmV0dXJuIGZhbHNlO1xuICAgICAgfVxuXG4gICAgICB2YXIgaGFzVmFsdWUgPSBlbnRyeVswXSA9PT0ga2V5O1xuICAgICAgZGVsZXRlIGVudHJ5WzBdO1xuICAgICAgZGVsZXRlIGVudHJ5WzFdO1xuICAgICAgcmV0dXJuIGhhc1ZhbHVlO1xuICAgIH0sXG4gICAgaGFzOiBmdW5jdGlvbiBoYXMoa2V5KSB7XG4gICAgICB2YXIgZW50cnkgPSBrZXlbdGhpcy5uYW1lXTtcblxuICAgICAgaWYgKCFlbnRyeSkge1xuICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICB9XG5cbiAgICAgIHJldHVybiBlbnRyeVswXSA9PT0ga2V5O1xuICAgIH1cbiAgfTtcbiAgcmV0dXJuIFdlYWtNYXA7XG59KCk7XG51dGlscy5TZXQgPSB0eXBlb2YgU2V0ICE9PSAndW5kZWZpbmVkJyA/IFNldCA6IGZ1bmN0aW9uICgpIHtcbiAgdmFyIGNvdW50ZXIgPSBEYXRlLm5vdygpICUgMWU5O1xuICAvKipcbiAgICogQSBwb2x5ZmlsbCB3aGljaCBjb3ZlcnMgb25seSB0aGUgYmFzaWMgdXNhZ2UuXG4gICAqIE9ubHkgc3VwcG9ydHMgbWV0aG9kcyB0aGF0IGFyZSBzdXBwb3J0ZWQgaW4gSUUxMS5cbiAgICoge0BsaW5rIGh0dHBzOi8vZG9jcy5taWNyb3NvZnQuY29tL2VuLXVzL3NjcmlwdGluZy9qYXZhc2NyaXB0L3JlZmVyZW5jZS9zZXQtb2JqZWN0LWphdmFzY3JpcHR9XG4gICAqIEFzc3VtZXMgdGhhdCAna2V5J3MgYXJlIGFsbCBvYmplY3RzLCBub3QgcHJpbWl0aXZlcyBzdWNoIGFzIGEgbnVtYmVyLlxuICAgKlxuICAgKiBAcGFyYW0ge0FycmF5fSBpdGVtcyBJbml0aWFsIGl0ZW1zIGluIHRoaXMgc2V0XG4gICAqL1xuXG4gIHZhciBTZXQgPSBmdW5jdGlvbiBTZXQoaXRlbXMpIHtcbiAgICB0aGlzLm5hbWUgPSBcIl9fc3RcIi5jb25jYXQoTWF0aC5yYW5kb20oKSAqIDFlOSA+Pj4gMCkuY29uY2F0KGNvdW50ZXIrKywgXCJfX1wiKTtcbiAgICB0aGlzLmtleXMgPSBbXTtcblxuICAgIGlmIChpdGVtcyAmJiBpdGVtcy5sZW5ndGgpIHtcbiAgICAgIHZhciBpSXRlbXMgPSBpdGVtcy5sZW5ndGg7XG5cbiAgICAgIHdoaWxlIChpSXRlbXMtLSkge1xuICAgICAgICB0aGlzLmFkZChpdGVtc1tpSXRlbXNdKTtcbiAgICAgIH1cbiAgICB9XG4gIH07XG5cbiAgU2V0LnByb3RvdHlwZSA9IHtcbiAgICBhZGQ6IGZ1bmN0aW9uIGFkZChrZXkpIHtcbiAgICAgIGlmICghaXNOdW1iZXIoa2V5W3RoaXMubmFtZV0pKSB7XG4gICAgICAgIHZhciBpbmRleCA9IHRoaXMua2V5cy5wdXNoKGtleSkgLSAxO1xuICAgICAgICB1dGlscy5kZWZpbmVQcm9wZXJ0eShrZXksIHRoaXMubmFtZSwge1xuICAgICAgICAgIHZhbHVlOiBpbmRleCxcbiAgICAgICAgICB3cml0YWJsZTogdHJ1ZVxuICAgICAgICB9KTtcbiAgICAgIH1cbiAgICB9LFxuICAgIGRlbGV0ZTogZnVuY3Rpb24gX2RlbGV0ZShrZXkpIHtcbiAgICAgIGlmIChpc051bWJlcihrZXlbdGhpcy5uYW1lXSkpIHtcbiAgICAgICAgdmFyIGluZGV4ID0ga2V5W3RoaXMubmFtZV07XG4gICAgICAgIGRlbGV0ZSB0aGlzLmtleXNbaW5kZXhdO1xuICAgICAgICBrZXlbdGhpcy5uYW1lXSA9IHVuZGVmaW5lZDtcbiAgICAgIH1cbiAgICB9LFxuICAgIGhhczogZnVuY3Rpb24gaGFzKGtleSkge1xuICAgICAgcmV0dXJuIGlzTnVtYmVyKGtleVt0aGlzLm5hbWVdKTtcbiAgICB9LFxuICAgIGNsZWFyOiBmdW5jdGlvbiBjbGVhcigpIHtcbiAgICAgIHRoaXMua2V5cy5mb3JFYWNoKGZ1bmN0aW9uIChrZXkpIHtcbiAgICAgICAga2V5W3RoaXMubmFtZV0gPSB1bmRlZmluZWQ7XG4gICAgICB9KTtcbiAgICAgIHRoaXMua2V5cy5sZW5ndGggPSAwO1xuICAgIH0sXG4gICAgZm9yRWFjaDogZnVuY3Rpb24gZm9yRWFjaChjYikge1xuICAgICAgdmFyIHRoYXQgPSB0aGlzO1xuICAgICAgdGhpcy5rZXlzLmZvckVhY2goZnVuY3Rpb24gKHZhbHVlKSB7XG4gICAgICAgIGNiKHZhbHVlLCB2YWx1ZSwgdGhhdCk7XG4gICAgICB9KTtcbiAgICB9XG4gIH07XG4gIHV0aWxzLmRlZmluZVByb3BlcnR5KFNldC5wcm90b3R5cGUsICdzaXplJywge1xuICAgIGdldDogZnVuY3Rpb24gZ2V0KCkge1xuICAgICAgLy8gU2tpcHMgaG9sZXMuXG4gICAgICByZXR1cm4gdGhpcy5rZXlzLnJlZHVjZShmdW5jdGlvbiAoYWNjKSB7XG4gICAgICAgIHJldHVybiBhY2MgKyAxO1xuICAgICAgfSwgMCk7XG4gICAgfVxuICB9KTtcbiAgcmV0dXJuIFNldDtcbn0oKTtcbi8qKlxuICogVmVuZG9yLXNwZWNpZmljIEVsZW1lbnQucHJvdG90eXBlLm1hdGNoZXNcbiAqL1xuXG51dGlscy5tYXRjaGVzUHJvcGVydHlOYW1lID0gZnVuY3Rpb24gKCkge1xuICB2YXIgcHJvcHMgPSBbJ21hdGNoZXMnLCAnbWF0Y2hlc1NlbGVjdG9yJywgJ21vek1hdGNoZXNTZWxlY3RvcicsICdtc01hdGNoZXNTZWxlY3RvcicsICdvTWF0Y2hlc1NlbGVjdG9yJywgJ3dlYmtpdE1hdGNoZXNTZWxlY3RvciddO1xuXG4gIGZvciAodmFyIGkgPSAwOyBpIDwgNjsgaSsrKSB7XG4gICAgaWYgKEVsZW1lbnQucHJvdG90eXBlLmhhc093blByb3BlcnR5KHByb3BzW2ldKSkge1xuICAgICAgcmV0dXJuIHByb3BzW2ldO1xuICAgIH1cbiAgfVxufSgpO1xuLyoqXG4gKiBQcm92aWRlcyBzdGF0cyBpbmZvcm1hdGlvblxuICovXG5cblxudXRpbHMuU3RhdHMgPSBmdW5jdGlvbiAoKSB7XG4gIC8qKiBAbWVtYmVyIHtBcnJheTxudW1iZXI+fSAqL1xuICB0aGlzLmFycmF5ID0gW107XG4gIC8qKiBAbWVtYmVyIHtudW1iZXJ9ICovXG5cbiAgdGhpcy5sZW5ndGggPSAwO1xuICB2YXIgemVyb0Rlc2NyaXB0b3IgPSB7XG4gICAgdmFsdWU6IDAsXG4gICAgd3JpdGFibGU6IHRydWVcbiAgfTtcbiAgLyoqIEBtZW1iZXIge251bWJlcn0gQHByaXZhdGUgKi9cblxuICBPYmplY3QuZGVmaW5lUHJvcGVydHkodGhpcywgJ3N1bScsIHplcm9EZXNjcmlwdG9yKTtcbiAgLyoqIEBtZW1iZXIge251bWJlcn0gQHByaXZhdGUgKi9cblxuICBPYmplY3QuZGVmaW5lUHJvcGVydHkodGhpcywgJ3NxdWFyZWRTdW0nLCB6ZXJvRGVzY3JpcHRvcik7XG59O1xuLyoqXG4gKiBAcGFyYW0ge251bWJlcn0gZGF0YVBvaW50IGRhdGEgcG9pbnRcbiAqL1xuXG5cbnV0aWxzLlN0YXRzLnByb3RvdHlwZS5wdXNoID0gZnVuY3Rpb24gKGRhdGFQb2ludCkge1xuICB0aGlzLmFycmF5LnB1c2goZGF0YVBvaW50KTtcbiAgdGhpcy5sZW5ndGgrKztcbiAgdGhpcy5zdW0gKz0gZGF0YVBvaW50O1xuICB0aGlzLnNxdWFyZWRTdW0gKz0gZGF0YVBvaW50ICogZGF0YVBvaW50O1xuICAvKiogQG1lbWJlciB7bnVtYmVyfSAqL1xuXG4gIHRoaXMubWVhbiA9IHRoaXMuc3VtIC8gdGhpcy5sZW5ndGg7XG4gIC8qKiBAbWVtYmVyIHtudW1iZXJ9ICovXG4gIC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBuby1yZXN0cmljdGVkLXByb3BlcnRpZXNcblxuICB0aGlzLnN0ZGRldiA9IE1hdGguc3FydCh0aGlzLnNxdWFyZWRTdW0gLyB0aGlzLmxlbmd0aCAtIE1hdGgucG93KHRoaXMubWVhbiwgMikpO1xufTtcbi8qKiBTYWZlIGNvbnNvbGUuZXJyb3IgdmVyc2lvbiAqL1xuXG5cbnV0aWxzLmxvZ0Vycm9yID0gdHlwZW9mIGNvbnNvbGUgIT09ICd1bmRlZmluZWQnICYmIGNvbnNvbGUuZXJyb3IgJiYgRnVuY3Rpb24ucHJvdG90eXBlLmJpbmQgJiYgY29uc29sZS5lcnJvci5iaW5kID8gY29uc29sZS5lcnJvci5iaW5kKHdpbmRvdy5jb25zb2xlKSA6IGNvbnNvbGUuZXJyb3I7XG4vKiogU2FmZSBjb25zb2xlLmluZm8gdmVyc2lvbiAqL1xuXG51dGlscy5sb2dJbmZvID0gdHlwZW9mIGNvbnNvbGUgIT09ICd1bmRlZmluZWQnICYmIGNvbnNvbGUuaW5mbyAmJiBGdW5jdGlvbi5wcm90b3R5cGUuYmluZCAmJiBjb25zb2xlLmluZm8uYmluZCA/IGNvbnNvbGUuaW5mby5iaW5kKHdpbmRvdy5jb25zb2xlKSA6IGNvbnNvbGUuaW5mbztcblxuZnVuY3Rpb24gaXNOdW1iZXIob2JqKSB7XG4gIHJldHVybiB0eXBlb2Ygb2JqID09PSAnbnVtYmVyJztcbn1cbi8qKlxuICogUmV0dXJucyBwYXRoIHRvIGVsZW1lbnQgd2Ugd2lsbCB1c2UgYXMgZWxlbWVudCBpZGVudGlmaWVyXG4gKiBAcGFyYW0ge0VsZW1lbnR9IGlucHV0RWxcbiAqIEByZXR1cm5zIHtzdHJpbmd9IC0gcGF0aCB0byB0aGUgZWxlbWVudFxuICovXG5cblxudXRpbHMuZ2V0Tm9kZVNlbGVjdG9yID0gZnVuY3Rpb24gKGlucHV0RWwpIHtcbiAgaWYgKCEoaW5wdXRFbCBpbnN0YW5jZW9mIEVsZW1lbnQpKSB7XG4gICAgdGhyb3cgbmV3IEVycm9yKCdGdW5jdGlvbiByZWNlaXZlZCBhcmd1bWVudCB3aXRoIHdyb25nIHR5cGUnKTtcbiAgfVxuXG4gIHZhciBlbCA9IGlucHV0RWw7XG4gIHZhciBwYXRoID0gW107IC8vIHdlIG5lZWQgdG8gY2hlY2sgJyEhZWwnIGZpcnN0IGJlY2F1c2UgaXQgaXMgcG9zc2libGVcbiAgLy8gdGhhdCBzb21lIGFuY2VzdG9yIG9mIHRoZSBpbnB1dEVsIHdhcyByZW1vdmVkIGJlZm9yZSBpdFxuXG4gIHdoaWxlICghIWVsICYmIGVsLm5vZGVUeXBlID09PSBOb2RlLkVMRU1FTlRfTk9ERSkge1xuICAgIHZhciBzZWxlY3RvciA9IGVsLm5vZGVOYW1lLnRvTG93ZXJDYXNlKCk7XG5cbiAgICBpZiAoZWwuaWQgJiYgdHlwZW9mIGVsLmlkID09PSAnc3RyaW5nJykge1xuICAgICAgc2VsZWN0b3IgKz0gXCIjXCIuY29uY2F0KGVsLmlkKTtcbiAgICAgIHBhdGgudW5zaGlmdChzZWxlY3Rvcik7XG4gICAgICBicmVhaztcbiAgICB9IGVsc2Uge1xuICAgICAgdmFyIHNpYmxpbmcgPSBlbDtcbiAgICAgIHZhciBudGggPSAxO1xuXG4gICAgICB3aGlsZSAoc2libGluZy5wcmV2aW91c1NpYmxpbmcpIHtcbiAgICAgICAgc2libGluZyA9IHNpYmxpbmcucHJldmlvdXNTaWJsaW5nO1xuXG4gICAgICAgIGlmIChzaWJsaW5nLm5vZGVUeXBlID09PSBOb2RlLkVMRU1FTlRfTk9ERSAmJiBzaWJsaW5nLm5vZGVOYW1lLnRvTG93ZXJDYXNlKCkgPT09IHNlbGVjdG9yKSB7XG4gICAgICAgICAgbnRoKys7XG4gICAgICAgIH1cbiAgICAgIH1cblxuICAgICAgaWYgKG50aCAhPT0gMSkge1xuICAgICAgICBzZWxlY3RvciArPSBcIjpudGgtb2YtdHlwZShcIi5jb25jYXQobnRoLCBcIilcIik7XG4gICAgICB9XG4gICAgfVxuXG4gICAgcGF0aC51bnNoaWZ0KHNlbGVjdG9yKTtcbiAgICBlbCA9IGVsLnBhcmVudE5vZGU7XG4gIH1cblxuICByZXR1cm4gcGF0aC5qb2luKCcgPiAnKTtcbn07XG5cbi8qKlxuICogQ29weXJpZ2h0IDIwMTYgQWRndWFyZCBTb2Z0d2FyZSBMdGRcbiAqXG4gKiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2Vuc2UsIFZlcnNpb24gMi4wICh0aGUgXCJMaWNlbnNlXCIpO1xuICogeW91IG1heSBub3QgdXNlIHRoaXMgZmlsZSBleGNlcHQgaW4gY29tcGxpYW5jZSB3aXRoIHRoZSBMaWNlbnNlLlxuICogWW91IG1heSBvYnRhaW4gYSBjb3B5IG9mIHRoZSBMaWNlbnNlIGF0XG4gKlxuICogaHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wXG4gKlxuICogVW5sZXNzIHJlcXVpcmVkIGJ5IGFwcGxpY2FibGUgbGF3IG9yIGFncmVlZCB0byBpbiB3cml0aW5nLCBzb2Z0d2FyZVxuICogZGlzdHJpYnV0ZWQgdW5kZXIgdGhlIExpY2Vuc2UgaXMgZGlzdHJpYnV0ZWQgb24gYW4gXCJBUyBJU1wiIEJBU0lTLFxuICogV0lUSE9VVCBXQVJSQU5USUVTIE9SIENPTkRJVElPTlMgT0YgQU5ZIEtJTkQsIGVpdGhlciBleHByZXNzIG9yIGltcGxpZWQuXG4gKiBTZWUgdGhlIExpY2Vuc2UgZm9yIHRoZSBzcGVjaWZpYyBsYW5ndWFnZSBnb3Zlcm5pbmcgcGVybWlzc2lvbnMgYW5kXG4gKiBsaW1pdGF0aW9ucyB1bmRlciB0aGUgTGljZW5zZS5cbiAqL1xuXG4vKipcbiAqIEhlbHBlciBjbGFzcyBjc3MgdXRpbHNcbiAqXG4gKiBAdHlwZSB7e25vcm1hbGl6ZX19XG4gKi9cbnZhciBjc3NVdGlscyA9IGZ1bmN0aW9uICgpIHtcbiAgLyoqXG4gICAqIFJlZ2V4IHRoYXQgbWF0Y2hlcyBBZEd1YXJkJ3MgYmFja3dhcmQgY29tcGF0aWJsZSBzeW50YXhlcy5cbiAgICovXG4gIHZhciByZUF0dHJGYWxsYmFjayA9IC9cXFstKD86ZXh0fGFicCktKFthLXotX10rKT0oW1wiJ10pKCg/Oig/PShcXFxcPykpXFw0LikqPylcXDJcXF0vZztcbiAgLyoqXG4gICAqIENvbXBsZXggcmVwbGFjZW1lbnQgZnVuY3Rpb24uXG4gICAqIFVuZXNjYXBlcyBxdW90ZSBjaGFyYWN0ZXJzIGluc2lkZSBvZiBhbiBleHRlbmRlZCBzZWxlY3Rvci5cbiAgICpcbiAgICogQHBhcmFtIG1hdGNoICAgICBXaG9sZSBtYXRjaGVkIHN0cmluZ1xuICAgKiBAcGFyYW0gbmFtZSAgICAgIEdyb3VwIDFcbiAgICogQHBhcmFtIHF1b3RlQ2hhciBHcm91cCAyXG4gICAqIEBwYXJhbSB2YWx1ZSAgICAgR3JvdXAgM1xuICAgKi9cblxuICB2YXIgZXZhbHVhdGVNYXRjaCA9IGZ1bmN0aW9uIGV2YWx1YXRlTWF0Y2gobWF0Y2gsIG5hbWUsIHF1b3RlQ2hhciwgdmFsdWUpIHtcbiAgICAvLyBVbmVzY2FwZSBxdW90ZXNcbiAgICB2YXIgcmUgPSBuZXcgUmVnRXhwKFwiKFteXFxcXFxcXFxdfF4pXFxcXFxcXFxcIi5jb25jYXQocXVvdGVDaGFyKSwgJ2cnKTtcbiAgICB2YWx1ZSA9IHZhbHVlLnJlcGxhY2UocmUsIFwiJDFcIi5jb25jYXQocXVvdGVDaGFyKSk7XG4gICAgcmV0dXJuIFwiOlwiLmNvbmNhdChuYW1lLCBcIihcIikuY29uY2F0KHZhbHVlLCBcIilcIik7XG4gIH07IC8vIFNpenpsZSdzIHBhcnNpbmcgb2YgcHNldWRvIGNsYXNzIGFyZ3VtZW50cyBpcyBidWdneSBvbiBjZXJ0YWluIGNpcmN1bXN0YW5jZXNcbiAgLy8gV2Ugc3VwcG9ydCBmb2xsb3dpbmcgZm9ybSBvZiBhcmd1bWVudHM6XG4gIC8vIDEuIGZvciA6bWF0Y2hlcy1jc3MsIHRob3NlIG9mIGEgZm9ybSB7cHJvcGVydHlOYW1lfTogLy4qL1xuICAvLyAyLiBmb3IgOmNvbnRhaW5zLCB0aG9zZSBvZiBhIGZvcm0gLy4qL1xuICAvLyBXZSB0cmFuc2Zvcm0gc3VjaCBjYXNlcyBpbiBhIHdheSB0aGF0IFNpenpsZSBoYXMgbm8gYW1iaWd1aXR5IGluIHBhcnNpbmcgYXJndW1lbnRzLlxuXG5cbiAgdmFyIHJlTWF0Y2hlc0NzcyA9IC9cXDoobWF0Y2hlcy1jc3MoPzotYWZ0ZXJ8LWJlZm9yZSk/KVxcKChbYS16LVxcc10qXFw6XFxzKlxcLyg/OlxcXFwufFteXFwvXSkqP1xcL1xccyopXFwpL2c7XG4gIHZhciByZUNvbnRhaW5zID0gLzooPzotYWJwLSk/KGNvbnRhaW5zfGhhcy10ZXh0KVxcKChcXHMqXFwvKD86XFxcXC58W15cXC9dKSo/XFwvXFxzKilcXCkvZztcbiAgdmFyIHJlU2NvcGUgPSAvXFwoXFw6c2NvcGUgPi9nOyAvLyBOb3RlIHRoYXQgd2UgcmVxdWlyZSBgL2AgY2hhcmFjdGVyIGluIHJlZ3VsYXIgZXhwcmVzc2lvbnMgdG8gYmUgZXNjYXBlZC5cblxuICAvKipcbiAgICogVXNlZCBmb3IgcHJlLXByb2Nlc3NpbmcgcHNldWRvLWNsYXNzZXMgdmFsdWVzIHdpdGggYWJvdmUgdHdvIHJlZ2V4ZXMuXG4gICAqL1xuXG4gIHZhciBhZGRRdW90ZXMgPSBmdW5jdGlvbiBhZGRRdW90ZXMoXywgYzEsIGMyKSB7XG4gICAgcmV0dXJuIFwiOlwiLmNvbmNhdChjMSwgXCIoXFxcIlwiKS5jb25jYXQoYzIucmVwbGFjZSgvW1wiXFxcXF0vZywgJ1xcXFwkJicpLCBcIlxcXCIpXCIpO1xuICB9O1xuXG4gIHZhciBTQ09QRV9SRVBMQUNFUiA9ICcoPic7XG4gIC8qKlxuICAgKiBOb3JtYWxpemVzIHNwZWNpZmllZCBjc3MgdGV4dCBpbiBhIGZvcm0gdGhhdCBjYW4gYmUgcGFyc2VkIGJ5IHRoZVxuICAgKiBTaXp6bGUgZW5naW5lLlxuICAgKiBOb3JtYWxpemF0aW9uIG1lYW5zXG4gICAqICAxLiB0cmFuc2Zvcm1pbmcgWy1leHQtKj1cIlwiXSBhdHRyaWJ1dGVzIHRvIHBzZXVkbyBjbGFzc2VzXG4gICAqICAyLiBlbmNsb3NpbmcgcG9zc2libHkgYW1iaWd1b3VzIGFyZ3VtZW50cyBvZiBgOmNvbnRhaW5zYCxcbiAgICogICAgIGA6bWF0Y2hlcy1jc3NgIHBzZXVkbyBjbGFzc2VzIHdpdGggcXVvdGVzLlxuICAgKiBAcGFyYW0ge3N0cmluZ30gY3NzVGV4dFxuICAgKiBAcmV0dXJuIHtzdHJpbmd9XG4gICAqL1xuXG4gIHZhciBub3JtYWxpemUgPSBmdW5jdGlvbiBub3JtYWxpemUoY3NzVGV4dCkge1xuICAgIHZhciBub3JtYWxpemVkQ3NzVGV4dCA9IGNzc1RleHQucmVwbGFjZShyZUF0dHJGYWxsYmFjaywgZXZhbHVhdGVNYXRjaCkucmVwbGFjZShyZU1hdGNoZXNDc3MsIGFkZFF1b3RlcykucmVwbGFjZShyZUNvbnRhaW5zLCBhZGRRdW90ZXMpLnJlcGxhY2UocmVTY29wZSwgU0NPUEVfUkVQTEFDRVIpO1xuICAgIHJldHVybiBub3JtYWxpemVkQ3NzVGV4dDtcbiAgfTtcblxuICB2YXIgaXNTaW1wbGVTZWxlY3RvclZhbGlkID0gZnVuY3Rpb24gaXNTaW1wbGVTZWxlY3RvclZhbGlkKHNlbGVjdG9yKSB7XG4gICAgdHJ5IHtcbiAgICAgIGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3JBbGwoc2VsZWN0b3IpO1xuICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgIHJldHVybiBmYWxzZTtcbiAgICB9XG5cbiAgICByZXR1cm4gdHJ1ZTtcbiAgfTtcblxuICByZXR1cm4ge1xuICAgIG5vcm1hbGl6ZTogbm9ybWFsaXplLFxuICAgIGlzU2ltcGxlU2VsZWN0b3JWYWxpZDogaXNTaW1wbGVTZWxlY3RvclZhbGlkXG4gIH07XG59KCk7XG5cbi8qIVxuICogU2l6emxlIENTUyBTZWxlY3RvciBFbmdpbmUgdjIuMy40LXByZS1hZGd1YXJkXG4gKiBodHRwczovL3NpenpsZWpzLmNvbS9cbiAqXG4gKiBDb3B5cmlnaHQgSlMgRm91bmRhdGlvbiBhbmQgb3RoZXIgY29udHJpYnV0b3JzXG4gKiBSZWxlYXNlZCB1bmRlciB0aGUgTUlUIGxpY2Vuc2VcbiAqIGh0dHBzOi8vanMuZm91bmRhdGlvbi9cbiAqXG4gKiBEYXRlOiAyMDIwLTA4LTA0XG4gKi9cblxuLyoqXG4gKiBWZXJzaW9uIG9mIFNpenpsZSBwYXRjaGVkIGJ5IEFkR3VhcmQgaW4gb3JkZXIgdG8gYmUgdXNlZCBpbiB0aGUgRXh0ZW5kZWRDc3MgbW9kdWxlLlxuICogaHR0cHM6Ly9naXRodWIuY29tL0FkZ3VhcmRUZWFtL3NpenpsZS1leHRjc3NcbiAqXG4gKiBMb29rIGZvciBbQWRHdWFyZCBQYXRjaF0gYW5kIEFER1VBUkRfRVhUQ1NTIG1hcmtlcnMgdG8gZmluZCBvdXQgd2hhdCBleGFjdGx5IHdhcyBjaGFuZ2VkIGJ5IHVzLlxuICpcbiAqIEdsb2JhbCBjaGFuZ2VzOlxuICogMS4gQWRkZWQgYWRkaXRpb25hbCBwYXJhbWV0ZXJzIHRvIHRoZSBcIlNpenpsZS50b2tlbml6ZVwiIG1ldGhvZCBzbyB0aGF0IGl0IGNhbiBiZSB1c2VkIGZvciBzdHlsZXNoZWV0cyBwYXJzaW5nIGFuZCB2YWxpZGF0aW9uLlxuICogMi4gQWRkZWQgdG9rZW5zIHJlLXNvcnRpbmcgbWVjaGFuaXNtIGZvcmNpbmcgc2xvdyBwc2V1ZG9zIHRvIGJlIG1hdGNoZWQgbGFzdCAgKHNlZSBzb3J0VG9rZW5Hcm91cHMpLlxuICogMy4gRml4IHRoZSBub25uYXRpdmVTZWxlY3RvckNhY2hlIGNhY2hpbmcgLS0gdGhlcmUgd2FzIG5vIHZhbHVlIGNvcnJlc3BvbmRpbmcgdG8gYSBrZXkuXG4gKiA0LiBBZGRlZCBTaXp6bGUuY29tcGlsZSBjYWxsIHRvIHRoZSBgOmhhc2AgcHNldWRvIGRlZmluaXRpb24uXG4gKlxuICogQ2hhbmdlcyB0aGF0IGFyZSBhcHBsaWVkIHRvIHRoZSBBREdVQVJEX0VYVENTUyBidWlsZCBvbmx5OlxuICogMS4gRG8gbm90IGV4cG9zZSBTaXp6bGUgdG8gdGhlIGdsb2JhbCBzY29wZS4gSW5pdGlhbGl6ZSBpdCBsYXppbHkgdmlhIGluaXRpYWxpemVTaXp6bGUoKS5cbiAqIDIuIFJlbW92ZWQgOmNvbnRhaW5zIHBzZXVkbyBkZWNsYXJhdGlvbiAtLSBpdHMgc3ludGF4IGlzIGNoYW5nZWQgYW5kIGRlY2xhcmVkIG91dHNpZGUgb2YgU2l6emxlLlxuICogMy4gUmVtb3ZlZCBkZWNsYXJhdGlvbnMgZm9yIHRoZSBmb2xsb3dpbmcgbm9uLXN0YW5kYXJkIHBzZXVkbyBjbGFzc2VzOlxuICogOnBhcmVudCwgOmhlYWRlciwgOmlucHV0LCA6YnV0dG9uLCA6dGV4dCwgOmZpcnN0LCA6bGFzdCwgOmVxLFxuICogOmV2ZW4sIDpvZGQsIDpsdCwgOmd0LCA6bnRoLCA6cmFkaW8sIDpjaGVja2JveCwgOmZpbGUsXG4gKiA6cGFzc3dvcmQsIDppbWFnZSwgOnN1Ym1pdCwgOnJlc2V0XG4gKiA0LiBBZGRlZCBlczYgbW9kdWxlIGV4cG9ydFxuICovXG52YXIgU2l6emxlO1xuLyoqXG4gKiBJbml0aWFsaXplcyBTaXp6bGUgb2JqZWN0LlxuICogSW4gdGhlIGNhc2Ugb2YgQWRHdWFyZCBFeHRlbmRlZENzcyB3ZSB3YW50IHRvIGF2b2lkIGluaXRpYWxpemluZyBTaXp6bGUgcmlnaHQgYXdheVxuICogYW5kIGV4cG9zaW5nIGl0IHRvIHRoZSBnbG9iYWwgc2NvcGUuXG4gKi9cblxudmFyIGluaXRpYWxpemVTaXp6bGUgPSBmdW5jdGlvbiBpbml0aWFsaXplU2l6emxlKCkge1xuICAvLyBqc2hpbnQgaWdub3JlOmxpbmVcbiAgaWYgKCFTaXp6bGUpIHtcbiAgICAvLzw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PFxuICAgIFNpenpsZSA9IGZ1bmN0aW9uICh3aW5kb3cpIHtcbiAgICAgIHZhciBzdXBwb3J0LFxuICAgICAgICAgIEV4cHIsXG4gICAgICAgICAgZ2V0VGV4dCxcbiAgICAgICAgICBpc1hNTCxcbiAgICAgICAgICB0b2tlbml6ZSxcbiAgICAgICAgICBjb21waWxlLFxuICAgICAgICAgIHNlbGVjdCxcbiAgICAgICAgICBvdXRlcm1vc3RDb250ZXh0LFxuICAgICAgICAgIHNvcnRJbnB1dCxcbiAgICAgICAgICBoYXNEdXBsaWNhdGUsXG4gICAgICAgICAgLy8gTG9jYWwgZG9jdW1lbnQgdmFyc1xuICAgICAgc2V0RG9jdW1lbnQsXG4gICAgICAgICAgZG9jdW1lbnQsXG4gICAgICAgICAgZG9jRWxlbSxcbiAgICAgICAgICBkb2N1bWVudElzSFRNTCxcbiAgICAgICAgICByYnVnZ3lRU0EsXG4gICAgICAgICAgcmJ1Z2d5TWF0Y2hlcyxcbiAgICAgICAgICBtYXRjaGVzLFxuICAgICAgICAgIGNvbnRhaW5zLFxuICAgICAgICAgIC8vIEluc3RhbmNlLXNwZWNpZmljIGRhdGFcbiAgICAgIGV4cGFuZG8gPSBcInNpenpsZVwiICsgMSAqIG5ldyBEYXRlKCksXG4gICAgICAgICAgcHJlZmVycmVkRG9jID0gd2luZG93LmRvY3VtZW50LFxuICAgICAgICAgIGRpcnJ1bnMgPSAwLFxuICAgICAgICAgIGRvbmUgPSAwLFxuICAgICAgICAgIGNsYXNzQ2FjaGUgPSBjcmVhdGVDYWNoZSgpLFxuICAgICAgICAgIHRva2VuQ2FjaGUgPSBjcmVhdGVDYWNoZSgpLFxuICAgICAgICAgIGNvbXBpbGVyQ2FjaGUgPSBjcmVhdGVDYWNoZSgpLFxuICAgICAgICAgIG5vbm5hdGl2ZVNlbGVjdG9yQ2FjaGUgPSBjcmVhdGVDYWNoZSgpLFxuICAgICAgICAgIHNvcnRPcmRlciA9IGZ1bmN0aW9uIHNvcnRPcmRlcihhLCBiKSB7XG4gICAgICAgIGlmIChhID09PSBiKSB7XG4gICAgICAgICAgaGFzRHVwbGljYXRlID0gdHJ1ZTtcbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiAwO1xuICAgICAgfSxcbiAgICAgICAgICAvLyBJbnN0YW5jZSBtZXRob2RzXG4gICAgICBoYXNPd24gPSB7fS5oYXNPd25Qcm9wZXJ0eSxcbiAgICAgICAgICBhcnIgPSBbXSxcbiAgICAgICAgICBwb3AgPSBhcnIucG9wLFxuICAgICAgICAgIHB1c2hfbmF0aXZlID0gYXJyLnB1c2gsXG4gICAgICAgICAgcHVzaCA9IGFyci5wdXNoLFxuICAgICAgICAgIHNsaWNlID0gYXJyLnNsaWNlLFxuICAgICAgICAgIC8vIFVzZSBhIHN0cmlwcGVkLWRvd24gaW5kZXhPZiBhcyBpdCdzIGZhc3RlciB0aGFuIG5hdGl2ZVxuICAgICAgLy8gaHR0cHM6Ly9qc3BlcmYuY29tL3Rob3ItaW5kZXhvZi12cy1mb3IvNVxuICAgICAgaW5kZXhPZiA9IGZ1bmN0aW9uIGluZGV4T2YobGlzdCwgZWxlbSkge1xuICAgICAgICB2YXIgaSA9IDAsXG4gICAgICAgICAgICBsZW4gPSBsaXN0Lmxlbmd0aDtcblxuICAgICAgICBmb3IgKDsgaSA8IGxlbjsgaSsrKSB7XG4gICAgICAgICAgaWYgKGxpc3RbaV0gPT09IGVsZW0pIHtcbiAgICAgICAgICAgIHJldHVybiBpO1xuICAgICAgICAgIH1cbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiAtMTtcbiAgICAgIH0sXG4gICAgICAgICAgYm9vbGVhbnMgPSBcImNoZWNrZWR8c2VsZWN0ZWR8YXN5bmN8YXV0b2ZvY3VzfGF1dG9wbGF5fGNvbnRyb2xzfGRlZmVyfGRpc2FibGVkfGhpZGRlbnxpc21hcHxsb29wfG11bHRpcGxlfG9wZW58cmVhZG9ubHl8cmVxdWlyZWR8c2NvcGVkXCIsXG4gICAgICAgICAgLy8gUmVndWxhciBleHByZXNzaW9uc1xuICAgICAgLy8gaHR0cDovL3d3dy53My5vcmcvVFIvY3NzMy1zZWxlY3RvcnMvI3doaXRlc3BhY2VcbiAgICAgIHdoaXRlc3BhY2UgPSBcIltcXFxceDIwXFxcXHRcXFxcclxcXFxuXFxcXGZdXCIsXG4gICAgICAgICAgLy8gaHR0cDovL3d3dy53My5vcmcvVFIvQ1NTMjEvc3luZGF0YS5odG1sI3ZhbHVlLWRlZi1pZGVudGlmaWVyXG4gICAgICBpZGVudGlmaWVyID0gXCIoPzpcXFxcXFxcXC58W1xcXFx3LV18W15cXDAtXFxcXHhhMF0pK1wiLFxuICAgICAgICAgIC8vIEF0dHJpYnV0ZSBzZWxlY3RvcnM6IGh0dHA6Ly93d3cudzMub3JnL1RSL3NlbGVjdG9ycy8jYXR0cmlidXRlLXNlbGVjdG9yc1xuICAgICAgYXR0cmlidXRlcyA9IFwiXFxcXFtcIiArIHdoaXRlc3BhY2UgKyBcIiooXCIgKyBpZGVudGlmaWVyICsgXCIpKD86XCIgKyB3aGl0ZXNwYWNlICsgLy8gT3BlcmF0b3IgKGNhcHR1cmUgMilcbiAgICAgIFwiKihbKl4kfCF+XT89KVwiICsgd2hpdGVzcGFjZSArIC8vIFwiQXR0cmlidXRlIHZhbHVlcyBtdXN0IGJlIENTUyBpZGVudGlmaWVycyBbY2FwdHVyZSA1XSBvciBzdHJpbmdzIFtjYXB0dXJlIDMgb3IgY2FwdHVyZSA0XVwiXG4gICAgICBcIiooPzonKCg/OlxcXFxcXFxcLnxbXlxcXFxcXFxcJ10pKiknfFxcXCIoKD86XFxcXFxcXFwufFteXFxcXFxcXFxcXFwiXSkqKVxcXCJ8KFwiICsgaWRlbnRpZmllciArIFwiKSl8KVwiICsgd2hpdGVzcGFjZSArIFwiKlxcXFxdXCIsXG4gICAgICAgICAgcHNldWRvcyA9IFwiOihcIiArIGlkZW50aWZpZXIgKyBcIikoPzpcXFxcKChcIiArIC8vIFRvIHJlZHVjZSB0aGUgbnVtYmVyIG9mIHNlbGVjdG9ycyBuZWVkaW5nIHRva2VuaXplIGluIHRoZSBwcmVGaWx0ZXIsIHByZWZlciBhcmd1bWVudHM6XG4gICAgICAvLyAxLiBxdW90ZWQgKGNhcHR1cmUgMzsgY2FwdHVyZSA0IG9yIGNhcHR1cmUgNSlcbiAgICAgIFwiKCcoKD86XFxcXFxcXFwufFteXFxcXFxcXFwnXSkqKSd8XFxcIigoPzpcXFxcXFxcXC58W15cXFxcXFxcXFxcXCJdKSopXFxcIil8XCIgKyAvLyAyLiBzaW1wbGUgKGNhcHR1cmUgNilcbiAgICAgIFwiKCg/OlxcXFxcXFxcLnxbXlxcXFxcXFxcKClbXFxcXF1dfFwiICsgYXR0cmlidXRlcyArIFwiKSopfFwiICsgLy8gMy4gYW55dGhpbmcgZWxzZSAoY2FwdHVyZSAyKVxuICAgICAgXCIuKlwiICsgXCIpXFxcXCl8KVwiLFxuICAgICAgICAgIC8vIExlYWRpbmcgYW5kIG5vbi1lc2NhcGVkIHRyYWlsaW5nIHdoaXRlc3BhY2UsIGNhcHR1cmluZyBzb21lIG5vbi13aGl0ZXNwYWNlIGNoYXJhY3RlcnMgcHJlY2VkaW5nIHRoZSBsYXR0ZXJcbiAgICAgIHJ3aGl0ZXNwYWNlID0gbmV3IFJlZ0V4cCh3aGl0ZXNwYWNlICsgXCIrXCIsIFwiZ1wiKSxcbiAgICAgICAgICBydHJpbSA9IG5ldyBSZWdFeHAoXCJeXCIgKyB3aGl0ZXNwYWNlICsgXCIrfCgoPzpefFteXFxcXFxcXFxdKSg/OlxcXFxcXFxcLikqKVwiICsgd2hpdGVzcGFjZSArIFwiKyRcIiwgXCJnXCIpLFxuICAgICAgICAgIHJjb21tYSA9IG5ldyBSZWdFeHAoXCJeXCIgKyB3aGl0ZXNwYWNlICsgXCIqLFwiICsgd2hpdGVzcGFjZSArIFwiKlwiKSxcbiAgICAgICAgICByY29tYmluYXRvcnMgPSBuZXcgUmVnRXhwKFwiXlwiICsgd2hpdGVzcGFjZSArIFwiKihbPit+XXxcIiArIHdoaXRlc3BhY2UgKyBcIilcIiArIHdoaXRlc3BhY2UgKyBcIipcIiksXG4gICAgICAgICAgcnBzZXVkbyA9IG5ldyBSZWdFeHAocHNldWRvcyksXG4gICAgICAgICAgcmlkZW50aWZpZXIgPSBuZXcgUmVnRXhwKFwiXlwiICsgaWRlbnRpZmllciArIFwiJFwiKSxcbiAgICAgICAgICBtYXRjaEV4cHIgPSB7XG4gICAgICAgIFwiSURcIjogbmV3IFJlZ0V4cChcIl4jKFwiICsgaWRlbnRpZmllciArIFwiKVwiKSxcbiAgICAgICAgXCJDTEFTU1wiOiBuZXcgUmVnRXhwKFwiXlxcXFwuKFwiICsgaWRlbnRpZmllciArIFwiKVwiKSxcbiAgICAgICAgXCJUQUdcIjogbmV3IFJlZ0V4cChcIl4oXCIgKyBpZGVudGlmaWVyICsgXCJ8WypdKVwiKSxcbiAgICAgICAgXCJBVFRSXCI6IG5ldyBSZWdFeHAoXCJeXCIgKyBhdHRyaWJ1dGVzKSxcbiAgICAgICAgXCJQU0VVRE9cIjogbmV3IFJlZ0V4cChcIl5cIiArIHBzZXVkb3MpLFxuICAgICAgICBcIkNISUxEXCI6IG5ldyBSZWdFeHAoXCJeOihvbmx5fGZpcnN0fGxhc3R8bnRofG50aC1sYXN0KS0oY2hpbGR8b2YtdHlwZSkoPzpcXFxcKFwiICsgd2hpdGVzcGFjZSArIFwiKihldmVufG9kZHwoKFsrLV18KShcXFxcZCopbnwpXCIgKyB3aGl0ZXNwYWNlICsgXCIqKD86KFsrLV18KVwiICsgd2hpdGVzcGFjZSArIFwiKihcXFxcZCspfCkpXCIgKyB3aGl0ZXNwYWNlICsgXCIqXFxcXCl8KVwiLCBcImlcIiksXG4gICAgICAgIFwiYm9vbFwiOiBuZXcgUmVnRXhwKFwiXig/OlwiICsgYm9vbGVhbnMgKyBcIikkXCIsIFwiaVwiKSxcbiAgICAgICAgLy8gRm9yIHVzZSBpbiBsaWJyYXJpZXMgaW1wbGVtZW50aW5nIC5pcygpXG4gICAgICAgIC8vIFdlIHVzZSB0aGlzIGZvciBQT1MgbWF0Y2hpbmcgaW4gYHNlbGVjdGBcbiAgICAgICAgXCJuZWVkc0NvbnRleHRcIjogbmV3IFJlZ0V4cChcIl5cIiArIHdoaXRlc3BhY2UgKyBcIipbPit+XXw6KGV2ZW58b2RkfGVxfGd0fGx0fG50aHxmaXJzdHxsYXN0KSg/OlxcXFwoXCIgKyB3aGl0ZXNwYWNlICsgXCIqKCg/Oi1cXFxcZCk/XFxcXGQqKVwiICsgd2hpdGVzcGFjZSArIFwiKlxcXFwpfCkoPz1bXi1dfCQpXCIsIFwiaVwiKVxuICAgICAgfSxcbiAgICAgICAgICBybmF0aXZlID0gL15bXntdK1xce1xccypcXFtuYXRpdmUgXFx3LyxcbiAgICAgICAgICAvLyBFYXNpbHktcGFyc2VhYmxlL3JldHJpZXZhYmxlIElEIG9yIFRBRyBvciBDTEFTUyBzZWxlY3RvcnNcbiAgICAgIHJxdWlja0V4cHIgPSAvXig/OiMoW1xcdy1dKyl8KFxcdyspfFxcLihbXFx3LV0rKSkkLyxcbiAgICAgICAgICByc2libGluZyA9IC9bK35dLyxcbiAgICAgICAgICAvLyBDU1MgZXNjYXBlc1xuICAgICAgLy8gaHR0cDovL3d3dy53My5vcmcvVFIvQ1NTMjEvc3luZGF0YS5odG1sI2VzY2FwZWQtY2hhcmFjdGVyc1xuICAgICAgcnVuZXNjYXBlID0gbmV3IFJlZ0V4cChcIlxcXFxcXFxcKFtcXFxcZGEtZl17MSw2fVwiICsgd2hpdGVzcGFjZSArIFwiP3woXCIgKyB3aGl0ZXNwYWNlICsgXCIpfC4pXCIsIFwiaWdcIiksXG4gICAgICAgICAgZnVuZXNjYXBlID0gZnVuY3Rpb24gZnVuZXNjYXBlKF8sIGVzY2FwZWQsIGVzY2FwZWRXaGl0ZXNwYWNlKSB7XG4gICAgICAgIHZhciBoaWdoID0gXCIweFwiICsgZXNjYXBlZCAtIDB4MTAwMDA7IC8vIE5hTiBtZWFucyBub24tY29kZXBvaW50XG4gICAgICAgIC8vIFN1cHBvcnQ6IEZpcmVmb3g8MjRcbiAgICAgICAgLy8gV29ya2Fyb3VuZCBlcnJvbmVvdXMgbnVtZXJpYyBpbnRlcnByZXRhdGlvbiBvZiArXCIweFwiXG5cbiAgICAgICAgcmV0dXJuIGhpZ2ggIT09IGhpZ2ggfHwgZXNjYXBlZFdoaXRlc3BhY2UgPyBlc2NhcGVkIDogaGlnaCA8IDAgPyAvLyBCTVAgY29kZXBvaW50XG4gICAgICAgIFN0cmluZy5mcm9tQ2hhckNvZGUoaGlnaCArIDB4MTAwMDApIDogLy8gU3VwcGxlbWVudGFsIFBsYW5lIGNvZGVwb2ludCAoc3Vycm9nYXRlIHBhaXIpXG4gICAgICAgIFN0cmluZy5mcm9tQ2hhckNvZGUoaGlnaCA+PiAxMCB8IDB4RDgwMCwgaGlnaCAmIDB4M0ZGIHwgMHhEQzAwKTtcbiAgICAgIH0sXG4gICAgICAgICAgLy8gQ1NTIHN0cmluZy9pZGVudGlmaWVyIHNlcmlhbGl6YXRpb25cbiAgICAgIC8vIGh0dHBzOi8vZHJhZnRzLmNzc3dnLm9yZy9jc3NvbS8jY29tbW9uLXNlcmlhbGl6aW5nLWlkaW9tc1xuICAgICAgcmNzc2VzY2FwZSA9IC8oW1xcMC1cXHgxZlxceDdmXXxeLT9cXGQpfF4tJHxbXlxcMC1cXHgxZlxceDdmLVxcdUZGRkZcXHctXS9nLFxuICAgICAgICAgIGZjc3Nlc2NhcGUgPSBmdW5jdGlvbiBmY3NzZXNjYXBlKGNoLCBhc0NvZGVQb2ludCkge1xuICAgICAgICBpZiAoYXNDb2RlUG9pbnQpIHtcbiAgICAgICAgICAvLyBVKzAwMDAgTlVMTCBiZWNvbWVzIFUrRkZGRCBSRVBMQUNFTUVOVCBDSEFSQUNURVJcbiAgICAgICAgICBpZiAoY2ggPT09IFwiXFwwXCIpIHtcbiAgICAgICAgICAgIHJldHVybiBcIlxcdUZGRkRcIjtcbiAgICAgICAgICB9IC8vIENvbnRyb2wgY2hhcmFjdGVycyBhbmQgKGRlcGVuZGVudCB1cG9uIHBvc2l0aW9uKSBudW1iZXJzIGdldCBlc2NhcGVkIGFzIGNvZGUgcG9pbnRzXG5cblxuICAgICAgICAgIHJldHVybiBjaC5zbGljZSgwLCAtMSkgKyBcIlxcXFxcIiArIGNoLmNoYXJDb2RlQXQoY2gubGVuZ3RoIC0gMSkudG9TdHJpbmcoMTYpICsgXCIgXCI7XG4gICAgICAgIH0gLy8gT3RoZXIgcG90ZW50aWFsbHktc3BlY2lhbCBBU0NJSSBjaGFyYWN0ZXJzIGdldCBiYWNrc2xhc2gtZXNjYXBlZFxuXG5cbiAgICAgICAgcmV0dXJuIFwiXFxcXFwiICsgY2g7XG4gICAgICB9LFxuICAgICAgICAgIC8vIFVzZWQgZm9yIGlmcmFtZXNcbiAgICAgIC8vIFNlZSBzZXREb2N1bWVudCgpXG4gICAgICAvLyBSZW1vdmluZyB0aGUgZnVuY3Rpb24gd3JhcHBlciBjYXVzZXMgYSBcIlBlcm1pc3Npb24gRGVuaWVkXCJcbiAgICAgIC8vIGVycm9yIGluIElFXG4gICAgICB1bmxvYWRIYW5kbGVyID0gZnVuY3Rpb24gdW5sb2FkSGFuZGxlcigpIHtcbiAgICAgICAgc2V0RG9jdW1lbnQoKTtcbiAgICAgIH0sXG4gICAgICAgICAgaW5EaXNhYmxlZEZpZWxkc2V0ID0gYWRkQ29tYmluYXRvcihmdW5jdGlvbiAoZWxlbSkge1xuICAgICAgICByZXR1cm4gZWxlbS5kaXNhYmxlZCA9PT0gdHJ1ZSAmJiBlbGVtLm5vZGVOYW1lLnRvTG93ZXJDYXNlKCkgPT09IFwiZmllbGRzZXRcIjtcbiAgICAgIH0sIHtcbiAgICAgICAgZGlyOiBcInBhcmVudE5vZGVcIixcbiAgICAgICAgbmV4dDogXCJsZWdlbmRcIlxuICAgICAgfSk7IC8vIE9wdGltaXplIGZvciBwdXNoLmFwcGx5KCBfLCBOb2RlTGlzdCApXG5cblxuICAgICAgdHJ5IHtcbiAgICAgICAgcHVzaC5hcHBseShhcnIgPSBzbGljZS5jYWxsKHByZWZlcnJlZERvYy5jaGlsZE5vZGVzKSwgcHJlZmVycmVkRG9jLmNoaWxkTm9kZXMpOyAvLyBTdXBwb3J0OiBBbmRyb2lkPDQuMFxuICAgICAgICAvLyBEZXRlY3Qgc2lsZW50bHkgZmFpbGluZyBwdXNoLmFwcGx5XG5cbiAgICAgICAgYXJyW3ByZWZlcnJlZERvYy5jaGlsZE5vZGVzLmxlbmd0aF0ubm9kZVR5cGU7XG4gICAgICB9IGNhdGNoIChlKSB7XG4gICAgICAgIHB1c2ggPSB7XG4gICAgICAgICAgYXBwbHk6IGFyci5sZW5ndGggPyAvLyBMZXZlcmFnZSBzbGljZSBpZiBwb3NzaWJsZVxuICAgICAgICAgIGZ1bmN0aW9uICh0YXJnZXQsIGVscykge1xuICAgICAgICAgICAgcHVzaF9uYXRpdmUuYXBwbHkodGFyZ2V0LCBzbGljZS5jYWxsKGVscykpO1xuICAgICAgICAgIH0gOiAvLyBTdXBwb3J0OiBJRTw5XG4gICAgICAgICAgLy8gT3RoZXJ3aXNlIGFwcGVuZCBkaXJlY3RseVxuICAgICAgICAgIGZ1bmN0aW9uICh0YXJnZXQsIGVscykge1xuICAgICAgICAgICAgdmFyIGogPSB0YXJnZXQubGVuZ3RoLFxuICAgICAgICAgICAgICAgIGkgPSAwOyAvLyBDYW4ndCB0cnVzdCBOb2RlTGlzdC5sZW5ndGhcblxuICAgICAgICAgICAgd2hpbGUgKHRhcmdldFtqKytdID0gZWxzW2krK10pIHt9XG5cbiAgICAgICAgICAgIHRhcmdldC5sZW5ndGggPSBqIC0gMTtcbiAgICAgICAgICB9XG4gICAgICAgIH07XG4gICAgICB9XG5cbiAgICAgIGZ1bmN0aW9uIFNpenpsZShzZWxlY3RvciwgY29udGV4dCwgcmVzdWx0cywgc2VlZCkge1xuICAgICAgICB2YXIgbSxcbiAgICAgICAgICAgIGksXG4gICAgICAgICAgICBlbGVtLFxuICAgICAgICAgICAgbmlkLFxuICAgICAgICAgICAgbWF0Y2gsXG4gICAgICAgICAgICBncm91cHMsXG4gICAgICAgICAgICBuZXdTZWxlY3RvcixcbiAgICAgICAgICAgIG5ld0NvbnRleHQgPSBjb250ZXh0ICYmIGNvbnRleHQub3duZXJEb2N1bWVudCxcbiAgICAgICAgICAgIC8vIG5vZGVUeXBlIGRlZmF1bHRzIHRvIDksIHNpbmNlIGNvbnRleHQgZGVmYXVsdHMgdG8gZG9jdW1lbnRcbiAgICAgICAgbm9kZVR5cGUgPSBjb250ZXh0ID8gY29udGV4dC5ub2RlVHlwZSA6IDk7XG4gICAgICAgIHJlc3VsdHMgPSByZXN1bHRzIHx8IFtdOyAvLyBSZXR1cm4gZWFybHkgZnJvbSBjYWxscyB3aXRoIGludmFsaWQgc2VsZWN0b3Igb3IgY29udGV4dFxuXG4gICAgICAgIGlmICh0eXBlb2Ygc2VsZWN0b3IgIT09IFwic3RyaW5nXCIgfHwgIXNlbGVjdG9yIHx8IG5vZGVUeXBlICE9PSAxICYmIG5vZGVUeXBlICE9PSA5ICYmIG5vZGVUeXBlICE9PSAxMSkge1xuICAgICAgICAgIHJldHVybiByZXN1bHRzO1xuICAgICAgICB9IC8vIFRyeSB0byBzaG9ydGN1dCBmaW5kIG9wZXJhdGlvbnMgKGFzIG9wcG9zZWQgdG8gZmlsdGVycykgaW4gSFRNTCBkb2N1bWVudHNcblxuXG4gICAgICAgIGlmICghc2VlZCkge1xuICAgICAgICAgIGlmICgoY29udGV4dCA/IGNvbnRleHQub3duZXJEb2N1bWVudCB8fCBjb250ZXh0IDogcHJlZmVycmVkRG9jKSAhPT0gZG9jdW1lbnQpIHtcbiAgICAgICAgICAgIHNldERvY3VtZW50KGNvbnRleHQpO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIGNvbnRleHQgPSBjb250ZXh0IHx8IGRvY3VtZW50O1xuXG4gICAgICAgICAgaWYgKGRvY3VtZW50SXNIVE1MKSB7XG4gICAgICAgICAgICAvLyBJZiB0aGUgc2VsZWN0b3IgaXMgc3VmZmljaWVudGx5IHNpbXBsZSwgdHJ5IHVzaW5nIGEgXCJnZXQqQnkqXCIgRE9NIG1ldGhvZFxuICAgICAgICAgICAgLy8gKGV4Y2VwdGluZyBEb2N1bWVudEZyYWdtZW50IGNvbnRleHQsIHdoZXJlIHRoZSBtZXRob2RzIGRvbid0IGV4aXN0KVxuICAgICAgICAgICAgaWYgKG5vZGVUeXBlICE9PSAxMSAmJiAobWF0Y2ggPSBycXVpY2tFeHByLmV4ZWMoc2VsZWN0b3IpKSkge1xuICAgICAgICAgICAgICAvLyBJRCBzZWxlY3RvclxuICAgICAgICAgICAgICBpZiAobSA9IG1hdGNoWzFdKSB7XG4gICAgICAgICAgICAgICAgLy8gRG9jdW1lbnQgY29udGV4dFxuICAgICAgICAgICAgICAgIGlmIChub2RlVHlwZSA9PT0gOSkge1xuICAgICAgICAgICAgICAgICAgaWYgKGVsZW0gPSBjb250ZXh0LmdldEVsZW1lbnRCeUlkKG0pKSB7XG4gICAgICAgICAgICAgICAgICAgIC8vIFN1cHBvcnQ6IElFLCBPcGVyYSwgV2Via2l0XG4gICAgICAgICAgICAgICAgICAgIC8vIFRPRE86IGlkZW50aWZ5IHZlcnNpb25zXG4gICAgICAgICAgICAgICAgICAgIC8vIGdldEVsZW1lbnRCeUlkIGNhbiBtYXRjaCBlbGVtZW50cyBieSBuYW1lIGluc3RlYWQgb2YgSURcbiAgICAgICAgICAgICAgICAgICAgaWYgKGVsZW0uaWQgPT09IG0pIHtcbiAgICAgICAgICAgICAgICAgICAgICByZXN1bHRzLnB1c2goZWxlbSk7XG4gICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIHJlc3VsdHM7XG4gICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgICAgICAgIHJldHVybiByZXN1bHRzO1xuICAgICAgICAgICAgICAgICAgfSAvLyBFbGVtZW50IGNvbnRleHRcblxuICAgICAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgICAgICAvLyBTdXBwb3J0OiBJRSwgT3BlcmEsIFdlYmtpdFxuICAgICAgICAgICAgICAgICAgLy8gVE9ETzogaWRlbnRpZnkgdmVyc2lvbnNcbiAgICAgICAgICAgICAgICAgIC8vIGdldEVsZW1lbnRCeUlkIGNhbiBtYXRjaCBlbGVtZW50cyBieSBuYW1lIGluc3RlYWQgb2YgSURcbiAgICAgICAgICAgICAgICAgIGlmIChuZXdDb250ZXh0ICYmIChlbGVtID0gbmV3Q29udGV4dC5nZXRFbGVtZW50QnlJZChtKSkgJiYgY29udGFpbnMoY29udGV4dCwgZWxlbSkgJiYgZWxlbS5pZCA9PT0gbSkge1xuICAgICAgICAgICAgICAgICAgICByZXN1bHRzLnB1c2goZWxlbSk7XG4gICAgICAgICAgICAgICAgICAgIHJldHVybiByZXN1bHRzO1xuICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIH0gLy8gVHlwZSBzZWxlY3RvclxuXG4gICAgICAgICAgICAgIH0gZWxzZSBpZiAobWF0Y2hbMl0pIHtcbiAgICAgICAgICAgICAgICBwdXNoLmFwcGx5KHJlc3VsdHMsIGNvbnRleHQuZ2V0RWxlbWVudHNCeVRhZ05hbWUoc2VsZWN0b3IpKTtcbiAgICAgICAgICAgICAgICByZXR1cm4gcmVzdWx0czsgLy8gQ2xhc3Mgc2VsZWN0b3JcbiAgICAgICAgICAgICAgfSBlbHNlIGlmICgobSA9IG1hdGNoWzNdKSAmJiBzdXBwb3J0LmdldEVsZW1lbnRzQnlDbGFzc05hbWUgJiYgY29udGV4dC5nZXRFbGVtZW50c0J5Q2xhc3NOYW1lKSB7XG4gICAgICAgICAgICAgICAgcHVzaC5hcHBseShyZXN1bHRzLCBjb250ZXh0LmdldEVsZW1lbnRzQnlDbGFzc05hbWUobSkpO1xuICAgICAgICAgICAgICAgIHJldHVybiByZXN1bHRzO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9IC8vIFRha2UgYWR2YW50YWdlIG9mIHF1ZXJ5U2VsZWN0b3JBbGxcblxuXG4gICAgICAgICAgICBpZiAoc3VwcG9ydC5xc2EgJiYgIW5vbm5hdGl2ZVNlbGVjdG9yQ2FjaGVbc2VsZWN0b3IgKyBcIiBcIl0gJiYgKCFyYnVnZ3lRU0EgfHwgIXJidWdneVFTQS50ZXN0KHNlbGVjdG9yKSkpIHtcbiAgICAgICAgICAgICAgaWYgKG5vZGVUeXBlICE9PSAxKSB7XG4gICAgICAgICAgICAgICAgbmV3Q29udGV4dCA9IGNvbnRleHQ7XG4gICAgICAgICAgICAgICAgbmV3U2VsZWN0b3IgPSBzZWxlY3RvcjsgLy8gcVNBIGxvb2tzIG91dHNpZGUgRWxlbWVudCBjb250ZXh0LCB3aGljaCBpcyBub3Qgd2hhdCB3ZSB3YW50XG4gICAgICAgICAgICAgICAgLy8gVGhhbmtzIHRvIEFuZHJldyBEdXBvbnQgZm9yIHRoaXMgd29ya2Fyb3VuZCB0ZWNobmlxdWVcbiAgICAgICAgICAgICAgICAvLyBTdXBwb3J0OiBJRSA8PThcbiAgICAgICAgICAgICAgICAvLyBFeGNsdWRlIG9iamVjdCBlbGVtZW50c1xuICAgICAgICAgICAgICB9IGVsc2UgaWYgKGNvbnRleHQubm9kZU5hbWUudG9Mb3dlckNhc2UoKSAhPT0gXCJvYmplY3RcIikge1xuICAgICAgICAgICAgICAgIC8vIENhcHR1cmUgdGhlIGNvbnRleHQgSUQsIHNldHRpbmcgaXQgZmlyc3QgaWYgbmVjZXNzYXJ5XG4gICAgICAgICAgICAgICAgaWYgKG5pZCA9IGNvbnRleHQuZ2V0QXR0cmlidXRlKFwiaWRcIikpIHtcbiAgICAgICAgICAgICAgICAgIG5pZCA9IG5pZC5yZXBsYWNlKHJjc3Nlc2NhcGUsIGZjc3Nlc2NhcGUpO1xuICAgICAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgICAgICBjb250ZXh0LnNldEF0dHJpYnV0ZShcImlkXCIsIG5pZCA9IGV4cGFuZG8pO1xuICAgICAgICAgICAgICAgIH0gLy8gUHJlZml4IGV2ZXJ5IHNlbGVjdG9yIGluIHRoZSBsaXN0XG5cblxuICAgICAgICAgICAgICAgIGdyb3VwcyA9IHRva2VuaXplKHNlbGVjdG9yKTtcbiAgICAgICAgICAgICAgICBpID0gZ3JvdXBzLmxlbmd0aDtcblxuICAgICAgICAgICAgICAgIHdoaWxlIChpLS0pIHtcbiAgICAgICAgICAgICAgICAgIGdyb3Vwc1tpXSA9IFwiI1wiICsgbmlkICsgXCIgXCIgKyB0b1NlbGVjdG9yKGdyb3Vwc1tpXSk7XG4gICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgbmV3U2VsZWN0b3IgPSBncm91cHMuam9pbihcIixcIik7IC8vIEV4cGFuZCBjb250ZXh0IGZvciBzaWJsaW5nIHNlbGVjdG9yc1xuXG4gICAgICAgICAgICAgICAgbmV3Q29udGV4dCA9IHJzaWJsaW5nLnRlc3Qoc2VsZWN0b3IpICYmIHRlc3RDb250ZXh0KGNvbnRleHQucGFyZW50Tm9kZSkgfHwgY29udGV4dDtcbiAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgIGlmIChuZXdTZWxlY3Rvcikge1xuICAgICAgICAgICAgICAgIHRyeSB7XG4gICAgICAgICAgICAgICAgICBwdXNoLmFwcGx5KHJlc3VsdHMsIG5ld0NvbnRleHQucXVlcnlTZWxlY3RvckFsbChuZXdTZWxlY3RvcikpO1xuICAgICAgICAgICAgICAgICAgcmV0dXJuIHJlc3VsdHM7XG4gICAgICAgICAgICAgICAgfSBjYXRjaCAocXNhRXJyb3IpIHtcbiAgICAgICAgICAgICAgICAgIC8vIFtBZEd1YXJkIFBhdGhdOiBGaXggdGhlIGNhY2hlIHZhbHVlXG4gICAgICAgICAgICAgICAgICBub25uYXRpdmVTZWxlY3RvckNhY2hlKHNlbGVjdG9yLCB0cnVlKTtcbiAgICAgICAgICAgICAgICB9IGZpbmFsbHkge1xuICAgICAgICAgICAgICAgICAgaWYgKG5pZCA9PT0gZXhwYW5kbykge1xuICAgICAgICAgICAgICAgICAgICBjb250ZXh0LnJlbW92ZUF0dHJpYnV0ZShcImlkXCIpO1xuICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cbiAgICAgICAgfSAvLyBBbGwgb3RoZXJzXG5cblxuICAgICAgICByZXR1cm4gc2VsZWN0KHNlbGVjdG9yLnJlcGxhY2UocnRyaW0sIFwiJDFcIiksIGNvbnRleHQsIHJlc3VsdHMsIHNlZWQpO1xuICAgICAgfVxuICAgICAgLyoqXG4gICAgICAgKiBDcmVhdGUga2V5LXZhbHVlIGNhY2hlcyBvZiBsaW1pdGVkIHNpemVcbiAgICAgICAqIEByZXR1cm5zIHtmdW5jdGlvbihzdHJpbmcsIG9iamVjdCl9IFJldHVybnMgdGhlIE9iamVjdCBkYXRhIGFmdGVyIHN0b3JpbmcgaXQgb24gaXRzZWxmIHdpdGhcbiAgICAgICAqXHRwcm9wZXJ0eSBuYW1lIHRoZSAoc3BhY2Utc3VmZml4ZWQpIHN0cmluZyBhbmQgKGlmIHRoZSBjYWNoZSBpcyBsYXJnZXIgdGhhbiBFeHByLmNhY2hlTGVuZ3RoKVxuICAgICAgICpcdGRlbGV0aW5nIHRoZSBvbGRlc3QgZW50cnlcbiAgICAgICAqL1xuXG5cbiAgICAgIGZ1bmN0aW9uIGNyZWF0ZUNhY2hlKCkge1xuICAgICAgICB2YXIga2V5cyA9IFtdO1xuXG4gICAgICAgIGZ1bmN0aW9uIGNhY2hlKGtleSwgdmFsdWUpIHtcbiAgICAgICAgICAvLyBVc2UgKGtleSArIFwiIFwiKSB0byBhdm9pZCBjb2xsaXNpb24gd2l0aCBuYXRpdmUgcHJvdG90eXBlIHByb3BlcnRpZXMgKHNlZSBJc3N1ZSAjMTU3KVxuICAgICAgICAgIGlmIChrZXlzLnB1c2goa2V5ICsgXCIgXCIpID4gRXhwci5jYWNoZUxlbmd0aCkge1xuICAgICAgICAgICAgLy8gT25seSBrZWVwIHRoZSBtb3N0IHJlY2VudCBlbnRyaWVzXG4gICAgICAgICAgICBkZWxldGUgY2FjaGVba2V5cy5zaGlmdCgpXTtcbiAgICAgICAgICB9XG5cbiAgICAgICAgICByZXR1cm4gY2FjaGVba2V5ICsgXCIgXCJdID0gdmFsdWU7XG4gICAgICAgIH1cblxuICAgICAgICByZXR1cm4gY2FjaGU7XG4gICAgICB9XG4gICAgICAvKipcbiAgICAgICAqIE1hcmsgYSBmdW5jdGlvbiBmb3Igc3BlY2lhbCB1c2UgYnkgU2l6emxlXG4gICAgICAgKiBAcGFyYW0ge0Z1bmN0aW9ufSBmbiBUaGUgZnVuY3Rpb24gdG8gbWFya1xuICAgICAgICovXG5cblxuICAgICAgZnVuY3Rpb24gbWFya0Z1bmN0aW9uKGZuKSB7XG4gICAgICAgIGZuW2V4cGFuZG9dID0gdHJ1ZTtcbiAgICAgICAgcmV0dXJuIGZuO1xuICAgICAgfVxuICAgICAgLyoqXG4gICAgICAgKiBTdXBwb3J0IHRlc3RpbmcgdXNpbmcgYW4gZWxlbWVudFxuICAgICAgICogQHBhcmFtIHtGdW5jdGlvbn0gZm4gUGFzc2VkIHRoZSBjcmVhdGVkIGVsZW1lbnQgYW5kIHJldHVybnMgYSBib29sZWFuIHJlc3VsdFxuICAgICAgICovXG5cblxuICAgICAgZnVuY3Rpb24gYXNzZXJ0KGZuKSB7XG4gICAgICAgIHZhciBlbCA9IGRvY3VtZW50LmNyZWF0ZUVsZW1lbnQoXCJmaWVsZHNldFwiKTtcblxuICAgICAgICB0cnkge1xuICAgICAgICAgIHJldHVybiAhIWZuKGVsKTtcbiAgICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgICAgfSBmaW5hbGx5IHtcbiAgICAgICAgICAvLyBSZW1vdmUgZnJvbSBpdHMgcGFyZW50IGJ5IGRlZmF1bHRcbiAgICAgICAgICBpZiAoZWwucGFyZW50Tm9kZSkge1xuICAgICAgICAgICAgZWwucGFyZW50Tm9kZS5yZW1vdmVDaGlsZChlbCk7XG4gICAgICAgICAgfSAvLyByZWxlYXNlIG1lbW9yeSBpbiBJRVxuXG5cbiAgICAgICAgICBlbCA9IG51bGw7XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICAgIC8qKlxuICAgICAgICogQWRkcyB0aGUgc2FtZSBoYW5kbGVyIGZvciBhbGwgb2YgdGhlIHNwZWNpZmllZCBhdHRyc1xuICAgICAgICogQHBhcmFtIHtTdHJpbmd9IGF0dHJzIFBpcGUtc2VwYXJhdGVkIGxpc3Qgb2YgYXR0cmlidXRlc1xuICAgICAgICogQHBhcmFtIHtGdW5jdGlvbn0gaGFuZGxlciBUaGUgbWV0aG9kIHRoYXQgd2lsbCBiZSBhcHBsaWVkXG4gICAgICAgKi9cblxuXG4gICAgICBmdW5jdGlvbiBhZGRIYW5kbGUoYXR0cnMsIGhhbmRsZXIpIHtcbiAgICAgICAgdmFyIGFyciA9IGF0dHJzLnNwbGl0KFwifFwiKSxcbiAgICAgICAgICAgIGkgPSBhcnIubGVuZ3RoO1xuXG4gICAgICAgIHdoaWxlIChpLS0pIHtcbiAgICAgICAgICBFeHByLmF0dHJIYW5kbGVbYXJyW2ldXSA9IGhhbmRsZXI7XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICAgIC8qKlxuICAgICAgICogQ2hlY2tzIGRvY3VtZW50IG9yZGVyIG9mIHR3byBzaWJsaW5nc1xuICAgICAgICogQHBhcmFtIHtFbGVtZW50fSBhXG4gICAgICAgKiBAcGFyYW0ge0VsZW1lbnR9IGJcbiAgICAgICAqIEByZXR1cm5zIHtOdW1iZXJ9IFJldHVybnMgbGVzcyB0aGFuIDAgaWYgYSBwcmVjZWRlcyBiLCBncmVhdGVyIHRoYW4gMCBpZiBhIGZvbGxvd3MgYlxuICAgICAgICovXG5cblxuICAgICAgZnVuY3Rpb24gc2libGluZ0NoZWNrKGEsIGIpIHtcbiAgICAgICAgdmFyIGN1ciA9IGIgJiYgYSxcbiAgICAgICAgICAgIGRpZmYgPSBjdXIgJiYgYS5ub2RlVHlwZSA9PT0gMSAmJiBiLm5vZGVUeXBlID09PSAxICYmIGEuc291cmNlSW5kZXggLSBiLnNvdXJjZUluZGV4OyAvLyBVc2UgSUUgc291cmNlSW5kZXggaWYgYXZhaWxhYmxlIG9uIGJvdGggbm9kZXNcblxuICAgICAgICBpZiAoZGlmZikge1xuICAgICAgICAgIHJldHVybiBkaWZmO1xuICAgICAgICB9IC8vIENoZWNrIGlmIGIgZm9sbG93cyBhXG5cblxuICAgICAgICBpZiAoY3VyKSB7XG4gICAgICAgICAgd2hpbGUgKGN1ciA9IGN1ci5uZXh0U2libGluZykge1xuICAgICAgICAgICAgaWYgKGN1ciA9PT0gYikge1xuICAgICAgICAgICAgICByZXR1cm4gLTE7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfVxuICAgICAgICB9XG5cbiAgICAgICAgcmV0dXJuIGEgPyAxIDogLTE7XG4gICAgICB9XG4gICAgICAvKipcbiAgICAgICAqIFJldHVybnMgYSBmdW5jdGlvbiB0byB1c2UgaW4gcHNldWRvcyBmb3IgOmVuYWJsZWQvOmRpc2FibGVkXG4gICAgICAgKiBAcGFyYW0ge0Jvb2xlYW59IGRpc2FibGVkIHRydWUgZm9yIDpkaXNhYmxlZDsgZmFsc2UgZm9yIDplbmFibGVkXG4gICAgICAgKi9cblxuXG4gICAgICBmdW5jdGlvbiBjcmVhdGVEaXNhYmxlZFBzZXVkbyhkaXNhYmxlZCkge1xuICAgICAgICAvLyBLbm93biA6ZGlzYWJsZWQgZmFsc2UgcG9zaXRpdmVzOiBmaWVsZHNldFtkaXNhYmxlZF0gPiBsZWdlbmQ6bnRoLW9mLXR5cGUobisyKSA6Y2FuLWRpc2FibGVcbiAgICAgICAgcmV0dXJuIGZ1bmN0aW9uIChlbGVtKSB7XG4gICAgICAgICAgLy8gT25seSBjZXJ0YWluIGVsZW1lbnRzIGNhbiBtYXRjaCA6ZW5hYmxlZCBvciA6ZGlzYWJsZWRcbiAgICAgICAgICAvLyBodHRwczovL2h0bWwuc3BlYy53aGF0d2cub3JnL211bHRpcGFnZS9zY3JpcHRpbmcuaHRtbCNzZWxlY3Rvci1lbmFibGVkXG4gICAgICAgICAgLy8gaHR0cHM6Ly9odG1sLnNwZWMud2hhdHdnLm9yZy9tdWx0aXBhZ2Uvc2NyaXB0aW5nLmh0bWwjc2VsZWN0b3ItZGlzYWJsZWRcbiAgICAgICAgICBpZiAoXCJmb3JtXCIgaW4gZWxlbSkge1xuICAgICAgICAgICAgLy8gQ2hlY2sgZm9yIGluaGVyaXRlZCBkaXNhYmxlZG5lc3Mgb24gcmVsZXZhbnQgbm9uLWRpc2FibGVkIGVsZW1lbnRzOlxuICAgICAgICAgICAgLy8gKiBsaXN0ZWQgZm9ybS1hc3NvY2lhdGVkIGVsZW1lbnRzIGluIGEgZGlzYWJsZWQgZmllbGRzZXRcbiAgICAgICAgICAgIC8vICAgaHR0cHM6Ly9odG1sLnNwZWMud2hhdHdnLm9yZy9tdWx0aXBhZ2UvZm9ybXMuaHRtbCNjYXRlZ29yeS1saXN0ZWRcbiAgICAgICAgICAgIC8vICAgaHR0cHM6Ly9odG1sLnNwZWMud2hhdHdnLm9yZy9tdWx0aXBhZ2UvZm9ybXMuaHRtbCNjb25jZXB0LWZlLWRpc2FibGVkXG4gICAgICAgICAgICAvLyAqIG9wdGlvbiBlbGVtZW50cyBpbiBhIGRpc2FibGVkIG9wdGdyb3VwXG4gICAgICAgICAgICAvLyAgIGh0dHBzOi8vaHRtbC5zcGVjLndoYXR3Zy5vcmcvbXVsdGlwYWdlL2Zvcm1zLmh0bWwjY29uY2VwdC1vcHRpb24tZGlzYWJsZWRcbiAgICAgICAgICAgIC8vIEFsbCBzdWNoIGVsZW1lbnRzIGhhdmUgYSBcImZvcm1cIiBwcm9wZXJ0eS5cbiAgICAgICAgICAgIGlmIChlbGVtLnBhcmVudE5vZGUgJiYgZWxlbS5kaXNhYmxlZCA9PT0gZmFsc2UpIHtcbiAgICAgICAgICAgICAgLy8gT3B0aW9uIGVsZW1lbnRzIGRlZmVyIHRvIGEgcGFyZW50IG9wdGdyb3VwIGlmIHByZXNlbnRcbiAgICAgICAgICAgICAgaWYgKFwibGFiZWxcIiBpbiBlbGVtKSB7XG4gICAgICAgICAgICAgICAgaWYgKFwibGFiZWxcIiBpbiBlbGVtLnBhcmVudE5vZGUpIHtcbiAgICAgICAgICAgICAgICAgIHJldHVybiBlbGVtLnBhcmVudE5vZGUuZGlzYWJsZWQgPT09IGRpc2FibGVkO1xuICAgICAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgICAgICByZXR1cm4gZWxlbS5kaXNhYmxlZCA9PT0gZGlzYWJsZWQ7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICB9IC8vIFN1cHBvcnQ6IElFIDYgLSAxMVxuICAgICAgICAgICAgICAvLyBVc2UgdGhlIGlzRGlzYWJsZWQgc2hvcnRjdXQgcHJvcGVydHkgdG8gY2hlY2sgZm9yIGRpc2FibGVkIGZpZWxkc2V0IGFuY2VzdG9yc1xuXG5cbiAgICAgICAgICAgICAgcmV0dXJuIGVsZW0uaXNEaXNhYmxlZCA9PT0gZGlzYWJsZWQgfHwgLy8gV2hlcmUgdGhlcmUgaXMgbm8gaXNEaXNhYmxlZCwgY2hlY2sgbWFudWFsbHlcblxuICAgICAgICAgICAgICAvKiBqc2hpbnQgLVcwMTggKi9cbiAgICAgICAgICAgICAgZWxlbS5pc0Rpc2FibGVkICE9PSAhZGlzYWJsZWQgJiYgaW5EaXNhYmxlZEZpZWxkc2V0KGVsZW0pID09PSBkaXNhYmxlZDtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgcmV0dXJuIGVsZW0uZGlzYWJsZWQgPT09IGRpc2FibGVkOyAvLyBUcnkgdG8gd2lubm93IG91dCBlbGVtZW50cyB0aGF0IGNhbid0IGJlIGRpc2FibGVkIGJlZm9yZSB0cnVzdGluZyB0aGUgZGlzYWJsZWQgcHJvcGVydHkuXG4gICAgICAgICAgICAvLyBTb21lIHZpY3RpbXMgZ2V0IGNhdWdodCBpbiBvdXIgbmV0IChsYWJlbCwgbGVnZW5kLCBtZW51LCB0cmFjayksIGJ1dCBpdCBzaG91bGRuJ3RcbiAgICAgICAgICAgIC8vIGV2ZW4gZXhpc3Qgb24gdGhlbSwgbGV0IGFsb25lIGhhdmUgYSBib29sZWFuIHZhbHVlLlxuICAgICAgICAgIH0gZWxzZSBpZiAoXCJsYWJlbFwiIGluIGVsZW0pIHtcbiAgICAgICAgICAgIHJldHVybiBlbGVtLmRpc2FibGVkID09PSBkaXNhYmxlZDtcbiAgICAgICAgICB9IC8vIFJlbWFpbmluZyBlbGVtZW50cyBhcmUgbmVpdGhlciA6ZW5hYmxlZCBub3IgOmRpc2FibGVkXG5cblxuICAgICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgICAgfTtcbiAgICAgIH1cbiAgICAgIC8qKlxuICAgICAgICogQ2hlY2tzIGEgbm9kZSBmb3IgdmFsaWRpdHkgYXMgYSBTaXp6bGUgY29udGV4dFxuICAgICAgICogQHBhcmFtIHtFbGVtZW50fE9iamVjdD19IGNvbnRleHRcbiAgICAgICAqIEByZXR1cm5zIHtFbGVtZW50fE9iamVjdHxCb29sZWFufSBUaGUgaW5wdXQgbm9kZSBpZiBhY2NlcHRhYmxlLCBvdGhlcndpc2UgYSBmYWxzeSB2YWx1ZVxuICAgICAgICovXG5cblxuICAgICAgZnVuY3Rpb24gdGVzdENvbnRleHQoY29udGV4dCkge1xuICAgICAgICByZXR1cm4gY29udGV4dCAmJiB0eXBlb2YgY29udGV4dC5nZXRFbGVtZW50c0J5VGFnTmFtZSAhPT0gXCJ1bmRlZmluZWRcIiAmJiBjb250ZXh0O1xuICAgICAgfSAvLyBFeHBvc2Ugc3VwcG9ydCB2YXJzIGZvciBjb252ZW5pZW5jZVxuXG5cbiAgICAgIHN1cHBvcnQgPSBTaXp6bGUuc3VwcG9ydCA9IHt9O1xuICAgICAgLyoqXG4gICAgICAgKiBEZXRlY3RzIFhNTCBub2Rlc1xuICAgICAgICogQHBhcmFtIHtFbGVtZW50fE9iamVjdH0gZWxlbSBBbiBlbGVtZW50IG9yIGEgZG9jdW1lbnRcbiAgICAgICAqIEByZXR1cm5zIHtCb29sZWFufSBUcnVlIGlmZiBlbGVtIGlzIGEgbm9uLUhUTUwgWE1MIG5vZGVcbiAgICAgICAqL1xuXG4gICAgICBpc1hNTCA9IFNpenpsZS5pc1hNTCA9IGZ1bmN0aW9uIChlbGVtKSB7XG4gICAgICAgIC8vIGRvY3VtZW50RWxlbWVudCBpcyB2ZXJpZmllZCBmb3IgY2FzZXMgd2hlcmUgaXQgZG9lc24ndCB5ZXQgZXhpc3RcbiAgICAgICAgLy8gKHN1Y2ggYXMgbG9hZGluZyBpZnJhbWVzIGluIElFIC0gIzQ4MzMpXG4gICAgICAgIHZhciBkb2N1bWVudEVsZW1lbnQgPSBlbGVtICYmIChlbGVtLm93bmVyRG9jdW1lbnQgfHwgZWxlbSkuZG9jdW1lbnRFbGVtZW50O1xuICAgICAgICByZXR1cm4gZG9jdW1lbnRFbGVtZW50ID8gZG9jdW1lbnRFbGVtZW50Lm5vZGVOYW1lICE9PSBcIkhUTUxcIiA6IGZhbHNlO1xuICAgICAgfTtcbiAgICAgIC8qKlxuICAgICAgICogU2V0cyBkb2N1bWVudC1yZWxhdGVkIHZhcmlhYmxlcyBvbmNlIGJhc2VkIG9uIHRoZSBjdXJyZW50IGRvY3VtZW50XG4gICAgICAgKiBAcGFyYW0ge0VsZW1lbnR8T2JqZWN0fSBbZG9jXSBBbiBlbGVtZW50IG9yIGRvY3VtZW50IG9iamVjdCB0byB1c2UgdG8gc2V0IHRoZSBkb2N1bWVudFxuICAgICAgICogQHJldHVybnMge09iamVjdH0gUmV0dXJucyB0aGUgY3VycmVudCBkb2N1bWVudFxuICAgICAgICovXG5cblxuICAgICAgc2V0RG9jdW1lbnQgPSBTaXp6bGUuc2V0RG9jdW1lbnQgPSBmdW5jdGlvbiAobm9kZSkge1xuICAgICAgICB2YXIgaGFzQ29tcGFyZSxcbiAgICAgICAgICAgIHN1YldpbmRvdyxcbiAgICAgICAgICAgIGRvYyA9IG5vZGUgPyBub2RlLm93bmVyRG9jdW1lbnQgfHwgbm9kZSA6IHByZWZlcnJlZERvYzsgLy8gUmV0dXJuIGVhcmx5IGlmIGRvYyBpcyBpbnZhbGlkIG9yIGFscmVhZHkgc2VsZWN0ZWRcblxuICAgICAgICBpZiAoZG9jID09PSBkb2N1bWVudCB8fCBkb2Mubm9kZVR5cGUgIT09IDkgfHwgIWRvYy5kb2N1bWVudEVsZW1lbnQpIHtcbiAgICAgICAgICByZXR1cm4gZG9jdW1lbnQ7XG4gICAgICAgIH0gLy8gVXBkYXRlIGdsb2JhbCB2YXJpYWJsZXNcblxuXG4gICAgICAgIGRvY3VtZW50ID0gZG9jO1xuICAgICAgICBkb2NFbGVtID0gZG9jdW1lbnQuZG9jdW1lbnRFbGVtZW50O1xuICAgICAgICBkb2N1bWVudElzSFRNTCA9ICFpc1hNTChkb2N1bWVudCk7IC8vIFN1cHBvcnQ6IElFIDktMTEsIEVkZ2VcbiAgICAgICAgLy8gQWNjZXNzaW5nIGlmcmFtZSBkb2N1bWVudHMgYWZ0ZXIgdW5sb2FkIHRocm93cyBcInBlcm1pc3Npb24gZGVuaWVkXCIgZXJyb3JzIChqUXVlcnkgIzEzOTM2KVxuXG4gICAgICAgIGlmIChwcmVmZXJyZWREb2MgIT09IGRvY3VtZW50ICYmIChzdWJXaW5kb3cgPSBkb2N1bWVudC5kZWZhdWx0VmlldykgJiYgc3ViV2luZG93LnRvcCAhPT0gc3ViV2luZG93KSB7XG4gICAgICAgICAgLy8gU3VwcG9ydDogSUUgMTEsIEVkZ2VcbiAgICAgICAgICBpZiAoc3ViV2luZG93LmFkZEV2ZW50TGlzdGVuZXIpIHtcbiAgICAgICAgICAgIHN1YldpbmRvdy5hZGRFdmVudExpc3RlbmVyKFwidW5sb2FkXCIsIHVubG9hZEhhbmRsZXIsIGZhbHNlKTsgLy8gU3VwcG9ydDogSUUgOSAtIDEwIG9ubHlcbiAgICAgICAgICB9IGVsc2UgaWYgKHN1YldpbmRvdy5hdHRhY2hFdmVudCkge1xuICAgICAgICAgICAgc3ViV2luZG93LmF0dGFjaEV2ZW50KFwib251bmxvYWRcIiwgdW5sb2FkSGFuZGxlcik7XG4gICAgICAgICAgfVxuICAgICAgICB9XG4gICAgICAgIC8qIEF0dHJpYnV0ZXNcbiAgICAgICAgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSAqL1xuICAgICAgICAvLyBTdXBwb3J0OiBJRTw4XG4gICAgICAgIC8vIFZlcmlmeSB0aGF0IGdldEF0dHJpYnV0ZSByZWFsbHkgcmV0dXJucyBhdHRyaWJ1dGVzIGFuZCBub3QgcHJvcGVydGllc1xuICAgICAgICAvLyAoZXhjZXB0aW5nIElFOCBib29sZWFucylcblxuXG4gICAgICAgIHN1cHBvcnQuYXR0cmlidXRlcyA9IGFzc2VydChmdW5jdGlvbiAoZWwpIHtcbiAgICAgICAgICBlbC5jbGFzc05hbWUgPSBcImlcIjtcbiAgICAgICAgICByZXR1cm4gIWVsLmdldEF0dHJpYnV0ZShcImNsYXNzTmFtZVwiKTtcbiAgICAgICAgfSk7XG4gICAgICAgIC8qIGdldEVsZW1lbnQocylCeSpcbiAgICAgICAgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSAqL1xuICAgICAgICAvLyBDaGVjayBpZiBnZXRFbGVtZW50c0J5VGFnTmFtZShcIipcIikgcmV0dXJucyBvbmx5IGVsZW1lbnRzXG5cbiAgICAgICAgc3VwcG9ydC5nZXRFbGVtZW50c0J5VGFnTmFtZSA9IGFzc2VydChmdW5jdGlvbiAoZWwpIHtcbiAgICAgICAgICBlbC5hcHBlbmRDaGlsZChkb2N1bWVudC5jcmVhdGVDb21tZW50KFwiXCIpKTtcbiAgICAgICAgICByZXR1cm4gIWVsLmdldEVsZW1lbnRzQnlUYWdOYW1lKFwiKlwiKS5sZW5ndGg7XG4gICAgICAgIH0pOyAvLyBTdXBwb3J0OiBJRTw5XG5cbiAgICAgICAgc3VwcG9ydC5nZXRFbGVtZW50c0J5Q2xhc3NOYW1lID0gcm5hdGl2ZS50ZXN0KGRvY3VtZW50LmdldEVsZW1lbnRzQnlDbGFzc05hbWUpOyAvLyBTdXBwb3J0OiBJRTwxMFxuICAgICAgICAvLyBDaGVjayBpZiBnZXRFbGVtZW50QnlJZCByZXR1cm5zIGVsZW1lbnRzIGJ5IG5hbWVcbiAgICAgICAgLy8gVGhlIGJyb2tlbiBnZXRFbGVtZW50QnlJZCBtZXRob2RzIGRvbid0IHBpY2sgdXAgcHJvZ3JhbW1hdGljYWxseS1zZXQgbmFtZXMsXG4gICAgICAgIC8vIHNvIHVzZSBhIHJvdW5kYWJvdXQgZ2V0RWxlbWVudHNCeU5hbWUgdGVzdFxuXG4gICAgICAgIHN1cHBvcnQuZ2V0QnlJZCA9IGFzc2VydChmdW5jdGlvbiAoZWwpIHtcbiAgICAgICAgICBkb2NFbGVtLmFwcGVuZENoaWxkKGVsKS5pZCA9IGV4cGFuZG87XG4gICAgICAgICAgcmV0dXJuICFkb2N1bWVudC5nZXRFbGVtZW50c0J5TmFtZSB8fCAhZG9jdW1lbnQuZ2V0RWxlbWVudHNCeU5hbWUoZXhwYW5kbykubGVuZ3RoO1xuICAgICAgICB9KTsgLy8gSUQgZmlsdGVyIGFuZCBmaW5kXG5cbiAgICAgICAgaWYgKHN1cHBvcnQuZ2V0QnlJZCkge1xuICAgICAgICAgIEV4cHIuZmlsdGVyW1wiSURcIl0gPSBmdW5jdGlvbiAoaWQpIHtcbiAgICAgICAgICAgIHZhciBhdHRySWQgPSBpZC5yZXBsYWNlKHJ1bmVzY2FwZSwgZnVuZXNjYXBlKTtcbiAgICAgICAgICAgIHJldHVybiBmdW5jdGlvbiAoZWxlbSkge1xuICAgICAgICAgICAgICByZXR1cm4gZWxlbS5nZXRBdHRyaWJ1dGUoXCJpZFwiKSA9PT0gYXR0cklkO1xuICAgICAgICAgICAgfTtcbiAgICAgICAgICB9O1xuXG4gICAgICAgICAgRXhwci5maW5kW1wiSURcIl0gPSBmdW5jdGlvbiAoaWQsIGNvbnRleHQpIHtcbiAgICAgICAgICAgIGlmICh0eXBlb2YgY29udGV4dC5nZXRFbGVtZW50QnlJZCAhPT0gXCJ1bmRlZmluZWRcIiAmJiBkb2N1bWVudElzSFRNTCkge1xuICAgICAgICAgICAgICB2YXIgZWxlbSA9IGNvbnRleHQuZ2V0RWxlbWVudEJ5SWQoaWQpO1xuICAgICAgICAgICAgICByZXR1cm4gZWxlbSA/IFtlbGVtXSA6IFtdO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH07XG4gICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgRXhwci5maWx0ZXJbXCJJRFwiXSA9IGZ1bmN0aW9uIChpZCkge1xuICAgICAgICAgICAgdmFyIGF0dHJJZCA9IGlkLnJlcGxhY2UocnVuZXNjYXBlLCBmdW5lc2NhcGUpO1xuICAgICAgICAgICAgcmV0dXJuIGZ1bmN0aW9uIChlbGVtKSB7XG4gICAgICAgICAgICAgIHZhciBub2RlID0gdHlwZW9mIGVsZW0uZ2V0QXR0cmlidXRlTm9kZSAhPT0gXCJ1bmRlZmluZWRcIiAmJiBlbGVtLmdldEF0dHJpYnV0ZU5vZGUoXCJpZFwiKTtcbiAgICAgICAgICAgICAgcmV0dXJuIG5vZGUgJiYgbm9kZS52YWx1ZSA9PT0gYXR0cklkO1xuICAgICAgICAgICAgfTtcbiAgICAgICAgICB9OyAvLyBTdXBwb3J0OiBJRSA2IC0gNyBvbmx5XG4gICAgICAgICAgLy8gZ2V0RWxlbWVudEJ5SWQgaXMgbm90IHJlbGlhYmxlIGFzIGEgZmluZCBzaG9ydGN1dFxuXG5cbiAgICAgICAgICBFeHByLmZpbmRbXCJJRFwiXSA9IGZ1bmN0aW9uIChpZCwgY29udGV4dCkge1xuICAgICAgICAgICAgaWYgKHR5cGVvZiBjb250ZXh0LmdldEVsZW1lbnRCeUlkICE9PSBcInVuZGVmaW5lZFwiICYmIGRvY3VtZW50SXNIVE1MKSB7XG4gICAgICAgICAgICAgIHZhciBub2RlLFxuICAgICAgICAgICAgICAgICAgaSxcbiAgICAgICAgICAgICAgICAgIGVsZW1zLFxuICAgICAgICAgICAgICAgICAgZWxlbSA9IGNvbnRleHQuZ2V0RWxlbWVudEJ5SWQoaWQpO1xuXG4gICAgICAgICAgICAgIGlmIChlbGVtKSB7XG4gICAgICAgICAgICAgICAgLy8gVmVyaWZ5IHRoZSBpZCBhdHRyaWJ1dGVcbiAgICAgICAgICAgICAgICBub2RlID0gZWxlbS5nZXRBdHRyaWJ1dGVOb2RlKFwiaWRcIik7XG5cbiAgICAgICAgICAgICAgICBpZiAobm9kZSAmJiBub2RlLnZhbHVlID09PSBpZCkge1xuICAgICAgICAgICAgICAgICAgcmV0dXJuIFtlbGVtXTtcbiAgICAgICAgICAgICAgICB9IC8vIEZhbGwgYmFjayBvbiBnZXRFbGVtZW50c0J5TmFtZVxuXG5cbiAgICAgICAgICAgICAgICBlbGVtcyA9IGNvbnRleHQuZ2V0RWxlbWVudHNCeU5hbWUoaWQpO1xuICAgICAgICAgICAgICAgIGkgPSAwO1xuXG4gICAgICAgICAgICAgICAgd2hpbGUgKGVsZW0gPSBlbGVtc1tpKytdKSB7XG4gICAgICAgICAgICAgICAgICBub2RlID0gZWxlbS5nZXRBdHRyaWJ1dGVOb2RlKFwiaWRcIik7XG5cbiAgICAgICAgICAgICAgICAgIGlmIChub2RlICYmIG5vZGUudmFsdWUgPT09IGlkKSB7XG4gICAgICAgICAgICAgICAgICAgIHJldHVybiBbZWxlbV07XG4gICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgcmV0dXJuIFtdO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH07XG4gICAgICAgIH0gLy8gVGFnXG5cblxuICAgICAgICBFeHByLmZpbmRbXCJUQUdcIl0gPSBzdXBwb3J0LmdldEVsZW1lbnRzQnlUYWdOYW1lID8gZnVuY3Rpb24gKHRhZywgY29udGV4dCkge1xuICAgICAgICAgIGlmICh0eXBlb2YgY29udGV4dC5nZXRFbGVtZW50c0J5VGFnTmFtZSAhPT0gXCJ1bmRlZmluZWRcIikge1xuICAgICAgICAgICAgcmV0dXJuIGNvbnRleHQuZ2V0RWxlbWVudHNCeVRhZ05hbWUodGFnKTsgLy8gRG9jdW1lbnRGcmFnbWVudCBub2RlcyBkb24ndCBoYXZlIGdFQlROXG4gICAgICAgICAgfSBlbHNlIGlmIChzdXBwb3J0LnFzYSkge1xuICAgICAgICAgICAgcmV0dXJuIGNvbnRleHQucXVlcnlTZWxlY3RvckFsbCh0YWcpO1xuICAgICAgICAgIH1cbiAgICAgICAgfSA6IGZ1bmN0aW9uICh0YWcsIGNvbnRleHQpIHtcbiAgICAgICAgICB2YXIgZWxlbSxcbiAgICAgICAgICAgICAgdG1wID0gW10sXG4gICAgICAgICAgICAgIGkgPSAwLFxuICAgICAgICAgICAgICAvLyBCeSBoYXBweSBjb2luY2lkZW5jZSwgYSAoYnJva2VuKSBnRUJUTiBhcHBlYXJzIG9uIERvY3VtZW50RnJhZ21lbnQgbm9kZXMgdG9vXG4gICAgICAgICAgcmVzdWx0cyA9IGNvbnRleHQuZ2V0RWxlbWVudHNCeVRhZ05hbWUodGFnKTsgLy8gRmlsdGVyIG91dCBwb3NzaWJsZSBjb21tZW50c1xuXG4gICAgICAgICAgaWYgKHRhZyA9PT0gXCIqXCIpIHtcbiAgICAgICAgICAgIHdoaWxlIChlbGVtID0gcmVzdWx0c1tpKytdKSB7XG4gICAgICAgICAgICAgIGlmIChlbGVtLm5vZGVUeXBlID09PSAxKSB7XG4gICAgICAgICAgICAgICAgdG1wLnB1c2goZWxlbSk7XG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgcmV0dXJuIHRtcDtcbiAgICAgICAgICB9XG5cbiAgICAgICAgICByZXR1cm4gcmVzdWx0cztcbiAgICAgICAgfTsgLy8gQ2xhc3NcblxuICAgICAgICBFeHByLmZpbmRbXCJDTEFTU1wiXSA9IHN1cHBvcnQuZ2V0RWxlbWVudHNCeUNsYXNzTmFtZSAmJiBmdW5jdGlvbiAoY2xhc3NOYW1lLCBjb250ZXh0KSB7XG4gICAgICAgICAgaWYgKHR5cGVvZiBjb250ZXh0LmdldEVsZW1lbnRzQnlDbGFzc05hbWUgIT09IFwidW5kZWZpbmVkXCIgJiYgZG9jdW1lbnRJc0hUTUwpIHtcbiAgICAgICAgICAgIHJldHVybiBjb250ZXh0LmdldEVsZW1lbnRzQnlDbGFzc05hbWUoY2xhc3NOYW1lKTtcbiAgICAgICAgICB9XG4gICAgICAgIH07XG4gICAgICAgIC8qIFFTQS9tYXRjaGVzU2VsZWN0b3JcbiAgICAgICAgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSAqL1xuICAgICAgICAvLyBRU0EgYW5kIG1hdGNoZXNTZWxlY3RvciBzdXBwb3J0XG4gICAgICAgIC8vIG1hdGNoZXNTZWxlY3Rvcig6YWN0aXZlKSByZXBvcnRzIGZhbHNlIHdoZW4gdHJ1ZSAoSUU5L09wZXJhIDExLjUpXG5cblxuICAgICAgICByYnVnZ3lNYXRjaGVzID0gW107IC8vIHFTYSg6Zm9jdXMpIHJlcG9ydHMgZmFsc2Ugd2hlbiB0cnVlIChDaHJvbWUgMjEpXG4gICAgICAgIC8vIFdlIGFsbG93IHRoaXMgYmVjYXVzZSBvZiBhIGJ1ZyBpbiBJRTgvOSB0aGF0IHRocm93cyBhbiBlcnJvclxuICAgICAgICAvLyB3aGVuZXZlciBgZG9jdW1lbnQuYWN0aXZlRWxlbWVudGAgaXMgYWNjZXNzZWQgb24gYW4gaWZyYW1lXG4gICAgICAgIC8vIFNvLCB3ZSBhbGxvdyA6Zm9jdXMgdG8gcGFzcyB0aHJvdWdoIFFTQSBhbGwgdGhlIHRpbWUgdG8gYXZvaWQgdGhlIElFIGVycm9yXG4gICAgICAgIC8vIFNlZSBodHRwczovL2J1Z3MuanF1ZXJ5LmNvbS90aWNrZXQvMTMzNzhcblxuICAgICAgICByYnVnZ3lRU0EgPSBbXTtcblxuICAgICAgICBpZiAoc3VwcG9ydC5xc2EgPSBybmF0aXZlLnRlc3QoZG9jdW1lbnQucXVlcnlTZWxlY3RvckFsbCkpIHtcbiAgICAgICAgICAvLyBCdWlsZCBRU0EgcmVnZXhcbiAgICAgICAgICAvLyBSZWdleCBzdHJhdGVneSBhZG9wdGVkIGZyb20gRGllZ28gUGVyaW5pXG4gICAgICAgICAgYXNzZXJ0KGZ1bmN0aW9uIChlbCkge1xuICAgICAgICAgICAgLy8gU2VsZWN0IGlzIHNldCB0byBlbXB0eSBzdHJpbmcgb24gcHVycG9zZVxuICAgICAgICAgICAgLy8gVGhpcyBpcyB0byB0ZXN0IElFJ3MgdHJlYXRtZW50IG9mIG5vdCBleHBsaWNpdGx5XG4gICAgICAgICAgICAvLyBzZXR0aW5nIGEgYm9vbGVhbiBjb250ZW50IGF0dHJpYnV0ZSxcbiAgICAgICAgICAgIC8vIHNpbmNlIGl0cyBwcmVzZW5jZSBzaG91bGQgYmUgZW5vdWdoXG4gICAgICAgICAgICAvLyBodHRwczovL2J1Z3MuanF1ZXJ5LmNvbS90aWNrZXQvMTIzNTlcbiAgICAgICAgICAgIGRvY0VsZW0uYXBwZW5kQ2hpbGQoZWwpLmlubmVySFRNTCA9IEFHUG9saWN5LmNyZWF0ZUhUTUwoXCI8YSBpZD0nXCIgKyBleHBhbmRvICsgXCInPjwvYT5cIiArIFwiPHNlbGVjdCBpZD0nXCIgKyBleHBhbmRvICsgXCItXFxyXFxcXCcgbXNhbGxvd2NhcHR1cmU9Jyc+XCIgKyBcIjxvcHRpb24gc2VsZWN0ZWQ9Jyc+PC9vcHRpb24+PC9zZWxlY3Q+XCIpOyAvLyBTdXBwb3J0OiBJRTgsIE9wZXJhIDExLTEyLjE2XG4gICAgICAgICAgICAvLyBOb3RoaW5nIHNob3VsZCBiZSBzZWxlY3RlZCB3aGVuIGVtcHR5IHN0cmluZ3MgZm9sbG93IF49IG9yICQ9IG9yICo9XG4gICAgICAgICAgICAvLyBUaGUgdGVzdCBhdHRyaWJ1dGUgbXVzdCBiZSB1bmtub3duIGluIE9wZXJhIGJ1dCBcInNhZmVcIiBmb3IgV2luUlRcbiAgICAgICAgICAgIC8vIGh0dHBzOi8vbXNkbi5taWNyb3NvZnQuY29tL2VuLXVzL2xpYnJhcnkvaWUvaGg0NjUzODguYXNweCNhdHRyaWJ1dGVfc2VjdGlvblxuXG4gICAgICAgICAgICBpZiAoZWwucXVlcnlTZWxlY3RvckFsbChcIlttc2FsbG93Y2FwdHVyZV49JyddXCIpLmxlbmd0aCkge1xuICAgICAgICAgICAgICByYnVnZ3lRU0EucHVzaChcIlsqXiRdPVwiICsgd2hpdGVzcGFjZSArIFwiKig/OicnfFxcXCJcXFwiKVwiKTtcbiAgICAgICAgICAgIH0gLy8gU3VwcG9ydDogSUU4XG4gICAgICAgICAgICAvLyBCb29sZWFuIGF0dHJpYnV0ZXMgYW5kIFwidmFsdWVcIiBhcmUgbm90IHRyZWF0ZWQgY29ycmVjdGx5XG5cblxuICAgICAgICAgICAgaWYgKCFlbC5xdWVyeVNlbGVjdG9yQWxsKFwiW3NlbGVjdGVkXVwiKS5sZW5ndGgpIHtcbiAgICAgICAgICAgICAgcmJ1Z2d5UVNBLnB1c2goXCJcXFxcW1wiICsgd2hpdGVzcGFjZSArIFwiKig/OnZhbHVlfFwiICsgYm9vbGVhbnMgKyBcIilcIik7XG4gICAgICAgICAgICB9IC8vIFN1cHBvcnQ6IENocm9tZTwyOSwgQW5kcm9pZDw0LjQsIFNhZmFyaTw3LjArLCBpT1M8Ny4wKywgUGhhbnRvbUpTPDEuOS44K1xuXG5cbiAgICAgICAgICAgIGlmICghZWwucXVlcnlTZWxlY3RvckFsbChcIltpZH49XCIgKyBleHBhbmRvICsgXCItXVwiKS5sZW5ndGgpIHtcbiAgICAgICAgICAgICAgcmJ1Z2d5UVNBLnB1c2goXCJ+PVwiKTtcbiAgICAgICAgICAgIH0gLy8gV2Via2l0L09wZXJhIC0gOmNoZWNrZWQgc2hvdWxkIHJldHVybiBzZWxlY3RlZCBvcHRpb24gZWxlbWVudHNcbiAgICAgICAgICAgIC8vIGh0dHA6Ly93d3cudzMub3JnL1RSLzIwMTEvUkVDLWNzczMtc2VsZWN0b3JzLTIwMTEwOTI5LyNjaGVja2VkXG4gICAgICAgICAgICAvLyBJRTggdGhyb3dzIGVycm9yIGhlcmUgYW5kIHdpbGwgbm90IHNlZSBsYXRlciB0ZXN0c1xuXG5cbiAgICAgICAgICAgIGlmICghZWwucXVlcnlTZWxlY3RvckFsbChcIjpjaGVja2VkXCIpLmxlbmd0aCkge1xuICAgICAgICAgICAgICByYnVnZ3lRU0EucHVzaChcIjpjaGVja2VkXCIpO1xuICAgICAgICAgICAgfSAvLyBTdXBwb3J0OiBTYWZhcmkgOCssIGlPUyA4K1xuICAgICAgICAgICAgLy8gaHR0cHM6Ly9idWdzLndlYmtpdC5vcmcvc2hvd19idWcuY2dpP2lkPTEzNjg1MVxuICAgICAgICAgICAgLy8gSW4tcGFnZSBgc2VsZWN0b3IjaWQgc2libGluZy1jb21iaW5hdG9yIHNlbGVjdG9yYCBmYWlsc1xuXG5cbiAgICAgICAgICAgIGlmICghZWwucXVlcnlTZWxlY3RvckFsbChcImEjXCIgKyBleHBhbmRvICsgXCIrKlwiKS5sZW5ndGgpIHtcbiAgICAgICAgICAgICAgcmJ1Z2d5UVNBLnB1c2goXCIuIy4rWyt+XVwiKTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9KTtcbiAgICAgICAgICBhc3NlcnQoZnVuY3Rpb24gKGVsKSB7XG4gICAgICAgICAgICBlbC5pbm5lckhUTUwgPSBBR1BvbGljeS5jcmVhdGVIVE1MKFwiPGEgaHJlZj0nJyBkaXNhYmxlZD0nZGlzYWJsZWQnPjwvYT5cIiArIFwiPHNlbGVjdCBkaXNhYmxlZD0nZGlzYWJsZWQnPjxvcHRpb24vPjwvc2VsZWN0PlwiKTsgLy8gU3VwcG9ydDogV2luZG93cyA4IE5hdGl2ZSBBcHBzXG4gICAgICAgICAgICAvLyBUaGUgdHlwZSBhbmQgbmFtZSBhdHRyaWJ1dGVzIGFyZSByZXN0cmljdGVkIGR1cmluZyAuaW5uZXJIVE1MIGFzc2lnbm1lbnRcblxuICAgICAgICAgICAgdmFyIGlucHV0ID0gZG9jdW1lbnQuY3JlYXRlRWxlbWVudChcImlucHV0XCIpO1xuICAgICAgICAgICAgaW5wdXQuc2V0QXR0cmlidXRlKFwidHlwZVwiLCBcImhpZGRlblwiKTtcbiAgICAgICAgICAgIGVsLmFwcGVuZENoaWxkKGlucHV0KS5zZXRBdHRyaWJ1dGUoXCJuYW1lXCIsIFwiRFwiKTsgLy8gU3VwcG9ydDogSUU4XG4gICAgICAgICAgICAvLyBFbmZvcmNlIGNhc2Utc2Vuc2l0aXZpdHkgb2YgbmFtZSBhdHRyaWJ1dGVcblxuICAgICAgICAgICAgaWYgKGVsLnF1ZXJ5U2VsZWN0b3JBbGwoXCJbbmFtZT1kXVwiKS5sZW5ndGgpIHtcbiAgICAgICAgICAgICAgcmJ1Z2d5UVNBLnB1c2goXCJuYW1lXCIgKyB3aGl0ZXNwYWNlICsgXCIqWypeJHwhfl0/PVwiKTtcbiAgICAgICAgICAgIH0gLy8gRkYgMy41IC0gOmVuYWJsZWQvOmRpc2FibGVkIGFuZCBoaWRkZW4gZWxlbWVudHMgKGhpZGRlbiBlbGVtZW50cyBhcmUgc3RpbGwgZW5hYmxlZClcbiAgICAgICAgICAgIC8vIElFOCB0aHJvd3MgZXJyb3IgaGVyZSBhbmQgd2lsbCBub3Qgc2VlIGxhdGVyIHRlc3RzXG5cblxuICAgICAgICAgICAgaWYgKGVsLnF1ZXJ5U2VsZWN0b3JBbGwoXCI6ZW5hYmxlZFwiKS5sZW5ndGggIT09IDIpIHtcbiAgICAgICAgICAgICAgcmJ1Z2d5UVNBLnB1c2goXCI6ZW5hYmxlZFwiLCBcIjpkaXNhYmxlZFwiKTtcbiAgICAgICAgICAgIH0gLy8gU3VwcG9ydDogSUU5LTExK1xuICAgICAgICAgICAgLy8gSUUncyA6ZGlzYWJsZWQgc2VsZWN0b3IgZG9lcyBub3QgcGljayB1cCB0aGUgY2hpbGRyZW4gb2YgZGlzYWJsZWQgZmllbGRzZXRzXG5cblxuICAgICAgICAgICAgZG9jRWxlbS5hcHBlbmRDaGlsZChlbCkuZGlzYWJsZWQgPSB0cnVlO1xuXG4gICAgICAgICAgICBpZiAoZWwucXVlcnlTZWxlY3RvckFsbChcIjpkaXNhYmxlZFwiKS5sZW5ndGggIT09IDIpIHtcbiAgICAgICAgICAgICAgcmJ1Z2d5UVNBLnB1c2goXCI6ZW5hYmxlZFwiLCBcIjpkaXNhYmxlZFwiKTtcbiAgICAgICAgICAgIH0gLy8gT3BlcmEgMTAtMTEgZG9lcyBub3QgdGhyb3cgb24gcG9zdC1jb21tYSBpbnZhbGlkIHBzZXVkb3NcblxuXG4gICAgICAgICAgICBlbC5xdWVyeVNlbGVjdG9yQWxsKFwiKiw6eFwiKTtcbiAgICAgICAgICAgIHJidWdneVFTQS5wdXNoKFwiLC4qOlwiKTtcbiAgICAgICAgICB9KTtcbiAgICAgICAgfVxuXG4gICAgICAgIGlmIChzdXBwb3J0Lm1hdGNoZXNTZWxlY3RvciA9IHJuYXRpdmUudGVzdChtYXRjaGVzID0gZG9jRWxlbS5tYXRjaGVzIHx8IGRvY0VsZW0ud2Via2l0TWF0Y2hlc1NlbGVjdG9yIHx8IGRvY0VsZW0ubW96TWF0Y2hlc1NlbGVjdG9yIHx8IGRvY0VsZW0ub01hdGNoZXNTZWxlY3RvciB8fCBkb2NFbGVtLm1zTWF0Y2hlc1NlbGVjdG9yKSkge1xuICAgICAgICAgIGFzc2VydChmdW5jdGlvbiAoZWwpIHtcbiAgICAgICAgICAgIC8vIENoZWNrIHRvIHNlZSBpZiBpdCdzIHBvc3NpYmxlIHRvIGRvIG1hdGNoZXNTZWxlY3RvclxuICAgICAgICAgICAgLy8gb24gYSBkaXNjb25uZWN0ZWQgbm9kZSAoSUUgOSlcbiAgICAgICAgICAgIHN1cHBvcnQuZGlzY29ubmVjdGVkTWF0Y2ggPSBtYXRjaGVzLmNhbGwoZWwsIFwiKlwiKTsgLy8gVGhpcyBzaG91bGQgZmFpbCB3aXRoIGFuIGV4Y2VwdGlvblxuICAgICAgICAgICAgLy8gR2Vja28gZG9lcyBub3QgZXJyb3IsIHJldHVybnMgZmFsc2UgaW5zdGVhZFxuXG4gICAgICAgICAgICBtYXRjaGVzLmNhbGwoZWwsIFwiW3MhPScnXTp4XCIpO1xuICAgICAgICAgICAgcmJ1Z2d5TWF0Y2hlcy5wdXNoKFwiIT1cIiwgcHNldWRvcyk7XG4gICAgICAgICAgfSk7XG4gICAgICAgIH1cblxuICAgICAgICByYnVnZ3lRU0EgPSByYnVnZ3lRU0EubGVuZ3RoICYmIG5ldyBSZWdFeHAocmJ1Z2d5UVNBLmpvaW4oXCJ8XCIpKTtcbiAgICAgICAgcmJ1Z2d5TWF0Y2hlcyA9IHJidWdneU1hdGNoZXMubGVuZ3RoICYmIG5ldyBSZWdFeHAocmJ1Z2d5TWF0Y2hlcy5qb2luKFwifFwiKSk7XG4gICAgICAgIC8qIENvbnRhaW5zXG4gICAgICAgIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0gKi9cblxuICAgICAgICBoYXNDb21wYXJlID0gcm5hdGl2ZS50ZXN0KGRvY0VsZW0uY29tcGFyZURvY3VtZW50UG9zaXRpb24pOyAvLyBFbGVtZW50IGNvbnRhaW5zIGFub3RoZXJcbiAgICAgICAgLy8gUHVycG9zZWZ1bGx5IHNlbGYtZXhjbHVzaXZlXG4gICAgICAgIC8vIEFzIGluLCBhbiBlbGVtZW50IGRvZXMgbm90IGNvbnRhaW4gaXRzZWxmXG5cbiAgICAgICAgY29udGFpbnMgPSBoYXNDb21wYXJlIHx8IHJuYXRpdmUudGVzdChkb2NFbGVtLmNvbnRhaW5zKSA/IGZ1bmN0aW9uIChhLCBiKSB7XG4gICAgICAgICAgdmFyIGFkb3duID0gYS5ub2RlVHlwZSA9PT0gOSA/IGEuZG9jdW1lbnRFbGVtZW50IDogYSxcbiAgICAgICAgICAgICAgYnVwID0gYiAmJiBiLnBhcmVudE5vZGU7XG4gICAgICAgICAgcmV0dXJuIGEgPT09IGJ1cCB8fCAhIShidXAgJiYgYnVwLm5vZGVUeXBlID09PSAxICYmIChhZG93bi5jb250YWlucyA/IGFkb3duLmNvbnRhaW5zKGJ1cCkgOiBhLmNvbXBhcmVEb2N1bWVudFBvc2l0aW9uICYmIGEuY29tcGFyZURvY3VtZW50UG9zaXRpb24oYnVwKSAmIDE2KSk7XG4gICAgICAgIH0gOiBmdW5jdGlvbiAoYSwgYikge1xuICAgICAgICAgIGlmIChiKSB7XG4gICAgICAgICAgICB3aGlsZSAoYiA9IGIucGFyZW50Tm9kZSkge1xuICAgICAgICAgICAgICBpZiAoYiA9PT0gYSkge1xuICAgICAgICAgICAgICAgIHJldHVybiB0cnVlO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgcmV0dXJuIGZhbHNlO1xuICAgICAgICB9O1xuICAgICAgICAvKiBTb3J0aW5nXG4gICAgICAgIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0gKi9cbiAgICAgICAgLy8gRG9jdW1lbnQgb3JkZXIgc29ydGluZ1xuXG4gICAgICAgIHNvcnRPcmRlciA9IGhhc0NvbXBhcmUgPyBmdW5jdGlvbiAoYSwgYikge1xuICAgICAgICAgIC8vIEZsYWcgZm9yIGR1cGxpY2F0ZSByZW1vdmFsXG4gICAgICAgICAgaWYgKGEgPT09IGIpIHtcbiAgICAgICAgICAgIGhhc0R1cGxpY2F0ZSA9IHRydWU7XG4gICAgICAgICAgICByZXR1cm4gMDtcbiAgICAgICAgICB9IC8vIFNvcnQgb24gbWV0aG9kIGV4aXN0ZW5jZSBpZiBvbmx5IG9uZSBpbnB1dCBoYXMgY29tcGFyZURvY3VtZW50UG9zaXRpb25cblxuXG4gICAgICAgICAgdmFyIGNvbXBhcmUgPSAhYS5jb21wYXJlRG9jdW1lbnRQb3NpdGlvbiAtICFiLmNvbXBhcmVEb2N1bWVudFBvc2l0aW9uO1xuXG4gICAgICAgICAgaWYgKGNvbXBhcmUpIHtcbiAgICAgICAgICAgIHJldHVybiBjb21wYXJlO1xuICAgICAgICAgIH0gLy8gQ2FsY3VsYXRlIHBvc2l0aW9uIGlmIGJvdGggaW5wdXRzIGJlbG9uZyB0byB0aGUgc2FtZSBkb2N1bWVudFxuXG5cbiAgICAgICAgICBjb21wYXJlID0gKGEub3duZXJEb2N1bWVudCB8fCBhKSA9PT0gKGIub3duZXJEb2N1bWVudCB8fCBiKSA/IGEuY29tcGFyZURvY3VtZW50UG9zaXRpb24oYikgOiAvLyBPdGhlcndpc2Ugd2Uga25vdyB0aGV5IGFyZSBkaXNjb25uZWN0ZWRcbiAgICAgICAgICAxOyAvLyBEaXNjb25uZWN0ZWQgbm9kZXNcblxuICAgICAgICAgIGlmIChjb21wYXJlICYgMSB8fCAhc3VwcG9ydC5zb3J0RGV0YWNoZWQgJiYgYi5jb21wYXJlRG9jdW1lbnRQb3NpdGlvbihhKSA9PT0gY29tcGFyZSkge1xuICAgICAgICAgICAgLy8gQ2hvb3NlIHRoZSBmaXJzdCBlbGVtZW50IHRoYXQgaXMgcmVsYXRlZCB0byBvdXIgcHJlZmVycmVkIGRvY3VtZW50XG4gICAgICAgICAgICBpZiAoYSA9PT0gZG9jdW1lbnQgfHwgYS5vd25lckRvY3VtZW50ID09PSBwcmVmZXJyZWREb2MgJiYgY29udGFpbnMocHJlZmVycmVkRG9jLCBhKSkge1xuICAgICAgICAgICAgICByZXR1cm4gLTE7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIGlmIChiID09PSBkb2N1bWVudCB8fCBiLm93bmVyRG9jdW1lbnQgPT09IHByZWZlcnJlZERvYyAmJiBjb250YWlucyhwcmVmZXJyZWREb2MsIGIpKSB7XG4gICAgICAgICAgICAgIHJldHVybiAxO1xuICAgICAgICAgICAgfSAvLyBNYWludGFpbiBvcmlnaW5hbCBvcmRlclxuXG5cbiAgICAgICAgICAgIHJldHVybiBzb3J0SW5wdXQgPyBpbmRleE9mKHNvcnRJbnB1dCwgYSkgLSBpbmRleE9mKHNvcnRJbnB1dCwgYikgOiAwO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIHJldHVybiBjb21wYXJlICYgNCA/IC0xIDogMTtcbiAgICAgICAgfSA6IGZ1bmN0aW9uIChhLCBiKSB7XG4gICAgICAgICAgLy8gRXhpdCBlYXJseSBpZiB0aGUgbm9kZXMgYXJlIGlkZW50aWNhbFxuICAgICAgICAgIGlmIChhID09PSBiKSB7XG4gICAgICAgICAgICBoYXNEdXBsaWNhdGUgPSB0cnVlO1xuICAgICAgICAgICAgcmV0dXJuIDA7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgdmFyIGN1cixcbiAgICAgICAgICAgICAgaSA9IDAsXG4gICAgICAgICAgICAgIGF1cCA9IGEucGFyZW50Tm9kZSxcbiAgICAgICAgICAgICAgYnVwID0gYi5wYXJlbnROb2RlLFxuICAgICAgICAgICAgICBhcCA9IFthXSxcbiAgICAgICAgICAgICAgYnAgPSBbYl07IC8vIFBhcmVudGxlc3Mgbm9kZXMgYXJlIGVpdGhlciBkb2N1bWVudHMgb3IgZGlzY29ubmVjdGVkXG5cbiAgICAgICAgICBpZiAoIWF1cCB8fCAhYnVwKSB7XG4gICAgICAgICAgICByZXR1cm4gYSA9PT0gZG9jdW1lbnQgPyAtMSA6IGIgPT09IGRvY3VtZW50ID8gMSA6IGF1cCA/IC0xIDogYnVwID8gMSA6IHNvcnRJbnB1dCA/IGluZGV4T2Yoc29ydElucHV0LCBhKSAtIGluZGV4T2Yoc29ydElucHV0LCBiKSA6IDA7IC8vIElmIHRoZSBub2RlcyBhcmUgc2libGluZ3MsIHdlIGNhbiBkbyBhIHF1aWNrIGNoZWNrXG4gICAgICAgICAgfSBlbHNlIGlmIChhdXAgPT09IGJ1cCkge1xuICAgICAgICAgICAgcmV0dXJuIHNpYmxpbmdDaGVjayhhLCBiKTtcbiAgICAgICAgICB9IC8vIE90aGVyd2lzZSB3ZSBuZWVkIGZ1bGwgbGlzdHMgb2YgdGhlaXIgYW5jZXN0b3JzIGZvciBjb21wYXJpc29uXG5cblxuICAgICAgICAgIGN1ciA9IGE7XG5cbiAgICAgICAgICB3aGlsZSAoY3VyID0gY3VyLnBhcmVudE5vZGUpIHtcbiAgICAgICAgICAgIGFwLnVuc2hpZnQoY3VyKTtcbiAgICAgICAgICB9XG5cbiAgICAgICAgICBjdXIgPSBiO1xuXG4gICAgICAgICAgd2hpbGUgKGN1ciA9IGN1ci5wYXJlbnROb2RlKSB7XG4gICAgICAgICAgICBicC51bnNoaWZ0KGN1cik7XG4gICAgICAgICAgfSAvLyBXYWxrIGRvd24gdGhlIHRyZWUgbG9va2luZyBmb3IgYSBkaXNjcmVwYW5jeVxuXG5cbiAgICAgICAgICB3aGlsZSAoYXBbaV0gPT09IGJwW2ldKSB7XG4gICAgICAgICAgICBpKys7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgcmV0dXJuIGkgPyAvLyBEbyBhIHNpYmxpbmcgY2hlY2sgaWYgdGhlIG5vZGVzIGhhdmUgYSBjb21tb24gYW5jZXN0b3JcbiAgICAgICAgICBzaWJsaW5nQ2hlY2soYXBbaV0sIGJwW2ldKSA6IC8vIE90aGVyd2lzZSBub2RlcyBpbiBvdXIgZG9jdW1lbnQgc29ydCBmaXJzdFxuICAgICAgICAgIGFwW2ldID09PSBwcmVmZXJyZWREb2MgPyAtMSA6IGJwW2ldID09PSBwcmVmZXJyZWREb2MgPyAxIDogMDtcbiAgICAgICAgfTtcbiAgICAgICAgcmV0dXJuIGRvY3VtZW50O1xuICAgICAgfTtcblxuICAgICAgU2l6emxlLm1hdGNoZXMgPSBmdW5jdGlvbiAoZXhwciwgZWxlbWVudHMpIHtcbiAgICAgICAgcmV0dXJuIFNpenpsZShleHByLCBudWxsLCBudWxsLCBlbGVtZW50cyk7XG4gICAgICB9O1xuXG4gICAgICBTaXp6bGUubWF0Y2hlc1NlbGVjdG9yID0gZnVuY3Rpb24gKGVsZW0sIGV4cHIpIHtcbiAgICAgICAgLy8gU2V0IGRvY3VtZW50IHZhcnMgaWYgbmVlZGVkXG4gICAgICAgIGlmICgoZWxlbS5vd25lckRvY3VtZW50IHx8IGVsZW0pICE9PSBkb2N1bWVudCkge1xuICAgICAgICAgIHNldERvY3VtZW50KGVsZW0pO1xuICAgICAgICB9XG5cbiAgICAgICAgaWYgKHN1cHBvcnQubWF0Y2hlc1NlbGVjdG9yICYmIGRvY3VtZW50SXNIVE1MICYmICFub25uYXRpdmVTZWxlY3RvckNhY2hlW2V4cHIgKyBcIiBcIl0gJiYgKCFyYnVnZ3lNYXRjaGVzIHx8ICFyYnVnZ3lNYXRjaGVzLnRlc3QoZXhwcikpICYmICghcmJ1Z2d5UVNBIHx8ICFyYnVnZ3lRU0EudGVzdChleHByKSkpIHtcbiAgICAgICAgICB0cnkge1xuICAgICAgICAgICAgdmFyIHJldCA9IG1hdGNoZXMuY2FsbChlbGVtLCBleHByKTsgLy8gSUUgOSdzIG1hdGNoZXNTZWxlY3RvciByZXR1cm5zIGZhbHNlIG9uIGRpc2Nvbm5lY3RlZCBub2Rlc1xuXG4gICAgICAgICAgICBpZiAocmV0IHx8IHN1cHBvcnQuZGlzY29ubmVjdGVkTWF0Y2ggfHwgLy8gQXMgd2VsbCwgZGlzY29ubmVjdGVkIG5vZGVzIGFyZSBzYWlkIHRvIGJlIGluIGEgZG9jdW1lbnRcbiAgICAgICAgICAgIC8vIGZyYWdtZW50IGluIElFIDlcbiAgICAgICAgICAgIGVsZW0uZG9jdW1lbnQgJiYgZWxlbS5kb2N1bWVudC5ub2RlVHlwZSAhPT0gMTEpIHtcbiAgICAgICAgICAgICAgcmV0dXJuIHJldDtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9IGNhdGNoIChlKSB7XG4gICAgICAgICAgICAvLyBbQWRHdWFyZCBQYXRoXTogRml4IHRoZSBjYWNoZSB2YWx1ZVxuICAgICAgICAgICAgbm9ubmF0aXZlU2VsZWN0b3JDYWNoZShleHByLCB0cnVlKTtcbiAgICAgICAgICB9XG4gICAgICAgIH1cblxuICAgICAgICByZXR1cm4gU2l6emxlKGV4cHIsIGRvY3VtZW50LCBudWxsLCBbZWxlbV0pLmxlbmd0aCA+IDA7XG4gICAgICB9O1xuXG4gICAgICBTaXp6bGUuY29udGFpbnMgPSBmdW5jdGlvbiAoY29udGV4dCwgZWxlbSkge1xuICAgICAgICAvLyBTZXQgZG9jdW1lbnQgdmFycyBpZiBuZWVkZWRcbiAgICAgICAgaWYgKChjb250ZXh0Lm93bmVyRG9jdW1lbnQgfHwgY29udGV4dCkgIT09IGRvY3VtZW50KSB7XG4gICAgICAgICAgc2V0RG9jdW1lbnQoY29udGV4dCk7XG4gICAgICAgIH1cblxuICAgICAgICByZXR1cm4gY29udGFpbnMoY29udGV4dCwgZWxlbSk7XG4gICAgICB9O1xuXG4gICAgICBTaXp6bGUuYXR0ciA9IGZ1bmN0aW9uIChlbGVtLCBuYW1lKSB7XG4gICAgICAgIC8vIFNldCBkb2N1bWVudCB2YXJzIGlmIG5lZWRlZFxuICAgICAgICBpZiAoKGVsZW0ub3duZXJEb2N1bWVudCB8fCBlbGVtKSAhPT0gZG9jdW1lbnQpIHtcbiAgICAgICAgICBzZXREb2N1bWVudChlbGVtKTtcbiAgICAgICAgfVxuXG4gICAgICAgIHZhciBmbiA9IEV4cHIuYXR0ckhhbmRsZVtuYW1lLnRvTG93ZXJDYXNlKCldLFxuICAgICAgICAgICAgLy8gRG9uJ3QgZ2V0IGZvb2xlZCBieSBPYmplY3QucHJvdG90eXBlIHByb3BlcnRpZXMgKGpRdWVyeSAjMTM4MDcpXG4gICAgICAgIHZhbCA9IGZuICYmIGhhc093bi5jYWxsKEV4cHIuYXR0ckhhbmRsZSwgbmFtZS50b0xvd2VyQ2FzZSgpKSA/IGZuKGVsZW0sIG5hbWUsICFkb2N1bWVudElzSFRNTCkgOiB1bmRlZmluZWQ7XG4gICAgICAgIHJldHVybiB2YWwgIT09IHVuZGVmaW5lZCA/IHZhbCA6IHN1cHBvcnQuYXR0cmlidXRlcyB8fCAhZG9jdW1lbnRJc0hUTUwgPyBlbGVtLmdldEF0dHJpYnV0ZShuYW1lKSA6ICh2YWwgPSBlbGVtLmdldEF0dHJpYnV0ZU5vZGUobmFtZSkpICYmIHZhbC5zcGVjaWZpZWQgPyB2YWwudmFsdWUgOiBudWxsO1xuICAgICAgfTtcblxuICAgICAgU2l6emxlLmVzY2FwZSA9IGZ1bmN0aW9uIChzZWwpIHtcbiAgICAgICAgcmV0dXJuIChzZWwgKyBcIlwiKS5yZXBsYWNlKHJjc3Nlc2NhcGUsIGZjc3Nlc2NhcGUpO1xuICAgICAgfTtcblxuICAgICAgU2l6emxlLmVycm9yID0gZnVuY3Rpb24gKG1zZykge1xuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJTeW50YXggZXJyb3IsIHVucmVjb2duaXplZCBleHByZXNzaW9uOiBcIiArIG1zZyk7XG4gICAgICB9O1xuICAgICAgLyoqXG4gICAgICAgKiBEb2N1bWVudCBzb3J0aW5nIGFuZCByZW1vdmluZyBkdXBsaWNhdGVzXG4gICAgICAgKiBAcGFyYW0ge0FycmF5TGlrZX0gcmVzdWx0c1xuICAgICAgICovXG5cblxuICAgICAgU2l6emxlLnVuaXF1ZVNvcnQgPSBmdW5jdGlvbiAocmVzdWx0cykge1xuICAgICAgICB2YXIgZWxlbSxcbiAgICAgICAgICAgIGR1cGxpY2F0ZXMgPSBbXSxcbiAgICAgICAgICAgIGogPSAwLFxuICAgICAgICAgICAgaSA9IDA7IC8vIFVubGVzcyB3ZSAqa25vdyogd2UgY2FuIGRldGVjdCBkdXBsaWNhdGVzLCBhc3N1bWUgdGhlaXIgcHJlc2VuY2VcblxuICAgICAgICBoYXNEdXBsaWNhdGUgPSAhc3VwcG9ydC5kZXRlY3REdXBsaWNhdGVzO1xuICAgICAgICBzb3J0SW5wdXQgPSAhc3VwcG9ydC5zb3J0U3RhYmxlICYmIHJlc3VsdHMuc2xpY2UoMCk7XG4gICAgICAgIHJlc3VsdHMuc29ydChzb3J0T3JkZXIpO1xuXG4gICAgICAgIGlmIChoYXNEdXBsaWNhdGUpIHtcbiAgICAgICAgICB3aGlsZSAoZWxlbSA9IHJlc3VsdHNbaSsrXSkge1xuICAgICAgICAgICAgaWYgKGVsZW0gPT09IHJlc3VsdHNbaV0pIHtcbiAgICAgICAgICAgICAgaiA9IGR1cGxpY2F0ZXMucHVzaChpKTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9XG5cbiAgICAgICAgICB3aGlsZSAoai0tKSB7XG4gICAgICAgICAgICByZXN1bHRzLnNwbGljZShkdXBsaWNhdGVzW2pdLCAxKTtcbiAgICAgICAgICB9XG4gICAgICAgIH0gLy8gQ2xlYXIgaW5wdXQgYWZ0ZXIgc29ydGluZyB0byByZWxlYXNlIG9iamVjdHNcbiAgICAgICAgLy8gU2VlIGh0dHBzOi8vZ2l0aHViLmNvbS9qcXVlcnkvc2l6emxlL3B1bGwvMjI1XG5cblxuICAgICAgICBzb3J0SW5wdXQgPSBudWxsO1xuICAgICAgICByZXR1cm4gcmVzdWx0cztcbiAgICAgIH07XG4gICAgICAvKipcbiAgICAgICAqIFV0aWxpdHkgZnVuY3Rpb24gZm9yIHJldHJpZXZpbmcgdGhlIHRleHQgdmFsdWUgb2YgYW4gYXJyYXkgb2YgRE9NIG5vZGVzXG4gICAgICAgKiBAcGFyYW0ge0FycmF5fEVsZW1lbnR9IGVsZW1cbiAgICAgICAqL1xuXG5cbiAgICAgIGdldFRleHQgPSBTaXp6bGUuZ2V0VGV4dCA9IGZ1bmN0aW9uIChlbGVtKSB7XG4gICAgICAgIHZhciBub2RlLFxuICAgICAgICAgICAgcmV0ID0gXCJcIixcbiAgICAgICAgICAgIGkgPSAwLFxuICAgICAgICAgICAgbm9kZVR5cGUgPSBlbGVtLm5vZGVUeXBlO1xuXG4gICAgICAgIGlmICghbm9kZVR5cGUpIHtcbiAgICAgICAgICAvLyBJZiBubyBub2RlVHlwZSwgdGhpcyBpcyBleHBlY3RlZCB0byBiZSBhbiBhcnJheVxuICAgICAgICAgIHdoaWxlIChub2RlID0gZWxlbVtpKytdKSB7XG4gICAgICAgICAgICAvLyBEbyBub3QgdHJhdmVyc2UgY29tbWVudCBub2Rlc1xuICAgICAgICAgICAgcmV0ICs9IGdldFRleHQobm9kZSk7XG4gICAgICAgICAgfVxuICAgICAgICB9IGVsc2UgaWYgKG5vZGVUeXBlID09PSAxIHx8IG5vZGVUeXBlID09PSA5IHx8IG5vZGVUeXBlID09PSAxMSkge1xuICAgICAgICAgIC8vIFVzZSB0ZXh0Q29udGVudCBmb3IgZWxlbWVudHNcbiAgICAgICAgICAvLyBpbm5lclRleHQgdXNhZ2UgcmVtb3ZlZCBmb3IgY29uc2lzdGVuY3kgb2YgbmV3IGxpbmVzIChqUXVlcnkgIzExMTUzKVxuICAgICAgICAgIGlmICh0eXBlb2YgZWxlbS50ZXh0Q29udGVudCA9PT0gXCJzdHJpbmdcIikge1xuICAgICAgICAgICAgcmV0dXJuIGVsZW0udGV4dENvbnRlbnQ7XG4gICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIC8vIFRyYXZlcnNlIGl0cyBjaGlsZHJlblxuICAgICAgICAgICAgZm9yIChlbGVtID0gZWxlbS5maXJzdENoaWxkOyBlbGVtOyBlbGVtID0gZWxlbS5uZXh0U2libGluZykge1xuICAgICAgICAgICAgICByZXQgKz0gZ2V0VGV4dChlbGVtKTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9XG4gICAgICAgIH0gZWxzZSBpZiAobm9kZVR5cGUgPT09IDMgfHwgbm9kZVR5cGUgPT09IDQpIHtcbiAgICAgICAgICByZXR1cm4gZWxlbS5ub2RlVmFsdWU7XG4gICAgICAgIH0gLy8gRG8gbm90IGluY2x1ZGUgY29tbWVudCBvciBwcm9jZXNzaW5nIGluc3RydWN0aW9uIG5vZGVzXG5cblxuICAgICAgICByZXR1cm4gcmV0O1xuICAgICAgfTtcblxuICAgICAgRXhwciA9IFNpenpsZS5zZWxlY3RvcnMgPSB7XG4gICAgICAgIC8vIENhbiBiZSBhZGp1c3RlZCBieSB0aGUgdXNlclxuICAgICAgICBjYWNoZUxlbmd0aDogNTAsXG4gICAgICAgIGNyZWF0ZVBzZXVkbzogbWFya0Z1bmN0aW9uLFxuICAgICAgICBtYXRjaDogbWF0Y2hFeHByLFxuICAgICAgICBhdHRySGFuZGxlOiB7fSxcbiAgICAgICAgZmluZDoge30sXG4gICAgICAgIHJlbGF0aXZlOiB7XG4gICAgICAgICAgXCI+XCI6IHtcbiAgICAgICAgICAgIGRpcjogXCJwYXJlbnROb2RlXCIsXG4gICAgICAgICAgICBmaXJzdDogdHJ1ZVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCIgXCI6IHtcbiAgICAgICAgICAgIGRpcjogXCJwYXJlbnROb2RlXCJcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiK1wiOiB7XG4gICAgICAgICAgICBkaXI6IFwicHJldmlvdXNTaWJsaW5nXCIsXG4gICAgICAgICAgICBmaXJzdDogdHJ1ZVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJ+XCI6IHtcbiAgICAgICAgICAgIGRpcjogXCJwcmV2aW91c1NpYmxpbmdcIlxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgcHJlRmlsdGVyOiB7XG4gICAgICAgICAgXCJBVFRSXCI6IGZ1bmN0aW9uIEFUVFIobWF0Y2gpIHtcbiAgICAgICAgICAgIG1hdGNoWzFdID0gbWF0Y2hbMV0ucmVwbGFjZShydW5lc2NhcGUsIGZ1bmVzY2FwZSk7IC8vIE1vdmUgdGhlIGdpdmVuIHZhbHVlIHRvIG1hdGNoWzNdIHdoZXRoZXIgcXVvdGVkIG9yIHVucXVvdGVkXG5cbiAgICAgICAgICAgIG1hdGNoWzNdID0gKG1hdGNoWzNdIHx8IG1hdGNoWzRdIHx8IG1hdGNoWzVdIHx8IFwiXCIpLnJlcGxhY2UocnVuZXNjYXBlLCBmdW5lc2NhcGUpO1xuXG4gICAgICAgICAgICBpZiAobWF0Y2hbMl0gPT09IFwifj1cIikge1xuICAgICAgICAgICAgICBtYXRjaFszXSA9IFwiIFwiICsgbWF0Y2hbM10gKyBcIiBcIjtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgcmV0dXJuIG1hdGNoLnNsaWNlKDAsIDQpO1xuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJDSElMRFwiOiBmdW5jdGlvbiBDSElMRChtYXRjaCkge1xuICAgICAgICAgICAgLyogbWF0Y2hlcyBmcm9tIG1hdGNoRXhwcltcIkNISUxEXCJdXG4gICAgICAgICAgICBcdDEgdHlwZSAob25seXxudGh8Li4uKVxuICAgICAgICAgICAgXHQyIHdoYXQgKGNoaWxkfG9mLXR5cGUpXG4gICAgICAgICAgICBcdDMgYXJndW1lbnQgKGV2ZW58b2RkfFxcZCp8XFxkKm4oWystXVxcZCspP3wuLi4pXG4gICAgICAgICAgICBcdDQgeG4tY29tcG9uZW50IG9mIHhuK3kgYXJndW1lbnQgKFsrLV0/XFxkKm58KVxuICAgICAgICAgICAgXHQ1IHNpZ24gb2YgeG4tY29tcG9uZW50XG4gICAgICAgICAgICBcdDYgeCBvZiB4bi1jb21wb25lbnRcbiAgICAgICAgICAgIFx0NyBzaWduIG9mIHktY29tcG9uZW50XG4gICAgICAgICAgICBcdDggeSBvZiB5LWNvbXBvbmVudFxuICAgICAgICAgICAgKi9cbiAgICAgICAgICAgIG1hdGNoWzFdID0gbWF0Y2hbMV0udG9Mb3dlckNhc2UoKTtcblxuICAgICAgICAgICAgaWYgKG1hdGNoWzFdLnNsaWNlKDAsIDMpID09PSBcIm50aFwiKSB7XG4gICAgICAgICAgICAgIC8vIG50aC0qIHJlcXVpcmVzIGFyZ3VtZW50XG4gICAgICAgICAgICAgIGlmICghbWF0Y2hbM10pIHtcbiAgICAgICAgICAgICAgICBTaXp6bGUuZXJyb3IobWF0Y2hbMF0pO1xuICAgICAgICAgICAgICB9IC8vIG51bWVyaWMgeCBhbmQgeSBwYXJhbWV0ZXJzIGZvciBFeHByLmZpbHRlci5DSElMRFxuICAgICAgICAgICAgICAvLyByZW1lbWJlciB0aGF0IGZhbHNlL3RydWUgY2FzdCByZXNwZWN0aXZlbHkgdG8gMC8xXG5cblxuICAgICAgICAgICAgICBtYXRjaFs0XSA9ICsobWF0Y2hbNF0gPyBtYXRjaFs1XSArIChtYXRjaFs2XSB8fCAxKSA6IDIgKiAobWF0Y2hbM10gPT09IFwiZXZlblwiIHx8IG1hdGNoWzNdID09PSBcIm9kZFwiKSk7XG4gICAgICAgICAgICAgIG1hdGNoWzVdID0gKyhtYXRjaFs3XSArIG1hdGNoWzhdIHx8IG1hdGNoWzNdID09PSBcIm9kZFwiKTsgLy8gb3RoZXIgdHlwZXMgcHJvaGliaXQgYXJndW1lbnRzXG4gICAgICAgICAgICB9IGVsc2UgaWYgKG1hdGNoWzNdKSB7XG4gICAgICAgICAgICAgIFNpenpsZS5lcnJvcihtYXRjaFswXSk7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIHJldHVybiBtYXRjaDtcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiUFNFVURPXCI6IGZ1bmN0aW9uIFBTRVVETyhtYXRjaCkge1xuICAgICAgICAgICAgdmFyIGV4Y2VzcyxcbiAgICAgICAgICAgICAgICB1bnF1b3RlZCA9ICFtYXRjaFs2XSAmJiBtYXRjaFsyXTtcblxuICAgICAgICAgICAgaWYgKG1hdGNoRXhwcltcIkNISUxEXCJdLnRlc3QobWF0Y2hbMF0pKSB7XG4gICAgICAgICAgICAgIHJldHVybiBudWxsO1xuICAgICAgICAgICAgfSAvLyBBY2NlcHQgcXVvdGVkIGFyZ3VtZW50cyBhcy1pc1xuXG5cbiAgICAgICAgICAgIGlmIChtYXRjaFszXSkge1xuICAgICAgICAgICAgICBtYXRjaFsyXSA9IG1hdGNoWzRdIHx8IG1hdGNoWzVdIHx8IFwiXCI7IC8vIFN0cmlwIGV4Y2VzcyBjaGFyYWN0ZXJzIGZyb20gdW5xdW90ZWQgYXJndW1lbnRzXG4gICAgICAgICAgICB9IGVsc2UgaWYgKHVucXVvdGVkICYmIHJwc2V1ZG8udGVzdCh1bnF1b3RlZCkgJiYgKCAvLyBHZXQgZXhjZXNzIGZyb20gdG9rZW5pemUgKHJlY3Vyc2l2ZWx5KVxuICAgICAgICAgICAgZXhjZXNzID0gdG9rZW5pemUodW5xdW90ZWQsIHRydWUpKSAmJiAoIC8vIGFkdmFuY2UgdG8gdGhlIG5leHQgY2xvc2luZyBwYXJlbnRoZXNpc1xuICAgICAgICAgICAgZXhjZXNzID0gdW5xdW90ZWQuaW5kZXhPZihcIilcIiwgdW5xdW90ZWQubGVuZ3RoIC0gZXhjZXNzKSAtIHVucXVvdGVkLmxlbmd0aCkpIHtcbiAgICAgICAgICAgICAgLy8gZXhjZXNzIGlzIGEgbmVnYXRpdmUgaW5kZXhcbiAgICAgICAgICAgICAgbWF0Y2hbMF0gPSBtYXRjaFswXS5zbGljZSgwLCBleGNlc3MpO1xuICAgICAgICAgICAgICBtYXRjaFsyXSA9IHVucXVvdGVkLnNsaWNlKDAsIGV4Y2Vzcyk7XG4gICAgICAgICAgICB9IC8vIFJldHVybiBvbmx5IGNhcHR1cmVzIG5lZWRlZCBieSB0aGUgcHNldWRvIGZpbHRlciBtZXRob2QgKHR5cGUgYW5kIGFyZ3VtZW50KVxuXG5cbiAgICAgICAgICAgIHJldHVybiBtYXRjaC5zbGljZSgwLCAzKTtcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIGZpbHRlcjoge1xuICAgICAgICAgIFwiVEFHXCI6IGZ1bmN0aW9uIFRBRyhub2RlTmFtZVNlbGVjdG9yKSB7XG4gICAgICAgICAgICB2YXIgbm9kZU5hbWUgPSBub2RlTmFtZVNlbGVjdG9yLnJlcGxhY2UocnVuZXNjYXBlLCBmdW5lc2NhcGUpLnRvTG93ZXJDYXNlKCk7XG4gICAgICAgICAgICByZXR1cm4gbm9kZU5hbWVTZWxlY3RvciA9PT0gXCIqXCIgPyBmdW5jdGlvbiAoKSB7XG4gICAgICAgICAgICAgIHJldHVybiB0cnVlO1xuICAgICAgICAgICAgfSA6IGZ1bmN0aW9uIChlbGVtKSB7XG4gICAgICAgICAgICAgIHJldHVybiBlbGVtLm5vZGVOYW1lICYmIGVsZW0ubm9kZU5hbWUudG9Mb3dlckNhc2UoKSA9PT0gbm9kZU5hbWU7XG4gICAgICAgICAgICB9O1xuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJDTEFTU1wiOiBmdW5jdGlvbiBDTEFTUyhjbGFzc05hbWUpIHtcbiAgICAgICAgICAgIHZhciBwYXR0ZXJuID0gY2xhc3NDYWNoZVtjbGFzc05hbWUgKyBcIiBcIl07XG4gICAgICAgICAgICByZXR1cm4gcGF0dGVybiB8fCAocGF0dGVybiA9IG5ldyBSZWdFeHAoXCIoXnxcIiArIHdoaXRlc3BhY2UgKyBcIilcIiArIGNsYXNzTmFtZSArIFwiKFwiICsgd2hpdGVzcGFjZSArIFwifCQpXCIpKSAmJiBjbGFzc0NhY2hlKGNsYXNzTmFtZSwgZnVuY3Rpb24gKGVsZW0pIHtcbiAgICAgICAgICAgICAgcmV0dXJuIHBhdHRlcm4udGVzdCh0eXBlb2YgZWxlbS5jbGFzc05hbWUgPT09IFwic3RyaW5nXCIgJiYgZWxlbS5jbGFzc05hbWUgfHwgdHlwZW9mIGVsZW0uZ2V0QXR0cmlidXRlICE9PSBcInVuZGVmaW5lZFwiICYmIGVsZW0uZ2V0QXR0cmlidXRlKFwiY2xhc3NcIikgfHwgXCJcIik7XG4gICAgICAgICAgICB9KTtcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiQVRUUlwiOiBmdW5jdGlvbiBBVFRSKG5hbWUsIG9wZXJhdG9yLCBjaGVjaykge1xuICAgICAgICAgICAgcmV0dXJuIGZ1bmN0aW9uIChlbGVtKSB7XG4gICAgICAgICAgICAgIHZhciByZXN1bHQgPSBTaXp6bGUuYXR0cihlbGVtLCBuYW1lKTtcblxuICAgICAgICAgICAgICBpZiAocmVzdWx0ID09IG51bGwpIHtcbiAgICAgICAgICAgICAgICByZXR1cm4gb3BlcmF0b3IgPT09IFwiIT1cIjtcbiAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgIGlmICghb3BlcmF0b3IpIHtcbiAgICAgICAgICAgICAgICByZXR1cm4gdHJ1ZTtcbiAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgIHJlc3VsdCArPSBcIlwiO1xuICAgICAgICAgICAgICByZXR1cm4gb3BlcmF0b3IgPT09IFwiPVwiID8gcmVzdWx0ID09PSBjaGVjayA6IG9wZXJhdG9yID09PSBcIiE9XCIgPyByZXN1bHQgIT09IGNoZWNrIDogb3BlcmF0b3IgPT09IFwiXj1cIiA/IGNoZWNrICYmIHJlc3VsdC5pbmRleE9mKGNoZWNrKSA9PT0gMCA6IG9wZXJhdG9yID09PSBcIio9XCIgPyBjaGVjayAmJiByZXN1bHQuaW5kZXhPZihjaGVjaykgPiAtMSA6IG9wZXJhdG9yID09PSBcIiQ9XCIgPyBjaGVjayAmJiByZXN1bHQuc2xpY2UoLWNoZWNrLmxlbmd0aCkgPT09IGNoZWNrIDogb3BlcmF0b3IgPT09IFwifj1cIiA/IChcIiBcIiArIHJlc3VsdC5yZXBsYWNlKHJ3aGl0ZXNwYWNlLCBcIiBcIikgKyBcIiBcIikuaW5kZXhPZihjaGVjaykgPiAtMSA6IG9wZXJhdG9yID09PSBcInw9XCIgPyByZXN1bHQgPT09IGNoZWNrIHx8IHJlc3VsdC5zbGljZSgwLCBjaGVjay5sZW5ndGggKyAxKSA9PT0gY2hlY2sgKyBcIi1cIiA6IGZhbHNlO1xuICAgICAgICAgICAgfTtcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiQ0hJTERcIjogZnVuY3Rpb24gQ0hJTEQodHlwZSwgd2hhdCwgYXJndW1lbnQsIGZpcnN0LCBsYXN0KSB7XG4gICAgICAgICAgICB2YXIgc2ltcGxlID0gdHlwZS5zbGljZSgwLCAzKSAhPT0gXCJudGhcIixcbiAgICAgICAgICAgICAgICBmb3J3YXJkID0gdHlwZS5zbGljZSgtNCkgIT09IFwibGFzdFwiLFxuICAgICAgICAgICAgICAgIG9mVHlwZSA9IHdoYXQgPT09IFwib2YtdHlwZVwiO1xuICAgICAgICAgICAgcmV0dXJuIGZpcnN0ID09PSAxICYmIGxhc3QgPT09IDAgPyAvLyBTaG9ydGN1dCBmb3IgOm50aC0qKG4pXG4gICAgICAgICAgICBmdW5jdGlvbiAoZWxlbSkge1xuICAgICAgICAgICAgICByZXR1cm4gISFlbGVtLnBhcmVudE5vZGU7XG4gICAgICAgICAgICB9IDogZnVuY3Rpb24gKGVsZW0sIGNvbnRleHQsIHhtbCkge1xuICAgICAgICAgICAgICB2YXIgY2FjaGUsXG4gICAgICAgICAgICAgICAgICB1bmlxdWVDYWNoZSxcbiAgICAgICAgICAgICAgICAgIG91dGVyQ2FjaGUsXG4gICAgICAgICAgICAgICAgICBub2RlLFxuICAgICAgICAgICAgICAgICAgbm9kZUluZGV4LFxuICAgICAgICAgICAgICAgICAgc3RhcnQsXG4gICAgICAgICAgICAgICAgICBkaXIgPSBzaW1wbGUgIT09IGZvcndhcmQgPyBcIm5leHRTaWJsaW5nXCIgOiBcInByZXZpb3VzU2libGluZ1wiLFxuICAgICAgICAgICAgICAgICAgcGFyZW50ID0gZWxlbS5wYXJlbnROb2RlLFxuICAgICAgICAgICAgICAgICAgbmFtZSA9IG9mVHlwZSAmJiBlbGVtLm5vZGVOYW1lLnRvTG93ZXJDYXNlKCksXG4gICAgICAgICAgICAgICAgICB1c2VDYWNoZSA9ICF4bWwgJiYgIW9mVHlwZSxcbiAgICAgICAgICAgICAgICAgIGRpZmYgPSBmYWxzZTtcblxuICAgICAgICAgICAgICBpZiAocGFyZW50KSB7XG4gICAgICAgICAgICAgICAgLy8gOihmaXJzdHxsYXN0fG9ubHkpLShjaGlsZHxvZi10eXBlKVxuICAgICAgICAgICAgICAgIGlmIChzaW1wbGUpIHtcbiAgICAgICAgICAgICAgICAgIHdoaWxlIChkaXIpIHtcbiAgICAgICAgICAgICAgICAgICAgbm9kZSA9IGVsZW07XG5cbiAgICAgICAgICAgICAgICAgICAgd2hpbGUgKG5vZGUgPSBub2RlW2Rpcl0pIHtcbiAgICAgICAgICAgICAgICAgICAgICBpZiAob2ZUeXBlID8gbm9kZS5ub2RlTmFtZS50b0xvd2VyQ2FzZSgpID09PSBuYW1lIDogbm9kZS5ub2RlVHlwZSA9PT0gMSkge1xuICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIGZhbHNlO1xuICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgfSAvLyBSZXZlcnNlIGRpcmVjdGlvbiBmb3IgOm9ubHktKiAoaWYgd2UgaGF2ZW4ndCB5ZXQgZG9uZSBzbylcblxuXG4gICAgICAgICAgICAgICAgICAgIHN0YXJ0ID0gZGlyID0gdHlwZSA9PT0gXCJvbmx5XCIgJiYgIXN0YXJ0ICYmIFwibmV4dFNpYmxpbmdcIjtcbiAgICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgICAgcmV0dXJuIHRydWU7XG4gICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgc3RhcnQgPSBbZm9yd2FyZCA/IHBhcmVudC5maXJzdENoaWxkIDogcGFyZW50Lmxhc3RDaGlsZF07IC8vIG5vbi14bWwgOm50aC1jaGlsZCguLi4pIHN0b3JlcyBjYWNoZSBkYXRhIG9uIGBwYXJlbnRgXG5cbiAgICAgICAgICAgICAgICBpZiAoZm9yd2FyZCAmJiB1c2VDYWNoZSkge1xuICAgICAgICAgICAgICAgICAgLy8gU2VlayBgZWxlbWAgZnJvbSBhIHByZXZpb3VzbHktY2FjaGVkIGluZGV4XG4gICAgICAgICAgICAgICAgICAvLyAuLi5pbiBhIGd6aXAtZnJpZW5kbHkgd2F5XG4gICAgICAgICAgICAgICAgICBub2RlID0gcGFyZW50O1xuICAgICAgICAgICAgICAgICAgb3V0ZXJDYWNoZSA9IG5vZGVbZXhwYW5kb10gfHwgKG5vZGVbZXhwYW5kb10gPSB7fSk7IC8vIFN1cHBvcnQ6IElFIDw5IG9ubHlcbiAgICAgICAgICAgICAgICAgIC8vIERlZmVuZCBhZ2FpbnN0IGNsb25lZCBhdHRyb3BlcnRpZXMgKGpRdWVyeSBnaC0xNzA5KVxuXG4gICAgICAgICAgICAgICAgICB1bmlxdWVDYWNoZSA9IG91dGVyQ2FjaGVbbm9kZS51bmlxdWVJRF0gfHwgKG91dGVyQ2FjaGVbbm9kZS51bmlxdWVJRF0gPSB7fSk7XG4gICAgICAgICAgICAgICAgICBjYWNoZSA9IHVuaXF1ZUNhY2hlW3R5cGVdIHx8IFtdO1xuICAgICAgICAgICAgICAgICAgbm9kZUluZGV4ID0gY2FjaGVbMF0gPT09IGRpcnJ1bnMgJiYgY2FjaGVbMV07XG4gICAgICAgICAgICAgICAgICBkaWZmID0gbm9kZUluZGV4ICYmIGNhY2hlWzJdO1xuICAgICAgICAgICAgICAgICAgbm9kZSA9IG5vZGVJbmRleCAmJiBwYXJlbnQuY2hpbGROb2Rlc1tub2RlSW5kZXhdO1xuXG4gICAgICAgICAgICAgICAgICB3aGlsZSAobm9kZSA9ICsrbm9kZUluZGV4ICYmIG5vZGUgJiYgbm9kZVtkaXJdIHx8ICggLy8gRmFsbGJhY2sgdG8gc2Vla2luZyBgZWxlbWAgZnJvbSB0aGUgc3RhcnRcbiAgICAgICAgICAgICAgICAgIGRpZmYgPSBub2RlSW5kZXggPSAwKSB8fCBzdGFydC5wb3AoKSkge1xuICAgICAgICAgICAgICAgICAgICAvLyBXaGVuIGZvdW5kLCBjYWNoZSBpbmRleGVzIG9uIGBwYXJlbnRgIGFuZCBicmVha1xuICAgICAgICAgICAgICAgICAgICBpZiAobm9kZS5ub2RlVHlwZSA9PT0gMSAmJiArK2RpZmYgJiYgbm9kZSA9PT0gZWxlbSkge1xuICAgICAgICAgICAgICAgICAgICAgIHVuaXF1ZUNhY2hlW3R5cGVdID0gW2RpcnJ1bnMsIG5vZGVJbmRleCwgZGlmZl07XG4gICAgICAgICAgICAgICAgICAgICAgYnJlYWs7XG4gICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICAgICAgLy8gVXNlIHByZXZpb3VzbHktY2FjaGVkIGVsZW1lbnQgaW5kZXggaWYgYXZhaWxhYmxlXG4gICAgICAgICAgICAgICAgICBpZiAodXNlQ2FjaGUpIHtcbiAgICAgICAgICAgICAgICAgICAgLy8gLi4uaW4gYSBnemlwLWZyaWVuZGx5IHdheVxuICAgICAgICAgICAgICAgICAgICBub2RlID0gZWxlbTtcbiAgICAgICAgICAgICAgICAgICAgb3V0ZXJDYWNoZSA9IG5vZGVbZXhwYW5kb10gfHwgKG5vZGVbZXhwYW5kb10gPSB7fSk7IC8vIFN1cHBvcnQ6IElFIDw5IG9ubHlcbiAgICAgICAgICAgICAgICAgICAgLy8gRGVmZW5kIGFnYWluc3QgY2xvbmVkIGF0dHJvcGVydGllcyAoalF1ZXJ5IGdoLTE3MDkpXG5cbiAgICAgICAgICAgICAgICAgICAgdW5pcXVlQ2FjaGUgPSBvdXRlckNhY2hlW25vZGUudW5pcXVlSURdIHx8IChvdXRlckNhY2hlW25vZGUudW5pcXVlSURdID0ge30pO1xuICAgICAgICAgICAgICAgICAgICBjYWNoZSA9IHVuaXF1ZUNhY2hlW3R5cGVdIHx8IFtdO1xuICAgICAgICAgICAgICAgICAgICBub2RlSW5kZXggPSBjYWNoZVswXSA9PT0gZGlycnVucyAmJiBjYWNoZVsxXTtcbiAgICAgICAgICAgICAgICAgICAgZGlmZiA9IG5vZGVJbmRleDtcbiAgICAgICAgICAgICAgICAgIH0gLy8geG1sIDpudGgtY2hpbGQoLi4uKVxuICAgICAgICAgICAgICAgICAgLy8gb3IgOm50aC1sYXN0LWNoaWxkKC4uLikgb3IgOm50aCgtbGFzdCk/LW9mLXR5cGUoLi4uKVxuXG5cbiAgICAgICAgICAgICAgICAgIGlmIChkaWZmID09PSBmYWxzZSkge1xuICAgICAgICAgICAgICAgICAgICAvLyBVc2UgdGhlIHNhbWUgbG9vcCBhcyBhYm92ZSB0byBzZWVrIGBlbGVtYCBmcm9tIHRoZSBzdGFydFxuICAgICAgICAgICAgICAgICAgICB3aGlsZSAobm9kZSA9ICsrbm9kZUluZGV4ICYmIG5vZGUgJiYgbm9kZVtkaXJdIHx8IChkaWZmID0gbm9kZUluZGV4ID0gMCkgfHwgc3RhcnQucG9wKCkpIHtcbiAgICAgICAgICAgICAgICAgICAgICBpZiAoKG9mVHlwZSA/IG5vZGUubm9kZU5hbWUudG9Mb3dlckNhc2UoKSA9PT0gbmFtZSA6IG5vZGUubm9kZVR5cGUgPT09IDEpICYmICsrZGlmZikge1xuICAgICAgICAgICAgICAgICAgICAgICAgLy8gQ2FjaGUgdGhlIGluZGV4IG9mIGVhY2ggZW5jb3VudGVyZWQgZWxlbWVudFxuICAgICAgICAgICAgICAgICAgICAgICAgaWYgKHVzZUNhY2hlKSB7XG4gICAgICAgICAgICAgICAgICAgICAgICAgIG91dGVyQ2FjaGUgPSBub2RlW2V4cGFuZG9dIHx8IChub2RlW2V4cGFuZG9dID0ge30pOyAvLyBTdXBwb3J0OiBJRSA8OSBvbmx5XG4gICAgICAgICAgICAgICAgICAgICAgICAgIC8vIERlZmVuZCBhZ2FpbnN0IGNsb25lZCBhdHRyb3BlcnRpZXMgKGpRdWVyeSBnaC0xNzA5KVxuXG4gICAgICAgICAgICAgICAgICAgICAgICAgIHVuaXF1ZUNhY2hlID0gb3V0ZXJDYWNoZVtub2RlLnVuaXF1ZUlEXSB8fCAob3V0ZXJDYWNoZVtub2RlLnVuaXF1ZUlEXSA9IHt9KTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgdW5pcXVlQ2FjaGVbdHlwZV0gPSBbZGlycnVucywgZGlmZl07XG4gICAgICAgICAgICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgICAgICAgICAgIGlmIChub2RlID09PSBlbGVtKSB7XG4gICAgICAgICAgICAgICAgICAgICAgICAgIGJyZWFrO1xuICAgICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIH0gLy8gSW5jb3Jwb3JhdGUgdGhlIG9mZnNldCwgdGhlbiBjaGVjayBhZ2FpbnN0IGN5Y2xlIHNpemVcblxuXG4gICAgICAgICAgICAgICAgZGlmZiAtPSBsYXN0O1xuICAgICAgICAgICAgICAgIHJldHVybiBkaWZmID09PSBmaXJzdCB8fCBkaWZmICUgZmlyc3QgPT09IDAgJiYgZGlmZiAvIGZpcnN0ID49IDA7XG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH07XG4gICAgICAgICAgfSxcbiAgICAgICAgICBcIlBTRVVET1wiOiBmdW5jdGlvbiBQU0VVRE8ocHNldWRvLCBhcmd1bWVudCkge1xuICAgICAgICAgICAgLy8gcHNldWRvLWNsYXNzIG5hbWVzIGFyZSBjYXNlLWluc2Vuc2l0aXZlXG4gICAgICAgICAgICAvLyBodHRwOi8vd3d3LnczLm9yZy9UUi9zZWxlY3RvcnMvI3BzZXVkby1jbGFzc2VzXG4gICAgICAgICAgICAvLyBQcmlvcml0aXplIGJ5IGNhc2Ugc2Vuc2l0aXZpdHkgaW4gY2FzZSBjdXN0b20gcHNldWRvcyBhcmUgYWRkZWQgd2l0aCB1cHBlcmNhc2UgbGV0dGVyc1xuICAgICAgICAgICAgLy8gUmVtZW1iZXIgdGhhdCBzZXRGaWx0ZXJzIGluaGVyaXRzIGZyb20gcHNldWRvc1xuICAgICAgICAgICAgdmFyIGFyZ3MsXG4gICAgICAgICAgICAgICAgZm4gPSBFeHByLnBzZXVkb3NbcHNldWRvXSB8fCBFeHByLnNldEZpbHRlcnNbcHNldWRvLnRvTG93ZXJDYXNlKCldIHx8IFNpenpsZS5lcnJvcihcInVuc3VwcG9ydGVkIHBzZXVkbzogXCIgKyBwc2V1ZG8pOyAvLyBUaGUgdXNlciBtYXkgdXNlIGNyZWF0ZVBzZXVkbyB0byBpbmRpY2F0ZSB0aGF0XG4gICAgICAgICAgICAvLyBhcmd1bWVudHMgYXJlIG5lZWRlZCB0byBjcmVhdGUgdGhlIGZpbHRlciBmdW5jdGlvblxuICAgICAgICAgICAgLy8ganVzdCBhcyBTaXp6bGUgZG9lc1xuXG4gICAgICAgICAgICBpZiAoZm5bZXhwYW5kb10pIHtcbiAgICAgICAgICAgICAgcmV0dXJuIGZuKGFyZ3VtZW50KTtcbiAgICAgICAgICAgIH0gLy8gQnV0IG1haW50YWluIHN1cHBvcnQgZm9yIG9sZCBzaWduYXR1cmVzXG5cblxuICAgICAgICAgICAgaWYgKGZuLmxlbmd0aCA+IDEpIHtcbiAgICAgICAgICAgICAgYXJncyA9IFtwc2V1ZG8sIHBzZXVkbywgXCJcIiwgYXJndW1lbnRdO1xuICAgICAgICAgICAgICByZXR1cm4gRXhwci5zZXRGaWx0ZXJzLmhhc093blByb3BlcnR5KHBzZXVkby50b0xvd2VyQ2FzZSgpKSA/IG1hcmtGdW5jdGlvbihmdW5jdGlvbiAoc2VlZCwgbWF0Y2hlcykge1xuICAgICAgICAgICAgICAgIHZhciBpZHgsXG4gICAgICAgICAgICAgICAgICAgIG1hdGNoZWQgPSBmbihzZWVkLCBhcmd1bWVudCksXG4gICAgICAgICAgICAgICAgICAgIGkgPSBtYXRjaGVkLmxlbmd0aDtcblxuICAgICAgICAgICAgICAgIHdoaWxlIChpLS0pIHtcbiAgICAgICAgICAgICAgICAgIGlkeCA9IGluZGV4T2Yoc2VlZCwgbWF0Y2hlZFtpXSk7XG4gICAgICAgICAgICAgICAgICBzZWVkW2lkeF0gPSAhKG1hdGNoZXNbaWR4XSA9IG1hdGNoZWRbaV0pO1xuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgfSkgOiBmdW5jdGlvbiAoZWxlbSkge1xuICAgICAgICAgICAgICAgIHJldHVybiBmbihlbGVtLCAwLCBhcmdzKTtcbiAgICAgICAgICAgICAgfTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgcmV0dXJuIGZuO1xuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgcHNldWRvczoge1xuICAgICAgICAgIC8vIFBvdGVudGlhbGx5IGNvbXBsZXggcHNldWRvc1xuICAgICAgICAgIFwibm90XCI6IG1hcmtGdW5jdGlvbihmdW5jdGlvbiAoc2VsZWN0b3IpIHtcbiAgICAgICAgICAgIC8vIFRyaW0gdGhlIHNlbGVjdG9yIHBhc3NlZCB0byBjb21waWxlXG4gICAgICAgICAgICAvLyB0byBhdm9pZCB0cmVhdGluZyBsZWFkaW5nIGFuZCB0cmFpbGluZ1xuICAgICAgICAgICAgLy8gc3BhY2VzIGFzIGNvbWJpbmF0b3JzXG4gICAgICAgICAgICB2YXIgaW5wdXQgPSBbXSxcbiAgICAgICAgICAgICAgICByZXN1bHRzID0gW10sXG4gICAgICAgICAgICAgICAgbWF0Y2hlciA9IGNvbXBpbGUoc2VsZWN0b3IucmVwbGFjZShydHJpbSwgXCIkMVwiKSk7XG4gICAgICAgICAgICByZXR1cm4gbWF0Y2hlcltleHBhbmRvXSA/IG1hcmtGdW5jdGlvbihmdW5jdGlvbiAoc2VlZCwgbWF0Y2hlcywgY29udGV4dCwgeG1sKSB7XG4gICAgICAgICAgICAgIHZhciBlbGVtLFxuICAgICAgICAgICAgICAgICAgdW5tYXRjaGVkID0gbWF0Y2hlcihzZWVkLCBudWxsLCB4bWwsIFtdKSxcbiAgICAgICAgICAgICAgICAgIGkgPSBzZWVkLmxlbmd0aDsgLy8gTWF0Y2ggZWxlbWVudHMgdW5tYXRjaGVkIGJ5IGBtYXRjaGVyYFxuXG4gICAgICAgICAgICAgIHdoaWxlIChpLS0pIHtcbiAgICAgICAgICAgICAgICBpZiAoZWxlbSA9IHVubWF0Y2hlZFtpXSkge1xuICAgICAgICAgICAgICAgICAgc2VlZFtpXSA9ICEobWF0Y2hlc1tpXSA9IGVsZW0pO1xuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfSkgOiBmdW5jdGlvbiAoZWxlbSwgY29udGV4dCwgeG1sKSB7XG4gICAgICAgICAgICAgIGlucHV0WzBdID0gZWxlbTtcbiAgICAgICAgICAgICAgbWF0Y2hlcihpbnB1dCwgbnVsbCwgeG1sLCByZXN1bHRzKTsgLy8gRG9uJ3Qga2VlcCB0aGUgZWxlbWVudCAoaXNzdWUgIzI5OSlcblxuICAgICAgICAgICAgICBpbnB1dFswXSA9IG51bGw7XG4gICAgICAgICAgICAgIHJldHVybiAhcmVzdWx0cy5wb3AoKTtcbiAgICAgICAgICAgIH07XG4gICAgICAgICAgfSksXG4gICAgICAgICAgXCJoYXNcIjogbWFya0Z1bmN0aW9uKGZ1bmN0aW9uIChzZWxlY3Rvcikge1xuICAgICAgICAgICAgaWYgKHR5cGVvZiBzZWxlY3RvciA9PT0gXCJzdHJpbmdcIikge1xuICAgICAgICAgICAgICBTaXp6bGUuY29tcGlsZShzZWxlY3Rvcik7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIHJldHVybiBmdW5jdGlvbiAoZWxlbSkge1xuICAgICAgICAgICAgICByZXR1cm4gU2l6emxlKHNlbGVjdG9yLCBlbGVtKS5sZW5ndGggPiAwO1xuICAgICAgICAgICAgfTtcbiAgICAgICAgICB9KSxcbiAgICAgICAgICAvLyBSZW1vdmVkIDpjb250YWlucyBwc2V1ZG8tY2xhc3MgZGVjbGFyYXRpb25cbiAgICAgICAgICAvLyBcIldoZXRoZXIgYW4gZWxlbWVudCBpcyByZXByZXNlbnRlZCBieSBhIDpsYW5nKCkgc2VsZWN0b3JcbiAgICAgICAgICAvLyBpcyBiYXNlZCBzb2xlbHkgb24gdGhlIGVsZW1lbnQncyBsYW5ndWFnZSB2YWx1ZVxuICAgICAgICAgIC8vIGJlaW5nIGVxdWFsIHRvIHRoZSBpZGVudGlmaWVyIEMsXG4gICAgICAgICAgLy8gb3IgYmVnaW5uaW5nIHdpdGggdGhlIGlkZW50aWZpZXIgQyBpbW1lZGlhdGVseSBmb2xsb3dlZCBieSBcIi1cIi5cbiAgICAgICAgICAvLyBUaGUgbWF0Y2hpbmcgb2YgQyBhZ2FpbnN0IHRoZSBlbGVtZW50J3MgbGFuZ3VhZ2UgdmFsdWUgaXMgcGVyZm9ybWVkIGNhc2UtaW5zZW5zaXRpdmVseS5cbiAgICAgICAgICAvLyBUaGUgaWRlbnRpZmllciBDIGRvZXMgbm90IGhhdmUgdG8gYmUgYSB2YWxpZCBsYW5ndWFnZSBuYW1lLlwiXG4gICAgICAgICAgLy8gaHR0cDovL3d3dy53My5vcmcvVFIvc2VsZWN0b3JzLyNsYW5nLXBzZXVkb1xuICAgICAgICAgIFwibGFuZ1wiOiBtYXJrRnVuY3Rpb24oZnVuY3Rpb24gKGxhbmcpIHtcbiAgICAgICAgICAgIC8vIGxhbmcgdmFsdWUgbXVzdCBiZSBhIHZhbGlkIGlkZW50aWZpZXJcbiAgICAgICAgICAgIGlmICghcmlkZW50aWZpZXIudGVzdChsYW5nIHx8IFwiXCIpKSB7XG4gICAgICAgICAgICAgIFNpenpsZS5lcnJvcihcInVuc3VwcG9ydGVkIGxhbmc6IFwiICsgbGFuZyk7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIGxhbmcgPSBsYW5nLnJlcGxhY2UocnVuZXNjYXBlLCBmdW5lc2NhcGUpLnRvTG93ZXJDYXNlKCk7XG4gICAgICAgICAgICByZXR1cm4gZnVuY3Rpb24gKGVsZW0pIHtcbiAgICAgICAgICAgICAgdmFyIGVsZW1MYW5nO1xuXG4gICAgICAgICAgICAgIGRvIHtcbiAgICAgICAgICAgICAgICBpZiAoZWxlbUxhbmcgPSBkb2N1bWVudElzSFRNTCA/IGVsZW0ubGFuZyA6IGVsZW0uZ2V0QXR0cmlidXRlKFwieG1sOmxhbmdcIikgfHwgZWxlbS5nZXRBdHRyaWJ1dGUoXCJsYW5nXCIpKSB7XG4gICAgICAgICAgICAgICAgICBlbGVtTGFuZyA9IGVsZW1MYW5nLnRvTG93ZXJDYXNlKCk7XG4gICAgICAgICAgICAgICAgICByZXR1cm4gZWxlbUxhbmcgPT09IGxhbmcgfHwgZWxlbUxhbmcuaW5kZXhPZihsYW5nICsgXCItXCIpID09PSAwO1xuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgfSB3aGlsZSAoKGVsZW0gPSBlbGVtLnBhcmVudE5vZGUpICYmIGVsZW0ubm9kZVR5cGUgPT09IDEpO1xuXG4gICAgICAgICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgICAgICAgIH07XG4gICAgICAgICAgfSksXG4gICAgICAgICAgLy8gTWlzY2VsbGFuZW91c1xuICAgICAgICAgIFwidGFyZ2V0XCI6IGZ1bmN0aW9uIHRhcmdldChlbGVtKSB7XG4gICAgICAgICAgICB2YXIgaGFzaCA9IHdpbmRvdy5sb2NhdGlvbiAmJiB3aW5kb3cubG9jYXRpb24uaGFzaDtcbiAgICAgICAgICAgIHJldHVybiBoYXNoICYmIGhhc2guc2xpY2UoMSkgPT09IGVsZW0uaWQ7XG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJvb3RcIjogZnVuY3Rpb24gcm9vdChlbGVtKSB7XG4gICAgICAgICAgICByZXR1cm4gZWxlbSA9PT0gZG9jRWxlbTtcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZm9jdXNcIjogZnVuY3Rpb24gZm9jdXMoZWxlbSkge1xuICAgICAgICAgICAgcmV0dXJuIGVsZW0gPT09IGRvY3VtZW50LmFjdGl2ZUVsZW1lbnQgJiYgKCFkb2N1bWVudC5oYXNGb2N1cyB8fCBkb2N1bWVudC5oYXNGb2N1cygpKSAmJiAhIShlbGVtLnR5cGUgfHwgZWxlbS5ocmVmIHx8IH5lbGVtLnRhYkluZGV4KTtcbiAgICAgICAgICB9LFxuICAgICAgICAgIC8vIEJvb2xlYW4gcHJvcGVydGllc1xuICAgICAgICAgIFwiZW5hYmxlZFwiOiBjcmVhdGVEaXNhYmxlZFBzZXVkbyhmYWxzZSksXG4gICAgICAgICAgXCJkaXNhYmxlZFwiOiBjcmVhdGVEaXNhYmxlZFBzZXVkbyh0cnVlKSxcbiAgICAgICAgICBcImNoZWNrZWRcIjogZnVuY3Rpb24gY2hlY2tlZChlbGVtKSB7XG4gICAgICAgICAgICAvLyBJbiBDU1MzLCA6Y2hlY2tlZCBzaG91bGQgcmV0dXJuIGJvdGggY2hlY2tlZCBhbmQgc2VsZWN0ZWQgZWxlbWVudHNcbiAgICAgICAgICAgIC8vIGh0dHA6Ly93d3cudzMub3JnL1RSLzIwMTEvUkVDLWNzczMtc2VsZWN0b3JzLTIwMTEwOTI5LyNjaGVja2VkXG4gICAgICAgICAgICB2YXIgbm9kZU5hbWUgPSBlbGVtLm5vZGVOYW1lLnRvTG93ZXJDYXNlKCk7XG4gICAgICAgICAgICByZXR1cm4gbm9kZU5hbWUgPT09IFwiaW5wdXRcIiAmJiAhIWVsZW0uY2hlY2tlZCB8fCBub2RlTmFtZSA9PT0gXCJvcHRpb25cIiAmJiAhIWVsZW0uc2VsZWN0ZWQ7XG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNlbGVjdGVkXCI6IGZ1bmN0aW9uIHNlbGVjdGVkKGVsZW0pIHtcbiAgICAgICAgICAgIC8vIEFjY2Vzc2luZyB0aGlzIHByb3BlcnR5IG1ha2VzIHNlbGVjdGVkLWJ5LWRlZmF1bHRcbiAgICAgICAgICAgIC8vIG9wdGlvbnMgaW4gU2FmYXJpIHdvcmsgcHJvcGVybHlcbiAgICAgICAgICAgIGlmIChlbGVtLnBhcmVudE5vZGUpIHtcbiAgICAgICAgICAgICAgZWxlbS5wYXJlbnROb2RlLnNlbGVjdGVkSW5kZXg7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIHJldHVybiBlbGVtLnNlbGVjdGVkID09PSB0cnVlO1xuICAgICAgICAgIH0sXG4gICAgICAgICAgLy8gQ29udGVudHNcbiAgICAgICAgICBcImVtcHR5XCI6IGZ1bmN0aW9uIGVtcHR5KGVsZW0pIHtcbiAgICAgICAgICAgIC8vIGh0dHA6Ly93d3cudzMub3JnL1RSL3NlbGVjdG9ycy8jZW1wdHktcHNldWRvXG4gICAgICAgICAgICAvLyA6ZW1wdHkgaXMgbmVnYXRlZCBieSBlbGVtZW50ICgxKSBvciBjb250ZW50IG5vZGVzICh0ZXh0OiAzOyBjZGF0YTogNDsgZW50aXR5IHJlZjogNSksXG4gICAgICAgICAgICAvLyAgIGJ1dCBub3QgYnkgb3RoZXJzIChjb21tZW50OiA4OyBwcm9jZXNzaW5nIGluc3RydWN0aW9uOiA3OyBldGMuKVxuICAgICAgICAgICAgLy8gbm9kZVR5cGUgPCA2IHdvcmtzIGJlY2F1c2UgYXR0cmlidXRlcyAoMikgZG8gbm90IGFwcGVhciBhcyBjaGlsZHJlblxuICAgICAgICAgICAgZm9yIChlbGVtID0gZWxlbS5maXJzdENoaWxkOyBlbGVtOyBlbGVtID0gZWxlbS5uZXh0U2libGluZykge1xuICAgICAgICAgICAgICBpZiAoZWxlbS5ub2RlVHlwZSA8IDYpIHtcbiAgICAgICAgICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgcmV0dXJuIHRydWU7XG4gICAgICAgICAgfSAvLyBSZW1vdmVkIGN1c3RvbSBwc2V1ZG8tY2xhc3Nlc1xuXG4gICAgICAgIH1cbiAgICAgIH07IC8vIFJlbW92ZWQgY3VzdG9tIHBzZXVkby1jbGFzc2VzXG4gICAgICAvLyBFYXN5IEFQSSBmb3IgY3JlYXRpbmcgbmV3IHNldEZpbHRlcnNcblxuICAgICAgZnVuY3Rpb24gc2V0RmlsdGVycygpIHt9XG5cbiAgICAgIHNldEZpbHRlcnMucHJvdG90eXBlID0gRXhwci5maWx0ZXJzID0gRXhwci5wc2V1ZG9zO1xuICAgICAgRXhwci5zZXRGaWx0ZXJzID0gbmV3IHNldEZpbHRlcnMoKTtcbiAgICAgIC8qKlxuICAgICAgICogW0FkR3VhcmQgUGF0Y2hdOlxuICAgICAgICogU29ydHMgdGhlIHRva2VucyBpbiBvcmRlciB0byBtaXRpZ2F0ZSB0aGUgcGVyZm9ybWFuY2UgaXNzdWVzIGNhdXNlZCBieSBtYXRjaGluZyBzbG93IHBzZXVkb3MgZmlyc3Q6XG4gICAgICAgKiBodHRwczovL2dpdGh1Yi5jb20vQWRndWFyZFRlYW0vRXh0ZW5kZWRDc3MvaXNzdWVzLzU1I2lzc3VlY29tbWVudC0zNjQwNTg3NDVcbiAgICAgICAqL1xuXG4gICAgICB2YXIgc29ydFRva2VuR3JvdXBzID0gZnVuY3Rpb24gKCkge1xuICAgICAgICAvKipcbiAgICAgICAgICogU3BsaXRzIGNvbXBvdW5kIHNlbGVjdG9yIGludG8gYSBsaXN0IG9mIHNpbXBsZSBzZWxlY3RvcnNcbiAgICAgICAgICpcbiAgICAgICAgICogQHBhcmFtIHsqfSB0b2tlbnMgVG9rZW5zIHRvIHNwbGl0IGludG8gZ3JvdXBzXG4gICAgICAgICAqIEByZXR1cm5zIGFuIGFycmF5IGNvbnNpc3Rpbmcgb2YgdG9rZW4gZ3JvdXBzIChhcnJheXMpIGFuZCByZWxhdGlvbiB0b2tlbnMuXG4gICAgICAgICAqL1xuICAgICAgICB2YXIgc3BsaXRDb21wb3VuZFNlbGVjdG9yID0gZnVuY3Rpb24gc3BsaXRDb21wb3VuZFNlbGVjdG9yKHRva2Vucykge1xuICAgICAgICAgIHZhciBncm91cHMgPSBbXTtcbiAgICAgICAgICB2YXIgY3VycmVudFRva2Vuc0dyb3VwID0gW107XG4gICAgICAgICAgdmFyIG1heElkeCA9IHRva2Vucy5sZW5ndGggLSAxO1xuXG4gICAgICAgICAgZm9yICh2YXIgaSA9IDA7IGkgPD0gbWF4SWR4OyBpKyspIHtcbiAgICAgICAgICAgIHZhciB0b2tlbiA9IHRva2Vuc1tpXTtcbiAgICAgICAgICAgIHZhciByZWxhdGl2ZSA9IFNpenpsZS5zZWxlY3RvcnMucmVsYXRpdmVbdG9rZW4udHlwZV07XG5cbiAgICAgICAgICAgIGlmIChyZWxhdGl2ZSkge1xuICAgICAgICAgICAgICBncm91cHMucHVzaChjdXJyZW50VG9rZW5zR3JvdXApO1xuICAgICAgICAgICAgICBncm91cHMucHVzaCh0b2tlbik7XG4gICAgICAgICAgICAgIGN1cnJlbnRUb2tlbnNHcm91cCA9IFtdO1xuICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgY3VycmVudFRva2Vuc0dyb3VwLnB1c2godG9rZW4pO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICBpZiAoaSA9PT0gbWF4SWR4KSB7XG4gICAgICAgICAgICAgIGdyb3Vwcy5wdXNoKGN1cnJlbnRUb2tlbnNHcm91cCk7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgcmV0dXJuIGdyb3VwcztcbiAgICAgICAgfTtcblxuICAgICAgICB2YXIgVE9LRU5fVFlQRVNfVkFMVUVTID0ge1xuICAgICAgICAgIC8vIG50aC1jaGlsZCwgZXRjLCBhbHdheXMgZ28gbGFzdFxuICAgICAgICAgIFwiQ0hJTERcIjogMTAwLFxuICAgICAgICAgIFwiSURcIjogOTAsXG4gICAgICAgICAgXCJDTEFTU1wiOiA4MCxcbiAgICAgICAgICBcIlRBR1wiOiA3MCxcbiAgICAgICAgICBcIkFUVFJcIjogNzAsXG4gICAgICAgICAgXCJQU0VVRE9cIjogNjBcbiAgICAgICAgfTtcbiAgICAgICAgdmFyIFBPU0lUSU9OQUxfUFNFVURPUyA9IFtcIm50aFwiLCBcImZpcnN0XCIsIFwibGFzdFwiLCBcImVxXCIsIFwiZXZlblwiLCBcIm9kZFwiLCBcImx0XCIsIFwiZ3RcIiwgXCJub3RcIl07XG4gICAgICAgIC8qKlxuICAgICAgICAgKiBBIGZ1bmN0aW9uIHRoYXQgZGVmaW5lcyB0aGUgc29ydCBvcmRlci5cbiAgICAgICAgICogUmV0dXJucyBhIHZhbHVlIGxlc3NlciB0aGFuIDAgaWYgXCJsZWZ0XCIgaXMgbGVzcyB0aGFuIFwicmlnaHRcIi5cbiAgICAgICAgICovXG5cbiAgICAgICAgdmFyIGNvbXBhcmVGdW5jdGlvbiA9IGZ1bmN0aW9uIGNvbXBhcmVGdW5jdGlvbihsZWZ0LCByaWdodCkge1xuICAgICAgICAgIHZhciBsZWZ0VmFsdWUgPSBUT0tFTl9UWVBFU19WQUxVRVNbbGVmdC50eXBlXTtcbiAgICAgICAgICB2YXIgcmlnaHRWYWx1ZSA9IFRPS0VOX1RZUEVTX1ZBTFVFU1tyaWdodC50eXBlXTtcbiAgICAgICAgICByZXR1cm4gbGVmdFZhbHVlIC0gcmlnaHRWYWx1ZTtcbiAgICAgICAgfTtcbiAgICAgICAgLyoqXG4gICAgICAgICAqIENoZWNrcyBpZiB0aGUgc3BlY2lmaWVkIHRva2VucyBncm91cCBpcyBzb3J0YWJsZS5cbiAgICAgICAgICogV2UgZG8gbm90IHJlLXNvcnQgdG9rZW5zIGluIGNhc2Ugb2YgYW55IHBvc2l0aW9uYWwgb3IgY2hpbGQgcHNldWRvcyBpbiB0aGUgZ3JvdXBcbiAgICAgICAgICovXG5cblxuICAgICAgICB2YXIgaXNTb3J0YWJsZSA9IGZ1bmN0aW9uIGlzU29ydGFibGUodG9rZW5zKSB7XG4gICAgICAgICAgdmFyIGlUb2tlbnMgPSB0b2tlbnMubGVuZ3RoO1xuXG4gICAgICAgICAgd2hpbGUgKGlUb2tlbnMtLSkge1xuICAgICAgICAgICAgdmFyIHRva2VuID0gdG9rZW5zW2lUb2tlbnNdO1xuXG4gICAgICAgICAgICBpZiAodG9rZW4udHlwZSA9PT0gXCJQU0VVRE9cIiAmJiBQT1NJVElPTkFMX1BTRVVET1MuaW5kZXhPZih0b2tlbi5tYXRjaGVzWzBdKSAhPT0gLTEpIHtcbiAgICAgICAgICAgICAgcmV0dXJuIGZhbHNlO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICBpZiAodG9rZW4udHlwZSA9PT0gXCJDSElMRFwiKSB7XG4gICAgICAgICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9XG5cbiAgICAgICAgICByZXR1cm4gdHJ1ZTtcbiAgICAgICAgfTtcbiAgICAgICAgLyoqXG4gICAgICAgICAqIFNvcnRzIHRoZSB0b2tlbnMgaW4gb3JkZXIgdG8gbWl0aWdhdGUgdGhlIGlzc3VlcyBjYXVzZWQgYnkgdGhlIGxlZnQtdG8tcmlnaHQgbWF0Y2hpbmcuXG4gICAgICAgICAqIFRoZSBpZGVhIGlzIGNoYW5nZSB0aGUgdG9rZW5zIG9yZGVyIHNvIHRoYXQgU2l6emxlIHdhcyBtYXRjaGluZyBmYXN0IHNlbGVjdG9ycyBmaXJzdCAoaWQsIGNsYXNzKSxcbiAgICAgICAgICogYW5kIHNsb3cgc2VsZWN0b3JzIGFmdGVyIHRoYXQgKGFuZCBoZXJlIEkgbWVhbiBvdXIgc2xvdyBjdXN0b20gcHNldWRvIGNsYXNzZXMpLlxuICAgICAgICAgKlxuICAgICAgICAgKiBAcGFyYW0ge0FycmF5fSB0b2tlbnMgQW4gYXJyYXkgb2YgdG9rZW5zIHRvIHNvcnRcbiAgICAgICAgICogQHJldHVybnMge0FycmF5fSBBIG5ldyByZS1zb3J0ZWQgYXJyYXlcbiAgICAgICAgICovXG5cblxuICAgICAgICB2YXIgc29ydFRva2VucyA9IGZ1bmN0aW9uIHNvcnRUb2tlbnModG9rZW5zKSB7XG4gICAgICAgICAgaWYgKCF0b2tlbnMgfHwgdG9rZW5zLmxlbmd0aCA9PT0gMSkge1xuICAgICAgICAgICAgcmV0dXJuIHRva2VucztcbiAgICAgICAgICB9XG5cbiAgICAgICAgICB2YXIgc29ydGVkVG9rZW5zID0gW107XG4gICAgICAgICAgdmFyIGdyb3VwcyA9IHNwbGl0Q29tcG91bmRTZWxlY3Rvcih0b2tlbnMpO1xuXG4gICAgICAgICAgZm9yICh2YXIgaSA9IDA7IGkgPCBncm91cHMubGVuZ3RoOyBpKyspIHtcbiAgICAgICAgICAgIHZhciBncm91cCA9IGdyb3Vwc1tpXTtcblxuICAgICAgICAgICAgaWYgKGdyb3VwIGluc3RhbmNlb2YgQXJyYXkpIHtcbiAgICAgICAgICAgICAgaWYgKGlzU29ydGFibGUoZ3JvdXApKSB7XG4gICAgICAgICAgICAgICAgZ3JvdXAuc29ydChjb21wYXJlRnVuY3Rpb24pO1xuICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgc29ydGVkVG9rZW5zID0gc29ydGVkVG9rZW5zLmNvbmNhdChncm91cCk7XG4gICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICBzb3J0ZWRUb2tlbnMucHVzaChncm91cCk7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgcmV0dXJuIHNvcnRlZFRva2VucztcbiAgICAgICAgfTtcbiAgICAgICAgLyoqXG4gICAgICAgICAqIFNvcnRzIGV2ZXJ5IHRva2VucyBhcnJheSBpbnNpZGUgb2YgdGhlIHNwZWNpZmllZCBcImdyb3Vwc1wiIGFycmF5LlxuICAgICAgICAgKiBTZWUgXCJzb3J0VG9rZW5zXCIgbWV0aG9kcyBmb3IgbW9yZSBpbmZvcm1hdGlvbiBvbiBob3cgdG9rZW5zIGFyZSBzb3J0ZWQuXG4gICAgICAgICAqXG4gICAgICAgICAqIEBwYXJhbSB7QXJyYXl9IGdyb3VwcyBBbiBhcnJheSBvZiB0b2tlbnMgYXJyYXlzLlxuICAgICAgICAgKiBAcmV0dXJucyB7QXJyYXl9IEEgbmV3IGFycmF5IHRoYXQgY29uc2lzdHMgb2YgdGhlIHNhbWUgdG9rZW5zIGFycmF5cyBhZnRlciBzb3J0aW5nXG4gICAgICAgICAqL1xuXG5cbiAgICAgICAgdmFyIHNvcnRUb2tlbkdyb3VwcyA9IGZ1bmN0aW9uIHNvcnRUb2tlbkdyb3Vwcyhncm91cHMpIHtcbiAgICAgICAgICB2YXIgc29ydGVkR3JvdXBzID0gW107XG4gICAgICAgICAgdmFyIGxlbiA9IGdyb3Vwcy5sZW5ndGg7XG4gICAgICAgICAgdmFyIGkgPSAwO1xuXG4gICAgICAgICAgZm9yICg7IGkgPCBsZW47IGkrKykge1xuICAgICAgICAgICAgc29ydGVkR3JvdXBzLnB1c2goc29ydFRva2Vucyhncm91cHNbaV0pKTtcbiAgICAgICAgICB9XG5cbiAgICAgICAgICByZXR1cm4gc29ydGVkR3JvdXBzO1xuICAgICAgICB9OyAvLyBFeHBvc2VcblxuXG4gICAgICAgIHJldHVybiBzb3J0VG9rZW5Hcm91cHM7XG4gICAgICB9KCk7XG4gICAgICAvKipcbiAgICAgICAqIENyZWF0ZXMgY3VzdG9tIHBvbGljeSB0byB1c2UgVHJ1c3RlZFR5cGVzIENTUCBwb2xpY3lcbiAgICAgICAqIGh0dHBzOi8vdzNjLmdpdGh1Yi5pby93ZWJhcHBzZWMtdHJ1c3RlZC10eXBlcy9kaXN0L3NwZWMvXG4gICAgICAgKi9cblxuXG4gICAgICB2YXIgQUdQb2xpY3kgPSBmdW5jdGlvbiBjcmVhdGVQb2xpY3koKSB7XG4gICAgICAgIHZhciBkZWZhdWx0UG9saWN5ID0ge1xuICAgICAgICAgIGNyZWF0ZUhUTUw6IGZ1bmN0aW9uIGNyZWF0ZUhUTUwoaW5wdXQpIHtcbiAgICAgICAgICAgIHJldHVybiBpbnB1dDtcbiAgICAgICAgICB9LFxuICAgICAgICAgIGNyZWF0ZVNjcmlwdDogZnVuY3Rpb24gY3JlYXRlU2NyaXB0KGlucHV0KSB7XG4gICAgICAgICAgICByZXR1cm4gaW5wdXQ7XG4gICAgICAgICAgfSxcbiAgICAgICAgICBjcmVhdGVTY3JpcHRVUkw6IGZ1bmN0aW9uIGNyZWF0ZVNjcmlwdFVSTChpbnB1dCkge1xuICAgICAgICAgICAgcmV0dXJuIGlucHV0O1xuICAgICAgICAgIH1cbiAgICAgICAgfTtcblxuICAgICAgICBpZiAod2luZG93LnRydXN0ZWRUeXBlcyAmJiB3aW5kb3cudHJ1c3RlZFR5cGVzLmNyZWF0ZVBvbGljeSkge1xuICAgICAgICAgIHJldHVybiB3aW5kb3cudHJ1c3RlZFR5cGVzLmNyZWF0ZVBvbGljeShcIkFHUG9saWN5XCIsIGRlZmF1bHRQb2xpY3kpO1xuICAgICAgICB9XG5cbiAgICAgICAgcmV0dXJuIGRlZmF1bHRQb2xpY3k7XG4gICAgICB9KCk7XG4gICAgICAvKipcbiAgICAgICAqIFtBZEd1YXJkIFBhdGNoXTpcbiAgICAgICAqIFJlbW92ZXMgdHJhaWxpbmcgc3BhY2VzIGZyb20gdGhlIHRva2VucyBsaXN0XG4gICAgICAgKlxuICAgICAgICogQHBhcmFtIHsqfSB0b2tlbnMgQW4gYXJyYXkgb2YgU2l6emxlIHRva2VucyB0byBwb3N0LXByb2Nlc3NcbiAgICAgICAqL1xuXG5cbiAgICAgIGZ1bmN0aW9uIHJlbW92ZVRyYWlsaW5nU3BhY2VzKHRva2Vucykge1xuICAgICAgICB2YXIgaVRva2VucyA9IHRva2Vucy5sZW5ndGg7XG5cbiAgICAgICAgd2hpbGUgKGlUb2tlbnMtLSkge1xuICAgICAgICAgIHZhciB0b2tlbiA9IHRva2Vuc1tpVG9rZW5zXTtcblxuICAgICAgICAgIGlmICh0b2tlbi50eXBlID09PSBcIiBcIikge1xuICAgICAgICAgICAgdG9rZW5zLmxlbmd0aCA9IGlUb2tlbnM7XG4gICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIGJyZWFrO1xuICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgfVxuICAgICAgLyoqXG4gICAgICAgKiBbQWRHdWFyZCBQYXRjaF06XG4gICAgICAgKiBBbiBvYmplY3Qgd2l0aCB0aGUgaW5mb3JtYXRpb24gYWJvdXQgc2VsZWN0b3JzIGFuZCB0aGVpciB0b2tlbiByZXByZXNlbnRhdGlvblxuICAgICAgICogQHR5cGVkZWYge3tzZWxlY3RvclRleHQ6IHN0cmluZywgZ3JvdXBzOiBBcnJheX19IFNlbGVjdG9yRGF0YVxuICAgICAgICogQHByb3BlcnR5IHtzdHJpbmd9IHNlbGVjdG9yVGV4dCBBIENTUyBzZWxlY3RvciB0ZXh0XG4gICAgICAgKiBAcHJvcGVydHkge0FycmF5fSBncm91cHMgQW4gYXJyYXkgb2YgdG9rZW4gZ3JvdXBzIGNvcnJlc3BvbmRpbmcgdG8gdGhhdCBzZWxlY3RvclxuICAgICAgICovXG5cbiAgICAgIC8qKlxuICAgICAgICogW0FkR3VhcmQgUGF0Y2hdOlxuICAgICAgICogVGhpcyBtZXRob2QgcHJvY2Vzc2VzIHBhcnNlZCB0b2tlbiBncm91cHMsIGRpdmlkZXMgdGhlbSBpbnRvIGEgbnVtYmVyIG9mIHNlbGVjdG9yc1xuICAgICAgICogYW5kIG1ha2VzIHN1cmUgdGhhdCBlYWNoIHNlbGVjdG9yJ3MgdG9rZW5zIGFyZSBjYWNoZWQgcHJvcGVybHkgaW4gU2l6emxlLlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSB7Kn0gZ3JvdXBzIFRva2VuIGdyb3VwcyAoc2VlIHtAbGluayBTaXp6bGUudG9rZW5pemV9KVxuICAgICAgICogQHJldHVybnMge0FycmF5LjxTZWxlY3RvckRhdGE+fSBBbiBhcnJheSBvZiBzZWxlY3RvcnMgZGF0YSB3ZSBnb3QgZnJvbSB0aGUgZ3JvdXBzXG4gICAgICAgKi9cblxuXG4gICAgICBmdW5jdGlvbiB0b2tlbkdyb3Vwc1RvU2VsZWN0b3JzKGdyb3Vwcykge1xuICAgICAgICAvLyBSZW1vdmUgdHJhaWxpbmcgc3BhY2VzIHdoaWNoIHdlIGNhbiBlbmNvdW50ZXIgaW4gdG9sZXJhbnQgbW9kZVxuICAgICAgICAvLyBXZSdyZSBkb2luZyBpdCBpbiB0b2xlcmFudCBtb2RlIG9ubHkgYXMgdGhpcyBpcyB0aGUgb25seSBjYXNlIHdoZW5cbiAgICAgICAgLy8gZW5jb3VudGVyaW5nIHRyYWlsaW5nIHNwYWNlcyBpcyBleHBlY3RlZFxuICAgICAgICByZW1vdmVUcmFpbGluZ1NwYWNlcyhncm91cHNbZ3JvdXBzLmxlbmd0aCAtIDFdKTsgLy8gV2UgbmVlZCBzb3J0ZWQgdG9rZW5zIHRvIG1ha2UgY2FjaGUgd29yayBwcm9wZXJseVxuXG4gICAgICAgIHZhciBzb3J0ZWRHcm91cHMgPSBzb3J0VG9rZW5Hcm91cHMoZ3JvdXBzKTtcbiAgICAgICAgdmFyIHNlbGVjdG9ycyA9IFtdO1xuXG4gICAgICAgIGZvciAodmFyIGkgPSAwOyBpIDwgZ3JvdXBzLmxlbmd0aDsgaSsrKSB7XG4gICAgICAgICAgdmFyIHRva2VuR3JvdXBzID0gZ3JvdXBzW2ldO1xuICAgICAgICAgIHZhciBzZWxlY3RvclRleHQgPSB0b1NlbGVjdG9yKHRva2VuR3JvdXBzKTtcbiAgICAgICAgICBzZWxlY3RvcnMucHVzaCh7XG4gICAgICAgICAgICAvLyBTaXp6bGUgZXhwZWN0cyBhbiBhcnJheSBvZiB0b2tlbiBncm91cHMgd2hlbiBjb21waWxpbmcgYSBzZWxlY3RvclxuICAgICAgICAgICAgZ3JvdXBzOiBbdG9rZW5Hcm91cHNdLFxuICAgICAgICAgICAgc2VsZWN0b3JUZXh0OiBzZWxlY3RvclRleHRcbiAgICAgICAgICB9KTsgLy8gTm93IG1ha2Ugc3VyZSB0aGF0IHNlbGVjdG9yIHRva2VucyBhcmUgY2FjaGVkXG5cbiAgICAgICAgICB2YXIgdG9rZW5zQ2FjaGVJdGVtID0ge1xuICAgICAgICAgICAgZ3JvdXBzOiB0b2tlbkdyb3VwcyxcbiAgICAgICAgICAgIHNvcnRlZEdyb3VwczogW3NvcnRlZEdyb3Vwc1tpXV1cbiAgICAgICAgICB9O1xuICAgICAgICAgIHRva2VuQ2FjaGUoc2VsZWN0b3JUZXh0LCB0b2tlbnNDYWNoZUl0ZW0pO1xuICAgICAgICB9XG5cbiAgICAgICAgcmV0dXJuIHNlbGVjdG9ycztcbiAgICAgIH1cbiAgICAgIC8qKlxuICAgICAgICogW0FkR3VhcmQgUGF0Y2hdOlxuICAgICAgICogQWRkIGFuIGFkZGl0aW9uYWwgYXJndW1lbnQgZm9yIFNpenpsZS50b2tlbml6ZSB3aGljaCBpbmRpY2F0ZXMgdGhhdCBpdFxuICAgICAgICogc2hvdWxkIG5vdCB0aHJvdyBvbiBpbnZhbGlkIHRva2VucywgYW5kIGluc3RlYWQgc2hvdWxkIHJldHVybiB0b2tlbnNcbiAgICAgICAqIHRoYXQgaXQgaGFzIHByb2R1Y2VkIHNvIGZhci5cbiAgICAgICAqXG4gICAgICAgKiBPbmUgbW9yZSBhZGRpdGlvbmFsIGFyZ3VtZW50IHRoYXQgYWxsb3cgdG8gY2hvb3NlIGlmIHlvdSB3YW50IHRvIHJlY2VpdmUgc29ydGVkIG9yIHVuc29ydGVkIHRva2Vuc1xuICAgICAgICogVGhlIHByb2JsZW0gaXMgdGhhdCB0aGUgcmUtc29ydGVkIHNlbGVjdG9ycyBhcmUgdmFsaWQgZm9yIFNpenpsZSwgYnV0IG5vdCBmb3IgdGhlIGJyb3dzZXIuXG4gICAgICAgKiBvcHRpb25zLnJldHVyblVuc29ydGVkIC0tIHJldHVybiB1bnNvcnRlZCB0b2tlbnMgaWYgdHJ1ZS5cbiAgICAgICAqIG9wdGlvbnMuY2FjaGVPbmx5IC0tIHJldHVybiBjYWNoZWQgcmVzdWx0IG9ubHkuIFJlcXVpcmVkIGZvciB1bml0LXRlc3RzLlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSB7Kn0gb3B0aW9ucyBPcHRpb25hbCBjb25maWd1cmF0aW9uIG9iamVjdCB3aXRoIHR3byBhZGRpdGlvbmFsIGZsYWdzXG4gICAgICAgKiAob3B0aW9ucy50b2xlcmFudCwgb3B0aW9ucy5yZXR1cm5VbnNvcnRlZCwgb3B0aW9ucy5jYWNoZU9ubHkpIC0tIHNlZSBwYXRjaGVzICM1IGFuZCAjNiBub3Rlc1xuICAgICAgICovXG5cblxuICAgICAgdG9rZW5pemUgPSBTaXp6bGUudG9rZW5pemUgPSBmdW5jdGlvbiAoc2VsZWN0b3IsIHBhcnNlT25seSwgb3B0aW9ucykge1xuICAgICAgICB2YXIgbWF0Y2hlZCxcbiAgICAgICAgICAgIG1hdGNoLFxuICAgICAgICAgICAgdG9rZW5zLFxuICAgICAgICAgICAgdHlwZSxcbiAgICAgICAgICAgIHNvRmFyLFxuICAgICAgICAgICAgZ3JvdXBzLFxuICAgICAgICAgICAgcHJlRmlsdGVycyxcbiAgICAgICAgICAgIGNhY2hlZCA9IHRva2VuQ2FjaGVbc2VsZWN0b3IgKyBcIiBcIl07XG4gICAgICAgIHZhciB0b2xlcmFudCA9IG9wdGlvbnMgJiYgb3B0aW9ucy50b2xlcmFudDtcbiAgICAgICAgdmFyIHJldHVyblVuc29ydGVkID0gb3B0aW9ucyAmJiBvcHRpb25zLnJldHVyblVuc29ydGVkO1xuICAgICAgICB2YXIgY2FjaGVPbmx5ID0gb3B0aW9ucyAmJiBvcHRpb25zLmNhY2hlT25seTtcblxuICAgICAgICBpZiAoY2FjaGVkKSB7XG4gICAgICAgICAgaWYgKHBhcnNlT25seSkge1xuICAgICAgICAgICAgcmV0dXJuIDA7XG4gICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIHJldHVybiAocmV0dXJuVW5zb3J0ZWQgPyBjYWNoZWQuZ3JvdXBzIDogY2FjaGVkLnNvcnRlZEdyb3Vwcykuc2xpY2UoMCk7XG4gICAgICAgICAgfVxuICAgICAgICB9XG5cbiAgICAgICAgaWYgKGNhY2hlT25seSkge1xuICAgICAgICAgIHJldHVybiBudWxsO1xuICAgICAgICB9XG5cbiAgICAgICAgc29GYXIgPSBzZWxlY3RvcjtcbiAgICAgICAgZ3JvdXBzID0gW107XG4gICAgICAgIHByZUZpbHRlcnMgPSBFeHByLnByZUZpbHRlcjtcblxuICAgICAgICB3aGlsZSAoc29GYXIpIHtcbiAgICAgICAgICAvLyBDb21tYSBhbmQgZmlyc3QgcnVuXG4gICAgICAgICAgaWYgKCFtYXRjaGVkIHx8IChtYXRjaCA9IHJjb21tYS5leGVjKHNvRmFyKSkpIHtcbiAgICAgICAgICAgIGlmIChtYXRjaCkge1xuICAgICAgICAgICAgICAvLyBEb24ndCBjb25zdW1lIHRyYWlsaW5nIGNvbW1hcyBhcyB2YWxpZFxuICAgICAgICAgICAgICBzb0ZhciA9IHNvRmFyLnNsaWNlKG1hdGNoWzBdLmxlbmd0aCkgfHwgc29GYXI7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIGdyb3Vwcy5wdXNoKHRva2VucyA9IFtdKTtcbiAgICAgICAgICB9XG5cbiAgICAgICAgICBtYXRjaGVkID0gZmFsc2U7IC8vIENvbWJpbmF0b3JzXG5cbiAgICAgICAgICBpZiAobWF0Y2ggPSByY29tYmluYXRvcnMuZXhlYyhzb0ZhcikpIHtcbiAgICAgICAgICAgIG1hdGNoZWQgPSBtYXRjaC5zaGlmdCgpO1xuICAgICAgICAgICAgdG9rZW5zLnB1c2goe1xuICAgICAgICAgICAgICB2YWx1ZTogbWF0Y2hlZCxcbiAgICAgICAgICAgICAgLy8gQ2FzdCBkZXNjZW5kYW50IGNvbWJpbmF0b3JzIHRvIHNwYWNlXG4gICAgICAgICAgICAgIHR5cGU6IG1hdGNoWzBdLnJlcGxhY2UocnRyaW0sIFwiIFwiKVxuICAgICAgICAgICAgfSk7XG4gICAgICAgICAgICBzb0ZhciA9IHNvRmFyLnNsaWNlKG1hdGNoZWQubGVuZ3RoKTtcbiAgICAgICAgICB9IC8vIEZpbHRlcnNcblxuXG4gICAgICAgICAgZm9yICh0eXBlIGluIEV4cHIuZmlsdGVyKSB7XG4gICAgICAgICAgICBpZiAoKG1hdGNoID0gbWF0Y2hFeHByW3R5cGVdLmV4ZWMoc29GYXIpKSAmJiAoIXByZUZpbHRlcnNbdHlwZV0gfHwgKG1hdGNoID0gcHJlRmlsdGVyc1t0eXBlXShtYXRjaCkpKSkge1xuICAgICAgICAgICAgICBtYXRjaGVkID0gbWF0Y2guc2hpZnQoKTtcbiAgICAgICAgICAgICAgdG9rZW5zLnB1c2goe1xuICAgICAgICAgICAgICAgIHZhbHVlOiBtYXRjaGVkLFxuICAgICAgICAgICAgICAgIHR5cGU6IHR5cGUsXG4gICAgICAgICAgICAgICAgbWF0Y2hlczogbWF0Y2hcbiAgICAgICAgICAgICAgfSk7XG4gICAgICAgICAgICAgIHNvRmFyID0gc29GYXIuc2xpY2UobWF0Y2hlZC5sZW5ndGgpO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cblxuICAgICAgICAgIGlmICghbWF0Y2hlZCkge1xuICAgICAgICAgICAgYnJlYWs7XG4gICAgICAgICAgfVxuICAgICAgICB9IC8vIFJldHVybiB0aGUgbGVuZ3RoIG9mIHRoZSBpbnZhbGlkIGV4Y2Vzc1xuICAgICAgICAvLyBpZiB3ZSdyZSBqdXN0IHBhcnNpbmdcbiAgICAgICAgLy8gT3RoZXJ3aXNlLCB0aHJvdyBhbiBlcnJvciBvciByZXR1cm4gdG9rZW5zXG5cblxuICAgICAgICB2YXIgaW52YWxpZExlbiA9IHNvRmFyLmxlbmd0aDtcblxuICAgICAgICBpZiAocGFyc2VPbmx5KSB7XG4gICAgICAgICAgcmV0dXJuIGludmFsaWRMZW47XG4gICAgICAgIH1cblxuICAgICAgICBpZiAoaW52YWxpZExlbiAhPT0gMCAmJiAhdG9sZXJhbnQpIHtcbiAgICAgICAgICBTaXp6bGUuZXJyb3Ioc2VsZWN0b3IpOyAvLyBUaHJvd3MgYW4gZXJyb3IuXG4gICAgICAgIH1cblxuICAgICAgICBpZiAodG9sZXJhbnQpIHtcbiAgICAgICAgICAvKipcbiAgICAgICAgICAgKiBbQWRHdWFyZCBQYXRjaF06XG4gICAgICAgICAgICogSW4gdG9sZXJhbnQgbW9kZSB3ZSByZXR1cm4gYSBzcGVjaWFsIG9iamVjdCB0aGF0IGNvbnN0aXN0cyBvZlxuICAgICAgICAgICAqIGFuIGFycmF5IG9mIHBhcnNlZCBzZWxlY3RvcnMgKGFuZCB0aGVpciB0b2tlbnMpIGFuZCBhIFwibmV4dEluZGV4XCIgZmllbGRcbiAgICAgICAgICAgKiB0aGF0IHBvaW50cyB0byBhbiBpbmRleCBhZnRlciB3aGljaCB3ZSdyZSBub3QgYWJsZSB0byBwYXJzZSBzZWxlY3RvcnMgZmFydGhlci5cbiAgICAgICAgICAgKi9cbiAgICAgICAgICB2YXIgbmV4dEluZGV4ID0gc2VsZWN0b3IubGVuZ3RoIC0gaW52YWxpZExlbjtcbiAgICAgICAgICB2YXIgc2VsZWN0b3JzID0gdG9rZW5Hcm91cHNUb1NlbGVjdG9ycyhncm91cHMpO1xuICAgICAgICAgIHJldHVybiB7XG4gICAgICAgICAgICBzZWxlY3RvcnM6IHNlbGVjdG9ycyxcbiAgICAgICAgICAgIG5leHRJbmRleDogbmV4dEluZGV4XG4gICAgICAgICAgfTtcbiAgICAgICAgfVxuICAgICAgICAvKiogW0FkR3VhcmQgUGF0Y2hdOiBTb3J0aW5nIHRva2VucyAqL1xuXG5cbiAgICAgICAgdmFyIHNvcnRlZEdyb3VwcyA9IHNvcnRUb2tlbkdyb3Vwcyhncm91cHMpO1xuICAgICAgICAvKiogW0FkR3VhcmQgUGF0Y2hdOiBDaGFuZ2UgdGhlIHdheSB0b2tlbnMgYXJlIGNhY2hlZCAqL1xuXG4gICAgICAgIHZhciB0b2tlbnNDYWNoZUl0ZW0gPSB7XG4gICAgICAgICAgZ3JvdXBzOiBncm91cHMsXG4gICAgICAgICAgc29ydGVkR3JvdXBzOiBzb3J0ZWRHcm91cHNcbiAgICAgICAgfTtcbiAgICAgICAgdG9rZW5zQ2FjaGVJdGVtID0gdG9rZW5DYWNoZShzZWxlY3RvciwgdG9rZW5zQ2FjaGVJdGVtKTtcbiAgICAgICAgcmV0dXJuIChyZXR1cm5VbnNvcnRlZCA/IHRva2Vuc0NhY2hlSXRlbS5ncm91cHMgOiB0b2tlbnNDYWNoZUl0ZW0uc29ydGVkR3JvdXBzKS5zbGljZSgwKTtcbiAgICAgIH07XG5cbiAgICAgIGZ1bmN0aW9uIHRvU2VsZWN0b3IodG9rZW5zKSB7XG4gICAgICAgIHZhciBpID0gMCxcbiAgICAgICAgICAgIGxlbiA9IHRva2Vucy5sZW5ndGgsXG4gICAgICAgICAgICBzZWxlY3RvciA9IFwiXCI7XG5cbiAgICAgICAgZm9yICg7IGkgPCBsZW47IGkrKykge1xuICAgICAgICAgIHNlbGVjdG9yICs9IHRva2Vuc1tpXS52YWx1ZTtcbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiBzZWxlY3RvcjtcbiAgICAgIH1cblxuICAgICAgZnVuY3Rpb24gYWRkQ29tYmluYXRvcihtYXRjaGVyLCBjb21iaW5hdG9yLCBiYXNlKSB7XG4gICAgICAgIHZhciBkaXIgPSBjb21iaW5hdG9yLmRpcixcbiAgICAgICAgICAgIHNraXAgPSBjb21iaW5hdG9yLm5leHQsXG4gICAgICAgICAgICBrZXkgPSBza2lwIHx8IGRpcixcbiAgICAgICAgICAgIGNoZWNrTm9uRWxlbWVudHMgPSBiYXNlICYmIGtleSA9PT0gXCJwYXJlbnROb2RlXCIsXG4gICAgICAgICAgICBkb25lTmFtZSA9IGRvbmUrKztcbiAgICAgICAgcmV0dXJuIGNvbWJpbmF0b3IuZmlyc3QgPyAvLyBDaGVjayBhZ2FpbnN0IGNsb3Nlc3QgYW5jZXN0b3IvcHJlY2VkaW5nIGVsZW1lbnRcbiAgICAgICAgZnVuY3Rpb24gKGVsZW0sIGNvbnRleHQsIHhtbCkge1xuICAgICAgICAgIHdoaWxlIChlbGVtID0gZWxlbVtkaXJdKSB7XG4gICAgICAgICAgICBpZiAoZWxlbS5ub2RlVHlwZSA9PT0gMSB8fCBjaGVja05vbkVsZW1lbnRzKSB7XG4gICAgICAgICAgICAgIHJldHVybiBtYXRjaGVyKGVsZW0sIGNvbnRleHQsIHhtbCk7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgcmV0dXJuIGZhbHNlO1xuICAgICAgICB9IDogLy8gQ2hlY2sgYWdhaW5zdCBhbGwgYW5jZXN0b3IvcHJlY2VkaW5nIGVsZW1lbnRzXG4gICAgICAgIGZ1bmN0aW9uIChlbGVtLCBjb250ZXh0LCB4bWwpIHtcbiAgICAgICAgICB2YXIgb2xkQ2FjaGUsXG4gICAgICAgICAgICAgIHVuaXF1ZUNhY2hlLFxuICAgICAgICAgICAgICBvdXRlckNhY2hlLFxuICAgICAgICAgICAgICBuZXdDYWNoZSA9IFtkaXJydW5zLCBkb25lTmFtZV07IC8vIFdlIGNhbid0IHNldCBhcmJpdHJhcnkgZGF0YSBvbiBYTUwgbm9kZXMsIHNvIHRoZXkgZG9uJ3QgYmVuZWZpdCBmcm9tIGNvbWJpbmF0b3IgY2FjaGluZ1xuXG4gICAgICAgICAgaWYgKHhtbCkge1xuICAgICAgICAgICAgd2hpbGUgKGVsZW0gPSBlbGVtW2Rpcl0pIHtcbiAgICAgICAgICAgICAgaWYgKGVsZW0ubm9kZVR5cGUgPT09IDEgfHwgY2hlY2tOb25FbGVtZW50cykge1xuICAgICAgICAgICAgICAgIGlmIChtYXRjaGVyKGVsZW0sIGNvbnRleHQsIHhtbCkpIHtcbiAgICAgICAgICAgICAgICAgIHJldHVybiB0cnVlO1xuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfVxuICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICB3aGlsZSAoZWxlbSA9IGVsZW1bZGlyXSkge1xuICAgICAgICAgICAgICBpZiAoZWxlbS5ub2RlVHlwZSA9PT0gMSB8fCBjaGVja05vbkVsZW1lbnRzKSB7XG4gICAgICAgICAgICAgICAgb3V0ZXJDYWNoZSA9IGVsZW1bZXhwYW5kb10gfHwgKGVsZW1bZXhwYW5kb10gPSB7fSk7IC8vIFN1cHBvcnQ6IElFIDw5IG9ubHlcbiAgICAgICAgICAgICAgICAvLyBEZWZlbmQgYWdhaW5zdCBjbG9uZWQgYXR0cm9wZXJ0aWVzIChqUXVlcnkgZ2gtMTcwOSlcblxuICAgICAgICAgICAgICAgIHVuaXF1ZUNhY2hlID0gb3V0ZXJDYWNoZVtlbGVtLnVuaXF1ZUlEXSB8fCAob3V0ZXJDYWNoZVtlbGVtLnVuaXF1ZUlEXSA9IHt9KTtcblxuICAgICAgICAgICAgICAgIGlmIChza2lwICYmIHNraXAgPT09IGVsZW0ubm9kZU5hbWUudG9Mb3dlckNhc2UoKSkge1xuICAgICAgICAgICAgICAgICAgZWxlbSA9IGVsZW1bZGlyXSB8fCBlbGVtO1xuICAgICAgICAgICAgICAgIH0gZWxzZSBpZiAoKG9sZENhY2hlID0gdW5pcXVlQ2FjaGVba2V5XSkgJiYgb2xkQ2FjaGVbMF0gPT09IGRpcnJ1bnMgJiYgb2xkQ2FjaGVbMV0gPT09IGRvbmVOYW1lKSB7XG4gICAgICAgICAgICAgICAgICAvLyBBc3NpZ24gdG8gbmV3Q2FjaGUgc28gcmVzdWx0cyBiYWNrLXByb3BhZ2F0ZSB0byBwcmV2aW91cyBlbGVtZW50c1xuICAgICAgICAgICAgICAgICAgcmV0dXJuIG5ld0NhY2hlWzJdID0gb2xkQ2FjaGVbMl07XG4gICAgICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgICAgIC8vIFJldXNlIG5ld2NhY2hlIHNvIHJlc3VsdHMgYmFjay1wcm9wYWdhdGUgdG8gcHJldmlvdXMgZWxlbWVudHNcbiAgICAgICAgICAgICAgICAgIHVuaXF1ZUNhY2hlW2tleV0gPSBuZXdDYWNoZTsgLy8gQSBtYXRjaCBtZWFucyB3ZSdyZSBkb25lOyBhIGZhaWwgbWVhbnMgd2UgaGF2ZSB0byBrZWVwIGNoZWNraW5nXG5cbiAgICAgICAgICAgICAgICAgIGlmIChuZXdDYWNoZVsyXSA9IG1hdGNoZXIoZWxlbSwgY29udGV4dCwgeG1sKSkge1xuICAgICAgICAgICAgICAgICAgICByZXR1cm4gdHJ1ZTtcbiAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9XG5cbiAgICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICAgIH07XG4gICAgICB9XG5cbiAgICAgIGZ1bmN0aW9uIGVsZW1lbnRNYXRjaGVyKG1hdGNoZXJzKSB7XG4gICAgICAgIHJldHVybiBtYXRjaGVycy5sZW5ndGggPiAxID8gZnVuY3Rpb24gKGVsZW0sIGNvbnRleHQsIHhtbCkge1xuICAgICAgICAgIHZhciBpID0gbWF0Y2hlcnMubGVuZ3RoO1xuXG4gICAgICAgICAgd2hpbGUgKGktLSkge1xuICAgICAgICAgICAgaWYgKCFtYXRjaGVyc1tpXShlbGVtLCBjb250ZXh0LCB4bWwpKSB7XG4gICAgICAgICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9XG5cbiAgICAgICAgICByZXR1cm4gdHJ1ZTtcbiAgICAgICAgfSA6IG1hdGNoZXJzWzBdO1xuICAgICAgfVxuXG4gICAgICBmdW5jdGlvbiBtdWx0aXBsZUNvbnRleHRzKHNlbGVjdG9yLCBjb250ZXh0cywgcmVzdWx0cykge1xuICAgICAgICB2YXIgaSA9IDAsXG4gICAgICAgICAgICBsZW4gPSBjb250ZXh0cy5sZW5ndGg7XG5cbiAgICAgICAgZm9yICg7IGkgPCBsZW47IGkrKykge1xuICAgICAgICAgIFNpenpsZShzZWxlY3RvciwgY29udGV4dHNbaV0sIHJlc3VsdHMpO1xuICAgICAgICB9XG5cbiAgICAgICAgcmV0dXJuIHJlc3VsdHM7XG4gICAgICB9XG5cbiAgICAgIGZ1bmN0aW9uIGNvbmRlbnNlKHVubWF0Y2hlZCwgbWFwLCBmaWx0ZXIsIGNvbnRleHQsIHhtbCkge1xuICAgICAgICB2YXIgZWxlbSxcbiAgICAgICAgICAgIG5ld1VubWF0Y2hlZCA9IFtdLFxuICAgICAgICAgICAgaSA9IDAsXG4gICAgICAgICAgICBsZW4gPSB1bm1hdGNoZWQubGVuZ3RoLFxuICAgICAgICAgICAgbWFwcGVkID0gbWFwICE9IG51bGw7XG5cbiAgICAgICAgZm9yICg7IGkgPCBsZW47IGkrKykge1xuICAgICAgICAgIGlmIChlbGVtID0gdW5tYXRjaGVkW2ldKSB7XG4gICAgICAgICAgICBpZiAoIWZpbHRlciB8fCBmaWx0ZXIoZWxlbSwgY29udGV4dCwgeG1sKSkge1xuICAgICAgICAgICAgICBuZXdVbm1hdGNoZWQucHVzaChlbGVtKTtcblxuICAgICAgICAgICAgICBpZiAobWFwcGVkKSB7XG4gICAgICAgICAgICAgICAgbWFwLnB1c2goaSk7XG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9XG4gICAgICAgIH1cblxuICAgICAgICByZXR1cm4gbmV3VW5tYXRjaGVkO1xuICAgICAgfVxuXG4gICAgICBmdW5jdGlvbiBzZXRNYXRjaGVyKHByZUZpbHRlciwgc2VsZWN0b3IsIG1hdGNoZXIsIHBvc3RGaWx0ZXIsIHBvc3RGaW5kZXIsIHBvc3RTZWxlY3Rvcikge1xuICAgICAgICBpZiAocG9zdEZpbHRlciAmJiAhcG9zdEZpbHRlcltleHBhbmRvXSkge1xuICAgICAgICAgIHBvc3RGaWx0ZXIgPSBzZXRNYXRjaGVyKHBvc3RGaWx0ZXIpO1xuICAgICAgICB9XG5cbiAgICAgICAgaWYgKHBvc3RGaW5kZXIgJiYgIXBvc3RGaW5kZXJbZXhwYW5kb10pIHtcbiAgICAgICAgICBwb3N0RmluZGVyID0gc2V0TWF0Y2hlcihwb3N0RmluZGVyLCBwb3N0U2VsZWN0b3IpO1xuICAgICAgICB9XG5cbiAgICAgICAgcmV0dXJuIG1hcmtGdW5jdGlvbihmdW5jdGlvbiAoc2VlZCwgcmVzdWx0cywgY29udGV4dCwgeG1sKSB7XG4gICAgICAgICAgdmFyIHRlbXAsXG4gICAgICAgICAgICAgIGksXG4gICAgICAgICAgICAgIGVsZW0sXG4gICAgICAgICAgICAgIHByZU1hcCA9IFtdLFxuICAgICAgICAgICAgICBwb3N0TWFwID0gW10sXG4gICAgICAgICAgICAgIHByZWV4aXN0aW5nID0gcmVzdWx0cy5sZW5ndGgsXG4gICAgICAgICAgICAgIC8vIEdldCBpbml0aWFsIGVsZW1lbnRzIGZyb20gc2VlZCBvciBjb250ZXh0XG4gICAgICAgICAgZWxlbXMgPSBzZWVkIHx8IG11bHRpcGxlQ29udGV4dHMoc2VsZWN0b3IgfHwgXCIqXCIsIGNvbnRleHQubm9kZVR5cGUgPyBbY29udGV4dF0gOiBjb250ZXh0LCBbXSksXG4gICAgICAgICAgICAgIC8vIFByZWZpbHRlciB0byBnZXQgbWF0Y2hlciBpbnB1dCwgcHJlc2VydmluZyBhIG1hcCBmb3Igc2VlZC1yZXN1bHRzIHN5bmNocm9uaXphdGlvblxuICAgICAgICAgIG1hdGNoZXJJbiA9IHByZUZpbHRlciAmJiAoc2VlZCB8fCAhc2VsZWN0b3IpID8gY29uZGVuc2UoZWxlbXMsIHByZU1hcCwgcHJlRmlsdGVyLCBjb250ZXh0LCB4bWwpIDogZWxlbXMsXG4gICAgICAgICAgICAgIG1hdGNoZXJPdXQgPSBtYXRjaGVyID8gLy8gSWYgd2UgaGF2ZSBhIHBvc3RGaW5kZXIsIG9yIGZpbHRlcmVkIHNlZWQsIG9yIG5vbi1zZWVkIHBvc3RGaWx0ZXIgb3IgcHJlZXhpc3RpbmcgcmVzdWx0cyxcbiAgICAgICAgICBwb3N0RmluZGVyIHx8IChzZWVkID8gcHJlRmlsdGVyIDogcHJlZXhpc3RpbmcgfHwgcG9zdEZpbHRlcikgPyAvLyAuLi5pbnRlcm1lZGlhdGUgcHJvY2Vzc2luZyBpcyBuZWNlc3NhcnlcbiAgICAgICAgICBbXSA6IC8vIC4uLm90aGVyd2lzZSB1c2UgcmVzdWx0cyBkaXJlY3RseVxuICAgICAgICAgIHJlc3VsdHMgOiBtYXRjaGVySW47IC8vIEZpbmQgcHJpbWFyeSBtYXRjaGVzXG5cbiAgICAgICAgICBpZiAobWF0Y2hlcikge1xuICAgICAgICAgICAgbWF0Y2hlcihtYXRjaGVySW4sIG1hdGNoZXJPdXQsIGNvbnRleHQsIHhtbCk7XG4gICAgICAgICAgfSAvLyBBcHBseSBwb3N0RmlsdGVyXG5cblxuICAgICAgICAgIGlmIChwb3N0RmlsdGVyKSB7XG4gICAgICAgICAgICB0ZW1wID0gY29uZGVuc2UobWF0Y2hlck91dCwgcG9zdE1hcCk7XG4gICAgICAgICAgICBwb3N0RmlsdGVyKHRlbXAsIFtdLCBjb250ZXh0LCB4bWwpOyAvLyBVbi1tYXRjaCBmYWlsaW5nIGVsZW1lbnRzIGJ5IG1vdmluZyB0aGVtIGJhY2sgdG8gbWF0Y2hlckluXG5cbiAgICAgICAgICAgIGkgPSB0ZW1wLmxlbmd0aDtcblxuICAgICAgICAgICAgd2hpbGUgKGktLSkge1xuICAgICAgICAgICAgICBpZiAoZWxlbSA9IHRlbXBbaV0pIHtcbiAgICAgICAgICAgICAgICBtYXRjaGVyT3V0W3Bvc3RNYXBbaV1dID0gIShtYXRjaGVySW5bcG9zdE1hcFtpXV0gPSBlbGVtKTtcbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cblxuICAgICAgICAgIGlmIChzZWVkKSB7XG4gICAgICAgICAgICBpZiAocG9zdEZpbmRlciB8fCBwcmVGaWx0ZXIpIHtcbiAgICAgICAgICAgICAgaWYgKHBvc3RGaW5kZXIpIHtcbiAgICAgICAgICAgICAgICAvLyBHZXQgdGhlIGZpbmFsIG1hdGNoZXJPdXQgYnkgY29uZGVuc2luZyB0aGlzIGludGVybWVkaWF0ZSBpbnRvIHBvc3RGaW5kZXIgY29udGV4dHNcbiAgICAgICAgICAgICAgICB0ZW1wID0gW107XG4gICAgICAgICAgICAgICAgaSA9IG1hdGNoZXJPdXQubGVuZ3RoO1xuXG4gICAgICAgICAgICAgICAgd2hpbGUgKGktLSkge1xuICAgICAgICAgICAgICAgICAgaWYgKGVsZW0gPSBtYXRjaGVyT3V0W2ldKSB7XG4gICAgICAgICAgICAgICAgICAgIC8vIFJlc3RvcmUgbWF0Y2hlckluIHNpbmNlIGVsZW0gaXMgbm90IHlldCBhIGZpbmFsIG1hdGNoXG4gICAgICAgICAgICAgICAgICAgIHRlbXAucHVzaChtYXRjaGVySW5baV0gPSBlbGVtKTtcbiAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgICBwb3N0RmluZGVyKG51bGwsIG1hdGNoZXJPdXQgPSBbXSwgdGVtcCwgeG1sKTtcbiAgICAgICAgICAgICAgfSAvLyBNb3ZlIG1hdGNoZWQgZWxlbWVudHMgZnJvbSBzZWVkIHRvIHJlc3VsdHMgdG8ga2VlcCB0aGVtIHN5bmNocm9uaXplZFxuXG5cbiAgICAgICAgICAgICAgaSA9IG1hdGNoZXJPdXQubGVuZ3RoO1xuXG4gICAgICAgICAgICAgIHdoaWxlIChpLS0pIHtcbiAgICAgICAgICAgICAgICBpZiAoKGVsZW0gPSBtYXRjaGVyT3V0W2ldKSAmJiAodGVtcCA9IHBvc3RGaW5kZXIgPyBpbmRleE9mKHNlZWQsIGVsZW0pIDogcHJlTWFwW2ldKSA+IC0xKSB7XG4gICAgICAgICAgICAgICAgICBzZWVkW3RlbXBdID0gIShyZXN1bHRzW3RlbXBdID0gZWxlbSk7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9IC8vIEFkZCBlbGVtZW50cyB0byByZXN1bHRzLCB0aHJvdWdoIHBvc3RGaW5kZXIgaWYgZGVmaW5lZFxuXG4gICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIG1hdGNoZXJPdXQgPSBjb25kZW5zZShtYXRjaGVyT3V0ID09PSByZXN1bHRzID8gbWF0Y2hlck91dC5zcGxpY2UocHJlZXhpc3RpbmcsIG1hdGNoZXJPdXQubGVuZ3RoKSA6IG1hdGNoZXJPdXQpO1xuXG4gICAgICAgICAgICBpZiAocG9zdEZpbmRlcikge1xuICAgICAgICAgICAgICBwb3N0RmluZGVyKG51bGwsIHJlc3VsdHMsIG1hdGNoZXJPdXQsIHhtbCk7XG4gICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICBwdXNoLmFwcGx5KHJlc3VsdHMsIG1hdGNoZXJPdXQpO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cbiAgICAgICAgfSk7XG4gICAgICB9XG5cbiAgICAgIGZ1bmN0aW9uIG1hdGNoZXJGcm9tVG9rZW5zKHRva2Vucykge1xuICAgICAgICB2YXIgY2hlY2tDb250ZXh0LFxuICAgICAgICAgICAgbWF0Y2hlcixcbiAgICAgICAgICAgIGosXG4gICAgICAgICAgICBsZW4gPSB0b2tlbnMubGVuZ3RoLFxuICAgICAgICAgICAgbGVhZGluZ1JlbGF0aXZlID0gRXhwci5yZWxhdGl2ZVt0b2tlbnNbMF0udHlwZV0sXG4gICAgICAgICAgICBpbXBsaWNpdFJlbGF0aXZlID0gbGVhZGluZ1JlbGF0aXZlIHx8IEV4cHIucmVsYXRpdmVbXCIgXCJdLFxuICAgICAgICAgICAgaSA9IGxlYWRpbmdSZWxhdGl2ZSA/IDEgOiAwLFxuICAgICAgICAgICAgLy8gVGhlIGZvdW5kYXRpb25hbCBtYXRjaGVyIGVuc3VyZXMgdGhhdCBlbGVtZW50cyBhcmUgcmVhY2hhYmxlIGZyb20gdG9wLWxldmVsIGNvbnRleHQocylcbiAgICAgICAgbWF0Y2hDb250ZXh0ID0gYWRkQ29tYmluYXRvcihmdW5jdGlvbiAoZWxlbSkge1xuICAgICAgICAgIHJldHVybiBlbGVtID09PSBjaGVja0NvbnRleHQ7XG4gICAgICAgIH0sIGltcGxpY2l0UmVsYXRpdmUsIHRydWUpLFxuICAgICAgICAgICAgbWF0Y2hBbnlDb250ZXh0ID0gYWRkQ29tYmluYXRvcihmdW5jdGlvbiAoZWxlbSkge1xuICAgICAgICAgIHJldHVybiBpbmRleE9mKGNoZWNrQ29udGV4dCwgZWxlbSkgPiAtMTtcbiAgICAgICAgfSwgaW1wbGljaXRSZWxhdGl2ZSwgdHJ1ZSksXG4gICAgICAgICAgICBtYXRjaGVycyA9IFtmdW5jdGlvbiAoZWxlbSwgY29udGV4dCwgeG1sKSB7XG4gICAgICAgICAgdmFyIHJldCA9ICFsZWFkaW5nUmVsYXRpdmUgJiYgKHhtbCB8fCBjb250ZXh0ICE9PSBvdXRlcm1vc3RDb250ZXh0KSB8fCAoKGNoZWNrQ29udGV4dCA9IGNvbnRleHQpLm5vZGVUeXBlID8gbWF0Y2hDb250ZXh0KGVsZW0sIGNvbnRleHQsIHhtbCkgOiBtYXRjaEFueUNvbnRleHQoZWxlbSwgY29udGV4dCwgeG1sKSk7IC8vIEF2b2lkIGhhbmdpbmcgb250byBlbGVtZW50IChpc3N1ZSAjMjk5KVxuXG4gICAgICAgICAgY2hlY2tDb250ZXh0ID0gbnVsbDtcbiAgICAgICAgICByZXR1cm4gcmV0O1xuICAgICAgICB9XTtcblxuICAgICAgICBmb3IgKDsgaSA8IGxlbjsgaSsrKSB7XG4gICAgICAgICAgaWYgKG1hdGNoZXIgPSBFeHByLnJlbGF0aXZlW3Rva2Vuc1tpXS50eXBlXSkge1xuICAgICAgICAgICAgbWF0Y2hlcnMgPSBbYWRkQ29tYmluYXRvcihlbGVtZW50TWF0Y2hlcihtYXRjaGVycyksIG1hdGNoZXIpXTtcbiAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgbWF0Y2hlciA9IEV4cHIuZmlsdGVyW3Rva2Vuc1tpXS50eXBlXS5hcHBseShudWxsLCB0b2tlbnNbaV0ubWF0Y2hlcyk7IC8vIFJldHVybiBzcGVjaWFsIHVwb24gc2VlaW5nIGEgcG9zaXRpb25hbCBtYXRjaGVyXG5cbiAgICAgICAgICAgIGlmIChtYXRjaGVyW2V4cGFuZG9dKSB7XG4gICAgICAgICAgICAgIC8vIEZpbmQgdGhlIG5leHQgcmVsYXRpdmUgb3BlcmF0b3IgKGlmIGFueSkgZm9yIHByb3BlciBoYW5kbGluZ1xuICAgICAgICAgICAgICBqID0gKytpO1xuXG4gICAgICAgICAgICAgIGZvciAoOyBqIDwgbGVuOyBqKyspIHtcbiAgICAgICAgICAgICAgICBpZiAoRXhwci5yZWxhdGl2ZVt0b2tlbnNbal0udHlwZV0pIHtcbiAgICAgICAgICAgICAgICAgIGJyZWFrO1xuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgIHJldHVybiBzZXRNYXRjaGVyKGkgPiAxICYmIGVsZW1lbnRNYXRjaGVyKG1hdGNoZXJzKSwgaSA+IDEgJiYgdG9TZWxlY3RvciggLy8gSWYgdGhlIHByZWNlZGluZyB0b2tlbiB3YXMgYSBkZXNjZW5kYW50IGNvbWJpbmF0b3IsIGluc2VydCBhbiBpbXBsaWNpdCBhbnktZWxlbWVudCBgKmBcbiAgICAgICAgICAgICAgdG9rZW5zLnNsaWNlKDAsIGkgLSAxKS5jb25jYXQoe1xuICAgICAgICAgICAgICAgIHZhbHVlOiB0b2tlbnNbaSAtIDJdLnR5cGUgPT09IFwiIFwiID8gXCIqXCIgOiBcIlwiXG4gICAgICAgICAgICAgIH0pKS5yZXBsYWNlKHJ0cmltLCBcIiQxXCIpLCBtYXRjaGVyLCBpIDwgaiAmJiBtYXRjaGVyRnJvbVRva2Vucyh0b2tlbnMuc2xpY2UoaSwgaikpLCBqIDwgbGVuICYmIG1hdGNoZXJGcm9tVG9rZW5zKHRva2VucyA9IHRva2Vucy5zbGljZShqKSksIGogPCBsZW4gJiYgdG9TZWxlY3Rvcih0b2tlbnMpKTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgbWF0Y2hlcnMucHVzaChtYXRjaGVyKTtcbiAgICAgICAgICB9XG4gICAgICAgIH1cblxuICAgICAgICByZXR1cm4gZWxlbWVudE1hdGNoZXIobWF0Y2hlcnMpO1xuICAgICAgfVxuXG4gICAgICBmdW5jdGlvbiBtYXRjaGVyRnJvbUdyb3VwTWF0Y2hlcnMoZWxlbWVudE1hdGNoZXJzLCBzZXRNYXRjaGVycykge1xuICAgICAgICB2YXIgYnlTZXQgPSBzZXRNYXRjaGVycy5sZW5ndGggPiAwLFxuICAgICAgICAgICAgYnlFbGVtZW50ID0gZWxlbWVudE1hdGNoZXJzLmxlbmd0aCA+IDAsXG4gICAgICAgICAgICBzdXBlck1hdGNoZXIgPSBmdW5jdGlvbiBzdXBlck1hdGNoZXIoc2VlZCwgY29udGV4dCwgeG1sLCByZXN1bHRzLCBvdXRlcm1vc3QpIHtcbiAgICAgICAgICB2YXIgZWxlbSxcbiAgICAgICAgICAgICAgaixcbiAgICAgICAgICAgICAgbWF0Y2hlcixcbiAgICAgICAgICAgICAgbWF0Y2hlZENvdW50ID0gMCxcbiAgICAgICAgICAgICAgaSA9IFwiMFwiLFxuICAgICAgICAgICAgICB1bm1hdGNoZWQgPSBzZWVkICYmIFtdLFxuICAgICAgICAgICAgICBzZXRNYXRjaGVkID0gW10sXG4gICAgICAgICAgICAgIGNvbnRleHRCYWNrdXAgPSBvdXRlcm1vc3RDb250ZXh0LFxuICAgICAgICAgICAgICAvLyBXZSBtdXN0IGFsd2F5cyBoYXZlIGVpdGhlciBzZWVkIGVsZW1lbnRzIG9yIG91dGVybW9zdCBjb250ZXh0XG4gICAgICAgICAgZWxlbXMgPSBzZWVkIHx8IGJ5RWxlbWVudCAmJiBFeHByLmZpbmRbXCJUQUdcIl0oXCIqXCIsIG91dGVybW9zdCksXG4gICAgICAgICAgICAgIC8vIFVzZSBpbnRlZ2VyIGRpcnJ1bnMgaWZmIHRoaXMgaXMgdGhlIG91dGVybW9zdCBtYXRjaGVyXG4gICAgICAgICAgZGlycnVuc1VuaXF1ZSA9IGRpcnJ1bnMgKz0gY29udGV4dEJhY2t1cCA9PSBudWxsID8gMSA6IE1hdGgucmFuZG9tKCkgfHwgMC4xLFxuICAgICAgICAgICAgICBsZW4gPSBlbGVtcy5sZW5ndGg7XG5cbiAgICAgICAgICBpZiAob3V0ZXJtb3N0KSB7XG4gICAgICAgICAgICBvdXRlcm1vc3RDb250ZXh0ID0gY29udGV4dCA9PT0gZG9jdW1lbnQgfHwgY29udGV4dCB8fCBvdXRlcm1vc3Q7XG4gICAgICAgICAgfSAvLyBBZGQgZWxlbWVudHMgcGFzc2luZyBlbGVtZW50TWF0Y2hlcnMgZGlyZWN0bHkgdG8gcmVzdWx0c1xuICAgICAgICAgIC8vIFN1cHBvcnQ6IElFPDksIFNhZmFyaVxuICAgICAgICAgIC8vIFRvbGVyYXRlIE5vZGVMaXN0IHByb3BlcnRpZXMgKElFOiBcImxlbmd0aFwiOyBTYWZhcmk6IDxudW1iZXI+KSBtYXRjaGluZyBlbGVtZW50cyBieSBpZFxuXG5cbiAgICAgICAgICBmb3IgKDsgaSAhPT0gbGVuICYmIChlbGVtID0gZWxlbXNbaV0pICE9IG51bGw7IGkrKykge1xuICAgICAgICAgICAgaWYgKGJ5RWxlbWVudCAmJiBlbGVtKSB7XG4gICAgICAgICAgICAgIGogPSAwO1xuXG4gICAgICAgICAgICAgIGlmICghY29udGV4dCAmJiBlbGVtLm93bmVyRG9jdW1lbnQgIT09IGRvY3VtZW50KSB7XG4gICAgICAgICAgICAgICAgc2V0RG9jdW1lbnQoZWxlbSk7XG4gICAgICAgICAgICAgICAgeG1sID0gIWRvY3VtZW50SXNIVE1MO1xuICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgd2hpbGUgKG1hdGNoZXIgPSBlbGVtZW50TWF0Y2hlcnNbaisrXSkge1xuICAgICAgICAgICAgICAgIGlmIChtYXRjaGVyKGVsZW0sIGNvbnRleHQgfHwgZG9jdW1lbnQsIHhtbCkpIHtcbiAgICAgICAgICAgICAgICAgIHJlc3VsdHMucHVzaChlbGVtKTtcbiAgICAgICAgICAgICAgICAgIGJyZWFrO1xuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgIGlmIChvdXRlcm1vc3QpIHtcbiAgICAgICAgICAgICAgICBkaXJydW5zID0gZGlycnVuc1VuaXF1ZTtcbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfSAvLyBUcmFjayB1bm1hdGNoZWQgZWxlbWVudHMgZm9yIHNldCBmaWx0ZXJzXG5cblxuICAgICAgICAgICAgaWYgKGJ5U2V0KSB7XG4gICAgICAgICAgICAgIC8vIFRoZXkgd2lsbCBoYXZlIGdvbmUgdGhyb3VnaCBhbGwgcG9zc2libGUgbWF0Y2hlcnNcbiAgICAgICAgICAgICAgaWYgKGVsZW0gPSAhbWF0Y2hlciAmJiBlbGVtKSB7XG4gICAgICAgICAgICAgICAgbWF0Y2hlZENvdW50LS07XG4gICAgICAgICAgICAgIH0gLy8gTGVuZ3RoZW4gdGhlIGFycmF5IGZvciBldmVyeSBlbGVtZW50LCBtYXRjaGVkIG9yIG5vdFxuXG5cbiAgICAgICAgICAgICAgaWYgKHNlZWQpIHtcbiAgICAgICAgICAgICAgICB1bm1hdGNoZWQucHVzaChlbGVtKTtcbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfVxuICAgICAgICAgIH0gLy8gYGlgIGlzIG5vdyB0aGUgY291bnQgb2YgZWxlbWVudHMgdmlzaXRlZCBhYm92ZSwgYW5kIGFkZGluZyBpdCB0byBgbWF0Y2hlZENvdW50YFxuICAgICAgICAgIC8vIG1ha2VzIHRoZSBsYXR0ZXIgbm9ubmVnYXRpdmUuXG5cblxuICAgICAgICAgIG1hdGNoZWRDb3VudCArPSBpOyAvLyBBcHBseSBzZXQgZmlsdGVycyB0byB1bm1hdGNoZWQgZWxlbWVudHNcbiAgICAgICAgICAvLyBOT1RFOiBUaGlzIGNhbiBiZSBza2lwcGVkIGlmIHRoZXJlIGFyZSBubyB1bm1hdGNoZWQgZWxlbWVudHMgKGkuZS4sIGBtYXRjaGVkQ291bnRgXG4gICAgICAgICAgLy8gZXF1YWxzIGBpYCksIHVubGVzcyB3ZSBkaWRuJ3QgdmlzaXQgX2FueV8gZWxlbWVudHMgaW4gdGhlIGFib3ZlIGxvb3AgYmVjYXVzZSB3ZSBoYXZlXG4gICAgICAgICAgLy8gbm8gZWxlbWVudCBtYXRjaGVycyBhbmQgbm8gc2VlZC5cbiAgICAgICAgICAvLyBJbmNyZW1lbnRpbmcgYW4gaW5pdGlhbGx5LXN0cmluZyBcIjBcIiBgaWAgYWxsb3dzIGBpYCB0byByZW1haW4gYSBzdHJpbmcgb25seSBpbiB0aGF0XG4gICAgICAgICAgLy8gY2FzZSwgd2hpY2ggd2lsbCByZXN1bHQgaW4gYSBcIjAwXCIgYG1hdGNoZWRDb3VudGAgdGhhdCBkaWZmZXJzIGZyb20gYGlgIGJ1dCBpcyBhbHNvXG4gICAgICAgICAgLy8gbnVtZXJpY2FsbHkgemVyby5cblxuICAgICAgICAgIGlmIChieVNldCAmJiBpICE9PSBtYXRjaGVkQ291bnQpIHtcbiAgICAgICAgICAgIGogPSAwO1xuXG4gICAgICAgICAgICB3aGlsZSAobWF0Y2hlciA9IHNldE1hdGNoZXJzW2orK10pIHtcbiAgICAgICAgICAgICAgbWF0Y2hlcih1bm1hdGNoZWQsIHNldE1hdGNoZWQsIGNvbnRleHQsIHhtbCk7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIGlmIChzZWVkKSB7XG4gICAgICAgICAgICAgIC8vIFJlaW50ZWdyYXRlIGVsZW1lbnQgbWF0Y2hlcyB0byBlbGltaW5hdGUgdGhlIG5lZWQgZm9yIHNvcnRpbmdcbiAgICAgICAgICAgICAgaWYgKG1hdGNoZWRDb3VudCA+IDApIHtcbiAgICAgICAgICAgICAgICB3aGlsZSAoaS0tKSB7XG4gICAgICAgICAgICAgICAgICBpZiAoISh1bm1hdGNoZWRbaV0gfHwgc2V0TWF0Y2hlZFtpXSkpIHtcbiAgICAgICAgICAgICAgICAgICAgc2V0TWF0Y2hlZFtpXSA9IHBvcC5jYWxsKHJlc3VsdHMpO1xuICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgfSAvLyBEaXNjYXJkIGluZGV4IHBsYWNlaG9sZGVyIHZhbHVlcyB0byBnZXQgb25seSBhY3R1YWwgbWF0Y2hlc1xuXG5cbiAgICAgICAgICAgICAgc2V0TWF0Y2hlZCA9IGNvbmRlbnNlKHNldE1hdGNoZWQpO1xuICAgICAgICAgICAgfSAvLyBBZGQgbWF0Y2hlcyB0byByZXN1bHRzXG5cblxuICAgICAgICAgICAgcHVzaC5hcHBseShyZXN1bHRzLCBzZXRNYXRjaGVkKTsgLy8gU2VlZGxlc3Mgc2V0IG1hdGNoZXMgc3VjY2VlZGluZyBtdWx0aXBsZSBzdWNjZXNzZnVsIG1hdGNoZXJzIHN0aXB1bGF0ZSBzb3J0aW5nXG5cbiAgICAgICAgICAgIGlmIChvdXRlcm1vc3QgJiYgIXNlZWQgJiYgc2V0TWF0Y2hlZC5sZW5ndGggPiAwICYmIG1hdGNoZWRDb3VudCArIHNldE1hdGNoZXJzLmxlbmd0aCA+IDEpIHtcbiAgICAgICAgICAgICAgU2l6emxlLnVuaXF1ZVNvcnQocmVzdWx0cyk7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfSAvLyBPdmVycmlkZSBtYW5pcHVsYXRpb24gb2YgZ2xvYmFscyBieSBuZXN0ZWQgbWF0Y2hlcnNcblxuXG4gICAgICAgICAgaWYgKG91dGVybW9zdCkge1xuICAgICAgICAgICAgZGlycnVucyA9IGRpcnJ1bnNVbmlxdWU7XG4gICAgICAgICAgICBvdXRlcm1vc3RDb250ZXh0ID0gY29udGV4dEJhY2t1cDtcbiAgICAgICAgICB9XG5cbiAgICAgICAgICByZXR1cm4gdW5tYXRjaGVkO1xuICAgICAgICB9O1xuXG4gICAgICAgIHJldHVybiBieVNldCA/IG1hcmtGdW5jdGlvbihzdXBlck1hdGNoZXIpIDogc3VwZXJNYXRjaGVyO1xuICAgICAgfVxuXG4gICAgICBjb21waWxlID0gU2l6emxlLmNvbXBpbGUgPSBmdW5jdGlvbiAoc2VsZWN0b3IsIG1hdGNoXG4gICAgICAvKiBJbnRlcm5hbCBVc2UgT25seSAqL1xuICAgICAgKSB7XG4gICAgICAgIHZhciBpLFxuICAgICAgICAgICAgc2V0TWF0Y2hlcnMgPSBbXSxcbiAgICAgICAgICAgIGVsZW1lbnRNYXRjaGVycyA9IFtdLFxuICAgICAgICAgICAgY2FjaGVkID0gY29tcGlsZXJDYWNoZVtzZWxlY3RvciArIFwiIFwiXTtcblxuICAgICAgICBpZiAoIWNhY2hlZCkge1xuICAgICAgICAgIC8vIEdlbmVyYXRlIGEgZnVuY3Rpb24gb2YgcmVjdXJzaXZlIGZ1bmN0aW9ucyB0aGF0IGNhbiBiZSB1c2VkIHRvIGNoZWNrIGVhY2ggZWxlbWVudFxuICAgICAgICAgIGlmICghbWF0Y2gpIHtcbiAgICAgICAgICAgIG1hdGNoID0gdG9rZW5pemUoc2VsZWN0b3IpO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIGkgPSBtYXRjaC5sZW5ndGg7XG5cbiAgICAgICAgICB3aGlsZSAoaS0tKSB7XG4gICAgICAgICAgICBjYWNoZWQgPSBtYXRjaGVyRnJvbVRva2VucyhtYXRjaFtpXSk7XG5cbiAgICAgICAgICAgIGlmIChjYWNoZWRbZXhwYW5kb10pIHtcbiAgICAgICAgICAgICAgc2V0TWF0Y2hlcnMucHVzaChjYWNoZWQpO1xuICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgZWxlbWVudE1hdGNoZXJzLnB1c2goY2FjaGVkKTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9IC8vIENhY2hlIHRoZSBjb21waWxlZCBmdW5jdGlvblxuXG5cbiAgICAgICAgICBjYWNoZWQgPSBjb21waWxlckNhY2hlKHNlbGVjdG9yLCBtYXRjaGVyRnJvbUdyb3VwTWF0Y2hlcnMoZWxlbWVudE1hdGNoZXJzLCBzZXRNYXRjaGVycykpOyAvLyBTYXZlIHNlbGVjdG9yIGFuZCB0b2tlbml6YXRpb25cblxuICAgICAgICAgIGNhY2hlZC5zZWxlY3RvciA9IHNlbGVjdG9yO1xuICAgICAgICB9XG5cbiAgICAgICAgcmV0dXJuIGNhY2hlZDtcbiAgICAgIH07XG4gICAgICAvKipcbiAgICAgICAqIEEgbG93LWxldmVsIHNlbGVjdGlvbiBmdW5jdGlvbiB0aGF0IHdvcmtzIHdpdGggU2l6emxlJ3MgY29tcGlsZWRcbiAgICAgICAqICBzZWxlY3RvciBmdW5jdGlvbnNcbiAgICAgICAqIEBwYXJhbSB7U3RyaW5nfEZ1bmN0aW9ufSBzZWxlY3RvciBBIHNlbGVjdG9yIG9yIGEgcHJlLWNvbXBpbGVkXG4gICAgICAgKiAgc2VsZWN0b3IgZnVuY3Rpb24gYnVpbHQgd2l0aCBTaXp6bGUuY29tcGlsZVxuICAgICAgICogQHBhcmFtIHtFbGVtZW50fSBjb250ZXh0XG4gICAgICAgKiBAcGFyYW0ge0FycmF5fSBbcmVzdWx0c11cbiAgICAgICAqIEBwYXJhbSB7QXJyYXl9IFtzZWVkXSBBIHNldCBvZiBlbGVtZW50cyB0byBtYXRjaCBhZ2FpbnN0XG4gICAgICAgKi9cblxuXG4gICAgICBzZWxlY3QgPSBTaXp6bGUuc2VsZWN0ID0gZnVuY3Rpb24gKHNlbGVjdG9yLCBjb250ZXh0LCByZXN1bHRzLCBzZWVkKSB7XG4gICAgICAgIHZhciBpLFxuICAgICAgICAgICAgdG9rZW5zLFxuICAgICAgICAgICAgdG9rZW4sXG4gICAgICAgICAgICB0eXBlLFxuICAgICAgICAgICAgZmluZCxcbiAgICAgICAgICAgIGNvbXBpbGVkID0gdHlwZW9mIHNlbGVjdG9yID09PSBcImZ1bmN0aW9uXCIgJiYgc2VsZWN0b3IsXG4gICAgICAgICAgICBtYXRjaCA9ICFzZWVkICYmIHRva2VuaXplKHNlbGVjdG9yID0gY29tcGlsZWQuc2VsZWN0b3IgfHwgc2VsZWN0b3IpO1xuICAgICAgICByZXN1bHRzID0gcmVzdWx0cyB8fCBbXTsgLy8gVHJ5IHRvIG1pbmltaXplIG9wZXJhdGlvbnMgaWYgdGhlcmUgaXMgb25seSBvbmUgc2VsZWN0b3IgaW4gdGhlIGxpc3QgYW5kIG5vIHNlZWRcbiAgICAgICAgLy8gKHRoZSBsYXR0ZXIgb2Ygd2hpY2ggZ3VhcmFudGVlcyB1cyBjb250ZXh0KVxuXG4gICAgICAgIGlmIChtYXRjaC5sZW5ndGggPT09IDEpIHtcbiAgICAgICAgICAvLyBSZWR1Y2UgY29udGV4dCBpZiB0aGUgbGVhZGluZyBjb21wb3VuZCBzZWxlY3RvciBpcyBhbiBJRFxuICAgICAgICAgIHRva2VucyA9IG1hdGNoWzBdID0gbWF0Y2hbMF0uc2xpY2UoMCk7XG5cbiAgICAgICAgICBpZiAodG9rZW5zLmxlbmd0aCA+IDIgJiYgKHRva2VuID0gdG9rZW5zWzBdKS50eXBlID09PSBcIklEXCIgJiYgY29udGV4dC5ub2RlVHlwZSA9PT0gOSAmJiBkb2N1bWVudElzSFRNTCAmJiBFeHByLnJlbGF0aXZlW3Rva2Vuc1sxXS50eXBlXSkge1xuICAgICAgICAgICAgY29udGV4dCA9IChFeHByLmZpbmRbXCJJRFwiXSh0b2tlbi5tYXRjaGVzWzBdLnJlcGxhY2UocnVuZXNjYXBlLCBmdW5lc2NhcGUpLCBjb250ZXh0KSB8fCBbXSlbMF07XG5cbiAgICAgICAgICAgIGlmICghY29udGV4dCkge1xuICAgICAgICAgICAgICByZXR1cm4gcmVzdWx0czsgLy8gUHJlY29tcGlsZWQgbWF0Y2hlcnMgd2lsbCBzdGlsbCB2ZXJpZnkgYW5jZXN0cnksIHNvIHN0ZXAgdXAgYSBsZXZlbFxuICAgICAgICAgICAgfSBlbHNlIGlmIChjb21waWxlZCkge1xuICAgICAgICAgICAgICBjb250ZXh0ID0gY29udGV4dC5wYXJlbnROb2RlO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICBzZWxlY3RvciA9IHNlbGVjdG9yLnNsaWNlKHRva2Vucy5zaGlmdCgpLnZhbHVlLmxlbmd0aCk7XG4gICAgICAgICAgfSAvLyBGZXRjaCBhIHNlZWQgc2V0IGZvciByaWdodC10by1sZWZ0IG1hdGNoaW5nXG5cblxuICAgICAgICAgIGkgPSBtYXRjaEV4cHJbXCJuZWVkc0NvbnRleHRcIl0udGVzdChzZWxlY3RvcikgPyAwIDogdG9rZW5zLmxlbmd0aDtcblxuICAgICAgICAgIHdoaWxlIChpLS0pIHtcbiAgICAgICAgICAgIHRva2VuID0gdG9rZW5zW2ldOyAvLyBBYm9ydCBpZiB3ZSBoaXQgYSBjb21iaW5hdG9yXG5cbiAgICAgICAgICAgIGlmIChFeHByLnJlbGF0aXZlW3R5cGUgPSB0b2tlbi50eXBlXSkge1xuICAgICAgICAgICAgICBicmVhaztcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgaWYgKGZpbmQgPSBFeHByLmZpbmRbdHlwZV0pIHtcbiAgICAgICAgICAgICAgLy8gU2VhcmNoLCBleHBhbmRpbmcgY29udGV4dCBmb3IgbGVhZGluZyBzaWJsaW5nIGNvbWJpbmF0b3JzXG4gICAgICAgICAgICAgIGlmIChzZWVkID0gZmluZCh0b2tlbi5tYXRjaGVzWzBdLnJlcGxhY2UocnVuZXNjYXBlLCBmdW5lc2NhcGUpLCByc2libGluZy50ZXN0KHRva2Vuc1swXS50eXBlKSAmJiB0ZXN0Q29udGV4dChjb250ZXh0LnBhcmVudE5vZGUpIHx8IGNvbnRleHQpKSB7XG4gICAgICAgICAgICAgICAgLy8gSWYgc2VlZCBpcyBlbXB0eSBvciBubyB0b2tlbnMgcmVtYWluLCB3ZSBjYW4gcmV0dXJuIGVhcmx5XG4gICAgICAgICAgICAgICAgdG9rZW5zLnNwbGljZShpLCAxKTtcbiAgICAgICAgICAgICAgICBzZWxlY3RvciA9IHNlZWQubGVuZ3RoICYmIHRvU2VsZWN0b3IodG9rZW5zKTtcblxuICAgICAgICAgICAgICAgIGlmICghc2VsZWN0b3IpIHtcbiAgICAgICAgICAgICAgICAgIHB1c2guYXBwbHkocmVzdWx0cywgc2VlZCk7XG4gICAgICAgICAgICAgICAgICByZXR1cm4gcmVzdWx0cztcbiAgICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgICBicmVhaztcbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cbiAgICAgICAgfSAvLyBDb21waWxlIGFuZCBleGVjdXRlIGEgZmlsdGVyaW5nIGZ1bmN0aW9uIGlmIG9uZSBpcyBub3QgcHJvdmlkZWRcbiAgICAgICAgLy8gUHJvdmlkZSBgbWF0Y2hgIHRvIGF2b2lkIHJldG9rZW5pemF0aW9uIGlmIHdlIG1vZGlmaWVkIHRoZSBzZWxlY3RvciBhYm92ZVxuXG5cbiAgICAgICAgKGNvbXBpbGVkIHx8IGNvbXBpbGUoc2VsZWN0b3IsIG1hdGNoKSkoc2VlZCwgY29udGV4dCwgIWRvY3VtZW50SXNIVE1MLCByZXN1bHRzLCAhY29udGV4dCB8fCByc2libGluZy50ZXN0KHNlbGVjdG9yKSAmJiB0ZXN0Q29udGV4dChjb250ZXh0LnBhcmVudE5vZGUpIHx8IGNvbnRleHQpO1xuICAgICAgICByZXR1cm4gcmVzdWx0cztcbiAgICAgIH07IC8vIE9uZS10aW1lIGFzc2lnbm1lbnRzXG4gICAgICAvLyBTb3J0IHN0YWJpbGl0eVxuXG5cbiAgICAgIHN1cHBvcnQuc29ydFN0YWJsZSA9IGV4cGFuZG8uc3BsaXQoXCJcIikuc29ydChzb3J0T3JkZXIpLmpvaW4oXCJcIikgPT09IGV4cGFuZG87IC8vIFN1cHBvcnQ6IENocm9tZSAxNC0zNStcbiAgICAgIC8vIEFsd2F5cyBhc3N1bWUgZHVwbGljYXRlcyBpZiB0aGV5IGFyZW4ndCBwYXNzZWQgdG8gdGhlIGNvbXBhcmlzb24gZnVuY3Rpb25cblxuICAgICAgc3VwcG9ydC5kZXRlY3REdXBsaWNhdGVzID0gISFoYXNEdXBsaWNhdGU7IC8vIEluaXRpYWxpemUgYWdhaW5zdCB0aGUgZGVmYXVsdCBkb2N1bWVudFxuXG4gICAgICBzZXREb2N1bWVudCgpOyAvLyBTdXBwb3J0OiBXZWJraXQ8NTM3LjMyIC0gU2FmYXJpIDYuMC4zL0Nocm9tZSAyNSAoZml4ZWQgaW4gQ2hyb21lIDI3KVxuICAgICAgLy8gRGV0YWNoZWQgbm9kZXMgY29uZm91bmRpbmdseSBmb2xsb3cgKmVhY2ggb3RoZXIqXG5cbiAgICAgIHN1cHBvcnQuc29ydERldGFjaGVkID0gYXNzZXJ0KGZ1bmN0aW9uIChlbCkge1xuICAgICAgICAvLyBTaG91bGQgcmV0dXJuIDEsIGJ1dCByZXR1cm5zIDQgKGZvbGxvd2luZylcbiAgICAgICAgcmV0dXJuIGVsLmNvbXBhcmVEb2N1bWVudFBvc2l0aW9uKGRvY3VtZW50LmNyZWF0ZUVsZW1lbnQoXCJmaWVsZHNldFwiKSkgJiAxO1xuICAgICAgfSk7IC8vIFN1cHBvcnQ6IElFPDhcbiAgICAgIC8vIFByZXZlbnQgYXR0cmlidXRlL3Byb3BlcnR5IFwiaW50ZXJwb2xhdGlvblwiXG4gICAgICAvLyBodHRwczovL21zZG4ubWljcm9zb2Z0LmNvbS9lbi11cy9saWJyYXJ5L21zNTM2NDI5JTI4VlMuODUlMjkuYXNweFxuXG4gICAgICBpZiAoIWFzc2VydChmdW5jdGlvbiAoZWwpIHtcbiAgICAgICAgZWwuaW5uZXJIVE1MID0gQUdQb2xpY3kuY3JlYXRlSFRNTChcIjxhIGhyZWY9JyMnPjwvYT5cIik7XG4gICAgICAgIHJldHVybiBlbC5maXJzdENoaWxkLmdldEF0dHJpYnV0ZShcImhyZWZcIikgPT09IFwiI1wiO1xuICAgICAgfSkpIHtcbiAgICAgICAgYWRkSGFuZGxlKFwidHlwZXxocmVmfGhlaWdodHx3aWR0aFwiLCBmdW5jdGlvbiAoZWxlbSwgbmFtZSwgaXNYTUwpIHtcbiAgICAgICAgICBpZiAoIWlzWE1MKSB7XG4gICAgICAgICAgICByZXR1cm4gZWxlbS5nZXRBdHRyaWJ1dGUobmFtZSwgbmFtZS50b0xvd2VyQ2FzZSgpID09PSBcInR5cGVcIiA/IDEgOiAyKTtcbiAgICAgICAgICB9XG4gICAgICAgIH0pO1xuICAgICAgfSAvLyBTdXBwb3J0OiBJRTw5XG4gICAgICAvLyBVc2UgZGVmYXVsdFZhbHVlIGluIHBsYWNlIG9mIGdldEF0dHJpYnV0ZShcInZhbHVlXCIpXG5cblxuICAgICAgaWYgKCFzdXBwb3J0LmF0dHJpYnV0ZXMgfHwgIWFzc2VydChmdW5jdGlvbiAoZWwpIHtcbiAgICAgICAgZWwuaW5uZXJIVE1MID0gQUdQb2xpY3kuY3JlYXRlSFRNTChcIjxpbnB1dC8+XCIpO1xuICAgICAgICBlbC5maXJzdENoaWxkLnNldEF0dHJpYnV0ZShcInZhbHVlXCIsIFwiXCIpO1xuICAgICAgICByZXR1cm4gZWwuZmlyc3RDaGlsZC5nZXRBdHRyaWJ1dGUoXCJ2YWx1ZVwiKSA9PT0gXCJcIjtcbiAgICAgIH0pKSB7XG4gICAgICAgIGFkZEhhbmRsZShcInZhbHVlXCIsIGZ1bmN0aW9uIChlbGVtLCBuYW1lLCBpc1hNTCkge1xuICAgICAgICAgIGlmICghaXNYTUwgJiYgZWxlbS5ub2RlTmFtZS50b0xvd2VyQ2FzZSgpID09PSBcImlucHV0XCIpIHtcbiAgICAgICAgICAgIHJldHVybiBlbGVtLmRlZmF1bHRWYWx1ZTtcbiAgICAgICAgICB9XG4gICAgICAgIH0pO1xuICAgICAgfSAvLyBTdXBwb3J0OiBJRTw5XG4gICAgICAvLyBVc2UgZ2V0QXR0cmlidXRlTm9kZSB0byBmZXRjaCBib29sZWFucyB3aGVuIGdldEF0dHJpYnV0ZSBsaWVzXG5cblxuICAgICAgaWYgKCFhc3NlcnQoZnVuY3Rpb24gKGVsKSB7XG4gICAgICAgIHJldHVybiBlbC5nZXRBdHRyaWJ1dGUoXCJkaXNhYmxlZFwiKSA9PSBudWxsO1xuICAgICAgfSkpIHtcbiAgICAgICAgYWRkSGFuZGxlKGJvb2xlYW5zLCBmdW5jdGlvbiAoZWxlbSwgbmFtZSwgaXNYTUwpIHtcbiAgICAgICAgICB2YXIgdmFsO1xuXG4gICAgICAgICAgaWYgKCFpc1hNTCkge1xuICAgICAgICAgICAgcmV0dXJuIGVsZW1bbmFtZV0gPT09IHRydWUgPyBuYW1lLnRvTG93ZXJDYXNlKCkgOiAodmFsID0gZWxlbS5nZXRBdHRyaWJ1dGVOb2RlKG5hbWUpKSAmJiB2YWwuc3BlY2lmaWVkID8gdmFsLnZhbHVlIDogbnVsbDtcbiAgICAgICAgICB9XG4gICAgICAgIH0pO1xuICAgICAgfSAvLyBFWFBPU0VcbiAgICAgIC8vIERvIG5vdCBleHBvc2UgU2l6emxlIHRvIHRoZSBnbG9iYWwgc2NvcGUgaW4gdGhlIGNhc2Ugb2YgQWRHdWFyZCBFeHRlbmRlZENzcyBidWlsZFxuXG5cbiAgICAgIHJldHVybiBTaXp6bGU7IC8vIEVYUE9TRVxuICAgIH0od2luZG93KTsgLy8+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj5cblxuICB9XG5cbiAgcmV0dXJuIFNpenpsZTtcbn07XG5cbi8qIGpzaGludCBpZ25vcmU6ZW5kICovXG5cbi8qKlxuICogQ29weXJpZ2h0IDIwMTYgQWRndWFyZCBTb2Z0d2FyZSBMdGRcbiAqXG4gKiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2Vuc2UsIFZlcnNpb24gMi4wICh0aGUgXCJMaWNlbnNlXCIpO1xuICogeW91IG1heSBub3QgdXNlIHRoaXMgZmlsZSBleGNlcHQgaW4gY29tcGxpYW5jZSB3aXRoIHRoZSBMaWNlbnNlLlxuICogWW91IG1heSBvYnRhaW4gYSBjb3B5IG9mIHRoZSBMaWNlbnNlIGF0XG4gKlxuICogaHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wXG4gKlxuICogVW5sZXNzIHJlcXVpcmVkIGJ5IGFwcGxpY2FibGUgbGF3IG9yIGFncmVlZCB0byBpbiB3cml0aW5nLCBzb2Z0d2FyZVxuICogZGlzdHJpYnV0ZWQgdW5kZXIgdGhlIExpY2Vuc2UgaXMgZGlzdHJpYnV0ZWQgb24gYW4gXCJBUyBJU1wiIEJBU0lTLFxuICogV0lUSE9VVCBXQVJSQU5USUVTIE9SIENPTkRJVElPTlMgT0YgQU5ZIEtJTkQsIGVpdGhlciBleHByZXNzIG9yIGltcGxpZWQuXG4gKiBTZWUgdGhlIExpY2Vuc2UgZm9yIHRoZSBzcGVjaWZpYyBsYW5ndWFnZSBnb3Zlcm5pbmcgcGVybWlzc2lvbnMgYW5kXG4gKiBsaW1pdGF0aW9ucyB1bmRlciB0aGUgTGljZW5zZS5cbiAqL1xuLyoqXG4gKiBDbGFzcyB0aGF0IGV4dGVuZHMgU2l6emxlIGFuZCBhZGRzIHN1cHBvcnQgZm9yIFwibWF0Y2hlcy1jc3NcIiBwc2V1ZG8gZWxlbWVudC5cbiAqL1xuXG52YXIgU3R5bGVQcm9wZXJ0eU1hdGNoZXIgPSBmdW5jdGlvbiAod2luZG93KSB7XG4gIHZhciBpc1BoYW50b20gPSAhIXdpbmRvdy5fcGhhbnRvbTtcbiAgdmFyIHVzZUZhbGxiYWNrID0gaXNQaGFudG9tICYmICEhd2luZG93LmdldE1hdGNoZWRDU1NSdWxlcztcbiAgLyoqXG4gICAqIFVucXVvdGVzIHNwZWNpZmllZCB2YWx1ZVxuICAgKiBXZWJraXQtYmFzZWQgYnJvd3NlcnMgc2luZ2xlcXVvdGVzIDxzdHJpbmc+IGNvbnRlbnQgcHJvcGVydHkgdmFsdWVzXG4gICAqIE90aGVyIGJyb3dzZXJzIGRvdWJsZXF1b3RlcyBjb250ZW50IHByb3BlcnR5IHZhbHVlcy5cbiAgICovXG5cbiAgdmFyIHJlbW92ZUNvbnRlbnRRdW90ZXMgPSBmdW5jdGlvbiByZW1vdmVDb250ZW50UXVvdGVzKHZhbHVlKSB7XG4gICAgaWYgKHR5cGVvZiB2YWx1ZSA9PT0gJ3N0cmluZycpIHtcbiAgICAgIHJldHVybiB2YWx1ZS5yZXBsYWNlKC9eKFtcIiddKShbXFxzXFxTXSopXFwxJC8sICckMicpO1xuICAgIH1cblxuICAgIHJldHVybiB2YWx1ZTtcbiAgfTtcblxuICB2YXIgZ2V0Q29tcHV0ZWRTdHlsZSA9IHdpbmRvdy5nZXRDb21wdXRlZFN0eWxlLmJpbmQod2luZG93KTtcbiAgdmFyIGdldE1hdGNoZWRDU1NSdWxlcyA9IHVzZUZhbGxiYWNrID8gd2luZG93LmdldE1hdGNoZWRDU1NSdWxlcy5iaW5kKHdpbmRvdykgOiBudWxsO1xuICAvKipcbiAgICogVGhlcmUgaXMgYW4gaXNzdWUgaW4gYnJvd3NlcnMgYmFzZWQgb24gb2xkIHdlYmtpdDpcbiAgICogZ2V0Q29tcHV0ZWRTdHlsZShlbCwgXCI6YmVmb3JlXCIpIGlzIGVtcHR5IGlmIGVsZW1lbnQgaXMgbm90IHZpc2libGUuXG4gICAqXG4gICAqIFRvIGNpcmN1bXZlbnQgdGhpcyBpc3N1ZSB3ZSB1c2UgZ2V0TWF0Y2hlZENTU1J1bGVzIGluc3RlYWQuXG4gICAqXG4gICAqIEl0IGFwcGVhcnMgdGhhdCBnZXRNYXRjaGVkQ1NTUnVsZXMgc29ydHMgdGhlIENTUyBydWxlc1xuICAgKiBpbiBpbmNyZWFzaW5nIG9yZGVyIG9mIHNwZWNpZml0aWVzIG9mIGNvcnJlc3BvbmRpbmcgc2VsZWN0b3JzLlxuICAgKiBXZSBwaWNrIHRoZSBjc3MgcnVsZSB0aGF0IGlzIGJlaW5nIGFwcGxpZWQgdG8gYW4gZWxlbWVudCBiYXNlZCBvbiB0aGlzIGFzc3VtcHRpb24uXG4gICAqXG4gICAqIEBwYXJhbSBlbGVtZW50ICAgICAgIERPTSBub2RlXG4gICAqIEBwYXJhbSBwc2V1ZG9FbGVtZW50IE9wdGlvbmFsIHBzZXVkb0VsZW1lbnQgbmFtZVxuICAgKiBAcGFyYW0gcHJvcGVydHlOYW1lICBDU1MgcHJvcGVydHkgbmFtZVxuICAgKi9cblxuICB2YXIgZ2V0Q29tcHV0ZWRTdHlsZVByb3BlcnR5VmFsdWUgPSBmdW5jdGlvbiBnZXRDb21wdXRlZFN0eWxlUHJvcGVydHlWYWx1ZShlbGVtZW50LCBwc2V1ZG9FbGVtZW50LCBwcm9wZXJ0eU5hbWUpIHtcbiAgICB2YXIgdmFsdWUgPSAnJztcblxuICAgIGlmICh1c2VGYWxsYmFjayAmJiBwc2V1ZG9FbGVtZW50KSB7XG4gICAgICB2YXIgY3NzUnVsZXMgPSBnZXRNYXRjaGVkQ1NTUnVsZXMoZWxlbWVudCwgcHNldWRvRWxlbWVudCkgfHwgW107XG4gICAgICB2YXIgaSA9IGNzc1J1bGVzLmxlbmd0aDtcblxuICAgICAgd2hpbGUgKGktLSA+IDAgJiYgIXZhbHVlKSB7XG4gICAgICAgIHZhbHVlID0gY3NzUnVsZXNbaV0uc3R5bGUuZ2V0UHJvcGVydHlWYWx1ZShwcm9wZXJ0eU5hbWUpO1xuICAgICAgfVxuICAgIH0gZWxzZSB7XG4gICAgICB2YXIgc3R5bGUgPSBnZXRDb21wdXRlZFN0eWxlKGVsZW1lbnQsIHBzZXVkb0VsZW1lbnQpO1xuXG4gICAgICBpZiAoc3R5bGUpIHtcbiAgICAgICAgdmFsdWUgPSBzdHlsZS5nZXRQcm9wZXJ0eVZhbHVlKHByb3BlcnR5TmFtZSk7IC8vIGh0dHBzOi8vYnVncy53ZWJraXQub3JnL3Nob3dfYnVnLmNnaT9pZD05MzQ0NVxuXG4gICAgICAgIGlmIChwcm9wZXJ0eU5hbWUgPT09ICdvcGFjaXR5JyAmJiB1dGlscy5pc1NhZmFyaUJyb3dzZXIpIHtcbiAgICAgICAgICB2YWx1ZSA9IChNYXRoLnJvdW5kKHBhcnNlRmxvYXQodmFsdWUpICogMTAwKSAvIDEwMCkudG9TdHJpbmcoKTtcbiAgICAgICAgfVxuICAgICAgfVxuICAgIH1cblxuICAgIGlmIChwcm9wZXJ0eU5hbWUgPT09ICdjb250ZW50Jykge1xuICAgICAgdmFsdWUgPSByZW1vdmVDb250ZW50UXVvdGVzKHZhbHVlKTtcbiAgICB9XG5cbiAgICByZXR1cm4gdmFsdWU7XG4gIH07XG4gIC8qKlxuICAgKiBBZGRzIHVybCBwYXJhbWV0ZXIgcXVvdGVzIGZvciBub24tcmVnZXggcGF0dGVyblxuICAgKiBAcGFyYW0ge3N0cmluZ30gcGF0dGVyblxuICAgKi9cblxuXG4gIHZhciBhZGRVcmxRdW90ZXMgPSBmdW5jdGlvbiBhZGRVcmxRdW90ZXMocGF0dGVybikge1xuICAgIC8vIGZvciByZWdleCBwYXR0ZXJuc1xuICAgIGlmIChwYXR0ZXJuWzBdID09PSAnLycgJiYgcGF0dGVybltwYXR0ZXJuLmxlbmd0aCAtIDFdID09PSAnLycgJiYgcGF0dGVybi5pbmRleE9mKCdcXFxcXCInKSA8IDEwKSB7XG4gICAgICAvLyBlLmcuIC9edXJsXFxcXChbYS16XXs0fTpbYS16XXs1fS9cbiAgICAgIC8vIG9yIC9edXJsXFxcXChkYXRhXFxcXDpcXFxcaW1hZ2VcXFxcL2dpZjtiYXNlNjQuKy9cbiAgICAgIHZhciByZSA9IC8oXFxeKT91cmwoXFxcXCk/XFxcXFxcKChcXHd8XFxbXFx3KS9nO1xuICAgICAgcmV0dXJuIHBhdHRlcm4ucmVwbGFjZShyZSwgJyQxdXJsJDJcXFxcXFwoXFxcXFwiPyQzJyk7XG4gICAgfSAvLyBmb3Igbm9uLXJlZ2V4IHBhdHRlcm5zXG5cblxuICAgIGlmIChwYXR0ZXJuLmluZGV4T2YoJ3VybChcIicpID09PSAtMSkge1xuICAgICAgdmFyIF9yZSA9IC91cmxcXCgoLio/KVxcKS9nO1xuICAgICAgcmV0dXJuIHBhdHRlcm4ucmVwbGFjZShfcmUsICd1cmwoXCIkMVwiKScpO1xuICAgIH1cblxuICAgIHJldHVybiBwYXR0ZXJuO1xuICB9O1xuICAvKipcbiAgICogQ2xhc3MgdGhhdCBtYXRjaGVzIGVsZW1lbnQgc3R5bGUgYWdhaW5zdCB0aGUgc3BlY2lmaWVkIGV4cHJlc3Npb25cbiAgICogQG1lbWJlciB7c3RyaW5nfSBwcm9wZXJ0eU5hbWVcbiAgICogQG1lbWJlciB7c3RyaW5nfSBwc2V1ZG9FbGVtZW50XG4gICAqIEBtZW1iZXIge1JlZ0V4cH0gcmVnZXhcbiAgICovXG5cblxuICB2YXIgTWF0Y2hlciA9IGZ1bmN0aW9uIE1hdGNoZXIocHJvcGVydHlGaWx0ZXIsIHBzZXVkb0VsZW1lbnQpIHtcbiAgICB0aGlzLnBzZXVkb0VsZW1lbnQgPSBwc2V1ZG9FbGVtZW50O1xuXG4gICAgdHJ5IHtcbiAgICAgIHZhciBpbmRleCA9IHByb3BlcnR5RmlsdGVyLmluZGV4T2YoJzonKTtcbiAgICAgIHRoaXMucHJvcGVydHlOYW1lID0gcHJvcGVydHlGaWx0ZXIuc3Vic3RyaW5nKDAsIGluZGV4KS50cmltKCk7XG4gICAgICB2YXIgcGF0dGVybiA9IHByb3BlcnR5RmlsdGVyLnN1YnN0cmluZyhpbmRleCArIDEpLnRyaW0oKTtcbiAgICAgIHBhdHRlcm4gPSBhZGRVcmxRdW90ZXMocGF0dGVybik7IC8vIFVuZXNjYXBpbmcgcGF0dGVyblxuICAgICAgLy8gRm9yIG5vbi1yZWdleCBwYXR0ZXJucywgKCwpLFssXSBzaG91bGQgYmUgdW5lc2NhcGVkLCBiZWNhdXNlIHdlIHJlcXVpcmUgZXNjYXBpbmcgdGhlbSBpbiBmaWx0ZXIgcnVsZXMuXG4gICAgICAvLyBGb3IgcmVnZXggcGF0dGVybnMsIFwiLFxcIHNob3VsZCBiZSBlc2NhcGVkLCBiZWNhdXNlIHdlIG1hbnVhbGx5IGVzY2FwZSB0aG9zZSBpbiBleHRlbmRlZC1jc3Mtc2VsZWN0b3IuanMuXG5cbiAgICAgIGlmICgvXlxcLy4qXFwvJC8udGVzdChwYXR0ZXJuKSkge1xuICAgICAgICBwYXR0ZXJuID0gcGF0dGVybi5zbGljZSgxLCAtMSk7XG4gICAgICAgIHRoaXMucmVnZXggPSB1dGlscy5wc2V1ZG9BcmdUb1JlZ2V4KHBhdHRlcm4pO1xuICAgICAgfSBlbHNlIHtcbiAgICAgICAgcGF0dGVybiA9IHBhdHRlcm4ucmVwbGFjZSgvXFxcXChbXFxcXCgpW1xcXVwiXSkvZywgJyQxJyk7XG4gICAgICAgIHRoaXMucmVnZXggPSB1dGlscy5jcmVhdGVVUkxSZWdleChwYXR0ZXJuKTtcbiAgICAgIH1cbiAgICB9IGNhdGNoIChleCkge1xuICAgICAgdXRpbHMubG9nRXJyb3IoXCJTdHlsZVByb3BlcnR5TWF0Y2hlcjogaW52YWxpZCBtYXRjaCBzdHJpbmcgXCIuY29uY2F0KHByb3BlcnR5RmlsdGVyKSk7XG4gICAgfVxuICB9O1xuICAvKipcbiAgICogRnVuY3Rpb24gdG8gY2hlY2sgaWYgZWxlbWVudCBDU1MgcHJvcGVydHkgbWF0Y2hlcyBmaWx0ZXIgcGF0dGVyblxuICAgKiBAcGFyYW0ge0VsZW1lbnR9IGVsZW1lbnQgdG8gY2hlY2tcbiAgICovXG5cblxuICBNYXRjaGVyLnByb3RvdHlwZS5tYXRjaGVzID0gZnVuY3Rpb24gKGVsZW1lbnQpIHtcbiAgICBpZiAoIXRoaXMucmVnZXggfHwgIXRoaXMucHJvcGVydHlOYW1lKSB7XG4gICAgICByZXR1cm4gZmFsc2U7XG4gICAgfVxuXG4gICAgdmFyIHZhbHVlID0gZ2V0Q29tcHV0ZWRTdHlsZVByb3BlcnR5VmFsdWUoZWxlbWVudCwgdGhpcy5wc2V1ZG9FbGVtZW50LCB0aGlzLnByb3BlcnR5TmFtZSk7XG4gICAgcmV0dXJuIHZhbHVlICYmIHRoaXMucmVnZXgudGVzdCh2YWx1ZSk7XG4gIH07XG4gIC8qKlxuICAgKiBDcmVhdGVzIGEgbmV3IHBzZXVkby1jbGFzcyBhbmQgcmVnaXN0ZXJzIGl0IGluIFNpenpsZVxuICAgKi9cblxuXG4gIHZhciBleHRlbmRTaXp6bGUgPSBmdW5jdGlvbiBleHRlbmRTaXp6bGUoc2l6emxlKSB7XG4gICAgLy8gRmlyc3Qgb2YgYWxsIHdlIHNob3VsZCBwcmVwYXJlIFNpenpsZSBlbmdpbmVcbiAgICBzaXp6bGUuc2VsZWN0b3JzLnBzZXVkb3NbJ21hdGNoZXMtY3NzJ10gPSBzaXp6bGUuc2VsZWN0b3JzLmNyZWF0ZVBzZXVkbyhmdW5jdGlvbiAocHJvcGVydHlGaWx0ZXIpIHtcbiAgICAgIHZhciBtYXRjaGVyID0gbmV3IE1hdGNoZXIocHJvcGVydHlGaWx0ZXIpO1xuICAgICAgcmV0dXJuIGZ1bmN0aW9uIChlbGVtZW50KSB7XG4gICAgICAgIHJldHVybiBtYXRjaGVyLm1hdGNoZXMoZWxlbWVudCk7XG4gICAgICB9O1xuICAgIH0pO1xuICAgIHNpenpsZS5zZWxlY3RvcnMucHNldWRvc1snbWF0Y2hlcy1jc3MtYmVmb3JlJ10gPSBzaXp6bGUuc2VsZWN0b3JzLmNyZWF0ZVBzZXVkbyhmdW5jdGlvbiAocHJvcGVydHlGaWx0ZXIpIHtcbiAgICAgIHZhciBtYXRjaGVyID0gbmV3IE1hdGNoZXIocHJvcGVydHlGaWx0ZXIsICc6YmVmb3JlJyk7XG4gICAgICByZXR1cm4gZnVuY3Rpb24gKGVsZW1lbnQpIHtcbiAgICAgICAgcmV0dXJuIG1hdGNoZXIubWF0Y2hlcyhlbGVtZW50KTtcbiAgICAgIH07XG4gICAgfSk7XG4gICAgc2l6emxlLnNlbGVjdG9ycy5wc2V1ZG9zWydtYXRjaGVzLWNzcy1hZnRlciddID0gc2l6emxlLnNlbGVjdG9ycy5jcmVhdGVQc2V1ZG8oZnVuY3Rpb24gKHByb3BlcnR5RmlsdGVyKSB7XG4gICAgICB2YXIgbWF0Y2hlciA9IG5ldyBNYXRjaGVyKHByb3BlcnR5RmlsdGVyLCAnOmFmdGVyJyk7XG4gICAgICByZXR1cm4gZnVuY3Rpb24gKGVsZW1lbnQpIHtcbiAgICAgICAgcmV0dXJuIG1hdGNoZXIubWF0Y2hlcyhlbGVtZW50KTtcbiAgICAgIH07XG4gICAgfSk7XG4gIH07IC8vIEVYUE9TRVxuXG5cbiAgcmV0dXJuIHtcbiAgICBleHRlbmRTaXp6bGU6IGV4dGVuZFNpenpsZVxuICB9O1xufSh3aW5kb3cpO1xuXG4vKipcbiAqIENvcHlyaWdodCAyMDE2IEFkZ3VhcmQgU29mdHdhcmUgTHRkXG4gKlxuICogTGljZW5zZWQgdW5kZXIgdGhlIEFwYWNoZSBMaWNlbnNlLCBWZXJzaW9uIDIuMCAodGhlIFwiTGljZW5zZVwiKTtcbiAqIHlvdSBtYXkgbm90IHVzZSB0aGlzIGZpbGUgZXhjZXB0IGluIGNvbXBsaWFuY2Ugd2l0aCB0aGUgTGljZW5zZS5cbiAqIFlvdSBtYXkgb2J0YWluIGEgY29weSBvZiB0aGUgTGljZW5zZSBhdFxuICpcbiAqIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMFxuICpcbiAqIFVubGVzcyByZXF1aXJlZCBieSBhcHBsaWNhYmxlIGxhdyBvciBhZ3JlZWQgdG8gaW4gd3JpdGluZywgc29mdHdhcmVcbiAqIGRpc3RyaWJ1dGVkIHVuZGVyIHRoZSBMaWNlbnNlIGlzIGRpc3RyaWJ1dGVkIG9uIGFuIFwiQVMgSVNcIiBCQVNJUyxcbiAqIFdJVEhPVVQgV0FSUkFOVElFUyBPUiBDT05ESVRJT05TIE9GIEFOWSBLSU5ELCBlaXRoZXIgZXhwcmVzcyBvciBpbXBsaWVkLlxuICogU2VlIHRoZSBMaWNlbnNlIGZvciB0aGUgc3BlY2lmaWMgbGFuZ3VhZ2UgZ292ZXJuaW5nIHBlcm1pc3Npb25zIGFuZFxuICogbGltaXRhdGlvbnMgdW5kZXIgdGhlIExpY2Vuc2UuXG4gKi9cbnZhciBtYXRjaGVyVXRpbHMgPSB7fTtcbm1hdGNoZXJVdGlscy5NdXRhdGlvbk9ic2VydmVyID0gd2luZG93Lk11dGF0aW9uT2JzZXJ2ZXIgfHwgd2luZG93LldlYktpdE11dGF0aW9uT2JzZXJ2ZXI7XG4vKipcbiAqIFBhcnNlcyBhcmd1bWVudCBvZiBtYXRjaGVyIHBzZXVkbyAoZm9yIG1hdGNoZXMtYXR0ciBhbmQgbWF0Y2hlcy1wcm9wZXJ0eSlcbiAqIEBwYXJhbSB7c3RyaW5nfSBtYXRjaGVyRmlsdGVyIGFyZ3VtZW50IG9mIHBzZXVkbyBjbGFzc1xuICogQHJldHVybnMge0FycmF5fVxuICovXG5cbm1hdGNoZXJVdGlscy5wYXJzZU1hdGNoZXJGaWx0ZXIgPSBmdW5jdGlvbiAobWF0Y2hlckZpbHRlcikge1xuICB2YXIgRlVMTF9NQVRDSF9NQVJLRVIgPSAnXCI9XCInO1xuICB2YXIgcmF3QXJncyA9IFtdO1xuXG4gIGlmIChtYXRjaGVyRmlsdGVyLmluZGV4T2YoRlVMTF9NQVRDSF9NQVJLRVIpID09PSAtMSkge1xuICAgIC8vIGlmIHRoZXJlIGlzIG9ubHkgb25lIHBzZXVkbyBhcmdcbiAgICAvLyBlLmcuIDptYXRjaGVzLWF0dHIoXCJkYXRhLW5hbWVcIikgb3IgOm1hdGNoZXMtcHJvcGVydHkoXCJpbm5lci5wcm9wXCIpXG4gICAgLy8gU2l6emxlIHdpbGwgcGFyc2UgaXQgYW5kIGdldCByaWQgb2YgcXVvdGVzXG4gICAgLy8gc28gaXQgbWlnaHQgYmUgdmFsaWQgYXJnIGFscmVhZHkgd2l0aG91dCB0aGVtXG4gICAgcmF3QXJncy5wdXNoKG1hdGNoZXJGaWx0ZXIpO1xuICB9IGVsc2Uge1xuICAgIG1hdGNoZXJGaWx0ZXIuc3BsaXQoJz0nKS5mb3JFYWNoKGZ1bmN0aW9uIChhcmcpIHtcbiAgICAgIGlmIChhcmdbMF0gPT09ICdcIicgJiYgYXJnW2FyZy5sZW5ndGggLSAxXSA9PT0gJ1wiJykge1xuICAgICAgICByYXdBcmdzLnB1c2goYXJnLnNsaWNlKDEsIC0xKSk7XG4gICAgICB9XG4gICAgfSk7XG4gIH1cblxuICByZXR1cm4gcmF3QXJncztcbn07XG4vKipcbiAqIEB0eXBlZGVmIHtPYmplY3R9IEFyZ0RhdGFcbiAqIEBwcm9wZXJ0eSB7c3RyaW5nfSBhcmdcbiAqIEBwcm9wZXJ0eSB7Ym9vbGVhbn0gaXNSZWdleHBcbiAqL1xuXG4vKipcbiAqIFBhcnNlcyByYXcgbWF0Y2hlciBhcmdcbiAqIEBwYXJhbSB7c3RyaW5nfSByYXdBcmdcbiAqIEByZXR1cm5zIHtBcmdEYXRhfVxuICovXG5cblxubWF0Y2hlclV0aWxzLnBhcnNlUmF3TWF0Y2hlckFyZyA9IGZ1bmN0aW9uIChyYXdBcmcpIHtcbiAgdmFyIGFyZyA9IHJhd0FyZztcbiAgdmFyIGlzUmVnZXhwID0gISFyYXdBcmcgJiYgcmF3QXJnWzBdID09PSAnLycgJiYgcmF3QXJnW3Jhd0FyZy5sZW5ndGggLSAxXSA9PT0gJy8nO1xuXG4gIGlmIChpc1JlZ2V4cCkge1xuICAgIC8vIHRvIGF2b2lkIGF0IGxlYXN0IHN1Y2ggY2FzZSDigJQgOm1hdGNoZXMtcHJvcGVydHkoXCIvL1wiKVxuICAgIGlmIChyYXdBcmcubGVuZ3RoID4gMikge1xuICAgICAgYXJnID0gdXRpbHMudG9SZWdFeHAocmF3QXJnKTtcbiAgICB9IGVsc2Uge1xuICAgICAgdGhyb3cgbmV3IEVycm9yKFwiSW52YWxpZCByZWdleHA6IFwiLmNvbmNhdChyYXdBcmcpKTtcbiAgICB9XG4gIH1cblxuICByZXR1cm4ge1xuICAgIGFyZzogYXJnLFxuICAgIGlzUmVnZXhwOiBpc1JlZ2V4cFxuICB9O1xufTtcbi8qKlxuICogQHR5cGVkZWYgQ2hhaW5cbiAqIEBwcm9wZXJ0eSB7T2JqZWN0fSBiYXNlXG4gKiBAcHJvcGVydHkge3N0cmluZ30gcHJvcFxuICogQHByb3BlcnR5IHtzdHJpbmd9IHZhbHVlXG4gKi9cblxuLyoqXG4gKiBDaGVja3MgaWYgdGhlIHByb3BlcnR5IGV4aXN0cyBpbiB0aGUgYmFzZSBvYmplY3QgKHJlY3Vyc2l2ZWx5KS5cbiAqIEBwYXJhbSB7T2JqZWN0fSBiYXNlXG4gKiBAcGFyYW0ge0FyZ0RhdGFbXX0gY2hhaW4gYXJyYXkgb2Ygb2JqZWN0cyAtIHBhcnNlZCBzdHJpbmcgcHJvcGVydHkgY2hhaW5cbiAqIEBwYXJhbSB7QXJyYXl9IFtvdXRwdXQ9W11dIHJlc3VsdCBhY2NcbiAqIEByZXR1cm5zIHtDaGFpbltdfSBhcnJheSBvZiBvYmplY3RzXG4gKi9cblxuXG5tYXRjaGVyVXRpbHMuZmlsdGVyUm9vdHNCeVJlZ2V4cENoYWluID0gZnVuY3Rpb24gKGJhc2UsIGNoYWluKSB7XG4gIHZhciBvdXRwdXQgPSBhcmd1bWVudHMubGVuZ3RoID4gMiAmJiBhcmd1bWVudHNbMl0gIT09IHVuZGVmaW5lZCA/IGFyZ3VtZW50c1syXSA6IFtdO1xuICB2YXIgdGVtcFByb3AgPSBjaGFpblswXTtcblxuICBpZiAoY2hhaW4ubGVuZ3RoID09PSAxKSB7XG4gICAgLy8gZXNsaW50LWRpc2FibGUtbmV4dC1saW5lIG5vLXJlc3RyaWN0ZWQtc3ludGF4XG4gICAgZm9yICh2YXIga2V5IGluIGJhc2UpIHtcbiAgICAgIGlmICh0ZW1wUHJvcC5pc1JlZ2V4cCkge1xuICAgICAgICBpZiAodGVtcFByb3AuYXJnLnRlc3Qoa2V5KSkge1xuICAgICAgICAgIG91dHB1dC5wdXNoKHtcbiAgICAgICAgICAgIGJhc2U6IGJhc2UsXG4gICAgICAgICAgICBwcm9wOiBrZXksXG4gICAgICAgICAgICB2YWx1ZTogYmFzZVtrZXldXG4gICAgICAgICAgfSk7XG4gICAgICAgIH1cbiAgICAgIH0gZWxzZSBpZiAodGVtcFByb3AuYXJnID09PSBrZXkpIHtcbiAgICAgICAgb3V0cHV0LnB1c2goe1xuICAgICAgICAgIGJhc2U6IGJhc2UsXG4gICAgICAgICAgcHJvcDogdGVtcFByb3AuYXJnLFxuICAgICAgICAgIHZhbHVlOiBiYXNlW2tleV1cbiAgICAgICAgfSk7XG4gICAgICB9XG4gICAgfVxuXG4gICAgcmV0dXJuIG91dHB1dDtcbiAgfSAvLyBpZiB0aGVyZSBpcyBhIHJlZ2V4cCBwcm9wIGluIGlucHV0IGNoYWluXG4gIC8vIGUuZy4gJ3VuaXQuL15hZC4rLy5zcmMnIGZvciAndW5pdC5hZC0xZ2YyLnNyYyB1bml0LmFkLWZnZDM0LnNyYycpLFxuICAvLyBldmVyeSBiYXNlIGtleXMgc2hvdWxkIGJlIHRlc3RlZCBieSByZWdleHAgYW5kIGl0IGNhbiBiZSBtb3JlIHRoYXQgb25lIHJlc3VsdHNcblxuXG4gIGlmICh0ZW1wUHJvcC5pc1JlZ2V4cCkge1xuICAgIHZhciBuZXh0UHJvcCA9IGNoYWluLnNsaWNlKDEpO1xuICAgIHZhciBiYXNlS2V5cyA9IFtdOyAvLyBlc2xpbnQtZGlzYWJsZS1uZXh0LWxpbmUgbm8tcmVzdHJpY3RlZC1zeW50YXhcblxuICAgIGZvciAodmFyIF9rZXkgaW4gYmFzZSkge1xuICAgICAgaWYgKHRlbXBQcm9wLmFyZy50ZXN0KF9rZXkpKSB7XG4gICAgICAgIGJhc2VLZXlzLnB1c2goX2tleSk7XG4gICAgICB9XG4gICAgfVxuXG4gICAgYmFzZUtleXMuZm9yRWFjaChmdW5jdGlvbiAoa2V5KSB7XG4gICAgICB2YXIgaXRlbSA9IGJhc2Vba2V5XTtcbiAgICAgIG1hdGNoZXJVdGlscy5maWx0ZXJSb290c0J5UmVnZXhwQ2hhaW4oaXRlbSwgbmV4dFByb3AsIG91dHB1dCk7XG4gICAgfSk7XG4gIH0gLy8gYXZvaWQgVHlwZUVycm9yIHdoaWxlIGFjY2Vzc2luZyB0byBudWxsLXByb3AncyBjaGlsZFxuXG5cbiAgaWYgKGJhc2UgPT09IG51bGwpIHtcbiAgICByZXR1cm47XG4gIH1cblxuICB2YXIgbmV4dEJhc2UgPSBiYXNlW3RlbXBQcm9wLmFyZ107XG4gIGNoYWluID0gY2hhaW4uc2xpY2UoMSk7XG5cbiAgaWYgKG5leHRCYXNlICE9PSB1bmRlZmluZWQpIHtcbiAgICBtYXRjaGVyVXRpbHMuZmlsdGVyUm9vdHNCeVJlZ2V4cENoYWluKG5leHRCYXNlLCBjaGFpbiwgb3V0cHV0KTtcbiAgfVxuXG4gIHJldHVybiBvdXRwdXQ7XG59O1xuLyoqXG4gKiBWYWxpZGF0ZXMgcGFyc2VkIGFyZ3Mgb2YgbWF0Y2hlcy1wcm9wZXJ0eSBwc2V1ZG9cbiAqIEBwYXJhbSB7Li4uQXJnRGF0YX0gYXJnc1xuICovXG5cblxubWF0Y2hlclV0aWxzLnZhbGlkYXRlUHJvcE1hdGNoZXJBcmdzID0gZnVuY3Rpb24gKCkge1xuICBmb3IgKHZhciBfbGVuID0gYXJndW1lbnRzLmxlbmd0aCwgYXJncyA9IG5ldyBBcnJheShfbGVuKSwgX2tleTIgPSAwOyBfa2V5MiA8IF9sZW47IF9rZXkyKyspIHtcbiAgICBhcmdzW19rZXkyXSA9IGFyZ3VtZW50c1tfa2V5Ml07XG4gIH1cblxuICBmb3IgKHZhciBpID0gMDsgaSA8IGFyZ3MubGVuZ3RoOyBpICs9IDEpIHtcbiAgICBpZiAoYXJnc1tpXS5pc1JlZ2V4cCkge1xuICAgICAgaWYgKCF1dGlscy5zdGFydHNXaXRoKGFyZ3NbaV0uYXJnLnRvU3RyaW5nKCksICcvJykgfHwgIXV0aWxzLmVuZHNXaXRoKGFyZ3NbaV0uYXJnLnRvU3RyaW5nKCksICcvJykpIHtcbiAgICAgICAgcmV0dXJuIGZhbHNlO1xuICAgICAgfSAvLyBzaW1wbGUgYXJnIGNoZWNrIGlmIGl0IGlzIG5vdCBhIHJlZ2V4cFxuXG4gICAgfSBlbHNlIGlmICghL15bXFx3LV0rJC8udGVzdChhcmdzW2ldLmFyZykpIHtcbiAgICAgIHJldHVybiBmYWxzZTtcbiAgICB9XG4gIH1cblxuICByZXR1cm4gdHJ1ZTtcbn07XG5cbi8qKlxuICogQ2xhc3MgdGhhdCBleHRlbmRzIFNpenpsZSBhbmQgYWRkcyBzdXBwb3J0IGZvciBcIm1hdGNoZXMtYXR0clwiIHBzZXVkbyBlbGVtZW50LlxuICovXG5cbnZhciBBdHRyaWJ1dGVzTWF0Y2hlciA9IGZ1bmN0aW9uICgpIHtcbiAgLyoqXG4gICAqIENsYXNzIHRoYXQgbWF0Y2hlcyBlbGVtZW50IGF0dHJpYnV0ZXMgYWdhaW5zdCB0aGUgc3BlY2lmaWVkIGV4cHJlc3Npb25zXG4gICAqIEBwYXJhbSB7QXJnRGF0YX0gbmFtZUFyZyAtIHBhcnNlZCBuYW1lIGFyZ3VtZW50XG4gICAqIEBwYXJhbSB7QXJnRGF0YX0gdmFsdWVBcmcgLSBwYXJzZWQgdmFsdWUgYXJndW1lbnRcbiAgICogQHBhcmFtIHtzdHJpbmd9IHBzZXVkb0VsZW1lbnRcbiAgICogQGNvbnN0cnVjdG9yXG4gICAqXG4gICAqIEBtZW1iZXIge3N0cmluZ3xSZWdFeHB9IGF0dHJOYW1lXG4gICAqIEBtZW1iZXIge2Jvb2xlYW59IGlzUmVnZXhwTmFtZVxuICAgKiBAbWVtYmVyIHtzdHJpbmd8UmVnRXhwfSBhdHRyVmFsdWVcbiAgICogQG1lbWJlciB7Ym9vbGVhbn0gaXNSZWdleHBWYWx1ZVxuICAgKi9cbiAgdmFyIEF0dHJNYXRjaGVyID0gZnVuY3Rpb24gQXR0ck1hdGNoZXIobmFtZUFyZywgdmFsdWVBcmcsIHBzZXVkb0VsZW1lbnQpIHtcbiAgICB0aGlzLnBzZXVkb0VsZW1lbnQgPSBwc2V1ZG9FbGVtZW50O1xuICAgIHRoaXMuYXR0ck5hbWUgPSBuYW1lQXJnLmFyZztcbiAgICB0aGlzLmlzUmVnZXhwTmFtZSA9IG5hbWVBcmcuaXNSZWdleHA7XG4gICAgdGhpcy5hdHRyVmFsdWUgPSB2YWx1ZUFyZy5hcmc7XG4gICAgdGhpcy5pc1JlZ2V4cFZhbHVlID0gdmFsdWVBcmcuaXNSZWdleHA7XG4gIH07XG4gIC8qKlxuICAgKiBGdW5jdGlvbiB0byBjaGVjayBpZiBlbGVtZW50IGF0dHJpYnV0ZXMgbWF0Y2hlcyBmaWx0ZXIgcGF0dGVyblxuICAgKiBAcGFyYW0ge0VsZW1lbnR9IGVsZW1lbnQgdG8gY2hlY2tcbiAgICovXG5cblxuICBBdHRyTWF0Y2hlci5wcm90b3R5cGUubWF0Y2hlcyA9IGZ1bmN0aW9uIChlbGVtZW50KSB7XG4gICAgdmFyIGVsQXR0cnMgPSBlbGVtZW50LmF0dHJpYnV0ZXM7XG5cbiAgICBpZiAoZWxBdHRycy5sZW5ndGggPT09IDAgfHwgIXRoaXMuYXR0ck5hbWUpIHtcbiAgICAgIHJldHVybiBmYWxzZTtcbiAgICB9XG5cbiAgICB2YXIgaSA9IDA7XG5cbiAgICB3aGlsZSAoaSA8IGVsQXR0cnMubGVuZ3RoKSB7XG4gICAgICB2YXIgYXR0ciA9IGVsQXR0cnNbaV07XG4gICAgICB2YXIgbWF0Y2hlZCA9IGZhbHNlO1xuICAgICAgdmFyIGF0dHJOYW1lTWF0Y2hlZCA9IHRoaXMuaXNSZWdleHBOYW1lID8gdGhpcy5hdHRyTmFtZS50ZXN0KGF0dHIubmFtZSkgOiB0aGlzLmF0dHJOYW1lID09PSBhdHRyLm5hbWU7XG5cbiAgICAgIGlmICghdGhpcy5hdHRyVmFsdWUpIHtcbiAgICAgICAgLy8gZm9yIDptYXRjaGVzLWF0dHIoXCIvcmVnZXgvXCIpIG9yIDptYXRjaGVzLWF0dHIoXCJhdHRyLW5hbWVcIilcbiAgICAgICAgbWF0Y2hlZCA9IGF0dHJOYW1lTWF0Y2hlZDtcbiAgICAgIH0gZWxzZSB7XG4gICAgICAgIHZhciBhdHRyVmFsdWVNYXRjaGVkID0gdGhpcy5pc1JlZ2V4cFZhbHVlID8gdGhpcy5hdHRyVmFsdWUudGVzdChhdHRyLnZhbHVlKSA6IHRoaXMuYXR0clZhbHVlID09PSBhdHRyLnZhbHVlO1xuICAgICAgICBtYXRjaGVkID0gYXR0ck5hbWVNYXRjaGVkICYmIGF0dHJWYWx1ZU1hdGNoZWQ7XG4gICAgICB9XG5cbiAgICAgIGlmIChtYXRjaGVkKSB7XG4gICAgICAgIHJldHVybiB0cnVlO1xuICAgICAgfVxuXG4gICAgICBpICs9IDE7XG4gICAgfVxuICB9O1xuICAvKipcbiAgICogQ3JlYXRlcyBhIG5ldyBwc2V1ZG8tY2xhc3MgYW5kIHJlZ2lzdGVycyBpdCBpbiBTaXp6bGVcbiAgICovXG5cblxuICB2YXIgZXh0ZW5kU2l6emxlID0gZnVuY3Rpb24gZXh0ZW5kU2l6emxlKHNpenpsZSkge1xuICAgIC8vIEZpcnN0IG9mIGFsbCB3ZSBzaG91bGQgcHJlcGFyZSBTaXp6bGUgZW5naW5lXG4gICAgc2l6emxlLnNlbGVjdG9ycy5wc2V1ZG9zWydtYXRjaGVzLWF0dHInXSA9IHNpenpsZS5zZWxlY3RvcnMuY3JlYXRlUHNldWRvKGZ1bmN0aW9uIChhdHRyRmlsdGVyKSB7XG4gICAgICB2YXIgX21hdGNoZXJVdGlscyRwYXJzZU1hID0gbWF0Y2hlclV0aWxzLnBhcnNlTWF0Y2hlckZpbHRlcihhdHRyRmlsdGVyKSxcbiAgICAgICAgICBfbWF0Y2hlclV0aWxzJHBhcnNlTWEyID0gX3NsaWNlZFRvQXJyYXkoX21hdGNoZXJVdGlscyRwYXJzZU1hLCAyKSxcbiAgICAgICAgICByYXdOYW1lID0gX21hdGNoZXJVdGlscyRwYXJzZU1hMlswXSxcbiAgICAgICAgICByYXdWYWx1ZSA9IF9tYXRjaGVyVXRpbHMkcGFyc2VNYTJbMV07XG5cbiAgICAgIHZhciBuYW1lQXJnID0gbWF0Y2hlclV0aWxzLnBhcnNlUmF3TWF0Y2hlckFyZyhyYXdOYW1lKTtcbiAgICAgIHZhciB2YWx1ZUFyZyA9IG1hdGNoZXJVdGlscy5wYXJzZVJhd01hdGNoZXJBcmcocmF3VmFsdWUpO1xuXG4gICAgICBpZiAoIWF0dHJGaWx0ZXIgfHwgIW1hdGNoZXJVdGlscy52YWxpZGF0ZVByb3BNYXRjaGVyQXJncyhuYW1lQXJnLCB2YWx1ZUFyZykpIHtcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiSW52YWxpZCBhcmd1bWVudCBvZiA6bWF0Y2hlcy1hdHRyIHBzZXVkbyBjbGFzczogXCIuY29uY2F0KGF0dHJGaWx0ZXIpKTtcbiAgICAgIH1cblxuICAgICAgdmFyIG1hdGNoZXIgPSBuZXcgQXR0ck1hdGNoZXIobmFtZUFyZywgdmFsdWVBcmcpO1xuICAgICAgcmV0dXJuIGZ1bmN0aW9uIChlbGVtZW50KSB7XG4gICAgICAgIHJldHVybiBtYXRjaGVyLm1hdGNoZXMoZWxlbWVudCk7XG4gICAgICB9O1xuICAgIH0pO1xuICB9OyAvLyBFWFBPU0VcblxuXG4gIHJldHVybiB7XG4gICAgZXh0ZW5kU2l6emxlOiBleHRlbmRTaXp6bGVcbiAgfTtcbn0oKTtcblxuLyoqXG4gKiBQYXJzZXMgcmF3IHByb3BlcnR5IGFyZ1xuICogQHBhcmFtIHtzdHJpbmd9IGlucHV0XG4gKiBAcmV0dXJucyB7QXJnRGF0YVtdfSBhcnJheSBvZiBvYmplY3RzXG4gKi9cblxudmFyIHBhcnNlUmF3UHJvcENoYWluID0gZnVuY3Rpb24gcGFyc2VSYXdQcm9wQ2hhaW4oaW5wdXQpIHtcbiAgdmFyIFBST1BTX0RJVklERVIgPSAnLic7XG4gIHZhciBSRUdFWFBfTUFSS0VSID0gJy8nO1xuICB2YXIgcHJvcHNBcnIgPSBbXTtcbiAgdmFyIHN0ciA9IGlucHV0O1xuXG4gIHdoaWxlIChzdHIubGVuZ3RoID4gMCkge1xuICAgIGlmICh1dGlscy5zdGFydHNXaXRoKHN0ciwgUFJPUFNfRElWSURFUikpIHtcbiAgICAgIC8vIGZvciBjYXNlcyBsaWtlICcucHJvcC5pZCcgYW5kICduZXN0ZWQuLnRlc3QnXG4gICAgICB0aHJvdyBuZXcgRXJyb3IoXCJJbnZhbGlkIGNoYWluIHByb3BlcnR5OiBcIi5jb25jYXQoaW5wdXQpKTtcbiAgICB9XG5cbiAgICBpZiAoIXV0aWxzLnN0YXJ0c1dpdGgoc3RyLCBSRUdFWFBfTUFSS0VSKSkge1xuICAgICAgdmFyIGlzUmVnZXhwID0gZmFsc2U7XG4gICAgICB2YXIgZGl2aWRlckluZGV4ID0gc3RyLmluZGV4T2YoUFJPUFNfRElWSURFUik7XG5cbiAgICAgIGlmIChzdHIuaW5kZXhPZihQUk9QU19ESVZJREVSKSA9PT0gLTEpIHtcbiAgICAgICAgLy8gaWYgdGhlcmUgaXMgbm8gJy4nIGxlZnQgaW4gc3RyXG4gICAgICAgIC8vIHRha2UgdGhlIHJlc3Qgb2Ygc3RyIGFzIHByb3BcbiAgICAgICAgcHJvcHNBcnIucHVzaCh7XG4gICAgICAgICAgYXJnOiBzdHIsXG4gICAgICAgICAgaXNSZWdleHA6IGlzUmVnZXhwXG4gICAgICAgIH0pO1xuICAgICAgICByZXR1cm4gcHJvcHNBcnI7XG4gICAgICB9IC8vIGVsc2UgdGFrZSBwcm9wIGZyb20gc3RyXG5cblxuICAgICAgdmFyIHByb3AgPSBzdHIuc2xpY2UoMCwgZGl2aWRlckluZGV4KTsgLy8gZm9yIGNhc2VzIGxpa2UgJ2FzYWRmLj8rLy50ZXN0J1xuXG4gICAgICBpZiAocHJvcC5pbmRleE9mKFJFR0VYUF9NQVJLRVIpID4gLTEpIHtcbiAgICAgICAgLy8gcHJvcCBpcyAnPysvJ1xuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJJbnZhbGlkIGNoYWluIHByb3BlcnR5OiBcIi5jb25jYXQocHJvcCkpO1xuICAgICAgfVxuXG4gICAgICBwcm9wc0Fyci5wdXNoKHtcbiAgICAgICAgYXJnOiBwcm9wLFxuICAgICAgICBpc1JlZ2V4cDogaXNSZWdleHBcbiAgICAgIH0pOyAvLyBkZWxldGUgcHJvcCBmcm9tIHN0clxuXG4gICAgICBzdHIgPSBzdHIuc2xpY2UoZGl2aWRlckluZGV4KTtcbiAgICB9IGVsc2Uge1xuICAgICAgLy8gZGVhbCB3aXRoIHJlZ2V4cFxuICAgICAgdmFyIHByb3BDaHVua3MgPSBbXTtcbiAgICAgIHByb3BDaHVua3MucHVzaChzdHIuc2xpY2UoMCwgMSkpOyAvLyBpZiBzdHIgc3RhcnRzIHdpdGggJy8nLCBkZWxldGUgaXQgZnJvbSBzdHIgYW5kIGZpbmQgY2xvc2luZyByZWdleHAgc2xhc2guXG4gICAgICAvLyBub3RlIHRoYXQgY2hhaW5lZCBwcm9wZXJ0eSBuYW1lIGNhbiBub3QgaW5jbHVkZSAnLycgb3IgJy4nXG4gICAgICAvLyBzbyB0aGVyZSBpcyBubyBjaGVja2luZyBmb3IgZXNjYXBlZCBjaGFyYWN0ZXJzXG5cbiAgICAgIHN0ciA9IHN0ci5zbGljZSgxKTtcbiAgICAgIHZhciByZWdleEVuZEluZGV4ID0gc3RyLmluZGV4T2YoUkVHRVhQX01BUktFUik7XG5cbiAgICAgIGlmIChyZWdleEVuZEluZGV4IDwgMSkge1xuICAgICAgICAvLyByZWdleHAgc2hvdWxkIGJlIGF0IGxlYXN0ID09PSAnLy4vJ1xuICAgICAgICAvLyBzbyB3ZSBzaG91bGQgYXZvaWQgYXJncyBsaWtlICcvaWQnIGFuZCAndGVzdC4vLy5pZCdcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiSW52YWxpZCByZWdleHA6IFwiLmNvbmNhdChSRUdFWFBfTUFSS0VSKS5jb25jYXQoc3RyKSk7XG4gICAgICB9XG5cbiAgICAgIHZhciBfaXNSZWdleHAgPSB0cnVlOyAvLyB0YWtlIHRoZSByZXN0IHJlZ2V4cCBwYXJ0XG5cbiAgICAgIHByb3BDaHVua3MucHVzaChzdHIuc2xpY2UoMCwgcmVnZXhFbmRJbmRleCArIDEpKTtcblxuICAgICAgdmFyIF9wcm9wID0gdXRpbHMudG9SZWdFeHAocHJvcENodW5rcy5qb2luKCcnKSk7XG5cbiAgICAgIHByb3BzQXJyLnB1c2goe1xuICAgICAgICBhcmc6IF9wcm9wLFxuICAgICAgICBpc1JlZ2V4cDogX2lzUmVnZXhwXG4gICAgICB9KTsgLy8gZGVsZXRlIHByb3AgZnJvbSBzdHJcblxuICAgICAgc3RyID0gc3RyLnNsaWNlKHJlZ2V4RW5kSW5kZXggKyAxKTtcbiAgICB9XG5cbiAgICBpZiAoIXN0cikge1xuICAgICAgcmV0dXJuIHByb3BzQXJyO1xuICAgIH0gLy8gc3RyIHNob3VsZCBiZSBsaWtlICcubmV4dFByb3AnIG5vd1xuICAgIC8vIHNvICd6eC5wcm9wJyBvciAnLicgaXMgaW52YWxpZFxuXG5cbiAgICBpZiAoIXV0aWxzLnN0YXJ0c1dpdGgoc3RyLCBQUk9QU19ESVZJREVSKSB8fCB1dGlscy5zdGFydHNXaXRoKHN0ciwgUFJPUFNfRElWSURFUikgJiYgc3RyLmxlbmd0aCA9PT0gMSkge1xuICAgICAgdGhyb3cgbmV3IEVycm9yKFwiSW52YWxpZCBjaGFpbiBwcm9wZXJ0eTogXCIuY29uY2F0KGlucHV0KSk7XG4gICAgfVxuXG4gICAgc3RyID0gc3RyLnNsaWNlKDEpO1xuICB9XG59O1xuXG52YXIgY29udmVydFR5cGVGcm9tU3RyID0gZnVuY3Rpb24gY29udmVydFR5cGVGcm9tU3RyKHZhbHVlKSB7XG4gIHZhciBudW1WYWx1ZSA9IE51bWJlcih2YWx1ZSk7XG4gIHZhciBvdXRwdXQ7XG5cbiAgaWYgKCFOdW1iZXIuaXNOYU4obnVtVmFsdWUpKSB7XG4gICAgb3V0cHV0ID0gbnVtVmFsdWU7XG4gIH0gZWxzZSB7XG4gICAgc3dpdGNoICh2YWx1ZSkge1xuICAgICAgY2FzZSAndW5kZWZpbmVkJzpcbiAgICAgICAgb3V0cHV0ID0gdW5kZWZpbmVkO1xuICAgICAgICBicmVhaztcblxuICAgICAgY2FzZSAnbnVsbCc6XG4gICAgICAgIG91dHB1dCA9IG51bGw7XG4gICAgICAgIGJyZWFrO1xuXG4gICAgICBjYXNlICd0cnVlJzpcbiAgICAgICAgb3V0cHV0ID0gdHJ1ZTtcbiAgICAgICAgYnJlYWs7XG5cbiAgICAgIGNhc2UgJ2ZhbHNlJzpcbiAgICAgICAgb3V0cHV0ID0gZmFsc2U7XG4gICAgICAgIGJyZWFrO1xuXG4gICAgICBkZWZhdWx0OlxuICAgICAgICBvdXRwdXQgPSB2YWx1ZTtcbiAgICB9XG4gIH1cblxuICByZXR1cm4gb3V0cHV0O1xufTtcblxudmFyIGNvbnZlcnRUeXBlSW50b1N0ciA9IGZ1bmN0aW9uIGNvbnZlcnRUeXBlSW50b1N0cih2YWx1ZSkge1xuICB2YXIgb3V0cHV0O1xuXG4gIHN3aXRjaCAodmFsdWUpIHtcbiAgICBjYXNlIHVuZGVmaW5lZDpcbiAgICAgIG91dHB1dCA9ICd1bmRlZmluZWQnO1xuICAgICAgYnJlYWs7XG5cbiAgICBjYXNlIG51bGw6XG4gICAgICBvdXRwdXQgPSAnbnVsbCc7XG4gICAgICBicmVhaztcblxuICAgIGRlZmF1bHQ6XG4gICAgICBvdXRwdXQgPSB2YWx1ZS50b1N0cmluZygpO1xuICB9XG5cbiAgcmV0dXJuIG91dHB1dDtcbn07XG4vKipcbiAqIENsYXNzIHRoYXQgZXh0ZW5kcyBTaXp6bGUgYW5kIGFkZHMgc3VwcG9ydCBmb3IgXCJtYXRjaGVzLXByb3BlcnR5XCIgcHNldWRvIGVsZW1lbnQuXG4gKi9cblxuXG52YXIgRWxlbWVudFByb3BlcnR5TWF0Y2hlciA9IGZ1bmN0aW9uICgpIHtcbiAgLyoqXG4gICAqIENsYXNzIHRoYXQgbWF0Y2hlcyBlbGVtZW50IHByb3BlcnRpZXMgYWdhaW5zdCB0aGUgc3BlY2lmaWVkIGV4cHJlc3Npb25zXG4gICAqIEBwYXJhbSB7QXJnRGF0YVtdfSBwcm9wc0NoYWluQXJnIC0gYXJyYXkgb2YgcGFyc2VkIHByb3BzIGNoYWluIG9iamVjdHNcbiAgICogQHBhcmFtIHtBcmdEYXRhfSB2YWx1ZUFyZyAtIHBhcnNlZCB2YWx1ZSBhcmd1bWVudFxuICAgKiBAcGFyYW0ge3N0cmluZ30gcHNldWRvRWxlbWVudFxuICAgKiBAY29uc3RydWN0b3JcbiAgICpcbiAgICogQG1lbWJlciB7QXJyYXl9IGNoYWluZWRQcm9wc1xuICAgKiBAbWVtYmVyIHtib29sZWFufSBpc1JlZ2V4cE5hbWVcbiAgICogQG1lbWJlciB7c3RyaW5nfFJlZ0V4cH0gcHJvcFZhbHVlXG4gICAqIEBtZW1iZXIge2Jvb2xlYW59IGlzUmVnZXhwVmFsdWVcbiAgICovXG4gIHZhciBQcm9wTWF0Y2hlciA9IGZ1bmN0aW9uIFByb3BNYXRjaGVyKHByb3BzQ2hhaW5BcmcsIHZhbHVlQXJnLCBwc2V1ZG9FbGVtZW50KSB7XG4gICAgdGhpcy5wc2V1ZG9FbGVtZW50ID0gcHNldWRvRWxlbWVudDtcbiAgICB0aGlzLmNoYWluZWRQcm9wcyA9IHByb3BzQ2hhaW5Bcmc7XG4gICAgdGhpcy5wcm9wVmFsdWUgPSB2YWx1ZUFyZy5hcmc7XG4gICAgdGhpcy5pc1JlZ2V4cFZhbHVlID0gdmFsdWVBcmcuaXNSZWdleHA7XG4gIH07XG4gIC8qKlxuICAgKiBGdW5jdGlvbiB0byBjaGVjayBpZiBlbGVtZW50IHByb3BlcnRpZXMgbWF0Y2hlcyBmaWx0ZXIgcGF0dGVyblxuICAgKiBAcGFyYW0ge0VsZW1lbnR9IGVsZW1lbnQgdG8gY2hlY2tcbiAgICovXG5cblxuICBQcm9wTWF0Y2hlci5wcm90b3R5cGUubWF0Y2hlcyA9IGZ1bmN0aW9uIChlbGVtZW50KSB7XG4gICAgdmFyIG93bmVyT2JqQXJyID0gbWF0Y2hlclV0aWxzLmZpbHRlclJvb3RzQnlSZWdleHBDaGFpbihlbGVtZW50LCB0aGlzLmNoYWluZWRQcm9wcyk7XG5cbiAgICBpZiAob3duZXJPYmpBcnIubGVuZ3RoID09PSAwKSB7XG4gICAgICByZXR1cm4gZmFsc2U7XG4gICAgfVxuXG4gICAgdmFyIG1hdGNoZWQgPSB0cnVlO1xuXG4gICAgaWYgKHRoaXMucHJvcFZhbHVlKSB7XG4gICAgICBmb3IgKHZhciBpID0gMDsgaSA8IG93bmVyT2JqQXJyLmxlbmd0aDsgaSArPSAxKSB7XG4gICAgICAgIHZhciByZWFsVmFsdWUgPSBvd25lck9iakFycltpXS52YWx1ZTtcblxuICAgICAgICBpZiAodGhpcy5pc1JlZ2V4cFZhbHVlKSB7XG4gICAgICAgICAgbWF0Y2hlZCA9IHRoaXMucHJvcFZhbHVlLnRlc3QoY29udmVydFR5cGVJbnRvU3RyKHJlYWxWYWx1ZSkpO1xuICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgIC8vIGhhbmRsZSAnbnVsbCcgYW5kICd1bmRlZmluZWQnIHByb3BlcnR5IHZhbHVlcyBzZXQgYXMgc3RyaW5nXG4gICAgICAgICAgaWYgKHJlYWxWYWx1ZSA9PT0gJ251bGwnIHx8IHJlYWxWYWx1ZSA9PT0gJ3VuZGVmaW5lZCcpIHtcbiAgICAgICAgICAgIG1hdGNoZWQgPSB0aGlzLnByb3BWYWx1ZSA9PT0gcmVhbFZhbHVlO1xuICAgICAgICAgICAgYnJlYWs7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgbWF0Y2hlZCA9IGNvbnZlcnRUeXBlRnJvbVN0cih0aGlzLnByb3BWYWx1ZSkgPT09IHJlYWxWYWx1ZTtcbiAgICAgICAgfVxuXG4gICAgICAgIGlmIChtYXRjaGVkKSB7XG4gICAgICAgICAgYnJlYWs7XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICB9XG5cbiAgICByZXR1cm4gbWF0Y2hlZDtcbiAgfTtcbiAgLyoqXG4gICAqIENyZWF0ZXMgYSBuZXcgcHNldWRvLWNsYXNzIGFuZCByZWdpc3RlcnMgaXQgaW4gU2l6emxlXG4gICAqL1xuXG5cbiAgdmFyIGV4dGVuZFNpenpsZSA9IGZ1bmN0aW9uIGV4dGVuZFNpenpsZShzaXp6bGUpIHtcbiAgICAvLyBGaXJzdCBvZiBhbGwgd2Ugc2hvdWxkIHByZXBhcmUgU2l6emxlIGVuZ2luZVxuICAgIHNpenpsZS5zZWxlY3RvcnMucHNldWRvc1snbWF0Y2hlcy1wcm9wZXJ0eSddID0gc2l6emxlLnNlbGVjdG9ycy5jcmVhdGVQc2V1ZG8oZnVuY3Rpb24gKHByb3BlcnR5RmlsdGVyKSB7XG4gICAgICBpZiAoIXByb3BlcnR5RmlsdGVyKSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcignTm8gYXJndW1lbnQgaXMgZ2l2ZW4gZm9yIDptYXRjaGVzLXByb3BlcnR5IHBzZXVkbyBjbGFzcycpO1xuICAgICAgfVxuXG4gICAgICB2YXIgX21hdGNoZXJVdGlscyRwYXJzZU1hID0gbWF0Y2hlclV0aWxzLnBhcnNlTWF0Y2hlckZpbHRlcihwcm9wZXJ0eUZpbHRlciksXG4gICAgICAgICAgX21hdGNoZXJVdGlscyRwYXJzZU1hMiA9IF9zbGljZWRUb0FycmF5KF9tYXRjaGVyVXRpbHMkcGFyc2VNYSwgMiksXG4gICAgICAgICAgcmF3UHJvcCA9IF9tYXRjaGVyVXRpbHMkcGFyc2VNYTJbMF0sXG4gICAgICAgICAgcmF3VmFsdWUgPSBfbWF0Y2hlclV0aWxzJHBhcnNlTWEyWzFdOyAvLyBjaGFpbmVkIHByb3BlcnR5IG5hbWUgY2FuIG5vdCBpbmNsdWRlICcvJyBvciAnLidcbiAgICAgIC8vIHNvIHJlZ2V4IHByb3AgbmFtZXMgd2l0aCBzdWNoIGVzY2FwZWQgY2hhcmFjdGVycyBhcmUgaW52YWxpZFxuXG5cbiAgICAgIGlmIChyYXdQcm9wLmluZGV4T2YoJ1xcXFwvJykgPiAtMSB8fCByYXdQcm9wLmluZGV4T2YoJ1xcXFwuJykgPiAtMSkge1xuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJJbnZhbGlkIHByb3BlcnR5IG5hbWU6IFwiLmNvbmNhdChyYXdQcm9wKSk7XG4gICAgICB9XG5cbiAgICAgIHZhciBwcm9wc0NoYWluQXJnID0gcGFyc2VSYXdQcm9wQ2hhaW4ocmF3UHJvcCk7XG4gICAgICB2YXIgdmFsdWVBcmcgPSBtYXRjaGVyVXRpbHMucGFyc2VSYXdNYXRjaGVyQXJnKHJhd1ZhbHVlKTtcbiAgICAgIHZhciBwcm9wc1RvVmFsaWRhdGUgPSBbXS5jb25jYXQoX3RvQ29uc3VtYWJsZUFycmF5KHByb3BzQ2hhaW5BcmcpLCBbdmFsdWVBcmddKTtcblxuICAgICAgaWYgKCFtYXRjaGVyVXRpbHMudmFsaWRhdGVQcm9wTWF0Y2hlckFyZ3MocHJvcHNUb1ZhbGlkYXRlKSkge1xuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJJbnZhbGlkIGFyZ3VtZW50IG9mIDptYXRjaGVzLXByb3BlcnR5IHBzZXVkbyBjbGFzczogXCIuY29uY2F0KHByb3BlcnR5RmlsdGVyKSk7XG4gICAgICB9XG5cbiAgICAgIHZhciBtYXRjaGVyID0gbmV3IFByb3BNYXRjaGVyKHByb3BzQ2hhaW5BcmcsIHZhbHVlQXJnKTtcbiAgICAgIHJldHVybiBmdW5jdGlvbiAoZWxlbWVudCkge1xuICAgICAgICByZXR1cm4gbWF0Y2hlci5tYXRjaGVzKGVsZW1lbnQpO1xuICAgICAgfTtcbiAgICB9KTtcbiAgfTsgLy8gRVhQT1NFXG5cblxuICByZXR1cm4ge1xuICAgIGV4dGVuZFNpenpsZTogZXh0ZW5kU2l6emxlXG4gIH07XG59KCk7XG5cbi8qKlxuICogQ29weXJpZ2h0IDIwMjAgQWRndWFyZCBTb2Z0d2FyZSBMdGRcbiAqXG4gKiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2Vuc2UsIFZlcnNpb24gMi4wICh0aGUgXCJMaWNlbnNlXCIpO1xuICogeW91IG1heSBub3QgdXNlIHRoaXMgZmlsZSBleGNlcHQgaW4gY29tcGxpYW5jZSB3aXRoIHRoZSBMaWNlbnNlLlxuICogWW91IG1heSBvYnRhaW4gYSBjb3B5IG9mIHRoZSBMaWNlbnNlIGF0XG4gKlxuICogaHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wXG4gKlxuICogVW5sZXNzIHJlcXVpcmVkIGJ5IGFwcGxpY2FibGUgbGF3IG9yIGFncmVlZCB0byBpbiB3cml0aW5nLCBzb2Z0d2FyZVxuICogZGlzdHJpYnV0ZWQgdW5kZXIgdGhlIExpY2Vuc2UgaXMgZGlzdHJpYnV0ZWQgb24gYW4gXCJBUyBJU1wiIEJBU0lTLFxuICogV0lUSE9VVCBXQVJSQU5USUVTIE9SIENPTkRJVElPTlMgT0YgQU5ZIEtJTkQsIGVpdGhlciBleHByZXNzIG9yIGltcGxpZWQuXG4gKiBTZWUgdGhlIExpY2Vuc2UgZm9yIHRoZSBzcGVjaWZpYyBsYW5ndWFnZSBnb3Zlcm5pbmcgcGVybWlzc2lvbnMgYW5kXG4gKiBsaW1pdGF0aW9ucyB1bmRlciB0aGUgTGljZW5zZS5cbiAqL1xuLyoqXG4gKiBDbGFzcyB0aGF0IGV4dGVuZHMgU2l6emxlIGFuZCBhZGRzIHN1cHBvcnQgZm9yIDppcygpIHBzZXVkbyBlbGVtZW50LlxuICovXG5cbnZhciBJc0FueU1hdGNoZXIgPSBmdW5jdGlvbiAoKSB7XG4gIC8qKlxuICAgKiBDbGFzcyB0aGF0IG1hdGNoZXMgZWxlbWVudCBieSBvbmUgb2YgdGhlIHNlbGVjdG9yc1xuICAgKiBodHRwczovL2RldmVsb3Blci5tb3ppbGxhLm9yZy9lbi1VUy9kb2NzL1dlYi9DU1MvOmlzXG4gICAqIEBwYXJhbSB7QXJyYXl9IHNlbGVjdG9yc1xuICAgKiBAcGFyYW0ge3N0cmluZ30gcHNldWRvRWxlbWVudFxuICAgKiBAY29uc3RydWN0b3JcbiAgICovXG4gIHZhciBJc01hdGNoZXIgPSBmdW5jdGlvbiBJc01hdGNoZXIoc2VsZWN0b3JzLCBwc2V1ZG9FbGVtZW50KSB7XG4gICAgdGhpcy5zZWxlY3RvcnMgPSBzZWxlY3RvcnM7XG4gICAgdGhpcy5wc2V1ZG9FbGVtZW50ID0gcHNldWRvRWxlbWVudDtcbiAgfTtcbiAgLyoqXG4gICAqIEZ1bmN0aW9uIHRvIGNoZWNrIGlmIGVsZW1lbnQgY2FuIGJlIG1hdGNoZWQgYnkgYW55IHBhc3NlZCBzZWxlY3RvclxuICAgKiBAcGFyYW0ge0VsZW1lbnR9IGVsZW1lbnQgdG8gY2hlY2tcbiAgICovXG5cblxuICBJc01hdGNoZXIucHJvdG90eXBlLm1hdGNoZXMgPSBmdW5jdGlvbiAoZWxlbWVudCkge1xuICAgIHZhciBpc01hdGNoZWQgPSAhIXRoaXMuc2VsZWN0b3JzLmZpbmQoZnVuY3Rpb24gKHNlbGVjdG9yKSB7XG4gICAgICB2YXIgbm9kZXMgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yQWxsKHNlbGVjdG9yKTtcbiAgICAgIHJldHVybiBBcnJheS5mcm9tKG5vZGVzKS5maW5kKGZ1bmN0aW9uIChub2RlKSB7XG4gICAgICAgIHJldHVybiBub2RlID09PSBlbGVtZW50O1xuICAgICAgfSk7XG4gICAgfSk7XG4gICAgcmV0dXJuIGlzTWF0Y2hlZDtcbiAgfTtcbiAgLyoqXG4gICAqIENyZWF0ZXMgYSBuZXcgcHNldWRvLWNsYXNzIGFuZCByZWdpc3RlcnMgaXQgaW4gU2l6emxlXG4gICAqL1xuXG5cbiAgdmFyIGV4dGVuZFNpenpsZSA9IGZ1bmN0aW9uIGV4dGVuZFNpenpsZShzaXp6bGUpIHtcbiAgICAvLyBGaXJzdCBvZiBhbGwgd2Ugc2hvdWxkIHByZXBhcmUgU2l6emxlIGVuZ2luZVxuICAgIHNpenpsZS5zZWxlY3RvcnMucHNldWRvc1snaXMnXSA9IHNpenpsZS5zZWxlY3RvcnMuY3JlYXRlUHNldWRvKGZ1bmN0aW9uIChpbnB1dCkge1xuICAgICAgaWYgKGlucHV0ID09PSAnJykge1xuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJJbnZhbGlkIGFyZ3VtZW50IG9mIDppcyBwc2V1ZG8tY2xhc3M6IFwiLmNvbmNhdChpbnB1dCkpO1xuICAgICAgfVxuXG4gICAgICB2YXIgc2VsZWN0b3JzID0gaW5wdXQuc3BsaXQoJywnKS5tYXAoZnVuY3Rpb24gKHMpIHtcbiAgICAgICAgcmV0dXJuIHMudHJpbSgpO1xuICAgICAgfSk7IC8vIGNvbGxlY3QgdmFsaWQgc2VsZWN0b3JzIGFuZCBsb2cgYWJvdXQgaW52YWxpZCBvbmVzXG5cbiAgICAgIHZhciB2YWxpZFNlbGVjdG9ycyA9IHNlbGVjdG9ycy5yZWR1Y2UoZnVuY3Rpb24gKGFjYywgc2VsZWN0b3IpIHtcbiAgICAgICAgaWYgKGNzc1V0aWxzLmlzU2ltcGxlU2VsZWN0b3JWYWxpZChzZWxlY3RvcikpIHtcbiAgICAgICAgICBhY2MucHVzaChzZWxlY3Rvcik7XG4gICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgdXRpbHMubG9nSW5mbyhcIkludmFsaWQgc2VsZWN0b3IgcGFzc2VkIHRvIDppcygpIHBzZXVkby1jbGFzczogJ1wiLmNvbmNhdChzZWxlY3RvciwgXCInXCIpKTtcbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiBhY2M7XG4gICAgICB9LCBbXSk7XG4gICAgICB2YXIgbWF0Y2hlciA9IG5ldyBJc01hdGNoZXIodmFsaWRTZWxlY3RvcnMpO1xuICAgICAgcmV0dXJuIGZ1bmN0aW9uIChlbGVtZW50KSB7XG4gICAgICAgIHJldHVybiBtYXRjaGVyLm1hdGNoZXMoZWxlbWVudCk7XG4gICAgICB9O1xuICAgIH0pO1xuICB9O1xuXG4gIHJldHVybiB7XG4gICAgZXh0ZW5kU2l6emxlOiBleHRlbmRTaXp6bGVcbiAgfTtcbn0oKTtcblxuLyoqXG4gKiBDb3B5cmlnaHQgMjAyMSBBZGd1YXJkIFNvZnR3YXJlIEx0ZFxuICpcbiAqIExpY2Vuc2VkIHVuZGVyIHRoZSBBcGFjaGUgTGljZW5zZSwgVmVyc2lvbiAyLjAgKHRoZSBcIkxpY2Vuc2VcIik7XG4gKiB5b3UgbWF5IG5vdCB1c2UgdGhpcyBmaWxlIGV4Y2VwdCBpbiBjb21wbGlhbmNlIHdpdGggdGhlIExpY2Vuc2UuXG4gKiBZb3UgbWF5IG9idGFpbiBhIGNvcHkgb2YgdGhlIExpY2Vuc2UgYXRcbiAqXG4gKiBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElDRU5TRS0yLjBcbiAqXG4gKiBVbmxlc3MgcmVxdWlyZWQgYnkgYXBwbGljYWJsZSBsYXcgb3IgYWdyZWVkIHRvIGluIHdyaXRpbmcsIHNvZnR3YXJlXG4gKiBkaXN0cmlidXRlZCB1bmRlciB0aGUgTGljZW5zZSBpcyBkaXN0cmlidXRlZCBvbiBhbiBcIkFTIElTXCIgQkFTSVMsXG4gKiBXSVRIT1VUIFdBUlJBTlRJRVMgT1IgQ09ORElUSU9OUyBPRiBBTlkgS0lORCwgZWl0aGVyIGV4cHJlc3Mgb3IgaW1wbGllZC5cbiAqIFNlZSB0aGUgTGljZW5zZSBmb3IgdGhlIHNwZWNpZmljIGxhbmd1YWdlIGdvdmVybmluZyBwZXJtaXNzaW9ucyBhbmRcbiAqIGxpbWl0YXRpb25zIHVuZGVyIHRoZSBMaWNlbnNlLlxuICovXG4vKipcbiAqIEV4dGVuZGVkIHNlbGVjdG9yIGZhY3RvcnkgbW9kdWxlLCBmb3IgY3JlYXRpbmcgZXh0ZW5kZWQgc2VsZWN0b3IgY2xhc3Nlcy5cbiAqXG4gKiBFeHRlbmRlZCBzZWxlY3Rpb24gY2FwYWJpbGl0aWVzIGRlc2NyaXB0aW9uOlxuICogaHR0cHM6Ly9naXRodWIuY29tL0FkZ3VhcmRUZWFtL0V4dGVuZGVkQ3NzL2Jsb2IvbWFzdGVyL1JFQURNRS5tZFxuICovXG5cbnZhciBFeHRlbmRlZFNlbGVjdG9yRmFjdG9yeSA9IGZ1bmN0aW9uICgpIHtcbiAgLy8gd2hpbGUgYWRkaW5nIG5ldyBtYXJrZXJzLCBjb25zdGFudHMgaW4gb3RoZXIgQWRHdWFyZCByZXBvcyBzaG91bGQgYmUgY29ycmVjdGVkXG4gIC8vIEFkR3VhcmQgYnJvd3NlciBleHRlbnNpb24gOiBDc3NGaWx0ZXJSdWxlLlNVUFBPUlRFRF9QU0VVRE9fQ0xBU1NFUyBhbmQgQ3NzRmlsdGVyUnVsZS5FWFRFTkRFRF9DU1NfTUFSS0VSU1xuICAvLyB0c3VybGZpbHRlciwgU2FmYXJpQ29udmVydGVyTGliIDogRVhUX0NTU19QU0VVRE9fSU5ESUNBVE9SU1xuICB2YXIgUFNFVURPX0VYVEVOU0lPTlNfTUFSS0VSUyA9IFsnOmhhcycsICc6Y29udGFpbnMnLCAnOmhhcy10ZXh0JywgJzptYXRjaGVzLWNzcycsICc6LWFicC1oYXMnLCAnOi1hYnAtaGFzLXRleHQnLCAnOmlmJywgJzppZi1ub3QnLCAnOnhwYXRoJywgJzpudGgtYW5jZXN0b3InLCAnOnVwd2FyZCcsICc6cmVtb3ZlJywgJzptYXRjaGVzLWF0dHInLCAnOm1hdGNoZXMtcHJvcGVydHknLCAnOi1hYnAtY29udGFpbnMnLCAnOmlzJ107XG4gIHZhciBpbml0aWFsaXplZCA9IGZhbHNlO1xuICB2YXIgU2l6emxlO1xuICAvKipcbiAgICogTGF6eSBpbml0aWFsaXphdGlvbiBvZiB0aGUgRXh0ZW5kZWRTZWxlY3RvckZhY3RvcnkgYW5kIG9iamVjdHMgdGhhdCBtaWdodCBiZSBuZWNlc3NhcnkgZm9yIGNyZWF0aW5nIGFuZCBhcHBseWluZyBzdHlsZXMuXG4gICAqIFRoaXMgbWV0aG9kIGV4dGVuZHMgU2l6emxlIGVuZ2luZSB0aGF0IHdlIHVzZSB1bmRlciB0aGUgaG9vZCB3aXRoIG91ciBjdXN0b20gcHNldWRvLWNsYXNzZXMuXG4gICAqL1xuXG4gIGZ1bmN0aW9uIGluaXRpYWxpemUoKSB7XG4gICAgaWYgKGluaXRpYWxpemVkKSB7XG4gICAgICByZXR1cm47XG4gICAgfVxuXG4gICAgaW5pdGlhbGl6ZWQgPSB0cnVlOyAvLyBPdXIgdmVyc2lvbiBvZiBTaXp6bGUgaXMgaW5pdGlhbGl6ZWQgbGF6aWx5IGFzIHdlbGxcblxuICAgIFNpenpsZSA9IGluaXRpYWxpemVTaXp6bGUoKTsgLy8gQWRkIDptYXRjaGVzLWNzcy0qKCkgc3VwcG9ydFxuXG4gICAgU3R5bGVQcm9wZXJ0eU1hdGNoZXIuZXh0ZW5kU2l6emxlKFNpenpsZSk7IC8vIEFkZCA6bWF0Y2hlcy1hdHRyKCkgc3VwcG9ydFxuXG4gICAgQXR0cmlidXRlc01hdGNoZXIuZXh0ZW5kU2l6emxlKFNpenpsZSk7IC8vIEFkZCA6bWF0Y2hlcy1wcm9wZXJ0eSgpIHN1cHBvcnRcblxuICAgIEVsZW1lbnRQcm9wZXJ0eU1hdGNoZXIuZXh0ZW5kU2l6emxlKFNpenpsZSk7IC8vIEFkZCA6aXMoKSBzdXBwb3J0XG5cbiAgICBJc0FueU1hdGNoZXIuZXh0ZW5kU2l6emxlKFNpenpsZSk7IC8vIEFkZCA6Y29udGFpbnMsIDpoYXMtdGV4dCwgOi1hYnAtY29udGFpbnMgc3VwcG9ydFxuXG4gICAgdmFyIGNvbnRhaW5zUHNldWRvID0gU2l6emxlLnNlbGVjdG9ycy5jcmVhdGVQc2V1ZG8oZnVuY3Rpb24gKHRleHQpIHtcbiAgICAgIGlmICgvXlxccypcXC8uKlxcL1tnbWlzdXldKlxccyokLy50ZXN0KHRleHQpKSB7XG4gICAgICAgIHRleHQgPSB0ZXh0LnRyaW0oKTtcbiAgICAgICAgdmFyIGZsYWdzSW5kZXggPSB0ZXh0Lmxhc3RJbmRleE9mKCcvJyk7XG4gICAgICAgIHZhciBmbGFncyA9IHRleHQuc3Vic3RyaW5nKGZsYWdzSW5kZXggKyAxKTtcbiAgICAgICAgdGV4dCA9IHRleHQuc3Vic3RyKDAsIGZsYWdzSW5kZXggKyAxKS5zbGljZSgxLCAtMSkucmVwbGFjZSgvXFxcXChbXFxcXFwiXSkvZywgJyQxJyk7XG4gICAgICAgIHZhciByZWdleDtcblxuICAgICAgICB0cnkge1xuICAgICAgICAgIHJlZ2V4ID0gbmV3IFJlZ0V4cCh0ZXh0LCBmbGFncyk7XG4gICAgICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJJbnZhbGlkIGFyZ3VtZW50IG9mIDpjb250YWlucyBwc2V1ZG8gY2xhc3M6IFwiLmNvbmNhdCh0ZXh0KSk7XG4gICAgICAgIH1cblxuICAgICAgICByZXR1cm4gZnVuY3Rpb24gKGVsZW0pIHtcbiAgICAgICAgICB2YXIgZWxlbVRleHRDb250ZW50ID0gdXRpbHMubm9kZVRleHRDb250ZW50R2V0dGVyLmFwcGx5KGVsZW0pO1xuICAgICAgICAgIHJldHVybiByZWdleC50ZXN0KGVsZW1UZXh0Q29udGVudCk7XG4gICAgICAgIH07XG4gICAgICB9XG5cbiAgICAgIHRleHQgPSB0ZXh0LnJlcGxhY2UoL1xcXFwoW1xcXFwoKVtcXF1cIl0pL2csICckMScpO1xuICAgICAgcmV0dXJuIGZ1bmN0aW9uIChlbGVtKSB7XG4gICAgICAgIHZhciBlbGVtVGV4dENvbnRlbnQgPSB1dGlscy5ub2RlVGV4dENvbnRlbnRHZXR0ZXIuYXBwbHkoZWxlbSk7XG4gICAgICAgIHJldHVybiBlbGVtVGV4dENvbnRlbnQuaW5kZXhPZih0ZXh0KSA+IC0xO1xuICAgICAgfTtcbiAgICB9KTtcbiAgICBTaXp6bGUuc2VsZWN0b3JzLnBzZXVkb3NbJ2NvbnRhaW5zJ10gPSBjb250YWluc1BzZXVkbztcbiAgICBTaXp6bGUuc2VsZWN0b3JzLnBzZXVkb3NbJ2hhcy10ZXh0J10gPSBjb250YWluc1BzZXVkbztcbiAgICBTaXp6bGUuc2VsZWN0b3JzLnBzZXVkb3NbJy1hYnAtY29udGFpbnMnXSA9IGNvbnRhaW5zUHNldWRvOyAvLyBBZGQgOmlmLCA6LWFicC1oYXMgc3VwcG9ydFxuXG4gICAgU2l6emxlLnNlbGVjdG9ycy5wc2V1ZG9zWydpZiddID0gU2l6emxlLnNlbGVjdG9ycy5wc2V1ZG9zWydoYXMnXTtcbiAgICBTaXp6bGUuc2VsZWN0b3JzLnBzZXVkb3NbJy1hYnAtaGFzJ10gPSBTaXp6bGUuc2VsZWN0b3JzLnBzZXVkb3NbJ2hhcyddOyAvLyBBZGQgOmlmLW5vdCBzdXBwb3J0XG5cbiAgICBTaXp6bGUuc2VsZWN0b3JzLnBzZXVkb3NbJ2lmLW5vdCddID0gU2l6emxlLnNlbGVjdG9ycy5jcmVhdGVQc2V1ZG8oZnVuY3Rpb24gKHNlbGVjdG9yKSB7XG4gICAgICBpZiAodHlwZW9mIHNlbGVjdG9yID09PSAnc3RyaW5nJykge1xuICAgICAgICBTaXp6bGUuY29tcGlsZShzZWxlY3Rvcik7XG4gICAgICB9XG5cbiAgICAgIHJldHVybiBmdW5jdGlvbiAoZWxlbSkge1xuICAgICAgICByZXR1cm4gU2l6emxlKHNlbGVjdG9yLCBlbGVtKS5sZW5ndGggPT09IDA7XG4gICAgICB9O1xuICAgIH0pO1xuICAgIHJlZ2lzdGVyUGFyc2VyT25seVRva2VucygpO1xuICB9XG4gIC8qKlxuICAgKiBSZWdpc3RyYXRlIGN1c3RvbSB0b2tlbnMgZm9yIHBhcnNlci5cbiAgICogTmVlZGVkIGZvciBwcm9wZXIgd29yayBvZiBwc2V1ZG9zOlxuICAgKiBmb3IgY2hlY2tpbmcgaWYgdGhlIHRva2VuIGlzIGxhc3QgYW5kIHBzZXVkby1jbGFzcyBhcmd1bWVudHMgdmFsaWRhdGlvblxuICAgKi9cblxuXG4gIGZ1bmN0aW9uIHJlZ2lzdGVyUGFyc2VyT25seVRva2VucygpIHtcbiAgICBTaXp6bGUuc2VsZWN0b3JzLnBzZXVkb3NbJ3hwYXRoJ10gPSBTaXp6bGUuc2VsZWN0b3JzLmNyZWF0ZVBzZXVkbyhmdW5jdGlvbiAoc2VsZWN0b3IpIHtcbiAgICAgIHRyeSB7XG4gICAgICAgIGRvY3VtZW50LmNyZWF0ZUV4cHJlc3Npb24oc2VsZWN0b3IsIG51bGwpO1xuICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJJbnZhbGlkIGFyZ3VtZW50IG9mIDp4cGF0aCBwc2V1ZG8gY2xhc3M6IFwiLmNvbmNhdChzZWxlY3RvcikpO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gZnVuY3Rpb24gKCkge1xuICAgICAgICByZXR1cm4gdHJ1ZTtcbiAgICAgIH07XG4gICAgfSk7XG4gICAgU2l6emxlLnNlbGVjdG9ycy5wc2V1ZG9zWydudGgtYW5jZXN0b3InXSA9IFNpenpsZS5zZWxlY3RvcnMuY3JlYXRlUHNldWRvKGZ1bmN0aW9uIChzZWxlY3Rvcikge1xuICAgICAgdmFyIGRlZXAgPSBOdW1iZXIoc2VsZWN0b3IpO1xuXG4gICAgICBpZiAoTnVtYmVyLmlzTmFOKGRlZXApIHx8IGRlZXAgPCAxIHx8IGRlZXAgPj0gMjU2KSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcihcIkludmFsaWQgYXJndW1lbnQgb2YgOm50aC1hbmNlc3RvciBwc2V1ZG8gY2xhc3M6IFwiLmNvbmNhdChzZWxlY3RvcikpO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gZnVuY3Rpb24gKCkge1xuICAgICAgICByZXR1cm4gdHJ1ZTtcbiAgICAgIH07XG4gICAgfSk7XG4gICAgU2l6emxlLnNlbGVjdG9ycy5wc2V1ZG9zWyd1cHdhcmQnXSA9IFNpenpsZS5zZWxlY3RvcnMuY3JlYXRlUHNldWRvKGZ1bmN0aW9uIChpbnB1dCkge1xuICAgICAgaWYgKGlucHV0ID09PSAnJykge1xuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJJbnZhbGlkIGFyZ3VtZW50IG9mIDp1cHdhcmQgcHNldWRvIGNsYXNzOiBcIi5jb25jYXQoaW5wdXQpKTtcbiAgICAgIH0gZWxzZSBpZiAoTnVtYmVyLmlzSW50ZWdlcigraW5wdXQpICYmICgraW5wdXQgPCAxIHx8ICtpbnB1dCA+PSAyNTYpKSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcihcIkludmFsaWQgYXJndW1lbnQgb2YgOnVwd2FyZCBwc2V1ZG8gY2xhc3M6IFwiLmNvbmNhdChpbnB1dCkpO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gZnVuY3Rpb24gKCkge1xuICAgICAgICByZXR1cm4gdHJ1ZTtcbiAgICAgIH07XG4gICAgfSk7XG4gICAgU2l6emxlLnNlbGVjdG9ycy5wc2V1ZG9zWydyZW1vdmUnXSA9IFNpenpsZS5zZWxlY3RvcnMuY3JlYXRlUHNldWRvKGZ1bmN0aW9uIChpbnB1dCkge1xuICAgICAgaWYgKGlucHV0ICE9PSAnJykge1xuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJJbnZhbGlkIGFyZ3VtZW50IG9mIDpyZW1vdmUgcHNldWRvIGNsYXNzOiBcIi5jb25jYXQoaW5wdXQpKTtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIGZ1bmN0aW9uICgpIHtcbiAgICAgICAgcmV0dXJuIHRydWU7XG4gICAgICB9O1xuICAgIH0pO1xuICB9XG4gIC8qKlxuICAgKiBDaGVja3MgaWYgc3BlY2lmaWVkIHRva2VuIGNhbiBiZSB1c2VkIGJ5IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3JBbGwuXG4gICAqL1xuXG5cbiAgZnVuY3Rpb24gaXNTaW1wbGVUb2tlbih0b2tlbikge1xuICAgIHZhciB0eXBlID0gdG9rZW4udHlwZTtcblxuICAgIGlmICh0eXBlID09PSAnSUQnIHx8IHR5cGUgPT09ICdDTEFTUycgfHwgdHlwZSA9PT0gJ0FUVFInIHx8IHR5cGUgPT09ICdUQUcnIHx8IHR5cGUgPT09ICdDSElMRCcpIHtcbiAgICAgIC8vIGtub3duIHNpbXBsZSB0b2tlbnNcbiAgICAgIHJldHVybiB0cnVlO1xuICAgIH1cblxuICAgIGlmICh0eXBlID09PSAnUFNFVURPJykge1xuICAgICAgLy8gY2hlY2sgaWYgdmFsdWUgY29udGFpbnMgYW55IG9mIGV4dGVuZGVkIHBzZXVkbyBjbGFzc2VzXG4gICAgICB2YXIgaSA9IFBTRVVET19FWFRFTlNJT05TX01BUktFUlMubGVuZ3RoO1xuXG4gICAgICB3aGlsZSAoaS0tKSB7XG4gICAgICAgIGlmICh0b2tlbi52YWx1ZS5pbmRleE9mKFBTRVVET19FWFRFTlNJT05TX01BUktFUlNbaV0pID49IDApIHtcbiAgICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICAgIH1cbiAgICAgIH1cblxuICAgICAgcmV0dXJuIHRydWU7XG4gICAgfSAvLyBhbGwgb3RoZXJzIGFyZW4ndCBzaW1wbGVcblxuXG4gICAgcmV0dXJuIGZhbHNlO1xuICB9XG4gIC8qKlxuICAgKiBDaGVja3MgaWYgc3BlY2lmaWVkIHRva2VuIGlzIGEgY29tYmluYXRvclxuICAgKi9cblxuXG4gIGZ1bmN0aW9uIGlzUmVsYXRpb25Ub2tlbih0b2tlbikge1xuICAgIHZhciB0eXBlID0gdG9rZW4udHlwZTtcbiAgICByZXR1cm4gdHlwZSA9PT0gJyAnIHx8IHR5cGUgPT09ICc+JyB8fCB0eXBlID09PSAnKycgfHwgdHlwZSA9PT0gJ34nO1xuICB9XG4gIC8qKlxuICAgKiBFeHRlbmRlZFNlbGVjdG9yUGFyc2VyIGlzIGEgaGVscGVyIGNsYXNzIGZvciBjcmVhdGluZyB2YXJpb3VzIHNlbGVjdG9yIGluc3RhbmNlcyB3aGljaFxuICAgKiBhbGwgc2hhcmVzIGEgbWV0aG9kIGBxdWVyeVNlbGVjdG9yQWxsKClgIGFuZCBgbWF0Y2hlcygpYCBpbXBsZW1lbnRpbmcgZGlmZmVyZW50IHNlYXJjaCBzdHJhdGVnaWVzXG4gICAqIGRlcGVuZGluZyBvbiBhIHR5cGUgb2Ygc2VsZWN0b3IuXG4gICAqXG4gICAqIEN1cnJlbnRseSwgdGhlcmUgYXJlIDMgdHlwZXM6XG4gICAqICBBIHRyYWl0LWxlc3MgZXh0ZW5kZWQgc2VsZWN0b3JcbiAgICogICAgLSB3ZSBkaXJlY3RseSBmZWVkIHNlbGVjdG9yIHN0cmluZ3MgdG8gU2l6emxlLlxuICAgKiAgQSBzcGxpdHRlZCBleHRlbmRlZCBzZWxlY3RvclxuICAgKiAgICAtIHN1Y2ggYXMgI2NvbnRhaW5lciAjZmVlZEl0ZW06aGFzKC5hZHMpLCB3aGVyZSBpdCBpcyBzcGxpdHRlZCB0byBgI2NvbnRhaW5lcmAgYW5kIGAjZmVlZEl0ZW06aGFzKC5hZHMpYC5cbiAgICovXG5cblxuICBmdW5jdGlvbiBFeHRlbmRlZFNlbGVjdG9yUGFyc2VyKHNlbGVjdG9yVGV4dCwgdG9rZW5zLCBkZWJ1Zykge1xuICAgIGluaXRpYWxpemUoKTtcblxuICAgIGlmICh0eXBlb2YgdG9rZW5zID09PSAndW5kZWZpbmVkJykge1xuICAgICAgdGhpcy5zZWxlY3RvclRleHQgPSBjc3NVdGlscy5ub3JtYWxpemUoc2VsZWN0b3JUZXh0KTsgLy8gUGFzc2luZyBgcmV0dXJuVW5zb3J0ZWRgIGluIG9yZGVyIHRvIHJlY2VpdmUgdG9rZW5zIGluIHRoZSBvcmRlciB0aGF0J3MgdmFsaWQgZm9yIHRoZSBicm93c2VyXG4gICAgICAvLyBJbiBTaXp6bGUgaW50ZXJuYWxseSwgdGhlIHRva2VucyBhcmUgcmUtc29ydGVkOiBodHRwczovL2dpdGh1Yi5jb20vQWRndWFyZFRlYW0vRXh0ZW5kZWRDc3MvaXNzdWVzLzU1XG5cbiAgICAgIHRoaXMudG9rZW5zID0gU2l6emxlLnRva2VuaXplKHRoaXMuc2VsZWN0b3JUZXh0LCBmYWxzZSwge1xuICAgICAgICByZXR1cm5VbnNvcnRlZDogdHJ1ZVxuICAgICAgfSk7XG4gICAgfSBlbHNlIHtcbiAgICAgIHRoaXMuc2VsZWN0b3JUZXh0ID0gc2VsZWN0b3JUZXh0O1xuICAgICAgdGhpcy50b2tlbnMgPSB0b2tlbnM7XG4gICAgfVxuXG4gICAgaWYgKGRlYnVnID09PSB0cnVlKSB7XG4gICAgICB0aGlzLmRlYnVnID0gdHJ1ZTtcbiAgICB9XG4gIH1cblxuICBFeHRlbmRlZFNlbGVjdG9yUGFyc2VyLnByb3RvdHlwZSA9IHtcbiAgICAvKipcbiAgICAgKiBUaGUgbWFpbiBtZXRob2QsIGNyZWF0ZXMgYSBzZWxlY3RvciBpbnN0YW5jZSBkZXBlbmRpbmcgb24gdGhlIHR5cGUgb2YgYSBzZWxlY3Rvci5cbiAgICAgKiBAcHVibGljXG4gICAgICovXG4gICAgY3JlYXRlU2VsZWN0b3I6IGZ1bmN0aW9uIGNyZWF0ZVNlbGVjdG9yKCkge1xuICAgICAgdmFyIGRlYnVnID0gdGhpcy5kZWJ1ZztcbiAgICAgIHZhciB0b2tlbnMgPSB0aGlzLnRva2VucztcbiAgICAgIHZhciBzZWxlY3RvclRleHQgPSB0aGlzLnNlbGVjdG9yVGV4dDtcblxuICAgICAgaWYgKHRva2Vucy5sZW5ndGggIT09IDEpIHtcbiAgICAgICAgLy8gQ29tbWEtc2VwYXJhdGUgc2VsZWN0b3IgLSBjYW4ndCBvcHRpbWl6ZSBmdXJ0aGVyXG4gICAgICAgIHJldHVybiBuZXcgVHJhaXRMZXNzU2VsZWN0b3Ioc2VsZWN0b3JUZXh0LCBkZWJ1Zyk7XG4gICAgICB9XG5cbiAgICAgIHZhciB4cGF0aFBhcnQgPSB0aGlzLmdldFhwYXRoUGFydCgpO1xuXG4gICAgICBpZiAodHlwZW9mIHhwYXRoUGFydCAhPT0gJ3VuZGVmaW5lZCcpIHtcbiAgICAgICAgcmV0dXJuIG5ldyBYcGF0aFNlbGVjdG9yKHNlbGVjdG9yVGV4dCwgeHBhdGhQYXJ0LCBkZWJ1Zyk7XG4gICAgICB9XG5cbiAgICAgIHZhciB1cHdhcmRQYXJ0ID0gdGhpcy5nZXRVcHdhcmRQYXJ0KCk7XG5cbiAgICAgIGlmICh0eXBlb2YgdXB3YXJkUGFydCAhPT0gJ3VuZGVmaW5lZCcpIHtcbiAgICAgICAgdmFyIG91dHB1dDtcbiAgICAgICAgdmFyIHVwd2FyZERlZXAgPSBwYXJzZUludCh1cHdhcmRQYXJ0LCAxMCk7IC8vIGlmIHVwd2FyZCBwYXJhbWV0ZXIgaXMgbm90IGEgbnVtYmVyLCB3ZSBjb25zaWRlciBpdCBhcyBhIHNlbGVjdG9yXG5cbiAgICAgICAgaWYgKE51bWJlci5pc05hTih1cHdhcmREZWVwKSkge1xuICAgICAgICAgIG91dHB1dCA9IG5ldyBVcHdhcmRTZWxlY3RvcihzZWxlY3RvclRleHQsIHVwd2FyZFBhcnQsIGRlYnVnKTtcbiAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAvLyB1cHdhcmQgd29ya3MgbGlrZSBudGgtYW5jZXN0b3JcbiAgICAgICAgICB2YXIgeHBhdGggPSB0aGlzLmNvbnZlcnROdGhBbmNlc3RvclRva2VuKHVwd2FyZERlZXApO1xuICAgICAgICAgIG91dHB1dCA9IG5ldyBYcGF0aFNlbGVjdG9yKHNlbGVjdG9yVGV4dCwgeHBhdGgsIGRlYnVnKTtcbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiBvdXRwdXQ7XG4gICAgICB9IC8vIGFyZ3VtZW50IG9mIHBzZXVkby1jbGFzcyByZW1vdmU7XG4gICAgICAvLyBpdCdzIGRlZmluZWQgb25seSBpZiByZW1vdmUgaXMgcGFyc2VkIGFzIGxhc3QgdG9rZW5cbiAgICAgIC8vIGFuZCBpdCdzIHZhbGlkIG9ubHkgaWYgcmVtb3ZlIGFyZyBpcyBlbXB0eSBzdHJpbmdcblxuXG4gICAgICB2YXIgcmVtb3ZlUGFydCA9IHRoaXMuZ2V0UmVtb3ZlUGFydCgpO1xuXG4gICAgICBpZiAodHlwZW9mIHJlbW92ZVBhcnQgIT09ICd1bmRlZmluZWQnKSB7XG4gICAgICAgIHZhciBoYXNWYWxpZFJlbW92ZVBhcnQgPSByZW1vdmVQYXJ0ID09PSAnJztcbiAgICAgICAgcmV0dXJuIG5ldyBSZW1vdmVTZWxlY3RvcihzZWxlY3RvclRleHQsIGhhc1ZhbGlkUmVtb3ZlUGFydCwgZGVidWcpO1xuICAgICAgfVxuXG4gICAgICB0b2tlbnMgPSB0b2tlbnNbMF07XG4gICAgICB2YXIgbCA9IHRva2Vucy5sZW5ndGg7XG4gICAgICB2YXIgbGFzdFJlbFRva2VuSW5kID0gdGhpcy5nZXRTcGxpdFBvaW50KCk7XG5cbiAgICAgIGlmICh0eXBlb2YgbGFzdFJlbFRva2VuSW5kID09PSAndW5kZWZpbmVkJykge1xuICAgICAgICB0cnkge1xuICAgICAgICAgIGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3Ioc2VsZWN0b3JUZXh0KTtcbiAgICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICAgIHJldHVybiBuZXcgVHJhaXRMZXNzU2VsZWN0b3Ioc2VsZWN0b3JUZXh0LCBkZWJ1Zyk7XG4gICAgICAgIH1cblxuICAgICAgICByZXR1cm4gbmV3IE5vdEFuRXh0ZW5kZWRTZWxlY3RvcihzZWxlY3RvclRleHQsIGRlYnVnKTtcbiAgICAgIH1cblxuICAgICAgdmFyIHNpbXBsZSA9ICcnO1xuICAgICAgdmFyIHJlbGF0aW9uID0gbnVsbDtcbiAgICAgIHZhciBjb21wbGV4ID0gJyc7XG4gICAgICB2YXIgaSA9IDA7XG5cbiAgICAgIGZvciAoOyBpIDwgbGFzdFJlbFRva2VuSW5kOyBpKyspIHtcbiAgICAgICAgLy8gYnVpbGQgc2ltcGxlIHBhcnRcbiAgICAgICAgc2ltcGxlICs9IHRva2Vuc1tpXS52YWx1ZTtcbiAgICAgIH1cblxuICAgICAgaWYgKGkgPiAwKSB7XG4gICAgICAgIC8vIGJ1aWxkIHJlbGF0aW9uIHBhcnRcbiAgICAgICAgcmVsYXRpb24gPSB0b2tlbnNbaSsrXS50eXBlO1xuICAgICAgfSAvLyBpIGlzIHBvaW50aW5nIHRvIHRoZSBzdGFydCBvZiBhIGNvbXBsZXggcGFydC5cblxuXG4gICAgICBmb3IgKDsgaSA8IGw7IGkrKykge1xuICAgICAgICBjb21wbGV4ICs9IHRva2Vuc1tpXS52YWx1ZTtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIGxhc3RSZWxUb2tlbkluZCA9PT0gLTEgPyBuZXcgVHJhaXRMZXNzU2VsZWN0b3Ioc2VsZWN0b3JUZXh0LCBkZWJ1ZykgOiBuZXcgU3BsaXR0ZWRTZWxlY3RvcihzZWxlY3RvclRleHQsIHNpbXBsZSwgcmVsYXRpb24sIGNvbXBsZXgsIGRlYnVnKTtcbiAgICB9LFxuXG4gICAgLyoqXG4gICAgICogQHByaXZhdGVcbiAgICAgKiBAcmV0dXJuIHtudW1iZXJ8dW5kZWZpbmVkfSBBbiBpbmRleCBvZiBhIHRva2VuIHRoYXQgaXMgc3BsaXQgcG9pbnQuXG4gICAgICogcmV0dXJucyB1bmRlZmluZWQgaWYgdGhlIHNlbGVjdG9yIGRvZXMgbm90IGNvbnRhaW4gYW55IGNvbXBsZXggdG9rZW5zXG4gICAgICogb3IgaXQgaXMgbm90IGVsaWdpYmxlIGZvciBzcGxpdHRpbmcuXG4gICAgICogT3RoZXJ3aXNlIHJldHVybnMgYW4gaW50ZWdlciBpbmRpY2F0aW5nIHRoZSBpbmRleCBvZiB0aGUgbGFzdCByZWxhdGlvbiB0b2tlbi5cbiAgICAgKi9cbiAgICBnZXRTcGxpdFBvaW50OiBmdW5jdGlvbiBnZXRTcGxpdFBvaW50KCkge1xuICAgICAgdmFyIHRva2VucyA9IHRoaXMudG9rZW5zWzBdOyAvLyBXZSBzcGxpdCBzZWxlY3RvciBvbmx5IHdoZW4gdGhlIGxhc3QgY29tcG91bmQgc2VsZWN0b3JcbiAgICAgIC8vIGlzIHRoZSBvbmx5IGV4dGVuZGVkIHNlbGVjdG9yLlxuXG4gICAgICB2YXIgbGF0ZXN0UmVsYXRpb25Ub2tlbkluZGV4ID0gLTE7XG4gICAgICB2YXIgaGF2ZU1ldENvbXBsZXhUb2tlbiA9IGZhbHNlO1xuXG4gICAgICBmb3IgKHZhciBpID0gMCwgbCA9IHRva2Vucy5sZW5ndGg7IGkgPCBsOyBpKyspIHtcbiAgICAgICAgdmFyIHRva2VuID0gdG9rZW5zW2ldO1xuXG4gICAgICAgIGlmIChpc1JlbGF0aW9uVG9rZW4odG9rZW4pKSB7XG4gICAgICAgICAgaWYgKGhhdmVNZXRDb21wbGV4VG9rZW4pIHtcbiAgICAgICAgICAgIHJldHVybjtcbiAgICAgICAgICB9XG5cbiAgICAgICAgICBsYXRlc3RSZWxhdGlvblRva2VuSW5kZXggPSBpO1xuICAgICAgICB9IGVsc2UgaWYgKCFpc1NpbXBsZVRva2VuKHRva2VuKSkge1xuICAgICAgICAgIGhhdmVNZXRDb21wbGV4VG9rZW4gPSB0cnVlO1xuICAgICAgICB9XG4gICAgICB9XG5cbiAgICAgIGlmICghaGF2ZU1ldENvbXBsZXhUb2tlbikge1xuICAgICAgICByZXR1cm47XG4gICAgICB9XG5cbiAgICAgIHJldHVybiBsYXRlc3RSZWxhdGlvblRva2VuSW5kZXg7XG4gICAgfSxcblxuICAgIC8qKlxuICAgICAqIEBwcml2YXRlXG4gICAgICogQHJldHVybiB7c3RyaW5nfHVuZGVmaW5lZH0geHBhdGggc2VsZWN0b3IgcGFydCBpZiBleGlzdHNcbiAgICAgKiByZXR1cm5zIHVuZGVmaW5lZCBpZiB0aGUgc2VsZWN0b3IgZG9lcyBub3QgY29udGFpbiB4cGF0aCB0b2tlbnNcbiAgICAgKi9cbiAgICBnZXRYcGF0aFBhcnQ6IGZ1bmN0aW9uIGdldFhwYXRoUGFydCgpIHtcbiAgICAgIHZhciB0b2tlbnMgPSB0aGlzLnRva2Vuc1swXTtcblxuICAgICAgZm9yICh2YXIgaSA9IDAsIHRva2Vuc0xlbmd0aCA9IHRva2Vucy5sZW5ndGg7IGkgPCB0b2tlbnNMZW5ndGg7IGkrKykge1xuICAgICAgICB2YXIgdG9rZW4gPSB0b2tlbnNbaV07XG5cbiAgICAgICAgaWYgKHRva2VuLnR5cGUgPT09ICdQU0VVRE8nKSB7XG4gICAgICAgICAgdmFyIG1hdGNoZXMgPSB0b2tlbi5tYXRjaGVzO1xuXG4gICAgICAgICAgaWYgKG1hdGNoZXMgJiYgbWF0Y2hlcy5sZW5ndGggPiAxKSB7XG4gICAgICAgICAgICBpZiAobWF0Y2hlc1swXSA9PT0gJ3hwYXRoJykge1xuICAgICAgICAgICAgICBpZiAodGhpcy5pc0xhc3RUb2tlbih0b2tlbnMsIGkpKSB7XG4gICAgICAgICAgICAgICAgdGhyb3cgbmV3IEVycm9yKCdJbnZhbGlkIHBzZXVkbzogXFwnOnhwYXRoXFwnIHNob3VsZCBiZSBhdCB0aGUgZW5kIG9mIHRoZSBzZWxlY3RvcicpO1xuICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgcmV0dXJuIG1hdGNoZXNbMV07XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIGlmIChtYXRjaGVzWzBdID09PSAnbnRoLWFuY2VzdG9yJykge1xuICAgICAgICAgICAgICBpZiAodGhpcy5pc0xhc3RUb2tlbih0b2tlbnMsIGkpKSB7XG4gICAgICAgICAgICAgICAgdGhyb3cgbmV3IEVycm9yKCdJbnZhbGlkIHBzZXVkbzogXFwnOm50aC1hbmNlc3RvclxcJyBzaG91bGQgYmUgYXQgdGhlIGVuZCBvZiB0aGUgc2VsZWN0b3InKTtcbiAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgIHZhciBkZWVwID0gbWF0Y2hlc1sxXTtcblxuICAgICAgICAgICAgICBpZiAoZGVlcCA+IDAgJiYgZGVlcCA8IDI1Nikge1xuICAgICAgICAgICAgICAgIHJldHVybiB0aGlzLmNvbnZlcnROdGhBbmNlc3RvclRva2VuKGRlZXApO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfVxuICAgICAgICB9XG4gICAgICB9XG4gICAgfSxcblxuICAgIC8qKlxuICAgICAqIGNvbnZlcnRzIG50aC1hbmNlc3Rvci91cHdhcmQgZGVlcCB2YWx1ZSB0byB4cGF0aCBlcXVpdmFsZW50XG4gICAgICogQHBhcmFtIHtudW1iZXJ9IGRlZXBcbiAgICAgKiBAcmV0dXJuIHtzdHJpbmd9XG4gICAgICovXG4gICAgY29udmVydE50aEFuY2VzdG9yVG9rZW46IGZ1bmN0aW9uIGNvbnZlcnROdGhBbmNlc3RvclRva2VuKGRlZXApIHtcbiAgICAgIHZhciByZXN1bHQgPSAnLi4nO1xuXG4gICAgICB3aGlsZSAoZGVlcCA+IDEpIHtcbiAgICAgICAgcmVzdWx0ICs9ICcvLi4nO1xuICAgICAgICBkZWVwLS07XG4gICAgICB9XG5cbiAgICAgIHJldHVybiByZXN1bHQ7XG4gICAgfSxcblxuICAgIC8qKlxuICAgICAqIENoZWNrcyBpZiB0aGUgdG9rZW4gaXMgbGFzdCxcbiAgICAgKiBleGNlcHQgb2YgcmVtb3ZlIHBzZXVkby1jbGFzc1xuICAgICAqIEBwYXJhbSB7QXJyYXl9IHRva2Vuc1xuICAgICAqIEBwYXJhbSB7bnVtYmVyfSBpIGluZGV4IG9mIHRva2VuXG4gICAgICogQHJldHVybnMge2Jvb2xlYW59XG4gICAgICovXG4gICAgaXNMYXN0VG9rZW46IGZ1bmN0aW9uIGlzTGFzdFRva2VuKHRva2VucywgaSkge1xuICAgICAgLy8gY2hlY2sgaWQgdGhlIG5leHQgcGFyc2VkIHRva2VuIGlzIHJlbW92ZSBwc2V1ZG9cbiAgICAgIHZhciBpc05leHRSZW1vdmVUb2tlbiA9IHRva2Vuc1tpICsgMV0gJiYgdG9rZW5zW2kgKyAxXS50eXBlID09PSAnUFNFVURPJyAmJiB0b2tlbnNbaSArIDFdLm1hdGNoZXMgJiYgdG9rZW5zW2kgKyAxXS5tYXRjaGVzWzBdID09PSAncmVtb3ZlJzsgLy8gY2hlY2sgaWYgdGhlIHRva2VuIGlzIGxhc3RcbiAgICAgIC8vIGFuZCBpZiBpdCBpcyBub3QgY2hlY2sgaWYgaXQgaXMgcmVtb3ZlIG9uZVxuICAgICAgLy8gd2hpY2ggc2hvdWxkIGJlIHNraXBwZWRcblxuICAgICAgcmV0dXJuIGkgKyAxICE9PSB0b2tlbnMubGVuZ3RoICYmICFpc05leHRSZW1vdmVUb2tlbjtcbiAgICB9LFxuXG4gICAgLyoqXG4gICAgICogQHByaXZhdGVcbiAgICAgKiBAcmV0dXJuIHtzdHJpbmd8dW5kZWZpbmVkfSB1cHdhcmQgcGFyYW1ldGVyXG4gICAgICogb3IgdW5kZWZpbmVkIGlmIHRoZSBpbnB1dCBkb2VzIG5vdCBjb250YWluIHVwd2FyZCB0b2tlbnNcbiAgICAgKi9cbiAgICBnZXRVcHdhcmRQYXJ0OiBmdW5jdGlvbiBnZXRVcHdhcmRQYXJ0KCkge1xuICAgICAgdmFyIHRva2VucyA9IHRoaXMudG9rZW5zWzBdO1xuXG4gICAgICBmb3IgKHZhciBpID0gMCwgdG9rZW5zTGVuZ3RoID0gdG9rZW5zLmxlbmd0aDsgaSA8IHRva2Vuc0xlbmd0aDsgaSsrKSB7XG4gICAgICAgIHZhciB0b2tlbiA9IHRva2Vuc1tpXTtcblxuICAgICAgICBpZiAodG9rZW4udHlwZSA9PT0gJ1BTRVVETycpIHtcbiAgICAgICAgICB2YXIgbWF0Y2hlcyA9IHRva2VuLm1hdGNoZXM7XG5cbiAgICAgICAgICBpZiAobWF0Y2hlcyAmJiBtYXRjaGVzLmxlbmd0aCA+IDEpIHtcbiAgICAgICAgICAgIGlmIChtYXRjaGVzWzBdID09PSAndXB3YXJkJykge1xuICAgICAgICAgICAgICBpZiAodGhpcy5pc0xhc3RUb2tlbih0b2tlbnMsIGkpKSB7XG4gICAgICAgICAgICAgICAgdGhyb3cgbmV3IEVycm9yKCdJbnZhbGlkIHBzZXVkbzogXFwnOnVwd2FyZFxcJyBzaG91bGQgYmUgYXQgdGhlIGVuZCBvZiB0aGUgc2VsZWN0b3InKTtcbiAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgIHJldHVybiBtYXRjaGVzWzFdO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgfVxuICAgIH0sXG5cbiAgICAvKipcbiAgICAgKiBAcHJpdmF0ZVxuICAgICAqIEByZXR1cm4ge3N0cmluZ3x1bmRlZmluZWR9IHJlbW92ZSBwYXJhbWV0ZXJcbiAgICAgKiBvciB1bmRlZmluZWQgaWYgdGhlIGlucHV0IGRvZXMgbm90IGNvbnRhaW4gcmVtb3ZlIHRva2Vuc1xuICAgICAqL1xuICAgIGdldFJlbW92ZVBhcnQ6IGZ1bmN0aW9uIGdldFJlbW92ZVBhcnQoKSB7XG4gICAgICB2YXIgdG9rZW5zID0gdGhpcy50b2tlbnNbMF07XG5cbiAgICAgIGZvciAodmFyIGkgPSAwLCB0b2tlbnNMZW5ndGggPSB0b2tlbnMubGVuZ3RoOyBpIDwgdG9rZW5zTGVuZ3RoOyBpKyspIHtcbiAgICAgICAgdmFyIHRva2VuID0gdG9rZW5zW2ldO1xuXG4gICAgICAgIGlmICh0b2tlbi50eXBlID09PSAnUFNFVURPJykge1xuICAgICAgICAgIHZhciBtYXRjaGVzID0gdG9rZW4ubWF0Y2hlcztcblxuICAgICAgICAgIGlmIChtYXRjaGVzICYmIG1hdGNoZXMubGVuZ3RoID4gMSkge1xuICAgICAgICAgICAgaWYgKG1hdGNoZXNbMF0gPT09ICdyZW1vdmUnKSB7XG4gICAgICAgICAgICAgIGlmIChpICsgMSAhPT0gdG9rZW5zTGVuZ3RoKSB7XG4gICAgICAgICAgICAgICAgdGhyb3cgbmV3IEVycm9yKCdJbnZhbGlkIHBzZXVkbzogXFwnOnJlbW92ZVxcJyBzaG91bGQgYmUgYXQgdGhlIGVuZCBvZiB0aGUgc2VsZWN0b3InKTtcbiAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgIHJldHVybiBtYXRjaGVzWzFdO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgfVxuICAgIH1cbiAgfTtcbiAgdmFyIGdsb2JhbERlYnVnZ2luZ0ZsYWcgPSBmYWxzZTtcblxuICBmdW5jdGlvbiBpc0RlYnVnZ2luZygpIHtcbiAgICByZXR1cm4gZ2xvYmFsRGVidWdnaW5nRmxhZyB8fCB0aGlzLmRlYnVnO1xuICB9XG4gIC8qKlxuICAgKiBUaGlzIGNsYXNzIHJlcHJlc2VudHMgYSBzZWxlY3RvciB3aGljaCBpcyBub3QgYW4gZXh0ZW5kZWQgc2VsZWN0b3IuXG4gICAqIEBwYXJhbSB7c3RyaW5nfSBzZWxlY3RvclRleHRcbiAgICogQHBhcmFtIHtib29sZWFuPX0gZGVidWdcbiAgICogQGZpbmFsXG4gICAqL1xuXG5cbiAgZnVuY3Rpb24gTm90QW5FeHRlbmRlZFNlbGVjdG9yKHNlbGVjdG9yVGV4dCwgZGVidWcpIHtcbiAgICB0aGlzLnNlbGVjdG9yVGV4dCA9IHNlbGVjdG9yVGV4dDtcbiAgICB0aGlzLmRlYnVnID0gZGVidWc7XG4gIH1cblxuICBOb3RBbkV4dGVuZGVkU2VsZWN0b3IucHJvdG90eXBlID0ge1xuICAgIHF1ZXJ5U2VsZWN0b3JBbGw6IGZ1bmN0aW9uIHF1ZXJ5U2VsZWN0b3JBbGwoKSB7XG4gICAgICByZXR1cm4gZG9jdW1lbnQucXVlcnlTZWxlY3RvckFsbCh0aGlzLnNlbGVjdG9yVGV4dCk7XG4gICAgfSxcbiAgICBtYXRjaGVzOiBmdW5jdGlvbiBtYXRjaGVzKGVsZW1lbnQpIHtcbiAgICAgIHJldHVybiBlbGVtZW50W3V0aWxzLm1hdGNoZXNQcm9wZXJ0eU5hbWVdKHRoaXMuc2VsZWN0b3JUZXh0KTtcbiAgICB9LFxuICAgIGlzRGVidWdnaW5nOiBpc0RlYnVnZ2luZ1xuICB9O1xuICAvKipcbiAgICogQSB0cmFpdC1sZXNzIGV4dGVuZGVkIHNlbGVjdG9yIGNsYXNzLlxuICAgKiBAcGFyYW0ge3N0cmluZ30gc2VsZWN0b3JUZXh0XG4gICAqIEBwYXJhbSB7Ym9vbGVhbj19IGRlYnVnXG4gICAqIEBjb25zdHJ1Y3RvclxuICAgKi9cblxuICBmdW5jdGlvbiBUcmFpdExlc3NTZWxlY3RvcihzZWxlY3RvclRleHQsIGRlYnVnKSB7XG4gICAgdGhpcy5zZWxlY3RvclRleHQgPSBzZWxlY3RvclRleHQ7XG4gICAgdGhpcy5kZWJ1ZyA9IGRlYnVnO1xuICAgIFNpenpsZS5jb21waWxlKHNlbGVjdG9yVGV4dCk7XG4gIH1cblxuICBUcmFpdExlc3NTZWxlY3Rvci5wcm90b3R5cGUgPSB7XG4gICAgcXVlcnlTZWxlY3RvckFsbDogZnVuY3Rpb24gcXVlcnlTZWxlY3RvckFsbCgpIHtcbiAgICAgIHJldHVybiBTaXp6bGUodGhpcy5zZWxlY3RvclRleHQpO1xuICAgIH0sXG5cbiAgICAvKiogQGZpbmFsICovXG4gICAgbWF0Y2hlczogZnVuY3Rpb24gbWF0Y2hlcyhlbGVtZW50KSB7XG4gICAgICByZXR1cm4gU2l6emxlLm1hdGNoZXNTZWxlY3RvcihlbGVtZW50LCB0aGlzLnNlbGVjdG9yVGV4dCk7XG4gICAgfSxcblxuICAgIC8qKiBAZmluYWwgKi9cbiAgICBpc0RlYnVnZ2luZzogaXNEZWJ1Z2dpbmdcbiAgfTtcbiAgLyoqXG4gICAqIFBhcmVudGFsIGNsYXNzIGZvciBzdWNoIHBzZXVkby1jbGFzc2VzIGFzIHhwYXRoLCB1cHdhcmQsIHJlbW92ZVxuICAgKiB3aGljaCBhcmUgbGltaXRlZCB0byBiZSB0aGUgbGFzdCBvbmUgdG9rZW4gaW4gc2VsZWN0b3JcbiAgICpcbiAgICogQHBhcmFtIHtzdHJpbmd9IHNlbGVjdG9yVGV4dFxuICAgKiBAcGFyYW0ge3N0cmluZ30gcHNldWRvQ2xhc3NBcmcgcHNldWRvLWNsYXNzIGFyZ1xuICAgKiBAcGFyYW0ge2Jvb2xlYW49fSBkZWJ1Z1xuICAgKiBAY29uc3RydWN0b3JcbiAgICovXG5cbiAgZnVuY3Rpb24gQmFzZUxhc3RBcmd1bWVudFNlbGVjdG9yKHNlbGVjdG9yVGV4dCwgcHNldWRvQ2xhc3NBcmcsIGRlYnVnKSB7XG4gICAgdGhpcy5zZWxlY3RvclRleHQgPSBzZWxlY3RvclRleHQ7XG4gICAgdGhpcy5wc2V1ZG9DbGFzc0FyZyA9IHBzZXVkb0NsYXNzQXJnO1xuICAgIHRoaXMuZGVidWcgPSBkZWJ1ZztcbiAgICBTaXp6bGUuY29tcGlsZSh0aGlzLnNlbGVjdG9yVGV4dCk7XG4gIH1cblxuICBCYXNlTGFzdEFyZ3VtZW50U2VsZWN0b3IucHJvdG90eXBlID0ge1xuICAgIHF1ZXJ5U2VsZWN0b3JBbGw6IGZ1bmN0aW9uIHF1ZXJ5U2VsZWN0b3JBbGwoKSB7XG4gICAgICB2YXIgX3RoaXMgPSB0aGlzO1xuXG4gICAgICB2YXIgcmVzdWx0Tm9kZXMgPSBbXTtcbiAgICAgIHZhciBzaW1wbGVOb2RlcztcblxuICAgICAgaWYgKHRoaXMuc2VsZWN0b3JUZXh0KSB7XG4gICAgICAgIHNpbXBsZU5vZGVzID0gU2l6emxlKHRoaXMuc2VsZWN0b3JUZXh0KTtcblxuICAgICAgICBpZiAoIXNpbXBsZU5vZGVzIHx8ICFzaW1wbGVOb2Rlcy5sZW5ndGgpIHtcbiAgICAgICAgICByZXR1cm4gcmVzdWx0Tm9kZXM7XG4gICAgICAgIH1cbiAgICAgIH0gZWxzZSB7XG4gICAgICAgIHNpbXBsZU5vZGVzID0gW2RvY3VtZW50XTtcbiAgICAgIH1cblxuICAgICAgc2ltcGxlTm9kZXMuZm9yRWFjaChmdW5jdGlvbiAobm9kZSkge1xuICAgICAgICBfdGhpcy5zZWFyY2hSZXN1bHROb2Rlcyhub2RlLCBfdGhpcy5wc2V1ZG9DbGFzc0FyZywgcmVzdWx0Tm9kZXMpO1xuICAgICAgfSk7XG4gICAgICByZXR1cm4gU2l6emxlLnVuaXF1ZVNvcnQocmVzdWx0Tm9kZXMpO1xuICAgIH0sXG5cbiAgICAvKiogQGZpbmFsICovXG4gICAgbWF0Y2hlczogZnVuY3Rpb24gbWF0Y2hlcyhlbGVtZW50KSB7XG4gICAgICB2YXIgcmVzdWx0cyA9IHRoaXMucXVlcnlTZWxlY3RvckFsbCgpO1xuICAgICAgcmV0dXJuIHJlc3VsdHMuaW5kZXhPZihlbGVtZW50KSA+IC0xO1xuICAgIH0sXG5cbiAgICAvKiogQGZpbmFsICovXG4gICAgaXNEZWJ1Z2dpbmc6IGlzRGVidWdnaW5nLFxuXG4gICAgLyoqXG4gICAgICogUHJpbWl0aXZlIG1ldGhvZCB0aGF0IHJldHVybnMgYWxsIG5vZGVzIGlmIHBzZXVkby1jbGFzcyBhcmcgaXMgZGVmaW5lZC5cbiAgICAgKiBUaGF0IGxvZ2ljIHdvcmtzIGZvciByZW1vdmUgcHNldWRvLWNsYXNzLFxuICAgICAqIGJ1dCBmb3Igb3RoZXJzIGl0IHNob3VsZCBiZSBvdmVycmlkZGVuLlxuICAgICAqIEBwYXJhbSB7T2JqZWN0fSBub2RlIGNvbnRleHQgZWxlbWVudFxuICAgICAqIEBwYXJhbSB7c3RyaW5nfSBwc2V1ZG9DbGFzc0FyZyBwc2V1ZG8tY2xhc3MgYXJndW1lbnRcbiAgICAgKiBAcGFyYW0ge0FycmF5fSByZXN1bHRcbiAgICAgKi9cbiAgICBzZWFyY2hSZXN1bHROb2RlczogZnVuY3Rpb24gc2VhcmNoUmVzdWx0Tm9kZXMobm9kZSwgcHNldWRvQ2xhc3NBcmcsIHJlc3VsdCkge1xuICAgICAgaWYgKHBzZXVkb0NsYXNzQXJnKSB7XG4gICAgICAgIHJlc3VsdC5wdXNoKG5vZGUpO1xuICAgICAgfVxuICAgIH1cbiAgfTtcbiAgLyoqXG4gICAqIFhwYXRoIHNlbGVjdG9yIGNsYXNzXG4gICAqIExpbWl0ZWQgdG8gc3VwcG9ydCAneHBhdGgnIHRvIGJlIG9ubHkgdGhlIGxhc3Qgb25lIHRva2VuIGluIHNlbGVjdG9yXG4gICAqIEBwYXJhbSB7c3RyaW5nfSBzZWxlY3RvclRleHRcbiAgICogQHBhcmFtIHtzdHJpbmd9IHhwYXRoIHZhbHVlXG4gICAqIEBwYXJhbSB7Ym9vbGVhbj19IGRlYnVnXG4gICAqIEBjb25zdHJ1Y3RvclxuICAgKiBAYXVnbWVudHMgQmFzZUxhc3RBcmd1bWVudFNlbGVjdG9yXG4gICAqL1xuXG4gIGZ1bmN0aW9uIFhwYXRoU2VsZWN0b3Ioc2VsZWN0b3JUZXh0LCB4cGF0aCwgZGVidWcpIHtcbiAgICB2YXIgTk9fU0VMRUNUT1JfTUFSS0VSID0gJzp4cGF0aCgvLyc7XG4gICAgdmFyIEJPRFlfU0VMRUNUT1JfUkVQTEFDRVIgPSAnYm9keTp4cGF0aCgvLyc7XG4gICAgdmFyIG1vZGlmaWVkU2VsZWN0b3JUZXh0ID0gc2VsZWN0b3JUZXh0OyAvLyBOb3JtYWxseSwgYSBwc2V1ZG8tY2xhc3MgaXMgYXBwbGllZCB0byBub2RlcyBzZWxlY3RlZCBieSBhIHNlbGVjdG9yIC0tIHNlbGVjdG9yOnhwYXRoKC4uLikuXG4gICAgLy8gSG93ZXZlciwgOnhwYXRoIGlzIHNwZWNpYWwgYXMgdGhlIHNlbGVjdG9yIGNhbiBiZSBvbW1pdGVkLlxuICAgIC8vIEZvciBhbnkgb3RoZXIgcHNldWRvLWNsYXNzIHRoYXQgd291bGQgbWVhbiBcImFwcGx5IHRvIEFMTCBET00gbm9kZXNcIixcbiAgICAvLyBidXQgaW4gY2FzZSBvZiA6eHBhdGggaXQganVzdCBtZWFucyBcImFwcGx5IG1lIHRvIHRoZSBkb2N1bWVudFwiLlxuXG4gICAgaWYgKHV0aWxzLnN0YXJ0c1dpdGgoc2VsZWN0b3JUZXh0LCBOT19TRUxFQ1RPUl9NQVJLRVIpKSB7XG4gICAgICBtb2RpZmllZFNlbGVjdG9yVGV4dCA9IHNlbGVjdG9yVGV4dC5yZXBsYWNlKE5PX1NFTEVDVE9SX01BUktFUiwgQk9EWV9TRUxFQ1RPUl9SRVBMQUNFUik7XG4gICAgfVxuXG4gICAgQmFzZUxhc3RBcmd1bWVudFNlbGVjdG9yLmNhbGwodGhpcywgbW9kaWZpZWRTZWxlY3RvclRleHQsIHhwYXRoLCBkZWJ1Zyk7XG4gIH1cblxuICBYcGF0aFNlbGVjdG9yLnByb3RvdHlwZSA9IE9iamVjdC5jcmVhdGUoQmFzZUxhc3RBcmd1bWVudFNlbGVjdG9yLnByb3RvdHlwZSk7XG4gIFhwYXRoU2VsZWN0b3IucHJvdG90eXBlLmNvbnN0cnVjdG9yID0gWHBhdGhTZWxlY3RvcjtcbiAgLyoqXG4gICAqIEFwcGxpZXMgeHBhdGggcHNldWRvLWNsYXNzIHRvIHByb3ZpZGVkIGNvbnRleHQgbm9kZVxuICAgKiBAcGFyYW0ge09iamVjdH0gbm9kZSBjb250ZXh0IGVsZW1lbnRcbiAgICogQHBhcmFtIHtzdHJpbmd9IHBzZXVkb0NsYXNzQXJnIHhwYXRoXG4gICAqIEBwYXJhbSB7QXJyYXl9IHJlc3VsdFxuICAgKiBAb3ZlcnJpZGVcbiAgICovXG5cbiAgWHBhdGhTZWxlY3Rvci5wcm90b3R5cGUuc2VhcmNoUmVzdWx0Tm9kZXMgPSBmdW5jdGlvbiAobm9kZSwgcHNldWRvQ2xhc3NBcmcsIHJlc3VsdCkge1xuICAgIHZhciB4cGF0aFJlc3VsdCA9IGRvY3VtZW50LmV2YWx1YXRlKHBzZXVkb0NsYXNzQXJnLCBub2RlLCBudWxsLCBYUGF0aFJlc3VsdC5VTk9SREVSRURfTk9ERV9JVEVSQVRPUl9UWVBFLCBudWxsKTtcbiAgICB2YXIgaU5vZGU7IC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBuby1jb25kLWFzc2lnblxuXG4gICAgd2hpbGUgKGlOb2RlID0geHBhdGhSZXN1bHQuaXRlcmF0ZU5leHQoKSkge1xuICAgICAgcmVzdWx0LnB1c2goaU5vZGUpO1xuICAgIH1cbiAgfTtcbiAgLyoqXG4gICAqIFVwd2FyZCBzZWxlY3RvciBjbGFzc1xuICAgKiBMaW1pdGVkIHRvIHN1cHBvcnQgJ3Vwd2FyZCcgdG8gYmUgb25seSB0aGUgbGFzdCBvbmUgdG9rZW4gaW4gc2VsZWN0b3JcbiAgICogQHBhcmFtIHtzdHJpbmd9IHNlbGVjdG9yVGV4dFxuICAgKiBAcGFyYW0ge3N0cmluZ30gdXB3YXJkU2VsZWN0b3IgdmFsdWVcbiAgICogQHBhcmFtIHtib29sZWFuPX0gZGVidWdcbiAgICogQGNvbnN0cnVjdG9yXG4gICAqIEBhdWdtZW50cyBCYXNlTGFzdEFyZ3VtZW50U2VsZWN0b3JcbiAgICovXG5cblxuICBmdW5jdGlvbiBVcHdhcmRTZWxlY3RvcihzZWxlY3RvclRleHQsIHVwd2FyZFNlbGVjdG9yLCBkZWJ1Zykge1xuICAgIEJhc2VMYXN0QXJndW1lbnRTZWxlY3Rvci5jYWxsKHRoaXMsIHNlbGVjdG9yVGV4dCwgdXB3YXJkU2VsZWN0b3IsIGRlYnVnKTtcbiAgfVxuXG4gIFVwd2FyZFNlbGVjdG9yLnByb3RvdHlwZSA9IE9iamVjdC5jcmVhdGUoQmFzZUxhc3RBcmd1bWVudFNlbGVjdG9yLnByb3RvdHlwZSk7XG4gIFVwd2FyZFNlbGVjdG9yLnByb3RvdHlwZS5jb25zdHJ1Y3RvciA9IFVwd2FyZFNlbGVjdG9yO1xuICAvKipcbiAgICogQXBwbGllcyB1cHdhcmQgcHNldWRvLWNsYXNzIHRvIHByb3ZpZGVkIGNvbnRleHQgbm9kZVxuICAgKiBAcGFyYW0ge09iamVjdH0gbm9kZSBjb250ZXh0IGVsZW1lbnRcbiAgICogQHBhcmFtIHtzdHJpbmd9IHVwd2FyZFNlbGVjdG9yIHVwd2FyZCBzZWxlY3RvclxuICAgKiBAcGFyYW0ge0FycmF5fSByZXN1bHRcbiAgICogQG92ZXJyaWRlXG4gICAqL1xuXG4gIFVwd2FyZFNlbGVjdG9yLnByb3RvdHlwZS5zZWFyY2hSZXN1bHROb2RlcyA9IGZ1bmN0aW9uIChub2RlLCB1cHdhcmRTZWxlY3RvciwgcmVzdWx0KSB7XG4gICAgaWYgKHVwd2FyZFNlbGVjdG9yICE9PSAnJykge1xuICAgICAgdmFyIHBhcmVudCA9IG5vZGUucGFyZW50RWxlbWVudDtcblxuICAgICAgaWYgKHBhcmVudCA9PT0gbnVsbCkge1xuICAgICAgICByZXR1cm47XG4gICAgICB9XG5cbiAgICAgIG5vZGUgPSBwYXJlbnQuY2xvc2VzdCh1cHdhcmRTZWxlY3Rvcik7XG5cbiAgICAgIGlmIChub2RlID09PSBudWxsKSB7XG4gICAgICAgIHJldHVybjtcbiAgICAgIH1cbiAgICB9XG5cbiAgICByZXN1bHQucHVzaChub2RlKTtcbiAgfTtcbiAgLyoqXG4gICAqIFJlbW92ZSBzZWxlY3RvciBjbGFzc1xuICAgKiBMaW1pdGVkIHRvIHN1cHBvcnQgJ3JlbW92ZScgdG8gYmUgb25seSB0aGUgbGFzdCBvbmUgdG9rZW4gaW4gc2VsZWN0b3JcbiAgICogQHBhcmFtIHtzdHJpbmd9IHNlbGVjdG9yVGV4dFxuICAgKiBAcGFyYW0ge2Jvb2xlYW59IGhhc1ZhbGlkUmVtb3ZlUGFydFxuICAgKiBAcGFyYW0ge2Jvb2xlYW49fSBkZWJ1Z1xuICAgKiBAY29uc3RydWN0b3JcbiAgICogQGF1Z21lbnRzIEJhc2VMYXN0QXJndW1lbnRTZWxlY3RvclxuICAgKi9cblxuXG4gIGZ1bmN0aW9uIFJlbW92ZVNlbGVjdG9yKHNlbGVjdG9yVGV4dCwgaGFzVmFsaWRSZW1vdmVQYXJ0LCBkZWJ1Zykge1xuICAgIHZhciBSRU1PVkVfUFNFVURPX01BUktFUiA9ICc6cmVtb3ZlKCknO1xuICAgIHZhciByZW1vdmVNYXJrZXJJbmRleCA9IHNlbGVjdG9yVGV4dC5pbmRleE9mKFJFTU9WRV9QU0VVRE9fTUFSS0VSKTsgLy8gZGVsZXRpbmcgcmVtb3ZlIHBhcnQgb2YgcnVsZSBpbnN0ZWFkIG9mIHdoaWNoXG4gICAgLy8gcHNldWRvLXByb3BlcnR5IHByb3BlcnR5ICdyZW1vdmUnIHdpbGwgYmUgYWRkZWQgYnkgRXh0ZW5kZWRDc3NQYXJzZXJcblxuICAgIHZhciBtb2RpZmllZFNlbGVjdG9yVGV4dCA9IHNlbGVjdG9yVGV4dC5zbGljZSgwLCByZW1vdmVNYXJrZXJJbmRleCk7XG4gICAgQmFzZUxhc3RBcmd1bWVudFNlbGVjdG9yLmNhbGwodGhpcywgbW9kaWZpZWRTZWxlY3RvclRleHQsIGhhc1ZhbGlkUmVtb3ZlUGFydCwgZGVidWcpOyAvLyBtYXJrIGV4dGVuZGVkU2VsZWN0b3IgYXMgUmVtb3ZlIG9uZSBmb3IgRXh0ZW5kZWRDc3NQYXJzZXJcblxuICAgIHRoaXMuaXNSZW1vdmVTZWxlY3RvciA9IHRydWU7XG4gIH1cblxuICBSZW1vdmVTZWxlY3Rvci5wcm90b3R5cGUgPSBPYmplY3QuY3JlYXRlKEJhc2VMYXN0QXJndW1lbnRTZWxlY3Rvci5wcm90b3R5cGUpO1xuICBSZW1vdmVTZWxlY3Rvci5wcm90b3R5cGUuY29uc3RydWN0b3IgPSBSZW1vdmVTZWxlY3RvcjtcbiAgLyoqXG4gICAqIEEgc3BsaXR0ZWQgZXh0ZW5kZWQgc2VsZWN0b3IgY2xhc3MuXG4gICAqXG4gICAqICNjb250YWluZXIgI2ZlZWRJdGVtOmhhcyguYWRzKVxuICAgKiArLS0tLS0tLS0rICAgICAgICAgICAgICAgICAgICAgc2ltcGxlXG4gICAqICAgICAgICAgICArICAgICAgICAgICAgICAgICAgICByZWxhdGlvblxuICAgKiAgICAgICAgICAgICstLS0tLS0tLS0tLS0tLS0tLSsgY29tcGxleFxuICAgKiBXZSBzcGxpdCBzZWxlY3RvciBvbmx5IHdoZW4gdGhlIGxhc3Qgc2VsZWN0b3IgaXMgY29tcGxleFxuICAgKiBAcGFyYW0ge3N0cmluZ30gc2VsZWN0b3JUZXh0XG4gICAqIEBwYXJhbSB7c3RyaW5nfSBzaW1wbGVcbiAgICogQHBhcmFtIHtzdHJpbmd9IHJlbGF0aW9uXG4gICAqIEBwYXJhbSB7c3RyaW5nfSBjb21wbGV4XG4gICAqIEBwYXJhbSB7Ym9vbGVhbj19IGRlYnVnXG4gICAqIEBjb25zdHJ1Y3RvclxuICAgKiBAZXh0ZW5kcyBUcmFpdExlc3NTZWxlY3RvclxuICAgKi9cblxuICBmdW5jdGlvbiBTcGxpdHRlZFNlbGVjdG9yKHNlbGVjdG9yVGV4dCwgc2ltcGxlLCByZWxhdGlvbiwgY29tcGxleCwgZGVidWcpIHtcbiAgICBUcmFpdExlc3NTZWxlY3Rvci5jYWxsKHRoaXMsIHNlbGVjdG9yVGV4dCwgZGVidWcpO1xuICAgIHRoaXMuc2ltcGxlID0gc2ltcGxlO1xuICAgIHRoaXMucmVsYXRpb24gPSByZWxhdGlvbjtcbiAgICB0aGlzLmNvbXBsZXggPSBjb21wbGV4O1xuICAgIFNpenpsZS5jb21waWxlKGNvbXBsZXgpO1xuICB9XG5cbiAgU3BsaXR0ZWRTZWxlY3Rvci5wcm90b3R5cGUgPSBPYmplY3QuY3JlYXRlKFRyYWl0TGVzc1NlbGVjdG9yLnByb3RvdHlwZSk7XG4gIFNwbGl0dGVkU2VsZWN0b3IucHJvdG90eXBlLmNvbnN0cnVjdG9yID0gU3BsaXR0ZWRTZWxlY3RvcjtcbiAgLyoqIEBvdmVycmlkZSAqL1xuXG4gIFNwbGl0dGVkU2VsZWN0b3IucHJvdG90eXBlLnF1ZXJ5U2VsZWN0b3JBbGwgPSBmdW5jdGlvbiAoKSB7XG4gICAgdmFyIF90aGlzMiA9IHRoaXM7XG5cbiAgICB2YXIgcmVzdWx0Tm9kZXMgPSBbXTtcbiAgICB2YXIgc2ltcGxlTm9kZXM7XG4gICAgdmFyIHNpbXBsZSA9IHRoaXMuc2ltcGxlO1xuICAgIHZhciByZWxhdGlvbjtcblxuICAgIGlmIChzaW1wbGUpIHtcbiAgICAgIC8vIEZpcnN0IHdlIHVzZSBzaW1wbGUgc2VsZWN0b3IgdG8gbmFycm93IG91ciBzZWFyY2hcbiAgICAgIHNpbXBsZU5vZGVzID0gZG9jdW1lbnQucXVlcnlTZWxlY3RvckFsbChzaW1wbGUpO1xuXG4gICAgICBpZiAoIXNpbXBsZU5vZGVzIHx8ICFzaW1wbGVOb2Rlcy5sZW5ndGgpIHtcbiAgICAgICAgcmV0dXJuIHJlc3VsdE5vZGVzO1xuICAgICAgfVxuXG4gICAgICByZWxhdGlvbiA9IHRoaXMucmVsYXRpb247XG4gICAgfSBlbHNlIHtcbiAgICAgIHNpbXBsZU5vZGVzID0gW2RvY3VtZW50XTtcbiAgICAgIHJlbGF0aW9uID0gJyAnO1xuICAgIH1cblxuICAgIHN3aXRjaCAocmVsYXRpb24pIHtcbiAgICAgIGNhc2UgJyAnOlxuICAgICAgICBzaW1wbGVOb2Rlcy5mb3JFYWNoKGZ1bmN0aW9uIChub2RlKSB7XG4gICAgICAgICAgX3RoaXMyLnJlbGF0aXZlU2VhcmNoKG5vZGUsIHJlc3VsdE5vZGVzKTtcbiAgICAgICAgfSk7XG4gICAgICAgIGJyZWFrO1xuXG4gICAgICBjYXNlICc+JzpcbiAgICAgICAge1xuICAgICAgICAgIHNpbXBsZU5vZGVzLmZvckVhY2goZnVuY3Rpb24gKG5vZGUpIHtcbiAgICAgICAgICAgIE9iamVjdC52YWx1ZXMobm9kZS5jaGlsZHJlbikuZm9yRWFjaChmdW5jdGlvbiAoY2hpbGROb2RlKSB7XG4gICAgICAgICAgICAgIGlmIChfdGhpczIubWF0Y2hlcyhjaGlsZE5vZGUpKSB7XG4gICAgICAgICAgICAgICAgcmVzdWx0Tm9kZXMucHVzaChjaGlsZE5vZGUpO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9KTtcbiAgICAgICAgICB9KTtcbiAgICAgICAgICBicmVhaztcbiAgICAgICAgfVxuXG4gICAgICBjYXNlICcrJzpcbiAgICAgICAge1xuICAgICAgICAgIHNpbXBsZU5vZGVzLmZvckVhY2goZnVuY3Rpb24gKG5vZGUpIHtcbiAgICAgICAgICAgIHZhciBwYXJlbnROb2RlID0gbm9kZS5wYXJlbnROb2RlO1xuICAgICAgICAgICAgT2JqZWN0LnZhbHVlcyhwYXJlbnROb2RlLmNoaWxkcmVuKS5mb3JFYWNoKGZ1bmN0aW9uIChjaGlsZE5vZGUpIHtcbiAgICAgICAgICAgICAgaWYgKF90aGlzMi5tYXRjaGVzKGNoaWxkTm9kZSkgJiYgY2hpbGROb2RlLnByZXZpb3VzRWxlbWVudFNpYmxpbmcgPT09IG5vZGUpIHtcbiAgICAgICAgICAgICAgICByZXN1bHROb2Rlcy5wdXNoKGNoaWxkTm9kZSk7XG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH0pO1xuICAgICAgICAgIH0pO1xuICAgICAgICAgIGJyZWFrO1xuICAgICAgICB9XG5cbiAgICAgIGNhc2UgJ34nOlxuICAgICAgICB7XG4gICAgICAgICAgc2ltcGxlTm9kZXMuZm9yRWFjaChmdW5jdGlvbiAobm9kZSkge1xuICAgICAgICAgICAgdmFyIHBhcmVudE5vZGUgPSBub2RlLnBhcmVudE5vZGU7XG4gICAgICAgICAgICBPYmplY3QudmFsdWVzKHBhcmVudE5vZGUuY2hpbGRyZW4pLmZvckVhY2goZnVuY3Rpb24gKGNoaWxkTm9kZSkge1xuICAgICAgICAgICAgICBpZiAoX3RoaXMyLm1hdGNoZXMoY2hpbGROb2RlKSAmJiBub2RlLmNvbXBhcmVEb2N1bWVudFBvc2l0aW9uKGNoaWxkTm9kZSkgPT09IDQpIHtcbiAgICAgICAgICAgICAgICByZXN1bHROb2Rlcy5wdXNoKGNoaWxkTm9kZSk7XG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH0pO1xuICAgICAgICAgIH0pO1xuICAgICAgICAgIGJyZWFrO1xuICAgICAgICB9XG4gICAgfVxuXG4gICAgcmV0dXJuIFNpenpsZS51bmlxdWVTb3J0KHJlc3VsdE5vZGVzKTtcbiAgfTtcbiAgLyoqXG4gICAqIFBlcmZvcm1zIGEgc2VhcmNoIG9mIFwiY29tcGxleFwiIHBhcnQgcmVsYXRpdmUgdG8gcmVzdWx0cyBmb3IgdGhlIFwic2ltcGxlXCIgcGFydC5cbiAgICogQHBhcmFtIHtOb2RlfSBub2RlIGEgbm9kZSBtYXRjaGluZyB0aGUgXCJzaW1wbGVcIiBwYXJ0LlxuICAgKiBAcGFyYW0ge05vZGVbXX0gcmVzdWx0IGFuIGFycmF5IHRvIGFwcGVuZCBzZWFyY2ggcmVzdWx0LlxuICAgKi9cblxuXG4gIFNwbGl0dGVkU2VsZWN0b3IucHJvdG90eXBlLnJlbGF0aXZlU2VhcmNoID0gZnVuY3Rpb24gKG5vZGUsIHJlc3VsdHMpIHtcbiAgICBTaXp6bGUodGhpcy5jb21wbGV4LCBub2RlLCByZXN1bHRzKTtcbiAgfTtcblxuICByZXR1cm4ge1xuICAgIC8qKlxuICAgICAqIFdyYXBzIHRoZSBpbm5lciBjbGFzcyBzbyB0aGF0IHRoZSBpbnN0YW5jZSBpcyBub3QgZXhwb3NlZC5cbiAgICAgKi9cbiAgICBjcmVhdGVTZWxlY3RvcjogZnVuY3Rpb24gY3JlYXRlU2VsZWN0b3Ioc2VsZWN0b3IsIHRva2VucywgZGVidWcpIHtcbiAgICAgIHJldHVybiBuZXcgRXh0ZW5kZWRTZWxlY3RvclBhcnNlcihzZWxlY3RvciwgdG9rZW5zLCBkZWJ1ZykuY3JlYXRlU2VsZWN0b3IoKTtcbiAgICB9LFxuXG4gICAgLyoqXG4gICAgICogTWFyayBldmVyeSBzZWxlY3RvciBhcyBhIHNlbGVjdG9yIGJlaW5nIGRlYnVnZ2VkLCBzbyB0aGF0IHRpbWluZyBpbmZvcm1hdGlvblxuICAgICAqIGZvciB0aGUgc2VsZWN0b3IgaXMgcHJpbnRlZCB0byB0aGUgY29uc29sZS5cbiAgICAgKi9cbiAgICBlbmFibGVHbG9iYWxEZWJ1Z2dpbmc6IGZ1bmN0aW9uIGVuYWJsZUdsb2JhbERlYnVnZ2luZygpIHtcbiAgICAgIGdsb2JhbERlYnVnZ2luZ0ZsYWcgPSB0cnVlO1xuICAgIH1cbiAgfTtcbn0oKTtcblxuLyoqXG4gKiBDb3B5cmlnaHQgMjAxNiBBZGd1YXJkIFNvZnR3YXJlIEx0ZFxuICpcbiAqIExpY2Vuc2VkIHVuZGVyIHRoZSBBcGFjaGUgTGljZW5zZSwgVmVyc2lvbiAyLjAgKHRoZSBcIkxpY2Vuc2VcIik7XG4gKiB5b3UgbWF5IG5vdCB1c2UgdGhpcyBmaWxlIGV4Y2VwdCBpbiBjb21wbGlhbmNlIHdpdGggdGhlIExpY2Vuc2UuXG4gKiBZb3UgbWF5IG9idGFpbiBhIGNvcHkgb2YgdGhlIExpY2Vuc2UgYXRcbiAqXG4gKiBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElDRU5TRS0yLjBcbiAqXG4gKiBVbmxlc3MgcmVxdWlyZWQgYnkgYXBwbGljYWJsZSBsYXcgb3IgYWdyZWVkIHRvIGluIHdyaXRpbmcsIHNvZnR3YXJlXG4gKiBkaXN0cmlidXRlZCB1bmRlciB0aGUgTGljZW5zZSBpcyBkaXN0cmlidXRlZCBvbiBhbiBcIkFTIElTXCIgQkFTSVMsXG4gKiBXSVRIT1VUIFdBUlJBTlRJRVMgT1IgQ09ORElUSU9OUyBPRiBBTlkgS0lORCwgZWl0aGVyIGV4cHJlc3Mgb3IgaW1wbGllZC5cbiAqIFNlZSB0aGUgTGljZW5zZSBmb3IgdGhlIHNwZWNpZmljIGxhbmd1YWdlIGdvdmVybmluZyBwZXJtaXNzaW9ucyBhbmRcbiAqIGxpbWl0YXRpb25zIHVuZGVyIHRoZSBMaWNlbnNlLlxuICovXG4vKipcbiAqIEEgaGVscGVyIGNsYXNzIHRoYXQgcGFyc2VzIHN0eWxlc2hlZXRzIGNvbnRhaW5pbmcgZXh0ZW5kZWQgc2VsZWN0b3JzXG4gKiBpbnRvIEV4dGVuZGVkU2VsZWN0b3IgaW5zdGFuY2VzIGFuZCBrZXktdmFsdWUgbWFwcyBvZiBzdHlsZSBkZWNsYXJhdGlvbnMuXG4gKiBQbGVhc2Ugbm90ZSwgdGhhdCBpdCBkb2VzIG5vdCBzdXBwb3J0IGFueSBjb21wbGV4IHRoaW5ncyBsaWtlIG1lZGlhIHF1ZXJpZXMgYW5kIHN1Y2guXG4gKi9cblxudmFyIEV4dGVuZGVkQ3NzUGFyc2VyID0gZnVuY3Rpb24gKCkge1xuICB2YXIgcmVEZWNsRW5kID0gL1s7fV0vZztcbiAgdmFyIHJlRGVjbERpdmlkZXIgPSAvWzs6fV0vZztcbiAgdmFyIHJlTm9uV2hpdGVzcGFjZSA9IC9cXFMvZztcbiAgdmFyIFNpenpsZTtcbiAgLyoqXG4gICAqIEBwYXJhbSB7c3RyaW5nfSBjc3NUZXh0XG4gICAqIEBjb25zdHJ1Y3RvclxuICAgKi9cblxuICBmdW5jdGlvbiBQYXJzZXIoY3NzVGV4dCkge1xuICAgIHRoaXMuY3NzVGV4dCA9IGNzc1RleHQ7XG4gIH1cblxuICBQYXJzZXIucHJvdG90eXBlID0ge1xuICAgIGVycm9yOiBmdW5jdGlvbiBlcnJvcihwb3NpdGlvbikge1xuICAgICAgdGhyb3cgbmV3IEVycm9yKFwiQ3NzUGFyc2VyOiBwYXJzZSBlcnJvciBhdCBwb3NpdGlvbiBcIi5jb25jYXQodGhpcy5wb3NPZmZzZXQgKyBwb3NpdGlvbikpO1xuICAgIH0sXG5cbiAgICAvKipcbiAgICAgKiBWYWxpZGF0ZXMgdGhhdCB0aGUgdG9rZW5zIGNvcnJlc3BvbmQgdG8gYSB2YWxpZCBzZWxlY3Rvci5cbiAgICAgKiBTaXp6bGUgaXMgZGlmZmVyZW50IGZyb20gYnJvd3NlcnMgYW5kIHNvbWUgc2VsZWN0b3JzIHRoYXQgaXQgdG9sZXJhdGVzIGFyZW4ndCBhY3R1YWxseSB2YWxpZC5cbiAgICAgKiBGb3IgaW5zdGFuY2UsIFwiZGl2ID5cIiB3b24ndCB3b3JrIGluIGEgYnJvd3NlciwgYnV0IGl0IHdpbGwgaW4gU2l6emxlIChpdCdkIGJlIHRoZSBzYW1lIGFzIFwiZGl2ID4gKlwiKS5cbiAgICAgKlxuICAgICAqIEBwYXJhbSB7Kn0gc2VsZWN0b3JzIEFuIGFycmF5IG9mIFNlbGVjdG9yRGF0YSAoc2VsZWN0b3IsIGdyb3VwcylcbiAgICAgKiBAcmV0dXJucyB7Ym9vbGVhbn0gZmFsc2UgaWYgYW55IG9mIHRoZSBncm91cHMgYXJlIGludmFsaWRcbiAgICAgKi9cbiAgICB2YWxpZGF0ZVNlbGVjdG9yczogZnVuY3Rpb24gdmFsaWRhdGVTZWxlY3RvcnMoc2VsZWN0b3JzKSB7XG4gICAgICB2YXIgaVNlbGVjdG9ycyA9IHNlbGVjdG9ycy5sZW5ndGg7XG5cbiAgICAgIHdoaWxlIChpU2VsZWN0b3JzLS0pIHtcbiAgICAgICAgdmFyIGdyb3VwcyA9IHNlbGVjdG9yc1tpU2VsZWN0b3JzXS5ncm91cHM7XG4gICAgICAgIHZhciBpR3JvdXBzID0gZ3JvdXBzLmxlbmd0aDtcblxuICAgICAgICB3aGlsZSAoaUdyb3Vwcy0tKSB7XG4gICAgICAgICAgdmFyIHRva2VucyA9IGdyb3Vwc1tpR3JvdXBzXTtcbiAgICAgICAgICB2YXIgbGFzdFRva2VuID0gdG9rZW5zW3Rva2Vucy5sZW5ndGggLSAxXTtcblxuICAgICAgICAgIGlmIChTaXp6bGUuc2VsZWN0b3JzLnJlbGF0aXZlW2xhc3RUb2tlbi50eXBlXSkge1xuICAgICAgICAgICAgcmV0dXJuIGZhbHNlO1xuICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgfVxuXG4gICAgICByZXR1cm4gdHJ1ZTtcbiAgICB9LFxuXG4gICAgLyoqXG4gICAgICogUGFyc2VzIGEgc3R5bGVzaGVldCBhbmQgcmV0dXJucyBhIGxpc3Qgb2YgcGFpcnMgb2YgYW4gRXh0ZW5kZWRTZWxlY3RvciBhbmQgYSBzdHlsZXMgbWFwLlxuICAgICAqIFRoaXMgbWV0aG9kIHdpbGwgdGhyb3cgYW4gZXJyb3IgaW4gY2FzZSBvZiBhbiBvYnZpb3VzbHkgaW52YWxpZCBpbnB1dC5cbiAgICAgKiBJZiBhbnkgb2YgdGhlIHNlbGVjdG9ycyB1c2VkIGluIHRoZSBzdHlsZXNoZWV0IGNhbm5vdCBiZSBjb21waWxlZCBpbnRvIGFuIEV4dGVuZGVkU2VsZWN0b3IsXG4gICAgICogaXQgd2lsbCBiZSBpZ25vcmVkLlxuICAgICAqXG4gICAgICogQHR5cGVkZWYge09iamVjdH0gRXh0ZW5kZWRTdHlsZVxuICAgICAqIEBwcm9wZXJ0eSB7T2JqZWN0fSBzZWxlY3RvciBBbiBpbnN0YW5jZSBvZiB0aGUge0BsaW5rIEV4dGVuZGVkU2VsZWN0b3J9IGNsYXNzXG4gICAgICogQHByb3BlcnR5IHtPYmplY3R9IHN0eWxlTWFwIEEgbWFwIG9mIHN0eWxlcyBwYXJzZWRcbiAgICAgKlxuICAgICAqIEByZXR1cm5zIHtBcnJheS48RXh0ZW5kZWRTdHlsZT59IEFuIGFycmF5IG9mIHRoZSBzdHlsZXMgcGFyc2VkXG4gICAgICovXG4gICAgcGFyc2VDc3M6IGZ1bmN0aW9uIHBhcnNlQ3NzKCkge1xuICAgICAgdGhpcy5wb3NPZmZzZXQgPSAwO1xuXG4gICAgICBpZiAoIXRoaXMuY3NzVGV4dCkge1xuICAgICAgICB0aGlzLmVycm9yKDApO1xuICAgICAgfVxuXG4gICAgICB2YXIgcmVzdWx0cyA9IFtdO1xuXG4gICAgICB3aGlsZSAodGhpcy5jc3NUZXh0KSB7XG4gICAgICAgIC8vIEFwcGx5IHRvbGVyYW50IHRva2VuaXphdGlvbi5cbiAgICAgICAgdmFyIHBhcnNlUmVzdWx0ID0gU2l6emxlLnRva2VuaXplKHRoaXMuY3NzVGV4dCwgZmFsc2UsIHtcbiAgICAgICAgICB0b2xlcmFudDogdHJ1ZSxcbiAgICAgICAgICByZXR1cm5VbnNvcnRlZDogdHJ1ZVxuICAgICAgICB9KTtcbiAgICAgICAgdmFyIHNlbGVjdG9yRGF0YSA9IHBhcnNlUmVzdWx0LnNlbGVjdG9ycztcbiAgICAgICAgdGhpcy5uZXh0SW5kZXggPSBwYXJzZVJlc3VsdC5uZXh0SW5kZXg7XG5cbiAgICAgICAgaWYgKHRoaXMuY3NzVGV4dC5jaGFyQ29kZUF0KHRoaXMubmV4dEluZGV4KSAhPT0gMTIzIHx8XG4gICAgICAgIC8qIGNoYXJDb2RlIG9mICd7JyAqL1xuICAgICAgICAhdGhpcy52YWxpZGF0ZVNlbGVjdG9ycyhzZWxlY3RvckRhdGEpKSB7XG4gICAgICAgICAgdGhpcy5lcnJvcih0aGlzLm5leHRJbmRleCk7XG4gICAgICAgIH1cblxuICAgICAgICB0aGlzLm5leHRJbmRleCsrOyAvLyBNb3ZlIHRoZSBwb2ludGVyIHRvIHRoZSBzdGFydCBvZiBzdHlsZSBkZWNsYXJhdGlvbi5cblxuICAgICAgICB2YXIgc3R5bGVNYXAgPSB0aGlzLnBhcnNlTmV4dFN0eWxlKCk7XG4gICAgICAgIHZhciBkZWJ1ZyA9IGZhbHNlOyAvLyBJZiB0aGVyZSBpcyBhIHN0eWxlIHByb3BlcnR5ICdkZWJ1ZycsIG1hcmsgdGhlIHNlbGVjdG9yXG4gICAgICAgIC8vIGFzIGEgZGVidWdnYWJsZSBzZWxlY3RvciwgYW5kIGRlbGV0ZSB0aGUgc3R5bGUgZGVjbGFyYXRpb24uXG5cbiAgICAgICAgdmFyIGRlYnVnUHJvcGVydHlWYWx1ZSA9IHN0eWxlTWFwWydkZWJ1ZyddO1xuXG4gICAgICAgIGlmICh0eXBlb2YgZGVidWdQcm9wZXJ0eVZhbHVlICE9PSAndW5kZWZpbmVkJykge1xuICAgICAgICAgIGlmIChkZWJ1Z1Byb3BlcnR5VmFsdWUgPT09ICdnbG9iYWwnKSB7XG4gICAgICAgICAgICBFeHRlbmRlZFNlbGVjdG9yRmFjdG9yeS5lbmFibGVHbG9iYWxEZWJ1Z2dpbmcoKTtcbiAgICAgICAgICB9XG5cbiAgICAgICAgICBkZWJ1ZyA9IHRydWU7XG4gICAgICAgICAgZGVsZXRlIHN0eWxlTWFwWydkZWJ1ZyddO1xuICAgICAgICB9IC8vIENyZWF0aW5nIGFuIEV4dGVuZGVkU2VsZWN0b3IgaW5zdGFuY2UgZm9yIGV2ZXJ5IHNlbGVjdG9yIHdlIGdvdCBmcm9tIFNpenpsZS50b2tlbml6ZS5cbiAgICAgICAgLy8gVGhpcyBpcyBxdWl0ZSBpbXBvcnRhbnQgYXMgU2l6emxlIGRvZXMgYSBwb29yIGpvYiBhdCBleGVjdXRpbmcgc2VsZWN0b3JzIGxpa2UgXCJzZWxlY3RvcjEsIHNlbGVjdG9yMlwiLlxuXG5cbiAgICAgICAgZm9yICh2YXIgaSA9IDAsIGwgPSBzZWxlY3RvckRhdGEubGVuZ3RoOyBpIDwgbDsgaSsrKSB7XG4gICAgICAgICAgdmFyIGRhdGEgPSBzZWxlY3RvckRhdGFbaV07XG5cbiAgICAgICAgICB0cnkge1xuICAgICAgICAgICAgdmFyIGV4dGVuZGVkU2VsZWN0b3IgPSBFeHRlbmRlZFNlbGVjdG9yRmFjdG9yeS5jcmVhdGVTZWxlY3RvcihkYXRhLnNlbGVjdG9yVGV4dCwgZGF0YS5ncm91cHMsIGRlYnVnKTtcblxuICAgICAgICAgICAgaWYgKGV4dGVuZGVkU2VsZWN0b3IucHNldWRvQ2xhc3NBcmcgJiYgZXh0ZW5kZWRTZWxlY3Rvci5pc1JlbW92ZVNlbGVjdG9yKSB7XG4gICAgICAgICAgICAgIC8vIGlmIHRoZXJlIGlzIHJlbW92ZSBwc2V1ZG8tY2xhc3MgaW4gcnVsZSxcbiAgICAgICAgICAgICAgLy8gdGhlIGVsZW1lbnQgd2lsbCBiZSByZW1vdmVkIGFuZCBubyBvdGhlciBzdHlsZXMgd2lsbCBiZSBhcHBsaWVkXG4gICAgICAgICAgICAgIHN0eWxlTWFwWydyZW1vdmUnXSA9ICd0cnVlJztcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgcmVzdWx0cy5wdXNoKHtcbiAgICAgICAgICAgICAgc2VsZWN0b3I6IGV4dGVuZGVkU2VsZWN0b3IsXG4gICAgICAgICAgICAgIHN0eWxlOiBzdHlsZU1hcFxuICAgICAgICAgICAgfSk7XG4gICAgICAgICAgfSBjYXRjaCAoZXgpIHtcbiAgICAgICAgICAgIHV0aWxzLmxvZ0Vycm9yKFwiRXh0ZW5kZWRDc3NQYXJzZXI6IGlnbm9yaW5nIGludmFsaWQgc2VsZWN0b3IgXCIuY29uY2F0KGRhdGEuc2VsZWN0b3JUZXh0KSk7XG4gICAgICAgICAgfVxuICAgICAgICB9XG4gICAgICB9XG5cbiAgICAgIHJldHVybiByZXN1bHRzO1xuICAgIH0sXG4gICAgcGFyc2VOZXh0U3R5bGU6IGZ1bmN0aW9uIHBhcnNlTmV4dFN0eWxlKCkge1xuICAgICAgdmFyIHN0eWxlTWFwID0gT2JqZWN0LmNyZWF0ZShudWxsKTtcbiAgICAgIHZhciBicmFja2V0UG9zID0gdGhpcy5wYXJzZVVudGlsQ2xvc2luZ0JyYWNrZXQoc3R5bGVNYXApOyAvLyBDdXQgb3V0IG1hdGNoZWQgcG9ydGlvbiBmcm9tIGNzc1RleHQuXG5cbiAgICAgIHJlTm9uV2hpdGVzcGFjZS5sYXN0SW5kZXggPSBicmFja2V0UG9zICsgMTtcbiAgICAgIHZhciBtYXRjaCA9IHJlTm9uV2hpdGVzcGFjZS5leGVjKHRoaXMuY3NzVGV4dCk7XG5cbiAgICAgIGlmIChtYXRjaCA9PT0gbnVsbCkge1xuICAgICAgICB0aGlzLmNzc1RleHQgPSAnJztcbiAgICAgICAgcmV0dXJuIHN0eWxlTWFwO1xuICAgICAgfVxuXG4gICAgICB2YXIgbWF0Y2hQb3MgPSBtYXRjaC5pbmRleDtcbiAgICAgIHRoaXMuY3NzVGV4dCA9IHRoaXMuY3NzVGV4dC5zbGljZShtYXRjaFBvcyk7XG4gICAgICB0aGlzLnBvc09mZnNldCArPSBtYXRjaFBvcztcbiAgICAgIHJldHVybiBzdHlsZU1hcDtcbiAgICB9LFxuXG4gICAgLyoqXG4gICAgICogQHJldHVybiB7bnVtYmVyfSBhbiBpbmRleCBvZiB0aGUgbmV4dCAnfScgaW4gYHRoaXMuY3NzVGV4dGAuXG4gICAgICovXG4gICAgcGFyc2VVbnRpbENsb3NpbmdCcmFja2V0OiBmdW5jdGlvbiBwYXJzZVVudGlsQ2xvc2luZ0JyYWNrZXQoc3R5bGVNYXApIHtcbiAgICAgIC8vIEV4cGVjdHMgXCI6XCIsIFwiO1wiLCBhbmQgXCJ9XCIuXG4gICAgICByZURlY2xEaXZpZGVyLmxhc3RJbmRleCA9IHRoaXMubmV4dEluZGV4O1xuICAgICAgdmFyIG1hdGNoID0gcmVEZWNsRGl2aWRlci5leGVjKHRoaXMuY3NzVGV4dCk7XG5cbiAgICAgIGlmIChtYXRjaCA9PT0gbnVsbCkge1xuICAgICAgICB0aGlzLmVycm9yKHRoaXMubmV4dEluZGV4KTtcbiAgICAgIH1cblxuICAgICAgdmFyIG1hdGNoUG9zID0gbWF0Y2guaW5kZXg7XG4gICAgICB2YXIgbWF0Y2hlZCA9IG1hdGNoWzBdO1xuXG4gICAgICBpZiAobWF0Y2hlZCA9PT0gJ30nKSB7XG4gICAgICAgIHJldHVybiBtYXRjaFBvcztcbiAgICAgIH1cblxuICAgICAgaWYgKG1hdGNoZWQgPT09ICc6Jykge1xuICAgICAgICB2YXIgY29sb25JbmRleCA9IG1hdGNoUG9zOyAvLyBFeHBlY3RzIFwiO1wiIGFuZCBcIn1cIi5cblxuICAgICAgICByZURlY2xFbmQubGFzdEluZGV4ID0gY29sb25JbmRleDtcbiAgICAgICAgbWF0Y2ggPSByZURlY2xFbmQuZXhlYyh0aGlzLmNzc1RleHQpO1xuXG4gICAgICAgIGlmIChtYXRjaCA9PT0gbnVsbCkge1xuICAgICAgICAgIHRoaXMuZXJyb3IoY29sb25JbmRleCk7XG4gICAgICAgIH1cblxuICAgICAgICBtYXRjaFBvcyA9IG1hdGNoLmluZGV4O1xuICAgICAgICBtYXRjaGVkID0gbWF0Y2hbMF07IC8vIFBvcHVsYXRlcyB0aGUgYHN0eWxlTWFwYCBrZXktdmFsdWUgbWFwLlxuXG4gICAgICAgIHZhciBwcm9wZXJ0eSA9IHRoaXMuY3NzVGV4dC5zbGljZSh0aGlzLm5leHRJbmRleCwgY29sb25JbmRleCkudHJpbSgpO1xuICAgICAgICB2YXIgdmFsdWUgPSB0aGlzLmNzc1RleHQuc2xpY2UoY29sb25JbmRleCArIDEsIG1hdGNoUG9zKS50cmltKCk7XG4gICAgICAgIHN0eWxlTWFwW3Byb3BlcnR5XSA9IHZhbHVlOyAvLyBJZiBmb3VuZCBcIn1cIiwgcmUtcnVuIHRoZSBvdXRlciBsb29wLlxuXG4gICAgICAgIGlmIChtYXRjaGVkID09PSAnfScpIHtcbiAgICAgICAgICByZXR1cm4gbWF0Y2hQb3M7XG4gICAgICAgIH1cbiAgICAgIH0gLy8gbWF0Y2hQb3MgaXMgdGhlIHBvc2l0aW9uIG9mIHRoZSBuZXh0ICc7Jy5cbiAgICAgIC8vIEluY3JlYXNlICduZXh0SW5kZXgnIGFuZCByZS1ydW4gdGhlIGxvb3AuXG5cblxuICAgICAgdGhpcy5uZXh0SW5kZXggPSBtYXRjaFBvcyArIDE7XG4gICAgICByZXR1cm4gdGhpcy5wYXJzZVVudGlsQ2xvc2luZ0JyYWNrZXQoc3R5bGVNYXApOyAvLyBTaG91bGQgYmUgYSBzdWJqZWN0IG9mIHRhaWwtY2FsbCBvcHRpbWl6YXRpb24uXG4gICAgfVxuICB9O1xuICByZXR1cm4ge1xuICAgIHBhcnNlQ3NzOiBmdW5jdGlvbiBwYXJzZUNzcyhjc3NUZXh0KSB7XG4gICAgICBTaXp6bGUgPSBpbml0aWFsaXplU2l6emxlKCk7XG4gICAgICByZXR1cm4gbmV3IFBhcnNlcihjc3NVdGlscy5ub3JtYWxpemUoY3NzVGV4dCkpLnBhcnNlQ3NzKCk7XG4gICAgfVxuICB9O1xufSgpO1xuXG4vKipcbiAqIFRoaXMgY2FsbGJhY2sgaXMgdXNlZCB0byBnZXQgYWZmZWN0ZWQgbm9kZSBlbGVtZW50cyBhbmQgaGFuZGxlIHN0eWxlIHByb3BlcnRpZXNcbiAqIGJlZm9yZSB0aGV5IGFyZSBhcHBsaWVkIHRvIHRoZW0gaWYgaXQgaXMgbmVjZXNzYXJ5XG4gKiBAY2FsbGJhY2sgYmVmb3JlU3R5bGVBcHBsaWVkXG4gKiBAcGFyYW0ge29iamVjdH0gYWZmZWN0ZWRFbGVtZW50IC0gT2JqZWN0IGNvbnRhaW5pbmcgRE9NIG5vZGUgYW5kIHJ1bGUgdG8gYmUgYXBwbGllZFxuICogQHJldHVybiB7b2JqZWN0fSBhZmZlY3RlZEVsZW1lbnQgLSBTYW1lIG9yIG1vZGlmaWVkIG9iamVjdCBjb250YWluaW5nIERPTSBub2RlIGFuZCBydWxlIHRvIGJlIGFwcGxpZWRcbiAqL1xuXG4vKipcbiAqIEV4dGVuZGVkIGNzcyBjbGFzc1xuICpcbiAqIEBwYXJhbSB7T2JqZWN0fSBjb25maWd1cmF0aW9uXG4gKiBAcGFyYW0ge3N0cmluZ30gY29uZmlndXJhdGlvbi5zdHlsZVNoZWV0IC0gdGhlIENTUyBzdHlsZXNoZWV0IHRleHRcbiAqIEBwYXJhbSB7YmVmb3JlU3R5bGVBcHBsaWVkfSBbY29uZmlndXJhdGlvbi5iZWZvcmVTdHlsZUFwcGxpZWRdIC0gdGhlIGNhbGxiYWNrIHRoYXQgaGFuZGxlcyBhZmZlY3RlZCBlbGVtZW50c1xuICogQGNvbnN0cnVjdG9yXG4gKi9cblxuZnVuY3Rpb24gRXh0ZW5kZWRDc3MoY29uZmlndXJhdGlvbikge1xuICBpZiAoIWNvbmZpZ3VyYXRpb24pIHtcbiAgICB0aHJvdyBuZXcgRXJyb3IoJ0NvbmZpZ3VyYXRpb24gaXMgbm90IHByb3ZpZGVkLicpO1xuICB9XG5cbiAgdmFyIHN0eWxlU2hlZXQgPSBjb25maWd1cmF0aW9uLnN0eWxlU2hlZXQ7XG4gIHZhciBiZWZvcmVTdHlsZUFwcGxpZWQgPSBjb25maWd1cmF0aW9uLmJlZm9yZVN0eWxlQXBwbGllZDtcblxuICBpZiAoYmVmb3JlU3R5bGVBcHBsaWVkICYmIHR5cGVvZiBiZWZvcmVTdHlsZUFwcGxpZWQgIT09ICdmdW5jdGlvbicpIHtcbiAgICAvLyBlc2xpbnQtZGlzYWJsZS1uZXh0LWxpbmUgbWF4LWxlblxuICAgIHRocm93IG5ldyBFcnJvcihcIldyb25nIGNvbmZpZ3VyYXRpb24uIFR5cGUgb2YgJ2JlZm9yZVN0eWxlQXBwbGllZCcgZmllbGQgc2hvdWxkIGJlIGEgZnVuY3Rpb24sIHJlY2VpdmVkOiBcIi5jb25jYXQoX3R5cGVvZihiZWZvcmVTdHlsZUFwcGxpZWQpKSk7XG4gIH0gLy8gV2UgdXNlIEV2ZW50VHJhY2tlciB0byB0cmFjayB0aGUgZXZlbnQgdGhhdCBpcyBsaWtlbHkgdG8gY2F1c2UgdGhlIG11dGF0aW9uLlxuICAvLyBUaGUgcHJvYmxlbSBpcyB0aGF0IHdlIGNhbm5vdCB1c2UgYHdpbmRvdy5ldmVudGAgZGlyZWN0bHkgZnJvbSB0aGUgbXV0YXRpb24gb2JzZXJ2ZXIgY2FsbFxuICAvLyBhcyB3ZSdyZSBub3QgaW4gdGhlIGV2ZW50IGhhbmRsZXIgY29udGV4dCBhbnltb3JlLlxuXG5cbiAgdmFyIEV2ZW50VHJhY2tlciA9IGZ1bmN0aW9uICgpIHtcbiAgICB2YXIgaWdub3JlZEV2ZW50VHlwZXMgPSBbJ21vdXNlb3ZlcicsICdtb3VzZWxlYXZlJywgJ21vdXNlZW50ZXInLCAnbW91c2VvdXQnXTtcbiAgICB2YXIgTEFTVF9FVkVOVF9USU1FT1VUX01TID0gMTA7XG4gICAgdmFyIEVWRU5UUyA9IFsvLyBrZXlib2FyZCBldmVudHNcbiAgICAna2V5ZG93bicsICdrZXlwcmVzcycsICdrZXl1cCcsIC8vIG1vdXNlIGV2ZW50c1xuICAgICdhdXhjbGljaycsICdjbGljaycsICdjb250ZXh0bWVudScsICdkYmxjbGljaycsICdtb3VzZWRvd24nLCAnbW91c2VlbnRlcicsICdtb3VzZWxlYXZlJywgJ21vdXNlbW92ZScsICdtb3VzZW92ZXInLCAnbW91c2VvdXQnLCAnbW91c2V1cCcsICdwb2ludGVybG9ja2NoYW5nZScsICdwb2ludGVybG9ja2Vycm9yJywgJ3NlbGVjdCcsICd3aGVlbCddOyAvLyAnd2hlZWwnIGV2ZW50IG1ha2VzIHNjcm9sbGluZyBpbiBTYWZhcmkgdHdpdGNoeVxuICAgIC8vIGh0dHBzOi8vZ2l0aHViLmNvbS9BZGd1YXJkVGVhbS9FeHRlbmRlZENzcy9pc3N1ZXMvMTIwXG5cbiAgICB2YXIgc2FmYXJpUHJvYmxlbWF0aWNFdmVudHMgPSBbJ3doZWVsJ107XG4gICAgdmFyIHRyYWNrZWRFdmVudHMgPSB1dGlscy5pc1NhZmFyaUJyb3dzZXIgPyBFVkVOVFMuZmlsdGVyKGZ1bmN0aW9uIChlbCkge1xuICAgICAgcmV0dXJuICEoc2FmYXJpUHJvYmxlbWF0aWNFdmVudHMuaW5kZXhPZihlbCkgPiAtMSk7XG4gICAgfSkgOiBFVkVOVFM7XG4gICAgdmFyIGxhc3RFdmVudFR5cGU7XG4gICAgdmFyIGxhc3RFdmVudFRpbWU7XG5cbiAgICB2YXIgdHJhY2tFdmVudCA9IGZ1bmN0aW9uIHRyYWNrRXZlbnQoZSkge1xuICAgICAgbGFzdEV2ZW50VHlwZSA9IGUudHlwZTtcbiAgICAgIGxhc3RFdmVudFRpbWUgPSBEYXRlLm5vdygpO1xuICAgIH07XG5cbiAgICB0cmFja2VkRXZlbnRzLmZvckVhY2goZnVuY3Rpb24gKGV2TmFtZSkge1xuICAgICAgZG9jdW1lbnQuZG9jdW1lbnRFbGVtZW50LmFkZEV2ZW50TGlzdGVuZXIoZXZOYW1lLCB0cmFja0V2ZW50LCB0cnVlKTtcbiAgICB9KTtcblxuICAgIHZhciBnZXRMYXN0RXZlbnRUeXBlID0gZnVuY3Rpb24gZ2V0TGFzdEV2ZW50VHlwZSgpIHtcbiAgICAgIHJldHVybiBsYXN0RXZlbnRUeXBlO1xuICAgIH07XG5cbiAgICB2YXIgZ2V0VGltZVNpbmNlTGFzdEV2ZW50ID0gZnVuY3Rpb24gZ2V0VGltZVNpbmNlTGFzdEV2ZW50KCkge1xuICAgICAgcmV0dXJuIERhdGUubm93KCkgLSBsYXN0RXZlbnRUaW1lO1xuICAgIH07XG5cbiAgICByZXR1cm4ge1xuICAgICAgaXNJZ25vcmVkRXZlbnRUeXBlOiBmdW5jdGlvbiBpc0lnbm9yZWRFdmVudFR5cGUoKSB7XG4gICAgICAgIHJldHVybiBpZ25vcmVkRXZlbnRUeXBlcy5pbmRleE9mKGdldExhc3RFdmVudFR5cGUoKSkgPiAtMSAmJiBnZXRUaW1lU2luY2VMYXN0RXZlbnQoKSA8IExBU1RfRVZFTlRfVElNRU9VVF9NUztcbiAgICAgIH1cbiAgICB9O1xuICB9KCk7XG5cbiAgdmFyIHJ1bGVzID0gW107XG4gIHZhciBhZmZlY3RlZEVsZW1lbnRzID0gW107XG4gIHZhciByZW1vdmFsc1N0YXRpc3RpYyA9IHt9O1xuICB2YXIgZG9tT2JzZXJ2ZWQ7XG4gIHZhciBldmVudExpc3RlbmVyU3VwcG9ydGVkID0gd2luZG93LmFkZEV2ZW50TGlzdGVuZXI7XG4gIHZhciBkb21NdXRhdGlvbk9ic2VydmVyO1xuXG4gIGZ1bmN0aW9uIG9ic2VydmVEb2N1bWVudChjYWxsYmFjaykge1xuICAgIC8vIFdlIGFyZSB0cnlpbmcgdG8gbGltaXQgdGhlIG51bWJlciBvZiBjYWxsYmFjayBjYWxscyBieSBub3QgY2FsbGluZyBpdCBvbiBhbGwga2luZCBvZiBcImhvdmVyXCIgZXZlbnRzLlxuICAgIC8vIFRoZSByYXRpb25hbGUgYmVoaW5kIHRoaXMgaXMgdGhhdCBcImhvdmVyXCIgZXZlbnRzIG9mdGVuIGNhdXNlIGF0dHJpYnV0ZXMgbW9kaWZpY2F0aW9uLFxuICAgIC8vIGJ1dCByZS1hcHBseWluZyBleHRDU1MgcnVsZXMgd2lsbCBiZSB1c2VsZXNzIGFzIHRoZXNlIGF0dHJpYnV0ZSBjaGFuZ2VzIGFyZSB1c3VhbGx5IHRyYW5zaWVudC5cbiAgICB2YXIgaXNJZ25vcmVkTXV0YXRpb24gPSBmdW5jdGlvbiBpc0lnbm9yZWRNdXRhdGlvbihtdXRhdGlvbnMpIHtcbiAgICAgIGZvciAodmFyIGkgPSAwOyBpIDwgbXV0YXRpb25zLmxlbmd0aDsgaSArPSAxKSB7XG4gICAgICAgIGlmIChtdXRhdGlvbnMudHlwZSAhPT0gJ2F0dHJpYnV0ZXMnKSB7XG4gICAgICAgICAgcmV0dXJuIGZhbHNlO1xuICAgICAgICB9XG4gICAgICB9XG5cbiAgICAgIHJldHVybiB0cnVlO1xuICAgIH07XG5cbiAgICBpZiAodXRpbHMuTXV0YXRpb25PYnNlcnZlcikge1xuICAgICAgZG9tTXV0YXRpb25PYnNlcnZlciA9IG5ldyB1dGlscy5NdXRhdGlvbk9ic2VydmVyKGZ1bmN0aW9uIChtdXRhdGlvbnMpIHtcbiAgICAgICAgaWYgKCFtdXRhdGlvbnMgfHwgbXV0YXRpb25zLmxlbmd0aCA9PT0gMCkge1xuICAgICAgICAgIHJldHVybjtcbiAgICAgICAgfVxuXG4gICAgICAgIGlmIChFdmVudFRyYWNrZXIuaXNJZ25vcmVkRXZlbnRUeXBlKCkgJiYgaXNJZ25vcmVkTXV0YXRpb24obXV0YXRpb25zKSkge1xuICAgICAgICAgIHJldHVybjtcbiAgICAgICAgfVxuXG4gICAgICAgIGNhbGxiYWNrKCk7XG4gICAgICB9KTtcbiAgICAgIGRvbU11dGF0aW9uT2JzZXJ2ZXIub2JzZXJ2ZShkb2N1bWVudCwge1xuICAgICAgICBjaGlsZExpc3Q6IHRydWUsXG4gICAgICAgIHN1YnRyZWU6IHRydWUsXG4gICAgICAgIGF0dHJpYnV0ZXM6IHRydWUsXG4gICAgICAgIGF0dHJpYnV0ZUZpbHRlcjogWydpZCcsICdjbGFzcyddXG4gICAgICB9KTtcbiAgICB9IGVsc2UgaWYgKGV2ZW50TGlzdGVuZXJTdXBwb3J0ZWQpIHtcbiAgICAgIGRvY3VtZW50LmFkZEV2ZW50TGlzdGVuZXIoJ0RPTU5vZGVJbnNlcnRlZCcsIGNhbGxiYWNrLCBmYWxzZSk7XG4gICAgICBkb2N1bWVudC5hZGRFdmVudExpc3RlbmVyKCdET01Ob2RlUmVtb3ZlZCcsIGNhbGxiYWNrLCBmYWxzZSk7XG4gICAgICBkb2N1bWVudC5hZGRFdmVudExpc3RlbmVyKCdET01BdHRyTW9kaWZpZWQnLCBjYWxsYmFjaywgZmFsc2UpO1xuICAgIH1cbiAgfVxuXG4gIGZ1bmN0aW9uIGRpc2Nvbm5lY3REb2N1bWVudChjYWxsYmFjaykge1xuICAgIGlmIChkb21NdXRhdGlvbk9ic2VydmVyKSB7XG4gICAgICBkb21NdXRhdGlvbk9ic2VydmVyLmRpc2Nvbm5lY3QoKTtcbiAgICB9IGVsc2UgaWYgKGV2ZW50TGlzdGVuZXJTdXBwb3J0ZWQpIHtcbiAgICAgIGRvY3VtZW50LnJlbW92ZUV2ZW50TGlzdGVuZXIoJ0RPTU5vZGVJbnNlcnRlZCcsIGNhbGxiYWNrLCBmYWxzZSk7XG4gICAgICBkb2N1bWVudC5yZW1vdmVFdmVudExpc3RlbmVyKCdET01Ob2RlUmVtb3ZlZCcsIGNhbGxiYWNrLCBmYWxzZSk7XG4gICAgICBkb2N1bWVudC5yZW1vdmVFdmVudExpc3RlbmVyKCdET01BdHRyTW9kaWZpZWQnLCBjYWxsYmFjaywgZmFsc2UpO1xuICAgIH1cbiAgfVxuXG4gIHZhciBNQVhfU1RZTEVfUFJPVEVDVElPTl9DT1VOVCA9IDUwO1xuICB2YXIgcHJvdGVjdGlvbk9ic2VydmVyT3B0aW9uID0ge1xuICAgIGF0dHJpYnV0ZXM6IHRydWUsXG4gICAgYXR0cmlidXRlT2xkVmFsdWU6IHRydWUsXG4gICAgYXR0cmlidXRlRmlsdGVyOiBbJ3N0eWxlJ11cbiAgfTtcbiAgLyoqXG4gICAqIENyZWF0ZXMgTXV0YXRpb25PYnNlcnZlciBwcm90ZWN0aW9uIGZ1bmN0aW9uXG4gICAqXG4gICAqIEBwYXJhbSBzdHlsZXNcbiAgICogQHJldHVybiB7cHJvdGVjdGlvbkZ1bmN0aW9ufVxuICAgKi9cblxuICBmdW5jdGlvbiBjcmVhdGVQcm90ZWN0aW9uRnVuY3Rpb24oc3R5bGVzKSB7XG4gICAgZnVuY3Rpb24gcHJvdGVjdGlvbkZ1bmN0aW9uKG11dGF0aW9ucywgb2JzZXJ2ZXIpIHtcbiAgICAgIGlmICghbXV0YXRpb25zLmxlbmd0aCkge1xuICAgICAgICByZXR1cm47XG4gICAgICB9XG5cbiAgICAgIHZhciBtdXRhdGlvbiA9IG11dGF0aW9uc1swXTtcbiAgICAgIHZhciB0YXJnZXQgPSBtdXRhdGlvbi50YXJnZXQ7XG4gICAgICBvYnNlcnZlci5kaXNjb25uZWN0KCk7XG4gICAgICBzdHlsZXMuZm9yRWFjaChmdW5jdGlvbiAoc3R5bGUpIHtcbiAgICAgICAgc2V0U3R5bGVUb0VsZW1lbnQodGFyZ2V0LCBzdHlsZSk7XG4gICAgICB9KTtcblxuICAgICAgaWYgKCsrb2JzZXJ2ZXIuc3R5bGVQcm90ZWN0aW9uQ291bnQgPCBNQVhfU1RZTEVfUFJPVEVDVElPTl9DT1VOVCkge1xuICAgICAgICBvYnNlcnZlci5vYnNlcnZlKHRhcmdldCwgcHJvdGVjdGlvbk9ic2VydmVyT3B0aW9uKTtcbiAgICAgIH0gZWxzZSB7XG4gICAgICAgIHV0aWxzLmxvZ0Vycm9yKCdFeHRlbmRlZENzczogaW5maW5pdGUgbG9vcCBwcm90ZWN0aW9uIGZvciBzdHlsZScpO1xuICAgICAgfVxuICAgIH1cblxuICAgIHJldHVybiBwcm90ZWN0aW9uRnVuY3Rpb247XG4gIH1cbiAgLyoqXG4gICAqIFNldHMgdXAgYSBNdXRhdGlvbk9ic2VydmVyIHdoaWNoIHByb3RlY3RzIHN0eWxlIGF0dHJpYnV0ZXMgZnJvbSBjaGFuZ2VzXG4gICAqIEBwYXJhbSBub2RlIERPTSBub2RlXG4gICAqIEBwYXJhbSBydWxlcyBydWxlc1xuICAgKiBAcmV0dXJucyBNdXRhdGlvbiBvYnNlcnZlciB1c2VkIHRvIHByb3RlY3QgYXR0cmlidXRlIG9yIG51bGwgaWYgdGhlcmUncyBub3RoaW5nIHRvIHByb3RlY3RcbiAgICovXG5cblxuICBmdW5jdGlvbiBwcm90ZWN0U3R5bGVBdHRyaWJ1dGUobm9kZSwgcnVsZXMpIHtcbiAgICBpZiAoIXV0aWxzLk11dGF0aW9uT2JzZXJ2ZXIpIHtcbiAgICAgIHJldHVybiBudWxsO1xuICAgIH1cblxuICAgIHZhciBzdHlsZXMgPSBydWxlcy5tYXAoZnVuY3Rpb24gKHIpIHtcbiAgICAgIHJldHVybiByLnN0eWxlO1xuICAgIH0pO1xuICAgIHZhciBwcm90ZWN0aW9uT2JzZXJ2ZXIgPSBuZXcgdXRpbHMuTXV0YXRpb25PYnNlcnZlcihjcmVhdGVQcm90ZWN0aW9uRnVuY3Rpb24oc3R5bGVzKSk7XG4gICAgcHJvdGVjdGlvbk9ic2VydmVyLm9ic2VydmUobm9kZSwgcHJvdGVjdGlvbk9ic2VydmVyT3B0aW9uKTsgLy8gQWRkcyBhbiBleHBhbmRvIHRvIHRoZSBvYnNlcnZlciB0byBrZWVwICdzdHlsZSBmaXggY291bnRzJy5cblxuICAgIHByb3RlY3Rpb25PYnNlcnZlci5zdHlsZVByb3RlY3Rpb25Db3VudCA9IDA7XG4gICAgcmV0dXJuIHByb3RlY3Rpb25PYnNlcnZlcjtcbiAgfVxuXG4gIGZ1bmN0aW9uIHJlbW92ZVN1ZmZpeChzdHIsIHN1ZmZpeCkge1xuICAgIHZhciBpbmRleCA9IHN0ci5pbmRleE9mKHN1ZmZpeCwgc3RyLmxlbmd0aCAtIHN1ZmZpeC5sZW5ndGgpO1xuXG4gICAgaWYgKGluZGV4ID49IDApIHtcbiAgICAgIHJldHVybiBzdHIuc3Vic3RyaW5nKDAsIGluZGV4KTtcbiAgICB9XG5cbiAgICByZXR1cm4gc3RyO1xuICB9XG4gIC8qKlxuICAgKiBGaW5kcyBhZmZlY3RlZEVsZW1lbnQgb2JqZWN0IGZvciB0aGUgc3BlY2lmaWVkIERPTSBub2RlXG4gICAqIEBwYXJhbSBub2RlICBET00gbm9kZVxuICAgKiBAcmV0dXJucyAgICAgYWZmZWN0ZWRFbGVtZW50IGZvdW5kIG9yIG51bGxcbiAgICovXG5cblxuICBmdW5jdGlvbiBmaW5kQWZmZWN0ZWRFbGVtZW50KG5vZGUpIHtcbiAgICBmb3IgKHZhciBpID0gMDsgaSA8IGFmZmVjdGVkRWxlbWVudHMubGVuZ3RoOyBpICs9IDEpIHtcbiAgICAgIGlmIChhZmZlY3RlZEVsZW1lbnRzW2ldLm5vZGUgPT09IG5vZGUpIHtcbiAgICAgICAgcmV0dXJuIGFmZmVjdGVkRWxlbWVudHNbaV07XG4gICAgICB9XG4gICAgfVxuXG4gICAgcmV0dXJuIG51bGw7XG4gIH1cblxuICBmdW5jdGlvbiByZW1vdmVFbGVtZW50KGFmZmVjdGVkRWxlbWVudCkge1xuICAgIHZhciBub2RlID0gYWZmZWN0ZWRFbGVtZW50Lm5vZGU7XG4gICAgYWZmZWN0ZWRFbGVtZW50LnJlbW92ZWQgPSB0cnVlO1xuICAgIHZhciBlbGVtZW50U2VsZWN0b3IgPSB1dGlscy5nZXROb2RlU2VsZWN0b3Iobm9kZSk7IC8vIGNoZWNrIGlmIHRoZSBlbGVtZW50IGhhcyBiZWVuIGFscmVhZHkgcmVtb3ZlZCBlYXJsaWVyXG5cbiAgICB2YXIgZWxlbWVudFJlbW92YWxzQ291bnRlciA9IHJlbW92YWxzU3RhdGlzdGljW2VsZW1lbnRTZWxlY3Rvcl0gfHwgMDsgLy8gaWYgcmVtb3ZhbHMgYXR0ZW1wdHMgaGFwcGVuZWQgbW9yZSB0aGFuIHNwZWNpZmllZCB3ZSBkbyBub3QgdHJ5IHRvIHJlbW92ZSBub2RlIGFnYWluXG5cbiAgICBpZiAoZWxlbWVudFJlbW92YWxzQ291bnRlciA+IE1BWF9TVFlMRV9QUk9URUNUSU9OX0NPVU5UKSB7XG4gICAgICB1dGlscy5sb2dFcnJvcignRXh0ZW5kZWRDc3M6IGluZmluaXRlIGxvb3AgcHJvdGVjdGlvbiBmb3IgU0VMRUNUT1InLCBlbGVtZW50U2VsZWN0b3IpO1xuICAgICAgcmV0dXJuO1xuICAgIH1cblxuICAgIGlmIChub2RlLnBhcmVudE5vZGUpIHtcbiAgICAgIG5vZGUucGFyZW50Tm9kZS5yZW1vdmVDaGlsZChub2RlKTtcbiAgICAgIHJlbW92YWxzU3RhdGlzdGljW2VsZW1lbnRTZWxlY3Rvcl0gPSBlbGVtZW50UmVtb3ZhbHNDb3VudGVyICsgMTtcbiAgICB9XG4gIH1cbiAgLyoqXG4gICAqIEFwcGxpZXMgc3R5bGUgdG8gdGhlIHNwZWNpZmllZCBET00gbm9kZVxuICAgKiBAcGFyYW0gYWZmZWN0ZWRFbGVtZW50IE9iamVjdCBjb250YWluaW5nIERPTSBub2RlIGFuZCBydWxlIHRvIGJlIGFwcGxpZWRcbiAgICovXG5cblxuICBmdW5jdGlvbiBhcHBseVN0eWxlKGFmZmVjdGVkRWxlbWVudCkge1xuICAgIGlmIChhZmZlY3RlZEVsZW1lbnQucHJvdGVjdGlvbk9ic2VydmVyKSB7XG4gICAgICAvLyBTdHlsZSBpcyBhbHJlYWR5IGFwcGxpZWQgYW5kIHByb3RlY3RlZCBieSB0aGUgb2JzZXJ2ZXJcbiAgICAgIHJldHVybjtcbiAgICB9XG5cbiAgICBpZiAoYmVmb3JlU3R5bGVBcHBsaWVkKSB7XG4gICAgICBhZmZlY3RlZEVsZW1lbnQgPSBiZWZvcmVTdHlsZUFwcGxpZWQoYWZmZWN0ZWRFbGVtZW50KTtcblxuICAgICAgaWYgKCFhZmZlY3RlZEVsZW1lbnQpIHtcbiAgICAgICAgcmV0dXJuO1xuICAgICAgfVxuICAgIH1cblxuICAgIHZhciBfYWZmZWN0ZWRFbGVtZW50ID0gYWZmZWN0ZWRFbGVtZW50LFxuICAgICAgICBub2RlID0gX2FmZmVjdGVkRWxlbWVudC5ub2RlO1xuXG4gICAgZm9yICh2YXIgaSA9IDA7IGkgPCBhZmZlY3RlZEVsZW1lbnQucnVsZXMubGVuZ3RoOyBpKyspIHtcbiAgICAgIHZhciBzdHlsZSA9IGFmZmVjdGVkRWxlbWVudC5ydWxlc1tpXS5zdHlsZTtcblxuICAgICAgaWYgKHN0eWxlWydyZW1vdmUnXSA9PT0gJ3RydWUnKSB7XG4gICAgICAgIHJlbW92ZUVsZW1lbnQoYWZmZWN0ZWRFbGVtZW50KTtcbiAgICAgICAgcmV0dXJuO1xuICAgICAgfVxuXG4gICAgICBzZXRTdHlsZVRvRWxlbWVudChub2RlLCBzdHlsZSk7XG4gICAgfVxuICB9XG4gIC8qKlxuICAgKiBTZXRzIHN0eWxlIHRvIHRoZSBzcGVjaWZpZWQgRE9NIG5vZGVcbiAgICogQHBhcmFtIG5vZGUgZWxlbWVudFxuICAgKiBAcGFyYW0gc3R5bGUgc3R5bGVcbiAgICovXG5cblxuICBmdW5jdGlvbiBzZXRTdHlsZVRvRWxlbWVudChub2RlLCBzdHlsZSkge1xuICAgIE9iamVjdC5rZXlzKHN0eWxlKS5mb3JFYWNoKGZ1bmN0aW9uIChwcm9wKSB7XG4gICAgICAvLyBBcHBseSB0aGlzIHN0eWxlIG9ubHkgdG8gZXhpc3RpbmcgcHJvcGVydGllc1xuICAgICAgLy8gV2UgY2FuJ3QgdXNlIGhhc093blByb3BlcnR5IGhlcmUgKGRvZXMgbm90IHdvcmsgaW4gRkYpXG4gICAgICBpZiAodHlwZW9mIG5vZGUuc3R5bGUuZ2V0UHJvcGVydHlWYWx1ZShwcm9wKSAhPT0gJ3VuZGVmaW5lZCcpIHtcbiAgICAgICAgdmFyIHZhbHVlID0gc3R5bGVbcHJvcF07IC8vIEZpcnN0IHdlIHNob3VsZCByZW1vdmUgIWltcG9ydGFudCBhdHRyaWJ1dGUgKG9yIGl0IHdvbid0IGJlIGFwcGxpZWQnKVxuXG4gICAgICAgIHZhbHVlID0gcmVtb3ZlU3VmZml4KHZhbHVlLnRyaW0oKSwgJyFpbXBvcnRhbnQnKS50cmltKCk7XG4gICAgICAgIG5vZGUuc3R5bGUuc2V0UHJvcGVydHkocHJvcCwgdmFsdWUsICdpbXBvcnRhbnQnKTtcbiAgICAgIH1cbiAgICB9KTtcbiAgfVxuICAvKipcbiAgICogUmV2ZXJ0cyBzdHlsZSBmb3IgdGhlIGFmZmVjdGVkIG9iamVjdFxuICAgKi9cblxuXG4gIGZ1bmN0aW9uIHJldmVydFN0eWxlKGFmZmVjdGVkRWxlbWVudCkge1xuICAgIGlmIChhZmZlY3RlZEVsZW1lbnQucHJvdGVjdGlvbk9ic2VydmVyKSB7XG4gICAgICBhZmZlY3RlZEVsZW1lbnQucHJvdGVjdGlvbk9ic2VydmVyLmRpc2Nvbm5lY3QoKTtcbiAgICB9XG5cbiAgICBhZmZlY3RlZEVsZW1lbnQubm9kZS5zdHlsZS5jc3NUZXh0ID0gYWZmZWN0ZWRFbGVtZW50Lm9yaWdpbmFsU3R5bGU7XG4gIH1cbiAgLyoqXG4gICAqIEFwcGxpZXMgc3BlY2lmaWVkIHJ1bGUgYW5kIHJldHVybnMgbGlzdCBvZiBlbGVtZW50cyBhZmZlY3RlZFxuICAgKiBAcGFyYW0gcnVsZSBSdWxlIHRvIGFwcGx5XG4gICAqIEByZXR1cm5zIExpc3Qgb2YgZWxlbWVudHMgYWZmZWN0ZWQgYnkgdGhpcyBydWxlXG4gICAqL1xuXG5cbiAgZnVuY3Rpb24gYXBwbHlSdWxlKHJ1bGUpIHtcbiAgICB2YXIgZGVidWcgPSBydWxlLnNlbGVjdG9yLmlzRGVidWdnaW5nKCk7XG4gICAgdmFyIHN0YXJ0O1xuXG4gICAgaWYgKGRlYnVnKSB7XG4gICAgICBzdGFydCA9IHV0aWxzLkFzeW5jV3JhcHBlci5ub3coKTtcbiAgICB9XG5cbiAgICB2YXIgc2VsZWN0b3IgPSBydWxlLnNlbGVjdG9yO1xuICAgIHZhciBub2RlcyA9IHNlbGVjdG9yLnF1ZXJ5U2VsZWN0b3JBbGwoKTtcbiAgICBub2Rlcy5mb3JFYWNoKGZ1bmN0aW9uIChub2RlKSB7XG4gICAgICB2YXIgYWZmZWN0ZWRFbGVtZW50ID0gZmluZEFmZmVjdGVkRWxlbWVudChub2RlKTtcblxuICAgICAgaWYgKGFmZmVjdGVkRWxlbWVudCkge1xuICAgICAgICBhZmZlY3RlZEVsZW1lbnQucnVsZXMucHVzaChydWxlKTtcbiAgICAgICAgYXBwbHlTdHlsZShhZmZlY3RlZEVsZW1lbnQpO1xuICAgICAgfSBlbHNlIHtcbiAgICAgICAgLy8gQXBwbHlpbmcgc3R5bGUgZmlyc3QgdGltZVxuICAgICAgICB2YXIgb3JpZ2luYWxTdHlsZSA9IG5vZGUuc3R5bGUuY3NzVGV4dDtcbiAgICAgICAgYWZmZWN0ZWRFbGVtZW50ID0ge1xuICAgICAgICAgIG5vZGU6IG5vZGUsXG4gICAgICAgICAgLy8gYWZmZWN0ZWQgRE9NIG5vZGVcbiAgICAgICAgICBydWxlczogW3J1bGVdLFxuICAgICAgICAgIC8vIHJ1bGVzIHRvIGJlIGFwcGxpZWRcbiAgICAgICAgICBvcmlnaW5hbFN0eWxlOiBvcmlnaW5hbFN0eWxlLFxuICAgICAgICAgIC8vIG9yaWdpbmFsIG5vZGUgc3R5bGVcbiAgICAgICAgICBwcm90ZWN0aW9uT2JzZXJ2ZXI6IG51bGwgLy8gc3R5bGUgYXR0cmlidXRlIG9ic2VydmVyXG5cbiAgICAgICAgfTtcbiAgICAgICAgYXBwbHlTdHlsZShhZmZlY3RlZEVsZW1lbnQpO1xuICAgICAgICBhZmZlY3RlZEVsZW1lbnRzLnB1c2goYWZmZWN0ZWRFbGVtZW50KTtcbiAgICAgIH1cbiAgICB9KTtcblxuICAgIGlmIChkZWJ1Zykge1xuICAgICAgdmFyIGVsYXBzZWQgPSB1dGlscy5Bc3luY1dyYXBwZXIubm93KCkgLSBzdGFydDtcblxuICAgICAgaWYgKCEoJ3RpbWluZ1N0YXRzJyBpbiBydWxlKSkge1xuICAgICAgICBydWxlLnRpbWluZ1N0YXRzID0gbmV3IHV0aWxzLlN0YXRzKCk7XG4gICAgICB9XG5cbiAgICAgIHJ1bGUudGltaW5nU3RhdHMucHVzaChlbGFwc2VkKTtcbiAgICB9XG5cbiAgICByZXR1cm4gbm9kZXM7XG4gIH1cbiAgLyoqXG4gICAqIEFwcGxpZXMgZmlsdGVyaW5nIHJ1bGVzXG4gICAqL1xuXG5cbiAgZnVuY3Rpb24gYXBwbHlSdWxlcygpIHtcbiAgICB2YXIgZWxlbWVudHNJbmRleCA9IFtdOyAvLyBzb21lIHJ1bGVzIGNvdWxkIG1ha2UgY2FsbCAtIHNlbGVjdG9yLnF1ZXJ5U2VsZWN0b3JBbGwoKSB0ZW1wb3JhcmlseSB0byBjaGFuZ2Ugbm9kZSBpZCBhdHRyaWJ1dGVcbiAgICAvLyB0aGlzIGNhdXNlZCBNdXRhdGlvbk9ic2VydmVyIHRvIGNhbGwgcmVjdXJzaXZlbHlcbiAgICAvLyBodHRwczovL2dpdGh1Yi5jb20vQWRndWFyZFRlYW0vRXh0ZW5kZWRDc3MvaXNzdWVzLzgxXG5cbiAgICBzdG9wT2JzZXJ2ZSgpO1xuICAgIHJ1bGVzLmZvckVhY2goZnVuY3Rpb24gKHJ1bGUpIHtcbiAgICAgIHZhciBub2RlcyA9IGFwcGx5UnVsZShydWxlKTtcbiAgICAgIEFycmF5LnByb3RvdHlwZS5wdXNoLmFwcGx5KGVsZW1lbnRzSW5kZXgsIG5vZGVzKTtcbiAgICB9KTsgLy8gTm93IHJldmVydCBzdHlsZXMgZm9yIGVsZW1lbnRzIHdoaWNoIGFyZSBubyBtb3JlIGFmZmVjdGVkXG5cbiAgICB2YXIgbCA9IGFmZmVjdGVkRWxlbWVudHMubGVuZ3RoOyAvLyBkbyBub3RoaW5nIGlmIHRoZXJlIGlzIG5vIGVsZW1lbnRzIHRvIHByb2Nlc3NcblxuICAgIGlmIChlbGVtZW50c0luZGV4Lmxlbmd0aCA+IDApIHtcbiAgICAgIHdoaWxlIChsLS0pIHtcbiAgICAgICAgdmFyIG9iaiA9IGFmZmVjdGVkRWxlbWVudHNbbF07XG5cbiAgICAgICAgaWYgKGVsZW1lbnRzSW5kZXguaW5kZXhPZihvYmoubm9kZSkgPT09IC0xKSB7XG4gICAgICAgICAgLy8gVGltZSB0byByZXZlcnQgc3R5bGVcbiAgICAgICAgICByZXZlcnRTdHlsZShvYmopO1xuICAgICAgICAgIGFmZmVjdGVkRWxlbWVudHMuc3BsaWNlKGwsIDEpO1xuICAgICAgICB9IGVsc2UgaWYgKCFvYmoucmVtb3ZlZCkge1xuICAgICAgICAgIC8vIEFkZCBzdHlsZSBwcm90ZWN0aW9uIG9ic2VydmVyXG4gICAgICAgICAgLy8gUHJvdGVjdCBcInN0eWxlXCIgYXR0cmlidXRlIGZyb20gY2hhbmdlc1xuICAgICAgICAgIGlmICghb2JqLnByb3RlY3Rpb25PYnNlcnZlcikge1xuICAgICAgICAgICAgb2JqLnByb3RlY3Rpb25PYnNlcnZlciA9IHByb3RlY3RTdHlsZUF0dHJpYnV0ZShvYmoubm9kZSwgb2JqLnJ1bGVzKTtcbiAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICB9IC8vIEFmdGVyIHN0eWxlcyBhcmUgYXBwbGllZCB3ZSBjYW4gc3RhcnQgb2JzZXJ2ZSBhZ2FpblxuXG5cbiAgICBvYnNlcnZlKCk7XG4gICAgcHJpbnRUaW1pbmdJbmZvKCk7XG4gIH1cblxuICB2YXIgQVBQTFlfUlVMRVNfREVMQVkgPSAxNTA7XG4gIHZhciBhcHBseVJ1bGVzU2NoZWR1bGVyID0gbmV3IHV0aWxzLkFzeW5jV3JhcHBlcihhcHBseVJ1bGVzLCBBUFBMWV9SVUxFU19ERUxBWSk7XG4gIHZhciBtYWluQ2FsbGJhY2sgPSBhcHBseVJ1bGVzU2NoZWR1bGVyLnJ1bi5iaW5kKGFwcGx5UnVsZXNTY2hlZHVsZXIpO1xuXG4gIGZ1bmN0aW9uIG9ic2VydmUoKSB7XG4gICAgaWYgKGRvbU9ic2VydmVkKSB7XG4gICAgICByZXR1cm47XG4gICAgfSAvLyBIYW5kbGUgZHluYW1pY2FsbHkgYWRkZWQgZWxlbWVudHNcblxuXG4gICAgZG9tT2JzZXJ2ZWQgPSB0cnVlO1xuICAgIG9ic2VydmVEb2N1bWVudChtYWluQ2FsbGJhY2spO1xuICB9XG5cbiAgZnVuY3Rpb24gc3RvcE9ic2VydmUoKSB7XG4gICAgaWYgKCFkb21PYnNlcnZlZCkge1xuICAgICAgcmV0dXJuO1xuICAgIH1cblxuICAgIGRvbU9ic2VydmVkID0gZmFsc2U7XG4gICAgZGlzY29ubmVjdERvY3VtZW50KG1haW5DYWxsYmFjayk7XG4gIH1cblxuICBmdW5jdGlvbiBhcHBseSgpIHtcbiAgICBhcHBseVJ1bGVzKCk7XG5cbiAgICBpZiAoZG9jdW1lbnQucmVhZHlTdGF0ZSAhPT0gJ2NvbXBsZXRlJykge1xuICAgICAgZG9jdW1lbnQuYWRkRXZlbnRMaXN0ZW5lcignRE9NQ29udGVudExvYWRlZCcsIGFwcGx5UnVsZXMpO1xuICAgIH1cbiAgfVxuICAvKipcbiAgICogRGlzcG9zZXMgRXh0ZW5kZWRDc3MgYW5kIHJlbW92ZXMgb3VyIHN0eWxlcyBmcm9tIG1hdGNoZWQgZWxlbWVudHNcbiAgICovXG5cblxuICBmdW5jdGlvbiBkaXNwb3NlKCkge1xuICAgIHN0b3BPYnNlcnZlKCk7XG4gICAgYWZmZWN0ZWRFbGVtZW50cy5mb3JFYWNoKGZ1bmN0aW9uIChvYmopIHtcbiAgICAgIHJldmVydFN0eWxlKG9iaik7XG4gICAgfSk7XG4gIH1cblxuICB2YXIgdGltaW5nc1ByaW50ZWQgPSBmYWxzZTtcbiAgLyoqXG4gICAqIFByaW50cyB0aW1pbmcgaW5mb3JtYXRpb24gZm9yIGFsbCBzZWxlY3RvcnMgbWFya2VkIGFzIFwiZGVidWdcIlxuICAgKi9cblxuICBmdW5jdGlvbiBwcmludFRpbWluZ0luZm8oKSB7XG4gICAgaWYgKHRpbWluZ3NQcmludGVkKSB7XG4gICAgICByZXR1cm47XG4gICAgfVxuXG4gICAgdGltaW5nc1ByaW50ZWQgPSB0cnVlO1xuICAgIHZhciB0aW1pbmdzID0gcnVsZXMuZmlsdGVyKGZ1bmN0aW9uIChydWxlKSB7XG4gICAgICByZXR1cm4gcnVsZS5zZWxlY3Rvci5pc0RlYnVnZ2luZygpO1xuICAgIH0pLm1hcChmdW5jdGlvbiAocnVsZSkge1xuICAgICAgcmV0dXJuIHtcbiAgICAgICAgc2VsZWN0b3JUZXh0OiBydWxlLnNlbGVjdG9yLnNlbGVjdG9yVGV4dCxcbiAgICAgICAgdGltaW5nU3RhdHM6IHJ1bGUudGltaW5nU3RhdHNcbiAgICAgIH07XG4gICAgfSk7XG5cbiAgICBpZiAodGltaW5ncy5sZW5ndGggPT09IDApIHtcbiAgICAgIHJldHVybjtcbiAgICB9IC8vIEFkZCBsb2NhdGlvbi5ocmVmIHRvIHRoZSBtZXNzYWdlIHRvIGRpc3Rpbmd1aXNoIGZyYW1lc1xuXG5cbiAgICB1dGlscy5sb2dJbmZvKCdbRXh0ZW5kZWRDc3NdIFRpbWluZ3MgZm9yICVvOlxcbiVvIChpbiBtaWxsaXNlY29uZHMpJywgd2luZG93LmxvY2F0aW9uLmhyZWYsIHRpbWluZ3MpO1xuICB9IC8vIEZpcnN0IG9mIGFsbCBwYXJzZSB0aGUgc3R5bGVzaGVldFxuXG5cbiAgcnVsZXMgPSBFeHRlbmRlZENzc1BhcnNlci5wYXJzZUNzcyhzdHlsZVNoZWV0KTsgLy8gRVhQT1NFXG5cbiAgdGhpcy5kaXNwb3NlID0gZGlzcG9zZTtcbiAgdGhpcy5hcHBseSA9IGFwcGx5O1xuICAvKiogRXhwb3NlZCBmb3IgdGVzdGluZyBwdXJwb3NlcyBvbmx5ICovXG5cbiAgdGhpcy5fZ2V0QWZmZWN0ZWRFbGVtZW50cyA9IGZ1bmN0aW9uICgpIHtcbiAgICByZXR1cm4gYWZmZWN0ZWRFbGVtZW50cztcbiAgfTtcbn1cbi8qKlxuICogRXhwb3NlIHF1ZXJ5U2VsZWN0b3JBbGwgZm9yIGRlYnVnZ2luZyBhbmQgdmFsaWRhdGluZyBzZWxlY3RvcnNcbiAqXG4gKiBAcGFyYW0ge3N0cmluZ30gc2VsZWN0b3JUZXh0IHNlbGVjdG9yIHRleHRcbiAqIEBwYXJhbSB7Ym9vbGVhbn0gbm9UaW1pbmcgaWYgdHJ1ZSAtLSBkbyBub3QgcHJpbnQgdGhlIHRpbWluZyB0byB0aGUgY29uc29sZVxuICogQHJldHVybnMge0FycmF5PE5vZGU+fE5vZGVMaXN0fSBhIGxpc3Qgb2YgZWxlbWVudHMgZm91bmRcbiAqIEB0aHJvd3MgV2lsbCB0aHJvdyBhbiBlcnJvciBpZiB0aGUgYXJndW1lbnQgaXMgbm90IGEgdmFsaWQgc2VsZWN0b3JcbiAqL1xuXG5cbkV4dGVuZGVkQ3NzLnF1ZXJ5ID0gZnVuY3Rpb24gKHNlbGVjdG9yVGV4dCwgbm9UaW1pbmcpIHtcbiAgaWYgKHR5cGVvZiBzZWxlY3RvclRleHQgIT09ICdzdHJpbmcnKSB7XG4gICAgdGhyb3cgbmV3IEVycm9yKCdTZWxlY3RvciB0ZXh0IGlzIGVtcHR5Jyk7XG4gIH1cblxuICB2YXIgbm93ID0gdXRpbHMuQXN5bmNXcmFwcGVyLm5vdztcbiAgdmFyIHN0YXJ0ID0gbm93KCk7XG5cbiAgdHJ5IHtcbiAgICByZXR1cm4gRXh0ZW5kZWRTZWxlY3RvckZhY3RvcnkuY3JlYXRlU2VsZWN0b3Ioc2VsZWN0b3JUZXh0KS5xdWVyeVNlbGVjdG9yQWxsKCk7XG4gIH0gZmluYWxseSB7XG4gICAgdmFyIGVuZCA9IG5vdygpO1xuXG4gICAgaWYgKCFub1RpbWluZykge1xuICAgICAgdXRpbHMubG9nSW5mbyhcIltFeHRlbmRlZENzc10gRWxhcHNlZDogXCIuY29uY2F0KE1hdGgucm91bmQoKGVuZCAtIHN0YXJ0KSAqIDEwMDApLCBcIiBcXHUwM0JDcy5cIikpO1xuICAgIH1cbiAgfVxufTtcblxuZXhwb3J0IGRlZmF1bHQgRXh0ZW5kZWRDc3M7XG4iLCIvKipcbiAqIENvcHlyaWdodCAoYykgMjAxNC1wcmVzZW50LCBGYWNlYm9vaywgSW5jLlxuICpcbiAqIFRoaXMgc291cmNlIGNvZGUgaXMgbGljZW5zZWQgdW5kZXIgdGhlIE1JVCBsaWNlbnNlIGZvdW5kIGluIHRoZVxuICogTElDRU5TRSBmaWxlIGluIHRoZSByb290IGRpcmVjdG9yeSBvZiB0aGlzIHNvdXJjZSB0cmVlLlxuICovXG5cbnZhciBydW50aW1lID0gKGZ1bmN0aW9uIChleHBvcnRzKSB7XG4gIFwidXNlIHN0cmljdFwiO1xuXG4gIHZhciBPcCA9IE9iamVjdC5wcm90b3R5cGU7XG4gIHZhciBoYXNPd24gPSBPcC5oYXNPd25Qcm9wZXJ0eTtcbiAgdmFyIHVuZGVmaW5lZDsgLy8gTW9yZSBjb21wcmVzc2libGUgdGhhbiB2b2lkIDAuXG4gIHZhciAkU3ltYm9sID0gdHlwZW9mIFN5bWJvbCA9PT0gXCJmdW5jdGlvblwiID8gU3ltYm9sIDoge307XG4gIHZhciBpdGVyYXRvclN5bWJvbCA9ICRTeW1ib2wuaXRlcmF0b3IgfHwgXCJAQGl0ZXJhdG9yXCI7XG4gIHZhciBhc3luY0l0ZXJhdG9yU3ltYm9sID0gJFN5bWJvbC5hc3luY0l0ZXJhdG9yIHx8IFwiQEBhc3luY0l0ZXJhdG9yXCI7XG4gIHZhciB0b1N0cmluZ1RhZ1N5bWJvbCA9ICRTeW1ib2wudG9TdHJpbmdUYWcgfHwgXCJAQHRvU3RyaW5nVGFnXCI7XG5cbiAgZnVuY3Rpb24gZGVmaW5lKG9iaiwga2V5LCB2YWx1ZSkge1xuICAgIE9iamVjdC5kZWZpbmVQcm9wZXJ0eShvYmosIGtleSwge1xuICAgICAgdmFsdWU6IHZhbHVlLFxuICAgICAgZW51bWVyYWJsZTogdHJ1ZSxcbiAgICAgIGNvbmZpZ3VyYWJsZTogdHJ1ZSxcbiAgICAgIHdyaXRhYmxlOiB0cnVlXG4gICAgfSk7XG4gICAgcmV0dXJuIG9ialtrZXldO1xuICB9XG4gIHRyeSB7XG4gICAgLy8gSUUgOCBoYXMgYSBicm9rZW4gT2JqZWN0LmRlZmluZVByb3BlcnR5IHRoYXQgb25seSB3b3JrcyBvbiBET00gb2JqZWN0cy5cbiAgICBkZWZpbmUoe30sIFwiXCIpO1xuICB9IGNhdGNoIChlcnIpIHtcbiAgICBkZWZpbmUgPSBmdW5jdGlvbihvYmosIGtleSwgdmFsdWUpIHtcbiAgICAgIHJldHVybiBvYmpba2V5XSA9IHZhbHVlO1xuICAgIH07XG4gIH1cblxuICBmdW5jdGlvbiB3cmFwKGlubmVyRm4sIG91dGVyRm4sIHNlbGYsIHRyeUxvY3NMaXN0KSB7XG4gICAgLy8gSWYgb3V0ZXJGbiBwcm92aWRlZCBhbmQgb3V0ZXJGbi5wcm90b3R5cGUgaXMgYSBHZW5lcmF0b3IsIHRoZW4gb3V0ZXJGbi5wcm90b3R5cGUgaW5zdGFuY2VvZiBHZW5lcmF0b3IuXG4gICAgdmFyIHByb3RvR2VuZXJhdG9yID0gb3V0ZXJGbiAmJiBvdXRlckZuLnByb3RvdHlwZSBpbnN0YW5jZW9mIEdlbmVyYXRvciA/IG91dGVyRm4gOiBHZW5lcmF0b3I7XG4gICAgdmFyIGdlbmVyYXRvciA9IE9iamVjdC5jcmVhdGUocHJvdG9HZW5lcmF0b3IucHJvdG90eXBlKTtcbiAgICB2YXIgY29udGV4dCA9IG5ldyBDb250ZXh0KHRyeUxvY3NMaXN0IHx8IFtdKTtcblxuICAgIC8vIFRoZSAuX2ludm9rZSBtZXRob2QgdW5pZmllcyB0aGUgaW1wbGVtZW50YXRpb25zIG9mIHRoZSAubmV4dCxcbiAgICAvLyAudGhyb3csIGFuZCAucmV0dXJuIG1ldGhvZHMuXG4gICAgZ2VuZXJhdG9yLl9pbnZva2UgPSBtYWtlSW52b2tlTWV0aG9kKGlubmVyRm4sIHNlbGYsIGNvbnRleHQpO1xuXG4gICAgcmV0dXJuIGdlbmVyYXRvcjtcbiAgfVxuICBleHBvcnRzLndyYXAgPSB3cmFwO1xuXG4gIC8vIFRyeS9jYXRjaCBoZWxwZXIgdG8gbWluaW1pemUgZGVvcHRpbWl6YXRpb25zLiBSZXR1cm5zIGEgY29tcGxldGlvblxuICAvLyByZWNvcmQgbGlrZSBjb250ZXh0LnRyeUVudHJpZXNbaV0uY29tcGxldGlvbi4gVGhpcyBpbnRlcmZhY2UgY291bGRcbiAgLy8gaGF2ZSBiZWVuIChhbmQgd2FzIHByZXZpb3VzbHkpIGRlc2lnbmVkIHRvIHRha2UgYSBjbG9zdXJlIHRvIGJlXG4gIC8vIGludm9rZWQgd2l0aG91dCBhcmd1bWVudHMsIGJ1dCBpbiBhbGwgdGhlIGNhc2VzIHdlIGNhcmUgYWJvdXQgd2VcbiAgLy8gYWxyZWFkeSBoYXZlIGFuIGV4aXN0aW5nIG1ldGhvZCB3ZSB3YW50IHRvIGNhbGwsIHNvIHRoZXJlJ3Mgbm8gbmVlZFxuICAvLyB0byBjcmVhdGUgYSBuZXcgZnVuY3Rpb24gb2JqZWN0LiBXZSBjYW4gZXZlbiBnZXQgYXdheSB3aXRoIGFzc3VtaW5nXG4gIC8vIHRoZSBtZXRob2QgdGFrZXMgZXhhY3RseSBvbmUgYXJndW1lbnQsIHNpbmNlIHRoYXQgaGFwcGVucyB0byBiZSB0cnVlXG4gIC8vIGluIGV2ZXJ5IGNhc2UsIHNvIHdlIGRvbid0IGhhdmUgdG8gdG91Y2ggdGhlIGFyZ3VtZW50cyBvYmplY3QuIFRoZVxuICAvLyBvbmx5IGFkZGl0aW9uYWwgYWxsb2NhdGlvbiByZXF1aXJlZCBpcyB0aGUgY29tcGxldGlvbiByZWNvcmQsIHdoaWNoXG4gIC8vIGhhcyBhIHN0YWJsZSBzaGFwZSBhbmQgc28gaG9wZWZ1bGx5IHNob3VsZCBiZSBjaGVhcCB0byBhbGxvY2F0ZS5cbiAgZnVuY3Rpb24gdHJ5Q2F0Y2goZm4sIG9iaiwgYXJnKSB7XG4gICAgdHJ5IHtcbiAgICAgIHJldHVybiB7IHR5cGU6IFwibm9ybWFsXCIsIGFyZzogZm4uY2FsbChvYmosIGFyZykgfTtcbiAgICB9IGNhdGNoIChlcnIpIHtcbiAgICAgIHJldHVybiB7IHR5cGU6IFwidGhyb3dcIiwgYXJnOiBlcnIgfTtcbiAgICB9XG4gIH1cblxuICB2YXIgR2VuU3RhdGVTdXNwZW5kZWRTdGFydCA9IFwic3VzcGVuZGVkU3RhcnRcIjtcbiAgdmFyIEdlblN0YXRlU3VzcGVuZGVkWWllbGQgPSBcInN1c3BlbmRlZFlpZWxkXCI7XG4gIHZhciBHZW5TdGF0ZUV4ZWN1dGluZyA9IFwiZXhlY3V0aW5nXCI7XG4gIHZhciBHZW5TdGF0ZUNvbXBsZXRlZCA9IFwiY29tcGxldGVkXCI7XG5cbiAgLy8gUmV0dXJuaW5nIHRoaXMgb2JqZWN0IGZyb20gdGhlIGlubmVyRm4gaGFzIHRoZSBzYW1lIGVmZmVjdCBhc1xuICAvLyBicmVha2luZyBvdXQgb2YgdGhlIGRpc3BhdGNoIHN3aXRjaCBzdGF0ZW1lbnQuXG4gIHZhciBDb250aW51ZVNlbnRpbmVsID0ge307XG5cbiAgLy8gRHVtbXkgY29uc3RydWN0b3IgZnVuY3Rpb25zIHRoYXQgd2UgdXNlIGFzIHRoZSAuY29uc3RydWN0b3IgYW5kXG4gIC8vIC5jb25zdHJ1Y3Rvci5wcm90b3R5cGUgcHJvcGVydGllcyBmb3IgZnVuY3Rpb25zIHRoYXQgcmV0dXJuIEdlbmVyYXRvclxuICAvLyBvYmplY3RzLiBGb3IgZnVsbCBzcGVjIGNvbXBsaWFuY2UsIHlvdSBtYXkgd2lzaCB0byBjb25maWd1cmUgeW91clxuICAvLyBtaW5pZmllciBub3QgdG8gbWFuZ2xlIHRoZSBuYW1lcyBvZiB0aGVzZSB0d28gZnVuY3Rpb25zLlxuICBmdW5jdGlvbiBHZW5lcmF0b3IoKSB7fVxuICBmdW5jdGlvbiBHZW5lcmF0b3JGdW5jdGlvbigpIHt9XG4gIGZ1bmN0aW9uIEdlbmVyYXRvckZ1bmN0aW9uUHJvdG90eXBlKCkge31cblxuICAvLyBUaGlzIGlzIGEgcG9seWZpbGwgZm9yICVJdGVyYXRvclByb3RvdHlwZSUgZm9yIGVudmlyb25tZW50cyB0aGF0XG4gIC8vIGRvbid0IG5hdGl2ZWx5IHN1cHBvcnQgaXQuXG4gIHZhciBJdGVyYXRvclByb3RvdHlwZSA9IHt9O1xuICBJdGVyYXRvclByb3RvdHlwZVtpdGVyYXRvclN5bWJvbF0gPSBmdW5jdGlvbiAoKSB7XG4gICAgcmV0dXJuIHRoaXM7XG4gIH07XG5cbiAgdmFyIGdldFByb3RvID0gT2JqZWN0LmdldFByb3RvdHlwZU9mO1xuICB2YXIgTmF0aXZlSXRlcmF0b3JQcm90b3R5cGUgPSBnZXRQcm90byAmJiBnZXRQcm90byhnZXRQcm90byh2YWx1ZXMoW10pKSk7XG4gIGlmIChOYXRpdmVJdGVyYXRvclByb3RvdHlwZSAmJlxuICAgICAgTmF0aXZlSXRlcmF0b3JQcm90b3R5cGUgIT09IE9wICYmXG4gICAgICBoYXNPd24uY2FsbChOYXRpdmVJdGVyYXRvclByb3RvdHlwZSwgaXRlcmF0b3JTeW1ib2wpKSB7XG4gICAgLy8gVGhpcyBlbnZpcm9ubWVudCBoYXMgYSBuYXRpdmUgJUl0ZXJhdG9yUHJvdG90eXBlJTsgdXNlIGl0IGluc3RlYWRcbiAgICAvLyBvZiB0aGUgcG9seWZpbGwuXG4gICAgSXRlcmF0b3JQcm90b3R5cGUgPSBOYXRpdmVJdGVyYXRvclByb3RvdHlwZTtcbiAgfVxuXG4gIHZhciBHcCA9IEdlbmVyYXRvckZ1bmN0aW9uUHJvdG90eXBlLnByb3RvdHlwZSA9XG4gICAgR2VuZXJhdG9yLnByb3RvdHlwZSA9IE9iamVjdC5jcmVhdGUoSXRlcmF0b3JQcm90b3R5cGUpO1xuICBHZW5lcmF0b3JGdW5jdGlvbi5wcm90b3R5cGUgPSBHcC5jb25zdHJ1Y3RvciA9IEdlbmVyYXRvckZ1bmN0aW9uUHJvdG90eXBlO1xuICBHZW5lcmF0b3JGdW5jdGlvblByb3RvdHlwZS5jb25zdHJ1Y3RvciA9IEdlbmVyYXRvckZ1bmN0aW9uO1xuICBHZW5lcmF0b3JGdW5jdGlvbi5kaXNwbGF5TmFtZSA9IGRlZmluZShcbiAgICBHZW5lcmF0b3JGdW5jdGlvblByb3RvdHlwZSxcbiAgICB0b1N0cmluZ1RhZ1N5bWJvbCxcbiAgICBcIkdlbmVyYXRvckZ1bmN0aW9uXCJcbiAgKTtcblxuICAvLyBIZWxwZXIgZm9yIGRlZmluaW5nIHRoZSAubmV4dCwgLnRocm93LCBhbmQgLnJldHVybiBtZXRob2RzIG9mIHRoZVxuICAvLyBJdGVyYXRvciBpbnRlcmZhY2UgaW4gdGVybXMgb2YgYSBzaW5nbGUgLl9pbnZva2UgbWV0aG9kLlxuICBmdW5jdGlvbiBkZWZpbmVJdGVyYXRvck1ldGhvZHMocHJvdG90eXBlKSB7XG4gICAgW1wibmV4dFwiLCBcInRocm93XCIsIFwicmV0dXJuXCJdLmZvckVhY2goZnVuY3Rpb24obWV0aG9kKSB7XG4gICAgICBkZWZpbmUocHJvdG90eXBlLCBtZXRob2QsIGZ1bmN0aW9uKGFyZykge1xuICAgICAgICByZXR1cm4gdGhpcy5faW52b2tlKG1ldGhvZCwgYXJnKTtcbiAgICAgIH0pO1xuICAgIH0pO1xuICB9XG5cbiAgZXhwb3J0cy5pc0dlbmVyYXRvckZ1bmN0aW9uID0gZnVuY3Rpb24oZ2VuRnVuKSB7XG4gICAgdmFyIGN0b3IgPSB0eXBlb2YgZ2VuRnVuID09PSBcImZ1bmN0aW9uXCIgJiYgZ2VuRnVuLmNvbnN0cnVjdG9yO1xuICAgIHJldHVybiBjdG9yXG4gICAgICA/IGN0b3IgPT09IEdlbmVyYXRvckZ1bmN0aW9uIHx8XG4gICAgICAgIC8vIEZvciB0aGUgbmF0aXZlIEdlbmVyYXRvckZ1bmN0aW9uIGNvbnN0cnVjdG9yLCB0aGUgYmVzdCB3ZSBjYW5cbiAgICAgICAgLy8gZG8gaXMgdG8gY2hlY2sgaXRzIC5uYW1lIHByb3BlcnR5LlxuICAgICAgICAoY3Rvci5kaXNwbGF5TmFtZSB8fCBjdG9yLm5hbWUpID09PSBcIkdlbmVyYXRvckZ1bmN0aW9uXCJcbiAgICAgIDogZmFsc2U7XG4gIH07XG5cbiAgZXhwb3J0cy5tYXJrID0gZnVuY3Rpb24oZ2VuRnVuKSB7XG4gICAgaWYgKE9iamVjdC5zZXRQcm90b3R5cGVPZikge1xuICAgICAgT2JqZWN0LnNldFByb3RvdHlwZU9mKGdlbkZ1biwgR2VuZXJhdG9yRnVuY3Rpb25Qcm90b3R5cGUpO1xuICAgIH0gZWxzZSB7XG4gICAgICBnZW5GdW4uX19wcm90b19fID0gR2VuZXJhdG9yRnVuY3Rpb25Qcm90b3R5cGU7XG4gICAgICBkZWZpbmUoZ2VuRnVuLCB0b1N0cmluZ1RhZ1N5bWJvbCwgXCJHZW5lcmF0b3JGdW5jdGlvblwiKTtcbiAgICB9XG4gICAgZ2VuRnVuLnByb3RvdHlwZSA9IE9iamVjdC5jcmVhdGUoR3ApO1xuICAgIHJldHVybiBnZW5GdW47XG4gIH07XG5cbiAgLy8gV2l0aGluIHRoZSBib2R5IG9mIGFueSBhc3luYyBmdW5jdGlvbiwgYGF3YWl0IHhgIGlzIHRyYW5zZm9ybWVkIHRvXG4gIC8vIGB5aWVsZCByZWdlbmVyYXRvclJ1bnRpbWUuYXdyYXAoeClgLCBzbyB0aGF0IHRoZSBydW50aW1lIGNhbiB0ZXN0XG4gIC8vIGBoYXNPd24uY2FsbCh2YWx1ZSwgXCJfX2F3YWl0XCIpYCB0byBkZXRlcm1pbmUgaWYgdGhlIHlpZWxkZWQgdmFsdWUgaXNcbiAgLy8gbWVhbnQgdG8gYmUgYXdhaXRlZC5cbiAgZXhwb3J0cy5hd3JhcCA9IGZ1bmN0aW9uKGFyZykge1xuICAgIHJldHVybiB7IF9fYXdhaXQ6IGFyZyB9O1xuICB9O1xuXG4gIGZ1bmN0aW9uIEFzeW5jSXRlcmF0b3IoZ2VuZXJhdG9yLCBQcm9taXNlSW1wbCkge1xuICAgIGZ1bmN0aW9uIGludm9rZShtZXRob2QsIGFyZywgcmVzb2x2ZSwgcmVqZWN0KSB7XG4gICAgICB2YXIgcmVjb3JkID0gdHJ5Q2F0Y2goZ2VuZXJhdG9yW21ldGhvZF0sIGdlbmVyYXRvciwgYXJnKTtcbiAgICAgIGlmIChyZWNvcmQudHlwZSA9PT0gXCJ0aHJvd1wiKSB7XG4gICAgICAgIHJlamVjdChyZWNvcmQuYXJnKTtcbiAgICAgIH0gZWxzZSB7XG4gICAgICAgIHZhciByZXN1bHQgPSByZWNvcmQuYXJnO1xuICAgICAgICB2YXIgdmFsdWUgPSByZXN1bHQudmFsdWU7XG4gICAgICAgIGlmICh2YWx1ZSAmJlxuICAgICAgICAgICAgdHlwZW9mIHZhbHVlID09PSBcIm9iamVjdFwiICYmXG4gICAgICAgICAgICBoYXNPd24uY2FsbCh2YWx1ZSwgXCJfX2F3YWl0XCIpKSB7XG4gICAgICAgICAgcmV0dXJuIFByb21pc2VJbXBsLnJlc29sdmUodmFsdWUuX19hd2FpdCkudGhlbihmdW5jdGlvbih2YWx1ZSkge1xuICAgICAgICAgICAgaW52b2tlKFwibmV4dFwiLCB2YWx1ZSwgcmVzb2x2ZSwgcmVqZWN0KTtcbiAgICAgICAgICB9LCBmdW5jdGlvbihlcnIpIHtcbiAgICAgICAgICAgIGludm9rZShcInRocm93XCIsIGVyciwgcmVzb2x2ZSwgcmVqZWN0KTtcbiAgICAgICAgICB9KTtcbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiBQcm9taXNlSW1wbC5yZXNvbHZlKHZhbHVlKS50aGVuKGZ1bmN0aW9uKHVud3JhcHBlZCkge1xuICAgICAgICAgIC8vIFdoZW4gYSB5aWVsZGVkIFByb21pc2UgaXMgcmVzb2x2ZWQsIGl0cyBmaW5hbCB2YWx1ZSBiZWNvbWVzXG4gICAgICAgICAgLy8gdGhlIC52YWx1ZSBvZiB0aGUgUHJvbWlzZTx7dmFsdWUsZG9uZX0+IHJlc3VsdCBmb3IgdGhlXG4gICAgICAgICAgLy8gY3VycmVudCBpdGVyYXRpb24uXG4gICAgICAgICAgcmVzdWx0LnZhbHVlID0gdW53cmFwcGVkO1xuICAgICAgICAgIHJlc29sdmUocmVzdWx0KTtcbiAgICAgICAgfSwgZnVuY3Rpb24oZXJyb3IpIHtcbiAgICAgICAgICAvLyBJZiBhIHJlamVjdGVkIFByb21pc2Ugd2FzIHlpZWxkZWQsIHRocm93IHRoZSByZWplY3Rpb24gYmFja1xuICAgICAgICAgIC8vIGludG8gdGhlIGFzeW5jIGdlbmVyYXRvciBmdW5jdGlvbiBzbyBpdCBjYW4gYmUgaGFuZGxlZCB0aGVyZS5cbiAgICAgICAgICByZXR1cm4gaW52b2tlKFwidGhyb3dcIiwgZXJyb3IsIHJlc29sdmUsIHJlamVjdCk7XG4gICAgICAgIH0pO1xuICAgICAgfVxuICAgIH1cblxuICAgIHZhciBwcmV2aW91c1Byb21pc2U7XG5cbiAgICBmdW5jdGlvbiBlbnF1ZXVlKG1ldGhvZCwgYXJnKSB7XG4gICAgICBmdW5jdGlvbiBjYWxsSW52b2tlV2l0aE1ldGhvZEFuZEFyZygpIHtcbiAgICAgICAgcmV0dXJuIG5ldyBQcm9taXNlSW1wbChmdW5jdGlvbihyZXNvbHZlLCByZWplY3QpIHtcbiAgICAgICAgICBpbnZva2UobWV0aG9kLCBhcmcsIHJlc29sdmUsIHJlamVjdCk7XG4gICAgICAgIH0pO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gcHJldmlvdXNQcm9taXNlID1cbiAgICAgICAgLy8gSWYgZW5xdWV1ZSBoYXMgYmVlbiBjYWxsZWQgYmVmb3JlLCB0aGVuIHdlIHdhbnQgdG8gd2FpdCB1bnRpbFxuICAgICAgICAvLyBhbGwgcHJldmlvdXMgUHJvbWlzZXMgaGF2ZSBiZWVuIHJlc29sdmVkIGJlZm9yZSBjYWxsaW5nIGludm9rZSxcbiAgICAgICAgLy8gc28gdGhhdCByZXN1bHRzIGFyZSBhbHdheXMgZGVsaXZlcmVkIGluIHRoZSBjb3JyZWN0IG9yZGVyLiBJZlxuICAgICAgICAvLyBlbnF1ZXVlIGhhcyBub3QgYmVlbiBjYWxsZWQgYmVmb3JlLCB0aGVuIGl0IGlzIGltcG9ydGFudCB0b1xuICAgICAgICAvLyBjYWxsIGludm9rZSBpbW1lZGlhdGVseSwgd2l0aG91dCB3YWl0aW5nIG9uIGEgY2FsbGJhY2sgdG8gZmlyZSxcbiAgICAgICAgLy8gc28gdGhhdCB0aGUgYXN5bmMgZ2VuZXJhdG9yIGZ1bmN0aW9uIGhhcyB0aGUgb3Bwb3J0dW5pdHkgdG8gZG9cbiAgICAgICAgLy8gYW55IG5lY2Vzc2FyeSBzZXR1cCBpbiBhIHByZWRpY3RhYmxlIHdheS4gVGhpcyBwcmVkaWN0YWJpbGl0eVxuICAgICAgICAvLyBpcyB3aHkgdGhlIFByb21pc2UgY29uc3RydWN0b3Igc3luY2hyb25vdXNseSBpbnZva2VzIGl0c1xuICAgICAgICAvLyBleGVjdXRvciBjYWxsYmFjaywgYW5kIHdoeSBhc3luYyBmdW5jdGlvbnMgc3luY2hyb25vdXNseVxuICAgICAgICAvLyBleGVjdXRlIGNvZGUgYmVmb3JlIHRoZSBmaXJzdCBhd2FpdC4gU2luY2Ugd2UgaW1wbGVtZW50IHNpbXBsZVxuICAgICAgICAvLyBhc3luYyBmdW5jdGlvbnMgaW4gdGVybXMgb2YgYXN5bmMgZ2VuZXJhdG9ycywgaXQgaXMgZXNwZWNpYWxseVxuICAgICAgICAvLyBpbXBvcnRhbnQgdG8gZ2V0IHRoaXMgcmlnaHQsIGV2ZW4gdGhvdWdoIGl0IHJlcXVpcmVzIGNhcmUuXG4gICAgICAgIHByZXZpb3VzUHJvbWlzZSA/IHByZXZpb3VzUHJvbWlzZS50aGVuKFxuICAgICAgICAgIGNhbGxJbnZva2VXaXRoTWV0aG9kQW5kQXJnLFxuICAgICAgICAgIC8vIEF2b2lkIHByb3BhZ2F0aW5nIGZhaWx1cmVzIHRvIFByb21pc2VzIHJldHVybmVkIGJ5IGxhdGVyXG4gICAgICAgICAgLy8gaW52b2NhdGlvbnMgb2YgdGhlIGl0ZXJhdG9yLlxuICAgICAgICAgIGNhbGxJbnZva2VXaXRoTWV0aG9kQW5kQXJnXG4gICAgICAgICkgOiBjYWxsSW52b2tlV2l0aE1ldGhvZEFuZEFyZygpO1xuICAgIH1cblxuICAgIC8vIERlZmluZSB0aGUgdW5pZmllZCBoZWxwZXIgbWV0aG9kIHRoYXQgaXMgdXNlZCB0byBpbXBsZW1lbnQgLm5leHQsXG4gICAgLy8gLnRocm93LCBhbmQgLnJldHVybiAoc2VlIGRlZmluZUl0ZXJhdG9yTWV0aG9kcykuXG4gICAgdGhpcy5faW52b2tlID0gZW5xdWV1ZTtcbiAgfVxuXG4gIGRlZmluZUl0ZXJhdG9yTWV0aG9kcyhBc3luY0l0ZXJhdG9yLnByb3RvdHlwZSk7XG4gIEFzeW5jSXRlcmF0b3IucHJvdG90eXBlW2FzeW5jSXRlcmF0b3JTeW1ib2xdID0gZnVuY3Rpb24gKCkge1xuICAgIHJldHVybiB0aGlzO1xuICB9O1xuICBleHBvcnRzLkFzeW5jSXRlcmF0b3IgPSBBc3luY0l0ZXJhdG9yO1xuXG4gIC8vIE5vdGUgdGhhdCBzaW1wbGUgYXN5bmMgZnVuY3Rpb25zIGFyZSBpbXBsZW1lbnRlZCBvbiB0b3Agb2ZcbiAgLy8gQXN5bmNJdGVyYXRvciBvYmplY3RzOyB0aGV5IGp1c3QgcmV0dXJuIGEgUHJvbWlzZSBmb3IgdGhlIHZhbHVlIG9mXG4gIC8vIHRoZSBmaW5hbCByZXN1bHQgcHJvZHVjZWQgYnkgdGhlIGl0ZXJhdG9yLlxuICBleHBvcnRzLmFzeW5jID0gZnVuY3Rpb24oaW5uZXJGbiwgb3V0ZXJGbiwgc2VsZiwgdHJ5TG9jc0xpc3QsIFByb21pc2VJbXBsKSB7XG4gICAgaWYgKFByb21pc2VJbXBsID09PSB2b2lkIDApIFByb21pc2VJbXBsID0gUHJvbWlzZTtcblxuICAgIHZhciBpdGVyID0gbmV3IEFzeW5jSXRlcmF0b3IoXG4gICAgICB3cmFwKGlubmVyRm4sIG91dGVyRm4sIHNlbGYsIHRyeUxvY3NMaXN0KSxcbiAgICAgIFByb21pc2VJbXBsXG4gICAgKTtcblxuICAgIHJldHVybiBleHBvcnRzLmlzR2VuZXJhdG9yRnVuY3Rpb24ob3V0ZXJGbilcbiAgICAgID8gaXRlciAvLyBJZiBvdXRlckZuIGlzIGEgZ2VuZXJhdG9yLCByZXR1cm4gdGhlIGZ1bGwgaXRlcmF0b3IuXG4gICAgICA6IGl0ZXIubmV4dCgpLnRoZW4oZnVuY3Rpb24ocmVzdWx0KSB7XG4gICAgICAgICAgcmV0dXJuIHJlc3VsdC5kb25lID8gcmVzdWx0LnZhbHVlIDogaXRlci5uZXh0KCk7XG4gICAgICAgIH0pO1xuICB9O1xuXG4gIGZ1bmN0aW9uIG1ha2VJbnZva2VNZXRob2QoaW5uZXJGbiwgc2VsZiwgY29udGV4dCkge1xuICAgIHZhciBzdGF0ZSA9IEdlblN0YXRlU3VzcGVuZGVkU3RhcnQ7XG5cbiAgICByZXR1cm4gZnVuY3Rpb24gaW52b2tlKG1ldGhvZCwgYXJnKSB7XG4gICAgICBpZiAoc3RhdGUgPT09IEdlblN0YXRlRXhlY3V0aW5nKSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcihcIkdlbmVyYXRvciBpcyBhbHJlYWR5IHJ1bm5pbmdcIik7XG4gICAgICB9XG5cbiAgICAgIGlmIChzdGF0ZSA9PT0gR2VuU3RhdGVDb21wbGV0ZWQpIHtcbiAgICAgICAgaWYgKG1ldGhvZCA9PT0gXCJ0aHJvd1wiKSB7XG4gICAgICAgICAgdGhyb3cgYXJnO1xuICAgICAgICB9XG5cbiAgICAgICAgLy8gQmUgZm9yZ2l2aW5nLCBwZXIgMjUuMy4zLjMuMyBvZiB0aGUgc3BlYzpcbiAgICAgICAgLy8gaHR0cHM6Ly9wZW9wbGUubW96aWxsYS5vcmcvfmpvcmVuZG9yZmYvZXM2LWRyYWZ0Lmh0bWwjc2VjLWdlbmVyYXRvcnJlc3VtZVxuICAgICAgICByZXR1cm4gZG9uZVJlc3VsdCgpO1xuICAgICAgfVxuXG4gICAgICBjb250ZXh0Lm1ldGhvZCA9IG1ldGhvZDtcbiAgICAgIGNvbnRleHQuYXJnID0gYXJnO1xuXG4gICAgICB3aGlsZSAodHJ1ZSkge1xuICAgICAgICB2YXIgZGVsZWdhdGUgPSBjb250ZXh0LmRlbGVnYXRlO1xuICAgICAgICBpZiAoZGVsZWdhdGUpIHtcbiAgICAgICAgICB2YXIgZGVsZWdhdGVSZXN1bHQgPSBtYXliZUludm9rZURlbGVnYXRlKGRlbGVnYXRlLCBjb250ZXh0KTtcbiAgICAgICAgICBpZiAoZGVsZWdhdGVSZXN1bHQpIHtcbiAgICAgICAgICAgIGlmIChkZWxlZ2F0ZVJlc3VsdCA9PT0gQ29udGludWVTZW50aW5lbCkgY29udGludWU7XG4gICAgICAgICAgICByZXR1cm4gZGVsZWdhdGVSZXN1bHQ7XG4gICAgICAgICAgfVxuICAgICAgICB9XG5cbiAgICAgICAgaWYgKGNvbnRleHQubWV0aG9kID09PSBcIm5leHRcIikge1xuICAgICAgICAgIC8vIFNldHRpbmcgY29udGV4dC5fc2VudCBmb3IgbGVnYWN5IHN1cHBvcnQgb2YgQmFiZWwnc1xuICAgICAgICAgIC8vIGZ1bmN0aW9uLnNlbnQgaW1wbGVtZW50YXRpb24uXG4gICAgICAgICAgY29udGV4dC5zZW50ID0gY29udGV4dC5fc2VudCA9IGNvbnRleHQuYXJnO1xuXG4gICAgICAgIH0gZWxzZSBpZiAoY29udGV4dC5tZXRob2QgPT09IFwidGhyb3dcIikge1xuICAgICAgICAgIGlmIChzdGF0ZSA9PT0gR2VuU3RhdGVTdXNwZW5kZWRTdGFydCkge1xuICAgICAgICAgICAgc3RhdGUgPSBHZW5TdGF0ZUNvbXBsZXRlZDtcbiAgICAgICAgICAgIHRocm93IGNvbnRleHQuYXJnO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIGNvbnRleHQuZGlzcGF0Y2hFeGNlcHRpb24oY29udGV4dC5hcmcpO1xuXG4gICAgICAgIH0gZWxzZSBpZiAoY29udGV4dC5tZXRob2QgPT09IFwicmV0dXJuXCIpIHtcbiAgICAgICAgICBjb250ZXh0LmFicnVwdChcInJldHVyblwiLCBjb250ZXh0LmFyZyk7XG4gICAgICAgIH1cblxuICAgICAgICBzdGF0ZSA9IEdlblN0YXRlRXhlY3V0aW5nO1xuXG4gICAgICAgIHZhciByZWNvcmQgPSB0cnlDYXRjaChpbm5lckZuLCBzZWxmLCBjb250ZXh0KTtcbiAgICAgICAgaWYgKHJlY29yZC50eXBlID09PSBcIm5vcm1hbFwiKSB7XG4gICAgICAgICAgLy8gSWYgYW4gZXhjZXB0aW9uIGlzIHRocm93biBmcm9tIGlubmVyRm4sIHdlIGxlYXZlIHN0YXRlID09PVxuICAgICAgICAgIC8vIEdlblN0YXRlRXhlY3V0aW5nIGFuZCBsb29wIGJhY2sgZm9yIGFub3RoZXIgaW52b2NhdGlvbi5cbiAgICAgICAgICBzdGF0ZSA9IGNvbnRleHQuZG9uZVxuICAgICAgICAgICAgPyBHZW5TdGF0ZUNvbXBsZXRlZFxuICAgICAgICAgICAgOiBHZW5TdGF0ZVN1c3BlbmRlZFlpZWxkO1xuXG4gICAgICAgICAgaWYgKHJlY29yZC5hcmcgPT09IENvbnRpbnVlU2VudGluZWwpIHtcbiAgICAgICAgICAgIGNvbnRpbnVlO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIHJldHVybiB7XG4gICAgICAgICAgICB2YWx1ZTogcmVjb3JkLmFyZyxcbiAgICAgICAgICAgIGRvbmU6IGNvbnRleHQuZG9uZVxuICAgICAgICAgIH07XG5cbiAgICAgICAgfSBlbHNlIGlmIChyZWNvcmQudHlwZSA9PT0gXCJ0aHJvd1wiKSB7XG4gICAgICAgICAgc3RhdGUgPSBHZW5TdGF0ZUNvbXBsZXRlZDtcbiAgICAgICAgICAvLyBEaXNwYXRjaCB0aGUgZXhjZXB0aW9uIGJ5IGxvb3BpbmcgYmFjayBhcm91bmQgdG8gdGhlXG4gICAgICAgICAgLy8gY29udGV4dC5kaXNwYXRjaEV4Y2VwdGlvbihjb250ZXh0LmFyZykgY2FsbCBhYm92ZS5cbiAgICAgICAgICBjb250ZXh0Lm1ldGhvZCA9IFwidGhyb3dcIjtcbiAgICAgICAgICBjb250ZXh0LmFyZyA9IHJlY29yZC5hcmc7XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICB9O1xuICB9XG5cbiAgLy8gQ2FsbCBkZWxlZ2F0ZS5pdGVyYXRvcltjb250ZXh0Lm1ldGhvZF0oY29udGV4dC5hcmcpIGFuZCBoYW5kbGUgdGhlXG4gIC8vIHJlc3VsdCwgZWl0aGVyIGJ5IHJldHVybmluZyBhIHsgdmFsdWUsIGRvbmUgfSByZXN1bHQgZnJvbSB0aGVcbiAgLy8gZGVsZWdhdGUgaXRlcmF0b3IsIG9yIGJ5IG1vZGlmeWluZyBjb250ZXh0Lm1ldGhvZCBhbmQgY29udGV4dC5hcmcsXG4gIC8vIHNldHRpbmcgY29udGV4dC5kZWxlZ2F0ZSB0byBudWxsLCBhbmQgcmV0dXJuaW5nIHRoZSBDb250aW51ZVNlbnRpbmVsLlxuICBmdW5jdGlvbiBtYXliZUludm9rZURlbGVnYXRlKGRlbGVnYXRlLCBjb250ZXh0KSB7XG4gICAgdmFyIG1ldGhvZCA9IGRlbGVnYXRlLml0ZXJhdG9yW2NvbnRleHQubWV0aG9kXTtcbiAgICBpZiAobWV0aG9kID09PSB1bmRlZmluZWQpIHtcbiAgICAgIC8vIEEgLnRocm93IG9yIC5yZXR1cm4gd2hlbiB0aGUgZGVsZWdhdGUgaXRlcmF0b3IgaGFzIG5vIC50aHJvd1xuICAgICAgLy8gbWV0aG9kIGFsd2F5cyB0ZXJtaW5hdGVzIHRoZSB5aWVsZCogbG9vcC5cbiAgICAgIGNvbnRleHQuZGVsZWdhdGUgPSBudWxsO1xuXG4gICAgICBpZiAoY29udGV4dC5tZXRob2QgPT09IFwidGhyb3dcIikge1xuICAgICAgICAvLyBOb3RlOiBbXCJyZXR1cm5cIl0gbXVzdCBiZSB1c2VkIGZvciBFUzMgcGFyc2luZyBjb21wYXRpYmlsaXR5LlxuICAgICAgICBpZiAoZGVsZWdhdGUuaXRlcmF0b3JbXCJyZXR1cm5cIl0pIHtcbiAgICAgICAgICAvLyBJZiB0aGUgZGVsZWdhdGUgaXRlcmF0b3IgaGFzIGEgcmV0dXJuIG1ldGhvZCwgZ2l2ZSBpdCBhXG4gICAgICAgICAgLy8gY2hhbmNlIHRvIGNsZWFuIHVwLlxuICAgICAgICAgIGNvbnRleHQubWV0aG9kID0gXCJyZXR1cm5cIjtcbiAgICAgICAgICBjb250ZXh0LmFyZyA9IHVuZGVmaW5lZDtcbiAgICAgICAgICBtYXliZUludm9rZURlbGVnYXRlKGRlbGVnYXRlLCBjb250ZXh0KTtcblxuICAgICAgICAgIGlmIChjb250ZXh0Lm1ldGhvZCA9PT0gXCJ0aHJvd1wiKSB7XG4gICAgICAgICAgICAvLyBJZiBtYXliZUludm9rZURlbGVnYXRlKGNvbnRleHQpIGNoYW5nZWQgY29udGV4dC5tZXRob2QgZnJvbVxuICAgICAgICAgICAgLy8gXCJyZXR1cm5cIiB0byBcInRocm93XCIsIGxldCB0aGF0IG92ZXJyaWRlIHRoZSBUeXBlRXJyb3IgYmVsb3cuXG4gICAgICAgICAgICByZXR1cm4gQ29udGludWVTZW50aW5lbDtcbiAgICAgICAgICB9XG4gICAgICAgIH1cblxuICAgICAgICBjb250ZXh0Lm1ldGhvZCA9IFwidGhyb3dcIjtcbiAgICAgICAgY29udGV4dC5hcmcgPSBuZXcgVHlwZUVycm9yKFxuICAgICAgICAgIFwiVGhlIGl0ZXJhdG9yIGRvZXMgbm90IHByb3ZpZGUgYSAndGhyb3cnIG1ldGhvZFwiKTtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIENvbnRpbnVlU2VudGluZWw7XG4gICAgfVxuXG4gICAgdmFyIHJlY29yZCA9IHRyeUNhdGNoKG1ldGhvZCwgZGVsZWdhdGUuaXRlcmF0b3IsIGNvbnRleHQuYXJnKTtcblxuICAgIGlmIChyZWNvcmQudHlwZSA9PT0gXCJ0aHJvd1wiKSB7XG4gICAgICBjb250ZXh0Lm1ldGhvZCA9IFwidGhyb3dcIjtcbiAgICAgIGNvbnRleHQuYXJnID0gcmVjb3JkLmFyZztcbiAgICAgIGNvbnRleHQuZGVsZWdhdGUgPSBudWxsO1xuICAgICAgcmV0dXJuIENvbnRpbnVlU2VudGluZWw7XG4gICAgfVxuXG4gICAgdmFyIGluZm8gPSByZWNvcmQuYXJnO1xuXG4gICAgaWYgKCEgaW5mbykge1xuICAgICAgY29udGV4dC5tZXRob2QgPSBcInRocm93XCI7XG4gICAgICBjb250ZXh0LmFyZyA9IG5ldyBUeXBlRXJyb3IoXCJpdGVyYXRvciByZXN1bHQgaXMgbm90IGFuIG9iamVjdFwiKTtcbiAgICAgIGNvbnRleHQuZGVsZWdhdGUgPSBudWxsO1xuICAgICAgcmV0dXJuIENvbnRpbnVlU2VudGluZWw7XG4gICAgfVxuXG4gICAgaWYgKGluZm8uZG9uZSkge1xuICAgICAgLy8gQXNzaWduIHRoZSByZXN1bHQgb2YgdGhlIGZpbmlzaGVkIGRlbGVnYXRlIHRvIHRoZSB0ZW1wb3JhcnlcbiAgICAgIC8vIHZhcmlhYmxlIHNwZWNpZmllZCBieSBkZWxlZ2F0ZS5yZXN1bHROYW1lIChzZWUgZGVsZWdhdGVZaWVsZCkuXG4gICAgICBjb250ZXh0W2RlbGVnYXRlLnJlc3VsdE5hbWVdID0gaW5mby52YWx1ZTtcblxuICAgICAgLy8gUmVzdW1lIGV4ZWN1dGlvbiBhdCB0aGUgZGVzaXJlZCBsb2NhdGlvbiAoc2VlIGRlbGVnYXRlWWllbGQpLlxuICAgICAgY29udGV4dC5uZXh0ID0gZGVsZWdhdGUubmV4dExvYztcblxuICAgICAgLy8gSWYgY29udGV4dC5tZXRob2Qgd2FzIFwidGhyb3dcIiBidXQgdGhlIGRlbGVnYXRlIGhhbmRsZWQgdGhlXG4gICAgICAvLyBleGNlcHRpb24sIGxldCB0aGUgb3V0ZXIgZ2VuZXJhdG9yIHByb2NlZWQgbm9ybWFsbHkuIElmXG4gICAgICAvLyBjb250ZXh0Lm1ldGhvZCB3YXMgXCJuZXh0XCIsIGZvcmdldCBjb250ZXh0LmFyZyBzaW5jZSBpdCBoYXMgYmVlblxuICAgICAgLy8gXCJjb25zdW1lZFwiIGJ5IHRoZSBkZWxlZ2F0ZSBpdGVyYXRvci4gSWYgY29udGV4dC5tZXRob2Qgd2FzXG4gICAgICAvLyBcInJldHVyblwiLCBhbGxvdyB0aGUgb3JpZ2luYWwgLnJldHVybiBjYWxsIHRvIGNvbnRpbnVlIGluIHRoZVxuICAgICAgLy8gb3V0ZXIgZ2VuZXJhdG9yLlxuICAgICAgaWYgKGNvbnRleHQubWV0aG9kICE9PSBcInJldHVyblwiKSB7XG4gICAgICAgIGNvbnRleHQubWV0aG9kID0gXCJuZXh0XCI7XG4gICAgICAgIGNvbnRleHQuYXJnID0gdW5kZWZpbmVkO1xuICAgICAgfVxuXG4gICAgfSBlbHNlIHtcbiAgICAgIC8vIFJlLXlpZWxkIHRoZSByZXN1bHQgcmV0dXJuZWQgYnkgdGhlIGRlbGVnYXRlIG1ldGhvZC5cbiAgICAgIHJldHVybiBpbmZvO1xuICAgIH1cblxuICAgIC8vIFRoZSBkZWxlZ2F0ZSBpdGVyYXRvciBpcyBmaW5pc2hlZCwgc28gZm9yZ2V0IGl0IGFuZCBjb250aW51ZSB3aXRoXG4gICAgLy8gdGhlIG91dGVyIGdlbmVyYXRvci5cbiAgICBjb250ZXh0LmRlbGVnYXRlID0gbnVsbDtcbiAgICByZXR1cm4gQ29udGludWVTZW50aW5lbDtcbiAgfVxuXG4gIC8vIERlZmluZSBHZW5lcmF0b3IucHJvdG90eXBlLntuZXh0LHRocm93LHJldHVybn0gaW4gdGVybXMgb2YgdGhlXG4gIC8vIHVuaWZpZWQgLl9pbnZva2UgaGVscGVyIG1ldGhvZC5cbiAgZGVmaW5lSXRlcmF0b3JNZXRob2RzKEdwKTtcblxuICBkZWZpbmUoR3AsIHRvU3RyaW5nVGFnU3ltYm9sLCBcIkdlbmVyYXRvclwiKTtcblxuICAvLyBBIEdlbmVyYXRvciBzaG91bGQgYWx3YXlzIHJldHVybiBpdHNlbGYgYXMgdGhlIGl0ZXJhdG9yIG9iamVjdCB3aGVuIHRoZVxuICAvLyBAQGl0ZXJhdG9yIGZ1bmN0aW9uIGlzIGNhbGxlZCBvbiBpdC4gU29tZSBicm93c2VycycgaW1wbGVtZW50YXRpb25zIG9mIHRoZVxuICAvLyBpdGVyYXRvciBwcm90b3R5cGUgY2hhaW4gaW5jb3JyZWN0bHkgaW1wbGVtZW50IHRoaXMsIGNhdXNpbmcgdGhlIEdlbmVyYXRvclxuICAvLyBvYmplY3QgdG8gbm90IGJlIHJldHVybmVkIGZyb20gdGhpcyBjYWxsLiBUaGlzIGVuc3VyZXMgdGhhdCBkb2Vzbid0IGhhcHBlbi5cbiAgLy8gU2VlIGh0dHBzOi8vZ2l0aHViLmNvbS9mYWNlYm9vay9yZWdlbmVyYXRvci9pc3N1ZXMvMjc0IGZvciBtb3JlIGRldGFpbHMuXG4gIEdwW2l0ZXJhdG9yU3ltYm9sXSA9IGZ1bmN0aW9uKCkge1xuICAgIHJldHVybiB0aGlzO1xuICB9O1xuXG4gIEdwLnRvU3RyaW5nID0gZnVuY3Rpb24oKSB7XG4gICAgcmV0dXJuIFwiW29iamVjdCBHZW5lcmF0b3JdXCI7XG4gIH07XG5cbiAgZnVuY3Rpb24gcHVzaFRyeUVudHJ5KGxvY3MpIHtcbiAgICB2YXIgZW50cnkgPSB7IHRyeUxvYzogbG9jc1swXSB9O1xuXG4gICAgaWYgKDEgaW4gbG9jcykge1xuICAgICAgZW50cnkuY2F0Y2hMb2MgPSBsb2NzWzFdO1xuICAgIH1cblxuICAgIGlmICgyIGluIGxvY3MpIHtcbiAgICAgIGVudHJ5LmZpbmFsbHlMb2MgPSBsb2NzWzJdO1xuICAgICAgZW50cnkuYWZ0ZXJMb2MgPSBsb2NzWzNdO1xuICAgIH1cblxuICAgIHRoaXMudHJ5RW50cmllcy5wdXNoKGVudHJ5KTtcbiAgfVxuXG4gIGZ1bmN0aW9uIHJlc2V0VHJ5RW50cnkoZW50cnkpIHtcbiAgICB2YXIgcmVjb3JkID0gZW50cnkuY29tcGxldGlvbiB8fCB7fTtcbiAgICByZWNvcmQudHlwZSA9IFwibm9ybWFsXCI7XG4gICAgZGVsZXRlIHJlY29yZC5hcmc7XG4gICAgZW50cnkuY29tcGxldGlvbiA9IHJlY29yZDtcbiAgfVxuXG4gIGZ1bmN0aW9uIENvbnRleHQodHJ5TG9jc0xpc3QpIHtcbiAgICAvLyBUaGUgcm9vdCBlbnRyeSBvYmplY3QgKGVmZmVjdGl2ZWx5IGEgdHJ5IHN0YXRlbWVudCB3aXRob3V0IGEgY2F0Y2hcbiAgICAvLyBvciBhIGZpbmFsbHkgYmxvY2spIGdpdmVzIHVzIGEgcGxhY2UgdG8gc3RvcmUgdmFsdWVzIHRocm93biBmcm9tXG4gICAgLy8gbG9jYXRpb25zIHdoZXJlIHRoZXJlIGlzIG5vIGVuY2xvc2luZyB0cnkgc3RhdGVtZW50LlxuICAgIHRoaXMudHJ5RW50cmllcyA9IFt7IHRyeUxvYzogXCJyb290XCIgfV07XG4gICAgdHJ5TG9jc0xpc3QuZm9yRWFjaChwdXNoVHJ5RW50cnksIHRoaXMpO1xuICAgIHRoaXMucmVzZXQodHJ1ZSk7XG4gIH1cblxuICBleHBvcnRzLmtleXMgPSBmdW5jdGlvbihvYmplY3QpIHtcbiAgICB2YXIga2V5cyA9IFtdO1xuICAgIGZvciAodmFyIGtleSBpbiBvYmplY3QpIHtcbiAgICAgIGtleXMucHVzaChrZXkpO1xuICAgIH1cbiAgICBrZXlzLnJldmVyc2UoKTtcblxuICAgIC8vIFJhdGhlciB0aGFuIHJldHVybmluZyBhbiBvYmplY3Qgd2l0aCBhIG5leHQgbWV0aG9kLCB3ZSBrZWVwXG4gICAgLy8gdGhpbmdzIHNpbXBsZSBhbmQgcmV0dXJuIHRoZSBuZXh0IGZ1bmN0aW9uIGl0c2VsZi5cbiAgICByZXR1cm4gZnVuY3Rpb24gbmV4dCgpIHtcbiAgICAgIHdoaWxlIChrZXlzLmxlbmd0aCkge1xuICAgICAgICB2YXIga2V5ID0ga2V5cy5wb3AoKTtcbiAgICAgICAgaWYgKGtleSBpbiBvYmplY3QpIHtcbiAgICAgICAgICBuZXh0LnZhbHVlID0ga2V5O1xuICAgICAgICAgIG5leHQuZG9uZSA9IGZhbHNlO1xuICAgICAgICAgIHJldHVybiBuZXh0O1xuICAgICAgICB9XG4gICAgICB9XG5cbiAgICAgIC8vIFRvIGF2b2lkIGNyZWF0aW5nIGFuIGFkZGl0aW9uYWwgb2JqZWN0LCB3ZSBqdXN0IGhhbmcgdGhlIC52YWx1ZVxuICAgICAgLy8gYW5kIC5kb25lIHByb3BlcnRpZXMgb2ZmIHRoZSBuZXh0IGZ1bmN0aW9uIG9iamVjdCBpdHNlbGYuIFRoaXNcbiAgICAgIC8vIGFsc28gZW5zdXJlcyB0aGF0IHRoZSBtaW5pZmllciB3aWxsIG5vdCBhbm9ueW1pemUgdGhlIGZ1bmN0aW9uLlxuICAgICAgbmV4dC5kb25lID0gdHJ1ZTtcbiAgICAgIHJldHVybiBuZXh0O1xuICAgIH07XG4gIH07XG5cbiAgZnVuY3Rpb24gdmFsdWVzKGl0ZXJhYmxlKSB7XG4gICAgaWYgKGl0ZXJhYmxlKSB7XG4gICAgICB2YXIgaXRlcmF0b3JNZXRob2QgPSBpdGVyYWJsZVtpdGVyYXRvclN5bWJvbF07XG4gICAgICBpZiAoaXRlcmF0b3JNZXRob2QpIHtcbiAgICAgICAgcmV0dXJuIGl0ZXJhdG9yTWV0aG9kLmNhbGwoaXRlcmFibGUpO1xuICAgICAgfVxuXG4gICAgICBpZiAodHlwZW9mIGl0ZXJhYmxlLm5leHQgPT09IFwiZnVuY3Rpb25cIikge1xuICAgICAgICByZXR1cm4gaXRlcmFibGU7XG4gICAgICB9XG5cbiAgICAgIGlmICghaXNOYU4oaXRlcmFibGUubGVuZ3RoKSkge1xuICAgICAgICB2YXIgaSA9IC0xLCBuZXh0ID0gZnVuY3Rpb24gbmV4dCgpIHtcbiAgICAgICAgICB3aGlsZSAoKytpIDwgaXRlcmFibGUubGVuZ3RoKSB7XG4gICAgICAgICAgICBpZiAoaGFzT3duLmNhbGwoaXRlcmFibGUsIGkpKSB7XG4gICAgICAgICAgICAgIG5leHQudmFsdWUgPSBpdGVyYWJsZVtpXTtcbiAgICAgICAgICAgICAgbmV4dC5kb25lID0gZmFsc2U7XG4gICAgICAgICAgICAgIHJldHVybiBuZXh0O1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cblxuICAgICAgICAgIG5leHQudmFsdWUgPSB1bmRlZmluZWQ7XG4gICAgICAgICAgbmV4dC5kb25lID0gdHJ1ZTtcblxuICAgICAgICAgIHJldHVybiBuZXh0O1xuICAgICAgICB9O1xuXG4gICAgICAgIHJldHVybiBuZXh0Lm5leHQgPSBuZXh0O1xuICAgICAgfVxuICAgIH1cblxuICAgIC8vIFJldHVybiBhbiBpdGVyYXRvciB3aXRoIG5vIHZhbHVlcy5cbiAgICByZXR1cm4geyBuZXh0OiBkb25lUmVzdWx0IH07XG4gIH1cbiAgZXhwb3J0cy52YWx1ZXMgPSB2YWx1ZXM7XG5cbiAgZnVuY3Rpb24gZG9uZVJlc3VsdCgpIHtcbiAgICByZXR1cm4geyB2YWx1ZTogdW5kZWZpbmVkLCBkb25lOiB0cnVlIH07XG4gIH1cblxuICBDb250ZXh0LnByb3RvdHlwZSA9IHtcbiAgICBjb25zdHJ1Y3RvcjogQ29udGV4dCxcblxuICAgIHJlc2V0OiBmdW5jdGlvbihza2lwVGVtcFJlc2V0KSB7XG4gICAgICB0aGlzLnByZXYgPSAwO1xuICAgICAgdGhpcy5uZXh0ID0gMDtcbiAgICAgIC8vIFJlc2V0dGluZyBjb250ZXh0Ll9zZW50IGZvciBsZWdhY3kgc3VwcG9ydCBvZiBCYWJlbCdzXG4gICAgICAvLyBmdW5jdGlvbi5zZW50IGltcGxlbWVudGF0aW9uLlxuICAgICAgdGhpcy5zZW50ID0gdGhpcy5fc2VudCA9IHVuZGVmaW5lZDtcbiAgICAgIHRoaXMuZG9uZSA9IGZhbHNlO1xuICAgICAgdGhpcy5kZWxlZ2F0ZSA9IG51bGw7XG5cbiAgICAgIHRoaXMubWV0aG9kID0gXCJuZXh0XCI7XG4gICAgICB0aGlzLmFyZyA9IHVuZGVmaW5lZDtcblxuICAgICAgdGhpcy50cnlFbnRyaWVzLmZvckVhY2gocmVzZXRUcnlFbnRyeSk7XG5cbiAgICAgIGlmICghc2tpcFRlbXBSZXNldCkge1xuICAgICAgICBmb3IgKHZhciBuYW1lIGluIHRoaXMpIHtcbiAgICAgICAgICAvLyBOb3Qgc3VyZSBhYm91dCB0aGUgb3B0aW1hbCBvcmRlciBvZiB0aGVzZSBjb25kaXRpb25zOlxuICAgICAgICAgIGlmIChuYW1lLmNoYXJBdCgwKSA9PT0gXCJ0XCIgJiZcbiAgICAgICAgICAgICAgaGFzT3duLmNhbGwodGhpcywgbmFtZSkgJiZcbiAgICAgICAgICAgICAgIWlzTmFOKCtuYW1lLnNsaWNlKDEpKSkge1xuICAgICAgICAgICAgdGhpc1tuYW1lXSA9IHVuZGVmaW5lZDtcbiAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICB9LFxuXG4gICAgc3RvcDogZnVuY3Rpb24oKSB7XG4gICAgICB0aGlzLmRvbmUgPSB0cnVlO1xuXG4gICAgICB2YXIgcm9vdEVudHJ5ID0gdGhpcy50cnlFbnRyaWVzWzBdO1xuICAgICAgdmFyIHJvb3RSZWNvcmQgPSByb290RW50cnkuY29tcGxldGlvbjtcbiAgICAgIGlmIChyb290UmVjb3JkLnR5cGUgPT09IFwidGhyb3dcIikge1xuICAgICAgICB0aHJvdyByb290UmVjb3JkLmFyZztcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIHRoaXMucnZhbDtcbiAgICB9LFxuXG4gICAgZGlzcGF0Y2hFeGNlcHRpb246IGZ1bmN0aW9uKGV4Y2VwdGlvbikge1xuICAgICAgaWYgKHRoaXMuZG9uZSkge1xuICAgICAgICB0aHJvdyBleGNlcHRpb247XG4gICAgICB9XG5cbiAgICAgIHZhciBjb250ZXh0ID0gdGhpcztcbiAgICAgIGZ1bmN0aW9uIGhhbmRsZShsb2MsIGNhdWdodCkge1xuICAgICAgICByZWNvcmQudHlwZSA9IFwidGhyb3dcIjtcbiAgICAgICAgcmVjb3JkLmFyZyA9IGV4Y2VwdGlvbjtcbiAgICAgICAgY29udGV4dC5uZXh0ID0gbG9jO1xuXG4gICAgICAgIGlmIChjYXVnaHQpIHtcbiAgICAgICAgICAvLyBJZiB0aGUgZGlzcGF0Y2hlZCBleGNlcHRpb24gd2FzIGNhdWdodCBieSBhIGNhdGNoIGJsb2NrLFxuICAgICAgICAgIC8vIHRoZW4gbGV0IHRoYXQgY2F0Y2ggYmxvY2sgaGFuZGxlIHRoZSBleGNlcHRpb24gbm9ybWFsbHkuXG4gICAgICAgICAgY29udGV4dC5tZXRob2QgPSBcIm5leHRcIjtcbiAgICAgICAgICBjb250ZXh0LmFyZyA9IHVuZGVmaW5lZDtcbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiAhISBjYXVnaHQ7XG4gICAgICB9XG5cbiAgICAgIGZvciAodmFyIGkgPSB0aGlzLnRyeUVudHJpZXMubGVuZ3RoIC0gMTsgaSA+PSAwOyAtLWkpIHtcbiAgICAgICAgdmFyIGVudHJ5ID0gdGhpcy50cnlFbnRyaWVzW2ldO1xuICAgICAgICB2YXIgcmVjb3JkID0gZW50cnkuY29tcGxldGlvbjtcblxuICAgICAgICBpZiAoZW50cnkudHJ5TG9jID09PSBcInJvb3RcIikge1xuICAgICAgICAgIC8vIEV4Y2VwdGlvbiB0aHJvd24gb3V0c2lkZSBvZiBhbnkgdHJ5IGJsb2NrIHRoYXQgY291bGQgaGFuZGxlXG4gICAgICAgICAgLy8gaXQsIHNvIHNldCB0aGUgY29tcGxldGlvbiB2YWx1ZSBvZiB0aGUgZW50aXJlIGZ1bmN0aW9uIHRvXG4gICAgICAgICAgLy8gdGhyb3cgdGhlIGV4Y2VwdGlvbi5cbiAgICAgICAgICByZXR1cm4gaGFuZGxlKFwiZW5kXCIpO1xuICAgICAgICB9XG5cbiAgICAgICAgaWYgKGVudHJ5LnRyeUxvYyA8PSB0aGlzLnByZXYpIHtcbiAgICAgICAgICB2YXIgaGFzQ2F0Y2ggPSBoYXNPd24uY2FsbChlbnRyeSwgXCJjYXRjaExvY1wiKTtcbiAgICAgICAgICB2YXIgaGFzRmluYWxseSA9IGhhc093bi5jYWxsKGVudHJ5LCBcImZpbmFsbHlMb2NcIik7XG5cbiAgICAgICAgICBpZiAoaGFzQ2F0Y2ggJiYgaGFzRmluYWxseSkge1xuICAgICAgICAgICAgaWYgKHRoaXMucHJldiA8IGVudHJ5LmNhdGNoTG9jKSB7XG4gICAgICAgICAgICAgIHJldHVybiBoYW5kbGUoZW50cnkuY2F0Y2hMb2MsIHRydWUpO1xuICAgICAgICAgICAgfSBlbHNlIGlmICh0aGlzLnByZXYgPCBlbnRyeS5maW5hbGx5TG9jKSB7XG4gICAgICAgICAgICAgIHJldHVybiBoYW5kbGUoZW50cnkuZmluYWxseUxvYyk7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICB9IGVsc2UgaWYgKGhhc0NhdGNoKSB7XG4gICAgICAgICAgICBpZiAodGhpcy5wcmV2IDwgZW50cnkuY2F0Y2hMb2MpIHtcbiAgICAgICAgICAgICAgcmV0dXJuIGhhbmRsZShlbnRyeS5jYXRjaExvYywgdHJ1ZSk7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICB9IGVsc2UgaWYgKGhhc0ZpbmFsbHkpIHtcbiAgICAgICAgICAgIGlmICh0aGlzLnByZXYgPCBlbnRyeS5maW5hbGx5TG9jKSB7XG4gICAgICAgICAgICAgIHJldHVybiBoYW5kbGUoZW50cnkuZmluYWxseUxvYyk7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwidHJ5IHN0YXRlbWVudCB3aXRob3V0IGNhdGNoIG9yIGZpbmFsbHlcIik7XG4gICAgICAgICAgfVxuICAgICAgICB9XG4gICAgICB9XG4gICAgfSxcblxuICAgIGFicnVwdDogZnVuY3Rpb24odHlwZSwgYXJnKSB7XG4gICAgICBmb3IgKHZhciBpID0gdGhpcy50cnlFbnRyaWVzLmxlbmd0aCAtIDE7IGkgPj0gMDsgLS1pKSB7XG4gICAgICAgIHZhciBlbnRyeSA9IHRoaXMudHJ5RW50cmllc1tpXTtcbiAgICAgICAgaWYgKGVudHJ5LnRyeUxvYyA8PSB0aGlzLnByZXYgJiZcbiAgICAgICAgICAgIGhhc093bi5jYWxsKGVudHJ5LCBcImZpbmFsbHlMb2NcIikgJiZcbiAgICAgICAgICAgIHRoaXMucHJldiA8IGVudHJ5LmZpbmFsbHlMb2MpIHtcbiAgICAgICAgICB2YXIgZmluYWxseUVudHJ5ID0gZW50cnk7XG4gICAgICAgICAgYnJlYWs7XG4gICAgICAgIH1cbiAgICAgIH1cblxuICAgICAgaWYgKGZpbmFsbHlFbnRyeSAmJlxuICAgICAgICAgICh0eXBlID09PSBcImJyZWFrXCIgfHxcbiAgICAgICAgICAgdHlwZSA9PT0gXCJjb250aW51ZVwiKSAmJlxuICAgICAgICAgIGZpbmFsbHlFbnRyeS50cnlMb2MgPD0gYXJnICYmXG4gICAgICAgICAgYXJnIDw9IGZpbmFsbHlFbnRyeS5maW5hbGx5TG9jKSB7XG4gICAgICAgIC8vIElnbm9yZSB0aGUgZmluYWxseSBlbnRyeSBpZiBjb250cm9sIGlzIG5vdCBqdW1waW5nIHRvIGFcbiAgICAgICAgLy8gbG9jYXRpb24gb3V0c2lkZSB0aGUgdHJ5L2NhdGNoIGJsb2NrLlxuICAgICAgICBmaW5hbGx5RW50cnkgPSBudWxsO1xuICAgICAgfVxuXG4gICAgICB2YXIgcmVjb3JkID0gZmluYWxseUVudHJ5ID8gZmluYWxseUVudHJ5LmNvbXBsZXRpb24gOiB7fTtcbiAgICAgIHJlY29yZC50eXBlID0gdHlwZTtcbiAgICAgIHJlY29yZC5hcmcgPSBhcmc7XG5cbiAgICAgIGlmIChmaW5hbGx5RW50cnkpIHtcbiAgICAgICAgdGhpcy5tZXRob2QgPSBcIm5leHRcIjtcbiAgICAgICAgdGhpcy5uZXh0ID0gZmluYWxseUVudHJ5LmZpbmFsbHlMb2M7XG4gICAgICAgIHJldHVybiBDb250aW51ZVNlbnRpbmVsO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gdGhpcy5jb21wbGV0ZShyZWNvcmQpO1xuICAgIH0sXG5cbiAgICBjb21wbGV0ZTogZnVuY3Rpb24ocmVjb3JkLCBhZnRlckxvYykge1xuICAgICAgaWYgKHJlY29yZC50eXBlID09PSBcInRocm93XCIpIHtcbiAgICAgICAgdGhyb3cgcmVjb3JkLmFyZztcbiAgICAgIH1cblxuICAgICAgaWYgKHJlY29yZC50eXBlID09PSBcImJyZWFrXCIgfHxcbiAgICAgICAgICByZWNvcmQudHlwZSA9PT0gXCJjb250aW51ZVwiKSB7XG4gICAgICAgIHRoaXMubmV4dCA9IHJlY29yZC5hcmc7XG4gICAgICB9IGVsc2UgaWYgKHJlY29yZC50eXBlID09PSBcInJldHVyblwiKSB7XG4gICAgICAgIHRoaXMucnZhbCA9IHRoaXMuYXJnID0gcmVjb3JkLmFyZztcbiAgICAgICAgdGhpcy5tZXRob2QgPSBcInJldHVyblwiO1xuICAgICAgICB0aGlzLm5leHQgPSBcImVuZFwiO1xuICAgICAgfSBlbHNlIGlmIChyZWNvcmQudHlwZSA9PT0gXCJub3JtYWxcIiAmJiBhZnRlckxvYykge1xuICAgICAgICB0aGlzLm5leHQgPSBhZnRlckxvYztcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIENvbnRpbnVlU2VudGluZWw7XG4gICAgfSxcblxuICAgIGZpbmlzaDogZnVuY3Rpb24oZmluYWxseUxvYykge1xuICAgICAgZm9yICh2YXIgaSA9IHRoaXMudHJ5RW50cmllcy5sZW5ndGggLSAxOyBpID49IDA7IC0taSkge1xuICAgICAgICB2YXIgZW50cnkgPSB0aGlzLnRyeUVudHJpZXNbaV07XG4gICAgICAgIGlmIChlbnRyeS5maW5hbGx5TG9jID09PSBmaW5hbGx5TG9jKSB7XG4gICAgICAgICAgdGhpcy5jb21wbGV0ZShlbnRyeS5jb21wbGV0aW9uLCBlbnRyeS5hZnRlckxvYyk7XG4gICAgICAgICAgcmVzZXRUcnlFbnRyeShlbnRyeSk7XG4gICAgICAgICAgcmV0dXJuIENvbnRpbnVlU2VudGluZWw7XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICB9LFxuXG4gICAgXCJjYXRjaFwiOiBmdW5jdGlvbih0cnlMb2MpIHtcbiAgICAgIGZvciAodmFyIGkgPSB0aGlzLnRyeUVudHJpZXMubGVuZ3RoIC0gMTsgaSA+PSAwOyAtLWkpIHtcbiAgICAgICAgdmFyIGVudHJ5ID0gdGhpcy50cnlFbnRyaWVzW2ldO1xuICAgICAgICBpZiAoZW50cnkudHJ5TG9jID09PSB0cnlMb2MpIHtcbiAgICAgICAgICB2YXIgcmVjb3JkID0gZW50cnkuY29tcGxldGlvbjtcbiAgICAgICAgICBpZiAocmVjb3JkLnR5cGUgPT09IFwidGhyb3dcIikge1xuICAgICAgICAgICAgdmFyIHRocm93biA9IHJlY29yZC5hcmc7XG4gICAgICAgICAgICByZXNldFRyeUVudHJ5KGVudHJ5KTtcbiAgICAgICAgICB9XG4gICAgICAgICAgcmV0dXJuIHRocm93bjtcbiAgICAgICAgfVxuICAgICAgfVxuXG4gICAgICAvLyBUaGUgY29udGV4dC5jYXRjaCBtZXRob2QgbXVzdCBvbmx5IGJlIGNhbGxlZCB3aXRoIGEgbG9jYXRpb25cbiAgICAgIC8vIGFyZ3VtZW50IHRoYXQgY29ycmVzcG9uZHMgdG8gYSBrbm93biBjYXRjaCBibG9jay5cbiAgICAgIHRocm93IG5ldyBFcnJvcihcImlsbGVnYWwgY2F0Y2ggYXR0ZW1wdFwiKTtcbiAgICB9LFxuXG4gICAgZGVsZWdhdGVZaWVsZDogZnVuY3Rpb24oaXRlcmFibGUsIHJlc3VsdE5hbWUsIG5leHRMb2MpIHtcbiAgICAgIHRoaXMuZGVsZWdhdGUgPSB7XG4gICAgICAgIGl0ZXJhdG9yOiB2YWx1ZXMoaXRlcmFibGUpLFxuICAgICAgICByZXN1bHROYW1lOiByZXN1bHROYW1lLFxuICAgICAgICBuZXh0TG9jOiBuZXh0TG9jXG4gICAgICB9O1xuXG4gICAgICBpZiAodGhpcy5tZXRob2QgPT09IFwibmV4dFwiKSB7XG4gICAgICAgIC8vIERlbGliZXJhdGVseSBmb3JnZXQgdGhlIGxhc3Qgc2VudCB2YWx1ZSBzbyB0aGF0IHdlIGRvbid0XG4gICAgICAgIC8vIGFjY2lkZW50YWxseSBwYXNzIGl0IG9uIHRvIHRoZSBkZWxlZ2F0ZS5cbiAgICAgICAgdGhpcy5hcmcgPSB1bmRlZmluZWQ7XG4gICAgICB9XG5cbiAgICAgIHJldHVybiBDb250aW51ZVNlbnRpbmVsO1xuICAgIH1cbiAgfTtcblxuICAvLyBSZWdhcmRsZXNzIG9mIHdoZXRoZXIgdGhpcyBzY3JpcHQgaXMgZXhlY3V0aW5nIGFzIGEgQ29tbW9uSlMgbW9kdWxlXG4gIC8vIG9yIG5vdCwgcmV0dXJuIHRoZSBydW50aW1lIG9iamVjdCBzbyB0aGF0IHdlIGNhbiBkZWNsYXJlIHRoZSB2YXJpYWJsZVxuICAvLyByZWdlbmVyYXRvclJ1bnRpbWUgaW4gdGhlIG91dGVyIHNjb3BlLCB3aGljaCBhbGxvd3MgdGhpcyBtb2R1bGUgdG8gYmVcbiAgLy8gaW5qZWN0ZWQgZWFzaWx5IGJ5IGBiaW4vcmVnZW5lcmF0b3IgLS1pbmNsdWRlLXJ1bnRpbWUgc2NyaXB0LmpzYC5cbiAgcmV0dXJuIGV4cG9ydHM7XG5cbn0oXG4gIC8vIElmIHRoaXMgc2NyaXB0IGlzIGV4ZWN1dGluZyBhcyBhIENvbW1vbkpTIG1vZHVsZSwgdXNlIG1vZHVsZS5leHBvcnRzXG4gIC8vIGFzIHRoZSByZWdlbmVyYXRvclJ1bnRpbWUgbmFtZXNwYWNlLiBPdGhlcndpc2UgY3JlYXRlIGEgbmV3IGVtcHR5XG4gIC8vIG9iamVjdC4gRWl0aGVyIHdheSwgdGhlIHJlc3VsdGluZyBvYmplY3Qgd2lsbCBiZSB1c2VkIHRvIGluaXRpYWxpemVcbiAgLy8gdGhlIHJlZ2VuZXJhdG9yUnVudGltZSB2YXJpYWJsZSBhdCB0aGUgdG9wIG9mIHRoaXMgZmlsZS5cbiAgdHlwZW9mIG1vZHVsZSA9PT0gXCJvYmplY3RcIiA/IG1vZHVsZS5leHBvcnRzIDoge31cbikpO1xuXG50cnkge1xuICByZWdlbmVyYXRvclJ1bnRpbWUgPSBydW50aW1lO1xufSBjYXRjaCAoYWNjaWRlbnRhbFN0cmljdE1vZGUpIHtcbiAgLy8gVGhpcyBtb2R1bGUgc2hvdWxkIG5vdCBiZSBydW5uaW5nIGluIHN0cmljdCBtb2RlLCBzbyB0aGUgYWJvdmVcbiAgLy8gYXNzaWdubWVudCBzaG91bGQgYWx3YXlzIHdvcmsgdW5sZXNzIHNvbWV0aGluZyBpcyBtaXNjb25maWd1cmVkLiBKdXN0XG4gIC8vIGluIGNhc2UgcnVudGltZS5qcyBhY2NpZGVudGFsbHkgcnVucyBpbiBzdHJpY3QgbW9kZSwgd2UgY2FuIGVzY2FwZVxuICAvLyBzdHJpY3QgbW9kZSB1c2luZyBhIGdsb2JhbCBGdW5jdGlvbiBjYWxsLiBUaGlzIGNvdWxkIGNvbmNlaXZhYmx5IGZhaWxcbiAgLy8gaWYgYSBDb250ZW50IFNlY3VyaXR5IFBvbGljeSBmb3JiaWRzIHVzaW5nIEZ1bmN0aW9uLCBidXQgaW4gdGhhdCBjYXNlXG4gIC8vIHRoZSBwcm9wZXIgc29sdXRpb24gaXMgdG8gZml4IHRoZSBhY2NpZGVudGFsIHN0cmljdCBtb2RlIHByb2JsZW0uIElmXG4gIC8vIHlvdSd2ZSBtaXNjb25maWd1cmVkIHlvdXIgYnVuZGxlciB0byBmb3JjZSBzdHJpY3QgbW9kZSBhbmQgYXBwbGllZCBhXG4gIC8vIENTUCB0byBmb3JiaWQgRnVuY3Rpb24sIGFuZCB5b3UncmUgbm90IHdpbGxpbmcgdG8gZml4IGVpdGhlciBvZiB0aG9zZVxuICAvLyBwcm9ibGVtcywgcGxlYXNlIGRldGFpbCB5b3VyIHVuaXF1ZSBwcmVkaWNhbWVudCBpbiBhIEdpdEh1YiBpc3N1ZS5cbiAgRnVuY3Rpb24oXCJyXCIsIFwicmVnZW5lcmF0b3JSdW50aW1lID0gclwiKShydW50aW1lKTtcbn1cbiIsIihmdW5jdGlvbiAoZ2xvYmFsLCBmYWN0b3J5KSB7XG4gIGlmICh0eXBlb2YgZGVmaW5lID09PSBcImZ1bmN0aW9uXCIgJiYgZGVmaW5lLmFtZCkge1xuICAgIGRlZmluZShcIndlYmV4dGVuc2lvbi1wb2x5ZmlsbFwiLCBbXCJtb2R1bGVcIl0sIGZhY3RvcnkpO1xuICB9IGVsc2UgaWYgKHR5cGVvZiBleHBvcnRzICE9PSBcInVuZGVmaW5lZFwiKSB7XG4gICAgZmFjdG9yeShtb2R1bGUpO1xuICB9IGVsc2Uge1xuICAgIHZhciBtb2QgPSB7XG4gICAgICBleHBvcnRzOiB7fVxuICAgIH07XG4gICAgZmFjdG9yeShtb2QpO1xuICAgIGdsb2JhbC5icm93c2VyID0gbW9kLmV4cG9ydHM7XG4gIH1cbn0pKHR5cGVvZiBnbG9iYWxUaGlzICE9PSBcInVuZGVmaW5lZFwiID8gZ2xvYmFsVGhpcyA6IHR5cGVvZiBzZWxmICE9PSBcInVuZGVmaW5lZFwiID8gc2VsZiA6IHRoaXMsIGZ1bmN0aW9uIChtb2R1bGUpIHtcbiAgLyogd2ViZXh0ZW5zaW9uLXBvbHlmaWxsIC0gdjAuOC4wIC0gVHVlIEFwciAyMCAyMDIxIDExOjI3OjM4ICovXG5cbiAgLyogLSotIE1vZGU6IGluZGVudC10YWJzLW1vZGU6IG5pbDsganMtaW5kZW50LWxldmVsOiAyIC0qLSAqL1xuXG4gIC8qIHZpbTogc2V0IHN0cz0yIHN3PTIgZXQgdHc9ODA6ICovXG5cbiAgLyogVGhpcyBTb3VyY2UgQ29kZSBGb3JtIGlzIHN1YmplY3QgdG8gdGhlIHRlcm1zIG9mIHRoZSBNb3ppbGxhIFB1YmxpY1xuICAgKiBMaWNlbnNlLCB2LiAyLjAuIElmIGEgY29weSBvZiB0aGUgTVBMIHdhcyBub3QgZGlzdHJpYnV0ZWQgd2l0aCB0aGlzXG4gICAqIGZpbGUsIFlvdSBjYW4gb2J0YWluIG9uZSBhdCBodHRwOi8vbW96aWxsYS5vcmcvTVBMLzIuMC8uICovXG4gIFwidXNlIHN0cmljdFwiO1xuXG4gIGlmICh0eXBlb2YgYnJvd3NlciA9PT0gXCJ1bmRlZmluZWRcIiB8fCBPYmplY3QuZ2V0UHJvdG90eXBlT2YoYnJvd3NlcikgIT09IE9iamVjdC5wcm90b3R5cGUpIHtcbiAgICBjb25zdCBDSFJPTUVfU0VORF9NRVNTQUdFX0NBTExCQUNLX05PX1JFU1BPTlNFX01FU1NBR0UgPSBcIlRoZSBtZXNzYWdlIHBvcnQgY2xvc2VkIGJlZm9yZSBhIHJlc3BvbnNlIHdhcyByZWNlaXZlZC5cIjtcbiAgICBjb25zdCBTRU5EX1JFU1BPTlNFX0RFUFJFQ0FUSU9OX1dBUk5JTkcgPSBcIlJldHVybmluZyBhIFByb21pc2UgaXMgdGhlIHByZWZlcnJlZCB3YXkgdG8gc2VuZCBhIHJlcGx5IGZyb20gYW4gb25NZXNzYWdlL29uTWVzc2FnZUV4dGVybmFsIGxpc3RlbmVyLCBhcyB0aGUgc2VuZFJlc3BvbnNlIHdpbGwgYmUgcmVtb3ZlZCBmcm9tIHRoZSBzcGVjcyAoU2VlIGh0dHBzOi8vZGV2ZWxvcGVyLm1vemlsbGEub3JnL2RvY3MvTW96aWxsYS9BZGQtb25zL1dlYkV4dGVuc2lvbnMvQVBJL3J1bnRpbWUvb25NZXNzYWdlKVwiOyAvLyBXcmFwcGluZyB0aGUgYnVsayBvZiB0aGlzIHBvbHlmaWxsIGluIGEgb25lLXRpbWUtdXNlIGZ1bmN0aW9uIGlzIGEgbWlub3JcbiAgICAvLyBvcHRpbWl6YXRpb24gZm9yIEZpcmVmb3guIFNpbmNlIFNwaWRlcm1vbmtleSBkb2VzIG5vdCBmdWxseSBwYXJzZSB0aGVcbiAgICAvLyBjb250ZW50cyBvZiBhIGZ1bmN0aW9uIHVudGlsIHRoZSBmaXJzdCB0aW1lIGl0J3MgY2FsbGVkLCBhbmQgc2luY2UgaXQgd2lsbFxuICAgIC8vIG5ldmVyIGFjdHVhbGx5IG5lZWQgdG8gYmUgY2FsbGVkLCB0aGlzIGFsbG93cyB0aGUgcG9seWZpbGwgdG8gYmUgaW5jbHVkZWRcbiAgICAvLyBpbiBGaXJlZm94IG5lYXJseSBmb3IgZnJlZS5cblxuICAgIGNvbnN0IHdyYXBBUElzID0gZXh0ZW5zaW9uQVBJcyA9PiB7XG4gICAgICAvLyBOT1RFOiBhcGlNZXRhZGF0YSBpcyBhc3NvY2lhdGVkIHRvIHRoZSBjb250ZW50IG9mIHRoZSBhcGktbWV0YWRhdGEuanNvbiBmaWxlXG4gICAgICAvLyBhdCBidWlsZCB0aW1lIGJ5IHJlcGxhY2luZyB0aGUgZm9sbG93aW5nIFwiaW5jbHVkZVwiIHdpdGggdGhlIGNvbnRlbnQgb2YgdGhlXG4gICAgICAvLyBKU09OIGZpbGUuXG4gICAgICBjb25zdCBhcGlNZXRhZGF0YSA9IHtcbiAgICAgICAgXCJhbGFybXNcIjoge1xuICAgICAgICAgIFwiY2xlYXJcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJjbGVhckFsbFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldEFsbFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcImJvb2ttYXJrc1wiOiB7XG4gICAgICAgICAgXCJjcmVhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRDaGlsZHJlblwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFJlY2VudFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFN1YlRyZWVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRUcmVlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwibW92ZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMixcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAyXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZVRyZWVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZWFyY2hcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJ1cGRhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDIsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJicm93c2VyQWN0aW9uXCI6IHtcbiAgICAgICAgICBcImRpc2FibGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwiZmFsbGJhY2tUb05vQ2FsbGJhY2tcIjogdHJ1ZVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJlbmFibGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwiZmFsbGJhY2tUb05vQ2FsbGJhY2tcIjogdHJ1ZVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRCYWRnZUJhY2tncm91bmRDb2xvclwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldEJhZGdlVGV4dFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFBvcHVwXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0VGl0bGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJvcGVuUG9wdXBcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZXRCYWRnZUJhY2tncm91bmRDb2xvclwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJmYWxsYmFja1RvTm9DYWxsYmFja1wiOiB0cnVlXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNldEJhZGdlVGV4dFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJmYWxsYmFja1RvTm9DYWxsYmFja1wiOiB0cnVlXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNldEljb25cIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZXRQb3B1cFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJmYWxsYmFja1RvTm9DYWxsYmFja1wiOiB0cnVlXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNldFRpdGxlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDEsXG4gICAgICAgICAgICBcImZhbGxiYWNrVG9Ob0NhbGxiYWNrXCI6IHRydWVcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwiYnJvd3NpbmdEYXRhXCI6IHtcbiAgICAgICAgICBcInJlbW92ZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMixcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAyXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZUNhY2hlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicmVtb3ZlQ29va2llc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZURvd25sb2Fkc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZUZvcm1EYXRhXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicmVtb3ZlSGlzdG9yeVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZUxvY2FsU3RvcmFnZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZVBhc3N3b3Jkc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZVBsdWdpbkRhdGFcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZXR0aW5nc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcImNvbW1hbmRzXCI6IHtcbiAgICAgICAgICBcImdldEFsbFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcImNvbnRleHRNZW51c1wiOiB7XG4gICAgICAgICAgXCJyZW1vdmVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZW1vdmVBbGxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJ1cGRhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDIsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJjb29raWVzXCI6IHtcbiAgICAgICAgICBcImdldFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldEFsbFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldEFsbENvb2tpZVN0b3Jlc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNldFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcImRldnRvb2xzXCI6IHtcbiAgICAgICAgICBcImluc3BlY3RlZFdpbmRvd1wiOiB7XG4gICAgICAgICAgICBcImV2YWxcIjoge1xuICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDIsXG4gICAgICAgICAgICAgIFwic2luZ2xlQ2FsbGJhY2tBcmdcIjogZmFsc2VcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicGFuZWxzXCI6IHtcbiAgICAgICAgICAgIFwiY3JlYXRlXCI6IHtcbiAgICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDMsXG4gICAgICAgICAgICAgIFwibWF4QXJnc1wiOiAzLFxuICAgICAgICAgICAgICBcInNpbmdsZUNhbGxiYWNrQXJnXCI6IHRydWVcbiAgICAgICAgICAgIH0sXG4gICAgICAgICAgICBcImVsZW1lbnRzXCI6IHtcbiAgICAgICAgICAgICAgXCJjcmVhdGVTaWRlYmFyUGFuZVwiOiB7XG4gICAgICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJkb3dubG9hZHNcIjoge1xuICAgICAgICAgIFwiY2FuY2VsXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZG93bmxvYWRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJlcmFzZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldEZpbGVJY29uXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDJcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwib3BlblwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJmYWxsYmFja1RvTm9DYWxsYmFja1wiOiB0cnVlXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInBhdXNlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicmVtb3ZlRmlsZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlc3VtZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNlYXJjaFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNob3dcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwiZmFsbGJhY2tUb05vQ2FsbGJhY2tcIjogdHJ1ZVxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJleHRlbnNpb25cIjoge1xuICAgICAgICAgIFwiaXNBbGxvd2VkRmlsZVNjaGVtZUFjY2Vzc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImlzQWxsb3dlZEluY29nbml0b0FjY2Vzc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcImhpc3RvcnlcIjoge1xuICAgICAgICAgIFwiYWRkVXJsXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZGVsZXRlQWxsXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZGVsZXRlUmFuZ2VcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJkZWxldGVVcmxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRWaXNpdHNcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZWFyY2hcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJpMThuXCI6IHtcbiAgICAgICAgICBcImRldGVjdExhbmd1YWdlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0QWNjZXB0TGFuZ3VhZ2VzXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwiaWRlbnRpdHlcIjoge1xuICAgICAgICAgIFwibGF1bmNoV2ViQXV0aEZsb3dcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJpZGxlXCI6IHtcbiAgICAgICAgICBcInF1ZXJ5U3RhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJtYW5hZ2VtZW50XCI6IHtcbiAgICAgICAgICBcImdldFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldEFsbFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFNlbGZcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZXRFbmFibGVkXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAyLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDJcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwidW5pbnN0YWxsU2VsZlwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcIm5vdGlmaWNhdGlvbnNcIjoge1xuICAgICAgICAgIFwiY2xlYXJcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJjcmVhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRBbGxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRQZXJtaXNzaW9uTGV2ZWxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJ1cGRhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDIsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJwYWdlQWN0aW9uXCI6IHtcbiAgICAgICAgICBcImdldFBvcHVwXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0VGl0bGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJoaWRlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDEsXG4gICAgICAgICAgICBcImZhbGxiYWNrVG9Ob0NhbGxiYWNrXCI6IHRydWVcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2V0SWNvblwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNldFBvcHVwXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDEsXG4gICAgICAgICAgICBcImZhbGxiYWNrVG9Ob0NhbGxiYWNrXCI6IHRydWVcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2V0VGl0bGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwiZmFsbGJhY2tUb05vQ2FsbGJhY2tcIjogdHJ1ZVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzaG93XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDEsXG4gICAgICAgICAgICBcImZhbGxiYWNrVG9Ob0NhbGxiYWNrXCI6IHRydWVcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwicGVybWlzc2lvbnNcIjoge1xuICAgICAgICAgIFwiY29udGFpbnNcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRBbGxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZW1vdmVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZXF1ZXN0XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwicnVudGltZVwiOiB7XG4gICAgICAgICAgXCJnZXRCYWNrZ3JvdW5kUGFnZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFBsYXRmb3JtSW5mb1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcIm9wZW5PcHRpb25zUGFnZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlcXVlc3RVcGRhdGVDaGVja1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNlbmRNZXNzYWdlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDNcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2VuZE5hdGl2ZU1lc3NhZ2VcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDIsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZXRVbmluc3RhbGxVUkxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJzZXNzaW9uc1wiOiB7XG4gICAgICAgICAgXCJnZXREZXZpY2VzXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0UmVjZW50bHlDbG9zZWRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZXN0b3JlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwic3RvcmFnZVwiOiB7XG4gICAgICAgICAgXCJsb2NhbFwiOiB7XG4gICAgICAgICAgICBcImNsZWFyXCI6IHtcbiAgICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgICB9LFxuICAgICAgICAgICAgXCJnZXRcIjoge1xuICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICAgIH0sXG4gICAgICAgICAgICBcImdldEJ5dGVzSW5Vc2VcIjoge1xuICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICAgIH0sXG4gICAgICAgICAgICBcInJlbW92ZVwiOiB7XG4gICAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgICAgfSxcbiAgICAgICAgICAgIFwic2V0XCI6IHtcbiAgICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgICB9XG4gICAgICAgICAgfSxcbiAgICAgICAgICBcIm1hbmFnZWRcIjoge1xuICAgICAgICAgICAgXCJnZXRcIjoge1xuICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICAgIH0sXG4gICAgICAgICAgICBcImdldEJ5dGVzSW5Vc2VcIjoge1xuICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic3luY1wiOiB7XG4gICAgICAgICAgICBcImNsZWFyXCI6IHtcbiAgICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgICB9LFxuICAgICAgICAgICAgXCJnZXRcIjoge1xuICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICAgIH0sXG4gICAgICAgICAgICBcImdldEJ5dGVzSW5Vc2VcIjoge1xuICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICAgIH0sXG4gICAgICAgICAgICBcInJlbW92ZVwiOiB7XG4gICAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgICAgfSxcbiAgICAgICAgICAgIFwic2V0XCI6IHtcbiAgICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgICB9XG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcInRhYnNcIjoge1xuICAgICAgICAgIFwiY2FwdHVyZVZpc2libGVUYWJcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJjcmVhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJkZXRlY3RMYW5ndWFnZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImRpc2NhcmRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJkdXBsaWNhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJleGVjdXRlU2NyaXB0XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDJcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0Q3VycmVudFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFpvb21cIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRab29tU2V0dGluZ3NcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnb0JhY2tcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnb0ZvcndhcmRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJoaWdobGlnaHRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJpbnNlcnRDU1NcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJtb3ZlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAyLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDJcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicXVlcnlcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZWxvYWRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZW1vdmVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZW1vdmVDU1NcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZW5kTWVzc2FnZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMixcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAzXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNldFpvb21cIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZXRab29tU2V0dGluZ3NcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJ1cGRhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJ0b3BTaXRlc1wiOiB7XG4gICAgICAgICAgXCJnZXRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJ3ZWJOYXZpZ2F0aW9uXCI6IHtcbiAgICAgICAgICBcImdldEFsbEZyYW1lc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldEZyYW1lXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwid2ViUmVxdWVzdFwiOiB7XG4gICAgICAgICAgXCJoYW5kbGVyQmVoYXZpb3JDaGFuZ2VkXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwid2luZG93c1wiOiB7XG4gICAgICAgICAgXCJjcmVhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRBbGxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRDdXJyZW50XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0TGFzdEZvY3VzZWRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZW1vdmVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJ1cGRhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDIsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgfTtcblxuICAgICAgaWYgKE9iamVjdC5rZXlzKGFwaU1ldGFkYXRhKS5sZW5ndGggPT09IDApIHtcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiYXBpLW1ldGFkYXRhLmpzb24gaGFzIG5vdCBiZWVuIGluY2x1ZGVkIGluIGJyb3dzZXItcG9seWZpbGxcIik7XG4gICAgICB9XG4gICAgICAvKipcbiAgICAgICAqIEEgV2Vha01hcCBzdWJjbGFzcyB3aGljaCBjcmVhdGVzIGFuZCBzdG9yZXMgYSB2YWx1ZSBmb3IgYW55IGtleSB3aGljaCBkb2VzXG4gICAgICAgKiBub3QgZXhpc3Qgd2hlbiBhY2Nlc3NlZCwgYnV0IGJlaGF2ZXMgZXhhY3RseSBhcyBhbiBvcmRpbmFyeSBXZWFrTWFwXG4gICAgICAgKiBvdGhlcndpc2UuXG4gICAgICAgKlxuICAgICAgICogQHBhcmFtIHtmdW5jdGlvbn0gY3JlYXRlSXRlbVxuICAgICAgICogICAgICAgIEEgZnVuY3Rpb24gd2hpY2ggd2lsbCBiZSBjYWxsZWQgaW4gb3JkZXIgdG8gY3JlYXRlIHRoZSB2YWx1ZSBmb3IgYW55XG4gICAgICAgKiAgICAgICAga2V5IHdoaWNoIGRvZXMgbm90IGV4aXN0LCB0aGUgZmlyc3QgdGltZSBpdCBpcyBhY2Nlc3NlZC4gVGhlXG4gICAgICAgKiAgICAgICAgZnVuY3Rpb24gcmVjZWl2ZXMsIGFzIGl0cyBvbmx5IGFyZ3VtZW50LCB0aGUga2V5IGJlaW5nIGNyZWF0ZWQuXG4gICAgICAgKi9cblxuXG4gICAgICBjbGFzcyBEZWZhdWx0V2Vha01hcCBleHRlbmRzIFdlYWtNYXAge1xuICAgICAgICBjb25zdHJ1Y3RvcihjcmVhdGVJdGVtLCBpdGVtcyA9IHVuZGVmaW5lZCkge1xuICAgICAgICAgIHN1cGVyKGl0ZW1zKTtcbiAgICAgICAgICB0aGlzLmNyZWF0ZUl0ZW0gPSBjcmVhdGVJdGVtO1xuICAgICAgICB9XG5cbiAgICAgICAgZ2V0KGtleSkge1xuICAgICAgICAgIGlmICghdGhpcy5oYXMoa2V5KSkge1xuICAgICAgICAgICAgdGhpcy5zZXQoa2V5LCB0aGlzLmNyZWF0ZUl0ZW0oa2V5KSk7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgcmV0dXJuIHN1cGVyLmdldChrZXkpO1xuICAgICAgICB9XG5cbiAgICAgIH1cbiAgICAgIC8qKlxuICAgICAgICogUmV0dXJucyB0cnVlIGlmIHRoZSBnaXZlbiBvYmplY3QgaXMgYW4gb2JqZWN0IHdpdGggYSBgdGhlbmAgbWV0aG9kLCBhbmQgY2FuXG4gICAgICAgKiB0aGVyZWZvcmUgYmUgYXNzdW1lZCB0byBiZWhhdmUgYXMgYSBQcm9taXNlLlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSB7Kn0gdmFsdWUgVGhlIHZhbHVlIHRvIHRlc3QuXG4gICAgICAgKiBAcmV0dXJucyB7Ym9vbGVhbn0gVHJ1ZSBpZiB0aGUgdmFsdWUgaXMgdGhlbmFibGUuXG4gICAgICAgKi9cblxuXG4gICAgICBjb25zdCBpc1RoZW5hYmxlID0gdmFsdWUgPT4ge1xuICAgICAgICByZXR1cm4gdmFsdWUgJiYgdHlwZW9mIHZhbHVlID09PSBcIm9iamVjdFwiICYmIHR5cGVvZiB2YWx1ZS50aGVuID09PSBcImZ1bmN0aW9uXCI7XG4gICAgICB9O1xuICAgICAgLyoqXG4gICAgICAgKiBDcmVhdGVzIGFuZCByZXR1cm5zIGEgZnVuY3Rpb24gd2hpY2gsIHdoZW4gY2FsbGVkLCB3aWxsIHJlc29sdmUgb3IgcmVqZWN0XG4gICAgICAgKiB0aGUgZ2l2ZW4gcHJvbWlzZSBiYXNlZCBvbiBob3cgaXQgaXMgY2FsbGVkOlxuICAgICAgICpcbiAgICAgICAqIC0gSWYsIHdoZW4gY2FsbGVkLCBgY2hyb21lLnJ1bnRpbWUubGFzdEVycm9yYCBjb250YWlucyBhIG5vbi1udWxsIG9iamVjdCxcbiAgICAgICAqICAgdGhlIHByb21pc2UgaXMgcmVqZWN0ZWQgd2l0aCB0aGF0IHZhbHVlLlxuICAgICAgICogLSBJZiB0aGUgZnVuY3Rpb24gaXMgY2FsbGVkIHdpdGggZXhhY3RseSBvbmUgYXJndW1lbnQsIHRoZSBwcm9taXNlIGlzXG4gICAgICAgKiAgIHJlc29sdmVkIHRvIHRoYXQgdmFsdWUuXG4gICAgICAgKiAtIE90aGVyd2lzZSwgdGhlIHByb21pc2UgaXMgcmVzb2x2ZWQgdG8gYW4gYXJyYXkgY29udGFpbmluZyBhbGwgb2YgdGhlXG4gICAgICAgKiAgIGZ1bmN0aW9uJ3MgYXJndW1lbnRzLlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSB7b2JqZWN0fSBwcm9taXNlXG4gICAgICAgKiAgICAgICAgQW4gb2JqZWN0IGNvbnRhaW5pbmcgdGhlIHJlc29sdXRpb24gYW5kIHJlamVjdGlvbiBmdW5jdGlvbnMgb2YgYVxuICAgICAgICogICAgICAgIHByb21pc2UuXG4gICAgICAgKiBAcGFyYW0ge2Z1bmN0aW9ufSBwcm9taXNlLnJlc29sdmVcbiAgICAgICAqICAgICAgICBUaGUgcHJvbWlzZSdzIHJlc29sdXRpb24gZnVuY3Rpb24uXG4gICAgICAgKiBAcGFyYW0ge2Z1bmN0aW9ufSBwcm9taXNlLnJlamVjdFxuICAgICAgICogICAgICAgIFRoZSBwcm9taXNlJ3MgcmVqZWN0aW9uIGZ1bmN0aW9uLlxuICAgICAgICogQHBhcmFtIHtvYmplY3R9IG1ldGFkYXRhXG4gICAgICAgKiAgICAgICAgTWV0YWRhdGEgYWJvdXQgdGhlIHdyYXBwZWQgbWV0aG9kIHdoaWNoIGhhcyBjcmVhdGVkIHRoZSBjYWxsYmFjay5cbiAgICAgICAqIEBwYXJhbSB7Ym9vbGVhbn0gbWV0YWRhdGEuc2luZ2xlQ2FsbGJhY2tBcmdcbiAgICAgICAqICAgICAgICBXaGV0aGVyIG9yIG5vdCB0aGUgcHJvbWlzZSBpcyByZXNvbHZlZCB3aXRoIG9ubHkgdGhlIGZpcnN0XG4gICAgICAgKiAgICAgICAgYXJndW1lbnQgb2YgdGhlIGNhbGxiYWNrLCBhbHRlcm5hdGl2ZWx5IGFuIGFycmF5IG9mIGFsbCB0aGVcbiAgICAgICAqICAgICAgICBjYWxsYmFjayBhcmd1bWVudHMgaXMgcmVzb2x2ZWQuIEJ5IGRlZmF1bHQsIGlmIHRoZSBjYWxsYmFja1xuICAgICAgICogICAgICAgIGZ1bmN0aW9uIGlzIGludm9rZWQgd2l0aCBvbmx5IGEgc2luZ2xlIGFyZ3VtZW50LCB0aGF0IHdpbGwgYmVcbiAgICAgICAqICAgICAgICByZXNvbHZlZCB0byB0aGUgcHJvbWlzZSwgd2hpbGUgYWxsIGFyZ3VtZW50cyB3aWxsIGJlIHJlc29sdmVkIGFzXG4gICAgICAgKiAgICAgICAgYW4gYXJyYXkgaWYgbXVsdGlwbGUgYXJlIGdpdmVuLlxuICAgICAgICpcbiAgICAgICAqIEByZXR1cm5zIHtmdW5jdGlvbn1cbiAgICAgICAqICAgICAgICBUaGUgZ2VuZXJhdGVkIGNhbGxiYWNrIGZ1bmN0aW9uLlxuICAgICAgICovXG5cblxuICAgICAgY29uc3QgbWFrZUNhbGxiYWNrID0gKHByb21pc2UsIG1ldGFkYXRhKSA9PiB7XG4gICAgICAgIHJldHVybiAoLi4uY2FsbGJhY2tBcmdzKSA9PiB7XG4gICAgICAgICAgaWYgKGV4dGVuc2lvbkFQSXMucnVudGltZS5sYXN0RXJyb3IpIHtcbiAgICAgICAgICAgIHByb21pc2UucmVqZWN0KG5ldyBFcnJvcihleHRlbnNpb25BUElzLnJ1bnRpbWUubGFzdEVycm9yLm1lc3NhZ2UpKTtcbiAgICAgICAgICB9IGVsc2UgaWYgKG1ldGFkYXRhLnNpbmdsZUNhbGxiYWNrQXJnIHx8IGNhbGxiYWNrQXJncy5sZW5ndGggPD0gMSAmJiBtZXRhZGF0YS5zaW5nbGVDYWxsYmFja0FyZyAhPT0gZmFsc2UpIHtcbiAgICAgICAgICAgIHByb21pc2UucmVzb2x2ZShjYWxsYmFja0FyZ3NbMF0pO1xuICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICBwcm9taXNlLnJlc29sdmUoY2FsbGJhY2tBcmdzKTtcbiAgICAgICAgICB9XG4gICAgICAgIH07XG4gICAgICB9O1xuXG4gICAgICBjb25zdCBwbHVyYWxpemVBcmd1bWVudHMgPSBudW1BcmdzID0+IG51bUFyZ3MgPT0gMSA/IFwiYXJndW1lbnRcIiA6IFwiYXJndW1lbnRzXCI7XG4gICAgICAvKipcbiAgICAgICAqIENyZWF0ZXMgYSB3cmFwcGVyIGZ1bmN0aW9uIGZvciBhIG1ldGhvZCB3aXRoIHRoZSBnaXZlbiBuYW1lIGFuZCBtZXRhZGF0YS5cbiAgICAgICAqXG4gICAgICAgKiBAcGFyYW0ge3N0cmluZ30gbmFtZVxuICAgICAgICogICAgICAgIFRoZSBuYW1lIG9mIHRoZSBtZXRob2Qgd2hpY2ggaXMgYmVpbmcgd3JhcHBlZC5cbiAgICAgICAqIEBwYXJhbSB7b2JqZWN0fSBtZXRhZGF0YVxuICAgICAgICogICAgICAgIE1ldGFkYXRhIGFib3V0IHRoZSBtZXRob2QgYmVpbmcgd3JhcHBlZC5cbiAgICAgICAqIEBwYXJhbSB7aW50ZWdlcn0gbWV0YWRhdGEubWluQXJnc1xuICAgICAgICogICAgICAgIFRoZSBtaW5pbXVtIG51bWJlciBvZiBhcmd1bWVudHMgd2hpY2ggbXVzdCBiZSBwYXNzZWQgdG8gdGhlXG4gICAgICAgKiAgICAgICAgZnVuY3Rpb24uIElmIGNhbGxlZCB3aXRoIGZld2VyIHRoYW4gdGhpcyBudW1iZXIgb2YgYXJndW1lbnRzLCB0aGVcbiAgICAgICAqICAgICAgICB3cmFwcGVyIHdpbGwgcmFpc2UgYW4gZXhjZXB0aW9uLlxuICAgICAgICogQHBhcmFtIHtpbnRlZ2VyfSBtZXRhZGF0YS5tYXhBcmdzXG4gICAgICAgKiAgICAgICAgVGhlIG1heGltdW0gbnVtYmVyIG9mIGFyZ3VtZW50cyB3aGljaCBtYXkgYmUgcGFzc2VkIHRvIHRoZVxuICAgICAgICogICAgICAgIGZ1bmN0aW9uLiBJZiBjYWxsZWQgd2l0aCBtb3JlIHRoYW4gdGhpcyBudW1iZXIgb2YgYXJndW1lbnRzLCB0aGVcbiAgICAgICAqICAgICAgICB3cmFwcGVyIHdpbGwgcmFpc2UgYW4gZXhjZXB0aW9uLlxuICAgICAgICogQHBhcmFtIHtib29sZWFufSBtZXRhZGF0YS5zaW5nbGVDYWxsYmFja0FyZ1xuICAgICAgICogICAgICAgIFdoZXRoZXIgb3Igbm90IHRoZSBwcm9taXNlIGlzIHJlc29sdmVkIHdpdGggb25seSB0aGUgZmlyc3RcbiAgICAgICAqICAgICAgICBhcmd1bWVudCBvZiB0aGUgY2FsbGJhY2ssIGFsdGVybmF0aXZlbHkgYW4gYXJyYXkgb2YgYWxsIHRoZVxuICAgICAgICogICAgICAgIGNhbGxiYWNrIGFyZ3VtZW50cyBpcyByZXNvbHZlZC4gQnkgZGVmYXVsdCwgaWYgdGhlIGNhbGxiYWNrXG4gICAgICAgKiAgICAgICAgZnVuY3Rpb24gaXMgaW52b2tlZCB3aXRoIG9ubHkgYSBzaW5nbGUgYXJndW1lbnQsIHRoYXQgd2lsbCBiZVxuICAgICAgICogICAgICAgIHJlc29sdmVkIHRvIHRoZSBwcm9taXNlLCB3aGlsZSBhbGwgYXJndW1lbnRzIHdpbGwgYmUgcmVzb2x2ZWQgYXNcbiAgICAgICAqICAgICAgICBhbiBhcnJheSBpZiBtdWx0aXBsZSBhcmUgZ2l2ZW4uXG4gICAgICAgKlxuICAgICAgICogQHJldHVybnMge2Z1bmN0aW9uKG9iamVjdCwgLi4uKil9XG4gICAgICAgKiAgICAgICBUaGUgZ2VuZXJhdGVkIHdyYXBwZXIgZnVuY3Rpb24uXG4gICAgICAgKi9cblxuXG4gICAgICBjb25zdCB3cmFwQXN5bmNGdW5jdGlvbiA9IChuYW1lLCBtZXRhZGF0YSkgPT4ge1xuICAgICAgICByZXR1cm4gZnVuY3Rpb24gYXN5bmNGdW5jdGlvbldyYXBwZXIodGFyZ2V0LCAuLi5hcmdzKSB7XG4gICAgICAgICAgaWYgKGFyZ3MubGVuZ3RoIDwgbWV0YWRhdGEubWluQXJncykge1xuICAgICAgICAgICAgdGhyb3cgbmV3IEVycm9yKGBFeHBlY3RlZCBhdCBsZWFzdCAke21ldGFkYXRhLm1pbkFyZ3N9ICR7cGx1cmFsaXplQXJndW1lbnRzKG1ldGFkYXRhLm1pbkFyZ3MpfSBmb3IgJHtuYW1lfSgpLCBnb3QgJHthcmdzLmxlbmd0aH1gKTtcbiAgICAgICAgICB9XG5cbiAgICAgICAgICBpZiAoYXJncy5sZW5ndGggPiBtZXRhZGF0YS5tYXhBcmdzKSB7XG4gICAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoYEV4cGVjdGVkIGF0IG1vc3QgJHttZXRhZGF0YS5tYXhBcmdzfSAke3BsdXJhbGl6ZUFyZ3VtZW50cyhtZXRhZGF0YS5tYXhBcmdzKX0gZm9yICR7bmFtZX0oKSwgZ290ICR7YXJncy5sZW5ndGh9YCk7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgcmV0dXJuIG5ldyBQcm9taXNlKChyZXNvbHZlLCByZWplY3QpID0+IHtcbiAgICAgICAgICAgIGlmIChtZXRhZGF0YS5mYWxsYmFja1RvTm9DYWxsYmFjaykge1xuICAgICAgICAgICAgICAvLyBUaGlzIEFQSSBtZXRob2QgaGFzIGN1cnJlbnRseSBubyBjYWxsYmFjayBvbiBDaHJvbWUsIGJ1dCBpdCByZXR1cm4gYSBwcm9taXNlIG9uIEZpcmVmb3gsXG4gICAgICAgICAgICAgIC8vIGFuZCBzbyB0aGUgcG9seWZpbGwgd2lsbCB0cnkgdG8gY2FsbCBpdCB3aXRoIGEgY2FsbGJhY2sgZmlyc3QsIGFuZCBpdCB3aWxsIGZhbGxiYWNrXG4gICAgICAgICAgICAgIC8vIHRvIG5vdCBwYXNzaW5nIHRoZSBjYWxsYmFjayBpZiB0aGUgZmlyc3QgY2FsbCBmYWlscy5cbiAgICAgICAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgICAgICB0YXJnZXRbbmFtZV0oLi4uYXJncywgbWFrZUNhbGxiYWNrKHtcbiAgICAgICAgICAgICAgICAgIHJlc29sdmUsXG4gICAgICAgICAgICAgICAgICByZWplY3RcbiAgICAgICAgICAgICAgICB9LCBtZXRhZGF0YSkpO1xuICAgICAgICAgICAgICB9IGNhdGNoIChjYkVycm9yKSB7XG4gICAgICAgICAgICAgICAgY29uc29sZS53YXJuKGAke25hbWV9IEFQSSBtZXRob2QgZG9lc24ndCBzZWVtIHRvIHN1cHBvcnQgdGhlIGNhbGxiYWNrIHBhcmFtZXRlciwgYCArIFwiZmFsbGluZyBiYWNrIHRvIGNhbGwgaXQgd2l0aG91dCBhIGNhbGxiYWNrOiBcIiwgY2JFcnJvcik7XG4gICAgICAgICAgICAgICAgdGFyZ2V0W25hbWVdKC4uLmFyZ3MpOyAvLyBVcGRhdGUgdGhlIEFQSSBtZXRob2QgbWV0YWRhdGEsIHNvIHRoYXQgdGhlIG5leHQgQVBJIGNhbGxzIHdpbGwgbm90IHRyeSB0b1xuICAgICAgICAgICAgICAgIC8vIHVzZSB0aGUgdW5zdXBwb3J0ZWQgY2FsbGJhY2sgYW55bW9yZS5cblxuICAgICAgICAgICAgICAgIG1ldGFkYXRhLmZhbGxiYWNrVG9Ob0NhbGxiYWNrID0gZmFsc2U7XG4gICAgICAgICAgICAgICAgbWV0YWRhdGEubm9DYWxsYmFjayA9IHRydWU7XG4gICAgICAgICAgICAgICAgcmVzb2x2ZSgpO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9IGVsc2UgaWYgKG1ldGFkYXRhLm5vQ2FsbGJhY2spIHtcbiAgICAgICAgICAgICAgdGFyZ2V0W25hbWVdKC4uLmFyZ3MpO1xuICAgICAgICAgICAgICByZXNvbHZlKCk7XG4gICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICB0YXJnZXRbbmFtZV0oLi4uYXJncywgbWFrZUNhbGxiYWNrKHtcbiAgICAgICAgICAgICAgICByZXNvbHZlLFxuICAgICAgICAgICAgICAgIHJlamVjdFxuICAgICAgICAgICAgICB9LCBtZXRhZGF0YSkpO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH0pO1xuICAgICAgICB9O1xuICAgICAgfTtcbiAgICAgIC8qKlxuICAgICAgICogV3JhcHMgYW4gZXhpc3RpbmcgbWV0aG9kIG9mIHRoZSB0YXJnZXQgb2JqZWN0LCBzbyB0aGF0IGNhbGxzIHRvIGl0IGFyZVxuICAgICAgICogaW50ZXJjZXB0ZWQgYnkgdGhlIGdpdmVuIHdyYXBwZXIgZnVuY3Rpb24uIFRoZSB3cmFwcGVyIGZ1bmN0aW9uIHJlY2VpdmVzLFxuICAgICAgICogYXMgaXRzIGZpcnN0IGFyZ3VtZW50LCB0aGUgb3JpZ2luYWwgYHRhcmdldGAgb2JqZWN0LCBmb2xsb3dlZCBieSBlYWNoIG9mXG4gICAgICAgKiB0aGUgYXJndW1lbnRzIHBhc3NlZCB0byB0aGUgb3JpZ2luYWwgbWV0aG9kLlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSB7b2JqZWN0fSB0YXJnZXRcbiAgICAgICAqICAgICAgICBUaGUgb3JpZ2luYWwgdGFyZ2V0IG9iamVjdCB0aGF0IHRoZSB3cmFwcGVkIG1ldGhvZCBiZWxvbmdzIHRvLlxuICAgICAgICogQHBhcmFtIHtmdW5jdGlvbn0gbWV0aG9kXG4gICAgICAgKiAgICAgICAgVGhlIG1ldGhvZCBiZWluZyB3cmFwcGVkLiBUaGlzIGlzIHVzZWQgYXMgdGhlIHRhcmdldCBvZiB0aGUgUHJveHlcbiAgICAgICAqICAgICAgICBvYmplY3Qgd2hpY2ggaXMgY3JlYXRlZCB0byB3cmFwIHRoZSBtZXRob2QuXG4gICAgICAgKiBAcGFyYW0ge2Z1bmN0aW9ufSB3cmFwcGVyXG4gICAgICAgKiAgICAgICAgVGhlIHdyYXBwZXIgZnVuY3Rpb24gd2hpY2ggaXMgY2FsbGVkIGluIHBsYWNlIG9mIGEgZGlyZWN0IGludm9jYXRpb25cbiAgICAgICAqICAgICAgICBvZiB0aGUgd3JhcHBlZCBtZXRob2QuXG4gICAgICAgKlxuICAgICAgICogQHJldHVybnMge1Byb3h5PGZ1bmN0aW9uPn1cbiAgICAgICAqICAgICAgICBBIFByb3h5IG9iamVjdCBmb3IgdGhlIGdpdmVuIG1ldGhvZCwgd2hpY2ggaW52b2tlcyB0aGUgZ2l2ZW4gd3JhcHBlclxuICAgICAgICogICAgICAgIG1ldGhvZCBpbiBpdHMgcGxhY2UuXG4gICAgICAgKi9cblxuXG4gICAgICBjb25zdCB3cmFwTWV0aG9kID0gKHRhcmdldCwgbWV0aG9kLCB3cmFwcGVyKSA9PiB7XG4gICAgICAgIHJldHVybiBuZXcgUHJveHkobWV0aG9kLCB7XG4gICAgICAgICAgYXBwbHkodGFyZ2V0TWV0aG9kLCB0aGlzT2JqLCBhcmdzKSB7XG4gICAgICAgICAgICByZXR1cm4gd3JhcHBlci5jYWxsKHRoaXNPYmosIHRhcmdldCwgLi4uYXJncyk7XG4gICAgICAgICAgfVxuXG4gICAgICAgIH0pO1xuICAgICAgfTtcblxuICAgICAgbGV0IGhhc093blByb3BlcnR5ID0gRnVuY3Rpb24uY2FsbC5iaW5kKE9iamVjdC5wcm90b3R5cGUuaGFzT3duUHJvcGVydHkpO1xuICAgICAgLyoqXG4gICAgICAgKiBXcmFwcyBhbiBvYmplY3QgaW4gYSBQcm94eSB3aGljaCBpbnRlcmNlcHRzIGFuZCB3cmFwcyBjZXJ0YWluIG1ldGhvZHNcbiAgICAgICAqIGJhc2VkIG9uIHRoZSBnaXZlbiBgd3JhcHBlcnNgIGFuZCBgbWV0YWRhdGFgIG9iamVjdHMuXG4gICAgICAgKlxuICAgICAgICogQHBhcmFtIHtvYmplY3R9IHRhcmdldFxuICAgICAgICogICAgICAgIFRoZSB0YXJnZXQgb2JqZWN0IHRvIHdyYXAuXG4gICAgICAgKlxuICAgICAgICogQHBhcmFtIHtvYmplY3R9IFt3cmFwcGVycyA9IHt9XVxuICAgICAgICogICAgICAgIEFuIG9iamVjdCB0cmVlIGNvbnRhaW5pbmcgd3JhcHBlciBmdW5jdGlvbnMgZm9yIHNwZWNpYWwgY2FzZXMuIEFueVxuICAgICAgICogICAgICAgIGZ1bmN0aW9uIHByZXNlbnQgaW4gdGhpcyBvYmplY3QgdHJlZSBpcyBjYWxsZWQgaW4gcGxhY2Ugb2YgdGhlXG4gICAgICAgKiAgICAgICAgbWV0aG9kIGluIHRoZSBzYW1lIGxvY2F0aW9uIGluIHRoZSBgdGFyZ2V0YCBvYmplY3QgdHJlZS4gVGhlc2VcbiAgICAgICAqICAgICAgICB3cmFwcGVyIG1ldGhvZHMgYXJlIGludm9rZWQgYXMgZGVzY3JpYmVkIGluIHtAc2VlIHdyYXBNZXRob2R9LlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSB7b2JqZWN0fSBbbWV0YWRhdGEgPSB7fV1cbiAgICAgICAqICAgICAgICBBbiBvYmplY3QgdHJlZSBjb250YWluaW5nIG1ldGFkYXRhIHVzZWQgdG8gYXV0b21hdGljYWxseSBnZW5lcmF0ZVxuICAgICAgICogICAgICAgIFByb21pc2UtYmFzZWQgd3JhcHBlciBmdW5jdGlvbnMgZm9yIGFzeW5jaHJvbm91cy4gQW55IGZ1bmN0aW9uIGluXG4gICAgICAgKiAgICAgICAgdGhlIGB0YXJnZXRgIG9iamVjdCB0cmVlIHdoaWNoIGhhcyBhIGNvcnJlc3BvbmRpbmcgbWV0YWRhdGEgb2JqZWN0XG4gICAgICAgKiAgICAgICAgaW4gdGhlIHNhbWUgbG9jYXRpb24gaW4gdGhlIGBtZXRhZGF0YWAgdHJlZSBpcyByZXBsYWNlZCB3aXRoIGFuXG4gICAgICAgKiAgICAgICAgYXV0b21hdGljYWxseS1nZW5lcmF0ZWQgd3JhcHBlciBmdW5jdGlvbiwgYXMgZGVzY3JpYmVkIGluXG4gICAgICAgKiAgICAgICAge0BzZWUgd3JhcEFzeW5jRnVuY3Rpb259XG4gICAgICAgKlxuICAgICAgICogQHJldHVybnMge1Byb3h5PG9iamVjdD59XG4gICAgICAgKi9cblxuICAgICAgY29uc3Qgd3JhcE9iamVjdCA9ICh0YXJnZXQsIHdyYXBwZXJzID0ge30sIG1ldGFkYXRhID0ge30pID0+IHtcbiAgICAgICAgbGV0IGNhY2hlID0gT2JqZWN0LmNyZWF0ZShudWxsKTtcbiAgICAgICAgbGV0IGhhbmRsZXJzID0ge1xuICAgICAgICAgIGhhcyhwcm94eVRhcmdldCwgcHJvcCkge1xuICAgICAgICAgICAgcmV0dXJuIHByb3AgaW4gdGFyZ2V0IHx8IHByb3AgaW4gY2FjaGU7XG4gICAgICAgICAgfSxcblxuICAgICAgICAgIGdldChwcm94eVRhcmdldCwgcHJvcCwgcmVjZWl2ZXIpIHtcbiAgICAgICAgICAgIGlmIChwcm9wIGluIGNhY2hlKSB7XG4gICAgICAgICAgICAgIHJldHVybiBjYWNoZVtwcm9wXTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgaWYgKCEocHJvcCBpbiB0YXJnZXQpKSB7XG4gICAgICAgICAgICAgIHJldHVybiB1bmRlZmluZWQ7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIGxldCB2YWx1ZSA9IHRhcmdldFtwcm9wXTtcblxuICAgICAgICAgICAgaWYgKHR5cGVvZiB2YWx1ZSA9PT0gXCJmdW5jdGlvblwiKSB7XG4gICAgICAgICAgICAgIC8vIFRoaXMgaXMgYSBtZXRob2Qgb24gdGhlIHVuZGVybHlpbmcgb2JqZWN0LiBDaGVjayBpZiB3ZSBuZWVkIHRvIGRvXG4gICAgICAgICAgICAgIC8vIGFueSB3cmFwcGluZy5cbiAgICAgICAgICAgICAgaWYgKHR5cGVvZiB3cmFwcGVyc1twcm9wXSA9PT0gXCJmdW5jdGlvblwiKSB7XG4gICAgICAgICAgICAgICAgLy8gV2UgaGF2ZSBhIHNwZWNpYWwtY2FzZSB3cmFwcGVyIGZvciB0aGlzIG1ldGhvZC5cbiAgICAgICAgICAgICAgICB2YWx1ZSA9IHdyYXBNZXRob2QodGFyZ2V0LCB0YXJnZXRbcHJvcF0sIHdyYXBwZXJzW3Byb3BdKTtcbiAgICAgICAgICAgICAgfSBlbHNlIGlmIChoYXNPd25Qcm9wZXJ0eShtZXRhZGF0YSwgcHJvcCkpIHtcbiAgICAgICAgICAgICAgICAvLyBUaGlzIGlzIGFuIGFzeW5jIG1ldGhvZCB0aGF0IHdlIGhhdmUgbWV0YWRhdGEgZm9yLiBDcmVhdGUgYVxuICAgICAgICAgICAgICAgIC8vIFByb21pc2Ugd3JhcHBlciBmb3IgaXQuXG4gICAgICAgICAgICAgICAgbGV0IHdyYXBwZXIgPSB3cmFwQXN5bmNGdW5jdGlvbihwcm9wLCBtZXRhZGF0YVtwcm9wXSk7XG4gICAgICAgICAgICAgICAgdmFsdWUgPSB3cmFwTWV0aG9kKHRhcmdldCwgdGFyZ2V0W3Byb3BdLCB3cmFwcGVyKTtcbiAgICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgICAvLyBUaGlzIGlzIGEgbWV0aG9kIHRoYXQgd2UgZG9uJ3Qga25vdyBvciBjYXJlIGFib3V0LiBSZXR1cm4gdGhlXG4gICAgICAgICAgICAgICAgLy8gb3JpZ2luYWwgbWV0aG9kLCBib3VuZCB0byB0aGUgdW5kZXJseWluZyBvYmplY3QuXG4gICAgICAgICAgICAgICAgdmFsdWUgPSB2YWx1ZS5iaW5kKHRhcmdldCk7XG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH0gZWxzZSBpZiAodHlwZW9mIHZhbHVlID09PSBcIm9iamVjdFwiICYmIHZhbHVlICE9PSBudWxsICYmIChoYXNPd25Qcm9wZXJ0eSh3cmFwcGVycywgcHJvcCkgfHwgaGFzT3duUHJvcGVydHkobWV0YWRhdGEsIHByb3ApKSkge1xuICAgICAgICAgICAgICAvLyBUaGlzIGlzIGFuIG9iamVjdCB0aGF0IHdlIG5lZWQgdG8gZG8gc29tZSB3cmFwcGluZyBmb3IgdGhlIGNoaWxkcmVuXG4gICAgICAgICAgICAgIC8vIG9mLiBDcmVhdGUgYSBzdWItb2JqZWN0IHdyYXBwZXIgZm9yIGl0IHdpdGggdGhlIGFwcHJvcHJpYXRlIGNoaWxkXG4gICAgICAgICAgICAgIC8vIG1ldGFkYXRhLlxuICAgICAgICAgICAgICB2YWx1ZSA9IHdyYXBPYmplY3QodmFsdWUsIHdyYXBwZXJzW3Byb3BdLCBtZXRhZGF0YVtwcm9wXSk7XG4gICAgICAgICAgICB9IGVsc2UgaWYgKGhhc093blByb3BlcnR5KG1ldGFkYXRhLCBcIipcIikpIHtcbiAgICAgICAgICAgICAgLy8gV3JhcCBhbGwgcHJvcGVydGllcyBpbiAqIG5hbWVzcGFjZS5cbiAgICAgICAgICAgICAgdmFsdWUgPSB3cmFwT2JqZWN0KHZhbHVlLCB3cmFwcGVyc1twcm9wXSwgbWV0YWRhdGFbXCIqXCJdKTtcbiAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgIC8vIFdlIGRvbid0IG5lZWQgdG8gZG8gYW55IHdyYXBwaW5nIGZvciB0aGlzIHByb3BlcnR5LFxuICAgICAgICAgICAgICAvLyBzbyBqdXN0IGZvcndhcmQgYWxsIGFjY2VzcyB0byB0aGUgdW5kZXJseWluZyBvYmplY3QuXG4gICAgICAgICAgICAgIE9iamVjdC5kZWZpbmVQcm9wZXJ0eShjYWNoZSwgcHJvcCwge1xuICAgICAgICAgICAgICAgIGNvbmZpZ3VyYWJsZTogdHJ1ZSxcbiAgICAgICAgICAgICAgICBlbnVtZXJhYmxlOiB0cnVlLFxuXG4gICAgICAgICAgICAgICAgZ2V0KCkge1xuICAgICAgICAgICAgICAgICAgcmV0dXJuIHRhcmdldFtwcm9wXTtcbiAgICAgICAgICAgICAgICB9LFxuXG4gICAgICAgICAgICAgICAgc2V0KHZhbHVlKSB7XG4gICAgICAgICAgICAgICAgICB0YXJnZXRbcHJvcF0gPSB2YWx1ZTtcbiAgICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgfSk7XG4gICAgICAgICAgICAgIHJldHVybiB2YWx1ZTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgY2FjaGVbcHJvcF0gPSB2YWx1ZTtcbiAgICAgICAgICAgIHJldHVybiB2YWx1ZTtcbiAgICAgICAgICB9LFxuXG4gICAgICAgICAgc2V0KHByb3h5VGFyZ2V0LCBwcm9wLCB2YWx1ZSwgcmVjZWl2ZXIpIHtcbiAgICAgICAgICAgIGlmIChwcm9wIGluIGNhY2hlKSB7XG4gICAgICAgICAgICAgIGNhY2hlW3Byb3BdID0gdmFsdWU7XG4gICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICB0YXJnZXRbcHJvcF0gPSB2YWx1ZTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgcmV0dXJuIHRydWU7XG4gICAgICAgICAgfSxcblxuICAgICAgICAgIGRlZmluZVByb3BlcnR5KHByb3h5VGFyZ2V0LCBwcm9wLCBkZXNjKSB7XG4gICAgICAgICAgICByZXR1cm4gUmVmbGVjdC5kZWZpbmVQcm9wZXJ0eShjYWNoZSwgcHJvcCwgZGVzYyk7XG4gICAgICAgICAgfSxcblxuICAgICAgICAgIGRlbGV0ZVByb3BlcnR5KHByb3h5VGFyZ2V0LCBwcm9wKSB7XG4gICAgICAgICAgICByZXR1cm4gUmVmbGVjdC5kZWxldGVQcm9wZXJ0eShjYWNoZSwgcHJvcCk7XG4gICAgICAgICAgfVxuXG4gICAgICAgIH07IC8vIFBlciBjb250cmFjdCBvZiB0aGUgUHJveHkgQVBJLCB0aGUgXCJnZXRcIiBwcm94eSBoYW5kbGVyIG11c3QgcmV0dXJuIHRoZVxuICAgICAgICAvLyBvcmlnaW5hbCB2YWx1ZSBvZiB0aGUgdGFyZ2V0IGlmIHRoYXQgdmFsdWUgaXMgZGVjbGFyZWQgcmVhZC1vbmx5IGFuZFxuICAgICAgICAvLyBub24tY29uZmlndXJhYmxlLiBGb3IgdGhpcyByZWFzb24sIHdlIGNyZWF0ZSBhbiBvYmplY3Qgd2l0aCB0aGVcbiAgICAgICAgLy8gcHJvdG90eXBlIHNldCB0byBgdGFyZ2V0YCBpbnN0ZWFkIG9mIHVzaW5nIGB0YXJnZXRgIGRpcmVjdGx5LlxuICAgICAgICAvLyBPdGhlcndpc2Ugd2UgY2Fubm90IHJldHVybiBhIGN1c3RvbSBvYmplY3QgZm9yIEFQSXMgdGhhdFxuICAgICAgICAvLyBhcmUgZGVjbGFyZWQgcmVhZC1vbmx5IGFuZCBub24tY29uZmlndXJhYmxlLCBzdWNoIGFzIGBjaHJvbWUuZGV2dG9vbHNgLlxuICAgICAgICAvL1xuICAgICAgICAvLyBUaGUgcHJveHkgaGFuZGxlcnMgdGhlbXNlbHZlcyB3aWxsIHN0aWxsIHVzZSB0aGUgb3JpZ2luYWwgYHRhcmdldGBcbiAgICAgICAgLy8gaW5zdGVhZCBvZiB0aGUgYHByb3h5VGFyZ2V0YCwgc28gdGhhdCB0aGUgbWV0aG9kcyBhbmQgcHJvcGVydGllcyBhcmVcbiAgICAgICAgLy8gZGVyZWZlcmVuY2VkIHZpYSB0aGUgb3JpZ2luYWwgdGFyZ2V0cy5cblxuICAgICAgICBsZXQgcHJveHlUYXJnZXQgPSBPYmplY3QuY3JlYXRlKHRhcmdldCk7XG4gICAgICAgIHJldHVybiBuZXcgUHJveHkocHJveHlUYXJnZXQsIGhhbmRsZXJzKTtcbiAgICAgIH07XG4gICAgICAvKipcbiAgICAgICAqIENyZWF0ZXMgYSBzZXQgb2Ygd3JhcHBlciBmdW5jdGlvbnMgZm9yIGFuIGV2ZW50IG9iamVjdCwgd2hpY2ggaGFuZGxlc1xuICAgICAgICogd3JhcHBpbmcgb2YgbGlzdGVuZXIgZnVuY3Rpb25zIHRoYXQgdGhvc2UgbWVzc2FnZXMgYXJlIHBhc3NlZC5cbiAgICAgICAqXG4gICAgICAgKiBBIHNpbmdsZSB3cmFwcGVyIGlzIGNyZWF0ZWQgZm9yIGVhY2ggbGlzdGVuZXIgZnVuY3Rpb24sIGFuZCBzdG9yZWQgaW4gYVxuICAgICAgICogbWFwLiBTdWJzZXF1ZW50IGNhbGxzIHRvIGBhZGRMaXN0ZW5lcmAsIGBoYXNMaXN0ZW5lcmAsIG9yIGByZW1vdmVMaXN0ZW5lcmBcbiAgICAgICAqIHJldHJpZXZlIHRoZSBvcmlnaW5hbCB3cmFwcGVyLCBzbyB0aGF0ICBhdHRlbXB0cyB0byByZW1vdmUgYVxuICAgICAgICogcHJldmlvdXNseS1hZGRlZCBsaXN0ZW5lciB3b3JrIGFzIGV4cGVjdGVkLlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSB7RGVmYXVsdFdlYWtNYXA8ZnVuY3Rpb24sIGZ1bmN0aW9uPn0gd3JhcHBlck1hcFxuICAgICAgICogICAgICAgIEEgRGVmYXVsdFdlYWtNYXAgb2JqZWN0IHdoaWNoIHdpbGwgY3JlYXRlIHRoZSBhcHByb3ByaWF0ZSB3cmFwcGVyXG4gICAgICAgKiAgICAgICAgZm9yIGEgZ2l2ZW4gbGlzdGVuZXIgZnVuY3Rpb24gd2hlbiBvbmUgZG9lcyBub3QgZXhpc3QsIGFuZCByZXRyaWV2ZVxuICAgICAgICogICAgICAgIGFuIGV4aXN0aW5nIG9uZSB3aGVuIGl0IGRvZXMuXG4gICAgICAgKlxuICAgICAgICogQHJldHVybnMge29iamVjdH1cbiAgICAgICAqL1xuXG5cbiAgICAgIGNvbnN0IHdyYXBFdmVudCA9IHdyYXBwZXJNYXAgPT4gKHtcbiAgICAgICAgYWRkTGlzdGVuZXIodGFyZ2V0LCBsaXN0ZW5lciwgLi4uYXJncykge1xuICAgICAgICAgIHRhcmdldC5hZGRMaXN0ZW5lcih3cmFwcGVyTWFwLmdldChsaXN0ZW5lciksIC4uLmFyZ3MpO1xuICAgICAgICB9LFxuXG4gICAgICAgIGhhc0xpc3RlbmVyKHRhcmdldCwgbGlzdGVuZXIpIHtcbiAgICAgICAgICByZXR1cm4gdGFyZ2V0Lmhhc0xpc3RlbmVyKHdyYXBwZXJNYXAuZ2V0KGxpc3RlbmVyKSk7XG4gICAgICAgIH0sXG5cbiAgICAgICAgcmVtb3ZlTGlzdGVuZXIodGFyZ2V0LCBsaXN0ZW5lcikge1xuICAgICAgICAgIHRhcmdldC5yZW1vdmVMaXN0ZW5lcih3cmFwcGVyTWFwLmdldChsaXN0ZW5lcikpO1xuICAgICAgICB9XG5cbiAgICAgIH0pO1xuXG4gICAgICBjb25zdCBvblJlcXVlc3RGaW5pc2hlZFdyYXBwZXJzID0gbmV3IERlZmF1bHRXZWFrTWFwKGxpc3RlbmVyID0+IHtcbiAgICAgICAgaWYgKHR5cGVvZiBsaXN0ZW5lciAhPT0gXCJmdW5jdGlvblwiKSB7XG4gICAgICAgICAgcmV0dXJuIGxpc3RlbmVyO1xuICAgICAgICB9XG4gICAgICAgIC8qKlxuICAgICAgICAgKiBXcmFwcyBhbiBvblJlcXVlc3RGaW5pc2hlZCBsaXN0ZW5lciBmdW5jdGlvbiBzbyB0aGF0IGl0IHdpbGwgcmV0dXJuIGFcbiAgICAgICAgICogYGdldENvbnRlbnQoKWAgcHJvcGVydHkgd2hpY2ggcmV0dXJucyBhIGBQcm9taXNlYCByYXRoZXIgdGhhbiB1c2luZyBhXG4gICAgICAgICAqIGNhbGxiYWNrIEFQSS5cbiAgICAgICAgICpcbiAgICAgICAgICogQHBhcmFtIHtvYmplY3R9IHJlcVxuICAgICAgICAgKiAgICAgICAgVGhlIEhBUiBlbnRyeSBvYmplY3QgcmVwcmVzZW50aW5nIHRoZSBuZXR3b3JrIHJlcXVlc3QuXG4gICAgICAgICAqL1xuXG5cbiAgICAgICAgcmV0dXJuIGZ1bmN0aW9uIG9uUmVxdWVzdEZpbmlzaGVkKHJlcSkge1xuICAgICAgICAgIGNvbnN0IHdyYXBwZWRSZXEgPSB3cmFwT2JqZWN0KHJlcSwge31cbiAgICAgICAgICAvKiB3cmFwcGVycyAqL1xuICAgICAgICAgICwge1xuICAgICAgICAgICAgZ2V0Q29udGVudDoge1xuICAgICAgICAgICAgICBtaW5BcmdzOiAwLFxuICAgICAgICAgICAgICBtYXhBcmdzOiAwXG4gICAgICAgICAgICB9XG4gICAgICAgICAgfSk7XG4gICAgICAgICAgbGlzdGVuZXIod3JhcHBlZFJlcSk7XG4gICAgICAgIH07XG4gICAgICB9KTsgLy8gS2VlcCB0cmFjayBpZiB0aGUgZGVwcmVjYXRpb24gd2FybmluZyBoYXMgYmVlbiBsb2dnZWQgYXQgbGVhc3Qgb25jZS5cblxuICAgICAgbGV0IGxvZ2dlZFNlbmRSZXNwb25zZURlcHJlY2F0aW9uV2FybmluZyA9IGZhbHNlO1xuICAgICAgY29uc3Qgb25NZXNzYWdlV3JhcHBlcnMgPSBuZXcgRGVmYXVsdFdlYWtNYXAobGlzdGVuZXIgPT4ge1xuICAgICAgICBpZiAodHlwZW9mIGxpc3RlbmVyICE9PSBcImZ1bmN0aW9uXCIpIHtcbiAgICAgICAgICByZXR1cm4gbGlzdGVuZXI7XG4gICAgICAgIH1cbiAgICAgICAgLyoqXG4gICAgICAgICAqIFdyYXBzIGEgbWVzc2FnZSBsaXN0ZW5lciBmdW5jdGlvbiBzbyB0aGF0IGl0IG1heSBzZW5kIHJlc3BvbnNlcyBiYXNlZCBvblxuICAgICAgICAgKiBpdHMgcmV0dXJuIHZhbHVlLCByYXRoZXIgdGhhbiBieSByZXR1cm5pbmcgYSBzZW50aW5lbCB2YWx1ZSBhbmQgY2FsbGluZyBhXG4gICAgICAgICAqIGNhbGxiYWNrLiBJZiB0aGUgbGlzdGVuZXIgZnVuY3Rpb24gcmV0dXJucyBhIFByb21pc2UsIHRoZSByZXNwb25zZSBpc1xuICAgICAgICAgKiBzZW50IHdoZW4gdGhlIHByb21pc2UgZWl0aGVyIHJlc29sdmVzIG9yIHJlamVjdHMuXG4gICAgICAgICAqXG4gICAgICAgICAqIEBwYXJhbSB7Kn0gbWVzc2FnZVxuICAgICAgICAgKiAgICAgICAgVGhlIG1lc3NhZ2Ugc2VudCBieSB0aGUgb3RoZXIgZW5kIG9mIHRoZSBjaGFubmVsLlxuICAgICAgICAgKiBAcGFyYW0ge29iamVjdH0gc2VuZGVyXG4gICAgICAgICAqICAgICAgICBEZXRhaWxzIGFib3V0IHRoZSBzZW5kZXIgb2YgdGhlIG1lc3NhZ2UuXG4gICAgICAgICAqIEBwYXJhbSB7ZnVuY3Rpb24oKil9IHNlbmRSZXNwb25zZVxuICAgICAgICAgKiAgICAgICAgQSBjYWxsYmFjayB3aGljaCwgd2hlbiBjYWxsZWQgd2l0aCBhbiBhcmJpdHJhcnkgYXJndW1lbnQsIHNlbmRzXG4gICAgICAgICAqICAgICAgICB0aGF0IHZhbHVlIGFzIGEgcmVzcG9uc2UuXG4gICAgICAgICAqIEByZXR1cm5zIHtib29sZWFufVxuICAgICAgICAgKiAgICAgICAgVHJ1ZSBpZiB0aGUgd3JhcHBlZCBsaXN0ZW5lciByZXR1cm5lZCBhIFByb21pc2UsIHdoaWNoIHdpbGwgbGF0ZXJcbiAgICAgICAgICogICAgICAgIHlpZWxkIGEgcmVzcG9uc2UuIEZhbHNlIG90aGVyd2lzZS5cbiAgICAgICAgICovXG5cblxuICAgICAgICByZXR1cm4gZnVuY3Rpb24gb25NZXNzYWdlKG1lc3NhZ2UsIHNlbmRlciwgc2VuZFJlc3BvbnNlKSB7XG4gICAgICAgICAgbGV0IGRpZENhbGxTZW5kUmVzcG9uc2UgPSBmYWxzZTtcbiAgICAgICAgICBsZXQgd3JhcHBlZFNlbmRSZXNwb25zZTtcbiAgICAgICAgICBsZXQgc2VuZFJlc3BvbnNlUHJvbWlzZSA9IG5ldyBQcm9taXNlKHJlc29sdmUgPT4ge1xuICAgICAgICAgICAgd3JhcHBlZFNlbmRSZXNwb25zZSA9IGZ1bmN0aW9uIChyZXNwb25zZSkge1xuICAgICAgICAgICAgICBpZiAoIWxvZ2dlZFNlbmRSZXNwb25zZURlcHJlY2F0aW9uV2FybmluZykge1xuICAgICAgICAgICAgICAgIGNvbnNvbGUud2FybihTRU5EX1JFU1BPTlNFX0RFUFJFQ0FUSU9OX1dBUk5JTkcsIG5ldyBFcnJvcigpLnN0YWNrKTtcbiAgICAgICAgICAgICAgICBsb2dnZWRTZW5kUmVzcG9uc2VEZXByZWNhdGlvbldhcm5pbmcgPSB0cnVlO1xuICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgZGlkQ2FsbFNlbmRSZXNwb25zZSA9IHRydWU7XG4gICAgICAgICAgICAgIHJlc29sdmUocmVzcG9uc2UpO1xuICAgICAgICAgICAgfTtcbiAgICAgICAgICB9KTtcbiAgICAgICAgICBsZXQgcmVzdWx0O1xuXG4gICAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgIHJlc3VsdCA9IGxpc3RlbmVyKG1lc3NhZ2UsIHNlbmRlciwgd3JhcHBlZFNlbmRSZXNwb25zZSk7XG4gICAgICAgICAgfSBjYXRjaCAoZXJyKSB7XG4gICAgICAgICAgICByZXN1bHQgPSBQcm9taXNlLnJlamVjdChlcnIpO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIGNvbnN0IGlzUmVzdWx0VGhlbmFibGUgPSByZXN1bHQgIT09IHRydWUgJiYgaXNUaGVuYWJsZShyZXN1bHQpOyAvLyBJZiB0aGUgbGlzdGVuZXIgZGlkbid0IHJldHVybmVkIHRydWUgb3IgYSBQcm9taXNlLCBvciBjYWxsZWRcbiAgICAgICAgICAvLyB3cmFwcGVkU2VuZFJlc3BvbnNlIHN5bmNocm9ub3VzbHksIHdlIGNhbiBleGl0IGVhcmxpZXJcbiAgICAgICAgICAvLyBiZWNhdXNlIHRoZXJlIHdpbGwgYmUgbm8gcmVzcG9uc2Ugc2VudCBmcm9tIHRoaXMgbGlzdGVuZXIuXG5cbiAgICAgICAgICBpZiAocmVzdWx0ICE9PSB0cnVlICYmICFpc1Jlc3VsdFRoZW5hYmxlICYmICFkaWRDYWxsU2VuZFJlc3BvbnNlKSB7XG4gICAgICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICAgICAgfSAvLyBBIHNtYWxsIGhlbHBlciB0byBzZW5kIHRoZSBtZXNzYWdlIGlmIHRoZSBwcm9taXNlIHJlc29sdmVzXG4gICAgICAgICAgLy8gYW5kIGFuIGVycm9yIGlmIHRoZSBwcm9taXNlIHJlamVjdHMgKGEgd3JhcHBlZCBzZW5kTWVzc2FnZSBoYXNcbiAgICAgICAgICAvLyB0byB0cmFuc2xhdGUgdGhlIG1lc3NhZ2UgaW50byBhIHJlc29sdmVkIHByb21pc2Ugb3IgYSByZWplY3RlZFxuICAgICAgICAgIC8vIHByb21pc2UpLlxuXG5cbiAgICAgICAgICBjb25zdCBzZW5kUHJvbWlzZWRSZXN1bHQgPSBwcm9taXNlID0+IHtcbiAgICAgICAgICAgIHByb21pc2UudGhlbihtc2cgPT4ge1xuICAgICAgICAgICAgICAvLyBzZW5kIHRoZSBtZXNzYWdlIHZhbHVlLlxuICAgICAgICAgICAgICBzZW5kUmVzcG9uc2UobXNnKTtcbiAgICAgICAgICAgIH0sIGVycm9yID0+IHtcbiAgICAgICAgICAgICAgLy8gU2VuZCBhIEpTT04gcmVwcmVzZW50YXRpb24gb2YgdGhlIGVycm9yIGlmIHRoZSByZWplY3RlZCB2YWx1ZVxuICAgICAgICAgICAgICAvLyBpcyBhbiBpbnN0YW5jZSBvZiBlcnJvciwgb3IgdGhlIG9iamVjdCBpdHNlbGYgb3RoZXJ3aXNlLlxuICAgICAgICAgICAgICBsZXQgbWVzc2FnZTtcblxuICAgICAgICAgICAgICBpZiAoZXJyb3IgJiYgKGVycm9yIGluc3RhbmNlb2YgRXJyb3IgfHwgdHlwZW9mIGVycm9yLm1lc3NhZ2UgPT09IFwic3RyaW5nXCIpKSB7XG4gICAgICAgICAgICAgICAgbWVzc2FnZSA9IGVycm9yLm1lc3NhZ2U7XG4gICAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgICAgbWVzc2FnZSA9IFwiQW4gdW5leHBlY3RlZCBlcnJvciBvY2N1cnJlZFwiO1xuICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgc2VuZFJlc3BvbnNlKHtcbiAgICAgICAgICAgICAgICBfX21veldlYkV4dGVuc2lvblBvbHlmaWxsUmVqZWN0X186IHRydWUsXG4gICAgICAgICAgICAgICAgbWVzc2FnZVxuICAgICAgICAgICAgICB9KTtcbiAgICAgICAgICAgIH0pLmNhdGNoKGVyciA9PiB7XG4gICAgICAgICAgICAgIC8vIFByaW50IGFuIGVycm9yIG9uIHRoZSBjb25zb2xlIGlmIHVuYWJsZSB0byBzZW5kIHRoZSByZXNwb25zZS5cbiAgICAgICAgICAgICAgY29uc29sZS5lcnJvcihcIkZhaWxlZCB0byBzZW5kIG9uTWVzc2FnZSByZWplY3RlZCByZXBseVwiLCBlcnIpO1xuICAgICAgICAgICAgfSk7XG4gICAgICAgICAgfTsgLy8gSWYgdGhlIGxpc3RlbmVyIHJldHVybmVkIGEgUHJvbWlzZSwgc2VuZCB0aGUgcmVzb2x2ZWQgdmFsdWUgYXMgYVxuICAgICAgICAgIC8vIHJlc3VsdCwgb3RoZXJ3aXNlIHdhaXQgdGhlIHByb21pc2UgcmVsYXRlZCB0byB0aGUgd3JhcHBlZFNlbmRSZXNwb25zZVxuICAgICAgICAgIC8vIGNhbGxiYWNrIHRvIHJlc29sdmUgYW5kIHNlbmQgaXQgYXMgYSByZXNwb25zZS5cblxuXG4gICAgICAgICAgaWYgKGlzUmVzdWx0VGhlbmFibGUpIHtcbiAgICAgICAgICAgIHNlbmRQcm9taXNlZFJlc3VsdChyZXN1bHQpO1xuICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICBzZW5kUHJvbWlzZWRSZXN1bHQoc2VuZFJlc3BvbnNlUHJvbWlzZSk7XG4gICAgICAgICAgfSAvLyBMZXQgQ2hyb21lIGtub3cgdGhhdCB0aGUgbGlzdGVuZXIgaXMgcmVwbHlpbmcuXG5cblxuICAgICAgICAgIHJldHVybiB0cnVlO1xuICAgICAgICB9O1xuICAgICAgfSk7XG5cbiAgICAgIGNvbnN0IHdyYXBwZWRTZW5kTWVzc2FnZUNhbGxiYWNrID0gKHtcbiAgICAgICAgcmVqZWN0LFxuICAgICAgICByZXNvbHZlXG4gICAgICB9LCByZXBseSkgPT4ge1xuICAgICAgICBpZiAoZXh0ZW5zaW9uQVBJcy5ydW50aW1lLmxhc3RFcnJvcikge1xuICAgICAgICAgIC8vIERldGVjdCB3aGVuIG5vbmUgb2YgdGhlIGxpc3RlbmVycyByZXBsaWVkIHRvIHRoZSBzZW5kTWVzc2FnZSBjYWxsIGFuZCByZXNvbHZlXG4gICAgICAgICAgLy8gdGhlIHByb21pc2UgdG8gdW5kZWZpbmVkIGFzIGluIEZpcmVmb3guXG4gICAgICAgICAgLy8gU2VlIGh0dHBzOi8vZ2l0aHViLmNvbS9tb3ppbGxhL3dlYmV4dGVuc2lvbi1wb2x5ZmlsbC9pc3N1ZXMvMTMwXG4gICAgICAgICAgaWYgKGV4dGVuc2lvbkFQSXMucnVudGltZS5sYXN0RXJyb3IubWVzc2FnZSA9PT0gQ0hST01FX1NFTkRfTUVTU0FHRV9DQUxMQkFDS19OT19SRVNQT05TRV9NRVNTQUdFKSB7XG4gICAgICAgICAgICByZXNvbHZlKCk7XG4gICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIHJlamVjdChuZXcgRXJyb3IoZXh0ZW5zaW9uQVBJcy5ydW50aW1lLmxhc3RFcnJvci5tZXNzYWdlKSk7XG4gICAgICAgICAgfVxuICAgICAgICB9IGVsc2UgaWYgKHJlcGx5ICYmIHJlcGx5Ll9fbW96V2ViRXh0ZW5zaW9uUG9seWZpbGxSZWplY3RfXykge1xuICAgICAgICAgIC8vIENvbnZlcnQgYmFjayB0aGUgSlNPTiByZXByZXNlbnRhdGlvbiBvZiB0aGUgZXJyb3IgaW50b1xuICAgICAgICAgIC8vIGFuIEVycm9yIGluc3RhbmNlLlxuICAgICAgICAgIHJlamVjdChuZXcgRXJyb3IocmVwbHkubWVzc2FnZSkpO1xuICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgIHJlc29sdmUocmVwbHkpO1xuICAgICAgICB9XG4gICAgICB9O1xuXG4gICAgICBjb25zdCB3cmFwcGVkU2VuZE1lc3NhZ2UgPSAobmFtZSwgbWV0YWRhdGEsIGFwaU5hbWVzcGFjZU9iaiwgLi4uYXJncykgPT4ge1xuICAgICAgICBpZiAoYXJncy5sZW5ndGggPCBtZXRhZGF0YS5taW5BcmdzKSB7XG4gICAgICAgICAgdGhyb3cgbmV3IEVycm9yKGBFeHBlY3RlZCBhdCBsZWFzdCAke21ldGFkYXRhLm1pbkFyZ3N9ICR7cGx1cmFsaXplQXJndW1lbnRzKG1ldGFkYXRhLm1pbkFyZ3MpfSBmb3IgJHtuYW1lfSgpLCBnb3QgJHthcmdzLmxlbmd0aH1gKTtcbiAgICAgICAgfVxuXG4gICAgICAgIGlmIChhcmdzLmxlbmd0aCA+IG1ldGFkYXRhLm1heEFyZ3MpIHtcbiAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoYEV4cGVjdGVkIGF0IG1vc3QgJHttZXRhZGF0YS5tYXhBcmdzfSAke3BsdXJhbGl6ZUFyZ3VtZW50cyhtZXRhZGF0YS5tYXhBcmdzKX0gZm9yICR7bmFtZX0oKSwgZ290ICR7YXJncy5sZW5ndGh9YCk7XG4gICAgICAgIH1cblxuICAgICAgICByZXR1cm4gbmV3IFByb21pc2UoKHJlc29sdmUsIHJlamVjdCkgPT4ge1xuICAgICAgICAgIGNvbnN0IHdyYXBwZWRDYiA9IHdyYXBwZWRTZW5kTWVzc2FnZUNhbGxiYWNrLmJpbmQobnVsbCwge1xuICAgICAgICAgICAgcmVzb2x2ZSxcbiAgICAgICAgICAgIHJlamVjdFxuICAgICAgICAgIH0pO1xuICAgICAgICAgIGFyZ3MucHVzaCh3cmFwcGVkQ2IpO1xuICAgICAgICAgIGFwaU5hbWVzcGFjZU9iai5zZW5kTWVzc2FnZSguLi5hcmdzKTtcbiAgICAgICAgfSk7XG4gICAgICB9O1xuXG4gICAgICBjb25zdCBzdGF0aWNXcmFwcGVycyA9IHtcbiAgICAgICAgZGV2dG9vbHM6IHtcbiAgICAgICAgICBuZXR3b3JrOiB7XG4gICAgICAgICAgICBvblJlcXVlc3RGaW5pc2hlZDogd3JhcEV2ZW50KG9uUmVxdWVzdEZpbmlzaGVkV3JhcHBlcnMpXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBydW50aW1lOiB7XG4gICAgICAgICAgb25NZXNzYWdlOiB3cmFwRXZlbnQob25NZXNzYWdlV3JhcHBlcnMpLFxuICAgICAgICAgIG9uTWVzc2FnZUV4dGVybmFsOiB3cmFwRXZlbnQob25NZXNzYWdlV3JhcHBlcnMpLFxuICAgICAgICAgIHNlbmRNZXNzYWdlOiB3cmFwcGVkU2VuZE1lc3NhZ2UuYmluZChudWxsLCBcInNlbmRNZXNzYWdlXCIsIHtcbiAgICAgICAgICAgIG1pbkFyZ3M6IDEsXG4gICAgICAgICAgICBtYXhBcmdzOiAzXG4gICAgICAgICAgfSlcbiAgICAgICAgfSxcbiAgICAgICAgdGFiczoge1xuICAgICAgICAgIHNlbmRNZXNzYWdlOiB3cmFwcGVkU2VuZE1lc3NhZ2UuYmluZChudWxsLCBcInNlbmRNZXNzYWdlXCIsIHtcbiAgICAgICAgICAgIG1pbkFyZ3M6IDIsXG4gICAgICAgICAgICBtYXhBcmdzOiAzXG4gICAgICAgICAgfSlcbiAgICAgICAgfVxuICAgICAgfTtcbiAgICAgIGNvbnN0IHNldHRpbmdNZXRhZGF0YSA9IHtcbiAgICAgICAgY2xlYXI6IHtcbiAgICAgICAgICBtaW5BcmdzOiAxLFxuICAgICAgICAgIG1heEFyZ3M6IDFcbiAgICAgICAgfSxcbiAgICAgICAgZ2V0OiB7XG4gICAgICAgICAgbWluQXJnczogMSxcbiAgICAgICAgICBtYXhBcmdzOiAxXG4gICAgICAgIH0sXG4gICAgICAgIHNldDoge1xuICAgICAgICAgIG1pbkFyZ3M6IDEsXG4gICAgICAgICAgbWF4QXJnczogMVxuICAgICAgICB9XG4gICAgICB9O1xuICAgICAgYXBpTWV0YWRhdGEucHJpdmFjeSA9IHtcbiAgICAgICAgbmV0d29yazoge1xuICAgICAgICAgIFwiKlwiOiBzZXR0aW5nTWV0YWRhdGFcbiAgICAgICAgfSxcbiAgICAgICAgc2VydmljZXM6IHtcbiAgICAgICAgICBcIipcIjogc2V0dGluZ01ldGFkYXRhXG4gICAgICAgIH0sXG4gICAgICAgIHdlYnNpdGVzOiB7XG4gICAgICAgICAgXCIqXCI6IHNldHRpbmdNZXRhZGF0YVxuICAgICAgICB9XG4gICAgICB9O1xuICAgICAgcmV0dXJuIHdyYXBPYmplY3QoZXh0ZW5zaW9uQVBJcywgc3RhdGljV3JhcHBlcnMsIGFwaU1ldGFkYXRhKTtcbiAgICB9O1xuXG4gICAgaWYgKHR5cGVvZiBjaHJvbWUgIT0gXCJvYmplY3RcIiB8fCAhY2hyb21lIHx8ICFjaHJvbWUucnVudGltZSB8fCAhY2hyb21lLnJ1bnRpbWUuaWQpIHtcbiAgICAgIHRocm93IG5ldyBFcnJvcihcIlRoaXMgc2NyaXB0IHNob3VsZCBvbmx5IGJlIGxvYWRlZCBpbiBhIGJyb3dzZXIgZXh0ZW5zaW9uLlwiKTtcbiAgICB9IC8vIFRoZSBidWlsZCBwcm9jZXNzIGFkZHMgYSBVTUQgd3JhcHBlciBhcm91bmQgdGhpcyBmaWxlLCB3aGljaCBtYWtlcyB0aGVcbiAgICAvLyBgbW9kdWxlYCB2YXJpYWJsZSBhdmFpbGFibGUuXG5cblxuICAgIG1vZHVsZS5leHBvcnRzID0gd3JhcEFQSXMoY2hyb21lKTtcbiAgfSBlbHNlIHtcbiAgICBtb2R1bGUuZXhwb3J0cyA9IGJyb3dzZXI7XG4gIH1cbn0pO1xuLy8jIHNvdXJjZU1hcHBpbmdVUkw9YnJvd3Nlci1wb2x5ZmlsbC5qcy5tYXBcbiIsIi8vIFRoZSBtb2R1bGUgY2FjaGVcbnZhciBfX3dlYnBhY2tfbW9kdWxlX2NhY2hlX18gPSB7fTtcblxuLy8gVGhlIHJlcXVpcmUgZnVuY3Rpb25cbmZ1bmN0aW9uIF9fd2VicGFja19yZXF1aXJlX18obW9kdWxlSWQpIHtcblx0Ly8gQ2hlY2sgaWYgbW9kdWxlIGlzIGluIGNhY2hlXG5cdHZhciBjYWNoZWRNb2R1bGUgPSBfX3dlYnBhY2tfbW9kdWxlX2NhY2hlX19bbW9kdWxlSWRdO1xuXHRpZiAoY2FjaGVkTW9kdWxlICE9PSB1bmRlZmluZWQpIHtcblx0XHRyZXR1cm4gY2FjaGVkTW9kdWxlLmV4cG9ydHM7XG5cdH1cblx0Ly8gQ3JlYXRlIGEgbmV3IG1vZHVsZSAoYW5kIHB1dCBpdCBpbnRvIHRoZSBjYWNoZSlcblx0dmFyIG1vZHVsZSA9IF9fd2VicGFja19tb2R1bGVfY2FjaGVfX1ttb2R1bGVJZF0gPSB7XG5cdFx0Ly8gbm8gbW9kdWxlLmlkIG5lZWRlZFxuXHRcdC8vIG5vIG1vZHVsZS5sb2FkZWQgbmVlZGVkXG5cdFx0ZXhwb3J0czoge31cblx0fTtcblxuXHQvLyBFeGVjdXRlIHRoZSBtb2R1bGUgZnVuY3Rpb25cblx0X193ZWJwYWNrX21vZHVsZXNfX1ttb2R1bGVJZF0uY2FsbChtb2R1bGUuZXhwb3J0cywgbW9kdWxlLCBtb2R1bGUuZXhwb3J0cywgX193ZWJwYWNrX3JlcXVpcmVfXyk7XG5cblx0Ly8gUmV0dXJuIHRoZSBleHBvcnRzIG9mIHRoZSBtb2R1bGVcblx0cmV0dXJuIG1vZHVsZS5leHBvcnRzO1xufVxuXG4iLCIvLyBnZXREZWZhdWx0RXhwb3J0IGZ1bmN0aW9uIGZvciBjb21wYXRpYmlsaXR5IHdpdGggbm9uLWhhcm1vbnkgbW9kdWxlc1xuX193ZWJwYWNrX3JlcXVpcmVfXy5uID0gKG1vZHVsZSkgPT4ge1xuXHR2YXIgZ2V0dGVyID0gbW9kdWxlICYmIG1vZHVsZS5fX2VzTW9kdWxlID9cblx0XHQoKSA9PiAobW9kdWxlWydkZWZhdWx0J10pIDpcblx0XHQoKSA9PiAobW9kdWxlKTtcblx0X193ZWJwYWNrX3JlcXVpcmVfXy5kKGdldHRlciwgeyBhOiBnZXR0ZXIgfSk7XG5cdHJldHVybiBnZXR0ZXI7XG59OyIsIi8vIGRlZmluZSBnZXR0ZXIgZnVuY3Rpb25zIGZvciBoYXJtb255IGV4cG9ydHNcbl9fd2VicGFja19yZXF1aXJlX18uZCA9IChleHBvcnRzLCBkZWZpbml0aW9uKSA9PiB7XG5cdGZvcih2YXIga2V5IGluIGRlZmluaXRpb24pIHtcblx0XHRpZihfX3dlYnBhY2tfcmVxdWlyZV9fLm8oZGVmaW5pdGlvbiwga2V5KSAmJiAhX193ZWJwYWNrX3JlcXVpcmVfXy5vKGV4cG9ydHMsIGtleSkpIHtcblx0XHRcdE9iamVjdC5kZWZpbmVQcm9wZXJ0eShleHBvcnRzLCBrZXksIHsgZW51bWVyYWJsZTogdHJ1ZSwgZ2V0OiBkZWZpbml0aW9uW2tleV0gfSk7XG5cdFx0fVxuXHR9XG59OyIsIl9fd2VicGFja19yZXF1aXJlX18ubyA9IChvYmosIHByb3ApID0+IChPYmplY3QucHJvdG90eXBlLmhhc093blByb3BlcnR5LmNhbGwob2JqLCBwcm9wKSkiLCIvLyBkZWZpbmUgX19lc01vZHVsZSBvbiBleHBvcnRzXG5fX3dlYnBhY2tfcmVxdWlyZV9fLnIgPSAoZXhwb3J0cykgPT4ge1xuXHRpZih0eXBlb2YgU3ltYm9sICE9PSAndW5kZWZpbmVkJyAmJiBTeW1ib2wudG9TdHJpbmdUYWcpIHtcblx0XHRPYmplY3QuZGVmaW5lUHJvcGVydHkoZXhwb3J0cywgU3ltYm9sLnRvU3RyaW5nVGFnLCB7IHZhbHVlOiAnTW9kdWxlJyB9KTtcblx0fVxuXHRPYmplY3QuZGVmaW5lUHJvcGVydHkoZXhwb3J0cywgJ19fZXNNb2R1bGUnLCB7IHZhbHVlOiB0cnVlIH0pO1xufTsiLCJpbXBvcnQgeyBjb250ZW50IH0gZnJvbSAnLi4vLi4vcGFnZXMvY29udGVudCc7XG5cbmNvbnRlbnQuaW5pdCgpO1xuIl0sInNvdXJjZVJvb3QiOiIifQ==