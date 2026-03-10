/******/ (() => { // webpackBootstrap
/******/ 	var __webpack_modules__ = ({

/***/ 6263:
/***/ ((module) => {

/*!
 * AdGuard Assistant - v4.3.68 - Tue Dec 06 2022
 * https://github.com/AdguardTeam/AdguardAssistant#adguard-assistant
 * Copyright (c) 2022 AdGuard. Licensed GPL-3.0
 */
(function webpackUniversalModuleDefinition(root, factory) {
	if(true)
		module.exports = factory();
	else { var i, a; }
})(self, () => {
return /******/ (() => { // webpackBootstrap
/******/ 	var __webpack_modules__ = ({

/***/ 1503:
/***/ ((module, __unused_webpack_exports, __nested_webpack_require_667__) => {

var map = {
	"./ar/messages.json": 5443,
	"./be/messages.json": 24,
	"./cs/messages.json": 3337,
	"./da/messages.json": 7691,
	"./de/messages.json": 9947,
	"./el/messages.json": 1773,
	"./en/messages.json": 1272,
	"./es/messages.json": 8194,
	"./fa/messages.json": 5455,
	"./fi/messages.json": 6183,
	"./fr/messages.json": 4652,
	"./he/messages.json": 6514,
	"./hi/messages.json": 1996,
	"./hr/messages.json": 2178,
	"./hu/messages.json": 2698,
	"./id/messages.json": 710,
	"./it/messages.json": 7294,
	"./ja/messages.json": 9265,
	"./ko/messages.json": 1474,
	"./lt/messages.json": 8612,
	"./nl/messages.json": 8967,
	"./no/messages.json": 6251,
	"./pl/messages.json": 1549,
	"./pt-PT/messages.json": 1902,
	"./pt/messages.json": 9274,
	"./ro/messages.json": 6090,
	"./ru/messages.json": 3999,
	"./sk/messages.json": 89,
	"./sl/messages.json": 6058,
	"./sr/messages.json": 9177,
	"./sv/messages.json": 6105,
	"./tr/messages.json": 147,
	"./uk/messages.json": 1249,
	"./vi/messages.json": 4534,
	"./zh-HK/messages.json": 3476,
	"./zh-TW/messages.json": 5480,
	"./zh/messages.json": 8868
};


function webpackContext(req) {
	var id = webpackContextResolve(req);
	return __nested_webpack_require_667__(id);
}
function webpackContextResolve(req) {
	if(!__nested_webpack_require_667__.o(map, req)) {
		var e = new Error("Cannot find module '" + req + "'");
		e.code = 'MODULE_NOT_FOUND';
		throw e;
	}
	return map[req];
}
webpackContext.keys = function webpackContextKeys() {
	return Object.keys(map);
};
webpackContext.resolve = webpackContextResolve;
module.exports = webpackContext;
webpackContext.id = 1503;

/***/ }),

/***/ 14:
/***/ ((module, __unused_webpack_exports, __nested_webpack_require_2344__) => {

function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { if (typeof Symbol === "undefined" || !(Symbol.iterator in Object(arr))) return; var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

var _require = __nested_webpack_require_2344__(897),
    _require2 = _slicedToArray(_require, 1),
    _require2$ = _require2[0],
    BASE_LOCALE = _require2$.base_locale,
    PROJECT_ID = _require2$.project_id,
    LANGUAGES = _require2$.languages,
    LOCALIZABLE_FILES = _require2$.localizable_files;
/**
 * Users locale may be defined with only two chars (language code)
 * Here we provide a map of equivalent translation for such locales
 */


var LOCALES_EQUIVALENTS_MAP = {
  'pt-BR': 'pt',
  'zh-CN': 'zh'
};
module.exports = {
  LOCALES_EQUIVALENTS_MAP: LOCALES_EQUIVALENTS_MAP,
  BASE_LOCALE: BASE_LOCALE,
  PROJECT_ID: PROJECT_ID,
  LANGUAGES: LANGUAGES,
  LOCALIZABLE_FILES: LOCALIZABLE_FILES
};

/***/ }),

/***/ 4123:
/***/ ((module, exports, __nested_webpack_require_4635__) => {

// Imports
var ___CSS_LOADER_API_IMPORT___ = __nested_webpack_require_4635__(3645);
var ___CSS_LOADER_GET_URL_IMPORT___ = __nested_webpack_require_4635__(1667);
var ___CSS_LOADER_URL_IMPORT_0___ = __nested_webpack_require_4635__(2668);
var ___CSS_LOADER_URL_IMPORT_1___ = __nested_webpack_require_4635__(1823);
exports = ___CSS_LOADER_API_IMPORT___(false);
var ___CSS_LOADER_URL_REPLACEMENT_0___ = ___CSS_LOADER_GET_URL_IMPORT___(___CSS_LOADER_URL_IMPORT_0___);
var ___CSS_LOADER_URL_REPLACEMENT_1___ = ___CSS_LOADER_GET_URL_IMPORT___(___CSS_LOADER_URL_IMPORT_1___);
// Module
exports.push([module.id, "/*! normalize.css v3.0.1 | MIT License | git.io/normalize */\n/**\n * 1. Set default font family to sans-serif.\n * 2. Prevent iOS text size adjust after orientation change, without disabling\n *    user zoom.\n */\nhtml {\n  font-family: sans-serif;\n  /* 1 */\n  -ms-text-size-adjust: 100%;\n  /* 2 */\n  -webkit-text-size-adjust: 100%;\n  /* 2 */\n}\n/**\n * Remove default margin.\n */\nbody {\n  margin: 0;\n}\n/* HTML5 display definitions\n========================================================================== */\n/**\n * Correct `block` display not defined for any HTML5 element in IE 8/9.\n * Correct `block` display not defined for `details` or `summary` in IE 10/11 and Firefox.\n * Correct `block` display not defined for `main` in IE 11.\n */\narticle,\naside,\ndetails,\nfigcaption,\nfigure,\nfooter,\nheader,\nhgroup,\nmain,\nnav,\nsection,\nsummary {\n  display: block;\n}\n/**\n * 1. Correct `inline-block` display not defined in IE 8/9.\n * 2. Normalize vertical alignment of `progress` in Chrome, Firefox, and Opera.\n */\naudio,\ncanvas,\nprogress,\nvideo {\n  display: inline-block;\n  /* 1 */\n  vertical-align: baseline;\n  /* 2 */\n}\n/**\n * Prevent modern browsers from displaying `audio` without controls.\n * Remove excess height in iOS 5 devices.\n */\naudio:not([controls]) {\n  display: none;\n  height: 0;\n}\n/**\n * Address `[hidden]` styling not present in IE 8/9/10.\n * Hide the `template` element in IE 8/9/11, Safari, and Firefox < 22.\n */\n[hidden],\ntemplate {\n  display: none;\n}\n/* Links\n========================================================================== */\n/**\n * Remove the gray background color from active links in IE 10.\n */\na {\n  background: transparent;\n}\n/**\n * Improve readability when focused and also mouse hovered in all browsers.\n */\na:active,\na:hover {\n  outline: 0;\n}\n/* Text-level semantics\n========================================================================== */\n/**\n * Address styling not present in IE 8/9/10/11, Safari, and Chrome.\n */\nabbr[title] {\n  border-bottom: 1px dotted;\n}\n/**\n * Address style set to `bolder` in Firefox 4+, Safari, and Chrome.\n */\nb,\nstrong {\n  font-weight: bold;\n}\n/**\n * Address styling not present in Safari and Chrome.\n */\ndfn {\n  font-style: italic;\n}\n/**\n * Address variable `h1` font-size and margin within `section` and `article`\n * contexts in Firefox 4+, Safari, and Chrome.\n */\nh1 {\n  font-size: 2em;\n  margin: 0.67em 0;\n}\n/**\n * Address styling not present in IE 8/9.\n */\nmark {\n  background: #ff0;\n  color: #000;\n}\n/**\n * Address inconsistent and variable font size in all browsers.\n */\nsmall {\n  font-size: 80%;\n}\n/**\n * Prevent `sub` and `sup` affecting `line-height` in all browsers.\n */\nsub,\nsup {\n  font-size: 75%;\n  line-height: 0;\n  position: relative;\n  vertical-align: baseline;\n}\nsup {\n  top: -0.5em;\n}\nsub {\n  bottom: -0.25em;\n}\n/* Embedded content\n========================================================================== */\n/**\n * Remove border when inside `a` element in IE 8/9/10.\n */\nimg {\n  border: 0;\n}\n/**\n * Correct overflow not hidden in IE 9/10/11.\n */\nsvg:not(:root) {\n  overflow: hidden;\n}\n/* Grouping content\n========================================================================== */\n/**\n * Address margin not present in IE 8/9 and Safari.\n */\nfigure {\n  margin: 1em 40px;\n}\n/**\n * Address differences between Firefox and other browsers.\n */\nhr {\n  -moz-box-sizing: content-box;\n  box-sizing: content-box;\n  height: 0;\n}\n/**\n * Contain overflow in all browsers.\n */\npre {\n  overflow: auto;\n}\n/**\n * Address odd `em`-unit font size rendering in all browsers.\n */\ncode,\nkbd,\npre,\nsamp {\n  font-family: monospace, monospace;\n  font-size: 1em;\n}\n/* Forms\n========================================================================== */\n/**\n * Known limitation: by default, Chrome and Safari on OS X allow very limited\n * styling of `select`, unless a `border` property is set.\n */\n/**\n * 1. Correct color not being inherited.\n *    Known issue: affects color of disabled elements.\n * 2. Correct font properties not being inherited.\n * 3. Address margins set differently in Firefox 4+, Safari, and Chrome.\n */\nbutton,\ninput,\noptgroup,\nselect,\ntextarea {\n  color: inherit;\n  /* 1 */\n  font: inherit;\n  /* 2 */\n  margin: 0;\n  /* 3 */\n}\n/**\n * Address `overflow` set to `hidden` in IE 8/9/10/11.\n */\nbutton {\n  overflow: visible;\n}\n/**\n * Address inconsistent `text-transform` inheritance for `button` and `select`.\n * All other form control elements do not inherit `text-transform` values.\n * Correct `button` style inheritance in Firefox, IE 8/9/10/11, and Opera.\n * Correct `select` style inheritance in Firefox.\n */\nbutton,\nselect {\n  text-transform: none;\n}\n/**\n * 1. Avoid the WebKit bug in Android 4.0.* where (2) destroys native `audio`\n *    and `video` controls.\n * 2. Correct inability to style clickable `input` types in iOS.\n * 3. Improve usability and consistency of cursor style between image-type\n *    `input` and others.\n */\nbutton,\nhtml input[type=\"button\"],\ninput[type=\"reset\"],\ninput[type=\"submit\"] {\n  -webkit-appearance: button;\n  /* 2 */\n  cursor: pointer;\n  /* 3 */\n}\n/**\n * Re-set default cursor for disabled elements.\n */\nbutton[disabled],\nhtml input[disabled] {\n  cursor: default;\n}\n/**\n * Remove inner padding and border in Firefox 4+.\n */\nbutton::-moz-focus-inner,\ninput::-moz-focus-inner {\n  border: 0;\n  padding: 0;\n}\n/**\n * Address Firefox 4+ setting `line-height` on `input` using `!important` in\n * the UA stylesheet.\n */\ninput {\n  line-height: normal;\n}\n/**\n * It's recommended that you don't attempt to style these elements.\n * Firefox's implementation doesn't respect box-sizing, padding, or width.\n *\n * 1. Address box sizing set to `content-box` in IE 8/9/10.\n * 2. Remove excess padding in IE 8/9/10.\n */\ninput[type=\"checkbox\"],\ninput[type=\"radio\"] {\n  box-sizing: border-box;\n  /* 1 */\n  padding: 0;\n  /* 2 */\n}\n/**\n * Fix the cursor style for Chrome's increment/decrement buttons. For certain\n * `font-size` values of the `input`, it causes the cursor style of the\n * decrement button to change from `default` to `text`.\n */\ninput[type=\"number\"]::-webkit-inner-spin-button,\ninput[type=\"number\"]::-webkit-outer-spin-button {\n  height: auto;\n}\n/**\n * 1. Address `appearance` set to `searchfield` in Safari and Chrome.\n * 2. Address `box-sizing` set to `border-box` in Safari and Chrome\n *    (include `-moz` to future-proof).\n */\ninput[type=\"search\"] {\n  -webkit-appearance: textfield;\n  /* 1 */\n  -moz-box-sizing: content-box;\n  -webkit-box-sizing: content-box;\n  /* 2 */\n  box-sizing: content-box;\n}\n/**\n * Remove inner padding and search cancel button in Safari and Chrome on OS X.\n * Safari (but not Chrome) clips the cancel button when the search input has\n * padding (and `textfield` appearance).\n */\ninput[type=\"search\"]::-webkit-search-cancel-button,\ninput[type=\"search\"]::-webkit-search-decoration {\n  -webkit-appearance: none;\n}\n/**\n * Define consistent border, margin, and padding.\n */\nfieldset {\n  border: 1px solid #c0c0c0;\n  margin: 0 2px;\n  padding: 0.35em 0.625em 0.75em;\n}\n/**\n * 1. Correct `color` not being inherited in IE 8/9/10/11.\n * 2. Remove padding so people aren't caught out if they zero out fieldsets.\n */\nlegend {\n  border: 0;\n  /* 1 */\n  padding: 0;\n  /* 2 */\n}\n/**\n * Remove default vertical scrollbar in IE 8/9/10/11.\n */\ntextarea {\n  overflow: auto;\n}\n/**\n * Don't inherit the `font-weight` (applied by a rule above).\n * NOTE: the default cannot safely be changed in Chrome and Safari on OS X.\n */\noptgroup {\n  font-weight: bold;\n}\n/* Tables\n========================================================================== */\n/**\n * Remove most spacing between table cells.\n */\ntable {\n  border-collapse: collapse;\n  border-spacing: 0;\n}\ntd,\nth {\n  padding: 0;\n}\n* {\n  box-sizing: border-box;\n}\n*:after,\n*:before {\n  box-sizing: border-box;\n}\nhtml {\n  font-size: 10px;\n  -webkit-tap-highlight-color: rgba(0, 0, 0, 0);\n}\nbody {\n  position: relative;\n  font-size: 1.3rem;\n  line-height: 1.42857143;\n  background-color: #e6e6e6;\n  font-family: \"Open Sans\", Arial, sans-serif;\n  font-weight: 400;\n  overflow-y: hidden;\n}\nbutton,\ninput,\nselect,\ntextarea {\n  font-family: inherit;\n  font-size: inherit;\n  line-height: inherit;\n  outline: none;\n  border-radius: 0;\n  box-shadow: none;\n}\na {\n  color: #36ba53;\n  text-decoration: underline;\n  outline: 0;\n}\na:hover {\n  color: #257f39;\n  text-decoration: underline;\n}\nfigure {\n  margin: 0;\n}\nimg {\n  vertical-align: middle;\n  max-width: 100%;\n}\nform {\n  margin: 0;\n}\nfieldset {\n  padding: 0;\n  margin: 0;\n  border: 0;\n  min-width: 0;\n}\nlegend {\n  display: block;\n  width: 100%;\n  padding: 0;\n  margin-bottom: 1.57142857;\n  font-size: 21px;\n  line-height: inherit;\n  border: 0;\n}\nlabel {\n  display: inline-block;\n}\ninput[type=\"search\"] {\n  box-sizing: border-box;\n}\ninput[type=\"radio\"],\ninput[type=\"checkbox\"] {\n  display: none;\n}\ninput[type=\"file\"]:focus,\ninput[type=\"radio\"]:focus,\ninput[type=\"checkbox\"]:focus {\n  outline: thin dotted;\n  outline: 5px auto -webkit-focus-ring-color;\n  outline-offset: -2px;\n}\n.form-control {\n  display: block;\n  width: 100%;\n  height: 40px;\n  padding: 6px 15px 4px;\n  font-size: 14px;\n  line-height: 22px;\n  box-shadow: inset 0 3px 3px rgba(0, 0, 0, 0.04);\n}\n.form-control:focus {\n  border-color: #8c8c8c;\n  outline: 0;\n}\n.form-control::-moz-placeholder {\n  color: #777777;\n  opacity: 1;\n}\n.form-control:-ms-input-placeholder {\n  color: #777777;\n}\n.form-control::-webkit-input-placeholder {\n  color: #777777;\n}\n.form-control[disabled],\n.form-control[readonly],\nfieldset[disabled] .form-control {\n  cursor: not-allowed;\n  background-color: #fff;\n  opacity: 1;\n}\ntextarea.form-control {\n  height: auto;\n}\n/*\n.fieldset.error{\n    .form-control{\n        border-color: @state-danger-text;\n        .placeholder(@state-danger-text);\n    }\n}\n*/\ninput[type=\"search\"] {\n  -webkit-appearance: none;\n}\ninput[type=\"date\"],\ninput[type=\"time\"],\ninput[type=\"datetime-local\"],\ninput[type=\"month\"] {\n  line-height: 22px;\n}\n.form-group {\n  margin: 23px 0 0;\n}\n.form-group:first-child {\n  margin-top: 0;\n}\ninput[type=\"radio\"][disabled],\ninput[type=\"checkbox\"][disabled],\ninput[type=\"radio\"].disabled,\ninput[type=\"checkbox\"].disabled,\nfieldset[disabled] input[type=\"radio\"],\nfieldset[disabled] input[type=\"checkbox\"] {\n  cursor: not-allowed;\n}\n@font-face {\n    font-family: 'Open Sans';\n    src: url('data:application/font-woff;base64,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') format('woff');\n    font-weight: normal;\n    font-style: normal;\n}\n\n@font-face {\n    font-family: 'Open Sans';\n    src: url('data:application/font-woff;base64,d09GRgABAAAAAMJ8ABMAAAABf4AAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAABGRlRNAADCWAAAABwAAAAcc200FkdERUYAALJ4AAAAHgAAAB4AJwHMR1BPUwAAstAAAA+GAAAgvrps/pRHU1VCAACymAAAADgAAABQkzyCS09TLzIAAAIkAAAAYAAAAGChs72vY21hcAAABtwAAAJuAAAD5hQ2HAhjdnQgAAAL5AAAAEgAAABIEUIViGZwZ20AAAlMAAABsQAAAmVTtC+nZ2FzcAAAsnAAAAAIAAAACAAAABBnbHlmAAAPvAAAmjEAATXcGBSJu2hlYWQAAAGoAAAANgAAADYHlgBVaGhlYQAAAeAAAAAhAAAAJBErCMtobXR4AAAChAAABFUAAAcYbFemBGxvY2EAAAwsAAADjgAAA460B2jSbWF4cAAAAgQAAAAgAAAAIALmAeBuYW1lAACp8AAAAw0AAAarnRnsGXBvc3QAAK0AAAAFbwAADLWt/T0acHJlcAAACwAAAADhAAABifN0UZB3ZWJmAADCdAAAAAYAAAAGAF9Z1gABAAAAARnbkezEVF8PPPUAHwgAAAAAAMlM6n0AAAAA1fuw3v9q/hQJsAgOAAAACAACAAAAAAAAeNpjYGRg4OD7u46BgXPr/6z/Czk3MABFkAHjMQCaFgcLAAAAAAEAAAHGAG4ACAAAAAAAAgABAAIAFgAAAQABbgAAAAAAAwTDAlgABQAEBZoFMwAAAR8FmgUzAAAD0QBmAfYAAAILBwYDCAQCAgTgAALvQAAgWwAAACgAAAAAMUFTQwBAAA0l/AZm/mYAAAgOAlIgAAGfAAAAAARSBbYAAAAgAAJ42l1VUWhcRRQ9b97MvGe66VKCdQ3rWkNqWNoFKwi1DYYSt2kpJZiWdC1r1DXa2pRYdAuhgqwfETVKP8xHhWD7FKGl1BbE4Iq2KkGrKIh+SFMIodUSQtUvq8Ga9dzJe0FdOJz3Zu6dd++ZM7PqOh4Ef/484C0CKoea/zBq+gYKuoIh+xYeMmdR9mZQU8+gl9is70MP58qqGZ1qBEWV5VwDaY7tJsaJfmIXsZY4ROwleuL5XS6+DZ2yBlER9o8gbX/GkGkBzCrU9Qyq5m3ydmI16uYNvk+hrkrEjsYBPcfxPOoB56xPrEBV12OWuY14TJeQNe/jjP4SCLqRIms9BugD6FIvY1xqJm/Qa5D1dzRu6jGvrKus/SIi/1vWdZE4iIr6Cm26iNV6FpFqZ1574zU96J6jYA8iGdfnXHwkOX4v8z/BgK/Z/yyO6Sxgt6JFb0JG56j1aWxRf2Cd3uR9oS6R2b9oTz5OFIlVrOV2+wR7KFJzauyeWZ93knFF7HQ6xQi8xqLo5bT6F1Sp8SH18kSTBKLHMu5gvdJvDPsd+l3fB/8L9nuCmHM9JpC+EuSW6nDrsA63htQg+QU0q+7GouyR6BRsQzV4lOPcH9Eo2Q/RZJnfxLQe9vrIV5NezByyei15JftkrvMBexMvBPsQBrU45ld64Fbm/ISUOckxqesbsnhK8l+nD7ievczxSeyWWBfPPHOU64jXppZ8JPniKactvSRr2gHWTB+ZHxh3GKNhK+rhA3weRmg/Zew8cQNdYTv5b+65aHIGg/odeuII9b5AL1EXW4Dyb6Jo7kUk0APEaa6RJi/Efrri/OS8yPOZdzrPcJw+MinOTWM0aKOm93ONQbTYjRyLGD+NLnuUz/vpo2QfZ5GS7/vXuBZ1j308L17mGQ+59+LjlNTh6uG32EcUrsSIHYMy69Gk/0RTsJ69XmPMfs4fhw6epFb7+D6NHOtJB5f5foL5p7CB/bXaITxtWzFum6khezIdzOtmHzHf8gGq4Qj12Eu970IlVPTpKCrB73jKfZf77V9h/aJhDyb1MK7TG58TU8ExdPD8ddgR1jTGb07yzorYw2fUXs7iFtT9CfI6FPyX0GS2cbyPej3C8zgBJfvv9uAQx99lnNwbJccFXaZ/DiM0AXW9jev3I7J95I+pyRB7JJsF9rTA2hLP0yPUN+88vYaI2WzmvfMKMvYS76OvkTfnMWruJOgf/b3jOj0a0ZM5s5VxMYvHxafiFXrT1Wh+Qaj/Yl0f8X2OOXezpjLHZS3xw3PMeZx3Uyn2Pv2XsNwTcsbp/1PiCfMbc6ooJ5x8K9FFv4gu3l0dcj7EE8u8Ymkvkz1NWHwv3pNz4vzzP05q5J1QFy/KeXGeTfbnHnc/Z3i+lLsrA4D+Q8LqLOHzf2pPDI+Y4J/XsxyX/6EY/o/oDd5Dr/c8MgKVRqefQsbhVeTVVbxgt6MmuWqc9+s4dsq61KCTPm7V7cA/I8KW7gAAAHjavZNZSFVRFIa/fb1pWZaNDpkdrcxGm0sbLZtnbbaysonmOSuzeS4bKApKE8UJ04ewtBy4DQhh1EMRlIKeil6CemiA6Mpqc7w0YNBbG9a/19qcc75z1voP4EZ9BKC0oqp1pazarhx6X8coGtETL5JII4NMcsmjgEKKKcHBfR5SyVOe84KXVFPLa97yno985ivfcCLKQ/mpKBWjYlWircL2ylZtP2oXw9NoY/gbgUawEWKEGRFGnHEjKLiLU0RTvTA0LV3TcjQt/w9aBU94ZtGqqLFo7/jAJ4v2XdPsyldFqmi1QCW4aNiPGxjehq8R4KKF/6LJF3kj9+WeOKRcyqRUiqRQbkqB5MsNyZNcyZJMyZB0SZPrkiopclWuyGW5JBflgiRLksyVSRIloXU1dY/rKp05zmwz20w3r5up5lXzinnOPGbGmz616VWP6jv835a7zdOaKA24Cpsrs/3jGfV3umHXHnDHg8Y0wZOmNNMTak4LvGlJK1rThra0wwdf/PCnvXZPBwLpqKcYRDCd6EwXQuhKKN3oTg/tp170Jow+9KUf/RnAQAYxmCGEE8FQhjGcEYzU3otkNGOIYizjGM8EJjKJyUxhKtOYzgxmEk0Ms5jNHOYyj/ksIJaFLGIxcSxhqX7/TTq2sE3rHu1i2M8BDlpfdpijHOEYx63qBCe1ntJxmjPWSTJnOWdl8SzX7SjT2T7WsEo9ZC0rdbX5t26t+EsHDzU4Wc16Vc4yNljVNVLULXVb3VUlqkgVW2fntfdRD5RD3fs5iDuqVG8b2a51B1u17iRB6y52uy7ZS6LWTLJddZb+d631A9uv07gAAHjaXVG7TltBEN0NDwOBxNggOdoUs5mQxnuhBQnE1Y1iZDuF5QhpN3KRi3EBH0CBRA3arxmgoaRImwYhF0h8Qj4hEjNriKI0Ozuzc86ZM0vKkap36WvPU+ckkMLdBs02/U5ItbMA96Tr642MtIMHWmxm9Mp1+/4LBpvRlDtqAOU9bykPGU07gVq0p/7R/AqG+/wf8zsYtDTT9NQ6CekhBOabcUuD7xnNussP+oLV4WIwMKSYpuIuP6ZS/rc052rLsLWR0byDMxH5yTRAU2ttBJr+1CHV83EUS5DLprE2mJiy/iQTwYXJdFVTtcz42sFdsrPoYIMqzYEH2MNWeQweDg8mFNK3JMosDRH2YqvECBGTHAo55dzJ/qRA+UgSxrxJSjvjhrUGxpHXwKA2T7P/PJtNbW8dwvhZHMF3vxlLOvjIhtoYEWI7YimACURCRlX5hhrPvSwG5FL7z0CUgOXxj3+dCLTu2EQ8l7V1DjFWCHp+29zyy4q7VrnOi0J3b6pqqNIpzftezr7HA54eC8NBY8Gbz/v+SoH6PCyuNGgOBEN6N3r/orXqiKu8Fz6yJ9O/sVoAAAB42kXOT2rCUBDH8TyjMf5roj6NiRTShau3EHqGxI0ipSAkIHiCLrrpVhFc6hW8wqQr8R7dd+8h7E87ne7m84Vh5qSuO1J7a0ruS1YodciLiWOyJ/LzKelXDJv8kRyzzCyy45Rsk1AzTj/t75K5owE0t4w60JgzakA9YbhAbcyoAu6I4QDViFEBnHdGGaj4jNbt6BvjAWiFv1Dk8V99VO+rZAp78gH2wP5RqMFeIuyC+lnYAbuxsA12LkIfbAfCIE7Plre+WlIGtxIo/V9CrAxWwggMF8IhGM3+mJM2P32Fb/gAAAAAAAQmBXwAxQB+AJEAmwCjAK0AsgC4ALwAwADQAPoA4gCxALcAvgDKANEA2wDdAOIA5gDtAPIA9ADYAMgA3wDDAJ4AjgBEBREAAAAsACwALAAsAGYAnAF2AgwCqANCA2ADiAOwA9oEHARCBGAEjgSoBPYFIgV4BeYGPAaoBxYHOge6CCoIagiqCL4I4Aj0CWQKDApECqwK9gs0C3ALpgwSDEoMaAyWDNAM9g1KDZYN6g4uDpAO5g9QD4APvA/qEJ4Q0hEAES4RXBF2EagRxhHeEggSgBLkEygTkBP0FEgVBBVOFYYV0BYOFioWmBbiFy4XmBgEGEAYqBkEGVIZfBo6GmwaqBrWGzQbThuuG+wb7BxWHLodHB1aHfQeGB4mHtAe+h82H1wfpB/wIGYguiE4IYgh1CIqIqAi1CMuI5Qj/CSCJNQlLiWeJjAmvCdOKAYosikqKaIqGCqWKzgrbCvGLCgski0cLYAt7C52Lu4vVjAGMGAwtDEeMbQx7jIYMnQy1DNKM+Q0YjTcNUg1hjXENgg2TDZ2Nr43CjdaN9A4ODhuOMo5NDlSOaw52jpAOp467DsuO4g8ADw8PHQ8vj0mPUw9oj3ePiI+kD7YP1g/ij/GQBpAUkCmQNBBFEFeQY5BzkJCQnZCsEL4QzBDeEPIRBxEYES8RTJFiEYARoJG5kcMR2JHxkgKSHZIukkySWRJnknsSiRKcEqaSwRLSEt4S7RMKExaTJRM2k0STVpNpk34TjpOik70T0pPwlBkUOBRGlFqUdJSClJkUq5TDlNqU9JUFFRsVOBVHFWuVghWalbMV0ZXuFf+WEJYplkGWaRZ/lq0WzJcAFzGXRxdfl3cXiheZl6oXwRfYl/oYGhg5mFcYopjrmRkZNRlLGWGZbxl7GZoZp5m1GgwaNJpYGniakZqomsCa35rrGvabB5sYmzKbTJtim3kboRvIG9ub7Zv/nBEcJ5w+nE6cXhxvnIKckxyjnL8c2h0DHSmdSZ1oHXYdhR2QnZ2dsZ3GHdad5x37Hg8eIp42nk6eaB55nooerB7NHvSfGh8hn0EfYJ97n5Sfpx+6n8+f5J/2oAigHqAyoEogYKBoIIUgryDMoPmhDqE5oVYhfCGUoa0h06H7ohwiPKJpIpQiqiK/ItQi6KMIIykjSqNtI4Sjl6O+I+EkB6QqpD0kTqRspIqkoaS3pNak9qUCJQ6lMiVVJXIlkCWmJb0lzyXgJeAl4CXgJeAl4CXgJeAl4CXgJeAl4CXjpecl6qXwpfamAKYKJhOmJCY0JkOmTyZmJmYmb6Z5JnkmmaazpruAAB42uR9CWAU1bJ2n+7Z954tM9knkwUIZGAmIUSRTRBRNlFRRAERxRVQQVZBBFFkUREXRMAgiIpI9ySAgMqiiHrV6xqVCy6gSFBQrztkOn/VOd0zkwX0vvf/7933/usNTCZh+lSdOlVffadOHY7nenMcP0Z/MSdwRq5MJlyka9yoKzgWlQ36/V3jAg8vOVnAt/X4dtxoCDd0jRN8PyaGxKKQGOrN5yuF5FHlWv3FJ9b31r3NwUdydzR+RVboZ3BWzsmdwcVtPFcqmSO1goNz6EqJ5IpIXJ1ki9Yasji/rlT9S7JHZZGUcrJNEN2So6pjp8ryzrGo3+c1hAuKPSEhfMf5fXr3O+/s3v2txNJp3ZS+5w3o3XvwAP35DWX4TGE2vw+eibL04OIcPlMXw2ea4bMNUSKZIpJQV8u7cBAS75KNBB5Nv5PNpFQ28qJbJrqqKq5jJ09MCBP4uuOzkvvJRZ+3uV8/Q9GTk4qeo/J14DjdXv00LovLI+dw8UyOK437/MFYLCZxkRpvRiCrMCMmE2N9DS9m5xRmRCVdpEZw5ebh23p422C22PFtYyRustrg3xEpPyJl1slBV70UpEOTTa76uNFkKa3pYdSZS2v8JqOpVPbBmz4/vunzmEslk0u2wq/aXPVyiJRKnTO3ddv+0wWcr9SyrduXP3vwhZTpquEzjZ7SGoH+acA/4Rk15qAJXvhdNRa/FV74XDV2nw1+wUX/FOmfXvwTfyeD/g78qwD9V/CZWdrnZGufk4O/U5Or/WYevi/0cPECSusSUS3ZObl5Zc3+J/XIRI1XhDxh+IoJMfzyhYQQfIU9YfiqjHnCHYirUiHBARsG/HPAugH/VI6XE0E5MGD9gOMD1vV744fOP5AHVhNXNXlYuR6/qpUfVivjyQP4Be+DVdzQuFho0H/I5XMlMH+PclJeRMqOyTpzvdQmGs/ToU7zckGn7ojkjUhFMdlpqQcjjTu9+COn3QyWWxaRzHUSF5VDznop5JJzSWlcZyuMRqO1OdSS4g5vG/hOynHJ7WBigs56OYJ/twPbcotgW7IuD6ybq5Lc4mZi9gVDhR0KM6pkpxfeFdHmK3JJhlhSRirKO1dWxHz+DGNxiZiRS2AZGH3himKP158hOgjpXFFeXHLDkAOXDF75wN+lO17Z2Pfhh/ptXvi3nXccv6D3sAGDSc4zA4dX/61NJSFjc7s+PWPuek/1KsO5Uler8mT2OY9PWLDJ9+6bOuGRyn5h0s7at+G74OQu5xagfeu5CxqPGQbq7+csnJcLcGHQ1xou7kMrD8EfcomhPu6H9RXn4Q/ZbaivNTlCvB1MFl5mldKXWYZ6qi6uTra66yWrS3aBHvRivaR3yUF4WQjvFrrktvAyV2RacllFd9zE+6qqqiS9KAWq5MIgqMVfJbUV41mhjCrUn6lEdNcEcwvbotrcWfCN3uri4BuwIVdIcxeVXn8sKrrCBQYPiZlJaz+4gEQfWb3qsSVPbO/Sfdas7l1GCZbtDb+Ql0hs6ZonHl1Svb1Lj5kze3QRPiVbvvrgwGeHP7hvIckiWQtPPqafcWIueYpsOfjR/gOH6u5bTHJI5gIObOzyxmP650BvOVwxF+WWcPEM1FkW6ixkq4+bUV0dzaCYGFVMbrBeynVJJfl1omzw1UuGiFziw7fkDrio4aXNJbvhpSdQL5fD3yW5oA6hSuog1pqzQoVOkFqyuaUwWpPsCoDaPG7Zl4FqCmXArwaqpI7iJs5g8xW2YxoCo6KmxfyqkXSujPFGEipxEE03lcRB0Ma6wa8Vg5oun/7E8F7vSs/uvvNRMmBAeX3vB0m+8tl9oz+7e3/D8XkTpBnKA9cMGNvjjBsvvahP/2Fk4u3br7j+wUFLnlmz8KaaYcqOsXuV759T6hcMGvTenhG3XUOu73kLP7vrjV3PuqFXt/MHcgT9NhlB/XYB89qqyybgM1P+WtZDZGB+GX0yumP4t4OUN/hy+Ld2sFIIVxz8IwfVrNFbLzvZvyh3V8YMvM/rzggX84MeWvjqXYsXz31l0VI+SyHbn96k9Pj2qNIv/iSphc87Ez4vX/s8Tvs8a52sS31ezO/2eXljuLO7opw/89VFS5cueuWuRYv1M55Wzm5IKP2ra8jmo9+Rlzn4vL78BcJRfR3ngDgoCREiOSO4DPBjKvVCTCjK0HuMVlLi6VtArmvzjxJyc5ay7uCOVfft+UxQ3ruWjFceuPa9LOWjsaSPsn0s/EP4zMu5fTqDbgnE1iEcRBvJCIHGBKsqGucIOirOYi6NEw5fEgF9li0iWeokPiqbIbboonGzBX9mNsKvWcz40sKZS2U7G1ZFSITI7guJYfFyMnMDmaXM3sCPWk/uVqauV6aReegfCNe1USALua84A1eEY6jl1RkzRiQelBWsl01grToIqJIBw2kGzEGGQeh6dv5nzsi0BBE+88eVb9hn9SEb+Rg/ns4/fJZMbPX4hdMvcxChhSz8bG3+K0K+PuQ42bhzJ/5bijOIGXRRxqUARhJn2NAWmoIMVc50ZHFHvz7n9DuvT59+U845f+DZvQcPYuNyQqD/ntqlH2wB1zGhBgHDYmOJkRhx8rYPE7+gP6C44KLGYzqHHucmA7BV3IwL32mtp6Yp+6wgVICapy2QXNoGiBDoDt02iBBmAZeuzwkvDVwV9WjuWNQtuvhwAe9xwersLLpwUV703Y/f/hP/+/q2O2dPmTL7ztv4l8mt5ErlPmWFskRZQcaT0cqXv54Ah5XZ8BuVZykM8BjIY4H4F9el5LFGJF2dLMAwbDAMQYcgyMhAEImBGZRXOohxKVnx4kGTv+cWXSXpc2KucO/qUYHKh+jnDgUs5ACfl8VdyPQkB4X6uAslNuM0ZkckQ53scdbHPQa0Nk8WGJ7Bgy8NaHg5CPmCHJgKqZLMYtxg86D/d7klOyggVkG68cwRGUu6ETppDuIkvpBvKLm++tqOt1w9+JGrpk06cPur3/VetPYn/rH15MY186f2GTmu68CHrrrw7Q0j129a/p15Lx3rhTA/PIy1mLueixfhWHWW+niARjFrfa3NWhSA0GWzwLBLYGXVyQXgoZ3onrMC9XFnFgUCVhh0Gxy0rohFcqsok4Iq9MRybl4V9cW+LPg7gKGLRXSYOBCilFTE8jVhOrOQZPRhaNeFCi4c9vrlT1bHd0ybTgZPumXwg1eP30W4D48/vuiZZ5SDyu/1Va+37zh11oTrtxwZPrqs58rFW564K55n9D+94M391PZAHF0P/SyYXzc3htkejc+1nNUMARmwsMxZ6ykQ9lAUY4vKJggxQjRuom7AZICJMVPAacaJ8SIGNUNE5p0uGnmt6iTxouRE26wA+4j5wmAjkAiUV4YNxiL+zv0vvbRfuYBsNBuzziDR54VVDeO2K++Q6HZy5YtTug9na2tC4zFBAVvM5mZwLDzqYJU4cB5Eob7WZ85y2NUFk0PnIQABMJcB3O7bTxRSXOsoc0j2nXpZzP7DIbl3crLdXVZGauwO0a3CSiIHjGDOOHyYrSw2W2BixAahMn1mQjghHgScqonBfEwY+ObQZauUHR3mRq/uzH+aOJ5fMKrvh78p3yiJb6veat/xnrkn3dYz+effUNYYnF/s/rIB5uAysC+vfjGs/kK0MC9KlgUWRnGS0VJf6wh5ERw5EAMUUVcAkkmWqBSgWFIW/fVyMSKigOiuNVp5hxdDvCjKeh0N6iCDzAGMlByiZKmSjG5Jr+KeDB+alRBTBQCHUczTeN6ZGpyDXMavur5fv1EHD1psHZ4ct6Put48e+XzK1w/eMnHmbbf1m96XHyp0EV/0/VP5dcDQo28caOQeIL6L79n68IKp93a7icYysC835DwGQNBxyINKqbMW6tHro7vnIH+k6IR5aRImfYW/JT75mS/V1exdebJQV4NzL6g+cjF41TDXMamlTJMKj8pM8ImdqGoyEBLh4iuEFxku9BSyCC9Fl2TDt0vhdWkEcZIchR+VForuTWbBmxlygNI4uSwTvgfsI4batIJ99HTZaaAHlRShwAfQt4Z8Lpr78Oybfti1t15peGpBI7fvq4ZPFk2Zfu+s2VmzJpS1Gzxq4sjbRo+aRMZM2t5vwPobHt38wrJP7hiyZcLz7726fcy4W0YPvKPSVjmPvyk6sGeH2ITzh4wcSdcp+iAbyB+AFQvSW2iMMKsxIgxeyJ9tEcBG/GgjxVQRQT9NCvNgAbijshFcdQnmFKBu2WYHY8gTay1Oj1+gYvsheoDrlLJFyV0lhd2ykUWScogkAF1cXKigpAJF9oRToA/kL4NvDBf++tHDn09V4op0R5ehQ7/+wmrrUn3Dto8OTJx8y/JekwdMul14fj/RLVGO7lZGK2OdLwV+JcahA468PeXe+cMvfuiSZVrurzsLYqCfq0yLypBU1TrUwJzRlACQRO2VHGgRnsXylpF68bl90wO2MPUBZAIGUf0iNlkOzzdwIncWB4ir1qw+1Y2upNZGH1Sjs2E6zYN/5yMUsXhUxBI3mJ1VVSnUYiWpAagA5mr1+RqQ0T2TfD7isw8Bn22D53PgIX1m4rtceDbRg9/J3zyRfPSislk58BKOczRZJSjCm5SvyGTIB2AcogtcAaYIchIq4iHwNVp4vGGM8DhZtX49mfXcc1zzZ1VWmAk87nJ+Z6KH8OyHL8H6O+9FpXQi1Ymz8SvhPBqjaeSj7igAwaAwUpurKgfiXXZdbYgpxxHKBuXY3TTH9WHeBmsMYp6MzrWWdwdyCzH7Apjojls8ZhodApCbxPX2LAzeECE4tLnOarw2OiBFCmNGq60toyelVecrn794oN3Qay/r+mL/Ubf2unHM5cvPu2cRznTvfvrwTVtXnzvhmiHnXD6wtNt1C88fftU5gy8pLzqpPNC/T+/BAxkfc0PjFYap+jlcBdedW8zFy3BNxSBJ1fEsW631dInpIAbmx2SPHpP62uBZ+IYc1IOue9BFVgrouNQl+0HKzpCldnbJYUbCyD3h73Bn0d3DbNN5giVlHWNnMgcTg5XWCXIuUepYJZ/VRXRvNnEuvzNcik47KErZbN0VxqI6N6oBZC1hi455oQzB502uPR2PazNa6TOE8zkC73sqUVE3fExu//Fd0qd26Iqx50/w2CL3Dl1Rc/z1fvE+vjH9h837/Ym3lfefIO2I/6PDbx4D8HcrH5O2iraz+kyfz8dOkLv/vkHZ9f78Q7Mu6HP++W+uf+23zAylZ8ayVx9Z+/vdzyivvascVT68ZOUQMotM+IIED7uepPpEEsCrnw2W6eTaM1QnCTEKGGsNJo6A5gzo+V0RxtgRk8jgWifAxGEhJHhCQhkpMRh5+wne/vPCxDfz3yLL5jijlsyofvaJWWSeMo3vT2YWry2ZvBBWwFaILesADzjBK4a4sSqOdNnUyAm5c20wwGHkDCImKKAT5oLIGYxKLhdFKrbMeikHo4Ie1jLOXI4LAbWJmia8lGw4JQBowDxDLGxCopOvS0GwcFEKpakvtpJqUkD4WZOXLlB+/1b59uf7lzy07MiB++fe9/hr+hnPbJn+pM+StXbhS3W7xk0ed9324TddNYyuy4ng41fCeguAB4r7qSyCao0W1FuQCmDPrJczUX0uP4zPWyVZxDhnpOhXh4mTZjwZRrQPMA/w4J2ZfUx8gnR86+MtF/ZdeemeQ/veuWzdZWvfU/6mbOZf/gc5d+PwHQUx5chviqL8Fs7e041MwjkFHesjoGMTaLkLFzdxDKAzDTtt9SotK5tBrWYXTQb0MEA6v06AgUmVcSLYaUksX3SFwltJnAwik5SZykNPPklOKm1ALcojygvKWuX+XbxAfmd+Cp4tfED54L7q3JpBH2hOsg7mVs9MSo+DsCUHgakqTWPNgLghf2U5q5rAsSSVfW0VMhNv8WLie+QCdit37lT6vpJ67nvwXDNlhLWchz7TpKfPNOF0WNgznenPhNRZfaC12QO3CgH2OHxYv1cSO7nknDfAnGdyU7h4AGV02NSoDg+pdXsCGNXd+LwsRotlJmkxH2RHLh8+1+WGJ2ZrXJhgQqAq+UTZoEdDdgAslHxVsseNONAKPzKJYCiSoOFAcCAZRnAbHDWWSjEE+Tw4HDAYMo8M3f/q4PXrv1ROfntgwkzlAK+fVX+Pslt5ClLHC8msi3cMUg7/ojQqP2eT6/YkerQrIFNVHeptdO66q57AyDyBpI/VChaqRUFIzpwVZo6PomCACUGfshGguzZnuGmAOSUo8TB/9+HDian6GYldfPcTc/mpibuTc0ZW0bw71Czvxo8X4NPwS5/8xK2H1fSbI43XK1PIMvi3Nq4DYFQcoyUi8zg4O81ycSwONGjewjyCngUqI0CgCvgsDEclD19w5kuH3351RI+N3uP6C05s+firgDouXT18tgNQK9ODRdWDIYbEDo7OQYWnFA9Fw7Jgq6piw+xcSUKckYSIEUY84goyneiVB57gc5Vflb53gxaunHg92aUMfqHhO37G+MRPKfv9EZ6p17wwalrVh0HTR1ygFivowXKMKUX7QMVD9DNO9tuT/CwD8mxebpj6WUZHLDmTRPLRz/N66yUvnTvZCLkIRkMvCuISqbHV8HoHZR2NDHoyMeOCzVXFBA1BAEDyqNxdGQYIEnb7xK2kN5mnJ0tI7wNWnUkZ/jflOpMIA3tSdwXM++bryODwyXG6pcrJrxIXq/Z2PoxT5IY007MpRjEcjFL0YhZAd0ksXgbdxCQaNooyj0vDAurXaUNMzgQMsJjHuQ6RcIYfR5fBSwbe9oFyODHQpHfAwNb5iW8g/8WJuboR3WoeTBQzjAHrW/9Ic25H0LgdIcXtZKW4ncw0bkcwJ7kdzlClrlbmTPO5dJ5nIrmEdCNV5GLlWeU1WJ/rf37vnbfe+/tbf3+f302Gg7O9S3kG/ptLppLLlAblF2ImBsITq/ILp/p53XDK83i4XuoKoj7eA17PbKVRlBIzXjpcC5isNSpZXMhv0uDpQ+v1WMUmQVIXCgdJKiwuJUZiVL5Qfl0yTVr74ApYr5+8t/9o4if+nelzpkxh+lLiVF9OxgzZUV8eTV9BgTFDGMZBXy6Gu1BfmOT5IV7XCFabGS3NgJkuDMgOAzLTGN5UfUhfo4drVYWvbCODIS7+VnQKPTZyypN9lYfJma0pk+myjvoTHzdctUZTjKnTB+q02qk6rQhK/Elmzx5FAxBVdWagcaIBWIxsW8MM0thRvUb07GlKdulRknQ1LyJOYlC+JwuVk4p0cNUT9y9f8Yh+xltvK3+MTzzId0r8nf9+8qTJ19L1ParxmHAI4k8hdy0XD3MszDEejlpnUUSy18kBCHIBtnLynYxrCKBmrbhuNuksLl92GLWe7467PTkU2OvCjDjxiTXE7snHn7rckFumM1slamJNg4/Bh1l0Lk/z61GjPrninjsnb9u58sT7b+7tt/3B8beWXT//sft7Kz8eP175aYfysZcOHHf+wL0LpTeHbR905eDOA/tU9ZiwcOT2j0CmbND/maB/I+4iG5LxmxOQtqIbuoY6WQ8uUE+pRb2A1KI+SS2mMih0Sdm6POWqr3Vb9uw52U+3hepsA6xpPfU1lVzciTozqP5VMiedDbhYSWAuEYIbdTYm3KF2Uo4Uo4Y/lg+zJnpppN1wuPpp0vvruxokmLTPyE/C/IZ7nl9LLhImN9y6vH4m8cJzObp/jHYFMc6GcnHaM+0RFqE4m7oAxRihnEQlQuvvSFFGuclW7iJFxxXfP/UzGh7p/mrHfjvLhKvVGAifyRk7U26tgXFrkhijH19DTGbw3THKqYFcBHJfwpa9K0Wv7froh7eRXnNInEvK3gm/IfE7t5115PtX8V29ZCpzSMadcobnDym4c9vu8cfnsvfN8L5lp+zL+UPy7Kzx+jye0m3dev8Yg59a2b5xhqc0Dn/m35t/b9gAeWRVHH4r9R3Xw8IbLZ5gtteXEUjtDpMeNt5oMrf8gcrwOQksLTELDZXLglCks/lpKPLEPLiHVUn/7gx/QV4CKQnkokJYsB19PeKztHN/9dXRgiJH5etHlCV/HHeVQQR1HjmxCbT6zp5HhrzRXShveP2Wr+Z/JHQ8MVfoU/lO226vdmzYwe+getbBHL5CcVFxU89Ao6ktQkGPzGPs0Vlo7DGTkJmwP3XkPWUA1wiRsc/vSj/yifK7Uq2s5D/h1ySO8Z7EpYn2fLfEbvoctJWFFLcD7jAmbUWAh5gpN2qAybOg9zSCxfCoB/YCTQeeR8D0T5D+pP8JpT1ApcQsfnbDmsQXfBA+uzt8dnuKj8s0TKDlKQIDxhT9ykbG/Mo6QWSJSayChJCYCPm6868mBgt7Emfw+1bpAntWn/xWxRtLlTf4S+nahbXFYLepHmkOld/ArRljFmfBWoyorPfWa98JUW3hAogJizHfUvLqr78qbxhqnjnxxLMt92YETSdpezM43c6PeOuHSWzIdVLeID/R8UAuwESE8RgjMqeOx1gHj0YeCgdhcMnEA+sDPIxLG5hR42QyAMMCsA51+vVXslvptkg/6pk/BuAzsnlep9PPodyTCtNUcpTuppCwmWST1ZPIe9sUWfmU54XZDbP4xxLXIHZtUN4RBjcOApkycK9QBrSJX2lCGcGP6YSLGp6TZ3OEXK5bJ5TpD8LcteHgKbgHZ0cihyYztXq2a0ZnjzfS2evYiVSEwJX4wmXwr4mhcGa7R3u9qX/He/bGToEo5aSGQgz5h66K8kTTGTMbD6JZ5Jnq406CqYypvlYoDDoR9OvZNgm4kmxwJdkuuYAhfreTkUXZaPtWwF1SgRh3Bk2YyrhxT4ST87zwIx+sVKkQEThzqBCDnCKgckrVdidNd33EcEk6X3kWckpDfz6xZeSYCx7u02/oO8Pf/Ht1mXHA41NXSN9edPG0h+5Z9QDpuOZpo6Hq6qs75ld3iMgvJSqWXnnOM4/2HTB/xuUGw0iQtxpytjH6OkBKedxVKlaiYSDDUh83o7zZFjQCWp2D6NhJkxsAyJlIOQRo1Q0FyHFYfShfpigjfcjJGRwt6EAaFvIMs7psaI5hjHXWkEpJ2Ohh/CtWJBirD5p4yw3vv/bZF6+/Od7Zrmr6gikzfr9nCq+vU1a0We5bCYirAaLKgQdm8r7dz79cS66vfhHtbjTM22KYNx/yDR4UwI67jnTCUtgEoB6iEUAfHhibC/F8nDMg2ZmWQLIYni/SUgAfapwfTQy/Pz2v931XKN/dO/eReV3vHf3jCd5ObCS/2+YuypKamvP3hPNIEDlN0Gcb0Kcb9HmDGtlcOBy/RR1ODujTnNSnB0Krh2WKwahscTJ9mmB4tYLD5c9BrGERIboHKBLxI4yyO2C8OWg1MGpZb0huk2bEihHXg50YcLeUqrWSGdHog3vfG2d1HZJLrDe+/9rnR26/fcEsfs6CybN5kehJePmtvcicE+0WrCT5hJO3rtiY/8YzuzhVHgfo1Qsr4hou7kZRrGZVlCAsBZ/JjVm9z5iEsyYQyRfFwiyKaP0qojVhlmR1o64NouygJmJ1UxSBObwD4JWbcaY4Bf4cEqLQis0A5wlRdn40EQ69/3Oiq37F/SNWX3HhMzf+rtR/Rw7y02+4cTZvhaDSrvGLacufKmy7pU0+QMlJc+++h/m+AsgjQ/ovwD5GqauaLmY3OuRonMfgZY3IBgszFS+tFvCArTuicQ+tfvKIgKy8dNPWi8iKmpHTzfYDrYhpJYNbMtG9n8o0JAhyUOxV8Ly8afLErhf2H3AOEZTEIWH6def0eXFTyfqskSP7rG+4S5hO94b8ShtdAei7lOvCnc29ABrHYfbUQU4aZUPuqa+X2kbkiKFe6hyRC2z1UlZE7oqeqHdEstXJVT4QCWnA9uC9q1xSHq2tcdPamjw3viV3Q8zrq6+JBrqZSuViyB/7wDtV7dUcTe6WJ7o3ZznDbSNdeyLLHYhS0oWTO0fgV4o56s+wCifLLRtwv7crlb+nO+4L2Cj2yNB2mpL7TRkhn5GWcMGSB3jsP5Oou4yp7adSUmCgRstM1j9jfIczzu514TX73uhwVZBM2BwMHdwba9uv9/Ct0mblY+WbT79+c87krbVXzVt/5S1XXjPq1SuvGj1GHj0v03NxpOuQtuHqGza8bDfMKAiNrlzzorFD16LChxfVvrrssX6Drr+kz5nDhaIxN7x37YTxzD6qAQf0hXXr4waoWMYWY/5PVP0f8yA+5v98LgQ3ss3JshsfR6GqZAdN0yTXLCaTR/B3RtyTBIAcFqlgPrH6oM1ZtuYmcufBq25cfBf4trsuH9v/YmV6oj+/aPrUZ19P/IhrbykM7AH9S7SGtFz1JXZCC0llwcHoShutxXM6cVubJlzOZBUFDSKp6lEYyNJe3c7s1evMbr3sB/Xdz+rZ86wzevU6cVJXfHIf5quNC5U29Hk2LoD5vZ6o7BEowB+RXQ5G2+rqsEzVCE/0RGkQMGLBhMuPYjcjlYR0UomkDWZiz973H3xu9TVnE5M2JOWf4pO61ScHrXkmYGhUx6bOy3BaP3RGigsx4shIJMk5OTXOSXZQsEmZQiN9mWSfjLFKhJ3IPlV/YTPcQXoSnXIR2av8pqyfoa9LlLy1igxVuiRWk/evUZZqNkHmwLMF8OXs2fhMlYWDmcevFAtXfVBfd6Kd+u8ML8MaDnMTVUwpZiLPBKNmQ7fH5DxUKiRwhfTTwvBJvKteCrvkLJAiEwTKZASKCD8pwt0XrCTSwYoTMWnOhFzaTOssJDvSO3nIFujMFrrLC4PJoJvgGTENOGh2lzJAOd/a/umrfxnsjKwf9/LzB68YPWfaoctH3zlNV7zg/AvXDbp05x6wxfumTVn7TOJt/PvZ1xLfJ9cJyObhBqdxU5pkWDCq0SoeVSYPK9DF0Ib7aB5VECsKAkNHNghJqtS4mywUGGdH+QYyExbKfXPp4LRV8sxeHJEWowbBmJCjSPJSWrj1WJLR347MBKMlDAGVlrAneSlPes0RRCDO5+LCBWWk0hVCoh9jj/nHw8Su/HL8oa+mHyEuePnj4jt4H+FJgfLxScAl++c1PKXcTyaQGymWrAZfPobqKh+xgF2DVSl1IRbgwKZCmsbAy8u8SJWGSwvxSoGqtLieFqEgvjJS3jHDrlZ2IBawVEmEWT7NyP0Z6QjL7wuSVCGEwVe9xRiwXffha599uffN8Q7H9AWTZs2cNm+G0kav5E6ophALhHng7mxlgHBs9/M74/EXVm5QdQ0ytaF4IJ8br+KBDMADJpSJKjwXZLImZfIhGKAWIGVSfIM8mwnCkClCJbP6EOm43Bm5iHRM4D8ZdlSBQS5FOSZ1LwgxDkhWSYuyOlcylOOiWFgDOWNWdjcFXjxkEuxj9r36+ZGGxTPuWDx1FoAcgRSdd9GCEzzZ3W5EcCUJcY3K0jXrwns27NTWutAe5HJxXTXOPTlLNjuYkMioOmbUdGm6mCWDDdta2LBGA4EB51ornh3du72/Y/ndT+uKt48cb3nfJi9KfMTizgjArTfAh4TQQmgdCIAqFbeatI0+8BSyxU9Vl6WWyOD+ngWjTj76hE2Cye4N5tFKGQDiDj0Fi0EvKx02iTWcQczAn2ooN4lPIBJTngo9dAUNvWWkpIyM2P/S9nX9npsUv+LxuZPPOPTBh7O3V79Xdv2ILXcKmfc80v/Zvtd0Oqdr7KLxA5Y/1eOVobe3rTijqO9ilKeo8Rj/vt4NK3GCah02sHi9Kg9iLb0pSVQh7FLxVnLvyauVZiL08prT8ZZs9qr5va0JbtSz3M5T0Z3EfIi2ksgdXEnR4wMWkDLl/SG9hlxYfFt3ZYcwfcyQL79bn3h9yMDMZ11+MoTvCuN+FHxID10x2PVQtlLZ4A3qcgUvp+0PgNdHMgzPS1iddP/KDl7OHqFo14xZnBuBAJJjsgGXKELdJE0Ga5AhdJrJPXpozA2L7zoUz7dGnh+/62Uygd+cuHnatGdf58WT+xacd9HOJP+RDWOzIldmpbk+UTcDNJKFs1JbRMLDg2ufsj3HP+liNZnP+OQH5YafdcWJh5eP6rOZvx6DPQGfxBk6wWfmECcXz0E/7o3Rj40Ti5uexshlFFmAUmS0BBtsP49RZLtNPxBagca5pJydDo0ik47/xIgzg0sy7ZSzLIwhG308zhgyC61XkwPwvn/ntm4X/ngr5cYMrhqjweQp3ba7/fe30Xcsrhqrxe4prbHhn3H4aRpnBj9JfQdog+th5U1WfyCYZTDa7GXpxJmdN1noT3Ka/UilztyEbjuD/nIQLDiStFmM8Wa5RNOlUCyEeaMQ9nxzd5nHYClxrP5thaNUZ3JUzD+kfJiYH+xl6pK/+A9Q8y+7F5yzuQMfSbwX2d35to9468l95PtBJE9J3KR46HwGYD4L6Hym82bk9LxZFqKXsJkEyCTlccL/+DPhlOVkcqPyh3KSz+VNykIyMfF74iBZpNyKNgN+OpfacymnmQt+tIjh0EeNlaOkPC4gTpR11EhFVXaQmFeLpLqTXz/p5DKZyg78rJwxQ/n8/L6xnmt6lYCgT82+ueJhfvbJAcomV43tpTFUtp7gR8fCc9P4NPBnOsLIpr/Ep/Xkg4qJ/yXxE5+zgD++YWWiaAPzlaXKG/zfKK97FRc30fJacCkZESwUo9VDFlYtmVmHHIzHS8+ueDJp9paBR4Wi8UyawGWiQ8ml68aPp1IyIYYSkcVSM2TUdmoHFbhWwVGCI/EBhvcBkAJn6YOERiwvvXPmu+/edNX+/aPHfbabvLbl0mGk9KHFG/WDByoHdxTZCnYpXw4azEv8g2uIG9RAyGtKlL9V/z7ltpIYEgIJfjEMScAvkNc2KFHjE7+PSsr7PMibi/I6UV4HyJsbkTkzExvlzcMjApIlKmeBvO5oPEtACbP84F4FWq0r5FJfKuejvBnUqLA01y/KJtyOcQCUdNOUrRuBMNq5sqIY5CsuqYhSeWM+jGJeg7F0+DXX3Lb/kuvrtk+bctuMHe/fTc699OSkmV5b0Q6SO3CwfuOD65TvRl2wZcgo5dOHF/K0Nosv1BmEPhALYhw9lRDDGFDjMTlMjHq0RtH7s1Ta46CpA7wvau6cpo1+teKjoLiEnsUY+UCPmy+aeXF0SperF3SbcsG0Szvexhe+MDYYrjizy+YbcgvKq6juVkFcfVt/P9jKFI4SeJTwjFupIZoxW6rNEIPIXGRYAWxHtS0B3L920OM5SIUGXNzZulI8WRAIoi4DPmY4ciCIxB49zSRm0OQYAG2cM3tVKsnESle040t0R0iVhB5h4lfteu3RJbefvXDMwnn3zj33zotuvevhvTv5vT8TT+6ax/VnbKravG3b+pzwzi76bTtziY2dEwC/0U6/mMvhblbXVpYA3jlKTxfiyq41GDmbHV25bDCy/CKXJmymKN328oAc9JRXIAdrOwJoJLoAvqHDFZGHgkEyJ2WhWEYWYm0iPYgYq0DzCFfEUtQGZTaweCjk6zPistrafTu2b+i3fNIecrsyp/sAvm57zqwb5LW/1r41aGPv94+u3XjJ9FJWgy6CHIPArv2YHznS+Pxal+jg7LgLJLv0aB61Xh99Qx+TvfCGMUoLJx11WARq99XjirY7cPx2LJAxROMOO37ncMF3gKQDar0e2xPwqXsCHronQJEC/BeuCNH/YuJ3pJyUH1Vm71P+SRzKPz9RfiAu5YdP9DMSs/lZieIHlj549OiDSx+gOJgEdX8XbtZvpHvhEazxlHwxWbDXS84o/qVthRsAtRlYKZHbT7fCcaWnZcJFaa9JsGdZrOtZ0bKeZFqPsthZ3TuV9dB371p+ZkXsrMoq/Lu8ayV4kFGNxww6sG0n5KWdubmMGZC9OnXfIltXX1teZsPivnJDfW24DX0ZxtNolZQZd7Hzny4X+gS5VKRVf6CrWhM7aNQF7aBUdG+xeXXZ4aJO5azWrxz0F62S2oibTa5APlfcCQFl2C0VNanx43XhgkK+0uvWxaKFeECoEAv7MtK3RlNLetROMng3fm1TpNf3KtL221aTYPWTJFC9Wjn8RLVydO3xD16aO6f7NVdcf+vY2yqmth9368vv8i/Tf6VIu19SavbuJf1fflI5Ur2G+FdXk+DqJ5Qja94+dvb8iuX3LHo0x/topyM0bxnEjRF+E7ZyBs5Oq1IzzMSo/jWIXLxa+ZE4Vw8nQ1fjpK/m+SBZeZkiKfEryMrky2ZndbgmJ3HApJvMS3uugnuytZkp7UCno1RfHy/tgMZamg/G2iZaW1BBf1CATF7nVuapPcxTh6jU3iV3gu+K4LuiJrNWCe92ag/ZlM2b3U6Hc1MkyiVt2SmMNjCBHWBK4ZcDXAn+sEL8SxMHUQnN04inUFP78n8+b+Tsk+sef/DQm1uH9urb75z+Pf500hLPClfNmbP2TGUO6a/Uko/P7t6nsvkeDxep1TXZ4zEk93ggc6eMGy4vcFWVIYjaRnJ554kFxBDd21u3LtB77RneM7bFGDYiy2DGRO5MtQrQaKjHg2k8bja5I5K+DjE93ee265FOs1BCiWdl5SbMtgErsYS6pDJGeU2AS+W9yruuH7ykZMBQ5R/dK5RtjvzSIYFVF/mGd//IgTY4IN0GK82kkvhIEftrAHEqP1aTS5WniZO9HKas20UGksGXKaODyugrUi/ZGQJan2os5gBHccGWFaruVIVqZgSTRshSMWfKSK9QTe6FtaxVHaRtjg1qXrRqdKu7ZSdv0apXm47HCzG3xXh8qfHkRBj0IuiPM5uMp3NlDABWuBiG0nJIoS1n/XHW1mW3jblqkqf5oPTfBl6++rptgXPGXnVew5WpcenYuAw/wbg8XBZXolXWpkbm1UaGGX5RTLaCD8+DONMmIpkADvgpHMByxALw33hU14EbGQZCI322KAWrpAJ3XE+P7IJQmKEG04VqeoCfypT+Xkq+6zXnP1qTblkyCKhiGuaowaCBV2Xk39TCAsc3KpDTLaI1xB6s1bHREyqxJoWmEDhrHS4biuwQsOzUliw79WJ1jCRGk5WnNJSaefBOFq3y1EfjV5ikKk/hS8ByN55foNMl9pNGhfCFDb8q2ZuIlSyenKxGZfXO/FhWF9VGrQ1ux93CqoNrQzouqCtNFgiD+uUsXI2lWp0wMneIvIphYbbH80F2PASdT0+2SMXiJovLrysIs/MfWAWRHy6GGZEtWKDPGels6cTTlxSTFiv6VEXG5K6ma/0URceJS5u6AFZPJXxgxNzPx13wZ5XA/j+rBKakiFb216wmOLXVnVYdnDg7ueutzUxyQbcYX9//G+NrMSrNOaeP6kPNTydHBStac9jNxhVAhub04wr+ybgQPmaqqovb7IGqVpSX5ovSR8qlvFD6WJPeh2O1/MIH4HMQG4bxfN/pRousUigmO8HtZCX3A04zdLNLcuOOng08E+TzgCqxVh2Rbq6fbRWYkY50+lrKdArYmS7eea0gUE3MpPepSvM5L8Afy2FebJyLK1KZMwct+xBptR3WVVGyFEvsLDgkoYmbh6T33JRKrzucrssTPq12RcCozQ+jOsVqymHabhhrqyIFGfb2ROketK1OdgbqawxOG+SZnJ9yAwDEa1z0Db+6IW3jtO1OPC8me4KtbpkJ6fhcU84Lhws17SSV8sdmHCz7lupGYPWy1GYzuBCuplYqZgtaq5gNqxWzNYI5kENd2l8omk2trFOXzxKnttD+rJCWb5u+/prKUngKWYpak6U4TZbcvypLEyhwanGKUpbzF+RJW6M6Jk9yjUbwTFgLiXALo0NMzgLLKgHL6pgunrrgsFNFIbxsBy/bpYRGhF6YC0KbnT7hLwt9ivV5avkntlytf6qHXc0XMc9qQGFuRVhZvVurAs1urQoU15CAa8jtYYXxTm9GEGVtrSQ0hTWbFod+pYWjVqpEDWJaXVZqjLm4Q99yjHmtjTG/2RhrnT5/Jt1psrrlgLriWxlsmvU1HW88ZXGtjFh3NM3IBDZmsDGRy+Hacpe3HDUegymJyT4wsBAYWLt0EdCUAv567Vh0oZ/2itEEK1VPSLPtslaFOIU1NZVHaWlBrcilv7OF56d7Zo3HdH/Xf8HFuAfVPTN66CfXVC9FIthWiEjlVKSYs16KuagrsPspksOJ8YGPNvrywSW3B5HbR+jZlAqEeDEQLAtJWbtYq8sNt4vgjLWnzVzyxbjVQvdBjbS4zIdnfDk5l6PJhBQR40bsPEC34pI9XhyA5vx5JLnPhYVFyZLt5IFMn1j929efnDiv+yWx0s6XX3ph6Tuvbr6uy+M9Xug18ZYxPXuf2232DVNn60Zve7V6Yd87OvXqkpXdqeisrsNv7L1ybbcd4cgDZ1zc95zJg8+6OlY+pFOfgddefXI12ACtJ4T8NQuiY0dudnpFYdsmFYVlqYpCdva7OFgvFbsQ62oVhXjEG1aAu8Zqy6aFYe3FTc5grikcwm/UusK2ybrCsn+1rjAtIfzTCsMntYWbedpSQ30XLVtMFR3SeJLSSxuwn3npemnfRC+dUnphxtQW9NLWhd2SNL2gzbRN10tE3OwM5uWb2hQzxcT9BYU0PWufVE6nf105aU5B+FP93JRyFKfXkE5MS13vTlOSTtXRRpq3RrluWA2W0lJpEy111LSEQbhrTM4Dl9IZXEp3qrI2wfqa7DaciSaxUhuXXJZUXk2Vuwzej8H7sYhcBdioR3rdqlzQBvSaFyyiB3pjouw0oWW55c5d4e8qUfbSup/SpF47/st6TQdcKbWmg9VTqPgFzXfFNAX3Tfqw1lX9jJY+t9H0LGxMw2ugb8OtuiquGFZqJVfDxXMxgy6MyQEzmFyU1V6JMdzRkiqitZ38uXZQeicjHsWQOoFW0Ui7UI2XgJGWJBevH/xbp6jkd9El7AUlV2ErK06llmAdx+2FRnRqfkDuIfg7KsbFQC6+43XLmVna6XIpCzduarjMEHJ4srETOxFkF2UL22Rmig4XMDVnYA1IDgm5Q2oha7HW5UpTc1GIzsrQo9/X7rp71bkXvzHym5G3fvra0cTFZhKQ1g5Zc/2893pctnXhytpvV02+d/ZD9/ILyd6bx9wwk3Rcu85o6Ldt0BMdIg89pCj/mKa8NGBLm/xrr59y2YalSxdMA+1e8ePti+9iNSNqbW4J5vtYnVuby/J9rUAXzFYOYL7fJnkkSy12CLsY7ZJlAUP05+QWUdZZ3GSye4S8fIqtPBAI4zn5Ycz3TXgGnzPQCCGIpynp9bRI9lsr8v25WZ7fsuY3UdssxxdYzSz4Ni9glSLcq2laNRuGBZvHqmbzjMkOF1g1m0erZvPVqlnscGHitIWVL24SrO6MzGx6IszdagFt3ukKaNPYvlOW0j6neXX3KWtqdTtVj95wjBXXpsuLUe7GP6sSLj5FlXCJWiWMcmbnF7GTbzUOZ6iAzvK/XCvsSSZEp6saviKZEbVePkyq0xKhdFlDELkmNZe1GGQtYLIWoKxtk7IWUFnDqqztmsxtWNwMMgeCOSE2uSB0VnYrQhecdn7T49Opp3hKKjAVnnKShWWpoJTYz+ZZp8q+kdZ+lUDUrm4ufRFIH2LSh4y4Uy11AucJoag0qkVvVEUoWuMzYTTKgqhjoocmaH5eZiiAN9v4KftX5meBPQssQkZXKLURa6xugdpFgVsu7QSr3VAmtr4SQqfTVBNKlioqPdq0prRXtVDTRlUZ6ZNMuFqukE5qmEncDprj0zEz3/gE/DEH7KcJX0LS+BLnn/Ilo9L4koO6damZOjlMLeXlhMYj8JwedH+yCV9CTsWXOP+DfIlwGr4koGlt68FQi/3MEydwsOxbNf7SOk6qGx+Xh/WlrVRy5rdWyRlSKzlrBbM/M485Djkr+y9VdaZ7idbqO29P+ofWCz3JoRb+gckQ5ApQ71SGbE2GfJQhTGXIDNAi31xVBmQRMjntdEcueHuX6AuaVW/v8aIw+dmtC9N07bdarzo3ZTTlpyhdFbqkLfpxyTpWnSrTRloXHuI6cLNUqbI0qWgxc0QqjYHZQiiPam1Pg5Dh2YO40j2sf1MOE7amjSFHBaMFEVzwtPepJ6jWkUsFYo1gzqITmeOWi0pR9rysU8ieboCa6E3Xc5oaXtdMMl9TArksuZKbqeNdbRk7VV3w01OcCa0XVGP8VaesGMw7fcVgkp6gUcAs1mjx3e7+S+WDqZjerJBwZpJWaVFRqA+l6P4mcoQwcp9CjoLTyxFuJkdtMpZRQbA9IFuNfy5QmiE3k2l0GvXSQirhRDq9B+uQycViVXvu/lNIhiGqHQtRhWC1HTQxa3yCFp9SAteUWM3wZsiPxKBc4k/XQBlGKkh64m6G2kO0KYnZLRe2q/rL1aCnomyaKeKpVjibFgrRLWlZN0JrApM6Gd28LrClMnx1VAVZLuphQWImpw8bZHqplLQrn1SCBU9/tZxQOIWUrZYZ7mkpayuVhy2LZNietNIt2cMpnxuh7vx6Yk12gLGeLqivb9LUKRSRXHVyhosV32e48FC13sNqqjELy6YyuiAtO3XfJyyliyHxFIuyWpdWGkGRXv0uu69X34vbntHr7JvGt2gLdXJA98m9u1/X5WLXvZ4bMT9Vugkn1LOpldx2Lt4Obbr1I6pSRUTuqG96UrVL6ydVa8rciLtKwJJLwJJdLDtNHV0tEWucJlpcLpcVgCq8/nb0HKsYL+1YQZXSsQKUEMPOFPGSsiimYXnt/m+cbm2hwz877nppuj7/5PBr4rZ07ar9TXQrjcUQ5QpO0bUqnOxaVfgf61qVtklzqq3lr5OAo/VNZd38FODg2blX8N+ImFo/+ZqfPPka+g+cfCVp8KhlekwGJgfbMjMWUpkTz20F22X9r7K5qYwJb7ktirUqPj3ujjqTe7k5f7YhmhHVmnV5XLSHg+yxsd4Usi+TdQB3irItQ21+k9wO1Tc3rrR9UGVWk4Wp7YCeaLoeRytDk2dj23OrWsl7pXYRuUjfNP3t0Cz9zWYkB5790jJh9LLZmPcIQZodxt3WPMYOSe0Q225yOPOLStrQDLEIVprUhi7H7HAJ/pbVHXfm5VdV/SupcnNdnC5j/iVdN6fImhsCTRYXwYon2sfJjudr8AwDtgSjzSLUBuMSiVKlYDNeK23GazGX0o7jMm9SKxywaTjEy8oMPZ1Do/25w+9fqtTxQxpev5jvPZZ/L/HCzEdl5fI95ItOHMF6GL6/vo6dm0DEKvER2qTLzJ6GcCaqduYS2AcbxbBo5DceHD38pYPD+FETBEPi7p4PTkuM53VdtDoE/fnqXtnFrXRnym6tO1NOs+5MNbzVTY/j/LUGTakUpXmrpvpU3USLnk3pFRS8er71IOfhcrgrTnlyL/dUJ/fympzcqzF6Aznq+IOZVX9+jC8lQdMDfWOS9XnNT/alFexpvtnwvn4JrLU87naOHam3gwXRJReAF3raZk7rN5cj1NeabXTR0U5PzAn6MulhNCz9wAwSq4cztephCnEyAdrEXW6BRjWbne0pmUWZ81XRU2hZyRZzaRVQBq31UqVYTDsvnUdi4y4TgomPeUPiBN+24djo65S3lZof3to744IBM/e+w+8mw8hkv+pUPHSTNqH8HBI+LlR+YTmkkYBfwV3DjtwydoeClAXZlRnJE+pdwNjkEsBsZdHadvYMlLOdMbl1lBtIbkzbwcjbRTFZLmUollLQuDctC1lV7MQyOplSd9zkyqDuQ1SzTVcGi27wK5jsS+3ccS4X91EAEajn8dCjaCRzyq3klxhC4FrSThzqGc08mhi/nfhqj9uPf/RLoqvlvqWjn7zigqfHKz/Nm6koB5WfjsxceM/tMxfOn8GfIAemjr/uTsjI9CRvxOXbGrnPp61YAw6mJLRtG2nLNW7etmXTCy9s6Tv73ruYfdDeT7AuC7kyblyr3Z8irXV/6tik+1MPM2v/VNS2jHWAqnV7ctqVUj/7n+sBlVoAp+0GtVFbD6dtC6VXmq4NeoYQ1naIK0W2uZVThO1PcYqwQ5NThD3M7BhhQXEpO0lYa3Do1TDznzhLmJL91KcK/9AEP83xQpISW2A9gQw/cSaazdzYtC8Q1vDmxvDcphSIUjjPmgTVOA3Y8tiMNVMR2emHPI++AUkORfpGM/poN+BXLNeQ+Co5y6Cyj631FDpVJpPsNbS1tWqqVPsh3fUtazFoPyIjnp/ynKIjkTfC+tOd5gRVCrSl9SZKTNJ0rHUpal5jR89u0VprzylOb/1Lz047x5X4WXu2dqKruX9nchN4tk87gdtEbskTke0OVnNooS3z2LGh040kbUrS9TBfazmg6cEwR+s3oOngpabjSNPBf3Ic6Tr5QRuHppNkTwbAS/t064SXKI8YUu84wSbitPRd64+GjAutRG/CmuxL0STp3DCeWRmiWytkGi6lfcnPwTMrsgP7ikQgcNerHclrbezMAevep90NFtAa+LHbObyOJBWXLlulN+nvyZBp1465c+a1Y6fPuKZDVVWHDlX6WVdOmTxq9LQpo68u79SxshIx4SEYz0f6rbQSFvUqGPEigBqT4IE16TDiaWG1xrTWx4YFwdsCw7KyYSU7bxBMwWTBQcEvnggFnWBWmctDUI4h0C3jwwXGQ9aZo9sOOv+c/P6ZU6y3j2kz8Py+oQFZurXzFha0DY2b/UBB24Lx/w41uhWnrdH9H11fOvhfqy8lXHbjMf21kDfk4FmxbLqHgcK6bfXpjRBr9Zl2Kq/AQGx2HV5XgiJmZdPjkHjaPJseh8zmQMgs1tMdk2JEtj7klu10G8mdzbaRMkVIkrXOiSHMm5JhjXUboP0Uhc+VYeSq9z/fuemqcy4498L+Y25Rnj6M/RWV2p3Pz335nZzdOSOumDH2ssQw2m5Rta2TYFv6VF9xddaEZP9p2s6R007J0/7TmqbTUgGhV2JNmxT+33OyX1N/zvox/532Yx6h9mP2pLEZtXZXAA8c2VP9mLERqT0K4Jr2YXayPsxsfx1jv0vEc452CoMstA9JK3QHHgekWFBt0/0UOeOTz/ZcMuX+/ju/8fALErdaPvtw+T82HFBexrbL/yB9peG7Kgo+evWVuiPd93QjE/6X9vH8j/d0/p9Y+/z/sg81z5kajxr98NmZ4P0uZrkgnnPJsuFhWCmI3ksAgzHyzOJrzWGXUUsEwf+JzDmYougGcPnbg9SxcXI4SyVzK+k6d3tCYoy2/m1LxJDRQjCSJFvkmzqX9xk8+gz+y1uImWQo3yt/KE8or2V3PHvo/OvO0Z1144qVy7cN4XcEnuNHkDcSe95/49063ZY65RFl4Y7hH984deJYzR8YO4IsbpjZK9lpWJTFo/o32mFcdIBvkzJjFAcZoxrJ4GZ9xt20gSk98R7Ac82YtmPMsQbr2c1SogeZ3AytERL2H09JJSbl2XqYD9RPIFbiU34EWVYkjgjkxuWrHts2hHUoT+z5cO+7ddilfNeNU2+5jvWmpb7Zgycy3GlMSNIru9xJr+yNSO46WWReWXSjhxHRK7tFfOlGryyqfEOgXj1olPS+auci5nMV5Qwy5bW6w8NvVJapznbHRkUgR8YMb+JndcfBz+L9jR2bdW3XJXt5WFi3cn+qW7lZUxNtU0rSHe5hvktD4g1+iPJT4uU7U443cSn/dOKyRDt+b6KqKeeCXNFIGIMLLLU1rog5XcFLN5msKleUre2lGYw0Ga8xuUS/yrWwSgc6UIOjKq2bIms4XhkmQgpQfGATzPzbxPaB25To6EpBikTxLUfb6kaemMt/+NSxk8vSoQWM2QYx42tjO0CIRdrpbBo1ODZoKRyRs/X18ewwjaX5lH+lJT0Z4JE91CPjksr3snqeQIboriGeIryPSMoTa/Q6v+qUZVOI7s87GB2Ne0Yia79BaAMTSLEcvBZx4TvEcp0ZmCu2/UYuKbOaDRmk6w9Knwvm19wxfuSIsZfc1lH55C1D24GDRl5pfdfx1mtvvQTS9hhTEKzkf20IblkzIOedoovH62v6DAhdOGrtYw/SnvDK7bofKC99LuMl8TZBbDFvpX0UrPQqwVRL27QCbWw4i01rAB3pMHds0eQf5wSM5obDyoWHsAu9bsuJucrtZM5/w/0ibD2MV3uiX6DeuWTVQJQOjwJ6LOlHAdV7DGCtWikasMJaxf1O7JVsatIi3ZTk1emFGCVJfyIMSyxax7dNHIyvXfvY8p3zAaMo9ypXK5eB/5h0zf/CO08otku/qyAN2RlaQ3bGNGRH8RyFcWwdKrfrx1C+3MONVBlzh1Avc4YoTAnteWC1s54mOvXSOPUIp3ZrqlOttTAbnBD5TT7Wfo2SmgS3ROIC9rvBuF8ZY6GOXksRBl8SMvC2Gxe8mMV/tGl/w6j9ZAQ/SnnXt2GPwk8j3U/2S7xA5ii38+cKP+xL7PpvvNsE/mfYR3uXq70BZSve50CNR2+KsfblTtoMxuGjDRI9WmOdGp3R7qLd8jpRMof5+zCyOoQPJhp/JT/tIz/9mmjkM5RE476EwtfxT1FPn+bt8QvHgfe5XQJ4ld5mRs94+LQb7wqs9bXZWU604WxLveYobcF61pYT7SGPdmvPywLhS3B4lHoSkY+jVJSU7WbmWwC/XoQ3S6nbOZ1D0TQzDuXTYw35ze5YvOgTUvQ5ETZVb92lvK38pHzz9IhvRpGbD+x7ZiVZc9/sa164Snfi4ZdXzd8YMPg3LHrlQP/X23f85/jbXvhi2NiKntrdJyNBx65W76IQW4tg7mYRTDa5qv5i+GoatFrEqmRMbQfjyeMebjEiPFzuh/Dkz0Gd+jMRVEQ19h+GWSPSug63J33ANZkWK7wZBCmCETnTq9aT4TCxt64kiLIxjzVudtFLrXIozWDCJDHucGZV/WlQbhK8msp4TouA1Sw8t0tFK+0OluPUj7eGaqzpqMZ2alTTBMs0hTDwDFPjN/TOB5GrYJECEGmNy+JylCKuRv6YaPDaJrCOCRa6qOn6SkfP4FAsxFBSgFh54BU9hdjXys39hz91zzmAi5/iu5BfTszVbUksU/o8L/wPu5/lv+4+oP8p964w2/yB9pePNEU0DMqY2L3UoA0jg0yY8Zo1f890oKs8nHgIk0ndFgyE/y53ufw73mf2//5uEJoL0D5NHVpmAkgY07sq/yqEPyVobw2kU95jBNh9AnSOlbSliA9pqZMB+3jl4xZouxhemgsQqNaf48XLDcMx7IlGXX57VmPLGukiUtTnRiH+AwoyhqM0Ry5hu6O4B8bJ+dj/z65eE9qNnAkh1BeL0n7VulLiC1eECwqxMulMQAgFhqTpjJjX8EzVp2c8e3LOUkV5PvfT/OeUhqVf7t7ojjxRy1/u2bB708oI/8nSH+7esOHuY4+s+OP2Tz6ZefLxNdv5DZsV89anlm36L71HA3Id/fomOI0RCnFOSF2b3mquoyY4NRajju2fNfNfMS3V2f4Zy3ROnp14GTIdwt0Fsr1EOYLz1BpM+gRLrFY0UMoWgKtkRizkSLUOVp8Kz5DMUXrJAEJXu0CBEZdWPVlJn0zD6l3f3Dhj+Ibphw/f+ebYvZ8IPfkzEydvurGgLf8guNJOZW23J+On8cp0363pgC4dvTl2CtHRZ2mHb5unecjWkT+OwP9V4Wmqx2k6N9lojjM09TzZaI0mte5Qta4+3HX6h9c4rCYTPUab5IVTw2DTQH48Qn4+vO2z1GDU2aDcGcQul3qfk5YH2tPI9FrBR/NAQd3bsLJiex6SDtoPxopEjVp6bwyqm18+O73LiTqTFLfkSTJlfJeNECoCyg/KH8qVh9c/tmr5liXgaTRSrMFCCSVtb8NgUv19Bt6aZWG9SZPJquSDGOtJjTHQLMY6UyrDZZ8RYF3XWAgwqjCIjTGVqxI6h09CGPAASD65fsVjKx6pnS/c+Q34pj0fvP5u3Y5xU2+9JjFb42RZXFqYiktN8ukm4/O2Nr4mcelUg9p6+DViJdnKUeWPd3c99tSq7etwNB/ufeeTXZq+CNcdfPQd1EeOUHtZOdS6KjkDZtPjNmGE9LBGUJJYh23x9Fn1cZHGARHvWqTdobCrETaRdotIoHtoN/sM2t0omW/EGGRQz093rgxV0OIxY/ddxwAzXKasVjb/47lR8ZEHvjYlJvN32z+vfeIFfcVwZZ5So6xS7uq2Jzt86MArOz++kOqv8ZjxecA0bi4XzwRyyZ0dv5o6MnyZjRYp2o0aosprxny6VOYzSKuVEPFYMtmxf4+LbeRA9m83Iv4RRHpVb7AqSYS6UyhICIkkDQjBIqrIAijkJm3JOcp2pU45pLzsUv7O5+5+edfO3dt3voooDZB0uTJHWa88rdxFLiaVibv5nRQW2YgAftlMYRHI6gFb6dPyDjWDBmOsLs6QdoeaUIeMNC4yiNDYkMmkNiunDtBGC5KIlVboWFky7xHppeMxUiiWF7bFJDaMR7hZsPKQhcpPYEgCWXv4qLJmzMMrNm5+YDk/9gpSuust8I2xxNvCl7fMJH8b+//j/TdjYP2cr/8KfE0Bt5CL+9RzLWBostNUL+kjWtFvgCHLADvE4g5SPqGQtkOWijMJpIplb3CyQV/2BjZItn2+axBrhax3ScJO1hAZbNBUVkbon7T9cE5A20llx1s4zPeduAJps/OizkUZOhDSqPbxxwMvrKxKdOF99mN+JMa9RMhTXlvyyDyLo1Ie8+o/lF+/rVd+O3L//Iavuk26ir+djCEzO7ct3tsxM3vnrkGX/v5FI6ccIcNI6aF6ch7p3vlS8LlYG3i5rpizg33mJnk4h5Edk8B+DrV+1sDNb0yuQbx0wR/F5mgi4+ylTIziOidbfmImyAOqx8TDwVyLX2SMQC7rVI1QHNvqsktBikL01o+QSsKFQ9XkD1K9f/qdX/9D+YZYjkyerDT8cPOkq0Yr3+uKlR9eLDE5Z179yOp1qwb0fPqMAd2rtB7ug3XF6fwbjp82olD5N+cp+bdqfqMS0xXLDQvomi1Q5usepzpJ499MTfk3M4RCW5SVhoimFP/mTfFv/iT/5v0X+LewgS8YevM8G3/X4+8n2rxLepEdX7snblxN3iLmhvmJfWSyMp8v5t98Tbnjf9MdPTzE/lJdcQs+j7TC53lPxefFWvJ55DVl5HHyyAdk2XFlBNn7u9L/A2UgX8jziQZeR7+UxH4+K/E1fmGPT/CBz2r3dxRwrGNw3K9Oc63VUuBHd21i24mQY+X56yUnWn/QC06Sdgp2YkkpVksYMO1mp5+EAlHdO5dJHq1VoT+QRLXA0o8po0afpFHSeJyf7cRqnHVBH+nFux9c+tidNz+25PBjT/Tb+sWef7x1x7hG7vCJyCsX9h84+Pxn+vSd3efp/g/cXdPFGL5j1APPq3d3LAH9OriBqShET0Kl7u8VfMkjT0gZu1QuD+EAhB0kuLAO1q4xXqxVNrvkhrEqkPZVf+LkfcTzqVWXOKYrTnw+8gWhy8l9fEb71zo0vKnWIi/RH4Zx5HCLWowErzPy6uvjXlqu4Q3AInNGtdJkNjzJhcp2emjTTpcnfcRSBv4o4GWFHQIqX59TRWsXwHozaAcFMz2cFYCEL1h1WkGaEnfpYm1qStu1kFJ/OEnbMb1foCtuxtmRppyd8884u+qDRMYMb7+SUCrggWC3CpfYp9qsqfF7nUWHe43laq07F2NctGChe1QETNhAmGegxK25DivgkS3SKLsUYxcuMIULR0/I59/4StmfNfzBSefpJDvZSl47uU+YpDyr3CGp/lY/Dp6J1WTqehXVe25oSyZaUSb7Yan62QENK0wLVhLZsOs6b06Sc3q7TyPnPP6Mys6VdCBGA15UWVwiVpPSw3lRW5uc46T9u+7SnPr1Rzq2AQ28PfDtsvsG8L1hUMOqlvdLvMr3uP3xhnXJ+5yG0R773ZvpPI2jM6c4Omdzjs7ZGkcHc/DzwYOKDULQUPLsyX3kTaXzv/MdNEwPvXTFzTg5HJTBnOLknClOztmck6sWqg8phXhYW7i1YdH/zntt/l3uDyRcW8AwO+h8JTk9HAN2/E/j9Jx/jdNrKzysPHVQmCQDqhEmsT2z/5Z7IfCsVBv9DH0dxPYAl4c3BznZHWuyz4z7uexMgyFGr3LIi+KRIF3yjkQE225WsSc4olGMsrLeFo3iiXIslzAH1bNtlOK2utjtBmaOzQpt+V7OFcES1nE+L6cHxRRzkENkiA5CaPOvktEklxg/JBwJKZ83cnUNyqdHV65YuYJ3rnjs8eW85ycSdJO1yvAM5WD998pXXqWcvOUloaMrd7r4/Z6XE7+4d6xY/pL7v+puj2plge47+owkj2duweORpjyeM8UnOZM8nrc1Hg983PGDyz7UFTcsggU/P7GfTFJ5vCp4ppvrp9afqW6+1qWnPYRdCIc86Q8Dj48XD+CZE7pVL9Alw8l6l1rKQGm8ZizeoWeGLB928OAVz1/z1Hb+UbJYmfFkhyh5HVzt7qrK55J39RnuTPftmvx0qTTh8JqInaTRnK1xeCD3yi/JikOq4PDFemlQfRsz4XlpHJ65FQ6PNOfwTvVwjcPznorD04by6IepwagzofIJeghBEGu8yOHR3MSuZWvgKWoFr5XGNxNd05TDc7bC4bnYyNia9zbh8FjZXwg5PApEPXxF4psvDn6hZB9MfD3ptt/ApyiXLHts9dPCpER0xeAedI0jHniE4pzm3J06uHTuzpTi7pxNuDFnirtztsrdsbE14e6qD378+Uef1X387D1Tbxu3V4gehAANw1vz1LoBgwf3UNprfVEY9uxH76dxa/tJskUdXq3A2qYLKVNmsAz3kxwUy1NT5mS3RUxdZ4tpLE1g2Xhg8izkxYP7lF8JN2Hi1PENOBbl7dVPr7ugPyqKcnbCZIg1AVxLGVp+IargrNZoyBBhFEYj3VZi+0lCBksdDCImj0a6t2TFy/8k6qkZgMv3aJQcZUwgSgJ46L7sfuJxK+3Jh7a5M0c81q3H00NOnFB+boy33dabdFh737zO63KKlG+VX5SflS9UHTUegzysqhVurkmQz7akuDlziptzNufmAiluLvBXuTnKeAD64bFnGeRwaVG++uB3gT/ePkCI8tV7v3mPkvcmzpkzadKcORMRlH1wFFHQSeXAb4eVzrxv87Ztm2u2bgWZRDDQ12k+709ycGZ2k6TshaTOJnIoiM3ITkLo6mjJiIOWeWG7aLOTQVeHjl0CgDmcrUpregBz4hUZq0FY/XCoKQknkjY3Tvt4G/nqUJ3SmD/juvd/vfxqUpO3ctIjiCKXKWP5QxcMIWcO+h/eP+x5rczQ9df7h/3/3Fdqu1ZV3UnrK9X1P9RXinA2wHV4f20xdw8XL0Lr9kfkLGs9QCjZRdE4FjYSQ72kj0pChNK2RfSW40KwbJ0JYllhEQaHQiPEsqJCfFmEcaKQEZ4eldEtLGIcdI5YY3f5A/RsYJafHbMvwv0C2ZVPfwMDSayC3bKD1TDsRHDqbKBYrt5IanvoIF52oTM5y5++mtyx8qFLenTpMuXvi+86qFuyYt26FddkDxx24UBlesM/V28I1IpP8l9+u2GPkq9bovlzYTCsFTxP0bkF6+dqjfXD3Euv1Scl+T8hdUQZmcBQ6mQygOf002osV3hK89+0FkDULNUE/tvq8KOlWtP9t6jWAzhEyUOrhzhqUYb0vCGknjlIP0BRwI0GM9BLC85eev0d813kI6XUOm/OksdnPZVQfoUMwk0yu63vfM+itcuX9H6hG/H/L7xT8r/6HmSh8Sg8tNd/c+80v+YZthzM+/Peaf+OdzfjOY0fDedAzM0Av36pulKQjQpEWfbHgRM30gvMKDHlhrVjyvfjVhg10xA9qmEK4j/QGmXghdsFtGBDUL1MkrlKYtYwJbBS5zQYk/X41gMffPGpMvpY1vAlkwYLK+Vxt0ycsEGltRhYFCYpTylzn9/McBr1LYZJNOfJbHI2Q0OzqbMZaBNmdjYj6xRnM5za2Qy/moFkp85m+JuczdDkoGczGKT8miw/tOPzD/bvU0Yq1/Izar6YOGEj46Bw5E+uQx5qHYPhGAvUu8xzuVvVuz09McDarccBQG05NA5ka3EgmxZPZmMcyKGn53IwDmQzTO5R93eyc5i1eAHCueheZOA0bj/tAmp09+OUJZq7pxegN/P0ien8COxlxZw8w+wXgI9vfpaDND3L4fzrZzmacKl9Uq4+nVRN9/kaZ32Qc6TuH2nCngdbY88zVfZco7jMYq3BIXrpcY4/ZdFTRznSiecxGsJqSTm/k36PC+v1dRg0FqYYvmmnrxCEJX19PDNEb8PECyJ97Gyor072eyhfi24r18tOfPp9orvGBniWduTDUxxe2t0t1y2b8qr+cuevpoc4WqWPlHdaEOstmn0dTj+/gVzIxZQLSD+/YW56fqNVLoSe3/Cmzm84Wzu/AYbyw0FlyfssDz+5T1lAGI82pfGY8WH9Yi6K3RA7cqwazSXUSxlRWpeJbaMttnopB/QaY8wv29N3s873Wh+SEkiJynFD2Y5bb4aOaCY+UeqAd7zHQ9g9DtdWR1BvB0w6ajmjJ7+ERV3ZEKpKdeFIqyhEPgWdoljOJ7fPWekG7f+cz00hlmMDH64a2mtI27kPvvTcuEsOX3Lb8y8undv2ol4XnbF0wHFiVSB9Hb/uvAvXXg2J4T7+c3IuGRtrs6E0W2n8XvlN+eJc8qhy7bkkn5iPESGn3YY2MWWZ8oKyXLm1y5ndy8mC5H5eBOYmE3t5ZnI0/6eWKJvFGDv/ZIZ1m0VBCMZsN3OLssUMyjBlYDqIm2M+Gp+4TGzDZs+oSr+k1yOw+47dYszFG8OCUQjz331YmGGy5D1xf8PWc1ymeRO/2vHWvpUd7oU8PDHz2kWFF5IJ5P7Ei/vOfpLcRyLKKsX8DnngeuVTlvtaYJ2/Db4Tz+Ndr/aZwcN4dAGh5zSj56w1Z7kIqzylTjSbltbwNNllTtRDj7V50ImK9M5ZEZ2oejTPrh3Ny/JoVBjeQEmdZsvyKQvxHSYzlTuXE5FkK8eVn5SbDy9b/eSTL83UVW46enTTr++/8d5HusqGe8ZNnTRGk2Gl7p/0ZrhbVBncqaBFyWRkyygkJgCJa4NmF0LWoImVCf2f9r47Pqoq/fueO3On955eJpn0TDKTZBJ6EQHpKKgoIogNRUWQojQFG6Br76xiw7rMnQQUV10UEQsqNnTdFRQVjWBZ2y5lju95nnPvlBRkf+/v8/716ifJZDLMnPOc55zz1O/XgXNxqReCy4EtejAXBzbuOWAuSkQWbmSsIMpxdbsAeGQkHUUyfb+XjKdxIpBX9u6heXv/s//yy37RXCbv2MFO47cygkkE6oN0P0g3McthhWLV5wm82jmjOsgC1UFFecxxB1h2KOSzR9SkQzG/gYsRYRVrUnLhzwlXIU7GyRwB8A9dgOdXAFUKAjK3xYuczJXhwUrIPTjjxnS5UHkXC10p3dVA8TZxlpOzSOmHW0782+rn9+SIC5LXmr7YPnXDGY/vou/Sp230FywZyiUxcdqLp7z10isf/4iVvBNIX17njXwa0lpmtxel5pyLczZmRl0sEN8rzFXnbORz5oHyIh57KcLTG+cc4HMuSM0ZWhtcBYhhqMw5AGizcX+Pc86gss/ySsoq4Gj8JXBwz7rbB10za/lVFrKDRow3Ll991wL5S3rE8QtYJ598MejxlpXXJNbeeNxz/X7+lrYofW/nSUvYee0SBqnRVL1S5d9hMUIADnTUYuYxOMMuWe/mAWS9QQkgEws+gF64EhLUBCHUoiElFXC6iVFCxKZvvl/41qLvSZQ0jxto0ZVLSw6tEC9LroYvTcOOh8O5s2CfQN3tPXh3OLqMBYKBRgsGA4162PCYMVXG4lLHYlfHYsfAT3os7hKxQqclLzP37OU9T095beqT3xLthf48sNrJRjoKvsTThd+HjUn1AJ/NZOJmJ+XZysrrzfYoGwl2ThP+E8KTEozIGuXK7kmZm26u7G4lzermx6gFjEvJg004bJkFWdLgeiv67E4POMjsZ1LCvDQbYZr85FdEFJsO7J//1sID31L6sLiIhGdUm/RV2JowiMlyUfJa9UvTlFwYKrxUtZdnMHm62blzZvY8UvYyj7DyKRj5FHL5FDxdp5DX0xTIUacQZVPQr3uHnLcJRZ84+dVJHXteol+I9T8NL7WflErbvkZb8YuZzeLFT0yt/juuQyHTzRcQa6JYeIWPv93u8BWU+aOcbrxQAQdlwy1gt3kBP82B3cHHo+n2HHRPoAKs3+EDt/IKMMERF7ewF8fztzz38u8HHuXPOhxx55a43RG3bRHaRZszHxnrU494fRgYh3pg3PA7ZV0hLxEpgmIG2VwMpWIudlW2KfQ3HTqzJ4DuusEp63luqcU9QIwRgKFhpqQ7qKknNVgdyLazxm0khYUX1J1x7Zn0Gu0DdPFtj/dd9e3iyrOHl35VfMKMysUJEibhs8nYNTeOt5K3V66kEe/DL9Ix5Nbls5IrxCXnrqCztRsh04yyYw6d9k229vns9DpOrSDzspVH165AzzHYfLtkr5v3V3khIlLIxg6T7NAa3f5CBbhbMuDY3cxY50MXuw49T7TPb7pyFt2l+Za+N2LmyMqF71xUckJT3utFbcNLL4p//hU5/pYlHnLK2WfTR60DzruIPkfqpw6n9eS9YdPoe5or6WEiKfvuVbbepUK58DUfc4fN7s3HBdfxnScH2R2jDWCBpruYaS3AVJZF1KhrKd94pdxeVoogfWkTDzIatgDGYkEp+td8V8+Xn6lD4Rb24nheplIwdXBsidsccStTCqsjr5ArhfoIlQI8L1knYZIzoUXWC6jKKkOYS2M5p3Q3YFhdG0B+EFkXhF1kSHmZvYg16G6JlTiN4uZ94lx6p/Y+umzmqmk1q/YtrTn7dMs+y+kzaxd/u6ohQm8Qq0g9qcf77K9MMRosE/90HWjGqmnJleLiM1bT2WTDHU3Ja5l+3EguVeN0upuZfoCsFylng82bH1U0BCWtVyUdL2ZyNmTJ2aPKGYXrVtgiSqHyS9JhSzmzmsug6xf2jNuPdJ8y8LH/d7MneYSdH9/RLzT76buoWm9fXDxKVa23FlYW0k/J3s+/wqNkWM8KRo4/t4C2MDU7QrRwrzfScdrhuruFMcKrQqJFjYKMCseHR+X+7NHgCIRqzOxRKCyXABbTWJx0n0Bnog8aaX2OYwZXMBLv45B1bN5Rpmc2qHOqZa+w1SLlOaBljmN/6wPVcG5PTi7IxOYcZNVqnL68gqpwQ8vg4aMAxLcWMM1KQqAg/UcxBRnaFm+BmA9PlgOySxRr08LMGYmHnAlfQS1CWrsSOUDKxcToV1mz0q2m+oqWGDt8m6M+/wDm5Pm9aDNgbadStCbZRKT+jkGY0ItpKggnNf59/98e//zjx+4nD/5p2WvPznr8udzBSx4Ycd2ICac0DazJiVRNb3zo2fgD7VuYS/LN1PPqxp9w2qzz+66JeqePGnrOuXP+8uzCG1aZdHMWXTL32c9Onzn/vktyik+4Kjd63anH19qWmUeOyu24amUiV+97etXWjyXRW1XVWCNJob+58iXpZrY2ufRszRMSsDOyEz8CayOya2lYOD4kKrexR4awbGSaGAzLhbAwI3BhWtydbB1B7C0D2cK0cA8yDNRmsCpVTFmLIwlrFWJLGtnCjGR/boGFcbp8GDO1OgcZRbsnkBuK9B0GT2hd7TW1/YbAwyqnXBiE1WkbxlZnAJABYYE0wG+GsQyvphZgYV0JT25VG5IFJHwB7hf5HeVlXSsHY6GelkVZFb2yKgOJsiiwJrnkFlJ0xz3LlerC5Zced8k9o5YNO+m0aP/a/LraU8sWXPXaktk0eWDCtJphp0yccfPSIteE5iEvXHrvuoXEoxHvGT+S1x822SYuyG1eOemEKutyy3EtBded2RHTly058+5HCPGEQnW1klTR7vIbV6L9ez47I7TsPM4TxvG8KO9KMTALoiNH5wfL0BSVcyzcbFBICTlEO7uHmUsj+7zMn0eiJUjXOu3czVIbhvoSDK8h5rpHKEG7oVg4/9P4s3kfFWx45nO6hx4IfxSm/6K7NU+RnbTp8Qc1/iOdjzzIHkeSzBGeQh4lOm6r30YrpceZn5gLOOoB7ttCSRX7eG7s2KOQR9SHUzAf3tRAdREsijNE1Lo4l4L7AXVxkGtyObmdyzYqohPx4fvZd16uEnV5HVjHUibc9skdj+x6en1B1d+H0m/o97vof+jPolt0J79ObDBLzYfesr+w+cJvnqCHf6OH6N/ttI1sNxBPBqcn9pW6mMU2qWtnKfaPWIyajP4RpcnUHVH6TKGsC1pN87JbTQGAOV3Glm415T5TOc+NdW82tX34/F/fdR55VdPieXvjpve79ZxKn3z26adb33pvp8qzgfV2YDVHlbE71Iq7gKmzw2PFsXsMiG/F461Q5dBjgV3W0LKq7L61XLV86TJLcr/otV95xeKuxXan3nLzzbc8fu31q1KYBNJA6TrBCz2T0E2QMIs8bOzgHVW8fswBGPo2bZuSxYeAGfH5W2LujF1KSg6Quliev9/9fU66eMLxY6MNTcNq6Sb6u7T4yPWJFVf9jfzrmT8Nyt/sm7L6SL7y2dpTtWHBD7V+/lTOgn22y4jVFryawuWHiKQWI5LITJAO13X9/HdGGXX6hsC51cOnjx9YV1xV2+ilv9HD2lDyL7uHR+PHkz7LZje6/2IdNjBpTPPSD9SHEI+8qmcZVIcBi/ZYZcBOMiUMWp561Itc6Avf5k0LLx68mYxRHvQkKb3L02f9kEDTy43KT3Xc2lOlvcjUW9Oz/GrDvFf02OXX49h7kSl9tuvge5Sy9HbX0WuAT90YV/rDa7OYbGthEmqbeCIAsymOxsvCcpUphUQOECoZXeP12Vu5qoydQSGsma5okwN2ZqsLFp0rH2vte+sjL+dBuVhW9Hce6UvqSAXpQ7eyq/wD+uqPf/3rC5s6XnjxOW3Dr5+EXQZb7K2faN8r6O4ThkcHPzSkku3/6eRiuoo+TB+iq8ilZDo7go8QDbEQA5Ho4TOSD1++cPzD4pR0pSHWGRoWKHW41exGSVfiIlkCFPHHC6Opslzgn6kwpXnms6tza7Orcyugfr8MZVHehrW67TohN08VRQ/luqQnQfRcw6tx/vpxk01yRd/9ifZbTPeMGN08+OEhod5Yh2YkH7196qn3iqdkllkiVsAqaZ/0I85+hhB3hjvybYJZW8NMyw4dPlLn6stFt7WEo+jgXEt8yNNsd2NaP9/JfrO7c9AvCznbBZ9F5SfTGMsq1WmXY3OSXwt6IEGysExwe1x+zj/oam4SK+BJnTiPBInNMrylabiNmEg5/Qc9lD9nbg79he7+cd2D7qGNZwUffOCBdcXnnl227gG29mFySXm/+vp+5UwDPmT/X1954YXlZD4Jv0t/C9WUjgkR07tvEWPF2DGV9KBSg3279gXtSjb3KmXueTbBwuZejnO3wNw5x67iskMiy6Kw6RZnzT2Pzx0Zq+PlznaLTyhOzb1UmXuTK8bn7nN5PSJYsxUhMebw8ydbnA7Otlihm/HlO4ZBTQ0DzTv27dnpvPASx5tffvOmrbUl2up4fbu1b3NbH+t20fsF8RY3hkKRIN33yV66v+zsc4Mk51O6szVUXlHWxuRR0bemqqqmr3p369cYbEK9MEQ4kcwUcKvHQ1Fo/2S3Ms9BMDfKAKwKzHEIy+G+zHuN6YAXtH1grI+hJj4gKkfY71FmTJ3EK/FykNMmTGo6hjiEGJPcEIc8nP02AQFXE8MnMItWGD6U2byjI/EJPPwRZAKcxN3bHy946TtwZOMD6uMt9fEBDjlafBDM477FB587MHlrgP3RHI862puiLe6a9mb4zl7V3m9AX/Zrf/ieYH8qXlW8KqizOV1t8ea2BHsaHvVrE9qbmvv1R4/4mWhTc0vffv0H1Cv/oWccNrNFM2hstbBSQ7C6YrhLjoCrPMGZcFYhM4/f1eEpKA614jLbatmOrkJmaEHnLAgqiRUJQi19nImhoyfAPxnoio/NLO1OATcUkowsS0uXJAuz1ACBti/xcvhZnR7yj81N9SL8AXK884jph1uXjTlryspbNz9yylODhj5xyqPP3baiz7TQqCW3/UAMbIv8PPuRESMeuZD+TD8RR/wUm33pslFW+xlrLjmlMlottbb1KakomTdwxJ94gmbq0yN5embP5DFjJpNSYviOaOrznp6KuZm1dE5bnz5tZI10XejrYE3wrpLKkliMJkY7WnLYuZ2Te8qoAZMXKfVnuhLdXraLBgjjyXQhUQG6FYzKVnZgupRa7YIoFLsA+0ZLWK6OMd2KSp3xSKS9b7SF6VafqFzPdCvMdGsCT8/mYJqnmmnTAA7my9RjKPttLGpaYuhY0K2h4E+NiMTH8uRCcU6nPFHRLeFlA+pWn/p4pB484TDTrYhDjoFu6bZGUbfCjvaGcIQpUyN8Z69qb+0TY7+2wfcE+1OGbjW2JdjT8KiV6VZDY2sb161wQ2MkxmSbpVsDquF4MFgx9zbUmdDVQz1MfKwrYS/P40m7DlduQbAJ9cpawfSqHPRqo6Cze3OLVcUCyP0WZ2LgiLHwb/q64qN4q6eiWLxngEOROlStUroddMjGAoUYvSiVUqIx48OdV5877KTh25ctu/aSxkVjly5/pXF0ybALr3rng1+/ufe8c+/6+iC5bt5SRZem3XjRyVWNVYa2tlhRZdGAloEjbmZXjpX4Y+vr6J82vTijqv+WZ8mcfOf6GO1kavgz/eqkk0ie9u3yOfPLasruKKkqaW6jiVGuZqZE9py8mvpRA09eyO+ic+CM0n0iNDA9ekxI1IMWVUbBMIn7lBOqNIo5tPxIvF84HmPnkbYT1nSAtVNuboukCIwBMItDUsueAML/QDlpeYCzFUP2eaNGqm+M9AM5e5yJmta+IN8cV0dxaWU0hmtir2drUoNJeEHnKipXl6S4rU2O9GOXfGNTW3qX955N7b7PS7z6YEWQf51DDD/efNWYIROqr7r9xfh5Z3x96tz4i7etqD5p8KjlN8Oe/oT+ctFjIyc9fja7+D4RNZqCMTUND4Wrwo/W1bBdfDw5/zQly3qQ7h5J7qSzxzA70sCzrKfhRr6HzuvXd1CMrJYq+/R56Cz2H5M15lqlWUI+u/cncKTkuC8j2wrEumwHF2qRGaKaybekHORbg0U2kOqrBdtWyMckK2Re5cJKJpSC4sx0ayydbvWYiD6oqdBrStxZAhAPfFDlMXinnH7H91vHmgzXLvhyQvymzy8orbmKHvFo8sdVhR9hs304XMXM2+ULl4z8YBu5Nfn8v2ofIKtI7Gd6P916O6k5bxb9SIrGYo/i7BB/h1YilrEPcA48qn1r92CvpdNYw6F4jAgUr3aeKZatGyzaAC/fRc/UaEf6qjgzE9lj6LvWY7gwC6AnlF7/oLNYmPc46b/ri+dPfP6OD378cvflF+2jf6H3iS9+TEbKp/1tEv36N5qkhwqSp5BtZA7WCNJKzYPsA/wQH8CuchuzQb3YOOx1GyH4iWE7GHq6yygNZmFWxm1XcJzckBG3cWISg01BcspgOC5JARZzXJSgMxgSsXbwiRuG3jHzlutvu3bEjLq91u+TvGpwUEdr4vln435HcgrZrifYuzLz9yPakdoPmEftFBJOAeCJFcB/IN6R3OXsy6+R9OX4VeGeOZj4XqIHhhBPfH6ceIfRH14mriH0wFMLnxLtl95Pxt8/735Sfxx9Z+3cP9P4A5f+mb4/lDRyP3mT9mTNLdI1gp3dMlCVotF2JixYsmGBZgqNBW4Djc5Yk4LA5GV8JWz7YXkUOw431TeTjeaTZ9S30FGWydO121oaTju/OTYF3v+A9knNDmmz4BGeEaC11RGV9ToowWonersBuuCYBDtlsxs2gRfq+ACGgV1EEGCG+8bV9+X1eN9o6uOOegjduHUHAXZSpzv4nPvA1nq8bzSOdq1Gxy4YCb7H3Y52p9vBfnXB9wT7U8Z9I7UlXFD53gYgNu1ayeni941GK+nY0+7M+wabuKIR8CZ9BSQIkTybGDxgGbV07gVtixfeNrPy1Nk3TNVuuCtYUzZ3bmXupNKKUpAreVl7n/i6TsdWsB7mDaQBaPe6EEafTXEou2sR0lMw2401ahN1GslfDzRQPogFkpdPGNQyoCk3t7VtwU3S4gGj62srXSa3LafZMca1kH3WK5mfJYQ7LOnP0u7qsPN7XWuHz9JCxYAx9Vld7yzyCl4//WMDR9yovW+Mg10mDmdOTm396CEnLmDzMggV9G39pdIpglXIYxoTE44TJgpnCrPJRUK8KdxRpxXamEXBts+4aIeT/zICourxWdEODf/9rEjChApmms4UTNCdE4lEILswNdpRxF8xORIfHO7og78kBveB1w5uZePuz1TkIpSflVsuVowvslurI48/UYVY0voUY0Jch/ZLPBjp8PAnSiNwazHrJ94a6Yjx546LxGMOuZE9NyDS0cCf6x+JNzjkYey5EyMdE/lzZ0biEx3ydPbus/kTsx3yaPaKKZGOUfyJUyPxUQ75XPaKczg1wsVQ4Q7HhEkDGRA9hJ4DRSEI/zcyk0eu68Oenj2dPT1u8tQR8PSo0ezps2YhcGode95jG4bZgpCG/ZJfeuKp3Ofhvk2QI71n/6bJ+o1k/62l9z9lv2XmCyuk6WedcrE0WuozeFSDNCPrt5FZv5Hd0pnw6yipzxD26wjzC6fO1im/kC/hpRfpxmjT/zD120XmF0+5WDcG3qVRIpsnz5xxSk1VeZgWTz57xqnwSNN+8kz2qDoUPjxk0tkzTqmurqiTdj43/VR4cLhv95fRuudmTq6uDtUrenujvkG6U9ALNnZ3FQohoU5oFvoLswSwm1slhCyXinc54/2iHE9lQDhetIvZ1R3lfG0Bz1zVs2BEHshWNqeIB2XKnXJhKbsG8oCnSpBbJE7QpXHKArN/4q2ueAzrcdh2ZgaNuyXm1zMJx3x+fQXb3i2xqN9GQP6xqE4flGLs72w5Yv5Cwu4Sd3MMIlahig+vsA589pKPj5uqXfqMZ9BdFae7CieTH6KOa0yOocGpruEFUyPOq8kT2kUvDvqsf2yqq+Sk/MGr1tiO2zLgA7HwjKjzarNzaPKtNZHTnaOGa48M7mw6Q9uw+dDJ+Lajpe3sde8vWegaNXzILbVHPjtD29pxwpBd5POrze7jC6dGeX0EXaKbrK8RcoQK4V6l9tKWxvwsD8uFUmeiENsXCkvZhs1lG7ZSxfyUJVdney7nc+VApXYF97PUBMgcJR6shyxlr6yCek0JIsQVIFWEPypBQ97uBLzPUpfsD7Rh8w+wNPPqzXbJZPZz6AkI02uiLlLijDKzKOhsGqDl8J8kE/7TbvybaCOmg/fSI4++K2okrYYYkvUT39afdMmM6cadzje2vQmYnGWT6bskrIkcHpPsICvED/InTDlleC05fLe+ZsbEU05//I6beS/2amm+tE9wCcUpPFSrUm+hB35b2c9k48eiJ38elKDxCimSwlLwQMrK7UZmGw/HUoDkidGrILowoWGllAZKMXRQduBxxl1QnxgvxIYGPSigbHFigWuqqLVdZzQ502KBcCiTShCkEusiknUfExsUuH65cvfSv9uT+9fv0E+aM22G4T3Hm9vfhBLQH5yV32taeQekmHPW80dek/bNmHDy6Y/efSvIoE7BtoaavYsyavbAw4BKPYUFroMI8BCr+Cy8qOd/oW4v2mvdXt2afSRK37qT+Ekp/Zr+SOfuu3fdYw9sulEb2PLww1s+eveNdz/UBo6sv2jRnPM45jP0JmLtYa4wk1tgUGwOrJiQg+xWup2XGr39j0bvU8AOMQmS2230iLGfVaoHZdpD6ItE+Gb3vn/S3L0H918+/xftyWv37l1LQ1Asrz35yPi1vE4esNBmIMZdfqruBxHI8pnQbQ7E6LSluTztzLx1ROJ2zioDGJ1A2gmhZcB/kqDnX5BtkMY3mhC5g9nGiIOcDd/NDjFdDQEYz1hFzK9Cea5lJq/hnDNnLlw2df6d1zc3jFs6a8Kdf34IED2XvNh63bQn/QDrqTv/jBsGLlu0QOl3VPAMfOx8WaToT67a6oj1K2UKngE/VHx2jHsowVPAvYWDw4cwsy43p39OaG06LPnmZd6OFPtjrjNh5i8qg9qMOHEqvIlu4E3k7j7ODQAOiggHOFBnCJfiumdKrOe/++ru+2Yunts68o2LbXr9FavLfbNWzOy3cPnKy7WAdnAjBzt446Zrpt/lvnnIWXQc4B0Yrptx1eSnNnXcI6exhH26B9jdFMvEK9dBjaVOrQ3tgtsqwpJ5MjEi4GuzeOM7yeulxaSM+gG3lWMxnS1NzHxvBJ0w9Pje9qO89zry4we0UBsitbTqyNXw3rDfBcRGP0npzdEo4+4QiEXZ4oIFcrFILmrBTWJGdoyE2aJiN7HvEtsoFmQbtQgK2yjuihT8eNBZt0YzPHk/WU0v2ydO3iKes41O25J8QpzMxmFiczwNe0pT4yCcXzxzHIau47D/j8ZhulHcSgvJcLr5cyJvIK8+R3/ZQMcRGTEmPdpfmDwK4fTLwp0HfByvtbMjT49ld3nWVJtuIYdgL8QqhkIA9y/k+9Gs9OgGCpk66+2uNhU7GM58AdvX2GlvDqTpdJnOaiEADpUDFc2pRl29c7NmTPLus6/YQgruWvb9fTOWDJm/cu2TP3zd93RgAhhhuZPu3v4y/fJub86O8D93vvuZOfmO2m9fqPUxueYJ87M6+sxIte5iyxzg8wloUoBWeXZO9ySodE8pjideBCDnCSqqiNeZ0Fv5vKDqHhLuAiTcARHI5M2al8BDb5mTWie+RnMn9jlIbN+9e92s8+csWHbvEy2t2tBf6Q9muof+h1L6ZcsrMfnppzZZ6AUK5sYSfStbH28K19ruysap94XjbsS1ciFOPdRWwx0MKJ9w79hc4P2bzErG0djGESQ2avVmi9PTDcY+ir3H3aDsydU/7l7aE5j9z2hgqID2RBDpaux76jpe0sN4PVnj9RzzeKM9jzcbqqv5nzsv5WBdIVFQwbqoQLkhoAJ24Rl+Eh2gYPC3CvdwdJGOsFbI0dakgPjB4K6UsvH428Lxml1y1IFksDVRUJ4asJKi/MLPBOqX+0DlVQ2bmVgaRu2pbGHa04pYbqGaKITM8sJMyZyAd5ivkE4wk5Gj9jv/C9R+t6JvFVG1jfKPcfzfbKoN1g0fcvOwfsXzZg4dcBRY/0NX2Gqqm2YPbDl+fO3U2U4uv2F0gIJ51gJM1oB6Bl41yE8FPmOOthySsvHPYuF41S65kcmvkZem9QaF1sr+1ljFpOOrA4c0DYoWamJCbEGAyLKqRhCiqQ7CW0WcO4ADpLkUgDTnMQOkdRdh75BpM7NF1xuCGj3QTW4cU3ks2p7ju3gm0BXm7tIMaMUiH17OboVNogMTpy1uAStasZs1JrMjZTe3xEiJoFd2CDtR950xlVxBJHrzA+TWHz+9hQ6/lnkK0+fNIi/R8c8mN+JGXnxx8mflHL1eex3ivaljM2d0zdlTMI5iRAE6QEQYqGM2QehAq0OLXtZLKVdHozdYU2PL2LpqP93xb717fhqcjCJUobpHub3RibI6LmM8Kpy4u8fGSbAfMaAS4cgbvLPPoRZzxpxRL4DnlBBv0AnyWbiYDCFS8l9iIf2NdixeCOL5Ezl5G1mavOvIAfLZb+TqGSieDFy27PGQ7PHYj2U8zszxxKDbUMPGU8HkMm3FO0qjYeeKaSCYOaTP2t+gx5A4niUT56iyqVNkg/FtiBfHHVGeIrFEmePiVR0XDXdc/NCqB9aER3VcPBhP9oDp78WouBcsCQRoF4DV2ohXuWrzR9nwFN0qIXo0c/Y9/XRKuVB6w6/dpy3deuedW+lfFQU7cgCVS1ua7jM9lfkrPjXGDWPmJTNdXZX0eO1/NF7ZA3VBJgS4teJDV1uWr6KPxviS67Gd9DMyjsom3WIymOjoSWQbPUifXPwZ7yhlttr9ZDJtTT5Ids6ktyFmAEEM7PloPw7mdlsGhwZgYCvGmgLa3NUwY5YltuoZFXFC54Q6GoNYLjYTHVO/AvpvJsCvtRu3J88UHwDd46LbyD4f8Hu0iN8zONWzqO5LaM5CjjzzLmaMcNAekwrawxnzBHPXz1ehLt1iDZF/oCPI7kO06WPNZXJmP6vmMvW8+hZ9tZO67EEJGWZT3BWOlK8moq9mSXFXgKluMnMYeOSmsqltCtlAUilSi927U7QWSjADqC2wd1MqR1ylM7rsv4yxGDsTNo1a4Zwalr3rsBDUyqKAWv3RqBDGb8cHn6hAfjyyoID5cR6SE1A/xqaRYpROHNkAPWcWbMTRKKoiqBjpEBg28wEZAp0JAyqOQZ+y6Pk4uD3PZSOW0ZdTwtl+eJRC+sGxFZ9E3yJzDEqlPKBMqGMwpsdg7zoG+x+OASQhNtG/pDAN5SOr03KgHgPU4xYLC5Qx5Ct8HkUaNMXdzLXIkXCdcqydmZ13xUpDBBeL0hNhVFD/fPmI+ehAI8ptVdkjgPQohzn9gFYjKYjWzqO4F5wwxHTmymeI+9YrD9wz+coTFi+9c8M/d80Yti/5MhPplbY76Wdvvkz33u7Jf6Pu89ff3W1PfqjdeHgU9zF0i5h8i9RuhHiegotYaEy7GVLazUh32BVxKII8Lm7FzQB8IIgG5OVnuBlSb26GUXUzYHZgsUAcrNvk1mmWRVrv+GzRuVtXXnnu9IsvXnDbuoqCL+lwtlItxisP/eXJX5a1vNrW/uRTm0z0fARnhPqvDZIs3SJUMztuHa/cwJKgINhkhUpQDPKkHb6mCgiM+YzcjEuX/0DesYYdPTWYm5BzvJ1ovdW4mQWvN2psDqyBaHS263z5mEVni8YL1iuAX7UE+wnLsQ0lH8KFTc4Os+DOqYdsgtGHSF6QuNSpiUufApcIudZQKick6n1KsyGEQsrEco/PP0BBBJ9H+pG6lmU1fSZMold/vL0sd+iJL26Ivzz/gr7DR/Vvm/nYDTPWbKOf3aWxj2wddcbo4cPHi0+R2WSRz7E5P/n1v+lPhnFEWPN550+f/5n+61S/74XAGcVPkP7tK94Y0PzB0hvuuQdryV7StjN7uEqIgBxDSgY3XgpyLEjBqZgAaCiuQxeBbUpvYwiBlsE0jmbmcqG6stqN12E1FlgBWSI2fle7oHjBYNM5IDsTDztlb1kbKEkir6AUtSdUyiFZCqDBBaSaB7Zxo7NDMLsCtUoZniuamQCOhVKptSwx1pNyD0oxWDrj0L4ZJ0aGDVq+cMU1Ecc5j9x607qpJ1Y0929qnrhm8blzbtmzSLx5ZmzohZeKZmIgoYK4d9Or6zcbVj7zsNzx0PznWx229a6xpVcfXHDfGaXLp2zA2kPmg3GOnBrw3AHvo6OU+xAqUU68KiznSZ0qP4s1F+stIf4XciAVi1wIjfA5JdjYEHJ2mBw+bSkvyavi9Rs+ZyKnMISOAhNMQtB72rpn77vR65Bu/kBvhDvkpWx3oBcCnuSCLt4A0xnmQ3EM0UqYP6CIQmoR5q+m+KHDJwDzr0rRFSkAPEE2/2o4QEzQv+MrRG0IOtsNVk0Rzj8QYvOvBLD/hC8Pur5kQxHMX4eFyOlKgB7gR7tPvidAUtK3y8S7A5Qm38+eNBHy6RLkIDJDB20W/ZAFWcGAfsiE+KQmCEVLDiYFJO5K6A3wrF6TIv3jqKX8jkY2oj17vmL20/YjHrAZtJwrp4quRnxUM/DJZECjJgSCSIwGMBKUj7ZnfnS7QTIx80Dv+YNPRszUN9/7B6CmJvuAXaC5TKmtB74PAyCQ6CEmhTxIGuYoGJmxuwvrhcGFglxrXAS8Av4AisMx1hF0HiKjyehDtHYfu5uWiVceeTj5mZijYLIW413fkInUkTJD2dUCKSsz1K5IWsRCsDg5iL4zXWDMPuCXbeV1ppqK7T/R6XuZr9F51vMdF4j+wx/TarIrYw4OYSq3O9U5dFhtZsGK+KtWDYRCsN3ZvCtuj6CKSpGECe0IExOvao9amfjgWDOZ1QnbsibsVWyM5pJmdeKkin60j35EqlQBhLfRD0jttkohhU1bjP3Dp6X4hDHwYImkxGIPI8y+fRcgGIHzaookbHa0Dy1sbHabWhCEt7LNnhaZq7vIUiP85b1QkamoeudP9Cxipz/spd8TBxPgK+fdsuwyccjhT56k75O6J5GridnPAbSfFYx65p+luZoc3G7nhjFKRjYgBwLHqDcYbWrwi/M3ocp143Ca+I9Pl3chcfoVzWYkciJCgPn1s9FuzhwDyR6D5xjGgLizyhiysGeF37e+tzAbfZbeDM48ItAKfN/rZJTD2Qo3mKTB5ieblFoMdCv00dSJwEZmUwjJbCnwYuX1yuGg42YigLJY2DlhTtEcKVTQihFfwg4IEz1ZvPCrL/Yc3oaHhEP7DHcu4KDAcwLtZztk0vj4jN3Gp2B6qODKyvjsfzQ+5mtYjDoDxzPveXhVmgjdRv7x+TsfHjkfT5IBKoKrgsN8NdOje5n8/NDrplBiAf6yjslK5+CMWC5TqiRM4YNyphixkGGCScjm4wViTuiL93Yjx+JnWhZBFvPGulFkKW4Z0mTB2K5H/9QHPWEKzC9UgknM7PGgODw2OGb9mXA6jhTab7vN7FDgbcGdd2gQ+k6QJQ/yd2Xj/mYOkGP/vvn+J13RfznnhYIAnOYU8wM2pj3FKWaJdnh1dugSNEah3wVKlb2Ya/J6ACUbAw46PYw8S6gebMnrcPPAjgExCCDYY45g6zb2TOm8CuSEIl0MzeHgdWCrg3TnXrF49m379t02e/G3+7ls55xHhtFXLE3i7YdWiuEWNztESmRl/I1MvgFhCddNLmRztMMnIZyYISr7mKx9KGsfVAtKPlRIHddCpz7FOKhIn9nsAEvj4nPQqxF5djpi2heQhtyKhsiSU4Gs4OuQORVvsFnPV2L+1As//3zepPm+nAfVlSCW3wXPQI7FfLznwMfiExmcj8jvlsnG2qGzqyzWcRdosybN75aGq8jge5fNbgTVVXxUlfOHI4dBaG/NjtO2f7Tvwismrl/N7o+3GypffCr5mihdeGFhffJiNZ43CflDRqZ9ZsTykKycgtjQqVTCQW8oDMGZ4vFGt8fkRKoLJiPw2DRqEFYdCQ5k3d74lsc3f/nE2BvOZ45Yv0ueuofOI9fdVx6jrYAh8ft3upOY/1UglAk3CZw6CVgTzZiEYG6XPj/HbIX2UFnPJFPIjp1yDlIJ3gF6lrCNHLnwNyg3BBoLW26nHFJQK6FFOx+847gDySyKnAkzAueCZ+Dzo0udw17mx5f52mTmTLpkQeTUhrEocxD6Es58xQFdypiBDAxYxeUlKOrC8mf8Z4VKyEjiIRHSekRr+fSjecRwyS66m+6kDwfoJrGfxvjcSxve00w99fjmttNJGelHb6S3DN31Tb+mnTPJGNK89f3XPuR5hcDv32n3M5s4Ux4ugOcC063UkCUPfZY8HFnyCGTJw350ebhUeXDkKFcOx6xkL/P2LA+ESy4gJa6SFJprRZkij0DReu+ZrqrfXv7438kGI6k+a91ZJ/5l1g/0ayv9QtSRA4svvWiF+Oy41sr+J3+0h/6++3L6t9IaAGzV/iCuW7bmai6HQnZfgl6UMN+gncshnh/FMpUcrNTIyTPyPkk5BFpSlJehJaUR1WFQtKQorSWlKBXwIHJ9SHYZVBSmOkNARaqACpFX2lnZhvhibjP6UTYASMhWnSJUndAxqI4e4fQ1paEs9SkkY4krS302frPnV/qNe93jXbWnmAxKa89JFmZtLColw4ljwWiuREyH6GrUoSIhJMR5t7XsYudjAMGoArlGDg7FdaoMdKowN0OniiMqSZmiU4VpnSpG6cHxCPmqnFxcCR87ZXN4cYdNgb1VBVmoCrKgTc4BQDKXuYyHeAJcxwpRx8r+UMdQbvXkaFq25In3Nm03HU3J+uvpPeTi4KHXVUXD85jcz85jDdO0dC0AiWvVGw+/pFQocPO+NKch8qnrq9n5mULd6sKo3kM9mYvXk7l28RqyFOAlZ1yHxBJIVy0iczMrXC4moHRgmvsLIWkKVGGm/LSJ2js1uzsLQbBHovb3sgEEe+Ntz+bV5v0TNdK+HuZO/gdz9/xfzz36R3PvkdTqqi6T74XjKhNCkcd5pRqmM8jLkdIZ5kxA6b3P2tmRz8stMGOuxEEDKtJYjtJDWaLUpbZLegf0UEJOk13msg+w3t0Y+/Qgmb0FMrl6Z+p2jZES0msFyb6nyQ1En3zOvp0Url3549pJS8cuvmbt079+PXU2swGmfEDeS86+nv7wyla69w53AQR5d/wzP9mZriM5HfEHL86oI4lroxjftXR2+HU4L7+pU0VpyOVmQa4S1PVyXAZvLiyNzoq84kYnWgjZMV0/j+kCPr8mlR4l0BeaEdl1lED9yGdkc5IO6Tx08ZvXrTjngnMXXEs3njSdWRK5ZB+tEun+I4//tqzllbaNj5Gp+XQF5quYr7AT60eGChz4DoAmmUGukrTaOPs6VCwYbU6V91zjgfAQFKpCEV2CYKo5k52dF6l2YWg/dC898khXmnbFs1Kp2nFMnIPEA7llt4ppY4gk3JiscQPuJpZEYf2c3ciZKKyccwqSAQarQg0pYGUp4M/YgdwgE9EXy0VTfFRT55SKr3+5Ys/SvcBJdcv8cdqEldxNvlT8qrn0CXrl06o+WzCXeloXfTaFZYcVOG7TeS5/qiFYxJI+d5qjHRuGgKrKhPJ0mDj0v+BExgU1qQQt36rWqhkvuv+XaUuPW3z92gdTfO6/0a/oC96cN+ref5schCQP189T0c86LVM/lXFq0uM0psdp7zpO+7GO0yOmxhnjmZ+fvvzs7ZEXNp1//qWzRWpTwNHor/SH3PxX2x5ZT9am8kBLdDr09U/8n+YMOV+wJZXY7Sk5x7WRC/DQfTT5SE9ZQwXzVeqPvv2JR8sbHi1ZeEzjQe3jyUKudj2lC7kvr/ijM47myydcRoRhtHXzQNNufbvN4mS+s92HpXuqc2/XQOm1t60H7usg+57l3u/Ys60HBmy6RBxNzkMWbPTvkcvHB/LL9u97d+qt6NTDzWYLp3x7m0aB5+vFu88cH/fuX/nwme7cPsBmSdwpfh+mb/rJTJ4BtZpYNrui0TQ1Ofd8gePP6+oERlbA0NH7uJsb8HKkfYuzXZRceBPpXe0ms8OJUXSo1+jQ6A0OpQzNyS6fdL1+SyzIbtugy+vcTI4j1+jJTeS4/9xDD6//VGMx0NPepOcbnNLiww9pp3KV1Dga5u0+fJH2NvrqpCOHFd3UnYi1i0rNjezwqfiHpmiqWpGJMY/3s1o8vD7RCQSwogmLgTCBqIxVZ7G6ctWxuguJQo/HtTOTIu9bX5mbc+R9dfXupZk8eVtaF0xDojzlpMwmy/u/sRk53ouH2Yx67G65PINjDmMA/lQMgOmXlVlPVqz1sDqNNRhmLkJUTaMbC6qNXOECEdnp4UWoRiAk1ft0/AprF4knX+Ej0Eo8tUr8iGUKWKBREtSUmLNBpt0lGmZk6/Si9ZBo/WVN8uvrNdkm0jZy9wp7xJQbka48tIxcQy9PG4aH3yZLQ49ULFgD80ReZGYf5gnVQrMgZzIj12cxI0dVZmQgGylhMy6phBmXlAOGOptxCwq1Jgfyq/ECOBry2ezzw3KBO5Vy1ZZFEH43Xh6RY5B6hYS5udoCzlpjgdO10Z5jKKmEhGrc5ZR9COVWn+JTjv63fMrZlqX7D9mVx2aL8Najki1L41Py/CXFu6zleqP7memNm8m0QmUdTmuOJ6U5znC8PCqbrcBvgyX4TGPYyQjmNRhnpT5efw8M5szawGxgPrbulLoSkujlauJBdN+UmmiyyVq4kmQ+l1aYi1QmhjNUVVmbImRQdEa3QiFmOCIqKiO+keJm0Cq6swHnGREGgA+b1p6aLO1pSGlPeRg6woqsgNehtsFX5nS251dCJ1MpkNk4AKxHoduOR0GV2ny8Iz7Fuy2XVjLTtSinvAaUJcpOFkATrXfJLf3Yzzan7MEISU1KeRr+a+XJFGRadTIZI3pRo+dS5DeqAo1UBduzKmkfV8VcqWqSZkMGBwZlPtwNaKdgBsmi8DUYFcxohO50QQUfEtbZmIElGfChZFHJm4Fu3chL443IlWYUjRBFZQ/0PKfEzsAgUcvy8UsDkP2iuFqrZafr75SIZUd+o/kbiZncuEBa/DK9agsdvhXURBwtnqucJbq52jYhJDQIMYgGFQocMD5g7IxXRXgJnTPK7JHOeHOko9FXaGWDbNRDlgLqbOshgdyKGlHBzpEKB/Tugx6AFduI1mEE6uiYMrQBxHyqlabWmbCW6dsQR1a2l7QBtGDCGUBcFI9Lzs3D7k9AxM6DPHu7kFsCtR6yvhFxRONWp2yyt6UVQmUa87ekQhs8ehaqUIjaVXVQohyTv/2h46Vr7x8x6fVpX0+b+/dXv01OMpJA/JGJD8+65t1BUzav+XPH/vsXrLry9lXiGrJ9zswLlpKGR9brdSOfG/dAXfj22yn9x+X0hTHPVBafN2vhlKdvu2315UwLpv5ryY1XMw/+cSbcf7K7yMY8vtU8MwC1OwmHyBvCOjx+uwMQ4ZgeWJi5ww5nCbswJGDyFjiasp1TvbsjiYBdDS8xrWAPICxkd8QF2GjEjYaHQamZhXPILiAHgmwAUnfJwrvhTGiyZZ+vac3xPp59kuo0uckdojP5g9iUvoYOXpVSohQ3GOd1qBYe6cqUVckOkTLOlFWm743noSbFmFUGxCpxH8zIy2YE/J9upM4q59RZ/IICGohapLRgMwy2yQXM1+gwuzQlgIMkF5azc9duK2rrzpZVdjS2rC73dK+cYmOyZXR778xiH6siS45UOMVF4erfv5Mul25BhMNzlZ46nxqPlwDhkDjN2QiH7lyVsA4KVm15HN7QncJiznG2aySzYk66OfGFhG2QZlfcwGsyYTZSM5CfcHg0fjLGrtZq7F++/R2lS/avZgbmBcxlfSt520+bX4p/bBVfH7bns0t39G2gy+iT9Gm6Upz6wbZdW9kcTmdr7kK+3Vzgd8c5+A1KDB3Kjjx8Dh59Ko7hsSNKikigGRbTWKCintQcRGeCTSF9NfYyBX2zyh0RLBVjfA6nizul+27ZmJj42JyDJJ8e+vzjf39+xdwLrzWRHZc/8MDYzeVBuvd3gR6iHxNh0/LV11yNHG+4Duy+h3UoFxqhV/VoaxEPhuPhqFxghQORxCOZC5OLaF1YYwhJgFr2sDZruaKZyyWHiiEoZfbBgsk5tcD6pmn775cu80Irz3h8tCVNjlavOHJ5itet52XWtil3W4rWTcvXndkNbox8R4SHFJkFM9e+mMusmO32gnC8ISr7mcyqU6wjxcx18xSDyZDLRQYqEUKVaK+ziez5CvZ8RViu8/F6tJSOyLnFEKUE8vQKJxOgE9GxRFeivLqBK07xMSpOdxMhlkl11YNCJVS5hVGzHkjZBd1VTDtRNQrWgrJp7lPlp+HxbKZzTqFAqFJ7ybpGtNl+qYhCk1y8JILwcPZd6fB1e8AGLeIuJiJXWA74OtsL8YkyHweNs0NI18uuTbkM4m4lFccQxDb2pkk9hrPJ4B5UqJeYdsoMbUvLgMe1N/QoA/JHMvD8L8mgh2B2bzLoMaz9Qw8y6C20PbC7DE5i++hkpgdw7vQHewstA6+pM9UaltETFg+H432jcpUVbC9EYwjtUs8YpSWsvdXiZwKIsCcjYbmV/fA7Um1iiSLM2hflMXMRsBpqQ5h2B0vLXiqCpVXkajcamvvi/YGNlU5Myllc2OSstI05lbYx13/TNtaLUP+4eez87gI+SgOZWN5dxsOYj/ME07OgEBb6Mi3DDjKs3lfbxzL6xgB5tC0qV1g5+GC/cLxsl1zN5Fh91CayeI4j3gJPN7C/N4TlFqaB/dnLGxCbzVmKvFp2pwyteEBxyhvMNKU8ugyMrdhU5lKaypxKU5nr2JvKehFw761lmu6C7a29TJrYVaoKV7C2DGOLpysMelqmt1aV/cZh8FlV8u0AcsO7c3jM0K1LUZhqfU6FcJJdem2YvnRifsbETHpeChJT9Kkk2ExKAB/fB2gGJaUDp/39LHImnb6U3J3cqLmC9ksSie6kBw63MYX4z94nyQ3bHqbjje89+9pnPHZXQSs1H2pD7JYfL6AjA4Q1cX+Yl3/k8iHaOxM6THrrABw9L3u0SHWcA+NLCA5slFfG6Fdw8VJjTBXOV5y2Y8rap+iieWRtcpPmNHriVwevOfzIt39+vbp27XWk5H7ydPs99DjPT6/d+PG8kYLKuSJN090iOJglfXp25QqUGTrDwJikUstpOG6ImeOGYPpCoxKIxs3OdoPDiYFGkzoH7ArT2drS6BdRzusWCxIoFdv8vkVjFN8ilvddhmSDQzxHWpwMXfptlXbaoZXiB49+d/huaf/69WneubHMp3FB1WYX3jkIEjv0aeL1bPo5Tzf6ORxT3OBKWJ1K+Oxo9HPeTOK5ceI53SjntOvZIDWKLH9msswXKoUrukuTLXsoKnusPBdflSlTCIH68QTFKGiQPQymJV2dJWknpNpkMzQZGHA/H4Owe9mx2QsQ6L5Luy1I98tV5Txn67MBfc6QsKb7CrFdyTx7l5XXtlSo69RuR0Qary9zxdpLDEaFvjgvLJf4eO0BOpZSm+zVsKW0uQIQBTTmQbCrsIyDTQAR4x/zCfYiisxFHtHDPdCNZ3Bgd0FoOZY80wHAoIY7YFZXNHkoyCsJx+uigEIQr2CyaEjhyVs49EChD8EJy6Argl8GKig1BEXLCuGUt3uNqYsTMfB6R6Hube27A8+/+/aOd9/Z8c57l/ZgZ3QFoZ9Cj9BfiZHoiEjM9Ffxpe52O2LTM50ALtYSoQ4YAlEWeSo6fRGyssZropCNjJczWdSjLHKYUW7NAb1ws/nn8C2hY09W6gqUoF9pGIissYMEanWQu5VZC+0aYx5y/xS45PIa2BVFeT0j3WcZ4ymc6iye6gx46jdUiRSqONXk9JRosqGpNTtVemq7AlItXpG2D/4/18D/NteAlLHnVK969dHl2qNXnRZyz451hujBsc61YHaZu9VGu18DbrWrFs3YY1yNY9+YXVbp9GPYn6mFE6/pfk5JWXuTe9VzFZnlq+tZxtazOAdlVmzAjdrAN6riVVt34fZ0O5CDSPWb3di3lFvcxv1ljTG/DPZjnStRWMJjY8U5x7AjswTV67Z8TRVEaReFISP+aHceeVlVInFESjAatDOXM13ienSXkDAonYPcR0I9chnE3vQod1cPmuPkmiPldSac6BQ5XczcAyUqhoIa0eCHVgTZCTEZhxfT8AZOQehyQvbBDdde3I+5nJQjpIRlStEDYqIqUQIOvSnVwJe+Yyo1hT5IN/3jqTMT0z79ypBcIF5r3dPxwLM39HDvN59Gr6Ht9H569YBt+cEvPt265aMTRXOPdz+TmWYB06WAUCY0QNWYX/V5nIQHZTv0Or+TyQzKEEvD8fqonM9kVslk1hiO5+xCR6eIR1trmB5B1L4oB/oB9WanXwfCqYHoqsHIydfRNBawyohAWhvy3MidEcdIDHdiit2qSDA278IYTG+X/8C7byJuF60lH1hWLj3jngGDHpt46BD95feEubtoqp47jtQ98qdrWtYXlNP99Ff6C/2sB6dFFCxMl75itrWPnZZNSvcF1EALijnIvIGAPuOgdNvUFmBZ6+RwwwRbdEiU2FL4OzGwSC3/JifXm406P+n3Ix024fr25RdPO+Pck+c3vIU29KCZpTkx8bcjOc88PKbg7fJJF2vngRmd4kMey6z9ANvzXfmQIfDNa+rhEDxWPmMYUI8sxm+irdyVuBitZdAbLp+fmXxKhXrwPrpJqDgcr43KuUxXQkxXwuG4f5dc4EPGQSjvrWK60sB+Fvh50WnQqTQ5Haske9GGXqW7rUcDuZu0JUuP+4TLfgOTfbFQCzUyXaRfGAby5ICVE77VIQs12sC8BrfCx1lJ8gAMAvK7zOLF+cYrwBE45tXqZdI9ruC2Hg3hblTUA3ucL66vHuprFA6cruub5sA5ZtVviUWBuDwKFOb4qNe1en7muG/znxv1XfWFhZ3sZ8+7IrD6Lk/4xT6B2F8GwM/MddrL1qlAqBBquq4T5N4h037s26PboHuU9WvZA+5x5/Q4XuwDYvsI4uM1cI9bU7V+pmiHU2eF3K4T2tIgaATd2wXheBWPkAcjag9yugtIraCHypMQexhCwB6lMgubk3N5kVO82MkbVboUY3VLiGclCpQCLd599WN3Bcuu2MJmLM333RWMz7uN7SeXUChUC8sV7DmlkKvDIWFO22GAqhLA2/dZeQdBjVrZ1e5G3zOH+56WdI1XuRkQNPBSCsvlPp71ywEAYMnhg8ob2VLE9mBpJRZ8OVQUyayCr6PLgBeB7cUSsHgP1lxmVRj2e2kGd5UA1odpRWmxYISTXIW6I4D2LGB7YS9dxmYVVlDp9d2sGZlc++mn0uJtR1xQzKXWFmrGa0Psvfsp/cVadp9rsblYi83FyscwcRkkoXtHcddPWSduoNE33tOGlG5iZoMCvoiB6a1J0dywcJ2QMEHcgB36ZguvVmCecofGbcJaRktXzW1IYQuIEYAXyFBe6BTmIC3xEKg9mmVh1Gc9FgrI4QB3qPWQ3wlW4b1hRlgGhfQZkUxLKtRwaG+LSbAU7CGiJ276Mz385Np71t7Zcf3t3VeVzP2anULb3n9t566/XbRo7jlabZc1PbhJKSiTEPfkTqbbPctGJTHPkI2hF9nYe5ON/aiysf+BbPjkj0k26/Z+tOfD3bs+euK6RfMv2n5hD3IZvVcboicDmur6MePHD9Jc0EUuhw4BYzTaL3V0soJ5mSvc2AX1EpjdHKaewC/zsKZF5F3cukjCiq3bVmhmNTnUbkFXOGHCThoTglGaJPzuZboMOWMTeLG2ABYWQ49LLkaO4fB3yW6PgsyUgVMJwGtIsAgwAxngmY7mlvM+vOm6sUOyUDSP7HBdRUbQJ267x8/jsiY6WcHUzAUvJAtVs4d5GrrO0951nlZHhzdPMGn/H804A6bTqs44C68zOYfNuJG+hDMWBS2dLBkRPyEgjElHD5WOcuALtJl4s6cDObJ5K6cj1dRt83EKdwGDgKKrXWtyurKbzNl3KXOIXbrNP6b/wWbzc1MLlG47r4WW893pJYJerMnaOYi/EIAoTmq8JHO8CZtPJbf4L4YuazlptdqYHuwy7qwOdbLgd+hPJ4nUqFOd6sm90KW+O0PMgGnJ7sytTM5OoX8ap0/i5lgH20iSFRqIkVbdFIEmUaQqwDwmBJ2ROV3Pad6bS1CwUAQGD0RyO/0HCdIbVJGuIeX0fbJWEeuireIgcM+TW7Ymr+Ud/NjDz8ZTir2qmeMh3cZj+MPxBJujKDAS9QYJNvL36dxPP1QE9f6P35P+XFSvPU1kkBAd9zRt5Y38RBhGNohR8WKw/iAxMYx8TzZs2cLH+D/92ziyUXOdeAH7mx94IWRi6oQvKChWqojhn4zTtJGNmzbx1+un/fHr9Q7l9QHNvWQmW0s9s1I5yLfeJhi1KThhXQ5iCMs6AZt44d+3uBDjPuCe0fRQ/7I9mvg4Yr/ot/3KWijvp4P3g53XISjvpw/HxV2ylr0fVHppRbVB2c3ezq/TBIYU7rZF57N/7t3he40m2Xv1+11D1ghfsvcqR04M8Q/eyc/fqd/Q4t328OVJotntS9Cvld5Zzb3iLzhPGyAUahTDlk82bo2oGI5svkA4YVAQyh3pqUMdlhYTaKZMMZS3uKNiWhrkqujCh4YUpqTi3UqM9ItXssagYyeyOgZjagwCBzbmM4treSLDnMPxSpRJQhkcrw+xZogumiXB/Wz61khakET7KcpTFKp+12iMKE+rMETgwIKKUFVY5f/m0/1AeqDTR/GHpmpQ6R5r02XfDSzdY6u/InnwG99blH3jC0CEpeRF8WzNp+ysqxfiRuRSMWhrlB+IMiPs6tDlwViUHyqeTIYlsHTp/HnLls+dt1x8++pVq1dedeMatOGX//6l9AYxKvmSMfD+srckiv0rQOBhz4tElMckXqZ+ko9TizCTvcPFf3Nh6qSjEH+DQBL7+FgvRknm4+Ujhx0/8oRhw0aKvpHDho884Xj2yK8+t/D4UWOHHjd+3LAuP2GvCjPF4zWb2XqUCKjVbGASzj2uiaAKYqusFpe6mfiNRD+OTHqQ/ovYHxTFHPLnKTROE1NRvmO6vxe7w5W3S78XgfeKGUmMeMkYYqf/WkdOoY+9RMaS8VPojBw6Q8B99532ZGkVz8EFwd8GsDOsLHNYwGQIQkdwDjMZpM54XqRDr8MnvFFZL3UiKUJFOK7ZJQfsnYkAtrAF8sAqCHiBjSgAT2gEzpcDObkANL4YsPC+UAE9Y9dYcZvs0HPXWKG0ZZZCRXOMHdEtKnegTs/uDb3Xz75juSyAm1X0WyGKK24qJ6Fvttw14ba51z5VQDbRfqJIrqXX9yfFq25auv5ruqeOfHJrWXDgrf8i7kntI9c9fGttU+hW+mHfrX2SP8JezRW3S1PwvAgICxXPyGiJsjlrMyGSdGxGBps7AsxHOZCQ75A4vaOkS6Ge6DBeq1Mhm5iGBbjpFEArWkFBxRvdzmykdpPF5YW8HD+qoe2HWcB5iC0TC2rY/35nrujetoZcs/PJ9jdu0Oo2z5d1WklYvDi5XWxjXxuTv4skOYrcuDj5m2iaS89X8IrKteVst1Rk9McpfSkdmjxBD7sRfyj3RKOzxAn/5PA/hP8Dspxn0QAAAHjanZNPaxNBGMafzR9baStt8SAoMhQPIu2mKUWkPcW0SCG00IgnL9PdcTNtshtmJ5QUBMEP4dFLL/0goncv6ifw6Mmb4LOTSf9YKqVZdve3s+8875v3fRbAwyBFgNFvFfueA8zjk+cSJvDTcxn3g8eeK5gPxvFVTAcfPN/CXPDF8wR2S+88T+Ju6Y/nKTwotzxPIyx/9jyDsPLS8x08qXz3PIvb1Xue5zBZXWUlQeU2nzquqoIDPMJHzyXu/ua5jKf45bmCR8GG5yruBW8938JCcOx5AsfBD8+TeFz66nkKz8rznqfxuqw9z5B/e76Dl5X3nmcxX614nsNsdQEb0Eh4Wp5HUIgheEo+S1KEDH0MYVxUh6sCJzxXsIw6j0XyC8ZkfNvlboEm2XBPcZVONUOKENjQibb6SMUillaKKOsPjU46VpyIleV6fVG8yLKkq0QzM/3MSKuzlLt2KKUoINCmXIrckUKPws8p3WWx2OmrVLRlmou26unnWZdruwxKMGCAZCXYVcmgKwl11lJn9eu8NijVJI2TjFMsXU5RD+vL6/VGu7leJCtyLZ3lunGRrxhkGD5qkjgtDq+UydkAUaTFdeq7ZlXaXYvJWjef2OkUHTrgWoY3l+ZZ7Cw8UUQNed9zq8Z1t1Cz7i+MfKNdtsitFP4ZPe9zCsbFxrxGp57IC1ecdUXnQgprZKx60hyI7M3YEDKNRU8OxZ4SRiU6t8rQRDoVkTJW8r4/MDqPdVRYJqdmg9KR++uxK+UqU6KRRyqNlTnvOTiXWwavocbj0B0ht10Ujbxk6KjHSHSs7a/VaoeHh6H0yhGFwyjr1W4ua9n2vmuwck5JGDtyTeg0exzUf1PbYV/FKtdJSlOFHdtjfMtNQrkpjGY3ONcuS+Fiyg0mlowbPV3cU3z5/9p3hSXRri3NCnLOaOCaaztKNPoy4s2/WRRjf6+Ey1d35ix56LqS8G33QhE5V1rY4nw3sU2bb/LT8EWc74hLHmYmqXVHBeS11lZzc7u9ueQKuPylnPkSl7+100/sLxGuTrwAAAB42m3VZZRWRQDG8ecZYBeW7k4FA5T39r0GeFNAwEAUAZUVll0Ed6kVwe5uxe4OVFBBsRXs7gIV7O7GOPs+x0/OOXP+986H+Z35MgODprGpDjPxP4OP/zsNm6EZmqMFKlCJlmiFKrRGG7RFO7RHB3REJ3RGF3RFN3RHD/REL/RGH/RFP/THAAzEIGyGzTEYQ7AFtsRW2BpDMQzbYFsMRwkWbDhw4cFHgBARtsP22AE7YgRGYifESJAiQ44CO2MURmMMdsFYjMN47IrdsDv2wATsiYnYC3tjEvbBZEzBVOyL/bA/pqGazXEcjsdSnIFTcRNb4BScjvW4GcvwBA7AWZiBZ1CDJ/E0nsPzeBEvoRav4zXU4WQciNmYgyvRgHmYi/lYgIOxCItxKA7DkTgKR2M1K1iJTfiLLdkKG7CRVWyNO7CcbdgW97Ed27MDO+JNrMNb7MTO7MKu7Mbu7MGe7MXe7MO+7Mf+HMCBHMTNuDkHcwi34JbciltzKIdxG27L4SzRok2HLj36DBgy4nbcnjtwR47gSO7EmAlTZsxZcGeO4miO4S4cy3Ecz125G3fnHpzAPTmRe3FvTuI+nMwpnMp9uR/35zRW8wBO5wzWcCZrWcdZPJCzOYcHsZ4NnMt5nM8FXMhGHsxFPISLuYSH8jAeziN4JI/i0TyGx/I4Hs8TeCJP4sk8hafyNJ7OM3gmz+LZPIfn8jyez6W8gBfyIl7MS3gpL+PlvIJX8ipezWt4La/j9byBN/Im3sxbeCuX8Tbezju4nCt4J+/i3VzJVbyH93I17+P9fIAP8iE+zEf4KB/jGq7l43yCT/IpPs1n+Cyf4/N8gS/yJb7MV/gqX+PrfINv8i2+zXf4LtdxPd/j+/yAG7iRH/IjfsxP+Ck/4+f8gl/yK37Nb/gtv+P3/IE/8if+zF/4K3/j7/yDf3IT/+LfBobGmGamuWlhKkylaWlamSrT2rQxbU070950MB1NJ9PZdDFdTTfT3fQwPU0v09v0MX1NP6zAnViJVViDu3A31uJE3GL640E8ZAaYgTjNDKqonbN4bp1V2Vg/q1QqZeXGJTWrjBtqG+prZldWq7laU27F+OrpjQtrKurLmVDOgnIml7OkKVWTZzQsrJ4+vaZ+YdWS/z6bHLdUUi3VVh3VVT3VVwM1VCM1VhM1VTM1V4tyLfmWfEu+Jd+Sb8m35FvyLfmWfEu+Jd+Sb8m35Fvybfm2fFu+Ld+Wb8u35dvybfm2fFu+Ld+Wb8u35dvyHfmOfEe+I9+R78h35DvyHfmOfEe+I9+R78h35DvyXfmufFe+K9+V78p35bvyXfmufFe+K9+V78p35bvyPfmefE++J9+T78n35HvyPfmefE++J9+T78n35Hvyffm+fF++L9+X78v35fvyffm+fF++L9+X78v35fvyA/mB/EB+ID+QH8gP5AfyA/mB/EB+ID+QH8gP5AfyQ/mh/FB+KD+UH8oP5YdyQ7mh3FBuKDeUG8oN5UZyI7mR3EhuJDeSG8mNdO5IfiQ/kh/Jj+RH8iP5kXzds24sP5Yfy4/lx/Jj+bH8WH4sP5Yfy4/lx/Jj+bH8RH4iP5GfyE/kJ/IT+Yn8RH4iP5GfyE/kJ/IT+Yn8VH4qP5Wfyk/lp/JT+an8VH4qP5Wfyk/lp/JT+an8TH4mP5Ofyc/kZ/Iz+Zn8TH4mP5Ofyc/kZ/Iz+Zn8XH4uP5efy8/l5/Jz+bn8XH4uP5efy8/l5/Jz+bn8Qn4hv5BfyC/kF/IL+YX8Qn4hv5BfyC/kF/IL+UWTb5fK7/6/tVRbdVRX9VRfDdRQjdS4XEv7WlbVzFm1jfNrZlQvqCsv2aK9onneOL+h6ccr0n8ATfJAqAAAAQAB//8ADwABAAAADAAAABYAAAACAAEAAQHFAAEABAAAAAIAAAAAeNpjYGRgYOBi8GHwY2BxcfMJYZBKrizKYVBJL0rNZtDLSSzJY7BgYAGqYfj/H0jgZwEBAGhUD5J42p2ZDZBW1XnHnwPLyi4u+4XIR9j4sSGsnVhLHT8o2iSlsDGOIqyKddFEhCQIKy+iBsENEt5IUQzBj5CDMVhpxtmxd3RiHIxMMtMzdVqb1AmT9DhGa6MNjXoSG5vq2hi2v+fcc9+P3SVNO3f+c+4977n3POd/no//va8YEWmWPrlOGhYtvrhPZq3avHGdzP3MxtU3yPx1n940IBdKA2NkZER07O9zbm5YvXFAJutZRINMiO1kMV3P6kjTMqF7QvfEWyZubRgET05qnNQHBiftoM0mNTaeCD5+Qu8JAycMTOqb3Nt05sRbmlY0rW3aB4Y4Owz0em3zhKZ9zRuaNzQdbt4w8ZaGJ/XgOX0gPxr14Ekc8Z54V3E0P9C8oeHJphU6vmktMw/qXE1nNj86ZW3LgeZH9Wg5NnVT6/a2eW0DU9a27Wk51jYAbPumlgNT1k7d1P4qV3va9ujINttmm1Z0HOxQC1d0dncc7Ozu3NW5q2Ooc5i2W3undU3r0r7clo4hvdaxncNttnN42uPTuloOtG4/aZaibeCkH3Xuon/X1E2dwwo99DphuOVA2x6eyV3tmzp3TVnbMTS9a8ZZMx6aecrM+TMPtQ10HNS25VhndwEdP72rY2jW9FmPzp7QuUtX0TE0+6w5ExTxLkYo5syb850579MCvbNretfjxW+K1u059ChsijMwa7WnQLECRWFnbtvMQw2DDYPRH7Yq8MXukZKcKz1yPlgAFso0WTSSyeKRsiwBveCiESdLwWVgGdfLaftoL6e9AqwAAzznRrABbOO3O3jGdvBFsIPrMvgSuBPsBHeBu8FucA/3fxnsAXu5/17uuZ/+r4L99H2d9hu0B7DtCc4PMeYwrQMvjHh5ieuXOX+N9ijt6yCAYfAeeB/8dsQZM1IyU0ErmDkSzOyRsjkVnA4+BHrAUsAazTqwnnG3gs+PeLOZ9jbaLbRbaQf5fRvtdnAP53vAXuYx8hE5JB+VuSNWzgDzwdngXGw7D1vPZ8wCsBBspH8zuA1sATxXbgeD4D6uHwQHGDfEvY9x/i3aZ2n/ATzH+ffh6fmRfjnC+Rv0vcXYt0esmQxmjPSbWbQfwK4ucArnp4FugG1mHljCWnppLwWXgeVc99FezvgrwdVc93O9kmddw/W1tJ+iXQVWg41c30S7mzFfBl8B++l7EDtaWHGG5RlWZ1ibYWWGlR4LPTNnzOyZMWNGz0wZM3n2dxJraQZzuToDfMQ0w6GHQx85PJ+nLAA5fx7+PPx5+FPOPJx55czgI+YZxndKK6PbQXd8guMJgScE+ROuF9JeAAY4vxFsAHvjE4I8DB4Bf4OnPI19h3lGc8Wuwqbj2aB+sIXxrdjZDk4jttSCUTPx5LJRXz6Zlfez8v4xM5wLzsOO82kXRJvdmFm38vvtYBBUWXCw0A8L/exG67F3pB2w/3Hl+aottlhssdhiixWbp4+9Yw4z9mPR+rbIX7GC0lj76F/EHIv5DY8iY5TIGCUyhiVjWDJGiYxhyRglMoYlY5TJGFau4t6/AFcD3fuVzFObRUavcRt9dzDPdvBFsIPrMvgSuBPsBHeBu8FucA9z4JVkFZuySn/k5n7Ovwr2xwjzZJcS2aUsf8X8B9nnb4OnQLEzTbDgYcCzeuUsYGHAwsBT1TM8o7ycwyjLKJt4yuApwFOApwBPAY48HHk48nDk4SjAUYCjAEcejgIceTgKcBTgSGfLmC1jtgw+AnwE+AjwEeDDw4eHDw8fHj48fHj48PDh4cPDh4cPDx8ePgJ8BPhQyzP4UG8N8OHhw8NHgI8AHx4+dGWWlVkqQ70Pl8d4wCJGLQZLAPmElfmaemFTvbCpXmSxXqyMsVBmdWVWVx5nty2rs6zOsjrL6iyrs6zOsjrL6iyrs6zOsjo7qoaUWZ1Nu21ZnY11JN9ty+oydtuz29X4ax6zX6P5vi/x00CkBiI1EF2B6AoypegZx6cDMwVmqo7mfnhslh5zCDzDufZorthCzxZ6tkh7naeod/RFTv73XS52U3dxNs9dxnOXjet7tU/9v/jRvfWzYPMybF5GnBSzFRn3tLjGZTF7MiJmUGXPwxX3gWc4P4seMmusFmWqRVmeovc59ukfaZ+nPUKfVo43wVupgjQC7qHOaY3LqHGZ+WNAfTB/DtAuqcLYWGHIPOYK2itpV8SKU9aKQ22z1DZPbbPUNk9Ns9Q0b1iheQCwSrMPfA1YQNagvnnzMHMc0nVh9+66PPkYFj6B1blKsagUS9X2VG1WxW5r1X6Rvp+Alxj/MuP+hd9eAf9K30/Bq+A1fvs32p+Bo4z5d9qfg9djtc9gI0PllOQX3PfLWP2t/Af4FXib3/6T9tfgv/j9Hdp3iYBhxr8HfsP1+7S/hQUDJrCqBjAJNLKqE6KK8KYJtHCeq6ayIb+ZTnASmAlm8ftsfptD+0FwCjiV69NoT6el4qGsSigObz4M5oEerlFF5hxwHlgILqT/o+DjnJNN2LnMXER7MbgkKhSPMiuhUjzqrGSW41l9jCGbsJuZIebYzYyd1F205jqwClzP2NW0a2g/x5gbOF8H1rMWKp8pxd225magSk9Vniq8QUAcGGLA7KSO7uJ3Mg1KR9VeCbXjUXwlFI9H9ZXMfdFbMjwlw0syPMSah8ABoFnmm2B0XTk5ekrhGd/PfTuyPisxqSwqg3MTc8qCMqD+qr66CqwG6q9qmVqlFmmemzPm6c/XzDDj95hlZZrp2spsNnK5cZwZ96dZ/6xSKx4jw4yNgoA1AWuceNqX8NKXues12qO0r4OQYnwYvAf+W9bgqR5PDXhqZibKGlYQkkdmrEJ1vK4k4Hm6moDn6YoCnqerCqwq4HXenM29i8GlXC+Nqwx4Uz2f17Pbyuka2txTsrjaeu/Q1Qc8QRkIeIKyEMzenIXKDvdU1OxQVO+Fai+ymo1ZrchozXFfarOZJ5t5spnqZZuyWSlls0Kh23GzWHWv8mz2BXBHXfbyFYXcXmRk9iqol8BtiB6yMu1+4WcbIw8BHgI8hLjrRRafXGR97A/YH7AxYGNVO0+Qx+WnZiesnFOpEEPRSzzchJj1eZqomvou+B59LlYCFyvBD5IPH6H/x9F7Ap6jXqHe4PGGYKYnywsbLuD8T2mXAFRIxaarYgUIlRV+FqwD6+nLV6lvfPq25w010ZTpvxfcnyrC15LPPwL+Ou54vsbZFZ2dv6fa+J6qq9F31R/Ed1XN7BarNatarLamI1l6VcUSfffUjGSxwmKFjVZUZkv6/KwaHn3i0cOjG8Wjr+HRRSuOgB9Ha8bjcDR/6n8+8efgzyX+6nkby5mHM62kDs4cnLkxfBl5F3/oitq5LapsrYmOrKB2ObJCICsEskIgIwQyQiAbqL0OWx2Rr1GvEa/RrlGuka1RHbDJEakapRqhGp2BHOzJwb6ibWfG/HO83PN+rG4+5pXTYyXzMY8sjVWomjeuj/kiz4qDsUL4mBNSPlAdlvSh1vk3aN8Ev4izBWI/UHNDrIG9tH0gr2eBGQIzhFi7bqLdEetMoM4E6kzg6aFSXwp92VTxipdibvWwpTuru1RlvhubUL0gt8lik0s2ZfErQiP8af0varvW79xGG78SXMHvKPlkq+afDFuzChu5zVm0eWe022G3w26H3VmN3WXsLsusGh2Ye/Jz8ftGFr21+HIwI2YYh3e66JW1XxEK77w6WqT5KyO6MyI6I1qreu3MSl6u3f2Cg9wLnHJQ5wkFHzNTxSl4qfWODycPUY4KL+lLynNFhScHT67Ga9wYr6nnylVydQd7S8YGT8Qoz4hyR3S7ur2eyjpbY2S6uOe3cr0ZbInqo8T+l2RHXcwNEYW5bs3kW5yzJ6Je4kC9dnVyhPZF2p/EWS0cZjX61aFfHfrVaZZDvzr0q8Zxhn516FcH16pbs6RbXdKtDt3q0KwOzeqSZlW9msF/hgroQbM69iFLX/IsmtWhBnrQrQ7d6tCsLmqbFtqp+JRm1nbOO+k7iXYmyPVqlnRqlnRqlnRqVtFAPZzPZ/zZPP8c2vPAQlDVqQ6d6lATPWYJuIjzi8ElINeqWdKqWdSqGiNX01b1qRujNnJ9qqoji9n/Rs5LINenjl0ss4tldrGMv2QVfbqL3+4GuTbNkjbNkjbNojbN9agz+k2oqkfrcyG1C4bb4666pMtcXW6sjYZqBj5+flw/jmc/TZ/67CnEoCMGHdHuUAZriHgXa1Qe8a5OG9VHvUtR71LU61ud1iNXifpcC2XpjS5XcPujLtd844glF99EowWVnlNjDKBSanRzYUcW7VD/OlkuiDngePq5t0ZD96VMVOTGVSnuV9OuSfmxXrlnvBdo9autfG+Nqn6/q+oVFUOrxejqp18vuivfGVWT5ryrLu2F93LSpFniXd+uy/BegvdS0qD480hvfPfSN2p9m841aAbv5cR7OWnQ+rVupD/fh3Lah/zb5PRKNs6/YftYfUZXnmrVqc2kY+vvgzXKdkpNJXFaRSq6pqpncj2o32s21by75JlwvCyoHvFCfIOvzYD2d2Q+W5P5LPtpU9bLxmQ9zXjvxjiz7LWtyXqWrJf9P7OeT1nPpqxnU9azKevZmqxnx816tdlubKazKdNVFcB1cecz9iQ7TkbLKhnt87E2lc1tsT6VzVbaQcZ+gV3ZxvkdtNtp67OcTVnOpixno6IoMlztl9tCCVV1bmvUhqFOCRWZqPCWcp3ueDPFYP7dKRxHg5Qr35nyqPA12SikbBRSNgp1Ki7PTKGSh9qwyGKRrXz1Kr549aacUo2C/CvVvvR1ijcOnmClkTVUvX15tCt6usytrFZj/7nKtwH9b8al6FOdU6xSo1CfopEYiMSADS4+sS/Gj9oSYv5dQdtP3+j8OzYPjJ+PJ8WvE0VMp1jmrfFj/DIp/nM+hfeFVt5XJ7JnPazxTPlDOVHmy9kyVc6VC/llkSxG0/fKJ+QD8kmOLrmE44OyVJZTcS7n6JYrOT4kV0k/XFzDcYYMyC3yB7JZBnnSNtkuC6QsO+UCuUt2M/tX5D6e+4Ds47kPcnxSDsjDcrE8wnEJyukxuVSekCdlmTzFcYUcksPM8F35HjP8Lcc18izHtfL38k/yKfkh+ukz8iP5Z/mcvMCxTl6UV2S9vMpxkxzl2CQ/57hZ3pBfYtev5G3ZIr+Wd+R2GZbfyDZjTIPsMI2mUXaayeZE+Usz1bTLPWa6mS57zQwzT+41f2Quk4NmublG/s582qyRH5rPmvXizQaD5jWbzM3yirnV3Mb7+FazVX5mBs2dctTsNigx83XzkBwzD5tvGjHfNt9hpsMcJ/4PmZksRwAAAAAAAQAAAADUJJi6AAAAAMlM6n0AAAAA1fuw3gABWdYAXgAA') format('woff');\n    font-weight: 600;\n    font-style: normal;\n}\n\n@font-face {\n    font-family: 'Open Sans';\n    src: url('data:application/font-woff;base64,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') format('woff');\n    font-weight: bold;\n    font-style: normal;\n}\n\n.weight-regular {\n  font-family: \"Open Sans\", Arial, sans-serif;\n  font-weight: 400;\n}\n.weight-medium {\n  font-family: \"Open Sans\", Arial, sans-serif;\n  font-weight: 600;\n}\n.weight-bold {\n  font-family: \"Open Sans\", Arial, sans-serif;\n  font-weight: 700;\n}\n.form-ui {\n  position: relative;\n  display: inline-block;\n  vertical-align: top;\n  margin: 0;\n  line-height: 20px;\n  font-weight: 400;\n  cursor: pointer;\n}\n.form-ui-control {\n  position: absolute;\n  top: -9999px;\n  left: -9999px;\n  width: 0;\n  height: 0;\n  overflow: hidden;\n  clip: rect(0, 0, 0, 0);\n  outline: 0 none;\n}\n.form-ui-txt {\n  position: relative;\n  display: inline-block;\n  vertical-align: top;\n  padding: 2px 0 0 30px;\n}\n.form-ui-txt:before {\n  content: '';\n  position: absolute;\n  top: 0;\n  left: 0;\n  width: 22px;\n  height: 22px;\n}\n.form-ui-txt:after {\n  content: '';\n  position: absolute;\n}\ninput[type=\"radio\"] + .form-ui .form-ui-txt:before {\n  border: 1px solid #cfcfcf;\n  border-radius: 50%;\n}\ninput[type=\"radio\"] + .form-ui .form-ui-txt:after {\n  top: 7px;\n  left: 7px;\n  width: 8px;\n  height: 8px;\n  border-radius: 50%;\n}\ninput[type=\"radio\"]:disabled + .form-ui .form-ui-txt:before {\n  background: #f2f2f2;\n  opacity: 0.6;\n}\ninput[type=\"radio\"]:disabled + .form-ui .form-ui-txt:after {\n  opacity: 0.6;\n}\ninput[type=\"checkbox\"] + .form-ui .form-ui-txt:after {\n  top: 7px;\n  left: 5px;\n  width: 13px;\n  height: 6px;\n  border-bottom: 2px solid transparent;\n  border-left: 2px solid transparent;\n  transform: rotate(-45deg);\n}\ninput[type=\"checkbox\"]:disabled + .form-ui .form-ui-txt:before {\n  opacity: 0.6;\n}\ninput[type=\"checkbox\"]:disabled + .form-ui .form-ui-txt:after {\n  opacity: 0.6;\n}\n.btn {\n  display: inline-block;\n  margin-bottom: 0;\n  padding: 10px 20px;\n  font-size: 13px;\n  line-height: 18px;\n  text-align: center;\n  text-decoration: none;\n  vertical-align: middle;\n  cursor: pointer;\n  background-image: none;\n  border: 1px solid transparent;\n  white-space: nowrap;\n  user-select: none;\n}\n.btn:hover {\n  color: #000;\n  text-decoration: none;\n}\n.btn:active,\n.btn.active {\n  outline: none;\n}\n.btn:focus {\n  outline: none;\n  box-shadow: inset 0 0 0 1px #fff;\n}\n.btn[disabled],\n.btn.disabled {\n  cursor: default;\n  box-shadow: none;\n  opacity: 0.5;\n  pointer-events: none;\n}\n.btn-default {\n  border-color: #58595b;\n  background: #58595b;\n  color: #fff;\n}\n.btn-default:hover {\n  border-color: #717275;\n  background: #717275;\n  color: #fff;\n}\n.btn-default.active,\n.btn-default:active {\n  border-color: #717275;\n  background: #717275;\n}\n.btn-default.disabled,\n.btn-default[disabled] {\n  border-color: #58595b;\n  background: #58595b;\n}\n@media (max-width: 320px) {\n  .btn-another-el {\n    font-size: 9px;\n    padding-left: 0;\n    padding-right: 0;\n    background-color: transparent;\n    border: 0;\n    color: #000;\n  }\n  .btn-another-el:hover {\n    border-color: transparent;\n    background: transparent;\n    color: #000;\n  }\n}\n.btn-lg {\n  font-size: 20px;\n  padding: 14px 24px 12px;\n}\n.btn-sm {\n  font-size: 16px;\n  padding-top: 14px;\n  padding-bottom: 14px;\n}\n.btn-xs {\n  font-size: 14px;\n  padding-top: 12px;\n  padding-bottom: 12px;\n}\n.btn-block {\n  display: block;\n  width: 100%;\n  padding-left: 0;\n  padding-right: 0;\n}\n.btn-block + .btn-block {\n  margin-top: 5px;\n}\ninput[type=\"submit\"].btn-block,\ninput[type=\"reset\"].btn-block,\ninput[type=\"button\"].btn-block {\n  width: 100%;\n}\n.btn-upload {\n  position: relative;\n  overflow: hidden;\n}\n.btn-upload input[type=file] {\n  position: absolute;\n  top: 0;\n  right: 0;\n  margin: 0;\n  font-size: 600%;\n  line-height: 600%;\n  width: auto;\n  height: auto;\n  opacity: 0;\n  cursor: pointer;\n}\n@media (prefers-color-scheme: light) {\n  body {\n    color: #282828;\n  }\n  .main {\n    background: #ffffff;\n  }\n  .main-popup__btn {\n    background: #ffffff;\n    border: 1px solid #cfcfcf;\n  }\n  .main-popup__btn:hover {\n    background-color: #efefef;\n  }\n  .main-menu__btn {\n    background-color: #ffffff;\n  }\n  .main-menu__btn:hover {\n    background-color: #efefef;\n  }\n  .main-menu__btn:active,\n  .main-menu__btn.active {\n    background-color: #f3f3f3;\n  }\n  .main-version {\n    color: #dfdfdf;\n  }\n  .head_title {\n    color: #343434;\n  }\n  .head_text {\n    color: #343434;\n  }\n  .element-rule_expand-link_txt {\n    color: #36ba53;\n    border-bottom: 1px solid #36ba53;\n  }\n  .element-rule_expand-link:hover .element-rule_expand-link_txt {\n    color: #36ba53;\n    border-bottom-color: #36ba53;\n  }\n  .element-rule_form-cont {\n    border-top: 1px solid #e0dfdb;\n    background: #f4f4ef;\n  }\n  .tick {\n    border: 20px solid #ffffff;\n    border-left: 1px solid #ffffff;\n    border-right: 1px solid #ffffff;\n  }\n  .close {\n    background: url(" + ___CSS_LOADER_URL_REPLACEMENT_0___ + ") no-repeat 0 0 / cover;\n    opacity: 0.6;\n  }\n  .close:hover {\n    opacity: 0.8;\n  }\n  .form-control {\n    color: #343434;\n    background: #ffffff;\n    border: 1px solid #cfcfcf;\n  }\n  input[type=\"checkbox\"] + .form-ui .form-ui-txt:before {\n    border: 1px solid #cfcfcf;\n    background: #ffffff;\n  }\n  input[type=\"checkbox\"]:checked + .form-ui .form-ui-txt:before {\n    border: 1px solid #36ba53;\n    background: #36ba53;\n  }\n  input[type=\"checkbox\"]:checked + .form-ui .form-ui-txt:after {\n    border-bottom-color: #ffffff;\n    border-left-color: #ffffff;\n  }\n  .menu,\n  .menu-filter,\n  .content,\n  .foot {\n    border-top: 1px solid #e0dfdb;\n  }\n  .settings_fieldset {\n    border-top: 1px solid #e0dfdb;\n  }\n  .btn-primary {\n    border-color: #36ba53;\n    background: #36ba53;\n    color: #fff;\n  }\n  .btn-primary:hover {\n    border-color: #30a64a;\n    background: #30a64a;\n    color: #fff;\n  }\n  .btn-primary.active,\n  .btn-primary:active {\n    border-color: #30a64a;\n    background: #30a64a;\n  }\n  .btn-primary.disabled,\n  .btn-primary[disabled] {\n    border-color: #30a64a;\n    background: #30a64a;\n  }\n  .btn-cancel {\n    border-color: #f3523d;\n    background: #f3523d;\n    color: #fff;\n  }\n  .btn-cancel:hover {\n    border-color: #ee290f;\n    background: #ee290f;\n    color: #fff;\n  }\n  .btn-cancel.active,\n  .btn-cancel:active {\n    border-color: #ee290f;\n    background: #ee290f;\n  }\n  .btn-cancel.disabled,\n  .btn-cancel[disabled] {\n    border-color: #ee290f;\n    background: #ee290f;\n  }\n  .ui-slider-handle:after {\n    background: #36ba53;\n  }\n  .change-position_input:checked + .change-position_label {\n    border-color: #36ba53;\n    background: #36ba53;\n  }\n  input[type=\"radio\"] + .form-ui .form-ui-txt:before {\n    background: #ffffff;\n  }\n  input[type=\"radio\"]:checked + .form-ui .form-ui-txt:after {\n    background: #36ba53;\n  }\n  .menu-head_title {\n    color: #343434;\n  }\n  .menu-head_text {\n    color: #343434;\n  }\n  .menu-filter_handle {\n    background: #ffffff;\n  }\n}\n@media (prefers-color-scheme: dark) {\n  body {\n    color: #ddd;\n  }\n  .main {\n    background: #323232;\n  }\n  .main-popup__btn {\n    background: #323232;\n    border: 1px solid #666;\n  }\n  .main-popup__btn:hover {\n    background-color: #555555;\n  }\n  .main-menu__btn {\n    background-color: #323232;\n  }\n  .main-menu__btn:hover {\n    background-color: #555555;\n  }\n  .main-menu__btn:active,\n  .main-menu__btn.active {\n    background-color: #4d4d4d;\n  }\n  .main-version {\n    color: #444;\n  }\n  .head_title {\n    color: #ccc;\n  }\n  .head_text {\n    color: #ccc;\n  }\n  .element-rule_expand-link_txt {\n    color: #67B279;\n    border-bottom: 1px solid #67B279;\n  }\n  .element-rule_expand-link:hover .element-rule_expand-link_txt {\n    color: #4D995F;\n    border-bottom-color: #4D995F;\n  }\n  .element-rule_form-cont {\n    border-top: 1px solid #444;\n    background: #555;\n  }\n  .tick {\n    border: 20px solid #323232;\n    border-left: 1px solid #323232;\n    border-right: 1px solid #323232;\n  }\n  .close {\n    background: url(" + ___CSS_LOADER_URL_REPLACEMENT_1___ + ") no-repeat 0 0 / cover;\n    opacity: 0.7;\n  }\n  .close:hover {\n    opacity: 1;\n  }\n  .form-control {\n    color: #ccc;\n    background: #323232;\n    border: 1px solid #666;\n  }\n  input[type=\"checkbox\"] + .form-ui .form-ui-txt:before {\n    border: 1px solid #666;\n    background: #323232;\n  }\n  input[type=\"checkbox\"]:checked + .form-ui .form-ui-txt:before {\n    border: 1px solid #4D995F;\n    background: #4D995F;\n  }\n  input[type=\"checkbox\"]:checked + .form-ui .form-ui-txt:after {\n    border-bottom-color: #323232;\n    border-left-color: #323232;\n  }\n  .menu,\n  .menu-filter,\n  .content,\n  .foot {\n    border-top: 1px solid #444;\n  }\n  .settings_fieldset {\n    border-top: 1px solid #444;\n  }\n  .btn-primary {\n    border-color: #4D995F;\n    background: #4D995F;\n    color: #fff;\n  }\n  .btn-primary:hover {\n    border-color: #39774C;\n    background: #39774C;\n    color: #fff;\n  }\n  .btn-primary.active,\n  .btn-primary:active {\n    border-color: #39774C;\n    background: #39774C;\n  }\n  .btn-primary.disabled,\n  .btn-primary[disabled] {\n    border-color: #39774C;\n    background: #39774C;\n  }\n  .btn-cancel {\n    border-color: #8E2C13;\n    background: #8E2C13;\n    color: #fff;\n  }\n  .btn-cancel:hover {\n    border-color: #732613;\n    background: #732613;\n    color: #fff;\n  }\n  .btn-cancel.active,\n  .btn-cancel:active {\n    border-color: #732613;\n    background: #732613;\n  }\n  .btn-cancel.disabled,\n  .btn-cancel[disabled] {\n    border-color: #732613;\n    background: #732613;\n  }\n  .ui-slider-handle:after {\n    background: #4D995F;\n  }\n  .change-position_input:checked + .change-position_label {\n    border-color: #4D995F;\n    background: #4D995F;\n  }\n  input[type=\"radio\"] + .form-ui .form-ui-txt:before {\n    background: #323232;\n  }\n  input[type=\"radio\"]:checked + .form-ui .form-ui-txt:after {\n    background: #4D995F;\n  }\n  .menu-head_title {\n    color: #ccc;\n  }\n  .menu-head_text {\n    color: #ccc;\n  }\n  .menu-filter_handle {\n    background: #323232;\n  }\n}\n", ""]);
// Exports
module.exports = exports;


/***/ }),

/***/ 2571:
/***/ ((module, exports, __nested_webpack_require_223876__) => {

// Imports
var ___CSS_LOADER_API_IMPORT___ = __nested_webpack_require_223876__(3645);
var ___CSS_LOADER_GET_URL_IMPORT___ = __nested_webpack_require_223876__(1667);
var ___CSS_LOADER_URL_IMPORT_0___ = __nested_webpack_require_223876__(9053);
exports = ___CSS_LOADER_API_IMPORT___(false);
var ___CSS_LOADER_URL_REPLACEMENT_0___ = ___CSS_LOADER_GET_URL_IMPORT___(___CSS_LOADER_URL_IMPORT_0___);
// Module
exports.push([module.id, ":host {\n  display: block!important;\n  position: relative!important;\n  width: 0!important;\n  height: 0!important;\n  margin: 0!important;\n  padding: 0!important;\n  z-index: 2147483647!important;\n}\n:host ::after,\n:host ::before {\n  display: none!important;\n}\n.adguard-assistant-button-main-logo {\n  background-image: url(" + ___CSS_LOADER_URL_REPLACEMENT_0___ + ") !important;\n}\n.adguard-alert {\n  cursor: pointer;\n  left: 0;\n  top: 0;\n  position: fixed !important;\n  z-index: 2147483647 !important;\n  width: 40px !important;\n  height: 40px !important;\n  zoom: 1 !important;\n  display: inline-block !important;\n  margin: 0 !important;\n  border: 0 !important;\n  padding: 0 !important;\n  will-change: transform;\n  opacity: 1;\n  touch-action: none;\n  -ms-touch-action: none;\n  visibility: visible !important;\n  min-height: auto !important;\n  max-height: auto !important;\n  min-width: auto !important;\n  max-width: auto !important;\n  background-size: 21px!important;\n  background-position: center center!important;\n  background-repeat: no-repeat !important;\n  background-color: #fff !important;\n  border: none !important;\n  box-shadow: 0 0 10px 3px rgba(162, 161, 161, 0.3) !important;\n  border-radius: 100% !important;\n  transition: background-color 0.3s ease;\n}\n.adguard-alert.sg_hide_element {\n  display: none!important;\n}\n.adguard-alert.logo-small {\n  width: 24px !important;\n  height: 24px !important;\n  background-position: 50% 6px!important;\n  background-size: 14px!important;\n}\n.adguard-alert:hover {\n  background-color: #ccf0d4 !important;\n}\n@media print {\n  .adguard-alert {\n    display: none!important;\n  }\n}\n.adguard-assistant-button-right {\n  left: auto;\n  right: 0;\n}\n.adguard-assistant-button-left {\n  left: 0;\n  right: auto;\n}\n.adguard-assistant-button-top {\n  top: 0;\n  bottom: auto;\n}\n.adguard-assistant-button-bottom {\n  top: auto;\n  bottom: 0;\n}\n.adguard-assistant-button-top.adguard-assistant-button-left {\n  left: 0;\n  right: auto;\n  transform: translate3d(10px, 10px, 0);\n}\n.adguard-assistant-button-top.adguard-assistant-button-right {\n  left: auto;\n  right: 0;\n  transform: translate3d(-10px, 10px, 0);\n}\n.adguard-assistant-button-bottom.adguard-assistant-button-left {\n  left: 0;\n  right: auto;\n  transform: translate3d(10px, -10px, 0);\n}\n.adguard-assistant-button-bottom.adguard-assistant-button-right {\n  left: auto;\n  right: 0;\n  transform: translate3d(-10px, -10px, 0);\n}\n.adguard-assistant-button-bottom.adguard-assistant-button-respect-vk {\n  transform: translate3d(-70px, -5px, 0);\n}\n.adguard-assistant-button-bottom.adguard-assistant-button-respect-fb {\n  transform: translate3d(-5px, -40px, 0);\n}\n", ""]);
// Exports
module.exports = exports;


/***/ }),

/***/ 6469:
/***/ ((module, exports, __nested_webpack_require_227117__) => {

// Imports
var ___CSS_LOADER_API_IMPORT___ = __nested_webpack_require_227117__(3645);
var ___CSS_LOADER_GET_URL_IMPORT___ = __nested_webpack_require_227117__(1667);
var ___CSS_LOADER_URL_IMPORT_0___ = __nested_webpack_require_227117__(8115);
var ___CSS_LOADER_URL_IMPORT_1___ = __nested_webpack_require_227117__(1660);
var ___CSS_LOADER_URL_IMPORT_2___ = __nested_webpack_require_227117__(1372);
var ___CSS_LOADER_URL_IMPORT_3___ = __nested_webpack_require_227117__(6112);
var ___CSS_LOADER_URL_IMPORT_4___ = __nested_webpack_require_227117__(9919);
var ___CSS_LOADER_URL_IMPORT_5___ = __nested_webpack_require_227117__(9023);
var ___CSS_LOADER_URL_IMPORT_6___ = __nested_webpack_require_227117__(6810);
var ___CSS_LOADER_URL_IMPORT_7___ = __nested_webpack_require_227117__(2307);
var ___CSS_LOADER_URL_IMPORT_8___ = __nested_webpack_require_227117__(7062);
var ___CSS_LOADER_URL_IMPORT_9___ = __nested_webpack_require_227117__(6255);
var ___CSS_LOADER_URL_IMPORT_10___ = __nested_webpack_require_227117__(9385);
var ___CSS_LOADER_URL_IMPORT_11___ = __nested_webpack_require_227117__(8225);
var ___CSS_LOADER_URL_IMPORT_12___ = __nested_webpack_require_227117__(6523);
var ___CSS_LOADER_URL_IMPORT_13___ = __nested_webpack_require_227117__(2286);
var ___CSS_LOADER_URL_IMPORT_14___ = __nested_webpack_require_227117__(2668);
var ___CSS_LOADER_URL_IMPORT_15___ = __nested_webpack_require_227117__(1823);
exports = ___CSS_LOADER_API_IMPORT___(false);
var ___CSS_LOADER_URL_REPLACEMENT_0___ = ___CSS_LOADER_GET_URL_IMPORT___(___CSS_LOADER_URL_IMPORT_0___);
var ___CSS_LOADER_URL_REPLACEMENT_1___ = ___CSS_LOADER_GET_URL_IMPORT___(___CSS_LOADER_URL_IMPORT_1___);
var ___CSS_LOADER_URL_REPLACEMENT_2___ = ___CSS_LOADER_GET_URL_IMPORT___(___CSS_LOADER_URL_IMPORT_2___);
var ___CSS_LOADER_URL_REPLACEMENT_3___ = ___CSS_LOADER_GET_URL_IMPORT___(___CSS_LOADER_URL_IMPORT_3___);
var ___CSS_LOADER_URL_REPLACEMENT_4___ = ___CSS_LOADER_GET_URL_IMPORT___(___CSS_LOADER_URL_IMPORT_4___);
var ___CSS_LOADER_URL_REPLACEMENT_5___ = ___CSS_LOADER_GET_URL_IMPORT___(___CSS_LOADER_URL_IMPORT_5___);
var ___CSS_LOADER_URL_REPLACEMENT_6___ = ___CSS_LOADER_GET_URL_IMPORT___(___CSS_LOADER_URL_IMPORT_6___);
var ___CSS_LOADER_URL_REPLACEMENT_7___ = ___CSS_LOADER_GET_URL_IMPORT___(___CSS_LOADER_URL_IMPORT_7___);
var ___CSS_LOADER_URL_REPLACEMENT_8___ = ___CSS_LOADER_GET_URL_IMPORT___(___CSS_LOADER_URL_IMPORT_8___);
var ___CSS_LOADER_URL_REPLACEMENT_9___ = ___CSS_LOADER_GET_URL_IMPORT___(___CSS_LOADER_URL_IMPORT_9___);
var ___CSS_LOADER_URL_REPLACEMENT_10___ = ___CSS_LOADER_GET_URL_IMPORT___(___CSS_LOADER_URL_IMPORT_10___);
var ___CSS_LOADER_URL_REPLACEMENT_11___ = ___CSS_LOADER_GET_URL_IMPORT___(___CSS_LOADER_URL_IMPORT_11___);
var ___CSS_LOADER_URL_REPLACEMENT_12___ = ___CSS_LOADER_GET_URL_IMPORT___(___CSS_LOADER_URL_IMPORT_12___);
var ___CSS_LOADER_URL_REPLACEMENT_13___ = ___CSS_LOADER_GET_URL_IMPORT___(___CSS_LOADER_URL_IMPORT_13___);
var ___CSS_LOADER_URL_REPLACEMENT_14___ = ___CSS_LOADER_GET_URL_IMPORT___(___CSS_LOADER_URL_IMPORT_14___);
var ___CSS_LOADER_URL_REPLACEMENT_15___ = ___CSS_LOADER_GET_URL_IMPORT___(___CSS_LOADER_URL_IMPORT_15___);
// Module
exports.push([module.id, ".close {\n  position: absolute;\n  top: 10px;\n  right: 10px;\n  display: inline-block;\n  vertical-align: top;\n  width: 1em;\n  font-size: 12px;\n  line-height: 1;\n  cursor: pointer;\n  transition: opacity 0.3s ease;\n}\n.close:before {\n  content: \"\\00a0\";\n}\n@media (max-width: 320px) {\n  .close {\n    font-size: 15px;\n    top: 18px;\n    right: 14px;\n  }\n}\n.a-logo {\n  display: inline-block;\n  vertical-align: top;\n  width: 40px;\n  height: 40px;\n  padding: 10px 0 0;\n  font-size: 20px;\n  text-align: center;\n  border: 1px solid #cdcdcd;\n  border-radius: 50%;\n  background: #fff;\n}\n.a-logo__small {\n  width: 24px;\n  height: 24px;\n  font-size: 12px;\n  padding: 6px 0 0;\n}\n.tooltip {\n  position: relative;\n}\n.tooltip:before {\n  display: none;\n  content: attr(data-title);\n  position: absolute;\n  top: 100%;\n  left: 50%;\n  width: 170px;\n  margin: 7px 0 0 -85px;\n  padding: 6px 0 5px;\n  font-size: 10px;\n  font-style: normal;\n  font-weight: 500;\n  color: #fff;\n  text-align: center;\n  white-space: nowrap;\n  border-radius: 4px;\n  background: rgba(0, 0, 0, 0.8);\n}\n.tooltip:after {\n  display: none;\n  content: '';\n  position: absolute;\n  top: 100%;\n  left: 50%;\n  margin: 3px 0 0 -4px;\n  border-bottom: 4px solid rgba(0, 0, 0, 0.8);\n  border-left: 4px solid transparent;\n  border-right: 4px solid transparent;\n}\n.tooltip:hover:before,\n.tooltip:hover:after {\n  display: block;\n}\n.main {\n  position: relative;\n}\n.head {\n  padding: 18px 20px;\n  cursor: move;\n}\n.head_title {\n  font-size: 16px;\n  font-weight: 700;\n}\n.head_text {\n  margin: 4px 0 0;\n  font-size: 12px;\n}\n.foot {\n  padding: 20px;\n}\n.foot_action {\n  float: right;\n}\n.foot_action_btn {\n  font-size: 0;\n}\n.foot_action_btn .btn + .btn {\n  margin-left: 10px;\n}\n.foot .cf {\n  clear: right;\n}\n.element-rule {\n  padding: 20px;\n}\n.element-rule_slider {\n  margin: 5px 0 7px;\n  user-select: none;\n}\n@media (max-width: 320px) {\n  .element-rule_slider {\n    display: none;\n  }\n}\n.element-rule_expand-link {\n  font-size: 12px;\n  line-height: 15px;\n  font-weight: 500;\n  cursor: pointer;\n}\n.element-rule_expand-link_txt {\n  display: inline-block;\n  vertical-align: top;\n}\n.element-rule_expand-link_arr {\n  display: inline-block;\n  vertical-align: top;\n  width: 5px;\n  height: 5px;\n  margin: 3px 0 0 3px;\n  border-bottom: 1px solid #91a795;\n  border-left: 1px solid #91a795;\n  transform: rotate(-45deg);\n  transition: 0.2s;\n}\n.element-rule_expand-link.active .element-rule_expand-link_arr {\n  margin-top: 5px;\n  transform: rotate(-225deg);\n}\n.element-rule_form {\n  height: 0;\n  margin: 0 -20px;\n  overflow: hidden;\n}\n.element-rule_form.open {\n  height: auto;\n  margin-bottom: -20px;\n}\n@media (max-width: 320px) {\n  .element-rule_form.open {\n    padding: 20px;\n    padding-top: 0;\n  }\n}\n.element-rule_form-cont {\n  margin: 4px 0 0;\n  padding: 20px;\n}\n@media (max-width: 320px) {\n  .element-rule_form-cont {\n    margin-top: 0;\n  }\n}\n.element-rule_fieldset {\n  margin: 10px 0 0;\n}\n.element-rule_fieldset:first-child {\n  margin: 0;\n}\n.element-rule_more--mobile {\n  display: none;\n}\n@media (max-width: 320px) {\n  .element-rule_more--mobile {\n    display: block;\n  }\n  .element-rule_more--mobile .element-rule_expand-link {\n    display: none;\n  }\n  .element-rule_more--mobile #adg-cancel {\n    width: 106px;\n    padding: 10px 7px;\n  }\n  .element-rule_more--mobile #adg-accept {\n    padding: 10px 6px;\n  }\n}\n.adg-slide {\n  position: relative;\n  width: 500px;\n  height: 44px;\n  margin: auto;\n  transform: translate3d(0, 0, 0);\n}\n.adg-slide-clue-min,\n.adg-slide-clue-max {\n  position: absolute;\n  top: 14px;\n  left: -40px;\n  width: 30px;\n  font-size: 12px;\n  font-weight: 500;\n  color: #8f9b92;\n  cursor: pointer;\n}\n.adg-slide-clue-min {\n  left: auto;\n  right: -40px;\n  text-align: right;\n}\n.adg-slide-btns {\n  display: none;\n}\n.adg-slide-btn {\n  position: relative;\n  width: 36px;\n  height: 36px;\n  border: 2px solid #e2e2e2;\n  border-radius: 2px;\n}\n.adg-slide-btn:after {\n  content: \"\";\n  position: absolute;\n  left: 8px;\n  top: 15.3px;\n  width: 18px;\n  height: 2px;\n  background-color: #4e4e4e;\n  border-radius: 2px;\n}\n.adg-slide-btn--plus {\n  margin-left: 9px;\n}\n.adg-slide-btn--plus:before {\n  content: \"\";\n  position: absolute;\n  left: 16px;\n  top: 8px;\n  height: 17px;\n  width: 2px;\n  background-color: #4e4e4e;\n  border-radius: 2px;\n}\n.ui-slider-handle {\n  position: absolute;\n  top: 22px;\n  z-index: 2;\n  cursor: pointer;\n}\n.ui-slider-handle:before {\n  content: '';\n  position: absolute;\n  top: 50%;\n  left: 50%;\n  width: 30px;\n  height: 30px;\n  margin: -15px 0 0 -15px;\n  background: rgba(0, 0, 0, 0.1);\n  border-radius: 50%;\n  transition: 0.2s;\n}\n.ui-slider-handle:after {\n  content: '';\n  position: absolute;\n  top: 50%;\n  left: 50%;\n  width: 20px;\n  height: 20px;\n  margin: -10px 0 0 -10px;\n  border-radius: 50%;\n}\n.ui-slider-handle:hover:active,\n.ui-slider-handle:hover:before {\n  background: rgba(0, 0, 0, 0.15);\n}\n.tick {\n  position: absolute;\n  height: 44px;\n}\n.settings_fieldset {\n  padding: 20px;\n}\n.settings_fieldset:first-child {\n  border: 0;\n}\n.settings_fieldset_lbl {\n  float: left;\n  width: 126px;\n  margin: 1px 0 0;\n  font-weight: 500;\n}\n.settings_fieldset_lbl__pos {\n  margin-top: 21px;\n}\n.settings_fieldset_val {\n  margin: 0 0 0 126px;\n}\n.choice-size {\n  position: relative;\n  font-size: 14px;\n}\n.choice-size_field {\n  margin: 10px 0 0;\n}\n.choice-size_field:first-child {\n  margin: 0;\n}\n.choice-size_logo {\n  display: none;\n  position: absolute;\n  top: 10px;\n  right: 15px;\n  width: 40px;\n  height: 40px;\n  background-size: 21px;\n  background-position: 50% 11px;\n  background-repeat: no-repeat;\n  background-color: #fff;\n  border: none ;\n  box-shadow: 0 0 10px 3px rgba(162, 161, 161, 0.3);\n  border-radius: 100% ;\n}\n.choice-size_logo.logo__small {\n  top: 15px;\n  right: 20px;\n  width: 24px;\n  height: 24px;\n  background-position: 50% 6px;\n  background-size: 14px;\n}\n.choice-size_input:checked ~ .choice-size_logo {\n  display: block;\n}\n[class^=\"s-position-arr-\"] {\n  display: block;\n  width: 11px;\n  height: 11px;\n  background: url(" + ___CSS_LOADER_URL_REPLACEMENT_0___ + ") no-repeat;\n  background-size: 44px 22px;\n}\n.s-position-arr-top-left {\n  background-position: 0 0;\n}\n.s-position-arr-top-right {\n  background-position: -11px 0;\n}\n.s-position-arr-bottom-left {\n  background-position: 0 -11px;\n}\n.s-position-arr-bottom-right {\n  background-position: -11px -11px;\n}\n.change-position {\n  position: relative;\n  display: inline-block;\n  vertical-align: top;\n  width: 70px;\n  margin: -3px 0 0 -3px;\n}\n.change-position_i {\n  float: left;\n  margin: 3px 0 0 3px;\n}\n.change-position_input:checked + .change-position_label .s-position-arr-top-left {\n  background-position: -22px 0;\n}\n.change-position_input:checked + .change-position_label .s-position-arr-top-right {\n  background-position: -33px 0;\n}\n.change-position_input:checked + .change-position_label .s-position-arr-bottom-left {\n  background-position: -22px -11px;\n}\n.change-position_input:checked + .change-position_label .s-position-arr-bottom-right {\n  background-position: -33px -11px;\n}\n.change-position_input:checked ~ .change-position_val {\n  display: block;\n}\n.change-position_label {\n  display: block;\n  width: 32px;\n  height: 32px;\n  margin: 0;\n  padding: 9px 0 0 9px;\n  border: 1px solid #dfdedb;\n  cursor: pointer;\n}\n.change-position_val {\n  display: none;\n  position: absolute;\n  top: 27px;\n  left: 82px;\n  font-size: 12px;\n  white-space: nowrap;\n}\n.position-save .position-save_field {\n  margin-bottom: 10px;\n}\n.wot-indicator {\n  display: inline-block;\n  vertical-align: top;\n  margin-right: 5px;\n}\n#WotDescriptionText {\n  white-space: pre-line;\n}\n#WotDescriptionText #WotLogo {\n  cursor: pointer;\n}\n.adg-wot {\n  width: 18px;\n  height: 18px;\n  display: block;\n  border: 5px solid #000;\n  border-radius: 50%;\n}\n.adg-wot-unknown {\n  border-color: #ccc;\n}\n.adg-wot-red {\n  border-color: #b60000;\n}\n.adg-wot-lightRed {\n  border-color: #f21800;\n}\n.adg-wot-yellow {\n  border-color: #fac000;\n}\n.adg-wot-lightGreen {\n  border-color: #69d225;\n}\n.adg-wot-green {\n  border-color: #00ae17;\n}\n.adg-wot-confidence {\n  width: 52px;\n  height: 18px;\n  display: inline-block;\n  vertical-align: middle;\n}\n.adg-wot-confidence-0 {\n  background-image: url(" + ___CSS_LOADER_URL_REPLACEMENT_1___ + ");\n}\n.adg-wot-confidence-1 {\n  background-image: url(" + ___CSS_LOADER_URL_REPLACEMENT_2___ + ");\n}\n.adg-wot-confidence-2 {\n  background-image: url(" + ___CSS_LOADER_URL_REPLACEMENT_3___ + ");\n}\n.adg-wot-confidence-3 {\n  background-image: url(" + ___CSS_LOADER_URL_REPLACEMENT_4___ + ");\n}\n.adg-wot-confidence-4 {\n  background-image: url(" + ___CSS_LOADER_URL_REPLACEMENT_5___ + ");\n}\n.adg-wot-confidence-5 {\n  background-image: url(" + ___CSS_LOADER_URL_REPLACEMENT_6___ + ");\n}\n.confidence-indication,\n.wot-indicator {\n  text-decoration: none;\n  vertical-align: middle;\n}\n.confidence-indication:hover,\n.wot-indicator:hover {\n  text-decoration: none;\n}\n.confidence-indication {\n  display: inline-block;\n  margin-right: 10px;\n}\n.wot-logo {\n  display: inline-block;\n  vertical-align: top;\n  width: 31px;\n  height: 12px;\n  background: url(" + ___CSS_LOADER_URL_REPLACEMENT_7___ + ") no-repeat 0 0 / cover;\n  margin-top: 3px;\n}\n.wot-hide {\n  display: none;\n}\niframe#adguard-assistant-dialog {\n  position: fixed;\n  clip: auto;\n  border-radius: 3px;\n  box-shadow: 0 0 10px 3px rgba(162, 161, 161, 0.3);\n  z-index: 2147483647;\n  display: block!important;\n}\n.sg_hide_element {\n  display: none!important;\n}\nimg.adguard_sg_selected {\n  border: 5px solid #0F0 !important;\n}\n#_sg_div.sg_top {\n  top: 5px !important;\n}\n#_sg_div.sg_bottom {\n  bottom: 5px !important;\n}\n#_sg_div input {\n  margin-right: 10px !important;\n  font-size: 15px !important;\n}\n#_sg_path_field {\n  width: 400px !important;\n}\n#_sg_div .sg_new_line {\n  clear: both !important;\n}\n#_sg_div .sg_option {\n  float: left !important;\n}\n#_sg_div .adguard_sg_selected_option {\n  text-decoration: underline;\n}\n.adguard-placeholder {\n  background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA8AAAAPCAMAAAAMCGV4AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyFpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDE0IDc5LjE1MTQ4MSwgMjAxMy8wMy8xMy0xMjowOToxNSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIChXaW5kb3dzKSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDo1OUM5OUE4MEZEQzUxMUUyOTAzM0EyODQyRjc5QjI2QyIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDo1OUM5OUE4MUZEQzUxMUUyOTAzM0EyODQyRjc5QjI2QyI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjU5Qzk5QTdFRkRDNTExRTI5MDMzQTI4NDJGNzlCMjZDIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjU5Qzk5QTdGRkRDNTExRTI5MDMzQTI4NDJGNzlCMjZDIi8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+9rJm9wAAAAZQTFRF2+7g1OfZ+LX/EgAAACtJREFUeNpiYIQABhhA5TIyoHIhfCS1DKhcEB/FJAZG7AYzoNlLLy5AgAEAMigAar6TcqkAAAAASUVORK5CYII=);\n}\n.adguard-placeholder-icon {\n  background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACYAAAAwCAYAAAB9sggoAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyFpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDE0IDc5LjE1MTQ4MSwgMjAxMy8wMy8xMy0xMjowOToxNSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIChXaW5kb3dzKSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDpENkNBQTNGMkZEQzUxMUUyQjVFMkZEMUFFRjlGOEQyMyIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDpENkNBQTNGM0ZEQzUxMUUyQjVFMkZEMUFFRjlGOEQyMyI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOkQ2Q0FBM0YwRkRDNTExRTJCNUUyRkQxQUVGOUY4RDIzIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOkQ2Q0FBM0YxRkRDNTExRTJCNUUyRkQxQUVGOUY4RDIzIi8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+49sbDwAAAl9JREFUeNrMmE0o5VEYxq9vJmpI2SBZjCSNKKGwkDE0m8mg2QwzEtkNCeUjGyVhYTbTUIZEMWmkbCVlw9QkG4mammbK5zAWuLqek3ch3W7v+Z8P/7d+u/cczz3neM7zP0Htg12eR6wUkA+eg2yQDOLAYegjiIkEr0AjyAPRfnp8toW9Be20QoHKa0tYEhgCVdwBNoQVgCmQKjPItLAKMAtiZAeaFFYM5sATJ4ODDYl6BuadijIlLAJMgHiFOWJMbGUfmaZsHYN98Bvs6haWA1olx2yCMfAd/DF1+Psl5rwGPWAYXJn8r3wNXjB7L0ENrZLRwy/m6ZDorw8kSqewUpDL7P0Epm3YRRBoYfbugW5bPpZDK8apTnBqS9h7WjWOLXyz5fxPQSWjz0dWcmPrEhdJNIEprIlW198Z7aUV1SasQWJnAp3Dzw+FqWxlOmV2HeXVecbegHBTYS5YYVy1yejrVJhIpxluFPaB6V1WhSWQTXjcJqyKjFVnhagabBhFFk7tgnPmlp+oChNbmMXM70XgL3Nen6qwj8y+xfv53fQZKweFzN5xW4c/Cgwwe9fAui1hIuBlMntHZOKNirAyiQ+NLbBkw8fEE9IM2QSnBv19I+oWVguWQSxzrnX6EVrqoV2I15kS0AxeSszjo+326hQm3hoSQRqR6mCeL2BV5x0VSjYQojDHNmgzcYn/Uxj/H9SBM7fkMQ951Tuw4aageEMpY8FUHnPy+XZECXbRTUFxhezEqCiZFfsFRnXdg1xhgcT9BF/BJG2htRKiDjx376EX9Md36HoR/NDp5jJ1K8AAcQBmooZhTgQAAAAASUVORK5CYII=);\n  background-position: center center;\n  background-repeat: no-repeat;\n  height: 100%;\n}\n.adguard-placeholder-domain {\n  background: #778b7c;\n  color: #ffffff;\n  left: 0;\n  top: 0;\n  padding: 2px 4px;\n  position: relative;\n}\n@media print {\n  .adguard-alert,\n  #adguard-assistant-dialog {\n    display: none!important;\n    opacity: 0!important;\n    visibility: hidden!important;\n  }\n}\n.menu-head {\n  padding: 18px 20px;\n  cursor: move;\n  touch-action: none;\n  -ms-touch-action: none;\n}\n.menu-head_title {\n  font-size: 16px;\n  font-weight: 700;\n}\n.menu-head_name {\n  display: inline-block;\n  vertical-align: top;\n  text-overflow: ellipsis;\n  overflow: hidden;\n  white-space: nowrap;\n  max-width: 260px;\n  line-height: 26px;\n  margin: 0 10px 5px 0;\n}\n.menu-head_text {\n  margin: 4px 10px 0 0;\n  font-size: 12px;\n}\n.menu-filter {\n  width: 100%;\n  display: table;\n  padding: 20px;\n}\n.menu-filter_lbl {\n  display: table-cell;\n  vertical-align: middle;\n}\n.menu-filter_val {\n  display: table-cell;\n  vertical-align: middle;\n}\n.menu-filter_label {\n  position: relative;\n  width: 30px;\n  height: 12px;\n  border-radius: 25px;\n  background-color: #ed7865;\n  cursor: pointer;\n  transition: all 0.3s ease;\n  float: right;\n}\n.menu-filter_label:after {\n  content: \"\";\n  cursor: pointer;\n  border-radius: 100%;\n  position: absolute;\n  left: -3px;\n  top: -4px;\n  box-shadow: 0 0 10px 3px rgba(162, 161, 161, 0.3);\n  width: 20px;\n  height: 20px;\n  background-color: #e85037;\n  transition: all 0.3s ease;\n}\n.menu-filter_handle {\n  position: absolute;\n  width: 20px;\n  height: 20px;\n  top: 1px;\n  left: 1px;\n  border-radius: 4px;\n}\n.menu-filter_input:checked + .menu-filter_label {\n  background-color: #bde5c1;\n}\n.menu-filter_input:checked + .menu-filter_label:after {\n  left: 12px;\n  background-color: #68bc72;\n}\n.menu__btn {\n  position: relative;\n  cursor: pointer;\n  line-height: 45px;\n  height: 45px;\n  background-repeat: no-repeat;\n  background-position: 20px 50%;\n  transition: 0.3s ease;\n  padding: 0 20px 0 60px;\n  white-space: nowrap;\n  overflow: hidden;\n  text-overflow: ellipsis;\n}\n.menu__btn:hover {\n  background-color: rgba(104, 188, 113, 0.2);\n}\n.menu__btn--clock {\n  background-image: url(" + ___CSS_LOADER_URL_REPLACEMENT_8___ + ");\n  background-size: 16px 19px;\n}\n.menu__btn--landscape {\n  background-image: url(" + ___CSS_LOADER_URL_REPLACEMENT_9___ + ");\n  background-size: 19px 17px;\n}\n.menu__btn--report {\n  background-image: url(" + ___CSS_LOADER_URL_REPLACEMENT_10___ + ");\n  background-size: 16px 17px;\n}\n.menu__btn--security {\n  background-image: url(" + ___CSS_LOADER_URL_REPLACEMENT_11___ + ");\n  background-size: 15px 16px;\n}\n.menu__btn--extensions {\n  background-image: url(" + ___CSS_LOADER_URL_REPLACEMENT_12___ + ");\n  background-size: 18px;\n}\n.menu__btn--settings {\n  background-image: url(" + ___CSS_LOADER_URL_REPLACEMENT_13___ + ");\n  background-size: 19px;\n}\n.menu__btn.hidden {\n  display: none;\n}\nbody {\n  color: #282828;\n}\n.main {\n  background: #ffffff;\n}\n.main-popup__btn {\n  background: #ffffff;\n  border: 1px solid #cfcfcf;\n}\n.main-popup__btn:hover {\n  background-color: #efefef;\n}\n.main-menu__btn {\n  background-color: #ffffff;\n}\n.main-menu__btn:hover {\n  background-color: #efefef;\n}\n.main-menu__btn:active,\n.main-menu__btn.active {\n  background-color: #f3f3f3;\n}\n.main-version {\n  color: #dfdfdf;\n}\n.head_title {\n  color: #343434;\n}\n.head_text {\n  color: #343434;\n}\n.element-rule_expand-link_txt {\n  color: #36ba53;\n  border-bottom: 1px solid #36ba53;\n}\n.element-rule_expand-link:hover .element-rule_expand-link_txt {\n  color: #36ba53;\n  border-bottom-color: #36ba53;\n}\n.element-rule_form-cont {\n  border-top: 1px solid #e0dfdb;\n  background: #f4f4ef;\n}\n.tick {\n  border: 20px solid #ffffff;\n  border-left: 1px solid #ffffff;\n  border-right: 1px solid #ffffff;\n}\n.close {\n  background: url(" + ___CSS_LOADER_URL_REPLACEMENT_14___ + ") no-repeat 0 0 / cover;\n  opacity: 0.6;\n}\n.close:hover {\n  opacity: 0.8;\n}\n.form-control {\n  color: #343434;\n  background: #ffffff;\n  border: 1px solid #cfcfcf;\n}\ninput[type=\"checkbox\"] + .form-ui .form-ui-txt:before {\n  border: 1px solid #cfcfcf;\n  background: #ffffff;\n}\ninput[type=\"checkbox\"]:checked + .form-ui .form-ui-txt:before {\n  border: 1px solid #36ba53;\n  background: #36ba53;\n}\ninput[type=\"checkbox\"]:checked + .form-ui .form-ui-txt:after {\n  border-bottom-color: #ffffff;\n  border-left-color: #ffffff;\n}\n.menu,\n.menu-filter,\n.content,\n.foot {\n  border-top: 1px solid #e0dfdb;\n}\n.settings_fieldset {\n  border-top: 1px solid #e0dfdb;\n}\n.btn-primary {\n  border-color: #36ba53;\n  background: #36ba53;\n  color: #fff;\n}\n.btn-primary:hover {\n  border-color: #30a64a;\n  background: #30a64a;\n  color: #fff;\n}\n.btn-primary.active,\n.btn-primary:active {\n  border-color: #30a64a;\n  background: #30a64a;\n}\n.btn-primary.disabled,\n.btn-primary[disabled] {\n  border-color: #30a64a;\n  background: #30a64a;\n}\n.btn-cancel {\n  border-color: #f3523d;\n  background: #f3523d;\n  color: #fff;\n}\n.btn-cancel:hover {\n  border-color: #ee290f;\n  background: #ee290f;\n  color: #fff;\n}\n.btn-cancel.active,\n.btn-cancel:active {\n  border-color: #ee290f;\n  background: #ee290f;\n}\n.btn-cancel.disabled,\n.btn-cancel[disabled] {\n  border-color: #ee290f;\n  background: #ee290f;\n}\n.ui-slider-handle:after {\n  background: #36ba53;\n}\n.change-position_input:checked + .change-position_label {\n  border-color: #36ba53;\n  background: #36ba53;\n}\ninput[type=\"radio\"] + .form-ui .form-ui-txt:before {\n  background: #ffffff;\n}\ninput[type=\"radio\"]:checked + .form-ui .form-ui-txt:after {\n  background: #36ba53;\n}\n.menu-head_title {\n  color: #343434;\n}\n.menu-head_text {\n  color: #343434;\n}\n.menu-filter_handle {\n  background: #ffffff;\n}\n@media (prefers-color-scheme: dark) {\n  body {\n    color: #ddd;\n  }\n  .main {\n    background: #323232;\n  }\n  .main-popup__btn {\n    background: #323232;\n    border: 1px solid #666;\n  }\n  .main-popup__btn:hover {\n    background-color: #555555;\n  }\n  .main-menu__btn {\n    background-color: #323232;\n  }\n  .main-menu__btn:hover {\n    background-color: #555555;\n  }\n  .main-menu__btn:active,\n  .main-menu__btn.active {\n    background-color: #4d4d4d;\n  }\n  .main-version {\n    color: #444;\n  }\n  .head_title {\n    color: #ccc;\n  }\n  .head_text {\n    color: #ccc;\n  }\n  .element-rule_expand-link_txt {\n    color: #67B279;\n    border-bottom: 1px solid #67B279;\n  }\n  .element-rule_expand-link:hover .element-rule_expand-link_txt {\n    color: #4D995F;\n    border-bottom-color: #4D995F;\n  }\n  .element-rule_form-cont {\n    border-top: 1px solid #444;\n    background: #555;\n  }\n  .tick {\n    border: 20px solid #323232;\n    border-left: 1px solid #323232;\n    border-right: 1px solid #323232;\n  }\n  .close {\n    background: url(" + ___CSS_LOADER_URL_REPLACEMENT_15___ + ") no-repeat 0 0 / cover;\n    opacity: 0.7;\n  }\n  .close:hover {\n    opacity: 1;\n  }\n  .form-control {\n    color: #ccc;\n    background: #323232;\n    border: 1px solid #666;\n  }\n  input[type=\"checkbox\"] + .form-ui .form-ui-txt:before {\n    border: 1px solid #666;\n    background: #323232;\n  }\n  input[type=\"checkbox\"]:checked + .form-ui .form-ui-txt:before {\n    border: 1px solid #4D995F;\n    background: #4D995F;\n  }\n  input[type=\"checkbox\"]:checked + .form-ui .form-ui-txt:after {\n    border-bottom-color: #323232;\n    border-left-color: #323232;\n  }\n  .menu,\n  .menu-filter,\n  .content,\n  .foot {\n    border-top: 1px solid #444;\n  }\n  .settings_fieldset {\n    border-top: 1px solid #444;\n  }\n  .btn-primary {\n    border-color: #4D995F;\n    background: #4D995F;\n    color: #fff;\n  }\n  .btn-primary:hover {\n    border-color: #39774C;\n    background: #39774C;\n    color: #fff;\n  }\n  .btn-primary.active,\n  .btn-primary:active {\n    border-color: #39774C;\n    background: #39774C;\n  }\n  .btn-primary.disabled,\n  .btn-primary[disabled] {\n    border-color: #39774C;\n    background: #39774C;\n  }\n  .btn-cancel {\n    border-color: #8E2C13;\n    background: #8E2C13;\n    color: #fff;\n  }\n  .btn-cancel:hover {\n    border-color: #732613;\n    background: #732613;\n    color: #fff;\n  }\n  .btn-cancel.active,\n  .btn-cancel:active {\n    border-color: #732613;\n    background: #732613;\n  }\n  .btn-cancel.disabled,\n  .btn-cancel[disabled] {\n    border-color: #732613;\n    background: #732613;\n  }\n  .ui-slider-handle:after {\n    background: #4D995F;\n  }\n  .change-position_input:checked + .change-position_label {\n    border-color: #4D995F;\n    background: #4D995F;\n  }\n  input[type=\"radio\"] + .form-ui .form-ui-txt:before {\n    background: #323232;\n  }\n  input[type=\"radio\"]:checked + .form-ui .form-ui-txt:after {\n    background: #4D995F;\n  }\n  .menu-head_title {\n    color: #ccc;\n  }\n  .menu-head_text {\n    color: #ccc;\n  }\n  .menu-filter_handle {\n    background: #323232;\n  }\n}\n:host {\n  display: block!important;\n  position: relative!important;\n  width: 0!important;\n  height: 0!important;\n  margin: 0!important;\n  padding: 0!important;\n  z-index: 2147483647!important;\n}\n:host ::after,\n:host ::before {\n  display: none!important;\n}\n", ""]);
// Exports
module.exports = exports;


/***/ }),

/***/ 817:
/***/ ((module, exports, __nested_webpack_require_253421__) => {

// Imports
var ___CSS_LOADER_API_IMPORT___ = __nested_webpack_require_253421__(3645);
var ___CSS_LOADER_GET_URL_IMPORT___ = __nested_webpack_require_253421__(1667);
var ___CSS_LOADER_URL_IMPORT_0___ = __nested_webpack_require_253421__(2668);
var ___CSS_LOADER_URL_IMPORT_1___ = __nested_webpack_require_253421__(1823);
var ___CSS_LOADER_URL_IMPORT_2___ = __nested_webpack_require_253421__(9053);
var ___CSS_LOADER_URL_IMPORT_3___ = __nested_webpack_require_253421__(8269);
var ___CSS_LOADER_URL_IMPORT_4___ = __nested_webpack_require_253421__(2834);
var ___CSS_LOADER_URL_IMPORT_5___ = __nested_webpack_require_253421__(9713);
var ___CSS_LOADER_URL_IMPORT_6___ = __nested_webpack_require_253421__(7693);
var ___CSS_LOADER_URL_IMPORT_7___ = __nested_webpack_require_253421__(6265);
var ___CSS_LOADER_URL_IMPORT_8___ = __nested_webpack_require_253421__(1109);
exports = ___CSS_LOADER_API_IMPORT___(false);
var ___CSS_LOADER_URL_REPLACEMENT_0___ = ___CSS_LOADER_GET_URL_IMPORT___(___CSS_LOADER_URL_IMPORT_0___);
var ___CSS_LOADER_URL_REPLACEMENT_1___ = ___CSS_LOADER_GET_URL_IMPORT___(___CSS_LOADER_URL_IMPORT_1___);
var ___CSS_LOADER_URL_REPLACEMENT_2___ = ___CSS_LOADER_GET_URL_IMPORT___(___CSS_LOADER_URL_IMPORT_2___);
var ___CSS_LOADER_URL_REPLACEMENT_3___ = ___CSS_LOADER_GET_URL_IMPORT___(___CSS_LOADER_URL_IMPORT_3___);
var ___CSS_LOADER_URL_REPLACEMENT_4___ = ___CSS_LOADER_GET_URL_IMPORT___(___CSS_LOADER_URL_IMPORT_4___);
var ___CSS_LOADER_URL_REPLACEMENT_5___ = ___CSS_LOADER_GET_URL_IMPORT___(___CSS_LOADER_URL_IMPORT_5___);
var ___CSS_LOADER_URL_REPLACEMENT_6___ = ___CSS_LOADER_GET_URL_IMPORT___(___CSS_LOADER_URL_IMPORT_6___);
var ___CSS_LOADER_URL_REPLACEMENT_7___ = ___CSS_LOADER_GET_URL_IMPORT___(___CSS_LOADER_URL_IMPORT_7___);
var ___CSS_LOADER_URL_REPLACEMENT_8___ = ___CSS_LOADER_GET_URL_IMPORT___(___CSS_LOADER_URL_IMPORT_8___);
// Module
exports.push([module.id, ":host {\n  display: block!important;\n  position: relative!important;\n  width: 0!important;\n  height: 0!important;\n  margin: 0!important;\n  padding: 0!important;\n  z-index: 2147483647!important;\n}\n:host ::after,\n:host ::before {\n  display: none!important;\n}\nbody {\n  color: #282828;\n}\n.main {\n  background: #ffffff;\n}\n.main-popup__btn {\n  background: #ffffff;\n  border: 1px solid #cfcfcf;\n}\n.main-popup__btn:hover {\n  background-color: #efefef;\n}\n.main-menu__btn {\n  background-color: #ffffff;\n}\n.main-menu__btn:hover {\n  background-color: #efefef;\n}\n.main-menu__btn:active,\n.main-menu__btn.active {\n  background-color: #f3f3f3;\n}\n.main-version {\n  color: #dfdfdf;\n}\n.head_title {\n  color: #343434;\n}\n.head_text {\n  color: #343434;\n}\n.element-rule_expand-link_txt {\n  color: #36ba53;\n  border-bottom: 1px solid #36ba53;\n}\n.element-rule_expand-link:hover .element-rule_expand-link_txt {\n  color: #36ba53;\n  border-bottom-color: #36ba53;\n}\n.element-rule_form-cont {\n  border-top: 1px solid #e0dfdb;\n  background: #f4f4ef;\n}\n.tick {\n  border: 20px solid #ffffff;\n  border-left: 1px solid #ffffff;\n  border-right: 1px solid #ffffff;\n}\n.close {\n  background: url(" + ___CSS_LOADER_URL_REPLACEMENT_0___ + ") no-repeat 0 0 / cover;\n  opacity: 0.6;\n}\n.close:hover {\n  opacity: 0.8;\n}\n.form-control {\n  color: #343434;\n  background: #ffffff;\n  border: 1px solid #cfcfcf;\n}\ninput[type=\"checkbox\"] + .form-ui .form-ui-txt:before {\n  border: 1px solid #cfcfcf;\n  background: #ffffff;\n}\ninput[type=\"checkbox\"]:checked + .form-ui .form-ui-txt:before {\n  border: 1px solid #36ba53;\n  background: #36ba53;\n}\ninput[type=\"checkbox\"]:checked + .form-ui .form-ui-txt:after {\n  border-bottom-color: #ffffff;\n  border-left-color: #ffffff;\n}\n.menu,\n.menu-filter,\n.content,\n.foot {\n  border-top: 1px solid #e0dfdb;\n}\n.settings_fieldset {\n  border-top: 1px solid #e0dfdb;\n}\n.btn-primary {\n  border-color: #36ba53;\n  background: #36ba53;\n  color: #fff;\n}\n.btn-primary:hover {\n  border-color: #30a64a;\n  background: #30a64a;\n  color: #fff;\n}\n.btn-primary.active,\n.btn-primary:active {\n  border-color: #30a64a;\n  background: #30a64a;\n}\n.btn-primary.disabled,\n.btn-primary[disabled] {\n  border-color: #30a64a;\n  background: #30a64a;\n}\n.btn-cancel {\n  border-color: #f3523d;\n  background: #f3523d;\n  color: #fff;\n}\n.btn-cancel:hover {\n  border-color: #ee290f;\n  background: #ee290f;\n  color: #fff;\n}\n.btn-cancel.active,\n.btn-cancel:active {\n  border-color: #ee290f;\n  background: #ee290f;\n}\n.btn-cancel.disabled,\n.btn-cancel[disabled] {\n  border-color: #ee290f;\n  background: #ee290f;\n}\n.ui-slider-handle:after {\n  background: #36ba53;\n}\n.change-position_input:checked + .change-position_label {\n  border-color: #36ba53;\n  background: #36ba53;\n}\ninput[type=\"radio\"] + .form-ui .form-ui-txt:before {\n  background: #ffffff;\n}\ninput[type=\"radio\"]:checked + .form-ui .form-ui-txt:after {\n  background: #36ba53;\n}\n.menu-head_title {\n  color: #343434;\n}\n.menu-head_text {\n  color: #343434;\n}\n.menu-filter_handle {\n  background: #ffffff;\n}\n@media (prefers-color-scheme: dark) {\n  body {\n    color: #ddd;\n  }\n  .main {\n    background: #323232;\n  }\n  .main-popup__btn {\n    background: #323232;\n    border: 1px solid #666;\n  }\n  .main-popup__btn:hover {\n    background-color: #555555;\n  }\n  .main-menu__btn {\n    background-color: #323232;\n  }\n  .main-menu__btn:hover {\n    background-color: #555555;\n  }\n  .main-menu__btn:active,\n  .main-menu__btn.active {\n    background-color: #4d4d4d;\n  }\n  .main-version {\n    color: #444;\n  }\n  .head_title {\n    color: #ccc;\n  }\n  .head_text {\n    color: #ccc;\n  }\n  .element-rule_expand-link_txt {\n    color: #67B279;\n    border-bottom: 1px solid #67B279;\n  }\n  .element-rule_expand-link:hover .element-rule_expand-link_txt {\n    color: #4D995F;\n    border-bottom-color: #4D995F;\n  }\n  .element-rule_form-cont {\n    border-top: 1px solid #444;\n    background: #555;\n  }\n  .tick {\n    border: 20px solid #323232;\n    border-left: 1px solid #323232;\n    border-right: 1px solid #323232;\n  }\n  .close {\n    background: url(" + ___CSS_LOADER_URL_REPLACEMENT_1___ + ") no-repeat 0 0 / cover;\n    opacity: 0.7;\n  }\n  .close:hover {\n    opacity: 1;\n  }\n  .form-control {\n    color: #ccc;\n    background: #323232;\n    border: 1px solid #666;\n  }\n  input[type=\"checkbox\"] + .form-ui .form-ui-txt:before {\n    border: 1px solid #666;\n    background: #323232;\n  }\n  input[type=\"checkbox\"]:checked + .form-ui .form-ui-txt:before {\n    border: 1px solid #4D995F;\n    background: #4D995F;\n  }\n  input[type=\"checkbox\"]:checked + .form-ui .form-ui-txt:after {\n    border-bottom-color: #323232;\n    border-left-color: #323232;\n  }\n  .menu,\n  .menu-filter,\n  .content,\n  .foot {\n    border-top: 1px solid #444;\n  }\n  .settings_fieldset {\n    border-top: 1px solid #444;\n  }\n  .btn-primary {\n    border-color: #4D995F;\n    background: #4D995F;\n    color: #fff;\n  }\n  .btn-primary:hover {\n    border-color: #39774C;\n    background: #39774C;\n    color: #fff;\n  }\n  .btn-primary.active,\n  .btn-primary:active {\n    border-color: #39774C;\n    background: #39774C;\n  }\n  .btn-primary.disabled,\n  .btn-primary[disabled] {\n    border-color: #39774C;\n    background: #39774C;\n  }\n  .btn-cancel {\n    border-color: #8E2C13;\n    background: #8E2C13;\n    color: #fff;\n  }\n  .btn-cancel:hover {\n    border-color: #732613;\n    background: #732613;\n    color: #fff;\n  }\n  .btn-cancel.active,\n  .btn-cancel:active {\n    border-color: #732613;\n    background: #732613;\n  }\n  .btn-cancel.disabled,\n  .btn-cancel[disabled] {\n    border-color: #732613;\n    background: #732613;\n  }\n  .ui-slider-handle:after {\n    background: #4D995F;\n  }\n  .change-position_input:checked + .change-position_label {\n    border-color: #4D995F;\n    background: #4D995F;\n  }\n  input[type=\"radio\"] + .form-ui .form-ui-txt:before {\n    background: #323232;\n  }\n  input[type=\"radio\"]:checked + .form-ui .form-ui-txt:after {\n    background: #4D995F;\n  }\n  .menu-head_title {\n    color: #ccc;\n  }\n  .menu-head_text {\n    color: #ccc;\n  }\n  .menu-filter_handle {\n    background: #323232;\n  }\n}\nbody {\n  padding: 1vw;\n  background: transparent;\n}\n.main {\n  position: relative;\n  padding: 8vw 3vw;\n}\n.main .footer {\n  letter-spacing: 3vw;\n}\n.main-version {\n  position: absolute;\n  bottom: 0;\n  right: 7px;\n  font-size: 5vw;\n}\n.main-popup {\n  text-align: center;\n  display: flex;\n  flex-direction: column;\n  align-items: center;\n  margin: 5vw;\n  box-shadow: 0 0px 5vw 0 rgba(0, 0, 0, 0.2);\n}\n.main-popup__logo {\n  width: 11vw;\n  height: 11vw;\n}\n.main-popup__logo.adguard-assistant-button-main-logo {\n  background-image: url(" + ___CSS_LOADER_URL_REPLACEMENT_2___ + ");\n  background-repeat: no-repeat;\n}\n.main-popup__title {\n  font-size: 6vw;\n  margin: 3vw 0;\n}\n.main-popup__content {\n  font-size: 5vw;\n  padding: 0 3vw;\n  margin-bottom: 5vw;\n  border-top: none;\n}\n.main-popup__btn {\n  font-size: 5vw;\n  padding: 2vh 8vw;\n  border-radius: 3px;\n  letter-spacing: normal;\n}\n.main-popup__btn--green {\n  color: #ffffff;\n  border: 1px solid #66B574;\n  background-color: #66B574;\n  box-shadow: none;\n}\n.main-popup__btn--green:hover {\n  background-color: #5ea76b;\n  color: #fff;\n}\n.main-popup__btn:focus {\n  box-shadow: none;\n}\n.main-menu {\n  margin: 4vw;\n  padding: 4vw;\n  display: flex;\n  justify-content: space-between;\n  border-radius: 4vw;\n  box-shadow: 0 0 4vw -2px rgba(0, 0, 0, 0.3);\n}\n.main-menu__info {\n  width: 100%;\n  text-align: center;\n}\n.main-menu__btn {\n  border: 0;\n  font-size: 0;\n  width: 12vw;\n  height: 12vw;\n  border-radius: 2vw;\n  background-repeat: no-repeat;\n  background-position: 50%;\n  background-size: 100%;\n  position: relative;\n}\n.main-menu__btn:disabled {\n  opacity: 0.5;\n  pointer-events: none;\n}\n.main-menu__btn--accept {\n  background-image: url(" + ___CSS_LOADER_URL_REPLACEMENT_3___ + ");\n}\n.main-menu__btn--preview {\n  background-image: url(" + ___CSS_LOADER_URL_REPLACEMENT_4___ + ");\n}\n.main-menu__btn--preview:active,\n.main-menu__btn--preview.active {\n  background-image: url(" + ___CSS_LOADER_URL_REPLACEMENT_5___ + ");\n}\n.main-menu__btn--plus {\n  background-image: url(" + ___CSS_LOADER_URL_REPLACEMENT_6___ + ");\n}\n.main-menu__btn--minus {\n  background-image: url(" + ___CSS_LOADER_URL_REPLACEMENT_7___ + ");\n}\n.main-menu__btn--close {\n  background-image: url(" + ___CSS_LOADER_URL_REPLACEMENT_8___ + ");\n}\n", ""]);
// Exports
module.exports = exports;


/***/ }),

/***/ 3596:
/***/ ((module, exports, __nested_webpack_require_263981__) => {

// Imports
var ___CSS_LOADER_API_IMPORT___ = __nested_webpack_require_263981__(3645);
exports = ___CSS_LOADER_API_IMPORT___(false);
// Module
exports.push([module.id, "iframe#adguard-assistant-dialog {\n  position: fixed;\n  clip: auto;\n  border-radius: 3px;\n  box-shadow: 0 0 10px 3px rgba(162, 161, 161, 0.3);\n  z-index: 2147483647;\n  display: block!important;\n}\n.sg_hide_element {\n  display: none!important;\n}\nimg.adguard_sg_selected {\n  border: 5px solid #0F0 !important;\n}\n#_sg_div.sg_top {\n  top: 5px !important;\n}\n#_sg_div.sg_bottom {\n  bottom: 5px !important;\n}\n#_sg_div input {\n  margin-right: 10px !important;\n  font-size: 15px !important;\n}\n#_sg_path_field {\n  width: 400px !important;\n}\n#_sg_div .sg_new_line {\n  clear: both !important;\n}\n#_sg_div .sg_option {\n  float: left !important;\n}\n#_sg_div .adguard_sg_selected_option {\n  text-decoration: underline;\n}\n.adguard-placeholder {\n  background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA8AAAAPCAMAAAAMCGV4AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyFpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDE0IDc5LjE1MTQ4MSwgMjAxMy8wMy8xMy0xMjowOToxNSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIChXaW5kb3dzKSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDo1OUM5OUE4MEZEQzUxMUUyOTAzM0EyODQyRjc5QjI2QyIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDo1OUM5OUE4MUZEQzUxMUUyOTAzM0EyODQyRjc5QjI2QyI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjU5Qzk5QTdFRkRDNTExRTI5MDMzQTI4NDJGNzlCMjZDIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjU5Qzk5QTdGRkRDNTExRTI5MDMzQTI4NDJGNzlCMjZDIi8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+9rJm9wAAAAZQTFRF2+7g1OfZ+LX/EgAAACtJREFUeNpiYIQABhhA5TIyoHIhfCS1DKhcEB/FJAZG7AYzoNlLLy5AgAEAMigAar6TcqkAAAAASUVORK5CYII=);\n}\n.adguard-placeholder-icon {\n  background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACYAAAAwCAYAAAB9sggoAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyFpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDE0IDc5LjE1MTQ4MSwgMjAxMy8wMy8xMy0xMjowOToxNSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIChXaW5kb3dzKSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDpENkNBQTNGMkZEQzUxMUUyQjVFMkZEMUFFRjlGOEQyMyIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDpENkNBQTNGM0ZEQzUxMUUyQjVFMkZEMUFFRjlGOEQyMyI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOkQ2Q0FBM0YwRkRDNTExRTJCNUUyRkQxQUVGOUY4RDIzIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOkQ2Q0FBM0YxRkRDNTExRTJCNUUyRkQxQUVGOUY4RDIzIi8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+49sbDwAAAl9JREFUeNrMmE0o5VEYxq9vJmpI2SBZjCSNKKGwkDE0m8mg2QwzEtkNCeUjGyVhYTbTUIZEMWmkbCVlw9QkG4mammbK5zAWuLqek3ch3W7v+Z8P/7d+u/cczz3neM7zP0Htg12eR6wUkA+eg2yQDOLAYegjiIkEr0AjyAPRfnp8toW9Be20QoHKa0tYEhgCVdwBNoQVgCmQKjPItLAKMAtiZAeaFFYM5sATJ4ODDYl6BuadijIlLAJMgHiFOWJMbGUfmaZsHYN98Bvs6haWA1olx2yCMfAd/DF1+Psl5rwGPWAYXJn8r3wNXjB7L0ENrZLRwy/m6ZDorw8kSqewUpDL7P0Epm3YRRBoYfbugW5bPpZDK8apTnBqS9h7WjWOLXyz5fxPQSWjz0dWcmPrEhdJNIEprIlW198Z7aUV1SasQWJnAp3Dzw+FqWxlOmV2HeXVecbegHBTYS5YYVy1yejrVJhIpxluFPaB6V1WhSWQTXjcJqyKjFVnhagabBhFFk7tgnPmlp+oChNbmMXM70XgL3Nen6qwj8y+xfv53fQZKweFzN5xW4c/Cgwwe9fAui1hIuBlMntHZOKNirAyiQ+NLbBkw8fEE9IM2QSnBv19I+oWVguWQSxzrnX6EVrqoV2I15kS0AxeSszjo+326hQm3hoSQRqR6mCeL2BV5x0VSjYQojDHNmgzcYn/Uxj/H9SBM7fkMQ951Tuw4aageEMpY8FUHnPy+XZECXbRTUFxhezEqCiZFfsFRnXdg1xhgcT9BF/BJG2htRKiDjx376EX9Md36HoR/NDp5jJ1K8AAcQBmooZhTgQAAAAASUVORK5CYII=);\n  background-position: center center;\n  background-repeat: no-repeat;\n  height: 100%;\n}\n.adguard-placeholder-domain {\n  background: #778b7c;\n  color: #ffffff;\n  left: 0;\n  top: 0;\n  padding: 2px 4px;\n  position: relative;\n}\n@media print {\n  .adguard-alert,\n  #adguard-assistant-dialog {\n    display: none!important;\n    opacity: 0!important;\n    visibility: hidden!important;\n  }\n}\n", ""]);
// Exports
module.exports = exports;


/***/ }),

/***/ 3645:
/***/ ((module) => {

"use strict";


/*
  MIT License http://www.opensource.org/licenses/mit-license.php
  Author Tobias Koppers @sokra
*/
// css base code, injected by the css-loader
// eslint-disable-next-line func-names
module.exports = function (useSourceMap) {
  var list = []; // return the list of modules as css string

  list.toString = function toString() {
    return this.map(function (item) {
      var content = cssWithMappingToString(item, useSourceMap);

      if (item[2]) {
        return "@media ".concat(item[2], " {").concat(content, "}");
      }

      return content;
    }).join('');
  }; // import a list of modules into the list
  // eslint-disable-next-line func-names


  list.i = function (modules, mediaQuery, dedupe) {
    if (typeof modules === 'string') {
      // eslint-disable-next-line no-param-reassign
      modules = [[null, modules, '']];
    }

    var alreadyImportedModules = {};

    if (dedupe) {
      for (var i = 0; i < this.length; i++) {
        // eslint-disable-next-line prefer-destructuring
        var id = this[i][0];

        if (id != null) {
          alreadyImportedModules[id] = true;
        }
      }
    }

    for (var _i = 0; _i < modules.length; _i++) {
      var item = [].concat(modules[_i]);

      if (dedupe && alreadyImportedModules[item[0]]) {
        // eslint-disable-next-line no-continue
        continue;
      }

      if (mediaQuery) {
        if (!item[2]) {
          item[2] = mediaQuery;
        } else {
          item[2] = "".concat(mediaQuery, " and ").concat(item[2]);
        }
      }

      list.push(item);
    }
  };

  return list;
};

function cssWithMappingToString(item, useSourceMap) {
  var content = item[1] || ''; // eslint-disable-next-line prefer-destructuring

  var cssMapping = item[3];

  if (!cssMapping) {
    return content;
  }

  if (useSourceMap && typeof btoa === 'function') {
    var sourceMapping = toComment(cssMapping);
    var sourceURLs = cssMapping.sources.map(function (source) {
      return "/*# sourceURL=".concat(cssMapping.sourceRoot || '').concat(source, " */");
    });
    return [content].concat(sourceURLs).concat([sourceMapping]).join('\n');
  }

  return [content].join('\n');
} // Adapted from convert-source-map (MIT)


function toComment(sourceMap) {
  // eslint-disable-next-line no-undef
  var base64 = btoa(unescape(encodeURIComponent(JSON.stringify(sourceMap))));
  var data = "sourceMappingURL=data:application/json;charset=utf-8;base64,".concat(base64);
  return "/*# ".concat(data, " */");
}

/***/ }),

/***/ 1667:
/***/ ((module) => {

"use strict";


module.exports = function (url, options) {
  if (!options) {
    // eslint-disable-next-line no-param-reassign
    options = {};
  } // eslint-disable-next-line no-underscore-dangle, no-param-reassign


  url = url && url.__esModule ? url.default : url;

  if (typeof url !== 'string') {
    return url;
  } // If url is already wrapped in quotes, remove them


  if (/^['"].*['"]$/.test(url)) {
    // eslint-disable-next-line no-param-reassign
    url = url.slice(1, -1);
  }

  if (options.hash) {
    // eslint-disable-next-line no-param-reassign
    url += options.hash;
  } // Should url be wrapped?
  // See https://drafts.csswg.org/css-values-3/#urls


  if (/["'() \t\n]/.test(url) || options.needQuotes) {
    return "\"".concat(url.replace(/"/g, '\\"').replace(/\n/g, '\\n'), "\"");
  }

  return url;
};

/***/ }),

/***/ 5688:
/***/ ((module) => {

// Module
var code = "<div class=\"main\"> <div class=\"close\"></div> <div class=\"head\"> <div i18n=\"assistant_preview_header\" class=\"head_title\"> </div> <div i18n=\"assistant_preview_header_info\" class=\"head_text\"> </div> </div> <div class=\"foot\"> <button i18n=\"assistant_another_element\" class=\"btn btn-default\" id=\"select-another-element\" type=\"button\"></button> <div class=\"foot_action\"> <div class=\"foot_action_btn\"> <button i18n=\"assistant_preview_end\" class=\"btn btn-primary\" id=\"end-preview\" type=\"button\"></button> <button i18n=\"assistant_block\" class=\"btn btn-cancel\" id=\"block-element\" type=\"button\"></button> </div> </div> </div> </div>";
// Exports
module.exports = code;

/***/ }),

/***/ 6696:
/***/ ((module) => {

// Module
var code = "<div class=\"adguard-alert adguard-assistant-button-fixed adguard-assistant-button-main-logo\"></div> ";
// Exports
module.exports = code;

/***/ }),

/***/ 3317:
/***/ ((module) => {

// Module
var code = "<div class=\"main\"> <div class=\"close\"></div> <div class=\"menu-head\"> <div class=\"menu-head_title\"> <span class=\"menu-head_name\"></span> <div class=\"confidence-indication wot-hide\"> <a class=\"wot-indicator wot-hide\" target=\"_blank\" href=\"https://link.adtidy.org/forward.html?action=wot_scorecard&from=main_menu&app=assistant&domain=example.org\"> <i id=\"WotIndication\" class=\"adg-wot tooltip\" data-title=\"Site reputation indicator\"></i> </a> <i id=\"ConfidenceIndication\" class=\"adg-wot-confidence tooltip\" data-title=\"Reputation Confidence Level\"></i> </div> </div> <div class=\"menu-head_text wot-hide\" id=\"WotDescriptionText\"></div> </div> <div class=\"menu-filter\"> <div i18n=\"menu_filtration_status\" class=\"menu-filter_lbl\"> </div> <div class=\"menu-filter_val\"> <input type=\"checkbox\" class=\"menu-filter_input\" id=\"is-filter\"> <label for=\"is-filter\" class=\"menu-filter_label\"></label> </div> </div> <div class=\"menu\"> <div id=\"do-not-block-30-sec\" class=\"menu__btn menu__btn--clock\" i18n=\"menu_do_not_filter_30_sec\"></div> <div id=\"block-ad\" class=\"menu__btn menu__btn--landscape\" i18n=\"menu_block_ad_on_site\"></div> <div id=\"report-abuse\" class=\"menu__btn menu__btn--report\" i18n=\"menu_report_abuse\"></div> <div id=\"site-report\" class=\"menu__btn menu__btn--security\" i18n=\"menu_site_report\"></div> <div id=\"assistant-settings\" class=\"menu__btn menu__btn--settings\" i18n=\"menu_settings\"></div> </div> </div> ";
// Exports
module.exports = code;

/***/ }),

/***/ 4825:
/***/ ((module) => {

// Module
var code = "<div class=\"main mobile main-menu\"> <button i18n-title=\"close\" class=\"adg-close main-menu__btn main-menu__btn--close\">close</button> <button i18n-title=\"minus\" class=\"adg-minus main-menu__btn main-menu__btn--minus\">minus</button> <button i18n-title=\"plus\" class=\"adg-plus main-menu__btn main-menu__btn--plus\">plus</button> <button i18n-title=\"assistant_preview\" class=\"adg-preview main-menu__btn main-menu__btn--preview\">preview</button> <button i18n-title=\"assistant_block\" class=\"adg-accept main-menu__btn main-menu__btn--accept\">accept</button> </div> ";
// Exports
module.exports = code;

/***/ }),

/***/ 2115:
/***/ ((module) => {

// Module
var code = "<div class=\"main mobile main-popup\"> <div class=\"main-popup__logo adguard-assistant-button-main-logo\"></div> <h2 class=\"mobile-title main-popup__title\" i18n=\"assistant_select_element\"></h2> <div class=\"content main-popup__content\" i18n=\"assistant_select_element_text\"></div> <div class=\"footer\"> <button i18n=\"assistant_select_element_start\" class=\"btn btn-active start-select-mode main-popup__btn main-popup__btn--green\"></button> <button i18n=\"assistant_select_element_cancel\" class=\"btn cancel-select-mode main-popup__btn\"></button> </div> <i class=\"main-version\" id=\"appVersion\"></i> </div> ";
// Exports
module.exports = code;

/***/ }),

/***/ 8514:
/***/ ((module) => {

// Module
var code = "<div class=\"main adguard_sg_ignore\"> <div class=\"close adg-close\" id=\"close-button\"></div> <div class=\"head\" id=\"drag-handle\"> <div i18n=\"assistant_select_element\" class=\"head_title\"></div> <div i18n=\"assistant_select_element_ext\" class=\"head_text\"></div> </div> <div class=\"foot\"> <button i18n=\"assistant_select_element_cancel\" type=\"button\" class=\"btn btn-default\" id=\"cancel-select-mode\"></button> </div> </div> ";
// Exports
module.exports = code;

/***/ }),

/***/ 4693:
/***/ ((module) => {

// Module
var code = "<div class=\"main\"> <div class=\"close\"></div> <div class=\"head\"> <div i18n=\"assistant_settings\" class=\"head_title\"></div> <div i18n=\"settings_choose_size_and_position\" class=\"head_text head_text--mobile-h\"></div> </div> <div class=\"content\"> <div class=\"settings settings__horizontal\"> <div class=\"settings_fieldset\"> <div i18n=\"settings_position_save\" class=\"settings_fieldset_lbl\"></div> <div class=\"settings_fieldset_val\"> <div class=\"position-save\"> <div class=\"position-save_group\"> <div class=\"position-save_field\"> <input class=\"form-ui-control\" id=\"all-site\" type=\"radio\" name=\"position-save\"> <label class=\"form-ui\" for=\"all-site\"> <span i18n=\"settings_position_save_all\" class=\"form-ui-txt\"></span> </label> </div> <div class=\"position-save_field\"> <input class=\"form-ui-control\" id=\"this-site\" type=\"radio\" name=\"position-save\"> <label class=\"form-ui\" for=\"this-site\"> <span i18n=\"settings_position_save_this\" class=\"form-ui-txt\"></span> </label> </div> </div> </div> </div> </div> <div class=\"settings_fieldset\"> <div i18n=\"settings_icon_size\" class=\"settings_fieldset_lbl\"></div> <div class=\"settings_fieldset_val\"> <div class=\"choice-size\"> <div class=\"choice-size_group\"> <div class=\"choice-size_field\"> <input class=\"choice-size_input form-ui-control\" id=\"size-small\" type=\"radio\" name=\"radio\"> <label class=\"form-ui\" for=\"size-small\"> <span i18n=\"settings_small\" class=\"form-ui-txt\"></span> </label> <div class=\"adguard-assistant-button-main-logo choice-size_logo logo__small\"></div> </div> <div class=\"choice-size_field\"> <input class=\"choice-size_input form-ui-control\" id=\"size-big\" type=\"radio\" name=\"radio\"> <label class=\"form-ui\" for=\"size-big\"> <span i18n=\"settings_big\" class=\"form-ui-txt\"></span> </label> <div class=\"adguard-assistant-button-main-logo choice-size_logo\"></div> </div> </div> </div> </div> </div> <div class=\"settings_fieldset\"> <div i18n=\"settings_position\" class=\"settings_fieldset_lbl settings_fieldset_lbl__pos\"></div> <div class=\"settings_fieldset_val\"> <div class=\"change-position\"> <div class=\"change-position_i\"> <input type=\"radio\" name=\"position\" class=\"change-position_input\" id=\"position-top-left\"> <label class=\"change-position_label\" for=\"position-top-left\"> <span class=\"s-position-arr-top-left\"></span> </label> <div i18n=\"settings_left_top\" class=\"change-position_val\"></div> </div> <div class=\"change-position_i\"> <input type=\"radio\" name=\"position\" class=\"change-position_input\" id=\"position-top-right\"> <label class=\"change-position_label\" for=\"position-top-right\"> <span class=\"s-position-arr-top-right\"></span> </label> <div i18n=\"settings_right_top\" class=\"change-position_val\"></div> </div> <div class=\"change-position_i\"> <input type=\"radio\" name=\"position\" class=\"change-position_input\" id=\"position-bottom-left\"> <label class=\"change-position_label\" for=\"position-bottom-left\"> <span class=\"s-position-arr-bottom-left\"></span> </label> <div i18n=\"settings_left_bottom\" class=\"change-position_val\"></div> </div> <div class=\"change-position_i\"> <input type=\"radio\" name=\"position\" class=\"change-position_input\" id=\"position-bottom-right\"> <label class=\"change-position_label\" for=\"position-bottom-right\"> <span class=\"s-position-arr-bottom-right\"></span> </label> <div i18n=\"settings_right_bottom\" class=\"change-position_val\"></div> </div> </div> </div> </div> </div> </div> <div class=\"foot\"> <div class=\"foot_action\"> <div class=\"foot_action_btn\"> <button i18n=\"settings_cancel\" class=\"btn btn-default\" type=\"button\" id=\"cancel\"></button> <button i18n=\"settings_save\" class=\"btn btn-primary\" type=\"button\" id=\"save-settings\"></button> </div> </div> <div class=\"cf\"></div> </div> </div> ";
// Exports
module.exports = code;

/***/ }),

/***/ 7726:
/***/ ((module) => {

// Module
var code = "<div class=\"main\"> <div class=\"close adg-close\"></div> <div class=\"head head--slider\"> <div class=\"head_in head_in--slider\"> <div i18n=\"assistant_block_element\" class=\"head_title head_title--slider\" id=\"head_title\"></div> <div class=\"element-rule_more element-rule_more--mobile\"> <span class=\"element-rule_expand-link\" id=\"ExtendedSettingsText\"></span> <button i18n=\"assistant_block\" type=\"button\" class=\"btn btn-cancel\" id=\"adg-accept\"></button> <button i18n=\"assistant_another_element\" type=\"button\" class=\"btn btn-default\" id=\"adg-cancel\"></button> </div> </div> <div class=\"adg-slide-btns\"> <div class=\"adg-slide-btn adg-slide-btn--minus\"></div> <div class=\"adg-slide-btn adg-slide-btn--plus\"></div> </div> <div i18n=\"assistant_block_element_explain\" class=\"head_text head_text--mobile-h\" id=\"head_text\"></div> </div> <div class=\"content\" id=\"slider-area\"> <div class=\"element-rule element-rule--slider\"> <div i18n=\"assistant_slider_explain\" class=\"element-rule_text element-rule_text--slider\"></div> <div class=\"element-rule_slider\"> <div class=\"adg-slide\" id=\"slider\"> <div class=\"adg-slide-clue-max\">MAX</div> <div class=\"adg-slide-clue-min\">MIN</div> </div> </div> <div class=\"element-rule_more\"> <span class=\"element-rule_expand-link\" id=\"ExtendedSettingsText\"> <span i18n=\"assistant_extended_settings\" class=\"element-rule_expand-link_txt\"></span> <span class=\"element-rule_expand-link_arr\"></span> </span> </div> <div class=\"element-rule_form\" id=\"advanced-settings\"> <div class=\"element-rule_form-cont\"> <div class=\"element-rule_fieldset\" id=\"one-domain-checkbox-block\"> <input class=\"form-ui-control\" id=\"one-domain-checkbox\" type=\"checkbox\"/> <label for=\"one-domain-checkbox\" class=\"form-ui\"> <span i18n=\"assistant_apply_rule_to_all_sites\" class=\"form-ui-txt\"></span> </label> </div> <div style=\"display:none\" class=\"element-rule_fieldset\" id=\"block-by-url-checkbox-block\"> <input class=\"form-ui-control\" id=\"block-by-url-checkbox\" type=\"checkbox\"/> <label for=\"block-by-url-checkbox\" class=\"form-ui\"> <span i18n=\"assistant_block_by_reference\" class=\"form-ui-txt\"></span> </label> </div> <div style=\"display:none\" class=\"element-rule_fieldset\" id=\"block-similar-checkbox-block\"> <input class=\"form-ui-control\" id=\"block-similar-checkbox\" type=\"checkbox\"/> <label for=\"block-similar-checkbox\" class=\"form-ui\"> <span i18n=\"assistant_block_similar\" class=\"form-ui-txt\"></span> </label> </div> <div class=\"element-rule_fieldset\"> <input class=\"form-control\" id=\"filter-rule\" type=\"text\"/> </div> </div> </div> </div> </div> <div class=\"foot foot--slider\"> <button i18n=\"assistant_another_element\" type=\"button\" class=\"btn btn-default btn-another-el\" id=\"adg-cancel\"></button> <div class=\"foot_action\"> <div class=\"foot_action_btn\"> <button i18n=\"assistant_preview\" type=\"button\" class=\"btn btn-primary\" id=\"adg-preview\"></button> <button i18n=\"assistant_block\" type=\"button\" class=\"btn btn-cancel\" id=\"adg-accept\"></button> </div> </div> </div> </div> ";
// Exports
module.exports = code;

/***/ }),

/***/ 1403:
/***/ ((module, __unused_webpack_exports, __nested_webpack_require_284095__) => {


        var result = __nested_webpack_require_284095__(4123);

        if (typeof result === "string") {
            module.exports = result;
        } else {
            module.exports = result.toString();
        }
    

/***/ }),

/***/ 5487:
/***/ ((module, __unused_webpack_exports, __nested_webpack_require_284397__) => {


        var result = __nested_webpack_require_284397__(2571);

        if (typeof result === "string") {
            module.exports = result;
        } else {
            module.exports = result.toString();
        }
    

/***/ }),

/***/ 3228:
/***/ ((module, __unused_webpack_exports, __nested_webpack_require_284699__) => {


        var result = __nested_webpack_require_284699__(6469);

        if (typeof result === "string") {
            module.exports = result;
        } else {
            module.exports = result.toString();
        }
    

/***/ }),

/***/ 1953:
/***/ ((module, __unused_webpack_exports, __nested_webpack_require_285001__) => {


        var result = __nested_webpack_require_285001__(817);

        if (typeof result === "string") {
            module.exports = result;
        } else {
            module.exports = result.toString();
        }
    

/***/ }),

/***/ 5317:
/***/ ((module, __unused_webpack_exports, __nested_webpack_require_285302__) => {


        var result = __nested_webpack_require_285302__(3596);

        if (typeof result === "string") {
            module.exports = result;
        } else {
            module.exports = result.toString();
        }
    

/***/ }),

/***/ 8269:
/***/ ((__unused_webpack_module, __nested_webpack_exports__, __nested_webpack_require_285616__) => {

"use strict";
__nested_webpack_require_285616__.r(__nested_webpack_exports__);
/* harmony export */ __nested_webpack_require_285616__.d(__nested_webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ("data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTUgMTEuNzY2NUwxMC41ODc4IDE3TDE5IDgiIHN0cm9rZT0iIzY3QjI3OSIgc3Ryb2tlLXdpZHRoPSIxLjUiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIvPgo8L3N2Zz4K");

/***/ }),

/***/ 7062:
/***/ ((__unused_webpack_module, __nested_webpack_exports__, __nested_webpack_require_286335__) => {

"use strict";
__nested_webpack_require_286335__.r(__nested_webpack_exports__);
/* harmony export */ __nested_webpack_require_286335__.d(__nested_webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB2aWV3Qm94PSIwIDAgMTcgMTciIHZlcnNpb249IjEuMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayI+CiAgICA8ZyBpZD0iQXJ0Ym9hcmQiIHN0cm9rZT0ibm9uZSIgc3Ryb2tlLXdpZHRoPSIxIiBmaWxsPSJub25lIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiIHRyYW5zZm9ybT0idHJhbnNsYXRlKC0yMi4wMDAwMDAsIC0xNDQuMDAwMDAwKSI+CiAgICAgICAgPGcgaWQ9Ikdyb3VwLTIiIHRyYW5zZm9ybT0idHJhbnNsYXRlKDIzLjAwMDAwMCwgMTQxLjAwMDAwMCkiIHN0cm9rZT0iIzk3OTc5NyIgc3Ryb2tlLXdpZHRoPSIxLjM1Ij4KICAgICAgICAgICAgPGNpcmNsZSBpZD0iT3ZhbCIgY3g9IjcuODcwMzYxMzMiIGN5PSIxMS4yNzU5NzY2IiByPSI3LjM3ODg1NzQyIj48L2NpcmNsZT4KICAgICAgICAgICAgPHBvbHlsaW5lIGlkPSJMaW5lLTIiIHN0cm9rZS1saW5lY2FwPSJzcXVhcmUiIHBvaW50cz0iNy43Njc5Njg3NSA3LjQ2MzI4MTI1IDcuNzY3OTY4NzUgMTEuOTYzMjgxMiAxMS4zNjc5Njg3IDExLjk2MzI4MTIiPjwvcG9seWxpbmU+CiAgICAgICAgPC9nPgogICAgPC9nPgo8L3N2Zz4K");

/***/ }),

/***/ 1823:
/***/ ((__unused_webpack_module, __nested_webpack_exports__, __nested_webpack_require_287630__) => {

"use strict";
__nested_webpack_require_287630__.r(__nested_webpack_exports__);
/* harmony export */ __nested_webpack_require_287630__.d(__nested_webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4KPHN2ZyB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgdmlld0JveD0iMCAwIDEwMCAxMDAiPgogICAgPGxpbmUgZmlsbD0ibm9uZSIgc3Ryb2tlPSIjZWVlIiBzdHJva2Utd2lkdGg9IjIwIiB4MT0iNSIgeTE9IjUiIHgyPSI5NSIgeTI9Ijk1Ii8+CiAgICA8bGluZSBmaWxsPSJub25lIiBzdHJva2U9IiNlZWUiIHN0cm9rZS13aWR0aD0iMjAiIHgxPSI5NSIgeTE9IjUiIHgyPSI1IiB5Mj0iOTUiLz4KPC9zdmc+Cg==");

/***/ }),

/***/ 2668:
/***/ ((__unused_webpack_module, __nested_webpack_exports__, __nested_webpack_require_288445__) => {

"use strict";
__nested_webpack_require_288445__.r(__nested_webpack_exports__);
/* harmony export */ __nested_webpack_require_288445__.d(__nested_webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4KPHN2ZyB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgdmlld0JveD0iMCAwIDEwMCAxMDAiPgogICAgPGxpbmUgZmlsbD0ibm9uZSIgc3Ryb2tlPSIjMDAwMDAwIiBzdHJva2Utd2lkdGg9IjIwIiB4MT0iNSIgeTE9IjUiIHgyPSI5NSIgeTI9Ijk1Ii8+CiAgICA8bGluZSBmaWxsPSJub25lIiBzdHJva2U9IiMwMDAwMDAiIHN0cm9rZS13aWR0aD0iMjAiIHgxPSI5NSIgeTE9IjUiIHgyPSI1IiB5Mj0iOTUiLz4KPC9zdmc+Cg==");

/***/ }),

/***/ 1109:
/***/ ((__unused_webpack_module, __nested_webpack_exports__, __nested_webpack_require_289268__) => {

"use strict";
__nested_webpack_require_289268__.r(__nested_webpack_exports__);
/* harmony export */ __nested_webpack_require_289268__.d(__nested_webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ("data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTYuNDI4NTcgNi40Mjg1N0wxNy42MDQzIDE3LjYwNDMiIHN0cm9rZT0iI0E0QTRBNCIgc3Ryb2tlLXdpZHRoPSIxLjUiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIvPgo8cGF0aCBkPSJNNi40Mjc3MyAxNy41NzE0TDE3LjYwMzUgNi4zOTU2MyIgc3Ryb2tlPSIjQTRBNEE0IiBzdHJva2Utd2lkdGg9IjEuNSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIi8+Cjwvc3ZnPgo=");

/***/ }),

/***/ 6523:
/***/ ((__unused_webpack_module, __nested_webpack_exports__, __nested_webpack_require_290103__) => {

"use strict";
__nested_webpack_require_290103__.r(__nested_webpack_exports__);
/* harmony export */ __nested_webpack_require_290103__.d(__nested_webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB2aWV3Qm94PSIwIDAgMjAgMTkiIHZlcnNpb249IjEuMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayI+CiAgICA8ZGVmcz4KICAgICAgICA8cGF0aAogICAgICAgICAgICBkPSJNMjcuNjE1NjkzMSwzMjIuMjg4MDg2IEwyMC43Njc5Njg3LDMyMi4yODgwODYgTDIwLjc2Nzk2ODcsMzE1LjQxNjAyNiBMMjEuOTU5OTMxNCwzMTUuNDE2MDI2IEMyMi41MTAyOTA4LDMxNS40MTYwMjYgMjIuOTU2NDQ1MywzMTQuOTY5ODcxIDIyLjk1NjQ0NTMsMzE0LjQxOTUxMiBDMjIuOTU2NDQ1MywzMTMuODY5MTUzIDIyLjUxMDI5MDgsMzEzLjQyMjk5OCAyMS45NTk5MzE0LDMxMy40MjI5OTggTDIwLjc2Nzk2ODcsMzEzLjQyMjk5OCBMMjAuNzY3OTY4NywzMDYuOTE3MTEgTDI1LjkzOTg5MjYsMzA2LjkxNzExIEwyNS45Mzk4OTI2LDMwNi44MTYzNjggQzI1LjkzOTg5MjYsMzA1LjMyNTE5OSAyNy4xNDg3MjM4LDMwNC4xMTYzNjggMjguNjM5ODkyNiwzMDQuMTE2MzY4IEMzMC4xMzEwNjE0LDMwNC4xMTYzNjggMzEuMzM5ODkyNiwzMDUuMzI1MTk5IDMxLjMzOTg5MjYsMzA2LjgxNjM2OCBMMzEuMzM5ODkyNiwzMDYuOTE3MTEgTDM2LjEzODk0NDUsMzA2LjkxNzExIEwzNi4xMzg5NDQ1LDMxMS45MDI1OTggTDM2LjMzMjA4MDEsMzExLjkwMjU5OCBDMzcuODIzMjQ4OSwzMTEuOTAyNTk4IDM5LjAzMjA4MDEsMzEzLjExMTQyOSAzOS4wMzIwODAxLDMxNC42MDI1OTggQzM5LjAzMjA4MDEsMzE2LjA5Mzc2NyAzNy44MjMyNDg5LDMxNy4zMDI1OTggMzYuMzMyMDgwMSwzMTcuMzAyNTk4IEwzNi4xMzg5NDQ1LDMxNy4zMDI1OTggTDM2LjEzODk0NDUsMzIyLjI4ODA4NiBMMjkuNjA4NzIwOSwzMjIuMjg4MDg2IEwyOS42MDg3MjA5LDMyMC41NzE2OSBDMjkuNjA4NzIwOSwzMjAuMDIxMzMgMjkuMTYyNTY2NSwzMTkuNTc1MTc2IDI4LjYxMjIwNywzMTkuNTc1MTc2IEMyOC4wNjE4NDc2LDMxOS41NzUxNzYgMjcuNjE1NjkzMSwzMjAuMDIxMzMgMjcuNjE1NjkzMSwzMjAuNTcxNjkgTDI3LjYxNTY5MzEsMzIyLjI4ODA4NiBaIgogICAgICAgICAgICBpZD0icGF0aC0xIj48L3BhdGg+CiAgICA8L2RlZnM+CiAgICA8ZyBzdHJva2U9Im5vbmUiIHN0cm9rZS13aWR0aD0iMSIgZmlsbD0ibm9uZSIgZmlsbC1ydWxlPSJldmVub2RkIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtMjAuMDAwMDAwLCAtMzA0LjAwMDAwMCkiPgogICAgICAgIDxnPgogICAgICAgICAgICA8dXNlIGZpbGwtcnVsZT0iZXZlbm9kZCIgeGxpbms6aHJlZj0iI3BhdGgtMSI+PC91c2U+CiAgICAgICAgICAgIDxwYXRoCiAgICAgICAgICAgICAgICBzdHJva2U9IiM5Nzk3OTciCiAgICAgICAgICAgICAgICBzdHJva2Utd2lkdGg9IjEuMzUiCiAgICAgICAgICAgICAgICBkPSJNMjYuOTQwNjkzMSwzMjEuNjEzMDg2IEwyNi45NDA2OTMxLDMyMC41NzE2OSBDMjYuOTQwNjkzMSwzMTkuNjQ4NTM4IDI3LjY4OTA1NTQsMzE4LjkwMDE3NiAyOC42MTIyMDcsMzE4LjkwMDE3NiBDMjkuNTM1MzU4NywzMTguOTAwMTc2IDMwLjI4MzcyMDksMzE5LjY0ODUzOCAzMC4yODM3MjA5LDMyMC41NzE2OSBMMzAuMjgzNzIwOSwzMjEuNjEzMDg2IEwzNS40NjM5NDQ1LDMyMS42MTMwODYgTDM1LjQ2Mzk0NDUsMzE2LjYyNzU5OCBMMzYuMzMyMDgwMSwzMTYuNjI3NTk4IEMzNy40NTA0NTY3LDMxNi42Mjc1OTggMzguMzU3MDgwMSwzMTUuNzIwOTc1IDM4LjM1NzA4MDEsMzE0LjYwMjU5OCBDMzguMzU3MDgwMSwzMTMuNDg0MjIxIDM3LjQ1MDQ1NjcsMzEyLjU3NzU5OCAzNi4zMzIwODAxLDMxMi41Nzc1OTggTDM1LjQ2Mzk0NDUsMzEyLjU3NzU5OCBMMzUuNDYzOTQ0NSwzMDcuNTkyMTEgTDMwLjY2NDg5MjYsMzA3LjU5MjExIEwzMC42NjQ4OTI2LDMwNi44MTYzNjggQzMwLjY2NDg5MjYsMzA1LjY5Nzk5MSAyOS43NTgyNjkyLDMwNC43OTEzNjggMjguNjM5ODkyNiwzMDQuNzkxMzY4IEMyNy41MjE1MTYsMzA0Ljc5MTM2OCAyNi42MTQ4OTI2LDMwNS42OTc5OTEgMjYuNjE0ODkyNiwzMDYuODE2MzY4IEwyNi42MTQ4OTI2LDMwNy41OTIxMSBMMjEuNDQyOTY4NywzMDcuNTkyMTEgTDIxLjQ0Mjk2ODcsMzEyLjc0Nzk5OCBMMjEuOTU5OTMxNCwzMTIuNzQ3OTk4IEMyMi44ODMwODMxLDMxMi43NDc5OTggMjMuNjMxNDQ1MywzMTMuNDk2MzYgMjMuNjMxNDQ1MywzMTQuNDE5NTEyIEMyMy42MzE0NDUzLDMxNS4zNDI2NjQgMjIuODgzMDgzMSwzMTYuMDkxMDI2IDIxLjk1OTkzMTQsMzE2LjA5MTAyNiBMMjEuNDQyOTY4NywzMTYuMDkxMDI2IEwyMS40NDI5Njg3LDMyMS42MTMwODYgTDI2Ljk0MDY5MzEsMzIxLjYxMzA4NiBaIj48L3BhdGg+CiAgICAgICAgPC9nPgogICAgPC9nPgo8L3N2Zz4K");

/***/ }),

/***/ 9713:
/***/ ((__unused_webpack_module, __nested_webpack_exports__, __nested_webpack_require_293750__) => {

"use strict";
__nested_webpack_require_293750__.r(__nested_webpack_exports__);
/* harmony export */ __nested_webpack_require_293750__.d(__nested_webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ("data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTQgMTBDNCAxMCA4IDE0Ljc3MiAxMiAxNC43NzJDMTYgMTQuNzcyIDIwIDEwIDIwIDEwIiBzdHJva2U9IiM2N0IyNzkiIHN0cm9rZS13aWR0aD0iMS41IiBzdHJva2UtbGluZWNhcD0icm91bmQiLz4KPHBhdGggZD0iTTEyIDE1VjE3IiBzdHJva2U9IiM2N0IyNzkiIHN0cm9rZS13aWR0aD0iMS41IiBzdHJva2UtbGluZWNhcD0icm91bmQiLz4KPHBhdGggZD0iTTE4IDEzVjE1IiBzdHJva2U9IiM2N0IyNzkiIHN0cm9rZS13aWR0aD0iMS41IiBzdHJva2UtbGluZWNhcD0icm91bmQiLz4KPHBhdGggZD0iTTYgMTNWMTUiIHN0cm9rZT0iIzY3QjI3OSIgc3Ryb2tlLXdpZHRoPSIxLjUiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIvPgo8L3N2Zz4K");

/***/ }),

/***/ 2834:
/***/ ((__unused_webpack_module, __nested_webpack_exports__, __nested_webpack_require_294793__) => {

"use strict";
__nested_webpack_require_294793__.r(__nested_webpack_exports__);
/* harmony export */ __nested_webpack_require_294793__.d(__nested_webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ("data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZmlsbC1ydWxlPSJldmVub2RkIiBjbGlwLXJ1bGU9ImV2ZW5vZGQiIGQ9Ik00IDExLjc3MkM2LjY2NjY3IDguNTkwNjUgOS4zMzMzMyA3IDEyIDdDMTQuNjY2NyA3IDE3LjMzMzMgOC41OTA2NSAyMCAxMS43NzJDMjAgMTEuNzcyIDE2IDE2Ljc3MiAxMiAxNi43NzJDOCAxNi43NzIgNCAxMS43NzIgNCAxMS43NzJaIiBzdHJva2U9IiM2N0IyNzkiIHN0cm9rZS13aWR0aD0iMS41IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiLz4KPHBhdGggZmlsbC1ydWxlPSJldmVub2RkIiBjbGlwLXJ1bGU9ImV2ZW5vZGQiIGQ9Ik0xMiAxMEMxMy4xMDQ2IDEwIDE0IDEwLjg5NTQgMTQgMTJDMTQgMTMuMTA0NiAxMy4xMDQ2IDE0IDEyIDE0QzEwLjg5NTQgMTQgMTAgMTMuMTA0NiAxMCAxMkMxMCAxMC44OTU0IDEwLjg5NTQgMTAgMTIgMTBaIiBzdHJva2U9IiM2N0IyNzkiIHN0cm9rZS13aWR0aD0iMS41Ii8+Cjwvc3ZnPgo=");

/***/ }),

/***/ 6255:
/***/ ((__unused_webpack_module, __nested_webpack_exports__, __nested_webpack_require_295988__) => {

"use strict";
__nested_webpack_require_295988__.r(__nested_webpack_exports__);
/* harmony export */ __nested_webpack_require_295988__.d(__nested_webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB2aWV3Qm94PSIwIDAgMTkgMTciIHZlcnNpb249IjEuMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayI+CiAgICA8ZGVmcz4KICAgICAgICA8cmVjdCBpZD0icGF0aC0xIiB4PSIwLjc2Nzk2ODc1IiB5PSIwLjk4MDY2NDA2MyIgd2lkdGg9IjE4IiBoZWlnaHQ9IjE1Ljg4MDUxNzYiIHJ4PSIxLjgiPjwvcmVjdD4KICAgIDwvZGVmcz4KICAgIDxnIHN0cm9rZT0ibm9uZSIgc3Ryb2tlLXdpZHRoPSIxIiBmaWxsPSJub25lIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiIHRyYW5zZm9ybT0idHJhbnNsYXRlKC0yMC4wMDAwMDAsIC0xODQuMDAwMDAwKSI+CiAgICAgICAgPGcgaWQ9Ikdyb3VwLTMiIHRyYW5zZm9ybT0idHJhbnNsYXRlKDIwLjAwMDAwMCwgMTg0LjAwMDAwMCkiPgogICAgICAgICAgICA8ZyBpZD0iUmVjdGFuZ2xlIj4KICAgICAgICAgICAgICAgIDx1c2UgZmlsbC1ydWxlPSJldmVub2RkIiB4bGluazpocmVmPSIjcGF0aC0xIj48L3VzZT4KICAgICAgICAgICAgICAgIDxyZWN0IHN0cm9rZT0iIzk3OTc5NyIgc3Ryb2tlLXdpZHRoPSIxLjM1IiB4PSIxLjQ0Mjk2ODc1IiB5PSIxLjY1NTY2NDA2IiB3aWR0aD0iMTYuNjUiIGhlaWdodD0iMTQuNTMwNTE3NiIgcng9IjEuOCI+PC9yZWN0PgogICAgICAgICAgICA8L2c+CiAgICAgICAgICAgIDxwb2x5bGluZSBpZD0iTGluZS0zIiBzdHJva2U9IiM5Nzk3OTciIHN0cm9rZS13aWR0aD0iMS4zNSIgc3Ryb2tlLWxpbmVjYXA9InNxdWFyZSIgcG9pbnRzPSIxLjYyNjY2MDE2IDEzLjA3MTMzNzkgNS4yMjY2NjAxNiA5LjQ3MTMzNzg5IDguMTc0MDcyMjcgMTIuMTE1NTI3MyAxMi45Mjk4MzQgNi43MjgyNzE0OCAxNy44Njc5Njg3IDEyLjMzMzA1NjYiPjwvcG9seWxpbmU+CiAgICAgICAgPC9nPgogICAgPC9nPgo8L3N2Zz4K");

/***/ }),

/***/ 9053:
/***/ ((__unused_webpack_module, __nested_webpack_exports__, __nested_webpack_require_297719__) => {

"use strict";
__nested_webpack_require_297719__.r(__nested_webpack_exports__);
/* harmony export */ __nested_webpack_require_297719__.d(__nested_webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB2aWV3Qm94PSIwIDAgMzUgMzYiIHZlcnNpb249IjEuMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayI+CiAgICA8ZyBzdHJva2U9Im5vbmUiIHN0cm9rZS13aWR0aD0iMSIgZmlsbD0ibm9uZSIgZmlsbC1ydWxlPSJldmVub2RkIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtMTY0LjAwMDAwMCwgLTIxOS4wMDAwMDApIj4KICAgICAgICA8ZyBpZD0iMyIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoNDAuMDAwMDAwLCAxOTAuMDAwMDAwKSI+CiAgICAgICAgICAgIDxnIHRyYW5zZm9ybT0idHJhbnNsYXRlKDEyNC41MDAwMDAsIDI5LjQxNDA2MikiPgogICAgICAgICAgICAgICAgPGcgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMC40NTM2NTYsIDAuMjI2ODI4KSI+CiAgICAgICAgICAgICAgICAgICAgPGc+CiAgICAgICAgICAgICAgICAgICAgICAgIDxnPgogICAgICAgICAgICAgICAgICAgICAgICAgICAgPHBhdGgKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBkPSJNMTYuNzE1NzQ5MiwwIEMxMS40OTA5MTk1LDAgNS4xODg0Njg3NywxLjI2NTU4MzUxIDUuMTI2MjAxMTRlLTA2LDQuMDUxMjIyMzkgQzUuMTI2MjAxMTRlLTA2LDEwLjA2NzQ0OTUgLTAuMDcxNjEzNjMyNCwyNS4wNTU2OTI1IDE2LjcxNTc0OTIsMzUuMjk2Njc5OCBDMzMuNTAzNDgzLDI1LjA1NTY5MjUgMzMuNDMyMjM1NCwxMC4wNjc0NDk1IDMzLjQzMjIzNTQsNC4wNTEyMjIzOSBDMjguMjQzNDAwNiwxLjI2NTU4MzUxIDIxLjk0MDk0OTksMCAxNi43MTU3NDkyLDAgTDE2LjcxNTc0OTIsMCBaIgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlkPSJQYXRoIgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGZpbGw9IiM2OEJDNzEiPjwvcGF0aD4KICAgICAgICAgICAgICAgICAgICAgICAgICAgIDxwYXRoIGQ9Ik0xNi42OTg2NzQzLDM1LjI4NjI1ODIgQy0wLjA3MTU2NTA2MDUsMjUuMDQ1NTI2OCA1LjEyNjIwMTEzZS0wNiwxMC4wNjU0MDkxIDUuMTI2MjAxMTNlLTA2LDQuMDUxMjIyMzkgQzUuMTgyODE4MDIsMS4yNjg2MTczNCAxMS40NzcxOTI5LDAuMDAyNzU4NDkxMjQgMTYuNjk4Njc0Myw0LjUwMzc4MzExZS0wNiBMMTYuNjk4Njc0MywzNS4yODYyNjE3IFoiIGlkPSJDb21iaW5lZC1TaGFwZSIgZmlsbD0iIzY3QjI3OSI+PC9wYXRoPgogICAgICAgICAgICAgICAgICAgICAgICA8L2c+CiAgICAgICAgICAgICAgICAgICAgICAgIDxwYXRoCiAgICAgICAgICAgICAgICAgICAgICAgICAgICBkPSJNMTYuMTA2MDI0NywyMy41NTEwOTQgTDI2LjIxNDMxNTUsOS41MTgwMTg2OSBDMjUuNDczNjAwNSw4LjkwNjQ3MjQ5IDI0LjgyMzg4NzYsOS4zMzgwODkxNiAyNC40NjYyMjgxLDkuNjcyMjQ0IEwyNC40NTMxNzc0LDkuNjczMzE1MDEgTDE2LjAyNDg5ODcsMTguNzA0NDIwOCBMMTIuODQ5MzQ3NywxNC43NjgxMDUzIEMxMS4zMzQ0MDkxLDEyLjk2NTI0IDkuMjc0ODY4NjYsMTQuMzQwNDE1NyA4Ljc5Mzc1NjYyLDE0LjcwMzg0NDggTDE2LjEwNjAyNDcsMjMuNTUxMDk0IgogICAgICAgICAgICAgICAgICAgICAgICAgICAgaWQ9IkZpbGwtMTEiCiAgICAgICAgICAgICAgICAgICAgICAgICAgICBmaWxsPSIjRkZGRkZGIj48L3BhdGg+CiAgICAgICAgICAgICAgICAgICAgPC9nPgogICAgICAgICAgICAgICAgPC9nPgogICAgICAgICAgICA8L2c+CiAgICAgICAgPC9nPgogICAgPC9nPgo8L3N2Zz4K");

/***/ }),

/***/ 6265:
/***/ ((__unused_webpack_module, __nested_webpack_exports__, __nested_webpack_require_300518__) => {

"use strict";
__nested_webpack_require_300518__.r(__nested_webpack_exports__);
/* harmony export */ __nested_webpack_require_300518__.d(__nested_webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ("data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTEwIDZWMTBINiIgc3Ryb2tlPSIjQTRBNEE0IiBzdHJva2Utd2lkdGg9IjEuNSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIi8+CjxwYXRoIGQ9Ik0xMCAxOFYxNEg2IiBzdHJva2U9IiNBNEE0QTQiIHN0cm9rZS13aWR0aD0iMS41IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiLz4KPHBhdGggZD0iTTE0IDZWMTBIMTgiIHN0cm9rZT0iI0E0QTRBNCIgc3Ryb2tlLXdpZHRoPSIxLjUiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIvPgo8cGF0aCBkPSJNMTQgMThWMTRIMTgiIHN0cm9rZT0iI0E0QTRBNCIgc3Ryb2tlLXdpZHRoPSIxLjUiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIvPgo8L3N2Zz4K");

/***/ }),

/***/ 7693:
/***/ ((__unused_webpack_module, __nested_webpack_exports__, __nested_webpack_require_301645__) => {

"use strict";
__nested_webpack_require_301645__.r(__nested_webpack_exports__);
/* harmony export */ __nested_webpack_require_301645__.d(__nested_webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ("data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTYgMTBWNkgxME02IDE0VjE4SDEwTTE4IDEwVjZIMTRNMTggMTRWMThIMTQiIHN0cm9rZT0iI0E0QTRBNCIgc3Ryb2tlLXdpZHRoPSIxLjUiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIvPgo8L3N2Zz4K");

/***/ }),

/***/ 8115:
/***/ ((__unused_webpack_module, __nested_webpack_exports__, __nested_webpack_require_302388__) => {

"use strict";
__nested_webpack_require_302388__.r(__nested_webpack_exports__);
/* harmony export */ __nested_webpack_require_302388__.d(__nested_webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4KPHN2ZyB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiCiAgICAgd2lkdGg9IjQwMCIgaGVpZ2h0PSIyMDAiIHZpZXdCb3g9IjAgMCA0MDAgMjAwIj4KICAgIDxkZWZzPgogICAgICAgIDxnIGlkPSJhcnIiPgogICAgICAgICAgICA8cG9seWdvbiBwb2ludHM9IjE4LjgsODQuNSAxOC44LDMyIDg2LjcsMTAwIDEwMCw4Ni43IDMyLDE4LjggODQuNSwxOC44IDg0LjUsMCAxOC44LDAgMCwwIDAsMTguOAogICAgICAgICAgICAgICAgMCw4NC41IAkiLz4KICAgICAgICA8L2c+CiAgICA8L2RlZnM+CgogICAgPHVzZSB4bGluazpocmVmPSIjYXJyIiBmaWxsPSIjYWJhYmFiIi8+CiAgICA8dXNlIHhsaW5rOmhyZWY9IiNhcnIiIGZpbGw9IiNhYmFiYWIiIHRyYW5zZm9ybT0icm90YXRlKDkwIDEwMCAxMDApIi8+CiAgICA8dXNlIHhsaW5rOmhyZWY9IiNhcnIiIGZpbGw9IiNhYmFiYWIiIHRyYW5zZm9ybT0icm90YXRlKDE4MCAxMDAgMTAwKSIvPgogICAgPHVzZSB4bGluazpocmVmPSIjYXJyIiBmaWxsPSIjYWJhYmFiIiB0cmFuc2Zvcm09InJvdGF0ZSgyNzAgMTAwIDEwMCkiLz4KCiAgICA8dXNlIHhsaW5rOmhyZWY9IiNhcnIiIGZpbGw9IiNmZmYiIHg9IjIwMCIvPgogICAgPHVzZSB4bGluazpocmVmPSIjYXJyIiBmaWxsPSIjZmZmIiB5PSItMjAwIiB0cmFuc2Zvcm09InJvdGF0ZSg5MCAxMDAgMTAwKSIvPgogICAgPHVzZSB4bGluazpocmVmPSIjYXJyIiBmaWxsPSIjZmZmIiB4PSItMjAwIiB0cmFuc2Zvcm09InJvdGF0ZSgxODAgMTAwIDEwMCkiLz4KICAgIDx1c2UgeGxpbms6aHJlZj0iI2FyciIgZmlsbD0iI2ZmZiIgeT0iMjAwIiB0cmFuc2Zvcm09InJvdGF0ZSgyNzAgMTAwIDEwMCkiLz4KPC9zdmc+Cg==");

/***/ }),

/***/ 9385:
/***/ ((__unused_webpack_module, __nested_webpack_exports__, __nested_webpack_require_304083__) => {

"use strict";
__nested_webpack_require_304083__.r(__nested_webpack_exports__);
/* harmony export */ __nested_webpack_require_304083__.d(__nested_webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB2aWV3Qm94PSIwIDAgMTcgMTgiIHZlcnNpb249IjEuMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayI+CiAgICA8ZyBzdHJva2U9Im5vbmUiIHN0cm9rZS13aWR0aD0iMSIgZmlsbD0ibm9uZSIgZmlsbC1ydWxlPSJldmVub2RkIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtMjIuMDAwMDAwLCAtMjI0LjAwMDAwMCkiPgogICAgICAgIDxwYXRoIGQ9Ik0yMi44MTc1NzgxLDIzNC40MTc0NTUgTDIyLjgxNzU3ODEsMjQwLjU1OTc0NyBMMzYuODk2MDY2LDIzMi43MjMwODkgTDIyLjgxNzU3ODEsMjI1LjY5OTEyMSBMMjIuODE3NTc4MSwyMzEuMDgwNTcyIEwyNS45Nzg4MzYzLDIzMi42NTc3NzEgTDIyLjgxNzU3ODEsMjM0LjQxNzQ1NSBaIiBpZD0iQ29tYmluZWQtU2hhcGUiIHN0cm9rZT0iIzk3OTc5NyIgc3Ryb2tlLXdpZHRoPSIxLjM1Ij48L3BhdGg+CiAgICA8L2c+Cjwvc3ZnPgo=");

/***/ }),

/***/ 8225:
/***/ ((__unused_webpack_module, __nested_webpack_exports__, __nested_webpack_require_305218__) => {

"use strict";
__nested_webpack_require_305218__.r(__nested_webpack_exports__);
/* harmony export */ __nested_webpack_require_305218__.d(__nested_webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB2aWV3Qm94PSIwIDAgMTggMTgiIHZlcnNpb249IjEuMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayI+CiAgICA8ZyBzdHJva2U9Im5vbmUiIHN0cm9rZS13aWR0aD0iMSIgZmlsbD0ibm9uZSIgZmlsbC1ydWxlPSJldmVub2RkIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtMjEuMDAwMDAwLCAtMjYzLjAwMDAwMCkiPgogICAgICAgIDxwYXRoIGQ9Ik0zMC4wMjM1ODk1LDI4MC4xMTkwMjQgQzI5Ljk3MTAwMTYsMjgwLjExOTAyNCAyOS45MTgzNjI1LDI4MC4xMTA4OTggMjkuODY3NjY1NSwyODAuMDk0NjQ3IEMyOC4xNjM1OTE1LDI3OS41NDg3ODUgMjYuNzEyNzk4MSwyNzguNTAxNzc5IDI1LjU1NTUwNTcsMjc2Ljk4Mjc1OSBDMjQuNjQ0MzkwMywyNzUuNzg2ODMxIDIzLjkxNDg1NCwyNzQuMjk4MzczIDIzLjM4NzI4ODEsMjcyLjU1ODcyOSBDMjIuNDk3MzMwNSwyNjkuNjI0NDg1IDIyLjQ4NzEwOTQsMjY3LjAxMDUyMiAyMi40ODcxMDk0LDI2Ni45MDA2OTYgQzIyLjQ4NzEwOTQsMjY2LjYzNzUwMSAyMi42ODcwMzU1LDI2Ni40MTcyODYgMjIuOTQ5MDU1MywyNjYuMzkxOTg4IEMyMi45ODg1MDksMjY2LjM4ODE1NSAyNi45NTc2OTc0LDI2NS45ODA2ODggMjkuNzIzMjkxNCwyNjMuOTcyMjc5IEMyOS45MDIzNjY0LDI2My44NDIxNjMgMzAuMTQ0ODYzNywyNjMuODQyMzE2IDMwLjMyMzkzODcsMjYzLjk3MjMzIEMzMy4wODg3NjYyLDI2NS45ODA2ODggMzcuMDU4NDY1NiwyNjYuMzg4MTU1IDM3LjA5ODIyNTksMjY2LjM5MjAzOSBDMzcuMzYwMDQxMywyNjYuNDE3NTkyIDM3LjU1OTkxNjMsMjY2LjYzNzcwNSAzNy41NTk5MTYzLDI2Ni45MDA2OTYgQzM3LjU1OTkxNjMsMjY3LjAxMDUyMiAzNy41NDk2OTUyLDI2OS42MjQ0ODUgMzYuNjU5Nzg4NywyNzIuNTU4NzggQzM2LjEzMjE3MTcsMjc0LjI5ODQyNCAzNS40MDI2ODY1LDI3NS43ODY4ODIgMzQuNDkxNTcxMSwyNzYuOTgyODExIEMzMy4zMzQzMjk5LDI3OC41MDE4MyAzMS44ODM1MzY1LDI3OS41NDg4MzYgMzAuMTc5NDYyNCwyODAuMDk0Njk4IEMzMC4xMjg3NjU0LDI4MC4xMTA4OTggMzAuMDc2MTc3NSwyODAuMTE5MDI0IDMwLjAyMzU4OTUsMjgwLjExOTAyNCBMMzAuMDIzNTg5NSwyODAuMTE5MDI0IFoiIGlkPSJQYXRoIiBzdHJva2U9IiM5Nzk3OTciIHN0cm9rZS13aWR0aD0iMS4zNSI+PC9wYXRoPgogICAgPC9nPgo8L3N2Zz4K");

/***/ }),

/***/ 2286:
/***/ ((__unused_webpack_module, __nested_webpack_exports__, __nested_webpack_require_307341__) => {

"use strict";
__nested_webpack_require_307341__.r(__nested_webpack_exports__);
/* harmony export */ __nested_webpack_require_307341__.d(__nested_webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB2aWV3Qm94PSIwIDAgMTkgMTkiIHZlcnNpb249IjEuMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayI+CiAgICA8ZyBzdHJva2U9Im5vbmUiIHN0cm9rZS13aWR0aD0iMSIgZmlsbD0ibm9uZSIgZmlsbC1ydWxlPSJldmVub2RkIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtMjAuMDAwMDAwLCAtMzQzLjAwMDAwMCkiPgogICAgICAgIDxnIHRyYW5zZm9ybT0idHJhbnNsYXRlKDIwLjE0MjM4MywgMzQzLjMwMzQ2NykiIHN0cm9rZT0iIzk3OTc5NyIgc3Ryb2tlLXdpZHRoPSIxLjM1Ij4KICAgICAgICAgICAgPHBhdGgKICAgICAgICAgICAgICAgIGQ9Ik03LjcxMTUyMzQ0LDEuOTAwNjM0NzcgTDcuNzExNTIzNDQsMi44OTYzNDMxNSBMNy4yMjkwNjY5NCwzLjAzOTkyOTIyIEM2LjgxMTM1NTQzLDMuMTY0MjQ2MjUgNi40MDg2MjIwOCwzLjMzMTQ2NDY4IDYuMDI2NDg4NDEsMy41Mzg1MzQ3NyBMNS41ODM3MDgzMiwzLjc3ODQ2Nzg2IEw0Ljg3OTEwMjQyLDMuMDczODYxOTYgQzQuNDM5NzYyNiwyLjYzNDUyMjE0IDMuNzI3NDUxOTksMi42MzQ1MjIxNCAzLjI4ODExMjE3LDMuMDczODYxOTYgTDMuMDAyMjMxMSwzLjM1OTc0MzAzIEMyLjU2Mjg5MTI4LDMuNzk5MDgyODUgMi41NjI4OTEyOCw0LjUxMTM5MzQ2IDMuMDAyMjMxMSw0Ljk1MDczMzI4IEwzLjcwNjgzNyw1LjY1NTMzOTE4IEwzLjQ2NjkwMzkxLDYuMDk4MTE5MjcgQzMuMjU5ODMzODIsNi40ODAyNTI5MyAzLjA5MjYxNTM5LDYuODgyOTg2MjkgMi45NjgyOTgzNiw3LjMwMDY5NzggTDIuODI0NzEyMjksNy43ODMxNTQzIEwxLjgyOTAwMzkxLDcuNzgzMTU0MyBDMS4yMDc2ODM1Niw3Ljc4MzE1NDMgMC43MDQwMDM5MDYsOC4yODY4MzM5NSAwLjcwNDAwMzkwNiw4LjkwODE1NDMgTDAuNzA0MDAzOTA2LDkuMzEyNDUxMTcgQzAuNzA0MDAzOTA2LDkuOTMzNzcxNTIgMS4yMDc2ODM1NiwxMC40Mzc0NTEyIDEuODI5MDAzOTEsMTAuNDM3NDUxMiBMMi44MjQ3MTIyOSwxMC40Mzc0NTEyIEwyLjk2ODI5ODM2LDEwLjkxOTkwNzcgQzMuMDkyNjE1MzksMTEuMzM3NjE5MiAzLjI1OTgzMzgyLDExLjc0MDM1MjUgMy40NjY5MDM5MSwxMi4xMjI0ODYyIEwzLjcwNjgzNywxMi41NjUyNjYzIEwzLjAwMjIzMTEsMTMuMjY5ODcyMiBDMi41NjI4OTEyOCwxMy43MDkyMTIgMi41NjI4OTEyOCwxNC40MjE1MjI2IDMuMDAyMjMxMSwxNC44NjA4NjI0IEwzLjI4ODExMjE3LDE1LjE0Njc0MzUgQzMuNzI3NDUxOTksMTUuNTg2MDgzMyA0LjQzOTc2MjYsMTUuNTg2MDgzMyA0Ljg3OTEwMjQyLDE1LjE0Njc0MzUgTDUuNTgzNzA4MzIsMTQuNDQyMTM3NiBMNi4wMjY0ODg0MSwxNC42ODIwNzA3IEM2LjQwODYyMjA4LDE0Ljg4OTE0MDggNi44MTEzNTU0MywxNS4wNTYzNTkyIDcuMjI5MDY2OTQsMTUuMTgwNjc2MiBMNy43MTE1MjM0NCwxNS4zMjQyNjIzIEw3LjcxMTUyMzQ0LDE2LjMxOTk3MDcgQzcuNzExNTIzNDQsMTYuOTQxMjkxIDguMjE1MjAzMDksMTcuNDQ0OTcwNyA4LjgzNjUyMzQ0LDE3LjQ0NDk3MDcgTDkuMjQwODIwMzEsMTcuNDQ0OTcwNyBDOS44NjIxNDA2NiwxNy40NDQ5NzA3IDEwLjM2NTgyMDMsMTYuOTQxMjkxIDEwLjM2NTgyMDMsMTYuMzE5OTcwNyBMMTAuMzY1ODIwMywxNS4zMjQyNjIzIEwxMC44NDgyNzY4LDE1LjE4MDY3NjIgQzExLjI2NTk4ODMsMTUuMDU2MzU5MiAxMS42Njg3MjE3LDE0Ljg4OTE0MDggMTIuMDUwODU1MywxNC42ODIwNzA3IEwxMi40OTM2MzU0LDE0LjQ0MjEzNzYgTDEzLjE5ODI0MTMsMTUuMTQ2NzQzNSBDMTMuNjM3NTgxMiwxNS41ODYwODMzIDE0LjM0OTg5MTgsMTUuNTg2MDgzMyAxNC43ODkyMzE2LDE1LjE0Njc0MzUgTDE1LjA3NTExMjYsMTQuODYwODYyNCBDMTUuNTE0NDUyNSwxNC40MjE1MjI2IDE1LjUxNDQ1MjUsMTMuNzA5MjEyIDE1LjA3NTExMjYsMTMuMjY5ODcyMiBMMTQuMzcwNTA2NywxMi41NjUyNjYzIEwxNC42MTA0Mzk4LDEyLjEyMjQ4NjIgQzE0LjgxNzUwOTksMTEuNzQwMzUyNSAxNC45ODQ3Mjg0LDExLjMzNzYxOTIgMTUuMTA5MDQ1NCwxMC45MTk5MDc3IEwxNS4yNTI2MzE1LDEwLjQzNzQ1MTIgTDE2LjI0ODMzOTgsMTAuNDM3NDUxMiBDMTYuODY5NjYwMiwxMC40Mzc0NTEyIDE3LjM3MzMzOTgsOS45MzM3NzE1MiAxNy4zNzMzMzk4LDkuMzEyNDUxMTcgTDE3LjM3MzMzOTgsOC45MDgxNTQzIEMxNy4zNzMzMzk4LDguMjg2ODMzOTUgMTYuODY5NjYwMiw3Ljc4MzE1NDMgMTYuMjQ4MzM5OCw3Ljc4MzE1NDMgTDE1LjI1MjYzMTUsNy43ODMxNTQzIEwxNS4xMDkwNDU0LDcuMzAwNjk3OCBDMTQuOTg0NzI4NCw2Ljg4Mjk4NjI5IDE0LjgxNzUwOTksNi40ODAyNTI5MyAxNC42MTA0Mzk4LDYuMDk4MTE5MjcgTDE0LjM3MDUwNjcsNS42NTUzMzkxOCBMMTUuMDc1MTEyNiw0Ljk1MDczMzI4IEMxNS41MTQ0NTI1LDQuNTExMzkzNDYgMTUuNTE0NDUyNSwzLjc5OTA4Mjg1IDE1LjA3NTExMjYsMy4zNTk3NDMwMyBMMTQuNzg5MjMxNiwzLjA3Mzg2MTk2IEMxNC4zNDk4OTE4LDIuNjM0NTIyMTQgMTMuNjM3NTgxMiwyLjYzNDUyMjE0IDEzLjE5ODI0MTMsMy4wNzM4NjE5NiBMMTIuNDkzNjM1NCwzLjc3ODQ2Nzg2IEwxMi4wNTA4NTUzLDMuNTM4NTM0NzcgQzExLjY2ODcyMTcsMy4zMzE0NjQ2OCAxMS4yNjU5ODgzLDMuMTY0MjQ2MjUgMTAuODQ4Mjc2OCwzLjAzOTkyOTIyIEwxMC4zNjU4MjAzLDIuODk2MzQzMTUgTDEwLjM2NTgyMDMsMS45MDA2MzQ3NyBDMTAuMzY1ODIwMywxLjI3OTMxNDQyIDkuODYyMTQwNjYsMC43NzU2MzQ3NjYgOS4yNDA4MjAzMSwwLjc3NTYzNDc2NiBMOC44MzY1MjM0NCwwLjc3NTYzNDc2NiBDOC4yMTUyMDMwOSwwLjc3NTYzNDc2NiA3LjcxMTUyMzQ0LDEuMjc5MzE0NDIgNy43MTE1MjM0NCwxLjkwMDYzNDc3IFoiCiAgICAgICAgICAgICAgICBpZD0iQ29tYmluZWQtU2hhcGUiPjwvcGF0aD4KICAgICAgICAgICAgPGNpcmNsZSBpZD0iT3ZhbC0xNSIgY3g9IjkuMDM4NjcxODgiIGN5PSI5LjExMDMwMjczIiByPSIxLjgiPjwvY2lyY2xlPgogICAgICAgIDwvZz4KICAgIDwvZz4KPC9zdmc+Cg==");

/***/ }),

/***/ 1660:
/***/ ((__unused_webpack_module, __nested_webpack_exports__, __nested_webpack_require_311896__) => {

"use strict";
__nested_webpack_require_311896__.r(__nested_webpack_exports__);
/* harmony export */ __nested_webpack_require_311896__.d(__nested_webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgdmlld0JveD0iMCAwIDUyIDE4Ij4KICAgIDxwYXRoIGQ9Ik01LjM1Myw3LjQxMiBMNS4zMDQsNy4zNjMgQzcuMTIxLDcuMTI1IDguNTI5LDUuNTg3IDguNTI5LDMuNzA2IEM4LjUyOSwxLjY1OSA2Ljg3LDAgNC44MjQsMCBDMi43NzcsMCAxLjExOCwxLjY1OSAxLjExOCwzLjcwNiBDMS4xMTgsNS41NzIgMi41MDIsNy4wOTkgNC4yOTQsNy4zNTggTDQuMjk0LDcuNDEyIEMxLjExOCw3LjQxMiAwLjA1OSw5LjUyOSAwLjA1OSw5LjUyOSBMMS4xMTgsMTUuODgyIEMxLjExOCwxNi45MzggMi40NzUsMTcuODA2IDQuMjQ0LDE3Ljk2NyBMNC4yOTQsMTggTDUuMzUzLDE4IEw1LjQwMywxNy45NjcgQzcuMTcyLDE3LjgwNiA4LjUyOSwxNi45MzggOC41MjksMTUuODgyIEw5LjU4OCw5LjUyOSBDOS41ODgsOS41MjkgOC41MjksNy40MTIgNS4zNTMsNy40MTIgeiIgZmlsbD0iI0Q2RDZENiIvPgogICAgPHBhdGggZD0iTTE1Ljk0MSw3LjQxMiBMMTUuODkyLDcuMzYzIEMxNy43MDksNy4xMjUgMTkuMTE4LDUuNTg3IDE5LjExOCwzLjcwNiBDMTkuMTE4LDEuNjU5IDE3LjQ1OCwwIDE1LjQxMiwwIEMxMy4zNjUsMCAxMS43MDYsMS42NTkgMTEuNzA2LDMuNzA2IEMxMS43MDYsNS41NzIgMTMuMDksNy4wOTkgMTQuODgyLDcuMzU4IEwxNC44ODIsNy40MTIgQzExLjcwNiw3LjQxMiAxMC42NDcsOS41MjkgMTAuNjQ3LDkuNTI5IEwxMS43MDYsMTUuODgyIEMxMS43MDYsMTYuOTM4IDEzLjA2MywxNy44MDYgMTQuODMzLDE3Ljk2NyBMMTQuODgyLDE4IEwxNS45NDEsMTggTDE1Ljk5MSwxNy45NjcgQzE3Ljc2LDE3LjgwNiAxOS4xMTgsMTYuOTM4IDE5LjExOCwxNS44ODIgTDIwLjE3Niw5LjUyOSBDMjAuMTc2LDkuNTI5IDE5LjExOCw3LjQxMiAxNS45NDEsNy40MTIgeiIgZmlsbD0iI0Q2RDZENiIvPgogICAgPHBhdGggZD0iTTI2LjUyOSw3LjQxMiBMMjYuNDgxLDcuMzYzIEMyOC4yOTgsNy4xMjUgMjkuNzA2LDUuNTg3IDI5LjcwNiwzLjcwNiBDMjkuNzA2LDEuNjU5IDI4LjA0NywwIDI2LDAgQzIzLjk1MywwIDIyLjI5NCwxLjY1OSAyMi4yOTQsMy43MDYgQzIyLjI5NCw1LjU3MiAyMy42NzgsNy4wOTkgMjUuNDcxLDcuMzU4IEwyNS40NzEsNy40MTIgQzIyLjI5NCw3LjQxMiAyMS4yMzUsOS41MjkgMjEuMjM1LDkuNTI5IEwyMi4yOTQsMTUuODgyIEMyMi4yOTQsMTYuOTM4IDIzLjY1MiwxNy44MDYgMjUuNDIxLDE3Ljk2NyBMMjUuNDcxLDE4IEwyNi41MjksMTggTDI2LjU3OSwxNy45NjcgQzI4LjM0OCwxNy44MDYgMjkuNzA2LDE2LjkzOCAyOS43MDYsMTUuODgyIEwzMC43NjUsOS41MjkgQzMwLjc2NSw5LjUyOSAyOS43MDYsNy40MTIgMjYuNTI5LDcuNDEyIHoiIGZpbGw9IiNENkQ2RDYiLz4KICAgIDxwYXRoIGQ9Ik0zNy4xMTgsNy40MTIgTDM3LjA2OSw3LjM2MyBDMzguODg2LDcuMTI1IDQwLjI5NCw1LjU4NyA0MC4yOTQsMy43MDYgQzQwLjI5NCwxLjY1OSAzOC42MzUsMCAzNi41ODgsMCBDMzQuNTQyLDAgMzIuODgyLDEuNjU5IDMyLjg4MiwzLjcwNiBDMzIuODgyLDUuNTcyIDM0LjI2Niw3LjA5OSAzNi4wNTksNy4zNTggTDM2LjA1OSw3LjQxMiBDMzIuODgyLDcuNDEyIDMxLjgyNCw5LjUyOSAzMS44MjQsOS41MjkgTDMyLjg4MiwxNS44ODIgQzMyLjg4MiwxNi45MzggMzQuMjQsMTcuODA2IDM2LjAwOSwxNy45NjcgTDM2LjA1OSwxOCBMMzcuMTE4LDE4IEwzNy4xNjcsMTcuOTY3IEMzOC45MzcsMTcuODA2IDQwLjI5NCwxNi45MzggNDAuMjk0LDE1Ljg4MiBMNDEuMzUzLDkuNTI5IEM0MS4zNTMsOS41MjkgNDAuMjk0LDcuNDEyIDM3LjExOCw3LjQxMiB6IiBmaWxsPSIjRDZENkQ2Ii8+CiAgICA8cGF0aCBkPSJNNDcuNzA2LDcuNDEyIEw0Ny42NTcsNy4zNjMgQzQ5LjQ3NCw3LjEyNSA1MC44ODIsNS41ODcgNTAuODgyLDMuNzA2IEM1MC44ODIsMS42NTkgNDkuMjIzLDAgNDcuMTc2LDAgQzQ1LjEzLDAgNDMuNDcxLDEuNjU5IDQzLjQ3MSwzLjcwNiBDNDMuNDcxLDUuNTcyIDQ0Ljg1NCw3LjA5OSA0Ni42NDcsNy4zNTggTDQ2LjY0Nyw3LjQxMiBDNDMuNDcxLDcuNDEyIDQyLjQxMiw5LjUyOSA0Mi40MTIsOS41MjkgTDQzLjQ3MSwxNS44ODIgQzQzLjQ3MSwxNi45MzggNDQuODI4LDE3LjgwNiA0Ni41OTcsMTcuOTY3IEw0Ni42NDcsMTggTDQ3LjcwNiwxOCBMNDcuNzU2LDE3Ljk2NyBDNDkuNTI1LDE3LjgwNiA1MC44ODIsMTYuOTM4IDUwLjg4MiwxNS44ODIgTDUxLjk0MSw5LjUyOSBDNTEuOTQxLDkuNTI5IDUwLjg4Miw3LjQxMiA0Ny43MDYsNy40MTIgeiIgZmlsbD0iI0Q2RDZENiIvPgo8L3N2Zz4K");

/***/ }),

/***/ 1372:
/***/ ((__unused_webpack_module, __nested_webpack_exports__, __nested_webpack_require_315455__) => {

"use strict";
__nested_webpack_require_315455__.r(__nested_webpack_exports__);
/* harmony export */ __nested_webpack_require_315455__.d(__nested_webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgdmlld0JveD0iMCAwIDUyIDE4Ij4KICAgIDxwYXRoIGQ9Ik01LjM1Myw3LjQxMiBMNS4zMDQsNy4zNjMgQzcuMTIxLDcuMTI1IDguNTI5LDUuNTg3IDguNTI5LDMuNzA2IEM4LjUyOSwxLjY1OSA2Ljg3LDAgNC44MjQsMCBDMi43NzcsMCAxLjExOCwxLjY1OSAxLjExOCwzLjcwNiBDMS4xMTgsNS41NzIgMi41MDIsNy4wOTkgNC4yOTQsNy4zNTggTDQuMjk0LDcuNDEyIEMxLjExOCw3LjQxMiAwLjA1OSw5LjUyOSAwLjA1OSw5LjUyOSBMMS4xMTgsMTUuODgyIEMxLjExOCwxNi45MzggMi40NzUsMTcuODA2IDQuMjQ0LDE3Ljk2NyBMNC4yOTQsMTggTDUuMzUzLDE4IEw1LjQwMywxNy45NjcgQzcuMTcyLDE3LjgwNiA4LjUyOSwxNi45MzggOC41MjksMTUuODgyIEw5LjU4OCw5LjUyOSBDOS41ODgsOS41MjkgOC41MjksNy40MTIgNS4zNTMsNy40MTIgeiIgZmlsbD0iIzcxNzE3MSIvPgogICAgPHBhdGggZD0iTTE1Ljk0MSw3LjQxMiBMMTUuODkyLDcuMzYzIEMxNy43MDksNy4xMjUgMTkuMTE4LDUuNTg3IDE5LjExOCwzLjcwNiBDMTkuMTE4LDEuNjU5IDE3LjQ1OCwwIDE1LjQxMiwwIEMxMy4zNjUsMCAxMS43MDYsMS42NTkgMTEuNzA2LDMuNzA2IEMxMS43MDYsNS41NzIgMTMuMDksNy4wOTkgMTQuODgyLDcuMzU4IEwxNC44ODIsNy40MTIgQzExLjcwNiw3LjQxMiAxMC42NDcsOS41MjkgMTAuNjQ3LDkuNTI5IEwxMS43MDYsMTUuODgyIEMxMS43MDYsMTYuOTM4IDEzLjA2MywxNy44MDYgMTQuODMzLDE3Ljk2NyBMMTQuODgyLDE4IEwxNS45NDEsMTggTDE1Ljk5MSwxNy45NjcgQzE3Ljc2LDE3LjgwNiAxOS4xMTgsMTYuOTM4IDE5LjExOCwxNS44ODIgTDIwLjE3Niw5LjUyOSBDMjAuMTc2LDkuNTI5IDE5LjExOCw3LjQxMiAxNS45NDEsNy40MTIgeiIgZmlsbD0iI0Q2RDZENiIvPgogICAgPHBhdGggZD0iTTI2LjUyOSw3LjQxMiBMMjYuNDgxLDcuMzYzIEMyOC4yOTgsNy4xMjUgMjkuNzA2LDUuNTg3IDI5LjcwNiwzLjcwNiBDMjkuNzA2LDEuNjU5IDI4LjA0NywwIDI2LDAgQzIzLjk1MywwIDIyLjI5NCwxLjY1OSAyMi4yOTQsMy43MDYgQzIyLjI5NCw1LjU3MiAyMy42NzgsNy4wOTkgMjUuNDcxLDcuMzU4IEwyNS40NzEsNy40MTIgQzIyLjI5NCw3LjQxMiAyMS4yMzUsOS41MjkgMjEuMjM1LDkuNTI5IEwyMi4yOTQsMTUuODgyIEMyMi4yOTQsMTYuOTM4IDIzLjY1MiwxNy44MDYgMjUuNDIxLDE3Ljk2NyBMMjUuNDcxLDE4IEwyNi41MjksMTggTDI2LjU3OSwxNy45NjcgQzI4LjM0OCwxNy44MDYgMjkuNzA2LDE2LjkzOCAyOS43MDYsMTUuODgyIEwzMC43NjUsOS41MjkgQzMwLjc2NSw5LjUyOSAyOS43MDYsNy40MTIgMjYuNTI5LDcuNDEyIHoiIGZpbGw9IiNENkQ2RDYiLz4KICAgIDxwYXRoIGQ9Ik0zNy4xMTgsNy40MTIgTDM3LjA2OSw3LjM2MyBDMzguODg2LDcuMTI1IDQwLjI5NCw1LjU4NyA0MC4yOTQsMy43MDYgQzQwLjI5NCwxLjY1OSAzOC42MzUsMCAzNi41ODgsMCBDMzQuNTQyLDAgMzIuODgyLDEuNjU5IDMyLjg4MiwzLjcwNiBDMzIuODgyLDUuNTcyIDM0LjI2Niw3LjA5OSAzNi4wNTksNy4zNTggTDM2LjA1OSw3LjQxMiBDMzIuODgyLDcuNDEyIDMxLjgyNCw5LjUyOSAzMS44MjQsOS41MjkgTDMyLjg4MiwxNS44ODIgQzMyLjg4MiwxNi45MzggMzQuMjQsMTcuODA2IDM2LjAwOSwxNy45NjcgTDM2LjA1OSwxOCBMMzcuMTE4LDE4IEwzNy4xNjcsMTcuOTY3IEMzOC45MzcsMTcuODA2IDQwLjI5NCwxNi45MzggNDAuMjk0LDE1Ljg4MiBMNDEuMzUzLDkuNTI5IEM0MS4zNTMsOS41MjkgNDAuMjk0LDcuNDEyIDM3LjExOCw3LjQxMiB6IiBmaWxsPSIjRDZENkQ2Ii8+CiAgICA8cGF0aCBkPSJNNDcuNzA2LDcuNDEyIEw0Ny42NTcsNy4zNjMgQzQ5LjQ3NCw3LjEyNSA1MC44ODIsNS41ODcgNTAuODgyLDMuNzA2IEM1MC44ODIsMS42NTkgNDkuMjIzLDAgNDcuMTc2LDAgQzQ1LjEzLDAgNDMuNDcxLDEuNjU5IDQzLjQ3MSwzLjcwNiBDNDMuNDcxLDUuNTcyIDQ0Ljg1NCw3LjA5OSA0Ni42NDcsNy4zNTggTDQ2LjY0Nyw3LjQxMiBDNDMuNDcxLDcuNDEyIDQyLjQxMiw5LjUyOSA0Mi40MTIsOS41MjkgTDQzLjQ3MSwxNS44ODIgQzQzLjQ3MSwxNi45MzggNDQuODI4LDE3LjgwNiA0Ni41OTcsMTcuOTY3IEw0Ni42NDcsMTggTDQ3LjcwNiwxOCBMNDcuNzU2LDE3Ljk2NyBDNDkuNTI1LDE3LjgwNiA1MC44ODIsMTYuOTM4IDUwLjg4MiwxNS44ODIgTDUxLjk0MSw5LjUyOSBDNTEuOTQxLDkuNTI5IDUwLjg4Miw3LjQxMiA0Ny43MDYsNy40MTIgeiIgZmlsbD0iI0Q2RDZENiIvPgo8L3N2Zz4K");

/***/ }),

/***/ 6112:
/***/ ((__unused_webpack_module, __nested_webpack_exports__, __nested_webpack_require_319014__) => {

"use strict";
__nested_webpack_require_319014__.r(__nested_webpack_exports__);
/* harmony export */ __nested_webpack_require_319014__.d(__nested_webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgdmlld0JveD0iMCAwIDUyIDE4Ij4KICAgIDxwYXRoIGQ9Ik01LjM1Myw3LjQxMiBMNS4zMDQsNy4zNjMgQzcuMTIxLDcuMTI1IDguNTI5LDUuNTg3IDguNTI5LDMuNzA2IEM4LjUyOSwxLjY1OSA2Ljg3LDAgNC44MjQsMCBDMi43NzcsMCAxLjExOCwxLjY1OSAxLjExOCwzLjcwNiBDMS4xMTgsNS41NzIgMi41MDIsNy4wOTkgNC4yOTQsNy4zNTggTDQuMjk0LDcuNDEyIEMxLjExOCw3LjQxMiAwLjA1OSw5LjUyOSAwLjA1OSw5LjUyOSBMMS4xMTgsMTUuODgyIEMxLjExOCwxNi45MzggMi40NzUsMTcuODA2IDQuMjQ0LDE3Ljk2NyBMNC4yOTQsMTggTDUuMzUzLDE4IEw1LjQwMywxNy45NjcgQzcuMTcyLDE3LjgwNiA4LjUyOSwxNi45MzggOC41MjksMTUuODgyIEw5LjU4OCw5LjUyOSBDOS41ODgsOS41MjkgOC41MjksNy40MTIgNS4zNTMsNy40MTIgeiIgZmlsbD0iIzcxNzE3MSIvPgogICAgPHBhdGggZD0iTTE1Ljk0MSw3LjQxMiBMMTUuODkyLDcuMzYzIEMxNy43MDksNy4xMjUgMTkuMTE4LDUuNTg3IDE5LjExOCwzLjcwNiBDMTkuMTE4LDEuNjU5IDE3LjQ1OCwwIDE1LjQxMiwwIEMxMy4zNjUsMCAxMS43MDYsMS42NTkgMTEuNzA2LDMuNzA2IEMxMS43MDYsNS41NzIgMTMuMDksNy4wOTkgMTQuODgyLDcuMzU4IEwxNC44ODIsNy40MTIgQzExLjcwNiw3LjQxMiAxMC42NDcsOS41MjkgMTAuNjQ3LDkuNTI5IEwxMS43MDYsMTUuODgyIEMxMS43MDYsMTYuOTM4IDEzLjA2MywxNy44MDYgMTQuODMzLDE3Ljk2NyBMMTQuODgyLDE4IEwxNS45NDEsMTggTDE1Ljk5MSwxNy45NjcgQzE3Ljc2LDE3LjgwNiAxOS4xMTgsMTYuOTM4IDE5LjExOCwxNS44ODIgTDIwLjE3Niw5LjUyOSBDMjAuMTc2LDkuNTI5IDE5LjExOCw3LjQxMiAxNS45NDEsNy40MTIgeiIgZmlsbD0iIzcxNzE3MSIvPgogICAgPHBhdGggZD0iTTI2LjUyOSw3LjQxMiBMMjYuNDgxLDcuMzYzIEMyOC4yOTgsNy4xMjUgMjkuNzA2LDUuNTg3IDI5LjcwNiwzLjcwNiBDMjkuNzA2LDEuNjU5IDI4LjA0NywwIDI2LDAgQzIzLjk1MywwIDIyLjI5NCwxLjY1OSAyMi4yOTQsMy43MDYgQzIyLjI5NCw1LjU3MiAyMy42NzgsNy4wOTkgMjUuNDcxLDcuMzU4IEwyNS40NzEsNy40MTIgQzIyLjI5NCw3LjQxMiAyMS4yMzUsOS41MjkgMjEuMjM1LDkuNTI5IEwyMi4yOTQsMTUuODgyIEMyMi4yOTQsMTYuOTM4IDIzLjY1MiwxNy44MDYgMjUuNDIxLDE3Ljk2NyBMMjUuNDcxLDE4IEwyNi41MjksMTggTDI2LjU3OSwxNy45NjcgQzI4LjM0OCwxNy44MDYgMjkuNzA2LDE2LjkzOCAyOS43MDYsMTUuODgyIEwzMC43NjUsOS41MjkgQzMwLjc2NSw5LjUyOSAyOS43MDYsNy40MTIgMjYuNTI5LDcuNDEyIHoiIGZpbGw9IiNENkQ2RDYiLz4KICAgIDxwYXRoIGQ9Ik0zNy4xMTgsNy40MTIgTDM3LjA2OSw3LjM2MyBDMzguODg2LDcuMTI1IDQwLjI5NCw1LjU4NyA0MC4yOTQsMy43MDYgQzQwLjI5NCwxLjY1OSAzOC42MzUsMCAzNi41ODgsMCBDMzQuNTQyLDAgMzIuODgyLDEuNjU5IDMyLjg4MiwzLjcwNiBDMzIuODgyLDUuNTcyIDM0LjI2Niw3LjA5OSAzNi4wNTksNy4zNTggTDM2LjA1OSw3LjQxMiBDMzIuODgyLDcuNDEyIDMxLjgyNCw5LjUyOSAzMS44MjQsOS41MjkgTDMyLjg4MiwxNS44ODIgQzMyLjg4MiwxNi45MzggMzQuMjQsMTcuODA2IDM2LjAwOSwxNy45NjcgTDM2LjA1OSwxOCBMMzcuMTE4LDE4IEwzNy4xNjcsMTcuOTY3IEMzOC45MzcsMTcuODA2IDQwLjI5NCwxNi45MzggNDAuMjk0LDE1Ljg4MiBMNDEuMzUzLDkuNTI5IEM0MS4zNTMsOS41MjkgNDAuMjk0LDcuNDEyIDM3LjExOCw3LjQxMiB6IiBmaWxsPSIjRDZENkQ2Ii8+CiAgICA8cGF0aCBkPSJNNDcuNzA2LDcuNDEyIEw0Ny42NTcsNy4zNjMgQzQ5LjQ3NCw3LjEyNSA1MC44ODIsNS41ODcgNTAuODgyLDMuNzA2IEM1MC44ODIsMS42NTkgNDkuMjIzLDAgNDcuMTc2LDAgQzQ1LjEzLDAgNDMuNDcxLDEuNjU5IDQzLjQ3MSwzLjcwNiBDNDMuNDcxLDUuNTcyIDQ0Ljg1NCw3LjA5OSA0Ni42NDcsNy4zNTggTDQ2LjY0Nyw3LjQxMiBDNDMuNDcxLDcuNDEyIDQyLjQxMiw5LjUyOSA0Mi40MTIsOS41MjkgTDQzLjQ3MSwxNS44ODIgQzQzLjQ3MSwxNi45MzggNDQuODI4LDE3LjgwNiA0Ni41OTcsMTcuOTY3IEw0Ni42NDcsMTggTDQ3LjcwNiwxOCBMNDcuNzU2LDE3Ljk2NyBDNDkuNTI1LDE3LjgwNiA1MC44ODIsMTYuOTM4IDUwLjg4MiwxNS44ODIgTDUxLjk0MSw5LjUyOSBDNTEuOTQxLDkuNTI5IDUwLjg4Miw3LjQxMiA0Ny43MDYsNy40MTIgeiIgZmlsbD0iI0Q2RDZENiIvPgo8L3N2Zz4K");

/***/ }),

/***/ 9919:
/***/ ((__unused_webpack_module, __nested_webpack_exports__, __nested_webpack_require_322573__) => {

"use strict";
__nested_webpack_require_322573__.r(__nested_webpack_exports__);
/* harmony export */ __nested_webpack_require_322573__.d(__nested_webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgdmlld0JveD0iMCAwIDUyIDE4Ij4KICAgIDxwYXRoIGQ9Ik01LjM1Myw3LjQxMiBMNS4zMDQsNy4zNjMgQzcuMTIxLDcuMTI1IDguNTI5LDUuNTg3IDguNTI5LDMuNzA2IEM4LjUyOSwxLjY1OSA2Ljg3LDAgNC44MjQsMCBDMi43NzcsMCAxLjExOCwxLjY1OSAxLjExOCwzLjcwNiBDMS4xMTgsNS41NzIgMi41MDIsNy4wOTkgNC4yOTQsNy4zNTggTDQuMjk0LDcuNDEyIEMxLjExOCw3LjQxMiAwLjA1OSw5LjUyOSAwLjA1OSw5LjUyOSBMMS4xMTgsMTUuODgyIEMxLjExOCwxNi45MzggMi40NzUsMTcuODA2IDQuMjQ0LDE3Ljk2NyBMNC4yOTQsMTggTDUuMzUzLDE4IEw1LjQwMywxNy45NjcgQzcuMTcyLDE3LjgwNiA4LjUyOSwxNi45MzggOC41MjksMTUuODgyIEw5LjU4OCw5LjUyOSBDOS41ODgsOS41MjkgOC41MjksNy40MTIgNS4zNTMsNy40MTIgeiIgZmlsbD0iIzcxNzE3MSIvPgogICAgPHBhdGggZD0iTTE1Ljk0MSw3LjQxMiBMMTUuODkyLDcuMzYzIEMxNy43MDksNy4xMjUgMTkuMTE4LDUuNTg3IDE5LjExOCwzLjcwNiBDMTkuMTE4LDEuNjU5IDE3LjQ1OCwwIDE1LjQxMiwwIEMxMy4zNjUsMCAxMS43MDYsMS42NTkgMTEuNzA2LDMuNzA2IEMxMS43MDYsNS41NzIgMTMuMDksNy4wOTkgMTQuODgyLDcuMzU4IEwxNC44ODIsNy40MTIgQzExLjcwNiw3LjQxMiAxMC42NDcsOS41MjkgMTAuNjQ3LDkuNTI5IEwxMS43MDYsMTUuODgyIEMxMS43MDYsMTYuOTM4IDEzLjA2MywxNy44MDYgMTQuODMzLDE3Ljk2NyBMMTQuODgyLDE4IEwxNS45NDEsMTggTDE1Ljk5MSwxNy45NjcgQzE3Ljc2LDE3LjgwNiAxOS4xMTgsMTYuOTM4IDE5LjExOCwxNS44ODIgTDIwLjE3Niw5LjUyOSBDMjAuMTc2LDkuNTI5IDE5LjExOCw3LjQxMiAxNS45NDEsNy40MTIgeiIgZmlsbD0iIzcxNzE3MSIvPgogICAgPHBhdGggZD0iTTI2LjUyOSw3LjQxMiBMMjYuNDgxLDcuMzYzIEMyOC4yOTgsNy4xMjUgMjkuNzA2LDUuNTg3IDI5LjcwNiwzLjcwNiBDMjkuNzA2LDEuNjU5IDI4LjA0NywwIDI2LDAgQzIzLjk1MywwIDIyLjI5NCwxLjY1OSAyMi4yOTQsMy43MDYgQzIyLjI5NCw1LjU3MiAyMy42NzgsNy4wOTkgMjUuNDcxLDcuMzU4IEwyNS40NzEsNy40MTIgQzIyLjI5NCw3LjQxMiAyMS4yMzUsOS41MjkgMjEuMjM1LDkuNTI5IEwyMi4yOTQsMTUuODgyIEMyMi4yOTQsMTYuOTM4IDIzLjY1MiwxNy44MDYgMjUuNDIxLDE3Ljk2NyBMMjUuNDcxLDE4IEwyNi41MjksMTggTDI2LjU3OSwxNy45NjcgQzI4LjM0OCwxNy44MDYgMjkuNzA2LDE2LjkzOCAyOS43MDYsMTUuODgyIEwzMC43NjUsOS41MjkgQzMwLjc2NSw5LjUyOSAyOS43MDYsNy40MTIgMjYuNTI5LDcuNDEyIHoiIGZpbGw9IiM3MTcxNzEiLz4KICAgIDxwYXRoIGQ9Ik0zNy4xMTgsNy40MTIgTDM3LjA2OSw3LjM2MyBDMzguODg2LDcuMTI1IDQwLjI5NCw1LjU4NyA0MC4yOTQsMy43MDYgQzQwLjI5NCwxLjY1OSAzOC42MzUsMCAzNi41ODgsMCBDMzQuNTQyLDAgMzIuODgyLDEuNjU5IDMyLjg4MiwzLjcwNiBDMzIuODgyLDUuNTcyIDM0LjI2Niw3LjA5OSAzNi4wNTksNy4zNTggTDM2LjA1OSw3LjQxMiBDMzIuODgyLDcuNDEyIDMxLjgyNCw5LjUyOSAzMS44MjQsOS41MjkgTDMyLjg4MiwxNS44ODIgQzMyLjg4MiwxNi45MzggMzQuMjQsMTcuODA2IDM2LjAwOSwxNy45NjcgTDM2LjA1OSwxOCBMMzcuMTE4LDE4IEwzNy4xNjcsMTcuOTY3IEMzOC45MzcsMTcuODA2IDQwLjI5NCwxNi45MzggNDAuMjk0LDE1Ljg4MiBMNDEuMzUzLDkuNTI5IEM0MS4zNTMsOS41MjkgNDAuMjk0LDcuNDEyIDM3LjExOCw3LjQxMiB6IiBmaWxsPSIjRDZENkQ2Ii8+CiAgICA8cGF0aCBkPSJNNDcuNzA2LDcuNDEyIEw0Ny42NTcsNy4zNjMgQzQ5LjQ3NCw3LjEyNSA1MC44ODIsNS41ODcgNTAuODgyLDMuNzA2IEM1MC44ODIsMS42NTkgNDkuMjIzLDAgNDcuMTc2LDAgQzQ1LjEzLDAgNDMuNDcxLDEuNjU5IDQzLjQ3MSwzLjcwNiBDNDMuNDcxLDUuNTcyIDQ0Ljg1NCw3LjA5OSA0Ni42NDcsNy4zNTggTDQ2LjY0Nyw3LjQxMiBDNDMuNDcxLDcuNDEyIDQyLjQxMiw5LjUyOSA0Mi40MTIsOS41MjkgTDQzLjQ3MSwxNS44ODIgQzQzLjQ3MSwxNi45MzggNDQuODI4LDE3LjgwNiA0Ni41OTcsMTcuOTY3IEw0Ni42NDcsMTggTDQ3LjcwNiwxOCBMNDcuNzU2LDE3Ljk2NyBDNDkuNTI1LDE3LjgwNiA1MC44ODIsMTYuOTM4IDUwLjg4MiwxNS44ODIgTDUxLjk0MSw5LjUyOSBDNTEuOTQxLDkuNTI5IDUwLjg4Miw3LjQxMiA0Ny43MDYsNy40MTIgeiIgZmlsbD0iI0Q2RDZENiIvPgo8L3N2Zz4K");

/***/ }),

/***/ 9023:
/***/ ((__unused_webpack_module, __nested_webpack_exports__, __nested_webpack_require_326132__) => {

"use strict";
__nested_webpack_require_326132__.r(__nested_webpack_exports__);
/* harmony export */ __nested_webpack_require_326132__.d(__nested_webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgdmlld0JveD0iMCAwIDUyIDE4Ij4KICAgIDxwYXRoIGQ9Ik01LjM1Myw3LjQxMiBMNS4zMDQsNy4zNjMgQzcuMTIxLDcuMTI1IDguNTI5LDUuNTg3IDguNTI5LDMuNzA2IEM4LjUyOSwxLjY1OSA2Ljg3LDAgNC44MjQsMCBDMi43NzcsMCAxLjExOCwxLjY1OSAxLjExOCwzLjcwNiBDMS4xMTgsNS41NzIgMi41MDIsNy4wOTkgNC4yOTQsNy4zNTggTDQuMjk0LDcuNDEyIEMxLjExOCw3LjQxMiAwLjA1OSw5LjUyOSAwLjA1OSw5LjUyOSBMMS4xMTgsMTUuODgyIEMxLjExOCwxNi45MzggMi40NzUsMTcuODA2IDQuMjQ0LDE3Ljk2NyBMNC4yOTQsMTggTDUuMzUzLDE4IEw1LjQwMywxNy45NjcgQzcuMTcyLDE3LjgwNiA4LjUyOSwxNi45MzggOC41MjksMTUuODgyIEw5LjU4OCw5LjUyOSBDOS41ODgsOS41MjkgOC41MjksNy40MTIgNS4zNTMsNy40MTIgeiIgZmlsbD0iIzcxNzE3MSIvPgogICAgPHBhdGggZD0iTTE1Ljk0MSw3LjQxMiBMMTUuODkyLDcuMzYzIEMxNy43MDksNy4xMjUgMTkuMTE4LDUuNTg3IDE5LjExOCwzLjcwNiBDMTkuMTE4LDEuNjU5IDE3LjQ1OCwwIDE1LjQxMiwwIEMxMy4zNjUsMCAxMS43MDYsMS42NTkgMTEuNzA2LDMuNzA2IEMxMS43MDYsNS41NzIgMTMuMDksNy4wOTkgMTQuODgyLDcuMzU4IEwxNC44ODIsNy40MTIgQzExLjcwNiw3LjQxMiAxMC42NDcsOS41MjkgMTAuNjQ3LDkuNTI5IEwxMS43MDYsMTUuODgyIEMxMS43MDYsMTYuOTM4IDEzLjA2MywxNy44MDYgMTQuODMzLDE3Ljk2NyBMMTQuODgyLDE4IEwxNS45NDEsMTggTDE1Ljk5MSwxNy45NjcgQzE3Ljc2LDE3LjgwNiAxOS4xMTgsMTYuOTM4IDE5LjExOCwxNS44ODIgTDIwLjE3Niw5LjUyOSBDMjAuMTc2LDkuNTI5IDE5LjExOCw3LjQxMiAxNS45NDEsNy40MTIgeiIgZmlsbD0iIzcxNzE3MSIvPgogICAgPHBhdGggZD0iTTI2LjUyOSw3LjQxMiBMMjYuNDgxLDcuMzYzIEMyOC4yOTgsNy4xMjUgMjkuNzA2LDUuNTg3IDI5LjcwNiwzLjcwNiBDMjkuNzA2LDEuNjU5IDI4LjA0NywwIDI2LDAgQzIzLjk1MywwIDIyLjI5NCwxLjY1OSAyMi4yOTQsMy43MDYgQzIyLjI5NCw1LjU3MiAyMy42NzgsNy4wOTkgMjUuNDcxLDcuMzU4IEwyNS40NzEsNy40MTIgQzIyLjI5NCw3LjQxMiAyMS4yMzUsOS41MjkgMjEuMjM1LDkuNTI5IEwyMi4yOTQsMTUuODgyIEMyMi4yOTQsMTYuOTM4IDIzLjY1MiwxNy44MDYgMjUuNDIxLDE3Ljk2NyBMMjUuNDcxLDE4IEwyNi41MjksMTggTDI2LjU3OSwxNy45NjcgQzI4LjM0OCwxNy44MDYgMjkuNzA2LDE2LjkzOCAyOS43MDYsMTUuODgyIEwzMC43NjUsOS41MjkgQzMwLjc2NSw5LjUyOSAyOS43MDYsNy40MTIgMjYuNTI5LDcuNDEyIHoiIGZpbGw9IiM3MTcxNzEiLz4KICAgIDxwYXRoIGQ9Ik0zNy4xMTgsNy40MTIgTDM3LjA2OSw3LjM2MyBDMzguODg2LDcuMTI1IDQwLjI5NCw1LjU4NyA0MC4yOTQsMy43MDYgQzQwLjI5NCwxLjY1OSAzOC42MzUsMCAzNi41ODgsMCBDMzQuNTQyLDAgMzIuODgyLDEuNjU5IDMyLjg4MiwzLjcwNiBDMzIuODgyLDUuNTcyIDM0LjI2Niw3LjA5OSAzNi4wNTksNy4zNTggTDM2LjA1OSw3LjQxMiBDMzIuODgyLDcuNDEyIDMxLjgyNCw5LjUyOSAzMS44MjQsOS41MjkgTDMyLjg4MiwxNS44ODIgQzMyLjg4MiwxNi45MzggMzQuMjQsMTcuODA2IDM2LjAwOSwxNy45NjcgTDM2LjA1OSwxOCBMMzcuMTE4LDE4IEwzNy4xNjcsMTcuOTY3IEMzOC45MzcsMTcuODA2IDQwLjI5NCwxNi45MzggNDAuMjk0LDE1Ljg4MiBMNDEuMzUzLDkuNTI5IEM0MS4zNTMsOS41MjkgNDAuMjk0LDcuNDEyIDM3LjExOCw3LjQxMiB6IiBmaWxsPSIjNzE3MTcxIi8+CiAgICA8cGF0aCBkPSJNNDcuNzA2LDcuNDEyIEw0Ny42NTcsNy4zNjMgQzQ5LjQ3NCw3LjEyNSA1MC44ODIsNS41ODcgNTAuODgyLDMuNzA2IEM1MC44ODIsMS42NTkgNDkuMjIzLDAgNDcuMTc2LDAgQzQ1LjEzLDAgNDMuNDcxLDEuNjU5IDQzLjQ3MSwzLjcwNiBDNDMuNDcxLDUuNTcyIDQ0Ljg1NCw3LjA5OSA0Ni42NDcsNy4zNTggTDQ2LjY0Nyw3LjQxMiBDNDMuNDcxLDcuNDEyIDQyLjQxMiw5LjUyOSA0Mi40MTIsOS41MjkgTDQzLjQ3MSwxNS44ODIgQzQzLjQ3MSwxNi45MzggNDQuODI4LDE3LjgwNiA0Ni41OTcsMTcuOTY3IEw0Ni42NDcsMTggTDQ3LjcwNiwxOCBMNDcuNzU2LDE3Ljk2NyBDNDkuNTI1LDE3LjgwNiA1MC44ODIsMTYuOTM4IDUwLjg4MiwxNS44ODIgTDUxLjk0MSw5LjUyOSBDNTEuOTQxLDkuNTI5IDUwLjg4Miw3LjQxMiA0Ny43MDYsNy40MTIgeiIgZmlsbD0iI0Q2RDZENiIvPgo8L3N2Zz4K");

/***/ }),

/***/ 6810:
/***/ ((__unused_webpack_module, __nested_webpack_exports__, __nested_webpack_require_329691__) => {

"use strict";
__nested_webpack_require_329691__.r(__nested_webpack_exports__);
/* harmony export */ __nested_webpack_require_329691__.d(__nested_webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgdmlld0JveD0iMCAwIDUyIDE4Ij4KICAgIDxwYXRoIGQ9Ik01LjM1Myw3LjQxMiBMNS4zMDQsNy4zNjMgQzcuMTIxLDcuMTI1IDguNTI5LDUuNTg3IDguNTI5LDMuNzA2IEM4LjUyOSwxLjY1OSA2Ljg3LDAgNC44MjQsMCBDMi43NzcsMCAxLjExOCwxLjY1OSAxLjExOCwzLjcwNiBDMS4xMTgsNS41NzIgMi41MDIsNy4wOTkgNC4yOTQsNy4zNTggTDQuMjk0LDcuNDEyIEMxLjExOCw3LjQxMiAwLjA1OSw5LjUyOSAwLjA1OSw5LjUyOSBMMS4xMTgsMTUuODgyIEMxLjExOCwxNi45MzggMi40NzUsMTcuODA2IDQuMjQ0LDE3Ljk2NyBMNC4yOTQsMTggTDUuMzUzLDE4IEw1LjQwMywxNy45NjcgQzcuMTcyLDE3LjgwNiA4LjUyOSwxNi45MzggOC41MjksMTUuODgyIEw5LjU4OCw5LjUyOSBDOS41ODgsOS41MjkgOC41MjksNy40MTIgNS4zNTMsNy40MTIgeiIgZmlsbD0iIzcxNzE3MSIvPgogICAgPHBhdGggZD0iTTE1Ljk0MSw3LjQxMiBMMTUuODkyLDcuMzYzIEMxNy43MDksNy4xMjUgMTkuMTE4LDUuNTg3IDE5LjExOCwzLjcwNiBDMTkuMTE4LDEuNjU5IDE3LjQ1OCwwIDE1LjQxMiwwIEMxMy4zNjUsMCAxMS43MDYsMS42NTkgMTEuNzA2LDMuNzA2IEMxMS43MDYsNS41NzIgMTMuMDksNy4wOTkgMTQuODgyLDcuMzU4IEwxNC44ODIsNy40MTIgQzExLjcwNiw3LjQxMiAxMC42NDcsOS41MjkgMTAuNjQ3LDkuNTI5IEwxMS43MDYsMTUuODgyIEMxMS43MDYsMTYuOTM4IDEzLjA2MywxNy44MDYgMTQuODMzLDE3Ljk2NyBMMTQuODgyLDE4IEwxNS45NDEsMTggTDE1Ljk5MSwxNy45NjcgQzE3Ljc2LDE3LjgwNiAxOS4xMTgsMTYuOTM4IDE5LjExOCwxNS44ODIgTDIwLjE3Niw5LjUyOSBDMjAuMTc2LDkuNTI5IDE5LjExOCw3LjQxMiAxNS45NDEsNy40MTIgeiIgZmlsbD0iIzcxNzE3MSIvPgogICAgPHBhdGggZD0iTTI2LjUyOSw3LjQxMiBMMjYuNDgxLDcuMzYzIEMyOC4yOTgsNy4xMjUgMjkuNzA2LDUuNTg3IDI5LjcwNiwzLjcwNiBDMjkuNzA2LDEuNjU5IDI4LjA0NywwIDI2LDAgQzIzLjk1MywwIDIyLjI5NCwxLjY1OSAyMi4yOTQsMy43MDYgQzIyLjI5NCw1LjU3MiAyMy42NzgsNy4wOTkgMjUuNDcxLDcuMzU4IEwyNS40NzEsNy40MTIgQzIyLjI5NCw3LjQxMiAyMS4yMzUsOS41MjkgMjEuMjM1LDkuNTI5IEwyMi4yOTQsMTUuODgyIEMyMi4yOTQsMTYuOTM4IDIzLjY1MiwxNy44MDYgMjUuNDIxLDE3Ljk2NyBMMjUuNDcxLDE4IEwyNi41MjksMTggTDI2LjU3OSwxNy45NjcgQzI4LjM0OCwxNy44MDYgMjkuNzA2LDE2LjkzOCAyOS43MDYsMTUuODgyIEwzMC43NjUsOS41MjkgQzMwLjc2NSw5LjUyOSAyOS43MDYsNy40MTIgMjYuNTI5LDcuNDEyIHoiIGZpbGw9IiM3MTcxNzEiLz4KICAgIDxwYXRoIGQ9Ik0zNy4xMTgsNy40MTIgTDM3LjA2OSw3LjM2MyBDMzguODg2LDcuMTI1IDQwLjI5NCw1LjU4NyA0MC4yOTQsMy43MDYgQzQwLjI5NCwxLjY1OSAzOC42MzUsMCAzNi41ODgsMCBDMzQuNTQyLDAgMzIuODgyLDEuNjU5IDMyLjg4MiwzLjcwNiBDMzIuODgyLDUuNTcyIDM0LjI2Niw3LjA5OSAzNi4wNTksNy4zNTggTDM2LjA1OSw3LjQxMiBDMzIuODgyLDcuNDEyIDMxLjgyNCw5LjUyOSAzMS44MjQsOS41MjkgTDMyLjg4MiwxNS44ODIgQzMyLjg4MiwxNi45MzggMzQuMjQsMTcuODA2IDM2LjAwOSwxNy45NjcgTDM2LjA1OSwxOCBMMzcuMTE4LDE4IEwzNy4xNjcsMTcuOTY3IEMzOC45MzcsMTcuODA2IDQwLjI5NCwxNi45MzggNDAuMjk0LDE1Ljg4MiBMNDEuMzUzLDkuNTI5IEM0MS4zNTMsOS41MjkgNDAuMjk0LDcuNDEyIDM3LjExOCw3LjQxMiB6IiBmaWxsPSIjNzE3MTcxIi8+CiAgICA8cGF0aCBkPSJNNDcuNzA2LDcuNDEyIEw0Ny42NTcsNy4zNjMgQzQ5LjQ3NCw3LjEyNSA1MC44ODIsNS41ODcgNTAuODgyLDMuNzA2IEM1MC44ODIsMS42NTkgNDkuMjIzLDAgNDcuMTc2LDAgQzQ1LjEzLDAgNDMuNDcxLDEuNjU5IDQzLjQ3MSwzLjcwNiBDNDMuNDcxLDUuNTcyIDQ0Ljg1NCw3LjA5OSA0Ni42NDcsNy4zNTggTDQ2LjY0Nyw3LjQxMiBDNDMuNDcxLDcuNDEyIDQyLjQxMiw5LjUyOSA0Mi40MTIsOS41MjkgTDQzLjQ3MSwxNS44ODIgQzQzLjQ3MSwxNi45MzggNDQuODI4LDE3LjgwNiA0Ni41OTcsMTcuOTY3IEw0Ni42NDcsMTggTDQ3LjcwNiwxOCBMNDcuNzU2LDE3Ljk2NyBDNDkuNTI1LDE3LjgwNiA1MC44ODIsMTYuOTM4IDUwLjg4MiwxNS44ODIgTDUxLjk0MSw5LjUyOSBDNTEuOTQxLDkuNTI5IDUwLjg4Miw3LjQxMiA0Ny43MDYsNy40MTIgeiIgZmlsbD0iIzcxNzE3MSIvPgo8L3N2Zz4K");

/***/ }),

/***/ 2307:
/***/ ((__unused_webpack_module, __nested_webpack_exports__, __nested_webpack_require_333250__) => {

"use strict";
__nested_webpack_require_333250__.r(__nested_webpack_exports__);
/* harmony export */ __nested_webpack_require_333250__.d(__nested_webpack_exports__, {
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgdmlld0JveD0iMCAwIDM4IDE1Ij4KICAgIDxwYXRoIGQ9Ik0yMS45MSwxLjA4MyBDMTguMDA4LDEuMDgzIDE0Ljg0Niw0LjA3IDE0Ljg0Niw3Ljc1OCBDMTQuODQ2LDExLjQ0NSAxOC4wMDgsMTQuNDMyIDIxLjkxLDE0LjQzMiBDMjUuODEzLDE0LjQzMiAyOC45NzcsMTEuNDQ1IDI4Ljk3Nyw3Ljc1OCBDMjguOTc4LDQuMDcgMjUuODEzLDEuMDgzIDIxLjkxLDEuMDgzIHogTTIxLjc3MSwxMS45IEMxOS41LDExLjkgMTcuNjU3LDEwLjA1NiAxNy42NTcsNy43ODMgQzE3LjY1Nyw1LjUwOCAxOS41MDEsMy42NjQgMjEuNzcxLDMuNjY0IEMyNC4wNDUsMy42NjQgMjUuODg2LDUuNTA4IDI1Ljg4Niw3Ljc4MyBDMjUuODg2LDEwLjA1NyAyNC4wNDUsMTEuOSAyMS43NzEsMTEuOSB6IiBmaWxsPSIjNzRCMDNFIi8+CiAgICA8cGF0aCBkPSJNMTYuNzUxLDAuNjQyIEwxNy4wMzEsMCBMMTQuMDYzLDAgTDExLjI3LDggTDguNjQ4LDAgTDguMjcyLDAgTDUuNjUsOCBMMywwIEwwLjAzMSwwIEw0LjksMTMuNDg2IEM0LjksMTMuNDg2IDUuMDc4LDEzLjg2IDUuMjc1LDEzLjg2IEM1LjQ1MSwxMy44NiA1LjY0OSwxMy40ODYgNS42NDksMTMuNDg2IEw4LjQ0NSw2LjQwNiBMMTEuMjY5LDEzLjQ4NiBDMTEuMjY5LDEzLjQ4NiAxMS40NTUsMTMuODYgMTEuNjQzLDEzLjg2IEMxMS44MjksMTMuODYgMTIuMDE4LDEzLjQ4NiAxMi4wMTgsMTMuNDg2IEwxMy42MTQsOS4wNjcgQzEzLjQ0NSw4LjQzMyAxMy4zNDUsNy43NzMgMTMuMzQ1LDcuMDg5IEMxMy4zNDYsNC40NTMgMTQuNjg2LDIuMTE4IDE2Ljc1MSwwLjY0MiB6IiBmaWxsPSIjRUUzNDI4Ii8+CiAgICA8cGF0aCBkPSJNMjcuMDMxLDAgTDI3LjAzMSwwLjYxMyBDMjcuOTQ0LDEuMjU4IDI4LjcxNSwyLjA2NyAyOS4yOTUsMyBMMzEuMDMxLDMgTDMxLjAzMSwxNCBMMzQuMDMxLDE0IEwzNC4wMzEsMyBMMzguMDMxLDMgTDM4LjAzMSwwIEwyNy4wMzEsMCB6IiBmaWxsPSIjRjA4NjE1Ii8+Cjwvc3ZnPgo=");

/***/ }),

/***/ 897:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('[{"project_id":"adguard-assistant","base_locale":"en","languages":{"en":"English","ar":"Arabic","be":"Belarusian","cs":"Czech","da":"Danish","de":"German","el":"Greek","es":"Spanish","fa":"Persian","fi":"Finnish","fr":"French","he":"Hebrew","hu":"Hungarian","id":"Indonesian","it":"Italian","ja":"Japanese","ko":"Korean","lt":"Lithuanian","no":"Norwegian","nl":"Dutch","pl":"Polish","pt-BR":"Portuguese (Brazil)","pt-PT":"Portuguese","ro":"Romanian","ru":"Russian","sk":"Slovak","sl":"Slovenian","sr":"Serbian (latin)","sv":"Swedish","tr":"Turkish","uk":"Ukrainian","vi":"Vietnamese","zh-CN":"Chinese Simplified (mainland China)","zh-HK":"Chinese Traditional (Hong Kong)","zh-TW":"Chinese Traditional (Taiwan)","hi":"Hindi","hr":"Croatian"},"localizable_files":["locales/en/messages.json","locales/en/messages.meta.json"]}]');

/***/ }),

/***/ 5443:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"مواقع الويب","settings_position_save_all":"كافة مواقع الويب","settings_position_save_this":"هذا الموقع","assistant_select_element_start":"بدء","assistant_select_element_text":"اختر عنصرا في الصفحة للحظرقم بتحديث الصفحة لالغاء وضع حظر العنصر","menu_filtration_status":{"message":"تفعيل الفلترةعلى هذا الموقع"},"menu_do_not_filter_30_sec":{"message":"عدم الفلترة لمده 30 ثانيه"},"menu_block_ad_on_site":{"message":"منع الإعلان على هذا الموقع"},"menu_report_abuse":{"message":"الإبلاغ عن هذا الموقع"},"menu_site_report":{"message":"تقرير أمن الموقع"},"menu_settings":{"message":"إعدادات المساعد"},"menu_wot_reputation_indicator":{"message":"مؤشر سمعة الموقع"},"menu_wot_reputation_confidence_level":{"message":"مستوى الثقة في السمعة"},"assistant_select_element":{"message":"حظر العنصر"},"assistant_select_element_ext":{"message":"اختر عنصرا في الصفحة للحظر"},"assistant_select_element_cancel":{"message":"الغاء"},"assistant_block_element":{"message":"حظر العنصر"},"assistant_block_element_explain":{"message":"ضبط قاعدة حظر العنصر"},"assistant_slider_explain":{"message":"حرك شريط التمرير لتغيير حجم الإطار الذي ستعمل عليه القاعدة الجديدة:"},"assistant_extended_settings":{"message":"إعدادات متقدمة"},"assistant_apply_rule_to_all_sites":{"message":"تطبيق القاعدة علي كافة مواقع الويب"},"assistant_block_by_reference":{"message":"حظر حسب الارتباط المرجعي"},"assistant_block_similar":{"message":"حظر عنصر مما ثل"},"assistant_another_element":{"message":"حدد عنصرًا مختلفًا"},"assistant_preview":{"message":"المعاينه"},"assistant_block":{"message":"حظر"},"assistant_settings":{"message":"إعدادات المساعد"},"assistant_preview_header":{"message":"حجب عنصر--معاينه"},"assistant_preview_header_info":{"message":"تاكد من حظر هذا العنصر كما هو مقصود"},"assistant_preview_end":{"message":"إنهاء المعاينة"},"wot_unknown_description":{"message":"$1 لم يتم تعريف سمعه هذا الموقع من قبل"},"wot_bad_description":{"message":"$1هذا الموقع لديه سمعة سيئة للغاية \\nوفقاً لـ"},"wot_poor_description":{"message":"$1 هذا الموقع له سمعة سيئة \\nوفقا لـ"},"wot_unsatisfactory_description":{"message":"$1هذا الموقع له سمعة سيئة\\nوفقا لـ"},"wot_good_description":{"message":"$1يتمتع هذا الموقع بسمعة طيبة\\nوفقا لـ"},"wot_excellent_description":{"message":"هذا الموقع يتمتع بسمعة ممتازة\\nوفقاً لـ $1"},"settings_choose_size_and_position":{"message":"وموضعه AdGuard ضبط حجم مساعد"},"settings_icon_size":{"message":":حجم الرمز"},"settings_small":{"message":"صغير"},"settings_big":{"message":"كبير"},"settings_position":{"message":"وضع"},"settings_left_top":{"message":"اعلي اليسار"},"settings_right_top":{"message":"اعلي اليمين"},"settings_left_bottom":{"message":"أسفل لليسار"},"settings_right_bottom":{"message":"أسفل لليمين"},"settings_cancel":{"message":"الغاء"},"settings_save":{"message":"حفظ التغييرات"}}');

/***/ }),

/***/ 24:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"Сайты","settings_position_save_all":"На ўсіх","settings_position_save_this":"Толькі на гэтым","assistant_select_element_start":"Пачаць","assistant_select_element_text":"Абярыце на старонцы элемент для блакавання. Абнавіце старонку, каб скасаваць рэжым блакавання элементаў.","menu_filtration_status":{"message":"Фільтрацыя на гэтым сайце"},"menu_do_not_filter_30_sec":{"message":"Не фільтраваць 30 секундаў"},"menu_block_ad_on_site":{"message":"Заблакаваць рэкламу на сайце"},"menu_report_abuse":{"message":"Паскардзіцца на сайт"},"menu_site_report":{"message":"Справаздача пра бяспеку сайта"},"menu_settings":{"message":"Наладзіць памочнік"},"menu_wot_reputation_indicator":{"message":"Індыкатар рэпутацыі сайта"},"menu_wot_reputation_confidence_level":{"message":"Узровень верагоднасці рэпутацыі"},"assistant_select_element":{"message":"Блакаванне элемента"},"assistant_select_element_ext":{"message":"Абярыце на старонцы элемент, які трэба заблакаваць"},"assistant_select_element_cancel":{"message":"Скасаванне"},"assistant_block_element":{"message":"Блакаванне элемента"},"assistant_block_element_explain":{"message":"Наладзьце правіла блакавання элемента"},"assistant_slider_explain":{"message":"Перасоўвайце бегунок, каб змяніць памер блока, для якога будзе дзейнічаць правіла:"},"assistant_extended_settings":{"message":"Пашыраныя налады"},"assistant_apply_rule_to_all_sites":{"message":"Ужыць правіла для ўсіх сайтаў"},"assistant_block_by_reference":{"message":"Блакаваць па спасылцы"},"assistant_block_similar":{"message":"Блакаваць падобныя"},"assistant_another_element":{"message":"Абраць іншы элемент"},"assistant_preview":{"message":"Перадпрагляд"},"assistant_block":{"message":"Заблакаваць"},"assistant_settings":{"message":"Налада памочніка"},"assistant_preview_header":{"message":"Блакаванне элемента - перадпрагляд"},"assistant_preview_header_info":{"message":"Пераканаецеся, што элемент заблакаваны як задумана"},"assistant_preview_end":{"message":"Скончыць перадпрагляд"},"wot_unknown_description":{"message":"Рэпутацыя не вызначана"},"wot_bad_description":{"message":"У сайта вельмі дрэнная рэпутацыя па дадзеных $1"},"wot_poor_description":{"message":"У сайта дрэнная рэпутацыя па дадзеных $1"},"wot_unsatisfactory_description":{"message":"У сайта нездавальняльная рэпутацыя па дадзеных $1"},"wot_good_description":{"message":"У сайта добрая рэпутацыя па дадзеных $1"},"wot_excellent_description":{"message":"У сайта выдатная рэпутацыя па дадзеных $1"},"settings_choose_size_and_position":{"message":"Наладзьце памер і становішча памочніка AdGuard"},"settings_icon_size":{"message":"Памер іконкі:"},"settings_small":{"message":"Маленькая"},"settings_big":{"message":"Вялікая"},"settings_position":{"message":"Месцаванне:"},"settings_left_top":{"message":"Уверсе злева"},"settings_right_top":{"message":"Уверсе справа"},"settings_left_bottom":{"message":"Унізе злева"},"settings_right_bottom":{"message":"Унізе справа"},"settings_cancel":{"message":"Скасаваць"},"settings_save":{"message":"Захаваць налады"}}');

/***/ }),

/***/ 3337:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"Webové stránky","settings_position_save_all":"Všechny webové stránky","settings_position_save_this":"Tato webová stránka","assistant_select_element_start":"Spustit","assistant_select_element_text":"Vyberte prvek na stránce, který chcete zablokovat. Obnovte stránku pro zrušení režimu blokování prvků.","menu_filtration_status":{"message":"Filtrování na těchto webových stránkách"},"menu_do_not_filter_30_sec":{"message":"Nefiltrovat po dobu 30 sekund"},"menu_block_ad_on_site":{"message":"Blokovat reklamy na této webové stránce"},"menu_report_abuse":{"message":"Nahlásit webovou stránku"},"menu_site_report":{"message":"Zpráva o bezpečnosti webové stránky"},"menu_settings":{"message":"Nastavení asistenta"},"menu_wot_reputation_indicator":{"message":"Indikátor reputace webu"},"menu_wot_reputation_confidence_level":{"message":"Úroveň důvěryhodnosti reputace"},"assistant_select_element":{"message":"Blokování prvku"},"assistant_select_element_ext":{"message":"Vyberte prvek na stránce, který chcete zablokovat"},"assistant_select_element_cancel":{"message":"Zrušit"},"assistant_block_element":{"message":"Blokování prvku"},"assistant_block_element_explain":{"message":"Upravit pravidlo blokování prvku"},"assistant_slider_explain":{"message":"Přesunutím posuvníku změňte velikost rámce, pro který bude nové pravidlo fungovat:"},"assistant_extended_settings":{"message":"Pokročilá nastavení"},"assistant_apply_rule_to_all_sites":{"message":"Použít pravidlo pro všechny webové stránky"},"assistant_block_by_reference":{"message":"Blokovat referenčním odkazem"},"assistant_block_similar":{"message":"Blokovat podobné"},"assistant_another_element":{"message":"Vyber jiný prvek"},"assistant_preview":{"message":"Náhled"},"assistant_block":{"message":"Blokovat"},"assistant_settings":{"message":"Nastavení asistenta"},"assistant_preview_header":{"message":"Blokování prvku - náhled"},"assistant_preview_header_info":{"message":"Ujistěte se, že je prvek zablokován podle určení"},"assistant_preview_end":{"message":"Ukončit náhled"},"wot_unknown_description":{"message":"Pověst této webové stránky není definována podle $1"},"wot_bad_description":{"message":"Tato webová stránka má velmi špatnou pověst \\npodle $1"},"wot_poor_description":{"message":"Tato webová stránka má špatnou pověst \\npodle $1"},"wot_unsatisfactory_description":{"message":"Tato webová stránka má špatnou pověst \\npodle $1"},"wot_good_description":{"message":"Tato webová stránka má dobrou pověst \\npodle $1"},"wot_excellent_description":{"message":"Tato webová stránka má výbornou pověst \\npodle $1"},"settings_choose_size_and_position":{"message":"Upravit velikost a pozici AdGuard Asistenta"},"settings_icon_size":{"message":"Velikost ikony:"},"settings_small":{"message":"Malá"},"settings_big":{"message":"Velká"},"settings_position":{"message":"Pozice:"},"settings_left_top":{"message":"Vlevo nahoře"},"settings_right_top":{"message":"Vpravo nahoře"},"settings_left_bottom":{"message":"Vlevo dole"},"settings_right_bottom":{"message":"Vpravo dole"},"settings_cancel":{"message":"Zrušit"},"settings_save":{"message":"Uložit změny"}}');

/***/ }),

/***/ 7691:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"Websteder","settings_position_save_all":"Alle websteder","settings_position_save_this":"Dette websted","assistant_select_element_start":"Start","assistant_select_element_text":"Vælg et element på denne side, der skal blokeres. Opfrisk siden for at afbryde elementblokeringstilstanden.","menu_filtration_status":{"message":"Filtrering på dette websted"},"menu_do_not_filter_30_sec":{"message":"Filtrér ikke i 30 sekunder"},"menu_block_ad_on_site":{"message":"Blokér annoncer på dette websted"},"menu_report_abuse":{"message":"Anmeld dette websted"},"menu_site_report":{"message":"Webstedssikkerhedsrapport"},"menu_settings":{"message":"Assistent-indstillinger"},"menu_wot_reputation_indicator":{"message":"Webstedsomdømmeindikator"},"menu_wot_reputation_confidence_level":{"message":"Omdømmetillidsniveau"},"assistant_select_element":{"message":"Elementblokering"},"assistant_select_element_ext":{"message":"Vælg et element på siden, der skal blokeres"},"assistant_select_element_cancel":{"message":"Afbryd"},"assistant_block_element":{"message":"Elementblokering"},"assistant_block_element_explain":{"message":"Justér regel for elementblokering"},"assistant_slider_explain":{"message":"Flyt skyderen for at ændre størrelsen på den ramme, den nye regel vil fungere for:"},"assistant_extended_settings":{"message":"Avancerede indstillinger"},"assistant_apply_rule_to_all_sites":{"message":"Anvend reglen på alle websteder"},"assistant_block_by_reference":{"message":"Blokér efter referencelink"},"assistant_block_similar":{"message":"Blokér lignende"},"assistant_another_element":{"message":"Vælg et andet element"},"assistant_preview":{"message":"Forhåndsvisning"},"assistant_block":{"message":"Blokér"},"assistant_settings":{"message":"Assistent-indstillinger"},"assistant_preview_header":{"message":"Elementblokering - forhåndsvisning"},"assistant_preview_header_info":{"message":"Sørg for, at elementet er blokeret som tilsigtet"},"assistant_preview_end":{"message":"Afslut forhåndsvisning"},"wot_unknown_description":{"message":"Dette websteds omdømme er ikke defineret af $1"},"wot_bad_description":{"message":"Dette websted har et meget dårligt omdømme jf. $1"},"wot_poor_description":{"message":"Dette websted har et dårligt omdømme jf. $1"},"wot_unsatisfactory_description":{"message":"Dette websted har et ringe omdømme jf. $1"},"wot_good_description":{"message":"Dette websted har et godt omdømme jf. $1"},"wot_excellent_description":{"message":"Dette websted har et fremragende omdømme \\njf. $1"},"settings_choose_size_and_position":{"message":"Justér størrelse og position for AdGuard Assistent"},"settings_icon_size":{"message":"Ikonstørrelse:"},"settings_small":{"message":"Lille"},"settings_big":{"message":"Stor"},"settings_position":{"message":"Position:"},"settings_left_top":{"message":"Øverst til venstre"},"settings_right_top":{"message":"Øverst til højre"},"settings_left_bottom":{"message":"Nederst til venstre"},"settings_right_bottom":{"message":"Nederst til højre"},"settings_cancel":{"message":"Afbryd"},"settings_save":{"message":"Gem ændringer"}}');

/***/ }),

/***/ 9947:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"Webseiten","settings_position_save_all":"Alle Webseiten","settings_position_save_this":"Diese Webseite","assistant_select_element_start":"Starten","assistant_select_element_text":"Wählen Sie ein zu sperrenden Element auf der Seite aus. Laden Sie die Seite neu, um den Sperrmodus zu verlassen.","menu_filtration_status":{"message":"Diese Webseite filtern"},"menu_do_not_filter_30_sec":{"message":"Schutz für 30 Sekunden deaktivieren"},"menu_block_ad_on_site":{"message":"Werbung auf dieser Seite sperren"},"menu_report_abuse":{"message":"Diese Webseite melden"},"menu_site_report":{"message":"Sicherheitsbericht dieser Webseite"},"menu_settings":{"message":"Assistent-Einstellungen"},"menu_wot_reputation_indicator":{"message":"Website-Reputations-Indikator"},"menu_wot_reputation_confidence_level":{"message":"Reputationsvertrauensgrad"},"assistant_select_element":{"message":"Element sperren"},"assistant_select_element_ext":{"message":"Zu sperrendes Element auf der Seite auswählen"},"assistant_select_element_cancel":{"message":"Abbrechen"},"assistant_block_element":{"message":"Element sperren"},"assistant_block_element_explain":{"message":"Regel zum Sperren von Elementen anpassen"},"assistant_slider_explain":{"message":"Bewegen Sie den Schieberegler, um die Ausmaßgröße der neuen Regeln zu ändern:"},"assistant_extended_settings":{"message":"Erweiterte Einstellungen"},"assistant_apply_rule_to_all_sites":{"message":"Regel auf alle Webseiten anwenden"},"assistant_block_by_reference":{"message":"Durch Referenzlink sperren"},"assistant_block_similar":{"message":"Ähnliche Elemente sperren"},"assistant_another_element":{"message":"Ein anderes Element wählen"},"assistant_preview":{"message":"Vorschau"},"assistant_block":{"message":"Sperren"},"assistant_settings":{"message":"Assistent-Einstellungen"},"assistant_preview_header":{"message":"Vorschau der zu sperrenden Elemente"},"assistant_preview_header_info":{"message":"Prüfen Sie, ob das Element wie vorgesehen gesperrt wurde."},"assistant_preview_end":{"message":"Vorschau beenden"},"wot_unknown_description":{"message":"Der Ruf dieser Webseite wird nicht durch $1 festgelegt"},"wot_bad_description":{"message":"Diese Webseite hat einen sehr schlechten Ruf laut $1"},"wot_poor_description":{"message":"Diese Webseite hat einen schlechten Ruf laut $1"},"wot_unsatisfactory_description":{"message":"Diese Webseite hat einen schlechten Ruf laut $1"},"wot_good_description":{"message":"Diese Webseite hat einen guten Ruf laut $1"},"wot_excellent_description":{"message":"Diese Webseite hat einen exzellenten Ruf laut $1"},"settings_choose_size_and_position":{"message":"Anpassen der Größe und Position des AdGuard-Assistent"},"settings_icon_size":{"message":"Symbol-Größe:"},"settings_small":{"message":"Klein"},"settings_big":{"message":"Groß"},"settings_position":{"message":"Position:"},"settings_left_top":{"message":"Oben links"},"settings_right_top":{"message":"Oben rechts"},"settings_left_bottom":{"message":"Unten links"},"settings_right_bottom":{"message":"Unten rechts"},"settings_cancel":{"message":"Abbrechen"},"settings_save":{"message":"Änderungen speichern"}}');

/***/ }),

/***/ 1773:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"Ιστοσελίδες","settings_position_save_all":"Όλοι οι ιστότοποι","settings_position_save_this":"Αυτός ο ιστότοπος","assistant_select_element_start":"Εκκίνηση","assistant_select_element_text":"Επιλέξτε ένα στοιχείο στη σελίδα για αποκλεισμό. Ανανεώστε τη σελίδα για να ακυρώσετε τη λειτουργία αποκλεισμού στοιχείων.","menu_filtration_status":{"message":"Φιλτράρισμα σε αυτόν τον ιστότοπο"},"menu_do_not_filter_30_sec":{"message":"Παύση φιλτραρίσματος για 30 δευτερόλεπτα"},"menu_block_ad_on_site":{"message":"Αποκλεισμός διαφήμισης σε αυτόν τον ιστότοπο"},"menu_report_abuse":{"message":"Αναφέρετε αυτόν τον ιστότοπο"},"menu_site_report":{"message":"Αναφορά ασφάλειας ιστότοπου"},"menu_settings":{"message":"Ρυθμίσεις βοηθού"},"menu_wot_reputation_indicator":{"message":"Δείκτης φήμης ιστότοπου"},"menu_wot_reputation_confidence_level":{"message":"Επίπεδο εμπιστοσύνης φήμης"},"assistant_select_element":{"message":"Αποκλεισμός στοιχείου"},"assistant_select_element_ext":{"message":"Επιλέξτε ένα στοιχείο στη σελίδα για αποκλεισμό"},"assistant_select_element_cancel":{"message":"Άκυρο"},"assistant_block_element":{"message":"Αποκλεισμός στοιχείου"},"assistant_block_element_explain":{"message":"Προσαρμόστε τον κανόνα αποκλεισμού στοιχείου"},"assistant_slider_explain":{"message":"Μετακινήστε το ρυθμιστικό για να αλλάξετε το μέγεθος του πλαισίου για τον οποίο θα λειτουργεί ο νέος κανόνας:"},"assistant_extended_settings":{"message":"Προηγμένες ρυθμίσεις"},"assistant_apply_rule_to_all_sites":{"message":"Εφαρμογή του κανόνα σε όλες τις ιστοσελίδες"},"assistant_block_by_reference":{"message":"Αποκλεισμός μέσω συνδέσμου αναφοράς"},"assistant_block_similar":{"message":"Αποκλεισμός παρόμοιου"},"assistant_another_element":{"message":"Επιλέξτε ένα διαφορετικό στοιχείο"},"assistant_preview":{"message":"Προεπισκόπηση"},"assistant_block":{"message":"Αποκλεισμός"},"assistant_settings":{"message":"Ρυθμίσεις βοηθού"},"assistant_preview_header":{"message":"Αποκλεισμός στοιχείου - προεπισκόπηση"},"assistant_preview_header_info":{"message":"Βεβαιωθείτε ότι το στοιχείο είναι μπλοκαρισμένο όπως προορίζεται"},"assistant_preview_end":{"message":"Έξοδος προεπισκόπησης"},"wot_unknown_description":{"message":"Η φήμη αυτού του ιστότοπου δεν έχει καθοριστεί από το $1"},"wot_bad_description":{"message":"Αυτός ο ιστότοπος έχει πολύ κακή φήμη\\nσύμφωνα με το $1"},"wot_poor_description":{"message":"Αυτός ο ιστότοπος έχει κακή φήμη\\nσύμφωνα με το $1"},"wot_unsatisfactory_description":{"message":"Αυτός ο ιστότοπος έχει κακή φήμη\\nσύμφωνα με το $1"},"wot_good_description":{"message":"Αυτός ο ιστότοπος έχει καλή φήμη\\nσύμφωνα με το $1"},"wot_excellent_description":{"message":"Αυτός ο ιστότοπος έχει εξαιρετική φήμη\\nσύμφωνα με το $1"},"settings_choose_size_and_position":{"message":"Προσαρμόστε το μέγεθος και τη θέση του Βοηθού AdGuard"},"settings_icon_size":{"message":"Μέγεθος εικονιδίου:"},"settings_small":{"message":"Μικρό"},"settings_big":{"message":"Μεγάλο"},"settings_position":{"message":"Θέση:"},"settings_left_top":{"message":"Πάνω αριστερά"},"settings_right_top":{"message":"Πάνω δεξιά"},"settings_left_bottom":{"message":"Κάτω αριστερά"},"settings_right_bottom":{"message":"Κάτω δεξιά"},"settings_cancel":{"message":"Άκυρο"},"settings_save":{"message":"Αποθήκευση αλλαγών"}}');

/***/ }),

/***/ 1272:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"Websites","settings_position_save_all":"All websites","settings_position_save_this":"This website","assistant_select_element_start":"Start","assistant_select_element_text":"Choose an element on the page to block. Refresh the page to cancel the element blocking mode.","menu_filtration_status":{"message":"Filtering on this website"},"menu_do_not_filter_30_sec":{"message":"Do not filter for 30 seconds"},"menu_block_ad_on_site":{"message":"Block ad on this website"},"menu_report_abuse":{"message":"Report the website"},"menu_site_report":{"message":"Website security report"},"menu_settings":{"message":"Assistant settings"},"menu_wot_reputation_indicator":{"message":"Site reputation indicator"},"menu_wot_reputation_confidence_level":{"message":"Reputation Confidence Level"},"assistant_select_element":{"message":"Element blocking"},"assistant_select_element_ext":{"message":"Choose an element on the page to block"},"assistant_select_element_cancel":{"message":"Cancel"},"assistant_block_element":{"message":"Element blocking"},"assistant_block_element_explain":{"message":"Adjust element blocking rule"},"assistant_slider_explain":{"message":"Move the slider to change the size of the frame the new rule will work for:"},"assistant_extended_settings":{"message":"Advanced settings"},"assistant_apply_rule_to_all_sites":{"message":"Apply the rule to all websites"},"assistant_block_by_reference":{"message":"Block by reference link"},"assistant_block_similar":{"message":"Block similar"},"assistant_another_element":{"message":"Select a different element"},"assistant_preview":{"message":"Preview"},"assistant_block":{"message":"Block"},"assistant_settings":{"message":"Assistant settings"},"assistant_preview_header":{"message":"Element blocking - preview"},"assistant_preview_header_info":{"message":"Make sure that element is blocked as intended"},"assistant_preview_end":{"message":"Exit preview"},"wot_unknown_description":{"message":"This website\'s reputation is not defined by $1"},"wot_bad_description":{"message":"This website has a very bad reputation\\naccording to $1"},"wot_poor_description":{"message":"This website has a bad reputation \\naccording to $1"},"wot_unsatisfactory_description":{"message":"This website has a poor reputation\\naccording to $1"},"wot_good_description":{"message":"This website has a good reputation\\naccording to $1"},"wot_excellent_description":{"message":"This website has an excellent reputation\\naccording to $1"},"settings_choose_size_and_position":{"message":"Adjust AdGuard Assistant size and position"},"settings_icon_size":{"message":"Icon size:"},"settings_small":{"message":"Small"},"settings_big":{"message":"Large"},"settings_position":{"message":"Position:"},"settings_left_top":{"message":"Top left"},"settings_right_top":{"message":"Top right"},"settings_left_bottom":{"message":"Bottom left"},"settings_right_bottom":{"message":"Bottom right"},"settings_cancel":{"message":"Cancel"},"settings_save":{"message":"Save changes"}}');

/***/ }),

/***/ 8194:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"Sitios web","settings_position_save_all":"Todos los sitios web","settings_position_save_this":"Este sitio web","assistant_select_element_start":"Comenzar","assistant_select_element_text":"Elige un elemento en la página para bloquear. Actualiza la página para cancelar el bloqueo de elementos.","menu_filtration_status":{"message":"Filtrado en este sitio web"},"menu_do_not_filter_30_sec":{"message":"No filtrar durante 30 segundos"},"menu_block_ad_on_site":{"message":"Bloquear anuncios en este sitio web"},"menu_report_abuse":{"message":"Reportar el sitio web"},"menu_site_report":{"message":"Informe de seguridad del sitio web"},"menu_settings":{"message":"Configuración del asistente"},"menu_wot_reputation_indicator":{"message":"Indicador de reputación del sitio"},"menu_wot_reputation_confidence_level":{"message":"Nivel de confianza de reputación"},"assistant_select_element":{"message":"Bloqueo de elementos"},"assistant_select_element_ext":{"message":"Elige un elemento en la página para bloquear"},"assistant_select_element_cancel":{"message":"Cancelar"},"assistant_block_element":{"message":"Bloqueo de elementos"},"assistant_block_element_explain":{"message":"Ajustar la regla de bloqueo del elemento"},"assistant_slider_explain":{"message":"Mueve el control deslizante para cambiar el tamaño del marco para el que funcionará la nueva regla:"},"assistant_extended_settings":{"message":"Configuración avanzada"},"assistant_apply_rule_to_all_sites":{"message":"Aplicar la regla a todos los sitios web"},"assistant_block_by_reference":{"message":"Bloquear por enlace de referencia"},"assistant_block_similar":{"message":"Bloquear elemento similar"},"assistant_another_element":{"message":"Seleccionar otro elemento"},"assistant_preview":{"message":"Vista previa"},"assistant_block":{"message":"Bloquear"},"assistant_settings":{"message":"Configuración del asistente"},"assistant_preview_header":{"message":"Bloqueo de elementos - vista previa"},"assistant_preview_header_info":{"message":"Asegúrate de que el elemento esté bloqueado como se deseaba"},"assistant_preview_end":{"message":"Salir de vista previa"},"wot_unknown_description":{"message":"La reputación de este sitio web no está definida por $1"},"wot_bad_description":{"message":"Este sitio web tiene muy mala reputación\\nde acuerdo a $1"},"wot_poor_description":{"message":"Este sitio web tiene mala reputación\\nde acuerdo a $1"},"wot_unsatisfactory_description":{"message":"Este sitio web tiene pobre reputación\\nde acuerdo a $1"},"wot_good_description":{"message":"Este sitio web tiene buena reputación\\nde acuerdo a $1"},"wot_excellent_description":{"message":"Este sitio web tiene excelente reputación\\nde acuerdo a $1"},"settings_choose_size_and_position":{"message":"Ajustar el tamaño y la posición del Asistente de AdGuard"},"settings_icon_size":{"message":"Tamaño del icono:"},"settings_small":{"message":"Pequeño"},"settings_big":{"message":"Grande"},"settings_position":{"message":"Posición:"},"settings_left_top":{"message":"Arriba a la izquierda"},"settings_right_top":{"message":"Arriba a la derecha"},"settings_left_bottom":{"message":"Abajo a la izquierda"},"settings_right_bottom":{"message":"Abajo a la derecha"},"settings_cancel":{"message":"Cancelar"},"settings_save":{"message":"Guardar cambios"}}');

/***/ }),

/***/ 5455:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"وبسایت","settings_position_save_all":"همه وبسایت ها","settings_position_save_this":"این وبسایت","assistant_select_element_start":"شروع","assistant_select_element_text":"عنصری در صفحه برای مسدودسازی انتخاب کنید. برای لغو،صفحه را رفرش کنید.","menu_filtration_status":{"message":"فیلترینگ در این وبسایت"},"menu_do_not_filter_30_sec":{"message":"به مدت 30 ثانیه فیلتر نکن"},"menu_block_ad_on_site":{"message":"مسدودسازی تبلیغ در این وبسایت"},"menu_report_abuse":{"message":"گزارش وبسایت"},"menu_site_report":{"message":"گزارش امنیتی وبسایت"},"menu_settings":{"message":"تنظیمات دستیار"},"menu_wot_reputation_indicator":{"message":"نشانگر اعتبار سایت"},"menu_wot_reputation_confidence_level":{"message":"سطح اعتبار"},"assistant_select_element":{"message":"مسدودسازی عنصر"},"assistant_select_element_ext":{"message":"عنصری در صفحه برای مسدودسازی انتخاب کنید"},"assistant_select_element_cancel":{"message":"لغو"},"assistant_block_element":{"message":"مسدودسازی عنصر"},"assistant_block_element_explain":{"message":"تنظیم دستور مسدودسازی عنصر"},"assistant_slider_explain":{"message":"جابجایی لغزنده برای تغییر اندازه فریم که دستور جدیدی کار خواهد کرد:"},"assistant_extended_settings":{"message":"تنظیمات پیشرفته"},"assistant_apply_rule_to_all_sites":{"message":"اِعمال دستور در همه وبسایت ها"},"assistant_block_by_reference":{"message":"مسدودسازی با لینک مرجع"},"assistant_block_similar":{"message":"مسدودسازی مشابه"},"assistant_another_element":{"message":"عنصر دیگری انتخاب کنید"},"assistant_preview":{"message":"پیشنمایش"},"assistant_block":{"message":"مسدود"},"assistant_settings":{"message":"تنظیمات دستیار"},"assistant_preview_header":{"message":"مسدودسازی عنصر - پیشنمایش"},"assistant_preview_header_info":{"message":"مطمئن شوید عنصر به شکل دلخواه مسدود شود"},"assistant_preview_end":{"message":"خروج از پیشنمایش"},"wot_unknown_description":{"message":"اعتبار تعریف نشده است"},"wot_bad_description":{"message":"این وبسایت اعتبار خیلی بدی دارد\\nبر طبق "},"wot_poor_description":{"message":"این وبسایت اعتبار بدی دارد\\nبر طبق "},"wot_unsatisfactory_description":{"message":"این وبسایت اعتبار کمی دارد\\nبر طبق "},"wot_good_description":{"message":"این وبسایت اعتبار خوبی دارد\\nبر طبق "},"wot_excellent_description":{"message":"این وبسایت اعتبار عالی دارد\\nبر طبق "},"settings_choose_size_and_position":{"message":"تنظیم اندازه و موقعیت دستیار AdGuard"},"settings_icon_size":{"message":"اندازه آیکون:"},"settings_small":{"message":"کوچک"},"settings_big":{"message":"بزرگ"},"settings_position":{"message":"موقعیت:"},"settings_left_top":{"message":"بالا سمت چپ"},"settings_right_top":{"message":"بالا سمت راست"},"settings_left_bottom":{"message":"پایین سمت چپ"},"settings_right_bottom":{"message":"پایین سمت راست"},"settings_cancel":{"message":"لغو"},"settings_save":{"message":"ذخیره تغییرات"}}');

/***/ }),

/***/ 6183:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"Verkkosivustot","settings_position_save_all":"Kaikki sivustot","settings_position_save_this":"Tämä sivusto","assistant_select_element_start":"Aloita","assistant_select_element_text":"Valitse sivulta estettävä elementti. Päivitä sivu poistuaksesi elementtien estotilasta.","menu_filtration_status":{"message":"Tämän sivuston suodatus"},"menu_do_not_filter_30_sec":{"message":"Pysäytä suodatus 30 sekunnin ajaksi"},"menu_block_ad_on_site":{"message":"Estä mainos tältä sivustolta"},"menu_report_abuse":{"message":"Ilmoita ongelmasta"},"menu_site_report":{"message":"Sivuston suojausraportti"},"menu_settings":{"message":"Apurin asetukset"},"menu_wot_reputation_indicator":{"message":"Sivuston maine"},"menu_wot_reputation_confidence_level":{"message":"Mainearvion luotettavuus"},"assistant_select_element":{"message":"Elementin esto"},"assistant_select_element_ext":{"message":"Valitse sivulta estettävä elementti"},"assistant_select_element_cancel":{"message":"Peruuta"},"assistant_block_element":{"message":"Elementin esto"},"assistant_block_element_explain":{"message":"Muokkaa elementinestosääntöä"},"assistant_slider_explain":{"message":"Siirrä liukukytkintä muuttaaksesi sen kehyksen kokoa, johon tämä sääntö vaikuttaa:"},"assistant_extended_settings":{"message":"Edistyneet lisäasetukset"},"assistant_apply_rule_to_all_sites":{"message":"Käytä kaikilla sivustoilla"},"assistant_block_by_reference":{"message":"Estä viitelinkillä"},"assistant_block_similar":{"message":"Estä samankaltaiset"},"assistant_another_element":{"message":"Valitse eri elementti"},"assistant_preview":{"message":"Esikatsele"},"assistant_block":{"message":"Estä"},"assistant_settings":{"message":"Apurin asetukset"},"assistant_preview_header":{"message":"Elementin estosäännön esikatselu"},"assistant_preview_header_info":{"message":"Varmista, että elementti estetään tarkoituksenmukaisesti"},"assistant_preview_end":{"message":"Sulje esikatselu"},"wot_unknown_description":{"message":"$1 ei tarjoa sivustolle mainearviointia"},"wot_bad_description":{"message":"$1 arvioinnin mukaan sivustolla on erittäin huono maine"},"wot_poor_description":{"message":"$1 arvioinnin mukaan sivustolla on huono maine"},"wot_unsatisfactory_description":{"message":"$1 arvioinnin mukaan sivustolla on heikko maine"},"wot_good_description":{"message":"$1 arvioinnin mukaan sivustolla on hyvä maine"},"wot_excellent_description":{"message":"$1 arvioinnin mukaan sivustolla on erinomainen maine"},"settings_choose_size_and_position":{"message":"Säädä AdGuard Avustajan kokoa ja sijaintia"},"settings_icon_size":{"message":"Kuvakkeen koko:"},"settings_small":{"message":"Pieni"},"settings_big":{"message":"Suuri"},"settings_position":{"message":"Sijainti:"},"settings_left_top":{"message":"Ylhäällä vasemmalla"},"settings_right_top":{"message":"Ylhäällä oikealla"},"settings_left_bottom":{"message":"Alhaalla vasemmalla"},"settings_right_bottom":{"message":"Alhaalla oikealla"},"settings_cancel":{"message":"Peruuta"},"settings_save":{"message":"Tallenna muutokset"}}');

/***/ }),

/***/ 4652:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"Sites web","settings_position_save_all":"Tous les sites web","settings_position_save_this":"Ce site web","assistant_select_element_start":"Démarrer","assistant_select_element_text":"Choisissez un élément de la page à bloquer. Pour afficher l\'élément de nouveau, rafraîchissez la page.","menu_filtration_status":{"message":"Filtrages sur ce site"},"menu_do_not_filter_30_sec":{"message":"Ne pas filtrer pendant 30 secondes "},"menu_block_ad_on_site":{"message":"Blocage des annonces sur ce site "},"menu_report_abuse":{"message":"Signaler le site"},"menu_site_report":{"message":"Rapport de sécurité du site"},"menu_settings":{"message":"Réglages de l\'Assistant AdGuard"},"menu_wot_reputation_indicator":{"message":"Indice de réputation du site"},"menu_wot_reputation_confidence_level":{"message":"Niveau de confiance"},"assistant_select_element":{"message":"Blocage d\'éléments "},"assistant_select_element_ext":{"message":"Choisir un élément de la page à bloquer "},"assistant_select_element_cancel":{"message":"Annuler"},"assistant_block_element":{"message":"Blocage d\'éléments "},"assistant_block_element_explain":{"message":"Affiner la règle de blocage d\'elements"},"assistant_slider_explain":{"message":"Déplacez le curseur pour modifier la taille du cadre de travail de la nouvelle règle"},"assistant_extended_settings":{"message":"Paramétrages avancés "},"assistant_apply_rule_to_all_sites":{"message":"Appliquer la règle à tous les sites"},"assistant_block_by_reference":{"message":"Blocage par liens de reference"},"assistant_block_similar":{"message":"Blocage des objets similaires "},"assistant_another_element":{"message":"Sélectionner un élément différent"},"assistant_preview":{"message":"Previsualisation "},"assistant_block":{"message":"Blocage "},"assistant_settings":{"message":"Réglages de l\'Assistant AdGuard"},"assistant_preview_header":{"message":"Blocage d\'éléments - Previsualisation "},"assistant_preview_header_info":{"message":"Assurez-vous que l\'élément est bloqué comme prévu"},"assistant_preview_end":{"message":"Sortir de la previsualisation "},"wot_unknown_description":{"message":"La définition de la réputation de ce site web n\'est pas définie par $1"},"wot_bad_description":{"message":"Ce site web a très mauvaise réputation selon $1"},"wot_poor_description":{"message":"Ce site web a mauvaise réputation selon $1"},"wot_unsatisfactory_description":{"message":"Ce site web a une reputation médiocre selon $1"},"wot_good_description":{"message":"Ce site a bonne réputation selon $1"},"wot_excellent_description":{"message":"Ce site a une réputation excellente selon $1"},"settings_choose_size_and_position":{"message":"Affiner la taille et la position de l\'assistant AdGuard "},"settings_icon_size":{"message":"Taille de l\'icone"},"settings_small":{"message":"Petite"},"settings_big":{"message":"Grande"},"settings_position":{"message":"Positionnement"},"settings_left_top":{"message":"En haut à gauche"},"settings_right_top":{"message":"En haut à droite"},"settings_left_bottom":{"message":"En bas à gauche"},"settings_right_bottom":{"message":"En bas à droite "},"settings_cancel":{"message":"Annuler"},"settings_save":{"message":"Sauvegarder les modifications "}}');

/***/ }),

/***/ 6514:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"אתרים","settings_position_save_all":"כל האתרים","settings_position_save_this":"האתר הזה","assistant_select_element_start":"התחל","assistant_select_element_text":".בחר אלמנט בדף לחסימה .רענן את הדף כדי לבטל את מצב חסימת האלמנטים","menu_filtration_status":{"message":"סינון באתר זה"},"menu_do_not_filter_30_sec":{"message":"אל תסנן למשך 30 שניות"},"menu_block_ad_on_site":{"message":"חסום פרסומת באתר זה"},"menu_report_abuse":{"message":"דווח על האתר"},"menu_site_report":{"message":"דוח אבטחת אתר"},"menu_settings":{"message":"הגדרות המסייע"},"menu_wot_reputation_indicator":{"message":"מד של מוניטין אתרים"},"menu_wot_reputation_confidence_level":{"message":"רמת אמון מוניטין"},"assistant_select_element":{"message":"חסימת אלמנט"},"assistant_select_element_ext":{"message":"בחר אלמנט בדף לחסימה"},"assistant_select_element_cancel":{"message":"בטל"},"assistant_block_element":{"message":"חסימת אלמנט"},"assistant_block_element_explain":{"message":"התאם כלל של חסימת אלמנט"},"assistant_slider_explain":{"message":"הזז את המַחְלֵק כדי לשנות את גודל המסגרת שבה הכלל החדש יעבוד:"},"assistant_extended_settings":{"message":"הגדרות מתקדמות"},"assistant_apply_rule_to_all_sites":{"message":"החל את הכלל בכל האתרים"},"assistant_block_by_reference":{"message":"חסום לפי קישור הפניה"},"assistant_block_similar":{"message":"חסום דומה"},"assistant_another_element":{"message":"בחר אלמנט אחר"},"assistant_preview":{"message":"הצג מראש"},"assistant_block":{"message":"חסום"},"assistant_settings":{"message":"הגדרות המסייע"},"assistant_preview_header":{"message":"חסימת אלמנט - תצוגה מקדימה"},"assistant_preview_header_info":{"message":"ודא כי אלמנט זה חסום כמתוכנן"},"assistant_preview_end":{"message":"צא מתצוגה מקדימה"},"wot_unknown_description":{"message":"המוניטין של אתר זה אינו מוגדר על ידי $1"},"wot_bad_description":{"message":"לאתר זה יש מוניטין רע מאוד\\nעל פי $1"},"wot_poor_description":{"message":"לאתר זה יש מוניטין רע \\nעל פי $1"},"wot_unsatisfactory_description":{"message":"לאתר זה יש מוניטין ירוד\\nעל פי $1"},"wot_good_description":{"message":"לאתר זה יש מוניטין טוב\\nעל פי $1"},"wot_excellent_description":{"message":"לאתר זה יש מוניטין מצויין\\nעל פי $1"},"settings_choose_size_and_position":{"message":"התאם גודל ומיקום של מסייע AdGuard"},"settings_icon_size":{"message":"גודל איקון:"},"settings_small":{"message":"קטן"},"settings_big":{"message":"גדול"},"settings_position":{"message":"מיקום:"},"settings_left_top":{"message":"בחלק העליון משמאל"},"settings_right_top":{"message":"בחלק העליון מימין"},"settings_left_bottom":{"message":"צד שמאל למטה"},"settings_right_bottom":{"message":"צד ימין למטה"},"settings_cancel":{"message":"בטל"},"settings_save":{"message":"שמור שינויים"}}');

/***/ }),

/***/ 1996:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"assistant_extended_settings":{"message":"उन्नत सेटिंग"},"assistant_block":{"message":"अवरुद्ध"},"settings_icon_size":{"message":"आइकन का आकार:"},"settings_small":{"message":"छोटा"},"settings_big":{"message":"बड़ा"}}');

/***/ }),

/***/ 2178:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"Web stranice","settings_position_save_all":"Sve web stranice","settings_position_save_this":"Ova web stranica","assistant_select_element_start":"Započni","assistant_select_element_text":"Odaberite element na stranici za blokiranje. Osvježite stranicu za izlazak iz načina blokade elemenata.","menu_filtration_status":{"message":"Filtriranje na ovoj web stranici"},"menu_do_not_filter_30_sec":{"message":"Ne filtriraj idućih 30 sekundi"},"menu_block_ad_on_site":{"message":"Blokiraj oglas na ovoj web stranici"},"menu_report_abuse":{"message":"Prijavi ovu stranicu"},"menu_site_report":{"message":"Sigurnosni izvještaj stranice"},"menu_settings":{"message":"Postavke pomoćnika"},"menu_wot_reputation_indicator":{"message":"Indikator reputacije stranice"},"menu_wot_reputation_confidence_level":{"message":"Razina povjerenja reputacije"},"assistant_select_element":{"message":"Blokiranje elementa"},"assistant_select_element_ext":{"message":"Odaberite element na stranici za blokiranje"},"assistant_select_element_cancel":{"message":"Poništi"},"assistant_block_element":{"message":"Blokiranje elementa"},"assistant_block_element_explain":{"message":"Prilagodite pravilo blokiranja elemenata"},"assistant_slider_explain":{"message":"Pomaknite klizač da biste promijenili veličinu okvira na koji će se primijeniti novo pravilo:"},"assistant_extended_settings":{"message":"Napredne postavke"},"assistant_apply_rule_to_all_sites":{"message":"Primjeni pravilo na sve web stranice"},"assistant_block_by_reference":{"message":"Blokiraj referentnom vezom"},"assistant_block_similar":{"message":"Blokiraj slične"},"assistant_another_element":{"message":"Odaberite drugi element"},"assistant_preview":{"message":"Pregled"},"assistant_block":{"message":"Blokiraj"},"assistant_settings":{"message":"Postavke pomoćnika"},"assistant_preview_header":{"message":"Pregled blokiranja elementa"},"assistant_preview_header_info":{"message":"Provjerite da je li element blokiran kako ste željeli"},"assistant_preview_end":{"message":"Izlaz iz pregleda"},"wot_unknown_description":{"message":"Reputaciju stranice nije odredio $1"},"wot_bad_description":{"message":"Web stranica ima jako lošu reputaciju \\nprema $1"},"wot_poor_description":{"message":"Web stranica ima lošu reputaciju \\nprema $1"},"wot_unsatisfactory_description":{"message":"Web stranica ima lošu reputaciju \\nprema $1"},"wot_good_description":{"message":"Web stranica ima dobru reputaciju \\nprema $1"},"wot_excellent_description":{"message":"Web stranica ima odličnu reputaciju \\nprema $1"},"settings_choose_size_and_position":{"message":"Podesite veličinu i poziciju AdGuard Pomoćnika"},"settings_icon_size":{"message":"Veličina ikone:"},"settings_small":{"message":"Malo"},"settings_big":{"message":"Veliko"},"settings_position":{"message":"Pozicija:"},"settings_left_top":{"message":"Gore lijevo"},"settings_right_top":{"message":"Gore desno"},"settings_left_bottom":{"message":"Dolje lijevo"},"settings_right_bottom":{"message":"Dolje desno"},"settings_cancel":{"message":"Poništi"},"settings_save":{"message":"Spremi promjene"}}');

/***/ }),

/***/ 2698:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"Weboldalak","settings_position_save_all":"Minden weboldal","settings_position_save_this":"Ez a weboldal","assistant_select_element_start":"Indítás","assistant_select_element_text":"Válassza ki az elemet az oldalon, amit blokkolni szeretne. Frissítse az oldalt, hogy kilépjen az elemblokkoló módból.","menu_filtration_status":{"message":"Szűrés ezen a weboldalon"},"menu_do_not_filter_30_sec":{"message":"Szüneteltetés 30 másodpercig"},"menu_block_ad_on_site":{"message":"Hirdetés blokkolása ezen a weboldalon"},"menu_report_abuse":{"message":"Weboldal jelentése"},"menu_site_report":{"message":"Weboldal biztonsági jelentése"},"menu_settings":{"message":"Asszisztens beállításai"},"menu_wot_reputation_indicator":{"message":"A webhely hírnevének mutatója"},"menu_wot_reputation_confidence_level":{"message":"A hírnév bizalmi szintje"},"assistant_select_element":{"message":"Elem blokkolása"},"assistant_select_element_ext":{"message":"Válassza ki az elemet az oldalon, amit blokkolni szeretne"},"assistant_select_element_cancel":{"message":"Mégse"},"assistant_block_element":{"message":"Elem blokkolása"},"assistant_block_element_explain":{"message":"Állítsa be az elemet blokkoló szabályt"},"assistant_slider_explain":{"message":"Mozgassa a csúszkát a keret méretének megváltoztatásához, amelyre az új szabály működni fog:"},"assistant_extended_settings":{"message":"Haladó beállítások"},"assistant_apply_rule_to_all_sites":{"message":"Szabály alkalmazása az összes weboldalra"},"assistant_block_by_reference":{"message":"Blokkolás link alapján"},"assistant_block_similar":{"message":"Hasonlók blokkolása"},"assistant_another_element":{"message":"Másik elem választása"},"assistant_preview":{"message":"Előnézet"},"assistant_block":{"message":"Blokkolás"},"assistant_settings":{"message":"Asszisztens beállításai"},"assistant_preview_header":{"message":"Elem blokkolása - előnézet"},"assistant_preview_header_info":{"message":"Ellenőrizze, hogy az elem blokkolva van-e a tervezett módon"},"assistant_preview_end":{"message":"Kilépés az előnézetből"},"wot_unknown_description":{"message":"Ez a weboldal nincs nyilvántartva a $1 alapján"},"wot_bad_description":{"message":"Ennek a weboldalnak nagyon rossz a megítélése a $1 alapján"},"wot_poor_description":{"message":"Ennek a weboldalnak rossz a megítélése a $1 alapján"},"wot_unsatisfactory_description":{"message":"Ennek a weboldalnak gyenge a megítélése a $1 alapján"},"wot_good_description":{"message":"Ennek a weboldalnak jó a megítélése a $1 alapján"},"wot_excellent_description":{"message":"Ennek a weboldalnak kitűnő a megítélése a $1 alapján"},"settings_choose_size_and_position":{"message":"Állítsa be az AdGuard Assistant méretét és pozícióját"},"settings_icon_size":{"message":"Ikon mérete:"},"settings_small":{"message":"Kicsi"},"settings_big":{"message":"Nagy"},"settings_position":{"message":"Pozíció:"},"settings_left_top":{"message":"Bal felül"},"settings_right_top":{"message":"Jobb felül"},"settings_left_bottom":{"message":"Bal alul"},"settings_right_bottom":{"message":"Jobb alul"},"settings_cancel":{"message":"Mégse"},"settings_save":{"message":"Változások mentése"}}');

/***/ }),

/***/ 710:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"Situs web","settings_position_save_all":"Semua situs web","settings_position_save_this":"Situs web ini","assistant_select_element_start":"Mulai","assistant_select_element_text":"Pilih elemen di halaman untuk diblokir. Segarkan halaman untuk membatalkan mode pemblokiran elemen.","menu_filtration_status":{"message":"Penyaringan di situs ini"},"menu_do_not_filter_30_sec":{"message":"Nonaktifkan penyaring untuk 30 detik"},"menu_block_ad_on_site":{"message":"Blokir iklan di situs ini"},"menu_report_abuse":{"message":"Laporkan situs"},"menu_site_report":{"message":"Laporan keamanan situs"},"menu_settings":{"message":"Pengaturan Asisten"},"menu_wot_reputation_indicator":{"message":"Indikator reputasi situs"},"menu_wot_reputation_confidence_level":{"message":"Tingkat Keyakinan Reputasi"},"assistant_select_element":{"message":"Blok Elemen"},"assistant_select_element_ext":{"message":"Pilih elemen di halaman untuk diblok"},"assistant_select_element_cancel":{"message":"Batalkan"},"assistant_block_element":{"message":"Blok Elemen"},"assistant_block_element_explain":{"message":"Atur aturan blokir elemen"},"assistant_slider_explain":{"message":"Pindahkan slider untuk mengatur ukuran frame dimana aturan baru akan aktif:"},"assistant_extended_settings":{"message":"Pengaturan lanjutan"},"assistant_apply_rule_to_all_sites":{"message":"Aktifkan aturan untuk seluruh situs"},"assistant_block_by_reference":{"message":"Blok berdasarkan referensi situs"},"assistant_block_similar":{"message":"Blok semacamnya"},"assistant_another_element":{"message":"Pilih elemen lainnya"},"assistant_preview":{"message":"Pratinjau"},"assistant_block":{"message":"Blokir"},"assistant_settings":{"message":"Pengaturan Asisten"},"assistant_preview_header":{"message":"Blok elemen - pratinjau"},"assistant_preview_header_info":{"message":"Harap pastikan bahwa elemen diblok sesuai kemauan Anda"},"assistant_preview_end":{"message":"Keluar pratinjau"},"wot_unknown_description":{"message":"Reputasi tidak terdefinisi"},"wot_bad_description":{"message":"Situs ini mempunyai reputasi sangat buruk\\nberdasarkan $1"},"wot_poor_description":{"message":"Situs ini mempunyai reputasi buruk\\nberdasarkan $1"},"wot_unsatisfactory_description":{"message":"Situs ini mempunyai reputasi biasa \\nberdasarkan $1"},"wot_good_description":{"message":"Situs ini mempunyai reputasi baik \\nberdasarkan $1"},"wot_excellent_description":{"message":"Situs ini mempunyai reputasi sempurna \\nberdasarkan $1"},"settings_choose_size_and_position":{"message":"Atur ukuran dan posisi AdGuard Assistant"},"settings_icon_size":{"message":"Ukuran ikon:"},"settings_small":{"message":"Kecil"},"settings_big":{"message":"Besar"},"settings_position":{"message":"Posisi:"},"settings_left_top":{"message":"Atas kiri"},"settings_right_top":{"message":"Atas kanan"},"settings_left_bottom":{"message":"Bawah kiri"},"settings_right_bottom":{"message":"Bawah kanan"},"settings_cancel":{"message":"Batal"},"settings_save":{"message":"Simpan perubahan"}}');

/***/ }),

/***/ 7294:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"Siti","settings_position_save_all":"Tutti i siti","settings_position_save_this":"Questo sito web","assistant_select_element_start":"Inizio","assistant_select_element_text":"Seleziona un elemento nella pagina per bloccarlo. Ricarica la pagina per annullare la modalità di blocco di un elemento.","menu_filtration_status":{"message":"Filtraggio su questo sito web"},"menu_do_not_filter_30_sec":{"message":"Non filtrare per 30 secondi"},"menu_block_ad_on_site":{"message":"Blocca annunci su questo sito web"},"menu_report_abuse":{"message":"Segnala il sito"},"menu_site_report":{"message":"Rapporto di sicurezza del sito"},"menu_settings":{"message":"Impostazioni di Assistant"},"menu_wot_reputation_indicator":{"message":"Indicatore reputazione sito"},"menu_wot_reputation_confidence_level":{"message":"Livello della reputazione"},"assistant_select_element":{"message":"Blocca elemento"},"assistant_select_element_ext":{"message":"Scegli un elemento da bloccare sulla pagina"},"assistant_select_element_cancel":{"message":"Annulla"},"assistant_block_element":{"message":"Blocca elemento"},"assistant_block_element_explain":{"message":"Modifica la regola di blocco di un elemento"},"assistant_slider_explain":{"message":"Muovi la barra per cambiare la grandezza del frame da per il quale la nuova regola funzionerà:"},"assistant_extended_settings":{"message":"Impostazioni avanzate"},"assistant_apply_rule_to_all_sites":{"message":"Applica la regola a tutti i siti"},"assistant_block_by_reference":{"message":"Blocco mediante indirizzo di riferimento"},"assistant_block_similar":{"message":"Blocca simile"},"assistant_another_element":{"message":"Seleziona un altro elemento"},"assistant_preview":{"message":"Anteprima"},"assistant_block":{"message":"Blocca"},"assistant_settings":{"message":"Impostazioni di Assistant"},"assistant_preview_header":{"message":"Blocco elemento - anteprima"},"assistant_preview_header_info":{"message":"Assicurati che l\'elemento è bloccato come richiesto"},"assistant_preview_end":{"message":"Esci dall\'anteprima"},"wot_unknown_description":{"message":"La reputazione di questo sito web non è definita da $1"},"wot_bad_description":{"message":"Questo sito web ha una pessima reputazione\\nsecondo $1"},"wot_poor_description":{"message":"Questo sito web ha una brutta reputazione\\nsecondo $1"},"wot_unsatisfactory_description":{"message":"Questo sito web ha una mediocre reputazione\\nsecondo $1"},"wot_good_description":{"message":"Questo sito web ha una buona reputazione\\nsecondo $1"},"wot_excellent_description":{"message":"Questo sito web ha una eccellente reputazione\\nsecondo $1"},"settings_choose_size_and_position":{"message":"Regola dimensione e posizione di AdGuard Assistant"},"settings_icon_size":{"message":"Grandezza dell\'icona:"},"settings_small":{"message":"Piccola"},"settings_big":{"message":"Grande"},"settings_position":{"message":"Posizione:"},"settings_left_top":{"message":"In alto a sinistra"},"settings_right_top":{"message":"In alto a destra"},"settings_left_bottom":{"message":"In basso a sinistra"},"settings_right_bottom":{"message":"In basso a destra"},"settings_cancel":{"message":"Annulla"},"settings_save":{"message":"Salva cambiamenti"}}');

/***/ }),

/***/ 9265:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"ウェブサイト","settings_position_save_all":"すべてのウェブサイト","settings_position_save_this":"このウェブサイト","assistant_select_element_start":"開始","assistant_select_element_text":"ブロックするページ上の要素を選択してください。 ページを更新し要素のブロックモードを解除します。","menu_filtration_status":{"message":"このウェブサイトをフィルタリング"},"menu_do_not_filter_30_sec":{"message":"30秒間フィルタリングしない"},"menu_block_ad_on_site":{"message":"このサイトで広告を手動ブロックする"},"menu_report_abuse":{"message":"このサイトの問題を報告する"},"menu_site_report":{"message":"ウェブサイトのセキュリティレポート"},"menu_settings":{"message":"アシスタントの設定"},"assistant_select_element":{"message":"要素をブロック"},"assistant_select_element_ext":{"message":"ブロックする要素を選択"},"assistant_select_element_cancel":{"message":"キャンセル"},"assistant_block_element":{"message":"要素をブロック"},"assistant_block_element_explain":{"message":"要素のブロックルールを調整する"},"assistant_slider_explain":{"message":"スライダーを動かすと、ブロックするフレームのサイズを変更できます:"},"assistant_extended_settings":{"message":"高度な設定"},"assistant_apply_rule_to_all_sites":{"message":"全てのウェブサイトにこのルールを適用"},"assistant_block_by_reference":{"message":"参照リンクによるブロック"},"assistant_block_similar":{"message":"類似項目をブロック"},"assistant_another_element":{"message":"他の要素を選択"},"assistant_preview":{"message":"プレビュー"},"assistant_block":{"message":"ブロック"},"assistant_settings":{"message":"アシスタントの設定"},"assistant_preview_header":{"message":"要素のブロック - プレビュー"},"assistant_preview_header_info":{"message":"要素が意図したとおりにブロックされていることを確認します"},"assistant_preview_end":{"message":"プレビューを終了"},"wot_unknown_description":{"message":"評判が定義されていません"},"wot_bad_description":{"message":"このウェブサイトは非常に評判が悪いです: "},"wot_poor_description":{"message":"このウェブサイトは評判が悪いです: "},"wot_unsatisfactory_description":{"message":"このウェブサイトは評判がやや悪いです: "},"wot_good_description":{"message":"このウェブサイトは評判が良いです: "},"wot_excellent_description":{"message":"このウェブサイトはとても評判が良いです: "},"settings_choose_size_and_position":{"message":"AdGuardアシスタントのサイズと位置を調整する"},"settings_icon_size":{"message":"アイコンの大きさ:"},"settings_small":{"message":"小"},"settings_big":{"message":"大"},"settings_position":{"message":"位置:"},"settings_left_top":{"message":"左上"},"settings_right_top":{"message":"右上"},"settings_left_bottom":{"message":"左下"},"settings_right_bottom":{"message":"右下"},"settings_cancel":{"message":"キャンセル"},"settings_save":{"message":"設定を保存"}}');

/***/ }),

/***/ 1474:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"웹사이트","settings_position_save_all":"모든 웹사이트","settings_position_save_this":"이 웹사이트","assistant_select_element_start":"시작","assistant_select_element_text":"페이지에서 차단할 요소를 선택하세요. 요소 차단 모드를 취소하려면 페이지를 새로 고침하세요.","menu_filtration_status":{"message":"이 웹사이트에서의 보호"},"menu_do_not_filter_30_sec":{"message":"30초 동안 차단 일시정지"},"menu_block_ad_on_site":{"message":"이 웹사이트에서 광고 차단"},"menu_report_abuse":{"message":"이 웹사이트에 관한 불만 사항 제출"},"menu_site_report":{"message":"웹사이트 보안 보고"},"menu_settings":{"message":"어시스턴트 설정"},"menu_wot_reputation_indicator":{"message":"웹사이트 평판 표시기"},"menu_wot_reputation_confidence_level":{"message":"평판 신뢰 수준"},"assistant_select_element":{"message":"선택 모드"},"assistant_select_element_ext":{"message":"페이지에서 아무 요소나 클릭하거나"},"assistant_select_element_cancel":{"message":"선택 모드 취소"},"assistant_block_element":{"message":"요소 차단"},"assistant_block_element_explain":{"message":"요소 차단 규칙 설정"},"assistant_slider_explain":{"message":"슬라이더로 차단할 요소의 범위를 지정하세요."},"assistant_extended_settings":{"message":"고급 설정"},"assistant_apply_rule_to_all_sites":{"message":"모든 웹사이트에 이 규칙 적용"},"assistant_block_by_reference":{"message":"참조 링크가 차단"},"assistant_block_similar":{"message":"유사한 요소 차단"},"assistant_another_element":{"message":"다른 요소 선택"},"assistant_preview":{"message":"미리 보기"},"assistant_block":{"message":"차단"},"assistant_settings":{"message":"어시스턴트 설정"},"assistant_preview_header":{"message":"요소 차단 - 미리 보기"},"assistant_preview_header_info":{"message":"의도한 대로 요소가 차단되었는지 확인하세요."},"assistant_preview_end":{"message":"미리 보기 종료"},"wot_unknown_description":{"message":"평판이 등록되지 않았습니다."},"wot_bad_description":{"message":"이 웹사이트는 아주 나쁜 평판을 갖고 있습니다.\\n제공 "},"wot_poor_description":{"message":"이 웹사이트는 나쁜 평판을 갖고 있습니다.\\n제공 "},"wot_unsatisfactory_description":{"message":"이 웹사이트는 좋지 않은 평판을 갖고 있습니다.\\n제공 "},"wot_good_description":{"message":"이 웹사이트는 좋은 평판을 갖고 있습니다.\\n제공 "},"wot_excellent_description":{"message":"이 웹사이트는 아주 좋은 평판을 갖고 있습니다.\\n제공 "},"settings_choose_size_and_position":{"message":"AdGuard 어시스턴트 크기와 위치를 조정합니다"},"settings_icon_size":{"message":"아이콘 크기:"},"settings_small":{"message":"작게"},"settings_big":{"message":"크게"},"settings_position":{"message":"위치:"},"settings_left_top":{"message":"왼쪽 위"},"settings_right_top":{"message":"오른쪽 위"},"settings_left_bottom":{"message":"왼쪽 아래"},"settings_right_bottom":{"message":"오른쪽 아래"},"settings_cancel":{"message":"취소"},"settings_save":{"message":"저장"}}');

/***/ }),

/***/ 8612:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"Interneto svetainės","settings_position_save_all":"Visos svetainės","settings_position_save_this":"Ši svetainė","assistant_select_element_start":"Pradėti","assistant_select_element_text":"Pasirinkite elementą puslapyje, kurį norite blokuoti. Atnaujinkite puslapį, kad atšauktumėte elementų blokavimo režimą.","menu_filtration_status":{"message":"Filtravimas šioje svetainėje"},"menu_do_not_filter_30_sec":{"message":"Nefiltruoti 30 sekundžių"},"menu_block_ad_on_site":{"message":"Blokuoti reklamą šioje svetainėje"},"menu_report_abuse":{"message":"Pranešti apie svetainę"},"menu_site_report":{"message":"Svetainės saugumo ataskaita"},"menu_settings":{"message":"Asistento nustatymai"},"menu_wot_reputation_indicator":{"message":"Svetainės reputacijos rodiklis"},"menu_wot_reputation_confidence_level":{"message":"Reputacijos pasitikėjimo lygis"},"assistant_select_element":{"message":"Elemento blokavimas"},"assistant_select_element_ext":{"message":"Pasirinkite elementą puslapyje, kurį norite blokuoti"},"assistant_select_element_cancel":{"message":"Atšaukti"},"assistant_block_element":{"message":"Elemento blokavimas"},"assistant_block_element_explain":{"message":"Nustatykite elemento blokavimo taisyklę"},"assistant_slider_explain":{"message":"Slankiklio pagalba, keiskite rėmelio dydį, kuriame galios nauja taisyklė:"},"assistant_extended_settings":{"message":"Išplėstiniai nustatymai"},"assistant_apply_rule_to_all_sites":{"message":"Pritaikyti taisyklę visoms svetainėms"},"assistant_block_by_reference":{"message":"Blokuoti pagal nuorodą"},"assistant_block_similar":{"message":"Blokuoti panašius"},"assistant_another_element":{"message":"Pasirinkti kitą elementą"},"assistant_preview":{"message":"Peržiūra"},"assistant_block":{"message":"Užblokuoti"},"assistant_settings":{"message":"Asistento nustatymai"},"assistant_preview_header":{"message":"Elemento blokavimas - peržiūra"},"assistant_preview_header_info":{"message":"Įsitikinkite, kad elementas yra užblokuotas kaip sumanyta"},"assistant_preview_end":{"message":"Baigti peržiūrą"},"wot_unknown_description":{"message":"Šios svetainės reputacija nėra apibrėžta $1"},"wot_bad_description":{"message":"Ši svetainė turi labai blogą reputaciją\\npagal $1"},"wot_poor_description":{"message":"Ši svetainė turi blogą reputaciją pagal $1"},"wot_unsatisfactory_description":{"message":"Ši svetainė turi prastą reputaciją pagal $1"},"wot_good_description":{"message":"Ši svetainė turi gerą reputaciją pagal $1"},"wot_excellent_description":{"message":"Ši svetainė turi puikią reputaciją pagal $1"},"settings_choose_size_and_position":{"message":"Nustatykite AdGuard Asistento dydį ir padėtį"},"settings_icon_size":{"message":"Piktogramos dydis:"},"settings_small":{"message":"Maža"},"settings_big":{"message":"Didelė"},"settings_position":{"message":"Padėtis:"},"settings_left_top":{"message":"Viršuje kairėje"},"settings_right_top":{"message":"Viršuje dešinėje"},"settings_left_bottom":{"message":"Apačioje kairėje"},"settings_right_bottom":{"message":"Apačioje dešinėje"},"settings_cancel":{"message":"Atšaukti"},"settings_save":{"message":"Išsaugoti pakeitimus"}}');

/***/ }),

/***/ 8967:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"Websites","settings_position_save_all":"Alle websites","settings_position_save_this":"Deze website","assistant_select_element_start":"Starten","assistant_select_element_text":"Kies een element op deze webpagina om te blokkeren. Herlaad de pagina om het blokkeren van het element te stoppen.","menu_filtration_status":{"message":"Filteren op deze website"},"menu_do_not_filter_30_sec":{"message":"Niet filtreren voor 30 seconden"},"menu_block_ad_on_site":{"message":"Blokkeer ad op deze website"},"menu_report_abuse":{"message":"Rapporteer de website"},"menu_site_report":{"message":"Beveiligingsrapport van website"},"menu_settings":{"message":"Instelling van de assistent"},"menu_wot_reputation_indicator":{"message":"Website reputatie indicator"},"menu_wot_reputation_confidence_level":{"message":"Vertrouwensniveau reputatie"},"assistant_select_element":{"message":"Element blokkeren"},"assistant_select_element_ext":{"message":"Kies een element op deze pagina dat je wil blokkeren"},"assistant_select_element_cancel":{"message":"Annuleren"},"assistant_block_element":{"message":"Element blokkeren"},"assistant_block_element_explain":{"message":"Pas de Element blokkeren regel aan"},"assistant_slider_explain":{"message":"Beweeg de schuifregelaar om de grootte van het frame te wijzigen waarvoor de nieuwe regel werkt:"},"assistant_extended_settings":{"message":"Geavanceerde instellingen"},"assistant_apply_rule_to_all_sites":{"message":"Regel toepassen op alle websites"},"assistant_block_by_reference":{"message":"Blokkeren via referentielink"},"assistant_block_similar":{"message":"Blokkeer vergelijkbare"},"assistant_another_element":{"message":"Een ander element selecteren"},"assistant_preview":{"message":"Voorbeeldweergave"},"assistant_block":{"message":"Blokkeren"},"assistant_settings":{"message":"Assistent instellingen"},"assistant_preview_header":{"message":"Elementblokkering - voorbeeld"},"assistant_preview_header_info":{"message":"Zorg ervoor dat het element wordt geblokkeerd zoals bedoeld"},"assistant_preview_end":{"message":"Voorbeeldweergave afsluiten"},"wot_unknown_description":{"message":"De reputatie van deze website wordt niet bepaald door $1"},"wot_bad_description":{"message":"Deze website heeft een zeer slechte reputatie\\nvolgens $1"},"wot_poor_description":{"message":"Deze website heeft een slechte reputatie\\nvolgens $ 1"},"wot_unsatisfactory_description":{"message":"Deze website heeft een slechte reputatie volgens $1"},"wot_good_description":{"message":"Deze website heeft een goede reputatie volgens $1"},"wot_excellent_description":{"message":"Deze website heeft een uitstekende reputatie volgens $1"},"settings_choose_size_and_position":{"message":"Grootte en positie van AdGuard Assistent aanpassen"},"settings_icon_size":{"message":"Grootte pictogram:"},"settings_small":{"message":"Klein"},"settings_big":{"message":"Groot"},"settings_position":{"message":"Positie:"},"settings_left_top":{"message":"Linksboven"},"settings_right_top":{"message":"Rechtsboven"},"settings_left_bottom":{"message":"Linksonder"},"settings_right_bottom":{"message":"Rechtsonder"},"settings_cancel":{"message":"Annuleren"},"settings_save":{"message":"Wijzigingen opslaan"}}');

/***/ }),

/***/ 6251:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"Nettsider","settings_position_save_all":"Alle nettsider","settings_position_save_this":"Denne nettsiden","assistant_select_element_start":"Start","assistant_select_element_text":"Velg et element på siden som skal blokkeres. Oppdater siden for å avbryte elementblokkeringsmodusen.","menu_filtration_status":{"message":"Filtrering på denne nettsiden"},"menu_do_not_filter_30_sec":{"message":"Ikke filtrer i 30 sekunder"},"menu_block_ad_on_site":{"message":"Blokker annonse på denne nettsiden"},"menu_report_abuse":{"message":"Rapporter denne nettsiden"},"menu_site_report":{"message":"Nettsidens sikkerhetsrapport"},"menu_settings":{"message":"Assistentinnstillinger"},"menu_wot_reputation_indicator":{"message":"Nettsteds-rykteindikator"},"menu_wot_reputation_confidence_level":{"message":"Ryktepålitelighetsnivå"},"assistant_select_element":{"message":"Elementblokkering"},"assistant_select_element_ext":{"message":"Velg et element på siden som skal blokkeres"},"assistant_select_element_cancel":{"message":"Avbryt"},"assistant_block_element":{"message":"Elementblokkering"},"assistant_block_element_explain":{"message":"Juster elementblokkeringsregel"},"assistant_slider_explain":{"message":"Flytt glidebryteren for å endre størrelsen på rammen den nye regelen vil fungere for:"},"assistant_extended_settings":{"message":"Avanserte innstillinger"},"assistant_apply_rule_to_all_sites":{"message":"Bruk regelen for alle nettsider"},"assistant_block_by_reference":{"message":"Blokker med referanselenke"},"assistant_block_similar":{"message":"Blokker lignende"},"assistant_another_element":{"message":"Velg et annet element"},"assistant_preview":{"message":"Forhåndsvisning"},"assistant_block":{"message":"Blokker"},"assistant_settings":{"message":"Assistentinnstillinger"},"assistant_preview_header":{"message":"Elementblokkering - forhåndsvisning"},"assistant_preview_header_info":{"message":"Kontroller at elementet er blokkert som det skal"},"assistant_preview_end":{"message":"Avslutt forhåndsvisning"},"wot_unknown_description":{"message":"Rykte er ikke definert"},"wot_bad_description":{"message":"Denne nettsiden har et veldig dårlig rykte\\ni følge $1"},"wot_poor_description":{"message":"Denne nettsiden har et dårlig rykte\\ni følge $1"},"wot_unsatisfactory_description":{"message":"Denne nettsiden har et dårlig rykte\\ni følge $1"},"wot_good_description":{"message":"Denne nettsiden har et godt rykte\\ni følge $1"},"wot_excellent_description":{"message":"Denne nettsiden har et utmerket rykte\\ni følge $1"},"settings_choose_size_and_position":{"message":"Juster størrelsen og posisjonen til AdGuard-assistent"},"settings_icon_size":{"message":"Ikonstørrelse:"},"settings_small":{"message":"Liten"},"settings_big":{"message":"Stor"},"settings_position":{"message":"Posisjoner:"},"settings_left_top":{"message":"Øverst til venstre"},"settings_right_top":{"message":"Øverst til høyre"},"settings_left_bottom":{"message":"Nederst til venstre"},"settings_right_bottom":{"message":"Nederst til høyre"},"settings_cancel":{"message":"Avbryt"},"settings_save":{"message":"Lagre endringer"}}');

/***/ }),

/***/ 1549:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"Strony internetowe","settings_position_save_all":"Wszystkie strony internetowe","settings_position_save_this":"Ta strona internetowa","assistant_select_element_start":"Rozpocznij","assistant_select_element_text":"Wybierz element na stronie do zablokowania. Odśwież stronę, aby anulować tryb blokowania elementu.","menu_filtration_status":{"message":"Filtrowanie na tej stronie internetowej"},"menu_do_not_filter_30_sec":{"message":"Nie filtruj przez 30 sekund"},"menu_block_ad_on_site":{"message":"Zablokuj reklamę na tej stronie internetowej"},"menu_report_abuse":{"message":"Raportuj stronę internetową"},"menu_site_report":{"message":"Raport bezpieczeństwa strony internetowej"},"menu_settings":{"message":"Ustawienia Asystenta"},"menu_wot_reputation_indicator":{"message":"Wskaźnik reputacji witryny"},"menu_wot_reputation_confidence_level":{"message":"Poziom zaufania do reputacji"},"assistant_select_element":{"message":"Blokowanie elementów"},"assistant_select_element_ext":{"message":"Wybierz element na stronie by zablokować"},"assistant_select_element_cancel":{"message":"Anuluj"},"assistant_block_element":{"message":"Blokowanie elementów"},"assistant_block_element_explain":{"message":"Dostosuj regułę blokowania elementów"},"assistant_slider_explain":{"message":"Przesuń suwak by zmienić rozmiar ramki, dla której będzie obowiązywać nowa reguła:"},"assistant_extended_settings":{"message":"Ustawienia zaawansowane"},"assistant_apply_rule_to_all_sites":{"message":"Zastosuj regułę dla wszystkich stron internetowych"},"assistant_block_by_reference":{"message":"Blokuj używając linka referencyjnego"},"assistant_block_similar":{"message":"Blokuj podobne"},"assistant_another_element":{"message":"Wybierz inny element"},"assistant_preview":{"message":"Podgląd"},"assistant_block":{"message":"Blokuj"},"assistant_settings":{"message":"Ustawienia Asystenta"},"assistant_preview_header":{"message":"Blokowanie elementów - podgląd"},"assistant_preview_header_info":{"message":"Upewnij się, że element jest blokowany jak zamierzono"},"assistant_preview_end":{"message":"Zamknij podgląd"},"wot_unknown_description":{"message":"Reputacja nie jest zdefiniowana"},"wot_bad_description":{"message":"Ta strona internetowa ma bardzo złą reputację zgodnie z $1"},"wot_poor_description":{"message":"Ta strona internetowa ma złą reputację zgodnie z $1"},"wot_unsatisfactory_description":{"message":"Ta strona internetowa ma słabą reputację zgodnie z $1"},"wot_good_description":{"message":"Ta strona internetowa ma dobrą reputację zgodnie z $1"},"wot_excellent_description":{"message":"Ta strona internetowa ma doskonałą reputację zgodnie z $1"},"settings_choose_size_and_position":{"message":"Dostosuj rozmiar i pozycję Asystenta AdGuarda"},"settings_icon_size":{"message":"Rozmiar ikony:"},"settings_small":{"message":"Mały"},"settings_big":{"message":"Duży"},"settings_position":{"message":"Pozycja:"},"settings_left_top":{"message":"Lewy górny"},"settings_right_top":{"message":"Prawy górny"},"settings_left_bottom":{"message":"Na dole po lewej"},"settings_right_bottom":{"message":"Na dole po prawej"},"settings_cancel":{"message":"Anuluj"},"settings_save":{"message":"Zapisz zmiany"}}');

/***/ }),

/***/ 1902:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"Sítios","settings_position_save_all":"Todos os sítios","settings_position_save_this":"Este sítio","assistant_select_element_start":"Iniciar","assistant_select_element_text":"Escolha um elemento na página para bloquear. Atualize a página para cancelar o bloqueio do elemento.","menu_filtration_status":{"message":"A filtrar este sítio"},"menu_do_not_filter_30_sec":{"message":"Não filtrar durante 30 segundos"},"menu_block_ad_on_site":{"message":"Bloquear publicidade neste sítio"},"menu_report_abuse":{"message":"Denunciar o sítio"},"menu_site_report":{"message":"Relatório de segurança do sítio"},"menu_settings":{"message":"Configurações do assistente"},"menu_wot_reputation_indicator":{"message":"Indicador de reputação do sítio"},"menu_wot_reputation_confidence_level":{"message":"Nível de Confiança de Reputação"},"assistant_select_element":{"message":"Bloqueio de elemento"},"assistant_select_element_ext":{"message":"Escolha um elemento na página para bloquear"},"assistant_select_element_cancel":{"message":"Cancelar"},"assistant_block_element":{"message":"Bloqueio de elementos"},"assistant_block_element_explain":{"message":"Ajustar a regra de bloqueio do elemento"},"assistant_slider_explain":{"message":"Desloque o controlo deslizante para alterar o tamanho do quadro para o qual a nova regra irá funcionar:"},"assistant_extended_settings":{"message":"Definições avançadas"},"assistant_apply_rule_to_all_sites":{"message":"Aplicar a regra para todos os sítios"},"assistant_block_by_reference":{"message":"Bloquear por link de referência"},"assistant_block_similar":{"message":"Bloquear semelhante"},"assistant_another_element":{"message":"Selecionar um elemento diferente"},"assistant_preview":{"message":"Pré-visualização"},"assistant_block":{"message":"Bloquear"},"assistant_settings":{"message":"Configurações do assistente"},"assistant_preview_header":{"message":"Bloquear elemento - pré-visualização"},"assistant_preview_header_info":{"message":"Certifique-se de que o elemento está bloqueado como pretendido"},"assistant_preview_end":{"message":"Sair da previsualização"},"wot_unknown_description":{"message":"A reputação deste sítio não está definida por $1"},"wot_bad_description":{"message":"Este sítio tem uma péssima reputação\\nde acordo com $1"},"wot_poor_description":{"message":"Este sítio tem uma má reputação\\nde acordo com $1"},"wot_unsatisfactory_description":{"message":"Este sítio tem uma frágil reputação\\nde acordo com $1"},"wot_good_description":{"message":"Este sítio tem uma boa reputação\\nde acordo com $1"},"wot_excellent_description":{"message":"Este sítio tem uma excelente reputação\\nde acordo com $1"},"settings_choose_size_and_position":{"message":"Ajustar o tamanho e a posição do Assistente do AdGuard"},"settings_icon_size":{"message":"Tamanho do ícone:"},"settings_small":{"message":"Pequeno"},"settings_big":{"message":"Grande"},"settings_position":{"message":"Posição:"},"settings_left_top":{"message":"Canto superior esquerdo"},"settings_right_top":{"message":"Canto superior direito"},"settings_left_bottom":{"message":"Canto inferior esquerdo"},"settings_right_bottom":{"message":"Canto inferior direito"},"settings_cancel":{"message":"Cancelar"},"settings_save":{"message":"Guardar alterações"}}');

/***/ }),

/***/ 9274:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"Sites","settings_position_save_all":"Todos os sites","settings_position_save_this":"Neste site","assistant_select_element_start":"Iniciar","assistant_select_element_text":"Escolha um elemento na página para bloquear. Atualize a página para cancelar o bloqueio do elemento.","menu_filtration_status":{"message":"Filtragem neste site"},"menu_do_not_filter_30_sec":{"message":"Não filtrar durante 30 segundos"},"menu_block_ad_on_site":{"message":"Bloquear anúncios neste site"},"menu_report_abuse":{"message":"Reportar o site"},"menu_site_report":{"message":"Relatório de segurança do site"},"menu_settings":{"message":"Configurações do assistente"},"menu_wot_reputation_indicator":{"message":"Indicador de reputação do site"},"menu_wot_reputation_confidence_level":{"message":"Nível de confiança de reputação"},"assistant_select_element":{"message":"Bloqueio de elemento"},"assistant_select_element_ext":{"message":"Escolha um elemento na página para bloquear"},"assistant_select_element_cancel":{"message":"Cancelar"},"assistant_block_element":{"message":"Bloqueio de elemento"},"assistant_block_element_explain":{"message":"Ajustar a regra de bloqueio de elemento"},"assistant_slider_explain":{"message":"Mova o controle deslizante para alterar o tamanho do quadro para o qual a nova regra funcionará:"},"assistant_extended_settings":{"message":"Configurações avançadas"},"assistant_apply_rule_to_all_sites":{"message":"Aplicar regra para todos os sites"},"assistant_block_by_reference":{"message":"Bloquear pelo link de referência"},"assistant_block_similar":{"message":"Bloquear semelhante"},"assistant_another_element":{"message":"Selecione um elemento diferente"},"assistant_preview":{"message":"Pré-visualização"},"assistant_block":{"message":"Bloquear"},"assistant_settings":{"message":"Configurações do assistente"},"assistant_preview_header":{"message":"Bloqueio de elemento - pré-visualização"},"assistant_preview_header_info":{"message":"Certifique-se de que o elemento esteja bloqueado como desejado"},"assistant_preview_end":{"message":"Sair da pré-visualização"},"wot_unknown_description":{"message":"A reputação deste site ainda não foi definida por $1"},"wot_bad_description":{"message":"Este site tem uma reputação muito ruim\\nde acordo com $1"},"wot_poor_description":{"message":"Este site tem uma má reputação\\nde acordo com $1"},"wot_unsatisfactory_description":{"message":"Este site tem uma reputação ruim\\nde acordo com $1"},"wot_good_description":{"message":"Este site tem uma boa reputação\\nde acordo com $1"},"wot_excellent_description":{"message":"Este site tem uma excelente reputação\\nde acordo com $1"},"settings_choose_size_and_position":{"message":"Ajuste o tamanho e posição do Assistente do AdGuard"},"settings_icon_size":{"message":"Tamanho do ícone:"},"settings_small":{"message":"Pequeno"},"settings_big":{"message":"Grande"},"settings_position":{"message":"Posição:"},"settings_left_top":{"message":"Canto superior esquerdo"},"settings_right_top":{"message":"Canto superior direito"},"settings_left_bottom":{"message":"Canto inferior esquerdo"},"settings_right_bottom":{"message":"Canto inferior direito"},"settings_cancel":{"message":"Cancelar"},"settings_save":{"message":"Salvar alterações"}}');

/***/ }),

/***/ 6090:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"Site web","settings_position_save_all":"Toate site-urile","settings_position_save_this":"Acest site","assistant_select_element_start":"Start","assistant_select_element_text":"Alegeți elementul de blocat pe pagină. Actualizați pagina ca să anulați modul de blocare a elementului.","menu_filtration_status":{"message":"Filtrare pe acest site web"},"menu_do_not_filter_30_sec":{"message":"Nu filtra pentru 30 secunde"},"menu_block_ad_on_site":{"message":"Blocare reclame pe acest site"},"menu_report_abuse":{"message":"Raportați site-ul"},"menu_site_report":{"message":"Raport de securitate site"},"menu_settings":{"message":"Setări asistent"},"menu_wot_reputation_indicator":{"message":"Indicator reputație site"},"menu_wot_reputation_confidence_level":{"message":"Nivel de încredere în reputație"},"assistant_select_element":{"message":"Element de blocat"},"assistant_select_element_ext":{"message":"Alegeți un element de blocat pe pagină"},"assistant_select_element_cancel":{"message":"Anulare"},"assistant_block_element":{"message":"Blocare de element"},"assistant_block_element_explain":{"message":"Ajustați regula de blocare element"},"assistant_slider_explain":{"message":"Mișcarea glisorului schimbă talia cadrului în care va funcționa noua regulă:"},"assistant_extended_settings":{"message":"Setări avansate"},"assistant_apply_rule_to_all_sites":{"message":"Aplică regula pe orice site"},"assistant_block_by_reference":{"message":"Blocare după link de referință"},"assistant_block_similar":{"message":"Blocare similare"},"assistant_another_element":{"message":"Alegeți un element diferit"},"assistant_preview":{"message":"Ecran"},"assistant_block":{"message":"Blocați"},"assistant_settings":{"message":"Setări asistent"},"assistant_preview_header":{"message":"Blocare element - previzualizare"},"assistant_preview_header_info":{"message":"Verificați blocarea elementului conform planului"},"assistant_preview_end":{"message":"Ieșire ecran"},"wot_unknown_description":{"message":"Reputația acestui site nu este definită de $1"},"wot_bad_description":{"message":"Acest site are o reputație foarte proastă\\nconform cu $1"},"wot_poor_description":{"message":"Acest site are o reputație proastă\\nconform cu $1"},"wot_unsatisfactory_description":{"message":"Acest site are o reputație slabă\\nconform cu $1"},"wot_good_description":{"message":"Acest site are o reputație bună\\nconform cu $1"},"wot_excellent_description":{"message":"Acest site are o reputație excelentă\\nconform cu $1"},"settings_choose_size_and_position":{"message":"Ajustați talia și poziția Asistentului AdGuard"},"settings_icon_size":{"message":"Talie icoană:"},"settings_small":{"message":"Mică"},"settings_big":{"message":"Mare"},"settings_position":{"message":"Poziție:"},"settings_left_top":{"message":"Stânga sus"},"settings_right_top":{"message":"Dreapta sus"},"settings_left_bottom":{"message":"Stânga jos"},"settings_right_bottom":{"message":"Dreapta jos"},"settings_cancel":{"message":"Anulare"},"settings_save":{"message":"Salvare alegeri"}}');

/***/ }),

/***/ 3999:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"Сайты","settings_position_save_all":"На всех","settings_position_save_this":"Только на этом","assistant_select_element_start":"Начать","assistant_select_element_text":"Выберите на странице элемент для блокирования. Обновите страницу, чтобы отменить режим блокировки элементов.","menu_filtration_status":{"message":"Фильтрация на этом сайте"},"menu_do_not_filter_30_sec":{"message":"Не фильтровать 30 секунд"},"menu_block_ad_on_site":{"message":"Заблокировать рекламу на сайте"},"menu_report_abuse":{"message":"Пожаловаться на сайт"},"menu_site_report":{"message":"Отчёт о безопасности сайта"},"menu_settings":{"message":"Настроить помощник"},"menu_wot_reputation_indicator":{"message":"Индикатор репутации сайта"},"menu_wot_reputation_confidence_level":{"message":"Уровень доверия к репутации"},"assistant_select_element":{"message":" Блокировка элемента"},"assistant_select_element_ext":{"message":"Выберите на странице элемент, который надо заблокировать"},"assistant_select_element_cancel":{"message":"Отмена"},"assistant_block_element":{"message":"Блокировка элемента"},"assistant_block_element_explain":{"message":"Настройте правило блокирования элемента"},"assistant_slider_explain":{"message":"Перемещайте бегунок, чтобы изменить размер блока, для которого будет действовать правило:"},"assistant_extended_settings":{"message":"Расширенные настройки"},"assistant_apply_rule_to_all_sites":{"message":"Применить правило для всех сайтов"},"assistant_block_by_reference":{"message":"Блокировать по ссылке"},"assistant_block_similar":{"message":"Блокировать похожие"},"assistant_another_element":{"message":"Выбрать другой элемент"},"assistant_preview":{"message":"Предпросмотр"},"assistant_block":{"message":"Заблокировать"},"assistant_settings":{"message":"Настройка помощника"},"assistant_preview_header":{"message":"Блокировка элемента – предпросмотр"},"assistant_preview_header_info":{"message":"Убедитесь, что элемент заблокирован как задумано"},"assistant_preview_end":{"message":"Закончить предпросмотр"},"wot_unknown_description":{"message":"Репутация не определена расширением $1"},"wot_bad_description":{"message":"У сайта очень плохая репутация по данным $1"},"wot_poor_description":{"message":"У сайта плохая репутация по данным $1"},"wot_unsatisfactory_description":{"message":"У сайта неудовлетворительная репутация по данным $1"},"wot_good_description":{"message":"У сайта хорошая репутация по данным $1"},"wot_excellent_description":{"message":"У сайта отличная репутация по данным $1"},"settings_choose_size_and_position":{"message":"Настройте размер и положение помощника AdGuard"},"settings_icon_size":{"message":"Размер иконки:"},"settings_small":{"message":"Маленькая"},"settings_big":{"message":"Большая"},"settings_position":{"message":"Расположение:"},"settings_left_top":{"message":"Вверху слева"},"settings_right_top":{"message":"Вверху справа"},"settings_left_bottom":{"message":"Внизу слева"},"settings_right_bottom":{"message":"Внизу справа"},"settings_cancel":{"message":"Отмена"},"settings_save":{"message":"Сохранить настройки"}}');

/***/ }),

/***/ 89:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"Webové stránky","settings_position_save_all":"Všetky stránky","settings_position_save_this":"Táto stránka","assistant_select_element_start":"Štart","assistant_select_element_text":"Vyberte prvok na stránke, ktorý chcete zablokovať. Obnovte stránku pre zrušenie režimu blokovania prvkov.","menu_filtration_status":{"message":"Filtrácia na tejto stránke"},"menu_do_not_filter_30_sec":{"message":"Nefiltrovať počas 30 sekúnd"},"menu_block_ad_on_site":{"message":"Blokovať reklamy na tejto stránke"},"menu_report_abuse":{"message":"Nahlásiť stránku"},"menu_site_report":{"message":"Bezpečnostná správa o stránke"},"menu_settings":{"message":"Nastavenia asistenta"},"menu_wot_reputation_indicator":{"message":"Indikátor reputácie stránok"},"menu_wot_reputation_confidence_level":{"message":"Úroveň spoľahlivosti reputácie"},"assistant_select_element":{"message":"Blokovanie prvku"},"assistant_select_element_ext":{"message":"Vyberte prvok stránky, ktorý sa má blokovať"},"assistant_select_element_cancel":{"message":"Zrušiť"},"assistant_block_element":{"message":"Blokovanie prvku"},"assistant_block_element_explain":{"message":"Upraviť pravidlo blokovania prvku"},"assistant_slider_explain":{"message":"Použite posuvník pre zmenu veľkosti rámu pre nové pravidlo, ktoré bude použité na:"},"assistant_extended_settings":{"message":"Pokročilé nastavenia"},"assistant_apply_rule_to_all_sites":{"message":"Použiť pravidlo na všetky stránky"},"assistant_block_by_reference":{"message":"Blokovať referenčným odkazom"},"assistant_block_similar":{"message":"Blokovať podobné"},"assistant_another_element":{"message":"Zvoliť iný prvok"},"assistant_preview":{"message":"Náhľad"},"assistant_block":{"message":"Blokovať"},"assistant_settings":{"message":"Nastavenia asistenta"},"assistant_preview_header":{"message":"Blokovanie prvku - náhľad"},"assistant_preview_header_info":{"message":"Uistite sa, že prvok je blokovaný podľa Vašich predstáv"},"assistant_preview_end":{"message":"Ukončenie náhľadu"},"wot_unknown_description":{"message":"Reputácia tejto webovej stránky nie je v $1 definovaná"},"wot_bad_description":{"message":"Táto stránka má podľa $1\\nveľmi zlú reputáciu"},"wot_poor_description":{"message":"Táto stránka má podľa $1\\nzlú reputáciu"},"wot_unsatisfactory_description":{"message":"Táto stránka má podľa $1\\nslabú reputáciu"},"wot_good_description":{"message":"Táto stránka má podľa $1\\ndobrú reputáciu"},"wot_excellent_description":{"message":"Táto stránka má podľa $1\\nvýbornú reputáciu"},"settings_choose_size_and_position":{"message":"Prispôsobiť veľkosť a polohu AdGuard asistenta"},"settings_icon_size":{"message":"Veľkosť ikony:"},"settings_small":{"message":"Malá"},"settings_big":{"message":"Veľká"},"settings_position":{"message":"Poloha:"},"settings_left_top":{"message":"Vľavo hore"},"settings_right_top":{"message":"Vpravo hore"},"settings_left_bottom":{"message":"Vľavo dole"},"settings_right_bottom":{"message":"Vpravo dole"},"settings_cancel":{"message":"Zrušiť"},"settings_save":{"message":"Uložiť zmeny"}}');

/***/ }),

/***/ 6058:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"Spletne strani","settings_position_save_all":"Vse pletne strani","settings_position_save_this":"To spletno stran","assistant_select_element_start":"Začni","assistant_select_element_text":"Izberite element na strani, ki jo želite onemogočiti. Osvežite stran, da prekličete način zaviranja elementa.","menu_filtration_status":{"message":"Filtriranje na tej spletni strani"},"menu_do_not_filter_30_sec":{"message":"Ne filtriraj 30 sekund"},"menu_block_ad_on_site":{"message":"Onemogoči oglas na tej spletni strani"},"menu_report_abuse":{"message":"Prijavi spletno stran"},"menu_site_report":{"message":"Poročilo o varnosti spletne strani"},"menu_settings":{"message":"Nastavitve Pomočnika"},"menu_wot_reputation_indicator":{"message":"Kazalnik ugleda spletnestrani"},"menu_wot_reputation_confidence_level":{"message":"Raven ugleda zaupanja"},"assistant_select_element":{"message":"Onemogočanje elementa"},"assistant_select_element_ext":{"message":"Izberite element na strani, ki ga želite onemogočiti"},"assistant_select_element_cancel":{"message":"Prekliči"},"assistant_block_element":{"message":"Onemogočanje elementa"},"assistant_block_element_explain":{"message":"Prilagodite pravilo za onemogočanje elementa"},"assistant_slider_explain":{"message":"Premaknite drsnik, da spremenite velikost okvirja, za katerega bo delovalo novo pravilo:"},"assistant_extended_settings":{"message":"Napredne nastavitve"},"assistant_apply_rule_to_all_sites":{"message":"Uporabi pravilo za vse spletne strani"},"assistant_block_by_reference":{"message":"Onemogočij z napotitveno povezavo"},"assistant_block_similar":{"message":"Onemogoči podobno"},"assistant_another_element":{"message":"Izberi drug element"},"assistant_preview":{"message":"Predogled"},"assistant_block":{"message":"Onemogoči"},"assistant_settings":{"message":"Nastavitve Pomočnika"},"assistant_preview_header":{"message":"Onemogočanje elementa - predogled"},"assistant_preview_header_info":{"message":"Prepričajte se, da je element bil onemogočen, kot je bilo predvideno"},"assistant_preview_end":{"message":"Zapusti predogled"},"wot_unknown_description":{"message":"Ugled te spletne strani ni opredeljen z $1"},"wot_bad_description":{"message":"Ta spletna stran ima zelo slab ugled\\nglede na $1"},"wot_poor_description":{"message":"Ta spletna stran ima slab ugled\\nglede na $1"},"wot_unsatisfactory_description":{"message":"Ta spletna stran ima zelo slab ugled\\nglede na $1"},"wot_good_description":{"message":"Ta spletna stran ima dober ugled\\nglede na $1"},"wot_excellent_description":{"message":"Ta spletna stran ima odličen ugled\\nglede na $1"},"settings_choose_size_and_position":{"message":"Prilagodi velikost in položaj AdGuard Pomočnika"},"settings_icon_size":{"message":"Velikost ikone:"},"settings_small":{"message":"Majhna"},"settings_big":{"message":"Velika"},"settings_position":{"message":"Položaj:"},"settings_left_top":{"message":"Zgoraj levo"},"settings_right_top":{"message":"Zgoraj desno"},"settings_left_bottom":{"message":"Spodaj levo"},"settings_right_bottom":{"message":"Spodaj desno"},"settings_cancel":{"message":"Prekliči"},"settings_save":{"message":"Shrani nastavitve"}}');

/***/ }),

/***/ 9177:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"Sajtovi","settings_position_save_all":"Svi sajtovi","settings_position_save_this":"Ovaj sajt","assistant_select_element_start":"Započni","assistant_select_element_text":"Izaberite element na stranici koji želite da blokirate. Osvežite stranicu da otkažete blokiranje elemenata.","menu_filtration_status":{"message":"Filtriranje na ovom sajtu"},"menu_do_not_filter_30_sec":{"message":"Ne filtriraj u narednih 30 sekundi"},"menu_block_ad_on_site":{"message":"Blokiraj reklamu na ovom sajtu"},"menu_report_abuse":{"message":"Prijavi sajt"},"menu_site_report":{"message":"Bezbednosni izveštaj o sajtu"},"menu_settings":{"message":"Postavke pomoćnika"},"menu_wot_reputation_indicator":{"message":"Indikator reputacije sajta"},"menu_wot_reputation_confidence_level":{"message":"Nivo poverljivosti reputacije"},"assistant_select_element":{"message":"Blokiranje elementa"},"assistant_select_element_ext":{"message":"Izaberite element koji želite da blokirate na stranici"},"assistant_select_element_cancel":{"message":"Otkaži"},"assistant_block_element":{"message":"Blokiranje elementa"},"assistant_block_element_explain":{"message":"Podesite pravilo blokiranja elementa"},"assistant_slider_explain":{"message":"Pomerajte klizač kako bi ste promenili veličinu okvira po kom će pravilo raditi:"},"assistant_extended_settings":{"message":"Napredne postavke"},"assistant_apply_rule_to_all_sites":{"message":"Primeni pravilo na sve sajtove"},"assistant_block_by_reference":{"message":"Blokiraj po linku reference"},"assistant_block_similar":{"message":"Blokiraj slično"},"assistant_another_element":{"message":"Izaberite drugi element"},"assistant_preview":{"message":"Pregled"},"assistant_block":{"message":"Blokiraj"},"assistant_settings":{"message":"Postavke pomoćnika"},"assistant_preview_header":{"message":"Pregled blokiranja elementa"},"assistant_preview_header_info":{"message":"Uverite se da je element blokiran kako ste želeli"},"assistant_preview_end":{"message":"Napusti pregled"},"wot_unknown_description":{"message":"Reputacija nije definisana"},"wot_bad_description":{"message":"Ovaj sajt ima veoma lošu reputaciju\\nprema "},"wot_poor_description":{"message":"Ovaj sajt ima lošu reputaciju\\nprema "},"wot_unsatisfactory_description":{"message":"Ovaj sajt ima slabu reputaciju\\nprema "},"wot_good_description":{"message":"Ovaj sajt ima dobru reputaciju\\nprema "},"wot_excellent_description":{"message":"Ovaj sajt ima odličnu reputaciju\\nprema "},"settings_choose_size_and_position":{"message":"Podesite veličinu i poziciju AdGuard pomoćnika"},"settings_icon_size":{"message":"Veličina ikonice"},"settings_small":{"message":"Mala"},"settings_big":{"message":"Velika"},"settings_position":{"message":"Pozicija:"},"settings_left_top":{"message":"Gore levo"},"settings_right_top":{"message":"Gore desno"},"settings_left_bottom":{"message":"Dole levo"},"settings_right_bottom":{"message":"Dole desno"},"settings_cancel":{"message":"Otkaži"},"settings_save":{"message":"Sačuvaj promene"}}');

/***/ }),

/***/ 6105:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"Webbplatser","settings_position_save_all":"Alla webbplatser","settings_position_save_this":"Den här webbplatsen","assistant_select_element_text":"Välj ett element sidan att blockera. Återladda sidan för att återställa elementblockeringsläget.","menu_filtration_status":{"message":"Webbplatsens filtrering"},"menu_do_not_filter_30_sec":{"message":"Pausa filtrering 30 sekunder"},"menu_block_ad_on_site":{"message":"Blockera annons på den här webbplatsen"},"menu_report_abuse":{"message":"Rapportera webbplatsen"},"menu_site_report":{"message":"Säkerhetsrapport för webbplatsen"},"menu_settings":{"message":"Assistentinställningar"},"assistant_select_element":{"message":"Blockering av annonselement"},"assistant_select_element_ext":{"message":"Välj ett annonselement för blockering"},"assistant_select_element_cancel":{"message":"Avbryt"},"assistant_block_element":{"message":"Blockering av annonselement"},"assistant_block_element_explain":{"message":"Anpassa blockeringsregeln för annonselementet"},"assistant_slider_explain":{"message":"Justera storleken på annonselementet som den nya blockeringsregeln skall avse:"},"assistant_extended_settings":{"message":"Avancerade val"},"assistant_apply_rule_to_all_sites":{"message":"Tillämpa regelns på alla webbplatster"},"assistant_block_by_reference":{"message":"Blockera med referenslänk"},"assistant_block_similar":{"message":"Blockera liknande"},"assistant_another_element":{"message":"Markera ett annat annonselement"},"assistant_preview":{"message":"Förhandsgranska"},"assistant_block":{"message":"Blockera"},"assistant_settings":{"message":"Assistentval"},"assistant_preview_header":{"message":"Förhandsgranskning av elementblockeringen"},"assistant_preview_header_info":{"message":"Kontrollera att elementet blockerats som avsett"},"assistant_preview_end":{"message":"Avsluta förhandsgranskningen"},"wot_unknown_description":{"message":"Den här sajtens anseende är inte klarlagd av $1"},"wot_bad_description":{"message":"Webbplatsen har ett mycket dåligt anseende\\nenligt $1"},"wot_poor_description":{"message":"Webbplatsen har dåligt anseende\\nenligt $1"},"wot_unsatisfactory_description":{"message":"Webbplatsen har tveksamt anseende\\nenligt $1"},"wot_good_description":{"message":"Webbplatsen har gott anseende\\nenligt $1"},"wot_excellent_description":{"message":"Webbplatsen har ett mycket gott anseende\\nenligt $1"},"settings_choose_size_and_position":{"message":"Anpassas storlek och läge för AdGuardassistenten"},"settings_icon_size":{"message":"Ikonstorlek"},"settings_small":{"message":"Liten"},"settings_big":{"message":"Stor"},"settings_position":{"message":"Läge:"},"settings_left_top":{"message":"Ovan vänster"},"settings_right_top":{"message":"Ovan höger"},"settings_left_bottom":{"message":"Nedan vänster"},"settings_right_bottom":{"message":"Nedan höger"},"settings_cancel":{"message":"Avbryt"},"settings_save":{"message":"Spara ändringar"}}');

/***/ }),

/***/ 147:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"Siteler","settings_position_save_all":"Tüm siteler","settings_position_save_this":"Bu site","assistant_select_element_start":"Başla","assistant_select_element_text":"Engellemek için sayfada bir öğe seçin. Öğe engelleme modunu iptal etmek için sayfayı yenileyin.","menu_filtration_status":{"message":"Bu sitedeki filtreleme"},"menu_do_not_filter_30_sec":{"message":"30 saniyeliğine filtreleme yapma"},"menu_block_ad_on_site":{"message":"Bu sitede reklam engelle"},"menu_report_abuse":{"message":"Siteyi bildir"},"menu_site_report":{"message":"Sitenin güvenlik raporu"},"menu_settings":{"message":"Asistan ayarları"},"menu_wot_reputation_indicator":{"message":"Site itibarı göstergesi"},"menu_wot_reputation_confidence_level":{"message":"İtibarın Güven Seviyesi"},"assistant_select_element":{"message":"Öğe engelleme"},"assistant_select_element_ext":{"message":"Sayfada engellenecek bir öğe seçin"},"assistant_select_element_cancel":{"message":"İptal"},"assistant_block_element":{"message":"Öğe engelleme"},"assistant_block_element_explain":{"message":"Öğe engelleme kuralını ayarla"},"assistant_slider_explain":{"message":"Yeni kuralın çalışacağı çerçevenin boyutunu değiştirmek için kayar düğmeyi hareket ettirin"},"assistant_extended_settings":{"message":"Gelişmiş ayarlar"},"assistant_apply_rule_to_all_sites":{"message":"Kuralı tüm sitelerde uygula"},"assistant_block_by_reference":{"message":"Referans bağlantı ile engelle"},"assistant_block_similar":{"message":"Benzerlerini engelle"},"assistant_another_element":{"message":"Farklı bir öğe seç"},"assistant_preview":{"message":"Önizleme"},"assistant_block":{"message":"Engelle"},"assistant_settings":{"message":"Asistan ayarları"},"assistant_preview_header":{"message":"Öğe engelleme - ön izleme"},"assistant_preview_header_info":{"message":"Öğenin istediğiniz gibi engellendiğinden emin olun"},"assistant_preview_end":{"message":"Önizlemeden çık"},"wot_unknown_description":{"message":"Bu sitenin itibarı $1 tarafından henüz belirlenmemiş"},"wot_bad_description":{"message":"1$\'a göre bu site çok kötü \\nbir itibara sahip"},"wot_poor_description":{"message":"1$\'a göre bu site kötü \\nbir itibara sahip"},"wot_unsatisfactory_description":{"message":"1$\'a göre bu site zayıf\\nbir itibara sahip"},"wot_good_description":{"message":"1$\'a göre bu site iyi\\nbir itibara sahip"},"wot_excellent_description":{"message":"1$\'a göre bu site mükemmel\\nbir itibara sahip"},"settings_choose_size_and_position":{"message":"AdGuard Asistanın boyutunu ve konumunu ayarlayın"},"settings_icon_size":{"message":"Simge boyutu:"},"settings_small":{"message":"Küçük"},"settings_big":{"message":"Büyük"},"settings_position":{"message":"Konum:"},"settings_left_top":{"message":"Sol üst"},"settings_right_top":{"message":"Sağ üst"},"settings_left_bottom":{"message":"Sol alt"},"settings_right_bottom":{"message":"Sağ alt"},"settings_cancel":{"message":"İptal"},"settings_save":{"message":"Değişiklikleri kaydet"}}');

/***/ }),

/***/ 1249:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"Сайти","settings_position_save_all":"На всіх","settings_position_save_this":"Тільки на даному","assistant_select_element_start":"Почати","assistant_select_element_text":"Виберіть елемент на сторінці, який треба заблокувати. Оновіть сторінку, щоб скасувати режим блокування.","menu_filtration_status":{"message":"Фільтрування на цьому сайті"},"menu_do_not_filter_30_sec":{"message":"Не фільтрувати 30 секунд"},"menu_block_ad_on_site":{"message":"Заблокувати рекламу на даному сайті"},"menu_report_abuse":{"message":"Повідомити про сайт"},"menu_site_report":{"message":"Звіт про безпеку сайту"},"menu_settings":{"message":"Налаштування помічника"},"menu_wot_reputation_indicator":{"message":"Індикатор репутації сайту"},"menu_wot_reputation_confidence_level":{"message":"Рівень надійності репутації"},"assistant_select_element":{"message":"Блокування елементу"},"assistant_select_element_ext":{"message":"Виберіть елемент на сторінці, який треба заблокувати"},"assistant_select_element_cancel":{"message":"Скасувати"},"assistant_block_element":{"message":"Блокування елементу"},"assistant_block_element_explain":{"message":"Налаштуйте правило блокування елементу"},"assistant_slider_explain":{"message":"Пересувайте повзунок, щоб змінити розмір блоку, для якого діятиме правило:"},"assistant_extended_settings":{"message":"Розширені налаштування"},"assistant_apply_rule_to_all_sites":{"message":"Застосувати правило для всіх сайтів"},"assistant_block_by_reference":{"message":"Блокувати за посиланням"},"assistant_block_similar":{"message":"Блокувати схожі елементи"},"assistant_another_element":{"message":"Вибрати інший елемент"},"assistant_preview":{"message":"Попередній перегляд"},"assistant_block":{"message":"Заблокувати"},"assistant_settings":{"message":"Налаштування помічника"},"assistant_preview_header":{"message":"Блокування елементу - попередній перегляд"},"assistant_preview_header_info":{"message":"Переконайтеся, що елемент заблокований як слід"},"assistant_preview_end":{"message":"Закінчити попередній перегляд"},"wot_unknown_description":{"message":"Репутація цього вебсайту не визначена"},"wot_bad_description":{"message":"Цей сайт має дуже погану репутацію\\nза версією $1"},"wot_poor_description":{"message":"Цей сайт має погану репутацію\\nза версією $1"},"wot_unsatisfactory_description":{"message":"Цей сайт має незадовільну репутацію\\nза версією $1"},"wot_good_description":{"message":"Цей сайт має добру репутацію\\nза версією $1"},"wot_excellent_description":{"message":"Цей сайт має дуже відмінну репутацію\\nза версією $1"},"settings_choose_size_and_position":{"message":"Налаштуйте розмір і положення помічника AdGuard"},"settings_icon_size":{"message":"Розмір іконки:"},"settings_small":{"message":"Маленька"},"settings_big":{"message":"Велика"},"settings_position":{"message":"Позиція:"},"settings_left_top":{"message":"Зверху зліва"},"settings_right_top":{"message":"Зверху справа"},"settings_left_bottom":{"message":"Внизу зліва"},"settings_right_bottom":{"message":"Внизу справа"},"settings_cancel":{"message":"Скасувати"},"settings_save":{"message":"Зберегти зміни"}}');

/***/ }),

/***/ 4534:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"Trang Web","settings_position_save_all":"Tất cả trang web","settings_position_save_this":"Chỉ trang web này","assistant_select_element_start":"Bắt đầu","assistant_select_element_text":"Chọn một thành phần trên trang để chặn. Làm mới trang web để hủy bỏ chế độ chặn thành phần.","menu_filtration_status":{"message":"Lọc trên website này"},"menu_do_not_filter_30_sec":{"message":"Không lọc trong 30 giây"},"menu_block_ad_on_site":{"message":"Chặn quảng cáo đối với trang web này"},"menu_report_abuse":{"message":"Báo cáo trang web này"},"menu_site_report":{"message":"Báo cáo bảo mật website"},"menu_settings":{"message":"Cài đặt trợ lý"},"menu_wot_reputation_indicator":{"message":"Chỉ số danh tiếng của trang Web"},"menu_wot_reputation_confidence_level":{"message":"Mức độ đáng tin của danh tiếng"},"assistant_select_element":{"message":"Chặn thành phần"},"assistant_select_element_ext":{"message":"Chọn một thành phần trên trang để chặn"},"assistant_select_element_cancel":{"message":"Hủy bỏ"},"assistant_block_element":{"message":"Chặn thành phần"},"assistant_block_element_explain":{"message":"Điều chỉnh quy tắc chặn phần tử"},"assistant_slider_explain":{"message":"Di chuyển thanh trượt để thay đổi kích thước của khung, quy tắc mới sẽ hoạt động cho:"},"assistant_extended_settings":{"message":"Cài đặt nâng cao"},"assistant_apply_rule_to_all_sites":{"message":"Áp dụng tất cả các điều luật đối với mọi trang web"},"assistant_block_by_reference":{"message":"Chặn theo liên kết tham chiếu"},"assistant_block_similar":{"message":"Chặn tương tự"},"assistant_another_element":{"message":"Chọn một phần tử khác"},"assistant_preview":{"message":"Xem trước"},"assistant_block":{"message":"Chặn"},"assistant_settings":{"message":"Cài đặt trợ lý"},"assistant_preview_header":{"message":"Element blocking-xem trước"},"assistant_preview_header_info":{"message":"Đảm bảo rằng thành phần đó bị chặn như dự định"},"assistant_preview_end":{"message":"Thoát xem trước"},"wot_unknown_description":{"message":"Website này danh tiếng chưa được xác định bởi $1"},"wot_bad_description":{"message":"Website này có danh tiếng cực xấu dựa theo $1"},"wot_poor_description":{"message":"Website này có danh tiếng xấu dựa theo $1"},"wot_unsatisfactory_description":{"message":"Website này có danh tiếng không tốt dựa theo $1"},"wot_good_description":{"message":"Website này có danh tiếng tốt dựa theo $1"},"wot_excellent_description":{"message":"Website này có danh tiếng tuyệt vời dựa theo $1"},"settings_choose_size_and_position":{"message":"Điều chỉnh kích thước và vị trí của Trợ Lý AdGuard"},"settings_icon_size":{"message":"Kích thước biểu tượng:"},"settings_small":{"message":"Nhỏ"},"settings_big":{"message":"Lớn"},"settings_position":{"message":"Vị trí:"},"settings_left_top":{"message":"Trên cùng bên trái"},"settings_right_top":{"message":"Trên cùng bên phải"},"settings_left_bottom":{"message":"Dưới cùng bên trái"},"settings_right_bottom":{"message":"Dưới cùng bên phải"},"settings_cancel":{"message":"Hủy bỏ"},"settings_save":{"message":"Lưu các thay đổi"}}');

/***/ }),

/***/ 3476:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"網站","settings_position_save_all":"所有網站","settings_position_save_this":"此網站","assistant_select_element_start":"開始","assistant_select_element_text":"選擇網頁上的元素來阻擋。若要取消重新整理網頁即可。","menu_filtration_status":{"message":"過濾此網頁上的廣告"},"menu_do_not_filter_30_sec":{"message":"暫停過濾 30 秒"},"menu_block_ad_on_site":{"message":"封鎖此網頁上的廣告"},"menu_report_abuse":{"message":"回報此網站"},"menu_site_report":{"message":"網站安全性報告"},"menu_settings":{"message":"助手設定"},"menu_wot_reputation_indicator":{"message":"網頁名譽指標"},"menu_wot_reputation_confidence_level":{"message":"名譽可信程度"},"assistant_select_element":{"message":"封鎖網頁元素"},"assistant_select_element_ext":{"message":"選取網頁上的元素來封鎖"},"assistant_select_element_cancel":{"message":"取消"},"assistant_block_element":{"message":"阻擋網頁元素"},"assistant_block_element_explain":{"message":"調整網頁元素阻擋條件"},"assistant_slider_explain":{"message":"移動滑桿可以更改阻擋元素範圍："},"assistant_extended_settings":{"message":"進階設定"},"assistant_apply_rule_to_all_sites":{"message":"套用至所有網站"},"assistant_block_by_reference":{"message":"通過參考連結封鎖"},"assistant_block_similar":{"message":"封鎖相關或類似的"},"assistant_another_element":{"message":"選取其他網頁元素"},"assistant_preview":{"message":"預覽"},"assistant_block":{"message":"封鎖"},"assistant_settings":{"message":"助手設定"},"assistant_preview_header":{"message":"封鎖網頁元祖 - 預覽"},"assistant_preview_header_info":{"message":"確保網頁元素已被正確封鎖"},"assistant_preview_end":{"message":"關閉預覽"},"wot_unknown_description":{"message":"此網站名譽尚未被 $1 評定"},"wot_bad_description":{"message":"根據 $1\\n此網站名譽非常糟糕"},"wot_poor_description":{"message":"根據 $1\\n此網站擁有不良的名譽"},"wot_unsatisfactory_description":{"message":"根據 $1\\n此網站擁有不好的名譽"},"wot_good_description":{"message":"根據 $1\\n此網站擁有良好的名譽"},"wot_excellent_description":{"message":"根據 $1\\n此網站擁有非常優秀的名譽"},"settings_choose_size_and_position":{"message":"調整 AdGuard 小助手大小與位置"},"settings_icon_size":{"message":"圖示大小："},"settings_small":{"message":"小"},"settings_big":{"message":"大"},"settings_position":{"message":"位置："},"settings_left_top":{"message":"左上角"},"settings_right_top":{"message":"右上角"},"settings_left_bottom":{"message":"左下角"},"settings_right_bottom":{"message":"右下角"},"settings_cancel":{"message":"取消"},"settings_save":{"message":"儲存變更"}}');

/***/ }),

/***/ 5480:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"網站","settings_position_save_all":"所有的網站","settings_position_save_this":"此網站","assistant_select_element_start":"開始","assistant_select_element_text":"選擇於該頁面上之元件以封鎖。重新整理該頁面以取消元件封鎖模式。","menu_filtration_status":{"message":"對此網站之過濾"},"menu_do_not_filter_30_sec":{"message":"計 30 秒不過濾"},"menu_block_ad_on_site":{"message":"封鎖於此網站上之廣告"},"menu_report_abuse":{"message":"報告該網站"},"menu_site_report":{"message":"網站安全性報告"},"menu_settings":{"message":"助理設定"},"menu_wot_reputation_indicator":{"message":"網站信譽指標"},"menu_wot_reputation_confidence_level":{"message":"信譽信賴等級"},"assistant_select_element":{"message":"元件封鎖"},"assistant_select_element_ext":{"message":"選擇於該頁面上之元件以封鎖"},"assistant_select_element_cancel":{"message":"取消"},"assistant_block_element":{"message":"元件封鎖"},"assistant_block_element_explain":{"message":"調整元件封鎖規則"},"assistant_slider_explain":{"message":"移動該滑標以更改新的規則將作用於的框架之尺寸："},"assistant_extended_settings":{"message":"進階設定"},"assistant_apply_rule_to_all_sites":{"message":"對所有的網站套用該規則"},"assistant_block_by_reference":{"message":"按照參考連結封鎖"},"assistant_block_similar":{"message":"封鎖相似之物"},"assistant_another_element":{"message":"選擇不同的元件"},"assistant_preview":{"message":"預覽"},"assistant_block":{"message":"封鎖"},"assistant_settings":{"message":"助理設定"},"assistant_preview_header":{"message":"元件封鎖 - 預覽"},"assistant_preview_header_info":{"message":"確定元件如預期的被封鎖"},"assistant_preview_end":{"message":"離開預覽"},"wot_unknown_description":{"message":"此網站的信譽未被 $1 界定"},"wot_bad_description":{"message":"根據 $1，\\n此網站有非常壞的信譽"},"wot_poor_description":{"message":"根據 $1，\\n此網站有壞的信譽"},"wot_unsatisfactory_description":{"message":"根據 $1，\\n此網站有不好的信譽"},"wot_good_description":{"message":"根據 $1，\\n此網站有好的信譽"},"wot_excellent_description":{"message":"根據 $1，\\n此網站有極好的信譽"},"settings_choose_size_and_position":{"message":"調整 AdGuard 助理尺寸和位置"},"settings_icon_size":{"message":"圖示尺寸："},"settings_small":{"message":"小的"},"settings_big":{"message":"大的"},"settings_position":{"message":"位置："},"settings_left_top":{"message":"左上角"},"settings_right_top":{"message":"右上角"},"settings_left_bottom":{"message":"左下角"},"settings_right_bottom":{"message":"右下角"},"settings_cancel":{"message":"取消"},"settings_save":{"message":"儲存更改"}}');

/***/ }),

/***/ 8868:
/***/ ((module) => {

"use strict";
module.exports = JSON.parse('{"settings_position_save":"网站","settings_position_save_all":"所有网站","settings_position_save_this":"此网站","assistant_select_element_start":"开始","assistant_select_element_text":"选择要拦截的网页元素。要取消元素拦截模式，请刷新网页。","menu_filtration_status":{"message":"对此网站进行过滤"},"menu_do_not_filter_30_sec":{"message":"暂停过滤 30 秒"},"menu_block_ad_on_site":{"message":"拦截此网站上的广告"},"menu_report_abuse":{"message":"报告此网站"},"menu_site_report":{"message":"网站安全报告"},"menu_settings":{"message":"助手设置"},"menu_wot_reputation_indicator":{"message":"网站声誉指标"},"menu_wot_reputation_confidence_level":{"message":"声望置信度"},"assistant_select_element":{"message":"拦截元素"},"assistant_select_element_ext":{"message":"选择此页面上需要拦截的元素"},"assistant_select_element_cancel":{"message":"取消"},"assistant_block_element":{"message":"拦截元素"},"assistant_block_element_explain":{"message":"调整元素拦截规则"},"assistant_slider_explain":{"message":"使用滑块改变要由新规则将要拦截的框架大小："},"assistant_extended_settings":{"message":"高级设置"},"assistant_apply_rule_to_all_sites":{"message":"应用规则至所有网站"},"assistant_block_by_reference":{"message":"通过参考链接进行拦截"},"assistant_block_similar":{"message":"拦截类似元素"},"assistant_another_element":{"message":"选择其它元素"},"assistant_preview":{"message":"预览"},"assistant_block":{"message":"拦截"},"assistant_settings":{"message":"AdGuard 助手设置"},"assistant_preview_header":{"message":"元素拦截 - 预览"},"assistant_preview_header_info":{"message":"请确保元素拦截方式符合预期"},"assistant_preview_end":{"message":"退出预览"},"wot_unknown_description":{"message":"声望尚未定义"},"wot_bad_description":{"message":"此网站在以下数据库中声望极低"},"wot_poor_description":{"message":"此网站在以下数据库中声望低下 "},"wot_unsatisfactory_description":{"message":"此网站在以下数据库中声望不佳 "},"wot_good_description":{"message":"此网站在以下数据库中声望良好 "},"wot_excellent_description":{"message":"此网站在以下数据库中声望极佳 "},"settings_choose_size_and_position":{"message":"调整 AdGuard 助手的大小与位置"},"settings_icon_size":{"message":"图标大小："},"settings_small":{"message":"小"},"settings_big":{"message":"大"},"settings_position":{"message":"位置："},"settings_left_top":{"message":"左上角"},"settings_right_top":{"message":"右上角"},"settings_left_bottom":{"message":"左下角"},"settings_right_bottom":{"message":"右下角"},"settings_cancel":{"message":"取消"},"settings_save":{"message":"保存更改"}}');

/***/ })

/******/ 	});
/************************************************************************/
/******/ 	// The module cache
/******/ 	var __webpack_module_cache__ = {};
/******/ 	
/******/ 	// The require function
/******/ 	function __nested_webpack_require_447230__(moduleId) {
/******/ 		// Check if module is in cache
/******/ 		var cachedModule = __webpack_module_cache__[moduleId];
/******/ 		if (cachedModule !== undefined) {
/******/ 			return cachedModule.exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = __webpack_module_cache__[moduleId] = {
/******/ 			id: moduleId,
/******/ 			// no module.loaded needed
/******/ 			exports: {}
/******/ 		};
/******/ 	
/******/ 		// Execute the module function
/******/ 		__webpack_modules__[moduleId](module, module.exports, __nested_webpack_require_447230__);
/******/ 	
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/ 	
/************************************************************************/
/******/ 	/* webpack/runtime/compat get default export */
/******/ 	(() => {
/******/ 		// getDefaultExport function for compatibility with non-harmony modules
/******/ 		__nested_webpack_require_447230__.n = (module) => {
/******/ 			var getter = module && module.__esModule ?
/******/ 				() => (module['default']) :
/******/ 				() => (module);
/******/ 			__nested_webpack_require_447230__.d(getter, { a: getter });
/******/ 			return getter;
/******/ 		};
/******/ 	})();
/******/ 	
/******/ 	/* webpack/runtime/define property getters */
/******/ 	(() => {
/******/ 		// define getter functions for harmony exports
/******/ 		__nested_webpack_require_447230__.d = (exports, definition) => {
/******/ 			for(var key in definition) {
/******/ 				if(__nested_webpack_require_447230__.o(definition, key) && !__nested_webpack_require_447230__.o(exports, key)) {
/******/ 					Object.defineProperty(exports, key, { enumerable: true, get: definition[key] });
/******/ 				}
/******/ 			}
/******/ 		};
/******/ 	})();
/******/ 	
/******/ 	/* webpack/runtime/hasOwnProperty shorthand */
/******/ 	(() => {
/******/ 		__nested_webpack_require_447230__.o = (obj, prop) => (Object.prototype.hasOwnProperty.call(obj, prop))
/******/ 	})();
/******/ 	
/******/ 	/* webpack/runtime/make namespace object */
/******/ 	(() => {
/******/ 		// define __esModule on exports
/******/ 		__nested_webpack_require_447230__.r = (exports) => {
/******/ 			if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 				Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 			}
/******/ 			Object.defineProperty(exports, '__esModule', { value: true });
/******/ 		};
/******/ 	})();
/******/ 	
/************************************************************************/
var __nested_webpack_exports__ = {};
// This entry need to be wrapped in an IIFE because it need to be in strict mode.
(() => {
"use strict";
// ESM COMPAT FLAG
__nested_webpack_require_447230__.r(__nested_webpack_exports__);

// EXPORTS
__nested_webpack_require_447230__.d(__nested_webpack_exports__, {
  "adguardAssistant": () => (/* binding */ adguardAssistant)
});

;// CONCATENATED MODULE: ./src/ioc.js
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

var getArguments = function getArguments(func) {
  // This regex is from require.js
  var FN_ARGS = /^function\s*[^(]*\(\s*([^)]*)\)/m;
  var args = func.toString().match(FN_ARGS)[1].split(',');

  if (args[0] === '') {
    return [];
  }

  return args;
};

var Ioc = /*#__PURE__*/function () {
  function Ioc() {
    _classCallCheck(this, Ioc);

    this.dependencies = {};
  }

  _createClass(Ioc, [{
    key: "resolveDependencies",
    value: function resolveDependencies(func) {
      var args = getArguments(func);
      var resolved = [];

      for (var i = 0; i < args.length; i += 1) {
        var depName = args[i].trim();
        var dep = this.dependencies[depName];

        if (!dep) {
          throw new Error("Can't find dependency: ".concat(depName));
        }

        resolved.push(this.dependencies[depName]);
      }

      return resolved;
    }
  }, {
    key: "register",
    value: function register(qualifier, obj) {
      this.dependencies[qualifier] = obj;
    }
  }, {
    key: "get",
    value: function get(func) {
      if (typeof func === 'string') {
        var resolved = this.dependencies[func];

        if (!resolved) {
          throw new Error("Can't resolve ".concat(func));
        }

        return resolved;
      }

      var resolvedDependencies = this.resolveDependencies(func);

      function FuncWrapper() {
        return func.apply(func, resolvedDependencies);
      }

      FuncWrapper.prototype = func.prototype;
      return new FuncWrapper();
    }
  }]);

  return Ioc;
}();

var ioc = new Ioc();
/* harmony default export */ const src_ioc = (ioc);
;// CONCATENATED MODULE: ./src/protectedApi.js
/**
 * TODO: rewrite to class
 * TODO: add relevant jsdoc
 * Protected API
 * @constructor
 */
function ProtectedApi() {
  var win = window;
  var functionPType = Function.prototype;
  var originalGetOwnPropertyDescriptor = Object.getOwnPropertyDescriptor;
  var _document = document,
      documentMode = _document.documentMode,
      documentElement = _document.documentElement;
  var originalAppendChild = document.appendChild;
  var originalJSON = win.JSON;
  var functionApply = functionPType.apply;
  var functionBind = functionPType.bind;
  var COMPLETE = 'complete';
  var originalAttachShadow = documentElement.attachShadow; // eslint-disable-next-line func-names

  var apply = typeof Reflect !== 'undefined' ? Reflect.apply : function (target, _this, _arguments) {
    return functionApply.call(target, _this, _arguments);
  };

  var noop = function noop() {};

  var methodCallerFactory = function methodCallerFactory(owner, prop) {
    if (!owner) {
      return noop;
    } // Keeps reference to the method, so that it is unaffected
    // when `owner` is mutated.


    var method = owner[prop]; // eslint-disable-next-line consistent-return, func-names

    return function () {
      if (method) {
        // eslint-disable-next-line prefer-rest-params
        return apply(method, owner, arguments);
      }
    };
  };

  var getReadyState = function getReadyState() {
    // We need to add this hook for tests, because a phantomjs
    // doesn't work with Object.getOwnPropertyDescriptor correctly
    if (typeof originalGetOwnPropertyDescriptor(Document.prototype, 'readyState') === 'undefined') {
      return COMPLETE;
    }

    var readyStateGetter = originalGetOwnPropertyDescriptor(Document.prototype, 'readyState').get;
    return apply(readyStateGetter, document, []);
  };

  var addListenerToWindow = methodCallerFactory(win, 'addEventListener');
  var removeListenerFromWindow = methodCallerFactory(win, 'removeEventListener');
  var querySelector = methodCallerFactory(document, 'querySelector');

  var appendChildToElement = function appendChildToElement(elem, child) {
    apply(originalAppendChild, elem, [child]);
  };
  /**
   * Creating element instead `document.createElement`
   * to prevented a custom `document.createElement`
   * see: https://github.com/AdguardTeam/AdguardAssistant/issues/165
   */


  var createElement = function createElement(markup) {
    var doc = document.implementation.createHTMLDocument('');

    if (markup && markup[0] !== '<') {
      // eslint-disable-next-line no-param-reassign
      markup = "<".concat(markup, "></").concat(markup, ">");
    }

    doc.body.innerHTML = markup;
    return doc.body.firstChild;
  };

  var json = {
    parse: methodCallerFactory(originalJSON, 'parse'),
    stringify: methodCallerFactory(originalJSON, 'stringify')
  };
  /**
   * Creating style element
   * @param {String} styles css styles in string
   * @param {String} nonce  attribute for content-security-policy
   * @param {String} id to prevent duplicates, can be empty
   * @return {Object|false} style tag with styles or false
   * if the styles with transferred id is exist
   */

  var createStylesElement = function createStylesElement(styles, nonce, id) {
    if (id && querySelector("#".concat(id))) {
      return false;
    }

    var tagNode = createElement('style');
    tagNode.setAttribute('type', 'text/css');

    if (id) {
      tagNode.setAttribute('id', id);
    }

    tagNode.setAttribute('nonce', nonce);

    if (tagNode.styleSheet) {
      tagNode.styleSheet.cssText = styles;
    } else {
      appendChildToElement(tagNode, document.createTextNode(styles));
    }

    return tagNode;
  };
  /**
   * Check browser shadow dom support.
   * Safari crashes after adding style tag in attachShadow so exclude it
   * see: https://github.com/AdguardTeam/AdguardBrowserExtension/issues/974
   */


  var checkShadowDomSupport = function checkShadowDomSupport() {
    var SAFARI_UA_REGEX = /^((?!chrome|android).)*safari/i;
    var isSafari = window.safari !== undefined || SAFARI_UA_REGEX.test(navigator.userAgent);
    return typeof originalAttachShadow !== 'undefined' && !isSafari;
  };

  return {
    functionBind: functionBind,
    addListenerToWindow: addListenerToWindow,
    removeListenerFromWindow: removeListenerFromWindow,
    getReadyState: getReadyState,
    documentMode: documentMode,
    appendChildToElement: appendChildToElement,
    createElement: createElement,
    json: json,
    createStylesElement: createStylesElement,
    checkShadowDomSupport: checkShadowDomSupport
  };
}

var protectedApi = new ProtectedApi();
/* harmony default export */ const src_protectedApi = (protectedApi);
;// CONCATENATED MODULE: ./src/wot.js
/**
 * Object that manages wot data
 * @returns {{
 * registerWotEventHandler: Function,
 * getWotData: Function,
 * getWotScorecardUrl: Function,
 * WOT_URL: string
 * }}
 * @constructor
 */
function Wot() {
  var wotUrlScorecardTemplate = 'https://link.adtidy.org/forward.html?action=wot_scorecard&from=main_menu&app=assistant&domain=';
  var WOT_URL = 'https://link.adtidy.org/forward.html?action=wot&from=main_menu&app=assistant';
  var wotData = null;

  var registerWotEventHandler = function registerWotEventHandler() {
    var wotDataCb = function wotDataCb(data) {
      wotData = data;
    };

    if (window.WotData) {
      wotData = window.WotData;
    } else {
      window.WotData = wotDataCb;
    }
  };

  var getWotData = function getWotData() {
    return wotData;
  };

  var getWotScorecardUrl = function getWotScorecardUrl(url) {
    return "".concat(wotUrlScorecardTemplate).concat(url);
  };

  return {
    registerWotEventHandler: registerWotEventHandler,
    getWotData: getWotData,
    getWotScorecardUrl: getWotScorecardUrl,
    WOT_URL: WOT_URL
  };
}

var wot = new Wot();
/* harmony default export */ const src_wot = (wot);
;// CONCATENATED MODULE: ./src/utils/common-utils.js
var cropDomain = function cropDomain(domain) {
  return domain.replace('www.', '').replace(/:\d+/, '');
};
/**
 * Force clear the page cache
 * see: https://stackoverflow.com/questions/10719505/force-a-reload-of-page-in-chrome-using-javascript-no-cache/27058362#27058362
 * @param callback
 */

var bypassCache = function bypassCache(callback) {
  var xhr = new XMLHttpRequest();
  xhr.open('GET', window.location.href, true);
  xhr.setRequestHeader('Pragma', 'no-cache');
  xhr.setRequestHeader('Expires', '-1');
  xhr.setRequestHeader('Cache-Control', 'no-cache');

  xhr.onreadystatechange = function () {
    if (xhr.readyState === 4 && callback) {
      callback();
    }
  };

  xhr.send();
};
/**
 * Reload page after bypassing cache
 */

var reloadPageBypassCache = function reloadPageBypassCache() {
  bypassCache(function () {
    window.location.reload(true);
  });
};
/**
 * Multiple event handler helper.
 * @param {Object}  elements  element or nodeList.
 * @param {String}  events    multiple events divided by space.
 * @param {Function}  eventHandler   event handler.
 * @param {Boolean}  useCapture   capture.
 * @return {Function} add/remove.
 */

var events = {
  add: function add(elements, es, eventHandler, useCapture) {
    this.addRemoveEvents(true, elements, es, eventHandler, useCapture);
  },
  remove: function remove(elements, es, eventHandler, useCapture) {
    this.addRemoveEvents(false, elements, es, eventHandler, useCapture);
  },
  // eslint-disable-next-line consistent-return
  addRemoveEvents: function addRemoveEvents(add, elements, es, eventHandler, useCapture) {
    if (!elements || !es || !eventHandler) {
      return false;
    }

    var eventList = es.split(' ');

    if (!eventList || eventList.length < 1) {
      return false;
    }

    if (!elements.length) {
      // eslint-disable-next-line no-param-reassign
      elements = new Array(elements);
    }

    for (var el = 0; el < elements.length; el += 1) {
      for (var evt = 0; evt < eventList.length; evt += 1) {
        if (!eventList[evt] || !eventList[evt].length) {
          // eslint-disable-next-line no-continue
          continue;
        }

        if (add) {
          elements[el].addEventListener(eventList[evt], eventHandler, !!useCapture);
        } else {
          elements[el].removeEventListener(eventList[evt], eventHandler, !!useCapture);
        }
      }
    }
  }
};
/**
 * Common utils
 * @type {{
 * cropDomain: Function,
 * bypassCache: Function,
 * reloadPageBypassCache: Function,
 * events: Object
 * }}
 */

var CommonUtils = {
  cropDomain: cropDomain,
  bypassCache: bypassCache,
  reloadPageBypassCache: reloadPageBypassCache,
  events: events
};
/* harmony default export */ const common_utils = ((/* unused pure expression or super */ null && (0)));
;// CONCATENATED MODULE: ./src/log.js
function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

/* global DEBUG */

/**
 * Simple logger with log levels
 * @returns {{
 *  warn: warn,
 *  info: info,
 *  debug: debug,
 *  error: error
 * }}
 * @constructor
 */
function Log() {
  var currentLevel =   false ? 0 : 'ERROR';
  var LogLevels = {
    ERROR: 1,
    WARN: 2,
    INFO: 3,
    DEBUG: 4
  };

  var print = function print(level, method, args) {
    // check log level
    if (LogLevels[currentLevel] < LogLevels[level]) {
      return;
    }

    if (!args || args.length === 0 || !args[0]) {
      return;
    }

    var formatted;

    if (_typeof(args[0]) === 'object') {
      // eslint-disable-next-line prefer-destructuring
      formatted = args[0];
    } else {
      var str = "".concat(args[0]); // eslint-disable-next-line no-param-reassign

      args = Array.prototype.slice.call(args, 1);
      formatted = str.replace(/{(\d+)}/g, function (match, number) {
        return typeof args[number] !== 'undefined' ? args[number] : match;
      });

      if (LogLevels[level] >= LogLevels[currentLevel]) {
        var now = new Date();
        formatted = "".concat(now.toISOString(), ": ").concat(formatted);
      }
    } // eslint-disable-next-line no-console


    console[method](formatted);
  };

  var debug = function debug() {
    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    print('DEBUG', 'log', args);
  };

  var info = function info() {
    for (var _len2 = arguments.length, args = new Array(_len2), _key2 = 0; _key2 < _len2; _key2++) {
      args[_key2] = arguments[_key2];
    }

    print('INFO', 'info', args);
  };

  var warn = function warn() {
    for (var _len3 = arguments.length, args = new Array(_len3), _key3 = 0; _key3 < _len3; _key3++) {
      args[_key3] = arguments[_key3];
    }

    print('WARN', 'info', args);
  };

  var error = function error() {
    for (var _len4 = arguments.length, args = new Array(_len4), _key4 = 0; _key4 < _len4; _key4++) {
      args[_key4] = arguments[_key4];
    }

    print('ERROR', 'error', args);
  };

  return {
    debug: debug,
    info: info,
    warn: warn,
    error: error
  };
}

var log = new Log();
/* harmony default export */ const src_log = (log);
;// CONCATENATED MODULE: ./src/upgradeHelper.js
function upgradeHelper_classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function upgradeHelper_defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function upgradeHelper_createClass(Constructor, protoProps, staticProps) { if (protoProps) upgradeHelper_defineProperties(Constructor.prototype, protoProps); if (staticProps) upgradeHelper_defineProperties(Constructor, staticProps); return Constructor; }



/* eslint-disable no-param-reassign */

/**
 * Helper for backward compatibility
 * @returns {{}}
 * @constructor
 */

var UpgradeHelper = /*#__PURE__*/function () {
  function UpgradeHelper() {
    upgradeHelper_classCallCheck(this, UpgradeHelper);

    this.Constants = {
      BUTTON_POSITION_ITEM_NAME: '__adbpos'
    };
  }

  upgradeHelper_createClass(UpgradeHelper, [{
    key: "getButtonPositionData",
    value: function getButtonPositionData() {
      try {
        var userPosition = localStorage.getItem(this.Constants.BUTTON_POSITION_ITEM_NAME);

        if (userPosition) {
          return src_protectedApi.json.parse(userPosition);
        }

        return undefined;
      } catch (ex) {
        src_log.error(ex);
        return undefined;
      }
    }
  }, {
    key: "removeUserPositionForButton",
    value: function removeUserPositionForButton() {
      try {
        localStorage.removeItem(this.Constants.BUTTON_POSITION_ITEM_NAME);
      } catch (ex) {
        src_log.error(ex);
      }
    } // eslint-disable-next-line class-methods-use-this

  }, {
    key: "upgradeGmStorage",
    value: function upgradeGmStorage(settings, version) {
      settings.personal = {};
      settings.scriptVersion = version;
      settings.personalConfig = true;
      return settings;
    } // Helper for assistant update from 4.1 to 4.2

  }, {
    key: "upgradeLocalStorage",
    value: function upgradeLocalStorage(settings, sitename) {
      var position = this.getButtonPositionData();

      if (position) {
        if (!settings.personal[sitename]) {
          settings.personal[sitename] = {};
        }

        settings.personal[sitename].position = position;
        settings.personal[sitename].largeIcon = settings.largeIcon;
      }

      this.removeUserPositionForButton();
      return settings;
    }
  }]);

  return UpgradeHelper;
}();

var upgradeHelper = new UpgradeHelper();
/* harmony default export */ const src_upgradeHelper = (upgradeHelper);
;// CONCATENATED MODULE: ./src/gm.js
/* harmony default export */ const gm = ({});
;// CONCATENATED MODULE: ./src/settings.js
function settings_typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { settings_typeof = function _typeof(obj) { return typeof obj; }; } else { settings_typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return settings_typeof(obj); }






/**
 * Object that manages user settings.
 * @returns {{
 * Constants: {
 *  MINIMUM_IE_SUPPORTED_VERSION: number,
 *  MINIMUM_VISIBLE_HEIGHT_TO_SHOW_BUTTON: number,
 *  BUTTON_POSITION_ITEM_NAME: string,
 *  IFRAME_ID: string
 * },
 * MenuItemsNames: {
 *  DetailedMenu: string,
 *  SelectorMenu: string,
 *  SliderMenu: string,
 *  BlockPreview: string,
 *  SettingsMenu: string
 * },
 * getSettings: getSettings,
 * loadSettings: loadSettings,
 * getWotData: getWotData,
 * setWotData: setWotData,
 * saveSettings: saveSettings,
 * getUserPositionForButton: getUserPositionForButton,
 * removeUserPositionForButton: removeUserPositionForButton,
 * selectedElement: *,
 * setAdguardSettings: setAdguardSettings,
 * getAdguardSettings: getAdguardSettings
 * }}
 * @constructor
 */

function Settings() {
  var Constants = {
    MINIMUM_IE_SUPPORTED_VERSION: 10,
    MINIMUM_VISIBLE_HEIGHT_TO_SHOW_BUTTON: 250,
    IFRAME_ID: 'adguard-assistant-dialog',
    REPORT_URL: 'https://link.adtidy.org/forward.html?action=site_report_page&domain={0}&from=main_menu&app=assistant'
  };
  var MenuItemsNames = {
    DetailedMenu: 'mainMenu.html',
    SelectorMenu: 'selectorMenu.html',
    SliderMenu: 'sliderMenu.html',
    BlockPreview: 'blockPreview.html',
    SettingsMenu: 'settingsMenu.html'
  };
  /**
   * Config data stored in GM storage
   * @typedef {Object} DefaultConfig
   * @property {boolean} buttonPositionTop - Static button position from top.
   * @property {boolean} buttonPositionLeft - Static button position from left.
   * @property {boolean} smallIcon - Button size. true - small, false - large.
   * @property {boolean} personalConfig - Is the settings save for all
   * sites or for each site individually.
   * @property {number} scriptVersion - Version of scheme. 2 is set since assistant version 4.2.
   * @property {object} personal - Object config that may includes the same properties,
   * except `scriptVersion`, but for each site individually.
   */

  var DefaultConfig = {
    buttonPositionTop: false,
    buttonPositionLeft: false,
    smallIcon: false,
    personalConfig: true,
    scriptVersion: 2,
    personal: {}
  };
  var wotData = null;
  var Config = null;
  var adguardSettings = null;
  var SITENAME = window.location.host;

  var getSettings = function getSettings() {
    return gm.getValue('settings').then(function (config) {
      try {
        return config && src_protectedApi.json.parse(config);
      } catch (ex) {
        src_log.error(ex);
        return null;
      }
    });
  };

  var validateSettings = function validateSettings(settings) {
    if (!settings) {
      src_log.error('Invalid settings object');
      return false;
    } // eslint-disable-next-line no-restricted-syntax, prefer-const


    for (var prop in settings) {
      // eslint-disable-next-line no-prototype-builtins
      if (!settings.hasOwnProperty(prop)) {
        // eslint-disable-next-line no-continue
        continue;
      }

      var property = DefaultConfig[prop];

      if (property && settings_typeof(property) !== settings_typeof(settings[prop])) {
        src_log.error('Invalid settings object');
        return false;
      }
    }

    if (settings.scriptVersion > DefaultConfig.scriptVersion) {
      src_log.error('Invalid settings object');
      return false;
    }

    if (settings.scriptVersion < DefaultConfig.scriptVersion) {
      src_log.info('Settings object is outdated. Updating...'); // eslint-disable-next-line no-param-reassign

      settings = src_upgradeHelper.upgradeGmStorage(settings, DefaultConfig.scriptVersion);
    } // save to gm store position data from localStorage
    // eslint-disable-next-line no-param-reassign


    settings = src_upgradeHelper.upgradeLocalStorage(settings, SITENAME);
    return settings;
  };

  var loadSettings = function loadSettings(showButton) {
    src_log.debug('Trying to get settings'); // getting config from gm storage

    getSettings().then(function (config) {
      // check and validate config data for prevent errors and backward compatibility
      var checkedConfig = config && validateSettings(config);

      if (checkedConfig) {
        // saving existing settings to Config variable in the gm storage
        Config = checkedConfig;
        src_log.debug('Settings parsed successfully');
      } else {
        // use default settings without saving
        Config = DefaultConfig;
        src_log.debug('No settings found');
      }

      showButton();
    });
  };

  var saveSettings = function saveSettings(config) {
    if (config) {
      Config = config;
    }

    src_log.debug('Update settings...');
    src_log.debug(Config);
    gm.setValue('settings', Config);
    bypassCache();
  };

  var getWotData = wotData;

  var setWotData = function setWotData(data) {
    wotData = data;
  };

  var setAdguardSettings = function setAdguardSettings(settings) {
    if (typeof settings === 'undefined') {
      src_log.info('No Adguard API Found');
      return;
    }

    adguardSettings = settings;
  };

  var getAdguardSettings = function getAdguardSettings() {
    return adguardSettings;
  };

  var getUserPositionForButton = function getUserPositionForButton() {
    var userPosition;

    if (Config.personalConfig) {
      if (Config.personal && Config.personal[SITENAME]) {
        userPosition = Config.personal[SITENAME].position;
      }
    } else {
      userPosition = Config.position;
    }

    if (userPosition) {
      return userPosition;
    }

    return null;
  };

  var setUserPositionForButton = function setUserPositionForButton(position) {
    if (Config.personalConfig) {
      if (!Config.personal[SITENAME]) {
        Config.personal[SITENAME] = {};
      }

      Config.personal[SITENAME].position = position;
    } else {
      Config.position = position;
    }

    saveSettings(Config);
  };

  var setIconSize = function setIconSize(smallIcon) {
    if (Config.personalConfig) {
      Config.personal[SITENAME].smallIcon = smallIcon;
    } else {
      Config.smallIcon = smallIcon;
    }
  };

  var getIconSize = function getIconSize() {
    if (Config.personalConfig && Config.personal && Config.personal[SITENAME]) {
      return Config.personal[SITENAME].smallIcon;
    }

    return Config.smallIcon;
  };
  /**
   * Set the parameters to which corner of the browser
   * window the button position is placed by option (not drag)
   */


  var setButtonSide = function setButtonSide(buttonSides) {
    if (Config.personalConfig) {
      delete Config.personal[SITENAME].position;
      Config.personal[SITENAME].buttonPositionTop = buttonSides.top;
      Config.personal[SITENAME].buttonPositionLeft = buttonSides.left;
    } else {
      delete Config.position;
      Config.buttonPositionTop = buttonSides.top;
      Config.buttonPositionLeft = buttonSides.left;
    }
  };
  /**
   * Save a setting that specifies how to save button settings: for all sites or only on this
   */


  var setPersonalParam = function setPersonalParam(personalConfig) {
    Config.personalConfig = personalConfig;

    if (Config.personalConfig && !Config.personal) {
      Config.personal = {};
    }

    if (Config.personalConfig && !Config.personal[SITENAME]) {
      Config.personal[SITENAME] = {};
      Config.personal[SITENAME].position = Config.position;
    }

    if (!Config.personalConfig && Config.personal) {
      Config.position = Config.personal[SITENAME] && Config.personal[SITENAME].position;
      delete Config.personal;
    }
  };
  /**
   * Get config that specifies how to save button settings: for all sites or only on this
   */


  var getPersonalConfig = function getPersonalConfig() {
    return Config.personalConfig;
  };
  /**
   * Get the option to which corner of the browser window the button position is placed
   * @return {Object}
   */


  var getButtonSide = function getButtonSide() {
    var config = Config;

    if (config.personalConfig && config.personal && config.personal[SITENAME]) {
      return {
        top: config.personal[SITENAME].buttonPositionTop,
        left: config.personal[SITENAME].buttonPositionLeft
      };
    }

    return {
      top: config.buttonPositionTop,
      left: config.buttonPositionLeft
    };
  };

  return {
    Constants: Constants,
    MenuItemsNames: MenuItemsNames,
    getSettings: getSettings,
    loadSettings: loadSettings,
    getWotData: getWotData,
    setWotData: setWotData,
    saveSettings: saveSettings,
    getUserPositionForButton: getUserPositionForButton,
    getButtonSide: getButtonSide,
    setIconSize: setIconSize,
    setUserPositionForButton: setUserPositionForButton,
    setAdguardSettings: setAdguardSettings,
    setPersonalParam: setPersonalParam,
    setButtonSide: setButtonSide,
    getAdguardSettings: getAdguardSettings,
    getIconSize: getIconSize,
    getPersonalConfig: getPersonalConfig
  };
}

var settings = new Settings();
/* harmony default export */ const src_settings = (settings);
// EXTERNAL MODULE: ./src/templates/button.html
var templates_button = __nested_webpack_require_447230__(6696);
var button_default = /*#__PURE__*/__nested_webpack_require_447230__.n(templates_button);
// EXTERNAL MODULE: ./src/templates/mainMenu.html
var mainMenu = __nested_webpack_require_447230__(3317);
var mainMenu_default = /*#__PURE__*/__nested_webpack_require_447230__.n(mainMenu);
// EXTERNAL MODULE: ./src/templates/selectorMenu.html
var selectorMenu = __nested_webpack_require_447230__(8514);
var selectorMenu_default = /*#__PURE__*/__nested_webpack_require_447230__.n(selectorMenu);
// EXTERNAL MODULE: ./src/templates/settingsMenu.html
var settingsMenu = __nested_webpack_require_447230__(4693);
var settingsMenu_default = /*#__PURE__*/__nested_webpack_require_447230__.n(settingsMenu);
// EXTERNAL MODULE: ./src/templates/sliderMenu.html
var sliderMenu = __nested_webpack_require_447230__(7726);
var sliderMenu_default = /*#__PURE__*/__nested_webpack_require_447230__.n(sliderMenu);
// EXTERNAL MODULE: ./src/templates/blockPreview.html
var blockPreview = __nested_webpack_require_447230__(5688);
var blockPreview_default = /*#__PURE__*/__nested_webpack_require_447230__.n(blockPreview);
// EXTERNAL MODULE: ./src/templates/mobilePopup.html
var mobilePopup = __nested_webpack_require_447230__(2115);
var mobilePopup_default = /*#__PURE__*/__nested_webpack_require_447230__.n(mobilePopup);
// EXTERNAL MODULE: ./src/templates/mobileMenu.html
var mobileMenu = __nested_webpack_require_447230__(4825);
var mobileMenu_default = /*#__PURE__*/__nested_webpack_require_447230__.n(mobileMenu);
// EXTERNAL MODULE: ./src/styles/base/base-common.less
var base_common = __nested_webpack_require_447230__(1403);
var base_common_default = /*#__PURE__*/__nested_webpack_require_447230__.n(base_common);
// EXTERNAL MODULE: ./src/styles/button.less
var styles_button = __nested_webpack_require_447230__(5487);
var styles_button_default = /*#__PURE__*/__nested_webpack_require_447230__.n(styles_button);
// EXTERNAL MODULE: ./src/styles/menu.less
var menu = __nested_webpack_require_447230__(3228);
var menu_default = /*#__PURE__*/__nested_webpack_require_447230__.n(menu);
// EXTERNAL MODULE: ./src/styles/selector.less
var selector = __nested_webpack_require_447230__(5317);
var selector_default = /*#__PURE__*/__nested_webpack_require_447230__.n(selector);
// EXTERNAL MODULE: ./src/styles/mobile-style.less
var mobile_style = __nested_webpack_require_447230__(1953);
var mobile_style_default = /*#__PURE__*/__nested_webpack_require_447230__.n(mobile_style);
;// CONCATENATED MODULE: ./src/inline-resources.js













var CSS = {
  common: (base_common_default()),
  button: (styles_button_default()),
  iframe: (menu_default()),
  selector: (selector_default()),
  mobile: (mobile_style_default())
};
var HTML = {
  button: (button_default()),
  detailed_menu: (mainMenu_default()),
  selector_menu: (selectorMenu_default()),
  settings_menu: (settingsMenu_default()),
  slider_menu: (sliderMenu_default()),
  preview: (blockPreview_default()),
  popup: (mobilePopup_default()),
  mobile_menu: (mobileMenu_default())
};
;// CONCATENATED MODULE: ./src/event.js
/**
 * Custom event
 * @returns {{attach: attach, notify: notify}}
 * @constructor
 */
function CustomEvent() {
  // jshint ignore:line
  var listeners = [];

  var attach = function attach(listener) {
    listeners.push(listener);
  };

  var notify = function notify(args) {
    for (var i = 0; i < listeners.length; i += 1) {
      listeners[i](args);
    }
  };

  return {
    attach: attach,
    notify: notify
  };
}
;// CONCATENATED MODULE: ./src/utils/dom-utils.js
function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _iterableToArrayLimit(arr, i) { if (typeof Symbol === "undefined" || !(Symbol.iterator in Object(arr))) return; var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function _toConsumableArray(arr) { return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _unsupportedIterableToArray(arr) || _nonIterableSpread(); }

function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _iterableToArray(iter) { if (typeof Symbol !== "undefined" && Symbol.iterator in Object(iter)) return Array.from(iter); }

function _arrayWithoutHoles(arr) { if (Array.isArray(arr)) return _arrayLikeToArray(arr); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

/**
 * Returns tag name for passed element
 * @param {Element} element target element
 */
var getNodeName = function getNodeName(element) {
  return element && element.nodeName ? element.nodeName.toUpperCase() : '';
};
/**
 * Returns arrays of parents for passed element
 * @param {Element} element target element
 */

var getParentsLevel = function getParentsLevel(element) {
  var parent = element;
  var parentArr = []; // eslint-disable-next-line no-cond-assign

  while ((parent = parent.parentNode) && getNodeName(parent) !== 'BODY') {
    parentArr.push(parent);
  }

  return parentArr;
};
/**
 * Returns child element if it only one ELEMENT_NODE child
 * @param {Element} element target element
 */
// eslint-disable-next-line consistent-return

var getSingleChildren = function getSingleChildren(element) {
  var children = element.childNodes;

  if (children) {
    var count = 0;
    var child;

    for (var i = 0; i < children.length; i += 1) {
      if (children[i].nodeType === 1) {
        child = children[i];
        count += 1;
      }
    }

    return count === 1 ? child : null;
  }
};
/**
 * Returns all children for target element
 * @param {Element} element target element
 */

var getAllChildren = function getAllChildren(element) {
  var childArray = [];
  var child = element; // eslint-disable-next-line no-cond-assign

  while (child = getSingleChildren(child)) {
    childArray.push(child);
  }

  return childArray;
};
/**
 * Converts passed argument to array
 * Usually used for transformatin NodeList to simple Array
 * @param {any} elems
 */

var toArray = function toArray(elems) {
  return elems && elems.length !== undefined ? Array.prototype.slice.call(elems) : [elems];
};
/**
 * Adds passed classes to target element
 * @param {Element} elem target element
 * @param {string} className string where classess must be separeted with space
 */

var addClass = function addClass(elem, className) {
  var elems = toArray(elem);
  elems.forEach(function (item) {
    var classList = item.classList;
    classList.add.apply(classList, _toConsumableArray(className.split(/\s/)));
  });
};
/**
 * Removes passed classes from target element
 * @param {Element} elem target element
 * @param {string} className string where classess must be separeted with space
 */

var removeClass = function removeClass(elem, className) {
  var elems = toArray(elem);
  elems.forEach(function (item) {
    var classList = item.classList;
    classList.remove.apply(classList, _toConsumableArray(className.split(/\s/)));
  });
};
/**
 * Checks whether class in target element
 * @param {Element} elem target element
 * @param {string} className target classname
 */

var hasClass = function hasClass(elem, className) {
  var elems = toArray(elem);

  var _elems = _slicedToArray(elems, 1),
      target = _elems[0];

  return !!(target.classList && target.classList.contains(className));
};
/**
 * Makes element visible via style.display = block
 * @param {Element} elem target element
 */

var show = function show(elem) {
  var elems = toArray(elem);
  elems.forEach(function (item) {
    // eslint-disable-next-line no-param-reassign
    item.style.display = 'block';
  });
};
/**
 * Makes element invisible via style.display = none
 * @param {Element} elem target element
 */

var hide = function hide(elem) {
  var elems = toArray(elem);
  elems.forEach(function (item) {
    // eslint-disable-next-line no-param-reassign
    item.style.display = 'none';
  });
};
/**
 * Inlines css styles to target element
 * @param {Element} elem target element
 * @param {string} attr css name
 * @param {string} value css value
 */

var addStyle = function addStyle(elem, attr, value) {
  var elems = toArray(elem);
  elems.forEach(function (item) {
    // eslint-disable-next-line no-param-reassign
    item.style[attr] = value;
  });
};
;// CONCATENATED MODULE: ./locales/index.js
var _require = __nested_webpack_require_447230__(14),
    LOCALES_EQUIVALENTS_MAP = _require.LOCALES_EQUIVALENTS_MAP,
    LANGUAGES = _require.LANGUAGES;

var locales = Object.keys(LANGUAGES).reduce(function (acc, language) {
  var resultLocale = LOCALES_EQUIVALENTS_MAP[language] || language; // eslint-disable-next-line global-require,import/no-dynamic-require

  var dictionary = __nested_webpack_require_447230__(1503)("./".concat(resultLocale, "/messages.json"));

  acc[resultLocale] = dictionary;
  return acc;
}, {});
/* harmony default export */ const locales_0 = (locales);
;// CONCATENATED MODULE: ./src/localization.js
function localization_typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { localization_typeof = function _typeof(obj) { return typeof obj; }; } else { localization_typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return localization_typeof(obj); }

function localization_slicedToArray(arr, i) { return localization_arrayWithHoles(arr) || localization_iterableToArrayLimit(arr, i) || localization_unsupportedIterableToArray(arr, i) || localization_nonIterableRest(); }

function localization_nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function localization_unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return localization_arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return localization_arrayLikeToArray(o, minLen); }

function localization_arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function localization_iterableToArrayLimit(arr, i) { if (typeof Symbol === "undefined" || !(Symbol.iterator in Object(arr))) return; var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function localization_arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

/* global AdguardSettings */



var localization_require = __nested_webpack_require_447230__(897),
    _require2 = localization_slicedToArray(localization_require, 1),
    BASE_LOCALE = _require2[0].base_locale;
/**
 * Object that manages localizations
 * @returns {{getMessage: Function, translateElement: Function}}
 * @constructor
 */


function Localization() {
  var currentLocale = null;
  var locale; // convert locales keys to lower case

  var supportedLocales = Object.keys(locales_0).reduce(function (acc, key) {
    var lowerCasedKey = key.toLowerCase();
    acc[lowerCasedKey] = locales_0[key];
    return acc;
  }, {});
  /*
   * In Edge, there is undocumented behavior. When you run the script
   * through `executeScript`, the Edge browser blocks access to the
   * `languages` property of the `navigator` object without displaying
   * an error in the console and stopping the processing of the code.
   * When you call `navigator.languages` manually from the console,
   * there is no error and the correct value is returned. Therefore,
   * it is necessary to check `typeof navigator.languages !== 'undefined'`.
   * issue: https://github.com/AdguardTeam/AdguardBrowserExtension/issues/983
   */

  if (typeof AdguardSettings !== 'undefined') {
    // eslint-disable-next-line prefer-destructuring
    locale = AdguardSettings.locale;
  } else if (typeof navigator.languages !== 'undefined') {
    // eslint-disable-next-line prefer-destructuring
    locale = navigator.languages[0];
  } else if (navigator.language) {
    locale = navigator.language;
  } else if (navigator.browserLanguage) {
    locale = navigator.browserLanguage;
  } else {
    locale = BASE_LOCALE;
  }

  if (supportedLocales[locale]) {
    currentLocale = locale;
  } else if (supportedLocales[locale.toLowerCase()]) {
    currentLocale = locale.toLowerCase();
  } else {
    var langSplit = locale.split('-')[0];

    if (supportedLocales[langSplit]) {
      currentLocale = langSplit;
    } else {
      currentLocale = BASE_LOCALE;
    }
  }

  var getMessage = function getMessage(messageId) {
    var message = supportedLocales[currentLocale][messageId];

    if (!message) {
      return localization_typeof(supportedLocales[BASE_LOCALE][messageId]) === 'object' ? supportedLocales[BASE_LOCALE][messageId].message : supportedLocales[BASE_LOCALE][messageId] || '';
    }

    return supportedLocales[currentLocale][messageId].message || supportedLocales[currentLocale][messageId];
  };

  var createElement = function createElement(tagName, attributes) {
    var el = src_protectedApi.createElement(tagName);

    if (!attributes) {
      return el;
    }

    var attrs = attributes.split(/([a-z]+='[^']+')/);

    for (var i = 0; i < attrs.length; i += 1) {
      var attr = attrs[i].trim();

      if (!attr) {
        // eslint-disable-next-line no-continue
        continue;
      }

      var index = attr.indexOf('=');
      var attrName = void 0;
      var attrValue = void 0;

      if (index > 0) {
        attrName = attr.substring(0, index);
        attrValue = attr.substring(index + 2, attr.length - 1);
      }

      if (attrName && attrValue) {
        el.setAttribute(attrName, attrValue);
      }
    }

    return el;
  };

  var processString = function processString(str, element) {
    var el;
    var match1 = /^([^]*?)<(a|strong|span|i)([^>]*)>(.*?)<\/\2>([^]*)$/m.exec(str);
    var match2 = /^([^]*?)<(br|input)([^>]*)\/?>([^]*)$/m.exec(str);

    if (match1) {
      processString(match1[1], element);
      el = createElement(match1[2], match1[3]);
      processString(match1[4], el);
      element.appendChild(el);
      processString(match1[5], element);
    } else if (match2) {
      processString(match2[1], element);
      el = createElement(match2[2], match2[3]);
      element.appendChild(el);
      processString(match2[4], element);
    } else {
      element.appendChild(document.createTextNode(str.replace(/&nbsp;/g, "\xA0")));
    }
  };

  var translateElement = function translateElement(element, message) {
    try {
      while (element.lastChild) {
        element.removeChild(element.lastChild);
      }

      processString(message, element);
    } catch (ex) {// Ignore exceptions
    }
  };

  return {
    getMessage: getMessage,
    translateElement: translateElement
  };
}

var localization = new Localization();
/* harmony default export */ const src_localization = (localization);
;// CONCATENATED MODULE: ./src/controllers/mainMenuController.js








/**
 * Main menu controller
 * @param iframe
 * @returns {{init: init}}
 * @constructor
 */

function DetailedMenuController(iframe) {
  var contentDocument = null;
  var iframeCtrl = iframe;
  var domain = null;
  var FILTERING_STATE_LS_PROPERTY = '__adfstate';
  var CONFIDENCE_LEVEL = {
    ZERO: {
      from: 0,
      to: 5
    },
    ONE: {
      from: 6,
      to: 11
    },
    TWO: {
      from: 12,
      to: 22
    },
    THREE: {
      from: 23,
      to: 33
    },
    FOUR: {
      from: 34,
      to: 44
    },
    FIVE: {
      from: 45,
      to: Infinity
    }
  };

  var setDomain = function setDomain() {
    domain = decodeURIComponent(window.location.hostname);
    contentDocument.getElementsByClassName('menu-head_name')[0].textContent = domain || 'unknown';
  };

  var truncateDecimals = function truncateDecimals(number) {
    return Math[number < 0 ? 'ceil' : 'floor'](number);
  };

  var getWotReputationSettings = function getWotReputationSettings(wotData) {
    if (!wotData) {
      return null;
    }

    var prefix = 'adg-wot-';
    var averageWot = wotData.reputation;
    var wotRatingText = null;
    var wotRating = null;

    if (averageWot === 0) {
      wotRatingText = src_localization.getMessage('wot_unknown_description');
      wotRating = "".concat(prefix, "unknown");
      return {
        text: wotRatingText,
        "class": wotRating
      };
    }

    var wotSettings = {
      0: {
        color: 'red',
        string: src_localization.getMessage('wot_bad_description')
      },
      1: {
        color: 'lightRed',
        string: src_localization.getMessage('wot_poor_description')
      },
      2: {
        color: 'yellow',
        string: src_localization.getMessage('wot_unsatisfactory_description')
      },
      3: {
        color: 'lightGreen',
        string: src_localization.getMessage('wot_good_description')
      },
      4: {
        color: 'green',
        string: src_localization.getMessage('wot_excellent_description')
      },
      5: {
        color: 'green',
        string: src_localization.getMessage('wot_excellent_description')
      }
    };
    var current = wotSettings[truncateDecimals(averageWot / 20)];
    wotRatingText = current.string;
    wotRating = prefix + current.color;
    return {
      text: wotRatingText,
      "class": wotRating
    };
  };

  var getWotConfidenceClass = function getWotConfidenceClass(wotData) {
    if (!wotData) {
      return null;
    }

    var prefix = 'adg-wot-confidence-';

    var isThisLevel = function isThisLevel(num, level) {
      return num >= level.from && num <= level.to;
    };

    var confidenceWot = wotData.confidence;

    if (isThisLevel(confidenceWot, CONFIDENCE_LEVEL.ZERO)) {
      return "".concat(prefix, "0");
    }

    if (isThisLevel(confidenceWot, CONFIDENCE_LEVEL.ONE)) {
      return "".concat(prefix, "1");
    }

    if (isThisLevel(confidenceWot, CONFIDENCE_LEVEL.TWO)) {
      return "".concat(prefix, "2");
    }

    if (isThisLevel(confidenceWot, CONFIDENCE_LEVEL.THREE)) {
      return "".concat(prefix, "3");
    }

    if (isThisLevel(confidenceWot, CONFIDENCE_LEVEL.FOUR)) {
      return "".concat(prefix, "4");
    }

    if (isThisLevel(confidenceWot, CONFIDENCE_LEVEL.FIVE)) {
      return "".concat(prefix, "5");
    }

    return undefined;
  };

  var setWotData = function setWotData() {
    var wotData = src_wot.getWotData();
    var wotReputationSettings = getWotReputationSettings(wotData);

    if (!wotReputationSettings) {
      return;
    }

    var wotIndication = contentDocument.querySelector('#WotIndication');
    addClass(wotIndication, wotReputationSettings["class"]);
    wotIndication.dataset.title = src_localization.getMessage('menu_wot_reputation_indicator');
    var wotDescriptionText = contentDocument.querySelector('#WotDescriptionText');
    var wotLogo = '<span id="WotLogo"><span class="wot-logo"></span></span>';
    wotDescriptionText.innerHTML = wotReputationSettings.text.replace('$1', wotLogo);
    var confidenceIndication = contentDocument.querySelector('#ConfidenceIndication');
    var wotConfidenceClass = getWotConfidenceClass(wotData);
    addClass(confidenceIndication, wotConfidenceClass);
    wotIndication.dataset.title = src_localization.getMessage('menu_wot_reputation_confidence_level');
    var wotLinkElem = contentDocument.querySelector('.wot-indicator');
    wotLinkElem.href = src_wot.getWotScorecardUrl(domain);
    removeClass(contentDocument.querySelectorAll('.wot-hide'), 'wot-hide');
  };

  var startAdSelector = function startAdSelector() {
    iframeCtrl.showSelectorMenu();
  };

  var goToWotUrl = function goToWotUrl() {
    window.open(src_wot.WOT_URL, '_blank');
  };

  var doNotBlock = function doNotBlock() {
    gm.ADG_temporaryDontBlock(30, function () {
      reloadPageBypassCache();
    });
  };

  var reportAbuse = function reportAbuse() {
    gm.ADG_sendAbuse(function () {
      iframeCtrl.removeIframe();
    });
  };

  var goToSiteReport = function goToSiteReport() {
    var url = src_settings.Constants.REPORT_URL.replace('{0}', domain);
    window.open(url, '_blank');
  };

  var showHideBlockAdButton = function showHideBlockAdButton(isFilter) {
    var blockAd = contentDocument.querySelector('#block-ad');

    if (isFilter) {
      removeClass(blockAd, 'hidden');
    } else {
      addClass(blockAd, 'hidden');
    }

    iframeCtrl.resizeIframe();
  };
  /**
   * Storing the filtering state for quick initialization
   *
   * @param {Boolean} state  on/off filtering state
   */
  // eslint-disable-next-line consistent-return


  var setFilteringStateToStore = function setFilteringStateToStore(state) {
    try {
      localStorage.setItem(FILTERING_STATE_LS_PROPERTY, src_protectedApi.json.stringify({
        state: state
      }));
    } catch (ex) {
      src_log.error(ex);
      return null;
    }
  };

  var onIsFilterChange = function onIsFilterChange() {
    var isFilter = contentDocument.getElementById('is-filter').checked; // animate class for prevent animation while the state from the application is determined

    addClass(contentDocument.querySelectorAll('.menu-filter_label'), 'animate');
    showHideBlockAdButton(isFilter);
    setFilteringStateToStore(isFilter);
    gm.ADG_changeFilteringState(isFilter, function () {
      reloadPageBypassCache();
    });
  };

  var bindEvents = function bindEvents() {
    var menuEvents = {
      '.close': iframeCtrl.removeIframe,
      '#block-ad': startAdSelector,
      '#assistant-settings': iframeCtrl.showSettingsMenu,
      '#WotLogo': goToWotUrl,
      '#do-not-block-30-sec': doNotBlock,
      '#report-abuse': reportAbuse,
      '#site-report': goToSiteReport,
      '#is-filter': onIsFilterChange
    };
    Object.keys(menuEvents).forEach(function (item) {
      var elems = contentDocument.querySelectorAll(item);
      toArray(elems).forEach(function (elem) {
        return elem.addEventListener('click', menuEvents[item]);
      });
    });
  };
  /**
   * Getting the filtering state for quick initialization from the localStorage,
   * while the state from the application is determined
   *
   * @returns {Boolean} on/off filtering state
   */


  var getFilteringStateFromStore = function getFilteringStateFromStore() {
    try {
      var state = localStorage.getItem(FILTERING_STATE_LS_PROPERTY);

      if (state) {
        return src_protectedApi.json.parse(state).state;
      }

      return false;
    } catch (ex) {
      src_log.error(ex);
      return false;
    }
  };

  var setInitFilteringState = function setInitFilteringState() {
    var input = contentDocument.getElementById('is-filter');
    input.checked = getFilteringStateFromStore();
    gm.ADG_isFiltered(function (isFiltered) {
      input.checked = isFiltered;
      setFilteringStateToStore(isFiltered);
      showHideBlockAdButton(isFiltered);
    });
  };
  /*
   Called from IframeController._showMenuItem to initialize view
   */
  // eslint-disable-next-line no-shadow


  var init = function init(iframe) {
    // eslint-disable-next-line prefer-destructuring
    contentDocument = iframe.contentDocument;
    setDomain();
    setWotData();
    bindEvents();
    setInitFilteringState();
  };

  return {
    init: init
  };
}
;// CONCATENATED MODULE: ./src/adguard-selector.js
function adguard_selector_typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { adguard_selector_typeof = function _typeof(obj) { return typeof obj; }; } else { adguard_selector_typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return adguard_selector_typeof(obj); }

/* eslint-disable no-param-reassign, func-names */


/**
 * Adguard selector
 * @type {Function}
 */

function AdguardSelector() {
  var api = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};
  var PLACEHOLDER_PREFIX = 'adguard-placeholder';
  var placeholdedElements = null;
  var transparentPlaceholdedElement = null;
  var restrictedElements = null;
  var SELECTED_CLASS = 'adguard_sg_selected';
  var REJECTED_CLASS = 'adguard_sg_rejected';
  var IGNORED_CLASS = 'adguard_sg_ignore';
  var unbound = true;
  var onElementSelectedHandler = null;
  var ignoreTouchEvent = 0;
  var selectionRenderer; // PRIVATE METHODS

  var removeClassName = function removeClassName(className) {
    var elem = document.querySelectorAll(".".concat(className));
    removeClass(elem, className);
  };

  var firstSelectedOrSuggestedParent = function firstSelectedOrSuggestedParent(element) {
    if (hasClass(element, SELECTED_CLASS)) {
      return element;
    } // eslint-disable-next-line no-cond-assign, no-param-reassign


    while (element.parentNode && (element = element.parentNode)) {
      if (restrictedElements.indexOf(element) === -1) {
        if (hasClass(element, SELECTED_CLASS)) {
          return element;
        }
      }
    }

    return null;
  };

  var px = function px(p) {
    return "".concat(p, "px");
  };

  var getTagPath = function getTagPath(element) {
    if (element.parentNode) {
      return "".concat(element.parentNode.tagName.toLowerCase(), " ").concat(element.tagName.toLowerCase());
    }

    return element.tagName.toLowerCase();
  };
  /** ******** Events ************** */


  var sgMouseoverHandler = function sgMouseoverHandler(e) {
    e.stopPropagation();

    if (unbound) {
      return true;
    }

    if (this === document.documentElement || this === document.documentElement.parentNode) {
      return false;
    }

    var parent = firstSelectedOrSuggestedParent(this);

    if (parent !== null && parent !== this) {
      selectionRenderer.add(parent);
    } else {
      selectionRenderer.add(this);
    }

    return false;
  }; // e.isTrusted checking for prevent programmatically events
  // see: https://github.com/AdguardTeam/AdguardAssistant/issues/134


  var sgMousedownHandler = function sgMousedownHandler(e) {
    if (e && e.isTrusted === false) {
      return false;
    }

    if (hasClass(e.target, IGNORED_CLASS)) {
      return false;
    }

    e.preventDefault();
    e.stopImmediatePropagation();

    if (unbound) {
      return true;
    }

    var elem = e.target;
    var borders = elem === selectionRenderer.borderTop || elem === selectionRenderer.borderLeft || elem === selectionRenderer.borderRight || elem === selectionRenderer.borderBottom;

    if (borders) {
      // Clicked on one of our floating borders, target the element that we are bordering.
      elem = elem.target_elem || elem;
    }

    if (elem === document.documentElement || elem === document.documentElement.parentNode) {
      return undefined;
    }

    selectionRenderer.remove();
    onElementSelectedHandler(elem);
    return false;
  };
  /** ******** Touch event handlers ************** */


  var touchElementSelectHandler = function touchElementSelectHandler(e) {
    e.preventDefault();
    e.stopImmediatePropagation();
    sgMouseoverHandler.call(this, e);
    sgMousedownHandler.call(this, e);
  };

  var removeElementToPreventEvents = function removeElementToPreventEvents() {
    if (!transparentPlaceholdedElement) {
      return false;
    }

    transparentPlaceholdedElement.removeEventListener('click', touchElementSelectHandler);
    transparentPlaceholdedElement.removeEventListener('touchstart', touchElementSelectHandler);
    transparentPlaceholdedElement.removeEventListener('pointerdown', touchElementSelectHandler);
    transparentPlaceholdedElement.parentNode.removeChild(transparentPlaceholdedElement);
    transparentPlaceholdedElement = null;
    return undefined;
  };

  var clearSelected = function clearSelected() {
    removeElementToPreventEvents();
    removeClassName(SELECTED_CLASS);
    removeClassName(REJECTED_CLASS);
    selectionRenderer.remove();
  };
  /**
   * Returns element offset coordinates extended with width and height values.
   *
   * @param elem
   * @returns {{top: number, left: number, outerWidth: number, outerHeight: number}}
   */


  var getOffsetExtended = function getOffsetExtended(elem) {
    var bodyRect = document.documentElement.getBoundingClientRect();
    var elemRect = elem.getBoundingClientRect();
    var rectTop = elemRect.top - bodyRect.top;
    var rectLeft = elemRect.left - bodyRect.left;
    return {
      top: rectTop,
      left: rectLeft,
      outerWidth: elem.offsetWidth,
      outerHeight: elem.offsetHeight
    };
  };
  /**
   * Adds borders to selected element.
   *
   * Default implementation of selection renderer.
   * Can be overwritten with custom implementation as a parameter of init function.
   *
   * @param element
   * @private
   */
  // eslint-disable-next-line no-shadow


  var BorderSelectionRenderer = function (api) {
    var BORDER_WIDTH = 5;
    var BORDER_PADDING = 2;
    var BORDER_CSS = {
      position: 'absolute',
      background: 'white',
      margin: '0px',
      padding: '0px',
      display: 'block',
      "float": 'none',
      border: '0',
      outline: '0',
      'background-color': '#13a35e',
      'font-style': 'normal',
      'vertical-align': 'baseline',
      'text-align': 'left',
      'line-height': '12px',
      'box-sizing': 'content-box',
      'min-height': 'auto',
      'max-height': 'auto',
      'min-width': 'auto',
      'max-width': 'auto',
      width: 0,
      height: 0,
      'z-index': 2147483646,
      'border-radius': 0
    };
    var BORDER_BOTTOM_CSS = {
      'font-size': '10px',
      'font-weight': 'bold',
      color: 'white',
      padding: '2px 0px 2px 5px',
      overflow: 'hidden'
    };
    var borderTop = null;
    var borderLeft = null;
    var borderRight = null;
    var borderBottom = null;

    var showBorders = function showBorders() {
      if (borderTop && borderBottom && borderLeft && borderRight) {
        show(borderTop);
        show(borderBottom);
        show(borderLeft);
        show(borderRight);
      }
    };

    var addBorderToDom = function addBorderToDom() {
      document.documentElement.appendChild(borderTop);
      document.documentElement.appendChild(borderBottom);
      document.documentElement.appendChild(borderLeft);
      document.documentElement.appendChild(borderRight);
    };

    var addBorderCSS = function addBorderCSS() {
      Object.keys(BORDER_CSS).forEach(function (item) {
        borderTop.style[item] = BORDER_CSS[item];
        borderBottom.style[item] = BORDER_CSS[item];
        borderLeft.style[item] = BORDER_CSS[item];
        borderRight.style[item] = BORDER_CSS[item];
      });
      Object.keys(BORDER_BOTTOM_CSS).forEach(function (item) {
        borderBottom.style[item] = BORDER_BOTTOM_CSS[item];
      });
    };

    var removeBorderFromDom = function removeBorderFromDom() {
      if (borderTop) {
        var parent = borderTop.parentNode;

        if (parent) {
          parent.removeChild(borderTop);
          parent.removeChild(borderBottom);
          parent.removeChild(borderLeft);
          parent.removeChild(borderRight);
        }
      }

      borderTop = null;
      borderBottom = null;
      borderRight = null;
      borderLeft = null;
    };
    /**
     * Preparing renderer.
     */


    api.init = function () {
      if (!borderTop) {
        var width = px(BORDER_WIDTH);
        var bottomHeight = px(BORDER_WIDTH + 6);
        borderTop = src_protectedApi.createElement('div');
        borderBottom = src_protectedApi.createElement('div');
        borderLeft = src_protectedApi.createElement('div');
        borderRight = src_protectedApi.createElement('div');
        borderTop.addEventListener('click', sgMousedownHandler);
        borderBottom.addEventListener('click', sgMousedownHandler);
        borderLeft.addEventListener('click', sgMousedownHandler);
        borderRight.addEventListener('click', sgMousedownHandler);
        addStyle(borderTop, 'height', width);
        addStyle(borderBottom, 'height', bottomHeight);
        addStyle(borderLeft, 'width', width);
        addStyle(borderRight, 'width', width);
        hide(borderTop);
        hide(borderBottom);
        hide(borderLeft);
        hide(borderRight); // eslint-disable-next-line prefer-destructuring

        api.borderTop = borderTop; // eslint-disable-next-line prefer-destructuring

        api.borderBottom = borderBottom; // eslint-disable-next-line prefer-destructuring

        api.borderLeft = borderLeft; // eslint-disable-next-line prefer-destructuring

        api.borderRight = borderRight;
        addBorderCSS();
        addBorderToDom();
      }
    };
    /**
     * Clearing DOM and so on.
     */


    api.finalize = function () {
      removeBorderFromDom();
    };
    /**
     * Adds borders to specified element
     *
     * @param element
     */


    api.add = function (element) {
      api.remove();

      if (!element) {
        return;
      }

      var p = getOffsetExtended(element);
      var top = p.top;
      var left = p.left;
      var width = p.outerWidth;
      var height = p.outerHeight;
      addStyle(borderTop, 'width', px(width + BORDER_PADDING * 2 + BORDER_WIDTH * 2));
      addStyle(borderTop, 'height', px(5));
      addStyle(borderTop, 'top', px(top - BORDER_WIDTH - BORDER_PADDING));
      addStyle(borderTop, 'left', px(left - BORDER_PADDING - BORDER_WIDTH));
      addStyle(borderBottom, 'width', px(width + BORDER_PADDING * 2 + BORDER_WIDTH));
      addStyle(borderBottom, 'height', px(12));
      addStyle(borderBottom, 'top', px(top + height + BORDER_PADDING));
      addStyle(borderBottom, 'left', px(left - BORDER_PADDING - BORDER_WIDTH));
      addStyle(borderLeft, 'height', px(height + BORDER_PADDING * 2));
      addStyle(borderLeft, 'width', px(5));
      addStyle(borderLeft, 'top', px(top - BORDER_PADDING));
      addStyle(borderLeft, 'left', px(left - BORDER_PADDING - BORDER_WIDTH));
      addStyle(borderRight, 'height', px(height + BORDER_PADDING * 2));
      addStyle(borderRight, 'width', px(5));
      addStyle(borderRight, 'top', px(top - BORDER_PADDING));
      addStyle(borderRight, 'left', px(left + width + BORDER_PADDING));
      borderBottom.textContent = getTagPath(element);
      borderRight.target_elem = element;
      borderLeft.target_elem = element;
      borderTop.target_elem = element;
      borderBottom.target_elem = element;
      showBorders();
    };
    /**
     * Removes borders
     */


    api.remove = function () {
      if (borderTop && borderBottom && borderLeft && borderRight) {
        hide(borderTop);
        hide(borderBottom);
        hide(borderLeft);
        hide(borderRight);
      }
    };

    return api; // eslint-disable-next-line no-use-before-define
  }(BorderSelectionRenderer || {});

  var linkHelper = src_protectedApi.createElement('a');

  var getHost = function getHost(url) {
    if (!url) {
      return '';
    }

    linkHelper.href = url;
    return linkHelper.hostname;
  };

  var makePlaceholderImage = function makePlaceholderImage(element) {
    var placeHolder = src_protectedApi.createElement('div');
    var style = window.getComputedStyle(element);
    placeHolder.style.height = style.height;
    placeHolder.style.width = style.width;
    placeHolder.style.position = style.position;
    placeHolder.style.top = style.top;
    placeHolder.style.bottom = style.bottom;
    placeHolder.style.left = style.left;
    placeHolder.style.right = style.right;
    placeHolder.className += "".concat(PLACEHOLDER_PREFIX, " ").concat(IGNORED_CLASS);
    var icon = src_protectedApi.createElement('div');
    icon.className += "".concat(PLACEHOLDER_PREFIX, "-icon ").concat(IGNORED_CLASS);
    var domain = src_protectedApi.createElement('div');
    domain.textContent = getHost(element.src);
    domain.className += "".concat(PLACEHOLDER_PREFIX, "-domain ").concat(IGNORED_CLASS);
    icon.appendChild(domain);
    placeHolder.appendChild(icon);
    return placeHolder;
  };

  var removePlaceholders = function removePlaceholders() {
    removeElementToPreventEvents();

    if (!placeholdedElements) {
      return;
    }

    var elements = placeholdedElements;

    for (var i = 0; i < elements.length; i += 1) {
      var current = elements[i];
      var id = PLACEHOLDER_PREFIX + i;
      var placeHolder = document.querySelector("#".concat(id));

      if (placeHolder) {
        var parent = placeHolder.parentNode;

        if (parent) {
          parent.replaceChild(current, placeHolder);
        }
      }
    }

    placeholdedElements = null;
  };

  var placeholderClick = function placeholderClick(element) {
    selectionRenderer.remove();
    removePlaceholders();
    onElementSelectedHandler(element);
  };
  /**
   * Making top level transparent layer to prevented events on emerging ad.
   * see: https://github.com/AdguardTeam/AdguardAssistant/issues/220
   *
   * @param element element where ad is added
   */


  var preventEvents = function preventEvents(element) {
    var placeHolder = src_protectedApi.createElement('div');
    var style = getOffsetExtended(element);
    placeHolder.style.height = px(style.outerHeight);
    placeHolder.style.width = px(style.outerWidth);
    placeHolder.style.top = px(style.top);
    placeHolder.style.left = px(style.left);
    placeHolder.style.background = 'transparent';
    placeHolder.style.position = 'absolute';
    placeHolder.style['pointer-events'] = 'all';
    placeHolder.style['box-sizing'] = 'content-box';
    placeHolder.style['z-index'] = '2147483646';
    placeHolder.className += IGNORED_CLASS;
    transparentPlaceholdedElement = placeHolder;
    placeHolder.addEventListener('click', touchElementSelectHandler);
    placeHolder.addEventListener('touchstart', touchElementSelectHandler);
    placeHolder.addEventListener('pointerdown', touchElementSelectHandler);
    document.documentElement.appendChild(placeHolder);
  };

  var gestureEndHandler = function gestureEndHandler() {
    ignoreTouchEvent = 2;
    return true;
  };

  var touchMoveHandler = function touchMoveHandler() {
    ignoreTouchEvent = 1;
    return true;
  };

  var needIgnoreTouchEvent = function needIgnoreTouchEvent() {
    if (ignoreTouchEvent > 0) {
      ignoreTouchEvent -= 1;
      return true;
    }

    return false;
  };

  var makeIFrameAndEmbeddedSelector = function makeIFrameAndEmbeddedSelector() {
    placeholdedElements = document.querySelectorAll("iframe:not(.".concat(IGNORED_CLASS, "),embed,object"));
    toArray(placeholdedElements).filter(function (elem) {
      var isVisible = elem.style.display !== 'none';
      var isHaveSize = elem.offsetWidth !== 0 && elem.offsetHeight !== 0;
      return isVisible && isHaveSize;
    });
    var elements = placeholdedElements;

    var _loop = function _loop(i) {
      var current = elements[i]; // eslint-disable-next-line no-shadow

      (function (current) {
        var placeHolder = makePlaceholderImage(current);
        var id = PLACEHOLDER_PREFIX + i;
        placeHolder.setAttribute('id', id);
        var parent = current.parentNode;

        if (parent) {
          parent.replaceChild(placeHolder, current);
          placeHolder.addEventListener('gestureend', gestureEndHandler);
          placeHolder.addEventListener('touchmove', touchMoveHandler); // eslint-disable-next-line consistent-return

          placeHolder.addEventListener('touchend', function (e) {
            e.preventDefault();

            if (needIgnoreTouchEvent()) {
              return true;
            }

            placeholderClick(current);
          });
          var elems = document.querySelectorAll("#".concat(id));
          toArray(elems).forEach(function (elem) {
            elem.addEventListener('click', function (e) {
              e.preventDefault();
              placeholderClick(current);
            });
          });
        }
      })(current);
    };

    for (var i = 0; i < elements.length; i += 1) {
      _loop(i);
    }
  };

  var sgMouseoutHandler = function sgMouseoutHandler() {
    if (unbound) {
      return true;
    }

    if (this === document.documentElement || this === document.documentElement.parentNode) {
      return false;
    }

    selectionRenderer.remove();
    return false;
  };

  var elementTouchendHandler = function elementTouchendHandler(e) {
    if (hasClass(e.target, IGNORED_CLASS)) {
      return false;
    }

    e.stopPropagation();

    if (needIgnoreTouchEvent()) {
      return true;
    }

    touchElementSelectHandler.call(this, e);
    return false;
  };

  var emptyEventHandler = function emptyEventHandler(e) {
    e.stopPropagation();
    return false;
  };

  var setupEventHandlers = function setupEventHandlers() {
    makeIFrameAndEmbeddedSelector();
    var elements = document.querySelectorAll("body *:not(.".concat(IGNORED_CLASS, ")"));
    toArray(elements).forEach(function (el) {
      el.addEventListener('gestureend', gestureEndHandler);
      el.addEventListener('touchmove', touchMoveHandler);
      el.addEventListener('touchend', elementTouchendHandler, true);
      el.addEventListener('touchstart', emptyEventHandler);
      el.addEventListener('mouseover', sgMouseoverHandler);
      el.addEventListener('mouseout', sgMouseoutHandler);
      el.addEventListener('click', sgMousedownHandler, true);
    });
  };

  var deleteEventHandlers = function deleteEventHandlers() {
    removePlaceholders();
    var elements = document.querySelectorAll('body *');
    toArray(elements).forEach(function (el) {
      el.removeEventListener('gestureend', gestureEndHandler);
      el.removeEventListener('touchmove', touchMoveHandler);
      el.removeEventListener('touchend', elementTouchendHandler, true);
      el.removeEventListener('touchstart', emptyEventHandler);
      el.removeEventListener('mouseover', sgMouseoverHandler);
      el.removeEventListener('mouseout', sgMouseoutHandler);
      el.removeEventListener('click', sgMousedownHandler, true);
    });
  }; // Define default implementation of selection renderer.


  selectionRenderer = BorderSelectionRenderer; // PUBLIC API

  /**
   * Starts selector module.
   *
   * @param onElementSelected callback function
   * @param selectionRenderImpl optional object contains selection presentation implementation
   */

  api.init = function (onElementSelected, selectionRenderImpl) {
    onElementSelectedHandler = onElementSelected;

    if (selectionRenderImpl && adguard_selector_typeof(selectionRenderImpl) === 'object') {
      selectionRenderer = selectionRenderImpl;
    }

    restrictedElements = ['html', 'body', 'head', 'base'].map(function (selector) {
      return document.querySelector(selector);
    });
    selectionRenderer.init();
    setupEventHandlers();
    unbound = false;
  };
  /**
   * Resets state of selector.
   * Clears current selection.
   */


  api.reset = function () {
    clearSelected();
  };
  /**
   * Destroys selector module.
   * Removes all selector elements and unbinds event handlers.
   */


  api.close = function () {
    unbound = true;
    selectionRenderer.finalize();
    deleteEventHandlers();
  };
  /**
   * Selects specified element.
   * Marks element as selected and holds selection on it.
   *
   * @param element
   */


  api.selectElement = function (element) {
    selectionRenderer.add(element);
    removePlaceholders();
    unbound = true;
    preventEvents(element);
  };
  /**
   Returns css class name.
   If this class assigns to HTML element, then Adguard Selector ignores it.
   */
  // eslint-disable-next-line func-names


  api.ignoreClassName = function () {
    return IGNORED_CLASS;
  };

  return api;
}

var adguard_selector_selector = new AdguardSelector();
/* harmony default export */ const adguard_selector = (adguard_selector_selector);
;// CONCATENATED MODULE: ./src/controllers/selectorMenuController.js


/**
 * Selector menu controller
 * @returns {{init: init}}
 * @constructor
 */

function SelectorMenuController(iframe) {
  var contentDocument = null;
  var iframeCtrl = iframe;

  var close = function close() {
    iframeCtrl.removeIframe();
  };

  var bindEvents = function bindEvents() {
    var menuEvents = {
      '.close': close,
      '.btn-default': close
    };
    Object.keys(menuEvents).forEach(function (item) {
      var elems = contentDocument.querySelectorAll(item);
      toArray(elems).forEach(function (elem) {
        return elem.addEventListener('click', menuEvents[item]);
      });
    });
  };

  var onElementSelected = function onElementSelected(element) {
    iframeCtrl.showSliderMenu(element);
  };

  var startSelector = function startSelector() {
    adguard_selector.reset();
    adguard_selector.init(onElementSelected);
  };
  /*
   Called from IframeController._showMenuItem to initialize view
   */
  // eslint-disable-next-line no-shadow


  var init = function init(iframe) {
    // eslint-disable-next-line prefer-destructuring
    contentDocument = iframe.contentDocument;
    bindEvents();
    startSelector();
  };

  iframeCtrl.onCloseMenu.attach(adguard_selector.close);
  return {
    init: init,
    startSelector: startSelector
  };
}
;// CONCATENATED MODULE: ./src/slider-widget.js


var BASIC_GREEN_COLOR = '#36BA53';
var DARK_GREEN_COLOR = '#4D995F';
var TICK_RIGHT_COLOR = '#E0DFDB';
/**
 * Slider widget
 * @type {Function}
 */

function SliderWidget() {
  var api = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};
  var PLACEHOLDER_CLASS = 'adg-slide ui-slider ui-slider-horizontal ui-widget ui-widget-content ui-corner-all';
  var HANDLE_CLASS = 'ui-slider-handle';
  var HANDLE_FULL_CLASS = 'ui-slider-handle ui-state-default ui-corner-all';
  var TICK_CLASS = 'tick';
  var TICK_FULL_CLASS = 'tick ui-widget-content';
  var tickLeftColor = BASIC_GREEN_COLOR;
  var placeholder = null;
  var min = 0;
  var max = 1;
  var value = 0;
  var sliderArea = null;
  var onValueChanged = null;

  if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
    tickLeftColor = DARK_GREEN_COLOR;
  }

  var refresh = function refresh() {
    var handle = placeholder.querySelectorAll(".".concat(HANDLE_CLASS));
    addStyle(handle, 'left', "".concat((value - 1) * 100 / (max - min), "%"));
    var ticks = placeholder.querySelectorAll(".".concat(TICK_CLASS));

    for (var i = 0; i < ticks.length; i += 1) {
      if (i + 1 < value) {
        addStyle(ticks[i], 'background-color', tickLeftColor);
      } else {
        addStyle(ticks[i], 'background-color', TICK_RIGHT_COLOR);
      }
    }
  };

  var render = function render() {
    addClass(placeholder, PLACEHOLDER_CLASS);
    var handle = src_protectedApi.createElement('span');
    handle.setAttribute('class', HANDLE_FULL_CLASS);
    placeholder.appendChild(handle);
    var count = max - min;

    var prepare = function prepare(i) {
      var tick = src_protectedApi.createElement('div');
      tick.setAttribute('class', TICK_FULL_CLASS);
      tick.style.left = "".concat(100 / count * i, "%");
      tick.style.width = "".concat(100 / count, "%");
      placeholder.appendChild(tick);
    };

    for (var i = 0; i < count; i += 1) {
      prepare(i);
    }

    refresh();
  };

  var setValue = function setValue(v) {
    if (v < min) {
      value = min;
    } else if (v > max) {
      value = max;
    } else {
      value = v;
    }

    refresh();
    onValueChanged(value);
  };

  var bindEvents = function bindEvents() {
    var rect = placeholder.getBoundingClientRect();
    var sliderWidth = rect.width;
    var offsetLeft = rect.left + document.body.scrollLeft;

    var getSliderValue = function getSliderValue(pageX) {
      return Math.round((max - min) / sliderWidth * (pageX - offsetLeft) + min);
    };

    var onMouseMove = function onMouseMove(e) {
      // calculate the correct position of the slider set the value
      var val = getSliderValue(e.pageX);
      setValue(val);
    };

    var onClick = function onClick(e) {
      // calculate the correct position of the slider set the value
      var val = getSliderValue(e.pageX);
      setValue(val);
    };

    var onMouseDown = function onMouseDown(e) {
      e.stopPropagation();
      e.preventDefault();
      e.cancelBubble = true;
      e.returnValue = false;
      sliderArea.addEventListener('mousemove', onMouseMove);
      sliderArea.addEventListener('touchmove', onMouseMove);
      sliderArea.addEventListener('pointermove', onMouseMove);
    };

    var sliderAreaRemoveListeners = function sliderAreaRemoveListeners() {
      sliderArea.removeEventListener('mousemove', onMouseMove);
      sliderArea.removeEventListener('touchmove', onMouseMove);
      sliderArea.removeEventListener('pointermove', onMouseMove);
    };

    document.addEventListener('mouseup', sliderAreaRemoveListeners);
    document.addEventListener('touchend', sliderAreaRemoveListeners);
    document.addEventListener('pointerup', sliderAreaRemoveListeners);
    placeholder.addEventListener('click', onClick);
    placeholder.addEventListener('mousedown', onMouseDown);
    placeholder.addEventListener('touchstart', onMouseDown);
    sliderArea.addEventListener('mouseup', sliderAreaRemoveListeners);
    sliderArea.addEventListener('touchend', sliderAreaRemoveListeners);
    sliderArea.addEventListener('pointerup', sliderAreaRemoveListeners);
    sliderArea.addEventListener('mouseleave', sliderAreaRemoveListeners);
  };
  /**
   * @param placeholderElement
   * @param options
   */
  // eslint-disable-next-line no-param-reassign


  api.init = function (placeholderElement, options) {
    placeholder = placeholderElement; // eslint-disable-next-line prefer-destructuring

    min = options.min; // eslint-disable-next-line prefer-destructuring

    max = options.max; // eslint-disable-next-line prefer-destructuring

    value = options.value; // eslint-disable-next-line prefer-destructuring

    onValueChanged = options.onValueChanged; // eslint-disable-next-line prefer-destructuring

    sliderArea = options.sliderArea;
    render();
    bindEvents();
  };

  return api;
}

var sliderWidget = new SliderWidget();
/* harmony default export */ const slider_widget = (sliderWidget);
;// CONCATENATED MODULE: ./src/libs/css.escape.js
/*! https://mths.be/cssescape v1.5.1 by @mathias | MIT license */
// https://drafts.csswg.org/cssom/#serialize-an-identifier
function cssEscape(value) {
  if (arguments.length === 0) {
    throw new TypeError('`CSS.escape` requires an argument.');
  }

  var string = String(value);
  var length = string.length;
  var index = -1;
  var codeUnit;
  var result = '';
  var firstCodeUnit = string.charCodeAt(0); // eslint-disable-next-line no-plusplus

  while (++index < length) {
    codeUnit = string.charCodeAt(index); // Note: there’s no need to special-case astral symbols, surrogate
    // pairs, or lone surrogates.
    // If the character is NULL (U+0000), then the REPLACEMENT CHARACTER
    // (U+FFFD).

    if (codeUnit === 0x0000) {
      result += "\uFFFD"; // eslint-disable-next-line no-continue

      continue;
    }

    if ( // If the character is in the range [\1-\1F] (U+0001 to U+001F) or is
    // U+007F, […]
    // eslint-disable-next-line eqeqeq
    codeUnit >= 0x0001 && codeUnit <= 0x001F || codeUnit == 0x007F // If the character is the first character and is in the range [0-9]
    // (U+0030 to U+0039), […]
    || index === 0 && codeUnit >= 0x0030 && codeUnit <= 0x0039 // If the character is the second character and is in the range [0-9]
    // (U+0030 to U+0039) and the first character is a `-` (U+002D), […]
    || index === 1 && codeUnit >= 0x0030 && codeUnit <= 0x0039 // eslint-disable-next-line eqeqeq
    && firstCodeUnit == 0x002D) {
      // https://drafts.csswg.org/cssom/#escape-a-character-as-code-point
      result += "\\".concat(codeUnit.toString(16), " "); // eslint-disable-next-line no-continue

      continue;
    }

    if ( // If the character is the first character and is a `-` (U+002D), and
    // there is no second character, […]
    index === 0 && length === 1 // eslint-disable-next-line eqeqeq
    && codeUnit == 0x002D) {
      result += "\\".concat(string.charAt(index)); // eslint-disable-next-line no-continue

      continue;
    } // If the character is not handled by one of the above rules and is
    // greater than or equal to U+0080, is `-` (U+002D) or `_` (U+005F), or
    // is in one of the ranges [0-9] (U+0030 to U+0039), [A-Z] (U+0041 to
    // U+005A), or [a-z] (U+0061 to U+007A), […]


    if (codeUnit >= 0x0080 // eslint-disable-next-line eqeqeq
    || codeUnit == 0x002D // eslint-disable-next-line eqeqeq
    || codeUnit == 0x005F || codeUnit >= 0x0030 && codeUnit <= 0x0039 || codeUnit >= 0x0041 && codeUnit <= 0x005A || codeUnit >= 0x0061 && codeUnit <= 0x007A) {
      // the character itself
      result += string.charAt(index); // eslint-disable-next-line no-continue

      continue;
    } // Otherwise, the escaped character.
    // https://drafts.csswg.org/cssom/#escape-a-character


    result += "\\".concat(string.charAt(index));
  }

  return result;
}
;// CONCATENATED MODULE: ./src/adguard-rules-constructor.js


/**
 * Adguard rules constructor
 * @type {Function}
 */

function AdguardRulesConstructorLib() {
  var api = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};
  var CSS_RULE_MARK = '##';
  var RULE_OPTIONS_MARK = '$';
  var URLBLOCK_ATTRIBUTES = ['src', 'data'];
  var linkHelper = src_protectedApi.createElement('a');
  /**
   * Constructs css selector by combining classes by AND
   * @param classList
   * @returns {string}
   */

  var constructClassCssSelectorByAND = function constructClassCssSelectorByAND(classList) {
    var selectors = [];

    if (classList) {
      for (var i = 0; i < classList.length; i += 1) {
        selectors.push(".".concat(cssEscape(classList[i])));
      }
    }

    return selectors.join('');
  };
  /**
   * Constructs css selector for element using tag name,
   * id and classed, like: tagName#id.class1.class2
   *
   * @param element Element
   * @param classList Override element classes
   * (If classList is null, element classes will be used)
   * @param excludeTagName Omit tag name in selector
   * @param excludeId Omit element id in selector
   * @returns {string}
   */


  var makeDefaultCssFilter = function makeDefaultCssFilter(element, classList, excludeTagName, excludeId) {
    var cssSelector = excludeTagName ? '' : element.tagName.toLowerCase();

    if (element.id && !excludeId) {
      cssSelector += "#".concat(cssEscape(element.id));
    }

    cssSelector += constructClassCssSelectorByAND(classList || element.classList);
    return cssSelector;
  };
  /**
   * Constructs css selector for element using parent elements
   * and nth-child (first-child, last-child) pseudo classes.
   *
   * @param element Element
   * @param options Construct options.
   * For example: {excludeTagName: false, excludeId: false, classList: []}
   * @returns {string}
   */


  var makeCssNthChildFilter = function makeCssNthChildFilter(element, options) {
    // eslint-disable-next-line no-param-reassign
    options = options || {};
    var _options = options,
        classList = _options.classList,
        excludeTagName = _options.excludeTagName,
        excludeId = _options.excludeId;
    var excludeTagNameOverride = ('excludeTagName' in options);
    var excludeIdOverride = ('excludeId' in options);
    var path = [];
    var el = element;

    while (el.parentNode) {
      var nodeName = el && el.nodeName ? el.nodeName.toUpperCase() : '';

      if (nodeName === 'BODY') {
        break;
      }

      if (el.id) {
        /**
         * Be default we don't include tag name and classes
         * to selector for element with id attribute
         */
        var cssSelector = '';

        if (el === element) {
          cssSelector = makeDefaultCssFilter(el, classList || [], excludeTagNameOverride ? excludeTagName : true, excludeIdOverride ? excludeId : false);
        } else {
          cssSelector = makeDefaultCssFilter(el, [], true, false);
        }

        path.unshift(cssSelector);
        break;
      } else {
        var c = 1;

        for (var e = el; e.previousSibling; e = e.previousSibling) {
          if (e.previousSibling.nodeType === 1) {
            c += 1;
          }
        }

        var cldCount = 0;

        for (var i = 0; el.parentNode && i < el.parentNode.childNodes.length; i += 1) {
          cldCount += el.parentNode.childNodes[i].nodeType === 1 ? 1 : 0;
        }

        var ch = void 0;

        if (cldCount === 0 || cldCount === 1) {
          ch = '';
        } else if (c === 1) {
          ch = ':first-child';
        } else if (c === cldCount) {
          ch = ':last-child';
        } else {
          ch = ":nth-child(".concat(c, ")");
        }
        /**
         * By default we include tag name and
         * element classes to selector for element without id attribute
         */


        if (el === element) {
          var p = makeDefaultCssFilter(el, classList, excludeId, excludeTagNameOverride ? excludeTagName : false);
          p += ch;
          path.unshift(p);
        } else {
          path.unshift(makeDefaultCssFilter(el, el.classList, false, false) + ch);
        }

        el = el.parentNode;
      }
    }

    return path.join(' > ');
  };
  /**
   * Constructs css selector by combining classes by OR
   * @param classList
   * @returns {string}
   */


  var constructClassCssSelectorByOR = function constructClassCssSelectorByOR(classList) {
    var selectors = [];

    if (classList) {
      for (var i = 0; i < classList.length; i += 1) {
        selectors.push(".".concat(cssEscape(classList[i])));
      }
    }

    return selectors.join(', ');
  };
  /**
   * Constructs element selector for matching elements
   * that contain any of classes in original element.
   * For example <el class='cl1 cl2 cl3'></el> => .cl1, .cl2, .cl3
   *
   * @param element Element
   * @param classList Override element classes
   * (If classList is null, element classes will be used)
   * @returns {string}
   */


  var makeSimilarCssFilter = function makeSimilarCssFilter(element, classList) {
    return constructClassCssSelectorByOR(classList || element.classList);
  };
  /**
   * Creates css rule text
   * @param element Element
   * @param options Construct options.
   * For example: {
   *  cssSelectorType: 'STRICT_FULL',
   *  excludeTagName: false,
   *  excludeId: false, classList: []
   * }
   * @returns {string}
   */


  var constructCssRuleText = function constructCssRuleText(element, options) {
    if (!element) {
      return;
    } // eslint-disable-next-line no-param-reassign


    options = options || {};
    var cssSelectorType = options.cssSelectorType || 'STRICT_FULL';
    var selector;

    switch (cssSelectorType) {
      case 'STRICT_FULL':
        selector = makeCssNthChildFilter(element, options);
        break;

      case 'STRICT':
        selector = makeDefaultCssFilter(element, options.classList, options.excludeTagName, options.excludeId);
        break;

      case 'SIMILAR':
        selector = makeSimilarCssFilter(element, options.classList, true);
        break;

      default:
        break;
    } // eslint-disable-next-line consistent-return


    return selector ? CSS_RULE_MARK + selector : '';
  };

  var constructUrlBlockRuleText = function constructUrlBlockRuleText(element, urlBlockAttribute, oneDomain, domain) {
    if (!urlBlockAttribute) {
      return null;
    }

    var blockUrlRuleText = urlBlockAttribute.replace(/^http:\/\/(www\.)?/, '||');

    if (blockUrlRuleText.indexOf('.') === 0) {
      blockUrlRuleText = blockUrlRuleText.substring(1);
    }

    if (!oneDomain) {
      blockUrlRuleText = "".concat(blockUrlRuleText).concat(RULE_OPTIONS_MARK, "domain=").concat(domain);
    }

    return blockUrlRuleText;
  };

  var isValidUrl = function isValidUrl(value) {
    if (value) {
      linkHelper.href = value;

      if (linkHelper.hostname) {
        return true;
      }
    }

    return false;
  };

  var getUrlBlockAttribute = function getUrlBlockAttribute(element) {
    if (!element || !element.getAttribute) {
      return null;
    }

    for (var i = 0; i < URLBLOCK_ATTRIBUTES.length; i += 1) {
      var attr = URLBLOCK_ATTRIBUTES[i];
      var value = element.getAttribute(attr);

      if (isValidUrl(value)) {
        return value;
      }
    }

    return null;
  };

  var haveUrlBlockParameter = function haveUrlBlockParameter(element) {
    var value = getUrlBlockAttribute(element);
    return value && value !== '';
  };

  var haveClassAttribute = function haveClassAttribute(element) {
    return element.classList && element.classList.length > 0;
  };

  var haveIdAttribute = function haveIdAttribute(element) {
    return element.id && element.id.trim() !== '';
  };

  var getUrl = function getUrl(url) {
    var pattern = '^(([^:/\\?#]+):)?(//(([^:/\\?#]*)(?::([^/\\?#]*))?))?([^\\?#]*)(\\?([^#]*))?(#(.*))?$';
    var rx = new RegExp(pattern);
    var parts = rx.exec(url);
    return {
      host: parts[4] || '',
      path: parts[7] || ''
    };
  };

  var cropDomain = function cropDomain(url) {
    var domain = getUrl(url).host;
    return domain.replace('www.', '').replace(/:\d+/, '');
  };
  /**
   * Utility method
   *
   * @param element
   * @returns {string}
   */
  // eslint-disable-next-line no-param-reassign


  api.makeCssNthChildFilter = makeCssNthChildFilter;
  /**
   * Returns detailed element info
   *
   * @param element
   */
  // eslint-disable-next-line no-param-reassign

  api.getElementInfo = function (element) {
    // Convert attributes to array
    var attributes = [];
    var elementAttributes = element.attributes;

    if (elementAttributes) {
      for (var i = 0; i < elementAttributes.length; i += 1) {
        var attr = elementAttributes[i];
        attributes.push({
          name: attr.name,
          value: attr.value
        });
      }
    }

    return {
      tagName: element.tagName,
      attributes: attributes,
      urlBlockAttributeValue: getUrlBlockAttribute(element),
      haveUrlBlockParameter: haveUrlBlockParameter(element),
      haveClassAttribute: haveClassAttribute(element),
      haveIdAttribute: haveIdAttribute(element)
    };
  };
  /**
   * Constructs css selector for specified rule
   *
   * @param ruleText rule text
   * @returns {string} css style selector
   */
  // eslint-disable-next-line no-param-reassign


  api.constructRuleCssSelector = function (ruleText) {
    if (!ruleText) {
      return null;
    }

    var index = ruleText.indexOf(CSS_RULE_MARK);
    var optionsIndex = ruleText.indexOf(RULE_OPTIONS_MARK);

    if (index >= 0) {
      return ruleText.substring(index + CSS_RULE_MARK.length, optionsIndex >= 0 ? optionsIndex : ruleText.length);
    }

    var s = ruleText.substring(0, optionsIndex);
    s = s.replace(/[|]|[\^]/g, '');

    if (isValidUrl(s)) {
      return "[src*=\"".concat(s, "\"]");
    }

    return null;
  };
  /**
   * Constructs adguard rule text from element node and specified options
   *
   * const options = {
   *  urlMask: url block attributes,
   *  isBlockOneDomain: boolean,
   *  url: url,
   *  attributes: attributesSelectorText,
   *  ruleType: (URL, CSS)
   *  cssSelectorType: (STRICT_FULL, STRICT, SIMILAR),
   *  excludeTagName: false, (Exclude element tag name from selector)
   *  excludeId: false, (Exclude element identifier from selector)
   *  classList: []
   *      (Override element classes (If classList is null, element classes will be used))
   * }
   *
   * @param element
   * @param options
   * @returns {*}
   */
  // eslint-disable-next-line no-param-reassign


  api.constructRuleText = function (element, options) {
    var croppedDomain = cropDomain(options.url);
    var ruleType = options.ruleType;

    if (ruleType === 'URL') {
      var blockUrlRuleText = constructUrlBlockRuleText(element, options.urlMask, options.isBlockOneDomain, croppedDomain);

      if (blockUrlRuleText) {
        return blockUrlRuleText;
      }
    }

    var result;

    if (ruleType === 'CSS') {
      result = constructCssRuleText(element, options); // Append html attributes to css selector

      if (options.attributes) {
        result = (result || CSS_RULE_MARK + result) + options.attributes;
      }
    }

    if (!options.isBlockOneDomain) {
      result = croppedDomain + result;
    }

    return result;
  };

  return api;
}

var adguardRulesConstructor = new AdguardRulesConstructorLib();
/* harmony default export */ const adguard_rules_constructor = (adguardRulesConstructor);
;// CONCATENATED MODULE: ./src/controllers/sliderMenuController.js





/**
 * Slider menu controller
 * @param addRule
 * @returns {{init: init}}
 * @constructor
 */

function SliderMenuController(addRule, iframe) {
  var contentDocument = null;
  var selectedElement = null;
  var startElement = null;
  var currentElement = null;
  var iframeCtrl = iframe;

  var getFilterRuleInputText = function getFilterRuleInputText() {
    return contentDocument.getElementById('filter-rule').value;
  };

  var close = function close() {
    iframeCtrl.removeIframe();
  };

  var expandAdvanced = function expandAdvanced() {
    var advancedSettings = contentDocument.querySelector('#advanced-settings');
    var extendedSettingsText = contentDocument.querySelector('#ExtendedSettingsText');
    var hidden = !hasClass(advancedSettings, 'open');

    if (hidden) {
      addClass(advancedSettings, 'open');
      addClass(extendedSettingsText, 'active');
      iframeCtrl.resizeSliderMenuToAdvanced();
    } else {
      removeClass(advancedSettings, 'open');
      removeClass(extendedSettingsText, 'active');
      iframeCtrl.resizeSliderMenuToNormal();
    }
  };

  var showPreview = function showPreview() {
    var options = {
      isBlockByUrl: contentDocument.getElementById('block-by-url-checkbox').checked,
      isBlockSimilar: contentDocument.getElementById('block-similar-checkbox').checked,
      isBlockOneDomain: contentDocument.getElementById('one-domain-checkbox').checked
    };
    iframeCtrl.showBlockPreview(selectedElement, getFilterRuleInputText(), startElement, options);
  };

  var blockElement = function blockElement() {
    var path = getFilterRuleInputText();
    iframeCtrl.blockElement(path, addRule);
  };

  var handleShowBlockSettings = function handleShowBlockSettings(showBlockByUrl, showBlockSimilar) {
    var blockByUrlBlock = contentDocument.querySelector('#block-by-url-checkbox-block');
    var blockSimilarBlock = contentDocument.querySelector('#block-similar-checkbox-block');

    if (showBlockByUrl) {
      show(blockByUrlBlock);
    } else {
      contentDocument.getElementById('block-by-url-checkbox').checked = false;
      hide(blockByUrlBlock);
    }

    if (showBlockSimilar) {
      show(blockSimilarBlock);
    } else {
      contentDocument.getElementById('block-similar-checkbox').checked = false;
      hide(blockSimilarBlock);
    }
  };

  var getUrlBlockAttribute = function getUrlBlockAttribute(element) {
    var urlBlockAttributes = ['src', 'data'];

    for (var i = 0; i < urlBlockAttributes.length; i += 1) {
      var attr = urlBlockAttributes[i];
      var value = element.getAttribute(attr);

      if (value) {
        return value;
      }
    }

    return null;
  };

  var haveUrlBlockParameter = function haveUrlBlockParameter(element) {
    var value = getUrlBlockAttribute(element);
    return value && value !== '';
  };

  var haveClassAttribute = function haveClassAttribute(element) {
    var className = element.className;
    return className && typeof className === 'string' && className.trim() !== '';
  };

  var setFilterRuleInputText = function setFilterRuleInputText(ruleText) {
    contentDocument.getElementById('filter-rule').value = ruleText;
  };

  var onScopeChange = function onScopeChange() {
    var isBlockByUrl = contentDocument.getElementById('block-by-url-checkbox').checked;
    var isBlockSimilar = contentDocument.getElementById('block-similar-checkbox').checked;
    var isBlockOneDomain = contentDocument.getElementById('one-domain-checkbox').checked;
    handleShowBlockSettings(haveUrlBlockParameter(selectedElement) && !isBlockSimilar, haveClassAttribute(selectedElement) && !isBlockByUrl);
    var options = {
      urlMask: getUrlBlockAttribute(selectedElement),
      cssSelectorType: isBlockSimilar ? 'SIMILAR' : 'STRICT_FULL',
      isBlockOneDomain: isBlockOneDomain,
      url: document.location,
      ruleType: isBlockByUrl ? 'URL' : 'CSS'
    };
    var ruleText = adguard_rules_constructor.constructRuleText(selectedElement, options);
    setFilterRuleInputText(ruleText);
    iframeCtrl.resizeIframe();
  };

  var bindEvents = function bindEvents() {
    var menuEvents = {
      '.close': close,
      '#ExtendedSettingsText': expandAdvanced,
      '#adg-cancel': iframeCtrl.showSelectorMenu,
      '#adg-preview': showPreview,
      '#adg-accept': blockElement,
      '#block-by-url-checkbox-block': onScopeChange,
      '#one-domain-checkbox-block': onScopeChange,
      '#block-similar-checkbox-block': onScopeChange
    };
    Object.keys(menuEvents).forEach(function (item) {
      var elems = contentDocument.querySelectorAll(item);
      toArray(elems).forEach(function (elem) {
        return elem.addEventListener('click', menuEvents[item]);
      });
    });
  };

  var makeDefaultCheckboxesForDetailedMenu = function makeDefaultCheckboxesForDetailedMenu(options) {
    contentDocument.getElementById('block-by-url-checkbox').checked = options && options.isBlockByUrl;
    contentDocument.getElementById('block-similar-checkbox').checked = options && options.isBlockSimilar;
    contentDocument.getElementById('one-domain-checkbox').checked = options && options.isBlockOneDomain;

    if (options && (options.isBlockByUrl || options.isBlockSimilar)) {
      handleShowBlockSettings(options.isBlockByUrl, options.isBlockSimilar);
    }
  };

  var onSliderMove = function onSliderMove(element) {
    selectedElement = element;
    adguard_selector.selectElement(element);
    makeDefaultCheckboxesForDetailedMenu();
    onScopeChange();
    handleShowBlockSettings(haveUrlBlockParameter(element), haveClassAttribute(element));
  };

  var createSlider = function createSlider(setElement) {
    var parents = getParentsLevel(selectedElement);
    var children = getAllChildren(selectedElement);
    var value = Math.abs(parents.length + 1);
    var max = parents.length + children.length + 1;
    var min = 1;
    var options = {
      value: value,
      min: min,
      max: max
    };
    var slider = contentDocument.querySelector('#slider');
    var sliderArea = contentDocument.querySelector('#slider-area');

    if (min === max) {
      // hide slider text
      hide(slider);
      hide(contentDocument.querySelectorAll('.element-rule_text'));
      expandAdvanced();
    }

    options.onSliderMove = function (delta) {
      var elem;

      if (delta > 0) {
        elem = parents[delta - 1];
      }

      if (delta === 0) {
        elem = startElement;
      }

      if (delta < 0) {
        elem = children[Math.abs(delta + 1)];
      }

      onSliderMove(elem);
    };

    var currentVal = options.value; // set slider position on current element after returning from preview mode

    if (setElement) {
      var setElementparents = getParentsLevel(setElement);
      currentVal = setElementparents.length + 1;
    }

    slider_widget.init(slider, {
      min: options.min,
      max: options.max,
      value: currentVal,
      // eslint-disable-next-line no-shadow
      onValueChanged: function onValueChanged(value) {
        var delta = options.value - value;
        options.onSliderMove(delta);
      },
      sliderArea: sliderArea
    });
  };
  /*
   Called from IframeController._showMenuItem to initialize view
   */
  // eslint-disable-next-line no-shadow


  var init = function init(iframe, options) {
    selectedElement = options.element;
    startElement = selectedElement; // eslint-disable-next-line prefer-destructuring

    contentDocument = iframe.contentDocument; // eslint-disable-next-line prefer-destructuring

    currentElement = options.currentElement;
    bindEvents();
    createSlider(currentElement);
    onScopeChange();
    adguard_selector.selectElement(selectedElement); // select current element after returning from preview mode

    if (currentElement) {
      onSliderMove(currentElement);
    } // make input clickable with right mouse button for text editing


    events.add(contentDocument.getElementById('filter-rule'), 'contextmenu', function (e) {
      e.stopPropagation();
    });

    if (options.path) {
      setFilterRuleInputText(options.path);
      expandAdvanced();
    }

    if (options.options) {
      makeDefaultCheckboxesForDetailedMenu(options.options);
    }
  };

  return {
    init: init
  };
}
;// CONCATENATED MODULE: ./src/controllers/blockPreviewController.js



/**
 * Block preview controller
 * @param addRule
 * @param iframe
 * @returns {{init: init}}
 * @constructor
 */

function BlockPreviewController(addRule, iframe) {
  var contentDocument = null;
  var currentElement = null;
  var selectedElement = null;
  var selectedPath = null;
  var optionsState = null;
  var iframeCtrl = iframe;
  var previewStyleID = 'ag-preview-style-id';

  var showElement = function showElement() {
    iframeCtrl.showHiddenElements(previewStyleID);
  };

  var close = function close() {
    showElement();
    iframeCtrl.removeIframe();
  };

  var selectAnotherElement = function selectAnotherElement() {
    showElement();
    iframeCtrl.showSelectorMenu();
  };

  var blockElement = function blockElement(e) {
    e.stopPropagation();
    iframeCtrl.blockElement(selectedPath, addRule);
  };

  var showDetailedMenu = function showDetailedMenu() {
    showElement();
    iframeCtrl.showSliderMenu(currentElement, selectedElement, selectedPath, optionsState);
  };

  var bindEvents = function bindEvents() {
    var menuEvents = {
      '.close': close,
      '#select-another-element': selectAnotherElement,
      '#end-preview': showDetailedMenu,
      '#block-element': blockElement
    };
    Object.keys(menuEvents).forEach(function (item) {
      var elems = contentDocument.querySelectorAll(item);
      toArray(elems).forEach(function (elem) {
        return elem.addEventListener('click', menuEvents[item]);
      });
    });
  };

  var hideElement = function hideElement() {
    if (!selectedPath) {
      src_log.error('Can`t block element: `selector` path is empty');
      return;
    }

    iframeCtrl.hideElementsByPath(selectedPath, previewStyleID);
  };
  /*
   Called from IframeController.showMenuItem to initialize view
   */
  // eslint-disable-next-line no-shadow


  var init = function init(iframe, options) {
    selectedElement = options.element;
    selectedPath = options.path; // eslint-disable-next-line prefer-destructuring

    currentElement = options.currentElement; // eslint-disable-next-line prefer-destructuring

    contentDocument = iframe.contentDocument;
    optionsState = options.options;
    adguard_selector.reset();
    bindEvents();
    hideElement();
  };

  return {
    init: init
  };
}
;// CONCATENATED MODULE: ./src/utils/ui-validation-utils.js


/**
 * Utils that checks environment for compatibility with assistant
 * @returns {{
 * checkVisibleAreaSize: checkVisibleAreaSize,
 * validateBrowser: validateBrowser,
 * validatePage: validatePage,
 * getViewPort: getViewPort
 * }}
 * @constructor
 */

function UIValidationUtils() {
  var _window = window,
      document = _window.document;

  var getViewPort = function getViewPort() {
    var width = window.innerWidth;
    var height = window.innerHeight;
    return {
      width: width,
      height: height
    };
  };
  /**
   * Check if visible area are enough to show menu.
   * @returns boolean. True if area enough
   */


  var checkVisibleAreaSize = function checkVisibleAreaSize() {
    var viewPort = getViewPort(); // eslint-disable-next-line max-len

    var visibleAreaSize = viewPort.height > src_settings.Constants.MINIMUM_VISIBLE_HEIGHT_TO_SHOW_BUTTON;

    if (!visibleAreaSize) {
      src_log.error("Viewport height is too small: ".concat(viewPort.height));
    }

    return visibleAreaSize;
  };
  /**
   * Checks if browser is valid for Adguard assistant
   * @returns boolean. True if browser valid
   */


  var validateBrowser = function validateBrowser() {
    var valid = !document.documentMode || document.documentMode > src_settings.Constants.MINIMUM_IE_SUPPORTED_VERSION;

    if (!valid) {
      src_log.error("IE version is ".concat(document.documentMode));
    }

    return valid;
  };
  /**
   * Checks if page is valid for Adguard assistant to work here.
   */


  var validatePage = function validatePage() {
    // Assistant do not work in iframes
    if (window.window !== window.top) {
      return false;
    }

    return true;
  };

  return {
    checkVisibleAreaSize: checkVisibleAreaSize,
    validateBrowser: validateBrowser,
    validatePage: validatePage,
    getViewPort: getViewPort
  };
}

var uiValidationUtils = new UIValidationUtils();
/* harmony default export */ const ui_validation_utils = (uiValidationUtils);
;// CONCATENATED MODULE: ./src/utils/ui-utils.js



/**
 * UI utils
 * @returns {{
 *  makeElementDraggable: Function,
 *  makeIframeDraggable: Function,
 *  moveElementTo: Function,
`*  setAnchorPosition: Function,
 *  checkElementPosition: Function,
 * }}
 * @constructor
 */

function UIUtils() {
  var elWidth;
  var elHeight;
  var windowWidth;
  var windowHeight; // Stored button anchor position

  var storedAnchor = {};
  /**
   * Get original event object for touch
   * devices to getting current coordinates
   * @param {Object}
   * @returns {Object}
   */

  var getOriginalEvent = function getOriginalEvent(e) {
    return e.targetTouches ? e.targetTouches[0] : e;
  };

  var outsidePosition = {
    top: function top(pos) {
      return storedAnchor.top && (pos.y + elHeight > windowHeight || pos.y < 0);
    },
    bottom: function bottom(pos) {
      return !storedAnchor.top && (Math.abs(pos.y) + elHeight > windowHeight || pos.y > 0);
    },
    left: function left(pos) {
      return storedAnchor.left && (pos.x + elWidth > windowWidth || pos.x < 0);
    },
    right: function right(pos) {
      return !storedAnchor.left && (Math.abs(pos.x) + elWidth > windowWidth || pos.x > 0);
    }
  };
  /**
   * Set transition css property for drag
   * translate3d is for better rendering performance
   * see: https://www.html5rocks.com/en/tutorials/speed/layers/
   */

  var moveElementTo = function moveElementTo(el, x, y) {
    var transform = "translate3d(".concat(x, "px,").concat(y, "px, 0px)"); // eslint-disable-next-line no-param-reassign

    el.style.webkitTransform = transform; // eslint-disable-next-line no-param-reassign

    el.style.mozTransform = transform; // eslint-disable-next-line no-param-reassign

    el.style.msTransform = transform; // eslint-disable-next-line no-param-reassign

    el.style.oTransform = transform; // eslint-disable-next-line no-param-reassign

    el.style.transform = transform;
  }; // getting screen width and height without scroll bars


  var getWindowSize = function getWindowSize() {
    return {
      width: Math.min(document.documentElement.clientWidth, window.innerWidth || window.screen.width),
      height: Math.min(document.documentElement.clientHeight, window.innerHeight || window.screen.height)
    };
  };
  /**
   * Functions for saving left/top anchors and setting class position
   *
   * @param {Object} element  button element
   * @param {Boolean} anchor  anchors positions `true` for top/left or `false` for bottom/right
   */


  var setAnchorPosition = {
    positionY: function positionY(element, anchor) {
      storedAnchor.top = anchor;

      if (storedAnchor.top) {
        addClass(element, 'adguard-assistant-button-top');
        removeClass(element, 'adguard-assistant-button-bottom');
      } else {
        addClass(element, 'adguard-assistant-button-bottom');
        removeClass(element, 'adguard-assistant-button-top');
      }
    },
    positionX: function positionX(element, anchor) {
      storedAnchor.left = anchor;

      if (storedAnchor.left) {
        addClass(element, 'adguard-assistant-button-left');
        removeClass(element, 'adguard-assistant-button-right');
      } else {
        addClass(element, 'adguard-assistant-button-right');
        removeClass(element, 'adguard-assistant-button-left');
      }
    }
  };
  /**
   * Make element draggable
   * @param element
   * @param onDragEnd
   * @param onClick
   */

  function makeElementDraggable(element, onDragEnd, onClick) {
    var coords;
    var shiftX;
    var shiftY;
    /**
     * Prevent text selection
     * With cursor drag
     */

    var pauseEvent = function pauseEvent(e) {
      e.stopPropagation();
      e.preventDefault();
      e.cancelBubble = true;
      e.returnValue = false;
      return false;
    };

    var onMouseMove = function onMouseMove(e) {
      pauseEvent(e); // eslint-disable-next-line no-use-before-define

      moveAt(e);
    };

    var preventedEvent = function preventedEvent(e) {
      e.preventDefault();
    };

    var getCoords = function getCoords(elem) {
      var box = elem.getBoundingClientRect();
      return {
        top: box.top,
        left: box.left,
        bottom: box.bottom,
        right: box.right
      };
    };
    /**
     * On mouse up event
     * @param {Object} e  event object
     * @param {Boolean|undefined} doNotOpenIframe do not open the iframe if true.
     * This is necessary when the cursor is out of bounds
     */


    var onMouseUp = function onMouseUp(e, doNotOpenIframe) {
      e.stopPropagation(); // make scroll availalbe

      events.remove(document.documentElement, 'wheel mousewheel', preventedEvent); // When a user finishes dragging icon, we set icon anchor
      // depending on the icon position, i.e. which quarter
      // of the screen it belongs.

      var lastX;
      var lastY;
      var lastCoords = getCoords(element);
      var topHalf = lastCoords.top < windowHeight / 2;
      var leftHalf = lastCoords.left < windowWidth / 2;
      setAnchorPosition.positionY(element, topHalf);
      setAnchorPosition.positionX(element, leftHalf);

      if (topHalf) {
        lastY = lastCoords.top;
      } else {
        lastY = lastCoords.bottom - windowHeight;
      }

      if (leftHalf) {
        lastX = lastCoords.left;
      } else {
        lastX = lastCoords.right - windowWidth;
      }

      moveElementTo(element, lastX, lastY); // Open the frame if the button has been shifted by no more than 5 pixels

      if (Math.abs(coords.left - lastCoords.left) > 5 || Math.abs(coords.top - lastCoords.top) > 5) {
        if (onDragEnd) {
          var store = {
            x: lastX,
            y: lastY,
            storedAnchor: storedAnchor
          };
          onDragEnd(store);
        }
      } else if (onClick && !doNotOpenIframe) {
        onClick(e);
      }

      events.remove(document.documentElement, 'mouseup touchend pointerup', onMouseUp);
      events.remove(document.documentElement, 'mousemove touchmove pointermove', onMouseMove);
    };

    var moveAt = function moveAt(e) {
      var position = {
        x: getOriginalEvent(e).pageX - shiftX,
        y: getOriginalEvent(e).pageY - shiftY
      }; // disable mousemove if button element outside the screen

      var out = outsidePosition.top(position) || outsidePosition.left(position) || outsidePosition.bottom(position) || outsidePosition.right(position);

      if (out) {
        onMouseUp(e, true);
      } else {
        moveElementTo(element, position.x, position.y);
      }
    };

    var mouseDown = function mouseDown(e) {
      pauseEvent(e); // prevent browser scroll

      events.add(document.documentElement, 'wheel mousewheel', preventedEvent); // prevent right button mousedown

      if (e.button > 0) return;
      elWidth = element.clientWidth;
      elHeight = element.clientWidth;
      windowWidth = getWindowSize().width;
      windowHeight = getWindowSize().height;
      coords = getCoords(element);

      if (storedAnchor.top) {
        shiftY = getOriginalEvent(e).pageY - coords.top;
      } else {
        shiftY = windowHeight - (coords.bottom - getOriginalEvent(e).pageY);
      }

      if (storedAnchor.left) {
        shiftX = getOriginalEvent(e).pageX - coords.left;
      } else {
        shiftX = windowWidth - (coords.right - getOriginalEvent(e).pageX);
      }
      /**
       * binding both mouse and touch/pointer events simultaneously
       * see: http://www.html5rocks.com/en/mobile/touchandmouse/
       */


      events.add(document.documentElement, 'mouseup touchend pointerup', onMouseUp);
      events.add(document.documentElement, 'mousemove touchmove pointermove', onMouseMove);
    };

    events.add(element, 'mousedown touchstart', src_protectedApi.functionBind.call(mouseDown, this));
    events.add(element, 'dragstart', function () {});
  }
  /**
   * Makes iframe draggable
   *
   * @param iframe
   * @param handleElement
   */


  var makeIframeDraggable = function makeIframeDraggable(iframe, handleElement) {
    var iframeDoc = iframe.contentDocument;
    var offset = Object.create(null);
    /**
     * Function that does actual "dragging"
     *
     * @param x
     * @param y
     */

    var drag = function drag(x, y) {
      // eslint-disable-next-line no-param-reassign
      iframe.style.left = "".concat(x, "px"); // eslint-disable-next-line no-param-reassign

      iframe.style.top = "".concat(y, "px");
    };

    var cancelIFrameSelection = function cancelIFrameSelection(e) {
      e.preventDefault();
      e.stopPropagation();
    };

    var onMouseMove = function onMouseMove(e) {
      var eventPosition = getOriginalEvent(e);
      drag(eventPosition.screenX + offset.x, eventPosition.screenY + offset.y);
    };

    var onMouseDown = function onMouseDown(e) {
      var eventPosition = getOriginalEvent(e);
      var rect = iframe.getBoundingClientRect();
      offset.x = rect.left + handleElement.offsetLeft - eventPosition.screenX;
      offset.y = rect.top + handleElement.offsetTop - eventPosition.screenY;
      events.add(iframeDoc, 'mousemove touchmove pointermove', onMouseMove);
      events.add(iframeDoc, 'selectstart', cancelIFrameSelection);
    };

    var onMouseUp = function onMouseUp() {
      events.remove(iframeDoc, 'mousemove touchmove pointermove', onMouseMove);
      events.remove(iframeDoc, 'selectstart', cancelIFrameSelection);
    }; // prevent iframe dragging while browser tabs is switching


    document.addEventListener('visibilitychange', onMouseUp);
    events.add(handleElement, 'mousedown touchstart', onMouseDown);
    events.add(iframeDoc, 'mouseup touchend pointerup', onMouseUp);
    events.add(iframeDoc, 'contextmenu', function (e) {
      e.preventDefault();
      return false;
    });
  };

  var checkElementPosition = function checkElementPosition(element, pos) {
    var position = pos;
    windowWidth = getWindowSize().width;
    windowHeight = getWindowSize().height;
    elWidth = element.clientWidth;
    elHeight = element.clientHeight;
    if (outsidePosition.top(position)) position.y = windowHeight - 60;
    if (outsidePosition.bottom(position)) position.y = -windowHeight + 60;
    if (outsidePosition.left(position)) position.x = windowWidth - 60;
    if (outsidePosition.right(position)) position.x = -windowWidth + 60;
    moveElementTo(element, position.x, position.y);
  };

  return {
    makeElementDraggable: makeElementDraggable,
    makeIframeDraggable: makeIframeDraggable,
    moveElementTo: moveElementTo,
    setAnchorPosition: setAnchorPosition,
    checkElementPosition: checkElementPosition
  };
}

var uiUtils = new UIUtils();
/* harmony default export */ const ui_utils = (uiUtils);
;// CONCATENATED MODULE: ./src/button.js








/**
 * Adguard assistant button
 * @returns {{show: show, remove: remove}}
 * @constructor
 */

function UIButton() {
  var button = null;
  var buttonElement = null;
  var isFullScreenEventsRegistered = false;
  var iframeController = null; // Important attribute for all inline stylesheets.
  // It needs for Content-Security-Policy.

  var getStyleNonce = function getStyleNonce() {
    var adgSettings = src_settings.getAdguardSettings();

    if (adgSettings === null) {
      return '';
    }

    return adgSettings.nonce;
  };

  var isButtonAlreadyInDOM = function isButtonAlreadyInDOM() {
    var alert = document.querySelector('.adguard-alert');

    if (alert) {
      src_log.error('Assistant button is already in DOM');
      return true;
    }

    return false;
  };
  /**
   * Checking browser and other requirements.
   * @private
   */


  var checkRequirements = function checkRequirements() {
    if (!ui_validation_utils.validateBrowser()) {
      return false;
    }

    if (!ui_validation_utils.validatePage()) {
      return false;
    }

    if (!ui_validation_utils.checkVisibleAreaSize()) {
      return false;
    }

    if (isButtonAlreadyInDOM()) {
      return false;
    }

    return true;
  };
  /**
   * Set a special classes for the pages on which
   * under the button there are important elements
   * issue: https://github.com/AdguardTeam/AdguardAssistant/issues/32
   */


  var respectPageElements = function respectPageElements(btn) {
    var buttonInRightBottom = hasClass(btn, 'adguard-assistant-button-bottom') && hasClass(btn, 'adguard-assistant-button-right');

    if (buttonInRightBottom && document.location.hostname.indexOf('vk.com') >= 0) {
      addClass(btn, 'adguard-assistant-button-respect adguard-assistant-button-respect-vk');
    }

    if (buttonInRightBottom && document.location.hostname.indexOf('facebook.com') >= 0) {
      addClass(btn, 'adguard-assistant-button-respect adguard-assistant-button-respect-fb');
    }

    return false;
  };

  var setPositionSettingsToButton = function setPositionSettingsToButton(btn) {
    var position = src_settings.getUserPositionForButton();

    if (src_settings.getIconSize()) {
      addClass(btn, 'logo-small');
    } // The anchor determines from which side of the
    // browser the positions of `position.x`, `position.y`.
    // If `position` parameter is not defined,
    // so the position of the button is set in the corners of the browser


    if (position && position.storedAnchor) {
      ui_utils.setAnchorPosition.positionY(btn, position.storedAnchor.top);
      ui_utils.setAnchorPosition.positionX(btn, position.storedAnchor.left);
      ui_utils.moveElementTo(btn, position.x, position.y);
      ui_utils.checkElementPosition(btn, position);
      return false;
    } // Getting the corner of the browser where the button is placed


    var side = src_settings.getButtonSide();

    if (side) {
      ui_utils.setAnchorPosition.positionY(btn, side.top);
      ui_utils.setAnchorPosition.positionX(btn, side.left);
      respectPageElements(btn);
    }

    return undefined;
  };
  /**
   * Get center button position
   * @returns {{left: *, top: *}}
   * @private
   */


  var getButtonPosition = function getButtonPosition(btn) {
    var box = btn.getBoundingClientRect();
    return {
      top: box.top + btn.offsetHeight / 2,
      left: box.left + btn.offsetWidth / 2
    };
  };

  var hideButton = function hideButton() {
    if (!button) {
      return;
    }

    button.style.setProperty('display', 'none', 'important');
  };

  var showButton = function showButton() {
    if (!button) {
      return;
    }

    button.style.setProperty('display', 'block', 'important');
  };

  var hideRestoreOnFullScreen = function hideRestoreOnFullScreen() {
    if (isFullScreenEventsRegistered) {
      return;
    }

    var isFullScreen = false;

    var onFullScreen = function onFullScreen() {
      if (!isFullScreen) {
        hideButton();
        isFullScreen = true;
      } else {
        showButton();
        isFullScreen = false;
      }
    };

    document.addEventListener('webkitfullscreenchange', onFullScreen);
    document.addEventListener('mozfullscreenchange', onFullScreen);
    document.addEventListener('fullscreenchange', onFullScreen);
    isFullScreenEventsRegistered = true;
  };

  var registerEvents = function registerEvents(btn) {
    var onDragEnd = function onDragEnd(data) {
      src_settings.setUserPositionForButton(data);
    };

    var openMenu = function openMenu() {
      iframeController.setButtonPosition(getButtonPosition(btn));
      iframeController.showDetailedMenu();
    };

    ui_utils.makeElementDraggable(btn, onDragEnd, openMenu);
    hideRestoreOnFullScreen();
  };
  /**
   * Shows Adguard initial button
   */


  var show = function show() {
    // TODO: get rid of it
    iframeController = src_ioc.get('iframeController');
    iframeController.onCloseMenu.attach(showButton);
    iframeController.onShowMenuItem.attach(hideButton);

    if (!checkRequirements()) {
      src_log.info('Environment doesn\'t satisfy requirements, so don\'t show Adguard');
      return;
    }

    if (button) {
      return;
    }

    src_log.debug('Requirements checked, all ok');
    buttonElement = src_protectedApi.createElement('div');
    buttonElement.innerHTML = HTML.button;
    button = buttonElement.firstChild;
    var adgStylesButton;

    if (src_protectedApi.checkShadowDomSupport()) {
      var shadowbuttonElement = buttonElement.attachShadow({
        mode: 'closed'
      });
      adgStylesButton = src_protectedApi.createStylesElement(CSS.common + CSS.button, getStyleNonce());
      shadowbuttonElement.appendChild(adgStylesButton);
      shadowbuttonElement.appendChild(button);
      document.documentElement.appendChild(buttonElement);
    } else {
      adgStylesButton = src_protectedApi.createStylesElement(CSS.button, getStyleNonce(), 'adg-styles-button');

      if (adgStylesButton) {
        document.documentElement.appendChild(adgStylesButton);
      }

      document.documentElement.appendChild(button);
      buttonElement = button;
    }

    setPositionSettingsToButton(button);
    registerEvents(button);
  };

  var removeButton = function removeButton() {
    if (!button) {
      return;
    }

    document.documentElement.removeChild(buttonElement);
    button = null;
  };

  return {
    show: show,
    remove: removeButton
  };
}

var button_button = new UIButton();
/* harmony default export */ const src_button = (button_button);
;// CONCATENATED MODULE: ./src/controllers/settingsMenuController.js



/**
 * Settings menu controller
 * @returns {{init: init}}
 * @constructor
 */

function SettingsMenuController(iframe) {
  var contentDocument = null;
  var iframeCtrl = iframe;
  var buttonSides = {
    'position-bottom-right': {
      top: false,
      left: false
    },
    'position-bottom-left': {
      top: false,
      left: true
    },
    'position-top-right': {
      top: true,
      left: false
    },
    'position-top-left': {
      top: true,
      left: true
    }
  };

  var close = function close() {
    iframeCtrl.removeIframe();
  };

  var setIconSize = function setIconSize() {
    var smallIcon = contentDocument.getElementById('size-small').checked;
    src_settings.setIconSize(smallIcon);
  };

  var setPersonalParam = function setPersonalParam() {
    var personalConfig = contentDocument.getElementById('this-site').checked;
    src_settings.setPersonalParam(personalConfig);
  };

  var setButtonSide = function setButtonSide() {
    var sideItem = null;
    Object.keys(buttonSides).forEach(function (item) {
      if (contentDocument.getElementById(item).checked) {
        sideItem = item;
      }
    });

    if (sideItem) {
      src_settings.setButtonSide(buttonSides[sideItem]);
    }
  };

  var setDefaultSettings = function setDefaultSettings() {
    if (src_settings.getIconSize()) {
      contentDocument.getElementById('size-small').checked = true;
    } else {
      contentDocument.getElementById('size-big').checked = true;
    }

    if (src_settings.getPersonalConfig()) {
      contentDocument.getElementById('this-site').checked = true;
    } else {
      contentDocument.getElementById('all-site').checked = true;
    }

    var position = src_settings.getUserPositionForButton();

    if (position) {
      return;
    }

    var sideFromSettings = src_settings.getButtonSide();
    Object.keys(buttonSides).forEach(function (item) {
      var sideItem = buttonSides[item];

      if (sideItem.left === sideFromSettings.left && sideItem.top === sideFromSettings.top) {
        contentDocument.getElementById(item).checked = true;
      }
    });
  };

  var saveSettings = function saveSettings() {
    setPersonalParam();
    setIconSize();
    setButtonSide();
    src_settings.saveSettings();
    close();
    src_button.remove();
    src_button.show();
  };

  var bindEvents = function bindEvents() {
    var menuEvents = {
      '.close': close,
      '#cancel': iframeCtrl.showDetailedMenu,
      '#save-settings': saveSettings
    };
    Object.keys(menuEvents).forEach(function (item) {
      var elems = contentDocument.querySelectorAll(item);
      toArray(elems).forEach(function (elem) {
        return elem.addEventListener('click', menuEvents[item]);
      });
    });
  };
  /*
   Called from IframeController._showMenuItem to initialize view
   */
  // eslint-disable-next-line no-shadow


  var init = function init(iframe) {
    // eslint-disable-next-line prefer-destructuring
    contentDocument = iframe.contentDocument;
    bindEvents();
    setDefaultSettings();
  };

  return {
    init: init
  };
}
;// CONCATENATED MODULE: ./src/iframe.js

















/**
 * Manages iframe and it's content
 * @returns {{
 * showDetailedMenu: showDetailedMenu,
 * showSelectorMenu: showSelectorMenu,
 * showSliderMenu: showSliderMenu,
 * showBlockPreview: showBlockPreview,
 * showSettingsMenu: showSettingsMenu,
 * setButtonPosition: setButtonPosition,
 * onCloseMenu: CustomEvent,
 * onShowMenuItem: CustomEvent,
 * removeIframe: removeIframe,
 * resizeSliderMenuToAdvanced: resizeSliderMenuToAdvanced,
 * resizeSliderMenuToNormal: resizeSliderMenuToNormal
 * }}
 * @constructor
 */

function IframeController() {
  var iframe = null;
  var iframeAnchor = null;
  var currentItem = null;
  var iframeMaxWidth = 320;
  var iframeMaxHeight = 407;
  var menuMaxWidth = 668;
  var settingsMaxWidth = 458;
  var iframePositionOffset = 20;
  var buttonPosition = null;
  var blockedElementsStyleID = 'ag-hide-elements-style-id';
  var views = {};
  views[src_settings.MenuItemsNames.DetailedMenu] = HTML.detailed_menu;
  views[src_settings.MenuItemsNames.SelectorMenu] = HTML.selector_menu;
  views[src_settings.MenuItemsNames.SliderMenu] = HTML.slider_menu;
  views[src_settings.MenuItemsNames.BlockPreview] = HTML.preview;
  views[src_settings.MenuItemsNames.SettingsMenu] = HTML.settings_menu;
  if (window.innerWidth < menuMaxWidth) menuMaxWidth = window.innerWidth;
  if (window.innerWidth < settingsMaxWidth) settingsMaxWidth = window.innerWidth;
  var onCloseMenu = new CustomEvent();
  var onShowMenuItem = new CustomEvent(); // Important attribute for all inline stylesheets.
  // It needs for Content-Security-Policy.

  var getStyleNonce = function getStyleNonce() {
    var adgSettings = src_settings.getAdguardSettings();

    if (adgSettings === null) {
      return '';
    }

    return adgSettings.nonce;
  };

  var createShadowRootElement = function createShadowRootElement(iframeAnc) {
    var shadowiframeAnchor = iframeAnc.attachShadow({
      mode: 'closed'
    });
    var stylesElement = src_protectedApi.createStylesElement(CSS.common + CSS.iframe, getStyleNonce());
    shadowiframeAnchor.appendChild(stylesElement);
    return shadowiframeAnchor;
  };

  var createIframe = function createIframe(onIframeLoadCallback) {
    src_log.debug('Creating iframe');
    iframe = src_protectedApi.createElement('iframe'); // IE hack for prevent access denied error
    // see: https://stackoverflow.com/questions/1886547/access-is-denied-javascript-error-when-trying-to-access-the-document-object-of

    if (navigator.userAgent.match(/msie/i)) {
      iframe.src = "javascript:'<script>window.onload=function(){document.write(\\'<script>document.domain=\\\"".concat(document.domain, "\\\";<\\\\/script>\\');document.close();};</script>'");
    }

    var attributes = {
      id: src_settings.Constants.IFRAME_ID,
      "class": adguard_selector.ignoreClassName(),
      frameBorder: 0,
      allowTransparency: 'true'
    };
    Object.keys(attributes).forEach(function (item) {
      iframe.setAttribute(item, attributes[item]);
    });
    var iframeAlreadyLoaded = false;
    iframe.addEventListener('load', function () {
      if (iframeAlreadyLoaded) {
        // IE calls load each time when we use document.close
        return;
      }

      iframeAlreadyLoaded = true;
      onIframeLoadCallback();
    });

    if (src_protectedApi.checkShadowDomSupport()) {
      iframeAnchor = src_protectedApi.createElement('div');
      createShadowRootElement(iframeAnchor).appendChild(iframe);
    } else {
      iframeAnchor = iframe;
    }

    document.documentElement.appendChild(iframeAnchor);
  };

  var getIframePosition = function getIframePosition() {
    var viewPort = ui_validation_utils.getViewPort();

    if (!buttonPosition) {
      return {
        left: iframe.offsetLeft <= 0 ? window.innerWidth : iframe.offsetLeft,
        top: parseInt(iframe.style.top, 10) || iframePositionOffset
      };
    }

    var defaultPosition = {
      left: buttonPosition.left,
      top: buttonPosition.top
    };
    var sides = [{
      // left top
      left: buttonPosition.left - iframeMaxWidth - iframePositionOffset,
      top: buttonPosition.top - iframeMaxHeight - iframePositionOffset
    }, {
      // right top
      left: buttonPosition.left + iframePositionOffset,
      checkLeft: buttonPosition.left + iframeMaxWidth + iframePositionOffset,
      top: buttonPosition.top - iframeMaxHeight - iframePositionOffset
    }, {
      // bottom right
      left: buttonPosition.left + iframePositionOffset,
      checkLeft: buttonPosition.left + iframeMaxWidth + iframePositionOffset,
      checkTop: buttonPosition.top + iframeMaxHeight + iframePositionOffset,
      top: buttonPosition.top + iframePositionOffset
    }, {
      // bottom left
      left: buttonPosition.left - iframeMaxWidth - iframePositionOffset,
      checkTop: buttonPosition.top + iframeMaxHeight + iframePositionOffset,
      top: buttonPosition.top + iframePositionOffset
    }];

    for (var i = 0; i < sides.length; i += 1) {
      var currentSide = sides[i];
      var left = currentSide.checkLeft ? currentSide.checkLeft : currentSide.left;
      var top = currentSide.checkTop ? currentSide.checkTop : currentSide.top;

      if (left < 0 || left > viewPort.width) {
        // eslint-disable-next-line no-continue
        continue;
      }

      if (top < 0 || top > viewPort.height) {
        // eslint-disable-next-line no-continue
        continue;
      }

      return currentSide;
    }

    return defaultPosition;
  };

  var specifyIframePosition = function specifyIframePosition() {
    var viewPort = ui_validation_utils.getViewPort();

    if (iframe.offsetLeft + iframe.offsetWidth > viewPort.width) {
      iframe.style.left = "".concat(Math.max(0, viewPort.width - iframe.offsetWidth - iframePositionOffset), "px");
    }

    if (iframe.offsetLeft < 0) {
      iframe.style.left = "".concat(iframePositionOffset, "px");
    }

    if (iframe.offsetTop + iframe.offsetHeight > viewPort.height) {
      iframe.style.top = "".concat(Math.max(0, viewPort.height - iframe.offsetHeight - iframePositionOffset), "px");
    }

    if (iframe.offsetHeight < 0) {
      iframe.style.top = "".concat(iframePositionOffset, "px");
    }
  };

  var appendContent = function appendContent(view) {
    var body = iframe.contentDocument.body;

    for (var i = 0; i < body.children.length; i += 1) {
      body.removeChild(body.children[i]);
    }

    body.appendChild(view);
  };

  var localize = function localize() {
    var elements = iframe.contentDocument.querySelectorAll('[i18n]');

    for (var i = 0; i < elements.length; i += 1) {
      var message = src_localization.getMessage(elements[i].getAttribute('i18n'));
      src_localization.translateElement(elements[i], message);
    }
  };

  var resizeIframe = function resizeIframe(width, height) {
    var frame = iframe; // setting iframe height dynamically based on inner content

    if (height === 'auto' || !height) {
      // eslint-disable-next-line no-param-reassign
      height = frame.contentWindow.document.body.querySelector('.main').clientHeight || iframeMaxHeight;
    }

    if (width) {
      frame.width = width;
      frame.style.setProperty('width', "".concat(width, "px"), 'important');
    }

    if (height) {
      frame.height = height;
      frame.style.setProperty('height', "".concat(height, "px"), 'important');
    }
  };

  var showMenuItem = function showMenuItem(viewName, controller, width, height, options) {
    src_log.debug("Showing menu item: ".concat(viewName));

    if (currentItem === viewName) {
      return;
    }

    var onIframeLoad = function onIframeLoad() {
      var frameElement = iframe;
      var view = src_protectedApi.createElement(views[viewName]);
      var stylesElement = src_protectedApi.createStylesElement(CSS.common + CSS.button + CSS.iframe, getStyleNonce());
      view.appendChild(stylesElement);
      appendContent(view);
      localize();

      if (!options) {
        // eslint-disable-next-line no-param-reassign
        options = {};
      } // eslint-disable-next-line no-param-reassign


      options.iframeAnchor = iframeAnchor;
      controller.init(frameElement, options);
      currentItem = viewName;
      onShowMenuItem.notify();

      if (options.dragElement) {
        ui_utils.makeIframeDraggable(iframe, iframe.contentDocument.querySelector(options.dragElement));
      } // make iframe size as like internal content size


      resizeIframe(width, height);
      var iframePosition = getIframePosition();
      iframe.style.left = "".concat(iframePosition.left, "px");
      iframe.style.top = "".concat(iframePosition.top, "px"); // fixing iframe position after resize, to avoid iframe outside of the viewport

      specifyIframePosition();
    };

    if (!iframe) {
      var adgStylesSelector = src_protectedApi.createStylesElement(CSS.selector, getStyleNonce(), 'adg-styles-selector');

      if (adgStylesSelector) {
        document.documentElement.appendChild(adgStylesSelector);
      }

      createIframe(onIframeLoad);
      return;
    }

    onIframeLoad();
  };

  var setButtonPosition = function setButtonPosition(coords) {
    buttonPosition = coords;
  }; // e.isTrusted checking for prevent programmatically events
  // see: https://github.com/AdguardTeam/AdguardAssistant/issues/134


  var removeIframe = function removeIframe(e) {
    if (e && e.isTrusted === false) {
      return false;
    }

    if (!iframeAnchor) {
      return false;
    }

    document.removeEventListener('click', removeIframe);
    document.documentElement.removeChild(iframeAnchor);
    iframe = null;
    iframeAnchor = null;
    currentItem = null;
    adguard_selector.close();
    onCloseMenu.notify();
    return undefined;
  };

  var setCloseEventIfNotHitIframe = function setCloseEventIfNotHitIframe(setEvent) {
    document.removeEventListener('click', removeIframe);

    if (setEvent) {
      window.setTimeout(function () {
        document.addEventListener('click', removeIframe);
      }, 150);
    }
  };

  var showDetailedMenu = function showDetailedMenu() {
    var controller = new DetailedMenuController(src_ioc.get('iframeController'));
    var options = {
      dragElement: '.menu-head'
    };
    showMenuItem(src_settings.MenuItemsNames.DetailedMenu, controller, iframeMaxWidth, 'auto', options);
    setCloseEventIfNotHitIframe(true);
  };

  var showSelectorMenu = function showSelectorMenu() {
    var controller = new SelectorMenuController(src_ioc.get('iframeController'));
    var options = {
      dragElement: '.head'
    };
    showMenuItem(src_settings.MenuItemsNames.SelectorMenu, controller, menuMaxWidth, 160, options);
    setCloseEventIfNotHitIframe(false);
  };

  var showSliderMenu = function showSliderMenu(initElement, currentElement, path, optionsState) {
    var controller = new SliderMenuController(src_ioc.get('addRule'), src_ioc.get('iframeController'));
    var options = {
      path: path,
      currentElement: currentElement,
      element: initElement,
      dragElement: '.head',
      options: optionsState
    };
    showMenuItem(src_settings.MenuItemsNames.SliderMenu, controller, menuMaxWidth, 'auto', options);
    setCloseEventIfNotHitIframe(true);
  };

  var showBlockPreview = function showBlockPreview(initElement, path, currentElement, optionsState) {
    var controller = new BlockPreviewController(src_ioc.get('addRule'), src_ioc.get('iframeController'));
    var options = {
      path: path,
      currentElement: currentElement,
      element: initElement,
      dragElement: '.head',
      options: optionsState
    };
    showMenuItem(src_settings.MenuItemsNames.BlockPreview, controller, menuMaxWidth, 'auto', options);
    setCloseEventIfNotHitIframe(true);
  };

  var showSettingsMenu = function showSettingsMenu() {
    var controller = new SettingsMenuController(src_ioc.get('iframeController'));
    var options = {
      dragElement: '.head'
    };
    showMenuItem(src_settings.MenuItemsNames.SettingsMenu, controller, 400, 468, options);
    setCloseEventIfNotHitIframe(true);
  };

  var resizeSliderMenuToAdvanced = function resizeSliderMenuToAdvanced() {
    resizeIframe(null, null);
  };

  var resizeSliderMenuToNormal = function resizeSliderMenuToNormal() {
    resizeIframe(null, null);
  };

  var hideElementsByPath = function hideElementsByPath(selectedPath, styleID) {
    if (!selectedPath) {
      return false;
    }

    var slctr;
    var style;

    if (selectedPath.indexOf('://') > 0) {
      // all images by src
      slctr = "[src*=\"".concat(selectedPath.split('$domain=')[0], "\"]");
    } else {
      // eslint-disable-next-line prefer-destructuring
      slctr = selectedPath.split('##')[1];
    }

    if (slctr) {
      style = "".concat(slctr, "{display:none!important}");
    } else {
      src_log.error('Can`t block element: `selector` path is empty');
      return false;
    }

    if (!styleID) {
      // eslint-disable-next-line no-param-reassign
      styleID = blockedElementsStyleID;
    }

    var stylesElement = document.documentElement.querySelector("#".concat(styleID));

    if (stylesElement) {
      stylesElement.innerHTML = "".concat(stylesElement.innerHTML, " ").concat(style);
    } else {
      document.documentElement.appendChild(src_protectedApi.createStylesElement(style, getStyleNonce(), styleID));
    } // do not hide assistant div if the user wrote a rule
    // that blocks all div or iframe elements


    if (iframeAnchor) {
      iframeAnchor.style.setProperty('display', 'block', 'important');
    }

    return undefined;
  }; // show elements hidden by `hideElementsByPath` function


  var showHiddenElements = function showHiddenElements(styleID) {
    if (!styleID) {
      // eslint-disable-next-line no-param-reassign
      styleID = blockedElementsStyleID;
    }

    var stylesElement = document.documentElement.querySelector("#".concat(styleID));

    if (stylesElement) {
      stylesElement.parentNode.removeChild(stylesElement);
    }
  };

  var blockElement = function blockElement(path, addRule) {
    if (gm.ADG_addRule) {
      gm.ADG_addRule(path, function () {
        removeIframe();
        hideElementsByPath(path);
        bypassCache();
      });
    } else {
      if (!addRule) {
        src_log.error('Callback function `addRule` can\'t be undefined!');
      }

      addRule(path);
      removeIframe();
      hideElementsByPath(path);
      bypassCache();
    }
  };

  return {
    showDetailedMenu: showDetailedMenu,
    showSelectorMenu: showSelectorMenu,
    showSliderMenu: showSliderMenu,
    showBlockPreview: showBlockPreview,
    showSettingsMenu: showSettingsMenu,
    setButtonPosition: setButtonPosition,
    onCloseMenu: onCloseMenu,
    onShowMenuItem: onShowMenuItem,
    removeIframe: removeIframe,
    resizeSliderMenuToAdvanced: resizeSliderMenuToAdvanced,
    resizeSliderMenuToNormal: resizeSliderMenuToNormal,
    resizeIframe: resizeIframe,
    hideElementsByPath: hideElementsByPath,
    showHiddenElements: showHiddenElements,
    blockElement: blockElement
  };
}

/* harmony default export */ const iframe = (IframeController);
;// CONCATENATED MODULE: ./src/controllers/sliderMenuControllerMobile.js



/**
 * Slider menu controller mobile
 * @param addRule
 * @param iframe
 * @returns {{init: init}}
 * @constructor
 */

function SliderMenuControllerMobile(addRule, iframe) {
  var contentDocument = null;
  var selectedElement = null;
  var iframeCtrl = iframe;
  var nodeParentsCount = 0;
  var nodeChildsCount = 0;
  var parents;
  var children;
  var nodeNumber = 0;

  function showPreview() {
    adguard_selector.reset();

    if (this.classList.contains('active')) {
      removeClass(selectedElement, 'sg_hide_element');
      removeClass(this, 'active');
      adguard_selector.selectElement(selectedElement);
      contentDocument.querySelector('.adg-plus').removeAttribute('disabled');
      contentDocument.querySelector('.adg-minus').removeAttribute('disabled');
      contentDocument.querySelector('.adg-close').removeAttribute('disabled');
    } else {
      addClass(selectedElement, 'sg_hide_element');
      addClass(this, 'active');
      contentDocument.querySelector('.adg-plus').setAttribute('disabled', 'disabled');
      contentDocument.querySelector('.adg-minus').setAttribute('disabled', 'disabled');
      contentDocument.querySelector('.adg-close').setAttribute('disabled', 'disabled');
    }
  }

  var getUrlBlockAttribute = function getUrlBlockAttribute(element) {
    var urlBlockAttributes = ['src', 'data'];

    for (var i = 0; i < urlBlockAttributes.length; i += 1) {
      var attr = urlBlockAttributes[i];
      var value = element.getAttribute(attr);

      if (value) {
        return value;
      }
    }

    return null;
  };

  var getFilterText = function getFilterText() {
    var options = {
      urlMask: getUrlBlockAttribute(selectedElement),
      cssSelectorType: 'STRICT_FULL',
      isBlockOneDomain: false,
      url: document.location,
      ruleType: 'CSS'
    };
    return adguard_rules_constructor.constructRuleText(selectedElement, options);
  };

  var blockElement = function blockElement() {
    selectedElement.classList.remove('sg_hide_element');
    selectedElement.style.display = 'none';
    addRule(getFilterText());
    iframeCtrl.removeIframe();
  };

  var onSliderMove = function onSliderMove(element) {
    selectedElement = element;
    adguard_selector.selectElement(element);
  };

  var plus = function plus() {
    nodeNumber = nodeNumber + 1 > nodeParentsCount ? nodeNumber : nodeNumber + 1;

    if (nodeNumber >= 0) {
      if (parents[nodeNumber]) onSliderMove(parents[nodeNumber]); // eslint-disable-next-line no-bitwise
    } else if (children[~nodeNumber]) onSliderMove(children[~nodeNumber]);
  };

  var minus = function minus() {
    // TODO: rewrite this
    // eslint-disable-next-line no-unused-expressions, no-self-assign
    nodeNumber <= -nodeChildsCount ? nodeNumber = nodeNumber : nodeNumber -= 1;

    if (nodeNumber >= 0) {
      if (parents[nodeNumber]) onSliderMove(parents[nodeNumber]); // eslint-disable-next-line no-bitwise
    } else if (children[~nodeNumber]) onSliderMove(children[~nodeNumber]);
  };

  var bindEvents = function bindEvents() {
    var menuEvents = {
      '.adg-close': iframeCtrl.showSelectorMenu,
      '.adg-preview': showPreview,
      '.adg-accept': blockElement,
      '.adg-plus': plus,
      '.adg-minus': minus
    };
    Object.keys(menuEvents).forEach(function (item) {
      var elems = contentDocument.querySelectorAll(item);
      toArray(elems).forEach(function (elem) {
        return elem.addEventListener('click', menuEvents[item]);
      });
    });
    window.addEventListener('orientationchange', iframeCtrl.showSelectorMenu);
  };
  /*
   Called from IframeController._showMenuItem to initialize view
   */
  // eslint-disable-next-line no-shadow


  var init = function init(iframe, options) {
    selectedElement = options.element; // eslint-disable-next-line prefer-destructuring

    contentDocument = iframe.contentDocument;
    bindEvents();
    adguard_selector.selectElement(selectedElement);
    children = getAllChildren(selectedElement);
    parents = getParentsLevel(selectedElement);
    parents.splice(0, 0, selectedElement);
    nodeParentsCount = parents.length;
    nodeChildsCount = children.length;
  };

  return {
    init: init
  };
}
;// CONCATENATED MODULE: ./package.json
const package_namespaceObject = {"i8":"4.3.68"};
;// CONCATENATED MODULE: ./src/iframe.mobile.js
function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }











/**
 * Manages iframe and it's content
 * @returns {{
 * showSelectorMenu: showSelectorMenu,
 * showSliderMenu: showSliderMenu,
 * setButtonPosition: setButtonPosition,
 * onCloseMenu: CustomEvent,
 * onShowMenuItem: CustomEvent,
 * removeIframe: removeIframe
 * }}
 * @constructor
 */

function IframeControllerMobile() {
  var iframe = null;
  var iframeElement = null;
  var currentItem = null;
  var onCloseMenu = new CustomEvent();
  var onShowMenuItem = new CustomEvent();
  var views = {};
  views['mobilePopup.html'] = HTML.popup;
  views['mobileMenu.html'] = HTML.mobile_menu;
  var defaultCSS = {
    clip: 'auto',
    'z-index': 2147483647
  };
  var defaultAttributes = {
    "class": adguard_selector.ignoreClassName(),
    frameBorder: 0,
    allowTransparency: 'true',
    id: 'iframe-x2eRYVVQRsG9'
  };

  var updateIframeAttrs = function updateIframeAttrs(attrs) {
    iframe.removeAttribute('style');
    iframe.removeAttribute('height');

    var attributes = _objectSpread(_objectSpread({}, defaultAttributes), attrs);

    Object.keys(attributes).forEach(function (item) {
      iframe.setAttribute(item, attributes[item]);
    });
  };

  var updateIframeStyles = function updateIframeStyles(styles) {
    var css = _objectSpread(_objectSpread({}, defaultCSS), styles);

    Object.keys(css).forEach(function (item) {
      iframe.style[item] = css[item];
    });
  };

  var createIframe = function createIframe(onIframeLoadCallback, styles, attrs) {
    src_log.debug('Creating iframe');

    if (document.querySelector("#".concat(defaultAttributes.id))) {
      src_log.error('Iframe already added');
      return;
    }

    iframe = src_protectedApi.createElement('iframe');
    iframe.addEventListener('load', function () {
      onIframeLoadCallback();
      updateIframeAttrs(attrs);
      updateIframeStyles(styles);
    });
    iframeElement = iframe;
    var adgStylesSelector = src_protectedApi.createStylesElement(CSS.selector, 'adg-styles-selector');

    if (adgStylesSelector) {
      document.documentElement.appendChild(adgStylesSelector);
    }

    document.documentElement.appendChild(iframeElement);
  };

  var appendContent = function appendContent(view) {
    var body = iframe.contentDocument.body;

    for (var i = 0; i < body.children.length; i += 1) {
      body.removeChild(body.children[i]);
    }

    body.appendChild(view);
  };

  var localize = function localize() {
    var elements = iframe.contentDocument.querySelectorAll('[i18n]');

    for (var i = 0; i < elements.length; i += 1) {
      var message = src_localization.getMessage(elements[i].getAttribute('i18n'));
      src_localization.translateElement(elements[i], message);
    }

    var elementsWithTitle = iframe.contentDocument.querySelectorAll('[i18n-title]');

    for (var j = 0; j < elementsWithTitle.length; j += 1) {
      var title = src_localization.getMessage(elementsWithTitle[j].getAttribute('i18n-title'));
      elementsWithTitle[j].setAttribute('title', title);
    }
  };

  var hideIframe = function hideIframe() {
    if (iframe) {
      iframe.style.display = 'none';
    }
  };

  var showIframe = function showIframe() {
    if (iframe) {
      iframe.style.display = 'block';
    }
  };

  var showMenuItem = function showMenuItem(viewName, controller, options, styles, attrs) {
    if (currentItem === viewName) {
      return;
    }

    var onIframeLoad = function onIframeLoad() {
      var frameElement = iframe;
      var view = src_protectedApi.createElement(views[viewName]);
      var iframeStyles = CSS.common + CSS.mobile;
      view.appendChild(src_protectedApi.createStylesElement(iframeStyles));
      appendContent(view);
      localize();

      if (!options) {
        // eslint-disable-next-line no-param-reassign
        options = {};
      }

      if (controller) {
        controller.init(frameElement, options);
      }

      updateIframeAttrs(attrs);
      updateIframeStyles(styles);
      currentItem = viewName;
      onShowMenuItem.notify();
      showIframe();
    };

    if (!iframe) {
      var adgStylesSelector = src_protectedApi.createStylesElement(CSS.selector, 'adg-styles-selector');

      if (adgStylesSelector) {
        document.documentElement.appendChild(adgStylesSelector);
      }

      createIframe(onIframeLoad, styles, attrs);
      return;
    }

    onIframeLoad();
  };

  var startSelect = function startSelect() {
    hideIframe();
    var controller = new SelectorMenuController(src_ioc.get('iframeController'));
    controller.startSelector();
  };

  var showSelectorMenu = function showSelectorMenu() {
    hideIframe();
    adguard_selector.close();
    var styles = {
      position: 'fixed',
      left: 0,
      top: 0,
      right: 0,
      bottom: 0,
      margin: 'auto',
      'border-radius': '2px',
      background: 'transparent',
      width: '40vmax',
      height: '40vmax'
    }; // eslint-disable-next-line no-use-before-define

    showMenuItem('mobilePopup.html', mobilePopupButtonsInit(), null, styles);
  }; // e.isTrusted checking for prevent programmatically events
  // see: https://github.com/AdguardTeam/AdguardAssistant/issues/134


  var removeIframe = function removeIframe(e) {
    if (e && e.isTrusted === false) {
      return false;
    }

    if (!iframeElement) {
      return false;
    }

    document.removeEventListener('click', removeIframe);
    window.removeEventListener('orientationchange', showSelectorMenu);
    document.documentElement.removeChild(iframeElement);
    iframe = null;
    iframeElement = null;
    currentItem = null;
    adguard_selector.close();
    onCloseMenu.notify();
    return undefined;
  };

  var mobilePopupButtonsInit = function mobilePopupButtonsInit() {
    return {
      init: function init() {
        var startSelectMode = iframe.contentDocument.querySelector('.start-select-mode');
        var cancelSelectMode = iframe.contentDocument.querySelector('.cancel-select-mode');
        var appVersionElem = iframe.contentDocument.querySelector('#appVersion');
        startSelectMode.addEventListener('click', startSelect);
        cancelSelectMode.addEventListener('click', removeIframe);
        appVersionElem.innerText = "v".concat(package_namespaceObject.i8);
      }
    };
  };

  var showSliderMenu = function showSliderMenu(element) {
    var controller = new SliderMenuControllerMobile(src_ioc.get('addRule'), src_ioc.get('iframeController'));
    var options = {
      element: element
    };
    var styles = {
      position: 'fixed',
      bottom: 0,
      left: '50%',
      transform: 'translateX(-50%)',
      width: '70vw',
      height: '27vw'
    };
    showMenuItem('mobileMenu.html', controller, options, styles);
  };

  return {
    showSelectorMenu: showSelectorMenu,
    showSliderMenu: showSliderMenu,
    onCloseMenu: onCloseMenu,
    onShowMenuItem: onShowMenuItem,
    removeIframe: removeIframe,
    startSelect: startSelect
  };
}
;// CONCATENATED MODULE: ./src/embedded.js
/* global AdguardSettings */






/* embedded script for extensions */

/*
 * adguardAssistantExtended main function is for desktop browsers
 */

function adguardAssistantExtended() {
  var adguardSettings = typeof AdguardSettings === 'undefined' ? null : AdguardSettings;
  src_wot.registerWotEventHandler();
  src_settings.setAdguardSettings(adguardSettings);
  var iframeController = new iframe();
  src_ioc.register('iframeController', iframeController);
  return {
    start: function start(element, callback) {
      src_ioc.register('addRule', src_protectedApi.functionBind.call(callback, this));

      if (element) {
        iframeController.showSelectorMenu();
        iframeController.showSliderMenu(element);
      } else {
        iframeController.showSelectorMenu();
      }
    },
    close: function close() {
      iframeController.removeIframe();
    }
  };
}
/*
 * adguardAssistantMini function is for mobile browsers
 */

function adguardAssistantMini() {
  var iframeController = new IframeControllerMobile();
  src_ioc.register('iframeController', iframeController);
  return {
    start: function start(element, callback) {
      src_ioc.register('addRule', src_protectedApi.functionBind.call(callback, this));

      if (element) {
        iframeController.showSelectorMenu();
        iframeController.showSliderMenu(element);
      } else {
        iframeController.showSelectorMenu();
      }
    },
    close: function close() {
      iframeController.removeIframe();
    }
  };
}
;// CONCATENATED MODULE: ./src/helpers.js
var mobileReg = /(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|ipad|iris|kindle|Android|Silk|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i;
var isMobile = function isMobile(ua) {
  return mobileReg.test(ua);
};
;// CONCATENATED MODULE: ./src/index.js


var adguardAssistant = isMobile(navigator.userAgent) ? adguardAssistantMini : adguardAssistantExtended;
})();

/******/ 	return __nested_webpack_exports__;
/******/ })()
;
});

/***/ }),

/***/ 7757:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

module.exports = __webpack_require__(5666);


/***/ }),

/***/ 5666:
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

/***/ 3150:
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
/******/ 	/* webpack/runtime/global */
/******/ 	(() => {
/******/ 		__webpack_require__.g = (function() {
/******/ 			if (typeof globalThis === 'object') return globalThis;
/******/ 			try {
/******/ 				return this || new Function('return this')();
/******/ 			} catch (e) {
/******/ 				if (typeof window === 'object') return window;
/******/ 			}
/******/ 		})();
/******/ 	})();
/******/ 	
/******/ 	/* webpack/runtime/hasOwnProperty shorthand */
/******/ 	(() => {
/******/ 		__webpack_require__.o = (obj, prop) => (Object.prototype.hasOwnProperty.call(obj, prop))
/******/ 	})();
/******/ 	
/************************************************************************/
var __webpack_exports__ = {};
// This entry need to be wrapped in an IIFE because it need to be in strict mode.
(() => {
"use strict";

;// CONCATENATED MODULE: ./node_modules/@babel/runtime/helpers/esm/asyncToGenerator.js
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
// EXTERNAL MODULE: ./node_modules/@babel/runtime/regenerator/index.js
var regenerator = __webpack_require__(7757);
var regenerator_default = /*#__PURE__*/__webpack_require__.n(regenerator);
// EXTERNAL MODULE: ./node_modules/@adguard/assistant/dist/assistant.js
var dist_assistant = __webpack_require__(6263);
// EXTERNAL MODULE: ./node_modules/webextension-polyfill/dist/browser-polyfill.js
var browser_polyfill = __webpack_require__(3150);
var browser_polyfill_default = /*#__PURE__*/__webpack_require__.n(browser_polyfill);
;// CONCATENATED MODULE: ./src/pages/common/constants.ts
var MessagesToNativeApp;

(function (MessagesToNativeApp) {
  MessagesToNativeApp["GetInitData"] = "get_init_data";
  MessagesToNativeApp["GetContentScriptData"] = "get_content_script_data";
})(MessagesToNativeApp || (MessagesToNativeApp = {}));

var MessagesToBackgroundPage;

(function (MessagesToBackgroundPage) {
  MessagesToBackgroundPage["OpenAssistant"] = "open_assistant";
  MessagesToBackgroundPage["AddRule"] = "add_rule";
  MessagesToBackgroundPage["GetPopupData"] = "get_popup_data";
  MessagesToBackgroundPage["SetPermissionsModalViewed"] = "set_permissions_modal_viewed";
  MessagesToBackgroundPage["SetProtectionStatus"] = "set_protection_status";
  MessagesToBackgroundPage["DeleteUserRulesByUrl"] = "delete_user_rules_by_url";
  MessagesToBackgroundPage["ReportProblem"] = "report_problem";
  MessagesToBackgroundPage["UpgradeClicked"] = "upgrade_clicked";
  MessagesToBackgroundPage["EnableAdvancedBlocking"] = "enable_advanced_blocking";
  MessagesToBackgroundPage["EnableSafariProtection"] = "enable_safari_protection";
  MessagesToBackgroundPage["RequestContentScriptData"] = "request_content_script_data";
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
var WEB_EXTENSION_MORE_URL = 'https://link.adtidy.org/forward.html?action=web_extension_more&from=popup&app=ios';
var Platform;

(function (Platform) {
  Platform["IPad"] = "ipad";
  Platform["IPhone"] = "iphone";
})(Platform || (Platform = {}));
;// CONCATENATED MODULE: ./node_modules/@babel/runtime/helpers/esm/typeof.js
function _typeof(obj) {
  "@babel/helpers - typeof";

  if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") {
    _typeof = function _typeof(obj) {
      return typeof obj;
    };
  } else {
    _typeof = function _typeof(obj) {
      return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj;
    };
  }

  return _typeof(obj);
}
;// CONCATENATED MODULE: ./node_modules/@babel/runtime/helpers/esm/classCallCheck.js
function _classCallCheck(instance, Constructor) {
  if (!(instance instanceof Constructor)) {
    throw new TypeError("Cannot call a class as a function");
  }
}
;// CONCATENATED MODULE: ./node_modules/@babel/runtime/helpers/esm/createClass.js
function _defineProperties(target, props) {
  for (var i = 0; i < props.length; i++) {
    var descriptor = props[i];
    descriptor.enumerable = descriptor.enumerable || false;
    descriptor.configurable = true;
    if ("value" in descriptor) descriptor.writable = true;
    Object.defineProperty(target, descriptor.key, descriptor);
  }
}

function _createClass(Constructor, protoProps, staticProps) {
  if (protoProps) _defineProperties(Constructor.prototype, protoProps);
  if (staticProps) _defineProperties(Constructor, staticProps);
  return Constructor;
}
;// CONCATENATED MODULE: ./node_modules/@adguard/extended-css/dist/extended-css.esm.js
/**
 * @adguard/extended-css - v2.1.1 - Thu Dec 19 2024
 * https://github.com/AdguardTeam/ExtendedCss#homepage
 * Copyright (c) 2024 AdGuard. Licensed GPL-3.0
 */
function _defineProperty(obj, key, value) {
  if (key in obj) {
    Object.defineProperty(obj, key, {
      value: value,
      enumerable: true,
      configurable: true,
      writable: true
    });
  } else {
    obj[key] = value;
  }

  return obj;
}

/**
 * Possible ast node types.
 *
 * IMPORTANT: it is used as 'const' instead of 'enum' to avoid side effects
 * during ExtendedCss import into other libraries.
 */
const NODE = {
  SELECTOR_LIST: 'SelectorList',
  SELECTOR: 'Selector',
  REGULAR_SELECTOR: 'RegularSelector',
  EXTENDED_SELECTOR: 'ExtendedSelector',
  ABSOLUTE_PSEUDO_CLASS: 'AbsolutePseudoClass',
  RELATIVE_PSEUDO_CLASS: 'RelativePseudoClass'
};

/**
 * Class needed for creating ast nodes while selector parsing.
 * Used for SelectorList, Selector, ExtendedSelector.
 */
class AnySelectorNode {
  /**
   * Creates new ast node.
   *
   * @param type Ast node type.
   */
  constructor(type) {
    _defineProperty(this, "children", []);

    this.type = type;
  }
  /**
   * Adds child node to children array.
   *
   * @param child Ast node.
   */


  addChild(child) {
    this.children.push(child);
  }

}
/**
 * Class needed for creating RegularSelector ast node while selector parsing.
 */

class RegularSelectorNode extends AnySelectorNode {
  /**
   * Creates RegularSelector ast node.
   *
   * @param value Value of RegularSelector node.
   */
  constructor(value) {
    super(NODE.REGULAR_SELECTOR);
    this.value = value;
  }

}
/**
 * Class needed for creating RelativePseudoClass ast node while selector parsing.
 */

class RelativePseudoClassNode extends AnySelectorNode {
  /**
   * Creates RegularSelector ast node.
   *
   * @param name Name of RelativePseudoClass node.
   */
  constructor(name) {
    super(NODE.RELATIVE_PSEUDO_CLASS);
    this.name = name;
  }

}
/**
 * Class needed for creating AbsolutePseudoClass ast node while selector parsing.
 */

class AbsolutePseudoClassNode extends AnySelectorNode {
  /**
   * Creates AbsolutePseudoClass ast node.
   *
   * @param name Name of AbsolutePseudoClass node.
   */
  constructor(name) {
    super(NODE.ABSOLUTE_PSEUDO_CLASS);

    _defineProperty(this, "value", '');

    this.name = name;
  }

}
/* eslint-disable jsdoc/require-description-complete-sentence */

/**
 * Root node.
 *
 * SelectorList
 *   : Selector
 *     ...
 *   ;
 */

/**
 * Selector node.
 *
 * Selector
 *   : RegularSelector
 *   | ExtendedSelector
 *     ...
 *   ;
 */

/**
 * Regular selector node.
 * It can be selected by querySelectorAll().
 *
 * RegularSelector
 *   : type
 *   : value
 *   ;
 */

/**
 * Extended selector node.
 *
 * ExtendedSelector
 *   : AbsolutePseudoClass
 *   | RelativePseudoClass
 *   ;
 */

/**
 * Absolute extended pseudo-class node,
 * i.e. none-selector args.
 *
 * AbsolutePseudoClass
 *   : type
 *   : name
 *   : value
 *   ;
 */

/**
 * Relative extended pseudo-class node
 * i.e. selector as arg.
 *
 * RelativePseudoClass
 *   : type
 *   : name
 *   : SelectorList
 *   ;
 */
//
//  ast example
//
//  div.banner > div:has(span, p), a img.ad
//
//  SelectorList - div.banner > div:has(span, p), a img.ad
//      Selector - div.banner > div:has(span, p)
//          RegularSelector - div.banner > div
//          ExtendedSelector - :has(span, p)
//              PseudoClassSelector - :has
//              SelectorList - span, p
//                  Selector - span
//                      RegularSelector - span
//                  Selector - p
//                      RegularSelector - p
//      Selector - a img.ad
//          RegularSelector - a img.ad
//

var version = "2.1.1";

const EXTENDED_CSS_VERSION = (/* unused pure expression or super */ null && (version));
const LEFT_SQUARE_BRACKET = '[';
const RIGHT_SQUARE_BRACKET = ']';
const LEFT_PARENTHESIS = '(';
const RIGHT_PARENTHESIS = ')';
const LEFT_CURLY_BRACKET = '{';
const RIGHT_CURLY_BRACKET = '}';
const BRACKET = {
  SQUARE: {
    LEFT: LEFT_SQUARE_BRACKET,
    RIGHT: RIGHT_SQUARE_BRACKET
  },
  PARENTHESES: {
    LEFT: LEFT_PARENTHESIS,
    RIGHT: RIGHT_PARENTHESIS
  },
  CURLY: {
    LEFT: LEFT_CURLY_BRACKET,
    RIGHT: RIGHT_CURLY_BRACKET
  }
};
const SLASH = '/';
const BACKSLASH = '\\';
const SPACE = ' ';
const COMMA = ',';
const DOT = '.';
const SEMICOLON = ';';
const COLON = ':';
const SINGLE_QUOTE = '\'';
const DOUBLE_QUOTE = '"'; // do not consider hyphen `-` as separated mark
// to avoid pseudo-class names splitting
// e.g. 'matches-css' or 'if-not'

const CARET = '^';
const DOLLAR_SIGN = '$';
const EQUAL_SIGN = '=';
const TAB = '\t';
const CARRIAGE_RETURN = '\r';
const LINE_FEED = '\n';
const FORM_FEED = '\f';
const WHITE_SPACE_CHARACTERS = [SPACE, TAB, CARRIAGE_RETURN, LINE_FEED, FORM_FEED]; // for universal selector and attributes

const ASTERISK = '*';
const ID_MARKER = '#';
const CLASS_MARKER = DOT;
const DESCENDANT_COMBINATOR = SPACE;
const CHILD_COMBINATOR = '>';
const NEXT_SIBLING_COMBINATOR = '+';
const SUBSEQUENT_SIBLING_COMBINATOR = '~';
const COMBINATORS = [DESCENDANT_COMBINATOR, CHILD_COMBINATOR, NEXT_SIBLING_COMBINATOR, SUBSEQUENT_SIBLING_COMBINATOR];
const SUPPORTED_SELECTOR_MARKS = [LEFT_SQUARE_BRACKET, RIGHT_SQUARE_BRACKET, LEFT_PARENTHESIS, RIGHT_PARENTHESIS, LEFT_CURLY_BRACKET, RIGHT_CURLY_BRACKET, SLASH, BACKSLASH, SEMICOLON, COLON, COMMA, SINGLE_QUOTE, DOUBLE_QUOTE, CARET, DOLLAR_SIGN, ASTERISK, ID_MARKER, CLASS_MARKER, DESCENDANT_COMBINATOR, CHILD_COMBINATOR, NEXT_SIBLING_COMBINATOR, SUBSEQUENT_SIBLING_COMBINATOR, TAB, CARRIAGE_RETURN, LINE_FEED, FORM_FEED];
const SUPPORTED_STYLE_DECLARATION_MARKS = [// divider between property and value in declaration
COLON, // divider between declarations
SEMICOLON, // sometimes is needed for value wrapping
// e.g. 'content: "-"'
SINGLE_QUOTE, DOUBLE_QUOTE, // needed for quote escaping inside the same-type quotes
BACKSLASH, // whitespaces
SPACE, TAB, CARRIAGE_RETURN, LINE_FEED, FORM_FEED]; // absolute:

const CONTAINS_PSEUDO = 'contains';
const HAS_TEXT_PSEUDO = 'has-text';
const ABP_CONTAINS_PSEUDO = '-abp-contains';
const MATCHES_CSS_PSEUDO = 'matches-css';
const MATCHES_CSS_BEFORE_PSEUDO = 'matches-css-before';
const MATCHES_CSS_AFTER_PSEUDO = 'matches-css-after';
const MATCHES_ATTR_PSEUDO_CLASS_MARKER = 'matches-attr';
const MATCHES_PROPERTY_PSEUDO_CLASS_MARKER = 'matches-property';
const XPATH_PSEUDO_CLASS_MARKER = 'xpath';
const NTH_ANCESTOR_PSEUDO_CLASS_MARKER = 'nth-ancestor';
const CONTAINS_PSEUDO_NAMES = [CONTAINS_PSEUDO, HAS_TEXT_PSEUDO, ABP_CONTAINS_PSEUDO];
/**
 * Pseudo-class :upward() can get number or selector arg
 * and if the arg is selector it should be standard, not extended
 * so :upward pseudo-class is always absolute.
 */

const UPWARD_PSEUDO_CLASS_MARKER = 'upward';
/**
 * Pseudo-class `:remove()` and pseudo-property `remove`
 * are used for element actions, not for element selecting.
 *
 * Selector text should not contain the pseudo-class
 * so selector parser should consider it as invalid
 * and both are handled by stylesheet parser.
 */

const REMOVE_PSEUDO_MARKER = 'remove'; // relative:

const HAS_PSEUDO_CLASS_MARKER = 'has';
const ABP_HAS_PSEUDO_CLASS_MARKER = '-abp-has';
const HAS_PSEUDO_CLASS_MARKERS = [HAS_PSEUDO_CLASS_MARKER, ABP_HAS_PSEUDO_CLASS_MARKER];
const IS_PSEUDO_CLASS_MARKER = 'is';
const NOT_PSEUDO_CLASS_MARKER = 'not';
const ABSOLUTE_PSEUDO_CLASSES = [CONTAINS_PSEUDO, HAS_TEXT_PSEUDO, ABP_CONTAINS_PSEUDO, MATCHES_CSS_PSEUDO, MATCHES_CSS_BEFORE_PSEUDO, MATCHES_CSS_AFTER_PSEUDO, MATCHES_ATTR_PSEUDO_CLASS_MARKER, MATCHES_PROPERTY_PSEUDO_CLASS_MARKER, XPATH_PSEUDO_CLASS_MARKER, NTH_ANCESTOR_PSEUDO_CLASS_MARKER, UPWARD_PSEUDO_CLASS_MARKER];
const RELATIVE_PSEUDO_CLASSES = [...HAS_PSEUDO_CLASS_MARKERS, IS_PSEUDO_CLASS_MARKER, NOT_PSEUDO_CLASS_MARKER];
const SUPPORTED_PSEUDO_CLASSES = [...ABSOLUTE_PSEUDO_CLASSES, ...RELATIVE_PSEUDO_CLASSES]; // these pseudo-classes should be part of RegularSelector value
// if its arg does not contain extended selectors.
// the ast will be checked after the selector is completely parsed

const OPTIMIZATION_PSEUDO_CLASSES = [NOT_PSEUDO_CLASS_MARKER, IS_PSEUDO_CLASS_MARKER];
/**
 * ':scope' is used for extended pseudo-class :has(), if-not(), :is() and :not().
 */

const SCOPE_CSS_PSEUDO_CLASS = ':scope';
/**
 * ':after' and ':before' are needed for :matches-css() pseudo-class
 * all other are needed for :has() limitation after regular pseudo-elements.
 *
 * @see {@link https://bugs.chromium.org/p/chromium/issues/detail?id=669058#c54} [case 3]
 */

const REGULAR_PSEUDO_ELEMENTS = {
  AFTER: 'after',
  BACKDROP: 'backdrop',
  BEFORE: 'before',
  CUE: 'cue',
  CUE_REGION: 'cue-region',
  FIRST_LETTER: 'first-letter',
  FIRST_LINE: 'first-line',
  FILE_SELECTION_BUTTON: 'file-selector-button',
  GRAMMAR_ERROR: 'grammar-error',
  MARKER: 'marker',
  PART: 'part',
  PLACEHOLDER: 'placeholder',
  SELECTION: 'selection',
  SLOTTED: 'slotted',
  SPELLING_ERROR: 'spelling-error',
  TARGET_TEXT: 'target-text'
}; // ExtendedCss does not support at-rules
// https://developer.mozilla.org/en-US/docs/Web/CSS/At-rule

const AT_RULE_MARKER = '@';
const CONTENT_CSS_PROPERTY = 'content';
const PSEUDO_PROPERTY_POSITIVE_VALUE = 'true';
const DEBUG_PSEUDO_PROPERTY_GLOBAL_VALUE = 'global';
const NO_SELECTOR_ERROR_PREFIX = 'Selector should be defined';
const STYLE_ERROR_PREFIX = {
  NO_STYLE: 'No style declaration found',
  NO_SELECTOR: `${NO_SELECTOR_ERROR_PREFIX} before style declaration in stylesheet`,
  INVALID_STYLE: 'Invalid style declaration',
  UNCLOSED_STYLE: 'Unclosed style declaration',
  NO_PROPERTY: 'Missing style property in declaration',
  NO_VALUE: 'Missing style value in declaration',
  NO_STYLE_OR_REMOVE: 'Style should be declared or :remove() pseudo-class should used',
  NO_COMMENT: 'Comments are not supported'
};
const NO_AT_RULE_ERROR_PREFIX = 'At-rules are not supported';
const REMOVE_ERROR_PREFIX = {
  INVALID_REMOVE: 'Invalid :remove() pseudo-class in selector',
  NO_TARGET_SELECTOR: `${NO_SELECTOR_ERROR_PREFIX} before :remove() pseudo-class`,
  MULTIPLE_USAGE: 'Pseudo-class :remove() appears more than once in selector',
  INVALID_POSITION: 'Pseudo-class :remove() should be at the end of selector'
};
const MATCHING_ELEMENT_ERROR_PREFIX = 'Error while matching element';
const MAX_STYLE_PROTECTION_COUNT = 50;

/**
 * Regexp that matches backward compatible syntaxes.
 */

const REGEXP_VALID_OLD_SYNTAX = /\[-(?:ext)-([a-z-_]+)=(["'])((?:(?=(\\?))\4.)*?)\2\]/g;
/**
 * Marker for checking invalid selector after old-syntax normalizing by selector converter.
 */

const INVALID_OLD_SYNTAX_MARKER = '[-ext-';
/**
 * Complex replacement function.
 * Undo quote escaping inside of an extended selector.
 *
 * @param match     Whole matched string.
 * @param name      Group 1.
 * @param quoteChar Group 2.
 * @param rawValue  Group 3.
 *
 * @returns Converted string.
 */

const evaluateMatch = (match, name, quoteChar, rawValue) => {
  // Unescape quotes
  const re = new RegExp(`([^\\\\]|^)\\\\${quoteChar}`, 'g');
  const value = rawValue.replace(re, `$1${quoteChar}`);
  return `:${name}(${value})`;
}; // ':scope' pseudo may be at start of :has() argument
// but ExtCssDocument.querySelectorAll() already use it for selecting exact element descendants


const SCOPE_MARKER_REGEXP = /\(:scope >/g;
const SCOPE_REPLACER = '(>';
const MATCHES_CSS_PSEUDO_ELEMENT_REGEXP = /(:matches-css)-(before|after)\(/g;

const convertMatchesCss = (match, extendedPseudoClass, regularPseudoElement) => {
  // ':matches-css-before('  -->  ':matches-css(before, '
  // ':matches-css-after('   -->  ':matches-css(after, '
  return `${extendedPseudoClass}${BRACKET.PARENTHESES.LEFT}${regularPseudoElement}${COMMA}`;
};
/**
 * Handles old syntax and :scope inside :has().
 *
 * @param selector Trimmed selector to normalize.
 *
 * @returns Normalized selector.
 * @throws An error on invalid old extended syntax selector.
 */


const normalize = selector => {
  const normalizedSelector = selector.replace(REGEXP_VALID_OLD_SYNTAX, evaluateMatch).replace(SCOPE_MARKER_REGEXP, SCOPE_REPLACER).replace(MATCHES_CSS_PSEUDO_ELEMENT_REGEXP, convertMatchesCss); // validate old syntax after normalizing
  // e.g. '[-ext-matches-css-before=\'content:  /^[A-Z][a-z]'

  if (normalizedSelector.includes(INVALID_OLD_SYNTAX_MARKER)) {
    throw new Error(`Invalid extended-css old syntax selector: '${selector}'`);
  }

  return normalizedSelector;
};
/**
 * Prepares the rawSelector before tokenization:
 * 1. Trims it.
 * 2. Converts old syntax `[-ext-pseudo-class="..."]` to new one `:pseudo-class(...)`.
 * 3. Handles :scope pseudo inside :has() pseudo-class arg.
 *
 * @param rawSelector Selector with no style declaration.
 * @returns Prepared selector with no style declaration.
 */


const convert = rawSelector => {
  const trimmedSelector = rawSelector.trim();
  return normalize(trimmedSelector);
};

/**
 * Possible token types.
 *
 * IMPORTANT: it is used as 'const' instead of 'enum' to avoid side effects
 * during ExtendedCss import into other libraries.
 */
const TOKEN_TYPE = {
  MARK: 'mark',
  WORD: 'word'
};

/**
 * Splits `input` string into tokens.
 *
 * @param input Input string to tokenize.
 * @param supportedMarks Array of supported marks to considered as `TOKEN_TYPE.MARK`;
 * all other will be considered as `TOKEN_TYPE.WORD`.
 *
 * @returns Array of tokens.
 */
const tokenize = (input, supportedMarks) => {
  // buffer is needed for words collecting while iterating
  let wordBuffer = ''; // result collection

  const tokens = [];
  const selectorSymbols = input.split(''); // iterate through selector chars and collect tokens

  selectorSymbols.forEach(symbol => {
    if (supportedMarks.includes(symbol)) {
      // if anything was collected to the buffer before
      if (wordBuffer.length > 0) {
        // now it is time to stop buffer collecting and save is as "word"
        tokens.push({
          type: TOKEN_TYPE.WORD,
          value: wordBuffer
        }); // reset the buffer

        wordBuffer = '';
      } // save current symbol as "mark"


      tokens.push({
        type: TOKEN_TYPE.MARK,
        value: symbol
      });
      return;
    } // otherwise collect symbol to the buffer


    wordBuffer += symbol;
  }); // save the last collected word

  if (wordBuffer.length > 0) {
    tokens.push({
      type: TOKEN_TYPE.WORD,
      value: wordBuffer
    });
  }

  return tokens;
};

/**
 * Prepares `rawSelector` and splits it into tokens.
 *
 * @param rawSelector Raw css selector.
 *
 * @returns Array of tokens supported for selector.
 */

const tokenizeSelector = rawSelector => {
  const selector = convert(rawSelector);
  return tokenize(selector, SUPPORTED_SELECTOR_MARKS);
};
/**
 * Splits `attribute` into tokens.
 *
 * @param attribute Input attribute.
 *
 * @returns Array of tokens supported for attribute.
 */

const tokenizeAttribute = attribute => {
  // equal sigh `=` in attribute is considered as `TOKEN_TYPE.MARK`
  return tokenize(attribute, [...SUPPORTED_SELECTOR_MARKS, EQUAL_SIGN]);
};

/**
 * Some browsers do not support Array.prototype.flat()
 * e.g. Opera 42 which is used for browserstack tests.
 *
 * @see {@link https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/flat}
 *
 * @param input Array needed to be flatten.
 *
 * @returns Flatten array.
 * @throws An error if array cannot be flatten.
 */
const flatten = input => {
  const stack = [];
  input.forEach(el => stack.push(el));
  const res = [];

  while (stack.length) {
    // pop value from stack
    const next = stack.pop();

    if (!next) {
      throw new Error('Unable to make array flat');
    }

    if (Array.isArray(next)) {
      // push back array items, won't modify the original input
      next.forEach(el => stack.push(el));
    } else {
      res.push(next);
    }
  } // reverse to restore input order


  return res.reverse();
};
/**
 * Returns first item from `array`.
 *
 * @param array Input array.
 *
 * @returns First array item, or `undefined` if there is no such item.
 */

const getFirst = array => {
  return array[0];
};
/**
 * Returns last item from array.
 *
 * @param array Input array.
 *
 * @returns Last array item, or `undefined` if there is no such item.
 */

const getLast = array => {
  return array[array.length - 1];
};
/**
 * Returns array item which is previous to the last one
 * e.g. for `[5, 6, 7, 8]` returns `7`.
 *
 * @param array Input array.
 *
 * @returns Previous to last array item, or `undefined` if there is no such item.
 */

const getPrevToLast = array => {
  return array[array.length - 2];
};
/**
 * Takes array of ast node `children` and returns the child by the `index`.
 *
 * @param array Array of ast node children.
 * @param index Index of needed child in the array.
 * @param errorMessage Optional error message to throw.
 *
 * @returns Array item at `index` position.
 * @throws An error if there is no child with specified `index` in array.
 */

const getItemByIndex = (array, index, errorMessage) => {
  const indexChild = array[index];

  if (!indexChild) {
    throw new Error(errorMessage || `No array item found by index ${index}`);
  }

  return indexChild;
};

const NO_REGULAR_SELECTOR_ERROR = 'At least one of Selector node children should be RegularSelector';
/**
 * Checks whether the type of `astNode` is SelectorList.
 *
 * @param astNode Ast node.
 *
 * @returns True if astNode.type === SelectorList.
 */

const isSelectorListNode = astNode => {
  return (astNode === null || astNode === void 0 ? void 0 : astNode.type) === NODE.SELECTOR_LIST;
};
/**
 * Checks whether the type of `astNode` is Selector.
 *
 * @param astNode Ast node.
 *
 * @returns True if astNode.type === Selector.
 */

const isSelectorNode = astNode => {
  return (astNode === null || astNode === void 0 ? void 0 : astNode.type) === NODE.SELECTOR;
};
/**
 * Checks whether the type of `astNode` is RegularSelector.
 *
 * @param astNode Ast node.
 *
 * @returns True if astNode.type === RegularSelector.
 */

const isRegularSelectorNode = astNode => {
  return (astNode === null || astNode === void 0 ? void 0 : astNode.type) === NODE.REGULAR_SELECTOR;
};
/**
 * Checks whether the type of `astNode` is ExtendedSelector.
 *
 * @param astNode Ast node.
 *
 * @returns True if astNode.type === ExtendedSelector.
 */

const isExtendedSelectorNode = astNode => {
  return astNode.type === NODE.EXTENDED_SELECTOR;
};
/**
 * Checks whether the type of `astNode` is AbsolutePseudoClass.
 *
 * @param astNode Ast node.
 *
 * @returns True if astNode.type === AbsolutePseudoClass.
 */

const isAbsolutePseudoClassNode = astNode => {
  return (astNode === null || astNode === void 0 ? void 0 : astNode.type) === NODE.ABSOLUTE_PSEUDO_CLASS;
};
/**
 * Checks whether the type of `astNode` is RelativePseudoClass.
 *
 * @param astNode Ast node.
 *
 * @returns True if astNode.type === RelativePseudoClass.
 */

const isRelativePseudoClassNode = astNode => {
  return (astNode === null || astNode === void 0 ? void 0 : astNode.type) === NODE.RELATIVE_PSEUDO_CLASS;
};
/**
 * Returns name of `astNode`.
 *
 * @param astNode AbsolutePseudoClass or RelativePseudoClass node.
 *
 * @returns Name of `astNode`.
 * @throws An error on unsupported ast node or no name found.
 */

const getNodeName = astNode => {
  if (astNode === null) {
    throw new Error('Ast node should be defined');
  }

  if (!isAbsolutePseudoClassNode(astNode) && !isRelativePseudoClassNode(astNode)) {
    throw new Error('Only AbsolutePseudoClass or RelativePseudoClass ast node can have a name');
  }

  if (!astNode.name) {
    throw new Error('Extended pseudo-class should have a name');
  }

  return astNode.name;
};
/**
 * Returns value of `astNode`.
 *
 * @param astNode RegularSelector or AbsolutePseudoClass node.
 * @param errorMessage Optional error message if no value found.
 *
 * @returns Value of `astNode`.
 * @throws An error on unsupported ast node or no value found.
 */

const getNodeValue = (astNode, errorMessage) => {
  if (astNode === null) {
    throw new Error('Ast node should be defined');
  }

  if (!isRegularSelectorNode(astNode) && !isAbsolutePseudoClassNode(astNode)) {
    throw new Error('Only RegularSelector ot AbsolutePseudoClass ast node can have a value');
  }

  if (!astNode.value) {
    throw new Error(errorMessage || 'Ast RegularSelector ot AbsolutePseudoClass node should have a value');
  }

  return astNode.value;
};
/**
 * Returns only RegularSelector nodes from `children`.
 *
 * @param children Array of ast node children.
 *
 * @returns Array of RegularSelector nodes.
 */

const getRegularSelectorNodes = children => {
  return children.filter(isRegularSelectorNode);
};
/**
 * Returns the first RegularSelector node from `children`.
 *
 * @param children Array of ast node children.
 * @param errorMessage Optional error message if no value found.
 *
 * @returns Ast RegularSelector node.
 * @throws An error if no RegularSelector node found.
 */


const getFirstRegularChild = (children, errorMessage) => {
  const regularSelectorNodes = getRegularSelectorNodes(children);
  const firstRegularSelectorNode = getFirst(regularSelectorNodes);

  if (!firstRegularSelectorNode) {
    throw new Error(errorMessage || NO_REGULAR_SELECTOR_ERROR);
  }

  return firstRegularSelectorNode;
};
/**
 * Returns the last RegularSelector node from `children`.
 *
 * @param children Array of ast node children.
 *
 * @returns Ast RegularSelector node.
 * @throws An error if no RegularSelector node found.
 */

const getLastRegularChild = children => {
  const regularSelectorNodes = getRegularSelectorNodes(children);
  const lastRegularSelectorNode = getLast(regularSelectorNodes);

  if (!lastRegularSelectorNode) {
    throw new Error(NO_REGULAR_SELECTOR_ERROR);
  }

  return lastRegularSelectorNode;
};
/**
 * Returns the only child of `node`.
 *
 * @param node Ast node.
 * @param errorMessage Error message.
 *
 * @returns The only child of ast node.
 * @throws An error if none or more than one child found.
 */

const getNodeOnlyChild = (node, errorMessage) => {
  if (node.children.length !== 1) {
    throw new Error(errorMessage);
  }

  const onlyChild = getFirst(node.children);

  if (!onlyChild) {
    throw new Error(errorMessage);
  }

  return onlyChild;
};
/**
 * Takes ExtendedSelector node and returns its only child.
 *
 * @param extendedSelectorNode ExtendedSelector ast node.
 *
 * @returns AbsolutePseudoClass or RelativePseudoClass.
 * @throws An error if there is no specific pseudo-class ast node.
 */

const getPseudoClassNode = extendedSelectorNode => {
  return getNodeOnlyChild(extendedSelectorNode, 'Extended selector should be specified');
};
/**
 * Takes RelativePseudoClass node and returns its only child
 * which is relative SelectorList node.
 *
 * @param pseudoClassNode RelativePseudoClass.
 *
 * @returns Relative SelectorList node.
 * @throws An error if no selector list found.
 */

const getRelativeSelectorListNode = pseudoClassNode => {
  if (!isRelativePseudoClassNode(pseudoClassNode)) {
    throw new Error('Only RelativePseudoClass node can have relative SelectorList node as child');
  }

  return getNodeOnlyChild(pseudoClassNode, `Missing arg for :${getNodeName(pseudoClassNode)}() pseudo-class`);
};

const ATTRIBUTE_CASE_INSENSITIVE_FLAG = 'i';
/**
 * Limited list of available symbols before slash `/`
 * to check whether it is valid regexp pattern opening.
 */

const POSSIBLE_MARKS_BEFORE_REGEXP = {
  COMMON: [// e.g. ':matches-attr(/data-/)'
  BRACKET.PARENTHESES.LEFT, // e.g. `:matches-attr('/data-/')`
  SINGLE_QUOTE, // e.g. ':matches-attr("/data-/")'
  DOUBLE_QUOTE, // e.g. ':matches-attr(check=/data-v-/)'
  EQUAL_SIGN, // e.g. ':matches-property(inner./_test/=null)'
  DOT, // e.g. ':matches-css(height:/20px/)'
  COLON, // ':matches-css-after( content  :   /(\\d+\\s)*me/  )'
  SPACE],
  CONTAINS: [// e.g. ':contains(/text/)'
  BRACKET.PARENTHESES.LEFT, // e.g. `:contains('/text/')`
  SINGLE_QUOTE, // e.g. ':contains("/text/")'
  DOUBLE_QUOTE]
};
/**
 * Checks whether the passed token is supported extended pseudo-class.
 *
 * @param tokenValue Token value to check.
 *
 * @returns True if `tokenValue` is one of supported extended pseudo-class names.
 */

const isSupportedPseudoClass = tokenValue => {
  return SUPPORTED_PSEUDO_CLASSES.includes(tokenValue);
};
/**
 * Checks whether the passed pseudo-class `name` should be optimized,
 * i.e. :not() and :is().
 *
 * @param name Pseudo-class name.
 *
 * @returns True if `name` is one if pseudo-class which should be optimized.
 */

const isOptimizationPseudoClass = name => {
  return OPTIMIZATION_PSEUDO_CLASSES.includes(name);
};
/**
 * Checks whether next to "space" token is a continuation of regular selector being processed.
 *
 * @param nextTokenType Type of token next to current one.
 * @param nextTokenValue Value of token next to current one.
 *
 * @returns True if next token seems to be a part of current regular selector.
 */

const doesRegularContinueAfterSpace = (nextTokenType, nextTokenValue) => {
  // regular selector does not continues after the current token
  if (!nextTokenType || !nextTokenValue) {
    return false;
  }

  return COMBINATORS.includes(nextTokenValue) || nextTokenType === TOKEN_TYPE.WORD // e.g. '#main *:has(> .ad)'
  || nextTokenValue === ASTERISK || nextTokenValue === ID_MARKER || nextTokenValue === CLASS_MARKER // e.g. 'div :where(.content)'
  || nextTokenValue === COLON // e.g. "div[class*=' ']"
  || nextTokenValue === SINGLE_QUOTE // e.g. 'div[class*=" "]'
  || nextTokenValue === DOUBLE_QUOTE || nextTokenValue === BRACKET.SQUARE.LEFT;
};
/**
 * Checks whether the regexp pattern for pseudo-class arg starts.
 * Needed for `context.isRegexpOpen` flag.
 *
 * @param context Selector parser context.
 * @param prevTokenValue Value of previous token.
 * @param bufferNodeValue Value of bufferNode.
 *
 * @returns True if current token seems to be a start of regexp pseudo-class arg pattern.
 * @throws An error on invalid regexp pattern.
 */

const isRegexpOpening = (context, prevTokenValue, bufferNodeValue) => {
  const lastExtendedPseudoClassName = getLast(context.extendedPseudoNamesStack);

  if (!lastExtendedPseudoClassName) {
    throw new Error('Regexp pattern allowed only in arg of extended pseudo-class');
  } // for regexp pattens the slash should not be escaped
  // const isRegexpPatternSlash = prevTokenValue !== BACKSLASH;
  // regexp pattern can be set as arg of pseudo-class
  // which means limited list of available symbols before slash `/`;
  // for :contains() pseudo-class regexp pattern should be at the beginning of arg


  if (CONTAINS_PSEUDO_NAMES.includes(lastExtendedPseudoClassName)) {
    return POSSIBLE_MARKS_BEFORE_REGEXP.CONTAINS.includes(prevTokenValue);
  }

  if (prevTokenValue === SLASH && lastExtendedPseudoClassName !== XPATH_PSEUDO_CLASS_MARKER) {
    const rawArgDesc = bufferNodeValue ? `in arg part: '${bufferNodeValue}'` : 'arg';
    throw new Error(`Invalid regexp pattern for :${lastExtendedPseudoClassName}() pseudo-class ${rawArgDesc}`);
  } // for other pseudo-classes regexp pattern can be either the whole arg or its part


  return POSSIBLE_MARKS_BEFORE_REGEXP.COMMON.includes(prevTokenValue);
};
/**
 * Checks whether the attribute starts.
 *
 * @param tokenValue Value of current token.
 * @param prevTokenValue Previous token value.
 *
 * @returns True if combination of current and previous token seems to be **a start** of attribute.
 */

const isAttributeOpening = (tokenValue, prevTokenValue) => {
  return tokenValue === BRACKET.SQUARE.LEFT && prevTokenValue !== BACKSLASH;
};
/**
 * Checks whether the attribute ends.
 *
 * @param context Selector parser context.
 *
 * @returns True if combination of current and previous token seems to be **an end** of attribute.
 * @throws An error on invalid attribute.
 */

const isAttributeClosing = context => {
  var _getPrevToLast;

  if (!context.isAttributeBracketsOpen) {
    return false;
  } // valid attributes may have extra spaces inside.
  // we get rid of them just to simplify the checking and they are skipped only here:
  //   - spaces will be collected to the ast with spaces as they were declared is selector
  //   - extra spaces in attribute are not relevant to attribute syntax validity
  //     e.g. 'a[ title ]' is the same as 'a[title]'
  //          'div[style *= "MARGIN" i]' is the same as 'div[style*="MARGIN"i]'


  const noSpaceAttr = context.attributeBuffer.split(SPACE).join(''); // tokenize the prepared attribute string

  const attrTokens = tokenizeAttribute(noSpaceAttr);
  const firstAttrToken = getFirst(attrTokens);
  const firstAttrTokenType = firstAttrToken === null || firstAttrToken === void 0 ? void 0 : firstAttrToken.type;
  const firstAttrTokenValue = firstAttrToken === null || firstAttrToken === void 0 ? void 0 : firstAttrToken.value; // signal an error on any mark-type token except backslash
  // e.g. '[="margin"]'

  if (firstAttrTokenType === TOKEN_TYPE.MARK // backslash is allowed at start of attribute
  // e.g. '[\\:data-service-slot]'
  && firstAttrTokenValue !== BACKSLASH) {
    // eslint-disable-next-line max-len
    throw new Error(`'[${context.attributeBuffer}]' is not a valid attribute due to '${firstAttrTokenValue}' at start of it`);
  }

  const lastAttrToken = getLast(attrTokens);
  const lastAttrTokenType = lastAttrToken === null || lastAttrToken === void 0 ? void 0 : lastAttrToken.type;
  const lastAttrTokenValue = lastAttrToken === null || lastAttrToken === void 0 ? void 0 : lastAttrToken.value;

  if (lastAttrTokenValue === EQUAL_SIGN) {
    // e.g. '[style=]'
    throw new Error(`'[${context.attributeBuffer}]' is not a valid attribute due to '${EQUAL_SIGN}'`);
  }

  const equalSignIndex = attrTokens.findIndex(token => {
    return token.type === TOKEN_TYPE.MARK && token.value === EQUAL_SIGN;
  });
  const prevToLastAttrTokenValue = (_getPrevToLast = getPrevToLast(attrTokens)) === null || _getPrevToLast === void 0 ? void 0 : _getPrevToLast.value;

  if (equalSignIndex === -1) {
    // if there is no '=' inside attribute,
    // it must be just attribute name which means the word-type token before closing bracket
    // e.g. 'div[style]'
    if (lastAttrTokenType === TOKEN_TYPE.WORD) {
      return true;
    }

    return prevToLastAttrTokenValue === BACKSLASH // some weird attribute are valid too
    // e.g. '[class\\"ads-article\\"]'
    && (lastAttrTokenValue === DOUBLE_QUOTE // e.g. "[class\\'ads-article\\']"
    || lastAttrTokenValue === SINGLE_QUOTE);
  } // get the value of token next to `=`


  const nextToEqualSignToken = getItemByIndex(attrTokens, equalSignIndex + 1);
  const nextToEqualSignTokenValue = nextToEqualSignToken.value; // check whether the attribute value wrapper in quotes

  const isAttrValueQuote = nextToEqualSignTokenValue === SINGLE_QUOTE || nextToEqualSignTokenValue === DOUBLE_QUOTE; // for no quotes after `=` the last token before `]` should be a word-type one
  // e.g. 'div[style*=margin]'
  //      'div[style*=MARGIN i]'

  if (!isAttrValueQuote) {
    if (lastAttrTokenType === TOKEN_TYPE.WORD) {
      return true;
    } // otherwise signal an error
    // e.g. 'table[style*=border: 0px"]'


    throw new Error(`'[${context.attributeBuffer}]' is not a valid attribute`);
  } // otherwise if quotes for value are present
  // the last token before `]` can still be word-type token
  // e.g. 'div[style*="MARGIN" i]'


  if (lastAttrTokenType === TOKEN_TYPE.WORD && (lastAttrTokenValue === null || lastAttrTokenValue === void 0 ? void 0 : lastAttrTokenValue.toLocaleLowerCase()) === ATTRIBUTE_CASE_INSENSITIVE_FLAG) {
    return prevToLastAttrTokenValue === nextToEqualSignTokenValue;
  } // eventually if there is quotes for attribute value and last token is not a word,
  // the closing mark should be the same quote as opening one


  return lastAttrTokenValue === nextToEqualSignTokenValue;
};
/**
 * Checks whether the `tokenValue` is a whitespace character.
 *
 * @param tokenValue Token value.
 *
 * @returns True if `tokenValue` is a whitespace character.
 */

const isWhiteSpaceChar = tokenValue => {
  if (!tokenValue) {
    return false;
  }

  return WHITE_SPACE_CHARACTERS.includes(tokenValue);
};

/**
 * Checks whether the passed `str` is a name of supported absolute extended pseudo-class,
 * e.g. :contains(), :matches-css() etc.
 *
 * @param str Token value to check.
 *
 * @returns True if `str` is one of absolute extended pseudo-class names.
 */

const isAbsolutePseudoClass = str => {
  return ABSOLUTE_PSEUDO_CLASSES.includes(str);
};
/**
 * Checks whether the passed `str` is a name of supported relative extended pseudo-class,
 * e.g. :has(), :not() etc.
 *
 * @param str Token value to check.
 *
 * @returns True if `str` is one of relative extended pseudo-class names.
 */

const isRelativePseudoClass = str => {
  return RELATIVE_PSEUDO_CLASSES.includes(str);
};

/**
 * Returns the node which is being collected
 * or null if there is no such one.
 *
 * @param context Selector parser context.
 *
 * @returns Buffer node or null.
 */

const getBufferNode = context => {
  if (context.pathToBufferNode.length === 0) {
    return null;
  } // buffer node is always the last in the pathToBufferNode stack


  return getLast(context.pathToBufferNode) || null;
};
/**
 * Returns the parent node to the 'buffer node' — which is the one being collected —
 * or null if there is no such one.
 *
 * @param context Selector parser context.
 *
 * @returns Parent node of buffer node or null.
 */

const getBufferNodeParent = context => {
  // at least two nodes should exist — the buffer node and its parent
  // otherwise return null
  if (context.pathToBufferNode.length < 2) {
    return null;
  } // since the buffer node is always the last in the pathToBufferNode stack
  // its parent is previous to it in the stack


  return getPrevToLast(context.pathToBufferNode) || null;
};
/**
 * Returns last RegularSelector ast node.
 * Needed for parsing of the complex selector with extended pseudo-class inside it.
 *
 * @param context Selector parser context.
 *
 * @returns Ast RegularSelector node.
 * @throws An error if:
 * - bufferNode is absent;
 * - type of bufferNode is unsupported;
 * - no RegularSelector in bufferNode.
 */

const getContextLastRegularSelectorNode = context => {
  const bufferNode = getBufferNode(context);

  if (!bufferNode) {
    throw new Error('No bufferNode found');
  }

  if (!isSelectorNode(bufferNode)) {
    throw new Error('Unsupported bufferNode type');
  }

  const lastRegularSelectorNode = getLastRegularChild(bufferNode.children);
  context.pathToBufferNode.push(lastRegularSelectorNode);
  return lastRegularSelectorNode;
};
/**
 * Updates needed buffer node value while tokens iterating.
 * For RegularSelector also collects token values to context.attributeBuffer
 * for proper attribute parsing.
 *
 * @param context Selector parser context.
 * @param tokenValue Value of current token.
 *
 * @throws An error if:
 * - no bufferNode;
 * - bufferNode.type is not RegularSelector or AbsolutePseudoClass.
 */

const updateBufferNode = (context, tokenValue) => {
  const bufferNode = getBufferNode(context);

  if (bufferNode === null) {
    throw new Error('No bufferNode to update');
  }

  if (isAbsolutePseudoClassNode(bufferNode)) {
    bufferNode.value += tokenValue;
  } else if (isRegularSelectorNode(bufferNode)) {
    bufferNode.value += tokenValue;

    if (context.isAttributeBracketsOpen) {
      context.attributeBuffer += tokenValue;
    }
  } else {
    // eslint-disable-next-line max-len
    throw new Error(`${bufferNode.type} node cannot be updated. Only RegularSelector and AbsolutePseudoClass are supported`);
  }
};
/**
 * Adds SelectorList node to context.ast at the start of ast collecting.
 *
 * @param context Selector parser context.
 */

const addSelectorListNode = context => {
  const selectorListNode = new AnySelectorNode(NODE.SELECTOR_LIST);
  context.ast = selectorListNode;
  context.pathToBufferNode.push(selectorListNode);
};
/**
 * Adds new node to buffer node children.
 * New added node will be considered as buffer node after it.
 *
 * @param context Selector parser context.
 * @param type Type of node to add.
 * @param tokenValue Optional, defaults to `''`, value of processing token.
 *
 * @throws An error if no bufferNode.
 */

const addAstNodeByType = function (context, type) {
  let tokenValue = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : '';
  const bufferNode = getBufferNode(context);

  if (bufferNode === null) {
    throw new Error('No buffer node');
  }

  let node;

  if (type === NODE.REGULAR_SELECTOR) {
    node = new RegularSelectorNode(tokenValue);
  } else if (type === NODE.ABSOLUTE_PSEUDO_CLASS) {
    node = new AbsolutePseudoClassNode(tokenValue);
  } else if (type === NODE.RELATIVE_PSEUDO_CLASS) {
    node = new RelativePseudoClassNode(tokenValue);
  } else {
    // SelectorList || Selector || ExtendedSelector
    node = new AnySelectorNode(type);
  }

  bufferNode.addChild(node);
  context.pathToBufferNode.push(node);
};
/**
 * The very beginning of ast collecting.
 *
 * @param context Selector parser context.
 * @param tokenValue Value of regular selector.
 */

const initAst = (context, tokenValue) => {
  addSelectorListNode(context);
  addAstNodeByType(context, NODE.SELECTOR); // RegularSelector node is always the first child of Selector node

  addAstNodeByType(context, NODE.REGULAR_SELECTOR, tokenValue);
};
/**
 * Inits selector list subtree for relative extended pseudo-classes, e.g. :has(), :not().
 *
 * @param context Selector parser context.
 * @param tokenValue Optional, defaults to `''`, value of inner regular selector.
 */

const initRelativeSubtree = function (context) {
  let tokenValue = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : '';
  addAstNodeByType(context, NODE.SELECTOR_LIST);
  addAstNodeByType(context, NODE.SELECTOR);
  addAstNodeByType(context, NODE.REGULAR_SELECTOR, tokenValue);
};
/**
 * Goes to closest parent specified by type.
 * Actually updates path to buffer node for proper ast collecting of selectors while parsing.
 *
 * @param context Selector parser context.
 * @param parentType Type of needed parent node in ast.
 */

const upToClosest = (context, parentType) => {
  for (let i = context.pathToBufferNode.length - 1; i >= 0; i -= 1) {
    var _context$pathToBuffer;

    if (((_context$pathToBuffer = context.pathToBufferNode[i]) === null || _context$pathToBuffer === void 0 ? void 0 : _context$pathToBuffer.type) === parentType) {
      context.pathToBufferNode = context.pathToBufferNode.slice(0, i + 1);
      break;
    }
  }
};
/**
 * Returns needed buffer node updated due to complex selector parsing.
 *
 * @param context Selector parser context.
 *
 * @returns Ast node for following selector parsing.
 * @throws An error if there is no upper SelectorNode is ast.
 */

const getUpdatedBufferNode = context => {
  // it may happen during the parsing of selector list
  // which is an argument of relative pseudo-class
  // e.g. '.banner:has(~span, ~p)'
  // parser position is here  ↑
  // so if after the comma the buffer node type is SelectorList and parent type is RelativePseudoClass
  // we should simply return the current buffer node
  const bufferNode = getBufferNode(context);

  if (bufferNode && isSelectorListNode(bufferNode) && isRelativePseudoClassNode(getBufferNodeParent(context))) {
    return bufferNode;
  }

  upToClosest(context, NODE.SELECTOR);
  const selectorNode = getBufferNode(context);

  if (!selectorNode) {
    throw new Error('No SelectorNode, impossible to continue selector parsing by ExtendedCss');
  }

  const lastSelectorNodeChild = getLast(selectorNode.children);
  const hasExtended = lastSelectorNodeChild && isExtendedSelectorNode(lastSelectorNodeChild) // parser position might be inside standard pseudo-class brackets which has space
  // e.g. 'div:contains(/а/):nth-child(100n + 2)'
  && context.standardPseudoBracketsStack.length === 0;
  const supposedPseudoClassNode = hasExtended && getFirst(lastSelectorNodeChild.children);
  let newNeededBufferNode = selectorNode;

  if (supposedPseudoClassNode) {
    // name of pseudo-class for last extended-node child for Selector node
    const lastExtendedPseudoName = hasExtended && supposedPseudoClassNode.name;
    const isLastExtendedNameRelative = lastExtendedPseudoName && isRelativePseudoClass(lastExtendedPseudoName);
    const isLastExtendedNameAbsolute = lastExtendedPseudoName && isAbsolutePseudoClass(lastExtendedPseudoName);
    const hasRelativeExtended = isLastExtendedNameRelative && context.extendedPseudoBracketsStack.length > 0 && context.extendedPseudoBracketsStack.length === context.extendedPseudoNamesStack.length;
    const hasAbsoluteExtended = isLastExtendedNameAbsolute && lastExtendedPseudoName === getLast(context.extendedPseudoNamesStack);

    if (hasRelativeExtended) {
      // return relative selector node to update later
      context.pathToBufferNode.push(lastSelectorNodeChild);
      newNeededBufferNode = supposedPseudoClassNode;
    } else if (hasAbsoluteExtended) {
      // return absolute selector node to update later
      context.pathToBufferNode.push(lastSelectorNodeChild);
      newNeededBufferNode = supposedPseudoClassNode;
    }
  } else if (hasExtended) {
    // return selector node to add new regular selector node later
    newNeededBufferNode = selectorNode;
  } else {
    // otherwise return last regular selector node to update later
    newNeededBufferNode = getContextLastRegularSelectorNode(context);
  } // update the path to buffer node properly


  context.pathToBufferNode.push(newNeededBufferNode);
  return newNeededBufferNode;
};
/**
 * Checks values of few next tokens on colon token `:` and:
 *  - updates buffer node for following standard pseudo-class;
 *  - adds extended selector ast node for following extended pseudo-class;
 *  - validates some cases of `:remove()` and `:has()` usage.
 *
 * @param context Selector parser context.
 * @param selector Selector.
 * @param tokenValue Value of current token.
 * @param nextTokenValue Value of token next to current one.
 * @param nextToNextTokenValue Value of token next to next to current one.
 *
 * @throws An error on :remove() pseudo-class in selector
 * or :has() inside regular pseudo limitation.
 */

const handleNextTokenOnColon = (context, selector, tokenValue, nextTokenValue, nextToNextTokenValue) => {
  if (!nextTokenValue) {
    throw new Error(`Invalid colon ':' at the end of selector: '${selector}'`);
  }

  if (!isSupportedPseudoClass(nextTokenValue.toLowerCase())) {
    if (nextTokenValue.toLowerCase() === REMOVE_PSEUDO_MARKER) {
      // :remove() pseudo-class should be handled before
      // as it is not about element selecting but actions with elements
      // e.g. 'body > div:empty:remove()'
      throw new Error(`${REMOVE_ERROR_PREFIX.INVALID_REMOVE}: '${selector}'`);
    } // if following token is not an extended pseudo
    // the colon should be collected to value of RegularSelector
    // e.g. '.entry_text:nth-child(2)'


    updateBufferNode(context, tokenValue); // check the token after the pseudo and do balance parentheses later
    // only if it is functional pseudo-class (standard with brackets, e.g. ':lang()').
    // no brackets balance needed for such case,
    // parser position is on first colon after the 'div':
    // e.g. 'div:last-child:has(button.privacy-policy__btn)'

    if (nextToNextTokenValue && nextToNextTokenValue === BRACKET.PARENTHESES.LEFT // no brackets balance needed for parentheses inside attribute value
    // e.g. 'a[href="javascript:void(0)"]'   <-- parser position is on colon `:`
    // before `void`           ↑
    && !context.isAttributeBracketsOpen) {
      context.standardPseudoNamesStack.push(nextTokenValue);
    }
  } else {
    // it is supported extended pseudo-class.
    // Disallow :has() inside the pseudos accepting only compound selectors
    // https://bugs.chromium.org/p/chromium/issues/detail?id=669058#c54 [2]
    if (HAS_PSEUDO_CLASS_MARKERS.includes(nextTokenValue) && context.standardPseudoNamesStack.length > 0) {
      // eslint-disable-next-line max-len
      throw new Error(`Usage of :${nextTokenValue}() pseudo-class is not allowed inside regular pseudo: '${getLast(context.standardPseudoNamesStack)}'`);
    } else {
      // stop RegularSelector value collecting
      upToClosest(context, NODE.SELECTOR); // add ExtendedSelector to Selector children

      addAstNodeByType(context, NODE.EXTENDED_SELECTOR);
    }
  }
};

// e.g. ':is(.page, .main) > .banner' or '*:not(span):not(p)'

const IS_OR_NOT_PSEUDO_SELECTING_ROOT = `html ${ASTERISK}`;
/**
 * Checks if there are any ExtendedSelector node in selector list.
 *
 * @param selectorList Ast SelectorList node.
 *
 * @returns True if `selectorList` has any inner ExtendedSelector node.
 */

const hasExtendedSelector = selectorList => {
  return selectorList.children.some(selectorNode => {
    return selectorNode.children.some(selectorNodeChild => {
      return isExtendedSelectorNode(selectorNodeChild);
    });
  });
};
/**
 * Converts selector list of RegularSelector nodes to string.
 *
 * @param selectorList Ast SelectorList node.
 *
 * @returns String representation for selector list of regular selectors.
 */


const selectorListOfRegularsToString = selectorList => {
  // if there is no ExtendedSelector in relative SelectorList
  // it means that each Selector node has single child — RegularSelector node
  // and their values should be combined to string
  const standardCssSelectors = selectorList.children.map(selectorNode => {
    const selectorOnlyChild = getNodeOnlyChild(selectorNode, 'Ast Selector node should have RegularSelector node');
    return getNodeValue(selectorOnlyChild);
  });
  return standardCssSelectors.join(`${COMMA}${SPACE}`);
};
/**
 * Updates children of `node` replacing them with `newChildren`.
 * Important: modifies input `node` which is passed by reference.
 *
 * @param node Ast node to update.
 * @param newChildren Array of new children for ast node.
 *
 * @returns Updated ast node.
 */


const updateNodeChildren = (node, newChildren) => {
  node.children = newChildren;
  return node;
};
/**
 * Recursively checks whether the ExtendedSelector node should be optimized.
 * It has to be recursive because RelativePseudoClass has inner SelectorList node.
 *
 * @param currExtendedSelectorNode Ast ExtendedSelector node.
 *
 * @returns True is ExtendedSelector should be optimized.
 */


const shouldOptimizeExtendedSelector = currExtendedSelectorNode => {
  if (currExtendedSelectorNode === null) {
    return false;
  }

  const extendedPseudoClassNode = getPseudoClassNode(currExtendedSelectorNode);
  const pseudoName = getNodeName(extendedPseudoClassNode);

  if (isAbsolutePseudoClass(pseudoName)) {
    return false;
  }

  const relativeSelectorList = getRelativeSelectorListNode(extendedPseudoClassNode);
  const innerSelectorNodes = relativeSelectorList.children; // simple checking for standard selectors in arg of :not() or :is() pseudo-class
  // e.g. 'div > *:is(div, a, span)'

  if (isOptimizationPseudoClass(pseudoName)) {
    const areAllSelectorNodeChildrenRegular = innerSelectorNodes.every(selectorNode => {
      try {
        const selectorOnlyChild = getNodeOnlyChild(selectorNode, 'Selector node should have RegularSelector'); // it means that the only child is RegularSelector and it can be optimized

        return isRegularSelectorNode(selectorOnlyChild);
      } catch (e) {
        return false;
      }
    });

    if (areAllSelectorNodeChildrenRegular) {
      return true;
    }
  } // for other extended pseudo-classes than :not() and :is()


  return innerSelectorNodes.some(selectorNode => {
    return selectorNode.children.some(selectorNodeChild => {
      if (!isExtendedSelectorNode(selectorNodeChild)) {
        return false;
      } // check inner ExtendedSelector recursively
      // e.g. 'div:has(*:not(.header))'


      return shouldOptimizeExtendedSelector(selectorNodeChild);
    });
  });
};
/**
 * Returns optimized ExtendedSelector node if it can be optimized
 * or null if ExtendedSelector is fully optimized while function execution
 * which means that value of `prevRegularSelectorNode` is updated.
 *
 * @param currExtendedSelectorNode Current ExtendedSelector node to optimize.
 * @param prevRegularSelectorNode Previous RegularSelector node.
 *
 * @returns Ast node or null.
 */


const getOptimizedExtendedSelector = (currExtendedSelectorNode, prevRegularSelectorNode) => {
  if (!currExtendedSelectorNode) {
    return null;
  }

  const extendedPseudoClassNode = getPseudoClassNode(currExtendedSelectorNode);
  const relativeSelectorList = getRelativeSelectorListNode(extendedPseudoClassNode);
  const hasInnerExtendedSelector = hasExtendedSelector(relativeSelectorList);

  if (!hasInnerExtendedSelector) {
    // if there is no extended selectors for :not() or :is()
    // e.g. 'div:not(.content, .main)'
    const relativeSelectorListStr = selectorListOfRegularsToString(relativeSelectorList);
    const pseudoName = getNodeName(extendedPseudoClassNode); // eslint-disable-next-line max-len

    const optimizedExtendedStr = `${COLON}${pseudoName}${BRACKET.PARENTHESES.LEFT}${relativeSelectorListStr}${BRACKET.PARENTHESES.RIGHT}`;
    prevRegularSelectorNode.value = `${getNodeValue(prevRegularSelectorNode)}${optimizedExtendedStr}`;
    return null;
  } // eslint-disable-next-line @typescript-eslint/no-use-before-define


  const optimizedRelativeSelectorList = optimizeSelectorListNode(relativeSelectorList);
  const optimizedExtendedPseudoClassNode = updateNodeChildren(extendedPseudoClassNode, [optimizedRelativeSelectorList]);
  return updateNodeChildren(currExtendedSelectorNode, [optimizedExtendedPseudoClassNode]);
};
/**
 * Combines values of `previous` and `current` RegularSelector nodes.
 * It may happen during the optimization when ExtendedSelector between RegularSelector node was optimized.
 *
 * @param current Current RegularSelector node.
 * @param previous Previous RegularSelector node.
 */


const optimizeCurrentRegularSelector = (current, previous) => {
  previous.value = `${getNodeValue(previous)}${SPACE}${getNodeValue(current)}`;
};
/**
 * Optimizes ast Selector node.
 *
 * @param selectorNode Ast Selector node.
 *
 * @returns Optimized ast node.
 * @throws An error while collecting optimized nodes.
 */


const optimizeSelectorNode = selectorNode => {
  // non-optimized list of SelectorNode children
  const rawSelectorNodeChildren = selectorNode.children; // for collecting optimized children list

  const optimizedChildrenList = [];
  let currentIndex = 0; // iterate through all children in non-optimized ast Selector node

  while (currentIndex < rawSelectorNodeChildren.length) {
    const currentChild = getItemByIndex(rawSelectorNodeChildren, currentIndex, 'currentChild should be specified'); // no need to optimize the very first child which is always RegularSelector node

    if (currentIndex === 0) {
      optimizedChildrenList.push(currentChild);
    } else {
      const prevRegularChild = getLastRegularChild(optimizedChildrenList);

      if (isExtendedSelectorNode(currentChild)) {
        // start checking with point is null
        let optimizedExtendedSelector = null; // check whether the optimization is needed

        let isOptimizationNeeded = shouldOptimizeExtendedSelector(currentChild); // update optimizedExtendedSelector so it can be optimized recursively
        // i.e. `getOptimizedExtendedSelector(optimizedExtendedSelector)` below

        optimizedExtendedSelector = currentChild;

        while (isOptimizationNeeded) {
          // recursively optimize ExtendedSelector until no optimization needed
          // e.g. div > *:is(.banner:not(.block))
          optimizedExtendedSelector = getOptimizedExtendedSelector(optimizedExtendedSelector, prevRegularChild);
          isOptimizationNeeded = shouldOptimizeExtendedSelector(optimizedExtendedSelector);
        } // if it was simple :not() of :is() with standard selector arg
        // e.g. 'div:not([class][id])'
        // or   '.main > *:is([data-loaded], .banner)'
        // after the optimization the ExtendedSelector node become part of RegularSelector
        // so nothing to save eventually
        // otherwise the optimized ExtendedSelector should be saved
        // e.g. 'div:has(:not([class]))'


        if (optimizedExtendedSelector !== null) {
          optimizedChildrenList.push(optimizedExtendedSelector); // if optimization is not needed

          const optimizedPseudoClass = getPseudoClassNode(optimizedExtendedSelector);
          const optimizedPseudoName = getNodeName(optimizedPseudoClass); // parent element checking is used to apply :is() and :not() pseudo-classes as extended.
          // as there is no parentNode for root element (html)
          // so element selection should be limited to it's children
          // e.g. '*:is(:has(.page))' -> 'html *:is(has(.page))'
          // or   '*:not(:has(span))' -> 'html *:not(:has(span))'

          if (getNodeValue(prevRegularChild) === ASTERISK && isOptimizationPseudoClass(optimizedPseudoName)) {
            prevRegularChild.value = IS_OR_NOT_PSEUDO_SELECTING_ROOT;
          }
        }
      } else if (isRegularSelectorNode(currentChild)) {
        // in non-optimized ast, RegularSelector node may follow ExtendedSelector which should be optimized
        // for example, for 'div:not(.content) > .banner' schematically it looks like
        // non-optimized ast: [
        //   1. RegularSelector: 'div'
        //   2. ExtendedSelector: 'not(.content)'
        //   3. RegularSelector: '> .banner'
        // ]
        // which after the ExtendedSelector looks like
        // partly optimized ast: [
        //   1. RegularSelector: 'div:not(.content)'
        //   2. RegularSelector: '> .banner'
        // ]
        // so second RegularSelector value should be combined with first one
        // optimized ast: [
        //   1. RegularSelector: 'div:not(.content) > .banner'
        // ]
        // here we check **children of selectorNode** after previous optimization if it was
        const lastOptimizedChild = getLast(optimizedChildrenList) || null;

        if (isRegularSelectorNode(lastOptimizedChild)) {
          optimizeCurrentRegularSelector(currentChild, prevRegularChild);
        }
      }
    }

    currentIndex += 1;
  }

  return updateNodeChildren(selectorNode, optimizedChildrenList);
};
/**
 * Optimizes ast SelectorList node.
 *
 * @param selectorListNode SelectorList node.
 *
 * @returns Optimized ast node.
 */


const optimizeSelectorListNode = selectorListNode => {
  return updateNodeChildren(selectorListNode, selectorListNode.children.map(s => optimizeSelectorNode(s)));
};
/**
 * Optimizes ast:
 * If arg of :not() and :is() pseudo-classes does not contain extended selectors,
 * native Document.querySelectorAll() can be used to query elements.
 * It means that ExtendedSelector ast nodes can be removed
 * and value of relevant RegularSelector node should be updated accordingly.
 *
 * @param ast Non-optimized ast.
 *
 * @returns Optimized ast.
 */


const optimizeAst = ast => {
  // ast is basically the selector list of selectors
  return optimizeSelectorListNode(ast);
};

// https://github.com/AdguardTeam/ExtendedCss/issues/115

const XPATH_PSEUDO_SELECTING_ROOT = 'body';
const NO_WHITESPACE_ERROR_PREFIX = 'No white space is allowed before or after extended pseudo-class name in selector';
/**
 * Parses selector into ast for following element selection.
 *
 * @param selector Selector to parse.
 *
 * @returns Parsed ast.
 * @throws An error on invalid selector.
 */

const parse = selector => {
  const tokens = tokenizeSelector(selector);
  const context = {
    ast: null,
    pathToBufferNode: [],
    extendedPseudoNamesStack: [],
    extendedPseudoBracketsStack: [],
    standardPseudoNamesStack: [],
    standardPseudoBracketsStack: [],
    isAttributeBracketsOpen: false,
    attributeBuffer: '',
    isRegexpOpen: false,
    shouldOptimize: false
  };
  let i = 0;

  while (i < tokens.length) {
    const token = tokens[i];

    if (!token) {
      break;
    } // Token to process


    const {
      type: tokenType,
      value: tokenValue
    } = token; // needed for SPACE and COLON tokens checking

    const nextToken = tokens[i + 1];
    const nextTokenType = nextToken === null || nextToken === void 0 ? void 0 : nextToken.type;
    const nextTokenValue = nextToken === null || nextToken === void 0 ? void 0 : nextToken.value; // needed for limitations
    // - :not() and :is() root element
    // - :has() usage
    // - white space before and after pseudo-class name

    const nextToNextToken = tokens[i + 2];
    const nextToNextTokenValue = nextToNextToken === null || nextToNextToken === void 0 ? void 0 : nextToNextToken.value; // needed for COLON token checking for none-specified regular selector before extended one
    // e.g. 'p, :hover'
    // or   '.banner, :contains(ads)'

    const previousToken = tokens[i - 1];
    const prevTokenType = previousToken === null || previousToken === void 0 ? void 0 : previousToken.type;
    const prevTokenValue = previousToken === null || previousToken === void 0 ? void 0 : previousToken.value; // needed for proper parsing of regexp pattern arg
    // e.g. ':matches-css(background-image: /^url\(https:\/\/example\.org\//)'

    const previousToPreviousToken = tokens[i - 2];
    const prevToPrevTokenValue = previousToPreviousToken === null || previousToPreviousToken === void 0 ? void 0 : previousToPreviousToken.value;
    let bufferNode = getBufferNode(context);

    switch (tokenType) {
      case TOKEN_TYPE.WORD:
        if (bufferNode === null) {
          // there is no buffer node only in one case — no ast collecting has been started
          initAst(context, tokenValue);
        } else if (isSelectorListNode(bufferNode)) {
          // add new selector to selector list
          addAstNodeByType(context, NODE.SELECTOR);
          addAstNodeByType(context, NODE.REGULAR_SELECTOR, tokenValue);
        } else if (isRegularSelectorNode(bufferNode)) {
          updateBufferNode(context, tokenValue);
        } else if (isExtendedSelectorNode(bufferNode)) {
          // No white space is allowed between the name of extended pseudo-class
          // and its opening parenthesis
          // https://www.w3.org/TR/selectors-4/#pseudo-classes
          // e.g. 'span:contains (text)'
          if (isWhiteSpaceChar(nextTokenValue) && nextToNextTokenValue === BRACKET.PARENTHESES.LEFT) {
            throw new Error(`${NO_WHITESPACE_ERROR_PREFIX}: '${selector}'`);
          }

          const lowerCaseTokenValue = tokenValue.toLowerCase(); // save pseudo-class name for brackets balance checking

          context.extendedPseudoNamesStack.push(lowerCaseTokenValue); // extended pseudo-class name are parsed in lower case
          // as they should be case-insensitive
          // https://www.w3.org/TR/selectors-4/#pseudo-classes

          if (isAbsolutePseudoClass(lowerCaseTokenValue)) {
            addAstNodeByType(context, NODE.ABSOLUTE_PSEUDO_CLASS, lowerCaseTokenValue);
          } else {
            // if it is not absolute pseudo-class, it must be relative one
            // add RelativePseudoClass with tokenValue as pseudo-class name to ExtendedSelector children
            addAstNodeByType(context, NODE.RELATIVE_PSEUDO_CLASS, lowerCaseTokenValue); // for :not() and :is() pseudo-classes parsed ast should be optimized later

            if (isOptimizationPseudoClass(lowerCaseTokenValue)) {
              context.shouldOptimize = true;
            }
          }
        } else if (isAbsolutePseudoClassNode(bufferNode)) {
          // collect absolute pseudo-class arg
          updateBufferNode(context, tokenValue);
        } else if (isRelativePseudoClassNode(bufferNode)) {
          initRelativeSubtree(context, tokenValue);
        }

        break;

      case TOKEN_TYPE.MARK:
        switch (tokenValue) {
          case COMMA:
            if (!bufferNode || typeof bufferNode !== 'undefined' && !nextTokenValue) {
              // consider the selector is invalid if there is no bufferNode yet (e.g. ', a')
              // or there is nothing after the comma while bufferNode is defined (e.g. 'div, ')
              throw new Error(`'${selector}' is not a valid selector`);
            } else if (isRegularSelectorNode(bufferNode)) {
              if (context.isAttributeBracketsOpen) {
                // the comma might be inside element attribute value
                // e.g. 'div[data-comma="0,1"]'
                updateBufferNode(context, tokenValue);
              } else {
                // new Selector should be collected to upper SelectorList
                upToClosest(context, NODE.SELECTOR_LIST);
              }
            } else if (isAbsolutePseudoClassNode(bufferNode)) {
              // the comma inside arg of absolute extended pseudo
              // e.g. 'div:xpath(//h3[contains(text(),"Share it!")]/..)'
              updateBufferNode(context, tokenValue);
            } else if (isSelectorNode(bufferNode)) {
              // new Selector should be collected to upper SelectorList
              // if parser position is on Selector node
              upToClosest(context, NODE.SELECTOR_LIST);
            }

            break;

          case SPACE:
            // it might be complex selector with extended pseudo-class inside it
            // and the space is between that complex selector and following regular selector
            // parser position is on ` ` before `span` now:
            // e.g. 'div:has(img).banner span'
            // so we need to check whether the new ast node should be added (example above)
            // or previous regular selector node should be updated
            if (isRegularSelectorNode(bufferNode) // no need to update the buffer node if attribute value is being parsed
            // e.g. 'div:not([id])[style="position: absolute; z-index: 10000;"]'
            // parser position inside attribute    ↑
            && !context.isAttributeBracketsOpen) {
              bufferNode = getUpdatedBufferNode(context);
            }

            if (isRegularSelectorNode(bufferNode)) {
              // standard selectors with white space between colon and name of pseudo
              // are invalid for native document.querySelectorAll() anyway,
              // so throwing the error here is better
              // than proper parsing of invalid selector and passing it further.
              // first of all do not check attributes
              // e.g. div[style="text-align: center"]
              if (!context.isAttributeBracketsOpen // check the space after the colon and before the pseudo
              // e.g. '.block: nth-child(2)
              && (prevTokenValue === COLON && nextTokenType === TOKEN_TYPE.WORD // or after the pseudo and before the opening parenthesis
              // e.g. '.block:nth-child (2)
              || prevTokenType === TOKEN_TYPE.WORD && nextTokenValue === BRACKET.PARENTHESES.LEFT)) {
                throw new Error(`'${selector}' is not a valid selector`);
              } // collect current tokenValue to value of RegularSelector
              // if it is the last token or standard selector continues after the space.
              // otherwise it will be skipped


              if (!nextTokenValue || doesRegularContinueAfterSpace(nextTokenType, nextTokenValue) // we also should collect space inside attribute value
              // e.g. `[onclick^="window.open ('https://example.com/share?url="]`
              // parser position             ↑
              || context.isAttributeBracketsOpen) {
                updateBufferNode(context, tokenValue);
              }
            }

            if (isAbsolutePseudoClassNode(bufferNode)) {
              // space inside extended pseudo-class arg
              // e.g. 'span:contains(some text)'
              updateBufferNode(context, tokenValue);
            }

            if (isRelativePseudoClassNode(bufferNode)) {
              // init with empty value RegularSelector
              // as the space is not needed for selector value
              // e.g. 'p:not( .content )'
              initRelativeSubtree(context);
            }

            if (isSelectorNode(bufferNode)) {
              // do NOT add RegularSelector if parser position on space BEFORE the comma in selector list
              // e.g. '.block:has(> img) , .banner)'
              if (doesRegularContinueAfterSpace(nextTokenType, nextTokenValue)) {
                // regular selector might be after the extended one.
                // extra space before combinator or selector should not be collected
                // e.g. '.banner:upward(2) .block'
                //      '.banner:upward(2) > .block'
                // so no tokenValue passed to addAnySelectorNode()
                addAstNodeByType(context, NODE.REGULAR_SELECTOR);
              }
            }

            break;

          case DESCENDANT_COMBINATOR:
          case CHILD_COMBINATOR:
          case NEXT_SIBLING_COMBINATOR:
          case SUBSEQUENT_SIBLING_COMBINATOR:
          case SEMICOLON:
          case SLASH:
          case BACKSLASH:
          case SINGLE_QUOTE:
          case DOUBLE_QUOTE:
          case CARET:
          case DOLLAR_SIGN:
          case BRACKET.CURLY.LEFT:
          case BRACKET.CURLY.RIGHT:
          case ASTERISK:
          case ID_MARKER:
          case CLASS_MARKER:
          case BRACKET.SQUARE.LEFT:
            // it might be complex selector with extended pseudo-class inside it
            // and the space is between that complex selector and following regular selector
            // e.g. 'div:has(img).banner'   // parser position is on `.` before `banner` now
            //      'div:has(img)[attr]'    // parser position is on `[` before `attr` now
            // so we need to check whether the new ast node should be added (example above)
            // or previous regular selector node should be updated
            if (COMBINATORS.includes(tokenValue)) {
              if (bufferNode === null) {
                // cases where combinator at very beginning of a selector
                // e.g. '> div'
                // or   '~ .banner'
                // or even '+js(overlay-buster)' which not a selector at all
                // but may be validated by FilterCompiler so error message should be appropriate
                throw new Error(`'${selector}' is not a valid selector`);
              }

              bufferNode = getUpdatedBufferNode(context);
            }

            if (bufferNode === null) {
              // no ast collecting has been started
              // e.g. '.banner > p'
              // or   '#top > div.ad'
              // or   '[class][style][attr]'
              // or   '*:not(span)'
              initAst(context, tokenValue);

              if (isAttributeOpening(tokenValue, prevTokenValue)) {
                // e.g. '[class^="banner-"]'
                context.isAttributeBracketsOpen = true;
              }
            } else if (isRegularSelectorNode(bufferNode)) {
              if (tokenValue === BRACKET.CURLY.LEFT && !(context.isAttributeBracketsOpen || context.isRegexpOpen)) {
                // e.g. 'div { content: "'
                throw new Error(`'${selector}' is not a valid selector`);
              } // collect the mark to the value of RegularSelector node


              updateBufferNode(context, tokenValue);

              if (isAttributeOpening(tokenValue, prevTokenValue)) {
                // needed for proper handling element attribute value with comma
                // e.g. 'div[data-comma="0,1"]'
                context.isAttributeBracketsOpen = true;
              }
            } else if (isAbsolutePseudoClassNode(bufferNode)) {
              // collect the mark to the arg of AbsolutePseudoClass node
              updateBufferNode(context, tokenValue); // 'isRegexpOpen' flag is needed for brackets balancing inside extended pseudo-class arg

              if (tokenValue === SLASH && context.extendedPseudoNamesStack.length > 0) {
                if (prevTokenValue === SLASH && prevToPrevTokenValue === BACKSLASH) {
                  // it may be specific url regexp pattern in arg of pseudo-class
                  // e.g. ':matches-css(background-image: /^url\(https:\/\/example\.org\//)'
                  // parser position is on final slash before `)`                        ↑
                  context.isRegexpOpen = false;
                } else if (prevTokenValue && prevTokenValue !== BACKSLASH) {
                  if (isRegexpOpening(context, prevTokenValue, getNodeValue(bufferNode))) {
                    context.isRegexpOpen = !context.isRegexpOpen;
                  } else {
                    // otherwise force `isRegexpOpen` flag to `false`
                    context.isRegexpOpen = false;
                  }
                }
              }
            } else if (isRelativePseudoClassNode(bufferNode)) {
              // add SelectorList to children of RelativePseudoClass node
              initRelativeSubtree(context, tokenValue);

              if (isAttributeOpening(tokenValue, prevTokenValue)) {
                // besides of creating the relative subtree
                // opening square bracket means start of attribute
                // e.g. 'div:not([class="content"])'
                //      'div:not([href*="window.print()"])'
                context.isAttributeBracketsOpen = true;
              }
            } else if (isSelectorNode(bufferNode)) {
              // after the extended pseudo closing parentheses
              // parser position is on Selector node
              // and regular selector can be after the extended one
              // e.g. '.banner:upward(2)> .block'
              // or   '.inner:nth-ancestor(1)~ .banner'
              if (COMBINATORS.includes(tokenValue)) {
                addAstNodeByType(context, NODE.REGULAR_SELECTOR, tokenValue);
              } else if (!context.isRegexpOpen) {
                // it might be complex selector with extended pseudo-class inside it.
                // parser position is on `.` now:
                // e.g. 'div:has(img).banner'
                // so we need to get last regular selector node and update its value
                bufferNode = getContextLastRegularSelectorNode(context);
                updateBufferNode(context, tokenValue);

                if (isAttributeOpening(tokenValue, prevTokenValue)) {
                  // handle attribute in compound selector after extended pseudo-class
                  // e.g. 'div:not(.top)[style="z-index: 10000;"]'
                  // parser position    ↑
                  context.isAttributeBracketsOpen = true;
                }
              }
            } else if (isSelectorListNode(bufferNode)) {
              // add Selector to SelectorList
              addAstNodeByType(context, NODE.SELECTOR); // and RegularSelector as it is always the first child of Selector

              addAstNodeByType(context, NODE.REGULAR_SELECTOR, tokenValue);

              if (isAttributeOpening(tokenValue, prevTokenValue)) {
                // handle simple attribute selector in selector list
                // e.g. '.banner, [class^="ad-"]'
                context.isAttributeBracketsOpen = true;
              }
            }

            break;

          case BRACKET.SQUARE.RIGHT:
            if (isRegularSelectorNode(bufferNode)) {
              // unescaped `]` in regular selector allowed only inside attribute value
              if (!context.isAttributeBracketsOpen && prevTokenValue !== BACKSLASH) {
                // e.g. 'div]'
                // eslint-disable-next-line max-len
                throw new Error(`'${selector}' is not a valid selector due to '${tokenValue}' after '${getNodeValue(bufferNode)}'`);
              } // needed for proper parsing regular selectors after the attributes with comma
              // e.g. 'div[data-comma="0,1"] > img'


              if (isAttributeClosing(context)) {
                context.isAttributeBracketsOpen = false; // reset attribute buffer on closing `]`

                context.attributeBuffer = '';
              } // collect the bracket to the value of RegularSelector node


              updateBufferNode(context, tokenValue);
            }

            if (isAbsolutePseudoClassNode(bufferNode)) {
              // :xpath() expended pseudo-class arg might contain square bracket
              // so it should be collected
              // e.g. 'div:xpath(//h3[contains(text(),"Share it!")]/..)'
              updateBufferNode(context, tokenValue);
            }

            break;

          case COLON:
            // No white space is allowed between the colon and the following name of the pseudo-class
            // https://www.w3.org/TR/selectors-4/#pseudo-classes
            // e.g. 'span: contains(text)'
            if (isWhiteSpaceChar(nextTokenValue) && nextToNextTokenValue && SUPPORTED_PSEUDO_CLASSES.includes(nextToNextTokenValue)) {
              throw new Error(`${NO_WHITESPACE_ERROR_PREFIX}: '${selector}'`);
            }

            if (bufferNode === null) {
              // no ast collecting has been started
              if (nextTokenValue === XPATH_PSEUDO_CLASS_MARKER) {
                // limit applying of "naked" :xpath pseudo-class
                // https://github.com/AdguardTeam/ExtendedCss/issues/115
                initAst(context, XPATH_PSEUDO_SELECTING_ROOT);
              } else if (nextTokenValue === UPWARD_PSEUDO_CLASS_MARKER || nextTokenValue === NTH_ANCESTOR_PSEUDO_CLASS_MARKER) {
                // selector should be specified before :nth-ancestor() or :upward()
                // e.g. ':nth-ancestor(3)'
                // or   ':upward(span)'
                throw new Error(`${NO_SELECTOR_ERROR_PREFIX} before :${nextTokenValue}() pseudo-class`);
              } else {
                // make it more obvious if selector starts with pseudo with no tag specified
                // e.g. ':has(a)' -> '*:has(a)'
                // or   ':empty'  -> '*:empty'
                initAst(context, ASTERISK);
              } // bufferNode should be updated for following checking


              bufferNode = getBufferNode(context);
            }

            if (isSelectorListNode(bufferNode)) {
              // bufferNode is SelectorList after comma has been parsed.
              // parser position is on colon now:
              // e.g. 'img,:not(.content)'
              addAstNodeByType(context, NODE.SELECTOR); // add empty value RegularSelector anyway as any selector should start with it
              // and check previous token on the next step

              addAstNodeByType(context, NODE.REGULAR_SELECTOR); // bufferNode should be updated for following checking

              bufferNode = getBufferNode(context);
            }

            if (isRegularSelectorNode(bufferNode)) {
              // it can be extended or standard pseudo
              // e.g. '#share, :contains(share it)'
              // or   'div,:hover'
              // of   'div:has(+:contains(text))'  // position is after '+'
              if (prevTokenValue && COMBINATORS.includes(prevTokenValue) || prevTokenValue === COMMA) {
                // case with colon at the start of string - e.g. ':contains(text)'
                // is covered by 'bufferNode === null' above at start of COLON checking
                updateBufferNode(context, ASTERISK);
              }

              handleNextTokenOnColon(context, selector, tokenValue, nextTokenValue, nextToNextTokenValue);
            }

            if (isSelectorNode(bufferNode)) {
              // e.g. 'div:contains(text):'
              if (!nextTokenValue) {
                throw new Error(`Invalid colon ':' at the end of selector: '${selector}'`);
              } // after the extended pseudo closing parentheses
              // parser position is on Selector node
              // and there is might be another extended selector.
              // parser position is on colon before 'upward':
              // e.g. 'p:contains(PR):upward(2)'


              if (isSupportedPseudoClass(nextTokenValue.toLowerCase())) {
                // if supported extended pseudo-class is next to colon
                // add ExtendedSelector to Selector children
                addAstNodeByType(context, NODE.EXTENDED_SELECTOR);
              } else if (nextTokenValue.toLowerCase() === REMOVE_PSEUDO_MARKER) {
                // :remove() pseudo-class should be handled before
                // as it is not about element selecting but actions with elements
                // e.g. '#banner:upward(2):remove()'
                throw new Error(`${REMOVE_ERROR_PREFIX.INVALID_REMOVE}: '${selector}'`);
              } else {
                // otherwise it is standard pseudo after extended pseudo-class in complex selector
                // and colon should be collected to value of previous RegularSelector
                // e.g. 'body *:not(input)::selection'
                //      'input:matches-css(padding: 10):checked'
                bufferNode = getContextLastRegularSelectorNode(context);
                handleNextTokenOnColon(context, selector, tokenValue, nextTokenType, nextToNextTokenValue);
              }
            }

            if (isAbsolutePseudoClassNode(bufferNode)) {
              // :xpath() pseudo-class should be the last of extended pseudo-classes
              if (getNodeName(bufferNode) === XPATH_PSEUDO_CLASS_MARKER && nextTokenValue && SUPPORTED_PSEUDO_CLASSES.includes(nextTokenValue) && nextToNextTokenValue === BRACKET.PARENTHESES.LEFT) {
                throw new Error(`:xpath() pseudo-class should be the last in selector: '${selector}'`);
              } // collecting arg for absolute pseudo-class
              // e.g. 'div:matches-css(width:400px)'


              updateBufferNode(context, tokenValue);
            }

            if (isRelativePseudoClassNode(bufferNode)) {
              if (!nextTokenValue) {
                // e.g. 'div:has(:'
                throw new Error(`Invalid pseudo-class arg at the end of selector: '${selector}'`);
              } // make it more obvious if selector starts with pseudo with no tag specified
              // parser position is on colon inside :has() arg
              // e.g. 'div:has(:contains(text))'
              // or   'div:not(:empty)'


              initRelativeSubtree(context, ASTERISK);

              if (!isSupportedPseudoClass(nextTokenValue.toLowerCase())) {
                // collect the colon to value of RegularSelector
                // e.g. 'div:not(:empty)'
                updateBufferNode(context, tokenValue); // parentheses should be balanced only for functional pseudo-classes
                // e.g. '.yellow:not(:nth-child(3))'

                if (nextToNextTokenValue === BRACKET.PARENTHESES.LEFT) {
                  context.standardPseudoNamesStack.push(nextTokenValue);
                }
              } else {
                // add ExtendedSelector to Selector children
                // e.g. 'div:has(:contains(text))'
                upToClosest(context, NODE.SELECTOR);
                addAstNodeByType(context, NODE.EXTENDED_SELECTOR);
              }
            }

            break;

          case BRACKET.PARENTHESES.LEFT:
            // start of pseudo-class arg
            if (isAbsolutePseudoClassNode(bufferNode)) {
              // no brackets balancing needed inside
              // 1. :xpath() extended pseudo-class arg
              // 2. regexp arg for other extended pseudo-classes
              if (getNodeName(bufferNode) !== XPATH_PSEUDO_CLASS_MARKER && context.isRegexpOpen) {
                // if the parentheses is escaped it should be part of regexp
                // collect it to arg of AbsolutePseudoClass
                // e.g. 'div:matches-css(background-image: /^url\\("data:image\\/gif;base64.+/)'
                updateBufferNode(context, tokenValue);
              } else {
                // otherwise brackets should be balanced
                // e.g. 'div:xpath(//h3[contains(text(),"Share it!")]/..)'
                context.extendedPseudoBracketsStack.push(tokenValue); // eslint-disable-next-line max-len

                if (context.extendedPseudoBracketsStack.length > context.extendedPseudoNamesStack.length) {
                  updateBufferNode(context, tokenValue);
                }
              }
            }

            if (isRegularSelectorNode(bufferNode)) {
              // continue RegularSelector value collecting for standard pseudo-classes
              // e.g. '.banner:where(div)'
              if (context.standardPseudoNamesStack.length > 0) {
                updateBufferNode(context, tokenValue);
                context.standardPseudoBracketsStack.push(tokenValue);
              } // parentheses inside attribute value should be part of RegularSelector value
              // e.g. 'div:not([href*="window.print()"])'   <-- parser position
              // is on the `(` after `print`       ↑


              if (context.isAttributeBracketsOpen) {
                updateBufferNode(context, tokenValue);
              }
            }

            if (isRelativePseudoClassNode(bufferNode)) {
              // save opening bracket for balancing
              // e.g. 'div:not()'  // position is on `(`
              context.extendedPseudoBracketsStack.push(tokenValue);
            }

            break;

          case BRACKET.PARENTHESES.RIGHT:
            if (isAbsolutePseudoClassNode(bufferNode)) {
              // no brackets balancing needed inside
              // 1. :xpath() extended pseudo-class arg
              // 2. regexp arg for other extended pseudo-classes
              if (getNodeName(bufferNode) !== XPATH_PSEUDO_CLASS_MARKER && context.isRegexpOpen) {
                // if closing bracket is part of regexp
                // simply save it to pseudo-class arg
                updateBufferNode(context, tokenValue);
              } else {
                // remove stacked open parentheses for brackets balance
                // e.g. 'h3:contains((Ads))'
                // or   'div:xpath(//h3[contains(text(),"Share it!")]/..)'
                context.extendedPseudoBracketsStack.pop();

                if (getNodeName(bufferNode) !== XPATH_PSEUDO_CLASS_MARKER) {
                  // for all other absolute pseudo-classes except :xpath()
                  // remove stacked name of extended pseudo-class
                  context.extendedPseudoNamesStack.pop(); // eslint-disable-next-line max-len

                  if (context.extendedPseudoBracketsStack.length > context.extendedPseudoNamesStack.length) {
                    // if brackets stack is not empty yet,
                    // save tokenValue to arg of AbsolutePseudoClass
                    // parser position on first closing bracket after 'Ads':
                    // e.g. 'h3:contains((Ads))'
                    updateBufferNode(context, tokenValue);
                  } else if (context.extendedPseudoBracketsStack.length >= 0 && context.extendedPseudoNamesStack.length >= 0) {
                    // assume it is combined extended pseudo-classes
                    // parser position on first closing bracket after 'advert':
                    // e.g. 'div:has(.banner, :contains(advert))'
                    upToClosest(context, NODE.SELECTOR);
                  }
                } else {
                  // for :xpath()
                  // eslint-disable-next-line max-len
                  if (context.extendedPseudoBracketsStack.length < context.extendedPseudoNamesStack.length) {
                    // remove stacked name of extended pseudo-class
                    // if there are less brackets than pseudo-class names
                    // with means last removes bracket was closing for pseudo-class
                    context.extendedPseudoNamesStack.pop();
                  } else {
                    // otherwise the bracket is part of arg
                    updateBufferNode(context, tokenValue);
                  }
                }
              }
            }

            if (isRegularSelectorNode(bufferNode)) {
              if (context.isAttributeBracketsOpen) {
                // parentheses inside attribute value should be part of RegularSelector value
                // e.g. 'div:not([href*="window.print()"])'   <-- parser position
                // is on the `)` after `print(`       ↑
                updateBufferNode(context, tokenValue);
              } else if (context.standardPseudoNamesStack.length > 0 && context.standardPseudoBracketsStack.length > 0) {
                // standard pseudo-class was processing.
                // collect the closing bracket to value of RegularSelector
                // parser position is on bracket after 'class' now:
                // e.g. 'div:where(.class)'
                updateBufferNode(context, tokenValue); // remove bracket and pseudo name from stacks

                context.standardPseudoBracketsStack.pop();
                const lastStandardPseudo = context.standardPseudoNamesStack.pop();

                if (!lastStandardPseudo) {
                  // standard pseudo should be in standardPseudoNamesStack
                  // as related to standardPseudoBracketsStack
                  throw new Error(`Parsing error. Invalid selector: ${selector}`);
                } // Disallow :has() after regular pseudo-elements
                // https://bugs.chromium.org/p/chromium/issues/detail?id=669058#c54 [3]


                if (Object.values(REGULAR_PSEUDO_ELEMENTS).includes(lastStandardPseudo) // check token which is next to closing parentheses and token after it
                // parser position is on bracket after 'foo' now:
                // e.g. '::part(foo):has(.a)'
                && nextTokenValue === COLON && nextToNextTokenValue && HAS_PSEUDO_CLASS_MARKERS.includes(nextToNextTokenValue)) {
                  // eslint-disable-next-line max-len
                  throw new Error(`Usage of :${nextToNextTokenValue}() pseudo-class is not allowed after any regular pseudo-element: '${lastStandardPseudo}'`);
                }
              } else {
                // extended pseudo-class was processing.
                // e.g. 'div:has(h3)'
                // remove bracket and pseudo name from stacks
                context.extendedPseudoBracketsStack.pop();
                context.extendedPseudoNamesStack.pop();
                upToClosest(context, NODE.EXTENDED_SELECTOR); // go to upper selector for possible selector continuation after extended pseudo-class
                // e.g. 'div:has(h3) > img'

                upToClosest(context, NODE.SELECTOR);
              }
            }

            if (isSelectorNode(bufferNode)) {
              // after inner extended pseudo-class bufferNode is Selector.
              // parser position is on last bracket now:
              // e.g. 'div:has(.banner, :contains(ads))'
              context.extendedPseudoBracketsStack.pop();
              context.extendedPseudoNamesStack.pop();
              upToClosest(context, NODE.EXTENDED_SELECTOR);
              upToClosest(context, NODE.SELECTOR);
            }

            if (isRelativePseudoClassNode(bufferNode)) {
              // save opening bracket for balancing
              // e.g. 'div:not()'  // position is on `)`
              // context.extendedPseudoBracketsStack.push(tokenValue);
              if (context.extendedPseudoNamesStack.length > 0 && context.extendedPseudoBracketsStack.length > 0) {
                context.extendedPseudoBracketsStack.pop();
                context.extendedPseudoNamesStack.pop();
              }
            }

            break;

          case LINE_FEED:
          case FORM_FEED:
          case CARRIAGE_RETURN:
            // such characters at start and end of selector should be trimmed
            // so is there is one them among tokens, it is not valid selector
            throw new Error(`'${selector}' is not a valid selector`);

          case TAB:
            // allow tab only inside attribute value
            // as there are such valid rules in filter lists
            // e.g. 'div[style^="margin-right: auto;	text-align: left;',
            // parser position                      ↑
            if (isRegularSelectorNode(bufferNode) && context.isAttributeBracketsOpen) {
              updateBufferNode(context, tokenValue);
            } else {
              // otherwise not valid
              throw new Error(`'${selector}' is not a valid selector`);
            }

        }

        break;
      // no default statement for Marks as they are limited to SUPPORTED_SELECTOR_MARKS
      // and all other symbol combinations are tokenized as Word
      // so error for invalid Word will be thrown later while element selecting by parsed ast

      default:
        throw new Error(`Unknown type of token: '${tokenValue}'`);
    }

    i += 1;
  }

  if (context.ast === null) {
    throw new Error(`'${selector}' is not a valid selector`);
  }

  if (context.extendedPseudoNamesStack.length > 0 || context.extendedPseudoBracketsStack.length > 0) {
    // eslint-disable-next-line max-len
    throw new Error(`Unbalanced brackets for extended pseudo-class: '${getLast(context.extendedPseudoNamesStack)}'`);
  }

  if (context.isAttributeBracketsOpen) {
    throw new Error(`Unbalanced attribute brackets in selector: '${selector}'`);
  }

  return context.shouldOptimize ? optimizeAst(context.ast) : context.ast;
};

const natives = {
  MutationObserver: window.MutationObserver || window.WebKitMutationObserver
};
/**
 * Class NativeTextContent is needed to intercept and save the native Node textContent getter
 * for proper work of :contains() pseudo-class as it may be mocked.
 *
 * @see {@link https://github.com/AdguardTeam/ExtendedCss/issues/127}
 */

class NativeTextContent {
  /**
   * Native Node.
   */

  /**
   * Native Node textContent getter.
   */

  /**
   * Stores native node.
   */
  constructor() {
    this.nativeNode = window.Node || Node;
  }
  /**
   * Sets native Node textContext getter to `getter` class field.
   */


  setGetter() {
    var _Object$getOwnPropert;

    this.getter = (_Object$getOwnPropert = Object.getOwnPropertyDescriptor(this.nativeNode.prototype, 'textContent')) === null || _Object$getOwnPropert === void 0 ? void 0 : _Object$getOwnPropert.get;
  }

}
const nativeTextContent = new NativeTextContent();

/**
 * Returns textContent of passed domElement.
 *
 * @param domElement DOM element.
 *
 * @returns DOM element textContent.
 */

const getNodeTextContent = domElement => {
  if (nativeTextContent.getter) {
    return nativeTextContent.getter.apply(domElement);
  } // if ExtendedCss.init() has not been executed and there is no nodeTextContentGetter,
  // use simple approach, especially when init() is not really needed, e.g. local tests


  return domElement.textContent || '';
};
/**
 * Returns element selector text based on it's tagName and attributes.
 *
 * @param element DOM element.
 *
 * @returns String representation of `element`.
 */

const getElementSelectorDesc = element => {
  let selectorText = element.tagName.toLowerCase();
  selectorText += Array.from(element.attributes).map(attr => {
    return `[${attr.name}="${element.getAttribute(attr.name)}"]`;
  }).join('');
  return selectorText;
};
/**
 * Returns path to a DOM element as a selector string.
 *
 * @param inputEl Input element.
 *
 * @returns String path to a DOM element.
 * @throws An error if `inputEl` in not instance of `Element`.
 */

const getElementSelectorPath = inputEl => {
  if (!(inputEl instanceof Element)) {
    throw new Error('Function received argument with wrong type');
  }

  let el;
  el = inputEl;
  const path = []; // we need to check '!!el' first because it is possible
  // that some ancestor of the inputEl was removed before it

  while (!!el && el.nodeType === Node.ELEMENT_NODE) {
    let selector = el.nodeName.toLowerCase();

    if (el.id && typeof el.id === 'string') {
      selector += `#${el.id}`;
      path.unshift(selector);
      break;
    }

    let sibling = el;
    let nth = 1;

    while (sibling.previousElementSibling) {
      sibling = sibling.previousElementSibling;

      if (sibling.nodeType === Node.ELEMENT_NODE && sibling.nodeName.toLowerCase() === selector) {
        nth += 1;
      }
    }

    if (nth !== 1) {
      selector += `:nth-of-type(${nth})`;
    }

    path.unshift(selector);
    el = el.parentElement;
  }

  return path.join(' > ');
};
/**
 * Checks whether the element is instance of HTMLElement.
 *
 * @param element Element to check.
 *
 * @returns True if `element` is HTMLElement.
 */

const isHtmlElement = element => {
  return element instanceof HTMLElement;
};
/**
 * Takes `element` and returns its parent element.
 *
 * @param element Element.
 * @param errorMessage Optional error message to throw.
 *
 * @returns Parent of `element`.
 * @throws An error if element has no parent element.
 */

const getParent = (element, errorMessage) => {
  const {
    parentElement
  } = element;

  if (!parentElement) {
    throw new Error(errorMessage || 'Element does no have parent element');
  }

  return parentElement;
};

/**
 * Checks whether the `error` has `message` property which type is string.
 *
 * @param error Error object.
 *
 * @returns True if `error` has message.
 */
const isErrorWithMessage = error => {
  return typeof error === 'object' && error !== null && 'message' in error && typeof error.message === 'string';
};
/**
 * Converts `maybeError` to error object with message.
 *
 * @param maybeError Possible error.
 *
 * @returns Error object with defined `message` property.
 */


const toErrorWithMessage = maybeError => {
  if (isErrorWithMessage(maybeError)) {
    return maybeError;
  }

  try {
    return new Error(JSON.stringify(maybeError));
  } catch {
    // fallback in case if there is an error happened during the maybeError stringifying
    // like with circular references for example
    return new Error(String(maybeError));
  }
};
/**
 * Returns error message from `error`.
 * May be helpful to handle caught errors.
 *
 * @param error Error object.
 *
 * @returns Message of `error`.
 */


const getErrorMessage = error => {
  return toErrorWithMessage(error).message;
};

const logger = {
  /**
   * Safe console.error version.
   */
  error: typeof console !== 'undefined' && console.error && console.error.bind ? console.error.bind(window.console) : console.error,

  /**
   * Safe console.info version.
   */
  info: typeof console !== 'undefined' && console.info && console.info.bind ? console.info.bind(window.console) : console.info
};

/**
 * Returns string without suffix.
 *
 * @param str Input string.
 * @param suffix Needed to remove.
 *
 * @returns String without suffix.
 */

const removeSuffix = (str, suffix) => {
  const index = str.indexOf(suffix, str.length - suffix.length);

  if (index >= 0) {
    return str.substring(0, index);
  }

  return str;
};
/**
 * Replaces all `pattern`s with `replacement` in `input` string.
 * String.replaceAll() polyfill because it is not supported by old browsers, e.g. Chrome 55.
 *
 * @see {@link https://caniuse.com/?search=String.replaceAll}
 *
 * @param input Input string to process.
 * @param pattern Find in the input string.
 * @param replacement Replace the pattern with.
 *
 * @returns Modified string.
 */

const replaceAll = (input, pattern, replacement) => {
  if (!input) {
    return input;
  }

  return input.split(pattern).join(replacement);
};
/**
 * Converts string pattern to regular expression.
 *
 * @param str String to convert.
 *
 * @returns Regular expression converted from pattern `str`.
 */

const toRegExp = str => {
  if (str.startsWith(SLASH) && str.endsWith(SLASH)) {
    return new RegExp(str.slice(1, -1));
  }

  const escaped = str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  return new RegExp(escaped);
};
/**
 * Converts any simple type value to string type,
 * e.g. `undefined` -> `'undefined'`.
 *
 * @param value Any type value.
 *
 * @returns String representation of `value`.
 */

const convertTypeIntoString = value => {
  let output;

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
 * Converts instance of string value into other simple types,
 * e.g. `'null'` -> `null`, `'true'` -> `true`.
 *
 * @param value String-type value.
 *
 * @returns Its own type representation of string-type `value`.
 */

const convertTypeFromString = value => {
  const numValue = Number(value);
  let output;

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

const SAFARI_USER_AGENT_REGEXP = /\sVersion\/(\d{2}\.\d)(.+\s|\s)(Safari)\//;
const isSafariBrowser = SAFARI_USER_AGENT_REGEXP.test(navigator.userAgent);
/**
 * Checks whether the browser userAgent is supported.
 *
 * @param userAgent User agent of browser.
 *
 * @returns False only for Internet Explorer.
 */

const isUserAgentSupported = userAgent => {
  // do not support Internet Explorer
  if (userAgent.includes('MSIE') || userAgent.includes('Trident/')) {
    return false;
  }

  return true;
};
/**
 * Checks whether the current browser is supported.
 *
 * @returns False for Internet Explorer, otherwise true.
 */

const isBrowserSupported = () => {
  return isUserAgentSupported(navigator.userAgent);
};

/**
 * CSS_PROPERTY is needed for style values normalization.
 *
 * IMPORTANT: it is used as 'const' instead of 'enum' to avoid side effects
 * during ExtendedCss import into other libraries.
 */

const CSS_PROPERTY = {
  BACKGROUND: 'background',
  BACKGROUND_IMAGE: 'background-image',
  CONTENT: 'content',
  OPACITY: 'opacity'
};
const REGEXP_ANY_SYMBOL = '.*';
const REGEXP_WITH_FLAGS_REGEXP = /^\s*\/.*\/[gmisuy]*\s*$/;

/**
 * Removes quotes for specified content value.
 *
 * For example, content style declaration with `::before` can be set as '-' (e.g. unordered list)
 * which displayed as simple dash `-` with no quotes.
 * But CSSStyleDeclaration.getPropertyValue('content') will return value
 * wrapped into quotes, e.g. '"-"', which should be removed
 * because filters maintainers does not use any quotes in real rules.
 *
 * @param str Input string.
 *
 * @returns String with no quotes for content value.
 */
const removeContentQuotes = str => {
  return str.replace(/^(["'])([\s\S]*)\1$/, '$2');
};
/**
 * Adds quotes for specified background url value.
 *
 * If background-image is specified **without** quotes:
 * e.g. 'background: url(data:image/gif;base64,R0lGODlhAQA7)'.
 *
 * CSSStyleDeclaration.getPropertyValue('background-image') may return value **with** quotes:
 * e.g. 'background: url("data:image/gif;base64,R0lGODlhAQA7")'.
 *
 * So we add quotes for compatibility since filters maintainers might use quotes in real rules.
 *
 * @param str Input string.
 *
 * @returns String with unified quotes for background url value.
 */


const addUrlPropertyQuotes = str => {
  if (!str.includes('url("')) {
    const re = /url\((.*?)\)/g;
    return str.replace(re, 'url("$1")');
  }

  return str;
};
/**
 * Adds quotes to url arg for consistent property value matching.
 */


const addUrlQuotesTo = {
  regexpArg: str => {
    // e.g. /^url\\([a-z]{4}:[a-z]{5}/
    // or /^url\\(data\\:\\image\\/gif;base64.+/
    const re = /(\^)?url(\\)?\\\((\w|\[\w)/g;
    return str.replace(re, '$1url$2\\(\\"?$3');
  },
  noneRegexpArg: addUrlPropertyQuotes
};
/**
 * Escapes regular expression string.
 *
 * @see {@link https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/regexp}
 *
 * @param str Input string.
 *
 * @returns Escaped regular expression string.
 */

const escapeRegExp = str => {
  // should be escaped . * + ? ^ $ { } ( ) | [ ] / \
  // except of * | ^
  const specials = ['.', '+', '?', '$', '{', '}', '(', ')', '[', ']', '\\', '/'];
  const specialsRegex = new RegExp(`[${specials.join('\\')}]`, 'g');
  return str.replace(specialsRegex, '\\$&');
};
/**
 * Converts :matches-css() arg property value match to regexp.
 *
 * @param rawValue Style match value pattern.
 *
 * @returns Arg of :matches-css() converted to regular expression.
 */


const convertStyleMatchValueToRegexp = rawValue => {
  let value;

  if (rawValue.startsWith(SLASH) && rawValue.endsWith(SLASH)) {
    // For regex patterns double quotes `"` and backslashes `\` should be escaped
    value = addUrlQuotesTo.regexpArg(rawValue);
    value = value.slice(1, -1);
  } else {
    // For non-regex patterns parentheses `(` `)` and square brackets `[` `]`
    // should be unescaped, because their escaping in filter rules is required
    value = addUrlQuotesTo.noneRegexpArg(rawValue);
    value = value.replace(/\\([\\()[\]"])/g, '$1');
    value = escapeRegExp(value); // e.g. div:matches-css(background-image: url(data:*))

    value = replaceAll(value, ASTERISK, REGEXP_ANY_SYMBOL);
  }

  return new RegExp(value, 'i');
};
/**
 * Makes some properties values compatible.
 *
 * @param propertyName Name of style property.
 * @param propertyValue Value of style property.
 *
 * @returns Normalized values for some CSS properties.
 */


const normalizePropertyValue = (propertyName, propertyValue) => {
  let normalized = '';

  switch (propertyName) {
    case CSS_PROPERTY.BACKGROUND:
    case CSS_PROPERTY.BACKGROUND_IMAGE:
      // sometimes url property does not have quotes
      // so we add them for consistent matching
      normalized = addUrlPropertyQuotes(propertyValue);
      break;

    case CSS_PROPERTY.CONTENT:
      normalized = removeContentQuotes(propertyValue);
      break;

    case CSS_PROPERTY.OPACITY:
      // https://bugs.webkit.org/show_bug.cgi?id=93445
      normalized = isSafariBrowser ? (Math.round(parseFloat(propertyValue) * 100) / 100).toString() : propertyValue;
      break;

    default:
      normalized = propertyValue;
  }

  return normalized;
};
/**
 * Returns domElement style property value
 * by css property name and standard pseudo-element.
 *
 * @param domElement DOM element.
 * @param propertyName CSS property name.
 * @param regularPseudoElement Standard pseudo-element — '::before', '::after' etc.
 *
 * @returns String containing the value of a specified CSS property.
 */


const getComputedStylePropertyValue = (domElement, propertyName, regularPseudoElement) => {
  const style = window.getComputedStyle(domElement, regularPseudoElement);
  const propertyValue = style.getPropertyValue(propertyName);
  return normalizePropertyValue(propertyName, propertyValue);
};

/**
 * Parses arg of absolute pseudo-class into 'name' and 'value' if set.
 *
 * Used for :matches-css() - with COLON as separator,
 * for :matches-attr() and :matches-property() - with EQUAL_SIGN as separator.
 *
 * @param pseudoArg Arg of pseudo-class.
 * @param separator Divider symbol.
 *
 * @returns Parsed 'matches' pseudo-class arg data.
 */
const getPseudoArgData = (pseudoArg, separator) => {
  const index = pseudoArg.indexOf(separator);
  let name;
  let value;

  if (index > -1) {
    name = pseudoArg.substring(0, index).trim();
    value = pseudoArg.substring(index + 1).trim();
  } else {
    name = pseudoArg;
  }

  return {
    name,
    value
  };
};

/**
 * Parses :matches-css() pseudo-class arg
 * where regular pseudo-element can be a part of arg
 * e.g. 'div:matches-css(before, color: rgb(255, 255, 255))'    <-- obsolete `:matches-css-before()`.
 *
 * @param pseudoName Pseudo-class name.
 * @param rawArg Pseudo-class arg.
 *
 * @returns Parsed :matches-css() pseudo-class arg data.
 * @throws An error on invalid `rawArg`.
 */
const parseStyleMatchArg = (pseudoName, rawArg) => {
  const {
    name,
    value
  } = getPseudoArgData(rawArg, COMMA);
  let regularPseudoElement = name;
  let styleMatchArg = value; // check whether the string part before the separator is valid regular pseudo-element,
  // otherwise `regularPseudoElement` is null, and `styleMatchArg` is rawArg

  if (!Object.values(REGULAR_PSEUDO_ELEMENTS).includes(name)) {
    regularPseudoElement = null;
    styleMatchArg = rawArg;
  }

  if (!styleMatchArg) {
    throw new Error(`Required style property argument part is missing in :${pseudoName}() arg: '${rawArg}'`);
  } // if regularPseudoElement is not `null`


  if (regularPseudoElement) {
    // pseudo-element should have two colon marks for Window.getComputedStyle() due to the syntax:
    // https://www.w3.org/TR/selectors-4/#pseudo-element-syntax
    // ':matches-css(before, content: ads)' ->> '::before'
    regularPseudoElement = `${COLON}${COLON}${regularPseudoElement}`;
  }

  return {
    regularPseudoElement,
    styleMatchArg
  };
};
/**
 * Checks whether the domElement is matched by :matches-css() arg.
 *
 * @param argsData Pseudo-class name, arg, and dom element to check.
 *
 @returns True if DOM element is matched.
 * @throws An error on invalid pseudo-class arg.
 */


const isStyleMatched = argsData => {
  const {
    pseudoName,
    pseudoArg,
    domElement
  } = argsData;
  const {
    regularPseudoElement,
    styleMatchArg
  } = parseStyleMatchArg(pseudoName, pseudoArg);
  const {
    name: matchName,
    value: matchValue
  } = getPseudoArgData(styleMatchArg, COLON);

  if (!matchName || !matchValue) {
    throw new Error(`Required property name or value is missing in :${pseudoName}() arg: '${styleMatchArg}'`);
  }

  let valueRegexp;

  try {
    valueRegexp = convertStyleMatchValueToRegexp(matchValue);
  } catch (e) {
    logger.error(getErrorMessage(e));
    throw new Error(`Invalid argument of :${pseudoName}() pseudo-class: '${styleMatchArg}'`);
  }

  const value = getComputedStylePropertyValue(domElement, matchName, regularPseudoElement);
  return valueRegexp && valueRegexp.test(value);
};
/**
 * Validates string arg for :matches-attr() and :matches-property().
 *
 * @param arg Pseudo-class arg.
 *
 * @returns True if 'matches' pseudo-class string arg is valid.
 */

const validateStrMatcherArg = arg => {
  if (arg.includes(SLASH)) {
    return false;
  }

  if (!/^[\w-]+$/.test(arg)) {
    return false;
  }

  return true;
};
/**
 * Returns valid arg for :matches-attr() and :matcher-property().
 *
 * @param rawArg Arg pattern.
 * @param [isWildcardAllowed=false] Flag for wildcard (`*`) using as pseudo-class arg.
 *
 * @returns Valid arg for :matches-attr() and :matcher-property().
 * @throws An error on invalid `rawArg`.
 */


const getValidMatcherArg = function (rawArg) {
  let isWildcardAllowed = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : false;
  // if rawArg is missing for pseudo-class
  // e.g. :matches-attr()
  // error will be thrown before getValidMatcherArg() is called:
  // name or arg is missing in AbsolutePseudoClass
  let arg;

  if (rawArg.length > 1 && rawArg.startsWith(DOUBLE_QUOTE) && rawArg.endsWith(DOUBLE_QUOTE)) {
    rawArg = rawArg.slice(1, -1);
  }

  if (rawArg === '') {
    // e.g. :matches-property("")
    throw new Error('Argument should be specified. Empty arg is invalid.');
  }

  if (rawArg.startsWith(SLASH) && rawArg.endsWith(SLASH)) {
    // e.g. :matches-property("//")
    if (rawArg.length > 2) {
      arg = toRegExp(rawArg);
    } else {
      throw new Error(`Invalid regexp: '${rawArg}'`);
    }
  } else if (rawArg.includes(ASTERISK)) {
    if (rawArg === ASTERISK && !isWildcardAllowed) {
      // e.g. :matches-attr(*)
      throw new Error(`Argument should be more specific than ${rawArg}`);
    }

    arg = replaceAll(rawArg, ASTERISK, REGEXP_ANY_SYMBOL);
    arg = new RegExp(arg);
  } else {
    if (!validateStrMatcherArg(rawArg)) {
      throw new Error(`Invalid argument: '${rawArg}'`);
    }

    arg = rawArg;
  }

  return arg;
};

/**
 * Parses pseudo-class argument and returns parsed data.
 *
 * @param pseudoName Extended pseudo-class name.
 * @param pseudoArg Extended pseudo-class argument.
 *
 * @returns Parsed pseudo-class argument data.
 * @throws An error if attribute name is missing in pseudo-class arg.
 */
const getRawMatchingData = (pseudoName, pseudoArg) => {
  const {
    name: rawName,
    value: rawValue
  } = getPseudoArgData(pseudoArg, EQUAL_SIGN);

  if (!rawName) {
    throw new Error(`Required attribute name is missing in :${pseudoName} arg: ${pseudoArg}`);
  }

  return {
    rawName,
    rawValue
  };
};
/**
 * Checks whether the domElement is matched by :matches-attr() arg.
 *
 * @param argsData Pseudo-class name, arg, and dom element to check.
 *
 @returns True if DOM element is matched.
 * @throws An error on invalid arg of pseudo-class.
 */

const isAttributeMatched = argsData => {
  const {
    pseudoName,
    pseudoArg,
    domElement
  } = argsData;
  const elementAttributes = domElement.attributes; // no match if dom element has no attributes

  if (elementAttributes.length === 0) {
    return false;
  }

  const {
    rawName: rawAttrName,
    rawValue: rawAttrValue
  } = getRawMatchingData(pseudoName, pseudoArg);
  let attrNameMatch;

  try {
    attrNameMatch = getValidMatcherArg(rawAttrName);
  } catch (e) {
    const errorMessage = getErrorMessage(e);
    logger.error(errorMessage);
    throw new SyntaxError(errorMessage);
  }

  let isMatched = false;
  let i = 0;

  while (i < elementAttributes.length && !isMatched) {
    const attr = elementAttributes[i];

    if (!attr) {
      break;
    }

    const isNameMatched = attrNameMatch instanceof RegExp ? attrNameMatch.test(attr.name) : attrNameMatch === attr.name;

    if (!rawAttrValue) {
      // for rules with no attribute value specified
      // e.g. :matches-attr("/regex/") or :matches-attr("attr-name")
      isMatched = isNameMatched;
    } else {
      let attrValueMatch;

      try {
        attrValueMatch = getValidMatcherArg(rawAttrValue);
      } catch (e) {
        const errorMessage = getErrorMessage(e);
        logger.error(errorMessage);
        throw new SyntaxError(errorMessage);
      }

      const isValueMatched = attrValueMatch instanceof RegExp ? attrValueMatch.test(attr.value) : attrValueMatch === attr.value;
      isMatched = isNameMatched && isValueMatched;
    }

    i += 1;
  }

  return isMatched;
};
/**
 * Parses raw :matches-property() arg which may be chain of properties.
 *
 * @param input Argument of :matches-property().
 *
 * @returns Arg of :matches-property() as array of strings or regular expressions.
 * @throws An error on invalid chain.
 */

const parseRawPropChain = input => {
  if (input.length > 1 && input.startsWith(DOUBLE_QUOTE) && input.endsWith(DOUBLE_QUOTE)) {
    input = input.slice(1, -1);
  }

  const chainChunks = input.split(DOT);
  const chainPatterns = [];
  let patternBuffer = '';
  let isRegexpPattern = false;
  let i = 0;

  while (i < chainChunks.length) {
    const chunk = getItemByIndex(chainChunks, i, `Invalid pseudo-class arg: '${input}'`);

    if (chunk.startsWith(SLASH) && chunk.endsWith(SLASH) && chunk.length > 2) {
      // regexp pattern with no dot in it, e.g. /propName/
      chainPatterns.push(chunk);
    } else if (chunk.startsWith(SLASH)) {
      // if chunk is a start of regexp pattern
      isRegexpPattern = true;
      patternBuffer += chunk;
    } else if (chunk.endsWith(SLASH)) {
      isRegexpPattern = false; // restore dot removed while splitting
      // e.g. testProp./.{1,5}/

      patternBuffer += `.${chunk}`;
      chainPatterns.push(patternBuffer);
      patternBuffer = '';
    } else {
      // if there are few dots in regexp pattern
      // so chunk might be in the middle of it
      if (isRegexpPattern) {
        patternBuffer += chunk;
      } else {
        // otherwise it is string pattern
        chainPatterns.push(chunk);
      }
    }

    i += 1;
  }

  if (patternBuffer.length > 0) {
    throw new Error(`Invalid regexp property pattern '${input}'`);
  }

  const chainMatchPatterns = chainPatterns.map(pattern => {
    if (pattern.length === 0) {
      // e.g. '.prop.id' or 'nested..test'
      throw new Error(`Empty pattern '${pattern}' is invalid in chain '${input}'`);
    }

    let validPattern;

    try {
      validPattern = getValidMatcherArg(pattern, true);
    } catch (e) {
      logger.error(getErrorMessage(e));
      throw new Error(`Invalid property pattern '${pattern}' in property chain '${input}'`);
    }

    return validPattern;
  });
  return chainMatchPatterns;
};

/**
 * Checks if the property exists in the base object (recursively).
 *
 * @param base Element to check.
 * @param chain Array of objects - parsed string property chain.
 * @param [output=[]] Result acc.
 *
 * @returns Array of parsed data — representation of `base`-related `chain`.
 */
const filterRootsByRegexpChain = function (base, chain) {
  let output = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : [];
  const tempProp = getFirst(chain);

  if (chain.length === 1) {
    let key;

    for (key in base) {
      if (tempProp instanceof RegExp) {
        if (tempProp.test(key)) {
          output.push({
            base,
            prop: key,
            value: base[key]
          });
        }
      } else if (tempProp === key) {
        output.push({
          base,
          prop: tempProp,
          value: base[key]
        });
      }
    }

    return output;
  } // if there is a regexp prop in input chain
  // e.g. 'unit./^ad.+/.src' for 'unit.ad-1gf2.src unit.ad-fgd34.src'),
  // every base keys should be tested by regexp and it can be more that one results


  if (tempProp instanceof RegExp) {
    const nextProp = chain.slice(1);
    const baseKeys = [];

    for (const key in base) {
      if (tempProp.test(key)) {
        baseKeys.push(key);
      }
    }

    baseKeys.forEach(key => {
      var _Object$getOwnPropert;

      const item = (_Object$getOwnPropert = Object.getOwnPropertyDescriptor(base, key)) === null || _Object$getOwnPropert === void 0 ? void 0 : _Object$getOwnPropert.value;
      filterRootsByRegexpChain(item, nextProp, output);
    });
  }

  if (base && typeof tempProp === 'string') {
    var _Object$getOwnPropert2;

    const nextBase = (_Object$getOwnPropert2 = Object.getOwnPropertyDescriptor(base, tempProp)) === null || _Object$getOwnPropert2 === void 0 ? void 0 : _Object$getOwnPropert2.value;
    chain = chain.slice(1);

    if (nextBase !== undefined) {
      filterRootsByRegexpChain(nextBase, chain, output);
    }
  }

  return output;
};
/**
 * Checks whether the domElement is matched by :matches-property() arg.
 *
 * @param argsData Pseudo-class name, arg, and dom element to check.
 *
 @returns True if DOM element is matched.
 * @throws An error on invalid prop in chain.
 */


const isPropertyMatched = argsData => {
  const {
    pseudoName,
    pseudoArg,
    domElement
  } = argsData;
  const {
    rawName: rawPropertyName,
    rawValue: rawPropertyValue
  } = getRawMatchingData(pseudoName, pseudoArg); // chained property name cannot include '/' or '.'
  // so regex prop names with such escaped characters are invalid

  if (rawPropertyName.includes('\\/') || rawPropertyName.includes('\\.')) {
    throw new Error(`Invalid :${pseudoName} name pattern: ${rawPropertyName}`);
  }

  let propChainMatches;

  try {
    propChainMatches = parseRawPropChain(rawPropertyName);
  } catch (e) {
    const errorMessage = getErrorMessage(e);
    logger.error(errorMessage);
    throw new SyntaxError(errorMessage);
  }

  const ownerObjArr = filterRootsByRegexpChain(domElement, propChainMatches);

  if (ownerObjArr.length === 0) {
    return false;
  }

  let isMatched = true;

  if (rawPropertyValue) {
    let propValueMatch;

    try {
      propValueMatch = getValidMatcherArg(rawPropertyValue);
    } catch (e) {
      const errorMessage = getErrorMessage(e);
      logger.error(errorMessage);
      throw new SyntaxError(errorMessage);
    }

    if (propValueMatch) {
      for (let i = 0; i < ownerObjArr.length; i += 1) {
        var _ownerObjArr$i;

        const realValue = (_ownerObjArr$i = ownerObjArr[i]) === null || _ownerObjArr$i === void 0 ? void 0 : _ownerObjArr$i.value;

        if (propValueMatch instanceof RegExp) {
          isMatched = propValueMatch.test(convertTypeIntoString(realValue));
        } else {
          // handle 'null' and 'undefined' property values set as string
          if (realValue === 'null' || realValue === 'undefined') {
            isMatched = propValueMatch === realValue;
            break;
          }

          isMatched = convertTypeFromString(propValueMatch) === realValue;
        }

        if (isMatched) {
          break;
        }
      }
    }
  }

  return isMatched;
};
/**
 * Checks whether the textContent is matched by :contains arg.
 *
 * @param argsData Pseudo-class name, arg, and dom element to check.
 *
 @returns True if DOM element is matched.
 * @throws An error on invalid arg of pseudo-class.
 */

const isTextMatched = argsData => {
  const {
    pseudoName,
    pseudoArg,
    domElement
  } = argsData;
  const textContent = getNodeTextContent(domElement);
  let isTextContentMatched;
  let pseudoArgToMatch = pseudoArg;

  if (pseudoArgToMatch.startsWith(SLASH) && REGEXP_WITH_FLAGS_REGEXP.test(pseudoArgToMatch)) {
    // regexp arg
    const flagsIndex = pseudoArgToMatch.lastIndexOf('/');
    const flagsStr = pseudoArgToMatch.substring(flagsIndex + 1);
    pseudoArgToMatch = pseudoArgToMatch.substring(0, flagsIndex + 1).slice(1, -1).replace(/\\([\\"])/g, '$1');
    let regex;

    try {
      regex = new RegExp(pseudoArgToMatch, flagsStr);
    } catch (e) {
      throw new Error(`Invalid argument of :${pseudoName}() pseudo-class: ${pseudoArg}`);
    }

    isTextContentMatched = regex.test(textContent);
  } else {
    // none-regexp arg
    pseudoArgToMatch = pseudoArgToMatch.replace(/\\([\\()[\]"])/g, '$1');
    isTextContentMatched = textContent.includes(pseudoArgToMatch);
  }

  return isTextContentMatched;
};

/**
 * Validates number arg for :nth-ancestor() and :upward() pseudo-classes.
 *
 * @param rawArg Raw arg of pseudo-class.
 * @param pseudoName Pseudo-class name.
 *
 * @returns Valid number arg for :nth-ancestor() and :upward().
 * @throws An error on invalid `rawArg`.
 */
const getValidNumberAncestorArg = (rawArg, pseudoName) => {
  const deep = Number(rawArg);

  if (Number.isNaN(deep) || deep < 1 || deep >= 256) {
    throw new Error(`Invalid argument of :${pseudoName} pseudo-class: '${rawArg}'`);
  }

  return deep;
};
/**
 * Returns nth ancestor by 'deep' number arg OR undefined if ancestor range limit exceeded.
 *
 * @param domElement DOM element to find ancestor for.
 * @param nth Depth up to needed ancestor.
 * @param pseudoName Pseudo-class name.
 *
 * @returns Ancestor element found in DOM, or null if not found.
 * @throws An error on invalid `nth` arg.
 */

const getNthAncestor = (domElement, nth, pseudoName) => {
  let ancestor = null;
  let i = 0;

  while (i < nth) {
    ancestor = domElement.parentElement;

    if (!ancestor) {
      throw new Error(`Out of DOM: Argument of :${pseudoName}() pseudo-class is too big — '${nth}'.`);
    }

    domElement = ancestor;
    i += 1;
  }

  return ancestor;
};
/**
 * Validates standard CSS selector.
 *
 * @param selector Standard selector.
 *
 * @returns True if standard CSS selector is valid.
 */

const validateStandardSelector = selector => {
  let isValid;

  try {
    document.querySelectorAll(selector);
    isValid = true;
  } catch (e) {
    isValid = false;
  }

  return isValid;
};

/**
 * Wrapper to run matcher `callback` with `args`
 * and throw error with `errorMessage` if `callback` run fails.
 *
 * @param callback Matcher callback.
 * @param argsData Args needed for matcher callback.
 * @param errorMessage Error message.
 *
 * @returns True if `callback` returns true.
 * @throws An error if `callback` fails.
 */
const matcherWrapper = (callback, argsData, errorMessage) => {
  let isMatched;

  try {
    isMatched = callback(argsData);
  } catch (e) {
    logger.error(getErrorMessage(e));
    throw new Error(errorMessage);
  }

  return isMatched;
};
/**
 * Generates common error message to throw while matching element `propDesc`.
 *
 * @param propDesc Text to describe what element 'prop' pseudo-class is trying to match.
 * @param pseudoName Pseudo-class name.
 * @param pseudoArg Pseudo-class arg.
 *
 * @returns Generated error message string.
 */


const getAbsolutePseudoError = (propDesc, pseudoName, pseudoArg) => {
  // eslint-disable-next-line max-len
  return `${MATCHING_ELEMENT_ERROR_PREFIX} ${propDesc}, may be invalid :${pseudoName}() pseudo-class arg: '${pseudoArg}'`;
};
/**
 * Checks whether the domElement is matched by absolute extended pseudo-class argument.
 *
 * @param domElement Page element.
 * @param pseudoName Pseudo-class name.
 * @param pseudoArg Pseudo-class arg.
 *
 * @returns True if `domElement` is matched by absolute pseudo-class.
 * @throws An error on unknown absolute pseudo-class.
 */


const isMatchedByAbsolutePseudo = (domElement, pseudoName, pseudoArg) => {
  let argsData;
  let errorMessage;
  let callback;

  switch (pseudoName) {
    case CONTAINS_PSEUDO:
    case HAS_TEXT_PSEUDO:
    case ABP_CONTAINS_PSEUDO:
      callback = isTextMatched;
      argsData = {
        pseudoName,
        pseudoArg,
        domElement
      };
      errorMessage = getAbsolutePseudoError('text content', pseudoName, pseudoArg);
      break;

    case MATCHES_CSS_PSEUDO:
    case MATCHES_CSS_AFTER_PSEUDO:
    case MATCHES_CSS_BEFORE_PSEUDO:
      callback = isStyleMatched;
      argsData = {
        pseudoName,
        pseudoArg,
        domElement
      };
      errorMessage = getAbsolutePseudoError('style', pseudoName, pseudoArg);
      break;

    case MATCHES_ATTR_PSEUDO_CLASS_MARKER:
      callback = isAttributeMatched;
      argsData = {
        domElement,
        pseudoName,
        pseudoArg
      };
      errorMessage = getAbsolutePseudoError('attributes', pseudoName, pseudoArg);
      break;

    case MATCHES_PROPERTY_PSEUDO_CLASS_MARKER:
      callback = isPropertyMatched;
      argsData = {
        domElement,
        pseudoName,
        pseudoArg
      };
      errorMessage = getAbsolutePseudoError('properties', pseudoName, pseudoArg);
      break;

    default:
      throw new Error(`Unknown absolute pseudo-class :${pseudoName}()`);
  }

  return matcherWrapper(callback, argsData, errorMessage);
};
const findByAbsolutePseudoPseudo = {
  /**
   * Returns list of nth ancestors relative to every dom node from domElements list.
   *
   * @param domElements DOM elements.
   * @param rawPseudoArg Number arg of :nth-ancestor() or :upward() pseudo-class.
   * @param pseudoName Pseudo-class name.
   *
   * @returns Array of ancestor DOM elements.
   */
  nthAncestor: (domElements, rawPseudoArg, pseudoName) => {
    const deep = getValidNumberAncestorArg(rawPseudoArg, pseudoName);
    const ancestors = domElements.map(domElement => {
      let ancestor = null;

      try {
        ancestor = getNthAncestor(domElement, deep, pseudoName);
      } catch (e) {
        logger.error(getErrorMessage(e));
      }

      return ancestor;
    }).filter(isHtmlElement);
    return ancestors;
  },

  /**
   * Returns list of elements by xpath expression, evaluated on every dom node from domElements list.
   *
   * @param domElements DOM elements.
   * @param rawPseudoArg Arg of :xpath() pseudo-class.
   *
   * @returns Array of DOM elements matched by xpath expression.
   */
  xpath: (domElements, rawPseudoArg) => {
    const foundElements = domElements.map(domElement => {
      const result = [];
      let xpathResult;

      try {
        xpathResult = document.evaluate(rawPseudoArg, domElement, null, window.XPathResult.UNORDERED_NODE_ITERATOR_TYPE, null);
      } catch (e) {
        logger.error(getErrorMessage(e));
        throw new Error(`Invalid argument of :xpath() pseudo-class: '${rawPseudoArg}'`);
      }

      let node = xpathResult.iterateNext();

      while (node) {
        if (isHtmlElement(node)) {
          result.push(node);
        }

        node = xpathResult.iterateNext();
      }

      return result;
    });
    return flatten(foundElements);
  },

  /**
   * Returns list of closest ancestors relative to every dom node from domElements list.
   *
   * @param domElements DOM elements.
   * @param rawPseudoArg Standard selector arg of :upward() pseudo-class.
   *
   * @returns Array of closest ancestor DOM elements.
   * @throws An error if `rawPseudoArg` is not a valid standard selector.
   */
  upward: (domElements, rawPseudoArg) => {
    if (!validateStandardSelector(rawPseudoArg)) {
      throw new Error(`Invalid argument of :upward pseudo-class: '${rawPseudoArg}'`);
    }

    const closestAncestors = domElements.map(domElement => {
      // closest to parent element should be found
      // otherwise `.base:upward(.base)` will return itself too, not only ancestor
      const parent = domElement.parentElement;

      if (!parent) {
        return null;
      }

      return parent.closest(rawPseudoArg);
    }).filter(isHtmlElement);
    return closestAncestors;
  }
};

/**
 * Calculated selector text which is needed to :has(), :is() and :not() pseudo-classes.
 * Contains calculated part (depends on the processed element)
 * and value of RegularSelector which is next to selector by.
 *
 * Native Document.querySelectorAll() does not select exact descendant elements
 * but match all page elements satisfying the selector,
 * so extra specification is needed for proper descendants selection
 * e.g. 'div:has(> img)'.
 *
 * Its calculation depends on extended selector.
 */

/**
 * Combined `:scope` pseudo-class and **child** combinator — `:scope>`.
 */
const scopeDirectChildren = `${SCOPE_CSS_PSEUDO_CLASS}${CHILD_COMBINATOR}`;
/**
 * Combined `:scope` pseudo-class and **descendant** combinator — `:scope `.
 */

const scopeAnyChildren = `${SCOPE_CSS_PSEUDO_CLASS}${DESCENDANT_COMBINATOR}`;
/**
 * Type for relative pseudo-class helpers args.
 */

/**
 * Returns the first of RegularSelector child node for `selectorNode`.
 *
 * @param selectorNode Ast Selector node.
 * @param pseudoName Name of relative pseudo-class.
 *
 * @returns Ast RegularSelector node.
 */
const getFirstInnerRegularChild = (selectorNode, pseudoName) => {
  return getFirstRegularChild(selectorNode.children, `RegularSelector is missing for :${pseudoName}() pseudo-class`);
}; // TODO: fix for <forgiving-relative-selector-list>
// https://github.com/AdguardTeam/ExtendedCss/issues/154

/**
 * Checks whether the element has all relative elements specified by pseudo-class arg.
 * Used for :has() pseudo-class.
 *
 * @param argsData Relative pseudo-class helpers args data.
 *
 * @returns True if **all selectors** from argsData.relativeSelectorList is **matched** for argsData.element.
 */


const hasRelativesBySelectorList = argsData => {
  const {
    element,
    relativeSelectorList,
    pseudoName
  } = argsData;
  return relativeSelectorList.children // Array.every() is used here as each Selector node from SelectorList should exist on page
  .every(selectorNode => {
    // selectorList.children always starts with regular selector as any selector generally
    const relativeRegularSelector = getFirstInnerRegularChild(selectorNode, pseudoName);
    let specifiedSelector = '';
    let rootElement = null;
    const regularSelector = getNodeValue(relativeRegularSelector);

    if (regularSelector.startsWith(NEXT_SIBLING_COMBINATOR) || regularSelector.startsWith(SUBSEQUENT_SIBLING_COMBINATOR)) {
      /**
       * For matching the element by "element:has(+ next-sibling)" and "element:has(~ sibling)"
       * we check whether the element's parentElement has specific direct child combination,
       * e.g. 'h1:has(+ .share)' -> `h1Node.parentElement.querySelectorAll(':scope > h1 + .share')`.
       *
       * @see {@link https://www.w3.org/TR/selectors-4/#relational}
       */
      rootElement = element.parentElement;
      const elementSelectorText = getElementSelectorDesc(element);
      specifiedSelector = `${scopeDirectChildren}${elementSelectorText}${regularSelector}`;
    } else if (regularSelector === ASTERISK) {
      /**
       * :scope specification is needed for proper descendants selection
       * as native element.querySelectorAll() does not select exact element descendants
       * e.g. 'a:has(> img)' -> `aNode.querySelectorAll(':scope > img')`.
       *
       * For 'any selector' as arg of relative simplicity should be set for all inner elements
       * e.g. 'div:has(*)' -> `divNode.querySelectorAll(':scope *')`
       * which means empty div with no child element.
       */
      rootElement = element;
      specifiedSelector = `${scopeAnyChildren}${ASTERISK}`;
    } else {
      /**
       * As it described above, inner elements should be found using `:scope` pseudo-class
       * e.g. 'a:has(> img)' -> `aNode.querySelectorAll(':scope > img')`
       * OR '.block(div > span)' -> `blockClassNode.querySelectorAll(':scope div > span')`.
       */
      specifiedSelector = `${scopeAnyChildren}${regularSelector}`;
      rootElement = element;
    }

    if (!rootElement) {
      throw new Error(`Selection by :${pseudoName}() pseudo-class is not possible`);
    }

    let relativeElements;

    try {
      // eslint-disable-next-line @typescript-eslint/no-use-before-define
      relativeElements = getElementsForSelectorNode(selectorNode, rootElement, specifiedSelector);
    } catch (e) {
      logger.error(getErrorMessage(e)); // fail for invalid selector

      throw new Error(`Invalid selector for :${pseudoName}() pseudo-class: '${regularSelector}'`);
    }

    return relativeElements.length > 0;
  });
};
/**
 * Checks whether the element is an any element specified by pseudo-class arg.
 * Used for :is() pseudo-class.
 *
 * @param argsData Relative pseudo-class helpers args data.
 *
 * @returns True if **any selector** from argsData.relativeSelectorList is **matched** for argsData.element.
 */


const isAnyElementBySelectorList = argsData => {
  const {
    element,
    relativeSelectorList,
    pseudoName
  } = argsData;
  return relativeSelectorList.children // Array.some() is used here as any selector from selector list should exist on page
  .some(selectorNode => {
    // selectorList.children always starts with regular selector
    const relativeRegularSelector = getFirstInnerRegularChild(selectorNode, pseudoName);
    /**
     * For checking the element by 'div:is(.banner)'
     * we check whether the element's parentElement has any specific direct child.
     */

    const rootElement = getParent(element, `Selection by :${pseudoName}() pseudo-class is not possible`);
    /**
     * So we calculate the element "description" by it's tagname and attributes for targeting
     * and use it to specify the selection
     * e.g. `div:is(.banner)` --> `divNode.parentElement.querySelectorAll(':scope > .banner')`.
     */

    const specifiedSelector = `${scopeDirectChildren}${getNodeValue(relativeRegularSelector)}`;
    let anyElements;

    try {
      // eslint-disable-next-line @typescript-eslint/no-use-before-define
      anyElements = getElementsForSelectorNode(selectorNode, rootElement, specifiedSelector);
    } catch (e) {
      // do not fail on invalid selectors for :is()
      return false;
    } // TODO: figure out how to handle complex selectors with extended pseudo-classes
    // (check readme - extended-css-is-limitations)
    // because `element` and `anyElements` may be from different DOM levels


    return anyElements.includes(element);
  });
};
/**
 * Checks whether the element is not an element specified by pseudo-class arg.
 * Used for :not() pseudo-class.
 *
 * @param argsData Relative pseudo-class helpers args data.
 *
 * @returns True if **any selector** from argsData.relativeSelectorList is **not matched** for argsData.element.
 */


const notElementBySelectorList = argsData => {
  const {
    element,
    relativeSelectorList,
    pseudoName
  } = argsData;
  return relativeSelectorList.children // Array.every() is used here as element should not be selected by any selector from selector list
  .every(selectorNode => {
    // selectorList.children always starts with regular selector
    const relativeRegularSelector = getFirstInnerRegularChild(selectorNode, pseudoName);
    /**
     * For checking the element by 'div:not([data="content"])
     * we check whether the element's parentElement has any specific direct child.
     */

    const rootElement = getParent(element, `Selection by :${pseudoName}() pseudo-class is not possible`);
    /**
     * So we calculate the element "description" by it's tagname and attributes for targeting
     * and use it to specify the selection
     * e.g. `div:not(.banner)` --> `divNode.parentElement.querySelectorAll(':scope > .banner')`.
     */

    const specifiedSelector = `${scopeDirectChildren}${getNodeValue(relativeRegularSelector)}`;
    let anyElements;

    try {
      // eslint-disable-next-line @typescript-eslint/no-use-before-define
      anyElements = getElementsForSelectorNode(selectorNode, rootElement, specifiedSelector);
    } catch (e) {
      // fail on invalid selectors for :not()
      logger.error(getErrorMessage(e)); // eslint-disable-next-line max-len

      throw new Error(`Invalid selector for :${pseudoName}() pseudo-class: '${getNodeValue(relativeRegularSelector)}'`);
    } // TODO: figure out how to handle up-looking pseudo-classes inside :not()
    // (check readme - extended-css-not-limitations)
    // because `element` and `anyElements` may be from different DOM levels


    return !anyElements.includes(element);
  });
};
/**
 * Selects dom elements by value of RegularSelector.
 *
 * @param regularSelectorNode RegularSelector node.
 * @param root Root DOM element.
 * @param specifiedSelector @see {@link SpecifiedSelector}.
 *
 * @returns Array of DOM elements.
 * @throws An error if RegularSelector node value is an invalid selector.
 */


const getByRegularSelector = (regularSelectorNode, root, specifiedSelector) => {
  const selectorText = specifiedSelector ? specifiedSelector : getNodeValue(regularSelectorNode);
  let selectedElements = [];

  try {
    selectedElements = Array.from(root.querySelectorAll(selectorText));
  } catch (e) {
    throw new Error(`Error: unable to select by '${selectorText}' — ${getErrorMessage(e)}`);
  }

  return selectedElements;
};
/**
 * Returns list of dom elements filtered or selected by ExtendedSelector node.
 *
 * @param domElements Array of DOM elements.
 * @param extendedSelectorNode ExtendedSelector node.
 *
 * @returns Array of DOM elements.
 * @throws An error on unknown pseudo-class,
 * absent or invalid arg of extended pseudo-class, etc.
 */

const getByExtendedSelector = (domElements, extendedSelectorNode) => {
  let foundElements = [];
  const extendedPseudoClassNode = getPseudoClassNode(extendedSelectorNode);
  const pseudoName = getNodeName(extendedPseudoClassNode);

  if (isAbsolutePseudoClass(pseudoName)) {
    // absolute extended pseudo-classes should have an argument
    const absolutePseudoArg = getNodeValue(extendedPseudoClassNode, `Missing arg for :${pseudoName}() pseudo-class`);

    if (pseudoName === NTH_ANCESTOR_PSEUDO_CLASS_MARKER) {
      // :nth-ancestor()
      foundElements = findByAbsolutePseudoPseudo.nthAncestor(domElements, absolutePseudoArg, pseudoName);
    } else if (pseudoName === XPATH_PSEUDO_CLASS_MARKER) {
      // :xpath()
      try {
        document.createExpression(absolutePseudoArg, null);
      } catch (e) {
        throw new Error(`Invalid argument of :${pseudoName}() pseudo-class: '${absolutePseudoArg}'`);
      }

      foundElements = findByAbsolutePseudoPseudo.xpath(domElements, absolutePseudoArg);
    } else if (pseudoName === UPWARD_PSEUDO_CLASS_MARKER) {
      // :upward()
      if (Number.isNaN(Number(absolutePseudoArg))) {
        // so arg is selector, not a number
        foundElements = findByAbsolutePseudoPseudo.upward(domElements, absolutePseudoArg);
      } else {
        foundElements = findByAbsolutePseudoPseudo.nthAncestor(domElements, absolutePseudoArg, pseudoName);
      }
    } else {
      // all other absolute extended pseudo-classes
      // e.g. contains, matches-attr, etc.
      foundElements = domElements.filter(element => {
        return isMatchedByAbsolutePseudo(element, pseudoName, absolutePseudoArg);
      });
    }
  } else if (isRelativePseudoClass(pseudoName)) {
    const relativeSelectorList = getRelativeSelectorListNode(extendedPseudoClassNode);
    let relativePredicate;

    switch (pseudoName) {
      case HAS_PSEUDO_CLASS_MARKER:
      case ABP_HAS_PSEUDO_CLASS_MARKER:
        relativePredicate = element => hasRelativesBySelectorList({
          element,
          relativeSelectorList,
          pseudoName
        });

        break;

      case IS_PSEUDO_CLASS_MARKER:
        relativePredicate = element => isAnyElementBySelectorList({
          element,
          relativeSelectorList,
          pseudoName
        });

        break;

      case NOT_PSEUDO_CLASS_MARKER:
        relativePredicate = element => notElementBySelectorList({
          element,
          relativeSelectorList,
          pseudoName
        });

        break;

      default:
        throw new Error(`Unknown relative pseudo-class: '${pseudoName}'`);
    }

    foundElements = domElements.filter(relativePredicate);
  } else {
    // extra check is parser missed something
    throw new Error(`Unknown extended pseudo-class: '${pseudoName}'`);
  }

  return foundElements;
};
/**
 * Returns list of dom elements which is selected by RegularSelector value.
 *
 * @param domElements Array of DOM elements.
 * @param regularSelectorNode RegularSelector node.
 *
 * @returns Array of DOM elements.
 * @throws An error if RegularSelector has not value.
 */

const getByFollowingRegularSelector = (domElements, regularSelectorNode) => {
  // array of arrays because of Array.map() later
  let foundElements = [];
  const value = getNodeValue(regularSelectorNode);

  if (value.startsWith(CHILD_COMBINATOR)) {
    // e.g. div:has(> img) > .banner
    foundElements = domElements.map(root => {
      const specifiedSelector = `${SCOPE_CSS_PSEUDO_CLASS}${value}`;
      return getByRegularSelector(regularSelectorNode, root, specifiedSelector);
    });
  } else if (value.startsWith(NEXT_SIBLING_COMBINATOR) || value.startsWith(SUBSEQUENT_SIBLING_COMBINATOR)) {
    // e.g. div:has(> img) + .banner
    // or   div:has(> img) ~ .banner
    foundElements = domElements.map(element => {
      const rootElement = element.parentElement;

      if (!rootElement) {
        // do not throw error if there in no parent for element
        // e.g. '*:contains(text)' selects `html` which has no parentElement
        return [];
      }

      const elementSelectorText = getElementSelectorDesc(element);
      const specifiedSelector = `${scopeDirectChildren}${elementSelectorText}${value}`;
      const selected = getByRegularSelector(regularSelectorNode, rootElement, specifiedSelector);
      return selected;
    });
  } else {
    // space-separated regular selector after extended one
    // e.g. div:has(> img) .banner
    foundElements = domElements.map(root => {
      const specifiedSelector = `${scopeAnyChildren}${getNodeValue(regularSelectorNode)}`;
      return getByRegularSelector(regularSelectorNode, root, specifiedSelector);
    });
  } // foundElements should be flattened
  // as getByRegularSelector() returns elements array, and Array.map() collects them to array


  return flatten(foundElements);
};
/**
 * Returns elements nodes for Selector node.
 * As far as any selector always starts with regular part,
 * it selects by RegularSelector first and checks found elements later.
 *
 * Relative pseudo-classes has it's own subtree so getElementsForSelectorNode is called recursively.
 *
 * 'specifiedSelector' is needed for :has(), :is(), and :not() pseudo-classes
 * as native querySelectorAll() does not select exact element descendants even if it is called on 'div'
 * e.g. ':scope' specification is needed for proper descendants selection for 'div:has(> img)'.
 * So we check `divNode.querySelectorAll(':scope > img').length > 0`.
 *
 * @param selectorNode Selector node.
 * @param root Root DOM element.
 * @param specifiedSelector Needed element specification.
 *
 * @returns Array of DOM elements.
 * @throws An error if there is no selectorNodeChild.
 */

const getElementsForSelectorNode = (selectorNode, root, specifiedSelector) => {
  let selectedElements = [];
  let i = 0;

  while (i < selectorNode.children.length) {
    const selectorNodeChild = getItemByIndex(selectorNode.children, i, 'selectorNodeChild should be specified');

    if (i === 0) {
      // any selector always starts with regular selector
      selectedElements = getByRegularSelector(selectorNodeChild, root, specifiedSelector);
    } else if (isExtendedSelectorNode(selectorNodeChild)) {
      // filter previously selected elements by next selector nodes
      selectedElements = getByExtendedSelector(selectedElements, selectorNodeChild);
    } else if (isRegularSelectorNode(selectorNodeChild)) {
      selectedElements = getByFollowingRegularSelector(selectedElements, selectorNodeChild);
    }

    i += 1;
  }

  return selectedElements;
};

/**
 * Selects elements by ast.
 *
 * @param ast Ast of parsed selector.
 * @param doc Document.
 *
 * @returns Array of DOM elements.
 */

const selectElementsByAst = function (ast) {
  let doc = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : document;
  const selectedElements = []; // ast root is SelectorList node;
  // it has Selector nodes as children which should be processed separately

  ast.children.forEach(selectorNode => {
    selectedElements.push(...getElementsForSelectorNode(selectorNode, doc));
  }); // selectedElements should be flattened as it is array of arrays with elements

  const uniqueElements = [...new Set(flatten(selectedElements))];
  return uniqueElements;
};
/**
 * Class of ExtCssDocument is needed for caching.
 * For making cache related to each new instance of class, not global.
 */

class ExtCssDocument {
  /**
   * Cache with selectors and their AST parsing results.
   */

  /**
   * Creates new ExtCssDocument and inits new `astCache`.
   */
  constructor() {
    this.astCache = new Map();
  }
  /**
   * Saves selector and it's ast to cache.
   *
   * @param selector Standard or extended selector.
   * @param ast Selector ast.
   */


  saveAstToCache(selector, ast) {
    this.astCache.set(selector, ast);
  }
  /**
   * Returns ast from cache for given selector.
   *
   * @param selector Standard or extended selector.
   *
   * @returns Previously parsed ast found in cache, or null if not found.
   */


  getAstFromCache(selector) {
    const cachedAst = this.astCache.get(selector) || null;
    return cachedAst;
  }
  /**
   * Returns selector ast:
   * - if cached ast exists — returns it;
   * - if no cached ast — saves newly parsed ast to cache and returns it.
   *
   * @param selector Standard or extended selector.
   *
   * @returns Ast for `selector`.
   */


  getSelectorAst(selector) {
    let ast = this.getAstFromCache(selector);

    if (!ast) {
      ast = parse(selector);
    }

    this.saveAstToCache(selector, ast);
    return ast;
  }
  /**
   * Selects elements by selector.
   *
   * @param selector Standard or extended selector.
   *
   * @returns Array of DOM elements.
   */


  querySelectorAll(selector) {
    const ast = this.getSelectorAst(selector);
    return selectElementsByAst(ast);
  }

}
const extCssDocument = new ExtCssDocument();

/**
 * Converts array of `entries` to object.
 * Object.fromEntries() polyfill because it is not supported by old browsers, e.g. Chrome 55.
 * Only first two elements of `entries` array matter, other will be skipped silently.
 *
 * @see {@link https://caniuse.com/?search=Object.fromEntries}
 *
 * @param entries Array of pairs.
 *
 * @returns Object converted from `entries`.
 */
const getObjectFromEntries = entries => {
  const object = {};
  entries.forEach(el => {
    const [key, value] = el;
    object[key] = value;
  });
  return object;
};

const DEBUG_PSEUDO_PROPERTY_KEY = 'debug';
/**
 * Checks the presence of :remove() pseudo-class and validates it while parsing the selector part of css rule.
 *
 * @param rawSelector Selector which may contain :remove() pseudo-class.
 *
 * @returns Parsed selector data with selector and styles.
 * @throws An error on invalid :remove() position.
 */

const parseRemoveSelector = rawSelector => {
  /**
   * No error will be thrown on invalid selector as it will be validated later
   * so it's better to explicitly specify 'any' selector for :remove() pseudo-class by '*',
   * e.g. '.banner > *:remove()' instead of '.banner > :remove()'.
   */
  // ':remove()'
  // eslint-disable-next-line max-len
  const VALID_REMOVE_MARKER = `${COLON}${REMOVE_PSEUDO_MARKER}${BRACKET.PARENTHESES.LEFT}${BRACKET.PARENTHESES.RIGHT}`; // ':remove(' - needed for validation rules like 'div:remove(2)'

  const INVALID_REMOVE_MARKER = `${COLON}${REMOVE_PSEUDO_MARKER}${BRACKET.PARENTHESES.LEFT}`;
  let selector;
  let shouldRemove = false;
  const firstIndex = rawSelector.indexOf(VALID_REMOVE_MARKER);

  if (firstIndex === 0) {
    // e.g. ':remove()'
    throw new Error(`${REMOVE_ERROR_PREFIX.NO_TARGET_SELECTOR}: '${rawSelector}'`);
  } else if (firstIndex > 0) {
    if (firstIndex !== rawSelector.lastIndexOf(VALID_REMOVE_MARKER)) {
      // rule with more than one :remove() pseudo-class is invalid
      // e.g. '.block:remove() > .banner:remove()'
      throw new Error(`${REMOVE_ERROR_PREFIX.MULTIPLE_USAGE}: '${rawSelector}'`);
    } else if (firstIndex + VALID_REMOVE_MARKER.length < rawSelector.length) {
      // remove pseudo-class should be last in the rule
      // e.g. '.block:remove():upward(2)'
      throw new Error(`${REMOVE_ERROR_PREFIX.INVALID_POSITION}: '${rawSelector}'`);
    } else {
      // valid :remove() pseudo-class position
      selector = rawSelector.substring(0, firstIndex);
      shouldRemove = true;
    }
  } else if (rawSelector.includes(INVALID_REMOVE_MARKER)) {
    // it is not valid if ':remove()' is absent in rule but just ':remove(' is present
    // e.g. 'div:remove(0)'
    throw new Error(`${REMOVE_ERROR_PREFIX.INVALID_REMOVE}: '${rawSelector}'`);
  } else {
    // there is no :remove() pseudo-class in rule
    selector = rawSelector;
  }

  const stylesOfSelector = shouldRemove ? [{
    property: REMOVE_PSEUDO_MARKER,
    value: PSEUDO_PROPERTY_POSITIVE_VALUE
  }] : [];
  return {
    selector,
    stylesOfSelector
  };
};
/**
 * Parses cropped selector part found before `{`.
 *
 * @param selectorBuffer Buffered selector to parse.
 * @param extCssDoc Needed for caching of selector ast.
 *
 * @returns Parsed validation data for cropped part of stylesheet which may be a selector.
 * @throws An error on unsupported CSS features, e.g. at-rules.
 */

const parseSelectorRulePart = (selectorBuffer, extCssDoc) => {
  let selector = selectorBuffer.trim();

  if (selector.startsWith(AT_RULE_MARKER)) {
    throw new Error(`${NO_AT_RULE_ERROR_PREFIX}: '${selector}'.`);
  }

  let removeSelectorData;

  try {
    removeSelectorData = parseRemoveSelector(selector);
  } catch (e) {
    logger.error(getErrorMessage(e));
    throw new Error(`${REMOVE_ERROR_PREFIX.INVALID_REMOVE}: '${selector}'`);
  }

  let stylesOfSelector = [];
  let success = false;
  let ast;

  try {
    selector = removeSelectorData.selector;
    stylesOfSelector = removeSelectorData.stylesOfSelector; // validate found selector by parsing it to ast
    // so if it is invalid error will be thrown

    ast = extCssDoc.getSelectorAst(selector);
    success = true;
  } catch (e) {
    success = false;
  }

  return {
    success,
    selector,
    ast,
    stylesOfSelector
  };
};
/**
 * Creates a map for storing raw results of css rules parsing.
 * Used for merging styles for same selector.
 *
 * @returns Map where **key** is `selector`
 * and **value** is object with `ast` and `styles`.
 */

const createRawResultsMap = () => {
  return new Map();
};
/**
 * Saves rules data for unique selectors.
 *
 * @param rawResults Previously collected results of parsing.
 * @param rawRuleData Parsed rule data.
 *
 * @throws An error if there is no rawRuleData.styles or rawRuleData.ast.
 */

const saveToRawResults = (rawResults, rawRuleData) => {
  const {
    selector,
    ast,
    rawStyles
  } = rawRuleData;

  if (!rawStyles) {
    throw new Error(`No style declaration for selector: '${selector}'`);
  }

  if (!ast) {
    throw new Error(`No ast parsed for selector: '${selector}'`);
  }

  const storedRuleData = rawResults.get(selector);

  if (!storedRuleData) {
    rawResults.set(selector, {
      ast,
      styles: rawStyles
    });
  } else {
    storedRuleData.styles.push(...rawStyles);
  }
};
/**
 * Checks whether the 'remove' property positively set in styles
 * with only one positive value - 'true'.
 *
 * @param styles Array of styles.
 *
 * @returns True if there is 'remove' property with 'true' value in `styles`.
 */

const isRemoveSetInStyles = styles => {
  return styles.some(s => {
    return s.property === REMOVE_PSEUDO_MARKER && s.value === PSEUDO_PROPERTY_POSITIVE_VALUE;
  });
};
/**
 * Returns 'debug' property value which is set in styles.
 *
 * @param styles Array of styles.
 *
 * @returns Value of 'debug' property if it is set in `styles`,
 * or `undefined` if the property is not found.
 */


const getDebugStyleValue = styles => {
  const debugStyle = styles.find(s => {
    return s.property === DEBUG_PSEUDO_PROPERTY_KEY;
  });
  return debugStyle === null || debugStyle === void 0 ? void 0 : debugStyle.value;
};
/**
 * Prepares final RuleData.
 * Handles `debug` and `remove` in raw rule data styles.
 *
 * @param rawRuleData Raw data of selector css rule parsing.
 *
 * @returns Parsed ExtendedCss rule data.
 * @throws An error if rawRuleData.ast or rawRuleData.rawStyles not defined.
 */


const prepareRuleData = rawRuleData => {
  const {
    selector,
    ast,
    rawStyles
  } = rawRuleData;

  if (!ast) {
    throw new Error(`AST should be parsed for selector: '${selector}'`);
  }

  if (!rawStyles) {
    throw new Error(`Styles should be parsed for selector: '${selector}'`);
  }

  const ruleData = {
    selector,
    ast
  };
  const debugValue = getDebugStyleValue(rawStyles);
  const shouldRemove = isRemoveSetInStyles(rawStyles);
  let styles = rawStyles;

  if (debugValue) {
    // get rid of 'debug' from styles
    styles = rawStyles.filter(s => s.property !== DEBUG_PSEUDO_PROPERTY_KEY); // and set it as separate property only if its value is valid
    // which is 'true' or 'global'

    if (debugValue === PSEUDO_PROPERTY_POSITIVE_VALUE || debugValue === DEBUG_PSEUDO_PROPERTY_GLOBAL_VALUE) {
      ruleData.debug = debugValue;
    }
  }

  if (shouldRemove) {
    // no other styles are needed to apply if 'remove' is set
    ruleData.style = {
      [REMOVE_PSEUDO_MARKER]: PSEUDO_PROPERTY_POSITIVE_VALUE
    };
    /**
     * 'content' property is needed for ExtCssConfiguration.beforeStyleApplied().
     *
     * @see {@link BeforeStyleAppliedCallback}
     */

    const contentStyle = styles.find(s => s.property === CONTENT_CSS_PROPERTY);

    if (contentStyle) {
      ruleData.style[CONTENT_CSS_PROPERTY] = contentStyle.value;
    }
  } else {
    // otherwise all styles should be applied.
    // every style property will be unique because of their converting into object
    if (styles.length > 0) {
      const stylesAsEntries = styles.map(style => {
        const {
          property,
          value
        } = style;
        return [property, value];
      });
      const preparedStyleData = getObjectFromEntries(stylesAsEntries);
      ruleData.style = preparedStyleData;
    }
  }

  return ruleData;
};
/**
 * Combines previously parsed css rules data objects
 * into rules which are ready to apply.
 *
 * @param rawResults Previously parsed css rules data objects.
 *
 * @returns Parsed ExtendedCss rule data.
 */

const combineRulesData = rawResults => {
  const results = [];
  rawResults.forEach((value, key) => {
    const selector = key;
    const {
      ast,
      styles: rawStyles
    } = value;
    results.push(prepareRuleData({
      selector,
      ast,
      rawStyles
    }));
  });
  return results;
};

/**
 * Trims `rawStyle` and splits it into tokens.
 *
 * @param rawStyle Style declaration block content inside curly bracket — `{` and `}` —
 * can be a single style declaration or a list of declarations.
 *
 * @returns Array of tokens supported for style declaration block.
 */

const tokenizeStyleBlock = rawStyle => {
  const styleDeclaration = rawStyle.trim();
  return tokenize(styleDeclaration, SUPPORTED_STYLE_DECLARATION_MARKS);
};

/**
 * Describes possible style declaration parts.
 *
 * IMPORTANT: it is used as 'const' instead of 'enum' to avoid side effects
 * during ExtendedCss import into other libraries.
 */

const DECLARATION_PART = {
  PROPERTY: 'property',
  VALUE: 'value'
};

/**
 * Checks whether the quotes has been opened for style value.
 *
 * @param context Style block parser context.
 *
 * @returns True if style value has already opened quotes.
 */
const isValueQuotesOpen = context => {
  return context.bufferValue !== '' && context.valueQuoteMark !== null;
};
/**
 * Saves parsed property and value to collection of parsed styles.
 * Prunes context buffers for property and value.
 *
 * @param context Style block parser context.
 */


const collectStyle = context => {
  context.styles.push({
    property: context.bufferProperty.trim(),
    value: context.bufferValue.trim()
  }); // reset buffers

  context.bufferProperty = '';
  context.bufferValue = '';
};
/**
 * Handles token which is supposed to be a part of style **property**.
 *
 * @param context Style block parser context.
 * @param styleBlock Whole style block which is being parsed.
 * @param token Current token.
 *
 * @throws An error on invalid token.
 */


const processPropertyToken = (context, styleBlock, token) => {
  const {
    value: tokenValue
  } = token;

  switch (token.type) {
    case TOKEN_TYPE.WORD:
      if (context.bufferProperty.length > 0) {
        // e.g. 'padding top: 0;' - current tokenValue is 'top' which is not valid
        throw new Error(`Invalid style property in style block: '${styleBlock}'`);
      }

      context.bufferProperty += tokenValue;
      break;

    case TOKEN_TYPE.MARK:
      // only colon and whitespaces are allowed while style property parsing
      if (tokenValue === COLON) {
        if (context.bufferProperty.trim().length === 0) {
          // e.g. such style block: '{ : none; }'
          throw new Error(`Missing style property before ':' in style block: '${styleBlock}'`);
        } // the property successfully collected


        context.bufferProperty = context.bufferProperty.trim(); // prepare for value collecting

        context.processing = DECLARATION_PART.VALUE; // the property buffer shall be reset after the value is successfully collected
      } else if (WHITE_SPACE_CHARACTERS.includes(tokenValue)) ; else {
        // if after the property there is anything other than ':' except whitespace, this is a parse error
        // https://www.w3.org/TR/css-syntax-3/#consume-declaration
        throw new Error(`Invalid style declaration in style block: '${styleBlock}'`);
      }

      break;

    default:
      throw new Error(`Unsupported style property character: '${tokenValue}' in style block: '${styleBlock}'`);
  }
};
/**
 * Handles token which is supposed to be a part of style **value**.
 *
 * @param context Style block parser context.
 * @param styleBlock Whole style block which is being parsed.
 * @param token Current token.
 *
 * @throws An error on invalid token.
 */


const processValueToken = (context, styleBlock, token) => {
  const {
    value: tokenValue
  } = token;

  if (token.type === TOKEN_TYPE.WORD) {
    // simply collect to buffer
    context.bufferValue += tokenValue;
  } else {
    // otherwise check the mark
    switch (tokenValue) {
      case COLON:
        // the ':' character inside of the value should be inside of quotes
        // otherwise the value is not valid
        // e.g. 'content: display: none'
        // parser is here        ↑
        if (!isValueQuotesOpen(context)) {
          // eslint-disable-next-line max-len
          throw new Error(`Invalid style value for property '${context.bufferProperty}' in style block: '${styleBlock}'`);
        } // collect the colon inside quotes
        // e.g. 'content: "test:123"'
        // parser is here      ↑


        context.bufferValue += tokenValue;
        break;

      case SEMICOLON:
        if (isValueQuotesOpen(context)) {
          // ';' inside quotes is part of style value
          // e.g. 'content: "test;"'
          context.bufferValue += tokenValue;
        } else {
          // otherwise the value is successfully collected
          // save parsed style
          collectStyle(context); // prepare for value collecting

          context.processing = DECLARATION_PART.PROPERTY;
        }

        break;

      case SINGLE_QUOTE:
      case DOUBLE_QUOTE:
        // if quotes are not open
        if (context.valueQuoteMark === null) {
          // save the opening quote mark for later comparison
          context.valueQuoteMark = tokenValue;
        } else if (!context.bufferValue.endsWith(BACKSLASH) // otherwise a quote appeared in the value earlier,
        // and non-escaped quote should be checked whether it is a closing quote
        && context.valueQuoteMark === tokenValue) {
          context.valueQuoteMark = null;
        } // always save the quote to the buffer
        // but after the context.bufferValue is checked for BACKSLASH above
        // e.g. 'content: "test:123"'
        //      'content: "\""'


        context.bufferValue += tokenValue;
        break;

      case BACKSLASH:
        if (!isValueQuotesOpen(context)) {
          // eslint-disable-next-line max-len
          throw new Error(`Invalid style value for property '${context.bufferProperty}' in style block: '${styleBlock}'`);
        } // collect the backslash inside quotes
        // e.g. ' content: "\"" '
        // parser is here   ↑


        context.bufferValue += tokenValue;
        break;

      case SPACE:
      case TAB:
      case CARRIAGE_RETURN:
      case LINE_FEED:
      case FORM_FEED:
        // whitespace should be collected only if the value collecting started
        // which means inside of the value
        // e.g. 'width: 100% !important'
        // parser is here   ↑
        if (context.bufferValue.length > 0) {
          context.bufferValue += tokenValue;
        } // otherwise it can be omitted
        // e.g. 'width:  100% !important'
        // here        ↑


        break;

      default:
        throw new Error(`Unknown style declaration token: '${tokenValue}'`);
    }
  }
};
/**
 * Parses css rule style block.
 *
 * @param rawStyleBlock Style block to parse.
 *
 * @returns Array of style declarations.
 * @throws An error on invalid style block.
 */


const parseStyleBlock = rawStyleBlock => {
  const styleBlock = rawStyleBlock.trim();
  const tokens = tokenizeStyleBlock(styleBlock);
  const context = {
    // style declaration parsing always starts with 'property'
    processing: DECLARATION_PART.PROPERTY,
    styles: [],
    bufferProperty: '',
    bufferValue: '',
    valueQuoteMark: null
  };
  let i = 0;

  while (i < tokens.length) {
    const token = tokens[i];

    if (!token) {
      break;
    }

    if (context.processing === DECLARATION_PART.PROPERTY) {
      processPropertyToken(context, styleBlock, token);
    } else if (context.processing === DECLARATION_PART.VALUE) {
      processValueToken(context, styleBlock, token);
    } else {
      throw new Error('Style declaration parsing failed');
    }

    i += 1;
  } // unbalanced value quotes
  // e.g. 'content: "test} '


  if (isValueQuotesOpen(context)) {
    throw new Error(`Unbalanced style declaration quotes in style block: '${styleBlock}'`);
  } // collected property and value have not been saved to styles;
  // it is possible for style block with no semicolon at the end
  // e.g. such style block: '{ display: none }'


  if (context.bufferProperty.length > 0) {
    if (context.bufferValue.length === 0) {
      // e.g. such style blocks:
      //   '{ display:  }'
      //   '{ remove }'
      // eslint-disable-next-line max-len
      throw new Error(`Missing style value for property '${context.bufferProperty}' in style block '${styleBlock}'`);
    }

    collectStyle(context);
  } // rule with empty style block
  // e.g. 'div { }'


  if (context.styles.length === 0) {
    throw new Error(STYLE_ERROR_PREFIX.NO_STYLE);
  }

  return context.styles;
};

/**
 * Returns array of positions of `{` in `cssRule`.
 *
 * @param cssRule CSS rule.
 *
 * @returns Array of left curly bracket indexes.
 */

const getLeftCurlyBracketIndexes = cssRule => {
  const indexes = [];

  for (let i = 0; i < cssRule.length; i += 1) {
    if (cssRule[i] === BRACKET.CURLY.LEFT) {
      indexes.push(i);
    }
  }

  return indexes;
}; // TODO: use `extCssDoc` for caching of style block parser results

/**
 * Parses CSS rule into rules data object:
 * 1. Find the last `{` mark in the rule
 *    which supposed to be a divider between selector and style block.
 * 2. Validates found string part before the `{` via selector parser; and if:
 *  - parsing failed – get the previous `{` in the rule,
 *    and validates a new rule part again [2];
 *  - parsing successful — saves a found rule part as selector and parses the style block.
 *
 * @param rawCssRule Single CSS rule to parse.
 * @param extCssDoc ExtCssDocument which is used for selector ast caching.
 *
 * @returns Array of rules data which contains:
 *   - selector as string;
 *   - ast to query elements by;
 *   - map of styles to apply.
 * @throws An error on invalid css rule syntax:
 *   - unsupported CSS features – comments and at-rules
 *   - invalid selector or style block.
 */


const parseRule = (rawCssRule, extCssDoc) => {
  var _rawRuleData$selector;

  const cssRule = rawCssRule.trim();

  if (cssRule.includes(`${SLASH}${ASTERISK}`) && cssRule.includes(`${ASTERISK}${SLASH}`)) {
    throw new Error(STYLE_ERROR_PREFIX.NO_COMMENT);
  }

  const leftCurlyBracketIndexes = getLeftCurlyBracketIndexes(cssRule); // rule with style block but no selector
  // e.g. '{ display: none; }'

  if (getFirst(leftCurlyBracketIndexes) === 0) {
    throw new Error(NO_SELECTOR_ERROR_PREFIX);
  }

  let selectorData; // if rule has `{` but there is no `}`

  if (leftCurlyBracketIndexes.length > 0 && !cssRule.includes(BRACKET.CURLY.RIGHT)) {
    throw new Error(`${STYLE_ERROR_PREFIX.NO_STYLE} OR ${STYLE_ERROR_PREFIX.UNCLOSED_STYLE}`);
  }

  if ( // if rule has no `{`
  leftCurlyBracketIndexes.length === 0 // or `}`
  || !cssRule.includes(BRACKET.CURLY.RIGHT)) {
    try {
      // the whole css rule considered as "selector part"
      // which may contain :remove() pseudo-class
      selectorData = parseSelectorRulePart(cssRule, extCssDoc);

      if (selectorData.success) {
        var _selectorData$stylesO;

        // rule with no style block has valid :remove() pseudo-class
        // which is parsed into "styles"
        // e.g. 'div:remove()'
        // but also it can be just selector with no styles
        // e.g. 'div'
        // which should not be considered as valid css rule
        if (((_selectorData$stylesO = selectorData.stylesOfSelector) === null || _selectorData$stylesO === void 0 ? void 0 : _selectorData$stylesO.length) === 0) {
          throw new Error(STYLE_ERROR_PREFIX.NO_STYLE_OR_REMOVE);
        }

        return {
          selector: selectorData.selector.trim(),
          ast: selectorData.ast,
          rawStyles: selectorData.stylesOfSelector
        };
      } else {
        // not valid selector
        throw new Error('Invalid selector');
      }
    } catch (e) {
      throw new Error(getErrorMessage(e));
    }
  }

  let selectorBuffer;
  let styleBlockBuffer;
  const rawRuleData = {
    selector: ''
  }; // css rule should be parsed from its end

  for (let i = leftCurlyBracketIndexes.length - 1; i > -1; i -= 1) {
    const index = leftCurlyBracketIndexes[i];

    if (!index) {
      throw new Error(`Impossible to continue, no '{' to process for rule: '${cssRule}'`);
    } // selector is before `{`, style block is after it


    selectorBuffer = cssRule.slice(0, index); // skip curly brackets

    styleBlockBuffer = cssRule.slice(index + 1, cssRule.length - 1);
    selectorData = parseSelectorRulePart(selectorBuffer, extCssDoc);

    if (selectorData.success) {
      var _rawRuleData$rawStyle;

      // selector successfully parsed
      rawRuleData.selector = selectorData.selector.trim();
      rawRuleData.ast = selectorData.ast;
      rawRuleData.rawStyles = selectorData.stylesOfSelector; // style block should be parsed
      // TODO: add cache for style block parsing

      const parsedStyles = parseStyleBlock(styleBlockBuffer);
      (_rawRuleData$rawStyle = rawRuleData.rawStyles) === null || _rawRuleData$rawStyle === void 0 ? void 0 : _rawRuleData$rawStyle.push(...parsedStyles); // stop rule parsing

      break;
    } else {
      // if selector was not parsed successfully
      // continue with next index of `{`
      continue;
    }
  }

  if (((_rawRuleData$selector = rawRuleData.selector) === null || _rawRuleData$selector === void 0 ? void 0 : _rawRuleData$selector.length) === 0) {
    // skip the rule as selector
    throw new Error('Selector in not valid');
  }

  return rawRuleData;
};
/**
 * Parses array of CSS rules into array of rules data objects.
 * Invalid rules are skipped and not applied,
 * and the errors are logged.
 *
 * @param rawCssRules Array of rules to parse.
 * @param extCssDoc Needed for selector ast caching.
 *
 * @returns Array of parsed valid rules data.
 */

const parseRules = (rawCssRules, extCssDoc) => {
  const rawResults = createRawResultsMap();
  const warnings = []; // trim all rules and find unique ones

  const uniqueRules = [...new Set(rawCssRules.map(r => r.trim()))];
  uniqueRules.forEach(rule => {
    try {
      saveToRawResults(rawResults, parseRule(rule, extCssDoc));
    } catch (e) {
      // skip the invalid rule
      const errorMessage = getErrorMessage(e);
      warnings.push(`'${rule}' - error: '${errorMessage}'`);
    }
  }); // log info about skipped invalid rules

  if (warnings.length > 0) {
    logger.info(`Invalid rules:\n  ${warnings.join('\n  ')}`);
  }

  return combineRulesData(rawResults);
};

const REGEXP_DECLARATION_END = /[;}]/g;
const REGEXP_DECLARATION_DIVIDER = /[;:}]/g;
const REGEXP_NON_WHITESPACE = /\S/g;
/**
 * Interface for stylesheet parser context.
 */

/**
 * Resets rule data buffer to init value after rule successfully collected.
 *
 * @param context Stylesheet parser context.
 */
const restoreRuleAcc = context => {
  context.rawRuleData = {
    selector: ''
  };
};
/**
 * Parses cropped selector part found before `{` previously.
 *
 * @param context Stylesheet parser context.
 * @param extCssDoc Needed for caching of selector ast.
 *
 * @returns Parsed validation data for cropped part of stylesheet which may be a selector.
 * @throws An error on unsupported CSS features, e.g. at-rules.
 */


const parseSelectorPart = (context, extCssDoc) => {
  let selector = context.selectorBuffer.trim();

  if (selector.startsWith(AT_RULE_MARKER)) {
    throw new Error(`${NO_AT_RULE_ERROR_PREFIX}: '${selector}'.`);
  }

  let removeSelectorData;

  try {
    removeSelectorData = parseRemoveSelector(selector);
  } catch (e) {
    logger.error(getErrorMessage(e));
    throw new Error(`${REMOVE_ERROR_PREFIX.INVALID_REMOVE}: '${selector}'`);
  }

  if (context.nextIndex === -1) {
    if (selector === removeSelectorData.selector) {
      // rule should have style or pseudo-class :remove()
      throw new Error(`${STYLE_ERROR_PREFIX.NO_STYLE_OR_REMOVE}: '${context.cssToParse}'`);
    } // stop parsing as there is no style declaration and selector parsed fine


    context.cssToParse = '';
  }

  let stylesOfSelector = [];
  let success = false;
  let ast;

  try {
    selector = removeSelectorData.selector;
    stylesOfSelector = removeSelectorData.stylesOfSelector; // validate found selector by parsing it to ast
    // so if it is invalid error will be thrown

    ast = extCssDoc.getSelectorAst(selector);
    success = true;
  } catch (e) {
    success = false;
  }

  if (context.nextIndex > 0) {
    // slice found valid selector part off
    // and parse rest of stylesheet later
    context.cssToParse = context.cssToParse.slice(context.nextIndex);
  }

  return {
    success,
    selector,
    ast,
    stylesOfSelector
  };
};
/**
 * Recursively parses style declaration string into `Style`s.
 *
 * @param context Stylesheet parser context.
 * @param styles Array of styles.
 *
 * @throws An error on invalid style declaration.
 * @returns A number index of the next `}` in `this.cssToParse`.
 */


const parseUntilClosingBracket = (context, styles) => {
  // Expects ":", ";", and "}".
  REGEXP_DECLARATION_DIVIDER.lastIndex = context.nextIndex;
  let match = REGEXP_DECLARATION_DIVIDER.exec(context.cssToParse);

  if (match === null) {
    throw new Error(`${STYLE_ERROR_PREFIX.INVALID_STYLE}: '${context.cssToParse}'`);
  }

  let matchPos = match.index;
  let matched = match[0];

  if (matched === BRACKET.CURLY.RIGHT) {
    const declarationChunk = context.cssToParse.slice(context.nextIndex, matchPos);

    if (declarationChunk.trim().length === 0) {
      // empty style declaration
      // e.g. 'div { }'
      if (styles.length === 0) {
        throw new Error(`${STYLE_ERROR_PREFIX.NO_STYLE}: '${context.cssToParse}'`);
      } // else valid style parsed before it
      // e.g. '{ display: none; }' -- position is after ';'

    } else {
      // closing curly bracket '}' is matched before colon ':'
      // trimmed declarationChunk is not a space, between ';' and '}',
      // e.g. 'visible }' in style '{ display: none; visible }' after part before ';' is parsed
      throw new Error(`${STYLE_ERROR_PREFIX.INVALID_STYLE}: '${context.cssToParse}'`);
    }

    return matchPos;
  }

  if (matched === COLON) {
    const colonIndex = matchPos; // Expects ";" and "}".

    REGEXP_DECLARATION_END.lastIndex = colonIndex;
    match = REGEXP_DECLARATION_END.exec(context.cssToParse);

    if (match === null) {
      throw new Error(`${STYLE_ERROR_PREFIX.UNCLOSED_STYLE}: '${context.cssToParse}'`);
    }

    matchPos = match.index;
    matched = match[0]; // Populates the `styleMap` key-value map.

    const property = context.cssToParse.slice(context.nextIndex, colonIndex).trim();

    if (property.length === 0) {
      throw new Error(`${STYLE_ERROR_PREFIX.NO_PROPERTY}: '${context.cssToParse}'`);
    }

    const value = context.cssToParse.slice(colonIndex + 1, matchPos).trim();

    if (value.length === 0) {
      throw new Error(`${STYLE_ERROR_PREFIX.NO_VALUE}: '${context.cssToParse}'`);
    }

    styles.push({
      property,
      value
    }); // finish style parsing if '}' is found
    // e.g. '{ display: none }' -- no ';' at the end of declaration

    if (matched === BRACKET.CURLY.RIGHT) {
      return matchPos;
    }
  } // matchPos is the position of the next ';'
  // crop 'cssToParse' and re-run the loop


  context.cssToParse = context.cssToParse.slice(matchPos + 1);
  context.nextIndex = 0;
  return parseUntilClosingBracket(context, styles); // Should be a subject of tail-call optimization.
};
/**
 * Parses next style declaration part in stylesheet.
 *
 * @param context Stylesheet parser context.
 *
 * @returns Array of style data objects.
 */


const parseNextStyle = context => {
  const styles = [];
  const styleEndPos = parseUntilClosingBracket(context, styles); // find next rule after the style declaration

  REGEXP_NON_WHITESPACE.lastIndex = styleEndPos + 1;
  const match = REGEXP_NON_WHITESPACE.exec(context.cssToParse);

  if (match === null) {
    context.cssToParse = '';
    return styles;
  }

  const matchPos = match.index; // cut out matched style declaration for previous selector

  context.cssToParse = context.cssToParse.slice(matchPos);
  return styles;
};
/**
 * Parses stylesheet of rules into rules data objects (non-recursively):
 * 1. Iterates through stylesheet string.
 * 2. Finds first `{` which can be style declaration start or part of selector.
 * 3. Validates found string part via selector parser; and if:
 *  - it throws error — saves string part to buffer as part of selector,
 *    slice next stylesheet part to `{` [2] and validates again [3];
 *  - no error — saves found string part as selector and starts to parse styles (recursively).
 *
 * @param rawStylesheet Raw stylesheet as string.
 * @param extCssDoc ExtCssDocument which uses cache while selectors parsing.
 * @throws An error on unsupported CSS features, e.g. comments or invalid stylesheet syntax.
 * @returns Array of rules data which contains:
 * - selector as string;
 * - ast to query elements by;
 * - map of styles to apply.
 */


const parseStylesheet = (rawStylesheet, extCssDoc) => {
  const stylesheet = rawStylesheet.trim();

  if (stylesheet.includes(`${SLASH}${ASTERISK}`) && stylesheet.includes(`${ASTERISK}${SLASH}`)) {
    throw new Error(`${STYLE_ERROR_PREFIX.NO_COMMENT} in stylesheet: '${stylesheet}'`);
  }

  const context = {
    // any stylesheet should start with selector
    isSelector: true,
    // init value of parser position
    nextIndex: 0,
    // init value of cssToParse
    cssToParse: stylesheet,
    // buffer for collecting selector part
    selectorBuffer: '',
    // accumulator for rules
    rawRuleData: {
      selector: ''
    }
  };
  const rawResults = createRawResultsMap();
  let selectorData; // context.cssToParse is going to be cropped while its parsing

  while (context.cssToParse) {
    if (context.isSelector) {
      // find index of first opening curly bracket
      // which may mean start of style part and end of selector one
      context.nextIndex = context.cssToParse.indexOf(BRACKET.CURLY.LEFT); // rule should not start with style, selector is required
      // e.g. '{ display: none; }'

      if (context.selectorBuffer.length === 0 && context.nextIndex === 0) {
        throw new Error(`${STYLE_ERROR_PREFIX.NO_SELECTOR}: '${context.cssToParse}'`);
      }

      if (context.nextIndex === -1) {
        // no style declaration in rule
        // but rule still may contain :remove() pseudo-class
        context.selectorBuffer = context.cssToParse;
      } else {
        // collect string parts before opening curly bracket
        // until valid selector collected
        context.selectorBuffer += context.cssToParse.slice(0, context.nextIndex);
      }

      selectorData = parseSelectorPart(context, extCssDoc);

      if (selectorData.success) {
        // selector successfully parsed
        context.rawRuleData.selector = selectorData.selector.trim();
        context.rawRuleData.ast = selectorData.ast;
        context.rawRuleData.rawStyles = selectorData.stylesOfSelector;
        context.isSelector = false; // save rule data if there is no style declaration

        if (context.nextIndex === -1) {
          saveToRawResults(rawResults, context.rawRuleData); // clean up ruleContext

          restoreRuleAcc(context);
        } else {
          // skip the opening curly bracket at the start of style declaration part
          context.nextIndex = 1;
          context.selectorBuffer = '';
        }
      } else {
        // if selector was not successfully parsed parseSelectorPart(), continue stylesheet parsing:
        // save the found bracket to buffer and proceed to next loop iteration
        context.selectorBuffer += BRACKET.CURLY.LEFT; // delete `{` from cssToParse

        context.cssToParse = context.cssToParse.slice(1);
      }
    } else {
      var _context$rawRuleData$;

      // style declaration should be parsed
      const parsedStyles = parseNextStyle(context); // styles can be parsed from selector part if it has :remove() pseudo-class
      // e.g. '.banner:remove() { debug: true; }'

      (_context$rawRuleData$ = context.rawRuleData.rawStyles) === null || _context$rawRuleData$ === void 0 ? void 0 : _context$rawRuleData$.push(...parsedStyles); // save rule data to results

      saveToRawResults(rawResults, context.rawRuleData);
      context.nextIndex = 0; // clean up ruleContext

      restoreRuleAcc(context); // parse next rule selector after style successfully parsed

      context.isSelector = true;
    }
  }

  return combineRulesData(rawResults);
};

/**
 * Checks whether passed `arg` is number type.
 *
 * @param arg Value to check.
 *
 * @returns True if `arg` is number and not NaN.
 */
const isNumber = arg => {
  return typeof arg === 'number' && !Number.isNaN(arg);
};

/**
 * The purpose of ThrottleWrapper is to throttle calls of the function
 * that applies ExtendedCss rules. The reasoning here is that the function calls
 * are triggered by MutationObserver and there may be many mutations in a short period of time.
 * We do not want to apply rules on every mutation so we use this helper to make sure
 * that there is only one call in the given amount of time.
 */

class ThrottleWrapper {
  /**
   * Creates new ThrottleWrapper.
   * The {@link callback} should be executed not more often than {@link ThrottleWrapper.THROTTLE_DELAY_MS}.
   *
   * @param callback The callback.
   */
  constructor(callback) {
    this.callback = callback;
    this.executeCallback = this.executeCallback.bind(this);
  }
  /**
   * Calls the {@link callback} function and update bounded throttle wrapper properties.
   */


  executeCallback() {
    this.lastRunTime = performance.now();

    if (isNumber(this.timerId)) {
      clearTimeout(this.timerId);
      delete this.timerId;
    }

    this.callback();
  }
  /**
   * Schedules the {@link executeCallback} function execution via setTimeout.
   * It may triggered by MutationObserver job which may occur too ofter, so we limit the function execution:
   *
   * 1. If {@link timerId} is set, ignore the call, because the function is already scheduled to be executed;
   *
   * 2. If {@link lastRunTime} is set, we need to check the time elapsed time since the last call. If it is
   * less than {@link ThrottleWrapper.THROTTLE_DELAY_MS}, we schedule the function execution after the remaining time.
   * 
   * Otherwise, we execute the function asynchronously to ensure that it is executed 
   * in the correct order with respect to DOM events, by deferring its execution until after 
   * those tasks have completed.
   */


  run() {
    if (isNumber(this.timerId)) {
      // there is a pending execution scheduled
      return;
    }

    if (isNumber(this.lastRunTime)) {
      const elapsedTime = performance.now() - this.lastRunTime;

      if (elapsedTime < ThrottleWrapper.THROTTLE_DELAY_MS) {
        this.timerId = window.setTimeout(this.executeCallback, ThrottleWrapper.THROTTLE_DELAY_MS - elapsedTime);
        return;
      }
    }
    /**
     * We use `setTimeout` instead `requestAnimationFrame`
     * here because requestAnimationFrame can be delayed for a long time
     * when the browser saves battery or the engine is heavily loaded.
     */


    this.timerId = window.setTimeout(this.executeCallback);
  }

}

_defineProperty(ThrottleWrapper, "THROTTLE_DELAY_MS", 150);

const LAST_EVENT_TIMEOUT_MS = 10;
const IGNORED_EVENTS = (/* unused pure expression or super */ null && (['mouseover', 'mouseleave', 'mouseenter', 'mouseout']));
const SUPPORTED_EVENTS = (/* unused pure expression or super */ null && ([// keyboard events
'keydown', 'keypress', 'keyup', // mouse events
'auxclick', 'click', 'contextmenu', 'dblclick', 'mousedown', 'mouseenter', 'mouseleave', 'mousemove', 'mouseover', 'mouseout', 'mouseup', 'pointerlockchange', 'pointerlockerror', 'select', 'wheel'])); // 'wheel' event makes scrolling in Safari twitchy
// https://github.com/AdguardTeam/ExtendedCss/issues/120

const SAFARI_PROBLEMATIC_EVENTS = (/* unused pure expression or super */ null && (['wheel']));
/**
 * We use EventTracker to track the event that is likely to cause the mutation.
 * The problem is that we cannot use `window.event` directly from the mutation observer call
 * as we're not in the event handler context anymore.
 */

class EventTracker {
  /**
   * Creates new EventTracker.
   */
  constructor() {
    _defineProperty(this, "getLastEventType", () => this.lastEventType);

    _defineProperty(this, "getTimeSinceLastEvent", () => {
      if (!this.lastEventTime) {
        return null;
      }

      return Date.now() - this.lastEventTime;
    });

    this.trackedEvents = isSafariBrowser ? SUPPORTED_EVENTS.filter(event => !SAFARI_PROBLEMATIC_EVENTS.includes(event)) : SUPPORTED_EVENTS;
    this.trackedEvents.forEach(eventName => {
      document.documentElement.addEventListener(eventName, this.trackEvent, true);
    });
  }
  /**
   * Callback for event listener for events tracking.
   *
   * @param event Any event.
   */


  trackEvent(event) {
    this.lastEventType = event.type;
    this.lastEventTime = Date.now();
  }

  /**
   * Checks whether the last caught event should be ignored.
   *
   * @returns True if event should be ignored.
   */
  isIgnoredEventType() {
    const lastEventType = this.getLastEventType();
    const sinceLastEventTime = this.getTimeSinceLastEvent();
    return !!lastEventType && IGNORED_EVENTS.includes(lastEventType) && !!sinceLastEventTime && sinceLastEventTime < LAST_EVENT_TIMEOUT_MS;
  }
  /**
   * Stops event tracking by removing event listener.
   */


  stopTracking() {
    this.trackedEvents.forEach(eventName => {
      document.documentElement.removeEventListener(eventName, this.trackEvent, true);
    });
  }

}

/**
 * We are trying to limit the number of callback calls by not calling it on all kind of "hover" events.
 * The rationale behind this is that "hover" events often cause attributes modification,
 * but re-applying extCSS rules will be useless as these attribute changes are usually transient.
 *
 * @param mutations DOM elements mutation records.
 * @returns True if all mutations are about attributes changes, otherwise false.
 */

function shouldIgnoreMutations(mutations) {
  // ignore if all mutations are about attributes changes
  return !mutations.some(m => m.type !== 'attributes');
}
/**
 * Adds new {@link context.domMutationObserver} instance and connect it to document.
 * 
 * @param context ExtendedCss context.
 */


function observeDocument(context) {
  if (context.isDomObserved) {
    return;
  } // enable dynamically added elements handling


  context.isDomObserved = true;
  context.domMutationObserver = new natives.MutationObserver(mutations => {
    if (!mutations || mutations.length === 0) {
      return;
    }

    const eventTracker = new EventTracker();

    if (eventTracker.isIgnoredEventType() && shouldIgnoreMutations(mutations)) {
      return;
    } // save instance of EventTracker to context
    // for removing its event listeners on disconnectDocument() while mainDisconnect()


    context.eventTracker = eventTracker;
    context.scheduler.run();
  });
  context.domMutationObserver.observe(document, {
    childList: true,
    subtree: true,
    attributes: true,
    attributeFilter: ['id', 'class']
  });
}
/**
 * Disconnect from {@link context.domMutationObserver}.
 * 
 * @param context ExtendedCss context.
 */

function disconnectDocument(context) {
  if (!context.isDomObserved) {
    return;
  } // disable dynamically added elements handling


  context.isDomObserved = false;

  if (context.domMutationObserver) {
    context.domMutationObserver.disconnect();
  } // clean up event listeners


  if (context.eventTracker) {
    context.eventTracker.stopTracking();
  }
}

const CONTENT_ATTR_PREFIX_REGEXP = /^("|')adguard.+?/;
/**
 * Removes affectedElement.node from DOM.
 *
 * @param context ExtendedCss context.
 * @param affectedElement Affected element.
 */

const removeElement = (context, affectedElement) => {
  const {
    node
  } = affectedElement;
  affectedElement.removed = true;
  const elementSelector = getElementSelectorPath(node); // check if the element has been already removed earlier

  const elementRemovalsCounter = context.removalsStatistic[elementSelector] || 0; // if removals attempts happened more than specified we do not try to remove node again

  if (elementRemovalsCounter > MAX_STYLE_PROTECTION_COUNT) {
    logger.error(`ExtendedCss: infinite loop protection for selector: '${elementSelector}'`);
    return;
  }

  if (node.parentElement) {
    node.parentElement.removeChild(node);
    context.removalsStatistic[elementSelector] = elementRemovalsCounter + 1;
  }
};
/**
 * Sets style to the specified DOM node.
 *
 * @param node DOM element.
 * @param style Style to set.
 */


const setStyleToElement = (node, style) => {
  if (!(node instanceof HTMLElement)) {
    return;
  }

  Object.keys(style).forEach(prop => {
    // Apply this style only to existing properties
    // We cannot use hasOwnProperty here (does not work in FF)
    if (typeof node.style.getPropertyValue(prop.toString()) !== 'undefined') {
      let value = style[prop];

      if (!value) {
        return;
      } // do not apply 'content' style given by tsurlfilter
      // which is needed only for BeforeStyleAppliedCallback


      if (prop === CONTENT_CSS_PROPERTY && value.match(CONTENT_ATTR_PREFIX_REGEXP)) {
        return;
      } // First we should remove !important attribute (or it won't be applied')


      value = removeSuffix(value.trim(), '!important').trim();
      node.style.setProperty(prop, value, 'important');
    }
  });
};
/**
 * Checks the required properties of `affectedElement`
 * **before** `beforeStyleApplied()` execution.
 *
 * @param affectedElement Affected element.
 *
 * @returns False if there is no `node` or `rules`
 * or `rules` is not an array.
 */

const isIAffectedElement = affectedElement => {
  return 'node' in affectedElement && 'rules' in affectedElement && affectedElement.rules instanceof Array;
};
/**
 * Checks the required properties of `affectedElement`
 * **after** `beforeStyleApplied()` execution.
 * These properties are needed for proper internal usage.
 *
 * @param affectedElement Affected element.
 *
 * @returns False if there is no `node` or `rules`
 * or `rules` is not an array.
 */


const isAffectedElement = affectedElement => {
  return 'node' in affectedElement && 'originalStyle' in affectedElement && 'rules' in affectedElement && affectedElement.rules instanceof Array;
};
/**
 * Applies style to the specified DOM node.
 *
 * @param context ExtendedCss context.
 * @param rawAffectedElement Object containing DOM node and rule to be applied.
 *
 * @throws An error if affectedElement has no style to apply.
 */


const applyStyle = (context, rawAffectedElement) => {
  if (rawAffectedElement.protectionObserver) {
    // style is already applied and protected by the observer
    return;
  }

  let affectedElement;

  if (context.beforeStyleApplied) {
    if (!isIAffectedElement(rawAffectedElement)) {
      throw new Error("Returned IAffectedElement should have 'node' and 'rules' properties");
    }

    affectedElement = context.beforeStyleApplied(rawAffectedElement);

    if (!affectedElement) {
      throw new Error("Callback 'beforeStyleApplied' should return IAffectedElement");
    }
  } else {
    affectedElement = rawAffectedElement;
  }

  if (!isAffectedElement(affectedElement)) {
    throw new Error("Returned IAffectedElement should have 'node' and 'rules' properties");
  }

  const {
    node,
    rules
  } = affectedElement;

  for (let i = 0; i < rules.length; i += 1) {
    const rule = rules[i];
    const selector = rule === null || rule === void 0 ? void 0 : rule.selector;
    const style = rule === null || rule === void 0 ? void 0 : rule.style;
    const debug = rule === null || rule === void 0 ? void 0 : rule.debug; // rule may not have style to apply
    // e.g. 'div:has(> a) { debug: true }' -> means no style to apply, and enable debug mode

    if (style) {
      if (style[REMOVE_PSEUDO_MARKER] === PSEUDO_PROPERTY_POSITIVE_VALUE) {
        removeElement(context, affectedElement);
        return;
      }

      setStyleToElement(node, style);
    } else if (!debug) {
      // but rule should not have both style and debug properties
      throw new Error(`No style declaration in rule for selector: '${selector}'`);
    }
  }
};
/**
 * Reverts style for the affected object.
 *
 * @param affectedElement Affected element.
 */

const revertStyle = affectedElement => {
  if (affectedElement.protectionObserver) {
    affectedElement.protectionObserver.disconnect();
  }

  affectedElement.node.style.cssText = affectedElement.originalStyle;
};

/**
 * ExtMutationObserver is a wrapper over regular MutationObserver with one additional function:
 * it keeps track of the number of times we called the "ProtectionCallback".
 *
 * We use an instance of this to monitor styles added by ExtendedCss
 * and to make sure these styles are recovered if the page script attempts to modify them.
 *
 * However, we want to avoid endless loops of modification if the page script repeatedly modifies the styles.
 * So we keep track of the number of calls and observe() makes a decision
 * whether to continue recovering the styles or not.
 */

class ExtMutationObserver {
  /**
   * Extra property for keeping 'style fix counts'.
   */

  /**
   * Creates new ExtMutationObserver.
   *
   * @param protectionCallback Callback which execution should be counted.
   */
  constructor(protectionCallback) {
    this.styleProtectionCount = 0;
    this.observer = new natives.MutationObserver(mutations => {
      if (!mutations.length) {
        return;
      }

      this.styleProtectionCount += 1;
      protectionCallback(mutations, this);
    });
  }
  /**
   * Starts to observe target element,
   * prevents infinite loop of observing due to the limited number of times of callback runs.
   *
   * @param target Target to observe.
   * @param options Mutation observer options.
   */


  observe(target, options) {
    if (this.styleProtectionCount < MAX_STYLE_PROTECTION_COUNT) {
      this.observer.observe(target, options);
    } else {
      logger.error('ExtendedCss: infinite loop protection for style');
    }
  }
  /**
   * Stops ExtMutationObserver from observing any mutations.
   * Until the `observe()` is used again, `protectionCallback` will not be invoked.
   */


  disconnect() {
    this.observer.disconnect();
  }

}

const PROTECTION_OBSERVER_OPTIONS = {
  attributes: true,
  attributeOldValue: true,
  attributeFilter: ['style']
};
/**
 * Creates MutationObserver protection callback.
 *
 * @param styles Styles data object.
 *
 * @returns Callback for styles protection.
 */

const createProtectionCallback = styles => {
  const protectionCallback = (mutations, extObserver) => {
    if (!mutations[0]) {
      return;
    }

    const {
      target
    } = mutations[0];
    extObserver.disconnect();
    styles.forEach(style => {
      setStyleToElement(target, style);
    });
    extObserver.observe(target, PROTECTION_OBSERVER_OPTIONS);
  };

  return protectionCallback;
};
/**
 * Sets up a MutationObserver which protects style attributes from changes.
 *
 * @param node DOM node.
 * @param rules Rule data objects.
 * @returns Mutation observer used to protect attribute or null if there's nothing to protect.
 */


const protectStyleAttribute = (node, rules) => {
  if (!natives.MutationObserver) {
    return null;
  }

  const styles = [];
  rules.forEach(ruleData => {
    const {
      style
    } = ruleData; // some rules might have only debug property in style declaration
    // e.g. 'div:has(> a) { debug: true }' -> parsed to boolean `ruleData.debug`
    // so no style is fine, and here we should collect only valid styles to protect

    if (style) {
      styles.push(style);
    }
  });
  const protectionObserver = new ExtMutationObserver(createProtectionCallback(styles));
  protectionObserver.observe(node, PROTECTION_OBSERVER_OPTIONS);
  return protectionObserver;
};

const STATS_DECIMAL_DIGITS_COUNT = 4;

/**
 * A helper class for applied rule stats.
 */
class TimingStats {
  /**
   * Creates new TimingStats.
   */
  constructor() {
    this.appliesTimings = [];
    this.appliesCount = 0;
    this.timingsSum = 0;
    this.meanTiming = 0;
    this.squaredSum = 0;
    this.standardDeviation = 0;
  }
  /**
   * Observe target element and mark observer as active.
   *
   * @param elapsedTimeMs Time in ms.
   */


  push(elapsedTimeMs) {
    this.appliesTimings.push(elapsedTimeMs);
    this.appliesCount += 1;
    this.timingsSum += elapsedTimeMs;
    this.meanTiming = this.timingsSum / this.appliesCount;
    this.squaredSum += elapsedTimeMs * elapsedTimeMs;
    this.standardDeviation = Math.sqrt(this.squaredSum / this.appliesCount - Math.pow(this.meanTiming, 2));
  }

}

/**
 * Makes the timestamps more readable.
 *
 * @param timestamp Raw timestamp.
 *
 * @returns Fine-looking timestamps.
 */
const beautifyTimingNumber = timestamp => {
  return Number(timestamp.toFixed(STATS_DECIMAL_DIGITS_COUNT));
};
/**
 * Improves timing stats readability.
 *
 * @param rawTimings Collected timings with raw timestamp.
 *
 * @returns Fine-looking timing stats.
 */


const beautifyTimings = rawTimings => {
  return {
    appliesTimings: rawTimings.appliesTimings.map(t => beautifyTimingNumber(t)),
    appliesCount: beautifyTimingNumber(rawTimings.appliesCount),
    timingsSum: beautifyTimingNumber(rawTimings.timingsSum),
    meanTiming: beautifyTimingNumber(rawTimings.meanTiming),
    standardDeviation: beautifyTimingNumber(rawTimings.standardDeviation)
  };
};
/**
 * Prints timing information if debugging mode is enabled.
 *
 * @param context ExtendedCss context.
 */


const printTimingInfo = context => {
  if (context.areTimingsPrinted) {
    return;
  }

  context.areTimingsPrinted = true;
  const timingsLogData = {};
  context.parsedRules.forEach(ruleData => {
    if (ruleData.timingStats) {
      const {
        selector,
        style,
        debug,
        matchedElements
      } = ruleData; // style declaration for some rules is parsed to debug property and no style to apply
      // e.g. 'div:has(> a) { debug: true }'

      if (!style && !debug) {
        throw new Error(`Rule should have style declaration for selector: '${selector}'`);
      }

      const selectorData = {
        selectorParsed: selector,
        timings: beautifyTimings(ruleData.timingStats)
      }; // `ruleData.style` may contain `remove` pseudo-property
      // and make logs look better

      if (style && style[REMOVE_PSEUDO_MARKER] === PSEUDO_PROPERTY_POSITIVE_VALUE) {
        selectorData.removed = true; // no matchedElements for such case as they are removed after ExtendedCss applied
      } else {
        selectorData.styleApplied = style || null;
        selectorData.matchedElements = matchedElements;
      }

      timingsLogData[selector] = selectorData;
    }
  });

  if (Object.keys(timingsLogData).length === 0) {
    return;
  } // add location.href to the message to distinguish frames


  logger.info('[ExtendedCss] Timings in milliseconds for %o:\n%o', window.location.href, timingsLogData);
};

/**
 * Finds affectedElement object for the specified DOM node.
 *
 * @param affElements Array of affected elements — context.affectedElements.
 * @param domNode DOM node.
 * @returns Found affectedElement or undefined.
 */

const findAffectedElement = (affElements, domNode) => {
  return affElements.find(affEl => affEl.node === domNode);
};
/**
 * Applies specified rule and returns list of elements affected.
 *
 * @param context ExtendedCss context.
 * @param ruleData Rule to apply.
 * @returns List of elements affected by the rule.
 */


const applyRule = (context, ruleData) => {
  // debugging mode can be enabled in two ways:
  // 1. for separate rules - by `{ debug: true; }`
  // 2. for all rules simultaneously by:
  //   - `{ debug: global; }` in any rule
  //   - positive `debug` property in ExtCssConfiguration
  const isDebuggingMode = !!ruleData.debug || context.debug;
  let startTime;

  if (isDebuggingMode) {
    startTime = performance.now();
  }

  const {
    ast
  } = ruleData;
  const nodes = []; // selector can be successfully parser into ast with no error
  // but its applying by native Document.querySelectorAll() still may throw an error
  // e.g. 'div[..banner]'

  try {
    nodes.push(...selectElementsByAst(ast));
  } catch (e) {
    // log the error only in debug mode
    if (context.debug) {
      logger.error(getErrorMessage(e));
    }
  }

  nodes.forEach(node => {
    let affectedElement = findAffectedElement(context.affectedElements, node);

    if (affectedElement) {
      affectedElement.rules.push(ruleData);
      applyStyle(context, affectedElement);
    } else {
      // Applying style first time
      const originalStyle = node.style.cssText;
      affectedElement = {
        node,
        // affected DOM node
        rules: [ruleData],
        // rule to be applied
        originalStyle,
        // original node style
        protectionObserver: null // style attribute observer

      };
      applyStyle(context, affectedElement);
      context.affectedElements.push(affectedElement);
    }
  });

  if (isDebuggingMode && startTime) {
    const elapsedTimeMs = performance.now() - startTime;

    if (!ruleData.timingStats) {
      ruleData.timingStats = new TimingStats();
    }

    ruleData.timingStats.push(elapsedTimeMs);
  }

  return nodes;
};
/**
 * Applies filtering rules.
 *
 * @param context ExtendedCss context.
 */


const applyRules = context => {
  const newSelectedElements = []; // some rules could make call - selector.querySelectorAll() temporarily to change node id attribute
  // this caused MutationObserver to call recursively
  // https://github.com/AdguardTeam/ExtendedCss/issues/81

  disconnectDocument(context);
  context.parsedRules.forEach(ruleData => {
    const nodes = applyRule(context, ruleData);
    Array.prototype.push.apply(newSelectedElements, nodes); // save matched elements to ruleData as linked to applied rule
    // only for debugging purposes

    if (ruleData.debug) {
      ruleData.matchedElements = nodes;
    }
  }); // Now revert styles for elements which are no more affected

  let affLength = context.affectedElements.length; // do nothing if there is no elements to process

  while (affLength) {
    const affectedElement = context.affectedElements[affLength - 1];

    if (!affectedElement) {
      break;
    }

    if (!newSelectedElements.includes(affectedElement.node)) {
      // Time to revert style
      revertStyle(affectedElement);
      context.affectedElements.splice(affLength - 1, 1);
    } else if (!affectedElement.removed) {
      // Add style protection observer
      // Protect "style" attribute from changes
      if (!affectedElement.protectionObserver) {
        affectedElement.protectionObserver = protectStyleAttribute(affectedElement.node, affectedElement.rules);
      }
    }

    affLength -= 1;
  } // After styles are applied we can start observe again


  observeDocument(context);
  printTimingInfo(context);
};

/**
 * Result of selector validation.
 */

/**
 * Main class of ExtendedCss lib.
 *
 * Parses css stylesheet with any selectors (passed to its argument as styleSheet),
 * and guarantee its applying as mutation observer is used to prevent the restyling of needed elements by other scripts.
 * This style protection is limited to 50 times to avoid infinite loop (MAX_STYLE_PROTECTION_COUNT).
 * Our own ThrottleWrapper is used for styles applying to avoid too often lib reactions on page mutations.
 *
 * Constructor creates the instance of class which should be run be `apply()` method to apply the rules,
 * and the applying can be stopped by `dispose()`.
 *
 * Can be used to select page elements by selector with `query()` method (similar to `Document.querySelectorAll()`),
 * which does not require instance creating.
 */
class extended_css_esm_ExtendedCss {
  /**
   * Creates new ExtendedCss.
   *
   * @param configuration ExtendedCss configuration.
   */
  constructor(configuration) {
    if (!configuration) {
      throw new Error('ExtendedCss configuration should be provided.');
    }

    this.applyRulesCallbackListener = this.applyRulesCallbackListener.bind(this);
    this.context = {
      beforeStyleApplied: configuration.beforeStyleApplied,
      debug: false,
      affectedElements: [],
      isDomObserved: false,
      removalsStatistic: {},
      parsedRules: [],
      scheduler: new ThrottleWrapper(this.applyRulesCallbackListener)
    }; // TODO: throw an error instead of logging and handle it in related products.

    if (!isBrowserSupported()) {
      logger.error('Browser is not supported by ExtendedCss');
      return;
    } // at least 'styleSheet' or 'cssRules' should be provided


    if (!configuration.styleSheet && !configuration.cssRules) {
      throw new Error("ExtendedCss configuration should have 'styleSheet' or 'cssRules' defined.");
    } // 'styleSheet' and 'cssRules' are optional
    // and both can be provided at the same time
    // so both should be parsed and applied in such case


    if (configuration.styleSheet) {
      // stylesheet parsing can fail on some invalid selectors
      try {
        this.context.parsedRules.push(...parseStylesheet(configuration.styleSheet, extCssDocument));
      } catch (e) {
        // eslint-disable-next-line max-len
        throw new Error(`Pass the rules as configuration.cssRules since configuration.styleSheet cannot be parsed because of: '${getErrorMessage(e)}'`);
      }
    }

    if (configuration.cssRules) {
      this.context.parsedRules.push(...parseRules(configuration.cssRules, extCssDocument));
    } // true if set in configuration
    // or any rule in styleSheet has `debug: global`


    this.context.debug = configuration.debug || this.context.parsedRules.some(ruleData => {
      return ruleData.debug === DEBUG_PSEUDO_PROPERTY_GLOBAL_VALUE;
    });

    if (this.context.beforeStyleApplied && typeof this.context.beforeStyleApplied !== 'function') {
      // eslint-disable-next-line max-len
      throw new Error(`Invalid configuration. Type of 'beforeStyleApplied' should be a function, received: '${typeof this.context.beforeStyleApplied}'`);
    }
  }
  /**
   * Invokes {@link applyRules} function with current app context.
   * 
   * This method is bound to the class instance in the constructor because it is called
   * in {@link ThrottleWrapper} and on the DOMContentLoaded event.
   */


  applyRulesCallbackListener() {
    applyRules(this.context);
  }
  /**
   * Initializes ExtendedCss.
   *
   * Should be executed on page ASAP,
   * otherwise the :contains() pseudo-class may work incorrectly.
   */


  init() {
    /**
     * Native Node textContent getter must be intercepted as soon as possible,
     * and stored as it is needed for proper work of :contains() pseudo-class
     * because DOM Node prototype 'textContent' property may be mocked.
     *
     * @see {@link https://github.com/AdguardTeam/ExtendedCss/issues/127}
     */
    nativeTextContent.setGetter();
  }
  /**
   * Applies stylesheet rules on page.
   */


  apply() {
    applyRules(this.context);

    if (document.readyState !== 'complete') {
      document.addEventListener('DOMContentLoaded', this.applyRulesCallbackListener, false);
    }
  }
  /**
   * Disposes ExtendedCss and removes our styles from matched elements.
   */


  dispose() {
    disconnectDocument(this.context);
    this.context.affectedElements.forEach(el => {
      revertStyle(el);
    });
    document.removeEventListener('DOMContentLoaded', this.applyRulesCallbackListener, false);
  }
  /**
   * Exposed for testing purposes only.
   *
   * @returns Array of AffectedElement data objects.
   */


  getAffectedElements() {
    return this.context.affectedElements;
  }
  /**
   * Returns a list of the document's elements that match the specified selector.
   * Uses ExtCssDocument.querySelectorAll().
   *
   * @param selector Selector text.
   * @param [noTiming=true] If true — do not print the timings to the console.
   *
   * @throws An error if selector is not valid.
   * @returns A list of elements that match the selector.
   */


  static query(selector) {
    let noTiming = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : true;

    if (typeof selector !== 'string') {
      throw new Error('Selector should be defined as a string.');
    }

    const start = performance.now();

    try {
      return extCssDocument.querySelectorAll(selector);
    } finally {
      const end = performance.now();

      if (!noTiming) {
        logger.info(`[ExtendedCss] Elapsed: ${Math.round((end - start) * 1000)} μs.`);
      }
    }
  }
  /**
   * Validates selector.
   *
   * @param inputSelector Selector text to validate.
   *
   * @returns Result of selector validation.
   */


  static validate(inputSelector) {
    try {
      // ExtendedCss in general supports :remove() in selector
      // but ExtendedCss.query() does not support it as it should be parsed by stylesheet parser.
      // so for validation we have to handle selectors with `:remove()` in it
      const {
        selector
      } = parseRemoveSelector(inputSelector);
      extended_css_esm_ExtendedCss.query(selector);
      return {
        ok: true,
        error: null
      };
    } catch (e) {
      // not valid input `selector` should be logged eventually
      const error = `Error: Invalid selector: '${inputSelector}' -- ${getErrorMessage(e)}`;
      return {
        ok: false,
        error
      };
    }
  }

}



;// CONCATENATED MODULE: ./node_modules/@adguard/safari-extension/dist/safari-extension.esm.js
/*
 * SafariExtension v4.1.0 (build date: Tue, 23 Dec 2025 11:36:32 GMT)
 * (c) 2025 Adguard Software Ltd.
 * Released under the GPL-3.0 license
 * https://github.com/AdguardTeam/SafariConverterLib/tree/master/Extension
 */





/* eslint-disable no-console */
/* eslint-disable class-methods-use-this */
/* eslint-disable max-classes-per-file */
/**
 * @file Defines the logger interface and its default implementation.
 */
/**
 * Logging level.
 */
var LoggingLevel;
(function (LoggingLevel) {
  LoggingLevel[LoggingLevel["Debug"] = 2] = "Debug";
  LoggingLevel[LoggingLevel["Info"] = 1] = "Info";
  LoggingLevel[LoggingLevel["Error"] = 0] = "Error";
})(LoggingLevel || (LoggingLevel = {}));
const getTimestamp = () => `[${new Date().toISOString()}]`;
/**
 * Console logger implementation.
 */
class ConsoleLogger {
  prefix = '[Safari Extension]';
  loggingLevel = LoggingLevel.Info;
  /**
   * Creates a new console logger.
   *
   * @param prefix Prefix to add to the log messages.
   * @param level Logging level.
   */
  constructor(prefix, level) {
    this.prefix = prefix;
    this.loggingLevel = level;
  }
  get level() {
    return this.loggingLevel;
  }
  set level(level) {
    this.loggingLevel = level;
  }
  debug(...args) {
    if (this.loggingLevel >= LoggingLevel.Debug) {
      console.debug(getTimestamp(), this.prefix, ...args);
    }
  }
  info(...args) {
    if (this.loggingLevel >= LoggingLevel.Info) {
      console.info(getTimestamp(), this.prefix, ...args);
    }
  }
  error(...args) {
    if (this.loggingLevel >= LoggingLevel.Error) {
      console.error(getTimestamp(), this.prefix, ...args);
    }
  }
}
/**
 * Logger that does not print anything.
 */
class NullLogger {
  level = LoggingLevel.Debug;
  debug() {
    // Do nothing.
  }
  info() {
    // Do nothing.
  }
  error() {
    // Do nothing.
  }
}
/**
 * Default logger. Can be redefined by the library user.
 */
let internalLogger = new NullLogger();
/**
 * Proxy logger that delegates all calls to the internal logger.
 * This internal logger can be redefined by the library user
 * via `setLogger`.
 */
class ProxyLogger {
  get level() {
    return internalLogger.level;
  }
  set level(level) {
    internalLogger.level = level;
  }
  debug(...args) {
    internalLogger.debug(...args);
  }
  info(...args) {
    internalLogger.info(...args);
  }
  error(...args) {
    internalLogger.error(...args);
  }
}
/**
 * Sets the logger to use.
 *
 * @param logger to use.
 */
const setLogger = logger => {
  internalLogger = logger;
};
/**
 * Logger instance that will be used inside the library (and can be actually
 * used outside the library too). It delegates all calls to the internal logger
 * that can be redefined via `setLogger`.
 */
const log = new ProxyLogger();
const safari_extension_esm_version = "4.1.0";

/**
 * @file Contains common constants and helper functions.
 */
/**
 * Name of the engine used to run scriptlets.
 */
const SCRIPTLET_ENGINE_NAME = 'safari-extension';
/**
 * Makes sure that we're dealing with CSS rules (selector + style)
 *
 * @param css Array of CSS selectors (for hiding elements) or full CSS rules.
 * @returns Array of CSS rules.
 */
const toCSSRules = css => {
  return css.map(s => s.trim()).filter(s => s.length > 0).map(s => {
    return s.at(-1) !== '}' ? `${s} {display:none!important;}` : s;
  });
};

/**
 * @file Contains the implementation of the content script.
 */
/**
 * Executes code in the context of the page via new script tag and text content.
 *
 * @param {string} code String of scripts to be executed.
 * @returns {boolean} Returns true if code was executed, otherwise returns false.
 */
const executeScriptsViaTextContent = code => {
  const scriptTag = document.createElement('script');
  scriptTag.setAttribute('type', 'text/javascript');
  scriptTag.textContent = code;
  const parent = document.head || document.documentElement;
  parent.appendChild(scriptTag);
  if (scriptTag.parentNode) {
    scriptTag.parentNode.removeChild(scriptTag);
    return false;
  }
  return true;
};
/**
 * Executes code in the context of page via new script tag and blob. We use
 * this way as a fallback if we fail to inject via textContent.
 *
 * @param {string} code String of scripts to be executed
 * @returns {boolean} Returns true if code was executed, otherwise returns false.
 */
const executeScriptsViaBlob = code => {
  const blob = new Blob([code], {
    type: 'text/javascript'
  });
  const url = URL.createObjectURL(blob);
  const scriptTag = document.createElement('script');
  scriptTag.src = url;
  const parent = document.head || document.documentElement;
  parent.appendChild(scriptTag);
  URL.revokeObjectURL(url);
  if (scriptTag.parentNode) {
    scriptTag.parentNode.removeChild(scriptTag);
    return false;
  }
  return true;
};
/**
 * Execute scripts in a page context and cleanup itself when execution
 * completes.
 *
 * @param {string[]} scripts Array of scripts to execute.
 */
const executeScripts = (scripts = []) => {
  scripts.unshift('( function () { try {');
  // we use this script detect if the script was applied,
  // if the script tag was removed, then it means that code was applied, otherwise no
  scripts.push(';document.currentScript.remove();');
  scripts.push("} catch (ex) { console.error('Error executing AG js: ' + ex); } })();");
  const code = scripts.join('\r\n');
  if (!executeScriptsViaTextContent(code)) {
    if (!executeScriptsViaBlob(code)) {
      log.error('Failed to execute scripts');
    }
  }
};
/**
 * Protects specified style element from changes to the current document
 * Add a mutation observer, which is adds our rules again if it was removed
 *
 * @param {HTMLElement} protectStyleEl protected style element.
 */
const protectStyleElementContent = protectStyleEl => {
  const {
    MutationObserver
  } = window;
  if (!MutationObserver) {
    return;
  }
  // Observer, which observe protectStyleEl inner changes, without deleting
  // styleEl.
  const innerObserver = new MutationObserver(mutations => {
    for (let i = 0; i < mutations.length; i += 1) {
      const m = mutations[i];
      if (protectStyleEl.hasAttribute('mod') && protectStyleEl.getAttribute('mod') === 'inner') {
        protectStyleEl.removeAttribute('mod');
        break;
      }
      protectStyleEl.setAttribute('mod', 'inner');
      let isProtectStyleElModified = false;
      // There are two mutually exclusive situations:
      //
      // 1. There were changes to the inner text of protectStyleEl.
      // 2. The whole "text" element of protectStyleEl was removed.
      if (m.removedNodes.length > 0) {
        for (let j = 0; j < m.removedNodes.length; j += 1) {
          isProtectStyleElModified = true;
          protectStyleEl.appendChild(m.removedNodes[j]);
        }
      } else if (m.oldValue) {
        isProtectStyleElModified = true;
        // eslint-disable-next-line no-param-reassign
        protectStyleEl.textContent = m.oldValue;
      }
      if (!isProtectStyleElModified) {
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
 * Converts scriptlet to the code that can be executed.
 *
 * @param {Scriptlet} scriptlet Scriptlet data (name and arguments)
 * @param {boolean} verbose Whether to log verbose output
 * @returns {string} Scriptlet code
 */
const getScriptletCode = (scriptlet, verbose) => {
  try {
    const scriptletSource = {
      engine: SCRIPTLET_ENGINE_NAME,
      name: scriptlet.name,
      args: scriptlet.args,
      version: safari_extension_esm_version,
      verbose
    };
    return scriptlets.invoke(scriptletSource);
  } catch (e) {
    log.error('Failed to get scriptlet code', scriptlet.name, e);
  }
  return '';
};
// Disable class-methods-use-this rule for the following code since it needs
// to implement particular interface.
/* eslint-disable class-methods-use-this  */
/**
 * Content script object. The way this object is used is different and
 * depends on whether this code is used from Safari App Extension or from
 * Safari Web Extension.
 *
 * In the case of Safari App Extension, this object is used from within
 * the content script, i.e. it is used to apply the configuration to the web
 * page.
 *
 * In the case of Safari Web Extension, `BackgroundScript` relies on the
 * functions of this object to run scripts and insert extended CSS into the
 * web page, i.e. it expects that there will be a global `adguard.contentScript`
 * object in the `ISOLATED` world that implements this interface.
 */
class ContentScript {
  /**
   * Applies the configuration to the web page. This method is supposed to be
   * run from the extension's content script (ISOLATED world) and it is only
   * supposed to be used by Safari App Extension.
   *
   * @param configuration Configuration to apply.
   * @param verbose Whether to log verbose output.
   */
  applyConfiguration(configuration, verbose = false) {
    this.insertCss(configuration.css);
    this.insertExtendedCss(configuration.extendedCss);
    this.runScriptlets(configuration.scriptlets, verbose);
    this.runScripts(configuration.js);
  }
  /**
   * Inserts specified CSS rules to the page.
   *
   * @param css Array of CSS rules to apply. Can be a selector
   */
  insertCss(css) {
    if (!css || !css.length) {
      return;
    }
    try {
      const styleElement = document.createElement('style');
      styleElement.setAttribute('type', 'text/css');
      (document.head || document.documentElement).appendChild(styleElement);
      if (styleElement.sheet) {
        const cssRules = toCSSRules(css);
        for (const style of cssRules) {
          styleElement.sheet.insertRule(style);
        }
      }
      protectStyleElementContent(styleElement);
    } catch (e) {
      log.error('Failed to insert CSS', e);
    }
  }
  /**
   * Applies Extended Css stylesheet.
   *
   * @param {string[]} extendedCss Array with ExtendedCss rules.
   */
  insertExtendedCss(extendedCss) {
    if (!extendedCss || !extendedCss.length) {
      return;
    }
    try {
      const cssRules = toCSSRules(extendedCss);
      const extCss = new ExtendedCss({
        cssRules
      });
      extCss.apply();
    } catch (e) {
      log.error('Failed to insert extended CSS', e);
    }
  }
  /**
   * Runs scripts in the web page. This method is supposed to be run from the
   * extension's content script (ISOLATED world).
   *
   * In the case of Safari Web Extension this method is exposed via
   * `adguard.contentScript` global object in `ISOLATED` world.
   *
   * @param scripts Array of scripts to run.
   */
  runScripts(scripts) {
    if (!scripts || scripts.length === 0) {
      return;
    }
    executeScripts(scripts);
  }
  /**
   * Runs scriptlets in the web page. This method is supposed to be run from
   * the extension's content script (ISOLATED world).
   *
   * In the case of Safari Web Extension this method is exposed via
   * `adguard.contentScript` global object in `ISOLATED` world.
   *
   * @param scriptlets Array of scriptlets to run.
   * @param verbose Whether to log verbose output.
   */
  runScriptlets(scriptlets, verbose) {
    if (!scriptlets || !scriptlets.length) {
      return;
    }
    const getCode = scriptlet => getScriptletCode(scriptlet, verbose);
    const scripts = scriptlets.map(getCode);
    executeScripts(scripts);
  }
}
/* eslint-enable class-methods-use-this */

/**
 * @file Exports `BackgroundScript` object that it supposed to be used by
 * web extension's background script.
 */
/**
 * `BackgroundScript` is a class that is used by web extension's background
 * script to apply the configuration to the web page. It uses
 * `browser.scripting` API to inject scripts and CSS into the web page.
 *
 * It's important that for correct work this class relies on the presence of
 * `adguard.contentScript` object in the `ISOLATED` world that implements
 * `ContentScript` interface.
 */
class BackgroundScript {
  /**
   * Map of registered script functions.
   */
  registeredScripts;
  /**
   * Creates an instance of the `BackgroundScript` object.
   *
   * The constructor accepts a map of registered functions. The idea is that
   * we would like JS rules to work in the same way as scriptlets, i.e. use
   * `browser.scripting.executeScript` with `world: 'MAIN'` In order to do
   * that we need to deal with JS functions. Unfortunately, due to security
   * limitations we cannot create `Function` objects from script text inside
   * the extension. To overcome that we can prepare a map of script texts and
   * functions. This map should be constructed in compile time and then
   * passed to the constructor. Whenever the script rule is applied, we will
   * first check if there's a registered `Function` object for the script
   * text and if there is, it will be used to execute the script. Otherwise,
   * we will attempt to execute it as a string (but the website CSP may
   * prevent that).
   *
   * @param registeredScripts Map of registered script functions.
   */
  constructor(registeredScripts = new Map()) {
    this.registeredScripts = registeredScripts;
    // Make sure that the default registered script is always added to the
    // map. This is a default registered script that is used on
    // testcases.agrd.dev for CSP tests.
    this.registeredScripts.set('console.log(Date.now(), "default registered script")', () => {
      // eslint-disable-next-line no-console
      console.log(Date.now(), 'default registered script');
    });
  }
  /**
   * Applies the configuration to the given tab and frame.
   *
   * @param tabId ID of the tab to apply the configuration to.
   * @param frameId ID of the frame to apply the configuration to.
   * @param configuration Configuration to apply.
   * @returns Promise that resolves when the configuration is applied.
   */
  async applyConfiguration(tabId, frameId, configuration) {
    log.debug('Applying configuration to tab', tabId, 'frame', frameId, 'configuration', configuration);
    await Promise.all([BackgroundScript.insertCss(tabId, frameId, configuration.css), BackgroundScript.insertExtendedCss(tabId, frameId, configuration.extendedCss), BackgroundScript.runScriptlets(tabId, frameId, configuration.scriptlets), BackgroundScript.runScripts(tabId, frameId, configuration.js, this.registeredScripts)]);
    log.debug('Finished applying configuration to tab', tabId, 'frame', frameId);
  }
  /**
   * Wrapper over `browser.scripting.scriptInjection` that logs errors.
   *
   * @param scriptInjection Script injection to execute.
   */
  static async executeScript(scriptInjection) {
    const results = await browser.scripting.executeScript(scriptInjection);
    if (results.length === 0) {
      log.error('Failed to execute script in target', scriptInjection.target);
      return;
    }
    const result = results[0];
    if (result.error) {
      log.error('Failed to execute script in target', scriptInjection.target, 'error', result.error);
    }
  }
  /**
   * Runs scripts in the given tab and frame.
   *
   * @param tabId ID of the tab to run the scripts in.
   * @param frameId ID of the frame to run the scripts in.
   * @param scripts Scripts to run.
   * @param registeredScripts Map of registered script functions.
   * @returns Promise that resolves when the scripts are run.
   */
  static async runScripts(tabId, frameId, scripts, registeredScripts) {
    if (scripts.length === 0) {
      log.debug('No scripts to run in tab', tabId, 'frame', frameId);
      return;
    }
    // Scan scripts for registered functions.
    const scriptFunctions = [];
    const scriptTexts = [];
    for (const script of scripts) {
      const scriptFunction = registeredScripts.get(script);
      if (scriptFunction) {
        scriptFunctions.push(scriptFunction);
      } else {
        scriptTexts.push(script);
      }
    }
    log.debug('Found', scriptFunctions.length, 'registered functions and', scriptTexts.length, 'scripts to run in tab', tabId, 'frame', frameId);
    await Promise.all([BackgroundScript.runScriptFunctions(tabId, frameId, scriptFunctions), BackgroundScript.runScriptTexts(tabId, frameId, scriptTexts)]);
    log.debug('Finished running scripts in tab', tabId, 'frame', frameId);
  }
  /**
   * Runs script functions in the given tab and frame.
   *
   * @param tabId ID of the tab to run the scripts in.
   * @param frameId ID of the frame to run the scripts in.
   * @param scriptFunctions Scripts to run.
   * @returns Promise that resolves when the scripts are run.
   */
  static async runScriptFunctions(tabId, frameId, scriptFunctions) {
    if (scriptFunctions.length === 0) {
      log.debug('No script functions to run in tab', tabId, 'frame', frameId);
      return;
    }
    log.debug('Running script functions in tab', tabId, 'frame', frameId, 'script functions', scriptFunctions);
    const promises = scriptFunctions.map(scriptFunction => {
      return BackgroundScript.runScriptFunction(tabId, frameId, scriptFunction);
    });
    await Promise.all(promises);
    log.debug('Finished running script functions in tab', tabId, 'frame', frameId);
  }
  /**
   * Runs a script in the given tab and frame.
   *
   * @param tabId ID of the tab to run the script in.
   * @param frameId ID of the frame to run the script in.
   * @param scriptFunction Script to run.
   * @returns Promise that resolves when the script is run.
   */
  static async runScriptFunction(tabId, frameId, scriptFunction) {
    log.debug('Running script function in tab', tabId, 'frame', frameId, 'script function', scriptFunction);
    await BackgroundScript.executeScript({
      target: {
        tabId,
        frameIds: [frameId]
      },
      func: scriptFunction,
      world: 'MAIN',
      injectImmediately: true
    });
    log.debug('Finished running script function in tab', tabId, 'frame', frameId);
  }
  /**
   * Runs script texts in the given tab and frame.
   *
   * @param tabId ID of the tab to run the script texts in.
   * @param frameId ID of the frame to run the script texts in.
   * @param scriptTexts Script texts to run.
   * @returns Promise that resolves when the script texts are run.
   */
  static async runScriptTexts(tabId, frameId, scriptTexts) {
    if (scriptTexts.length === 0) {
      log.debug('No script texts to run in tab', tabId, 'frame', frameId);
      return;
    }
    log.debug('Running script texts in tab', tabId, 'frame', frameId, 'script texts', scriptTexts);
    await BackgroundScript.executeScript({
      target: {
        tabId,
        frameIds: [frameId]
      },
      func: (scripts = []) => {
        try {
          adguard.contentScript.runScripts(scripts);
        } catch (e) {
          // eslint-disable-next-line no-console
          console.error('Failed to run scripts, make sure adguard.contentScript is available', e);
        }
      },
      args: [scriptTexts],
      world: 'ISOLATED',
      injectImmediately: true
    });
    log.debug('Finished running script texts in tab', tabId, 'frame', frameId);
  }
  /**
   * Inserts extended CSS into the given tab and frame.
   *
   * @param tabId ID of the tab to insert extended CSS into.
   * @param frameId ID of the frame to insert extended CSS into.
   * @param extendedCss Extended CSS to insert.
   * @returns Promise that resolves when the extended CSS is inserted.
   */
  static async insertExtendedCss(tabId, frameId, extendedCss) {
    if (extendedCss.length === 0) {
      log.debug('No extended CSS to insert into tab', tabId, 'frame', frameId);
      return;
    }
    await BackgroundScript.executeScript({
      target: {
        tabId,
        frameIds: [frameId]
      },
      func: (extCss = []) => {
        try {
          adguard.contentScript.insertExtendedCss(extCss);
        } catch (e) {
          // eslint-disable-next-line no-console
          console.error('Failed to insert extended CSS, make sure adguard.contentScript is available', e);
        }
      },
      args: [extendedCss],
      world: 'ISOLATED',
      injectImmediately: true
    });
  }
  /**
   * Inserts CSS into the given tab and frame.
   *
   * @param tabId ID of the tab to insert CSS into.
   * @param frameId ID of the frame to insert CSS into.
   * @param css CSS to insert.
   * @returns Promise that resolves when the CSS is inserted.
   */
  static async insertCss(tabId, frameId, css) {
    if (css.length === 0) {
      log.debug('No CSS to insert into tab', tabId, 'frame', frameId);
      return;
    }
    log.debug('Inserting CSS into tab', tabId, 'frame', frameId, 'css', css);
    const cssRules = toCSSRules(css);
    const cssStyle = cssRules.join('\n');
    await browser.scripting.insertCSS({
      target: {
        tabId,
        frameIds: [frameId]
      },
      origin: 'USER',
      css: cssStyle
    });
    log.debug('CSS inserted into tab', tabId, 'frame', frameId);
  }
  /**
   * Runs scriptlets in the given tab and frame.
   *
   * @param tabId ID of the tab to run the scriptlets in.
   * @param frameId ID of the frame to run the scriptlets in.
   * @param scriptlets Scriptlets to run.
   * @returns Promise that resolves when the scriptlets are run.
   */
  static async runScriptlets(tabId, frameId, scriptlets) {
    if (scriptlets.length === 0) {
      log.debug('No scriptlets to run into tab', tabId, 'frame', frameId);
      return;
    }
    log.debug('Running scriptlets in the tab', tabId, 'frame', frameId, 'scriptlets', scriptlets);
    const promises = scriptlets.map(scriptlet => BackgroundScript.runScriptlet(tabId, frameId, scriptlet));
    await Promise.all(promises);
    log.debug('Finished running scriptlets in the tab', tabId, 'frame', frameId);
  }
  /**
   * Runs a scriptlet in the given tab and frame.
   *
   * @param tabId ID of the tab to run the scriptlet in.
   * @param frameId ID of the frame to run the scriptlet in.
   * @param scriptlet Scriptlet to run.
   * @returns Promise that resolves when the scriptlet is run.
   */
  static async runScriptlet(tabId, frameId, scriptlet) {
    log.debug('Running scriptlet', scriptlet.name, 'in the tab', tabId, 'frame', frameId);
    const scriptletFunction = scriptlets.getScriptletFunction(scriptlet.name);
    if (!scriptletFunction) {
      log.error('Scriptlet function not found', scriptlet.name);
      return;
    }
    // Use verbose logging in scriptlets when debug-level logging is
    // enabled.
    const verbose = log.level === LoggingLevel.Debug;
    const scriptletSource = {
      engine: SCRIPTLET_ENGINE_NAME,
      name: scriptlet.name,
      args: scriptlet.args,
      version: safari_extension_esm_version,
      verbose
    };
    const args = [];
    args.push(scriptletSource);
    args.push(scriptlet.args);
    await BackgroundScript.executeScript({
      target: {
        tabId,
        frameIds: [frameId]
      },
      func: scriptletFunction,
      args,
      world: 'MAIN',
      injectImmediately: true
    });
    log.debug('Finished running scriptlet', scriptlet.name, 'in the tab', tabId, 'frame', frameId);
  }
}

/**
 * @file Handles delaying and dispatching of DOMContentLoaded and load events.
 */
/**
 * The interceptors delay the events until either a response is received or the
 * timeout expires. If the events have already fired, no interceptors are added.
 *
 * In Safari extensions running scripts and scriptlets has a slight delay and
 * the page scripts may already do their work. By delaying DOMContentLoaded and
 * load we try to delay the execution of page scripts so that the extension's
 * scriptlets work as expected.
 *
 * @param timeoutMs - Timeout in milliseconds after which the events are forced
 *                  (if not already handled). Default is 1000ms.
 * @returns A function which, when invoked, cancels the timeout and dispatches
 *         (or removes) the interceptors.
 */
function setupDelayedEventDispatcher(timeoutMs = 1000) {
  const interceptors = [];
  const events = [{
    name: 'DOMContentLoaded',
    options: {
      bubbles: true,
      cancelable: false
    },
    target: document
  }, {
    name: 'load',
    options: {
      bubbles: false,
      cancelable: false
    },
    target: window
  }];
  events.forEach(ev => {
    const interceptor = {
      name: ev.name,
      options: ev.options,
      intercepted: false,
      target: ev.target,
      listener: event => {
        // Prevent immediate propagation.
        event.stopImmediatePropagation();
        interceptor.intercepted = true;
        log.debug('Event has been intercepted:', ev.name);
      }
    };
    interceptors.push(interceptor);
    interceptor.target.addEventListener(ev.name, interceptor.listener, {
      capture: true
    });
  });
  let dispatched = false;
  const dispatchEvents = trigger => {
    if (dispatched) {
      // The events were already dispatched, do nothing.
      return;
    }
    dispatched = true;
    interceptors.forEach(interceptor => {
      // Remove the interceptor listener.
      interceptor.target.removeEventListener(interceptor.name, interceptor.listener, {
        capture: true
      });
      if (interceptor.intercepted) {
        // If intercepted, dispatch the event manually so downstream listeners eventually receive it.
        const newEvent = new Event(interceptor.name, interceptor.options);
        interceptor.target.dispatchEvent(newEvent);
        const targetName = interceptor.target === document ? 'document' : 'window';
        log.debug(`${interceptor.name} event re-dispatched due to ${trigger} on ${targetName}.`);
      } else {
        log.debug(`Interceptor for ${interceptor.name} removed due to ${trigger}.`);
      }
    });
  };
  // Set a timer to automatically dispatch the events after the timeout.
  const timer = setTimeout(() => {
    dispatchEvents('timeout');
  }, timeoutMs);
  // Return a function to cancel the timer and dispatch events immediately.
  return () => {
    clearTimeout(timer);
    dispatchEvents('response received');
  };
}

//# sourceMappingURL=safari-extension.esm.js.map

;// CONCATENATED MODULE: ./src/pages/common/log.ts




/* eslint-disable class-methods-use-this,no-console */
// Configure debug-level logging. If you need to debug the content script,
// set verbose to true.
 // TODO: add enum for levels 'INFO', 'DEBUG', 'ERROR'

/**
 * Redefine if you need it
*/

var DEFAULT_LEVEL = 'INFO';
var CONSOLE_METHODS = {
  LOG: 'log',
  INFO: 'info',
  ERROR: 'error'
};
var LEVELS = {
  ERROR: 1,
  INFO: 2,
  DEBUG: 3
};
/**
 * Simple logger with log levels
 */

var Log = /*#__PURE__*/function () {
  function Log() {
    _classCallCheck(this, Log);

    this.currentLevel = DEFAULT_LEVEL;
  }

  _createClass(Log, [{
    key: "errorToString",
    value:
    /**
     * Pretty-print javascript error
     */
    function errorToString(error) {
      return "".concat(error.toString(), "\nStack trace:\n").concat(error.stack);
    }
    /**
     * Formats date to local time string
     * @param date
     */

  }, {
    key: "getLocalTimeString",
    value: function getLocalTimeString(date) {
      var ONE_MINUTE_MS = 60 * 1000;
      var timeZoneOffsetMs = date.getTimezoneOffset() * ONE_MINUTE_MS;
      var localTime = new Date(date.getTime() - timeZoneOffsetMs);
      return localTime.toISOString().replace('Z', '');
    }
    /**
     * Sets logging level `DEBUG`.
     */

  }, {
    key: "setLevelDebug",
    value: function setLevelDebug() {
      this.currentLevel = 'DEBUG';
    }
    /**
     * Prints log message
     */

  }, {
    key: "print",
    value: function print(level, method, args) {
      var _this = this;

      // check log level
      if (LEVELS[this.currentLevel] < LEVELS[level]) {
        return;
      }

      if (!args || args.length === 0 || !args[0]) {
        return;
      }

      var formatted = args.map(function (arg) {
        if (typeof arg !== 'undefined') {
          var value = arg;

          if (value instanceof Error) {
            value = _this.errorToString(value);
          } else if (value && value.message) {
            value = value.message;
          } else if (_typeof(value) === 'object') {
            value = JSON.stringify(value, null, 4);
          }

          return value;
        }

        return arg;
      }).join(' ');
      var timestamp = "[".concat(new Date().toISOString(), "]");
      console[method](timestamp, formatted);
    }
  }, {
    key: "debug",
    value: function debug() {
      for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
        args[_key] = arguments[_key];
      }

      this.print('DEBUG', 'log', args);
    }
  }, {
    key: "info",
    value: function info() {
      for (var _len2 = arguments.length, args = new Array(_len2), _key2 = 0; _key2 < _len2; _key2++) {
        args[_key2] = arguments[_key2];
      }

      this.print('INFO', 'info', args);
    }
  }, {
    key: "error",
    value: function error() {
      for (var _len3 = arguments.length, args = new Array(_len3), _key3 = 0; _key3 < _len3; _key3++) {
        args[_key3] = arguments[_key3];
      }

      this.print('ERROR', 'error', args);
    }
  }]);

  return Log;
}();

var log_log = new Log(); // Configure logging in @adguard/safari-extension

setLogger({
  debug: function debug() {
    for (var _len4 = arguments.length, args = new Array(_len4), _key4 = 0; _key4 < _len4; _key4++) {
      args[_key4] = arguments[_key4];
    }

    return log_log.debug(args);
  },
  info: function info() {
    for (var _len5 = arguments.length, args = new Array(_len5), _key5 = 0; _key5 < _len5; _key5++) {
      args[_key5] = arguments[_key5];
    }

    return log_log.info(args);
  },
  error: function error() {
    for (var _len6 = arguments.length, args = new Array(_len6), _key6 = 0; _key6 < _len6; _key6++) {
      args[_key6] = arguments[_key6];
    }

    return log_log.error(args);
  },

  get level() {
    return log_log.currentLevel === 'DEBUG' ? LoggingLevel.Debug : LoggingLevel.Info;
  },

  set level(_) {// Do nothing
  }

});
;// CONCATENATED MODULE: ./src/pages/content/assistant/index.ts






var initAssistant = function initAssistant() {
  // @ts-ignore
  if (__webpack_require__.g.assistantStarted) {
    return;
  }

  if (window.top !== window || !(document.documentElement instanceof HTMLElement)) {
    return;
  }

  var assistant; // save right-clicked element for assistant

  var clickedEl;
  document.addEventListener('mousedown', function (event) {
    if (event.button === 2) {
      clickedEl = event.target;
    }
  });
  browser_polyfill_default().runtime.onMessage.addListener(function (message) {
    var data = message.data,
        type = message.type;

    switch (type) {
      case MessagesToContentScript.InitAssistant:
        {
          var addRuleCallbackName = data.addRuleCallbackName,
              selectElement = data.selectElement;
          var selectedElement = null;

          if (clickedEl && selectElement) {
            selectedElement = clickedEl;
          }

          if (!assistant) {
            assistant = (0,dist_assistant.adguardAssistant)();
          } else {
            assistant.close();
          }

          assistant.start(selectedElement, /*#__PURE__*/function () {
            var _ref = _asyncToGenerator( /*#__PURE__*/regenerator_default().mark(function _callee(rules) {
              return regenerator_default().wrap(function _callee$(_context) {
                while (1) switch (_context.prev = _context.next) {
                  case 0:
                    _context.prev = 0;
                    _context.next = 3;
                    return browser_polyfill_default().runtime.sendMessage({
                      type: addRuleCallbackName,
                      data: {
                        ruleText: rules
                      }
                    });

                  case 3:
                    _context.next = 8;
                    break;

                  case 5:
                    _context.prev = 5;
                    _context.t0 = _context["catch"](0);
                    log_log.error(_context.t0);

                  case 8:
                  case "end":
                    return _context.stop();
                }
              }, _callee, null, [[0, 5]]);
            }));

            return function (_x) {
              return _ref.apply(this, arguments);
            };
          }());
          break;
        }

      default:
        break;
    }
  }); // do not start assistant twice
  // @ts-ignore

  __webpack_require__.g.assistantStarted = true;
};
var assistant = {
  init: initAssistant
};
;// CONCATENATED MODULE: ./src/targets/assistant/index.ts

assistant.init();
})();

/******/ })()
;