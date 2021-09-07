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
  MessagesToNativeApp["GetBlockingData"] = "getBlockingData";
  MessagesToNativeApp["AddToUserRules"] = "addToUserRules";
  MessagesToNativeApp["IsProtectionEnabled"] = "isProtectionEnabled";
  MessagesToNativeApp["EnableProtection"] = "enableProtection";
  MessagesToNativeApp["DisableProtection"] = "disableProtection";
  MessagesToNativeApp["HasUserRulesBySite"] = "hasUserRulesBySite";
  MessagesToNativeApp["RemoveUserRulesBySite"] = "removeUserRulesBySite";
  MessagesToNativeApp["ReportProblem"] = "reportProblem";
  MessagesToNativeApp["IsPremium"] = "isPremium";
  MessagesToNativeApp["GetAppearanceTheme"] = "getAppearanceTheme";
  MessagesToNativeApp["AreContentBlockersEnabled"] = "areContentBlockersEnabled";
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
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIndlYnBhY2s6Ly9hZHZhbmNlZC1hZGJsb2NrZXItd2ViLWV4dGVuc2lvbi8uL25vZGVfbW9kdWxlcy9AYmFiZWwvcnVudGltZS9oZWxwZXJzL2VzbS9hcnJheUxpa2VUb0FycmF5LmpzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vbm9kZV9tb2R1bGVzL0BiYWJlbC9ydW50aW1lL2hlbHBlcnMvZXNtL2FycmF5V2l0aG91dEhvbGVzLmpzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vbm9kZV9tb2R1bGVzL0BiYWJlbC9ydW50aW1lL2hlbHBlcnMvZXNtL2FzeW5jVG9HZW5lcmF0b3IuanMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vLi9ub2RlX21vZHVsZXMvQGJhYmVsL3J1bnRpbWUvaGVscGVycy9lc20vaXRlcmFibGVUb0FycmF5LmpzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vbm9kZV9tb2R1bGVzL0BiYWJlbC9ydW50aW1lL2hlbHBlcnMvZXNtL25vbkl0ZXJhYmxlU3ByZWFkLmpzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vbm9kZV9tb2R1bGVzL0BiYWJlbC9ydW50aW1lL2hlbHBlcnMvZXNtL3RvQ29uc3VtYWJsZUFycmF5LmpzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vbm9kZV9tb2R1bGVzL0BiYWJlbC9ydW50aW1lL2hlbHBlcnMvZXNtL3Vuc3VwcG9ydGVkSXRlcmFibGVUb0FycmF5LmpzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vbm9kZV9tb2R1bGVzL0BiYWJlbC9ydW50aW1lL3JlZ2VuZXJhdG9yL2luZGV4LmpzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vc3JjL3BhZ2VzL2NvbW1vbi9jb25zdGFudHMudHMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vLi9zcmMvcGFnZXMvY29udGVudC9jb250ZW50LnRzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vbm9kZV9tb2R1bGVzL2V4dGVuZGVkLWNzcy9kaXN0L2V4dGVuZGVkLWNzcy5lc20uanMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vLi9ub2RlX21vZHVsZXMvcmVnZW5lcmF0b3ItcnVudGltZS9ydW50aW1lLmpzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vbm9kZV9tb2R1bGVzL3dlYmV4dGVuc2lvbi1wb2x5ZmlsbC10cy9saWIvaW5kZXguanMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vLi9ub2RlX21vZHVsZXMvd2ViZXh0ZW5zaW9uLXBvbHlmaWxsL2Rpc3QvYnJvd3Nlci1wb2x5ZmlsbC5qcyIsIndlYnBhY2s6Ly9hZHZhbmNlZC1hZGJsb2NrZXItd2ViLWV4dGVuc2lvbi93ZWJwYWNrL2Jvb3RzdHJhcCIsIndlYnBhY2s6Ly9hZHZhbmNlZC1hZGJsb2NrZXItd2ViLWV4dGVuc2lvbi93ZWJwYWNrL3J1bnRpbWUvY29tcGF0IGdldCBkZWZhdWx0IGV4cG9ydCIsIndlYnBhY2s6Ly9hZHZhbmNlZC1hZGJsb2NrZXItd2ViLWV4dGVuc2lvbi93ZWJwYWNrL3J1bnRpbWUvZGVmaW5lIHByb3BlcnR5IGdldHRlcnMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vd2VicGFjay9ydW50aW1lL2hhc093blByb3BlcnR5IHNob3J0aGFuZCIsIndlYnBhY2s6Ly9hZHZhbmNlZC1hZGJsb2NrZXItd2ViLWV4dGVuc2lvbi93ZWJwYWNrL3J1bnRpbWUvbWFrZSBuYW1lc3BhY2Ugb2JqZWN0Iiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vc3JjL3RhcmdldHMvY29udGVudC9pbmRleC50cyJdLCJuYW1lcyI6WyJNZXNzYWdlc1RvTmF0aXZlQXBwIiwiTWVzc2FnZXNUb0JhY2tncm91bmRQYWdlIiwiTWVzc2FnZXNUb0NvbnRlbnRTY3JpcHQiLCJBcHBlYXJhbmNlVGhlbWUiLCJBUFBFQVJBTkNFX1RIRU1FX0RFRkFVTFQiLCJTeXN0ZW0iLCJsb2dNZXNzYWdlIiwidmVyYm9zZSIsIm1lc3NhZ2UiLCJjb25zb2xlIiwibG9nIiwiZ2V0U2VsZWN0b3JzQW5kU2NyaXB0cyIsImJyb3dzZXIiLCJ0eXBlIiwiZGF0YSIsInVybCIsIndpbmRvdyIsImxvY2F0aW9uIiwiaHJlZiIsInJlc3BvbnNlIiwiZXhlY3V0ZVNjcmlwdHMiLCJzY3JpcHRzIiwic3RhcnQiLCJlbmQiLCJ1cGRhdGVkIiwic2NyaXB0VGFnIiwiZG9jdW1lbnQiLCJjcmVhdGVFbGVtZW50Iiwic2V0QXR0cmlidXRlIiwidGV4dENvbnRlbnQiLCJqb2luIiwicGFyZW50IiwiaGVhZCIsImRvY3VtZW50RWxlbWVudCIsImFwcGVuZENoaWxkIiwicGFyZW50Tm9kZSIsInJlbW92ZUNoaWxkIiwiYXBwbHlTY3JpcHRzIiwibGVuZ3RoIiwicmV2ZXJzZSIsInByb3RlY3RTdHlsZUVsZW1lbnRDb250ZW50IiwicHJvdGVjdFN0eWxlRWwiLCJNdXRhdGlvbk9ic2VydmVyIiwiV2ViS2l0TXV0YXRpb25PYnNlcnZlciIsImlubmVyT2JzZXJ2ZXIiLCJtdXRhdGlvbnMiLCJpIiwibSIsImhhc0F0dHJpYnV0ZSIsImdldEF0dHJpYnV0ZSIsInJlbW92ZUF0dHJpYnV0ZSIsImlzUHJvdGVjdFN0eWxlRWxNb2RpZmllZCIsInJlbW92ZWROb2RlcyIsImoiLCJvbGRWYWx1ZSIsIm9ic2VydmUiLCJjaGlsZExpc3QiLCJjaGFyYWN0ZXJEYXRhIiwic3VidHJlZSIsImNoYXJhY3RlckRhdGFPbGRWYWx1ZSIsImFwcGx5Q3NzIiwic3R5bGVTZWxlY3RvcnMiLCJzdHlsZUVsZW1lbnQiLCJzZWxlY3RvcnMiLCJtYXAiLCJzIiwidHJpbSIsImZvckVhY2giLCJzZWxlY3RvciIsInNoZWV0IiwiaW5zZXJ0UnVsZSIsImFwcGx5RXh0ZW5kZWRDc3MiLCJleHRlbmRlZENzcyIsImV4dGNzcyIsIkV4dGVuZGVkQ3NzIiwic3R5bGVTaGVldCIsImZpbHRlciIsImFwcGx5IiwiYXBwbHlBZHZhbmNlZEJsb2NraW5nRGF0YSIsInNlbGVjdG9yc0FuZFNjcmlwdHMiLCJjc3NJbmplY3QiLCJjc3NFeHRlbmRlZCIsImluaXQiLCJIVE1MRG9jdW1lbnQiLCJpbmRleE9mIiwic3RhcnRHZXR0aW5nU2NyaXB0cyIsIkRhdGUiLCJub3ciLCJjb250ZW50Il0sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7Ozs7OztBQUFlO0FBQ2Y7O0FBRUEsd0NBQXdDLFNBQVM7QUFDakQ7QUFDQTs7QUFFQTtBQUNBLEM7Ozs7Ozs7Ozs7Ozs7Ozs7QUNScUQ7QUFDdEM7QUFDZixpQ0FBaUMsNkRBQWdCO0FBQ2pELEM7Ozs7Ozs7Ozs7Ozs7OztBQ0hBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsR0FBRztBQUNIO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0EsR0FBRztBQUNIO0FBQ0E7QUFDQTs7QUFFZTtBQUNmO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBLEtBQUs7QUFDTDtBQUNBLEM7Ozs7Ozs7Ozs7Ozs7OztBQ2xDZTtBQUNmO0FBQ0EsQzs7Ozs7Ozs7Ozs7Ozs7O0FDRmU7QUFDZjtBQUNBLEM7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7QUNGdUQ7QUFDSjtBQUNzQjtBQUNsQjtBQUN4QztBQUNmLFNBQVMsOERBQWlCLFNBQVMsNERBQWUsU0FBUyx1RUFBMEIsU0FBUyw4REFBaUI7QUFDL0csQzs7Ozs7Ozs7Ozs7Ozs7OztBQ05xRDtBQUN0QztBQUNm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OztBQUU3QztBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsYUFBYSxTQUFTO0FBQ3RCLGFBQWEsT0FBTztBQUNwQjtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFVBQVU7QUFDVjtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7O0FBRUE7QUFDQSxLQUFLO0FBQ0w7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0EsQ0FBQztBQUNEO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTtBQUNBLDJCQUEyQix5Q0FBeUM7QUFDcEU7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0EsT0FBTztBQUNQO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDs7QUFFQTtBQUNBLEtBQUs7QUFDTDtBQUNBO0FBQ0E7QUFDQSxLQUFLO0FBQ0w7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQSxLQUFLO0FBQ0w7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQSxDQUFDO0FBQ0Q7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLE1BQU07QUFDTjtBQUNBO0FBQ0EsYUFBYSxNQUFNO0FBQ25COztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQSxLQUFLO0FBQ0w7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsS0FBSztBQUNMO0FBQ0E7QUFDQSxLQUFLO0FBQ0w7QUFDQTtBQUNBO0FBQ0EsT0FBTztBQUNQO0FBQ0EsS0FBSztBQUNMO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsT0FBTztBQUNQO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsT0FBTztBQUNQO0FBQ0EsR0FBRztBQUNIO0FBQ0EsQ0FBQztBQUNEO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBLGlCQUFpQixPQUFPO0FBQ3hCO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsQ0FBQztBQUNEO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQSxlQUFlLGNBQWM7QUFDN0I7QUFDQSxlQUFlLE9BQU87O0FBRXRCO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxlQUFlLE9BQU87O0FBRXRCO0FBQ0EsZUFBZSxPQUFPOztBQUV0QjtBQUNBO0FBQ0E7QUFDQSxXQUFXLE9BQU87QUFDbEI7OztBQUdBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxlQUFlLE9BQU87O0FBRXRCO0FBQ0EsZUFBZSxPQUFPO0FBQ3RCOztBQUVBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVyxRQUFRO0FBQ25CLGFBQWEsT0FBTztBQUNwQjs7O0FBR0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQSxnQkFBZ0I7QUFDaEI7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLEtBQUs7QUFDTDtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLElBQUk7QUFDSjtBQUNBLDJDQUEyQyxhQUFhO0FBQ3hEO0FBQ0E7OztBQUdBO0FBQ0E7QUFDQSwrQkFBK0I7O0FBRS9CO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLGFBQWEsT0FBTztBQUNwQixjQUFjO0FBQ2Q7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0EsS0FBSztBQUNMO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLENBQUM7O0FBRUQ7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNB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QUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsZ0NBQWdDOztBQUVoQztBQUNBO0FBQ0E7QUFDQSxLQUFLO0FBQ0w7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLE9BQU87QUFDUDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLEtBQUs7O0FBRUw7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBLDJCQUEyQjtBQUMzQjtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsS0FBSyxFQUFFOztBQUVQLG9DQUFvQzs7QUFFcEM7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsS0FBSzs7O0FBR0w7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQSxLQUFLOzs7QUFHTDtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsS0FBSztBQUNMOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLEtBQUs7QUFDTDtBQUNBO0FBQ0E7QUFDQTtBQUNBLEtBQUs7O0FBRUw7QUFDQTtBQUNBLEtBQUs7OztBQUdMO0FBQ0EsR0FBRzs7O0FBR0gsaURBQWlEOztBQUVqRDtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXLE9BQU87QUFDbEIsV0FBVyxRQUFRO0FBQ25CLGFBQWEscUJBQXFCO0FBQ2xDO0FBQ0E7OztBQUdBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBLEdBQUc7QUFDSDs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBLGlFQUFlLFdBQVcsRUFBQzs7Ozs7Ozs7Ozs7QUNwckszQjtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0EsZ0JBQWdCO0FBQ2hCO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLEtBQUs7QUFDTDtBQUNBO0FBQ0E7QUFDQTtBQUNBLGFBQWE7QUFDYixHQUFHO0FBQ0g7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLGNBQWM7QUFDZCxLQUFLO0FBQ0wsY0FBYztBQUNkO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EseURBQXlEO0FBQ3pEO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsT0FBTztBQUNQLEtBQUs7QUFDTDs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0EsS0FBSztBQUNMO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsWUFBWTtBQUNaOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxPQUFPO0FBQ1A7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQSxXQUFXO0FBQ1g7O0FBRUE7QUFDQTtBQUNBLHdDQUF3QyxXQUFXO0FBQ25EO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQSwyQkFBMkI7QUFDM0I7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUEsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBOztBQUVBOztBQUVBLFNBQVM7QUFDVDtBQUNBOztBQUVBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0Esb0NBQW9DLGNBQWM7QUFDbEQ7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQSxLQUFLO0FBQ0w7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUEsaUNBQWlDLGtCQUFrQjtBQUNuRDtBQUNBOztBQUVBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0EsaUJBQWlCOztBQUVqQjtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQSx3QkFBd0IsaUJBQWlCO0FBQ3pDO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0EsWUFBWTtBQUNaO0FBQ0E7O0FBRUE7QUFDQSxZQUFZO0FBQ1o7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxLQUFLOztBQUVMO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBLEtBQUs7O0FBRUw7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQSw4Q0FBOEMsUUFBUTtBQUN0RDtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0EsYUFBYTtBQUNiO0FBQ0E7O0FBRUEsV0FBVztBQUNYO0FBQ0E7QUFDQTs7QUFFQSxXQUFXO0FBQ1g7QUFDQTtBQUNBOztBQUVBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLEtBQUs7O0FBRUw7QUFDQSw4Q0FBOEMsUUFBUTtBQUN0RDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBLEtBQUs7O0FBRUw7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0EsT0FBTztBQUNQO0FBQ0E7QUFDQTtBQUNBLE9BQU87QUFDUDtBQUNBOztBQUVBO0FBQ0EsS0FBSzs7QUFFTDtBQUNBLDhDQUE4QyxRQUFRO0FBQ3REO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsS0FBSzs7QUFFTDtBQUNBLDhDQUE4QyxRQUFRO0FBQ3REO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLEtBQUs7O0FBRUw7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUEsQ0FBQztBQUNEO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsRUFBRSxLQUEwQixvQkFBb0IsQ0FBRTtBQUNsRDs7QUFFQTtBQUNBO0FBQ0EsQ0FBQztBQUNEO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7Ozs7Ozs7Ozs7OztBQzN1QmE7QUFDYiw4Q0FBNkMsQ0FBQyxjQUFjLEVBQUM7O0FBRTdELG1JQUFrRDs7Ozs7Ozs7Ozs7QUNIbEQ7QUFDQSxNQUFNLElBQTBDO0FBQ2hELElBQUksaUNBQWdDLENBQUMsTUFBUSxDQUFDLG9DQUFFLE9BQU87QUFBQTtBQUFBO0FBQUEsa0dBQUM7QUFDeEQsR0FBRyxNQUFNLFlBUU47QUFDSCxDQUFDO0FBQ0Q7O0FBRUEscUNBQXFDOztBQUVyQzs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0EsdVNBQXVTO0FBQ3ZTO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxhQUFhO0FBQ2I7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsYUFBYTtBQUNiO0FBQ0E7QUFDQTtBQUNBLGFBQWE7QUFDYjtBQUNBO0FBQ0E7QUFDQSxhQUFhO0FBQ2I7QUFDQTtBQUNBO0FBQ0EsYUFBYTtBQUNiO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsYUFBYTtBQUNiO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsYUFBYTtBQUNiO0FBQ0E7QUFDQTtBQUNBLGFBQWE7QUFDYjtBQUNBO0FBQ0E7QUFDQSxhQUFhO0FBQ2I7QUFDQTtBQUNBO0FBQ0EsYUFBYTtBQUNiO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNB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QUNBOzs7OztXQ3RCQTtXQUNBO1dBQ0E7V0FDQTtXQUNBO1dBQ0EsZ0NBQWdDLFlBQVk7V0FDNUM7V0FDQSxFOzs7OztXQ1BBO1dBQ0E7V0FDQTtXQUNBO1dBQ0Esd0NBQXdDLHlDQUF5QztXQUNqRjtXQUNBO1dBQ0EsRTs7Ozs7V0NQQSx3Rjs7Ozs7V0NBQTtXQUNBO1dBQ0E7V0FDQSxzREFBc0Qsa0JBQWtCO1dBQ3hFO1dBQ0EsK0NBQStDLGNBQWM7V0FDN0QsRTs7Ozs7Ozs7Ozs7OztBQ05BO0FBRUFNLHdEQUFBLEciLCJmaWxlIjoiY29udGVudC5qcyIsInNvdXJjZXNDb250ZW50IjpbImV4cG9ydCBkZWZhdWx0IGZ1bmN0aW9uIF9hcnJheUxpa2VUb0FycmF5KGFyciwgbGVuKSB7XG4gIGlmIChsZW4gPT0gbnVsbCB8fCBsZW4gPiBhcnIubGVuZ3RoKSBsZW4gPSBhcnIubGVuZ3RoO1xuXG4gIGZvciAodmFyIGkgPSAwLCBhcnIyID0gbmV3IEFycmF5KGxlbik7IGkgPCBsZW47IGkrKykge1xuICAgIGFycjJbaV0gPSBhcnJbaV07XG4gIH1cblxuICByZXR1cm4gYXJyMjtcbn0iLCJpbXBvcnQgYXJyYXlMaWtlVG9BcnJheSBmcm9tIFwiLi9hcnJheUxpa2VUb0FycmF5LmpzXCI7XG5leHBvcnQgZGVmYXVsdCBmdW5jdGlvbiBfYXJyYXlXaXRob3V0SG9sZXMoYXJyKSB7XG4gIGlmIChBcnJheS5pc0FycmF5KGFycikpIHJldHVybiBhcnJheUxpa2VUb0FycmF5KGFycik7XG59IiwiZnVuY3Rpb24gYXN5bmNHZW5lcmF0b3JTdGVwKGdlbiwgcmVzb2x2ZSwgcmVqZWN0LCBfbmV4dCwgX3Rocm93LCBrZXksIGFyZykge1xuICB0cnkge1xuICAgIHZhciBpbmZvID0gZ2VuW2tleV0oYXJnKTtcbiAgICB2YXIgdmFsdWUgPSBpbmZvLnZhbHVlO1xuICB9IGNhdGNoIChlcnJvcikge1xuICAgIHJlamVjdChlcnJvcik7XG4gICAgcmV0dXJuO1xuICB9XG5cbiAgaWYgKGluZm8uZG9uZSkge1xuICAgIHJlc29sdmUodmFsdWUpO1xuICB9IGVsc2Uge1xuICAgIFByb21pc2UucmVzb2x2ZSh2YWx1ZSkudGhlbihfbmV4dCwgX3Rocm93KTtcbiAgfVxufVxuXG5leHBvcnQgZGVmYXVsdCBmdW5jdGlvbiBfYXN5bmNUb0dlbmVyYXRvcihmbikge1xuICByZXR1cm4gZnVuY3Rpb24gKCkge1xuICAgIHZhciBzZWxmID0gdGhpcyxcbiAgICAgICAgYXJncyA9IGFyZ3VtZW50cztcbiAgICByZXR1cm4gbmV3IFByb21pc2UoZnVuY3Rpb24gKHJlc29sdmUsIHJlamVjdCkge1xuICAgICAgdmFyIGdlbiA9IGZuLmFwcGx5KHNlbGYsIGFyZ3MpO1xuXG4gICAgICBmdW5jdGlvbiBfbmV4dCh2YWx1ZSkge1xuICAgICAgICBhc3luY0dlbmVyYXRvclN0ZXAoZ2VuLCByZXNvbHZlLCByZWplY3QsIF9uZXh0LCBfdGhyb3csIFwibmV4dFwiLCB2YWx1ZSk7XG4gICAgICB9XG5cbiAgICAgIGZ1bmN0aW9uIF90aHJvdyhlcnIpIHtcbiAgICAgICAgYXN5bmNHZW5lcmF0b3JTdGVwKGdlbiwgcmVzb2x2ZSwgcmVqZWN0LCBfbmV4dCwgX3Rocm93LCBcInRocm93XCIsIGVycik7XG4gICAgICB9XG5cbiAgICAgIF9uZXh0KHVuZGVmaW5lZCk7XG4gICAgfSk7XG4gIH07XG59IiwiZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24gX2l0ZXJhYmxlVG9BcnJheShpdGVyKSB7XG4gIGlmICh0eXBlb2YgU3ltYm9sICE9PSBcInVuZGVmaW5lZFwiICYmIGl0ZXJbU3ltYm9sLml0ZXJhdG9yXSAhPSBudWxsIHx8IGl0ZXJbXCJAQGl0ZXJhdG9yXCJdICE9IG51bGwpIHJldHVybiBBcnJheS5mcm9tKGl0ZXIpO1xufSIsImV4cG9ydCBkZWZhdWx0IGZ1bmN0aW9uIF9ub25JdGVyYWJsZVNwcmVhZCgpIHtcbiAgdGhyb3cgbmV3IFR5cGVFcnJvcihcIkludmFsaWQgYXR0ZW1wdCB0byBzcHJlYWQgbm9uLWl0ZXJhYmxlIGluc3RhbmNlLlxcbkluIG9yZGVyIHRvIGJlIGl0ZXJhYmxlLCBub24tYXJyYXkgb2JqZWN0cyBtdXN0IGhhdmUgYSBbU3ltYm9sLml0ZXJhdG9yXSgpIG1ldGhvZC5cIik7XG59IiwiaW1wb3J0IGFycmF5V2l0aG91dEhvbGVzIGZyb20gXCIuL2FycmF5V2l0aG91dEhvbGVzLmpzXCI7XG5pbXBvcnQgaXRlcmFibGVUb0FycmF5IGZyb20gXCIuL2l0ZXJhYmxlVG9BcnJheS5qc1wiO1xuaW1wb3J0IHVuc3VwcG9ydGVkSXRlcmFibGVUb0FycmF5IGZyb20gXCIuL3Vuc3VwcG9ydGVkSXRlcmFibGVUb0FycmF5LmpzXCI7XG5pbXBvcnQgbm9uSXRlcmFibGVTcHJlYWQgZnJvbSBcIi4vbm9uSXRlcmFibGVTcHJlYWQuanNcIjtcbmV4cG9ydCBkZWZhdWx0IGZ1bmN0aW9uIF90b0NvbnN1bWFibGVBcnJheShhcnIpIHtcbiAgcmV0dXJuIGFycmF5V2l0aG91dEhvbGVzKGFycikgfHwgaXRlcmFibGVUb0FycmF5KGFycikgfHwgdW5zdXBwb3J0ZWRJdGVyYWJsZVRvQXJyYXkoYXJyKSB8fCBub25JdGVyYWJsZVNwcmVhZCgpO1xufSIsImltcG9ydCBhcnJheUxpa2VUb0FycmF5IGZyb20gXCIuL2FycmF5TGlrZVRvQXJyYXkuanNcIjtcbmV4cG9ydCBkZWZhdWx0IGZ1bmN0aW9uIF91bnN1cHBvcnRlZEl0ZXJhYmxlVG9BcnJheShvLCBtaW5MZW4pIHtcbiAgaWYgKCFvKSByZXR1cm47XG4gIGlmICh0eXBlb2YgbyA9PT0gXCJzdHJpbmdcIikgcmV0dXJuIGFycmF5TGlrZVRvQXJyYXkobywgbWluTGVuKTtcbiAgdmFyIG4gPSBPYmplY3QucHJvdG90eXBlLnRvU3RyaW5nLmNhbGwobykuc2xpY2UoOCwgLTEpO1xuICBpZiAobiA9PT0gXCJPYmplY3RcIiAmJiBvLmNvbnN0cnVjdG9yKSBuID0gby5jb25zdHJ1Y3Rvci5uYW1lO1xuICBpZiAobiA9PT0gXCJNYXBcIiB8fCBuID09PSBcIlNldFwiKSByZXR1cm4gQXJyYXkuZnJvbShvKTtcbiAgaWYgKG4gPT09IFwiQXJndW1lbnRzXCIgfHwgL14oPzpVaXxJKW50KD86OHwxNnwzMikoPzpDbGFtcGVkKT9BcnJheSQvLnRlc3QobikpIHJldHVybiBhcnJheUxpa2VUb0FycmF5KG8sIG1pbkxlbik7XG59IiwibW9kdWxlLmV4cG9ydHMgPSByZXF1aXJlKFwicmVnZW5lcmF0b3ItcnVudGltZVwiKTtcbiIsImV4cG9ydCBlbnVtIE1lc3NhZ2VzVG9OYXRpdmVBcHAge1xuICAgIFdyaXRlSW5OYXRpdmVMb2cgPSAnd3JpdGVJbk5hdGl2ZUxvZycsXG4gICAgR2V0QmxvY2tpbmdEYXRhID0gJ2dldEJsb2NraW5nRGF0YScsXG4gICAgQWRkVG9Vc2VyUnVsZXMgPSAnYWRkVG9Vc2VyUnVsZXMnLFxuICAgIElzUHJvdGVjdGlvbkVuYWJsZWQgPSAnaXNQcm90ZWN0aW9uRW5hYmxlZCcsXG4gICAgRW5hYmxlUHJvdGVjdGlvbiA9ICdlbmFibGVQcm90ZWN0aW9uJyxcbiAgICBEaXNhYmxlUHJvdGVjdGlvbiA9ICdkaXNhYmxlUHJvdGVjdGlvbicsXG4gICAgSGFzVXNlclJ1bGVzQnlTaXRlID0gJ2hhc1VzZXJSdWxlc0J5U2l0ZScsXG4gICAgUmVtb3ZlVXNlclJ1bGVzQnlTaXRlID0gJ3JlbW92ZVVzZXJSdWxlc0J5U2l0ZScsXG4gICAgUmVwb3J0UHJvYmxlbSA9ICdyZXBvcnRQcm9ibGVtJyxcbiAgICBJc1ByZW1pdW0gPSAnaXNQcmVtaXVtJyxcbiAgICBHZXRBcHBlYXJhbmNlVGhlbWUgPSAnZ2V0QXBwZWFyYW5jZVRoZW1lJyxcbiAgICBBcmVDb250ZW50QmxvY2tlcnNFbmFibGVkID0gJ2FyZUNvbnRlbnRCbG9ja2Vyc0VuYWJsZWQnLFxuICAgIFVwZ3JhZGVNZSA9ICd1cGdyYWRlTWUnLFxuICAgIEdldEFkdmFuY2VkUnVsZXNUZXh0ID0gJ2dldF9hZHZhbmNlZF9ydWxlc190ZXh0JyxcbiAgICBHZXRJbml0RGF0YSA9ICdnZXRfaW5pdF9kYXRhJyxcbn1cblxuZXhwb3J0IGVudW0gTWVzc2FnZXNUb0JhY2tncm91bmRQYWdlIHtcbiAgICBPcGVuQXNzaXN0YW50ID0gJ29wZW5fYXNzaXN0YW50JyxcbiAgICBHZXRTY3JpcHRzQW5kU2VsZWN0b3JzID0gJ2dldF9zY3JpcHRzX2FuZF9zZWxlY3RvcnMnLFxuICAgIEFkZFJ1bGUgPSAnYWRkX3J1bGUnLFxuICAgIEdldFBvcHVwRGF0YSA9ICdnZXRfcG9wdXBfZGF0YScsXG4gICAgU2V0UGVybWlzc2lvbnNNb2RhbFZpZXdlZCA9ICdzZXRfcGVybWlzc2lvbnNfbW9kYWxfdmlld2VkJyxcbiAgICBTZXRQcm90ZWN0aW9uU3RhdHVzID0gJ3NldF9wcm90ZWN0aW9uX3N0YXR1cycsXG4gICAgRGVsZXRlVXNlclJ1bGVzQnlVcmwgPSAnZGVsZXRlX3VzZXJfcnVsZXNfYnlfdXJsJyxcbiAgICBSZXBvcnRQcm9ibGVtID0gJ3JlcG9ydF9wcm9ibGVtJyxcbiAgICBVcGdyYWRlQ2xpY2tlZCA9ICd1cGdyYWRlX2NsaWNrZWQnLFxufVxuXG5leHBvcnQgZW51bSBNZXNzYWdlc1RvQ29udGVudFNjcmlwdCB7XG4gICAgSW5pdEFzc2lzdGFudCA9ICdpbml0X2Fzc2lzdGFudCcsXG59XG5cbmV4cG9ydCBlbnVtIEFwcGVhcmFuY2VUaGVtZSB7XG4gICAgU3lzdGVtID0gJ3N5c3RlbScsXG4gICAgRGFyayA9ICdkYXJrJyxcbiAgICBMaWdodCA9ICdsaWdodCcsXG59XG5cbmV4cG9ydCBjb25zdCBBUFBFQVJBTkNFX1RIRU1FX0RFRkFVTFQgPSBBcHBlYXJhbmNlVGhlbWUuU3lzdGVtO1xuIiwiLyogZXNsaW50LWRpc2FibGUgbm8tY29uc29sZSAqL1xuaW1wb3J0IHsgYnJvd3NlciB9IGZyb20gJ3dlYmV4dGVuc2lvbi1wb2x5ZmlsbC10cyc7XG5pbXBvcnQgRXh0ZW5kZWRDc3MgZnJvbSAnZXh0ZW5kZWQtY3NzJztcblxuaW1wb3J0IHsgTWVzc2FnZXNUb0JhY2tncm91bmRQYWdlIH0gZnJvbSAnLi4vY29tbW9uL2NvbnN0YW50cyc7XG5pbXBvcnQgeyBTZWxlY3RvcnNBbmRTY3JpcHRzIH0gZnJvbSAnLi4vY29tbW9uL2ludGVyZmFjZXMnO1xuXG4vKipcbiAqIExvZ3MgYSBtZXNzYWdlIGlmIHZlcmJvc2UgaXMgdHJ1ZVxuICpcbiAqIEBwYXJhbSB2ZXJib3NlXG4gKiBAcGFyYW0gbWVzc2FnZVxuICovXG5jb25zdCBsb2dNZXNzYWdlID0gKHZlcmJvc2U6IGJvb2xlYW4sIG1lc3NhZ2U6IHN0cmluZykgPT4ge1xuICAgIGlmICh2ZXJib3NlKSB7XG4gICAgICAgIGNvbnNvbGUubG9nKGAoQUcpICR7bWVzc2FnZX1gKTtcbiAgICB9XG59O1xuXG5jb25zdCBnZXRTZWxlY3RvcnNBbmRTY3JpcHRzID0gYXN5bmMgKCk6IFByb21pc2U8U2VsZWN0b3JzQW5kU2NyaXB0cyB8IG51bGw+ID0+IHtcbiAgICBjb25zdCByZXNwb25zZSA9IGF3YWl0IGJyb3dzZXIucnVudGltZS5zZW5kTWVzc2FnZSh7XG4gICAgICAgIHR5cGU6IE1lc3NhZ2VzVG9CYWNrZ3JvdW5kUGFnZS5HZXRTY3JpcHRzQW5kU2VsZWN0b3JzLFxuICAgICAgICBkYXRhOiB7XG4gICAgICAgICAgICB1cmw6IHdpbmRvdy5sb2NhdGlvbi5ocmVmLFxuICAgICAgICB9LFxuICAgIH0pO1xuXG4gICAgaWYgKHJlc3BvbnNlID09PSBudWxsKSB7XG4gICAgICAgIGNvbnNvbGUubG9nKCdBRzogbm8gc2NyaXB0cyBhbmQgc2VsZWN0b3JzIHJlY2VpdmVkJyk7XG4gICAgICAgIHJldHVybiBudWxsO1xuICAgIH1cblxuICAgIHJldHVybiByZXNwb25zZSBhcyBTZWxlY3RvcnNBbmRTY3JpcHRzO1xufTtcblxuLyoqXG4gKiBFeGVjdXRlIHNjcmlwdHMgaW4gYSBwYWdlIGNvbnRleHQgYW5kIGNsZWFudXAgaXRzZWxmIHdoZW4gZXhlY3V0aW9uIGNvbXBsZXRlc1xuICogQHBhcmFtIHNjcmlwdHMgU2NyaXB0cyBhcnJheSB0byBleGVjdXRlXG4gKi9cbmNvbnN0IGV4ZWN1dGVTY3JpcHRzID0gKHNjcmlwdHM6IHN0cmluZ1tdKSA9PiB7XG4gICAgLy8gV3JhcCB3aXRoIHRyeSBjYXRjaFxuICAgIGNvbnN0IHN0YXJ0ID0gJyggZnVuY3Rpb24gKCkgeyB0cnkgeyc7XG4gICAgY29uc3QgZW5kID0gXCJ9IGNhdGNoIChleCkgeyBjb25zb2xlLmVycm9yKCdFcnJvciBleGVjdXRpbmcgQUcganM6ICcgKyBleCk7IH0gfSkoKTtcIjtcblxuICAgIGNvbnN0IHVwZGF0ZWQgPSBbc3RhcnQsIC4uLnNjcmlwdHMsIGVuZF07XG5cbiAgICBjb25zdCBzY3JpcHRUYWcgPSBkb2N1bWVudC5jcmVhdGVFbGVtZW50KCdzY3JpcHQnKTtcbiAgICBzY3JpcHRUYWcuc2V0QXR0cmlidXRlKCd0eXBlJywgJ3RleHQvamF2YXNjcmlwdCcpO1xuICAgIHNjcmlwdFRhZy50ZXh0Q29udGVudCA9IHVwZGF0ZWQuam9pbignXFxyXFxuJyk7XG5cbiAgICBjb25zdCBwYXJlbnQgPSBkb2N1bWVudC5oZWFkIHx8IGRvY3VtZW50LmRvY3VtZW50RWxlbWVudDtcbiAgICBwYXJlbnQuYXBwZW5kQ2hpbGQoc2NyaXB0VGFnKTtcbiAgICBpZiAoc2NyaXB0VGFnLnBhcmVudE5vZGUpIHtcbiAgICAgICAgc2NyaXB0VGFnLnBhcmVudE5vZGUucmVtb3ZlQ2hpbGQoc2NyaXB0VGFnKTtcbiAgICB9XG59O1xuXG4vKipcbiAqIEFwcGxpZXMgSlMgaW5qZWN0aW9ucy5cbiAqIEBwYXJhbSBzY3JpcHRzIEFycmF5IHdpdGggSlMgc2NyaXB0c1xuICogQHBhcmFtIHZlcmJvc2UgbG9nZ2luZ1xuICovXG5jb25zdCBhcHBseVNjcmlwdHMgPSAoc2NyaXB0czogc3RyaW5nW10sIHZlcmJvc2U6IGJvb2xlYW4pID0+IHtcbiAgICBpZiAoIXNjcmlwdHMgfHwgc2NyaXB0cy5sZW5ndGggPT09IDApIHtcbiAgICAgICAgcmV0dXJuO1xuICAgIH1cblxuICAgIGxvZ01lc3NhZ2UodmVyYm9zZSwgYHNjcmlwdHMgbGVuZ3RoOiAke3NjcmlwdHMubGVuZ3RofWApO1xuICAgIGV4ZWN1dGVTY3JpcHRzKHNjcmlwdHMucmV2ZXJzZSgpKTtcbn07XG5cbi8qKlxuICogUHJvdGVjdHMgc3BlY2lmaWVkIHN0eWxlIGVsZW1lbnQgZnJvbSBjaGFuZ2VzIHRvIHRoZSBjdXJyZW50IGRvY3VtZW50XG4gKiBBZGQgYSBtdXRhdGlvbiBvYnNlcnZlciwgd2hpY2ggaXMgYWRkcyBvdXIgcnVsZXMgYWdhaW4gaWYgaXQgd2FzIHJlbW92ZWRcbiAqXG4gKiBAcGFyYW0gcHJvdGVjdFN0eWxlRWwgcHJvdGVjdGVkIHN0eWxlIGVsZW1lbnRcbiAqL1xuY29uc3QgcHJvdGVjdFN0eWxlRWxlbWVudENvbnRlbnQgPSAocHJvdGVjdFN0eWxlRWw6IE5vZGUpID0+IHtcbiAgICAvLyBAdHMtaWdub3JlXG4gICAgY29uc3QgTXV0YXRpb25PYnNlcnZlciA9IHdpbmRvdy5NdXRhdGlvbk9ic2VydmVyIHx8IHdpbmRvdy5XZWJLaXRNdXRhdGlvbk9ic2VydmVyO1xuICAgIGlmICghTXV0YXRpb25PYnNlcnZlcikge1xuICAgICAgICByZXR1cm47XG4gICAgfVxuICAgIC8qIG9ic2VydmVyLCB3aGljaCBvYnNlcnZlIHByb3RlY3RTdHlsZUVsIGlubmVyIGNoYW5nZXMsIHdpdGhvdXQgZGVsZXRpbmcgc3R5bGVFbCAqL1xuICAgIGNvbnN0IGlubmVyT2JzZXJ2ZXIgPSBuZXcgTXV0YXRpb25PYnNlcnZlcigoKG11dGF0aW9ucykgPT4ge1xuICAgICAgICBmb3IgKGxldCBpID0gMDsgaSA8IG11dGF0aW9ucy5sZW5ndGg7IGkgKz0gMSkge1xuICAgICAgICAgICAgY29uc3QgbSA9IG11dGF0aW9uc1tpXTtcbiAgICAgICAgICAgIC8vIEB0cy1pZ25vcmVcbiAgICAgICAgICAgIGlmIChwcm90ZWN0U3R5bGVFbC5oYXNBdHRyaWJ1dGUoJ21vZCcpICYmIHByb3RlY3RTdHlsZUVsLmdldEF0dHJpYnV0ZSgnbW9kJykgPT09ICdpbm5lcicpIHtcbiAgICAgICAgICAgICAgICAvLyBAdHMtaWdub3JlXG4gICAgICAgICAgICAgICAgcHJvdGVjdFN0eWxlRWwucmVtb3ZlQXR0cmlidXRlKCdtb2QnKTtcbiAgICAgICAgICAgICAgICBicmVhaztcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgLy8gQHRzLWlnbm9yZVxuICAgICAgICAgICAgcHJvdGVjdFN0eWxlRWwuc2V0QXR0cmlidXRlKCdtb2QnLCAnaW5uZXInKTtcbiAgICAgICAgICAgIGxldCBpc1Byb3RlY3RTdHlsZUVsTW9kaWZpZWQgPSBmYWxzZTtcblxuICAgICAgICAgICAgLyoqXG4gICAgICAgICAgICAgKiBmdXJ0aGVyLCB0aGVyZSBhcmUgdHdvIG11dHVhbGx5IGV4Y2x1c2l2ZSBzaXR1YXRpb25zOiBlaXRoZXIgdGhlcmUgd2VyZSBjaGFuZ2VzXG4gICAgICAgICAgICAgKiB0aGUgdGV4dCBvZiBwcm90ZWN0U3R5bGVFbCwgZWl0aGVyIHRoZXJlIHdhcyByZW1vdmVzIGEgd2hvbGUgY2hpbGQgXCJ0ZXh0XCJcbiAgICAgICAgICAgICAqIGVsZW1lbnQgb2YgcHJvdGVjdFN0eWxlRWwgd2UnbGwgcHJvY2VzcyBib3RoIG9mIHRoZW1cbiAgICAgICAgICAgICAqL1xuICAgICAgICAgICAgaWYgKG0ucmVtb3ZlZE5vZGVzLmxlbmd0aCA+IDApIHtcbiAgICAgICAgICAgICAgICBmb3IgKGxldCBqID0gMDsgaiA8IG0ucmVtb3ZlZE5vZGVzLmxlbmd0aDsgaiArPSAxKSB7XG4gICAgICAgICAgICAgICAgICAgIGlzUHJvdGVjdFN0eWxlRWxNb2RpZmllZCA9IHRydWU7XG4gICAgICAgICAgICAgICAgICAgIHByb3RlY3RTdHlsZUVsLmFwcGVuZENoaWxkKG0ucmVtb3ZlZE5vZGVzW2pdKTtcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9IGVsc2UgaWYgKG0ub2xkVmFsdWUpIHtcbiAgICAgICAgICAgICAgICBpc1Byb3RlY3RTdHlsZUVsTW9kaWZpZWQgPSB0cnVlO1xuICAgICAgICAgICAgICAgIC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBuby1wYXJhbS1yZWFzc2lnblxuICAgICAgICAgICAgICAgIHByb3RlY3RTdHlsZUVsLnRleHRDb250ZW50ID0gbS5vbGRWYWx1ZTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgaWYgKCFpc1Byb3RlY3RTdHlsZUVsTW9kaWZpZWQpIHtcbiAgICAgICAgICAgICAgICAvLyBAdHMtaWdub3JlXG4gICAgICAgICAgICAgICAgcHJvdGVjdFN0eWxlRWwucmVtb3ZlQXR0cmlidXRlKCdtb2QnKTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgIH0pKTtcblxuICAgIGlubmVyT2JzZXJ2ZXIub2JzZXJ2ZShwcm90ZWN0U3R5bGVFbCwge1xuICAgICAgICBjaGlsZExpc3Q6IHRydWUsXG4gICAgICAgIGNoYXJhY3RlckRhdGE6IHRydWUsXG4gICAgICAgIHN1YnRyZWU6IHRydWUsXG4gICAgICAgIGNoYXJhY3RlckRhdGFPbGRWYWx1ZTogdHJ1ZSxcbiAgICB9KTtcbn07XG5cbi8qKlxuICogQXBwbGllcyBjc3Mgc3R5bGVzaGVldFxuICogQHBhcmFtIHN0eWxlU2VsZWN0b3JzIEFycmF5IG9mIHN0eWxlc2hlZXRzIG9yIHNlbGVjdG9yc1xuICogQHBhcmFtIHZlcmJvc2UgbG9nZ2luZ1xuICovXG5jb25zdCBhcHBseUNzcyA9IChzdHlsZVNlbGVjdG9yczogc3RyaW5nW10sIHZlcmJvc2U6IGJvb2xlYW4pID0+IHtcbiAgICBpZiAoIXN0eWxlU2VsZWN0b3JzIHx8ICFzdHlsZVNlbGVjdG9ycy5sZW5ndGgpIHtcbiAgICAgICAgcmV0dXJuO1xuICAgIH1cblxuICAgIGxvZ01lc3NhZ2UodmVyYm9zZSwgYGNzcyBsZW5ndGg6ICR7c3R5bGVTZWxlY3RvcnMubGVuZ3RofWApO1xuXG4gICAgY29uc3Qgc3R5bGVFbGVtZW50ID0gZG9jdW1lbnQuY3JlYXRlRWxlbWVudCgnc3R5bGUnKTtcbiAgICBzdHlsZUVsZW1lbnQuc2V0QXR0cmlidXRlKCd0eXBlJywgJ3RleHQvY3NzJyk7XG4gICAgKGRvY3VtZW50LmhlYWQgfHwgZG9jdW1lbnQuZG9jdW1lbnRFbGVtZW50KS5hcHBlbmRDaGlsZChzdHlsZUVsZW1lbnQpO1xuXG4gICAgY29uc3Qgc2VsZWN0b3JzID0gc3R5bGVTZWxlY3RvcnMubWFwKChzKSA9PiBzLnRyaW0oKSk7XG4gICAgc2VsZWN0b3JzLmZvckVhY2goKHNlbGVjdG9yKSA9PiB7XG4gICAgICAgIHN0eWxlRWxlbWVudC5zaGVldCEuaW5zZXJ0UnVsZShzZWxlY3Rvcik7XG4gICAgfSk7XG5cbiAgICBwcm90ZWN0U3R5bGVFbGVtZW50Q29udGVudChzdHlsZUVsZW1lbnQpO1xufTtcblxuLyoqXG4gKiBBcHBsaWVzIEV4dGVuZGVkIENzcyBzdHlsZXNoZWV0XG4gKlxuICogQHBhcmFtIGV4dGVuZGVkQ3NzIEFycmF5IHdpdGggRXh0ZW5kZWRDc3Mgc3R5bGVzaGVldHNcbiAqIEBwYXJhbSB2ZXJib3NlIGxvZ2dpbmdcbiAqL1xuY29uc3QgYXBwbHlFeHRlbmRlZENzcyA9IChleHRlbmRlZENzczogc3RyaW5nW10sIHZlcmJvc2U6IGJvb2xlYW4pID0+IHtcbiAgICBpZiAoIWV4dGVuZGVkQ3NzIHx8ICFleHRlbmRlZENzcy5sZW5ndGgpIHtcbiAgICAgICAgcmV0dXJuO1xuICAgIH1cblxuICAgIGxvZ01lc3NhZ2UodmVyYm9zZSwgYGV4dGVuZGVkIGNzcyBsZW5ndGg6ICR7ZXh0ZW5kZWRDc3MubGVuZ3RofWApO1xuICAgIGNvbnN0IGV4dGNzcyA9IG5ldyBFeHRlbmRlZENzcyh7XG4gICAgICAgIHN0eWxlU2hlZXQ6IGV4dGVuZGVkQ3NzXG4gICAgICAgICAgICAuZmlsdGVyKChzKSA9PiBzLmxlbmd0aCA+IDApXG4gICAgICAgICAgICAubWFwKChzKSA9PiBzLnRyaW0oKSlcbiAgICAgICAgICAgIC5tYXAoKHMpID0+IChzW3MubGVuZ3RoIC0gMV0gIT09ICd9JyA/IGAke3N9IHtkaXNwbGF5Om5vbmUhaW1wb3J0YW50O31gIDogcykpXG4gICAgICAgICAgICAuam9pbignXFxuJyksXG4gICAgfSk7XG4gICAgZXh0Y3NzLmFwcGx5KCk7XG59O1xuXG4vKipcbiAqIEFwcGxpZXMgaW5qZWN0ZWQgc2NyaXB0IGFuZCBjc3NcbiAqXG4gKiBAcGFyYW0gc2VsZWN0b3JzQW5kU2NyaXB0c1xuICogQHBhcmFtIHZlcmJvc2VcbiAqL1xuY29uc3QgYXBwbHlBZHZhbmNlZEJsb2NraW5nRGF0YSA9IChzZWxlY3RvcnNBbmRTY3JpcHRzOiBTZWxlY3RvcnNBbmRTY3JpcHRzLCB2ZXJib3NlID0gdHJ1ZSkgPT4ge1xuICAgIGxvZ01lc3NhZ2UodmVyYm9zZSwgJ0FwcGx5aW5nIHNjcmlwdHMgYW5kIGNzcy4uJyk7XG4gICAgbG9nTWVzc2FnZSh2ZXJib3NlLCBgRnJhbWUgdXJsOiAke3dpbmRvdy5sb2NhdGlvbi5ocmVmfWApO1xuXG4gICAgYXBwbHlTY3JpcHRzKHNlbGVjdG9yc0FuZFNjcmlwdHMuc2NyaXB0cywgdmVyYm9zZSk7XG4gICAgYXBwbHlDc3Moc2VsZWN0b3JzQW5kU2NyaXB0cy5jc3NJbmplY3QsIHZlcmJvc2UpO1xuICAgIGFwcGx5RXh0ZW5kZWRDc3Moc2VsZWN0b3JzQW5kU2NyaXB0cy5jc3NFeHRlbmRlZCwgdmVyYm9zZSk7XG5cbiAgICBsb2dNZXNzYWdlKHZlcmJvc2UsICdBcHBseWluZyBzY3JpcHRzIGFuZCBjc3MgLSBkb25lJyk7XG59O1xuXG5jb25zdCBpbml0ID0gYXN5bmMgKCkgPT4ge1xuICAgIGlmIChkb2N1bWVudCBpbnN0YW5jZW9mIEhUTUxEb2N1bWVudCkge1xuICAgICAgICBpZiAod2luZG93LmxvY2F0aW9uLmhyZWYgJiYgd2luZG93LmxvY2F0aW9uLmhyZWYuaW5kZXhPZignaHR0cCcpID09PSAwKSB7XG4gICAgICAgICAgICBjb25zdCBzdGFydEdldHRpbmdTY3JpcHRzID0gRGF0ZS5ub3coKTtcbiAgICAgICAgICAgIGxldCBzZWxlY3RvcnNBbmRTY3JpcHRzO1xuICAgICAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgICAgICBzZWxlY3RvcnNBbmRTY3JpcHRzID0gYXdhaXQgZ2V0U2VsZWN0b3JzQW5kU2NyaXB0cygpO1xuICAgICAgICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKGUpO1xuICAgICAgICAgICAgfVxuICAgICAgICAgICAgY29uc29sZS5sb2coYFRpbWUgdG8gZ2V0IHNlbGVjdG9ycyBhbmQgc2NyaXB0cyBmcm9tIG5hdGl2ZSBwYWdlIHRvIGNvbnRlbnQgc2NyaXB0OiAke0RhdGUubm93KCkgLSBzdGFydEdldHRpbmdTY3JpcHRzfSBtc2ApO1xuICAgICAgICAgICAgaWYgKHNlbGVjdG9yc0FuZFNjcmlwdHMpIHtcbiAgICAgICAgICAgICAgICBhcHBseUFkdmFuY2VkQmxvY2tpbmdEYXRhKHNlbGVjdG9yc0FuZFNjcmlwdHMsIGZhbHNlKTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgIH1cbn07XG5cbmV4cG9ydCBjb25zdCBjb250ZW50ID0ge1xuICAgIGluaXQsXG59O1xuIiwiLyohIGV4dGVuZGVkLWNzcyAtIHYxLjMuMTIgLSBNb24gTWF5IDMxIDIwMjFcbiogaHR0cHM6Ly9naXRodWIuY29tL0FkZ3VhcmRUZWFtL0V4dGVuZGVkQ3NzXG4qIENvcHlyaWdodCAoYykgMjAyMSBBZEd1YXJkLiBMaWNlbnNlZCBMR1BMLTMuMFxuKi9cbmZ1bmN0aW9uIF90eXBlb2Yob2JqKSB7XG4gIFwiQGJhYmVsL2hlbHBlcnMgLSB0eXBlb2ZcIjtcblxuICBpZiAodHlwZW9mIFN5bWJvbCA9PT0gXCJmdW5jdGlvblwiICYmIHR5cGVvZiBTeW1ib2wuaXRlcmF0b3IgPT09IFwic3ltYm9sXCIpIHtcbiAgICBfdHlwZW9mID0gZnVuY3Rpb24gKG9iaikge1xuICAgICAgcmV0dXJuIHR5cGVvZiBvYmo7XG4gICAgfTtcbiAgfSBlbHNlIHtcbiAgICBfdHlwZW9mID0gZnVuY3Rpb24gKG9iaikge1xuICAgICAgcmV0dXJuIG9iaiAmJiB0eXBlb2YgU3ltYm9sID09PSBcImZ1bmN0aW9uXCIgJiYgb2JqLmNvbnN0cnVjdG9yID09PSBTeW1ib2wgJiYgb2JqICE9PSBTeW1ib2wucHJvdG90eXBlID8gXCJzeW1ib2xcIiA6IHR5cGVvZiBvYmo7XG4gICAgfTtcbiAgfVxuXG4gIHJldHVybiBfdHlwZW9mKG9iaik7XG59XG5cbmZ1bmN0aW9uIF9zbGljZWRUb0FycmF5KGFyciwgaSkge1xuICByZXR1cm4gX2FycmF5V2l0aEhvbGVzKGFycikgfHwgX2l0ZXJhYmxlVG9BcnJheUxpbWl0KGFyciwgaSkgfHwgX3Vuc3VwcG9ydGVkSXRlcmFibGVUb0FycmF5KGFyciwgaSkgfHwgX25vbkl0ZXJhYmxlUmVzdCgpO1xufVxuXG5mdW5jdGlvbiBfdG9Db25zdW1hYmxlQXJyYXkoYXJyKSB7XG4gIHJldHVybiBfYXJyYXlXaXRob3V0SG9sZXMoYXJyKSB8fCBfaXRlcmFibGVUb0FycmF5KGFycikgfHwgX3Vuc3VwcG9ydGVkSXRlcmFibGVUb0FycmF5KGFycikgfHwgX25vbkl0ZXJhYmxlU3ByZWFkKCk7XG59XG5cbmZ1bmN0aW9uIF9hcnJheVdpdGhvdXRIb2xlcyhhcnIpIHtcbiAgaWYgKEFycmF5LmlzQXJyYXkoYXJyKSkgcmV0dXJuIF9hcnJheUxpa2VUb0FycmF5KGFycik7XG59XG5cbmZ1bmN0aW9uIF9hcnJheVdpdGhIb2xlcyhhcnIpIHtcbiAgaWYgKEFycmF5LmlzQXJyYXkoYXJyKSkgcmV0dXJuIGFycjtcbn1cblxuZnVuY3Rpb24gX2l0ZXJhYmxlVG9BcnJheShpdGVyKSB7XG4gIGlmICh0eXBlb2YgU3ltYm9sICE9PSBcInVuZGVmaW5lZFwiICYmIFN5bWJvbC5pdGVyYXRvciBpbiBPYmplY3QoaXRlcikpIHJldHVybiBBcnJheS5mcm9tKGl0ZXIpO1xufVxuXG5mdW5jdGlvbiBfaXRlcmFibGVUb0FycmF5TGltaXQoYXJyLCBpKSB7XG4gIGlmICh0eXBlb2YgU3ltYm9sID09PSBcInVuZGVmaW5lZFwiIHx8ICEoU3ltYm9sLml0ZXJhdG9yIGluIE9iamVjdChhcnIpKSkgcmV0dXJuO1xuICB2YXIgX2FyciA9IFtdO1xuICB2YXIgX24gPSB0cnVlO1xuICB2YXIgX2QgPSBmYWxzZTtcbiAgdmFyIF9lID0gdW5kZWZpbmVkO1xuXG4gIHRyeSB7XG4gICAgZm9yICh2YXIgX2kgPSBhcnJbU3ltYm9sLml0ZXJhdG9yXSgpLCBfczsgIShfbiA9IChfcyA9IF9pLm5leHQoKSkuZG9uZSk7IF9uID0gdHJ1ZSkge1xuICAgICAgX2Fyci5wdXNoKF9zLnZhbHVlKTtcblxuICAgICAgaWYgKGkgJiYgX2Fyci5sZW5ndGggPT09IGkpIGJyZWFrO1xuICAgIH1cbiAgfSBjYXRjaCAoZXJyKSB7XG4gICAgX2QgPSB0cnVlO1xuICAgIF9lID0gZXJyO1xuICB9IGZpbmFsbHkge1xuICAgIHRyeSB7XG4gICAgICBpZiAoIV9uICYmIF9pW1wicmV0dXJuXCJdICE9IG51bGwpIF9pW1wicmV0dXJuXCJdKCk7XG4gICAgfSBmaW5hbGx5IHtcbiAgICAgIGlmIChfZCkgdGhyb3cgX2U7XG4gICAgfVxuICB9XG5cbiAgcmV0dXJuIF9hcnI7XG59XG5cbmZ1bmN0aW9uIF91bnN1cHBvcnRlZEl0ZXJhYmxlVG9BcnJheShvLCBtaW5MZW4pIHtcbiAgaWYgKCFvKSByZXR1cm47XG4gIGlmICh0eXBlb2YgbyA9PT0gXCJzdHJpbmdcIikgcmV0dXJuIF9hcnJheUxpa2VUb0FycmF5KG8sIG1pbkxlbik7XG4gIHZhciBuID0gT2JqZWN0LnByb3RvdHlwZS50b1N0cmluZy5jYWxsKG8pLnNsaWNlKDgsIC0xKTtcbiAgaWYgKG4gPT09IFwiT2JqZWN0XCIgJiYgby5jb25zdHJ1Y3RvcikgbiA9IG8uY29uc3RydWN0b3IubmFtZTtcbiAgaWYgKG4gPT09IFwiTWFwXCIgfHwgbiA9PT0gXCJTZXRcIikgcmV0dXJuIEFycmF5LmZyb20obyk7XG4gIGlmIChuID09PSBcIkFyZ3VtZW50c1wiIHx8IC9eKD86VWl8SSludCg/Ojh8MTZ8MzIpKD86Q2xhbXBlZCk/QXJyYXkkLy50ZXN0KG4pKSByZXR1cm4gX2FycmF5TGlrZVRvQXJyYXkobywgbWluTGVuKTtcbn1cblxuZnVuY3Rpb24gX2FycmF5TGlrZVRvQXJyYXkoYXJyLCBsZW4pIHtcbiAgaWYgKGxlbiA9PSBudWxsIHx8IGxlbiA+IGFyci5sZW5ndGgpIGxlbiA9IGFyci5sZW5ndGg7XG5cbiAgZm9yICh2YXIgaSA9IDAsIGFycjIgPSBuZXcgQXJyYXkobGVuKTsgaSA8IGxlbjsgaSsrKSBhcnIyW2ldID0gYXJyW2ldO1xuXG4gIHJldHVybiBhcnIyO1xufVxuXG5mdW5jdGlvbiBfbm9uSXRlcmFibGVTcHJlYWQoKSB7XG4gIHRocm93IG5ldyBUeXBlRXJyb3IoXCJJbnZhbGlkIGF0dGVtcHQgdG8gc3ByZWFkIG5vbi1pdGVyYWJsZSBpbnN0YW5jZS5cXG5JbiBvcmRlciB0byBiZSBpdGVyYWJsZSwgbm9uLWFycmF5IG9iamVjdHMgbXVzdCBoYXZlIGEgW1N5bWJvbC5pdGVyYXRvcl0oKSBtZXRob2QuXCIpO1xufVxuXG5mdW5jdGlvbiBfbm9uSXRlcmFibGVSZXN0KCkge1xuICB0aHJvdyBuZXcgVHlwZUVycm9yKFwiSW52YWxpZCBhdHRlbXB0IHRvIGRlc3RydWN0dXJlIG5vbi1pdGVyYWJsZSBpbnN0YW5jZS5cXG5JbiBvcmRlciB0byBiZSBpdGVyYWJsZSwgbm9uLWFycmF5IG9iamVjdHMgbXVzdCBoYXZlIGEgW1N5bWJvbC5pdGVyYXRvcl0oKSBtZXRob2QuXCIpO1xufVxuXG4vKipcbiAqIENvcHlyaWdodCAyMDE2IEFkZ3VhcmQgU29mdHdhcmUgTHRkXG4gKlxuICogTGljZW5zZWQgdW5kZXIgdGhlIEFwYWNoZSBMaWNlbnNlLCBWZXJzaW9uIDIuMCAodGhlIFwiTGljZW5zZVwiKTtcbiAqIHlvdSBtYXkgbm90IHVzZSB0aGlzIGZpbGUgZXhjZXB0IGluIGNvbXBsaWFuY2Ugd2l0aCB0aGUgTGljZW5zZS5cbiAqIFlvdSBtYXkgb2J0YWluIGEgY29weSBvZiB0aGUgTGljZW5zZSBhdFxuICpcbiAqIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMFxuICpcbiAqIFVubGVzcyByZXF1aXJlZCBieSBhcHBsaWNhYmxlIGxhdyBvciBhZ3JlZWQgdG8gaW4gd3JpdGluZywgc29mdHdhcmVcbiAqIGRpc3RyaWJ1dGVkIHVuZGVyIHRoZSBMaWNlbnNlIGlzIGRpc3RyaWJ1dGVkIG9uIGFuIFwiQVMgSVNcIiBCQVNJUyxcbiAqIFdJVEhPVVQgV0FSUkFOVElFUyBPUiBDT05ESVRJT05TIE9GIEFOWSBLSU5ELCBlaXRoZXIgZXhwcmVzcyBvciBpbXBsaWVkLlxuICogU2VlIHRoZSBMaWNlbnNlIGZvciB0aGUgc3BlY2lmaWMgbGFuZ3VhZ2UgZ292ZXJuaW5nIHBlcm1pc3Npb25zIGFuZFxuICogbGltaXRhdGlvbnMgdW5kZXIgdGhlIExpY2Vuc2UuXG4gKi9cblxuLyogZXNsaW50LWRpc2FibGUgbm8tY29uc29sZSAqL1xudmFyIHV0aWxzID0ge307XG51dGlscy5NdXRhdGlvbk9ic2VydmVyID0gd2luZG93Lk11dGF0aW9uT2JzZXJ2ZXIgfHwgd2luZG93LldlYktpdE11dGF0aW9uT2JzZXJ2ZXI7XG4vKipcbiAqIFN0b3JlcyBuYXRpdmUgTm9kZSB0ZXh0Q29udGVudCBnZXR0ZXIgdG8gYmUgdXNlZCBmb3IgY29udGFpbnMgcHNldWRvLWNsYXNzXG4gKiBiZWNhdXNlIGVsZW1lbnRzJyAndGV4dENvbnRlbnQnIGFuZCAnaW5uZXJUZXh0JyBwcm9wZXJ0aWVzIG1pZ2h0IGJlIG1vY2tlZFxuICogaHR0cHM6Ly9naXRodWIuY29tL0FkZ3VhcmRUZWFtL0V4dGVuZGVkQ3NzL2lzc3Vlcy8xMjdcbiAqL1xuXG51dGlscy5ub2RlVGV4dENvbnRlbnRHZXR0ZXIgPSBmdW5jdGlvbiAoKSB7XG4gIHZhciBuYXRpdmVOb2RlID0gd2luZG93Lk5vZGUgfHwgTm9kZTtcbiAgcmV0dXJuIE9iamVjdC5nZXRPd25Qcm9wZXJ0eURlc2NyaXB0b3IobmF0aXZlTm9kZS5wcm90b3R5cGUsICd0ZXh0Q29udGVudCcpLmdldDtcbn0oKTtcblxudXRpbHMuaXNTYWZhcmlCcm93c2VyID0gZnVuY3Rpb24gKCkge1xuICB2YXIgaXNDaHJvbWUgPSBuYXZpZ2F0b3IudXNlckFnZW50LmluZGV4T2YoJ0Nocm9tZScpID4gLTE7XG4gIHZhciBpc1NhZmFyaSA9IG5hdmlnYXRvci51c2VyQWdlbnQuaW5kZXhPZignU2FmYXJpJykgPiAtMTtcblxuICBpZiAoaXNTYWZhcmkpIHtcbiAgICBpZiAoaXNDaHJvbWUpIHtcbiAgICAgIC8vIENocm9tZSBzZWVtcyB0byBoYXZlIGJvdGggQ2hyb21lIGFuZCBTYWZhcmkgdXNlckFnZW50c1xuICAgICAgcmV0dXJuIGZhbHNlO1xuICAgIH1cblxuICAgIHJldHVybiB0cnVlO1xuICB9XG5cbiAgcmV0dXJuIGZhbHNlO1xufSgpO1xuLyoqXG4gKiBDb252ZXJ0cyByZWd1bGFyIGV4cHJlc3Npb25zIHBhc3NlZCBhcyBwc2V1ZG8gY2xhc3MgYXJndW1lbnRzIGludG8gUmVnRXhwIGluc3RhbmNlcy5cbiAqIEhhdmUgdG8gdW5lc2NhcGUgZG91YmxlcXVvdGUgXCIgYXMgd2VsbCwgYmVjYXVzZSB3ZSBlc2NhcGUgdGhlbSB3aGlsZSBlbmNsb3Npbmcgc3VjaFxuICogYXJndW1lbnRzIHdpdGggZG91YmxlcXVvdGVzLCBhbmQgc2l6emxlIGRvZXMgbm90IGF1dG9tYXRpY2FsbHkgdW5lc2NhcGVzIHRoZW0uXG4gKi9cblxuXG51dGlscy5wc2V1ZG9BcmdUb1JlZ2V4ID0gZnVuY3Rpb24gKHJlZ2V4U3JjLCBmbGFnKSB7XG4gIGZsYWcgPSBmbGFnIHx8ICdpJztcbiAgcmVnZXhTcmMgPSByZWdleFNyYy50cmltKCkucmVwbGFjZSgvXFxcXChbXCJcXFxcXSkvZywgJyQxJyk7XG4gIHJldHVybiBuZXcgUmVnRXhwKHJlZ2V4U3JjLCBmbGFnKTtcbn07XG4vKipcbiAqIENvbnZlcnRzIHN0cmluZyB0byB0aGUgcmVnZXhwXG4gKiBAcGFyYW0ge3N0cmluZ30gc3RyXG4gKiBAcmV0dXJucyB7UmVnRXhwfVxuICovXG5cblxudXRpbHMudG9SZWdFeHAgPSBmdW5jdGlvbiAoc3RyKSB7XG4gIGlmIChzdHJbMF0gPT09ICcvJyAmJiBzdHJbc3RyLmxlbmd0aCAtIDFdID09PSAnLycpIHtcbiAgICByZXR1cm4gbmV3IFJlZ0V4cChzdHIuc2xpY2UoMSwgLTEpKTtcbiAgfVxuXG4gIHZhciBlc2NhcGVkID0gc3RyLnJlcGxhY2UoL1suKis/XiR7fSgpfFtcXF1cXFxcXS9nLCAnXFxcXCQmJyk7XG4gIHJldHVybiBuZXcgUmVnRXhwKGVzY2FwZWQpO1xufTtcblxudXRpbHMuc3RhcnRzV2l0aCA9IGZ1bmN0aW9uIChzdHIsIHByZWZpeCkge1xuICAvLyBpZiBzdHIgPT09ICcnLCAoc3RyICYmIGZhbHNlKSB3aWxsIHJldHVybiAnJ1xuICAvLyB0aGF0J3Mgd2h5IGl0IGhhcyB0byBiZSAhIXN0clxuICByZXR1cm4gISFzdHIgJiYgc3RyLmluZGV4T2YocHJlZml4KSA9PT0gMDtcbn07XG5cbnV0aWxzLmVuZHNXaXRoID0gZnVuY3Rpb24gKHN0ciwgcG9zdGZpeCkge1xuICBpZiAoIXN0ciB8fCAhcG9zdGZpeCkge1xuICAgIHJldHVybiBmYWxzZTtcbiAgfVxuXG4gIGlmIChzdHIuZW5kc1dpdGgpIHtcbiAgICByZXR1cm4gc3RyLmVuZHNXaXRoKHBvc3RmaXgpO1xuICB9XG5cbiAgdmFyIHQgPSBTdHJpbmcocG9zdGZpeCk7XG4gIHZhciBpbmRleCA9IHN0ci5sYXN0SW5kZXhPZih0KTtcbiAgcmV0dXJuIGluZGV4ID49IDAgJiYgaW5kZXggPT09IHN0ci5sZW5ndGggLSB0Lmxlbmd0aDtcbn07XG4vKipcbiAqIEhlbHBlciBmdW5jdGlvbiBmb3IgY3JlYXRpbmcgcmVndWxhciBleHByZXNzaW9uIGZyb20gYSB1cmwgZmlsdGVyIHJ1bGUgc3ludGF4LlxuICovXG5cblxudXRpbHMuY3JlYXRlVVJMUmVnZXggPSBmdW5jdGlvbiAoKSB7XG4gIC8vIENvbnN0YW50c1xuICB2YXIgcmVnZXhDb25maWd1cmF0aW9uID0ge1xuICAgIG1hc2tTdGFydFVybDogJ3x8JyxcbiAgICBtYXNrUGlwZTogJ3wnLFxuICAgIG1hc2tTZXBhcmF0b3I6ICdeJyxcbiAgICBtYXNrQW55U3ltYm9sOiAnKicsXG4gICAgcmVnZXhBbnlTeW1ib2w6ICcuKicsXG4gICAgcmVnZXhTZXBhcmF0b3I6ICcoW14gYS16QS1aMC05LiVfLV18JCknLFxuICAgIHJlZ2V4U3RhcnRVcmw6ICdeKGh0dHB8aHR0cHN8d3N8d3NzKTovLyhbYS16MC05LV8uXStcXFxcLik/JyxcbiAgICByZWdleFN0YXJ0U3RyaW5nOiAnXicsXG4gICAgcmVnZXhFbmRTdHJpbmc6ICckJ1xuICB9OyAvLyBodHRwczovL2RldmVsb3Blci5tb3ppbGxhLm9yZy9lbi9KYXZhU2NyaXB0L1JlZmVyZW5jZS9HbG9iYWxfT2JqZWN0cy9yZWdleHBcbiAgLy8gc2hvdWxkIGJlIGVzY2FwZWQgLiAqICsgPyBeICQgeyB9ICggKSB8IFsgXSAvIFxcXG4gIC8vIGV4Y2VwdCBvZiAqIHwgXlxuXG4gIHZhciBzcGVjaWFscyA9IFsnLicsICcrJywgJz8nLCAnJCcsICd7JywgJ30nLCAnKCcsICcpJywgJ1snLCAnXScsICdcXFxcJywgJy8nXTtcbiAgdmFyIHNwZWNpYWxzUmVnZXggPSBuZXcgUmVnRXhwKFwiW1wiLmNvbmNhdChzcGVjaWFscy5qb2luKCdcXFxcJyksIFwiXVwiKSwgJ2cnKTtcbiAgLyoqXG4gICAqIEVzY2FwZXMgcmVndWxhciBleHByZXNzaW9uIHN0cmluZ1xuICAgKi9cblxuICB2YXIgZXNjYXBlUmVnRXhwID0gZnVuY3Rpb24gZXNjYXBlUmVnRXhwKHN0cikge1xuICAgIHJldHVybiBzdHIucmVwbGFjZShzcGVjaWFsc1JlZ2V4LCAnXFxcXCQmJyk7XG4gIH07XG5cbiAgdmFyIHJlcGxhY2VBbGwgPSBmdW5jdGlvbiByZXBsYWNlQWxsKHN0ciwgZmluZCwgcmVwbGFjZSkge1xuICAgIGlmICghc3RyKSB7XG4gICAgICByZXR1cm4gc3RyO1xuICAgIH1cblxuICAgIHJldHVybiBzdHIuc3BsaXQoZmluZCkuam9pbihyZXBsYWNlKTtcbiAgfTtcbiAgLyoqXG4gICAqIE1haW4gZnVuY3Rpb24gdGhhdCBjb252ZXJ0cyBhIHVybCBmaWx0ZXIgcnVsZSBzdHJpbmcgdG8gYSByZWdleC5cbiAgICogQHBhcmFtIHtzdHJpbmd9IHN0clxuICAgKiBAcmV0dXJuIHtSZWdFeHB9XG4gICAqL1xuXG5cbiAgdmFyIGNyZWF0ZVJlZ2V4VGV4dCA9IGZ1bmN0aW9uIGNyZWF0ZVJlZ2V4VGV4dChzdHIpIHtcbiAgICB2YXIgcmVnZXggPSBlc2NhcGVSZWdFeHAoc3RyKTtcblxuICAgIGlmICh1dGlscy5zdGFydHNXaXRoKHJlZ2V4LCByZWdleENvbmZpZ3VyYXRpb24ubWFza1N0YXJ0VXJsKSkge1xuICAgICAgcmVnZXggPSByZWdleC5zdWJzdHJpbmcoMCwgcmVnZXhDb25maWd1cmF0aW9uLm1hc2tTdGFydFVybC5sZW5ndGgpICsgcmVwbGFjZUFsbChyZWdleC5zdWJzdHJpbmcocmVnZXhDb25maWd1cmF0aW9uLm1hc2tTdGFydFVybC5sZW5ndGgsIHJlZ2V4Lmxlbmd0aCAtIDEpLCAnXFx8JywgJ1xcXFx8JykgKyByZWdleC5zdWJzdHJpbmcocmVnZXgubGVuZ3RoIC0gMSk7XG4gICAgfSBlbHNlIGlmICh1dGlscy5zdGFydHNXaXRoKHJlZ2V4LCByZWdleENvbmZpZ3VyYXRpb24ubWFza1BpcGUpKSB7XG4gICAgICByZWdleCA9IHJlZ2V4LnN1YnN0cmluZygwLCByZWdleENvbmZpZ3VyYXRpb24ubWFza1BpcGUubGVuZ3RoKSArIHJlcGxhY2VBbGwocmVnZXguc3Vic3RyaW5nKHJlZ2V4Q29uZmlndXJhdGlvbi5tYXNrUGlwZS5sZW5ndGgsIHJlZ2V4Lmxlbmd0aCAtIDEpLCAnXFx8JywgJ1xcXFx8JykgKyByZWdleC5zdWJzdHJpbmcocmVnZXgubGVuZ3RoIC0gMSk7XG4gICAgfSBlbHNlIHtcbiAgICAgIHJlZ2V4ID0gcmVwbGFjZUFsbChyZWdleC5zdWJzdHJpbmcoMCwgcmVnZXgubGVuZ3RoIC0gMSksICdcXHwnLCAnXFxcXHwnKSArIHJlZ2V4LnN1YnN0cmluZyhyZWdleC5sZW5ndGggLSAxKTtcbiAgICB9IC8vIFJlcGxhY2luZyBzcGVjaWFsIHVybCBtYXNrc1xuXG5cbiAgICByZWdleCA9IHJlcGxhY2VBbGwocmVnZXgsIHJlZ2V4Q29uZmlndXJhdGlvbi5tYXNrQW55U3ltYm9sLCByZWdleENvbmZpZ3VyYXRpb24ucmVnZXhBbnlTeW1ib2wpO1xuICAgIHJlZ2V4ID0gcmVwbGFjZUFsbChyZWdleCwgcmVnZXhDb25maWd1cmF0aW9uLm1hc2tTZXBhcmF0b3IsIHJlZ2V4Q29uZmlndXJhdGlvbi5yZWdleFNlcGFyYXRvcik7XG5cbiAgICBpZiAodXRpbHMuc3RhcnRzV2l0aChyZWdleCwgcmVnZXhDb25maWd1cmF0aW9uLm1hc2tTdGFydFVybCkpIHtcbiAgICAgIHJlZ2V4ID0gcmVnZXhDb25maWd1cmF0aW9uLnJlZ2V4U3RhcnRVcmwgKyByZWdleC5zdWJzdHJpbmcocmVnZXhDb25maWd1cmF0aW9uLm1hc2tTdGFydFVybC5sZW5ndGgpO1xuICAgIH0gZWxzZSBpZiAodXRpbHMuc3RhcnRzV2l0aChyZWdleCwgcmVnZXhDb25maWd1cmF0aW9uLm1hc2tQaXBlKSkge1xuICAgICAgcmVnZXggPSByZWdleENvbmZpZ3VyYXRpb24ucmVnZXhTdGFydFN0cmluZyArIHJlZ2V4LnN1YnN0cmluZyhyZWdleENvbmZpZ3VyYXRpb24ubWFza1BpcGUubGVuZ3RoKTtcbiAgICB9XG5cbiAgICBpZiAodXRpbHMuZW5kc1dpdGgocmVnZXgsIHJlZ2V4Q29uZmlndXJhdGlvbi5tYXNrUGlwZSkpIHtcbiAgICAgIHJlZ2V4ID0gcmVnZXguc3Vic3RyaW5nKDAsIHJlZ2V4Lmxlbmd0aCAtIDEpICsgcmVnZXhDb25maWd1cmF0aW9uLnJlZ2V4RW5kU3RyaW5nO1xuICAgIH1cblxuICAgIHJldHVybiBuZXcgUmVnRXhwKHJlZ2V4LCAnaScpO1xuICB9O1xuXG4gIHJldHVybiBjcmVhdGVSZWdleFRleHQ7XG59KCk7XG4vKipcbiAqIENyZWF0ZXMgYW4gb2JqZWN0IGltcGxlbWVudGluZyBMb2NhdGlvbiBpbnRlcmZhY2UgZnJvbSBhIHVybC5cbiAqIEFuIGFsdGVybmF0aXZlIHRvIFVSTC5cbiAqIGh0dHBzOi8vZ2l0aHViLmNvbS9BZGd1YXJkVGVhbS9GaW5nZXJwcmludGluZ0Jsb2NrZXIvYmxvYi9tYXN0ZXIvc3JjL3NoYXJlZC91cmwudHMjTDY0XG4gKi9cblxuXG51dGlscy5jcmVhdGVMb2NhdGlvbiA9IGZ1bmN0aW9uIChocmVmKSB7XG4gIHZhciBhbmNob3IgPSBkb2N1bWVudC5jcmVhdGVFbGVtZW50KCdhJyk7XG4gIGFuY2hvci5ocmVmID0gaHJlZjtcblxuICBpZiAoYW5jaG9yLmhvc3QgPT09ICcnKSB7XG4gICAgYW5jaG9yLmhyZWYgPSBhbmNob3IuaHJlZjsgLy8gZXNsaW50LWRpc2FibGUtbGluZSBuby1zZWxmLWFzc2lnblxuICB9XG5cbiAgcmV0dXJuIGFuY2hvcjtcbn07XG4vKipcbiAqIENoZWNrcyB3aGV0aGVyIEEgaGFzIHRoZSBzYW1lIG9yaWdpbiBhcyBCLlxuICogQHBhcmFtIHtzdHJpbmd9IHVybEEgbG9jYXRpb24uaHJlZiBvZiBBLlxuICogQHBhcmFtIHtMb2NhdGlvbn0gbG9jYXRpb25CIGxvY2F0aW9uIG9mIEIuXG4gKiBAcGFyYW0ge3N0cmluZ30gZG9tYWluQiBkb2N1bWVudC5kb21haW4gb2YgQi5cbiAqIEByZXR1cm4ge2Jvb2xlYW59XG4gKi9cblxuXG51dGlscy5pc1NhbWVPcmlnaW4gPSBmdW5jdGlvbiAodXJsQSwgbG9jYXRpb25CLCBkb21haW5CKSB7XG4gIHZhciBsb2NhdGlvbkEgPSB1dGlscy5jcmVhdGVMb2NhdGlvbih1cmxBKTsgLy8gZXNsaW50LWRpc2FibGUtbmV4dC1saW5lIG5vLXNjcmlwdC11cmxcblxuICBpZiAobG9jYXRpb25BLnByb3RvY29sID09PSAnamF2YXNjcmlwdDonIHx8IGxvY2F0aW9uQS5ocmVmID09PSAnYWJvdXQ6YmxhbmsnKSB7XG4gICAgcmV0dXJuIHRydWU7XG4gIH1cblxuICBpZiAobG9jYXRpb25BLnByb3RvY29sID09PSAnZGF0YTonIHx8IGxvY2F0aW9uQS5wcm90b2NvbCA9PT0gJ2ZpbGU6Jykge1xuICAgIHJldHVybiBmYWxzZTtcbiAgfVxuXG4gIHJldHVybiBsb2NhdGlvbkEuaG9zdG5hbWUgPT09IGRvbWFpbkIgJiYgbG9jYXRpb25BLnBvcnQgPT09IGxvY2F0aW9uQi5wb3J0ICYmIGxvY2F0aW9uQS5wcm90b2NvbCA9PT0gbG9jYXRpb25CLnByb3RvY29sO1xufTtcbi8qKlxuICogQSBoZWxwZXIgY2xhc3MgdG8gdGhyb3R0bGUgZnVuY3Rpb24gY2FsbHMgd2l0aCBzZXRUaW1lb3V0IGFuZCByZXF1ZXN0QW5pbWF0aW9uRnJhbWUuXG4gKi9cblxuXG51dGlscy5Bc3luY1dyYXBwZXIgPSBmdW5jdGlvbiAoKSB7XG4gIC8qKlxuICAgKiBQaGFudG9tSlMgcGFzc2VzIGEgd3JvbmcgdGltZXN0YW1wIHRvIHRoZSByZXF1ZXN0QW5pbWF0aW9uRnJhbWUgY2FsbGJhY2sgYW5kIHRoYXQgYnJlYWtzIHRoZSBBc3luY1dyYXBwZXIgbG9naWNcbiAgICogaHR0cHM6Ly9naXRodWIuY29tL2FyaXlhL3BoYW50b21qcy9pc3N1ZXMvMTQ4MzJcbiAgICovXG4gIHZhciBzdXBwb3J0ZWQgPSB0eXBlb2Ygd2luZG93LnJlcXVlc3RBbmltYXRpb25GcmFtZSAhPT0gJ3VuZGVmaW5lZCcgJiYgIS9waGFudG9tL2kudGVzdChuYXZpZ2F0b3IudXNlckFnZW50KTtcbiAgdmFyIHJBRiA9IHN1cHBvcnRlZCA/IHJlcXVlc3RBbmltYXRpb25GcmFtZSA6IHNldFRpbWVvdXQ7XG4gIHZhciBjQUYgPSBzdXBwb3J0ZWQgPyBjYW5jZWxBbmltYXRpb25GcmFtZSA6IGNsZWFyVGltZW91dDtcbiAgdmFyIHBlcmYgPSBzdXBwb3J0ZWQgPyBwZXJmb3JtYW5jZSA6IERhdGU7XG4gIC8qKlxuICAgKiBAcGFyYW0ge0Z1bmN0aW9ufSBjYWxsYmFja1xuICAgKiBAcGFyYW0ge251bWJlcn0gdGhyb3R0bGUgbnVtYmVyLCB0aGUgcHJvdmlkZWQgY2FsbGJhY2sgc2hvdWxkIGJlIGV4ZWN1dGVkIHR3aWNlXG4gICAqIGluIHRoaXMgdGltZSBmcmFtZS5cbiAgICogQGNvbnN0cnVjdG9yXG4gICAqL1xuXG4gIGZ1bmN0aW9uIEFzeW5jV3JhcHBlcihjYWxsYmFjaywgdGhyb3R0bGUpIHtcbiAgICB0aGlzLmNhbGxiYWNrID0gY2FsbGJhY2s7XG4gICAgdGhpcy50aHJvdHRsZSA9IHRocm90dGxlO1xuICAgIHRoaXMud3JhcHBlZENhbGxiYWNrID0gdGhpcy53cmFwcGVkQ2FsbGJhY2suYmluZCh0aGlzKTtcblxuICAgIGlmICh0aGlzLndyYXBwZWRBc2FwQ2FsbGJhY2spIHtcbiAgICAgIHRoaXMud3JhcHBlZEFzYXBDYWxsYmFjayA9IHRoaXMud3JhcHBlZEFzYXBDYWxsYmFjay5iaW5kKHRoaXMpO1xuICAgIH1cbiAgfVxuICAvKiogQHByaXZhdGUgKi9cblxuXG4gIEFzeW5jV3JhcHBlci5wcm90b3R5cGUud3JhcHBlZENhbGxiYWNrID0gZnVuY3Rpb24gKHRzKSB7XG4gICAgdGhpcy5sYXN0UnVuID0gaXNOdW1iZXIodHMpID8gdHMgOiBwZXJmLm5vdygpO1xuICAgIGRlbGV0ZSB0aGlzLnJBRmlkO1xuICAgIGRlbGV0ZSB0aGlzLnRpbWVySWQ7XG4gICAgZGVsZXRlIHRoaXMuYXNhcFNjaGVkdWxlZDtcbiAgICB0aGlzLmNhbGxiYWNrKCk7XG4gIH07XG4gIC8qKiBAcHJpdmF0ZSBJbmRpY2F0ZXMgd2hldGhlciB0aGVyZSBpcyBhIHNjaGVkdWxlZCBjYWxsYmFjay4gKi9cblxuXG4gIEFzeW5jV3JhcHBlci5wcm90b3R5cGUuaGFzUGVuZGluZ0NhbGxiYWNrID0gZnVuY3Rpb24gKCkge1xuICAgIHJldHVybiBpc051bWJlcih0aGlzLnJBRmlkKSB8fCBpc051bWJlcih0aGlzLnRpbWVySWQpO1xuICB9O1xuICAvKipcbiAgICogU2NoZWR1bGVzIGEgZnVuY3Rpb24gY2FsbCBiZWZvcmUgdGhlIG5leHQgYW5pbWF0aW9uIGZyYW1lLlxuICAgKi9cblxuXG4gIEFzeW5jV3JhcHBlci5wcm90b3R5cGUucnVuID0gZnVuY3Rpb24gKCkge1xuICAgIGlmICh0aGlzLmhhc1BlbmRpbmdDYWxsYmFjaygpKSB7XG4gICAgICAvLyBUaGVyZSBpcyBhIHBlbmRpbmcgZXhlY3V0aW9uIHNjaGVkdWxlZC5cbiAgICAgIHJldHVybjtcbiAgICB9XG5cbiAgICBpZiAodHlwZW9mIHRoaXMubGFzdFJ1biAhPT0gJ3VuZGVmaW5lZCcpIHtcbiAgICAgIHZhciBlbGFwc2VkID0gcGVyZi5ub3coKSAtIHRoaXMubGFzdFJ1bjtcblxuICAgICAgaWYgKGVsYXBzZWQgPCB0aGlzLnRocm90dGxlKSB7XG4gICAgICAgIHRoaXMudGltZXJJZCA9IHNldFRpbWVvdXQodGhpcy53cmFwcGVkQ2FsbGJhY2ssIHRoaXMudGhyb3R0bGUgLSBlbGFwc2VkKTtcbiAgICAgICAgcmV0dXJuO1xuICAgICAgfVxuICAgIH1cblxuICAgIHRoaXMuckFGaWQgPSByQUYodGhpcy53cmFwcGVkQ2FsbGJhY2spO1xuICB9O1xuICAvKipcbiAgICogU2NoZWR1bGVzIGEgZnVuY3Rpb24gY2FsbCBpbiB0aGUgbW9zdCBpbW1lbmVudCBtaWNyb3Rhc2suXG4gICAqIFRoaXMgY2Fubm90IGJlIGNhbmNlbGVkLlxuICAgKi9cblxuXG4gIEFzeW5jV3JhcHBlci5wcm90b3R5cGUucnVuQXNhcCA9IGZ1bmN0aW9uICgpIHtcbiAgICBpZiAodGhpcy5hc2FwU2NoZWR1bGVkKSB7XG4gICAgICByZXR1cm47XG4gICAgfVxuXG4gICAgdGhpcy5hc2FwU2NoZWR1bGVkID0gdHJ1ZTtcbiAgICBjQUYodGhpcy5yQUZpZCk7XG4gICAgY2xlYXJUaW1lb3V0KHRoaXMudGltZXJJZCk7XG5cbiAgICBpZiAodXRpbHMuTXV0YXRpb25PYnNlcnZlcikge1xuICAgICAgLyoqXG4gICAgICAgKiBVc2luZyBNdXRhdGlvbk9ic2VydmVycyB0byBhY2Nlc3MgbWljcm90YXNrIHF1ZXVlIGlzIGEgc3RhbmRhcmQgdGVjaG5pcXVlLFxuICAgICAgICogdXNlZCBpbiBBU0FQIGxpYnJhcnlcbiAgICAgICAqIHtAbGluayBodHRwczovL2dpdGh1Yi5jb20va3Jpc2tvd2FsL2FzYXAvYmxvYi9tYXN0ZXIvYnJvd3Nlci1yYXcuanMjTDE0MH1cbiAgICAgICAqL1xuICAgICAgaWYgKCF0aGlzLm1vKSB7XG4gICAgICAgIHRoaXMubW8gPSBuZXcgdXRpbHMuTXV0YXRpb25PYnNlcnZlcih0aGlzLndyYXBwZWRDYWxsYmFjayk7XG4gICAgICAgIHRoaXMubm9kZSA9IGRvY3VtZW50LmNyZWF0ZVRleHROb2RlKDEpO1xuICAgICAgICB0aGlzLm1vLm9ic2VydmUodGhpcy5ub2RlLCB7XG4gICAgICAgICAgY2hhcmFjdGVyRGF0YTogdHJ1ZVxuICAgICAgICB9KTtcbiAgICAgIH1cblxuICAgICAgdGhpcy5ub2RlLm5vZGVWYWx1ZSA9IC10aGlzLm5vZGUubm9kZVZhbHVlO1xuICAgIH0gZWxzZSB7XG4gICAgICBzZXRUaW1lb3V0KHRoaXMud3JhcHBlZENhbGxiYWNrKTtcbiAgICB9XG4gIH07XG4gIC8qKlxuICAgKiBSdW5zIHNjaGVkdWxlZCBleGVjdXRpb24gaW1tZWRpYXRlbHksIGlmIHRoZXJlIHdlcmUgYW55LlxuICAgKi9cblxuXG4gIEFzeW5jV3JhcHBlci5wcm90b3R5cGUucnVuSW1tZWRpYXRlbHkgPSBmdW5jdGlvbiAoKSB7XG4gICAgaWYgKHRoaXMuaGFzUGVuZGluZ0NhbGxiYWNrKCkpIHtcbiAgICAgIGNBRih0aGlzLnJBRmlkKTtcbiAgICAgIGNsZWFyVGltZW91dCh0aGlzLnRpbWVySWQpO1xuICAgICAgZGVsZXRlIHRoaXMuckFGaWQ7XG4gICAgICBkZWxldGUgdGhpcy50aW1lcklkO1xuICAgICAgdGhpcy53cmFwcGVkQ2FsbGJhY2soKTtcbiAgICB9XG4gIH07XG5cbiAgQXN5bmNXcmFwcGVyLm5vdyA9IGZ1bmN0aW9uICgpIHtcbiAgICByZXR1cm4gcGVyZi5ub3coKTtcbiAgfTtcblxuICByZXR1cm4gQXN5bmNXcmFwcGVyO1xufSgpO1xuLyoqXG4gKiBTdG9yZXMgbmF0aXZlIE9kUCB0byBiZSB1c2VkIGluIFdlYWtNYXAgYW5kIFNldCBwb2x5ZmlsbHMuXG4gKi9cblxuXG51dGlscy5kZWZpbmVQcm9wZXJ0eSA9IE9iamVjdC5kZWZpbmVQcm9wZXJ0eTtcbnV0aWxzLldlYWtNYXAgPSB0eXBlb2YgV2Vha01hcCAhPT0gJ3VuZGVmaW5lZCcgPyBXZWFrTWFwIDogZnVuY3Rpb24gKCkge1xuICAvKiogT3JpZ2luYWxseSBiYXNlZCBvbiB7QGxpbmsgaHR0cHM6Ly9naXRodWIuY29tL1BvbHltZXIvV2Vha01hcH0gKi9cbiAgdmFyIGNvdW50ZXIgPSBEYXRlLm5vdygpICUgMWU5O1xuXG4gIHZhciBXZWFrTWFwID0gZnVuY3Rpb24gV2Vha01hcCgpIHtcbiAgICB0aGlzLm5hbWUgPSBcIl9fc3RcIi5jb25jYXQoTWF0aC5yYW5kb20oKSAqIDFlOSA+Pj4gMCkuY29uY2F0KGNvdW50ZXIrKywgXCJfX1wiKTtcbiAgfTtcblxuICBXZWFrTWFwLnByb3RvdHlwZSA9IHtcbiAgICBzZXQ6IGZ1bmN0aW9uIHNldChrZXksIHZhbHVlKSB7XG4gICAgICB2YXIgZW50cnkgPSBrZXlbdGhpcy5uYW1lXTtcblxuICAgICAgaWYgKGVudHJ5ICYmIGVudHJ5WzBdID09PSBrZXkpIHtcbiAgICAgICAgZW50cnlbMV0gPSB2YWx1ZTtcbiAgICAgIH0gZWxzZSB7XG4gICAgICAgIHV0aWxzLmRlZmluZVByb3BlcnR5KGtleSwgdGhpcy5uYW1lLCB7XG4gICAgICAgICAgdmFsdWU6IFtrZXksIHZhbHVlXSxcbiAgICAgICAgICB3cml0YWJsZTogdHJ1ZVxuICAgICAgICB9KTtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIHRoaXM7XG4gICAgfSxcbiAgICBnZXQ6IGZ1bmN0aW9uIGdldChrZXkpIHtcbiAgICAgIHZhciBlbnRyeSA9IGtleVt0aGlzLm5hbWVdO1xuICAgICAgcmV0dXJuIGVudHJ5ICYmIGVudHJ5WzBdID09PSBrZXkgPyBlbnRyeVsxXSA6IHVuZGVmaW5lZDtcbiAgICB9LFxuICAgIGRlbGV0ZTogZnVuY3Rpb24gX2RlbGV0ZShrZXkpIHtcbiAgICAgIHZhciBlbnRyeSA9IGtleVt0aGlzLm5hbWVdO1xuXG4gICAgICBpZiAoIWVudHJ5KSB7XG4gICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgIH1cblxuICAgICAgdmFyIGhhc1ZhbHVlID0gZW50cnlbMF0gPT09IGtleTtcbiAgICAgIGRlbGV0ZSBlbnRyeVswXTtcbiAgICAgIGRlbGV0ZSBlbnRyeVsxXTtcbiAgICAgIHJldHVybiBoYXNWYWx1ZTtcbiAgICB9LFxuICAgIGhhczogZnVuY3Rpb24gaGFzKGtleSkge1xuICAgICAgdmFyIGVudHJ5ID0ga2V5W3RoaXMubmFtZV07XG5cbiAgICAgIGlmICghZW50cnkpIHtcbiAgICAgICAgcmV0dXJuIGZhbHNlO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gZW50cnlbMF0gPT09IGtleTtcbiAgICB9XG4gIH07XG4gIHJldHVybiBXZWFrTWFwO1xufSgpO1xudXRpbHMuU2V0ID0gdHlwZW9mIFNldCAhPT0gJ3VuZGVmaW5lZCcgPyBTZXQgOiBmdW5jdGlvbiAoKSB7XG4gIHZhciBjb3VudGVyID0gRGF0ZS5ub3coKSAlIDFlOTtcbiAgLyoqXG4gICAqIEEgcG9seWZpbGwgd2hpY2ggY292ZXJzIG9ubHkgdGhlIGJhc2ljIHVzYWdlLlxuICAgKiBPbmx5IHN1cHBvcnRzIG1ldGhvZHMgdGhhdCBhcmUgc3VwcG9ydGVkIGluIElFMTEuXG4gICAqIHtAbGluayBodHRwczovL2RvY3MubWljcm9zb2Z0LmNvbS9lbi11cy9zY3JpcHRpbmcvamF2YXNjcmlwdC9yZWZlcmVuY2Uvc2V0LW9iamVjdC1qYXZhc2NyaXB0fVxuICAgKiBBc3N1bWVzIHRoYXQgJ2tleSdzIGFyZSBhbGwgb2JqZWN0cywgbm90IHByaW1pdGl2ZXMgc3VjaCBhcyBhIG51bWJlci5cbiAgICpcbiAgICogQHBhcmFtIHtBcnJheX0gaXRlbXMgSW5pdGlhbCBpdGVtcyBpbiB0aGlzIHNldFxuICAgKi9cblxuICB2YXIgU2V0ID0gZnVuY3Rpb24gU2V0KGl0ZW1zKSB7XG4gICAgdGhpcy5uYW1lID0gXCJfX3N0XCIuY29uY2F0KE1hdGgucmFuZG9tKCkgKiAxZTkgPj4+IDApLmNvbmNhdChjb3VudGVyKyssIFwiX19cIik7XG4gICAgdGhpcy5rZXlzID0gW107XG5cbiAgICBpZiAoaXRlbXMgJiYgaXRlbXMubGVuZ3RoKSB7XG4gICAgICB2YXIgaUl0ZW1zID0gaXRlbXMubGVuZ3RoO1xuXG4gICAgICB3aGlsZSAoaUl0ZW1zLS0pIHtcbiAgICAgICAgdGhpcy5hZGQoaXRlbXNbaUl0ZW1zXSk7XG4gICAgICB9XG4gICAgfVxuICB9O1xuXG4gIFNldC5wcm90b3R5cGUgPSB7XG4gICAgYWRkOiBmdW5jdGlvbiBhZGQoa2V5KSB7XG4gICAgICBpZiAoIWlzTnVtYmVyKGtleVt0aGlzLm5hbWVdKSkge1xuICAgICAgICB2YXIgaW5kZXggPSB0aGlzLmtleXMucHVzaChrZXkpIC0gMTtcbiAgICAgICAgdXRpbHMuZGVmaW5lUHJvcGVydHkoa2V5LCB0aGlzLm5hbWUsIHtcbiAgICAgICAgICB2YWx1ZTogaW5kZXgsXG4gICAgICAgICAgd3JpdGFibGU6IHRydWVcbiAgICAgICAgfSk7XG4gICAgICB9XG4gICAgfSxcbiAgICBkZWxldGU6IGZ1bmN0aW9uIF9kZWxldGUoa2V5KSB7XG4gICAgICBpZiAoaXNOdW1iZXIoa2V5W3RoaXMubmFtZV0pKSB7XG4gICAgICAgIHZhciBpbmRleCA9IGtleVt0aGlzLm5hbWVdO1xuICAgICAgICBkZWxldGUgdGhpcy5rZXlzW2luZGV4XTtcbiAgICAgICAga2V5W3RoaXMubmFtZV0gPSB1bmRlZmluZWQ7XG4gICAgICB9XG4gICAgfSxcbiAgICBoYXM6IGZ1bmN0aW9uIGhhcyhrZXkpIHtcbiAgICAgIHJldHVybiBpc051bWJlcihrZXlbdGhpcy5uYW1lXSk7XG4gICAgfSxcbiAgICBjbGVhcjogZnVuY3Rpb24gY2xlYXIoKSB7XG4gICAgICB0aGlzLmtleXMuZm9yRWFjaChmdW5jdGlvbiAoa2V5KSB7XG4gICAgICAgIGtleVt0aGlzLm5hbWVdID0gdW5kZWZpbmVkO1xuICAgICAgfSk7XG4gICAgICB0aGlzLmtleXMubGVuZ3RoID0gMDtcbiAgICB9LFxuICAgIGZvckVhY2g6IGZ1bmN0aW9uIGZvckVhY2goY2IpIHtcbiAgICAgIHZhciB0aGF0ID0gdGhpcztcbiAgICAgIHRoaXMua2V5cy5mb3JFYWNoKGZ1bmN0aW9uICh2YWx1ZSkge1xuICAgICAgICBjYih2YWx1ZSwgdmFsdWUsIHRoYXQpO1xuICAgICAgfSk7XG4gICAgfVxuICB9O1xuICB1dGlscy5kZWZpbmVQcm9wZXJ0eShTZXQucHJvdG90eXBlLCAnc2l6ZScsIHtcbiAgICBnZXQ6IGZ1bmN0aW9uIGdldCgpIHtcbiAgICAgIC8vIFNraXBzIGhvbGVzLlxuICAgICAgcmV0dXJuIHRoaXMua2V5cy5yZWR1Y2UoZnVuY3Rpb24gKGFjYykge1xuICAgICAgICByZXR1cm4gYWNjICsgMTtcbiAgICAgIH0sIDApO1xuICAgIH1cbiAgfSk7XG4gIHJldHVybiBTZXQ7XG59KCk7XG4vKipcbiAqIFZlbmRvci1zcGVjaWZpYyBFbGVtZW50LnByb3RvdHlwZS5tYXRjaGVzXG4gKi9cblxudXRpbHMubWF0Y2hlc1Byb3BlcnR5TmFtZSA9IGZ1bmN0aW9uICgpIHtcbiAgdmFyIHByb3BzID0gWydtYXRjaGVzJywgJ21hdGNoZXNTZWxlY3RvcicsICdtb3pNYXRjaGVzU2VsZWN0b3InLCAnbXNNYXRjaGVzU2VsZWN0b3InLCAnb01hdGNoZXNTZWxlY3RvcicsICd3ZWJraXRNYXRjaGVzU2VsZWN0b3InXTtcblxuICBmb3IgKHZhciBpID0gMDsgaSA8IDY7IGkrKykge1xuICAgIGlmIChFbGVtZW50LnByb3RvdHlwZS5oYXNPd25Qcm9wZXJ0eShwcm9wc1tpXSkpIHtcbiAgICAgIHJldHVybiBwcm9wc1tpXTtcbiAgICB9XG4gIH1cbn0oKTtcbi8qKlxuICogUHJvdmlkZXMgc3RhdHMgaW5mb3JtYXRpb25cbiAqL1xuXG5cbnV0aWxzLlN0YXRzID0gZnVuY3Rpb24gKCkge1xuICAvKiogQG1lbWJlciB7QXJyYXk8bnVtYmVyPn0gKi9cbiAgdGhpcy5hcnJheSA9IFtdO1xuICAvKiogQG1lbWJlciB7bnVtYmVyfSAqL1xuXG4gIHRoaXMubGVuZ3RoID0gMDtcbiAgdmFyIHplcm9EZXNjcmlwdG9yID0ge1xuICAgIHZhbHVlOiAwLFxuICAgIHdyaXRhYmxlOiB0cnVlXG4gIH07XG4gIC8qKiBAbWVtYmVyIHtudW1iZXJ9IEBwcml2YXRlICovXG5cbiAgT2JqZWN0LmRlZmluZVByb3BlcnR5KHRoaXMsICdzdW0nLCB6ZXJvRGVzY3JpcHRvcik7XG4gIC8qKiBAbWVtYmVyIHtudW1iZXJ9IEBwcml2YXRlICovXG5cbiAgT2JqZWN0LmRlZmluZVByb3BlcnR5KHRoaXMsICdzcXVhcmVkU3VtJywgemVyb0Rlc2NyaXB0b3IpO1xufTtcbi8qKlxuICogQHBhcmFtIHtudW1iZXJ9IGRhdGFQb2ludCBkYXRhIHBvaW50XG4gKi9cblxuXG51dGlscy5TdGF0cy5wcm90b3R5cGUucHVzaCA9IGZ1bmN0aW9uIChkYXRhUG9pbnQpIHtcbiAgdGhpcy5hcnJheS5wdXNoKGRhdGFQb2ludCk7XG4gIHRoaXMubGVuZ3RoKys7XG4gIHRoaXMuc3VtICs9IGRhdGFQb2ludDtcbiAgdGhpcy5zcXVhcmVkU3VtICs9IGRhdGFQb2ludCAqIGRhdGFQb2ludDtcbiAgLyoqIEBtZW1iZXIge251bWJlcn0gKi9cblxuICB0aGlzLm1lYW4gPSB0aGlzLnN1bSAvIHRoaXMubGVuZ3RoO1xuICAvKiogQG1lbWJlciB7bnVtYmVyfSAqL1xuICAvLyBlc2xpbnQtZGlzYWJsZS1uZXh0LWxpbmUgbm8tcmVzdHJpY3RlZC1wcm9wZXJ0aWVzXG5cbiAgdGhpcy5zdGRkZXYgPSBNYXRoLnNxcnQodGhpcy5zcXVhcmVkU3VtIC8gdGhpcy5sZW5ndGggLSBNYXRoLnBvdyh0aGlzLm1lYW4sIDIpKTtcbn07XG4vKiogU2FmZSBjb25zb2xlLmVycm9yIHZlcnNpb24gKi9cblxuXG51dGlscy5sb2dFcnJvciA9IHR5cGVvZiBjb25zb2xlICE9PSAndW5kZWZpbmVkJyAmJiBjb25zb2xlLmVycm9yICYmIEZ1bmN0aW9uLnByb3RvdHlwZS5iaW5kICYmIGNvbnNvbGUuZXJyb3IuYmluZCA/IGNvbnNvbGUuZXJyb3IuYmluZCh3aW5kb3cuY29uc29sZSkgOiBjb25zb2xlLmVycm9yO1xuLyoqIFNhZmUgY29uc29sZS5pbmZvIHZlcnNpb24gKi9cblxudXRpbHMubG9nSW5mbyA9IHR5cGVvZiBjb25zb2xlICE9PSAndW5kZWZpbmVkJyAmJiBjb25zb2xlLmluZm8gJiYgRnVuY3Rpb24ucHJvdG90eXBlLmJpbmQgJiYgY29uc29sZS5pbmZvLmJpbmQgPyBjb25zb2xlLmluZm8uYmluZCh3aW5kb3cuY29uc29sZSkgOiBjb25zb2xlLmluZm87XG5cbmZ1bmN0aW9uIGlzTnVtYmVyKG9iaikge1xuICByZXR1cm4gdHlwZW9mIG9iaiA9PT0gJ251bWJlcic7XG59XG4vKipcbiAqIFJldHVybnMgcGF0aCB0byBlbGVtZW50IHdlIHdpbGwgdXNlIGFzIGVsZW1lbnQgaWRlbnRpZmllclxuICogQHBhcmFtIHtFbGVtZW50fSBpbnB1dEVsXG4gKiBAcmV0dXJucyB7c3RyaW5nfSAtIHBhdGggdG8gdGhlIGVsZW1lbnRcbiAqL1xuXG5cbnV0aWxzLmdldE5vZGVTZWxlY3RvciA9IGZ1bmN0aW9uIChpbnB1dEVsKSB7XG4gIGlmICghKGlucHV0RWwgaW5zdGFuY2VvZiBFbGVtZW50KSkge1xuICAgIHRocm93IG5ldyBFcnJvcignRnVuY3Rpb24gcmVjZWl2ZWQgYXJndW1lbnQgd2l0aCB3cm9uZyB0eXBlJyk7XG4gIH1cblxuICB2YXIgZWwgPSBpbnB1dEVsO1xuICB2YXIgcGF0aCA9IFtdOyAvLyB3ZSBuZWVkIHRvIGNoZWNrICchIWVsJyBmaXJzdCBiZWNhdXNlIGl0IGlzIHBvc3NpYmxlXG4gIC8vIHRoYXQgc29tZSBhbmNlc3RvciBvZiB0aGUgaW5wdXRFbCB3YXMgcmVtb3ZlZCBiZWZvcmUgaXRcblxuICB3aGlsZSAoISFlbCAmJiBlbC5ub2RlVHlwZSA9PT0gTm9kZS5FTEVNRU5UX05PREUpIHtcbiAgICB2YXIgc2VsZWN0b3IgPSBlbC5ub2RlTmFtZS50b0xvd2VyQ2FzZSgpO1xuXG4gICAgaWYgKGVsLmlkICYmIHR5cGVvZiBlbC5pZCA9PT0gJ3N0cmluZycpIHtcbiAgICAgIHNlbGVjdG9yICs9IFwiI1wiLmNvbmNhdChlbC5pZCk7XG4gICAgICBwYXRoLnVuc2hpZnQoc2VsZWN0b3IpO1xuICAgICAgYnJlYWs7XG4gICAgfSBlbHNlIHtcbiAgICAgIHZhciBzaWJsaW5nID0gZWw7XG4gICAgICB2YXIgbnRoID0gMTtcblxuICAgICAgd2hpbGUgKHNpYmxpbmcucHJldmlvdXNTaWJsaW5nKSB7XG4gICAgICAgIHNpYmxpbmcgPSBzaWJsaW5nLnByZXZpb3VzU2libGluZztcblxuICAgICAgICBpZiAoc2libGluZy5ub2RlVHlwZSA9PT0gTm9kZS5FTEVNRU5UX05PREUgJiYgc2libGluZy5ub2RlTmFtZS50b0xvd2VyQ2FzZSgpID09PSBzZWxlY3Rvcikge1xuICAgICAgICAgIG50aCsrO1xuICAgICAgICB9XG4gICAgICB9XG5cbiAgICAgIGlmIChudGggIT09IDEpIHtcbiAgICAgICAgc2VsZWN0b3IgKz0gXCI6bnRoLW9mLXR5cGUoXCIuY29uY2F0KG50aCwgXCIpXCIpO1xuICAgICAgfVxuICAgIH1cblxuICAgIHBhdGgudW5zaGlmdChzZWxlY3Rvcik7XG4gICAgZWwgPSBlbC5wYXJlbnROb2RlO1xuICB9XG5cbiAgcmV0dXJuIHBhdGguam9pbignID4gJyk7XG59O1xuXG4vKipcbiAqIENvcHlyaWdodCAyMDE2IEFkZ3VhcmQgU29mdHdhcmUgTHRkXG4gKlxuICogTGljZW5zZWQgdW5kZXIgdGhlIEFwYWNoZSBMaWNlbnNlLCBWZXJzaW9uIDIuMCAodGhlIFwiTGljZW5zZVwiKTtcbiAqIHlvdSBtYXkgbm90IHVzZSB0aGlzIGZpbGUgZXhjZXB0IGluIGNvbXBsaWFuY2Ugd2l0aCB0aGUgTGljZW5zZS5cbiAqIFlvdSBtYXkgb2J0YWluIGEgY29weSBvZiB0aGUgTGljZW5zZSBhdFxuICpcbiAqIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMFxuICpcbiAqIFVubGVzcyByZXF1aXJlZCBieSBhcHBsaWNhYmxlIGxhdyBvciBhZ3JlZWQgdG8gaW4gd3JpdGluZywgc29mdHdhcmVcbiAqIGRpc3RyaWJ1dGVkIHVuZGVyIHRoZSBMaWNlbnNlIGlzIGRpc3RyaWJ1dGVkIG9uIGFuIFwiQVMgSVNcIiBCQVNJUyxcbiAqIFdJVEhPVVQgV0FSUkFOVElFUyBPUiBDT05ESVRJT05TIE9GIEFOWSBLSU5ELCBlaXRoZXIgZXhwcmVzcyBvciBpbXBsaWVkLlxuICogU2VlIHRoZSBMaWNlbnNlIGZvciB0aGUgc3BlY2lmaWMgbGFuZ3VhZ2UgZ292ZXJuaW5nIHBlcm1pc3Npb25zIGFuZFxuICogbGltaXRhdGlvbnMgdW5kZXIgdGhlIExpY2Vuc2UuXG4gKi9cblxuLyoqXG4gKiBIZWxwZXIgY2xhc3MgY3NzIHV0aWxzXG4gKlxuICogQHR5cGUge3tub3JtYWxpemV9fVxuICovXG52YXIgY3NzVXRpbHMgPSBmdW5jdGlvbiAoKSB7XG4gIC8qKlxuICAgKiBSZWdleCB0aGF0IG1hdGNoZXMgQWRHdWFyZCdzIGJhY2t3YXJkIGNvbXBhdGlibGUgc3ludGF4ZXMuXG4gICAqL1xuICB2YXIgcmVBdHRyRmFsbGJhY2sgPSAvXFxbLSg/OmV4dHxhYnApLShbYS16LV9dKyk9KFtcIiddKSgoPzooPz0oXFxcXD8pKVxcNC4pKj8pXFwyXFxdL2c7XG4gIC8qKlxuICAgKiBDb21wbGV4IHJlcGxhY2VtZW50IGZ1bmN0aW9uLlxuICAgKiBVbmVzY2FwZXMgcXVvdGUgY2hhcmFjdGVycyBpbnNpZGUgb2YgYW4gZXh0ZW5kZWQgc2VsZWN0b3IuXG4gICAqXG4gICAqIEBwYXJhbSBtYXRjaCAgICAgV2hvbGUgbWF0Y2hlZCBzdHJpbmdcbiAgICogQHBhcmFtIG5hbWUgICAgICBHcm91cCAxXG4gICAqIEBwYXJhbSBxdW90ZUNoYXIgR3JvdXAgMlxuICAgKiBAcGFyYW0gdmFsdWUgICAgIEdyb3VwIDNcbiAgICovXG5cbiAgdmFyIGV2YWx1YXRlTWF0Y2ggPSBmdW5jdGlvbiBldmFsdWF0ZU1hdGNoKG1hdGNoLCBuYW1lLCBxdW90ZUNoYXIsIHZhbHVlKSB7XG4gICAgLy8gVW5lc2NhcGUgcXVvdGVzXG4gICAgdmFyIHJlID0gbmV3IFJlZ0V4cChcIihbXlxcXFxcXFxcXXxeKVxcXFxcXFxcXCIuY29uY2F0KHF1b3RlQ2hhciksICdnJyk7XG4gICAgdmFsdWUgPSB2YWx1ZS5yZXBsYWNlKHJlLCBcIiQxXCIuY29uY2F0KHF1b3RlQ2hhcikpO1xuICAgIHJldHVybiBcIjpcIi5jb25jYXQobmFtZSwgXCIoXCIpLmNvbmNhdCh2YWx1ZSwgXCIpXCIpO1xuICB9OyAvLyBTaXp6bGUncyBwYXJzaW5nIG9mIHBzZXVkbyBjbGFzcyBhcmd1bWVudHMgaXMgYnVnZ3kgb24gY2VydGFpbiBjaXJjdW1zdGFuY2VzXG4gIC8vIFdlIHN1cHBvcnQgZm9sbG93aW5nIGZvcm0gb2YgYXJndW1lbnRzOlxuICAvLyAxLiBmb3IgOm1hdGNoZXMtY3NzLCB0aG9zZSBvZiBhIGZvcm0ge3Byb3BlcnR5TmFtZX06IC8uKi9cbiAgLy8gMi4gZm9yIDpjb250YWlucywgdGhvc2Ugb2YgYSBmb3JtIC8uKi9cbiAgLy8gV2UgdHJhbnNmb3JtIHN1Y2ggY2FzZXMgaW4gYSB3YXkgdGhhdCBTaXp6bGUgaGFzIG5vIGFtYmlndWl0eSBpbiBwYXJzaW5nIGFyZ3VtZW50cy5cblxuXG4gIHZhciByZU1hdGNoZXNDc3MgPSAvXFw6KG1hdGNoZXMtY3NzKD86LWFmdGVyfC1iZWZvcmUpPylcXCgoW2Etei1cXHNdKlxcOlxccypcXC8oPzpcXFxcLnxbXlxcL10pKj9cXC9cXHMqKVxcKS9nO1xuICB2YXIgcmVDb250YWlucyA9IC86KD86LWFicC0pPyhjb250YWluc3xoYXMtdGV4dClcXCgoXFxzKlxcLyg/OlxcXFwufFteXFwvXSkqP1xcL1xccyopXFwpL2c7XG4gIHZhciByZVNjb3BlID0gL1xcKFxcOnNjb3BlID4vZzsgLy8gTm90ZSB0aGF0IHdlIHJlcXVpcmUgYC9gIGNoYXJhY3RlciBpbiByZWd1bGFyIGV4cHJlc3Npb25zIHRvIGJlIGVzY2FwZWQuXG5cbiAgLyoqXG4gICAqIFVzZWQgZm9yIHByZS1wcm9jZXNzaW5nIHBzZXVkby1jbGFzc2VzIHZhbHVlcyB3aXRoIGFib3ZlIHR3byByZWdleGVzLlxuICAgKi9cblxuICB2YXIgYWRkUXVvdGVzID0gZnVuY3Rpb24gYWRkUXVvdGVzKF8sIGMxLCBjMikge1xuICAgIHJldHVybiBcIjpcIi5jb25jYXQoYzEsIFwiKFxcXCJcIikuY29uY2F0KGMyLnJlcGxhY2UoL1tcIlxcXFxdL2csICdcXFxcJCYnKSwgXCJcXFwiKVwiKTtcbiAgfTtcblxuICB2YXIgU0NPUEVfUkVQTEFDRVIgPSAnKD4nO1xuICAvKipcbiAgICogTm9ybWFsaXplcyBzcGVjaWZpZWQgY3NzIHRleHQgaW4gYSBmb3JtIHRoYXQgY2FuIGJlIHBhcnNlZCBieSB0aGVcbiAgICogU2l6emxlIGVuZ2luZS5cbiAgICogTm9ybWFsaXphdGlvbiBtZWFuc1xuICAgKiAgMS4gdHJhbnNmb3JtaW5nIFstZXh0LSo9XCJcIl0gYXR0cmlidXRlcyB0byBwc2V1ZG8gY2xhc3Nlc1xuICAgKiAgMi4gZW5jbG9zaW5nIHBvc3NpYmx5IGFtYmlndW91cyBhcmd1bWVudHMgb2YgYDpjb250YWluc2AsXG4gICAqICAgICBgOm1hdGNoZXMtY3NzYCBwc2V1ZG8gY2xhc3NlcyB3aXRoIHF1b3Rlcy5cbiAgICogQHBhcmFtIHtzdHJpbmd9IGNzc1RleHRcbiAgICogQHJldHVybiB7c3RyaW5nfVxuICAgKi9cblxuICB2YXIgbm9ybWFsaXplID0gZnVuY3Rpb24gbm9ybWFsaXplKGNzc1RleHQpIHtcbiAgICB2YXIgbm9ybWFsaXplZENzc1RleHQgPSBjc3NUZXh0LnJlcGxhY2UocmVBdHRyRmFsbGJhY2ssIGV2YWx1YXRlTWF0Y2gpLnJlcGxhY2UocmVNYXRjaGVzQ3NzLCBhZGRRdW90ZXMpLnJlcGxhY2UocmVDb250YWlucywgYWRkUXVvdGVzKS5yZXBsYWNlKHJlU2NvcGUsIFNDT1BFX1JFUExBQ0VSKTtcbiAgICByZXR1cm4gbm9ybWFsaXplZENzc1RleHQ7XG4gIH07XG5cbiAgdmFyIGlzU2ltcGxlU2VsZWN0b3JWYWxpZCA9IGZ1bmN0aW9uIGlzU2ltcGxlU2VsZWN0b3JWYWxpZChzZWxlY3Rvcikge1xuICAgIHRyeSB7XG4gICAgICBkb2N1bWVudC5xdWVyeVNlbGVjdG9yQWxsKHNlbGVjdG9yKTtcbiAgICB9IGNhdGNoIChlKSB7XG4gICAgICByZXR1cm4gZmFsc2U7XG4gICAgfVxuXG4gICAgcmV0dXJuIHRydWU7XG4gIH07XG5cbiAgcmV0dXJuIHtcbiAgICBub3JtYWxpemU6IG5vcm1hbGl6ZSxcbiAgICBpc1NpbXBsZVNlbGVjdG9yVmFsaWQ6IGlzU2ltcGxlU2VsZWN0b3JWYWxpZFxuICB9O1xufSgpO1xuXG4vKiFcbiAqIFNpenpsZSBDU1MgU2VsZWN0b3IgRW5naW5lIHYyLjMuNC1wcmUtYWRndWFyZFxuICogaHR0cHM6Ly9zaXp6bGVqcy5jb20vXG4gKlxuICogQ29weXJpZ2h0IEpTIEZvdW5kYXRpb24gYW5kIG90aGVyIGNvbnRyaWJ1dG9yc1xuICogUmVsZWFzZWQgdW5kZXIgdGhlIE1JVCBsaWNlbnNlXG4gKiBodHRwczovL2pzLmZvdW5kYXRpb24vXG4gKlxuICogRGF0ZTogMjAyMC0wOC0wNFxuICovXG5cbi8qKlxuICogVmVyc2lvbiBvZiBTaXp6bGUgcGF0Y2hlZCBieSBBZEd1YXJkIGluIG9yZGVyIHRvIGJlIHVzZWQgaW4gdGhlIEV4dGVuZGVkQ3NzIG1vZHVsZS5cbiAqIGh0dHBzOi8vZ2l0aHViLmNvbS9BZGd1YXJkVGVhbS9zaXp6bGUtZXh0Y3NzXG4gKlxuICogTG9vayBmb3IgW0FkR3VhcmQgUGF0Y2hdIGFuZCBBREdVQVJEX0VYVENTUyBtYXJrZXJzIHRvIGZpbmQgb3V0IHdoYXQgZXhhY3RseSB3YXMgY2hhbmdlZCBieSB1cy5cbiAqXG4gKiBHbG9iYWwgY2hhbmdlczpcbiAqIDEuIEFkZGVkIGFkZGl0aW9uYWwgcGFyYW1ldGVycyB0byB0aGUgXCJTaXp6bGUudG9rZW5pemVcIiBtZXRob2Qgc28gdGhhdCBpdCBjYW4gYmUgdXNlZCBmb3Igc3R5bGVzaGVldHMgcGFyc2luZyBhbmQgdmFsaWRhdGlvbi5cbiAqIDIuIEFkZGVkIHRva2VucyByZS1zb3J0aW5nIG1lY2hhbmlzbSBmb3JjaW5nIHNsb3cgcHNldWRvcyB0byBiZSBtYXRjaGVkIGxhc3QgIChzZWUgc29ydFRva2VuR3JvdXBzKS5cbiAqIDMuIEZpeCB0aGUgbm9ubmF0aXZlU2VsZWN0b3JDYWNoZSBjYWNoaW5nIC0tIHRoZXJlIHdhcyBubyB2YWx1ZSBjb3JyZXNwb25kaW5nIHRvIGEga2V5LlxuICogNC4gQWRkZWQgU2l6emxlLmNvbXBpbGUgY2FsbCB0byB0aGUgYDpoYXNgIHBzZXVkbyBkZWZpbml0aW9uLlxuICpcbiAqIENoYW5nZXMgdGhhdCBhcmUgYXBwbGllZCB0byB0aGUgQURHVUFSRF9FWFRDU1MgYnVpbGQgb25seTpcbiAqIDEuIERvIG5vdCBleHBvc2UgU2l6emxlIHRvIHRoZSBnbG9iYWwgc2NvcGUuIEluaXRpYWxpemUgaXQgbGF6aWx5IHZpYSBpbml0aWFsaXplU2l6emxlKCkuXG4gKiAyLiBSZW1vdmVkIDpjb250YWlucyBwc2V1ZG8gZGVjbGFyYXRpb24gLS0gaXRzIHN5bnRheCBpcyBjaGFuZ2VkIGFuZCBkZWNsYXJlZCBvdXRzaWRlIG9mIFNpenpsZS5cbiAqIDMuIFJlbW92ZWQgZGVjbGFyYXRpb25zIGZvciB0aGUgZm9sbG93aW5nIG5vbi1zdGFuZGFyZCBwc2V1ZG8gY2xhc3NlczpcbiAqIDpwYXJlbnQsIDpoZWFkZXIsIDppbnB1dCwgOmJ1dHRvbiwgOnRleHQsIDpmaXJzdCwgOmxhc3QsIDplcSxcbiAqIDpldmVuLCA6b2RkLCA6bHQsIDpndCwgOm50aCwgOnJhZGlvLCA6Y2hlY2tib3gsIDpmaWxlLFxuICogOnBhc3N3b3JkLCA6aW1hZ2UsIDpzdWJtaXQsIDpyZXNldFxuICogNC4gQWRkZWQgZXM2IG1vZHVsZSBleHBvcnRcbiAqL1xudmFyIFNpenpsZTtcbi8qKlxuICogSW5pdGlhbGl6ZXMgU2l6emxlIG9iamVjdC5cbiAqIEluIHRoZSBjYXNlIG9mIEFkR3VhcmQgRXh0ZW5kZWRDc3Mgd2Ugd2FudCB0byBhdm9pZCBpbml0aWFsaXppbmcgU2l6emxlIHJpZ2h0IGF3YXlcbiAqIGFuZCBleHBvc2luZyBpdCB0byB0aGUgZ2xvYmFsIHNjb3BlLlxuICovXG5cbnZhciBpbml0aWFsaXplU2l6emxlID0gZnVuY3Rpb24gaW5pdGlhbGl6ZVNpenpsZSgpIHtcbiAgLy8ganNoaW50IGlnbm9yZTpsaW5lXG4gIGlmICghU2l6emxlKSB7XG4gICAgLy88PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDxcbiAgICBTaXp6bGUgPSBmdW5jdGlvbiAod2luZG93KSB7XG4gICAgICB2YXIgc3VwcG9ydCxcbiAgICAgICAgICBFeHByLFxuICAgICAgICAgIGdldFRleHQsXG4gICAgICAgICAgaXNYTUwsXG4gICAgICAgICAgdG9rZW5pemUsXG4gICAgICAgICAgY29tcGlsZSxcbiAgICAgICAgICBzZWxlY3QsXG4gICAgICAgICAgb3V0ZXJtb3N0Q29udGV4dCxcbiAgICAgICAgICBzb3J0SW5wdXQsXG4gICAgICAgICAgaGFzRHVwbGljYXRlLFxuICAgICAgICAgIC8vIExvY2FsIGRvY3VtZW50IHZhcnNcbiAgICAgIHNldERvY3VtZW50LFxuICAgICAgICAgIGRvY3VtZW50LFxuICAgICAgICAgIGRvY0VsZW0sXG4gICAgICAgICAgZG9jdW1lbnRJc0hUTUwsXG4gICAgICAgICAgcmJ1Z2d5UVNBLFxuICAgICAgICAgIHJidWdneU1hdGNoZXMsXG4gICAgICAgICAgbWF0Y2hlcyxcbiAgICAgICAgICBjb250YWlucyxcbiAgICAgICAgICAvLyBJbnN0YW5jZS1zcGVjaWZpYyBkYXRhXG4gICAgICBleHBhbmRvID0gXCJzaXp6bGVcIiArIDEgKiBuZXcgRGF0ZSgpLFxuICAgICAgICAgIHByZWZlcnJlZERvYyA9IHdpbmRvdy5kb2N1bWVudCxcbiAgICAgICAgICBkaXJydW5zID0gMCxcbiAgICAgICAgICBkb25lID0gMCxcbiAgICAgICAgICBjbGFzc0NhY2hlID0gY3JlYXRlQ2FjaGUoKSxcbiAgICAgICAgICB0b2tlbkNhY2hlID0gY3JlYXRlQ2FjaGUoKSxcbiAgICAgICAgICBjb21waWxlckNhY2hlID0gY3JlYXRlQ2FjaGUoKSxcbiAgICAgICAgICBub25uYXRpdmVTZWxlY3RvckNhY2hlID0gY3JlYXRlQ2FjaGUoKSxcbiAgICAgICAgICBzb3J0T3JkZXIgPSBmdW5jdGlvbiBzb3J0T3JkZXIoYSwgYikge1xuICAgICAgICBpZiAoYSA9PT0gYikge1xuICAgICAgICAgIGhhc0R1cGxpY2F0ZSA9IHRydWU7XG4gICAgICAgIH1cblxuICAgICAgICByZXR1cm4gMDtcbiAgICAgIH0sXG4gICAgICAgICAgLy8gSW5zdGFuY2UgbWV0aG9kc1xuICAgICAgaGFzT3duID0ge30uaGFzT3duUHJvcGVydHksXG4gICAgICAgICAgYXJyID0gW10sXG4gICAgICAgICAgcG9wID0gYXJyLnBvcCxcbiAgICAgICAgICBwdXNoX25hdGl2ZSA9IGFyci5wdXNoLFxuICAgICAgICAgIHB1c2ggPSBhcnIucHVzaCxcbiAgICAgICAgICBzbGljZSA9IGFyci5zbGljZSxcbiAgICAgICAgICAvLyBVc2UgYSBzdHJpcHBlZC1kb3duIGluZGV4T2YgYXMgaXQncyBmYXN0ZXIgdGhhbiBuYXRpdmVcbiAgICAgIC8vIGh0dHBzOi8vanNwZXJmLmNvbS90aG9yLWluZGV4b2YtdnMtZm9yLzVcbiAgICAgIGluZGV4T2YgPSBmdW5jdGlvbiBpbmRleE9mKGxpc3QsIGVsZW0pIHtcbiAgICAgICAgdmFyIGkgPSAwLFxuICAgICAgICAgICAgbGVuID0gbGlzdC5sZW5ndGg7XG5cbiAgICAgICAgZm9yICg7IGkgPCBsZW47IGkrKykge1xuICAgICAgICAgIGlmIChsaXN0W2ldID09PSBlbGVtKSB7XG4gICAgICAgICAgICByZXR1cm4gaTtcbiAgICAgICAgICB9XG4gICAgICAgIH1cblxuICAgICAgICByZXR1cm4gLTE7XG4gICAgICB9LFxuICAgICAgICAgIGJvb2xlYW5zID0gXCJjaGVja2VkfHNlbGVjdGVkfGFzeW5jfGF1dG9mb2N1c3xhdXRvcGxheXxjb250cm9sc3xkZWZlcnxkaXNhYmxlZHxoaWRkZW58aXNtYXB8bG9vcHxtdWx0aXBsZXxvcGVufHJlYWRvbmx5fHJlcXVpcmVkfHNjb3BlZFwiLFxuICAgICAgICAgIC8vIFJlZ3VsYXIgZXhwcmVzc2lvbnNcbiAgICAgIC8vIGh0dHA6Ly93d3cudzMub3JnL1RSL2NzczMtc2VsZWN0b3JzLyN3aGl0ZXNwYWNlXG4gICAgICB3aGl0ZXNwYWNlID0gXCJbXFxcXHgyMFxcXFx0XFxcXHJcXFxcblxcXFxmXVwiLFxuICAgICAgICAgIC8vIGh0dHA6Ly93d3cudzMub3JnL1RSL0NTUzIxL3N5bmRhdGEuaHRtbCN2YWx1ZS1kZWYtaWRlbnRpZmllclxuICAgICAgaWRlbnRpZmllciA9IFwiKD86XFxcXFxcXFwufFtcXFxcdy1dfFteXFwwLVxcXFx4YTBdKStcIixcbiAgICAgICAgICAvLyBBdHRyaWJ1dGUgc2VsZWN0b3JzOiBodHRwOi8vd3d3LnczLm9yZy9UUi9zZWxlY3RvcnMvI2F0dHJpYnV0ZS1zZWxlY3RvcnNcbiAgICAgIGF0dHJpYnV0ZXMgPSBcIlxcXFxbXCIgKyB3aGl0ZXNwYWNlICsgXCIqKFwiICsgaWRlbnRpZmllciArIFwiKSg/OlwiICsgd2hpdGVzcGFjZSArIC8vIE9wZXJhdG9yIChjYXB0dXJlIDIpXG4gICAgICBcIiooWypeJHwhfl0/PSlcIiArIHdoaXRlc3BhY2UgKyAvLyBcIkF0dHJpYnV0ZSB2YWx1ZXMgbXVzdCBiZSBDU1MgaWRlbnRpZmllcnMgW2NhcHR1cmUgNV0gb3Igc3RyaW5ncyBbY2FwdHVyZSAzIG9yIGNhcHR1cmUgNF1cIlxuICAgICAgXCIqKD86JygoPzpcXFxcXFxcXC58W15cXFxcXFxcXCddKSopJ3xcXFwiKCg/OlxcXFxcXFxcLnxbXlxcXFxcXFxcXFxcIl0pKilcXFwifChcIiArIGlkZW50aWZpZXIgKyBcIikpfClcIiArIHdoaXRlc3BhY2UgKyBcIipcXFxcXVwiLFxuICAgICAgICAgIHBzZXVkb3MgPSBcIjooXCIgKyBpZGVudGlmaWVyICsgXCIpKD86XFxcXCgoXCIgKyAvLyBUbyByZWR1Y2UgdGhlIG51bWJlciBvZiBzZWxlY3RvcnMgbmVlZGluZyB0b2tlbml6ZSBpbiB0aGUgcHJlRmlsdGVyLCBwcmVmZXIgYXJndW1lbnRzOlxuICAgICAgLy8gMS4gcXVvdGVkIChjYXB0dXJlIDM7IGNhcHR1cmUgNCBvciBjYXB0dXJlIDUpXG4gICAgICBcIignKCg/OlxcXFxcXFxcLnxbXlxcXFxcXFxcJ10pKiknfFxcXCIoKD86XFxcXFxcXFwufFteXFxcXFxcXFxcXFwiXSkqKVxcXCIpfFwiICsgLy8gMi4gc2ltcGxlIChjYXB0dXJlIDYpXG4gICAgICBcIigoPzpcXFxcXFxcXC58W15cXFxcXFxcXCgpW1xcXFxdXXxcIiArIGF0dHJpYnV0ZXMgKyBcIikqKXxcIiArIC8vIDMuIGFueXRoaW5nIGVsc2UgKGNhcHR1cmUgMilcbiAgICAgIFwiLipcIiArIFwiKVxcXFwpfClcIixcbiAgICAgICAgICAvLyBMZWFkaW5nIGFuZCBub24tZXNjYXBlZCB0cmFpbGluZyB3aGl0ZXNwYWNlLCBjYXB0dXJpbmcgc29tZSBub24td2hpdGVzcGFjZSBjaGFyYWN0ZXJzIHByZWNlZGluZyB0aGUgbGF0dGVyXG4gICAgICByd2hpdGVzcGFjZSA9IG5ldyBSZWdFeHAod2hpdGVzcGFjZSArIFwiK1wiLCBcImdcIiksXG4gICAgICAgICAgcnRyaW0gPSBuZXcgUmVnRXhwKFwiXlwiICsgd2hpdGVzcGFjZSArIFwiK3woKD86XnxbXlxcXFxcXFxcXSkoPzpcXFxcXFxcXC4pKilcIiArIHdoaXRlc3BhY2UgKyBcIiskXCIsIFwiZ1wiKSxcbiAgICAgICAgICByY29tbWEgPSBuZXcgUmVnRXhwKFwiXlwiICsgd2hpdGVzcGFjZSArIFwiKixcIiArIHdoaXRlc3BhY2UgKyBcIipcIiksXG4gICAgICAgICAgcmNvbWJpbmF0b3JzID0gbmV3IFJlZ0V4cChcIl5cIiArIHdoaXRlc3BhY2UgKyBcIiooWz4rfl18XCIgKyB3aGl0ZXNwYWNlICsgXCIpXCIgKyB3aGl0ZXNwYWNlICsgXCIqXCIpLFxuICAgICAgICAgIHJwc2V1ZG8gPSBuZXcgUmVnRXhwKHBzZXVkb3MpLFxuICAgICAgICAgIHJpZGVudGlmaWVyID0gbmV3IFJlZ0V4cChcIl5cIiArIGlkZW50aWZpZXIgKyBcIiRcIiksXG4gICAgICAgICAgbWF0Y2hFeHByID0ge1xuICAgICAgICBcIklEXCI6IG5ldyBSZWdFeHAoXCJeIyhcIiArIGlkZW50aWZpZXIgKyBcIilcIiksXG4gICAgICAgIFwiQ0xBU1NcIjogbmV3IFJlZ0V4cChcIl5cXFxcLihcIiArIGlkZW50aWZpZXIgKyBcIilcIiksXG4gICAgICAgIFwiVEFHXCI6IG5ldyBSZWdFeHAoXCJeKFwiICsgaWRlbnRpZmllciArIFwifFsqXSlcIiksXG4gICAgICAgIFwiQVRUUlwiOiBuZXcgUmVnRXhwKFwiXlwiICsgYXR0cmlidXRlcyksXG4gICAgICAgIFwiUFNFVURPXCI6IG5ldyBSZWdFeHAoXCJeXCIgKyBwc2V1ZG9zKSxcbiAgICAgICAgXCJDSElMRFwiOiBuZXcgUmVnRXhwKFwiXjoob25seXxmaXJzdHxsYXN0fG50aHxudGgtbGFzdCktKGNoaWxkfG9mLXR5cGUpKD86XFxcXChcIiArIHdoaXRlc3BhY2UgKyBcIiooZXZlbnxvZGR8KChbKy1dfCkoXFxcXGQqKW58KVwiICsgd2hpdGVzcGFjZSArIFwiKig/OihbKy1dfClcIiArIHdoaXRlc3BhY2UgKyBcIiooXFxcXGQrKXwpKVwiICsgd2hpdGVzcGFjZSArIFwiKlxcXFwpfClcIiwgXCJpXCIpLFxuICAgICAgICBcImJvb2xcIjogbmV3IFJlZ0V4cChcIl4oPzpcIiArIGJvb2xlYW5zICsgXCIpJFwiLCBcImlcIiksXG4gICAgICAgIC8vIEZvciB1c2UgaW4gbGlicmFyaWVzIGltcGxlbWVudGluZyAuaXMoKVxuICAgICAgICAvLyBXZSB1c2UgdGhpcyBmb3IgUE9TIG1hdGNoaW5nIGluIGBzZWxlY3RgXG4gICAgICAgIFwibmVlZHNDb250ZXh0XCI6IG5ldyBSZWdFeHAoXCJeXCIgKyB3aGl0ZXNwYWNlICsgXCIqWz4rfl18OihldmVufG9kZHxlcXxndHxsdHxudGh8Zmlyc3R8bGFzdCkoPzpcXFxcKFwiICsgd2hpdGVzcGFjZSArIFwiKigoPzotXFxcXGQpP1xcXFxkKilcIiArIHdoaXRlc3BhY2UgKyBcIipcXFxcKXwpKD89W14tXXwkKVwiLCBcImlcIilcbiAgICAgIH0sXG4gICAgICAgICAgcm5hdGl2ZSA9IC9eW157XStcXHtcXHMqXFxbbmF0aXZlIFxcdy8sXG4gICAgICAgICAgLy8gRWFzaWx5LXBhcnNlYWJsZS9yZXRyaWV2YWJsZSBJRCBvciBUQUcgb3IgQ0xBU1Mgc2VsZWN0b3JzXG4gICAgICBycXVpY2tFeHByID0gL14oPzojKFtcXHctXSspfChcXHcrKXxcXC4oW1xcdy1dKykpJC8sXG4gICAgICAgICAgcnNpYmxpbmcgPSAvWyt+XS8sXG4gICAgICAgICAgLy8gQ1NTIGVzY2FwZXNcbiAgICAgIC8vIGh0dHA6Ly93d3cudzMub3JnL1RSL0NTUzIxL3N5bmRhdGEuaHRtbCNlc2NhcGVkLWNoYXJhY3RlcnNcbiAgICAgIHJ1bmVzY2FwZSA9IG5ldyBSZWdFeHAoXCJcXFxcXFxcXChbXFxcXGRhLWZdezEsNn1cIiArIHdoaXRlc3BhY2UgKyBcIj98KFwiICsgd2hpdGVzcGFjZSArIFwiKXwuKVwiLCBcImlnXCIpLFxuICAgICAgICAgIGZ1bmVzY2FwZSA9IGZ1bmN0aW9uIGZ1bmVzY2FwZShfLCBlc2NhcGVkLCBlc2NhcGVkV2hpdGVzcGFjZSkge1xuICAgICAgICB2YXIgaGlnaCA9IFwiMHhcIiArIGVzY2FwZWQgLSAweDEwMDAwOyAvLyBOYU4gbWVhbnMgbm9uLWNvZGVwb2ludFxuICAgICAgICAvLyBTdXBwb3J0OiBGaXJlZm94PDI0XG4gICAgICAgIC8vIFdvcmthcm91bmQgZXJyb25lb3VzIG51bWVyaWMgaW50ZXJwcmV0YXRpb24gb2YgK1wiMHhcIlxuXG4gICAgICAgIHJldHVybiBoaWdoICE9PSBoaWdoIHx8IGVzY2FwZWRXaGl0ZXNwYWNlID8gZXNjYXBlZCA6IGhpZ2ggPCAwID8gLy8gQk1QIGNvZGVwb2ludFxuICAgICAgICBTdHJpbmcuZnJvbUNoYXJDb2RlKGhpZ2ggKyAweDEwMDAwKSA6IC8vIFN1cHBsZW1lbnRhbCBQbGFuZSBjb2RlcG9pbnQgKHN1cnJvZ2F0ZSBwYWlyKVxuICAgICAgICBTdHJpbmcuZnJvbUNoYXJDb2RlKGhpZ2ggPj4gMTAgfCAweEQ4MDAsIGhpZ2ggJiAweDNGRiB8IDB4REMwMCk7XG4gICAgICB9LFxuICAgICAgICAgIC8vIENTUyBzdHJpbmcvaWRlbnRpZmllciBzZXJpYWxpemF0aW9uXG4gICAgICAvLyBodHRwczovL2RyYWZ0cy5jc3N3Zy5vcmcvY3Nzb20vI2NvbW1vbi1zZXJpYWxpemluZy1pZGlvbXNcbiAgICAgIHJjc3Nlc2NhcGUgPSAvKFtcXDAtXFx4MWZcXHg3Zl18Xi0/XFxkKXxeLSR8W15cXDAtXFx4MWZcXHg3Zi1cXHVGRkZGXFx3LV0vZyxcbiAgICAgICAgICBmY3NzZXNjYXBlID0gZnVuY3Rpb24gZmNzc2VzY2FwZShjaCwgYXNDb2RlUG9pbnQpIHtcbiAgICAgICAgaWYgKGFzQ29kZVBvaW50KSB7XG4gICAgICAgICAgLy8gVSswMDAwIE5VTEwgYmVjb21lcyBVK0ZGRkQgUkVQTEFDRU1FTlQgQ0hBUkFDVEVSXG4gICAgICAgICAgaWYgKGNoID09PSBcIlxcMFwiKSB7XG4gICAgICAgICAgICByZXR1cm4gXCJcXHVGRkZEXCI7XG4gICAgICAgICAgfSAvLyBDb250cm9sIGNoYXJhY3RlcnMgYW5kIChkZXBlbmRlbnQgdXBvbiBwb3NpdGlvbikgbnVtYmVycyBnZXQgZXNjYXBlZCBhcyBjb2RlIHBvaW50c1xuXG5cbiAgICAgICAgICByZXR1cm4gY2guc2xpY2UoMCwgLTEpICsgXCJcXFxcXCIgKyBjaC5jaGFyQ29kZUF0KGNoLmxlbmd0aCAtIDEpLnRvU3RyaW5nKDE2KSArIFwiIFwiO1xuICAgICAgICB9IC8vIE90aGVyIHBvdGVudGlhbGx5LXNwZWNpYWwgQVNDSUkgY2hhcmFjdGVycyBnZXQgYmFja3NsYXNoLWVzY2FwZWRcblxuXG4gICAgICAgIHJldHVybiBcIlxcXFxcIiArIGNoO1xuICAgICAgfSxcbiAgICAgICAgICAvLyBVc2VkIGZvciBpZnJhbWVzXG4gICAgICAvLyBTZWUgc2V0RG9jdW1lbnQoKVxuICAgICAgLy8gUmVtb3ZpbmcgdGhlIGZ1bmN0aW9uIHdyYXBwZXIgY2F1c2VzIGEgXCJQZXJtaXNzaW9uIERlbmllZFwiXG4gICAgICAvLyBlcnJvciBpbiBJRVxuICAgICAgdW5sb2FkSGFuZGxlciA9IGZ1bmN0aW9uIHVubG9hZEhhbmRsZXIoKSB7XG4gICAgICAgIHNldERvY3VtZW50KCk7XG4gICAgICB9LFxuICAgICAgICAgIGluRGlzYWJsZWRGaWVsZHNldCA9IGFkZENvbWJpbmF0b3IoZnVuY3Rpb24gKGVsZW0pIHtcbiAgICAgICAgcmV0dXJuIGVsZW0uZGlzYWJsZWQgPT09IHRydWUgJiYgZWxlbS5ub2RlTmFtZS50b0xvd2VyQ2FzZSgpID09PSBcImZpZWxkc2V0XCI7XG4gICAgICB9LCB7XG4gICAgICAgIGRpcjogXCJwYXJlbnROb2RlXCIsXG4gICAgICAgIG5leHQ6IFwibGVnZW5kXCJcbiAgICAgIH0pOyAvLyBPcHRpbWl6ZSBmb3IgcHVzaC5hcHBseSggXywgTm9kZUxpc3QgKVxuXG5cbiAgICAgIHRyeSB7XG4gICAgICAgIHB1c2guYXBwbHkoYXJyID0gc2xpY2UuY2FsbChwcmVmZXJyZWREb2MuY2hpbGROb2RlcyksIHByZWZlcnJlZERvYy5jaGlsZE5vZGVzKTsgLy8gU3VwcG9ydDogQW5kcm9pZDw0LjBcbiAgICAgICAgLy8gRGV0ZWN0IHNpbGVudGx5IGZhaWxpbmcgcHVzaC5hcHBseVxuXG4gICAgICAgIGFycltwcmVmZXJyZWREb2MuY2hpbGROb2Rlcy5sZW5ndGhdLm5vZGVUeXBlO1xuICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICBwdXNoID0ge1xuICAgICAgICAgIGFwcGx5OiBhcnIubGVuZ3RoID8gLy8gTGV2ZXJhZ2Ugc2xpY2UgaWYgcG9zc2libGVcbiAgICAgICAgICBmdW5jdGlvbiAodGFyZ2V0LCBlbHMpIHtcbiAgICAgICAgICAgIHB1c2hfbmF0aXZlLmFwcGx5KHRhcmdldCwgc2xpY2UuY2FsbChlbHMpKTtcbiAgICAgICAgICB9IDogLy8gU3VwcG9ydDogSUU8OVxuICAgICAgICAgIC8vIE90aGVyd2lzZSBhcHBlbmQgZGlyZWN0bHlcbiAgICAgICAgICBmdW5jdGlvbiAodGFyZ2V0LCBlbHMpIHtcbiAgICAgICAgICAgIHZhciBqID0gdGFyZ2V0Lmxlbmd0aCxcbiAgICAgICAgICAgICAgICBpID0gMDsgLy8gQ2FuJ3QgdHJ1c3QgTm9kZUxpc3QubGVuZ3RoXG5cbiAgICAgICAgICAgIHdoaWxlICh0YXJnZXRbaisrXSA9IGVsc1tpKytdKSB7fVxuXG4gICAgICAgICAgICB0YXJnZXQubGVuZ3RoID0gaiAtIDE7XG4gICAgICAgICAgfVxuICAgICAgICB9O1xuICAgICAgfVxuXG4gICAgICBmdW5jdGlvbiBTaXp6bGUoc2VsZWN0b3IsIGNvbnRleHQsIHJlc3VsdHMsIHNlZWQpIHtcbiAgICAgICAgdmFyIG0sXG4gICAgICAgICAgICBpLFxuICAgICAgICAgICAgZWxlbSxcbiAgICAgICAgICAgIG5pZCxcbiAgICAgICAgICAgIG1hdGNoLFxuICAgICAgICAgICAgZ3JvdXBzLFxuICAgICAgICAgICAgbmV3U2VsZWN0b3IsXG4gICAgICAgICAgICBuZXdDb250ZXh0ID0gY29udGV4dCAmJiBjb250ZXh0Lm93bmVyRG9jdW1lbnQsXG4gICAgICAgICAgICAvLyBub2RlVHlwZSBkZWZhdWx0cyB0byA5LCBzaW5jZSBjb250ZXh0IGRlZmF1bHRzIHRvIGRvY3VtZW50XG4gICAgICAgIG5vZGVUeXBlID0gY29udGV4dCA/IGNvbnRleHQubm9kZVR5cGUgOiA5O1xuICAgICAgICByZXN1bHRzID0gcmVzdWx0cyB8fCBbXTsgLy8gUmV0dXJuIGVhcmx5IGZyb20gY2FsbHMgd2l0aCBpbnZhbGlkIHNlbGVjdG9yIG9yIGNvbnRleHRcblxuICAgICAgICBpZiAodHlwZW9mIHNlbGVjdG9yICE9PSBcInN0cmluZ1wiIHx8ICFzZWxlY3RvciB8fCBub2RlVHlwZSAhPT0gMSAmJiBub2RlVHlwZSAhPT0gOSAmJiBub2RlVHlwZSAhPT0gMTEpIHtcbiAgICAgICAgICByZXR1cm4gcmVzdWx0cztcbiAgICAgICAgfSAvLyBUcnkgdG8gc2hvcnRjdXQgZmluZCBvcGVyYXRpb25zIChhcyBvcHBvc2VkIHRvIGZpbHRlcnMpIGluIEhUTUwgZG9jdW1lbnRzXG5cblxuICAgICAgICBpZiAoIXNlZWQpIHtcbiAgICAgICAgICBpZiAoKGNvbnRleHQgPyBjb250ZXh0Lm93bmVyRG9jdW1lbnQgfHwgY29udGV4dCA6IHByZWZlcnJlZERvYykgIT09IGRvY3VtZW50KSB7XG4gICAgICAgICAgICBzZXREb2N1bWVudChjb250ZXh0KTtcbiAgICAgICAgICB9XG5cbiAgICAgICAgICBjb250ZXh0ID0gY29udGV4dCB8fCBkb2N1bWVudDtcblxuICAgICAgICAgIGlmIChkb2N1bWVudElzSFRNTCkge1xuICAgICAgICAgICAgLy8gSWYgdGhlIHNlbGVjdG9yIGlzIHN1ZmZpY2llbnRseSBzaW1wbGUsIHRyeSB1c2luZyBhIFwiZ2V0KkJ5KlwiIERPTSBtZXRob2RcbiAgICAgICAgICAgIC8vIChleGNlcHRpbmcgRG9jdW1lbnRGcmFnbWVudCBjb250ZXh0LCB3aGVyZSB0aGUgbWV0aG9kcyBkb24ndCBleGlzdClcbiAgICAgICAgICAgIGlmIChub2RlVHlwZSAhPT0gMTEgJiYgKG1hdGNoID0gcnF1aWNrRXhwci5leGVjKHNlbGVjdG9yKSkpIHtcbiAgICAgICAgICAgICAgLy8gSUQgc2VsZWN0b3JcbiAgICAgICAgICAgICAgaWYgKG0gPSBtYXRjaFsxXSkge1xuICAgICAgICAgICAgICAgIC8vIERvY3VtZW50IGNvbnRleHRcbiAgICAgICAgICAgICAgICBpZiAobm9kZVR5cGUgPT09IDkpIHtcbiAgICAgICAgICAgICAgICAgIGlmIChlbGVtID0gY29udGV4dC5nZXRFbGVtZW50QnlJZChtKSkge1xuICAgICAgICAgICAgICAgICAgICAvLyBTdXBwb3J0OiBJRSwgT3BlcmEsIFdlYmtpdFxuICAgICAgICAgICAgICAgICAgICAvLyBUT0RPOiBpZGVudGlmeSB2ZXJzaW9uc1xuICAgICAgICAgICAgICAgICAgICAvLyBnZXRFbGVtZW50QnlJZCBjYW4gbWF0Y2ggZWxlbWVudHMgYnkgbmFtZSBpbnN0ZWFkIG9mIElEXG4gICAgICAgICAgICAgICAgICAgIGlmIChlbGVtLmlkID09PSBtKSB7XG4gICAgICAgICAgICAgICAgICAgICAgcmVzdWx0cy5wdXNoKGVsZW0pO1xuICAgICAgICAgICAgICAgICAgICAgIHJldHVybiByZXN1bHRzO1xuICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICAgICAgICByZXR1cm4gcmVzdWx0cztcbiAgICAgICAgICAgICAgICAgIH0gLy8gRWxlbWVudCBjb250ZXh0XG5cbiAgICAgICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICAgICAgLy8gU3VwcG9ydDogSUUsIE9wZXJhLCBXZWJraXRcbiAgICAgICAgICAgICAgICAgIC8vIFRPRE86IGlkZW50aWZ5IHZlcnNpb25zXG4gICAgICAgICAgICAgICAgICAvLyBnZXRFbGVtZW50QnlJZCBjYW4gbWF0Y2ggZWxlbWVudHMgYnkgbmFtZSBpbnN0ZWFkIG9mIElEXG4gICAgICAgICAgICAgICAgICBpZiAobmV3Q29udGV4dCAmJiAoZWxlbSA9IG5ld0NvbnRleHQuZ2V0RWxlbWVudEJ5SWQobSkpICYmIGNvbnRhaW5zKGNvbnRleHQsIGVsZW0pICYmIGVsZW0uaWQgPT09IG0pIHtcbiAgICAgICAgICAgICAgICAgICAgcmVzdWx0cy5wdXNoKGVsZW0pO1xuICAgICAgICAgICAgICAgICAgICByZXR1cm4gcmVzdWx0cztcbiAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICB9IC8vIFR5cGUgc2VsZWN0b3JcblxuICAgICAgICAgICAgICB9IGVsc2UgaWYgKG1hdGNoWzJdKSB7XG4gICAgICAgICAgICAgICAgcHVzaC5hcHBseShyZXN1bHRzLCBjb250ZXh0LmdldEVsZW1lbnRzQnlUYWdOYW1lKHNlbGVjdG9yKSk7XG4gICAgICAgICAgICAgICAgcmV0dXJuIHJlc3VsdHM7IC8vIENsYXNzIHNlbGVjdG9yXG4gICAgICAgICAgICAgIH0gZWxzZSBpZiAoKG0gPSBtYXRjaFszXSkgJiYgc3VwcG9ydC5nZXRFbGVtZW50c0J5Q2xhc3NOYW1lICYmIGNvbnRleHQuZ2V0RWxlbWVudHNCeUNsYXNzTmFtZSkge1xuICAgICAgICAgICAgICAgIHB1c2guYXBwbHkocmVzdWx0cywgY29udGV4dC5nZXRFbGVtZW50c0J5Q2xhc3NOYW1lKG0pKTtcbiAgICAgICAgICAgICAgICByZXR1cm4gcmVzdWx0cztcbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfSAvLyBUYWtlIGFkdmFudGFnZSBvZiBxdWVyeVNlbGVjdG9yQWxsXG5cblxuICAgICAgICAgICAgaWYgKHN1cHBvcnQucXNhICYmICFub25uYXRpdmVTZWxlY3RvckNhY2hlW3NlbGVjdG9yICsgXCIgXCJdICYmICghcmJ1Z2d5UVNBIHx8ICFyYnVnZ3lRU0EudGVzdChzZWxlY3RvcikpKSB7XG4gICAgICAgICAgICAgIGlmIChub2RlVHlwZSAhPT0gMSkge1xuICAgICAgICAgICAgICAgIG5ld0NvbnRleHQgPSBjb250ZXh0O1xuICAgICAgICAgICAgICAgIG5ld1NlbGVjdG9yID0gc2VsZWN0b3I7IC8vIHFTQSBsb29rcyBvdXRzaWRlIEVsZW1lbnQgY29udGV4dCwgd2hpY2ggaXMgbm90IHdoYXQgd2Ugd2FudFxuICAgICAgICAgICAgICAgIC8vIFRoYW5rcyB0byBBbmRyZXcgRHVwb250IGZvciB0aGlzIHdvcmthcm91bmQgdGVjaG5pcXVlXG4gICAgICAgICAgICAgICAgLy8gU3VwcG9ydDogSUUgPD04XG4gICAgICAgICAgICAgICAgLy8gRXhjbHVkZSBvYmplY3QgZWxlbWVudHNcbiAgICAgICAgICAgICAgfSBlbHNlIGlmIChjb250ZXh0Lm5vZGVOYW1lLnRvTG93ZXJDYXNlKCkgIT09IFwib2JqZWN0XCIpIHtcbiAgICAgICAgICAgICAgICAvLyBDYXB0dXJlIHRoZSBjb250ZXh0IElELCBzZXR0aW5nIGl0IGZpcnN0IGlmIG5lY2Vzc2FyeVxuICAgICAgICAgICAgICAgIGlmIChuaWQgPSBjb250ZXh0LmdldEF0dHJpYnV0ZShcImlkXCIpKSB7XG4gICAgICAgICAgICAgICAgICBuaWQgPSBuaWQucmVwbGFjZShyY3NzZXNjYXBlLCBmY3NzZXNjYXBlKTtcbiAgICAgICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICAgICAgY29udGV4dC5zZXRBdHRyaWJ1dGUoXCJpZFwiLCBuaWQgPSBleHBhbmRvKTtcbiAgICAgICAgICAgICAgICB9IC8vIFByZWZpeCBldmVyeSBzZWxlY3RvciBpbiB0aGUgbGlzdFxuXG5cbiAgICAgICAgICAgICAgICBncm91cHMgPSB0b2tlbml6ZShzZWxlY3Rvcik7XG4gICAgICAgICAgICAgICAgaSA9IGdyb3Vwcy5sZW5ndGg7XG5cbiAgICAgICAgICAgICAgICB3aGlsZSAoaS0tKSB7XG4gICAgICAgICAgICAgICAgICBncm91cHNbaV0gPSBcIiNcIiArIG5pZCArIFwiIFwiICsgdG9TZWxlY3Rvcihncm91cHNbaV0pO1xuICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgIG5ld1NlbGVjdG9yID0gZ3JvdXBzLmpvaW4oXCIsXCIpOyAvLyBFeHBhbmQgY29udGV4dCBmb3Igc2libGluZyBzZWxlY3RvcnNcblxuICAgICAgICAgICAgICAgIG5ld0NvbnRleHQgPSByc2libGluZy50ZXN0KHNlbGVjdG9yKSAmJiB0ZXN0Q29udGV4dChjb250ZXh0LnBhcmVudE5vZGUpIHx8IGNvbnRleHQ7XG4gICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICBpZiAobmV3U2VsZWN0b3IpIHtcbiAgICAgICAgICAgICAgICB0cnkge1xuICAgICAgICAgICAgICAgICAgcHVzaC5hcHBseShyZXN1bHRzLCBuZXdDb250ZXh0LnF1ZXJ5U2VsZWN0b3JBbGwobmV3U2VsZWN0b3IpKTtcbiAgICAgICAgICAgICAgICAgIHJldHVybiByZXN1bHRzO1xuICAgICAgICAgICAgICAgIH0gY2F0Y2ggKHFzYUVycm9yKSB7XG4gICAgICAgICAgICAgICAgICAvLyBbQWRHdWFyZCBQYXRoXTogRml4IHRoZSBjYWNoZSB2YWx1ZVxuICAgICAgICAgICAgICAgICAgbm9ubmF0aXZlU2VsZWN0b3JDYWNoZShzZWxlY3RvciwgdHJ1ZSk7XG4gICAgICAgICAgICAgICAgfSBmaW5hbGx5IHtcbiAgICAgICAgICAgICAgICAgIGlmIChuaWQgPT09IGV4cGFuZG8pIHtcbiAgICAgICAgICAgICAgICAgICAgY29udGV4dC5yZW1vdmVBdHRyaWJ1dGUoXCJpZFwiKTtcbiAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9XG4gICAgICAgIH0gLy8gQWxsIG90aGVyc1xuXG5cbiAgICAgICAgcmV0dXJuIHNlbGVjdChzZWxlY3Rvci5yZXBsYWNlKHJ0cmltLCBcIiQxXCIpLCBjb250ZXh0LCByZXN1bHRzLCBzZWVkKTtcbiAgICAgIH1cbiAgICAgIC8qKlxuICAgICAgICogQ3JlYXRlIGtleS12YWx1ZSBjYWNoZXMgb2YgbGltaXRlZCBzaXplXG4gICAgICAgKiBAcmV0dXJucyB7ZnVuY3Rpb24oc3RyaW5nLCBvYmplY3QpfSBSZXR1cm5zIHRoZSBPYmplY3QgZGF0YSBhZnRlciBzdG9yaW5nIGl0IG9uIGl0c2VsZiB3aXRoXG4gICAgICAgKlx0cHJvcGVydHkgbmFtZSB0aGUgKHNwYWNlLXN1ZmZpeGVkKSBzdHJpbmcgYW5kIChpZiB0aGUgY2FjaGUgaXMgbGFyZ2VyIHRoYW4gRXhwci5jYWNoZUxlbmd0aClcbiAgICAgICAqXHRkZWxldGluZyB0aGUgb2xkZXN0IGVudHJ5XG4gICAgICAgKi9cblxuXG4gICAgICBmdW5jdGlvbiBjcmVhdGVDYWNoZSgpIHtcbiAgICAgICAgdmFyIGtleXMgPSBbXTtcblxuICAgICAgICBmdW5jdGlvbiBjYWNoZShrZXksIHZhbHVlKSB7XG4gICAgICAgICAgLy8gVXNlIChrZXkgKyBcIiBcIikgdG8gYXZvaWQgY29sbGlzaW9uIHdpdGggbmF0aXZlIHByb3RvdHlwZSBwcm9wZXJ0aWVzIChzZWUgSXNzdWUgIzE1NylcbiAgICAgICAgICBpZiAoa2V5cy5wdXNoKGtleSArIFwiIFwiKSA+IEV4cHIuY2FjaGVMZW5ndGgpIHtcbiAgICAgICAgICAgIC8vIE9ubHkga2VlcCB0aGUgbW9zdCByZWNlbnQgZW50cmllc1xuICAgICAgICAgICAgZGVsZXRlIGNhY2hlW2tleXMuc2hpZnQoKV07XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgcmV0dXJuIGNhY2hlW2tleSArIFwiIFwiXSA9IHZhbHVlO1xuICAgICAgICB9XG5cbiAgICAgICAgcmV0dXJuIGNhY2hlO1xuICAgICAgfVxuICAgICAgLyoqXG4gICAgICAgKiBNYXJrIGEgZnVuY3Rpb24gZm9yIHNwZWNpYWwgdXNlIGJ5IFNpenpsZVxuICAgICAgICogQHBhcmFtIHtGdW5jdGlvbn0gZm4gVGhlIGZ1bmN0aW9uIHRvIG1hcmtcbiAgICAgICAqL1xuXG5cbiAgICAgIGZ1bmN0aW9uIG1hcmtGdW5jdGlvbihmbikge1xuICAgICAgICBmbltleHBhbmRvXSA9IHRydWU7XG4gICAgICAgIHJldHVybiBmbjtcbiAgICAgIH1cbiAgICAgIC8qKlxuICAgICAgICogU3VwcG9ydCB0ZXN0aW5nIHVzaW5nIGFuIGVsZW1lbnRcbiAgICAgICAqIEBwYXJhbSB7RnVuY3Rpb259IGZuIFBhc3NlZCB0aGUgY3JlYXRlZCBlbGVtZW50IGFuZCByZXR1cm5zIGEgYm9vbGVhbiByZXN1bHRcbiAgICAgICAqL1xuXG5cbiAgICAgIGZ1bmN0aW9uIGFzc2VydChmbikge1xuICAgICAgICB2YXIgZWwgPSBkb2N1bWVudC5jcmVhdGVFbGVtZW50KFwiZmllbGRzZXRcIik7XG5cbiAgICAgICAgdHJ5IHtcbiAgICAgICAgICByZXR1cm4gISFmbihlbCk7XG4gICAgICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICAgIH0gZmluYWxseSB7XG4gICAgICAgICAgLy8gUmVtb3ZlIGZyb20gaXRzIHBhcmVudCBieSBkZWZhdWx0XG4gICAgICAgICAgaWYgKGVsLnBhcmVudE5vZGUpIHtcbiAgICAgICAgICAgIGVsLnBhcmVudE5vZGUucmVtb3ZlQ2hpbGQoZWwpO1xuICAgICAgICAgIH0gLy8gcmVsZWFzZSBtZW1vcnkgaW4gSUVcblxuXG4gICAgICAgICAgZWwgPSBudWxsO1xuICAgICAgICB9XG4gICAgICB9XG4gICAgICAvKipcbiAgICAgICAqIEFkZHMgdGhlIHNhbWUgaGFuZGxlciBmb3IgYWxsIG9mIHRoZSBzcGVjaWZpZWQgYXR0cnNcbiAgICAgICAqIEBwYXJhbSB7U3RyaW5nfSBhdHRycyBQaXBlLXNlcGFyYXRlZCBsaXN0IG9mIGF0dHJpYnV0ZXNcbiAgICAgICAqIEBwYXJhbSB7RnVuY3Rpb259IGhhbmRsZXIgVGhlIG1ldGhvZCB0aGF0IHdpbGwgYmUgYXBwbGllZFxuICAgICAgICovXG5cblxuICAgICAgZnVuY3Rpb24gYWRkSGFuZGxlKGF0dHJzLCBoYW5kbGVyKSB7XG4gICAgICAgIHZhciBhcnIgPSBhdHRycy5zcGxpdChcInxcIiksXG4gICAgICAgICAgICBpID0gYXJyLmxlbmd0aDtcblxuICAgICAgICB3aGlsZSAoaS0tKSB7XG4gICAgICAgICAgRXhwci5hdHRySGFuZGxlW2FycltpXV0gPSBoYW5kbGVyO1xuICAgICAgICB9XG4gICAgICB9XG4gICAgICAvKipcbiAgICAgICAqIENoZWNrcyBkb2N1bWVudCBvcmRlciBvZiB0d28gc2libGluZ3NcbiAgICAgICAqIEBwYXJhbSB7RWxlbWVudH0gYVxuICAgICAgICogQHBhcmFtIHtFbGVtZW50fSBiXG4gICAgICAgKiBAcmV0dXJucyB7TnVtYmVyfSBSZXR1cm5zIGxlc3MgdGhhbiAwIGlmIGEgcHJlY2VkZXMgYiwgZ3JlYXRlciB0aGFuIDAgaWYgYSBmb2xsb3dzIGJcbiAgICAgICAqL1xuXG5cbiAgICAgIGZ1bmN0aW9uIHNpYmxpbmdDaGVjayhhLCBiKSB7XG4gICAgICAgIHZhciBjdXIgPSBiICYmIGEsXG4gICAgICAgICAgICBkaWZmID0gY3VyICYmIGEubm9kZVR5cGUgPT09IDEgJiYgYi5ub2RlVHlwZSA9PT0gMSAmJiBhLnNvdXJjZUluZGV4IC0gYi5zb3VyY2VJbmRleDsgLy8gVXNlIElFIHNvdXJjZUluZGV4IGlmIGF2YWlsYWJsZSBvbiBib3RoIG5vZGVzXG5cbiAgICAgICAgaWYgKGRpZmYpIHtcbiAgICAgICAgICByZXR1cm4gZGlmZjtcbiAgICAgICAgfSAvLyBDaGVjayBpZiBiIGZvbGxvd3MgYVxuXG5cbiAgICAgICAgaWYgKGN1cikge1xuICAgICAgICAgIHdoaWxlIChjdXIgPSBjdXIubmV4dFNpYmxpbmcpIHtcbiAgICAgICAgICAgIGlmIChjdXIgPT09IGIpIHtcbiAgICAgICAgICAgICAgcmV0dXJuIC0xO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiBhID8gMSA6IC0xO1xuICAgICAgfVxuICAgICAgLyoqXG4gICAgICAgKiBSZXR1cm5zIGEgZnVuY3Rpb24gdG8gdXNlIGluIHBzZXVkb3MgZm9yIDplbmFibGVkLzpkaXNhYmxlZFxuICAgICAgICogQHBhcmFtIHtCb29sZWFufSBkaXNhYmxlZCB0cnVlIGZvciA6ZGlzYWJsZWQ7IGZhbHNlIGZvciA6ZW5hYmxlZFxuICAgICAgICovXG5cblxuICAgICAgZnVuY3Rpb24gY3JlYXRlRGlzYWJsZWRQc2V1ZG8oZGlzYWJsZWQpIHtcbiAgICAgICAgLy8gS25vd24gOmRpc2FibGVkIGZhbHNlIHBvc2l0aXZlczogZmllbGRzZXRbZGlzYWJsZWRdID4gbGVnZW5kOm50aC1vZi10eXBlKG4rMikgOmNhbi1kaXNhYmxlXG4gICAgICAgIHJldHVybiBmdW5jdGlvbiAoZWxlbSkge1xuICAgICAgICAgIC8vIE9ubHkgY2VydGFpbiBlbGVtZW50cyBjYW4gbWF0Y2ggOmVuYWJsZWQgb3IgOmRpc2FibGVkXG4gICAgICAgICAgLy8gaHR0cHM6Ly9odG1sLnNwZWMud2hhdHdnLm9yZy9tdWx0aXBhZ2Uvc2NyaXB0aW5nLmh0bWwjc2VsZWN0b3ItZW5hYmxlZFxuICAgICAgICAgIC8vIGh0dHBzOi8vaHRtbC5zcGVjLndoYXR3Zy5vcmcvbXVsdGlwYWdlL3NjcmlwdGluZy5odG1sI3NlbGVjdG9yLWRpc2FibGVkXG4gICAgICAgICAgaWYgKFwiZm9ybVwiIGluIGVsZW0pIHtcbiAgICAgICAgICAgIC8vIENoZWNrIGZvciBpbmhlcml0ZWQgZGlzYWJsZWRuZXNzIG9uIHJlbGV2YW50IG5vbi1kaXNhYmxlZCBlbGVtZW50czpcbiAgICAgICAgICAgIC8vICogbGlzdGVkIGZvcm0tYXNzb2NpYXRlZCBlbGVtZW50cyBpbiBhIGRpc2FibGVkIGZpZWxkc2V0XG4gICAgICAgICAgICAvLyAgIGh0dHBzOi8vaHRtbC5zcGVjLndoYXR3Zy5vcmcvbXVsdGlwYWdlL2Zvcm1zLmh0bWwjY2F0ZWdvcnktbGlzdGVkXG4gICAgICAgICAgICAvLyAgIGh0dHBzOi8vaHRtbC5zcGVjLndoYXR3Zy5vcmcvbXVsdGlwYWdlL2Zvcm1zLmh0bWwjY29uY2VwdC1mZS1kaXNhYmxlZFxuICAgICAgICAgICAgLy8gKiBvcHRpb24gZWxlbWVudHMgaW4gYSBkaXNhYmxlZCBvcHRncm91cFxuICAgICAgICAgICAgLy8gICBodHRwczovL2h0bWwuc3BlYy53aGF0d2cub3JnL211bHRpcGFnZS9mb3Jtcy5odG1sI2NvbmNlcHQtb3B0aW9uLWRpc2FibGVkXG4gICAgICAgICAgICAvLyBBbGwgc3VjaCBlbGVtZW50cyBoYXZlIGEgXCJmb3JtXCIgcHJvcGVydHkuXG4gICAgICAgICAgICBpZiAoZWxlbS5wYXJlbnROb2RlICYmIGVsZW0uZGlzYWJsZWQgPT09IGZhbHNlKSB7XG4gICAgICAgICAgICAgIC8vIE9wdGlvbiBlbGVtZW50cyBkZWZlciB0byBhIHBhcmVudCBvcHRncm91cCBpZiBwcmVzZW50XG4gICAgICAgICAgICAgIGlmIChcImxhYmVsXCIgaW4gZWxlbSkge1xuICAgICAgICAgICAgICAgIGlmIChcImxhYmVsXCIgaW4gZWxlbS5wYXJlbnROb2RlKSB7XG4gICAgICAgICAgICAgICAgICByZXR1cm4gZWxlbS5wYXJlbnROb2RlLmRpc2FibGVkID09PSBkaXNhYmxlZDtcbiAgICAgICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICAgICAgcmV0dXJuIGVsZW0uZGlzYWJsZWQgPT09IGRpc2FibGVkO1xuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgfSAvLyBTdXBwb3J0OiBJRSA2IC0gMTFcbiAgICAgICAgICAgICAgLy8gVXNlIHRoZSBpc0Rpc2FibGVkIHNob3J0Y3V0IHByb3BlcnR5IHRvIGNoZWNrIGZvciBkaXNhYmxlZCBmaWVsZHNldCBhbmNlc3RvcnNcblxuXG4gICAgICAgICAgICAgIHJldHVybiBlbGVtLmlzRGlzYWJsZWQgPT09IGRpc2FibGVkIHx8IC8vIFdoZXJlIHRoZXJlIGlzIG5vIGlzRGlzYWJsZWQsIGNoZWNrIG1hbnVhbGx5XG5cbiAgICAgICAgICAgICAgLyoganNoaW50IC1XMDE4ICovXG4gICAgICAgICAgICAgIGVsZW0uaXNEaXNhYmxlZCAhPT0gIWRpc2FibGVkICYmIGluRGlzYWJsZWRGaWVsZHNldChlbGVtKSA9PT0gZGlzYWJsZWQ7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIHJldHVybiBlbGVtLmRpc2FibGVkID09PSBkaXNhYmxlZDsgLy8gVHJ5IHRvIHdpbm5vdyBvdXQgZWxlbWVudHMgdGhhdCBjYW4ndCBiZSBkaXNhYmxlZCBiZWZvcmUgdHJ1c3RpbmcgdGhlIGRpc2FibGVkIHByb3BlcnR5LlxuICAgICAgICAgICAgLy8gU29tZSB2aWN0aW1zIGdldCBjYXVnaHQgaW4gb3VyIG5ldCAobGFiZWwsIGxlZ2VuZCwgbWVudSwgdHJhY2spLCBidXQgaXQgc2hvdWxkbid0XG4gICAgICAgICAgICAvLyBldmVuIGV4aXN0IG9uIHRoZW0sIGxldCBhbG9uZSBoYXZlIGEgYm9vbGVhbiB2YWx1ZS5cbiAgICAgICAgICB9IGVsc2UgaWYgKFwibGFiZWxcIiBpbiBlbGVtKSB7XG4gICAgICAgICAgICByZXR1cm4gZWxlbS5kaXNhYmxlZCA9PT0gZGlzYWJsZWQ7XG4gICAgICAgICAgfSAvLyBSZW1haW5pbmcgZWxlbWVudHMgYXJlIG5laXRoZXIgOmVuYWJsZWQgbm9yIDpkaXNhYmxlZFxuXG5cbiAgICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICAgIH07XG4gICAgICB9XG4gICAgICAvKipcbiAgICAgICAqIENoZWNrcyBhIG5vZGUgZm9yIHZhbGlkaXR5IGFzIGEgU2l6emxlIGNvbnRleHRcbiAgICAgICAqIEBwYXJhbSB7RWxlbWVudHxPYmplY3Q9fSBjb250ZXh0XG4gICAgICAgKiBAcmV0dXJucyB7RWxlbWVudHxPYmplY3R8Qm9vbGVhbn0gVGhlIGlucHV0IG5vZGUgaWYgYWNjZXB0YWJsZSwgb3RoZXJ3aXNlIGEgZmFsc3kgdmFsdWVcbiAgICAgICAqL1xuXG5cbiAgICAgIGZ1bmN0aW9uIHRlc3RDb250ZXh0KGNvbnRleHQpIHtcbiAgICAgICAgcmV0dXJuIGNvbnRleHQgJiYgdHlwZW9mIGNvbnRleHQuZ2V0RWxlbWVudHNCeVRhZ05hbWUgIT09IFwidW5kZWZpbmVkXCIgJiYgY29udGV4dDtcbiAgICAgIH0gLy8gRXhwb3NlIHN1cHBvcnQgdmFycyBmb3IgY29udmVuaWVuY2VcblxuXG4gICAgICBzdXBwb3J0ID0gU2l6emxlLnN1cHBvcnQgPSB7fTtcbiAgICAgIC8qKlxuICAgICAgICogRGV0ZWN0cyBYTUwgbm9kZXNcbiAgICAgICAqIEBwYXJhbSB7RWxlbWVudHxPYmplY3R9IGVsZW0gQW4gZWxlbWVudCBvciBhIGRvY3VtZW50XG4gICAgICAgKiBAcmV0dXJucyB7Qm9vbGVhbn0gVHJ1ZSBpZmYgZWxlbSBpcyBhIG5vbi1IVE1MIFhNTCBub2RlXG4gICAgICAgKi9cblxuICAgICAgaXNYTUwgPSBTaXp6bGUuaXNYTUwgPSBmdW5jdGlvbiAoZWxlbSkge1xuICAgICAgICAvLyBkb2N1bWVudEVsZW1lbnQgaXMgdmVyaWZpZWQgZm9yIGNhc2VzIHdoZXJlIGl0IGRvZXNuJ3QgeWV0IGV4aXN0XG4gICAgICAgIC8vIChzdWNoIGFzIGxvYWRpbmcgaWZyYW1lcyBpbiBJRSAtICM0ODMzKVxuICAgICAgICB2YXIgZG9jdW1lbnRFbGVtZW50ID0gZWxlbSAmJiAoZWxlbS5vd25lckRvY3VtZW50IHx8IGVsZW0pLmRvY3VtZW50RWxlbWVudDtcbiAgICAgICAgcmV0dXJuIGRvY3VtZW50RWxlbWVudCA/IGRvY3VtZW50RWxlbWVudC5ub2RlTmFtZSAhPT0gXCJIVE1MXCIgOiBmYWxzZTtcbiAgICAgIH07XG4gICAgICAvKipcbiAgICAgICAqIFNldHMgZG9jdW1lbnQtcmVsYXRlZCB2YXJpYWJsZXMgb25jZSBiYXNlZCBvbiB0aGUgY3VycmVudCBkb2N1bWVudFxuICAgICAgICogQHBhcmFtIHtFbGVtZW50fE9iamVjdH0gW2RvY10gQW4gZWxlbWVudCBvciBkb2N1bWVudCBvYmplY3QgdG8gdXNlIHRvIHNldCB0aGUgZG9jdW1lbnRcbiAgICAgICAqIEByZXR1cm5zIHtPYmplY3R9IFJldHVybnMgdGhlIGN1cnJlbnQgZG9jdW1lbnRcbiAgICAgICAqL1xuXG5cbiAgICAgIHNldERvY3VtZW50ID0gU2l6emxlLnNldERvY3VtZW50ID0gZnVuY3Rpb24gKG5vZGUpIHtcbiAgICAgICAgdmFyIGhhc0NvbXBhcmUsXG4gICAgICAgICAgICBzdWJXaW5kb3csXG4gICAgICAgICAgICBkb2MgPSBub2RlID8gbm9kZS5vd25lckRvY3VtZW50IHx8IG5vZGUgOiBwcmVmZXJyZWREb2M7IC8vIFJldHVybiBlYXJseSBpZiBkb2MgaXMgaW52YWxpZCBvciBhbHJlYWR5IHNlbGVjdGVkXG5cbiAgICAgICAgaWYgKGRvYyA9PT0gZG9jdW1lbnQgfHwgZG9jLm5vZGVUeXBlICE9PSA5IHx8ICFkb2MuZG9jdW1lbnRFbGVtZW50KSB7XG4gICAgICAgICAgcmV0dXJuIGRvY3VtZW50O1xuICAgICAgICB9IC8vIFVwZGF0ZSBnbG9iYWwgdmFyaWFibGVzXG5cblxuICAgICAgICBkb2N1bWVudCA9IGRvYztcbiAgICAgICAgZG9jRWxlbSA9IGRvY3VtZW50LmRvY3VtZW50RWxlbWVudDtcbiAgICAgICAgZG9jdW1lbnRJc0hUTUwgPSAhaXNYTUwoZG9jdW1lbnQpOyAvLyBTdXBwb3J0OiBJRSA5LTExLCBFZGdlXG4gICAgICAgIC8vIEFjY2Vzc2luZyBpZnJhbWUgZG9jdW1lbnRzIGFmdGVyIHVubG9hZCB0aHJvd3MgXCJwZXJtaXNzaW9uIGRlbmllZFwiIGVycm9ycyAoalF1ZXJ5ICMxMzkzNilcblxuICAgICAgICBpZiAocHJlZmVycmVkRG9jICE9PSBkb2N1bWVudCAmJiAoc3ViV2luZG93ID0gZG9jdW1lbnQuZGVmYXVsdFZpZXcpICYmIHN1YldpbmRvdy50b3AgIT09IHN1YldpbmRvdykge1xuICAgICAgICAgIC8vIFN1cHBvcnQ6IElFIDExLCBFZGdlXG4gICAgICAgICAgaWYgKHN1YldpbmRvdy5hZGRFdmVudExpc3RlbmVyKSB7XG4gICAgICAgICAgICBzdWJXaW5kb3cuYWRkRXZlbnRMaXN0ZW5lcihcInVubG9hZFwiLCB1bmxvYWRIYW5kbGVyLCBmYWxzZSk7IC8vIFN1cHBvcnQ6IElFIDkgLSAxMCBvbmx5XG4gICAgICAgICAgfSBlbHNlIGlmIChzdWJXaW5kb3cuYXR0YWNoRXZlbnQpIHtcbiAgICAgICAgICAgIHN1YldpbmRvdy5hdHRhY2hFdmVudChcIm9udW5sb2FkXCIsIHVubG9hZEhhbmRsZXIpO1xuICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgICAvKiBBdHRyaWJ1dGVzXG4gICAgICAgIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0gKi9cbiAgICAgICAgLy8gU3VwcG9ydDogSUU8OFxuICAgICAgICAvLyBWZXJpZnkgdGhhdCBnZXRBdHRyaWJ1dGUgcmVhbGx5IHJldHVybnMgYXR0cmlidXRlcyBhbmQgbm90IHByb3BlcnRpZXNcbiAgICAgICAgLy8gKGV4Y2VwdGluZyBJRTggYm9vbGVhbnMpXG5cblxuICAgICAgICBzdXBwb3J0LmF0dHJpYnV0ZXMgPSBhc3NlcnQoZnVuY3Rpb24gKGVsKSB7XG4gICAgICAgICAgZWwuY2xhc3NOYW1lID0gXCJpXCI7XG4gICAgICAgICAgcmV0dXJuICFlbC5nZXRBdHRyaWJ1dGUoXCJjbGFzc05hbWVcIik7XG4gICAgICAgIH0pO1xuICAgICAgICAvKiBnZXRFbGVtZW50KHMpQnkqXG4gICAgICAgIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0gKi9cbiAgICAgICAgLy8gQ2hlY2sgaWYgZ2V0RWxlbWVudHNCeVRhZ05hbWUoXCIqXCIpIHJldHVybnMgb25seSBlbGVtZW50c1xuXG4gICAgICAgIHN1cHBvcnQuZ2V0RWxlbWVudHNCeVRhZ05hbWUgPSBhc3NlcnQoZnVuY3Rpb24gKGVsKSB7XG4gICAgICAgICAgZWwuYXBwZW5kQ2hpbGQoZG9jdW1lbnQuY3JlYXRlQ29tbWVudChcIlwiKSk7XG4gICAgICAgICAgcmV0dXJuICFlbC5nZXRFbGVtZW50c0J5VGFnTmFtZShcIipcIikubGVuZ3RoO1xuICAgICAgICB9KTsgLy8gU3VwcG9ydDogSUU8OVxuXG4gICAgICAgIHN1cHBvcnQuZ2V0RWxlbWVudHNCeUNsYXNzTmFtZSA9IHJuYXRpdmUudGVzdChkb2N1bWVudC5nZXRFbGVtZW50c0J5Q2xhc3NOYW1lKTsgLy8gU3VwcG9ydDogSUU8MTBcbiAgICAgICAgLy8gQ2hlY2sgaWYgZ2V0RWxlbWVudEJ5SWQgcmV0dXJucyBlbGVtZW50cyBieSBuYW1lXG4gICAgICAgIC8vIFRoZSBicm9rZW4gZ2V0RWxlbWVudEJ5SWQgbWV0aG9kcyBkb24ndCBwaWNrIHVwIHByb2dyYW1tYXRpY2FsbHktc2V0IG5hbWVzLFxuICAgICAgICAvLyBzbyB1c2UgYSByb3VuZGFib3V0IGdldEVsZW1lbnRzQnlOYW1lIHRlc3RcblxuICAgICAgICBzdXBwb3J0LmdldEJ5SWQgPSBhc3NlcnQoZnVuY3Rpb24gKGVsKSB7XG4gICAgICAgICAgZG9jRWxlbS5hcHBlbmRDaGlsZChlbCkuaWQgPSBleHBhbmRvO1xuICAgICAgICAgIHJldHVybiAhZG9jdW1lbnQuZ2V0RWxlbWVudHNCeU5hbWUgfHwgIWRvY3VtZW50LmdldEVsZW1lbnRzQnlOYW1lKGV4cGFuZG8pLmxlbmd0aDtcbiAgICAgICAgfSk7IC8vIElEIGZpbHRlciBhbmQgZmluZFxuXG4gICAgICAgIGlmIChzdXBwb3J0LmdldEJ5SWQpIHtcbiAgICAgICAgICBFeHByLmZpbHRlcltcIklEXCJdID0gZnVuY3Rpb24gKGlkKSB7XG4gICAgICAgICAgICB2YXIgYXR0cklkID0gaWQucmVwbGFjZShydW5lc2NhcGUsIGZ1bmVzY2FwZSk7XG4gICAgICAgICAgICByZXR1cm4gZnVuY3Rpb24gKGVsZW0pIHtcbiAgICAgICAgICAgICAgcmV0dXJuIGVsZW0uZ2V0QXR0cmlidXRlKFwiaWRcIikgPT09IGF0dHJJZDtcbiAgICAgICAgICAgIH07XG4gICAgICAgICAgfTtcblxuICAgICAgICAgIEV4cHIuZmluZFtcIklEXCJdID0gZnVuY3Rpb24gKGlkLCBjb250ZXh0KSB7XG4gICAgICAgICAgICBpZiAodHlwZW9mIGNvbnRleHQuZ2V0RWxlbWVudEJ5SWQgIT09IFwidW5kZWZpbmVkXCIgJiYgZG9jdW1lbnRJc0hUTUwpIHtcbiAgICAgICAgICAgICAgdmFyIGVsZW0gPSBjb250ZXh0LmdldEVsZW1lbnRCeUlkKGlkKTtcbiAgICAgICAgICAgICAgcmV0dXJuIGVsZW0gPyBbZWxlbV0gOiBbXTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9O1xuICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgIEV4cHIuZmlsdGVyW1wiSURcIl0gPSBmdW5jdGlvbiAoaWQpIHtcbiAgICAgICAgICAgIHZhciBhdHRySWQgPSBpZC5yZXBsYWNlKHJ1bmVzY2FwZSwgZnVuZXNjYXBlKTtcbiAgICAgICAgICAgIHJldHVybiBmdW5jdGlvbiAoZWxlbSkge1xuICAgICAgICAgICAgICB2YXIgbm9kZSA9IHR5cGVvZiBlbGVtLmdldEF0dHJpYnV0ZU5vZGUgIT09IFwidW5kZWZpbmVkXCIgJiYgZWxlbS5nZXRBdHRyaWJ1dGVOb2RlKFwiaWRcIik7XG4gICAgICAgICAgICAgIHJldHVybiBub2RlICYmIG5vZGUudmFsdWUgPT09IGF0dHJJZDtcbiAgICAgICAgICAgIH07XG4gICAgICAgICAgfTsgLy8gU3VwcG9ydDogSUUgNiAtIDcgb25seVxuICAgICAgICAgIC8vIGdldEVsZW1lbnRCeUlkIGlzIG5vdCByZWxpYWJsZSBhcyBhIGZpbmQgc2hvcnRjdXRcblxuXG4gICAgICAgICAgRXhwci5maW5kW1wiSURcIl0gPSBmdW5jdGlvbiAoaWQsIGNvbnRleHQpIHtcbiAgICAgICAgICAgIGlmICh0eXBlb2YgY29udGV4dC5nZXRFbGVtZW50QnlJZCAhPT0gXCJ1bmRlZmluZWRcIiAmJiBkb2N1bWVudElzSFRNTCkge1xuICAgICAgICAgICAgICB2YXIgbm9kZSxcbiAgICAgICAgICAgICAgICAgIGksXG4gICAgICAgICAgICAgICAgICBlbGVtcyxcbiAgICAgICAgICAgICAgICAgIGVsZW0gPSBjb250ZXh0LmdldEVsZW1lbnRCeUlkKGlkKTtcblxuICAgICAgICAgICAgICBpZiAoZWxlbSkge1xuICAgICAgICAgICAgICAgIC8vIFZlcmlmeSB0aGUgaWQgYXR0cmlidXRlXG4gICAgICAgICAgICAgICAgbm9kZSA9IGVsZW0uZ2V0QXR0cmlidXRlTm9kZShcImlkXCIpO1xuXG4gICAgICAgICAgICAgICAgaWYgKG5vZGUgJiYgbm9kZS52YWx1ZSA9PT0gaWQpIHtcbiAgICAgICAgICAgICAgICAgIHJldHVybiBbZWxlbV07XG4gICAgICAgICAgICAgICAgfSAvLyBGYWxsIGJhY2sgb24gZ2V0RWxlbWVudHNCeU5hbWVcblxuXG4gICAgICAgICAgICAgICAgZWxlbXMgPSBjb250ZXh0LmdldEVsZW1lbnRzQnlOYW1lKGlkKTtcbiAgICAgICAgICAgICAgICBpID0gMDtcblxuICAgICAgICAgICAgICAgIHdoaWxlIChlbGVtID0gZWxlbXNbaSsrXSkge1xuICAgICAgICAgICAgICAgICAgbm9kZSA9IGVsZW0uZ2V0QXR0cmlidXRlTm9kZShcImlkXCIpO1xuXG4gICAgICAgICAgICAgICAgICBpZiAobm9kZSAmJiBub2RlLnZhbHVlID09PSBpZCkge1xuICAgICAgICAgICAgICAgICAgICByZXR1cm4gW2VsZW1dO1xuICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgIHJldHVybiBbXTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9O1xuICAgICAgICB9IC8vIFRhZ1xuXG5cbiAgICAgICAgRXhwci5maW5kW1wiVEFHXCJdID0gc3VwcG9ydC5nZXRFbGVtZW50c0J5VGFnTmFtZSA/IGZ1bmN0aW9uICh0YWcsIGNvbnRleHQpIHtcbiAgICAgICAgICBpZiAodHlwZW9mIGNvbnRleHQuZ2V0RWxlbWVudHNCeVRhZ05hbWUgIT09IFwidW5kZWZpbmVkXCIpIHtcbiAgICAgICAgICAgIHJldHVybiBjb250ZXh0LmdldEVsZW1lbnRzQnlUYWdOYW1lKHRhZyk7IC8vIERvY3VtZW50RnJhZ21lbnQgbm9kZXMgZG9uJ3QgaGF2ZSBnRUJUTlxuICAgICAgICAgIH0gZWxzZSBpZiAoc3VwcG9ydC5xc2EpIHtcbiAgICAgICAgICAgIHJldHVybiBjb250ZXh0LnF1ZXJ5U2VsZWN0b3JBbGwodGFnKTtcbiAgICAgICAgICB9XG4gICAgICAgIH0gOiBmdW5jdGlvbiAodGFnLCBjb250ZXh0KSB7XG4gICAgICAgICAgdmFyIGVsZW0sXG4gICAgICAgICAgICAgIHRtcCA9IFtdLFxuICAgICAgICAgICAgICBpID0gMCxcbiAgICAgICAgICAgICAgLy8gQnkgaGFwcHkgY29pbmNpZGVuY2UsIGEgKGJyb2tlbikgZ0VCVE4gYXBwZWFycyBvbiBEb2N1bWVudEZyYWdtZW50IG5vZGVzIHRvb1xuICAgICAgICAgIHJlc3VsdHMgPSBjb250ZXh0LmdldEVsZW1lbnRzQnlUYWdOYW1lKHRhZyk7IC8vIEZpbHRlciBvdXQgcG9zc2libGUgY29tbWVudHNcblxuICAgICAgICAgIGlmICh0YWcgPT09IFwiKlwiKSB7XG4gICAgICAgICAgICB3aGlsZSAoZWxlbSA9IHJlc3VsdHNbaSsrXSkge1xuICAgICAgICAgICAgICBpZiAoZWxlbS5ub2RlVHlwZSA9PT0gMSkge1xuICAgICAgICAgICAgICAgIHRtcC5wdXNoKGVsZW0pO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIHJldHVybiB0bXA7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgcmV0dXJuIHJlc3VsdHM7XG4gICAgICAgIH07IC8vIENsYXNzXG5cbiAgICAgICAgRXhwci5maW5kW1wiQ0xBU1NcIl0gPSBzdXBwb3J0LmdldEVsZW1lbnRzQnlDbGFzc05hbWUgJiYgZnVuY3Rpb24gKGNsYXNzTmFtZSwgY29udGV4dCkge1xuICAgICAgICAgIGlmICh0eXBlb2YgY29udGV4dC5nZXRFbGVtZW50c0J5Q2xhc3NOYW1lICE9PSBcInVuZGVmaW5lZFwiICYmIGRvY3VtZW50SXNIVE1MKSB7XG4gICAgICAgICAgICByZXR1cm4gY29udGV4dC5nZXRFbGVtZW50c0J5Q2xhc3NOYW1lKGNsYXNzTmFtZSk7XG4gICAgICAgICAgfVxuICAgICAgICB9O1xuICAgICAgICAvKiBRU0EvbWF0Y2hlc1NlbGVjdG9yXG4gICAgICAgIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0gKi9cbiAgICAgICAgLy8gUVNBIGFuZCBtYXRjaGVzU2VsZWN0b3Igc3VwcG9ydFxuICAgICAgICAvLyBtYXRjaGVzU2VsZWN0b3IoOmFjdGl2ZSkgcmVwb3J0cyBmYWxzZSB3aGVuIHRydWUgKElFOS9PcGVyYSAxMS41KVxuXG5cbiAgICAgICAgcmJ1Z2d5TWF0Y2hlcyA9IFtdOyAvLyBxU2EoOmZvY3VzKSByZXBvcnRzIGZhbHNlIHdoZW4gdHJ1ZSAoQ2hyb21lIDIxKVxuICAgICAgICAvLyBXZSBhbGxvdyB0aGlzIGJlY2F1c2Ugb2YgYSBidWcgaW4gSUU4LzkgdGhhdCB0aHJvd3MgYW4gZXJyb3JcbiAgICAgICAgLy8gd2hlbmV2ZXIgYGRvY3VtZW50LmFjdGl2ZUVsZW1lbnRgIGlzIGFjY2Vzc2VkIG9uIGFuIGlmcmFtZVxuICAgICAgICAvLyBTbywgd2UgYWxsb3cgOmZvY3VzIHRvIHBhc3MgdGhyb3VnaCBRU0EgYWxsIHRoZSB0aW1lIHRvIGF2b2lkIHRoZSBJRSBlcnJvclxuICAgICAgICAvLyBTZWUgaHR0cHM6Ly9idWdzLmpxdWVyeS5jb20vdGlja2V0LzEzMzc4XG5cbiAgICAgICAgcmJ1Z2d5UVNBID0gW107XG5cbiAgICAgICAgaWYgKHN1cHBvcnQucXNhID0gcm5hdGl2ZS50ZXN0KGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3JBbGwpKSB7XG4gICAgICAgICAgLy8gQnVpbGQgUVNBIHJlZ2V4XG4gICAgICAgICAgLy8gUmVnZXggc3RyYXRlZ3kgYWRvcHRlZCBmcm9tIERpZWdvIFBlcmluaVxuICAgICAgICAgIGFzc2VydChmdW5jdGlvbiAoZWwpIHtcbiAgICAgICAgICAgIC8vIFNlbGVjdCBpcyBzZXQgdG8gZW1wdHkgc3RyaW5nIG9uIHB1cnBvc2VcbiAgICAgICAgICAgIC8vIFRoaXMgaXMgdG8gdGVzdCBJRSdzIHRyZWF0bWVudCBvZiBub3QgZXhwbGljaXRseVxuICAgICAgICAgICAgLy8gc2V0dGluZyBhIGJvb2xlYW4gY29udGVudCBhdHRyaWJ1dGUsXG4gICAgICAgICAgICAvLyBzaW5jZSBpdHMgcHJlc2VuY2Ugc2hvdWxkIGJlIGVub3VnaFxuICAgICAgICAgICAgLy8gaHR0cHM6Ly9idWdzLmpxdWVyeS5jb20vdGlja2V0LzEyMzU5XG4gICAgICAgICAgICBkb2NFbGVtLmFwcGVuZENoaWxkKGVsKS5pbm5lckhUTUwgPSBBR1BvbGljeS5jcmVhdGVIVE1MKFwiPGEgaWQ9J1wiICsgZXhwYW5kbyArIFwiJz48L2E+XCIgKyBcIjxzZWxlY3QgaWQ9J1wiICsgZXhwYW5kbyArIFwiLVxcclxcXFwnIG1zYWxsb3djYXB0dXJlPScnPlwiICsgXCI8b3B0aW9uIHNlbGVjdGVkPScnPjwvb3B0aW9uPjwvc2VsZWN0PlwiKTsgLy8gU3VwcG9ydDogSUU4LCBPcGVyYSAxMS0xMi4xNlxuICAgICAgICAgICAgLy8gTm90aGluZyBzaG91bGQgYmUgc2VsZWN0ZWQgd2hlbiBlbXB0eSBzdHJpbmdzIGZvbGxvdyBePSBvciAkPSBvciAqPVxuICAgICAgICAgICAgLy8gVGhlIHRlc3QgYXR0cmlidXRlIG11c3QgYmUgdW5rbm93biBpbiBPcGVyYSBidXQgXCJzYWZlXCIgZm9yIFdpblJUXG4gICAgICAgICAgICAvLyBodHRwczovL21zZG4ubWljcm9zb2Z0LmNvbS9lbi11cy9saWJyYXJ5L2llL2hoNDY1Mzg4LmFzcHgjYXR0cmlidXRlX3NlY3Rpb25cblxuICAgICAgICAgICAgaWYgKGVsLnF1ZXJ5U2VsZWN0b3JBbGwoXCJbbXNhbGxvd2NhcHR1cmVePScnXVwiKS5sZW5ndGgpIHtcbiAgICAgICAgICAgICAgcmJ1Z2d5UVNBLnB1c2goXCJbKl4kXT1cIiArIHdoaXRlc3BhY2UgKyBcIiooPzonJ3xcXFwiXFxcIilcIik7XG4gICAgICAgICAgICB9IC8vIFN1cHBvcnQ6IElFOFxuICAgICAgICAgICAgLy8gQm9vbGVhbiBhdHRyaWJ1dGVzIGFuZCBcInZhbHVlXCIgYXJlIG5vdCB0cmVhdGVkIGNvcnJlY3RseVxuXG5cbiAgICAgICAgICAgIGlmICghZWwucXVlcnlTZWxlY3RvckFsbChcIltzZWxlY3RlZF1cIikubGVuZ3RoKSB7XG4gICAgICAgICAgICAgIHJidWdneVFTQS5wdXNoKFwiXFxcXFtcIiArIHdoaXRlc3BhY2UgKyBcIiooPzp2YWx1ZXxcIiArIGJvb2xlYW5zICsgXCIpXCIpO1xuICAgICAgICAgICAgfSAvLyBTdXBwb3J0OiBDaHJvbWU8MjksIEFuZHJvaWQ8NC40LCBTYWZhcmk8Ny4wKywgaU9TPDcuMCssIFBoYW50b21KUzwxLjkuOCtcblxuXG4gICAgICAgICAgICBpZiAoIWVsLnF1ZXJ5U2VsZWN0b3JBbGwoXCJbaWR+PVwiICsgZXhwYW5kbyArIFwiLV1cIikubGVuZ3RoKSB7XG4gICAgICAgICAgICAgIHJidWdneVFTQS5wdXNoKFwifj1cIik7XG4gICAgICAgICAgICB9IC8vIFdlYmtpdC9PcGVyYSAtIDpjaGVja2VkIHNob3VsZCByZXR1cm4gc2VsZWN0ZWQgb3B0aW9uIGVsZW1lbnRzXG4gICAgICAgICAgICAvLyBodHRwOi8vd3d3LnczLm9yZy9UUi8yMDExL1JFQy1jc3MzLXNlbGVjdG9ycy0yMDExMDkyOS8jY2hlY2tlZFxuICAgICAgICAgICAgLy8gSUU4IHRocm93cyBlcnJvciBoZXJlIGFuZCB3aWxsIG5vdCBzZWUgbGF0ZXIgdGVzdHNcblxuXG4gICAgICAgICAgICBpZiAoIWVsLnF1ZXJ5U2VsZWN0b3JBbGwoXCI6Y2hlY2tlZFwiKS5sZW5ndGgpIHtcbiAgICAgICAgICAgICAgcmJ1Z2d5UVNBLnB1c2goXCI6Y2hlY2tlZFwiKTtcbiAgICAgICAgICAgIH0gLy8gU3VwcG9ydDogU2FmYXJpIDgrLCBpT1MgOCtcbiAgICAgICAgICAgIC8vIGh0dHBzOi8vYnVncy53ZWJraXQub3JnL3Nob3dfYnVnLmNnaT9pZD0xMzY4NTFcbiAgICAgICAgICAgIC8vIEluLXBhZ2UgYHNlbGVjdG9yI2lkIHNpYmxpbmctY29tYmluYXRvciBzZWxlY3RvcmAgZmFpbHNcblxuXG4gICAgICAgICAgICBpZiAoIWVsLnF1ZXJ5U2VsZWN0b3JBbGwoXCJhI1wiICsgZXhwYW5kbyArIFwiKypcIikubGVuZ3RoKSB7XG4gICAgICAgICAgICAgIHJidWdneVFTQS5wdXNoKFwiLiMuK1srfl1cIik7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfSk7XG4gICAgICAgICAgYXNzZXJ0KGZ1bmN0aW9uIChlbCkge1xuICAgICAgICAgICAgZWwuaW5uZXJIVE1MID0gQUdQb2xpY3kuY3JlYXRlSFRNTChcIjxhIGhyZWY9JycgZGlzYWJsZWQ9J2Rpc2FibGVkJz48L2E+XCIgKyBcIjxzZWxlY3QgZGlzYWJsZWQ9J2Rpc2FibGVkJz48b3B0aW9uLz48L3NlbGVjdD5cIik7IC8vIFN1cHBvcnQ6IFdpbmRvd3MgOCBOYXRpdmUgQXBwc1xuICAgICAgICAgICAgLy8gVGhlIHR5cGUgYW5kIG5hbWUgYXR0cmlidXRlcyBhcmUgcmVzdHJpY3RlZCBkdXJpbmcgLmlubmVySFRNTCBhc3NpZ25tZW50XG5cbiAgICAgICAgICAgIHZhciBpbnB1dCA9IGRvY3VtZW50LmNyZWF0ZUVsZW1lbnQoXCJpbnB1dFwiKTtcbiAgICAgICAgICAgIGlucHV0LnNldEF0dHJpYnV0ZShcInR5cGVcIiwgXCJoaWRkZW5cIik7XG4gICAgICAgICAgICBlbC5hcHBlbmRDaGlsZChpbnB1dCkuc2V0QXR0cmlidXRlKFwibmFtZVwiLCBcIkRcIik7IC8vIFN1cHBvcnQ6IElFOFxuICAgICAgICAgICAgLy8gRW5mb3JjZSBjYXNlLXNlbnNpdGl2aXR5IG9mIG5hbWUgYXR0cmlidXRlXG5cbiAgICAgICAgICAgIGlmIChlbC5xdWVyeVNlbGVjdG9yQWxsKFwiW25hbWU9ZF1cIikubGVuZ3RoKSB7XG4gICAgICAgICAgICAgIHJidWdneVFTQS5wdXNoKFwibmFtZVwiICsgd2hpdGVzcGFjZSArIFwiKlsqXiR8IX5dPz1cIik7XG4gICAgICAgICAgICB9IC8vIEZGIDMuNSAtIDplbmFibGVkLzpkaXNhYmxlZCBhbmQgaGlkZGVuIGVsZW1lbnRzIChoaWRkZW4gZWxlbWVudHMgYXJlIHN0aWxsIGVuYWJsZWQpXG4gICAgICAgICAgICAvLyBJRTggdGhyb3dzIGVycm9yIGhlcmUgYW5kIHdpbGwgbm90IHNlZSBsYXRlciB0ZXN0c1xuXG5cbiAgICAgICAgICAgIGlmIChlbC5xdWVyeVNlbGVjdG9yQWxsKFwiOmVuYWJsZWRcIikubGVuZ3RoICE9PSAyKSB7XG4gICAgICAgICAgICAgIHJidWdneVFTQS5wdXNoKFwiOmVuYWJsZWRcIiwgXCI6ZGlzYWJsZWRcIik7XG4gICAgICAgICAgICB9IC8vIFN1cHBvcnQ6IElFOS0xMStcbiAgICAgICAgICAgIC8vIElFJ3MgOmRpc2FibGVkIHNlbGVjdG9yIGRvZXMgbm90IHBpY2sgdXAgdGhlIGNoaWxkcmVuIG9mIGRpc2FibGVkIGZpZWxkc2V0c1xuXG5cbiAgICAgICAgICAgIGRvY0VsZW0uYXBwZW5kQ2hpbGQoZWwpLmRpc2FibGVkID0gdHJ1ZTtcblxuICAgICAgICAgICAgaWYgKGVsLnF1ZXJ5U2VsZWN0b3JBbGwoXCI6ZGlzYWJsZWRcIikubGVuZ3RoICE9PSAyKSB7XG4gICAgICAgICAgICAgIHJidWdneVFTQS5wdXNoKFwiOmVuYWJsZWRcIiwgXCI6ZGlzYWJsZWRcIik7XG4gICAgICAgICAgICB9IC8vIE9wZXJhIDEwLTExIGRvZXMgbm90IHRocm93IG9uIHBvc3QtY29tbWEgaW52YWxpZCBwc2V1ZG9zXG5cblxuICAgICAgICAgICAgZWwucXVlcnlTZWxlY3RvckFsbChcIiosOnhcIik7XG4gICAgICAgICAgICByYnVnZ3lRU0EucHVzaChcIiwuKjpcIik7XG4gICAgICAgICAgfSk7XG4gICAgICAgIH1cblxuICAgICAgICBpZiAoc3VwcG9ydC5tYXRjaGVzU2VsZWN0b3IgPSBybmF0aXZlLnRlc3QobWF0Y2hlcyA9IGRvY0VsZW0ubWF0Y2hlcyB8fCBkb2NFbGVtLndlYmtpdE1hdGNoZXNTZWxlY3RvciB8fCBkb2NFbGVtLm1vek1hdGNoZXNTZWxlY3RvciB8fCBkb2NFbGVtLm9NYXRjaGVzU2VsZWN0b3IgfHwgZG9jRWxlbS5tc01hdGNoZXNTZWxlY3RvcikpIHtcbiAgICAgICAgICBhc3NlcnQoZnVuY3Rpb24gKGVsKSB7XG4gICAgICAgICAgICAvLyBDaGVjayB0byBzZWUgaWYgaXQncyBwb3NzaWJsZSB0byBkbyBtYXRjaGVzU2VsZWN0b3JcbiAgICAgICAgICAgIC8vIG9uIGEgZGlzY29ubmVjdGVkIG5vZGUgKElFIDkpXG4gICAgICAgICAgICBzdXBwb3J0LmRpc2Nvbm5lY3RlZE1hdGNoID0gbWF0Y2hlcy5jYWxsKGVsLCBcIipcIik7IC8vIFRoaXMgc2hvdWxkIGZhaWwgd2l0aCBhbiBleGNlcHRpb25cbiAgICAgICAgICAgIC8vIEdlY2tvIGRvZXMgbm90IGVycm9yLCByZXR1cm5zIGZhbHNlIGluc3RlYWRcblxuICAgICAgICAgICAgbWF0Y2hlcy5jYWxsKGVsLCBcIltzIT0nJ106eFwiKTtcbiAgICAgICAgICAgIHJidWdneU1hdGNoZXMucHVzaChcIiE9XCIsIHBzZXVkb3MpO1xuICAgICAgICAgIH0pO1xuICAgICAgICB9XG5cbiAgICAgICAgcmJ1Z2d5UVNBID0gcmJ1Z2d5UVNBLmxlbmd0aCAmJiBuZXcgUmVnRXhwKHJidWdneVFTQS5qb2luKFwifFwiKSk7XG4gICAgICAgIHJidWdneU1hdGNoZXMgPSByYnVnZ3lNYXRjaGVzLmxlbmd0aCAmJiBuZXcgUmVnRXhwKHJidWdneU1hdGNoZXMuam9pbihcInxcIikpO1xuICAgICAgICAvKiBDb250YWluc1xuICAgICAgICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tICovXG5cbiAgICAgICAgaGFzQ29tcGFyZSA9IHJuYXRpdmUudGVzdChkb2NFbGVtLmNvbXBhcmVEb2N1bWVudFBvc2l0aW9uKTsgLy8gRWxlbWVudCBjb250YWlucyBhbm90aGVyXG4gICAgICAgIC8vIFB1cnBvc2VmdWxseSBzZWxmLWV4Y2x1c2l2ZVxuICAgICAgICAvLyBBcyBpbiwgYW4gZWxlbWVudCBkb2VzIG5vdCBjb250YWluIGl0c2VsZlxuXG4gICAgICAgIGNvbnRhaW5zID0gaGFzQ29tcGFyZSB8fCBybmF0aXZlLnRlc3QoZG9jRWxlbS5jb250YWlucykgPyBmdW5jdGlvbiAoYSwgYikge1xuICAgICAgICAgIHZhciBhZG93biA9IGEubm9kZVR5cGUgPT09IDkgPyBhLmRvY3VtZW50RWxlbWVudCA6IGEsXG4gICAgICAgICAgICAgIGJ1cCA9IGIgJiYgYi5wYXJlbnROb2RlO1xuICAgICAgICAgIHJldHVybiBhID09PSBidXAgfHwgISEoYnVwICYmIGJ1cC5ub2RlVHlwZSA9PT0gMSAmJiAoYWRvd24uY29udGFpbnMgPyBhZG93bi5jb250YWlucyhidXApIDogYS5jb21wYXJlRG9jdW1lbnRQb3NpdGlvbiAmJiBhLmNvbXBhcmVEb2N1bWVudFBvc2l0aW9uKGJ1cCkgJiAxNikpO1xuICAgICAgICB9IDogZnVuY3Rpb24gKGEsIGIpIHtcbiAgICAgICAgICBpZiAoYikge1xuICAgICAgICAgICAgd2hpbGUgKGIgPSBiLnBhcmVudE5vZGUpIHtcbiAgICAgICAgICAgICAgaWYgKGIgPT09IGEpIHtcbiAgICAgICAgICAgICAgICByZXR1cm4gdHJ1ZTtcbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cblxuICAgICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgICAgfTtcbiAgICAgICAgLyogU29ydGluZ1xuICAgICAgICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tICovXG4gICAgICAgIC8vIERvY3VtZW50IG9yZGVyIHNvcnRpbmdcblxuICAgICAgICBzb3J0T3JkZXIgPSBoYXNDb21wYXJlID8gZnVuY3Rpb24gKGEsIGIpIHtcbiAgICAgICAgICAvLyBGbGFnIGZvciBkdXBsaWNhdGUgcmVtb3ZhbFxuICAgICAgICAgIGlmIChhID09PSBiKSB7XG4gICAgICAgICAgICBoYXNEdXBsaWNhdGUgPSB0cnVlO1xuICAgICAgICAgICAgcmV0dXJuIDA7XG4gICAgICAgICAgfSAvLyBTb3J0IG9uIG1ldGhvZCBleGlzdGVuY2UgaWYgb25seSBvbmUgaW5wdXQgaGFzIGNvbXBhcmVEb2N1bWVudFBvc2l0aW9uXG5cblxuICAgICAgICAgIHZhciBjb21wYXJlID0gIWEuY29tcGFyZURvY3VtZW50UG9zaXRpb24gLSAhYi5jb21wYXJlRG9jdW1lbnRQb3NpdGlvbjtcblxuICAgICAgICAgIGlmIChjb21wYXJlKSB7XG4gICAgICAgICAgICByZXR1cm4gY29tcGFyZTtcbiAgICAgICAgICB9IC8vIENhbGN1bGF0ZSBwb3NpdGlvbiBpZiBib3RoIGlucHV0cyBiZWxvbmcgdG8gdGhlIHNhbWUgZG9jdW1lbnRcblxuXG4gICAgICAgICAgY29tcGFyZSA9IChhLm93bmVyRG9jdW1lbnQgfHwgYSkgPT09IChiLm93bmVyRG9jdW1lbnQgfHwgYikgPyBhLmNvbXBhcmVEb2N1bWVudFBvc2l0aW9uKGIpIDogLy8gT3RoZXJ3aXNlIHdlIGtub3cgdGhleSBhcmUgZGlzY29ubmVjdGVkXG4gICAgICAgICAgMTsgLy8gRGlzY29ubmVjdGVkIG5vZGVzXG5cbiAgICAgICAgICBpZiAoY29tcGFyZSAmIDEgfHwgIXN1cHBvcnQuc29ydERldGFjaGVkICYmIGIuY29tcGFyZURvY3VtZW50UG9zaXRpb24oYSkgPT09IGNvbXBhcmUpIHtcbiAgICAgICAgICAgIC8vIENob29zZSB0aGUgZmlyc3QgZWxlbWVudCB0aGF0IGlzIHJlbGF0ZWQgdG8gb3VyIHByZWZlcnJlZCBkb2N1bWVudFxuICAgICAgICAgICAgaWYgKGEgPT09IGRvY3VtZW50IHx8IGEub3duZXJEb2N1bWVudCA9PT0gcHJlZmVycmVkRG9jICYmIGNvbnRhaW5zKHByZWZlcnJlZERvYywgYSkpIHtcbiAgICAgICAgICAgICAgcmV0dXJuIC0xO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICBpZiAoYiA9PT0gZG9jdW1lbnQgfHwgYi5vd25lckRvY3VtZW50ID09PSBwcmVmZXJyZWREb2MgJiYgY29udGFpbnMocHJlZmVycmVkRG9jLCBiKSkge1xuICAgICAgICAgICAgICByZXR1cm4gMTtcbiAgICAgICAgICAgIH0gLy8gTWFpbnRhaW4gb3JpZ2luYWwgb3JkZXJcblxuXG4gICAgICAgICAgICByZXR1cm4gc29ydElucHV0ID8gaW5kZXhPZihzb3J0SW5wdXQsIGEpIC0gaW5kZXhPZihzb3J0SW5wdXQsIGIpIDogMDtcbiAgICAgICAgICB9XG5cbiAgICAgICAgICByZXR1cm4gY29tcGFyZSAmIDQgPyAtMSA6IDE7XG4gICAgICAgIH0gOiBmdW5jdGlvbiAoYSwgYikge1xuICAgICAgICAgIC8vIEV4aXQgZWFybHkgaWYgdGhlIG5vZGVzIGFyZSBpZGVudGljYWxcbiAgICAgICAgICBpZiAoYSA9PT0gYikge1xuICAgICAgICAgICAgaGFzRHVwbGljYXRlID0gdHJ1ZTtcbiAgICAgICAgICAgIHJldHVybiAwO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIHZhciBjdXIsXG4gICAgICAgICAgICAgIGkgPSAwLFxuICAgICAgICAgICAgICBhdXAgPSBhLnBhcmVudE5vZGUsXG4gICAgICAgICAgICAgIGJ1cCA9IGIucGFyZW50Tm9kZSxcbiAgICAgICAgICAgICAgYXAgPSBbYV0sXG4gICAgICAgICAgICAgIGJwID0gW2JdOyAvLyBQYXJlbnRsZXNzIG5vZGVzIGFyZSBlaXRoZXIgZG9jdW1lbnRzIG9yIGRpc2Nvbm5lY3RlZFxuXG4gICAgICAgICAgaWYgKCFhdXAgfHwgIWJ1cCkge1xuICAgICAgICAgICAgcmV0dXJuIGEgPT09IGRvY3VtZW50ID8gLTEgOiBiID09PSBkb2N1bWVudCA/IDEgOiBhdXAgPyAtMSA6IGJ1cCA/IDEgOiBzb3J0SW5wdXQgPyBpbmRleE9mKHNvcnRJbnB1dCwgYSkgLSBpbmRleE9mKHNvcnRJbnB1dCwgYikgOiAwOyAvLyBJZiB0aGUgbm9kZXMgYXJlIHNpYmxpbmdzLCB3ZSBjYW4gZG8gYSBxdWljayBjaGVja1xuICAgICAgICAgIH0gZWxzZSBpZiAoYXVwID09PSBidXApIHtcbiAgICAgICAgICAgIHJldHVybiBzaWJsaW5nQ2hlY2soYSwgYik7XG4gICAgICAgICAgfSAvLyBPdGhlcndpc2Ugd2UgbmVlZCBmdWxsIGxpc3RzIG9mIHRoZWlyIGFuY2VzdG9ycyBmb3IgY29tcGFyaXNvblxuXG5cbiAgICAgICAgICBjdXIgPSBhO1xuXG4gICAgICAgICAgd2hpbGUgKGN1ciA9IGN1ci5wYXJlbnROb2RlKSB7XG4gICAgICAgICAgICBhcC51bnNoaWZ0KGN1cik7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgY3VyID0gYjtcblxuICAgICAgICAgIHdoaWxlIChjdXIgPSBjdXIucGFyZW50Tm9kZSkge1xuICAgICAgICAgICAgYnAudW5zaGlmdChjdXIpO1xuICAgICAgICAgIH0gLy8gV2FsayBkb3duIHRoZSB0cmVlIGxvb2tpbmcgZm9yIGEgZGlzY3JlcGFuY3lcblxuXG4gICAgICAgICAgd2hpbGUgKGFwW2ldID09PSBicFtpXSkge1xuICAgICAgICAgICAgaSsrO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIHJldHVybiBpID8gLy8gRG8gYSBzaWJsaW5nIGNoZWNrIGlmIHRoZSBub2RlcyBoYXZlIGEgY29tbW9uIGFuY2VzdG9yXG4gICAgICAgICAgc2libGluZ0NoZWNrKGFwW2ldLCBicFtpXSkgOiAvLyBPdGhlcndpc2Ugbm9kZXMgaW4gb3VyIGRvY3VtZW50IHNvcnQgZmlyc3RcbiAgICAgICAgICBhcFtpXSA9PT0gcHJlZmVycmVkRG9jID8gLTEgOiBicFtpXSA9PT0gcHJlZmVycmVkRG9jID8gMSA6IDA7XG4gICAgICAgIH07XG4gICAgICAgIHJldHVybiBkb2N1bWVudDtcbiAgICAgIH07XG5cbiAgICAgIFNpenpsZS5tYXRjaGVzID0gZnVuY3Rpb24gKGV4cHIsIGVsZW1lbnRzKSB7XG4gICAgICAgIHJldHVybiBTaXp6bGUoZXhwciwgbnVsbCwgbnVsbCwgZWxlbWVudHMpO1xuICAgICAgfTtcblxuICAgICAgU2l6emxlLm1hdGNoZXNTZWxlY3RvciA9IGZ1bmN0aW9uIChlbGVtLCBleHByKSB7XG4gICAgICAgIC8vIFNldCBkb2N1bWVudCB2YXJzIGlmIG5lZWRlZFxuICAgICAgICBpZiAoKGVsZW0ub3duZXJEb2N1bWVudCB8fCBlbGVtKSAhPT0gZG9jdW1lbnQpIHtcbiAgICAgICAgICBzZXREb2N1bWVudChlbGVtKTtcbiAgICAgICAgfVxuXG4gICAgICAgIGlmIChzdXBwb3J0Lm1hdGNoZXNTZWxlY3RvciAmJiBkb2N1bWVudElzSFRNTCAmJiAhbm9ubmF0aXZlU2VsZWN0b3JDYWNoZVtleHByICsgXCIgXCJdICYmICghcmJ1Z2d5TWF0Y2hlcyB8fCAhcmJ1Z2d5TWF0Y2hlcy50ZXN0KGV4cHIpKSAmJiAoIXJidWdneVFTQSB8fCAhcmJ1Z2d5UVNBLnRlc3QoZXhwcikpKSB7XG4gICAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgIHZhciByZXQgPSBtYXRjaGVzLmNhbGwoZWxlbSwgZXhwcik7IC8vIElFIDkncyBtYXRjaGVzU2VsZWN0b3IgcmV0dXJucyBmYWxzZSBvbiBkaXNjb25uZWN0ZWQgbm9kZXNcblxuICAgICAgICAgICAgaWYgKHJldCB8fCBzdXBwb3J0LmRpc2Nvbm5lY3RlZE1hdGNoIHx8IC8vIEFzIHdlbGwsIGRpc2Nvbm5lY3RlZCBub2RlcyBhcmUgc2FpZCB0byBiZSBpbiBhIGRvY3VtZW50XG4gICAgICAgICAgICAvLyBmcmFnbWVudCBpbiBJRSA5XG4gICAgICAgICAgICBlbGVtLmRvY3VtZW50ICYmIGVsZW0uZG9jdW1lbnQubm9kZVR5cGUgIT09IDExKSB7XG4gICAgICAgICAgICAgIHJldHVybiByZXQ7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICAgICAgLy8gW0FkR3VhcmQgUGF0aF06IEZpeCB0aGUgY2FjaGUgdmFsdWVcbiAgICAgICAgICAgIG5vbm5hdGl2ZVNlbGVjdG9yQ2FjaGUoZXhwciwgdHJ1ZSk7XG4gICAgICAgICAgfVxuICAgICAgICB9XG5cbiAgICAgICAgcmV0dXJuIFNpenpsZShleHByLCBkb2N1bWVudCwgbnVsbCwgW2VsZW1dKS5sZW5ndGggPiAwO1xuICAgICAgfTtcblxuICAgICAgU2l6emxlLmNvbnRhaW5zID0gZnVuY3Rpb24gKGNvbnRleHQsIGVsZW0pIHtcbiAgICAgICAgLy8gU2V0IGRvY3VtZW50IHZhcnMgaWYgbmVlZGVkXG4gICAgICAgIGlmICgoY29udGV4dC5vd25lckRvY3VtZW50IHx8IGNvbnRleHQpICE9PSBkb2N1bWVudCkge1xuICAgICAgICAgIHNldERvY3VtZW50KGNvbnRleHQpO1xuICAgICAgICB9XG5cbiAgICAgICAgcmV0dXJuIGNvbnRhaW5zKGNvbnRleHQsIGVsZW0pO1xuICAgICAgfTtcblxuICAgICAgU2l6emxlLmF0dHIgPSBmdW5jdGlvbiAoZWxlbSwgbmFtZSkge1xuICAgICAgICAvLyBTZXQgZG9jdW1lbnQgdmFycyBpZiBuZWVkZWRcbiAgICAgICAgaWYgKChlbGVtLm93bmVyRG9jdW1lbnQgfHwgZWxlbSkgIT09IGRvY3VtZW50KSB7XG4gICAgICAgICAgc2V0RG9jdW1lbnQoZWxlbSk7XG4gICAgICAgIH1cblxuICAgICAgICB2YXIgZm4gPSBFeHByLmF0dHJIYW5kbGVbbmFtZS50b0xvd2VyQ2FzZSgpXSxcbiAgICAgICAgICAgIC8vIERvbid0IGdldCBmb29sZWQgYnkgT2JqZWN0LnByb3RvdHlwZSBwcm9wZXJ0aWVzIChqUXVlcnkgIzEzODA3KVxuICAgICAgICB2YWwgPSBmbiAmJiBoYXNPd24uY2FsbChFeHByLmF0dHJIYW5kbGUsIG5hbWUudG9Mb3dlckNhc2UoKSkgPyBmbihlbGVtLCBuYW1lLCAhZG9jdW1lbnRJc0hUTUwpIDogdW5kZWZpbmVkO1xuICAgICAgICByZXR1cm4gdmFsICE9PSB1bmRlZmluZWQgPyB2YWwgOiBzdXBwb3J0LmF0dHJpYnV0ZXMgfHwgIWRvY3VtZW50SXNIVE1MID8gZWxlbS5nZXRBdHRyaWJ1dGUobmFtZSkgOiAodmFsID0gZWxlbS5nZXRBdHRyaWJ1dGVOb2RlKG5hbWUpKSAmJiB2YWwuc3BlY2lmaWVkID8gdmFsLnZhbHVlIDogbnVsbDtcbiAgICAgIH07XG5cbiAgICAgIFNpenpsZS5lc2NhcGUgPSBmdW5jdGlvbiAoc2VsKSB7XG4gICAgICAgIHJldHVybiAoc2VsICsgXCJcIikucmVwbGFjZShyY3NzZXNjYXBlLCBmY3NzZXNjYXBlKTtcbiAgICAgIH07XG5cbiAgICAgIFNpenpsZS5lcnJvciA9IGZ1bmN0aW9uIChtc2cpIHtcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiU3ludGF4IGVycm9yLCB1bnJlY29nbml6ZWQgZXhwcmVzc2lvbjogXCIgKyBtc2cpO1xuICAgICAgfTtcbiAgICAgIC8qKlxuICAgICAgICogRG9jdW1lbnQgc29ydGluZyBhbmQgcmVtb3ZpbmcgZHVwbGljYXRlc1xuICAgICAgICogQHBhcmFtIHtBcnJheUxpa2V9IHJlc3VsdHNcbiAgICAgICAqL1xuXG5cbiAgICAgIFNpenpsZS51bmlxdWVTb3J0ID0gZnVuY3Rpb24gKHJlc3VsdHMpIHtcbiAgICAgICAgdmFyIGVsZW0sXG4gICAgICAgICAgICBkdXBsaWNhdGVzID0gW10sXG4gICAgICAgICAgICBqID0gMCxcbiAgICAgICAgICAgIGkgPSAwOyAvLyBVbmxlc3Mgd2UgKmtub3cqIHdlIGNhbiBkZXRlY3QgZHVwbGljYXRlcywgYXNzdW1lIHRoZWlyIHByZXNlbmNlXG5cbiAgICAgICAgaGFzRHVwbGljYXRlID0gIXN1cHBvcnQuZGV0ZWN0RHVwbGljYXRlcztcbiAgICAgICAgc29ydElucHV0ID0gIXN1cHBvcnQuc29ydFN0YWJsZSAmJiByZXN1bHRzLnNsaWNlKDApO1xuICAgICAgICByZXN1bHRzLnNvcnQoc29ydE9yZGVyKTtcblxuICAgICAgICBpZiAoaGFzRHVwbGljYXRlKSB7XG4gICAgICAgICAgd2hpbGUgKGVsZW0gPSByZXN1bHRzW2krK10pIHtcbiAgICAgICAgICAgIGlmIChlbGVtID09PSByZXN1bHRzW2ldKSB7XG4gICAgICAgICAgICAgIGogPSBkdXBsaWNhdGVzLnB1c2goaSk7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgd2hpbGUgKGotLSkge1xuICAgICAgICAgICAgcmVzdWx0cy5zcGxpY2UoZHVwbGljYXRlc1tqXSwgMSk7XG4gICAgICAgICAgfVxuICAgICAgICB9IC8vIENsZWFyIGlucHV0IGFmdGVyIHNvcnRpbmcgdG8gcmVsZWFzZSBvYmplY3RzXG4gICAgICAgIC8vIFNlZSBodHRwczovL2dpdGh1Yi5jb20vanF1ZXJ5L3NpenpsZS9wdWxsLzIyNVxuXG5cbiAgICAgICAgc29ydElucHV0ID0gbnVsbDtcbiAgICAgICAgcmV0dXJuIHJlc3VsdHM7XG4gICAgICB9O1xuICAgICAgLyoqXG4gICAgICAgKiBVdGlsaXR5IGZ1bmN0aW9uIGZvciByZXRyaWV2aW5nIHRoZSB0ZXh0IHZhbHVlIG9mIGFuIGFycmF5IG9mIERPTSBub2Rlc1xuICAgICAgICogQHBhcmFtIHtBcnJheXxFbGVtZW50fSBlbGVtXG4gICAgICAgKi9cblxuXG4gICAgICBnZXRUZXh0ID0gU2l6emxlLmdldFRleHQgPSBmdW5jdGlvbiAoZWxlbSkge1xuICAgICAgICB2YXIgbm9kZSxcbiAgICAgICAgICAgIHJldCA9IFwiXCIsXG4gICAgICAgICAgICBpID0gMCxcbiAgICAgICAgICAgIG5vZGVUeXBlID0gZWxlbS5ub2RlVHlwZTtcblxuICAgICAgICBpZiAoIW5vZGVUeXBlKSB7XG4gICAgICAgICAgLy8gSWYgbm8gbm9kZVR5cGUsIHRoaXMgaXMgZXhwZWN0ZWQgdG8gYmUgYW4gYXJyYXlcbiAgICAgICAgICB3aGlsZSAobm9kZSA9IGVsZW1baSsrXSkge1xuICAgICAgICAgICAgLy8gRG8gbm90IHRyYXZlcnNlIGNvbW1lbnQgbm9kZXNcbiAgICAgICAgICAgIHJldCArPSBnZXRUZXh0KG5vZGUpO1xuICAgICAgICAgIH1cbiAgICAgICAgfSBlbHNlIGlmIChub2RlVHlwZSA9PT0gMSB8fCBub2RlVHlwZSA9PT0gOSB8fCBub2RlVHlwZSA9PT0gMTEpIHtcbiAgICAgICAgICAvLyBVc2UgdGV4dENvbnRlbnQgZm9yIGVsZW1lbnRzXG4gICAgICAgICAgLy8gaW5uZXJUZXh0IHVzYWdlIHJlbW92ZWQgZm9yIGNvbnNpc3RlbmN5IG9mIG5ldyBsaW5lcyAoalF1ZXJ5ICMxMTE1MylcbiAgICAgICAgICBpZiAodHlwZW9mIGVsZW0udGV4dENvbnRlbnQgPT09IFwic3RyaW5nXCIpIHtcbiAgICAgICAgICAgIHJldHVybiBlbGVtLnRleHRDb250ZW50O1xuICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAvLyBUcmF2ZXJzZSBpdHMgY2hpbGRyZW5cbiAgICAgICAgICAgIGZvciAoZWxlbSA9IGVsZW0uZmlyc3RDaGlsZDsgZWxlbTsgZWxlbSA9IGVsZW0ubmV4dFNpYmxpbmcpIHtcbiAgICAgICAgICAgICAgcmV0ICs9IGdldFRleHQoZWxlbSk7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfVxuICAgICAgICB9IGVsc2UgaWYgKG5vZGVUeXBlID09PSAzIHx8IG5vZGVUeXBlID09PSA0KSB7XG4gICAgICAgICAgcmV0dXJuIGVsZW0ubm9kZVZhbHVlO1xuICAgICAgICB9IC8vIERvIG5vdCBpbmNsdWRlIGNvbW1lbnQgb3IgcHJvY2Vzc2luZyBpbnN0cnVjdGlvbiBub2Rlc1xuXG5cbiAgICAgICAgcmV0dXJuIHJldDtcbiAgICAgIH07XG5cbiAgICAgIEV4cHIgPSBTaXp6bGUuc2VsZWN0b3JzID0ge1xuICAgICAgICAvLyBDYW4gYmUgYWRqdXN0ZWQgYnkgdGhlIHVzZXJcbiAgICAgICAgY2FjaGVMZW5ndGg6IDUwLFxuICAgICAgICBjcmVhdGVQc2V1ZG86IG1hcmtGdW5jdGlvbixcbiAgICAgICAgbWF0Y2g6IG1hdGNoRXhwcixcbiAgICAgICAgYXR0ckhhbmRsZToge30sXG4gICAgICAgIGZpbmQ6IHt9LFxuICAgICAgICByZWxhdGl2ZToge1xuICAgICAgICAgIFwiPlwiOiB7XG4gICAgICAgICAgICBkaXI6IFwicGFyZW50Tm9kZVwiLFxuICAgICAgICAgICAgZmlyc3Q6IHRydWVcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiIFwiOiB7XG4gICAgICAgICAgICBkaXI6IFwicGFyZW50Tm9kZVwiXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcIitcIjoge1xuICAgICAgICAgICAgZGlyOiBcInByZXZpb3VzU2libGluZ1wiLFxuICAgICAgICAgICAgZmlyc3Q6IHRydWVcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiflwiOiB7XG4gICAgICAgICAgICBkaXI6IFwicHJldmlvdXNTaWJsaW5nXCJcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIHByZUZpbHRlcjoge1xuICAgICAgICAgIFwiQVRUUlwiOiBmdW5jdGlvbiBBVFRSKG1hdGNoKSB7XG4gICAgICAgICAgICBtYXRjaFsxXSA9IG1hdGNoWzFdLnJlcGxhY2UocnVuZXNjYXBlLCBmdW5lc2NhcGUpOyAvLyBNb3ZlIHRoZSBnaXZlbiB2YWx1ZSB0byBtYXRjaFszXSB3aGV0aGVyIHF1b3RlZCBvciB1bnF1b3RlZFxuXG4gICAgICAgICAgICBtYXRjaFszXSA9IChtYXRjaFszXSB8fCBtYXRjaFs0XSB8fCBtYXRjaFs1XSB8fCBcIlwiKS5yZXBsYWNlKHJ1bmVzY2FwZSwgZnVuZXNjYXBlKTtcblxuICAgICAgICAgICAgaWYgKG1hdGNoWzJdID09PSBcIn49XCIpIHtcbiAgICAgICAgICAgICAgbWF0Y2hbM10gPSBcIiBcIiArIG1hdGNoWzNdICsgXCIgXCI7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIHJldHVybiBtYXRjaC5zbGljZSgwLCA0KTtcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiQ0hJTERcIjogZnVuY3Rpb24gQ0hJTEQobWF0Y2gpIHtcbiAgICAgICAgICAgIC8qIG1hdGNoZXMgZnJvbSBtYXRjaEV4cHJbXCJDSElMRFwiXVxuICAgICAgICAgICAgXHQxIHR5cGUgKG9ubHl8bnRofC4uLilcbiAgICAgICAgICAgIFx0MiB3aGF0IChjaGlsZHxvZi10eXBlKVxuICAgICAgICAgICAgXHQzIGFyZ3VtZW50IChldmVufG9kZHxcXGQqfFxcZCpuKFsrLV1cXGQrKT98Li4uKVxuICAgICAgICAgICAgXHQ0IHhuLWNvbXBvbmVudCBvZiB4bit5IGFyZ3VtZW50IChbKy1dP1xcZCpufClcbiAgICAgICAgICAgIFx0NSBzaWduIG9mIHhuLWNvbXBvbmVudFxuICAgICAgICAgICAgXHQ2IHggb2YgeG4tY29tcG9uZW50XG4gICAgICAgICAgICBcdDcgc2lnbiBvZiB5LWNvbXBvbmVudFxuICAgICAgICAgICAgXHQ4IHkgb2YgeS1jb21wb25lbnRcbiAgICAgICAgICAgICovXG4gICAgICAgICAgICBtYXRjaFsxXSA9IG1hdGNoWzFdLnRvTG93ZXJDYXNlKCk7XG5cbiAgICAgICAgICAgIGlmIChtYXRjaFsxXS5zbGljZSgwLCAzKSA9PT0gXCJudGhcIikge1xuICAgICAgICAgICAgICAvLyBudGgtKiByZXF1aXJlcyBhcmd1bWVudFxuICAgICAgICAgICAgICBpZiAoIW1hdGNoWzNdKSB7XG4gICAgICAgICAgICAgICAgU2l6emxlLmVycm9yKG1hdGNoWzBdKTtcbiAgICAgICAgICAgICAgfSAvLyBudW1lcmljIHggYW5kIHkgcGFyYW1ldGVycyBmb3IgRXhwci5maWx0ZXIuQ0hJTERcbiAgICAgICAgICAgICAgLy8gcmVtZW1iZXIgdGhhdCBmYWxzZS90cnVlIGNhc3QgcmVzcGVjdGl2ZWx5IHRvIDAvMVxuXG5cbiAgICAgICAgICAgICAgbWF0Y2hbNF0gPSArKG1hdGNoWzRdID8gbWF0Y2hbNV0gKyAobWF0Y2hbNl0gfHwgMSkgOiAyICogKG1hdGNoWzNdID09PSBcImV2ZW5cIiB8fCBtYXRjaFszXSA9PT0gXCJvZGRcIikpO1xuICAgICAgICAgICAgICBtYXRjaFs1XSA9ICsobWF0Y2hbN10gKyBtYXRjaFs4XSB8fCBtYXRjaFszXSA9PT0gXCJvZGRcIik7IC8vIG90aGVyIHR5cGVzIHByb2hpYml0IGFyZ3VtZW50c1xuICAgICAgICAgICAgfSBlbHNlIGlmIChtYXRjaFszXSkge1xuICAgICAgICAgICAgICBTaXp6bGUuZXJyb3IobWF0Y2hbMF0pO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICByZXR1cm4gbWF0Y2g7XG4gICAgICAgICAgfSxcbiAgICAgICAgICBcIlBTRVVET1wiOiBmdW5jdGlvbiBQU0VVRE8obWF0Y2gpIHtcbiAgICAgICAgICAgIHZhciBleGNlc3MsXG4gICAgICAgICAgICAgICAgdW5xdW90ZWQgPSAhbWF0Y2hbNl0gJiYgbWF0Y2hbMl07XG5cbiAgICAgICAgICAgIGlmIChtYXRjaEV4cHJbXCJDSElMRFwiXS50ZXN0KG1hdGNoWzBdKSkge1xuICAgICAgICAgICAgICByZXR1cm4gbnVsbDtcbiAgICAgICAgICAgIH0gLy8gQWNjZXB0IHF1b3RlZCBhcmd1bWVudHMgYXMtaXNcblxuXG4gICAgICAgICAgICBpZiAobWF0Y2hbM10pIHtcbiAgICAgICAgICAgICAgbWF0Y2hbMl0gPSBtYXRjaFs0XSB8fCBtYXRjaFs1XSB8fCBcIlwiOyAvLyBTdHJpcCBleGNlc3MgY2hhcmFjdGVycyBmcm9tIHVucXVvdGVkIGFyZ3VtZW50c1xuICAgICAgICAgICAgfSBlbHNlIGlmICh1bnF1b3RlZCAmJiBycHNldWRvLnRlc3QodW5xdW90ZWQpICYmICggLy8gR2V0IGV4Y2VzcyBmcm9tIHRva2VuaXplIChyZWN1cnNpdmVseSlcbiAgICAgICAgICAgIGV4Y2VzcyA9IHRva2VuaXplKHVucXVvdGVkLCB0cnVlKSkgJiYgKCAvLyBhZHZhbmNlIHRvIHRoZSBuZXh0IGNsb3NpbmcgcGFyZW50aGVzaXNcbiAgICAgICAgICAgIGV4Y2VzcyA9IHVucXVvdGVkLmluZGV4T2YoXCIpXCIsIHVucXVvdGVkLmxlbmd0aCAtIGV4Y2VzcykgLSB1bnF1b3RlZC5sZW5ndGgpKSB7XG4gICAgICAgICAgICAgIC8vIGV4Y2VzcyBpcyBhIG5lZ2F0aXZlIGluZGV4XG4gICAgICAgICAgICAgIG1hdGNoWzBdID0gbWF0Y2hbMF0uc2xpY2UoMCwgZXhjZXNzKTtcbiAgICAgICAgICAgICAgbWF0Y2hbMl0gPSB1bnF1b3RlZC5zbGljZSgwLCBleGNlc3MpO1xuICAgICAgICAgICAgfSAvLyBSZXR1cm4gb25seSBjYXB0dXJlcyBuZWVkZWQgYnkgdGhlIHBzZXVkbyBmaWx0ZXIgbWV0aG9kICh0eXBlIGFuZCBhcmd1bWVudClcblxuXG4gICAgICAgICAgICByZXR1cm4gbWF0Y2guc2xpY2UoMCwgMyk7XG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBmaWx0ZXI6IHtcbiAgICAgICAgICBcIlRBR1wiOiBmdW5jdGlvbiBUQUcobm9kZU5hbWVTZWxlY3Rvcikge1xuICAgICAgICAgICAgdmFyIG5vZGVOYW1lID0gbm9kZU5hbWVTZWxlY3Rvci5yZXBsYWNlKHJ1bmVzY2FwZSwgZnVuZXNjYXBlKS50b0xvd2VyQ2FzZSgpO1xuICAgICAgICAgICAgcmV0dXJuIG5vZGVOYW1lU2VsZWN0b3IgPT09IFwiKlwiID8gZnVuY3Rpb24gKCkge1xuICAgICAgICAgICAgICByZXR1cm4gdHJ1ZTtcbiAgICAgICAgICAgIH0gOiBmdW5jdGlvbiAoZWxlbSkge1xuICAgICAgICAgICAgICByZXR1cm4gZWxlbS5ub2RlTmFtZSAmJiBlbGVtLm5vZGVOYW1lLnRvTG93ZXJDYXNlKCkgPT09IG5vZGVOYW1lO1xuICAgICAgICAgICAgfTtcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiQ0xBU1NcIjogZnVuY3Rpb24gQ0xBU1MoY2xhc3NOYW1lKSB7XG4gICAgICAgICAgICB2YXIgcGF0dGVybiA9IGNsYXNzQ2FjaGVbY2xhc3NOYW1lICsgXCIgXCJdO1xuICAgICAgICAgICAgcmV0dXJuIHBhdHRlcm4gfHwgKHBhdHRlcm4gPSBuZXcgUmVnRXhwKFwiKF58XCIgKyB3aGl0ZXNwYWNlICsgXCIpXCIgKyBjbGFzc05hbWUgKyBcIihcIiArIHdoaXRlc3BhY2UgKyBcInwkKVwiKSkgJiYgY2xhc3NDYWNoZShjbGFzc05hbWUsIGZ1bmN0aW9uIChlbGVtKSB7XG4gICAgICAgICAgICAgIHJldHVybiBwYXR0ZXJuLnRlc3QodHlwZW9mIGVsZW0uY2xhc3NOYW1lID09PSBcInN0cmluZ1wiICYmIGVsZW0uY2xhc3NOYW1lIHx8IHR5cGVvZiBlbGVtLmdldEF0dHJpYnV0ZSAhPT0gXCJ1bmRlZmluZWRcIiAmJiBlbGVtLmdldEF0dHJpYnV0ZShcImNsYXNzXCIpIHx8IFwiXCIpO1xuICAgICAgICAgICAgfSk7XG4gICAgICAgICAgfSxcbiAgICAgICAgICBcIkFUVFJcIjogZnVuY3Rpb24gQVRUUihuYW1lLCBvcGVyYXRvciwgY2hlY2spIHtcbiAgICAgICAgICAgIHJldHVybiBmdW5jdGlvbiAoZWxlbSkge1xuICAgICAgICAgICAgICB2YXIgcmVzdWx0ID0gU2l6emxlLmF0dHIoZWxlbSwgbmFtZSk7XG5cbiAgICAgICAgICAgICAgaWYgKHJlc3VsdCA9PSBudWxsKSB7XG4gICAgICAgICAgICAgICAgcmV0dXJuIG9wZXJhdG9yID09PSBcIiE9XCI7XG4gICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICBpZiAoIW9wZXJhdG9yKSB7XG4gICAgICAgICAgICAgICAgcmV0dXJuIHRydWU7XG4gICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICByZXN1bHQgKz0gXCJcIjtcbiAgICAgICAgICAgICAgcmV0dXJuIG9wZXJhdG9yID09PSBcIj1cIiA/IHJlc3VsdCA9PT0gY2hlY2sgOiBvcGVyYXRvciA9PT0gXCIhPVwiID8gcmVzdWx0ICE9PSBjaGVjayA6IG9wZXJhdG9yID09PSBcIl49XCIgPyBjaGVjayAmJiByZXN1bHQuaW5kZXhPZihjaGVjaykgPT09IDAgOiBvcGVyYXRvciA9PT0gXCIqPVwiID8gY2hlY2sgJiYgcmVzdWx0LmluZGV4T2YoY2hlY2spID4gLTEgOiBvcGVyYXRvciA9PT0gXCIkPVwiID8gY2hlY2sgJiYgcmVzdWx0LnNsaWNlKC1jaGVjay5sZW5ndGgpID09PSBjaGVjayA6IG9wZXJhdG9yID09PSBcIn49XCIgPyAoXCIgXCIgKyByZXN1bHQucmVwbGFjZShyd2hpdGVzcGFjZSwgXCIgXCIpICsgXCIgXCIpLmluZGV4T2YoY2hlY2spID4gLTEgOiBvcGVyYXRvciA9PT0gXCJ8PVwiID8gcmVzdWx0ID09PSBjaGVjayB8fCByZXN1bHQuc2xpY2UoMCwgY2hlY2subGVuZ3RoICsgMSkgPT09IGNoZWNrICsgXCItXCIgOiBmYWxzZTtcbiAgICAgICAgICAgIH07XG4gICAgICAgICAgfSxcbiAgICAgICAgICBcIkNISUxEXCI6IGZ1bmN0aW9uIENISUxEKHR5cGUsIHdoYXQsIGFyZ3VtZW50LCBmaXJzdCwgbGFzdCkge1xuICAgICAgICAgICAgdmFyIHNpbXBsZSA9IHR5cGUuc2xpY2UoMCwgMykgIT09IFwibnRoXCIsXG4gICAgICAgICAgICAgICAgZm9yd2FyZCA9IHR5cGUuc2xpY2UoLTQpICE9PSBcImxhc3RcIixcbiAgICAgICAgICAgICAgICBvZlR5cGUgPSB3aGF0ID09PSBcIm9mLXR5cGVcIjtcbiAgICAgICAgICAgIHJldHVybiBmaXJzdCA9PT0gMSAmJiBsYXN0ID09PSAwID8gLy8gU2hvcnRjdXQgZm9yIDpudGgtKihuKVxuICAgICAgICAgICAgZnVuY3Rpb24gKGVsZW0pIHtcbiAgICAgICAgICAgICAgcmV0dXJuICEhZWxlbS5wYXJlbnROb2RlO1xuICAgICAgICAgICAgfSA6IGZ1bmN0aW9uIChlbGVtLCBjb250ZXh0LCB4bWwpIHtcbiAgICAgICAgICAgICAgdmFyIGNhY2hlLFxuICAgICAgICAgICAgICAgICAgdW5pcXVlQ2FjaGUsXG4gICAgICAgICAgICAgICAgICBvdXRlckNhY2hlLFxuICAgICAgICAgICAgICAgICAgbm9kZSxcbiAgICAgICAgICAgICAgICAgIG5vZGVJbmRleCxcbiAgICAgICAgICAgICAgICAgIHN0YXJ0LFxuICAgICAgICAgICAgICAgICAgZGlyID0gc2ltcGxlICE9PSBmb3J3YXJkID8gXCJuZXh0U2libGluZ1wiIDogXCJwcmV2aW91c1NpYmxpbmdcIixcbiAgICAgICAgICAgICAgICAgIHBhcmVudCA9IGVsZW0ucGFyZW50Tm9kZSxcbiAgICAgICAgICAgICAgICAgIG5hbWUgPSBvZlR5cGUgJiYgZWxlbS5ub2RlTmFtZS50b0xvd2VyQ2FzZSgpLFxuICAgICAgICAgICAgICAgICAgdXNlQ2FjaGUgPSAheG1sICYmICFvZlR5cGUsXG4gICAgICAgICAgICAgICAgICBkaWZmID0gZmFsc2U7XG5cbiAgICAgICAgICAgICAgaWYgKHBhcmVudCkge1xuICAgICAgICAgICAgICAgIC8vIDooZmlyc3R8bGFzdHxvbmx5KS0oY2hpbGR8b2YtdHlwZSlcbiAgICAgICAgICAgICAgICBpZiAoc2ltcGxlKSB7XG4gICAgICAgICAgICAgICAgICB3aGlsZSAoZGlyKSB7XG4gICAgICAgICAgICAgICAgICAgIG5vZGUgPSBlbGVtO1xuXG4gICAgICAgICAgICAgICAgICAgIHdoaWxlIChub2RlID0gbm9kZVtkaXJdKSB7XG4gICAgICAgICAgICAgICAgICAgICAgaWYgKG9mVHlwZSA/IG5vZGUubm9kZU5hbWUudG9Mb3dlckNhc2UoKSA9PT0gbmFtZSA6IG5vZGUubm9kZVR5cGUgPT09IDEpIHtcbiAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgIH0gLy8gUmV2ZXJzZSBkaXJlY3Rpb24gZm9yIDpvbmx5LSogKGlmIHdlIGhhdmVuJ3QgeWV0IGRvbmUgc28pXG5cblxuICAgICAgICAgICAgICAgICAgICBzdGFydCA9IGRpciA9IHR5cGUgPT09IFwib25seVwiICYmICFzdGFydCAmJiBcIm5leHRTaWJsaW5nXCI7XG4gICAgICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgICAgIHJldHVybiB0cnVlO1xuICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgIHN0YXJ0ID0gW2ZvcndhcmQgPyBwYXJlbnQuZmlyc3RDaGlsZCA6IHBhcmVudC5sYXN0Q2hpbGRdOyAvLyBub24teG1sIDpudGgtY2hpbGQoLi4uKSBzdG9yZXMgY2FjaGUgZGF0YSBvbiBgcGFyZW50YFxuXG4gICAgICAgICAgICAgICAgaWYgKGZvcndhcmQgJiYgdXNlQ2FjaGUpIHtcbiAgICAgICAgICAgICAgICAgIC8vIFNlZWsgYGVsZW1gIGZyb20gYSBwcmV2aW91c2x5LWNhY2hlZCBpbmRleFxuICAgICAgICAgICAgICAgICAgLy8gLi4uaW4gYSBnemlwLWZyaWVuZGx5IHdheVxuICAgICAgICAgICAgICAgICAgbm9kZSA9IHBhcmVudDtcbiAgICAgICAgICAgICAgICAgIG91dGVyQ2FjaGUgPSBub2RlW2V4cGFuZG9dIHx8IChub2RlW2V4cGFuZG9dID0ge30pOyAvLyBTdXBwb3J0OiBJRSA8OSBvbmx5XG4gICAgICAgICAgICAgICAgICAvLyBEZWZlbmQgYWdhaW5zdCBjbG9uZWQgYXR0cm9wZXJ0aWVzIChqUXVlcnkgZ2gtMTcwOSlcblxuICAgICAgICAgICAgICAgICAgdW5pcXVlQ2FjaGUgPSBvdXRlckNhY2hlW25vZGUudW5pcXVlSURdIHx8IChvdXRlckNhY2hlW25vZGUudW5pcXVlSURdID0ge30pO1xuICAgICAgICAgICAgICAgICAgY2FjaGUgPSB1bmlxdWVDYWNoZVt0eXBlXSB8fCBbXTtcbiAgICAgICAgICAgICAgICAgIG5vZGVJbmRleCA9IGNhY2hlWzBdID09PSBkaXJydW5zICYmIGNhY2hlWzFdO1xuICAgICAgICAgICAgICAgICAgZGlmZiA9IG5vZGVJbmRleCAmJiBjYWNoZVsyXTtcbiAgICAgICAgICAgICAgICAgIG5vZGUgPSBub2RlSW5kZXggJiYgcGFyZW50LmNoaWxkTm9kZXNbbm9kZUluZGV4XTtcblxuICAgICAgICAgICAgICAgICAgd2hpbGUgKG5vZGUgPSArK25vZGVJbmRleCAmJiBub2RlICYmIG5vZGVbZGlyXSB8fCAoIC8vIEZhbGxiYWNrIHRvIHNlZWtpbmcgYGVsZW1gIGZyb20gdGhlIHN0YXJ0XG4gICAgICAgICAgICAgICAgICBkaWZmID0gbm9kZUluZGV4ID0gMCkgfHwgc3RhcnQucG9wKCkpIHtcbiAgICAgICAgICAgICAgICAgICAgLy8gV2hlbiBmb3VuZCwgY2FjaGUgaW5kZXhlcyBvbiBgcGFyZW50YCBhbmQgYnJlYWtcbiAgICAgICAgICAgICAgICAgICAgaWYgKG5vZGUubm9kZVR5cGUgPT09IDEgJiYgKytkaWZmICYmIG5vZGUgPT09IGVsZW0pIHtcbiAgICAgICAgICAgICAgICAgICAgICB1bmlxdWVDYWNoZVt0eXBlXSA9IFtkaXJydW5zLCBub2RlSW5kZXgsIGRpZmZdO1xuICAgICAgICAgICAgICAgICAgICAgIGJyZWFrO1xuICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgICAgIC8vIFVzZSBwcmV2aW91c2x5LWNhY2hlZCBlbGVtZW50IGluZGV4IGlmIGF2YWlsYWJsZVxuICAgICAgICAgICAgICAgICAgaWYgKHVzZUNhY2hlKSB7XG4gICAgICAgICAgICAgICAgICAgIC8vIC4uLmluIGEgZ3ppcC1mcmllbmRseSB3YXlcbiAgICAgICAgICAgICAgICAgICAgbm9kZSA9IGVsZW07XG4gICAgICAgICAgICAgICAgICAgIG91dGVyQ2FjaGUgPSBub2RlW2V4cGFuZG9dIHx8IChub2RlW2V4cGFuZG9dID0ge30pOyAvLyBTdXBwb3J0OiBJRSA8OSBvbmx5XG4gICAgICAgICAgICAgICAgICAgIC8vIERlZmVuZCBhZ2FpbnN0IGNsb25lZCBhdHRyb3BlcnRpZXMgKGpRdWVyeSBnaC0xNzA5KVxuXG4gICAgICAgICAgICAgICAgICAgIHVuaXF1ZUNhY2hlID0gb3V0ZXJDYWNoZVtub2RlLnVuaXF1ZUlEXSB8fCAob3V0ZXJDYWNoZVtub2RlLnVuaXF1ZUlEXSA9IHt9KTtcbiAgICAgICAgICAgICAgICAgICAgY2FjaGUgPSB1bmlxdWVDYWNoZVt0eXBlXSB8fCBbXTtcbiAgICAgICAgICAgICAgICAgICAgbm9kZUluZGV4ID0gY2FjaGVbMF0gPT09IGRpcnJ1bnMgJiYgY2FjaGVbMV07XG4gICAgICAgICAgICAgICAgICAgIGRpZmYgPSBub2RlSW5kZXg7XG4gICAgICAgICAgICAgICAgICB9IC8vIHhtbCA6bnRoLWNoaWxkKC4uLilcbiAgICAgICAgICAgICAgICAgIC8vIG9yIDpudGgtbGFzdC1jaGlsZCguLi4pIG9yIDpudGgoLWxhc3QpPy1vZi10eXBlKC4uLilcblxuXG4gICAgICAgICAgICAgICAgICBpZiAoZGlmZiA9PT0gZmFsc2UpIHtcbiAgICAgICAgICAgICAgICAgICAgLy8gVXNlIHRoZSBzYW1lIGxvb3AgYXMgYWJvdmUgdG8gc2VlayBgZWxlbWAgZnJvbSB0aGUgc3RhcnRcbiAgICAgICAgICAgICAgICAgICAgd2hpbGUgKG5vZGUgPSArK25vZGVJbmRleCAmJiBub2RlICYmIG5vZGVbZGlyXSB8fCAoZGlmZiA9IG5vZGVJbmRleCA9IDApIHx8IHN0YXJ0LnBvcCgpKSB7XG4gICAgICAgICAgICAgICAgICAgICAgaWYgKChvZlR5cGUgPyBub2RlLm5vZGVOYW1lLnRvTG93ZXJDYXNlKCkgPT09IG5hbWUgOiBub2RlLm5vZGVUeXBlID09PSAxKSAmJiArK2RpZmYpIHtcbiAgICAgICAgICAgICAgICAgICAgICAgIC8vIENhY2hlIHRoZSBpbmRleCBvZiBlYWNoIGVuY291bnRlcmVkIGVsZW1lbnRcbiAgICAgICAgICAgICAgICAgICAgICAgIGlmICh1c2VDYWNoZSkge1xuICAgICAgICAgICAgICAgICAgICAgICAgICBvdXRlckNhY2hlID0gbm9kZVtleHBhbmRvXSB8fCAobm9kZVtleHBhbmRvXSA9IHt9KTsgLy8gU3VwcG9ydDogSUUgPDkgb25seVxuICAgICAgICAgICAgICAgICAgICAgICAgICAvLyBEZWZlbmQgYWdhaW5zdCBjbG9uZWQgYXR0cm9wZXJ0aWVzIChqUXVlcnkgZ2gtMTcwOSlcblxuICAgICAgICAgICAgICAgICAgICAgICAgICB1bmlxdWVDYWNoZSA9IG91dGVyQ2FjaGVbbm9kZS51bmlxdWVJRF0gfHwgKG91dGVyQ2FjaGVbbm9kZS51bmlxdWVJRF0gPSB7fSk7XG4gICAgICAgICAgICAgICAgICAgICAgICAgIHVuaXF1ZUNhY2hlW3R5cGVdID0gW2RpcnJ1bnMsIGRpZmZdO1xuICAgICAgICAgICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgICAgICAgICBpZiAobm9kZSA9PT0gZWxlbSkge1xuICAgICAgICAgICAgICAgICAgICAgICAgICBicmVhaztcbiAgICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICB9IC8vIEluY29ycG9yYXRlIHRoZSBvZmZzZXQsIHRoZW4gY2hlY2sgYWdhaW5zdCBjeWNsZSBzaXplXG5cblxuICAgICAgICAgICAgICAgIGRpZmYgLT0gbGFzdDtcbiAgICAgICAgICAgICAgICByZXR1cm4gZGlmZiA9PT0gZmlyc3QgfHwgZGlmZiAlIGZpcnN0ID09PSAwICYmIGRpZmYgLyBmaXJzdCA+PSAwO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9O1xuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJQU0VVRE9cIjogZnVuY3Rpb24gUFNFVURPKHBzZXVkbywgYXJndW1lbnQpIHtcbiAgICAgICAgICAgIC8vIHBzZXVkby1jbGFzcyBuYW1lcyBhcmUgY2FzZS1pbnNlbnNpdGl2ZVxuICAgICAgICAgICAgLy8gaHR0cDovL3d3dy53My5vcmcvVFIvc2VsZWN0b3JzLyNwc2V1ZG8tY2xhc3Nlc1xuICAgICAgICAgICAgLy8gUHJpb3JpdGl6ZSBieSBjYXNlIHNlbnNpdGl2aXR5IGluIGNhc2UgY3VzdG9tIHBzZXVkb3MgYXJlIGFkZGVkIHdpdGggdXBwZXJjYXNlIGxldHRlcnNcbiAgICAgICAgICAgIC8vIFJlbWVtYmVyIHRoYXQgc2V0RmlsdGVycyBpbmhlcml0cyBmcm9tIHBzZXVkb3NcbiAgICAgICAgICAgIHZhciBhcmdzLFxuICAgICAgICAgICAgICAgIGZuID0gRXhwci5wc2V1ZG9zW3BzZXVkb10gfHwgRXhwci5zZXRGaWx0ZXJzW3BzZXVkby50b0xvd2VyQ2FzZSgpXSB8fCBTaXp6bGUuZXJyb3IoXCJ1bnN1cHBvcnRlZCBwc2V1ZG86IFwiICsgcHNldWRvKTsgLy8gVGhlIHVzZXIgbWF5IHVzZSBjcmVhdGVQc2V1ZG8gdG8gaW5kaWNhdGUgdGhhdFxuICAgICAgICAgICAgLy8gYXJndW1lbnRzIGFyZSBuZWVkZWQgdG8gY3JlYXRlIHRoZSBmaWx0ZXIgZnVuY3Rpb25cbiAgICAgICAgICAgIC8vIGp1c3QgYXMgU2l6emxlIGRvZXNcblxuICAgICAgICAgICAgaWYgKGZuW2V4cGFuZG9dKSB7XG4gICAgICAgICAgICAgIHJldHVybiBmbihhcmd1bWVudCk7XG4gICAgICAgICAgICB9IC8vIEJ1dCBtYWludGFpbiBzdXBwb3J0IGZvciBvbGQgc2lnbmF0dXJlc1xuXG5cbiAgICAgICAgICAgIGlmIChmbi5sZW5ndGggPiAxKSB7XG4gICAgICAgICAgICAgIGFyZ3MgPSBbcHNldWRvLCBwc2V1ZG8sIFwiXCIsIGFyZ3VtZW50XTtcbiAgICAgICAgICAgICAgcmV0dXJuIEV4cHIuc2V0RmlsdGVycy5oYXNPd25Qcm9wZXJ0eShwc2V1ZG8udG9Mb3dlckNhc2UoKSkgPyBtYXJrRnVuY3Rpb24oZnVuY3Rpb24gKHNlZWQsIG1hdGNoZXMpIHtcbiAgICAgICAgICAgICAgICB2YXIgaWR4LFxuICAgICAgICAgICAgICAgICAgICBtYXRjaGVkID0gZm4oc2VlZCwgYXJndW1lbnQpLFxuICAgICAgICAgICAgICAgICAgICBpID0gbWF0Y2hlZC5sZW5ndGg7XG5cbiAgICAgICAgICAgICAgICB3aGlsZSAoaS0tKSB7XG4gICAgICAgICAgICAgICAgICBpZHggPSBpbmRleE9mKHNlZWQsIG1hdGNoZWRbaV0pO1xuICAgICAgICAgICAgICAgICAgc2VlZFtpZHhdID0gIShtYXRjaGVzW2lkeF0gPSBtYXRjaGVkW2ldKTtcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgIH0pIDogZnVuY3Rpb24gKGVsZW0pIHtcbiAgICAgICAgICAgICAgICByZXR1cm4gZm4oZWxlbSwgMCwgYXJncyk7XG4gICAgICAgICAgICAgIH07XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIHJldHVybiBmbjtcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIHBzZXVkb3M6IHtcbiAgICAgICAgICAvLyBQb3RlbnRpYWxseSBjb21wbGV4IHBzZXVkb3NcbiAgICAgICAgICBcIm5vdFwiOiBtYXJrRnVuY3Rpb24oZnVuY3Rpb24gKHNlbGVjdG9yKSB7XG4gICAgICAgICAgICAvLyBUcmltIHRoZSBzZWxlY3RvciBwYXNzZWQgdG8gY29tcGlsZVxuICAgICAgICAgICAgLy8gdG8gYXZvaWQgdHJlYXRpbmcgbGVhZGluZyBhbmQgdHJhaWxpbmdcbiAgICAgICAgICAgIC8vIHNwYWNlcyBhcyBjb21iaW5hdG9yc1xuICAgICAgICAgICAgdmFyIGlucHV0ID0gW10sXG4gICAgICAgICAgICAgICAgcmVzdWx0cyA9IFtdLFxuICAgICAgICAgICAgICAgIG1hdGNoZXIgPSBjb21waWxlKHNlbGVjdG9yLnJlcGxhY2UocnRyaW0sIFwiJDFcIikpO1xuICAgICAgICAgICAgcmV0dXJuIG1hdGNoZXJbZXhwYW5kb10gPyBtYXJrRnVuY3Rpb24oZnVuY3Rpb24gKHNlZWQsIG1hdGNoZXMsIGNvbnRleHQsIHhtbCkge1xuICAgICAgICAgICAgICB2YXIgZWxlbSxcbiAgICAgICAgICAgICAgICAgIHVubWF0Y2hlZCA9IG1hdGNoZXIoc2VlZCwgbnVsbCwgeG1sLCBbXSksXG4gICAgICAgICAgICAgICAgICBpID0gc2VlZC5sZW5ndGg7IC8vIE1hdGNoIGVsZW1lbnRzIHVubWF0Y2hlZCBieSBgbWF0Y2hlcmBcblxuICAgICAgICAgICAgICB3aGlsZSAoaS0tKSB7XG4gICAgICAgICAgICAgICAgaWYgKGVsZW0gPSB1bm1hdGNoZWRbaV0pIHtcbiAgICAgICAgICAgICAgICAgIHNlZWRbaV0gPSAhKG1hdGNoZXNbaV0gPSBlbGVtKTtcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH0pIDogZnVuY3Rpb24gKGVsZW0sIGNvbnRleHQsIHhtbCkge1xuICAgICAgICAgICAgICBpbnB1dFswXSA9IGVsZW07XG4gICAgICAgICAgICAgIG1hdGNoZXIoaW5wdXQsIG51bGwsIHhtbCwgcmVzdWx0cyk7IC8vIERvbid0IGtlZXAgdGhlIGVsZW1lbnQgKGlzc3VlICMyOTkpXG5cbiAgICAgICAgICAgICAgaW5wdXRbMF0gPSBudWxsO1xuICAgICAgICAgICAgICByZXR1cm4gIXJlc3VsdHMucG9wKCk7XG4gICAgICAgICAgICB9O1xuICAgICAgICAgIH0pLFxuICAgICAgICAgIFwiaGFzXCI6IG1hcmtGdW5jdGlvbihmdW5jdGlvbiAoc2VsZWN0b3IpIHtcbiAgICAgICAgICAgIGlmICh0eXBlb2Ygc2VsZWN0b3IgPT09IFwic3RyaW5nXCIpIHtcbiAgICAgICAgICAgICAgU2l6emxlLmNvbXBpbGUoc2VsZWN0b3IpO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICByZXR1cm4gZnVuY3Rpb24gKGVsZW0pIHtcbiAgICAgICAgICAgICAgcmV0dXJuIFNpenpsZShzZWxlY3RvciwgZWxlbSkubGVuZ3RoID4gMDtcbiAgICAgICAgICAgIH07XG4gICAgICAgICAgfSksXG4gICAgICAgICAgLy8gUmVtb3ZlZCA6Y29udGFpbnMgcHNldWRvLWNsYXNzIGRlY2xhcmF0aW9uXG4gICAgICAgICAgLy8gXCJXaGV0aGVyIGFuIGVsZW1lbnQgaXMgcmVwcmVzZW50ZWQgYnkgYSA6bGFuZygpIHNlbGVjdG9yXG4gICAgICAgICAgLy8gaXMgYmFzZWQgc29sZWx5IG9uIHRoZSBlbGVtZW50J3MgbGFuZ3VhZ2UgdmFsdWVcbiAgICAgICAgICAvLyBiZWluZyBlcXVhbCB0byB0aGUgaWRlbnRpZmllciBDLFxuICAgICAgICAgIC8vIG9yIGJlZ2lubmluZyB3aXRoIHRoZSBpZGVudGlmaWVyIEMgaW1tZWRpYXRlbHkgZm9sbG93ZWQgYnkgXCItXCIuXG4gICAgICAgICAgLy8gVGhlIG1hdGNoaW5nIG9mIEMgYWdhaW5zdCB0aGUgZWxlbWVudCdzIGxhbmd1YWdlIHZhbHVlIGlzIHBlcmZvcm1lZCBjYXNlLWluc2Vuc2l0aXZlbHkuXG4gICAgICAgICAgLy8gVGhlIGlkZW50aWZpZXIgQyBkb2VzIG5vdCBoYXZlIHRvIGJlIGEgdmFsaWQgbGFuZ3VhZ2UgbmFtZS5cIlxuICAgICAgICAgIC8vIGh0dHA6Ly93d3cudzMub3JnL1RSL3NlbGVjdG9ycy8jbGFuZy1wc2V1ZG9cbiAgICAgICAgICBcImxhbmdcIjogbWFya0Z1bmN0aW9uKGZ1bmN0aW9uIChsYW5nKSB7XG4gICAgICAgICAgICAvLyBsYW5nIHZhbHVlIG11c3QgYmUgYSB2YWxpZCBpZGVudGlmaWVyXG4gICAgICAgICAgICBpZiAoIXJpZGVudGlmaWVyLnRlc3QobGFuZyB8fCBcIlwiKSkge1xuICAgICAgICAgICAgICBTaXp6bGUuZXJyb3IoXCJ1bnN1cHBvcnRlZCBsYW5nOiBcIiArIGxhbmcpO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICBsYW5nID0gbGFuZy5yZXBsYWNlKHJ1bmVzY2FwZSwgZnVuZXNjYXBlKS50b0xvd2VyQ2FzZSgpO1xuICAgICAgICAgICAgcmV0dXJuIGZ1bmN0aW9uIChlbGVtKSB7XG4gICAgICAgICAgICAgIHZhciBlbGVtTGFuZztcblxuICAgICAgICAgICAgICBkbyB7XG4gICAgICAgICAgICAgICAgaWYgKGVsZW1MYW5nID0gZG9jdW1lbnRJc0hUTUwgPyBlbGVtLmxhbmcgOiBlbGVtLmdldEF0dHJpYnV0ZShcInhtbDpsYW5nXCIpIHx8IGVsZW0uZ2V0QXR0cmlidXRlKFwibGFuZ1wiKSkge1xuICAgICAgICAgICAgICAgICAgZWxlbUxhbmcgPSBlbGVtTGFuZy50b0xvd2VyQ2FzZSgpO1xuICAgICAgICAgICAgICAgICAgcmV0dXJuIGVsZW1MYW5nID09PSBsYW5nIHx8IGVsZW1MYW5nLmluZGV4T2YobGFuZyArIFwiLVwiKSA9PT0gMDtcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgIH0gd2hpbGUgKChlbGVtID0gZWxlbS5wYXJlbnROb2RlKSAmJiBlbGVtLm5vZGVUeXBlID09PSAxKTtcblxuICAgICAgICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICAgICAgICB9O1xuICAgICAgICAgIH0pLFxuICAgICAgICAgIC8vIE1pc2NlbGxhbmVvdXNcbiAgICAgICAgICBcInRhcmdldFwiOiBmdW5jdGlvbiB0YXJnZXQoZWxlbSkge1xuICAgICAgICAgICAgdmFyIGhhc2ggPSB3aW5kb3cubG9jYXRpb24gJiYgd2luZG93LmxvY2F0aW9uLmhhc2g7XG4gICAgICAgICAgICByZXR1cm4gaGFzaCAmJiBoYXNoLnNsaWNlKDEpID09PSBlbGVtLmlkO1xuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyb290XCI6IGZ1bmN0aW9uIHJvb3QoZWxlbSkge1xuICAgICAgICAgICAgcmV0dXJuIGVsZW0gPT09IGRvY0VsZW07XG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImZvY3VzXCI6IGZ1bmN0aW9uIGZvY3VzKGVsZW0pIHtcbiAgICAgICAgICAgIHJldHVybiBlbGVtID09PSBkb2N1bWVudC5hY3RpdmVFbGVtZW50ICYmICghZG9jdW1lbnQuaGFzRm9jdXMgfHwgZG9jdW1lbnQuaGFzRm9jdXMoKSkgJiYgISEoZWxlbS50eXBlIHx8IGVsZW0uaHJlZiB8fCB+ZWxlbS50YWJJbmRleCk7XG4gICAgICAgICAgfSxcbiAgICAgICAgICAvLyBCb29sZWFuIHByb3BlcnRpZXNcbiAgICAgICAgICBcImVuYWJsZWRcIjogY3JlYXRlRGlzYWJsZWRQc2V1ZG8oZmFsc2UpLFxuICAgICAgICAgIFwiZGlzYWJsZWRcIjogY3JlYXRlRGlzYWJsZWRQc2V1ZG8odHJ1ZSksXG4gICAgICAgICAgXCJjaGVja2VkXCI6IGZ1bmN0aW9uIGNoZWNrZWQoZWxlbSkge1xuICAgICAgICAgICAgLy8gSW4gQ1NTMywgOmNoZWNrZWQgc2hvdWxkIHJldHVybiBib3RoIGNoZWNrZWQgYW5kIHNlbGVjdGVkIGVsZW1lbnRzXG4gICAgICAgICAgICAvLyBodHRwOi8vd3d3LnczLm9yZy9UUi8yMDExL1JFQy1jc3MzLXNlbGVjdG9ycy0yMDExMDkyOS8jY2hlY2tlZFxuICAgICAgICAgICAgdmFyIG5vZGVOYW1lID0gZWxlbS5ub2RlTmFtZS50b0xvd2VyQ2FzZSgpO1xuICAgICAgICAgICAgcmV0dXJuIG5vZGVOYW1lID09PSBcImlucHV0XCIgJiYgISFlbGVtLmNoZWNrZWQgfHwgbm9kZU5hbWUgPT09IFwib3B0aW9uXCIgJiYgISFlbGVtLnNlbGVjdGVkO1xuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZWxlY3RlZFwiOiBmdW5jdGlvbiBzZWxlY3RlZChlbGVtKSB7XG4gICAgICAgICAgICAvLyBBY2Nlc3NpbmcgdGhpcyBwcm9wZXJ0eSBtYWtlcyBzZWxlY3RlZC1ieS1kZWZhdWx0XG4gICAgICAgICAgICAvLyBvcHRpb25zIGluIFNhZmFyaSB3b3JrIHByb3Blcmx5XG4gICAgICAgICAgICBpZiAoZWxlbS5wYXJlbnROb2RlKSB7XG4gICAgICAgICAgICAgIGVsZW0ucGFyZW50Tm9kZS5zZWxlY3RlZEluZGV4O1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICByZXR1cm4gZWxlbS5zZWxlY3RlZCA9PT0gdHJ1ZTtcbiAgICAgICAgICB9LFxuICAgICAgICAgIC8vIENvbnRlbnRzXG4gICAgICAgICAgXCJlbXB0eVwiOiBmdW5jdGlvbiBlbXB0eShlbGVtKSB7XG4gICAgICAgICAgICAvLyBodHRwOi8vd3d3LnczLm9yZy9UUi9zZWxlY3RvcnMvI2VtcHR5LXBzZXVkb1xuICAgICAgICAgICAgLy8gOmVtcHR5IGlzIG5lZ2F0ZWQgYnkgZWxlbWVudCAoMSkgb3IgY29udGVudCBub2RlcyAodGV4dDogMzsgY2RhdGE6IDQ7IGVudGl0eSByZWY6IDUpLFxuICAgICAgICAgICAgLy8gICBidXQgbm90IGJ5IG90aGVycyAoY29tbWVudDogODsgcHJvY2Vzc2luZyBpbnN0cnVjdGlvbjogNzsgZXRjLilcbiAgICAgICAgICAgIC8vIG5vZGVUeXBlIDwgNiB3b3JrcyBiZWNhdXNlIGF0dHJpYnV0ZXMgKDIpIGRvIG5vdCBhcHBlYXIgYXMgY2hpbGRyZW5cbiAgICAgICAgICAgIGZvciAoZWxlbSA9IGVsZW0uZmlyc3RDaGlsZDsgZWxlbTsgZWxlbSA9IGVsZW0ubmV4dFNpYmxpbmcpIHtcbiAgICAgICAgICAgICAgaWYgKGVsZW0ubm9kZVR5cGUgPCA2KSB7XG4gICAgICAgICAgICAgICAgcmV0dXJuIGZhbHNlO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIHJldHVybiB0cnVlO1xuICAgICAgICAgIH0gLy8gUmVtb3ZlZCBjdXN0b20gcHNldWRvLWNsYXNzZXNcblxuICAgICAgICB9XG4gICAgICB9OyAvLyBSZW1vdmVkIGN1c3RvbSBwc2V1ZG8tY2xhc3Nlc1xuICAgICAgLy8gRWFzeSBBUEkgZm9yIGNyZWF0aW5nIG5ldyBzZXRGaWx0ZXJzXG5cbiAgICAgIGZ1bmN0aW9uIHNldEZpbHRlcnMoKSB7fVxuXG4gICAgICBzZXRGaWx0ZXJzLnByb3RvdHlwZSA9IEV4cHIuZmlsdGVycyA9IEV4cHIucHNldWRvcztcbiAgICAgIEV4cHIuc2V0RmlsdGVycyA9IG5ldyBzZXRGaWx0ZXJzKCk7XG4gICAgICAvKipcbiAgICAgICAqIFtBZEd1YXJkIFBhdGNoXTpcbiAgICAgICAqIFNvcnRzIHRoZSB0b2tlbnMgaW4gb3JkZXIgdG8gbWl0aWdhdGUgdGhlIHBlcmZvcm1hbmNlIGlzc3VlcyBjYXVzZWQgYnkgbWF0Y2hpbmcgc2xvdyBwc2V1ZG9zIGZpcnN0OlxuICAgICAgICogaHR0cHM6Ly9naXRodWIuY29tL0FkZ3VhcmRUZWFtL0V4dGVuZGVkQ3NzL2lzc3Vlcy81NSNpc3N1ZWNvbW1lbnQtMzY0MDU4NzQ1XG4gICAgICAgKi9cblxuICAgICAgdmFyIHNvcnRUb2tlbkdyb3VwcyA9IGZ1bmN0aW9uICgpIHtcbiAgICAgICAgLyoqXG4gICAgICAgICAqIFNwbGl0cyBjb21wb3VuZCBzZWxlY3RvciBpbnRvIGEgbGlzdCBvZiBzaW1wbGUgc2VsZWN0b3JzXG4gICAgICAgICAqXG4gICAgICAgICAqIEBwYXJhbSB7Kn0gdG9rZW5zIFRva2VucyB0byBzcGxpdCBpbnRvIGdyb3Vwc1xuICAgICAgICAgKiBAcmV0dXJucyBhbiBhcnJheSBjb25zaXN0aW5nIG9mIHRva2VuIGdyb3VwcyAoYXJyYXlzKSBhbmQgcmVsYXRpb24gdG9rZW5zLlxuICAgICAgICAgKi9cbiAgICAgICAgdmFyIHNwbGl0Q29tcG91bmRTZWxlY3RvciA9IGZ1bmN0aW9uIHNwbGl0Q29tcG91bmRTZWxlY3Rvcih0b2tlbnMpIHtcbiAgICAgICAgICB2YXIgZ3JvdXBzID0gW107XG4gICAgICAgICAgdmFyIGN1cnJlbnRUb2tlbnNHcm91cCA9IFtdO1xuICAgICAgICAgIHZhciBtYXhJZHggPSB0b2tlbnMubGVuZ3RoIC0gMTtcblxuICAgICAgICAgIGZvciAodmFyIGkgPSAwOyBpIDw9IG1heElkeDsgaSsrKSB7XG4gICAgICAgICAgICB2YXIgdG9rZW4gPSB0b2tlbnNbaV07XG4gICAgICAgICAgICB2YXIgcmVsYXRpdmUgPSBTaXp6bGUuc2VsZWN0b3JzLnJlbGF0aXZlW3Rva2VuLnR5cGVdO1xuXG4gICAgICAgICAgICBpZiAocmVsYXRpdmUpIHtcbiAgICAgICAgICAgICAgZ3JvdXBzLnB1c2goY3VycmVudFRva2Vuc0dyb3VwKTtcbiAgICAgICAgICAgICAgZ3JvdXBzLnB1c2godG9rZW4pO1xuICAgICAgICAgICAgICBjdXJyZW50VG9rZW5zR3JvdXAgPSBbXTtcbiAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgIGN1cnJlbnRUb2tlbnNHcm91cC5wdXNoKHRva2VuKTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgaWYgKGkgPT09IG1heElkeCkge1xuICAgICAgICAgICAgICBncm91cHMucHVzaChjdXJyZW50VG9rZW5zR3JvdXApO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cblxuICAgICAgICAgIHJldHVybiBncm91cHM7XG4gICAgICAgIH07XG5cbiAgICAgICAgdmFyIFRPS0VOX1RZUEVTX1ZBTFVFUyA9IHtcbiAgICAgICAgICAvLyBudGgtY2hpbGQsIGV0YywgYWx3YXlzIGdvIGxhc3RcbiAgICAgICAgICBcIkNISUxEXCI6IDEwMCxcbiAgICAgICAgICBcIklEXCI6IDkwLFxuICAgICAgICAgIFwiQ0xBU1NcIjogODAsXG4gICAgICAgICAgXCJUQUdcIjogNzAsXG4gICAgICAgICAgXCJBVFRSXCI6IDcwLFxuICAgICAgICAgIFwiUFNFVURPXCI6IDYwXG4gICAgICAgIH07XG4gICAgICAgIHZhciBQT1NJVElPTkFMX1BTRVVET1MgPSBbXCJudGhcIiwgXCJmaXJzdFwiLCBcImxhc3RcIiwgXCJlcVwiLCBcImV2ZW5cIiwgXCJvZGRcIiwgXCJsdFwiLCBcImd0XCIsIFwibm90XCJdO1xuICAgICAgICAvKipcbiAgICAgICAgICogQSBmdW5jdGlvbiB0aGF0IGRlZmluZXMgdGhlIHNvcnQgb3JkZXIuXG4gICAgICAgICAqIFJldHVybnMgYSB2YWx1ZSBsZXNzZXIgdGhhbiAwIGlmIFwibGVmdFwiIGlzIGxlc3MgdGhhbiBcInJpZ2h0XCIuXG4gICAgICAgICAqL1xuXG4gICAgICAgIHZhciBjb21wYXJlRnVuY3Rpb24gPSBmdW5jdGlvbiBjb21wYXJlRnVuY3Rpb24obGVmdCwgcmlnaHQpIHtcbiAgICAgICAgICB2YXIgbGVmdFZhbHVlID0gVE9LRU5fVFlQRVNfVkFMVUVTW2xlZnQudHlwZV07XG4gICAgICAgICAgdmFyIHJpZ2h0VmFsdWUgPSBUT0tFTl9UWVBFU19WQUxVRVNbcmlnaHQudHlwZV07XG4gICAgICAgICAgcmV0dXJuIGxlZnRWYWx1ZSAtIHJpZ2h0VmFsdWU7XG4gICAgICAgIH07XG4gICAgICAgIC8qKlxuICAgICAgICAgKiBDaGVja3MgaWYgdGhlIHNwZWNpZmllZCB0b2tlbnMgZ3JvdXAgaXMgc29ydGFibGUuXG4gICAgICAgICAqIFdlIGRvIG5vdCByZS1zb3J0IHRva2VucyBpbiBjYXNlIG9mIGFueSBwb3NpdGlvbmFsIG9yIGNoaWxkIHBzZXVkb3MgaW4gdGhlIGdyb3VwXG4gICAgICAgICAqL1xuXG5cbiAgICAgICAgdmFyIGlzU29ydGFibGUgPSBmdW5jdGlvbiBpc1NvcnRhYmxlKHRva2Vucykge1xuICAgICAgICAgIHZhciBpVG9rZW5zID0gdG9rZW5zLmxlbmd0aDtcblxuICAgICAgICAgIHdoaWxlIChpVG9rZW5zLS0pIHtcbiAgICAgICAgICAgIHZhciB0b2tlbiA9IHRva2Vuc1tpVG9rZW5zXTtcblxuICAgICAgICAgICAgaWYgKHRva2VuLnR5cGUgPT09IFwiUFNFVURPXCIgJiYgUE9TSVRJT05BTF9QU0VVRE9TLmluZGV4T2YodG9rZW4ubWF0Y2hlc1swXSkgIT09IC0xKSB7XG4gICAgICAgICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgaWYgKHRva2VuLnR5cGUgPT09IFwiQ0hJTERcIikge1xuICAgICAgICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgcmV0dXJuIHRydWU7XG4gICAgICAgIH07XG4gICAgICAgIC8qKlxuICAgICAgICAgKiBTb3J0cyB0aGUgdG9rZW5zIGluIG9yZGVyIHRvIG1pdGlnYXRlIHRoZSBpc3N1ZXMgY2F1c2VkIGJ5IHRoZSBsZWZ0LXRvLXJpZ2h0IG1hdGNoaW5nLlxuICAgICAgICAgKiBUaGUgaWRlYSBpcyBjaGFuZ2UgdGhlIHRva2VucyBvcmRlciBzbyB0aGF0IFNpenpsZSB3YXMgbWF0Y2hpbmcgZmFzdCBzZWxlY3RvcnMgZmlyc3QgKGlkLCBjbGFzcyksXG4gICAgICAgICAqIGFuZCBzbG93IHNlbGVjdG9ycyBhZnRlciB0aGF0IChhbmQgaGVyZSBJIG1lYW4gb3VyIHNsb3cgY3VzdG9tIHBzZXVkbyBjbGFzc2VzKS5cbiAgICAgICAgICpcbiAgICAgICAgICogQHBhcmFtIHtBcnJheX0gdG9rZW5zIEFuIGFycmF5IG9mIHRva2VucyB0byBzb3J0XG4gICAgICAgICAqIEByZXR1cm5zIHtBcnJheX0gQSBuZXcgcmUtc29ydGVkIGFycmF5XG4gICAgICAgICAqL1xuXG5cbiAgICAgICAgdmFyIHNvcnRUb2tlbnMgPSBmdW5jdGlvbiBzb3J0VG9rZW5zKHRva2Vucykge1xuICAgICAgICAgIGlmICghdG9rZW5zIHx8IHRva2Vucy5sZW5ndGggPT09IDEpIHtcbiAgICAgICAgICAgIHJldHVybiB0b2tlbnM7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgdmFyIHNvcnRlZFRva2VucyA9IFtdO1xuICAgICAgICAgIHZhciBncm91cHMgPSBzcGxpdENvbXBvdW5kU2VsZWN0b3IodG9rZW5zKTtcblxuICAgICAgICAgIGZvciAodmFyIGkgPSAwOyBpIDwgZ3JvdXBzLmxlbmd0aDsgaSsrKSB7XG4gICAgICAgICAgICB2YXIgZ3JvdXAgPSBncm91cHNbaV07XG5cbiAgICAgICAgICAgIGlmIChncm91cCBpbnN0YW5jZW9mIEFycmF5KSB7XG4gICAgICAgICAgICAgIGlmIChpc1NvcnRhYmxlKGdyb3VwKSkge1xuICAgICAgICAgICAgICAgIGdyb3VwLnNvcnQoY29tcGFyZUZ1bmN0aW9uKTtcbiAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgIHNvcnRlZFRva2VucyA9IHNvcnRlZFRva2Vucy5jb25jYXQoZ3JvdXApO1xuICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgc29ydGVkVG9rZW5zLnB1c2goZ3JvdXApO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cblxuICAgICAgICAgIHJldHVybiBzb3J0ZWRUb2tlbnM7XG4gICAgICAgIH07XG4gICAgICAgIC8qKlxuICAgICAgICAgKiBTb3J0cyBldmVyeSB0b2tlbnMgYXJyYXkgaW5zaWRlIG9mIHRoZSBzcGVjaWZpZWQgXCJncm91cHNcIiBhcnJheS5cbiAgICAgICAgICogU2VlIFwic29ydFRva2Vuc1wiIG1ldGhvZHMgZm9yIG1vcmUgaW5mb3JtYXRpb24gb24gaG93IHRva2VucyBhcmUgc29ydGVkLlxuICAgICAgICAgKlxuICAgICAgICAgKiBAcGFyYW0ge0FycmF5fSBncm91cHMgQW4gYXJyYXkgb2YgdG9rZW5zIGFycmF5cy5cbiAgICAgICAgICogQHJldHVybnMge0FycmF5fSBBIG5ldyBhcnJheSB0aGF0IGNvbnNpc3RzIG9mIHRoZSBzYW1lIHRva2VucyBhcnJheXMgYWZ0ZXIgc29ydGluZ1xuICAgICAgICAgKi9cblxuXG4gICAgICAgIHZhciBzb3J0VG9rZW5Hcm91cHMgPSBmdW5jdGlvbiBzb3J0VG9rZW5Hcm91cHMoZ3JvdXBzKSB7XG4gICAgICAgICAgdmFyIHNvcnRlZEdyb3VwcyA9IFtdO1xuICAgICAgICAgIHZhciBsZW4gPSBncm91cHMubGVuZ3RoO1xuICAgICAgICAgIHZhciBpID0gMDtcblxuICAgICAgICAgIGZvciAoOyBpIDwgbGVuOyBpKyspIHtcbiAgICAgICAgICAgIHNvcnRlZEdyb3Vwcy5wdXNoKHNvcnRUb2tlbnMoZ3JvdXBzW2ldKSk7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgcmV0dXJuIHNvcnRlZEdyb3VwcztcbiAgICAgICAgfTsgLy8gRXhwb3NlXG5cblxuICAgICAgICByZXR1cm4gc29ydFRva2VuR3JvdXBzO1xuICAgICAgfSgpO1xuICAgICAgLyoqXG4gICAgICAgKiBDcmVhdGVzIGN1c3RvbSBwb2xpY3kgdG8gdXNlIFRydXN0ZWRUeXBlcyBDU1AgcG9saWN5XG4gICAgICAgKiBodHRwczovL3czYy5naXRodWIuaW8vd2ViYXBwc2VjLXRydXN0ZWQtdHlwZXMvZGlzdC9zcGVjL1xuICAgICAgICovXG5cblxuICAgICAgdmFyIEFHUG9saWN5ID0gZnVuY3Rpb24gY3JlYXRlUG9saWN5KCkge1xuICAgICAgICB2YXIgZGVmYXVsdFBvbGljeSA9IHtcbiAgICAgICAgICBjcmVhdGVIVE1MOiBmdW5jdGlvbiBjcmVhdGVIVE1MKGlucHV0KSB7XG4gICAgICAgICAgICByZXR1cm4gaW5wdXQ7XG4gICAgICAgICAgfSxcbiAgICAgICAgICBjcmVhdGVTY3JpcHQ6IGZ1bmN0aW9uIGNyZWF0ZVNjcmlwdChpbnB1dCkge1xuICAgICAgICAgICAgcmV0dXJuIGlucHV0O1xuICAgICAgICAgIH0sXG4gICAgICAgICAgY3JlYXRlU2NyaXB0VVJMOiBmdW5jdGlvbiBjcmVhdGVTY3JpcHRVUkwoaW5wdXQpIHtcbiAgICAgICAgICAgIHJldHVybiBpbnB1dDtcbiAgICAgICAgICB9XG4gICAgICAgIH07XG5cbiAgICAgICAgaWYgKHdpbmRvdy50cnVzdGVkVHlwZXMgJiYgd2luZG93LnRydXN0ZWRUeXBlcy5jcmVhdGVQb2xpY3kpIHtcbiAgICAgICAgICByZXR1cm4gd2luZG93LnRydXN0ZWRUeXBlcy5jcmVhdGVQb2xpY3koXCJBR1BvbGljeVwiLCBkZWZhdWx0UG9saWN5KTtcbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiBkZWZhdWx0UG9saWN5O1xuICAgICAgfSgpO1xuICAgICAgLyoqXG4gICAgICAgKiBbQWRHdWFyZCBQYXRjaF06XG4gICAgICAgKiBSZW1vdmVzIHRyYWlsaW5nIHNwYWNlcyBmcm9tIHRoZSB0b2tlbnMgbGlzdFxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSB7Kn0gdG9rZW5zIEFuIGFycmF5IG9mIFNpenpsZSB0b2tlbnMgdG8gcG9zdC1wcm9jZXNzXG4gICAgICAgKi9cblxuXG4gICAgICBmdW5jdGlvbiByZW1vdmVUcmFpbGluZ1NwYWNlcyh0b2tlbnMpIHtcbiAgICAgICAgdmFyIGlUb2tlbnMgPSB0b2tlbnMubGVuZ3RoO1xuXG4gICAgICAgIHdoaWxlIChpVG9rZW5zLS0pIHtcbiAgICAgICAgICB2YXIgdG9rZW4gPSB0b2tlbnNbaVRva2Vuc107XG5cbiAgICAgICAgICBpZiAodG9rZW4udHlwZSA9PT0gXCIgXCIpIHtcbiAgICAgICAgICAgIHRva2Vucy5sZW5ndGggPSBpVG9rZW5zO1xuICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICBicmVhaztcbiAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICAgIC8qKlxuICAgICAgICogW0FkR3VhcmQgUGF0Y2hdOlxuICAgICAgICogQW4gb2JqZWN0IHdpdGggdGhlIGluZm9ybWF0aW9uIGFib3V0IHNlbGVjdG9ycyBhbmQgdGhlaXIgdG9rZW4gcmVwcmVzZW50YXRpb25cbiAgICAgICAqIEB0eXBlZGVmIHt7c2VsZWN0b3JUZXh0OiBzdHJpbmcsIGdyb3VwczogQXJyYXl9fSBTZWxlY3RvckRhdGFcbiAgICAgICAqIEBwcm9wZXJ0eSB7c3RyaW5nfSBzZWxlY3RvclRleHQgQSBDU1Mgc2VsZWN0b3IgdGV4dFxuICAgICAgICogQHByb3BlcnR5IHtBcnJheX0gZ3JvdXBzIEFuIGFycmF5IG9mIHRva2VuIGdyb3VwcyBjb3JyZXNwb25kaW5nIHRvIHRoYXQgc2VsZWN0b3JcbiAgICAgICAqL1xuXG4gICAgICAvKipcbiAgICAgICAqIFtBZEd1YXJkIFBhdGNoXTpcbiAgICAgICAqIFRoaXMgbWV0aG9kIHByb2Nlc3NlcyBwYXJzZWQgdG9rZW4gZ3JvdXBzLCBkaXZpZGVzIHRoZW0gaW50byBhIG51bWJlciBvZiBzZWxlY3RvcnNcbiAgICAgICAqIGFuZCBtYWtlcyBzdXJlIHRoYXQgZWFjaCBzZWxlY3RvcidzIHRva2VucyBhcmUgY2FjaGVkIHByb3Blcmx5IGluIFNpenpsZS5cbiAgICAgICAqXG4gICAgICAgKiBAcGFyYW0geyp9IGdyb3VwcyBUb2tlbiBncm91cHMgKHNlZSB7QGxpbmsgU2l6emxlLnRva2VuaXplfSlcbiAgICAgICAqIEByZXR1cm5zIHtBcnJheS48U2VsZWN0b3JEYXRhPn0gQW4gYXJyYXkgb2Ygc2VsZWN0b3JzIGRhdGEgd2UgZ290IGZyb20gdGhlIGdyb3Vwc1xuICAgICAgICovXG5cblxuICAgICAgZnVuY3Rpb24gdG9rZW5Hcm91cHNUb1NlbGVjdG9ycyhncm91cHMpIHtcbiAgICAgICAgLy8gUmVtb3ZlIHRyYWlsaW5nIHNwYWNlcyB3aGljaCB3ZSBjYW4gZW5jb3VudGVyIGluIHRvbGVyYW50IG1vZGVcbiAgICAgICAgLy8gV2UncmUgZG9pbmcgaXQgaW4gdG9sZXJhbnQgbW9kZSBvbmx5IGFzIHRoaXMgaXMgdGhlIG9ubHkgY2FzZSB3aGVuXG4gICAgICAgIC8vIGVuY291bnRlcmluZyB0cmFpbGluZyBzcGFjZXMgaXMgZXhwZWN0ZWRcbiAgICAgICAgcmVtb3ZlVHJhaWxpbmdTcGFjZXMoZ3JvdXBzW2dyb3Vwcy5sZW5ndGggLSAxXSk7IC8vIFdlIG5lZWQgc29ydGVkIHRva2VucyB0byBtYWtlIGNhY2hlIHdvcmsgcHJvcGVybHlcblxuICAgICAgICB2YXIgc29ydGVkR3JvdXBzID0gc29ydFRva2VuR3JvdXBzKGdyb3Vwcyk7XG4gICAgICAgIHZhciBzZWxlY3RvcnMgPSBbXTtcblxuICAgICAgICBmb3IgKHZhciBpID0gMDsgaSA8IGdyb3Vwcy5sZW5ndGg7IGkrKykge1xuICAgICAgICAgIHZhciB0b2tlbkdyb3VwcyA9IGdyb3Vwc1tpXTtcbiAgICAgICAgICB2YXIgc2VsZWN0b3JUZXh0ID0gdG9TZWxlY3Rvcih0b2tlbkdyb3Vwcyk7XG4gICAgICAgICAgc2VsZWN0b3JzLnB1c2goe1xuICAgICAgICAgICAgLy8gU2l6emxlIGV4cGVjdHMgYW4gYXJyYXkgb2YgdG9rZW4gZ3JvdXBzIHdoZW4gY29tcGlsaW5nIGEgc2VsZWN0b3JcbiAgICAgICAgICAgIGdyb3VwczogW3Rva2VuR3JvdXBzXSxcbiAgICAgICAgICAgIHNlbGVjdG9yVGV4dDogc2VsZWN0b3JUZXh0XG4gICAgICAgICAgfSk7IC8vIE5vdyBtYWtlIHN1cmUgdGhhdCBzZWxlY3RvciB0b2tlbnMgYXJlIGNhY2hlZFxuXG4gICAgICAgICAgdmFyIHRva2Vuc0NhY2hlSXRlbSA9IHtcbiAgICAgICAgICAgIGdyb3VwczogdG9rZW5Hcm91cHMsXG4gICAgICAgICAgICBzb3J0ZWRHcm91cHM6IFtzb3J0ZWRHcm91cHNbaV1dXG4gICAgICAgICAgfTtcbiAgICAgICAgICB0b2tlbkNhY2hlKHNlbGVjdG9yVGV4dCwgdG9rZW5zQ2FjaGVJdGVtKTtcbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiBzZWxlY3RvcnM7XG4gICAgICB9XG4gICAgICAvKipcbiAgICAgICAqIFtBZEd1YXJkIFBhdGNoXTpcbiAgICAgICAqIEFkZCBhbiBhZGRpdGlvbmFsIGFyZ3VtZW50IGZvciBTaXp6bGUudG9rZW5pemUgd2hpY2ggaW5kaWNhdGVzIHRoYXQgaXRcbiAgICAgICAqIHNob3VsZCBub3QgdGhyb3cgb24gaW52YWxpZCB0b2tlbnMsIGFuZCBpbnN0ZWFkIHNob3VsZCByZXR1cm4gdG9rZW5zXG4gICAgICAgKiB0aGF0IGl0IGhhcyBwcm9kdWNlZCBzbyBmYXIuXG4gICAgICAgKlxuICAgICAgICogT25lIG1vcmUgYWRkaXRpb25hbCBhcmd1bWVudCB0aGF0IGFsbG93IHRvIGNob29zZSBpZiB5b3Ugd2FudCB0byByZWNlaXZlIHNvcnRlZCBvciB1bnNvcnRlZCB0b2tlbnNcbiAgICAgICAqIFRoZSBwcm9ibGVtIGlzIHRoYXQgdGhlIHJlLXNvcnRlZCBzZWxlY3RvcnMgYXJlIHZhbGlkIGZvciBTaXp6bGUsIGJ1dCBub3QgZm9yIHRoZSBicm93c2VyLlxuICAgICAgICogb3B0aW9ucy5yZXR1cm5VbnNvcnRlZCAtLSByZXR1cm4gdW5zb3J0ZWQgdG9rZW5zIGlmIHRydWUuXG4gICAgICAgKiBvcHRpb25zLmNhY2hlT25seSAtLSByZXR1cm4gY2FjaGVkIHJlc3VsdCBvbmx5LiBSZXF1aXJlZCBmb3IgdW5pdC10ZXN0cy5cbiAgICAgICAqXG4gICAgICAgKiBAcGFyYW0geyp9IG9wdGlvbnMgT3B0aW9uYWwgY29uZmlndXJhdGlvbiBvYmplY3Qgd2l0aCB0d28gYWRkaXRpb25hbCBmbGFnc1xuICAgICAgICogKG9wdGlvbnMudG9sZXJhbnQsIG9wdGlvbnMucmV0dXJuVW5zb3J0ZWQsIG9wdGlvbnMuY2FjaGVPbmx5KSAtLSBzZWUgcGF0Y2hlcyAjNSBhbmQgIzYgbm90ZXNcbiAgICAgICAqL1xuXG5cbiAgICAgIHRva2VuaXplID0gU2l6emxlLnRva2VuaXplID0gZnVuY3Rpb24gKHNlbGVjdG9yLCBwYXJzZU9ubHksIG9wdGlvbnMpIHtcbiAgICAgICAgdmFyIG1hdGNoZWQsXG4gICAgICAgICAgICBtYXRjaCxcbiAgICAgICAgICAgIHRva2VucyxcbiAgICAgICAgICAgIHR5cGUsXG4gICAgICAgICAgICBzb0ZhcixcbiAgICAgICAgICAgIGdyb3VwcyxcbiAgICAgICAgICAgIHByZUZpbHRlcnMsXG4gICAgICAgICAgICBjYWNoZWQgPSB0b2tlbkNhY2hlW3NlbGVjdG9yICsgXCIgXCJdO1xuICAgICAgICB2YXIgdG9sZXJhbnQgPSBvcHRpb25zICYmIG9wdGlvbnMudG9sZXJhbnQ7XG4gICAgICAgIHZhciByZXR1cm5VbnNvcnRlZCA9IG9wdGlvbnMgJiYgb3B0aW9ucy5yZXR1cm5VbnNvcnRlZDtcbiAgICAgICAgdmFyIGNhY2hlT25seSA9IG9wdGlvbnMgJiYgb3B0aW9ucy5jYWNoZU9ubHk7XG5cbiAgICAgICAgaWYgKGNhY2hlZCkge1xuICAgICAgICAgIGlmIChwYXJzZU9ubHkpIHtcbiAgICAgICAgICAgIHJldHVybiAwO1xuICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICByZXR1cm4gKHJldHVyblVuc29ydGVkID8gY2FjaGVkLmdyb3VwcyA6IGNhY2hlZC5zb3J0ZWRHcm91cHMpLnNsaWNlKDApO1xuICAgICAgICAgIH1cbiAgICAgICAgfVxuXG4gICAgICAgIGlmIChjYWNoZU9ubHkpIHtcbiAgICAgICAgICByZXR1cm4gbnVsbDtcbiAgICAgICAgfVxuXG4gICAgICAgIHNvRmFyID0gc2VsZWN0b3I7XG4gICAgICAgIGdyb3VwcyA9IFtdO1xuICAgICAgICBwcmVGaWx0ZXJzID0gRXhwci5wcmVGaWx0ZXI7XG5cbiAgICAgICAgd2hpbGUgKHNvRmFyKSB7XG4gICAgICAgICAgLy8gQ29tbWEgYW5kIGZpcnN0IHJ1blxuICAgICAgICAgIGlmICghbWF0Y2hlZCB8fCAobWF0Y2ggPSByY29tbWEuZXhlYyhzb0ZhcikpKSB7XG4gICAgICAgICAgICBpZiAobWF0Y2gpIHtcbiAgICAgICAgICAgICAgLy8gRG9uJ3QgY29uc3VtZSB0cmFpbGluZyBjb21tYXMgYXMgdmFsaWRcbiAgICAgICAgICAgICAgc29GYXIgPSBzb0Zhci5zbGljZShtYXRjaFswXS5sZW5ndGgpIHx8IHNvRmFyO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICBncm91cHMucHVzaCh0b2tlbnMgPSBbXSk7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgbWF0Y2hlZCA9IGZhbHNlOyAvLyBDb21iaW5hdG9yc1xuXG4gICAgICAgICAgaWYgKG1hdGNoID0gcmNvbWJpbmF0b3JzLmV4ZWMoc29GYXIpKSB7XG4gICAgICAgICAgICBtYXRjaGVkID0gbWF0Y2guc2hpZnQoKTtcbiAgICAgICAgICAgIHRva2Vucy5wdXNoKHtcbiAgICAgICAgICAgICAgdmFsdWU6IG1hdGNoZWQsXG4gICAgICAgICAgICAgIC8vIENhc3QgZGVzY2VuZGFudCBjb21iaW5hdG9ycyB0byBzcGFjZVxuICAgICAgICAgICAgICB0eXBlOiBtYXRjaFswXS5yZXBsYWNlKHJ0cmltLCBcIiBcIilcbiAgICAgICAgICAgIH0pO1xuICAgICAgICAgICAgc29GYXIgPSBzb0Zhci5zbGljZShtYXRjaGVkLmxlbmd0aCk7XG4gICAgICAgICAgfSAvLyBGaWx0ZXJzXG5cblxuICAgICAgICAgIGZvciAodHlwZSBpbiBFeHByLmZpbHRlcikge1xuICAgICAgICAgICAgaWYgKChtYXRjaCA9IG1hdGNoRXhwclt0eXBlXS5leGVjKHNvRmFyKSkgJiYgKCFwcmVGaWx0ZXJzW3R5cGVdIHx8IChtYXRjaCA9IHByZUZpbHRlcnNbdHlwZV0obWF0Y2gpKSkpIHtcbiAgICAgICAgICAgICAgbWF0Y2hlZCA9IG1hdGNoLnNoaWZ0KCk7XG4gICAgICAgICAgICAgIHRva2Vucy5wdXNoKHtcbiAgICAgICAgICAgICAgICB2YWx1ZTogbWF0Y2hlZCxcbiAgICAgICAgICAgICAgICB0eXBlOiB0eXBlLFxuICAgICAgICAgICAgICAgIG1hdGNoZXM6IG1hdGNoXG4gICAgICAgICAgICAgIH0pO1xuICAgICAgICAgICAgICBzb0ZhciA9IHNvRmFyLnNsaWNlKG1hdGNoZWQubGVuZ3RoKTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9XG5cbiAgICAgICAgICBpZiAoIW1hdGNoZWQpIHtcbiAgICAgICAgICAgIGJyZWFrO1xuICAgICAgICAgIH1cbiAgICAgICAgfSAvLyBSZXR1cm4gdGhlIGxlbmd0aCBvZiB0aGUgaW52YWxpZCBleGNlc3NcbiAgICAgICAgLy8gaWYgd2UncmUganVzdCBwYXJzaW5nXG4gICAgICAgIC8vIE90aGVyd2lzZSwgdGhyb3cgYW4gZXJyb3Igb3IgcmV0dXJuIHRva2Vuc1xuXG5cbiAgICAgICAgdmFyIGludmFsaWRMZW4gPSBzb0Zhci5sZW5ndGg7XG5cbiAgICAgICAgaWYgKHBhcnNlT25seSkge1xuICAgICAgICAgIHJldHVybiBpbnZhbGlkTGVuO1xuICAgICAgICB9XG5cbiAgICAgICAgaWYgKGludmFsaWRMZW4gIT09IDAgJiYgIXRvbGVyYW50KSB7XG4gICAgICAgICAgU2l6emxlLmVycm9yKHNlbGVjdG9yKTsgLy8gVGhyb3dzIGFuIGVycm9yLlxuICAgICAgICB9XG5cbiAgICAgICAgaWYgKHRvbGVyYW50KSB7XG4gICAgICAgICAgLyoqXG4gICAgICAgICAgICogW0FkR3VhcmQgUGF0Y2hdOlxuICAgICAgICAgICAqIEluIHRvbGVyYW50IG1vZGUgd2UgcmV0dXJuIGEgc3BlY2lhbCBvYmplY3QgdGhhdCBjb25zdGlzdHMgb2ZcbiAgICAgICAgICAgKiBhbiBhcnJheSBvZiBwYXJzZWQgc2VsZWN0b3JzIChhbmQgdGhlaXIgdG9rZW5zKSBhbmQgYSBcIm5leHRJbmRleFwiIGZpZWxkXG4gICAgICAgICAgICogdGhhdCBwb2ludHMgdG8gYW4gaW5kZXggYWZ0ZXIgd2hpY2ggd2UncmUgbm90IGFibGUgdG8gcGFyc2Ugc2VsZWN0b3JzIGZhcnRoZXIuXG4gICAgICAgICAgICovXG4gICAgICAgICAgdmFyIG5leHRJbmRleCA9IHNlbGVjdG9yLmxlbmd0aCAtIGludmFsaWRMZW47XG4gICAgICAgICAgdmFyIHNlbGVjdG9ycyA9IHRva2VuR3JvdXBzVG9TZWxlY3RvcnMoZ3JvdXBzKTtcbiAgICAgICAgICByZXR1cm4ge1xuICAgICAgICAgICAgc2VsZWN0b3JzOiBzZWxlY3RvcnMsXG4gICAgICAgICAgICBuZXh0SW5kZXg6IG5leHRJbmRleFxuICAgICAgICAgIH07XG4gICAgICAgIH1cbiAgICAgICAgLyoqIFtBZEd1YXJkIFBhdGNoXTogU29ydGluZyB0b2tlbnMgKi9cblxuXG4gICAgICAgIHZhciBzb3J0ZWRHcm91cHMgPSBzb3J0VG9rZW5Hcm91cHMoZ3JvdXBzKTtcbiAgICAgICAgLyoqIFtBZEd1YXJkIFBhdGNoXTogQ2hhbmdlIHRoZSB3YXkgdG9rZW5zIGFyZSBjYWNoZWQgKi9cblxuICAgICAgICB2YXIgdG9rZW5zQ2FjaGVJdGVtID0ge1xuICAgICAgICAgIGdyb3VwczogZ3JvdXBzLFxuICAgICAgICAgIHNvcnRlZEdyb3Vwczogc29ydGVkR3JvdXBzXG4gICAgICAgIH07XG4gICAgICAgIHRva2Vuc0NhY2hlSXRlbSA9IHRva2VuQ2FjaGUoc2VsZWN0b3IsIHRva2Vuc0NhY2hlSXRlbSk7XG4gICAgICAgIHJldHVybiAocmV0dXJuVW5zb3J0ZWQgPyB0b2tlbnNDYWNoZUl0ZW0uZ3JvdXBzIDogdG9rZW5zQ2FjaGVJdGVtLnNvcnRlZEdyb3Vwcykuc2xpY2UoMCk7XG4gICAgICB9O1xuXG4gICAgICBmdW5jdGlvbiB0b1NlbGVjdG9yKHRva2Vucykge1xuICAgICAgICB2YXIgaSA9IDAsXG4gICAgICAgICAgICBsZW4gPSB0b2tlbnMubGVuZ3RoLFxuICAgICAgICAgICAgc2VsZWN0b3IgPSBcIlwiO1xuXG4gICAgICAgIGZvciAoOyBpIDwgbGVuOyBpKyspIHtcbiAgICAgICAgICBzZWxlY3RvciArPSB0b2tlbnNbaV0udmFsdWU7XG4gICAgICAgIH1cblxuICAgICAgICByZXR1cm4gc2VsZWN0b3I7XG4gICAgICB9XG5cbiAgICAgIGZ1bmN0aW9uIGFkZENvbWJpbmF0b3IobWF0Y2hlciwgY29tYmluYXRvciwgYmFzZSkge1xuICAgICAgICB2YXIgZGlyID0gY29tYmluYXRvci5kaXIsXG4gICAgICAgICAgICBza2lwID0gY29tYmluYXRvci5uZXh0LFxuICAgICAgICAgICAga2V5ID0gc2tpcCB8fCBkaXIsXG4gICAgICAgICAgICBjaGVja05vbkVsZW1lbnRzID0gYmFzZSAmJiBrZXkgPT09IFwicGFyZW50Tm9kZVwiLFxuICAgICAgICAgICAgZG9uZU5hbWUgPSBkb25lKys7XG4gICAgICAgIHJldHVybiBjb21iaW5hdG9yLmZpcnN0ID8gLy8gQ2hlY2sgYWdhaW5zdCBjbG9zZXN0IGFuY2VzdG9yL3ByZWNlZGluZyBlbGVtZW50XG4gICAgICAgIGZ1bmN0aW9uIChlbGVtLCBjb250ZXh0LCB4bWwpIHtcbiAgICAgICAgICB3aGlsZSAoZWxlbSA9IGVsZW1bZGlyXSkge1xuICAgICAgICAgICAgaWYgKGVsZW0ubm9kZVR5cGUgPT09IDEgfHwgY2hlY2tOb25FbGVtZW50cykge1xuICAgICAgICAgICAgICByZXR1cm4gbWF0Y2hlcihlbGVtLCBjb250ZXh0LCB4bWwpO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cblxuICAgICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgICAgfSA6IC8vIENoZWNrIGFnYWluc3QgYWxsIGFuY2VzdG9yL3ByZWNlZGluZyBlbGVtZW50c1xuICAgICAgICBmdW5jdGlvbiAoZWxlbSwgY29udGV4dCwgeG1sKSB7XG4gICAgICAgICAgdmFyIG9sZENhY2hlLFxuICAgICAgICAgICAgICB1bmlxdWVDYWNoZSxcbiAgICAgICAgICAgICAgb3V0ZXJDYWNoZSxcbiAgICAgICAgICAgICAgbmV3Q2FjaGUgPSBbZGlycnVucywgZG9uZU5hbWVdOyAvLyBXZSBjYW4ndCBzZXQgYXJiaXRyYXJ5IGRhdGEgb24gWE1MIG5vZGVzLCBzbyB0aGV5IGRvbid0IGJlbmVmaXQgZnJvbSBjb21iaW5hdG9yIGNhY2hpbmdcblxuICAgICAgICAgIGlmICh4bWwpIHtcbiAgICAgICAgICAgIHdoaWxlIChlbGVtID0gZWxlbVtkaXJdKSB7XG4gICAgICAgICAgICAgIGlmIChlbGVtLm5vZGVUeXBlID09PSAxIHx8IGNoZWNrTm9uRWxlbWVudHMpIHtcbiAgICAgICAgICAgICAgICBpZiAobWF0Y2hlcihlbGVtLCBjb250ZXh0LCB4bWwpKSB7XG4gICAgICAgICAgICAgICAgICByZXR1cm4gdHJ1ZTtcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgd2hpbGUgKGVsZW0gPSBlbGVtW2Rpcl0pIHtcbiAgICAgICAgICAgICAgaWYgKGVsZW0ubm9kZVR5cGUgPT09IDEgfHwgY2hlY2tOb25FbGVtZW50cykge1xuICAgICAgICAgICAgICAgIG91dGVyQ2FjaGUgPSBlbGVtW2V4cGFuZG9dIHx8IChlbGVtW2V4cGFuZG9dID0ge30pOyAvLyBTdXBwb3J0OiBJRSA8OSBvbmx5XG4gICAgICAgICAgICAgICAgLy8gRGVmZW5kIGFnYWluc3QgY2xvbmVkIGF0dHJvcGVydGllcyAoalF1ZXJ5IGdoLTE3MDkpXG5cbiAgICAgICAgICAgICAgICB1bmlxdWVDYWNoZSA9IG91dGVyQ2FjaGVbZWxlbS51bmlxdWVJRF0gfHwgKG91dGVyQ2FjaGVbZWxlbS51bmlxdWVJRF0gPSB7fSk7XG5cbiAgICAgICAgICAgICAgICBpZiAoc2tpcCAmJiBza2lwID09PSBlbGVtLm5vZGVOYW1lLnRvTG93ZXJDYXNlKCkpIHtcbiAgICAgICAgICAgICAgICAgIGVsZW0gPSBlbGVtW2Rpcl0gfHwgZWxlbTtcbiAgICAgICAgICAgICAgICB9IGVsc2UgaWYgKChvbGRDYWNoZSA9IHVuaXF1ZUNhY2hlW2tleV0pICYmIG9sZENhY2hlWzBdID09PSBkaXJydW5zICYmIG9sZENhY2hlWzFdID09PSBkb25lTmFtZSkge1xuICAgICAgICAgICAgICAgICAgLy8gQXNzaWduIHRvIG5ld0NhY2hlIHNvIHJlc3VsdHMgYmFjay1wcm9wYWdhdGUgdG8gcHJldmlvdXMgZWxlbWVudHNcbiAgICAgICAgICAgICAgICAgIHJldHVybiBuZXdDYWNoZVsyXSA9IG9sZENhY2hlWzJdO1xuICAgICAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgICAgICAvLyBSZXVzZSBuZXdjYWNoZSBzbyByZXN1bHRzIGJhY2stcHJvcGFnYXRlIHRvIHByZXZpb3VzIGVsZW1lbnRzXG4gICAgICAgICAgICAgICAgICB1bmlxdWVDYWNoZVtrZXldID0gbmV3Q2FjaGU7IC8vIEEgbWF0Y2ggbWVhbnMgd2UncmUgZG9uZTsgYSBmYWlsIG1lYW5zIHdlIGhhdmUgdG8ga2VlcCBjaGVja2luZ1xuXG4gICAgICAgICAgICAgICAgICBpZiAobmV3Q2FjaGVbMl0gPSBtYXRjaGVyKGVsZW0sIGNvbnRleHQsIHhtbCkpIHtcbiAgICAgICAgICAgICAgICAgICAgcmV0dXJuIHRydWU7XG4gICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgcmV0dXJuIGZhbHNlO1xuICAgICAgICB9O1xuICAgICAgfVxuXG4gICAgICBmdW5jdGlvbiBlbGVtZW50TWF0Y2hlcihtYXRjaGVycykge1xuICAgICAgICByZXR1cm4gbWF0Y2hlcnMubGVuZ3RoID4gMSA/IGZ1bmN0aW9uIChlbGVtLCBjb250ZXh0LCB4bWwpIHtcbiAgICAgICAgICB2YXIgaSA9IG1hdGNoZXJzLmxlbmd0aDtcblxuICAgICAgICAgIHdoaWxlIChpLS0pIHtcbiAgICAgICAgICAgIGlmICghbWF0Y2hlcnNbaV0oZWxlbSwgY29udGV4dCwgeG1sKSkge1xuICAgICAgICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgcmV0dXJuIHRydWU7XG4gICAgICAgIH0gOiBtYXRjaGVyc1swXTtcbiAgICAgIH1cblxuICAgICAgZnVuY3Rpb24gbXVsdGlwbGVDb250ZXh0cyhzZWxlY3RvciwgY29udGV4dHMsIHJlc3VsdHMpIHtcbiAgICAgICAgdmFyIGkgPSAwLFxuICAgICAgICAgICAgbGVuID0gY29udGV4dHMubGVuZ3RoO1xuXG4gICAgICAgIGZvciAoOyBpIDwgbGVuOyBpKyspIHtcbiAgICAgICAgICBTaXp6bGUoc2VsZWN0b3IsIGNvbnRleHRzW2ldLCByZXN1bHRzKTtcbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiByZXN1bHRzO1xuICAgICAgfVxuXG4gICAgICBmdW5jdGlvbiBjb25kZW5zZSh1bm1hdGNoZWQsIG1hcCwgZmlsdGVyLCBjb250ZXh0LCB4bWwpIHtcbiAgICAgICAgdmFyIGVsZW0sXG4gICAgICAgICAgICBuZXdVbm1hdGNoZWQgPSBbXSxcbiAgICAgICAgICAgIGkgPSAwLFxuICAgICAgICAgICAgbGVuID0gdW5tYXRjaGVkLmxlbmd0aCxcbiAgICAgICAgICAgIG1hcHBlZCA9IG1hcCAhPSBudWxsO1xuXG4gICAgICAgIGZvciAoOyBpIDwgbGVuOyBpKyspIHtcbiAgICAgICAgICBpZiAoZWxlbSA9IHVubWF0Y2hlZFtpXSkge1xuICAgICAgICAgICAgaWYgKCFmaWx0ZXIgfHwgZmlsdGVyKGVsZW0sIGNvbnRleHQsIHhtbCkpIHtcbiAgICAgICAgICAgICAgbmV3VW5tYXRjaGVkLnB1c2goZWxlbSk7XG5cbiAgICAgICAgICAgICAgaWYgKG1hcHBlZCkge1xuICAgICAgICAgICAgICAgIG1hcC5wdXNoKGkpO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfVxuICAgICAgICB9XG5cbiAgICAgICAgcmV0dXJuIG5ld1VubWF0Y2hlZDtcbiAgICAgIH1cblxuICAgICAgZnVuY3Rpb24gc2V0TWF0Y2hlcihwcmVGaWx0ZXIsIHNlbGVjdG9yLCBtYXRjaGVyLCBwb3N0RmlsdGVyLCBwb3N0RmluZGVyLCBwb3N0U2VsZWN0b3IpIHtcbiAgICAgICAgaWYgKHBvc3RGaWx0ZXIgJiYgIXBvc3RGaWx0ZXJbZXhwYW5kb10pIHtcbiAgICAgICAgICBwb3N0RmlsdGVyID0gc2V0TWF0Y2hlcihwb3N0RmlsdGVyKTtcbiAgICAgICAgfVxuXG4gICAgICAgIGlmIChwb3N0RmluZGVyICYmICFwb3N0RmluZGVyW2V4cGFuZG9dKSB7XG4gICAgICAgICAgcG9zdEZpbmRlciA9IHNldE1hdGNoZXIocG9zdEZpbmRlciwgcG9zdFNlbGVjdG9yKTtcbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiBtYXJrRnVuY3Rpb24oZnVuY3Rpb24gKHNlZWQsIHJlc3VsdHMsIGNvbnRleHQsIHhtbCkge1xuICAgICAgICAgIHZhciB0ZW1wLFxuICAgICAgICAgICAgICBpLFxuICAgICAgICAgICAgICBlbGVtLFxuICAgICAgICAgICAgICBwcmVNYXAgPSBbXSxcbiAgICAgICAgICAgICAgcG9zdE1hcCA9IFtdLFxuICAgICAgICAgICAgICBwcmVleGlzdGluZyA9IHJlc3VsdHMubGVuZ3RoLFxuICAgICAgICAgICAgICAvLyBHZXQgaW5pdGlhbCBlbGVtZW50cyBmcm9tIHNlZWQgb3IgY29udGV4dFxuICAgICAgICAgIGVsZW1zID0gc2VlZCB8fCBtdWx0aXBsZUNvbnRleHRzKHNlbGVjdG9yIHx8IFwiKlwiLCBjb250ZXh0Lm5vZGVUeXBlID8gW2NvbnRleHRdIDogY29udGV4dCwgW10pLFxuICAgICAgICAgICAgICAvLyBQcmVmaWx0ZXIgdG8gZ2V0IG1hdGNoZXIgaW5wdXQsIHByZXNlcnZpbmcgYSBtYXAgZm9yIHNlZWQtcmVzdWx0cyBzeW5jaHJvbml6YXRpb25cbiAgICAgICAgICBtYXRjaGVySW4gPSBwcmVGaWx0ZXIgJiYgKHNlZWQgfHwgIXNlbGVjdG9yKSA/IGNvbmRlbnNlKGVsZW1zLCBwcmVNYXAsIHByZUZpbHRlciwgY29udGV4dCwgeG1sKSA6IGVsZW1zLFxuICAgICAgICAgICAgICBtYXRjaGVyT3V0ID0gbWF0Y2hlciA/IC8vIElmIHdlIGhhdmUgYSBwb3N0RmluZGVyLCBvciBmaWx0ZXJlZCBzZWVkLCBvciBub24tc2VlZCBwb3N0RmlsdGVyIG9yIHByZWV4aXN0aW5nIHJlc3VsdHMsXG4gICAgICAgICAgcG9zdEZpbmRlciB8fCAoc2VlZCA/IHByZUZpbHRlciA6IHByZWV4aXN0aW5nIHx8IHBvc3RGaWx0ZXIpID8gLy8gLi4uaW50ZXJtZWRpYXRlIHByb2Nlc3NpbmcgaXMgbmVjZXNzYXJ5XG4gICAgICAgICAgW10gOiAvLyAuLi5vdGhlcndpc2UgdXNlIHJlc3VsdHMgZGlyZWN0bHlcbiAgICAgICAgICByZXN1bHRzIDogbWF0Y2hlckluOyAvLyBGaW5kIHByaW1hcnkgbWF0Y2hlc1xuXG4gICAgICAgICAgaWYgKG1hdGNoZXIpIHtcbiAgICAgICAgICAgIG1hdGNoZXIobWF0Y2hlckluLCBtYXRjaGVyT3V0LCBjb250ZXh0LCB4bWwpO1xuICAgICAgICAgIH0gLy8gQXBwbHkgcG9zdEZpbHRlclxuXG5cbiAgICAgICAgICBpZiAocG9zdEZpbHRlcikge1xuICAgICAgICAgICAgdGVtcCA9IGNvbmRlbnNlKG1hdGNoZXJPdXQsIHBvc3RNYXApO1xuICAgICAgICAgICAgcG9zdEZpbHRlcih0ZW1wLCBbXSwgY29udGV4dCwgeG1sKTsgLy8gVW4tbWF0Y2ggZmFpbGluZyBlbGVtZW50cyBieSBtb3ZpbmcgdGhlbSBiYWNrIHRvIG1hdGNoZXJJblxuXG4gICAgICAgICAgICBpID0gdGVtcC5sZW5ndGg7XG5cbiAgICAgICAgICAgIHdoaWxlIChpLS0pIHtcbiAgICAgICAgICAgICAgaWYgKGVsZW0gPSB0ZW1wW2ldKSB7XG4gICAgICAgICAgICAgICAgbWF0Y2hlck91dFtwb3N0TWFwW2ldXSA9ICEobWF0Y2hlckluW3Bvc3RNYXBbaV1dID0gZWxlbSk7XG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9XG5cbiAgICAgICAgICBpZiAoc2VlZCkge1xuICAgICAgICAgICAgaWYgKHBvc3RGaW5kZXIgfHwgcHJlRmlsdGVyKSB7XG4gICAgICAgICAgICAgIGlmIChwb3N0RmluZGVyKSB7XG4gICAgICAgICAgICAgICAgLy8gR2V0IHRoZSBmaW5hbCBtYXRjaGVyT3V0IGJ5IGNvbmRlbnNpbmcgdGhpcyBpbnRlcm1lZGlhdGUgaW50byBwb3N0RmluZGVyIGNvbnRleHRzXG4gICAgICAgICAgICAgICAgdGVtcCA9IFtdO1xuICAgICAgICAgICAgICAgIGkgPSBtYXRjaGVyT3V0Lmxlbmd0aDtcblxuICAgICAgICAgICAgICAgIHdoaWxlIChpLS0pIHtcbiAgICAgICAgICAgICAgICAgIGlmIChlbGVtID0gbWF0Y2hlck91dFtpXSkge1xuICAgICAgICAgICAgICAgICAgICAvLyBSZXN0b3JlIG1hdGNoZXJJbiBzaW5jZSBlbGVtIGlzIG5vdCB5ZXQgYSBmaW5hbCBtYXRjaFxuICAgICAgICAgICAgICAgICAgICB0ZW1wLnB1c2gobWF0Y2hlckluW2ldID0gZWxlbSk7XG4gICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgcG9zdEZpbmRlcihudWxsLCBtYXRjaGVyT3V0ID0gW10sIHRlbXAsIHhtbCk7XG4gICAgICAgICAgICAgIH0gLy8gTW92ZSBtYXRjaGVkIGVsZW1lbnRzIGZyb20gc2VlZCB0byByZXN1bHRzIHRvIGtlZXAgdGhlbSBzeW5jaHJvbml6ZWRcblxuXG4gICAgICAgICAgICAgIGkgPSBtYXRjaGVyT3V0Lmxlbmd0aDtcblxuICAgICAgICAgICAgICB3aGlsZSAoaS0tKSB7XG4gICAgICAgICAgICAgICAgaWYgKChlbGVtID0gbWF0Y2hlck91dFtpXSkgJiYgKHRlbXAgPSBwb3N0RmluZGVyID8gaW5kZXhPZihzZWVkLCBlbGVtKSA6IHByZU1hcFtpXSkgPiAtMSkge1xuICAgICAgICAgICAgICAgICAgc2VlZFt0ZW1wXSA9ICEocmVzdWx0c1t0ZW1wXSA9IGVsZW0pO1xuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfSAvLyBBZGQgZWxlbWVudHMgdG8gcmVzdWx0cywgdGhyb3VnaCBwb3N0RmluZGVyIGlmIGRlZmluZWRcblxuICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICBtYXRjaGVyT3V0ID0gY29uZGVuc2UobWF0Y2hlck91dCA9PT0gcmVzdWx0cyA/IG1hdGNoZXJPdXQuc3BsaWNlKHByZWV4aXN0aW5nLCBtYXRjaGVyT3V0Lmxlbmd0aCkgOiBtYXRjaGVyT3V0KTtcblxuICAgICAgICAgICAgaWYgKHBvc3RGaW5kZXIpIHtcbiAgICAgICAgICAgICAgcG9zdEZpbmRlcihudWxsLCByZXN1bHRzLCBtYXRjaGVyT3V0LCB4bWwpO1xuICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgcHVzaC5hcHBseShyZXN1bHRzLCBtYXRjaGVyT3V0KTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9XG4gICAgICAgIH0pO1xuICAgICAgfVxuXG4gICAgICBmdW5jdGlvbiBtYXRjaGVyRnJvbVRva2Vucyh0b2tlbnMpIHtcbiAgICAgICAgdmFyIGNoZWNrQ29udGV4dCxcbiAgICAgICAgICAgIG1hdGNoZXIsXG4gICAgICAgICAgICBqLFxuICAgICAgICAgICAgbGVuID0gdG9rZW5zLmxlbmd0aCxcbiAgICAgICAgICAgIGxlYWRpbmdSZWxhdGl2ZSA9IEV4cHIucmVsYXRpdmVbdG9rZW5zWzBdLnR5cGVdLFxuICAgICAgICAgICAgaW1wbGljaXRSZWxhdGl2ZSA9IGxlYWRpbmdSZWxhdGl2ZSB8fCBFeHByLnJlbGF0aXZlW1wiIFwiXSxcbiAgICAgICAgICAgIGkgPSBsZWFkaW5nUmVsYXRpdmUgPyAxIDogMCxcbiAgICAgICAgICAgIC8vIFRoZSBmb3VuZGF0aW9uYWwgbWF0Y2hlciBlbnN1cmVzIHRoYXQgZWxlbWVudHMgYXJlIHJlYWNoYWJsZSBmcm9tIHRvcC1sZXZlbCBjb250ZXh0KHMpXG4gICAgICAgIG1hdGNoQ29udGV4dCA9IGFkZENvbWJpbmF0b3IoZnVuY3Rpb24gKGVsZW0pIHtcbiAgICAgICAgICByZXR1cm4gZWxlbSA9PT0gY2hlY2tDb250ZXh0O1xuICAgICAgICB9LCBpbXBsaWNpdFJlbGF0aXZlLCB0cnVlKSxcbiAgICAgICAgICAgIG1hdGNoQW55Q29udGV4dCA9IGFkZENvbWJpbmF0b3IoZnVuY3Rpb24gKGVsZW0pIHtcbiAgICAgICAgICByZXR1cm4gaW5kZXhPZihjaGVja0NvbnRleHQsIGVsZW0pID4gLTE7XG4gICAgICAgIH0sIGltcGxpY2l0UmVsYXRpdmUsIHRydWUpLFxuICAgICAgICAgICAgbWF0Y2hlcnMgPSBbZnVuY3Rpb24gKGVsZW0sIGNvbnRleHQsIHhtbCkge1xuICAgICAgICAgIHZhciByZXQgPSAhbGVhZGluZ1JlbGF0aXZlICYmICh4bWwgfHwgY29udGV4dCAhPT0gb3V0ZXJtb3N0Q29udGV4dCkgfHwgKChjaGVja0NvbnRleHQgPSBjb250ZXh0KS5ub2RlVHlwZSA/IG1hdGNoQ29udGV4dChlbGVtLCBjb250ZXh0LCB4bWwpIDogbWF0Y2hBbnlDb250ZXh0KGVsZW0sIGNvbnRleHQsIHhtbCkpOyAvLyBBdm9pZCBoYW5naW5nIG9udG8gZWxlbWVudCAoaXNzdWUgIzI5OSlcblxuICAgICAgICAgIGNoZWNrQ29udGV4dCA9IG51bGw7XG4gICAgICAgICAgcmV0dXJuIHJldDtcbiAgICAgICAgfV07XG5cbiAgICAgICAgZm9yICg7IGkgPCBsZW47IGkrKykge1xuICAgICAgICAgIGlmIChtYXRjaGVyID0gRXhwci5yZWxhdGl2ZVt0b2tlbnNbaV0udHlwZV0pIHtcbiAgICAgICAgICAgIG1hdGNoZXJzID0gW2FkZENvbWJpbmF0b3IoZWxlbWVudE1hdGNoZXIobWF0Y2hlcnMpLCBtYXRjaGVyKV07XG4gICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIG1hdGNoZXIgPSBFeHByLmZpbHRlclt0b2tlbnNbaV0udHlwZV0uYXBwbHkobnVsbCwgdG9rZW5zW2ldLm1hdGNoZXMpOyAvLyBSZXR1cm4gc3BlY2lhbCB1cG9uIHNlZWluZyBhIHBvc2l0aW9uYWwgbWF0Y2hlclxuXG4gICAgICAgICAgICBpZiAobWF0Y2hlcltleHBhbmRvXSkge1xuICAgICAgICAgICAgICAvLyBGaW5kIHRoZSBuZXh0IHJlbGF0aXZlIG9wZXJhdG9yIChpZiBhbnkpIGZvciBwcm9wZXIgaGFuZGxpbmdcbiAgICAgICAgICAgICAgaiA9ICsraTtcblxuICAgICAgICAgICAgICBmb3IgKDsgaiA8IGxlbjsgaisrKSB7XG4gICAgICAgICAgICAgICAgaWYgKEV4cHIucmVsYXRpdmVbdG9rZW5zW2pdLnR5cGVdKSB7XG4gICAgICAgICAgICAgICAgICBicmVhaztcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICByZXR1cm4gc2V0TWF0Y2hlcihpID4gMSAmJiBlbGVtZW50TWF0Y2hlcihtYXRjaGVycyksIGkgPiAxICYmIHRvU2VsZWN0b3IoIC8vIElmIHRoZSBwcmVjZWRpbmcgdG9rZW4gd2FzIGEgZGVzY2VuZGFudCBjb21iaW5hdG9yLCBpbnNlcnQgYW4gaW1wbGljaXQgYW55LWVsZW1lbnQgYCpgXG4gICAgICAgICAgICAgIHRva2Vucy5zbGljZSgwLCBpIC0gMSkuY29uY2F0KHtcbiAgICAgICAgICAgICAgICB2YWx1ZTogdG9rZW5zW2kgLSAyXS50eXBlID09PSBcIiBcIiA/IFwiKlwiIDogXCJcIlxuICAgICAgICAgICAgICB9KSkucmVwbGFjZShydHJpbSwgXCIkMVwiKSwgbWF0Y2hlciwgaSA8IGogJiYgbWF0Y2hlckZyb21Ub2tlbnModG9rZW5zLnNsaWNlKGksIGopKSwgaiA8IGxlbiAmJiBtYXRjaGVyRnJvbVRva2Vucyh0b2tlbnMgPSB0b2tlbnMuc2xpY2UoaikpLCBqIDwgbGVuICYmIHRvU2VsZWN0b3IodG9rZW5zKSk7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIG1hdGNoZXJzLnB1c2gobWF0Y2hlcik7XG4gICAgICAgICAgfVxuICAgICAgICB9XG5cbiAgICAgICAgcmV0dXJuIGVsZW1lbnRNYXRjaGVyKG1hdGNoZXJzKTtcbiAgICAgIH1cblxuICAgICAgZnVuY3Rpb24gbWF0Y2hlckZyb21Hcm91cE1hdGNoZXJzKGVsZW1lbnRNYXRjaGVycywgc2V0TWF0Y2hlcnMpIHtcbiAgICAgICAgdmFyIGJ5U2V0ID0gc2V0TWF0Y2hlcnMubGVuZ3RoID4gMCxcbiAgICAgICAgICAgIGJ5RWxlbWVudCA9IGVsZW1lbnRNYXRjaGVycy5sZW5ndGggPiAwLFxuICAgICAgICAgICAgc3VwZXJNYXRjaGVyID0gZnVuY3Rpb24gc3VwZXJNYXRjaGVyKHNlZWQsIGNvbnRleHQsIHhtbCwgcmVzdWx0cywgb3V0ZXJtb3N0KSB7XG4gICAgICAgICAgdmFyIGVsZW0sXG4gICAgICAgICAgICAgIGosXG4gICAgICAgICAgICAgIG1hdGNoZXIsXG4gICAgICAgICAgICAgIG1hdGNoZWRDb3VudCA9IDAsXG4gICAgICAgICAgICAgIGkgPSBcIjBcIixcbiAgICAgICAgICAgICAgdW5tYXRjaGVkID0gc2VlZCAmJiBbXSxcbiAgICAgICAgICAgICAgc2V0TWF0Y2hlZCA9IFtdLFxuICAgICAgICAgICAgICBjb250ZXh0QmFja3VwID0gb3V0ZXJtb3N0Q29udGV4dCxcbiAgICAgICAgICAgICAgLy8gV2UgbXVzdCBhbHdheXMgaGF2ZSBlaXRoZXIgc2VlZCBlbGVtZW50cyBvciBvdXRlcm1vc3QgY29udGV4dFxuICAgICAgICAgIGVsZW1zID0gc2VlZCB8fCBieUVsZW1lbnQgJiYgRXhwci5maW5kW1wiVEFHXCJdKFwiKlwiLCBvdXRlcm1vc3QpLFxuICAgICAgICAgICAgICAvLyBVc2UgaW50ZWdlciBkaXJydW5zIGlmZiB0aGlzIGlzIHRoZSBvdXRlcm1vc3QgbWF0Y2hlclxuICAgICAgICAgIGRpcnJ1bnNVbmlxdWUgPSBkaXJydW5zICs9IGNvbnRleHRCYWNrdXAgPT0gbnVsbCA/IDEgOiBNYXRoLnJhbmRvbSgpIHx8IDAuMSxcbiAgICAgICAgICAgICAgbGVuID0gZWxlbXMubGVuZ3RoO1xuXG4gICAgICAgICAgaWYgKG91dGVybW9zdCkge1xuICAgICAgICAgICAgb3V0ZXJtb3N0Q29udGV4dCA9IGNvbnRleHQgPT09IGRvY3VtZW50IHx8IGNvbnRleHQgfHwgb3V0ZXJtb3N0O1xuICAgICAgICAgIH0gLy8gQWRkIGVsZW1lbnRzIHBhc3NpbmcgZWxlbWVudE1hdGNoZXJzIGRpcmVjdGx5IHRvIHJlc3VsdHNcbiAgICAgICAgICAvLyBTdXBwb3J0OiBJRTw5LCBTYWZhcmlcbiAgICAgICAgICAvLyBUb2xlcmF0ZSBOb2RlTGlzdCBwcm9wZXJ0aWVzIChJRTogXCJsZW5ndGhcIjsgU2FmYXJpOiA8bnVtYmVyPikgbWF0Y2hpbmcgZWxlbWVudHMgYnkgaWRcblxuXG4gICAgICAgICAgZm9yICg7IGkgIT09IGxlbiAmJiAoZWxlbSA9IGVsZW1zW2ldKSAhPSBudWxsOyBpKyspIHtcbiAgICAgICAgICAgIGlmIChieUVsZW1lbnQgJiYgZWxlbSkge1xuICAgICAgICAgICAgICBqID0gMDtcblxuICAgICAgICAgICAgICBpZiAoIWNvbnRleHQgJiYgZWxlbS5vd25lckRvY3VtZW50ICE9PSBkb2N1bWVudCkge1xuICAgICAgICAgICAgICAgIHNldERvY3VtZW50KGVsZW0pO1xuICAgICAgICAgICAgICAgIHhtbCA9ICFkb2N1bWVudElzSFRNTDtcbiAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgIHdoaWxlIChtYXRjaGVyID0gZWxlbWVudE1hdGNoZXJzW2orK10pIHtcbiAgICAgICAgICAgICAgICBpZiAobWF0Y2hlcihlbGVtLCBjb250ZXh0IHx8IGRvY3VtZW50LCB4bWwpKSB7XG4gICAgICAgICAgICAgICAgICByZXN1bHRzLnB1c2goZWxlbSk7XG4gICAgICAgICAgICAgICAgICBicmVhaztcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICBpZiAob3V0ZXJtb3N0KSB7XG4gICAgICAgICAgICAgICAgZGlycnVucyA9IGRpcnJ1bnNVbmlxdWU7XG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH0gLy8gVHJhY2sgdW5tYXRjaGVkIGVsZW1lbnRzIGZvciBzZXQgZmlsdGVyc1xuXG5cbiAgICAgICAgICAgIGlmIChieVNldCkge1xuICAgICAgICAgICAgICAvLyBUaGV5IHdpbGwgaGF2ZSBnb25lIHRocm91Z2ggYWxsIHBvc3NpYmxlIG1hdGNoZXJzXG4gICAgICAgICAgICAgIGlmIChlbGVtID0gIW1hdGNoZXIgJiYgZWxlbSkge1xuICAgICAgICAgICAgICAgIG1hdGNoZWRDb3VudC0tO1xuICAgICAgICAgICAgICB9IC8vIExlbmd0aGVuIHRoZSBhcnJheSBmb3IgZXZlcnkgZWxlbWVudCwgbWF0Y2hlZCBvciBub3RcblxuXG4gICAgICAgICAgICAgIGlmIChzZWVkKSB7XG4gICAgICAgICAgICAgICAgdW5tYXRjaGVkLnB1c2goZWxlbSk7XG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9IC8vIGBpYCBpcyBub3cgdGhlIGNvdW50IG9mIGVsZW1lbnRzIHZpc2l0ZWQgYWJvdmUsIGFuZCBhZGRpbmcgaXQgdG8gYG1hdGNoZWRDb3VudGBcbiAgICAgICAgICAvLyBtYWtlcyB0aGUgbGF0dGVyIG5vbm5lZ2F0aXZlLlxuXG5cbiAgICAgICAgICBtYXRjaGVkQ291bnQgKz0gaTsgLy8gQXBwbHkgc2V0IGZpbHRlcnMgdG8gdW5tYXRjaGVkIGVsZW1lbnRzXG4gICAgICAgICAgLy8gTk9URTogVGhpcyBjYW4gYmUgc2tpcHBlZCBpZiB0aGVyZSBhcmUgbm8gdW5tYXRjaGVkIGVsZW1lbnRzIChpLmUuLCBgbWF0Y2hlZENvdW50YFxuICAgICAgICAgIC8vIGVxdWFscyBgaWApLCB1bmxlc3Mgd2UgZGlkbid0IHZpc2l0IF9hbnlfIGVsZW1lbnRzIGluIHRoZSBhYm92ZSBsb29wIGJlY2F1c2Ugd2UgaGF2ZVxuICAgICAgICAgIC8vIG5vIGVsZW1lbnQgbWF0Y2hlcnMgYW5kIG5vIHNlZWQuXG4gICAgICAgICAgLy8gSW5jcmVtZW50aW5nIGFuIGluaXRpYWxseS1zdHJpbmcgXCIwXCIgYGlgIGFsbG93cyBgaWAgdG8gcmVtYWluIGEgc3RyaW5nIG9ubHkgaW4gdGhhdFxuICAgICAgICAgIC8vIGNhc2UsIHdoaWNoIHdpbGwgcmVzdWx0IGluIGEgXCIwMFwiIGBtYXRjaGVkQ291bnRgIHRoYXQgZGlmZmVycyBmcm9tIGBpYCBidXQgaXMgYWxzb1xuICAgICAgICAgIC8vIG51bWVyaWNhbGx5IHplcm8uXG5cbiAgICAgICAgICBpZiAoYnlTZXQgJiYgaSAhPT0gbWF0Y2hlZENvdW50KSB7XG4gICAgICAgICAgICBqID0gMDtcblxuICAgICAgICAgICAgd2hpbGUgKG1hdGNoZXIgPSBzZXRNYXRjaGVyc1tqKytdKSB7XG4gICAgICAgICAgICAgIG1hdGNoZXIodW5tYXRjaGVkLCBzZXRNYXRjaGVkLCBjb250ZXh0LCB4bWwpO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICBpZiAoc2VlZCkge1xuICAgICAgICAgICAgICAvLyBSZWludGVncmF0ZSBlbGVtZW50IG1hdGNoZXMgdG8gZWxpbWluYXRlIHRoZSBuZWVkIGZvciBzb3J0aW5nXG4gICAgICAgICAgICAgIGlmIChtYXRjaGVkQ291bnQgPiAwKSB7XG4gICAgICAgICAgICAgICAgd2hpbGUgKGktLSkge1xuICAgICAgICAgICAgICAgICAgaWYgKCEodW5tYXRjaGVkW2ldIHx8IHNldE1hdGNoZWRbaV0pKSB7XG4gICAgICAgICAgICAgICAgICAgIHNldE1hdGNoZWRbaV0gPSBwb3AuY2FsbChyZXN1bHRzKTtcbiAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgIH0gLy8gRGlzY2FyZCBpbmRleCBwbGFjZWhvbGRlciB2YWx1ZXMgdG8gZ2V0IG9ubHkgYWN0dWFsIG1hdGNoZXNcblxuXG4gICAgICAgICAgICAgIHNldE1hdGNoZWQgPSBjb25kZW5zZShzZXRNYXRjaGVkKTtcbiAgICAgICAgICAgIH0gLy8gQWRkIG1hdGNoZXMgdG8gcmVzdWx0c1xuXG5cbiAgICAgICAgICAgIHB1c2guYXBwbHkocmVzdWx0cywgc2V0TWF0Y2hlZCk7IC8vIFNlZWRsZXNzIHNldCBtYXRjaGVzIHN1Y2NlZWRpbmcgbXVsdGlwbGUgc3VjY2Vzc2Z1bCBtYXRjaGVycyBzdGlwdWxhdGUgc29ydGluZ1xuXG4gICAgICAgICAgICBpZiAob3V0ZXJtb3N0ICYmICFzZWVkICYmIHNldE1hdGNoZWQubGVuZ3RoID4gMCAmJiBtYXRjaGVkQ291bnQgKyBzZXRNYXRjaGVycy5sZW5ndGggPiAxKSB7XG4gICAgICAgICAgICAgIFNpenpsZS51bmlxdWVTb3J0KHJlc3VsdHMpO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH0gLy8gT3ZlcnJpZGUgbWFuaXB1bGF0aW9uIG9mIGdsb2JhbHMgYnkgbmVzdGVkIG1hdGNoZXJzXG5cblxuICAgICAgICAgIGlmIChvdXRlcm1vc3QpIHtcbiAgICAgICAgICAgIGRpcnJ1bnMgPSBkaXJydW5zVW5pcXVlO1xuICAgICAgICAgICAgb3V0ZXJtb3N0Q29udGV4dCA9IGNvbnRleHRCYWNrdXA7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgcmV0dXJuIHVubWF0Y2hlZDtcbiAgICAgICAgfTtcblxuICAgICAgICByZXR1cm4gYnlTZXQgPyBtYXJrRnVuY3Rpb24oc3VwZXJNYXRjaGVyKSA6IHN1cGVyTWF0Y2hlcjtcbiAgICAgIH1cblxuICAgICAgY29tcGlsZSA9IFNpenpsZS5jb21waWxlID0gZnVuY3Rpb24gKHNlbGVjdG9yLCBtYXRjaFxuICAgICAgLyogSW50ZXJuYWwgVXNlIE9ubHkgKi9cbiAgICAgICkge1xuICAgICAgICB2YXIgaSxcbiAgICAgICAgICAgIHNldE1hdGNoZXJzID0gW10sXG4gICAgICAgICAgICBlbGVtZW50TWF0Y2hlcnMgPSBbXSxcbiAgICAgICAgICAgIGNhY2hlZCA9IGNvbXBpbGVyQ2FjaGVbc2VsZWN0b3IgKyBcIiBcIl07XG5cbiAgICAgICAgaWYgKCFjYWNoZWQpIHtcbiAgICAgICAgICAvLyBHZW5lcmF0ZSBhIGZ1bmN0aW9uIG9mIHJlY3Vyc2l2ZSBmdW5jdGlvbnMgdGhhdCBjYW4gYmUgdXNlZCB0byBjaGVjayBlYWNoIGVsZW1lbnRcbiAgICAgICAgICBpZiAoIW1hdGNoKSB7XG4gICAgICAgICAgICBtYXRjaCA9IHRva2VuaXplKHNlbGVjdG9yKTtcbiAgICAgICAgICB9XG5cbiAgICAgICAgICBpID0gbWF0Y2gubGVuZ3RoO1xuXG4gICAgICAgICAgd2hpbGUgKGktLSkge1xuICAgICAgICAgICAgY2FjaGVkID0gbWF0Y2hlckZyb21Ub2tlbnMobWF0Y2hbaV0pO1xuXG4gICAgICAgICAgICBpZiAoY2FjaGVkW2V4cGFuZG9dKSB7XG4gICAgICAgICAgICAgIHNldE1hdGNoZXJzLnB1c2goY2FjaGVkKTtcbiAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgIGVsZW1lbnRNYXRjaGVycy5wdXNoKGNhY2hlZCk7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfSAvLyBDYWNoZSB0aGUgY29tcGlsZWQgZnVuY3Rpb25cblxuXG4gICAgICAgICAgY2FjaGVkID0gY29tcGlsZXJDYWNoZShzZWxlY3RvciwgbWF0Y2hlckZyb21Hcm91cE1hdGNoZXJzKGVsZW1lbnRNYXRjaGVycywgc2V0TWF0Y2hlcnMpKTsgLy8gU2F2ZSBzZWxlY3RvciBhbmQgdG9rZW5pemF0aW9uXG5cbiAgICAgICAgICBjYWNoZWQuc2VsZWN0b3IgPSBzZWxlY3RvcjtcbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiBjYWNoZWQ7XG4gICAgICB9O1xuICAgICAgLyoqXG4gICAgICAgKiBBIGxvdy1sZXZlbCBzZWxlY3Rpb24gZnVuY3Rpb24gdGhhdCB3b3JrcyB3aXRoIFNpenpsZSdzIGNvbXBpbGVkXG4gICAgICAgKiAgc2VsZWN0b3IgZnVuY3Rpb25zXG4gICAgICAgKiBAcGFyYW0ge1N0cmluZ3xGdW5jdGlvbn0gc2VsZWN0b3IgQSBzZWxlY3RvciBvciBhIHByZS1jb21waWxlZFxuICAgICAgICogIHNlbGVjdG9yIGZ1bmN0aW9uIGJ1aWx0IHdpdGggU2l6emxlLmNvbXBpbGVcbiAgICAgICAqIEBwYXJhbSB7RWxlbWVudH0gY29udGV4dFxuICAgICAgICogQHBhcmFtIHtBcnJheX0gW3Jlc3VsdHNdXG4gICAgICAgKiBAcGFyYW0ge0FycmF5fSBbc2VlZF0gQSBzZXQgb2YgZWxlbWVudHMgdG8gbWF0Y2ggYWdhaW5zdFxuICAgICAgICovXG5cblxuICAgICAgc2VsZWN0ID0gU2l6emxlLnNlbGVjdCA9IGZ1bmN0aW9uIChzZWxlY3RvciwgY29udGV4dCwgcmVzdWx0cywgc2VlZCkge1xuICAgICAgICB2YXIgaSxcbiAgICAgICAgICAgIHRva2VucyxcbiAgICAgICAgICAgIHRva2VuLFxuICAgICAgICAgICAgdHlwZSxcbiAgICAgICAgICAgIGZpbmQsXG4gICAgICAgICAgICBjb21waWxlZCA9IHR5cGVvZiBzZWxlY3RvciA9PT0gXCJmdW5jdGlvblwiICYmIHNlbGVjdG9yLFxuICAgICAgICAgICAgbWF0Y2ggPSAhc2VlZCAmJiB0b2tlbml6ZShzZWxlY3RvciA9IGNvbXBpbGVkLnNlbGVjdG9yIHx8IHNlbGVjdG9yKTtcbiAgICAgICAgcmVzdWx0cyA9IHJlc3VsdHMgfHwgW107IC8vIFRyeSB0byBtaW5pbWl6ZSBvcGVyYXRpb25zIGlmIHRoZXJlIGlzIG9ubHkgb25lIHNlbGVjdG9yIGluIHRoZSBsaXN0IGFuZCBubyBzZWVkXG4gICAgICAgIC8vICh0aGUgbGF0dGVyIG9mIHdoaWNoIGd1YXJhbnRlZXMgdXMgY29udGV4dClcblxuICAgICAgICBpZiAobWF0Y2gubGVuZ3RoID09PSAxKSB7XG4gICAgICAgICAgLy8gUmVkdWNlIGNvbnRleHQgaWYgdGhlIGxlYWRpbmcgY29tcG91bmQgc2VsZWN0b3IgaXMgYW4gSURcbiAgICAgICAgICB0b2tlbnMgPSBtYXRjaFswXSA9IG1hdGNoWzBdLnNsaWNlKDApO1xuXG4gICAgICAgICAgaWYgKHRva2Vucy5sZW5ndGggPiAyICYmICh0b2tlbiA9IHRva2Vuc1swXSkudHlwZSA9PT0gXCJJRFwiICYmIGNvbnRleHQubm9kZVR5cGUgPT09IDkgJiYgZG9jdW1lbnRJc0hUTUwgJiYgRXhwci5yZWxhdGl2ZVt0b2tlbnNbMV0udHlwZV0pIHtcbiAgICAgICAgICAgIGNvbnRleHQgPSAoRXhwci5maW5kW1wiSURcIl0odG9rZW4ubWF0Y2hlc1swXS5yZXBsYWNlKHJ1bmVzY2FwZSwgZnVuZXNjYXBlKSwgY29udGV4dCkgfHwgW10pWzBdO1xuXG4gICAgICAgICAgICBpZiAoIWNvbnRleHQpIHtcbiAgICAgICAgICAgICAgcmV0dXJuIHJlc3VsdHM7IC8vIFByZWNvbXBpbGVkIG1hdGNoZXJzIHdpbGwgc3RpbGwgdmVyaWZ5IGFuY2VzdHJ5LCBzbyBzdGVwIHVwIGEgbGV2ZWxcbiAgICAgICAgICAgIH0gZWxzZSBpZiAoY29tcGlsZWQpIHtcbiAgICAgICAgICAgICAgY29udGV4dCA9IGNvbnRleHQucGFyZW50Tm9kZTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgc2VsZWN0b3IgPSBzZWxlY3Rvci5zbGljZSh0b2tlbnMuc2hpZnQoKS52YWx1ZS5sZW5ndGgpO1xuICAgICAgICAgIH0gLy8gRmV0Y2ggYSBzZWVkIHNldCBmb3IgcmlnaHQtdG8tbGVmdCBtYXRjaGluZ1xuXG5cbiAgICAgICAgICBpID0gbWF0Y2hFeHByW1wibmVlZHNDb250ZXh0XCJdLnRlc3Qoc2VsZWN0b3IpID8gMCA6IHRva2Vucy5sZW5ndGg7XG5cbiAgICAgICAgICB3aGlsZSAoaS0tKSB7XG4gICAgICAgICAgICB0b2tlbiA9IHRva2Vuc1tpXTsgLy8gQWJvcnQgaWYgd2UgaGl0IGEgY29tYmluYXRvclxuXG4gICAgICAgICAgICBpZiAoRXhwci5yZWxhdGl2ZVt0eXBlID0gdG9rZW4udHlwZV0pIHtcbiAgICAgICAgICAgICAgYnJlYWs7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIGlmIChmaW5kID0gRXhwci5maW5kW3R5cGVdKSB7XG4gICAgICAgICAgICAgIC8vIFNlYXJjaCwgZXhwYW5kaW5nIGNvbnRleHQgZm9yIGxlYWRpbmcgc2libGluZyBjb21iaW5hdG9yc1xuICAgICAgICAgICAgICBpZiAoc2VlZCA9IGZpbmQodG9rZW4ubWF0Y2hlc1swXS5yZXBsYWNlKHJ1bmVzY2FwZSwgZnVuZXNjYXBlKSwgcnNpYmxpbmcudGVzdCh0b2tlbnNbMF0udHlwZSkgJiYgdGVzdENvbnRleHQoY29udGV4dC5wYXJlbnROb2RlKSB8fCBjb250ZXh0KSkge1xuICAgICAgICAgICAgICAgIC8vIElmIHNlZWQgaXMgZW1wdHkgb3Igbm8gdG9rZW5zIHJlbWFpbiwgd2UgY2FuIHJldHVybiBlYXJseVxuICAgICAgICAgICAgICAgIHRva2Vucy5zcGxpY2UoaSwgMSk7XG4gICAgICAgICAgICAgICAgc2VsZWN0b3IgPSBzZWVkLmxlbmd0aCAmJiB0b1NlbGVjdG9yKHRva2Vucyk7XG5cbiAgICAgICAgICAgICAgICBpZiAoIXNlbGVjdG9yKSB7XG4gICAgICAgICAgICAgICAgICBwdXNoLmFwcGx5KHJlc3VsdHMsIHNlZWQpO1xuICAgICAgICAgICAgICAgICAgcmV0dXJuIHJlc3VsdHM7XG4gICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgYnJlYWs7XG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9XG4gICAgICAgIH0gLy8gQ29tcGlsZSBhbmQgZXhlY3V0ZSBhIGZpbHRlcmluZyBmdW5jdGlvbiBpZiBvbmUgaXMgbm90IHByb3ZpZGVkXG4gICAgICAgIC8vIFByb3ZpZGUgYG1hdGNoYCB0byBhdm9pZCByZXRva2VuaXphdGlvbiBpZiB3ZSBtb2RpZmllZCB0aGUgc2VsZWN0b3IgYWJvdmVcblxuXG4gICAgICAgIChjb21waWxlZCB8fCBjb21waWxlKHNlbGVjdG9yLCBtYXRjaCkpKHNlZWQsIGNvbnRleHQsICFkb2N1bWVudElzSFRNTCwgcmVzdWx0cywgIWNvbnRleHQgfHwgcnNpYmxpbmcudGVzdChzZWxlY3RvcikgJiYgdGVzdENvbnRleHQoY29udGV4dC5wYXJlbnROb2RlKSB8fCBjb250ZXh0KTtcbiAgICAgICAgcmV0dXJuIHJlc3VsdHM7XG4gICAgICB9OyAvLyBPbmUtdGltZSBhc3NpZ25tZW50c1xuICAgICAgLy8gU29ydCBzdGFiaWxpdHlcblxuXG4gICAgICBzdXBwb3J0LnNvcnRTdGFibGUgPSBleHBhbmRvLnNwbGl0KFwiXCIpLnNvcnQoc29ydE9yZGVyKS5qb2luKFwiXCIpID09PSBleHBhbmRvOyAvLyBTdXBwb3J0OiBDaHJvbWUgMTQtMzUrXG4gICAgICAvLyBBbHdheXMgYXNzdW1lIGR1cGxpY2F0ZXMgaWYgdGhleSBhcmVuJ3QgcGFzc2VkIHRvIHRoZSBjb21wYXJpc29uIGZ1bmN0aW9uXG5cbiAgICAgIHN1cHBvcnQuZGV0ZWN0RHVwbGljYXRlcyA9ICEhaGFzRHVwbGljYXRlOyAvLyBJbml0aWFsaXplIGFnYWluc3QgdGhlIGRlZmF1bHQgZG9jdW1lbnRcblxuICAgICAgc2V0RG9jdW1lbnQoKTsgLy8gU3VwcG9ydDogV2Via2l0PDUzNy4zMiAtIFNhZmFyaSA2LjAuMy9DaHJvbWUgMjUgKGZpeGVkIGluIENocm9tZSAyNylcbiAgICAgIC8vIERldGFjaGVkIG5vZGVzIGNvbmZvdW5kaW5nbHkgZm9sbG93ICplYWNoIG90aGVyKlxuXG4gICAgICBzdXBwb3J0LnNvcnREZXRhY2hlZCA9IGFzc2VydChmdW5jdGlvbiAoZWwpIHtcbiAgICAgICAgLy8gU2hvdWxkIHJldHVybiAxLCBidXQgcmV0dXJucyA0IChmb2xsb3dpbmcpXG4gICAgICAgIHJldHVybiBlbC5jb21wYXJlRG9jdW1lbnRQb3NpdGlvbihkb2N1bWVudC5jcmVhdGVFbGVtZW50KFwiZmllbGRzZXRcIikpICYgMTtcbiAgICAgIH0pOyAvLyBTdXBwb3J0OiBJRTw4XG4gICAgICAvLyBQcmV2ZW50IGF0dHJpYnV0ZS9wcm9wZXJ0eSBcImludGVycG9sYXRpb25cIlxuICAgICAgLy8gaHR0cHM6Ly9tc2RuLm1pY3Jvc29mdC5jb20vZW4tdXMvbGlicmFyeS9tczUzNjQyOSUyOFZTLjg1JTI5LmFzcHhcblxuICAgICAgaWYgKCFhc3NlcnQoZnVuY3Rpb24gKGVsKSB7XG4gICAgICAgIGVsLmlubmVySFRNTCA9IEFHUG9saWN5LmNyZWF0ZUhUTUwoXCI8YSBocmVmPScjJz48L2E+XCIpO1xuICAgICAgICByZXR1cm4gZWwuZmlyc3RDaGlsZC5nZXRBdHRyaWJ1dGUoXCJocmVmXCIpID09PSBcIiNcIjtcbiAgICAgIH0pKSB7XG4gICAgICAgIGFkZEhhbmRsZShcInR5cGV8aHJlZnxoZWlnaHR8d2lkdGhcIiwgZnVuY3Rpb24gKGVsZW0sIG5hbWUsIGlzWE1MKSB7XG4gICAgICAgICAgaWYgKCFpc1hNTCkge1xuICAgICAgICAgICAgcmV0dXJuIGVsZW0uZ2V0QXR0cmlidXRlKG5hbWUsIG5hbWUudG9Mb3dlckNhc2UoKSA9PT0gXCJ0eXBlXCIgPyAxIDogMik7XG4gICAgICAgICAgfVxuICAgICAgICB9KTtcbiAgICAgIH0gLy8gU3VwcG9ydDogSUU8OVxuICAgICAgLy8gVXNlIGRlZmF1bHRWYWx1ZSBpbiBwbGFjZSBvZiBnZXRBdHRyaWJ1dGUoXCJ2YWx1ZVwiKVxuXG5cbiAgICAgIGlmICghc3VwcG9ydC5hdHRyaWJ1dGVzIHx8ICFhc3NlcnQoZnVuY3Rpb24gKGVsKSB7XG4gICAgICAgIGVsLmlubmVySFRNTCA9IEFHUG9saWN5LmNyZWF0ZUhUTUwoXCI8aW5wdXQvPlwiKTtcbiAgICAgICAgZWwuZmlyc3RDaGlsZC5zZXRBdHRyaWJ1dGUoXCJ2YWx1ZVwiLCBcIlwiKTtcbiAgICAgICAgcmV0dXJuIGVsLmZpcnN0Q2hpbGQuZ2V0QXR0cmlidXRlKFwidmFsdWVcIikgPT09IFwiXCI7XG4gICAgICB9KSkge1xuICAgICAgICBhZGRIYW5kbGUoXCJ2YWx1ZVwiLCBmdW5jdGlvbiAoZWxlbSwgbmFtZSwgaXNYTUwpIHtcbiAgICAgICAgICBpZiAoIWlzWE1MICYmIGVsZW0ubm9kZU5hbWUudG9Mb3dlckNhc2UoKSA9PT0gXCJpbnB1dFwiKSB7XG4gICAgICAgICAgICByZXR1cm4gZWxlbS5kZWZhdWx0VmFsdWU7XG4gICAgICAgICAgfVxuICAgICAgICB9KTtcbiAgICAgIH0gLy8gU3VwcG9ydDogSUU8OVxuICAgICAgLy8gVXNlIGdldEF0dHJpYnV0ZU5vZGUgdG8gZmV0Y2ggYm9vbGVhbnMgd2hlbiBnZXRBdHRyaWJ1dGUgbGllc1xuXG5cbiAgICAgIGlmICghYXNzZXJ0KGZ1bmN0aW9uIChlbCkge1xuICAgICAgICByZXR1cm4gZWwuZ2V0QXR0cmlidXRlKFwiZGlzYWJsZWRcIikgPT0gbnVsbDtcbiAgICAgIH0pKSB7XG4gICAgICAgIGFkZEhhbmRsZShib29sZWFucywgZnVuY3Rpb24gKGVsZW0sIG5hbWUsIGlzWE1MKSB7XG4gICAgICAgICAgdmFyIHZhbDtcblxuICAgICAgICAgIGlmICghaXNYTUwpIHtcbiAgICAgICAgICAgIHJldHVybiBlbGVtW25hbWVdID09PSB0cnVlID8gbmFtZS50b0xvd2VyQ2FzZSgpIDogKHZhbCA9IGVsZW0uZ2V0QXR0cmlidXRlTm9kZShuYW1lKSkgJiYgdmFsLnNwZWNpZmllZCA/IHZhbC52YWx1ZSA6IG51bGw7XG4gICAgICAgICAgfVxuICAgICAgICB9KTtcbiAgICAgIH0gLy8gRVhQT1NFXG4gICAgICAvLyBEbyBub3QgZXhwb3NlIFNpenpsZSB0byB0aGUgZ2xvYmFsIHNjb3BlIGluIHRoZSBjYXNlIG9mIEFkR3VhcmQgRXh0ZW5kZWRDc3MgYnVpbGRcblxuXG4gICAgICByZXR1cm4gU2l6emxlOyAvLyBFWFBPU0VcbiAgICB9KHdpbmRvdyk7IC8vPj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+XG5cbiAgfVxuXG4gIHJldHVybiBTaXp6bGU7XG59O1xuXG4vKiBqc2hpbnQgaWdub3JlOmVuZCAqL1xuXG4vKipcbiAqIENvcHlyaWdodCAyMDE2IEFkZ3VhcmQgU29mdHdhcmUgTHRkXG4gKlxuICogTGljZW5zZWQgdW5kZXIgdGhlIEFwYWNoZSBMaWNlbnNlLCBWZXJzaW9uIDIuMCAodGhlIFwiTGljZW5zZVwiKTtcbiAqIHlvdSBtYXkgbm90IHVzZSB0aGlzIGZpbGUgZXhjZXB0IGluIGNvbXBsaWFuY2Ugd2l0aCB0aGUgTGljZW5zZS5cbiAqIFlvdSBtYXkgb2J0YWluIGEgY29weSBvZiB0aGUgTGljZW5zZSBhdFxuICpcbiAqIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMFxuICpcbiAqIFVubGVzcyByZXF1aXJlZCBieSBhcHBsaWNhYmxlIGxhdyBvciBhZ3JlZWQgdG8gaW4gd3JpdGluZywgc29mdHdhcmVcbiAqIGRpc3RyaWJ1dGVkIHVuZGVyIHRoZSBMaWNlbnNlIGlzIGRpc3RyaWJ1dGVkIG9uIGFuIFwiQVMgSVNcIiBCQVNJUyxcbiAqIFdJVEhPVVQgV0FSUkFOVElFUyBPUiBDT05ESVRJT05TIE9GIEFOWSBLSU5ELCBlaXRoZXIgZXhwcmVzcyBvciBpbXBsaWVkLlxuICogU2VlIHRoZSBMaWNlbnNlIGZvciB0aGUgc3BlY2lmaWMgbGFuZ3VhZ2UgZ292ZXJuaW5nIHBlcm1pc3Npb25zIGFuZFxuICogbGltaXRhdGlvbnMgdW5kZXIgdGhlIExpY2Vuc2UuXG4gKi9cbi8qKlxuICogQ2xhc3MgdGhhdCBleHRlbmRzIFNpenpsZSBhbmQgYWRkcyBzdXBwb3J0IGZvciBcIm1hdGNoZXMtY3NzXCIgcHNldWRvIGVsZW1lbnQuXG4gKi9cblxudmFyIFN0eWxlUHJvcGVydHlNYXRjaGVyID0gZnVuY3Rpb24gKHdpbmRvdykge1xuICB2YXIgaXNQaGFudG9tID0gISF3aW5kb3cuX3BoYW50b207XG4gIHZhciB1c2VGYWxsYmFjayA9IGlzUGhhbnRvbSAmJiAhIXdpbmRvdy5nZXRNYXRjaGVkQ1NTUnVsZXM7XG4gIC8qKlxuICAgKiBVbnF1b3RlcyBzcGVjaWZpZWQgdmFsdWVcbiAgICogV2Via2l0LWJhc2VkIGJyb3dzZXJzIHNpbmdsZXF1b3RlcyA8c3RyaW5nPiBjb250ZW50IHByb3BlcnR5IHZhbHVlc1xuICAgKiBPdGhlciBicm93c2VycyBkb3VibGVxdW90ZXMgY29udGVudCBwcm9wZXJ0eSB2YWx1ZXMuXG4gICAqL1xuXG4gIHZhciByZW1vdmVDb250ZW50UXVvdGVzID0gZnVuY3Rpb24gcmVtb3ZlQ29udGVudFF1b3Rlcyh2YWx1ZSkge1xuICAgIGlmICh0eXBlb2YgdmFsdWUgPT09ICdzdHJpbmcnKSB7XG4gICAgICByZXR1cm4gdmFsdWUucmVwbGFjZSgvXihbXCInXSkoW1xcc1xcU10qKVxcMSQvLCAnJDInKTtcbiAgICB9XG5cbiAgICByZXR1cm4gdmFsdWU7XG4gIH07XG5cbiAgdmFyIGdldENvbXB1dGVkU3R5bGUgPSB3aW5kb3cuZ2V0Q29tcHV0ZWRTdHlsZS5iaW5kKHdpbmRvdyk7XG4gIHZhciBnZXRNYXRjaGVkQ1NTUnVsZXMgPSB1c2VGYWxsYmFjayA/IHdpbmRvdy5nZXRNYXRjaGVkQ1NTUnVsZXMuYmluZCh3aW5kb3cpIDogbnVsbDtcbiAgLyoqXG4gICAqIFRoZXJlIGlzIGFuIGlzc3VlIGluIGJyb3dzZXJzIGJhc2VkIG9uIG9sZCB3ZWJraXQ6XG4gICAqIGdldENvbXB1dGVkU3R5bGUoZWwsIFwiOmJlZm9yZVwiKSBpcyBlbXB0eSBpZiBlbGVtZW50IGlzIG5vdCB2aXNpYmxlLlxuICAgKlxuICAgKiBUbyBjaXJjdW12ZW50IHRoaXMgaXNzdWUgd2UgdXNlIGdldE1hdGNoZWRDU1NSdWxlcyBpbnN0ZWFkLlxuICAgKlxuICAgKiBJdCBhcHBlYXJzIHRoYXQgZ2V0TWF0Y2hlZENTU1J1bGVzIHNvcnRzIHRoZSBDU1MgcnVsZXNcbiAgICogaW4gaW5jcmVhc2luZyBvcmRlciBvZiBzcGVjaWZpdGllcyBvZiBjb3JyZXNwb25kaW5nIHNlbGVjdG9ycy5cbiAgICogV2UgcGljayB0aGUgY3NzIHJ1bGUgdGhhdCBpcyBiZWluZyBhcHBsaWVkIHRvIGFuIGVsZW1lbnQgYmFzZWQgb24gdGhpcyBhc3N1bXB0aW9uLlxuICAgKlxuICAgKiBAcGFyYW0gZWxlbWVudCAgICAgICBET00gbm9kZVxuICAgKiBAcGFyYW0gcHNldWRvRWxlbWVudCBPcHRpb25hbCBwc2V1ZG9FbGVtZW50IG5hbWVcbiAgICogQHBhcmFtIHByb3BlcnR5TmFtZSAgQ1NTIHByb3BlcnR5IG5hbWVcbiAgICovXG5cbiAgdmFyIGdldENvbXB1dGVkU3R5bGVQcm9wZXJ0eVZhbHVlID0gZnVuY3Rpb24gZ2V0Q29tcHV0ZWRTdHlsZVByb3BlcnR5VmFsdWUoZWxlbWVudCwgcHNldWRvRWxlbWVudCwgcHJvcGVydHlOYW1lKSB7XG4gICAgdmFyIHZhbHVlID0gJyc7XG5cbiAgICBpZiAodXNlRmFsbGJhY2sgJiYgcHNldWRvRWxlbWVudCkge1xuICAgICAgdmFyIGNzc1J1bGVzID0gZ2V0TWF0Y2hlZENTU1J1bGVzKGVsZW1lbnQsIHBzZXVkb0VsZW1lbnQpIHx8IFtdO1xuICAgICAgdmFyIGkgPSBjc3NSdWxlcy5sZW5ndGg7XG5cbiAgICAgIHdoaWxlIChpLS0gPiAwICYmICF2YWx1ZSkge1xuICAgICAgICB2YWx1ZSA9IGNzc1J1bGVzW2ldLnN0eWxlLmdldFByb3BlcnR5VmFsdWUocHJvcGVydHlOYW1lKTtcbiAgICAgIH1cbiAgICB9IGVsc2Uge1xuICAgICAgdmFyIHN0eWxlID0gZ2V0Q29tcHV0ZWRTdHlsZShlbGVtZW50LCBwc2V1ZG9FbGVtZW50KTtcblxuICAgICAgaWYgKHN0eWxlKSB7XG4gICAgICAgIHZhbHVlID0gc3R5bGUuZ2V0UHJvcGVydHlWYWx1ZShwcm9wZXJ0eU5hbWUpOyAvLyBodHRwczovL2J1Z3Mud2Via2l0Lm9yZy9zaG93X2J1Zy5jZ2k/aWQ9OTM0NDVcblxuICAgICAgICBpZiAocHJvcGVydHlOYW1lID09PSAnb3BhY2l0eScgJiYgdXRpbHMuaXNTYWZhcmlCcm93c2VyKSB7XG4gICAgICAgICAgdmFsdWUgPSAoTWF0aC5yb3VuZChwYXJzZUZsb2F0KHZhbHVlKSAqIDEwMCkgLyAxMDApLnRvU3RyaW5nKCk7XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICB9XG5cbiAgICBpZiAocHJvcGVydHlOYW1lID09PSAnY29udGVudCcpIHtcbiAgICAgIHZhbHVlID0gcmVtb3ZlQ29udGVudFF1b3Rlcyh2YWx1ZSk7XG4gICAgfVxuXG4gICAgcmV0dXJuIHZhbHVlO1xuICB9O1xuICAvKipcbiAgICogQWRkcyB1cmwgcGFyYW1ldGVyIHF1b3RlcyBmb3Igbm9uLXJlZ2V4IHBhdHRlcm5cbiAgICogQHBhcmFtIHtzdHJpbmd9IHBhdHRlcm5cbiAgICovXG5cblxuICB2YXIgYWRkVXJsUXVvdGVzID0gZnVuY3Rpb24gYWRkVXJsUXVvdGVzKHBhdHRlcm4pIHtcbiAgICAvLyBmb3IgcmVnZXggcGF0dGVybnNcbiAgICBpZiAocGF0dGVyblswXSA9PT0gJy8nICYmIHBhdHRlcm5bcGF0dGVybi5sZW5ndGggLSAxXSA9PT0gJy8nICYmIHBhdHRlcm4uaW5kZXhPZignXFxcXFwiJykgPCAxMCkge1xuICAgICAgLy8gZS5nLiAvXnVybFxcXFwoW2Etel17NH06W2Etel17NX0vXG4gICAgICAvLyBvciAvXnVybFxcXFwoZGF0YVxcXFw6XFxcXGltYWdlXFxcXC9naWY7YmFzZTY0LisvXG4gICAgICB2YXIgcmUgPSAvKFxcXik/dXJsKFxcXFwpP1xcXFxcXCgoXFx3fFxcW1xcdykvZztcbiAgICAgIHJldHVybiBwYXR0ZXJuLnJlcGxhY2UocmUsICckMXVybCQyXFxcXFxcKFxcXFxcIj8kMycpO1xuICAgIH0gLy8gZm9yIG5vbi1yZWdleCBwYXR0ZXJuc1xuXG5cbiAgICBpZiAocGF0dGVybi5pbmRleE9mKCd1cmwoXCInKSA9PT0gLTEpIHtcbiAgICAgIHZhciBfcmUgPSAvdXJsXFwoKC4qPylcXCkvZztcbiAgICAgIHJldHVybiBwYXR0ZXJuLnJlcGxhY2UoX3JlLCAndXJsKFwiJDFcIiknKTtcbiAgICB9XG5cbiAgICByZXR1cm4gcGF0dGVybjtcbiAgfTtcbiAgLyoqXG4gICAqIENsYXNzIHRoYXQgbWF0Y2hlcyBlbGVtZW50IHN0eWxlIGFnYWluc3QgdGhlIHNwZWNpZmllZCBleHByZXNzaW9uXG4gICAqIEBtZW1iZXIge3N0cmluZ30gcHJvcGVydHlOYW1lXG4gICAqIEBtZW1iZXIge3N0cmluZ30gcHNldWRvRWxlbWVudFxuICAgKiBAbWVtYmVyIHtSZWdFeHB9IHJlZ2V4XG4gICAqL1xuXG5cbiAgdmFyIE1hdGNoZXIgPSBmdW5jdGlvbiBNYXRjaGVyKHByb3BlcnR5RmlsdGVyLCBwc2V1ZG9FbGVtZW50KSB7XG4gICAgdGhpcy5wc2V1ZG9FbGVtZW50ID0gcHNldWRvRWxlbWVudDtcblxuICAgIHRyeSB7XG4gICAgICB2YXIgaW5kZXggPSBwcm9wZXJ0eUZpbHRlci5pbmRleE9mKCc6Jyk7XG4gICAgICB0aGlzLnByb3BlcnR5TmFtZSA9IHByb3BlcnR5RmlsdGVyLnN1YnN0cmluZygwLCBpbmRleCkudHJpbSgpO1xuICAgICAgdmFyIHBhdHRlcm4gPSBwcm9wZXJ0eUZpbHRlci5zdWJzdHJpbmcoaW5kZXggKyAxKS50cmltKCk7XG4gICAgICBwYXR0ZXJuID0gYWRkVXJsUXVvdGVzKHBhdHRlcm4pOyAvLyBVbmVzY2FwaW5nIHBhdHRlcm5cbiAgICAgIC8vIEZvciBub24tcmVnZXggcGF0dGVybnMsICgsKSxbLF0gc2hvdWxkIGJlIHVuZXNjYXBlZCwgYmVjYXVzZSB3ZSByZXF1aXJlIGVzY2FwaW5nIHRoZW0gaW4gZmlsdGVyIHJ1bGVzLlxuICAgICAgLy8gRm9yIHJlZ2V4IHBhdHRlcm5zLCBcIixcXCBzaG91bGQgYmUgZXNjYXBlZCwgYmVjYXVzZSB3ZSBtYW51YWxseSBlc2NhcGUgdGhvc2UgaW4gZXh0ZW5kZWQtY3NzLXNlbGVjdG9yLmpzLlxuXG4gICAgICBpZiAoL15cXC8uKlxcLyQvLnRlc3QocGF0dGVybikpIHtcbiAgICAgICAgcGF0dGVybiA9IHBhdHRlcm4uc2xpY2UoMSwgLTEpO1xuICAgICAgICB0aGlzLnJlZ2V4ID0gdXRpbHMucHNldWRvQXJnVG9SZWdleChwYXR0ZXJuKTtcbiAgICAgIH0gZWxzZSB7XG4gICAgICAgIHBhdHRlcm4gPSBwYXR0ZXJuLnJlcGxhY2UoL1xcXFwoW1xcXFwoKVtcXF1cIl0pL2csICckMScpO1xuICAgICAgICB0aGlzLnJlZ2V4ID0gdXRpbHMuY3JlYXRlVVJMUmVnZXgocGF0dGVybik7XG4gICAgICB9XG4gICAgfSBjYXRjaCAoZXgpIHtcbiAgICAgIHV0aWxzLmxvZ0Vycm9yKFwiU3R5bGVQcm9wZXJ0eU1hdGNoZXI6IGludmFsaWQgbWF0Y2ggc3RyaW5nIFwiLmNvbmNhdChwcm9wZXJ0eUZpbHRlcikpO1xuICAgIH1cbiAgfTtcbiAgLyoqXG4gICAqIEZ1bmN0aW9uIHRvIGNoZWNrIGlmIGVsZW1lbnQgQ1NTIHByb3BlcnR5IG1hdGNoZXMgZmlsdGVyIHBhdHRlcm5cbiAgICogQHBhcmFtIHtFbGVtZW50fSBlbGVtZW50IHRvIGNoZWNrXG4gICAqL1xuXG5cbiAgTWF0Y2hlci5wcm90b3R5cGUubWF0Y2hlcyA9IGZ1bmN0aW9uIChlbGVtZW50KSB7XG4gICAgaWYgKCF0aGlzLnJlZ2V4IHx8ICF0aGlzLnByb3BlcnR5TmFtZSkge1xuICAgICAgcmV0dXJuIGZhbHNlO1xuICAgIH1cblxuICAgIHZhciB2YWx1ZSA9IGdldENvbXB1dGVkU3R5bGVQcm9wZXJ0eVZhbHVlKGVsZW1lbnQsIHRoaXMucHNldWRvRWxlbWVudCwgdGhpcy5wcm9wZXJ0eU5hbWUpO1xuICAgIHJldHVybiB2YWx1ZSAmJiB0aGlzLnJlZ2V4LnRlc3QodmFsdWUpO1xuICB9O1xuICAvKipcbiAgICogQ3JlYXRlcyBhIG5ldyBwc2V1ZG8tY2xhc3MgYW5kIHJlZ2lzdGVycyBpdCBpbiBTaXp6bGVcbiAgICovXG5cblxuICB2YXIgZXh0ZW5kU2l6emxlID0gZnVuY3Rpb24gZXh0ZW5kU2l6emxlKHNpenpsZSkge1xuICAgIC8vIEZpcnN0IG9mIGFsbCB3ZSBzaG91bGQgcHJlcGFyZSBTaXp6bGUgZW5naW5lXG4gICAgc2l6emxlLnNlbGVjdG9ycy5wc2V1ZG9zWydtYXRjaGVzLWNzcyddID0gc2l6emxlLnNlbGVjdG9ycy5jcmVhdGVQc2V1ZG8oZnVuY3Rpb24gKHByb3BlcnR5RmlsdGVyKSB7XG4gICAgICB2YXIgbWF0Y2hlciA9IG5ldyBNYXRjaGVyKHByb3BlcnR5RmlsdGVyKTtcbiAgICAgIHJldHVybiBmdW5jdGlvbiAoZWxlbWVudCkge1xuICAgICAgICByZXR1cm4gbWF0Y2hlci5tYXRjaGVzKGVsZW1lbnQpO1xuICAgICAgfTtcbiAgICB9KTtcbiAgICBzaXp6bGUuc2VsZWN0b3JzLnBzZXVkb3NbJ21hdGNoZXMtY3NzLWJlZm9yZSddID0gc2l6emxlLnNlbGVjdG9ycy5jcmVhdGVQc2V1ZG8oZnVuY3Rpb24gKHByb3BlcnR5RmlsdGVyKSB7XG4gICAgICB2YXIgbWF0Y2hlciA9IG5ldyBNYXRjaGVyKHByb3BlcnR5RmlsdGVyLCAnOmJlZm9yZScpO1xuICAgICAgcmV0dXJuIGZ1bmN0aW9uIChlbGVtZW50KSB7XG4gICAgICAgIHJldHVybiBtYXRjaGVyLm1hdGNoZXMoZWxlbWVudCk7XG4gICAgICB9O1xuICAgIH0pO1xuICAgIHNpenpsZS5zZWxlY3RvcnMucHNldWRvc1snbWF0Y2hlcy1jc3MtYWZ0ZXInXSA9IHNpenpsZS5zZWxlY3RvcnMuY3JlYXRlUHNldWRvKGZ1bmN0aW9uIChwcm9wZXJ0eUZpbHRlcikge1xuICAgICAgdmFyIG1hdGNoZXIgPSBuZXcgTWF0Y2hlcihwcm9wZXJ0eUZpbHRlciwgJzphZnRlcicpO1xuICAgICAgcmV0dXJuIGZ1bmN0aW9uIChlbGVtZW50KSB7XG4gICAgICAgIHJldHVybiBtYXRjaGVyLm1hdGNoZXMoZWxlbWVudCk7XG4gICAgICB9O1xuICAgIH0pO1xuICB9OyAvLyBFWFBPU0VcblxuXG4gIHJldHVybiB7XG4gICAgZXh0ZW5kU2l6emxlOiBleHRlbmRTaXp6bGVcbiAgfTtcbn0od2luZG93KTtcblxuLyoqXG4gKiBDb3B5cmlnaHQgMjAxNiBBZGd1YXJkIFNvZnR3YXJlIEx0ZFxuICpcbiAqIExpY2Vuc2VkIHVuZGVyIHRoZSBBcGFjaGUgTGljZW5zZSwgVmVyc2lvbiAyLjAgKHRoZSBcIkxpY2Vuc2VcIik7XG4gKiB5b3UgbWF5IG5vdCB1c2UgdGhpcyBmaWxlIGV4Y2VwdCBpbiBjb21wbGlhbmNlIHdpdGggdGhlIExpY2Vuc2UuXG4gKiBZb3UgbWF5IG9idGFpbiBhIGNvcHkgb2YgdGhlIExpY2Vuc2UgYXRcbiAqXG4gKiBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElDRU5TRS0yLjBcbiAqXG4gKiBVbmxlc3MgcmVxdWlyZWQgYnkgYXBwbGljYWJsZSBsYXcgb3IgYWdyZWVkIHRvIGluIHdyaXRpbmcsIHNvZnR3YXJlXG4gKiBkaXN0cmlidXRlZCB1bmRlciB0aGUgTGljZW5zZSBpcyBkaXN0cmlidXRlZCBvbiBhbiBcIkFTIElTXCIgQkFTSVMsXG4gKiBXSVRIT1VUIFdBUlJBTlRJRVMgT1IgQ09ORElUSU9OUyBPRiBBTlkgS0lORCwgZWl0aGVyIGV4cHJlc3Mgb3IgaW1wbGllZC5cbiAqIFNlZSB0aGUgTGljZW5zZSBmb3IgdGhlIHNwZWNpZmljIGxhbmd1YWdlIGdvdmVybmluZyBwZXJtaXNzaW9ucyBhbmRcbiAqIGxpbWl0YXRpb25zIHVuZGVyIHRoZSBMaWNlbnNlLlxuICovXG52YXIgbWF0Y2hlclV0aWxzID0ge307XG5tYXRjaGVyVXRpbHMuTXV0YXRpb25PYnNlcnZlciA9IHdpbmRvdy5NdXRhdGlvbk9ic2VydmVyIHx8IHdpbmRvdy5XZWJLaXRNdXRhdGlvbk9ic2VydmVyO1xuLyoqXG4gKiBQYXJzZXMgYXJndW1lbnQgb2YgbWF0Y2hlciBwc2V1ZG8gKGZvciBtYXRjaGVzLWF0dHIgYW5kIG1hdGNoZXMtcHJvcGVydHkpXG4gKiBAcGFyYW0ge3N0cmluZ30gbWF0Y2hlckZpbHRlciBhcmd1bWVudCBvZiBwc2V1ZG8gY2xhc3NcbiAqIEByZXR1cm5zIHtBcnJheX1cbiAqL1xuXG5tYXRjaGVyVXRpbHMucGFyc2VNYXRjaGVyRmlsdGVyID0gZnVuY3Rpb24gKG1hdGNoZXJGaWx0ZXIpIHtcbiAgdmFyIEZVTExfTUFUQ0hfTUFSS0VSID0gJ1wiPVwiJztcbiAgdmFyIHJhd0FyZ3MgPSBbXTtcblxuICBpZiAobWF0Y2hlckZpbHRlci5pbmRleE9mKEZVTExfTUFUQ0hfTUFSS0VSKSA9PT0gLTEpIHtcbiAgICAvLyBpZiB0aGVyZSBpcyBvbmx5IG9uZSBwc2V1ZG8gYXJnXG4gICAgLy8gZS5nLiA6bWF0Y2hlcy1hdHRyKFwiZGF0YS1uYW1lXCIpIG9yIDptYXRjaGVzLXByb3BlcnR5KFwiaW5uZXIucHJvcFwiKVxuICAgIC8vIFNpenpsZSB3aWxsIHBhcnNlIGl0IGFuZCBnZXQgcmlkIG9mIHF1b3Rlc1xuICAgIC8vIHNvIGl0IG1pZ2h0IGJlIHZhbGlkIGFyZyBhbHJlYWR5IHdpdGhvdXQgdGhlbVxuICAgIHJhd0FyZ3MucHVzaChtYXRjaGVyRmlsdGVyKTtcbiAgfSBlbHNlIHtcbiAgICBtYXRjaGVyRmlsdGVyLnNwbGl0KCc9JykuZm9yRWFjaChmdW5jdGlvbiAoYXJnKSB7XG4gICAgICBpZiAoYXJnWzBdID09PSAnXCInICYmIGFyZ1thcmcubGVuZ3RoIC0gMV0gPT09ICdcIicpIHtcbiAgICAgICAgcmF3QXJncy5wdXNoKGFyZy5zbGljZSgxLCAtMSkpO1xuICAgICAgfVxuICAgIH0pO1xuICB9XG5cbiAgcmV0dXJuIHJhd0FyZ3M7XG59O1xuLyoqXG4gKiBAdHlwZWRlZiB7T2JqZWN0fSBBcmdEYXRhXG4gKiBAcHJvcGVydHkge3N0cmluZ30gYXJnXG4gKiBAcHJvcGVydHkge2Jvb2xlYW59IGlzUmVnZXhwXG4gKi9cblxuLyoqXG4gKiBQYXJzZXMgcmF3IG1hdGNoZXIgYXJnXG4gKiBAcGFyYW0ge3N0cmluZ30gcmF3QXJnXG4gKiBAcmV0dXJucyB7QXJnRGF0YX1cbiAqL1xuXG5cbm1hdGNoZXJVdGlscy5wYXJzZVJhd01hdGNoZXJBcmcgPSBmdW5jdGlvbiAocmF3QXJnKSB7XG4gIHZhciBhcmcgPSByYXdBcmc7XG4gIHZhciBpc1JlZ2V4cCA9ICEhcmF3QXJnICYmIHJhd0FyZ1swXSA9PT0gJy8nICYmIHJhd0FyZ1tyYXdBcmcubGVuZ3RoIC0gMV0gPT09ICcvJztcblxuICBpZiAoaXNSZWdleHApIHtcbiAgICAvLyB0byBhdm9pZCBhdCBsZWFzdCBzdWNoIGNhc2Ug4oCUIDptYXRjaGVzLXByb3BlcnR5KFwiLy9cIilcbiAgICBpZiAocmF3QXJnLmxlbmd0aCA+IDIpIHtcbiAgICAgIGFyZyA9IHV0aWxzLnRvUmVnRXhwKHJhd0FyZyk7XG4gICAgfSBlbHNlIHtcbiAgICAgIHRocm93IG5ldyBFcnJvcihcIkludmFsaWQgcmVnZXhwOiBcIi5jb25jYXQocmF3QXJnKSk7XG4gICAgfVxuICB9XG5cbiAgcmV0dXJuIHtcbiAgICBhcmc6IGFyZyxcbiAgICBpc1JlZ2V4cDogaXNSZWdleHBcbiAgfTtcbn07XG4vKipcbiAqIEB0eXBlZGVmIENoYWluXG4gKiBAcHJvcGVydHkge09iamVjdH0gYmFzZVxuICogQHByb3BlcnR5IHtzdHJpbmd9IHByb3BcbiAqIEBwcm9wZXJ0eSB7c3RyaW5nfSB2YWx1ZVxuICovXG5cbi8qKlxuICogQ2hlY2tzIGlmIHRoZSBwcm9wZXJ0eSBleGlzdHMgaW4gdGhlIGJhc2Ugb2JqZWN0IChyZWN1cnNpdmVseSkuXG4gKiBAcGFyYW0ge09iamVjdH0gYmFzZVxuICogQHBhcmFtIHtBcmdEYXRhW119IGNoYWluIGFycmF5IG9mIG9iamVjdHMgLSBwYXJzZWQgc3RyaW5nIHByb3BlcnR5IGNoYWluXG4gKiBAcGFyYW0ge0FycmF5fSBbb3V0cHV0PVtdXSByZXN1bHQgYWNjXG4gKiBAcmV0dXJucyB7Q2hhaW5bXX0gYXJyYXkgb2Ygb2JqZWN0c1xuICovXG5cblxubWF0Y2hlclV0aWxzLmZpbHRlclJvb3RzQnlSZWdleHBDaGFpbiA9IGZ1bmN0aW9uIChiYXNlLCBjaGFpbikge1xuICB2YXIgb3V0cHV0ID0gYXJndW1lbnRzLmxlbmd0aCA+IDIgJiYgYXJndW1lbnRzWzJdICE9PSB1bmRlZmluZWQgPyBhcmd1bWVudHNbMl0gOiBbXTtcbiAgdmFyIHRlbXBQcm9wID0gY2hhaW5bMF07XG5cbiAgaWYgKGNoYWluLmxlbmd0aCA9PT0gMSkge1xuICAgIC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBuby1yZXN0cmljdGVkLXN5bnRheFxuICAgIGZvciAodmFyIGtleSBpbiBiYXNlKSB7XG4gICAgICBpZiAodGVtcFByb3AuaXNSZWdleHApIHtcbiAgICAgICAgaWYgKHRlbXBQcm9wLmFyZy50ZXN0KGtleSkpIHtcbiAgICAgICAgICBvdXRwdXQucHVzaCh7XG4gICAgICAgICAgICBiYXNlOiBiYXNlLFxuICAgICAgICAgICAgcHJvcDoga2V5LFxuICAgICAgICAgICAgdmFsdWU6IGJhc2Vba2V5XVxuICAgICAgICAgIH0pO1xuICAgICAgICB9XG4gICAgICB9IGVsc2UgaWYgKHRlbXBQcm9wLmFyZyA9PT0ga2V5KSB7XG4gICAgICAgIG91dHB1dC5wdXNoKHtcbiAgICAgICAgICBiYXNlOiBiYXNlLFxuICAgICAgICAgIHByb3A6IHRlbXBQcm9wLmFyZyxcbiAgICAgICAgICB2YWx1ZTogYmFzZVtrZXldXG4gICAgICAgIH0pO1xuICAgICAgfVxuICAgIH1cblxuICAgIHJldHVybiBvdXRwdXQ7XG4gIH0gLy8gaWYgdGhlcmUgaXMgYSByZWdleHAgcHJvcCBpbiBpbnB1dCBjaGFpblxuICAvLyBlLmcuICd1bml0Li9eYWQuKy8uc3JjJyBmb3IgJ3VuaXQuYWQtMWdmMi5zcmMgdW5pdC5hZC1mZ2QzNC5zcmMnKSxcbiAgLy8gZXZlcnkgYmFzZSBrZXlzIHNob3VsZCBiZSB0ZXN0ZWQgYnkgcmVnZXhwIGFuZCBpdCBjYW4gYmUgbW9yZSB0aGF0IG9uZSByZXN1bHRzXG5cblxuICBpZiAodGVtcFByb3AuaXNSZWdleHApIHtcbiAgICB2YXIgbmV4dFByb3AgPSBjaGFpbi5zbGljZSgxKTtcbiAgICB2YXIgYmFzZUtleXMgPSBbXTsgLy8gZXNsaW50LWRpc2FibGUtbmV4dC1saW5lIG5vLXJlc3RyaWN0ZWQtc3ludGF4XG5cbiAgICBmb3IgKHZhciBfa2V5IGluIGJhc2UpIHtcbiAgICAgIGlmICh0ZW1wUHJvcC5hcmcudGVzdChfa2V5KSkge1xuICAgICAgICBiYXNlS2V5cy5wdXNoKF9rZXkpO1xuICAgICAgfVxuICAgIH1cblxuICAgIGJhc2VLZXlzLmZvckVhY2goZnVuY3Rpb24gKGtleSkge1xuICAgICAgdmFyIGl0ZW0gPSBiYXNlW2tleV07XG4gICAgICBtYXRjaGVyVXRpbHMuZmlsdGVyUm9vdHNCeVJlZ2V4cENoYWluKGl0ZW0sIG5leHRQcm9wLCBvdXRwdXQpO1xuICAgIH0pO1xuICB9IC8vIGF2b2lkIFR5cGVFcnJvciB3aGlsZSBhY2Nlc3NpbmcgdG8gbnVsbC1wcm9wJ3MgY2hpbGRcblxuXG4gIGlmIChiYXNlID09PSBudWxsKSB7XG4gICAgcmV0dXJuO1xuICB9XG5cbiAgdmFyIG5leHRCYXNlID0gYmFzZVt0ZW1wUHJvcC5hcmddO1xuICBjaGFpbiA9IGNoYWluLnNsaWNlKDEpO1xuXG4gIGlmIChuZXh0QmFzZSAhPT0gdW5kZWZpbmVkKSB7XG4gICAgbWF0Y2hlclV0aWxzLmZpbHRlclJvb3RzQnlSZWdleHBDaGFpbihuZXh0QmFzZSwgY2hhaW4sIG91dHB1dCk7XG4gIH1cblxuICByZXR1cm4gb3V0cHV0O1xufTtcbi8qKlxuICogVmFsaWRhdGVzIHBhcnNlZCBhcmdzIG9mIG1hdGNoZXMtcHJvcGVydHkgcHNldWRvXG4gKiBAcGFyYW0gey4uLkFyZ0RhdGF9IGFyZ3NcbiAqL1xuXG5cbm1hdGNoZXJVdGlscy52YWxpZGF0ZVByb3BNYXRjaGVyQXJncyA9IGZ1bmN0aW9uICgpIHtcbiAgZm9yICh2YXIgX2xlbiA9IGFyZ3VtZW50cy5sZW5ndGgsIGFyZ3MgPSBuZXcgQXJyYXkoX2xlbiksIF9rZXkyID0gMDsgX2tleTIgPCBfbGVuOyBfa2V5MisrKSB7XG4gICAgYXJnc1tfa2V5Ml0gPSBhcmd1bWVudHNbX2tleTJdO1xuICB9XG5cbiAgZm9yICh2YXIgaSA9IDA7IGkgPCBhcmdzLmxlbmd0aDsgaSArPSAxKSB7XG4gICAgaWYgKGFyZ3NbaV0uaXNSZWdleHApIHtcbiAgICAgIGlmICghdXRpbHMuc3RhcnRzV2l0aChhcmdzW2ldLmFyZy50b1N0cmluZygpLCAnLycpIHx8ICF1dGlscy5lbmRzV2l0aChhcmdzW2ldLmFyZy50b1N0cmluZygpLCAnLycpKSB7XG4gICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgIH0gLy8gc2ltcGxlIGFyZyBjaGVjayBpZiBpdCBpcyBub3QgYSByZWdleHBcblxuICAgIH0gZWxzZSBpZiAoIS9eW1xcdy1dKyQvLnRlc3QoYXJnc1tpXS5hcmcpKSB7XG4gICAgICByZXR1cm4gZmFsc2U7XG4gICAgfVxuICB9XG5cbiAgcmV0dXJuIHRydWU7XG59O1xuXG4vKipcbiAqIENsYXNzIHRoYXQgZXh0ZW5kcyBTaXp6bGUgYW5kIGFkZHMgc3VwcG9ydCBmb3IgXCJtYXRjaGVzLWF0dHJcIiBwc2V1ZG8gZWxlbWVudC5cbiAqL1xuXG52YXIgQXR0cmlidXRlc01hdGNoZXIgPSBmdW5jdGlvbiAoKSB7XG4gIC8qKlxuICAgKiBDbGFzcyB0aGF0IG1hdGNoZXMgZWxlbWVudCBhdHRyaWJ1dGVzIGFnYWluc3QgdGhlIHNwZWNpZmllZCBleHByZXNzaW9uc1xuICAgKiBAcGFyYW0ge0FyZ0RhdGF9IG5hbWVBcmcgLSBwYXJzZWQgbmFtZSBhcmd1bWVudFxuICAgKiBAcGFyYW0ge0FyZ0RhdGF9IHZhbHVlQXJnIC0gcGFyc2VkIHZhbHVlIGFyZ3VtZW50XG4gICAqIEBwYXJhbSB7c3RyaW5nfSBwc2V1ZG9FbGVtZW50XG4gICAqIEBjb25zdHJ1Y3RvclxuICAgKlxuICAgKiBAbWVtYmVyIHtzdHJpbmd8UmVnRXhwfSBhdHRyTmFtZVxuICAgKiBAbWVtYmVyIHtib29sZWFufSBpc1JlZ2V4cE5hbWVcbiAgICogQG1lbWJlciB7c3RyaW5nfFJlZ0V4cH0gYXR0clZhbHVlXG4gICAqIEBtZW1iZXIge2Jvb2xlYW59IGlzUmVnZXhwVmFsdWVcbiAgICovXG4gIHZhciBBdHRyTWF0Y2hlciA9IGZ1bmN0aW9uIEF0dHJNYXRjaGVyKG5hbWVBcmcsIHZhbHVlQXJnLCBwc2V1ZG9FbGVtZW50KSB7XG4gICAgdGhpcy5wc2V1ZG9FbGVtZW50ID0gcHNldWRvRWxlbWVudDtcbiAgICB0aGlzLmF0dHJOYW1lID0gbmFtZUFyZy5hcmc7XG4gICAgdGhpcy5pc1JlZ2V4cE5hbWUgPSBuYW1lQXJnLmlzUmVnZXhwO1xuICAgIHRoaXMuYXR0clZhbHVlID0gdmFsdWVBcmcuYXJnO1xuICAgIHRoaXMuaXNSZWdleHBWYWx1ZSA9IHZhbHVlQXJnLmlzUmVnZXhwO1xuICB9O1xuICAvKipcbiAgICogRnVuY3Rpb24gdG8gY2hlY2sgaWYgZWxlbWVudCBhdHRyaWJ1dGVzIG1hdGNoZXMgZmlsdGVyIHBhdHRlcm5cbiAgICogQHBhcmFtIHtFbGVtZW50fSBlbGVtZW50IHRvIGNoZWNrXG4gICAqL1xuXG5cbiAgQXR0ck1hdGNoZXIucHJvdG90eXBlLm1hdGNoZXMgPSBmdW5jdGlvbiAoZWxlbWVudCkge1xuICAgIHZhciBlbEF0dHJzID0gZWxlbWVudC5hdHRyaWJ1dGVzO1xuXG4gICAgaWYgKGVsQXR0cnMubGVuZ3RoID09PSAwIHx8ICF0aGlzLmF0dHJOYW1lKSB7XG4gICAgICByZXR1cm4gZmFsc2U7XG4gICAgfVxuXG4gICAgdmFyIGkgPSAwO1xuXG4gICAgd2hpbGUgKGkgPCBlbEF0dHJzLmxlbmd0aCkge1xuICAgICAgdmFyIGF0dHIgPSBlbEF0dHJzW2ldO1xuICAgICAgdmFyIG1hdGNoZWQgPSBmYWxzZTtcbiAgICAgIHZhciBhdHRyTmFtZU1hdGNoZWQgPSB0aGlzLmlzUmVnZXhwTmFtZSA/IHRoaXMuYXR0ck5hbWUudGVzdChhdHRyLm5hbWUpIDogdGhpcy5hdHRyTmFtZSA9PT0gYXR0ci5uYW1lO1xuXG4gICAgICBpZiAoIXRoaXMuYXR0clZhbHVlKSB7XG4gICAgICAgIC8vIGZvciA6bWF0Y2hlcy1hdHRyKFwiL3JlZ2V4L1wiKSBvciA6bWF0Y2hlcy1hdHRyKFwiYXR0ci1uYW1lXCIpXG4gICAgICAgIG1hdGNoZWQgPSBhdHRyTmFtZU1hdGNoZWQ7XG4gICAgICB9IGVsc2Uge1xuICAgICAgICB2YXIgYXR0clZhbHVlTWF0Y2hlZCA9IHRoaXMuaXNSZWdleHBWYWx1ZSA/IHRoaXMuYXR0clZhbHVlLnRlc3QoYXR0ci52YWx1ZSkgOiB0aGlzLmF0dHJWYWx1ZSA9PT0gYXR0ci52YWx1ZTtcbiAgICAgICAgbWF0Y2hlZCA9IGF0dHJOYW1lTWF0Y2hlZCAmJiBhdHRyVmFsdWVNYXRjaGVkO1xuICAgICAgfVxuXG4gICAgICBpZiAobWF0Y2hlZCkge1xuICAgICAgICByZXR1cm4gdHJ1ZTtcbiAgICAgIH1cblxuICAgICAgaSArPSAxO1xuICAgIH1cbiAgfTtcbiAgLyoqXG4gICAqIENyZWF0ZXMgYSBuZXcgcHNldWRvLWNsYXNzIGFuZCByZWdpc3RlcnMgaXQgaW4gU2l6emxlXG4gICAqL1xuXG5cbiAgdmFyIGV4dGVuZFNpenpsZSA9IGZ1bmN0aW9uIGV4dGVuZFNpenpsZShzaXp6bGUpIHtcbiAgICAvLyBGaXJzdCBvZiBhbGwgd2Ugc2hvdWxkIHByZXBhcmUgU2l6emxlIGVuZ2luZVxuICAgIHNpenpsZS5zZWxlY3RvcnMucHNldWRvc1snbWF0Y2hlcy1hdHRyJ10gPSBzaXp6bGUuc2VsZWN0b3JzLmNyZWF0ZVBzZXVkbyhmdW5jdGlvbiAoYXR0ckZpbHRlcikge1xuICAgICAgdmFyIF9tYXRjaGVyVXRpbHMkcGFyc2VNYSA9IG1hdGNoZXJVdGlscy5wYXJzZU1hdGNoZXJGaWx0ZXIoYXR0ckZpbHRlciksXG4gICAgICAgICAgX21hdGNoZXJVdGlscyRwYXJzZU1hMiA9IF9zbGljZWRUb0FycmF5KF9tYXRjaGVyVXRpbHMkcGFyc2VNYSwgMiksXG4gICAgICAgICAgcmF3TmFtZSA9IF9tYXRjaGVyVXRpbHMkcGFyc2VNYTJbMF0sXG4gICAgICAgICAgcmF3VmFsdWUgPSBfbWF0Y2hlclV0aWxzJHBhcnNlTWEyWzFdO1xuXG4gICAgICB2YXIgbmFtZUFyZyA9IG1hdGNoZXJVdGlscy5wYXJzZVJhd01hdGNoZXJBcmcocmF3TmFtZSk7XG4gICAgICB2YXIgdmFsdWVBcmcgPSBtYXRjaGVyVXRpbHMucGFyc2VSYXdNYXRjaGVyQXJnKHJhd1ZhbHVlKTtcblxuICAgICAgaWYgKCFhdHRyRmlsdGVyIHx8ICFtYXRjaGVyVXRpbHMudmFsaWRhdGVQcm9wTWF0Y2hlckFyZ3MobmFtZUFyZywgdmFsdWVBcmcpKSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcihcIkludmFsaWQgYXJndW1lbnQgb2YgOm1hdGNoZXMtYXR0ciBwc2V1ZG8gY2xhc3M6IFwiLmNvbmNhdChhdHRyRmlsdGVyKSk7XG4gICAgICB9XG5cbiAgICAgIHZhciBtYXRjaGVyID0gbmV3IEF0dHJNYXRjaGVyKG5hbWVBcmcsIHZhbHVlQXJnKTtcbiAgICAgIHJldHVybiBmdW5jdGlvbiAoZWxlbWVudCkge1xuICAgICAgICByZXR1cm4gbWF0Y2hlci5tYXRjaGVzKGVsZW1lbnQpO1xuICAgICAgfTtcbiAgICB9KTtcbiAgfTsgLy8gRVhQT1NFXG5cblxuICByZXR1cm4ge1xuICAgIGV4dGVuZFNpenpsZTogZXh0ZW5kU2l6emxlXG4gIH07XG59KCk7XG5cbi8qKlxuICogUGFyc2VzIHJhdyBwcm9wZXJ0eSBhcmdcbiAqIEBwYXJhbSB7c3RyaW5nfSBpbnB1dFxuICogQHJldHVybnMge0FyZ0RhdGFbXX0gYXJyYXkgb2Ygb2JqZWN0c1xuICovXG5cbnZhciBwYXJzZVJhd1Byb3BDaGFpbiA9IGZ1bmN0aW9uIHBhcnNlUmF3UHJvcENoYWluKGlucHV0KSB7XG4gIHZhciBQUk9QU19ESVZJREVSID0gJy4nO1xuICB2YXIgUkVHRVhQX01BUktFUiA9ICcvJztcbiAgdmFyIHByb3BzQXJyID0gW107XG4gIHZhciBzdHIgPSBpbnB1dDtcblxuICB3aGlsZSAoc3RyLmxlbmd0aCA+IDApIHtcbiAgICBpZiAodXRpbHMuc3RhcnRzV2l0aChzdHIsIFBST1BTX0RJVklERVIpKSB7XG4gICAgICAvLyBmb3IgY2FzZXMgbGlrZSAnLnByb3AuaWQnIGFuZCAnbmVzdGVkLi50ZXN0J1xuICAgICAgdGhyb3cgbmV3IEVycm9yKFwiSW52YWxpZCBjaGFpbiBwcm9wZXJ0eTogXCIuY29uY2F0KGlucHV0KSk7XG4gICAgfVxuXG4gICAgaWYgKCF1dGlscy5zdGFydHNXaXRoKHN0ciwgUkVHRVhQX01BUktFUikpIHtcbiAgICAgIHZhciBpc1JlZ2V4cCA9IGZhbHNlO1xuICAgICAgdmFyIGRpdmlkZXJJbmRleCA9IHN0ci5pbmRleE9mKFBST1BTX0RJVklERVIpO1xuXG4gICAgICBpZiAoc3RyLmluZGV4T2YoUFJPUFNfRElWSURFUikgPT09IC0xKSB7XG4gICAgICAgIC8vIGlmIHRoZXJlIGlzIG5vICcuJyBsZWZ0IGluIHN0clxuICAgICAgICAvLyB0YWtlIHRoZSByZXN0IG9mIHN0ciBhcyBwcm9wXG4gICAgICAgIHByb3BzQXJyLnB1c2goe1xuICAgICAgICAgIGFyZzogc3RyLFxuICAgICAgICAgIGlzUmVnZXhwOiBpc1JlZ2V4cFxuICAgICAgICB9KTtcbiAgICAgICAgcmV0dXJuIHByb3BzQXJyO1xuICAgICAgfSAvLyBlbHNlIHRha2UgcHJvcCBmcm9tIHN0clxuXG5cbiAgICAgIHZhciBwcm9wID0gc3RyLnNsaWNlKDAsIGRpdmlkZXJJbmRleCk7IC8vIGZvciBjYXNlcyBsaWtlICdhc2FkZi4/Ky8udGVzdCdcblxuICAgICAgaWYgKHByb3AuaW5kZXhPZihSRUdFWFBfTUFSS0VSKSA+IC0xKSB7XG4gICAgICAgIC8vIHByb3AgaXMgJz8rLydcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiSW52YWxpZCBjaGFpbiBwcm9wZXJ0eTogXCIuY29uY2F0KHByb3ApKTtcbiAgICAgIH1cblxuICAgICAgcHJvcHNBcnIucHVzaCh7XG4gICAgICAgIGFyZzogcHJvcCxcbiAgICAgICAgaXNSZWdleHA6IGlzUmVnZXhwXG4gICAgICB9KTsgLy8gZGVsZXRlIHByb3AgZnJvbSBzdHJcblxuICAgICAgc3RyID0gc3RyLnNsaWNlKGRpdmlkZXJJbmRleCk7XG4gICAgfSBlbHNlIHtcbiAgICAgIC8vIGRlYWwgd2l0aCByZWdleHBcbiAgICAgIHZhciBwcm9wQ2h1bmtzID0gW107XG4gICAgICBwcm9wQ2h1bmtzLnB1c2goc3RyLnNsaWNlKDAsIDEpKTsgLy8gaWYgc3RyIHN0YXJ0cyB3aXRoICcvJywgZGVsZXRlIGl0IGZyb20gc3RyIGFuZCBmaW5kIGNsb3NpbmcgcmVnZXhwIHNsYXNoLlxuICAgICAgLy8gbm90ZSB0aGF0IGNoYWluZWQgcHJvcGVydHkgbmFtZSBjYW4gbm90IGluY2x1ZGUgJy8nIG9yICcuJ1xuICAgICAgLy8gc28gdGhlcmUgaXMgbm8gY2hlY2tpbmcgZm9yIGVzY2FwZWQgY2hhcmFjdGVyc1xuXG4gICAgICBzdHIgPSBzdHIuc2xpY2UoMSk7XG4gICAgICB2YXIgcmVnZXhFbmRJbmRleCA9IHN0ci5pbmRleE9mKFJFR0VYUF9NQVJLRVIpO1xuXG4gICAgICBpZiAocmVnZXhFbmRJbmRleCA8IDEpIHtcbiAgICAgICAgLy8gcmVnZXhwIHNob3VsZCBiZSBhdCBsZWFzdCA9PT0gJy8uLydcbiAgICAgICAgLy8gc28gd2Ugc2hvdWxkIGF2b2lkIGFyZ3MgbGlrZSAnL2lkJyBhbmQgJ3Rlc3QuLy8uaWQnXG4gICAgICAgIHRocm93IG5ldyBFcnJvcihcIkludmFsaWQgcmVnZXhwOiBcIi5jb25jYXQoUkVHRVhQX01BUktFUikuY29uY2F0KHN0cikpO1xuICAgICAgfVxuXG4gICAgICB2YXIgX2lzUmVnZXhwID0gdHJ1ZTsgLy8gdGFrZSB0aGUgcmVzdCByZWdleHAgcGFydFxuXG4gICAgICBwcm9wQ2h1bmtzLnB1c2goc3RyLnNsaWNlKDAsIHJlZ2V4RW5kSW5kZXggKyAxKSk7XG5cbiAgICAgIHZhciBfcHJvcCA9IHV0aWxzLnRvUmVnRXhwKHByb3BDaHVua3Muam9pbignJykpO1xuXG4gICAgICBwcm9wc0Fyci5wdXNoKHtcbiAgICAgICAgYXJnOiBfcHJvcCxcbiAgICAgICAgaXNSZWdleHA6IF9pc1JlZ2V4cFxuICAgICAgfSk7IC8vIGRlbGV0ZSBwcm9wIGZyb20gc3RyXG5cbiAgICAgIHN0ciA9IHN0ci5zbGljZShyZWdleEVuZEluZGV4ICsgMSk7XG4gICAgfVxuXG4gICAgaWYgKCFzdHIpIHtcbiAgICAgIHJldHVybiBwcm9wc0FycjtcbiAgICB9IC8vIHN0ciBzaG91bGQgYmUgbGlrZSAnLm5leHRQcm9wJyBub3dcbiAgICAvLyBzbyAnengucHJvcCcgb3IgJy4nIGlzIGludmFsaWRcblxuXG4gICAgaWYgKCF1dGlscy5zdGFydHNXaXRoKHN0ciwgUFJPUFNfRElWSURFUikgfHwgdXRpbHMuc3RhcnRzV2l0aChzdHIsIFBST1BTX0RJVklERVIpICYmIHN0ci5sZW5ndGggPT09IDEpIHtcbiAgICAgIHRocm93IG5ldyBFcnJvcihcIkludmFsaWQgY2hhaW4gcHJvcGVydHk6IFwiLmNvbmNhdChpbnB1dCkpO1xuICAgIH1cblxuICAgIHN0ciA9IHN0ci5zbGljZSgxKTtcbiAgfVxufTtcblxudmFyIGNvbnZlcnRUeXBlRnJvbVN0ciA9IGZ1bmN0aW9uIGNvbnZlcnRUeXBlRnJvbVN0cih2YWx1ZSkge1xuICB2YXIgbnVtVmFsdWUgPSBOdW1iZXIodmFsdWUpO1xuICB2YXIgb3V0cHV0O1xuXG4gIGlmICghTnVtYmVyLmlzTmFOKG51bVZhbHVlKSkge1xuICAgIG91dHB1dCA9IG51bVZhbHVlO1xuICB9IGVsc2Uge1xuICAgIHN3aXRjaCAodmFsdWUpIHtcbiAgICAgIGNhc2UgJ3VuZGVmaW5lZCc6XG4gICAgICAgIG91dHB1dCA9IHVuZGVmaW5lZDtcbiAgICAgICAgYnJlYWs7XG5cbiAgICAgIGNhc2UgJ251bGwnOlxuICAgICAgICBvdXRwdXQgPSBudWxsO1xuICAgICAgICBicmVhaztcblxuICAgICAgY2FzZSAndHJ1ZSc6XG4gICAgICAgIG91dHB1dCA9IHRydWU7XG4gICAgICAgIGJyZWFrO1xuXG4gICAgICBjYXNlICdmYWxzZSc6XG4gICAgICAgIG91dHB1dCA9IGZhbHNlO1xuICAgICAgICBicmVhaztcblxuICAgICAgZGVmYXVsdDpcbiAgICAgICAgb3V0cHV0ID0gdmFsdWU7XG4gICAgfVxuICB9XG5cbiAgcmV0dXJuIG91dHB1dDtcbn07XG5cbnZhciBjb252ZXJ0VHlwZUludG9TdHIgPSBmdW5jdGlvbiBjb252ZXJ0VHlwZUludG9TdHIodmFsdWUpIHtcbiAgdmFyIG91dHB1dDtcblxuICBzd2l0Y2ggKHZhbHVlKSB7XG4gICAgY2FzZSB1bmRlZmluZWQ6XG4gICAgICBvdXRwdXQgPSAndW5kZWZpbmVkJztcbiAgICAgIGJyZWFrO1xuXG4gICAgY2FzZSBudWxsOlxuICAgICAgb3V0cHV0ID0gJ251bGwnO1xuICAgICAgYnJlYWs7XG5cbiAgICBkZWZhdWx0OlxuICAgICAgb3V0cHV0ID0gdmFsdWUudG9TdHJpbmcoKTtcbiAgfVxuXG4gIHJldHVybiBvdXRwdXQ7XG59O1xuLyoqXG4gKiBDbGFzcyB0aGF0IGV4dGVuZHMgU2l6emxlIGFuZCBhZGRzIHN1cHBvcnQgZm9yIFwibWF0Y2hlcy1wcm9wZXJ0eVwiIHBzZXVkbyBlbGVtZW50LlxuICovXG5cblxudmFyIEVsZW1lbnRQcm9wZXJ0eU1hdGNoZXIgPSBmdW5jdGlvbiAoKSB7XG4gIC8qKlxuICAgKiBDbGFzcyB0aGF0IG1hdGNoZXMgZWxlbWVudCBwcm9wZXJ0aWVzIGFnYWluc3QgdGhlIHNwZWNpZmllZCBleHByZXNzaW9uc1xuICAgKiBAcGFyYW0ge0FyZ0RhdGFbXX0gcHJvcHNDaGFpbkFyZyAtIGFycmF5IG9mIHBhcnNlZCBwcm9wcyBjaGFpbiBvYmplY3RzXG4gICAqIEBwYXJhbSB7QXJnRGF0YX0gdmFsdWVBcmcgLSBwYXJzZWQgdmFsdWUgYXJndW1lbnRcbiAgICogQHBhcmFtIHtzdHJpbmd9IHBzZXVkb0VsZW1lbnRcbiAgICogQGNvbnN0cnVjdG9yXG4gICAqXG4gICAqIEBtZW1iZXIge0FycmF5fSBjaGFpbmVkUHJvcHNcbiAgICogQG1lbWJlciB7Ym9vbGVhbn0gaXNSZWdleHBOYW1lXG4gICAqIEBtZW1iZXIge3N0cmluZ3xSZWdFeHB9IHByb3BWYWx1ZVxuICAgKiBAbWVtYmVyIHtib29sZWFufSBpc1JlZ2V4cFZhbHVlXG4gICAqL1xuICB2YXIgUHJvcE1hdGNoZXIgPSBmdW5jdGlvbiBQcm9wTWF0Y2hlcihwcm9wc0NoYWluQXJnLCB2YWx1ZUFyZywgcHNldWRvRWxlbWVudCkge1xuICAgIHRoaXMucHNldWRvRWxlbWVudCA9IHBzZXVkb0VsZW1lbnQ7XG4gICAgdGhpcy5jaGFpbmVkUHJvcHMgPSBwcm9wc0NoYWluQXJnO1xuICAgIHRoaXMucHJvcFZhbHVlID0gdmFsdWVBcmcuYXJnO1xuICAgIHRoaXMuaXNSZWdleHBWYWx1ZSA9IHZhbHVlQXJnLmlzUmVnZXhwO1xuICB9O1xuICAvKipcbiAgICogRnVuY3Rpb24gdG8gY2hlY2sgaWYgZWxlbWVudCBwcm9wZXJ0aWVzIG1hdGNoZXMgZmlsdGVyIHBhdHRlcm5cbiAgICogQHBhcmFtIHtFbGVtZW50fSBlbGVtZW50IHRvIGNoZWNrXG4gICAqL1xuXG5cbiAgUHJvcE1hdGNoZXIucHJvdG90eXBlLm1hdGNoZXMgPSBmdW5jdGlvbiAoZWxlbWVudCkge1xuICAgIHZhciBvd25lck9iakFyciA9IG1hdGNoZXJVdGlscy5maWx0ZXJSb290c0J5UmVnZXhwQ2hhaW4oZWxlbWVudCwgdGhpcy5jaGFpbmVkUHJvcHMpO1xuXG4gICAgaWYgKG93bmVyT2JqQXJyLmxlbmd0aCA9PT0gMCkge1xuICAgICAgcmV0dXJuIGZhbHNlO1xuICAgIH1cblxuICAgIHZhciBtYXRjaGVkID0gdHJ1ZTtcblxuICAgIGlmICh0aGlzLnByb3BWYWx1ZSkge1xuICAgICAgZm9yICh2YXIgaSA9IDA7IGkgPCBvd25lck9iakFyci5sZW5ndGg7IGkgKz0gMSkge1xuICAgICAgICB2YXIgcmVhbFZhbHVlID0gb3duZXJPYmpBcnJbaV0udmFsdWU7XG5cbiAgICAgICAgaWYgKHRoaXMuaXNSZWdleHBWYWx1ZSkge1xuICAgICAgICAgIG1hdGNoZWQgPSB0aGlzLnByb3BWYWx1ZS50ZXN0KGNvbnZlcnRUeXBlSW50b1N0cihyZWFsVmFsdWUpKTtcbiAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAvLyBoYW5kbGUgJ251bGwnIGFuZCAndW5kZWZpbmVkJyBwcm9wZXJ0eSB2YWx1ZXMgc2V0IGFzIHN0cmluZ1xuICAgICAgICAgIGlmIChyZWFsVmFsdWUgPT09ICdudWxsJyB8fCByZWFsVmFsdWUgPT09ICd1bmRlZmluZWQnKSB7XG4gICAgICAgICAgICBtYXRjaGVkID0gdGhpcy5wcm9wVmFsdWUgPT09IHJlYWxWYWx1ZTtcbiAgICAgICAgICAgIGJyZWFrO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIG1hdGNoZWQgPSBjb252ZXJ0VHlwZUZyb21TdHIodGhpcy5wcm9wVmFsdWUpID09PSByZWFsVmFsdWU7XG4gICAgICAgIH1cblxuICAgICAgICBpZiAobWF0Y2hlZCkge1xuICAgICAgICAgIGJyZWFrO1xuICAgICAgICB9XG4gICAgICB9XG4gICAgfVxuXG4gICAgcmV0dXJuIG1hdGNoZWQ7XG4gIH07XG4gIC8qKlxuICAgKiBDcmVhdGVzIGEgbmV3IHBzZXVkby1jbGFzcyBhbmQgcmVnaXN0ZXJzIGl0IGluIFNpenpsZVxuICAgKi9cblxuXG4gIHZhciBleHRlbmRTaXp6bGUgPSBmdW5jdGlvbiBleHRlbmRTaXp6bGUoc2l6emxlKSB7XG4gICAgLy8gRmlyc3Qgb2YgYWxsIHdlIHNob3VsZCBwcmVwYXJlIFNpenpsZSBlbmdpbmVcbiAgICBzaXp6bGUuc2VsZWN0b3JzLnBzZXVkb3NbJ21hdGNoZXMtcHJvcGVydHknXSA9IHNpenpsZS5zZWxlY3RvcnMuY3JlYXRlUHNldWRvKGZ1bmN0aW9uIChwcm9wZXJ0eUZpbHRlcikge1xuICAgICAgaWYgKCFwcm9wZXJ0eUZpbHRlcikge1xuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoJ05vIGFyZ3VtZW50IGlzIGdpdmVuIGZvciA6bWF0Y2hlcy1wcm9wZXJ0eSBwc2V1ZG8gY2xhc3MnKTtcbiAgICAgIH1cblxuICAgICAgdmFyIF9tYXRjaGVyVXRpbHMkcGFyc2VNYSA9IG1hdGNoZXJVdGlscy5wYXJzZU1hdGNoZXJGaWx0ZXIocHJvcGVydHlGaWx0ZXIpLFxuICAgICAgICAgIF9tYXRjaGVyVXRpbHMkcGFyc2VNYTIgPSBfc2xpY2VkVG9BcnJheShfbWF0Y2hlclV0aWxzJHBhcnNlTWEsIDIpLFxuICAgICAgICAgIHJhd1Byb3AgPSBfbWF0Y2hlclV0aWxzJHBhcnNlTWEyWzBdLFxuICAgICAgICAgIHJhd1ZhbHVlID0gX21hdGNoZXJVdGlscyRwYXJzZU1hMlsxXTsgLy8gY2hhaW5lZCBwcm9wZXJ0eSBuYW1lIGNhbiBub3QgaW5jbHVkZSAnLycgb3IgJy4nXG4gICAgICAvLyBzbyByZWdleCBwcm9wIG5hbWVzIHdpdGggc3VjaCBlc2NhcGVkIGNoYXJhY3RlcnMgYXJlIGludmFsaWRcblxuXG4gICAgICBpZiAocmF3UHJvcC5pbmRleE9mKCdcXFxcLycpID4gLTEgfHwgcmF3UHJvcC5pbmRleE9mKCdcXFxcLicpID4gLTEpIHtcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiSW52YWxpZCBwcm9wZXJ0eSBuYW1lOiBcIi5jb25jYXQocmF3UHJvcCkpO1xuICAgICAgfVxuXG4gICAgICB2YXIgcHJvcHNDaGFpbkFyZyA9IHBhcnNlUmF3UHJvcENoYWluKHJhd1Byb3ApO1xuICAgICAgdmFyIHZhbHVlQXJnID0gbWF0Y2hlclV0aWxzLnBhcnNlUmF3TWF0Y2hlckFyZyhyYXdWYWx1ZSk7XG4gICAgICB2YXIgcHJvcHNUb1ZhbGlkYXRlID0gW10uY29uY2F0KF90b0NvbnN1bWFibGVBcnJheShwcm9wc0NoYWluQXJnKSwgW3ZhbHVlQXJnXSk7XG5cbiAgICAgIGlmICghbWF0Y2hlclV0aWxzLnZhbGlkYXRlUHJvcE1hdGNoZXJBcmdzKHByb3BzVG9WYWxpZGF0ZSkpIHtcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiSW52YWxpZCBhcmd1bWVudCBvZiA6bWF0Y2hlcy1wcm9wZXJ0eSBwc2V1ZG8gY2xhc3M6IFwiLmNvbmNhdChwcm9wZXJ0eUZpbHRlcikpO1xuICAgICAgfVxuXG4gICAgICB2YXIgbWF0Y2hlciA9IG5ldyBQcm9wTWF0Y2hlcihwcm9wc0NoYWluQXJnLCB2YWx1ZUFyZyk7XG4gICAgICByZXR1cm4gZnVuY3Rpb24gKGVsZW1lbnQpIHtcbiAgICAgICAgcmV0dXJuIG1hdGNoZXIubWF0Y2hlcyhlbGVtZW50KTtcbiAgICAgIH07XG4gICAgfSk7XG4gIH07IC8vIEVYUE9TRVxuXG5cbiAgcmV0dXJuIHtcbiAgICBleHRlbmRTaXp6bGU6IGV4dGVuZFNpenpsZVxuICB9O1xufSgpO1xuXG4vKipcbiAqIENvcHlyaWdodCAyMDIwIEFkZ3VhcmQgU29mdHdhcmUgTHRkXG4gKlxuICogTGljZW5zZWQgdW5kZXIgdGhlIEFwYWNoZSBMaWNlbnNlLCBWZXJzaW9uIDIuMCAodGhlIFwiTGljZW5zZVwiKTtcbiAqIHlvdSBtYXkgbm90IHVzZSB0aGlzIGZpbGUgZXhjZXB0IGluIGNvbXBsaWFuY2Ugd2l0aCB0aGUgTGljZW5zZS5cbiAqIFlvdSBtYXkgb2J0YWluIGEgY29weSBvZiB0aGUgTGljZW5zZSBhdFxuICpcbiAqIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMFxuICpcbiAqIFVubGVzcyByZXF1aXJlZCBieSBhcHBsaWNhYmxlIGxhdyBvciBhZ3JlZWQgdG8gaW4gd3JpdGluZywgc29mdHdhcmVcbiAqIGRpc3RyaWJ1dGVkIHVuZGVyIHRoZSBMaWNlbnNlIGlzIGRpc3RyaWJ1dGVkIG9uIGFuIFwiQVMgSVNcIiBCQVNJUyxcbiAqIFdJVEhPVVQgV0FSUkFOVElFUyBPUiBDT05ESVRJT05TIE9GIEFOWSBLSU5ELCBlaXRoZXIgZXhwcmVzcyBvciBpbXBsaWVkLlxuICogU2VlIHRoZSBMaWNlbnNlIGZvciB0aGUgc3BlY2lmaWMgbGFuZ3VhZ2UgZ292ZXJuaW5nIHBlcm1pc3Npb25zIGFuZFxuICogbGltaXRhdGlvbnMgdW5kZXIgdGhlIExpY2Vuc2UuXG4gKi9cbi8qKlxuICogQ2xhc3MgdGhhdCBleHRlbmRzIFNpenpsZSBhbmQgYWRkcyBzdXBwb3J0IGZvciA6aXMoKSBwc2V1ZG8gZWxlbWVudC5cbiAqL1xuXG52YXIgSXNBbnlNYXRjaGVyID0gZnVuY3Rpb24gKCkge1xuICAvKipcbiAgICogQ2xhc3MgdGhhdCBtYXRjaGVzIGVsZW1lbnQgYnkgb25lIG9mIHRoZSBzZWxlY3RvcnNcbiAgICogaHR0cHM6Ly9kZXZlbG9wZXIubW96aWxsYS5vcmcvZW4tVVMvZG9jcy9XZWIvQ1NTLzppc1xuICAgKiBAcGFyYW0ge0FycmF5fSBzZWxlY3RvcnNcbiAgICogQHBhcmFtIHtzdHJpbmd9IHBzZXVkb0VsZW1lbnRcbiAgICogQGNvbnN0cnVjdG9yXG4gICAqL1xuICB2YXIgSXNNYXRjaGVyID0gZnVuY3Rpb24gSXNNYXRjaGVyKHNlbGVjdG9ycywgcHNldWRvRWxlbWVudCkge1xuICAgIHRoaXMuc2VsZWN0b3JzID0gc2VsZWN0b3JzO1xuICAgIHRoaXMucHNldWRvRWxlbWVudCA9IHBzZXVkb0VsZW1lbnQ7XG4gIH07XG4gIC8qKlxuICAgKiBGdW5jdGlvbiB0byBjaGVjayBpZiBlbGVtZW50IGNhbiBiZSBtYXRjaGVkIGJ5IGFueSBwYXNzZWQgc2VsZWN0b3JcbiAgICogQHBhcmFtIHtFbGVtZW50fSBlbGVtZW50IHRvIGNoZWNrXG4gICAqL1xuXG5cbiAgSXNNYXRjaGVyLnByb3RvdHlwZS5tYXRjaGVzID0gZnVuY3Rpb24gKGVsZW1lbnQpIHtcbiAgICB2YXIgaXNNYXRjaGVkID0gISF0aGlzLnNlbGVjdG9ycy5maW5kKGZ1bmN0aW9uIChzZWxlY3Rvcikge1xuICAgICAgdmFyIG5vZGVzID0gZG9jdW1lbnQucXVlcnlTZWxlY3RvckFsbChzZWxlY3Rvcik7XG4gICAgICByZXR1cm4gQXJyYXkuZnJvbShub2RlcykuZmluZChmdW5jdGlvbiAobm9kZSkge1xuICAgICAgICByZXR1cm4gbm9kZSA9PT0gZWxlbWVudDtcbiAgICAgIH0pO1xuICAgIH0pO1xuICAgIHJldHVybiBpc01hdGNoZWQ7XG4gIH07XG4gIC8qKlxuICAgKiBDcmVhdGVzIGEgbmV3IHBzZXVkby1jbGFzcyBhbmQgcmVnaXN0ZXJzIGl0IGluIFNpenpsZVxuICAgKi9cblxuXG4gIHZhciBleHRlbmRTaXp6bGUgPSBmdW5jdGlvbiBleHRlbmRTaXp6bGUoc2l6emxlKSB7XG4gICAgLy8gRmlyc3Qgb2YgYWxsIHdlIHNob3VsZCBwcmVwYXJlIFNpenpsZSBlbmdpbmVcbiAgICBzaXp6bGUuc2VsZWN0b3JzLnBzZXVkb3NbJ2lzJ10gPSBzaXp6bGUuc2VsZWN0b3JzLmNyZWF0ZVBzZXVkbyhmdW5jdGlvbiAoaW5wdXQpIHtcbiAgICAgIGlmIChpbnB1dCA9PT0gJycpIHtcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiSW52YWxpZCBhcmd1bWVudCBvZiA6aXMgcHNldWRvLWNsYXNzOiBcIi5jb25jYXQoaW5wdXQpKTtcbiAgICAgIH1cblxuICAgICAgdmFyIHNlbGVjdG9ycyA9IGlucHV0LnNwbGl0KCcsJykubWFwKGZ1bmN0aW9uIChzKSB7XG4gICAgICAgIHJldHVybiBzLnRyaW0oKTtcbiAgICAgIH0pOyAvLyBjb2xsZWN0IHZhbGlkIHNlbGVjdG9ycyBhbmQgbG9nIGFib3V0IGludmFsaWQgb25lc1xuXG4gICAgICB2YXIgdmFsaWRTZWxlY3RvcnMgPSBzZWxlY3RvcnMucmVkdWNlKGZ1bmN0aW9uIChhY2MsIHNlbGVjdG9yKSB7XG4gICAgICAgIGlmIChjc3NVdGlscy5pc1NpbXBsZVNlbGVjdG9yVmFsaWQoc2VsZWN0b3IpKSB7XG4gICAgICAgICAgYWNjLnB1c2goc2VsZWN0b3IpO1xuICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgIHV0aWxzLmxvZ0luZm8oXCJJbnZhbGlkIHNlbGVjdG9yIHBhc3NlZCB0byA6aXMoKSBwc2V1ZG8tY2xhc3M6ICdcIi5jb25jYXQoc2VsZWN0b3IsIFwiJ1wiKSk7XG4gICAgICAgIH1cblxuICAgICAgICByZXR1cm4gYWNjO1xuICAgICAgfSwgW10pO1xuICAgICAgdmFyIG1hdGNoZXIgPSBuZXcgSXNNYXRjaGVyKHZhbGlkU2VsZWN0b3JzKTtcbiAgICAgIHJldHVybiBmdW5jdGlvbiAoZWxlbWVudCkge1xuICAgICAgICByZXR1cm4gbWF0Y2hlci5tYXRjaGVzKGVsZW1lbnQpO1xuICAgICAgfTtcbiAgICB9KTtcbiAgfTtcblxuICByZXR1cm4ge1xuICAgIGV4dGVuZFNpenpsZTogZXh0ZW5kU2l6emxlXG4gIH07XG59KCk7XG5cbi8qKlxuICogQ29weXJpZ2h0IDIwMjEgQWRndWFyZCBTb2Z0d2FyZSBMdGRcbiAqXG4gKiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2Vuc2UsIFZlcnNpb24gMi4wICh0aGUgXCJMaWNlbnNlXCIpO1xuICogeW91IG1heSBub3QgdXNlIHRoaXMgZmlsZSBleGNlcHQgaW4gY29tcGxpYW5jZSB3aXRoIHRoZSBMaWNlbnNlLlxuICogWW91IG1heSBvYnRhaW4gYSBjb3B5IG9mIHRoZSBMaWNlbnNlIGF0XG4gKlxuICogaHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wXG4gKlxuICogVW5sZXNzIHJlcXVpcmVkIGJ5IGFwcGxpY2FibGUgbGF3IG9yIGFncmVlZCB0byBpbiB3cml0aW5nLCBzb2Z0d2FyZVxuICogZGlzdHJpYnV0ZWQgdW5kZXIgdGhlIExpY2Vuc2UgaXMgZGlzdHJpYnV0ZWQgb24gYW4gXCJBUyBJU1wiIEJBU0lTLFxuICogV0lUSE9VVCBXQVJSQU5USUVTIE9SIENPTkRJVElPTlMgT0YgQU5ZIEtJTkQsIGVpdGhlciBleHByZXNzIG9yIGltcGxpZWQuXG4gKiBTZWUgdGhlIExpY2Vuc2UgZm9yIHRoZSBzcGVjaWZpYyBsYW5ndWFnZSBnb3Zlcm5pbmcgcGVybWlzc2lvbnMgYW5kXG4gKiBsaW1pdGF0aW9ucyB1bmRlciB0aGUgTGljZW5zZS5cbiAqL1xuLyoqXG4gKiBFeHRlbmRlZCBzZWxlY3RvciBmYWN0b3J5IG1vZHVsZSwgZm9yIGNyZWF0aW5nIGV4dGVuZGVkIHNlbGVjdG9yIGNsYXNzZXMuXG4gKlxuICogRXh0ZW5kZWQgc2VsZWN0aW9uIGNhcGFiaWxpdGllcyBkZXNjcmlwdGlvbjpcbiAqIGh0dHBzOi8vZ2l0aHViLmNvbS9BZGd1YXJkVGVhbS9FeHRlbmRlZENzcy9ibG9iL21hc3Rlci9SRUFETUUubWRcbiAqL1xuXG52YXIgRXh0ZW5kZWRTZWxlY3RvckZhY3RvcnkgPSBmdW5jdGlvbiAoKSB7XG4gIC8vIHdoaWxlIGFkZGluZyBuZXcgbWFya2VycywgY29uc3RhbnRzIGluIG90aGVyIEFkR3VhcmQgcmVwb3Mgc2hvdWxkIGJlIGNvcnJlY3RlZFxuICAvLyBBZEd1YXJkIGJyb3dzZXIgZXh0ZW5zaW9uIDogQ3NzRmlsdGVyUnVsZS5TVVBQT1JURURfUFNFVURPX0NMQVNTRVMgYW5kIENzc0ZpbHRlclJ1bGUuRVhURU5ERURfQ1NTX01BUktFUlNcbiAgLy8gdHN1cmxmaWx0ZXIsIFNhZmFyaUNvbnZlcnRlckxpYiA6IEVYVF9DU1NfUFNFVURPX0lORElDQVRPUlNcbiAgdmFyIFBTRVVET19FWFRFTlNJT05TX01BUktFUlMgPSBbJzpoYXMnLCAnOmNvbnRhaW5zJywgJzpoYXMtdGV4dCcsICc6bWF0Y2hlcy1jc3MnLCAnOi1hYnAtaGFzJywgJzotYWJwLWhhcy10ZXh0JywgJzppZicsICc6aWYtbm90JywgJzp4cGF0aCcsICc6bnRoLWFuY2VzdG9yJywgJzp1cHdhcmQnLCAnOnJlbW92ZScsICc6bWF0Y2hlcy1hdHRyJywgJzptYXRjaGVzLXByb3BlcnR5JywgJzotYWJwLWNvbnRhaW5zJywgJzppcyddO1xuICB2YXIgaW5pdGlhbGl6ZWQgPSBmYWxzZTtcbiAgdmFyIFNpenpsZTtcbiAgLyoqXG4gICAqIExhenkgaW5pdGlhbGl6YXRpb24gb2YgdGhlIEV4dGVuZGVkU2VsZWN0b3JGYWN0b3J5IGFuZCBvYmplY3RzIHRoYXQgbWlnaHQgYmUgbmVjZXNzYXJ5IGZvciBjcmVhdGluZyBhbmQgYXBwbHlpbmcgc3R5bGVzLlxuICAgKiBUaGlzIG1ldGhvZCBleHRlbmRzIFNpenpsZSBlbmdpbmUgdGhhdCB3ZSB1c2UgdW5kZXIgdGhlIGhvb2Qgd2l0aCBvdXIgY3VzdG9tIHBzZXVkby1jbGFzc2VzLlxuICAgKi9cblxuICBmdW5jdGlvbiBpbml0aWFsaXplKCkge1xuICAgIGlmIChpbml0aWFsaXplZCkge1xuICAgICAgcmV0dXJuO1xuICAgIH1cblxuICAgIGluaXRpYWxpemVkID0gdHJ1ZTsgLy8gT3VyIHZlcnNpb24gb2YgU2l6emxlIGlzIGluaXRpYWxpemVkIGxhemlseSBhcyB3ZWxsXG5cbiAgICBTaXp6bGUgPSBpbml0aWFsaXplU2l6emxlKCk7IC8vIEFkZCA6bWF0Y2hlcy1jc3MtKigpIHN1cHBvcnRcblxuICAgIFN0eWxlUHJvcGVydHlNYXRjaGVyLmV4dGVuZFNpenpsZShTaXp6bGUpOyAvLyBBZGQgOm1hdGNoZXMtYXR0cigpIHN1cHBvcnRcblxuICAgIEF0dHJpYnV0ZXNNYXRjaGVyLmV4dGVuZFNpenpsZShTaXp6bGUpOyAvLyBBZGQgOm1hdGNoZXMtcHJvcGVydHkoKSBzdXBwb3J0XG5cbiAgICBFbGVtZW50UHJvcGVydHlNYXRjaGVyLmV4dGVuZFNpenpsZShTaXp6bGUpOyAvLyBBZGQgOmlzKCkgc3VwcG9ydFxuXG4gICAgSXNBbnlNYXRjaGVyLmV4dGVuZFNpenpsZShTaXp6bGUpOyAvLyBBZGQgOmNvbnRhaW5zLCA6aGFzLXRleHQsIDotYWJwLWNvbnRhaW5zIHN1cHBvcnRcblxuICAgIHZhciBjb250YWluc1BzZXVkbyA9IFNpenpsZS5zZWxlY3RvcnMuY3JlYXRlUHNldWRvKGZ1bmN0aW9uICh0ZXh0KSB7XG4gICAgICBpZiAoL15cXHMqXFwvLipcXC9bZ21pc3V5XSpcXHMqJC8udGVzdCh0ZXh0KSkge1xuICAgICAgICB0ZXh0ID0gdGV4dC50cmltKCk7XG4gICAgICAgIHZhciBmbGFnc0luZGV4ID0gdGV4dC5sYXN0SW5kZXhPZignLycpO1xuICAgICAgICB2YXIgZmxhZ3MgPSB0ZXh0LnN1YnN0cmluZyhmbGFnc0luZGV4ICsgMSk7XG4gICAgICAgIHRleHQgPSB0ZXh0LnN1YnN0cigwLCBmbGFnc0luZGV4ICsgMSkuc2xpY2UoMSwgLTEpLnJlcGxhY2UoL1xcXFwoW1xcXFxcIl0pL2csICckMScpO1xuICAgICAgICB2YXIgcmVnZXg7XG5cbiAgICAgICAgdHJ5IHtcbiAgICAgICAgICByZWdleCA9IG5ldyBSZWdFeHAodGV4dCwgZmxhZ3MpO1xuICAgICAgICB9IGNhdGNoIChlKSB7XG4gICAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiSW52YWxpZCBhcmd1bWVudCBvZiA6Y29udGFpbnMgcHNldWRvIGNsYXNzOiBcIi5jb25jYXQodGV4dCkpO1xuICAgICAgICB9XG5cbiAgICAgICAgcmV0dXJuIGZ1bmN0aW9uIChlbGVtKSB7XG4gICAgICAgICAgdmFyIGVsZW1UZXh0Q29udGVudCA9IHV0aWxzLm5vZGVUZXh0Q29udGVudEdldHRlci5hcHBseShlbGVtKTtcbiAgICAgICAgICByZXR1cm4gcmVnZXgudGVzdChlbGVtVGV4dENvbnRlbnQpO1xuICAgICAgICB9O1xuICAgICAgfVxuXG4gICAgICB0ZXh0ID0gdGV4dC5yZXBsYWNlKC9cXFxcKFtcXFxcKClbXFxdXCJdKS9nLCAnJDEnKTtcbiAgICAgIHJldHVybiBmdW5jdGlvbiAoZWxlbSkge1xuICAgICAgICB2YXIgZWxlbVRleHRDb250ZW50ID0gdXRpbHMubm9kZVRleHRDb250ZW50R2V0dGVyLmFwcGx5KGVsZW0pO1xuICAgICAgICByZXR1cm4gZWxlbVRleHRDb250ZW50LmluZGV4T2YodGV4dCkgPiAtMTtcbiAgICAgIH07XG4gICAgfSk7XG4gICAgU2l6emxlLnNlbGVjdG9ycy5wc2V1ZG9zWydjb250YWlucyddID0gY29udGFpbnNQc2V1ZG87XG4gICAgU2l6emxlLnNlbGVjdG9ycy5wc2V1ZG9zWydoYXMtdGV4dCddID0gY29udGFpbnNQc2V1ZG87XG4gICAgU2l6emxlLnNlbGVjdG9ycy5wc2V1ZG9zWyctYWJwLWNvbnRhaW5zJ10gPSBjb250YWluc1BzZXVkbzsgLy8gQWRkIDppZiwgOi1hYnAtaGFzIHN1cHBvcnRcblxuICAgIFNpenpsZS5zZWxlY3RvcnMucHNldWRvc1snaWYnXSA9IFNpenpsZS5zZWxlY3RvcnMucHNldWRvc1snaGFzJ107XG4gICAgU2l6emxlLnNlbGVjdG9ycy5wc2V1ZG9zWyctYWJwLWhhcyddID0gU2l6emxlLnNlbGVjdG9ycy5wc2V1ZG9zWydoYXMnXTsgLy8gQWRkIDppZi1ub3Qgc3VwcG9ydFxuXG4gICAgU2l6emxlLnNlbGVjdG9ycy5wc2V1ZG9zWydpZi1ub3QnXSA9IFNpenpsZS5zZWxlY3RvcnMuY3JlYXRlUHNldWRvKGZ1bmN0aW9uIChzZWxlY3Rvcikge1xuICAgICAgaWYgKHR5cGVvZiBzZWxlY3RvciA9PT0gJ3N0cmluZycpIHtcbiAgICAgICAgU2l6emxlLmNvbXBpbGUoc2VsZWN0b3IpO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gZnVuY3Rpb24gKGVsZW0pIHtcbiAgICAgICAgcmV0dXJuIFNpenpsZShzZWxlY3RvciwgZWxlbSkubGVuZ3RoID09PSAwO1xuICAgICAgfTtcbiAgICB9KTtcbiAgICByZWdpc3RlclBhcnNlck9ubHlUb2tlbnMoKTtcbiAgfVxuICAvKipcbiAgICogUmVnaXN0cmF0ZSBjdXN0b20gdG9rZW5zIGZvciBwYXJzZXIuXG4gICAqIE5lZWRlZCBmb3IgcHJvcGVyIHdvcmsgb2YgcHNldWRvczpcbiAgICogZm9yIGNoZWNraW5nIGlmIHRoZSB0b2tlbiBpcyBsYXN0IGFuZCBwc2V1ZG8tY2xhc3MgYXJndW1lbnRzIHZhbGlkYXRpb25cbiAgICovXG5cblxuICBmdW5jdGlvbiByZWdpc3RlclBhcnNlck9ubHlUb2tlbnMoKSB7XG4gICAgU2l6emxlLnNlbGVjdG9ycy5wc2V1ZG9zWyd4cGF0aCddID0gU2l6emxlLnNlbGVjdG9ycy5jcmVhdGVQc2V1ZG8oZnVuY3Rpb24gKHNlbGVjdG9yKSB7XG4gICAgICB0cnkge1xuICAgICAgICBkb2N1bWVudC5jcmVhdGVFeHByZXNzaW9uKHNlbGVjdG9yLCBudWxsKTtcbiAgICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiSW52YWxpZCBhcmd1bWVudCBvZiA6eHBhdGggcHNldWRvIGNsYXNzOiBcIi5jb25jYXQoc2VsZWN0b3IpKTtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIGZ1bmN0aW9uICgpIHtcbiAgICAgICAgcmV0dXJuIHRydWU7XG4gICAgICB9O1xuICAgIH0pO1xuICAgIFNpenpsZS5zZWxlY3RvcnMucHNldWRvc1snbnRoLWFuY2VzdG9yJ10gPSBTaXp6bGUuc2VsZWN0b3JzLmNyZWF0ZVBzZXVkbyhmdW5jdGlvbiAoc2VsZWN0b3IpIHtcbiAgICAgIHZhciBkZWVwID0gTnVtYmVyKHNlbGVjdG9yKTtcblxuICAgICAgaWYgKE51bWJlci5pc05hTihkZWVwKSB8fCBkZWVwIDwgMSB8fCBkZWVwID49IDI1Nikge1xuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJJbnZhbGlkIGFyZ3VtZW50IG9mIDpudGgtYW5jZXN0b3IgcHNldWRvIGNsYXNzOiBcIi5jb25jYXQoc2VsZWN0b3IpKTtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIGZ1bmN0aW9uICgpIHtcbiAgICAgICAgcmV0dXJuIHRydWU7XG4gICAgICB9O1xuICAgIH0pO1xuICAgIFNpenpsZS5zZWxlY3RvcnMucHNldWRvc1sndXB3YXJkJ10gPSBTaXp6bGUuc2VsZWN0b3JzLmNyZWF0ZVBzZXVkbyhmdW5jdGlvbiAoaW5wdXQpIHtcbiAgICAgIGlmIChpbnB1dCA9PT0gJycpIHtcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiSW52YWxpZCBhcmd1bWVudCBvZiA6dXB3YXJkIHBzZXVkbyBjbGFzczogXCIuY29uY2F0KGlucHV0KSk7XG4gICAgICB9IGVsc2UgaWYgKE51bWJlci5pc0ludGVnZXIoK2lucHV0KSAmJiAoK2lucHV0IDwgMSB8fCAraW5wdXQgPj0gMjU2KSkge1xuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJJbnZhbGlkIGFyZ3VtZW50IG9mIDp1cHdhcmQgcHNldWRvIGNsYXNzOiBcIi5jb25jYXQoaW5wdXQpKTtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIGZ1bmN0aW9uICgpIHtcbiAgICAgICAgcmV0dXJuIHRydWU7XG4gICAgICB9O1xuICAgIH0pO1xuICAgIFNpenpsZS5zZWxlY3RvcnMucHNldWRvc1sncmVtb3ZlJ10gPSBTaXp6bGUuc2VsZWN0b3JzLmNyZWF0ZVBzZXVkbyhmdW5jdGlvbiAoaW5wdXQpIHtcbiAgICAgIGlmIChpbnB1dCAhPT0gJycpIHtcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiSW52YWxpZCBhcmd1bWVudCBvZiA6cmVtb3ZlIHBzZXVkbyBjbGFzczogXCIuY29uY2F0KGlucHV0KSk7XG4gICAgICB9XG5cbiAgICAgIHJldHVybiBmdW5jdGlvbiAoKSB7XG4gICAgICAgIHJldHVybiB0cnVlO1xuICAgICAgfTtcbiAgICB9KTtcbiAgfVxuICAvKipcbiAgICogQ2hlY2tzIGlmIHNwZWNpZmllZCB0b2tlbiBjYW4gYmUgdXNlZCBieSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yQWxsLlxuICAgKi9cblxuXG4gIGZ1bmN0aW9uIGlzU2ltcGxlVG9rZW4odG9rZW4pIHtcbiAgICB2YXIgdHlwZSA9IHRva2VuLnR5cGU7XG5cbiAgICBpZiAodHlwZSA9PT0gJ0lEJyB8fCB0eXBlID09PSAnQ0xBU1MnIHx8IHR5cGUgPT09ICdBVFRSJyB8fCB0eXBlID09PSAnVEFHJyB8fCB0eXBlID09PSAnQ0hJTEQnKSB7XG4gICAgICAvLyBrbm93biBzaW1wbGUgdG9rZW5zXG4gICAgICByZXR1cm4gdHJ1ZTtcbiAgICB9XG5cbiAgICBpZiAodHlwZSA9PT0gJ1BTRVVETycpIHtcbiAgICAgIC8vIGNoZWNrIGlmIHZhbHVlIGNvbnRhaW5zIGFueSBvZiBleHRlbmRlZCBwc2V1ZG8gY2xhc3Nlc1xuICAgICAgdmFyIGkgPSBQU0VVRE9fRVhURU5TSU9OU19NQVJLRVJTLmxlbmd0aDtcblxuICAgICAgd2hpbGUgKGktLSkge1xuICAgICAgICBpZiAodG9rZW4udmFsdWUuaW5kZXhPZihQU0VVRE9fRVhURU5TSU9OU19NQVJLRVJTW2ldKSA+PSAwKSB7XG4gICAgICAgICAgcmV0dXJuIGZhbHNlO1xuICAgICAgICB9XG4gICAgICB9XG5cbiAgICAgIHJldHVybiB0cnVlO1xuICAgIH0gLy8gYWxsIG90aGVycyBhcmVuJ3Qgc2ltcGxlXG5cblxuICAgIHJldHVybiBmYWxzZTtcbiAgfVxuICAvKipcbiAgICogQ2hlY2tzIGlmIHNwZWNpZmllZCB0b2tlbiBpcyBhIGNvbWJpbmF0b3JcbiAgICovXG5cblxuICBmdW5jdGlvbiBpc1JlbGF0aW9uVG9rZW4odG9rZW4pIHtcbiAgICB2YXIgdHlwZSA9IHRva2VuLnR5cGU7XG4gICAgcmV0dXJuIHR5cGUgPT09ICcgJyB8fCB0eXBlID09PSAnPicgfHwgdHlwZSA9PT0gJysnIHx8IHR5cGUgPT09ICd+JztcbiAgfVxuICAvKipcbiAgICogRXh0ZW5kZWRTZWxlY3RvclBhcnNlciBpcyBhIGhlbHBlciBjbGFzcyBmb3IgY3JlYXRpbmcgdmFyaW91cyBzZWxlY3RvciBpbnN0YW5jZXMgd2hpY2hcbiAgICogYWxsIHNoYXJlcyBhIG1ldGhvZCBgcXVlcnlTZWxlY3RvckFsbCgpYCBhbmQgYG1hdGNoZXMoKWAgaW1wbGVtZW50aW5nIGRpZmZlcmVudCBzZWFyY2ggc3RyYXRlZ2llc1xuICAgKiBkZXBlbmRpbmcgb24gYSB0eXBlIG9mIHNlbGVjdG9yLlxuICAgKlxuICAgKiBDdXJyZW50bHksIHRoZXJlIGFyZSAzIHR5cGVzOlxuICAgKiAgQSB0cmFpdC1sZXNzIGV4dGVuZGVkIHNlbGVjdG9yXG4gICAqICAgIC0gd2UgZGlyZWN0bHkgZmVlZCBzZWxlY3RvciBzdHJpbmdzIHRvIFNpenpsZS5cbiAgICogIEEgc3BsaXR0ZWQgZXh0ZW5kZWQgc2VsZWN0b3JcbiAgICogICAgLSBzdWNoIGFzICNjb250YWluZXIgI2ZlZWRJdGVtOmhhcyguYWRzKSwgd2hlcmUgaXQgaXMgc3BsaXR0ZWQgdG8gYCNjb250YWluZXJgIGFuZCBgI2ZlZWRJdGVtOmhhcyguYWRzKWAuXG4gICAqL1xuXG5cbiAgZnVuY3Rpb24gRXh0ZW5kZWRTZWxlY3RvclBhcnNlcihzZWxlY3RvclRleHQsIHRva2VucywgZGVidWcpIHtcbiAgICBpbml0aWFsaXplKCk7XG5cbiAgICBpZiAodHlwZW9mIHRva2VucyA9PT0gJ3VuZGVmaW5lZCcpIHtcbiAgICAgIHRoaXMuc2VsZWN0b3JUZXh0ID0gY3NzVXRpbHMubm9ybWFsaXplKHNlbGVjdG9yVGV4dCk7IC8vIFBhc3NpbmcgYHJldHVyblVuc29ydGVkYCBpbiBvcmRlciB0byByZWNlaXZlIHRva2VucyBpbiB0aGUgb3JkZXIgdGhhdCdzIHZhbGlkIGZvciB0aGUgYnJvd3NlclxuICAgICAgLy8gSW4gU2l6emxlIGludGVybmFsbHksIHRoZSB0b2tlbnMgYXJlIHJlLXNvcnRlZDogaHR0cHM6Ly9naXRodWIuY29tL0FkZ3VhcmRUZWFtL0V4dGVuZGVkQ3NzL2lzc3Vlcy81NVxuXG4gICAgICB0aGlzLnRva2VucyA9IFNpenpsZS50b2tlbml6ZSh0aGlzLnNlbGVjdG9yVGV4dCwgZmFsc2UsIHtcbiAgICAgICAgcmV0dXJuVW5zb3J0ZWQ6IHRydWVcbiAgICAgIH0pO1xuICAgIH0gZWxzZSB7XG4gICAgICB0aGlzLnNlbGVjdG9yVGV4dCA9IHNlbGVjdG9yVGV4dDtcbiAgICAgIHRoaXMudG9rZW5zID0gdG9rZW5zO1xuICAgIH1cblxuICAgIGlmIChkZWJ1ZyA9PT0gdHJ1ZSkge1xuICAgICAgdGhpcy5kZWJ1ZyA9IHRydWU7XG4gICAgfVxuICB9XG5cbiAgRXh0ZW5kZWRTZWxlY3RvclBhcnNlci5wcm90b3R5cGUgPSB7XG4gICAgLyoqXG4gICAgICogVGhlIG1haW4gbWV0aG9kLCBjcmVhdGVzIGEgc2VsZWN0b3IgaW5zdGFuY2UgZGVwZW5kaW5nIG9uIHRoZSB0eXBlIG9mIGEgc2VsZWN0b3IuXG4gICAgICogQHB1YmxpY1xuICAgICAqL1xuICAgIGNyZWF0ZVNlbGVjdG9yOiBmdW5jdGlvbiBjcmVhdGVTZWxlY3RvcigpIHtcbiAgICAgIHZhciBkZWJ1ZyA9IHRoaXMuZGVidWc7XG4gICAgICB2YXIgdG9rZW5zID0gdGhpcy50b2tlbnM7XG4gICAgICB2YXIgc2VsZWN0b3JUZXh0ID0gdGhpcy5zZWxlY3RvclRleHQ7XG5cbiAgICAgIGlmICh0b2tlbnMubGVuZ3RoICE9PSAxKSB7XG4gICAgICAgIC8vIENvbW1hLXNlcGFyYXRlIHNlbGVjdG9yIC0gY2FuJ3Qgb3B0aW1pemUgZnVydGhlclxuICAgICAgICByZXR1cm4gbmV3IFRyYWl0TGVzc1NlbGVjdG9yKHNlbGVjdG9yVGV4dCwgZGVidWcpO1xuICAgICAgfVxuXG4gICAgICB2YXIgeHBhdGhQYXJ0ID0gdGhpcy5nZXRYcGF0aFBhcnQoKTtcblxuICAgICAgaWYgKHR5cGVvZiB4cGF0aFBhcnQgIT09ICd1bmRlZmluZWQnKSB7XG4gICAgICAgIHJldHVybiBuZXcgWHBhdGhTZWxlY3RvcihzZWxlY3RvclRleHQsIHhwYXRoUGFydCwgZGVidWcpO1xuICAgICAgfVxuXG4gICAgICB2YXIgdXB3YXJkUGFydCA9IHRoaXMuZ2V0VXB3YXJkUGFydCgpO1xuXG4gICAgICBpZiAodHlwZW9mIHVwd2FyZFBhcnQgIT09ICd1bmRlZmluZWQnKSB7XG4gICAgICAgIHZhciBvdXRwdXQ7XG4gICAgICAgIHZhciB1cHdhcmREZWVwID0gcGFyc2VJbnQodXB3YXJkUGFydCwgMTApOyAvLyBpZiB1cHdhcmQgcGFyYW1ldGVyIGlzIG5vdCBhIG51bWJlciwgd2UgY29uc2lkZXIgaXQgYXMgYSBzZWxlY3RvclxuXG4gICAgICAgIGlmIChOdW1iZXIuaXNOYU4odXB3YXJkRGVlcCkpIHtcbiAgICAgICAgICBvdXRwdXQgPSBuZXcgVXB3YXJkU2VsZWN0b3Ioc2VsZWN0b3JUZXh0LCB1cHdhcmRQYXJ0LCBkZWJ1Zyk7XG4gICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgLy8gdXB3YXJkIHdvcmtzIGxpa2UgbnRoLWFuY2VzdG9yXG4gICAgICAgICAgdmFyIHhwYXRoID0gdGhpcy5jb252ZXJ0TnRoQW5jZXN0b3JUb2tlbih1cHdhcmREZWVwKTtcbiAgICAgICAgICBvdXRwdXQgPSBuZXcgWHBhdGhTZWxlY3RvcihzZWxlY3RvclRleHQsIHhwYXRoLCBkZWJ1Zyk7XG4gICAgICAgIH1cblxuICAgICAgICByZXR1cm4gb3V0cHV0O1xuICAgICAgfSAvLyBhcmd1bWVudCBvZiBwc2V1ZG8tY2xhc3MgcmVtb3ZlO1xuICAgICAgLy8gaXQncyBkZWZpbmVkIG9ubHkgaWYgcmVtb3ZlIGlzIHBhcnNlZCBhcyBsYXN0IHRva2VuXG4gICAgICAvLyBhbmQgaXQncyB2YWxpZCBvbmx5IGlmIHJlbW92ZSBhcmcgaXMgZW1wdHkgc3RyaW5nXG5cblxuICAgICAgdmFyIHJlbW92ZVBhcnQgPSB0aGlzLmdldFJlbW92ZVBhcnQoKTtcblxuICAgICAgaWYgKHR5cGVvZiByZW1vdmVQYXJ0ICE9PSAndW5kZWZpbmVkJykge1xuICAgICAgICB2YXIgaGFzVmFsaWRSZW1vdmVQYXJ0ID0gcmVtb3ZlUGFydCA9PT0gJyc7XG4gICAgICAgIHJldHVybiBuZXcgUmVtb3ZlU2VsZWN0b3Ioc2VsZWN0b3JUZXh0LCBoYXNWYWxpZFJlbW92ZVBhcnQsIGRlYnVnKTtcbiAgICAgIH1cblxuICAgICAgdG9rZW5zID0gdG9rZW5zWzBdO1xuICAgICAgdmFyIGwgPSB0b2tlbnMubGVuZ3RoO1xuICAgICAgdmFyIGxhc3RSZWxUb2tlbkluZCA9IHRoaXMuZ2V0U3BsaXRQb2ludCgpO1xuXG4gICAgICBpZiAodHlwZW9mIGxhc3RSZWxUb2tlbkluZCA9PT0gJ3VuZGVmaW5lZCcpIHtcbiAgICAgICAgdHJ5IHtcbiAgICAgICAgICBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKHNlbGVjdG9yVGV4dCk7XG4gICAgICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgICAgICByZXR1cm4gbmV3IFRyYWl0TGVzc1NlbGVjdG9yKHNlbGVjdG9yVGV4dCwgZGVidWcpO1xuICAgICAgICB9XG5cbiAgICAgICAgcmV0dXJuIG5ldyBOb3RBbkV4dGVuZGVkU2VsZWN0b3Ioc2VsZWN0b3JUZXh0LCBkZWJ1Zyk7XG4gICAgICB9XG5cbiAgICAgIHZhciBzaW1wbGUgPSAnJztcbiAgICAgIHZhciByZWxhdGlvbiA9IG51bGw7XG4gICAgICB2YXIgY29tcGxleCA9ICcnO1xuICAgICAgdmFyIGkgPSAwO1xuXG4gICAgICBmb3IgKDsgaSA8IGxhc3RSZWxUb2tlbkluZDsgaSsrKSB7XG4gICAgICAgIC8vIGJ1aWxkIHNpbXBsZSBwYXJ0XG4gICAgICAgIHNpbXBsZSArPSB0b2tlbnNbaV0udmFsdWU7XG4gICAgICB9XG5cbiAgICAgIGlmIChpID4gMCkge1xuICAgICAgICAvLyBidWlsZCByZWxhdGlvbiBwYXJ0XG4gICAgICAgIHJlbGF0aW9uID0gdG9rZW5zW2krK10udHlwZTtcbiAgICAgIH0gLy8gaSBpcyBwb2ludGluZyB0byB0aGUgc3RhcnQgb2YgYSBjb21wbGV4IHBhcnQuXG5cblxuICAgICAgZm9yICg7IGkgPCBsOyBpKyspIHtcbiAgICAgICAgY29tcGxleCArPSB0b2tlbnNbaV0udmFsdWU7XG4gICAgICB9XG5cbiAgICAgIHJldHVybiBsYXN0UmVsVG9rZW5JbmQgPT09IC0xID8gbmV3IFRyYWl0TGVzc1NlbGVjdG9yKHNlbGVjdG9yVGV4dCwgZGVidWcpIDogbmV3IFNwbGl0dGVkU2VsZWN0b3Ioc2VsZWN0b3JUZXh0LCBzaW1wbGUsIHJlbGF0aW9uLCBjb21wbGV4LCBkZWJ1Zyk7XG4gICAgfSxcblxuICAgIC8qKlxuICAgICAqIEBwcml2YXRlXG4gICAgICogQHJldHVybiB7bnVtYmVyfHVuZGVmaW5lZH0gQW4gaW5kZXggb2YgYSB0b2tlbiB0aGF0IGlzIHNwbGl0IHBvaW50LlxuICAgICAqIHJldHVybnMgdW5kZWZpbmVkIGlmIHRoZSBzZWxlY3RvciBkb2VzIG5vdCBjb250YWluIGFueSBjb21wbGV4IHRva2Vuc1xuICAgICAqIG9yIGl0IGlzIG5vdCBlbGlnaWJsZSBmb3Igc3BsaXR0aW5nLlxuICAgICAqIE90aGVyd2lzZSByZXR1cm5zIGFuIGludGVnZXIgaW5kaWNhdGluZyB0aGUgaW5kZXggb2YgdGhlIGxhc3QgcmVsYXRpb24gdG9rZW4uXG4gICAgICovXG4gICAgZ2V0U3BsaXRQb2ludDogZnVuY3Rpb24gZ2V0U3BsaXRQb2ludCgpIHtcbiAgICAgIHZhciB0b2tlbnMgPSB0aGlzLnRva2Vuc1swXTsgLy8gV2Ugc3BsaXQgc2VsZWN0b3Igb25seSB3aGVuIHRoZSBsYXN0IGNvbXBvdW5kIHNlbGVjdG9yXG4gICAgICAvLyBpcyB0aGUgb25seSBleHRlbmRlZCBzZWxlY3Rvci5cblxuICAgICAgdmFyIGxhdGVzdFJlbGF0aW9uVG9rZW5JbmRleCA9IC0xO1xuICAgICAgdmFyIGhhdmVNZXRDb21wbGV4VG9rZW4gPSBmYWxzZTtcblxuICAgICAgZm9yICh2YXIgaSA9IDAsIGwgPSB0b2tlbnMubGVuZ3RoOyBpIDwgbDsgaSsrKSB7XG4gICAgICAgIHZhciB0b2tlbiA9IHRva2Vuc1tpXTtcblxuICAgICAgICBpZiAoaXNSZWxhdGlvblRva2VuKHRva2VuKSkge1xuICAgICAgICAgIGlmIChoYXZlTWV0Q29tcGxleFRva2VuKSB7XG4gICAgICAgICAgICByZXR1cm47XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgbGF0ZXN0UmVsYXRpb25Ub2tlbkluZGV4ID0gaTtcbiAgICAgICAgfSBlbHNlIGlmICghaXNTaW1wbGVUb2tlbih0b2tlbikpIHtcbiAgICAgICAgICBoYXZlTWV0Q29tcGxleFRva2VuID0gdHJ1ZTtcbiAgICAgICAgfVxuICAgICAgfVxuXG4gICAgICBpZiAoIWhhdmVNZXRDb21wbGV4VG9rZW4pIHtcbiAgICAgICAgcmV0dXJuO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gbGF0ZXN0UmVsYXRpb25Ub2tlbkluZGV4O1xuICAgIH0sXG5cbiAgICAvKipcbiAgICAgKiBAcHJpdmF0ZVxuICAgICAqIEByZXR1cm4ge3N0cmluZ3x1bmRlZmluZWR9IHhwYXRoIHNlbGVjdG9yIHBhcnQgaWYgZXhpc3RzXG4gICAgICogcmV0dXJucyB1bmRlZmluZWQgaWYgdGhlIHNlbGVjdG9yIGRvZXMgbm90IGNvbnRhaW4geHBhdGggdG9rZW5zXG4gICAgICovXG4gICAgZ2V0WHBhdGhQYXJ0OiBmdW5jdGlvbiBnZXRYcGF0aFBhcnQoKSB7XG4gICAgICB2YXIgdG9rZW5zID0gdGhpcy50b2tlbnNbMF07XG5cbiAgICAgIGZvciAodmFyIGkgPSAwLCB0b2tlbnNMZW5ndGggPSB0b2tlbnMubGVuZ3RoOyBpIDwgdG9rZW5zTGVuZ3RoOyBpKyspIHtcbiAgICAgICAgdmFyIHRva2VuID0gdG9rZW5zW2ldO1xuXG4gICAgICAgIGlmICh0b2tlbi50eXBlID09PSAnUFNFVURPJykge1xuICAgICAgICAgIHZhciBtYXRjaGVzID0gdG9rZW4ubWF0Y2hlcztcblxuICAgICAgICAgIGlmIChtYXRjaGVzICYmIG1hdGNoZXMubGVuZ3RoID4gMSkge1xuICAgICAgICAgICAgaWYgKG1hdGNoZXNbMF0gPT09ICd4cGF0aCcpIHtcbiAgICAgICAgICAgICAgaWYgKHRoaXMuaXNMYXN0VG9rZW4odG9rZW5zLCBpKSkge1xuICAgICAgICAgICAgICAgIHRocm93IG5ldyBFcnJvcignSW52YWxpZCBwc2V1ZG86IFxcJzp4cGF0aFxcJyBzaG91bGQgYmUgYXQgdGhlIGVuZCBvZiB0aGUgc2VsZWN0b3InKTtcbiAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgIHJldHVybiBtYXRjaGVzWzFdO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICBpZiAobWF0Y2hlc1swXSA9PT0gJ250aC1hbmNlc3RvcicpIHtcbiAgICAgICAgICAgICAgaWYgKHRoaXMuaXNMYXN0VG9rZW4odG9rZW5zLCBpKSkge1xuICAgICAgICAgICAgICAgIHRocm93IG5ldyBFcnJvcignSW52YWxpZCBwc2V1ZG86IFxcJzpudGgtYW5jZXN0b3JcXCcgc2hvdWxkIGJlIGF0IHRoZSBlbmQgb2YgdGhlIHNlbGVjdG9yJyk7XG4gICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICB2YXIgZGVlcCA9IG1hdGNoZXNbMV07XG5cbiAgICAgICAgICAgICAgaWYgKGRlZXAgPiAwICYmIGRlZXAgPCAyNTYpIHtcbiAgICAgICAgICAgICAgICByZXR1cm4gdGhpcy5jb252ZXJ0TnRoQW5jZXN0b3JUb2tlbihkZWVwKTtcbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgfVxuICAgIH0sXG5cbiAgICAvKipcbiAgICAgKiBjb252ZXJ0cyBudGgtYW5jZXN0b3IvdXB3YXJkIGRlZXAgdmFsdWUgdG8geHBhdGggZXF1aXZhbGVudFxuICAgICAqIEBwYXJhbSB7bnVtYmVyfSBkZWVwXG4gICAgICogQHJldHVybiB7c3RyaW5nfVxuICAgICAqL1xuICAgIGNvbnZlcnROdGhBbmNlc3RvclRva2VuOiBmdW5jdGlvbiBjb252ZXJ0TnRoQW5jZXN0b3JUb2tlbihkZWVwKSB7XG4gICAgICB2YXIgcmVzdWx0ID0gJy4uJztcblxuICAgICAgd2hpbGUgKGRlZXAgPiAxKSB7XG4gICAgICAgIHJlc3VsdCArPSAnLy4uJztcbiAgICAgICAgZGVlcC0tO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gcmVzdWx0O1xuICAgIH0sXG5cbiAgICAvKipcbiAgICAgKiBDaGVja3MgaWYgdGhlIHRva2VuIGlzIGxhc3QsXG4gICAgICogZXhjZXB0IG9mIHJlbW92ZSBwc2V1ZG8tY2xhc3NcbiAgICAgKiBAcGFyYW0ge0FycmF5fSB0b2tlbnNcbiAgICAgKiBAcGFyYW0ge251bWJlcn0gaSBpbmRleCBvZiB0b2tlblxuICAgICAqIEByZXR1cm5zIHtib29sZWFufVxuICAgICAqL1xuICAgIGlzTGFzdFRva2VuOiBmdW5jdGlvbiBpc0xhc3RUb2tlbih0b2tlbnMsIGkpIHtcbiAgICAgIC8vIGNoZWNrIGlkIHRoZSBuZXh0IHBhcnNlZCB0b2tlbiBpcyByZW1vdmUgcHNldWRvXG4gICAgICB2YXIgaXNOZXh0UmVtb3ZlVG9rZW4gPSB0b2tlbnNbaSArIDFdICYmIHRva2Vuc1tpICsgMV0udHlwZSA9PT0gJ1BTRVVETycgJiYgdG9rZW5zW2kgKyAxXS5tYXRjaGVzICYmIHRva2Vuc1tpICsgMV0ubWF0Y2hlc1swXSA9PT0gJ3JlbW92ZSc7IC8vIGNoZWNrIGlmIHRoZSB0b2tlbiBpcyBsYXN0XG4gICAgICAvLyBhbmQgaWYgaXQgaXMgbm90IGNoZWNrIGlmIGl0IGlzIHJlbW92ZSBvbmVcbiAgICAgIC8vIHdoaWNoIHNob3VsZCBiZSBza2lwcGVkXG5cbiAgICAgIHJldHVybiBpICsgMSAhPT0gdG9rZW5zLmxlbmd0aCAmJiAhaXNOZXh0UmVtb3ZlVG9rZW47XG4gICAgfSxcblxuICAgIC8qKlxuICAgICAqIEBwcml2YXRlXG4gICAgICogQHJldHVybiB7c3RyaW5nfHVuZGVmaW5lZH0gdXB3YXJkIHBhcmFtZXRlclxuICAgICAqIG9yIHVuZGVmaW5lZCBpZiB0aGUgaW5wdXQgZG9lcyBub3QgY29udGFpbiB1cHdhcmQgdG9rZW5zXG4gICAgICovXG4gICAgZ2V0VXB3YXJkUGFydDogZnVuY3Rpb24gZ2V0VXB3YXJkUGFydCgpIHtcbiAgICAgIHZhciB0b2tlbnMgPSB0aGlzLnRva2Vuc1swXTtcblxuICAgICAgZm9yICh2YXIgaSA9IDAsIHRva2Vuc0xlbmd0aCA9IHRva2Vucy5sZW5ndGg7IGkgPCB0b2tlbnNMZW5ndGg7IGkrKykge1xuICAgICAgICB2YXIgdG9rZW4gPSB0b2tlbnNbaV07XG5cbiAgICAgICAgaWYgKHRva2VuLnR5cGUgPT09ICdQU0VVRE8nKSB7XG4gICAgICAgICAgdmFyIG1hdGNoZXMgPSB0b2tlbi5tYXRjaGVzO1xuXG4gICAgICAgICAgaWYgKG1hdGNoZXMgJiYgbWF0Y2hlcy5sZW5ndGggPiAxKSB7XG4gICAgICAgICAgICBpZiAobWF0Y2hlc1swXSA9PT0gJ3Vwd2FyZCcpIHtcbiAgICAgICAgICAgICAgaWYgKHRoaXMuaXNMYXN0VG9rZW4odG9rZW5zLCBpKSkge1xuICAgICAgICAgICAgICAgIHRocm93IG5ldyBFcnJvcignSW52YWxpZCBwc2V1ZG86IFxcJzp1cHdhcmRcXCcgc2hvdWxkIGJlIGF0IHRoZSBlbmQgb2YgdGhlIHNlbGVjdG9yJyk7XG4gICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICByZXR1cm4gbWF0Y2hlc1sxXTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICB9LFxuXG4gICAgLyoqXG4gICAgICogQHByaXZhdGVcbiAgICAgKiBAcmV0dXJuIHtzdHJpbmd8dW5kZWZpbmVkfSByZW1vdmUgcGFyYW1ldGVyXG4gICAgICogb3IgdW5kZWZpbmVkIGlmIHRoZSBpbnB1dCBkb2VzIG5vdCBjb250YWluIHJlbW92ZSB0b2tlbnNcbiAgICAgKi9cbiAgICBnZXRSZW1vdmVQYXJ0OiBmdW5jdGlvbiBnZXRSZW1vdmVQYXJ0KCkge1xuICAgICAgdmFyIHRva2VucyA9IHRoaXMudG9rZW5zWzBdO1xuXG4gICAgICBmb3IgKHZhciBpID0gMCwgdG9rZW5zTGVuZ3RoID0gdG9rZW5zLmxlbmd0aDsgaSA8IHRva2Vuc0xlbmd0aDsgaSsrKSB7XG4gICAgICAgIHZhciB0b2tlbiA9IHRva2Vuc1tpXTtcblxuICAgICAgICBpZiAodG9rZW4udHlwZSA9PT0gJ1BTRVVETycpIHtcbiAgICAgICAgICB2YXIgbWF0Y2hlcyA9IHRva2VuLm1hdGNoZXM7XG5cbiAgICAgICAgICBpZiAobWF0Y2hlcyAmJiBtYXRjaGVzLmxlbmd0aCA+IDEpIHtcbiAgICAgICAgICAgIGlmIChtYXRjaGVzWzBdID09PSAncmVtb3ZlJykge1xuICAgICAgICAgICAgICBpZiAoaSArIDEgIT09IHRva2Vuc0xlbmd0aCkge1xuICAgICAgICAgICAgICAgIHRocm93IG5ldyBFcnJvcignSW52YWxpZCBwc2V1ZG86IFxcJzpyZW1vdmVcXCcgc2hvdWxkIGJlIGF0IHRoZSBlbmQgb2YgdGhlIHNlbGVjdG9yJyk7XG4gICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICByZXR1cm4gbWF0Y2hlc1sxXTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICB9XG4gIH07XG4gIHZhciBnbG9iYWxEZWJ1Z2dpbmdGbGFnID0gZmFsc2U7XG5cbiAgZnVuY3Rpb24gaXNEZWJ1Z2dpbmcoKSB7XG4gICAgcmV0dXJuIGdsb2JhbERlYnVnZ2luZ0ZsYWcgfHwgdGhpcy5kZWJ1ZztcbiAgfVxuICAvKipcbiAgICogVGhpcyBjbGFzcyByZXByZXNlbnRzIGEgc2VsZWN0b3Igd2hpY2ggaXMgbm90IGFuIGV4dGVuZGVkIHNlbGVjdG9yLlxuICAgKiBAcGFyYW0ge3N0cmluZ30gc2VsZWN0b3JUZXh0XG4gICAqIEBwYXJhbSB7Ym9vbGVhbj19IGRlYnVnXG4gICAqIEBmaW5hbFxuICAgKi9cblxuXG4gIGZ1bmN0aW9uIE5vdEFuRXh0ZW5kZWRTZWxlY3RvcihzZWxlY3RvclRleHQsIGRlYnVnKSB7XG4gICAgdGhpcy5zZWxlY3RvclRleHQgPSBzZWxlY3RvclRleHQ7XG4gICAgdGhpcy5kZWJ1ZyA9IGRlYnVnO1xuICB9XG5cbiAgTm90QW5FeHRlbmRlZFNlbGVjdG9yLnByb3RvdHlwZSA9IHtcbiAgICBxdWVyeVNlbGVjdG9yQWxsOiBmdW5jdGlvbiBxdWVyeVNlbGVjdG9yQWxsKCkge1xuICAgICAgcmV0dXJuIGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3JBbGwodGhpcy5zZWxlY3RvclRleHQpO1xuICAgIH0sXG4gICAgbWF0Y2hlczogZnVuY3Rpb24gbWF0Y2hlcyhlbGVtZW50KSB7XG4gICAgICByZXR1cm4gZWxlbWVudFt1dGlscy5tYXRjaGVzUHJvcGVydHlOYW1lXSh0aGlzLnNlbGVjdG9yVGV4dCk7XG4gICAgfSxcbiAgICBpc0RlYnVnZ2luZzogaXNEZWJ1Z2dpbmdcbiAgfTtcbiAgLyoqXG4gICAqIEEgdHJhaXQtbGVzcyBleHRlbmRlZCBzZWxlY3RvciBjbGFzcy5cbiAgICogQHBhcmFtIHtzdHJpbmd9IHNlbGVjdG9yVGV4dFxuICAgKiBAcGFyYW0ge2Jvb2xlYW49fSBkZWJ1Z1xuICAgKiBAY29uc3RydWN0b3JcbiAgICovXG5cbiAgZnVuY3Rpb24gVHJhaXRMZXNzU2VsZWN0b3Ioc2VsZWN0b3JUZXh0LCBkZWJ1Zykge1xuICAgIHRoaXMuc2VsZWN0b3JUZXh0ID0gc2VsZWN0b3JUZXh0O1xuICAgIHRoaXMuZGVidWcgPSBkZWJ1ZztcbiAgICBTaXp6bGUuY29tcGlsZShzZWxlY3RvclRleHQpO1xuICB9XG5cbiAgVHJhaXRMZXNzU2VsZWN0b3IucHJvdG90eXBlID0ge1xuICAgIHF1ZXJ5U2VsZWN0b3JBbGw6IGZ1bmN0aW9uIHF1ZXJ5U2VsZWN0b3JBbGwoKSB7XG4gICAgICByZXR1cm4gU2l6emxlKHRoaXMuc2VsZWN0b3JUZXh0KTtcbiAgICB9LFxuXG4gICAgLyoqIEBmaW5hbCAqL1xuICAgIG1hdGNoZXM6IGZ1bmN0aW9uIG1hdGNoZXMoZWxlbWVudCkge1xuICAgICAgcmV0dXJuIFNpenpsZS5tYXRjaGVzU2VsZWN0b3IoZWxlbWVudCwgdGhpcy5zZWxlY3RvclRleHQpO1xuICAgIH0sXG5cbiAgICAvKiogQGZpbmFsICovXG4gICAgaXNEZWJ1Z2dpbmc6IGlzRGVidWdnaW5nXG4gIH07XG4gIC8qKlxuICAgKiBQYXJlbnRhbCBjbGFzcyBmb3Igc3VjaCBwc2V1ZG8tY2xhc3NlcyBhcyB4cGF0aCwgdXB3YXJkLCByZW1vdmVcbiAgICogd2hpY2ggYXJlIGxpbWl0ZWQgdG8gYmUgdGhlIGxhc3Qgb25lIHRva2VuIGluIHNlbGVjdG9yXG4gICAqXG4gICAqIEBwYXJhbSB7c3RyaW5nfSBzZWxlY3RvclRleHRcbiAgICogQHBhcmFtIHtzdHJpbmd9IHBzZXVkb0NsYXNzQXJnIHBzZXVkby1jbGFzcyBhcmdcbiAgICogQHBhcmFtIHtib29sZWFuPX0gZGVidWdcbiAgICogQGNvbnN0cnVjdG9yXG4gICAqL1xuXG4gIGZ1bmN0aW9uIEJhc2VMYXN0QXJndW1lbnRTZWxlY3RvcihzZWxlY3RvclRleHQsIHBzZXVkb0NsYXNzQXJnLCBkZWJ1Zykge1xuICAgIHRoaXMuc2VsZWN0b3JUZXh0ID0gc2VsZWN0b3JUZXh0O1xuICAgIHRoaXMucHNldWRvQ2xhc3NBcmcgPSBwc2V1ZG9DbGFzc0FyZztcbiAgICB0aGlzLmRlYnVnID0gZGVidWc7XG4gICAgU2l6emxlLmNvbXBpbGUodGhpcy5zZWxlY3RvclRleHQpO1xuICB9XG5cbiAgQmFzZUxhc3RBcmd1bWVudFNlbGVjdG9yLnByb3RvdHlwZSA9IHtcbiAgICBxdWVyeVNlbGVjdG9yQWxsOiBmdW5jdGlvbiBxdWVyeVNlbGVjdG9yQWxsKCkge1xuICAgICAgdmFyIF90aGlzID0gdGhpcztcblxuICAgICAgdmFyIHJlc3VsdE5vZGVzID0gW107XG4gICAgICB2YXIgc2ltcGxlTm9kZXM7XG5cbiAgICAgIGlmICh0aGlzLnNlbGVjdG9yVGV4dCkge1xuICAgICAgICBzaW1wbGVOb2RlcyA9IFNpenpsZSh0aGlzLnNlbGVjdG9yVGV4dCk7XG5cbiAgICAgICAgaWYgKCFzaW1wbGVOb2RlcyB8fCAhc2ltcGxlTm9kZXMubGVuZ3RoKSB7XG4gICAgICAgICAgcmV0dXJuIHJlc3VsdE5vZGVzO1xuICAgICAgICB9XG4gICAgICB9IGVsc2Uge1xuICAgICAgICBzaW1wbGVOb2RlcyA9IFtkb2N1bWVudF07XG4gICAgICB9XG5cbiAgICAgIHNpbXBsZU5vZGVzLmZvckVhY2goZnVuY3Rpb24gKG5vZGUpIHtcbiAgICAgICAgX3RoaXMuc2VhcmNoUmVzdWx0Tm9kZXMobm9kZSwgX3RoaXMucHNldWRvQ2xhc3NBcmcsIHJlc3VsdE5vZGVzKTtcbiAgICAgIH0pO1xuICAgICAgcmV0dXJuIFNpenpsZS51bmlxdWVTb3J0KHJlc3VsdE5vZGVzKTtcbiAgICB9LFxuXG4gICAgLyoqIEBmaW5hbCAqL1xuICAgIG1hdGNoZXM6IGZ1bmN0aW9uIG1hdGNoZXMoZWxlbWVudCkge1xuICAgICAgdmFyIHJlc3VsdHMgPSB0aGlzLnF1ZXJ5U2VsZWN0b3JBbGwoKTtcbiAgICAgIHJldHVybiByZXN1bHRzLmluZGV4T2YoZWxlbWVudCkgPiAtMTtcbiAgICB9LFxuXG4gICAgLyoqIEBmaW5hbCAqL1xuICAgIGlzRGVidWdnaW5nOiBpc0RlYnVnZ2luZyxcblxuICAgIC8qKlxuICAgICAqIFByaW1pdGl2ZSBtZXRob2QgdGhhdCByZXR1cm5zIGFsbCBub2RlcyBpZiBwc2V1ZG8tY2xhc3MgYXJnIGlzIGRlZmluZWQuXG4gICAgICogVGhhdCBsb2dpYyB3b3JrcyBmb3IgcmVtb3ZlIHBzZXVkby1jbGFzcyxcbiAgICAgKiBidXQgZm9yIG90aGVycyBpdCBzaG91bGQgYmUgb3ZlcnJpZGRlbi5cbiAgICAgKiBAcGFyYW0ge09iamVjdH0gbm9kZSBjb250ZXh0IGVsZW1lbnRcbiAgICAgKiBAcGFyYW0ge3N0cmluZ30gcHNldWRvQ2xhc3NBcmcgcHNldWRvLWNsYXNzIGFyZ3VtZW50XG4gICAgICogQHBhcmFtIHtBcnJheX0gcmVzdWx0XG4gICAgICovXG4gICAgc2VhcmNoUmVzdWx0Tm9kZXM6IGZ1bmN0aW9uIHNlYXJjaFJlc3VsdE5vZGVzKG5vZGUsIHBzZXVkb0NsYXNzQXJnLCByZXN1bHQpIHtcbiAgICAgIGlmIChwc2V1ZG9DbGFzc0FyZykge1xuICAgICAgICByZXN1bHQucHVzaChub2RlKTtcbiAgICAgIH1cbiAgICB9XG4gIH07XG4gIC8qKlxuICAgKiBYcGF0aCBzZWxlY3RvciBjbGFzc1xuICAgKiBMaW1pdGVkIHRvIHN1cHBvcnQgJ3hwYXRoJyB0byBiZSBvbmx5IHRoZSBsYXN0IG9uZSB0b2tlbiBpbiBzZWxlY3RvclxuICAgKiBAcGFyYW0ge3N0cmluZ30gc2VsZWN0b3JUZXh0XG4gICAqIEBwYXJhbSB7c3RyaW5nfSB4cGF0aCB2YWx1ZVxuICAgKiBAcGFyYW0ge2Jvb2xlYW49fSBkZWJ1Z1xuICAgKiBAY29uc3RydWN0b3JcbiAgICogQGF1Z21lbnRzIEJhc2VMYXN0QXJndW1lbnRTZWxlY3RvclxuICAgKi9cblxuICBmdW5jdGlvbiBYcGF0aFNlbGVjdG9yKHNlbGVjdG9yVGV4dCwgeHBhdGgsIGRlYnVnKSB7XG4gICAgdmFyIE5PX1NFTEVDVE9SX01BUktFUiA9ICc6eHBhdGgoLy8nO1xuICAgIHZhciBCT0RZX1NFTEVDVE9SX1JFUExBQ0VSID0gJ2JvZHk6eHBhdGgoLy8nO1xuICAgIHZhciBtb2RpZmllZFNlbGVjdG9yVGV4dCA9IHNlbGVjdG9yVGV4dDsgLy8gTm9ybWFsbHksIGEgcHNldWRvLWNsYXNzIGlzIGFwcGxpZWQgdG8gbm9kZXMgc2VsZWN0ZWQgYnkgYSBzZWxlY3RvciAtLSBzZWxlY3Rvcjp4cGF0aCguLi4pLlxuICAgIC8vIEhvd2V2ZXIsIDp4cGF0aCBpcyBzcGVjaWFsIGFzIHRoZSBzZWxlY3RvciBjYW4gYmUgb21taXRlZC5cbiAgICAvLyBGb3IgYW55IG90aGVyIHBzZXVkby1jbGFzcyB0aGF0IHdvdWxkIG1lYW4gXCJhcHBseSB0byBBTEwgRE9NIG5vZGVzXCIsXG4gICAgLy8gYnV0IGluIGNhc2Ugb2YgOnhwYXRoIGl0IGp1c3QgbWVhbnMgXCJhcHBseSBtZSB0byB0aGUgZG9jdW1lbnRcIi5cblxuICAgIGlmICh1dGlscy5zdGFydHNXaXRoKHNlbGVjdG9yVGV4dCwgTk9fU0VMRUNUT1JfTUFSS0VSKSkge1xuICAgICAgbW9kaWZpZWRTZWxlY3RvclRleHQgPSBzZWxlY3RvclRleHQucmVwbGFjZShOT19TRUxFQ1RPUl9NQVJLRVIsIEJPRFlfU0VMRUNUT1JfUkVQTEFDRVIpO1xuICAgIH1cblxuICAgIEJhc2VMYXN0QXJndW1lbnRTZWxlY3Rvci5jYWxsKHRoaXMsIG1vZGlmaWVkU2VsZWN0b3JUZXh0LCB4cGF0aCwgZGVidWcpO1xuICB9XG5cbiAgWHBhdGhTZWxlY3Rvci5wcm90b3R5cGUgPSBPYmplY3QuY3JlYXRlKEJhc2VMYXN0QXJndW1lbnRTZWxlY3Rvci5wcm90b3R5cGUpO1xuICBYcGF0aFNlbGVjdG9yLnByb3RvdHlwZS5jb25zdHJ1Y3RvciA9IFhwYXRoU2VsZWN0b3I7XG4gIC8qKlxuICAgKiBBcHBsaWVzIHhwYXRoIHBzZXVkby1jbGFzcyB0byBwcm92aWRlZCBjb250ZXh0IG5vZGVcbiAgICogQHBhcmFtIHtPYmplY3R9IG5vZGUgY29udGV4dCBlbGVtZW50XG4gICAqIEBwYXJhbSB7c3RyaW5nfSBwc2V1ZG9DbGFzc0FyZyB4cGF0aFxuICAgKiBAcGFyYW0ge0FycmF5fSByZXN1bHRcbiAgICogQG92ZXJyaWRlXG4gICAqL1xuXG4gIFhwYXRoU2VsZWN0b3IucHJvdG90eXBlLnNlYXJjaFJlc3VsdE5vZGVzID0gZnVuY3Rpb24gKG5vZGUsIHBzZXVkb0NsYXNzQXJnLCByZXN1bHQpIHtcbiAgICB2YXIgeHBhdGhSZXN1bHQgPSBkb2N1bWVudC5ldmFsdWF0ZShwc2V1ZG9DbGFzc0FyZywgbm9kZSwgbnVsbCwgWFBhdGhSZXN1bHQuVU5PUkRFUkVEX05PREVfSVRFUkFUT1JfVFlQRSwgbnVsbCk7XG4gICAgdmFyIGlOb2RlOyAvLyBlc2xpbnQtZGlzYWJsZS1uZXh0LWxpbmUgbm8tY29uZC1hc3NpZ25cblxuICAgIHdoaWxlIChpTm9kZSA9IHhwYXRoUmVzdWx0Lml0ZXJhdGVOZXh0KCkpIHtcbiAgICAgIHJlc3VsdC5wdXNoKGlOb2RlKTtcbiAgICB9XG4gIH07XG4gIC8qKlxuICAgKiBVcHdhcmQgc2VsZWN0b3IgY2xhc3NcbiAgICogTGltaXRlZCB0byBzdXBwb3J0ICd1cHdhcmQnIHRvIGJlIG9ubHkgdGhlIGxhc3Qgb25lIHRva2VuIGluIHNlbGVjdG9yXG4gICAqIEBwYXJhbSB7c3RyaW5nfSBzZWxlY3RvclRleHRcbiAgICogQHBhcmFtIHtzdHJpbmd9IHVwd2FyZFNlbGVjdG9yIHZhbHVlXG4gICAqIEBwYXJhbSB7Ym9vbGVhbj19IGRlYnVnXG4gICAqIEBjb25zdHJ1Y3RvclxuICAgKiBAYXVnbWVudHMgQmFzZUxhc3RBcmd1bWVudFNlbGVjdG9yXG4gICAqL1xuXG5cbiAgZnVuY3Rpb24gVXB3YXJkU2VsZWN0b3Ioc2VsZWN0b3JUZXh0LCB1cHdhcmRTZWxlY3RvciwgZGVidWcpIHtcbiAgICBCYXNlTGFzdEFyZ3VtZW50U2VsZWN0b3IuY2FsbCh0aGlzLCBzZWxlY3RvclRleHQsIHVwd2FyZFNlbGVjdG9yLCBkZWJ1Zyk7XG4gIH1cblxuICBVcHdhcmRTZWxlY3Rvci5wcm90b3R5cGUgPSBPYmplY3QuY3JlYXRlKEJhc2VMYXN0QXJndW1lbnRTZWxlY3Rvci5wcm90b3R5cGUpO1xuICBVcHdhcmRTZWxlY3Rvci5wcm90b3R5cGUuY29uc3RydWN0b3IgPSBVcHdhcmRTZWxlY3RvcjtcbiAgLyoqXG4gICAqIEFwcGxpZXMgdXB3YXJkIHBzZXVkby1jbGFzcyB0byBwcm92aWRlZCBjb250ZXh0IG5vZGVcbiAgICogQHBhcmFtIHtPYmplY3R9IG5vZGUgY29udGV4dCBlbGVtZW50XG4gICAqIEBwYXJhbSB7c3RyaW5nfSB1cHdhcmRTZWxlY3RvciB1cHdhcmQgc2VsZWN0b3JcbiAgICogQHBhcmFtIHtBcnJheX0gcmVzdWx0XG4gICAqIEBvdmVycmlkZVxuICAgKi9cblxuICBVcHdhcmRTZWxlY3Rvci5wcm90b3R5cGUuc2VhcmNoUmVzdWx0Tm9kZXMgPSBmdW5jdGlvbiAobm9kZSwgdXB3YXJkU2VsZWN0b3IsIHJlc3VsdCkge1xuICAgIGlmICh1cHdhcmRTZWxlY3RvciAhPT0gJycpIHtcbiAgICAgIHZhciBwYXJlbnQgPSBub2RlLnBhcmVudEVsZW1lbnQ7XG5cbiAgICAgIGlmIChwYXJlbnQgPT09IG51bGwpIHtcbiAgICAgICAgcmV0dXJuO1xuICAgICAgfVxuXG4gICAgICBub2RlID0gcGFyZW50LmNsb3Nlc3QodXB3YXJkU2VsZWN0b3IpO1xuXG4gICAgICBpZiAobm9kZSA9PT0gbnVsbCkge1xuICAgICAgICByZXR1cm47XG4gICAgICB9XG4gICAgfVxuXG4gICAgcmVzdWx0LnB1c2gobm9kZSk7XG4gIH07XG4gIC8qKlxuICAgKiBSZW1vdmUgc2VsZWN0b3IgY2xhc3NcbiAgICogTGltaXRlZCB0byBzdXBwb3J0ICdyZW1vdmUnIHRvIGJlIG9ubHkgdGhlIGxhc3Qgb25lIHRva2VuIGluIHNlbGVjdG9yXG4gICAqIEBwYXJhbSB7c3RyaW5nfSBzZWxlY3RvclRleHRcbiAgICogQHBhcmFtIHtib29sZWFufSBoYXNWYWxpZFJlbW92ZVBhcnRcbiAgICogQHBhcmFtIHtib29sZWFuPX0gZGVidWdcbiAgICogQGNvbnN0cnVjdG9yXG4gICAqIEBhdWdtZW50cyBCYXNlTGFzdEFyZ3VtZW50U2VsZWN0b3JcbiAgICovXG5cblxuICBmdW5jdGlvbiBSZW1vdmVTZWxlY3RvcihzZWxlY3RvclRleHQsIGhhc1ZhbGlkUmVtb3ZlUGFydCwgZGVidWcpIHtcbiAgICB2YXIgUkVNT1ZFX1BTRVVET19NQVJLRVIgPSAnOnJlbW92ZSgpJztcbiAgICB2YXIgcmVtb3ZlTWFya2VySW5kZXggPSBzZWxlY3RvclRleHQuaW5kZXhPZihSRU1PVkVfUFNFVURPX01BUktFUik7IC8vIGRlbGV0aW5nIHJlbW92ZSBwYXJ0IG9mIHJ1bGUgaW5zdGVhZCBvZiB3aGljaFxuICAgIC8vIHBzZXVkby1wcm9wZXJ0eSBwcm9wZXJ0eSAncmVtb3ZlJyB3aWxsIGJlIGFkZGVkIGJ5IEV4dGVuZGVkQ3NzUGFyc2VyXG5cbiAgICB2YXIgbW9kaWZpZWRTZWxlY3RvclRleHQgPSBzZWxlY3RvclRleHQuc2xpY2UoMCwgcmVtb3ZlTWFya2VySW5kZXgpO1xuICAgIEJhc2VMYXN0QXJndW1lbnRTZWxlY3Rvci5jYWxsKHRoaXMsIG1vZGlmaWVkU2VsZWN0b3JUZXh0LCBoYXNWYWxpZFJlbW92ZVBhcnQsIGRlYnVnKTsgLy8gbWFyayBleHRlbmRlZFNlbGVjdG9yIGFzIFJlbW92ZSBvbmUgZm9yIEV4dGVuZGVkQ3NzUGFyc2VyXG5cbiAgICB0aGlzLmlzUmVtb3ZlU2VsZWN0b3IgPSB0cnVlO1xuICB9XG5cbiAgUmVtb3ZlU2VsZWN0b3IucHJvdG90eXBlID0gT2JqZWN0LmNyZWF0ZShCYXNlTGFzdEFyZ3VtZW50U2VsZWN0b3IucHJvdG90eXBlKTtcbiAgUmVtb3ZlU2VsZWN0b3IucHJvdG90eXBlLmNvbnN0cnVjdG9yID0gUmVtb3ZlU2VsZWN0b3I7XG4gIC8qKlxuICAgKiBBIHNwbGl0dGVkIGV4dGVuZGVkIHNlbGVjdG9yIGNsYXNzLlxuICAgKlxuICAgKiAjY29udGFpbmVyICNmZWVkSXRlbTpoYXMoLmFkcylcbiAgICogKy0tLS0tLS0tKyAgICAgICAgICAgICAgICAgICAgIHNpbXBsZVxuICAgKiAgICAgICAgICAgKyAgICAgICAgICAgICAgICAgICAgcmVsYXRpb25cbiAgICogICAgICAgICAgICArLS0tLS0tLS0tLS0tLS0tLS0rIGNvbXBsZXhcbiAgICogV2Ugc3BsaXQgc2VsZWN0b3Igb25seSB3aGVuIHRoZSBsYXN0IHNlbGVjdG9yIGlzIGNvbXBsZXhcbiAgICogQHBhcmFtIHtzdHJpbmd9IHNlbGVjdG9yVGV4dFxuICAgKiBAcGFyYW0ge3N0cmluZ30gc2ltcGxlXG4gICAqIEBwYXJhbSB7c3RyaW5nfSByZWxhdGlvblxuICAgKiBAcGFyYW0ge3N0cmluZ30gY29tcGxleFxuICAgKiBAcGFyYW0ge2Jvb2xlYW49fSBkZWJ1Z1xuICAgKiBAY29uc3RydWN0b3JcbiAgICogQGV4dGVuZHMgVHJhaXRMZXNzU2VsZWN0b3JcbiAgICovXG5cbiAgZnVuY3Rpb24gU3BsaXR0ZWRTZWxlY3RvcihzZWxlY3RvclRleHQsIHNpbXBsZSwgcmVsYXRpb24sIGNvbXBsZXgsIGRlYnVnKSB7XG4gICAgVHJhaXRMZXNzU2VsZWN0b3IuY2FsbCh0aGlzLCBzZWxlY3RvclRleHQsIGRlYnVnKTtcbiAgICB0aGlzLnNpbXBsZSA9IHNpbXBsZTtcbiAgICB0aGlzLnJlbGF0aW9uID0gcmVsYXRpb247XG4gICAgdGhpcy5jb21wbGV4ID0gY29tcGxleDtcbiAgICBTaXp6bGUuY29tcGlsZShjb21wbGV4KTtcbiAgfVxuXG4gIFNwbGl0dGVkU2VsZWN0b3IucHJvdG90eXBlID0gT2JqZWN0LmNyZWF0ZShUcmFpdExlc3NTZWxlY3Rvci5wcm90b3R5cGUpO1xuICBTcGxpdHRlZFNlbGVjdG9yLnByb3RvdHlwZS5jb25zdHJ1Y3RvciA9IFNwbGl0dGVkU2VsZWN0b3I7XG4gIC8qKiBAb3ZlcnJpZGUgKi9cblxuICBTcGxpdHRlZFNlbGVjdG9yLnByb3RvdHlwZS5xdWVyeVNlbGVjdG9yQWxsID0gZnVuY3Rpb24gKCkge1xuICAgIHZhciBfdGhpczIgPSB0aGlzO1xuXG4gICAgdmFyIHJlc3VsdE5vZGVzID0gW107XG4gICAgdmFyIHNpbXBsZU5vZGVzO1xuICAgIHZhciBzaW1wbGUgPSB0aGlzLnNpbXBsZTtcbiAgICB2YXIgcmVsYXRpb247XG5cbiAgICBpZiAoc2ltcGxlKSB7XG4gICAgICAvLyBGaXJzdCB3ZSB1c2Ugc2ltcGxlIHNlbGVjdG9yIHRvIG5hcnJvdyBvdXIgc2VhcmNoXG4gICAgICBzaW1wbGVOb2RlcyA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3JBbGwoc2ltcGxlKTtcblxuICAgICAgaWYgKCFzaW1wbGVOb2RlcyB8fCAhc2ltcGxlTm9kZXMubGVuZ3RoKSB7XG4gICAgICAgIHJldHVybiByZXN1bHROb2RlcztcbiAgICAgIH1cblxuICAgICAgcmVsYXRpb24gPSB0aGlzLnJlbGF0aW9uO1xuICAgIH0gZWxzZSB7XG4gICAgICBzaW1wbGVOb2RlcyA9IFtkb2N1bWVudF07XG4gICAgICByZWxhdGlvbiA9ICcgJztcbiAgICB9XG5cbiAgICBzd2l0Y2ggKHJlbGF0aW9uKSB7XG4gICAgICBjYXNlICcgJzpcbiAgICAgICAgc2ltcGxlTm9kZXMuZm9yRWFjaChmdW5jdGlvbiAobm9kZSkge1xuICAgICAgICAgIF90aGlzMi5yZWxhdGl2ZVNlYXJjaChub2RlLCByZXN1bHROb2Rlcyk7XG4gICAgICAgIH0pO1xuICAgICAgICBicmVhaztcblxuICAgICAgY2FzZSAnPic6XG4gICAgICAgIHtcbiAgICAgICAgICBzaW1wbGVOb2Rlcy5mb3JFYWNoKGZ1bmN0aW9uIChub2RlKSB7XG4gICAgICAgICAgICBPYmplY3QudmFsdWVzKG5vZGUuY2hpbGRyZW4pLmZvckVhY2goZnVuY3Rpb24gKGNoaWxkTm9kZSkge1xuICAgICAgICAgICAgICBpZiAoX3RoaXMyLm1hdGNoZXMoY2hpbGROb2RlKSkge1xuICAgICAgICAgICAgICAgIHJlc3VsdE5vZGVzLnB1c2goY2hpbGROb2RlKTtcbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfSk7XG4gICAgICAgICAgfSk7XG4gICAgICAgICAgYnJlYWs7XG4gICAgICAgIH1cblxuICAgICAgY2FzZSAnKyc6XG4gICAgICAgIHtcbiAgICAgICAgICBzaW1wbGVOb2Rlcy5mb3JFYWNoKGZ1bmN0aW9uIChub2RlKSB7XG4gICAgICAgICAgICB2YXIgcGFyZW50Tm9kZSA9IG5vZGUucGFyZW50Tm9kZTtcbiAgICAgICAgICAgIE9iamVjdC52YWx1ZXMocGFyZW50Tm9kZS5jaGlsZHJlbikuZm9yRWFjaChmdW5jdGlvbiAoY2hpbGROb2RlKSB7XG4gICAgICAgICAgICAgIGlmIChfdGhpczIubWF0Y2hlcyhjaGlsZE5vZGUpICYmIGNoaWxkTm9kZS5wcmV2aW91c0VsZW1lbnRTaWJsaW5nID09PSBub2RlKSB7XG4gICAgICAgICAgICAgICAgcmVzdWx0Tm9kZXMucHVzaChjaGlsZE5vZGUpO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9KTtcbiAgICAgICAgICB9KTtcbiAgICAgICAgICBicmVhaztcbiAgICAgICAgfVxuXG4gICAgICBjYXNlICd+JzpcbiAgICAgICAge1xuICAgICAgICAgIHNpbXBsZU5vZGVzLmZvckVhY2goZnVuY3Rpb24gKG5vZGUpIHtcbiAgICAgICAgICAgIHZhciBwYXJlbnROb2RlID0gbm9kZS5wYXJlbnROb2RlO1xuICAgICAgICAgICAgT2JqZWN0LnZhbHVlcyhwYXJlbnROb2RlLmNoaWxkcmVuKS5mb3JFYWNoKGZ1bmN0aW9uIChjaGlsZE5vZGUpIHtcbiAgICAgICAgICAgICAgaWYgKF90aGlzMi5tYXRjaGVzKGNoaWxkTm9kZSkgJiYgbm9kZS5jb21wYXJlRG9jdW1lbnRQb3NpdGlvbihjaGlsZE5vZGUpID09PSA0KSB7XG4gICAgICAgICAgICAgICAgcmVzdWx0Tm9kZXMucHVzaChjaGlsZE5vZGUpO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9KTtcbiAgICAgICAgICB9KTtcbiAgICAgICAgICBicmVhaztcbiAgICAgICAgfVxuICAgIH1cblxuICAgIHJldHVybiBTaXp6bGUudW5pcXVlU29ydChyZXN1bHROb2Rlcyk7XG4gIH07XG4gIC8qKlxuICAgKiBQZXJmb3JtcyBhIHNlYXJjaCBvZiBcImNvbXBsZXhcIiBwYXJ0IHJlbGF0aXZlIHRvIHJlc3VsdHMgZm9yIHRoZSBcInNpbXBsZVwiIHBhcnQuXG4gICAqIEBwYXJhbSB7Tm9kZX0gbm9kZSBhIG5vZGUgbWF0Y2hpbmcgdGhlIFwic2ltcGxlXCIgcGFydC5cbiAgICogQHBhcmFtIHtOb2RlW119IHJlc3VsdCBhbiBhcnJheSB0byBhcHBlbmQgc2VhcmNoIHJlc3VsdC5cbiAgICovXG5cblxuICBTcGxpdHRlZFNlbGVjdG9yLnByb3RvdHlwZS5yZWxhdGl2ZVNlYXJjaCA9IGZ1bmN0aW9uIChub2RlLCByZXN1bHRzKSB7XG4gICAgU2l6emxlKHRoaXMuY29tcGxleCwgbm9kZSwgcmVzdWx0cyk7XG4gIH07XG5cbiAgcmV0dXJuIHtcbiAgICAvKipcbiAgICAgKiBXcmFwcyB0aGUgaW5uZXIgY2xhc3Mgc28gdGhhdCB0aGUgaW5zdGFuY2UgaXMgbm90IGV4cG9zZWQuXG4gICAgICovXG4gICAgY3JlYXRlU2VsZWN0b3I6IGZ1bmN0aW9uIGNyZWF0ZVNlbGVjdG9yKHNlbGVjdG9yLCB0b2tlbnMsIGRlYnVnKSB7XG4gICAgICByZXR1cm4gbmV3IEV4dGVuZGVkU2VsZWN0b3JQYXJzZXIoc2VsZWN0b3IsIHRva2VucywgZGVidWcpLmNyZWF0ZVNlbGVjdG9yKCk7XG4gICAgfSxcblxuICAgIC8qKlxuICAgICAqIE1hcmsgZXZlcnkgc2VsZWN0b3IgYXMgYSBzZWxlY3RvciBiZWluZyBkZWJ1Z2dlZCwgc28gdGhhdCB0aW1pbmcgaW5mb3JtYXRpb25cbiAgICAgKiBmb3IgdGhlIHNlbGVjdG9yIGlzIHByaW50ZWQgdG8gdGhlIGNvbnNvbGUuXG4gICAgICovXG4gICAgZW5hYmxlR2xvYmFsRGVidWdnaW5nOiBmdW5jdGlvbiBlbmFibGVHbG9iYWxEZWJ1Z2dpbmcoKSB7XG4gICAgICBnbG9iYWxEZWJ1Z2dpbmdGbGFnID0gdHJ1ZTtcbiAgICB9XG4gIH07XG59KCk7XG5cbi8qKlxuICogQ29weXJpZ2h0IDIwMTYgQWRndWFyZCBTb2Z0d2FyZSBMdGRcbiAqXG4gKiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2Vuc2UsIFZlcnNpb24gMi4wICh0aGUgXCJMaWNlbnNlXCIpO1xuICogeW91IG1heSBub3QgdXNlIHRoaXMgZmlsZSBleGNlcHQgaW4gY29tcGxpYW5jZSB3aXRoIHRoZSBMaWNlbnNlLlxuICogWW91IG1heSBvYnRhaW4gYSBjb3B5IG9mIHRoZSBMaWNlbnNlIGF0XG4gKlxuICogaHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wXG4gKlxuICogVW5sZXNzIHJlcXVpcmVkIGJ5IGFwcGxpY2FibGUgbGF3IG9yIGFncmVlZCB0byBpbiB3cml0aW5nLCBzb2Z0d2FyZVxuICogZGlzdHJpYnV0ZWQgdW5kZXIgdGhlIExpY2Vuc2UgaXMgZGlzdHJpYnV0ZWQgb24gYW4gXCJBUyBJU1wiIEJBU0lTLFxuICogV0lUSE9VVCBXQVJSQU5USUVTIE9SIENPTkRJVElPTlMgT0YgQU5ZIEtJTkQsIGVpdGhlciBleHByZXNzIG9yIGltcGxpZWQuXG4gKiBTZWUgdGhlIExpY2Vuc2UgZm9yIHRoZSBzcGVjaWZpYyBsYW5ndWFnZSBnb3Zlcm5pbmcgcGVybWlzc2lvbnMgYW5kXG4gKiBsaW1pdGF0aW9ucyB1bmRlciB0aGUgTGljZW5zZS5cbiAqL1xuLyoqXG4gKiBBIGhlbHBlciBjbGFzcyB0aGF0IHBhcnNlcyBzdHlsZXNoZWV0cyBjb250YWluaW5nIGV4dGVuZGVkIHNlbGVjdG9yc1xuICogaW50byBFeHRlbmRlZFNlbGVjdG9yIGluc3RhbmNlcyBhbmQga2V5LXZhbHVlIG1hcHMgb2Ygc3R5bGUgZGVjbGFyYXRpb25zLlxuICogUGxlYXNlIG5vdGUsIHRoYXQgaXQgZG9lcyBub3Qgc3VwcG9ydCBhbnkgY29tcGxleCB0aGluZ3MgbGlrZSBtZWRpYSBxdWVyaWVzIGFuZCBzdWNoLlxuICovXG5cbnZhciBFeHRlbmRlZENzc1BhcnNlciA9IGZ1bmN0aW9uICgpIHtcbiAgdmFyIHJlRGVjbEVuZCA9IC9bO31dL2c7XG4gIHZhciByZURlY2xEaXZpZGVyID0gL1s7On1dL2c7XG4gIHZhciByZU5vbldoaXRlc3BhY2UgPSAvXFxTL2c7XG4gIHZhciBTaXp6bGU7XG4gIC8qKlxuICAgKiBAcGFyYW0ge3N0cmluZ30gY3NzVGV4dFxuICAgKiBAY29uc3RydWN0b3JcbiAgICovXG5cbiAgZnVuY3Rpb24gUGFyc2VyKGNzc1RleHQpIHtcbiAgICB0aGlzLmNzc1RleHQgPSBjc3NUZXh0O1xuICB9XG5cbiAgUGFyc2VyLnByb3RvdHlwZSA9IHtcbiAgICBlcnJvcjogZnVuY3Rpb24gZXJyb3IocG9zaXRpb24pIHtcbiAgICAgIHRocm93IG5ldyBFcnJvcihcIkNzc1BhcnNlcjogcGFyc2UgZXJyb3IgYXQgcG9zaXRpb24gXCIuY29uY2F0KHRoaXMucG9zT2Zmc2V0ICsgcG9zaXRpb24pKTtcbiAgICB9LFxuXG4gICAgLyoqXG4gICAgICogVmFsaWRhdGVzIHRoYXQgdGhlIHRva2VucyBjb3JyZXNwb25kIHRvIGEgdmFsaWQgc2VsZWN0b3IuXG4gICAgICogU2l6emxlIGlzIGRpZmZlcmVudCBmcm9tIGJyb3dzZXJzIGFuZCBzb21lIHNlbGVjdG9ycyB0aGF0IGl0IHRvbGVyYXRlcyBhcmVuJ3QgYWN0dWFsbHkgdmFsaWQuXG4gICAgICogRm9yIGluc3RhbmNlLCBcImRpdiA+XCIgd29uJ3Qgd29yayBpbiBhIGJyb3dzZXIsIGJ1dCBpdCB3aWxsIGluIFNpenpsZSAoaXQnZCBiZSB0aGUgc2FtZSBhcyBcImRpdiA+ICpcIikuXG4gICAgICpcbiAgICAgKiBAcGFyYW0geyp9IHNlbGVjdG9ycyBBbiBhcnJheSBvZiBTZWxlY3RvckRhdGEgKHNlbGVjdG9yLCBncm91cHMpXG4gICAgICogQHJldHVybnMge2Jvb2xlYW59IGZhbHNlIGlmIGFueSBvZiB0aGUgZ3JvdXBzIGFyZSBpbnZhbGlkXG4gICAgICovXG4gICAgdmFsaWRhdGVTZWxlY3RvcnM6IGZ1bmN0aW9uIHZhbGlkYXRlU2VsZWN0b3JzKHNlbGVjdG9ycykge1xuICAgICAgdmFyIGlTZWxlY3RvcnMgPSBzZWxlY3RvcnMubGVuZ3RoO1xuXG4gICAgICB3aGlsZSAoaVNlbGVjdG9ycy0tKSB7XG4gICAgICAgIHZhciBncm91cHMgPSBzZWxlY3RvcnNbaVNlbGVjdG9yc10uZ3JvdXBzO1xuICAgICAgICB2YXIgaUdyb3VwcyA9IGdyb3Vwcy5sZW5ndGg7XG5cbiAgICAgICAgd2hpbGUgKGlHcm91cHMtLSkge1xuICAgICAgICAgIHZhciB0b2tlbnMgPSBncm91cHNbaUdyb3Vwc107XG4gICAgICAgICAgdmFyIGxhc3RUb2tlbiA9IHRva2Vuc1t0b2tlbnMubGVuZ3RoIC0gMV07XG5cbiAgICAgICAgICBpZiAoU2l6emxlLnNlbGVjdG9ycy5yZWxhdGl2ZVtsYXN0VG9rZW4udHlwZV0pIHtcbiAgICAgICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICAgIH1cblxuICAgICAgcmV0dXJuIHRydWU7XG4gICAgfSxcblxuICAgIC8qKlxuICAgICAqIFBhcnNlcyBhIHN0eWxlc2hlZXQgYW5kIHJldHVybnMgYSBsaXN0IG9mIHBhaXJzIG9mIGFuIEV4dGVuZGVkU2VsZWN0b3IgYW5kIGEgc3R5bGVzIG1hcC5cbiAgICAgKiBUaGlzIG1ldGhvZCB3aWxsIHRocm93IGFuIGVycm9yIGluIGNhc2Ugb2YgYW4gb2J2aW91c2x5IGludmFsaWQgaW5wdXQuXG4gICAgICogSWYgYW55IG9mIHRoZSBzZWxlY3RvcnMgdXNlZCBpbiB0aGUgc3R5bGVzaGVldCBjYW5ub3QgYmUgY29tcGlsZWQgaW50byBhbiBFeHRlbmRlZFNlbGVjdG9yLFxuICAgICAqIGl0IHdpbGwgYmUgaWdub3JlZC5cbiAgICAgKlxuICAgICAqIEB0eXBlZGVmIHtPYmplY3R9IEV4dGVuZGVkU3R5bGVcbiAgICAgKiBAcHJvcGVydHkge09iamVjdH0gc2VsZWN0b3IgQW4gaW5zdGFuY2Ugb2YgdGhlIHtAbGluayBFeHRlbmRlZFNlbGVjdG9yfSBjbGFzc1xuICAgICAqIEBwcm9wZXJ0eSB7T2JqZWN0fSBzdHlsZU1hcCBBIG1hcCBvZiBzdHlsZXMgcGFyc2VkXG4gICAgICpcbiAgICAgKiBAcmV0dXJucyB7QXJyYXkuPEV4dGVuZGVkU3R5bGU+fSBBbiBhcnJheSBvZiB0aGUgc3R5bGVzIHBhcnNlZFxuICAgICAqL1xuICAgIHBhcnNlQ3NzOiBmdW5jdGlvbiBwYXJzZUNzcygpIHtcbiAgICAgIHRoaXMucG9zT2Zmc2V0ID0gMDtcblxuICAgICAgaWYgKCF0aGlzLmNzc1RleHQpIHtcbiAgICAgICAgdGhpcy5lcnJvcigwKTtcbiAgICAgIH1cblxuICAgICAgdmFyIHJlc3VsdHMgPSBbXTtcblxuICAgICAgd2hpbGUgKHRoaXMuY3NzVGV4dCkge1xuICAgICAgICAvLyBBcHBseSB0b2xlcmFudCB0b2tlbml6YXRpb24uXG4gICAgICAgIHZhciBwYXJzZVJlc3VsdCA9IFNpenpsZS50b2tlbml6ZSh0aGlzLmNzc1RleHQsIGZhbHNlLCB7XG4gICAgICAgICAgdG9sZXJhbnQ6IHRydWUsXG4gICAgICAgICAgcmV0dXJuVW5zb3J0ZWQ6IHRydWVcbiAgICAgICAgfSk7XG4gICAgICAgIHZhciBzZWxlY3RvckRhdGEgPSBwYXJzZVJlc3VsdC5zZWxlY3RvcnM7XG4gICAgICAgIHRoaXMubmV4dEluZGV4ID0gcGFyc2VSZXN1bHQubmV4dEluZGV4O1xuXG4gICAgICAgIGlmICh0aGlzLmNzc1RleHQuY2hhckNvZGVBdCh0aGlzLm5leHRJbmRleCkgIT09IDEyMyB8fFxuICAgICAgICAvKiBjaGFyQ29kZSBvZiAneycgKi9cbiAgICAgICAgIXRoaXMudmFsaWRhdGVTZWxlY3RvcnMoc2VsZWN0b3JEYXRhKSkge1xuICAgICAgICAgIHRoaXMuZXJyb3IodGhpcy5uZXh0SW5kZXgpO1xuICAgICAgICB9XG5cbiAgICAgICAgdGhpcy5uZXh0SW5kZXgrKzsgLy8gTW92ZSB0aGUgcG9pbnRlciB0byB0aGUgc3RhcnQgb2Ygc3R5bGUgZGVjbGFyYXRpb24uXG5cbiAgICAgICAgdmFyIHN0eWxlTWFwID0gdGhpcy5wYXJzZU5leHRTdHlsZSgpO1xuICAgICAgICB2YXIgZGVidWcgPSBmYWxzZTsgLy8gSWYgdGhlcmUgaXMgYSBzdHlsZSBwcm9wZXJ0eSAnZGVidWcnLCBtYXJrIHRoZSBzZWxlY3RvclxuICAgICAgICAvLyBhcyBhIGRlYnVnZ2FibGUgc2VsZWN0b3IsIGFuZCBkZWxldGUgdGhlIHN0eWxlIGRlY2xhcmF0aW9uLlxuXG4gICAgICAgIHZhciBkZWJ1Z1Byb3BlcnR5VmFsdWUgPSBzdHlsZU1hcFsnZGVidWcnXTtcblxuICAgICAgICBpZiAodHlwZW9mIGRlYnVnUHJvcGVydHlWYWx1ZSAhPT0gJ3VuZGVmaW5lZCcpIHtcbiAgICAgICAgICBpZiAoZGVidWdQcm9wZXJ0eVZhbHVlID09PSAnZ2xvYmFsJykge1xuICAgICAgICAgICAgRXh0ZW5kZWRTZWxlY3RvckZhY3RvcnkuZW5hYmxlR2xvYmFsRGVidWdnaW5nKCk7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgZGVidWcgPSB0cnVlO1xuICAgICAgICAgIGRlbGV0ZSBzdHlsZU1hcFsnZGVidWcnXTtcbiAgICAgICAgfSAvLyBDcmVhdGluZyBhbiBFeHRlbmRlZFNlbGVjdG9yIGluc3RhbmNlIGZvciBldmVyeSBzZWxlY3RvciB3ZSBnb3QgZnJvbSBTaXp6bGUudG9rZW5pemUuXG4gICAgICAgIC8vIFRoaXMgaXMgcXVpdGUgaW1wb3J0YW50IGFzIFNpenpsZSBkb2VzIGEgcG9vciBqb2IgYXQgZXhlY3V0aW5nIHNlbGVjdG9ycyBsaWtlIFwic2VsZWN0b3IxLCBzZWxlY3RvcjJcIi5cblxuXG4gICAgICAgIGZvciAodmFyIGkgPSAwLCBsID0gc2VsZWN0b3JEYXRhLmxlbmd0aDsgaSA8IGw7IGkrKykge1xuICAgICAgICAgIHZhciBkYXRhID0gc2VsZWN0b3JEYXRhW2ldO1xuXG4gICAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgIHZhciBleHRlbmRlZFNlbGVjdG9yID0gRXh0ZW5kZWRTZWxlY3RvckZhY3RvcnkuY3JlYXRlU2VsZWN0b3IoZGF0YS5zZWxlY3RvclRleHQsIGRhdGEuZ3JvdXBzLCBkZWJ1Zyk7XG5cbiAgICAgICAgICAgIGlmIChleHRlbmRlZFNlbGVjdG9yLnBzZXVkb0NsYXNzQXJnICYmIGV4dGVuZGVkU2VsZWN0b3IuaXNSZW1vdmVTZWxlY3Rvcikge1xuICAgICAgICAgICAgICAvLyBpZiB0aGVyZSBpcyByZW1vdmUgcHNldWRvLWNsYXNzIGluIHJ1bGUsXG4gICAgICAgICAgICAgIC8vIHRoZSBlbGVtZW50IHdpbGwgYmUgcmVtb3ZlZCBhbmQgbm8gb3RoZXIgc3R5bGVzIHdpbGwgYmUgYXBwbGllZFxuICAgICAgICAgICAgICBzdHlsZU1hcFsncmVtb3ZlJ10gPSAndHJ1ZSc7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIHJlc3VsdHMucHVzaCh7XG4gICAgICAgICAgICAgIHNlbGVjdG9yOiBleHRlbmRlZFNlbGVjdG9yLFxuICAgICAgICAgICAgICBzdHlsZTogc3R5bGVNYXBcbiAgICAgICAgICAgIH0pO1xuICAgICAgICAgIH0gY2F0Y2ggKGV4KSB7XG4gICAgICAgICAgICB1dGlscy5sb2dFcnJvcihcIkV4dGVuZGVkQ3NzUGFyc2VyOiBpZ25vcmluZyBpbnZhbGlkIHNlbGVjdG9yIFwiLmNvbmNhdChkYXRhLnNlbGVjdG9yVGV4dCkpO1xuICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgfVxuXG4gICAgICByZXR1cm4gcmVzdWx0cztcbiAgICB9LFxuICAgIHBhcnNlTmV4dFN0eWxlOiBmdW5jdGlvbiBwYXJzZU5leHRTdHlsZSgpIHtcbiAgICAgIHZhciBzdHlsZU1hcCA9IE9iamVjdC5jcmVhdGUobnVsbCk7XG4gICAgICB2YXIgYnJhY2tldFBvcyA9IHRoaXMucGFyc2VVbnRpbENsb3NpbmdCcmFja2V0KHN0eWxlTWFwKTsgLy8gQ3V0IG91dCBtYXRjaGVkIHBvcnRpb24gZnJvbSBjc3NUZXh0LlxuXG4gICAgICByZU5vbldoaXRlc3BhY2UubGFzdEluZGV4ID0gYnJhY2tldFBvcyArIDE7XG4gICAgICB2YXIgbWF0Y2ggPSByZU5vbldoaXRlc3BhY2UuZXhlYyh0aGlzLmNzc1RleHQpO1xuXG4gICAgICBpZiAobWF0Y2ggPT09IG51bGwpIHtcbiAgICAgICAgdGhpcy5jc3NUZXh0ID0gJyc7XG4gICAgICAgIHJldHVybiBzdHlsZU1hcDtcbiAgICAgIH1cblxuICAgICAgdmFyIG1hdGNoUG9zID0gbWF0Y2guaW5kZXg7XG4gICAgICB0aGlzLmNzc1RleHQgPSB0aGlzLmNzc1RleHQuc2xpY2UobWF0Y2hQb3MpO1xuICAgICAgdGhpcy5wb3NPZmZzZXQgKz0gbWF0Y2hQb3M7XG4gICAgICByZXR1cm4gc3R5bGVNYXA7XG4gICAgfSxcblxuICAgIC8qKlxuICAgICAqIEByZXR1cm4ge251bWJlcn0gYW4gaW5kZXggb2YgdGhlIG5leHQgJ30nIGluIGB0aGlzLmNzc1RleHRgLlxuICAgICAqL1xuICAgIHBhcnNlVW50aWxDbG9zaW5nQnJhY2tldDogZnVuY3Rpb24gcGFyc2VVbnRpbENsb3NpbmdCcmFja2V0KHN0eWxlTWFwKSB7XG4gICAgICAvLyBFeHBlY3RzIFwiOlwiLCBcIjtcIiwgYW5kIFwifVwiLlxuICAgICAgcmVEZWNsRGl2aWRlci5sYXN0SW5kZXggPSB0aGlzLm5leHRJbmRleDtcbiAgICAgIHZhciBtYXRjaCA9IHJlRGVjbERpdmlkZXIuZXhlYyh0aGlzLmNzc1RleHQpO1xuXG4gICAgICBpZiAobWF0Y2ggPT09IG51bGwpIHtcbiAgICAgICAgdGhpcy5lcnJvcih0aGlzLm5leHRJbmRleCk7XG4gICAgICB9XG5cbiAgICAgIHZhciBtYXRjaFBvcyA9IG1hdGNoLmluZGV4O1xuICAgICAgdmFyIG1hdGNoZWQgPSBtYXRjaFswXTtcblxuICAgICAgaWYgKG1hdGNoZWQgPT09ICd9Jykge1xuICAgICAgICByZXR1cm4gbWF0Y2hQb3M7XG4gICAgICB9XG5cbiAgICAgIGlmIChtYXRjaGVkID09PSAnOicpIHtcbiAgICAgICAgdmFyIGNvbG9uSW5kZXggPSBtYXRjaFBvczsgLy8gRXhwZWN0cyBcIjtcIiBhbmQgXCJ9XCIuXG5cbiAgICAgICAgcmVEZWNsRW5kLmxhc3RJbmRleCA9IGNvbG9uSW5kZXg7XG4gICAgICAgIG1hdGNoID0gcmVEZWNsRW5kLmV4ZWModGhpcy5jc3NUZXh0KTtcblxuICAgICAgICBpZiAobWF0Y2ggPT09IG51bGwpIHtcbiAgICAgICAgICB0aGlzLmVycm9yKGNvbG9uSW5kZXgpO1xuICAgICAgICB9XG5cbiAgICAgICAgbWF0Y2hQb3MgPSBtYXRjaC5pbmRleDtcbiAgICAgICAgbWF0Y2hlZCA9IG1hdGNoWzBdOyAvLyBQb3B1bGF0ZXMgdGhlIGBzdHlsZU1hcGAga2V5LXZhbHVlIG1hcC5cblxuICAgICAgICB2YXIgcHJvcGVydHkgPSB0aGlzLmNzc1RleHQuc2xpY2UodGhpcy5uZXh0SW5kZXgsIGNvbG9uSW5kZXgpLnRyaW0oKTtcbiAgICAgICAgdmFyIHZhbHVlID0gdGhpcy5jc3NUZXh0LnNsaWNlKGNvbG9uSW5kZXggKyAxLCBtYXRjaFBvcykudHJpbSgpO1xuICAgICAgICBzdHlsZU1hcFtwcm9wZXJ0eV0gPSB2YWx1ZTsgLy8gSWYgZm91bmQgXCJ9XCIsIHJlLXJ1biB0aGUgb3V0ZXIgbG9vcC5cblxuICAgICAgICBpZiAobWF0Y2hlZCA9PT0gJ30nKSB7XG4gICAgICAgICAgcmV0dXJuIG1hdGNoUG9zO1xuICAgICAgICB9XG4gICAgICB9IC8vIG1hdGNoUG9zIGlzIHRoZSBwb3NpdGlvbiBvZiB0aGUgbmV4dCAnOycuXG4gICAgICAvLyBJbmNyZWFzZSAnbmV4dEluZGV4JyBhbmQgcmUtcnVuIHRoZSBsb29wLlxuXG5cbiAgICAgIHRoaXMubmV4dEluZGV4ID0gbWF0Y2hQb3MgKyAxO1xuICAgICAgcmV0dXJuIHRoaXMucGFyc2VVbnRpbENsb3NpbmdCcmFja2V0KHN0eWxlTWFwKTsgLy8gU2hvdWxkIGJlIGEgc3ViamVjdCBvZiB0YWlsLWNhbGwgb3B0aW1pemF0aW9uLlxuICAgIH1cbiAgfTtcbiAgcmV0dXJuIHtcbiAgICBwYXJzZUNzczogZnVuY3Rpb24gcGFyc2VDc3MoY3NzVGV4dCkge1xuICAgICAgU2l6emxlID0gaW5pdGlhbGl6ZVNpenpsZSgpO1xuICAgICAgcmV0dXJuIG5ldyBQYXJzZXIoY3NzVXRpbHMubm9ybWFsaXplKGNzc1RleHQpKS5wYXJzZUNzcygpO1xuICAgIH1cbiAgfTtcbn0oKTtcblxuLyoqXG4gKiBUaGlzIGNhbGxiYWNrIGlzIHVzZWQgdG8gZ2V0IGFmZmVjdGVkIG5vZGUgZWxlbWVudHMgYW5kIGhhbmRsZSBzdHlsZSBwcm9wZXJ0aWVzXG4gKiBiZWZvcmUgdGhleSBhcmUgYXBwbGllZCB0byB0aGVtIGlmIGl0IGlzIG5lY2Vzc2FyeVxuICogQGNhbGxiYWNrIGJlZm9yZVN0eWxlQXBwbGllZFxuICogQHBhcmFtIHtvYmplY3R9IGFmZmVjdGVkRWxlbWVudCAtIE9iamVjdCBjb250YWluaW5nIERPTSBub2RlIGFuZCBydWxlIHRvIGJlIGFwcGxpZWRcbiAqIEByZXR1cm4ge29iamVjdH0gYWZmZWN0ZWRFbGVtZW50IC0gU2FtZSBvciBtb2RpZmllZCBvYmplY3QgY29udGFpbmluZyBET00gbm9kZSBhbmQgcnVsZSB0byBiZSBhcHBsaWVkXG4gKi9cblxuLyoqXG4gKiBFeHRlbmRlZCBjc3MgY2xhc3NcbiAqXG4gKiBAcGFyYW0ge09iamVjdH0gY29uZmlndXJhdGlvblxuICogQHBhcmFtIHtzdHJpbmd9IGNvbmZpZ3VyYXRpb24uc3R5bGVTaGVldCAtIHRoZSBDU1Mgc3R5bGVzaGVldCB0ZXh0XG4gKiBAcGFyYW0ge2JlZm9yZVN0eWxlQXBwbGllZH0gW2NvbmZpZ3VyYXRpb24uYmVmb3JlU3R5bGVBcHBsaWVkXSAtIHRoZSBjYWxsYmFjayB0aGF0IGhhbmRsZXMgYWZmZWN0ZWQgZWxlbWVudHNcbiAqIEBjb25zdHJ1Y3RvclxuICovXG5cbmZ1bmN0aW9uIEV4dGVuZGVkQ3NzKGNvbmZpZ3VyYXRpb24pIHtcbiAgaWYgKCFjb25maWd1cmF0aW9uKSB7XG4gICAgdGhyb3cgbmV3IEVycm9yKCdDb25maWd1cmF0aW9uIGlzIG5vdCBwcm92aWRlZC4nKTtcbiAgfVxuXG4gIHZhciBzdHlsZVNoZWV0ID0gY29uZmlndXJhdGlvbi5zdHlsZVNoZWV0O1xuICB2YXIgYmVmb3JlU3R5bGVBcHBsaWVkID0gY29uZmlndXJhdGlvbi5iZWZvcmVTdHlsZUFwcGxpZWQ7XG5cbiAgaWYgKGJlZm9yZVN0eWxlQXBwbGllZCAmJiB0eXBlb2YgYmVmb3JlU3R5bGVBcHBsaWVkICE9PSAnZnVuY3Rpb24nKSB7XG4gICAgLy8gZXNsaW50LWRpc2FibGUtbmV4dC1saW5lIG1heC1sZW5cbiAgICB0aHJvdyBuZXcgRXJyb3IoXCJXcm9uZyBjb25maWd1cmF0aW9uLiBUeXBlIG9mICdiZWZvcmVTdHlsZUFwcGxpZWQnIGZpZWxkIHNob3VsZCBiZSBhIGZ1bmN0aW9uLCByZWNlaXZlZDogXCIuY29uY2F0KF90eXBlb2YoYmVmb3JlU3R5bGVBcHBsaWVkKSkpO1xuICB9IC8vIFdlIHVzZSBFdmVudFRyYWNrZXIgdG8gdHJhY2sgdGhlIGV2ZW50IHRoYXQgaXMgbGlrZWx5IHRvIGNhdXNlIHRoZSBtdXRhdGlvbi5cbiAgLy8gVGhlIHByb2JsZW0gaXMgdGhhdCB3ZSBjYW5ub3QgdXNlIGB3aW5kb3cuZXZlbnRgIGRpcmVjdGx5IGZyb20gdGhlIG11dGF0aW9uIG9ic2VydmVyIGNhbGxcbiAgLy8gYXMgd2UncmUgbm90IGluIHRoZSBldmVudCBoYW5kbGVyIGNvbnRleHQgYW55bW9yZS5cblxuXG4gIHZhciBFdmVudFRyYWNrZXIgPSBmdW5jdGlvbiAoKSB7XG4gICAgdmFyIGlnbm9yZWRFdmVudFR5cGVzID0gWydtb3VzZW92ZXInLCAnbW91c2VsZWF2ZScsICdtb3VzZWVudGVyJywgJ21vdXNlb3V0J107XG4gICAgdmFyIExBU1RfRVZFTlRfVElNRU9VVF9NUyA9IDEwO1xuICAgIHZhciBFVkVOVFMgPSBbLy8ga2V5Ym9hcmQgZXZlbnRzXG4gICAgJ2tleWRvd24nLCAna2V5cHJlc3MnLCAna2V5dXAnLCAvLyBtb3VzZSBldmVudHNcbiAgICAnYXV4Y2xpY2snLCAnY2xpY2snLCAnY29udGV4dG1lbnUnLCAnZGJsY2xpY2snLCAnbW91c2Vkb3duJywgJ21vdXNlZW50ZXInLCAnbW91c2VsZWF2ZScsICdtb3VzZW1vdmUnLCAnbW91c2VvdmVyJywgJ21vdXNlb3V0JywgJ21vdXNldXAnLCAncG9pbnRlcmxvY2tjaGFuZ2UnLCAncG9pbnRlcmxvY2tlcnJvcicsICdzZWxlY3QnLCAnd2hlZWwnXTsgLy8gJ3doZWVsJyBldmVudCBtYWtlcyBzY3JvbGxpbmcgaW4gU2FmYXJpIHR3aXRjaHlcbiAgICAvLyBodHRwczovL2dpdGh1Yi5jb20vQWRndWFyZFRlYW0vRXh0ZW5kZWRDc3MvaXNzdWVzLzEyMFxuXG4gICAgdmFyIHNhZmFyaVByb2JsZW1hdGljRXZlbnRzID0gWyd3aGVlbCddO1xuICAgIHZhciB0cmFja2VkRXZlbnRzID0gdXRpbHMuaXNTYWZhcmlCcm93c2VyID8gRVZFTlRTLmZpbHRlcihmdW5jdGlvbiAoZWwpIHtcbiAgICAgIHJldHVybiAhKHNhZmFyaVByb2JsZW1hdGljRXZlbnRzLmluZGV4T2YoZWwpID4gLTEpO1xuICAgIH0pIDogRVZFTlRTO1xuICAgIHZhciBsYXN0RXZlbnRUeXBlO1xuICAgIHZhciBsYXN0RXZlbnRUaW1lO1xuXG4gICAgdmFyIHRyYWNrRXZlbnQgPSBmdW5jdGlvbiB0cmFja0V2ZW50KGUpIHtcbiAgICAgIGxhc3RFdmVudFR5cGUgPSBlLnR5cGU7XG4gICAgICBsYXN0RXZlbnRUaW1lID0gRGF0ZS5ub3coKTtcbiAgICB9O1xuXG4gICAgdHJhY2tlZEV2ZW50cy5mb3JFYWNoKGZ1bmN0aW9uIChldk5hbWUpIHtcbiAgICAgIGRvY3VtZW50LmRvY3VtZW50RWxlbWVudC5hZGRFdmVudExpc3RlbmVyKGV2TmFtZSwgdHJhY2tFdmVudCwgdHJ1ZSk7XG4gICAgfSk7XG5cbiAgICB2YXIgZ2V0TGFzdEV2ZW50VHlwZSA9IGZ1bmN0aW9uIGdldExhc3RFdmVudFR5cGUoKSB7XG4gICAgICByZXR1cm4gbGFzdEV2ZW50VHlwZTtcbiAgICB9O1xuXG4gICAgdmFyIGdldFRpbWVTaW5jZUxhc3RFdmVudCA9IGZ1bmN0aW9uIGdldFRpbWVTaW5jZUxhc3RFdmVudCgpIHtcbiAgICAgIHJldHVybiBEYXRlLm5vdygpIC0gbGFzdEV2ZW50VGltZTtcbiAgICB9O1xuXG4gICAgcmV0dXJuIHtcbiAgICAgIGlzSWdub3JlZEV2ZW50VHlwZTogZnVuY3Rpb24gaXNJZ25vcmVkRXZlbnRUeXBlKCkge1xuICAgICAgICByZXR1cm4gaWdub3JlZEV2ZW50VHlwZXMuaW5kZXhPZihnZXRMYXN0RXZlbnRUeXBlKCkpID4gLTEgJiYgZ2V0VGltZVNpbmNlTGFzdEV2ZW50KCkgPCBMQVNUX0VWRU5UX1RJTUVPVVRfTVM7XG4gICAgICB9XG4gICAgfTtcbiAgfSgpO1xuXG4gIHZhciBydWxlcyA9IFtdO1xuICB2YXIgYWZmZWN0ZWRFbGVtZW50cyA9IFtdO1xuICB2YXIgcmVtb3ZhbHNTdGF0aXN0aWMgPSB7fTtcbiAgdmFyIGRvbU9ic2VydmVkO1xuICB2YXIgZXZlbnRMaXN0ZW5lclN1cHBvcnRlZCA9IHdpbmRvdy5hZGRFdmVudExpc3RlbmVyO1xuICB2YXIgZG9tTXV0YXRpb25PYnNlcnZlcjtcblxuICBmdW5jdGlvbiBvYnNlcnZlRG9jdW1lbnQoY2FsbGJhY2spIHtcbiAgICAvLyBXZSBhcmUgdHJ5aW5nIHRvIGxpbWl0IHRoZSBudW1iZXIgb2YgY2FsbGJhY2sgY2FsbHMgYnkgbm90IGNhbGxpbmcgaXQgb24gYWxsIGtpbmQgb2YgXCJob3ZlclwiIGV2ZW50cy5cbiAgICAvLyBUaGUgcmF0aW9uYWxlIGJlaGluZCB0aGlzIGlzIHRoYXQgXCJob3ZlclwiIGV2ZW50cyBvZnRlbiBjYXVzZSBhdHRyaWJ1dGVzIG1vZGlmaWNhdGlvbixcbiAgICAvLyBidXQgcmUtYXBwbHlpbmcgZXh0Q1NTIHJ1bGVzIHdpbGwgYmUgdXNlbGVzcyBhcyB0aGVzZSBhdHRyaWJ1dGUgY2hhbmdlcyBhcmUgdXN1YWxseSB0cmFuc2llbnQuXG4gICAgdmFyIGlzSWdub3JlZE11dGF0aW9uID0gZnVuY3Rpb24gaXNJZ25vcmVkTXV0YXRpb24obXV0YXRpb25zKSB7XG4gICAgICBmb3IgKHZhciBpID0gMDsgaSA8IG11dGF0aW9ucy5sZW5ndGg7IGkgKz0gMSkge1xuICAgICAgICBpZiAobXV0YXRpb25zLnR5cGUgIT09ICdhdHRyaWJ1dGVzJykge1xuICAgICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgICAgfVxuICAgICAgfVxuXG4gICAgICByZXR1cm4gdHJ1ZTtcbiAgICB9O1xuXG4gICAgaWYgKHV0aWxzLk11dGF0aW9uT2JzZXJ2ZXIpIHtcbiAgICAgIGRvbU11dGF0aW9uT2JzZXJ2ZXIgPSBuZXcgdXRpbHMuTXV0YXRpb25PYnNlcnZlcihmdW5jdGlvbiAobXV0YXRpb25zKSB7XG4gICAgICAgIGlmICghbXV0YXRpb25zIHx8IG11dGF0aW9ucy5sZW5ndGggPT09IDApIHtcbiAgICAgICAgICByZXR1cm47XG4gICAgICAgIH1cblxuICAgICAgICBpZiAoRXZlbnRUcmFja2VyLmlzSWdub3JlZEV2ZW50VHlwZSgpICYmIGlzSWdub3JlZE11dGF0aW9uKG11dGF0aW9ucykpIHtcbiAgICAgICAgICByZXR1cm47XG4gICAgICAgIH1cblxuICAgICAgICBjYWxsYmFjaygpO1xuICAgICAgfSk7XG4gICAgICBkb21NdXRhdGlvbk9ic2VydmVyLm9ic2VydmUoZG9jdW1lbnQsIHtcbiAgICAgICAgY2hpbGRMaXN0OiB0cnVlLFxuICAgICAgICBzdWJ0cmVlOiB0cnVlLFxuICAgICAgICBhdHRyaWJ1dGVzOiB0cnVlLFxuICAgICAgICBhdHRyaWJ1dGVGaWx0ZXI6IFsnaWQnLCAnY2xhc3MnXVxuICAgICAgfSk7XG4gICAgfSBlbHNlIGlmIChldmVudExpc3RlbmVyU3VwcG9ydGVkKSB7XG4gICAgICBkb2N1bWVudC5hZGRFdmVudExpc3RlbmVyKCdET01Ob2RlSW5zZXJ0ZWQnLCBjYWxsYmFjaywgZmFsc2UpO1xuICAgICAgZG9jdW1lbnQuYWRkRXZlbnRMaXN0ZW5lcignRE9NTm9kZVJlbW92ZWQnLCBjYWxsYmFjaywgZmFsc2UpO1xuICAgICAgZG9jdW1lbnQuYWRkRXZlbnRMaXN0ZW5lcignRE9NQXR0ck1vZGlmaWVkJywgY2FsbGJhY2ssIGZhbHNlKTtcbiAgICB9XG4gIH1cblxuICBmdW5jdGlvbiBkaXNjb25uZWN0RG9jdW1lbnQoY2FsbGJhY2spIHtcbiAgICBpZiAoZG9tTXV0YXRpb25PYnNlcnZlcikge1xuICAgICAgZG9tTXV0YXRpb25PYnNlcnZlci5kaXNjb25uZWN0KCk7XG4gICAgfSBlbHNlIGlmIChldmVudExpc3RlbmVyU3VwcG9ydGVkKSB7XG4gICAgICBkb2N1bWVudC5yZW1vdmVFdmVudExpc3RlbmVyKCdET01Ob2RlSW5zZXJ0ZWQnLCBjYWxsYmFjaywgZmFsc2UpO1xuICAgICAgZG9jdW1lbnQucmVtb3ZlRXZlbnRMaXN0ZW5lcignRE9NTm9kZVJlbW92ZWQnLCBjYWxsYmFjaywgZmFsc2UpO1xuICAgICAgZG9jdW1lbnQucmVtb3ZlRXZlbnRMaXN0ZW5lcignRE9NQXR0ck1vZGlmaWVkJywgY2FsbGJhY2ssIGZhbHNlKTtcbiAgICB9XG4gIH1cblxuICB2YXIgTUFYX1NUWUxFX1BST1RFQ1RJT05fQ09VTlQgPSA1MDtcbiAgdmFyIHByb3RlY3Rpb25PYnNlcnZlck9wdGlvbiA9IHtcbiAgICBhdHRyaWJ1dGVzOiB0cnVlLFxuICAgIGF0dHJpYnV0ZU9sZFZhbHVlOiB0cnVlLFxuICAgIGF0dHJpYnV0ZUZpbHRlcjogWydzdHlsZSddXG4gIH07XG4gIC8qKlxuICAgKiBDcmVhdGVzIE11dGF0aW9uT2JzZXJ2ZXIgcHJvdGVjdGlvbiBmdW5jdGlvblxuICAgKlxuICAgKiBAcGFyYW0gc3R5bGVzXG4gICAqIEByZXR1cm4ge3Byb3RlY3Rpb25GdW5jdGlvbn1cbiAgICovXG5cbiAgZnVuY3Rpb24gY3JlYXRlUHJvdGVjdGlvbkZ1bmN0aW9uKHN0eWxlcykge1xuICAgIGZ1bmN0aW9uIHByb3RlY3Rpb25GdW5jdGlvbihtdXRhdGlvbnMsIG9ic2VydmVyKSB7XG4gICAgICBpZiAoIW11dGF0aW9ucy5sZW5ndGgpIHtcbiAgICAgICAgcmV0dXJuO1xuICAgICAgfVxuXG4gICAgICB2YXIgbXV0YXRpb24gPSBtdXRhdGlvbnNbMF07XG4gICAgICB2YXIgdGFyZ2V0ID0gbXV0YXRpb24udGFyZ2V0O1xuICAgICAgb2JzZXJ2ZXIuZGlzY29ubmVjdCgpO1xuICAgICAgc3R5bGVzLmZvckVhY2goZnVuY3Rpb24gKHN0eWxlKSB7XG4gICAgICAgIHNldFN0eWxlVG9FbGVtZW50KHRhcmdldCwgc3R5bGUpO1xuICAgICAgfSk7XG5cbiAgICAgIGlmICgrK29ic2VydmVyLnN0eWxlUHJvdGVjdGlvbkNvdW50IDwgTUFYX1NUWUxFX1BST1RFQ1RJT05fQ09VTlQpIHtcbiAgICAgICAgb2JzZXJ2ZXIub2JzZXJ2ZSh0YXJnZXQsIHByb3RlY3Rpb25PYnNlcnZlck9wdGlvbik7XG4gICAgICB9IGVsc2Uge1xuICAgICAgICB1dGlscy5sb2dFcnJvcignRXh0ZW5kZWRDc3M6IGluZmluaXRlIGxvb3AgcHJvdGVjdGlvbiBmb3Igc3R5bGUnKTtcbiAgICAgIH1cbiAgICB9XG5cbiAgICByZXR1cm4gcHJvdGVjdGlvbkZ1bmN0aW9uO1xuICB9XG4gIC8qKlxuICAgKiBTZXRzIHVwIGEgTXV0YXRpb25PYnNlcnZlciB3aGljaCBwcm90ZWN0cyBzdHlsZSBhdHRyaWJ1dGVzIGZyb20gY2hhbmdlc1xuICAgKiBAcGFyYW0gbm9kZSBET00gbm9kZVxuICAgKiBAcGFyYW0gcnVsZXMgcnVsZXNcbiAgICogQHJldHVybnMgTXV0YXRpb24gb2JzZXJ2ZXIgdXNlZCB0byBwcm90ZWN0IGF0dHJpYnV0ZSBvciBudWxsIGlmIHRoZXJlJ3Mgbm90aGluZyB0byBwcm90ZWN0XG4gICAqL1xuXG5cbiAgZnVuY3Rpb24gcHJvdGVjdFN0eWxlQXR0cmlidXRlKG5vZGUsIHJ1bGVzKSB7XG4gICAgaWYgKCF1dGlscy5NdXRhdGlvbk9ic2VydmVyKSB7XG4gICAgICByZXR1cm4gbnVsbDtcbiAgICB9XG5cbiAgICB2YXIgc3R5bGVzID0gcnVsZXMubWFwKGZ1bmN0aW9uIChyKSB7XG4gICAgICByZXR1cm4gci5zdHlsZTtcbiAgICB9KTtcbiAgICB2YXIgcHJvdGVjdGlvbk9ic2VydmVyID0gbmV3IHV0aWxzLk11dGF0aW9uT2JzZXJ2ZXIoY3JlYXRlUHJvdGVjdGlvbkZ1bmN0aW9uKHN0eWxlcykpO1xuICAgIHByb3RlY3Rpb25PYnNlcnZlci5vYnNlcnZlKG5vZGUsIHByb3RlY3Rpb25PYnNlcnZlck9wdGlvbik7IC8vIEFkZHMgYW4gZXhwYW5kbyB0byB0aGUgb2JzZXJ2ZXIgdG8ga2VlcCAnc3R5bGUgZml4IGNvdW50cycuXG5cbiAgICBwcm90ZWN0aW9uT2JzZXJ2ZXIuc3R5bGVQcm90ZWN0aW9uQ291bnQgPSAwO1xuICAgIHJldHVybiBwcm90ZWN0aW9uT2JzZXJ2ZXI7XG4gIH1cblxuICBmdW5jdGlvbiByZW1vdmVTdWZmaXgoc3RyLCBzdWZmaXgpIHtcbiAgICB2YXIgaW5kZXggPSBzdHIuaW5kZXhPZihzdWZmaXgsIHN0ci5sZW5ndGggLSBzdWZmaXgubGVuZ3RoKTtcblxuICAgIGlmIChpbmRleCA+PSAwKSB7XG4gICAgICByZXR1cm4gc3RyLnN1YnN0cmluZygwLCBpbmRleCk7XG4gICAgfVxuXG4gICAgcmV0dXJuIHN0cjtcbiAgfVxuICAvKipcbiAgICogRmluZHMgYWZmZWN0ZWRFbGVtZW50IG9iamVjdCBmb3IgdGhlIHNwZWNpZmllZCBET00gbm9kZVxuICAgKiBAcGFyYW0gbm9kZSAgRE9NIG5vZGVcbiAgICogQHJldHVybnMgICAgIGFmZmVjdGVkRWxlbWVudCBmb3VuZCBvciBudWxsXG4gICAqL1xuXG5cbiAgZnVuY3Rpb24gZmluZEFmZmVjdGVkRWxlbWVudChub2RlKSB7XG4gICAgZm9yICh2YXIgaSA9IDA7IGkgPCBhZmZlY3RlZEVsZW1lbnRzLmxlbmd0aDsgaSArPSAxKSB7XG4gICAgICBpZiAoYWZmZWN0ZWRFbGVtZW50c1tpXS5ub2RlID09PSBub2RlKSB7XG4gICAgICAgIHJldHVybiBhZmZlY3RlZEVsZW1lbnRzW2ldO1xuICAgICAgfVxuICAgIH1cblxuICAgIHJldHVybiBudWxsO1xuICB9XG5cbiAgZnVuY3Rpb24gcmVtb3ZlRWxlbWVudChhZmZlY3RlZEVsZW1lbnQpIHtcbiAgICB2YXIgbm9kZSA9IGFmZmVjdGVkRWxlbWVudC5ub2RlO1xuICAgIGFmZmVjdGVkRWxlbWVudC5yZW1vdmVkID0gdHJ1ZTtcbiAgICB2YXIgZWxlbWVudFNlbGVjdG9yID0gdXRpbHMuZ2V0Tm9kZVNlbGVjdG9yKG5vZGUpOyAvLyBjaGVjayBpZiB0aGUgZWxlbWVudCBoYXMgYmVlbiBhbHJlYWR5IHJlbW92ZWQgZWFybGllclxuXG4gICAgdmFyIGVsZW1lbnRSZW1vdmFsc0NvdW50ZXIgPSByZW1vdmFsc1N0YXRpc3RpY1tlbGVtZW50U2VsZWN0b3JdIHx8IDA7IC8vIGlmIHJlbW92YWxzIGF0dGVtcHRzIGhhcHBlbmVkIG1vcmUgdGhhbiBzcGVjaWZpZWQgd2UgZG8gbm90IHRyeSB0byByZW1vdmUgbm9kZSBhZ2FpblxuXG4gICAgaWYgKGVsZW1lbnRSZW1vdmFsc0NvdW50ZXIgPiBNQVhfU1RZTEVfUFJPVEVDVElPTl9DT1VOVCkge1xuICAgICAgdXRpbHMubG9nRXJyb3IoJ0V4dGVuZGVkQ3NzOiBpbmZpbml0ZSBsb29wIHByb3RlY3Rpb24gZm9yIFNFTEVDVE9SJywgZWxlbWVudFNlbGVjdG9yKTtcbiAgICAgIHJldHVybjtcbiAgICB9XG5cbiAgICBpZiAobm9kZS5wYXJlbnROb2RlKSB7XG4gICAgICBub2RlLnBhcmVudE5vZGUucmVtb3ZlQ2hpbGQobm9kZSk7XG4gICAgICByZW1vdmFsc1N0YXRpc3RpY1tlbGVtZW50U2VsZWN0b3JdID0gZWxlbWVudFJlbW92YWxzQ291bnRlciArIDE7XG4gICAgfVxuICB9XG4gIC8qKlxuICAgKiBBcHBsaWVzIHN0eWxlIHRvIHRoZSBzcGVjaWZpZWQgRE9NIG5vZGVcbiAgICogQHBhcmFtIGFmZmVjdGVkRWxlbWVudCBPYmplY3QgY29udGFpbmluZyBET00gbm9kZSBhbmQgcnVsZSB0byBiZSBhcHBsaWVkXG4gICAqL1xuXG5cbiAgZnVuY3Rpb24gYXBwbHlTdHlsZShhZmZlY3RlZEVsZW1lbnQpIHtcbiAgICBpZiAoYWZmZWN0ZWRFbGVtZW50LnByb3RlY3Rpb25PYnNlcnZlcikge1xuICAgICAgLy8gU3R5bGUgaXMgYWxyZWFkeSBhcHBsaWVkIGFuZCBwcm90ZWN0ZWQgYnkgdGhlIG9ic2VydmVyXG4gICAgICByZXR1cm47XG4gICAgfVxuXG4gICAgaWYgKGJlZm9yZVN0eWxlQXBwbGllZCkge1xuICAgICAgYWZmZWN0ZWRFbGVtZW50ID0gYmVmb3JlU3R5bGVBcHBsaWVkKGFmZmVjdGVkRWxlbWVudCk7XG5cbiAgICAgIGlmICghYWZmZWN0ZWRFbGVtZW50KSB7XG4gICAgICAgIHJldHVybjtcbiAgICAgIH1cbiAgICB9XG5cbiAgICB2YXIgX2FmZmVjdGVkRWxlbWVudCA9IGFmZmVjdGVkRWxlbWVudCxcbiAgICAgICAgbm9kZSA9IF9hZmZlY3RlZEVsZW1lbnQubm9kZTtcblxuICAgIGZvciAodmFyIGkgPSAwOyBpIDwgYWZmZWN0ZWRFbGVtZW50LnJ1bGVzLmxlbmd0aDsgaSsrKSB7XG4gICAgICB2YXIgc3R5bGUgPSBhZmZlY3RlZEVsZW1lbnQucnVsZXNbaV0uc3R5bGU7XG5cbiAgICAgIGlmIChzdHlsZVsncmVtb3ZlJ10gPT09ICd0cnVlJykge1xuICAgICAgICByZW1vdmVFbGVtZW50KGFmZmVjdGVkRWxlbWVudCk7XG4gICAgICAgIHJldHVybjtcbiAgICAgIH1cblxuICAgICAgc2V0U3R5bGVUb0VsZW1lbnQobm9kZSwgc3R5bGUpO1xuICAgIH1cbiAgfVxuICAvKipcbiAgICogU2V0cyBzdHlsZSB0byB0aGUgc3BlY2lmaWVkIERPTSBub2RlXG4gICAqIEBwYXJhbSBub2RlIGVsZW1lbnRcbiAgICogQHBhcmFtIHN0eWxlIHN0eWxlXG4gICAqL1xuXG5cbiAgZnVuY3Rpb24gc2V0U3R5bGVUb0VsZW1lbnQobm9kZSwgc3R5bGUpIHtcbiAgICBPYmplY3Qua2V5cyhzdHlsZSkuZm9yRWFjaChmdW5jdGlvbiAocHJvcCkge1xuICAgICAgLy8gQXBwbHkgdGhpcyBzdHlsZSBvbmx5IHRvIGV4aXN0aW5nIHByb3BlcnRpZXNcbiAgICAgIC8vIFdlIGNhbid0IHVzZSBoYXNPd25Qcm9wZXJ0eSBoZXJlIChkb2VzIG5vdCB3b3JrIGluIEZGKVxuICAgICAgaWYgKHR5cGVvZiBub2RlLnN0eWxlLmdldFByb3BlcnR5VmFsdWUocHJvcCkgIT09ICd1bmRlZmluZWQnKSB7XG4gICAgICAgIHZhciB2YWx1ZSA9IHN0eWxlW3Byb3BdOyAvLyBGaXJzdCB3ZSBzaG91bGQgcmVtb3ZlICFpbXBvcnRhbnQgYXR0cmlidXRlIChvciBpdCB3b24ndCBiZSBhcHBsaWVkJylcblxuICAgICAgICB2YWx1ZSA9IHJlbW92ZVN1ZmZpeCh2YWx1ZS50cmltKCksICchaW1wb3J0YW50JykudHJpbSgpO1xuICAgICAgICBub2RlLnN0eWxlLnNldFByb3BlcnR5KHByb3AsIHZhbHVlLCAnaW1wb3J0YW50Jyk7XG4gICAgICB9XG4gICAgfSk7XG4gIH1cbiAgLyoqXG4gICAqIFJldmVydHMgc3R5bGUgZm9yIHRoZSBhZmZlY3RlZCBvYmplY3RcbiAgICovXG5cblxuICBmdW5jdGlvbiByZXZlcnRTdHlsZShhZmZlY3RlZEVsZW1lbnQpIHtcbiAgICBpZiAoYWZmZWN0ZWRFbGVtZW50LnByb3RlY3Rpb25PYnNlcnZlcikge1xuICAgICAgYWZmZWN0ZWRFbGVtZW50LnByb3RlY3Rpb25PYnNlcnZlci5kaXNjb25uZWN0KCk7XG4gICAgfVxuXG4gICAgYWZmZWN0ZWRFbGVtZW50Lm5vZGUuc3R5bGUuY3NzVGV4dCA9IGFmZmVjdGVkRWxlbWVudC5vcmlnaW5hbFN0eWxlO1xuICB9XG4gIC8qKlxuICAgKiBBcHBsaWVzIHNwZWNpZmllZCBydWxlIGFuZCByZXR1cm5zIGxpc3Qgb2YgZWxlbWVudHMgYWZmZWN0ZWRcbiAgICogQHBhcmFtIHJ1bGUgUnVsZSB0byBhcHBseVxuICAgKiBAcmV0dXJucyBMaXN0IG9mIGVsZW1lbnRzIGFmZmVjdGVkIGJ5IHRoaXMgcnVsZVxuICAgKi9cblxuXG4gIGZ1bmN0aW9uIGFwcGx5UnVsZShydWxlKSB7XG4gICAgdmFyIGRlYnVnID0gcnVsZS5zZWxlY3Rvci5pc0RlYnVnZ2luZygpO1xuICAgIHZhciBzdGFydDtcblxuICAgIGlmIChkZWJ1Zykge1xuICAgICAgc3RhcnQgPSB1dGlscy5Bc3luY1dyYXBwZXIubm93KCk7XG4gICAgfVxuXG4gICAgdmFyIHNlbGVjdG9yID0gcnVsZS5zZWxlY3RvcjtcbiAgICB2YXIgbm9kZXMgPSBzZWxlY3Rvci5xdWVyeVNlbGVjdG9yQWxsKCk7XG4gICAgbm9kZXMuZm9yRWFjaChmdW5jdGlvbiAobm9kZSkge1xuICAgICAgdmFyIGFmZmVjdGVkRWxlbWVudCA9IGZpbmRBZmZlY3RlZEVsZW1lbnQobm9kZSk7XG5cbiAgICAgIGlmIChhZmZlY3RlZEVsZW1lbnQpIHtcbiAgICAgICAgYWZmZWN0ZWRFbGVtZW50LnJ1bGVzLnB1c2gocnVsZSk7XG4gICAgICAgIGFwcGx5U3R5bGUoYWZmZWN0ZWRFbGVtZW50KTtcbiAgICAgIH0gZWxzZSB7XG4gICAgICAgIC8vIEFwcGx5aW5nIHN0eWxlIGZpcnN0IHRpbWVcbiAgICAgICAgdmFyIG9yaWdpbmFsU3R5bGUgPSBub2RlLnN0eWxlLmNzc1RleHQ7XG4gICAgICAgIGFmZmVjdGVkRWxlbWVudCA9IHtcbiAgICAgICAgICBub2RlOiBub2RlLFxuICAgICAgICAgIC8vIGFmZmVjdGVkIERPTSBub2RlXG4gICAgICAgICAgcnVsZXM6IFtydWxlXSxcbiAgICAgICAgICAvLyBydWxlcyB0byBiZSBhcHBsaWVkXG4gICAgICAgICAgb3JpZ2luYWxTdHlsZTogb3JpZ2luYWxTdHlsZSxcbiAgICAgICAgICAvLyBvcmlnaW5hbCBub2RlIHN0eWxlXG4gICAgICAgICAgcHJvdGVjdGlvbk9ic2VydmVyOiBudWxsIC8vIHN0eWxlIGF0dHJpYnV0ZSBvYnNlcnZlclxuXG4gICAgICAgIH07XG4gICAgICAgIGFwcGx5U3R5bGUoYWZmZWN0ZWRFbGVtZW50KTtcbiAgICAgICAgYWZmZWN0ZWRFbGVtZW50cy5wdXNoKGFmZmVjdGVkRWxlbWVudCk7XG4gICAgICB9XG4gICAgfSk7XG5cbiAgICBpZiAoZGVidWcpIHtcbiAgICAgIHZhciBlbGFwc2VkID0gdXRpbHMuQXN5bmNXcmFwcGVyLm5vdygpIC0gc3RhcnQ7XG5cbiAgICAgIGlmICghKCd0aW1pbmdTdGF0cycgaW4gcnVsZSkpIHtcbiAgICAgICAgcnVsZS50aW1pbmdTdGF0cyA9IG5ldyB1dGlscy5TdGF0cygpO1xuICAgICAgfVxuXG4gICAgICBydWxlLnRpbWluZ1N0YXRzLnB1c2goZWxhcHNlZCk7XG4gICAgfVxuXG4gICAgcmV0dXJuIG5vZGVzO1xuICB9XG4gIC8qKlxuICAgKiBBcHBsaWVzIGZpbHRlcmluZyBydWxlc1xuICAgKi9cblxuXG4gIGZ1bmN0aW9uIGFwcGx5UnVsZXMoKSB7XG4gICAgdmFyIGVsZW1lbnRzSW5kZXggPSBbXTsgLy8gc29tZSBydWxlcyBjb3VsZCBtYWtlIGNhbGwgLSBzZWxlY3Rvci5xdWVyeVNlbGVjdG9yQWxsKCkgdGVtcG9yYXJpbHkgdG8gY2hhbmdlIG5vZGUgaWQgYXR0cmlidXRlXG4gICAgLy8gdGhpcyBjYXVzZWQgTXV0YXRpb25PYnNlcnZlciB0byBjYWxsIHJlY3Vyc2l2ZWx5XG4gICAgLy8gaHR0cHM6Ly9naXRodWIuY29tL0FkZ3VhcmRUZWFtL0V4dGVuZGVkQ3NzL2lzc3Vlcy84MVxuXG4gICAgc3RvcE9ic2VydmUoKTtcbiAgICBydWxlcy5mb3JFYWNoKGZ1bmN0aW9uIChydWxlKSB7XG4gICAgICB2YXIgbm9kZXMgPSBhcHBseVJ1bGUocnVsZSk7XG4gICAgICBBcnJheS5wcm90b3R5cGUucHVzaC5hcHBseShlbGVtZW50c0luZGV4LCBub2Rlcyk7XG4gICAgfSk7IC8vIE5vdyByZXZlcnQgc3R5bGVzIGZvciBlbGVtZW50cyB3aGljaCBhcmUgbm8gbW9yZSBhZmZlY3RlZFxuXG4gICAgdmFyIGwgPSBhZmZlY3RlZEVsZW1lbnRzLmxlbmd0aDsgLy8gZG8gbm90aGluZyBpZiB0aGVyZSBpcyBubyBlbGVtZW50cyB0byBwcm9jZXNzXG5cbiAgICBpZiAoZWxlbWVudHNJbmRleC5sZW5ndGggPiAwKSB7XG4gICAgICB3aGlsZSAobC0tKSB7XG4gICAgICAgIHZhciBvYmogPSBhZmZlY3RlZEVsZW1lbnRzW2xdO1xuXG4gICAgICAgIGlmIChlbGVtZW50c0luZGV4LmluZGV4T2Yob2JqLm5vZGUpID09PSAtMSkge1xuICAgICAgICAgIC8vIFRpbWUgdG8gcmV2ZXJ0IHN0eWxlXG4gICAgICAgICAgcmV2ZXJ0U3R5bGUob2JqKTtcbiAgICAgICAgICBhZmZlY3RlZEVsZW1lbnRzLnNwbGljZShsLCAxKTtcbiAgICAgICAgfSBlbHNlIGlmICghb2JqLnJlbW92ZWQpIHtcbiAgICAgICAgICAvLyBBZGQgc3R5bGUgcHJvdGVjdGlvbiBvYnNlcnZlclxuICAgICAgICAgIC8vIFByb3RlY3QgXCJzdHlsZVwiIGF0dHJpYnV0ZSBmcm9tIGNoYW5nZXNcbiAgICAgICAgICBpZiAoIW9iai5wcm90ZWN0aW9uT2JzZXJ2ZXIpIHtcbiAgICAgICAgICAgIG9iai5wcm90ZWN0aW9uT2JzZXJ2ZXIgPSBwcm90ZWN0U3R5bGVBdHRyaWJ1dGUob2JqLm5vZGUsIG9iai5ydWxlcyk7XG4gICAgICAgICAgfVxuICAgICAgICB9XG4gICAgICB9XG4gICAgfSAvLyBBZnRlciBzdHlsZXMgYXJlIGFwcGxpZWQgd2UgY2FuIHN0YXJ0IG9ic2VydmUgYWdhaW5cblxuXG4gICAgb2JzZXJ2ZSgpO1xuICAgIHByaW50VGltaW5nSW5mbygpO1xuICB9XG5cbiAgdmFyIEFQUExZX1JVTEVTX0RFTEFZID0gMTUwO1xuICB2YXIgYXBwbHlSdWxlc1NjaGVkdWxlciA9IG5ldyB1dGlscy5Bc3luY1dyYXBwZXIoYXBwbHlSdWxlcywgQVBQTFlfUlVMRVNfREVMQVkpO1xuICB2YXIgbWFpbkNhbGxiYWNrID0gYXBwbHlSdWxlc1NjaGVkdWxlci5ydW4uYmluZChhcHBseVJ1bGVzU2NoZWR1bGVyKTtcblxuICBmdW5jdGlvbiBvYnNlcnZlKCkge1xuICAgIGlmIChkb21PYnNlcnZlZCkge1xuICAgICAgcmV0dXJuO1xuICAgIH0gLy8gSGFuZGxlIGR5bmFtaWNhbGx5IGFkZGVkIGVsZW1lbnRzXG5cblxuICAgIGRvbU9ic2VydmVkID0gdHJ1ZTtcbiAgICBvYnNlcnZlRG9jdW1lbnQobWFpbkNhbGxiYWNrKTtcbiAgfVxuXG4gIGZ1bmN0aW9uIHN0b3BPYnNlcnZlKCkge1xuICAgIGlmICghZG9tT2JzZXJ2ZWQpIHtcbiAgICAgIHJldHVybjtcbiAgICB9XG5cbiAgICBkb21PYnNlcnZlZCA9IGZhbHNlO1xuICAgIGRpc2Nvbm5lY3REb2N1bWVudChtYWluQ2FsbGJhY2spO1xuICB9XG5cbiAgZnVuY3Rpb24gYXBwbHkoKSB7XG4gICAgYXBwbHlSdWxlcygpO1xuXG4gICAgaWYgKGRvY3VtZW50LnJlYWR5U3RhdGUgIT09ICdjb21wbGV0ZScpIHtcbiAgICAgIGRvY3VtZW50LmFkZEV2ZW50TGlzdGVuZXIoJ0RPTUNvbnRlbnRMb2FkZWQnLCBhcHBseVJ1bGVzKTtcbiAgICB9XG4gIH1cbiAgLyoqXG4gICAqIERpc3Bvc2VzIEV4dGVuZGVkQ3NzIGFuZCByZW1vdmVzIG91ciBzdHlsZXMgZnJvbSBtYXRjaGVkIGVsZW1lbnRzXG4gICAqL1xuXG5cbiAgZnVuY3Rpb24gZGlzcG9zZSgpIHtcbiAgICBzdG9wT2JzZXJ2ZSgpO1xuICAgIGFmZmVjdGVkRWxlbWVudHMuZm9yRWFjaChmdW5jdGlvbiAob2JqKSB7XG4gICAgICByZXZlcnRTdHlsZShvYmopO1xuICAgIH0pO1xuICB9XG5cbiAgdmFyIHRpbWluZ3NQcmludGVkID0gZmFsc2U7XG4gIC8qKlxuICAgKiBQcmludHMgdGltaW5nIGluZm9ybWF0aW9uIGZvciBhbGwgc2VsZWN0b3JzIG1hcmtlZCBhcyBcImRlYnVnXCJcbiAgICovXG5cbiAgZnVuY3Rpb24gcHJpbnRUaW1pbmdJbmZvKCkge1xuICAgIGlmICh0aW1pbmdzUHJpbnRlZCkge1xuICAgICAgcmV0dXJuO1xuICAgIH1cblxuICAgIHRpbWluZ3NQcmludGVkID0gdHJ1ZTtcbiAgICB2YXIgdGltaW5ncyA9IHJ1bGVzLmZpbHRlcihmdW5jdGlvbiAocnVsZSkge1xuICAgICAgcmV0dXJuIHJ1bGUuc2VsZWN0b3IuaXNEZWJ1Z2dpbmcoKTtcbiAgICB9KS5tYXAoZnVuY3Rpb24gKHJ1bGUpIHtcbiAgICAgIHJldHVybiB7XG4gICAgICAgIHNlbGVjdG9yVGV4dDogcnVsZS5zZWxlY3Rvci5zZWxlY3RvclRleHQsXG4gICAgICAgIHRpbWluZ1N0YXRzOiBydWxlLnRpbWluZ1N0YXRzXG4gICAgICB9O1xuICAgIH0pO1xuXG4gICAgaWYgKHRpbWluZ3MubGVuZ3RoID09PSAwKSB7XG4gICAgICByZXR1cm47XG4gICAgfSAvLyBBZGQgbG9jYXRpb24uaHJlZiB0byB0aGUgbWVzc2FnZSB0byBkaXN0aW5ndWlzaCBmcmFtZXNcblxuXG4gICAgdXRpbHMubG9nSW5mbygnW0V4dGVuZGVkQ3NzXSBUaW1pbmdzIGZvciAlbzpcXG4lbyAoaW4gbWlsbGlzZWNvbmRzKScsIHdpbmRvdy5sb2NhdGlvbi5ocmVmLCB0aW1pbmdzKTtcbiAgfSAvLyBGaXJzdCBvZiBhbGwgcGFyc2UgdGhlIHN0eWxlc2hlZXRcblxuXG4gIHJ1bGVzID0gRXh0ZW5kZWRDc3NQYXJzZXIucGFyc2VDc3Moc3R5bGVTaGVldCk7IC8vIEVYUE9TRVxuXG4gIHRoaXMuZGlzcG9zZSA9IGRpc3Bvc2U7XG4gIHRoaXMuYXBwbHkgPSBhcHBseTtcbiAgLyoqIEV4cG9zZWQgZm9yIHRlc3RpbmcgcHVycG9zZXMgb25seSAqL1xuXG4gIHRoaXMuX2dldEFmZmVjdGVkRWxlbWVudHMgPSBmdW5jdGlvbiAoKSB7XG4gICAgcmV0dXJuIGFmZmVjdGVkRWxlbWVudHM7XG4gIH07XG59XG4vKipcbiAqIEV4cG9zZSBxdWVyeVNlbGVjdG9yQWxsIGZvciBkZWJ1Z2dpbmcgYW5kIHZhbGlkYXRpbmcgc2VsZWN0b3JzXG4gKlxuICogQHBhcmFtIHtzdHJpbmd9IHNlbGVjdG9yVGV4dCBzZWxlY3RvciB0ZXh0XG4gKiBAcGFyYW0ge2Jvb2xlYW59IG5vVGltaW5nIGlmIHRydWUgLS0gZG8gbm90IHByaW50IHRoZSB0aW1pbmcgdG8gdGhlIGNvbnNvbGVcbiAqIEByZXR1cm5zIHtBcnJheTxOb2RlPnxOb2RlTGlzdH0gYSBsaXN0IG9mIGVsZW1lbnRzIGZvdW5kXG4gKiBAdGhyb3dzIFdpbGwgdGhyb3cgYW4gZXJyb3IgaWYgdGhlIGFyZ3VtZW50IGlzIG5vdCBhIHZhbGlkIHNlbGVjdG9yXG4gKi9cblxuXG5FeHRlbmRlZENzcy5xdWVyeSA9IGZ1bmN0aW9uIChzZWxlY3RvclRleHQsIG5vVGltaW5nKSB7XG4gIGlmICh0eXBlb2Ygc2VsZWN0b3JUZXh0ICE9PSAnc3RyaW5nJykge1xuICAgIHRocm93IG5ldyBFcnJvcignU2VsZWN0b3IgdGV4dCBpcyBlbXB0eScpO1xuICB9XG5cbiAgdmFyIG5vdyA9IHV0aWxzLkFzeW5jV3JhcHBlci5ub3c7XG4gIHZhciBzdGFydCA9IG5vdygpO1xuXG4gIHRyeSB7XG4gICAgcmV0dXJuIEV4dGVuZGVkU2VsZWN0b3JGYWN0b3J5LmNyZWF0ZVNlbGVjdG9yKHNlbGVjdG9yVGV4dCkucXVlcnlTZWxlY3RvckFsbCgpO1xuICB9IGZpbmFsbHkge1xuICAgIHZhciBlbmQgPSBub3coKTtcblxuICAgIGlmICghbm9UaW1pbmcpIHtcbiAgICAgIHV0aWxzLmxvZ0luZm8oXCJbRXh0ZW5kZWRDc3NdIEVsYXBzZWQ6IFwiLmNvbmNhdChNYXRoLnJvdW5kKChlbmQgLSBzdGFydCkgKiAxMDAwKSwgXCIgXFx1MDNCQ3MuXCIpKTtcbiAgICB9XG4gIH1cbn07XG5cbmV4cG9ydCBkZWZhdWx0IEV4dGVuZGVkQ3NzO1xuIiwiLyoqXG4gKiBDb3B5cmlnaHQgKGMpIDIwMTQtcHJlc2VudCwgRmFjZWJvb2ssIEluYy5cbiAqXG4gKiBUaGlzIHNvdXJjZSBjb2RlIGlzIGxpY2Vuc2VkIHVuZGVyIHRoZSBNSVQgbGljZW5zZSBmb3VuZCBpbiB0aGVcbiAqIExJQ0VOU0UgZmlsZSBpbiB0aGUgcm9vdCBkaXJlY3Rvcnkgb2YgdGhpcyBzb3VyY2UgdHJlZS5cbiAqL1xuXG52YXIgcnVudGltZSA9IChmdW5jdGlvbiAoZXhwb3J0cykge1xuICBcInVzZSBzdHJpY3RcIjtcblxuICB2YXIgT3AgPSBPYmplY3QucHJvdG90eXBlO1xuICB2YXIgaGFzT3duID0gT3AuaGFzT3duUHJvcGVydHk7XG4gIHZhciB1bmRlZmluZWQ7IC8vIE1vcmUgY29tcHJlc3NpYmxlIHRoYW4gdm9pZCAwLlxuICB2YXIgJFN5bWJvbCA9IHR5cGVvZiBTeW1ib2wgPT09IFwiZnVuY3Rpb25cIiA/IFN5bWJvbCA6IHt9O1xuICB2YXIgaXRlcmF0b3JTeW1ib2wgPSAkU3ltYm9sLml0ZXJhdG9yIHx8IFwiQEBpdGVyYXRvclwiO1xuICB2YXIgYXN5bmNJdGVyYXRvclN5bWJvbCA9ICRTeW1ib2wuYXN5bmNJdGVyYXRvciB8fCBcIkBAYXN5bmNJdGVyYXRvclwiO1xuICB2YXIgdG9TdHJpbmdUYWdTeW1ib2wgPSAkU3ltYm9sLnRvU3RyaW5nVGFnIHx8IFwiQEB0b1N0cmluZ1RhZ1wiO1xuXG4gIGZ1bmN0aW9uIGRlZmluZShvYmosIGtleSwgdmFsdWUpIHtcbiAgICBPYmplY3QuZGVmaW5lUHJvcGVydHkob2JqLCBrZXksIHtcbiAgICAgIHZhbHVlOiB2YWx1ZSxcbiAgICAgIGVudW1lcmFibGU6IHRydWUsXG4gICAgICBjb25maWd1cmFibGU6IHRydWUsXG4gICAgICB3cml0YWJsZTogdHJ1ZVxuICAgIH0pO1xuICAgIHJldHVybiBvYmpba2V5XTtcbiAgfVxuICB0cnkge1xuICAgIC8vIElFIDggaGFzIGEgYnJva2VuIE9iamVjdC5kZWZpbmVQcm9wZXJ0eSB0aGF0IG9ubHkgd29ya3Mgb24gRE9NIG9iamVjdHMuXG4gICAgZGVmaW5lKHt9LCBcIlwiKTtcbiAgfSBjYXRjaCAoZXJyKSB7XG4gICAgZGVmaW5lID0gZnVuY3Rpb24ob2JqLCBrZXksIHZhbHVlKSB7XG4gICAgICByZXR1cm4gb2JqW2tleV0gPSB2YWx1ZTtcbiAgICB9O1xuICB9XG5cbiAgZnVuY3Rpb24gd3JhcChpbm5lckZuLCBvdXRlckZuLCBzZWxmLCB0cnlMb2NzTGlzdCkge1xuICAgIC8vIElmIG91dGVyRm4gcHJvdmlkZWQgYW5kIG91dGVyRm4ucHJvdG90eXBlIGlzIGEgR2VuZXJhdG9yLCB0aGVuIG91dGVyRm4ucHJvdG90eXBlIGluc3RhbmNlb2YgR2VuZXJhdG9yLlxuICAgIHZhciBwcm90b0dlbmVyYXRvciA9IG91dGVyRm4gJiYgb3V0ZXJGbi5wcm90b3R5cGUgaW5zdGFuY2VvZiBHZW5lcmF0b3IgPyBvdXRlckZuIDogR2VuZXJhdG9yO1xuICAgIHZhciBnZW5lcmF0b3IgPSBPYmplY3QuY3JlYXRlKHByb3RvR2VuZXJhdG9yLnByb3RvdHlwZSk7XG4gICAgdmFyIGNvbnRleHQgPSBuZXcgQ29udGV4dCh0cnlMb2NzTGlzdCB8fCBbXSk7XG5cbiAgICAvLyBUaGUgLl9pbnZva2UgbWV0aG9kIHVuaWZpZXMgdGhlIGltcGxlbWVudGF0aW9ucyBvZiB0aGUgLm5leHQsXG4gICAgLy8gLnRocm93LCBhbmQgLnJldHVybiBtZXRob2RzLlxuICAgIGdlbmVyYXRvci5faW52b2tlID0gbWFrZUludm9rZU1ldGhvZChpbm5lckZuLCBzZWxmLCBjb250ZXh0KTtcblxuICAgIHJldHVybiBnZW5lcmF0b3I7XG4gIH1cbiAgZXhwb3J0cy53cmFwID0gd3JhcDtcblxuICAvLyBUcnkvY2F0Y2ggaGVscGVyIHRvIG1pbmltaXplIGRlb3B0aW1pemF0aW9ucy4gUmV0dXJucyBhIGNvbXBsZXRpb25cbiAgLy8gcmVjb3JkIGxpa2UgY29udGV4dC50cnlFbnRyaWVzW2ldLmNvbXBsZXRpb24uIFRoaXMgaW50ZXJmYWNlIGNvdWxkXG4gIC8vIGhhdmUgYmVlbiAoYW5kIHdhcyBwcmV2aW91c2x5KSBkZXNpZ25lZCB0byB0YWtlIGEgY2xvc3VyZSB0byBiZVxuICAvLyBpbnZva2VkIHdpdGhvdXQgYXJndW1lbnRzLCBidXQgaW4gYWxsIHRoZSBjYXNlcyB3ZSBjYXJlIGFib3V0IHdlXG4gIC8vIGFscmVhZHkgaGF2ZSBhbiBleGlzdGluZyBtZXRob2Qgd2Ugd2FudCB0byBjYWxsLCBzbyB0aGVyZSdzIG5vIG5lZWRcbiAgLy8gdG8gY3JlYXRlIGEgbmV3IGZ1bmN0aW9uIG9iamVjdC4gV2UgY2FuIGV2ZW4gZ2V0IGF3YXkgd2l0aCBhc3N1bWluZ1xuICAvLyB0aGUgbWV0aG9kIHRha2VzIGV4YWN0bHkgb25lIGFyZ3VtZW50LCBzaW5jZSB0aGF0IGhhcHBlbnMgdG8gYmUgdHJ1ZVxuICAvLyBpbiBldmVyeSBjYXNlLCBzbyB3ZSBkb24ndCBoYXZlIHRvIHRvdWNoIHRoZSBhcmd1bWVudHMgb2JqZWN0LiBUaGVcbiAgLy8gb25seSBhZGRpdGlvbmFsIGFsbG9jYXRpb24gcmVxdWlyZWQgaXMgdGhlIGNvbXBsZXRpb24gcmVjb3JkLCB3aGljaFxuICAvLyBoYXMgYSBzdGFibGUgc2hhcGUgYW5kIHNvIGhvcGVmdWxseSBzaG91bGQgYmUgY2hlYXAgdG8gYWxsb2NhdGUuXG4gIGZ1bmN0aW9uIHRyeUNhdGNoKGZuLCBvYmosIGFyZykge1xuICAgIHRyeSB7XG4gICAgICByZXR1cm4geyB0eXBlOiBcIm5vcm1hbFwiLCBhcmc6IGZuLmNhbGwob2JqLCBhcmcpIH07XG4gICAgfSBjYXRjaCAoZXJyKSB7XG4gICAgICByZXR1cm4geyB0eXBlOiBcInRocm93XCIsIGFyZzogZXJyIH07XG4gICAgfVxuICB9XG5cbiAgdmFyIEdlblN0YXRlU3VzcGVuZGVkU3RhcnQgPSBcInN1c3BlbmRlZFN0YXJ0XCI7XG4gIHZhciBHZW5TdGF0ZVN1c3BlbmRlZFlpZWxkID0gXCJzdXNwZW5kZWRZaWVsZFwiO1xuICB2YXIgR2VuU3RhdGVFeGVjdXRpbmcgPSBcImV4ZWN1dGluZ1wiO1xuICB2YXIgR2VuU3RhdGVDb21wbGV0ZWQgPSBcImNvbXBsZXRlZFwiO1xuXG4gIC8vIFJldHVybmluZyB0aGlzIG9iamVjdCBmcm9tIHRoZSBpbm5lckZuIGhhcyB0aGUgc2FtZSBlZmZlY3QgYXNcbiAgLy8gYnJlYWtpbmcgb3V0IG9mIHRoZSBkaXNwYXRjaCBzd2l0Y2ggc3RhdGVtZW50LlxuICB2YXIgQ29udGludWVTZW50aW5lbCA9IHt9O1xuXG4gIC8vIER1bW15IGNvbnN0cnVjdG9yIGZ1bmN0aW9ucyB0aGF0IHdlIHVzZSBhcyB0aGUgLmNvbnN0cnVjdG9yIGFuZFxuICAvLyAuY29uc3RydWN0b3IucHJvdG90eXBlIHByb3BlcnRpZXMgZm9yIGZ1bmN0aW9ucyB0aGF0IHJldHVybiBHZW5lcmF0b3JcbiAgLy8gb2JqZWN0cy4gRm9yIGZ1bGwgc3BlYyBjb21wbGlhbmNlLCB5b3UgbWF5IHdpc2ggdG8gY29uZmlndXJlIHlvdXJcbiAgLy8gbWluaWZpZXIgbm90IHRvIG1hbmdsZSB0aGUgbmFtZXMgb2YgdGhlc2UgdHdvIGZ1bmN0aW9ucy5cbiAgZnVuY3Rpb24gR2VuZXJhdG9yKCkge31cbiAgZnVuY3Rpb24gR2VuZXJhdG9yRnVuY3Rpb24oKSB7fVxuICBmdW5jdGlvbiBHZW5lcmF0b3JGdW5jdGlvblByb3RvdHlwZSgpIHt9XG5cbiAgLy8gVGhpcyBpcyBhIHBvbHlmaWxsIGZvciAlSXRlcmF0b3JQcm90b3R5cGUlIGZvciBlbnZpcm9ubWVudHMgdGhhdFxuICAvLyBkb24ndCBuYXRpdmVseSBzdXBwb3J0IGl0LlxuICB2YXIgSXRlcmF0b3JQcm90b3R5cGUgPSB7fTtcbiAgSXRlcmF0b3JQcm90b3R5cGVbaXRlcmF0b3JTeW1ib2xdID0gZnVuY3Rpb24gKCkge1xuICAgIHJldHVybiB0aGlzO1xuICB9O1xuXG4gIHZhciBnZXRQcm90byA9IE9iamVjdC5nZXRQcm90b3R5cGVPZjtcbiAgdmFyIE5hdGl2ZUl0ZXJhdG9yUHJvdG90eXBlID0gZ2V0UHJvdG8gJiYgZ2V0UHJvdG8oZ2V0UHJvdG8odmFsdWVzKFtdKSkpO1xuICBpZiAoTmF0aXZlSXRlcmF0b3JQcm90b3R5cGUgJiZcbiAgICAgIE5hdGl2ZUl0ZXJhdG9yUHJvdG90eXBlICE9PSBPcCAmJlxuICAgICAgaGFzT3duLmNhbGwoTmF0aXZlSXRlcmF0b3JQcm90b3R5cGUsIGl0ZXJhdG9yU3ltYm9sKSkge1xuICAgIC8vIFRoaXMgZW52aXJvbm1lbnQgaGFzIGEgbmF0aXZlICVJdGVyYXRvclByb3RvdHlwZSU7IHVzZSBpdCBpbnN0ZWFkXG4gICAgLy8gb2YgdGhlIHBvbHlmaWxsLlxuICAgIEl0ZXJhdG9yUHJvdG90eXBlID0gTmF0aXZlSXRlcmF0b3JQcm90b3R5cGU7XG4gIH1cblxuICB2YXIgR3AgPSBHZW5lcmF0b3JGdW5jdGlvblByb3RvdHlwZS5wcm90b3R5cGUgPVxuICAgIEdlbmVyYXRvci5wcm90b3R5cGUgPSBPYmplY3QuY3JlYXRlKEl0ZXJhdG9yUHJvdG90eXBlKTtcbiAgR2VuZXJhdG9yRnVuY3Rpb24ucHJvdG90eXBlID0gR3AuY29uc3RydWN0b3IgPSBHZW5lcmF0b3JGdW5jdGlvblByb3RvdHlwZTtcbiAgR2VuZXJhdG9yRnVuY3Rpb25Qcm90b3R5cGUuY29uc3RydWN0b3IgPSBHZW5lcmF0b3JGdW5jdGlvbjtcbiAgR2VuZXJhdG9yRnVuY3Rpb24uZGlzcGxheU5hbWUgPSBkZWZpbmUoXG4gICAgR2VuZXJhdG9yRnVuY3Rpb25Qcm90b3R5cGUsXG4gICAgdG9TdHJpbmdUYWdTeW1ib2wsXG4gICAgXCJHZW5lcmF0b3JGdW5jdGlvblwiXG4gICk7XG5cbiAgLy8gSGVscGVyIGZvciBkZWZpbmluZyB0aGUgLm5leHQsIC50aHJvdywgYW5kIC5yZXR1cm4gbWV0aG9kcyBvZiB0aGVcbiAgLy8gSXRlcmF0b3IgaW50ZXJmYWNlIGluIHRlcm1zIG9mIGEgc2luZ2xlIC5faW52b2tlIG1ldGhvZC5cbiAgZnVuY3Rpb24gZGVmaW5lSXRlcmF0b3JNZXRob2RzKHByb3RvdHlwZSkge1xuICAgIFtcIm5leHRcIiwgXCJ0aHJvd1wiLCBcInJldHVyblwiXS5mb3JFYWNoKGZ1bmN0aW9uKG1ldGhvZCkge1xuICAgICAgZGVmaW5lKHByb3RvdHlwZSwgbWV0aG9kLCBmdW5jdGlvbihhcmcpIHtcbiAgICAgICAgcmV0dXJuIHRoaXMuX2ludm9rZShtZXRob2QsIGFyZyk7XG4gICAgICB9KTtcbiAgICB9KTtcbiAgfVxuXG4gIGV4cG9ydHMuaXNHZW5lcmF0b3JGdW5jdGlvbiA9IGZ1bmN0aW9uKGdlbkZ1bikge1xuICAgIHZhciBjdG9yID0gdHlwZW9mIGdlbkZ1biA9PT0gXCJmdW5jdGlvblwiICYmIGdlbkZ1bi5jb25zdHJ1Y3RvcjtcbiAgICByZXR1cm4gY3RvclxuICAgICAgPyBjdG9yID09PSBHZW5lcmF0b3JGdW5jdGlvbiB8fFxuICAgICAgICAvLyBGb3IgdGhlIG5hdGl2ZSBHZW5lcmF0b3JGdW5jdGlvbiBjb25zdHJ1Y3RvciwgdGhlIGJlc3Qgd2UgY2FuXG4gICAgICAgIC8vIGRvIGlzIHRvIGNoZWNrIGl0cyAubmFtZSBwcm9wZXJ0eS5cbiAgICAgICAgKGN0b3IuZGlzcGxheU5hbWUgfHwgY3Rvci5uYW1lKSA9PT0gXCJHZW5lcmF0b3JGdW5jdGlvblwiXG4gICAgICA6IGZhbHNlO1xuICB9O1xuXG4gIGV4cG9ydHMubWFyayA9IGZ1bmN0aW9uKGdlbkZ1bikge1xuICAgIGlmIChPYmplY3Quc2V0UHJvdG90eXBlT2YpIHtcbiAgICAgIE9iamVjdC5zZXRQcm90b3R5cGVPZihnZW5GdW4sIEdlbmVyYXRvckZ1bmN0aW9uUHJvdG90eXBlKTtcbiAgICB9IGVsc2Uge1xuICAgICAgZ2VuRnVuLl9fcHJvdG9fXyA9IEdlbmVyYXRvckZ1bmN0aW9uUHJvdG90eXBlO1xuICAgICAgZGVmaW5lKGdlbkZ1biwgdG9TdHJpbmdUYWdTeW1ib2wsIFwiR2VuZXJhdG9yRnVuY3Rpb25cIik7XG4gICAgfVxuICAgIGdlbkZ1bi5wcm90b3R5cGUgPSBPYmplY3QuY3JlYXRlKEdwKTtcbiAgICByZXR1cm4gZ2VuRnVuO1xuICB9O1xuXG4gIC8vIFdpdGhpbiB0aGUgYm9keSBvZiBhbnkgYXN5bmMgZnVuY3Rpb24sIGBhd2FpdCB4YCBpcyB0cmFuc2Zvcm1lZCB0b1xuICAvLyBgeWllbGQgcmVnZW5lcmF0b3JSdW50aW1lLmF3cmFwKHgpYCwgc28gdGhhdCB0aGUgcnVudGltZSBjYW4gdGVzdFxuICAvLyBgaGFzT3duLmNhbGwodmFsdWUsIFwiX19hd2FpdFwiKWAgdG8gZGV0ZXJtaW5lIGlmIHRoZSB5aWVsZGVkIHZhbHVlIGlzXG4gIC8vIG1lYW50IHRvIGJlIGF3YWl0ZWQuXG4gIGV4cG9ydHMuYXdyYXAgPSBmdW5jdGlvbihhcmcpIHtcbiAgICByZXR1cm4geyBfX2F3YWl0OiBhcmcgfTtcbiAgfTtcblxuICBmdW5jdGlvbiBBc3luY0l0ZXJhdG9yKGdlbmVyYXRvciwgUHJvbWlzZUltcGwpIHtcbiAgICBmdW5jdGlvbiBpbnZva2UobWV0aG9kLCBhcmcsIHJlc29sdmUsIHJlamVjdCkge1xuICAgICAgdmFyIHJlY29yZCA9IHRyeUNhdGNoKGdlbmVyYXRvclttZXRob2RdLCBnZW5lcmF0b3IsIGFyZyk7XG4gICAgICBpZiAocmVjb3JkLnR5cGUgPT09IFwidGhyb3dcIikge1xuICAgICAgICByZWplY3QocmVjb3JkLmFyZyk7XG4gICAgICB9IGVsc2Uge1xuICAgICAgICB2YXIgcmVzdWx0ID0gcmVjb3JkLmFyZztcbiAgICAgICAgdmFyIHZhbHVlID0gcmVzdWx0LnZhbHVlO1xuICAgICAgICBpZiAodmFsdWUgJiZcbiAgICAgICAgICAgIHR5cGVvZiB2YWx1ZSA9PT0gXCJvYmplY3RcIiAmJlxuICAgICAgICAgICAgaGFzT3duLmNhbGwodmFsdWUsIFwiX19hd2FpdFwiKSkge1xuICAgICAgICAgIHJldHVybiBQcm9taXNlSW1wbC5yZXNvbHZlKHZhbHVlLl9fYXdhaXQpLnRoZW4oZnVuY3Rpb24odmFsdWUpIHtcbiAgICAgICAgICAgIGludm9rZShcIm5leHRcIiwgdmFsdWUsIHJlc29sdmUsIHJlamVjdCk7XG4gICAgICAgICAgfSwgZnVuY3Rpb24oZXJyKSB7XG4gICAgICAgICAgICBpbnZva2UoXCJ0aHJvd1wiLCBlcnIsIHJlc29sdmUsIHJlamVjdCk7XG4gICAgICAgICAgfSk7XG4gICAgICAgIH1cblxuICAgICAgICByZXR1cm4gUHJvbWlzZUltcGwucmVzb2x2ZSh2YWx1ZSkudGhlbihmdW5jdGlvbih1bndyYXBwZWQpIHtcbiAgICAgICAgICAvLyBXaGVuIGEgeWllbGRlZCBQcm9taXNlIGlzIHJlc29sdmVkLCBpdHMgZmluYWwgdmFsdWUgYmVjb21lc1xuICAgICAgICAgIC8vIHRoZSAudmFsdWUgb2YgdGhlIFByb21pc2U8e3ZhbHVlLGRvbmV9PiByZXN1bHQgZm9yIHRoZVxuICAgICAgICAgIC8vIGN1cnJlbnQgaXRlcmF0aW9uLlxuICAgICAgICAgIHJlc3VsdC52YWx1ZSA9IHVud3JhcHBlZDtcbiAgICAgICAgICByZXNvbHZlKHJlc3VsdCk7XG4gICAgICAgIH0sIGZ1bmN0aW9uKGVycm9yKSB7XG4gICAgICAgICAgLy8gSWYgYSByZWplY3RlZCBQcm9taXNlIHdhcyB5aWVsZGVkLCB0aHJvdyB0aGUgcmVqZWN0aW9uIGJhY2tcbiAgICAgICAgICAvLyBpbnRvIHRoZSBhc3luYyBnZW5lcmF0b3IgZnVuY3Rpb24gc28gaXQgY2FuIGJlIGhhbmRsZWQgdGhlcmUuXG4gICAgICAgICAgcmV0dXJuIGludm9rZShcInRocm93XCIsIGVycm9yLCByZXNvbHZlLCByZWplY3QpO1xuICAgICAgICB9KTtcbiAgICAgIH1cbiAgICB9XG5cbiAgICB2YXIgcHJldmlvdXNQcm9taXNlO1xuXG4gICAgZnVuY3Rpb24gZW5xdWV1ZShtZXRob2QsIGFyZykge1xuICAgICAgZnVuY3Rpb24gY2FsbEludm9rZVdpdGhNZXRob2RBbmRBcmcoKSB7XG4gICAgICAgIHJldHVybiBuZXcgUHJvbWlzZUltcGwoZnVuY3Rpb24ocmVzb2x2ZSwgcmVqZWN0KSB7XG4gICAgICAgICAgaW52b2tlKG1ldGhvZCwgYXJnLCByZXNvbHZlLCByZWplY3QpO1xuICAgICAgICB9KTtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIHByZXZpb3VzUHJvbWlzZSA9XG4gICAgICAgIC8vIElmIGVucXVldWUgaGFzIGJlZW4gY2FsbGVkIGJlZm9yZSwgdGhlbiB3ZSB3YW50IHRvIHdhaXQgdW50aWxcbiAgICAgICAgLy8gYWxsIHByZXZpb3VzIFByb21pc2VzIGhhdmUgYmVlbiByZXNvbHZlZCBiZWZvcmUgY2FsbGluZyBpbnZva2UsXG4gICAgICAgIC8vIHNvIHRoYXQgcmVzdWx0cyBhcmUgYWx3YXlzIGRlbGl2ZXJlZCBpbiB0aGUgY29ycmVjdCBvcmRlci4gSWZcbiAgICAgICAgLy8gZW5xdWV1ZSBoYXMgbm90IGJlZW4gY2FsbGVkIGJlZm9yZSwgdGhlbiBpdCBpcyBpbXBvcnRhbnQgdG9cbiAgICAgICAgLy8gY2FsbCBpbnZva2UgaW1tZWRpYXRlbHksIHdpdGhvdXQgd2FpdGluZyBvbiBhIGNhbGxiYWNrIHRvIGZpcmUsXG4gICAgICAgIC8vIHNvIHRoYXQgdGhlIGFzeW5jIGdlbmVyYXRvciBmdW5jdGlvbiBoYXMgdGhlIG9wcG9ydHVuaXR5IHRvIGRvXG4gICAgICAgIC8vIGFueSBuZWNlc3Nhcnkgc2V0dXAgaW4gYSBwcmVkaWN0YWJsZSB3YXkuIFRoaXMgcHJlZGljdGFiaWxpdHlcbiAgICAgICAgLy8gaXMgd2h5IHRoZSBQcm9taXNlIGNvbnN0cnVjdG9yIHN5bmNocm9ub3VzbHkgaW52b2tlcyBpdHNcbiAgICAgICAgLy8gZXhlY3V0b3IgY2FsbGJhY2ssIGFuZCB3aHkgYXN5bmMgZnVuY3Rpb25zIHN5bmNocm9ub3VzbHlcbiAgICAgICAgLy8gZXhlY3V0ZSBjb2RlIGJlZm9yZSB0aGUgZmlyc3QgYXdhaXQuIFNpbmNlIHdlIGltcGxlbWVudCBzaW1wbGVcbiAgICAgICAgLy8gYXN5bmMgZnVuY3Rpb25zIGluIHRlcm1zIG9mIGFzeW5jIGdlbmVyYXRvcnMsIGl0IGlzIGVzcGVjaWFsbHlcbiAgICAgICAgLy8gaW1wb3J0YW50IHRvIGdldCB0aGlzIHJpZ2h0LCBldmVuIHRob3VnaCBpdCByZXF1aXJlcyBjYXJlLlxuICAgICAgICBwcmV2aW91c1Byb21pc2UgPyBwcmV2aW91c1Byb21pc2UudGhlbihcbiAgICAgICAgICBjYWxsSW52b2tlV2l0aE1ldGhvZEFuZEFyZyxcbiAgICAgICAgICAvLyBBdm9pZCBwcm9wYWdhdGluZyBmYWlsdXJlcyB0byBQcm9taXNlcyByZXR1cm5lZCBieSBsYXRlclxuICAgICAgICAgIC8vIGludm9jYXRpb25zIG9mIHRoZSBpdGVyYXRvci5cbiAgICAgICAgICBjYWxsSW52b2tlV2l0aE1ldGhvZEFuZEFyZ1xuICAgICAgICApIDogY2FsbEludm9rZVdpdGhNZXRob2RBbmRBcmcoKTtcbiAgICB9XG5cbiAgICAvLyBEZWZpbmUgdGhlIHVuaWZpZWQgaGVscGVyIG1ldGhvZCB0aGF0IGlzIHVzZWQgdG8gaW1wbGVtZW50IC5uZXh0LFxuICAgIC8vIC50aHJvdywgYW5kIC5yZXR1cm4gKHNlZSBkZWZpbmVJdGVyYXRvck1ldGhvZHMpLlxuICAgIHRoaXMuX2ludm9rZSA9IGVucXVldWU7XG4gIH1cblxuICBkZWZpbmVJdGVyYXRvck1ldGhvZHMoQXN5bmNJdGVyYXRvci5wcm90b3R5cGUpO1xuICBBc3luY0l0ZXJhdG9yLnByb3RvdHlwZVthc3luY0l0ZXJhdG9yU3ltYm9sXSA9IGZ1bmN0aW9uICgpIHtcbiAgICByZXR1cm4gdGhpcztcbiAgfTtcbiAgZXhwb3J0cy5Bc3luY0l0ZXJhdG9yID0gQXN5bmNJdGVyYXRvcjtcblxuICAvLyBOb3RlIHRoYXQgc2ltcGxlIGFzeW5jIGZ1bmN0aW9ucyBhcmUgaW1wbGVtZW50ZWQgb24gdG9wIG9mXG4gIC8vIEFzeW5jSXRlcmF0b3Igb2JqZWN0czsgdGhleSBqdXN0IHJldHVybiBhIFByb21pc2UgZm9yIHRoZSB2YWx1ZSBvZlxuICAvLyB0aGUgZmluYWwgcmVzdWx0IHByb2R1Y2VkIGJ5IHRoZSBpdGVyYXRvci5cbiAgZXhwb3J0cy5hc3luYyA9IGZ1bmN0aW9uKGlubmVyRm4sIG91dGVyRm4sIHNlbGYsIHRyeUxvY3NMaXN0LCBQcm9taXNlSW1wbCkge1xuICAgIGlmIChQcm9taXNlSW1wbCA9PT0gdm9pZCAwKSBQcm9taXNlSW1wbCA9IFByb21pc2U7XG5cbiAgICB2YXIgaXRlciA9IG5ldyBBc3luY0l0ZXJhdG9yKFxuICAgICAgd3JhcChpbm5lckZuLCBvdXRlckZuLCBzZWxmLCB0cnlMb2NzTGlzdCksXG4gICAgICBQcm9taXNlSW1wbFxuICAgICk7XG5cbiAgICByZXR1cm4gZXhwb3J0cy5pc0dlbmVyYXRvckZ1bmN0aW9uKG91dGVyRm4pXG4gICAgICA/IGl0ZXIgLy8gSWYgb3V0ZXJGbiBpcyBhIGdlbmVyYXRvciwgcmV0dXJuIHRoZSBmdWxsIGl0ZXJhdG9yLlxuICAgICAgOiBpdGVyLm5leHQoKS50aGVuKGZ1bmN0aW9uKHJlc3VsdCkge1xuICAgICAgICAgIHJldHVybiByZXN1bHQuZG9uZSA/IHJlc3VsdC52YWx1ZSA6IGl0ZXIubmV4dCgpO1xuICAgICAgICB9KTtcbiAgfTtcblxuICBmdW5jdGlvbiBtYWtlSW52b2tlTWV0aG9kKGlubmVyRm4sIHNlbGYsIGNvbnRleHQpIHtcbiAgICB2YXIgc3RhdGUgPSBHZW5TdGF0ZVN1c3BlbmRlZFN0YXJ0O1xuXG4gICAgcmV0dXJuIGZ1bmN0aW9uIGludm9rZShtZXRob2QsIGFyZykge1xuICAgICAgaWYgKHN0YXRlID09PSBHZW5TdGF0ZUV4ZWN1dGluZykge1xuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJHZW5lcmF0b3IgaXMgYWxyZWFkeSBydW5uaW5nXCIpO1xuICAgICAgfVxuXG4gICAgICBpZiAoc3RhdGUgPT09IEdlblN0YXRlQ29tcGxldGVkKSB7XG4gICAgICAgIGlmIChtZXRob2QgPT09IFwidGhyb3dcIikge1xuICAgICAgICAgIHRocm93IGFyZztcbiAgICAgICAgfVxuXG4gICAgICAgIC8vIEJlIGZvcmdpdmluZywgcGVyIDI1LjMuMy4zLjMgb2YgdGhlIHNwZWM6XG4gICAgICAgIC8vIGh0dHBzOi8vcGVvcGxlLm1vemlsbGEub3JnL35qb3JlbmRvcmZmL2VzNi1kcmFmdC5odG1sI3NlYy1nZW5lcmF0b3JyZXN1bWVcbiAgICAgICAgcmV0dXJuIGRvbmVSZXN1bHQoKTtcbiAgICAgIH1cblxuICAgICAgY29udGV4dC5tZXRob2QgPSBtZXRob2Q7XG4gICAgICBjb250ZXh0LmFyZyA9IGFyZztcblxuICAgICAgd2hpbGUgKHRydWUpIHtcbiAgICAgICAgdmFyIGRlbGVnYXRlID0gY29udGV4dC5kZWxlZ2F0ZTtcbiAgICAgICAgaWYgKGRlbGVnYXRlKSB7XG4gICAgICAgICAgdmFyIGRlbGVnYXRlUmVzdWx0ID0gbWF5YmVJbnZva2VEZWxlZ2F0ZShkZWxlZ2F0ZSwgY29udGV4dCk7XG4gICAgICAgICAgaWYgKGRlbGVnYXRlUmVzdWx0KSB7XG4gICAgICAgICAgICBpZiAoZGVsZWdhdGVSZXN1bHQgPT09IENvbnRpbnVlU2VudGluZWwpIGNvbnRpbnVlO1xuICAgICAgICAgICAgcmV0dXJuIGRlbGVnYXRlUmVzdWx0O1xuICAgICAgICAgIH1cbiAgICAgICAgfVxuXG4gICAgICAgIGlmIChjb250ZXh0Lm1ldGhvZCA9PT0gXCJuZXh0XCIpIHtcbiAgICAgICAgICAvLyBTZXR0aW5nIGNvbnRleHQuX3NlbnQgZm9yIGxlZ2FjeSBzdXBwb3J0IG9mIEJhYmVsJ3NcbiAgICAgICAgICAvLyBmdW5jdGlvbi5zZW50IGltcGxlbWVudGF0aW9uLlxuICAgICAgICAgIGNvbnRleHQuc2VudCA9IGNvbnRleHQuX3NlbnQgPSBjb250ZXh0LmFyZztcblxuICAgICAgICB9IGVsc2UgaWYgKGNvbnRleHQubWV0aG9kID09PSBcInRocm93XCIpIHtcbiAgICAgICAgICBpZiAoc3RhdGUgPT09IEdlblN0YXRlU3VzcGVuZGVkU3RhcnQpIHtcbiAgICAgICAgICAgIHN0YXRlID0gR2VuU3RhdGVDb21wbGV0ZWQ7XG4gICAgICAgICAgICB0aHJvdyBjb250ZXh0LmFyZztcbiAgICAgICAgICB9XG5cbiAgICAgICAgICBjb250ZXh0LmRpc3BhdGNoRXhjZXB0aW9uKGNvbnRleHQuYXJnKTtcblxuICAgICAgICB9IGVsc2UgaWYgKGNvbnRleHQubWV0aG9kID09PSBcInJldHVyblwiKSB7XG4gICAgICAgICAgY29udGV4dC5hYnJ1cHQoXCJyZXR1cm5cIiwgY29udGV4dC5hcmcpO1xuICAgICAgICB9XG5cbiAgICAgICAgc3RhdGUgPSBHZW5TdGF0ZUV4ZWN1dGluZztcblxuICAgICAgICB2YXIgcmVjb3JkID0gdHJ5Q2F0Y2goaW5uZXJGbiwgc2VsZiwgY29udGV4dCk7XG4gICAgICAgIGlmIChyZWNvcmQudHlwZSA9PT0gXCJub3JtYWxcIikge1xuICAgICAgICAgIC8vIElmIGFuIGV4Y2VwdGlvbiBpcyB0aHJvd24gZnJvbSBpbm5lckZuLCB3ZSBsZWF2ZSBzdGF0ZSA9PT1cbiAgICAgICAgICAvLyBHZW5TdGF0ZUV4ZWN1dGluZyBhbmQgbG9vcCBiYWNrIGZvciBhbm90aGVyIGludm9jYXRpb24uXG4gICAgICAgICAgc3RhdGUgPSBjb250ZXh0LmRvbmVcbiAgICAgICAgICAgID8gR2VuU3RhdGVDb21wbGV0ZWRcbiAgICAgICAgICAgIDogR2VuU3RhdGVTdXNwZW5kZWRZaWVsZDtcblxuICAgICAgICAgIGlmIChyZWNvcmQuYXJnID09PSBDb250aW51ZVNlbnRpbmVsKSB7XG4gICAgICAgICAgICBjb250aW51ZTtcbiAgICAgICAgICB9XG5cbiAgICAgICAgICByZXR1cm4ge1xuICAgICAgICAgICAgdmFsdWU6IHJlY29yZC5hcmcsXG4gICAgICAgICAgICBkb25lOiBjb250ZXh0LmRvbmVcbiAgICAgICAgICB9O1xuXG4gICAgICAgIH0gZWxzZSBpZiAocmVjb3JkLnR5cGUgPT09IFwidGhyb3dcIikge1xuICAgICAgICAgIHN0YXRlID0gR2VuU3RhdGVDb21wbGV0ZWQ7XG4gICAgICAgICAgLy8gRGlzcGF0Y2ggdGhlIGV4Y2VwdGlvbiBieSBsb29waW5nIGJhY2sgYXJvdW5kIHRvIHRoZVxuICAgICAgICAgIC8vIGNvbnRleHQuZGlzcGF0Y2hFeGNlcHRpb24oY29udGV4dC5hcmcpIGNhbGwgYWJvdmUuXG4gICAgICAgICAgY29udGV4dC5tZXRob2QgPSBcInRocm93XCI7XG4gICAgICAgICAgY29udGV4dC5hcmcgPSByZWNvcmQuYXJnO1xuICAgICAgICB9XG4gICAgICB9XG4gICAgfTtcbiAgfVxuXG4gIC8vIENhbGwgZGVsZWdhdGUuaXRlcmF0b3JbY29udGV4dC5tZXRob2RdKGNvbnRleHQuYXJnKSBhbmQgaGFuZGxlIHRoZVxuICAvLyByZXN1bHQsIGVpdGhlciBieSByZXR1cm5pbmcgYSB7IHZhbHVlLCBkb25lIH0gcmVzdWx0IGZyb20gdGhlXG4gIC8vIGRlbGVnYXRlIGl0ZXJhdG9yLCBvciBieSBtb2RpZnlpbmcgY29udGV4dC5tZXRob2QgYW5kIGNvbnRleHQuYXJnLFxuICAvLyBzZXR0aW5nIGNvbnRleHQuZGVsZWdhdGUgdG8gbnVsbCwgYW5kIHJldHVybmluZyB0aGUgQ29udGludWVTZW50aW5lbC5cbiAgZnVuY3Rpb24gbWF5YmVJbnZva2VEZWxlZ2F0ZShkZWxlZ2F0ZSwgY29udGV4dCkge1xuICAgIHZhciBtZXRob2QgPSBkZWxlZ2F0ZS5pdGVyYXRvcltjb250ZXh0Lm1ldGhvZF07XG4gICAgaWYgKG1ldGhvZCA9PT0gdW5kZWZpbmVkKSB7XG4gICAgICAvLyBBIC50aHJvdyBvciAucmV0dXJuIHdoZW4gdGhlIGRlbGVnYXRlIGl0ZXJhdG9yIGhhcyBubyAudGhyb3dcbiAgICAgIC8vIG1ldGhvZCBhbHdheXMgdGVybWluYXRlcyB0aGUgeWllbGQqIGxvb3AuXG4gICAgICBjb250ZXh0LmRlbGVnYXRlID0gbnVsbDtcblxuICAgICAgaWYgKGNvbnRleHQubWV0aG9kID09PSBcInRocm93XCIpIHtcbiAgICAgICAgLy8gTm90ZTogW1wicmV0dXJuXCJdIG11c3QgYmUgdXNlZCBmb3IgRVMzIHBhcnNpbmcgY29tcGF0aWJpbGl0eS5cbiAgICAgICAgaWYgKGRlbGVnYXRlLml0ZXJhdG9yW1wicmV0dXJuXCJdKSB7XG4gICAgICAgICAgLy8gSWYgdGhlIGRlbGVnYXRlIGl0ZXJhdG9yIGhhcyBhIHJldHVybiBtZXRob2QsIGdpdmUgaXQgYVxuICAgICAgICAgIC8vIGNoYW5jZSB0byBjbGVhbiB1cC5cbiAgICAgICAgICBjb250ZXh0Lm1ldGhvZCA9IFwicmV0dXJuXCI7XG4gICAgICAgICAgY29udGV4dC5hcmcgPSB1bmRlZmluZWQ7XG4gICAgICAgICAgbWF5YmVJbnZva2VEZWxlZ2F0ZShkZWxlZ2F0ZSwgY29udGV4dCk7XG5cbiAgICAgICAgICBpZiAoY29udGV4dC5tZXRob2QgPT09IFwidGhyb3dcIikge1xuICAgICAgICAgICAgLy8gSWYgbWF5YmVJbnZva2VEZWxlZ2F0ZShjb250ZXh0KSBjaGFuZ2VkIGNvbnRleHQubWV0aG9kIGZyb21cbiAgICAgICAgICAgIC8vIFwicmV0dXJuXCIgdG8gXCJ0aHJvd1wiLCBsZXQgdGhhdCBvdmVycmlkZSB0aGUgVHlwZUVycm9yIGJlbG93LlxuICAgICAgICAgICAgcmV0dXJuIENvbnRpbnVlU2VudGluZWw7XG4gICAgICAgICAgfVxuICAgICAgICB9XG5cbiAgICAgICAgY29udGV4dC5tZXRob2QgPSBcInRocm93XCI7XG4gICAgICAgIGNvbnRleHQuYXJnID0gbmV3IFR5cGVFcnJvcihcbiAgICAgICAgICBcIlRoZSBpdGVyYXRvciBkb2VzIG5vdCBwcm92aWRlIGEgJ3Rocm93JyBtZXRob2RcIik7XG4gICAgICB9XG5cbiAgICAgIHJldHVybiBDb250aW51ZVNlbnRpbmVsO1xuICAgIH1cblxuICAgIHZhciByZWNvcmQgPSB0cnlDYXRjaChtZXRob2QsIGRlbGVnYXRlLml0ZXJhdG9yLCBjb250ZXh0LmFyZyk7XG5cbiAgICBpZiAocmVjb3JkLnR5cGUgPT09IFwidGhyb3dcIikge1xuICAgICAgY29udGV4dC5tZXRob2QgPSBcInRocm93XCI7XG4gICAgICBjb250ZXh0LmFyZyA9IHJlY29yZC5hcmc7XG4gICAgICBjb250ZXh0LmRlbGVnYXRlID0gbnVsbDtcbiAgICAgIHJldHVybiBDb250aW51ZVNlbnRpbmVsO1xuICAgIH1cblxuICAgIHZhciBpbmZvID0gcmVjb3JkLmFyZztcblxuICAgIGlmICghIGluZm8pIHtcbiAgICAgIGNvbnRleHQubWV0aG9kID0gXCJ0aHJvd1wiO1xuICAgICAgY29udGV4dC5hcmcgPSBuZXcgVHlwZUVycm9yKFwiaXRlcmF0b3IgcmVzdWx0IGlzIG5vdCBhbiBvYmplY3RcIik7XG4gICAgICBjb250ZXh0LmRlbGVnYXRlID0gbnVsbDtcbiAgICAgIHJldHVybiBDb250aW51ZVNlbnRpbmVsO1xuICAgIH1cblxuICAgIGlmIChpbmZvLmRvbmUpIHtcbiAgICAgIC8vIEFzc2lnbiB0aGUgcmVzdWx0IG9mIHRoZSBmaW5pc2hlZCBkZWxlZ2F0ZSB0byB0aGUgdGVtcG9yYXJ5XG4gICAgICAvLyB2YXJpYWJsZSBzcGVjaWZpZWQgYnkgZGVsZWdhdGUucmVzdWx0TmFtZSAoc2VlIGRlbGVnYXRlWWllbGQpLlxuICAgICAgY29udGV4dFtkZWxlZ2F0ZS5yZXN1bHROYW1lXSA9IGluZm8udmFsdWU7XG5cbiAgICAgIC8vIFJlc3VtZSBleGVjdXRpb24gYXQgdGhlIGRlc2lyZWQgbG9jYXRpb24gKHNlZSBkZWxlZ2F0ZVlpZWxkKS5cbiAgICAgIGNvbnRleHQubmV4dCA9IGRlbGVnYXRlLm5leHRMb2M7XG5cbiAgICAgIC8vIElmIGNvbnRleHQubWV0aG9kIHdhcyBcInRocm93XCIgYnV0IHRoZSBkZWxlZ2F0ZSBoYW5kbGVkIHRoZVxuICAgICAgLy8gZXhjZXB0aW9uLCBsZXQgdGhlIG91dGVyIGdlbmVyYXRvciBwcm9jZWVkIG5vcm1hbGx5LiBJZlxuICAgICAgLy8gY29udGV4dC5tZXRob2Qgd2FzIFwibmV4dFwiLCBmb3JnZXQgY29udGV4dC5hcmcgc2luY2UgaXQgaGFzIGJlZW5cbiAgICAgIC8vIFwiY29uc3VtZWRcIiBieSB0aGUgZGVsZWdhdGUgaXRlcmF0b3IuIElmIGNvbnRleHQubWV0aG9kIHdhc1xuICAgICAgLy8gXCJyZXR1cm5cIiwgYWxsb3cgdGhlIG9yaWdpbmFsIC5yZXR1cm4gY2FsbCB0byBjb250aW51ZSBpbiB0aGVcbiAgICAgIC8vIG91dGVyIGdlbmVyYXRvci5cbiAgICAgIGlmIChjb250ZXh0Lm1ldGhvZCAhPT0gXCJyZXR1cm5cIikge1xuICAgICAgICBjb250ZXh0Lm1ldGhvZCA9IFwibmV4dFwiO1xuICAgICAgICBjb250ZXh0LmFyZyA9IHVuZGVmaW5lZDtcbiAgICAgIH1cblxuICAgIH0gZWxzZSB7XG4gICAgICAvLyBSZS15aWVsZCB0aGUgcmVzdWx0IHJldHVybmVkIGJ5IHRoZSBkZWxlZ2F0ZSBtZXRob2QuXG4gICAgICByZXR1cm4gaW5mbztcbiAgICB9XG5cbiAgICAvLyBUaGUgZGVsZWdhdGUgaXRlcmF0b3IgaXMgZmluaXNoZWQsIHNvIGZvcmdldCBpdCBhbmQgY29udGludWUgd2l0aFxuICAgIC8vIHRoZSBvdXRlciBnZW5lcmF0b3IuXG4gICAgY29udGV4dC5kZWxlZ2F0ZSA9IG51bGw7XG4gICAgcmV0dXJuIENvbnRpbnVlU2VudGluZWw7XG4gIH1cblxuICAvLyBEZWZpbmUgR2VuZXJhdG9yLnByb3RvdHlwZS57bmV4dCx0aHJvdyxyZXR1cm59IGluIHRlcm1zIG9mIHRoZVxuICAvLyB1bmlmaWVkIC5faW52b2tlIGhlbHBlciBtZXRob2QuXG4gIGRlZmluZUl0ZXJhdG9yTWV0aG9kcyhHcCk7XG5cbiAgZGVmaW5lKEdwLCB0b1N0cmluZ1RhZ1N5bWJvbCwgXCJHZW5lcmF0b3JcIik7XG5cbiAgLy8gQSBHZW5lcmF0b3Igc2hvdWxkIGFsd2F5cyByZXR1cm4gaXRzZWxmIGFzIHRoZSBpdGVyYXRvciBvYmplY3Qgd2hlbiB0aGVcbiAgLy8gQEBpdGVyYXRvciBmdW5jdGlvbiBpcyBjYWxsZWQgb24gaXQuIFNvbWUgYnJvd3NlcnMnIGltcGxlbWVudGF0aW9ucyBvZiB0aGVcbiAgLy8gaXRlcmF0b3IgcHJvdG90eXBlIGNoYWluIGluY29ycmVjdGx5IGltcGxlbWVudCB0aGlzLCBjYXVzaW5nIHRoZSBHZW5lcmF0b3JcbiAgLy8gb2JqZWN0IHRvIG5vdCBiZSByZXR1cm5lZCBmcm9tIHRoaXMgY2FsbC4gVGhpcyBlbnN1cmVzIHRoYXQgZG9lc24ndCBoYXBwZW4uXG4gIC8vIFNlZSBodHRwczovL2dpdGh1Yi5jb20vZmFjZWJvb2svcmVnZW5lcmF0b3IvaXNzdWVzLzI3NCBmb3IgbW9yZSBkZXRhaWxzLlxuICBHcFtpdGVyYXRvclN5bWJvbF0gPSBmdW5jdGlvbigpIHtcbiAgICByZXR1cm4gdGhpcztcbiAgfTtcblxuICBHcC50b1N0cmluZyA9IGZ1bmN0aW9uKCkge1xuICAgIHJldHVybiBcIltvYmplY3QgR2VuZXJhdG9yXVwiO1xuICB9O1xuXG4gIGZ1bmN0aW9uIHB1c2hUcnlFbnRyeShsb2NzKSB7XG4gICAgdmFyIGVudHJ5ID0geyB0cnlMb2M6IGxvY3NbMF0gfTtcblxuICAgIGlmICgxIGluIGxvY3MpIHtcbiAgICAgIGVudHJ5LmNhdGNoTG9jID0gbG9jc1sxXTtcbiAgICB9XG5cbiAgICBpZiAoMiBpbiBsb2NzKSB7XG4gICAgICBlbnRyeS5maW5hbGx5TG9jID0gbG9jc1syXTtcbiAgICAgIGVudHJ5LmFmdGVyTG9jID0gbG9jc1szXTtcbiAgICB9XG5cbiAgICB0aGlzLnRyeUVudHJpZXMucHVzaChlbnRyeSk7XG4gIH1cblxuICBmdW5jdGlvbiByZXNldFRyeUVudHJ5KGVudHJ5KSB7XG4gICAgdmFyIHJlY29yZCA9IGVudHJ5LmNvbXBsZXRpb24gfHwge307XG4gICAgcmVjb3JkLnR5cGUgPSBcIm5vcm1hbFwiO1xuICAgIGRlbGV0ZSByZWNvcmQuYXJnO1xuICAgIGVudHJ5LmNvbXBsZXRpb24gPSByZWNvcmQ7XG4gIH1cblxuICBmdW5jdGlvbiBDb250ZXh0KHRyeUxvY3NMaXN0KSB7XG4gICAgLy8gVGhlIHJvb3QgZW50cnkgb2JqZWN0IChlZmZlY3RpdmVseSBhIHRyeSBzdGF0ZW1lbnQgd2l0aG91dCBhIGNhdGNoXG4gICAgLy8gb3IgYSBmaW5hbGx5IGJsb2NrKSBnaXZlcyB1cyBhIHBsYWNlIHRvIHN0b3JlIHZhbHVlcyB0aHJvd24gZnJvbVxuICAgIC8vIGxvY2F0aW9ucyB3aGVyZSB0aGVyZSBpcyBubyBlbmNsb3NpbmcgdHJ5IHN0YXRlbWVudC5cbiAgICB0aGlzLnRyeUVudHJpZXMgPSBbeyB0cnlMb2M6IFwicm9vdFwiIH1dO1xuICAgIHRyeUxvY3NMaXN0LmZvckVhY2gocHVzaFRyeUVudHJ5LCB0aGlzKTtcbiAgICB0aGlzLnJlc2V0KHRydWUpO1xuICB9XG5cbiAgZXhwb3J0cy5rZXlzID0gZnVuY3Rpb24ob2JqZWN0KSB7XG4gICAgdmFyIGtleXMgPSBbXTtcbiAgICBmb3IgKHZhciBrZXkgaW4gb2JqZWN0KSB7XG4gICAgICBrZXlzLnB1c2goa2V5KTtcbiAgICB9XG4gICAga2V5cy5yZXZlcnNlKCk7XG5cbiAgICAvLyBSYXRoZXIgdGhhbiByZXR1cm5pbmcgYW4gb2JqZWN0IHdpdGggYSBuZXh0IG1ldGhvZCwgd2Uga2VlcFxuICAgIC8vIHRoaW5ncyBzaW1wbGUgYW5kIHJldHVybiB0aGUgbmV4dCBmdW5jdGlvbiBpdHNlbGYuXG4gICAgcmV0dXJuIGZ1bmN0aW9uIG5leHQoKSB7XG4gICAgICB3aGlsZSAoa2V5cy5sZW5ndGgpIHtcbiAgICAgICAgdmFyIGtleSA9IGtleXMucG9wKCk7XG4gICAgICAgIGlmIChrZXkgaW4gb2JqZWN0KSB7XG4gICAgICAgICAgbmV4dC52YWx1ZSA9IGtleTtcbiAgICAgICAgICBuZXh0LmRvbmUgPSBmYWxzZTtcbiAgICAgICAgICByZXR1cm4gbmV4dDtcbiAgICAgICAgfVxuICAgICAgfVxuXG4gICAgICAvLyBUbyBhdm9pZCBjcmVhdGluZyBhbiBhZGRpdGlvbmFsIG9iamVjdCwgd2UganVzdCBoYW5nIHRoZSAudmFsdWVcbiAgICAgIC8vIGFuZCAuZG9uZSBwcm9wZXJ0aWVzIG9mZiB0aGUgbmV4dCBmdW5jdGlvbiBvYmplY3QgaXRzZWxmLiBUaGlzXG4gICAgICAvLyBhbHNvIGVuc3VyZXMgdGhhdCB0aGUgbWluaWZpZXIgd2lsbCBub3QgYW5vbnltaXplIHRoZSBmdW5jdGlvbi5cbiAgICAgIG5leHQuZG9uZSA9IHRydWU7XG4gICAgICByZXR1cm4gbmV4dDtcbiAgICB9O1xuICB9O1xuXG4gIGZ1bmN0aW9uIHZhbHVlcyhpdGVyYWJsZSkge1xuICAgIGlmIChpdGVyYWJsZSkge1xuICAgICAgdmFyIGl0ZXJhdG9yTWV0aG9kID0gaXRlcmFibGVbaXRlcmF0b3JTeW1ib2xdO1xuICAgICAgaWYgKGl0ZXJhdG9yTWV0aG9kKSB7XG4gICAgICAgIHJldHVybiBpdGVyYXRvck1ldGhvZC5jYWxsKGl0ZXJhYmxlKTtcbiAgICAgIH1cblxuICAgICAgaWYgKHR5cGVvZiBpdGVyYWJsZS5uZXh0ID09PSBcImZ1bmN0aW9uXCIpIHtcbiAgICAgICAgcmV0dXJuIGl0ZXJhYmxlO1xuICAgICAgfVxuXG4gICAgICBpZiAoIWlzTmFOKGl0ZXJhYmxlLmxlbmd0aCkpIHtcbiAgICAgICAgdmFyIGkgPSAtMSwgbmV4dCA9IGZ1bmN0aW9uIG5leHQoKSB7XG4gICAgICAgICAgd2hpbGUgKCsraSA8IGl0ZXJhYmxlLmxlbmd0aCkge1xuICAgICAgICAgICAgaWYgKGhhc093bi5jYWxsKGl0ZXJhYmxlLCBpKSkge1xuICAgICAgICAgICAgICBuZXh0LnZhbHVlID0gaXRlcmFibGVbaV07XG4gICAgICAgICAgICAgIG5leHQuZG9uZSA9IGZhbHNlO1xuICAgICAgICAgICAgICByZXR1cm4gbmV4dDtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9XG5cbiAgICAgICAgICBuZXh0LnZhbHVlID0gdW5kZWZpbmVkO1xuICAgICAgICAgIG5leHQuZG9uZSA9IHRydWU7XG5cbiAgICAgICAgICByZXR1cm4gbmV4dDtcbiAgICAgICAgfTtcblxuICAgICAgICByZXR1cm4gbmV4dC5uZXh0ID0gbmV4dDtcbiAgICAgIH1cbiAgICB9XG5cbiAgICAvLyBSZXR1cm4gYW4gaXRlcmF0b3Igd2l0aCBubyB2YWx1ZXMuXG4gICAgcmV0dXJuIHsgbmV4dDogZG9uZVJlc3VsdCB9O1xuICB9XG4gIGV4cG9ydHMudmFsdWVzID0gdmFsdWVzO1xuXG4gIGZ1bmN0aW9uIGRvbmVSZXN1bHQoKSB7XG4gICAgcmV0dXJuIHsgdmFsdWU6IHVuZGVmaW5lZCwgZG9uZTogdHJ1ZSB9O1xuICB9XG5cbiAgQ29udGV4dC5wcm90b3R5cGUgPSB7XG4gICAgY29uc3RydWN0b3I6IENvbnRleHQsXG5cbiAgICByZXNldDogZnVuY3Rpb24oc2tpcFRlbXBSZXNldCkge1xuICAgICAgdGhpcy5wcmV2ID0gMDtcbiAgICAgIHRoaXMubmV4dCA9IDA7XG4gICAgICAvLyBSZXNldHRpbmcgY29udGV4dC5fc2VudCBmb3IgbGVnYWN5IHN1cHBvcnQgb2YgQmFiZWwnc1xuICAgICAgLy8gZnVuY3Rpb24uc2VudCBpbXBsZW1lbnRhdGlvbi5cbiAgICAgIHRoaXMuc2VudCA9IHRoaXMuX3NlbnQgPSB1bmRlZmluZWQ7XG4gICAgICB0aGlzLmRvbmUgPSBmYWxzZTtcbiAgICAgIHRoaXMuZGVsZWdhdGUgPSBudWxsO1xuXG4gICAgICB0aGlzLm1ldGhvZCA9IFwibmV4dFwiO1xuICAgICAgdGhpcy5hcmcgPSB1bmRlZmluZWQ7XG5cbiAgICAgIHRoaXMudHJ5RW50cmllcy5mb3JFYWNoKHJlc2V0VHJ5RW50cnkpO1xuXG4gICAgICBpZiAoIXNraXBUZW1wUmVzZXQpIHtcbiAgICAgICAgZm9yICh2YXIgbmFtZSBpbiB0aGlzKSB7XG4gICAgICAgICAgLy8gTm90IHN1cmUgYWJvdXQgdGhlIG9wdGltYWwgb3JkZXIgb2YgdGhlc2UgY29uZGl0aW9uczpcbiAgICAgICAgICBpZiAobmFtZS5jaGFyQXQoMCkgPT09IFwidFwiICYmXG4gICAgICAgICAgICAgIGhhc093bi5jYWxsKHRoaXMsIG5hbWUpICYmXG4gICAgICAgICAgICAgICFpc05hTigrbmFtZS5zbGljZSgxKSkpIHtcbiAgICAgICAgICAgIHRoaXNbbmFtZV0gPSB1bmRlZmluZWQ7XG4gICAgICAgICAgfVxuICAgICAgICB9XG4gICAgICB9XG4gICAgfSxcblxuICAgIHN0b3A6IGZ1bmN0aW9uKCkge1xuICAgICAgdGhpcy5kb25lID0gdHJ1ZTtcblxuICAgICAgdmFyIHJvb3RFbnRyeSA9IHRoaXMudHJ5RW50cmllc1swXTtcbiAgICAgIHZhciByb290UmVjb3JkID0gcm9vdEVudHJ5LmNvbXBsZXRpb247XG4gICAgICBpZiAocm9vdFJlY29yZC50eXBlID09PSBcInRocm93XCIpIHtcbiAgICAgICAgdGhyb3cgcm9vdFJlY29yZC5hcmc7XG4gICAgICB9XG5cbiAgICAgIHJldHVybiB0aGlzLnJ2YWw7XG4gICAgfSxcblxuICAgIGRpc3BhdGNoRXhjZXB0aW9uOiBmdW5jdGlvbihleGNlcHRpb24pIHtcbiAgICAgIGlmICh0aGlzLmRvbmUpIHtcbiAgICAgICAgdGhyb3cgZXhjZXB0aW9uO1xuICAgICAgfVxuXG4gICAgICB2YXIgY29udGV4dCA9IHRoaXM7XG4gICAgICBmdW5jdGlvbiBoYW5kbGUobG9jLCBjYXVnaHQpIHtcbiAgICAgICAgcmVjb3JkLnR5cGUgPSBcInRocm93XCI7XG4gICAgICAgIHJlY29yZC5hcmcgPSBleGNlcHRpb247XG4gICAgICAgIGNvbnRleHQubmV4dCA9IGxvYztcblxuICAgICAgICBpZiAoY2F1Z2h0KSB7XG4gICAgICAgICAgLy8gSWYgdGhlIGRpc3BhdGNoZWQgZXhjZXB0aW9uIHdhcyBjYXVnaHQgYnkgYSBjYXRjaCBibG9jayxcbiAgICAgICAgICAvLyB0aGVuIGxldCB0aGF0IGNhdGNoIGJsb2NrIGhhbmRsZSB0aGUgZXhjZXB0aW9uIG5vcm1hbGx5LlxuICAgICAgICAgIGNvbnRleHQubWV0aG9kID0gXCJuZXh0XCI7XG4gICAgICAgICAgY29udGV4dC5hcmcgPSB1bmRlZmluZWQ7XG4gICAgICAgIH1cblxuICAgICAgICByZXR1cm4gISEgY2F1Z2h0O1xuICAgICAgfVxuXG4gICAgICBmb3IgKHZhciBpID0gdGhpcy50cnlFbnRyaWVzLmxlbmd0aCAtIDE7IGkgPj0gMDsgLS1pKSB7XG4gICAgICAgIHZhciBlbnRyeSA9IHRoaXMudHJ5RW50cmllc1tpXTtcbiAgICAgICAgdmFyIHJlY29yZCA9IGVudHJ5LmNvbXBsZXRpb247XG5cbiAgICAgICAgaWYgKGVudHJ5LnRyeUxvYyA9PT0gXCJyb290XCIpIHtcbiAgICAgICAgICAvLyBFeGNlcHRpb24gdGhyb3duIG91dHNpZGUgb2YgYW55IHRyeSBibG9jayB0aGF0IGNvdWxkIGhhbmRsZVxuICAgICAgICAgIC8vIGl0LCBzbyBzZXQgdGhlIGNvbXBsZXRpb24gdmFsdWUgb2YgdGhlIGVudGlyZSBmdW5jdGlvbiB0b1xuICAgICAgICAgIC8vIHRocm93IHRoZSBleGNlcHRpb24uXG4gICAgICAgICAgcmV0dXJuIGhhbmRsZShcImVuZFwiKTtcbiAgICAgICAgfVxuXG4gICAgICAgIGlmIChlbnRyeS50cnlMb2MgPD0gdGhpcy5wcmV2KSB7XG4gICAgICAgICAgdmFyIGhhc0NhdGNoID0gaGFzT3duLmNhbGwoZW50cnksIFwiY2F0Y2hMb2NcIik7XG4gICAgICAgICAgdmFyIGhhc0ZpbmFsbHkgPSBoYXNPd24uY2FsbChlbnRyeSwgXCJmaW5hbGx5TG9jXCIpO1xuXG4gICAgICAgICAgaWYgKGhhc0NhdGNoICYmIGhhc0ZpbmFsbHkpIHtcbiAgICAgICAgICAgIGlmICh0aGlzLnByZXYgPCBlbnRyeS5jYXRjaExvYykge1xuICAgICAgICAgICAgICByZXR1cm4gaGFuZGxlKGVudHJ5LmNhdGNoTG9jLCB0cnVlKTtcbiAgICAgICAgICAgIH0gZWxzZSBpZiAodGhpcy5wcmV2IDwgZW50cnkuZmluYWxseUxvYykge1xuICAgICAgICAgICAgICByZXR1cm4gaGFuZGxlKGVudHJ5LmZpbmFsbHlMb2MpO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgfSBlbHNlIGlmIChoYXNDYXRjaCkge1xuICAgICAgICAgICAgaWYgKHRoaXMucHJldiA8IGVudHJ5LmNhdGNoTG9jKSB7XG4gICAgICAgICAgICAgIHJldHVybiBoYW5kbGUoZW50cnkuY2F0Y2hMb2MsIHRydWUpO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgfSBlbHNlIGlmIChoYXNGaW5hbGx5KSB7XG4gICAgICAgICAgICBpZiAodGhpcy5wcmV2IDwgZW50cnkuZmluYWxseUxvYykge1xuICAgICAgICAgICAgICByZXR1cm4gaGFuZGxlKGVudHJ5LmZpbmFsbHlMb2MpO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIHRocm93IG5ldyBFcnJvcihcInRyeSBzdGF0ZW1lbnQgd2l0aG91dCBjYXRjaCBvciBmaW5hbGx5XCIpO1xuICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgfVxuICAgIH0sXG5cbiAgICBhYnJ1cHQ6IGZ1bmN0aW9uKHR5cGUsIGFyZykge1xuICAgICAgZm9yICh2YXIgaSA9IHRoaXMudHJ5RW50cmllcy5sZW5ndGggLSAxOyBpID49IDA7IC0taSkge1xuICAgICAgICB2YXIgZW50cnkgPSB0aGlzLnRyeUVudHJpZXNbaV07XG4gICAgICAgIGlmIChlbnRyeS50cnlMb2MgPD0gdGhpcy5wcmV2ICYmXG4gICAgICAgICAgICBoYXNPd24uY2FsbChlbnRyeSwgXCJmaW5hbGx5TG9jXCIpICYmXG4gICAgICAgICAgICB0aGlzLnByZXYgPCBlbnRyeS5maW5hbGx5TG9jKSB7XG4gICAgICAgICAgdmFyIGZpbmFsbHlFbnRyeSA9IGVudHJ5O1xuICAgICAgICAgIGJyZWFrO1xuICAgICAgICB9XG4gICAgICB9XG5cbiAgICAgIGlmIChmaW5hbGx5RW50cnkgJiZcbiAgICAgICAgICAodHlwZSA9PT0gXCJicmVha1wiIHx8XG4gICAgICAgICAgIHR5cGUgPT09IFwiY29udGludWVcIikgJiZcbiAgICAgICAgICBmaW5hbGx5RW50cnkudHJ5TG9jIDw9IGFyZyAmJlxuICAgICAgICAgIGFyZyA8PSBmaW5hbGx5RW50cnkuZmluYWxseUxvYykge1xuICAgICAgICAvLyBJZ25vcmUgdGhlIGZpbmFsbHkgZW50cnkgaWYgY29udHJvbCBpcyBub3QganVtcGluZyB0byBhXG4gICAgICAgIC8vIGxvY2F0aW9uIG91dHNpZGUgdGhlIHRyeS9jYXRjaCBibG9jay5cbiAgICAgICAgZmluYWxseUVudHJ5ID0gbnVsbDtcbiAgICAgIH1cblxuICAgICAgdmFyIHJlY29yZCA9IGZpbmFsbHlFbnRyeSA/IGZpbmFsbHlFbnRyeS5jb21wbGV0aW9uIDoge307XG4gICAgICByZWNvcmQudHlwZSA9IHR5cGU7XG4gICAgICByZWNvcmQuYXJnID0gYXJnO1xuXG4gICAgICBpZiAoZmluYWxseUVudHJ5KSB7XG4gICAgICAgIHRoaXMubWV0aG9kID0gXCJuZXh0XCI7XG4gICAgICAgIHRoaXMubmV4dCA9IGZpbmFsbHlFbnRyeS5maW5hbGx5TG9jO1xuICAgICAgICByZXR1cm4gQ29udGludWVTZW50aW5lbDtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIHRoaXMuY29tcGxldGUocmVjb3JkKTtcbiAgICB9LFxuXG4gICAgY29tcGxldGU6IGZ1bmN0aW9uKHJlY29yZCwgYWZ0ZXJMb2MpIHtcbiAgICAgIGlmIChyZWNvcmQudHlwZSA9PT0gXCJ0aHJvd1wiKSB7XG4gICAgICAgIHRocm93IHJlY29yZC5hcmc7XG4gICAgICB9XG5cbiAgICAgIGlmIChyZWNvcmQudHlwZSA9PT0gXCJicmVha1wiIHx8XG4gICAgICAgICAgcmVjb3JkLnR5cGUgPT09IFwiY29udGludWVcIikge1xuICAgICAgICB0aGlzLm5leHQgPSByZWNvcmQuYXJnO1xuICAgICAgfSBlbHNlIGlmIChyZWNvcmQudHlwZSA9PT0gXCJyZXR1cm5cIikge1xuICAgICAgICB0aGlzLnJ2YWwgPSB0aGlzLmFyZyA9IHJlY29yZC5hcmc7XG4gICAgICAgIHRoaXMubWV0aG9kID0gXCJyZXR1cm5cIjtcbiAgICAgICAgdGhpcy5uZXh0ID0gXCJlbmRcIjtcbiAgICAgIH0gZWxzZSBpZiAocmVjb3JkLnR5cGUgPT09IFwibm9ybWFsXCIgJiYgYWZ0ZXJMb2MpIHtcbiAgICAgICAgdGhpcy5uZXh0ID0gYWZ0ZXJMb2M7XG4gICAgICB9XG5cbiAgICAgIHJldHVybiBDb250aW51ZVNlbnRpbmVsO1xuICAgIH0sXG5cbiAgICBmaW5pc2g6IGZ1bmN0aW9uKGZpbmFsbHlMb2MpIHtcbiAgICAgIGZvciAodmFyIGkgPSB0aGlzLnRyeUVudHJpZXMubGVuZ3RoIC0gMTsgaSA+PSAwOyAtLWkpIHtcbiAgICAgICAgdmFyIGVudHJ5ID0gdGhpcy50cnlFbnRyaWVzW2ldO1xuICAgICAgICBpZiAoZW50cnkuZmluYWxseUxvYyA9PT0gZmluYWxseUxvYykge1xuICAgICAgICAgIHRoaXMuY29tcGxldGUoZW50cnkuY29tcGxldGlvbiwgZW50cnkuYWZ0ZXJMb2MpO1xuICAgICAgICAgIHJlc2V0VHJ5RW50cnkoZW50cnkpO1xuICAgICAgICAgIHJldHVybiBDb250aW51ZVNlbnRpbmVsO1xuICAgICAgICB9XG4gICAgICB9XG4gICAgfSxcblxuICAgIFwiY2F0Y2hcIjogZnVuY3Rpb24odHJ5TG9jKSB7XG4gICAgICBmb3IgKHZhciBpID0gdGhpcy50cnlFbnRyaWVzLmxlbmd0aCAtIDE7IGkgPj0gMDsgLS1pKSB7XG4gICAgICAgIHZhciBlbnRyeSA9IHRoaXMudHJ5RW50cmllc1tpXTtcbiAgICAgICAgaWYgKGVudHJ5LnRyeUxvYyA9PT0gdHJ5TG9jKSB7XG4gICAgICAgICAgdmFyIHJlY29yZCA9IGVudHJ5LmNvbXBsZXRpb247XG4gICAgICAgICAgaWYgKHJlY29yZC50eXBlID09PSBcInRocm93XCIpIHtcbiAgICAgICAgICAgIHZhciB0aHJvd24gPSByZWNvcmQuYXJnO1xuICAgICAgICAgICAgcmVzZXRUcnlFbnRyeShlbnRyeSk7XG4gICAgICAgICAgfVxuICAgICAgICAgIHJldHVybiB0aHJvd247XG4gICAgICAgIH1cbiAgICAgIH1cblxuICAgICAgLy8gVGhlIGNvbnRleHQuY2F0Y2ggbWV0aG9kIG11c3Qgb25seSBiZSBjYWxsZWQgd2l0aCBhIGxvY2F0aW9uXG4gICAgICAvLyBhcmd1bWVudCB0aGF0IGNvcnJlc3BvbmRzIHRvIGEga25vd24gY2F0Y2ggYmxvY2suXG4gICAgICB0aHJvdyBuZXcgRXJyb3IoXCJpbGxlZ2FsIGNhdGNoIGF0dGVtcHRcIik7XG4gICAgfSxcblxuICAgIGRlbGVnYXRlWWllbGQ6IGZ1bmN0aW9uKGl0ZXJhYmxlLCByZXN1bHROYW1lLCBuZXh0TG9jKSB7XG4gICAgICB0aGlzLmRlbGVnYXRlID0ge1xuICAgICAgICBpdGVyYXRvcjogdmFsdWVzKGl0ZXJhYmxlKSxcbiAgICAgICAgcmVzdWx0TmFtZTogcmVzdWx0TmFtZSxcbiAgICAgICAgbmV4dExvYzogbmV4dExvY1xuICAgICAgfTtcblxuICAgICAgaWYgKHRoaXMubWV0aG9kID09PSBcIm5leHRcIikge1xuICAgICAgICAvLyBEZWxpYmVyYXRlbHkgZm9yZ2V0IHRoZSBsYXN0IHNlbnQgdmFsdWUgc28gdGhhdCB3ZSBkb24ndFxuICAgICAgICAvLyBhY2NpZGVudGFsbHkgcGFzcyBpdCBvbiB0byB0aGUgZGVsZWdhdGUuXG4gICAgICAgIHRoaXMuYXJnID0gdW5kZWZpbmVkO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gQ29udGludWVTZW50aW5lbDtcbiAgICB9XG4gIH07XG5cbiAgLy8gUmVnYXJkbGVzcyBvZiB3aGV0aGVyIHRoaXMgc2NyaXB0IGlzIGV4ZWN1dGluZyBhcyBhIENvbW1vbkpTIG1vZHVsZVxuICAvLyBvciBub3QsIHJldHVybiB0aGUgcnVudGltZSBvYmplY3Qgc28gdGhhdCB3ZSBjYW4gZGVjbGFyZSB0aGUgdmFyaWFibGVcbiAgLy8gcmVnZW5lcmF0b3JSdW50aW1lIGluIHRoZSBvdXRlciBzY29wZSwgd2hpY2ggYWxsb3dzIHRoaXMgbW9kdWxlIHRvIGJlXG4gIC8vIGluamVjdGVkIGVhc2lseSBieSBgYmluL3JlZ2VuZXJhdG9yIC0taW5jbHVkZS1ydW50aW1lIHNjcmlwdC5qc2AuXG4gIHJldHVybiBleHBvcnRzO1xuXG59KFxuICAvLyBJZiB0aGlzIHNjcmlwdCBpcyBleGVjdXRpbmcgYXMgYSBDb21tb25KUyBtb2R1bGUsIHVzZSBtb2R1bGUuZXhwb3J0c1xuICAvLyBhcyB0aGUgcmVnZW5lcmF0b3JSdW50aW1lIG5hbWVzcGFjZS4gT3RoZXJ3aXNlIGNyZWF0ZSBhIG5ldyBlbXB0eVxuICAvLyBvYmplY3QuIEVpdGhlciB3YXksIHRoZSByZXN1bHRpbmcgb2JqZWN0IHdpbGwgYmUgdXNlZCB0byBpbml0aWFsaXplXG4gIC8vIHRoZSByZWdlbmVyYXRvclJ1bnRpbWUgdmFyaWFibGUgYXQgdGhlIHRvcCBvZiB0aGlzIGZpbGUuXG4gIHR5cGVvZiBtb2R1bGUgPT09IFwib2JqZWN0XCIgPyBtb2R1bGUuZXhwb3J0cyA6IHt9XG4pKTtcblxudHJ5IHtcbiAgcmVnZW5lcmF0b3JSdW50aW1lID0gcnVudGltZTtcbn0gY2F0Y2ggKGFjY2lkZW50YWxTdHJpY3RNb2RlKSB7XG4gIC8vIFRoaXMgbW9kdWxlIHNob3VsZCBub3QgYmUgcnVubmluZyBpbiBzdHJpY3QgbW9kZSwgc28gdGhlIGFib3ZlXG4gIC8vIGFzc2lnbm1lbnQgc2hvdWxkIGFsd2F5cyB3b3JrIHVubGVzcyBzb21ldGhpbmcgaXMgbWlzY29uZmlndXJlZC4gSnVzdFxuICAvLyBpbiBjYXNlIHJ1bnRpbWUuanMgYWNjaWRlbnRhbGx5IHJ1bnMgaW4gc3RyaWN0IG1vZGUsIHdlIGNhbiBlc2NhcGVcbiAgLy8gc3RyaWN0IG1vZGUgdXNpbmcgYSBnbG9iYWwgRnVuY3Rpb24gY2FsbC4gVGhpcyBjb3VsZCBjb25jZWl2YWJseSBmYWlsXG4gIC8vIGlmIGEgQ29udGVudCBTZWN1cml0eSBQb2xpY3kgZm9yYmlkcyB1c2luZyBGdW5jdGlvbiwgYnV0IGluIHRoYXQgY2FzZVxuICAvLyB0aGUgcHJvcGVyIHNvbHV0aW9uIGlzIHRvIGZpeCB0aGUgYWNjaWRlbnRhbCBzdHJpY3QgbW9kZSBwcm9ibGVtLiBJZlxuICAvLyB5b3UndmUgbWlzY29uZmlndXJlZCB5b3VyIGJ1bmRsZXIgdG8gZm9yY2Ugc3RyaWN0IG1vZGUgYW5kIGFwcGxpZWQgYVxuICAvLyBDU1AgdG8gZm9yYmlkIEZ1bmN0aW9uLCBhbmQgeW91J3JlIG5vdCB3aWxsaW5nIHRvIGZpeCBlaXRoZXIgb2YgdGhvc2VcbiAgLy8gcHJvYmxlbXMsIHBsZWFzZSBkZXRhaWwgeW91ciB1bmlxdWUgcHJlZGljYW1lbnQgaW4gYSBHaXRIdWIgaXNzdWUuXG4gIEZ1bmN0aW9uKFwiclwiLCBcInJlZ2VuZXJhdG9yUnVudGltZSA9IHJcIikocnVudGltZSk7XG59XG4iLCJcInVzZSBzdHJpY3RcIjtcbk9iamVjdC5kZWZpbmVQcm9wZXJ0eShleHBvcnRzLCBcIl9fZXNNb2R1bGVcIiwgeyB2YWx1ZTogdHJ1ZSB9KTtcblxuZXhwb3J0cy5icm93c2VyID0gcmVxdWlyZShcIndlYmV4dGVuc2lvbi1wb2x5ZmlsbFwiKTtcbiIsIihmdW5jdGlvbiAoZ2xvYmFsLCBmYWN0b3J5KSB7XG4gIGlmICh0eXBlb2YgZGVmaW5lID09PSBcImZ1bmN0aW9uXCIgJiYgZGVmaW5lLmFtZCkge1xuICAgIGRlZmluZShcIndlYmV4dGVuc2lvbi1wb2x5ZmlsbFwiLCBbXCJtb2R1bGVcIl0sIGZhY3RvcnkpO1xuICB9IGVsc2UgaWYgKHR5cGVvZiBleHBvcnRzICE9PSBcInVuZGVmaW5lZFwiKSB7XG4gICAgZmFjdG9yeShtb2R1bGUpO1xuICB9IGVsc2Uge1xuICAgIHZhciBtb2QgPSB7XG4gICAgICBleHBvcnRzOiB7fVxuICAgIH07XG4gICAgZmFjdG9yeShtb2QpO1xuICAgIGdsb2JhbC5icm93c2VyID0gbW9kLmV4cG9ydHM7XG4gIH1cbn0pKHR5cGVvZiBnbG9iYWxUaGlzICE9PSBcInVuZGVmaW5lZFwiID8gZ2xvYmFsVGhpcyA6IHR5cGVvZiBzZWxmICE9PSBcInVuZGVmaW5lZFwiID8gc2VsZiA6IHRoaXMsIGZ1bmN0aW9uIChtb2R1bGUpIHtcbiAgLyogd2ViZXh0ZW5zaW9uLXBvbHlmaWxsIC0gdjAuNy4wIC0gVHVlIE5vdiAxMCAyMDIwIDIwOjI0OjA0ICovXG5cbiAgLyogLSotIE1vZGU6IGluZGVudC10YWJzLW1vZGU6IG5pbDsganMtaW5kZW50LWxldmVsOiAyIC0qLSAqL1xuXG4gIC8qIHZpbTogc2V0IHN0cz0yIHN3PTIgZXQgdHc9ODA6ICovXG5cbiAgLyogVGhpcyBTb3VyY2UgQ29kZSBGb3JtIGlzIHN1YmplY3QgdG8gdGhlIHRlcm1zIG9mIHRoZSBNb3ppbGxhIFB1YmxpY1xuICAgKiBMaWNlbnNlLCB2LiAyLjAuIElmIGEgY29weSBvZiB0aGUgTVBMIHdhcyBub3QgZGlzdHJpYnV0ZWQgd2l0aCB0aGlzXG4gICAqIGZpbGUsIFlvdSBjYW4gb2J0YWluIG9uZSBhdCBodHRwOi8vbW96aWxsYS5vcmcvTVBMLzIuMC8uICovXG4gIFwidXNlIHN0cmljdFwiO1xuXG4gIGlmICh0eXBlb2YgYnJvd3NlciA9PT0gXCJ1bmRlZmluZWRcIiB8fCBPYmplY3QuZ2V0UHJvdG90eXBlT2YoYnJvd3NlcikgIT09IE9iamVjdC5wcm90b3R5cGUpIHtcbiAgICBjb25zdCBDSFJPTUVfU0VORF9NRVNTQUdFX0NBTExCQUNLX05PX1JFU1BPTlNFX01FU1NBR0UgPSBcIlRoZSBtZXNzYWdlIHBvcnQgY2xvc2VkIGJlZm9yZSBhIHJlc3BvbnNlIHdhcyByZWNlaXZlZC5cIjtcbiAgICBjb25zdCBTRU5EX1JFU1BPTlNFX0RFUFJFQ0FUSU9OX1dBUk5JTkcgPSBcIlJldHVybmluZyBhIFByb21pc2UgaXMgdGhlIHByZWZlcnJlZCB3YXkgdG8gc2VuZCBhIHJlcGx5IGZyb20gYW4gb25NZXNzYWdlL29uTWVzc2FnZUV4dGVybmFsIGxpc3RlbmVyLCBhcyB0aGUgc2VuZFJlc3BvbnNlIHdpbGwgYmUgcmVtb3ZlZCBmcm9tIHRoZSBzcGVjcyAoU2VlIGh0dHBzOi8vZGV2ZWxvcGVyLm1vemlsbGEub3JnL2RvY3MvTW96aWxsYS9BZGQtb25zL1dlYkV4dGVuc2lvbnMvQVBJL3J1bnRpbWUvb25NZXNzYWdlKVwiOyAvLyBXcmFwcGluZyB0aGUgYnVsayBvZiB0aGlzIHBvbHlmaWxsIGluIGEgb25lLXRpbWUtdXNlIGZ1bmN0aW9uIGlzIGEgbWlub3JcbiAgICAvLyBvcHRpbWl6YXRpb24gZm9yIEZpcmVmb3guIFNpbmNlIFNwaWRlcm1vbmtleSBkb2VzIG5vdCBmdWxseSBwYXJzZSB0aGVcbiAgICAvLyBjb250ZW50cyBvZiBhIGZ1bmN0aW9uIHVudGlsIHRoZSBmaXJzdCB0aW1lIGl0J3MgY2FsbGVkLCBhbmQgc2luY2UgaXQgd2lsbFxuICAgIC8vIG5ldmVyIGFjdHVhbGx5IG5lZWQgdG8gYmUgY2FsbGVkLCB0aGlzIGFsbG93cyB0aGUgcG9seWZpbGwgdG8gYmUgaW5jbHVkZWRcbiAgICAvLyBpbiBGaXJlZm94IG5lYXJseSBmb3IgZnJlZS5cblxuICAgIGNvbnN0IHdyYXBBUElzID0gZXh0ZW5zaW9uQVBJcyA9PiB7XG4gICAgICAvLyBOT1RFOiBhcGlNZXRhZGF0YSBpcyBhc3NvY2lhdGVkIHRvIHRoZSBjb250ZW50IG9mIHRoZSBhcGktbWV0YWRhdGEuanNvbiBmaWxlXG4gICAgICAvLyBhdCBidWlsZCB0aW1lIGJ5IHJlcGxhY2luZyB0aGUgZm9sbG93aW5nIFwiaW5jbHVkZVwiIHdpdGggdGhlIGNvbnRlbnQgb2YgdGhlXG4gICAgICAvLyBKU09OIGZpbGUuXG4gICAgICBjb25zdCBhcGlNZXRhZGF0YSA9IHtcbiAgICAgICAgXCJhbGFybXNcIjoge1xuICAgICAgICAgIFwiY2xlYXJcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJjbGVhckFsbFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldEFsbFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcImJvb2ttYXJrc1wiOiB7XG4gICAgICAgICAgXCJjcmVhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRDaGlsZHJlblwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFJlY2VudFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFN1YlRyZWVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRUcmVlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwibW92ZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMixcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAyXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZVRyZWVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZWFyY2hcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJ1cGRhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDIsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJicm93c2VyQWN0aW9uXCI6IHtcbiAgICAgICAgICBcImRpc2FibGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwiZmFsbGJhY2tUb05vQ2FsbGJhY2tcIjogdHJ1ZVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJlbmFibGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwiZmFsbGJhY2tUb05vQ2FsbGJhY2tcIjogdHJ1ZVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRCYWRnZUJhY2tncm91bmRDb2xvclwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldEJhZGdlVGV4dFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFBvcHVwXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0VGl0bGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJvcGVuUG9wdXBcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZXRCYWRnZUJhY2tncm91bmRDb2xvclwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJmYWxsYmFja1RvTm9DYWxsYmFja1wiOiB0cnVlXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNldEJhZGdlVGV4dFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJmYWxsYmFja1RvTm9DYWxsYmFja1wiOiB0cnVlXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNldEljb25cIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZXRQb3B1cFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJmYWxsYmFja1RvTm9DYWxsYmFja1wiOiB0cnVlXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNldFRpdGxlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDEsXG4gICAgICAgICAgICBcImZhbGxiYWNrVG9Ob0NhbGxiYWNrXCI6IHRydWVcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwiYnJvd3NpbmdEYXRhXCI6IHtcbiAgICAgICAgICBcInJlbW92ZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMixcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAyXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZUNhY2hlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicmVtb3ZlQ29va2llc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZURvd25sb2Fkc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZUZvcm1EYXRhXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicmVtb3ZlSGlzdG9yeVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZUxvY2FsU3RvcmFnZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZVBhc3N3b3Jkc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZVBsdWdpbkRhdGFcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZXR0aW5nc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcImNvbW1hbmRzXCI6IHtcbiAgICAgICAgICBcImdldEFsbFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcImNvbnRleHRNZW51c1wiOiB7XG4gICAgICAgICAgXCJyZW1vdmVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZW1vdmVBbGxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJ1cGRhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDIsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJjb29raWVzXCI6IHtcbiAgICAgICAgICBcImdldFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldEFsbFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldEFsbENvb2tpZVN0b3Jlc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNldFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcImRldnRvb2xzXCI6IHtcbiAgICAgICAgICBcImluc3BlY3RlZFdpbmRvd1wiOiB7XG4gICAgICAgICAgICBcImV2YWxcIjoge1xuICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDIsXG4gICAgICAgICAgICAgIFwic2luZ2xlQ2FsbGJhY2tBcmdcIjogZmFsc2VcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicGFuZWxzXCI6IHtcbiAgICAgICAgICAgIFwiY3JlYXRlXCI6IHtcbiAgICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDMsXG4gICAgICAgICAgICAgIFwibWF4QXJnc1wiOiAzLFxuICAgICAgICAgICAgICBcInNpbmdsZUNhbGxiYWNrQXJnXCI6IHRydWVcbiAgICAgICAgICAgIH0sXG4gICAgICAgICAgICBcImVsZW1lbnRzXCI6IHtcbiAgICAgICAgICAgICAgXCJjcmVhdGVTaWRlYmFyUGFuZVwiOiB7XG4gICAgICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJkb3dubG9hZHNcIjoge1xuICAgICAgICAgIFwiY2FuY2VsXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZG93bmxvYWRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJlcmFzZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldEZpbGVJY29uXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDJcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwib3BlblwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJmYWxsYmFja1RvTm9DYWxsYmFja1wiOiB0cnVlXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInBhdXNlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicmVtb3ZlRmlsZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlc3VtZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNlYXJjaFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNob3dcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwiZmFsbGJhY2tUb05vQ2FsbGJhY2tcIjogdHJ1ZVxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJleHRlbnNpb25cIjoge1xuICAgICAgICAgIFwiaXNBbGxvd2VkRmlsZVNjaGVtZUFjY2Vzc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImlzQWxsb3dlZEluY29nbml0b0FjY2Vzc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcImhpc3RvcnlcIjoge1xuICAgICAgICAgIFwiYWRkVXJsXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZGVsZXRlQWxsXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZGVsZXRlUmFuZ2VcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJkZWxldGVVcmxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRWaXNpdHNcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZWFyY2hcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJpMThuXCI6IHtcbiAgICAgICAgICBcImRldGVjdExhbmd1YWdlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0QWNjZXB0TGFuZ3VhZ2VzXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwiaWRlbnRpdHlcIjoge1xuICAgICAgICAgIFwibGF1bmNoV2ViQXV0aEZsb3dcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJpZGxlXCI6IHtcbiAgICAgICAgICBcInF1ZXJ5U3RhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJtYW5hZ2VtZW50XCI6IHtcbiAgICAgICAgICBcImdldFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldEFsbFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFNlbGZcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZXRFbmFibGVkXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAyLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDJcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwidW5pbnN0YWxsU2VsZlwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcIm5vdGlmaWNhdGlvbnNcIjoge1xuICAgICAgICAgIFwiY2xlYXJcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJjcmVhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRBbGxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRQZXJtaXNzaW9uTGV2ZWxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJ1cGRhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDIsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJwYWdlQWN0aW9uXCI6IHtcbiAgICAgICAgICBcImdldFBvcHVwXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0VGl0bGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJoaWRlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDEsXG4gICAgICAgICAgICBcImZhbGxiYWNrVG9Ob0NhbGxiYWNrXCI6IHRydWVcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2V0SWNvblwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNldFBvcHVwXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDEsXG4gICAgICAgICAgICBcImZhbGxiYWNrVG9Ob0NhbGxiYWNrXCI6IHRydWVcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2V0VGl0bGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwiZmFsbGJhY2tUb05vQ2FsbGJhY2tcIjogdHJ1ZVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzaG93XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDEsXG4gICAgICAgICAgICBcImZhbGxiYWNrVG9Ob0NhbGxiYWNrXCI6IHRydWVcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwicGVybWlzc2lvbnNcIjoge1xuICAgICAgICAgIFwiY29udGFpbnNcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRBbGxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZW1vdmVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZXF1ZXN0XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwicnVudGltZVwiOiB7XG4gICAgICAgICAgXCJnZXRCYWNrZ3JvdW5kUGFnZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFBsYXRmb3JtSW5mb1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcIm9wZW5PcHRpb25zUGFnZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlcXVlc3RVcGRhdGVDaGVja1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNlbmRNZXNzYWdlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDNcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2VuZE5hdGl2ZU1lc3NhZ2VcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDIsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZXRVbmluc3RhbGxVUkxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJzZXNzaW9uc1wiOiB7XG4gICAgICAgICAgXCJnZXREZXZpY2VzXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0UmVjZW50bHlDbG9zZWRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZXN0b3JlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwic3RvcmFnZVwiOiB7XG4gICAgICAgICAgXCJsb2NhbFwiOiB7XG4gICAgICAgICAgICBcImNsZWFyXCI6IHtcbiAgICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgICB9LFxuICAgICAgICAgICAgXCJnZXRcIjoge1xuICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICAgIH0sXG4gICAgICAgICAgICBcImdldEJ5dGVzSW5Vc2VcIjoge1xuICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICAgIH0sXG4gICAgICAgICAgICBcInJlbW92ZVwiOiB7XG4gICAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgICAgfSxcbiAgICAgICAgICAgIFwic2V0XCI6IHtcbiAgICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgICB9XG4gICAgICAgICAgfSxcbiAgICAgICAgICBcIm1hbmFnZWRcIjoge1xuICAgICAgICAgICAgXCJnZXRcIjoge1xuICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICAgIH0sXG4gICAgICAgICAgICBcImdldEJ5dGVzSW5Vc2VcIjoge1xuICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic3luY1wiOiB7XG4gICAgICAgICAgICBcImNsZWFyXCI6IHtcbiAgICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgICB9LFxuICAgICAgICAgICAgXCJnZXRcIjoge1xuICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICAgIH0sXG4gICAgICAgICAgICBcImdldEJ5dGVzSW5Vc2VcIjoge1xuICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICAgIH0sXG4gICAgICAgICAgICBcInJlbW92ZVwiOiB7XG4gICAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgICAgfSxcbiAgICAgICAgICAgIFwic2V0XCI6IHtcbiAgICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgICB9XG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcInRhYnNcIjoge1xuICAgICAgICAgIFwiY2FwdHVyZVZpc2libGVUYWJcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJjcmVhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJkZXRlY3RMYW5ndWFnZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImRpc2NhcmRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJkdXBsaWNhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJleGVjdXRlU2NyaXB0XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDJcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0Q3VycmVudFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFpvb21cIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRab29tU2V0dGluZ3NcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnb0JhY2tcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnb0ZvcndhcmRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJoaWdobGlnaHRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJpbnNlcnRDU1NcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJtb3ZlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAyLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDJcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicXVlcnlcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZWxvYWRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZW1vdmVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZW1vdmVDU1NcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZW5kTWVzc2FnZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMixcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAzXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNldFpvb21cIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZXRab29tU2V0dGluZ3NcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJ1cGRhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJ0b3BTaXRlc1wiOiB7XG4gICAgICAgICAgXCJnZXRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJ3ZWJOYXZpZ2F0aW9uXCI6IHtcbiAgICAgICAgICBcImdldEFsbEZyYW1lc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldEZyYW1lXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwid2ViUmVxdWVzdFwiOiB7XG4gICAgICAgICAgXCJoYW5kbGVyQmVoYXZpb3JDaGFuZ2VkXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwid2luZG93c1wiOiB7XG4gICAgICAgICAgXCJjcmVhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRBbGxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRDdXJyZW50XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0TGFzdEZvY3VzZWRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZW1vdmVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJ1cGRhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDIsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgfTtcblxuICAgICAgaWYgKE9iamVjdC5rZXlzKGFwaU1ldGFkYXRhKS5sZW5ndGggPT09IDApIHtcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiYXBpLW1ldGFkYXRhLmpzb24gaGFzIG5vdCBiZWVuIGluY2x1ZGVkIGluIGJyb3dzZXItcG9seWZpbGxcIik7XG4gICAgICB9XG4gICAgICAvKipcbiAgICAgICAqIEEgV2Vha01hcCBzdWJjbGFzcyB3aGljaCBjcmVhdGVzIGFuZCBzdG9yZXMgYSB2YWx1ZSBmb3IgYW55IGtleSB3aGljaCBkb2VzXG4gICAgICAgKiBub3QgZXhpc3Qgd2hlbiBhY2Nlc3NlZCwgYnV0IGJlaGF2ZXMgZXhhY3RseSBhcyBhbiBvcmRpbmFyeSBXZWFrTWFwXG4gICAgICAgKiBvdGhlcndpc2UuXG4gICAgICAgKlxuICAgICAgICogQHBhcmFtIHtmdW5jdGlvbn0gY3JlYXRlSXRlbVxuICAgICAgICogICAgICAgIEEgZnVuY3Rpb24gd2hpY2ggd2lsbCBiZSBjYWxsZWQgaW4gb3JkZXIgdG8gY3JlYXRlIHRoZSB2YWx1ZSBmb3IgYW55XG4gICAgICAgKiAgICAgICAga2V5IHdoaWNoIGRvZXMgbm90IGV4aXN0LCB0aGUgZmlyc3QgdGltZSBpdCBpcyBhY2Nlc3NlZC4gVGhlXG4gICAgICAgKiAgICAgICAgZnVuY3Rpb24gcmVjZWl2ZXMsIGFzIGl0cyBvbmx5IGFyZ3VtZW50LCB0aGUga2V5IGJlaW5nIGNyZWF0ZWQuXG4gICAgICAgKi9cblxuXG4gICAgICBjbGFzcyBEZWZhdWx0V2Vha01hcCBleHRlbmRzIFdlYWtNYXAge1xuICAgICAgICBjb25zdHJ1Y3RvcihjcmVhdGVJdGVtLCBpdGVtcyA9IHVuZGVmaW5lZCkge1xuICAgICAgICAgIHN1cGVyKGl0ZW1zKTtcbiAgICAgICAgICB0aGlzLmNyZWF0ZUl0ZW0gPSBjcmVhdGVJdGVtO1xuICAgICAgICB9XG5cbiAgICAgICAgZ2V0KGtleSkge1xuICAgICAgICAgIGlmICghdGhpcy5oYXMoa2V5KSkge1xuICAgICAgICAgICAgdGhpcy5zZXQoa2V5LCB0aGlzLmNyZWF0ZUl0ZW0oa2V5KSk7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgcmV0dXJuIHN1cGVyLmdldChrZXkpO1xuICAgICAgICB9XG5cbiAgICAgIH1cbiAgICAgIC8qKlxuICAgICAgICogUmV0dXJucyB0cnVlIGlmIHRoZSBnaXZlbiBvYmplY3QgaXMgYW4gb2JqZWN0IHdpdGggYSBgdGhlbmAgbWV0aG9kLCBhbmQgY2FuXG4gICAgICAgKiB0aGVyZWZvcmUgYmUgYXNzdW1lZCB0byBiZWhhdmUgYXMgYSBQcm9taXNlLlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSB7Kn0gdmFsdWUgVGhlIHZhbHVlIHRvIHRlc3QuXG4gICAgICAgKiBAcmV0dXJucyB7Ym9vbGVhbn0gVHJ1ZSBpZiB0aGUgdmFsdWUgaXMgdGhlbmFibGUuXG4gICAgICAgKi9cblxuXG4gICAgICBjb25zdCBpc1RoZW5hYmxlID0gdmFsdWUgPT4ge1xuICAgICAgICByZXR1cm4gdmFsdWUgJiYgdHlwZW9mIHZhbHVlID09PSBcIm9iamVjdFwiICYmIHR5cGVvZiB2YWx1ZS50aGVuID09PSBcImZ1bmN0aW9uXCI7XG4gICAgICB9O1xuICAgICAgLyoqXG4gICAgICAgKiBDcmVhdGVzIGFuZCByZXR1cm5zIGEgZnVuY3Rpb24gd2hpY2gsIHdoZW4gY2FsbGVkLCB3aWxsIHJlc29sdmUgb3IgcmVqZWN0XG4gICAgICAgKiB0aGUgZ2l2ZW4gcHJvbWlzZSBiYXNlZCBvbiBob3cgaXQgaXMgY2FsbGVkOlxuICAgICAgICpcbiAgICAgICAqIC0gSWYsIHdoZW4gY2FsbGVkLCBgY2hyb21lLnJ1bnRpbWUubGFzdEVycm9yYCBjb250YWlucyBhIG5vbi1udWxsIG9iamVjdCxcbiAgICAgICAqICAgdGhlIHByb21pc2UgaXMgcmVqZWN0ZWQgd2l0aCB0aGF0IHZhbHVlLlxuICAgICAgICogLSBJZiB0aGUgZnVuY3Rpb24gaXMgY2FsbGVkIHdpdGggZXhhY3RseSBvbmUgYXJndW1lbnQsIHRoZSBwcm9taXNlIGlzXG4gICAgICAgKiAgIHJlc29sdmVkIHRvIHRoYXQgdmFsdWUuXG4gICAgICAgKiAtIE90aGVyd2lzZSwgdGhlIHByb21pc2UgaXMgcmVzb2x2ZWQgdG8gYW4gYXJyYXkgY29udGFpbmluZyBhbGwgb2YgdGhlXG4gICAgICAgKiAgIGZ1bmN0aW9uJ3MgYXJndW1lbnRzLlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSB7b2JqZWN0fSBwcm9taXNlXG4gICAgICAgKiAgICAgICAgQW4gb2JqZWN0IGNvbnRhaW5pbmcgdGhlIHJlc29sdXRpb24gYW5kIHJlamVjdGlvbiBmdW5jdGlvbnMgb2YgYVxuICAgICAgICogICAgICAgIHByb21pc2UuXG4gICAgICAgKiBAcGFyYW0ge2Z1bmN0aW9ufSBwcm9taXNlLnJlc29sdmVcbiAgICAgICAqICAgICAgICBUaGUgcHJvbWlzZSdzIHJlc29sdXRpb24gZnVuY3Rpb24uXG4gICAgICAgKiBAcGFyYW0ge2Z1bmN0aW9ufSBwcm9taXNlLnJlamVjdGlvblxuICAgICAgICogICAgICAgIFRoZSBwcm9taXNlJ3MgcmVqZWN0aW9uIGZ1bmN0aW9uLlxuICAgICAgICogQHBhcmFtIHtvYmplY3R9IG1ldGFkYXRhXG4gICAgICAgKiAgICAgICAgTWV0YWRhdGEgYWJvdXQgdGhlIHdyYXBwZWQgbWV0aG9kIHdoaWNoIGhhcyBjcmVhdGVkIHRoZSBjYWxsYmFjay5cbiAgICAgICAqIEBwYXJhbSB7aW50ZWdlcn0gbWV0YWRhdGEubWF4UmVzb2x2ZWRBcmdzXG4gICAgICAgKiAgICAgICAgVGhlIG1heGltdW0gbnVtYmVyIG9mIGFyZ3VtZW50cyB3aGljaCBtYXkgYmUgcGFzc2VkIHRvIHRoZVxuICAgICAgICogICAgICAgIGNhbGxiYWNrIGNyZWF0ZWQgYnkgdGhlIHdyYXBwZWQgYXN5bmMgZnVuY3Rpb24uXG4gICAgICAgKlxuICAgICAgICogQHJldHVybnMge2Z1bmN0aW9ufVxuICAgICAgICogICAgICAgIFRoZSBnZW5lcmF0ZWQgY2FsbGJhY2sgZnVuY3Rpb24uXG4gICAgICAgKi9cblxuXG4gICAgICBjb25zdCBtYWtlQ2FsbGJhY2sgPSAocHJvbWlzZSwgbWV0YWRhdGEpID0+IHtcbiAgICAgICAgcmV0dXJuICguLi5jYWxsYmFja0FyZ3MpID0+IHtcbiAgICAgICAgICBpZiAoZXh0ZW5zaW9uQVBJcy5ydW50aW1lLmxhc3RFcnJvcikge1xuICAgICAgICAgICAgcHJvbWlzZS5yZWplY3QoZXh0ZW5zaW9uQVBJcy5ydW50aW1lLmxhc3RFcnJvcik7XG4gICAgICAgICAgfSBlbHNlIGlmIChtZXRhZGF0YS5zaW5nbGVDYWxsYmFja0FyZyB8fCBjYWxsYmFja0FyZ3MubGVuZ3RoIDw9IDEgJiYgbWV0YWRhdGEuc2luZ2xlQ2FsbGJhY2tBcmcgIT09IGZhbHNlKSB7XG4gICAgICAgICAgICBwcm9taXNlLnJlc29sdmUoY2FsbGJhY2tBcmdzWzBdKTtcbiAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgcHJvbWlzZS5yZXNvbHZlKGNhbGxiYWNrQXJncyk7XG4gICAgICAgICAgfVxuICAgICAgICB9O1xuICAgICAgfTtcblxuICAgICAgY29uc3QgcGx1cmFsaXplQXJndW1lbnRzID0gbnVtQXJncyA9PiBudW1BcmdzID09IDEgPyBcImFyZ3VtZW50XCIgOiBcImFyZ3VtZW50c1wiO1xuICAgICAgLyoqXG4gICAgICAgKiBDcmVhdGVzIGEgd3JhcHBlciBmdW5jdGlvbiBmb3IgYSBtZXRob2Qgd2l0aCB0aGUgZ2l2ZW4gbmFtZSBhbmQgbWV0YWRhdGEuXG4gICAgICAgKlxuICAgICAgICogQHBhcmFtIHtzdHJpbmd9IG5hbWVcbiAgICAgICAqICAgICAgICBUaGUgbmFtZSBvZiB0aGUgbWV0aG9kIHdoaWNoIGlzIGJlaW5nIHdyYXBwZWQuXG4gICAgICAgKiBAcGFyYW0ge29iamVjdH0gbWV0YWRhdGFcbiAgICAgICAqICAgICAgICBNZXRhZGF0YSBhYm91dCB0aGUgbWV0aG9kIGJlaW5nIHdyYXBwZWQuXG4gICAgICAgKiBAcGFyYW0ge2ludGVnZXJ9IG1ldGFkYXRhLm1pbkFyZ3NcbiAgICAgICAqICAgICAgICBUaGUgbWluaW11bSBudW1iZXIgb2YgYXJndW1lbnRzIHdoaWNoIG11c3QgYmUgcGFzc2VkIHRvIHRoZVxuICAgICAgICogICAgICAgIGZ1bmN0aW9uLiBJZiBjYWxsZWQgd2l0aCBmZXdlciB0aGFuIHRoaXMgbnVtYmVyIG9mIGFyZ3VtZW50cywgdGhlXG4gICAgICAgKiAgICAgICAgd3JhcHBlciB3aWxsIHJhaXNlIGFuIGV4Y2VwdGlvbi5cbiAgICAgICAqIEBwYXJhbSB7aW50ZWdlcn0gbWV0YWRhdGEubWF4QXJnc1xuICAgICAgICogICAgICAgIFRoZSBtYXhpbXVtIG51bWJlciBvZiBhcmd1bWVudHMgd2hpY2ggbWF5IGJlIHBhc3NlZCB0byB0aGVcbiAgICAgICAqICAgICAgICBmdW5jdGlvbi4gSWYgY2FsbGVkIHdpdGggbW9yZSB0aGFuIHRoaXMgbnVtYmVyIG9mIGFyZ3VtZW50cywgdGhlXG4gICAgICAgKiAgICAgICAgd3JhcHBlciB3aWxsIHJhaXNlIGFuIGV4Y2VwdGlvbi5cbiAgICAgICAqIEBwYXJhbSB7aW50ZWdlcn0gbWV0YWRhdGEubWF4UmVzb2x2ZWRBcmdzXG4gICAgICAgKiAgICAgICAgVGhlIG1heGltdW0gbnVtYmVyIG9mIGFyZ3VtZW50cyB3aGljaCBtYXkgYmUgcGFzc2VkIHRvIHRoZVxuICAgICAgICogICAgICAgIGNhbGxiYWNrIGNyZWF0ZWQgYnkgdGhlIHdyYXBwZWQgYXN5bmMgZnVuY3Rpb24uXG4gICAgICAgKlxuICAgICAgICogQHJldHVybnMge2Z1bmN0aW9uKG9iamVjdCwgLi4uKil9XG4gICAgICAgKiAgICAgICBUaGUgZ2VuZXJhdGVkIHdyYXBwZXIgZnVuY3Rpb24uXG4gICAgICAgKi9cblxuXG4gICAgICBjb25zdCB3cmFwQXN5bmNGdW5jdGlvbiA9IChuYW1lLCBtZXRhZGF0YSkgPT4ge1xuICAgICAgICByZXR1cm4gZnVuY3Rpb24gYXN5bmNGdW5jdGlvbldyYXBwZXIodGFyZ2V0LCAuLi5hcmdzKSB7XG4gICAgICAgICAgaWYgKGFyZ3MubGVuZ3RoIDwgbWV0YWRhdGEubWluQXJncykge1xuICAgICAgICAgICAgdGhyb3cgbmV3IEVycm9yKGBFeHBlY3RlZCBhdCBsZWFzdCAke21ldGFkYXRhLm1pbkFyZ3N9ICR7cGx1cmFsaXplQXJndW1lbnRzKG1ldGFkYXRhLm1pbkFyZ3MpfSBmb3IgJHtuYW1lfSgpLCBnb3QgJHthcmdzLmxlbmd0aH1gKTtcbiAgICAgICAgICB9XG5cbiAgICAgICAgICBpZiAoYXJncy5sZW5ndGggPiBtZXRhZGF0YS5tYXhBcmdzKSB7XG4gICAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoYEV4cGVjdGVkIGF0IG1vc3QgJHttZXRhZGF0YS5tYXhBcmdzfSAke3BsdXJhbGl6ZUFyZ3VtZW50cyhtZXRhZGF0YS5tYXhBcmdzKX0gZm9yICR7bmFtZX0oKSwgZ290ICR7YXJncy5sZW5ndGh9YCk7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgcmV0dXJuIG5ldyBQcm9taXNlKChyZXNvbHZlLCByZWplY3QpID0+IHtcbiAgICAgICAgICAgIGlmIChtZXRhZGF0YS5mYWxsYmFja1RvTm9DYWxsYmFjaykge1xuICAgICAgICAgICAgICAvLyBUaGlzIEFQSSBtZXRob2QgaGFzIGN1cnJlbnRseSBubyBjYWxsYmFjayBvbiBDaHJvbWUsIGJ1dCBpdCByZXR1cm4gYSBwcm9taXNlIG9uIEZpcmVmb3gsXG4gICAgICAgICAgICAgIC8vIGFuZCBzbyB0aGUgcG9seWZpbGwgd2lsbCB0cnkgdG8gY2FsbCBpdCB3aXRoIGEgY2FsbGJhY2sgZmlyc3QsIGFuZCBpdCB3aWxsIGZhbGxiYWNrXG4gICAgICAgICAgICAgIC8vIHRvIG5vdCBwYXNzaW5nIHRoZSBjYWxsYmFjayBpZiB0aGUgZmlyc3QgY2FsbCBmYWlscy5cbiAgICAgICAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgICAgICB0YXJnZXRbbmFtZV0oLi4uYXJncywgbWFrZUNhbGxiYWNrKHtcbiAgICAgICAgICAgICAgICAgIHJlc29sdmUsXG4gICAgICAgICAgICAgICAgICByZWplY3RcbiAgICAgICAgICAgICAgICB9LCBtZXRhZGF0YSkpO1xuICAgICAgICAgICAgICB9IGNhdGNoIChjYkVycm9yKSB7XG4gICAgICAgICAgICAgICAgY29uc29sZS53YXJuKGAke25hbWV9IEFQSSBtZXRob2QgZG9lc24ndCBzZWVtIHRvIHN1cHBvcnQgdGhlIGNhbGxiYWNrIHBhcmFtZXRlciwgYCArIFwiZmFsbGluZyBiYWNrIHRvIGNhbGwgaXQgd2l0aG91dCBhIGNhbGxiYWNrOiBcIiwgY2JFcnJvcik7XG4gICAgICAgICAgICAgICAgdGFyZ2V0W25hbWVdKC4uLmFyZ3MpOyAvLyBVcGRhdGUgdGhlIEFQSSBtZXRob2QgbWV0YWRhdGEsIHNvIHRoYXQgdGhlIG5leHQgQVBJIGNhbGxzIHdpbGwgbm90IHRyeSB0b1xuICAgICAgICAgICAgICAgIC8vIHVzZSB0aGUgdW5zdXBwb3J0ZWQgY2FsbGJhY2sgYW55bW9yZS5cblxuICAgICAgICAgICAgICAgIG1ldGFkYXRhLmZhbGxiYWNrVG9Ob0NhbGxiYWNrID0gZmFsc2U7XG4gICAgICAgICAgICAgICAgbWV0YWRhdGEubm9DYWxsYmFjayA9IHRydWU7XG4gICAgICAgICAgICAgICAgcmVzb2x2ZSgpO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9IGVsc2UgaWYgKG1ldGFkYXRhLm5vQ2FsbGJhY2spIHtcbiAgICAgICAgICAgICAgdGFyZ2V0W25hbWVdKC4uLmFyZ3MpO1xuICAgICAgICAgICAgICByZXNvbHZlKCk7XG4gICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICB0YXJnZXRbbmFtZV0oLi4uYXJncywgbWFrZUNhbGxiYWNrKHtcbiAgICAgICAgICAgICAgICByZXNvbHZlLFxuICAgICAgICAgICAgICAgIHJlamVjdFxuICAgICAgICAgICAgICB9LCBtZXRhZGF0YSkpO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH0pO1xuICAgICAgICB9O1xuICAgICAgfTtcbiAgICAgIC8qKlxuICAgICAgICogV3JhcHMgYW4gZXhpc3RpbmcgbWV0aG9kIG9mIHRoZSB0YXJnZXQgb2JqZWN0LCBzbyB0aGF0IGNhbGxzIHRvIGl0IGFyZVxuICAgICAgICogaW50ZXJjZXB0ZWQgYnkgdGhlIGdpdmVuIHdyYXBwZXIgZnVuY3Rpb24uIFRoZSB3cmFwcGVyIGZ1bmN0aW9uIHJlY2VpdmVzLFxuICAgICAgICogYXMgaXRzIGZpcnN0IGFyZ3VtZW50LCB0aGUgb3JpZ2luYWwgYHRhcmdldGAgb2JqZWN0LCBmb2xsb3dlZCBieSBlYWNoIG9mXG4gICAgICAgKiB0aGUgYXJndW1lbnRzIHBhc3NlZCB0byB0aGUgb3JpZ2luYWwgbWV0aG9kLlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSB7b2JqZWN0fSB0YXJnZXRcbiAgICAgICAqICAgICAgICBUaGUgb3JpZ2luYWwgdGFyZ2V0IG9iamVjdCB0aGF0IHRoZSB3cmFwcGVkIG1ldGhvZCBiZWxvbmdzIHRvLlxuICAgICAgICogQHBhcmFtIHtmdW5jdGlvbn0gbWV0aG9kXG4gICAgICAgKiAgICAgICAgVGhlIG1ldGhvZCBiZWluZyB3cmFwcGVkLiBUaGlzIGlzIHVzZWQgYXMgdGhlIHRhcmdldCBvZiB0aGUgUHJveHlcbiAgICAgICAqICAgICAgICBvYmplY3Qgd2hpY2ggaXMgY3JlYXRlZCB0byB3cmFwIHRoZSBtZXRob2QuXG4gICAgICAgKiBAcGFyYW0ge2Z1bmN0aW9ufSB3cmFwcGVyXG4gICAgICAgKiAgICAgICAgVGhlIHdyYXBwZXIgZnVuY3Rpb24gd2hpY2ggaXMgY2FsbGVkIGluIHBsYWNlIG9mIGEgZGlyZWN0IGludm9jYXRpb25cbiAgICAgICAqICAgICAgICBvZiB0aGUgd3JhcHBlZCBtZXRob2QuXG4gICAgICAgKlxuICAgICAgICogQHJldHVybnMge1Byb3h5PGZ1bmN0aW9uPn1cbiAgICAgICAqICAgICAgICBBIFByb3h5IG9iamVjdCBmb3IgdGhlIGdpdmVuIG1ldGhvZCwgd2hpY2ggaW52b2tlcyB0aGUgZ2l2ZW4gd3JhcHBlclxuICAgICAgICogICAgICAgIG1ldGhvZCBpbiBpdHMgcGxhY2UuXG4gICAgICAgKi9cblxuXG4gICAgICBjb25zdCB3cmFwTWV0aG9kID0gKHRhcmdldCwgbWV0aG9kLCB3cmFwcGVyKSA9PiB7XG4gICAgICAgIHJldHVybiBuZXcgUHJveHkobWV0aG9kLCB7XG4gICAgICAgICAgYXBwbHkodGFyZ2V0TWV0aG9kLCB0aGlzT2JqLCBhcmdzKSB7XG4gICAgICAgICAgICByZXR1cm4gd3JhcHBlci5jYWxsKHRoaXNPYmosIHRhcmdldCwgLi4uYXJncyk7XG4gICAgICAgICAgfVxuXG4gICAgICAgIH0pO1xuICAgICAgfTtcblxuICAgICAgbGV0IGhhc093blByb3BlcnR5ID0gRnVuY3Rpb24uY2FsbC5iaW5kKE9iamVjdC5wcm90b3R5cGUuaGFzT3duUHJvcGVydHkpO1xuICAgICAgLyoqXG4gICAgICAgKiBXcmFwcyBhbiBvYmplY3QgaW4gYSBQcm94eSB3aGljaCBpbnRlcmNlcHRzIGFuZCB3cmFwcyBjZXJ0YWluIG1ldGhvZHNcbiAgICAgICAqIGJhc2VkIG9uIHRoZSBnaXZlbiBgd3JhcHBlcnNgIGFuZCBgbWV0YWRhdGFgIG9iamVjdHMuXG4gICAgICAgKlxuICAgICAgICogQHBhcmFtIHtvYmplY3R9IHRhcmdldFxuICAgICAgICogICAgICAgIFRoZSB0YXJnZXQgb2JqZWN0IHRvIHdyYXAuXG4gICAgICAgKlxuICAgICAgICogQHBhcmFtIHtvYmplY3R9IFt3cmFwcGVycyA9IHt9XVxuICAgICAgICogICAgICAgIEFuIG9iamVjdCB0cmVlIGNvbnRhaW5pbmcgd3JhcHBlciBmdW5jdGlvbnMgZm9yIHNwZWNpYWwgY2FzZXMuIEFueVxuICAgICAgICogICAgICAgIGZ1bmN0aW9uIHByZXNlbnQgaW4gdGhpcyBvYmplY3QgdHJlZSBpcyBjYWxsZWQgaW4gcGxhY2Ugb2YgdGhlXG4gICAgICAgKiAgICAgICAgbWV0aG9kIGluIHRoZSBzYW1lIGxvY2F0aW9uIGluIHRoZSBgdGFyZ2V0YCBvYmplY3QgdHJlZS4gVGhlc2VcbiAgICAgICAqICAgICAgICB3cmFwcGVyIG1ldGhvZHMgYXJlIGludm9rZWQgYXMgZGVzY3JpYmVkIGluIHtAc2VlIHdyYXBNZXRob2R9LlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSB7b2JqZWN0fSBbbWV0YWRhdGEgPSB7fV1cbiAgICAgICAqICAgICAgICBBbiBvYmplY3QgdHJlZSBjb250YWluaW5nIG1ldGFkYXRhIHVzZWQgdG8gYXV0b21hdGljYWxseSBnZW5lcmF0ZVxuICAgICAgICogICAgICAgIFByb21pc2UtYmFzZWQgd3JhcHBlciBmdW5jdGlvbnMgZm9yIGFzeW5jaHJvbm91cy4gQW55IGZ1bmN0aW9uIGluXG4gICAgICAgKiAgICAgICAgdGhlIGB0YXJnZXRgIG9iamVjdCB0cmVlIHdoaWNoIGhhcyBhIGNvcnJlc3BvbmRpbmcgbWV0YWRhdGEgb2JqZWN0XG4gICAgICAgKiAgICAgICAgaW4gdGhlIHNhbWUgbG9jYXRpb24gaW4gdGhlIGBtZXRhZGF0YWAgdHJlZSBpcyByZXBsYWNlZCB3aXRoIGFuXG4gICAgICAgKiAgICAgICAgYXV0b21hdGljYWxseS1nZW5lcmF0ZWQgd3JhcHBlciBmdW5jdGlvbiwgYXMgZGVzY3JpYmVkIGluXG4gICAgICAgKiAgICAgICAge0BzZWUgd3JhcEFzeW5jRnVuY3Rpb259XG4gICAgICAgKlxuICAgICAgICogQHJldHVybnMge1Byb3h5PG9iamVjdD59XG4gICAgICAgKi9cblxuICAgICAgY29uc3Qgd3JhcE9iamVjdCA9ICh0YXJnZXQsIHdyYXBwZXJzID0ge30sIG1ldGFkYXRhID0ge30pID0+IHtcbiAgICAgICAgbGV0IGNhY2hlID0gT2JqZWN0LmNyZWF0ZShudWxsKTtcbiAgICAgICAgbGV0IGhhbmRsZXJzID0ge1xuICAgICAgICAgIGhhcyhwcm94eVRhcmdldCwgcHJvcCkge1xuICAgICAgICAgICAgcmV0dXJuIHByb3AgaW4gdGFyZ2V0IHx8IHByb3AgaW4gY2FjaGU7XG4gICAgICAgICAgfSxcblxuICAgICAgICAgIGdldChwcm94eVRhcmdldCwgcHJvcCwgcmVjZWl2ZXIpIHtcbiAgICAgICAgICAgIGlmIChwcm9wIGluIGNhY2hlKSB7XG4gICAgICAgICAgICAgIHJldHVybiBjYWNoZVtwcm9wXTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgaWYgKCEocHJvcCBpbiB0YXJnZXQpKSB7XG4gICAgICAgICAgICAgIHJldHVybiB1bmRlZmluZWQ7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIGxldCB2YWx1ZSA9IHRhcmdldFtwcm9wXTtcblxuICAgICAgICAgICAgaWYgKHR5cGVvZiB2YWx1ZSA9PT0gXCJmdW5jdGlvblwiKSB7XG4gICAgICAgICAgICAgIC8vIFRoaXMgaXMgYSBtZXRob2Qgb24gdGhlIHVuZGVybHlpbmcgb2JqZWN0LiBDaGVjayBpZiB3ZSBuZWVkIHRvIGRvXG4gICAgICAgICAgICAgIC8vIGFueSB3cmFwcGluZy5cbiAgICAgICAgICAgICAgaWYgKHR5cGVvZiB3cmFwcGVyc1twcm9wXSA9PT0gXCJmdW5jdGlvblwiKSB7XG4gICAgICAgICAgICAgICAgLy8gV2UgaGF2ZSBhIHNwZWNpYWwtY2FzZSB3cmFwcGVyIGZvciB0aGlzIG1ldGhvZC5cbiAgICAgICAgICAgICAgICB2YWx1ZSA9IHdyYXBNZXRob2QodGFyZ2V0LCB0YXJnZXRbcHJvcF0sIHdyYXBwZXJzW3Byb3BdKTtcbiAgICAgICAgICAgICAgfSBlbHNlIGlmIChoYXNPd25Qcm9wZXJ0eShtZXRhZGF0YSwgcHJvcCkpIHtcbiAgICAgICAgICAgICAgICAvLyBUaGlzIGlzIGFuIGFzeW5jIG1ldGhvZCB0aGF0IHdlIGhhdmUgbWV0YWRhdGEgZm9yLiBDcmVhdGUgYVxuICAgICAgICAgICAgICAgIC8vIFByb21pc2Ugd3JhcHBlciBmb3IgaXQuXG4gICAgICAgICAgICAgICAgbGV0IHdyYXBwZXIgPSB3cmFwQXN5bmNGdW5jdGlvbihwcm9wLCBtZXRhZGF0YVtwcm9wXSk7XG4gICAgICAgICAgICAgICAgdmFsdWUgPSB3cmFwTWV0aG9kKHRhcmdldCwgdGFyZ2V0W3Byb3BdLCB3cmFwcGVyKTtcbiAgICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgICAvLyBUaGlzIGlzIGEgbWV0aG9kIHRoYXQgd2UgZG9uJ3Qga25vdyBvciBjYXJlIGFib3V0LiBSZXR1cm4gdGhlXG4gICAgICAgICAgICAgICAgLy8gb3JpZ2luYWwgbWV0aG9kLCBib3VuZCB0byB0aGUgdW5kZXJseWluZyBvYmplY3QuXG4gICAgICAgICAgICAgICAgdmFsdWUgPSB2YWx1ZS5iaW5kKHRhcmdldCk7XG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH0gZWxzZSBpZiAodHlwZW9mIHZhbHVlID09PSBcIm9iamVjdFwiICYmIHZhbHVlICE9PSBudWxsICYmIChoYXNPd25Qcm9wZXJ0eSh3cmFwcGVycywgcHJvcCkgfHwgaGFzT3duUHJvcGVydHkobWV0YWRhdGEsIHByb3ApKSkge1xuICAgICAgICAgICAgICAvLyBUaGlzIGlzIGFuIG9iamVjdCB0aGF0IHdlIG5lZWQgdG8gZG8gc29tZSB3cmFwcGluZyBmb3IgdGhlIGNoaWxkcmVuXG4gICAgICAgICAgICAgIC8vIG9mLiBDcmVhdGUgYSBzdWItb2JqZWN0IHdyYXBwZXIgZm9yIGl0IHdpdGggdGhlIGFwcHJvcHJpYXRlIGNoaWxkXG4gICAgICAgICAgICAgIC8vIG1ldGFkYXRhLlxuICAgICAgICAgICAgICB2YWx1ZSA9IHdyYXBPYmplY3QodmFsdWUsIHdyYXBwZXJzW3Byb3BdLCBtZXRhZGF0YVtwcm9wXSk7XG4gICAgICAgICAgICB9IGVsc2UgaWYgKGhhc093blByb3BlcnR5KG1ldGFkYXRhLCBcIipcIikpIHtcbiAgICAgICAgICAgICAgLy8gV3JhcCBhbGwgcHJvcGVydGllcyBpbiAqIG5hbWVzcGFjZS5cbiAgICAgICAgICAgICAgdmFsdWUgPSB3cmFwT2JqZWN0KHZhbHVlLCB3cmFwcGVyc1twcm9wXSwgbWV0YWRhdGFbXCIqXCJdKTtcbiAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgIC8vIFdlIGRvbid0IG5lZWQgdG8gZG8gYW55IHdyYXBwaW5nIGZvciB0aGlzIHByb3BlcnR5LFxuICAgICAgICAgICAgICAvLyBzbyBqdXN0IGZvcndhcmQgYWxsIGFjY2VzcyB0byB0aGUgdW5kZXJseWluZyBvYmplY3QuXG4gICAgICAgICAgICAgIE9iamVjdC5kZWZpbmVQcm9wZXJ0eShjYWNoZSwgcHJvcCwge1xuICAgICAgICAgICAgICAgIGNvbmZpZ3VyYWJsZTogdHJ1ZSxcbiAgICAgICAgICAgICAgICBlbnVtZXJhYmxlOiB0cnVlLFxuXG4gICAgICAgICAgICAgICAgZ2V0KCkge1xuICAgICAgICAgICAgICAgICAgcmV0dXJuIHRhcmdldFtwcm9wXTtcbiAgICAgICAgICAgICAgICB9LFxuXG4gICAgICAgICAgICAgICAgc2V0KHZhbHVlKSB7XG4gICAgICAgICAgICAgICAgICB0YXJnZXRbcHJvcF0gPSB2YWx1ZTtcbiAgICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgfSk7XG4gICAgICAgICAgICAgIHJldHVybiB2YWx1ZTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgY2FjaGVbcHJvcF0gPSB2YWx1ZTtcbiAgICAgICAgICAgIHJldHVybiB2YWx1ZTtcbiAgICAgICAgICB9LFxuXG4gICAgICAgICAgc2V0KHByb3h5VGFyZ2V0LCBwcm9wLCB2YWx1ZSwgcmVjZWl2ZXIpIHtcbiAgICAgICAgICAgIGlmIChwcm9wIGluIGNhY2hlKSB7XG4gICAgICAgICAgICAgIGNhY2hlW3Byb3BdID0gdmFsdWU7XG4gICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICB0YXJnZXRbcHJvcF0gPSB2YWx1ZTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgcmV0dXJuIHRydWU7XG4gICAgICAgICAgfSxcblxuICAgICAgICAgIGRlZmluZVByb3BlcnR5KHByb3h5VGFyZ2V0LCBwcm9wLCBkZXNjKSB7XG4gICAgICAgICAgICByZXR1cm4gUmVmbGVjdC5kZWZpbmVQcm9wZXJ0eShjYWNoZSwgcHJvcCwgZGVzYyk7XG4gICAgICAgICAgfSxcblxuICAgICAgICAgIGRlbGV0ZVByb3BlcnR5KHByb3h5VGFyZ2V0LCBwcm9wKSB7XG4gICAgICAgICAgICByZXR1cm4gUmVmbGVjdC5kZWxldGVQcm9wZXJ0eShjYWNoZSwgcHJvcCk7XG4gICAgICAgICAgfVxuXG4gICAgICAgIH07IC8vIFBlciBjb250cmFjdCBvZiB0aGUgUHJveHkgQVBJLCB0aGUgXCJnZXRcIiBwcm94eSBoYW5kbGVyIG11c3QgcmV0dXJuIHRoZVxuICAgICAgICAvLyBvcmlnaW5hbCB2YWx1ZSBvZiB0aGUgdGFyZ2V0IGlmIHRoYXQgdmFsdWUgaXMgZGVjbGFyZWQgcmVhZC1vbmx5IGFuZFxuICAgICAgICAvLyBub24tY29uZmlndXJhYmxlLiBGb3IgdGhpcyByZWFzb24sIHdlIGNyZWF0ZSBhbiBvYmplY3Qgd2l0aCB0aGVcbiAgICAgICAgLy8gcHJvdG90eXBlIHNldCB0byBgdGFyZ2V0YCBpbnN0ZWFkIG9mIHVzaW5nIGB0YXJnZXRgIGRpcmVjdGx5LlxuICAgICAgICAvLyBPdGhlcndpc2Ugd2UgY2Fubm90IHJldHVybiBhIGN1c3RvbSBvYmplY3QgZm9yIEFQSXMgdGhhdFxuICAgICAgICAvLyBhcmUgZGVjbGFyZWQgcmVhZC1vbmx5IGFuZCBub24tY29uZmlndXJhYmxlLCBzdWNoIGFzIGBjaHJvbWUuZGV2dG9vbHNgLlxuICAgICAgICAvL1xuICAgICAgICAvLyBUaGUgcHJveHkgaGFuZGxlcnMgdGhlbXNlbHZlcyB3aWxsIHN0aWxsIHVzZSB0aGUgb3JpZ2luYWwgYHRhcmdldGBcbiAgICAgICAgLy8gaW5zdGVhZCBvZiB0aGUgYHByb3h5VGFyZ2V0YCwgc28gdGhhdCB0aGUgbWV0aG9kcyBhbmQgcHJvcGVydGllcyBhcmVcbiAgICAgICAgLy8gZGVyZWZlcmVuY2VkIHZpYSB0aGUgb3JpZ2luYWwgdGFyZ2V0cy5cblxuICAgICAgICBsZXQgcHJveHlUYXJnZXQgPSBPYmplY3QuY3JlYXRlKHRhcmdldCk7XG4gICAgICAgIHJldHVybiBuZXcgUHJveHkocHJveHlUYXJnZXQsIGhhbmRsZXJzKTtcbiAgICAgIH07XG4gICAgICAvKipcbiAgICAgICAqIENyZWF0ZXMgYSBzZXQgb2Ygd3JhcHBlciBmdW5jdGlvbnMgZm9yIGFuIGV2ZW50IG9iamVjdCwgd2hpY2ggaGFuZGxlc1xuICAgICAgICogd3JhcHBpbmcgb2YgbGlzdGVuZXIgZnVuY3Rpb25zIHRoYXQgdGhvc2UgbWVzc2FnZXMgYXJlIHBhc3NlZC5cbiAgICAgICAqXG4gICAgICAgKiBBIHNpbmdsZSB3cmFwcGVyIGlzIGNyZWF0ZWQgZm9yIGVhY2ggbGlzdGVuZXIgZnVuY3Rpb24sIGFuZCBzdG9yZWQgaW4gYVxuICAgICAgICogbWFwLiBTdWJzZXF1ZW50IGNhbGxzIHRvIGBhZGRMaXN0ZW5lcmAsIGBoYXNMaXN0ZW5lcmAsIG9yIGByZW1vdmVMaXN0ZW5lcmBcbiAgICAgICAqIHJldHJpZXZlIHRoZSBvcmlnaW5hbCB3cmFwcGVyLCBzbyB0aGF0ICBhdHRlbXB0cyB0byByZW1vdmUgYVxuICAgICAgICogcHJldmlvdXNseS1hZGRlZCBsaXN0ZW5lciB3b3JrIGFzIGV4cGVjdGVkLlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSB7RGVmYXVsdFdlYWtNYXA8ZnVuY3Rpb24sIGZ1bmN0aW9uPn0gd3JhcHBlck1hcFxuICAgICAgICogICAgICAgIEEgRGVmYXVsdFdlYWtNYXAgb2JqZWN0IHdoaWNoIHdpbGwgY3JlYXRlIHRoZSBhcHByb3ByaWF0ZSB3cmFwcGVyXG4gICAgICAgKiAgICAgICAgZm9yIGEgZ2l2ZW4gbGlzdGVuZXIgZnVuY3Rpb24gd2hlbiBvbmUgZG9lcyBub3QgZXhpc3QsIGFuZCByZXRyaWV2ZVxuICAgICAgICogICAgICAgIGFuIGV4aXN0aW5nIG9uZSB3aGVuIGl0IGRvZXMuXG4gICAgICAgKlxuICAgICAgICogQHJldHVybnMge29iamVjdH1cbiAgICAgICAqL1xuXG5cbiAgICAgIGNvbnN0IHdyYXBFdmVudCA9IHdyYXBwZXJNYXAgPT4gKHtcbiAgICAgICAgYWRkTGlzdGVuZXIodGFyZ2V0LCBsaXN0ZW5lciwgLi4uYXJncykge1xuICAgICAgICAgIHRhcmdldC5hZGRMaXN0ZW5lcih3cmFwcGVyTWFwLmdldChsaXN0ZW5lciksIC4uLmFyZ3MpO1xuICAgICAgICB9LFxuXG4gICAgICAgIGhhc0xpc3RlbmVyKHRhcmdldCwgbGlzdGVuZXIpIHtcbiAgICAgICAgICByZXR1cm4gdGFyZ2V0Lmhhc0xpc3RlbmVyKHdyYXBwZXJNYXAuZ2V0KGxpc3RlbmVyKSk7XG4gICAgICAgIH0sXG5cbiAgICAgICAgcmVtb3ZlTGlzdGVuZXIodGFyZ2V0LCBsaXN0ZW5lcikge1xuICAgICAgICAgIHRhcmdldC5yZW1vdmVMaXN0ZW5lcih3cmFwcGVyTWFwLmdldChsaXN0ZW5lcikpO1xuICAgICAgICB9XG5cbiAgICAgIH0pOyAvLyBLZWVwIHRyYWNrIGlmIHRoZSBkZXByZWNhdGlvbiB3YXJuaW5nIGhhcyBiZWVuIGxvZ2dlZCBhdCBsZWFzdCBvbmNlLlxuXG5cbiAgICAgIGxldCBsb2dnZWRTZW5kUmVzcG9uc2VEZXByZWNhdGlvbldhcm5pbmcgPSBmYWxzZTtcbiAgICAgIGNvbnN0IG9uTWVzc2FnZVdyYXBwZXJzID0gbmV3IERlZmF1bHRXZWFrTWFwKGxpc3RlbmVyID0+IHtcbiAgICAgICAgaWYgKHR5cGVvZiBsaXN0ZW5lciAhPT0gXCJmdW5jdGlvblwiKSB7XG4gICAgICAgICAgcmV0dXJuIGxpc3RlbmVyO1xuICAgICAgICB9XG4gICAgICAgIC8qKlxuICAgICAgICAgKiBXcmFwcyBhIG1lc3NhZ2UgbGlzdGVuZXIgZnVuY3Rpb24gc28gdGhhdCBpdCBtYXkgc2VuZCByZXNwb25zZXMgYmFzZWQgb25cbiAgICAgICAgICogaXRzIHJldHVybiB2YWx1ZSwgcmF0aGVyIHRoYW4gYnkgcmV0dXJuaW5nIGEgc2VudGluZWwgdmFsdWUgYW5kIGNhbGxpbmcgYVxuICAgICAgICAgKiBjYWxsYmFjay4gSWYgdGhlIGxpc3RlbmVyIGZ1bmN0aW9uIHJldHVybnMgYSBQcm9taXNlLCB0aGUgcmVzcG9uc2UgaXNcbiAgICAgICAgICogc2VudCB3aGVuIHRoZSBwcm9taXNlIGVpdGhlciByZXNvbHZlcyBvciByZWplY3RzLlxuICAgICAgICAgKlxuICAgICAgICAgKiBAcGFyYW0geyp9IG1lc3NhZ2VcbiAgICAgICAgICogICAgICAgIFRoZSBtZXNzYWdlIHNlbnQgYnkgdGhlIG90aGVyIGVuZCBvZiB0aGUgY2hhbm5lbC5cbiAgICAgICAgICogQHBhcmFtIHtvYmplY3R9IHNlbmRlclxuICAgICAgICAgKiAgICAgICAgRGV0YWlscyBhYm91dCB0aGUgc2VuZGVyIG9mIHRoZSBtZXNzYWdlLlxuICAgICAgICAgKiBAcGFyYW0ge2Z1bmN0aW9uKCopfSBzZW5kUmVzcG9uc2VcbiAgICAgICAgICogICAgICAgIEEgY2FsbGJhY2sgd2hpY2gsIHdoZW4gY2FsbGVkIHdpdGggYW4gYXJiaXRyYXJ5IGFyZ3VtZW50LCBzZW5kc1xuICAgICAgICAgKiAgICAgICAgdGhhdCB2YWx1ZSBhcyBhIHJlc3BvbnNlLlxuICAgICAgICAgKiBAcmV0dXJucyB7Ym9vbGVhbn1cbiAgICAgICAgICogICAgICAgIFRydWUgaWYgdGhlIHdyYXBwZWQgbGlzdGVuZXIgcmV0dXJuZWQgYSBQcm9taXNlLCB3aGljaCB3aWxsIGxhdGVyXG4gICAgICAgICAqICAgICAgICB5aWVsZCBhIHJlc3BvbnNlLiBGYWxzZSBvdGhlcndpc2UuXG4gICAgICAgICAqL1xuXG5cbiAgICAgICAgcmV0dXJuIGZ1bmN0aW9uIG9uTWVzc2FnZShtZXNzYWdlLCBzZW5kZXIsIHNlbmRSZXNwb25zZSkge1xuICAgICAgICAgIGxldCBkaWRDYWxsU2VuZFJlc3BvbnNlID0gZmFsc2U7XG4gICAgICAgICAgbGV0IHdyYXBwZWRTZW5kUmVzcG9uc2U7XG4gICAgICAgICAgbGV0IHNlbmRSZXNwb25zZVByb21pc2UgPSBuZXcgUHJvbWlzZShyZXNvbHZlID0+IHtcbiAgICAgICAgICAgIHdyYXBwZWRTZW5kUmVzcG9uc2UgPSBmdW5jdGlvbiAocmVzcG9uc2UpIHtcbiAgICAgICAgICAgICAgaWYgKCFsb2dnZWRTZW5kUmVzcG9uc2VEZXByZWNhdGlvbldhcm5pbmcpIHtcbiAgICAgICAgICAgICAgICBjb25zb2xlLndhcm4oU0VORF9SRVNQT05TRV9ERVBSRUNBVElPTl9XQVJOSU5HLCBuZXcgRXJyb3IoKS5zdGFjayk7XG4gICAgICAgICAgICAgICAgbG9nZ2VkU2VuZFJlc3BvbnNlRGVwcmVjYXRpb25XYXJuaW5nID0gdHJ1ZTtcbiAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgIGRpZENhbGxTZW5kUmVzcG9uc2UgPSB0cnVlO1xuICAgICAgICAgICAgICByZXNvbHZlKHJlc3BvbnNlKTtcbiAgICAgICAgICAgIH07XG4gICAgICAgICAgfSk7XG4gICAgICAgICAgbGV0IHJlc3VsdDtcblxuICAgICAgICAgIHRyeSB7XG4gICAgICAgICAgICByZXN1bHQgPSBsaXN0ZW5lcihtZXNzYWdlLCBzZW5kZXIsIHdyYXBwZWRTZW5kUmVzcG9uc2UpO1xuICAgICAgICAgIH0gY2F0Y2ggKGVycikge1xuICAgICAgICAgICAgcmVzdWx0ID0gUHJvbWlzZS5yZWplY3QoZXJyKTtcbiAgICAgICAgICB9XG5cbiAgICAgICAgICBjb25zdCBpc1Jlc3VsdFRoZW5hYmxlID0gcmVzdWx0ICE9PSB0cnVlICYmIGlzVGhlbmFibGUocmVzdWx0KTsgLy8gSWYgdGhlIGxpc3RlbmVyIGRpZG4ndCByZXR1cm5lZCB0cnVlIG9yIGEgUHJvbWlzZSwgb3IgY2FsbGVkXG4gICAgICAgICAgLy8gd3JhcHBlZFNlbmRSZXNwb25zZSBzeW5jaHJvbm91c2x5LCB3ZSBjYW4gZXhpdCBlYXJsaWVyXG4gICAgICAgICAgLy8gYmVjYXVzZSB0aGVyZSB3aWxsIGJlIG5vIHJlc3BvbnNlIHNlbnQgZnJvbSB0aGlzIGxpc3RlbmVyLlxuXG4gICAgICAgICAgaWYgKHJlc3VsdCAhPT0gdHJ1ZSAmJiAhaXNSZXN1bHRUaGVuYWJsZSAmJiAhZGlkQ2FsbFNlbmRSZXNwb25zZSkge1xuICAgICAgICAgICAgcmV0dXJuIGZhbHNlO1xuICAgICAgICAgIH0gLy8gQSBzbWFsbCBoZWxwZXIgdG8gc2VuZCB0aGUgbWVzc2FnZSBpZiB0aGUgcHJvbWlzZSByZXNvbHZlc1xuICAgICAgICAgIC8vIGFuZCBhbiBlcnJvciBpZiB0aGUgcHJvbWlzZSByZWplY3RzIChhIHdyYXBwZWQgc2VuZE1lc3NhZ2UgaGFzXG4gICAgICAgICAgLy8gdG8gdHJhbnNsYXRlIHRoZSBtZXNzYWdlIGludG8gYSByZXNvbHZlZCBwcm9taXNlIG9yIGEgcmVqZWN0ZWRcbiAgICAgICAgICAvLyBwcm9taXNlKS5cblxuXG4gICAgICAgICAgY29uc3Qgc2VuZFByb21pc2VkUmVzdWx0ID0gcHJvbWlzZSA9PiB7XG4gICAgICAgICAgICBwcm9taXNlLnRoZW4obXNnID0+IHtcbiAgICAgICAgICAgICAgLy8gc2VuZCB0aGUgbWVzc2FnZSB2YWx1ZS5cbiAgICAgICAgICAgICAgc2VuZFJlc3BvbnNlKG1zZyk7XG4gICAgICAgICAgICB9LCBlcnJvciA9PiB7XG4gICAgICAgICAgICAgIC8vIFNlbmQgYSBKU09OIHJlcHJlc2VudGF0aW9uIG9mIHRoZSBlcnJvciBpZiB0aGUgcmVqZWN0ZWQgdmFsdWVcbiAgICAgICAgICAgICAgLy8gaXMgYW4gaW5zdGFuY2Ugb2YgZXJyb3IsIG9yIHRoZSBvYmplY3QgaXRzZWxmIG90aGVyd2lzZS5cbiAgICAgICAgICAgICAgbGV0IG1lc3NhZ2U7XG5cbiAgICAgICAgICAgICAgaWYgKGVycm9yICYmIChlcnJvciBpbnN0YW5jZW9mIEVycm9yIHx8IHR5cGVvZiBlcnJvci5tZXNzYWdlID09PSBcInN0cmluZ1wiKSkge1xuICAgICAgICAgICAgICAgIG1lc3NhZ2UgPSBlcnJvci5tZXNzYWdlO1xuICAgICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICAgIG1lc3NhZ2UgPSBcIkFuIHVuZXhwZWN0ZWQgZXJyb3Igb2NjdXJyZWRcIjtcbiAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgIHNlbmRSZXNwb25zZSh7XG4gICAgICAgICAgICAgICAgX19tb3pXZWJFeHRlbnNpb25Qb2x5ZmlsbFJlamVjdF9fOiB0cnVlLFxuICAgICAgICAgICAgICAgIG1lc3NhZ2VcbiAgICAgICAgICAgICAgfSk7XG4gICAgICAgICAgICB9KS5jYXRjaChlcnIgPT4ge1xuICAgICAgICAgICAgICAvLyBQcmludCBhbiBlcnJvciBvbiB0aGUgY29uc29sZSBpZiB1bmFibGUgdG8gc2VuZCB0aGUgcmVzcG9uc2UuXG4gICAgICAgICAgICAgIGNvbnNvbGUuZXJyb3IoXCJGYWlsZWQgdG8gc2VuZCBvbk1lc3NhZ2UgcmVqZWN0ZWQgcmVwbHlcIiwgZXJyKTtcbiAgICAgICAgICAgIH0pO1xuICAgICAgICAgIH07IC8vIElmIHRoZSBsaXN0ZW5lciByZXR1cm5lZCBhIFByb21pc2UsIHNlbmQgdGhlIHJlc29sdmVkIHZhbHVlIGFzIGFcbiAgICAgICAgICAvLyByZXN1bHQsIG90aGVyd2lzZSB3YWl0IHRoZSBwcm9taXNlIHJlbGF0ZWQgdG8gdGhlIHdyYXBwZWRTZW5kUmVzcG9uc2VcbiAgICAgICAgICAvLyBjYWxsYmFjayB0byByZXNvbHZlIGFuZCBzZW5kIGl0IGFzIGEgcmVzcG9uc2UuXG5cblxuICAgICAgICAgIGlmIChpc1Jlc3VsdFRoZW5hYmxlKSB7XG4gICAgICAgICAgICBzZW5kUHJvbWlzZWRSZXN1bHQocmVzdWx0KTtcbiAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgc2VuZFByb21pc2VkUmVzdWx0KHNlbmRSZXNwb25zZVByb21pc2UpO1xuICAgICAgICAgIH0gLy8gTGV0IENocm9tZSBrbm93IHRoYXQgdGhlIGxpc3RlbmVyIGlzIHJlcGx5aW5nLlxuXG5cbiAgICAgICAgICByZXR1cm4gdHJ1ZTtcbiAgICAgICAgfTtcbiAgICAgIH0pO1xuXG4gICAgICBjb25zdCB3cmFwcGVkU2VuZE1lc3NhZ2VDYWxsYmFjayA9ICh7XG4gICAgICAgIHJlamVjdCxcbiAgICAgICAgcmVzb2x2ZVxuICAgICAgfSwgcmVwbHkpID0+IHtcbiAgICAgICAgaWYgKGV4dGVuc2lvbkFQSXMucnVudGltZS5sYXN0RXJyb3IpIHtcbiAgICAgICAgICAvLyBEZXRlY3Qgd2hlbiBub25lIG9mIHRoZSBsaXN0ZW5lcnMgcmVwbGllZCB0byB0aGUgc2VuZE1lc3NhZ2UgY2FsbCBhbmQgcmVzb2x2ZVxuICAgICAgICAgIC8vIHRoZSBwcm9taXNlIHRvIHVuZGVmaW5lZCBhcyBpbiBGaXJlZm94LlxuICAgICAgICAgIC8vIFNlZSBodHRwczovL2dpdGh1Yi5jb20vbW96aWxsYS93ZWJleHRlbnNpb24tcG9seWZpbGwvaXNzdWVzLzEzMFxuICAgICAgICAgIGlmIChleHRlbnNpb25BUElzLnJ1bnRpbWUubGFzdEVycm9yLm1lc3NhZ2UgPT09IENIUk9NRV9TRU5EX01FU1NBR0VfQ0FMTEJBQ0tfTk9fUkVTUE9OU0VfTUVTU0FHRSkge1xuICAgICAgICAgICAgcmVzb2x2ZSgpO1xuICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICByZWplY3QoZXh0ZW5zaW9uQVBJcy5ydW50aW1lLmxhc3RFcnJvcik7XG4gICAgICAgICAgfVxuICAgICAgICB9IGVsc2UgaWYgKHJlcGx5ICYmIHJlcGx5Ll9fbW96V2ViRXh0ZW5zaW9uUG9seWZpbGxSZWplY3RfXykge1xuICAgICAgICAgIC8vIENvbnZlcnQgYmFjayB0aGUgSlNPTiByZXByZXNlbnRhdGlvbiBvZiB0aGUgZXJyb3IgaW50b1xuICAgICAgICAgIC8vIGFuIEVycm9yIGluc3RhbmNlLlxuICAgICAgICAgIHJlamVjdChuZXcgRXJyb3IocmVwbHkubWVzc2FnZSkpO1xuICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgIHJlc29sdmUocmVwbHkpO1xuICAgICAgICB9XG4gICAgICB9O1xuXG4gICAgICBjb25zdCB3cmFwcGVkU2VuZE1lc3NhZ2UgPSAobmFtZSwgbWV0YWRhdGEsIGFwaU5hbWVzcGFjZU9iaiwgLi4uYXJncykgPT4ge1xuICAgICAgICBpZiAoYXJncy5sZW5ndGggPCBtZXRhZGF0YS5taW5BcmdzKSB7XG4gICAgICAgICAgdGhyb3cgbmV3IEVycm9yKGBFeHBlY3RlZCBhdCBsZWFzdCAke21ldGFkYXRhLm1pbkFyZ3N9ICR7cGx1cmFsaXplQXJndW1lbnRzKG1ldGFkYXRhLm1pbkFyZ3MpfSBmb3IgJHtuYW1lfSgpLCBnb3QgJHthcmdzLmxlbmd0aH1gKTtcbiAgICAgICAgfVxuXG4gICAgICAgIGlmIChhcmdzLmxlbmd0aCA+IG1ldGFkYXRhLm1heEFyZ3MpIHtcbiAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoYEV4cGVjdGVkIGF0IG1vc3QgJHttZXRhZGF0YS5tYXhBcmdzfSAke3BsdXJhbGl6ZUFyZ3VtZW50cyhtZXRhZGF0YS5tYXhBcmdzKX0gZm9yICR7bmFtZX0oKSwgZ290ICR7YXJncy5sZW5ndGh9YCk7XG4gICAgICAgIH1cblxuICAgICAgICByZXR1cm4gbmV3IFByb21pc2UoKHJlc29sdmUsIHJlamVjdCkgPT4ge1xuICAgICAgICAgIGNvbnN0IHdyYXBwZWRDYiA9IHdyYXBwZWRTZW5kTWVzc2FnZUNhbGxiYWNrLmJpbmQobnVsbCwge1xuICAgICAgICAgICAgcmVzb2x2ZSxcbiAgICAgICAgICAgIHJlamVjdFxuICAgICAgICAgIH0pO1xuICAgICAgICAgIGFyZ3MucHVzaCh3cmFwcGVkQ2IpO1xuICAgICAgICAgIGFwaU5hbWVzcGFjZU9iai5zZW5kTWVzc2FnZSguLi5hcmdzKTtcbiAgICAgICAgfSk7XG4gICAgICB9O1xuXG4gICAgICBjb25zdCBzdGF0aWNXcmFwcGVycyA9IHtcbiAgICAgICAgcnVudGltZToge1xuICAgICAgICAgIG9uTWVzc2FnZTogd3JhcEV2ZW50KG9uTWVzc2FnZVdyYXBwZXJzKSxcbiAgICAgICAgICBvbk1lc3NhZ2VFeHRlcm5hbDogd3JhcEV2ZW50KG9uTWVzc2FnZVdyYXBwZXJzKSxcbiAgICAgICAgICBzZW5kTWVzc2FnZTogd3JhcHBlZFNlbmRNZXNzYWdlLmJpbmQobnVsbCwgXCJzZW5kTWVzc2FnZVwiLCB7XG4gICAgICAgICAgICBtaW5BcmdzOiAxLFxuICAgICAgICAgICAgbWF4QXJnczogM1xuICAgICAgICAgIH0pXG4gICAgICAgIH0sXG4gICAgICAgIHRhYnM6IHtcbiAgICAgICAgICBzZW5kTWVzc2FnZTogd3JhcHBlZFNlbmRNZXNzYWdlLmJpbmQobnVsbCwgXCJzZW5kTWVzc2FnZVwiLCB7XG4gICAgICAgICAgICBtaW5BcmdzOiAyLFxuICAgICAgICAgICAgbWF4QXJnczogM1xuICAgICAgICAgIH0pXG4gICAgICAgIH1cbiAgICAgIH07XG4gICAgICBjb25zdCBzZXR0aW5nTWV0YWRhdGEgPSB7XG4gICAgICAgIGNsZWFyOiB7XG4gICAgICAgICAgbWluQXJnczogMSxcbiAgICAgICAgICBtYXhBcmdzOiAxXG4gICAgICAgIH0sXG4gICAgICAgIGdldDoge1xuICAgICAgICAgIG1pbkFyZ3M6IDEsXG4gICAgICAgICAgbWF4QXJnczogMVxuICAgICAgICB9LFxuICAgICAgICBzZXQ6IHtcbiAgICAgICAgICBtaW5BcmdzOiAxLFxuICAgICAgICAgIG1heEFyZ3M6IDFcbiAgICAgICAgfVxuICAgICAgfTtcbiAgICAgIGFwaU1ldGFkYXRhLnByaXZhY3kgPSB7XG4gICAgICAgIG5ldHdvcms6IHtcbiAgICAgICAgICBcIipcIjogc2V0dGluZ01ldGFkYXRhXG4gICAgICAgIH0sXG4gICAgICAgIHNlcnZpY2VzOiB7XG4gICAgICAgICAgXCIqXCI6IHNldHRpbmdNZXRhZGF0YVxuICAgICAgICB9LFxuICAgICAgICB3ZWJzaXRlczoge1xuICAgICAgICAgIFwiKlwiOiBzZXR0aW5nTWV0YWRhdGFcbiAgICAgICAgfVxuICAgICAgfTtcbiAgICAgIHJldHVybiB3cmFwT2JqZWN0KGV4dGVuc2lvbkFQSXMsIHN0YXRpY1dyYXBwZXJzLCBhcGlNZXRhZGF0YSk7XG4gICAgfTtcblxuICAgIGlmICh0eXBlb2YgY2hyb21lICE9IFwib2JqZWN0XCIgfHwgIWNocm9tZSB8fCAhY2hyb21lLnJ1bnRpbWUgfHwgIWNocm9tZS5ydW50aW1lLmlkKSB7XG4gICAgICB0aHJvdyBuZXcgRXJyb3IoXCJUaGlzIHNjcmlwdCBzaG91bGQgb25seSBiZSBsb2FkZWQgaW4gYSBicm93c2VyIGV4dGVuc2lvbi5cIik7XG4gICAgfSAvLyBUaGUgYnVpbGQgcHJvY2VzcyBhZGRzIGEgVU1EIHdyYXBwZXIgYXJvdW5kIHRoaXMgZmlsZSwgd2hpY2ggbWFrZXMgdGhlXG4gICAgLy8gYG1vZHVsZWAgdmFyaWFibGUgYXZhaWxhYmxlLlxuXG5cbiAgICBtb2R1bGUuZXhwb3J0cyA9IHdyYXBBUElzKGNocm9tZSk7XG4gIH0gZWxzZSB7XG4gICAgbW9kdWxlLmV4cG9ydHMgPSBicm93c2VyO1xuICB9XG59KTtcbi8vIyBzb3VyY2VNYXBwaW5nVVJMPWJyb3dzZXItcG9seWZpbGwuanMubWFwXG4iLCIvLyBUaGUgbW9kdWxlIGNhY2hlXG52YXIgX193ZWJwYWNrX21vZHVsZV9jYWNoZV9fID0ge307XG5cbi8vIFRoZSByZXF1aXJlIGZ1bmN0aW9uXG5mdW5jdGlvbiBfX3dlYnBhY2tfcmVxdWlyZV9fKG1vZHVsZUlkKSB7XG5cdC8vIENoZWNrIGlmIG1vZHVsZSBpcyBpbiBjYWNoZVxuXHR2YXIgY2FjaGVkTW9kdWxlID0gX193ZWJwYWNrX21vZHVsZV9jYWNoZV9fW21vZHVsZUlkXTtcblx0aWYgKGNhY2hlZE1vZHVsZSAhPT0gdW5kZWZpbmVkKSB7XG5cdFx0cmV0dXJuIGNhY2hlZE1vZHVsZS5leHBvcnRzO1xuXHR9XG5cdC8vIENyZWF0ZSBhIG5ldyBtb2R1bGUgKGFuZCBwdXQgaXQgaW50byB0aGUgY2FjaGUpXG5cdHZhciBtb2R1bGUgPSBfX3dlYnBhY2tfbW9kdWxlX2NhY2hlX19bbW9kdWxlSWRdID0ge1xuXHRcdC8vIG5vIG1vZHVsZS5pZCBuZWVkZWRcblx0XHQvLyBubyBtb2R1bGUubG9hZGVkIG5lZWRlZFxuXHRcdGV4cG9ydHM6IHt9XG5cdH07XG5cblx0Ly8gRXhlY3V0ZSB0aGUgbW9kdWxlIGZ1bmN0aW9uXG5cdF9fd2VicGFja19tb2R1bGVzX19bbW9kdWxlSWRdLmNhbGwobW9kdWxlLmV4cG9ydHMsIG1vZHVsZSwgbW9kdWxlLmV4cG9ydHMsIF9fd2VicGFja19yZXF1aXJlX18pO1xuXG5cdC8vIFJldHVybiB0aGUgZXhwb3J0cyBvZiB0aGUgbW9kdWxlXG5cdHJldHVybiBtb2R1bGUuZXhwb3J0cztcbn1cblxuIiwiLy8gZ2V0RGVmYXVsdEV4cG9ydCBmdW5jdGlvbiBmb3IgY29tcGF0aWJpbGl0eSB3aXRoIG5vbi1oYXJtb255IG1vZHVsZXNcbl9fd2VicGFja19yZXF1aXJlX18ubiA9IChtb2R1bGUpID0+IHtcblx0dmFyIGdldHRlciA9IG1vZHVsZSAmJiBtb2R1bGUuX19lc01vZHVsZSA/XG5cdFx0KCkgPT4gKG1vZHVsZVsnZGVmYXVsdCddKSA6XG5cdFx0KCkgPT4gKG1vZHVsZSk7XG5cdF9fd2VicGFja19yZXF1aXJlX18uZChnZXR0ZXIsIHsgYTogZ2V0dGVyIH0pO1xuXHRyZXR1cm4gZ2V0dGVyO1xufTsiLCIvLyBkZWZpbmUgZ2V0dGVyIGZ1bmN0aW9ucyBmb3IgaGFybW9ueSBleHBvcnRzXG5fX3dlYnBhY2tfcmVxdWlyZV9fLmQgPSAoZXhwb3J0cywgZGVmaW5pdGlvbikgPT4ge1xuXHRmb3IodmFyIGtleSBpbiBkZWZpbml0aW9uKSB7XG5cdFx0aWYoX193ZWJwYWNrX3JlcXVpcmVfXy5vKGRlZmluaXRpb24sIGtleSkgJiYgIV9fd2VicGFja19yZXF1aXJlX18ubyhleHBvcnRzLCBrZXkpKSB7XG5cdFx0XHRPYmplY3QuZGVmaW5lUHJvcGVydHkoZXhwb3J0cywga2V5LCB7IGVudW1lcmFibGU6IHRydWUsIGdldDogZGVmaW5pdGlvbltrZXldIH0pO1xuXHRcdH1cblx0fVxufTsiLCJfX3dlYnBhY2tfcmVxdWlyZV9fLm8gPSAob2JqLCBwcm9wKSA9PiAoT2JqZWN0LnByb3RvdHlwZS5oYXNPd25Qcm9wZXJ0eS5jYWxsKG9iaiwgcHJvcCkpIiwiLy8gZGVmaW5lIF9fZXNNb2R1bGUgb24gZXhwb3J0c1xuX193ZWJwYWNrX3JlcXVpcmVfXy5yID0gKGV4cG9ydHMpID0+IHtcblx0aWYodHlwZW9mIFN5bWJvbCAhPT0gJ3VuZGVmaW5lZCcgJiYgU3ltYm9sLnRvU3RyaW5nVGFnKSB7XG5cdFx0T2JqZWN0LmRlZmluZVByb3BlcnR5KGV4cG9ydHMsIFN5bWJvbC50b1N0cmluZ1RhZywgeyB2YWx1ZTogJ01vZHVsZScgfSk7XG5cdH1cblx0T2JqZWN0LmRlZmluZVByb3BlcnR5KGV4cG9ydHMsICdfX2VzTW9kdWxlJywgeyB2YWx1ZTogdHJ1ZSB9KTtcbn07IiwiaW1wb3J0IHsgY29udGVudCB9IGZyb20gJy4uLy4uL3BhZ2VzL2NvbnRlbnQnO1xuXG5jb250ZW50LmluaXQoKTtcbiJdLCJzb3VyY2VSb290IjoiIn0=