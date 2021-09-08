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
/* harmony export */   "APPEARANCE_THEME_DEFAULT": () => (/* binding */ APPEARANCE_THEME_DEFAULT)
/* harmony export */ });
var MessagesToNativeApp;

(function (MessagesToNativeApp) {
  MessagesToNativeApp["WriteInNativeLog"] = "writeInNativeLog";
  MessagesToNativeApp["ReportProblem"] = "reportProblem";
  MessagesToNativeApp["UpgradeMe"] = "upgradeMe";
  MessagesToNativeApp["GetAdvancedRulesText"] = "get_advanced_rules_text";
  MessagesToNativeApp["GetInitData"] = "get_init_data";
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
/* harmony import */ var webextension_polyfill_ts__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! webextension-polyfill-ts */ "./node_modules/webextension-polyfill-ts/lib/index.js");
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
            return webextension_polyfill_ts__WEBPACK_IMPORTED_MODULE_3__.browser.runtime.sendMessage({
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
    styleElement.sheet.insertRule(selector);
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

/***/ "./node_modules/webextension-polyfill-ts/lib/index.js":
/*!************************************************************!*\
  !*** ./node_modules/webextension-polyfill-ts/lib/index.js ***!
  \************************************************************/
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {

"use strict";

Object.defineProperty(exports, "__esModule", ({ value: true }));

exports.browser = __webpack_require__(/*! webextension-polyfill */ "./node_modules/webextension-polyfill/dist/browser-polyfill.js");


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
  /* webextension-polyfill - v0.7.0 - Tue Nov 10 2020 20:24:04 */

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
       * @param {function} promise.rejection
       *        The promise's rejection function.
       * @param {object} metadata
       *        Metadata about the wrapped method which has created the callback.
       * @param {integer} metadata.maxResolvedArgs
       *        The maximum number of arguments which may be passed to the
       *        callback created by the wrapped async function.
       *
       * @returns {function}
       *        The generated callback function.
       */


      const makeCallback = (promise, metadata) => {
        return (...callbackArgs) => {
          if (extensionAPIs.runtime.lastError) {
            promise.reject(extensionAPIs.runtime.lastError);
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
       * @param {integer} metadata.maxResolvedArgs
       *        The maximum number of arguments which may be passed to the
       *        callback created by the wrapped async function.
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
            reject(extensionAPIs.runtime.lastError);
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
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIndlYnBhY2s6Ly9hZHZhbmNlZC1hZGJsb2NrZXItd2ViLWV4dGVuc2lvbi8uL25vZGVfbW9kdWxlcy9AYmFiZWwvcnVudGltZS9oZWxwZXJzL2VzbS9hcnJheUxpa2VUb0FycmF5LmpzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vbm9kZV9tb2R1bGVzL0BiYWJlbC9ydW50aW1lL2hlbHBlcnMvZXNtL2FycmF5V2l0aG91dEhvbGVzLmpzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vbm9kZV9tb2R1bGVzL0BiYWJlbC9ydW50aW1lL2hlbHBlcnMvZXNtL2FzeW5jVG9HZW5lcmF0b3IuanMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vLi9ub2RlX21vZHVsZXMvQGJhYmVsL3J1bnRpbWUvaGVscGVycy9lc20vaXRlcmFibGVUb0FycmF5LmpzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vbm9kZV9tb2R1bGVzL0BiYWJlbC9ydW50aW1lL2hlbHBlcnMvZXNtL25vbkl0ZXJhYmxlU3ByZWFkLmpzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vbm9kZV9tb2R1bGVzL0BiYWJlbC9ydW50aW1lL2hlbHBlcnMvZXNtL3RvQ29uc3VtYWJsZUFycmF5LmpzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vbm9kZV9tb2R1bGVzL0BiYWJlbC9ydW50aW1lL2hlbHBlcnMvZXNtL3Vuc3VwcG9ydGVkSXRlcmFibGVUb0FycmF5LmpzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vbm9kZV9tb2R1bGVzL0BiYWJlbC9ydW50aW1lL3JlZ2VuZXJhdG9yL2luZGV4LmpzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vc3JjL3BhZ2VzL2NvbW1vbi9jb25zdGFudHMudHMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vLi9zcmMvcGFnZXMvY29udGVudC9jb250ZW50LnRzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vbm9kZV9tb2R1bGVzL2V4dGVuZGVkLWNzcy9kaXN0L2V4dGVuZGVkLWNzcy5lc20uanMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vLi9ub2RlX21vZHVsZXMvcmVnZW5lcmF0b3ItcnVudGltZS9ydW50aW1lLmpzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vbm9kZV9tb2R1bGVzL3dlYmV4dGVuc2lvbi1wb2x5ZmlsbC10cy9saWIvaW5kZXguanMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vLi9ub2RlX21vZHVsZXMvd2ViZXh0ZW5zaW9uLXBvbHlmaWxsL2Rpc3QvYnJvd3Nlci1wb2x5ZmlsbC5qcyIsIndlYnBhY2s6Ly9hZHZhbmNlZC1hZGJsb2NrZXItd2ViLWV4dGVuc2lvbi93ZWJwYWNrL2Jvb3RzdHJhcCIsIndlYnBhY2s6Ly9hZHZhbmNlZC1hZGJsb2NrZXItd2ViLWV4dGVuc2lvbi93ZWJwYWNrL3J1bnRpbWUvY29tcGF0IGdldCBkZWZhdWx0IGV4cG9ydCIsIndlYnBhY2s6Ly9hZHZhbmNlZC1hZGJsb2NrZXItd2ViLWV4dGVuc2lvbi93ZWJwYWNrL3J1bnRpbWUvZGVmaW5lIHByb3BlcnR5IGdldHRlcnMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vd2VicGFjay9ydW50aW1lL2hhc093blByb3BlcnR5IHNob3J0aGFuZCIsIndlYnBhY2s6Ly9hZHZhbmNlZC1hZGJsb2NrZXItd2ViLWV4dGVuc2lvbi93ZWJwYWNrL3J1bnRpbWUvbWFrZSBuYW1lc3BhY2Ugb2JqZWN0Iiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vc3JjL3RhcmdldHMvY29udGVudC9pbmRleC50cyJdLCJuYW1lcyI6WyJNZXNzYWdlc1RvTmF0aXZlQXBwIiwiTWVzc2FnZXNUb0JhY2tncm91bmRQYWdlIiwiTWVzc2FnZXNUb0NvbnRlbnRTY3JpcHQiLCJBcHBlYXJhbmNlVGhlbWUiLCJBUFBFQVJBTkNFX1RIRU1FX0RFRkFVTFQiLCJTeXN0ZW0iLCJsb2dNZXNzYWdlIiwidmVyYm9zZSIsIm1lc3NhZ2UiLCJjb25zb2xlIiwibG9nIiwiZ2V0U2VsZWN0b3JzQW5kU2NyaXB0cyIsImJyb3dzZXIiLCJ0eXBlIiwiZGF0YSIsInVybCIsIndpbmRvdyIsImxvY2F0aW9uIiwiaHJlZiIsInJlc3BvbnNlIiwiZXhlY3V0ZVNjcmlwdHMiLCJzY3JpcHRzIiwic3RhcnQiLCJlbmQiLCJ1cGRhdGVkIiwic2NyaXB0VGFnIiwiZG9jdW1lbnQiLCJjcmVhdGVFbGVtZW50Iiwic2V0QXR0cmlidXRlIiwidGV4dENvbnRlbnQiLCJqb2luIiwicGFyZW50IiwiaGVhZCIsImRvY3VtZW50RWxlbWVudCIsImFwcGVuZENoaWxkIiwicGFyZW50Tm9kZSIsInJlbW92ZUNoaWxkIiwiYXBwbHlTY3JpcHRzIiwibGVuZ3RoIiwicmV2ZXJzZSIsInByb3RlY3RTdHlsZUVsZW1lbnRDb250ZW50IiwicHJvdGVjdFN0eWxlRWwiLCJNdXRhdGlvbk9ic2VydmVyIiwiV2ViS2l0TXV0YXRpb25PYnNlcnZlciIsImlubmVyT2JzZXJ2ZXIiLCJtdXRhdGlvbnMiLCJpIiwibSIsImhhc0F0dHJpYnV0ZSIsImdldEF0dHJpYnV0ZSIsInJlbW92ZUF0dHJpYnV0ZSIsImlzUHJvdGVjdFN0eWxlRWxNb2RpZmllZCIsInJlbW92ZWROb2RlcyIsImoiLCJvbGRWYWx1ZSIsIm9ic2VydmUiLCJjaGlsZExpc3QiLCJjaGFyYWN0ZXJEYXRhIiwic3VidHJlZSIsImNoYXJhY3RlckRhdGFPbGRWYWx1ZSIsImFwcGx5Q3NzIiwic3R5bGVTZWxlY3RvcnMiLCJzdHlsZUVsZW1lbnQiLCJzZWxlY3RvcnMiLCJtYXAiLCJzIiwidHJpbSIsImZvckVhY2giLCJzZWxlY3RvciIsInNoZWV0IiwiaW5zZXJ0UnVsZSIsImFwcGx5RXh0ZW5kZWRDc3MiLCJleHRlbmRlZENzcyIsImV4dGNzcyIsIkV4dGVuZGVkQ3NzIiwic3R5bGVTaGVldCIsImZpbHRlciIsImFwcGx5IiwiYXBwbHlBZHZhbmNlZEJsb2NraW5nRGF0YSIsInNlbGVjdG9yc0FuZFNjcmlwdHMiLCJjc3NJbmplY3QiLCJjc3NFeHRlbmRlZCIsImluaXQiLCJIVE1MRG9jdW1lbnQiLCJpbmRleE9mIiwic3RhcnRHZXR0aW5nU2NyaXB0cyIsIkRhdGUiLCJub3ciLCJjb250ZW50Il0sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7Ozs7OztBQUFlO0FBQ2Y7O0FBRUEsd0NBQXdDLFNBQVM7QUFDakQ7QUFDQTs7QUFFQTtBQUNBLEM7Ozs7Ozs7Ozs7Ozs7Ozs7QUNScUQ7QUFDdEM7QUFDZixpQ0FBaUMsNkRBQWdCO0FBQ2pELEM7Ozs7Ozs7Ozs7Ozs7OztBQ0hBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsR0FBRztBQUNIO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0EsR0FBRztBQUNIO0FBQ0E7QUFDQTs7QUFFZTtBQUNmO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBLEtBQUs7QUFDTDtBQUNBLEM7Ozs7Ozs7Ozs7Ozs7OztBQ2xDZTtBQUNmO0FBQ0EsQzs7Ozs7Ozs7Ozs7Ozs7O0FDRmU7QUFDZjtBQUNBLEM7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7QUNGdUQ7QUFDSjtBQUNzQjtBQUNsQjtBQUN4QztBQUNmLFNBQVMsOERBQWlCLFNBQVMsNERBQWUsU0FBUyx1RUFBMEIsU0FBUyw4REFBaUI7QUFDL0csQzs7Ozs7Ozs7Ozs7Ozs7OztBQ05xRDtBQUN0QztBQUNm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O0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxhQUFhLFNBQVM7QUFDdEIsYUFBYSxPQUFPO0FBQ3BCO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsVUFBVTtBQUNWO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDs7QUFFQTtBQUNBLEtBQUs7QUFDTDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQSxDQUFDO0FBQ0Q7QUFDQTtBQUNBOzs7QUFHQTtBQUNBO0FBQ0EsMkJBQTJCLHlDQUF5QztBQUNwRTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQSxPQUFPO0FBQ1A7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUOztBQUVBO0FBQ0EsS0FBSztBQUNMO0FBQ0E7QUFDQTtBQUNBLEtBQUs7QUFDTDtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLEtBQUs7QUFDTDtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLENBQUM7QUFDRDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsTUFBTTtBQUNOO0FBQ0E7QUFDQSxhQUFhLE1BQU07QUFDbkI7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBLEtBQUs7QUFDTDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxLQUFLO0FBQ0w7QUFDQTtBQUNBLEtBQUs7QUFDTDtBQUNBO0FBQ0E7QUFDQSxPQUFPO0FBQ1A7QUFDQSxLQUFLO0FBQ0w7QUFDQTtBQUNBO0FBQ0E7QUFDQSxPQUFPO0FBQ1A7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxPQUFPO0FBQ1A7QUFDQSxHQUFHO0FBQ0g7QUFDQSxDQUFDO0FBQ0Q7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUEsaUJBQWlCLE9BQU87QUFDeEI7QUFDQTtBQUNBO0FBQ0E7QUFDQSxDQUFDO0FBQ0Q7QUFDQTtBQUNBOzs7QUFHQTtBQUNBLGVBQWUsY0FBYztBQUM3QjtBQUNBLGVBQWUsT0FBTzs7QUFFdEI7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLGVBQWUsT0FBTzs7QUFFdEI7QUFDQSxlQUFlLE9BQU87O0FBRXRCO0FBQ0E7QUFDQTtBQUNBLFdBQVcsT0FBTztBQUNsQjs7O0FBR0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLGVBQWUsT0FBTzs7QUFFdEI7QUFDQSxlQUFlLE9BQU87QUFDdEI7O0FBRUE7QUFDQTtBQUNBOzs7QUFHQTtBQUNBOztBQUVBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXLFFBQVE7QUFDbkIsYUFBYSxPQUFPO0FBQ3BCOzs7QUFHQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBLGdCQUFnQjtBQUNoQjs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsS0FBSztBQUNMO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsSUFBSTtBQUNKO0FBQ0EsMkNBQTJDLGFBQWE7QUFDeEQ7QUFDQTs7O0FBR0E7QUFDQTtBQUNBLCtCQUErQjs7QUFFL0I7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsYUFBYSxPQUFPO0FBQ3BCLGNBQWM7QUFDZDs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQSxLQUFLO0FBQ0w7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsQ0FBQzs7QUFFRDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQSxPQUFPO0FBQ1A7QUFDQSxpQkFBaUI7QUFDakI7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtB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Q0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0EsT0FBTyxFQUFFOztBQUVUO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBOztBQUVBO0FBQ0EsT0FBTztBQUNQO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsS0FBSztBQUNMOztBQUVBO0FBQ0E7QUFDQTtBQUNBLENBQUM7O0FBRUQ7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUEsdUJBQXVCOztBQUV2QixnQ0FBZ0M7O0FBRWhDLDhDQUE4Qzs7QUFFOUMsMkNBQTJDOztBQUUzQyxnREFBZ0Q7O0FBRWhELHNDQUFzQzs7QUFFdEM7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLEtBQUs7QUFDTDtBQUNBO0FBQ0EsK0RBQStEOztBQUUvRDtBQUNBLDJFQUEyRTs7QUFFM0U7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0EsS0FBSztBQUNMO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLE9BQU87QUFDUDtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLEtBQUs7QUFDTDtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQSxLQUFLO0FBQ0w7QUFDQTtBQUNBO0FBQ0EsT0FBTztBQUNQO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0EsS0FBSztBQUNMO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtB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Z0M7O0FBRWhDO0FBQ0E7QUFDQTtBQUNBLEtBQUs7QUFDTDtBQUNBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0EsT0FBTztBQUNQO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsS0FBSzs7QUFFTDtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0EsMkJBQTJCO0FBQzNCO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQSxLQUFLLEVBQUU7O0FBRVAsb0NBQW9DOztBQUVwQztBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxLQUFLOzs7QUFHTDtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLEtBQUs7OztBQUdMO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxLQUFLO0FBQ0w7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0EsS0FBSztBQUNMO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsS0FBSzs7QUFFTDtBQUNBO0FBQ0EsS0FBSzs7O0FBR0w7QUFDQSxHQUFHOzs7QUFHSCxpREFBaUQ7O0FBRWpEO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVcsT0FBTztBQUNsQixXQUFXLFFBQVE7QUFDbkIsYUFBYSxxQkFBcUI7QUFDbEM7QUFDQTs7O0FBR0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0EsR0FBRztBQUNIOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUEsaUVBQWUsV0FBVyxFQUFDOzs7Ozs7Ozs7OztBQ3BySzNCO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQSxnQkFBZ0I7QUFDaEI7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsS0FBSztBQUNMO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsYUFBYTtBQUNiLEdBQUc7QUFDSDtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsY0FBYztBQUNkLEtBQUs7QUFDTCxjQUFjO0FBQ2Q7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSx5REFBeUQ7QUFDekQ7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxPQUFPO0FBQ1AsS0FBSztBQUNMOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQSxLQUFLO0FBQ0w7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxZQUFZO0FBQ1o7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLE9BQU87QUFDUDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBLFdBQVc7QUFDWDs7QUFFQTtBQUNBO0FBQ0Esd0NBQXdDLFdBQVc7QUFDbkQ7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBOztBQUVBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBLDJCQUEyQjtBQUMzQjtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7O0FBRUEsU0FBUztBQUNUO0FBQ0E7O0FBRUE7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQSxvQ0FBb0MsY0FBYztBQUNsRDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBLEtBQUs7QUFDTDtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQSxpQ0FBaUMsa0JBQWtCO0FBQ25EO0FBQ0E7O0FBRUE7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQSxpQkFBaUI7O0FBRWpCO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLHdCQUF3QixpQkFBaUI7QUFDekM7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQSxZQUFZO0FBQ1o7QUFDQTs7QUFFQTtBQUNBLFlBQVk7QUFDWjs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLEtBQUs7O0FBRUw7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0EsS0FBSzs7QUFFTDtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBLDhDQUE4QyxRQUFRO0FBQ3REO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQSxhQUFhO0FBQ2I7QUFDQTs7QUFFQSxXQUFXO0FBQ1g7QUFDQTtBQUNBOztBQUVBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7O0FBRUEsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsS0FBSzs7QUFFTDtBQUNBLDhDQUE4QyxRQUFRO0FBQ3REO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0EsS0FBSzs7QUFFTDtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQSxPQUFPO0FBQ1A7QUFDQTtBQUNBO0FBQ0EsT0FBTztBQUNQO0FBQ0E7O0FBRUE7QUFDQSxLQUFLOztBQUVMO0FBQ0EsOENBQThDLFFBQVE7QUFDdEQ7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxLQUFLOztBQUVMO0FBQ0EsOENBQThDLFFBQVE7QUFDdEQ7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0EsS0FBSzs7QUFFTDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQSxDQUFDO0FBQ0Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxFQUFFLEtBQTBCLG9CQUFvQixDQUFFO0FBQ2xEOztBQUVBO0FBQ0E7QUFDQSxDQUFDO0FBQ0Q7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7Ozs7Ozs7Ozs7O0FDM3VCYTtBQUNiLDhDQUE2QyxDQUFDLGNBQWMsRUFBQzs7QUFFN0QsbUlBQWtEOzs7Ozs7Ozs7OztBQ0hsRDtBQUNBLE1BQU0sSUFBMEM7QUFDaEQsSUFBSSxpQ0FBZ0MsQ0FBQyxNQUFRLENBQUMsb0NBQUUsT0FBTztBQUFBO0FBQUE7QUFBQSxrR0FBQztBQUN4RCxHQUFHLE1BQU0sWUFRTjtBQUNILENBQUM7QUFDRDs7QUFFQSxxQ0FBcUM7O0FBRXJDOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQSx1U0FBdVM7QUFDdlM7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLGFBQWE7QUFDYjtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxhQUFhO0FBQ2I7QUFDQTtBQUNBO0FBQ0EsYUFBYTtBQUNiO0FBQ0E7QUFDQTtBQUNBLGFBQWE7QUFDYjtBQUNBO0FBQ0E7QUFDQSxhQUFhO0FBQ2I7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxhQUFhO0FBQ2I7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxhQUFhO0FBQ2I7QUFDQTtBQUNBO0FBQ0EsYUFBYTtBQUNiO0FBQ0E7QUFDQTtBQUNBLGFBQWE7QUFDYjtBQUNBO0FBQ0E7QUFDQSxhQUFhO0FBQ2I7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7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QSx3Q0FBd0MseUNBQXlDO1dBQ2pGO1dBQ0E7V0FDQSxFOzs7OztXQ1BBLHdGOzs7OztXQ0FBO1dBQ0E7V0FDQTtXQUNBLHNEQUFzRCxrQkFBa0I7V0FDeEU7V0FDQSwrQ0FBK0MsY0FBYztXQUM3RCxFOzs7Ozs7Ozs7Ozs7O0FDTkE7QUFFQU0sd0RBQUEsRyIsImZpbGUiOiJjb250ZW50LmpzIiwic291cmNlc0NvbnRlbnQiOlsiZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24gX2FycmF5TGlrZVRvQXJyYXkoYXJyLCBsZW4pIHtcbiAgaWYgKGxlbiA9PSBudWxsIHx8IGxlbiA+IGFyci5sZW5ndGgpIGxlbiA9IGFyci5sZW5ndGg7XG5cbiAgZm9yICh2YXIgaSA9IDAsIGFycjIgPSBuZXcgQXJyYXkobGVuKTsgaSA8IGxlbjsgaSsrKSB7XG4gICAgYXJyMltpXSA9IGFycltpXTtcbiAgfVxuXG4gIHJldHVybiBhcnIyO1xufSIsImltcG9ydCBhcnJheUxpa2VUb0FycmF5IGZyb20gXCIuL2FycmF5TGlrZVRvQXJyYXkuanNcIjtcbmV4cG9ydCBkZWZhdWx0IGZ1bmN0aW9uIF9hcnJheVdpdGhvdXRIb2xlcyhhcnIpIHtcbiAgaWYgKEFycmF5LmlzQXJyYXkoYXJyKSkgcmV0dXJuIGFycmF5TGlrZVRvQXJyYXkoYXJyKTtcbn0iLCJmdW5jdGlvbiBhc3luY0dlbmVyYXRvclN0ZXAoZ2VuLCByZXNvbHZlLCByZWplY3QsIF9uZXh0LCBfdGhyb3csIGtleSwgYXJnKSB7XG4gIHRyeSB7XG4gICAgdmFyIGluZm8gPSBnZW5ba2V5XShhcmcpO1xuICAgIHZhciB2YWx1ZSA9IGluZm8udmFsdWU7XG4gIH0gY2F0Y2ggKGVycm9yKSB7XG4gICAgcmVqZWN0KGVycm9yKTtcbiAgICByZXR1cm47XG4gIH1cblxuICBpZiAoaW5mby5kb25lKSB7XG4gICAgcmVzb2x2ZSh2YWx1ZSk7XG4gIH0gZWxzZSB7XG4gICAgUHJvbWlzZS5yZXNvbHZlKHZhbHVlKS50aGVuKF9uZXh0LCBfdGhyb3cpO1xuICB9XG59XG5cbmV4cG9ydCBkZWZhdWx0IGZ1bmN0aW9uIF9hc3luY1RvR2VuZXJhdG9yKGZuKSB7XG4gIHJldHVybiBmdW5jdGlvbiAoKSB7XG4gICAgdmFyIHNlbGYgPSB0aGlzLFxuICAgICAgICBhcmdzID0gYXJndW1lbnRzO1xuICAgIHJldHVybiBuZXcgUHJvbWlzZShmdW5jdGlvbiAocmVzb2x2ZSwgcmVqZWN0KSB7XG4gICAgICB2YXIgZ2VuID0gZm4uYXBwbHkoc2VsZiwgYXJncyk7XG5cbiAgICAgIGZ1bmN0aW9uIF9uZXh0KHZhbHVlKSB7XG4gICAgICAgIGFzeW5jR2VuZXJhdG9yU3RlcChnZW4sIHJlc29sdmUsIHJlamVjdCwgX25leHQsIF90aHJvdywgXCJuZXh0XCIsIHZhbHVlKTtcbiAgICAgIH1cblxuICAgICAgZnVuY3Rpb24gX3Rocm93KGVycikge1xuICAgICAgICBhc3luY0dlbmVyYXRvclN0ZXAoZ2VuLCByZXNvbHZlLCByZWplY3QsIF9uZXh0LCBfdGhyb3csIFwidGhyb3dcIiwgZXJyKTtcbiAgICAgIH1cblxuICAgICAgX25leHQodW5kZWZpbmVkKTtcbiAgICB9KTtcbiAgfTtcbn0iLCJleHBvcnQgZGVmYXVsdCBmdW5jdGlvbiBfaXRlcmFibGVUb0FycmF5KGl0ZXIpIHtcbiAgaWYgKHR5cGVvZiBTeW1ib2wgIT09IFwidW5kZWZpbmVkXCIgJiYgaXRlcltTeW1ib2wuaXRlcmF0b3JdICE9IG51bGwgfHwgaXRlcltcIkBAaXRlcmF0b3JcIl0gIT0gbnVsbCkgcmV0dXJuIEFycmF5LmZyb20oaXRlcik7XG59IiwiZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24gX25vbkl0ZXJhYmxlU3ByZWFkKCkge1xuICB0aHJvdyBuZXcgVHlwZUVycm9yKFwiSW52YWxpZCBhdHRlbXB0IHRvIHNwcmVhZCBub24taXRlcmFibGUgaW5zdGFuY2UuXFxuSW4gb3JkZXIgdG8gYmUgaXRlcmFibGUsIG5vbi1hcnJheSBvYmplY3RzIG11c3QgaGF2ZSBhIFtTeW1ib2wuaXRlcmF0b3JdKCkgbWV0aG9kLlwiKTtcbn0iLCJpbXBvcnQgYXJyYXlXaXRob3V0SG9sZXMgZnJvbSBcIi4vYXJyYXlXaXRob3V0SG9sZXMuanNcIjtcbmltcG9ydCBpdGVyYWJsZVRvQXJyYXkgZnJvbSBcIi4vaXRlcmFibGVUb0FycmF5LmpzXCI7XG5pbXBvcnQgdW5zdXBwb3J0ZWRJdGVyYWJsZVRvQXJyYXkgZnJvbSBcIi4vdW5zdXBwb3J0ZWRJdGVyYWJsZVRvQXJyYXkuanNcIjtcbmltcG9ydCBub25JdGVyYWJsZVNwcmVhZCBmcm9tIFwiLi9ub25JdGVyYWJsZVNwcmVhZC5qc1wiO1xuZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24gX3RvQ29uc3VtYWJsZUFycmF5KGFycikge1xuICByZXR1cm4gYXJyYXlXaXRob3V0SG9sZXMoYXJyKSB8fCBpdGVyYWJsZVRvQXJyYXkoYXJyKSB8fCB1bnN1cHBvcnRlZEl0ZXJhYmxlVG9BcnJheShhcnIpIHx8IG5vbkl0ZXJhYmxlU3ByZWFkKCk7XG59IiwiaW1wb3J0IGFycmF5TGlrZVRvQXJyYXkgZnJvbSBcIi4vYXJyYXlMaWtlVG9BcnJheS5qc1wiO1xuZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24gX3Vuc3VwcG9ydGVkSXRlcmFibGVUb0FycmF5KG8sIG1pbkxlbikge1xuICBpZiAoIW8pIHJldHVybjtcbiAgaWYgKHR5cGVvZiBvID09PSBcInN0cmluZ1wiKSByZXR1cm4gYXJyYXlMaWtlVG9BcnJheShvLCBtaW5MZW4pO1xuICB2YXIgbiA9IE9iamVjdC5wcm90b3R5cGUudG9TdHJpbmcuY2FsbChvKS5zbGljZSg4LCAtMSk7XG4gIGlmIChuID09PSBcIk9iamVjdFwiICYmIG8uY29uc3RydWN0b3IpIG4gPSBvLmNvbnN0cnVjdG9yLm5hbWU7XG4gIGlmIChuID09PSBcIk1hcFwiIHx8IG4gPT09IFwiU2V0XCIpIHJldHVybiBBcnJheS5mcm9tKG8pO1xuICBpZiAobiA9PT0gXCJBcmd1bWVudHNcIiB8fCAvXig/OlVpfEkpbnQoPzo4fDE2fDMyKSg/OkNsYW1wZWQpP0FycmF5JC8udGVzdChuKSkgcmV0dXJuIGFycmF5TGlrZVRvQXJyYXkobywgbWluTGVuKTtcbn0iLCJtb2R1bGUuZXhwb3J0cyA9IHJlcXVpcmUoXCJyZWdlbmVyYXRvci1ydW50aW1lXCIpO1xuIiwiZXhwb3J0IGVudW0gTWVzc2FnZXNUb05hdGl2ZUFwcCB7XG4gICAgV3JpdGVJbk5hdGl2ZUxvZyA9ICd3cml0ZUluTmF0aXZlTG9nJyxcbiAgICAvLyBUT0RPIHJlbW92ZSBpZiBub3QgbmVjZXNzYXJ5XG4gICAgUmVwb3J0UHJvYmxlbSA9ICdyZXBvcnRQcm9ibGVtJyxcbiAgICBVcGdyYWRlTWUgPSAndXBncmFkZU1lJyxcbiAgICBHZXRBZHZhbmNlZFJ1bGVzVGV4dCA9ICdnZXRfYWR2YW5jZWRfcnVsZXNfdGV4dCcsXG4gICAgR2V0SW5pdERhdGEgPSAnZ2V0X2luaXRfZGF0YScsXG59XG5cbmV4cG9ydCBlbnVtIE1lc3NhZ2VzVG9CYWNrZ3JvdW5kUGFnZSB7XG4gICAgT3BlbkFzc2lzdGFudCA9ICdvcGVuX2Fzc2lzdGFudCcsXG4gICAgR2V0U2NyaXB0c0FuZFNlbGVjdG9ycyA9ICdnZXRfc2NyaXB0c19hbmRfc2VsZWN0b3JzJyxcbiAgICBBZGRSdWxlID0gJ2FkZF9ydWxlJyxcbiAgICBHZXRQb3B1cERhdGEgPSAnZ2V0X3BvcHVwX2RhdGEnLFxuICAgIFNldFBlcm1pc3Npb25zTW9kYWxWaWV3ZWQgPSAnc2V0X3Blcm1pc3Npb25zX21vZGFsX3ZpZXdlZCcsXG4gICAgU2V0UHJvdGVjdGlvblN0YXR1cyA9ICdzZXRfcHJvdGVjdGlvbl9zdGF0dXMnLFxuICAgIERlbGV0ZVVzZXJSdWxlc0J5VXJsID0gJ2RlbGV0ZV91c2VyX3J1bGVzX2J5X3VybCcsXG4gICAgUmVwb3J0UHJvYmxlbSA9ICdyZXBvcnRfcHJvYmxlbScsXG4gICAgVXBncmFkZUNsaWNrZWQgPSAndXBncmFkZV9jbGlja2VkJyxcbn1cblxuZXhwb3J0IGVudW0gTWVzc2FnZXNUb0NvbnRlbnRTY3JpcHQge1xuICAgIEluaXRBc3Npc3RhbnQgPSAnaW5pdF9hc3Npc3RhbnQnLFxufVxuXG5leHBvcnQgZW51bSBBcHBlYXJhbmNlVGhlbWUge1xuICAgIFN5c3RlbSA9ICdzeXN0ZW0nLFxuICAgIERhcmsgPSAnZGFyaycsXG4gICAgTGlnaHQgPSAnbGlnaHQnLFxufVxuXG5leHBvcnQgY29uc3QgQVBQRUFSQU5DRV9USEVNRV9ERUZBVUxUID0gQXBwZWFyYW5jZVRoZW1lLlN5c3RlbTtcbiIsIi8qIGVzbGludC1kaXNhYmxlIG5vLWNvbnNvbGUgKi9cbmltcG9ydCB7IGJyb3dzZXIgfSBmcm9tICd3ZWJleHRlbnNpb24tcG9seWZpbGwtdHMnO1xuaW1wb3J0IEV4dGVuZGVkQ3NzIGZyb20gJ2V4dGVuZGVkLWNzcyc7XG5cbmltcG9ydCB7IE1lc3NhZ2VzVG9CYWNrZ3JvdW5kUGFnZSB9IGZyb20gJy4uL2NvbW1vbi9jb25zdGFudHMnO1xuaW1wb3J0IHsgU2VsZWN0b3JzQW5kU2NyaXB0cyB9IGZyb20gJy4uL2NvbW1vbi9pbnRlcmZhY2VzJztcblxuLyoqXG4gKiBMb2dzIGEgbWVzc2FnZSBpZiB2ZXJib3NlIGlzIHRydWVcbiAqXG4gKiBAcGFyYW0gdmVyYm9zZVxuICogQHBhcmFtIG1lc3NhZ2VcbiAqL1xuY29uc3QgbG9nTWVzc2FnZSA9ICh2ZXJib3NlOiBib29sZWFuLCBtZXNzYWdlOiBzdHJpbmcpID0+IHtcbiAgICBpZiAodmVyYm9zZSkge1xuICAgICAgICBjb25zb2xlLmxvZyhgKEFHKSAke21lc3NhZ2V9YCk7XG4gICAgfVxufTtcblxuY29uc3QgZ2V0U2VsZWN0b3JzQW5kU2NyaXB0cyA9IGFzeW5jICgpOiBQcm9taXNlPFNlbGVjdG9yc0FuZFNjcmlwdHMgfCBudWxsPiA9PiB7XG4gICAgY29uc3QgcmVzcG9uc2UgPSBhd2FpdCBicm93c2VyLnJ1bnRpbWUuc2VuZE1lc3NhZ2Uoe1xuICAgICAgICB0eXBlOiBNZXNzYWdlc1RvQmFja2dyb3VuZFBhZ2UuR2V0U2NyaXB0c0FuZFNlbGVjdG9ycyxcbiAgICAgICAgZGF0YToge1xuICAgICAgICAgICAgdXJsOiB3aW5kb3cubG9jYXRpb24uaHJlZixcbiAgICAgICAgfSxcbiAgICB9KTtcblxuICAgIGlmIChyZXNwb25zZSA9PT0gbnVsbCkge1xuICAgICAgICBjb25zb2xlLmxvZygnQUc6IG5vIHNjcmlwdHMgYW5kIHNlbGVjdG9ycyByZWNlaXZlZCcpO1xuICAgICAgICByZXR1cm4gbnVsbDtcbiAgICB9XG5cbiAgICByZXR1cm4gcmVzcG9uc2UgYXMgU2VsZWN0b3JzQW5kU2NyaXB0cztcbn07XG5cbi8qKlxuICogRXhlY3V0ZSBzY3JpcHRzIGluIGEgcGFnZSBjb250ZXh0IGFuZCBjbGVhbnVwIGl0c2VsZiB3aGVuIGV4ZWN1dGlvbiBjb21wbGV0ZXNcbiAqIEBwYXJhbSBzY3JpcHRzIFNjcmlwdHMgYXJyYXkgdG8gZXhlY3V0ZVxuICovXG5jb25zdCBleGVjdXRlU2NyaXB0cyA9IChzY3JpcHRzOiBzdHJpbmdbXSkgPT4ge1xuICAgIC8vIFdyYXAgd2l0aCB0cnkgY2F0Y2hcbiAgICBjb25zdCBzdGFydCA9ICcoIGZ1bmN0aW9uICgpIHsgdHJ5IHsnO1xuICAgIGNvbnN0IGVuZCA9IFwifSBjYXRjaCAoZXgpIHsgY29uc29sZS5lcnJvcignRXJyb3IgZXhlY3V0aW5nIEFHIGpzOiAnICsgZXgpOyB9IH0pKCk7XCI7XG5cbiAgICBjb25zdCB1cGRhdGVkID0gW3N0YXJ0LCAuLi5zY3JpcHRzLCBlbmRdO1xuXG4gICAgY29uc3Qgc2NyaXB0VGFnID0gZG9jdW1lbnQuY3JlYXRlRWxlbWVudCgnc2NyaXB0Jyk7XG4gICAgc2NyaXB0VGFnLnNldEF0dHJpYnV0ZSgndHlwZScsICd0ZXh0L2phdmFzY3JpcHQnKTtcbiAgICBzY3JpcHRUYWcudGV4dENvbnRlbnQgPSB1cGRhdGVkLmpvaW4oJ1xcclxcbicpO1xuXG4gICAgY29uc3QgcGFyZW50ID0gZG9jdW1lbnQuaGVhZCB8fCBkb2N1bWVudC5kb2N1bWVudEVsZW1lbnQ7XG4gICAgcGFyZW50LmFwcGVuZENoaWxkKHNjcmlwdFRhZyk7XG4gICAgaWYgKHNjcmlwdFRhZy5wYXJlbnROb2RlKSB7XG4gICAgICAgIHNjcmlwdFRhZy5wYXJlbnROb2RlLnJlbW92ZUNoaWxkKHNjcmlwdFRhZyk7XG4gICAgfVxufTtcblxuLyoqXG4gKiBBcHBsaWVzIEpTIGluamVjdGlvbnMuXG4gKiBAcGFyYW0gc2NyaXB0cyBBcnJheSB3aXRoIEpTIHNjcmlwdHNcbiAqIEBwYXJhbSB2ZXJib3NlIGxvZ2dpbmdcbiAqL1xuY29uc3QgYXBwbHlTY3JpcHRzID0gKHNjcmlwdHM6IHN0cmluZ1tdLCB2ZXJib3NlOiBib29sZWFuKSA9PiB7XG4gICAgaWYgKCFzY3JpcHRzIHx8IHNjcmlwdHMubGVuZ3RoID09PSAwKSB7XG4gICAgICAgIHJldHVybjtcbiAgICB9XG5cbiAgICBsb2dNZXNzYWdlKHZlcmJvc2UsIGBzY3JpcHRzIGxlbmd0aDogJHtzY3JpcHRzLmxlbmd0aH1gKTtcbiAgICBleGVjdXRlU2NyaXB0cyhzY3JpcHRzLnJldmVyc2UoKSk7XG59O1xuXG4vKipcbiAqIFByb3RlY3RzIHNwZWNpZmllZCBzdHlsZSBlbGVtZW50IGZyb20gY2hhbmdlcyB0byB0aGUgY3VycmVudCBkb2N1bWVudFxuICogQWRkIGEgbXV0YXRpb24gb2JzZXJ2ZXIsIHdoaWNoIGlzIGFkZHMgb3VyIHJ1bGVzIGFnYWluIGlmIGl0IHdhcyByZW1vdmVkXG4gKlxuICogQHBhcmFtIHByb3RlY3RTdHlsZUVsIHByb3RlY3RlZCBzdHlsZSBlbGVtZW50XG4gKi9cbmNvbnN0IHByb3RlY3RTdHlsZUVsZW1lbnRDb250ZW50ID0gKHByb3RlY3RTdHlsZUVsOiBOb2RlKSA9PiB7XG4gICAgLy8gQHRzLWlnbm9yZVxuICAgIGNvbnN0IE11dGF0aW9uT2JzZXJ2ZXIgPSB3aW5kb3cuTXV0YXRpb25PYnNlcnZlciB8fCB3aW5kb3cuV2ViS2l0TXV0YXRpb25PYnNlcnZlcjtcbiAgICBpZiAoIU11dGF0aW9uT2JzZXJ2ZXIpIHtcbiAgICAgICAgcmV0dXJuO1xuICAgIH1cbiAgICAvKiBvYnNlcnZlciwgd2hpY2ggb2JzZXJ2ZSBwcm90ZWN0U3R5bGVFbCBpbm5lciBjaGFuZ2VzLCB3aXRob3V0IGRlbGV0aW5nIHN0eWxlRWwgKi9cbiAgICBjb25zdCBpbm5lck9ic2VydmVyID0gbmV3IE11dGF0aW9uT2JzZXJ2ZXIoKChtdXRhdGlvbnMpID0+IHtcbiAgICAgICAgZm9yIChsZXQgaSA9IDA7IGkgPCBtdXRhdGlvbnMubGVuZ3RoOyBpICs9IDEpIHtcbiAgICAgICAgICAgIGNvbnN0IG0gPSBtdXRhdGlvbnNbaV07XG4gICAgICAgICAgICAvLyBAdHMtaWdub3JlXG4gICAgICAgICAgICBpZiAocHJvdGVjdFN0eWxlRWwuaGFzQXR0cmlidXRlKCdtb2QnKSAmJiBwcm90ZWN0U3R5bGVFbC5nZXRBdHRyaWJ1dGUoJ21vZCcpID09PSAnaW5uZXInKSB7XG4gICAgICAgICAgICAgICAgLy8gQHRzLWlnbm9yZVxuICAgICAgICAgICAgICAgIHByb3RlY3RTdHlsZUVsLnJlbW92ZUF0dHJpYnV0ZSgnbW9kJyk7XG4gICAgICAgICAgICAgICAgYnJlYWs7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIC8vIEB0cy1pZ25vcmVcbiAgICAgICAgICAgIHByb3RlY3RTdHlsZUVsLnNldEF0dHJpYnV0ZSgnbW9kJywgJ2lubmVyJyk7XG4gICAgICAgICAgICBsZXQgaXNQcm90ZWN0U3R5bGVFbE1vZGlmaWVkID0gZmFsc2U7XG5cbiAgICAgICAgICAgIC8qKlxuICAgICAgICAgICAgICogZnVydGhlciwgdGhlcmUgYXJlIHR3byBtdXR1YWxseSBleGNsdXNpdmUgc2l0dWF0aW9uczogZWl0aGVyIHRoZXJlIHdlcmUgY2hhbmdlc1xuICAgICAgICAgICAgICogdGhlIHRleHQgb2YgcHJvdGVjdFN0eWxlRWwsIGVpdGhlciB0aGVyZSB3YXMgcmVtb3ZlcyBhIHdob2xlIGNoaWxkIFwidGV4dFwiXG4gICAgICAgICAgICAgKiBlbGVtZW50IG9mIHByb3RlY3RTdHlsZUVsIHdlJ2xsIHByb2Nlc3MgYm90aCBvZiB0aGVtXG4gICAgICAgICAgICAgKi9cbiAgICAgICAgICAgIGlmIChtLnJlbW92ZWROb2Rlcy5sZW5ndGggPiAwKSB7XG4gICAgICAgICAgICAgICAgZm9yIChsZXQgaiA9IDA7IGogPCBtLnJlbW92ZWROb2Rlcy5sZW5ndGg7IGogKz0gMSkge1xuICAgICAgICAgICAgICAgICAgICBpc1Byb3RlY3RTdHlsZUVsTW9kaWZpZWQgPSB0cnVlO1xuICAgICAgICAgICAgICAgICAgICBwcm90ZWN0U3R5bGVFbC5hcHBlbmRDaGlsZChtLnJlbW92ZWROb2Rlc1tqXSk7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfSBlbHNlIGlmIChtLm9sZFZhbHVlKSB7XG4gICAgICAgICAgICAgICAgaXNQcm90ZWN0U3R5bGVFbE1vZGlmaWVkID0gdHJ1ZTtcbiAgICAgICAgICAgICAgICAvLyBlc2xpbnQtZGlzYWJsZS1uZXh0LWxpbmUgbm8tcGFyYW0tcmVhc3NpZ25cbiAgICAgICAgICAgICAgICBwcm90ZWN0U3R5bGVFbC50ZXh0Q29udGVudCA9IG0ub2xkVmFsdWU7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIGlmICghaXNQcm90ZWN0U3R5bGVFbE1vZGlmaWVkKSB7XG4gICAgICAgICAgICAgICAgLy8gQHRzLWlnbm9yZVxuICAgICAgICAgICAgICAgIHByb3RlY3RTdHlsZUVsLnJlbW92ZUF0dHJpYnV0ZSgnbW9kJyk7XG4gICAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICB9KSk7XG5cbiAgICBpbm5lck9ic2VydmVyLm9ic2VydmUocHJvdGVjdFN0eWxlRWwsIHtcbiAgICAgICAgY2hpbGRMaXN0OiB0cnVlLFxuICAgICAgICBjaGFyYWN0ZXJEYXRhOiB0cnVlLFxuICAgICAgICBzdWJ0cmVlOiB0cnVlLFxuICAgICAgICBjaGFyYWN0ZXJEYXRhT2xkVmFsdWU6IHRydWUsXG4gICAgfSk7XG59O1xuXG4vKipcbiAqIEFwcGxpZXMgY3NzIHN0eWxlc2hlZXRcbiAqIEBwYXJhbSBzdHlsZVNlbGVjdG9ycyBBcnJheSBvZiBzdHlsZXNoZWV0cyBvciBzZWxlY3RvcnNcbiAqIEBwYXJhbSB2ZXJib3NlIGxvZ2dpbmdcbiAqL1xuY29uc3QgYXBwbHlDc3MgPSAoc3R5bGVTZWxlY3RvcnM6IHN0cmluZ1tdLCB2ZXJib3NlOiBib29sZWFuKSA9PiB7XG4gICAgaWYgKCFzdHlsZVNlbGVjdG9ycyB8fCAhc3R5bGVTZWxlY3RvcnMubGVuZ3RoKSB7XG4gICAgICAgIHJldHVybjtcbiAgICB9XG5cbiAgICBsb2dNZXNzYWdlKHZlcmJvc2UsIGBjc3MgbGVuZ3RoOiAke3N0eWxlU2VsZWN0b3JzLmxlbmd0aH1gKTtcblxuICAgIGNvbnN0IHN0eWxlRWxlbWVudCA9IGRvY3VtZW50LmNyZWF0ZUVsZW1lbnQoJ3N0eWxlJyk7XG4gICAgc3R5bGVFbGVtZW50LnNldEF0dHJpYnV0ZSgndHlwZScsICd0ZXh0L2NzcycpO1xuICAgIChkb2N1bWVudC5oZWFkIHx8IGRvY3VtZW50LmRvY3VtZW50RWxlbWVudCkuYXBwZW5kQ2hpbGQoc3R5bGVFbGVtZW50KTtcblxuICAgIGNvbnN0IHNlbGVjdG9ycyA9IHN0eWxlU2VsZWN0b3JzLm1hcCgocykgPT4gcy50cmltKCkpO1xuICAgIHNlbGVjdG9ycy5mb3JFYWNoKChzZWxlY3RvcikgPT4ge1xuICAgICAgICBzdHlsZUVsZW1lbnQuc2hlZXQhLmluc2VydFJ1bGUoc2VsZWN0b3IpO1xuICAgIH0pO1xuXG4gICAgcHJvdGVjdFN0eWxlRWxlbWVudENvbnRlbnQoc3R5bGVFbGVtZW50KTtcbn07XG5cbi8qKlxuICogQXBwbGllcyBFeHRlbmRlZCBDc3Mgc3R5bGVzaGVldFxuICpcbiAqIEBwYXJhbSBleHRlbmRlZENzcyBBcnJheSB3aXRoIEV4dGVuZGVkQ3NzIHN0eWxlc2hlZXRzXG4gKiBAcGFyYW0gdmVyYm9zZSBsb2dnaW5nXG4gKi9cbmNvbnN0IGFwcGx5RXh0ZW5kZWRDc3MgPSAoZXh0ZW5kZWRDc3M6IHN0cmluZ1tdLCB2ZXJib3NlOiBib29sZWFuKSA9PiB7XG4gICAgaWYgKCFleHRlbmRlZENzcyB8fCAhZXh0ZW5kZWRDc3MubGVuZ3RoKSB7XG4gICAgICAgIHJldHVybjtcbiAgICB9XG5cbiAgICBsb2dNZXNzYWdlKHZlcmJvc2UsIGBleHRlbmRlZCBjc3MgbGVuZ3RoOiAke2V4dGVuZGVkQ3NzLmxlbmd0aH1gKTtcbiAgICBjb25zdCBleHRjc3MgPSBuZXcgRXh0ZW5kZWRDc3Moe1xuICAgICAgICBzdHlsZVNoZWV0OiBleHRlbmRlZENzc1xuICAgICAgICAgICAgLmZpbHRlcigocykgPT4gcy5sZW5ndGggPiAwKVxuICAgICAgICAgICAgLm1hcCgocykgPT4gcy50cmltKCkpXG4gICAgICAgICAgICAubWFwKChzKSA9PiAoc1tzLmxlbmd0aCAtIDFdICE9PSAnfScgPyBgJHtzfSB7ZGlzcGxheTpub25lIWltcG9ydGFudDt9YCA6IHMpKVxuICAgICAgICAgICAgLmpvaW4oJ1xcbicpLFxuICAgIH0pO1xuICAgIGV4dGNzcy5hcHBseSgpO1xufTtcblxuLyoqXG4gKiBBcHBsaWVzIGluamVjdGVkIHNjcmlwdCBhbmQgY3NzXG4gKlxuICogQHBhcmFtIHNlbGVjdG9yc0FuZFNjcmlwdHNcbiAqIEBwYXJhbSB2ZXJib3NlXG4gKi9cbmNvbnN0IGFwcGx5QWR2YW5jZWRCbG9ja2luZ0RhdGEgPSAoc2VsZWN0b3JzQW5kU2NyaXB0czogU2VsZWN0b3JzQW5kU2NyaXB0cywgdmVyYm9zZSA9IHRydWUpID0+IHtcbiAgICBsb2dNZXNzYWdlKHZlcmJvc2UsICdBcHBseWluZyBzY3JpcHRzIGFuZCBjc3MuLicpO1xuICAgIGxvZ01lc3NhZ2UodmVyYm9zZSwgYEZyYW1lIHVybDogJHt3aW5kb3cubG9jYXRpb24uaHJlZn1gKTtcblxuICAgIGFwcGx5U2NyaXB0cyhzZWxlY3RvcnNBbmRTY3JpcHRzLnNjcmlwdHMsIHZlcmJvc2UpO1xuICAgIGFwcGx5Q3NzKHNlbGVjdG9yc0FuZFNjcmlwdHMuY3NzSW5qZWN0LCB2ZXJib3NlKTtcbiAgICBhcHBseUV4dGVuZGVkQ3NzKHNlbGVjdG9yc0FuZFNjcmlwdHMuY3NzRXh0ZW5kZWQsIHZlcmJvc2UpO1xuXG4gICAgbG9nTWVzc2FnZSh2ZXJib3NlLCAnQXBwbHlpbmcgc2NyaXB0cyBhbmQgY3NzIC0gZG9uZScpO1xufTtcblxuY29uc3QgaW5pdCA9IGFzeW5jICgpID0+IHtcbiAgICBpZiAoZG9jdW1lbnQgaW5zdGFuY2VvZiBIVE1MRG9jdW1lbnQpIHtcbiAgICAgICAgaWYgKHdpbmRvdy5sb2NhdGlvbi5ocmVmICYmIHdpbmRvdy5sb2NhdGlvbi5ocmVmLmluZGV4T2YoJ2h0dHAnKSA9PT0gMCkge1xuICAgICAgICAgICAgY29uc3Qgc3RhcnRHZXR0aW5nU2NyaXB0cyA9IERhdGUubm93KCk7XG4gICAgICAgICAgICBsZXQgc2VsZWN0b3JzQW5kU2NyaXB0cztcbiAgICAgICAgICAgIHRyeSB7XG4gICAgICAgICAgICAgICAgc2VsZWN0b3JzQW5kU2NyaXB0cyA9IGF3YWl0IGdldFNlbGVjdG9yc0FuZFNjcmlwdHMoKTtcbiAgICAgICAgICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhlKTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICAgIGNvbnNvbGUubG9nKGBUaW1lIHRvIGdldCBzZWxlY3RvcnMgYW5kIHNjcmlwdHMgZnJvbSBuYXRpdmUgcGFnZSB0byBjb250ZW50IHNjcmlwdDogJHtEYXRlLm5vdygpIC0gc3RhcnRHZXR0aW5nU2NyaXB0c30gbXNgKTtcbiAgICAgICAgICAgIGlmIChzZWxlY3RvcnNBbmRTY3JpcHRzKSB7XG4gICAgICAgICAgICAgICAgYXBwbHlBZHZhbmNlZEJsb2NraW5nRGF0YShzZWxlY3RvcnNBbmRTY3JpcHRzLCBmYWxzZSk7XG4gICAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICB9XG59O1xuXG5leHBvcnQgY29uc3QgY29udGVudCA9IHtcbiAgICBpbml0LFxufTtcbiIsIi8qISBleHRlbmRlZC1jc3MgLSB2MS4zLjEyIC0gTW9uIE1heSAzMSAyMDIxXG4qIGh0dHBzOi8vZ2l0aHViLmNvbS9BZGd1YXJkVGVhbS9FeHRlbmRlZENzc1xuKiBDb3B5cmlnaHQgKGMpIDIwMjEgQWRHdWFyZC4gTGljZW5zZWQgTEdQTC0zLjBcbiovXG5mdW5jdGlvbiBfdHlwZW9mKG9iaikge1xuICBcIkBiYWJlbC9oZWxwZXJzIC0gdHlwZW9mXCI7XG5cbiAgaWYgKHR5cGVvZiBTeW1ib2wgPT09IFwiZnVuY3Rpb25cIiAmJiB0eXBlb2YgU3ltYm9sLml0ZXJhdG9yID09PSBcInN5bWJvbFwiKSB7XG4gICAgX3R5cGVvZiA9IGZ1bmN0aW9uIChvYmopIHtcbiAgICAgIHJldHVybiB0eXBlb2Ygb2JqO1xuICAgIH07XG4gIH0gZWxzZSB7XG4gICAgX3R5cGVvZiA9IGZ1bmN0aW9uIChvYmopIHtcbiAgICAgIHJldHVybiBvYmogJiYgdHlwZW9mIFN5bWJvbCA9PT0gXCJmdW5jdGlvblwiICYmIG9iai5jb25zdHJ1Y3RvciA9PT0gU3ltYm9sICYmIG9iaiAhPT0gU3ltYm9sLnByb3RvdHlwZSA/IFwic3ltYm9sXCIgOiB0eXBlb2Ygb2JqO1xuICAgIH07XG4gIH1cblxuICByZXR1cm4gX3R5cGVvZihvYmopO1xufVxuXG5mdW5jdGlvbiBfc2xpY2VkVG9BcnJheShhcnIsIGkpIHtcbiAgcmV0dXJuIF9hcnJheVdpdGhIb2xlcyhhcnIpIHx8IF9pdGVyYWJsZVRvQXJyYXlMaW1pdChhcnIsIGkpIHx8IF91bnN1cHBvcnRlZEl0ZXJhYmxlVG9BcnJheShhcnIsIGkpIHx8IF9ub25JdGVyYWJsZVJlc3QoKTtcbn1cblxuZnVuY3Rpb24gX3RvQ29uc3VtYWJsZUFycmF5KGFycikge1xuICByZXR1cm4gX2FycmF5V2l0aG91dEhvbGVzKGFycikgfHwgX2l0ZXJhYmxlVG9BcnJheShhcnIpIHx8IF91bnN1cHBvcnRlZEl0ZXJhYmxlVG9BcnJheShhcnIpIHx8IF9ub25JdGVyYWJsZVNwcmVhZCgpO1xufVxuXG5mdW5jdGlvbiBfYXJyYXlXaXRob3V0SG9sZXMoYXJyKSB7XG4gIGlmIChBcnJheS5pc0FycmF5KGFycikpIHJldHVybiBfYXJyYXlMaWtlVG9BcnJheShhcnIpO1xufVxuXG5mdW5jdGlvbiBfYXJyYXlXaXRoSG9sZXMoYXJyKSB7XG4gIGlmIChBcnJheS5pc0FycmF5KGFycikpIHJldHVybiBhcnI7XG59XG5cbmZ1bmN0aW9uIF9pdGVyYWJsZVRvQXJyYXkoaXRlcikge1xuICBpZiAodHlwZW9mIFN5bWJvbCAhPT0gXCJ1bmRlZmluZWRcIiAmJiBTeW1ib2wuaXRlcmF0b3IgaW4gT2JqZWN0KGl0ZXIpKSByZXR1cm4gQXJyYXkuZnJvbShpdGVyKTtcbn1cblxuZnVuY3Rpb24gX2l0ZXJhYmxlVG9BcnJheUxpbWl0KGFyciwgaSkge1xuICBpZiAodHlwZW9mIFN5bWJvbCA9PT0gXCJ1bmRlZmluZWRcIiB8fCAhKFN5bWJvbC5pdGVyYXRvciBpbiBPYmplY3QoYXJyKSkpIHJldHVybjtcbiAgdmFyIF9hcnIgPSBbXTtcbiAgdmFyIF9uID0gdHJ1ZTtcbiAgdmFyIF9kID0gZmFsc2U7XG4gIHZhciBfZSA9IHVuZGVmaW5lZDtcblxuICB0cnkge1xuICAgIGZvciAodmFyIF9pID0gYXJyW1N5bWJvbC5pdGVyYXRvcl0oKSwgX3M7ICEoX24gPSAoX3MgPSBfaS5uZXh0KCkpLmRvbmUpOyBfbiA9IHRydWUpIHtcbiAgICAgIF9hcnIucHVzaChfcy52YWx1ZSk7XG5cbiAgICAgIGlmIChpICYmIF9hcnIubGVuZ3RoID09PSBpKSBicmVhaztcbiAgICB9XG4gIH0gY2F0Y2ggKGVycikge1xuICAgIF9kID0gdHJ1ZTtcbiAgICBfZSA9IGVycjtcbiAgfSBmaW5hbGx5IHtcbiAgICB0cnkge1xuICAgICAgaWYgKCFfbiAmJiBfaVtcInJldHVyblwiXSAhPSBudWxsKSBfaVtcInJldHVyblwiXSgpO1xuICAgIH0gZmluYWxseSB7XG4gICAgICBpZiAoX2QpIHRocm93IF9lO1xuICAgIH1cbiAgfVxuXG4gIHJldHVybiBfYXJyO1xufVxuXG5mdW5jdGlvbiBfdW5zdXBwb3J0ZWRJdGVyYWJsZVRvQXJyYXkobywgbWluTGVuKSB7XG4gIGlmICghbykgcmV0dXJuO1xuICBpZiAodHlwZW9mIG8gPT09IFwic3RyaW5nXCIpIHJldHVybiBfYXJyYXlMaWtlVG9BcnJheShvLCBtaW5MZW4pO1xuICB2YXIgbiA9IE9iamVjdC5wcm90b3R5cGUudG9TdHJpbmcuY2FsbChvKS5zbGljZSg4LCAtMSk7XG4gIGlmIChuID09PSBcIk9iamVjdFwiICYmIG8uY29uc3RydWN0b3IpIG4gPSBvLmNvbnN0cnVjdG9yLm5hbWU7XG4gIGlmIChuID09PSBcIk1hcFwiIHx8IG4gPT09IFwiU2V0XCIpIHJldHVybiBBcnJheS5mcm9tKG8pO1xuICBpZiAobiA9PT0gXCJBcmd1bWVudHNcIiB8fCAvXig/OlVpfEkpbnQoPzo4fDE2fDMyKSg/OkNsYW1wZWQpP0FycmF5JC8udGVzdChuKSkgcmV0dXJuIF9hcnJheUxpa2VUb0FycmF5KG8sIG1pbkxlbik7XG59XG5cbmZ1bmN0aW9uIF9hcnJheUxpa2VUb0FycmF5KGFyciwgbGVuKSB7XG4gIGlmIChsZW4gPT0gbnVsbCB8fCBsZW4gPiBhcnIubGVuZ3RoKSBsZW4gPSBhcnIubGVuZ3RoO1xuXG4gIGZvciAodmFyIGkgPSAwLCBhcnIyID0gbmV3IEFycmF5KGxlbik7IGkgPCBsZW47IGkrKykgYXJyMltpXSA9IGFycltpXTtcblxuICByZXR1cm4gYXJyMjtcbn1cblxuZnVuY3Rpb24gX25vbkl0ZXJhYmxlU3ByZWFkKCkge1xuICB0aHJvdyBuZXcgVHlwZUVycm9yKFwiSW52YWxpZCBhdHRlbXB0IHRvIHNwcmVhZCBub24taXRlcmFibGUgaW5zdGFuY2UuXFxuSW4gb3JkZXIgdG8gYmUgaXRlcmFibGUsIG5vbi1hcnJheSBvYmplY3RzIG11c3QgaGF2ZSBhIFtTeW1ib2wuaXRlcmF0b3JdKCkgbWV0aG9kLlwiKTtcbn1cblxuZnVuY3Rpb24gX25vbkl0ZXJhYmxlUmVzdCgpIHtcbiAgdGhyb3cgbmV3IFR5cGVFcnJvcihcIkludmFsaWQgYXR0ZW1wdCB0byBkZXN0cnVjdHVyZSBub24taXRlcmFibGUgaW5zdGFuY2UuXFxuSW4gb3JkZXIgdG8gYmUgaXRlcmFibGUsIG5vbi1hcnJheSBvYmplY3RzIG11c3QgaGF2ZSBhIFtTeW1ib2wuaXRlcmF0b3JdKCkgbWV0aG9kLlwiKTtcbn1cblxuLyoqXG4gKiBDb3B5cmlnaHQgMjAxNiBBZGd1YXJkIFNvZnR3YXJlIEx0ZFxuICpcbiAqIExpY2Vuc2VkIHVuZGVyIHRoZSBBcGFjaGUgTGljZW5zZSwgVmVyc2lvbiAyLjAgKHRoZSBcIkxpY2Vuc2VcIik7XG4gKiB5b3UgbWF5IG5vdCB1c2UgdGhpcyBmaWxlIGV4Y2VwdCBpbiBjb21wbGlhbmNlIHdpdGggdGhlIExpY2Vuc2UuXG4gKiBZb3UgbWF5IG9idGFpbiBhIGNvcHkgb2YgdGhlIExpY2Vuc2UgYXRcbiAqXG4gKiBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElDRU5TRS0yLjBcbiAqXG4gKiBVbmxlc3MgcmVxdWlyZWQgYnkgYXBwbGljYWJsZSBsYXcgb3IgYWdyZWVkIHRvIGluIHdyaXRpbmcsIHNvZnR3YXJlXG4gKiBkaXN0cmlidXRlZCB1bmRlciB0aGUgTGljZW5zZSBpcyBkaXN0cmlidXRlZCBvbiBhbiBcIkFTIElTXCIgQkFTSVMsXG4gKiBXSVRIT1VUIFdBUlJBTlRJRVMgT1IgQ09ORElUSU9OUyBPRiBBTlkgS0lORCwgZWl0aGVyIGV4cHJlc3Mgb3IgaW1wbGllZC5cbiAqIFNlZSB0aGUgTGljZW5zZSBmb3IgdGhlIHNwZWNpZmljIGxhbmd1YWdlIGdvdmVybmluZyBwZXJtaXNzaW9ucyBhbmRcbiAqIGxpbWl0YXRpb25zIHVuZGVyIHRoZSBMaWNlbnNlLlxuICovXG5cbi8qIGVzbGludC1kaXNhYmxlIG5vLWNvbnNvbGUgKi9cbnZhciB1dGlscyA9IHt9O1xudXRpbHMuTXV0YXRpb25PYnNlcnZlciA9IHdpbmRvdy5NdXRhdGlvbk9ic2VydmVyIHx8IHdpbmRvdy5XZWJLaXRNdXRhdGlvbk9ic2VydmVyO1xuLyoqXG4gKiBTdG9yZXMgbmF0aXZlIE5vZGUgdGV4dENvbnRlbnQgZ2V0dGVyIHRvIGJlIHVzZWQgZm9yIGNvbnRhaW5zIHBzZXVkby1jbGFzc1xuICogYmVjYXVzZSBlbGVtZW50cycgJ3RleHRDb250ZW50JyBhbmQgJ2lubmVyVGV4dCcgcHJvcGVydGllcyBtaWdodCBiZSBtb2NrZWRcbiAqIGh0dHBzOi8vZ2l0aHViLmNvbS9BZGd1YXJkVGVhbS9FeHRlbmRlZENzcy9pc3N1ZXMvMTI3XG4gKi9cblxudXRpbHMubm9kZVRleHRDb250ZW50R2V0dGVyID0gZnVuY3Rpb24gKCkge1xuICB2YXIgbmF0aXZlTm9kZSA9IHdpbmRvdy5Ob2RlIHx8IE5vZGU7XG4gIHJldHVybiBPYmplY3QuZ2V0T3duUHJvcGVydHlEZXNjcmlwdG9yKG5hdGl2ZU5vZGUucHJvdG90eXBlLCAndGV4dENvbnRlbnQnKS5nZXQ7XG59KCk7XG5cbnV0aWxzLmlzU2FmYXJpQnJvd3NlciA9IGZ1bmN0aW9uICgpIHtcbiAgdmFyIGlzQ2hyb21lID0gbmF2aWdhdG9yLnVzZXJBZ2VudC5pbmRleE9mKCdDaHJvbWUnKSA+IC0xO1xuICB2YXIgaXNTYWZhcmkgPSBuYXZpZ2F0b3IudXNlckFnZW50LmluZGV4T2YoJ1NhZmFyaScpID4gLTE7XG5cbiAgaWYgKGlzU2FmYXJpKSB7XG4gICAgaWYgKGlzQ2hyb21lKSB7XG4gICAgICAvLyBDaHJvbWUgc2VlbXMgdG8gaGF2ZSBib3RoIENocm9tZSBhbmQgU2FmYXJpIHVzZXJBZ2VudHNcbiAgICAgIHJldHVybiBmYWxzZTtcbiAgICB9XG5cbiAgICByZXR1cm4gdHJ1ZTtcbiAgfVxuXG4gIHJldHVybiBmYWxzZTtcbn0oKTtcbi8qKlxuICogQ29udmVydHMgcmVndWxhciBleHByZXNzaW9ucyBwYXNzZWQgYXMgcHNldWRvIGNsYXNzIGFyZ3VtZW50cyBpbnRvIFJlZ0V4cCBpbnN0YW5jZXMuXG4gKiBIYXZlIHRvIHVuZXNjYXBlIGRvdWJsZXF1b3RlIFwiIGFzIHdlbGwsIGJlY2F1c2Ugd2UgZXNjYXBlIHRoZW0gd2hpbGUgZW5jbG9zaW5nIHN1Y2hcbiAqIGFyZ3VtZW50cyB3aXRoIGRvdWJsZXF1b3RlcywgYW5kIHNpenpsZSBkb2VzIG5vdCBhdXRvbWF0aWNhbGx5IHVuZXNjYXBlcyB0aGVtLlxuICovXG5cblxudXRpbHMucHNldWRvQXJnVG9SZWdleCA9IGZ1bmN0aW9uIChyZWdleFNyYywgZmxhZykge1xuICBmbGFnID0gZmxhZyB8fCAnaSc7XG4gIHJlZ2V4U3JjID0gcmVnZXhTcmMudHJpbSgpLnJlcGxhY2UoL1xcXFwoW1wiXFxcXF0pL2csICckMScpO1xuICByZXR1cm4gbmV3IFJlZ0V4cChyZWdleFNyYywgZmxhZyk7XG59O1xuLyoqXG4gKiBDb252ZXJ0cyBzdHJpbmcgdG8gdGhlIHJlZ2V4cFxuICogQHBhcmFtIHtzdHJpbmd9IHN0clxuICogQHJldHVybnMge1JlZ0V4cH1cbiAqL1xuXG5cbnV0aWxzLnRvUmVnRXhwID0gZnVuY3Rpb24gKHN0cikge1xuICBpZiAoc3RyWzBdID09PSAnLycgJiYgc3RyW3N0ci5sZW5ndGggLSAxXSA9PT0gJy8nKSB7XG4gICAgcmV0dXJuIG5ldyBSZWdFeHAoc3RyLnNsaWNlKDEsIC0xKSk7XG4gIH1cblxuICB2YXIgZXNjYXBlZCA9IHN0ci5yZXBsYWNlKC9bLiorP14ke30oKXxbXFxdXFxcXF0vZywgJ1xcXFwkJicpO1xuICByZXR1cm4gbmV3IFJlZ0V4cChlc2NhcGVkKTtcbn07XG5cbnV0aWxzLnN0YXJ0c1dpdGggPSBmdW5jdGlvbiAoc3RyLCBwcmVmaXgpIHtcbiAgLy8gaWYgc3RyID09PSAnJywgKHN0ciAmJiBmYWxzZSkgd2lsbCByZXR1cm4gJydcbiAgLy8gdGhhdCdzIHdoeSBpdCBoYXMgdG8gYmUgISFzdHJcbiAgcmV0dXJuICEhc3RyICYmIHN0ci5pbmRleE9mKHByZWZpeCkgPT09IDA7XG59O1xuXG51dGlscy5lbmRzV2l0aCA9IGZ1bmN0aW9uIChzdHIsIHBvc3RmaXgpIHtcbiAgaWYgKCFzdHIgfHwgIXBvc3RmaXgpIHtcbiAgICByZXR1cm4gZmFsc2U7XG4gIH1cblxuICBpZiAoc3RyLmVuZHNXaXRoKSB7XG4gICAgcmV0dXJuIHN0ci5lbmRzV2l0aChwb3N0Zml4KTtcbiAgfVxuXG4gIHZhciB0ID0gU3RyaW5nKHBvc3RmaXgpO1xuICB2YXIgaW5kZXggPSBzdHIubGFzdEluZGV4T2YodCk7XG4gIHJldHVybiBpbmRleCA+PSAwICYmIGluZGV4ID09PSBzdHIubGVuZ3RoIC0gdC5sZW5ndGg7XG59O1xuLyoqXG4gKiBIZWxwZXIgZnVuY3Rpb24gZm9yIGNyZWF0aW5nIHJlZ3VsYXIgZXhwcmVzc2lvbiBmcm9tIGEgdXJsIGZpbHRlciBydWxlIHN5bnRheC5cbiAqL1xuXG5cbnV0aWxzLmNyZWF0ZVVSTFJlZ2V4ID0gZnVuY3Rpb24gKCkge1xuICAvLyBDb25zdGFudHNcbiAgdmFyIHJlZ2V4Q29uZmlndXJhdGlvbiA9IHtcbiAgICBtYXNrU3RhcnRVcmw6ICd8fCcsXG4gICAgbWFza1BpcGU6ICd8JyxcbiAgICBtYXNrU2VwYXJhdG9yOiAnXicsXG4gICAgbWFza0FueVN5bWJvbDogJyonLFxuICAgIHJlZ2V4QW55U3ltYm9sOiAnLionLFxuICAgIHJlZ2V4U2VwYXJhdG9yOiAnKFteIGEtekEtWjAtOS4lXy1dfCQpJyxcbiAgICByZWdleFN0YXJ0VXJsOiAnXihodHRwfGh0dHBzfHdzfHdzcyk6Ly8oW2EtejAtOS1fLl0rXFxcXC4pPycsXG4gICAgcmVnZXhTdGFydFN0cmluZzogJ14nLFxuICAgIHJlZ2V4RW5kU3RyaW5nOiAnJCdcbiAgfTsgLy8gaHR0cHM6Ly9kZXZlbG9wZXIubW96aWxsYS5vcmcvZW4vSmF2YVNjcmlwdC9SZWZlcmVuY2UvR2xvYmFsX09iamVjdHMvcmVnZXhwXG4gIC8vIHNob3VsZCBiZSBlc2NhcGVkIC4gKiArID8gXiAkIHsgfSAoICkgfCBbIF0gLyBcXFxuICAvLyBleGNlcHQgb2YgKiB8IF5cblxuICB2YXIgc3BlY2lhbHMgPSBbJy4nLCAnKycsICc/JywgJyQnLCAneycsICd9JywgJygnLCAnKScsICdbJywgJ10nLCAnXFxcXCcsICcvJ107XG4gIHZhciBzcGVjaWFsc1JlZ2V4ID0gbmV3IFJlZ0V4cChcIltcIi5jb25jYXQoc3BlY2lhbHMuam9pbignXFxcXCcpLCBcIl1cIiksICdnJyk7XG4gIC8qKlxuICAgKiBFc2NhcGVzIHJlZ3VsYXIgZXhwcmVzc2lvbiBzdHJpbmdcbiAgICovXG5cbiAgdmFyIGVzY2FwZVJlZ0V4cCA9IGZ1bmN0aW9uIGVzY2FwZVJlZ0V4cChzdHIpIHtcbiAgICByZXR1cm4gc3RyLnJlcGxhY2Uoc3BlY2lhbHNSZWdleCwgJ1xcXFwkJicpO1xuICB9O1xuXG4gIHZhciByZXBsYWNlQWxsID0gZnVuY3Rpb24gcmVwbGFjZUFsbChzdHIsIGZpbmQsIHJlcGxhY2UpIHtcbiAgICBpZiAoIXN0cikge1xuICAgICAgcmV0dXJuIHN0cjtcbiAgICB9XG5cbiAgICByZXR1cm4gc3RyLnNwbGl0KGZpbmQpLmpvaW4ocmVwbGFjZSk7XG4gIH07XG4gIC8qKlxuICAgKiBNYWluIGZ1bmN0aW9uIHRoYXQgY29udmVydHMgYSB1cmwgZmlsdGVyIHJ1bGUgc3RyaW5nIHRvIGEgcmVnZXguXG4gICAqIEBwYXJhbSB7c3RyaW5nfSBzdHJcbiAgICogQHJldHVybiB7UmVnRXhwfVxuICAgKi9cblxuXG4gIHZhciBjcmVhdGVSZWdleFRleHQgPSBmdW5jdGlvbiBjcmVhdGVSZWdleFRleHQoc3RyKSB7XG4gICAgdmFyIHJlZ2V4ID0gZXNjYXBlUmVnRXhwKHN0cik7XG5cbiAgICBpZiAodXRpbHMuc3RhcnRzV2l0aChyZWdleCwgcmVnZXhDb25maWd1cmF0aW9uLm1hc2tTdGFydFVybCkpIHtcbiAgICAgIHJlZ2V4ID0gcmVnZXguc3Vic3RyaW5nKDAsIHJlZ2V4Q29uZmlndXJhdGlvbi5tYXNrU3RhcnRVcmwubGVuZ3RoKSArIHJlcGxhY2VBbGwocmVnZXguc3Vic3RyaW5nKHJlZ2V4Q29uZmlndXJhdGlvbi5tYXNrU3RhcnRVcmwubGVuZ3RoLCByZWdleC5sZW5ndGggLSAxKSwgJ1xcfCcsICdcXFxcfCcpICsgcmVnZXguc3Vic3RyaW5nKHJlZ2V4Lmxlbmd0aCAtIDEpO1xuICAgIH0gZWxzZSBpZiAodXRpbHMuc3RhcnRzV2l0aChyZWdleCwgcmVnZXhDb25maWd1cmF0aW9uLm1hc2tQaXBlKSkge1xuICAgICAgcmVnZXggPSByZWdleC5zdWJzdHJpbmcoMCwgcmVnZXhDb25maWd1cmF0aW9uLm1hc2tQaXBlLmxlbmd0aCkgKyByZXBsYWNlQWxsKHJlZ2V4LnN1YnN0cmluZyhyZWdleENvbmZpZ3VyYXRpb24ubWFza1BpcGUubGVuZ3RoLCByZWdleC5sZW5ndGggLSAxKSwgJ1xcfCcsICdcXFxcfCcpICsgcmVnZXguc3Vic3RyaW5nKHJlZ2V4Lmxlbmd0aCAtIDEpO1xuICAgIH0gZWxzZSB7XG4gICAgICByZWdleCA9IHJlcGxhY2VBbGwocmVnZXguc3Vic3RyaW5nKDAsIHJlZ2V4Lmxlbmd0aCAtIDEpLCAnXFx8JywgJ1xcXFx8JykgKyByZWdleC5zdWJzdHJpbmcocmVnZXgubGVuZ3RoIC0gMSk7XG4gICAgfSAvLyBSZXBsYWNpbmcgc3BlY2lhbCB1cmwgbWFza3NcblxuXG4gICAgcmVnZXggPSByZXBsYWNlQWxsKHJlZ2V4LCByZWdleENvbmZpZ3VyYXRpb24ubWFza0FueVN5bWJvbCwgcmVnZXhDb25maWd1cmF0aW9uLnJlZ2V4QW55U3ltYm9sKTtcbiAgICByZWdleCA9IHJlcGxhY2VBbGwocmVnZXgsIHJlZ2V4Q29uZmlndXJhdGlvbi5tYXNrU2VwYXJhdG9yLCByZWdleENvbmZpZ3VyYXRpb24ucmVnZXhTZXBhcmF0b3IpO1xuXG4gICAgaWYgKHV0aWxzLnN0YXJ0c1dpdGgocmVnZXgsIHJlZ2V4Q29uZmlndXJhdGlvbi5tYXNrU3RhcnRVcmwpKSB7XG4gICAgICByZWdleCA9IHJlZ2V4Q29uZmlndXJhdGlvbi5yZWdleFN0YXJ0VXJsICsgcmVnZXguc3Vic3RyaW5nKHJlZ2V4Q29uZmlndXJhdGlvbi5tYXNrU3RhcnRVcmwubGVuZ3RoKTtcbiAgICB9IGVsc2UgaWYgKHV0aWxzLnN0YXJ0c1dpdGgocmVnZXgsIHJlZ2V4Q29uZmlndXJhdGlvbi5tYXNrUGlwZSkpIHtcbiAgICAgIHJlZ2V4ID0gcmVnZXhDb25maWd1cmF0aW9uLnJlZ2V4U3RhcnRTdHJpbmcgKyByZWdleC5zdWJzdHJpbmcocmVnZXhDb25maWd1cmF0aW9uLm1hc2tQaXBlLmxlbmd0aCk7XG4gICAgfVxuXG4gICAgaWYgKHV0aWxzLmVuZHNXaXRoKHJlZ2V4LCByZWdleENvbmZpZ3VyYXRpb24ubWFza1BpcGUpKSB7XG4gICAgICByZWdleCA9IHJlZ2V4LnN1YnN0cmluZygwLCByZWdleC5sZW5ndGggLSAxKSArIHJlZ2V4Q29uZmlndXJhdGlvbi5yZWdleEVuZFN0cmluZztcbiAgICB9XG5cbiAgICByZXR1cm4gbmV3IFJlZ0V4cChyZWdleCwgJ2knKTtcbiAgfTtcblxuICByZXR1cm4gY3JlYXRlUmVnZXhUZXh0O1xufSgpO1xuLyoqXG4gKiBDcmVhdGVzIGFuIG9iamVjdCBpbXBsZW1lbnRpbmcgTG9jYXRpb24gaW50ZXJmYWNlIGZyb20gYSB1cmwuXG4gKiBBbiBhbHRlcm5hdGl2ZSB0byBVUkwuXG4gKiBodHRwczovL2dpdGh1Yi5jb20vQWRndWFyZFRlYW0vRmluZ2VycHJpbnRpbmdCbG9ja2VyL2Jsb2IvbWFzdGVyL3NyYy9zaGFyZWQvdXJsLnRzI0w2NFxuICovXG5cblxudXRpbHMuY3JlYXRlTG9jYXRpb24gPSBmdW5jdGlvbiAoaHJlZikge1xuICB2YXIgYW5jaG9yID0gZG9jdW1lbnQuY3JlYXRlRWxlbWVudCgnYScpO1xuICBhbmNob3IuaHJlZiA9IGhyZWY7XG5cbiAgaWYgKGFuY2hvci5ob3N0ID09PSAnJykge1xuICAgIGFuY2hvci5ocmVmID0gYW5jaG9yLmhyZWY7IC8vIGVzbGludC1kaXNhYmxlLWxpbmUgbm8tc2VsZi1hc3NpZ25cbiAgfVxuXG4gIHJldHVybiBhbmNob3I7XG59O1xuLyoqXG4gKiBDaGVja3Mgd2hldGhlciBBIGhhcyB0aGUgc2FtZSBvcmlnaW4gYXMgQi5cbiAqIEBwYXJhbSB7c3RyaW5nfSB1cmxBIGxvY2F0aW9uLmhyZWYgb2YgQS5cbiAqIEBwYXJhbSB7TG9jYXRpb259IGxvY2F0aW9uQiBsb2NhdGlvbiBvZiBCLlxuICogQHBhcmFtIHtzdHJpbmd9IGRvbWFpbkIgZG9jdW1lbnQuZG9tYWluIG9mIEIuXG4gKiBAcmV0dXJuIHtib29sZWFufVxuICovXG5cblxudXRpbHMuaXNTYW1lT3JpZ2luID0gZnVuY3Rpb24gKHVybEEsIGxvY2F0aW9uQiwgZG9tYWluQikge1xuICB2YXIgbG9jYXRpb25BID0gdXRpbHMuY3JlYXRlTG9jYXRpb24odXJsQSk7IC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBuby1zY3JpcHQtdXJsXG5cbiAgaWYgKGxvY2F0aW9uQS5wcm90b2NvbCA9PT0gJ2phdmFzY3JpcHQ6JyB8fCBsb2NhdGlvbkEuaHJlZiA9PT0gJ2Fib3V0OmJsYW5rJykge1xuICAgIHJldHVybiB0cnVlO1xuICB9XG5cbiAgaWYgKGxvY2F0aW9uQS5wcm90b2NvbCA9PT0gJ2RhdGE6JyB8fCBsb2NhdGlvbkEucHJvdG9jb2wgPT09ICdmaWxlOicpIHtcbiAgICByZXR1cm4gZmFsc2U7XG4gIH1cblxuICByZXR1cm4gbG9jYXRpb25BLmhvc3RuYW1lID09PSBkb21haW5CICYmIGxvY2F0aW9uQS5wb3J0ID09PSBsb2NhdGlvbkIucG9ydCAmJiBsb2NhdGlvbkEucHJvdG9jb2wgPT09IGxvY2F0aW9uQi5wcm90b2NvbDtcbn07XG4vKipcbiAqIEEgaGVscGVyIGNsYXNzIHRvIHRocm90dGxlIGZ1bmN0aW9uIGNhbGxzIHdpdGggc2V0VGltZW91dCBhbmQgcmVxdWVzdEFuaW1hdGlvbkZyYW1lLlxuICovXG5cblxudXRpbHMuQXN5bmNXcmFwcGVyID0gZnVuY3Rpb24gKCkge1xuICAvKipcbiAgICogUGhhbnRvbUpTIHBhc3NlcyBhIHdyb25nIHRpbWVzdGFtcCB0byB0aGUgcmVxdWVzdEFuaW1hdGlvbkZyYW1lIGNhbGxiYWNrIGFuZCB0aGF0IGJyZWFrcyB0aGUgQXN5bmNXcmFwcGVyIGxvZ2ljXG4gICAqIGh0dHBzOi8vZ2l0aHViLmNvbS9hcml5YS9waGFudG9tanMvaXNzdWVzLzE0ODMyXG4gICAqL1xuICB2YXIgc3VwcG9ydGVkID0gdHlwZW9mIHdpbmRvdy5yZXF1ZXN0QW5pbWF0aW9uRnJhbWUgIT09ICd1bmRlZmluZWQnICYmICEvcGhhbnRvbS9pLnRlc3QobmF2aWdhdG9yLnVzZXJBZ2VudCk7XG4gIHZhciByQUYgPSBzdXBwb3J0ZWQgPyByZXF1ZXN0QW5pbWF0aW9uRnJhbWUgOiBzZXRUaW1lb3V0O1xuICB2YXIgY0FGID0gc3VwcG9ydGVkID8gY2FuY2VsQW5pbWF0aW9uRnJhbWUgOiBjbGVhclRpbWVvdXQ7XG4gIHZhciBwZXJmID0gc3VwcG9ydGVkID8gcGVyZm9ybWFuY2UgOiBEYXRlO1xuICAvKipcbiAgICogQHBhcmFtIHtGdW5jdGlvbn0gY2FsbGJhY2tcbiAgICogQHBhcmFtIHtudW1iZXJ9IHRocm90dGxlIG51bWJlciwgdGhlIHByb3ZpZGVkIGNhbGxiYWNrIHNob3VsZCBiZSBleGVjdXRlZCB0d2ljZVxuICAgKiBpbiB0aGlzIHRpbWUgZnJhbWUuXG4gICAqIEBjb25zdHJ1Y3RvclxuICAgKi9cblxuICBmdW5jdGlvbiBBc3luY1dyYXBwZXIoY2FsbGJhY2ssIHRocm90dGxlKSB7XG4gICAgdGhpcy5jYWxsYmFjayA9IGNhbGxiYWNrO1xuICAgIHRoaXMudGhyb3R0bGUgPSB0aHJvdHRsZTtcbiAgICB0aGlzLndyYXBwZWRDYWxsYmFjayA9IHRoaXMud3JhcHBlZENhbGxiYWNrLmJpbmQodGhpcyk7XG5cbiAgICBpZiAodGhpcy53cmFwcGVkQXNhcENhbGxiYWNrKSB7XG4gICAgICB0aGlzLndyYXBwZWRBc2FwQ2FsbGJhY2sgPSB0aGlzLndyYXBwZWRBc2FwQ2FsbGJhY2suYmluZCh0aGlzKTtcbiAgICB9XG4gIH1cbiAgLyoqIEBwcml2YXRlICovXG5cblxuICBBc3luY1dyYXBwZXIucHJvdG90eXBlLndyYXBwZWRDYWxsYmFjayA9IGZ1bmN0aW9uICh0cykge1xuICAgIHRoaXMubGFzdFJ1biA9IGlzTnVtYmVyKHRzKSA/IHRzIDogcGVyZi5ub3coKTtcbiAgICBkZWxldGUgdGhpcy5yQUZpZDtcbiAgICBkZWxldGUgdGhpcy50aW1lcklkO1xuICAgIGRlbGV0ZSB0aGlzLmFzYXBTY2hlZHVsZWQ7XG4gICAgdGhpcy5jYWxsYmFjaygpO1xuICB9O1xuICAvKiogQHByaXZhdGUgSW5kaWNhdGVzIHdoZXRoZXIgdGhlcmUgaXMgYSBzY2hlZHVsZWQgY2FsbGJhY2suICovXG5cblxuICBBc3luY1dyYXBwZXIucHJvdG90eXBlLmhhc1BlbmRpbmdDYWxsYmFjayA9IGZ1bmN0aW9uICgpIHtcbiAgICByZXR1cm4gaXNOdW1iZXIodGhpcy5yQUZpZCkgfHwgaXNOdW1iZXIodGhpcy50aW1lcklkKTtcbiAgfTtcbiAgLyoqXG4gICAqIFNjaGVkdWxlcyBhIGZ1bmN0aW9uIGNhbGwgYmVmb3JlIHRoZSBuZXh0IGFuaW1hdGlvbiBmcmFtZS5cbiAgICovXG5cblxuICBBc3luY1dyYXBwZXIucHJvdG90eXBlLnJ1biA9IGZ1bmN0aW9uICgpIHtcbiAgICBpZiAodGhpcy5oYXNQZW5kaW5nQ2FsbGJhY2soKSkge1xuICAgICAgLy8gVGhlcmUgaXMgYSBwZW5kaW5nIGV4ZWN1dGlvbiBzY2hlZHVsZWQuXG4gICAgICByZXR1cm47XG4gICAgfVxuXG4gICAgaWYgKHR5cGVvZiB0aGlzLmxhc3RSdW4gIT09ICd1bmRlZmluZWQnKSB7XG4gICAgICB2YXIgZWxhcHNlZCA9IHBlcmYubm93KCkgLSB0aGlzLmxhc3RSdW47XG5cbiAgICAgIGlmIChlbGFwc2VkIDwgdGhpcy50aHJvdHRsZSkge1xuICAgICAgICB0aGlzLnRpbWVySWQgPSBzZXRUaW1lb3V0KHRoaXMud3JhcHBlZENhbGxiYWNrLCB0aGlzLnRocm90dGxlIC0gZWxhcHNlZCk7XG4gICAgICAgIHJldHVybjtcbiAgICAgIH1cbiAgICB9XG5cbiAgICB0aGlzLnJBRmlkID0gckFGKHRoaXMud3JhcHBlZENhbGxiYWNrKTtcbiAgfTtcbiAgLyoqXG4gICAqIFNjaGVkdWxlcyBhIGZ1bmN0aW9uIGNhbGwgaW4gdGhlIG1vc3QgaW1tZW5lbnQgbWljcm90YXNrLlxuICAgKiBUaGlzIGNhbm5vdCBiZSBjYW5jZWxlZC5cbiAgICovXG5cblxuICBBc3luY1dyYXBwZXIucHJvdG90eXBlLnJ1bkFzYXAgPSBmdW5jdGlvbiAoKSB7XG4gICAgaWYgKHRoaXMuYXNhcFNjaGVkdWxlZCkge1xuICAgICAgcmV0dXJuO1xuICAgIH1cblxuICAgIHRoaXMuYXNhcFNjaGVkdWxlZCA9IHRydWU7XG4gICAgY0FGKHRoaXMuckFGaWQpO1xuICAgIGNsZWFyVGltZW91dCh0aGlzLnRpbWVySWQpO1xuXG4gICAgaWYgKHV0aWxzLk11dGF0aW9uT2JzZXJ2ZXIpIHtcbiAgICAgIC8qKlxuICAgICAgICogVXNpbmcgTXV0YXRpb25PYnNlcnZlcnMgdG8gYWNjZXNzIG1pY3JvdGFzayBxdWV1ZSBpcyBhIHN0YW5kYXJkIHRlY2huaXF1ZSxcbiAgICAgICAqIHVzZWQgaW4gQVNBUCBsaWJyYXJ5XG4gICAgICAgKiB7QGxpbmsgaHR0cHM6Ly9naXRodWIuY29tL2tyaXNrb3dhbC9hc2FwL2Jsb2IvbWFzdGVyL2Jyb3dzZXItcmF3LmpzI0wxNDB9XG4gICAgICAgKi9cbiAgICAgIGlmICghdGhpcy5tbykge1xuICAgICAgICB0aGlzLm1vID0gbmV3IHV0aWxzLk11dGF0aW9uT2JzZXJ2ZXIodGhpcy53cmFwcGVkQ2FsbGJhY2spO1xuICAgICAgICB0aGlzLm5vZGUgPSBkb2N1bWVudC5jcmVhdGVUZXh0Tm9kZSgxKTtcbiAgICAgICAgdGhpcy5tby5vYnNlcnZlKHRoaXMubm9kZSwge1xuICAgICAgICAgIGNoYXJhY3RlckRhdGE6IHRydWVcbiAgICAgICAgfSk7XG4gICAgICB9XG5cbiAgICAgIHRoaXMubm9kZS5ub2RlVmFsdWUgPSAtdGhpcy5ub2RlLm5vZGVWYWx1ZTtcbiAgICB9IGVsc2Uge1xuICAgICAgc2V0VGltZW91dCh0aGlzLndyYXBwZWRDYWxsYmFjayk7XG4gICAgfVxuICB9O1xuICAvKipcbiAgICogUnVucyBzY2hlZHVsZWQgZXhlY3V0aW9uIGltbWVkaWF0ZWx5LCBpZiB0aGVyZSB3ZXJlIGFueS5cbiAgICovXG5cblxuICBBc3luY1dyYXBwZXIucHJvdG90eXBlLnJ1bkltbWVkaWF0ZWx5ID0gZnVuY3Rpb24gKCkge1xuICAgIGlmICh0aGlzLmhhc1BlbmRpbmdDYWxsYmFjaygpKSB7XG4gICAgICBjQUYodGhpcy5yQUZpZCk7XG4gICAgICBjbGVhclRpbWVvdXQodGhpcy50aW1lcklkKTtcbiAgICAgIGRlbGV0ZSB0aGlzLnJBRmlkO1xuICAgICAgZGVsZXRlIHRoaXMudGltZXJJZDtcbiAgICAgIHRoaXMud3JhcHBlZENhbGxiYWNrKCk7XG4gICAgfVxuICB9O1xuXG4gIEFzeW5jV3JhcHBlci5ub3cgPSBmdW5jdGlvbiAoKSB7XG4gICAgcmV0dXJuIHBlcmYubm93KCk7XG4gIH07XG5cbiAgcmV0dXJuIEFzeW5jV3JhcHBlcjtcbn0oKTtcbi8qKlxuICogU3RvcmVzIG5hdGl2ZSBPZFAgdG8gYmUgdXNlZCBpbiBXZWFrTWFwIGFuZCBTZXQgcG9seWZpbGxzLlxuICovXG5cblxudXRpbHMuZGVmaW5lUHJvcGVydHkgPSBPYmplY3QuZGVmaW5lUHJvcGVydHk7XG51dGlscy5XZWFrTWFwID0gdHlwZW9mIFdlYWtNYXAgIT09ICd1bmRlZmluZWQnID8gV2Vha01hcCA6IGZ1bmN0aW9uICgpIHtcbiAgLyoqIE9yaWdpbmFsbHkgYmFzZWQgb24ge0BsaW5rIGh0dHBzOi8vZ2l0aHViLmNvbS9Qb2x5bWVyL1dlYWtNYXB9ICovXG4gIHZhciBjb3VudGVyID0gRGF0ZS5ub3coKSAlIDFlOTtcblxuICB2YXIgV2Vha01hcCA9IGZ1bmN0aW9uIFdlYWtNYXAoKSB7XG4gICAgdGhpcy5uYW1lID0gXCJfX3N0XCIuY29uY2F0KE1hdGgucmFuZG9tKCkgKiAxZTkgPj4+IDApLmNvbmNhdChjb3VudGVyKyssIFwiX19cIik7XG4gIH07XG5cbiAgV2Vha01hcC5wcm90b3R5cGUgPSB7XG4gICAgc2V0OiBmdW5jdGlvbiBzZXQoa2V5LCB2YWx1ZSkge1xuICAgICAgdmFyIGVudHJ5ID0ga2V5W3RoaXMubmFtZV07XG5cbiAgICAgIGlmIChlbnRyeSAmJiBlbnRyeVswXSA9PT0ga2V5KSB7XG4gICAgICAgIGVudHJ5WzFdID0gdmFsdWU7XG4gICAgICB9IGVsc2Uge1xuICAgICAgICB1dGlscy5kZWZpbmVQcm9wZXJ0eShrZXksIHRoaXMubmFtZSwge1xuICAgICAgICAgIHZhbHVlOiBba2V5LCB2YWx1ZV0sXG4gICAgICAgICAgd3JpdGFibGU6IHRydWVcbiAgICAgICAgfSk7XG4gICAgICB9XG5cbiAgICAgIHJldHVybiB0aGlzO1xuICAgIH0sXG4gICAgZ2V0OiBmdW5jdGlvbiBnZXQoa2V5KSB7XG4gICAgICB2YXIgZW50cnkgPSBrZXlbdGhpcy5uYW1lXTtcbiAgICAgIHJldHVybiBlbnRyeSAmJiBlbnRyeVswXSA9PT0ga2V5ID8gZW50cnlbMV0gOiB1bmRlZmluZWQ7XG4gICAgfSxcbiAgICBkZWxldGU6IGZ1bmN0aW9uIF9kZWxldGUoa2V5KSB7XG4gICAgICB2YXIgZW50cnkgPSBrZXlbdGhpcy5uYW1lXTtcblxuICAgICAgaWYgKCFlbnRyeSkge1xuICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICB9XG5cbiAgICAgIHZhciBoYXNWYWx1ZSA9IGVudHJ5WzBdID09PSBrZXk7XG4gICAgICBkZWxldGUgZW50cnlbMF07XG4gICAgICBkZWxldGUgZW50cnlbMV07XG4gICAgICByZXR1cm4gaGFzVmFsdWU7XG4gICAgfSxcbiAgICBoYXM6IGZ1bmN0aW9uIGhhcyhrZXkpIHtcbiAgICAgIHZhciBlbnRyeSA9IGtleVt0aGlzLm5hbWVdO1xuXG4gICAgICBpZiAoIWVudHJ5KSB7XG4gICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIGVudHJ5WzBdID09PSBrZXk7XG4gICAgfVxuICB9O1xuICByZXR1cm4gV2Vha01hcDtcbn0oKTtcbnV0aWxzLlNldCA9IHR5cGVvZiBTZXQgIT09ICd1bmRlZmluZWQnID8gU2V0IDogZnVuY3Rpb24gKCkge1xuICB2YXIgY291bnRlciA9IERhdGUubm93KCkgJSAxZTk7XG4gIC8qKlxuICAgKiBBIHBvbHlmaWxsIHdoaWNoIGNvdmVycyBvbmx5IHRoZSBiYXNpYyB1c2FnZS5cbiAgICogT25seSBzdXBwb3J0cyBtZXRob2RzIHRoYXQgYXJlIHN1cHBvcnRlZCBpbiBJRTExLlxuICAgKiB7QGxpbmsgaHR0cHM6Ly9kb2NzLm1pY3Jvc29mdC5jb20vZW4tdXMvc2NyaXB0aW5nL2phdmFzY3JpcHQvcmVmZXJlbmNlL3NldC1vYmplY3QtamF2YXNjcmlwdH1cbiAgICogQXNzdW1lcyB0aGF0ICdrZXkncyBhcmUgYWxsIG9iamVjdHMsIG5vdCBwcmltaXRpdmVzIHN1Y2ggYXMgYSBudW1iZXIuXG4gICAqXG4gICAqIEBwYXJhbSB7QXJyYXl9IGl0ZW1zIEluaXRpYWwgaXRlbXMgaW4gdGhpcyBzZXRcbiAgICovXG5cbiAgdmFyIFNldCA9IGZ1bmN0aW9uIFNldChpdGVtcykge1xuICAgIHRoaXMubmFtZSA9IFwiX19zdFwiLmNvbmNhdChNYXRoLnJhbmRvbSgpICogMWU5ID4+PiAwKS5jb25jYXQoY291bnRlcisrLCBcIl9fXCIpO1xuICAgIHRoaXMua2V5cyA9IFtdO1xuXG4gICAgaWYgKGl0ZW1zICYmIGl0ZW1zLmxlbmd0aCkge1xuICAgICAgdmFyIGlJdGVtcyA9IGl0ZW1zLmxlbmd0aDtcblxuICAgICAgd2hpbGUgKGlJdGVtcy0tKSB7XG4gICAgICAgIHRoaXMuYWRkKGl0ZW1zW2lJdGVtc10pO1xuICAgICAgfVxuICAgIH1cbiAgfTtcblxuICBTZXQucHJvdG90eXBlID0ge1xuICAgIGFkZDogZnVuY3Rpb24gYWRkKGtleSkge1xuICAgICAgaWYgKCFpc051bWJlcihrZXlbdGhpcy5uYW1lXSkpIHtcbiAgICAgICAgdmFyIGluZGV4ID0gdGhpcy5rZXlzLnB1c2goa2V5KSAtIDE7XG4gICAgICAgIHV0aWxzLmRlZmluZVByb3BlcnR5KGtleSwgdGhpcy5uYW1lLCB7XG4gICAgICAgICAgdmFsdWU6IGluZGV4LFxuICAgICAgICAgIHdyaXRhYmxlOiB0cnVlXG4gICAgICAgIH0pO1xuICAgICAgfVxuICAgIH0sXG4gICAgZGVsZXRlOiBmdW5jdGlvbiBfZGVsZXRlKGtleSkge1xuICAgICAgaWYgKGlzTnVtYmVyKGtleVt0aGlzLm5hbWVdKSkge1xuICAgICAgICB2YXIgaW5kZXggPSBrZXlbdGhpcy5uYW1lXTtcbiAgICAgICAgZGVsZXRlIHRoaXMua2V5c1tpbmRleF07XG4gICAgICAgIGtleVt0aGlzLm5hbWVdID0gdW5kZWZpbmVkO1xuICAgICAgfVxuICAgIH0sXG4gICAgaGFzOiBmdW5jdGlvbiBoYXMoa2V5KSB7XG4gICAgICByZXR1cm4gaXNOdW1iZXIoa2V5W3RoaXMubmFtZV0pO1xuICAgIH0sXG4gICAgY2xlYXI6IGZ1bmN0aW9uIGNsZWFyKCkge1xuICAgICAgdGhpcy5rZXlzLmZvckVhY2goZnVuY3Rpb24gKGtleSkge1xuICAgICAgICBrZXlbdGhpcy5uYW1lXSA9IHVuZGVmaW5lZDtcbiAgICAgIH0pO1xuICAgICAgdGhpcy5rZXlzLmxlbmd0aCA9IDA7XG4gICAgfSxcbiAgICBmb3JFYWNoOiBmdW5jdGlvbiBmb3JFYWNoKGNiKSB7XG4gICAgICB2YXIgdGhhdCA9IHRoaXM7XG4gICAgICB0aGlzLmtleXMuZm9yRWFjaChmdW5jdGlvbiAodmFsdWUpIHtcbiAgICAgICAgY2IodmFsdWUsIHZhbHVlLCB0aGF0KTtcbiAgICAgIH0pO1xuICAgIH1cbiAgfTtcbiAgdXRpbHMuZGVmaW5lUHJvcGVydHkoU2V0LnByb3RvdHlwZSwgJ3NpemUnLCB7XG4gICAgZ2V0OiBmdW5jdGlvbiBnZXQoKSB7XG4gICAgICAvLyBTa2lwcyBob2xlcy5cbiAgICAgIHJldHVybiB0aGlzLmtleXMucmVkdWNlKGZ1bmN0aW9uIChhY2MpIHtcbiAgICAgICAgcmV0dXJuIGFjYyArIDE7XG4gICAgICB9LCAwKTtcbiAgICB9XG4gIH0pO1xuICByZXR1cm4gU2V0O1xufSgpO1xuLyoqXG4gKiBWZW5kb3Itc3BlY2lmaWMgRWxlbWVudC5wcm90b3R5cGUubWF0Y2hlc1xuICovXG5cbnV0aWxzLm1hdGNoZXNQcm9wZXJ0eU5hbWUgPSBmdW5jdGlvbiAoKSB7XG4gIHZhciBwcm9wcyA9IFsnbWF0Y2hlcycsICdtYXRjaGVzU2VsZWN0b3InLCAnbW96TWF0Y2hlc1NlbGVjdG9yJywgJ21zTWF0Y2hlc1NlbGVjdG9yJywgJ29NYXRjaGVzU2VsZWN0b3InLCAnd2Via2l0TWF0Y2hlc1NlbGVjdG9yJ107XG5cbiAgZm9yICh2YXIgaSA9IDA7IGkgPCA2OyBpKyspIHtcbiAgICBpZiAoRWxlbWVudC5wcm90b3R5cGUuaGFzT3duUHJvcGVydHkocHJvcHNbaV0pKSB7XG4gICAgICByZXR1cm4gcHJvcHNbaV07XG4gICAgfVxuICB9XG59KCk7XG4vKipcbiAqIFByb3ZpZGVzIHN0YXRzIGluZm9ybWF0aW9uXG4gKi9cblxuXG51dGlscy5TdGF0cyA9IGZ1bmN0aW9uICgpIHtcbiAgLyoqIEBtZW1iZXIge0FycmF5PG51bWJlcj59ICovXG4gIHRoaXMuYXJyYXkgPSBbXTtcbiAgLyoqIEBtZW1iZXIge251bWJlcn0gKi9cblxuICB0aGlzLmxlbmd0aCA9IDA7XG4gIHZhciB6ZXJvRGVzY3JpcHRvciA9IHtcbiAgICB2YWx1ZTogMCxcbiAgICB3cml0YWJsZTogdHJ1ZVxuICB9O1xuICAvKiogQG1lbWJlciB7bnVtYmVyfSBAcHJpdmF0ZSAqL1xuXG4gIE9iamVjdC5kZWZpbmVQcm9wZXJ0eSh0aGlzLCAnc3VtJywgemVyb0Rlc2NyaXB0b3IpO1xuICAvKiogQG1lbWJlciB7bnVtYmVyfSBAcHJpdmF0ZSAqL1xuXG4gIE9iamVjdC5kZWZpbmVQcm9wZXJ0eSh0aGlzLCAnc3F1YXJlZFN1bScsIHplcm9EZXNjcmlwdG9yKTtcbn07XG4vKipcbiAqIEBwYXJhbSB7bnVtYmVyfSBkYXRhUG9pbnQgZGF0YSBwb2ludFxuICovXG5cblxudXRpbHMuU3RhdHMucHJvdG90eXBlLnB1c2ggPSBmdW5jdGlvbiAoZGF0YVBvaW50KSB7XG4gIHRoaXMuYXJyYXkucHVzaChkYXRhUG9pbnQpO1xuICB0aGlzLmxlbmd0aCsrO1xuICB0aGlzLnN1bSArPSBkYXRhUG9pbnQ7XG4gIHRoaXMuc3F1YXJlZFN1bSArPSBkYXRhUG9pbnQgKiBkYXRhUG9pbnQ7XG4gIC8qKiBAbWVtYmVyIHtudW1iZXJ9ICovXG5cbiAgdGhpcy5tZWFuID0gdGhpcy5zdW0gLyB0aGlzLmxlbmd0aDtcbiAgLyoqIEBtZW1iZXIge251bWJlcn0gKi9cbiAgLy8gZXNsaW50LWRpc2FibGUtbmV4dC1saW5lIG5vLXJlc3RyaWN0ZWQtcHJvcGVydGllc1xuXG4gIHRoaXMuc3RkZGV2ID0gTWF0aC5zcXJ0KHRoaXMuc3F1YXJlZFN1bSAvIHRoaXMubGVuZ3RoIC0gTWF0aC5wb3codGhpcy5tZWFuLCAyKSk7XG59O1xuLyoqIFNhZmUgY29uc29sZS5lcnJvciB2ZXJzaW9uICovXG5cblxudXRpbHMubG9nRXJyb3IgPSB0eXBlb2YgY29uc29sZSAhPT0gJ3VuZGVmaW5lZCcgJiYgY29uc29sZS5lcnJvciAmJiBGdW5jdGlvbi5wcm90b3R5cGUuYmluZCAmJiBjb25zb2xlLmVycm9yLmJpbmQgPyBjb25zb2xlLmVycm9yLmJpbmQod2luZG93LmNvbnNvbGUpIDogY29uc29sZS5lcnJvcjtcbi8qKiBTYWZlIGNvbnNvbGUuaW5mbyB2ZXJzaW9uICovXG5cbnV0aWxzLmxvZ0luZm8gPSB0eXBlb2YgY29uc29sZSAhPT0gJ3VuZGVmaW5lZCcgJiYgY29uc29sZS5pbmZvICYmIEZ1bmN0aW9uLnByb3RvdHlwZS5iaW5kICYmIGNvbnNvbGUuaW5mby5iaW5kID8gY29uc29sZS5pbmZvLmJpbmQod2luZG93LmNvbnNvbGUpIDogY29uc29sZS5pbmZvO1xuXG5mdW5jdGlvbiBpc051bWJlcihvYmopIHtcbiAgcmV0dXJuIHR5cGVvZiBvYmogPT09ICdudW1iZXInO1xufVxuLyoqXG4gKiBSZXR1cm5zIHBhdGggdG8gZWxlbWVudCB3ZSB3aWxsIHVzZSBhcyBlbGVtZW50IGlkZW50aWZpZXJcbiAqIEBwYXJhbSB7RWxlbWVudH0gaW5wdXRFbFxuICogQHJldHVybnMge3N0cmluZ30gLSBwYXRoIHRvIHRoZSBlbGVtZW50XG4gKi9cblxuXG51dGlscy5nZXROb2RlU2VsZWN0b3IgPSBmdW5jdGlvbiAoaW5wdXRFbCkge1xuICBpZiAoIShpbnB1dEVsIGluc3RhbmNlb2YgRWxlbWVudCkpIHtcbiAgICB0aHJvdyBuZXcgRXJyb3IoJ0Z1bmN0aW9uIHJlY2VpdmVkIGFyZ3VtZW50IHdpdGggd3JvbmcgdHlwZScpO1xuICB9XG5cbiAgdmFyIGVsID0gaW5wdXRFbDtcbiAgdmFyIHBhdGggPSBbXTsgLy8gd2UgbmVlZCB0byBjaGVjayAnISFlbCcgZmlyc3QgYmVjYXVzZSBpdCBpcyBwb3NzaWJsZVxuICAvLyB0aGF0IHNvbWUgYW5jZXN0b3Igb2YgdGhlIGlucHV0RWwgd2FzIHJlbW92ZWQgYmVmb3JlIGl0XG5cbiAgd2hpbGUgKCEhZWwgJiYgZWwubm9kZVR5cGUgPT09IE5vZGUuRUxFTUVOVF9OT0RFKSB7XG4gICAgdmFyIHNlbGVjdG9yID0gZWwubm9kZU5hbWUudG9Mb3dlckNhc2UoKTtcblxuICAgIGlmIChlbC5pZCAmJiB0eXBlb2YgZWwuaWQgPT09ICdzdHJpbmcnKSB7XG4gICAgICBzZWxlY3RvciArPSBcIiNcIi5jb25jYXQoZWwuaWQpO1xuICAgICAgcGF0aC51bnNoaWZ0KHNlbGVjdG9yKTtcbiAgICAgIGJyZWFrO1xuICAgIH0gZWxzZSB7XG4gICAgICB2YXIgc2libGluZyA9IGVsO1xuICAgICAgdmFyIG50aCA9IDE7XG5cbiAgICAgIHdoaWxlIChzaWJsaW5nLnByZXZpb3VzU2libGluZykge1xuICAgICAgICBzaWJsaW5nID0gc2libGluZy5wcmV2aW91c1NpYmxpbmc7XG5cbiAgICAgICAgaWYgKHNpYmxpbmcubm9kZVR5cGUgPT09IE5vZGUuRUxFTUVOVF9OT0RFICYmIHNpYmxpbmcubm9kZU5hbWUudG9Mb3dlckNhc2UoKSA9PT0gc2VsZWN0b3IpIHtcbiAgICAgICAgICBudGgrKztcbiAgICAgICAgfVxuICAgICAgfVxuXG4gICAgICBpZiAobnRoICE9PSAxKSB7XG4gICAgICAgIHNlbGVjdG9yICs9IFwiOm50aC1vZi10eXBlKFwiLmNvbmNhdChudGgsIFwiKVwiKTtcbiAgICAgIH1cbiAgICB9XG5cbiAgICBwYXRoLnVuc2hpZnQoc2VsZWN0b3IpO1xuICAgIGVsID0gZWwucGFyZW50Tm9kZTtcbiAgfVxuXG4gIHJldHVybiBwYXRoLmpvaW4oJyA+ICcpO1xufTtcblxuLyoqXG4gKiBDb3B5cmlnaHQgMjAxNiBBZGd1YXJkIFNvZnR3YXJlIEx0ZFxuICpcbiAqIExpY2Vuc2VkIHVuZGVyIHRoZSBBcGFjaGUgTGljZW5zZSwgVmVyc2lvbiAyLjAgKHRoZSBcIkxpY2Vuc2VcIik7XG4gKiB5b3UgbWF5IG5vdCB1c2UgdGhpcyBmaWxlIGV4Y2VwdCBpbiBjb21wbGlhbmNlIHdpdGggdGhlIExpY2Vuc2UuXG4gKiBZb3UgbWF5IG9idGFpbiBhIGNvcHkgb2YgdGhlIExpY2Vuc2UgYXRcbiAqXG4gKiBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElDRU5TRS0yLjBcbiAqXG4gKiBVbmxlc3MgcmVxdWlyZWQgYnkgYXBwbGljYWJsZSBsYXcgb3IgYWdyZWVkIHRvIGluIHdyaXRpbmcsIHNvZnR3YXJlXG4gKiBkaXN0cmlidXRlZCB1bmRlciB0aGUgTGljZW5zZSBpcyBkaXN0cmlidXRlZCBvbiBhbiBcIkFTIElTXCIgQkFTSVMsXG4gKiBXSVRIT1VUIFdBUlJBTlRJRVMgT1IgQ09ORElUSU9OUyBPRiBBTlkgS0lORCwgZWl0aGVyIGV4cHJlc3Mgb3IgaW1wbGllZC5cbiAqIFNlZSB0aGUgTGljZW5zZSBmb3IgdGhlIHNwZWNpZmljIGxhbmd1YWdlIGdvdmVybmluZyBwZXJtaXNzaW9ucyBhbmRcbiAqIGxpbWl0YXRpb25zIHVuZGVyIHRoZSBMaWNlbnNlLlxuICovXG5cbi8qKlxuICogSGVscGVyIGNsYXNzIGNzcyB1dGlsc1xuICpcbiAqIEB0eXBlIHt7bm9ybWFsaXplfX1cbiAqL1xudmFyIGNzc1V0aWxzID0gZnVuY3Rpb24gKCkge1xuICAvKipcbiAgICogUmVnZXggdGhhdCBtYXRjaGVzIEFkR3VhcmQncyBiYWNrd2FyZCBjb21wYXRpYmxlIHN5bnRheGVzLlxuICAgKi9cbiAgdmFyIHJlQXR0ckZhbGxiYWNrID0gL1xcWy0oPzpleHR8YWJwKS0oW2Etei1fXSspPShbXCInXSkoKD86KD89KFxcXFw/KSlcXDQuKSo/KVxcMlxcXS9nO1xuICAvKipcbiAgICogQ29tcGxleCByZXBsYWNlbWVudCBmdW5jdGlvbi5cbiAgICogVW5lc2NhcGVzIHF1b3RlIGNoYXJhY3RlcnMgaW5zaWRlIG9mIGFuIGV4dGVuZGVkIHNlbGVjdG9yLlxuICAgKlxuICAgKiBAcGFyYW0gbWF0Y2ggICAgIFdob2xlIG1hdGNoZWQgc3RyaW5nXG4gICAqIEBwYXJhbSBuYW1lICAgICAgR3JvdXAgMVxuICAgKiBAcGFyYW0gcXVvdGVDaGFyIEdyb3VwIDJcbiAgICogQHBhcmFtIHZhbHVlICAgICBHcm91cCAzXG4gICAqL1xuXG4gIHZhciBldmFsdWF0ZU1hdGNoID0gZnVuY3Rpb24gZXZhbHVhdGVNYXRjaChtYXRjaCwgbmFtZSwgcXVvdGVDaGFyLCB2YWx1ZSkge1xuICAgIC8vIFVuZXNjYXBlIHF1b3Rlc1xuICAgIHZhciByZSA9IG5ldyBSZWdFeHAoXCIoW15cXFxcXFxcXF18XilcXFxcXFxcXFwiLmNvbmNhdChxdW90ZUNoYXIpLCAnZycpO1xuICAgIHZhbHVlID0gdmFsdWUucmVwbGFjZShyZSwgXCIkMVwiLmNvbmNhdChxdW90ZUNoYXIpKTtcbiAgICByZXR1cm4gXCI6XCIuY29uY2F0KG5hbWUsIFwiKFwiKS5jb25jYXQodmFsdWUsIFwiKVwiKTtcbiAgfTsgLy8gU2l6emxlJ3MgcGFyc2luZyBvZiBwc2V1ZG8gY2xhc3MgYXJndW1lbnRzIGlzIGJ1Z2d5IG9uIGNlcnRhaW4gY2lyY3Vtc3RhbmNlc1xuICAvLyBXZSBzdXBwb3J0IGZvbGxvd2luZyBmb3JtIG9mIGFyZ3VtZW50czpcbiAgLy8gMS4gZm9yIDptYXRjaGVzLWNzcywgdGhvc2Ugb2YgYSBmb3JtIHtwcm9wZXJ0eU5hbWV9OiAvLiovXG4gIC8vIDIuIGZvciA6Y29udGFpbnMsIHRob3NlIG9mIGEgZm9ybSAvLiovXG4gIC8vIFdlIHRyYW5zZm9ybSBzdWNoIGNhc2VzIGluIGEgd2F5IHRoYXQgU2l6emxlIGhhcyBubyBhbWJpZ3VpdHkgaW4gcGFyc2luZyBhcmd1bWVudHMuXG5cblxuICB2YXIgcmVNYXRjaGVzQ3NzID0gL1xcOihtYXRjaGVzLWNzcyg/Oi1hZnRlcnwtYmVmb3JlKT8pXFwoKFthLXotXFxzXSpcXDpcXHMqXFwvKD86XFxcXC58W15cXC9dKSo/XFwvXFxzKilcXCkvZztcbiAgdmFyIHJlQ29udGFpbnMgPSAvOig/Oi1hYnAtKT8oY29udGFpbnN8aGFzLXRleHQpXFwoKFxccypcXC8oPzpcXFxcLnxbXlxcL10pKj9cXC9cXHMqKVxcKS9nO1xuICB2YXIgcmVTY29wZSA9IC9cXChcXDpzY29wZSA+L2c7IC8vIE5vdGUgdGhhdCB3ZSByZXF1aXJlIGAvYCBjaGFyYWN0ZXIgaW4gcmVndWxhciBleHByZXNzaW9ucyB0byBiZSBlc2NhcGVkLlxuXG4gIC8qKlxuICAgKiBVc2VkIGZvciBwcmUtcHJvY2Vzc2luZyBwc2V1ZG8tY2xhc3NlcyB2YWx1ZXMgd2l0aCBhYm92ZSB0d28gcmVnZXhlcy5cbiAgICovXG5cbiAgdmFyIGFkZFF1b3RlcyA9IGZ1bmN0aW9uIGFkZFF1b3RlcyhfLCBjMSwgYzIpIHtcbiAgICByZXR1cm4gXCI6XCIuY29uY2F0KGMxLCBcIihcXFwiXCIpLmNvbmNhdChjMi5yZXBsYWNlKC9bXCJcXFxcXS9nLCAnXFxcXCQmJyksIFwiXFxcIilcIik7XG4gIH07XG5cbiAgdmFyIFNDT1BFX1JFUExBQ0VSID0gJyg+JztcbiAgLyoqXG4gICAqIE5vcm1hbGl6ZXMgc3BlY2lmaWVkIGNzcyB0ZXh0IGluIGEgZm9ybSB0aGF0IGNhbiBiZSBwYXJzZWQgYnkgdGhlXG4gICAqIFNpenpsZSBlbmdpbmUuXG4gICAqIE5vcm1hbGl6YXRpb24gbWVhbnNcbiAgICogIDEuIHRyYW5zZm9ybWluZyBbLWV4dC0qPVwiXCJdIGF0dHJpYnV0ZXMgdG8gcHNldWRvIGNsYXNzZXNcbiAgICogIDIuIGVuY2xvc2luZyBwb3NzaWJseSBhbWJpZ3VvdXMgYXJndW1lbnRzIG9mIGA6Y29udGFpbnNgLFxuICAgKiAgICAgYDptYXRjaGVzLWNzc2AgcHNldWRvIGNsYXNzZXMgd2l0aCBxdW90ZXMuXG4gICAqIEBwYXJhbSB7c3RyaW5nfSBjc3NUZXh0XG4gICAqIEByZXR1cm4ge3N0cmluZ31cbiAgICovXG5cbiAgdmFyIG5vcm1hbGl6ZSA9IGZ1bmN0aW9uIG5vcm1hbGl6ZShjc3NUZXh0KSB7XG4gICAgdmFyIG5vcm1hbGl6ZWRDc3NUZXh0ID0gY3NzVGV4dC5yZXBsYWNlKHJlQXR0ckZhbGxiYWNrLCBldmFsdWF0ZU1hdGNoKS5yZXBsYWNlKHJlTWF0Y2hlc0NzcywgYWRkUXVvdGVzKS5yZXBsYWNlKHJlQ29udGFpbnMsIGFkZFF1b3RlcykucmVwbGFjZShyZVNjb3BlLCBTQ09QRV9SRVBMQUNFUik7XG4gICAgcmV0dXJuIG5vcm1hbGl6ZWRDc3NUZXh0O1xuICB9O1xuXG4gIHZhciBpc1NpbXBsZVNlbGVjdG9yVmFsaWQgPSBmdW5jdGlvbiBpc1NpbXBsZVNlbGVjdG9yVmFsaWQoc2VsZWN0b3IpIHtcbiAgICB0cnkge1xuICAgICAgZG9jdW1lbnQucXVlcnlTZWxlY3RvckFsbChzZWxlY3Rvcik7XG4gICAgfSBjYXRjaCAoZSkge1xuICAgICAgcmV0dXJuIGZhbHNlO1xuICAgIH1cblxuICAgIHJldHVybiB0cnVlO1xuICB9O1xuXG4gIHJldHVybiB7XG4gICAgbm9ybWFsaXplOiBub3JtYWxpemUsXG4gICAgaXNTaW1wbGVTZWxlY3RvclZhbGlkOiBpc1NpbXBsZVNlbGVjdG9yVmFsaWRcbiAgfTtcbn0oKTtcblxuLyohXG4gKiBTaXp6bGUgQ1NTIFNlbGVjdG9yIEVuZ2luZSB2Mi4zLjQtcHJlLWFkZ3VhcmRcbiAqIGh0dHBzOi8vc2l6emxlanMuY29tL1xuICpcbiAqIENvcHlyaWdodCBKUyBGb3VuZGF0aW9uIGFuZCBvdGhlciBjb250cmlidXRvcnNcbiAqIFJlbGVhc2VkIHVuZGVyIHRoZSBNSVQgbGljZW5zZVxuICogaHR0cHM6Ly9qcy5mb3VuZGF0aW9uL1xuICpcbiAqIERhdGU6IDIwMjAtMDgtMDRcbiAqL1xuXG4vKipcbiAqIFZlcnNpb24gb2YgU2l6emxlIHBhdGNoZWQgYnkgQWRHdWFyZCBpbiBvcmRlciB0byBiZSB1c2VkIGluIHRoZSBFeHRlbmRlZENzcyBtb2R1bGUuXG4gKiBodHRwczovL2dpdGh1Yi5jb20vQWRndWFyZFRlYW0vc2l6emxlLWV4dGNzc1xuICpcbiAqIExvb2sgZm9yIFtBZEd1YXJkIFBhdGNoXSBhbmQgQURHVUFSRF9FWFRDU1MgbWFya2VycyB0byBmaW5kIG91dCB3aGF0IGV4YWN0bHkgd2FzIGNoYW5nZWQgYnkgdXMuXG4gKlxuICogR2xvYmFsIGNoYW5nZXM6XG4gKiAxLiBBZGRlZCBhZGRpdGlvbmFsIHBhcmFtZXRlcnMgdG8gdGhlIFwiU2l6emxlLnRva2VuaXplXCIgbWV0aG9kIHNvIHRoYXQgaXQgY2FuIGJlIHVzZWQgZm9yIHN0eWxlc2hlZXRzIHBhcnNpbmcgYW5kIHZhbGlkYXRpb24uXG4gKiAyLiBBZGRlZCB0b2tlbnMgcmUtc29ydGluZyBtZWNoYW5pc20gZm9yY2luZyBzbG93IHBzZXVkb3MgdG8gYmUgbWF0Y2hlZCBsYXN0ICAoc2VlIHNvcnRUb2tlbkdyb3VwcykuXG4gKiAzLiBGaXggdGhlIG5vbm5hdGl2ZVNlbGVjdG9yQ2FjaGUgY2FjaGluZyAtLSB0aGVyZSB3YXMgbm8gdmFsdWUgY29ycmVzcG9uZGluZyB0byBhIGtleS5cbiAqIDQuIEFkZGVkIFNpenpsZS5jb21waWxlIGNhbGwgdG8gdGhlIGA6aGFzYCBwc2V1ZG8gZGVmaW5pdGlvbi5cbiAqXG4gKiBDaGFuZ2VzIHRoYXQgYXJlIGFwcGxpZWQgdG8gdGhlIEFER1VBUkRfRVhUQ1NTIGJ1aWxkIG9ubHk6XG4gKiAxLiBEbyBub3QgZXhwb3NlIFNpenpsZSB0byB0aGUgZ2xvYmFsIHNjb3BlLiBJbml0aWFsaXplIGl0IGxhemlseSB2aWEgaW5pdGlhbGl6ZVNpenpsZSgpLlxuICogMi4gUmVtb3ZlZCA6Y29udGFpbnMgcHNldWRvIGRlY2xhcmF0aW9uIC0tIGl0cyBzeW50YXggaXMgY2hhbmdlZCBhbmQgZGVjbGFyZWQgb3V0c2lkZSBvZiBTaXp6bGUuXG4gKiAzLiBSZW1vdmVkIGRlY2xhcmF0aW9ucyBmb3IgdGhlIGZvbGxvd2luZyBub24tc3RhbmRhcmQgcHNldWRvIGNsYXNzZXM6XG4gKiA6cGFyZW50LCA6aGVhZGVyLCA6aW5wdXQsIDpidXR0b24sIDp0ZXh0LCA6Zmlyc3QsIDpsYXN0LCA6ZXEsXG4gKiA6ZXZlbiwgOm9kZCwgOmx0LCA6Z3QsIDpudGgsIDpyYWRpbywgOmNoZWNrYm94LCA6ZmlsZSxcbiAqIDpwYXNzd29yZCwgOmltYWdlLCA6c3VibWl0LCA6cmVzZXRcbiAqIDQuIEFkZGVkIGVzNiBtb2R1bGUgZXhwb3J0XG4gKi9cbnZhciBTaXp6bGU7XG4vKipcbiAqIEluaXRpYWxpemVzIFNpenpsZSBvYmplY3QuXG4gKiBJbiB0aGUgY2FzZSBvZiBBZEd1YXJkIEV4dGVuZGVkQ3NzIHdlIHdhbnQgdG8gYXZvaWQgaW5pdGlhbGl6aW5nIFNpenpsZSByaWdodCBhd2F5XG4gKiBhbmQgZXhwb3NpbmcgaXQgdG8gdGhlIGdsb2JhbCBzY29wZS5cbiAqL1xuXG52YXIgaW5pdGlhbGl6ZVNpenpsZSA9IGZ1bmN0aW9uIGluaXRpYWxpemVTaXp6bGUoKSB7XG4gIC8vIGpzaGludCBpZ25vcmU6bGluZVxuICBpZiAoIVNpenpsZSkge1xuICAgIC8vPDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8XG4gICAgU2l6emxlID0gZnVuY3Rpb24gKHdpbmRvdykge1xuICAgICAgdmFyIHN1cHBvcnQsXG4gICAgICAgICAgRXhwcixcbiAgICAgICAgICBnZXRUZXh0LFxuICAgICAgICAgIGlzWE1MLFxuICAgICAgICAgIHRva2VuaXplLFxuICAgICAgICAgIGNvbXBpbGUsXG4gICAgICAgICAgc2VsZWN0LFxuICAgICAgICAgIG91dGVybW9zdENvbnRleHQsXG4gICAgICAgICAgc29ydElucHV0LFxuICAgICAgICAgIGhhc0R1cGxpY2F0ZSxcbiAgICAgICAgICAvLyBMb2NhbCBkb2N1bWVudCB2YXJzXG4gICAgICBzZXREb2N1bWVudCxcbiAgICAgICAgICBkb2N1bWVudCxcbiAgICAgICAgICBkb2NFbGVtLFxuICAgICAgICAgIGRvY3VtZW50SXNIVE1MLFxuICAgICAgICAgIHJidWdneVFTQSxcbiAgICAgICAgICByYnVnZ3lNYXRjaGVzLFxuICAgICAgICAgIG1hdGNoZXMsXG4gICAgICAgICAgY29udGFpbnMsXG4gICAgICAgICAgLy8gSW5zdGFuY2Utc3BlY2lmaWMgZGF0YVxuICAgICAgZXhwYW5kbyA9IFwic2l6emxlXCIgKyAxICogbmV3IERhdGUoKSxcbiAgICAgICAgICBwcmVmZXJyZWREb2MgPSB3aW5kb3cuZG9jdW1lbnQsXG4gICAgICAgICAgZGlycnVucyA9IDAsXG4gICAgICAgICAgZG9uZSA9IDAsXG4gICAgICAgICAgY2xhc3NDYWNoZSA9IGNyZWF0ZUNhY2hlKCksXG4gICAgICAgICAgdG9rZW5DYWNoZSA9IGNyZWF0ZUNhY2hlKCksXG4gICAgICAgICAgY29tcGlsZXJDYWNoZSA9IGNyZWF0ZUNhY2hlKCksXG4gICAgICAgICAgbm9ubmF0aXZlU2VsZWN0b3JDYWNoZSA9IGNyZWF0ZUNhY2hlKCksXG4gICAgICAgICAgc29ydE9yZGVyID0gZnVuY3Rpb24gc29ydE9yZGVyKGEsIGIpIHtcbiAgICAgICAgaWYgKGEgPT09IGIpIHtcbiAgICAgICAgICBoYXNEdXBsaWNhdGUgPSB0cnVlO1xuICAgICAgICB9XG5cbiAgICAgICAgcmV0dXJuIDA7XG4gICAgICB9LFxuICAgICAgICAgIC8vIEluc3RhbmNlIG1ldGhvZHNcbiAgICAgIGhhc093biA9IHt9Lmhhc093blByb3BlcnR5LFxuICAgICAgICAgIGFyciA9IFtdLFxuICAgICAgICAgIHBvcCA9IGFyci5wb3AsXG4gICAgICAgICAgcHVzaF9uYXRpdmUgPSBhcnIucHVzaCxcbiAgICAgICAgICBwdXNoID0gYXJyLnB1c2gsXG4gICAgICAgICAgc2xpY2UgPSBhcnIuc2xpY2UsXG4gICAgICAgICAgLy8gVXNlIGEgc3RyaXBwZWQtZG93biBpbmRleE9mIGFzIGl0J3MgZmFzdGVyIHRoYW4gbmF0aXZlXG4gICAgICAvLyBodHRwczovL2pzcGVyZi5jb20vdGhvci1pbmRleG9mLXZzLWZvci81XG4gICAgICBpbmRleE9mID0gZnVuY3Rpb24gaW5kZXhPZihsaXN0LCBlbGVtKSB7XG4gICAgICAgIHZhciBpID0gMCxcbiAgICAgICAgICAgIGxlbiA9IGxpc3QubGVuZ3RoO1xuXG4gICAgICAgIGZvciAoOyBpIDwgbGVuOyBpKyspIHtcbiAgICAgICAgICBpZiAobGlzdFtpXSA9PT0gZWxlbSkge1xuICAgICAgICAgICAgcmV0dXJuIGk7XG4gICAgICAgICAgfVxuICAgICAgICB9XG5cbiAgICAgICAgcmV0dXJuIC0xO1xuICAgICAgfSxcbiAgICAgICAgICBib29sZWFucyA9IFwiY2hlY2tlZHxzZWxlY3RlZHxhc3luY3xhdXRvZm9jdXN8YXV0b3BsYXl8Y29udHJvbHN8ZGVmZXJ8ZGlzYWJsZWR8aGlkZGVufGlzbWFwfGxvb3B8bXVsdGlwbGV8b3BlbnxyZWFkb25seXxyZXF1aXJlZHxzY29wZWRcIixcbiAgICAgICAgICAvLyBSZWd1bGFyIGV4cHJlc3Npb25zXG4gICAgICAvLyBodHRwOi8vd3d3LnczLm9yZy9UUi9jc3MzLXNlbGVjdG9ycy8jd2hpdGVzcGFjZVxuICAgICAgd2hpdGVzcGFjZSA9IFwiW1xcXFx4MjBcXFxcdFxcXFxyXFxcXG5cXFxcZl1cIixcbiAgICAgICAgICAvLyBodHRwOi8vd3d3LnczLm9yZy9UUi9DU1MyMS9zeW5kYXRhLmh0bWwjdmFsdWUtZGVmLWlkZW50aWZpZXJcbiAgICAgIGlkZW50aWZpZXIgPSBcIig/OlxcXFxcXFxcLnxbXFxcXHctXXxbXlxcMC1cXFxceGEwXSkrXCIsXG4gICAgICAgICAgLy8gQXR0cmlidXRlIHNlbGVjdG9yczogaHR0cDovL3d3dy53My5vcmcvVFIvc2VsZWN0b3JzLyNhdHRyaWJ1dGUtc2VsZWN0b3JzXG4gICAgICBhdHRyaWJ1dGVzID0gXCJcXFxcW1wiICsgd2hpdGVzcGFjZSArIFwiKihcIiArIGlkZW50aWZpZXIgKyBcIikoPzpcIiArIHdoaXRlc3BhY2UgKyAvLyBPcGVyYXRvciAoY2FwdHVyZSAyKVxuICAgICAgXCIqKFsqXiR8IX5dPz0pXCIgKyB3aGl0ZXNwYWNlICsgLy8gXCJBdHRyaWJ1dGUgdmFsdWVzIG11c3QgYmUgQ1NTIGlkZW50aWZpZXJzIFtjYXB0dXJlIDVdIG9yIHN0cmluZ3MgW2NhcHR1cmUgMyBvciBjYXB0dXJlIDRdXCJcbiAgICAgIFwiKig/OicoKD86XFxcXFxcXFwufFteXFxcXFxcXFwnXSkqKSd8XFxcIigoPzpcXFxcXFxcXC58W15cXFxcXFxcXFxcXCJdKSopXFxcInwoXCIgKyBpZGVudGlmaWVyICsgXCIpKXwpXCIgKyB3aGl0ZXNwYWNlICsgXCIqXFxcXF1cIixcbiAgICAgICAgICBwc2V1ZG9zID0gXCI6KFwiICsgaWRlbnRpZmllciArIFwiKSg/OlxcXFwoKFwiICsgLy8gVG8gcmVkdWNlIHRoZSBudW1iZXIgb2Ygc2VsZWN0b3JzIG5lZWRpbmcgdG9rZW5pemUgaW4gdGhlIHByZUZpbHRlciwgcHJlZmVyIGFyZ3VtZW50czpcbiAgICAgIC8vIDEuIHF1b3RlZCAoY2FwdHVyZSAzOyBjYXB0dXJlIDQgb3IgY2FwdHVyZSA1KVxuICAgICAgXCIoJygoPzpcXFxcXFxcXC58W15cXFxcXFxcXCddKSopJ3xcXFwiKCg/OlxcXFxcXFxcLnxbXlxcXFxcXFxcXFxcIl0pKilcXFwiKXxcIiArIC8vIDIuIHNpbXBsZSAoY2FwdHVyZSA2KVxuICAgICAgXCIoKD86XFxcXFxcXFwufFteXFxcXFxcXFwoKVtcXFxcXV18XCIgKyBhdHRyaWJ1dGVzICsgXCIpKil8XCIgKyAvLyAzLiBhbnl0aGluZyBlbHNlIChjYXB0dXJlIDIpXG4gICAgICBcIi4qXCIgKyBcIilcXFxcKXwpXCIsXG4gICAgICAgICAgLy8gTGVhZGluZyBhbmQgbm9uLWVzY2FwZWQgdHJhaWxpbmcgd2hpdGVzcGFjZSwgY2FwdHVyaW5nIHNvbWUgbm9uLXdoaXRlc3BhY2UgY2hhcmFjdGVycyBwcmVjZWRpbmcgdGhlIGxhdHRlclxuICAgICAgcndoaXRlc3BhY2UgPSBuZXcgUmVnRXhwKHdoaXRlc3BhY2UgKyBcIitcIiwgXCJnXCIpLFxuICAgICAgICAgIHJ0cmltID0gbmV3IFJlZ0V4cChcIl5cIiArIHdoaXRlc3BhY2UgKyBcIit8KCg/Ol58W15cXFxcXFxcXF0pKD86XFxcXFxcXFwuKSopXCIgKyB3aGl0ZXNwYWNlICsgXCIrJFwiLCBcImdcIiksXG4gICAgICAgICAgcmNvbW1hID0gbmV3IFJlZ0V4cChcIl5cIiArIHdoaXRlc3BhY2UgKyBcIiosXCIgKyB3aGl0ZXNwYWNlICsgXCIqXCIpLFxuICAgICAgICAgIHJjb21iaW5hdG9ycyA9IG5ldyBSZWdFeHAoXCJeXCIgKyB3aGl0ZXNwYWNlICsgXCIqKFs+K35dfFwiICsgd2hpdGVzcGFjZSArIFwiKVwiICsgd2hpdGVzcGFjZSArIFwiKlwiKSxcbiAgICAgICAgICBycHNldWRvID0gbmV3IFJlZ0V4cChwc2V1ZG9zKSxcbiAgICAgICAgICByaWRlbnRpZmllciA9IG5ldyBSZWdFeHAoXCJeXCIgKyBpZGVudGlmaWVyICsgXCIkXCIpLFxuICAgICAgICAgIG1hdGNoRXhwciA9IHtcbiAgICAgICAgXCJJRFwiOiBuZXcgUmVnRXhwKFwiXiMoXCIgKyBpZGVudGlmaWVyICsgXCIpXCIpLFxuICAgICAgICBcIkNMQVNTXCI6IG5ldyBSZWdFeHAoXCJeXFxcXC4oXCIgKyBpZGVudGlmaWVyICsgXCIpXCIpLFxuICAgICAgICBcIlRBR1wiOiBuZXcgUmVnRXhwKFwiXihcIiArIGlkZW50aWZpZXIgKyBcInxbKl0pXCIpLFxuICAgICAgICBcIkFUVFJcIjogbmV3IFJlZ0V4cChcIl5cIiArIGF0dHJpYnV0ZXMpLFxuICAgICAgICBcIlBTRVVET1wiOiBuZXcgUmVnRXhwKFwiXlwiICsgcHNldWRvcyksXG4gICAgICAgIFwiQ0hJTERcIjogbmV3IFJlZ0V4cChcIl46KG9ubHl8Zmlyc3R8bGFzdHxudGh8bnRoLWxhc3QpLShjaGlsZHxvZi10eXBlKSg/OlxcXFwoXCIgKyB3aGl0ZXNwYWNlICsgXCIqKGV2ZW58b2RkfCgoWystXXwpKFxcXFxkKilufClcIiArIHdoaXRlc3BhY2UgKyBcIiooPzooWystXXwpXCIgKyB3aGl0ZXNwYWNlICsgXCIqKFxcXFxkKyl8KSlcIiArIHdoaXRlc3BhY2UgKyBcIipcXFxcKXwpXCIsIFwiaVwiKSxcbiAgICAgICAgXCJib29sXCI6IG5ldyBSZWdFeHAoXCJeKD86XCIgKyBib29sZWFucyArIFwiKSRcIiwgXCJpXCIpLFxuICAgICAgICAvLyBGb3IgdXNlIGluIGxpYnJhcmllcyBpbXBsZW1lbnRpbmcgLmlzKClcbiAgICAgICAgLy8gV2UgdXNlIHRoaXMgZm9yIFBPUyBtYXRjaGluZyBpbiBgc2VsZWN0YFxuICAgICAgICBcIm5lZWRzQ29udGV4dFwiOiBuZXcgUmVnRXhwKFwiXlwiICsgd2hpdGVzcGFjZSArIFwiKls+K35dfDooZXZlbnxvZGR8ZXF8Z3R8bHR8bnRofGZpcnN0fGxhc3QpKD86XFxcXChcIiArIHdoaXRlc3BhY2UgKyBcIiooKD86LVxcXFxkKT9cXFxcZCopXCIgKyB3aGl0ZXNwYWNlICsgXCIqXFxcXCl8KSg/PVteLV18JClcIiwgXCJpXCIpXG4gICAgICB9LFxuICAgICAgICAgIHJuYXRpdmUgPSAvXltee10rXFx7XFxzKlxcW25hdGl2ZSBcXHcvLFxuICAgICAgICAgIC8vIEVhc2lseS1wYXJzZWFibGUvcmV0cmlldmFibGUgSUQgb3IgVEFHIG9yIENMQVNTIHNlbGVjdG9yc1xuICAgICAgcnF1aWNrRXhwciA9IC9eKD86IyhbXFx3LV0rKXwoXFx3Kyl8XFwuKFtcXHctXSspKSQvLFxuICAgICAgICAgIHJzaWJsaW5nID0gL1srfl0vLFxuICAgICAgICAgIC8vIENTUyBlc2NhcGVzXG4gICAgICAvLyBodHRwOi8vd3d3LnczLm9yZy9UUi9DU1MyMS9zeW5kYXRhLmh0bWwjZXNjYXBlZC1jaGFyYWN0ZXJzXG4gICAgICBydW5lc2NhcGUgPSBuZXcgUmVnRXhwKFwiXFxcXFxcXFwoW1xcXFxkYS1mXXsxLDZ9XCIgKyB3aGl0ZXNwYWNlICsgXCI/fChcIiArIHdoaXRlc3BhY2UgKyBcIil8LilcIiwgXCJpZ1wiKSxcbiAgICAgICAgICBmdW5lc2NhcGUgPSBmdW5jdGlvbiBmdW5lc2NhcGUoXywgZXNjYXBlZCwgZXNjYXBlZFdoaXRlc3BhY2UpIHtcbiAgICAgICAgdmFyIGhpZ2ggPSBcIjB4XCIgKyBlc2NhcGVkIC0gMHgxMDAwMDsgLy8gTmFOIG1lYW5zIG5vbi1jb2RlcG9pbnRcbiAgICAgICAgLy8gU3VwcG9ydDogRmlyZWZveDwyNFxuICAgICAgICAvLyBXb3JrYXJvdW5kIGVycm9uZW91cyBudW1lcmljIGludGVycHJldGF0aW9uIG9mICtcIjB4XCJcblxuICAgICAgICByZXR1cm4gaGlnaCAhPT0gaGlnaCB8fCBlc2NhcGVkV2hpdGVzcGFjZSA/IGVzY2FwZWQgOiBoaWdoIDwgMCA/IC8vIEJNUCBjb2RlcG9pbnRcbiAgICAgICAgU3RyaW5nLmZyb21DaGFyQ29kZShoaWdoICsgMHgxMDAwMCkgOiAvLyBTdXBwbGVtZW50YWwgUGxhbmUgY29kZXBvaW50IChzdXJyb2dhdGUgcGFpcilcbiAgICAgICAgU3RyaW5nLmZyb21DaGFyQ29kZShoaWdoID4+IDEwIHwgMHhEODAwLCBoaWdoICYgMHgzRkYgfCAweERDMDApO1xuICAgICAgfSxcbiAgICAgICAgICAvLyBDU1Mgc3RyaW5nL2lkZW50aWZpZXIgc2VyaWFsaXphdGlvblxuICAgICAgLy8gaHR0cHM6Ly9kcmFmdHMuY3Nzd2cub3JnL2Nzc29tLyNjb21tb24tc2VyaWFsaXppbmctaWRpb21zXG4gICAgICByY3NzZXNjYXBlID0gLyhbXFwwLVxceDFmXFx4N2ZdfF4tP1xcZCl8Xi0kfFteXFwwLVxceDFmXFx4N2YtXFx1RkZGRlxcdy1dL2csXG4gICAgICAgICAgZmNzc2VzY2FwZSA9IGZ1bmN0aW9uIGZjc3Nlc2NhcGUoY2gsIGFzQ29kZVBvaW50KSB7XG4gICAgICAgIGlmIChhc0NvZGVQb2ludCkge1xuICAgICAgICAgIC8vIFUrMDAwMCBOVUxMIGJlY29tZXMgVStGRkZEIFJFUExBQ0VNRU5UIENIQVJBQ1RFUlxuICAgICAgICAgIGlmIChjaCA9PT0gXCJcXDBcIikge1xuICAgICAgICAgICAgcmV0dXJuIFwiXFx1RkZGRFwiO1xuICAgICAgICAgIH0gLy8gQ29udHJvbCBjaGFyYWN0ZXJzIGFuZCAoZGVwZW5kZW50IHVwb24gcG9zaXRpb24pIG51bWJlcnMgZ2V0IGVzY2FwZWQgYXMgY29kZSBwb2ludHNcblxuXG4gICAgICAgICAgcmV0dXJuIGNoLnNsaWNlKDAsIC0xKSArIFwiXFxcXFwiICsgY2guY2hhckNvZGVBdChjaC5sZW5ndGggLSAxKS50b1N0cmluZygxNikgKyBcIiBcIjtcbiAgICAgICAgfSAvLyBPdGhlciBwb3RlbnRpYWxseS1zcGVjaWFsIEFTQ0lJIGNoYXJhY3RlcnMgZ2V0IGJhY2tzbGFzaC1lc2NhcGVkXG5cblxuICAgICAgICByZXR1cm4gXCJcXFxcXCIgKyBjaDtcbiAgICAgIH0sXG4gICAgICAgICAgLy8gVXNlZCBmb3IgaWZyYW1lc1xuICAgICAgLy8gU2VlIHNldERvY3VtZW50KClcbiAgICAgIC8vIFJlbW92aW5nIHRoZSBmdW5jdGlvbiB3cmFwcGVyIGNhdXNlcyBhIFwiUGVybWlzc2lvbiBEZW5pZWRcIlxuICAgICAgLy8gZXJyb3IgaW4gSUVcbiAgICAgIHVubG9hZEhhbmRsZXIgPSBmdW5jdGlvbiB1bmxvYWRIYW5kbGVyKCkge1xuICAgICAgICBzZXREb2N1bWVudCgpO1xuICAgICAgfSxcbiAgICAgICAgICBpbkRpc2FibGVkRmllbGRzZXQgPSBhZGRDb21iaW5hdG9yKGZ1bmN0aW9uIChlbGVtKSB7XG4gICAgICAgIHJldHVybiBlbGVtLmRpc2FibGVkID09PSB0cnVlICYmIGVsZW0ubm9kZU5hbWUudG9Mb3dlckNhc2UoKSA9PT0gXCJmaWVsZHNldFwiO1xuICAgICAgfSwge1xuICAgICAgICBkaXI6IFwicGFyZW50Tm9kZVwiLFxuICAgICAgICBuZXh0OiBcImxlZ2VuZFwiXG4gICAgICB9KTsgLy8gT3B0aW1pemUgZm9yIHB1c2guYXBwbHkoIF8sIE5vZGVMaXN0IClcblxuXG4gICAgICB0cnkge1xuICAgICAgICBwdXNoLmFwcGx5KGFyciA9IHNsaWNlLmNhbGwocHJlZmVycmVkRG9jLmNoaWxkTm9kZXMpLCBwcmVmZXJyZWREb2MuY2hpbGROb2Rlcyk7IC8vIFN1cHBvcnQ6IEFuZHJvaWQ8NC4wXG4gICAgICAgIC8vIERldGVjdCBzaWxlbnRseSBmYWlsaW5nIHB1c2guYXBwbHlcblxuICAgICAgICBhcnJbcHJlZmVycmVkRG9jLmNoaWxkTm9kZXMubGVuZ3RoXS5ub2RlVHlwZTtcbiAgICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgICAgcHVzaCA9IHtcbiAgICAgICAgICBhcHBseTogYXJyLmxlbmd0aCA/IC8vIExldmVyYWdlIHNsaWNlIGlmIHBvc3NpYmxlXG4gICAgICAgICAgZnVuY3Rpb24gKHRhcmdldCwgZWxzKSB7XG4gICAgICAgICAgICBwdXNoX25hdGl2ZS5hcHBseSh0YXJnZXQsIHNsaWNlLmNhbGwoZWxzKSk7XG4gICAgICAgICAgfSA6IC8vIFN1cHBvcnQ6IElFPDlcbiAgICAgICAgICAvLyBPdGhlcndpc2UgYXBwZW5kIGRpcmVjdGx5XG4gICAgICAgICAgZnVuY3Rpb24gKHRhcmdldCwgZWxzKSB7XG4gICAgICAgICAgICB2YXIgaiA9IHRhcmdldC5sZW5ndGgsXG4gICAgICAgICAgICAgICAgaSA9IDA7IC8vIENhbid0IHRydXN0IE5vZGVMaXN0Lmxlbmd0aFxuXG4gICAgICAgICAgICB3aGlsZSAodGFyZ2V0W2orK10gPSBlbHNbaSsrXSkge31cblxuICAgICAgICAgICAgdGFyZ2V0Lmxlbmd0aCA9IGogLSAxO1xuICAgICAgICAgIH1cbiAgICAgICAgfTtcbiAgICAgIH1cblxuICAgICAgZnVuY3Rpb24gU2l6emxlKHNlbGVjdG9yLCBjb250ZXh0LCByZXN1bHRzLCBzZWVkKSB7XG4gICAgICAgIHZhciBtLFxuICAgICAgICAgICAgaSxcbiAgICAgICAgICAgIGVsZW0sXG4gICAgICAgICAgICBuaWQsXG4gICAgICAgICAgICBtYXRjaCxcbiAgICAgICAgICAgIGdyb3VwcyxcbiAgICAgICAgICAgIG5ld1NlbGVjdG9yLFxuICAgICAgICAgICAgbmV3Q29udGV4dCA9IGNvbnRleHQgJiYgY29udGV4dC5vd25lckRvY3VtZW50LFxuICAgICAgICAgICAgLy8gbm9kZVR5cGUgZGVmYXVsdHMgdG8gOSwgc2luY2UgY29udGV4dCBkZWZhdWx0cyB0byBkb2N1bWVudFxuICAgICAgICBub2RlVHlwZSA9IGNvbnRleHQgPyBjb250ZXh0Lm5vZGVUeXBlIDogOTtcbiAgICAgICAgcmVzdWx0cyA9IHJlc3VsdHMgfHwgW107IC8vIFJldHVybiBlYXJseSBmcm9tIGNhbGxzIHdpdGggaW52YWxpZCBzZWxlY3RvciBvciBjb250ZXh0XG5cbiAgICAgICAgaWYgKHR5cGVvZiBzZWxlY3RvciAhPT0gXCJzdHJpbmdcIiB8fCAhc2VsZWN0b3IgfHwgbm9kZVR5cGUgIT09IDEgJiYgbm9kZVR5cGUgIT09IDkgJiYgbm9kZVR5cGUgIT09IDExKSB7XG4gICAgICAgICAgcmV0dXJuIHJlc3VsdHM7XG4gICAgICAgIH0gLy8gVHJ5IHRvIHNob3J0Y3V0IGZpbmQgb3BlcmF0aW9ucyAoYXMgb3Bwb3NlZCB0byBmaWx0ZXJzKSBpbiBIVE1MIGRvY3VtZW50c1xuXG5cbiAgICAgICAgaWYgKCFzZWVkKSB7XG4gICAgICAgICAgaWYgKChjb250ZXh0ID8gY29udGV4dC5vd25lckRvY3VtZW50IHx8IGNvbnRleHQgOiBwcmVmZXJyZWREb2MpICE9PSBkb2N1bWVudCkge1xuICAgICAgICAgICAgc2V0RG9jdW1lbnQoY29udGV4dCk7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgY29udGV4dCA9IGNvbnRleHQgfHwgZG9jdW1lbnQ7XG5cbiAgICAgICAgICBpZiAoZG9jdW1lbnRJc0hUTUwpIHtcbiAgICAgICAgICAgIC8vIElmIHRoZSBzZWxlY3RvciBpcyBzdWZmaWNpZW50bHkgc2ltcGxlLCB0cnkgdXNpbmcgYSBcImdldCpCeSpcIiBET00gbWV0aG9kXG4gICAgICAgICAgICAvLyAoZXhjZXB0aW5nIERvY3VtZW50RnJhZ21lbnQgY29udGV4dCwgd2hlcmUgdGhlIG1ldGhvZHMgZG9uJ3QgZXhpc3QpXG4gICAgICAgICAgICBpZiAobm9kZVR5cGUgIT09IDExICYmIChtYXRjaCA9IHJxdWlja0V4cHIuZXhlYyhzZWxlY3RvcikpKSB7XG4gICAgICAgICAgICAgIC8vIElEIHNlbGVjdG9yXG4gICAgICAgICAgICAgIGlmIChtID0gbWF0Y2hbMV0pIHtcbiAgICAgICAgICAgICAgICAvLyBEb2N1bWVudCBjb250ZXh0XG4gICAgICAgICAgICAgICAgaWYgKG5vZGVUeXBlID09PSA5KSB7XG4gICAgICAgICAgICAgICAgICBpZiAoZWxlbSA9IGNvbnRleHQuZ2V0RWxlbWVudEJ5SWQobSkpIHtcbiAgICAgICAgICAgICAgICAgICAgLy8gU3VwcG9ydDogSUUsIE9wZXJhLCBXZWJraXRcbiAgICAgICAgICAgICAgICAgICAgLy8gVE9ETzogaWRlbnRpZnkgdmVyc2lvbnNcbiAgICAgICAgICAgICAgICAgICAgLy8gZ2V0RWxlbWVudEJ5SWQgY2FuIG1hdGNoIGVsZW1lbnRzIGJ5IG5hbWUgaW5zdGVhZCBvZiBJRFxuICAgICAgICAgICAgICAgICAgICBpZiAoZWxlbS5pZCA9PT0gbSkge1xuICAgICAgICAgICAgICAgICAgICAgIHJlc3VsdHMucHVzaChlbGVtKTtcbiAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gcmVzdWx0cztcbiAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgICAgICAgcmV0dXJuIHJlc3VsdHM7XG4gICAgICAgICAgICAgICAgICB9IC8vIEVsZW1lbnQgY29udGV4dFxuXG4gICAgICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgICAgIC8vIFN1cHBvcnQ6IElFLCBPcGVyYSwgV2Via2l0XG4gICAgICAgICAgICAgICAgICAvLyBUT0RPOiBpZGVudGlmeSB2ZXJzaW9uc1xuICAgICAgICAgICAgICAgICAgLy8gZ2V0RWxlbWVudEJ5SWQgY2FuIG1hdGNoIGVsZW1lbnRzIGJ5IG5hbWUgaW5zdGVhZCBvZiBJRFxuICAgICAgICAgICAgICAgICAgaWYgKG5ld0NvbnRleHQgJiYgKGVsZW0gPSBuZXdDb250ZXh0LmdldEVsZW1lbnRCeUlkKG0pKSAmJiBjb250YWlucyhjb250ZXh0LCBlbGVtKSAmJiBlbGVtLmlkID09PSBtKSB7XG4gICAgICAgICAgICAgICAgICAgIHJlc3VsdHMucHVzaChlbGVtKTtcbiAgICAgICAgICAgICAgICAgICAgcmV0dXJuIHJlc3VsdHM7XG4gICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgfSAvLyBUeXBlIHNlbGVjdG9yXG5cbiAgICAgICAgICAgICAgfSBlbHNlIGlmIChtYXRjaFsyXSkge1xuICAgICAgICAgICAgICAgIHB1c2guYXBwbHkocmVzdWx0cywgY29udGV4dC5nZXRFbGVtZW50c0J5VGFnTmFtZShzZWxlY3RvcikpO1xuICAgICAgICAgICAgICAgIHJldHVybiByZXN1bHRzOyAvLyBDbGFzcyBzZWxlY3RvclxuICAgICAgICAgICAgICB9IGVsc2UgaWYgKChtID0gbWF0Y2hbM10pICYmIHN1cHBvcnQuZ2V0RWxlbWVudHNCeUNsYXNzTmFtZSAmJiBjb250ZXh0LmdldEVsZW1lbnRzQnlDbGFzc05hbWUpIHtcbiAgICAgICAgICAgICAgICBwdXNoLmFwcGx5KHJlc3VsdHMsIGNvbnRleHQuZ2V0RWxlbWVudHNCeUNsYXNzTmFtZShtKSk7XG4gICAgICAgICAgICAgICAgcmV0dXJuIHJlc3VsdHM7XG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH0gLy8gVGFrZSBhZHZhbnRhZ2Ugb2YgcXVlcnlTZWxlY3RvckFsbFxuXG5cbiAgICAgICAgICAgIGlmIChzdXBwb3J0LnFzYSAmJiAhbm9ubmF0aXZlU2VsZWN0b3JDYWNoZVtzZWxlY3RvciArIFwiIFwiXSAmJiAoIXJidWdneVFTQSB8fCAhcmJ1Z2d5UVNBLnRlc3Qoc2VsZWN0b3IpKSkge1xuICAgICAgICAgICAgICBpZiAobm9kZVR5cGUgIT09IDEpIHtcbiAgICAgICAgICAgICAgICBuZXdDb250ZXh0ID0gY29udGV4dDtcbiAgICAgICAgICAgICAgICBuZXdTZWxlY3RvciA9IHNlbGVjdG9yOyAvLyBxU0EgbG9va3Mgb3V0c2lkZSBFbGVtZW50IGNvbnRleHQsIHdoaWNoIGlzIG5vdCB3aGF0IHdlIHdhbnRcbiAgICAgICAgICAgICAgICAvLyBUaGFua3MgdG8gQW5kcmV3IER1cG9udCBmb3IgdGhpcyB3b3JrYXJvdW5kIHRlY2huaXF1ZVxuICAgICAgICAgICAgICAgIC8vIFN1cHBvcnQ6IElFIDw9OFxuICAgICAgICAgICAgICAgIC8vIEV4Y2x1ZGUgb2JqZWN0IGVsZW1lbnRzXG4gICAgICAgICAgICAgIH0gZWxzZSBpZiAoY29udGV4dC5ub2RlTmFtZS50b0xvd2VyQ2FzZSgpICE9PSBcIm9iamVjdFwiKSB7XG4gICAgICAgICAgICAgICAgLy8gQ2FwdHVyZSB0aGUgY29udGV4dCBJRCwgc2V0dGluZyBpdCBmaXJzdCBpZiBuZWNlc3NhcnlcbiAgICAgICAgICAgICAgICBpZiAobmlkID0gY29udGV4dC5nZXRBdHRyaWJ1dGUoXCJpZFwiKSkge1xuICAgICAgICAgICAgICAgICAgbmlkID0gbmlkLnJlcGxhY2UocmNzc2VzY2FwZSwgZmNzc2VzY2FwZSk7XG4gICAgICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgICAgIGNvbnRleHQuc2V0QXR0cmlidXRlKFwiaWRcIiwgbmlkID0gZXhwYW5kbyk7XG4gICAgICAgICAgICAgICAgfSAvLyBQcmVmaXggZXZlcnkgc2VsZWN0b3IgaW4gdGhlIGxpc3RcblxuXG4gICAgICAgICAgICAgICAgZ3JvdXBzID0gdG9rZW5pemUoc2VsZWN0b3IpO1xuICAgICAgICAgICAgICAgIGkgPSBncm91cHMubGVuZ3RoO1xuXG4gICAgICAgICAgICAgICAgd2hpbGUgKGktLSkge1xuICAgICAgICAgICAgICAgICAgZ3JvdXBzW2ldID0gXCIjXCIgKyBuaWQgKyBcIiBcIiArIHRvU2VsZWN0b3IoZ3JvdXBzW2ldKTtcbiAgICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgICBuZXdTZWxlY3RvciA9IGdyb3Vwcy5qb2luKFwiLFwiKTsgLy8gRXhwYW5kIGNvbnRleHQgZm9yIHNpYmxpbmcgc2VsZWN0b3JzXG5cbiAgICAgICAgICAgICAgICBuZXdDb250ZXh0ID0gcnNpYmxpbmcudGVzdChzZWxlY3RvcikgJiYgdGVzdENvbnRleHQoY29udGV4dC5wYXJlbnROb2RlKSB8fCBjb250ZXh0O1xuICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgaWYgKG5ld1NlbGVjdG9yKSB7XG4gICAgICAgICAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgICAgICAgIHB1c2guYXBwbHkocmVzdWx0cywgbmV3Q29udGV4dC5xdWVyeVNlbGVjdG9yQWxsKG5ld1NlbGVjdG9yKSk7XG4gICAgICAgICAgICAgICAgICByZXR1cm4gcmVzdWx0cztcbiAgICAgICAgICAgICAgICB9IGNhdGNoIChxc2FFcnJvcikge1xuICAgICAgICAgICAgICAgICAgLy8gW0FkR3VhcmQgUGF0aF06IEZpeCB0aGUgY2FjaGUgdmFsdWVcbiAgICAgICAgICAgICAgICAgIG5vbm5hdGl2ZVNlbGVjdG9yQ2FjaGUoc2VsZWN0b3IsIHRydWUpO1xuICAgICAgICAgICAgICAgIH0gZmluYWxseSB7XG4gICAgICAgICAgICAgICAgICBpZiAobmlkID09PSBleHBhbmRvKSB7XG4gICAgICAgICAgICAgICAgICAgIGNvbnRleHQucmVtb3ZlQXR0cmlidXRlKFwiaWRcIik7XG4gICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfVxuICAgICAgICB9IC8vIEFsbCBvdGhlcnNcblxuXG4gICAgICAgIHJldHVybiBzZWxlY3Qoc2VsZWN0b3IucmVwbGFjZShydHJpbSwgXCIkMVwiKSwgY29udGV4dCwgcmVzdWx0cywgc2VlZCk7XG4gICAgICB9XG4gICAgICAvKipcbiAgICAgICAqIENyZWF0ZSBrZXktdmFsdWUgY2FjaGVzIG9mIGxpbWl0ZWQgc2l6ZVxuICAgICAgICogQHJldHVybnMge2Z1bmN0aW9uKHN0cmluZywgb2JqZWN0KX0gUmV0dXJucyB0aGUgT2JqZWN0IGRhdGEgYWZ0ZXIgc3RvcmluZyBpdCBvbiBpdHNlbGYgd2l0aFxuICAgICAgICpcdHByb3BlcnR5IG5hbWUgdGhlIChzcGFjZS1zdWZmaXhlZCkgc3RyaW5nIGFuZCAoaWYgdGhlIGNhY2hlIGlzIGxhcmdlciB0aGFuIEV4cHIuY2FjaGVMZW5ndGgpXG4gICAgICAgKlx0ZGVsZXRpbmcgdGhlIG9sZGVzdCBlbnRyeVxuICAgICAgICovXG5cblxuICAgICAgZnVuY3Rpb24gY3JlYXRlQ2FjaGUoKSB7XG4gICAgICAgIHZhciBrZXlzID0gW107XG5cbiAgICAgICAgZnVuY3Rpb24gY2FjaGUoa2V5LCB2YWx1ZSkge1xuICAgICAgICAgIC8vIFVzZSAoa2V5ICsgXCIgXCIpIHRvIGF2b2lkIGNvbGxpc2lvbiB3aXRoIG5hdGl2ZSBwcm90b3R5cGUgcHJvcGVydGllcyAoc2VlIElzc3VlICMxNTcpXG4gICAgICAgICAgaWYgKGtleXMucHVzaChrZXkgKyBcIiBcIikgPiBFeHByLmNhY2hlTGVuZ3RoKSB7XG4gICAgICAgICAgICAvLyBPbmx5IGtlZXAgdGhlIG1vc3QgcmVjZW50IGVudHJpZXNcbiAgICAgICAgICAgIGRlbGV0ZSBjYWNoZVtrZXlzLnNoaWZ0KCldO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIHJldHVybiBjYWNoZVtrZXkgKyBcIiBcIl0gPSB2YWx1ZTtcbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiBjYWNoZTtcbiAgICAgIH1cbiAgICAgIC8qKlxuICAgICAgICogTWFyayBhIGZ1bmN0aW9uIGZvciBzcGVjaWFsIHVzZSBieSBTaXp6bGVcbiAgICAgICAqIEBwYXJhbSB7RnVuY3Rpb259IGZuIFRoZSBmdW5jdGlvbiB0byBtYXJrXG4gICAgICAgKi9cblxuXG4gICAgICBmdW5jdGlvbiBtYXJrRnVuY3Rpb24oZm4pIHtcbiAgICAgICAgZm5bZXhwYW5kb10gPSB0cnVlO1xuICAgICAgICByZXR1cm4gZm47XG4gICAgICB9XG4gICAgICAvKipcbiAgICAgICAqIFN1cHBvcnQgdGVzdGluZyB1c2luZyBhbiBlbGVtZW50XG4gICAgICAgKiBAcGFyYW0ge0Z1bmN0aW9ufSBmbiBQYXNzZWQgdGhlIGNyZWF0ZWQgZWxlbWVudCBhbmQgcmV0dXJucyBhIGJvb2xlYW4gcmVzdWx0XG4gICAgICAgKi9cblxuXG4gICAgICBmdW5jdGlvbiBhc3NlcnQoZm4pIHtcbiAgICAgICAgdmFyIGVsID0gZG9jdW1lbnQuY3JlYXRlRWxlbWVudChcImZpZWxkc2V0XCIpO1xuXG4gICAgICAgIHRyeSB7XG4gICAgICAgICAgcmV0dXJuICEhZm4oZWwpO1xuICAgICAgICB9IGNhdGNoIChlKSB7XG4gICAgICAgICAgcmV0dXJuIGZhbHNlO1xuICAgICAgICB9IGZpbmFsbHkge1xuICAgICAgICAgIC8vIFJlbW92ZSBmcm9tIGl0cyBwYXJlbnQgYnkgZGVmYXVsdFxuICAgICAgICAgIGlmIChlbC5wYXJlbnROb2RlKSB7XG4gICAgICAgICAgICBlbC5wYXJlbnROb2RlLnJlbW92ZUNoaWxkKGVsKTtcbiAgICAgICAgICB9IC8vIHJlbGVhc2UgbWVtb3J5IGluIElFXG5cblxuICAgICAgICAgIGVsID0gbnVsbDtcbiAgICAgICAgfVxuICAgICAgfVxuICAgICAgLyoqXG4gICAgICAgKiBBZGRzIHRoZSBzYW1lIGhhbmRsZXIgZm9yIGFsbCBvZiB0aGUgc3BlY2lmaWVkIGF0dHJzXG4gICAgICAgKiBAcGFyYW0ge1N0cmluZ30gYXR0cnMgUGlwZS1zZXBhcmF0ZWQgbGlzdCBvZiBhdHRyaWJ1dGVzXG4gICAgICAgKiBAcGFyYW0ge0Z1bmN0aW9ufSBoYW5kbGVyIFRoZSBtZXRob2QgdGhhdCB3aWxsIGJlIGFwcGxpZWRcbiAgICAgICAqL1xuXG5cbiAgICAgIGZ1bmN0aW9uIGFkZEhhbmRsZShhdHRycywgaGFuZGxlcikge1xuICAgICAgICB2YXIgYXJyID0gYXR0cnMuc3BsaXQoXCJ8XCIpLFxuICAgICAgICAgICAgaSA9IGFyci5sZW5ndGg7XG5cbiAgICAgICAgd2hpbGUgKGktLSkge1xuICAgICAgICAgIEV4cHIuYXR0ckhhbmRsZVthcnJbaV1dID0gaGFuZGxlcjtcbiAgICAgICAgfVxuICAgICAgfVxuICAgICAgLyoqXG4gICAgICAgKiBDaGVja3MgZG9jdW1lbnQgb3JkZXIgb2YgdHdvIHNpYmxpbmdzXG4gICAgICAgKiBAcGFyYW0ge0VsZW1lbnR9IGFcbiAgICAgICAqIEBwYXJhbSB7RWxlbWVudH0gYlxuICAgICAgICogQHJldHVybnMge051bWJlcn0gUmV0dXJucyBsZXNzIHRoYW4gMCBpZiBhIHByZWNlZGVzIGIsIGdyZWF0ZXIgdGhhbiAwIGlmIGEgZm9sbG93cyBiXG4gICAgICAgKi9cblxuXG4gICAgICBmdW5jdGlvbiBzaWJsaW5nQ2hlY2soYSwgYikge1xuICAgICAgICB2YXIgY3VyID0gYiAmJiBhLFxuICAgICAgICAgICAgZGlmZiA9IGN1ciAmJiBhLm5vZGVUeXBlID09PSAxICYmIGIubm9kZVR5cGUgPT09IDEgJiYgYS5zb3VyY2VJbmRleCAtIGIuc291cmNlSW5kZXg7IC8vIFVzZSBJRSBzb3VyY2VJbmRleCBpZiBhdmFpbGFibGUgb24gYm90aCBub2Rlc1xuXG4gICAgICAgIGlmIChkaWZmKSB7XG4gICAgICAgICAgcmV0dXJuIGRpZmY7XG4gICAgICAgIH0gLy8gQ2hlY2sgaWYgYiBmb2xsb3dzIGFcblxuXG4gICAgICAgIGlmIChjdXIpIHtcbiAgICAgICAgICB3aGlsZSAoY3VyID0gY3VyLm5leHRTaWJsaW5nKSB7XG4gICAgICAgICAgICBpZiAoY3VyID09PSBiKSB7XG4gICAgICAgICAgICAgIHJldHVybiAtMTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9XG4gICAgICAgIH1cblxuICAgICAgICByZXR1cm4gYSA/IDEgOiAtMTtcbiAgICAgIH1cbiAgICAgIC8qKlxuICAgICAgICogUmV0dXJucyBhIGZ1bmN0aW9uIHRvIHVzZSBpbiBwc2V1ZG9zIGZvciA6ZW5hYmxlZC86ZGlzYWJsZWRcbiAgICAgICAqIEBwYXJhbSB7Qm9vbGVhbn0gZGlzYWJsZWQgdHJ1ZSBmb3IgOmRpc2FibGVkOyBmYWxzZSBmb3IgOmVuYWJsZWRcbiAgICAgICAqL1xuXG5cbiAgICAgIGZ1bmN0aW9uIGNyZWF0ZURpc2FibGVkUHNldWRvKGRpc2FibGVkKSB7XG4gICAgICAgIC8vIEtub3duIDpkaXNhYmxlZCBmYWxzZSBwb3NpdGl2ZXM6IGZpZWxkc2V0W2Rpc2FibGVkXSA+IGxlZ2VuZDpudGgtb2YtdHlwZShuKzIpIDpjYW4tZGlzYWJsZVxuICAgICAgICByZXR1cm4gZnVuY3Rpb24gKGVsZW0pIHtcbiAgICAgICAgICAvLyBPbmx5IGNlcnRhaW4gZWxlbWVudHMgY2FuIG1hdGNoIDplbmFibGVkIG9yIDpkaXNhYmxlZFxuICAgICAgICAgIC8vIGh0dHBzOi8vaHRtbC5zcGVjLndoYXR3Zy5vcmcvbXVsdGlwYWdlL3NjcmlwdGluZy5odG1sI3NlbGVjdG9yLWVuYWJsZWRcbiAgICAgICAgICAvLyBodHRwczovL2h0bWwuc3BlYy53aGF0d2cub3JnL211bHRpcGFnZS9zY3JpcHRpbmcuaHRtbCNzZWxlY3Rvci1kaXNhYmxlZFxuICAgICAgICAgIGlmIChcImZvcm1cIiBpbiBlbGVtKSB7XG4gICAgICAgICAgICAvLyBDaGVjayBmb3IgaW5oZXJpdGVkIGRpc2FibGVkbmVzcyBvbiByZWxldmFudCBub24tZGlzYWJsZWQgZWxlbWVudHM6XG4gICAgICAgICAgICAvLyAqIGxpc3RlZCBmb3JtLWFzc29jaWF0ZWQgZWxlbWVudHMgaW4gYSBkaXNhYmxlZCBmaWVsZHNldFxuICAgICAgICAgICAgLy8gICBodHRwczovL2h0bWwuc3BlYy53aGF0d2cub3JnL211bHRpcGFnZS9mb3Jtcy5odG1sI2NhdGVnb3J5LWxpc3RlZFxuICAgICAgICAgICAgLy8gICBodHRwczovL2h0bWwuc3BlYy53aGF0d2cub3JnL211bHRpcGFnZS9mb3Jtcy5odG1sI2NvbmNlcHQtZmUtZGlzYWJsZWRcbiAgICAgICAgICAgIC8vICogb3B0aW9uIGVsZW1lbnRzIGluIGEgZGlzYWJsZWQgb3B0Z3JvdXBcbiAgICAgICAgICAgIC8vICAgaHR0cHM6Ly9odG1sLnNwZWMud2hhdHdnLm9yZy9tdWx0aXBhZ2UvZm9ybXMuaHRtbCNjb25jZXB0LW9wdGlvbi1kaXNhYmxlZFxuICAgICAgICAgICAgLy8gQWxsIHN1Y2ggZWxlbWVudHMgaGF2ZSBhIFwiZm9ybVwiIHByb3BlcnR5LlxuICAgICAgICAgICAgaWYgKGVsZW0ucGFyZW50Tm9kZSAmJiBlbGVtLmRpc2FibGVkID09PSBmYWxzZSkge1xuICAgICAgICAgICAgICAvLyBPcHRpb24gZWxlbWVudHMgZGVmZXIgdG8gYSBwYXJlbnQgb3B0Z3JvdXAgaWYgcHJlc2VudFxuICAgICAgICAgICAgICBpZiAoXCJsYWJlbFwiIGluIGVsZW0pIHtcbiAgICAgICAgICAgICAgICBpZiAoXCJsYWJlbFwiIGluIGVsZW0ucGFyZW50Tm9kZSkge1xuICAgICAgICAgICAgICAgICAgcmV0dXJuIGVsZW0ucGFyZW50Tm9kZS5kaXNhYmxlZCA9PT0gZGlzYWJsZWQ7XG4gICAgICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgICAgIHJldHVybiBlbGVtLmRpc2FibGVkID09PSBkaXNhYmxlZDtcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgIH0gLy8gU3VwcG9ydDogSUUgNiAtIDExXG4gICAgICAgICAgICAgIC8vIFVzZSB0aGUgaXNEaXNhYmxlZCBzaG9ydGN1dCBwcm9wZXJ0eSB0byBjaGVjayBmb3IgZGlzYWJsZWQgZmllbGRzZXQgYW5jZXN0b3JzXG5cblxuICAgICAgICAgICAgICByZXR1cm4gZWxlbS5pc0Rpc2FibGVkID09PSBkaXNhYmxlZCB8fCAvLyBXaGVyZSB0aGVyZSBpcyBubyBpc0Rpc2FibGVkLCBjaGVjayBtYW51YWxseVxuXG4gICAgICAgICAgICAgIC8qIGpzaGludCAtVzAxOCAqL1xuICAgICAgICAgICAgICBlbGVtLmlzRGlzYWJsZWQgIT09ICFkaXNhYmxlZCAmJiBpbkRpc2FibGVkRmllbGRzZXQoZWxlbSkgPT09IGRpc2FibGVkO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICByZXR1cm4gZWxlbS5kaXNhYmxlZCA9PT0gZGlzYWJsZWQ7IC8vIFRyeSB0byB3aW5ub3cgb3V0IGVsZW1lbnRzIHRoYXQgY2FuJ3QgYmUgZGlzYWJsZWQgYmVmb3JlIHRydXN0aW5nIHRoZSBkaXNhYmxlZCBwcm9wZXJ0eS5cbiAgICAgICAgICAgIC8vIFNvbWUgdmljdGltcyBnZXQgY2F1Z2h0IGluIG91ciBuZXQgKGxhYmVsLCBsZWdlbmQsIG1lbnUsIHRyYWNrKSwgYnV0IGl0IHNob3VsZG4ndFxuICAgICAgICAgICAgLy8gZXZlbiBleGlzdCBvbiB0aGVtLCBsZXQgYWxvbmUgaGF2ZSBhIGJvb2xlYW4gdmFsdWUuXG4gICAgICAgICAgfSBlbHNlIGlmIChcImxhYmVsXCIgaW4gZWxlbSkge1xuICAgICAgICAgICAgcmV0dXJuIGVsZW0uZGlzYWJsZWQgPT09IGRpc2FibGVkO1xuICAgICAgICAgIH0gLy8gUmVtYWluaW5nIGVsZW1lbnRzIGFyZSBuZWl0aGVyIDplbmFibGVkIG5vciA6ZGlzYWJsZWRcblxuXG4gICAgICAgICAgcmV0dXJuIGZhbHNlO1xuICAgICAgICB9O1xuICAgICAgfVxuICAgICAgLyoqXG4gICAgICAgKiBDaGVja3MgYSBub2RlIGZvciB2YWxpZGl0eSBhcyBhIFNpenpsZSBjb250ZXh0XG4gICAgICAgKiBAcGFyYW0ge0VsZW1lbnR8T2JqZWN0PX0gY29udGV4dFxuICAgICAgICogQHJldHVybnMge0VsZW1lbnR8T2JqZWN0fEJvb2xlYW59IFRoZSBpbnB1dCBub2RlIGlmIGFjY2VwdGFibGUsIG90aGVyd2lzZSBhIGZhbHN5IHZhbHVlXG4gICAgICAgKi9cblxuXG4gICAgICBmdW5jdGlvbiB0ZXN0Q29udGV4dChjb250ZXh0KSB7XG4gICAgICAgIHJldHVybiBjb250ZXh0ICYmIHR5cGVvZiBjb250ZXh0LmdldEVsZW1lbnRzQnlUYWdOYW1lICE9PSBcInVuZGVmaW5lZFwiICYmIGNvbnRleHQ7XG4gICAgICB9IC8vIEV4cG9zZSBzdXBwb3J0IHZhcnMgZm9yIGNvbnZlbmllbmNlXG5cblxuICAgICAgc3VwcG9ydCA9IFNpenpsZS5zdXBwb3J0ID0ge307XG4gICAgICAvKipcbiAgICAgICAqIERldGVjdHMgWE1MIG5vZGVzXG4gICAgICAgKiBAcGFyYW0ge0VsZW1lbnR8T2JqZWN0fSBlbGVtIEFuIGVsZW1lbnQgb3IgYSBkb2N1bWVudFxuICAgICAgICogQHJldHVybnMge0Jvb2xlYW59IFRydWUgaWZmIGVsZW0gaXMgYSBub24tSFRNTCBYTUwgbm9kZVxuICAgICAgICovXG5cbiAgICAgIGlzWE1MID0gU2l6emxlLmlzWE1MID0gZnVuY3Rpb24gKGVsZW0pIHtcbiAgICAgICAgLy8gZG9jdW1lbnRFbGVtZW50IGlzIHZlcmlmaWVkIGZvciBjYXNlcyB3aGVyZSBpdCBkb2Vzbid0IHlldCBleGlzdFxuICAgICAgICAvLyAoc3VjaCBhcyBsb2FkaW5nIGlmcmFtZXMgaW4gSUUgLSAjNDgzMylcbiAgICAgICAgdmFyIGRvY3VtZW50RWxlbWVudCA9IGVsZW0gJiYgKGVsZW0ub3duZXJEb2N1bWVudCB8fCBlbGVtKS5kb2N1bWVudEVsZW1lbnQ7XG4gICAgICAgIHJldHVybiBkb2N1bWVudEVsZW1lbnQgPyBkb2N1bWVudEVsZW1lbnQubm9kZU5hbWUgIT09IFwiSFRNTFwiIDogZmFsc2U7XG4gICAgICB9O1xuICAgICAgLyoqXG4gICAgICAgKiBTZXRzIGRvY3VtZW50LXJlbGF0ZWQgdmFyaWFibGVzIG9uY2UgYmFzZWQgb24gdGhlIGN1cnJlbnQgZG9jdW1lbnRcbiAgICAgICAqIEBwYXJhbSB7RWxlbWVudHxPYmplY3R9IFtkb2NdIEFuIGVsZW1lbnQgb3IgZG9jdW1lbnQgb2JqZWN0IHRvIHVzZSB0byBzZXQgdGhlIGRvY3VtZW50XG4gICAgICAgKiBAcmV0dXJucyB7T2JqZWN0fSBSZXR1cm5zIHRoZSBjdXJyZW50IGRvY3VtZW50XG4gICAgICAgKi9cblxuXG4gICAgICBzZXREb2N1bWVudCA9IFNpenpsZS5zZXREb2N1bWVudCA9IGZ1bmN0aW9uIChub2RlKSB7XG4gICAgICAgIHZhciBoYXNDb21wYXJlLFxuICAgICAgICAgICAgc3ViV2luZG93LFxuICAgICAgICAgICAgZG9jID0gbm9kZSA/IG5vZGUub3duZXJEb2N1bWVudCB8fCBub2RlIDogcHJlZmVycmVkRG9jOyAvLyBSZXR1cm4gZWFybHkgaWYgZG9jIGlzIGludmFsaWQgb3IgYWxyZWFkeSBzZWxlY3RlZFxuXG4gICAgICAgIGlmIChkb2MgPT09IGRvY3VtZW50IHx8IGRvYy5ub2RlVHlwZSAhPT0gOSB8fCAhZG9jLmRvY3VtZW50RWxlbWVudCkge1xuICAgICAgICAgIHJldHVybiBkb2N1bWVudDtcbiAgICAgICAgfSAvLyBVcGRhdGUgZ2xvYmFsIHZhcmlhYmxlc1xuXG5cbiAgICAgICAgZG9jdW1lbnQgPSBkb2M7XG4gICAgICAgIGRvY0VsZW0gPSBkb2N1bWVudC5kb2N1bWVudEVsZW1lbnQ7XG4gICAgICAgIGRvY3VtZW50SXNIVE1MID0gIWlzWE1MKGRvY3VtZW50KTsgLy8gU3VwcG9ydDogSUUgOS0xMSwgRWRnZVxuICAgICAgICAvLyBBY2Nlc3NpbmcgaWZyYW1lIGRvY3VtZW50cyBhZnRlciB1bmxvYWQgdGhyb3dzIFwicGVybWlzc2lvbiBkZW5pZWRcIiBlcnJvcnMgKGpRdWVyeSAjMTM5MzYpXG5cbiAgICAgICAgaWYgKHByZWZlcnJlZERvYyAhPT0gZG9jdW1lbnQgJiYgKHN1YldpbmRvdyA9IGRvY3VtZW50LmRlZmF1bHRWaWV3KSAmJiBzdWJXaW5kb3cudG9wICE9PSBzdWJXaW5kb3cpIHtcbiAgICAgICAgICAvLyBTdXBwb3J0OiBJRSAxMSwgRWRnZVxuICAgICAgICAgIGlmIChzdWJXaW5kb3cuYWRkRXZlbnRMaXN0ZW5lcikge1xuICAgICAgICAgICAgc3ViV2luZG93LmFkZEV2ZW50TGlzdGVuZXIoXCJ1bmxvYWRcIiwgdW5sb2FkSGFuZGxlciwgZmFsc2UpOyAvLyBTdXBwb3J0OiBJRSA5IC0gMTAgb25seVxuICAgICAgICAgIH0gZWxzZSBpZiAoc3ViV2luZG93LmF0dGFjaEV2ZW50KSB7XG4gICAgICAgICAgICBzdWJXaW5kb3cuYXR0YWNoRXZlbnQoXCJvbnVubG9hZFwiLCB1bmxvYWRIYW5kbGVyKTtcbiAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICAgICAgLyogQXR0cmlidXRlc1xuICAgICAgICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tICovXG4gICAgICAgIC8vIFN1cHBvcnQ6IElFPDhcbiAgICAgICAgLy8gVmVyaWZ5IHRoYXQgZ2V0QXR0cmlidXRlIHJlYWxseSByZXR1cm5zIGF0dHJpYnV0ZXMgYW5kIG5vdCBwcm9wZXJ0aWVzXG4gICAgICAgIC8vIChleGNlcHRpbmcgSUU4IGJvb2xlYW5zKVxuXG5cbiAgICAgICAgc3VwcG9ydC5hdHRyaWJ1dGVzID0gYXNzZXJ0KGZ1bmN0aW9uIChlbCkge1xuICAgICAgICAgIGVsLmNsYXNzTmFtZSA9IFwiaVwiO1xuICAgICAgICAgIHJldHVybiAhZWwuZ2V0QXR0cmlidXRlKFwiY2xhc3NOYW1lXCIpO1xuICAgICAgICB9KTtcbiAgICAgICAgLyogZ2V0RWxlbWVudChzKUJ5KlxuICAgICAgICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tICovXG4gICAgICAgIC8vIENoZWNrIGlmIGdldEVsZW1lbnRzQnlUYWdOYW1lKFwiKlwiKSByZXR1cm5zIG9ubHkgZWxlbWVudHNcblxuICAgICAgICBzdXBwb3J0LmdldEVsZW1lbnRzQnlUYWdOYW1lID0gYXNzZXJ0KGZ1bmN0aW9uIChlbCkge1xuICAgICAgICAgIGVsLmFwcGVuZENoaWxkKGRvY3VtZW50LmNyZWF0ZUNvbW1lbnQoXCJcIikpO1xuICAgICAgICAgIHJldHVybiAhZWwuZ2V0RWxlbWVudHNCeVRhZ05hbWUoXCIqXCIpLmxlbmd0aDtcbiAgICAgICAgfSk7IC8vIFN1cHBvcnQ6IElFPDlcblxuICAgICAgICBzdXBwb3J0LmdldEVsZW1lbnRzQnlDbGFzc05hbWUgPSBybmF0aXZlLnRlc3QoZG9jdW1lbnQuZ2V0RWxlbWVudHNCeUNsYXNzTmFtZSk7IC8vIFN1cHBvcnQ6IElFPDEwXG4gICAgICAgIC8vIENoZWNrIGlmIGdldEVsZW1lbnRCeUlkIHJldHVybnMgZWxlbWVudHMgYnkgbmFtZVxuICAgICAgICAvLyBUaGUgYnJva2VuIGdldEVsZW1lbnRCeUlkIG1ldGhvZHMgZG9uJ3QgcGljayB1cCBwcm9ncmFtbWF0aWNhbGx5LXNldCBuYW1lcyxcbiAgICAgICAgLy8gc28gdXNlIGEgcm91bmRhYm91dCBnZXRFbGVtZW50c0J5TmFtZSB0ZXN0XG5cbiAgICAgICAgc3VwcG9ydC5nZXRCeUlkID0gYXNzZXJ0KGZ1bmN0aW9uIChlbCkge1xuICAgICAgICAgIGRvY0VsZW0uYXBwZW5kQ2hpbGQoZWwpLmlkID0gZXhwYW5kbztcbiAgICAgICAgICByZXR1cm4gIWRvY3VtZW50LmdldEVsZW1lbnRzQnlOYW1lIHx8ICFkb2N1bWVudC5nZXRFbGVtZW50c0J5TmFtZShleHBhbmRvKS5sZW5ndGg7XG4gICAgICAgIH0pOyAvLyBJRCBmaWx0ZXIgYW5kIGZpbmRcblxuICAgICAgICBpZiAoc3VwcG9ydC5nZXRCeUlkKSB7XG4gICAgICAgICAgRXhwci5maWx0ZXJbXCJJRFwiXSA9IGZ1bmN0aW9uIChpZCkge1xuICAgICAgICAgICAgdmFyIGF0dHJJZCA9IGlkLnJlcGxhY2UocnVuZXNjYXBlLCBmdW5lc2NhcGUpO1xuICAgICAgICAgICAgcmV0dXJuIGZ1bmN0aW9uIChlbGVtKSB7XG4gICAgICAgICAgICAgIHJldHVybiBlbGVtLmdldEF0dHJpYnV0ZShcImlkXCIpID09PSBhdHRySWQ7XG4gICAgICAgICAgICB9O1xuICAgICAgICAgIH07XG5cbiAgICAgICAgICBFeHByLmZpbmRbXCJJRFwiXSA9IGZ1bmN0aW9uIChpZCwgY29udGV4dCkge1xuICAgICAgICAgICAgaWYgKHR5cGVvZiBjb250ZXh0LmdldEVsZW1lbnRCeUlkICE9PSBcInVuZGVmaW5lZFwiICYmIGRvY3VtZW50SXNIVE1MKSB7XG4gICAgICAgICAgICAgIHZhciBlbGVtID0gY29udGV4dC5nZXRFbGVtZW50QnlJZChpZCk7XG4gICAgICAgICAgICAgIHJldHVybiBlbGVtID8gW2VsZW1dIDogW107XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfTtcbiAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICBFeHByLmZpbHRlcltcIklEXCJdID0gZnVuY3Rpb24gKGlkKSB7XG4gICAgICAgICAgICB2YXIgYXR0cklkID0gaWQucmVwbGFjZShydW5lc2NhcGUsIGZ1bmVzY2FwZSk7XG4gICAgICAgICAgICByZXR1cm4gZnVuY3Rpb24gKGVsZW0pIHtcbiAgICAgICAgICAgICAgdmFyIG5vZGUgPSB0eXBlb2YgZWxlbS5nZXRBdHRyaWJ1dGVOb2RlICE9PSBcInVuZGVmaW5lZFwiICYmIGVsZW0uZ2V0QXR0cmlidXRlTm9kZShcImlkXCIpO1xuICAgICAgICAgICAgICByZXR1cm4gbm9kZSAmJiBub2RlLnZhbHVlID09PSBhdHRySWQ7XG4gICAgICAgICAgICB9O1xuICAgICAgICAgIH07IC8vIFN1cHBvcnQ6IElFIDYgLSA3IG9ubHlcbiAgICAgICAgICAvLyBnZXRFbGVtZW50QnlJZCBpcyBub3QgcmVsaWFibGUgYXMgYSBmaW5kIHNob3J0Y3V0XG5cblxuICAgICAgICAgIEV4cHIuZmluZFtcIklEXCJdID0gZnVuY3Rpb24gKGlkLCBjb250ZXh0KSB7XG4gICAgICAgICAgICBpZiAodHlwZW9mIGNvbnRleHQuZ2V0RWxlbWVudEJ5SWQgIT09IFwidW5kZWZpbmVkXCIgJiYgZG9jdW1lbnRJc0hUTUwpIHtcbiAgICAgICAgICAgICAgdmFyIG5vZGUsXG4gICAgICAgICAgICAgICAgICBpLFxuICAgICAgICAgICAgICAgICAgZWxlbXMsXG4gICAgICAgICAgICAgICAgICBlbGVtID0gY29udGV4dC5nZXRFbGVtZW50QnlJZChpZCk7XG5cbiAgICAgICAgICAgICAgaWYgKGVsZW0pIHtcbiAgICAgICAgICAgICAgICAvLyBWZXJpZnkgdGhlIGlkIGF0dHJpYnV0ZVxuICAgICAgICAgICAgICAgIG5vZGUgPSBlbGVtLmdldEF0dHJpYnV0ZU5vZGUoXCJpZFwiKTtcblxuICAgICAgICAgICAgICAgIGlmIChub2RlICYmIG5vZGUudmFsdWUgPT09IGlkKSB7XG4gICAgICAgICAgICAgICAgICByZXR1cm4gW2VsZW1dO1xuICAgICAgICAgICAgICAgIH0gLy8gRmFsbCBiYWNrIG9uIGdldEVsZW1lbnRzQnlOYW1lXG5cblxuICAgICAgICAgICAgICAgIGVsZW1zID0gY29udGV4dC5nZXRFbGVtZW50c0J5TmFtZShpZCk7XG4gICAgICAgICAgICAgICAgaSA9IDA7XG5cbiAgICAgICAgICAgICAgICB3aGlsZSAoZWxlbSA9IGVsZW1zW2krK10pIHtcbiAgICAgICAgICAgICAgICAgIG5vZGUgPSBlbGVtLmdldEF0dHJpYnV0ZU5vZGUoXCJpZFwiKTtcblxuICAgICAgICAgICAgICAgICAgaWYgKG5vZGUgJiYgbm9kZS52YWx1ZSA9PT0gaWQpIHtcbiAgICAgICAgICAgICAgICAgICAgcmV0dXJuIFtlbGVtXTtcbiAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICByZXR1cm4gW107XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfTtcbiAgICAgICAgfSAvLyBUYWdcblxuXG4gICAgICAgIEV4cHIuZmluZFtcIlRBR1wiXSA9IHN1cHBvcnQuZ2V0RWxlbWVudHNCeVRhZ05hbWUgPyBmdW5jdGlvbiAodGFnLCBjb250ZXh0KSB7XG4gICAgICAgICAgaWYgKHR5cGVvZiBjb250ZXh0LmdldEVsZW1lbnRzQnlUYWdOYW1lICE9PSBcInVuZGVmaW5lZFwiKSB7XG4gICAgICAgICAgICByZXR1cm4gY29udGV4dC5nZXRFbGVtZW50c0J5VGFnTmFtZSh0YWcpOyAvLyBEb2N1bWVudEZyYWdtZW50IG5vZGVzIGRvbid0IGhhdmUgZ0VCVE5cbiAgICAgICAgICB9IGVsc2UgaWYgKHN1cHBvcnQucXNhKSB7XG4gICAgICAgICAgICByZXR1cm4gY29udGV4dC5xdWVyeVNlbGVjdG9yQWxsKHRhZyk7XG4gICAgICAgICAgfVxuICAgICAgICB9IDogZnVuY3Rpb24gKHRhZywgY29udGV4dCkge1xuICAgICAgICAgIHZhciBlbGVtLFxuICAgICAgICAgICAgICB0bXAgPSBbXSxcbiAgICAgICAgICAgICAgaSA9IDAsXG4gICAgICAgICAgICAgIC8vIEJ5IGhhcHB5IGNvaW5jaWRlbmNlLCBhIChicm9rZW4pIGdFQlROIGFwcGVhcnMgb24gRG9jdW1lbnRGcmFnbWVudCBub2RlcyB0b29cbiAgICAgICAgICByZXN1bHRzID0gY29udGV4dC5nZXRFbGVtZW50c0J5VGFnTmFtZSh0YWcpOyAvLyBGaWx0ZXIgb3V0IHBvc3NpYmxlIGNvbW1lbnRzXG5cbiAgICAgICAgICBpZiAodGFnID09PSBcIipcIikge1xuICAgICAgICAgICAgd2hpbGUgKGVsZW0gPSByZXN1bHRzW2krK10pIHtcbiAgICAgICAgICAgICAgaWYgKGVsZW0ubm9kZVR5cGUgPT09IDEpIHtcbiAgICAgICAgICAgICAgICB0bXAucHVzaChlbGVtKTtcbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICByZXR1cm4gdG1wO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIHJldHVybiByZXN1bHRzO1xuICAgICAgICB9OyAvLyBDbGFzc1xuXG4gICAgICAgIEV4cHIuZmluZFtcIkNMQVNTXCJdID0gc3VwcG9ydC5nZXRFbGVtZW50c0J5Q2xhc3NOYW1lICYmIGZ1bmN0aW9uIChjbGFzc05hbWUsIGNvbnRleHQpIHtcbiAgICAgICAgICBpZiAodHlwZW9mIGNvbnRleHQuZ2V0RWxlbWVudHNCeUNsYXNzTmFtZSAhPT0gXCJ1bmRlZmluZWRcIiAmJiBkb2N1bWVudElzSFRNTCkge1xuICAgICAgICAgICAgcmV0dXJuIGNvbnRleHQuZ2V0RWxlbWVudHNCeUNsYXNzTmFtZShjbGFzc05hbWUpO1xuICAgICAgICAgIH1cbiAgICAgICAgfTtcbiAgICAgICAgLyogUVNBL21hdGNoZXNTZWxlY3RvclxuICAgICAgICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tICovXG4gICAgICAgIC8vIFFTQSBhbmQgbWF0Y2hlc1NlbGVjdG9yIHN1cHBvcnRcbiAgICAgICAgLy8gbWF0Y2hlc1NlbGVjdG9yKDphY3RpdmUpIHJlcG9ydHMgZmFsc2Ugd2hlbiB0cnVlIChJRTkvT3BlcmEgMTEuNSlcblxuXG4gICAgICAgIHJidWdneU1hdGNoZXMgPSBbXTsgLy8gcVNhKDpmb2N1cykgcmVwb3J0cyBmYWxzZSB3aGVuIHRydWUgKENocm9tZSAyMSlcbiAgICAgICAgLy8gV2UgYWxsb3cgdGhpcyBiZWNhdXNlIG9mIGEgYnVnIGluIElFOC85IHRoYXQgdGhyb3dzIGFuIGVycm9yXG4gICAgICAgIC8vIHdoZW5ldmVyIGBkb2N1bWVudC5hY3RpdmVFbGVtZW50YCBpcyBhY2Nlc3NlZCBvbiBhbiBpZnJhbWVcbiAgICAgICAgLy8gU28sIHdlIGFsbG93IDpmb2N1cyB0byBwYXNzIHRocm91Z2ggUVNBIGFsbCB0aGUgdGltZSB0byBhdm9pZCB0aGUgSUUgZXJyb3JcbiAgICAgICAgLy8gU2VlIGh0dHBzOi8vYnVncy5qcXVlcnkuY29tL3RpY2tldC8xMzM3OFxuXG4gICAgICAgIHJidWdneVFTQSA9IFtdO1xuXG4gICAgICAgIGlmIChzdXBwb3J0LnFzYSA9IHJuYXRpdmUudGVzdChkb2N1bWVudC5xdWVyeVNlbGVjdG9yQWxsKSkge1xuICAgICAgICAgIC8vIEJ1aWxkIFFTQSByZWdleFxuICAgICAgICAgIC8vIFJlZ2V4IHN0cmF0ZWd5IGFkb3B0ZWQgZnJvbSBEaWVnbyBQZXJpbmlcbiAgICAgICAgICBhc3NlcnQoZnVuY3Rpb24gKGVsKSB7XG4gICAgICAgICAgICAvLyBTZWxlY3QgaXMgc2V0IHRvIGVtcHR5IHN0cmluZyBvbiBwdXJwb3NlXG4gICAgICAgICAgICAvLyBUaGlzIGlzIHRvIHRlc3QgSUUncyB0cmVhdG1lbnQgb2Ygbm90IGV4cGxpY2l0bHlcbiAgICAgICAgICAgIC8vIHNldHRpbmcgYSBib29sZWFuIGNvbnRlbnQgYXR0cmlidXRlLFxuICAgICAgICAgICAgLy8gc2luY2UgaXRzIHByZXNlbmNlIHNob3VsZCBiZSBlbm91Z2hcbiAgICAgICAgICAgIC8vIGh0dHBzOi8vYnVncy5qcXVlcnkuY29tL3RpY2tldC8xMjM1OVxuICAgICAgICAgICAgZG9jRWxlbS5hcHBlbmRDaGlsZChlbCkuaW5uZXJIVE1MID0gQUdQb2xpY3kuY3JlYXRlSFRNTChcIjxhIGlkPSdcIiArIGV4cGFuZG8gKyBcIic+PC9hPlwiICsgXCI8c2VsZWN0IGlkPSdcIiArIGV4cGFuZG8gKyBcIi1cXHJcXFxcJyBtc2FsbG93Y2FwdHVyZT0nJz5cIiArIFwiPG9wdGlvbiBzZWxlY3RlZD0nJz48L29wdGlvbj48L3NlbGVjdD5cIik7IC8vIFN1cHBvcnQ6IElFOCwgT3BlcmEgMTEtMTIuMTZcbiAgICAgICAgICAgIC8vIE5vdGhpbmcgc2hvdWxkIGJlIHNlbGVjdGVkIHdoZW4gZW1wdHkgc3RyaW5ncyBmb2xsb3cgXj0gb3IgJD0gb3IgKj1cbiAgICAgICAgICAgIC8vIFRoZSB0ZXN0IGF0dHJpYnV0ZSBtdXN0IGJlIHVua25vd24gaW4gT3BlcmEgYnV0IFwic2FmZVwiIGZvciBXaW5SVFxuICAgICAgICAgICAgLy8gaHR0cHM6Ly9tc2RuLm1pY3Jvc29mdC5jb20vZW4tdXMvbGlicmFyeS9pZS9oaDQ2NTM4OC5hc3B4I2F0dHJpYnV0ZV9zZWN0aW9uXG5cbiAgICAgICAgICAgIGlmIChlbC5xdWVyeVNlbGVjdG9yQWxsKFwiW21zYWxsb3djYXB0dXJlXj0nJ11cIikubGVuZ3RoKSB7XG4gICAgICAgICAgICAgIHJidWdneVFTQS5wdXNoKFwiWypeJF09XCIgKyB3aGl0ZXNwYWNlICsgXCIqKD86Jyd8XFxcIlxcXCIpXCIpO1xuICAgICAgICAgICAgfSAvLyBTdXBwb3J0OiBJRThcbiAgICAgICAgICAgIC8vIEJvb2xlYW4gYXR0cmlidXRlcyBhbmQgXCJ2YWx1ZVwiIGFyZSBub3QgdHJlYXRlZCBjb3JyZWN0bHlcblxuXG4gICAgICAgICAgICBpZiAoIWVsLnF1ZXJ5U2VsZWN0b3JBbGwoXCJbc2VsZWN0ZWRdXCIpLmxlbmd0aCkge1xuICAgICAgICAgICAgICByYnVnZ3lRU0EucHVzaChcIlxcXFxbXCIgKyB3aGl0ZXNwYWNlICsgXCIqKD86dmFsdWV8XCIgKyBib29sZWFucyArIFwiKVwiKTtcbiAgICAgICAgICAgIH0gLy8gU3VwcG9ydDogQ2hyb21lPDI5LCBBbmRyb2lkPDQuNCwgU2FmYXJpPDcuMCssIGlPUzw3LjArLCBQaGFudG9tSlM8MS45LjgrXG5cblxuICAgICAgICAgICAgaWYgKCFlbC5xdWVyeVNlbGVjdG9yQWxsKFwiW2lkfj1cIiArIGV4cGFuZG8gKyBcIi1dXCIpLmxlbmd0aCkge1xuICAgICAgICAgICAgICByYnVnZ3lRU0EucHVzaChcIn49XCIpO1xuICAgICAgICAgICAgfSAvLyBXZWJraXQvT3BlcmEgLSA6Y2hlY2tlZCBzaG91bGQgcmV0dXJuIHNlbGVjdGVkIG9wdGlvbiBlbGVtZW50c1xuICAgICAgICAgICAgLy8gaHR0cDovL3d3dy53My5vcmcvVFIvMjAxMS9SRUMtY3NzMy1zZWxlY3RvcnMtMjAxMTA5MjkvI2NoZWNrZWRcbiAgICAgICAgICAgIC8vIElFOCB0aHJvd3MgZXJyb3IgaGVyZSBhbmQgd2lsbCBub3Qgc2VlIGxhdGVyIHRlc3RzXG5cblxuICAgICAgICAgICAgaWYgKCFlbC5xdWVyeVNlbGVjdG9yQWxsKFwiOmNoZWNrZWRcIikubGVuZ3RoKSB7XG4gICAgICAgICAgICAgIHJidWdneVFTQS5wdXNoKFwiOmNoZWNrZWRcIik7XG4gICAgICAgICAgICB9IC8vIFN1cHBvcnQ6IFNhZmFyaSA4KywgaU9TIDgrXG4gICAgICAgICAgICAvLyBodHRwczovL2J1Z3Mud2Via2l0Lm9yZy9zaG93X2J1Zy5jZ2k/aWQ9MTM2ODUxXG4gICAgICAgICAgICAvLyBJbi1wYWdlIGBzZWxlY3RvciNpZCBzaWJsaW5nLWNvbWJpbmF0b3Igc2VsZWN0b3JgIGZhaWxzXG5cblxuICAgICAgICAgICAgaWYgKCFlbC5xdWVyeVNlbGVjdG9yQWxsKFwiYSNcIiArIGV4cGFuZG8gKyBcIisqXCIpLmxlbmd0aCkge1xuICAgICAgICAgICAgICByYnVnZ3lRU0EucHVzaChcIi4jLitbK35dXCIpO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH0pO1xuICAgICAgICAgIGFzc2VydChmdW5jdGlvbiAoZWwpIHtcbiAgICAgICAgICAgIGVsLmlubmVySFRNTCA9IEFHUG9saWN5LmNyZWF0ZUhUTUwoXCI8YSBocmVmPScnIGRpc2FibGVkPSdkaXNhYmxlZCc+PC9hPlwiICsgXCI8c2VsZWN0IGRpc2FibGVkPSdkaXNhYmxlZCc+PG9wdGlvbi8+PC9zZWxlY3Q+XCIpOyAvLyBTdXBwb3J0OiBXaW5kb3dzIDggTmF0aXZlIEFwcHNcbiAgICAgICAgICAgIC8vIFRoZSB0eXBlIGFuZCBuYW1lIGF0dHJpYnV0ZXMgYXJlIHJlc3RyaWN0ZWQgZHVyaW5nIC5pbm5lckhUTUwgYXNzaWdubWVudFxuXG4gICAgICAgICAgICB2YXIgaW5wdXQgPSBkb2N1bWVudC5jcmVhdGVFbGVtZW50KFwiaW5wdXRcIik7XG4gICAgICAgICAgICBpbnB1dC5zZXRBdHRyaWJ1dGUoXCJ0eXBlXCIsIFwiaGlkZGVuXCIpO1xuICAgICAgICAgICAgZWwuYXBwZW5kQ2hpbGQoaW5wdXQpLnNldEF0dHJpYnV0ZShcIm5hbWVcIiwgXCJEXCIpOyAvLyBTdXBwb3J0OiBJRThcbiAgICAgICAgICAgIC8vIEVuZm9yY2UgY2FzZS1zZW5zaXRpdml0eSBvZiBuYW1lIGF0dHJpYnV0ZVxuXG4gICAgICAgICAgICBpZiAoZWwucXVlcnlTZWxlY3RvckFsbChcIltuYW1lPWRdXCIpLmxlbmd0aCkge1xuICAgICAgICAgICAgICByYnVnZ3lRU0EucHVzaChcIm5hbWVcIiArIHdoaXRlc3BhY2UgKyBcIipbKl4kfCF+XT89XCIpO1xuICAgICAgICAgICAgfSAvLyBGRiAzLjUgLSA6ZW5hYmxlZC86ZGlzYWJsZWQgYW5kIGhpZGRlbiBlbGVtZW50cyAoaGlkZGVuIGVsZW1lbnRzIGFyZSBzdGlsbCBlbmFibGVkKVxuICAgICAgICAgICAgLy8gSUU4IHRocm93cyBlcnJvciBoZXJlIGFuZCB3aWxsIG5vdCBzZWUgbGF0ZXIgdGVzdHNcblxuXG4gICAgICAgICAgICBpZiAoZWwucXVlcnlTZWxlY3RvckFsbChcIjplbmFibGVkXCIpLmxlbmd0aCAhPT0gMikge1xuICAgICAgICAgICAgICByYnVnZ3lRU0EucHVzaChcIjplbmFibGVkXCIsIFwiOmRpc2FibGVkXCIpO1xuICAgICAgICAgICAgfSAvLyBTdXBwb3J0OiBJRTktMTErXG4gICAgICAgICAgICAvLyBJRSdzIDpkaXNhYmxlZCBzZWxlY3RvciBkb2VzIG5vdCBwaWNrIHVwIHRoZSBjaGlsZHJlbiBvZiBkaXNhYmxlZCBmaWVsZHNldHNcblxuXG4gICAgICAgICAgICBkb2NFbGVtLmFwcGVuZENoaWxkKGVsKS5kaXNhYmxlZCA9IHRydWU7XG5cbiAgICAgICAgICAgIGlmIChlbC5xdWVyeVNlbGVjdG9yQWxsKFwiOmRpc2FibGVkXCIpLmxlbmd0aCAhPT0gMikge1xuICAgICAgICAgICAgICByYnVnZ3lRU0EucHVzaChcIjplbmFibGVkXCIsIFwiOmRpc2FibGVkXCIpO1xuICAgICAgICAgICAgfSAvLyBPcGVyYSAxMC0xMSBkb2VzIG5vdCB0aHJvdyBvbiBwb3N0LWNvbW1hIGludmFsaWQgcHNldWRvc1xuXG5cbiAgICAgICAgICAgIGVsLnF1ZXJ5U2VsZWN0b3JBbGwoXCIqLDp4XCIpO1xuICAgICAgICAgICAgcmJ1Z2d5UVNBLnB1c2goXCIsLio6XCIpO1xuICAgICAgICAgIH0pO1xuICAgICAgICB9XG5cbiAgICAgICAgaWYgKHN1cHBvcnQubWF0Y2hlc1NlbGVjdG9yID0gcm5hdGl2ZS50ZXN0KG1hdGNoZXMgPSBkb2NFbGVtLm1hdGNoZXMgfHwgZG9jRWxlbS53ZWJraXRNYXRjaGVzU2VsZWN0b3IgfHwgZG9jRWxlbS5tb3pNYXRjaGVzU2VsZWN0b3IgfHwgZG9jRWxlbS5vTWF0Y2hlc1NlbGVjdG9yIHx8IGRvY0VsZW0ubXNNYXRjaGVzU2VsZWN0b3IpKSB7XG4gICAgICAgICAgYXNzZXJ0KGZ1bmN0aW9uIChlbCkge1xuICAgICAgICAgICAgLy8gQ2hlY2sgdG8gc2VlIGlmIGl0J3MgcG9zc2libGUgdG8gZG8gbWF0Y2hlc1NlbGVjdG9yXG4gICAgICAgICAgICAvLyBvbiBhIGRpc2Nvbm5lY3RlZCBub2RlIChJRSA5KVxuICAgICAgICAgICAgc3VwcG9ydC5kaXNjb25uZWN0ZWRNYXRjaCA9IG1hdGNoZXMuY2FsbChlbCwgXCIqXCIpOyAvLyBUaGlzIHNob3VsZCBmYWlsIHdpdGggYW4gZXhjZXB0aW9uXG4gICAgICAgICAgICAvLyBHZWNrbyBkb2VzIG5vdCBlcnJvciwgcmV0dXJucyBmYWxzZSBpbnN0ZWFkXG5cbiAgICAgICAgICAgIG1hdGNoZXMuY2FsbChlbCwgXCJbcyE9JyddOnhcIik7XG4gICAgICAgICAgICByYnVnZ3lNYXRjaGVzLnB1c2goXCIhPVwiLCBwc2V1ZG9zKTtcbiAgICAgICAgICB9KTtcbiAgICAgICAgfVxuXG4gICAgICAgIHJidWdneVFTQSA9IHJidWdneVFTQS5sZW5ndGggJiYgbmV3IFJlZ0V4cChyYnVnZ3lRU0Euam9pbihcInxcIikpO1xuICAgICAgICByYnVnZ3lNYXRjaGVzID0gcmJ1Z2d5TWF0Y2hlcy5sZW5ndGggJiYgbmV3IFJlZ0V4cChyYnVnZ3lNYXRjaGVzLmpvaW4oXCJ8XCIpKTtcbiAgICAgICAgLyogQ29udGFpbnNcbiAgICAgICAgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSAqL1xuXG4gICAgICAgIGhhc0NvbXBhcmUgPSBybmF0aXZlLnRlc3QoZG9jRWxlbS5jb21wYXJlRG9jdW1lbnRQb3NpdGlvbik7IC8vIEVsZW1lbnQgY29udGFpbnMgYW5vdGhlclxuICAgICAgICAvLyBQdXJwb3NlZnVsbHkgc2VsZi1leGNsdXNpdmVcbiAgICAgICAgLy8gQXMgaW4sIGFuIGVsZW1lbnQgZG9lcyBub3QgY29udGFpbiBpdHNlbGZcblxuICAgICAgICBjb250YWlucyA9IGhhc0NvbXBhcmUgfHwgcm5hdGl2ZS50ZXN0KGRvY0VsZW0uY29udGFpbnMpID8gZnVuY3Rpb24gKGEsIGIpIHtcbiAgICAgICAgICB2YXIgYWRvd24gPSBhLm5vZGVUeXBlID09PSA5ID8gYS5kb2N1bWVudEVsZW1lbnQgOiBhLFxuICAgICAgICAgICAgICBidXAgPSBiICYmIGIucGFyZW50Tm9kZTtcbiAgICAgICAgICByZXR1cm4gYSA9PT0gYnVwIHx8ICEhKGJ1cCAmJiBidXAubm9kZVR5cGUgPT09IDEgJiYgKGFkb3duLmNvbnRhaW5zID8gYWRvd24uY29udGFpbnMoYnVwKSA6IGEuY29tcGFyZURvY3VtZW50UG9zaXRpb24gJiYgYS5jb21wYXJlRG9jdW1lbnRQb3NpdGlvbihidXApICYgMTYpKTtcbiAgICAgICAgfSA6IGZ1bmN0aW9uIChhLCBiKSB7XG4gICAgICAgICAgaWYgKGIpIHtcbiAgICAgICAgICAgIHdoaWxlIChiID0gYi5wYXJlbnROb2RlKSB7XG4gICAgICAgICAgICAgIGlmIChiID09PSBhKSB7XG4gICAgICAgICAgICAgICAgcmV0dXJuIHRydWU7XG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9XG5cbiAgICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICAgIH07XG4gICAgICAgIC8qIFNvcnRpbmdcbiAgICAgICAgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSAqL1xuICAgICAgICAvLyBEb2N1bWVudCBvcmRlciBzb3J0aW5nXG5cbiAgICAgICAgc29ydE9yZGVyID0gaGFzQ29tcGFyZSA/IGZ1bmN0aW9uIChhLCBiKSB7XG4gICAgICAgICAgLy8gRmxhZyBmb3IgZHVwbGljYXRlIHJlbW92YWxcbiAgICAgICAgICBpZiAoYSA9PT0gYikge1xuICAgICAgICAgICAgaGFzRHVwbGljYXRlID0gdHJ1ZTtcbiAgICAgICAgICAgIHJldHVybiAwO1xuICAgICAgICAgIH0gLy8gU29ydCBvbiBtZXRob2QgZXhpc3RlbmNlIGlmIG9ubHkgb25lIGlucHV0IGhhcyBjb21wYXJlRG9jdW1lbnRQb3NpdGlvblxuXG5cbiAgICAgICAgICB2YXIgY29tcGFyZSA9ICFhLmNvbXBhcmVEb2N1bWVudFBvc2l0aW9uIC0gIWIuY29tcGFyZURvY3VtZW50UG9zaXRpb247XG5cbiAgICAgICAgICBpZiAoY29tcGFyZSkge1xuICAgICAgICAgICAgcmV0dXJuIGNvbXBhcmU7XG4gICAgICAgICAgfSAvLyBDYWxjdWxhdGUgcG9zaXRpb24gaWYgYm90aCBpbnB1dHMgYmVsb25nIHRvIHRoZSBzYW1lIGRvY3VtZW50XG5cblxuICAgICAgICAgIGNvbXBhcmUgPSAoYS5vd25lckRvY3VtZW50IHx8IGEpID09PSAoYi5vd25lckRvY3VtZW50IHx8IGIpID8gYS5jb21wYXJlRG9jdW1lbnRQb3NpdGlvbihiKSA6IC8vIE90aGVyd2lzZSB3ZSBrbm93IHRoZXkgYXJlIGRpc2Nvbm5lY3RlZFxuICAgICAgICAgIDE7IC8vIERpc2Nvbm5lY3RlZCBub2Rlc1xuXG4gICAgICAgICAgaWYgKGNvbXBhcmUgJiAxIHx8ICFzdXBwb3J0LnNvcnREZXRhY2hlZCAmJiBiLmNvbXBhcmVEb2N1bWVudFBvc2l0aW9uKGEpID09PSBjb21wYXJlKSB7XG4gICAgICAgICAgICAvLyBDaG9vc2UgdGhlIGZpcnN0IGVsZW1lbnQgdGhhdCBpcyByZWxhdGVkIHRvIG91ciBwcmVmZXJyZWQgZG9jdW1lbnRcbiAgICAgICAgICAgIGlmIChhID09PSBkb2N1bWVudCB8fCBhLm93bmVyRG9jdW1lbnQgPT09IHByZWZlcnJlZERvYyAmJiBjb250YWlucyhwcmVmZXJyZWREb2MsIGEpKSB7XG4gICAgICAgICAgICAgIHJldHVybiAtMTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgaWYgKGIgPT09IGRvY3VtZW50IHx8IGIub3duZXJEb2N1bWVudCA9PT0gcHJlZmVycmVkRG9jICYmIGNvbnRhaW5zKHByZWZlcnJlZERvYywgYikpIHtcbiAgICAgICAgICAgICAgcmV0dXJuIDE7XG4gICAgICAgICAgICB9IC8vIE1haW50YWluIG9yaWdpbmFsIG9yZGVyXG5cblxuICAgICAgICAgICAgcmV0dXJuIHNvcnRJbnB1dCA/IGluZGV4T2Yoc29ydElucHV0LCBhKSAtIGluZGV4T2Yoc29ydElucHV0LCBiKSA6IDA7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgcmV0dXJuIGNvbXBhcmUgJiA0ID8gLTEgOiAxO1xuICAgICAgICB9IDogZnVuY3Rpb24gKGEsIGIpIHtcbiAgICAgICAgICAvLyBFeGl0IGVhcmx5IGlmIHRoZSBub2RlcyBhcmUgaWRlbnRpY2FsXG4gICAgICAgICAgaWYgKGEgPT09IGIpIHtcbiAgICAgICAgICAgIGhhc0R1cGxpY2F0ZSA9IHRydWU7XG4gICAgICAgICAgICByZXR1cm4gMDtcbiAgICAgICAgICB9XG5cbiAgICAgICAgICB2YXIgY3VyLFxuICAgICAgICAgICAgICBpID0gMCxcbiAgICAgICAgICAgICAgYXVwID0gYS5wYXJlbnROb2RlLFxuICAgICAgICAgICAgICBidXAgPSBiLnBhcmVudE5vZGUsXG4gICAgICAgICAgICAgIGFwID0gW2FdLFxuICAgICAgICAgICAgICBicCA9IFtiXTsgLy8gUGFyZW50bGVzcyBub2RlcyBhcmUgZWl0aGVyIGRvY3VtZW50cyBvciBkaXNjb25uZWN0ZWRcblxuICAgICAgICAgIGlmICghYXVwIHx8ICFidXApIHtcbiAgICAgICAgICAgIHJldHVybiBhID09PSBkb2N1bWVudCA/IC0xIDogYiA9PT0gZG9jdW1lbnQgPyAxIDogYXVwID8gLTEgOiBidXAgPyAxIDogc29ydElucHV0ID8gaW5kZXhPZihzb3J0SW5wdXQsIGEpIC0gaW5kZXhPZihzb3J0SW5wdXQsIGIpIDogMDsgLy8gSWYgdGhlIG5vZGVzIGFyZSBzaWJsaW5ncywgd2UgY2FuIGRvIGEgcXVpY2sgY2hlY2tcbiAgICAgICAgICB9IGVsc2UgaWYgKGF1cCA9PT0gYnVwKSB7XG4gICAgICAgICAgICByZXR1cm4gc2libGluZ0NoZWNrKGEsIGIpO1xuICAgICAgICAgIH0gLy8gT3RoZXJ3aXNlIHdlIG5lZWQgZnVsbCBsaXN0cyBvZiB0aGVpciBhbmNlc3RvcnMgZm9yIGNvbXBhcmlzb25cblxuXG4gICAgICAgICAgY3VyID0gYTtcblxuICAgICAgICAgIHdoaWxlIChjdXIgPSBjdXIucGFyZW50Tm9kZSkge1xuICAgICAgICAgICAgYXAudW5zaGlmdChjdXIpO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIGN1ciA9IGI7XG5cbiAgICAgICAgICB3aGlsZSAoY3VyID0gY3VyLnBhcmVudE5vZGUpIHtcbiAgICAgICAgICAgIGJwLnVuc2hpZnQoY3VyKTtcbiAgICAgICAgICB9IC8vIFdhbGsgZG93biB0aGUgdHJlZSBsb29raW5nIGZvciBhIGRpc2NyZXBhbmN5XG5cblxuICAgICAgICAgIHdoaWxlIChhcFtpXSA9PT0gYnBbaV0pIHtcbiAgICAgICAgICAgIGkrKztcbiAgICAgICAgICB9XG5cbiAgICAgICAgICByZXR1cm4gaSA/IC8vIERvIGEgc2libGluZyBjaGVjayBpZiB0aGUgbm9kZXMgaGF2ZSBhIGNvbW1vbiBhbmNlc3RvclxuICAgICAgICAgIHNpYmxpbmdDaGVjayhhcFtpXSwgYnBbaV0pIDogLy8gT3RoZXJ3aXNlIG5vZGVzIGluIG91ciBkb2N1bWVudCBzb3J0IGZpcnN0XG4gICAgICAgICAgYXBbaV0gPT09IHByZWZlcnJlZERvYyA/IC0xIDogYnBbaV0gPT09IHByZWZlcnJlZERvYyA/IDEgOiAwO1xuICAgICAgICB9O1xuICAgICAgICByZXR1cm4gZG9jdW1lbnQ7XG4gICAgICB9O1xuXG4gICAgICBTaXp6bGUubWF0Y2hlcyA9IGZ1bmN0aW9uIChleHByLCBlbGVtZW50cykge1xuICAgICAgICByZXR1cm4gU2l6emxlKGV4cHIsIG51bGwsIG51bGwsIGVsZW1lbnRzKTtcbiAgICAgIH07XG5cbiAgICAgIFNpenpsZS5tYXRjaGVzU2VsZWN0b3IgPSBmdW5jdGlvbiAoZWxlbSwgZXhwcikge1xuICAgICAgICAvLyBTZXQgZG9jdW1lbnQgdmFycyBpZiBuZWVkZWRcbiAgICAgICAgaWYgKChlbGVtLm93bmVyRG9jdW1lbnQgfHwgZWxlbSkgIT09IGRvY3VtZW50KSB7XG4gICAgICAgICAgc2V0RG9jdW1lbnQoZWxlbSk7XG4gICAgICAgIH1cblxuICAgICAgICBpZiAoc3VwcG9ydC5tYXRjaGVzU2VsZWN0b3IgJiYgZG9jdW1lbnRJc0hUTUwgJiYgIW5vbm5hdGl2ZVNlbGVjdG9yQ2FjaGVbZXhwciArIFwiIFwiXSAmJiAoIXJidWdneU1hdGNoZXMgfHwgIXJidWdneU1hdGNoZXMudGVzdChleHByKSkgJiYgKCFyYnVnZ3lRU0EgfHwgIXJidWdneVFTQS50ZXN0KGV4cHIpKSkge1xuICAgICAgICAgIHRyeSB7XG4gICAgICAgICAgICB2YXIgcmV0ID0gbWF0Y2hlcy5jYWxsKGVsZW0sIGV4cHIpOyAvLyBJRSA5J3MgbWF0Y2hlc1NlbGVjdG9yIHJldHVybnMgZmFsc2Ugb24gZGlzY29ubmVjdGVkIG5vZGVzXG5cbiAgICAgICAgICAgIGlmIChyZXQgfHwgc3VwcG9ydC5kaXNjb25uZWN0ZWRNYXRjaCB8fCAvLyBBcyB3ZWxsLCBkaXNjb25uZWN0ZWQgbm9kZXMgYXJlIHNhaWQgdG8gYmUgaW4gYSBkb2N1bWVudFxuICAgICAgICAgICAgLy8gZnJhZ21lbnQgaW4gSUUgOVxuICAgICAgICAgICAgZWxlbS5kb2N1bWVudCAmJiBlbGVtLmRvY3VtZW50Lm5vZGVUeXBlICE9PSAxMSkge1xuICAgICAgICAgICAgICByZXR1cm4gcmV0O1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgICAgICAgIC8vIFtBZEd1YXJkIFBhdGhdOiBGaXggdGhlIGNhY2hlIHZhbHVlXG4gICAgICAgICAgICBub25uYXRpdmVTZWxlY3RvckNhY2hlKGV4cHIsIHRydWUpO1xuICAgICAgICAgIH1cbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiBTaXp6bGUoZXhwciwgZG9jdW1lbnQsIG51bGwsIFtlbGVtXSkubGVuZ3RoID4gMDtcbiAgICAgIH07XG5cbiAgICAgIFNpenpsZS5jb250YWlucyA9IGZ1bmN0aW9uIChjb250ZXh0LCBlbGVtKSB7XG4gICAgICAgIC8vIFNldCBkb2N1bWVudCB2YXJzIGlmIG5lZWRlZFxuICAgICAgICBpZiAoKGNvbnRleHQub3duZXJEb2N1bWVudCB8fCBjb250ZXh0KSAhPT0gZG9jdW1lbnQpIHtcbiAgICAgICAgICBzZXREb2N1bWVudChjb250ZXh0KTtcbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiBjb250YWlucyhjb250ZXh0LCBlbGVtKTtcbiAgICAgIH07XG5cbiAgICAgIFNpenpsZS5hdHRyID0gZnVuY3Rpb24gKGVsZW0sIG5hbWUpIHtcbiAgICAgICAgLy8gU2V0IGRvY3VtZW50IHZhcnMgaWYgbmVlZGVkXG4gICAgICAgIGlmICgoZWxlbS5vd25lckRvY3VtZW50IHx8IGVsZW0pICE9PSBkb2N1bWVudCkge1xuICAgICAgICAgIHNldERvY3VtZW50KGVsZW0pO1xuICAgICAgICB9XG5cbiAgICAgICAgdmFyIGZuID0gRXhwci5hdHRySGFuZGxlW25hbWUudG9Mb3dlckNhc2UoKV0sXG4gICAgICAgICAgICAvLyBEb24ndCBnZXQgZm9vbGVkIGJ5IE9iamVjdC5wcm90b3R5cGUgcHJvcGVydGllcyAoalF1ZXJ5ICMxMzgwNylcbiAgICAgICAgdmFsID0gZm4gJiYgaGFzT3duLmNhbGwoRXhwci5hdHRySGFuZGxlLCBuYW1lLnRvTG93ZXJDYXNlKCkpID8gZm4oZWxlbSwgbmFtZSwgIWRvY3VtZW50SXNIVE1MKSA6IHVuZGVmaW5lZDtcbiAgICAgICAgcmV0dXJuIHZhbCAhPT0gdW5kZWZpbmVkID8gdmFsIDogc3VwcG9ydC5hdHRyaWJ1dGVzIHx8ICFkb2N1bWVudElzSFRNTCA/IGVsZW0uZ2V0QXR0cmlidXRlKG5hbWUpIDogKHZhbCA9IGVsZW0uZ2V0QXR0cmlidXRlTm9kZShuYW1lKSkgJiYgdmFsLnNwZWNpZmllZCA/IHZhbC52YWx1ZSA6IG51bGw7XG4gICAgICB9O1xuXG4gICAgICBTaXp6bGUuZXNjYXBlID0gZnVuY3Rpb24gKHNlbCkge1xuICAgICAgICByZXR1cm4gKHNlbCArIFwiXCIpLnJlcGxhY2UocmNzc2VzY2FwZSwgZmNzc2VzY2FwZSk7XG4gICAgICB9O1xuXG4gICAgICBTaXp6bGUuZXJyb3IgPSBmdW5jdGlvbiAobXNnKSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcihcIlN5bnRheCBlcnJvciwgdW5yZWNvZ25pemVkIGV4cHJlc3Npb246IFwiICsgbXNnKTtcbiAgICAgIH07XG4gICAgICAvKipcbiAgICAgICAqIERvY3VtZW50IHNvcnRpbmcgYW5kIHJlbW92aW5nIGR1cGxpY2F0ZXNcbiAgICAgICAqIEBwYXJhbSB7QXJyYXlMaWtlfSByZXN1bHRzXG4gICAgICAgKi9cblxuXG4gICAgICBTaXp6bGUudW5pcXVlU29ydCA9IGZ1bmN0aW9uIChyZXN1bHRzKSB7XG4gICAgICAgIHZhciBlbGVtLFxuICAgICAgICAgICAgZHVwbGljYXRlcyA9IFtdLFxuICAgICAgICAgICAgaiA9IDAsXG4gICAgICAgICAgICBpID0gMDsgLy8gVW5sZXNzIHdlICprbm93KiB3ZSBjYW4gZGV0ZWN0IGR1cGxpY2F0ZXMsIGFzc3VtZSB0aGVpciBwcmVzZW5jZVxuXG4gICAgICAgIGhhc0R1cGxpY2F0ZSA9ICFzdXBwb3J0LmRldGVjdER1cGxpY2F0ZXM7XG4gICAgICAgIHNvcnRJbnB1dCA9ICFzdXBwb3J0LnNvcnRTdGFibGUgJiYgcmVzdWx0cy5zbGljZSgwKTtcbiAgICAgICAgcmVzdWx0cy5zb3J0KHNvcnRPcmRlcik7XG5cbiAgICAgICAgaWYgKGhhc0R1cGxpY2F0ZSkge1xuICAgICAgICAgIHdoaWxlIChlbGVtID0gcmVzdWx0c1tpKytdKSB7XG4gICAgICAgICAgICBpZiAoZWxlbSA9PT0gcmVzdWx0c1tpXSkge1xuICAgICAgICAgICAgICBqID0gZHVwbGljYXRlcy5wdXNoKGkpO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cblxuICAgICAgICAgIHdoaWxlIChqLS0pIHtcbiAgICAgICAgICAgIHJlc3VsdHMuc3BsaWNlKGR1cGxpY2F0ZXNbal0sIDEpO1xuICAgICAgICAgIH1cbiAgICAgICAgfSAvLyBDbGVhciBpbnB1dCBhZnRlciBzb3J0aW5nIHRvIHJlbGVhc2Ugb2JqZWN0c1xuICAgICAgICAvLyBTZWUgaHR0cHM6Ly9naXRodWIuY29tL2pxdWVyeS9zaXp6bGUvcHVsbC8yMjVcblxuXG4gICAgICAgIHNvcnRJbnB1dCA9IG51bGw7XG4gICAgICAgIHJldHVybiByZXN1bHRzO1xuICAgICAgfTtcbiAgICAgIC8qKlxuICAgICAgICogVXRpbGl0eSBmdW5jdGlvbiBmb3IgcmV0cmlldmluZyB0aGUgdGV4dCB2YWx1ZSBvZiBhbiBhcnJheSBvZiBET00gbm9kZXNcbiAgICAgICAqIEBwYXJhbSB7QXJyYXl8RWxlbWVudH0gZWxlbVxuICAgICAgICovXG5cblxuICAgICAgZ2V0VGV4dCA9IFNpenpsZS5nZXRUZXh0ID0gZnVuY3Rpb24gKGVsZW0pIHtcbiAgICAgICAgdmFyIG5vZGUsXG4gICAgICAgICAgICByZXQgPSBcIlwiLFxuICAgICAgICAgICAgaSA9IDAsXG4gICAgICAgICAgICBub2RlVHlwZSA9IGVsZW0ubm9kZVR5cGU7XG5cbiAgICAgICAgaWYgKCFub2RlVHlwZSkge1xuICAgICAgICAgIC8vIElmIG5vIG5vZGVUeXBlLCB0aGlzIGlzIGV4cGVjdGVkIHRvIGJlIGFuIGFycmF5XG4gICAgICAgICAgd2hpbGUgKG5vZGUgPSBlbGVtW2krK10pIHtcbiAgICAgICAgICAgIC8vIERvIG5vdCB0cmF2ZXJzZSBjb21tZW50IG5vZGVzXG4gICAgICAgICAgICByZXQgKz0gZ2V0VGV4dChub2RlKTtcbiAgICAgICAgICB9XG4gICAgICAgIH0gZWxzZSBpZiAobm9kZVR5cGUgPT09IDEgfHwgbm9kZVR5cGUgPT09IDkgfHwgbm9kZVR5cGUgPT09IDExKSB7XG4gICAgICAgICAgLy8gVXNlIHRleHRDb250ZW50IGZvciBlbGVtZW50c1xuICAgICAgICAgIC8vIGlubmVyVGV4dCB1c2FnZSByZW1vdmVkIGZvciBjb25zaXN0ZW5jeSBvZiBuZXcgbGluZXMgKGpRdWVyeSAjMTExNTMpXG4gICAgICAgICAgaWYgKHR5cGVvZiBlbGVtLnRleHRDb250ZW50ID09PSBcInN0cmluZ1wiKSB7XG4gICAgICAgICAgICByZXR1cm4gZWxlbS50ZXh0Q29udGVudDtcbiAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgLy8gVHJhdmVyc2UgaXRzIGNoaWxkcmVuXG4gICAgICAgICAgICBmb3IgKGVsZW0gPSBlbGVtLmZpcnN0Q2hpbGQ7IGVsZW07IGVsZW0gPSBlbGVtLm5leHRTaWJsaW5nKSB7XG4gICAgICAgICAgICAgIHJldCArPSBnZXRUZXh0KGVsZW0pO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cbiAgICAgICAgfSBlbHNlIGlmIChub2RlVHlwZSA9PT0gMyB8fCBub2RlVHlwZSA9PT0gNCkge1xuICAgICAgICAgIHJldHVybiBlbGVtLm5vZGVWYWx1ZTtcbiAgICAgICAgfSAvLyBEbyBub3QgaW5jbHVkZSBjb21tZW50IG9yIHByb2Nlc3NpbmcgaW5zdHJ1Y3Rpb24gbm9kZXNcblxuXG4gICAgICAgIHJldHVybiByZXQ7XG4gICAgICB9O1xuXG4gICAgICBFeHByID0gU2l6emxlLnNlbGVjdG9ycyA9IHtcbiAgICAgICAgLy8gQ2FuIGJlIGFkanVzdGVkIGJ5IHRoZSB1c2VyXG4gICAgICAgIGNhY2hlTGVuZ3RoOiA1MCxcbiAgICAgICAgY3JlYXRlUHNldWRvOiBtYXJrRnVuY3Rpb24sXG4gICAgICAgIG1hdGNoOiBtYXRjaEV4cHIsXG4gICAgICAgIGF0dHJIYW5kbGU6IHt9LFxuICAgICAgICBmaW5kOiB7fSxcbiAgICAgICAgcmVsYXRpdmU6IHtcbiAgICAgICAgICBcIj5cIjoge1xuICAgICAgICAgICAgZGlyOiBcInBhcmVudE5vZGVcIixcbiAgICAgICAgICAgIGZpcnN0OiB0cnVlXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcIiBcIjoge1xuICAgICAgICAgICAgZGlyOiBcInBhcmVudE5vZGVcIlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCIrXCI6IHtcbiAgICAgICAgICAgIGRpcjogXCJwcmV2aW91c1NpYmxpbmdcIixcbiAgICAgICAgICAgIGZpcnN0OiB0cnVlXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcIn5cIjoge1xuICAgICAgICAgICAgZGlyOiBcInByZXZpb3VzU2libGluZ1wiXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBwcmVGaWx0ZXI6IHtcbiAgICAgICAgICBcIkFUVFJcIjogZnVuY3Rpb24gQVRUUihtYXRjaCkge1xuICAgICAgICAgICAgbWF0Y2hbMV0gPSBtYXRjaFsxXS5yZXBsYWNlKHJ1bmVzY2FwZSwgZnVuZXNjYXBlKTsgLy8gTW92ZSB0aGUgZ2l2ZW4gdmFsdWUgdG8gbWF0Y2hbM10gd2hldGhlciBxdW90ZWQgb3IgdW5xdW90ZWRcblxuICAgICAgICAgICAgbWF0Y2hbM10gPSAobWF0Y2hbM10gfHwgbWF0Y2hbNF0gfHwgbWF0Y2hbNV0gfHwgXCJcIikucmVwbGFjZShydW5lc2NhcGUsIGZ1bmVzY2FwZSk7XG5cbiAgICAgICAgICAgIGlmIChtYXRjaFsyXSA9PT0gXCJ+PVwiKSB7XG4gICAgICAgICAgICAgIG1hdGNoWzNdID0gXCIgXCIgKyBtYXRjaFszXSArIFwiIFwiO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICByZXR1cm4gbWF0Y2guc2xpY2UoMCwgNCk7XG4gICAgICAgICAgfSxcbiAgICAgICAgICBcIkNISUxEXCI6IGZ1bmN0aW9uIENISUxEKG1hdGNoKSB7XG4gICAgICAgICAgICAvKiBtYXRjaGVzIGZyb20gbWF0Y2hFeHByW1wiQ0hJTERcIl1cbiAgICAgICAgICAgIFx0MSB0eXBlIChvbmx5fG50aHwuLi4pXG4gICAgICAgICAgICBcdDIgd2hhdCAoY2hpbGR8b2YtdHlwZSlcbiAgICAgICAgICAgIFx0MyBhcmd1bWVudCAoZXZlbnxvZGR8XFxkKnxcXGQqbihbKy1dXFxkKyk/fC4uLilcbiAgICAgICAgICAgIFx0NCB4bi1jb21wb25lbnQgb2YgeG4reSBhcmd1bWVudCAoWystXT9cXGQqbnwpXG4gICAgICAgICAgICBcdDUgc2lnbiBvZiB4bi1jb21wb25lbnRcbiAgICAgICAgICAgIFx0NiB4IG9mIHhuLWNvbXBvbmVudFxuICAgICAgICAgICAgXHQ3IHNpZ24gb2YgeS1jb21wb25lbnRcbiAgICAgICAgICAgIFx0OCB5IG9mIHktY29tcG9uZW50XG4gICAgICAgICAgICAqL1xuICAgICAgICAgICAgbWF0Y2hbMV0gPSBtYXRjaFsxXS50b0xvd2VyQ2FzZSgpO1xuXG4gICAgICAgICAgICBpZiAobWF0Y2hbMV0uc2xpY2UoMCwgMykgPT09IFwibnRoXCIpIHtcbiAgICAgICAgICAgICAgLy8gbnRoLSogcmVxdWlyZXMgYXJndW1lbnRcbiAgICAgICAgICAgICAgaWYgKCFtYXRjaFszXSkge1xuICAgICAgICAgICAgICAgIFNpenpsZS5lcnJvcihtYXRjaFswXSk7XG4gICAgICAgICAgICAgIH0gLy8gbnVtZXJpYyB4IGFuZCB5IHBhcmFtZXRlcnMgZm9yIEV4cHIuZmlsdGVyLkNISUxEXG4gICAgICAgICAgICAgIC8vIHJlbWVtYmVyIHRoYXQgZmFsc2UvdHJ1ZSBjYXN0IHJlc3BlY3RpdmVseSB0byAwLzFcblxuXG4gICAgICAgICAgICAgIG1hdGNoWzRdID0gKyhtYXRjaFs0XSA/IG1hdGNoWzVdICsgKG1hdGNoWzZdIHx8IDEpIDogMiAqIChtYXRjaFszXSA9PT0gXCJldmVuXCIgfHwgbWF0Y2hbM10gPT09IFwib2RkXCIpKTtcbiAgICAgICAgICAgICAgbWF0Y2hbNV0gPSArKG1hdGNoWzddICsgbWF0Y2hbOF0gfHwgbWF0Y2hbM10gPT09IFwib2RkXCIpOyAvLyBvdGhlciB0eXBlcyBwcm9oaWJpdCBhcmd1bWVudHNcbiAgICAgICAgICAgIH0gZWxzZSBpZiAobWF0Y2hbM10pIHtcbiAgICAgICAgICAgICAgU2l6emxlLmVycm9yKG1hdGNoWzBdKTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgcmV0dXJuIG1hdGNoO1xuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJQU0VVRE9cIjogZnVuY3Rpb24gUFNFVURPKG1hdGNoKSB7XG4gICAgICAgICAgICB2YXIgZXhjZXNzLFxuICAgICAgICAgICAgICAgIHVucXVvdGVkID0gIW1hdGNoWzZdICYmIG1hdGNoWzJdO1xuXG4gICAgICAgICAgICBpZiAobWF0Y2hFeHByW1wiQ0hJTERcIl0udGVzdChtYXRjaFswXSkpIHtcbiAgICAgICAgICAgICAgcmV0dXJuIG51bGw7XG4gICAgICAgICAgICB9IC8vIEFjY2VwdCBxdW90ZWQgYXJndW1lbnRzIGFzLWlzXG5cblxuICAgICAgICAgICAgaWYgKG1hdGNoWzNdKSB7XG4gICAgICAgICAgICAgIG1hdGNoWzJdID0gbWF0Y2hbNF0gfHwgbWF0Y2hbNV0gfHwgXCJcIjsgLy8gU3RyaXAgZXhjZXNzIGNoYXJhY3RlcnMgZnJvbSB1bnF1b3RlZCBhcmd1bWVudHNcbiAgICAgICAgICAgIH0gZWxzZSBpZiAodW5xdW90ZWQgJiYgcnBzZXVkby50ZXN0KHVucXVvdGVkKSAmJiAoIC8vIEdldCBleGNlc3MgZnJvbSB0b2tlbml6ZSAocmVjdXJzaXZlbHkpXG4gICAgICAgICAgICBleGNlc3MgPSB0b2tlbml6ZSh1bnF1b3RlZCwgdHJ1ZSkpICYmICggLy8gYWR2YW5jZSB0byB0aGUgbmV4dCBjbG9zaW5nIHBhcmVudGhlc2lzXG4gICAgICAgICAgICBleGNlc3MgPSB1bnF1b3RlZC5pbmRleE9mKFwiKVwiLCB1bnF1b3RlZC5sZW5ndGggLSBleGNlc3MpIC0gdW5xdW90ZWQubGVuZ3RoKSkge1xuICAgICAgICAgICAgICAvLyBleGNlc3MgaXMgYSBuZWdhdGl2ZSBpbmRleFxuICAgICAgICAgICAgICBtYXRjaFswXSA9IG1hdGNoWzBdLnNsaWNlKDAsIGV4Y2Vzcyk7XG4gICAgICAgICAgICAgIG1hdGNoWzJdID0gdW5xdW90ZWQuc2xpY2UoMCwgZXhjZXNzKTtcbiAgICAgICAgICAgIH0gLy8gUmV0dXJuIG9ubHkgY2FwdHVyZXMgbmVlZGVkIGJ5IHRoZSBwc2V1ZG8gZmlsdGVyIG1ldGhvZCAodHlwZSBhbmQgYXJndW1lbnQpXG5cblxuICAgICAgICAgICAgcmV0dXJuIG1hdGNoLnNsaWNlKDAsIDMpO1xuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgZmlsdGVyOiB7XG4gICAgICAgICAgXCJUQUdcIjogZnVuY3Rpb24gVEFHKG5vZGVOYW1lU2VsZWN0b3IpIHtcbiAgICAgICAgICAgIHZhciBub2RlTmFtZSA9IG5vZGVOYW1lU2VsZWN0b3IucmVwbGFjZShydW5lc2NhcGUsIGZ1bmVzY2FwZSkudG9Mb3dlckNhc2UoKTtcbiAgICAgICAgICAgIHJldHVybiBub2RlTmFtZVNlbGVjdG9yID09PSBcIipcIiA/IGZ1bmN0aW9uICgpIHtcbiAgICAgICAgICAgICAgcmV0dXJuIHRydWU7XG4gICAgICAgICAgICB9IDogZnVuY3Rpb24gKGVsZW0pIHtcbiAgICAgICAgICAgICAgcmV0dXJuIGVsZW0ubm9kZU5hbWUgJiYgZWxlbS5ub2RlTmFtZS50b0xvd2VyQ2FzZSgpID09PSBub2RlTmFtZTtcbiAgICAgICAgICAgIH07XG4gICAgICAgICAgfSxcbiAgICAgICAgICBcIkNMQVNTXCI6IGZ1bmN0aW9uIENMQVNTKGNsYXNzTmFtZSkge1xuICAgICAgICAgICAgdmFyIHBhdHRlcm4gPSBjbGFzc0NhY2hlW2NsYXNzTmFtZSArIFwiIFwiXTtcbiAgICAgICAgICAgIHJldHVybiBwYXR0ZXJuIHx8IChwYXR0ZXJuID0gbmV3IFJlZ0V4cChcIihefFwiICsgd2hpdGVzcGFjZSArIFwiKVwiICsgY2xhc3NOYW1lICsgXCIoXCIgKyB3aGl0ZXNwYWNlICsgXCJ8JClcIikpICYmIGNsYXNzQ2FjaGUoY2xhc3NOYW1lLCBmdW5jdGlvbiAoZWxlbSkge1xuICAgICAgICAgICAgICByZXR1cm4gcGF0dGVybi50ZXN0KHR5cGVvZiBlbGVtLmNsYXNzTmFtZSA9PT0gXCJzdHJpbmdcIiAmJiBlbGVtLmNsYXNzTmFtZSB8fCB0eXBlb2YgZWxlbS5nZXRBdHRyaWJ1dGUgIT09IFwidW5kZWZpbmVkXCIgJiYgZWxlbS5nZXRBdHRyaWJ1dGUoXCJjbGFzc1wiKSB8fCBcIlwiKTtcbiAgICAgICAgICAgIH0pO1xuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJBVFRSXCI6IGZ1bmN0aW9uIEFUVFIobmFtZSwgb3BlcmF0b3IsIGNoZWNrKSB7XG4gICAgICAgICAgICByZXR1cm4gZnVuY3Rpb24gKGVsZW0pIHtcbiAgICAgICAgICAgICAgdmFyIHJlc3VsdCA9IFNpenpsZS5hdHRyKGVsZW0sIG5hbWUpO1xuXG4gICAgICAgICAgICAgIGlmIChyZXN1bHQgPT0gbnVsbCkge1xuICAgICAgICAgICAgICAgIHJldHVybiBvcGVyYXRvciA9PT0gXCIhPVwiO1xuICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgaWYgKCFvcGVyYXRvcikge1xuICAgICAgICAgICAgICAgIHJldHVybiB0cnVlO1xuICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgcmVzdWx0ICs9IFwiXCI7XG4gICAgICAgICAgICAgIHJldHVybiBvcGVyYXRvciA9PT0gXCI9XCIgPyByZXN1bHQgPT09IGNoZWNrIDogb3BlcmF0b3IgPT09IFwiIT1cIiA/IHJlc3VsdCAhPT0gY2hlY2sgOiBvcGVyYXRvciA9PT0gXCJePVwiID8gY2hlY2sgJiYgcmVzdWx0LmluZGV4T2YoY2hlY2spID09PSAwIDogb3BlcmF0b3IgPT09IFwiKj1cIiA/IGNoZWNrICYmIHJlc3VsdC5pbmRleE9mKGNoZWNrKSA+IC0xIDogb3BlcmF0b3IgPT09IFwiJD1cIiA/IGNoZWNrICYmIHJlc3VsdC5zbGljZSgtY2hlY2subGVuZ3RoKSA9PT0gY2hlY2sgOiBvcGVyYXRvciA9PT0gXCJ+PVwiID8gKFwiIFwiICsgcmVzdWx0LnJlcGxhY2UocndoaXRlc3BhY2UsIFwiIFwiKSArIFwiIFwiKS5pbmRleE9mKGNoZWNrKSA+IC0xIDogb3BlcmF0b3IgPT09IFwifD1cIiA/IHJlc3VsdCA9PT0gY2hlY2sgfHwgcmVzdWx0LnNsaWNlKDAsIGNoZWNrLmxlbmd0aCArIDEpID09PSBjaGVjayArIFwiLVwiIDogZmFsc2U7XG4gICAgICAgICAgICB9O1xuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJDSElMRFwiOiBmdW5jdGlvbiBDSElMRCh0eXBlLCB3aGF0LCBhcmd1bWVudCwgZmlyc3QsIGxhc3QpIHtcbiAgICAgICAgICAgIHZhciBzaW1wbGUgPSB0eXBlLnNsaWNlKDAsIDMpICE9PSBcIm50aFwiLFxuICAgICAgICAgICAgICAgIGZvcndhcmQgPSB0eXBlLnNsaWNlKC00KSAhPT0gXCJsYXN0XCIsXG4gICAgICAgICAgICAgICAgb2ZUeXBlID0gd2hhdCA9PT0gXCJvZi10eXBlXCI7XG4gICAgICAgICAgICByZXR1cm4gZmlyc3QgPT09IDEgJiYgbGFzdCA9PT0gMCA/IC8vIFNob3J0Y3V0IGZvciA6bnRoLSoobilcbiAgICAgICAgICAgIGZ1bmN0aW9uIChlbGVtKSB7XG4gICAgICAgICAgICAgIHJldHVybiAhIWVsZW0ucGFyZW50Tm9kZTtcbiAgICAgICAgICAgIH0gOiBmdW5jdGlvbiAoZWxlbSwgY29udGV4dCwgeG1sKSB7XG4gICAgICAgICAgICAgIHZhciBjYWNoZSxcbiAgICAgICAgICAgICAgICAgIHVuaXF1ZUNhY2hlLFxuICAgICAgICAgICAgICAgICAgb3V0ZXJDYWNoZSxcbiAgICAgICAgICAgICAgICAgIG5vZGUsXG4gICAgICAgICAgICAgICAgICBub2RlSW5kZXgsXG4gICAgICAgICAgICAgICAgICBzdGFydCxcbiAgICAgICAgICAgICAgICAgIGRpciA9IHNpbXBsZSAhPT0gZm9yd2FyZCA/IFwibmV4dFNpYmxpbmdcIiA6IFwicHJldmlvdXNTaWJsaW5nXCIsXG4gICAgICAgICAgICAgICAgICBwYXJlbnQgPSBlbGVtLnBhcmVudE5vZGUsXG4gICAgICAgICAgICAgICAgICBuYW1lID0gb2ZUeXBlICYmIGVsZW0ubm9kZU5hbWUudG9Mb3dlckNhc2UoKSxcbiAgICAgICAgICAgICAgICAgIHVzZUNhY2hlID0gIXhtbCAmJiAhb2ZUeXBlLFxuICAgICAgICAgICAgICAgICAgZGlmZiA9IGZhbHNlO1xuXG4gICAgICAgICAgICAgIGlmIChwYXJlbnQpIHtcbiAgICAgICAgICAgICAgICAvLyA6KGZpcnN0fGxhc3R8b25seSktKGNoaWxkfG9mLXR5cGUpXG4gICAgICAgICAgICAgICAgaWYgKHNpbXBsZSkge1xuICAgICAgICAgICAgICAgICAgd2hpbGUgKGRpcikge1xuICAgICAgICAgICAgICAgICAgICBub2RlID0gZWxlbTtcblxuICAgICAgICAgICAgICAgICAgICB3aGlsZSAobm9kZSA9IG5vZGVbZGlyXSkge1xuICAgICAgICAgICAgICAgICAgICAgIGlmIChvZlR5cGUgPyBub2RlLm5vZGVOYW1lLnRvTG93ZXJDYXNlKCkgPT09IG5hbWUgOiBub2RlLm5vZGVUeXBlID09PSAxKSB7XG4gICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICB9IC8vIFJldmVyc2UgZGlyZWN0aW9uIGZvciA6b25seS0qIChpZiB3ZSBoYXZlbid0IHlldCBkb25lIHNvKVxuXG5cbiAgICAgICAgICAgICAgICAgICAgc3RhcnQgPSBkaXIgPSB0eXBlID09PSBcIm9ubHlcIiAmJiAhc3RhcnQgJiYgXCJuZXh0U2libGluZ1wiO1xuICAgICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgICByZXR1cm4gdHJ1ZTtcbiAgICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgICBzdGFydCA9IFtmb3J3YXJkID8gcGFyZW50LmZpcnN0Q2hpbGQgOiBwYXJlbnQubGFzdENoaWxkXTsgLy8gbm9uLXhtbCA6bnRoLWNoaWxkKC4uLikgc3RvcmVzIGNhY2hlIGRhdGEgb24gYHBhcmVudGBcblxuICAgICAgICAgICAgICAgIGlmIChmb3J3YXJkICYmIHVzZUNhY2hlKSB7XG4gICAgICAgICAgICAgICAgICAvLyBTZWVrIGBlbGVtYCBmcm9tIGEgcHJldmlvdXNseS1jYWNoZWQgaW5kZXhcbiAgICAgICAgICAgICAgICAgIC8vIC4uLmluIGEgZ3ppcC1mcmllbmRseSB3YXlcbiAgICAgICAgICAgICAgICAgIG5vZGUgPSBwYXJlbnQ7XG4gICAgICAgICAgICAgICAgICBvdXRlckNhY2hlID0gbm9kZVtleHBhbmRvXSB8fCAobm9kZVtleHBhbmRvXSA9IHt9KTsgLy8gU3VwcG9ydDogSUUgPDkgb25seVxuICAgICAgICAgICAgICAgICAgLy8gRGVmZW5kIGFnYWluc3QgY2xvbmVkIGF0dHJvcGVydGllcyAoalF1ZXJ5IGdoLTE3MDkpXG5cbiAgICAgICAgICAgICAgICAgIHVuaXF1ZUNhY2hlID0gb3V0ZXJDYWNoZVtub2RlLnVuaXF1ZUlEXSB8fCAob3V0ZXJDYWNoZVtub2RlLnVuaXF1ZUlEXSA9IHt9KTtcbiAgICAgICAgICAgICAgICAgIGNhY2hlID0gdW5pcXVlQ2FjaGVbdHlwZV0gfHwgW107XG4gICAgICAgICAgICAgICAgICBub2RlSW5kZXggPSBjYWNoZVswXSA9PT0gZGlycnVucyAmJiBjYWNoZVsxXTtcbiAgICAgICAgICAgICAgICAgIGRpZmYgPSBub2RlSW5kZXggJiYgY2FjaGVbMl07XG4gICAgICAgICAgICAgICAgICBub2RlID0gbm9kZUluZGV4ICYmIHBhcmVudC5jaGlsZE5vZGVzW25vZGVJbmRleF07XG5cbiAgICAgICAgICAgICAgICAgIHdoaWxlIChub2RlID0gKytub2RlSW5kZXggJiYgbm9kZSAmJiBub2RlW2Rpcl0gfHwgKCAvLyBGYWxsYmFjayB0byBzZWVraW5nIGBlbGVtYCBmcm9tIHRoZSBzdGFydFxuICAgICAgICAgICAgICAgICAgZGlmZiA9IG5vZGVJbmRleCA9IDApIHx8IHN0YXJ0LnBvcCgpKSB7XG4gICAgICAgICAgICAgICAgICAgIC8vIFdoZW4gZm91bmQsIGNhY2hlIGluZGV4ZXMgb24gYHBhcmVudGAgYW5kIGJyZWFrXG4gICAgICAgICAgICAgICAgICAgIGlmIChub2RlLm5vZGVUeXBlID09PSAxICYmICsrZGlmZiAmJiBub2RlID09PSBlbGVtKSB7XG4gICAgICAgICAgICAgICAgICAgICAgdW5pcXVlQ2FjaGVbdHlwZV0gPSBbZGlycnVucywgbm9kZUluZGV4LCBkaWZmXTtcbiAgICAgICAgICAgICAgICAgICAgICBicmVhaztcbiAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgICAgICAvLyBVc2UgcHJldmlvdXNseS1jYWNoZWQgZWxlbWVudCBpbmRleCBpZiBhdmFpbGFibGVcbiAgICAgICAgICAgICAgICAgIGlmICh1c2VDYWNoZSkge1xuICAgICAgICAgICAgICAgICAgICAvLyAuLi5pbiBhIGd6aXAtZnJpZW5kbHkgd2F5XG4gICAgICAgICAgICAgICAgICAgIG5vZGUgPSBlbGVtO1xuICAgICAgICAgICAgICAgICAgICBvdXRlckNhY2hlID0gbm9kZVtleHBhbmRvXSB8fCAobm9kZVtleHBhbmRvXSA9IHt9KTsgLy8gU3VwcG9ydDogSUUgPDkgb25seVxuICAgICAgICAgICAgICAgICAgICAvLyBEZWZlbmQgYWdhaW5zdCBjbG9uZWQgYXR0cm9wZXJ0aWVzIChqUXVlcnkgZ2gtMTcwOSlcblxuICAgICAgICAgICAgICAgICAgICB1bmlxdWVDYWNoZSA9IG91dGVyQ2FjaGVbbm9kZS51bmlxdWVJRF0gfHwgKG91dGVyQ2FjaGVbbm9kZS51bmlxdWVJRF0gPSB7fSk7XG4gICAgICAgICAgICAgICAgICAgIGNhY2hlID0gdW5pcXVlQ2FjaGVbdHlwZV0gfHwgW107XG4gICAgICAgICAgICAgICAgICAgIG5vZGVJbmRleCA9IGNhY2hlWzBdID09PSBkaXJydW5zICYmIGNhY2hlWzFdO1xuICAgICAgICAgICAgICAgICAgICBkaWZmID0gbm9kZUluZGV4O1xuICAgICAgICAgICAgICAgICAgfSAvLyB4bWwgOm50aC1jaGlsZCguLi4pXG4gICAgICAgICAgICAgICAgICAvLyBvciA6bnRoLWxhc3QtY2hpbGQoLi4uKSBvciA6bnRoKC1sYXN0KT8tb2YtdHlwZSguLi4pXG5cblxuICAgICAgICAgICAgICAgICAgaWYgKGRpZmYgPT09IGZhbHNlKSB7XG4gICAgICAgICAgICAgICAgICAgIC8vIFVzZSB0aGUgc2FtZSBsb29wIGFzIGFib3ZlIHRvIHNlZWsgYGVsZW1gIGZyb20gdGhlIHN0YXJ0XG4gICAgICAgICAgICAgICAgICAgIHdoaWxlIChub2RlID0gKytub2RlSW5kZXggJiYgbm9kZSAmJiBub2RlW2Rpcl0gfHwgKGRpZmYgPSBub2RlSW5kZXggPSAwKSB8fCBzdGFydC5wb3AoKSkge1xuICAgICAgICAgICAgICAgICAgICAgIGlmICgob2ZUeXBlID8gbm9kZS5ub2RlTmFtZS50b0xvd2VyQ2FzZSgpID09PSBuYW1lIDogbm9kZS5ub2RlVHlwZSA9PT0gMSkgJiYgKytkaWZmKSB7XG4gICAgICAgICAgICAgICAgICAgICAgICAvLyBDYWNoZSB0aGUgaW5kZXggb2YgZWFjaCBlbmNvdW50ZXJlZCBlbGVtZW50XG4gICAgICAgICAgICAgICAgICAgICAgICBpZiAodXNlQ2FjaGUpIHtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgb3V0ZXJDYWNoZSA9IG5vZGVbZXhwYW5kb10gfHwgKG5vZGVbZXhwYW5kb10gPSB7fSk7IC8vIFN1cHBvcnQ6IElFIDw5IG9ubHlcbiAgICAgICAgICAgICAgICAgICAgICAgICAgLy8gRGVmZW5kIGFnYWluc3QgY2xvbmVkIGF0dHJvcGVydGllcyAoalF1ZXJ5IGdoLTE3MDkpXG5cbiAgICAgICAgICAgICAgICAgICAgICAgICAgdW5pcXVlQ2FjaGUgPSBvdXRlckNhY2hlW25vZGUudW5pcXVlSURdIHx8IChvdXRlckNhY2hlW25vZGUudW5pcXVlSURdID0ge30pO1xuICAgICAgICAgICAgICAgICAgICAgICAgICB1bmlxdWVDYWNoZVt0eXBlXSA9IFtkaXJydW5zLCBkaWZmXTtcbiAgICAgICAgICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgICAgICAgICAgaWYgKG5vZGUgPT09IGVsZW0pIHtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgYnJlYWs7XG4gICAgICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgfSAvLyBJbmNvcnBvcmF0ZSB0aGUgb2Zmc2V0LCB0aGVuIGNoZWNrIGFnYWluc3QgY3ljbGUgc2l6ZVxuXG5cbiAgICAgICAgICAgICAgICBkaWZmIC09IGxhc3Q7XG4gICAgICAgICAgICAgICAgcmV0dXJuIGRpZmYgPT09IGZpcnN0IHx8IGRpZmYgJSBmaXJzdCA9PT0gMCAmJiBkaWZmIC8gZmlyc3QgPj0gMDtcbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfTtcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiUFNFVURPXCI6IGZ1bmN0aW9uIFBTRVVETyhwc2V1ZG8sIGFyZ3VtZW50KSB7XG4gICAgICAgICAgICAvLyBwc2V1ZG8tY2xhc3MgbmFtZXMgYXJlIGNhc2UtaW5zZW5zaXRpdmVcbiAgICAgICAgICAgIC8vIGh0dHA6Ly93d3cudzMub3JnL1RSL3NlbGVjdG9ycy8jcHNldWRvLWNsYXNzZXNcbiAgICAgICAgICAgIC8vIFByaW9yaXRpemUgYnkgY2FzZSBzZW5zaXRpdml0eSBpbiBjYXNlIGN1c3RvbSBwc2V1ZG9zIGFyZSBhZGRlZCB3aXRoIHVwcGVyY2FzZSBsZXR0ZXJzXG4gICAgICAgICAgICAvLyBSZW1lbWJlciB0aGF0IHNldEZpbHRlcnMgaW5oZXJpdHMgZnJvbSBwc2V1ZG9zXG4gICAgICAgICAgICB2YXIgYXJncyxcbiAgICAgICAgICAgICAgICBmbiA9IEV4cHIucHNldWRvc1twc2V1ZG9dIHx8IEV4cHIuc2V0RmlsdGVyc1twc2V1ZG8udG9Mb3dlckNhc2UoKV0gfHwgU2l6emxlLmVycm9yKFwidW5zdXBwb3J0ZWQgcHNldWRvOiBcIiArIHBzZXVkbyk7IC8vIFRoZSB1c2VyIG1heSB1c2UgY3JlYXRlUHNldWRvIHRvIGluZGljYXRlIHRoYXRcbiAgICAgICAgICAgIC8vIGFyZ3VtZW50cyBhcmUgbmVlZGVkIHRvIGNyZWF0ZSB0aGUgZmlsdGVyIGZ1bmN0aW9uXG4gICAgICAgICAgICAvLyBqdXN0IGFzIFNpenpsZSBkb2VzXG5cbiAgICAgICAgICAgIGlmIChmbltleHBhbmRvXSkge1xuICAgICAgICAgICAgICByZXR1cm4gZm4oYXJndW1lbnQpO1xuICAgICAgICAgICAgfSAvLyBCdXQgbWFpbnRhaW4gc3VwcG9ydCBmb3Igb2xkIHNpZ25hdHVyZXNcblxuXG4gICAgICAgICAgICBpZiAoZm4ubGVuZ3RoID4gMSkge1xuICAgICAgICAgICAgICBhcmdzID0gW3BzZXVkbywgcHNldWRvLCBcIlwiLCBhcmd1bWVudF07XG4gICAgICAgICAgICAgIHJldHVybiBFeHByLnNldEZpbHRlcnMuaGFzT3duUHJvcGVydHkocHNldWRvLnRvTG93ZXJDYXNlKCkpID8gbWFya0Z1bmN0aW9uKGZ1bmN0aW9uIChzZWVkLCBtYXRjaGVzKSB7XG4gICAgICAgICAgICAgICAgdmFyIGlkeCxcbiAgICAgICAgICAgICAgICAgICAgbWF0Y2hlZCA9IGZuKHNlZWQsIGFyZ3VtZW50KSxcbiAgICAgICAgICAgICAgICAgICAgaSA9IG1hdGNoZWQubGVuZ3RoO1xuXG4gICAgICAgICAgICAgICAgd2hpbGUgKGktLSkge1xuICAgICAgICAgICAgICAgICAgaWR4ID0gaW5kZXhPZihzZWVkLCBtYXRjaGVkW2ldKTtcbiAgICAgICAgICAgICAgICAgIHNlZWRbaWR4XSA9ICEobWF0Y2hlc1tpZHhdID0gbWF0Y2hlZFtpXSk7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICB9KSA6IGZ1bmN0aW9uIChlbGVtKSB7XG4gICAgICAgICAgICAgICAgcmV0dXJuIGZuKGVsZW0sIDAsIGFyZ3MpO1xuICAgICAgICAgICAgICB9O1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICByZXR1cm4gZm47XG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBwc2V1ZG9zOiB7XG4gICAgICAgICAgLy8gUG90ZW50aWFsbHkgY29tcGxleCBwc2V1ZG9zXG4gICAgICAgICAgXCJub3RcIjogbWFya0Z1bmN0aW9uKGZ1bmN0aW9uIChzZWxlY3Rvcikge1xuICAgICAgICAgICAgLy8gVHJpbSB0aGUgc2VsZWN0b3IgcGFzc2VkIHRvIGNvbXBpbGVcbiAgICAgICAgICAgIC8vIHRvIGF2b2lkIHRyZWF0aW5nIGxlYWRpbmcgYW5kIHRyYWlsaW5nXG4gICAgICAgICAgICAvLyBzcGFjZXMgYXMgY29tYmluYXRvcnNcbiAgICAgICAgICAgIHZhciBpbnB1dCA9IFtdLFxuICAgICAgICAgICAgICAgIHJlc3VsdHMgPSBbXSxcbiAgICAgICAgICAgICAgICBtYXRjaGVyID0gY29tcGlsZShzZWxlY3Rvci5yZXBsYWNlKHJ0cmltLCBcIiQxXCIpKTtcbiAgICAgICAgICAgIHJldHVybiBtYXRjaGVyW2V4cGFuZG9dID8gbWFya0Z1bmN0aW9uKGZ1bmN0aW9uIChzZWVkLCBtYXRjaGVzLCBjb250ZXh0LCB4bWwpIHtcbiAgICAgICAgICAgICAgdmFyIGVsZW0sXG4gICAgICAgICAgICAgICAgICB1bm1hdGNoZWQgPSBtYXRjaGVyKHNlZWQsIG51bGwsIHhtbCwgW10pLFxuICAgICAgICAgICAgICAgICAgaSA9IHNlZWQubGVuZ3RoOyAvLyBNYXRjaCBlbGVtZW50cyB1bm1hdGNoZWQgYnkgYG1hdGNoZXJgXG5cbiAgICAgICAgICAgICAgd2hpbGUgKGktLSkge1xuICAgICAgICAgICAgICAgIGlmIChlbGVtID0gdW5tYXRjaGVkW2ldKSB7XG4gICAgICAgICAgICAgICAgICBzZWVkW2ldID0gIShtYXRjaGVzW2ldID0gZWxlbSk7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9KSA6IGZ1bmN0aW9uIChlbGVtLCBjb250ZXh0LCB4bWwpIHtcbiAgICAgICAgICAgICAgaW5wdXRbMF0gPSBlbGVtO1xuICAgICAgICAgICAgICBtYXRjaGVyKGlucHV0LCBudWxsLCB4bWwsIHJlc3VsdHMpOyAvLyBEb24ndCBrZWVwIHRoZSBlbGVtZW50IChpc3N1ZSAjMjk5KVxuXG4gICAgICAgICAgICAgIGlucHV0WzBdID0gbnVsbDtcbiAgICAgICAgICAgICAgcmV0dXJuICFyZXN1bHRzLnBvcCgpO1xuICAgICAgICAgICAgfTtcbiAgICAgICAgICB9KSxcbiAgICAgICAgICBcImhhc1wiOiBtYXJrRnVuY3Rpb24oZnVuY3Rpb24gKHNlbGVjdG9yKSB7XG4gICAgICAgICAgICBpZiAodHlwZW9mIHNlbGVjdG9yID09PSBcInN0cmluZ1wiKSB7XG4gICAgICAgICAgICAgIFNpenpsZS5jb21waWxlKHNlbGVjdG9yKTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgcmV0dXJuIGZ1bmN0aW9uIChlbGVtKSB7XG4gICAgICAgICAgICAgIHJldHVybiBTaXp6bGUoc2VsZWN0b3IsIGVsZW0pLmxlbmd0aCA+IDA7XG4gICAgICAgICAgICB9O1xuICAgICAgICAgIH0pLFxuICAgICAgICAgIC8vIFJlbW92ZWQgOmNvbnRhaW5zIHBzZXVkby1jbGFzcyBkZWNsYXJhdGlvblxuICAgICAgICAgIC8vIFwiV2hldGhlciBhbiBlbGVtZW50IGlzIHJlcHJlc2VudGVkIGJ5IGEgOmxhbmcoKSBzZWxlY3RvclxuICAgICAgICAgIC8vIGlzIGJhc2VkIHNvbGVseSBvbiB0aGUgZWxlbWVudCdzIGxhbmd1YWdlIHZhbHVlXG4gICAgICAgICAgLy8gYmVpbmcgZXF1YWwgdG8gdGhlIGlkZW50aWZpZXIgQyxcbiAgICAgICAgICAvLyBvciBiZWdpbm5pbmcgd2l0aCB0aGUgaWRlbnRpZmllciBDIGltbWVkaWF0ZWx5IGZvbGxvd2VkIGJ5IFwiLVwiLlxuICAgICAgICAgIC8vIFRoZSBtYXRjaGluZyBvZiBDIGFnYWluc3QgdGhlIGVsZW1lbnQncyBsYW5ndWFnZSB2YWx1ZSBpcyBwZXJmb3JtZWQgY2FzZS1pbnNlbnNpdGl2ZWx5LlxuICAgICAgICAgIC8vIFRoZSBpZGVudGlmaWVyIEMgZG9lcyBub3QgaGF2ZSB0byBiZSBhIHZhbGlkIGxhbmd1YWdlIG5hbWUuXCJcbiAgICAgICAgICAvLyBodHRwOi8vd3d3LnczLm9yZy9UUi9zZWxlY3RvcnMvI2xhbmctcHNldWRvXG4gICAgICAgICAgXCJsYW5nXCI6IG1hcmtGdW5jdGlvbihmdW5jdGlvbiAobGFuZykge1xuICAgICAgICAgICAgLy8gbGFuZyB2YWx1ZSBtdXN0IGJlIGEgdmFsaWQgaWRlbnRpZmllclxuICAgICAgICAgICAgaWYgKCFyaWRlbnRpZmllci50ZXN0KGxhbmcgfHwgXCJcIikpIHtcbiAgICAgICAgICAgICAgU2l6emxlLmVycm9yKFwidW5zdXBwb3J0ZWQgbGFuZzogXCIgKyBsYW5nKTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgbGFuZyA9IGxhbmcucmVwbGFjZShydW5lc2NhcGUsIGZ1bmVzY2FwZSkudG9Mb3dlckNhc2UoKTtcbiAgICAgICAgICAgIHJldHVybiBmdW5jdGlvbiAoZWxlbSkge1xuICAgICAgICAgICAgICB2YXIgZWxlbUxhbmc7XG5cbiAgICAgICAgICAgICAgZG8ge1xuICAgICAgICAgICAgICAgIGlmIChlbGVtTGFuZyA9IGRvY3VtZW50SXNIVE1MID8gZWxlbS5sYW5nIDogZWxlbS5nZXRBdHRyaWJ1dGUoXCJ4bWw6bGFuZ1wiKSB8fCBlbGVtLmdldEF0dHJpYnV0ZShcImxhbmdcIikpIHtcbiAgICAgICAgICAgICAgICAgIGVsZW1MYW5nID0gZWxlbUxhbmcudG9Mb3dlckNhc2UoKTtcbiAgICAgICAgICAgICAgICAgIHJldHVybiBlbGVtTGFuZyA9PT0gbGFuZyB8fCBlbGVtTGFuZy5pbmRleE9mKGxhbmcgKyBcIi1cIikgPT09IDA7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICB9IHdoaWxlICgoZWxlbSA9IGVsZW0ucGFyZW50Tm9kZSkgJiYgZWxlbS5ub2RlVHlwZSA9PT0gMSk7XG5cbiAgICAgICAgICAgICAgcmV0dXJuIGZhbHNlO1xuICAgICAgICAgICAgfTtcbiAgICAgICAgICB9KSxcbiAgICAgICAgICAvLyBNaXNjZWxsYW5lb3VzXG4gICAgICAgICAgXCJ0YXJnZXRcIjogZnVuY3Rpb24gdGFyZ2V0KGVsZW0pIHtcbiAgICAgICAgICAgIHZhciBoYXNoID0gd2luZG93LmxvY2F0aW9uICYmIHdpbmRvdy5sb2NhdGlvbi5oYXNoO1xuICAgICAgICAgICAgcmV0dXJuIGhhc2ggJiYgaGFzaC5zbGljZSgxKSA9PT0gZWxlbS5pZDtcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicm9vdFwiOiBmdW5jdGlvbiByb290KGVsZW0pIHtcbiAgICAgICAgICAgIHJldHVybiBlbGVtID09PSBkb2NFbGVtO1xuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJmb2N1c1wiOiBmdW5jdGlvbiBmb2N1cyhlbGVtKSB7XG4gICAgICAgICAgICByZXR1cm4gZWxlbSA9PT0gZG9jdW1lbnQuYWN0aXZlRWxlbWVudCAmJiAoIWRvY3VtZW50Lmhhc0ZvY3VzIHx8IGRvY3VtZW50Lmhhc0ZvY3VzKCkpICYmICEhKGVsZW0udHlwZSB8fCBlbGVtLmhyZWYgfHwgfmVsZW0udGFiSW5kZXgpO1xuICAgICAgICAgIH0sXG4gICAgICAgICAgLy8gQm9vbGVhbiBwcm9wZXJ0aWVzXG4gICAgICAgICAgXCJlbmFibGVkXCI6IGNyZWF0ZURpc2FibGVkUHNldWRvKGZhbHNlKSxcbiAgICAgICAgICBcImRpc2FibGVkXCI6IGNyZWF0ZURpc2FibGVkUHNldWRvKHRydWUpLFxuICAgICAgICAgIFwiY2hlY2tlZFwiOiBmdW5jdGlvbiBjaGVja2VkKGVsZW0pIHtcbiAgICAgICAgICAgIC8vIEluIENTUzMsIDpjaGVja2VkIHNob3VsZCByZXR1cm4gYm90aCBjaGVja2VkIGFuZCBzZWxlY3RlZCBlbGVtZW50c1xuICAgICAgICAgICAgLy8gaHR0cDovL3d3dy53My5vcmcvVFIvMjAxMS9SRUMtY3NzMy1zZWxlY3RvcnMtMjAxMTA5MjkvI2NoZWNrZWRcbiAgICAgICAgICAgIHZhciBub2RlTmFtZSA9IGVsZW0ubm9kZU5hbWUudG9Mb3dlckNhc2UoKTtcbiAgICAgICAgICAgIHJldHVybiBub2RlTmFtZSA9PT0gXCJpbnB1dFwiICYmICEhZWxlbS5jaGVja2VkIHx8IG5vZGVOYW1lID09PSBcIm9wdGlvblwiICYmICEhZWxlbS5zZWxlY3RlZDtcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2VsZWN0ZWRcIjogZnVuY3Rpb24gc2VsZWN0ZWQoZWxlbSkge1xuICAgICAgICAgICAgLy8gQWNjZXNzaW5nIHRoaXMgcHJvcGVydHkgbWFrZXMgc2VsZWN0ZWQtYnktZGVmYXVsdFxuICAgICAgICAgICAgLy8gb3B0aW9ucyBpbiBTYWZhcmkgd29yayBwcm9wZXJseVxuICAgICAgICAgICAgaWYgKGVsZW0ucGFyZW50Tm9kZSkge1xuICAgICAgICAgICAgICBlbGVtLnBhcmVudE5vZGUuc2VsZWN0ZWRJbmRleDtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgcmV0dXJuIGVsZW0uc2VsZWN0ZWQgPT09IHRydWU7XG4gICAgICAgICAgfSxcbiAgICAgICAgICAvLyBDb250ZW50c1xuICAgICAgICAgIFwiZW1wdHlcIjogZnVuY3Rpb24gZW1wdHkoZWxlbSkge1xuICAgICAgICAgICAgLy8gaHR0cDovL3d3dy53My5vcmcvVFIvc2VsZWN0b3JzLyNlbXB0eS1wc2V1ZG9cbiAgICAgICAgICAgIC8vIDplbXB0eSBpcyBuZWdhdGVkIGJ5IGVsZW1lbnQgKDEpIG9yIGNvbnRlbnQgbm9kZXMgKHRleHQ6IDM7IGNkYXRhOiA0OyBlbnRpdHkgcmVmOiA1KSxcbiAgICAgICAgICAgIC8vICAgYnV0IG5vdCBieSBvdGhlcnMgKGNvbW1lbnQ6IDg7IHByb2Nlc3NpbmcgaW5zdHJ1Y3Rpb246IDc7IGV0Yy4pXG4gICAgICAgICAgICAvLyBub2RlVHlwZSA8IDYgd29ya3MgYmVjYXVzZSBhdHRyaWJ1dGVzICgyKSBkbyBub3QgYXBwZWFyIGFzIGNoaWxkcmVuXG4gICAgICAgICAgICBmb3IgKGVsZW0gPSBlbGVtLmZpcnN0Q2hpbGQ7IGVsZW07IGVsZW0gPSBlbGVtLm5leHRTaWJsaW5nKSB7XG4gICAgICAgICAgICAgIGlmIChlbGVtLm5vZGVUeXBlIDwgNikge1xuICAgICAgICAgICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICByZXR1cm4gdHJ1ZTtcbiAgICAgICAgICB9IC8vIFJlbW92ZWQgY3VzdG9tIHBzZXVkby1jbGFzc2VzXG5cbiAgICAgICAgfVxuICAgICAgfTsgLy8gUmVtb3ZlZCBjdXN0b20gcHNldWRvLWNsYXNzZXNcbiAgICAgIC8vIEVhc3kgQVBJIGZvciBjcmVhdGluZyBuZXcgc2V0RmlsdGVyc1xuXG4gICAgICBmdW5jdGlvbiBzZXRGaWx0ZXJzKCkge31cblxuICAgICAgc2V0RmlsdGVycy5wcm90b3R5cGUgPSBFeHByLmZpbHRlcnMgPSBFeHByLnBzZXVkb3M7XG4gICAgICBFeHByLnNldEZpbHRlcnMgPSBuZXcgc2V0RmlsdGVycygpO1xuICAgICAgLyoqXG4gICAgICAgKiBbQWRHdWFyZCBQYXRjaF06XG4gICAgICAgKiBTb3J0cyB0aGUgdG9rZW5zIGluIG9yZGVyIHRvIG1pdGlnYXRlIHRoZSBwZXJmb3JtYW5jZSBpc3N1ZXMgY2F1c2VkIGJ5IG1hdGNoaW5nIHNsb3cgcHNldWRvcyBmaXJzdDpcbiAgICAgICAqIGh0dHBzOi8vZ2l0aHViLmNvbS9BZGd1YXJkVGVhbS9FeHRlbmRlZENzcy9pc3N1ZXMvNTUjaXNzdWVjb21tZW50LTM2NDA1ODc0NVxuICAgICAgICovXG5cbiAgICAgIHZhciBzb3J0VG9rZW5Hcm91cHMgPSBmdW5jdGlvbiAoKSB7XG4gICAgICAgIC8qKlxuICAgICAgICAgKiBTcGxpdHMgY29tcG91bmQgc2VsZWN0b3IgaW50byBhIGxpc3Qgb2Ygc2ltcGxlIHNlbGVjdG9yc1xuICAgICAgICAgKlxuICAgICAgICAgKiBAcGFyYW0geyp9IHRva2VucyBUb2tlbnMgdG8gc3BsaXQgaW50byBncm91cHNcbiAgICAgICAgICogQHJldHVybnMgYW4gYXJyYXkgY29uc2lzdGluZyBvZiB0b2tlbiBncm91cHMgKGFycmF5cykgYW5kIHJlbGF0aW9uIHRva2Vucy5cbiAgICAgICAgICovXG4gICAgICAgIHZhciBzcGxpdENvbXBvdW5kU2VsZWN0b3IgPSBmdW5jdGlvbiBzcGxpdENvbXBvdW5kU2VsZWN0b3IodG9rZW5zKSB7XG4gICAgICAgICAgdmFyIGdyb3VwcyA9IFtdO1xuICAgICAgICAgIHZhciBjdXJyZW50VG9rZW5zR3JvdXAgPSBbXTtcbiAgICAgICAgICB2YXIgbWF4SWR4ID0gdG9rZW5zLmxlbmd0aCAtIDE7XG5cbiAgICAgICAgICBmb3IgKHZhciBpID0gMDsgaSA8PSBtYXhJZHg7IGkrKykge1xuICAgICAgICAgICAgdmFyIHRva2VuID0gdG9rZW5zW2ldO1xuICAgICAgICAgICAgdmFyIHJlbGF0aXZlID0gU2l6emxlLnNlbGVjdG9ycy5yZWxhdGl2ZVt0b2tlbi50eXBlXTtcblxuICAgICAgICAgICAgaWYgKHJlbGF0aXZlKSB7XG4gICAgICAgICAgICAgIGdyb3Vwcy5wdXNoKGN1cnJlbnRUb2tlbnNHcm91cCk7XG4gICAgICAgICAgICAgIGdyb3Vwcy5wdXNoKHRva2VuKTtcbiAgICAgICAgICAgICAgY3VycmVudFRva2Vuc0dyb3VwID0gW107XG4gICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICBjdXJyZW50VG9rZW5zR3JvdXAucHVzaCh0b2tlbik7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIGlmIChpID09PSBtYXhJZHgpIHtcbiAgICAgICAgICAgICAgZ3JvdXBzLnB1c2goY3VycmVudFRva2Vuc0dyb3VwKTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9XG5cbiAgICAgICAgICByZXR1cm4gZ3JvdXBzO1xuICAgICAgICB9O1xuXG4gICAgICAgIHZhciBUT0tFTl9UWVBFU19WQUxVRVMgPSB7XG4gICAgICAgICAgLy8gbnRoLWNoaWxkLCBldGMsIGFsd2F5cyBnbyBsYXN0XG4gICAgICAgICAgXCJDSElMRFwiOiAxMDAsXG4gICAgICAgICAgXCJJRFwiOiA5MCxcbiAgICAgICAgICBcIkNMQVNTXCI6IDgwLFxuICAgICAgICAgIFwiVEFHXCI6IDcwLFxuICAgICAgICAgIFwiQVRUUlwiOiA3MCxcbiAgICAgICAgICBcIlBTRVVET1wiOiA2MFxuICAgICAgICB9O1xuICAgICAgICB2YXIgUE9TSVRJT05BTF9QU0VVRE9TID0gW1wibnRoXCIsIFwiZmlyc3RcIiwgXCJsYXN0XCIsIFwiZXFcIiwgXCJldmVuXCIsIFwib2RkXCIsIFwibHRcIiwgXCJndFwiLCBcIm5vdFwiXTtcbiAgICAgICAgLyoqXG4gICAgICAgICAqIEEgZnVuY3Rpb24gdGhhdCBkZWZpbmVzIHRoZSBzb3J0IG9yZGVyLlxuICAgICAgICAgKiBSZXR1cm5zIGEgdmFsdWUgbGVzc2VyIHRoYW4gMCBpZiBcImxlZnRcIiBpcyBsZXNzIHRoYW4gXCJyaWdodFwiLlxuICAgICAgICAgKi9cblxuICAgICAgICB2YXIgY29tcGFyZUZ1bmN0aW9uID0gZnVuY3Rpb24gY29tcGFyZUZ1bmN0aW9uKGxlZnQsIHJpZ2h0KSB7XG4gICAgICAgICAgdmFyIGxlZnRWYWx1ZSA9IFRPS0VOX1RZUEVTX1ZBTFVFU1tsZWZ0LnR5cGVdO1xuICAgICAgICAgIHZhciByaWdodFZhbHVlID0gVE9LRU5fVFlQRVNfVkFMVUVTW3JpZ2h0LnR5cGVdO1xuICAgICAgICAgIHJldHVybiBsZWZ0VmFsdWUgLSByaWdodFZhbHVlO1xuICAgICAgICB9O1xuICAgICAgICAvKipcbiAgICAgICAgICogQ2hlY2tzIGlmIHRoZSBzcGVjaWZpZWQgdG9rZW5zIGdyb3VwIGlzIHNvcnRhYmxlLlxuICAgICAgICAgKiBXZSBkbyBub3QgcmUtc29ydCB0b2tlbnMgaW4gY2FzZSBvZiBhbnkgcG9zaXRpb25hbCBvciBjaGlsZCBwc2V1ZG9zIGluIHRoZSBncm91cFxuICAgICAgICAgKi9cblxuXG4gICAgICAgIHZhciBpc1NvcnRhYmxlID0gZnVuY3Rpb24gaXNTb3J0YWJsZSh0b2tlbnMpIHtcbiAgICAgICAgICB2YXIgaVRva2VucyA9IHRva2Vucy5sZW5ndGg7XG5cbiAgICAgICAgICB3aGlsZSAoaVRva2Vucy0tKSB7XG4gICAgICAgICAgICB2YXIgdG9rZW4gPSB0b2tlbnNbaVRva2Vuc107XG5cbiAgICAgICAgICAgIGlmICh0b2tlbi50eXBlID09PSBcIlBTRVVET1wiICYmIFBPU0lUSU9OQUxfUFNFVURPUy5pbmRleE9mKHRva2VuLm1hdGNoZXNbMF0pICE9PSAtMSkge1xuICAgICAgICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIGlmICh0b2tlbi50eXBlID09PSBcIkNISUxEXCIpIHtcbiAgICAgICAgICAgICAgcmV0dXJuIGZhbHNlO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cblxuICAgICAgICAgIHJldHVybiB0cnVlO1xuICAgICAgICB9O1xuICAgICAgICAvKipcbiAgICAgICAgICogU29ydHMgdGhlIHRva2VucyBpbiBvcmRlciB0byBtaXRpZ2F0ZSB0aGUgaXNzdWVzIGNhdXNlZCBieSB0aGUgbGVmdC10by1yaWdodCBtYXRjaGluZy5cbiAgICAgICAgICogVGhlIGlkZWEgaXMgY2hhbmdlIHRoZSB0b2tlbnMgb3JkZXIgc28gdGhhdCBTaXp6bGUgd2FzIG1hdGNoaW5nIGZhc3Qgc2VsZWN0b3JzIGZpcnN0IChpZCwgY2xhc3MpLFxuICAgICAgICAgKiBhbmQgc2xvdyBzZWxlY3RvcnMgYWZ0ZXIgdGhhdCAoYW5kIGhlcmUgSSBtZWFuIG91ciBzbG93IGN1c3RvbSBwc2V1ZG8gY2xhc3NlcykuXG4gICAgICAgICAqXG4gICAgICAgICAqIEBwYXJhbSB7QXJyYXl9IHRva2VucyBBbiBhcnJheSBvZiB0b2tlbnMgdG8gc29ydFxuICAgICAgICAgKiBAcmV0dXJucyB7QXJyYXl9IEEgbmV3IHJlLXNvcnRlZCBhcnJheVxuICAgICAgICAgKi9cblxuXG4gICAgICAgIHZhciBzb3J0VG9rZW5zID0gZnVuY3Rpb24gc29ydFRva2Vucyh0b2tlbnMpIHtcbiAgICAgICAgICBpZiAoIXRva2VucyB8fCB0b2tlbnMubGVuZ3RoID09PSAxKSB7XG4gICAgICAgICAgICByZXR1cm4gdG9rZW5zO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIHZhciBzb3J0ZWRUb2tlbnMgPSBbXTtcbiAgICAgICAgICB2YXIgZ3JvdXBzID0gc3BsaXRDb21wb3VuZFNlbGVjdG9yKHRva2Vucyk7XG5cbiAgICAgICAgICBmb3IgKHZhciBpID0gMDsgaSA8IGdyb3Vwcy5sZW5ndGg7IGkrKykge1xuICAgICAgICAgICAgdmFyIGdyb3VwID0gZ3JvdXBzW2ldO1xuXG4gICAgICAgICAgICBpZiAoZ3JvdXAgaW5zdGFuY2VvZiBBcnJheSkge1xuICAgICAgICAgICAgICBpZiAoaXNTb3J0YWJsZShncm91cCkpIHtcbiAgICAgICAgICAgICAgICBncm91cC5zb3J0KGNvbXBhcmVGdW5jdGlvbik7XG4gICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICBzb3J0ZWRUb2tlbnMgPSBzb3J0ZWRUb2tlbnMuY29uY2F0KGdyb3VwKTtcbiAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgIHNvcnRlZFRva2Vucy5wdXNoKGdyb3VwKTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9XG5cbiAgICAgICAgICByZXR1cm4gc29ydGVkVG9rZW5zO1xuICAgICAgICB9O1xuICAgICAgICAvKipcbiAgICAgICAgICogU29ydHMgZXZlcnkgdG9rZW5zIGFycmF5IGluc2lkZSBvZiB0aGUgc3BlY2lmaWVkIFwiZ3JvdXBzXCIgYXJyYXkuXG4gICAgICAgICAqIFNlZSBcInNvcnRUb2tlbnNcIiBtZXRob2RzIGZvciBtb3JlIGluZm9ybWF0aW9uIG9uIGhvdyB0b2tlbnMgYXJlIHNvcnRlZC5cbiAgICAgICAgICpcbiAgICAgICAgICogQHBhcmFtIHtBcnJheX0gZ3JvdXBzIEFuIGFycmF5IG9mIHRva2VucyBhcnJheXMuXG4gICAgICAgICAqIEByZXR1cm5zIHtBcnJheX0gQSBuZXcgYXJyYXkgdGhhdCBjb25zaXN0cyBvZiB0aGUgc2FtZSB0b2tlbnMgYXJyYXlzIGFmdGVyIHNvcnRpbmdcbiAgICAgICAgICovXG5cblxuICAgICAgICB2YXIgc29ydFRva2VuR3JvdXBzID0gZnVuY3Rpb24gc29ydFRva2VuR3JvdXBzKGdyb3Vwcykge1xuICAgICAgICAgIHZhciBzb3J0ZWRHcm91cHMgPSBbXTtcbiAgICAgICAgICB2YXIgbGVuID0gZ3JvdXBzLmxlbmd0aDtcbiAgICAgICAgICB2YXIgaSA9IDA7XG5cbiAgICAgICAgICBmb3IgKDsgaSA8IGxlbjsgaSsrKSB7XG4gICAgICAgICAgICBzb3J0ZWRHcm91cHMucHVzaChzb3J0VG9rZW5zKGdyb3Vwc1tpXSkpO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIHJldHVybiBzb3J0ZWRHcm91cHM7XG4gICAgICAgIH07IC8vIEV4cG9zZVxuXG5cbiAgICAgICAgcmV0dXJuIHNvcnRUb2tlbkdyb3VwcztcbiAgICAgIH0oKTtcbiAgICAgIC8qKlxuICAgICAgICogQ3JlYXRlcyBjdXN0b20gcG9saWN5IHRvIHVzZSBUcnVzdGVkVHlwZXMgQ1NQIHBvbGljeVxuICAgICAgICogaHR0cHM6Ly93M2MuZ2l0aHViLmlvL3dlYmFwcHNlYy10cnVzdGVkLXR5cGVzL2Rpc3Qvc3BlYy9cbiAgICAgICAqL1xuXG5cbiAgICAgIHZhciBBR1BvbGljeSA9IGZ1bmN0aW9uIGNyZWF0ZVBvbGljeSgpIHtcbiAgICAgICAgdmFyIGRlZmF1bHRQb2xpY3kgPSB7XG4gICAgICAgICAgY3JlYXRlSFRNTDogZnVuY3Rpb24gY3JlYXRlSFRNTChpbnB1dCkge1xuICAgICAgICAgICAgcmV0dXJuIGlucHV0O1xuICAgICAgICAgIH0sXG4gICAgICAgICAgY3JlYXRlU2NyaXB0OiBmdW5jdGlvbiBjcmVhdGVTY3JpcHQoaW5wdXQpIHtcbiAgICAgICAgICAgIHJldHVybiBpbnB1dDtcbiAgICAgICAgICB9LFxuICAgICAgICAgIGNyZWF0ZVNjcmlwdFVSTDogZnVuY3Rpb24gY3JlYXRlU2NyaXB0VVJMKGlucHV0KSB7XG4gICAgICAgICAgICByZXR1cm4gaW5wdXQ7XG4gICAgICAgICAgfVxuICAgICAgICB9O1xuXG4gICAgICAgIGlmICh3aW5kb3cudHJ1c3RlZFR5cGVzICYmIHdpbmRvdy50cnVzdGVkVHlwZXMuY3JlYXRlUG9saWN5KSB7XG4gICAgICAgICAgcmV0dXJuIHdpbmRvdy50cnVzdGVkVHlwZXMuY3JlYXRlUG9saWN5KFwiQUdQb2xpY3lcIiwgZGVmYXVsdFBvbGljeSk7XG4gICAgICAgIH1cblxuICAgICAgICByZXR1cm4gZGVmYXVsdFBvbGljeTtcbiAgICAgIH0oKTtcbiAgICAgIC8qKlxuICAgICAgICogW0FkR3VhcmQgUGF0Y2hdOlxuICAgICAgICogUmVtb3ZlcyB0cmFpbGluZyBzcGFjZXMgZnJvbSB0aGUgdG9rZW5zIGxpc3RcbiAgICAgICAqXG4gICAgICAgKiBAcGFyYW0geyp9IHRva2VucyBBbiBhcnJheSBvZiBTaXp6bGUgdG9rZW5zIHRvIHBvc3QtcHJvY2Vzc1xuICAgICAgICovXG5cblxuICAgICAgZnVuY3Rpb24gcmVtb3ZlVHJhaWxpbmdTcGFjZXModG9rZW5zKSB7XG4gICAgICAgIHZhciBpVG9rZW5zID0gdG9rZW5zLmxlbmd0aDtcblxuICAgICAgICB3aGlsZSAoaVRva2Vucy0tKSB7XG4gICAgICAgICAgdmFyIHRva2VuID0gdG9rZW5zW2lUb2tlbnNdO1xuXG4gICAgICAgICAgaWYgKHRva2VuLnR5cGUgPT09IFwiIFwiKSB7XG4gICAgICAgICAgICB0b2tlbnMubGVuZ3RoID0gaVRva2VucztcbiAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgYnJlYWs7XG4gICAgICAgICAgfVxuICAgICAgICB9XG4gICAgICB9XG4gICAgICAvKipcbiAgICAgICAqIFtBZEd1YXJkIFBhdGNoXTpcbiAgICAgICAqIEFuIG9iamVjdCB3aXRoIHRoZSBpbmZvcm1hdGlvbiBhYm91dCBzZWxlY3RvcnMgYW5kIHRoZWlyIHRva2VuIHJlcHJlc2VudGF0aW9uXG4gICAgICAgKiBAdHlwZWRlZiB7e3NlbGVjdG9yVGV4dDogc3RyaW5nLCBncm91cHM6IEFycmF5fX0gU2VsZWN0b3JEYXRhXG4gICAgICAgKiBAcHJvcGVydHkge3N0cmluZ30gc2VsZWN0b3JUZXh0IEEgQ1NTIHNlbGVjdG9yIHRleHRcbiAgICAgICAqIEBwcm9wZXJ0eSB7QXJyYXl9IGdyb3VwcyBBbiBhcnJheSBvZiB0b2tlbiBncm91cHMgY29ycmVzcG9uZGluZyB0byB0aGF0IHNlbGVjdG9yXG4gICAgICAgKi9cblxuICAgICAgLyoqXG4gICAgICAgKiBbQWRHdWFyZCBQYXRjaF06XG4gICAgICAgKiBUaGlzIG1ldGhvZCBwcm9jZXNzZXMgcGFyc2VkIHRva2VuIGdyb3VwcywgZGl2aWRlcyB0aGVtIGludG8gYSBudW1iZXIgb2Ygc2VsZWN0b3JzXG4gICAgICAgKiBhbmQgbWFrZXMgc3VyZSB0aGF0IGVhY2ggc2VsZWN0b3IncyB0b2tlbnMgYXJlIGNhY2hlZCBwcm9wZXJseSBpbiBTaXp6bGUuXG4gICAgICAgKlxuICAgICAgICogQHBhcmFtIHsqfSBncm91cHMgVG9rZW4gZ3JvdXBzIChzZWUge0BsaW5rIFNpenpsZS50b2tlbml6ZX0pXG4gICAgICAgKiBAcmV0dXJucyB7QXJyYXkuPFNlbGVjdG9yRGF0YT59IEFuIGFycmF5IG9mIHNlbGVjdG9ycyBkYXRhIHdlIGdvdCBmcm9tIHRoZSBncm91cHNcbiAgICAgICAqL1xuXG5cbiAgICAgIGZ1bmN0aW9uIHRva2VuR3JvdXBzVG9TZWxlY3RvcnMoZ3JvdXBzKSB7XG4gICAgICAgIC8vIFJlbW92ZSB0cmFpbGluZyBzcGFjZXMgd2hpY2ggd2UgY2FuIGVuY291bnRlciBpbiB0b2xlcmFudCBtb2RlXG4gICAgICAgIC8vIFdlJ3JlIGRvaW5nIGl0IGluIHRvbGVyYW50IG1vZGUgb25seSBhcyB0aGlzIGlzIHRoZSBvbmx5IGNhc2Ugd2hlblxuICAgICAgICAvLyBlbmNvdW50ZXJpbmcgdHJhaWxpbmcgc3BhY2VzIGlzIGV4cGVjdGVkXG4gICAgICAgIHJlbW92ZVRyYWlsaW5nU3BhY2VzKGdyb3Vwc1tncm91cHMubGVuZ3RoIC0gMV0pOyAvLyBXZSBuZWVkIHNvcnRlZCB0b2tlbnMgdG8gbWFrZSBjYWNoZSB3b3JrIHByb3Blcmx5XG5cbiAgICAgICAgdmFyIHNvcnRlZEdyb3VwcyA9IHNvcnRUb2tlbkdyb3Vwcyhncm91cHMpO1xuICAgICAgICB2YXIgc2VsZWN0b3JzID0gW107XG5cbiAgICAgICAgZm9yICh2YXIgaSA9IDA7IGkgPCBncm91cHMubGVuZ3RoOyBpKyspIHtcbiAgICAgICAgICB2YXIgdG9rZW5Hcm91cHMgPSBncm91cHNbaV07XG4gICAgICAgICAgdmFyIHNlbGVjdG9yVGV4dCA9IHRvU2VsZWN0b3IodG9rZW5Hcm91cHMpO1xuICAgICAgICAgIHNlbGVjdG9ycy5wdXNoKHtcbiAgICAgICAgICAgIC8vIFNpenpsZSBleHBlY3RzIGFuIGFycmF5IG9mIHRva2VuIGdyb3VwcyB3aGVuIGNvbXBpbGluZyBhIHNlbGVjdG9yXG4gICAgICAgICAgICBncm91cHM6IFt0b2tlbkdyb3Vwc10sXG4gICAgICAgICAgICBzZWxlY3RvclRleHQ6IHNlbGVjdG9yVGV4dFxuICAgICAgICAgIH0pOyAvLyBOb3cgbWFrZSBzdXJlIHRoYXQgc2VsZWN0b3IgdG9rZW5zIGFyZSBjYWNoZWRcblxuICAgICAgICAgIHZhciB0b2tlbnNDYWNoZUl0ZW0gPSB7XG4gICAgICAgICAgICBncm91cHM6IHRva2VuR3JvdXBzLFxuICAgICAgICAgICAgc29ydGVkR3JvdXBzOiBbc29ydGVkR3JvdXBzW2ldXVxuICAgICAgICAgIH07XG4gICAgICAgICAgdG9rZW5DYWNoZShzZWxlY3RvclRleHQsIHRva2Vuc0NhY2hlSXRlbSk7XG4gICAgICAgIH1cblxuICAgICAgICByZXR1cm4gc2VsZWN0b3JzO1xuICAgICAgfVxuICAgICAgLyoqXG4gICAgICAgKiBbQWRHdWFyZCBQYXRjaF06XG4gICAgICAgKiBBZGQgYW4gYWRkaXRpb25hbCBhcmd1bWVudCBmb3IgU2l6emxlLnRva2VuaXplIHdoaWNoIGluZGljYXRlcyB0aGF0IGl0XG4gICAgICAgKiBzaG91bGQgbm90IHRocm93IG9uIGludmFsaWQgdG9rZW5zLCBhbmQgaW5zdGVhZCBzaG91bGQgcmV0dXJuIHRva2Vuc1xuICAgICAgICogdGhhdCBpdCBoYXMgcHJvZHVjZWQgc28gZmFyLlxuICAgICAgICpcbiAgICAgICAqIE9uZSBtb3JlIGFkZGl0aW9uYWwgYXJndW1lbnQgdGhhdCBhbGxvdyB0byBjaG9vc2UgaWYgeW91IHdhbnQgdG8gcmVjZWl2ZSBzb3J0ZWQgb3IgdW5zb3J0ZWQgdG9rZW5zXG4gICAgICAgKiBUaGUgcHJvYmxlbSBpcyB0aGF0IHRoZSByZS1zb3J0ZWQgc2VsZWN0b3JzIGFyZSB2YWxpZCBmb3IgU2l6emxlLCBidXQgbm90IGZvciB0aGUgYnJvd3Nlci5cbiAgICAgICAqIG9wdGlvbnMucmV0dXJuVW5zb3J0ZWQgLS0gcmV0dXJuIHVuc29ydGVkIHRva2VucyBpZiB0cnVlLlxuICAgICAgICogb3B0aW9ucy5jYWNoZU9ubHkgLS0gcmV0dXJuIGNhY2hlZCByZXN1bHQgb25seS4gUmVxdWlyZWQgZm9yIHVuaXQtdGVzdHMuXG4gICAgICAgKlxuICAgICAgICogQHBhcmFtIHsqfSBvcHRpb25zIE9wdGlvbmFsIGNvbmZpZ3VyYXRpb24gb2JqZWN0IHdpdGggdHdvIGFkZGl0aW9uYWwgZmxhZ3NcbiAgICAgICAqIChvcHRpb25zLnRvbGVyYW50LCBvcHRpb25zLnJldHVyblVuc29ydGVkLCBvcHRpb25zLmNhY2hlT25seSkgLS0gc2VlIHBhdGNoZXMgIzUgYW5kICM2IG5vdGVzXG4gICAgICAgKi9cblxuXG4gICAgICB0b2tlbml6ZSA9IFNpenpsZS50b2tlbml6ZSA9IGZ1bmN0aW9uIChzZWxlY3RvciwgcGFyc2VPbmx5LCBvcHRpb25zKSB7XG4gICAgICAgIHZhciBtYXRjaGVkLFxuICAgICAgICAgICAgbWF0Y2gsXG4gICAgICAgICAgICB0b2tlbnMsXG4gICAgICAgICAgICB0eXBlLFxuICAgICAgICAgICAgc29GYXIsXG4gICAgICAgICAgICBncm91cHMsXG4gICAgICAgICAgICBwcmVGaWx0ZXJzLFxuICAgICAgICAgICAgY2FjaGVkID0gdG9rZW5DYWNoZVtzZWxlY3RvciArIFwiIFwiXTtcbiAgICAgICAgdmFyIHRvbGVyYW50ID0gb3B0aW9ucyAmJiBvcHRpb25zLnRvbGVyYW50O1xuICAgICAgICB2YXIgcmV0dXJuVW5zb3J0ZWQgPSBvcHRpb25zICYmIG9wdGlvbnMucmV0dXJuVW5zb3J0ZWQ7XG4gICAgICAgIHZhciBjYWNoZU9ubHkgPSBvcHRpb25zICYmIG9wdGlvbnMuY2FjaGVPbmx5O1xuXG4gICAgICAgIGlmIChjYWNoZWQpIHtcbiAgICAgICAgICBpZiAocGFyc2VPbmx5KSB7XG4gICAgICAgICAgICByZXR1cm4gMDtcbiAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgcmV0dXJuIChyZXR1cm5VbnNvcnRlZCA/IGNhY2hlZC5ncm91cHMgOiBjYWNoZWQuc29ydGVkR3JvdXBzKS5zbGljZSgwKTtcbiAgICAgICAgICB9XG4gICAgICAgIH1cblxuICAgICAgICBpZiAoY2FjaGVPbmx5KSB7XG4gICAgICAgICAgcmV0dXJuIG51bGw7XG4gICAgICAgIH1cblxuICAgICAgICBzb0ZhciA9IHNlbGVjdG9yO1xuICAgICAgICBncm91cHMgPSBbXTtcbiAgICAgICAgcHJlRmlsdGVycyA9IEV4cHIucHJlRmlsdGVyO1xuXG4gICAgICAgIHdoaWxlIChzb0Zhcikge1xuICAgICAgICAgIC8vIENvbW1hIGFuZCBmaXJzdCBydW5cbiAgICAgICAgICBpZiAoIW1hdGNoZWQgfHwgKG1hdGNoID0gcmNvbW1hLmV4ZWMoc29GYXIpKSkge1xuICAgICAgICAgICAgaWYgKG1hdGNoKSB7XG4gICAgICAgICAgICAgIC8vIERvbid0IGNvbnN1bWUgdHJhaWxpbmcgY29tbWFzIGFzIHZhbGlkXG4gICAgICAgICAgICAgIHNvRmFyID0gc29GYXIuc2xpY2UobWF0Y2hbMF0ubGVuZ3RoKSB8fCBzb0ZhcjtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgZ3JvdXBzLnB1c2godG9rZW5zID0gW10pO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIG1hdGNoZWQgPSBmYWxzZTsgLy8gQ29tYmluYXRvcnNcblxuICAgICAgICAgIGlmIChtYXRjaCA9IHJjb21iaW5hdG9ycy5leGVjKHNvRmFyKSkge1xuICAgICAgICAgICAgbWF0Y2hlZCA9IG1hdGNoLnNoaWZ0KCk7XG4gICAgICAgICAgICB0b2tlbnMucHVzaCh7XG4gICAgICAgICAgICAgIHZhbHVlOiBtYXRjaGVkLFxuICAgICAgICAgICAgICAvLyBDYXN0IGRlc2NlbmRhbnQgY29tYmluYXRvcnMgdG8gc3BhY2VcbiAgICAgICAgICAgICAgdHlwZTogbWF0Y2hbMF0ucmVwbGFjZShydHJpbSwgXCIgXCIpXG4gICAgICAgICAgICB9KTtcbiAgICAgICAgICAgIHNvRmFyID0gc29GYXIuc2xpY2UobWF0Y2hlZC5sZW5ndGgpO1xuICAgICAgICAgIH0gLy8gRmlsdGVyc1xuXG5cbiAgICAgICAgICBmb3IgKHR5cGUgaW4gRXhwci5maWx0ZXIpIHtcbiAgICAgICAgICAgIGlmICgobWF0Y2ggPSBtYXRjaEV4cHJbdHlwZV0uZXhlYyhzb0ZhcikpICYmICghcHJlRmlsdGVyc1t0eXBlXSB8fCAobWF0Y2ggPSBwcmVGaWx0ZXJzW3R5cGVdKG1hdGNoKSkpKSB7XG4gICAgICAgICAgICAgIG1hdGNoZWQgPSBtYXRjaC5zaGlmdCgpO1xuICAgICAgICAgICAgICB0b2tlbnMucHVzaCh7XG4gICAgICAgICAgICAgICAgdmFsdWU6IG1hdGNoZWQsXG4gICAgICAgICAgICAgICAgdHlwZTogdHlwZSxcbiAgICAgICAgICAgICAgICBtYXRjaGVzOiBtYXRjaFxuICAgICAgICAgICAgICB9KTtcbiAgICAgICAgICAgICAgc29GYXIgPSBzb0Zhci5zbGljZShtYXRjaGVkLmxlbmd0aCk7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgaWYgKCFtYXRjaGVkKSB7XG4gICAgICAgICAgICBicmVhaztcbiAgICAgICAgICB9XG4gICAgICAgIH0gLy8gUmV0dXJuIHRoZSBsZW5ndGggb2YgdGhlIGludmFsaWQgZXhjZXNzXG4gICAgICAgIC8vIGlmIHdlJ3JlIGp1c3QgcGFyc2luZ1xuICAgICAgICAvLyBPdGhlcndpc2UsIHRocm93IGFuIGVycm9yIG9yIHJldHVybiB0b2tlbnNcblxuXG4gICAgICAgIHZhciBpbnZhbGlkTGVuID0gc29GYXIubGVuZ3RoO1xuXG4gICAgICAgIGlmIChwYXJzZU9ubHkpIHtcbiAgICAgICAgICByZXR1cm4gaW52YWxpZExlbjtcbiAgICAgICAgfVxuXG4gICAgICAgIGlmIChpbnZhbGlkTGVuICE9PSAwICYmICF0b2xlcmFudCkge1xuICAgICAgICAgIFNpenpsZS5lcnJvcihzZWxlY3Rvcik7IC8vIFRocm93cyBhbiBlcnJvci5cbiAgICAgICAgfVxuXG4gICAgICAgIGlmICh0b2xlcmFudCkge1xuICAgICAgICAgIC8qKlxuICAgICAgICAgICAqIFtBZEd1YXJkIFBhdGNoXTpcbiAgICAgICAgICAgKiBJbiB0b2xlcmFudCBtb2RlIHdlIHJldHVybiBhIHNwZWNpYWwgb2JqZWN0IHRoYXQgY29uc3Rpc3RzIG9mXG4gICAgICAgICAgICogYW4gYXJyYXkgb2YgcGFyc2VkIHNlbGVjdG9ycyAoYW5kIHRoZWlyIHRva2VucykgYW5kIGEgXCJuZXh0SW5kZXhcIiBmaWVsZFxuICAgICAgICAgICAqIHRoYXQgcG9pbnRzIHRvIGFuIGluZGV4IGFmdGVyIHdoaWNoIHdlJ3JlIG5vdCBhYmxlIHRvIHBhcnNlIHNlbGVjdG9ycyBmYXJ0aGVyLlxuICAgICAgICAgICAqL1xuICAgICAgICAgIHZhciBuZXh0SW5kZXggPSBzZWxlY3Rvci5sZW5ndGggLSBpbnZhbGlkTGVuO1xuICAgICAgICAgIHZhciBzZWxlY3RvcnMgPSB0b2tlbkdyb3Vwc1RvU2VsZWN0b3JzKGdyb3Vwcyk7XG4gICAgICAgICAgcmV0dXJuIHtcbiAgICAgICAgICAgIHNlbGVjdG9yczogc2VsZWN0b3JzLFxuICAgICAgICAgICAgbmV4dEluZGV4OiBuZXh0SW5kZXhcbiAgICAgICAgICB9O1xuICAgICAgICB9XG4gICAgICAgIC8qKiBbQWRHdWFyZCBQYXRjaF06IFNvcnRpbmcgdG9rZW5zICovXG5cblxuICAgICAgICB2YXIgc29ydGVkR3JvdXBzID0gc29ydFRva2VuR3JvdXBzKGdyb3Vwcyk7XG4gICAgICAgIC8qKiBbQWRHdWFyZCBQYXRjaF06IENoYW5nZSB0aGUgd2F5IHRva2VucyBhcmUgY2FjaGVkICovXG5cbiAgICAgICAgdmFyIHRva2Vuc0NhY2hlSXRlbSA9IHtcbiAgICAgICAgICBncm91cHM6IGdyb3VwcyxcbiAgICAgICAgICBzb3J0ZWRHcm91cHM6IHNvcnRlZEdyb3Vwc1xuICAgICAgICB9O1xuICAgICAgICB0b2tlbnNDYWNoZUl0ZW0gPSB0b2tlbkNhY2hlKHNlbGVjdG9yLCB0b2tlbnNDYWNoZUl0ZW0pO1xuICAgICAgICByZXR1cm4gKHJldHVyblVuc29ydGVkID8gdG9rZW5zQ2FjaGVJdGVtLmdyb3VwcyA6IHRva2Vuc0NhY2hlSXRlbS5zb3J0ZWRHcm91cHMpLnNsaWNlKDApO1xuICAgICAgfTtcblxuICAgICAgZnVuY3Rpb24gdG9TZWxlY3Rvcih0b2tlbnMpIHtcbiAgICAgICAgdmFyIGkgPSAwLFxuICAgICAgICAgICAgbGVuID0gdG9rZW5zLmxlbmd0aCxcbiAgICAgICAgICAgIHNlbGVjdG9yID0gXCJcIjtcblxuICAgICAgICBmb3IgKDsgaSA8IGxlbjsgaSsrKSB7XG4gICAgICAgICAgc2VsZWN0b3IgKz0gdG9rZW5zW2ldLnZhbHVlO1xuICAgICAgICB9XG5cbiAgICAgICAgcmV0dXJuIHNlbGVjdG9yO1xuICAgICAgfVxuXG4gICAgICBmdW5jdGlvbiBhZGRDb21iaW5hdG9yKG1hdGNoZXIsIGNvbWJpbmF0b3IsIGJhc2UpIHtcbiAgICAgICAgdmFyIGRpciA9IGNvbWJpbmF0b3IuZGlyLFxuICAgICAgICAgICAgc2tpcCA9IGNvbWJpbmF0b3IubmV4dCxcbiAgICAgICAgICAgIGtleSA9IHNraXAgfHwgZGlyLFxuICAgICAgICAgICAgY2hlY2tOb25FbGVtZW50cyA9IGJhc2UgJiYga2V5ID09PSBcInBhcmVudE5vZGVcIixcbiAgICAgICAgICAgIGRvbmVOYW1lID0gZG9uZSsrO1xuICAgICAgICByZXR1cm4gY29tYmluYXRvci5maXJzdCA/IC8vIENoZWNrIGFnYWluc3QgY2xvc2VzdCBhbmNlc3Rvci9wcmVjZWRpbmcgZWxlbWVudFxuICAgICAgICBmdW5jdGlvbiAoZWxlbSwgY29udGV4dCwgeG1sKSB7XG4gICAgICAgICAgd2hpbGUgKGVsZW0gPSBlbGVtW2Rpcl0pIHtcbiAgICAgICAgICAgIGlmIChlbGVtLm5vZGVUeXBlID09PSAxIHx8IGNoZWNrTm9uRWxlbWVudHMpIHtcbiAgICAgICAgICAgICAgcmV0dXJuIG1hdGNoZXIoZWxlbSwgY29udGV4dCwgeG1sKTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9XG5cbiAgICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICAgIH0gOiAvLyBDaGVjayBhZ2FpbnN0IGFsbCBhbmNlc3Rvci9wcmVjZWRpbmcgZWxlbWVudHNcbiAgICAgICAgZnVuY3Rpb24gKGVsZW0sIGNvbnRleHQsIHhtbCkge1xuICAgICAgICAgIHZhciBvbGRDYWNoZSxcbiAgICAgICAgICAgICAgdW5pcXVlQ2FjaGUsXG4gICAgICAgICAgICAgIG91dGVyQ2FjaGUsXG4gICAgICAgICAgICAgIG5ld0NhY2hlID0gW2RpcnJ1bnMsIGRvbmVOYW1lXTsgLy8gV2UgY2FuJ3Qgc2V0IGFyYml0cmFyeSBkYXRhIG9uIFhNTCBub2Rlcywgc28gdGhleSBkb24ndCBiZW5lZml0IGZyb20gY29tYmluYXRvciBjYWNoaW5nXG5cbiAgICAgICAgICBpZiAoeG1sKSB7XG4gICAgICAgICAgICB3aGlsZSAoZWxlbSA9IGVsZW1bZGlyXSkge1xuICAgICAgICAgICAgICBpZiAoZWxlbS5ub2RlVHlwZSA9PT0gMSB8fCBjaGVja05vbkVsZW1lbnRzKSB7XG4gICAgICAgICAgICAgICAgaWYgKG1hdGNoZXIoZWxlbSwgY29udGV4dCwgeG1sKSkge1xuICAgICAgICAgICAgICAgICAgcmV0dXJuIHRydWU7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIHdoaWxlIChlbGVtID0gZWxlbVtkaXJdKSB7XG4gICAgICAgICAgICAgIGlmIChlbGVtLm5vZGVUeXBlID09PSAxIHx8IGNoZWNrTm9uRWxlbWVudHMpIHtcbiAgICAgICAgICAgICAgICBvdXRlckNhY2hlID0gZWxlbVtleHBhbmRvXSB8fCAoZWxlbVtleHBhbmRvXSA9IHt9KTsgLy8gU3VwcG9ydDogSUUgPDkgb25seVxuICAgICAgICAgICAgICAgIC8vIERlZmVuZCBhZ2FpbnN0IGNsb25lZCBhdHRyb3BlcnRpZXMgKGpRdWVyeSBnaC0xNzA5KVxuXG4gICAgICAgICAgICAgICAgdW5pcXVlQ2FjaGUgPSBvdXRlckNhY2hlW2VsZW0udW5pcXVlSURdIHx8IChvdXRlckNhY2hlW2VsZW0udW5pcXVlSURdID0ge30pO1xuXG4gICAgICAgICAgICAgICAgaWYgKHNraXAgJiYgc2tpcCA9PT0gZWxlbS5ub2RlTmFtZS50b0xvd2VyQ2FzZSgpKSB7XG4gICAgICAgICAgICAgICAgICBlbGVtID0gZWxlbVtkaXJdIHx8IGVsZW07XG4gICAgICAgICAgICAgICAgfSBlbHNlIGlmICgob2xkQ2FjaGUgPSB1bmlxdWVDYWNoZVtrZXldKSAmJiBvbGRDYWNoZVswXSA9PT0gZGlycnVucyAmJiBvbGRDYWNoZVsxXSA9PT0gZG9uZU5hbWUpIHtcbiAgICAgICAgICAgICAgICAgIC8vIEFzc2lnbiB0byBuZXdDYWNoZSBzbyByZXN1bHRzIGJhY2stcHJvcGFnYXRlIHRvIHByZXZpb3VzIGVsZW1lbnRzXG4gICAgICAgICAgICAgICAgICByZXR1cm4gbmV3Q2FjaGVbMl0gPSBvbGRDYWNoZVsyXTtcbiAgICAgICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICAgICAgLy8gUmV1c2UgbmV3Y2FjaGUgc28gcmVzdWx0cyBiYWNrLXByb3BhZ2F0ZSB0byBwcmV2aW91cyBlbGVtZW50c1xuICAgICAgICAgICAgICAgICAgdW5pcXVlQ2FjaGVba2V5XSA9IG5ld0NhY2hlOyAvLyBBIG1hdGNoIG1lYW5zIHdlJ3JlIGRvbmU7IGEgZmFpbCBtZWFucyB3ZSBoYXZlIHRvIGtlZXAgY2hlY2tpbmdcblxuICAgICAgICAgICAgICAgICAgaWYgKG5ld0NhY2hlWzJdID0gbWF0Y2hlcihlbGVtLCBjb250ZXh0LCB4bWwpKSB7XG4gICAgICAgICAgICAgICAgICAgIHJldHVybiB0cnVlO1xuICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cblxuICAgICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgICAgfTtcbiAgICAgIH1cblxuICAgICAgZnVuY3Rpb24gZWxlbWVudE1hdGNoZXIobWF0Y2hlcnMpIHtcbiAgICAgICAgcmV0dXJuIG1hdGNoZXJzLmxlbmd0aCA+IDEgPyBmdW5jdGlvbiAoZWxlbSwgY29udGV4dCwgeG1sKSB7XG4gICAgICAgICAgdmFyIGkgPSBtYXRjaGVycy5sZW5ndGg7XG5cbiAgICAgICAgICB3aGlsZSAoaS0tKSB7XG4gICAgICAgICAgICBpZiAoIW1hdGNoZXJzW2ldKGVsZW0sIGNvbnRleHQsIHhtbCkpIHtcbiAgICAgICAgICAgICAgcmV0dXJuIGZhbHNlO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cblxuICAgICAgICAgIHJldHVybiB0cnVlO1xuICAgICAgICB9IDogbWF0Y2hlcnNbMF07XG4gICAgICB9XG5cbiAgICAgIGZ1bmN0aW9uIG11bHRpcGxlQ29udGV4dHMoc2VsZWN0b3IsIGNvbnRleHRzLCByZXN1bHRzKSB7XG4gICAgICAgIHZhciBpID0gMCxcbiAgICAgICAgICAgIGxlbiA9IGNvbnRleHRzLmxlbmd0aDtcblxuICAgICAgICBmb3IgKDsgaSA8IGxlbjsgaSsrKSB7XG4gICAgICAgICAgU2l6emxlKHNlbGVjdG9yLCBjb250ZXh0c1tpXSwgcmVzdWx0cyk7XG4gICAgICAgIH1cblxuICAgICAgICByZXR1cm4gcmVzdWx0cztcbiAgICAgIH1cblxuICAgICAgZnVuY3Rpb24gY29uZGVuc2UodW5tYXRjaGVkLCBtYXAsIGZpbHRlciwgY29udGV4dCwgeG1sKSB7XG4gICAgICAgIHZhciBlbGVtLFxuICAgICAgICAgICAgbmV3VW5tYXRjaGVkID0gW10sXG4gICAgICAgICAgICBpID0gMCxcbiAgICAgICAgICAgIGxlbiA9IHVubWF0Y2hlZC5sZW5ndGgsXG4gICAgICAgICAgICBtYXBwZWQgPSBtYXAgIT0gbnVsbDtcblxuICAgICAgICBmb3IgKDsgaSA8IGxlbjsgaSsrKSB7XG4gICAgICAgICAgaWYgKGVsZW0gPSB1bm1hdGNoZWRbaV0pIHtcbiAgICAgICAgICAgIGlmICghZmlsdGVyIHx8IGZpbHRlcihlbGVtLCBjb250ZXh0LCB4bWwpKSB7XG4gICAgICAgICAgICAgIG5ld1VubWF0Y2hlZC5wdXNoKGVsZW0pO1xuXG4gICAgICAgICAgICAgIGlmIChtYXBwZWQpIHtcbiAgICAgICAgICAgICAgICBtYXAucHVzaChpKTtcbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiBuZXdVbm1hdGNoZWQ7XG4gICAgICB9XG5cbiAgICAgIGZ1bmN0aW9uIHNldE1hdGNoZXIocHJlRmlsdGVyLCBzZWxlY3RvciwgbWF0Y2hlciwgcG9zdEZpbHRlciwgcG9zdEZpbmRlciwgcG9zdFNlbGVjdG9yKSB7XG4gICAgICAgIGlmIChwb3N0RmlsdGVyICYmICFwb3N0RmlsdGVyW2V4cGFuZG9dKSB7XG4gICAgICAgICAgcG9zdEZpbHRlciA9IHNldE1hdGNoZXIocG9zdEZpbHRlcik7XG4gICAgICAgIH1cblxuICAgICAgICBpZiAocG9zdEZpbmRlciAmJiAhcG9zdEZpbmRlcltleHBhbmRvXSkge1xuICAgICAgICAgIHBvc3RGaW5kZXIgPSBzZXRNYXRjaGVyKHBvc3RGaW5kZXIsIHBvc3RTZWxlY3Rvcik7XG4gICAgICAgIH1cblxuICAgICAgICByZXR1cm4gbWFya0Z1bmN0aW9uKGZ1bmN0aW9uIChzZWVkLCByZXN1bHRzLCBjb250ZXh0LCB4bWwpIHtcbiAgICAgICAgICB2YXIgdGVtcCxcbiAgICAgICAgICAgICAgaSxcbiAgICAgICAgICAgICAgZWxlbSxcbiAgICAgICAgICAgICAgcHJlTWFwID0gW10sXG4gICAgICAgICAgICAgIHBvc3RNYXAgPSBbXSxcbiAgICAgICAgICAgICAgcHJlZXhpc3RpbmcgPSByZXN1bHRzLmxlbmd0aCxcbiAgICAgICAgICAgICAgLy8gR2V0IGluaXRpYWwgZWxlbWVudHMgZnJvbSBzZWVkIG9yIGNvbnRleHRcbiAgICAgICAgICBlbGVtcyA9IHNlZWQgfHwgbXVsdGlwbGVDb250ZXh0cyhzZWxlY3RvciB8fCBcIipcIiwgY29udGV4dC5ub2RlVHlwZSA/IFtjb250ZXh0XSA6IGNvbnRleHQsIFtdKSxcbiAgICAgICAgICAgICAgLy8gUHJlZmlsdGVyIHRvIGdldCBtYXRjaGVyIGlucHV0LCBwcmVzZXJ2aW5nIGEgbWFwIGZvciBzZWVkLXJlc3VsdHMgc3luY2hyb25pemF0aW9uXG4gICAgICAgICAgbWF0Y2hlckluID0gcHJlRmlsdGVyICYmIChzZWVkIHx8ICFzZWxlY3RvcikgPyBjb25kZW5zZShlbGVtcywgcHJlTWFwLCBwcmVGaWx0ZXIsIGNvbnRleHQsIHhtbCkgOiBlbGVtcyxcbiAgICAgICAgICAgICAgbWF0Y2hlck91dCA9IG1hdGNoZXIgPyAvLyBJZiB3ZSBoYXZlIGEgcG9zdEZpbmRlciwgb3IgZmlsdGVyZWQgc2VlZCwgb3Igbm9uLXNlZWQgcG9zdEZpbHRlciBvciBwcmVleGlzdGluZyByZXN1bHRzLFxuICAgICAgICAgIHBvc3RGaW5kZXIgfHwgKHNlZWQgPyBwcmVGaWx0ZXIgOiBwcmVleGlzdGluZyB8fCBwb3N0RmlsdGVyKSA/IC8vIC4uLmludGVybWVkaWF0ZSBwcm9jZXNzaW5nIGlzIG5lY2Vzc2FyeVxuICAgICAgICAgIFtdIDogLy8gLi4ub3RoZXJ3aXNlIHVzZSByZXN1bHRzIGRpcmVjdGx5XG4gICAgICAgICAgcmVzdWx0cyA6IG1hdGNoZXJJbjsgLy8gRmluZCBwcmltYXJ5IG1hdGNoZXNcblxuICAgICAgICAgIGlmIChtYXRjaGVyKSB7XG4gICAgICAgICAgICBtYXRjaGVyKG1hdGNoZXJJbiwgbWF0Y2hlck91dCwgY29udGV4dCwgeG1sKTtcbiAgICAgICAgICB9IC8vIEFwcGx5IHBvc3RGaWx0ZXJcblxuXG4gICAgICAgICAgaWYgKHBvc3RGaWx0ZXIpIHtcbiAgICAgICAgICAgIHRlbXAgPSBjb25kZW5zZShtYXRjaGVyT3V0LCBwb3N0TWFwKTtcbiAgICAgICAgICAgIHBvc3RGaWx0ZXIodGVtcCwgW10sIGNvbnRleHQsIHhtbCk7IC8vIFVuLW1hdGNoIGZhaWxpbmcgZWxlbWVudHMgYnkgbW92aW5nIHRoZW0gYmFjayB0byBtYXRjaGVySW5cblxuICAgICAgICAgICAgaSA9IHRlbXAubGVuZ3RoO1xuXG4gICAgICAgICAgICB3aGlsZSAoaS0tKSB7XG4gICAgICAgICAgICAgIGlmIChlbGVtID0gdGVtcFtpXSkge1xuICAgICAgICAgICAgICAgIG1hdGNoZXJPdXRbcG9zdE1hcFtpXV0gPSAhKG1hdGNoZXJJbltwb3N0TWFwW2ldXSA9IGVsZW0pO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgaWYgKHNlZWQpIHtcbiAgICAgICAgICAgIGlmIChwb3N0RmluZGVyIHx8IHByZUZpbHRlcikge1xuICAgICAgICAgICAgICBpZiAocG9zdEZpbmRlcikge1xuICAgICAgICAgICAgICAgIC8vIEdldCB0aGUgZmluYWwgbWF0Y2hlck91dCBieSBjb25kZW5zaW5nIHRoaXMgaW50ZXJtZWRpYXRlIGludG8gcG9zdEZpbmRlciBjb250ZXh0c1xuICAgICAgICAgICAgICAgIHRlbXAgPSBbXTtcbiAgICAgICAgICAgICAgICBpID0gbWF0Y2hlck91dC5sZW5ndGg7XG5cbiAgICAgICAgICAgICAgICB3aGlsZSAoaS0tKSB7XG4gICAgICAgICAgICAgICAgICBpZiAoZWxlbSA9IG1hdGNoZXJPdXRbaV0pIHtcbiAgICAgICAgICAgICAgICAgICAgLy8gUmVzdG9yZSBtYXRjaGVySW4gc2luY2UgZWxlbSBpcyBub3QgeWV0IGEgZmluYWwgbWF0Y2hcbiAgICAgICAgICAgICAgICAgICAgdGVtcC5wdXNoKG1hdGNoZXJJbltpXSA9IGVsZW0pO1xuICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgIHBvc3RGaW5kZXIobnVsbCwgbWF0Y2hlck91dCA9IFtdLCB0ZW1wLCB4bWwpO1xuICAgICAgICAgICAgICB9IC8vIE1vdmUgbWF0Y2hlZCBlbGVtZW50cyBmcm9tIHNlZWQgdG8gcmVzdWx0cyB0byBrZWVwIHRoZW0gc3luY2hyb25pemVkXG5cblxuICAgICAgICAgICAgICBpID0gbWF0Y2hlck91dC5sZW5ndGg7XG5cbiAgICAgICAgICAgICAgd2hpbGUgKGktLSkge1xuICAgICAgICAgICAgICAgIGlmICgoZWxlbSA9IG1hdGNoZXJPdXRbaV0pICYmICh0ZW1wID0gcG9zdEZpbmRlciA/IGluZGV4T2Yoc2VlZCwgZWxlbSkgOiBwcmVNYXBbaV0pID4gLTEpIHtcbiAgICAgICAgICAgICAgICAgIHNlZWRbdGVtcF0gPSAhKHJlc3VsdHNbdGVtcF0gPSBlbGVtKTtcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH0gLy8gQWRkIGVsZW1lbnRzIHRvIHJlc3VsdHMsIHRocm91Z2ggcG9zdEZpbmRlciBpZiBkZWZpbmVkXG5cbiAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgbWF0Y2hlck91dCA9IGNvbmRlbnNlKG1hdGNoZXJPdXQgPT09IHJlc3VsdHMgPyBtYXRjaGVyT3V0LnNwbGljZShwcmVleGlzdGluZywgbWF0Y2hlck91dC5sZW5ndGgpIDogbWF0Y2hlck91dCk7XG5cbiAgICAgICAgICAgIGlmIChwb3N0RmluZGVyKSB7XG4gICAgICAgICAgICAgIHBvc3RGaW5kZXIobnVsbCwgcmVzdWx0cywgbWF0Y2hlck91dCwgeG1sKTtcbiAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgIHB1c2guYXBwbHkocmVzdWx0cywgbWF0Y2hlck91dCk7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfVxuICAgICAgICB9KTtcbiAgICAgIH1cblxuICAgICAgZnVuY3Rpb24gbWF0Y2hlckZyb21Ub2tlbnModG9rZW5zKSB7XG4gICAgICAgIHZhciBjaGVja0NvbnRleHQsXG4gICAgICAgICAgICBtYXRjaGVyLFxuICAgICAgICAgICAgaixcbiAgICAgICAgICAgIGxlbiA9IHRva2Vucy5sZW5ndGgsXG4gICAgICAgICAgICBsZWFkaW5nUmVsYXRpdmUgPSBFeHByLnJlbGF0aXZlW3Rva2Vuc1swXS50eXBlXSxcbiAgICAgICAgICAgIGltcGxpY2l0UmVsYXRpdmUgPSBsZWFkaW5nUmVsYXRpdmUgfHwgRXhwci5yZWxhdGl2ZVtcIiBcIl0sXG4gICAgICAgICAgICBpID0gbGVhZGluZ1JlbGF0aXZlID8gMSA6IDAsXG4gICAgICAgICAgICAvLyBUaGUgZm91bmRhdGlvbmFsIG1hdGNoZXIgZW5zdXJlcyB0aGF0IGVsZW1lbnRzIGFyZSByZWFjaGFibGUgZnJvbSB0b3AtbGV2ZWwgY29udGV4dChzKVxuICAgICAgICBtYXRjaENvbnRleHQgPSBhZGRDb21iaW5hdG9yKGZ1bmN0aW9uIChlbGVtKSB7XG4gICAgICAgICAgcmV0dXJuIGVsZW0gPT09IGNoZWNrQ29udGV4dDtcbiAgICAgICAgfSwgaW1wbGljaXRSZWxhdGl2ZSwgdHJ1ZSksXG4gICAgICAgICAgICBtYXRjaEFueUNvbnRleHQgPSBhZGRDb21iaW5hdG9yKGZ1bmN0aW9uIChlbGVtKSB7XG4gICAgICAgICAgcmV0dXJuIGluZGV4T2YoY2hlY2tDb250ZXh0LCBlbGVtKSA+IC0xO1xuICAgICAgICB9LCBpbXBsaWNpdFJlbGF0aXZlLCB0cnVlKSxcbiAgICAgICAgICAgIG1hdGNoZXJzID0gW2Z1bmN0aW9uIChlbGVtLCBjb250ZXh0LCB4bWwpIHtcbiAgICAgICAgICB2YXIgcmV0ID0gIWxlYWRpbmdSZWxhdGl2ZSAmJiAoeG1sIHx8IGNvbnRleHQgIT09IG91dGVybW9zdENvbnRleHQpIHx8ICgoY2hlY2tDb250ZXh0ID0gY29udGV4dCkubm9kZVR5cGUgPyBtYXRjaENvbnRleHQoZWxlbSwgY29udGV4dCwgeG1sKSA6IG1hdGNoQW55Q29udGV4dChlbGVtLCBjb250ZXh0LCB4bWwpKTsgLy8gQXZvaWQgaGFuZ2luZyBvbnRvIGVsZW1lbnQgKGlzc3VlICMyOTkpXG5cbiAgICAgICAgICBjaGVja0NvbnRleHQgPSBudWxsO1xuICAgICAgICAgIHJldHVybiByZXQ7XG4gICAgICAgIH1dO1xuXG4gICAgICAgIGZvciAoOyBpIDwgbGVuOyBpKyspIHtcbiAgICAgICAgICBpZiAobWF0Y2hlciA9IEV4cHIucmVsYXRpdmVbdG9rZW5zW2ldLnR5cGVdKSB7XG4gICAgICAgICAgICBtYXRjaGVycyA9IFthZGRDb21iaW5hdG9yKGVsZW1lbnRNYXRjaGVyKG1hdGNoZXJzKSwgbWF0Y2hlcildO1xuICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICBtYXRjaGVyID0gRXhwci5maWx0ZXJbdG9rZW5zW2ldLnR5cGVdLmFwcGx5KG51bGwsIHRva2Vuc1tpXS5tYXRjaGVzKTsgLy8gUmV0dXJuIHNwZWNpYWwgdXBvbiBzZWVpbmcgYSBwb3NpdGlvbmFsIG1hdGNoZXJcblxuICAgICAgICAgICAgaWYgKG1hdGNoZXJbZXhwYW5kb10pIHtcbiAgICAgICAgICAgICAgLy8gRmluZCB0aGUgbmV4dCByZWxhdGl2ZSBvcGVyYXRvciAoaWYgYW55KSBmb3IgcHJvcGVyIGhhbmRsaW5nXG4gICAgICAgICAgICAgIGogPSArK2k7XG5cbiAgICAgICAgICAgICAgZm9yICg7IGogPCBsZW47IGorKykge1xuICAgICAgICAgICAgICAgIGlmIChFeHByLnJlbGF0aXZlW3Rva2Vuc1tqXS50eXBlXSkge1xuICAgICAgICAgICAgICAgICAgYnJlYWs7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgcmV0dXJuIHNldE1hdGNoZXIoaSA+IDEgJiYgZWxlbWVudE1hdGNoZXIobWF0Y2hlcnMpLCBpID4gMSAmJiB0b1NlbGVjdG9yKCAvLyBJZiB0aGUgcHJlY2VkaW5nIHRva2VuIHdhcyBhIGRlc2NlbmRhbnQgY29tYmluYXRvciwgaW5zZXJ0IGFuIGltcGxpY2l0IGFueS1lbGVtZW50IGAqYFxuICAgICAgICAgICAgICB0b2tlbnMuc2xpY2UoMCwgaSAtIDEpLmNvbmNhdCh7XG4gICAgICAgICAgICAgICAgdmFsdWU6IHRva2Vuc1tpIC0gMl0udHlwZSA9PT0gXCIgXCIgPyBcIipcIiA6IFwiXCJcbiAgICAgICAgICAgICAgfSkpLnJlcGxhY2UocnRyaW0sIFwiJDFcIiksIG1hdGNoZXIsIGkgPCBqICYmIG1hdGNoZXJGcm9tVG9rZW5zKHRva2Vucy5zbGljZShpLCBqKSksIGogPCBsZW4gJiYgbWF0Y2hlckZyb21Ub2tlbnModG9rZW5zID0gdG9rZW5zLnNsaWNlKGopKSwgaiA8IGxlbiAmJiB0b1NlbGVjdG9yKHRva2VucykpO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICBtYXRjaGVycy5wdXNoKG1hdGNoZXIpO1xuICAgICAgICAgIH1cbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiBlbGVtZW50TWF0Y2hlcihtYXRjaGVycyk7XG4gICAgICB9XG5cbiAgICAgIGZ1bmN0aW9uIG1hdGNoZXJGcm9tR3JvdXBNYXRjaGVycyhlbGVtZW50TWF0Y2hlcnMsIHNldE1hdGNoZXJzKSB7XG4gICAgICAgIHZhciBieVNldCA9IHNldE1hdGNoZXJzLmxlbmd0aCA+IDAsXG4gICAgICAgICAgICBieUVsZW1lbnQgPSBlbGVtZW50TWF0Y2hlcnMubGVuZ3RoID4gMCxcbiAgICAgICAgICAgIHN1cGVyTWF0Y2hlciA9IGZ1bmN0aW9uIHN1cGVyTWF0Y2hlcihzZWVkLCBjb250ZXh0LCB4bWwsIHJlc3VsdHMsIG91dGVybW9zdCkge1xuICAgICAgICAgIHZhciBlbGVtLFxuICAgICAgICAgICAgICBqLFxuICAgICAgICAgICAgICBtYXRjaGVyLFxuICAgICAgICAgICAgICBtYXRjaGVkQ291bnQgPSAwLFxuICAgICAgICAgICAgICBpID0gXCIwXCIsXG4gICAgICAgICAgICAgIHVubWF0Y2hlZCA9IHNlZWQgJiYgW10sXG4gICAgICAgICAgICAgIHNldE1hdGNoZWQgPSBbXSxcbiAgICAgICAgICAgICAgY29udGV4dEJhY2t1cCA9IG91dGVybW9zdENvbnRleHQsXG4gICAgICAgICAgICAgIC8vIFdlIG11c3QgYWx3YXlzIGhhdmUgZWl0aGVyIHNlZWQgZWxlbWVudHMgb3Igb3V0ZXJtb3N0IGNvbnRleHRcbiAgICAgICAgICBlbGVtcyA9IHNlZWQgfHwgYnlFbGVtZW50ICYmIEV4cHIuZmluZFtcIlRBR1wiXShcIipcIiwgb3V0ZXJtb3N0KSxcbiAgICAgICAgICAgICAgLy8gVXNlIGludGVnZXIgZGlycnVucyBpZmYgdGhpcyBpcyB0aGUgb3V0ZXJtb3N0IG1hdGNoZXJcbiAgICAgICAgICBkaXJydW5zVW5pcXVlID0gZGlycnVucyArPSBjb250ZXh0QmFja3VwID09IG51bGwgPyAxIDogTWF0aC5yYW5kb20oKSB8fCAwLjEsXG4gICAgICAgICAgICAgIGxlbiA9IGVsZW1zLmxlbmd0aDtcblxuICAgICAgICAgIGlmIChvdXRlcm1vc3QpIHtcbiAgICAgICAgICAgIG91dGVybW9zdENvbnRleHQgPSBjb250ZXh0ID09PSBkb2N1bWVudCB8fCBjb250ZXh0IHx8IG91dGVybW9zdDtcbiAgICAgICAgICB9IC8vIEFkZCBlbGVtZW50cyBwYXNzaW5nIGVsZW1lbnRNYXRjaGVycyBkaXJlY3RseSB0byByZXN1bHRzXG4gICAgICAgICAgLy8gU3VwcG9ydDogSUU8OSwgU2FmYXJpXG4gICAgICAgICAgLy8gVG9sZXJhdGUgTm9kZUxpc3QgcHJvcGVydGllcyAoSUU6IFwibGVuZ3RoXCI7IFNhZmFyaTogPG51bWJlcj4pIG1hdGNoaW5nIGVsZW1lbnRzIGJ5IGlkXG5cblxuICAgICAgICAgIGZvciAoOyBpICE9PSBsZW4gJiYgKGVsZW0gPSBlbGVtc1tpXSkgIT0gbnVsbDsgaSsrKSB7XG4gICAgICAgICAgICBpZiAoYnlFbGVtZW50ICYmIGVsZW0pIHtcbiAgICAgICAgICAgICAgaiA9IDA7XG5cbiAgICAgICAgICAgICAgaWYgKCFjb250ZXh0ICYmIGVsZW0ub3duZXJEb2N1bWVudCAhPT0gZG9jdW1lbnQpIHtcbiAgICAgICAgICAgICAgICBzZXREb2N1bWVudChlbGVtKTtcbiAgICAgICAgICAgICAgICB4bWwgPSAhZG9jdW1lbnRJc0hUTUw7XG4gICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICB3aGlsZSAobWF0Y2hlciA9IGVsZW1lbnRNYXRjaGVyc1tqKytdKSB7XG4gICAgICAgICAgICAgICAgaWYgKG1hdGNoZXIoZWxlbSwgY29udGV4dCB8fCBkb2N1bWVudCwgeG1sKSkge1xuICAgICAgICAgICAgICAgICAgcmVzdWx0cy5wdXNoKGVsZW0pO1xuICAgICAgICAgICAgICAgICAgYnJlYWs7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgaWYgKG91dGVybW9zdCkge1xuICAgICAgICAgICAgICAgIGRpcnJ1bnMgPSBkaXJydW5zVW5pcXVlO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9IC8vIFRyYWNrIHVubWF0Y2hlZCBlbGVtZW50cyBmb3Igc2V0IGZpbHRlcnNcblxuXG4gICAgICAgICAgICBpZiAoYnlTZXQpIHtcbiAgICAgICAgICAgICAgLy8gVGhleSB3aWxsIGhhdmUgZ29uZSB0aHJvdWdoIGFsbCBwb3NzaWJsZSBtYXRjaGVyc1xuICAgICAgICAgICAgICBpZiAoZWxlbSA9ICFtYXRjaGVyICYmIGVsZW0pIHtcbiAgICAgICAgICAgICAgICBtYXRjaGVkQ291bnQtLTtcbiAgICAgICAgICAgICAgfSAvLyBMZW5ndGhlbiB0aGUgYXJyYXkgZm9yIGV2ZXJ5IGVsZW1lbnQsIG1hdGNoZWQgb3Igbm90XG5cblxuICAgICAgICAgICAgICBpZiAoc2VlZCkge1xuICAgICAgICAgICAgICAgIHVubWF0Y2hlZC5wdXNoKGVsZW0pO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfSAvLyBgaWAgaXMgbm93IHRoZSBjb3VudCBvZiBlbGVtZW50cyB2aXNpdGVkIGFib3ZlLCBhbmQgYWRkaW5nIGl0IHRvIGBtYXRjaGVkQ291bnRgXG4gICAgICAgICAgLy8gbWFrZXMgdGhlIGxhdHRlciBub25uZWdhdGl2ZS5cblxuXG4gICAgICAgICAgbWF0Y2hlZENvdW50ICs9IGk7IC8vIEFwcGx5IHNldCBmaWx0ZXJzIHRvIHVubWF0Y2hlZCBlbGVtZW50c1xuICAgICAgICAgIC8vIE5PVEU6IFRoaXMgY2FuIGJlIHNraXBwZWQgaWYgdGhlcmUgYXJlIG5vIHVubWF0Y2hlZCBlbGVtZW50cyAoaS5lLiwgYG1hdGNoZWRDb3VudGBcbiAgICAgICAgICAvLyBlcXVhbHMgYGlgKSwgdW5sZXNzIHdlIGRpZG4ndCB2aXNpdCBfYW55XyBlbGVtZW50cyBpbiB0aGUgYWJvdmUgbG9vcCBiZWNhdXNlIHdlIGhhdmVcbiAgICAgICAgICAvLyBubyBlbGVtZW50IG1hdGNoZXJzIGFuZCBubyBzZWVkLlxuICAgICAgICAgIC8vIEluY3JlbWVudGluZyBhbiBpbml0aWFsbHktc3RyaW5nIFwiMFwiIGBpYCBhbGxvd3MgYGlgIHRvIHJlbWFpbiBhIHN0cmluZyBvbmx5IGluIHRoYXRcbiAgICAgICAgICAvLyBjYXNlLCB3aGljaCB3aWxsIHJlc3VsdCBpbiBhIFwiMDBcIiBgbWF0Y2hlZENvdW50YCB0aGF0IGRpZmZlcnMgZnJvbSBgaWAgYnV0IGlzIGFsc29cbiAgICAgICAgICAvLyBudW1lcmljYWxseSB6ZXJvLlxuXG4gICAgICAgICAgaWYgKGJ5U2V0ICYmIGkgIT09IG1hdGNoZWRDb3VudCkge1xuICAgICAgICAgICAgaiA9IDA7XG5cbiAgICAgICAgICAgIHdoaWxlIChtYXRjaGVyID0gc2V0TWF0Y2hlcnNbaisrXSkge1xuICAgICAgICAgICAgICBtYXRjaGVyKHVubWF0Y2hlZCwgc2V0TWF0Y2hlZCwgY29udGV4dCwgeG1sKTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgaWYgKHNlZWQpIHtcbiAgICAgICAgICAgICAgLy8gUmVpbnRlZ3JhdGUgZWxlbWVudCBtYXRjaGVzIHRvIGVsaW1pbmF0ZSB0aGUgbmVlZCBmb3Igc29ydGluZ1xuICAgICAgICAgICAgICBpZiAobWF0Y2hlZENvdW50ID4gMCkge1xuICAgICAgICAgICAgICAgIHdoaWxlIChpLS0pIHtcbiAgICAgICAgICAgICAgICAgIGlmICghKHVubWF0Y2hlZFtpXSB8fCBzZXRNYXRjaGVkW2ldKSkge1xuICAgICAgICAgICAgICAgICAgICBzZXRNYXRjaGVkW2ldID0gcG9wLmNhbGwocmVzdWx0cyk7XG4gICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICB9IC8vIERpc2NhcmQgaW5kZXggcGxhY2Vob2xkZXIgdmFsdWVzIHRvIGdldCBvbmx5IGFjdHVhbCBtYXRjaGVzXG5cblxuICAgICAgICAgICAgICBzZXRNYXRjaGVkID0gY29uZGVuc2Uoc2V0TWF0Y2hlZCk7XG4gICAgICAgICAgICB9IC8vIEFkZCBtYXRjaGVzIHRvIHJlc3VsdHNcblxuXG4gICAgICAgICAgICBwdXNoLmFwcGx5KHJlc3VsdHMsIHNldE1hdGNoZWQpOyAvLyBTZWVkbGVzcyBzZXQgbWF0Y2hlcyBzdWNjZWVkaW5nIG11bHRpcGxlIHN1Y2Nlc3NmdWwgbWF0Y2hlcnMgc3RpcHVsYXRlIHNvcnRpbmdcblxuICAgICAgICAgICAgaWYgKG91dGVybW9zdCAmJiAhc2VlZCAmJiBzZXRNYXRjaGVkLmxlbmd0aCA+IDAgJiYgbWF0Y2hlZENvdW50ICsgc2V0TWF0Y2hlcnMubGVuZ3RoID4gMSkge1xuICAgICAgICAgICAgICBTaXp6bGUudW5pcXVlU29ydChyZXN1bHRzKTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9IC8vIE92ZXJyaWRlIG1hbmlwdWxhdGlvbiBvZiBnbG9iYWxzIGJ5IG5lc3RlZCBtYXRjaGVyc1xuXG5cbiAgICAgICAgICBpZiAob3V0ZXJtb3N0KSB7XG4gICAgICAgICAgICBkaXJydW5zID0gZGlycnVuc1VuaXF1ZTtcbiAgICAgICAgICAgIG91dGVybW9zdENvbnRleHQgPSBjb250ZXh0QmFja3VwO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIHJldHVybiB1bm1hdGNoZWQ7XG4gICAgICAgIH07XG5cbiAgICAgICAgcmV0dXJuIGJ5U2V0ID8gbWFya0Z1bmN0aW9uKHN1cGVyTWF0Y2hlcikgOiBzdXBlck1hdGNoZXI7XG4gICAgICB9XG5cbiAgICAgIGNvbXBpbGUgPSBTaXp6bGUuY29tcGlsZSA9IGZ1bmN0aW9uIChzZWxlY3RvciwgbWF0Y2hcbiAgICAgIC8qIEludGVybmFsIFVzZSBPbmx5ICovXG4gICAgICApIHtcbiAgICAgICAgdmFyIGksXG4gICAgICAgICAgICBzZXRNYXRjaGVycyA9IFtdLFxuICAgICAgICAgICAgZWxlbWVudE1hdGNoZXJzID0gW10sXG4gICAgICAgICAgICBjYWNoZWQgPSBjb21waWxlckNhY2hlW3NlbGVjdG9yICsgXCIgXCJdO1xuXG4gICAgICAgIGlmICghY2FjaGVkKSB7XG4gICAgICAgICAgLy8gR2VuZXJhdGUgYSBmdW5jdGlvbiBvZiByZWN1cnNpdmUgZnVuY3Rpb25zIHRoYXQgY2FuIGJlIHVzZWQgdG8gY2hlY2sgZWFjaCBlbGVtZW50XG4gICAgICAgICAgaWYgKCFtYXRjaCkge1xuICAgICAgICAgICAgbWF0Y2ggPSB0b2tlbml6ZShzZWxlY3Rvcik7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgaSA9IG1hdGNoLmxlbmd0aDtcblxuICAgICAgICAgIHdoaWxlIChpLS0pIHtcbiAgICAgICAgICAgIGNhY2hlZCA9IG1hdGNoZXJGcm9tVG9rZW5zKG1hdGNoW2ldKTtcblxuICAgICAgICAgICAgaWYgKGNhY2hlZFtleHBhbmRvXSkge1xuICAgICAgICAgICAgICBzZXRNYXRjaGVycy5wdXNoKGNhY2hlZCk7XG4gICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICBlbGVtZW50TWF0Y2hlcnMucHVzaChjYWNoZWQpO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH0gLy8gQ2FjaGUgdGhlIGNvbXBpbGVkIGZ1bmN0aW9uXG5cblxuICAgICAgICAgIGNhY2hlZCA9IGNvbXBpbGVyQ2FjaGUoc2VsZWN0b3IsIG1hdGNoZXJGcm9tR3JvdXBNYXRjaGVycyhlbGVtZW50TWF0Y2hlcnMsIHNldE1hdGNoZXJzKSk7IC8vIFNhdmUgc2VsZWN0b3IgYW5kIHRva2VuaXphdGlvblxuXG4gICAgICAgICAgY2FjaGVkLnNlbGVjdG9yID0gc2VsZWN0b3I7XG4gICAgICAgIH1cblxuICAgICAgICByZXR1cm4gY2FjaGVkO1xuICAgICAgfTtcbiAgICAgIC8qKlxuICAgICAgICogQSBsb3ctbGV2ZWwgc2VsZWN0aW9uIGZ1bmN0aW9uIHRoYXQgd29ya3Mgd2l0aCBTaXp6bGUncyBjb21waWxlZFxuICAgICAgICogIHNlbGVjdG9yIGZ1bmN0aW9uc1xuICAgICAgICogQHBhcmFtIHtTdHJpbmd8RnVuY3Rpb259IHNlbGVjdG9yIEEgc2VsZWN0b3Igb3IgYSBwcmUtY29tcGlsZWRcbiAgICAgICAqICBzZWxlY3RvciBmdW5jdGlvbiBidWlsdCB3aXRoIFNpenpsZS5jb21waWxlXG4gICAgICAgKiBAcGFyYW0ge0VsZW1lbnR9IGNvbnRleHRcbiAgICAgICAqIEBwYXJhbSB7QXJyYXl9IFtyZXN1bHRzXVxuICAgICAgICogQHBhcmFtIHtBcnJheX0gW3NlZWRdIEEgc2V0IG9mIGVsZW1lbnRzIHRvIG1hdGNoIGFnYWluc3RcbiAgICAgICAqL1xuXG5cbiAgICAgIHNlbGVjdCA9IFNpenpsZS5zZWxlY3QgPSBmdW5jdGlvbiAoc2VsZWN0b3IsIGNvbnRleHQsIHJlc3VsdHMsIHNlZWQpIHtcbiAgICAgICAgdmFyIGksXG4gICAgICAgICAgICB0b2tlbnMsXG4gICAgICAgICAgICB0b2tlbixcbiAgICAgICAgICAgIHR5cGUsXG4gICAgICAgICAgICBmaW5kLFxuICAgICAgICAgICAgY29tcGlsZWQgPSB0eXBlb2Ygc2VsZWN0b3IgPT09IFwiZnVuY3Rpb25cIiAmJiBzZWxlY3RvcixcbiAgICAgICAgICAgIG1hdGNoID0gIXNlZWQgJiYgdG9rZW5pemUoc2VsZWN0b3IgPSBjb21waWxlZC5zZWxlY3RvciB8fCBzZWxlY3Rvcik7XG4gICAgICAgIHJlc3VsdHMgPSByZXN1bHRzIHx8IFtdOyAvLyBUcnkgdG8gbWluaW1pemUgb3BlcmF0aW9ucyBpZiB0aGVyZSBpcyBvbmx5IG9uZSBzZWxlY3RvciBpbiB0aGUgbGlzdCBhbmQgbm8gc2VlZFxuICAgICAgICAvLyAodGhlIGxhdHRlciBvZiB3aGljaCBndWFyYW50ZWVzIHVzIGNvbnRleHQpXG5cbiAgICAgICAgaWYgKG1hdGNoLmxlbmd0aCA9PT0gMSkge1xuICAgICAgICAgIC8vIFJlZHVjZSBjb250ZXh0IGlmIHRoZSBsZWFkaW5nIGNvbXBvdW5kIHNlbGVjdG9yIGlzIGFuIElEXG4gICAgICAgICAgdG9rZW5zID0gbWF0Y2hbMF0gPSBtYXRjaFswXS5zbGljZSgwKTtcblxuICAgICAgICAgIGlmICh0b2tlbnMubGVuZ3RoID4gMiAmJiAodG9rZW4gPSB0b2tlbnNbMF0pLnR5cGUgPT09IFwiSURcIiAmJiBjb250ZXh0Lm5vZGVUeXBlID09PSA5ICYmIGRvY3VtZW50SXNIVE1MICYmIEV4cHIucmVsYXRpdmVbdG9rZW5zWzFdLnR5cGVdKSB7XG4gICAgICAgICAgICBjb250ZXh0ID0gKEV4cHIuZmluZFtcIklEXCJdKHRva2VuLm1hdGNoZXNbMF0ucmVwbGFjZShydW5lc2NhcGUsIGZ1bmVzY2FwZSksIGNvbnRleHQpIHx8IFtdKVswXTtcblxuICAgICAgICAgICAgaWYgKCFjb250ZXh0KSB7XG4gICAgICAgICAgICAgIHJldHVybiByZXN1bHRzOyAvLyBQcmVjb21waWxlZCBtYXRjaGVycyB3aWxsIHN0aWxsIHZlcmlmeSBhbmNlc3RyeSwgc28gc3RlcCB1cCBhIGxldmVsXG4gICAgICAgICAgICB9IGVsc2UgaWYgKGNvbXBpbGVkKSB7XG4gICAgICAgICAgICAgIGNvbnRleHQgPSBjb250ZXh0LnBhcmVudE5vZGU7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIHNlbGVjdG9yID0gc2VsZWN0b3Iuc2xpY2UodG9rZW5zLnNoaWZ0KCkudmFsdWUubGVuZ3RoKTtcbiAgICAgICAgICB9IC8vIEZldGNoIGEgc2VlZCBzZXQgZm9yIHJpZ2h0LXRvLWxlZnQgbWF0Y2hpbmdcblxuXG4gICAgICAgICAgaSA9IG1hdGNoRXhwcltcIm5lZWRzQ29udGV4dFwiXS50ZXN0KHNlbGVjdG9yKSA/IDAgOiB0b2tlbnMubGVuZ3RoO1xuXG4gICAgICAgICAgd2hpbGUgKGktLSkge1xuICAgICAgICAgICAgdG9rZW4gPSB0b2tlbnNbaV07IC8vIEFib3J0IGlmIHdlIGhpdCBhIGNvbWJpbmF0b3JcblxuICAgICAgICAgICAgaWYgKEV4cHIucmVsYXRpdmVbdHlwZSA9IHRva2VuLnR5cGVdKSB7XG4gICAgICAgICAgICAgIGJyZWFrO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICBpZiAoZmluZCA9IEV4cHIuZmluZFt0eXBlXSkge1xuICAgICAgICAgICAgICAvLyBTZWFyY2gsIGV4cGFuZGluZyBjb250ZXh0IGZvciBsZWFkaW5nIHNpYmxpbmcgY29tYmluYXRvcnNcbiAgICAgICAgICAgICAgaWYgKHNlZWQgPSBmaW5kKHRva2VuLm1hdGNoZXNbMF0ucmVwbGFjZShydW5lc2NhcGUsIGZ1bmVzY2FwZSksIHJzaWJsaW5nLnRlc3QodG9rZW5zWzBdLnR5cGUpICYmIHRlc3RDb250ZXh0KGNvbnRleHQucGFyZW50Tm9kZSkgfHwgY29udGV4dCkpIHtcbiAgICAgICAgICAgICAgICAvLyBJZiBzZWVkIGlzIGVtcHR5IG9yIG5vIHRva2VucyByZW1haW4sIHdlIGNhbiByZXR1cm4gZWFybHlcbiAgICAgICAgICAgICAgICB0b2tlbnMuc3BsaWNlKGksIDEpO1xuICAgICAgICAgICAgICAgIHNlbGVjdG9yID0gc2VlZC5sZW5ndGggJiYgdG9TZWxlY3Rvcih0b2tlbnMpO1xuXG4gICAgICAgICAgICAgICAgaWYgKCFzZWxlY3Rvcikge1xuICAgICAgICAgICAgICAgICAgcHVzaC5hcHBseShyZXN1bHRzLCBzZWVkKTtcbiAgICAgICAgICAgICAgICAgIHJldHVybiByZXN1bHRzO1xuICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgIGJyZWFrO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfVxuICAgICAgICB9IC8vIENvbXBpbGUgYW5kIGV4ZWN1dGUgYSBmaWx0ZXJpbmcgZnVuY3Rpb24gaWYgb25lIGlzIG5vdCBwcm92aWRlZFxuICAgICAgICAvLyBQcm92aWRlIGBtYXRjaGAgdG8gYXZvaWQgcmV0b2tlbml6YXRpb24gaWYgd2UgbW9kaWZpZWQgdGhlIHNlbGVjdG9yIGFib3ZlXG5cblxuICAgICAgICAoY29tcGlsZWQgfHwgY29tcGlsZShzZWxlY3RvciwgbWF0Y2gpKShzZWVkLCBjb250ZXh0LCAhZG9jdW1lbnRJc0hUTUwsIHJlc3VsdHMsICFjb250ZXh0IHx8IHJzaWJsaW5nLnRlc3Qoc2VsZWN0b3IpICYmIHRlc3RDb250ZXh0KGNvbnRleHQucGFyZW50Tm9kZSkgfHwgY29udGV4dCk7XG4gICAgICAgIHJldHVybiByZXN1bHRzO1xuICAgICAgfTsgLy8gT25lLXRpbWUgYXNzaWdubWVudHNcbiAgICAgIC8vIFNvcnQgc3RhYmlsaXR5XG5cblxuICAgICAgc3VwcG9ydC5zb3J0U3RhYmxlID0gZXhwYW5kby5zcGxpdChcIlwiKS5zb3J0KHNvcnRPcmRlcikuam9pbihcIlwiKSA9PT0gZXhwYW5kbzsgLy8gU3VwcG9ydDogQ2hyb21lIDE0LTM1K1xuICAgICAgLy8gQWx3YXlzIGFzc3VtZSBkdXBsaWNhdGVzIGlmIHRoZXkgYXJlbid0IHBhc3NlZCB0byB0aGUgY29tcGFyaXNvbiBmdW5jdGlvblxuXG4gICAgICBzdXBwb3J0LmRldGVjdER1cGxpY2F0ZXMgPSAhIWhhc0R1cGxpY2F0ZTsgLy8gSW5pdGlhbGl6ZSBhZ2FpbnN0IHRoZSBkZWZhdWx0IGRvY3VtZW50XG5cbiAgICAgIHNldERvY3VtZW50KCk7IC8vIFN1cHBvcnQ6IFdlYmtpdDw1MzcuMzIgLSBTYWZhcmkgNi4wLjMvQ2hyb21lIDI1IChmaXhlZCBpbiBDaHJvbWUgMjcpXG4gICAgICAvLyBEZXRhY2hlZCBub2RlcyBjb25mb3VuZGluZ2x5IGZvbGxvdyAqZWFjaCBvdGhlcipcblxuICAgICAgc3VwcG9ydC5zb3J0RGV0YWNoZWQgPSBhc3NlcnQoZnVuY3Rpb24gKGVsKSB7XG4gICAgICAgIC8vIFNob3VsZCByZXR1cm4gMSwgYnV0IHJldHVybnMgNCAoZm9sbG93aW5nKVxuICAgICAgICByZXR1cm4gZWwuY29tcGFyZURvY3VtZW50UG9zaXRpb24oZG9jdW1lbnQuY3JlYXRlRWxlbWVudChcImZpZWxkc2V0XCIpKSAmIDE7XG4gICAgICB9KTsgLy8gU3VwcG9ydDogSUU8OFxuICAgICAgLy8gUHJldmVudCBhdHRyaWJ1dGUvcHJvcGVydHkgXCJpbnRlcnBvbGF0aW9uXCJcbiAgICAgIC8vIGh0dHBzOi8vbXNkbi5taWNyb3NvZnQuY29tL2VuLXVzL2xpYnJhcnkvbXM1MzY0MjklMjhWUy44NSUyOS5hc3B4XG5cbiAgICAgIGlmICghYXNzZXJ0KGZ1bmN0aW9uIChlbCkge1xuICAgICAgICBlbC5pbm5lckhUTUwgPSBBR1BvbGljeS5jcmVhdGVIVE1MKFwiPGEgaHJlZj0nIyc+PC9hPlwiKTtcbiAgICAgICAgcmV0dXJuIGVsLmZpcnN0Q2hpbGQuZ2V0QXR0cmlidXRlKFwiaHJlZlwiKSA9PT0gXCIjXCI7XG4gICAgICB9KSkge1xuICAgICAgICBhZGRIYW5kbGUoXCJ0eXBlfGhyZWZ8aGVpZ2h0fHdpZHRoXCIsIGZ1bmN0aW9uIChlbGVtLCBuYW1lLCBpc1hNTCkge1xuICAgICAgICAgIGlmICghaXNYTUwpIHtcbiAgICAgICAgICAgIHJldHVybiBlbGVtLmdldEF0dHJpYnV0ZShuYW1lLCBuYW1lLnRvTG93ZXJDYXNlKCkgPT09IFwidHlwZVwiID8gMSA6IDIpO1xuICAgICAgICAgIH1cbiAgICAgICAgfSk7XG4gICAgICB9IC8vIFN1cHBvcnQ6IElFPDlcbiAgICAgIC8vIFVzZSBkZWZhdWx0VmFsdWUgaW4gcGxhY2Ugb2YgZ2V0QXR0cmlidXRlKFwidmFsdWVcIilcblxuXG4gICAgICBpZiAoIXN1cHBvcnQuYXR0cmlidXRlcyB8fCAhYXNzZXJ0KGZ1bmN0aW9uIChlbCkge1xuICAgICAgICBlbC5pbm5lckhUTUwgPSBBR1BvbGljeS5jcmVhdGVIVE1MKFwiPGlucHV0Lz5cIik7XG4gICAgICAgIGVsLmZpcnN0Q2hpbGQuc2V0QXR0cmlidXRlKFwidmFsdWVcIiwgXCJcIik7XG4gICAgICAgIHJldHVybiBlbC5maXJzdENoaWxkLmdldEF0dHJpYnV0ZShcInZhbHVlXCIpID09PSBcIlwiO1xuICAgICAgfSkpIHtcbiAgICAgICAgYWRkSGFuZGxlKFwidmFsdWVcIiwgZnVuY3Rpb24gKGVsZW0sIG5hbWUsIGlzWE1MKSB7XG4gICAgICAgICAgaWYgKCFpc1hNTCAmJiBlbGVtLm5vZGVOYW1lLnRvTG93ZXJDYXNlKCkgPT09IFwiaW5wdXRcIikge1xuICAgICAgICAgICAgcmV0dXJuIGVsZW0uZGVmYXVsdFZhbHVlO1xuICAgICAgICAgIH1cbiAgICAgICAgfSk7XG4gICAgICB9IC8vIFN1cHBvcnQ6IElFPDlcbiAgICAgIC8vIFVzZSBnZXRBdHRyaWJ1dGVOb2RlIHRvIGZldGNoIGJvb2xlYW5zIHdoZW4gZ2V0QXR0cmlidXRlIGxpZXNcblxuXG4gICAgICBpZiAoIWFzc2VydChmdW5jdGlvbiAoZWwpIHtcbiAgICAgICAgcmV0dXJuIGVsLmdldEF0dHJpYnV0ZShcImRpc2FibGVkXCIpID09IG51bGw7XG4gICAgICB9KSkge1xuICAgICAgICBhZGRIYW5kbGUoYm9vbGVhbnMsIGZ1bmN0aW9uIChlbGVtLCBuYW1lLCBpc1hNTCkge1xuICAgICAgICAgIHZhciB2YWw7XG5cbiAgICAgICAgICBpZiAoIWlzWE1MKSB7XG4gICAgICAgICAgICByZXR1cm4gZWxlbVtuYW1lXSA9PT0gdHJ1ZSA/IG5hbWUudG9Mb3dlckNhc2UoKSA6ICh2YWwgPSBlbGVtLmdldEF0dHJpYnV0ZU5vZGUobmFtZSkpICYmIHZhbC5zcGVjaWZpZWQgPyB2YWwudmFsdWUgOiBudWxsO1xuICAgICAgICAgIH1cbiAgICAgICAgfSk7XG4gICAgICB9IC8vIEVYUE9TRVxuICAgICAgLy8gRG8gbm90IGV4cG9zZSBTaXp6bGUgdG8gdGhlIGdsb2JhbCBzY29wZSBpbiB0aGUgY2FzZSBvZiBBZEd1YXJkIEV4dGVuZGVkQ3NzIGJ1aWxkXG5cblxuICAgICAgcmV0dXJuIFNpenpsZTsgLy8gRVhQT1NFXG4gICAgfSh3aW5kb3cpOyAvLz4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+PlxuXG4gIH1cblxuICByZXR1cm4gU2l6emxlO1xufTtcblxuLyoganNoaW50IGlnbm9yZTplbmQgKi9cblxuLyoqXG4gKiBDb3B5cmlnaHQgMjAxNiBBZGd1YXJkIFNvZnR3YXJlIEx0ZFxuICpcbiAqIExpY2Vuc2VkIHVuZGVyIHRoZSBBcGFjaGUgTGljZW5zZSwgVmVyc2lvbiAyLjAgKHRoZSBcIkxpY2Vuc2VcIik7XG4gKiB5b3UgbWF5IG5vdCB1c2UgdGhpcyBmaWxlIGV4Y2VwdCBpbiBjb21wbGlhbmNlIHdpdGggdGhlIExpY2Vuc2UuXG4gKiBZb3UgbWF5IG9idGFpbiBhIGNvcHkgb2YgdGhlIExpY2Vuc2UgYXRcbiAqXG4gKiBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElDRU5TRS0yLjBcbiAqXG4gKiBVbmxlc3MgcmVxdWlyZWQgYnkgYXBwbGljYWJsZSBsYXcgb3IgYWdyZWVkIHRvIGluIHdyaXRpbmcsIHNvZnR3YXJlXG4gKiBkaXN0cmlidXRlZCB1bmRlciB0aGUgTGljZW5zZSBpcyBkaXN0cmlidXRlZCBvbiBhbiBcIkFTIElTXCIgQkFTSVMsXG4gKiBXSVRIT1VUIFdBUlJBTlRJRVMgT1IgQ09ORElUSU9OUyBPRiBBTlkgS0lORCwgZWl0aGVyIGV4cHJlc3Mgb3IgaW1wbGllZC5cbiAqIFNlZSB0aGUgTGljZW5zZSBmb3IgdGhlIHNwZWNpZmljIGxhbmd1YWdlIGdvdmVybmluZyBwZXJtaXNzaW9ucyBhbmRcbiAqIGxpbWl0YXRpb25zIHVuZGVyIHRoZSBMaWNlbnNlLlxuICovXG4vKipcbiAqIENsYXNzIHRoYXQgZXh0ZW5kcyBTaXp6bGUgYW5kIGFkZHMgc3VwcG9ydCBmb3IgXCJtYXRjaGVzLWNzc1wiIHBzZXVkbyBlbGVtZW50LlxuICovXG5cbnZhciBTdHlsZVByb3BlcnR5TWF0Y2hlciA9IGZ1bmN0aW9uICh3aW5kb3cpIHtcbiAgdmFyIGlzUGhhbnRvbSA9ICEhd2luZG93Ll9waGFudG9tO1xuICB2YXIgdXNlRmFsbGJhY2sgPSBpc1BoYW50b20gJiYgISF3aW5kb3cuZ2V0TWF0Y2hlZENTU1J1bGVzO1xuICAvKipcbiAgICogVW5xdW90ZXMgc3BlY2lmaWVkIHZhbHVlXG4gICAqIFdlYmtpdC1iYXNlZCBicm93c2VycyBzaW5nbGVxdW90ZXMgPHN0cmluZz4gY29udGVudCBwcm9wZXJ0eSB2YWx1ZXNcbiAgICogT3RoZXIgYnJvd3NlcnMgZG91YmxlcXVvdGVzIGNvbnRlbnQgcHJvcGVydHkgdmFsdWVzLlxuICAgKi9cblxuICB2YXIgcmVtb3ZlQ29udGVudFF1b3RlcyA9IGZ1bmN0aW9uIHJlbW92ZUNvbnRlbnRRdW90ZXModmFsdWUpIHtcbiAgICBpZiAodHlwZW9mIHZhbHVlID09PSAnc3RyaW5nJykge1xuICAgICAgcmV0dXJuIHZhbHVlLnJlcGxhY2UoL14oW1wiJ10pKFtcXHNcXFNdKilcXDEkLywgJyQyJyk7XG4gICAgfVxuXG4gICAgcmV0dXJuIHZhbHVlO1xuICB9O1xuXG4gIHZhciBnZXRDb21wdXRlZFN0eWxlID0gd2luZG93LmdldENvbXB1dGVkU3R5bGUuYmluZCh3aW5kb3cpO1xuICB2YXIgZ2V0TWF0Y2hlZENTU1J1bGVzID0gdXNlRmFsbGJhY2sgPyB3aW5kb3cuZ2V0TWF0Y2hlZENTU1J1bGVzLmJpbmQod2luZG93KSA6IG51bGw7XG4gIC8qKlxuICAgKiBUaGVyZSBpcyBhbiBpc3N1ZSBpbiBicm93c2VycyBiYXNlZCBvbiBvbGQgd2Via2l0OlxuICAgKiBnZXRDb21wdXRlZFN0eWxlKGVsLCBcIjpiZWZvcmVcIikgaXMgZW1wdHkgaWYgZWxlbWVudCBpcyBub3QgdmlzaWJsZS5cbiAgICpcbiAgICogVG8gY2lyY3VtdmVudCB0aGlzIGlzc3VlIHdlIHVzZSBnZXRNYXRjaGVkQ1NTUnVsZXMgaW5zdGVhZC5cbiAgICpcbiAgICogSXQgYXBwZWFycyB0aGF0IGdldE1hdGNoZWRDU1NSdWxlcyBzb3J0cyB0aGUgQ1NTIHJ1bGVzXG4gICAqIGluIGluY3JlYXNpbmcgb3JkZXIgb2Ygc3BlY2lmaXRpZXMgb2YgY29ycmVzcG9uZGluZyBzZWxlY3RvcnMuXG4gICAqIFdlIHBpY2sgdGhlIGNzcyBydWxlIHRoYXQgaXMgYmVpbmcgYXBwbGllZCB0byBhbiBlbGVtZW50IGJhc2VkIG9uIHRoaXMgYXNzdW1wdGlvbi5cbiAgICpcbiAgICogQHBhcmFtIGVsZW1lbnQgICAgICAgRE9NIG5vZGVcbiAgICogQHBhcmFtIHBzZXVkb0VsZW1lbnQgT3B0aW9uYWwgcHNldWRvRWxlbWVudCBuYW1lXG4gICAqIEBwYXJhbSBwcm9wZXJ0eU5hbWUgIENTUyBwcm9wZXJ0eSBuYW1lXG4gICAqL1xuXG4gIHZhciBnZXRDb21wdXRlZFN0eWxlUHJvcGVydHlWYWx1ZSA9IGZ1bmN0aW9uIGdldENvbXB1dGVkU3R5bGVQcm9wZXJ0eVZhbHVlKGVsZW1lbnQsIHBzZXVkb0VsZW1lbnQsIHByb3BlcnR5TmFtZSkge1xuICAgIHZhciB2YWx1ZSA9ICcnO1xuXG4gICAgaWYgKHVzZUZhbGxiYWNrICYmIHBzZXVkb0VsZW1lbnQpIHtcbiAgICAgIHZhciBjc3NSdWxlcyA9IGdldE1hdGNoZWRDU1NSdWxlcyhlbGVtZW50LCBwc2V1ZG9FbGVtZW50KSB8fCBbXTtcbiAgICAgIHZhciBpID0gY3NzUnVsZXMubGVuZ3RoO1xuXG4gICAgICB3aGlsZSAoaS0tID4gMCAmJiAhdmFsdWUpIHtcbiAgICAgICAgdmFsdWUgPSBjc3NSdWxlc1tpXS5zdHlsZS5nZXRQcm9wZXJ0eVZhbHVlKHByb3BlcnR5TmFtZSk7XG4gICAgICB9XG4gICAgfSBlbHNlIHtcbiAgICAgIHZhciBzdHlsZSA9IGdldENvbXB1dGVkU3R5bGUoZWxlbWVudCwgcHNldWRvRWxlbWVudCk7XG5cbiAgICAgIGlmIChzdHlsZSkge1xuICAgICAgICB2YWx1ZSA9IHN0eWxlLmdldFByb3BlcnR5VmFsdWUocHJvcGVydHlOYW1lKTsgLy8gaHR0cHM6Ly9idWdzLndlYmtpdC5vcmcvc2hvd19idWcuY2dpP2lkPTkzNDQ1XG5cbiAgICAgICAgaWYgKHByb3BlcnR5TmFtZSA9PT0gJ29wYWNpdHknICYmIHV0aWxzLmlzU2FmYXJpQnJvd3Nlcikge1xuICAgICAgICAgIHZhbHVlID0gKE1hdGgucm91bmQocGFyc2VGbG9hdCh2YWx1ZSkgKiAxMDApIC8gMTAwKS50b1N0cmluZygpO1xuICAgICAgICB9XG4gICAgICB9XG4gICAgfVxuXG4gICAgaWYgKHByb3BlcnR5TmFtZSA9PT0gJ2NvbnRlbnQnKSB7XG4gICAgICB2YWx1ZSA9IHJlbW92ZUNvbnRlbnRRdW90ZXModmFsdWUpO1xuICAgIH1cblxuICAgIHJldHVybiB2YWx1ZTtcbiAgfTtcbiAgLyoqXG4gICAqIEFkZHMgdXJsIHBhcmFtZXRlciBxdW90ZXMgZm9yIG5vbi1yZWdleCBwYXR0ZXJuXG4gICAqIEBwYXJhbSB7c3RyaW5nfSBwYXR0ZXJuXG4gICAqL1xuXG5cbiAgdmFyIGFkZFVybFF1b3RlcyA9IGZ1bmN0aW9uIGFkZFVybFF1b3RlcyhwYXR0ZXJuKSB7XG4gICAgLy8gZm9yIHJlZ2V4IHBhdHRlcm5zXG4gICAgaWYgKHBhdHRlcm5bMF0gPT09ICcvJyAmJiBwYXR0ZXJuW3BhdHRlcm4ubGVuZ3RoIC0gMV0gPT09ICcvJyAmJiBwYXR0ZXJuLmluZGV4T2YoJ1xcXFxcIicpIDwgMTApIHtcbiAgICAgIC8vIGUuZy4gL151cmxcXFxcKFthLXpdezR9OlthLXpdezV9L1xuICAgICAgLy8gb3IgL151cmxcXFxcKGRhdGFcXFxcOlxcXFxpbWFnZVxcXFwvZ2lmO2Jhc2U2NC4rL1xuICAgICAgdmFyIHJlID0gLyhcXF4pP3VybChcXFxcKT9cXFxcXFwoKFxcd3xcXFtcXHcpL2c7XG4gICAgICByZXR1cm4gcGF0dGVybi5yZXBsYWNlKHJlLCAnJDF1cmwkMlxcXFxcXChcXFxcXCI/JDMnKTtcbiAgICB9IC8vIGZvciBub24tcmVnZXggcGF0dGVybnNcblxuXG4gICAgaWYgKHBhdHRlcm4uaW5kZXhPZigndXJsKFwiJykgPT09IC0xKSB7XG4gICAgICB2YXIgX3JlID0gL3VybFxcKCguKj8pXFwpL2c7XG4gICAgICByZXR1cm4gcGF0dGVybi5yZXBsYWNlKF9yZSwgJ3VybChcIiQxXCIpJyk7XG4gICAgfVxuXG4gICAgcmV0dXJuIHBhdHRlcm47XG4gIH07XG4gIC8qKlxuICAgKiBDbGFzcyB0aGF0IG1hdGNoZXMgZWxlbWVudCBzdHlsZSBhZ2FpbnN0IHRoZSBzcGVjaWZpZWQgZXhwcmVzc2lvblxuICAgKiBAbWVtYmVyIHtzdHJpbmd9IHByb3BlcnR5TmFtZVxuICAgKiBAbWVtYmVyIHtzdHJpbmd9IHBzZXVkb0VsZW1lbnRcbiAgICogQG1lbWJlciB7UmVnRXhwfSByZWdleFxuICAgKi9cblxuXG4gIHZhciBNYXRjaGVyID0gZnVuY3Rpb24gTWF0Y2hlcihwcm9wZXJ0eUZpbHRlciwgcHNldWRvRWxlbWVudCkge1xuICAgIHRoaXMucHNldWRvRWxlbWVudCA9IHBzZXVkb0VsZW1lbnQ7XG5cbiAgICB0cnkge1xuICAgICAgdmFyIGluZGV4ID0gcHJvcGVydHlGaWx0ZXIuaW5kZXhPZignOicpO1xuICAgICAgdGhpcy5wcm9wZXJ0eU5hbWUgPSBwcm9wZXJ0eUZpbHRlci5zdWJzdHJpbmcoMCwgaW5kZXgpLnRyaW0oKTtcbiAgICAgIHZhciBwYXR0ZXJuID0gcHJvcGVydHlGaWx0ZXIuc3Vic3RyaW5nKGluZGV4ICsgMSkudHJpbSgpO1xuICAgICAgcGF0dGVybiA9IGFkZFVybFF1b3RlcyhwYXR0ZXJuKTsgLy8gVW5lc2NhcGluZyBwYXR0ZXJuXG4gICAgICAvLyBGb3Igbm9uLXJlZ2V4IHBhdHRlcm5zLCAoLCksWyxdIHNob3VsZCBiZSB1bmVzY2FwZWQsIGJlY2F1c2Ugd2UgcmVxdWlyZSBlc2NhcGluZyB0aGVtIGluIGZpbHRlciBydWxlcy5cbiAgICAgIC8vIEZvciByZWdleCBwYXR0ZXJucywgXCIsXFwgc2hvdWxkIGJlIGVzY2FwZWQsIGJlY2F1c2Ugd2UgbWFudWFsbHkgZXNjYXBlIHRob3NlIGluIGV4dGVuZGVkLWNzcy1zZWxlY3Rvci5qcy5cblxuICAgICAgaWYgKC9eXFwvLipcXC8kLy50ZXN0KHBhdHRlcm4pKSB7XG4gICAgICAgIHBhdHRlcm4gPSBwYXR0ZXJuLnNsaWNlKDEsIC0xKTtcbiAgICAgICAgdGhpcy5yZWdleCA9IHV0aWxzLnBzZXVkb0FyZ1RvUmVnZXgocGF0dGVybik7XG4gICAgICB9IGVsc2Uge1xuICAgICAgICBwYXR0ZXJuID0gcGF0dGVybi5yZXBsYWNlKC9cXFxcKFtcXFxcKClbXFxdXCJdKS9nLCAnJDEnKTtcbiAgICAgICAgdGhpcy5yZWdleCA9IHV0aWxzLmNyZWF0ZVVSTFJlZ2V4KHBhdHRlcm4pO1xuICAgICAgfVxuICAgIH0gY2F0Y2ggKGV4KSB7XG4gICAgICB1dGlscy5sb2dFcnJvcihcIlN0eWxlUHJvcGVydHlNYXRjaGVyOiBpbnZhbGlkIG1hdGNoIHN0cmluZyBcIi5jb25jYXQocHJvcGVydHlGaWx0ZXIpKTtcbiAgICB9XG4gIH07XG4gIC8qKlxuICAgKiBGdW5jdGlvbiB0byBjaGVjayBpZiBlbGVtZW50IENTUyBwcm9wZXJ0eSBtYXRjaGVzIGZpbHRlciBwYXR0ZXJuXG4gICAqIEBwYXJhbSB7RWxlbWVudH0gZWxlbWVudCB0byBjaGVja1xuICAgKi9cblxuXG4gIE1hdGNoZXIucHJvdG90eXBlLm1hdGNoZXMgPSBmdW5jdGlvbiAoZWxlbWVudCkge1xuICAgIGlmICghdGhpcy5yZWdleCB8fCAhdGhpcy5wcm9wZXJ0eU5hbWUpIHtcbiAgICAgIHJldHVybiBmYWxzZTtcbiAgICB9XG5cbiAgICB2YXIgdmFsdWUgPSBnZXRDb21wdXRlZFN0eWxlUHJvcGVydHlWYWx1ZShlbGVtZW50LCB0aGlzLnBzZXVkb0VsZW1lbnQsIHRoaXMucHJvcGVydHlOYW1lKTtcbiAgICByZXR1cm4gdmFsdWUgJiYgdGhpcy5yZWdleC50ZXN0KHZhbHVlKTtcbiAgfTtcbiAgLyoqXG4gICAqIENyZWF0ZXMgYSBuZXcgcHNldWRvLWNsYXNzIGFuZCByZWdpc3RlcnMgaXQgaW4gU2l6emxlXG4gICAqL1xuXG5cbiAgdmFyIGV4dGVuZFNpenpsZSA9IGZ1bmN0aW9uIGV4dGVuZFNpenpsZShzaXp6bGUpIHtcbiAgICAvLyBGaXJzdCBvZiBhbGwgd2Ugc2hvdWxkIHByZXBhcmUgU2l6emxlIGVuZ2luZVxuICAgIHNpenpsZS5zZWxlY3RvcnMucHNldWRvc1snbWF0Y2hlcy1jc3MnXSA9IHNpenpsZS5zZWxlY3RvcnMuY3JlYXRlUHNldWRvKGZ1bmN0aW9uIChwcm9wZXJ0eUZpbHRlcikge1xuICAgICAgdmFyIG1hdGNoZXIgPSBuZXcgTWF0Y2hlcihwcm9wZXJ0eUZpbHRlcik7XG4gICAgICByZXR1cm4gZnVuY3Rpb24gKGVsZW1lbnQpIHtcbiAgICAgICAgcmV0dXJuIG1hdGNoZXIubWF0Y2hlcyhlbGVtZW50KTtcbiAgICAgIH07XG4gICAgfSk7XG4gICAgc2l6emxlLnNlbGVjdG9ycy5wc2V1ZG9zWydtYXRjaGVzLWNzcy1iZWZvcmUnXSA9IHNpenpsZS5zZWxlY3RvcnMuY3JlYXRlUHNldWRvKGZ1bmN0aW9uIChwcm9wZXJ0eUZpbHRlcikge1xuICAgICAgdmFyIG1hdGNoZXIgPSBuZXcgTWF0Y2hlcihwcm9wZXJ0eUZpbHRlciwgJzpiZWZvcmUnKTtcbiAgICAgIHJldHVybiBmdW5jdGlvbiAoZWxlbWVudCkge1xuICAgICAgICByZXR1cm4gbWF0Y2hlci5tYXRjaGVzKGVsZW1lbnQpO1xuICAgICAgfTtcbiAgICB9KTtcbiAgICBzaXp6bGUuc2VsZWN0b3JzLnBzZXVkb3NbJ21hdGNoZXMtY3NzLWFmdGVyJ10gPSBzaXp6bGUuc2VsZWN0b3JzLmNyZWF0ZVBzZXVkbyhmdW5jdGlvbiAocHJvcGVydHlGaWx0ZXIpIHtcbiAgICAgIHZhciBtYXRjaGVyID0gbmV3IE1hdGNoZXIocHJvcGVydHlGaWx0ZXIsICc6YWZ0ZXInKTtcbiAgICAgIHJldHVybiBmdW5jdGlvbiAoZWxlbWVudCkge1xuICAgICAgICByZXR1cm4gbWF0Y2hlci5tYXRjaGVzKGVsZW1lbnQpO1xuICAgICAgfTtcbiAgICB9KTtcbiAgfTsgLy8gRVhQT1NFXG5cblxuICByZXR1cm4ge1xuICAgIGV4dGVuZFNpenpsZTogZXh0ZW5kU2l6emxlXG4gIH07XG59KHdpbmRvdyk7XG5cbi8qKlxuICogQ29weXJpZ2h0IDIwMTYgQWRndWFyZCBTb2Z0d2FyZSBMdGRcbiAqXG4gKiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2Vuc2UsIFZlcnNpb24gMi4wICh0aGUgXCJMaWNlbnNlXCIpO1xuICogeW91IG1heSBub3QgdXNlIHRoaXMgZmlsZSBleGNlcHQgaW4gY29tcGxpYW5jZSB3aXRoIHRoZSBMaWNlbnNlLlxuICogWW91IG1heSBvYnRhaW4gYSBjb3B5IG9mIHRoZSBMaWNlbnNlIGF0XG4gKlxuICogaHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wXG4gKlxuICogVW5sZXNzIHJlcXVpcmVkIGJ5IGFwcGxpY2FibGUgbGF3IG9yIGFncmVlZCB0byBpbiB3cml0aW5nLCBzb2Z0d2FyZVxuICogZGlzdHJpYnV0ZWQgdW5kZXIgdGhlIExpY2Vuc2UgaXMgZGlzdHJpYnV0ZWQgb24gYW4gXCJBUyBJU1wiIEJBU0lTLFxuICogV0lUSE9VVCBXQVJSQU5USUVTIE9SIENPTkRJVElPTlMgT0YgQU5ZIEtJTkQsIGVpdGhlciBleHByZXNzIG9yIGltcGxpZWQuXG4gKiBTZWUgdGhlIExpY2Vuc2UgZm9yIHRoZSBzcGVjaWZpYyBsYW5ndWFnZSBnb3Zlcm5pbmcgcGVybWlzc2lvbnMgYW5kXG4gKiBsaW1pdGF0aW9ucyB1bmRlciB0aGUgTGljZW5zZS5cbiAqL1xudmFyIG1hdGNoZXJVdGlscyA9IHt9O1xubWF0Y2hlclV0aWxzLk11dGF0aW9uT2JzZXJ2ZXIgPSB3aW5kb3cuTXV0YXRpb25PYnNlcnZlciB8fCB3aW5kb3cuV2ViS2l0TXV0YXRpb25PYnNlcnZlcjtcbi8qKlxuICogUGFyc2VzIGFyZ3VtZW50IG9mIG1hdGNoZXIgcHNldWRvIChmb3IgbWF0Y2hlcy1hdHRyIGFuZCBtYXRjaGVzLXByb3BlcnR5KVxuICogQHBhcmFtIHtzdHJpbmd9IG1hdGNoZXJGaWx0ZXIgYXJndW1lbnQgb2YgcHNldWRvIGNsYXNzXG4gKiBAcmV0dXJucyB7QXJyYXl9XG4gKi9cblxubWF0Y2hlclV0aWxzLnBhcnNlTWF0Y2hlckZpbHRlciA9IGZ1bmN0aW9uIChtYXRjaGVyRmlsdGVyKSB7XG4gIHZhciBGVUxMX01BVENIX01BUktFUiA9ICdcIj1cIic7XG4gIHZhciByYXdBcmdzID0gW107XG5cbiAgaWYgKG1hdGNoZXJGaWx0ZXIuaW5kZXhPZihGVUxMX01BVENIX01BUktFUikgPT09IC0xKSB7XG4gICAgLy8gaWYgdGhlcmUgaXMgb25seSBvbmUgcHNldWRvIGFyZ1xuICAgIC8vIGUuZy4gOm1hdGNoZXMtYXR0cihcImRhdGEtbmFtZVwiKSBvciA6bWF0Y2hlcy1wcm9wZXJ0eShcImlubmVyLnByb3BcIilcbiAgICAvLyBTaXp6bGUgd2lsbCBwYXJzZSBpdCBhbmQgZ2V0IHJpZCBvZiBxdW90ZXNcbiAgICAvLyBzbyBpdCBtaWdodCBiZSB2YWxpZCBhcmcgYWxyZWFkeSB3aXRob3V0IHRoZW1cbiAgICByYXdBcmdzLnB1c2gobWF0Y2hlckZpbHRlcik7XG4gIH0gZWxzZSB7XG4gICAgbWF0Y2hlckZpbHRlci5zcGxpdCgnPScpLmZvckVhY2goZnVuY3Rpb24gKGFyZykge1xuICAgICAgaWYgKGFyZ1swXSA9PT0gJ1wiJyAmJiBhcmdbYXJnLmxlbmd0aCAtIDFdID09PSAnXCInKSB7XG4gICAgICAgIHJhd0FyZ3MucHVzaChhcmcuc2xpY2UoMSwgLTEpKTtcbiAgICAgIH1cbiAgICB9KTtcbiAgfVxuXG4gIHJldHVybiByYXdBcmdzO1xufTtcbi8qKlxuICogQHR5cGVkZWYge09iamVjdH0gQXJnRGF0YVxuICogQHByb3BlcnR5IHtzdHJpbmd9IGFyZ1xuICogQHByb3BlcnR5IHtib29sZWFufSBpc1JlZ2V4cFxuICovXG5cbi8qKlxuICogUGFyc2VzIHJhdyBtYXRjaGVyIGFyZ1xuICogQHBhcmFtIHtzdHJpbmd9IHJhd0FyZ1xuICogQHJldHVybnMge0FyZ0RhdGF9XG4gKi9cblxuXG5tYXRjaGVyVXRpbHMucGFyc2VSYXdNYXRjaGVyQXJnID0gZnVuY3Rpb24gKHJhd0FyZykge1xuICB2YXIgYXJnID0gcmF3QXJnO1xuICB2YXIgaXNSZWdleHAgPSAhIXJhd0FyZyAmJiByYXdBcmdbMF0gPT09ICcvJyAmJiByYXdBcmdbcmF3QXJnLmxlbmd0aCAtIDFdID09PSAnLyc7XG5cbiAgaWYgKGlzUmVnZXhwKSB7XG4gICAgLy8gdG8gYXZvaWQgYXQgbGVhc3Qgc3VjaCBjYXNlIOKAlCA6bWF0Y2hlcy1wcm9wZXJ0eShcIi8vXCIpXG4gICAgaWYgKHJhd0FyZy5sZW5ndGggPiAyKSB7XG4gICAgICBhcmcgPSB1dGlscy50b1JlZ0V4cChyYXdBcmcpO1xuICAgIH0gZWxzZSB7XG4gICAgICB0aHJvdyBuZXcgRXJyb3IoXCJJbnZhbGlkIHJlZ2V4cDogXCIuY29uY2F0KHJhd0FyZykpO1xuICAgIH1cbiAgfVxuXG4gIHJldHVybiB7XG4gICAgYXJnOiBhcmcsXG4gICAgaXNSZWdleHA6IGlzUmVnZXhwXG4gIH07XG59O1xuLyoqXG4gKiBAdHlwZWRlZiBDaGFpblxuICogQHByb3BlcnR5IHtPYmplY3R9IGJhc2VcbiAqIEBwcm9wZXJ0eSB7c3RyaW5nfSBwcm9wXG4gKiBAcHJvcGVydHkge3N0cmluZ30gdmFsdWVcbiAqL1xuXG4vKipcbiAqIENoZWNrcyBpZiB0aGUgcHJvcGVydHkgZXhpc3RzIGluIHRoZSBiYXNlIG9iamVjdCAocmVjdXJzaXZlbHkpLlxuICogQHBhcmFtIHtPYmplY3R9IGJhc2VcbiAqIEBwYXJhbSB7QXJnRGF0YVtdfSBjaGFpbiBhcnJheSBvZiBvYmplY3RzIC0gcGFyc2VkIHN0cmluZyBwcm9wZXJ0eSBjaGFpblxuICogQHBhcmFtIHtBcnJheX0gW291dHB1dD1bXV0gcmVzdWx0IGFjY1xuICogQHJldHVybnMge0NoYWluW119IGFycmF5IG9mIG9iamVjdHNcbiAqL1xuXG5cbm1hdGNoZXJVdGlscy5maWx0ZXJSb290c0J5UmVnZXhwQ2hhaW4gPSBmdW5jdGlvbiAoYmFzZSwgY2hhaW4pIHtcbiAgdmFyIG91dHB1dCA9IGFyZ3VtZW50cy5sZW5ndGggPiAyICYmIGFyZ3VtZW50c1syXSAhPT0gdW5kZWZpbmVkID8gYXJndW1lbnRzWzJdIDogW107XG4gIHZhciB0ZW1wUHJvcCA9IGNoYWluWzBdO1xuXG4gIGlmIChjaGFpbi5sZW5ndGggPT09IDEpIHtcbiAgICAvLyBlc2xpbnQtZGlzYWJsZS1uZXh0LWxpbmUgbm8tcmVzdHJpY3RlZC1zeW50YXhcbiAgICBmb3IgKHZhciBrZXkgaW4gYmFzZSkge1xuICAgICAgaWYgKHRlbXBQcm9wLmlzUmVnZXhwKSB7XG4gICAgICAgIGlmICh0ZW1wUHJvcC5hcmcudGVzdChrZXkpKSB7XG4gICAgICAgICAgb3V0cHV0LnB1c2goe1xuICAgICAgICAgICAgYmFzZTogYmFzZSxcbiAgICAgICAgICAgIHByb3A6IGtleSxcbiAgICAgICAgICAgIHZhbHVlOiBiYXNlW2tleV1cbiAgICAgICAgICB9KTtcbiAgICAgICAgfVxuICAgICAgfSBlbHNlIGlmICh0ZW1wUHJvcC5hcmcgPT09IGtleSkge1xuICAgICAgICBvdXRwdXQucHVzaCh7XG4gICAgICAgICAgYmFzZTogYmFzZSxcbiAgICAgICAgICBwcm9wOiB0ZW1wUHJvcC5hcmcsXG4gICAgICAgICAgdmFsdWU6IGJhc2Vba2V5XVxuICAgICAgICB9KTtcbiAgICAgIH1cbiAgICB9XG5cbiAgICByZXR1cm4gb3V0cHV0O1xuICB9IC8vIGlmIHRoZXJlIGlzIGEgcmVnZXhwIHByb3AgaW4gaW5wdXQgY2hhaW5cbiAgLy8gZS5nLiAndW5pdC4vXmFkLisvLnNyYycgZm9yICd1bml0LmFkLTFnZjIuc3JjIHVuaXQuYWQtZmdkMzQuc3JjJyksXG4gIC8vIGV2ZXJ5IGJhc2Uga2V5cyBzaG91bGQgYmUgdGVzdGVkIGJ5IHJlZ2V4cCBhbmQgaXQgY2FuIGJlIG1vcmUgdGhhdCBvbmUgcmVzdWx0c1xuXG5cbiAgaWYgKHRlbXBQcm9wLmlzUmVnZXhwKSB7XG4gICAgdmFyIG5leHRQcm9wID0gY2hhaW4uc2xpY2UoMSk7XG4gICAgdmFyIGJhc2VLZXlzID0gW107IC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBuby1yZXN0cmljdGVkLXN5bnRheFxuXG4gICAgZm9yICh2YXIgX2tleSBpbiBiYXNlKSB7XG4gICAgICBpZiAodGVtcFByb3AuYXJnLnRlc3QoX2tleSkpIHtcbiAgICAgICAgYmFzZUtleXMucHVzaChfa2V5KTtcbiAgICAgIH1cbiAgICB9XG5cbiAgICBiYXNlS2V5cy5mb3JFYWNoKGZ1bmN0aW9uIChrZXkpIHtcbiAgICAgIHZhciBpdGVtID0gYmFzZVtrZXldO1xuICAgICAgbWF0Y2hlclV0aWxzLmZpbHRlclJvb3RzQnlSZWdleHBDaGFpbihpdGVtLCBuZXh0UHJvcCwgb3V0cHV0KTtcbiAgICB9KTtcbiAgfSAvLyBhdm9pZCBUeXBlRXJyb3Igd2hpbGUgYWNjZXNzaW5nIHRvIG51bGwtcHJvcCdzIGNoaWxkXG5cblxuICBpZiAoYmFzZSA9PT0gbnVsbCkge1xuICAgIHJldHVybjtcbiAgfVxuXG4gIHZhciBuZXh0QmFzZSA9IGJhc2VbdGVtcFByb3AuYXJnXTtcbiAgY2hhaW4gPSBjaGFpbi5zbGljZSgxKTtcblxuICBpZiAobmV4dEJhc2UgIT09IHVuZGVmaW5lZCkge1xuICAgIG1hdGNoZXJVdGlscy5maWx0ZXJSb290c0J5UmVnZXhwQ2hhaW4obmV4dEJhc2UsIGNoYWluLCBvdXRwdXQpO1xuICB9XG5cbiAgcmV0dXJuIG91dHB1dDtcbn07XG4vKipcbiAqIFZhbGlkYXRlcyBwYXJzZWQgYXJncyBvZiBtYXRjaGVzLXByb3BlcnR5IHBzZXVkb1xuICogQHBhcmFtIHsuLi5BcmdEYXRhfSBhcmdzXG4gKi9cblxuXG5tYXRjaGVyVXRpbHMudmFsaWRhdGVQcm9wTWF0Y2hlckFyZ3MgPSBmdW5jdGlvbiAoKSB7XG4gIGZvciAodmFyIF9sZW4gPSBhcmd1bWVudHMubGVuZ3RoLCBhcmdzID0gbmV3IEFycmF5KF9sZW4pLCBfa2V5MiA9IDA7IF9rZXkyIDwgX2xlbjsgX2tleTIrKykge1xuICAgIGFyZ3NbX2tleTJdID0gYXJndW1lbnRzW19rZXkyXTtcbiAgfVxuXG4gIGZvciAodmFyIGkgPSAwOyBpIDwgYXJncy5sZW5ndGg7IGkgKz0gMSkge1xuICAgIGlmIChhcmdzW2ldLmlzUmVnZXhwKSB7XG4gICAgICBpZiAoIXV0aWxzLnN0YXJ0c1dpdGgoYXJnc1tpXS5hcmcudG9TdHJpbmcoKSwgJy8nKSB8fCAhdXRpbHMuZW5kc1dpdGgoYXJnc1tpXS5hcmcudG9TdHJpbmcoKSwgJy8nKSkge1xuICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICB9IC8vIHNpbXBsZSBhcmcgY2hlY2sgaWYgaXQgaXMgbm90IGEgcmVnZXhwXG5cbiAgICB9IGVsc2UgaWYgKCEvXltcXHctXSskLy50ZXN0KGFyZ3NbaV0uYXJnKSkge1xuICAgICAgcmV0dXJuIGZhbHNlO1xuICAgIH1cbiAgfVxuXG4gIHJldHVybiB0cnVlO1xufTtcblxuLyoqXG4gKiBDbGFzcyB0aGF0IGV4dGVuZHMgU2l6emxlIGFuZCBhZGRzIHN1cHBvcnQgZm9yIFwibWF0Y2hlcy1hdHRyXCIgcHNldWRvIGVsZW1lbnQuXG4gKi9cblxudmFyIEF0dHJpYnV0ZXNNYXRjaGVyID0gZnVuY3Rpb24gKCkge1xuICAvKipcbiAgICogQ2xhc3MgdGhhdCBtYXRjaGVzIGVsZW1lbnQgYXR0cmlidXRlcyBhZ2FpbnN0IHRoZSBzcGVjaWZpZWQgZXhwcmVzc2lvbnNcbiAgICogQHBhcmFtIHtBcmdEYXRhfSBuYW1lQXJnIC0gcGFyc2VkIG5hbWUgYXJndW1lbnRcbiAgICogQHBhcmFtIHtBcmdEYXRhfSB2YWx1ZUFyZyAtIHBhcnNlZCB2YWx1ZSBhcmd1bWVudFxuICAgKiBAcGFyYW0ge3N0cmluZ30gcHNldWRvRWxlbWVudFxuICAgKiBAY29uc3RydWN0b3JcbiAgICpcbiAgICogQG1lbWJlciB7c3RyaW5nfFJlZ0V4cH0gYXR0ck5hbWVcbiAgICogQG1lbWJlciB7Ym9vbGVhbn0gaXNSZWdleHBOYW1lXG4gICAqIEBtZW1iZXIge3N0cmluZ3xSZWdFeHB9IGF0dHJWYWx1ZVxuICAgKiBAbWVtYmVyIHtib29sZWFufSBpc1JlZ2V4cFZhbHVlXG4gICAqL1xuICB2YXIgQXR0ck1hdGNoZXIgPSBmdW5jdGlvbiBBdHRyTWF0Y2hlcihuYW1lQXJnLCB2YWx1ZUFyZywgcHNldWRvRWxlbWVudCkge1xuICAgIHRoaXMucHNldWRvRWxlbWVudCA9IHBzZXVkb0VsZW1lbnQ7XG4gICAgdGhpcy5hdHRyTmFtZSA9IG5hbWVBcmcuYXJnO1xuICAgIHRoaXMuaXNSZWdleHBOYW1lID0gbmFtZUFyZy5pc1JlZ2V4cDtcbiAgICB0aGlzLmF0dHJWYWx1ZSA9IHZhbHVlQXJnLmFyZztcbiAgICB0aGlzLmlzUmVnZXhwVmFsdWUgPSB2YWx1ZUFyZy5pc1JlZ2V4cDtcbiAgfTtcbiAgLyoqXG4gICAqIEZ1bmN0aW9uIHRvIGNoZWNrIGlmIGVsZW1lbnQgYXR0cmlidXRlcyBtYXRjaGVzIGZpbHRlciBwYXR0ZXJuXG4gICAqIEBwYXJhbSB7RWxlbWVudH0gZWxlbWVudCB0byBjaGVja1xuICAgKi9cblxuXG4gIEF0dHJNYXRjaGVyLnByb3RvdHlwZS5tYXRjaGVzID0gZnVuY3Rpb24gKGVsZW1lbnQpIHtcbiAgICB2YXIgZWxBdHRycyA9IGVsZW1lbnQuYXR0cmlidXRlcztcblxuICAgIGlmIChlbEF0dHJzLmxlbmd0aCA9PT0gMCB8fCAhdGhpcy5hdHRyTmFtZSkge1xuICAgICAgcmV0dXJuIGZhbHNlO1xuICAgIH1cblxuICAgIHZhciBpID0gMDtcblxuICAgIHdoaWxlIChpIDwgZWxBdHRycy5sZW5ndGgpIHtcbiAgICAgIHZhciBhdHRyID0gZWxBdHRyc1tpXTtcbiAgICAgIHZhciBtYXRjaGVkID0gZmFsc2U7XG4gICAgICB2YXIgYXR0ck5hbWVNYXRjaGVkID0gdGhpcy5pc1JlZ2V4cE5hbWUgPyB0aGlzLmF0dHJOYW1lLnRlc3QoYXR0ci5uYW1lKSA6IHRoaXMuYXR0ck5hbWUgPT09IGF0dHIubmFtZTtcblxuICAgICAgaWYgKCF0aGlzLmF0dHJWYWx1ZSkge1xuICAgICAgICAvLyBmb3IgOm1hdGNoZXMtYXR0cihcIi9yZWdleC9cIikgb3IgOm1hdGNoZXMtYXR0cihcImF0dHItbmFtZVwiKVxuICAgICAgICBtYXRjaGVkID0gYXR0ck5hbWVNYXRjaGVkO1xuICAgICAgfSBlbHNlIHtcbiAgICAgICAgdmFyIGF0dHJWYWx1ZU1hdGNoZWQgPSB0aGlzLmlzUmVnZXhwVmFsdWUgPyB0aGlzLmF0dHJWYWx1ZS50ZXN0KGF0dHIudmFsdWUpIDogdGhpcy5hdHRyVmFsdWUgPT09IGF0dHIudmFsdWU7XG4gICAgICAgIG1hdGNoZWQgPSBhdHRyTmFtZU1hdGNoZWQgJiYgYXR0clZhbHVlTWF0Y2hlZDtcbiAgICAgIH1cblxuICAgICAgaWYgKG1hdGNoZWQpIHtcbiAgICAgICAgcmV0dXJuIHRydWU7XG4gICAgICB9XG5cbiAgICAgIGkgKz0gMTtcbiAgICB9XG4gIH07XG4gIC8qKlxuICAgKiBDcmVhdGVzIGEgbmV3IHBzZXVkby1jbGFzcyBhbmQgcmVnaXN0ZXJzIGl0IGluIFNpenpsZVxuICAgKi9cblxuXG4gIHZhciBleHRlbmRTaXp6bGUgPSBmdW5jdGlvbiBleHRlbmRTaXp6bGUoc2l6emxlKSB7XG4gICAgLy8gRmlyc3Qgb2YgYWxsIHdlIHNob3VsZCBwcmVwYXJlIFNpenpsZSBlbmdpbmVcbiAgICBzaXp6bGUuc2VsZWN0b3JzLnBzZXVkb3NbJ21hdGNoZXMtYXR0ciddID0gc2l6emxlLnNlbGVjdG9ycy5jcmVhdGVQc2V1ZG8oZnVuY3Rpb24gKGF0dHJGaWx0ZXIpIHtcbiAgICAgIHZhciBfbWF0Y2hlclV0aWxzJHBhcnNlTWEgPSBtYXRjaGVyVXRpbHMucGFyc2VNYXRjaGVyRmlsdGVyKGF0dHJGaWx0ZXIpLFxuICAgICAgICAgIF9tYXRjaGVyVXRpbHMkcGFyc2VNYTIgPSBfc2xpY2VkVG9BcnJheShfbWF0Y2hlclV0aWxzJHBhcnNlTWEsIDIpLFxuICAgICAgICAgIHJhd05hbWUgPSBfbWF0Y2hlclV0aWxzJHBhcnNlTWEyWzBdLFxuICAgICAgICAgIHJhd1ZhbHVlID0gX21hdGNoZXJVdGlscyRwYXJzZU1hMlsxXTtcblxuICAgICAgdmFyIG5hbWVBcmcgPSBtYXRjaGVyVXRpbHMucGFyc2VSYXdNYXRjaGVyQXJnKHJhd05hbWUpO1xuICAgICAgdmFyIHZhbHVlQXJnID0gbWF0Y2hlclV0aWxzLnBhcnNlUmF3TWF0Y2hlckFyZyhyYXdWYWx1ZSk7XG5cbiAgICAgIGlmICghYXR0ckZpbHRlciB8fCAhbWF0Y2hlclV0aWxzLnZhbGlkYXRlUHJvcE1hdGNoZXJBcmdzKG5hbWVBcmcsIHZhbHVlQXJnKSkge1xuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJJbnZhbGlkIGFyZ3VtZW50IG9mIDptYXRjaGVzLWF0dHIgcHNldWRvIGNsYXNzOiBcIi5jb25jYXQoYXR0ckZpbHRlcikpO1xuICAgICAgfVxuXG4gICAgICB2YXIgbWF0Y2hlciA9IG5ldyBBdHRyTWF0Y2hlcihuYW1lQXJnLCB2YWx1ZUFyZyk7XG4gICAgICByZXR1cm4gZnVuY3Rpb24gKGVsZW1lbnQpIHtcbiAgICAgICAgcmV0dXJuIG1hdGNoZXIubWF0Y2hlcyhlbGVtZW50KTtcbiAgICAgIH07XG4gICAgfSk7XG4gIH07IC8vIEVYUE9TRVxuXG5cbiAgcmV0dXJuIHtcbiAgICBleHRlbmRTaXp6bGU6IGV4dGVuZFNpenpsZVxuICB9O1xufSgpO1xuXG4vKipcbiAqIFBhcnNlcyByYXcgcHJvcGVydHkgYXJnXG4gKiBAcGFyYW0ge3N0cmluZ30gaW5wdXRcbiAqIEByZXR1cm5zIHtBcmdEYXRhW119IGFycmF5IG9mIG9iamVjdHNcbiAqL1xuXG52YXIgcGFyc2VSYXdQcm9wQ2hhaW4gPSBmdW5jdGlvbiBwYXJzZVJhd1Byb3BDaGFpbihpbnB1dCkge1xuICB2YXIgUFJPUFNfRElWSURFUiA9ICcuJztcbiAgdmFyIFJFR0VYUF9NQVJLRVIgPSAnLyc7XG4gIHZhciBwcm9wc0FyciA9IFtdO1xuICB2YXIgc3RyID0gaW5wdXQ7XG5cbiAgd2hpbGUgKHN0ci5sZW5ndGggPiAwKSB7XG4gICAgaWYgKHV0aWxzLnN0YXJ0c1dpdGgoc3RyLCBQUk9QU19ESVZJREVSKSkge1xuICAgICAgLy8gZm9yIGNhc2VzIGxpa2UgJy5wcm9wLmlkJyBhbmQgJ25lc3RlZC4udGVzdCdcbiAgICAgIHRocm93IG5ldyBFcnJvcihcIkludmFsaWQgY2hhaW4gcHJvcGVydHk6IFwiLmNvbmNhdChpbnB1dCkpO1xuICAgIH1cblxuICAgIGlmICghdXRpbHMuc3RhcnRzV2l0aChzdHIsIFJFR0VYUF9NQVJLRVIpKSB7XG4gICAgICB2YXIgaXNSZWdleHAgPSBmYWxzZTtcbiAgICAgIHZhciBkaXZpZGVySW5kZXggPSBzdHIuaW5kZXhPZihQUk9QU19ESVZJREVSKTtcblxuICAgICAgaWYgKHN0ci5pbmRleE9mKFBST1BTX0RJVklERVIpID09PSAtMSkge1xuICAgICAgICAvLyBpZiB0aGVyZSBpcyBubyAnLicgbGVmdCBpbiBzdHJcbiAgICAgICAgLy8gdGFrZSB0aGUgcmVzdCBvZiBzdHIgYXMgcHJvcFxuICAgICAgICBwcm9wc0Fyci5wdXNoKHtcbiAgICAgICAgICBhcmc6IHN0cixcbiAgICAgICAgICBpc1JlZ2V4cDogaXNSZWdleHBcbiAgICAgICAgfSk7XG4gICAgICAgIHJldHVybiBwcm9wc0FycjtcbiAgICAgIH0gLy8gZWxzZSB0YWtlIHByb3AgZnJvbSBzdHJcblxuXG4gICAgICB2YXIgcHJvcCA9IHN0ci5zbGljZSgwLCBkaXZpZGVySW5kZXgpOyAvLyBmb3IgY2FzZXMgbGlrZSAnYXNhZGYuPysvLnRlc3QnXG5cbiAgICAgIGlmIChwcm9wLmluZGV4T2YoUkVHRVhQX01BUktFUikgPiAtMSkge1xuICAgICAgICAvLyBwcm9wIGlzICc/Ky8nXG4gICAgICAgIHRocm93IG5ldyBFcnJvcihcIkludmFsaWQgY2hhaW4gcHJvcGVydHk6IFwiLmNvbmNhdChwcm9wKSk7XG4gICAgICB9XG5cbiAgICAgIHByb3BzQXJyLnB1c2goe1xuICAgICAgICBhcmc6IHByb3AsXG4gICAgICAgIGlzUmVnZXhwOiBpc1JlZ2V4cFxuICAgICAgfSk7IC8vIGRlbGV0ZSBwcm9wIGZyb20gc3RyXG5cbiAgICAgIHN0ciA9IHN0ci5zbGljZShkaXZpZGVySW5kZXgpO1xuICAgIH0gZWxzZSB7XG4gICAgICAvLyBkZWFsIHdpdGggcmVnZXhwXG4gICAgICB2YXIgcHJvcENodW5rcyA9IFtdO1xuICAgICAgcHJvcENodW5rcy5wdXNoKHN0ci5zbGljZSgwLCAxKSk7IC8vIGlmIHN0ciBzdGFydHMgd2l0aCAnLycsIGRlbGV0ZSBpdCBmcm9tIHN0ciBhbmQgZmluZCBjbG9zaW5nIHJlZ2V4cCBzbGFzaC5cbiAgICAgIC8vIG5vdGUgdGhhdCBjaGFpbmVkIHByb3BlcnR5IG5hbWUgY2FuIG5vdCBpbmNsdWRlICcvJyBvciAnLidcbiAgICAgIC8vIHNvIHRoZXJlIGlzIG5vIGNoZWNraW5nIGZvciBlc2NhcGVkIGNoYXJhY3RlcnNcblxuICAgICAgc3RyID0gc3RyLnNsaWNlKDEpO1xuICAgICAgdmFyIHJlZ2V4RW5kSW5kZXggPSBzdHIuaW5kZXhPZihSRUdFWFBfTUFSS0VSKTtcblxuICAgICAgaWYgKHJlZ2V4RW5kSW5kZXggPCAxKSB7XG4gICAgICAgIC8vIHJlZ2V4cCBzaG91bGQgYmUgYXQgbGVhc3QgPT09ICcvLi8nXG4gICAgICAgIC8vIHNvIHdlIHNob3VsZCBhdm9pZCBhcmdzIGxpa2UgJy9pZCcgYW5kICd0ZXN0Li8vLmlkJ1xuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJJbnZhbGlkIHJlZ2V4cDogXCIuY29uY2F0KFJFR0VYUF9NQVJLRVIpLmNvbmNhdChzdHIpKTtcbiAgICAgIH1cblxuICAgICAgdmFyIF9pc1JlZ2V4cCA9IHRydWU7IC8vIHRha2UgdGhlIHJlc3QgcmVnZXhwIHBhcnRcblxuICAgICAgcHJvcENodW5rcy5wdXNoKHN0ci5zbGljZSgwLCByZWdleEVuZEluZGV4ICsgMSkpO1xuXG4gICAgICB2YXIgX3Byb3AgPSB1dGlscy50b1JlZ0V4cChwcm9wQ2h1bmtzLmpvaW4oJycpKTtcblxuICAgICAgcHJvcHNBcnIucHVzaCh7XG4gICAgICAgIGFyZzogX3Byb3AsXG4gICAgICAgIGlzUmVnZXhwOiBfaXNSZWdleHBcbiAgICAgIH0pOyAvLyBkZWxldGUgcHJvcCBmcm9tIHN0clxuXG4gICAgICBzdHIgPSBzdHIuc2xpY2UocmVnZXhFbmRJbmRleCArIDEpO1xuICAgIH1cblxuICAgIGlmICghc3RyKSB7XG4gICAgICByZXR1cm4gcHJvcHNBcnI7XG4gICAgfSAvLyBzdHIgc2hvdWxkIGJlIGxpa2UgJy5uZXh0UHJvcCcgbm93XG4gICAgLy8gc28gJ3p4LnByb3AnIG9yICcuJyBpcyBpbnZhbGlkXG5cblxuICAgIGlmICghdXRpbHMuc3RhcnRzV2l0aChzdHIsIFBST1BTX0RJVklERVIpIHx8IHV0aWxzLnN0YXJ0c1dpdGgoc3RyLCBQUk9QU19ESVZJREVSKSAmJiBzdHIubGVuZ3RoID09PSAxKSB7XG4gICAgICB0aHJvdyBuZXcgRXJyb3IoXCJJbnZhbGlkIGNoYWluIHByb3BlcnR5OiBcIi5jb25jYXQoaW5wdXQpKTtcbiAgICB9XG5cbiAgICBzdHIgPSBzdHIuc2xpY2UoMSk7XG4gIH1cbn07XG5cbnZhciBjb252ZXJ0VHlwZUZyb21TdHIgPSBmdW5jdGlvbiBjb252ZXJ0VHlwZUZyb21TdHIodmFsdWUpIHtcbiAgdmFyIG51bVZhbHVlID0gTnVtYmVyKHZhbHVlKTtcbiAgdmFyIG91dHB1dDtcblxuICBpZiAoIU51bWJlci5pc05hTihudW1WYWx1ZSkpIHtcbiAgICBvdXRwdXQgPSBudW1WYWx1ZTtcbiAgfSBlbHNlIHtcbiAgICBzd2l0Y2ggKHZhbHVlKSB7XG4gICAgICBjYXNlICd1bmRlZmluZWQnOlxuICAgICAgICBvdXRwdXQgPSB1bmRlZmluZWQ7XG4gICAgICAgIGJyZWFrO1xuXG4gICAgICBjYXNlICdudWxsJzpcbiAgICAgICAgb3V0cHV0ID0gbnVsbDtcbiAgICAgICAgYnJlYWs7XG5cbiAgICAgIGNhc2UgJ3RydWUnOlxuICAgICAgICBvdXRwdXQgPSB0cnVlO1xuICAgICAgICBicmVhaztcblxuICAgICAgY2FzZSAnZmFsc2UnOlxuICAgICAgICBvdXRwdXQgPSBmYWxzZTtcbiAgICAgICAgYnJlYWs7XG5cbiAgICAgIGRlZmF1bHQ6XG4gICAgICAgIG91dHB1dCA9IHZhbHVlO1xuICAgIH1cbiAgfVxuXG4gIHJldHVybiBvdXRwdXQ7XG59O1xuXG52YXIgY29udmVydFR5cGVJbnRvU3RyID0gZnVuY3Rpb24gY29udmVydFR5cGVJbnRvU3RyKHZhbHVlKSB7XG4gIHZhciBvdXRwdXQ7XG5cbiAgc3dpdGNoICh2YWx1ZSkge1xuICAgIGNhc2UgdW5kZWZpbmVkOlxuICAgICAgb3V0cHV0ID0gJ3VuZGVmaW5lZCc7XG4gICAgICBicmVhaztcblxuICAgIGNhc2UgbnVsbDpcbiAgICAgIG91dHB1dCA9ICdudWxsJztcbiAgICAgIGJyZWFrO1xuXG4gICAgZGVmYXVsdDpcbiAgICAgIG91dHB1dCA9IHZhbHVlLnRvU3RyaW5nKCk7XG4gIH1cblxuICByZXR1cm4gb3V0cHV0O1xufTtcbi8qKlxuICogQ2xhc3MgdGhhdCBleHRlbmRzIFNpenpsZSBhbmQgYWRkcyBzdXBwb3J0IGZvciBcIm1hdGNoZXMtcHJvcGVydHlcIiBwc2V1ZG8gZWxlbWVudC5cbiAqL1xuXG5cbnZhciBFbGVtZW50UHJvcGVydHlNYXRjaGVyID0gZnVuY3Rpb24gKCkge1xuICAvKipcbiAgICogQ2xhc3MgdGhhdCBtYXRjaGVzIGVsZW1lbnQgcHJvcGVydGllcyBhZ2FpbnN0IHRoZSBzcGVjaWZpZWQgZXhwcmVzc2lvbnNcbiAgICogQHBhcmFtIHtBcmdEYXRhW119IHByb3BzQ2hhaW5BcmcgLSBhcnJheSBvZiBwYXJzZWQgcHJvcHMgY2hhaW4gb2JqZWN0c1xuICAgKiBAcGFyYW0ge0FyZ0RhdGF9IHZhbHVlQXJnIC0gcGFyc2VkIHZhbHVlIGFyZ3VtZW50XG4gICAqIEBwYXJhbSB7c3RyaW5nfSBwc2V1ZG9FbGVtZW50XG4gICAqIEBjb25zdHJ1Y3RvclxuICAgKlxuICAgKiBAbWVtYmVyIHtBcnJheX0gY2hhaW5lZFByb3BzXG4gICAqIEBtZW1iZXIge2Jvb2xlYW59IGlzUmVnZXhwTmFtZVxuICAgKiBAbWVtYmVyIHtzdHJpbmd8UmVnRXhwfSBwcm9wVmFsdWVcbiAgICogQG1lbWJlciB7Ym9vbGVhbn0gaXNSZWdleHBWYWx1ZVxuICAgKi9cbiAgdmFyIFByb3BNYXRjaGVyID0gZnVuY3Rpb24gUHJvcE1hdGNoZXIocHJvcHNDaGFpbkFyZywgdmFsdWVBcmcsIHBzZXVkb0VsZW1lbnQpIHtcbiAgICB0aGlzLnBzZXVkb0VsZW1lbnQgPSBwc2V1ZG9FbGVtZW50O1xuICAgIHRoaXMuY2hhaW5lZFByb3BzID0gcHJvcHNDaGFpbkFyZztcbiAgICB0aGlzLnByb3BWYWx1ZSA9IHZhbHVlQXJnLmFyZztcbiAgICB0aGlzLmlzUmVnZXhwVmFsdWUgPSB2YWx1ZUFyZy5pc1JlZ2V4cDtcbiAgfTtcbiAgLyoqXG4gICAqIEZ1bmN0aW9uIHRvIGNoZWNrIGlmIGVsZW1lbnQgcHJvcGVydGllcyBtYXRjaGVzIGZpbHRlciBwYXR0ZXJuXG4gICAqIEBwYXJhbSB7RWxlbWVudH0gZWxlbWVudCB0byBjaGVja1xuICAgKi9cblxuXG4gIFByb3BNYXRjaGVyLnByb3RvdHlwZS5tYXRjaGVzID0gZnVuY3Rpb24gKGVsZW1lbnQpIHtcbiAgICB2YXIgb3duZXJPYmpBcnIgPSBtYXRjaGVyVXRpbHMuZmlsdGVyUm9vdHNCeVJlZ2V4cENoYWluKGVsZW1lbnQsIHRoaXMuY2hhaW5lZFByb3BzKTtcblxuICAgIGlmIChvd25lck9iakFyci5sZW5ndGggPT09IDApIHtcbiAgICAgIHJldHVybiBmYWxzZTtcbiAgICB9XG5cbiAgICB2YXIgbWF0Y2hlZCA9IHRydWU7XG5cbiAgICBpZiAodGhpcy5wcm9wVmFsdWUpIHtcbiAgICAgIGZvciAodmFyIGkgPSAwOyBpIDwgb3duZXJPYmpBcnIubGVuZ3RoOyBpICs9IDEpIHtcbiAgICAgICAgdmFyIHJlYWxWYWx1ZSA9IG93bmVyT2JqQXJyW2ldLnZhbHVlO1xuXG4gICAgICAgIGlmICh0aGlzLmlzUmVnZXhwVmFsdWUpIHtcbiAgICAgICAgICBtYXRjaGVkID0gdGhpcy5wcm9wVmFsdWUudGVzdChjb252ZXJ0VHlwZUludG9TdHIocmVhbFZhbHVlKSk7XG4gICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgLy8gaGFuZGxlICdudWxsJyBhbmQgJ3VuZGVmaW5lZCcgcHJvcGVydHkgdmFsdWVzIHNldCBhcyBzdHJpbmdcbiAgICAgICAgICBpZiAocmVhbFZhbHVlID09PSAnbnVsbCcgfHwgcmVhbFZhbHVlID09PSAndW5kZWZpbmVkJykge1xuICAgICAgICAgICAgbWF0Y2hlZCA9IHRoaXMucHJvcFZhbHVlID09PSByZWFsVmFsdWU7XG4gICAgICAgICAgICBicmVhaztcbiAgICAgICAgICB9XG5cbiAgICAgICAgICBtYXRjaGVkID0gY29udmVydFR5cGVGcm9tU3RyKHRoaXMucHJvcFZhbHVlKSA9PT0gcmVhbFZhbHVlO1xuICAgICAgICB9XG5cbiAgICAgICAgaWYgKG1hdGNoZWQpIHtcbiAgICAgICAgICBicmVhaztcbiAgICAgICAgfVxuICAgICAgfVxuICAgIH1cblxuICAgIHJldHVybiBtYXRjaGVkO1xuICB9O1xuICAvKipcbiAgICogQ3JlYXRlcyBhIG5ldyBwc2V1ZG8tY2xhc3MgYW5kIHJlZ2lzdGVycyBpdCBpbiBTaXp6bGVcbiAgICovXG5cblxuICB2YXIgZXh0ZW5kU2l6emxlID0gZnVuY3Rpb24gZXh0ZW5kU2l6emxlKHNpenpsZSkge1xuICAgIC8vIEZpcnN0IG9mIGFsbCB3ZSBzaG91bGQgcHJlcGFyZSBTaXp6bGUgZW5naW5lXG4gICAgc2l6emxlLnNlbGVjdG9ycy5wc2V1ZG9zWydtYXRjaGVzLXByb3BlcnR5J10gPSBzaXp6bGUuc2VsZWN0b3JzLmNyZWF0ZVBzZXVkbyhmdW5jdGlvbiAocHJvcGVydHlGaWx0ZXIpIHtcbiAgICAgIGlmICghcHJvcGVydHlGaWx0ZXIpIHtcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKCdObyBhcmd1bWVudCBpcyBnaXZlbiBmb3IgOm1hdGNoZXMtcHJvcGVydHkgcHNldWRvIGNsYXNzJyk7XG4gICAgICB9XG5cbiAgICAgIHZhciBfbWF0Y2hlclV0aWxzJHBhcnNlTWEgPSBtYXRjaGVyVXRpbHMucGFyc2VNYXRjaGVyRmlsdGVyKHByb3BlcnR5RmlsdGVyKSxcbiAgICAgICAgICBfbWF0Y2hlclV0aWxzJHBhcnNlTWEyID0gX3NsaWNlZFRvQXJyYXkoX21hdGNoZXJVdGlscyRwYXJzZU1hLCAyKSxcbiAgICAgICAgICByYXdQcm9wID0gX21hdGNoZXJVdGlscyRwYXJzZU1hMlswXSxcbiAgICAgICAgICByYXdWYWx1ZSA9IF9tYXRjaGVyVXRpbHMkcGFyc2VNYTJbMV07IC8vIGNoYWluZWQgcHJvcGVydHkgbmFtZSBjYW4gbm90IGluY2x1ZGUgJy8nIG9yICcuJ1xuICAgICAgLy8gc28gcmVnZXggcHJvcCBuYW1lcyB3aXRoIHN1Y2ggZXNjYXBlZCBjaGFyYWN0ZXJzIGFyZSBpbnZhbGlkXG5cblxuICAgICAgaWYgKHJhd1Byb3AuaW5kZXhPZignXFxcXC8nKSA+IC0xIHx8IHJhd1Byb3AuaW5kZXhPZignXFxcXC4nKSA+IC0xKSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcihcIkludmFsaWQgcHJvcGVydHkgbmFtZTogXCIuY29uY2F0KHJhd1Byb3ApKTtcbiAgICAgIH1cblxuICAgICAgdmFyIHByb3BzQ2hhaW5BcmcgPSBwYXJzZVJhd1Byb3BDaGFpbihyYXdQcm9wKTtcbiAgICAgIHZhciB2YWx1ZUFyZyA9IG1hdGNoZXJVdGlscy5wYXJzZVJhd01hdGNoZXJBcmcocmF3VmFsdWUpO1xuICAgICAgdmFyIHByb3BzVG9WYWxpZGF0ZSA9IFtdLmNvbmNhdChfdG9Db25zdW1hYmxlQXJyYXkocHJvcHNDaGFpbkFyZyksIFt2YWx1ZUFyZ10pO1xuXG4gICAgICBpZiAoIW1hdGNoZXJVdGlscy52YWxpZGF0ZVByb3BNYXRjaGVyQXJncyhwcm9wc1RvVmFsaWRhdGUpKSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcihcIkludmFsaWQgYXJndW1lbnQgb2YgOm1hdGNoZXMtcHJvcGVydHkgcHNldWRvIGNsYXNzOiBcIi5jb25jYXQocHJvcGVydHlGaWx0ZXIpKTtcbiAgICAgIH1cblxuICAgICAgdmFyIG1hdGNoZXIgPSBuZXcgUHJvcE1hdGNoZXIocHJvcHNDaGFpbkFyZywgdmFsdWVBcmcpO1xuICAgICAgcmV0dXJuIGZ1bmN0aW9uIChlbGVtZW50KSB7XG4gICAgICAgIHJldHVybiBtYXRjaGVyLm1hdGNoZXMoZWxlbWVudCk7XG4gICAgICB9O1xuICAgIH0pO1xuICB9OyAvLyBFWFBPU0VcblxuXG4gIHJldHVybiB7XG4gICAgZXh0ZW5kU2l6emxlOiBleHRlbmRTaXp6bGVcbiAgfTtcbn0oKTtcblxuLyoqXG4gKiBDb3B5cmlnaHQgMjAyMCBBZGd1YXJkIFNvZnR3YXJlIEx0ZFxuICpcbiAqIExpY2Vuc2VkIHVuZGVyIHRoZSBBcGFjaGUgTGljZW5zZSwgVmVyc2lvbiAyLjAgKHRoZSBcIkxpY2Vuc2VcIik7XG4gKiB5b3UgbWF5IG5vdCB1c2UgdGhpcyBmaWxlIGV4Y2VwdCBpbiBjb21wbGlhbmNlIHdpdGggdGhlIExpY2Vuc2UuXG4gKiBZb3UgbWF5IG9idGFpbiBhIGNvcHkgb2YgdGhlIExpY2Vuc2UgYXRcbiAqXG4gKiBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElDRU5TRS0yLjBcbiAqXG4gKiBVbmxlc3MgcmVxdWlyZWQgYnkgYXBwbGljYWJsZSBsYXcgb3IgYWdyZWVkIHRvIGluIHdyaXRpbmcsIHNvZnR3YXJlXG4gKiBkaXN0cmlidXRlZCB1bmRlciB0aGUgTGljZW5zZSBpcyBkaXN0cmlidXRlZCBvbiBhbiBcIkFTIElTXCIgQkFTSVMsXG4gKiBXSVRIT1VUIFdBUlJBTlRJRVMgT1IgQ09ORElUSU9OUyBPRiBBTlkgS0lORCwgZWl0aGVyIGV4cHJlc3Mgb3IgaW1wbGllZC5cbiAqIFNlZSB0aGUgTGljZW5zZSBmb3IgdGhlIHNwZWNpZmljIGxhbmd1YWdlIGdvdmVybmluZyBwZXJtaXNzaW9ucyBhbmRcbiAqIGxpbWl0YXRpb25zIHVuZGVyIHRoZSBMaWNlbnNlLlxuICovXG4vKipcbiAqIENsYXNzIHRoYXQgZXh0ZW5kcyBTaXp6bGUgYW5kIGFkZHMgc3VwcG9ydCBmb3IgOmlzKCkgcHNldWRvIGVsZW1lbnQuXG4gKi9cblxudmFyIElzQW55TWF0Y2hlciA9IGZ1bmN0aW9uICgpIHtcbiAgLyoqXG4gICAqIENsYXNzIHRoYXQgbWF0Y2hlcyBlbGVtZW50IGJ5IG9uZSBvZiB0aGUgc2VsZWN0b3JzXG4gICAqIGh0dHBzOi8vZGV2ZWxvcGVyLm1vemlsbGEub3JnL2VuLVVTL2RvY3MvV2ViL0NTUy86aXNcbiAgICogQHBhcmFtIHtBcnJheX0gc2VsZWN0b3JzXG4gICAqIEBwYXJhbSB7c3RyaW5nfSBwc2V1ZG9FbGVtZW50XG4gICAqIEBjb25zdHJ1Y3RvclxuICAgKi9cbiAgdmFyIElzTWF0Y2hlciA9IGZ1bmN0aW9uIElzTWF0Y2hlcihzZWxlY3RvcnMsIHBzZXVkb0VsZW1lbnQpIHtcbiAgICB0aGlzLnNlbGVjdG9ycyA9IHNlbGVjdG9ycztcbiAgICB0aGlzLnBzZXVkb0VsZW1lbnQgPSBwc2V1ZG9FbGVtZW50O1xuICB9O1xuICAvKipcbiAgICogRnVuY3Rpb24gdG8gY2hlY2sgaWYgZWxlbWVudCBjYW4gYmUgbWF0Y2hlZCBieSBhbnkgcGFzc2VkIHNlbGVjdG9yXG4gICAqIEBwYXJhbSB7RWxlbWVudH0gZWxlbWVudCB0byBjaGVja1xuICAgKi9cblxuXG4gIElzTWF0Y2hlci5wcm90b3R5cGUubWF0Y2hlcyA9IGZ1bmN0aW9uIChlbGVtZW50KSB7XG4gICAgdmFyIGlzTWF0Y2hlZCA9ICEhdGhpcy5zZWxlY3RvcnMuZmluZChmdW5jdGlvbiAoc2VsZWN0b3IpIHtcbiAgICAgIHZhciBub2RlcyA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3JBbGwoc2VsZWN0b3IpO1xuICAgICAgcmV0dXJuIEFycmF5LmZyb20obm9kZXMpLmZpbmQoZnVuY3Rpb24gKG5vZGUpIHtcbiAgICAgICAgcmV0dXJuIG5vZGUgPT09IGVsZW1lbnQ7XG4gICAgICB9KTtcbiAgICB9KTtcbiAgICByZXR1cm4gaXNNYXRjaGVkO1xuICB9O1xuICAvKipcbiAgICogQ3JlYXRlcyBhIG5ldyBwc2V1ZG8tY2xhc3MgYW5kIHJlZ2lzdGVycyBpdCBpbiBTaXp6bGVcbiAgICovXG5cblxuICB2YXIgZXh0ZW5kU2l6emxlID0gZnVuY3Rpb24gZXh0ZW5kU2l6emxlKHNpenpsZSkge1xuICAgIC8vIEZpcnN0IG9mIGFsbCB3ZSBzaG91bGQgcHJlcGFyZSBTaXp6bGUgZW5naW5lXG4gICAgc2l6emxlLnNlbGVjdG9ycy5wc2V1ZG9zWydpcyddID0gc2l6emxlLnNlbGVjdG9ycy5jcmVhdGVQc2V1ZG8oZnVuY3Rpb24gKGlucHV0KSB7XG4gICAgICBpZiAoaW5wdXQgPT09ICcnKSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcihcIkludmFsaWQgYXJndW1lbnQgb2YgOmlzIHBzZXVkby1jbGFzczogXCIuY29uY2F0KGlucHV0KSk7XG4gICAgICB9XG5cbiAgICAgIHZhciBzZWxlY3RvcnMgPSBpbnB1dC5zcGxpdCgnLCcpLm1hcChmdW5jdGlvbiAocykge1xuICAgICAgICByZXR1cm4gcy50cmltKCk7XG4gICAgICB9KTsgLy8gY29sbGVjdCB2YWxpZCBzZWxlY3RvcnMgYW5kIGxvZyBhYm91dCBpbnZhbGlkIG9uZXNcblxuICAgICAgdmFyIHZhbGlkU2VsZWN0b3JzID0gc2VsZWN0b3JzLnJlZHVjZShmdW5jdGlvbiAoYWNjLCBzZWxlY3Rvcikge1xuICAgICAgICBpZiAoY3NzVXRpbHMuaXNTaW1wbGVTZWxlY3RvclZhbGlkKHNlbGVjdG9yKSkge1xuICAgICAgICAgIGFjYy5wdXNoKHNlbGVjdG9yKTtcbiAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICB1dGlscy5sb2dJbmZvKFwiSW52YWxpZCBzZWxlY3RvciBwYXNzZWQgdG8gOmlzKCkgcHNldWRvLWNsYXNzOiAnXCIuY29uY2F0KHNlbGVjdG9yLCBcIidcIikpO1xuICAgICAgICB9XG5cbiAgICAgICAgcmV0dXJuIGFjYztcbiAgICAgIH0sIFtdKTtcbiAgICAgIHZhciBtYXRjaGVyID0gbmV3IElzTWF0Y2hlcih2YWxpZFNlbGVjdG9ycyk7XG4gICAgICByZXR1cm4gZnVuY3Rpb24gKGVsZW1lbnQpIHtcbiAgICAgICAgcmV0dXJuIG1hdGNoZXIubWF0Y2hlcyhlbGVtZW50KTtcbiAgICAgIH07XG4gICAgfSk7XG4gIH07XG5cbiAgcmV0dXJuIHtcbiAgICBleHRlbmRTaXp6bGU6IGV4dGVuZFNpenpsZVxuICB9O1xufSgpO1xuXG4vKipcbiAqIENvcHlyaWdodCAyMDIxIEFkZ3VhcmQgU29mdHdhcmUgTHRkXG4gKlxuICogTGljZW5zZWQgdW5kZXIgdGhlIEFwYWNoZSBMaWNlbnNlLCBWZXJzaW9uIDIuMCAodGhlIFwiTGljZW5zZVwiKTtcbiAqIHlvdSBtYXkgbm90IHVzZSB0aGlzIGZpbGUgZXhjZXB0IGluIGNvbXBsaWFuY2Ugd2l0aCB0aGUgTGljZW5zZS5cbiAqIFlvdSBtYXkgb2J0YWluIGEgY29weSBvZiB0aGUgTGljZW5zZSBhdFxuICpcbiAqIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMFxuICpcbiAqIFVubGVzcyByZXF1aXJlZCBieSBhcHBsaWNhYmxlIGxhdyBvciBhZ3JlZWQgdG8gaW4gd3JpdGluZywgc29mdHdhcmVcbiAqIGRpc3RyaWJ1dGVkIHVuZGVyIHRoZSBMaWNlbnNlIGlzIGRpc3RyaWJ1dGVkIG9uIGFuIFwiQVMgSVNcIiBCQVNJUyxcbiAqIFdJVEhPVVQgV0FSUkFOVElFUyBPUiBDT05ESVRJT05TIE9GIEFOWSBLSU5ELCBlaXRoZXIgZXhwcmVzcyBvciBpbXBsaWVkLlxuICogU2VlIHRoZSBMaWNlbnNlIGZvciB0aGUgc3BlY2lmaWMgbGFuZ3VhZ2UgZ292ZXJuaW5nIHBlcm1pc3Npb25zIGFuZFxuICogbGltaXRhdGlvbnMgdW5kZXIgdGhlIExpY2Vuc2UuXG4gKi9cbi8qKlxuICogRXh0ZW5kZWQgc2VsZWN0b3IgZmFjdG9yeSBtb2R1bGUsIGZvciBjcmVhdGluZyBleHRlbmRlZCBzZWxlY3RvciBjbGFzc2VzLlxuICpcbiAqIEV4dGVuZGVkIHNlbGVjdGlvbiBjYXBhYmlsaXRpZXMgZGVzY3JpcHRpb246XG4gKiBodHRwczovL2dpdGh1Yi5jb20vQWRndWFyZFRlYW0vRXh0ZW5kZWRDc3MvYmxvYi9tYXN0ZXIvUkVBRE1FLm1kXG4gKi9cblxudmFyIEV4dGVuZGVkU2VsZWN0b3JGYWN0b3J5ID0gZnVuY3Rpb24gKCkge1xuICAvLyB3aGlsZSBhZGRpbmcgbmV3IG1hcmtlcnMsIGNvbnN0YW50cyBpbiBvdGhlciBBZEd1YXJkIHJlcG9zIHNob3VsZCBiZSBjb3JyZWN0ZWRcbiAgLy8gQWRHdWFyZCBicm93c2VyIGV4dGVuc2lvbiA6IENzc0ZpbHRlclJ1bGUuU1VQUE9SVEVEX1BTRVVET19DTEFTU0VTIGFuZCBDc3NGaWx0ZXJSdWxlLkVYVEVOREVEX0NTU19NQVJLRVJTXG4gIC8vIHRzdXJsZmlsdGVyLCBTYWZhcmlDb252ZXJ0ZXJMaWIgOiBFWFRfQ1NTX1BTRVVET19JTkRJQ0FUT1JTXG4gIHZhciBQU0VVRE9fRVhURU5TSU9OU19NQVJLRVJTID0gWyc6aGFzJywgJzpjb250YWlucycsICc6aGFzLXRleHQnLCAnOm1hdGNoZXMtY3NzJywgJzotYWJwLWhhcycsICc6LWFicC1oYXMtdGV4dCcsICc6aWYnLCAnOmlmLW5vdCcsICc6eHBhdGgnLCAnOm50aC1hbmNlc3RvcicsICc6dXB3YXJkJywgJzpyZW1vdmUnLCAnOm1hdGNoZXMtYXR0cicsICc6bWF0Y2hlcy1wcm9wZXJ0eScsICc6LWFicC1jb250YWlucycsICc6aXMnXTtcbiAgdmFyIGluaXRpYWxpemVkID0gZmFsc2U7XG4gIHZhciBTaXp6bGU7XG4gIC8qKlxuICAgKiBMYXp5IGluaXRpYWxpemF0aW9uIG9mIHRoZSBFeHRlbmRlZFNlbGVjdG9yRmFjdG9yeSBhbmQgb2JqZWN0cyB0aGF0IG1pZ2h0IGJlIG5lY2Vzc2FyeSBmb3IgY3JlYXRpbmcgYW5kIGFwcGx5aW5nIHN0eWxlcy5cbiAgICogVGhpcyBtZXRob2QgZXh0ZW5kcyBTaXp6bGUgZW5naW5lIHRoYXQgd2UgdXNlIHVuZGVyIHRoZSBob29kIHdpdGggb3VyIGN1c3RvbSBwc2V1ZG8tY2xhc3Nlcy5cbiAgICovXG5cbiAgZnVuY3Rpb24gaW5pdGlhbGl6ZSgpIHtcbiAgICBpZiAoaW5pdGlhbGl6ZWQpIHtcbiAgICAgIHJldHVybjtcbiAgICB9XG5cbiAgICBpbml0aWFsaXplZCA9IHRydWU7IC8vIE91ciB2ZXJzaW9uIG9mIFNpenpsZSBpcyBpbml0aWFsaXplZCBsYXppbHkgYXMgd2VsbFxuXG4gICAgU2l6emxlID0gaW5pdGlhbGl6ZVNpenpsZSgpOyAvLyBBZGQgOm1hdGNoZXMtY3NzLSooKSBzdXBwb3J0XG5cbiAgICBTdHlsZVByb3BlcnR5TWF0Y2hlci5leHRlbmRTaXp6bGUoU2l6emxlKTsgLy8gQWRkIDptYXRjaGVzLWF0dHIoKSBzdXBwb3J0XG5cbiAgICBBdHRyaWJ1dGVzTWF0Y2hlci5leHRlbmRTaXp6bGUoU2l6emxlKTsgLy8gQWRkIDptYXRjaGVzLXByb3BlcnR5KCkgc3VwcG9ydFxuXG4gICAgRWxlbWVudFByb3BlcnR5TWF0Y2hlci5leHRlbmRTaXp6bGUoU2l6emxlKTsgLy8gQWRkIDppcygpIHN1cHBvcnRcblxuICAgIElzQW55TWF0Y2hlci5leHRlbmRTaXp6bGUoU2l6emxlKTsgLy8gQWRkIDpjb250YWlucywgOmhhcy10ZXh0LCA6LWFicC1jb250YWlucyBzdXBwb3J0XG5cbiAgICB2YXIgY29udGFpbnNQc2V1ZG8gPSBTaXp6bGUuc2VsZWN0b3JzLmNyZWF0ZVBzZXVkbyhmdW5jdGlvbiAodGV4dCkge1xuICAgICAgaWYgKC9eXFxzKlxcLy4qXFwvW2dtaXN1eV0qXFxzKiQvLnRlc3QodGV4dCkpIHtcbiAgICAgICAgdGV4dCA9IHRleHQudHJpbSgpO1xuICAgICAgICB2YXIgZmxhZ3NJbmRleCA9IHRleHQubGFzdEluZGV4T2YoJy8nKTtcbiAgICAgICAgdmFyIGZsYWdzID0gdGV4dC5zdWJzdHJpbmcoZmxhZ3NJbmRleCArIDEpO1xuICAgICAgICB0ZXh0ID0gdGV4dC5zdWJzdHIoMCwgZmxhZ3NJbmRleCArIDEpLnNsaWNlKDEsIC0xKS5yZXBsYWNlKC9cXFxcKFtcXFxcXCJdKS9nLCAnJDEnKTtcbiAgICAgICAgdmFyIHJlZ2V4O1xuXG4gICAgICAgIHRyeSB7XG4gICAgICAgICAgcmVnZXggPSBuZXcgUmVnRXhwKHRleHQsIGZsYWdzKTtcbiAgICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICAgIHRocm93IG5ldyBFcnJvcihcIkludmFsaWQgYXJndW1lbnQgb2YgOmNvbnRhaW5zIHBzZXVkbyBjbGFzczogXCIuY29uY2F0KHRleHQpKTtcbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiBmdW5jdGlvbiAoZWxlbSkge1xuICAgICAgICAgIHZhciBlbGVtVGV4dENvbnRlbnQgPSB1dGlscy5ub2RlVGV4dENvbnRlbnRHZXR0ZXIuYXBwbHkoZWxlbSk7XG4gICAgICAgICAgcmV0dXJuIHJlZ2V4LnRlc3QoZWxlbVRleHRDb250ZW50KTtcbiAgICAgICAgfTtcbiAgICAgIH1cblxuICAgICAgdGV4dCA9IHRleHQucmVwbGFjZSgvXFxcXChbXFxcXCgpW1xcXVwiXSkvZywgJyQxJyk7XG4gICAgICByZXR1cm4gZnVuY3Rpb24gKGVsZW0pIHtcbiAgICAgICAgdmFyIGVsZW1UZXh0Q29udGVudCA9IHV0aWxzLm5vZGVUZXh0Q29udGVudEdldHRlci5hcHBseShlbGVtKTtcbiAgICAgICAgcmV0dXJuIGVsZW1UZXh0Q29udGVudC5pbmRleE9mKHRleHQpID4gLTE7XG4gICAgICB9O1xuICAgIH0pO1xuICAgIFNpenpsZS5zZWxlY3RvcnMucHNldWRvc1snY29udGFpbnMnXSA9IGNvbnRhaW5zUHNldWRvO1xuICAgIFNpenpsZS5zZWxlY3RvcnMucHNldWRvc1snaGFzLXRleHQnXSA9IGNvbnRhaW5zUHNldWRvO1xuICAgIFNpenpsZS5zZWxlY3RvcnMucHNldWRvc1snLWFicC1jb250YWlucyddID0gY29udGFpbnNQc2V1ZG87IC8vIEFkZCA6aWYsIDotYWJwLWhhcyBzdXBwb3J0XG5cbiAgICBTaXp6bGUuc2VsZWN0b3JzLnBzZXVkb3NbJ2lmJ10gPSBTaXp6bGUuc2VsZWN0b3JzLnBzZXVkb3NbJ2hhcyddO1xuICAgIFNpenpsZS5zZWxlY3RvcnMucHNldWRvc1snLWFicC1oYXMnXSA9IFNpenpsZS5zZWxlY3RvcnMucHNldWRvc1snaGFzJ107IC8vIEFkZCA6aWYtbm90IHN1cHBvcnRcblxuICAgIFNpenpsZS5zZWxlY3RvcnMucHNldWRvc1snaWYtbm90J10gPSBTaXp6bGUuc2VsZWN0b3JzLmNyZWF0ZVBzZXVkbyhmdW5jdGlvbiAoc2VsZWN0b3IpIHtcbiAgICAgIGlmICh0eXBlb2Ygc2VsZWN0b3IgPT09ICdzdHJpbmcnKSB7XG4gICAgICAgIFNpenpsZS5jb21waWxlKHNlbGVjdG9yKTtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIGZ1bmN0aW9uIChlbGVtKSB7XG4gICAgICAgIHJldHVybiBTaXp6bGUoc2VsZWN0b3IsIGVsZW0pLmxlbmd0aCA9PT0gMDtcbiAgICAgIH07XG4gICAgfSk7XG4gICAgcmVnaXN0ZXJQYXJzZXJPbmx5VG9rZW5zKCk7XG4gIH1cbiAgLyoqXG4gICAqIFJlZ2lzdHJhdGUgY3VzdG9tIHRva2VucyBmb3IgcGFyc2VyLlxuICAgKiBOZWVkZWQgZm9yIHByb3BlciB3b3JrIG9mIHBzZXVkb3M6XG4gICAqIGZvciBjaGVja2luZyBpZiB0aGUgdG9rZW4gaXMgbGFzdCBhbmQgcHNldWRvLWNsYXNzIGFyZ3VtZW50cyB2YWxpZGF0aW9uXG4gICAqL1xuXG5cbiAgZnVuY3Rpb24gcmVnaXN0ZXJQYXJzZXJPbmx5VG9rZW5zKCkge1xuICAgIFNpenpsZS5zZWxlY3RvcnMucHNldWRvc1sneHBhdGgnXSA9IFNpenpsZS5zZWxlY3RvcnMuY3JlYXRlUHNldWRvKGZ1bmN0aW9uIChzZWxlY3Rvcikge1xuICAgICAgdHJ5IHtcbiAgICAgICAgZG9jdW1lbnQuY3JlYXRlRXhwcmVzc2lvbihzZWxlY3RvciwgbnVsbCk7XG4gICAgICB9IGNhdGNoIChlKSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcihcIkludmFsaWQgYXJndW1lbnQgb2YgOnhwYXRoIHBzZXVkbyBjbGFzczogXCIuY29uY2F0KHNlbGVjdG9yKSk7XG4gICAgICB9XG5cbiAgICAgIHJldHVybiBmdW5jdGlvbiAoKSB7XG4gICAgICAgIHJldHVybiB0cnVlO1xuICAgICAgfTtcbiAgICB9KTtcbiAgICBTaXp6bGUuc2VsZWN0b3JzLnBzZXVkb3NbJ250aC1hbmNlc3RvciddID0gU2l6emxlLnNlbGVjdG9ycy5jcmVhdGVQc2V1ZG8oZnVuY3Rpb24gKHNlbGVjdG9yKSB7XG4gICAgICB2YXIgZGVlcCA9IE51bWJlcihzZWxlY3Rvcik7XG5cbiAgICAgIGlmIChOdW1iZXIuaXNOYU4oZGVlcCkgfHwgZGVlcCA8IDEgfHwgZGVlcCA+PSAyNTYpIHtcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiSW52YWxpZCBhcmd1bWVudCBvZiA6bnRoLWFuY2VzdG9yIHBzZXVkbyBjbGFzczogXCIuY29uY2F0KHNlbGVjdG9yKSk7XG4gICAgICB9XG5cbiAgICAgIHJldHVybiBmdW5jdGlvbiAoKSB7XG4gICAgICAgIHJldHVybiB0cnVlO1xuICAgICAgfTtcbiAgICB9KTtcbiAgICBTaXp6bGUuc2VsZWN0b3JzLnBzZXVkb3NbJ3Vwd2FyZCddID0gU2l6emxlLnNlbGVjdG9ycy5jcmVhdGVQc2V1ZG8oZnVuY3Rpb24gKGlucHV0KSB7XG4gICAgICBpZiAoaW5wdXQgPT09ICcnKSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcihcIkludmFsaWQgYXJndW1lbnQgb2YgOnVwd2FyZCBwc2V1ZG8gY2xhc3M6IFwiLmNvbmNhdChpbnB1dCkpO1xuICAgICAgfSBlbHNlIGlmIChOdW1iZXIuaXNJbnRlZ2VyKCtpbnB1dCkgJiYgKCtpbnB1dCA8IDEgfHwgK2lucHV0ID49IDI1NikpIHtcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiSW52YWxpZCBhcmd1bWVudCBvZiA6dXB3YXJkIHBzZXVkbyBjbGFzczogXCIuY29uY2F0KGlucHV0KSk7XG4gICAgICB9XG5cbiAgICAgIHJldHVybiBmdW5jdGlvbiAoKSB7XG4gICAgICAgIHJldHVybiB0cnVlO1xuICAgICAgfTtcbiAgICB9KTtcbiAgICBTaXp6bGUuc2VsZWN0b3JzLnBzZXVkb3NbJ3JlbW92ZSddID0gU2l6emxlLnNlbGVjdG9ycy5jcmVhdGVQc2V1ZG8oZnVuY3Rpb24gKGlucHV0KSB7XG4gICAgICBpZiAoaW5wdXQgIT09ICcnKSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcihcIkludmFsaWQgYXJndW1lbnQgb2YgOnJlbW92ZSBwc2V1ZG8gY2xhc3M6IFwiLmNvbmNhdChpbnB1dCkpO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gZnVuY3Rpb24gKCkge1xuICAgICAgICByZXR1cm4gdHJ1ZTtcbiAgICAgIH07XG4gICAgfSk7XG4gIH1cbiAgLyoqXG4gICAqIENoZWNrcyBpZiBzcGVjaWZpZWQgdG9rZW4gY2FuIGJlIHVzZWQgYnkgZG9jdW1lbnQucXVlcnlTZWxlY3RvckFsbC5cbiAgICovXG5cblxuICBmdW5jdGlvbiBpc1NpbXBsZVRva2VuKHRva2VuKSB7XG4gICAgdmFyIHR5cGUgPSB0b2tlbi50eXBlO1xuXG4gICAgaWYgKHR5cGUgPT09ICdJRCcgfHwgdHlwZSA9PT0gJ0NMQVNTJyB8fCB0eXBlID09PSAnQVRUUicgfHwgdHlwZSA9PT0gJ1RBRycgfHwgdHlwZSA9PT0gJ0NISUxEJykge1xuICAgICAgLy8ga25vd24gc2ltcGxlIHRva2Vuc1xuICAgICAgcmV0dXJuIHRydWU7XG4gICAgfVxuXG4gICAgaWYgKHR5cGUgPT09ICdQU0VVRE8nKSB7XG4gICAgICAvLyBjaGVjayBpZiB2YWx1ZSBjb250YWlucyBhbnkgb2YgZXh0ZW5kZWQgcHNldWRvIGNsYXNzZXNcbiAgICAgIHZhciBpID0gUFNFVURPX0VYVEVOU0lPTlNfTUFSS0VSUy5sZW5ndGg7XG5cbiAgICAgIHdoaWxlIChpLS0pIHtcbiAgICAgICAgaWYgKHRva2VuLnZhbHVlLmluZGV4T2YoUFNFVURPX0VYVEVOU0lPTlNfTUFSS0VSU1tpXSkgPj0gMCkge1xuICAgICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgICAgfVxuICAgICAgfVxuXG4gICAgICByZXR1cm4gdHJ1ZTtcbiAgICB9IC8vIGFsbCBvdGhlcnMgYXJlbid0IHNpbXBsZVxuXG5cbiAgICByZXR1cm4gZmFsc2U7XG4gIH1cbiAgLyoqXG4gICAqIENoZWNrcyBpZiBzcGVjaWZpZWQgdG9rZW4gaXMgYSBjb21iaW5hdG9yXG4gICAqL1xuXG5cbiAgZnVuY3Rpb24gaXNSZWxhdGlvblRva2VuKHRva2VuKSB7XG4gICAgdmFyIHR5cGUgPSB0b2tlbi50eXBlO1xuICAgIHJldHVybiB0eXBlID09PSAnICcgfHwgdHlwZSA9PT0gJz4nIHx8IHR5cGUgPT09ICcrJyB8fCB0eXBlID09PSAnfic7XG4gIH1cbiAgLyoqXG4gICAqIEV4dGVuZGVkU2VsZWN0b3JQYXJzZXIgaXMgYSBoZWxwZXIgY2xhc3MgZm9yIGNyZWF0aW5nIHZhcmlvdXMgc2VsZWN0b3IgaW5zdGFuY2VzIHdoaWNoXG4gICAqIGFsbCBzaGFyZXMgYSBtZXRob2QgYHF1ZXJ5U2VsZWN0b3JBbGwoKWAgYW5kIGBtYXRjaGVzKClgIGltcGxlbWVudGluZyBkaWZmZXJlbnQgc2VhcmNoIHN0cmF0ZWdpZXNcbiAgICogZGVwZW5kaW5nIG9uIGEgdHlwZSBvZiBzZWxlY3Rvci5cbiAgICpcbiAgICogQ3VycmVudGx5LCB0aGVyZSBhcmUgMyB0eXBlczpcbiAgICogIEEgdHJhaXQtbGVzcyBleHRlbmRlZCBzZWxlY3RvclxuICAgKiAgICAtIHdlIGRpcmVjdGx5IGZlZWQgc2VsZWN0b3Igc3RyaW5ncyB0byBTaXp6bGUuXG4gICAqICBBIHNwbGl0dGVkIGV4dGVuZGVkIHNlbGVjdG9yXG4gICAqICAgIC0gc3VjaCBhcyAjY29udGFpbmVyICNmZWVkSXRlbTpoYXMoLmFkcyksIHdoZXJlIGl0IGlzIHNwbGl0dGVkIHRvIGAjY29udGFpbmVyYCBhbmQgYCNmZWVkSXRlbTpoYXMoLmFkcylgLlxuICAgKi9cblxuXG4gIGZ1bmN0aW9uIEV4dGVuZGVkU2VsZWN0b3JQYXJzZXIoc2VsZWN0b3JUZXh0LCB0b2tlbnMsIGRlYnVnKSB7XG4gICAgaW5pdGlhbGl6ZSgpO1xuXG4gICAgaWYgKHR5cGVvZiB0b2tlbnMgPT09ICd1bmRlZmluZWQnKSB7XG4gICAgICB0aGlzLnNlbGVjdG9yVGV4dCA9IGNzc1V0aWxzLm5vcm1hbGl6ZShzZWxlY3RvclRleHQpOyAvLyBQYXNzaW5nIGByZXR1cm5VbnNvcnRlZGAgaW4gb3JkZXIgdG8gcmVjZWl2ZSB0b2tlbnMgaW4gdGhlIG9yZGVyIHRoYXQncyB2YWxpZCBmb3IgdGhlIGJyb3dzZXJcbiAgICAgIC8vIEluIFNpenpsZSBpbnRlcm5hbGx5LCB0aGUgdG9rZW5zIGFyZSByZS1zb3J0ZWQ6IGh0dHBzOi8vZ2l0aHViLmNvbS9BZGd1YXJkVGVhbS9FeHRlbmRlZENzcy9pc3N1ZXMvNTVcblxuICAgICAgdGhpcy50b2tlbnMgPSBTaXp6bGUudG9rZW5pemUodGhpcy5zZWxlY3RvclRleHQsIGZhbHNlLCB7XG4gICAgICAgIHJldHVyblVuc29ydGVkOiB0cnVlXG4gICAgICB9KTtcbiAgICB9IGVsc2Uge1xuICAgICAgdGhpcy5zZWxlY3RvclRleHQgPSBzZWxlY3RvclRleHQ7XG4gICAgICB0aGlzLnRva2VucyA9IHRva2VucztcbiAgICB9XG5cbiAgICBpZiAoZGVidWcgPT09IHRydWUpIHtcbiAgICAgIHRoaXMuZGVidWcgPSB0cnVlO1xuICAgIH1cbiAgfVxuXG4gIEV4dGVuZGVkU2VsZWN0b3JQYXJzZXIucHJvdG90eXBlID0ge1xuICAgIC8qKlxuICAgICAqIFRoZSBtYWluIG1ldGhvZCwgY3JlYXRlcyBhIHNlbGVjdG9yIGluc3RhbmNlIGRlcGVuZGluZyBvbiB0aGUgdHlwZSBvZiBhIHNlbGVjdG9yLlxuICAgICAqIEBwdWJsaWNcbiAgICAgKi9cbiAgICBjcmVhdGVTZWxlY3RvcjogZnVuY3Rpb24gY3JlYXRlU2VsZWN0b3IoKSB7XG4gICAgICB2YXIgZGVidWcgPSB0aGlzLmRlYnVnO1xuICAgICAgdmFyIHRva2VucyA9IHRoaXMudG9rZW5zO1xuICAgICAgdmFyIHNlbGVjdG9yVGV4dCA9IHRoaXMuc2VsZWN0b3JUZXh0O1xuXG4gICAgICBpZiAodG9rZW5zLmxlbmd0aCAhPT0gMSkge1xuICAgICAgICAvLyBDb21tYS1zZXBhcmF0ZSBzZWxlY3RvciAtIGNhbid0IG9wdGltaXplIGZ1cnRoZXJcbiAgICAgICAgcmV0dXJuIG5ldyBUcmFpdExlc3NTZWxlY3RvcihzZWxlY3RvclRleHQsIGRlYnVnKTtcbiAgICAgIH1cblxuICAgICAgdmFyIHhwYXRoUGFydCA9IHRoaXMuZ2V0WHBhdGhQYXJ0KCk7XG5cbiAgICAgIGlmICh0eXBlb2YgeHBhdGhQYXJ0ICE9PSAndW5kZWZpbmVkJykge1xuICAgICAgICByZXR1cm4gbmV3IFhwYXRoU2VsZWN0b3Ioc2VsZWN0b3JUZXh0LCB4cGF0aFBhcnQsIGRlYnVnKTtcbiAgICAgIH1cblxuICAgICAgdmFyIHVwd2FyZFBhcnQgPSB0aGlzLmdldFVwd2FyZFBhcnQoKTtcblxuICAgICAgaWYgKHR5cGVvZiB1cHdhcmRQYXJ0ICE9PSAndW5kZWZpbmVkJykge1xuICAgICAgICB2YXIgb3V0cHV0O1xuICAgICAgICB2YXIgdXB3YXJkRGVlcCA9IHBhcnNlSW50KHVwd2FyZFBhcnQsIDEwKTsgLy8gaWYgdXB3YXJkIHBhcmFtZXRlciBpcyBub3QgYSBudW1iZXIsIHdlIGNvbnNpZGVyIGl0IGFzIGEgc2VsZWN0b3JcblxuICAgICAgICBpZiAoTnVtYmVyLmlzTmFOKHVwd2FyZERlZXApKSB7XG4gICAgICAgICAgb3V0cHV0ID0gbmV3IFVwd2FyZFNlbGVjdG9yKHNlbGVjdG9yVGV4dCwgdXB3YXJkUGFydCwgZGVidWcpO1xuICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgIC8vIHVwd2FyZCB3b3JrcyBsaWtlIG50aC1hbmNlc3RvclxuICAgICAgICAgIHZhciB4cGF0aCA9IHRoaXMuY29udmVydE50aEFuY2VzdG9yVG9rZW4odXB3YXJkRGVlcCk7XG4gICAgICAgICAgb3V0cHV0ID0gbmV3IFhwYXRoU2VsZWN0b3Ioc2VsZWN0b3JUZXh0LCB4cGF0aCwgZGVidWcpO1xuICAgICAgICB9XG5cbiAgICAgICAgcmV0dXJuIG91dHB1dDtcbiAgICAgIH0gLy8gYXJndW1lbnQgb2YgcHNldWRvLWNsYXNzIHJlbW92ZTtcbiAgICAgIC8vIGl0J3MgZGVmaW5lZCBvbmx5IGlmIHJlbW92ZSBpcyBwYXJzZWQgYXMgbGFzdCB0b2tlblxuICAgICAgLy8gYW5kIGl0J3MgdmFsaWQgb25seSBpZiByZW1vdmUgYXJnIGlzIGVtcHR5IHN0cmluZ1xuXG5cbiAgICAgIHZhciByZW1vdmVQYXJ0ID0gdGhpcy5nZXRSZW1vdmVQYXJ0KCk7XG5cbiAgICAgIGlmICh0eXBlb2YgcmVtb3ZlUGFydCAhPT0gJ3VuZGVmaW5lZCcpIHtcbiAgICAgICAgdmFyIGhhc1ZhbGlkUmVtb3ZlUGFydCA9IHJlbW92ZVBhcnQgPT09ICcnO1xuICAgICAgICByZXR1cm4gbmV3IFJlbW92ZVNlbGVjdG9yKHNlbGVjdG9yVGV4dCwgaGFzVmFsaWRSZW1vdmVQYXJ0LCBkZWJ1Zyk7XG4gICAgICB9XG5cbiAgICAgIHRva2VucyA9IHRva2Vuc1swXTtcbiAgICAgIHZhciBsID0gdG9rZW5zLmxlbmd0aDtcbiAgICAgIHZhciBsYXN0UmVsVG9rZW5JbmQgPSB0aGlzLmdldFNwbGl0UG9pbnQoKTtcblxuICAgICAgaWYgKHR5cGVvZiBsYXN0UmVsVG9rZW5JbmQgPT09ICd1bmRlZmluZWQnKSB7XG4gICAgICAgIHRyeSB7XG4gICAgICAgICAgZG9jdW1lbnQucXVlcnlTZWxlY3RvcihzZWxlY3RvclRleHQpO1xuICAgICAgICB9IGNhdGNoIChlKSB7XG4gICAgICAgICAgcmV0dXJuIG5ldyBUcmFpdExlc3NTZWxlY3RvcihzZWxlY3RvclRleHQsIGRlYnVnKTtcbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiBuZXcgTm90QW5FeHRlbmRlZFNlbGVjdG9yKHNlbGVjdG9yVGV4dCwgZGVidWcpO1xuICAgICAgfVxuXG4gICAgICB2YXIgc2ltcGxlID0gJyc7XG4gICAgICB2YXIgcmVsYXRpb24gPSBudWxsO1xuICAgICAgdmFyIGNvbXBsZXggPSAnJztcbiAgICAgIHZhciBpID0gMDtcblxuICAgICAgZm9yICg7IGkgPCBsYXN0UmVsVG9rZW5JbmQ7IGkrKykge1xuICAgICAgICAvLyBidWlsZCBzaW1wbGUgcGFydFxuICAgICAgICBzaW1wbGUgKz0gdG9rZW5zW2ldLnZhbHVlO1xuICAgICAgfVxuXG4gICAgICBpZiAoaSA+IDApIHtcbiAgICAgICAgLy8gYnVpbGQgcmVsYXRpb24gcGFydFxuICAgICAgICByZWxhdGlvbiA9IHRva2Vuc1tpKytdLnR5cGU7XG4gICAgICB9IC8vIGkgaXMgcG9pbnRpbmcgdG8gdGhlIHN0YXJ0IG9mIGEgY29tcGxleCBwYXJ0LlxuXG5cbiAgICAgIGZvciAoOyBpIDwgbDsgaSsrKSB7XG4gICAgICAgIGNvbXBsZXggKz0gdG9rZW5zW2ldLnZhbHVlO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gbGFzdFJlbFRva2VuSW5kID09PSAtMSA/IG5ldyBUcmFpdExlc3NTZWxlY3RvcihzZWxlY3RvclRleHQsIGRlYnVnKSA6IG5ldyBTcGxpdHRlZFNlbGVjdG9yKHNlbGVjdG9yVGV4dCwgc2ltcGxlLCByZWxhdGlvbiwgY29tcGxleCwgZGVidWcpO1xuICAgIH0sXG5cbiAgICAvKipcbiAgICAgKiBAcHJpdmF0ZVxuICAgICAqIEByZXR1cm4ge251bWJlcnx1bmRlZmluZWR9IEFuIGluZGV4IG9mIGEgdG9rZW4gdGhhdCBpcyBzcGxpdCBwb2ludC5cbiAgICAgKiByZXR1cm5zIHVuZGVmaW5lZCBpZiB0aGUgc2VsZWN0b3IgZG9lcyBub3QgY29udGFpbiBhbnkgY29tcGxleCB0b2tlbnNcbiAgICAgKiBvciBpdCBpcyBub3QgZWxpZ2libGUgZm9yIHNwbGl0dGluZy5cbiAgICAgKiBPdGhlcndpc2UgcmV0dXJucyBhbiBpbnRlZ2VyIGluZGljYXRpbmcgdGhlIGluZGV4IG9mIHRoZSBsYXN0IHJlbGF0aW9uIHRva2VuLlxuICAgICAqL1xuICAgIGdldFNwbGl0UG9pbnQ6IGZ1bmN0aW9uIGdldFNwbGl0UG9pbnQoKSB7XG4gICAgICB2YXIgdG9rZW5zID0gdGhpcy50b2tlbnNbMF07IC8vIFdlIHNwbGl0IHNlbGVjdG9yIG9ubHkgd2hlbiB0aGUgbGFzdCBjb21wb3VuZCBzZWxlY3RvclxuICAgICAgLy8gaXMgdGhlIG9ubHkgZXh0ZW5kZWQgc2VsZWN0b3IuXG5cbiAgICAgIHZhciBsYXRlc3RSZWxhdGlvblRva2VuSW5kZXggPSAtMTtcbiAgICAgIHZhciBoYXZlTWV0Q29tcGxleFRva2VuID0gZmFsc2U7XG5cbiAgICAgIGZvciAodmFyIGkgPSAwLCBsID0gdG9rZW5zLmxlbmd0aDsgaSA8IGw7IGkrKykge1xuICAgICAgICB2YXIgdG9rZW4gPSB0b2tlbnNbaV07XG5cbiAgICAgICAgaWYgKGlzUmVsYXRpb25Ub2tlbih0b2tlbikpIHtcbiAgICAgICAgICBpZiAoaGF2ZU1ldENvbXBsZXhUb2tlbikge1xuICAgICAgICAgICAgcmV0dXJuO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIGxhdGVzdFJlbGF0aW9uVG9rZW5JbmRleCA9IGk7XG4gICAgICAgIH0gZWxzZSBpZiAoIWlzU2ltcGxlVG9rZW4odG9rZW4pKSB7XG4gICAgICAgICAgaGF2ZU1ldENvbXBsZXhUb2tlbiA9IHRydWU7XG4gICAgICAgIH1cbiAgICAgIH1cblxuICAgICAgaWYgKCFoYXZlTWV0Q29tcGxleFRva2VuKSB7XG4gICAgICAgIHJldHVybjtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIGxhdGVzdFJlbGF0aW9uVG9rZW5JbmRleDtcbiAgICB9LFxuXG4gICAgLyoqXG4gICAgICogQHByaXZhdGVcbiAgICAgKiBAcmV0dXJuIHtzdHJpbmd8dW5kZWZpbmVkfSB4cGF0aCBzZWxlY3RvciBwYXJ0IGlmIGV4aXN0c1xuICAgICAqIHJldHVybnMgdW5kZWZpbmVkIGlmIHRoZSBzZWxlY3RvciBkb2VzIG5vdCBjb250YWluIHhwYXRoIHRva2Vuc1xuICAgICAqL1xuICAgIGdldFhwYXRoUGFydDogZnVuY3Rpb24gZ2V0WHBhdGhQYXJ0KCkge1xuICAgICAgdmFyIHRva2VucyA9IHRoaXMudG9rZW5zWzBdO1xuXG4gICAgICBmb3IgKHZhciBpID0gMCwgdG9rZW5zTGVuZ3RoID0gdG9rZW5zLmxlbmd0aDsgaSA8IHRva2Vuc0xlbmd0aDsgaSsrKSB7XG4gICAgICAgIHZhciB0b2tlbiA9IHRva2Vuc1tpXTtcblxuICAgICAgICBpZiAodG9rZW4udHlwZSA9PT0gJ1BTRVVETycpIHtcbiAgICAgICAgICB2YXIgbWF0Y2hlcyA9IHRva2VuLm1hdGNoZXM7XG5cbiAgICAgICAgICBpZiAobWF0Y2hlcyAmJiBtYXRjaGVzLmxlbmd0aCA+IDEpIHtcbiAgICAgICAgICAgIGlmIChtYXRjaGVzWzBdID09PSAneHBhdGgnKSB7XG4gICAgICAgICAgICAgIGlmICh0aGlzLmlzTGFzdFRva2VuKHRva2VucywgaSkpIHtcbiAgICAgICAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoJ0ludmFsaWQgcHNldWRvOiBcXCc6eHBhdGhcXCcgc2hvdWxkIGJlIGF0IHRoZSBlbmQgb2YgdGhlIHNlbGVjdG9yJyk7XG4gICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICByZXR1cm4gbWF0Y2hlc1sxXTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgaWYgKG1hdGNoZXNbMF0gPT09ICdudGgtYW5jZXN0b3InKSB7XG4gICAgICAgICAgICAgIGlmICh0aGlzLmlzTGFzdFRva2VuKHRva2VucywgaSkpIHtcbiAgICAgICAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoJ0ludmFsaWQgcHNldWRvOiBcXCc6bnRoLWFuY2VzdG9yXFwnIHNob3VsZCBiZSBhdCB0aGUgZW5kIG9mIHRoZSBzZWxlY3RvcicpO1xuICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgdmFyIGRlZXAgPSBtYXRjaGVzWzFdO1xuXG4gICAgICAgICAgICAgIGlmIChkZWVwID4gMCAmJiBkZWVwIDwgMjU2KSB7XG4gICAgICAgICAgICAgICAgcmV0dXJuIHRoaXMuY29udmVydE50aEFuY2VzdG9yVG9rZW4oZGVlcCk7XG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICB9LFxuXG4gICAgLyoqXG4gICAgICogY29udmVydHMgbnRoLWFuY2VzdG9yL3Vwd2FyZCBkZWVwIHZhbHVlIHRvIHhwYXRoIGVxdWl2YWxlbnRcbiAgICAgKiBAcGFyYW0ge251bWJlcn0gZGVlcFxuICAgICAqIEByZXR1cm4ge3N0cmluZ31cbiAgICAgKi9cbiAgICBjb252ZXJ0TnRoQW5jZXN0b3JUb2tlbjogZnVuY3Rpb24gY29udmVydE50aEFuY2VzdG9yVG9rZW4oZGVlcCkge1xuICAgICAgdmFyIHJlc3VsdCA9ICcuLic7XG5cbiAgICAgIHdoaWxlIChkZWVwID4gMSkge1xuICAgICAgICByZXN1bHQgKz0gJy8uLic7XG4gICAgICAgIGRlZXAtLTtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIHJlc3VsdDtcbiAgICB9LFxuXG4gICAgLyoqXG4gICAgICogQ2hlY2tzIGlmIHRoZSB0b2tlbiBpcyBsYXN0LFxuICAgICAqIGV4Y2VwdCBvZiByZW1vdmUgcHNldWRvLWNsYXNzXG4gICAgICogQHBhcmFtIHtBcnJheX0gdG9rZW5zXG4gICAgICogQHBhcmFtIHtudW1iZXJ9IGkgaW5kZXggb2YgdG9rZW5cbiAgICAgKiBAcmV0dXJucyB7Ym9vbGVhbn1cbiAgICAgKi9cbiAgICBpc0xhc3RUb2tlbjogZnVuY3Rpb24gaXNMYXN0VG9rZW4odG9rZW5zLCBpKSB7XG4gICAgICAvLyBjaGVjayBpZCB0aGUgbmV4dCBwYXJzZWQgdG9rZW4gaXMgcmVtb3ZlIHBzZXVkb1xuICAgICAgdmFyIGlzTmV4dFJlbW92ZVRva2VuID0gdG9rZW5zW2kgKyAxXSAmJiB0b2tlbnNbaSArIDFdLnR5cGUgPT09ICdQU0VVRE8nICYmIHRva2Vuc1tpICsgMV0ubWF0Y2hlcyAmJiB0b2tlbnNbaSArIDFdLm1hdGNoZXNbMF0gPT09ICdyZW1vdmUnOyAvLyBjaGVjayBpZiB0aGUgdG9rZW4gaXMgbGFzdFxuICAgICAgLy8gYW5kIGlmIGl0IGlzIG5vdCBjaGVjayBpZiBpdCBpcyByZW1vdmUgb25lXG4gICAgICAvLyB3aGljaCBzaG91bGQgYmUgc2tpcHBlZFxuXG4gICAgICByZXR1cm4gaSArIDEgIT09IHRva2Vucy5sZW5ndGggJiYgIWlzTmV4dFJlbW92ZVRva2VuO1xuICAgIH0sXG5cbiAgICAvKipcbiAgICAgKiBAcHJpdmF0ZVxuICAgICAqIEByZXR1cm4ge3N0cmluZ3x1bmRlZmluZWR9IHVwd2FyZCBwYXJhbWV0ZXJcbiAgICAgKiBvciB1bmRlZmluZWQgaWYgdGhlIGlucHV0IGRvZXMgbm90IGNvbnRhaW4gdXB3YXJkIHRva2Vuc1xuICAgICAqL1xuICAgIGdldFVwd2FyZFBhcnQ6IGZ1bmN0aW9uIGdldFVwd2FyZFBhcnQoKSB7XG4gICAgICB2YXIgdG9rZW5zID0gdGhpcy50b2tlbnNbMF07XG5cbiAgICAgIGZvciAodmFyIGkgPSAwLCB0b2tlbnNMZW5ndGggPSB0b2tlbnMubGVuZ3RoOyBpIDwgdG9rZW5zTGVuZ3RoOyBpKyspIHtcbiAgICAgICAgdmFyIHRva2VuID0gdG9rZW5zW2ldO1xuXG4gICAgICAgIGlmICh0b2tlbi50eXBlID09PSAnUFNFVURPJykge1xuICAgICAgICAgIHZhciBtYXRjaGVzID0gdG9rZW4ubWF0Y2hlcztcblxuICAgICAgICAgIGlmIChtYXRjaGVzICYmIG1hdGNoZXMubGVuZ3RoID4gMSkge1xuICAgICAgICAgICAgaWYgKG1hdGNoZXNbMF0gPT09ICd1cHdhcmQnKSB7XG4gICAgICAgICAgICAgIGlmICh0aGlzLmlzTGFzdFRva2VuKHRva2VucywgaSkpIHtcbiAgICAgICAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoJ0ludmFsaWQgcHNldWRvOiBcXCc6dXB3YXJkXFwnIHNob3VsZCBiZSBhdCB0aGUgZW5kIG9mIHRoZSBzZWxlY3RvcicpO1xuICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgcmV0dXJuIG1hdGNoZXNbMV07XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfVxuICAgICAgICB9XG4gICAgICB9XG4gICAgfSxcblxuICAgIC8qKlxuICAgICAqIEBwcml2YXRlXG4gICAgICogQHJldHVybiB7c3RyaW5nfHVuZGVmaW5lZH0gcmVtb3ZlIHBhcmFtZXRlclxuICAgICAqIG9yIHVuZGVmaW5lZCBpZiB0aGUgaW5wdXQgZG9lcyBub3QgY29udGFpbiByZW1vdmUgdG9rZW5zXG4gICAgICovXG4gICAgZ2V0UmVtb3ZlUGFydDogZnVuY3Rpb24gZ2V0UmVtb3ZlUGFydCgpIHtcbiAgICAgIHZhciB0b2tlbnMgPSB0aGlzLnRva2Vuc1swXTtcblxuICAgICAgZm9yICh2YXIgaSA9IDAsIHRva2Vuc0xlbmd0aCA9IHRva2Vucy5sZW5ndGg7IGkgPCB0b2tlbnNMZW5ndGg7IGkrKykge1xuICAgICAgICB2YXIgdG9rZW4gPSB0b2tlbnNbaV07XG5cbiAgICAgICAgaWYgKHRva2VuLnR5cGUgPT09ICdQU0VVRE8nKSB7XG4gICAgICAgICAgdmFyIG1hdGNoZXMgPSB0b2tlbi5tYXRjaGVzO1xuXG4gICAgICAgICAgaWYgKG1hdGNoZXMgJiYgbWF0Y2hlcy5sZW5ndGggPiAxKSB7XG4gICAgICAgICAgICBpZiAobWF0Y2hlc1swXSA9PT0gJ3JlbW92ZScpIHtcbiAgICAgICAgICAgICAgaWYgKGkgKyAxICE9PSB0b2tlbnNMZW5ndGgpIHtcbiAgICAgICAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoJ0ludmFsaWQgcHNldWRvOiBcXCc6cmVtb3ZlXFwnIHNob3VsZCBiZSBhdCB0aGUgZW5kIG9mIHRoZSBzZWxlY3RvcicpO1xuICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgcmV0dXJuIG1hdGNoZXNbMV07XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfVxuICAgICAgICB9XG4gICAgICB9XG4gICAgfVxuICB9O1xuICB2YXIgZ2xvYmFsRGVidWdnaW5nRmxhZyA9IGZhbHNlO1xuXG4gIGZ1bmN0aW9uIGlzRGVidWdnaW5nKCkge1xuICAgIHJldHVybiBnbG9iYWxEZWJ1Z2dpbmdGbGFnIHx8IHRoaXMuZGVidWc7XG4gIH1cbiAgLyoqXG4gICAqIFRoaXMgY2xhc3MgcmVwcmVzZW50cyBhIHNlbGVjdG9yIHdoaWNoIGlzIG5vdCBhbiBleHRlbmRlZCBzZWxlY3Rvci5cbiAgICogQHBhcmFtIHtzdHJpbmd9IHNlbGVjdG9yVGV4dFxuICAgKiBAcGFyYW0ge2Jvb2xlYW49fSBkZWJ1Z1xuICAgKiBAZmluYWxcbiAgICovXG5cblxuICBmdW5jdGlvbiBOb3RBbkV4dGVuZGVkU2VsZWN0b3Ioc2VsZWN0b3JUZXh0LCBkZWJ1Zykge1xuICAgIHRoaXMuc2VsZWN0b3JUZXh0ID0gc2VsZWN0b3JUZXh0O1xuICAgIHRoaXMuZGVidWcgPSBkZWJ1ZztcbiAgfVxuXG4gIE5vdEFuRXh0ZW5kZWRTZWxlY3Rvci5wcm90b3R5cGUgPSB7XG4gICAgcXVlcnlTZWxlY3RvckFsbDogZnVuY3Rpb24gcXVlcnlTZWxlY3RvckFsbCgpIHtcbiAgICAgIHJldHVybiBkb2N1bWVudC5xdWVyeVNlbGVjdG9yQWxsKHRoaXMuc2VsZWN0b3JUZXh0KTtcbiAgICB9LFxuICAgIG1hdGNoZXM6IGZ1bmN0aW9uIG1hdGNoZXMoZWxlbWVudCkge1xuICAgICAgcmV0dXJuIGVsZW1lbnRbdXRpbHMubWF0Y2hlc1Byb3BlcnR5TmFtZV0odGhpcy5zZWxlY3RvclRleHQpO1xuICAgIH0sXG4gICAgaXNEZWJ1Z2dpbmc6IGlzRGVidWdnaW5nXG4gIH07XG4gIC8qKlxuICAgKiBBIHRyYWl0LWxlc3MgZXh0ZW5kZWQgc2VsZWN0b3IgY2xhc3MuXG4gICAqIEBwYXJhbSB7c3RyaW5nfSBzZWxlY3RvclRleHRcbiAgICogQHBhcmFtIHtib29sZWFuPX0gZGVidWdcbiAgICogQGNvbnN0cnVjdG9yXG4gICAqL1xuXG4gIGZ1bmN0aW9uIFRyYWl0TGVzc1NlbGVjdG9yKHNlbGVjdG9yVGV4dCwgZGVidWcpIHtcbiAgICB0aGlzLnNlbGVjdG9yVGV4dCA9IHNlbGVjdG9yVGV4dDtcbiAgICB0aGlzLmRlYnVnID0gZGVidWc7XG4gICAgU2l6emxlLmNvbXBpbGUoc2VsZWN0b3JUZXh0KTtcbiAgfVxuXG4gIFRyYWl0TGVzc1NlbGVjdG9yLnByb3RvdHlwZSA9IHtcbiAgICBxdWVyeVNlbGVjdG9yQWxsOiBmdW5jdGlvbiBxdWVyeVNlbGVjdG9yQWxsKCkge1xuICAgICAgcmV0dXJuIFNpenpsZSh0aGlzLnNlbGVjdG9yVGV4dCk7XG4gICAgfSxcblxuICAgIC8qKiBAZmluYWwgKi9cbiAgICBtYXRjaGVzOiBmdW5jdGlvbiBtYXRjaGVzKGVsZW1lbnQpIHtcbiAgICAgIHJldHVybiBTaXp6bGUubWF0Y2hlc1NlbGVjdG9yKGVsZW1lbnQsIHRoaXMuc2VsZWN0b3JUZXh0KTtcbiAgICB9LFxuXG4gICAgLyoqIEBmaW5hbCAqL1xuICAgIGlzRGVidWdnaW5nOiBpc0RlYnVnZ2luZ1xuICB9O1xuICAvKipcbiAgICogUGFyZW50YWwgY2xhc3MgZm9yIHN1Y2ggcHNldWRvLWNsYXNzZXMgYXMgeHBhdGgsIHVwd2FyZCwgcmVtb3ZlXG4gICAqIHdoaWNoIGFyZSBsaW1pdGVkIHRvIGJlIHRoZSBsYXN0IG9uZSB0b2tlbiBpbiBzZWxlY3RvclxuICAgKlxuICAgKiBAcGFyYW0ge3N0cmluZ30gc2VsZWN0b3JUZXh0XG4gICAqIEBwYXJhbSB7c3RyaW5nfSBwc2V1ZG9DbGFzc0FyZyBwc2V1ZG8tY2xhc3MgYXJnXG4gICAqIEBwYXJhbSB7Ym9vbGVhbj19IGRlYnVnXG4gICAqIEBjb25zdHJ1Y3RvclxuICAgKi9cblxuICBmdW5jdGlvbiBCYXNlTGFzdEFyZ3VtZW50U2VsZWN0b3Ioc2VsZWN0b3JUZXh0LCBwc2V1ZG9DbGFzc0FyZywgZGVidWcpIHtcbiAgICB0aGlzLnNlbGVjdG9yVGV4dCA9IHNlbGVjdG9yVGV4dDtcbiAgICB0aGlzLnBzZXVkb0NsYXNzQXJnID0gcHNldWRvQ2xhc3NBcmc7XG4gICAgdGhpcy5kZWJ1ZyA9IGRlYnVnO1xuICAgIFNpenpsZS5jb21waWxlKHRoaXMuc2VsZWN0b3JUZXh0KTtcbiAgfVxuXG4gIEJhc2VMYXN0QXJndW1lbnRTZWxlY3Rvci5wcm90b3R5cGUgPSB7XG4gICAgcXVlcnlTZWxlY3RvckFsbDogZnVuY3Rpb24gcXVlcnlTZWxlY3RvckFsbCgpIHtcbiAgICAgIHZhciBfdGhpcyA9IHRoaXM7XG5cbiAgICAgIHZhciByZXN1bHROb2RlcyA9IFtdO1xuICAgICAgdmFyIHNpbXBsZU5vZGVzO1xuXG4gICAgICBpZiAodGhpcy5zZWxlY3RvclRleHQpIHtcbiAgICAgICAgc2ltcGxlTm9kZXMgPSBTaXp6bGUodGhpcy5zZWxlY3RvclRleHQpO1xuXG4gICAgICAgIGlmICghc2ltcGxlTm9kZXMgfHwgIXNpbXBsZU5vZGVzLmxlbmd0aCkge1xuICAgICAgICAgIHJldHVybiByZXN1bHROb2RlcztcbiAgICAgICAgfVxuICAgICAgfSBlbHNlIHtcbiAgICAgICAgc2ltcGxlTm9kZXMgPSBbZG9jdW1lbnRdO1xuICAgICAgfVxuXG4gICAgICBzaW1wbGVOb2Rlcy5mb3JFYWNoKGZ1bmN0aW9uIChub2RlKSB7XG4gICAgICAgIF90aGlzLnNlYXJjaFJlc3VsdE5vZGVzKG5vZGUsIF90aGlzLnBzZXVkb0NsYXNzQXJnLCByZXN1bHROb2Rlcyk7XG4gICAgICB9KTtcbiAgICAgIHJldHVybiBTaXp6bGUudW5pcXVlU29ydChyZXN1bHROb2Rlcyk7XG4gICAgfSxcblxuICAgIC8qKiBAZmluYWwgKi9cbiAgICBtYXRjaGVzOiBmdW5jdGlvbiBtYXRjaGVzKGVsZW1lbnQpIHtcbiAgICAgIHZhciByZXN1bHRzID0gdGhpcy5xdWVyeVNlbGVjdG9yQWxsKCk7XG4gICAgICByZXR1cm4gcmVzdWx0cy5pbmRleE9mKGVsZW1lbnQpID4gLTE7XG4gICAgfSxcblxuICAgIC8qKiBAZmluYWwgKi9cbiAgICBpc0RlYnVnZ2luZzogaXNEZWJ1Z2dpbmcsXG5cbiAgICAvKipcbiAgICAgKiBQcmltaXRpdmUgbWV0aG9kIHRoYXQgcmV0dXJucyBhbGwgbm9kZXMgaWYgcHNldWRvLWNsYXNzIGFyZyBpcyBkZWZpbmVkLlxuICAgICAqIFRoYXQgbG9naWMgd29ya3MgZm9yIHJlbW92ZSBwc2V1ZG8tY2xhc3MsXG4gICAgICogYnV0IGZvciBvdGhlcnMgaXQgc2hvdWxkIGJlIG92ZXJyaWRkZW4uXG4gICAgICogQHBhcmFtIHtPYmplY3R9IG5vZGUgY29udGV4dCBlbGVtZW50XG4gICAgICogQHBhcmFtIHtzdHJpbmd9IHBzZXVkb0NsYXNzQXJnIHBzZXVkby1jbGFzcyBhcmd1bWVudFxuICAgICAqIEBwYXJhbSB7QXJyYXl9IHJlc3VsdFxuICAgICAqL1xuICAgIHNlYXJjaFJlc3VsdE5vZGVzOiBmdW5jdGlvbiBzZWFyY2hSZXN1bHROb2Rlcyhub2RlLCBwc2V1ZG9DbGFzc0FyZywgcmVzdWx0KSB7XG4gICAgICBpZiAocHNldWRvQ2xhc3NBcmcpIHtcbiAgICAgICAgcmVzdWx0LnB1c2gobm9kZSk7XG4gICAgICB9XG4gICAgfVxuICB9O1xuICAvKipcbiAgICogWHBhdGggc2VsZWN0b3IgY2xhc3NcbiAgICogTGltaXRlZCB0byBzdXBwb3J0ICd4cGF0aCcgdG8gYmUgb25seSB0aGUgbGFzdCBvbmUgdG9rZW4gaW4gc2VsZWN0b3JcbiAgICogQHBhcmFtIHtzdHJpbmd9IHNlbGVjdG9yVGV4dFxuICAgKiBAcGFyYW0ge3N0cmluZ30geHBhdGggdmFsdWVcbiAgICogQHBhcmFtIHtib29sZWFuPX0gZGVidWdcbiAgICogQGNvbnN0cnVjdG9yXG4gICAqIEBhdWdtZW50cyBCYXNlTGFzdEFyZ3VtZW50U2VsZWN0b3JcbiAgICovXG5cbiAgZnVuY3Rpb24gWHBhdGhTZWxlY3RvcihzZWxlY3RvclRleHQsIHhwYXRoLCBkZWJ1Zykge1xuICAgIHZhciBOT19TRUxFQ1RPUl9NQVJLRVIgPSAnOnhwYXRoKC8vJztcbiAgICB2YXIgQk9EWV9TRUxFQ1RPUl9SRVBMQUNFUiA9ICdib2R5OnhwYXRoKC8vJztcbiAgICB2YXIgbW9kaWZpZWRTZWxlY3RvclRleHQgPSBzZWxlY3RvclRleHQ7IC8vIE5vcm1hbGx5LCBhIHBzZXVkby1jbGFzcyBpcyBhcHBsaWVkIHRvIG5vZGVzIHNlbGVjdGVkIGJ5IGEgc2VsZWN0b3IgLS0gc2VsZWN0b3I6eHBhdGgoLi4uKS5cbiAgICAvLyBIb3dldmVyLCA6eHBhdGggaXMgc3BlY2lhbCBhcyB0aGUgc2VsZWN0b3IgY2FuIGJlIG9tbWl0ZWQuXG4gICAgLy8gRm9yIGFueSBvdGhlciBwc2V1ZG8tY2xhc3MgdGhhdCB3b3VsZCBtZWFuIFwiYXBwbHkgdG8gQUxMIERPTSBub2Rlc1wiLFxuICAgIC8vIGJ1dCBpbiBjYXNlIG9mIDp4cGF0aCBpdCBqdXN0IG1lYW5zIFwiYXBwbHkgbWUgdG8gdGhlIGRvY3VtZW50XCIuXG5cbiAgICBpZiAodXRpbHMuc3RhcnRzV2l0aChzZWxlY3RvclRleHQsIE5PX1NFTEVDVE9SX01BUktFUikpIHtcbiAgICAgIG1vZGlmaWVkU2VsZWN0b3JUZXh0ID0gc2VsZWN0b3JUZXh0LnJlcGxhY2UoTk9fU0VMRUNUT1JfTUFSS0VSLCBCT0RZX1NFTEVDVE9SX1JFUExBQ0VSKTtcbiAgICB9XG5cbiAgICBCYXNlTGFzdEFyZ3VtZW50U2VsZWN0b3IuY2FsbCh0aGlzLCBtb2RpZmllZFNlbGVjdG9yVGV4dCwgeHBhdGgsIGRlYnVnKTtcbiAgfVxuXG4gIFhwYXRoU2VsZWN0b3IucHJvdG90eXBlID0gT2JqZWN0LmNyZWF0ZShCYXNlTGFzdEFyZ3VtZW50U2VsZWN0b3IucHJvdG90eXBlKTtcbiAgWHBhdGhTZWxlY3Rvci5wcm90b3R5cGUuY29uc3RydWN0b3IgPSBYcGF0aFNlbGVjdG9yO1xuICAvKipcbiAgICogQXBwbGllcyB4cGF0aCBwc2V1ZG8tY2xhc3MgdG8gcHJvdmlkZWQgY29udGV4dCBub2RlXG4gICAqIEBwYXJhbSB7T2JqZWN0fSBub2RlIGNvbnRleHQgZWxlbWVudFxuICAgKiBAcGFyYW0ge3N0cmluZ30gcHNldWRvQ2xhc3NBcmcgeHBhdGhcbiAgICogQHBhcmFtIHtBcnJheX0gcmVzdWx0XG4gICAqIEBvdmVycmlkZVxuICAgKi9cblxuICBYcGF0aFNlbGVjdG9yLnByb3RvdHlwZS5zZWFyY2hSZXN1bHROb2RlcyA9IGZ1bmN0aW9uIChub2RlLCBwc2V1ZG9DbGFzc0FyZywgcmVzdWx0KSB7XG4gICAgdmFyIHhwYXRoUmVzdWx0ID0gZG9jdW1lbnQuZXZhbHVhdGUocHNldWRvQ2xhc3NBcmcsIG5vZGUsIG51bGwsIFhQYXRoUmVzdWx0LlVOT1JERVJFRF9OT0RFX0lURVJBVE9SX1RZUEUsIG51bGwpO1xuICAgIHZhciBpTm9kZTsgLy8gZXNsaW50LWRpc2FibGUtbmV4dC1saW5lIG5vLWNvbmQtYXNzaWduXG5cbiAgICB3aGlsZSAoaU5vZGUgPSB4cGF0aFJlc3VsdC5pdGVyYXRlTmV4dCgpKSB7XG4gICAgICByZXN1bHQucHVzaChpTm9kZSk7XG4gICAgfVxuICB9O1xuICAvKipcbiAgICogVXB3YXJkIHNlbGVjdG9yIGNsYXNzXG4gICAqIExpbWl0ZWQgdG8gc3VwcG9ydCAndXB3YXJkJyB0byBiZSBvbmx5IHRoZSBsYXN0IG9uZSB0b2tlbiBpbiBzZWxlY3RvclxuICAgKiBAcGFyYW0ge3N0cmluZ30gc2VsZWN0b3JUZXh0XG4gICAqIEBwYXJhbSB7c3RyaW5nfSB1cHdhcmRTZWxlY3RvciB2YWx1ZVxuICAgKiBAcGFyYW0ge2Jvb2xlYW49fSBkZWJ1Z1xuICAgKiBAY29uc3RydWN0b3JcbiAgICogQGF1Z21lbnRzIEJhc2VMYXN0QXJndW1lbnRTZWxlY3RvclxuICAgKi9cblxuXG4gIGZ1bmN0aW9uIFVwd2FyZFNlbGVjdG9yKHNlbGVjdG9yVGV4dCwgdXB3YXJkU2VsZWN0b3IsIGRlYnVnKSB7XG4gICAgQmFzZUxhc3RBcmd1bWVudFNlbGVjdG9yLmNhbGwodGhpcywgc2VsZWN0b3JUZXh0LCB1cHdhcmRTZWxlY3RvciwgZGVidWcpO1xuICB9XG5cbiAgVXB3YXJkU2VsZWN0b3IucHJvdG90eXBlID0gT2JqZWN0LmNyZWF0ZShCYXNlTGFzdEFyZ3VtZW50U2VsZWN0b3IucHJvdG90eXBlKTtcbiAgVXB3YXJkU2VsZWN0b3IucHJvdG90eXBlLmNvbnN0cnVjdG9yID0gVXB3YXJkU2VsZWN0b3I7XG4gIC8qKlxuICAgKiBBcHBsaWVzIHVwd2FyZCBwc2V1ZG8tY2xhc3MgdG8gcHJvdmlkZWQgY29udGV4dCBub2RlXG4gICAqIEBwYXJhbSB7T2JqZWN0fSBub2RlIGNvbnRleHQgZWxlbWVudFxuICAgKiBAcGFyYW0ge3N0cmluZ30gdXB3YXJkU2VsZWN0b3IgdXB3YXJkIHNlbGVjdG9yXG4gICAqIEBwYXJhbSB7QXJyYXl9IHJlc3VsdFxuICAgKiBAb3ZlcnJpZGVcbiAgICovXG5cbiAgVXB3YXJkU2VsZWN0b3IucHJvdG90eXBlLnNlYXJjaFJlc3VsdE5vZGVzID0gZnVuY3Rpb24gKG5vZGUsIHVwd2FyZFNlbGVjdG9yLCByZXN1bHQpIHtcbiAgICBpZiAodXB3YXJkU2VsZWN0b3IgIT09ICcnKSB7XG4gICAgICB2YXIgcGFyZW50ID0gbm9kZS5wYXJlbnRFbGVtZW50O1xuXG4gICAgICBpZiAocGFyZW50ID09PSBudWxsKSB7XG4gICAgICAgIHJldHVybjtcbiAgICAgIH1cblxuICAgICAgbm9kZSA9IHBhcmVudC5jbG9zZXN0KHVwd2FyZFNlbGVjdG9yKTtcblxuICAgICAgaWYgKG5vZGUgPT09IG51bGwpIHtcbiAgICAgICAgcmV0dXJuO1xuICAgICAgfVxuICAgIH1cblxuICAgIHJlc3VsdC5wdXNoKG5vZGUpO1xuICB9O1xuICAvKipcbiAgICogUmVtb3ZlIHNlbGVjdG9yIGNsYXNzXG4gICAqIExpbWl0ZWQgdG8gc3VwcG9ydCAncmVtb3ZlJyB0byBiZSBvbmx5IHRoZSBsYXN0IG9uZSB0b2tlbiBpbiBzZWxlY3RvclxuICAgKiBAcGFyYW0ge3N0cmluZ30gc2VsZWN0b3JUZXh0XG4gICAqIEBwYXJhbSB7Ym9vbGVhbn0gaGFzVmFsaWRSZW1vdmVQYXJ0XG4gICAqIEBwYXJhbSB7Ym9vbGVhbj19IGRlYnVnXG4gICAqIEBjb25zdHJ1Y3RvclxuICAgKiBAYXVnbWVudHMgQmFzZUxhc3RBcmd1bWVudFNlbGVjdG9yXG4gICAqL1xuXG5cbiAgZnVuY3Rpb24gUmVtb3ZlU2VsZWN0b3Ioc2VsZWN0b3JUZXh0LCBoYXNWYWxpZFJlbW92ZVBhcnQsIGRlYnVnKSB7XG4gICAgdmFyIFJFTU9WRV9QU0VVRE9fTUFSS0VSID0gJzpyZW1vdmUoKSc7XG4gICAgdmFyIHJlbW92ZU1hcmtlckluZGV4ID0gc2VsZWN0b3JUZXh0LmluZGV4T2YoUkVNT1ZFX1BTRVVET19NQVJLRVIpOyAvLyBkZWxldGluZyByZW1vdmUgcGFydCBvZiBydWxlIGluc3RlYWQgb2Ygd2hpY2hcbiAgICAvLyBwc2V1ZG8tcHJvcGVydHkgcHJvcGVydHkgJ3JlbW92ZScgd2lsbCBiZSBhZGRlZCBieSBFeHRlbmRlZENzc1BhcnNlclxuXG4gICAgdmFyIG1vZGlmaWVkU2VsZWN0b3JUZXh0ID0gc2VsZWN0b3JUZXh0LnNsaWNlKDAsIHJlbW92ZU1hcmtlckluZGV4KTtcbiAgICBCYXNlTGFzdEFyZ3VtZW50U2VsZWN0b3IuY2FsbCh0aGlzLCBtb2RpZmllZFNlbGVjdG9yVGV4dCwgaGFzVmFsaWRSZW1vdmVQYXJ0LCBkZWJ1Zyk7IC8vIG1hcmsgZXh0ZW5kZWRTZWxlY3RvciBhcyBSZW1vdmUgb25lIGZvciBFeHRlbmRlZENzc1BhcnNlclxuXG4gICAgdGhpcy5pc1JlbW92ZVNlbGVjdG9yID0gdHJ1ZTtcbiAgfVxuXG4gIFJlbW92ZVNlbGVjdG9yLnByb3RvdHlwZSA9IE9iamVjdC5jcmVhdGUoQmFzZUxhc3RBcmd1bWVudFNlbGVjdG9yLnByb3RvdHlwZSk7XG4gIFJlbW92ZVNlbGVjdG9yLnByb3RvdHlwZS5jb25zdHJ1Y3RvciA9IFJlbW92ZVNlbGVjdG9yO1xuICAvKipcbiAgICogQSBzcGxpdHRlZCBleHRlbmRlZCBzZWxlY3RvciBjbGFzcy5cbiAgICpcbiAgICogI2NvbnRhaW5lciAjZmVlZEl0ZW06aGFzKC5hZHMpXG4gICAqICstLS0tLS0tLSsgICAgICAgICAgICAgICAgICAgICBzaW1wbGVcbiAgICogICAgICAgICAgICsgICAgICAgICAgICAgICAgICAgIHJlbGF0aW9uXG4gICAqICAgICAgICAgICAgKy0tLS0tLS0tLS0tLS0tLS0tKyBjb21wbGV4XG4gICAqIFdlIHNwbGl0IHNlbGVjdG9yIG9ubHkgd2hlbiB0aGUgbGFzdCBzZWxlY3RvciBpcyBjb21wbGV4XG4gICAqIEBwYXJhbSB7c3RyaW5nfSBzZWxlY3RvclRleHRcbiAgICogQHBhcmFtIHtzdHJpbmd9IHNpbXBsZVxuICAgKiBAcGFyYW0ge3N0cmluZ30gcmVsYXRpb25cbiAgICogQHBhcmFtIHtzdHJpbmd9IGNvbXBsZXhcbiAgICogQHBhcmFtIHtib29sZWFuPX0gZGVidWdcbiAgICogQGNvbnN0cnVjdG9yXG4gICAqIEBleHRlbmRzIFRyYWl0TGVzc1NlbGVjdG9yXG4gICAqL1xuXG4gIGZ1bmN0aW9uIFNwbGl0dGVkU2VsZWN0b3Ioc2VsZWN0b3JUZXh0LCBzaW1wbGUsIHJlbGF0aW9uLCBjb21wbGV4LCBkZWJ1Zykge1xuICAgIFRyYWl0TGVzc1NlbGVjdG9yLmNhbGwodGhpcywgc2VsZWN0b3JUZXh0LCBkZWJ1Zyk7XG4gICAgdGhpcy5zaW1wbGUgPSBzaW1wbGU7XG4gICAgdGhpcy5yZWxhdGlvbiA9IHJlbGF0aW9uO1xuICAgIHRoaXMuY29tcGxleCA9IGNvbXBsZXg7XG4gICAgU2l6emxlLmNvbXBpbGUoY29tcGxleCk7XG4gIH1cblxuICBTcGxpdHRlZFNlbGVjdG9yLnByb3RvdHlwZSA9IE9iamVjdC5jcmVhdGUoVHJhaXRMZXNzU2VsZWN0b3IucHJvdG90eXBlKTtcbiAgU3BsaXR0ZWRTZWxlY3Rvci5wcm90b3R5cGUuY29uc3RydWN0b3IgPSBTcGxpdHRlZFNlbGVjdG9yO1xuICAvKiogQG92ZXJyaWRlICovXG5cbiAgU3BsaXR0ZWRTZWxlY3Rvci5wcm90b3R5cGUucXVlcnlTZWxlY3RvckFsbCA9IGZ1bmN0aW9uICgpIHtcbiAgICB2YXIgX3RoaXMyID0gdGhpcztcblxuICAgIHZhciByZXN1bHROb2RlcyA9IFtdO1xuICAgIHZhciBzaW1wbGVOb2RlcztcbiAgICB2YXIgc2ltcGxlID0gdGhpcy5zaW1wbGU7XG4gICAgdmFyIHJlbGF0aW9uO1xuXG4gICAgaWYgKHNpbXBsZSkge1xuICAgICAgLy8gRmlyc3Qgd2UgdXNlIHNpbXBsZSBzZWxlY3RvciB0byBuYXJyb3cgb3VyIHNlYXJjaFxuICAgICAgc2ltcGxlTm9kZXMgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yQWxsKHNpbXBsZSk7XG5cbiAgICAgIGlmICghc2ltcGxlTm9kZXMgfHwgIXNpbXBsZU5vZGVzLmxlbmd0aCkge1xuICAgICAgICByZXR1cm4gcmVzdWx0Tm9kZXM7XG4gICAgICB9XG5cbiAgICAgIHJlbGF0aW9uID0gdGhpcy5yZWxhdGlvbjtcbiAgICB9IGVsc2Uge1xuICAgICAgc2ltcGxlTm9kZXMgPSBbZG9jdW1lbnRdO1xuICAgICAgcmVsYXRpb24gPSAnICc7XG4gICAgfVxuXG4gICAgc3dpdGNoIChyZWxhdGlvbikge1xuICAgICAgY2FzZSAnICc6XG4gICAgICAgIHNpbXBsZU5vZGVzLmZvckVhY2goZnVuY3Rpb24gKG5vZGUpIHtcbiAgICAgICAgICBfdGhpczIucmVsYXRpdmVTZWFyY2gobm9kZSwgcmVzdWx0Tm9kZXMpO1xuICAgICAgICB9KTtcbiAgICAgICAgYnJlYWs7XG5cbiAgICAgIGNhc2UgJz4nOlxuICAgICAgICB7XG4gICAgICAgICAgc2ltcGxlTm9kZXMuZm9yRWFjaChmdW5jdGlvbiAobm9kZSkge1xuICAgICAgICAgICAgT2JqZWN0LnZhbHVlcyhub2RlLmNoaWxkcmVuKS5mb3JFYWNoKGZ1bmN0aW9uIChjaGlsZE5vZGUpIHtcbiAgICAgICAgICAgICAgaWYgKF90aGlzMi5tYXRjaGVzKGNoaWxkTm9kZSkpIHtcbiAgICAgICAgICAgICAgICByZXN1bHROb2Rlcy5wdXNoKGNoaWxkTm9kZSk7XG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH0pO1xuICAgICAgICAgIH0pO1xuICAgICAgICAgIGJyZWFrO1xuICAgICAgICB9XG5cbiAgICAgIGNhc2UgJysnOlxuICAgICAgICB7XG4gICAgICAgICAgc2ltcGxlTm9kZXMuZm9yRWFjaChmdW5jdGlvbiAobm9kZSkge1xuICAgICAgICAgICAgdmFyIHBhcmVudE5vZGUgPSBub2RlLnBhcmVudE5vZGU7XG4gICAgICAgICAgICBPYmplY3QudmFsdWVzKHBhcmVudE5vZGUuY2hpbGRyZW4pLmZvckVhY2goZnVuY3Rpb24gKGNoaWxkTm9kZSkge1xuICAgICAgICAgICAgICBpZiAoX3RoaXMyLm1hdGNoZXMoY2hpbGROb2RlKSAmJiBjaGlsZE5vZGUucHJldmlvdXNFbGVtZW50U2libGluZyA9PT0gbm9kZSkge1xuICAgICAgICAgICAgICAgIHJlc3VsdE5vZGVzLnB1c2goY2hpbGROb2RlKTtcbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfSk7XG4gICAgICAgICAgfSk7XG4gICAgICAgICAgYnJlYWs7XG4gICAgICAgIH1cblxuICAgICAgY2FzZSAnfic6XG4gICAgICAgIHtcbiAgICAgICAgICBzaW1wbGVOb2Rlcy5mb3JFYWNoKGZ1bmN0aW9uIChub2RlKSB7XG4gICAgICAgICAgICB2YXIgcGFyZW50Tm9kZSA9IG5vZGUucGFyZW50Tm9kZTtcbiAgICAgICAgICAgIE9iamVjdC52YWx1ZXMocGFyZW50Tm9kZS5jaGlsZHJlbikuZm9yRWFjaChmdW5jdGlvbiAoY2hpbGROb2RlKSB7XG4gICAgICAgICAgICAgIGlmIChfdGhpczIubWF0Y2hlcyhjaGlsZE5vZGUpICYmIG5vZGUuY29tcGFyZURvY3VtZW50UG9zaXRpb24oY2hpbGROb2RlKSA9PT0gNCkge1xuICAgICAgICAgICAgICAgIHJlc3VsdE5vZGVzLnB1c2goY2hpbGROb2RlKTtcbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfSk7XG4gICAgICAgICAgfSk7XG4gICAgICAgICAgYnJlYWs7XG4gICAgICAgIH1cbiAgICB9XG5cbiAgICByZXR1cm4gU2l6emxlLnVuaXF1ZVNvcnQocmVzdWx0Tm9kZXMpO1xuICB9O1xuICAvKipcbiAgICogUGVyZm9ybXMgYSBzZWFyY2ggb2YgXCJjb21wbGV4XCIgcGFydCByZWxhdGl2ZSB0byByZXN1bHRzIGZvciB0aGUgXCJzaW1wbGVcIiBwYXJ0LlxuICAgKiBAcGFyYW0ge05vZGV9IG5vZGUgYSBub2RlIG1hdGNoaW5nIHRoZSBcInNpbXBsZVwiIHBhcnQuXG4gICAqIEBwYXJhbSB7Tm9kZVtdfSByZXN1bHQgYW4gYXJyYXkgdG8gYXBwZW5kIHNlYXJjaCByZXN1bHQuXG4gICAqL1xuXG5cbiAgU3BsaXR0ZWRTZWxlY3Rvci5wcm90b3R5cGUucmVsYXRpdmVTZWFyY2ggPSBmdW5jdGlvbiAobm9kZSwgcmVzdWx0cykge1xuICAgIFNpenpsZSh0aGlzLmNvbXBsZXgsIG5vZGUsIHJlc3VsdHMpO1xuICB9O1xuXG4gIHJldHVybiB7XG4gICAgLyoqXG4gICAgICogV3JhcHMgdGhlIGlubmVyIGNsYXNzIHNvIHRoYXQgdGhlIGluc3RhbmNlIGlzIG5vdCBleHBvc2VkLlxuICAgICAqL1xuICAgIGNyZWF0ZVNlbGVjdG9yOiBmdW5jdGlvbiBjcmVhdGVTZWxlY3RvcihzZWxlY3RvciwgdG9rZW5zLCBkZWJ1Zykge1xuICAgICAgcmV0dXJuIG5ldyBFeHRlbmRlZFNlbGVjdG9yUGFyc2VyKHNlbGVjdG9yLCB0b2tlbnMsIGRlYnVnKS5jcmVhdGVTZWxlY3RvcigpO1xuICAgIH0sXG5cbiAgICAvKipcbiAgICAgKiBNYXJrIGV2ZXJ5IHNlbGVjdG9yIGFzIGEgc2VsZWN0b3IgYmVpbmcgZGVidWdnZWQsIHNvIHRoYXQgdGltaW5nIGluZm9ybWF0aW9uXG4gICAgICogZm9yIHRoZSBzZWxlY3RvciBpcyBwcmludGVkIHRvIHRoZSBjb25zb2xlLlxuICAgICAqL1xuICAgIGVuYWJsZUdsb2JhbERlYnVnZ2luZzogZnVuY3Rpb24gZW5hYmxlR2xvYmFsRGVidWdnaW5nKCkge1xuICAgICAgZ2xvYmFsRGVidWdnaW5nRmxhZyA9IHRydWU7XG4gICAgfVxuICB9O1xufSgpO1xuXG4vKipcbiAqIENvcHlyaWdodCAyMDE2IEFkZ3VhcmQgU29mdHdhcmUgTHRkXG4gKlxuICogTGljZW5zZWQgdW5kZXIgdGhlIEFwYWNoZSBMaWNlbnNlLCBWZXJzaW9uIDIuMCAodGhlIFwiTGljZW5zZVwiKTtcbiAqIHlvdSBtYXkgbm90IHVzZSB0aGlzIGZpbGUgZXhjZXB0IGluIGNvbXBsaWFuY2Ugd2l0aCB0aGUgTGljZW5zZS5cbiAqIFlvdSBtYXkgb2J0YWluIGEgY29weSBvZiB0aGUgTGljZW5zZSBhdFxuICpcbiAqIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMFxuICpcbiAqIFVubGVzcyByZXF1aXJlZCBieSBhcHBsaWNhYmxlIGxhdyBvciBhZ3JlZWQgdG8gaW4gd3JpdGluZywgc29mdHdhcmVcbiAqIGRpc3RyaWJ1dGVkIHVuZGVyIHRoZSBMaWNlbnNlIGlzIGRpc3RyaWJ1dGVkIG9uIGFuIFwiQVMgSVNcIiBCQVNJUyxcbiAqIFdJVEhPVVQgV0FSUkFOVElFUyBPUiBDT05ESVRJT05TIE9GIEFOWSBLSU5ELCBlaXRoZXIgZXhwcmVzcyBvciBpbXBsaWVkLlxuICogU2VlIHRoZSBMaWNlbnNlIGZvciB0aGUgc3BlY2lmaWMgbGFuZ3VhZ2UgZ292ZXJuaW5nIHBlcm1pc3Npb25zIGFuZFxuICogbGltaXRhdGlvbnMgdW5kZXIgdGhlIExpY2Vuc2UuXG4gKi9cbi8qKlxuICogQSBoZWxwZXIgY2xhc3MgdGhhdCBwYXJzZXMgc3R5bGVzaGVldHMgY29udGFpbmluZyBleHRlbmRlZCBzZWxlY3RvcnNcbiAqIGludG8gRXh0ZW5kZWRTZWxlY3RvciBpbnN0YW5jZXMgYW5kIGtleS12YWx1ZSBtYXBzIG9mIHN0eWxlIGRlY2xhcmF0aW9ucy5cbiAqIFBsZWFzZSBub3RlLCB0aGF0IGl0IGRvZXMgbm90IHN1cHBvcnQgYW55IGNvbXBsZXggdGhpbmdzIGxpa2UgbWVkaWEgcXVlcmllcyBhbmQgc3VjaC5cbiAqL1xuXG52YXIgRXh0ZW5kZWRDc3NQYXJzZXIgPSBmdW5jdGlvbiAoKSB7XG4gIHZhciByZURlY2xFbmQgPSAvWzt9XS9nO1xuICB2YXIgcmVEZWNsRGl2aWRlciA9IC9bOzp9XS9nO1xuICB2YXIgcmVOb25XaGl0ZXNwYWNlID0gL1xcUy9nO1xuICB2YXIgU2l6emxlO1xuICAvKipcbiAgICogQHBhcmFtIHtzdHJpbmd9IGNzc1RleHRcbiAgICogQGNvbnN0cnVjdG9yXG4gICAqL1xuXG4gIGZ1bmN0aW9uIFBhcnNlcihjc3NUZXh0KSB7XG4gICAgdGhpcy5jc3NUZXh0ID0gY3NzVGV4dDtcbiAgfVxuXG4gIFBhcnNlci5wcm90b3R5cGUgPSB7XG4gICAgZXJyb3I6IGZ1bmN0aW9uIGVycm9yKHBvc2l0aW9uKSB7XG4gICAgICB0aHJvdyBuZXcgRXJyb3IoXCJDc3NQYXJzZXI6IHBhcnNlIGVycm9yIGF0IHBvc2l0aW9uIFwiLmNvbmNhdCh0aGlzLnBvc09mZnNldCArIHBvc2l0aW9uKSk7XG4gICAgfSxcblxuICAgIC8qKlxuICAgICAqIFZhbGlkYXRlcyB0aGF0IHRoZSB0b2tlbnMgY29ycmVzcG9uZCB0byBhIHZhbGlkIHNlbGVjdG9yLlxuICAgICAqIFNpenpsZSBpcyBkaWZmZXJlbnQgZnJvbSBicm93c2VycyBhbmQgc29tZSBzZWxlY3RvcnMgdGhhdCBpdCB0b2xlcmF0ZXMgYXJlbid0IGFjdHVhbGx5IHZhbGlkLlxuICAgICAqIEZvciBpbnN0YW5jZSwgXCJkaXYgPlwiIHdvbid0IHdvcmsgaW4gYSBicm93c2VyLCBidXQgaXQgd2lsbCBpbiBTaXp6bGUgKGl0J2QgYmUgdGhlIHNhbWUgYXMgXCJkaXYgPiAqXCIpLlxuICAgICAqXG4gICAgICogQHBhcmFtIHsqfSBzZWxlY3RvcnMgQW4gYXJyYXkgb2YgU2VsZWN0b3JEYXRhIChzZWxlY3RvciwgZ3JvdXBzKVxuICAgICAqIEByZXR1cm5zIHtib29sZWFufSBmYWxzZSBpZiBhbnkgb2YgdGhlIGdyb3VwcyBhcmUgaW52YWxpZFxuICAgICAqL1xuICAgIHZhbGlkYXRlU2VsZWN0b3JzOiBmdW5jdGlvbiB2YWxpZGF0ZVNlbGVjdG9ycyhzZWxlY3RvcnMpIHtcbiAgICAgIHZhciBpU2VsZWN0b3JzID0gc2VsZWN0b3JzLmxlbmd0aDtcblxuICAgICAgd2hpbGUgKGlTZWxlY3RvcnMtLSkge1xuICAgICAgICB2YXIgZ3JvdXBzID0gc2VsZWN0b3JzW2lTZWxlY3RvcnNdLmdyb3VwcztcbiAgICAgICAgdmFyIGlHcm91cHMgPSBncm91cHMubGVuZ3RoO1xuXG4gICAgICAgIHdoaWxlIChpR3JvdXBzLS0pIHtcbiAgICAgICAgICB2YXIgdG9rZW5zID0gZ3JvdXBzW2lHcm91cHNdO1xuICAgICAgICAgIHZhciBsYXN0VG9rZW4gPSB0b2tlbnNbdG9rZW5zLmxlbmd0aCAtIDFdO1xuXG4gICAgICAgICAgaWYgKFNpenpsZS5zZWxlY3RvcnMucmVsYXRpdmVbbGFzdFRva2VuLnR5cGVdKSB7XG4gICAgICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICAgICAgfVxuICAgICAgICB9XG4gICAgICB9XG5cbiAgICAgIHJldHVybiB0cnVlO1xuICAgIH0sXG5cbiAgICAvKipcbiAgICAgKiBQYXJzZXMgYSBzdHlsZXNoZWV0IGFuZCByZXR1cm5zIGEgbGlzdCBvZiBwYWlycyBvZiBhbiBFeHRlbmRlZFNlbGVjdG9yIGFuZCBhIHN0eWxlcyBtYXAuXG4gICAgICogVGhpcyBtZXRob2Qgd2lsbCB0aHJvdyBhbiBlcnJvciBpbiBjYXNlIG9mIGFuIG9idmlvdXNseSBpbnZhbGlkIGlucHV0LlxuICAgICAqIElmIGFueSBvZiB0aGUgc2VsZWN0b3JzIHVzZWQgaW4gdGhlIHN0eWxlc2hlZXQgY2Fubm90IGJlIGNvbXBpbGVkIGludG8gYW4gRXh0ZW5kZWRTZWxlY3RvcixcbiAgICAgKiBpdCB3aWxsIGJlIGlnbm9yZWQuXG4gICAgICpcbiAgICAgKiBAdHlwZWRlZiB7T2JqZWN0fSBFeHRlbmRlZFN0eWxlXG4gICAgICogQHByb3BlcnR5IHtPYmplY3R9IHNlbGVjdG9yIEFuIGluc3RhbmNlIG9mIHRoZSB7QGxpbmsgRXh0ZW5kZWRTZWxlY3Rvcn0gY2xhc3NcbiAgICAgKiBAcHJvcGVydHkge09iamVjdH0gc3R5bGVNYXAgQSBtYXAgb2Ygc3R5bGVzIHBhcnNlZFxuICAgICAqXG4gICAgICogQHJldHVybnMge0FycmF5LjxFeHRlbmRlZFN0eWxlPn0gQW4gYXJyYXkgb2YgdGhlIHN0eWxlcyBwYXJzZWRcbiAgICAgKi9cbiAgICBwYXJzZUNzczogZnVuY3Rpb24gcGFyc2VDc3MoKSB7XG4gICAgICB0aGlzLnBvc09mZnNldCA9IDA7XG5cbiAgICAgIGlmICghdGhpcy5jc3NUZXh0KSB7XG4gICAgICAgIHRoaXMuZXJyb3IoMCk7XG4gICAgICB9XG5cbiAgICAgIHZhciByZXN1bHRzID0gW107XG5cbiAgICAgIHdoaWxlICh0aGlzLmNzc1RleHQpIHtcbiAgICAgICAgLy8gQXBwbHkgdG9sZXJhbnQgdG9rZW5pemF0aW9uLlxuICAgICAgICB2YXIgcGFyc2VSZXN1bHQgPSBTaXp6bGUudG9rZW5pemUodGhpcy5jc3NUZXh0LCBmYWxzZSwge1xuICAgICAgICAgIHRvbGVyYW50OiB0cnVlLFxuICAgICAgICAgIHJldHVyblVuc29ydGVkOiB0cnVlXG4gICAgICAgIH0pO1xuICAgICAgICB2YXIgc2VsZWN0b3JEYXRhID0gcGFyc2VSZXN1bHQuc2VsZWN0b3JzO1xuICAgICAgICB0aGlzLm5leHRJbmRleCA9IHBhcnNlUmVzdWx0Lm5leHRJbmRleDtcblxuICAgICAgICBpZiAodGhpcy5jc3NUZXh0LmNoYXJDb2RlQXQodGhpcy5uZXh0SW5kZXgpICE9PSAxMjMgfHxcbiAgICAgICAgLyogY2hhckNvZGUgb2YgJ3snICovXG4gICAgICAgICF0aGlzLnZhbGlkYXRlU2VsZWN0b3JzKHNlbGVjdG9yRGF0YSkpIHtcbiAgICAgICAgICB0aGlzLmVycm9yKHRoaXMubmV4dEluZGV4KTtcbiAgICAgICAgfVxuXG4gICAgICAgIHRoaXMubmV4dEluZGV4Kys7IC8vIE1vdmUgdGhlIHBvaW50ZXIgdG8gdGhlIHN0YXJ0IG9mIHN0eWxlIGRlY2xhcmF0aW9uLlxuXG4gICAgICAgIHZhciBzdHlsZU1hcCA9IHRoaXMucGFyc2VOZXh0U3R5bGUoKTtcbiAgICAgICAgdmFyIGRlYnVnID0gZmFsc2U7IC8vIElmIHRoZXJlIGlzIGEgc3R5bGUgcHJvcGVydHkgJ2RlYnVnJywgbWFyayB0aGUgc2VsZWN0b3JcbiAgICAgICAgLy8gYXMgYSBkZWJ1Z2dhYmxlIHNlbGVjdG9yLCBhbmQgZGVsZXRlIHRoZSBzdHlsZSBkZWNsYXJhdGlvbi5cblxuICAgICAgICB2YXIgZGVidWdQcm9wZXJ0eVZhbHVlID0gc3R5bGVNYXBbJ2RlYnVnJ107XG5cbiAgICAgICAgaWYgKHR5cGVvZiBkZWJ1Z1Byb3BlcnR5VmFsdWUgIT09ICd1bmRlZmluZWQnKSB7XG4gICAgICAgICAgaWYgKGRlYnVnUHJvcGVydHlWYWx1ZSA9PT0gJ2dsb2JhbCcpIHtcbiAgICAgICAgICAgIEV4dGVuZGVkU2VsZWN0b3JGYWN0b3J5LmVuYWJsZUdsb2JhbERlYnVnZ2luZygpO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIGRlYnVnID0gdHJ1ZTtcbiAgICAgICAgICBkZWxldGUgc3R5bGVNYXBbJ2RlYnVnJ107XG4gICAgICAgIH0gLy8gQ3JlYXRpbmcgYW4gRXh0ZW5kZWRTZWxlY3RvciBpbnN0YW5jZSBmb3IgZXZlcnkgc2VsZWN0b3Igd2UgZ290IGZyb20gU2l6emxlLnRva2VuaXplLlxuICAgICAgICAvLyBUaGlzIGlzIHF1aXRlIGltcG9ydGFudCBhcyBTaXp6bGUgZG9lcyBhIHBvb3Igam9iIGF0IGV4ZWN1dGluZyBzZWxlY3RvcnMgbGlrZSBcInNlbGVjdG9yMSwgc2VsZWN0b3IyXCIuXG5cblxuICAgICAgICBmb3IgKHZhciBpID0gMCwgbCA9IHNlbGVjdG9yRGF0YS5sZW5ndGg7IGkgPCBsOyBpKyspIHtcbiAgICAgICAgICB2YXIgZGF0YSA9IHNlbGVjdG9yRGF0YVtpXTtcblxuICAgICAgICAgIHRyeSB7XG4gICAgICAgICAgICB2YXIgZXh0ZW5kZWRTZWxlY3RvciA9IEV4dGVuZGVkU2VsZWN0b3JGYWN0b3J5LmNyZWF0ZVNlbGVjdG9yKGRhdGEuc2VsZWN0b3JUZXh0LCBkYXRhLmdyb3VwcywgZGVidWcpO1xuXG4gICAgICAgICAgICBpZiAoZXh0ZW5kZWRTZWxlY3Rvci5wc2V1ZG9DbGFzc0FyZyAmJiBleHRlbmRlZFNlbGVjdG9yLmlzUmVtb3ZlU2VsZWN0b3IpIHtcbiAgICAgICAgICAgICAgLy8gaWYgdGhlcmUgaXMgcmVtb3ZlIHBzZXVkby1jbGFzcyBpbiBydWxlLFxuICAgICAgICAgICAgICAvLyB0aGUgZWxlbWVudCB3aWxsIGJlIHJlbW92ZWQgYW5kIG5vIG90aGVyIHN0eWxlcyB3aWxsIGJlIGFwcGxpZWRcbiAgICAgICAgICAgICAgc3R5bGVNYXBbJ3JlbW92ZSddID0gJ3RydWUnO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICByZXN1bHRzLnB1c2goe1xuICAgICAgICAgICAgICBzZWxlY3RvcjogZXh0ZW5kZWRTZWxlY3RvcixcbiAgICAgICAgICAgICAgc3R5bGU6IHN0eWxlTWFwXG4gICAgICAgICAgICB9KTtcbiAgICAgICAgICB9IGNhdGNoIChleCkge1xuICAgICAgICAgICAgdXRpbHMubG9nRXJyb3IoXCJFeHRlbmRlZENzc1BhcnNlcjogaWdub3JpbmcgaW52YWxpZCBzZWxlY3RvciBcIi5jb25jYXQoZGF0YS5zZWxlY3RvclRleHQpKTtcbiAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICAgIH1cblxuICAgICAgcmV0dXJuIHJlc3VsdHM7XG4gICAgfSxcbiAgICBwYXJzZU5leHRTdHlsZTogZnVuY3Rpb24gcGFyc2VOZXh0U3R5bGUoKSB7XG4gICAgICB2YXIgc3R5bGVNYXAgPSBPYmplY3QuY3JlYXRlKG51bGwpO1xuICAgICAgdmFyIGJyYWNrZXRQb3MgPSB0aGlzLnBhcnNlVW50aWxDbG9zaW5nQnJhY2tldChzdHlsZU1hcCk7IC8vIEN1dCBvdXQgbWF0Y2hlZCBwb3J0aW9uIGZyb20gY3NzVGV4dC5cblxuICAgICAgcmVOb25XaGl0ZXNwYWNlLmxhc3RJbmRleCA9IGJyYWNrZXRQb3MgKyAxO1xuICAgICAgdmFyIG1hdGNoID0gcmVOb25XaGl0ZXNwYWNlLmV4ZWModGhpcy5jc3NUZXh0KTtcblxuICAgICAgaWYgKG1hdGNoID09PSBudWxsKSB7XG4gICAgICAgIHRoaXMuY3NzVGV4dCA9ICcnO1xuICAgICAgICByZXR1cm4gc3R5bGVNYXA7XG4gICAgICB9XG5cbiAgICAgIHZhciBtYXRjaFBvcyA9IG1hdGNoLmluZGV4O1xuICAgICAgdGhpcy5jc3NUZXh0ID0gdGhpcy5jc3NUZXh0LnNsaWNlKG1hdGNoUG9zKTtcbiAgICAgIHRoaXMucG9zT2Zmc2V0ICs9IG1hdGNoUG9zO1xuICAgICAgcmV0dXJuIHN0eWxlTWFwO1xuICAgIH0sXG5cbiAgICAvKipcbiAgICAgKiBAcmV0dXJuIHtudW1iZXJ9IGFuIGluZGV4IG9mIHRoZSBuZXh0ICd9JyBpbiBgdGhpcy5jc3NUZXh0YC5cbiAgICAgKi9cbiAgICBwYXJzZVVudGlsQ2xvc2luZ0JyYWNrZXQ6IGZ1bmN0aW9uIHBhcnNlVW50aWxDbG9zaW5nQnJhY2tldChzdHlsZU1hcCkge1xuICAgICAgLy8gRXhwZWN0cyBcIjpcIiwgXCI7XCIsIGFuZCBcIn1cIi5cbiAgICAgIHJlRGVjbERpdmlkZXIubGFzdEluZGV4ID0gdGhpcy5uZXh0SW5kZXg7XG4gICAgICB2YXIgbWF0Y2ggPSByZURlY2xEaXZpZGVyLmV4ZWModGhpcy5jc3NUZXh0KTtcblxuICAgICAgaWYgKG1hdGNoID09PSBudWxsKSB7XG4gICAgICAgIHRoaXMuZXJyb3IodGhpcy5uZXh0SW5kZXgpO1xuICAgICAgfVxuXG4gICAgICB2YXIgbWF0Y2hQb3MgPSBtYXRjaC5pbmRleDtcbiAgICAgIHZhciBtYXRjaGVkID0gbWF0Y2hbMF07XG5cbiAgICAgIGlmIChtYXRjaGVkID09PSAnfScpIHtcbiAgICAgICAgcmV0dXJuIG1hdGNoUG9zO1xuICAgICAgfVxuXG4gICAgICBpZiAobWF0Y2hlZCA9PT0gJzonKSB7XG4gICAgICAgIHZhciBjb2xvbkluZGV4ID0gbWF0Y2hQb3M7IC8vIEV4cGVjdHMgXCI7XCIgYW5kIFwifVwiLlxuXG4gICAgICAgIHJlRGVjbEVuZC5sYXN0SW5kZXggPSBjb2xvbkluZGV4O1xuICAgICAgICBtYXRjaCA9IHJlRGVjbEVuZC5leGVjKHRoaXMuY3NzVGV4dCk7XG5cbiAgICAgICAgaWYgKG1hdGNoID09PSBudWxsKSB7XG4gICAgICAgICAgdGhpcy5lcnJvcihjb2xvbkluZGV4KTtcbiAgICAgICAgfVxuXG4gICAgICAgIG1hdGNoUG9zID0gbWF0Y2guaW5kZXg7XG4gICAgICAgIG1hdGNoZWQgPSBtYXRjaFswXTsgLy8gUG9wdWxhdGVzIHRoZSBgc3R5bGVNYXBgIGtleS12YWx1ZSBtYXAuXG5cbiAgICAgICAgdmFyIHByb3BlcnR5ID0gdGhpcy5jc3NUZXh0LnNsaWNlKHRoaXMubmV4dEluZGV4LCBjb2xvbkluZGV4KS50cmltKCk7XG4gICAgICAgIHZhciB2YWx1ZSA9IHRoaXMuY3NzVGV4dC5zbGljZShjb2xvbkluZGV4ICsgMSwgbWF0Y2hQb3MpLnRyaW0oKTtcbiAgICAgICAgc3R5bGVNYXBbcHJvcGVydHldID0gdmFsdWU7IC8vIElmIGZvdW5kIFwifVwiLCByZS1ydW4gdGhlIG91dGVyIGxvb3AuXG5cbiAgICAgICAgaWYgKG1hdGNoZWQgPT09ICd9Jykge1xuICAgICAgICAgIHJldHVybiBtYXRjaFBvcztcbiAgICAgICAgfVxuICAgICAgfSAvLyBtYXRjaFBvcyBpcyB0aGUgcG9zaXRpb24gb2YgdGhlIG5leHQgJzsnLlxuICAgICAgLy8gSW5jcmVhc2UgJ25leHRJbmRleCcgYW5kIHJlLXJ1biB0aGUgbG9vcC5cblxuXG4gICAgICB0aGlzLm5leHRJbmRleCA9IG1hdGNoUG9zICsgMTtcbiAgICAgIHJldHVybiB0aGlzLnBhcnNlVW50aWxDbG9zaW5nQnJhY2tldChzdHlsZU1hcCk7IC8vIFNob3VsZCBiZSBhIHN1YmplY3Qgb2YgdGFpbC1jYWxsIG9wdGltaXphdGlvbi5cbiAgICB9XG4gIH07XG4gIHJldHVybiB7XG4gICAgcGFyc2VDc3M6IGZ1bmN0aW9uIHBhcnNlQ3NzKGNzc1RleHQpIHtcbiAgICAgIFNpenpsZSA9IGluaXRpYWxpemVTaXp6bGUoKTtcbiAgICAgIHJldHVybiBuZXcgUGFyc2VyKGNzc1V0aWxzLm5vcm1hbGl6ZShjc3NUZXh0KSkucGFyc2VDc3MoKTtcbiAgICB9XG4gIH07XG59KCk7XG5cbi8qKlxuICogVGhpcyBjYWxsYmFjayBpcyB1c2VkIHRvIGdldCBhZmZlY3RlZCBub2RlIGVsZW1lbnRzIGFuZCBoYW5kbGUgc3R5bGUgcHJvcGVydGllc1xuICogYmVmb3JlIHRoZXkgYXJlIGFwcGxpZWQgdG8gdGhlbSBpZiBpdCBpcyBuZWNlc3NhcnlcbiAqIEBjYWxsYmFjayBiZWZvcmVTdHlsZUFwcGxpZWRcbiAqIEBwYXJhbSB7b2JqZWN0fSBhZmZlY3RlZEVsZW1lbnQgLSBPYmplY3QgY29udGFpbmluZyBET00gbm9kZSBhbmQgcnVsZSB0byBiZSBhcHBsaWVkXG4gKiBAcmV0dXJuIHtvYmplY3R9IGFmZmVjdGVkRWxlbWVudCAtIFNhbWUgb3IgbW9kaWZpZWQgb2JqZWN0IGNvbnRhaW5pbmcgRE9NIG5vZGUgYW5kIHJ1bGUgdG8gYmUgYXBwbGllZFxuICovXG5cbi8qKlxuICogRXh0ZW5kZWQgY3NzIGNsYXNzXG4gKlxuICogQHBhcmFtIHtPYmplY3R9IGNvbmZpZ3VyYXRpb25cbiAqIEBwYXJhbSB7c3RyaW5nfSBjb25maWd1cmF0aW9uLnN0eWxlU2hlZXQgLSB0aGUgQ1NTIHN0eWxlc2hlZXQgdGV4dFxuICogQHBhcmFtIHtiZWZvcmVTdHlsZUFwcGxpZWR9IFtjb25maWd1cmF0aW9uLmJlZm9yZVN0eWxlQXBwbGllZF0gLSB0aGUgY2FsbGJhY2sgdGhhdCBoYW5kbGVzIGFmZmVjdGVkIGVsZW1lbnRzXG4gKiBAY29uc3RydWN0b3JcbiAqL1xuXG5mdW5jdGlvbiBFeHRlbmRlZENzcyhjb25maWd1cmF0aW9uKSB7XG4gIGlmICghY29uZmlndXJhdGlvbikge1xuICAgIHRocm93IG5ldyBFcnJvcignQ29uZmlndXJhdGlvbiBpcyBub3QgcHJvdmlkZWQuJyk7XG4gIH1cblxuICB2YXIgc3R5bGVTaGVldCA9IGNvbmZpZ3VyYXRpb24uc3R5bGVTaGVldDtcbiAgdmFyIGJlZm9yZVN0eWxlQXBwbGllZCA9IGNvbmZpZ3VyYXRpb24uYmVmb3JlU3R5bGVBcHBsaWVkO1xuXG4gIGlmIChiZWZvcmVTdHlsZUFwcGxpZWQgJiYgdHlwZW9mIGJlZm9yZVN0eWxlQXBwbGllZCAhPT0gJ2Z1bmN0aW9uJykge1xuICAgIC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBtYXgtbGVuXG4gICAgdGhyb3cgbmV3IEVycm9yKFwiV3JvbmcgY29uZmlndXJhdGlvbi4gVHlwZSBvZiAnYmVmb3JlU3R5bGVBcHBsaWVkJyBmaWVsZCBzaG91bGQgYmUgYSBmdW5jdGlvbiwgcmVjZWl2ZWQ6IFwiLmNvbmNhdChfdHlwZW9mKGJlZm9yZVN0eWxlQXBwbGllZCkpKTtcbiAgfSAvLyBXZSB1c2UgRXZlbnRUcmFja2VyIHRvIHRyYWNrIHRoZSBldmVudCB0aGF0IGlzIGxpa2VseSB0byBjYXVzZSB0aGUgbXV0YXRpb24uXG4gIC8vIFRoZSBwcm9ibGVtIGlzIHRoYXQgd2UgY2Fubm90IHVzZSBgd2luZG93LmV2ZW50YCBkaXJlY3RseSBmcm9tIHRoZSBtdXRhdGlvbiBvYnNlcnZlciBjYWxsXG4gIC8vIGFzIHdlJ3JlIG5vdCBpbiB0aGUgZXZlbnQgaGFuZGxlciBjb250ZXh0IGFueW1vcmUuXG5cblxuICB2YXIgRXZlbnRUcmFja2VyID0gZnVuY3Rpb24gKCkge1xuICAgIHZhciBpZ25vcmVkRXZlbnRUeXBlcyA9IFsnbW91c2VvdmVyJywgJ21vdXNlbGVhdmUnLCAnbW91c2VlbnRlcicsICdtb3VzZW91dCddO1xuICAgIHZhciBMQVNUX0VWRU5UX1RJTUVPVVRfTVMgPSAxMDtcbiAgICB2YXIgRVZFTlRTID0gWy8vIGtleWJvYXJkIGV2ZW50c1xuICAgICdrZXlkb3duJywgJ2tleXByZXNzJywgJ2tleXVwJywgLy8gbW91c2UgZXZlbnRzXG4gICAgJ2F1eGNsaWNrJywgJ2NsaWNrJywgJ2NvbnRleHRtZW51JywgJ2RibGNsaWNrJywgJ21vdXNlZG93bicsICdtb3VzZWVudGVyJywgJ21vdXNlbGVhdmUnLCAnbW91c2Vtb3ZlJywgJ21vdXNlb3ZlcicsICdtb3VzZW91dCcsICdtb3VzZXVwJywgJ3BvaW50ZXJsb2NrY2hhbmdlJywgJ3BvaW50ZXJsb2NrZXJyb3InLCAnc2VsZWN0JywgJ3doZWVsJ107IC8vICd3aGVlbCcgZXZlbnQgbWFrZXMgc2Nyb2xsaW5nIGluIFNhZmFyaSB0d2l0Y2h5XG4gICAgLy8gaHR0cHM6Ly9naXRodWIuY29tL0FkZ3VhcmRUZWFtL0V4dGVuZGVkQ3NzL2lzc3Vlcy8xMjBcblxuICAgIHZhciBzYWZhcmlQcm9ibGVtYXRpY0V2ZW50cyA9IFsnd2hlZWwnXTtcbiAgICB2YXIgdHJhY2tlZEV2ZW50cyA9IHV0aWxzLmlzU2FmYXJpQnJvd3NlciA/IEVWRU5UUy5maWx0ZXIoZnVuY3Rpb24gKGVsKSB7XG4gICAgICByZXR1cm4gIShzYWZhcmlQcm9ibGVtYXRpY0V2ZW50cy5pbmRleE9mKGVsKSA+IC0xKTtcbiAgICB9KSA6IEVWRU5UUztcbiAgICB2YXIgbGFzdEV2ZW50VHlwZTtcbiAgICB2YXIgbGFzdEV2ZW50VGltZTtcblxuICAgIHZhciB0cmFja0V2ZW50ID0gZnVuY3Rpb24gdHJhY2tFdmVudChlKSB7XG4gICAgICBsYXN0RXZlbnRUeXBlID0gZS50eXBlO1xuICAgICAgbGFzdEV2ZW50VGltZSA9IERhdGUubm93KCk7XG4gICAgfTtcblxuICAgIHRyYWNrZWRFdmVudHMuZm9yRWFjaChmdW5jdGlvbiAoZXZOYW1lKSB7XG4gICAgICBkb2N1bWVudC5kb2N1bWVudEVsZW1lbnQuYWRkRXZlbnRMaXN0ZW5lcihldk5hbWUsIHRyYWNrRXZlbnQsIHRydWUpO1xuICAgIH0pO1xuXG4gICAgdmFyIGdldExhc3RFdmVudFR5cGUgPSBmdW5jdGlvbiBnZXRMYXN0RXZlbnRUeXBlKCkge1xuICAgICAgcmV0dXJuIGxhc3RFdmVudFR5cGU7XG4gICAgfTtcblxuICAgIHZhciBnZXRUaW1lU2luY2VMYXN0RXZlbnQgPSBmdW5jdGlvbiBnZXRUaW1lU2luY2VMYXN0RXZlbnQoKSB7XG4gICAgICByZXR1cm4gRGF0ZS5ub3coKSAtIGxhc3RFdmVudFRpbWU7XG4gICAgfTtcblxuICAgIHJldHVybiB7XG4gICAgICBpc0lnbm9yZWRFdmVudFR5cGU6IGZ1bmN0aW9uIGlzSWdub3JlZEV2ZW50VHlwZSgpIHtcbiAgICAgICAgcmV0dXJuIGlnbm9yZWRFdmVudFR5cGVzLmluZGV4T2YoZ2V0TGFzdEV2ZW50VHlwZSgpKSA+IC0xICYmIGdldFRpbWVTaW5jZUxhc3RFdmVudCgpIDwgTEFTVF9FVkVOVF9USU1FT1VUX01TO1xuICAgICAgfVxuICAgIH07XG4gIH0oKTtcblxuICB2YXIgcnVsZXMgPSBbXTtcbiAgdmFyIGFmZmVjdGVkRWxlbWVudHMgPSBbXTtcbiAgdmFyIHJlbW92YWxzU3RhdGlzdGljID0ge307XG4gIHZhciBkb21PYnNlcnZlZDtcbiAgdmFyIGV2ZW50TGlzdGVuZXJTdXBwb3J0ZWQgPSB3aW5kb3cuYWRkRXZlbnRMaXN0ZW5lcjtcbiAgdmFyIGRvbU11dGF0aW9uT2JzZXJ2ZXI7XG5cbiAgZnVuY3Rpb24gb2JzZXJ2ZURvY3VtZW50KGNhbGxiYWNrKSB7XG4gICAgLy8gV2UgYXJlIHRyeWluZyB0byBsaW1pdCB0aGUgbnVtYmVyIG9mIGNhbGxiYWNrIGNhbGxzIGJ5IG5vdCBjYWxsaW5nIGl0IG9uIGFsbCBraW5kIG9mIFwiaG92ZXJcIiBldmVudHMuXG4gICAgLy8gVGhlIHJhdGlvbmFsZSBiZWhpbmQgdGhpcyBpcyB0aGF0IFwiaG92ZXJcIiBldmVudHMgb2Z0ZW4gY2F1c2UgYXR0cmlidXRlcyBtb2RpZmljYXRpb24sXG4gICAgLy8gYnV0IHJlLWFwcGx5aW5nIGV4dENTUyBydWxlcyB3aWxsIGJlIHVzZWxlc3MgYXMgdGhlc2UgYXR0cmlidXRlIGNoYW5nZXMgYXJlIHVzdWFsbHkgdHJhbnNpZW50LlxuICAgIHZhciBpc0lnbm9yZWRNdXRhdGlvbiA9IGZ1bmN0aW9uIGlzSWdub3JlZE11dGF0aW9uKG11dGF0aW9ucykge1xuICAgICAgZm9yICh2YXIgaSA9IDA7IGkgPCBtdXRhdGlvbnMubGVuZ3RoOyBpICs9IDEpIHtcbiAgICAgICAgaWYgKG11dGF0aW9ucy50eXBlICE9PSAnYXR0cmlidXRlcycpIHtcbiAgICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICAgIH1cbiAgICAgIH1cblxuICAgICAgcmV0dXJuIHRydWU7XG4gICAgfTtcblxuICAgIGlmICh1dGlscy5NdXRhdGlvbk9ic2VydmVyKSB7XG4gICAgICBkb21NdXRhdGlvbk9ic2VydmVyID0gbmV3IHV0aWxzLk11dGF0aW9uT2JzZXJ2ZXIoZnVuY3Rpb24gKG11dGF0aW9ucykge1xuICAgICAgICBpZiAoIW11dGF0aW9ucyB8fCBtdXRhdGlvbnMubGVuZ3RoID09PSAwKSB7XG4gICAgICAgICAgcmV0dXJuO1xuICAgICAgICB9XG5cbiAgICAgICAgaWYgKEV2ZW50VHJhY2tlci5pc0lnbm9yZWRFdmVudFR5cGUoKSAmJiBpc0lnbm9yZWRNdXRhdGlvbihtdXRhdGlvbnMpKSB7XG4gICAgICAgICAgcmV0dXJuO1xuICAgICAgICB9XG5cbiAgICAgICAgY2FsbGJhY2soKTtcbiAgICAgIH0pO1xuICAgICAgZG9tTXV0YXRpb25PYnNlcnZlci5vYnNlcnZlKGRvY3VtZW50LCB7XG4gICAgICAgIGNoaWxkTGlzdDogdHJ1ZSxcbiAgICAgICAgc3VidHJlZTogdHJ1ZSxcbiAgICAgICAgYXR0cmlidXRlczogdHJ1ZSxcbiAgICAgICAgYXR0cmlidXRlRmlsdGVyOiBbJ2lkJywgJ2NsYXNzJ11cbiAgICAgIH0pO1xuICAgIH0gZWxzZSBpZiAoZXZlbnRMaXN0ZW5lclN1cHBvcnRlZCkge1xuICAgICAgZG9jdW1lbnQuYWRkRXZlbnRMaXN0ZW5lcignRE9NTm9kZUluc2VydGVkJywgY2FsbGJhY2ssIGZhbHNlKTtcbiAgICAgIGRvY3VtZW50LmFkZEV2ZW50TGlzdGVuZXIoJ0RPTU5vZGVSZW1vdmVkJywgY2FsbGJhY2ssIGZhbHNlKTtcbiAgICAgIGRvY3VtZW50LmFkZEV2ZW50TGlzdGVuZXIoJ0RPTUF0dHJNb2RpZmllZCcsIGNhbGxiYWNrLCBmYWxzZSk7XG4gICAgfVxuICB9XG5cbiAgZnVuY3Rpb24gZGlzY29ubmVjdERvY3VtZW50KGNhbGxiYWNrKSB7XG4gICAgaWYgKGRvbU11dGF0aW9uT2JzZXJ2ZXIpIHtcbiAgICAgIGRvbU11dGF0aW9uT2JzZXJ2ZXIuZGlzY29ubmVjdCgpO1xuICAgIH0gZWxzZSBpZiAoZXZlbnRMaXN0ZW5lclN1cHBvcnRlZCkge1xuICAgICAgZG9jdW1lbnQucmVtb3ZlRXZlbnRMaXN0ZW5lcignRE9NTm9kZUluc2VydGVkJywgY2FsbGJhY2ssIGZhbHNlKTtcbiAgICAgIGRvY3VtZW50LnJlbW92ZUV2ZW50TGlzdGVuZXIoJ0RPTU5vZGVSZW1vdmVkJywgY2FsbGJhY2ssIGZhbHNlKTtcbiAgICAgIGRvY3VtZW50LnJlbW92ZUV2ZW50TGlzdGVuZXIoJ0RPTUF0dHJNb2RpZmllZCcsIGNhbGxiYWNrLCBmYWxzZSk7XG4gICAgfVxuICB9XG5cbiAgdmFyIE1BWF9TVFlMRV9QUk9URUNUSU9OX0NPVU5UID0gNTA7XG4gIHZhciBwcm90ZWN0aW9uT2JzZXJ2ZXJPcHRpb24gPSB7XG4gICAgYXR0cmlidXRlczogdHJ1ZSxcbiAgICBhdHRyaWJ1dGVPbGRWYWx1ZTogdHJ1ZSxcbiAgICBhdHRyaWJ1dGVGaWx0ZXI6IFsnc3R5bGUnXVxuICB9O1xuICAvKipcbiAgICogQ3JlYXRlcyBNdXRhdGlvbk9ic2VydmVyIHByb3RlY3Rpb24gZnVuY3Rpb25cbiAgICpcbiAgICogQHBhcmFtIHN0eWxlc1xuICAgKiBAcmV0dXJuIHtwcm90ZWN0aW9uRnVuY3Rpb259XG4gICAqL1xuXG4gIGZ1bmN0aW9uIGNyZWF0ZVByb3RlY3Rpb25GdW5jdGlvbihzdHlsZXMpIHtcbiAgICBmdW5jdGlvbiBwcm90ZWN0aW9uRnVuY3Rpb24obXV0YXRpb25zLCBvYnNlcnZlcikge1xuICAgICAgaWYgKCFtdXRhdGlvbnMubGVuZ3RoKSB7XG4gICAgICAgIHJldHVybjtcbiAgICAgIH1cblxuICAgICAgdmFyIG11dGF0aW9uID0gbXV0YXRpb25zWzBdO1xuICAgICAgdmFyIHRhcmdldCA9IG11dGF0aW9uLnRhcmdldDtcbiAgICAgIG9ic2VydmVyLmRpc2Nvbm5lY3QoKTtcbiAgICAgIHN0eWxlcy5mb3JFYWNoKGZ1bmN0aW9uIChzdHlsZSkge1xuICAgICAgICBzZXRTdHlsZVRvRWxlbWVudCh0YXJnZXQsIHN0eWxlKTtcbiAgICAgIH0pO1xuXG4gICAgICBpZiAoKytvYnNlcnZlci5zdHlsZVByb3RlY3Rpb25Db3VudCA8IE1BWF9TVFlMRV9QUk9URUNUSU9OX0NPVU5UKSB7XG4gICAgICAgIG9ic2VydmVyLm9ic2VydmUodGFyZ2V0LCBwcm90ZWN0aW9uT2JzZXJ2ZXJPcHRpb24pO1xuICAgICAgfSBlbHNlIHtcbiAgICAgICAgdXRpbHMubG9nRXJyb3IoJ0V4dGVuZGVkQ3NzOiBpbmZpbml0ZSBsb29wIHByb3RlY3Rpb24gZm9yIHN0eWxlJyk7XG4gICAgICB9XG4gICAgfVxuXG4gICAgcmV0dXJuIHByb3RlY3Rpb25GdW5jdGlvbjtcbiAgfVxuICAvKipcbiAgICogU2V0cyB1cCBhIE11dGF0aW9uT2JzZXJ2ZXIgd2hpY2ggcHJvdGVjdHMgc3R5bGUgYXR0cmlidXRlcyBmcm9tIGNoYW5nZXNcbiAgICogQHBhcmFtIG5vZGUgRE9NIG5vZGVcbiAgICogQHBhcmFtIHJ1bGVzIHJ1bGVzXG4gICAqIEByZXR1cm5zIE11dGF0aW9uIG9ic2VydmVyIHVzZWQgdG8gcHJvdGVjdCBhdHRyaWJ1dGUgb3IgbnVsbCBpZiB0aGVyZSdzIG5vdGhpbmcgdG8gcHJvdGVjdFxuICAgKi9cblxuXG4gIGZ1bmN0aW9uIHByb3RlY3RTdHlsZUF0dHJpYnV0ZShub2RlLCBydWxlcykge1xuICAgIGlmICghdXRpbHMuTXV0YXRpb25PYnNlcnZlcikge1xuICAgICAgcmV0dXJuIG51bGw7XG4gICAgfVxuXG4gICAgdmFyIHN0eWxlcyA9IHJ1bGVzLm1hcChmdW5jdGlvbiAocikge1xuICAgICAgcmV0dXJuIHIuc3R5bGU7XG4gICAgfSk7XG4gICAgdmFyIHByb3RlY3Rpb25PYnNlcnZlciA9IG5ldyB1dGlscy5NdXRhdGlvbk9ic2VydmVyKGNyZWF0ZVByb3RlY3Rpb25GdW5jdGlvbihzdHlsZXMpKTtcbiAgICBwcm90ZWN0aW9uT2JzZXJ2ZXIub2JzZXJ2ZShub2RlLCBwcm90ZWN0aW9uT2JzZXJ2ZXJPcHRpb24pOyAvLyBBZGRzIGFuIGV4cGFuZG8gdG8gdGhlIG9ic2VydmVyIHRvIGtlZXAgJ3N0eWxlIGZpeCBjb3VudHMnLlxuXG4gICAgcHJvdGVjdGlvbk9ic2VydmVyLnN0eWxlUHJvdGVjdGlvbkNvdW50ID0gMDtcbiAgICByZXR1cm4gcHJvdGVjdGlvbk9ic2VydmVyO1xuICB9XG5cbiAgZnVuY3Rpb24gcmVtb3ZlU3VmZml4KHN0ciwgc3VmZml4KSB7XG4gICAgdmFyIGluZGV4ID0gc3RyLmluZGV4T2Yoc3VmZml4LCBzdHIubGVuZ3RoIC0gc3VmZml4Lmxlbmd0aCk7XG5cbiAgICBpZiAoaW5kZXggPj0gMCkge1xuICAgICAgcmV0dXJuIHN0ci5zdWJzdHJpbmcoMCwgaW5kZXgpO1xuICAgIH1cblxuICAgIHJldHVybiBzdHI7XG4gIH1cbiAgLyoqXG4gICAqIEZpbmRzIGFmZmVjdGVkRWxlbWVudCBvYmplY3QgZm9yIHRoZSBzcGVjaWZpZWQgRE9NIG5vZGVcbiAgICogQHBhcmFtIG5vZGUgIERPTSBub2RlXG4gICAqIEByZXR1cm5zICAgICBhZmZlY3RlZEVsZW1lbnQgZm91bmQgb3IgbnVsbFxuICAgKi9cblxuXG4gIGZ1bmN0aW9uIGZpbmRBZmZlY3RlZEVsZW1lbnQobm9kZSkge1xuICAgIGZvciAodmFyIGkgPSAwOyBpIDwgYWZmZWN0ZWRFbGVtZW50cy5sZW5ndGg7IGkgKz0gMSkge1xuICAgICAgaWYgKGFmZmVjdGVkRWxlbWVudHNbaV0ubm9kZSA9PT0gbm9kZSkge1xuICAgICAgICByZXR1cm4gYWZmZWN0ZWRFbGVtZW50c1tpXTtcbiAgICAgIH1cbiAgICB9XG5cbiAgICByZXR1cm4gbnVsbDtcbiAgfVxuXG4gIGZ1bmN0aW9uIHJlbW92ZUVsZW1lbnQoYWZmZWN0ZWRFbGVtZW50KSB7XG4gICAgdmFyIG5vZGUgPSBhZmZlY3RlZEVsZW1lbnQubm9kZTtcbiAgICBhZmZlY3RlZEVsZW1lbnQucmVtb3ZlZCA9IHRydWU7XG4gICAgdmFyIGVsZW1lbnRTZWxlY3RvciA9IHV0aWxzLmdldE5vZGVTZWxlY3Rvcihub2RlKTsgLy8gY2hlY2sgaWYgdGhlIGVsZW1lbnQgaGFzIGJlZW4gYWxyZWFkeSByZW1vdmVkIGVhcmxpZXJcblxuICAgIHZhciBlbGVtZW50UmVtb3ZhbHNDb3VudGVyID0gcmVtb3ZhbHNTdGF0aXN0aWNbZWxlbWVudFNlbGVjdG9yXSB8fCAwOyAvLyBpZiByZW1vdmFscyBhdHRlbXB0cyBoYXBwZW5lZCBtb3JlIHRoYW4gc3BlY2lmaWVkIHdlIGRvIG5vdCB0cnkgdG8gcmVtb3ZlIG5vZGUgYWdhaW5cblxuICAgIGlmIChlbGVtZW50UmVtb3ZhbHNDb3VudGVyID4gTUFYX1NUWUxFX1BST1RFQ1RJT05fQ09VTlQpIHtcbiAgICAgIHV0aWxzLmxvZ0Vycm9yKCdFeHRlbmRlZENzczogaW5maW5pdGUgbG9vcCBwcm90ZWN0aW9uIGZvciBTRUxFQ1RPUicsIGVsZW1lbnRTZWxlY3Rvcik7XG4gICAgICByZXR1cm47XG4gICAgfVxuXG4gICAgaWYgKG5vZGUucGFyZW50Tm9kZSkge1xuICAgICAgbm9kZS5wYXJlbnROb2RlLnJlbW92ZUNoaWxkKG5vZGUpO1xuICAgICAgcmVtb3ZhbHNTdGF0aXN0aWNbZWxlbWVudFNlbGVjdG9yXSA9IGVsZW1lbnRSZW1vdmFsc0NvdW50ZXIgKyAxO1xuICAgIH1cbiAgfVxuICAvKipcbiAgICogQXBwbGllcyBzdHlsZSB0byB0aGUgc3BlY2lmaWVkIERPTSBub2RlXG4gICAqIEBwYXJhbSBhZmZlY3RlZEVsZW1lbnQgT2JqZWN0IGNvbnRhaW5pbmcgRE9NIG5vZGUgYW5kIHJ1bGUgdG8gYmUgYXBwbGllZFxuICAgKi9cblxuXG4gIGZ1bmN0aW9uIGFwcGx5U3R5bGUoYWZmZWN0ZWRFbGVtZW50KSB7XG4gICAgaWYgKGFmZmVjdGVkRWxlbWVudC5wcm90ZWN0aW9uT2JzZXJ2ZXIpIHtcbiAgICAgIC8vIFN0eWxlIGlzIGFscmVhZHkgYXBwbGllZCBhbmQgcHJvdGVjdGVkIGJ5IHRoZSBvYnNlcnZlclxuICAgICAgcmV0dXJuO1xuICAgIH1cblxuICAgIGlmIChiZWZvcmVTdHlsZUFwcGxpZWQpIHtcbiAgICAgIGFmZmVjdGVkRWxlbWVudCA9IGJlZm9yZVN0eWxlQXBwbGllZChhZmZlY3RlZEVsZW1lbnQpO1xuXG4gICAgICBpZiAoIWFmZmVjdGVkRWxlbWVudCkge1xuICAgICAgICByZXR1cm47XG4gICAgICB9XG4gICAgfVxuXG4gICAgdmFyIF9hZmZlY3RlZEVsZW1lbnQgPSBhZmZlY3RlZEVsZW1lbnQsXG4gICAgICAgIG5vZGUgPSBfYWZmZWN0ZWRFbGVtZW50Lm5vZGU7XG5cbiAgICBmb3IgKHZhciBpID0gMDsgaSA8IGFmZmVjdGVkRWxlbWVudC5ydWxlcy5sZW5ndGg7IGkrKykge1xuICAgICAgdmFyIHN0eWxlID0gYWZmZWN0ZWRFbGVtZW50LnJ1bGVzW2ldLnN0eWxlO1xuXG4gICAgICBpZiAoc3R5bGVbJ3JlbW92ZSddID09PSAndHJ1ZScpIHtcbiAgICAgICAgcmVtb3ZlRWxlbWVudChhZmZlY3RlZEVsZW1lbnQpO1xuICAgICAgICByZXR1cm47XG4gICAgICB9XG5cbiAgICAgIHNldFN0eWxlVG9FbGVtZW50KG5vZGUsIHN0eWxlKTtcbiAgICB9XG4gIH1cbiAgLyoqXG4gICAqIFNldHMgc3R5bGUgdG8gdGhlIHNwZWNpZmllZCBET00gbm9kZVxuICAgKiBAcGFyYW0gbm9kZSBlbGVtZW50XG4gICAqIEBwYXJhbSBzdHlsZSBzdHlsZVxuICAgKi9cblxuXG4gIGZ1bmN0aW9uIHNldFN0eWxlVG9FbGVtZW50KG5vZGUsIHN0eWxlKSB7XG4gICAgT2JqZWN0LmtleXMoc3R5bGUpLmZvckVhY2goZnVuY3Rpb24gKHByb3ApIHtcbiAgICAgIC8vIEFwcGx5IHRoaXMgc3R5bGUgb25seSB0byBleGlzdGluZyBwcm9wZXJ0aWVzXG4gICAgICAvLyBXZSBjYW4ndCB1c2UgaGFzT3duUHJvcGVydHkgaGVyZSAoZG9lcyBub3Qgd29yayBpbiBGRilcbiAgICAgIGlmICh0eXBlb2Ygbm9kZS5zdHlsZS5nZXRQcm9wZXJ0eVZhbHVlKHByb3ApICE9PSAndW5kZWZpbmVkJykge1xuICAgICAgICB2YXIgdmFsdWUgPSBzdHlsZVtwcm9wXTsgLy8gRmlyc3Qgd2Ugc2hvdWxkIHJlbW92ZSAhaW1wb3J0YW50IGF0dHJpYnV0ZSAob3IgaXQgd29uJ3QgYmUgYXBwbGllZCcpXG5cbiAgICAgICAgdmFsdWUgPSByZW1vdmVTdWZmaXgodmFsdWUudHJpbSgpLCAnIWltcG9ydGFudCcpLnRyaW0oKTtcbiAgICAgICAgbm9kZS5zdHlsZS5zZXRQcm9wZXJ0eShwcm9wLCB2YWx1ZSwgJ2ltcG9ydGFudCcpO1xuICAgICAgfVxuICAgIH0pO1xuICB9XG4gIC8qKlxuICAgKiBSZXZlcnRzIHN0eWxlIGZvciB0aGUgYWZmZWN0ZWQgb2JqZWN0XG4gICAqL1xuXG5cbiAgZnVuY3Rpb24gcmV2ZXJ0U3R5bGUoYWZmZWN0ZWRFbGVtZW50KSB7XG4gICAgaWYgKGFmZmVjdGVkRWxlbWVudC5wcm90ZWN0aW9uT2JzZXJ2ZXIpIHtcbiAgICAgIGFmZmVjdGVkRWxlbWVudC5wcm90ZWN0aW9uT2JzZXJ2ZXIuZGlzY29ubmVjdCgpO1xuICAgIH1cblxuICAgIGFmZmVjdGVkRWxlbWVudC5ub2RlLnN0eWxlLmNzc1RleHQgPSBhZmZlY3RlZEVsZW1lbnQub3JpZ2luYWxTdHlsZTtcbiAgfVxuICAvKipcbiAgICogQXBwbGllcyBzcGVjaWZpZWQgcnVsZSBhbmQgcmV0dXJucyBsaXN0IG9mIGVsZW1lbnRzIGFmZmVjdGVkXG4gICAqIEBwYXJhbSBydWxlIFJ1bGUgdG8gYXBwbHlcbiAgICogQHJldHVybnMgTGlzdCBvZiBlbGVtZW50cyBhZmZlY3RlZCBieSB0aGlzIHJ1bGVcbiAgICovXG5cblxuICBmdW5jdGlvbiBhcHBseVJ1bGUocnVsZSkge1xuICAgIHZhciBkZWJ1ZyA9IHJ1bGUuc2VsZWN0b3IuaXNEZWJ1Z2dpbmcoKTtcbiAgICB2YXIgc3RhcnQ7XG5cbiAgICBpZiAoZGVidWcpIHtcbiAgICAgIHN0YXJ0ID0gdXRpbHMuQXN5bmNXcmFwcGVyLm5vdygpO1xuICAgIH1cblxuICAgIHZhciBzZWxlY3RvciA9IHJ1bGUuc2VsZWN0b3I7XG4gICAgdmFyIG5vZGVzID0gc2VsZWN0b3IucXVlcnlTZWxlY3RvckFsbCgpO1xuICAgIG5vZGVzLmZvckVhY2goZnVuY3Rpb24gKG5vZGUpIHtcbiAgICAgIHZhciBhZmZlY3RlZEVsZW1lbnQgPSBmaW5kQWZmZWN0ZWRFbGVtZW50KG5vZGUpO1xuXG4gICAgICBpZiAoYWZmZWN0ZWRFbGVtZW50KSB7XG4gICAgICAgIGFmZmVjdGVkRWxlbWVudC5ydWxlcy5wdXNoKHJ1bGUpO1xuICAgICAgICBhcHBseVN0eWxlKGFmZmVjdGVkRWxlbWVudCk7XG4gICAgICB9IGVsc2Uge1xuICAgICAgICAvLyBBcHBseWluZyBzdHlsZSBmaXJzdCB0aW1lXG4gICAgICAgIHZhciBvcmlnaW5hbFN0eWxlID0gbm9kZS5zdHlsZS5jc3NUZXh0O1xuICAgICAgICBhZmZlY3RlZEVsZW1lbnQgPSB7XG4gICAgICAgICAgbm9kZTogbm9kZSxcbiAgICAgICAgICAvLyBhZmZlY3RlZCBET00gbm9kZVxuICAgICAgICAgIHJ1bGVzOiBbcnVsZV0sXG4gICAgICAgICAgLy8gcnVsZXMgdG8gYmUgYXBwbGllZFxuICAgICAgICAgIG9yaWdpbmFsU3R5bGU6IG9yaWdpbmFsU3R5bGUsXG4gICAgICAgICAgLy8gb3JpZ2luYWwgbm9kZSBzdHlsZVxuICAgICAgICAgIHByb3RlY3Rpb25PYnNlcnZlcjogbnVsbCAvLyBzdHlsZSBhdHRyaWJ1dGUgb2JzZXJ2ZXJcblxuICAgICAgICB9O1xuICAgICAgICBhcHBseVN0eWxlKGFmZmVjdGVkRWxlbWVudCk7XG4gICAgICAgIGFmZmVjdGVkRWxlbWVudHMucHVzaChhZmZlY3RlZEVsZW1lbnQpO1xuICAgICAgfVxuICAgIH0pO1xuXG4gICAgaWYgKGRlYnVnKSB7XG4gICAgICB2YXIgZWxhcHNlZCA9IHV0aWxzLkFzeW5jV3JhcHBlci5ub3coKSAtIHN0YXJ0O1xuXG4gICAgICBpZiAoISgndGltaW5nU3RhdHMnIGluIHJ1bGUpKSB7XG4gICAgICAgIHJ1bGUudGltaW5nU3RhdHMgPSBuZXcgdXRpbHMuU3RhdHMoKTtcbiAgICAgIH1cblxuICAgICAgcnVsZS50aW1pbmdTdGF0cy5wdXNoKGVsYXBzZWQpO1xuICAgIH1cblxuICAgIHJldHVybiBub2RlcztcbiAgfVxuICAvKipcbiAgICogQXBwbGllcyBmaWx0ZXJpbmcgcnVsZXNcbiAgICovXG5cblxuICBmdW5jdGlvbiBhcHBseVJ1bGVzKCkge1xuICAgIHZhciBlbGVtZW50c0luZGV4ID0gW107IC8vIHNvbWUgcnVsZXMgY291bGQgbWFrZSBjYWxsIC0gc2VsZWN0b3IucXVlcnlTZWxlY3RvckFsbCgpIHRlbXBvcmFyaWx5IHRvIGNoYW5nZSBub2RlIGlkIGF0dHJpYnV0ZVxuICAgIC8vIHRoaXMgY2F1c2VkIE11dGF0aW9uT2JzZXJ2ZXIgdG8gY2FsbCByZWN1cnNpdmVseVxuICAgIC8vIGh0dHBzOi8vZ2l0aHViLmNvbS9BZGd1YXJkVGVhbS9FeHRlbmRlZENzcy9pc3N1ZXMvODFcblxuICAgIHN0b3BPYnNlcnZlKCk7XG4gICAgcnVsZXMuZm9yRWFjaChmdW5jdGlvbiAocnVsZSkge1xuICAgICAgdmFyIG5vZGVzID0gYXBwbHlSdWxlKHJ1bGUpO1xuICAgICAgQXJyYXkucHJvdG90eXBlLnB1c2guYXBwbHkoZWxlbWVudHNJbmRleCwgbm9kZXMpO1xuICAgIH0pOyAvLyBOb3cgcmV2ZXJ0IHN0eWxlcyBmb3IgZWxlbWVudHMgd2hpY2ggYXJlIG5vIG1vcmUgYWZmZWN0ZWRcblxuICAgIHZhciBsID0gYWZmZWN0ZWRFbGVtZW50cy5sZW5ndGg7IC8vIGRvIG5vdGhpbmcgaWYgdGhlcmUgaXMgbm8gZWxlbWVudHMgdG8gcHJvY2Vzc1xuXG4gICAgaWYgKGVsZW1lbnRzSW5kZXgubGVuZ3RoID4gMCkge1xuICAgICAgd2hpbGUgKGwtLSkge1xuICAgICAgICB2YXIgb2JqID0gYWZmZWN0ZWRFbGVtZW50c1tsXTtcblxuICAgICAgICBpZiAoZWxlbWVudHNJbmRleC5pbmRleE9mKG9iai5ub2RlKSA9PT0gLTEpIHtcbiAgICAgICAgICAvLyBUaW1lIHRvIHJldmVydCBzdHlsZVxuICAgICAgICAgIHJldmVydFN0eWxlKG9iaik7XG4gICAgICAgICAgYWZmZWN0ZWRFbGVtZW50cy5zcGxpY2UobCwgMSk7XG4gICAgICAgIH0gZWxzZSBpZiAoIW9iai5yZW1vdmVkKSB7XG4gICAgICAgICAgLy8gQWRkIHN0eWxlIHByb3RlY3Rpb24gb2JzZXJ2ZXJcbiAgICAgICAgICAvLyBQcm90ZWN0IFwic3R5bGVcIiBhdHRyaWJ1dGUgZnJvbSBjaGFuZ2VzXG4gICAgICAgICAgaWYgKCFvYmoucHJvdGVjdGlvbk9ic2VydmVyKSB7XG4gICAgICAgICAgICBvYmoucHJvdGVjdGlvbk9ic2VydmVyID0gcHJvdGVjdFN0eWxlQXR0cmlidXRlKG9iai5ub2RlLCBvYmoucnVsZXMpO1xuICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgfVxuICAgIH0gLy8gQWZ0ZXIgc3R5bGVzIGFyZSBhcHBsaWVkIHdlIGNhbiBzdGFydCBvYnNlcnZlIGFnYWluXG5cblxuICAgIG9ic2VydmUoKTtcbiAgICBwcmludFRpbWluZ0luZm8oKTtcbiAgfVxuXG4gIHZhciBBUFBMWV9SVUxFU19ERUxBWSA9IDE1MDtcbiAgdmFyIGFwcGx5UnVsZXNTY2hlZHVsZXIgPSBuZXcgdXRpbHMuQXN5bmNXcmFwcGVyKGFwcGx5UnVsZXMsIEFQUExZX1JVTEVTX0RFTEFZKTtcbiAgdmFyIG1haW5DYWxsYmFjayA9IGFwcGx5UnVsZXNTY2hlZHVsZXIucnVuLmJpbmQoYXBwbHlSdWxlc1NjaGVkdWxlcik7XG5cbiAgZnVuY3Rpb24gb2JzZXJ2ZSgpIHtcbiAgICBpZiAoZG9tT2JzZXJ2ZWQpIHtcbiAgICAgIHJldHVybjtcbiAgICB9IC8vIEhhbmRsZSBkeW5hbWljYWxseSBhZGRlZCBlbGVtZW50c1xuXG5cbiAgICBkb21PYnNlcnZlZCA9IHRydWU7XG4gICAgb2JzZXJ2ZURvY3VtZW50KG1haW5DYWxsYmFjayk7XG4gIH1cblxuICBmdW5jdGlvbiBzdG9wT2JzZXJ2ZSgpIHtcbiAgICBpZiAoIWRvbU9ic2VydmVkKSB7XG4gICAgICByZXR1cm47XG4gICAgfVxuXG4gICAgZG9tT2JzZXJ2ZWQgPSBmYWxzZTtcbiAgICBkaXNjb25uZWN0RG9jdW1lbnQobWFpbkNhbGxiYWNrKTtcbiAgfVxuXG4gIGZ1bmN0aW9uIGFwcGx5KCkge1xuICAgIGFwcGx5UnVsZXMoKTtcblxuICAgIGlmIChkb2N1bWVudC5yZWFkeVN0YXRlICE9PSAnY29tcGxldGUnKSB7XG4gICAgICBkb2N1bWVudC5hZGRFdmVudExpc3RlbmVyKCdET01Db250ZW50TG9hZGVkJywgYXBwbHlSdWxlcyk7XG4gICAgfVxuICB9XG4gIC8qKlxuICAgKiBEaXNwb3NlcyBFeHRlbmRlZENzcyBhbmQgcmVtb3ZlcyBvdXIgc3R5bGVzIGZyb20gbWF0Y2hlZCBlbGVtZW50c1xuICAgKi9cblxuXG4gIGZ1bmN0aW9uIGRpc3Bvc2UoKSB7XG4gICAgc3RvcE9ic2VydmUoKTtcbiAgICBhZmZlY3RlZEVsZW1lbnRzLmZvckVhY2goZnVuY3Rpb24gKG9iaikge1xuICAgICAgcmV2ZXJ0U3R5bGUob2JqKTtcbiAgICB9KTtcbiAgfVxuXG4gIHZhciB0aW1pbmdzUHJpbnRlZCA9IGZhbHNlO1xuICAvKipcbiAgICogUHJpbnRzIHRpbWluZyBpbmZvcm1hdGlvbiBmb3IgYWxsIHNlbGVjdG9ycyBtYXJrZWQgYXMgXCJkZWJ1Z1wiXG4gICAqL1xuXG4gIGZ1bmN0aW9uIHByaW50VGltaW5nSW5mbygpIHtcbiAgICBpZiAodGltaW5nc1ByaW50ZWQpIHtcbiAgICAgIHJldHVybjtcbiAgICB9XG5cbiAgICB0aW1pbmdzUHJpbnRlZCA9IHRydWU7XG4gICAgdmFyIHRpbWluZ3MgPSBydWxlcy5maWx0ZXIoZnVuY3Rpb24gKHJ1bGUpIHtcbiAgICAgIHJldHVybiBydWxlLnNlbGVjdG9yLmlzRGVidWdnaW5nKCk7XG4gICAgfSkubWFwKGZ1bmN0aW9uIChydWxlKSB7XG4gICAgICByZXR1cm4ge1xuICAgICAgICBzZWxlY3RvclRleHQ6IHJ1bGUuc2VsZWN0b3Iuc2VsZWN0b3JUZXh0LFxuICAgICAgICB0aW1pbmdTdGF0czogcnVsZS50aW1pbmdTdGF0c1xuICAgICAgfTtcbiAgICB9KTtcblxuICAgIGlmICh0aW1pbmdzLmxlbmd0aCA9PT0gMCkge1xuICAgICAgcmV0dXJuO1xuICAgIH0gLy8gQWRkIGxvY2F0aW9uLmhyZWYgdG8gdGhlIG1lc3NhZ2UgdG8gZGlzdGluZ3Vpc2ggZnJhbWVzXG5cblxuICAgIHV0aWxzLmxvZ0luZm8oJ1tFeHRlbmRlZENzc10gVGltaW5ncyBmb3IgJW86XFxuJW8gKGluIG1pbGxpc2Vjb25kcyknLCB3aW5kb3cubG9jYXRpb24uaHJlZiwgdGltaW5ncyk7XG4gIH0gLy8gRmlyc3Qgb2YgYWxsIHBhcnNlIHRoZSBzdHlsZXNoZWV0XG5cblxuICBydWxlcyA9IEV4dGVuZGVkQ3NzUGFyc2VyLnBhcnNlQ3NzKHN0eWxlU2hlZXQpOyAvLyBFWFBPU0VcblxuICB0aGlzLmRpc3Bvc2UgPSBkaXNwb3NlO1xuICB0aGlzLmFwcGx5ID0gYXBwbHk7XG4gIC8qKiBFeHBvc2VkIGZvciB0ZXN0aW5nIHB1cnBvc2VzIG9ubHkgKi9cblxuICB0aGlzLl9nZXRBZmZlY3RlZEVsZW1lbnRzID0gZnVuY3Rpb24gKCkge1xuICAgIHJldHVybiBhZmZlY3RlZEVsZW1lbnRzO1xuICB9O1xufVxuLyoqXG4gKiBFeHBvc2UgcXVlcnlTZWxlY3RvckFsbCBmb3IgZGVidWdnaW5nIGFuZCB2YWxpZGF0aW5nIHNlbGVjdG9yc1xuICpcbiAqIEBwYXJhbSB7c3RyaW5nfSBzZWxlY3RvclRleHQgc2VsZWN0b3IgdGV4dFxuICogQHBhcmFtIHtib29sZWFufSBub1RpbWluZyBpZiB0cnVlIC0tIGRvIG5vdCBwcmludCB0aGUgdGltaW5nIHRvIHRoZSBjb25zb2xlXG4gKiBAcmV0dXJucyB7QXJyYXk8Tm9kZT58Tm9kZUxpc3R9IGEgbGlzdCBvZiBlbGVtZW50cyBmb3VuZFxuICogQHRocm93cyBXaWxsIHRocm93IGFuIGVycm9yIGlmIHRoZSBhcmd1bWVudCBpcyBub3QgYSB2YWxpZCBzZWxlY3RvclxuICovXG5cblxuRXh0ZW5kZWRDc3MucXVlcnkgPSBmdW5jdGlvbiAoc2VsZWN0b3JUZXh0LCBub1RpbWluZykge1xuICBpZiAodHlwZW9mIHNlbGVjdG9yVGV4dCAhPT0gJ3N0cmluZycpIHtcbiAgICB0aHJvdyBuZXcgRXJyb3IoJ1NlbGVjdG9yIHRleHQgaXMgZW1wdHknKTtcbiAgfVxuXG4gIHZhciBub3cgPSB1dGlscy5Bc3luY1dyYXBwZXIubm93O1xuICB2YXIgc3RhcnQgPSBub3coKTtcblxuICB0cnkge1xuICAgIHJldHVybiBFeHRlbmRlZFNlbGVjdG9yRmFjdG9yeS5jcmVhdGVTZWxlY3RvcihzZWxlY3RvclRleHQpLnF1ZXJ5U2VsZWN0b3JBbGwoKTtcbiAgfSBmaW5hbGx5IHtcbiAgICB2YXIgZW5kID0gbm93KCk7XG5cbiAgICBpZiAoIW5vVGltaW5nKSB7XG4gICAgICB1dGlscy5sb2dJbmZvKFwiW0V4dGVuZGVkQ3NzXSBFbGFwc2VkOiBcIi5jb25jYXQoTWF0aC5yb3VuZCgoZW5kIC0gc3RhcnQpICogMTAwMCksIFwiIFxcdTAzQkNzLlwiKSk7XG4gICAgfVxuICB9XG59O1xuXG5leHBvcnQgZGVmYXVsdCBFeHRlbmRlZENzcztcbiIsIi8qKlxuICogQ29weXJpZ2h0IChjKSAyMDE0LXByZXNlbnQsIEZhY2Vib29rLCBJbmMuXG4gKlxuICogVGhpcyBzb3VyY2UgY29kZSBpcyBsaWNlbnNlZCB1bmRlciB0aGUgTUlUIGxpY2Vuc2UgZm91bmQgaW4gdGhlXG4gKiBMSUNFTlNFIGZpbGUgaW4gdGhlIHJvb3QgZGlyZWN0b3J5IG9mIHRoaXMgc291cmNlIHRyZWUuXG4gKi9cblxudmFyIHJ1bnRpbWUgPSAoZnVuY3Rpb24gKGV4cG9ydHMpIHtcbiAgXCJ1c2Ugc3RyaWN0XCI7XG5cbiAgdmFyIE9wID0gT2JqZWN0LnByb3RvdHlwZTtcbiAgdmFyIGhhc093biA9IE9wLmhhc093blByb3BlcnR5O1xuICB2YXIgdW5kZWZpbmVkOyAvLyBNb3JlIGNvbXByZXNzaWJsZSB0aGFuIHZvaWQgMC5cbiAgdmFyICRTeW1ib2wgPSB0eXBlb2YgU3ltYm9sID09PSBcImZ1bmN0aW9uXCIgPyBTeW1ib2wgOiB7fTtcbiAgdmFyIGl0ZXJhdG9yU3ltYm9sID0gJFN5bWJvbC5pdGVyYXRvciB8fCBcIkBAaXRlcmF0b3JcIjtcbiAgdmFyIGFzeW5jSXRlcmF0b3JTeW1ib2wgPSAkU3ltYm9sLmFzeW5jSXRlcmF0b3IgfHwgXCJAQGFzeW5jSXRlcmF0b3JcIjtcbiAgdmFyIHRvU3RyaW5nVGFnU3ltYm9sID0gJFN5bWJvbC50b1N0cmluZ1RhZyB8fCBcIkBAdG9TdHJpbmdUYWdcIjtcblxuICBmdW5jdGlvbiBkZWZpbmUob2JqLCBrZXksIHZhbHVlKSB7XG4gICAgT2JqZWN0LmRlZmluZVByb3BlcnR5KG9iaiwga2V5LCB7XG4gICAgICB2YWx1ZTogdmFsdWUsXG4gICAgICBlbnVtZXJhYmxlOiB0cnVlLFxuICAgICAgY29uZmlndXJhYmxlOiB0cnVlLFxuICAgICAgd3JpdGFibGU6IHRydWVcbiAgICB9KTtcbiAgICByZXR1cm4gb2JqW2tleV07XG4gIH1cbiAgdHJ5IHtcbiAgICAvLyBJRSA4IGhhcyBhIGJyb2tlbiBPYmplY3QuZGVmaW5lUHJvcGVydHkgdGhhdCBvbmx5IHdvcmtzIG9uIERPTSBvYmplY3RzLlxuICAgIGRlZmluZSh7fSwgXCJcIik7XG4gIH0gY2F0Y2ggKGVycikge1xuICAgIGRlZmluZSA9IGZ1bmN0aW9uKG9iaiwga2V5LCB2YWx1ZSkge1xuICAgICAgcmV0dXJuIG9ialtrZXldID0gdmFsdWU7XG4gICAgfTtcbiAgfVxuXG4gIGZ1bmN0aW9uIHdyYXAoaW5uZXJGbiwgb3V0ZXJGbiwgc2VsZiwgdHJ5TG9jc0xpc3QpIHtcbiAgICAvLyBJZiBvdXRlckZuIHByb3ZpZGVkIGFuZCBvdXRlckZuLnByb3RvdHlwZSBpcyBhIEdlbmVyYXRvciwgdGhlbiBvdXRlckZuLnByb3RvdHlwZSBpbnN0YW5jZW9mIEdlbmVyYXRvci5cbiAgICB2YXIgcHJvdG9HZW5lcmF0b3IgPSBvdXRlckZuICYmIG91dGVyRm4ucHJvdG90eXBlIGluc3RhbmNlb2YgR2VuZXJhdG9yID8gb3V0ZXJGbiA6IEdlbmVyYXRvcjtcbiAgICB2YXIgZ2VuZXJhdG9yID0gT2JqZWN0LmNyZWF0ZShwcm90b0dlbmVyYXRvci5wcm90b3R5cGUpO1xuICAgIHZhciBjb250ZXh0ID0gbmV3IENvbnRleHQodHJ5TG9jc0xpc3QgfHwgW10pO1xuXG4gICAgLy8gVGhlIC5faW52b2tlIG1ldGhvZCB1bmlmaWVzIHRoZSBpbXBsZW1lbnRhdGlvbnMgb2YgdGhlIC5uZXh0LFxuICAgIC8vIC50aHJvdywgYW5kIC5yZXR1cm4gbWV0aG9kcy5cbiAgICBnZW5lcmF0b3IuX2ludm9rZSA9IG1ha2VJbnZva2VNZXRob2QoaW5uZXJGbiwgc2VsZiwgY29udGV4dCk7XG5cbiAgICByZXR1cm4gZ2VuZXJhdG9yO1xuICB9XG4gIGV4cG9ydHMud3JhcCA9IHdyYXA7XG5cbiAgLy8gVHJ5L2NhdGNoIGhlbHBlciB0byBtaW5pbWl6ZSBkZW9wdGltaXphdGlvbnMuIFJldHVybnMgYSBjb21wbGV0aW9uXG4gIC8vIHJlY29yZCBsaWtlIGNvbnRleHQudHJ5RW50cmllc1tpXS5jb21wbGV0aW9uLiBUaGlzIGludGVyZmFjZSBjb3VsZFxuICAvLyBoYXZlIGJlZW4gKGFuZCB3YXMgcHJldmlvdXNseSkgZGVzaWduZWQgdG8gdGFrZSBhIGNsb3N1cmUgdG8gYmVcbiAgLy8gaW52b2tlZCB3aXRob3V0IGFyZ3VtZW50cywgYnV0IGluIGFsbCB0aGUgY2FzZXMgd2UgY2FyZSBhYm91dCB3ZVxuICAvLyBhbHJlYWR5IGhhdmUgYW4gZXhpc3RpbmcgbWV0aG9kIHdlIHdhbnQgdG8gY2FsbCwgc28gdGhlcmUncyBubyBuZWVkXG4gIC8vIHRvIGNyZWF0ZSBhIG5ldyBmdW5jdGlvbiBvYmplY3QuIFdlIGNhbiBldmVuIGdldCBhd2F5IHdpdGggYXNzdW1pbmdcbiAgLy8gdGhlIG1ldGhvZCB0YWtlcyBleGFjdGx5IG9uZSBhcmd1bWVudCwgc2luY2UgdGhhdCBoYXBwZW5zIHRvIGJlIHRydWVcbiAgLy8gaW4gZXZlcnkgY2FzZSwgc28gd2UgZG9uJ3QgaGF2ZSB0byB0b3VjaCB0aGUgYXJndW1lbnRzIG9iamVjdC4gVGhlXG4gIC8vIG9ubHkgYWRkaXRpb25hbCBhbGxvY2F0aW9uIHJlcXVpcmVkIGlzIHRoZSBjb21wbGV0aW9uIHJlY29yZCwgd2hpY2hcbiAgLy8gaGFzIGEgc3RhYmxlIHNoYXBlIGFuZCBzbyBob3BlZnVsbHkgc2hvdWxkIGJlIGNoZWFwIHRvIGFsbG9jYXRlLlxuICBmdW5jdGlvbiB0cnlDYXRjaChmbiwgb2JqLCBhcmcpIHtcbiAgICB0cnkge1xuICAgICAgcmV0dXJuIHsgdHlwZTogXCJub3JtYWxcIiwgYXJnOiBmbi5jYWxsKG9iaiwgYXJnKSB9O1xuICAgIH0gY2F0Y2ggKGVycikge1xuICAgICAgcmV0dXJuIHsgdHlwZTogXCJ0aHJvd1wiLCBhcmc6IGVyciB9O1xuICAgIH1cbiAgfVxuXG4gIHZhciBHZW5TdGF0ZVN1c3BlbmRlZFN0YXJ0ID0gXCJzdXNwZW5kZWRTdGFydFwiO1xuICB2YXIgR2VuU3RhdGVTdXNwZW5kZWRZaWVsZCA9IFwic3VzcGVuZGVkWWllbGRcIjtcbiAgdmFyIEdlblN0YXRlRXhlY3V0aW5nID0gXCJleGVjdXRpbmdcIjtcbiAgdmFyIEdlblN0YXRlQ29tcGxldGVkID0gXCJjb21wbGV0ZWRcIjtcblxuICAvLyBSZXR1cm5pbmcgdGhpcyBvYmplY3QgZnJvbSB0aGUgaW5uZXJGbiBoYXMgdGhlIHNhbWUgZWZmZWN0IGFzXG4gIC8vIGJyZWFraW5nIG91dCBvZiB0aGUgZGlzcGF0Y2ggc3dpdGNoIHN0YXRlbWVudC5cbiAgdmFyIENvbnRpbnVlU2VudGluZWwgPSB7fTtcblxuICAvLyBEdW1teSBjb25zdHJ1Y3RvciBmdW5jdGlvbnMgdGhhdCB3ZSB1c2UgYXMgdGhlIC5jb25zdHJ1Y3RvciBhbmRcbiAgLy8gLmNvbnN0cnVjdG9yLnByb3RvdHlwZSBwcm9wZXJ0aWVzIGZvciBmdW5jdGlvbnMgdGhhdCByZXR1cm4gR2VuZXJhdG9yXG4gIC8vIG9iamVjdHMuIEZvciBmdWxsIHNwZWMgY29tcGxpYW5jZSwgeW91IG1heSB3aXNoIHRvIGNvbmZpZ3VyZSB5b3VyXG4gIC8vIG1pbmlmaWVyIG5vdCB0byBtYW5nbGUgdGhlIG5hbWVzIG9mIHRoZXNlIHR3byBmdW5jdGlvbnMuXG4gIGZ1bmN0aW9uIEdlbmVyYXRvcigpIHt9XG4gIGZ1bmN0aW9uIEdlbmVyYXRvckZ1bmN0aW9uKCkge31cbiAgZnVuY3Rpb24gR2VuZXJhdG9yRnVuY3Rpb25Qcm90b3R5cGUoKSB7fVxuXG4gIC8vIFRoaXMgaXMgYSBwb2x5ZmlsbCBmb3IgJUl0ZXJhdG9yUHJvdG90eXBlJSBmb3IgZW52aXJvbm1lbnRzIHRoYXRcbiAgLy8gZG9uJ3QgbmF0aXZlbHkgc3VwcG9ydCBpdC5cbiAgdmFyIEl0ZXJhdG9yUHJvdG90eXBlID0ge307XG4gIEl0ZXJhdG9yUHJvdG90eXBlW2l0ZXJhdG9yU3ltYm9sXSA9IGZ1bmN0aW9uICgpIHtcbiAgICByZXR1cm4gdGhpcztcbiAgfTtcblxuICB2YXIgZ2V0UHJvdG8gPSBPYmplY3QuZ2V0UHJvdG90eXBlT2Y7XG4gIHZhciBOYXRpdmVJdGVyYXRvclByb3RvdHlwZSA9IGdldFByb3RvICYmIGdldFByb3RvKGdldFByb3RvKHZhbHVlcyhbXSkpKTtcbiAgaWYgKE5hdGl2ZUl0ZXJhdG9yUHJvdG90eXBlICYmXG4gICAgICBOYXRpdmVJdGVyYXRvclByb3RvdHlwZSAhPT0gT3AgJiZcbiAgICAgIGhhc093bi5jYWxsKE5hdGl2ZUl0ZXJhdG9yUHJvdG90eXBlLCBpdGVyYXRvclN5bWJvbCkpIHtcbiAgICAvLyBUaGlzIGVudmlyb25tZW50IGhhcyBhIG5hdGl2ZSAlSXRlcmF0b3JQcm90b3R5cGUlOyB1c2UgaXQgaW5zdGVhZFxuICAgIC8vIG9mIHRoZSBwb2x5ZmlsbC5cbiAgICBJdGVyYXRvclByb3RvdHlwZSA9IE5hdGl2ZUl0ZXJhdG9yUHJvdG90eXBlO1xuICB9XG5cbiAgdmFyIEdwID0gR2VuZXJhdG9yRnVuY3Rpb25Qcm90b3R5cGUucHJvdG90eXBlID1cbiAgICBHZW5lcmF0b3IucHJvdG90eXBlID0gT2JqZWN0LmNyZWF0ZShJdGVyYXRvclByb3RvdHlwZSk7XG4gIEdlbmVyYXRvckZ1bmN0aW9uLnByb3RvdHlwZSA9IEdwLmNvbnN0cnVjdG9yID0gR2VuZXJhdG9yRnVuY3Rpb25Qcm90b3R5cGU7XG4gIEdlbmVyYXRvckZ1bmN0aW9uUHJvdG90eXBlLmNvbnN0cnVjdG9yID0gR2VuZXJhdG9yRnVuY3Rpb247XG4gIEdlbmVyYXRvckZ1bmN0aW9uLmRpc3BsYXlOYW1lID0gZGVmaW5lKFxuICAgIEdlbmVyYXRvckZ1bmN0aW9uUHJvdG90eXBlLFxuICAgIHRvU3RyaW5nVGFnU3ltYm9sLFxuICAgIFwiR2VuZXJhdG9yRnVuY3Rpb25cIlxuICApO1xuXG4gIC8vIEhlbHBlciBmb3IgZGVmaW5pbmcgdGhlIC5uZXh0LCAudGhyb3csIGFuZCAucmV0dXJuIG1ldGhvZHMgb2YgdGhlXG4gIC8vIEl0ZXJhdG9yIGludGVyZmFjZSBpbiB0ZXJtcyBvZiBhIHNpbmdsZSAuX2ludm9rZSBtZXRob2QuXG4gIGZ1bmN0aW9uIGRlZmluZUl0ZXJhdG9yTWV0aG9kcyhwcm90b3R5cGUpIHtcbiAgICBbXCJuZXh0XCIsIFwidGhyb3dcIiwgXCJyZXR1cm5cIl0uZm9yRWFjaChmdW5jdGlvbihtZXRob2QpIHtcbiAgICAgIGRlZmluZShwcm90b3R5cGUsIG1ldGhvZCwgZnVuY3Rpb24oYXJnKSB7XG4gICAgICAgIHJldHVybiB0aGlzLl9pbnZva2UobWV0aG9kLCBhcmcpO1xuICAgICAgfSk7XG4gICAgfSk7XG4gIH1cblxuICBleHBvcnRzLmlzR2VuZXJhdG9yRnVuY3Rpb24gPSBmdW5jdGlvbihnZW5GdW4pIHtcbiAgICB2YXIgY3RvciA9IHR5cGVvZiBnZW5GdW4gPT09IFwiZnVuY3Rpb25cIiAmJiBnZW5GdW4uY29uc3RydWN0b3I7XG4gICAgcmV0dXJuIGN0b3JcbiAgICAgID8gY3RvciA9PT0gR2VuZXJhdG9yRnVuY3Rpb24gfHxcbiAgICAgICAgLy8gRm9yIHRoZSBuYXRpdmUgR2VuZXJhdG9yRnVuY3Rpb24gY29uc3RydWN0b3IsIHRoZSBiZXN0IHdlIGNhblxuICAgICAgICAvLyBkbyBpcyB0byBjaGVjayBpdHMgLm5hbWUgcHJvcGVydHkuXG4gICAgICAgIChjdG9yLmRpc3BsYXlOYW1lIHx8IGN0b3IubmFtZSkgPT09IFwiR2VuZXJhdG9yRnVuY3Rpb25cIlxuICAgICAgOiBmYWxzZTtcbiAgfTtcblxuICBleHBvcnRzLm1hcmsgPSBmdW5jdGlvbihnZW5GdW4pIHtcbiAgICBpZiAoT2JqZWN0LnNldFByb3RvdHlwZU9mKSB7XG4gICAgICBPYmplY3Quc2V0UHJvdG90eXBlT2YoZ2VuRnVuLCBHZW5lcmF0b3JGdW5jdGlvblByb3RvdHlwZSk7XG4gICAgfSBlbHNlIHtcbiAgICAgIGdlbkZ1bi5fX3Byb3RvX18gPSBHZW5lcmF0b3JGdW5jdGlvblByb3RvdHlwZTtcbiAgICAgIGRlZmluZShnZW5GdW4sIHRvU3RyaW5nVGFnU3ltYm9sLCBcIkdlbmVyYXRvckZ1bmN0aW9uXCIpO1xuICAgIH1cbiAgICBnZW5GdW4ucHJvdG90eXBlID0gT2JqZWN0LmNyZWF0ZShHcCk7XG4gICAgcmV0dXJuIGdlbkZ1bjtcbiAgfTtcblxuICAvLyBXaXRoaW4gdGhlIGJvZHkgb2YgYW55IGFzeW5jIGZ1bmN0aW9uLCBgYXdhaXQgeGAgaXMgdHJhbnNmb3JtZWQgdG9cbiAgLy8gYHlpZWxkIHJlZ2VuZXJhdG9yUnVudGltZS5hd3JhcCh4KWAsIHNvIHRoYXQgdGhlIHJ1bnRpbWUgY2FuIHRlc3RcbiAgLy8gYGhhc093bi5jYWxsKHZhbHVlLCBcIl9fYXdhaXRcIilgIHRvIGRldGVybWluZSBpZiB0aGUgeWllbGRlZCB2YWx1ZSBpc1xuICAvLyBtZWFudCB0byBiZSBhd2FpdGVkLlxuICBleHBvcnRzLmF3cmFwID0gZnVuY3Rpb24oYXJnKSB7XG4gICAgcmV0dXJuIHsgX19hd2FpdDogYXJnIH07XG4gIH07XG5cbiAgZnVuY3Rpb24gQXN5bmNJdGVyYXRvcihnZW5lcmF0b3IsIFByb21pc2VJbXBsKSB7XG4gICAgZnVuY3Rpb24gaW52b2tlKG1ldGhvZCwgYXJnLCByZXNvbHZlLCByZWplY3QpIHtcbiAgICAgIHZhciByZWNvcmQgPSB0cnlDYXRjaChnZW5lcmF0b3JbbWV0aG9kXSwgZ2VuZXJhdG9yLCBhcmcpO1xuICAgICAgaWYgKHJlY29yZC50eXBlID09PSBcInRocm93XCIpIHtcbiAgICAgICAgcmVqZWN0KHJlY29yZC5hcmcpO1xuICAgICAgfSBlbHNlIHtcbiAgICAgICAgdmFyIHJlc3VsdCA9IHJlY29yZC5hcmc7XG4gICAgICAgIHZhciB2YWx1ZSA9IHJlc3VsdC52YWx1ZTtcbiAgICAgICAgaWYgKHZhbHVlICYmXG4gICAgICAgICAgICB0eXBlb2YgdmFsdWUgPT09IFwib2JqZWN0XCIgJiZcbiAgICAgICAgICAgIGhhc093bi5jYWxsKHZhbHVlLCBcIl9fYXdhaXRcIikpIHtcbiAgICAgICAgICByZXR1cm4gUHJvbWlzZUltcGwucmVzb2x2ZSh2YWx1ZS5fX2F3YWl0KS50aGVuKGZ1bmN0aW9uKHZhbHVlKSB7XG4gICAgICAgICAgICBpbnZva2UoXCJuZXh0XCIsIHZhbHVlLCByZXNvbHZlLCByZWplY3QpO1xuICAgICAgICAgIH0sIGZ1bmN0aW9uKGVycikge1xuICAgICAgICAgICAgaW52b2tlKFwidGhyb3dcIiwgZXJyLCByZXNvbHZlLCByZWplY3QpO1xuICAgICAgICAgIH0pO1xuICAgICAgICB9XG5cbiAgICAgICAgcmV0dXJuIFByb21pc2VJbXBsLnJlc29sdmUodmFsdWUpLnRoZW4oZnVuY3Rpb24odW53cmFwcGVkKSB7XG4gICAgICAgICAgLy8gV2hlbiBhIHlpZWxkZWQgUHJvbWlzZSBpcyByZXNvbHZlZCwgaXRzIGZpbmFsIHZhbHVlIGJlY29tZXNcbiAgICAgICAgICAvLyB0aGUgLnZhbHVlIG9mIHRoZSBQcm9taXNlPHt2YWx1ZSxkb25lfT4gcmVzdWx0IGZvciB0aGVcbiAgICAgICAgICAvLyBjdXJyZW50IGl0ZXJhdGlvbi5cbiAgICAgICAgICByZXN1bHQudmFsdWUgPSB1bndyYXBwZWQ7XG4gICAgICAgICAgcmVzb2x2ZShyZXN1bHQpO1xuICAgICAgICB9LCBmdW5jdGlvbihlcnJvcikge1xuICAgICAgICAgIC8vIElmIGEgcmVqZWN0ZWQgUHJvbWlzZSB3YXMgeWllbGRlZCwgdGhyb3cgdGhlIHJlamVjdGlvbiBiYWNrXG4gICAgICAgICAgLy8gaW50byB0aGUgYXN5bmMgZ2VuZXJhdG9yIGZ1bmN0aW9uIHNvIGl0IGNhbiBiZSBoYW5kbGVkIHRoZXJlLlxuICAgICAgICAgIHJldHVybiBpbnZva2UoXCJ0aHJvd1wiLCBlcnJvciwgcmVzb2x2ZSwgcmVqZWN0KTtcbiAgICAgICAgfSk7XG4gICAgICB9XG4gICAgfVxuXG4gICAgdmFyIHByZXZpb3VzUHJvbWlzZTtcblxuICAgIGZ1bmN0aW9uIGVucXVldWUobWV0aG9kLCBhcmcpIHtcbiAgICAgIGZ1bmN0aW9uIGNhbGxJbnZva2VXaXRoTWV0aG9kQW5kQXJnKCkge1xuICAgICAgICByZXR1cm4gbmV3IFByb21pc2VJbXBsKGZ1bmN0aW9uKHJlc29sdmUsIHJlamVjdCkge1xuICAgICAgICAgIGludm9rZShtZXRob2QsIGFyZywgcmVzb2x2ZSwgcmVqZWN0KTtcbiAgICAgICAgfSk7XG4gICAgICB9XG5cbiAgICAgIHJldHVybiBwcmV2aW91c1Byb21pc2UgPVxuICAgICAgICAvLyBJZiBlbnF1ZXVlIGhhcyBiZWVuIGNhbGxlZCBiZWZvcmUsIHRoZW4gd2Ugd2FudCB0byB3YWl0IHVudGlsXG4gICAgICAgIC8vIGFsbCBwcmV2aW91cyBQcm9taXNlcyBoYXZlIGJlZW4gcmVzb2x2ZWQgYmVmb3JlIGNhbGxpbmcgaW52b2tlLFxuICAgICAgICAvLyBzbyB0aGF0IHJlc3VsdHMgYXJlIGFsd2F5cyBkZWxpdmVyZWQgaW4gdGhlIGNvcnJlY3Qgb3JkZXIuIElmXG4gICAgICAgIC8vIGVucXVldWUgaGFzIG5vdCBiZWVuIGNhbGxlZCBiZWZvcmUsIHRoZW4gaXQgaXMgaW1wb3J0YW50IHRvXG4gICAgICAgIC8vIGNhbGwgaW52b2tlIGltbWVkaWF0ZWx5LCB3aXRob3V0IHdhaXRpbmcgb24gYSBjYWxsYmFjayB0byBmaXJlLFxuICAgICAgICAvLyBzbyB0aGF0IHRoZSBhc3luYyBnZW5lcmF0b3IgZnVuY3Rpb24gaGFzIHRoZSBvcHBvcnR1bml0eSB0byBkb1xuICAgICAgICAvLyBhbnkgbmVjZXNzYXJ5IHNldHVwIGluIGEgcHJlZGljdGFibGUgd2F5LiBUaGlzIHByZWRpY3RhYmlsaXR5XG4gICAgICAgIC8vIGlzIHdoeSB0aGUgUHJvbWlzZSBjb25zdHJ1Y3RvciBzeW5jaHJvbm91c2x5IGludm9rZXMgaXRzXG4gICAgICAgIC8vIGV4ZWN1dG9yIGNhbGxiYWNrLCBhbmQgd2h5IGFzeW5jIGZ1bmN0aW9ucyBzeW5jaHJvbm91c2x5XG4gICAgICAgIC8vIGV4ZWN1dGUgY29kZSBiZWZvcmUgdGhlIGZpcnN0IGF3YWl0LiBTaW5jZSB3ZSBpbXBsZW1lbnQgc2ltcGxlXG4gICAgICAgIC8vIGFzeW5jIGZ1bmN0aW9ucyBpbiB0ZXJtcyBvZiBhc3luYyBnZW5lcmF0b3JzLCBpdCBpcyBlc3BlY2lhbGx5XG4gICAgICAgIC8vIGltcG9ydGFudCB0byBnZXQgdGhpcyByaWdodCwgZXZlbiB0aG91Z2ggaXQgcmVxdWlyZXMgY2FyZS5cbiAgICAgICAgcHJldmlvdXNQcm9taXNlID8gcHJldmlvdXNQcm9taXNlLnRoZW4oXG4gICAgICAgICAgY2FsbEludm9rZVdpdGhNZXRob2RBbmRBcmcsXG4gICAgICAgICAgLy8gQXZvaWQgcHJvcGFnYXRpbmcgZmFpbHVyZXMgdG8gUHJvbWlzZXMgcmV0dXJuZWQgYnkgbGF0ZXJcbiAgICAgICAgICAvLyBpbnZvY2F0aW9ucyBvZiB0aGUgaXRlcmF0b3IuXG4gICAgICAgICAgY2FsbEludm9rZVdpdGhNZXRob2RBbmRBcmdcbiAgICAgICAgKSA6IGNhbGxJbnZva2VXaXRoTWV0aG9kQW5kQXJnKCk7XG4gICAgfVxuXG4gICAgLy8gRGVmaW5lIHRoZSB1bmlmaWVkIGhlbHBlciBtZXRob2QgdGhhdCBpcyB1c2VkIHRvIGltcGxlbWVudCAubmV4dCxcbiAgICAvLyAudGhyb3csIGFuZCAucmV0dXJuIChzZWUgZGVmaW5lSXRlcmF0b3JNZXRob2RzKS5cbiAgICB0aGlzLl9pbnZva2UgPSBlbnF1ZXVlO1xuICB9XG5cbiAgZGVmaW5lSXRlcmF0b3JNZXRob2RzKEFzeW5jSXRlcmF0b3IucHJvdG90eXBlKTtcbiAgQXN5bmNJdGVyYXRvci5wcm90b3R5cGVbYXN5bmNJdGVyYXRvclN5bWJvbF0gPSBmdW5jdGlvbiAoKSB7XG4gICAgcmV0dXJuIHRoaXM7XG4gIH07XG4gIGV4cG9ydHMuQXN5bmNJdGVyYXRvciA9IEFzeW5jSXRlcmF0b3I7XG5cbiAgLy8gTm90ZSB0aGF0IHNpbXBsZSBhc3luYyBmdW5jdGlvbnMgYXJlIGltcGxlbWVudGVkIG9uIHRvcCBvZlxuICAvLyBBc3luY0l0ZXJhdG9yIG9iamVjdHM7IHRoZXkganVzdCByZXR1cm4gYSBQcm9taXNlIGZvciB0aGUgdmFsdWUgb2ZcbiAgLy8gdGhlIGZpbmFsIHJlc3VsdCBwcm9kdWNlZCBieSB0aGUgaXRlcmF0b3IuXG4gIGV4cG9ydHMuYXN5bmMgPSBmdW5jdGlvbihpbm5lckZuLCBvdXRlckZuLCBzZWxmLCB0cnlMb2NzTGlzdCwgUHJvbWlzZUltcGwpIHtcbiAgICBpZiAoUHJvbWlzZUltcGwgPT09IHZvaWQgMCkgUHJvbWlzZUltcGwgPSBQcm9taXNlO1xuXG4gICAgdmFyIGl0ZXIgPSBuZXcgQXN5bmNJdGVyYXRvcihcbiAgICAgIHdyYXAoaW5uZXJGbiwgb3V0ZXJGbiwgc2VsZiwgdHJ5TG9jc0xpc3QpLFxuICAgICAgUHJvbWlzZUltcGxcbiAgICApO1xuXG4gICAgcmV0dXJuIGV4cG9ydHMuaXNHZW5lcmF0b3JGdW5jdGlvbihvdXRlckZuKVxuICAgICAgPyBpdGVyIC8vIElmIG91dGVyRm4gaXMgYSBnZW5lcmF0b3IsIHJldHVybiB0aGUgZnVsbCBpdGVyYXRvci5cbiAgICAgIDogaXRlci5uZXh0KCkudGhlbihmdW5jdGlvbihyZXN1bHQpIHtcbiAgICAgICAgICByZXR1cm4gcmVzdWx0LmRvbmUgPyByZXN1bHQudmFsdWUgOiBpdGVyLm5leHQoKTtcbiAgICAgICAgfSk7XG4gIH07XG5cbiAgZnVuY3Rpb24gbWFrZUludm9rZU1ldGhvZChpbm5lckZuLCBzZWxmLCBjb250ZXh0KSB7XG4gICAgdmFyIHN0YXRlID0gR2VuU3RhdGVTdXNwZW5kZWRTdGFydDtcblxuICAgIHJldHVybiBmdW5jdGlvbiBpbnZva2UobWV0aG9kLCBhcmcpIHtcbiAgICAgIGlmIChzdGF0ZSA9PT0gR2VuU3RhdGVFeGVjdXRpbmcpIHtcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiR2VuZXJhdG9yIGlzIGFscmVhZHkgcnVubmluZ1wiKTtcbiAgICAgIH1cblxuICAgICAgaWYgKHN0YXRlID09PSBHZW5TdGF0ZUNvbXBsZXRlZCkge1xuICAgICAgICBpZiAobWV0aG9kID09PSBcInRocm93XCIpIHtcbiAgICAgICAgICB0aHJvdyBhcmc7XG4gICAgICAgIH1cblxuICAgICAgICAvLyBCZSBmb3JnaXZpbmcsIHBlciAyNS4zLjMuMy4zIG9mIHRoZSBzcGVjOlxuICAgICAgICAvLyBodHRwczovL3Blb3BsZS5tb3ppbGxhLm9yZy9+am9yZW5kb3JmZi9lczYtZHJhZnQuaHRtbCNzZWMtZ2VuZXJhdG9ycmVzdW1lXG4gICAgICAgIHJldHVybiBkb25lUmVzdWx0KCk7XG4gICAgICB9XG5cbiAgICAgIGNvbnRleHQubWV0aG9kID0gbWV0aG9kO1xuICAgICAgY29udGV4dC5hcmcgPSBhcmc7XG5cbiAgICAgIHdoaWxlICh0cnVlKSB7XG4gICAgICAgIHZhciBkZWxlZ2F0ZSA9IGNvbnRleHQuZGVsZWdhdGU7XG4gICAgICAgIGlmIChkZWxlZ2F0ZSkge1xuICAgICAgICAgIHZhciBkZWxlZ2F0ZVJlc3VsdCA9IG1heWJlSW52b2tlRGVsZWdhdGUoZGVsZWdhdGUsIGNvbnRleHQpO1xuICAgICAgICAgIGlmIChkZWxlZ2F0ZVJlc3VsdCkge1xuICAgICAgICAgICAgaWYgKGRlbGVnYXRlUmVzdWx0ID09PSBDb250aW51ZVNlbnRpbmVsKSBjb250aW51ZTtcbiAgICAgICAgICAgIHJldHVybiBkZWxlZ2F0ZVJlc3VsdDtcbiAgICAgICAgICB9XG4gICAgICAgIH1cblxuICAgICAgICBpZiAoY29udGV4dC5tZXRob2QgPT09IFwibmV4dFwiKSB7XG4gICAgICAgICAgLy8gU2V0dGluZyBjb250ZXh0Ll9zZW50IGZvciBsZWdhY3kgc3VwcG9ydCBvZiBCYWJlbCdzXG4gICAgICAgICAgLy8gZnVuY3Rpb24uc2VudCBpbXBsZW1lbnRhdGlvbi5cbiAgICAgICAgICBjb250ZXh0LnNlbnQgPSBjb250ZXh0Ll9zZW50ID0gY29udGV4dC5hcmc7XG5cbiAgICAgICAgfSBlbHNlIGlmIChjb250ZXh0Lm1ldGhvZCA9PT0gXCJ0aHJvd1wiKSB7XG4gICAgICAgICAgaWYgKHN0YXRlID09PSBHZW5TdGF0ZVN1c3BlbmRlZFN0YXJ0KSB7XG4gICAgICAgICAgICBzdGF0ZSA9IEdlblN0YXRlQ29tcGxldGVkO1xuICAgICAgICAgICAgdGhyb3cgY29udGV4dC5hcmc7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgY29udGV4dC5kaXNwYXRjaEV4Y2VwdGlvbihjb250ZXh0LmFyZyk7XG5cbiAgICAgICAgfSBlbHNlIGlmIChjb250ZXh0Lm1ldGhvZCA9PT0gXCJyZXR1cm5cIikge1xuICAgICAgICAgIGNvbnRleHQuYWJydXB0KFwicmV0dXJuXCIsIGNvbnRleHQuYXJnKTtcbiAgICAgICAgfVxuXG4gICAgICAgIHN0YXRlID0gR2VuU3RhdGVFeGVjdXRpbmc7XG5cbiAgICAgICAgdmFyIHJlY29yZCA9IHRyeUNhdGNoKGlubmVyRm4sIHNlbGYsIGNvbnRleHQpO1xuICAgICAgICBpZiAocmVjb3JkLnR5cGUgPT09IFwibm9ybWFsXCIpIHtcbiAgICAgICAgICAvLyBJZiBhbiBleGNlcHRpb24gaXMgdGhyb3duIGZyb20gaW5uZXJGbiwgd2UgbGVhdmUgc3RhdGUgPT09XG4gICAgICAgICAgLy8gR2VuU3RhdGVFeGVjdXRpbmcgYW5kIGxvb3AgYmFjayBmb3IgYW5vdGhlciBpbnZvY2F0aW9uLlxuICAgICAgICAgIHN0YXRlID0gY29udGV4dC5kb25lXG4gICAgICAgICAgICA/IEdlblN0YXRlQ29tcGxldGVkXG4gICAgICAgICAgICA6IEdlblN0YXRlU3VzcGVuZGVkWWllbGQ7XG5cbiAgICAgICAgICBpZiAocmVjb3JkLmFyZyA9PT0gQ29udGludWVTZW50aW5lbCkge1xuICAgICAgICAgICAgY29udGludWU7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgcmV0dXJuIHtcbiAgICAgICAgICAgIHZhbHVlOiByZWNvcmQuYXJnLFxuICAgICAgICAgICAgZG9uZTogY29udGV4dC5kb25lXG4gICAgICAgICAgfTtcblxuICAgICAgICB9IGVsc2UgaWYgKHJlY29yZC50eXBlID09PSBcInRocm93XCIpIHtcbiAgICAgICAgICBzdGF0ZSA9IEdlblN0YXRlQ29tcGxldGVkO1xuICAgICAgICAgIC8vIERpc3BhdGNoIHRoZSBleGNlcHRpb24gYnkgbG9vcGluZyBiYWNrIGFyb3VuZCB0byB0aGVcbiAgICAgICAgICAvLyBjb250ZXh0LmRpc3BhdGNoRXhjZXB0aW9uKGNvbnRleHQuYXJnKSBjYWxsIGFib3ZlLlxuICAgICAgICAgIGNvbnRleHQubWV0aG9kID0gXCJ0aHJvd1wiO1xuICAgICAgICAgIGNvbnRleHQuYXJnID0gcmVjb3JkLmFyZztcbiAgICAgICAgfVxuICAgICAgfVxuICAgIH07XG4gIH1cblxuICAvLyBDYWxsIGRlbGVnYXRlLml0ZXJhdG9yW2NvbnRleHQubWV0aG9kXShjb250ZXh0LmFyZykgYW5kIGhhbmRsZSB0aGVcbiAgLy8gcmVzdWx0LCBlaXRoZXIgYnkgcmV0dXJuaW5nIGEgeyB2YWx1ZSwgZG9uZSB9IHJlc3VsdCBmcm9tIHRoZVxuICAvLyBkZWxlZ2F0ZSBpdGVyYXRvciwgb3IgYnkgbW9kaWZ5aW5nIGNvbnRleHQubWV0aG9kIGFuZCBjb250ZXh0LmFyZyxcbiAgLy8gc2V0dGluZyBjb250ZXh0LmRlbGVnYXRlIHRvIG51bGwsIGFuZCByZXR1cm5pbmcgdGhlIENvbnRpbnVlU2VudGluZWwuXG4gIGZ1bmN0aW9uIG1heWJlSW52b2tlRGVsZWdhdGUoZGVsZWdhdGUsIGNvbnRleHQpIHtcbiAgICB2YXIgbWV0aG9kID0gZGVsZWdhdGUuaXRlcmF0b3JbY29udGV4dC5tZXRob2RdO1xuICAgIGlmIChtZXRob2QgPT09IHVuZGVmaW5lZCkge1xuICAgICAgLy8gQSAudGhyb3cgb3IgLnJldHVybiB3aGVuIHRoZSBkZWxlZ2F0ZSBpdGVyYXRvciBoYXMgbm8gLnRocm93XG4gICAgICAvLyBtZXRob2QgYWx3YXlzIHRlcm1pbmF0ZXMgdGhlIHlpZWxkKiBsb29wLlxuICAgICAgY29udGV4dC5kZWxlZ2F0ZSA9IG51bGw7XG5cbiAgICAgIGlmIChjb250ZXh0Lm1ldGhvZCA9PT0gXCJ0aHJvd1wiKSB7XG4gICAgICAgIC8vIE5vdGU6IFtcInJldHVyblwiXSBtdXN0IGJlIHVzZWQgZm9yIEVTMyBwYXJzaW5nIGNvbXBhdGliaWxpdHkuXG4gICAgICAgIGlmIChkZWxlZ2F0ZS5pdGVyYXRvcltcInJldHVyblwiXSkge1xuICAgICAgICAgIC8vIElmIHRoZSBkZWxlZ2F0ZSBpdGVyYXRvciBoYXMgYSByZXR1cm4gbWV0aG9kLCBnaXZlIGl0IGFcbiAgICAgICAgICAvLyBjaGFuY2UgdG8gY2xlYW4gdXAuXG4gICAgICAgICAgY29udGV4dC5tZXRob2QgPSBcInJldHVyblwiO1xuICAgICAgICAgIGNvbnRleHQuYXJnID0gdW5kZWZpbmVkO1xuICAgICAgICAgIG1heWJlSW52b2tlRGVsZWdhdGUoZGVsZWdhdGUsIGNvbnRleHQpO1xuXG4gICAgICAgICAgaWYgKGNvbnRleHQubWV0aG9kID09PSBcInRocm93XCIpIHtcbiAgICAgICAgICAgIC8vIElmIG1heWJlSW52b2tlRGVsZWdhdGUoY29udGV4dCkgY2hhbmdlZCBjb250ZXh0Lm1ldGhvZCBmcm9tXG4gICAgICAgICAgICAvLyBcInJldHVyblwiIHRvIFwidGhyb3dcIiwgbGV0IHRoYXQgb3ZlcnJpZGUgdGhlIFR5cGVFcnJvciBiZWxvdy5cbiAgICAgICAgICAgIHJldHVybiBDb250aW51ZVNlbnRpbmVsO1xuICAgICAgICAgIH1cbiAgICAgICAgfVxuXG4gICAgICAgIGNvbnRleHQubWV0aG9kID0gXCJ0aHJvd1wiO1xuICAgICAgICBjb250ZXh0LmFyZyA9IG5ldyBUeXBlRXJyb3IoXG4gICAgICAgICAgXCJUaGUgaXRlcmF0b3IgZG9lcyBub3QgcHJvdmlkZSBhICd0aHJvdycgbWV0aG9kXCIpO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gQ29udGludWVTZW50aW5lbDtcbiAgICB9XG5cbiAgICB2YXIgcmVjb3JkID0gdHJ5Q2F0Y2gobWV0aG9kLCBkZWxlZ2F0ZS5pdGVyYXRvciwgY29udGV4dC5hcmcpO1xuXG4gICAgaWYgKHJlY29yZC50eXBlID09PSBcInRocm93XCIpIHtcbiAgICAgIGNvbnRleHQubWV0aG9kID0gXCJ0aHJvd1wiO1xuICAgICAgY29udGV4dC5hcmcgPSByZWNvcmQuYXJnO1xuICAgICAgY29udGV4dC5kZWxlZ2F0ZSA9IG51bGw7XG4gICAgICByZXR1cm4gQ29udGludWVTZW50aW5lbDtcbiAgICB9XG5cbiAgICB2YXIgaW5mbyA9IHJlY29yZC5hcmc7XG5cbiAgICBpZiAoISBpbmZvKSB7XG4gICAgICBjb250ZXh0Lm1ldGhvZCA9IFwidGhyb3dcIjtcbiAgICAgIGNvbnRleHQuYXJnID0gbmV3IFR5cGVFcnJvcihcIml0ZXJhdG9yIHJlc3VsdCBpcyBub3QgYW4gb2JqZWN0XCIpO1xuICAgICAgY29udGV4dC5kZWxlZ2F0ZSA9IG51bGw7XG4gICAgICByZXR1cm4gQ29udGludWVTZW50aW5lbDtcbiAgICB9XG5cbiAgICBpZiAoaW5mby5kb25lKSB7XG4gICAgICAvLyBBc3NpZ24gdGhlIHJlc3VsdCBvZiB0aGUgZmluaXNoZWQgZGVsZWdhdGUgdG8gdGhlIHRlbXBvcmFyeVxuICAgICAgLy8gdmFyaWFibGUgc3BlY2lmaWVkIGJ5IGRlbGVnYXRlLnJlc3VsdE5hbWUgKHNlZSBkZWxlZ2F0ZVlpZWxkKS5cbiAgICAgIGNvbnRleHRbZGVsZWdhdGUucmVzdWx0TmFtZV0gPSBpbmZvLnZhbHVlO1xuXG4gICAgICAvLyBSZXN1bWUgZXhlY3V0aW9uIGF0IHRoZSBkZXNpcmVkIGxvY2F0aW9uIChzZWUgZGVsZWdhdGVZaWVsZCkuXG4gICAgICBjb250ZXh0Lm5leHQgPSBkZWxlZ2F0ZS5uZXh0TG9jO1xuXG4gICAgICAvLyBJZiBjb250ZXh0Lm1ldGhvZCB3YXMgXCJ0aHJvd1wiIGJ1dCB0aGUgZGVsZWdhdGUgaGFuZGxlZCB0aGVcbiAgICAgIC8vIGV4Y2VwdGlvbiwgbGV0IHRoZSBvdXRlciBnZW5lcmF0b3IgcHJvY2VlZCBub3JtYWxseS4gSWZcbiAgICAgIC8vIGNvbnRleHQubWV0aG9kIHdhcyBcIm5leHRcIiwgZm9yZ2V0IGNvbnRleHQuYXJnIHNpbmNlIGl0IGhhcyBiZWVuXG4gICAgICAvLyBcImNvbnN1bWVkXCIgYnkgdGhlIGRlbGVnYXRlIGl0ZXJhdG9yLiBJZiBjb250ZXh0Lm1ldGhvZCB3YXNcbiAgICAgIC8vIFwicmV0dXJuXCIsIGFsbG93IHRoZSBvcmlnaW5hbCAucmV0dXJuIGNhbGwgdG8gY29udGludWUgaW4gdGhlXG4gICAgICAvLyBvdXRlciBnZW5lcmF0b3IuXG4gICAgICBpZiAoY29udGV4dC5tZXRob2QgIT09IFwicmV0dXJuXCIpIHtcbiAgICAgICAgY29udGV4dC5tZXRob2QgPSBcIm5leHRcIjtcbiAgICAgICAgY29udGV4dC5hcmcgPSB1bmRlZmluZWQ7XG4gICAgICB9XG5cbiAgICB9IGVsc2Uge1xuICAgICAgLy8gUmUteWllbGQgdGhlIHJlc3VsdCByZXR1cm5lZCBieSB0aGUgZGVsZWdhdGUgbWV0aG9kLlxuICAgICAgcmV0dXJuIGluZm87XG4gICAgfVxuXG4gICAgLy8gVGhlIGRlbGVnYXRlIGl0ZXJhdG9yIGlzIGZpbmlzaGVkLCBzbyBmb3JnZXQgaXQgYW5kIGNvbnRpbnVlIHdpdGhcbiAgICAvLyB0aGUgb3V0ZXIgZ2VuZXJhdG9yLlxuICAgIGNvbnRleHQuZGVsZWdhdGUgPSBudWxsO1xuICAgIHJldHVybiBDb250aW51ZVNlbnRpbmVsO1xuICB9XG5cbiAgLy8gRGVmaW5lIEdlbmVyYXRvci5wcm90b3R5cGUue25leHQsdGhyb3cscmV0dXJufSBpbiB0ZXJtcyBvZiB0aGVcbiAgLy8gdW5pZmllZCAuX2ludm9rZSBoZWxwZXIgbWV0aG9kLlxuICBkZWZpbmVJdGVyYXRvck1ldGhvZHMoR3ApO1xuXG4gIGRlZmluZShHcCwgdG9TdHJpbmdUYWdTeW1ib2wsIFwiR2VuZXJhdG9yXCIpO1xuXG4gIC8vIEEgR2VuZXJhdG9yIHNob3VsZCBhbHdheXMgcmV0dXJuIGl0c2VsZiBhcyB0aGUgaXRlcmF0b3Igb2JqZWN0IHdoZW4gdGhlXG4gIC8vIEBAaXRlcmF0b3IgZnVuY3Rpb24gaXMgY2FsbGVkIG9uIGl0LiBTb21lIGJyb3dzZXJzJyBpbXBsZW1lbnRhdGlvbnMgb2YgdGhlXG4gIC8vIGl0ZXJhdG9yIHByb3RvdHlwZSBjaGFpbiBpbmNvcnJlY3RseSBpbXBsZW1lbnQgdGhpcywgY2F1c2luZyB0aGUgR2VuZXJhdG9yXG4gIC8vIG9iamVjdCB0byBub3QgYmUgcmV0dXJuZWQgZnJvbSB0aGlzIGNhbGwuIFRoaXMgZW5zdXJlcyB0aGF0IGRvZXNuJ3QgaGFwcGVuLlxuICAvLyBTZWUgaHR0cHM6Ly9naXRodWIuY29tL2ZhY2Vib29rL3JlZ2VuZXJhdG9yL2lzc3Vlcy8yNzQgZm9yIG1vcmUgZGV0YWlscy5cbiAgR3BbaXRlcmF0b3JTeW1ib2xdID0gZnVuY3Rpb24oKSB7XG4gICAgcmV0dXJuIHRoaXM7XG4gIH07XG5cbiAgR3AudG9TdHJpbmcgPSBmdW5jdGlvbigpIHtcbiAgICByZXR1cm4gXCJbb2JqZWN0IEdlbmVyYXRvcl1cIjtcbiAgfTtcblxuICBmdW5jdGlvbiBwdXNoVHJ5RW50cnkobG9jcykge1xuICAgIHZhciBlbnRyeSA9IHsgdHJ5TG9jOiBsb2NzWzBdIH07XG5cbiAgICBpZiAoMSBpbiBsb2NzKSB7XG4gICAgICBlbnRyeS5jYXRjaExvYyA9IGxvY3NbMV07XG4gICAgfVxuXG4gICAgaWYgKDIgaW4gbG9jcykge1xuICAgICAgZW50cnkuZmluYWxseUxvYyA9IGxvY3NbMl07XG4gICAgICBlbnRyeS5hZnRlckxvYyA9IGxvY3NbM107XG4gICAgfVxuXG4gICAgdGhpcy50cnlFbnRyaWVzLnB1c2goZW50cnkpO1xuICB9XG5cbiAgZnVuY3Rpb24gcmVzZXRUcnlFbnRyeShlbnRyeSkge1xuICAgIHZhciByZWNvcmQgPSBlbnRyeS5jb21wbGV0aW9uIHx8IHt9O1xuICAgIHJlY29yZC50eXBlID0gXCJub3JtYWxcIjtcbiAgICBkZWxldGUgcmVjb3JkLmFyZztcbiAgICBlbnRyeS5jb21wbGV0aW9uID0gcmVjb3JkO1xuICB9XG5cbiAgZnVuY3Rpb24gQ29udGV4dCh0cnlMb2NzTGlzdCkge1xuICAgIC8vIFRoZSByb290IGVudHJ5IG9iamVjdCAoZWZmZWN0aXZlbHkgYSB0cnkgc3RhdGVtZW50IHdpdGhvdXQgYSBjYXRjaFxuICAgIC8vIG9yIGEgZmluYWxseSBibG9jaykgZ2l2ZXMgdXMgYSBwbGFjZSB0byBzdG9yZSB2YWx1ZXMgdGhyb3duIGZyb21cbiAgICAvLyBsb2NhdGlvbnMgd2hlcmUgdGhlcmUgaXMgbm8gZW5jbG9zaW5nIHRyeSBzdGF0ZW1lbnQuXG4gICAgdGhpcy50cnlFbnRyaWVzID0gW3sgdHJ5TG9jOiBcInJvb3RcIiB9XTtcbiAgICB0cnlMb2NzTGlzdC5mb3JFYWNoKHB1c2hUcnlFbnRyeSwgdGhpcyk7XG4gICAgdGhpcy5yZXNldCh0cnVlKTtcbiAgfVxuXG4gIGV4cG9ydHMua2V5cyA9IGZ1bmN0aW9uKG9iamVjdCkge1xuICAgIHZhciBrZXlzID0gW107XG4gICAgZm9yICh2YXIga2V5IGluIG9iamVjdCkge1xuICAgICAga2V5cy5wdXNoKGtleSk7XG4gICAgfVxuICAgIGtleXMucmV2ZXJzZSgpO1xuXG4gICAgLy8gUmF0aGVyIHRoYW4gcmV0dXJuaW5nIGFuIG9iamVjdCB3aXRoIGEgbmV4dCBtZXRob2QsIHdlIGtlZXBcbiAgICAvLyB0aGluZ3Mgc2ltcGxlIGFuZCByZXR1cm4gdGhlIG5leHQgZnVuY3Rpb24gaXRzZWxmLlxuICAgIHJldHVybiBmdW5jdGlvbiBuZXh0KCkge1xuICAgICAgd2hpbGUgKGtleXMubGVuZ3RoKSB7XG4gICAgICAgIHZhciBrZXkgPSBrZXlzLnBvcCgpO1xuICAgICAgICBpZiAoa2V5IGluIG9iamVjdCkge1xuICAgICAgICAgIG5leHQudmFsdWUgPSBrZXk7XG4gICAgICAgICAgbmV4dC5kb25lID0gZmFsc2U7XG4gICAgICAgICAgcmV0dXJuIG5leHQ7XG4gICAgICAgIH1cbiAgICAgIH1cblxuICAgICAgLy8gVG8gYXZvaWQgY3JlYXRpbmcgYW4gYWRkaXRpb25hbCBvYmplY3QsIHdlIGp1c3QgaGFuZyB0aGUgLnZhbHVlXG4gICAgICAvLyBhbmQgLmRvbmUgcHJvcGVydGllcyBvZmYgdGhlIG5leHQgZnVuY3Rpb24gb2JqZWN0IGl0c2VsZi4gVGhpc1xuICAgICAgLy8gYWxzbyBlbnN1cmVzIHRoYXQgdGhlIG1pbmlmaWVyIHdpbGwgbm90IGFub255bWl6ZSB0aGUgZnVuY3Rpb24uXG4gICAgICBuZXh0LmRvbmUgPSB0cnVlO1xuICAgICAgcmV0dXJuIG5leHQ7XG4gICAgfTtcbiAgfTtcblxuICBmdW5jdGlvbiB2YWx1ZXMoaXRlcmFibGUpIHtcbiAgICBpZiAoaXRlcmFibGUpIHtcbiAgICAgIHZhciBpdGVyYXRvck1ldGhvZCA9IGl0ZXJhYmxlW2l0ZXJhdG9yU3ltYm9sXTtcbiAgICAgIGlmIChpdGVyYXRvck1ldGhvZCkge1xuICAgICAgICByZXR1cm4gaXRlcmF0b3JNZXRob2QuY2FsbChpdGVyYWJsZSk7XG4gICAgICB9XG5cbiAgICAgIGlmICh0eXBlb2YgaXRlcmFibGUubmV4dCA9PT0gXCJmdW5jdGlvblwiKSB7XG4gICAgICAgIHJldHVybiBpdGVyYWJsZTtcbiAgICAgIH1cblxuICAgICAgaWYgKCFpc05hTihpdGVyYWJsZS5sZW5ndGgpKSB7XG4gICAgICAgIHZhciBpID0gLTEsIG5leHQgPSBmdW5jdGlvbiBuZXh0KCkge1xuICAgICAgICAgIHdoaWxlICgrK2kgPCBpdGVyYWJsZS5sZW5ndGgpIHtcbiAgICAgICAgICAgIGlmIChoYXNPd24uY2FsbChpdGVyYWJsZSwgaSkpIHtcbiAgICAgICAgICAgICAgbmV4dC52YWx1ZSA9IGl0ZXJhYmxlW2ldO1xuICAgICAgICAgICAgICBuZXh0LmRvbmUgPSBmYWxzZTtcbiAgICAgICAgICAgICAgcmV0dXJuIG5leHQ7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgbmV4dC52YWx1ZSA9IHVuZGVmaW5lZDtcbiAgICAgICAgICBuZXh0LmRvbmUgPSB0cnVlO1xuXG4gICAgICAgICAgcmV0dXJuIG5leHQ7XG4gICAgICAgIH07XG5cbiAgICAgICAgcmV0dXJuIG5leHQubmV4dCA9IG5leHQ7XG4gICAgICB9XG4gICAgfVxuXG4gICAgLy8gUmV0dXJuIGFuIGl0ZXJhdG9yIHdpdGggbm8gdmFsdWVzLlxuICAgIHJldHVybiB7IG5leHQ6IGRvbmVSZXN1bHQgfTtcbiAgfVxuICBleHBvcnRzLnZhbHVlcyA9IHZhbHVlcztcblxuICBmdW5jdGlvbiBkb25lUmVzdWx0KCkge1xuICAgIHJldHVybiB7IHZhbHVlOiB1bmRlZmluZWQsIGRvbmU6IHRydWUgfTtcbiAgfVxuXG4gIENvbnRleHQucHJvdG90eXBlID0ge1xuICAgIGNvbnN0cnVjdG9yOiBDb250ZXh0LFxuXG4gICAgcmVzZXQ6IGZ1bmN0aW9uKHNraXBUZW1wUmVzZXQpIHtcbiAgICAgIHRoaXMucHJldiA9IDA7XG4gICAgICB0aGlzLm5leHQgPSAwO1xuICAgICAgLy8gUmVzZXR0aW5nIGNvbnRleHQuX3NlbnQgZm9yIGxlZ2FjeSBzdXBwb3J0IG9mIEJhYmVsJ3NcbiAgICAgIC8vIGZ1bmN0aW9uLnNlbnQgaW1wbGVtZW50YXRpb24uXG4gICAgICB0aGlzLnNlbnQgPSB0aGlzLl9zZW50ID0gdW5kZWZpbmVkO1xuICAgICAgdGhpcy5kb25lID0gZmFsc2U7XG4gICAgICB0aGlzLmRlbGVnYXRlID0gbnVsbDtcblxuICAgICAgdGhpcy5tZXRob2QgPSBcIm5leHRcIjtcbiAgICAgIHRoaXMuYXJnID0gdW5kZWZpbmVkO1xuXG4gICAgICB0aGlzLnRyeUVudHJpZXMuZm9yRWFjaChyZXNldFRyeUVudHJ5KTtcblxuICAgICAgaWYgKCFza2lwVGVtcFJlc2V0KSB7XG4gICAgICAgIGZvciAodmFyIG5hbWUgaW4gdGhpcykge1xuICAgICAgICAgIC8vIE5vdCBzdXJlIGFib3V0IHRoZSBvcHRpbWFsIG9yZGVyIG9mIHRoZXNlIGNvbmRpdGlvbnM6XG4gICAgICAgICAgaWYgKG5hbWUuY2hhckF0KDApID09PSBcInRcIiAmJlxuICAgICAgICAgICAgICBoYXNPd24uY2FsbCh0aGlzLCBuYW1lKSAmJlxuICAgICAgICAgICAgICAhaXNOYU4oK25hbWUuc2xpY2UoMSkpKSB7XG4gICAgICAgICAgICB0aGlzW25hbWVdID0gdW5kZWZpbmVkO1xuICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgfVxuICAgIH0sXG5cbiAgICBzdG9wOiBmdW5jdGlvbigpIHtcbiAgICAgIHRoaXMuZG9uZSA9IHRydWU7XG5cbiAgICAgIHZhciByb290RW50cnkgPSB0aGlzLnRyeUVudHJpZXNbMF07XG4gICAgICB2YXIgcm9vdFJlY29yZCA9IHJvb3RFbnRyeS5jb21wbGV0aW9uO1xuICAgICAgaWYgKHJvb3RSZWNvcmQudHlwZSA9PT0gXCJ0aHJvd1wiKSB7XG4gICAgICAgIHRocm93IHJvb3RSZWNvcmQuYXJnO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gdGhpcy5ydmFsO1xuICAgIH0sXG5cbiAgICBkaXNwYXRjaEV4Y2VwdGlvbjogZnVuY3Rpb24oZXhjZXB0aW9uKSB7XG4gICAgICBpZiAodGhpcy5kb25lKSB7XG4gICAgICAgIHRocm93IGV4Y2VwdGlvbjtcbiAgICAgIH1cblxuICAgICAgdmFyIGNvbnRleHQgPSB0aGlzO1xuICAgICAgZnVuY3Rpb24gaGFuZGxlKGxvYywgY2F1Z2h0KSB7XG4gICAgICAgIHJlY29yZC50eXBlID0gXCJ0aHJvd1wiO1xuICAgICAgICByZWNvcmQuYXJnID0gZXhjZXB0aW9uO1xuICAgICAgICBjb250ZXh0Lm5leHQgPSBsb2M7XG5cbiAgICAgICAgaWYgKGNhdWdodCkge1xuICAgICAgICAgIC8vIElmIHRoZSBkaXNwYXRjaGVkIGV4Y2VwdGlvbiB3YXMgY2F1Z2h0IGJ5IGEgY2F0Y2ggYmxvY2ssXG4gICAgICAgICAgLy8gdGhlbiBsZXQgdGhhdCBjYXRjaCBibG9jayBoYW5kbGUgdGhlIGV4Y2VwdGlvbiBub3JtYWxseS5cbiAgICAgICAgICBjb250ZXh0Lm1ldGhvZCA9IFwibmV4dFwiO1xuICAgICAgICAgIGNvbnRleHQuYXJnID0gdW5kZWZpbmVkO1xuICAgICAgICB9XG5cbiAgICAgICAgcmV0dXJuICEhIGNhdWdodDtcbiAgICAgIH1cblxuICAgICAgZm9yICh2YXIgaSA9IHRoaXMudHJ5RW50cmllcy5sZW5ndGggLSAxOyBpID49IDA7IC0taSkge1xuICAgICAgICB2YXIgZW50cnkgPSB0aGlzLnRyeUVudHJpZXNbaV07XG4gICAgICAgIHZhciByZWNvcmQgPSBlbnRyeS5jb21wbGV0aW9uO1xuXG4gICAgICAgIGlmIChlbnRyeS50cnlMb2MgPT09IFwicm9vdFwiKSB7XG4gICAgICAgICAgLy8gRXhjZXB0aW9uIHRocm93biBvdXRzaWRlIG9mIGFueSB0cnkgYmxvY2sgdGhhdCBjb3VsZCBoYW5kbGVcbiAgICAgICAgICAvLyBpdCwgc28gc2V0IHRoZSBjb21wbGV0aW9uIHZhbHVlIG9mIHRoZSBlbnRpcmUgZnVuY3Rpb24gdG9cbiAgICAgICAgICAvLyB0aHJvdyB0aGUgZXhjZXB0aW9uLlxuICAgICAgICAgIHJldHVybiBoYW5kbGUoXCJlbmRcIik7XG4gICAgICAgIH1cblxuICAgICAgICBpZiAoZW50cnkudHJ5TG9jIDw9IHRoaXMucHJldikge1xuICAgICAgICAgIHZhciBoYXNDYXRjaCA9IGhhc093bi5jYWxsKGVudHJ5LCBcImNhdGNoTG9jXCIpO1xuICAgICAgICAgIHZhciBoYXNGaW5hbGx5ID0gaGFzT3duLmNhbGwoZW50cnksIFwiZmluYWxseUxvY1wiKTtcblxuICAgICAgICAgIGlmIChoYXNDYXRjaCAmJiBoYXNGaW5hbGx5KSB7XG4gICAgICAgICAgICBpZiAodGhpcy5wcmV2IDwgZW50cnkuY2F0Y2hMb2MpIHtcbiAgICAgICAgICAgICAgcmV0dXJuIGhhbmRsZShlbnRyeS5jYXRjaExvYywgdHJ1ZSk7XG4gICAgICAgICAgICB9IGVsc2UgaWYgKHRoaXMucHJldiA8IGVudHJ5LmZpbmFsbHlMb2MpIHtcbiAgICAgICAgICAgICAgcmV0dXJuIGhhbmRsZShlbnRyeS5maW5hbGx5TG9jKTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgIH0gZWxzZSBpZiAoaGFzQ2F0Y2gpIHtcbiAgICAgICAgICAgIGlmICh0aGlzLnByZXYgPCBlbnRyeS5jYXRjaExvYykge1xuICAgICAgICAgICAgICByZXR1cm4gaGFuZGxlKGVudHJ5LmNhdGNoTG9jLCB0cnVlKTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgIH0gZWxzZSBpZiAoaGFzRmluYWxseSkge1xuICAgICAgICAgICAgaWYgKHRoaXMucHJldiA8IGVudHJ5LmZpbmFsbHlMb2MpIHtcbiAgICAgICAgICAgICAgcmV0dXJuIGhhbmRsZShlbnRyeS5maW5hbGx5TG9jKTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJ0cnkgc3RhdGVtZW50IHdpdGhvdXQgY2F0Y2ggb3IgZmluYWxseVwiKTtcbiAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICB9LFxuXG4gICAgYWJydXB0OiBmdW5jdGlvbih0eXBlLCBhcmcpIHtcbiAgICAgIGZvciAodmFyIGkgPSB0aGlzLnRyeUVudHJpZXMubGVuZ3RoIC0gMTsgaSA+PSAwOyAtLWkpIHtcbiAgICAgICAgdmFyIGVudHJ5ID0gdGhpcy50cnlFbnRyaWVzW2ldO1xuICAgICAgICBpZiAoZW50cnkudHJ5TG9jIDw9IHRoaXMucHJldiAmJlxuICAgICAgICAgICAgaGFzT3duLmNhbGwoZW50cnksIFwiZmluYWxseUxvY1wiKSAmJlxuICAgICAgICAgICAgdGhpcy5wcmV2IDwgZW50cnkuZmluYWxseUxvYykge1xuICAgICAgICAgIHZhciBmaW5hbGx5RW50cnkgPSBlbnRyeTtcbiAgICAgICAgICBicmVhaztcbiAgICAgICAgfVxuICAgICAgfVxuXG4gICAgICBpZiAoZmluYWxseUVudHJ5ICYmXG4gICAgICAgICAgKHR5cGUgPT09IFwiYnJlYWtcIiB8fFxuICAgICAgICAgICB0eXBlID09PSBcImNvbnRpbnVlXCIpICYmXG4gICAgICAgICAgZmluYWxseUVudHJ5LnRyeUxvYyA8PSBhcmcgJiZcbiAgICAgICAgICBhcmcgPD0gZmluYWxseUVudHJ5LmZpbmFsbHlMb2MpIHtcbiAgICAgICAgLy8gSWdub3JlIHRoZSBmaW5hbGx5IGVudHJ5IGlmIGNvbnRyb2wgaXMgbm90IGp1bXBpbmcgdG8gYVxuICAgICAgICAvLyBsb2NhdGlvbiBvdXRzaWRlIHRoZSB0cnkvY2F0Y2ggYmxvY2suXG4gICAgICAgIGZpbmFsbHlFbnRyeSA9IG51bGw7XG4gICAgICB9XG5cbiAgICAgIHZhciByZWNvcmQgPSBmaW5hbGx5RW50cnkgPyBmaW5hbGx5RW50cnkuY29tcGxldGlvbiA6IHt9O1xuICAgICAgcmVjb3JkLnR5cGUgPSB0eXBlO1xuICAgICAgcmVjb3JkLmFyZyA9IGFyZztcblxuICAgICAgaWYgKGZpbmFsbHlFbnRyeSkge1xuICAgICAgICB0aGlzLm1ldGhvZCA9IFwibmV4dFwiO1xuICAgICAgICB0aGlzLm5leHQgPSBmaW5hbGx5RW50cnkuZmluYWxseUxvYztcbiAgICAgICAgcmV0dXJuIENvbnRpbnVlU2VudGluZWw7XG4gICAgICB9XG5cbiAgICAgIHJldHVybiB0aGlzLmNvbXBsZXRlKHJlY29yZCk7XG4gICAgfSxcblxuICAgIGNvbXBsZXRlOiBmdW5jdGlvbihyZWNvcmQsIGFmdGVyTG9jKSB7XG4gICAgICBpZiAocmVjb3JkLnR5cGUgPT09IFwidGhyb3dcIikge1xuICAgICAgICB0aHJvdyByZWNvcmQuYXJnO1xuICAgICAgfVxuXG4gICAgICBpZiAocmVjb3JkLnR5cGUgPT09IFwiYnJlYWtcIiB8fFxuICAgICAgICAgIHJlY29yZC50eXBlID09PSBcImNvbnRpbnVlXCIpIHtcbiAgICAgICAgdGhpcy5uZXh0ID0gcmVjb3JkLmFyZztcbiAgICAgIH0gZWxzZSBpZiAocmVjb3JkLnR5cGUgPT09IFwicmV0dXJuXCIpIHtcbiAgICAgICAgdGhpcy5ydmFsID0gdGhpcy5hcmcgPSByZWNvcmQuYXJnO1xuICAgICAgICB0aGlzLm1ldGhvZCA9IFwicmV0dXJuXCI7XG4gICAgICAgIHRoaXMubmV4dCA9IFwiZW5kXCI7XG4gICAgICB9IGVsc2UgaWYgKHJlY29yZC50eXBlID09PSBcIm5vcm1hbFwiICYmIGFmdGVyTG9jKSB7XG4gICAgICAgIHRoaXMubmV4dCA9IGFmdGVyTG9jO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gQ29udGludWVTZW50aW5lbDtcbiAgICB9LFxuXG4gICAgZmluaXNoOiBmdW5jdGlvbihmaW5hbGx5TG9jKSB7XG4gICAgICBmb3IgKHZhciBpID0gdGhpcy50cnlFbnRyaWVzLmxlbmd0aCAtIDE7IGkgPj0gMDsgLS1pKSB7XG4gICAgICAgIHZhciBlbnRyeSA9IHRoaXMudHJ5RW50cmllc1tpXTtcbiAgICAgICAgaWYgKGVudHJ5LmZpbmFsbHlMb2MgPT09IGZpbmFsbHlMb2MpIHtcbiAgICAgICAgICB0aGlzLmNvbXBsZXRlKGVudHJ5LmNvbXBsZXRpb24sIGVudHJ5LmFmdGVyTG9jKTtcbiAgICAgICAgICByZXNldFRyeUVudHJ5KGVudHJ5KTtcbiAgICAgICAgICByZXR1cm4gQ29udGludWVTZW50aW5lbDtcbiAgICAgICAgfVxuICAgICAgfVxuICAgIH0sXG5cbiAgICBcImNhdGNoXCI6IGZ1bmN0aW9uKHRyeUxvYykge1xuICAgICAgZm9yICh2YXIgaSA9IHRoaXMudHJ5RW50cmllcy5sZW5ndGggLSAxOyBpID49IDA7IC0taSkge1xuICAgICAgICB2YXIgZW50cnkgPSB0aGlzLnRyeUVudHJpZXNbaV07XG4gICAgICAgIGlmIChlbnRyeS50cnlMb2MgPT09IHRyeUxvYykge1xuICAgICAgICAgIHZhciByZWNvcmQgPSBlbnRyeS5jb21wbGV0aW9uO1xuICAgICAgICAgIGlmIChyZWNvcmQudHlwZSA9PT0gXCJ0aHJvd1wiKSB7XG4gICAgICAgICAgICB2YXIgdGhyb3duID0gcmVjb3JkLmFyZztcbiAgICAgICAgICAgIHJlc2V0VHJ5RW50cnkoZW50cnkpO1xuICAgICAgICAgIH1cbiAgICAgICAgICByZXR1cm4gdGhyb3duO1xuICAgICAgICB9XG4gICAgICB9XG5cbiAgICAgIC8vIFRoZSBjb250ZXh0LmNhdGNoIG1ldGhvZCBtdXN0IG9ubHkgYmUgY2FsbGVkIHdpdGggYSBsb2NhdGlvblxuICAgICAgLy8gYXJndW1lbnQgdGhhdCBjb3JyZXNwb25kcyB0byBhIGtub3duIGNhdGNoIGJsb2NrLlxuICAgICAgdGhyb3cgbmV3IEVycm9yKFwiaWxsZWdhbCBjYXRjaCBhdHRlbXB0XCIpO1xuICAgIH0sXG5cbiAgICBkZWxlZ2F0ZVlpZWxkOiBmdW5jdGlvbihpdGVyYWJsZSwgcmVzdWx0TmFtZSwgbmV4dExvYykge1xuICAgICAgdGhpcy5kZWxlZ2F0ZSA9IHtcbiAgICAgICAgaXRlcmF0b3I6IHZhbHVlcyhpdGVyYWJsZSksXG4gICAgICAgIHJlc3VsdE5hbWU6IHJlc3VsdE5hbWUsXG4gICAgICAgIG5leHRMb2M6IG5leHRMb2NcbiAgICAgIH07XG5cbiAgICAgIGlmICh0aGlzLm1ldGhvZCA9PT0gXCJuZXh0XCIpIHtcbiAgICAgICAgLy8gRGVsaWJlcmF0ZWx5IGZvcmdldCB0aGUgbGFzdCBzZW50IHZhbHVlIHNvIHRoYXQgd2UgZG9uJ3RcbiAgICAgICAgLy8gYWNjaWRlbnRhbGx5IHBhc3MgaXQgb24gdG8gdGhlIGRlbGVnYXRlLlxuICAgICAgICB0aGlzLmFyZyA9IHVuZGVmaW5lZDtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIENvbnRpbnVlU2VudGluZWw7XG4gICAgfVxuICB9O1xuXG4gIC8vIFJlZ2FyZGxlc3Mgb2Ygd2hldGhlciB0aGlzIHNjcmlwdCBpcyBleGVjdXRpbmcgYXMgYSBDb21tb25KUyBtb2R1bGVcbiAgLy8gb3Igbm90LCByZXR1cm4gdGhlIHJ1bnRpbWUgb2JqZWN0IHNvIHRoYXQgd2UgY2FuIGRlY2xhcmUgdGhlIHZhcmlhYmxlXG4gIC8vIHJlZ2VuZXJhdG9yUnVudGltZSBpbiB0aGUgb3V0ZXIgc2NvcGUsIHdoaWNoIGFsbG93cyB0aGlzIG1vZHVsZSB0byBiZVxuICAvLyBpbmplY3RlZCBlYXNpbHkgYnkgYGJpbi9yZWdlbmVyYXRvciAtLWluY2x1ZGUtcnVudGltZSBzY3JpcHQuanNgLlxuICByZXR1cm4gZXhwb3J0cztcblxufShcbiAgLy8gSWYgdGhpcyBzY3JpcHQgaXMgZXhlY3V0aW5nIGFzIGEgQ29tbW9uSlMgbW9kdWxlLCB1c2UgbW9kdWxlLmV4cG9ydHNcbiAgLy8gYXMgdGhlIHJlZ2VuZXJhdG9yUnVudGltZSBuYW1lc3BhY2UuIE90aGVyd2lzZSBjcmVhdGUgYSBuZXcgZW1wdHlcbiAgLy8gb2JqZWN0LiBFaXRoZXIgd2F5LCB0aGUgcmVzdWx0aW5nIG9iamVjdCB3aWxsIGJlIHVzZWQgdG8gaW5pdGlhbGl6ZVxuICAvLyB0aGUgcmVnZW5lcmF0b3JSdW50aW1lIHZhcmlhYmxlIGF0IHRoZSB0b3Agb2YgdGhpcyBmaWxlLlxuICB0eXBlb2YgbW9kdWxlID09PSBcIm9iamVjdFwiID8gbW9kdWxlLmV4cG9ydHMgOiB7fVxuKSk7XG5cbnRyeSB7XG4gIHJlZ2VuZXJhdG9yUnVudGltZSA9IHJ1bnRpbWU7XG59IGNhdGNoIChhY2NpZGVudGFsU3RyaWN0TW9kZSkge1xuICAvLyBUaGlzIG1vZHVsZSBzaG91bGQgbm90IGJlIHJ1bm5pbmcgaW4gc3RyaWN0IG1vZGUsIHNvIHRoZSBhYm92ZVxuICAvLyBhc3NpZ25tZW50IHNob3VsZCBhbHdheXMgd29yayB1bmxlc3Mgc29tZXRoaW5nIGlzIG1pc2NvbmZpZ3VyZWQuIEp1c3RcbiAgLy8gaW4gY2FzZSBydW50aW1lLmpzIGFjY2lkZW50YWxseSBydW5zIGluIHN0cmljdCBtb2RlLCB3ZSBjYW4gZXNjYXBlXG4gIC8vIHN0cmljdCBtb2RlIHVzaW5nIGEgZ2xvYmFsIEZ1bmN0aW9uIGNhbGwuIFRoaXMgY291bGQgY29uY2VpdmFibHkgZmFpbFxuICAvLyBpZiBhIENvbnRlbnQgU2VjdXJpdHkgUG9saWN5IGZvcmJpZHMgdXNpbmcgRnVuY3Rpb24sIGJ1dCBpbiB0aGF0IGNhc2VcbiAgLy8gdGhlIHByb3BlciBzb2x1dGlvbiBpcyB0byBmaXggdGhlIGFjY2lkZW50YWwgc3RyaWN0IG1vZGUgcHJvYmxlbS4gSWZcbiAgLy8geW91J3ZlIG1pc2NvbmZpZ3VyZWQgeW91ciBidW5kbGVyIHRvIGZvcmNlIHN0cmljdCBtb2RlIGFuZCBhcHBsaWVkIGFcbiAgLy8gQ1NQIHRvIGZvcmJpZCBGdW5jdGlvbiwgYW5kIHlvdSdyZSBub3Qgd2lsbGluZyB0byBmaXggZWl0aGVyIG9mIHRob3NlXG4gIC8vIHByb2JsZW1zLCBwbGVhc2UgZGV0YWlsIHlvdXIgdW5pcXVlIHByZWRpY2FtZW50IGluIGEgR2l0SHViIGlzc3VlLlxuICBGdW5jdGlvbihcInJcIiwgXCJyZWdlbmVyYXRvclJ1bnRpbWUgPSByXCIpKHJ1bnRpbWUpO1xufVxuIiwiXCJ1c2Ugc3RyaWN0XCI7XG5PYmplY3QuZGVmaW5lUHJvcGVydHkoZXhwb3J0cywgXCJfX2VzTW9kdWxlXCIsIHsgdmFsdWU6IHRydWUgfSk7XG5cbmV4cG9ydHMuYnJvd3NlciA9IHJlcXVpcmUoXCJ3ZWJleHRlbnNpb24tcG9seWZpbGxcIik7XG4iLCIoZnVuY3Rpb24gKGdsb2JhbCwgZmFjdG9yeSkge1xuICBpZiAodHlwZW9mIGRlZmluZSA9PT0gXCJmdW5jdGlvblwiICYmIGRlZmluZS5hbWQpIHtcbiAgICBkZWZpbmUoXCJ3ZWJleHRlbnNpb24tcG9seWZpbGxcIiwgW1wibW9kdWxlXCJdLCBmYWN0b3J5KTtcbiAgfSBlbHNlIGlmICh0eXBlb2YgZXhwb3J0cyAhPT0gXCJ1bmRlZmluZWRcIikge1xuICAgIGZhY3RvcnkobW9kdWxlKTtcbiAgfSBlbHNlIHtcbiAgICB2YXIgbW9kID0ge1xuICAgICAgZXhwb3J0czoge31cbiAgICB9O1xuICAgIGZhY3RvcnkobW9kKTtcbiAgICBnbG9iYWwuYnJvd3NlciA9IG1vZC5leHBvcnRzO1xuICB9XG59KSh0eXBlb2YgZ2xvYmFsVGhpcyAhPT0gXCJ1bmRlZmluZWRcIiA/IGdsb2JhbFRoaXMgOiB0eXBlb2Ygc2VsZiAhPT0gXCJ1bmRlZmluZWRcIiA/IHNlbGYgOiB0aGlzLCBmdW5jdGlvbiAobW9kdWxlKSB7XG4gIC8qIHdlYmV4dGVuc2lvbi1wb2x5ZmlsbCAtIHYwLjcuMCAtIFR1ZSBOb3YgMTAgMjAyMCAyMDoyNDowNCAqL1xuXG4gIC8qIC0qLSBNb2RlOiBpbmRlbnQtdGFicy1tb2RlOiBuaWw7IGpzLWluZGVudC1sZXZlbDogMiAtKi0gKi9cblxuICAvKiB2aW06IHNldCBzdHM9MiBzdz0yIGV0IHR3PTgwOiAqL1xuXG4gIC8qIFRoaXMgU291cmNlIENvZGUgRm9ybSBpcyBzdWJqZWN0IHRvIHRoZSB0ZXJtcyBvZiB0aGUgTW96aWxsYSBQdWJsaWNcbiAgICogTGljZW5zZSwgdi4gMi4wLiBJZiBhIGNvcHkgb2YgdGhlIE1QTCB3YXMgbm90IGRpc3RyaWJ1dGVkIHdpdGggdGhpc1xuICAgKiBmaWxlLCBZb3UgY2FuIG9idGFpbiBvbmUgYXQgaHR0cDovL21vemlsbGEub3JnL01QTC8yLjAvLiAqL1xuICBcInVzZSBzdHJpY3RcIjtcblxuICBpZiAodHlwZW9mIGJyb3dzZXIgPT09IFwidW5kZWZpbmVkXCIgfHwgT2JqZWN0LmdldFByb3RvdHlwZU9mKGJyb3dzZXIpICE9PSBPYmplY3QucHJvdG90eXBlKSB7XG4gICAgY29uc3QgQ0hST01FX1NFTkRfTUVTU0FHRV9DQUxMQkFDS19OT19SRVNQT05TRV9NRVNTQUdFID0gXCJUaGUgbWVzc2FnZSBwb3J0IGNsb3NlZCBiZWZvcmUgYSByZXNwb25zZSB3YXMgcmVjZWl2ZWQuXCI7XG4gICAgY29uc3QgU0VORF9SRVNQT05TRV9ERVBSRUNBVElPTl9XQVJOSU5HID0gXCJSZXR1cm5pbmcgYSBQcm9taXNlIGlzIHRoZSBwcmVmZXJyZWQgd2F5IHRvIHNlbmQgYSByZXBseSBmcm9tIGFuIG9uTWVzc2FnZS9vbk1lc3NhZ2VFeHRlcm5hbCBsaXN0ZW5lciwgYXMgdGhlIHNlbmRSZXNwb25zZSB3aWxsIGJlIHJlbW92ZWQgZnJvbSB0aGUgc3BlY3MgKFNlZSBodHRwczovL2RldmVsb3Blci5tb3ppbGxhLm9yZy9kb2NzL01vemlsbGEvQWRkLW9ucy9XZWJFeHRlbnNpb25zL0FQSS9ydW50aW1lL29uTWVzc2FnZSlcIjsgLy8gV3JhcHBpbmcgdGhlIGJ1bGsgb2YgdGhpcyBwb2x5ZmlsbCBpbiBhIG9uZS10aW1lLXVzZSBmdW5jdGlvbiBpcyBhIG1pbm9yXG4gICAgLy8gb3B0aW1pemF0aW9uIGZvciBGaXJlZm94LiBTaW5jZSBTcGlkZXJtb25rZXkgZG9lcyBub3QgZnVsbHkgcGFyc2UgdGhlXG4gICAgLy8gY29udGVudHMgb2YgYSBmdW5jdGlvbiB1bnRpbCB0aGUgZmlyc3QgdGltZSBpdCdzIGNhbGxlZCwgYW5kIHNpbmNlIGl0IHdpbGxcbiAgICAvLyBuZXZlciBhY3R1YWxseSBuZWVkIHRvIGJlIGNhbGxlZCwgdGhpcyBhbGxvd3MgdGhlIHBvbHlmaWxsIHRvIGJlIGluY2x1ZGVkXG4gICAgLy8gaW4gRmlyZWZveCBuZWFybHkgZm9yIGZyZWUuXG5cbiAgICBjb25zdCB3cmFwQVBJcyA9IGV4dGVuc2lvbkFQSXMgPT4ge1xuICAgICAgLy8gTk9URTogYXBpTWV0YWRhdGEgaXMgYXNzb2NpYXRlZCB0byB0aGUgY29udGVudCBvZiB0aGUgYXBpLW1ldGFkYXRhLmpzb24gZmlsZVxuICAgICAgLy8gYXQgYnVpbGQgdGltZSBieSByZXBsYWNpbmcgdGhlIGZvbGxvd2luZyBcImluY2x1ZGVcIiB3aXRoIHRoZSBjb250ZW50IG9mIHRoZVxuICAgICAgLy8gSlNPTiBmaWxlLlxuICAgICAgY29uc3QgYXBpTWV0YWRhdGEgPSB7XG4gICAgICAgIFwiYWxhcm1zXCI6IHtcbiAgICAgICAgICBcImNsZWFyXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiY2xlYXJBbGxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRBbGxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJib29rbWFya3NcIjoge1xuICAgICAgICAgIFwiY3JlYXRlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0Q2hpbGRyZW5cIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRSZWNlbnRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRTdWJUcmVlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0VHJlZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcIm1vdmVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDIsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZW1vdmVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZW1vdmVUcmVlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2VhcmNoXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwidXBkYXRlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAyLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDJcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwiYnJvd3NlckFjdGlvblwiOiB7XG4gICAgICAgICAgXCJkaXNhYmxlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDEsXG4gICAgICAgICAgICBcImZhbGxiYWNrVG9Ob0NhbGxiYWNrXCI6IHRydWVcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZW5hYmxlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDEsXG4gICAgICAgICAgICBcImZhbGxiYWNrVG9Ob0NhbGxiYWNrXCI6IHRydWVcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0QmFkZ2VCYWNrZ3JvdW5kQ29sb3JcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRCYWRnZVRleHRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRQb3B1cFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFRpdGxlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwib3BlblBvcHVwXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2V0QmFkZ2VCYWNrZ3JvdW5kQ29sb3JcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwiZmFsbGJhY2tUb05vQ2FsbGJhY2tcIjogdHJ1ZVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZXRCYWRnZVRleHRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwiZmFsbGJhY2tUb05vQ2FsbGJhY2tcIjogdHJ1ZVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZXRJY29uXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2V0UG9wdXBcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwiZmFsbGJhY2tUb05vQ2FsbGJhY2tcIjogdHJ1ZVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZXRUaXRsZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJmYWxsYmFja1RvTm9DYWxsYmFja1wiOiB0cnVlXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcImJyb3dzaW5nRGF0YVwiOiB7XG4gICAgICAgICAgXCJyZW1vdmVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDIsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZW1vdmVDYWNoZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZUNvb2tpZXNcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZW1vdmVEb3dubG9hZHNcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZW1vdmVGb3JtRGF0YVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZUhpc3RvcnlcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZW1vdmVMb2NhbFN0b3JhZ2VcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZW1vdmVQYXNzd29yZHNcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZW1vdmVQbHVnaW5EYXRhXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2V0dGluZ3NcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJjb21tYW5kc1wiOiB7XG4gICAgICAgICAgXCJnZXRBbGxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJjb250ZXh0TWVudXNcIjoge1xuICAgICAgICAgIFwicmVtb3ZlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicmVtb3ZlQWxsXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwidXBkYXRlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAyLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDJcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwiY29va2llc1wiOiB7XG4gICAgICAgICAgXCJnZXRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRBbGxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRBbGxDb29raWVTdG9yZXNcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZW1vdmVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZXRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJkZXZ0b29sc1wiOiB7XG4gICAgICAgICAgXCJpbnNwZWN0ZWRXaW5kb3dcIjoge1xuICAgICAgICAgICAgXCJldmFsXCI6IHtcbiAgICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICAgIFwibWF4QXJnc1wiOiAyLFxuICAgICAgICAgICAgICBcInNpbmdsZUNhbGxiYWNrQXJnXCI6IGZhbHNlXG4gICAgICAgICAgICB9XG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInBhbmVsc1wiOiB7XG4gICAgICAgICAgICBcImNyZWF0ZVwiOiB7XG4gICAgICAgICAgICAgIFwibWluQXJnc1wiOiAzLFxuICAgICAgICAgICAgICBcIm1heEFyZ3NcIjogMyxcbiAgICAgICAgICAgICAgXCJzaW5nbGVDYWxsYmFja0FyZ1wiOiB0cnVlXG4gICAgICAgICAgICB9LFxuICAgICAgICAgICAgXCJlbGVtZW50c1wiOiB7XG4gICAgICAgICAgICAgIFwiY3JlYXRlU2lkZWJhclBhbmVcIjoge1xuICAgICAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwiZG93bmxvYWRzXCI6IHtcbiAgICAgICAgICBcImNhbmNlbFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImRvd25sb2FkXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZXJhc2VcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRGaWxlSWNvblwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAyXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcIm9wZW5cIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwiZmFsbGJhY2tUb05vQ2FsbGJhY2tcIjogdHJ1ZVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJwYXVzZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZUZpbGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZXN1bWVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZWFyY2hcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzaG93XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDEsXG4gICAgICAgICAgICBcImZhbGxiYWNrVG9Ob0NhbGxiYWNrXCI6IHRydWVcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwiZXh0ZW5zaW9uXCI6IHtcbiAgICAgICAgICBcImlzQWxsb3dlZEZpbGVTY2hlbWVBY2Nlc3NcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJpc0FsbG93ZWRJbmNvZ25pdG9BY2Nlc3NcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJoaXN0b3J5XCI6IHtcbiAgICAgICAgICBcImFkZFVybFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImRlbGV0ZUFsbFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImRlbGV0ZVJhbmdlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZGVsZXRlVXJsXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0VmlzaXRzXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2VhcmNoXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwiaTE4blwiOiB7XG4gICAgICAgICAgXCJkZXRlY3RMYW5ndWFnZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldEFjY2VwdExhbmd1YWdlc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcImlkZW50aXR5XCI6IHtcbiAgICAgICAgICBcImxhdW5jaFdlYkF1dGhGbG93XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwiaWRsZVwiOiB7XG4gICAgICAgICAgXCJxdWVyeVN0YXRlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwibWFuYWdlbWVudFwiOiB7XG4gICAgICAgICAgXCJnZXRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRBbGxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRTZWxmXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2V0RW5hYmxlZFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMixcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAyXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInVuaW5zdGFsbFNlbGZcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJub3RpZmljYXRpb25zXCI6IHtcbiAgICAgICAgICBcImNsZWFyXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiY3JlYXRlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDJcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0QWxsXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0UGVybWlzc2lvbkxldmVsXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwidXBkYXRlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAyLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDJcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwicGFnZUFjdGlvblwiOiB7XG4gICAgICAgICAgXCJnZXRQb3B1cFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFRpdGxlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiaGlkZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJmYWxsYmFja1RvTm9DYWxsYmFja1wiOiB0cnVlXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNldEljb25cIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZXRQb3B1cFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJmYWxsYmFja1RvTm9DYWxsYmFja1wiOiB0cnVlXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNldFRpdGxlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDEsXG4gICAgICAgICAgICBcImZhbGxiYWNrVG9Ob0NhbGxiYWNrXCI6IHRydWVcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2hvd1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJmYWxsYmFja1RvTm9DYWxsYmFja1wiOiB0cnVlXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcInBlcm1pc3Npb25zXCI6IHtcbiAgICAgICAgICBcImNvbnRhaW5zXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0QWxsXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicmVtb3ZlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicmVxdWVzdFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcInJ1bnRpbWVcIjoge1xuICAgICAgICAgIFwiZ2V0QmFja2dyb3VuZFBhZ2VcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRQbGF0Zm9ybUluZm9cIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJvcGVuT3B0aW9uc1BhZ2VcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZXF1ZXN0VXBkYXRlQ2hlY2tcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZW5kTWVzc2FnZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAzXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNlbmROYXRpdmVNZXNzYWdlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAyLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDJcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2V0VW5pbnN0YWxsVVJMXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwic2Vzc2lvbnNcIjoge1xuICAgICAgICAgIFwiZ2V0RGV2aWNlc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFJlY2VudGx5Q2xvc2VkXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicmVzdG9yZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcInN0b3JhZ2VcIjoge1xuICAgICAgICAgIFwibG9jYWxcIjoge1xuICAgICAgICAgICAgXCJjbGVhclwiOiB7XG4gICAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgICAgfSxcbiAgICAgICAgICAgIFwiZ2V0XCI6IHtcbiAgICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgICB9LFxuICAgICAgICAgICAgXCJnZXRCeXRlc0luVXNlXCI6IHtcbiAgICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgICB9LFxuICAgICAgICAgICAgXCJyZW1vdmVcIjoge1xuICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICAgIH0sXG4gICAgICAgICAgICBcInNldFwiOiB7XG4gICAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgICAgfVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJtYW5hZ2VkXCI6IHtcbiAgICAgICAgICAgIFwiZ2V0XCI6IHtcbiAgICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgICB9LFxuICAgICAgICAgICAgXCJnZXRCeXRlc0luVXNlXCI6IHtcbiAgICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgICB9XG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInN5bmNcIjoge1xuICAgICAgICAgICAgXCJjbGVhclwiOiB7XG4gICAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgICAgfSxcbiAgICAgICAgICAgIFwiZ2V0XCI6IHtcbiAgICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgICB9LFxuICAgICAgICAgICAgXCJnZXRCeXRlc0luVXNlXCI6IHtcbiAgICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgICB9LFxuICAgICAgICAgICAgXCJyZW1vdmVcIjoge1xuICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICAgIH0sXG4gICAgICAgICAgICBcInNldFwiOiB7XG4gICAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJ0YWJzXCI6IHtcbiAgICAgICAgICBcImNhcHR1cmVWaXNpYmxlVGFiXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDJcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiY3JlYXRlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZGV0ZWN0TGFuZ3VhZ2VcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJkaXNjYXJkXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZHVwbGljYXRlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZXhlY3V0ZVNjcmlwdFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAyXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldEN1cnJlbnRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRab29tXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0Wm9vbVNldHRpbmdzXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ29CYWNrXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ29Gb3J3YXJkXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiaGlnaGxpZ2h0XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiaW5zZXJ0Q1NTXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDJcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwibW92ZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMixcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAyXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInF1ZXJ5XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicmVsb2FkXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDJcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicmVtb3ZlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicmVtb3ZlQ1NTXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDJcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2VuZE1lc3NhZ2VcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDIsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogM1xuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZXRab29tXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDJcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2V0Wm9vbVNldHRpbmdzXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDJcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwidXBkYXRlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDJcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwidG9wU2l0ZXNcIjoge1xuICAgICAgICAgIFwiZ2V0XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwid2ViTmF2aWdhdGlvblwiOiB7XG4gICAgICAgICAgXCJnZXRBbGxGcmFtZXNcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRGcmFtZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcIndlYlJlcXVlc3RcIjoge1xuICAgICAgICAgIFwiaGFuZGxlckJlaGF2aW9yQ2hhbmdlZFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcIndpbmRvd3NcIjoge1xuICAgICAgICAgIFwiY3JlYXRlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDJcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0QWxsXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0Q3VycmVudFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldExhc3RGb2N1c2VkXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicmVtb3ZlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwidXBkYXRlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAyLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDJcbiAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICAgIH07XG5cbiAgICAgIGlmIChPYmplY3Qua2V5cyhhcGlNZXRhZGF0YSkubGVuZ3RoID09PSAwKSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcihcImFwaS1tZXRhZGF0YS5qc29uIGhhcyBub3QgYmVlbiBpbmNsdWRlZCBpbiBicm93c2VyLXBvbHlmaWxsXCIpO1xuICAgICAgfVxuICAgICAgLyoqXG4gICAgICAgKiBBIFdlYWtNYXAgc3ViY2xhc3Mgd2hpY2ggY3JlYXRlcyBhbmQgc3RvcmVzIGEgdmFsdWUgZm9yIGFueSBrZXkgd2hpY2ggZG9lc1xuICAgICAgICogbm90IGV4aXN0IHdoZW4gYWNjZXNzZWQsIGJ1dCBiZWhhdmVzIGV4YWN0bHkgYXMgYW4gb3JkaW5hcnkgV2Vha01hcFxuICAgICAgICogb3RoZXJ3aXNlLlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSB7ZnVuY3Rpb259IGNyZWF0ZUl0ZW1cbiAgICAgICAqICAgICAgICBBIGZ1bmN0aW9uIHdoaWNoIHdpbGwgYmUgY2FsbGVkIGluIG9yZGVyIHRvIGNyZWF0ZSB0aGUgdmFsdWUgZm9yIGFueVxuICAgICAgICogICAgICAgIGtleSB3aGljaCBkb2VzIG5vdCBleGlzdCwgdGhlIGZpcnN0IHRpbWUgaXQgaXMgYWNjZXNzZWQuIFRoZVxuICAgICAgICogICAgICAgIGZ1bmN0aW9uIHJlY2VpdmVzLCBhcyBpdHMgb25seSBhcmd1bWVudCwgdGhlIGtleSBiZWluZyBjcmVhdGVkLlxuICAgICAgICovXG5cblxuICAgICAgY2xhc3MgRGVmYXVsdFdlYWtNYXAgZXh0ZW5kcyBXZWFrTWFwIHtcbiAgICAgICAgY29uc3RydWN0b3IoY3JlYXRlSXRlbSwgaXRlbXMgPSB1bmRlZmluZWQpIHtcbiAgICAgICAgICBzdXBlcihpdGVtcyk7XG4gICAgICAgICAgdGhpcy5jcmVhdGVJdGVtID0gY3JlYXRlSXRlbTtcbiAgICAgICAgfVxuXG4gICAgICAgIGdldChrZXkpIHtcbiAgICAgICAgICBpZiAoIXRoaXMuaGFzKGtleSkpIHtcbiAgICAgICAgICAgIHRoaXMuc2V0KGtleSwgdGhpcy5jcmVhdGVJdGVtKGtleSkpO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIHJldHVybiBzdXBlci5nZXQoa2V5KTtcbiAgICAgICAgfVxuXG4gICAgICB9XG4gICAgICAvKipcbiAgICAgICAqIFJldHVybnMgdHJ1ZSBpZiB0aGUgZ2l2ZW4gb2JqZWN0IGlzIGFuIG9iamVjdCB3aXRoIGEgYHRoZW5gIG1ldGhvZCwgYW5kIGNhblxuICAgICAgICogdGhlcmVmb3JlIGJlIGFzc3VtZWQgdG8gYmVoYXZlIGFzIGEgUHJvbWlzZS5cbiAgICAgICAqXG4gICAgICAgKiBAcGFyYW0geyp9IHZhbHVlIFRoZSB2YWx1ZSB0byB0ZXN0LlxuICAgICAgICogQHJldHVybnMge2Jvb2xlYW59IFRydWUgaWYgdGhlIHZhbHVlIGlzIHRoZW5hYmxlLlxuICAgICAgICovXG5cblxuICAgICAgY29uc3QgaXNUaGVuYWJsZSA9IHZhbHVlID0+IHtcbiAgICAgICAgcmV0dXJuIHZhbHVlICYmIHR5cGVvZiB2YWx1ZSA9PT0gXCJvYmplY3RcIiAmJiB0eXBlb2YgdmFsdWUudGhlbiA9PT0gXCJmdW5jdGlvblwiO1xuICAgICAgfTtcbiAgICAgIC8qKlxuICAgICAgICogQ3JlYXRlcyBhbmQgcmV0dXJucyBhIGZ1bmN0aW9uIHdoaWNoLCB3aGVuIGNhbGxlZCwgd2lsbCByZXNvbHZlIG9yIHJlamVjdFxuICAgICAgICogdGhlIGdpdmVuIHByb21pc2UgYmFzZWQgb24gaG93IGl0IGlzIGNhbGxlZDpcbiAgICAgICAqXG4gICAgICAgKiAtIElmLCB3aGVuIGNhbGxlZCwgYGNocm9tZS5ydW50aW1lLmxhc3RFcnJvcmAgY29udGFpbnMgYSBub24tbnVsbCBvYmplY3QsXG4gICAgICAgKiAgIHRoZSBwcm9taXNlIGlzIHJlamVjdGVkIHdpdGggdGhhdCB2YWx1ZS5cbiAgICAgICAqIC0gSWYgdGhlIGZ1bmN0aW9uIGlzIGNhbGxlZCB3aXRoIGV4YWN0bHkgb25lIGFyZ3VtZW50LCB0aGUgcHJvbWlzZSBpc1xuICAgICAgICogICByZXNvbHZlZCB0byB0aGF0IHZhbHVlLlxuICAgICAgICogLSBPdGhlcndpc2UsIHRoZSBwcm9taXNlIGlzIHJlc29sdmVkIHRvIGFuIGFycmF5IGNvbnRhaW5pbmcgYWxsIG9mIHRoZVxuICAgICAgICogICBmdW5jdGlvbidzIGFyZ3VtZW50cy5cbiAgICAgICAqXG4gICAgICAgKiBAcGFyYW0ge29iamVjdH0gcHJvbWlzZVxuICAgICAgICogICAgICAgIEFuIG9iamVjdCBjb250YWluaW5nIHRoZSByZXNvbHV0aW9uIGFuZCByZWplY3Rpb24gZnVuY3Rpb25zIG9mIGFcbiAgICAgICAqICAgICAgICBwcm9taXNlLlxuICAgICAgICogQHBhcmFtIHtmdW5jdGlvbn0gcHJvbWlzZS5yZXNvbHZlXG4gICAgICAgKiAgICAgICAgVGhlIHByb21pc2UncyByZXNvbHV0aW9uIGZ1bmN0aW9uLlxuICAgICAgICogQHBhcmFtIHtmdW5jdGlvbn0gcHJvbWlzZS5yZWplY3Rpb25cbiAgICAgICAqICAgICAgICBUaGUgcHJvbWlzZSdzIHJlamVjdGlvbiBmdW5jdGlvbi5cbiAgICAgICAqIEBwYXJhbSB7b2JqZWN0fSBtZXRhZGF0YVxuICAgICAgICogICAgICAgIE1ldGFkYXRhIGFib3V0IHRoZSB3cmFwcGVkIG1ldGhvZCB3aGljaCBoYXMgY3JlYXRlZCB0aGUgY2FsbGJhY2suXG4gICAgICAgKiBAcGFyYW0ge2ludGVnZXJ9IG1ldGFkYXRhLm1heFJlc29sdmVkQXJnc1xuICAgICAgICogICAgICAgIFRoZSBtYXhpbXVtIG51bWJlciBvZiBhcmd1bWVudHMgd2hpY2ggbWF5IGJlIHBhc3NlZCB0byB0aGVcbiAgICAgICAqICAgICAgICBjYWxsYmFjayBjcmVhdGVkIGJ5IHRoZSB3cmFwcGVkIGFzeW5jIGZ1bmN0aW9uLlxuICAgICAgICpcbiAgICAgICAqIEByZXR1cm5zIHtmdW5jdGlvbn1cbiAgICAgICAqICAgICAgICBUaGUgZ2VuZXJhdGVkIGNhbGxiYWNrIGZ1bmN0aW9uLlxuICAgICAgICovXG5cblxuICAgICAgY29uc3QgbWFrZUNhbGxiYWNrID0gKHByb21pc2UsIG1ldGFkYXRhKSA9PiB7XG4gICAgICAgIHJldHVybiAoLi4uY2FsbGJhY2tBcmdzKSA9PiB7XG4gICAgICAgICAgaWYgKGV4dGVuc2lvbkFQSXMucnVudGltZS5sYXN0RXJyb3IpIHtcbiAgICAgICAgICAgIHByb21pc2UucmVqZWN0KGV4dGVuc2lvbkFQSXMucnVudGltZS5sYXN0RXJyb3IpO1xuICAgICAgICAgIH0gZWxzZSBpZiAobWV0YWRhdGEuc2luZ2xlQ2FsbGJhY2tBcmcgfHwgY2FsbGJhY2tBcmdzLmxlbmd0aCA8PSAxICYmIG1ldGFkYXRhLnNpbmdsZUNhbGxiYWNrQXJnICE9PSBmYWxzZSkge1xuICAgICAgICAgICAgcHJvbWlzZS5yZXNvbHZlKGNhbGxiYWNrQXJnc1swXSk7XG4gICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIHByb21pc2UucmVzb2x2ZShjYWxsYmFja0FyZ3MpO1xuICAgICAgICAgIH1cbiAgICAgICAgfTtcbiAgICAgIH07XG5cbiAgICAgIGNvbnN0IHBsdXJhbGl6ZUFyZ3VtZW50cyA9IG51bUFyZ3MgPT4gbnVtQXJncyA9PSAxID8gXCJhcmd1bWVudFwiIDogXCJhcmd1bWVudHNcIjtcbiAgICAgIC8qKlxuICAgICAgICogQ3JlYXRlcyBhIHdyYXBwZXIgZnVuY3Rpb24gZm9yIGEgbWV0aG9kIHdpdGggdGhlIGdpdmVuIG5hbWUgYW5kIG1ldGFkYXRhLlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSB7c3RyaW5nfSBuYW1lXG4gICAgICAgKiAgICAgICAgVGhlIG5hbWUgb2YgdGhlIG1ldGhvZCB3aGljaCBpcyBiZWluZyB3cmFwcGVkLlxuICAgICAgICogQHBhcmFtIHtvYmplY3R9IG1ldGFkYXRhXG4gICAgICAgKiAgICAgICAgTWV0YWRhdGEgYWJvdXQgdGhlIG1ldGhvZCBiZWluZyB3cmFwcGVkLlxuICAgICAgICogQHBhcmFtIHtpbnRlZ2VyfSBtZXRhZGF0YS5taW5BcmdzXG4gICAgICAgKiAgICAgICAgVGhlIG1pbmltdW0gbnVtYmVyIG9mIGFyZ3VtZW50cyB3aGljaCBtdXN0IGJlIHBhc3NlZCB0byB0aGVcbiAgICAgICAqICAgICAgICBmdW5jdGlvbi4gSWYgY2FsbGVkIHdpdGggZmV3ZXIgdGhhbiB0aGlzIG51bWJlciBvZiBhcmd1bWVudHMsIHRoZVxuICAgICAgICogICAgICAgIHdyYXBwZXIgd2lsbCByYWlzZSBhbiBleGNlcHRpb24uXG4gICAgICAgKiBAcGFyYW0ge2ludGVnZXJ9IG1ldGFkYXRhLm1heEFyZ3NcbiAgICAgICAqICAgICAgICBUaGUgbWF4aW11bSBudW1iZXIgb2YgYXJndW1lbnRzIHdoaWNoIG1heSBiZSBwYXNzZWQgdG8gdGhlXG4gICAgICAgKiAgICAgICAgZnVuY3Rpb24uIElmIGNhbGxlZCB3aXRoIG1vcmUgdGhhbiB0aGlzIG51bWJlciBvZiBhcmd1bWVudHMsIHRoZVxuICAgICAgICogICAgICAgIHdyYXBwZXIgd2lsbCByYWlzZSBhbiBleGNlcHRpb24uXG4gICAgICAgKiBAcGFyYW0ge2ludGVnZXJ9IG1ldGFkYXRhLm1heFJlc29sdmVkQXJnc1xuICAgICAgICogICAgICAgIFRoZSBtYXhpbXVtIG51bWJlciBvZiBhcmd1bWVudHMgd2hpY2ggbWF5IGJlIHBhc3NlZCB0byB0aGVcbiAgICAgICAqICAgICAgICBjYWxsYmFjayBjcmVhdGVkIGJ5IHRoZSB3cmFwcGVkIGFzeW5jIGZ1bmN0aW9uLlxuICAgICAgICpcbiAgICAgICAqIEByZXR1cm5zIHtmdW5jdGlvbihvYmplY3QsIC4uLiopfVxuICAgICAgICogICAgICAgVGhlIGdlbmVyYXRlZCB3cmFwcGVyIGZ1bmN0aW9uLlxuICAgICAgICovXG5cblxuICAgICAgY29uc3Qgd3JhcEFzeW5jRnVuY3Rpb24gPSAobmFtZSwgbWV0YWRhdGEpID0+IHtcbiAgICAgICAgcmV0dXJuIGZ1bmN0aW9uIGFzeW5jRnVuY3Rpb25XcmFwcGVyKHRhcmdldCwgLi4uYXJncykge1xuICAgICAgICAgIGlmIChhcmdzLmxlbmd0aCA8IG1ldGFkYXRhLm1pbkFyZ3MpIHtcbiAgICAgICAgICAgIHRocm93IG5ldyBFcnJvcihgRXhwZWN0ZWQgYXQgbGVhc3QgJHttZXRhZGF0YS5taW5BcmdzfSAke3BsdXJhbGl6ZUFyZ3VtZW50cyhtZXRhZGF0YS5taW5BcmdzKX0gZm9yICR7bmFtZX0oKSwgZ290ICR7YXJncy5sZW5ndGh9YCk7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgaWYgKGFyZ3MubGVuZ3RoID4gbWV0YWRhdGEubWF4QXJncykge1xuICAgICAgICAgICAgdGhyb3cgbmV3IEVycm9yKGBFeHBlY3RlZCBhdCBtb3N0ICR7bWV0YWRhdGEubWF4QXJnc30gJHtwbHVyYWxpemVBcmd1bWVudHMobWV0YWRhdGEubWF4QXJncyl9IGZvciAke25hbWV9KCksIGdvdCAke2FyZ3MubGVuZ3RofWApO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIHJldHVybiBuZXcgUHJvbWlzZSgocmVzb2x2ZSwgcmVqZWN0KSA9PiB7XG4gICAgICAgICAgICBpZiAobWV0YWRhdGEuZmFsbGJhY2tUb05vQ2FsbGJhY2spIHtcbiAgICAgICAgICAgICAgLy8gVGhpcyBBUEkgbWV0aG9kIGhhcyBjdXJyZW50bHkgbm8gY2FsbGJhY2sgb24gQ2hyb21lLCBidXQgaXQgcmV0dXJuIGEgcHJvbWlzZSBvbiBGaXJlZm94LFxuICAgICAgICAgICAgICAvLyBhbmQgc28gdGhlIHBvbHlmaWxsIHdpbGwgdHJ5IHRvIGNhbGwgaXQgd2l0aCBhIGNhbGxiYWNrIGZpcnN0LCBhbmQgaXQgd2lsbCBmYWxsYmFja1xuICAgICAgICAgICAgICAvLyB0byBub3QgcGFzc2luZyB0aGUgY2FsbGJhY2sgaWYgdGhlIGZpcnN0IGNhbGwgZmFpbHMuXG4gICAgICAgICAgICAgIHRyeSB7XG4gICAgICAgICAgICAgICAgdGFyZ2V0W25hbWVdKC4uLmFyZ3MsIG1ha2VDYWxsYmFjayh7XG4gICAgICAgICAgICAgICAgICByZXNvbHZlLFxuICAgICAgICAgICAgICAgICAgcmVqZWN0XG4gICAgICAgICAgICAgICAgfSwgbWV0YWRhdGEpKTtcbiAgICAgICAgICAgICAgfSBjYXRjaCAoY2JFcnJvcikge1xuICAgICAgICAgICAgICAgIGNvbnNvbGUud2FybihgJHtuYW1lfSBBUEkgbWV0aG9kIGRvZXNuJ3Qgc2VlbSB0byBzdXBwb3J0IHRoZSBjYWxsYmFjayBwYXJhbWV0ZXIsIGAgKyBcImZhbGxpbmcgYmFjayB0byBjYWxsIGl0IHdpdGhvdXQgYSBjYWxsYmFjazogXCIsIGNiRXJyb3IpO1xuICAgICAgICAgICAgICAgIHRhcmdldFtuYW1lXSguLi5hcmdzKTsgLy8gVXBkYXRlIHRoZSBBUEkgbWV0aG9kIG1ldGFkYXRhLCBzbyB0aGF0IHRoZSBuZXh0IEFQSSBjYWxscyB3aWxsIG5vdCB0cnkgdG9cbiAgICAgICAgICAgICAgICAvLyB1c2UgdGhlIHVuc3VwcG9ydGVkIGNhbGxiYWNrIGFueW1vcmUuXG5cbiAgICAgICAgICAgICAgICBtZXRhZGF0YS5mYWxsYmFja1RvTm9DYWxsYmFjayA9IGZhbHNlO1xuICAgICAgICAgICAgICAgIG1ldGFkYXRhLm5vQ2FsbGJhY2sgPSB0cnVlO1xuICAgICAgICAgICAgICAgIHJlc29sdmUoKTtcbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfSBlbHNlIGlmIChtZXRhZGF0YS5ub0NhbGxiYWNrKSB7XG4gICAgICAgICAgICAgIHRhcmdldFtuYW1lXSguLi5hcmdzKTtcbiAgICAgICAgICAgICAgcmVzb2x2ZSgpO1xuICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgdGFyZ2V0W25hbWVdKC4uLmFyZ3MsIG1ha2VDYWxsYmFjayh7XG4gICAgICAgICAgICAgICAgcmVzb2x2ZSxcbiAgICAgICAgICAgICAgICByZWplY3RcbiAgICAgICAgICAgICAgfSwgbWV0YWRhdGEpKTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9KTtcbiAgICAgICAgfTtcbiAgICAgIH07XG4gICAgICAvKipcbiAgICAgICAqIFdyYXBzIGFuIGV4aXN0aW5nIG1ldGhvZCBvZiB0aGUgdGFyZ2V0IG9iamVjdCwgc28gdGhhdCBjYWxscyB0byBpdCBhcmVcbiAgICAgICAqIGludGVyY2VwdGVkIGJ5IHRoZSBnaXZlbiB3cmFwcGVyIGZ1bmN0aW9uLiBUaGUgd3JhcHBlciBmdW5jdGlvbiByZWNlaXZlcyxcbiAgICAgICAqIGFzIGl0cyBmaXJzdCBhcmd1bWVudCwgdGhlIG9yaWdpbmFsIGB0YXJnZXRgIG9iamVjdCwgZm9sbG93ZWQgYnkgZWFjaCBvZlxuICAgICAgICogdGhlIGFyZ3VtZW50cyBwYXNzZWQgdG8gdGhlIG9yaWdpbmFsIG1ldGhvZC5cbiAgICAgICAqXG4gICAgICAgKiBAcGFyYW0ge29iamVjdH0gdGFyZ2V0XG4gICAgICAgKiAgICAgICAgVGhlIG9yaWdpbmFsIHRhcmdldCBvYmplY3QgdGhhdCB0aGUgd3JhcHBlZCBtZXRob2QgYmVsb25ncyB0by5cbiAgICAgICAqIEBwYXJhbSB7ZnVuY3Rpb259IG1ldGhvZFxuICAgICAgICogICAgICAgIFRoZSBtZXRob2QgYmVpbmcgd3JhcHBlZC4gVGhpcyBpcyB1c2VkIGFzIHRoZSB0YXJnZXQgb2YgdGhlIFByb3h5XG4gICAgICAgKiAgICAgICAgb2JqZWN0IHdoaWNoIGlzIGNyZWF0ZWQgdG8gd3JhcCB0aGUgbWV0aG9kLlxuICAgICAgICogQHBhcmFtIHtmdW5jdGlvbn0gd3JhcHBlclxuICAgICAgICogICAgICAgIFRoZSB3cmFwcGVyIGZ1bmN0aW9uIHdoaWNoIGlzIGNhbGxlZCBpbiBwbGFjZSBvZiBhIGRpcmVjdCBpbnZvY2F0aW9uXG4gICAgICAgKiAgICAgICAgb2YgdGhlIHdyYXBwZWQgbWV0aG9kLlxuICAgICAgICpcbiAgICAgICAqIEByZXR1cm5zIHtQcm94eTxmdW5jdGlvbj59XG4gICAgICAgKiAgICAgICAgQSBQcm94eSBvYmplY3QgZm9yIHRoZSBnaXZlbiBtZXRob2QsIHdoaWNoIGludm9rZXMgdGhlIGdpdmVuIHdyYXBwZXJcbiAgICAgICAqICAgICAgICBtZXRob2QgaW4gaXRzIHBsYWNlLlxuICAgICAgICovXG5cblxuICAgICAgY29uc3Qgd3JhcE1ldGhvZCA9ICh0YXJnZXQsIG1ldGhvZCwgd3JhcHBlcikgPT4ge1xuICAgICAgICByZXR1cm4gbmV3IFByb3h5KG1ldGhvZCwge1xuICAgICAgICAgIGFwcGx5KHRhcmdldE1ldGhvZCwgdGhpc09iaiwgYXJncykge1xuICAgICAgICAgICAgcmV0dXJuIHdyYXBwZXIuY2FsbCh0aGlzT2JqLCB0YXJnZXQsIC4uLmFyZ3MpO1xuICAgICAgICAgIH1cblxuICAgICAgICB9KTtcbiAgICAgIH07XG5cbiAgICAgIGxldCBoYXNPd25Qcm9wZXJ0eSA9IEZ1bmN0aW9uLmNhbGwuYmluZChPYmplY3QucHJvdG90eXBlLmhhc093blByb3BlcnR5KTtcbiAgICAgIC8qKlxuICAgICAgICogV3JhcHMgYW4gb2JqZWN0IGluIGEgUHJveHkgd2hpY2ggaW50ZXJjZXB0cyBhbmQgd3JhcHMgY2VydGFpbiBtZXRob2RzXG4gICAgICAgKiBiYXNlZCBvbiB0aGUgZ2l2ZW4gYHdyYXBwZXJzYCBhbmQgYG1ldGFkYXRhYCBvYmplY3RzLlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSB7b2JqZWN0fSB0YXJnZXRcbiAgICAgICAqICAgICAgICBUaGUgdGFyZ2V0IG9iamVjdCB0byB3cmFwLlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSB7b2JqZWN0fSBbd3JhcHBlcnMgPSB7fV1cbiAgICAgICAqICAgICAgICBBbiBvYmplY3QgdHJlZSBjb250YWluaW5nIHdyYXBwZXIgZnVuY3Rpb25zIGZvciBzcGVjaWFsIGNhc2VzLiBBbnlcbiAgICAgICAqICAgICAgICBmdW5jdGlvbiBwcmVzZW50IGluIHRoaXMgb2JqZWN0IHRyZWUgaXMgY2FsbGVkIGluIHBsYWNlIG9mIHRoZVxuICAgICAgICogICAgICAgIG1ldGhvZCBpbiB0aGUgc2FtZSBsb2NhdGlvbiBpbiB0aGUgYHRhcmdldGAgb2JqZWN0IHRyZWUuIFRoZXNlXG4gICAgICAgKiAgICAgICAgd3JhcHBlciBtZXRob2RzIGFyZSBpbnZva2VkIGFzIGRlc2NyaWJlZCBpbiB7QHNlZSB3cmFwTWV0aG9kfS5cbiAgICAgICAqXG4gICAgICAgKiBAcGFyYW0ge29iamVjdH0gW21ldGFkYXRhID0ge31dXG4gICAgICAgKiAgICAgICAgQW4gb2JqZWN0IHRyZWUgY29udGFpbmluZyBtZXRhZGF0YSB1c2VkIHRvIGF1dG9tYXRpY2FsbHkgZ2VuZXJhdGVcbiAgICAgICAqICAgICAgICBQcm9taXNlLWJhc2VkIHdyYXBwZXIgZnVuY3Rpb25zIGZvciBhc3luY2hyb25vdXMuIEFueSBmdW5jdGlvbiBpblxuICAgICAgICogICAgICAgIHRoZSBgdGFyZ2V0YCBvYmplY3QgdHJlZSB3aGljaCBoYXMgYSBjb3JyZXNwb25kaW5nIG1ldGFkYXRhIG9iamVjdFxuICAgICAgICogICAgICAgIGluIHRoZSBzYW1lIGxvY2F0aW9uIGluIHRoZSBgbWV0YWRhdGFgIHRyZWUgaXMgcmVwbGFjZWQgd2l0aCBhblxuICAgICAgICogICAgICAgIGF1dG9tYXRpY2FsbHktZ2VuZXJhdGVkIHdyYXBwZXIgZnVuY3Rpb24sIGFzIGRlc2NyaWJlZCBpblxuICAgICAgICogICAgICAgIHtAc2VlIHdyYXBBc3luY0Z1bmN0aW9ufVxuICAgICAgICpcbiAgICAgICAqIEByZXR1cm5zIHtQcm94eTxvYmplY3Q+fVxuICAgICAgICovXG5cbiAgICAgIGNvbnN0IHdyYXBPYmplY3QgPSAodGFyZ2V0LCB3cmFwcGVycyA9IHt9LCBtZXRhZGF0YSA9IHt9KSA9PiB7XG4gICAgICAgIGxldCBjYWNoZSA9IE9iamVjdC5jcmVhdGUobnVsbCk7XG4gICAgICAgIGxldCBoYW5kbGVycyA9IHtcbiAgICAgICAgICBoYXMocHJveHlUYXJnZXQsIHByb3ApIHtcbiAgICAgICAgICAgIHJldHVybiBwcm9wIGluIHRhcmdldCB8fCBwcm9wIGluIGNhY2hlO1xuICAgICAgICAgIH0sXG5cbiAgICAgICAgICBnZXQocHJveHlUYXJnZXQsIHByb3AsIHJlY2VpdmVyKSB7XG4gICAgICAgICAgICBpZiAocHJvcCBpbiBjYWNoZSkge1xuICAgICAgICAgICAgICByZXR1cm4gY2FjaGVbcHJvcF07XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIGlmICghKHByb3AgaW4gdGFyZ2V0KSkge1xuICAgICAgICAgICAgICByZXR1cm4gdW5kZWZpbmVkO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICBsZXQgdmFsdWUgPSB0YXJnZXRbcHJvcF07XG5cbiAgICAgICAgICAgIGlmICh0eXBlb2YgdmFsdWUgPT09IFwiZnVuY3Rpb25cIikge1xuICAgICAgICAgICAgICAvLyBUaGlzIGlzIGEgbWV0aG9kIG9uIHRoZSB1bmRlcmx5aW5nIG9iamVjdC4gQ2hlY2sgaWYgd2UgbmVlZCB0byBkb1xuICAgICAgICAgICAgICAvLyBhbnkgd3JhcHBpbmcuXG4gICAgICAgICAgICAgIGlmICh0eXBlb2Ygd3JhcHBlcnNbcHJvcF0gPT09IFwiZnVuY3Rpb25cIikge1xuICAgICAgICAgICAgICAgIC8vIFdlIGhhdmUgYSBzcGVjaWFsLWNhc2Ugd3JhcHBlciBmb3IgdGhpcyBtZXRob2QuXG4gICAgICAgICAgICAgICAgdmFsdWUgPSB3cmFwTWV0aG9kKHRhcmdldCwgdGFyZ2V0W3Byb3BdLCB3cmFwcGVyc1twcm9wXSk7XG4gICAgICAgICAgICAgIH0gZWxzZSBpZiAoaGFzT3duUHJvcGVydHkobWV0YWRhdGEsIHByb3ApKSB7XG4gICAgICAgICAgICAgICAgLy8gVGhpcyBpcyBhbiBhc3luYyBtZXRob2QgdGhhdCB3ZSBoYXZlIG1ldGFkYXRhIGZvci4gQ3JlYXRlIGFcbiAgICAgICAgICAgICAgICAvLyBQcm9taXNlIHdyYXBwZXIgZm9yIGl0LlxuICAgICAgICAgICAgICAgIGxldCB3cmFwcGVyID0gd3JhcEFzeW5jRnVuY3Rpb24ocHJvcCwgbWV0YWRhdGFbcHJvcF0pO1xuICAgICAgICAgICAgICAgIHZhbHVlID0gd3JhcE1ldGhvZCh0YXJnZXQsIHRhcmdldFtwcm9wXSwgd3JhcHBlcik7XG4gICAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgICAgLy8gVGhpcyBpcyBhIG1ldGhvZCB0aGF0IHdlIGRvbid0IGtub3cgb3IgY2FyZSBhYm91dC4gUmV0dXJuIHRoZVxuICAgICAgICAgICAgICAgIC8vIG9yaWdpbmFsIG1ldGhvZCwgYm91bmQgdG8gdGhlIHVuZGVybHlpbmcgb2JqZWN0LlxuICAgICAgICAgICAgICAgIHZhbHVlID0gdmFsdWUuYmluZCh0YXJnZXQpO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9IGVsc2UgaWYgKHR5cGVvZiB2YWx1ZSA9PT0gXCJvYmplY3RcIiAmJiB2YWx1ZSAhPT0gbnVsbCAmJiAoaGFzT3duUHJvcGVydHkod3JhcHBlcnMsIHByb3ApIHx8IGhhc093blByb3BlcnR5KG1ldGFkYXRhLCBwcm9wKSkpIHtcbiAgICAgICAgICAgICAgLy8gVGhpcyBpcyBhbiBvYmplY3QgdGhhdCB3ZSBuZWVkIHRvIGRvIHNvbWUgd3JhcHBpbmcgZm9yIHRoZSBjaGlsZHJlblxuICAgICAgICAgICAgICAvLyBvZi4gQ3JlYXRlIGEgc3ViLW9iamVjdCB3cmFwcGVyIGZvciBpdCB3aXRoIHRoZSBhcHByb3ByaWF0ZSBjaGlsZFxuICAgICAgICAgICAgICAvLyBtZXRhZGF0YS5cbiAgICAgICAgICAgICAgdmFsdWUgPSB3cmFwT2JqZWN0KHZhbHVlLCB3cmFwcGVyc1twcm9wXSwgbWV0YWRhdGFbcHJvcF0pO1xuICAgICAgICAgICAgfSBlbHNlIGlmIChoYXNPd25Qcm9wZXJ0eShtZXRhZGF0YSwgXCIqXCIpKSB7XG4gICAgICAgICAgICAgIC8vIFdyYXAgYWxsIHByb3BlcnRpZXMgaW4gKiBuYW1lc3BhY2UuXG4gICAgICAgICAgICAgIHZhbHVlID0gd3JhcE9iamVjdCh2YWx1ZSwgd3JhcHBlcnNbcHJvcF0sIG1ldGFkYXRhW1wiKlwiXSk7XG4gICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICAvLyBXZSBkb24ndCBuZWVkIHRvIGRvIGFueSB3cmFwcGluZyBmb3IgdGhpcyBwcm9wZXJ0eSxcbiAgICAgICAgICAgICAgLy8gc28ganVzdCBmb3J3YXJkIGFsbCBhY2Nlc3MgdG8gdGhlIHVuZGVybHlpbmcgb2JqZWN0LlxuICAgICAgICAgICAgICBPYmplY3QuZGVmaW5lUHJvcGVydHkoY2FjaGUsIHByb3AsIHtcbiAgICAgICAgICAgICAgICBjb25maWd1cmFibGU6IHRydWUsXG4gICAgICAgICAgICAgICAgZW51bWVyYWJsZTogdHJ1ZSxcblxuICAgICAgICAgICAgICAgIGdldCgpIHtcbiAgICAgICAgICAgICAgICAgIHJldHVybiB0YXJnZXRbcHJvcF07XG4gICAgICAgICAgICAgICAgfSxcblxuICAgICAgICAgICAgICAgIHNldCh2YWx1ZSkge1xuICAgICAgICAgICAgICAgICAgdGFyZ2V0W3Byb3BdID0gdmFsdWU7XG4gICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgIH0pO1xuICAgICAgICAgICAgICByZXR1cm4gdmFsdWU7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIGNhY2hlW3Byb3BdID0gdmFsdWU7XG4gICAgICAgICAgICByZXR1cm4gdmFsdWU7XG4gICAgICAgICAgfSxcblxuICAgICAgICAgIHNldChwcm94eVRhcmdldCwgcHJvcCwgdmFsdWUsIHJlY2VpdmVyKSB7XG4gICAgICAgICAgICBpZiAocHJvcCBpbiBjYWNoZSkge1xuICAgICAgICAgICAgICBjYWNoZVtwcm9wXSA9IHZhbHVlO1xuICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgdGFyZ2V0W3Byb3BdID0gdmFsdWU7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIHJldHVybiB0cnVlO1xuICAgICAgICAgIH0sXG5cbiAgICAgICAgICBkZWZpbmVQcm9wZXJ0eShwcm94eVRhcmdldCwgcHJvcCwgZGVzYykge1xuICAgICAgICAgICAgcmV0dXJuIFJlZmxlY3QuZGVmaW5lUHJvcGVydHkoY2FjaGUsIHByb3AsIGRlc2MpO1xuICAgICAgICAgIH0sXG5cbiAgICAgICAgICBkZWxldGVQcm9wZXJ0eShwcm94eVRhcmdldCwgcHJvcCkge1xuICAgICAgICAgICAgcmV0dXJuIFJlZmxlY3QuZGVsZXRlUHJvcGVydHkoY2FjaGUsIHByb3ApO1xuICAgICAgICAgIH1cblxuICAgICAgICB9OyAvLyBQZXIgY29udHJhY3Qgb2YgdGhlIFByb3h5IEFQSSwgdGhlIFwiZ2V0XCIgcHJveHkgaGFuZGxlciBtdXN0IHJldHVybiB0aGVcbiAgICAgICAgLy8gb3JpZ2luYWwgdmFsdWUgb2YgdGhlIHRhcmdldCBpZiB0aGF0IHZhbHVlIGlzIGRlY2xhcmVkIHJlYWQtb25seSBhbmRcbiAgICAgICAgLy8gbm9uLWNvbmZpZ3VyYWJsZS4gRm9yIHRoaXMgcmVhc29uLCB3ZSBjcmVhdGUgYW4gb2JqZWN0IHdpdGggdGhlXG4gICAgICAgIC8vIHByb3RvdHlwZSBzZXQgdG8gYHRhcmdldGAgaW5zdGVhZCBvZiB1c2luZyBgdGFyZ2V0YCBkaXJlY3RseS5cbiAgICAgICAgLy8gT3RoZXJ3aXNlIHdlIGNhbm5vdCByZXR1cm4gYSBjdXN0b20gb2JqZWN0IGZvciBBUElzIHRoYXRcbiAgICAgICAgLy8gYXJlIGRlY2xhcmVkIHJlYWQtb25seSBhbmQgbm9uLWNvbmZpZ3VyYWJsZSwgc3VjaCBhcyBgY2hyb21lLmRldnRvb2xzYC5cbiAgICAgICAgLy9cbiAgICAgICAgLy8gVGhlIHByb3h5IGhhbmRsZXJzIHRoZW1zZWx2ZXMgd2lsbCBzdGlsbCB1c2UgdGhlIG9yaWdpbmFsIGB0YXJnZXRgXG4gICAgICAgIC8vIGluc3RlYWQgb2YgdGhlIGBwcm94eVRhcmdldGAsIHNvIHRoYXQgdGhlIG1ldGhvZHMgYW5kIHByb3BlcnRpZXMgYXJlXG4gICAgICAgIC8vIGRlcmVmZXJlbmNlZCB2aWEgdGhlIG9yaWdpbmFsIHRhcmdldHMuXG5cbiAgICAgICAgbGV0IHByb3h5VGFyZ2V0ID0gT2JqZWN0LmNyZWF0ZSh0YXJnZXQpO1xuICAgICAgICByZXR1cm4gbmV3IFByb3h5KHByb3h5VGFyZ2V0LCBoYW5kbGVycyk7XG4gICAgICB9O1xuICAgICAgLyoqXG4gICAgICAgKiBDcmVhdGVzIGEgc2V0IG9mIHdyYXBwZXIgZnVuY3Rpb25zIGZvciBhbiBldmVudCBvYmplY3QsIHdoaWNoIGhhbmRsZXNcbiAgICAgICAqIHdyYXBwaW5nIG9mIGxpc3RlbmVyIGZ1bmN0aW9ucyB0aGF0IHRob3NlIG1lc3NhZ2VzIGFyZSBwYXNzZWQuXG4gICAgICAgKlxuICAgICAgICogQSBzaW5nbGUgd3JhcHBlciBpcyBjcmVhdGVkIGZvciBlYWNoIGxpc3RlbmVyIGZ1bmN0aW9uLCBhbmQgc3RvcmVkIGluIGFcbiAgICAgICAqIG1hcC4gU3Vic2VxdWVudCBjYWxscyB0byBgYWRkTGlzdGVuZXJgLCBgaGFzTGlzdGVuZXJgLCBvciBgcmVtb3ZlTGlzdGVuZXJgXG4gICAgICAgKiByZXRyaWV2ZSB0aGUgb3JpZ2luYWwgd3JhcHBlciwgc28gdGhhdCAgYXR0ZW1wdHMgdG8gcmVtb3ZlIGFcbiAgICAgICAqIHByZXZpb3VzbHktYWRkZWQgbGlzdGVuZXIgd29yayBhcyBleHBlY3RlZC5cbiAgICAgICAqXG4gICAgICAgKiBAcGFyYW0ge0RlZmF1bHRXZWFrTWFwPGZ1bmN0aW9uLCBmdW5jdGlvbj59IHdyYXBwZXJNYXBcbiAgICAgICAqICAgICAgICBBIERlZmF1bHRXZWFrTWFwIG9iamVjdCB3aGljaCB3aWxsIGNyZWF0ZSB0aGUgYXBwcm9wcmlhdGUgd3JhcHBlclxuICAgICAgICogICAgICAgIGZvciBhIGdpdmVuIGxpc3RlbmVyIGZ1bmN0aW9uIHdoZW4gb25lIGRvZXMgbm90IGV4aXN0LCBhbmQgcmV0cmlldmVcbiAgICAgICAqICAgICAgICBhbiBleGlzdGluZyBvbmUgd2hlbiBpdCBkb2VzLlxuICAgICAgICpcbiAgICAgICAqIEByZXR1cm5zIHtvYmplY3R9XG4gICAgICAgKi9cblxuXG4gICAgICBjb25zdCB3cmFwRXZlbnQgPSB3cmFwcGVyTWFwID0+ICh7XG4gICAgICAgIGFkZExpc3RlbmVyKHRhcmdldCwgbGlzdGVuZXIsIC4uLmFyZ3MpIHtcbiAgICAgICAgICB0YXJnZXQuYWRkTGlzdGVuZXIod3JhcHBlck1hcC5nZXQobGlzdGVuZXIpLCAuLi5hcmdzKTtcbiAgICAgICAgfSxcblxuICAgICAgICBoYXNMaXN0ZW5lcih0YXJnZXQsIGxpc3RlbmVyKSB7XG4gICAgICAgICAgcmV0dXJuIHRhcmdldC5oYXNMaXN0ZW5lcih3cmFwcGVyTWFwLmdldChsaXN0ZW5lcikpO1xuICAgICAgICB9LFxuXG4gICAgICAgIHJlbW92ZUxpc3RlbmVyKHRhcmdldCwgbGlzdGVuZXIpIHtcbiAgICAgICAgICB0YXJnZXQucmVtb3ZlTGlzdGVuZXIod3JhcHBlck1hcC5nZXQobGlzdGVuZXIpKTtcbiAgICAgICAgfVxuXG4gICAgICB9KTsgLy8gS2VlcCB0cmFjayBpZiB0aGUgZGVwcmVjYXRpb24gd2FybmluZyBoYXMgYmVlbiBsb2dnZWQgYXQgbGVhc3Qgb25jZS5cblxuXG4gICAgICBsZXQgbG9nZ2VkU2VuZFJlc3BvbnNlRGVwcmVjYXRpb25XYXJuaW5nID0gZmFsc2U7XG4gICAgICBjb25zdCBvbk1lc3NhZ2VXcmFwcGVycyA9IG5ldyBEZWZhdWx0V2Vha01hcChsaXN0ZW5lciA9PiB7XG4gICAgICAgIGlmICh0eXBlb2YgbGlzdGVuZXIgIT09IFwiZnVuY3Rpb25cIikge1xuICAgICAgICAgIHJldHVybiBsaXN0ZW5lcjtcbiAgICAgICAgfVxuICAgICAgICAvKipcbiAgICAgICAgICogV3JhcHMgYSBtZXNzYWdlIGxpc3RlbmVyIGZ1bmN0aW9uIHNvIHRoYXQgaXQgbWF5IHNlbmQgcmVzcG9uc2VzIGJhc2VkIG9uXG4gICAgICAgICAqIGl0cyByZXR1cm4gdmFsdWUsIHJhdGhlciB0aGFuIGJ5IHJldHVybmluZyBhIHNlbnRpbmVsIHZhbHVlIGFuZCBjYWxsaW5nIGFcbiAgICAgICAgICogY2FsbGJhY2suIElmIHRoZSBsaXN0ZW5lciBmdW5jdGlvbiByZXR1cm5zIGEgUHJvbWlzZSwgdGhlIHJlc3BvbnNlIGlzXG4gICAgICAgICAqIHNlbnQgd2hlbiB0aGUgcHJvbWlzZSBlaXRoZXIgcmVzb2x2ZXMgb3IgcmVqZWN0cy5cbiAgICAgICAgICpcbiAgICAgICAgICogQHBhcmFtIHsqfSBtZXNzYWdlXG4gICAgICAgICAqICAgICAgICBUaGUgbWVzc2FnZSBzZW50IGJ5IHRoZSBvdGhlciBlbmQgb2YgdGhlIGNoYW5uZWwuXG4gICAgICAgICAqIEBwYXJhbSB7b2JqZWN0fSBzZW5kZXJcbiAgICAgICAgICogICAgICAgIERldGFpbHMgYWJvdXQgdGhlIHNlbmRlciBvZiB0aGUgbWVzc2FnZS5cbiAgICAgICAgICogQHBhcmFtIHtmdW5jdGlvbigqKX0gc2VuZFJlc3BvbnNlXG4gICAgICAgICAqICAgICAgICBBIGNhbGxiYWNrIHdoaWNoLCB3aGVuIGNhbGxlZCB3aXRoIGFuIGFyYml0cmFyeSBhcmd1bWVudCwgc2VuZHNcbiAgICAgICAgICogICAgICAgIHRoYXQgdmFsdWUgYXMgYSByZXNwb25zZS5cbiAgICAgICAgICogQHJldHVybnMge2Jvb2xlYW59XG4gICAgICAgICAqICAgICAgICBUcnVlIGlmIHRoZSB3cmFwcGVkIGxpc3RlbmVyIHJldHVybmVkIGEgUHJvbWlzZSwgd2hpY2ggd2lsbCBsYXRlclxuICAgICAgICAgKiAgICAgICAgeWllbGQgYSByZXNwb25zZS4gRmFsc2Ugb3RoZXJ3aXNlLlxuICAgICAgICAgKi9cblxuXG4gICAgICAgIHJldHVybiBmdW5jdGlvbiBvbk1lc3NhZ2UobWVzc2FnZSwgc2VuZGVyLCBzZW5kUmVzcG9uc2UpIHtcbiAgICAgICAgICBsZXQgZGlkQ2FsbFNlbmRSZXNwb25zZSA9IGZhbHNlO1xuICAgICAgICAgIGxldCB3cmFwcGVkU2VuZFJlc3BvbnNlO1xuICAgICAgICAgIGxldCBzZW5kUmVzcG9uc2VQcm9taXNlID0gbmV3IFByb21pc2UocmVzb2x2ZSA9PiB7XG4gICAgICAgICAgICB3cmFwcGVkU2VuZFJlc3BvbnNlID0gZnVuY3Rpb24gKHJlc3BvbnNlKSB7XG4gICAgICAgICAgICAgIGlmICghbG9nZ2VkU2VuZFJlc3BvbnNlRGVwcmVjYXRpb25XYXJuaW5nKSB7XG4gICAgICAgICAgICAgICAgY29uc29sZS53YXJuKFNFTkRfUkVTUE9OU0VfREVQUkVDQVRJT05fV0FSTklORywgbmV3IEVycm9yKCkuc3RhY2spO1xuICAgICAgICAgICAgICAgIGxvZ2dlZFNlbmRSZXNwb25zZURlcHJlY2F0aW9uV2FybmluZyA9IHRydWU7XG4gICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICBkaWRDYWxsU2VuZFJlc3BvbnNlID0gdHJ1ZTtcbiAgICAgICAgICAgICAgcmVzb2x2ZShyZXNwb25zZSk7XG4gICAgICAgICAgICB9O1xuICAgICAgICAgIH0pO1xuICAgICAgICAgIGxldCByZXN1bHQ7XG5cbiAgICAgICAgICB0cnkge1xuICAgICAgICAgICAgcmVzdWx0ID0gbGlzdGVuZXIobWVzc2FnZSwgc2VuZGVyLCB3cmFwcGVkU2VuZFJlc3BvbnNlKTtcbiAgICAgICAgICB9IGNhdGNoIChlcnIpIHtcbiAgICAgICAgICAgIHJlc3VsdCA9IFByb21pc2UucmVqZWN0KGVycik7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgY29uc3QgaXNSZXN1bHRUaGVuYWJsZSA9IHJlc3VsdCAhPT0gdHJ1ZSAmJiBpc1RoZW5hYmxlKHJlc3VsdCk7IC8vIElmIHRoZSBsaXN0ZW5lciBkaWRuJ3QgcmV0dXJuZWQgdHJ1ZSBvciBhIFByb21pc2UsIG9yIGNhbGxlZFxuICAgICAgICAgIC8vIHdyYXBwZWRTZW5kUmVzcG9uc2Ugc3luY2hyb25vdXNseSwgd2UgY2FuIGV4aXQgZWFybGllclxuICAgICAgICAgIC8vIGJlY2F1c2UgdGhlcmUgd2lsbCBiZSBubyByZXNwb25zZSBzZW50IGZyb20gdGhpcyBsaXN0ZW5lci5cblxuICAgICAgICAgIGlmIChyZXN1bHQgIT09IHRydWUgJiYgIWlzUmVzdWx0VGhlbmFibGUgJiYgIWRpZENhbGxTZW5kUmVzcG9uc2UpIHtcbiAgICAgICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgICAgICB9IC8vIEEgc21hbGwgaGVscGVyIHRvIHNlbmQgdGhlIG1lc3NhZ2UgaWYgdGhlIHByb21pc2UgcmVzb2x2ZXNcbiAgICAgICAgICAvLyBhbmQgYW4gZXJyb3IgaWYgdGhlIHByb21pc2UgcmVqZWN0cyAoYSB3cmFwcGVkIHNlbmRNZXNzYWdlIGhhc1xuICAgICAgICAgIC8vIHRvIHRyYW5zbGF0ZSB0aGUgbWVzc2FnZSBpbnRvIGEgcmVzb2x2ZWQgcHJvbWlzZSBvciBhIHJlamVjdGVkXG4gICAgICAgICAgLy8gcHJvbWlzZSkuXG5cblxuICAgICAgICAgIGNvbnN0IHNlbmRQcm9taXNlZFJlc3VsdCA9IHByb21pc2UgPT4ge1xuICAgICAgICAgICAgcHJvbWlzZS50aGVuKG1zZyA9PiB7XG4gICAgICAgICAgICAgIC8vIHNlbmQgdGhlIG1lc3NhZ2UgdmFsdWUuXG4gICAgICAgICAgICAgIHNlbmRSZXNwb25zZShtc2cpO1xuICAgICAgICAgICAgfSwgZXJyb3IgPT4ge1xuICAgICAgICAgICAgICAvLyBTZW5kIGEgSlNPTiByZXByZXNlbnRhdGlvbiBvZiB0aGUgZXJyb3IgaWYgdGhlIHJlamVjdGVkIHZhbHVlXG4gICAgICAgICAgICAgIC8vIGlzIGFuIGluc3RhbmNlIG9mIGVycm9yLCBvciB0aGUgb2JqZWN0IGl0c2VsZiBvdGhlcndpc2UuXG4gICAgICAgICAgICAgIGxldCBtZXNzYWdlO1xuXG4gICAgICAgICAgICAgIGlmIChlcnJvciAmJiAoZXJyb3IgaW5zdGFuY2VvZiBFcnJvciB8fCB0eXBlb2YgZXJyb3IubWVzc2FnZSA9PT0gXCJzdHJpbmdcIikpIHtcbiAgICAgICAgICAgICAgICBtZXNzYWdlID0gZXJyb3IubWVzc2FnZTtcbiAgICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgICBtZXNzYWdlID0gXCJBbiB1bmV4cGVjdGVkIGVycm9yIG9jY3VycmVkXCI7XG4gICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICBzZW5kUmVzcG9uc2Uoe1xuICAgICAgICAgICAgICAgIF9fbW96V2ViRXh0ZW5zaW9uUG9seWZpbGxSZWplY3RfXzogdHJ1ZSxcbiAgICAgICAgICAgICAgICBtZXNzYWdlXG4gICAgICAgICAgICAgIH0pO1xuICAgICAgICAgICAgfSkuY2F0Y2goZXJyID0+IHtcbiAgICAgICAgICAgICAgLy8gUHJpbnQgYW4gZXJyb3Igb24gdGhlIGNvbnNvbGUgaWYgdW5hYmxlIHRvIHNlbmQgdGhlIHJlc3BvbnNlLlxuICAgICAgICAgICAgICBjb25zb2xlLmVycm9yKFwiRmFpbGVkIHRvIHNlbmQgb25NZXNzYWdlIHJlamVjdGVkIHJlcGx5XCIsIGVycik7XG4gICAgICAgICAgICB9KTtcbiAgICAgICAgICB9OyAvLyBJZiB0aGUgbGlzdGVuZXIgcmV0dXJuZWQgYSBQcm9taXNlLCBzZW5kIHRoZSByZXNvbHZlZCB2YWx1ZSBhcyBhXG4gICAgICAgICAgLy8gcmVzdWx0LCBvdGhlcndpc2Ugd2FpdCB0aGUgcHJvbWlzZSByZWxhdGVkIHRvIHRoZSB3cmFwcGVkU2VuZFJlc3BvbnNlXG4gICAgICAgICAgLy8gY2FsbGJhY2sgdG8gcmVzb2x2ZSBhbmQgc2VuZCBpdCBhcyBhIHJlc3BvbnNlLlxuXG5cbiAgICAgICAgICBpZiAoaXNSZXN1bHRUaGVuYWJsZSkge1xuICAgICAgICAgICAgc2VuZFByb21pc2VkUmVzdWx0KHJlc3VsdCk7XG4gICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIHNlbmRQcm9taXNlZFJlc3VsdChzZW5kUmVzcG9uc2VQcm9taXNlKTtcbiAgICAgICAgICB9IC8vIExldCBDaHJvbWUga25vdyB0aGF0IHRoZSBsaXN0ZW5lciBpcyByZXBseWluZy5cblxuXG4gICAgICAgICAgcmV0dXJuIHRydWU7XG4gICAgICAgIH07XG4gICAgICB9KTtcblxuICAgICAgY29uc3Qgd3JhcHBlZFNlbmRNZXNzYWdlQ2FsbGJhY2sgPSAoe1xuICAgICAgICByZWplY3QsXG4gICAgICAgIHJlc29sdmVcbiAgICAgIH0sIHJlcGx5KSA9PiB7XG4gICAgICAgIGlmIChleHRlbnNpb25BUElzLnJ1bnRpbWUubGFzdEVycm9yKSB7XG4gICAgICAgICAgLy8gRGV0ZWN0IHdoZW4gbm9uZSBvZiB0aGUgbGlzdGVuZXJzIHJlcGxpZWQgdG8gdGhlIHNlbmRNZXNzYWdlIGNhbGwgYW5kIHJlc29sdmVcbiAgICAgICAgICAvLyB0aGUgcHJvbWlzZSB0byB1bmRlZmluZWQgYXMgaW4gRmlyZWZveC5cbiAgICAgICAgICAvLyBTZWUgaHR0cHM6Ly9naXRodWIuY29tL21vemlsbGEvd2ViZXh0ZW5zaW9uLXBvbHlmaWxsL2lzc3Vlcy8xMzBcbiAgICAgICAgICBpZiAoZXh0ZW5zaW9uQVBJcy5ydW50aW1lLmxhc3RFcnJvci5tZXNzYWdlID09PSBDSFJPTUVfU0VORF9NRVNTQUdFX0NBTExCQUNLX05PX1JFU1BPTlNFX01FU1NBR0UpIHtcbiAgICAgICAgICAgIHJlc29sdmUoKTtcbiAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgcmVqZWN0KGV4dGVuc2lvbkFQSXMucnVudGltZS5sYXN0RXJyb3IpO1xuICAgICAgICAgIH1cbiAgICAgICAgfSBlbHNlIGlmIChyZXBseSAmJiByZXBseS5fX21veldlYkV4dGVuc2lvblBvbHlmaWxsUmVqZWN0X18pIHtcbiAgICAgICAgICAvLyBDb252ZXJ0IGJhY2sgdGhlIEpTT04gcmVwcmVzZW50YXRpb24gb2YgdGhlIGVycm9yIGludG9cbiAgICAgICAgICAvLyBhbiBFcnJvciBpbnN0YW5jZS5cbiAgICAgICAgICByZWplY3QobmV3IEVycm9yKHJlcGx5Lm1lc3NhZ2UpKTtcbiAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICByZXNvbHZlKHJlcGx5KTtcbiAgICAgICAgfVxuICAgICAgfTtcblxuICAgICAgY29uc3Qgd3JhcHBlZFNlbmRNZXNzYWdlID0gKG5hbWUsIG1ldGFkYXRhLCBhcGlOYW1lc3BhY2VPYmosIC4uLmFyZ3MpID0+IHtcbiAgICAgICAgaWYgKGFyZ3MubGVuZ3RoIDwgbWV0YWRhdGEubWluQXJncykge1xuICAgICAgICAgIHRocm93IG5ldyBFcnJvcihgRXhwZWN0ZWQgYXQgbGVhc3QgJHttZXRhZGF0YS5taW5BcmdzfSAke3BsdXJhbGl6ZUFyZ3VtZW50cyhtZXRhZGF0YS5taW5BcmdzKX0gZm9yICR7bmFtZX0oKSwgZ290ICR7YXJncy5sZW5ndGh9YCk7XG4gICAgICAgIH1cblxuICAgICAgICBpZiAoYXJncy5sZW5ndGggPiBtZXRhZGF0YS5tYXhBcmdzKSB7XG4gICAgICAgICAgdGhyb3cgbmV3IEVycm9yKGBFeHBlY3RlZCBhdCBtb3N0ICR7bWV0YWRhdGEubWF4QXJnc30gJHtwbHVyYWxpemVBcmd1bWVudHMobWV0YWRhdGEubWF4QXJncyl9IGZvciAke25hbWV9KCksIGdvdCAke2FyZ3MubGVuZ3RofWApO1xuICAgICAgICB9XG5cbiAgICAgICAgcmV0dXJuIG5ldyBQcm9taXNlKChyZXNvbHZlLCByZWplY3QpID0+IHtcbiAgICAgICAgICBjb25zdCB3cmFwcGVkQ2IgPSB3cmFwcGVkU2VuZE1lc3NhZ2VDYWxsYmFjay5iaW5kKG51bGwsIHtcbiAgICAgICAgICAgIHJlc29sdmUsXG4gICAgICAgICAgICByZWplY3RcbiAgICAgICAgICB9KTtcbiAgICAgICAgICBhcmdzLnB1c2god3JhcHBlZENiKTtcbiAgICAgICAgICBhcGlOYW1lc3BhY2VPYmouc2VuZE1lc3NhZ2UoLi4uYXJncyk7XG4gICAgICAgIH0pO1xuICAgICAgfTtcblxuICAgICAgY29uc3Qgc3RhdGljV3JhcHBlcnMgPSB7XG4gICAgICAgIHJ1bnRpbWU6IHtcbiAgICAgICAgICBvbk1lc3NhZ2U6IHdyYXBFdmVudChvbk1lc3NhZ2VXcmFwcGVycyksXG4gICAgICAgICAgb25NZXNzYWdlRXh0ZXJuYWw6IHdyYXBFdmVudChvbk1lc3NhZ2VXcmFwcGVycyksXG4gICAgICAgICAgc2VuZE1lc3NhZ2U6IHdyYXBwZWRTZW5kTWVzc2FnZS5iaW5kKG51bGwsIFwic2VuZE1lc3NhZ2VcIiwge1xuICAgICAgICAgICAgbWluQXJnczogMSxcbiAgICAgICAgICAgIG1heEFyZ3M6IDNcbiAgICAgICAgICB9KVxuICAgICAgICB9LFxuICAgICAgICB0YWJzOiB7XG4gICAgICAgICAgc2VuZE1lc3NhZ2U6IHdyYXBwZWRTZW5kTWVzc2FnZS5iaW5kKG51bGwsIFwic2VuZE1lc3NhZ2VcIiwge1xuICAgICAgICAgICAgbWluQXJnczogMixcbiAgICAgICAgICAgIG1heEFyZ3M6IDNcbiAgICAgICAgICB9KVxuICAgICAgICB9XG4gICAgICB9O1xuICAgICAgY29uc3Qgc2V0dGluZ01ldGFkYXRhID0ge1xuICAgICAgICBjbGVhcjoge1xuICAgICAgICAgIG1pbkFyZ3M6IDEsXG4gICAgICAgICAgbWF4QXJnczogMVxuICAgICAgICB9LFxuICAgICAgICBnZXQ6IHtcbiAgICAgICAgICBtaW5BcmdzOiAxLFxuICAgICAgICAgIG1heEFyZ3M6IDFcbiAgICAgICAgfSxcbiAgICAgICAgc2V0OiB7XG4gICAgICAgICAgbWluQXJnczogMSxcbiAgICAgICAgICBtYXhBcmdzOiAxXG4gICAgICAgIH1cbiAgICAgIH07XG4gICAgICBhcGlNZXRhZGF0YS5wcml2YWN5ID0ge1xuICAgICAgICBuZXR3b3JrOiB7XG4gICAgICAgICAgXCIqXCI6IHNldHRpbmdNZXRhZGF0YVxuICAgICAgICB9LFxuICAgICAgICBzZXJ2aWNlczoge1xuICAgICAgICAgIFwiKlwiOiBzZXR0aW5nTWV0YWRhdGFcbiAgICAgICAgfSxcbiAgICAgICAgd2Vic2l0ZXM6IHtcbiAgICAgICAgICBcIipcIjogc2V0dGluZ01ldGFkYXRhXG4gICAgICAgIH1cbiAgICAgIH07XG4gICAgICByZXR1cm4gd3JhcE9iamVjdChleHRlbnNpb25BUElzLCBzdGF0aWNXcmFwcGVycywgYXBpTWV0YWRhdGEpO1xuICAgIH07XG5cbiAgICBpZiAodHlwZW9mIGNocm9tZSAhPSBcIm9iamVjdFwiIHx8ICFjaHJvbWUgfHwgIWNocm9tZS5ydW50aW1lIHx8ICFjaHJvbWUucnVudGltZS5pZCkge1xuICAgICAgdGhyb3cgbmV3IEVycm9yKFwiVGhpcyBzY3JpcHQgc2hvdWxkIG9ubHkgYmUgbG9hZGVkIGluIGEgYnJvd3NlciBleHRlbnNpb24uXCIpO1xuICAgIH0gLy8gVGhlIGJ1aWxkIHByb2Nlc3MgYWRkcyBhIFVNRCB3cmFwcGVyIGFyb3VuZCB0aGlzIGZpbGUsIHdoaWNoIG1ha2VzIHRoZVxuICAgIC8vIGBtb2R1bGVgIHZhcmlhYmxlIGF2YWlsYWJsZS5cblxuXG4gICAgbW9kdWxlLmV4cG9ydHMgPSB3cmFwQVBJcyhjaHJvbWUpO1xuICB9IGVsc2Uge1xuICAgIG1vZHVsZS5leHBvcnRzID0gYnJvd3NlcjtcbiAgfVxufSk7XG4vLyMgc291cmNlTWFwcGluZ1VSTD1icm93c2VyLXBvbHlmaWxsLmpzLm1hcFxuIiwiLy8gVGhlIG1vZHVsZSBjYWNoZVxudmFyIF9fd2VicGFja19tb2R1bGVfY2FjaGVfXyA9IHt9O1xuXG4vLyBUaGUgcmVxdWlyZSBmdW5jdGlvblxuZnVuY3Rpb24gX193ZWJwYWNrX3JlcXVpcmVfXyhtb2R1bGVJZCkge1xuXHQvLyBDaGVjayBpZiBtb2R1bGUgaXMgaW4gY2FjaGVcblx0dmFyIGNhY2hlZE1vZHVsZSA9IF9fd2VicGFja19tb2R1bGVfY2FjaGVfX1ttb2R1bGVJZF07XG5cdGlmIChjYWNoZWRNb2R1bGUgIT09IHVuZGVmaW5lZCkge1xuXHRcdHJldHVybiBjYWNoZWRNb2R1bGUuZXhwb3J0cztcblx0fVxuXHQvLyBDcmVhdGUgYSBuZXcgbW9kdWxlIChhbmQgcHV0IGl0IGludG8gdGhlIGNhY2hlKVxuXHR2YXIgbW9kdWxlID0gX193ZWJwYWNrX21vZHVsZV9jYWNoZV9fW21vZHVsZUlkXSA9IHtcblx0XHQvLyBubyBtb2R1bGUuaWQgbmVlZGVkXG5cdFx0Ly8gbm8gbW9kdWxlLmxvYWRlZCBuZWVkZWRcblx0XHRleHBvcnRzOiB7fVxuXHR9O1xuXG5cdC8vIEV4ZWN1dGUgdGhlIG1vZHVsZSBmdW5jdGlvblxuXHRfX3dlYnBhY2tfbW9kdWxlc19fW21vZHVsZUlkXS5jYWxsKG1vZHVsZS5leHBvcnRzLCBtb2R1bGUsIG1vZHVsZS5leHBvcnRzLCBfX3dlYnBhY2tfcmVxdWlyZV9fKTtcblxuXHQvLyBSZXR1cm4gdGhlIGV4cG9ydHMgb2YgdGhlIG1vZHVsZVxuXHRyZXR1cm4gbW9kdWxlLmV4cG9ydHM7XG59XG5cbiIsIi8vIGdldERlZmF1bHRFeHBvcnQgZnVuY3Rpb24gZm9yIGNvbXBhdGliaWxpdHkgd2l0aCBub24taGFybW9ueSBtb2R1bGVzXG5fX3dlYnBhY2tfcmVxdWlyZV9fLm4gPSAobW9kdWxlKSA9PiB7XG5cdHZhciBnZXR0ZXIgPSBtb2R1bGUgJiYgbW9kdWxlLl9fZXNNb2R1bGUgP1xuXHRcdCgpID0+IChtb2R1bGVbJ2RlZmF1bHQnXSkgOlxuXHRcdCgpID0+IChtb2R1bGUpO1xuXHRfX3dlYnBhY2tfcmVxdWlyZV9fLmQoZ2V0dGVyLCB7IGE6IGdldHRlciB9KTtcblx0cmV0dXJuIGdldHRlcjtcbn07IiwiLy8gZGVmaW5lIGdldHRlciBmdW5jdGlvbnMgZm9yIGhhcm1vbnkgZXhwb3J0c1xuX193ZWJwYWNrX3JlcXVpcmVfXy5kID0gKGV4cG9ydHMsIGRlZmluaXRpb24pID0+IHtcblx0Zm9yKHZhciBrZXkgaW4gZGVmaW5pdGlvbikge1xuXHRcdGlmKF9fd2VicGFja19yZXF1aXJlX18ubyhkZWZpbml0aW9uLCBrZXkpICYmICFfX3dlYnBhY2tfcmVxdWlyZV9fLm8oZXhwb3J0cywga2V5KSkge1xuXHRcdFx0T2JqZWN0LmRlZmluZVByb3BlcnR5KGV4cG9ydHMsIGtleSwgeyBlbnVtZXJhYmxlOiB0cnVlLCBnZXQ6IGRlZmluaXRpb25ba2V5XSB9KTtcblx0XHR9XG5cdH1cbn07IiwiX193ZWJwYWNrX3JlcXVpcmVfXy5vID0gKG9iaiwgcHJvcCkgPT4gKE9iamVjdC5wcm90b3R5cGUuaGFzT3duUHJvcGVydHkuY2FsbChvYmosIHByb3ApKSIsIi8vIGRlZmluZSBfX2VzTW9kdWxlIG9uIGV4cG9ydHNcbl9fd2VicGFja19yZXF1aXJlX18uciA9IChleHBvcnRzKSA9PiB7XG5cdGlmKHR5cGVvZiBTeW1ib2wgIT09ICd1bmRlZmluZWQnICYmIFN5bWJvbC50b1N0cmluZ1RhZykge1xuXHRcdE9iamVjdC5kZWZpbmVQcm9wZXJ0eShleHBvcnRzLCBTeW1ib2wudG9TdHJpbmdUYWcsIHsgdmFsdWU6ICdNb2R1bGUnIH0pO1xuXHR9XG5cdE9iamVjdC5kZWZpbmVQcm9wZXJ0eShleHBvcnRzLCAnX19lc01vZHVsZScsIHsgdmFsdWU6IHRydWUgfSk7XG59OyIsImltcG9ydCB7IGNvbnRlbnQgfSBmcm9tICcuLi8uLi9wYWdlcy9jb250ZW50JztcblxuY29udGVudC5pbml0KCk7XG4iXSwic291cmNlUm9vdCI6IiJ9