/******/ (() => { // webpackBootstrap
/******/ 	var __webpack_modules__ = ({

/***/ "./node_modules/@adguard/extended-css/dist/extended-css.umd.js":
/*!*********************************************************************!*\
  !*** ./node_modules/@adguard/extended-css/dist/extended-css.umd.js ***!
  \*********************************************************************/
/***/ (function(__unused_webpack_module, exports) {

/*! @adguard/extended-css - v2.0.10 - Tue Nov 15 2022
* https://github.com/AdguardTeam/ExtendedCss#homepage
* Copyright (c) 2022 AdGuard. Licensed GPL-3.0
*/
(function (global, factory) {
     true ? factory(exports) :
    0;
})(this, (function (exports) { 'use strict';

    const LEFT_SQUARE_BRACKET = '[';
    const RIGHT_SQUARE_BRACKET = ']';
    const LEFT_PARENTHESIS = '(';
    const RIGHT_PARENTHESIS = ')';
    const LEFT_CURLY_BRACKET = '{';
    const RIGHT_CURLY_BRACKET = '}';
    const BRACKETS = {
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
    const SUPPORTED_SELECTOR_MARKS = [LEFT_SQUARE_BRACKET, RIGHT_SQUARE_BRACKET, LEFT_PARENTHESIS, RIGHT_PARENTHESIS, LEFT_CURLY_BRACKET, RIGHT_CURLY_BRACKET, SLASH, BACKSLASH, SEMICOLON, COLON, COMMA, SINGLE_QUOTE, DOUBLE_QUOTE, CARET, DOLLAR_SIGN, ASTERISK, ID_MARKER, CLASS_MARKER, DESCENDANT_COMBINATOR, CHILD_COMBINATOR, NEXT_SIBLING_COMBINATOR, SUBSEQUENT_SIBLING_COMBINATOR, TAB, CARRIAGE_RETURN, LINE_FEED, FORM_FEED]; // absolute:

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
    const IF_PSEUDO_CLASS_MARKER = 'if';
    const ABP_HAS_PSEUDO_CLASS_MARKER = '-abp-has';
    const HAS_PSEUDO_CLASS_MARKERS = [HAS_PSEUDO_CLASS_MARKER, IF_PSEUDO_CLASS_MARKER, ABP_HAS_PSEUDO_CLASS_MARKER];
    const IF_NOT_PSEUDO_CLASS_MARKER = 'if-not';
    const IS_PSEUDO_CLASS_MARKER = 'is';
    const NOT_PSEUDO_CLASS_MARKER = 'not';
    const ABSOLUTE_PSEUDO_CLASSES = [CONTAINS_PSEUDO, HAS_TEXT_PSEUDO, ABP_CONTAINS_PSEUDO, MATCHES_CSS_PSEUDO, MATCHES_CSS_BEFORE_PSEUDO, MATCHES_CSS_AFTER_PSEUDO, MATCHES_ATTR_PSEUDO_CLASS_MARKER, MATCHES_PROPERTY_PSEUDO_CLASS_MARKER, XPATH_PSEUDO_CLASS_MARKER, NTH_ANCESTOR_PSEUDO_CLASS_MARKER, UPWARD_PSEUDO_CLASS_MARKER];
    const RELATIVE_PSEUDO_CLASSES = [...HAS_PSEUDO_CLASS_MARKERS, IF_NOT_PSEUDO_CLASS_MARKER, IS_PSEUDO_CLASS_MARKER, NOT_PSEUDO_CLASS_MARKER];
    const SUPPORTED_PSEUDO_CLASSES = [...ABSOLUTE_PSEUDO_CLASSES, ...RELATIVE_PSEUDO_CLASSES];
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
    };
    const PSEUDO_PROPERTY_POSITIVE_VALUE = 'true';
    const DEBUG_PSEUDO_PROPERTY_GLOBAL_VALUE = 'global';
    const STYLESHEET_ERROR_PREFIX = {
      NO_STYLE: 'No style declaration at stylesheet part',
      NO_SELECTOR: 'Selector should be defined before style declaration in stylesheet',
      INVALID_STYLE: 'Invalid style declaration at stylesheet part',
      UNCLOSED_STYLE: 'Unclosed style declaration at stylesheet part',
      NO_PROPERTY: 'Missing style property in declaration at stylesheet part',
      NO_VALUE: 'Missing style value in declaration at stylesheet part',
      NO_STYLE_OR_REMOVE: 'Invalid stylesheet - no style declared or :remove() pseudo-class used',
      NO_COMMENT: 'Comments in stylesheet are not supported'
    };
    const REMOVE_ERROR_PREFIX = {
      INVALID_REMOVE: 'Invalid :remove() pseudo-class in selector',
      NO_TARGET_SELECTOR: 'Selector should be specified before :remove() pseudo-class',
      MULTIPLE_USAGE: 'Pseudo-class :remove() appears more than once in selector',
      INVALID_POSITION: 'Pseudo-class :remove() should be at the end of selector'
    };
    const MATCHING_ELEMENT_ERROR_PREFIX = 'Error while matching element';
    const MAX_STYLE_PROTECTION_COUNT = 50;

    /**
     * Gets string without suffix.
     *
     * @param str Input string.
     * @param suffix Needed to remove.
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

    var BrowserName;

    (function (BrowserName) {
      BrowserName["Chrome"] = "Chrome";
      BrowserName["Firefox"] = "Firefox";
      BrowserName["Edge"] = "Edg";
      BrowserName["Opera"] = "Opera";
      BrowserName["Safari"] = "Safari";
    })(BrowserName || (BrowserName = {}));

    const CHROMIUM_BRAND_NAME = 'Chromium';
    const GOOGLE_CHROME_BRAND_NAME = 'Google Chrome';
    /**
     * Simple check for Safari browser.
     */

    const isSafariBrowser = navigator.vendor === 'Apple Computer, Inc.';
    const SUPPORTED_BROWSERS_DATA = {
      [BrowserName.Chrome]: {
        // avoid Chromium-based Edge browser
        MASK: /\s(Chrome)\/(\d+)\..+\s(?!.*Edg\/)/,
        MIN_VERSION: 55
      },
      [BrowserName.Firefox]: {
        MASK: /\s(Firefox)\/(\d+)\./,
        MIN_VERSION: 52
      },
      [BrowserName.Edge]: {
        MASK: /\s(Edg)\/(\d+)\./,
        MIN_VERSION: 80
      },
      [BrowserName.Opera]: {
        MASK: /\s(OPR)\/(\d+)\./,
        MIN_VERSION: 80
      },
      [BrowserName.Safari]: {
        MASK: /\sVersion\/(\d{2}\.\d)(.+\s|\s)(Safari)\//,
        MIN_VERSION: 11.1
      }
    };
    /**
     * Returns chromium brand object from navigator.userAgentData.brands or null if not supported.
     * Chromium because of all browsers based on it should be supported as well
     * and it is universal way to check it.
     *
     * @see {@link https://developer.mozilla.org/en-US/docs/Web/API/NavigatorUAData/brands}
     */

    const getChromiumBrand = () => {
      var _navigator$userAgentD;

      const brandsData = (_navigator$userAgentD = navigator.userAgentData) === null || _navigator$userAgentD === void 0 ? void 0 : _navigator$userAgentD.brands;

      if (!brandsData) {
        return null;
      } // for chromium-based browsers


      const chromiumBrand = brandsData.find(brandData => {
        return brandData.brand === CHROMIUM_BRAND_NAME || brandData.brand === GOOGLE_CHROME_BRAND_NAME;
      });
      return chromiumBrand || null;
    };

    /**
     * Parses userAgent string and returns the data object for supported browsers;
     * otherwise returns null.
     */
    const parseUserAgent = () => {
      let browserName;
      let currentVersion;
      const browserNames = Object.values(BrowserName);

      for (let i = 0; i < browserNames.length; i += 1) {
        const match = SUPPORTED_BROWSERS_DATA[browserNames[i]].MASK.exec(navigator.userAgent);

        if (match) {
          // for safari browser the order is different because of regexp
          if (match[3] === browserNames[i]) {
            browserName = match[3];
            currentVersion = Number(match[1]);
          } else {
            // for others first is name and second is version
            browserName = match[1];
            currentVersion = Number(match[2]);
          }

          return {
            browserName,
            currentVersion
          };
        }
      }

      return null;
    };
    /**
     * Gets info about current browser.
     */


    const getCurrentBrowserInfoAsSupported = () => {
      const brandData = getChromiumBrand();

      if (!brandData) {
        const uaInfo = parseUserAgent();

        if (!uaInfo) {
          return null;
        }

        const browserName = uaInfo.browserName,
              currentVersion = uaInfo.currentVersion;
        return {
          browserName,
          currentVersion
        };
      } // if navigator.userAgentData is supported


      const brand = brandData.brand,
            version = brandData.version; // handle chromium-based browsers

      const browserName = brand === CHROMIUM_BRAND_NAME || brand === GOOGLE_CHROME_BRAND_NAME ? BrowserName.Chrome : brand;
      return {
        browserName,
        currentVersion: Number(version)
      };
    };
    /**
     * Checks whether the current browser is supported.
     */


    const isBrowserSupported = () => {
      const ua = navigator.userAgent; // do not support Internet Explorer

      if (ua.includes('MSIE') || ua.includes('Trident/')) {
        return false;
      } // for local testing purposes


      if (ua.includes('jsdom')) {
        return true;
      }

      const currentBrowserData = getCurrentBrowserInfoAsSupported();

      if (!currentBrowserData) {
        return false;
      }

      const browserName = currentBrowserData.browserName,
            currentVersion = currentBrowserData.currentVersion;
      return currentVersion >= SUPPORTED_BROWSERS_DATA[browserName].MIN_VERSION;
    };

    const natives = {
      MutationObserver: window.MutationObserver || window.WebKitMutationObserver
    };
    /**
     * As soon as possible stores native Node textContent getter to be used for contains pseudo-class
     * because elements' 'textContent' and 'innerText' properties might be mocked.
     *
     * @see {@link https://github.com/AdguardTeam/ExtendedCss/issues/127}
     */

    const nodeTextContentGetter = (() => {
      var _Object$getOwnPropert;

      const nativeNode = window.Node || Node;
      return (_Object$getOwnPropert = Object.getOwnPropertyDescriptor(nativeNode.prototype, 'textContent')) === null || _Object$getOwnPropert === void 0 ? void 0 : _Object$getOwnPropert.get;
    })();

    /**
     * Returns textContent of passed domElement.
     *
     * @param domElement DOM element.
     */

    const getNodeTextContent = domElement => {
      return (nodeTextContentGetter === null || nodeTextContentGetter === void 0 ? void 0 : nodeTextContentGetter.apply(domElement)) || '';
    };
    /**
     * Returns element selector text based on it's tagName and attributes.
     *
     * @param element DOM element.
     */

    const getElementSelectorDesc = element => {
      let selectorText = element.tagName.toLowerCase();
      selectorText += Array.from(element.attributes).map(attr => {
        return "[".concat(attr.name, "=\"").concat(element.getAttribute(attr.name), "\"]");
      }).join('');
      return selectorText;
    };
    /**
     * Returns path to a DOM element as a selector string.
     *
     * @param inputEl Input element.
     *
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
          selector += "#".concat(el.id);
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
          selector += ":nth-of-type(".concat(nth, ")");
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
     */

    const isHtmlElement = element => {
      return element instanceof HTMLElement;
    };

    var CssProperty;

    (function (CssProperty) {
      CssProperty["Background"] = "background";
      CssProperty["BackgroundImage"] = "background-image";
      CssProperty["Content"] = "content";
      CssProperty["Opacity"] = "opacity";
    })(CssProperty || (CssProperty = {}));

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
     * @param str Input string.
     */

    const escapeRegExp = str => {
      // https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/regexp
      // should be escaped . * + ? ^ $ { } ( ) | [ ] / \
      // except of * | ^
      const specials = ['.', '+', '?', '$', '{', '}', '(', ')', '[', ']', '\\', '/'];
      const specialsRegex = new RegExp("[".concat(specials.join('\\'), "]"), 'g');
      return str.replace(specialsRegex, '\\$&');
    };
    /**
     * Converts :matches-css() arg property value match to regexp.
     *
     * @param rawValue Style match value pattern.
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
     */


    const normalizePropertyValue = (propertyName, propertyValue) => {
      let normalized = '';

      switch (propertyName) {
        case CssProperty.Background:
        case CssProperty.BackgroundImage:
          // sometimes url property does not have quotes
          // so we add them for consistent matching
          normalized = addUrlPropertyQuotes(propertyValue);
          break;

        case CssProperty.Content:
          normalized = removeContentQuotes(propertyValue);
          break;

        case CssProperty.Opacity:
          // https://bugs.webkit.org/show_bug.cgi?id=93445
          normalized = isSafariBrowser ? (Math.round(parseFloat(propertyValue) * 100) / 100).toString() : propertyValue;
          break;

        default:
          normalized = propertyValue;
      }

      return normalized;
    };
    /**
     * Gets domElement style property value
     * by css property name and standard pseudo-element.
     *
     * @param domElement DOM element.
     * @param propertyName CSS property name.
     * @param regularPseudoElement Standard pseudo-element — :before, :after etc.
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
     * @throws An error on invalid `rawArg`.
     */
    const parseStyleMatchArg = (pseudoName, rawArg) => {
      const _getPseudoArgData = getPseudoArgData(rawArg, COMMA),
            name = _getPseudoArgData.name,
            value = _getPseudoArgData.value;

      let regularPseudoElement = name;
      let styleMatchArg = value; // check whether the string part before the separator is valid regular pseudo-element,
      // otherwise `regularPseudoElement` is null, and `styleMatchArg` is rawArg

      if (!Object.values(REGULAR_PSEUDO_ELEMENTS).includes(name)) {
        regularPseudoElement = null;
        styleMatchArg = rawArg;
      }

      if (!styleMatchArg) {
        throw new Error("Required style property argument part is missing in :".concat(pseudoName, "() arg: '").concat(rawArg, "'"));
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
     * @throws An error on invalid pseudo-class arg.
     */


    const isStyleMatched = argsData => {
      const pseudoName = argsData.pseudoName,
            pseudoArg = argsData.pseudoArg,
            domElement = argsData.domElement;

      const _parseStyleMatchArg = parseStyleMatchArg(pseudoName, pseudoArg),
            regularPseudoElement = _parseStyleMatchArg.regularPseudoElement,
            styleMatchArg = _parseStyleMatchArg.styleMatchArg;

      const _getPseudoArgData2 = getPseudoArgData(styleMatchArg, COLON),
            matchName = _getPseudoArgData2.name,
            matchValue = _getPseudoArgData2.value;

      if (!matchName || !matchValue) {
        throw new Error("Required property name or value is missing in :".concat(pseudoName, "() arg: '").concat(styleMatchArg, "'"));
      }

      let valueRegexp;

      try {
        valueRegexp = convertStyleMatchValueToRegexp(matchValue);
      } catch (e) {
        logger.error(e);
        throw new Error("Invalid argument of :".concat(pseudoName, "() pseudo-class: '").concat(styleMatchArg, "'"));
      }

      const value = getComputedStylePropertyValue(domElement, matchName, regularPseudoElement);
      return valueRegexp && valueRegexp.test(value);
    };
    /**
     * Validates string arg for :matches-attr() and :matches-property().
     *
     * @param arg Pseudo-class arg.
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
     * Returns valid arg for :matches-attr and :matcher-property.
     *
     * @param rawArg Arg pattern.
     * @param [isWildcardAllowed=false] Flag for wildcard (`*`) using as pseudo-class arg.
     *
     * @throws An error on invalid `rawArg`.
     */


    const getValidMatcherArg = function getValidMatcherArg(rawArg) {
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
          throw new Error("Invalid regexp: '".concat(rawArg, "'"));
        }
      } else if (rawArg.includes(ASTERISK)) {
        if (rawArg === ASTERISK && !isWildcardAllowed) {
          // e.g. :matches-attr(*)
          throw new Error("Argument should be more specific than ".concat(rawArg));
        }

        arg = replaceAll(rawArg, ASTERISK, REGEXP_ANY_SYMBOL);
        arg = new RegExp(arg);
      } else {
        if (!validateStrMatcherArg(rawArg)) {
          throw new Error("Invalid argument: '".concat(rawArg, "'"));
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
     * @throws An error if attribute name is missing in pseudo-class arg.
     */
    const getRawMatchingData = (pseudoName, pseudoArg) => {
      const _getPseudoArgData3 = getPseudoArgData(pseudoArg, EQUAL_SIGN),
            rawName = _getPseudoArgData3.name,
            rawValue = _getPseudoArgData3.value;

      if (!rawName) {
        throw new Error("Required attribute name is missing in :".concat(pseudoName, " arg: ").concat(pseudoArg));
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
     * @throws An error on invalid arg of pseudo-class.
     */

    const isAttributeMatched = argsData => {
      const pseudoName = argsData.pseudoName,
            pseudoArg = argsData.pseudoArg,
            domElement = argsData.domElement;
      const elementAttributes = domElement.attributes; // no match if dom element has no attributes

      if (elementAttributes.length === 0) {
        return false;
      }

      const _getRawMatchingData = getRawMatchingData(pseudoName, pseudoArg),
            rawAttrName = _getRawMatchingData.rawName,
            rawAttrValue = _getRawMatchingData.rawValue;

      let attrNameMatch;

      try {
        attrNameMatch = getValidMatcherArg(rawAttrName);
      } catch (e) {
        // eslint-disable-line @typescript-eslint/no-explicit-any
        logger.error(e);
        throw new SyntaxError(e.message);
      }

      let isMatched = false;
      let i = 0;

      while (i < elementAttributes.length && !isMatched) {
        const attr = elementAttributes[i];
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
            // eslint-disable-line @typescript-eslint/no-explicit-any
            logger.error(e);
            throw new SyntaxError(e.message);
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
        const chunk = chainChunks[i];

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

          patternBuffer += ".".concat(chunk);
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
        throw new Error("Invalid regexp property pattern '".concat(input, "'"));
      }

      const chainMatchPatterns = chainPatterns.map(pattern => {
        if (pattern.length === 0) {
          // e.g. '.prop.id' or 'nested..test'
          throw new Error("Empty pattern '".concat(pattern, "' is invalid in chain '").concat(input, "'"));
        }

        let validPattern;

        try {
          validPattern = getValidMatcherArg(pattern, true);
        } catch (e) {
          logger.error(e);
          throw new Error("Invalid property pattern '".concat(pattern, "' in property chain '").concat(input, "'"));
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
     */
    const filterRootsByRegexpChain = function filterRootsByRegexpChain(base, chain) {
      let output = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : [];
      const tempProp = chain[0];

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
     * @throws An error on invalid prop in chain.
     */


    const isPropertyMatched = argsData => {
      const pseudoName = argsData.pseudoName,
            pseudoArg = argsData.pseudoArg,
            domElement = argsData.domElement;

      const _getRawMatchingData2 = getRawMatchingData(pseudoName, pseudoArg),
            rawPropertyName = _getRawMatchingData2.rawName,
            rawPropertyValue = _getRawMatchingData2.rawValue; // chained property name can not include '/' or '.'
      // so regex prop names with such escaped characters are invalid


      if (rawPropertyName.includes('\\/') || rawPropertyName.includes('\\.')) {
        throw new Error("Invalid :".concat(pseudoName, " name pattern: ").concat(rawPropertyName));
      }

      let propChainMatches;

      try {
        propChainMatches = parseRawPropChain(rawPropertyName);
      } catch (e) {
        // eslint-disable-line @typescript-eslint/no-explicit-any
        logger.error(e);
        throw new SyntaxError(e.message);
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
          // eslint-disable-line @typescript-eslint/no-explicit-any
          logger.error(e);
          throw new SyntaxError(e.message);
        }

        if (propValueMatch) {
          for (let i = 0; i < ownerObjArr.length; i += 1) {
            const realValue = ownerObjArr[i].value;

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
     * @throws An error on invalid arg of pseudo-class.
     */

    const isTextMatched = argsData => {
      const pseudoName = argsData.pseudoName,
            pseudoArg = argsData.pseudoArg,
            domElement = argsData.domElement;
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
          throw new Error("Invalid argument of :".concat(pseudoName, "() pseudo-class: ").concat(pseudoArg));
        }

        isTextContentMatched = regex.test(textContent);
      } else {
        // none-regexp arg
        pseudoArgToMatch = pseudoArgToMatch.replace(/\\([\\()[\]"])/g, '$1');
        isTextContentMatched = textContent.includes(pseudoArgToMatch);
      }

      return isTextContentMatched;
    };

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

    let NodeType;
    /**
     * Universal interface for all node types.
     */

    (function (NodeType) {
      NodeType["SelectorList"] = "SelectorList";
      NodeType["Selector"] = "Selector";
      NodeType["RegularSelector"] = "RegularSelector";
      NodeType["ExtendedSelector"] = "ExtendedSelector";
      NodeType["AbsolutePseudoClass"] = "AbsolutePseudoClass";
      NodeType["RelativePseudoClass"] = "RelativePseudoClass";
    })(NodeType || (NodeType = {}));

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
        super(NodeType.RegularSelector);
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
        super(NodeType.RelativePseudoClass);
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
        super(NodeType.AbsolutePseudoClass);

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
     */

    const evaluateMatch = (match, name, quoteChar, rawValue) => {
      // Unescape quotes
      const re = new RegExp("([^\\\\]|^)\\\\".concat(quoteChar), 'g');
      const value = rawValue.replace(re, "$1".concat(quoteChar));
      return ":".concat(name, "(").concat(value, ")");
    }; // ':scope' pseudo may be at start of :has() argument
    // but ExtCssDocument.querySelectorAll() already use it for selecting exact element descendants


    const reScope = /\(:scope >/g;
    const SCOPE_REPLACER = '(>';
    const MATCHES_CSS_PSEUDO_ELEMENT_REGEXP = /(:matches-css)-(before|after)\(/g;

    const convertMatchesCss = (match, extendedPseudoClass, regularPseudoElement) => {
      // ':matches-css-before('  -->  ':matches-css(before, '
      // ':matches-css-after('   -->  ':matches-css(after, '
      return "".concat(extendedPseudoClass).concat(BRACKETS.PARENTHESES.LEFT).concat(regularPseudoElement).concat(COMMA);
    };
    /**
     * Handles old syntax and :scope inside :has().
     *
     * @param selector Trimmed selector to normalize.
     *
     * @throws An error on invalid old extended syntax selector.
     */


    const normalize = selector => {
      const normalizedSelector = selector.replace(REGEXP_VALID_OLD_SYNTAX, evaluateMatch).replace(reScope, SCOPE_REPLACER).replace(MATCHES_CSS_PSEUDO_ELEMENT_REGEXP, convertMatchesCss); // validate old syntax after normalizing
      // e.g. '[-ext-matches-css-before=\'content:  /^[A-Z][a-z]'

      if (normalizedSelector.includes(INVALID_OLD_SYNTAX_MARKER)) {
        throw new Error("Invalid extended-css old syntax selector: '".concat(selector, "'"));
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

    let TokenType;

    (function (TokenType) {
      TokenType["Mark"] = "mark";
      TokenType["Word"] = "word";
    })(TokenType || (TokenType = {}));

    /**
     * Splits selector string into tokens.
     *
     * @param rawSelector Raw css selector.
     */
    const tokenize = rawSelector => {
      const selector = convert(rawSelector); // currently processed

      let symbol; // for words collecting while iterating

      let buffer = ''; // result collection

      const tokens = []; // iterate selector chars and collect tokens

      for (let i = 0; i < selector.length; i += 1) {
        symbol = selector[i];

        if (SUPPORTED_SELECTOR_MARKS.includes(symbol)) {
          tokens.push({
            type: TokenType.Mark,
            value: symbol
          });
          continue;
        }

        buffer += symbol;
        const nextSymbol = selector[i + 1]; // string end has been reached if nextSymbol is undefined

        if (!nextSymbol || SUPPORTED_SELECTOR_MARKS.includes(nextSymbol)) {
          tokens.push({
            type: TokenType.Word,
            value: buffer
          });
          buffer = '';
        }
      }

      return tokens;
    };

    /**
     * Some browsers do not support Array.prototype.flat()
     * e.g. Opera 42 which is used for browserstack tests.
     *
     * @see {@link https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/flat}
     *
     * @param input Array needed to be flatten.
     *
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
     * Returns last item from array.
     *
     * @param array Input array.
     */

    const getLast = array => {
      return array[array.length - 1];
    };

    // e.g. ':is(.page, .main) > .banner' or '*:not(span):not(p)'

    const IS_OR_NOT_PSEUDO_SELECTING_ROOT = "html ".concat(ASTERISK); // limit applying of :xpath() pseudo-class to 'any' element
    // https://github.com/AdguardTeam/ExtendedCss/issues/115

    const XPATH_PSEUDO_SELECTING_ROOT = 'body';
    /**
     * Checks whether the passed token is supported extended pseudo-class.
     *
     * @param tokenValue Token value to check.
     */

    const isSupportedExtendedPseudo = tokenValue => SUPPORTED_PSEUDO_CLASSES.includes(tokenValue);
    /**
     * Checks whether next token is a continuation of regular selector being processed.
     *
     * @param nextTokenType Type of token next to current one.
     * @param nextTokenValue Value of token next to current one.
     */


    const doesRegularContinueAfterSpace = (nextTokenType, nextTokenValue) => {
      return COMBINATORS.includes(nextTokenValue) || nextTokenType === TokenType.Word // e.g. '#main *:has(> .ad)'
      || nextTokenValue === ASTERISK || nextTokenValue === ID_MARKER || nextTokenValue === CLASS_MARKER // e.g. 'div :where(.content)'
      || nextTokenValue === COLON // e.g. "div[class*=' ']"
      || nextTokenValue === SINGLE_QUOTE // e.g. 'div[class*=" "]'
      || nextTokenValue === DOUBLE_QUOTE || nextTokenValue === BRACKETS.SQUARE.LEFT;
    };
    /**
     * Limited list of available symbols before slash `/`
     * to check whether it is valid regexp pattern opening.
     */


    const POSSIBLE_MARKS_BEFORE_REGEXP = {
      COMMON: [// e.g. ':matches-attr(/data-/)'
      BRACKETS.PARENTHESES.LEFT, // e.g. `:matches-attr('/data-/')`
      SINGLE_QUOTE, // e.g. ':matches-attr("/data-/")'
      DOUBLE_QUOTE, // e.g. ':matches-attr(check=/data-v-/)'
      EQUAL_SIGN, // e.g. ':matches-property(inner./_test/=null)'
      DOT, // e.g. ':matches-css(height:/20px/)'
      COLON, // ':matches-css-after( content  :   /(\\d+\\s)*me/  )'
      SPACE],
      CONTAINS: [// e.g. ':contains(/text/)'
      BRACKETS.PARENTHESES.LEFT, // e.g. `:contains('/text/')`
      SINGLE_QUOTE, // e.g. ':contains("/text/")'
      DOUBLE_QUOTE]
    };
    /**
     * Checks whether the regexp pattern for pseudo-class arg starts.
     * Needed for `context.isRegexpOpen` flag.
     *
     * @param context Selector parser context.
     * @param prevTokenValue Value of previous token.
     * @param bufferNodeValue Value of bufferNode.
     *
     * @throws An error on invalid regexp pattern.
     */

    const isRegexpOpening = (context, prevTokenValue, bufferNodeValue) => {
      const lastExtendedPseudoClassName = getLast(context.extendedPseudoNamesStack); // for regexp pattens the slash should not be escaped
      // const isRegexpPatternSlash = prevTokenValue !== BACKSLASH;
      // regexp pattern can be set as arg of pseudo-class
      // which means limited list of available symbols before slash `/`;
      // for :contains() pseudo-class regexp pattern should be at the beginning of arg

      if (CONTAINS_PSEUDO_NAMES.includes(lastExtendedPseudoClassName)) {
        return POSSIBLE_MARKS_BEFORE_REGEXP.CONTAINS.includes(prevTokenValue);
      }

      if (prevTokenValue === SLASH && lastExtendedPseudoClassName !== XPATH_PSEUDO_CLASS_MARKER) {
        const rawArgDesc = bufferNodeValue ? "in arg part: '".concat(bufferNodeValue, "'") : 'arg';
        throw new Error("Invalid regexp pattern for :".concat(lastExtendedPseudoClassName, "() pseudo-class ").concat(rawArgDesc));
      } // for other pseudo-classes regexp pattern can be either the whole arg or its part


      return POSSIBLE_MARKS_BEFORE_REGEXP.COMMON.includes(prevTokenValue);
    };
    /**
     * Interface for selector parser context.
     */


    /**
     * Gets the node which is being collected
     * or null if there is no such one.
     *
     * @param context Selector parser context.
     */
    const getBufferNode = context => {
      if (context.pathToBufferNode.length === 0) {
        return null;
      } // buffer node is always the last in the pathToBufferNode stack


      return getLast(context.pathToBufferNode);
    };
    /**
     * Gets last RegularSelector ast node.
     * Needed for parsing of the complex selector with extended pseudo-class inside it.
     *
     * @param context Selector parser context.
     *
     * @throws An error if:
     * - bufferNode is absent;
     * - type of bufferNode is unsupported;
     * - no RegularSelector in bufferNode.
     */


    const getLastRegularSelectorNode = context => {
      const bufferNode = getBufferNode(context);

      if (!bufferNode) {
        throw new Error('No bufferNode found');
      }

      if (bufferNode.type !== NodeType.Selector) {
        throw new Error('Unsupported bufferNode type');
      }

      const selectorRegularChildren = bufferNode.children.filter(node => node.type === NodeType.RegularSelector);

      if (selectorRegularChildren.length === 0) {
        throw new Error('No RegularSelector node found');
      }

      const lastRegularSelectorNode = getLast(selectorRegularChildren);
      context.pathToBufferNode.push(lastRegularSelectorNode);
      return lastRegularSelectorNode;
    };
    /**
     * Updates needed buffer node value while tokens iterating.
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

      const type = bufferNode.type;

      if (type === NodeType.RegularSelector || type === NodeType.AbsolutePseudoClass) {
        bufferNode.value += tokenValue;
      } else {
        throw new Error("".concat(bufferNode.type, " node can not be updated. Only RegularSelector and AbsolutePseudoClass are supported")); // eslint-disable-line max-len
      }
    };
    /**
     * Adds SelectorList node to context.ast at the start of ast collecting.
     *
     * @param context Selector parser context.
     */


    const addSelectorListNode = context => {
      const selectorListNode = new AnySelectorNode(NodeType.SelectorList);
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


    const addAstNodeByType = function addAstNodeByType(context, type) {
      let tokenValue = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : '';
      const bufferNode = getBufferNode(context);

      if (bufferNode === null) {
        throw new Error('No buffer node');
      }

      let node;

      if (type === NodeType.RegularSelector) {
        node = new RegularSelectorNode(tokenValue);
      } else if (type === NodeType.AbsolutePseudoClass) {
        node = new AbsolutePseudoClassNode(tokenValue);
      } else if (type === NodeType.RelativePseudoClass) {
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
      addAstNodeByType(context, NodeType.Selector); // RegularSelector node is always the first child of Selector node

      addAstNodeByType(context, NodeType.RegularSelector, tokenValue);
    };
    /**
     * Inits selector list subtree for relative extended pseudo-classes, e.g. :has(), :not().
     *
     * @param context Selector parser context.
     * @param tokenValue Optional, defaults to `''`, value of inner regular selector.
     */


    const initRelativeSubtree = function initRelativeSubtree(context) {
      let tokenValue = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : '';
      addAstNodeByType(context, NodeType.SelectorList);
      addAstNodeByType(context, NodeType.Selector);
      addAstNodeByType(context, NodeType.RegularSelector, tokenValue);
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
        if (context.pathToBufferNode[i].type === parentType) {
          context.pathToBufferNode = context.pathToBufferNode.slice(0, i + 1);
          break;
        }
      }
    };
    /**
     * Gets needed buffer node updated due to complex selector parsing.
     *
     * @param context Selector parser context.
     *
     * @throws An error if there is no upper SelectorNode is ast.
     */


    const getUpdatedBufferNode = context => {
      upToClosest(context, NodeType.Selector);
      const selectorNode = getBufferNode(context);

      if (!selectorNode) {
        throw new Error('No SelectorNode, impossible to continue selector parsing by ExtendedCss');
      }

      const lastSelectorNodeChild = getLast(selectorNode.children);
      const hasExtended = lastSelectorNodeChild.type === NodeType.ExtendedSelector // parser position might be inside standard pseudo-class brackets which has space
      // e.g. 'div:contains(/а/):nth-child(100n + 2)'
      && context.standardPseudoBracketsStack.length === 0;
      const lastExtendedPseudoName = hasExtended && lastSelectorNodeChild.children[0].name;
      const isLastExtendedNameRelative = lastExtendedPseudoName && RELATIVE_PSEUDO_CLASSES.includes(lastExtendedPseudoName);
      const isLastExtendedNameAbsolute = lastExtendedPseudoName && ABSOLUTE_PSEUDO_CLASSES.includes(lastExtendedPseudoName);
      const hasRelativeExtended = isLastExtendedNameRelative && context.extendedPseudoBracketsStack.length > 0 && context.extendedPseudoBracketsStack.length === context.extendedPseudoNamesStack.length;
      const hasAbsoluteExtended = isLastExtendedNameAbsolute && lastExtendedPseudoName === getLast(context.extendedPseudoNamesStack);
      let newNeededBufferNode = selectorNode;

      if (hasRelativeExtended) {
        // return relative selector node to update later
        context.pathToBufferNode.push(lastSelectorNodeChild);
        newNeededBufferNode = lastSelectorNodeChild.children[0];
      } else if (hasAbsoluteExtended) {
        // return absolute selector node to update later
        context.pathToBufferNode.push(lastSelectorNodeChild);
        newNeededBufferNode = lastSelectorNodeChild.children[0];
      } else if (hasExtended) {
        // return selector node to add new regular selector node later
        newNeededBufferNode = selectorNode;
      } else {
        // otherwise return last regular selector node to update later
        newNeededBufferNode = getLastRegularSelectorNode(context);
      }

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
      if (!isSupportedExtendedPseudo(nextTokenValue.toLowerCase())) {
        if (nextTokenValue.toLowerCase() === REMOVE_PSEUDO_MARKER) {
          // :remove() pseudo-class should be handled before
          // as it is not about element selecting but actions with elements
          // e.g. 'body > div:empty:remove()'
          throw new Error("Selector parser error: invalid :remove() pseudo-class in selector: '".concat(selector, "'")); // eslint-disable-line max-len
        } // if following token is not an extended pseudo
        // the colon should be collected to value of RegularSelector
        // e.g. '.entry_text:nth-child(2)'


        updateBufferNode(context, tokenValue); // check the token after the pseudo and do balance parentheses later
        // only if it is functional pseudo-class (standard with brackets, e.g. ':lang()').
        // no brackets balance needed for such case,
        // parser position is on first colon after the 'div':
        // e.g. 'div:last-child:has(button.privacy-policy__btn)'

        if (nextToNextTokenValue === BRACKETS.PARENTHESES.LEFT // no brackets balance needed for parentheses inside attribute value
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
          throw new Error("Usage of :".concat(nextTokenValue, "() pseudo-class is not allowed inside regular pseudo: '").concat(getLast(context.standardPseudoNamesStack), "'"));
        } else {
          // stop RegularSelector value collecting
          upToClosest(context, NodeType.Selector); // add ExtendedSelector to Selector children

          addAstNodeByType(context, NodeType.ExtendedSelector);
        }
      }
    };
    /**
     * Parses selector into ast for following element selection.
     *
     * @param selector Selector to parse.
     *
     * @throws An error on invalid selector.
     */


    const parse$1 = selector => {
      var _bufferNode, _bufferNode2, _bufferNode3, _bufferNode4, _bufferNode5, _bufferNode6, _bufferNode7, _bufferNode8, _bufferNode9, _bufferNode10, _bufferNode11, _bufferNode12, _bufferNode13, _bufferNode14, _bufferNode15, _bufferNode16, _bufferNode17, _bufferNode18, _bufferNode19, _bufferNode20;

      const tokens = tokenize(selector);
      const context = {
        ast: null,
        pathToBufferNode: [],
        extendedPseudoNamesStack: [],
        extendedPseudoBracketsStack: [],
        standardPseudoNamesStack: [],
        standardPseudoBracketsStack: [],
        isAttributeBracketsOpen: false,
        isRegexpOpen: false
      };
      let i = 0;

      while (i < tokens.length) {
        const token = tokens[i]; // Token to process

        const tokenType = token.type,
              tokenValue = token.value; // needed for SPACE and COLON tokens checking

        const nextToken = tokens[i + 1] || [];
        const nextTokenType = nextToken.type,
              nextTokenValue = nextToken.value; // needed for limitations
        // - :not() and :is() root element
        // - :has() usage
        // - white space before and after pseudo-class name

        const nextToNextToken = tokens[i + 2] || [];
        const nextToNextTokenValue = nextToNextToken.value; // needed for COLON token checking for none-specified regular selector before extended one
        // e.g. 'p, :hover'
        // or   '.banner, :contains(ads)'

        const previousToken = tokens[i - 1] || [];
        const prevTokenType = previousToken.type,
              prevTokenValue = previousToken.value; // needed for proper parsing of regexp pattern arg
        // e.g. ':matches-css(background-image: /^url\(https:\/\/example\.org\//)'

        const previousToPreviousToken = tokens[i - 2] || [];
        const prevToPrevTokenValue = previousToPreviousToken.value;
        let bufferNode = getBufferNode(context);

        switch (tokenType) {
          case TokenType.Word:
            if (bufferNode === null) {
              // there is no buffer node only in one case — no ast collecting has been started
              initAst(context, tokenValue);
            } else if (bufferNode.type === NodeType.SelectorList) {
              // add new selector to selector list
              addAstNodeByType(context, NodeType.Selector);
              addAstNodeByType(context, NodeType.RegularSelector, tokenValue);
            } else if (bufferNode.type === NodeType.RegularSelector) {
              updateBufferNode(context, tokenValue);
            } else if (bufferNode.type === NodeType.ExtendedSelector) {
              // No white space is allowed between the name of extended pseudo-class
              // and its opening parenthesis
              // https://www.w3.org/TR/selectors-4/#pseudo-classes
              // e.g. 'span:contains (text)'
              if (WHITE_SPACE_CHARACTERS.includes(nextTokenValue) && nextToNextTokenValue === BRACKETS.PARENTHESES.LEFT) {
                throw new Error("No white space is allowed before or after extended pseudo-class name in selector: '".concat(selector, "'")); // eslint-disable-line max-len
              } // save pseudo-class name for brackets balance checking


              context.extendedPseudoNamesStack.push(tokenValue.toLowerCase()); // extended pseudo-class name are parsed in lower case
              // as they should be case-insensitive
              // https://www.w3.org/TR/selectors-4/#pseudo-classes

              if (ABSOLUTE_PSEUDO_CLASSES.includes(tokenValue.toLowerCase())) {
                addAstNodeByType(context, NodeType.AbsolutePseudoClass, tokenValue.toLowerCase());
              } else {
                // if it is not absolute pseudo-class, it must be relative one
                // add RelativePseudoClass with tokenValue as pseudo-class name to ExtendedSelector children
                addAstNodeByType(context, NodeType.RelativePseudoClass, tokenValue.toLowerCase());
              }
            } else if (bufferNode.type === NodeType.AbsolutePseudoClass) {
              // collect absolute pseudo-class arg
              updateBufferNode(context, tokenValue);
            } else if (bufferNode.type === NodeType.RelativePseudoClass) {
              initRelativeSubtree(context, tokenValue);
            }

            break;

          case TokenType.Mark:
            switch (tokenValue) {
              case COMMA:
                if (!bufferNode || typeof bufferNode !== 'undefined' && !nextTokenValue) {
                  // consider the selector is invalid if there is no bufferNode yet (e.g. ', a')
                  // or there is nothing after the comma while bufferNode is defined (e.g. 'div, ')
                  throw new Error("'".concat(selector, "' is not a valid selector"));
                } else if (bufferNode.type === NodeType.RegularSelector) {
                  if (context.isAttributeBracketsOpen) {
                    // the comma might be inside element attribute value
                    // e.g. 'div[data-comma="0,1"]'
                    updateBufferNode(context, tokenValue);
                  } else {
                    // new Selector should be collected to upper SelectorList
                    upToClosest(context, NodeType.SelectorList);
                  }
                } else if (bufferNode.type === NodeType.AbsolutePseudoClass) {
                  // the comma inside arg of absolute extended pseudo
                  // e.g. 'div:xpath(//h3[contains(text(),"Share it!")]/..)'
                  updateBufferNode(context, tokenValue);
                } else if (((_bufferNode = bufferNode) === null || _bufferNode === void 0 ? void 0 : _bufferNode.type) === NodeType.Selector) {
                  // new Selector should be collected to upper SelectorList
                  // if parser position is on Selector node
                  upToClosest(context, NodeType.SelectorList);
                }

                break;

              case SPACE:
                // it might be complex selector with extended pseudo-class inside it
                // and the space is between that complex selector and following regular selector
                // parser position is on ` ` before `span` now:
                // e.g. 'div:has(img).banner span'
                // so we need to check whether the new ast node should be added (example above)
                // or previous regular selector node should be updated
                if (((_bufferNode2 = bufferNode) === null || _bufferNode2 === void 0 ? void 0 : _bufferNode2.type) === NodeType.RegularSelector // no need to update the buffer node if attribute value is being parsed
                // e.g. 'div:not([id])[style="position: absolute; z-index: 10000;"]'
                // parser position inside attribute    ↑
                && !context.isAttributeBracketsOpen) {
                  bufferNode = getUpdatedBufferNode(context);
                }

                if (((_bufferNode3 = bufferNode) === null || _bufferNode3 === void 0 ? void 0 : _bufferNode3.type) === NodeType.RegularSelector) {
                  // standard selectors with white space between colon and name of pseudo
                  // are invalid for native document.querySelectorAll() anyway,
                  // so throwing the error here is better
                  // than proper parsing of invalid selector and passing it further.
                  // first of all do not check attributes
                  // e.g. div[style="text-align: center"]
                  if (!context.isAttributeBracketsOpen // check the space after the colon and before the pseudo
                  // e.g. '.block: nth-child(2)
                  && (prevTokenValue === COLON && nextTokenType === TokenType.Word // or after the pseudo and before the opening parenthesis
                  // e.g. '.block:nth-child (2)
                  || prevTokenType === TokenType.Word && nextTokenValue === BRACKETS.PARENTHESES.LEFT)) {
                    throw new Error("'".concat(selector, "' is not a valid selector"));
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

                if (((_bufferNode4 = bufferNode) === null || _bufferNode4 === void 0 ? void 0 : _bufferNode4.type) === NodeType.AbsolutePseudoClass) {
                  // space inside extended pseudo-class arg
                  // e.g. 'span:contains(some text)'
                  updateBufferNode(context, tokenValue);
                }

                if (((_bufferNode5 = bufferNode) === null || _bufferNode5 === void 0 ? void 0 : _bufferNode5.type) === NodeType.RelativePseudoClass) {
                  // init with empty value RegularSelector
                  // as the space is not needed for selector value
                  // e.g. 'p:not( .content )'
                  initRelativeSubtree(context);
                }

                if (((_bufferNode6 = bufferNode) === null || _bufferNode6 === void 0 ? void 0 : _bufferNode6.type) === NodeType.Selector) {
                  // do NOT add RegularSelector if parser position on space BEFORE the comma in selector list
                  // e.g. '.block:has(> img) , .banner)'
                  if (nextTokenValue && doesRegularContinueAfterSpace(nextTokenType, nextTokenValue)) {
                    // regular selector might be after the extended one.
                    // extra space before combinator or selector should not be collected
                    // e.g. '.banner:upward(2) .block'
                    //      '.banner:upward(2) > .block'
                    // so no tokenValue passed to addAnySelectorNode()
                    addAstNodeByType(context, NodeType.RegularSelector);
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
              case BRACKETS.CURLY.LEFT:
              case BRACKETS.CURLY.RIGHT:
              case ASTERISK:
              case ID_MARKER:
              case CLASS_MARKER:
              case BRACKETS.SQUARE.LEFT:
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
                    throw new Error("'".concat(selector, "' is not a valid selector"));
                  }

                  bufferNode = getUpdatedBufferNode(context);
                }

                if (bufferNode === null) {
                  // no ast collecting has been started
                  if (tokenValue === ASTERISK && nextTokenValue === COLON && (nextToNextTokenValue === IS_PSEUDO_CLASS_MARKER || nextToNextTokenValue === NOT_PSEUDO_CLASS_MARKER)) {
                    // limit applying of wildcard :is() and :not() pseudo-class only to html children
                    // as we check element parent for them and there is no parent for html,
                    // e.g. '*:is(.page, .main) > .banner'
                    // or   '*:not(span):not(p)'
                    initAst(context, IS_OR_NOT_PSEUDO_SELECTING_ROOT);
                  } else {
                    // e.g. '.banner > p'
                    // or   '#top > div.ad'
                    // or   '[class][style][attr]'
                    initAst(context, tokenValue);

                    if (tokenValue === BRACKETS.SQUARE.LEFT) {
                      // e.g. '[class^="banner-"]'
                      context.isAttributeBracketsOpen = true;
                    }
                  }
                } else if (bufferNode.type === NodeType.RegularSelector) {
                  // collect the mark to the value of RegularSelector node
                  updateBufferNode(context, tokenValue);

                  if (tokenValue === BRACKETS.SQUARE.LEFT) {
                    // needed for proper handling element attribute value with comma
                    // e.g. 'div[data-comma="0,1"]'
                    context.isAttributeBracketsOpen = true;
                  }
                } else if (bufferNode.type === NodeType.AbsolutePseudoClass) {
                  // collect the mark to the arg of AbsolutePseudoClass node
                  updateBufferNode(context, tokenValue);

                  if (!bufferNode.value) {
                    throw new Error('bufferNode should have value by now');
                  } // 'isRegexpOpen' flag is needed for brackets balancing inside extended pseudo-class arg


                  if (tokenValue === SLASH && context.extendedPseudoNamesStack.length > 0) {
                    if (prevTokenValue === SLASH && prevToPrevTokenValue === BACKSLASH) {
                      // it may be specific url regexp pattern in arg of pseudo-class
                      // e.g. ':matches-css(background-image: /^url\(https:\/\/example\.org\//)'
                      // parser position is on final slash before `)`                        ↑
                      context.isRegexpOpen = false;
                    } else if (prevTokenValue !== BACKSLASH) {
                      if (isRegexpOpening(context, prevTokenValue, bufferNode.value)) {
                        context.isRegexpOpen = !context.isRegexpOpen;
                      } else {
                        // otherwise force `isRegexpOpen` flag to `false`
                        context.isRegexpOpen = false;
                      }
                    }
                  }
                } else if (bufferNode.type === NodeType.RelativePseudoClass) {
                  // add SelectorList to children of RelativePseudoClass node
                  initRelativeSubtree(context, tokenValue);

                  if (tokenValue === BRACKETS.SQUARE.LEFT) {
                    // besides of creating the relative subtree
                    // opening square bracket means start of attribute
                    // e.g. 'div:not([class="content"])'
                    //      'div:not([href*="window.print()"])'
                    context.isAttributeBracketsOpen = true;
                  }
                } else if (bufferNode.type === NodeType.Selector) {
                  // after the extended pseudo closing parentheses
                  // parser position is on Selector node
                  // and regular selector can be after the extended one
                  // e.g. '.banner:upward(2)> .block'
                  // or   '.inner:nth-ancestor(1)~ .banner'
                  if (COMBINATORS.includes(tokenValue)) {
                    addAstNodeByType(context, NodeType.RegularSelector, tokenValue);
                  } else if (!context.isRegexpOpen) {
                    // it might be complex selector with extended pseudo-class inside it.
                    // parser position is on `.` now:
                    // e.g. 'div:has(img).banner'
                    // so we need to get last regular selector node and update its value
                    bufferNode = getLastRegularSelectorNode(context);
                    updateBufferNode(context, tokenValue);

                    if (tokenValue === BRACKETS.SQUARE.LEFT) {
                      // handle attribute in compound selector after extended pseudo-class
                      // e.g. 'div:not(.top)[style="z-index: 10000;"]'
                      // parser position    ↑
                      context.isAttributeBracketsOpen = true;
                    }
                  }
                } else if (bufferNode.type === NodeType.SelectorList) {
                  // add Selector to SelectorList
                  addAstNodeByType(context, NodeType.Selector); // and RegularSelector as it is always the first child of Selector

                  addAstNodeByType(context, NodeType.RegularSelector, tokenValue);

                  if (tokenValue === BRACKETS.SQUARE.LEFT) {
                    // handle simple attribute selector in selector list
                    // e.g. '.banner, [class^="ad-"]'
                    context.isAttributeBracketsOpen = true;
                  }
                }

                break;

              case BRACKETS.SQUARE.RIGHT:
                if (((_bufferNode7 = bufferNode) === null || _bufferNode7 === void 0 ? void 0 : _bufferNode7.type) === NodeType.RegularSelector) {
                  // needed for proper parsing regular selectors after the attributes with comma
                  // e.g. 'div[data-comma="0,1"] > img'
                  // TODO: handle `]` inside attribute value
                  // e.g. '[onclick^="return test.onEvent(arguments[0]||window.event,\'"]'
                  context.isAttributeBracketsOpen = false; // collect the bracket to the value of RegularSelector node

                  updateBufferNode(context, tokenValue);
                }

                if (((_bufferNode8 = bufferNode) === null || _bufferNode8 === void 0 ? void 0 : _bufferNode8.type) === NodeType.AbsolutePseudoClass) {
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
                if (WHITE_SPACE_CHARACTERS.includes(nextTokenValue) && SUPPORTED_PSEUDO_CLASSES.includes(nextToNextTokenValue)) {
                  throw new Error("No white space is allowed before or after extended pseudo-class name in selector: '".concat(selector, "'")); // eslint-disable-line max-len
                }

                if (bufferNode === null) {
                  // no ast collecting has been started
                  if (nextTokenValue === XPATH_PSEUDO_CLASS_MARKER) {
                    // limit applying of "naked" :xpath pseudo-class
                    // https://github.com/AdguardTeam/ExtendedCss/issues/115
                    initAst(context, XPATH_PSEUDO_SELECTING_ROOT);
                  } else if (nextTokenValue === IS_PSEUDO_CLASS_MARKER || nextTokenValue === NOT_PSEUDO_CLASS_MARKER) {
                    // parent element checking is used for extended pseudo-class :is() and :not().
                    // as there is no parentNode for root element (html)
                    // element selection should be limited to it's children.
                    // e.g. ':is(.page, .main) > .banner'
                    // or   ':not(span):not(p)'
                    initAst(context, IS_OR_NOT_PSEUDO_SELECTING_ROOT);
                  } else if (nextTokenValue === UPWARD_PSEUDO_CLASS_MARKER || nextTokenValue === NTH_ANCESTOR_PSEUDO_CLASS_MARKER) {
                    // selector should be specified before :nth-ancestor() or :upward()
                    // e.g. ':nth-ancestor(3)'
                    // or   ':upward(span)'
                    throw new Error("Selector should be specified before :".concat(nextTokenValue, "() pseudo-class")); // eslint-disable-line max-len
                  } else {
                    // make it more obvious if selector starts with pseudo with no tag specified
                    // e.g. ':has(a)' -> '*:has(a)'
                    // or   ':empty'  -> '*:empty'
                    initAst(context, ASTERISK);
                  } // bufferNode should be updated for following checking


                  bufferNode = getBufferNode(context);
                }

                if (!bufferNode) {
                  throw new Error('bufferNode has to be specified by now');
                }

                if (bufferNode.type === NodeType.SelectorList) {
                  // bufferNode is SelectorList after comma has been parsed.
                  // parser position is on colon now:
                  // e.g. 'img,:not(.content)'
                  addAstNodeByType(context, NodeType.Selector); // add empty value RegularSelector anyway as any selector should start with it
                  // and check previous token on the next step

                  addAstNodeByType(context, NodeType.RegularSelector); // bufferNode should be updated for following checking

                  bufferNode = getBufferNode(context);
                }

                if (((_bufferNode9 = bufferNode) === null || _bufferNode9 === void 0 ? void 0 : _bufferNode9.type) === NodeType.RegularSelector) {
                  // it can be extended or standard pseudo
                  // e.g. '#share, :contains(share it)'
                  // or   'div,:hover'
                  // of   'div:has(+:contains(text))'  // position is after '+'
                  if (COMBINATORS.includes(prevTokenValue) || prevTokenValue === COMMA) {
                    // case with colon at the start of string - e.g. ':contains(text)'
                    // is covered by 'bufferNode === null' above at start of COLON checking
                    updateBufferNode(context, ASTERISK);
                  }

                  handleNextTokenOnColon(context, selector, tokenValue, nextTokenValue, nextToNextTokenValue);
                }

                if (((_bufferNode10 = bufferNode) === null || _bufferNode10 === void 0 ? void 0 : _bufferNode10.type) === NodeType.Selector) {
                  // after the extended pseudo closing parentheses
                  // parser position is on Selector node
                  // and there is might be another extended selector.
                  // parser position is on colon before 'upward':
                  // e.g. 'p:contains(PR):upward(2)'
                  if (isSupportedExtendedPseudo(nextTokenValue.toLowerCase())) {
                    // if supported extended pseudo-class is next to colon
                    // add ExtendedSelector to Selector children
                    addAstNodeByType(context, NodeType.ExtendedSelector);
                  } else if (nextTokenValue.toLowerCase() === REMOVE_PSEUDO_MARKER) {
                    // :remove() pseudo-class should be handled before
                    // as it is not about element selecting but actions with elements
                    // e.g. '#banner:upward(2):remove()'
                    throw new Error("Selector parser error: invalid :remove() pseudo-class in selector: '".concat(selector, "'")); // eslint-disable-line max-len
                  } else {
                    // otherwise it is standard pseudo after extended pseudo-class in complex selector
                    // and colon should be collected to value of previous RegularSelector
                    // e.g. 'body *:not(input)::selection'
                    //      'input:matches-css(padding: 10):checked'
                    bufferNode = getLastRegularSelectorNode(context);
                    handleNextTokenOnColon(context, selector, tokenValue, nextTokenType, nextToNextTokenValue); // eslint-disable-line max-len
                  }
                }

                if (((_bufferNode11 = bufferNode) === null || _bufferNode11 === void 0 ? void 0 : _bufferNode11.type) === NodeType.AbsolutePseudoClass) {
                  // :xpath() pseudo-class should be the last of extended pseudo-classes
                  if (bufferNode.name === XPATH_PSEUDO_CLASS_MARKER && SUPPORTED_PSEUDO_CLASSES.includes(nextToken.value) && nextToNextToken.value === BRACKETS.PARENTHESES.LEFT) {
                    throw new Error(":xpath() pseudo-class should be at the end of selector: '".concat(selector, "'")); // eslint-disable-line max-len
                  } // collecting arg for absolute pseudo-class
                  // e.g. 'div:matches-css(width:400px)'


                  updateBufferNode(context, tokenValue);
                }

                if (((_bufferNode12 = bufferNode) === null || _bufferNode12 === void 0 ? void 0 : _bufferNode12.type) === NodeType.RelativePseudoClass) {
                  // make it more obvious if selector starts with pseudo with no tag specified
                  // parser position is on colon inside :has() arg
                  // e.g. 'div:has(:contains(text))'
                  // or   'div:not(:empty)'
                  initRelativeSubtree(context, ASTERISK);

                  if (!isSupportedExtendedPseudo(nextTokenValue.toLowerCase())) {
                    // collect the colon to value of RegularSelector
                    // e.g. 'div:not(:empty)'
                    updateBufferNode(context, tokenValue); // parentheses should be balanced only for functional pseudo-classes
                    // e.g. '.yellow:not(:nth-child(3))'

                    if (nextToNextTokenValue === BRACKETS.PARENTHESES.LEFT) {
                      context.standardPseudoNamesStack.push(nextTokenValue);
                    }
                  } else {
                    // add ExtendedSelector to Selector children
                    // e.g. 'div:has(:contains(text))'
                    upToClosest(context, NodeType.Selector);
                    addAstNodeByType(context, NodeType.ExtendedSelector);
                  }
                }

                break;

              case BRACKETS.PARENTHESES.LEFT:
                // start of pseudo-class arg
                if (((_bufferNode13 = bufferNode) === null || _bufferNode13 === void 0 ? void 0 : _bufferNode13.type) === NodeType.AbsolutePseudoClass) {
                  // no brackets balancing needed inside
                  // 1. :xpath() extended pseudo-class arg
                  // 2. regexp arg for other extended pseudo-classes
                  if (bufferNode.name !== XPATH_PSEUDO_CLASS_MARKER && context.isRegexpOpen) {
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

                if (((_bufferNode14 = bufferNode) === null || _bufferNode14 === void 0 ? void 0 : _bufferNode14.type) === NodeType.RegularSelector) {
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

                if (((_bufferNode15 = bufferNode) === null || _bufferNode15 === void 0 ? void 0 : _bufferNode15.type) === NodeType.RelativePseudoClass) {
                  // save opening bracket for balancing
                  // e.g. 'div:not()'  // position is on `(`
                  context.extendedPseudoBracketsStack.push(tokenValue);
                }

                break;

              case BRACKETS.PARENTHESES.RIGHT:
                if (((_bufferNode16 = bufferNode) === null || _bufferNode16 === void 0 ? void 0 : _bufferNode16.type) === NodeType.AbsolutePseudoClass) {
                  // no brackets balancing needed inside
                  // 1. :xpath() extended pseudo-class arg
                  // 2. regexp arg for other extended pseudo-classes
                  if (bufferNode.name !== XPATH_PSEUDO_CLASS_MARKER && context.isRegexpOpen) {
                    // if closing bracket is part of regexp
                    // simply save it to pseudo-class arg
                    updateBufferNode(context, tokenValue);
                  } else {
                    // remove stacked open parentheses for brackets balance
                    // e.g. 'h3:contains((Ads))'
                    // or   'div:xpath(//h3[contains(text(),"Share it!")]/..)'
                    context.extendedPseudoBracketsStack.pop();

                    if (bufferNode.name !== XPATH_PSEUDO_CLASS_MARKER) {
                      // for all other absolute pseudo-classes except :xpath()
                      // remove stacked name of extended pseudo-class
                      context.extendedPseudoNamesStack.pop();

                      if (context.extendedPseudoBracketsStack.length > context.extendedPseudoNamesStack.length) {
                        // eslint-disable-line max-len
                        // if brackets stack is not empty yet,
                        // save tokenValue to arg of AbsolutePseudoClass
                        // parser position on first closing bracket after 'Ads':
                        // e.g. 'h3:contains((Ads))'
                        updateBufferNode(context, tokenValue);
                      } else if (context.extendedPseudoBracketsStack.length >= 0 && context.extendedPseudoNamesStack.length >= 0) {
                        // assume it is combined extended pseudo-classes
                        // parser position on first closing bracket after 'advert':
                        // e.g. 'div:has(.banner, :contains(advert))'
                        upToClosest(context, NodeType.Selector);
                      }
                    } else {
                      // for :xpath()
                      if (context.extendedPseudoBracketsStack.length < context.extendedPseudoNamesStack.length) {
                        // eslint-disable-line max-len
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

                if (((_bufferNode17 = bufferNode) === null || _bufferNode17 === void 0 ? void 0 : _bufferNode17.type) === NodeType.RegularSelector) {
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
                      throw new Error("Parsing error. Invalid selector: ".concat(selector));
                    } // Disallow :has() after regular pseudo-elements
                    // https://bugs.chromium.org/p/chromium/issues/detail?id=669058#c54 [3]


                    if (Object.values(REGULAR_PSEUDO_ELEMENTS).includes(lastStandardPseudo) // check token which is next to closing parentheses and token after it
                    // parser position is on bracket after 'foo' now:
                    // e.g. '::part(foo):has(.a)'
                    && nextTokenValue === COLON && nextToNextTokenValue && HAS_PSEUDO_CLASS_MARKERS.includes(nextToNextTokenValue)) {
                      // eslint-disable-next-line max-len
                      throw new Error("Usage of :".concat(nextToNextTokenValue, "() pseudo-class is not allowed after any regular pseudo-element: '").concat(lastStandardPseudo, "'"));
                    }
                  } else {
                    // extended pseudo-class was processing.
                    // e.g. 'div:has(h3)'
                    // remove bracket and pseudo name from stacks
                    context.extendedPseudoBracketsStack.pop();
                    context.extendedPseudoNamesStack.pop();
                    upToClosest(context, NodeType.ExtendedSelector); // go to upper selector for possible selector continuation after extended pseudo-class
                    // e.g. 'div:has(h3) > img'

                    upToClosest(context, NodeType.Selector);
                  }
                }

                if (((_bufferNode18 = bufferNode) === null || _bufferNode18 === void 0 ? void 0 : _bufferNode18.type) === NodeType.Selector) {
                  // after inner extended pseudo-class bufferNode is Selector.
                  // parser position is on last bracket now:
                  // e.g. 'div:has(.banner, :contains(ads))'
                  context.extendedPseudoBracketsStack.pop();
                  context.extendedPseudoNamesStack.pop();
                  upToClosest(context, NodeType.ExtendedSelector);
                  upToClosest(context, NodeType.Selector);
                }

                if (((_bufferNode19 = bufferNode) === null || _bufferNode19 === void 0 ? void 0 : _bufferNode19.type) === NodeType.RelativePseudoClass) {
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
                throw new Error("'".concat(selector, "' is not a valid selector"));

              case TAB:
                // allow tab only inside attribute value
                // as there are such valid rules in filter lists
                // e.g. 'div[style^="margin-right: auto;	text-align: left;',
                // parser position                      ↑
                if (((_bufferNode20 = bufferNode) === null || _bufferNode20 === void 0 ? void 0 : _bufferNode20.type) === NodeType.RegularSelector && context.isAttributeBracketsOpen) {
                  updateBufferNode(context, tokenValue);
                } else {
                  // otherwise not valid
                  throw new Error("'".concat(selector, "' is not a valid selector"));
                }

            }

            break;
          // no default statement for Marks as they are limited to SUPPORTED_SELECTOR_MARKS
          // and all other symbol combinations are tokenized as Word
          // so error for invalid Word will be thrown later while element selecting by parsed ast

          default:
            throw new Error("Unknown type of token: '".concat(tokenValue, "'"));
        }

        i += 1;
      }

      if (context.ast === null) {
        throw new Error("'".concat(selector, "' is not a valid selector"));
      }

      if (context.extendedPseudoNamesStack.length > 0 || context.extendedPseudoBracketsStack.length > 0) {
        // eslint-disable-next-line max-len
        throw new Error("Unbalanced brackets for extended pseudo-class: '".concat(getLast(context.extendedPseudoNamesStack), "'"));
      }

      if (context.isAttributeBracketsOpen) {
        throw new Error("Unbalanced attribute brackets is selector: '".concat(selector, "'"));
      }

      return context.ast;
    };

    function _arrayWithHoles(arr) {
      if (Array.isArray(arr)) return arr;
    }

    function _iterableToArrayLimit(arr, i) {
      var _i = arr == null ? null : typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"];

      if (_i == null) return;
      var _arr = [];
      var _n = true;
      var _d = false;

      var _s, _e;

      try {
        for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) {
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

    function _arrayLikeToArray(arr, len) {
      if (len == null || len > arr.length) len = arr.length;

      for (var i = 0, arr2 = new Array(len); i < len; i++) {
        arr2[i] = arr[i];
      }

      return arr2;
    }

    function _unsupportedIterableToArray(o, minLen) {
      if (!o) return;
      if (typeof o === "string") return _arrayLikeToArray(o, minLen);
      var n = Object.prototype.toString.call(o).slice(8, -1);
      if (n === "Object" && o.constructor) n = o.constructor.name;
      if (n === "Map" || n === "Set") return Array.from(o);
      if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen);
    }

    function _nonIterableRest() {
      throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.");
    }

    function _slicedToArray(arr, i) {
      return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest();
    }

    /**
     * Validates number arg for :nth-ancestor() and :upward() pseudo-classes.
     *
     * @param rawArg Raw arg of pseudo-class.
     * @param pseudoName Pseudo-class name.
     *
     * @throws An error on invalid `rawArg`.
     */
    const getValidNumberAncestorArg = (rawArg, pseudoName) => {
      const deep = Number(rawArg);

      if (Number.isNaN(deep) || deep < 1 || deep >= 256) {
        throw new Error("Invalid argument of :".concat(pseudoName, " pseudo-class: '").concat(rawArg, "'"));
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
     * @throws An error on invalid `nth` arg.
     */

    const getNthAncestor = (domElement, nth, pseudoName) => {
      let ancestor = null;
      let i = 0;

      while (i < nth) {
        ancestor = domElement.parentElement;

        if (!ancestor) {
          throw new Error("Argument of :".concat(pseudoName, "() pseudo-class is too big \u2014 '").concat(nth, "', out of DOM elements root.")); // eslint-disable-line max-len
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
     * @throws An error if `callback` fails.
     */
    const matcherWrapper = (callback, argsData, errorMessage) => {
      let isMatched;

      try {
        isMatched = callback(argsData);
      } catch (e) {
        logger.error(e);
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
     */


    const getAbsolutePseudoError = (propDesc, pseudoName, pseudoArg) => {
      return "".concat(MATCHING_ELEMENT_ERROR_PREFIX, " ").concat(propDesc, ", may be invalid :").concat(pseudoName, "() pseudo-class arg: '").concat(pseudoArg, "'"); // eslint-disable-line max-len
    };
    /**
     * Checks whether the domElement is matched by absolute extended pseudo-class argument.
     *
     * @param domElement Page element.
     * @param pseudoName Pseudo-class name.
     * @param pseudoArg Pseudo-class arg.
     *
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
          throw new Error("Unknown absolute pseudo-class :".concat(pseudoName, "()"));
      }

      return matcherWrapper(callback, argsData, errorMessage);
    };
    const findByAbsolutePseudoPseudo = {
      /**
       * Gets list of nth ancestors relative to every dom node from domElements list.
       *
       * @param domElements DOM elements.
       * @param rawPseudoArg Number arg of :nth-ancestor() or :upward() pseudo-class.
       * @param pseudoName Pseudo-class name.
       */
      nthAncestor: (domElements, rawPseudoArg, pseudoName) => {
        const deep = getValidNumberAncestorArg(rawPseudoArg, pseudoName);
        const ancestors = domElements.map(domElement => {
          let ancestor = null;

          try {
            ancestor = getNthAncestor(domElement, deep, pseudoName);
          } catch (e) {
            logger.error(e);
          }

          return ancestor;
        }).filter(isHtmlElement);
        return ancestors;
      },

      /**
       * Gets list of elements by xpath expression, evaluated on every dom node from domElements list.
       *
       * @param domElements DOM elements.
       * @param rawPseudoArg Arg of :xpath() pseudo-class.
       */
      xpath: (domElements, rawPseudoArg) => {
        const foundElements = domElements.map(domElement => {
          const result = [];
          let xpathResult;

          try {
            xpathResult = document.evaluate(rawPseudoArg, domElement, null, window.XPathResult.UNORDERED_NODE_ITERATOR_TYPE, null);
          } catch (e) {
            logger.error(e);
            throw new Error("Invalid argument of :xpath pseudo-class: '".concat(rawPseudoArg, "'"));
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
       * Gets list of closest ancestors relative to every dom node from domElements list.
       *
       * @param domElements DOM elements.
       * @param rawPseudoArg Standard selector arg of :upward() pseudo-class.
       *
       * @throws An error if `rawPseudoArg` is not a valid standard selector.
       */
      upward: (domElements, rawPseudoArg) => {
        if (!validateStandardSelector(rawPseudoArg)) {
          throw new Error("Invalid argument of :upward pseudo-class: '".concat(rawPseudoArg, "'"));
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
     * Calculated selector text which is needed to :has(), :if-not(), :is() and :not() pseudo-classes.
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
     * Checks whether the element has all relative elements specified by pseudo-class arg.
     * Used for :has() and :if-not() pseudo-classes.
     *
     * @param argsData Relative pseudo-class helpers args data.
     */
    const hasRelativesBySelectorList = argsData => {
      const element = argsData.element,
            relativeSelectorList = argsData.relativeSelectorList,
            pseudoName = argsData.pseudoName;
      return relativeSelectorList.children // Array.every() is used here as each Selector node from SelectorList should exist on page
      .every(selector => {
        var _relativeRegularSelec, _relativeRegularSelec2;

        // selectorList.children always starts with regular selector as any selector generally
        const _selector$children = _slicedToArray(selector.children, 1),
              relativeRegularSelector = _selector$children[0];

        if (!relativeRegularSelector) {
          throw new Error("RegularSelector is missing for :".concat(pseudoName, "() pseudo-class"));
        }

        let specifiedSelector = '';
        let rootElement = null;

        if ((_relativeRegularSelec = relativeRegularSelector.value) !== null && _relativeRegularSelec !== void 0 && _relativeRegularSelec.startsWith(NEXT_SIBLING_COMBINATOR) || (_relativeRegularSelec2 = relativeRegularSelector.value) !== null && _relativeRegularSelec2 !== void 0 && _relativeRegularSelec2.startsWith(SUBSEQUENT_SIBLING_COMBINATOR)) {
          /**
           * For matching the element by "element:has(+ next-sibling)" and "element:has(~ sibling)"
           * we check whether the element's parentElement has specific direct child combination,
           * e.g. 'h1:has(+ .share)' -> `h1Node.parentElement.querySelectorAll(':scope > h1 + .share')`.
           *
           * @see {@link https://www.w3.org/TR/selectors-4/#relational}
           */
          rootElement = element.parentElement;
          const elementSelectorText = getElementSelectorDesc(element);
          specifiedSelector = "".concat(SCOPE_CSS_PSEUDO_CLASS).concat(CHILD_COMBINATOR).concat(elementSelectorText).concat(relativeRegularSelector.value); // eslint-disable-line max-len
        } else if (relativeRegularSelector.value === ASTERISK) {
          /**
           * :scope specification is needed for proper descendants selection
           * as native element.querySelectorAll() does not select exact element descendants
           * e.g. 'a:has(> img)' -> `aNode.querySelectorAll(':scope > img')`.
           *
           * For 'any selector' as arg of relative simplicity should be set for all inner elements
           * e.g. 'div:if-not(*)' -> `divNode.querySelectorAll(':scope *')`
           * which means empty div with no child element.
           */
          rootElement = element;
          specifiedSelector = "".concat(SCOPE_CSS_PSEUDO_CLASS).concat(DESCENDANT_COMBINATOR).concat(ASTERISK);
        } else {
          /**
           * As it described above, inner elements should be found using `:scope` pseudo-class
           * e.g. 'a:has(> img)' -> `aNode.querySelectorAll(':scope > img')`
           * OR '.block(div > span)' -> `blockClassNode.querySelectorAll(':scope div > span')`.
           */
          specifiedSelector = "".concat(SCOPE_CSS_PSEUDO_CLASS).concat(DESCENDANT_COMBINATOR).concat(relativeRegularSelector.value); // eslint-disable-line max-len

          rootElement = element;
        }

        if (!rootElement) {
          throw new Error("Selection by :".concat(pseudoName, "() pseudo-class is not possible"));
        }

        let relativeElements;

        try {
          // eslint-disable-next-line @typescript-eslint/no-use-before-define
          relativeElements = getElementsForSelectorNode(selector, rootElement, specifiedSelector);
        } catch (e) {
          logger.error(e); // fail for invalid selector

          throw new Error("Invalid selector for :".concat(pseudoName, "() pseudo-class: '").concat(relativeRegularSelector.value, "'")); // eslint-disable-line max-len
        }

        return relativeElements.length > 0;
      });
    };
    /**
     * Checks whether the element is an any element specified by pseudo-class arg.
     * Used for :is() pseudo-class.
     *
     * @param argsData Relative pseudo-class helpers args data.
     */


    const isAnyElementBySelectorList = argsData => {
      const element = argsData.element,
            relativeSelectorList = argsData.relativeSelectorList,
            pseudoName = argsData.pseudoName;
      return relativeSelectorList.children // Array.some() is used here as any selector from selector list should exist on page
      .some(selector => {
        // selectorList.children always starts with regular selector
        const _selector$children2 = _slicedToArray(selector.children, 1),
              relativeRegularSelector = _selector$children2[0];

        if (!relativeRegularSelector) {
          throw new Error("RegularSelector is missing for :".concat(pseudoName, "() pseudo-class"));
        }
        /**
         * For checking the element by 'div:is(.banner)'
         * we check whether the element's parentElement has any specific direct child.
         */


        const rootElement = element.parentElement;

        if (!rootElement) {
          throw new Error("Selection by :".concat(pseudoName, "() pseudo-class is not possible"));
        }
        /**
         * So we calculate the element "description" by it's tagname and attributes for targeting
         * and use it to specify the selection
         * e.g. `div:is(.banner)` --> `divNode.parentElement.querySelectorAll(':scope > .banner')`.
         */


        const specifiedSelector = "".concat(SCOPE_CSS_PSEUDO_CLASS).concat(CHILD_COMBINATOR).concat(relativeRegularSelector.value); // eslint-disable-line max-len

        let anyElements;

        try {
          // eslint-disable-next-line @typescript-eslint/no-use-before-define
          anyElements = getElementsForSelectorNode(selector, rootElement, specifiedSelector);
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
     */


    const notElementBySelectorList = argsData => {
      const element = argsData.element,
            relativeSelectorList = argsData.relativeSelectorList,
            pseudoName = argsData.pseudoName;
      return relativeSelectorList.children // Array.every() is used here as element should not be selected by any selector from selector list
      .every(selector => {
        // selectorList.children always starts with regular selector
        const _selector$children3 = _slicedToArray(selector.children, 1),
              relativeRegularSelector = _selector$children3[0];

        if (!relativeRegularSelector) {
          throw new Error("RegularSelector is missing for :".concat(pseudoName, "() pseudo-class"));
        }
        /**
         * For checking the element by 'div:not([data="content"])
         * we check whether the element's parentElement has any specific direct child.
         */


        const rootElement = element.parentElement;

        if (!rootElement) {
          throw new Error("Selection by :".concat(pseudoName, "() pseudo-class is not possible"));
        }
        /**
         * So we calculate the element "description" by it's tagname and attributes for targeting
         * and use it to specify the selection
         * e.g. `div:not(.banner)` --> `divNode.parentElement.querySelectorAll(':scope > .banner')`.
         */


        const specifiedSelector = "".concat(SCOPE_CSS_PSEUDO_CLASS).concat(CHILD_COMBINATOR).concat(relativeRegularSelector.value); // eslint-disable-line max-len

        let anyElements;

        try {
          // eslint-disable-next-line @typescript-eslint/no-use-before-define
          anyElements = getElementsForSelectorNode(selector, rootElement, specifiedSelector);
        } catch (e) {
          // fail on invalid selectors for :not()
          logger.error(e);
          throw new Error("Invalid selector for :".concat(pseudoName, "() pseudo-class: '").concat(relativeRegularSelector.value, "'")); // eslint-disable-line max-len
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
     * @throws An error if RegularSelector has no value
     * or RegularSelector.value is invalid selector.
     */


    const getByRegularSelector = (regularSelectorNode, root, specifiedSelector) => {
      if (!regularSelectorNode.value) {
        throw new Error('RegularSelector value should be specified');
      }

      const selectorText = specifiedSelector ? specifiedSelector : regularSelectorNode.value;
      let selectedElements = [];

      try {
        selectedElements = Array.from(root.querySelectorAll(selectorText));
      } catch (e) {
        // eslint-disable-line @typescript-eslint/no-explicit-any
        throw new Error("Error: unable to select by '".concat(selectorText, "' \u2014 ").concat(e.message));
      }

      return selectedElements;
    };
    /**
     * Returns list of dom elements filtered or selected by ExtendedSelector node.
     *
     * @param domElements Array of DOM elements.
     * @param extendedSelectorNode ExtendedSelector node.
     *
     * @throws An error on unknown pseudo-class,
     * absent or invalid arg of extended pseudo-class, etc.
     * @returns Array of DOM elements.
     */

    const getByExtendedSelector = (domElements, extendedSelectorNode) => {
      let foundElements = [];
      const pseudoName = extendedSelectorNode.children[0].name;

      if (!pseudoName) {
        // extended pseudo-classes should have a name
        throw new Error('Extended pseudo-class should have a name');
      }

      if (ABSOLUTE_PSEUDO_CLASSES.includes(pseudoName)) {
        const absolutePseudoArg = extendedSelectorNode.children[0].value;

        if (!absolutePseudoArg) {
          // absolute extended pseudo-classes should have an argument
          throw new Error("Missing arg for :".concat(pseudoName, "() pseudo-class"));
        }

        if (pseudoName === NTH_ANCESTOR_PSEUDO_CLASS_MARKER) {
          // :nth-ancestor()
          foundElements = findByAbsolutePseudoPseudo.nthAncestor(domElements, absolutePseudoArg, pseudoName);
        } else if (pseudoName === XPATH_PSEUDO_CLASS_MARKER) {
          // :xpath()
          try {
            document.createExpression(absolutePseudoArg, null);
          } catch (e) {
            throw new Error("Invalid argument of :".concat(pseudoName, "() pseudo-class: '").concat(absolutePseudoArg, "'"));
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
      } else if (RELATIVE_PSEUDO_CLASSES.includes(pseudoName)) {
        const relativeSelectorNodes = extendedSelectorNode.children[0].children;

        if (relativeSelectorNodes.length === 0) {
          // extended relative pseudo-classes should have an argument as well
          throw new Error("Missing arg for :".concat(pseudoName, "() pseudo-class"));
        }

        const _relativeSelectorNode = _slicedToArray(relativeSelectorNodes, 1),
              relativeSelectorList = _relativeSelectorNode[0];

        let relativePredicate;

        switch (pseudoName) {
          case HAS_PSEUDO_CLASS_MARKER:
          case IF_PSEUDO_CLASS_MARKER:
          case ABP_HAS_PSEUDO_CLASS_MARKER:
            relativePredicate = element => hasRelativesBySelectorList({
              element,
              relativeSelectorList,
              pseudoName
            });

            break;

          case IF_NOT_PSEUDO_CLASS_MARKER:
            relativePredicate = element => !hasRelativesBySelectorList({
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
            throw new Error("Unknown relative pseudo-class: '".concat(pseudoName, "'"));
        }

        foundElements = domElements.filter(relativePredicate);
      } else {
        // extra check is parser missed something
        throw new Error("Unknown extended pseudo-class: '".concat(pseudoName, "'"));
      }

      return foundElements;
    };
    /**
     * Returns list of dom elements which is selected by RegularSelector value.
     *
     * @param domElements Array of DOM elements.
     * @param regularSelectorNode RegularSelector node.
     *
     * @throws An error if RegularSelector has not value.
     * @returns Array of DOM elements.
     */

    const getByFollowingRegularSelector = (domElements, regularSelectorNode) => {
      // array of arrays because of Array.map() later
      let foundElements = [];
      const value = regularSelectorNode.value;

      if (!value) {
        throw new Error('RegularSelector should have a value.');
      }

      if (value.startsWith(CHILD_COMBINATOR)) {
        // e.g. div:has(> img) > .banner
        foundElements = domElements.map(root => {
          const specifiedSelector = "".concat(SCOPE_CSS_PSEUDO_CLASS).concat(value);
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
          const specifiedSelector = "".concat(SCOPE_CSS_PSEUDO_CLASS).concat(CHILD_COMBINATOR).concat(elementSelectorText).concat(value); // eslint-disable-line max-len

          const selected = getByRegularSelector(regularSelectorNode, rootElement, specifiedSelector);
          return selected;
        });
      } else {
        // space-separated regular selector after extended one
        // e.g. div:has(> img) .banner
        foundElements = domElements.map(root => {
          const specifiedSelector = "".concat(SCOPE_CSS_PSEUDO_CLASS).concat(DESCENDANT_COMBINATOR).concat(regularSelectorNode.value); // eslint-disable-line max-len

          return getByRegularSelector(regularSelectorNode, root, specifiedSelector);
        });
      } // foundElements should be flattened
      // as getByRegularSelector() returns elements array, and Array.map() collects them to array


      return flatten(foundElements);
    };
    /**
     * Gets elements nodes for Selector node.
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
     */

    const getElementsForSelectorNode = (selectorNode, root, specifiedSelector) => {
      let selectedElements = [];
      let i = 0;

      while (i < selectorNode.children.length) {
        const selectorNodeChild = selectorNode.children[i];

        if (i === 0) {
          // any selector always starts with regular selector
          selectedElements = getByRegularSelector(selectorNodeChild, root, specifiedSelector);
        } else if (selectorNodeChild.type === NodeType.ExtendedSelector) {
          // filter previously selected elements by next selector nodes
          selectedElements = getByExtendedSelector(selectedElements, selectorNodeChild);
        } else if (selectorNodeChild.type === NodeType.RegularSelector) {
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
     */

    const selectElementsByAst = function selectElementsByAst(ast) {
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
       * Gets ast from cache for given selector.
       *
       * @param selector Standard or extended selector.
       */


      getAstFromCache(selector) {
        const cachedAst = this.astCache.get(selector) || null;
        return cachedAst;
      }
      /**
       * Gets selector ast:
       * - if cached ast exists — returns it;
       * - if no cached ast — saves newly parsed ast to cache and returns it.
       *
       * @param selector Standard or extended selector.
       */


      getSelectorAst(selector) {
        let ast = this.getAstFromCache(selector);

        if (!ast) {
          ast = parse$1(selector);
        }

        this.saveAstToCache(selector, ast);
        return ast;
      }
      /**
       * Selects elements by selector.
       *
       * @param selector Standard or extended selector.
       */


      querySelectorAll(selector) {
        const ast = this.getSelectorAst(selector);
        return selectElementsByAst(ast);
      }

    }
    const extCssDocument = new ExtCssDocument();

    /**
     * Checks the presence of :remove() pseudo-class and validates it while parsing the selector part of css rule.
     *
     * @param rawSelector Selector which may contain :remove() pseudo-class.
     *
     * @throws An error on invalid :remove() position.
     */
    const parseRemoveSelector = rawSelector => {
      /**
       * No error will be thrown on invalid selector as it will be validated later
       * so it's better to explicitly specify 'any' selector for :remove() pseudo-class by '*',
       * e.g. '.banner > *:remove()' instead of '.banner > :remove()'.
       */
      // ':remove()'
      const VALID_REMOVE_MARKER = "".concat(COLON).concat(REMOVE_PSEUDO_MARKER).concat(BRACKETS.PARENTHESES.LEFT).concat(BRACKETS.PARENTHESES.RIGHT); // eslint-disable-line max-len
      // ':remove(' - needed for validation rules like 'div:remove(2)'

      const INVALID_REMOVE_MARKER = "".concat(COLON).concat(REMOVE_PSEUDO_MARKER).concat(BRACKETS.PARENTHESES.LEFT);
      let selector;
      let shouldRemove = false;
      const firstIndex = rawSelector.indexOf(VALID_REMOVE_MARKER);

      if (firstIndex === 0) {
        // e.g. ':remove()'
        throw new Error("".concat(REMOVE_ERROR_PREFIX.NO_TARGET_SELECTOR, ": '").concat(rawSelector, "'"));
      } else if (firstIndex > 0) {
        if (firstIndex !== rawSelector.lastIndexOf(VALID_REMOVE_MARKER)) {
          // rule with more than one :remove() pseudo-class is invalid
          // e.g. '.block:remove() > .banner:remove()'
          throw new Error("".concat(REMOVE_ERROR_PREFIX.MULTIPLE_USAGE, ": '").concat(rawSelector, "'"));
        } else if (firstIndex + VALID_REMOVE_MARKER.length < rawSelector.length) {
          // remove pseudo-class should be last in the rule
          // e.g. '.block:remove():upward(2)'
          throw new Error("".concat(REMOVE_ERROR_PREFIX.INVALID_POSITION, ": '").concat(rawSelector, "'"));
        } else {
          // valid :remove() pseudo-class position
          selector = rawSelector.substring(0, firstIndex);
          shouldRemove = true;
        }
      } else if (rawSelector.includes(INVALID_REMOVE_MARKER)) {
        // it is not valid if ':remove()' is absent in rule but just ':remove(' is present
        // e.g. 'div:remove(0)'
        throw new Error("".concat(REMOVE_ERROR_PREFIX.INVALID_REMOVE, ": '").concat(rawSelector, "'"));
      } else {
        // there is no :remove() pseudo-class is rule
        selector = rawSelector;
      }

      const stylesOfSelector = shouldRemove ? [{
        property: REMOVE_PSEUDO_MARKER,
        value: String(shouldRemove)
      }] : [];
      return {
        selector,
        stylesOfSelector
      };
    };

    /**
     * Converts array of pairs to object.
     * Object.fromEntries() polyfill because it is not supported by old browsers, e.g. Chrome 55.
     *
     * @see {@link https://caniuse.com/?search=Object.fromEntries}
     *
     * @param entries Array of pairs.
     */
    const getObjectFromEntries = entries => {
      const initAcc = {};
      const object = entries.reduce((acc, el) => {
        const key = el[0];
        const value = el[1];
        acc[key] = value;
        return acc;
      }, initAcc);
      return object;
    };

    const DEBUG_PSEUDO_PROPERTY_KEY = 'debug';
    const REGEXP_DECLARATION_END = /[;}]/g;
    const REGEXP_DECLARATION_DIVIDER = /[;:}]/g;
    const REGEXP_NON_WHITESPACE = /\S/g; // ExtendedCss does not support at-rules
    // https://developer.mozilla.org/en-US/docs/Web/CSS/At-rule

    const AT_RULE_MARKER = '@';

    /**
     * Init value for rawRuleData.
     */
    const initRawRuleData = {
      selector: ''
    };
    /**
     * Resets rule data buffer to init value after rule successfully collected.
     *
     * @param context Stylesheet parser context.
     */

    const restoreRuleAcc = context => {
      context.rawRuleData = initRawRuleData;
    };
    /**
     * Parses cropped selector part found before `{` previously.
     *
     * @param context Stylesheet parser context.
     * @param extCssDoc Needed for caching of selector ast.
     *
     * @throws An error on unsupported CSS features, e.g. at-rules.
     */


    const parseSelectorPart = (context, extCssDoc) => {
      let selector = context.selectorBuffer.trim();

      if (selector.startsWith(AT_RULE_MARKER)) {
        throw new Error("At-rules are not supported: '".concat(selector, "'."));
      }

      let removeSelectorData;

      try {
        removeSelectorData = parseRemoveSelector(selector);
      } catch (e) {
        // eslint-disable-line @typescript-eslint/no-explicit-any
        logger.error(e.message);
        throw new Error("".concat(REMOVE_ERROR_PREFIX.INVALID_REMOVE, ": '").concat(selector, "'"));
      }

      if (context.nextIndex === -1) {
        if (selector === removeSelectorData.selector) {
          // rule should have style or pseudo-class :remove()
          throw new Error("".concat(STYLESHEET_ERROR_PREFIX.NO_STYLE_OR_REMOVE, ": '").concat(context.cssToParse, "'")); // eslint-disable-line max-len
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
        // eslint-disable-line @typescript-eslint/no-explicit-any
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
        throw new Error("".concat(STYLESHEET_ERROR_PREFIX.INVALID_STYLE, ": '").concat(context.cssToParse, "'"));
      }

      let matchPos = match.index;
      let matched = match[0];

      if (matched === BRACKETS.CURLY.RIGHT) {
        const declarationChunk = context.cssToParse.slice(context.nextIndex, matchPos);

        if (declarationChunk.trim().length === 0) {
          // empty style declaration
          // e.g. 'div { }'
          if (styles.length === 0) {
            throw new Error("".concat(STYLESHEET_ERROR_PREFIX.NO_STYLE, ": '").concat(context.cssToParse, "'"));
          } // else valid style parsed before it
          // e.g. '{ display: none; }' -- position is after ';'

        } else {
          // closing curly bracket '}' is matched before colon ':'
          // trimmed declarationChunk is not a space, between ';' and '}',
          // e.g. 'visible }' in style '{ display: none; visible }' after part before ';' is parsed
          throw new Error("".concat(STYLESHEET_ERROR_PREFIX.INVALID_STYLE, ": '").concat(context.cssToParse, "'"));
        }

        return matchPos;
      }

      if (matched === COLON) {
        const colonIndex = matchPos; // Expects ";" and "}".

        REGEXP_DECLARATION_END.lastIndex = colonIndex;
        match = REGEXP_DECLARATION_END.exec(context.cssToParse);

        if (match === null) {
          throw new Error("".concat(STYLESHEET_ERROR_PREFIX.UNCLOSED_STYLE, ": '").concat(context.cssToParse, "'"));
        }

        matchPos = match.index;
        matched = match[0]; // Populates the `styleMap` key-value map.

        const property = context.cssToParse.slice(context.nextIndex, colonIndex).trim();

        if (property.length === 0) {
          throw new Error("".concat(STYLESHEET_ERROR_PREFIX.NO_PROPERTY, ": '").concat(context.cssToParse, "'"));
        }

        const value = context.cssToParse.slice(colonIndex + 1, matchPos).trim();

        if (value.length === 0) {
          throw new Error("".concat(STYLESHEET_ERROR_PREFIX.NO_VALUE, ": '").concat(context.cssToParse, "'"));
        }

        styles.push({
          property,
          value
        }); // finish style parsing if '}' is found
        // e.g. '{ display: none }' -- no ';' at the end of declaration

        if (matched === BRACKETS.CURLY.RIGHT) {
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
     * Checks whether the 'remove' property positively set in styles
     * with only one positive value - 'true'.
     *
     * @param styles Array of styles.
     */


    const isRemoveSetInStyles = styles => {
      return styles.some(s => {
        return s.property === REMOVE_PSEUDO_MARKER && s.value === PSEUDO_PROPERTY_POSITIVE_VALUE;
      });
    };
    /**
     * Gets valid 'debug' property value set in styles
     * where possible values are 'true' and 'global'.
     *
     * @param styles Array of styles.
     */


    const getDebugStyleValue = styles => {
      const debugStyle = styles.find(s => {
        return s.property === DEBUG_PSEUDO_PROPERTY_KEY;
      });
      return debugStyle === null || debugStyle === void 0 ? void 0 : debugStyle.value;
    };
    /**
     * Prepares final RuleData.
     *
     * @param selector String selector.
     * @param ast Parsed ast.
     * @param rawStyles Array of previously collected styles which may contain 'remove' and 'debug'.
     */


    const prepareRuleData = (selector, ast, rawStyles) => {
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
      } else {
        // otherwise all styles should be applied.
        // every style property will be unique because of their converting into object
        if (styles.length > 0) {
          const stylesAsEntries = styles.map(style => {
            const property = style.property,
                  value = style.value;
            return [property, value];
          });
          const preparedStyleData = getObjectFromEntries(stylesAsEntries);
          ruleData.style = preparedStyleData;
        }
      }

      return ruleData;
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
      const selector = rawRuleData.selector,
            ast = rawRuleData.ast,
            styles = rawRuleData.styles;

      if (!styles) {
        throw new Error("No style declaration for selector: '".concat(selector, "'"));
      }

      if (!ast) {
        throw new Error("No ast parsed for selector: '".concat(selector, "'"));
      }

      const storedRuleData = rawResults.get(selector);

      if (!storedRuleData) {
        rawResults.set(selector, {
          ast,
          styles
        });
      } else {
        storedRuleData.styles.push(...styles);
      }
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
     * @throws An error on unsupported CSS features, e.g. comments, or invalid stylesheet syntax.
     * @returns Array of rules data which contains:
     * - selector as string;
     * - ast to query elements by;
     * - map of styles to apply.
     */


    const parse = (rawStylesheet, extCssDoc) => {
      const stylesheet = rawStylesheet.trim();

      if (stylesheet.includes("".concat(SLASH).concat(ASTERISK)) && stylesheet.includes("".concat(ASTERISK).concat(SLASH))) {
        throw new Error("".concat(STYLESHEET_ERROR_PREFIX.NO_COMMENT, ": '").concat(stylesheet, "'"));
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
        rawRuleData: initRawRuleData
      };
      const rawResults = new Map();
      let selectorData; // context.cssToParse is going to be cropped while its parsing

      while (context.cssToParse) {
        if (context.isSelector) {
          // find index of first opening curly bracket
          // which may mean start of style part and end of selector one
          context.nextIndex = context.cssToParse.indexOf(BRACKETS.CURLY.LEFT); // rule should not start with style, selector is required
          // e.g. '{ display: none; }'

          if (context.selectorBuffer.length === 0 && context.nextIndex === 0) {
            throw new Error("".concat(STYLESHEET_ERROR_PREFIX.NO_SELECTOR, ": '").concat(context.cssToParse, "'")); // eslint-disable-line max-len
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
            context.rawRuleData.styles = selectorData.stylesOfSelector;
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
            context.selectorBuffer += BRACKETS.CURLY.LEFT; // delete `{` from cssToParse

            context.cssToParse = context.cssToParse.slice(1);
          }
        } else {
          var _context$rawRuleData$;

          // style declaration should be parsed
          const parsedStyles = parseNextStyle(context); // styles can be parsed from selector part if it has :remove() pseudo-class
          // e.g. '.banner:remove() { debug: true; }'

          (_context$rawRuleData$ = context.rawRuleData.styles) === null || _context$rawRuleData$ === void 0 ? void 0 : _context$rawRuleData$.push(...parsedStyles); // save rule data to results

          saveToRawResults(rawResults, context.rawRuleData);
          context.nextIndex = 0; // clean up ruleContext

          restoreRuleAcc(context); // parse next rule selector after style successfully parsed

          context.isSelector = true;
        }
      }

      const results = [];
      rawResults.forEach((value, key) => {
        const selector = key;
        const ast = value.ast,
              rawStyles = value.styles;
        results.push(prepareRuleData(selector, ast, rawStyles));
      });
      return results;
    };

    /**
     * Checks whether passed `arg` is number type.
     *
     * @param arg Value to check.
     */
    const isNumber = arg => {
      return typeof arg === 'number' && !Number.isNaN(arg);
    };

    const isSupported = typeof window.requestAnimationFrame !== 'undefined';
    const timeout = isSupported ? requestAnimationFrame : window.setTimeout;
    const deleteTimeout = isSupported ? cancelAnimationFrame : clearTimeout;
    const perf = isSupported ? performance : Date;
    const DEFAULT_THROTTLE_DELAY_MS = 150;

    /**
     * The purpose of ThrottleWrapper is to throttle calls of the function
     * that applies ExtendedCss rules. The reasoning here is that the function calls
     * are triggered by MutationObserver and there may be many mutations in a short period of time.
     * We do not want to apply rules on every mutation so we use this helper to make sure
     * that there is only one call in the given amount of time.
     */
    class ThrottleWrapper {
      /**
       * The provided callback should be executed twice in this time frame:
       * very first time and not more often than throttleDelayMs for further executions.
       *
       * @see {@link ThrottleWrapper.run}
       */

      /**
       * Creates new ThrottleWrapper.
       *
       * @param context ExtendedCss context.
       * @param callback The callback.
       * @param throttleMs Throttle delay in ms.
       */
      constructor(context, callback, throttleMs) {
        this.context = context;
        this.callback = callback;
        this.throttleDelayMs = throttleMs || DEFAULT_THROTTLE_DELAY_MS;
        this.wrappedCb = this.wrappedCallback.bind(this);
      }
      /**
       * Wraps the callback (which supposed to be `applyRules`),
       * needed to update `lastRunTime` and clean previous timeouts for proper execution of the callback.
       *
       * @param timestamp Timestamp.
       */


      wrappedCallback(timestamp) {
        this.lastRunTime = isNumber(timestamp) ? timestamp : perf.now(); // `timeoutId` can be requestAnimationFrame-related
        // so cancelAnimationFrame() as deleteTimeout() needs the arg to be defined

        if (this.timeoutId) {
          deleteTimeout(this.timeoutId);
          delete this.timeoutId;
        }

        clearTimeout(this.timerId);
        delete this.timerId;

        if (this.callback) {
          this.callback(this.context);
        }
      }
      /**
       * Indicates whether there is a scheduled callback.
       */


      hasPendingCallback() {
        return isNumber(this.timeoutId) || isNumber(this.timerId);
      }
      /**
       * Schedules the function which applies ExtendedCss rules before the next animation frame.
       *
       * Wraps function execution into `timeout` — requestAnimationFrame or setTimeout.
       * For the first time runs the function without any condition.
       * As it may be triggered by any mutation which may occur too ofter, we limit the function execution:
       * 1. If `elapsedTime` since last function execution is less then set `throttleDelayMs`,
       * next function call is hold till the end of throttle interval (subtracting `elapsed` from `throttleDelayMs`);
       * 2. Do nothing if triggered again but function call which is on hold has not yet started its execution.
       */


      run() {
        if (this.hasPendingCallback()) {
          // there is a pending execution scheduled
          return;
        }

        if (typeof this.lastRunTime !== 'undefined') {
          const elapsedTime = perf.now() - this.lastRunTime;

          if (elapsedTime < this.throttleDelayMs) {
            this.timerId = window.setTimeout(this.wrappedCb, this.throttleDelayMs - elapsedTime);
            return;
          }
        }

        this.timeoutId = timeout(this.wrappedCb);
      }
      /**
       * Returns timestamp for 'now'.
       */


      static now() {
        return perf.now();
      }

    }

    const LAST_EVENT_TIMEOUT_MS = 10;
    const IGNORED_EVENTS = ['mouseover', 'mouseleave', 'mouseenter', 'mouseout'];
    const SUPPORTED_EVENTS = [// keyboard events
    'keydown', 'keypress', 'keyup', // mouse events
    'auxclick', 'click', 'contextmenu', 'dblclick', 'mousedown', 'mouseenter', 'mouseleave', 'mousemove', 'mouseover', 'mouseout', 'mouseup', 'pointerlockchange', 'pointerlockerror', 'select', 'wheel']; // 'wheel' event makes scrolling in Safari twitchy
    // https://github.com/AdguardTeam/ExtendedCss/issues/120

    const SAFARI_PROBLEMATIC_EVENTS = ['wheel'];
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

    const isEventListenerSupported = typeof window.addEventListener !== 'undefined';

    const observeDocument = (context, callback) => {
      // We are trying to limit the number of callback calls by not calling it on all kind of "hover" events.
      // The rationale behind this is that "hover" events often cause attributes modification,
      // but re-applying extCSS rules will be useless as these attribute changes are usually transient.
      const shouldIgnoreMutations = mutations => {
        // ignore if all mutations are about attributes changes
        return mutations.every(m => m.type === 'attributes');
      };

      if (natives.MutationObserver) {
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
          callback();
        });
        context.domMutationObserver.observe(document, {
          childList: true,
          subtree: true,
          attributes: true,
          attributeFilter: ['id', 'class']
        });
      } else if (isEventListenerSupported) {
        document.addEventListener('DOMNodeInserted', callback, false);
        document.addEventListener('DOMNodeRemoved', callback, false);
        document.addEventListener('DOMAttrModified', callback, false);
      }
    };

    const disconnectDocument = (context, callback) => {
      var _context$eventTracker;

      if (context.domMutationObserver) {
        context.domMutationObserver.disconnect();
      } else if (isEventListenerSupported) {
        document.removeEventListener('DOMNodeInserted', callback, false);
        document.removeEventListener('DOMNodeRemoved', callback, false);
        document.removeEventListener('DOMAttrModified', callback, false);
      } // clean up event listeners


      (_context$eventTracker = context.eventTracker) === null || _context$eventTracker === void 0 ? void 0 : _context$eventTracker.stopTracking();
    };

    const mainObserve = (context, mainCallback) => {
      if (context.isDomObserved) {
        return;
      } // handle dynamically added elements


      context.isDomObserved = true;
      observeDocument(context, mainCallback);
    };
    const mainDisconnect = (context, mainCallback) => {
      if (!context.isDomObserved) {
        return;
      }

      context.isDomObserved = false;
      disconnectDocument(context, mainCallback);
    };

    /**
     * Removes affectedElement.node from DOM.
     *
     * @param context ExtendedCss context.
     * @param affectedElement Affected element.
     */

    const removeElement = (context, affectedElement) => {
      const node = affectedElement.node;
      affectedElement.removed = true;
      const elementSelector = getElementSelectorPath(node); // check if the element has been already removed earlier

      const elementRemovalsCounter = context.removalsStatistic[elementSelector] || 0; // if removals attempts happened more than specified we do not try to remove node again

      if (elementRemovalsCounter > MAX_STYLE_PROTECTION_COUNT) {
        logger.error("ExtendedCss: infinite loop protection for selector: '".concat(elementSelector, "'"));
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
        // We can't use hasOwnProperty here (does not work in FF)
        if (typeof node.style.getPropertyValue(prop) !== 'undefined') {
          let value = style[prop]; // First we should remove !important attribute (or it won't be applied')

          value = removeSuffix(value.trim(), '!important').trim();
          node.style.setProperty(prop, value, 'important');
        }
      });
    };
    /**
     * Applies style to the specified DOM node.
     *
     * @param context ExtendedCss context.
     * @param affectedElement Object containing DOM node and rule to be applied.
     *
     * @throws An error if affectedElement has no style to apply.
     */

    const applyStyle = (context, affectedElement) => {
      if (affectedElement.protectionObserver) {
        // style is already applied and protected by the observer
        return;
      }

      if (context.beforeStyleApplied) {
        affectedElement = context.beforeStyleApplied(affectedElement);

        if (!affectedElement) {
          return;
        }
      }

      const _affectedElement = affectedElement,
            node = _affectedElement.node,
            rules = _affectedElement.rules;

      for (let i = 0; i < rules.length; i += 1) {
        const _rules$i = rules[i],
              selector = _rules$i.selector,
              style = _rules$i.style,
              debug = _rules$i.debug; // rule may not have style to apply
        // e.g. 'div:has(> a) { debug: true }' -> means no style to apply, and enable debug mode

        if (style) {
          if (style[REMOVE_PSEUDO_MARKER] === PSEUDO_PROPERTY_POSITIVE_VALUE) {
            removeElement(context, affectedElement);
            return;
          }

          setStyleToElement(node, style);
        } else if (!debug) {
          // but rule should not have both style and debug properties
          throw new Error("No style declaration in rule for selector: '".concat(selector, "'"));
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
     */

    const createProtectionCallback = styles => {
      const protectionCallback = (mutations, extObserver) => {
        const target = mutations[0].target;
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
        const style = ruleData.style; // some rules might have only debug property in style declaration
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
     */
    const beautifyTimingNumber = timestamp => {
      return Number(timestamp.toFixed(STATS_DECIMAL_DIGITS_COUNT));
    };
    /**
     * Improves timing stats readability.
     *
     * @param rawTimings Collected timings with raw timestamp.
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
          const selector = ruleData.selector,
                style = ruleData.style,
                debug = ruleData.debug,
                matchedElements = ruleData.matchedElements; // style declaration for some rules is parsed to debug property and no style to apply
          // e.g. 'div:has(> a) { debug: true }'

          if (!style && !debug) {
            throw new Error("Rule should have style declaration for selector: '".concat(selector, "'"));
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
        startTime = ThrottleWrapper.now();
      }

      const ast = ruleData.ast;
      const nodes = selectElementsByAst(ast);
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
        const elapsedTimeMs = ThrottleWrapper.now() - startTime;

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

      mainDisconnect(context, context.mainCallback);
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


      mainObserve(context, context.mainCallback);
      printTimingInfo(context);
    };

    /**
     * Throttle timeout for ThrottleWrapper to execute applyRules().
     */

    const APPLY_RULES_DELAY = 150;
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
    class ExtendedCss {
      /**
       * Creates new ExtendedCss.
       *
       * @param configuration ExtendedCss configuration.
       */
      constructor(configuration) {
        if (!isBrowserSupported()) {
          throw new Error('Browser is not supported by ExtendedCss.');
        }

        if (!configuration) {
          throw new Error('ExtendedCss configuration should be provided.');
        }

        this.context = {
          beforeStyleApplied: configuration.beforeStyleApplied,
          debug: false,
          affectedElements: [],
          isDomObserved: false,
          removalsStatistic: {},
          parsedRules: parse(configuration.styleSheet, extCssDocument),
          mainCallback: () => {}
        }; // true if set in configuration
        // or any rule in styleSheet has `debug: global`

        this.context.debug = configuration.debug || this.context.parsedRules.some(ruleData => {
          return ruleData.debug === DEBUG_PSEUDO_PROPERTY_GLOBAL_VALUE;
        });
        this.applyRulesScheduler = new ThrottleWrapper(this.context, applyRules, APPLY_RULES_DELAY);
        this.context.mainCallback = this.applyRulesScheduler.run.bind(this.applyRulesScheduler);

        if (this.context.beforeStyleApplied && typeof this.context.beforeStyleApplied !== 'function') {
          throw new Error("Invalid configuration. Type of 'beforeStyleApplied' should be a function, received: '".concat(typeof this.context.beforeStyleApplied, "'")); // eslint-disable-line max-len
        }

        this.applyRulesCallbackListener = () => {
          applyRules(this.context);
        };
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
        mainDisconnect(this.context, this.context.mainCallback);
        this.context.affectedElements.forEach(el => {
          revertStyle(el);
        });
        document.removeEventListener('DOMContentLoaded', this.applyRulesCallbackListener, false);
      }
      /**
       * Exposed for testing purposes only.
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

        const start = ThrottleWrapper.now();

        try {
          return extCssDocument.querySelectorAll(selector);
        } finally {
          const end = ThrottleWrapper.now();

          if (!noTiming) {
            logger.info("[ExtendedCss] Elapsed: ".concat(Math.round((end - start) * 1000), " \u03BCs."));
          }
        }
      }
      /**
       * Validates selector.
       *
       * @param inputSelector Selector text to validate.
       */


      static validate(inputSelector) {
        try {
          // ExtendedCss in general supports :remove() in selector
          // but ExtendedCss.query() does not support it as it should be parsed by stylesheet parser.
          // so for validation we have to handle selectors with `:remove()` in it
          const _parseRemoveSelector = parseRemoveSelector(inputSelector),
                selector = _parseRemoveSelector.selector;

          ExtendedCss.query(selector);
          return {
            ok: true,
            error: null
          };
        } catch (e) {
          // eslint-disable-line @typescript-eslint/no-explicit-any
          // not valid input `selector` should be logged eventually
          const error = "Selector is not valid: '".concat(inputSelector, "' -- ").concat(e.message);
          return {
            ok: false,
            error
          };
        }
      }

    }

    exports.ExtendedCss = ExtendedCss;

    Object.defineProperty(exports, '__esModule', { value: true });

}));


/***/ }),

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
/* harmony export */   "Platform": () => (/* binding */ Platform)
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
  MessagesToBackgroundPage["EnableSafariProtection"] = "enable_safari_protection";
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
/* harmony import */ var _adguard_extended_css__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! @adguard/extended-css */ "./node_modules/@adguard/extended-css/dist/extended-css.umd.js");
/* harmony import */ var _adguard_extended_css__WEBPACK_IMPORTED_MODULE_4___default = /*#__PURE__*/__webpack_require__.n(_adguard_extended_css__WEBPACK_IMPORTED_MODULE_4__);
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
  executeScripts(scripts);
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
  var extCss = new _adguard_extended_css__WEBPACK_IMPORTED_MODULE_4__.ExtendedCss({
    styleSheet: extendedCss.filter(function (s) {
      return s.length > 0;
    }).map(function (s) {
      return s.trim();
    }).map(function (s) {
      return s[s.length - 1] !== '}' ? "".concat(s, " {display:none!important;}") : s;
    }).join('\n')
  });
  extCss.apply();
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
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIndlYnBhY2s6Ly9hZHZhbmNlZC1hZGJsb2NrZXItd2ViLWV4dGVuc2lvbi8uL25vZGVfbW9kdWxlcy9AYWRndWFyZC9leHRlbmRlZC1jc3MvZGlzdC9leHRlbmRlZC1jc3MudW1kLmpzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vbm9kZV9tb2R1bGVzL0BiYWJlbC9ydW50aW1lL2hlbHBlcnMvZXNtL2FycmF5TGlrZVRvQXJyYXkuanMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vLi9ub2RlX21vZHVsZXMvQGJhYmVsL3J1bnRpbWUvaGVscGVycy9lc20vYXJyYXlXaXRob3V0SG9sZXMuanMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vLi9ub2RlX21vZHVsZXMvQGJhYmVsL3J1bnRpbWUvaGVscGVycy9lc20vYXN5bmNUb0dlbmVyYXRvci5qcyIsIndlYnBhY2s6Ly9hZHZhbmNlZC1hZGJsb2NrZXItd2ViLWV4dGVuc2lvbi8uL25vZGVfbW9kdWxlcy9AYmFiZWwvcnVudGltZS9oZWxwZXJzL2VzbS9pdGVyYWJsZVRvQXJyYXkuanMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vLi9ub2RlX21vZHVsZXMvQGJhYmVsL3J1bnRpbWUvaGVscGVycy9lc20vbm9uSXRlcmFibGVTcHJlYWQuanMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vLi9ub2RlX21vZHVsZXMvQGJhYmVsL3J1bnRpbWUvaGVscGVycy9lc20vdG9Db25zdW1hYmxlQXJyYXkuanMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vLi9ub2RlX21vZHVsZXMvQGJhYmVsL3J1bnRpbWUvaGVscGVycy9lc20vdW5zdXBwb3J0ZWRJdGVyYWJsZVRvQXJyYXkuanMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vLi9ub2RlX21vZHVsZXMvQGJhYmVsL3J1bnRpbWUvcmVnZW5lcmF0b3IvaW5kZXguanMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vLi9zcmMvcGFnZXMvY29tbW9uL2NvbnN0YW50cy50cyIsIndlYnBhY2s6Ly9hZHZhbmNlZC1hZGJsb2NrZXItd2ViLWV4dGVuc2lvbi8uL3NyYy9wYWdlcy9jb250ZW50L2NvbnRlbnQudHMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vLi9ub2RlX21vZHVsZXMvcmVnZW5lcmF0b3ItcnVudGltZS9ydW50aW1lLmpzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vbm9kZV9tb2R1bGVzL3dlYmV4dGVuc2lvbi1wb2x5ZmlsbC9kaXN0L2Jyb3dzZXItcG9seWZpbGwuanMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vd2VicGFjay9ib290c3RyYXAiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vd2VicGFjay9ydW50aW1lL2NvbXBhdCBnZXQgZGVmYXVsdCBleHBvcnQiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vd2VicGFjay9ydW50aW1lL2RlZmluZSBwcm9wZXJ0eSBnZXR0ZXJzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uL3dlYnBhY2svcnVudGltZS9oYXNPd25Qcm9wZXJ0eSBzaG9ydGhhbmQiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vd2VicGFjay9ydW50aW1lL21ha2UgbmFtZXNwYWNlIG9iamVjdCIsIndlYnBhY2s6Ly9hZHZhbmNlZC1hZGJsb2NrZXItd2ViLWV4dGVuc2lvbi8uL3NyYy90YXJnZXRzL2NvbnRlbnQvaW5kZXgudHMiXSwibmFtZXMiOlsiTWVzc2FnZXNUb05hdGl2ZUFwcCIsIk1lc3NhZ2VzVG9CYWNrZ3JvdW5kUGFnZSIsIk1lc3NhZ2VzVG9Db250ZW50U2NyaXB0IiwiQXBwZWFyYW5jZVRoZW1lIiwiQVBQRUFSQU5DRV9USEVNRV9ERUZBVUxUIiwiU3lzdGVtIiwiV0VCX0VYVEVOU0lPTl9NT1JFX1VSTCIsIlBsYXRmb3JtIiwibG9nTWVzc2FnZSIsInZlcmJvc2UiLCJtZXNzYWdlIiwiY29uc29sZSIsImxvZyIsImdldFNlbGVjdG9yc0FuZFNjcmlwdHMiLCJicm93c2VyIiwidHlwZSIsImRhdGEiLCJ1cmwiLCJ3aW5kb3ciLCJsb2NhdGlvbiIsImhyZWYiLCJyZXNwb25zZSIsImV4ZWN1dGVTY3JpcHRzIiwic2NyaXB0cyIsInN0YXJ0IiwiZW5kIiwidXBkYXRlZCIsInNjcmlwdFRhZyIsImRvY3VtZW50IiwiY3JlYXRlRWxlbWVudCIsInNldEF0dHJpYnV0ZSIsInRleHRDb250ZW50Iiwiam9pbiIsInBhcmVudCIsImhlYWQiLCJkb2N1bWVudEVsZW1lbnQiLCJhcHBlbmRDaGlsZCIsInBhcmVudE5vZGUiLCJyZW1vdmVDaGlsZCIsImFwcGx5U2NyaXB0cyIsImxlbmd0aCIsInByb3RlY3RTdHlsZUVsZW1lbnRDb250ZW50IiwicHJvdGVjdFN0eWxlRWwiLCJNdXRhdGlvbk9ic2VydmVyIiwiV2ViS2l0TXV0YXRpb25PYnNlcnZlciIsImlubmVyT2JzZXJ2ZXIiLCJtdXRhdGlvbnMiLCJpIiwibSIsImhhc0F0dHJpYnV0ZSIsImdldEF0dHJpYnV0ZSIsInJlbW92ZUF0dHJpYnV0ZSIsImlzUHJvdGVjdFN0eWxlRWxNb2RpZmllZCIsInJlbW92ZWROb2RlcyIsImoiLCJvbGRWYWx1ZSIsIm9ic2VydmUiLCJjaGlsZExpc3QiLCJjaGFyYWN0ZXJEYXRhIiwic3VidHJlZSIsImNoYXJhY3RlckRhdGFPbGRWYWx1ZSIsImFwcGx5Q3NzIiwic3R5bGVTZWxlY3RvcnMiLCJzdHlsZUVsZW1lbnQiLCJzZWxlY3RvcnMiLCJtYXAiLCJzIiwidHJpbSIsImZvckVhY2giLCJzZWxlY3RvciIsInNoZWV0IiwiaW5zZXJ0UnVsZSIsImUiLCJhcHBseUV4dGVuZGVkQ3NzIiwiZXh0ZW5kZWRDc3MiLCJleHRDc3MiLCJFeHRlbmRlZENzcyIsInN0eWxlU2hlZXQiLCJmaWx0ZXIiLCJhcHBseSIsImFwcGx5QWR2YW5jZWRCbG9ja2luZ0RhdGEiLCJzZWxlY3RvcnNBbmRTY3JpcHRzIiwiY3NzSW5qZWN0IiwiY3NzRXh0ZW5kZWQiLCJpbml0IiwiSFRNTERvY3VtZW50IiwiaW5kZXhPZiIsInN0YXJ0R2V0dGluZ1NjcmlwdHMiLCJEYXRlIiwibm93IiwiY29udGVudCJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7O0FBQUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLElBQUksS0FBNEQ7QUFDaEUsSUFBSSxDQUM0RztBQUNoSCxDQUFDLDZCQUE2Qjs7QUFFOUI7QUFDQTtBQUNBO0FBQ0E7QUFDQSxpQ0FBaUM7QUFDakMsa0NBQWtDO0FBQ2xDO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsT0FBTztBQUNQO0FBQ0E7QUFDQTtBQUNBLE9BQU87QUFDUDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLHdCQUF3QjtBQUN4QjtBQUNBO0FBQ0EsNkJBQTZCO0FBQzdCO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSx1RkFBdUY7O0FBRXZGO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSwwYUFBMGE7O0FBRTFhO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQSwwQ0FBMEM7O0FBRTFDO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxhQUFhLHVFQUF1RTtBQUNwRjs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxhQUFhO0FBQ2I7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQSw0Q0FBNEM7QUFDNUM7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBLE9BQU87QUFDUDtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxLQUFLLGtDQUFrQzs7QUFFdkM7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxPQUFPO0FBQ1A7QUFDQTtBQUNBO0FBQ0EsT0FBTztBQUNQO0FBQ0E7QUFDQTtBQUNBLE9BQU87QUFDUDtBQUNBO0FBQ0E7QUFDQSxPQUFPO0FBQ1A7QUFDQSw4QkFBOEIsRUFBRTtBQUNoQztBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsYUFBYTtBQUNiOztBQUVBO0FBQ0E7O0FBRUE7O0FBRUE7QUFDQTtBQUNBLE9BQU87OztBQUdQO0FBQ0E7QUFDQSxPQUFPO0FBQ1A7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBLHFCQUFxQix5QkFBeUI7QUFDOUM7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxPQUFPOzs7QUFHUDtBQUNBLHdDQUF3Qzs7QUFFeEM7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBLHFDQUFxQzs7QUFFckM7QUFDQTtBQUNBLE9BQU87OztBQUdQO0FBQ0E7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxhQUFhO0FBQ2I7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0EsS0FBSzs7QUFFTDtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQSxPQUFPO0FBQ1A7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQSxzQkFBc0I7QUFDdEI7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsS0FBSyxrQ0FBa0M7O0FBRXZDO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsNENBQTRDO0FBQzVDO0FBQ0E7QUFDQSw2Q0FBNkM7QUFDN0M7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBO0FBQ0EsOEJBQThCLEVBQUUsT0FBTyxFQUFFO0FBQ3pDLDJDQUEyQztBQUMzQztBQUNBO0FBQ0EsT0FBTztBQUNQO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQSx3Q0FBd0MsRUFBRTtBQUMxQztBQUNBLDhDQUE4QyxLQUFLO0FBQ25EO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQSxPQUFPO0FBQ1A7QUFDQTtBQUNBO0FBQ0E7QUFDQSxvQ0FBb0M7O0FBRXBDO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLE9BQU87QUFDUDtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBLGdDQUFnQztBQUNoQzs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0EsT0FBTztBQUNQO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQSxPQUFPO0FBQ1A7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBLE9BQU87QUFDUDtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtB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QUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLE1BQU07QUFDTjs7O0FBR0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQSx5TEFBeUw7QUFDekw7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0E7QUFDQTtBQUNBOztBQUVBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLEtBQUssOEJBQThCOztBQUVuQztBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSw0Q0FBNEM7O0FBRTVDLGlCQUFpQjs7QUFFakIsc0JBQXNCOztBQUV0Qix3QkFBd0I7O0FBRXhCLHFCQUFxQixxQkFBcUI7QUFDMUM7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTs7QUFFQTtBQUNBLDJDQUEyQzs7QUFFM0M7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQSxhQUFhO0FBQ2I7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQSxPQUFPOzs7QUFHUDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7O0FBRUEscUVBQXFFO0FBQ3JFOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0Esb0ZBQW9GO0FBQ3BGO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQSxPQUFPOzs7QUFHUDtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxPQUFPOzs7QUFHUDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0EsT0FBTztBQUNQLDRJQUE0STtBQUM1STtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBOztBQUVBO0FBQ0E7QUFDQSxPQUFPO0FBQ1A7QUFDQSxPQUFPO0FBQ1A7QUFDQSxPQUFPO0FBQ1A7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTtBQUNBLG1EQUFtRDs7QUFFbkQ7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0EsdURBQXVELFFBQVE7QUFDL0Q7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQSxPQUFPO0FBQ1A7QUFDQTtBQUNBO0FBQ0EsT0FBTztBQUNQO0FBQ0E7QUFDQSxPQUFPO0FBQ1A7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0Esd0hBQXdIO0FBQ3hILFNBQVM7QUFDVDtBQUNBOzs7QUFHQSw4Q0FBOEM7QUFDOUM7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsT0FBTztBQUNQO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBLGtEQUFrRDs7QUFFbEQ7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQSxnQ0FBZ0M7O0FBRWhDO0FBQ0EsdUNBQXVDOztBQUV2QztBQUNBO0FBQ0EsK0NBQStDO0FBQy9DO0FBQ0E7QUFDQTs7QUFFQTtBQUNBLDJEQUEyRDtBQUMzRDtBQUNBOztBQUVBO0FBQ0E7QUFDQSxtREFBbUQ7QUFDbkQ7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxhQUFhO0FBQ2I7QUFDQTtBQUNBO0FBQ0EsYUFBYTtBQUNiO0FBQ0EsYUFBYTtBQUNiO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSw2SUFBNkk7QUFDN0ksZUFBZTs7O0FBR2YsOEVBQThFO0FBQzlFO0FBQ0E7O0FBRUE7QUFDQTtBQUNBLGVBQWU7QUFDZjtBQUNBO0FBQ0E7QUFDQTtBQUNBLGFBQWE7QUFDYjtBQUNBO0FBQ0EsYUFBYTtBQUNiO0FBQ0E7O0FBRUE7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxpQkFBaUI7QUFDakI7QUFDQTtBQUNBO0FBQ0E7QUFDQSxtQkFBbUI7QUFDbkI7QUFDQTtBQUNBO0FBQ0EsaUJBQWlCO0FBQ2pCO0FBQ0E7QUFDQTtBQUNBLGlCQUFpQjtBQUNqQjtBQUNBO0FBQ0E7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsaUVBQWlFLGdCQUFnQjtBQUNqRjtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLG1CQUFtQjtBQUNuQjtBQUNBOzs7QUFHQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxtQkFBbUI7QUFDbkI7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLGlCQUFpQjtBQUNqQjtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxpQkFBaUI7QUFDakI7QUFDQTs7QUFFQTtBQUNBO0FBQ0EsbUJBQW1C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Q0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQSxPQUFPO0FBQ1A7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0EsT0FBTztBQUNQO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0Esc0tBQXNLO0FBQ3RLO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTs7QUFFQTtBQUNBLFNBQVM7QUFDVDtBQUNBLE9BQU87O0FBRVA7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7O0FBRUE7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBLFNBQVM7QUFDVDtBQUNBLE9BQU87O0FBRVA7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxtQkFBbUI7QUFDbkI7QUFDQTtBQUNBO0FBQ0EsMkpBQTJKO0FBQzNKLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxvSUFBb0k7O0FBRXBJO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVCwwQkFBMEI7O0FBRTFCLHdJQUF3STtBQUN4STs7QUFFQTtBQUNBLE9BQU87QUFDUDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQSxtSUFBbUk7O0FBRW5JOztBQUVBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7OztBQUdBO0FBQ0EsT0FBTztBQUNQO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUdBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUdBLG1JQUFtSTs7QUFFbkk7O0FBRUE7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQSx3SUFBd0k7QUFDeEksU0FBUztBQUNUO0FBQ0E7OztBQUdBO0FBQ0EsT0FBTztBQUNQO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLHNDQUFzQyx3QkFBd0I7QUFDOUQ7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBLE9BQU87QUFDUDtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTs7QUFFQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0EsT0FBTztBQUNQOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLGFBQWE7O0FBRWI7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLGFBQWE7O0FBRWI7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLGFBQWE7O0FBRWI7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLGFBQWE7O0FBRWI7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0EsT0FBTztBQUNQO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNULE9BQU87QUFDUDtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0EseUlBQXlJOztBQUV6STtBQUNBO0FBQ0EsU0FBUztBQUNULE9BQU87QUFDUDtBQUNBO0FBQ0E7QUFDQSxzSUFBc0k7O0FBRXRJO0FBQ0EsU0FBUztBQUNULE9BQU87QUFDUDs7O0FBR0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0Esa0NBQWtDO0FBQ2xDOztBQUVBO0FBQ0E7QUFDQSxPQUFPLEVBQUU7O0FBRVQ7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxxSkFBcUo7QUFDcko7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0EsT0FBTztBQUNQO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBLE9BQU87QUFDUDtBQUNBO0FBQ0E7QUFDQSxPQUFPO0FBQ1A7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLE9BQU87QUFDUDtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsYUFBYTtBQUNiO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsT0FBTztBQUNQO0FBQ0E7O0FBRUE7QUFDQSx1Q0FBdUM7QUFDdkMsMENBQTBDLEVBQUU7QUFDNUMsd0NBQXdDO0FBQ3hDOztBQUVBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQSxtREFBbUQ7QUFDbkQ7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0EsT0FBTztBQUNQO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLHdIQUF3SDtBQUN4SCxTQUFTOzs7QUFHVDtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0EsK0RBQStEO0FBQy9EOztBQUVBO0FBQ0E7QUFDQSxPQUFPO0FBQ1A7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLDZDQUE2QztBQUM3Qzs7O0FBR0E7QUFDQSx3QkFBd0IsU0FBUztBQUNqQztBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBLHdCQUF3QixFQUFFO0FBQzFCO0FBQ0E7QUFDQSxXQUFXO0FBQ1gsb0JBQW9CLGVBQWUsRUFBRSx5QkFBeUI7O0FBRTlELFNBQVM7QUFDVCxxQ0FBcUM7QUFDckMsZ0VBQWdFLFFBQVE7QUFDeEUsNEJBQTRCLGFBQWEsZUFBZSxVQUFVLHNCQUFzQjtBQUN4RjtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQSxvQ0FBb0MsY0FBYyxRQUFROztBQUUxRDtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBLDJCQUEyQjs7QUFFM0I7O0FBRUE7QUFDQTtBQUNBOztBQUVBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQSxTQUFTLEVBQUUsOEJBQThCO0FBQ3pDLGtCQUFrQixnQkFBZ0IsVUFBVTs7QUFFNUM7QUFDQTtBQUNBO0FBQ0EsT0FBTywyQ0FBMkM7QUFDbEQ7OztBQUdBO0FBQ0E7QUFDQSx1REFBdUQ7QUFDdkQ7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBO0FBQ0Esb0VBQW9FOztBQUVwRTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBLG1DQUFtQzs7QUFFbkM7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBO0FBQ0E7QUFDQSxPQUFPO0FBQ1A7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0E7QUFDQTtBQUNBLE9BQU87QUFDUDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBLGlGQUFpRjtBQUNqRjs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsT0FBTztBQUNQO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1QsT0FBTztBQUNQO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLHdCQUF3QjtBQUN4QiwwREFBMEQ7QUFDMUQ7QUFDQSwwQ0FBMEM7QUFDMUM7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsdUJBQXVCOztBQUV2QjtBQUNBO0FBQ0E7QUFDQTtBQUNBLDhFQUE4RTtBQUM5RSxvQkFBb0IsZUFBZSxFQUFFOztBQUVyQztBQUNBLG1IQUFtSDtBQUNuSDs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsdUNBQXVDOztBQUV2QztBQUNBLGdFQUFnRTs7QUFFaEU7QUFDQSxhQUFhO0FBQ2I7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBLDBEQUEwRCxhQUFhOztBQUV2RTtBQUNBO0FBQ0EsU0FBUztBQUNUOztBQUVBO0FBQ0EsdURBQXVEO0FBQ3ZELHFDQUFxQyxhQUFhLEVBQUU7O0FBRXBELG1LQUFtSzs7QUFFbks7QUFDQSxnQ0FBZ0M7O0FBRWhDLGtDQUFrQzs7QUFFbEM7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLE9BQU87QUFDUDtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxlQUFlO0FBQ2Y7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0Esd0VBQXdFO0FBQ3hFOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBO0FBQ0E7O0FBRUE7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQSwwTUFBME07QUFDMU07O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBLFNBQVM7O0FBRVQ7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUOztBQUVBOztBQUVBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFF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QTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTs7QUFFQTs7QUFFQSxTQUFTO0FBQ1Q7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUEsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBLG9DQUFvQyxjQUFjO0FBQ2xEO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUEsS0FBSztBQUNMO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBLGlDQUFpQyxrQkFBa0I7QUFDbkQ7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBLGlCQUFpQjs7QUFFakI7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0Esd0JBQXdCLGlCQUFpQjtBQUN6QztBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBLFlBQVk7QUFDWjtBQUNBOztBQUVBO0FBQ0EsWUFBWTtBQUNaOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsS0FBSzs7QUFFTDtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQSxLQUFLOztBQUVMO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUEsOENBQThDLFFBQVE7QUFDdEQ7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLGFBQWE7QUFDYjtBQUNBOztBQUVBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7O0FBRUEsV0FBVztBQUNYO0FBQ0E7QUFDQTs7QUFFQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxLQUFLOztBQUVMO0FBQ0EsOENBQThDLFFBQVE7QUFDdEQ7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQSxLQUFLOztBQUVMO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLE9BQU87QUFDUDtBQUNBO0FBQ0E7QUFDQSxPQUFPO0FBQ1A7QUFDQTs7QUFFQTtBQUNBLEtBQUs7O0FBRUw7QUFDQSw4Q0FBOEMsUUFBUTtBQUN0RDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLEtBQUs7O0FBRUw7QUFDQSw4Q0FBOEMsUUFBUTtBQUN0RDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQSxLQUFLOztBQUVMO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBLENBQUM7QUFDRDtBQUNBO0FBQ0E7QUFDQTtBQUNBLEVBQUUsS0FBMEIsb0JBQW9CLENBQUU7QUFDbEQ7O0FBRUE7QUFDQTtBQUNBLENBQUM7QUFDRDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7Ozs7Ozs7OztBQzN1QkE7QUFDQSxNQUFNLElBQTBDO0FBQ2hELElBQUksaUNBQWdDLENBQUMsTUFBUSxDQUFDLG9DQUFFLE9BQU87QUFBQTtBQUFBO0FBQUEsa0dBQUM7QUFDeEQsR0FBRyxNQUFNLFlBUU47QUFDSCxDQUFDO0FBQ0Q7O0FBRUEscUNBQXFDOztBQUVyQzs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0EsdVNBQXVTO0FBQ3ZTO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxhQUFhO0FBQ2I7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsYUFBYTtBQUNiO0FBQ0E7QUFDQTtBQUNBLGFBQWE7QUFDYjtBQUNBO0FBQ0E7QUFDQSxhQUFhO0FBQ2I7QUFDQTtBQUNBO0FBQ0EsYUFBYTtBQUNiO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsYUFBYTtBQUNiO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsYUFBYTtBQUNiO0FBQ0E7QUFDQTtBQUNBLGFBQWE7QUFDYjtBQUNBO0FBQ0E7QUFDQSxhQUFhO0FBQ2I7QUFDQTtBQUNBO0FBQ0EsYUFBYTtBQUNiO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNB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ekk7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBLFNBQVM7QUFDVDs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWCxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQSxLQUFLO0FBQ0w7OztBQUdBO0FBQ0EsR0FBRztBQUNIO0FBQ0E7QUFDQSxDQUFDO0FBQ0Q7Ozs7Ozs7VUM1dkNBO1VBQ0E7O1VBRUE7VUFDQTtVQUNBO1VBQ0E7VUFDQTtVQUNBO1VBQ0E7VUFDQTtVQUNBO1VBQ0E7VUFDQTtVQUNBO1VBQ0E7O1VBRUE7VUFDQTs7VUFFQTtVQUNBO1VBQ0E7Ozs7O1dDdEJBO1dBQ0E7V0FDQTtXQUNBO1dBQ0E7V0FDQSxnQ0FBZ0MsWUFBWTtXQUM1QztXQUNBLEU7Ozs7O1dDUEE7V0FDQTtXQUNBO1dBQ0E7V0FDQSx3Q0FBd0MseUNBQXlDO1dBQ2pGO1dBQ0E7V0FDQSxFOzs7OztXQ1BBLHdGOzs7OztXQ0FBO1dBQ0E7V0FDQTtXQUNBLHNEQUFzRCxrQkFBa0I7V0FDeEU7V0FDQSwrQ0FBK0MsY0FBYztXQUM3RCxFOzs7Ozs7Ozs7Ozs7O0FDTkE7QUFFQU0sd0RBQUEsRyIsImZpbGUiOiJjb250ZW50LmpzIiwic291cmNlc0NvbnRlbnQiOlsiLyohIEBhZGd1YXJkL2V4dGVuZGVkLWNzcyAtIHYyLjAuMTAgLSBUdWUgTm92IDE1IDIwMjJcbiogaHR0cHM6Ly9naXRodWIuY29tL0FkZ3VhcmRUZWFtL0V4dGVuZGVkQ3NzI2hvbWVwYWdlXG4qIENvcHlyaWdodCAoYykgMjAyMiBBZEd1YXJkLiBMaWNlbnNlZCBHUEwtMy4wXG4qL1xuKGZ1bmN0aW9uIChnbG9iYWwsIGZhY3RvcnkpIHtcbiAgICB0eXBlb2YgZXhwb3J0cyA9PT0gJ29iamVjdCcgJiYgdHlwZW9mIG1vZHVsZSAhPT0gJ3VuZGVmaW5lZCcgPyBmYWN0b3J5KGV4cG9ydHMpIDpcbiAgICB0eXBlb2YgZGVmaW5lID09PSAnZnVuY3Rpb24nICYmIGRlZmluZS5hbWQgPyBkZWZpbmUoWydleHBvcnRzJ10sIGZhY3RvcnkpIDpcbiAgICAoZ2xvYmFsID0gdHlwZW9mIGdsb2JhbFRoaXMgIT09ICd1bmRlZmluZWQnID8gZ2xvYmFsVGhpcyA6IGdsb2JhbCB8fCBzZWxmLCBmYWN0b3J5KGdsb2JhbC5FeHRlbmRlZENzcyA9IHt9KSk7XG59KSh0aGlzLCAoZnVuY3Rpb24gKGV4cG9ydHMpIHsgJ3VzZSBzdHJpY3QnO1xuXG4gICAgY29uc3QgTEVGVF9TUVVBUkVfQlJBQ0tFVCA9ICdbJztcbiAgICBjb25zdCBSSUdIVF9TUVVBUkVfQlJBQ0tFVCA9ICddJztcbiAgICBjb25zdCBMRUZUX1BBUkVOVEhFU0lTID0gJygnO1xuICAgIGNvbnN0IFJJR0hUX1BBUkVOVEhFU0lTID0gJyknO1xuICAgIGNvbnN0IExFRlRfQ1VSTFlfQlJBQ0tFVCA9ICd7JztcbiAgICBjb25zdCBSSUdIVF9DVVJMWV9CUkFDS0VUID0gJ30nO1xuICAgIGNvbnN0IEJSQUNLRVRTID0ge1xuICAgICAgU1FVQVJFOiB7XG4gICAgICAgIExFRlQ6IExFRlRfU1FVQVJFX0JSQUNLRVQsXG4gICAgICAgIFJJR0hUOiBSSUdIVF9TUVVBUkVfQlJBQ0tFVFxuICAgICAgfSxcbiAgICAgIFBBUkVOVEhFU0VTOiB7XG4gICAgICAgIExFRlQ6IExFRlRfUEFSRU5USEVTSVMsXG4gICAgICAgIFJJR0hUOiBSSUdIVF9QQVJFTlRIRVNJU1xuICAgICAgfSxcbiAgICAgIENVUkxZOiB7XG4gICAgICAgIExFRlQ6IExFRlRfQ1VSTFlfQlJBQ0tFVCxcbiAgICAgICAgUklHSFQ6IFJJR0hUX0NVUkxZX0JSQUNLRVRcbiAgICAgIH1cbiAgICB9O1xuICAgIGNvbnN0IFNMQVNIID0gJy8nO1xuICAgIGNvbnN0IEJBQ0tTTEFTSCA9ICdcXFxcJztcbiAgICBjb25zdCBTUEFDRSA9ICcgJztcbiAgICBjb25zdCBDT01NQSA9ICcsJztcbiAgICBjb25zdCBET1QgPSAnLic7XG4gICAgY29uc3QgU0VNSUNPTE9OID0gJzsnO1xuICAgIGNvbnN0IENPTE9OID0gJzonO1xuICAgIGNvbnN0IFNJTkdMRV9RVU9URSA9ICdcXCcnO1xuICAgIGNvbnN0IERPVUJMRV9RVU9URSA9ICdcIic7IC8vIGRvIG5vdCBjb25zaWRlciBoeXBoZW4gYC1gIGFzIHNlcGFyYXRlZCBtYXJrXG4gICAgLy8gdG8gYXZvaWQgcHNldWRvLWNsYXNzIG5hbWVzIHNwbGl0dGluZ1xuICAgIC8vIGUuZy4gJ21hdGNoZXMtY3NzJyBvciAnaWYtbm90J1xuXG4gICAgY29uc3QgQ0FSRVQgPSAnXic7XG4gICAgY29uc3QgRE9MTEFSX1NJR04gPSAnJCc7XG4gICAgY29uc3QgRVFVQUxfU0lHTiA9ICc9JztcbiAgICBjb25zdCBUQUIgPSAnXFx0JztcbiAgICBjb25zdCBDQVJSSUFHRV9SRVRVUk4gPSAnXFxyJztcbiAgICBjb25zdCBMSU5FX0ZFRUQgPSAnXFxuJztcbiAgICBjb25zdCBGT1JNX0ZFRUQgPSAnXFxmJztcbiAgICBjb25zdCBXSElURV9TUEFDRV9DSEFSQUNURVJTID0gW1NQQUNFLCBUQUIsIENBUlJJQUdFX1JFVFVSTiwgTElORV9GRUVELCBGT1JNX0ZFRURdOyAvLyBmb3IgdW5pdmVyc2FsIHNlbGVjdG9yIGFuZCBhdHRyaWJ1dGVzXG5cbiAgICBjb25zdCBBU1RFUklTSyA9ICcqJztcbiAgICBjb25zdCBJRF9NQVJLRVIgPSAnIyc7XG4gICAgY29uc3QgQ0xBU1NfTUFSS0VSID0gRE9UO1xuICAgIGNvbnN0IERFU0NFTkRBTlRfQ09NQklOQVRPUiA9IFNQQUNFO1xuICAgIGNvbnN0IENISUxEX0NPTUJJTkFUT1IgPSAnPic7XG4gICAgY29uc3QgTkVYVF9TSUJMSU5HX0NPTUJJTkFUT1IgPSAnKyc7XG4gICAgY29uc3QgU1VCU0VRVUVOVF9TSUJMSU5HX0NPTUJJTkFUT1IgPSAnfic7XG4gICAgY29uc3QgQ09NQklOQVRPUlMgPSBbREVTQ0VOREFOVF9DT01CSU5BVE9SLCBDSElMRF9DT01CSU5BVE9SLCBORVhUX1NJQkxJTkdfQ09NQklOQVRPUiwgU1VCU0VRVUVOVF9TSUJMSU5HX0NPTUJJTkFUT1JdO1xuICAgIGNvbnN0IFNVUFBPUlRFRF9TRUxFQ1RPUl9NQVJLUyA9IFtMRUZUX1NRVUFSRV9CUkFDS0VULCBSSUdIVF9TUVVBUkVfQlJBQ0tFVCwgTEVGVF9QQVJFTlRIRVNJUywgUklHSFRfUEFSRU5USEVTSVMsIExFRlRfQ1VSTFlfQlJBQ0tFVCwgUklHSFRfQ1VSTFlfQlJBQ0tFVCwgU0xBU0gsIEJBQ0tTTEFTSCwgU0VNSUNPTE9OLCBDT0xPTiwgQ09NTUEsIFNJTkdMRV9RVU9URSwgRE9VQkxFX1FVT1RFLCBDQVJFVCwgRE9MTEFSX1NJR04sIEFTVEVSSVNLLCBJRF9NQVJLRVIsIENMQVNTX01BUktFUiwgREVTQ0VOREFOVF9DT01CSU5BVE9SLCBDSElMRF9DT01CSU5BVE9SLCBORVhUX1NJQkxJTkdfQ09NQklOQVRPUiwgU1VCU0VRVUVOVF9TSUJMSU5HX0NPTUJJTkFUT1IsIFRBQiwgQ0FSUklBR0VfUkVUVVJOLCBMSU5FX0ZFRUQsIEZPUk1fRkVFRF07IC8vIGFic29sdXRlOlxuXG4gICAgY29uc3QgQ09OVEFJTlNfUFNFVURPID0gJ2NvbnRhaW5zJztcbiAgICBjb25zdCBIQVNfVEVYVF9QU0VVRE8gPSAnaGFzLXRleHQnO1xuICAgIGNvbnN0IEFCUF9DT05UQUlOU19QU0VVRE8gPSAnLWFicC1jb250YWlucyc7XG4gICAgY29uc3QgTUFUQ0hFU19DU1NfUFNFVURPID0gJ21hdGNoZXMtY3NzJztcbiAgICBjb25zdCBNQVRDSEVTX0NTU19CRUZPUkVfUFNFVURPID0gJ21hdGNoZXMtY3NzLWJlZm9yZSc7XG4gICAgY29uc3QgTUFUQ0hFU19DU1NfQUZURVJfUFNFVURPID0gJ21hdGNoZXMtY3NzLWFmdGVyJztcbiAgICBjb25zdCBNQVRDSEVTX0FUVFJfUFNFVURPX0NMQVNTX01BUktFUiA9ICdtYXRjaGVzLWF0dHInO1xuICAgIGNvbnN0IE1BVENIRVNfUFJPUEVSVFlfUFNFVURPX0NMQVNTX01BUktFUiA9ICdtYXRjaGVzLXByb3BlcnR5JztcbiAgICBjb25zdCBYUEFUSF9QU0VVRE9fQ0xBU1NfTUFSS0VSID0gJ3hwYXRoJztcbiAgICBjb25zdCBOVEhfQU5DRVNUT1JfUFNFVURPX0NMQVNTX01BUktFUiA9ICdudGgtYW5jZXN0b3InO1xuICAgIGNvbnN0IENPTlRBSU5TX1BTRVVET19OQU1FUyA9IFtDT05UQUlOU19QU0VVRE8sIEhBU19URVhUX1BTRVVETywgQUJQX0NPTlRBSU5TX1BTRVVET107XG4gICAgLyoqXG4gICAgICogUHNldWRvLWNsYXNzIDp1cHdhcmQoKSBjYW4gZ2V0IG51bWJlciBvciBzZWxlY3RvciBhcmdcbiAgICAgKiBhbmQgaWYgdGhlIGFyZyBpcyBzZWxlY3RvciBpdCBzaG91bGQgYmUgc3RhbmRhcmQsIG5vdCBleHRlbmRlZFxuICAgICAqIHNvIDp1cHdhcmQgcHNldWRvLWNsYXNzIGlzIGFsd2F5cyBhYnNvbHV0ZS5cbiAgICAgKi9cblxuICAgIGNvbnN0IFVQV0FSRF9QU0VVRE9fQ0xBU1NfTUFSS0VSID0gJ3Vwd2FyZCc7XG4gICAgLyoqXG4gICAgICogUHNldWRvLWNsYXNzIGA6cmVtb3ZlKClgIGFuZCBwc2V1ZG8tcHJvcGVydHkgYHJlbW92ZWBcbiAgICAgKiBhcmUgdXNlZCBmb3IgZWxlbWVudCBhY3Rpb25zLCBub3QgZm9yIGVsZW1lbnQgc2VsZWN0aW5nLlxuICAgICAqXG4gICAgICogU2VsZWN0b3IgdGV4dCBzaG91bGQgbm90IGNvbnRhaW4gdGhlIHBzZXVkby1jbGFzc1xuICAgICAqIHNvIHNlbGVjdG9yIHBhcnNlciBzaG91bGQgY29uc2lkZXIgaXQgYXMgaW52YWxpZFxuICAgICAqIGFuZCBib3RoIGFyZSBoYW5kbGVkIGJ5IHN0eWxlc2hlZXQgcGFyc2VyLlxuICAgICAqL1xuXG4gICAgY29uc3QgUkVNT1ZFX1BTRVVET19NQVJLRVIgPSAncmVtb3ZlJzsgLy8gcmVsYXRpdmU6XG5cbiAgICBjb25zdCBIQVNfUFNFVURPX0NMQVNTX01BUktFUiA9ICdoYXMnO1xuICAgIGNvbnN0IElGX1BTRVVET19DTEFTU19NQVJLRVIgPSAnaWYnO1xuICAgIGNvbnN0IEFCUF9IQVNfUFNFVURPX0NMQVNTX01BUktFUiA9ICctYWJwLWhhcyc7XG4gICAgY29uc3QgSEFTX1BTRVVET19DTEFTU19NQVJLRVJTID0gW0hBU19QU0VVRE9fQ0xBU1NfTUFSS0VSLCBJRl9QU0VVRE9fQ0xBU1NfTUFSS0VSLCBBQlBfSEFTX1BTRVVET19DTEFTU19NQVJLRVJdO1xuICAgIGNvbnN0IElGX05PVF9QU0VVRE9fQ0xBU1NfTUFSS0VSID0gJ2lmLW5vdCc7XG4gICAgY29uc3QgSVNfUFNFVURPX0NMQVNTX01BUktFUiA9ICdpcyc7XG4gICAgY29uc3QgTk9UX1BTRVVET19DTEFTU19NQVJLRVIgPSAnbm90JztcbiAgICBjb25zdCBBQlNPTFVURV9QU0VVRE9fQ0xBU1NFUyA9IFtDT05UQUlOU19QU0VVRE8sIEhBU19URVhUX1BTRVVETywgQUJQX0NPTlRBSU5TX1BTRVVETywgTUFUQ0hFU19DU1NfUFNFVURPLCBNQVRDSEVTX0NTU19CRUZPUkVfUFNFVURPLCBNQVRDSEVTX0NTU19BRlRFUl9QU0VVRE8sIE1BVENIRVNfQVRUUl9QU0VVRE9fQ0xBU1NfTUFSS0VSLCBNQVRDSEVTX1BST1BFUlRZX1BTRVVET19DTEFTU19NQVJLRVIsIFhQQVRIX1BTRVVET19DTEFTU19NQVJLRVIsIE5USF9BTkNFU1RPUl9QU0VVRE9fQ0xBU1NfTUFSS0VSLCBVUFdBUkRfUFNFVURPX0NMQVNTX01BUktFUl07XG4gICAgY29uc3QgUkVMQVRJVkVfUFNFVURPX0NMQVNTRVMgPSBbLi4uSEFTX1BTRVVET19DTEFTU19NQVJLRVJTLCBJRl9OT1RfUFNFVURPX0NMQVNTX01BUktFUiwgSVNfUFNFVURPX0NMQVNTX01BUktFUiwgTk9UX1BTRVVET19DTEFTU19NQVJLRVJdO1xuICAgIGNvbnN0IFNVUFBPUlRFRF9QU0VVRE9fQ0xBU1NFUyA9IFsuLi5BQlNPTFVURV9QU0VVRE9fQ0xBU1NFUywgLi4uUkVMQVRJVkVfUFNFVURPX0NMQVNTRVNdO1xuICAgIC8qKlxuICAgICAqICc6c2NvcGUnIGlzIHVzZWQgZm9yIGV4dGVuZGVkIHBzZXVkby1jbGFzcyA6aGFzKCksIGlmLW5vdCgpLCA6aXMoKSBhbmQgOm5vdCgpLlxuICAgICAqL1xuXG4gICAgY29uc3QgU0NPUEVfQ1NTX1BTRVVET19DTEFTUyA9ICc6c2NvcGUnO1xuICAgIC8qKlxuICAgICAqICc6YWZ0ZXInIGFuZCAnOmJlZm9yZScgYXJlIG5lZWRlZCBmb3IgOm1hdGNoZXMtY3NzKCkgcHNldWRvLWNsYXNzXG4gICAgICogYWxsIG90aGVyIGFyZSBuZWVkZWQgZm9yIDpoYXMoKSBsaW1pdGF0aW9uIGFmdGVyIHJlZ3VsYXIgcHNldWRvLWVsZW1lbnRzLlxuICAgICAqXG4gICAgICogQHNlZSB7QGxpbmsgaHR0cHM6Ly9idWdzLmNocm9taXVtLm9yZy9wL2Nocm9taXVtL2lzc3Vlcy9kZXRhaWw/aWQ9NjY5MDU4I2M1NH0gW2Nhc2UgM11cbiAgICAgKi9cblxuICAgIGNvbnN0IFJFR1VMQVJfUFNFVURPX0VMRU1FTlRTID0ge1xuICAgICAgQUZURVI6ICdhZnRlcicsXG4gICAgICBCQUNLRFJPUDogJ2JhY2tkcm9wJyxcbiAgICAgIEJFRk9SRTogJ2JlZm9yZScsXG4gICAgICBDVUU6ICdjdWUnLFxuICAgICAgQ1VFX1JFR0lPTjogJ2N1ZS1yZWdpb24nLFxuICAgICAgRklSU1RfTEVUVEVSOiAnZmlyc3QtbGV0dGVyJyxcbiAgICAgIEZJUlNUX0xJTkU6ICdmaXJzdC1saW5lJyxcbiAgICAgIEZJTEVfU0VMRUNUSU9OX0JVVFRPTjogJ2ZpbGUtc2VsZWN0b3ItYnV0dG9uJyxcbiAgICAgIEdSQU1NQVJfRVJST1I6ICdncmFtbWFyLWVycm9yJyxcbiAgICAgIE1BUktFUjogJ21hcmtlcicsXG4gICAgICBQQVJUOiAncGFydCcsXG4gICAgICBQTEFDRUhPTERFUjogJ3BsYWNlaG9sZGVyJyxcbiAgICAgIFNFTEVDVElPTjogJ3NlbGVjdGlvbicsXG4gICAgICBTTE9UVEVEOiAnc2xvdHRlZCcsXG4gICAgICBTUEVMTElOR19FUlJPUjogJ3NwZWxsaW5nLWVycm9yJyxcbiAgICAgIFRBUkdFVF9URVhUOiAndGFyZ2V0LXRleHQnXG4gICAgfTtcbiAgICBjb25zdCBQU0VVRE9fUFJPUEVSVFlfUE9TSVRJVkVfVkFMVUUgPSAndHJ1ZSc7XG4gICAgY29uc3QgREVCVUdfUFNFVURPX1BST1BFUlRZX0dMT0JBTF9WQUxVRSA9ICdnbG9iYWwnO1xuICAgIGNvbnN0IFNUWUxFU0hFRVRfRVJST1JfUFJFRklYID0ge1xuICAgICAgTk9fU1RZTEU6ICdObyBzdHlsZSBkZWNsYXJhdGlvbiBhdCBzdHlsZXNoZWV0IHBhcnQnLFxuICAgICAgTk9fU0VMRUNUT1I6ICdTZWxlY3RvciBzaG91bGQgYmUgZGVmaW5lZCBiZWZvcmUgc3R5bGUgZGVjbGFyYXRpb24gaW4gc3R5bGVzaGVldCcsXG4gICAgICBJTlZBTElEX1NUWUxFOiAnSW52YWxpZCBzdHlsZSBkZWNsYXJhdGlvbiBhdCBzdHlsZXNoZWV0IHBhcnQnLFxuICAgICAgVU5DTE9TRURfU1RZTEU6ICdVbmNsb3NlZCBzdHlsZSBkZWNsYXJhdGlvbiBhdCBzdHlsZXNoZWV0IHBhcnQnLFxuICAgICAgTk9fUFJPUEVSVFk6ICdNaXNzaW5nIHN0eWxlIHByb3BlcnR5IGluIGRlY2xhcmF0aW9uIGF0IHN0eWxlc2hlZXQgcGFydCcsXG4gICAgICBOT19WQUxVRTogJ01pc3Npbmcgc3R5bGUgdmFsdWUgaW4gZGVjbGFyYXRpb24gYXQgc3R5bGVzaGVldCBwYXJ0JyxcbiAgICAgIE5PX1NUWUxFX09SX1JFTU9WRTogJ0ludmFsaWQgc3R5bGVzaGVldCAtIG5vIHN0eWxlIGRlY2xhcmVkIG9yIDpyZW1vdmUoKSBwc2V1ZG8tY2xhc3MgdXNlZCcsXG4gICAgICBOT19DT01NRU5UOiAnQ29tbWVudHMgaW4gc3R5bGVzaGVldCBhcmUgbm90IHN1cHBvcnRlZCdcbiAgICB9O1xuICAgIGNvbnN0IFJFTU9WRV9FUlJPUl9QUkVGSVggPSB7XG4gICAgICBJTlZBTElEX1JFTU9WRTogJ0ludmFsaWQgOnJlbW92ZSgpIHBzZXVkby1jbGFzcyBpbiBzZWxlY3RvcicsXG4gICAgICBOT19UQVJHRVRfU0VMRUNUT1I6ICdTZWxlY3RvciBzaG91bGQgYmUgc3BlY2lmaWVkIGJlZm9yZSA6cmVtb3ZlKCkgcHNldWRvLWNsYXNzJyxcbiAgICAgIE1VTFRJUExFX1VTQUdFOiAnUHNldWRvLWNsYXNzIDpyZW1vdmUoKSBhcHBlYXJzIG1vcmUgdGhhbiBvbmNlIGluIHNlbGVjdG9yJyxcbiAgICAgIElOVkFMSURfUE9TSVRJT046ICdQc2V1ZG8tY2xhc3MgOnJlbW92ZSgpIHNob3VsZCBiZSBhdCB0aGUgZW5kIG9mIHNlbGVjdG9yJ1xuICAgIH07XG4gICAgY29uc3QgTUFUQ0hJTkdfRUxFTUVOVF9FUlJPUl9QUkVGSVggPSAnRXJyb3Igd2hpbGUgbWF0Y2hpbmcgZWxlbWVudCc7XG4gICAgY29uc3QgTUFYX1NUWUxFX1BST1RFQ1RJT05fQ09VTlQgPSA1MDtcblxuICAgIC8qKlxuICAgICAqIEdldHMgc3RyaW5nIHdpdGhvdXQgc3VmZml4LlxuICAgICAqXG4gICAgICogQHBhcmFtIHN0ciBJbnB1dCBzdHJpbmcuXG4gICAgICogQHBhcmFtIHN1ZmZpeCBOZWVkZWQgdG8gcmVtb3ZlLlxuICAgICAqL1xuXG4gICAgY29uc3QgcmVtb3ZlU3VmZml4ID0gKHN0ciwgc3VmZml4KSA9PiB7XG4gICAgICBjb25zdCBpbmRleCA9IHN0ci5pbmRleE9mKHN1ZmZpeCwgc3RyLmxlbmd0aCAtIHN1ZmZpeC5sZW5ndGgpO1xuXG4gICAgICBpZiAoaW5kZXggPj0gMCkge1xuICAgICAgICByZXR1cm4gc3RyLnN1YnN0cmluZygwLCBpbmRleCk7XG4gICAgICB9XG5cbiAgICAgIHJldHVybiBzdHI7XG4gICAgfTtcbiAgICAvKipcbiAgICAgKiBSZXBsYWNlcyBhbGwgYHBhdHRlcm5gcyB3aXRoIGByZXBsYWNlbWVudGAgaW4gYGlucHV0YCBzdHJpbmcuXG4gICAgICogU3RyaW5nLnJlcGxhY2VBbGwoKSBwb2x5ZmlsbCBiZWNhdXNlIGl0IGlzIG5vdCBzdXBwb3J0ZWQgYnkgb2xkIGJyb3dzZXJzLCBlLmcuIENocm9tZSA1NS5cbiAgICAgKlxuICAgICAqIEBzZWUge0BsaW5rIGh0dHBzOi8vY2FuaXVzZS5jb20vP3NlYXJjaD1TdHJpbmcucmVwbGFjZUFsbH1cbiAgICAgKlxuICAgICAqIEBwYXJhbSBpbnB1dCBJbnB1dCBzdHJpbmcgdG8gcHJvY2Vzcy5cbiAgICAgKiBAcGFyYW0gcGF0dGVybiBGaW5kIGluIHRoZSBpbnB1dCBzdHJpbmcuXG4gICAgICogQHBhcmFtIHJlcGxhY2VtZW50IFJlcGxhY2UgdGhlIHBhdHRlcm4gd2l0aC5cbiAgICAgKi9cblxuICAgIGNvbnN0IHJlcGxhY2VBbGwgPSAoaW5wdXQsIHBhdHRlcm4sIHJlcGxhY2VtZW50KSA9PiB7XG4gICAgICBpZiAoIWlucHV0KSB7XG4gICAgICAgIHJldHVybiBpbnB1dDtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIGlucHV0LnNwbGl0KHBhdHRlcm4pLmpvaW4ocmVwbGFjZW1lbnQpO1xuICAgIH07XG4gICAgLyoqXG4gICAgICogQ29udmVydHMgc3RyaW5nIHBhdHRlcm4gdG8gcmVndWxhciBleHByZXNzaW9uLlxuICAgICAqXG4gICAgICogQHBhcmFtIHN0ciBTdHJpbmcgdG8gY29udmVydC5cbiAgICAgKi9cblxuICAgIGNvbnN0IHRvUmVnRXhwID0gc3RyID0+IHtcbiAgICAgIGlmIChzdHIuc3RhcnRzV2l0aChTTEFTSCkgJiYgc3RyLmVuZHNXaXRoKFNMQVNIKSkge1xuICAgICAgICByZXR1cm4gbmV3IFJlZ0V4cChzdHIuc2xpY2UoMSwgLTEpKTtcbiAgICAgIH1cblxuICAgICAgY29uc3QgZXNjYXBlZCA9IHN0ci5yZXBsYWNlKC9bLiorP14ke30oKXxbXFxdXFxcXF0vZywgJ1xcXFwkJicpO1xuICAgICAgcmV0dXJuIG5ldyBSZWdFeHAoZXNjYXBlZCk7XG4gICAgfTtcbiAgICAvKipcbiAgICAgKiBDb252ZXJ0cyBhbnkgc2ltcGxlIHR5cGUgdmFsdWUgdG8gc3RyaW5nIHR5cGUsXG4gICAgICogZS5nLiBgdW5kZWZpbmVkYCAtPiBgJ3VuZGVmaW5lZCdgLlxuICAgICAqXG4gICAgICogQHBhcmFtIHZhbHVlIEFueSB0eXBlIHZhbHVlLlxuICAgICAqL1xuXG4gICAgY29uc3QgY29udmVydFR5cGVJbnRvU3RyaW5nID0gdmFsdWUgPT4ge1xuICAgICAgbGV0IG91dHB1dDtcblxuICAgICAgc3dpdGNoICh2YWx1ZSkge1xuICAgICAgICBjYXNlIHVuZGVmaW5lZDpcbiAgICAgICAgICBvdXRwdXQgPSAndW5kZWZpbmVkJztcbiAgICAgICAgICBicmVhaztcblxuICAgICAgICBjYXNlIG51bGw6XG4gICAgICAgICAgb3V0cHV0ID0gJ251bGwnO1xuICAgICAgICAgIGJyZWFrO1xuXG4gICAgICAgIGRlZmF1bHQ6XG4gICAgICAgICAgb3V0cHV0ID0gdmFsdWUudG9TdHJpbmcoKTtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIG91dHB1dDtcbiAgICB9O1xuICAgIC8qKlxuICAgICAqIENvbnZlcnRzIGluc3RhbmNlIG9mIHN0cmluZyB2YWx1ZSBpbnRvIG90aGVyIHNpbXBsZSB0eXBlcyxcbiAgICAgKiBlLmcuIGAnbnVsbCdgIC0+IGBudWxsYCwgYCd0cnVlJ2AgLT4gYHRydWVgLlxuICAgICAqXG4gICAgICogQHBhcmFtIHZhbHVlIFN0cmluZy10eXBlIHZhbHVlLlxuICAgICAqL1xuXG4gICAgY29uc3QgY29udmVydFR5cGVGcm9tU3RyaW5nID0gdmFsdWUgPT4ge1xuICAgICAgY29uc3QgbnVtVmFsdWUgPSBOdW1iZXIodmFsdWUpO1xuICAgICAgbGV0IG91dHB1dDtcblxuICAgICAgaWYgKCFOdW1iZXIuaXNOYU4obnVtVmFsdWUpKSB7XG4gICAgICAgIG91dHB1dCA9IG51bVZhbHVlO1xuICAgICAgfSBlbHNlIHtcbiAgICAgICAgc3dpdGNoICh2YWx1ZSkge1xuICAgICAgICAgIGNhc2UgJ3VuZGVmaW5lZCc6XG4gICAgICAgICAgICBvdXRwdXQgPSB1bmRlZmluZWQ7XG4gICAgICAgICAgICBicmVhaztcblxuICAgICAgICAgIGNhc2UgJ251bGwnOlxuICAgICAgICAgICAgb3V0cHV0ID0gbnVsbDtcbiAgICAgICAgICAgIGJyZWFrO1xuXG4gICAgICAgICAgY2FzZSAndHJ1ZSc6XG4gICAgICAgICAgICBvdXRwdXQgPSB0cnVlO1xuICAgICAgICAgICAgYnJlYWs7XG5cbiAgICAgICAgICBjYXNlICdmYWxzZSc6XG4gICAgICAgICAgICBvdXRwdXQgPSBmYWxzZTtcbiAgICAgICAgICAgIGJyZWFrO1xuXG4gICAgICAgICAgZGVmYXVsdDpcbiAgICAgICAgICAgIG91dHB1dCA9IHZhbHVlO1xuICAgICAgICB9XG4gICAgICB9XG5cbiAgICAgIHJldHVybiBvdXRwdXQ7XG4gICAgfTtcblxuICAgIGNvbnN0IGxvZ2dlciA9IHtcbiAgICAgIC8qKlxuICAgICAgICogU2FmZSBjb25zb2xlLmVycm9yIHZlcnNpb24uXG4gICAgICAgKi9cbiAgICAgIGVycm9yOiB0eXBlb2YgY29uc29sZSAhPT0gJ3VuZGVmaW5lZCcgJiYgY29uc29sZS5lcnJvciAmJiBjb25zb2xlLmVycm9yLmJpbmQgPyBjb25zb2xlLmVycm9yLmJpbmQod2luZG93LmNvbnNvbGUpIDogY29uc29sZS5lcnJvcixcblxuICAgICAgLyoqXG4gICAgICAgKiBTYWZlIGNvbnNvbGUuaW5mbyB2ZXJzaW9uLlxuICAgICAgICovXG4gICAgICBpbmZvOiB0eXBlb2YgY29uc29sZSAhPT0gJ3VuZGVmaW5lZCcgJiYgY29uc29sZS5pbmZvICYmIGNvbnNvbGUuaW5mby5iaW5kID8gY29uc29sZS5pbmZvLmJpbmQod2luZG93LmNvbnNvbGUpIDogY29uc29sZS5pbmZvXG4gICAgfTtcblxuICAgIHZhciBCcm93c2VyTmFtZTtcblxuICAgIChmdW5jdGlvbiAoQnJvd3Nlck5hbWUpIHtcbiAgICAgIEJyb3dzZXJOYW1lW1wiQ2hyb21lXCJdID0gXCJDaHJvbWVcIjtcbiAgICAgIEJyb3dzZXJOYW1lW1wiRmlyZWZveFwiXSA9IFwiRmlyZWZveFwiO1xuICAgICAgQnJvd3Nlck5hbWVbXCJFZGdlXCJdID0gXCJFZGdcIjtcbiAgICAgIEJyb3dzZXJOYW1lW1wiT3BlcmFcIl0gPSBcIk9wZXJhXCI7XG4gICAgICBCcm93c2VyTmFtZVtcIlNhZmFyaVwiXSA9IFwiU2FmYXJpXCI7XG4gICAgfSkoQnJvd3Nlck5hbWUgfHwgKEJyb3dzZXJOYW1lID0ge30pKTtcblxuICAgIGNvbnN0IENIUk9NSVVNX0JSQU5EX05BTUUgPSAnQ2hyb21pdW0nO1xuICAgIGNvbnN0IEdPT0dMRV9DSFJPTUVfQlJBTkRfTkFNRSA9ICdHb29nbGUgQ2hyb21lJztcbiAgICAvKipcbiAgICAgKiBTaW1wbGUgY2hlY2sgZm9yIFNhZmFyaSBicm93c2VyLlxuICAgICAqL1xuXG4gICAgY29uc3QgaXNTYWZhcmlCcm93c2VyID0gbmF2aWdhdG9yLnZlbmRvciA9PT0gJ0FwcGxlIENvbXB1dGVyLCBJbmMuJztcbiAgICBjb25zdCBTVVBQT1JURURfQlJPV1NFUlNfREFUQSA9IHtcbiAgICAgIFtCcm93c2VyTmFtZS5DaHJvbWVdOiB7XG4gICAgICAgIC8vIGF2b2lkIENocm9taXVtLWJhc2VkIEVkZ2UgYnJvd3NlclxuICAgICAgICBNQVNLOiAvXFxzKENocm9tZSlcXC8oXFxkKylcXC4uK1xccyg/IS4qRWRnXFwvKS8sXG4gICAgICAgIE1JTl9WRVJTSU9OOiA1NVxuICAgICAgfSxcbiAgICAgIFtCcm93c2VyTmFtZS5GaXJlZm94XToge1xuICAgICAgICBNQVNLOiAvXFxzKEZpcmVmb3gpXFwvKFxcZCspXFwuLyxcbiAgICAgICAgTUlOX1ZFUlNJT046IDUyXG4gICAgICB9LFxuICAgICAgW0Jyb3dzZXJOYW1lLkVkZ2VdOiB7XG4gICAgICAgIE1BU0s6IC9cXHMoRWRnKVxcLyhcXGQrKVxcLi8sXG4gICAgICAgIE1JTl9WRVJTSU9OOiA4MFxuICAgICAgfSxcbiAgICAgIFtCcm93c2VyTmFtZS5PcGVyYV06IHtcbiAgICAgICAgTUFTSzogL1xccyhPUFIpXFwvKFxcZCspXFwuLyxcbiAgICAgICAgTUlOX1ZFUlNJT046IDgwXG4gICAgICB9LFxuICAgICAgW0Jyb3dzZXJOYW1lLlNhZmFyaV06IHtcbiAgICAgICAgTUFTSzogL1xcc1ZlcnNpb25cXC8oXFxkezJ9XFwuXFxkKSguK1xcc3xcXHMpKFNhZmFyaSlcXC8vLFxuICAgICAgICBNSU5fVkVSU0lPTjogMTEuMVxuICAgICAgfVxuICAgIH07XG4gICAgLyoqXG4gICAgICogUmV0dXJucyBjaHJvbWl1bSBicmFuZCBvYmplY3QgZnJvbSBuYXZpZ2F0b3IudXNlckFnZW50RGF0YS5icmFuZHMgb3IgbnVsbCBpZiBub3Qgc3VwcG9ydGVkLlxuICAgICAqIENocm9taXVtIGJlY2F1c2Ugb2YgYWxsIGJyb3dzZXJzIGJhc2VkIG9uIGl0IHNob3VsZCBiZSBzdXBwb3J0ZWQgYXMgd2VsbFxuICAgICAqIGFuZCBpdCBpcyB1bml2ZXJzYWwgd2F5IHRvIGNoZWNrIGl0LlxuICAgICAqXG4gICAgICogQHNlZSB7QGxpbmsgaHR0cHM6Ly9kZXZlbG9wZXIubW96aWxsYS5vcmcvZW4tVVMvZG9jcy9XZWIvQVBJL05hdmlnYXRvclVBRGF0YS9icmFuZHN9XG4gICAgICovXG5cbiAgICBjb25zdCBnZXRDaHJvbWl1bUJyYW5kID0gKCkgPT4ge1xuICAgICAgdmFyIF9uYXZpZ2F0b3IkdXNlckFnZW50RDtcblxuICAgICAgY29uc3QgYnJhbmRzRGF0YSA9IChfbmF2aWdhdG9yJHVzZXJBZ2VudEQgPSBuYXZpZ2F0b3IudXNlckFnZW50RGF0YSkgPT09IG51bGwgfHwgX25hdmlnYXRvciR1c2VyQWdlbnREID09PSB2b2lkIDAgPyB2b2lkIDAgOiBfbmF2aWdhdG9yJHVzZXJBZ2VudEQuYnJhbmRzO1xuXG4gICAgICBpZiAoIWJyYW5kc0RhdGEpIHtcbiAgICAgICAgcmV0dXJuIG51bGw7XG4gICAgICB9IC8vIGZvciBjaHJvbWl1bS1iYXNlZCBicm93c2Vyc1xuXG5cbiAgICAgIGNvbnN0IGNocm9taXVtQnJhbmQgPSBicmFuZHNEYXRhLmZpbmQoYnJhbmREYXRhID0+IHtcbiAgICAgICAgcmV0dXJuIGJyYW5kRGF0YS5icmFuZCA9PT0gQ0hST01JVU1fQlJBTkRfTkFNRSB8fCBicmFuZERhdGEuYnJhbmQgPT09IEdPT0dMRV9DSFJPTUVfQlJBTkRfTkFNRTtcbiAgICAgIH0pO1xuICAgICAgcmV0dXJuIGNocm9taXVtQnJhbmQgfHwgbnVsbDtcbiAgICB9O1xuXG4gICAgLyoqXG4gICAgICogUGFyc2VzIHVzZXJBZ2VudCBzdHJpbmcgYW5kIHJldHVybnMgdGhlIGRhdGEgb2JqZWN0IGZvciBzdXBwb3J0ZWQgYnJvd3NlcnM7XG4gICAgICogb3RoZXJ3aXNlIHJldHVybnMgbnVsbC5cbiAgICAgKi9cbiAgICBjb25zdCBwYXJzZVVzZXJBZ2VudCA9ICgpID0+IHtcbiAgICAgIGxldCBicm93c2VyTmFtZTtcbiAgICAgIGxldCBjdXJyZW50VmVyc2lvbjtcbiAgICAgIGNvbnN0IGJyb3dzZXJOYW1lcyA9IE9iamVjdC52YWx1ZXMoQnJvd3Nlck5hbWUpO1xuXG4gICAgICBmb3IgKGxldCBpID0gMDsgaSA8IGJyb3dzZXJOYW1lcy5sZW5ndGg7IGkgKz0gMSkge1xuICAgICAgICBjb25zdCBtYXRjaCA9IFNVUFBPUlRFRF9CUk9XU0VSU19EQVRBW2Jyb3dzZXJOYW1lc1tpXV0uTUFTSy5leGVjKG5hdmlnYXRvci51c2VyQWdlbnQpO1xuXG4gICAgICAgIGlmIChtYXRjaCkge1xuICAgICAgICAgIC8vIGZvciBzYWZhcmkgYnJvd3NlciB0aGUgb3JkZXIgaXMgZGlmZmVyZW50IGJlY2F1c2Ugb2YgcmVnZXhwXG4gICAgICAgICAgaWYgKG1hdGNoWzNdID09PSBicm93c2VyTmFtZXNbaV0pIHtcbiAgICAgICAgICAgIGJyb3dzZXJOYW1lID0gbWF0Y2hbM107XG4gICAgICAgICAgICBjdXJyZW50VmVyc2lvbiA9IE51bWJlcihtYXRjaFsxXSk7XG4gICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIC8vIGZvciBvdGhlcnMgZmlyc3QgaXMgbmFtZSBhbmQgc2Vjb25kIGlzIHZlcnNpb25cbiAgICAgICAgICAgIGJyb3dzZXJOYW1lID0gbWF0Y2hbMV07XG4gICAgICAgICAgICBjdXJyZW50VmVyc2lvbiA9IE51bWJlcihtYXRjaFsyXSk7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgcmV0dXJuIHtcbiAgICAgICAgICAgIGJyb3dzZXJOYW1lLFxuICAgICAgICAgICAgY3VycmVudFZlcnNpb25cbiAgICAgICAgICB9O1xuICAgICAgICB9XG4gICAgICB9XG5cbiAgICAgIHJldHVybiBudWxsO1xuICAgIH07XG4gICAgLyoqXG4gICAgICogR2V0cyBpbmZvIGFib3V0IGN1cnJlbnQgYnJvd3Nlci5cbiAgICAgKi9cblxuXG4gICAgY29uc3QgZ2V0Q3VycmVudEJyb3dzZXJJbmZvQXNTdXBwb3J0ZWQgPSAoKSA9PiB7XG4gICAgICBjb25zdCBicmFuZERhdGEgPSBnZXRDaHJvbWl1bUJyYW5kKCk7XG5cbiAgICAgIGlmICghYnJhbmREYXRhKSB7XG4gICAgICAgIGNvbnN0IHVhSW5mbyA9IHBhcnNlVXNlckFnZW50KCk7XG5cbiAgICAgICAgaWYgKCF1YUluZm8pIHtcbiAgICAgICAgICByZXR1cm4gbnVsbDtcbiAgICAgICAgfVxuXG4gICAgICAgIGNvbnN0IGJyb3dzZXJOYW1lID0gdWFJbmZvLmJyb3dzZXJOYW1lLFxuICAgICAgICAgICAgICBjdXJyZW50VmVyc2lvbiA9IHVhSW5mby5jdXJyZW50VmVyc2lvbjtcbiAgICAgICAgcmV0dXJuIHtcbiAgICAgICAgICBicm93c2VyTmFtZSxcbiAgICAgICAgICBjdXJyZW50VmVyc2lvblxuICAgICAgICB9O1xuICAgICAgfSAvLyBpZiBuYXZpZ2F0b3IudXNlckFnZW50RGF0YSBpcyBzdXBwb3J0ZWRcblxuXG4gICAgICBjb25zdCBicmFuZCA9IGJyYW5kRGF0YS5icmFuZCxcbiAgICAgICAgICAgIHZlcnNpb24gPSBicmFuZERhdGEudmVyc2lvbjsgLy8gaGFuZGxlIGNocm9taXVtLWJhc2VkIGJyb3dzZXJzXG5cbiAgICAgIGNvbnN0IGJyb3dzZXJOYW1lID0gYnJhbmQgPT09IENIUk9NSVVNX0JSQU5EX05BTUUgfHwgYnJhbmQgPT09IEdPT0dMRV9DSFJPTUVfQlJBTkRfTkFNRSA/IEJyb3dzZXJOYW1lLkNocm9tZSA6IGJyYW5kO1xuICAgICAgcmV0dXJuIHtcbiAgICAgICAgYnJvd3Nlck5hbWUsXG4gICAgICAgIGN1cnJlbnRWZXJzaW9uOiBOdW1iZXIodmVyc2lvbilcbiAgICAgIH07XG4gICAgfTtcbiAgICAvKipcbiAgICAgKiBDaGVja3Mgd2hldGhlciB0aGUgY3VycmVudCBicm93c2VyIGlzIHN1cHBvcnRlZC5cbiAgICAgKi9cblxuXG4gICAgY29uc3QgaXNCcm93c2VyU3VwcG9ydGVkID0gKCkgPT4ge1xuICAgICAgY29uc3QgdWEgPSBuYXZpZ2F0b3IudXNlckFnZW50OyAvLyBkbyBub3Qgc3VwcG9ydCBJbnRlcm5ldCBFeHBsb3JlclxuXG4gICAgICBpZiAodWEuaW5jbHVkZXMoJ01TSUUnKSB8fCB1YS5pbmNsdWRlcygnVHJpZGVudC8nKSkge1xuICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICB9IC8vIGZvciBsb2NhbCB0ZXN0aW5nIHB1cnBvc2VzXG5cblxuICAgICAgaWYgKHVhLmluY2x1ZGVzKCdqc2RvbScpKSB7XG4gICAgICAgIHJldHVybiB0cnVlO1xuICAgICAgfVxuXG4gICAgICBjb25zdCBjdXJyZW50QnJvd3NlckRhdGEgPSBnZXRDdXJyZW50QnJvd3NlckluZm9Bc1N1cHBvcnRlZCgpO1xuXG4gICAgICBpZiAoIWN1cnJlbnRCcm93c2VyRGF0YSkge1xuICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICB9XG5cbiAgICAgIGNvbnN0IGJyb3dzZXJOYW1lID0gY3VycmVudEJyb3dzZXJEYXRhLmJyb3dzZXJOYW1lLFxuICAgICAgICAgICAgY3VycmVudFZlcnNpb24gPSBjdXJyZW50QnJvd3NlckRhdGEuY3VycmVudFZlcnNpb247XG4gICAgICByZXR1cm4gY3VycmVudFZlcnNpb24gPj0gU1VQUE9SVEVEX0JST1dTRVJTX0RBVEFbYnJvd3Nlck5hbWVdLk1JTl9WRVJTSU9OO1xuICAgIH07XG5cbiAgICBjb25zdCBuYXRpdmVzID0ge1xuICAgICAgTXV0YXRpb25PYnNlcnZlcjogd2luZG93Lk11dGF0aW9uT2JzZXJ2ZXIgfHwgd2luZG93LldlYktpdE11dGF0aW9uT2JzZXJ2ZXJcbiAgICB9O1xuICAgIC8qKlxuICAgICAqIEFzIHNvb24gYXMgcG9zc2libGUgc3RvcmVzIG5hdGl2ZSBOb2RlIHRleHRDb250ZW50IGdldHRlciB0byBiZSB1c2VkIGZvciBjb250YWlucyBwc2V1ZG8tY2xhc3NcbiAgICAgKiBiZWNhdXNlIGVsZW1lbnRzJyAndGV4dENvbnRlbnQnIGFuZCAnaW5uZXJUZXh0JyBwcm9wZXJ0aWVzIG1pZ2h0IGJlIG1vY2tlZC5cbiAgICAgKlxuICAgICAqIEBzZWUge0BsaW5rIGh0dHBzOi8vZ2l0aHViLmNvbS9BZGd1YXJkVGVhbS9FeHRlbmRlZENzcy9pc3N1ZXMvMTI3fVxuICAgICAqL1xuXG4gICAgY29uc3Qgbm9kZVRleHRDb250ZW50R2V0dGVyID0gKCgpID0+IHtcbiAgICAgIHZhciBfT2JqZWN0JGdldE93blByb3BlcnQ7XG5cbiAgICAgIGNvbnN0IG5hdGl2ZU5vZGUgPSB3aW5kb3cuTm9kZSB8fCBOb2RlO1xuICAgICAgcmV0dXJuIChfT2JqZWN0JGdldE93blByb3BlcnQgPSBPYmplY3QuZ2V0T3duUHJvcGVydHlEZXNjcmlwdG9yKG5hdGl2ZU5vZGUucHJvdG90eXBlLCAndGV4dENvbnRlbnQnKSkgPT09IG51bGwgfHwgX09iamVjdCRnZXRPd25Qcm9wZXJ0ID09PSB2b2lkIDAgPyB2b2lkIDAgOiBfT2JqZWN0JGdldE93blByb3BlcnQuZ2V0O1xuICAgIH0pKCk7XG5cbiAgICAvKipcbiAgICAgKiBSZXR1cm5zIHRleHRDb250ZW50IG9mIHBhc3NlZCBkb21FbGVtZW50LlxuICAgICAqXG4gICAgICogQHBhcmFtIGRvbUVsZW1lbnQgRE9NIGVsZW1lbnQuXG4gICAgICovXG5cbiAgICBjb25zdCBnZXROb2RlVGV4dENvbnRlbnQgPSBkb21FbGVtZW50ID0+IHtcbiAgICAgIHJldHVybiAobm9kZVRleHRDb250ZW50R2V0dGVyID09PSBudWxsIHx8IG5vZGVUZXh0Q29udGVudEdldHRlciA9PT0gdm9pZCAwID8gdm9pZCAwIDogbm9kZVRleHRDb250ZW50R2V0dGVyLmFwcGx5KGRvbUVsZW1lbnQpKSB8fCAnJztcbiAgICB9O1xuICAgIC8qKlxuICAgICAqIFJldHVybnMgZWxlbWVudCBzZWxlY3RvciB0ZXh0IGJhc2VkIG9uIGl0J3MgdGFnTmFtZSBhbmQgYXR0cmlidXRlcy5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBlbGVtZW50IERPTSBlbGVtZW50LlxuICAgICAqL1xuXG4gICAgY29uc3QgZ2V0RWxlbWVudFNlbGVjdG9yRGVzYyA9IGVsZW1lbnQgPT4ge1xuICAgICAgbGV0IHNlbGVjdG9yVGV4dCA9IGVsZW1lbnQudGFnTmFtZS50b0xvd2VyQ2FzZSgpO1xuICAgICAgc2VsZWN0b3JUZXh0ICs9IEFycmF5LmZyb20oZWxlbWVudC5hdHRyaWJ1dGVzKS5tYXAoYXR0ciA9PiB7XG4gICAgICAgIHJldHVybiBcIltcIi5jb25jYXQoYXR0ci5uYW1lLCBcIj1cXFwiXCIpLmNvbmNhdChlbGVtZW50LmdldEF0dHJpYnV0ZShhdHRyLm5hbWUpLCBcIlxcXCJdXCIpO1xuICAgICAgfSkuam9pbignJyk7XG4gICAgICByZXR1cm4gc2VsZWN0b3JUZXh0O1xuICAgIH07XG4gICAgLyoqXG4gICAgICogUmV0dXJucyBwYXRoIHRvIGEgRE9NIGVsZW1lbnQgYXMgYSBzZWxlY3RvciBzdHJpbmcuXG4gICAgICpcbiAgICAgKiBAcGFyYW0gaW5wdXRFbCBJbnB1dCBlbGVtZW50LlxuICAgICAqXG4gICAgICogQHRocm93cyBBbiBlcnJvciBpZiBgaW5wdXRFbGAgaW4gbm90IGluc3RhbmNlIG9mIGBFbGVtZW50YC5cbiAgICAgKi9cblxuICAgIGNvbnN0IGdldEVsZW1lbnRTZWxlY3RvclBhdGggPSBpbnB1dEVsID0+IHtcbiAgICAgIGlmICghKGlucHV0RWwgaW5zdGFuY2VvZiBFbGVtZW50KSkge1xuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoJ0Z1bmN0aW9uIHJlY2VpdmVkIGFyZ3VtZW50IHdpdGggd3JvbmcgdHlwZScpO1xuICAgICAgfVxuXG4gICAgICBsZXQgZWw7XG4gICAgICBlbCA9IGlucHV0RWw7XG4gICAgICBjb25zdCBwYXRoID0gW107IC8vIHdlIG5lZWQgdG8gY2hlY2sgJyEhZWwnIGZpcnN0IGJlY2F1c2UgaXQgaXMgcG9zc2libGVcbiAgICAgIC8vIHRoYXQgc29tZSBhbmNlc3RvciBvZiB0aGUgaW5wdXRFbCB3YXMgcmVtb3ZlZCBiZWZvcmUgaXRcblxuICAgICAgd2hpbGUgKCEhZWwgJiYgZWwubm9kZVR5cGUgPT09IE5vZGUuRUxFTUVOVF9OT0RFKSB7XG4gICAgICAgIGxldCBzZWxlY3RvciA9IGVsLm5vZGVOYW1lLnRvTG93ZXJDYXNlKCk7XG5cbiAgICAgICAgaWYgKGVsLmlkICYmIHR5cGVvZiBlbC5pZCA9PT0gJ3N0cmluZycpIHtcbiAgICAgICAgICBzZWxlY3RvciArPSBcIiNcIi5jb25jYXQoZWwuaWQpO1xuICAgICAgICAgIHBhdGgudW5zaGlmdChzZWxlY3Rvcik7XG4gICAgICAgICAgYnJlYWs7XG4gICAgICAgIH1cblxuICAgICAgICBsZXQgc2libGluZyA9IGVsO1xuICAgICAgICBsZXQgbnRoID0gMTtcblxuICAgICAgICB3aGlsZSAoc2libGluZy5wcmV2aW91c0VsZW1lbnRTaWJsaW5nKSB7XG4gICAgICAgICAgc2libGluZyA9IHNpYmxpbmcucHJldmlvdXNFbGVtZW50U2libGluZztcblxuICAgICAgICAgIGlmIChzaWJsaW5nLm5vZGVUeXBlID09PSBOb2RlLkVMRU1FTlRfTk9ERSAmJiBzaWJsaW5nLm5vZGVOYW1lLnRvTG93ZXJDYXNlKCkgPT09IHNlbGVjdG9yKSB7XG4gICAgICAgICAgICBudGggKz0gMTtcbiAgICAgICAgICB9XG4gICAgICAgIH1cblxuICAgICAgICBpZiAobnRoICE9PSAxKSB7XG4gICAgICAgICAgc2VsZWN0b3IgKz0gXCI6bnRoLW9mLXR5cGUoXCIuY29uY2F0KG50aCwgXCIpXCIpO1xuICAgICAgICB9XG5cbiAgICAgICAgcGF0aC51bnNoaWZ0KHNlbGVjdG9yKTtcbiAgICAgICAgZWwgPSBlbC5wYXJlbnRFbGVtZW50O1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gcGF0aC5qb2luKCcgPiAnKTtcbiAgICB9O1xuICAgIC8qKlxuICAgICAqIENoZWNrcyB3aGV0aGVyIHRoZSBlbGVtZW50IGlzIGluc3RhbmNlIG9mIEhUTUxFbGVtZW50LlxuICAgICAqXG4gICAgICogQHBhcmFtIGVsZW1lbnQgRWxlbWVudCB0byBjaGVjay5cbiAgICAgKi9cblxuICAgIGNvbnN0IGlzSHRtbEVsZW1lbnQgPSBlbGVtZW50ID0+IHtcbiAgICAgIHJldHVybiBlbGVtZW50IGluc3RhbmNlb2YgSFRNTEVsZW1lbnQ7XG4gICAgfTtcblxuICAgIHZhciBDc3NQcm9wZXJ0eTtcblxuICAgIChmdW5jdGlvbiAoQ3NzUHJvcGVydHkpIHtcbiAgICAgIENzc1Byb3BlcnR5W1wiQmFja2dyb3VuZFwiXSA9IFwiYmFja2dyb3VuZFwiO1xuICAgICAgQ3NzUHJvcGVydHlbXCJCYWNrZ3JvdW5kSW1hZ2VcIl0gPSBcImJhY2tncm91bmQtaW1hZ2VcIjtcbiAgICAgIENzc1Byb3BlcnR5W1wiQ29udGVudFwiXSA9IFwiY29udGVudFwiO1xuICAgICAgQ3NzUHJvcGVydHlbXCJPcGFjaXR5XCJdID0gXCJvcGFjaXR5XCI7XG4gICAgfSkoQ3NzUHJvcGVydHkgfHwgKENzc1Byb3BlcnR5ID0ge30pKTtcblxuICAgIGNvbnN0IFJFR0VYUF9BTllfU1lNQk9MID0gJy4qJztcbiAgICBjb25zdCBSRUdFWFBfV0lUSF9GTEFHU19SRUdFWFAgPSAvXlxccypcXC8uKlxcL1tnbWlzdXldKlxccyokLztcblxuICAgIC8qKlxuICAgICAqIFJlbW92ZXMgcXVvdGVzIGZvciBzcGVjaWZpZWQgY29udGVudCB2YWx1ZS5cbiAgICAgKlxuICAgICAqIEZvciBleGFtcGxlLCBjb250ZW50IHN0eWxlIGRlY2xhcmF0aW9uIHdpdGggYDo6YmVmb3JlYCBjYW4gYmUgc2V0IGFzICctJyAoZS5nLiB1bm9yZGVyZWQgbGlzdClcbiAgICAgKiB3aGljaCBkaXNwbGF5ZWQgYXMgc2ltcGxlIGRhc2ggYC1gIHdpdGggbm8gcXVvdGVzLlxuICAgICAqIEJ1dCBDU1NTdHlsZURlY2xhcmF0aW9uLmdldFByb3BlcnR5VmFsdWUoJ2NvbnRlbnQnKSB3aWxsIHJldHVybiB2YWx1ZVxuICAgICAqIHdyYXBwZWQgaW50byBxdW90ZXMsIGUuZy4gJ1wiLVwiJywgd2hpY2ggc2hvdWxkIGJlIHJlbW92ZWRcbiAgICAgKiBiZWNhdXNlIGZpbHRlcnMgbWFpbnRhaW5lcnMgZG9lcyBub3QgdXNlIGFueSBxdW90ZXMgaW4gcmVhbCBydWxlcy5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBzdHIgSW5wdXQgc3RyaW5nLlxuICAgICAqL1xuICAgIGNvbnN0IHJlbW92ZUNvbnRlbnRRdW90ZXMgPSBzdHIgPT4ge1xuICAgICAgcmV0dXJuIHN0ci5yZXBsYWNlKC9eKFtcIiddKShbXFxzXFxTXSopXFwxJC8sICckMicpO1xuICAgIH07XG4gICAgLyoqXG4gICAgICogQWRkcyBxdW90ZXMgZm9yIHNwZWNpZmllZCBiYWNrZ3JvdW5kIHVybCB2YWx1ZS5cbiAgICAgKlxuICAgICAqIElmIGJhY2tncm91bmQtaW1hZ2UgaXMgc3BlY2lmaWVkICoqd2l0aG91dCoqIHF1b3RlczpcbiAgICAgKiBlLmcuICdiYWNrZ3JvdW5kOiB1cmwoZGF0YTppbWFnZS9naWY7YmFzZTY0LFIwbEdPRGxoQVFBNyknLlxuICAgICAqXG4gICAgICogQ1NTU3R5bGVEZWNsYXJhdGlvbi5nZXRQcm9wZXJ0eVZhbHVlKCdiYWNrZ3JvdW5kLWltYWdlJykgbWF5IHJldHVybiB2YWx1ZSAqKndpdGgqKiBxdW90ZXM6XG4gICAgICogZS5nLiAnYmFja2dyb3VuZDogdXJsKFwiZGF0YTppbWFnZS9naWY7YmFzZTY0LFIwbEdPRGxoQVFBN1wiKScuXG4gICAgICpcbiAgICAgKiBTbyB3ZSBhZGQgcXVvdGVzIGZvciBjb21wYXRpYmlsaXR5IHNpbmNlIGZpbHRlcnMgbWFpbnRhaW5lcnMgbWlnaHQgdXNlIHF1b3RlcyBpbiByZWFsIHJ1bGVzLlxuICAgICAqXG4gICAgICogQHBhcmFtIHN0ciBJbnB1dCBzdHJpbmcuXG4gICAgICovXG5cblxuICAgIGNvbnN0IGFkZFVybFByb3BlcnR5UXVvdGVzID0gc3RyID0+IHtcbiAgICAgIGlmICghc3RyLmluY2x1ZGVzKCd1cmwoXCInKSkge1xuICAgICAgICBjb25zdCByZSA9IC91cmxcXCgoLio/KVxcKS9nO1xuICAgICAgICByZXR1cm4gc3RyLnJlcGxhY2UocmUsICd1cmwoXCIkMVwiKScpO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gc3RyO1xuICAgIH07XG4gICAgLyoqXG4gICAgICogQWRkcyBxdW90ZXMgdG8gdXJsIGFyZyBmb3IgY29uc2lzdGVudCBwcm9wZXJ0eSB2YWx1ZSBtYXRjaGluZy5cbiAgICAgKi9cblxuXG4gICAgY29uc3QgYWRkVXJsUXVvdGVzVG8gPSB7XG4gICAgICByZWdleHBBcmc6IHN0ciA9PiB7XG4gICAgICAgIC8vIGUuZy4gL151cmxcXFxcKFthLXpdezR9OlthLXpdezV9L1xuICAgICAgICAvLyBvciAvXnVybFxcXFwoZGF0YVxcXFw6XFxcXGltYWdlXFxcXC9naWY7YmFzZTY0LisvXG4gICAgICAgIGNvbnN0IHJlID0gLyhcXF4pP3VybChcXFxcKT9cXFxcXFwoKFxcd3xcXFtcXHcpL2c7XG4gICAgICAgIHJldHVybiBzdHIucmVwbGFjZShyZSwgJyQxdXJsJDJcXFxcKFxcXFxcIj8kMycpO1xuICAgICAgfSxcbiAgICAgIG5vbmVSZWdleHBBcmc6IGFkZFVybFByb3BlcnR5UXVvdGVzXG4gICAgfTtcbiAgICAvKipcbiAgICAgKiBFc2NhcGVzIHJlZ3VsYXIgZXhwcmVzc2lvbiBzdHJpbmcuXG4gICAgICpcbiAgICAgKiBAcGFyYW0gc3RyIElucHV0IHN0cmluZy5cbiAgICAgKi9cblxuICAgIGNvbnN0IGVzY2FwZVJlZ0V4cCA9IHN0ciA9PiB7XG4gICAgICAvLyBodHRwczovL2RldmVsb3Blci5tb3ppbGxhLm9yZy9lbi9KYXZhU2NyaXB0L1JlZmVyZW5jZS9HbG9iYWxfT2JqZWN0cy9yZWdleHBcbiAgICAgIC8vIHNob3VsZCBiZSBlc2NhcGVkIC4gKiArID8gXiAkIHsgfSAoICkgfCBbIF0gLyBcXFxuICAgICAgLy8gZXhjZXB0IG9mICogfCBeXG4gICAgICBjb25zdCBzcGVjaWFscyA9IFsnLicsICcrJywgJz8nLCAnJCcsICd7JywgJ30nLCAnKCcsICcpJywgJ1snLCAnXScsICdcXFxcJywgJy8nXTtcbiAgICAgIGNvbnN0IHNwZWNpYWxzUmVnZXggPSBuZXcgUmVnRXhwKFwiW1wiLmNvbmNhdChzcGVjaWFscy5qb2luKCdcXFxcJyksIFwiXVwiKSwgJ2cnKTtcbiAgICAgIHJldHVybiBzdHIucmVwbGFjZShzcGVjaWFsc1JlZ2V4LCAnXFxcXCQmJyk7XG4gICAgfTtcbiAgICAvKipcbiAgICAgKiBDb252ZXJ0cyA6bWF0Y2hlcy1jc3MoKSBhcmcgcHJvcGVydHkgdmFsdWUgbWF0Y2ggdG8gcmVnZXhwLlxuICAgICAqXG4gICAgICogQHBhcmFtIHJhd1ZhbHVlIFN0eWxlIG1hdGNoIHZhbHVlIHBhdHRlcm4uXG4gICAgICovXG5cblxuICAgIGNvbnN0IGNvbnZlcnRTdHlsZU1hdGNoVmFsdWVUb1JlZ2V4cCA9IHJhd1ZhbHVlID0+IHtcbiAgICAgIGxldCB2YWx1ZTtcblxuICAgICAgaWYgKHJhd1ZhbHVlLnN0YXJ0c1dpdGgoU0xBU0gpICYmIHJhd1ZhbHVlLmVuZHNXaXRoKFNMQVNIKSkge1xuICAgICAgICAvLyBGb3IgcmVnZXggcGF0dGVybnMgZG91YmxlIHF1b3RlcyBgXCJgIGFuZCBiYWNrc2xhc2hlcyBgXFxgIHNob3VsZCBiZSBlc2NhcGVkXG4gICAgICAgIHZhbHVlID0gYWRkVXJsUXVvdGVzVG8ucmVnZXhwQXJnKHJhd1ZhbHVlKTtcbiAgICAgICAgdmFsdWUgPSB2YWx1ZS5zbGljZSgxLCAtMSk7XG4gICAgICB9IGVsc2Uge1xuICAgICAgICAvLyBGb3Igbm9uLXJlZ2V4IHBhdHRlcm5zIHBhcmVudGhlc2VzIGAoYCBgKWAgYW5kIHNxdWFyZSBicmFja2V0cyBgW2AgYF1gXG4gICAgICAgIC8vIHNob3VsZCBiZSB1bmVzY2FwZWQsIGJlY2F1c2UgdGhlaXIgZXNjYXBpbmcgaW4gZmlsdGVyIHJ1bGVzIGlzIHJlcXVpcmVkXG4gICAgICAgIHZhbHVlID0gYWRkVXJsUXVvdGVzVG8ubm9uZVJlZ2V4cEFyZyhyYXdWYWx1ZSk7XG4gICAgICAgIHZhbHVlID0gdmFsdWUucmVwbGFjZSgvXFxcXChbXFxcXCgpW1xcXVwiXSkvZywgJyQxJyk7XG4gICAgICAgIHZhbHVlID0gZXNjYXBlUmVnRXhwKHZhbHVlKTsgLy8gZS5nLiBkaXY6bWF0Y2hlcy1jc3MoYmFja2dyb3VuZC1pbWFnZTogdXJsKGRhdGE6KikpXG5cbiAgICAgICAgdmFsdWUgPSByZXBsYWNlQWxsKHZhbHVlLCBBU1RFUklTSywgUkVHRVhQX0FOWV9TWU1CT0wpO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gbmV3IFJlZ0V4cCh2YWx1ZSwgJ2knKTtcbiAgICB9O1xuICAgIC8qKlxuICAgICAqIE1ha2VzIHNvbWUgcHJvcGVydGllcyB2YWx1ZXMgY29tcGF0aWJsZS5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBwcm9wZXJ0eU5hbWUgTmFtZSBvZiBzdHlsZSBwcm9wZXJ0eS5cbiAgICAgKiBAcGFyYW0gcHJvcGVydHlWYWx1ZSBWYWx1ZSBvZiBzdHlsZSBwcm9wZXJ0eS5cbiAgICAgKi9cblxuXG4gICAgY29uc3Qgbm9ybWFsaXplUHJvcGVydHlWYWx1ZSA9IChwcm9wZXJ0eU5hbWUsIHByb3BlcnR5VmFsdWUpID0+IHtcbiAgICAgIGxldCBub3JtYWxpemVkID0gJyc7XG5cbiAgICAgIHN3aXRjaCAocHJvcGVydHlOYW1lKSB7XG4gICAgICAgIGNhc2UgQ3NzUHJvcGVydHkuQmFja2dyb3VuZDpcbiAgICAgICAgY2FzZSBDc3NQcm9wZXJ0eS5CYWNrZ3JvdW5kSW1hZ2U6XG4gICAgICAgICAgLy8gc29tZXRpbWVzIHVybCBwcm9wZXJ0eSBkb2VzIG5vdCBoYXZlIHF1b3Rlc1xuICAgICAgICAgIC8vIHNvIHdlIGFkZCB0aGVtIGZvciBjb25zaXN0ZW50IG1hdGNoaW5nXG4gICAgICAgICAgbm9ybWFsaXplZCA9IGFkZFVybFByb3BlcnR5UXVvdGVzKHByb3BlcnR5VmFsdWUpO1xuICAgICAgICAgIGJyZWFrO1xuXG4gICAgICAgIGNhc2UgQ3NzUHJvcGVydHkuQ29udGVudDpcbiAgICAgICAgICBub3JtYWxpemVkID0gcmVtb3ZlQ29udGVudFF1b3Rlcyhwcm9wZXJ0eVZhbHVlKTtcbiAgICAgICAgICBicmVhaztcblxuICAgICAgICBjYXNlIENzc1Byb3BlcnR5Lk9wYWNpdHk6XG4gICAgICAgICAgLy8gaHR0cHM6Ly9idWdzLndlYmtpdC5vcmcvc2hvd19idWcuY2dpP2lkPTkzNDQ1XG4gICAgICAgICAgbm9ybWFsaXplZCA9IGlzU2FmYXJpQnJvd3NlciA/IChNYXRoLnJvdW5kKHBhcnNlRmxvYXQocHJvcGVydHlWYWx1ZSkgKiAxMDApIC8gMTAwKS50b1N0cmluZygpIDogcHJvcGVydHlWYWx1ZTtcbiAgICAgICAgICBicmVhaztcblxuICAgICAgICBkZWZhdWx0OlxuICAgICAgICAgIG5vcm1hbGl6ZWQgPSBwcm9wZXJ0eVZhbHVlO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gbm9ybWFsaXplZDtcbiAgICB9O1xuICAgIC8qKlxuICAgICAqIEdldHMgZG9tRWxlbWVudCBzdHlsZSBwcm9wZXJ0eSB2YWx1ZVxuICAgICAqIGJ5IGNzcyBwcm9wZXJ0eSBuYW1lIGFuZCBzdGFuZGFyZCBwc2V1ZG8tZWxlbWVudC5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBkb21FbGVtZW50IERPTSBlbGVtZW50LlxuICAgICAqIEBwYXJhbSBwcm9wZXJ0eU5hbWUgQ1NTIHByb3BlcnR5IG5hbWUuXG4gICAgICogQHBhcmFtIHJlZ3VsYXJQc2V1ZG9FbGVtZW50IFN0YW5kYXJkIHBzZXVkby1lbGVtZW50IOKAlCA6YmVmb3JlLCA6YWZ0ZXIgZXRjLlxuICAgICAqL1xuXG5cbiAgICBjb25zdCBnZXRDb21wdXRlZFN0eWxlUHJvcGVydHlWYWx1ZSA9IChkb21FbGVtZW50LCBwcm9wZXJ0eU5hbWUsIHJlZ3VsYXJQc2V1ZG9FbGVtZW50KSA9PiB7XG4gICAgICBjb25zdCBzdHlsZSA9IHdpbmRvdy5nZXRDb21wdXRlZFN0eWxlKGRvbUVsZW1lbnQsIHJlZ3VsYXJQc2V1ZG9FbGVtZW50KTtcbiAgICAgIGNvbnN0IHByb3BlcnR5VmFsdWUgPSBzdHlsZS5nZXRQcm9wZXJ0eVZhbHVlKHByb3BlcnR5TmFtZSk7XG4gICAgICByZXR1cm4gbm9ybWFsaXplUHJvcGVydHlWYWx1ZShwcm9wZXJ0eU5hbWUsIHByb3BlcnR5VmFsdWUpO1xuICAgIH07XG5cbiAgICAvKipcbiAgICAgKiBQYXJzZXMgYXJnIG9mIGFic29sdXRlIHBzZXVkby1jbGFzcyBpbnRvICduYW1lJyBhbmQgJ3ZhbHVlJyBpZiBzZXQuXG4gICAgICpcbiAgICAgKiBVc2VkIGZvciA6bWF0Y2hlcy1jc3MoKSAtIHdpdGggQ09MT04gYXMgc2VwYXJhdG9yLFxuICAgICAqIGZvciA6bWF0Y2hlcy1hdHRyKCkgYW5kIDptYXRjaGVzLXByb3BlcnR5KCkgLSB3aXRoIEVRVUFMX1NJR04gYXMgc2VwYXJhdG9yLlxuICAgICAqXG4gICAgICogQHBhcmFtIHBzZXVkb0FyZyBBcmcgb2YgcHNldWRvLWNsYXNzLlxuICAgICAqIEBwYXJhbSBzZXBhcmF0b3IgRGl2aWRlciBzeW1ib2wuXG4gICAgICovXG4gICAgY29uc3QgZ2V0UHNldWRvQXJnRGF0YSA9IChwc2V1ZG9BcmcsIHNlcGFyYXRvcikgPT4ge1xuICAgICAgY29uc3QgaW5kZXggPSBwc2V1ZG9BcmcuaW5kZXhPZihzZXBhcmF0b3IpO1xuICAgICAgbGV0IG5hbWU7XG4gICAgICBsZXQgdmFsdWU7XG5cbiAgICAgIGlmIChpbmRleCA+IC0xKSB7XG4gICAgICAgIG5hbWUgPSBwc2V1ZG9Bcmcuc3Vic3RyaW5nKDAsIGluZGV4KS50cmltKCk7XG4gICAgICAgIHZhbHVlID0gcHNldWRvQXJnLnN1YnN0cmluZyhpbmRleCArIDEpLnRyaW0oKTtcbiAgICAgIH0gZWxzZSB7XG4gICAgICAgIG5hbWUgPSBwc2V1ZG9Bcmc7XG4gICAgICB9XG5cbiAgICAgIHJldHVybiB7XG4gICAgICAgIG5hbWUsXG4gICAgICAgIHZhbHVlXG4gICAgICB9O1xuICAgIH07XG5cbiAgICAvKipcbiAgICAgKiBQYXJzZXMgOm1hdGNoZXMtY3NzKCkgcHNldWRvLWNsYXNzIGFyZ1xuICAgICAqIHdoZXJlIHJlZ3VsYXIgcHNldWRvLWVsZW1lbnQgY2FuIGJlIGEgcGFydCBvZiBhcmdcbiAgICAgKiBlLmcuICdkaXY6bWF0Y2hlcy1jc3MoYmVmb3JlLCBjb2xvcjogcmdiKDI1NSwgMjU1LCAyNTUpKScgICAgPC0tIG9ic29sZXRlIGA6bWF0Y2hlcy1jc3MtYmVmb3JlKClgLlxuICAgICAqXG4gICAgICogQHBhcmFtIHBzZXVkb05hbWUgUHNldWRvLWNsYXNzIG5hbWUuXG4gICAgICogQHBhcmFtIHJhd0FyZyBQc2V1ZG8tY2xhc3MgYXJnLlxuICAgICAqXG4gICAgICogQHRocm93cyBBbiBlcnJvciBvbiBpbnZhbGlkIGByYXdBcmdgLlxuICAgICAqL1xuICAgIGNvbnN0IHBhcnNlU3R5bGVNYXRjaEFyZyA9IChwc2V1ZG9OYW1lLCByYXdBcmcpID0+IHtcbiAgICAgIGNvbnN0IF9nZXRQc2V1ZG9BcmdEYXRhID0gZ2V0UHNldWRvQXJnRGF0YShyYXdBcmcsIENPTU1BKSxcbiAgICAgICAgICAgIG5hbWUgPSBfZ2V0UHNldWRvQXJnRGF0YS5uYW1lLFxuICAgICAgICAgICAgdmFsdWUgPSBfZ2V0UHNldWRvQXJnRGF0YS52YWx1ZTtcblxuICAgICAgbGV0IHJlZ3VsYXJQc2V1ZG9FbGVtZW50ID0gbmFtZTtcbiAgICAgIGxldCBzdHlsZU1hdGNoQXJnID0gdmFsdWU7IC8vIGNoZWNrIHdoZXRoZXIgdGhlIHN0cmluZyBwYXJ0IGJlZm9yZSB0aGUgc2VwYXJhdG9yIGlzIHZhbGlkIHJlZ3VsYXIgcHNldWRvLWVsZW1lbnQsXG4gICAgICAvLyBvdGhlcndpc2UgYHJlZ3VsYXJQc2V1ZG9FbGVtZW50YCBpcyBudWxsLCBhbmQgYHN0eWxlTWF0Y2hBcmdgIGlzIHJhd0FyZ1xuXG4gICAgICBpZiAoIU9iamVjdC52YWx1ZXMoUkVHVUxBUl9QU0VVRE9fRUxFTUVOVFMpLmluY2x1ZGVzKG5hbWUpKSB7XG4gICAgICAgIHJlZ3VsYXJQc2V1ZG9FbGVtZW50ID0gbnVsbDtcbiAgICAgICAgc3R5bGVNYXRjaEFyZyA9IHJhd0FyZztcbiAgICAgIH1cblxuICAgICAgaWYgKCFzdHlsZU1hdGNoQXJnKSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcihcIlJlcXVpcmVkIHN0eWxlIHByb3BlcnR5IGFyZ3VtZW50IHBhcnQgaXMgbWlzc2luZyBpbiA6XCIuY29uY2F0KHBzZXVkb05hbWUsIFwiKCkgYXJnOiAnXCIpLmNvbmNhdChyYXdBcmcsIFwiJ1wiKSk7XG4gICAgICB9XG5cbiAgICAgIHJldHVybiB7XG4gICAgICAgIHJlZ3VsYXJQc2V1ZG9FbGVtZW50LFxuICAgICAgICBzdHlsZU1hdGNoQXJnXG4gICAgICB9O1xuICAgIH07XG4gICAgLyoqXG4gICAgICogQ2hlY2tzIHdoZXRoZXIgdGhlIGRvbUVsZW1lbnQgaXMgbWF0Y2hlZCBieSA6bWF0Y2hlcy1jc3MoKSBhcmcuXG4gICAgICpcbiAgICAgKiBAcGFyYW0gYXJnc0RhdGEgUHNldWRvLWNsYXNzIG5hbWUsIGFyZywgYW5kIGRvbSBlbGVtZW50IHRvIGNoZWNrLlxuICAgICAqXG4gICAgICogQHRocm93cyBBbiBlcnJvciBvbiBpbnZhbGlkIHBzZXVkby1jbGFzcyBhcmcuXG4gICAgICovXG5cblxuICAgIGNvbnN0IGlzU3R5bGVNYXRjaGVkID0gYXJnc0RhdGEgPT4ge1xuICAgICAgY29uc3QgcHNldWRvTmFtZSA9IGFyZ3NEYXRhLnBzZXVkb05hbWUsXG4gICAgICAgICAgICBwc2V1ZG9BcmcgPSBhcmdzRGF0YS5wc2V1ZG9BcmcsXG4gICAgICAgICAgICBkb21FbGVtZW50ID0gYXJnc0RhdGEuZG9tRWxlbWVudDtcblxuICAgICAgY29uc3QgX3BhcnNlU3R5bGVNYXRjaEFyZyA9IHBhcnNlU3R5bGVNYXRjaEFyZyhwc2V1ZG9OYW1lLCBwc2V1ZG9BcmcpLFxuICAgICAgICAgICAgcmVndWxhclBzZXVkb0VsZW1lbnQgPSBfcGFyc2VTdHlsZU1hdGNoQXJnLnJlZ3VsYXJQc2V1ZG9FbGVtZW50LFxuICAgICAgICAgICAgc3R5bGVNYXRjaEFyZyA9IF9wYXJzZVN0eWxlTWF0Y2hBcmcuc3R5bGVNYXRjaEFyZztcblxuICAgICAgY29uc3QgX2dldFBzZXVkb0FyZ0RhdGEyID0gZ2V0UHNldWRvQXJnRGF0YShzdHlsZU1hdGNoQXJnLCBDT0xPTiksXG4gICAgICAgICAgICBtYXRjaE5hbWUgPSBfZ2V0UHNldWRvQXJnRGF0YTIubmFtZSxcbiAgICAgICAgICAgIG1hdGNoVmFsdWUgPSBfZ2V0UHNldWRvQXJnRGF0YTIudmFsdWU7XG5cbiAgICAgIGlmICghbWF0Y2hOYW1lIHx8ICFtYXRjaFZhbHVlKSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcihcIlJlcXVpcmVkIHByb3BlcnR5IG5hbWUgb3IgdmFsdWUgaXMgbWlzc2luZyBpbiA6XCIuY29uY2F0KHBzZXVkb05hbWUsIFwiKCkgYXJnOiAnXCIpLmNvbmNhdChzdHlsZU1hdGNoQXJnLCBcIidcIikpO1xuICAgICAgfVxuXG4gICAgICBsZXQgdmFsdWVSZWdleHA7XG5cbiAgICAgIHRyeSB7XG4gICAgICAgIHZhbHVlUmVnZXhwID0gY29udmVydFN0eWxlTWF0Y2hWYWx1ZVRvUmVnZXhwKG1hdGNoVmFsdWUpO1xuICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICBsb2dnZXIuZXJyb3IoZSk7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcihcIkludmFsaWQgYXJndW1lbnQgb2YgOlwiLmNvbmNhdChwc2V1ZG9OYW1lLCBcIigpIHBzZXVkby1jbGFzczogJ1wiKS5jb25jYXQoc3R5bGVNYXRjaEFyZywgXCInXCIpKTtcbiAgICAgIH1cblxuICAgICAgY29uc3QgdmFsdWUgPSBnZXRDb21wdXRlZFN0eWxlUHJvcGVydHlWYWx1ZShkb21FbGVtZW50LCBtYXRjaE5hbWUsIHJlZ3VsYXJQc2V1ZG9FbGVtZW50KTtcbiAgICAgIHJldHVybiB2YWx1ZVJlZ2V4cCAmJiB2YWx1ZVJlZ2V4cC50ZXN0KHZhbHVlKTtcbiAgICB9O1xuICAgIC8qKlxuICAgICAqIFZhbGlkYXRlcyBzdHJpbmcgYXJnIGZvciA6bWF0Y2hlcy1hdHRyKCkgYW5kIDptYXRjaGVzLXByb3BlcnR5KCkuXG4gICAgICpcbiAgICAgKiBAcGFyYW0gYXJnIFBzZXVkby1jbGFzcyBhcmcuXG4gICAgICovXG5cbiAgICBjb25zdCB2YWxpZGF0ZVN0ck1hdGNoZXJBcmcgPSBhcmcgPT4ge1xuICAgICAgaWYgKGFyZy5pbmNsdWRlcyhTTEFTSCkpIHtcbiAgICAgICAgcmV0dXJuIGZhbHNlO1xuICAgICAgfVxuXG4gICAgICBpZiAoIS9eW1xcdy1dKyQvLnRlc3QoYXJnKSkge1xuICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICB9XG5cbiAgICAgIHJldHVybiB0cnVlO1xuICAgIH07XG4gICAgLyoqXG4gICAgICogUmV0dXJucyB2YWxpZCBhcmcgZm9yIDptYXRjaGVzLWF0dHIgYW5kIDptYXRjaGVyLXByb3BlcnR5LlxuICAgICAqXG4gICAgICogQHBhcmFtIHJhd0FyZyBBcmcgcGF0dGVybi5cbiAgICAgKiBAcGFyYW0gW2lzV2lsZGNhcmRBbGxvd2VkPWZhbHNlXSBGbGFnIGZvciB3aWxkY2FyZCAoYCpgKSB1c2luZyBhcyBwc2V1ZG8tY2xhc3MgYXJnLlxuICAgICAqXG4gICAgICogQHRocm93cyBBbiBlcnJvciBvbiBpbnZhbGlkIGByYXdBcmdgLlxuICAgICAqL1xuXG5cbiAgICBjb25zdCBnZXRWYWxpZE1hdGNoZXJBcmcgPSBmdW5jdGlvbiBnZXRWYWxpZE1hdGNoZXJBcmcocmF3QXJnKSB7XG4gICAgICBsZXQgaXNXaWxkY2FyZEFsbG93ZWQgPSBhcmd1bWVudHMubGVuZ3RoID4gMSAmJiBhcmd1bWVudHNbMV0gIT09IHVuZGVmaW5lZCA/IGFyZ3VtZW50c1sxXSA6IGZhbHNlO1xuICAgICAgLy8gaWYgcmF3QXJnIGlzIG1pc3NpbmcgZm9yIHBzZXVkby1jbGFzc1xuICAgICAgLy8gZS5nLiA6bWF0Y2hlcy1hdHRyKClcbiAgICAgIC8vIGVycm9yIHdpbGwgYmUgdGhyb3duIGJlZm9yZSBnZXRWYWxpZE1hdGNoZXJBcmcoKSBpcyBjYWxsZWQ6XG4gICAgICAvLyBuYW1lIG9yIGFyZyBpcyBtaXNzaW5nIGluIEFic29sdXRlUHNldWRvQ2xhc3NcbiAgICAgIGxldCBhcmc7XG5cbiAgICAgIGlmIChyYXdBcmcubGVuZ3RoID4gMSAmJiByYXdBcmcuc3RhcnRzV2l0aChET1VCTEVfUVVPVEUpICYmIHJhd0FyZy5lbmRzV2l0aChET1VCTEVfUVVPVEUpKSB7XG4gICAgICAgIHJhd0FyZyA9IHJhd0FyZy5zbGljZSgxLCAtMSk7XG4gICAgICB9XG5cbiAgICAgIGlmIChyYXdBcmcgPT09ICcnKSB7XG4gICAgICAgIC8vIGUuZy4gOm1hdGNoZXMtcHJvcGVydHkoXCJcIilcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKCdBcmd1bWVudCBzaG91bGQgYmUgc3BlY2lmaWVkLiBFbXB0eSBhcmcgaXMgaW52YWxpZC4nKTtcbiAgICAgIH1cblxuICAgICAgaWYgKHJhd0FyZy5zdGFydHNXaXRoKFNMQVNIKSAmJiByYXdBcmcuZW5kc1dpdGgoU0xBU0gpKSB7XG4gICAgICAgIC8vIGUuZy4gOm1hdGNoZXMtcHJvcGVydHkoXCIvL1wiKVxuICAgICAgICBpZiAocmF3QXJnLmxlbmd0aCA+IDIpIHtcbiAgICAgICAgICBhcmcgPSB0b1JlZ0V4cChyYXdBcmcpO1xuICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgIHRocm93IG5ldyBFcnJvcihcIkludmFsaWQgcmVnZXhwOiAnXCIuY29uY2F0KHJhd0FyZywgXCInXCIpKTtcbiAgICAgICAgfVxuICAgICAgfSBlbHNlIGlmIChyYXdBcmcuaW5jbHVkZXMoQVNURVJJU0spKSB7XG4gICAgICAgIGlmIChyYXdBcmcgPT09IEFTVEVSSVNLICYmICFpc1dpbGRjYXJkQWxsb3dlZCkge1xuICAgICAgICAgIC8vIGUuZy4gOm1hdGNoZXMtYXR0cigqKVxuICAgICAgICAgIHRocm93IG5ldyBFcnJvcihcIkFyZ3VtZW50IHNob3VsZCBiZSBtb3JlIHNwZWNpZmljIHRoYW4gXCIuY29uY2F0KHJhd0FyZykpO1xuICAgICAgICB9XG5cbiAgICAgICAgYXJnID0gcmVwbGFjZUFsbChyYXdBcmcsIEFTVEVSSVNLLCBSRUdFWFBfQU5ZX1NZTUJPTCk7XG4gICAgICAgIGFyZyA9IG5ldyBSZWdFeHAoYXJnKTtcbiAgICAgIH0gZWxzZSB7XG4gICAgICAgIGlmICghdmFsaWRhdGVTdHJNYXRjaGVyQXJnKHJhd0FyZykpIHtcbiAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJJbnZhbGlkIGFyZ3VtZW50OiAnXCIuY29uY2F0KHJhd0FyZywgXCInXCIpKTtcbiAgICAgICAgfVxuXG4gICAgICAgIGFyZyA9IHJhd0FyZztcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIGFyZztcbiAgICB9O1xuXG4gICAgLyoqXG4gICAgICogUGFyc2VzIHBzZXVkby1jbGFzcyBhcmd1bWVudCBhbmQgcmV0dXJucyBwYXJzZWQgZGF0YS5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBwc2V1ZG9OYW1lIEV4dGVuZGVkIHBzZXVkby1jbGFzcyBuYW1lLlxuICAgICAqIEBwYXJhbSBwc2V1ZG9BcmcgRXh0ZW5kZWQgcHNldWRvLWNsYXNzIGFyZ3VtZW50LlxuICAgICAqXG4gICAgICogQHRocm93cyBBbiBlcnJvciBpZiBhdHRyaWJ1dGUgbmFtZSBpcyBtaXNzaW5nIGluIHBzZXVkby1jbGFzcyBhcmcuXG4gICAgICovXG4gICAgY29uc3QgZ2V0UmF3TWF0Y2hpbmdEYXRhID0gKHBzZXVkb05hbWUsIHBzZXVkb0FyZykgPT4ge1xuICAgICAgY29uc3QgX2dldFBzZXVkb0FyZ0RhdGEzID0gZ2V0UHNldWRvQXJnRGF0YShwc2V1ZG9BcmcsIEVRVUFMX1NJR04pLFxuICAgICAgICAgICAgcmF3TmFtZSA9IF9nZXRQc2V1ZG9BcmdEYXRhMy5uYW1lLFxuICAgICAgICAgICAgcmF3VmFsdWUgPSBfZ2V0UHNldWRvQXJnRGF0YTMudmFsdWU7XG5cbiAgICAgIGlmICghcmF3TmFtZSkge1xuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJSZXF1aXJlZCBhdHRyaWJ1dGUgbmFtZSBpcyBtaXNzaW5nIGluIDpcIi5jb25jYXQocHNldWRvTmFtZSwgXCIgYXJnOiBcIikuY29uY2F0KHBzZXVkb0FyZykpO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4ge1xuICAgICAgICByYXdOYW1lLFxuICAgICAgICByYXdWYWx1ZVxuICAgICAgfTtcbiAgICB9O1xuICAgIC8qKlxuICAgICAqIENoZWNrcyB3aGV0aGVyIHRoZSBkb21FbGVtZW50IGlzIG1hdGNoZWQgYnkgOm1hdGNoZXMtYXR0cigpIGFyZy5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBhcmdzRGF0YSBQc2V1ZG8tY2xhc3MgbmFtZSwgYXJnLCBhbmQgZG9tIGVsZW1lbnQgdG8gY2hlY2suXG4gICAgICpcbiAgICAgKiBAdGhyb3dzIEFuIGVycm9yIG9uIGludmFsaWQgYXJnIG9mIHBzZXVkby1jbGFzcy5cbiAgICAgKi9cblxuICAgIGNvbnN0IGlzQXR0cmlidXRlTWF0Y2hlZCA9IGFyZ3NEYXRhID0+IHtcbiAgICAgIGNvbnN0IHBzZXVkb05hbWUgPSBhcmdzRGF0YS5wc2V1ZG9OYW1lLFxuICAgICAgICAgICAgcHNldWRvQXJnID0gYXJnc0RhdGEucHNldWRvQXJnLFxuICAgICAgICAgICAgZG9tRWxlbWVudCA9IGFyZ3NEYXRhLmRvbUVsZW1lbnQ7XG4gICAgICBjb25zdCBlbGVtZW50QXR0cmlidXRlcyA9IGRvbUVsZW1lbnQuYXR0cmlidXRlczsgLy8gbm8gbWF0Y2ggaWYgZG9tIGVsZW1lbnQgaGFzIG5vIGF0dHJpYnV0ZXNcblxuICAgICAgaWYgKGVsZW1lbnRBdHRyaWJ1dGVzLmxlbmd0aCA9PT0gMCkge1xuICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICB9XG5cbiAgICAgIGNvbnN0IF9nZXRSYXdNYXRjaGluZ0RhdGEgPSBnZXRSYXdNYXRjaGluZ0RhdGEocHNldWRvTmFtZSwgcHNldWRvQXJnKSxcbiAgICAgICAgICAgIHJhd0F0dHJOYW1lID0gX2dldFJhd01hdGNoaW5nRGF0YS5yYXdOYW1lLFxuICAgICAgICAgICAgcmF3QXR0clZhbHVlID0gX2dldFJhd01hdGNoaW5nRGF0YS5yYXdWYWx1ZTtcblxuICAgICAgbGV0IGF0dHJOYW1lTWF0Y2g7XG5cbiAgICAgIHRyeSB7XG4gICAgICAgIGF0dHJOYW1lTWF0Y2ggPSBnZXRWYWxpZE1hdGNoZXJBcmcocmF3QXR0ck5hbWUpO1xuICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICAvLyBlc2xpbnQtZGlzYWJsZS1saW5lIEB0eXBlc2NyaXB0LWVzbGludC9uby1leHBsaWNpdC1hbnlcbiAgICAgICAgbG9nZ2VyLmVycm9yKGUpO1xuICAgICAgICB0aHJvdyBuZXcgU3ludGF4RXJyb3IoZS5tZXNzYWdlKTtcbiAgICAgIH1cblxuICAgICAgbGV0IGlzTWF0Y2hlZCA9IGZhbHNlO1xuICAgICAgbGV0IGkgPSAwO1xuXG4gICAgICB3aGlsZSAoaSA8IGVsZW1lbnRBdHRyaWJ1dGVzLmxlbmd0aCAmJiAhaXNNYXRjaGVkKSB7XG4gICAgICAgIGNvbnN0IGF0dHIgPSBlbGVtZW50QXR0cmlidXRlc1tpXTtcbiAgICAgICAgY29uc3QgaXNOYW1lTWF0Y2hlZCA9IGF0dHJOYW1lTWF0Y2ggaW5zdGFuY2VvZiBSZWdFeHAgPyBhdHRyTmFtZU1hdGNoLnRlc3QoYXR0ci5uYW1lKSA6IGF0dHJOYW1lTWF0Y2ggPT09IGF0dHIubmFtZTtcblxuICAgICAgICBpZiAoIXJhd0F0dHJWYWx1ZSkge1xuICAgICAgICAgIC8vIGZvciBydWxlcyB3aXRoIG5vIGF0dHJpYnV0ZSB2YWx1ZSBzcGVjaWZpZWRcbiAgICAgICAgICAvLyBlLmcuIDptYXRjaGVzLWF0dHIoXCIvcmVnZXgvXCIpIG9yIDptYXRjaGVzLWF0dHIoXCJhdHRyLW5hbWVcIilcbiAgICAgICAgICBpc01hdGNoZWQgPSBpc05hbWVNYXRjaGVkO1xuICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgIGxldCBhdHRyVmFsdWVNYXRjaDtcblxuICAgICAgICAgIHRyeSB7XG4gICAgICAgICAgICBhdHRyVmFsdWVNYXRjaCA9IGdldFZhbGlkTWF0Y2hlckFyZyhyYXdBdHRyVmFsdWUpO1xuICAgICAgICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgICAgICAgIC8vIGVzbGludC1kaXNhYmxlLWxpbmUgQHR5cGVzY3JpcHQtZXNsaW50L25vLWV4cGxpY2l0LWFueVxuICAgICAgICAgICAgbG9nZ2VyLmVycm9yKGUpO1xuICAgICAgICAgICAgdGhyb3cgbmV3IFN5bnRheEVycm9yKGUubWVzc2FnZSk7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgY29uc3QgaXNWYWx1ZU1hdGNoZWQgPSBhdHRyVmFsdWVNYXRjaCBpbnN0YW5jZW9mIFJlZ0V4cCA/IGF0dHJWYWx1ZU1hdGNoLnRlc3QoYXR0ci52YWx1ZSkgOiBhdHRyVmFsdWVNYXRjaCA9PT0gYXR0ci52YWx1ZTtcbiAgICAgICAgICBpc01hdGNoZWQgPSBpc05hbWVNYXRjaGVkICYmIGlzVmFsdWVNYXRjaGVkO1xuICAgICAgICB9XG5cbiAgICAgICAgaSArPSAxO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gaXNNYXRjaGVkO1xuICAgIH07XG4gICAgLyoqXG4gICAgICogUGFyc2VzIHJhdyA6bWF0Y2hlcy1wcm9wZXJ0eSgpIGFyZyB3aGljaCBtYXkgYmUgY2hhaW4gb2YgcHJvcGVydGllcy5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBpbnB1dCBBcmd1bWVudCBvZiA6bWF0Y2hlcy1wcm9wZXJ0eSgpLlxuICAgICAqXG4gICAgICogQHRocm93cyBBbiBlcnJvciBvbiBpbnZhbGlkIGNoYWluLlxuICAgICAqL1xuXG4gICAgY29uc3QgcGFyc2VSYXdQcm9wQ2hhaW4gPSBpbnB1dCA9PiB7XG4gICAgICBpZiAoaW5wdXQubGVuZ3RoID4gMSAmJiBpbnB1dC5zdGFydHNXaXRoKERPVUJMRV9RVU9URSkgJiYgaW5wdXQuZW5kc1dpdGgoRE9VQkxFX1FVT1RFKSkge1xuICAgICAgICBpbnB1dCA9IGlucHV0LnNsaWNlKDEsIC0xKTtcbiAgICAgIH1cblxuICAgICAgY29uc3QgY2hhaW5DaHVua3MgPSBpbnB1dC5zcGxpdChET1QpO1xuICAgICAgY29uc3QgY2hhaW5QYXR0ZXJucyA9IFtdO1xuICAgICAgbGV0IHBhdHRlcm5CdWZmZXIgPSAnJztcbiAgICAgIGxldCBpc1JlZ2V4cFBhdHRlcm4gPSBmYWxzZTtcbiAgICAgIGxldCBpID0gMDtcblxuICAgICAgd2hpbGUgKGkgPCBjaGFpbkNodW5rcy5sZW5ndGgpIHtcbiAgICAgICAgY29uc3QgY2h1bmsgPSBjaGFpbkNodW5rc1tpXTtcblxuICAgICAgICBpZiAoY2h1bmsuc3RhcnRzV2l0aChTTEFTSCkgJiYgY2h1bmsuZW5kc1dpdGgoU0xBU0gpICYmIGNodW5rLmxlbmd0aCA+IDIpIHtcbiAgICAgICAgICAvLyByZWdleHAgcGF0dGVybiB3aXRoIG5vIGRvdCBpbiBpdCwgZS5nLiAvcHJvcE5hbWUvXG4gICAgICAgICAgY2hhaW5QYXR0ZXJucy5wdXNoKGNodW5rKTtcbiAgICAgICAgfSBlbHNlIGlmIChjaHVuay5zdGFydHNXaXRoKFNMQVNIKSkge1xuICAgICAgICAgIC8vIGlmIGNodW5rIGlzIGEgc3RhcnQgb2YgcmVnZXhwIHBhdHRlcm5cbiAgICAgICAgICBpc1JlZ2V4cFBhdHRlcm4gPSB0cnVlO1xuICAgICAgICAgIHBhdHRlcm5CdWZmZXIgKz0gY2h1bms7XG4gICAgICAgIH0gZWxzZSBpZiAoY2h1bmsuZW5kc1dpdGgoU0xBU0gpKSB7XG4gICAgICAgICAgaXNSZWdleHBQYXR0ZXJuID0gZmFsc2U7IC8vIHJlc3RvcmUgZG90IHJlbW92ZWQgd2hpbGUgc3BsaXR0aW5nXG4gICAgICAgICAgLy8gZS5nLiB0ZXN0UHJvcC4vLnsxLDV9L1xuXG4gICAgICAgICAgcGF0dGVybkJ1ZmZlciArPSBcIi5cIi5jb25jYXQoY2h1bmspO1xuICAgICAgICAgIGNoYWluUGF0dGVybnMucHVzaChwYXR0ZXJuQnVmZmVyKTtcbiAgICAgICAgICBwYXR0ZXJuQnVmZmVyID0gJyc7XG4gICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgLy8gaWYgdGhlcmUgYXJlIGZldyBkb3RzIGluIHJlZ2V4cCBwYXR0ZXJuXG4gICAgICAgICAgLy8gc28gY2h1bmsgbWlnaHQgYmUgaW4gdGhlIG1pZGRsZSBvZiBpdFxuICAgICAgICAgIGlmIChpc1JlZ2V4cFBhdHRlcm4pIHtcbiAgICAgICAgICAgIHBhdHRlcm5CdWZmZXIgKz0gY2h1bms7XG4gICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIC8vIG90aGVyd2lzZSBpdCBpcyBzdHJpbmcgcGF0dGVyblxuICAgICAgICAgICAgY2hhaW5QYXR0ZXJucy5wdXNoKGNodW5rKTtcbiAgICAgICAgICB9XG4gICAgICAgIH1cblxuICAgICAgICBpICs9IDE7XG4gICAgICB9XG5cbiAgICAgIGlmIChwYXR0ZXJuQnVmZmVyLmxlbmd0aCA+IDApIHtcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiSW52YWxpZCByZWdleHAgcHJvcGVydHkgcGF0dGVybiAnXCIuY29uY2F0KGlucHV0LCBcIidcIikpO1xuICAgICAgfVxuXG4gICAgICBjb25zdCBjaGFpbk1hdGNoUGF0dGVybnMgPSBjaGFpblBhdHRlcm5zLm1hcChwYXR0ZXJuID0+IHtcbiAgICAgICAgaWYgKHBhdHRlcm4ubGVuZ3RoID09PSAwKSB7XG4gICAgICAgICAgLy8gZS5nLiAnLnByb3AuaWQnIG9yICduZXN0ZWQuLnRlc3QnXG4gICAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiRW1wdHkgcGF0dGVybiAnXCIuY29uY2F0KHBhdHRlcm4sIFwiJyBpcyBpbnZhbGlkIGluIGNoYWluICdcIikuY29uY2F0KGlucHV0LCBcIidcIikpO1xuICAgICAgICB9XG5cbiAgICAgICAgbGV0IHZhbGlkUGF0dGVybjtcblxuICAgICAgICB0cnkge1xuICAgICAgICAgIHZhbGlkUGF0dGVybiA9IGdldFZhbGlkTWF0Y2hlckFyZyhwYXR0ZXJuLCB0cnVlKTtcbiAgICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICAgIGxvZ2dlci5lcnJvcihlKTtcbiAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJJbnZhbGlkIHByb3BlcnR5IHBhdHRlcm4gJ1wiLmNvbmNhdChwYXR0ZXJuLCBcIicgaW4gcHJvcGVydHkgY2hhaW4gJ1wiKS5jb25jYXQoaW5wdXQsIFwiJ1wiKSk7XG4gICAgICAgIH1cblxuICAgICAgICByZXR1cm4gdmFsaWRQYXR0ZXJuO1xuICAgICAgfSk7XG4gICAgICByZXR1cm4gY2hhaW5NYXRjaFBhdHRlcm5zO1xuICAgIH07XG5cbiAgICAvKipcbiAgICAgKiBDaGVja3MgaWYgdGhlIHByb3BlcnR5IGV4aXN0cyBpbiB0aGUgYmFzZSBvYmplY3QgKHJlY3Vyc2l2ZWx5KS5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBiYXNlIEVsZW1lbnQgdG8gY2hlY2suXG4gICAgICogQHBhcmFtIGNoYWluIEFycmF5IG9mIG9iamVjdHMgLSBwYXJzZWQgc3RyaW5nIHByb3BlcnR5IGNoYWluLlxuICAgICAqIEBwYXJhbSBbb3V0cHV0PVtdXSBSZXN1bHQgYWNjLlxuICAgICAqL1xuICAgIGNvbnN0IGZpbHRlclJvb3RzQnlSZWdleHBDaGFpbiA9IGZ1bmN0aW9uIGZpbHRlclJvb3RzQnlSZWdleHBDaGFpbihiYXNlLCBjaGFpbikge1xuICAgICAgbGV0IG91dHB1dCA9IGFyZ3VtZW50cy5sZW5ndGggPiAyICYmIGFyZ3VtZW50c1syXSAhPT0gdW5kZWZpbmVkID8gYXJndW1lbnRzWzJdIDogW107XG4gICAgICBjb25zdCB0ZW1wUHJvcCA9IGNoYWluWzBdO1xuXG4gICAgICBpZiAoY2hhaW4ubGVuZ3RoID09PSAxKSB7XG4gICAgICAgIGxldCBrZXk7XG5cbiAgICAgICAgZm9yIChrZXkgaW4gYmFzZSkge1xuICAgICAgICAgIGlmICh0ZW1wUHJvcCBpbnN0YW5jZW9mIFJlZ0V4cCkge1xuICAgICAgICAgICAgaWYgKHRlbXBQcm9wLnRlc3Qoa2V5KSkge1xuICAgICAgICAgICAgICBvdXRwdXQucHVzaCh7XG4gICAgICAgICAgICAgICAgYmFzZSxcbiAgICAgICAgICAgICAgICBwcm9wOiBrZXksXG4gICAgICAgICAgICAgICAgdmFsdWU6IGJhc2Vba2V5XVxuICAgICAgICAgICAgICB9KTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9IGVsc2UgaWYgKHRlbXBQcm9wID09PSBrZXkpIHtcbiAgICAgICAgICAgIG91dHB1dC5wdXNoKHtcbiAgICAgICAgICAgICAgYmFzZSxcbiAgICAgICAgICAgICAgcHJvcDogdGVtcFByb3AsXG4gICAgICAgICAgICAgIHZhbHVlOiBiYXNlW2tleV1cbiAgICAgICAgICAgIH0pO1xuICAgICAgICAgIH1cbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiBvdXRwdXQ7XG4gICAgICB9IC8vIGlmIHRoZXJlIGlzIGEgcmVnZXhwIHByb3AgaW4gaW5wdXQgY2hhaW5cbiAgICAgIC8vIGUuZy4gJ3VuaXQuL15hZC4rLy5zcmMnIGZvciAndW5pdC5hZC0xZ2YyLnNyYyB1bml0LmFkLWZnZDM0LnNyYycpLFxuICAgICAgLy8gZXZlcnkgYmFzZSBrZXlzIHNob3VsZCBiZSB0ZXN0ZWQgYnkgcmVnZXhwIGFuZCBpdCBjYW4gYmUgbW9yZSB0aGF0IG9uZSByZXN1bHRzXG5cblxuICAgICAgaWYgKHRlbXBQcm9wIGluc3RhbmNlb2YgUmVnRXhwKSB7XG4gICAgICAgIGNvbnN0IG5leHRQcm9wID0gY2hhaW4uc2xpY2UoMSk7XG4gICAgICAgIGNvbnN0IGJhc2VLZXlzID0gW107XG5cbiAgICAgICAgZm9yIChjb25zdCBrZXkgaW4gYmFzZSkge1xuICAgICAgICAgIGlmICh0ZW1wUHJvcC50ZXN0KGtleSkpIHtcbiAgICAgICAgICAgIGJhc2VLZXlzLnB1c2goa2V5KTtcbiAgICAgICAgICB9XG4gICAgICAgIH1cblxuICAgICAgICBiYXNlS2V5cy5mb3JFYWNoKGtleSA9PiB7XG4gICAgICAgICAgdmFyIF9PYmplY3QkZ2V0T3duUHJvcGVydDtcblxuICAgICAgICAgIGNvbnN0IGl0ZW0gPSAoX09iamVjdCRnZXRPd25Qcm9wZXJ0ID0gT2JqZWN0LmdldE93blByb3BlcnR5RGVzY3JpcHRvcihiYXNlLCBrZXkpKSA9PT0gbnVsbCB8fCBfT2JqZWN0JGdldE93blByb3BlcnQgPT09IHZvaWQgMCA/IHZvaWQgMCA6IF9PYmplY3QkZ2V0T3duUHJvcGVydC52YWx1ZTtcbiAgICAgICAgICBmaWx0ZXJSb290c0J5UmVnZXhwQ2hhaW4oaXRlbSwgbmV4dFByb3AsIG91dHB1dCk7XG4gICAgICAgIH0pO1xuICAgICAgfVxuXG4gICAgICBpZiAoYmFzZSAmJiB0eXBlb2YgdGVtcFByb3AgPT09ICdzdHJpbmcnKSB7XG4gICAgICAgIHZhciBfT2JqZWN0JGdldE93blByb3BlcnQyO1xuXG4gICAgICAgIGNvbnN0IG5leHRCYXNlID0gKF9PYmplY3QkZ2V0T3duUHJvcGVydDIgPSBPYmplY3QuZ2V0T3duUHJvcGVydHlEZXNjcmlwdG9yKGJhc2UsIHRlbXBQcm9wKSkgPT09IG51bGwgfHwgX09iamVjdCRnZXRPd25Qcm9wZXJ0MiA9PT0gdm9pZCAwID8gdm9pZCAwIDogX09iamVjdCRnZXRPd25Qcm9wZXJ0Mi52YWx1ZTtcbiAgICAgICAgY2hhaW4gPSBjaGFpbi5zbGljZSgxKTtcblxuICAgICAgICBpZiAobmV4dEJhc2UgIT09IHVuZGVmaW5lZCkge1xuICAgICAgICAgIGZpbHRlclJvb3RzQnlSZWdleHBDaGFpbihuZXh0QmFzZSwgY2hhaW4sIG91dHB1dCk7XG4gICAgICAgIH1cbiAgICAgIH1cblxuICAgICAgcmV0dXJuIG91dHB1dDtcbiAgICB9O1xuICAgIC8qKlxuICAgICAqIENoZWNrcyB3aGV0aGVyIHRoZSBkb21FbGVtZW50IGlzIG1hdGNoZWQgYnkgOm1hdGNoZXMtcHJvcGVydHkoKSBhcmcuXG4gICAgICpcbiAgICAgKiBAcGFyYW0gYXJnc0RhdGEgUHNldWRvLWNsYXNzIG5hbWUsIGFyZywgYW5kIGRvbSBlbGVtZW50IHRvIGNoZWNrLlxuICAgICAqXG4gICAgICogQHRocm93cyBBbiBlcnJvciBvbiBpbnZhbGlkIHByb3AgaW4gY2hhaW4uXG4gICAgICovXG5cblxuICAgIGNvbnN0IGlzUHJvcGVydHlNYXRjaGVkID0gYXJnc0RhdGEgPT4ge1xuICAgICAgY29uc3QgcHNldWRvTmFtZSA9IGFyZ3NEYXRhLnBzZXVkb05hbWUsXG4gICAgICAgICAgICBwc2V1ZG9BcmcgPSBhcmdzRGF0YS5wc2V1ZG9BcmcsXG4gICAgICAgICAgICBkb21FbGVtZW50ID0gYXJnc0RhdGEuZG9tRWxlbWVudDtcblxuICAgICAgY29uc3QgX2dldFJhd01hdGNoaW5nRGF0YTIgPSBnZXRSYXdNYXRjaGluZ0RhdGEocHNldWRvTmFtZSwgcHNldWRvQXJnKSxcbiAgICAgICAgICAgIHJhd1Byb3BlcnR5TmFtZSA9IF9nZXRSYXdNYXRjaGluZ0RhdGEyLnJhd05hbWUsXG4gICAgICAgICAgICByYXdQcm9wZXJ0eVZhbHVlID0gX2dldFJhd01hdGNoaW5nRGF0YTIucmF3VmFsdWU7IC8vIGNoYWluZWQgcHJvcGVydHkgbmFtZSBjYW4gbm90IGluY2x1ZGUgJy8nIG9yICcuJ1xuICAgICAgLy8gc28gcmVnZXggcHJvcCBuYW1lcyB3aXRoIHN1Y2ggZXNjYXBlZCBjaGFyYWN0ZXJzIGFyZSBpbnZhbGlkXG5cblxuICAgICAgaWYgKHJhd1Byb3BlcnR5TmFtZS5pbmNsdWRlcygnXFxcXC8nKSB8fCByYXdQcm9wZXJ0eU5hbWUuaW5jbHVkZXMoJ1xcXFwuJykpIHtcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiSW52YWxpZCA6XCIuY29uY2F0KHBzZXVkb05hbWUsIFwiIG5hbWUgcGF0dGVybjogXCIpLmNvbmNhdChyYXdQcm9wZXJ0eU5hbWUpKTtcbiAgICAgIH1cblxuICAgICAgbGV0IHByb3BDaGFpbk1hdGNoZXM7XG5cbiAgICAgIHRyeSB7XG4gICAgICAgIHByb3BDaGFpbk1hdGNoZXMgPSBwYXJzZVJhd1Byb3BDaGFpbihyYXdQcm9wZXJ0eU5hbWUpO1xuICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICAvLyBlc2xpbnQtZGlzYWJsZS1saW5lIEB0eXBlc2NyaXB0LWVzbGludC9uby1leHBsaWNpdC1hbnlcbiAgICAgICAgbG9nZ2VyLmVycm9yKGUpO1xuICAgICAgICB0aHJvdyBuZXcgU3ludGF4RXJyb3IoZS5tZXNzYWdlKTtcbiAgICAgIH1cblxuICAgICAgY29uc3Qgb3duZXJPYmpBcnIgPSBmaWx0ZXJSb290c0J5UmVnZXhwQ2hhaW4oZG9tRWxlbWVudCwgcHJvcENoYWluTWF0Y2hlcyk7XG5cbiAgICAgIGlmIChvd25lck9iakFyci5sZW5ndGggPT09IDApIHtcbiAgICAgICAgcmV0dXJuIGZhbHNlO1xuICAgICAgfVxuXG4gICAgICBsZXQgaXNNYXRjaGVkID0gdHJ1ZTtcblxuICAgICAgaWYgKHJhd1Byb3BlcnR5VmFsdWUpIHtcbiAgICAgICAgbGV0IHByb3BWYWx1ZU1hdGNoO1xuXG4gICAgICAgIHRyeSB7XG4gICAgICAgICAgcHJvcFZhbHVlTWF0Y2ggPSBnZXRWYWxpZE1hdGNoZXJBcmcocmF3UHJvcGVydHlWYWx1ZSk7XG4gICAgICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgICAgICAvLyBlc2xpbnQtZGlzYWJsZS1saW5lIEB0eXBlc2NyaXB0LWVzbGludC9uby1leHBsaWNpdC1hbnlcbiAgICAgICAgICBsb2dnZXIuZXJyb3IoZSk7XG4gICAgICAgICAgdGhyb3cgbmV3IFN5bnRheEVycm9yKGUubWVzc2FnZSk7XG4gICAgICAgIH1cblxuICAgICAgICBpZiAocHJvcFZhbHVlTWF0Y2gpIHtcbiAgICAgICAgICBmb3IgKGxldCBpID0gMDsgaSA8IG93bmVyT2JqQXJyLmxlbmd0aDsgaSArPSAxKSB7XG4gICAgICAgICAgICBjb25zdCByZWFsVmFsdWUgPSBvd25lck9iakFycltpXS52YWx1ZTtcblxuICAgICAgICAgICAgaWYgKHByb3BWYWx1ZU1hdGNoIGluc3RhbmNlb2YgUmVnRXhwKSB7XG4gICAgICAgICAgICAgIGlzTWF0Y2hlZCA9IHByb3BWYWx1ZU1hdGNoLnRlc3QoY29udmVydFR5cGVJbnRvU3RyaW5nKHJlYWxWYWx1ZSkpO1xuICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgLy8gaGFuZGxlICdudWxsJyBhbmQgJ3VuZGVmaW5lZCcgcHJvcGVydHkgdmFsdWVzIHNldCBhcyBzdHJpbmdcbiAgICAgICAgICAgICAgaWYgKHJlYWxWYWx1ZSA9PT0gJ251bGwnIHx8IHJlYWxWYWx1ZSA9PT0gJ3VuZGVmaW5lZCcpIHtcbiAgICAgICAgICAgICAgICBpc01hdGNoZWQgPSBwcm9wVmFsdWVNYXRjaCA9PT0gcmVhbFZhbHVlO1xuICAgICAgICAgICAgICAgIGJyZWFrO1xuICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgaXNNYXRjaGVkID0gY29udmVydFR5cGVGcm9tU3RyaW5nKHByb3BWYWx1ZU1hdGNoKSA9PT0gcmVhbFZhbHVlO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICBpZiAoaXNNYXRjaGVkKSB7XG4gICAgICAgICAgICAgIGJyZWFrO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgfVxuXG4gICAgICByZXR1cm4gaXNNYXRjaGVkO1xuICAgIH07XG4gICAgLyoqXG4gICAgICogQ2hlY2tzIHdoZXRoZXIgdGhlIHRleHRDb250ZW50IGlzIG1hdGNoZWQgYnkgOmNvbnRhaW5zIGFyZy5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBhcmdzRGF0YSBQc2V1ZG8tY2xhc3MgbmFtZSwgYXJnLCBhbmQgZG9tIGVsZW1lbnQgdG8gY2hlY2suXG4gICAgICpcbiAgICAgKiBAdGhyb3dzIEFuIGVycm9yIG9uIGludmFsaWQgYXJnIG9mIHBzZXVkby1jbGFzcy5cbiAgICAgKi9cblxuICAgIGNvbnN0IGlzVGV4dE1hdGNoZWQgPSBhcmdzRGF0YSA9PiB7XG4gICAgICBjb25zdCBwc2V1ZG9OYW1lID0gYXJnc0RhdGEucHNldWRvTmFtZSxcbiAgICAgICAgICAgIHBzZXVkb0FyZyA9IGFyZ3NEYXRhLnBzZXVkb0FyZyxcbiAgICAgICAgICAgIGRvbUVsZW1lbnQgPSBhcmdzRGF0YS5kb21FbGVtZW50O1xuICAgICAgY29uc3QgdGV4dENvbnRlbnQgPSBnZXROb2RlVGV4dENvbnRlbnQoZG9tRWxlbWVudCk7XG4gICAgICBsZXQgaXNUZXh0Q29udGVudE1hdGNoZWQ7XG4gICAgICBsZXQgcHNldWRvQXJnVG9NYXRjaCA9IHBzZXVkb0FyZztcblxuICAgICAgaWYgKHBzZXVkb0FyZ1RvTWF0Y2guc3RhcnRzV2l0aChTTEFTSCkgJiYgUkVHRVhQX1dJVEhfRkxBR1NfUkVHRVhQLnRlc3QocHNldWRvQXJnVG9NYXRjaCkpIHtcbiAgICAgICAgLy8gcmVnZXhwIGFyZ1xuICAgICAgICBjb25zdCBmbGFnc0luZGV4ID0gcHNldWRvQXJnVG9NYXRjaC5sYXN0SW5kZXhPZignLycpO1xuICAgICAgICBjb25zdCBmbGFnc1N0ciA9IHBzZXVkb0FyZ1RvTWF0Y2guc3Vic3RyaW5nKGZsYWdzSW5kZXggKyAxKTtcbiAgICAgICAgcHNldWRvQXJnVG9NYXRjaCA9IHBzZXVkb0FyZ1RvTWF0Y2guc3Vic3RyaW5nKDAsIGZsYWdzSW5kZXggKyAxKS5zbGljZSgxLCAtMSkucmVwbGFjZSgvXFxcXChbXFxcXFwiXSkvZywgJyQxJyk7XG4gICAgICAgIGxldCByZWdleDtcblxuICAgICAgICB0cnkge1xuICAgICAgICAgIHJlZ2V4ID0gbmV3IFJlZ0V4cChwc2V1ZG9BcmdUb01hdGNoLCBmbGFnc1N0cik7XG4gICAgICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJJbnZhbGlkIGFyZ3VtZW50IG9mIDpcIi5jb25jYXQocHNldWRvTmFtZSwgXCIoKSBwc2V1ZG8tY2xhc3M6IFwiKS5jb25jYXQocHNldWRvQXJnKSk7XG4gICAgICAgIH1cblxuICAgICAgICBpc1RleHRDb250ZW50TWF0Y2hlZCA9IHJlZ2V4LnRlc3QodGV4dENvbnRlbnQpO1xuICAgICAgfSBlbHNlIHtcbiAgICAgICAgLy8gbm9uZS1yZWdleHAgYXJnXG4gICAgICAgIHBzZXVkb0FyZ1RvTWF0Y2ggPSBwc2V1ZG9BcmdUb01hdGNoLnJlcGxhY2UoL1xcXFwoW1xcXFwoKVtcXF1cIl0pL2csICckMScpO1xuICAgICAgICBpc1RleHRDb250ZW50TWF0Y2hlZCA9IHRleHRDb250ZW50LmluY2x1ZGVzKHBzZXVkb0FyZ1RvTWF0Y2gpO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gaXNUZXh0Q29udGVudE1hdGNoZWQ7XG4gICAgfTtcblxuICAgIGZ1bmN0aW9uIF9kZWZpbmVQcm9wZXJ0eShvYmosIGtleSwgdmFsdWUpIHtcbiAgICAgIGlmIChrZXkgaW4gb2JqKSB7XG4gICAgICAgIE9iamVjdC5kZWZpbmVQcm9wZXJ0eShvYmosIGtleSwge1xuICAgICAgICAgIHZhbHVlOiB2YWx1ZSxcbiAgICAgICAgICBlbnVtZXJhYmxlOiB0cnVlLFxuICAgICAgICAgIGNvbmZpZ3VyYWJsZTogdHJ1ZSxcbiAgICAgICAgICB3cml0YWJsZTogdHJ1ZVxuICAgICAgICB9KTtcbiAgICAgIH0gZWxzZSB7XG4gICAgICAgIG9ialtrZXldID0gdmFsdWU7XG4gICAgICB9XG5cbiAgICAgIHJldHVybiBvYmo7XG4gICAgfVxuXG4gICAgbGV0IE5vZGVUeXBlO1xuICAgIC8qKlxuICAgICAqIFVuaXZlcnNhbCBpbnRlcmZhY2UgZm9yIGFsbCBub2RlIHR5cGVzLlxuICAgICAqL1xuXG4gICAgKGZ1bmN0aW9uIChOb2RlVHlwZSkge1xuICAgICAgTm9kZVR5cGVbXCJTZWxlY3Rvckxpc3RcIl0gPSBcIlNlbGVjdG9yTGlzdFwiO1xuICAgICAgTm9kZVR5cGVbXCJTZWxlY3RvclwiXSA9IFwiU2VsZWN0b3JcIjtcbiAgICAgIE5vZGVUeXBlW1wiUmVndWxhclNlbGVjdG9yXCJdID0gXCJSZWd1bGFyU2VsZWN0b3JcIjtcbiAgICAgIE5vZGVUeXBlW1wiRXh0ZW5kZWRTZWxlY3RvclwiXSA9IFwiRXh0ZW5kZWRTZWxlY3RvclwiO1xuICAgICAgTm9kZVR5cGVbXCJBYnNvbHV0ZVBzZXVkb0NsYXNzXCJdID0gXCJBYnNvbHV0ZVBzZXVkb0NsYXNzXCI7XG4gICAgICBOb2RlVHlwZVtcIlJlbGF0aXZlUHNldWRvQ2xhc3NcIl0gPSBcIlJlbGF0aXZlUHNldWRvQ2xhc3NcIjtcbiAgICB9KShOb2RlVHlwZSB8fCAoTm9kZVR5cGUgPSB7fSkpO1xuXG4gICAgLyoqXG4gICAgICogQ2xhc3MgbmVlZGVkIGZvciBjcmVhdGluZyBhc3Qgbm9kZXMgd2hpbGUgc2VsZWN0b3IgcGFyc2luZy5cbiAgICAgKiBVc2VkIGZvciBTZWxlY3Rvckxpc3QsIFNlbGVjdG9yLCBFeHRlbmRlZFNlbGVjdG9yLlxuICAgICAqL1xuICAgIGNsYXNzIEFueVNlbGVjdG9yTm9kZSB7XG4gICAgICAvKipcbiAgICAgICAqIENyZWF0ZXMgbmV3IGFzdCBub2RlLlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSB0eXBlIEFzdCBub2RlIHR5cGUuXG4gICAgICAgKi9cbiAgICAgIGNvbnN0cnVjdG9yKHR5cGUpIHtcbiAgICAgICAgX2RlZmluZVByb3BlcnR5KHRoaXMsIFwiY2hpbGRyZW5cIiwgW10pO1xuXG4gICAgICAgIHRoaXMudHlwZSA9IHR5cGU7XG4gICAgICB9XG4gICAgICAvKipcbiAgICAgICAqIEFkZHMgY2hpbGQgbm9kZSB0byBjaGlsZHJlbiBhcnJheS5cbiAgICAgICAqXG4gICAgICAgKiBAcGFyYW0gY2hpbGQgQXN0IG5vZGUuXG4gICAgICAgKi9cblxuXG4gICAgICBhZGRDaGlsZChjaGlsZCkge1xuICAgICAgICB0aGlzLmNoaWxkcmVuLnB1c2goY2hpbGQpO1xuICAgICAgfVxuXG4gICAgfVxuICAgIC8qKlxuICAgICAqIENsYXNzIG5lZWRlZCBmb3IgY3JlYXRpbmcgUmVndWxhclNlbGVjdG9yIGFzdCBub2RlIHdoaWxlIHNlbGVjdG9yIHBhcnNpbmcuXG4gICAgICovXG5cbiAgICBjbGFzcyBSZWd1bGFyU2VsZWN0b3JOb2RlIGV4dGVuZHMgQW55U2VsZWN0b3JOb2RlIHtcbiAgICAgIC8qKlxuICAgICAgICogQ3JlYXRlcyBSZWd1bGFyU2VsZWN0b3IgYXN0IG5vZGUuXG4gICAgICAgKlxuICAgICAgICogQHBhcmFtIHZhbHVlIFZhbHVlIG9mIFJlZ3VsYXJTZWxlY3RvciBub2RlLlxuICAgICAgICovXG4gICAgICBjb25zdHJ1Y3Rvcih2YWx1ZSkge1xuICAgICAgICBzdXBlcihOb2RlVHlwZS5SZWd1bGFyU2VsZWN0b3IpO1xuICAgICAgICB0aGlzLnZhbHVlID0gdmFsdWU7XG4gICAgICB9XG5cbiAgICB9XG4gICAgLyoqXG4gICAgICogQ2xhc3MgbmVlZGVkIGZvciBjcmVhdGluZyBSZWxhdGl2ZVBzZXVkb0NsYXNzIGFzdCBub2RlIHdoaWxlIHNlbGVjdG9yIHBhcnNpbmcuXG4gICAgICovXG5cbiAgICBjbGFzcyBSZWxhdGl2ZVBzZXVkb0NsYXNzTm9kZSBleHRlbmRzIEFueVNlbGVjdG9yTm9kZSB7XG4gICAgICAvKipcbiAgICAgICAqIENyZWF0ZXMgUmVndWxhclNlbGVjdG9yIGFzdCBub2RlLlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSBuYW1lIE5hbWUgb2YgUmVsYXRpdmVQc2V1ZG9DbGFzcyBub2RlLlxuICAgICAgICovXG4gICAgICBjb25zdHJ1Y3RvcihuYW1lKSB7XG4gICAgICAgIHN1cGVyKE5vZGVUeXBlLlJlbGF0aXZlUHNldWRvQ2xhc3MpO1xuICAgICAgICB0aGlzLm5hbWUgPSBuYW1lO1xuICAgICAgfVxuXG4gICAgfVxuICAgIC8qKlxuICAgICAqIENsYXNzIG5lZWRlZCBmb3IgY3JlYXRpbmcgQWJzb2x1dGVQc2V1ZG9DbGFzcyBhc3Qgbm9kZSB3aGlsZSBzZWxlY3RvciBwYXJzaW5nLlxuICAgICAqL1xuXG4gICAgY2xhc3MgQWJzb2x1dGVQc2V1ZG9DbGFzc05vZGUgZXh0ZW5kcyBBbnlTZWxlY3Rvck5vZGUge1xuICAgICAgLyoqXG4gICAgICAgKiBDcmVhdGVzIEFic29sdXRlUHNldWRvQ2xhc3MgYXN0IG5vZGUuXG4gICAgICAgKlxuICAgICAgICogQHBhcmFtIG5hbWUgTmFtZSBvZiBBYnNvbHV0ZVBzZXVkb0NsYXNzIG5vZGUuXG4gICAgICAgKi9cbiAgICAgIGNvbnN0cnVjdG9yKG5hbWUpIHtcbiAgICAgICAgc3VwZXIoTm9kZVR5cGUuQWJzb2x1dGVQc2V1ZG9DbGFzcyk7XG5cbiAgICAgICAgX2RlZmluZVByb3BlcnR5KHRoaXMsIFwidmFsdWVcIiwgJycpO1xuXG4gICAgICAgIHRoaXMubmFtZSA9IG5hbWU7XG4gICAgICB9XG5cbiAgICB9XG4gICAgLyogZXNsaW50LWRpc2FibGUganNkb2MvcmVxdWlyZS1kZXNjcmlwdGlvbi1jb21wbGV0ZS1zZW50ZW5jZSAqL1xuXG4gICAgLyoqXG4gICAgICogUm9vdCBub2RlLlxuICAgICAqXG4gICAgICogU2VsZWN0b3JMaXN0XG4gICAgICogICA6IFNlbGVjdG9yXG4gICAgICogICAgIC4uLlxuICAgICAqICAgO1xuICAgICAqL1xuXG4gICAgLyoqXG4gICAgICogU2VsZWN0b3Igbm9kZS5cbiAgICAgKlxuICAgICAqIFNlbGVjdG9yXG4gICAgICogICA6IFJlZ3VsYXJTZWxlY3RvclxuICAgICAqICAgfCBFeHRlbmRlZFNlbGVjdG9yXG4gICAgICogICAgIC4uLlxuICAgICAqICAgO1xuICAgICAqL1xuXG4gICAgLyoqXG4gICAgICogUmVndWxhciBzZWxlY3RvciBub2RlLlxuICAgICAqIEl0IGNhbiBiZSBzZWxlY3RlZCBieSBxdWVyeVNlbGVjdG9yQWxsKCkuXG4gICAgICpcbiAgICAgKiBSZWd1bGFyU2VsZWN0b3JcbiAgICAgKiAgIDogdHlwZVxuICAgICAqICAgOiB2YWx1ZVxuICAgICAqICAgO1xuICAgICAqL1xuXG4gICAgLyoqXG4gICAgICogRXh0ZW5kZWQgc2VsZWN0b3Igbm9kZS5cbiAgICAgKlxuICAgICAqIEV4dGVuZGVkU2VsZWN0b3JcbiAgICAgKiAgIDogQWJzb2x1dGVQc2V1ZG9DbGFzc1xuICAgICAqICAgfCBSZWxhdGl2ZVBzZXVkb0NsYXNzXG4gICAgICogICA7XG4gICAgICovXG5cbiAgICAvKipcbiAgICAgKiBBYnNvbHV0ZSBleHRlbmRlZCBwc2V1ZG8tY2xhc3Mgbm9kZSxcbiAgICAgKiBpLmUuIG5vbmUtc2VsZWN0b3IgYXJncy5cbiAgICAgKlxuICAgICAqIEFic29sdXRlUHNldWRvQ2xhc3NcbiAgICAgKiAgIDogdHlwZVxuICAgICAqICAgOiBuYW1lXG4gICAgICogICA6IHZhbHVlXG4gICAgICogICA7XG4gICAgICovXG5cbiAgICAvKipcbiAgICAgKiBSZWxhdGl2ZSBleHRlbmRlZCBwc2V1ZG8tY2xhc3Mgbm9kZVxuICAgICAqIGkuZS4gc2VsZWN0b3IgYXMgYXJnLlxuICAgICAqXG4gICAgICogUmVsYXRpdmVQc2V1ZG9DbGFzc1xuICAgICAqICAgOiB0eXBlXG4gICAgICogICA6IG5hbWVcbiAgICAgKiAgIDogU2VsZWN0b3JMaXN0XG4gICAgICogICA7XG4gICAgICovXG4gICAgLy9cbiAgICAvLyAgYXN0IGV4YW1wbGVcbiAgICAvL1xuICAgIC8vICBkaXYuYmFubmVyID4gZGl2OmhhcyhzcGFuLCBwKSwgYSBpbWcuYWRcbiAgICAvL1xuICAgIC8vICBTZWxlY3Rvckxpc3QgLSBkaXYuYmFubmVyID4gZGl2OmhhcyhzcGFuLCBwKSwgYSBpbWcuYWRcbiAgICAvLyAgICAgIFNlbGVjdG9yIC0gZGl2LmJhbm5lciA+IGRpdjpoYXMoc3BhbiwgcClcbiAgICAvLyAgICAgICAgICBSZWd1bGFyU2VsZWN0b3IgLSBkaXYuYmFubmVyID4gZGl2XG4gICAgLy8gICAgICAgICAgRXh0ZW5kZWRTZWxlY3RvciAtIDpoYXMoc3BhbiwgcClcbiAgICAvLyAgICAgICAgICAgICAgUHNldWRvQ2xhc3NTZWxlY3RvciAtIDpoYXNcbiAgICAvLyAgICAgICAgICAgICAgU2VsZWN0b3JMaXN0IC0gc3BhbiwgcFxuICAgIC8vICAgICAgICAgICAgICAgICAgU2VsZWN0b3IgLSBzcGFuXG4gICAgLy8gICAgICAgICAgICAgICAgICAgICAgUmVndWxhclNlbGVjdG9yIC0gc3BhblxuICAgIC8vICAgICAgICAgICAgICAgICAgU2VsZWN0b3IgLSBwXG4gICAgLy8gICAgICAgICAgICAgICAgICAgICAgUmVndWxhclNlbGVjdG9yIC0gcFxuICAgIC8vICAgICAgU2VsZWN0b3IgLSBhIGltZy5hZFxuICAgIC8vICAgICAgICAgIFJlZ3VsYXJTZWxlY3RvciAtIGEgaW1nLmFkXG4gICAgLy9cblxuICAgIC8qKlxuICAgICAqIFJlZ2V4cCB0aGF0IG1hdGNoZXMgYmFja3dhcmQgY29tcGF0aWJsZSBzeW50YXhlcy5cbiAgICAgKi9cblxuICAgIGNvbnN0IFJFR0VYUF9WQUxJRF9PTERfU1lOVEFYID0gL1xcWy0oPzpleHQpLShbYS16LV9dKyk9KFtcIiddKSgoPzooPz0oXFxcXD8pKVxcNC4pKj8pXFwyXFxdL2c7XG4gICAgLyoqXG4gICAgICogTWFya2VyIGZvciBjaGVja2luZyBpbnZhbGlkIHNlbGVjdG9yIGFmdGVyIG9sZC1zeW50YXggbm9ybWFsaXppbmcgYnkgc2VsZWN0b3IgY29udmVydGVyLlxuICAgICAqL1xuXG4gICAgY29uc3QgSU5WQUxJRF9PTERfU1lOVEFYX01BUktFUiA9ICdbLWV4dC0nO1xuICAgIC8qKlxuICAgICAqIENvbXBsZXggcmVwbGFjZW1lbnQgZnVuY3Rpb24uXG4gICAgICogVW5kbyBxdW90ZSBlc2NhcGluZyBpbnNpZGUgb2YgYW4gZXh0ZW5kZWQgc2VsZWN0b3IuXG4gICAgICpcbiAgICAgKiBAcGFyYW0gbWF0Y2ggICAgIFdob2xlIG1hdGNoZWQgc3RyaW5nLlxuICAgICAqIEBwYXJhbSBuYW1lICAgICAgR3JvdXAgMS5cbiAgICAgKiBAcGFyYW0gcXVvdGVDaGFyIEdyb3VwIDIuXG4gICAgICogQHBhcmFtIHJhd1ZhbHVlICBHcm91cCAzLlxuICAgICAqL1xuXG4gICAgY29uc3QgZXZhbHVhdGVNYXRjaCA9IChtYXRjaCwgbmFtZSwgcXVvdGVDaGFyLCByYXdWYWx1ZSkgPT4ge1xuICAgICAgLy8gVW5lc2NhcGUgcXVvdGVzXG4gICAgICBjb25zdCByZSA9IG5ldyBSZWdFeHAoXCIoW15cXFxcXFxcXF18XilcXFxcXFxcXFwiLmNvbmNhdChxdW90ZUNoYXIpLCAnZycpO1xuICAgICAgY29uc3QgdmFsdWUgPSByYXdWYWx1ZS5yZXBsYWNlKHJlLCBcIiQxXCIuY29uY2F0KHF1b3RlQ2hhcikpO1xuICAgICAgcmV0dXJuIFwiOlwiLmNvbmNhdChuYW1lLCBcIihcIikuY29uY2F0KHZhbHVlLCBcIilcIik7XG4gICAgfTsgLy8gJzpzY29wZScgcHNldWRvIG1heSBiZSBhdCBzdGFydCBvZiA6aGFzKCkgYXJndW1lbnRcbiAgICAvLyBidXQgRXh0Q3NzRG9jdW1lbnQucXVlcnlTZWxlY3RvckFsbCgpIGFscmVhZHkgdXNlIGl0IGZvciBzZWxlY3RpbmcgZXhhY3QgZWxlbWVudCBkZXNjZW5kYW50c1xuXG5cbiAgICBjb25zdCByZVNjb3BlID0gL1xcKDpzY29wZSA+L2c7XG4gICAgY29uc3QgU0NPUEVfUkVQTEFDRVIgPSAnKD4nO1xuICAgIGNvbnN0IE1BVENIRVNfQ1NTX1BTRVVET19FTEVNRU5UX1JFR0VYUCA9IC8oOm1hdGNoZXMtY3NzKS0oYmVmb3JlfGFmdGVyKVxcKC9nO1xuXG4gICAgY29uc3QgY29udmVydE1hdGNoZXNDc3MgPSAobWF0Y2gsIGV4dGVuZGVkUHNldWRvQ2xhc3MsIHJlZ3VsYXJQc2V1ZG9FbGVtZW50KSA9PiB7XG4gICAgICAvLyAnOm1hdGNoZXMtY3NzLWJlZm9yZSgnICAtLT4gICc6bWF0Y2hlcy1jc3MoYmVmb3JlLCAnXG4gICAgICAvLyAnOm1hdGNoZXMtY3NzLWFmdGVyKCcgICAtLT4gICc6bWF0Y2hlcy1jc3MoYWZ0ZXIsICdcbiAgICAgIHJldHVybiBcIlwiLmNvbmNhdChleHRlbmRlZFBzZXVkb0NsYXNzKS5jb25jYXQoQlJBQ0tFVFMuUEFSRU5USEVTRVMuTEVGVCkuY29uY2F0KHJlZ3VsYXJQc2V1ZG9FbGVtZW50KS5jb25jYXQoQ09NTUEpO1xuICAgIH07XG4gICAgLyoqXG4gICAgICogSGFuZGxlcyBvbGQgc3ludGF4IGFuZCA6c2NvcGUgaW5zaWRlIDpoYXMoKS5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBzZWxlY3RvciBUcmltbWVkIHNlbGVjdG9yIHRvIG5vcm1hbGl6ZS5cbiAgICAgKlxuICAgICAqIEB0aHJvd3MgQW4gZXJyb3Igb24gaW52YWxpZCBvbGQgZXh0ZW5kZWQgc3ludGF4IHNlbGVjdG9yLlxuICAgICAqL1xuXG5cbiAgICBjb25zdCBub3JtYWxpemUgPSBzZWxlY3RvciA9PiB7XG4gICAgICBjb25zdCBub3JtYWxpemVkU2VsZWN0b3IgPSBzZWxlY3Rvci5yZXBsYWNlKFJFR0VYUF9WQUxJRF9PTERfU1lOVEFYLCBldmFsdWF0ZU1hdGNoKS5yZXBsYWNlKHJlU2NvcGUsIFNDT1BFX1JFUExBQ0VSKS5yZXBsYWNlKE1BVENIRVNfQ1NTX1BTRVVET19FTEVNRU5UX1JFR0VYUCwgY29udmVydE1hdGNoZXNDc3MpOyAvLyB2YWxpZGF0ZSBvbGQgc3ludGF4IGFmdGVyIG5vcm1hbGl6aW5nXG4gICAgICAvLyBlLmcuICdbLWV4dC1tYXRjaGVzLWNzcy1iZWZvcmU9XFwnY29udGVudDogIC9eW0EtWl1bYS16XSdcblxuICAgICAgaWYgKG5vcm1hbGl6ZWRTZWxlY3Rvci5pbmNsdWRlcyhJTlZBTElEX09MRF9TWU5UQVhfTUFSS0VSKSkge1xuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJJbnZhbGlkIGV4dGVuZGVkLWNzcyBvbGQgc3ludGF4IHNlbGVjdG9yOiAnXCIuY29uY2F0KHNlbGVjdG9yLCBcIidcIikpO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gbm9ybWFsaXplZFNlbGVjdG9yO1xuICAgIH07XG4gICAgLyoqXG4gICAgICogUHJlcGFyZXMgdGhlIHJhd1NlbGVjdG9yIGJlZm9yZSB0b2tlbml6YXRpb246XG4gICAgICogMS4gVHJpbXMgaXQuXG4gICAgICogMi4gQ29udmVydHMgb2xkIHN5bnRheCBgWy1leHQtcHNldWRvLWNsYXNzPVwiLi4uXCJdYCB0byBuZXcgb25lIGA6cHNldWRvLWNsYXNzKC4uLilgLlxuICAgICAqIDMuIEhhbmRsZXMgOnNjb3BlIHBzZXVkbyBpbnNpZGUgOmhhcygpIHBzZXVkby1jbGFzcyBhcmcuXG4gICAgICpcbiAgICAgKiBAcGFyYW0gcmF3U2VsZWN0b3IgU2VsZWN0b3Igd2l0aCBubyBzdHlsZSBkZWNsYXJhdGlvbi5cbiAgICAgKiBAcmV0dXJucyBQcmVwYXJlZCBzZWxlY3RvciB3aXRoIG5vIHN0eWxlIGRlY2xhcmF0aW9uLlxuICAgICAqL1xuXG5cbiAgICBjb25zdCBjb252ZXJ0ID0gcmF3U2VsZWN0b3IgPT4ge1xuICAgICAgY29uc3QgdHJpbW1lZFNlbGVjdG9yID0gcmF3U2VsZWN0b3IudHJpbSgpO1xuICAgICAgcmV0dXJuIG5vcm1hbGl6ZSh0cmltbWVkU2VsZWN0b3IpO1xuICAgIH07XG5cbiAgICBsZXQgVG9rZW5UeXBlO1xuXG4gICAgKGZ1bmN0aW9uIChUb2tlblR5cGUpIHtcbiAgICAgIFRva2VuVHlwZVtcIk1hcmtcIl0gPSBcIm1hcmtcIjtcbiAgICAgIFRva2VuVHlwZVtcIldvcmRcIl0gPSBcIndvcmRcIjtcbiAgICB9KShUb2tlblR5cGUgfHwgKFRva2VuVHlwZSA9IHt9KSk7XG5cbiAgICAvKipcbiAgICAgKiBTcGxpdHMgc2VsZWN0b3Igc3RyaW5nIGludG8gdG9rZW5zLlxuICAgICAqXG4gICAgICogQHBhcmFtIHJhd1NlbGVjdG9yIFJhdyBjc3Mgc2VsZWN0b3IuXG4gICAgICovXG4gICAgY29uc3QgdG9rZW5pemUgPSByYXdTZWxlY3RvciA9PiB7XG4gICAgICBjb25zdCBzZWxlY3RvciA9IGNvbnZlcnQocmF3U2VsZWN0b3IpOyAvLyBjdXJyZW50bHkgcHJvY2Vzc2VkXG5cbiAgICAgIGxldCBzeW1ib2w7IC8vIGZvciB3b3JkcyBjb2xsZWN0aW5nIHdoaWxlIGl0ZXJhdGluZ1xuXG4gICAgICBsZXQgYnVmZmVyID0gJyc7IC8vIHJlc3VsdCBjb2xsZWN0aW9uXG5cbiAgICAgIGNvbnN0IHRva2VucyA9IFtdOyAvLyBpdGVyYXRlIHNlbGVjdG9yIGNoYXJzIGFuZCBjb2xsZWN0IHRva2Vuc1xuXG4gICAgICBmb3IgKGxldCBpID0gMDsgaSA8IHNlbGVjdG9yLmxlbmd0aDsgaSArPSAxKSB7XG4gICAgICAgIHN5bWJvbCA9IHNlbGVjdG9yW2ldO1xuXG4gICAgICAgIGlmIChTVVBQT1JURURfU0VMRUNUT1JfTUFSS1MuaW5jbHVkZXMoc3ltYm9sKSkge1xuICAgICAgICAgIHRva2Vucy5wdXNoKHtcbiAgICAgICAgICAgIHR5cGU6IFRva2VuVHlwZS5NYXJrLFxuICAgICAgICAgICAgdmFsdWU6IHN5bWJvbFxuICAgICAgICAgIH0pO1xuICAgICAgICAgIGNvbnRpbnVlO1xuICAgICAgICB9XG5cbiAgICAgICAgYnVmZmVyICs9IHN5bWJvbDtcbiAgICAgICAgY29uc3QgbmV4dFN5bWJvbCA9IHNlbGVjdG9yW2kgKyAxXTsgLy8gc3RyaW5nIGVuZCBoYXMgYmVlbiByZWFjaGVkIGlmIG5leHRTeW1ib2wgaXMgdW5kZWZpbmVkXG5cbiAgICAgICAgaWYgKCFuZXh0U3ltYm9sIHx8IFNVUFBPUlRFRF9TRUxFQ1RPUl9NQVJLUy5pbmNsdWRlcyhuZXh0U3ltYm9sKSkge1xuICAgICAgICAgIHRva2Vucy5wdXNoKHtcbiAgICAgICAgICAgIHR5cGU6IFRva2VuVHlwZS5Xb3JkLFxuICAgICAgICAgICAgdmFsdWU6IGJ1ZmZlclxuICAgICAgICAgIH0pO1xuICAgICAgICAgIGJ1ZmZlciA9ICcnO1xuICAgICAgICB9XG4gICAgICB9XG5cbiAgICAgIHJldHVybiB0b2tlbnM7XG4gICAgfTtcblxuICAgIC8qKlxuICAgICAqIFNvbWUgYnJvd3NlcnMgZG8gbm90IHN1cHBvcnQgQXJyYXkucHJvdG90eXBlLmZsYXQoKVxuICAgICAqIGUuZy4gT3BlcmEgNDIgd2hpY2ggaXMgdXNlZCBmb3IgYnJvd3NlcnN0YWNrIHRlc3RzLlxuICAgICAqXG4gICAgICogQHNlZSB7QGxpbmsgaHR0cHM6Ly9kZXZlbG9wZXIubW96aWxsYS5vcmcvZW4tVVMvZG9jcy9XZWIvSmF2YVNjcmlwdC9SZWZlcmVuY2UvR2xvYmFsX09iamVjdHMvQXJyYXkvZmxhdH1cbiAgICAgKlxuICAgICAqIEBwYXJhbSBpbnB1dCBBcnJheSBuZWVkZWQgdG8gYmUgZmxhdHRlbi5cbiAgICAgKlxuICAgICAqIEB0aHJvd3MgQW4gZXJyb3IgaWYgYXJyYXkgY2Fubm90IGJlIGZsYXR0ZW4uXG4gICAgICovXG4gICAgY29uc3QgZmxhdHRlbiA9IGlucHV0ID0+IHtcbiAgICAgIGNvbnN0IHN0YWNrID0gW107XG4gICAgICBpbnB1dC5mb3JFYWNoKGVsID0+IHN0YWNrLnB1c2goZWwpKTtcbiAgICAgIGNvbnN0IHJlcyA9IFtdO1xuXG4gICAgICB3aGlsZSAoc3RhY2subGVuZ3RoKSB7XG4gICAgICAgIC8vIHBvcCB2YWx1ZSBmcm9tIHN0YWNrXG4gICAgICAgIGNvbnN0IG5leHQgPSBzdGFjay5wb3AoKTtcblxuICAgICAgICBpZiAoIW5leHQpIHtcbiAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoJ1VuYWJsZSB0byBtYWtlIGFycmF5IGZsYXQnKTtcbiAgICAgICAgfVxuXG4gICAgICAgIGlmIChBcnJheS5pc0FycmF5KG5leHQpKSB7XG4gICAgICAgICAgLy8gcHVzaCBiYWNrIGFycmF5IGl0ZW1zLCB3b24ndCBtb2RpZnkgdGhlIG9yaWdpbmFsIGlucHV0XG4gICAgICAgICAgbmV4dC5mb3JFYWNoKGVsID0+IHN0YWNrLnB1c2goZWwpKTtcbiAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICByZXMucHVzaChuZXh0KTtcbiAgICAgICAgfVxuICAgICAgfSAvLyByZXZlcnNlIHRvIHJlc3RvcmUgaW5wdXQgb3JkZXJcblxuXG4gICAgICByZXR1cm4gcmVzLnJldmVyc2UoKTtcbiAgICB9O1xuICAgIC8qKlxuICAgICAqIFJldHVybnMgbGFzdCBpdGVtIGZyb20gYXJyYXkuXG4gICAgICpcbiAgICAgKiBAcGFyYW0gYXJyYXkgSW5wdXQgYXJyYXkuXG4gICAgICovXG5cbiAgICBjb25zdCBnZXRMYXN0ID0gYXJyYXkgPT4ge1xuICAgICAgcmV0dXJuIGFycmF5W2FycmF5Lmxlbmd0aCAtIDFdO1xuICAgIH07XG5cbiAgICAvLyBlLmcuICc6aXMoLnBhZ2UsIC5tYWluKSA+IC5iYW5uZXInIG9yICcqOm5vdChzcGFuKTpub3QocCknXG5cbiAgICBjb25zdCBJU19PUl9OT1RfUFNFVURPX1NFTEVDVElOR19ST09UID0gXCJodG1sIFwiLmNvbmNhdChBU1RFUklTSyk7IC8vIGxpbWl0IGFwcGx5aW5nIG9mIDp4cGF0aCgpIHBzZXVkby1jbGFzcyB0byAnYW55JyBlbGVtZW50XG4gICAgLy8gaHR0cHM6Ly9naXRodWIuY29tL0FkZ3VhcmRUZWFtL0V4dGVuZGVkQ3NzL2lzc3Vlcy8xMTVcblxuICAgIGNvbnN0IFhQQVRIX1BTRVVET19TRUxFQ1RJTkdfUk9PVCA9ICdib2R5JztcbiAgICAvKipcbiAgICAgKiBDaGVja3Mgd2hldGhlciB0aGUgcGFzc2VkIHRva2VuIGlzIHN1cHBvcnRlZCBleHRlbmRlZCBwc2V1ZG8tY2xhc3MuXG4gICAgICpcbiAgICAgKiBAcGFyYW0gdG9rZW5WYWx1ZSBUb2tlbiB2YWx1ZSB0byBjaGVjay5cbiAgICAgKi9cblxuICAgIGNvbnN0IGlzU3VwcG9ydGVkRXh0ZW5kZWRQc2V1ZG8gPSB0b2tlblZhbHVlID0+IFNVUFBPUlRFRF9QU0VVRE9fQ0xBU1NFUy5pbmNsdWRlcyh0b2tlblZhbHVlKTtcbiAgICAvKipcbiAgICAgKiBDaGVja3Mgd2hldGhlciBuZXh0IHRva2VuIGlzIGEgY29udGludWF0aW9uIG9mIHJlZ3VsYXIgc2VsZWN0b3IgYmVpbmcgcHJvY2Vzc2VkLlxuICAgICAqXG4gICAgICogQHBhcmFtIG5leHRUb2tlblR5cGUgVHlwZSBvZiB0b2tlbiBuZXh0IHRvIGN1cnJlbnQgb25lLlxuICAgICAqIEBwYXJhbSBuZXh0VG9rZW5WYWx1ZSBWYWx1ZSBvZiB0b2tlbiBuZXh0IHRvIGN1cnJlbnQgb25lLlxuICAgICAqL1xuXG5cbiAgICBjb25zdCBkb2VzUmVndWxhckNvbnRpbnVlQWZ0ZXJTcGFjZSA9IChuZXh0VG9rZW5UeXBlLCBuZXh0VG9rZW5WYWx1ZSkgPT4ge1xuICAgICAgcmV0dXJuIENPTUJJTkFUT1JTLmluY2x1ZGVzKG5leHRUb2tlblZhbHVlKSB8fCBuZXh0VG9rZW5UeXBlID09PSBUb2tlblR5cGUuV29yZCAvLyBlLmcuICcjbWFpbiAqOmhhcyg+IC5hZCknXG4gICAgICB8fCBuZXh0VG9rZW5WYWx1ZSA9PT0gQVNURVJJU0sgfHwgbmV4dFRva2VuVmFsdWUgPT09IElEX01BUktFUiB8fCBuZXh0VG9rZW5WYWx1ZSA9PT0gQ0xBU1NfTUFSS0VSIC8vIGUuZy4gJ2RpdiA6d2hlcmUoLmNvbnRlbnQpJ1xuICAgICAgfHwgbmV4dFRva2VuVmFsdWUgPT09IENPTE9OIC8vIGUuZy4gXCJkaXZbY2xhc3MqPScgJ11cIlxuICAgICAgfHwgbmV4dFRva2VuVmFsdWUgPT09IFNJTkdMRV9RVU9URSAvLyBlLmcuICdkaXZbY2xhc3MqPVwiIFwiXSdcbiAgICAgIHx8IG5leHRUb2tlblZhbHVlID09PSBET1VCTEVfUVVPVEUgfHwgbmV4dFRva2VuVmFsdWUgPT09IEJSQUNLRVRTLlNRVUFSRS5MRUZUO1xuICAgIH07XG4gICAgLyoqXG4gICAgICogTGltaXRlZCBsaXN0IG9mIGF2YWlsYWJsZSBzeW1ib2xzIGJlZm9yZSBzbGFzaCBgL2BcbiAgICAgKiB0byBjaGVjayB3aGV0aGVyIGl0IGlzIHZhbGlkIHJlZ2V4cCBwYXR0ZXJuIG9wZW5pbmcuXG4gICAgICovXG5cblxuICAgIGNvbnN0IFBPU1NJQkxFX01BUktTX0JFRk9SRV9SRUdFWFAgPSB7XG4gICAgICBDT01NT046IFsvLyBlLmcuICc6bWF0Y2hlcy1hdHRyKC9kYXRhLS8pJ1xuICAgICAgQlJBQ0tFVFMuUEFSRU5USEVTRVMuTEVGVCwgLy8gZS5nLiBgOm1hdGNoZXMtYXR0cignL2RhdGEtLycpYFxuICAgICAgU0lOR0xFX1FVT1RFLCAvLyBlLmcuICc6bWF0Y2hlcy1hdHRyKFwiL2RhdGEtL1wiKSdcbiAgICAgIERPVUJMRV9RVU9URSwgLy8gZS5nLiAnOm1hdGNoZXMtYXR0cihjaGVjaz0vZGF0YS12LS8pJ1xuICAgICAgRVFVQUxfU0lHTiwgLy8gZS5nLiAnOm1hdGNoZXMtcHJvcGVydHkoaW5uZXIuL190ZXN0Lz1udWxsKSdcbiAgICAgIERPVCwgLy8gZS5nLiAnOm1hdGNoZXMtY3NzKGhlaWdodDovMjBweC8pJ1xuICAgICAgQ09MT04sIC8vICc6bWF0Y2hlcy1jc3MtYWZ0ZXIoIGNvbnRlbnQgIDogICAvKFxcXFxkK1xcXFxzKSptZS8gICknXG4gICAgICBTUEFDRV0sXG4gICAgICBDT05UQUlOUzogWy8vIGUuZy4gJzpjb250YWlucygvdGV4dC8pJ1xuICAgICAgQlJBQ0tFVFMuUEFSRU5USEVTRVMuTEVGVCwgLy8gZS5nLiBgOmNvbnRhaW5zKCcvdGV4dC8nKWBcbiAgICAgIFNJTkdMRV9RVU9URSwgLy8gZS5nLiAnOmNvbnRhaW5zKFwiL3RleHQvXCIpJ1xuICAgICAgRE9VQkxFX1FVT1RFXVxuICAgIH07XG4gICAgLyoqXG4gICAgICogQ2hlY2tzIHdoZXRoZXIgdGhlIHJlZ2V4cCBwYXR0ZXJuIGZvciBwc2V1ZG8tY2xhc3MgYXJnIHN0YXJ0cy5cbiAgICAgKiBOZWVkZWQgZm9yIGBjb250ZXh0LmlzUmVnZXhwT3BlbmAgZmxhZy5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBjb250ZXh0IFNlbGVjdG9yIHBhcnNlciBjb250ZXh0LlxuICAgICAqIEBwYXJhbSBwcmV2VG9rZW5WYWx1ZSBWYWx1ZSBvZiBwcmV2aW91cyB0b2tlbi5cbiAgICAgKiBAcGFyYW0gYnVmZmVyTm9kZVZhbHVlIFZhbHVlIG9mIGJ1ZmZlck5vZGUuXG4gICAgICpcbiAgICAgKiBAdGhyb3dzIEFuIGVycm9yIG9uIGludmFsaWQgcmVnZXhwIHBhdHRlcm4uXG4gICAgICovXG5cbiAgICBjb25zdCBpc1JlZ2V4cE9wZW5pbmcgPSAoY29udGV4dCwgcHJldlRva2VuVmFsdWUsIGJ1ZmZlck5vZGVWYWx1ZSkgPT4ge1xuICAgICAgY29uc3QgbGFzdEV4dGVuZGVkUHNldWRvQ2xhc3NOYW1lID0gZ2V0TGFzdChjb250ZXh0LmV4dGVuZGVkUHNldWRvTmFtZXNTdGFjayk7IC8vIGZvciByZWdleHAgcGF0dGVucyB0aGUgc2xhc2ggc2hvdWxkIG5vdCBiZSBlc2NhcGVkXG4gICAgICAvLyBjb25zdCBpc1JlZ2V4cFBhdHRlcm5TbGFzaCA9IHByZXZUb2tlblZhbHVlICE9PSBCQUNLU0xBU0g7XG4gICAgICAvLyByZWdleHAgcGF0dGVybiBjYW4gYmUgc2V0IGFzIGFyZyBvZiBwc2V1ZG8tY2xhc3NcbiAgICAgIC8vIHdoaWNoIG1lYW5zIGxpbWl0ZWQgbGlzdCBvZiBhdmFpbGFibGUgc3ltYm9scyBiZWZvcmUgc2xhc2ggYC9gO1xuICAgICAgLy8gZm9yIDpjb250YWlucygpIHBzZXVkby1jbGFzcyByZWdleHAgcGF0dGVybiBzaG91bGQgYmUgYXQgdGhlIGJlZ2lubmluZyBvZiBhcmdcblxuICAgICAgaWYgKENPTlRBSU5TX1BTRVVET19OQU1FUy5pbmNsdWRlcyhsYXN0RXh0ZW5kZWRQc2V1ZG9DbGFzc05hbWUpKSB7XG4gICAgICAgIHJldHVybiBQT1NTSUJMRV9NQVJLU19CRUZPUkVfUkVHRVhQLkNPTlRBSU5TLmluY2x1ZGVzKHByZXZUb2tlblZhbHVlKTtcbiAgICAgIH1cblxuICAgICAgaWYgKHByZXZUb2tlblZhbHVlID09PSBTTEFTSCAmJiBsYXN0RXh0ZW5kZWRQc2V1ZG9DbGFzc05hbWUgIT09IFhQQVRIX1BTRVVET19DTEFTU19NQVJLRVIpIHtcbiAgICAgICAgY29uc3QgcmF3QXJnRGVzYyA9IGJ1ZmZlck5vZGVWYWx1ZSA/IFwiaW4gYXJnIHBhcnQ6ICdcIi5jb25jYXQoYnVmZmVyTm9kZVZhbHVlLCBcIidcIikgOiAnYXJnJztcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiSW52YWxpZCByZWdleHAgcGF0dGVybiBmb3IgOlwiLmNvbmNhdChsYXN0RXh0ZW5kZWRQc2V1ZG9DbGFzc05hbWUsIFwiKCkgcHNldWRvLWNsYXNzIFwiKS5jb25jYXQocmF3QXJnRGVzYykpO1xuICAgICAgfSAvLyBmb3Igb3RoZXIgcHNldWRvLWNsYXNzZXMgcmVnZXhwIHBhdHRlcm4gY2FuIGJlIGVpdGhlciB0aGUgd2hvbGUgYXJnIG9yIGl0cyBwYXJ0XG5cblxuICAgICAgcmV0dXJuIFBPU1NJQkxFX01BUktTX0JFRk9SRV9SRUdFWFAuQ09NTU9OLmluY2x1ZGVzKHByZXZUb2tlblZhbHVlKTtcbiAgICB9O1xuICAgIC8qKlxuICAgICAqIEludGVyZmFjZSBmb3Igc2VsZWN0b3IgcGFyc2VyIGNvbnRleHQuXG4gICAgICovXG5cblxuICAgIC8qKlxuICAgICAqIEdldHMgdGhlIG5vZGUgd2hpY2ggaXMgYmVpbmcgY29sbGVjdGVkXG4gICAgICogb3IgbnVsbCBpZiB0aGVyZSBpcyBubyBzdWNoIG9uZS5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBjb250ZXh0IFNlbGVjdG9yIHBhcnNlciBjb250ZXh0LlxuICAgICAqL1xuICAgIGNvbnN0IGdldEJ1ZmZlck5vZGUgPSBjb250ZXh0ID0+IHtcbiAgICAgIGlmIChjb250ZXh0LnBhdGhUb0J1ZmZlck5vZGUubGVuZ3RoID09PSAwKSB7XG4gICAgICAgIHJldHVybiBudWxsO1xuICAgICAgfSAvLyBidWZmZXIgbm9kZSBpcyBhbHdheXMgdGhlIGxhc3QgaW4gdGhlIHBhdGhUb0J1ZmZlck5vZGUgc3RhY2tcblxuXG4gICAgICByZXR1cm4gZ2V0TGFzdChjb250ZXh0LnBhdGhUb0J1ZmZlck5vZGUpO1xuICAgIH07XG4gICAgLyoqXG4gICAgICogR2V0cyBsYXN0IFJlZ3VsYXJTZWxlY3RvciBhc3Qgbm9kZS5cbiAgICAgKiBOZWVkZWQgZm9yIHBhcnNpbmcgb2YgdGhlIGNvbXBsZXggc2VsZWN0b3Igd2l0aCBleHRlbmRlZCBwc2V1ZG8tY2xhc3MgaW5zaWRlIGl0LlxuICAgICAqXG4gICAgICogQHBhcmFtIGNvbnRleHQgU2VsZWN0b3IgcGFyc2VyIGNvbnRleHQuXG4gICAgICpcbiAgICAgKiBAdGhyb3dzIEFuIGVycm9yIGlmOlxuICAgICAqIC0gYnVmZmVyTm9kZSBpcyBhYnNlbnQ7XG4gICAgICogLSB0eXBlIG9mIGJ1ZmZlck5vZGUgaXMgdW5zdXBwb3J0ZWQ7XG4gICAgICogLSBubyBSZWd1bGFyU2VsZWN0b3IgaW4gYnVmZmVyTm9kZS5cbiAgICAgKi9cblxuXG4gICAgY29uc3QgZ2V0TGFzdFJlZ3VsYXJTZWxlY3Rvck5vZGUgPSBjb250ZXh0ID0+IHtcbiAgICAgIGNvbnN0IGJ1ZmZlck5vZGUgPSBnZXRCdWZmZXJOb2RlKGNvbnRleHQpO1xuXG4gICAgICBpZiAoIWJ1ZmZlck5vZGUpIHtcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKCdObyBidWZmZXJOb2RlIGZvdW5kJyk7XG4gICAgICB9XG5cbiAgICAgIGlmIChidWZmZXJOb2RlLnR5cGUgIT09IE5vZGVUeXBlLlNlbGVjdG9yKSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcignVW5zdXBwb3J0ZWQgYnVmZmVyTm9kZSB0eXBlJyk7XG4gICAgICB9XG5cbiAgICAgIGNvbnN0IHNlbGVjdG9yUmVndWxhckNoaWxkcmVuID0gYnVmZmVyTm9kZS5jaGlsZHJlbi5maWx0ZXIobm9kZSA9PiBub2RlLnR5cGUgPT09IE5vZGVUeXBlLlJlZ3VsYXJTZWxlY3Rvcik7XG5cbiAgICAgIGlmIChzZWxlY3RvclJlZ3VsYXJDaGlsZHJlbi5sZW5ndGggPT09IDApIHtcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKCdObyBSZWd1bGFyU2VsZWN0b3Igbm9kZSBmb3VuZCcpO1xuICAgICAgfVxuXG4gICAgICBjb25zdCBsYXN0UmVndWxhclNlbGVjdG9yTm9kZSA9IGdldExhc3Qoc2VsZWN0b3JSZWd1bGFyQ2hpbGRyZW4pO1xuICAgICAgY29udGV4dC5wYXRoVG9CdWZmZXJOb2RlLnB1c2gobGFzdFJlZ3VsYXJTZWxlY3Rvck5vZGUpO1xuICAgICAgcmV0dXJuIGxhc3RSZWd1bGFyU2VsZWN0b3JOb2RlO1xuICAgIH07XG4gICAgLyoqXG4gICAgICogVXBkYXRlcyBuZWVkZWQgYnVmZmVyIG5vZGUgdmFsdWUgd2hpbGUgdG9rZW5zIGl0ZXJhdGluZy5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBjb250ZXh0IFNlbGVjdG9yIHBhcnNlciBjb250ZXh0LlxuICAgICAqIEBwYXJhbSB0b2tlblZhbHVlIFZhbHVlIG9mIGN1cnJlbnQgdG9rZW4uXG4gICAgICpcbiAgICAgKiBAdGhyb3dzIEFuIGVycm9yIGlmOlxuICAgICAqIC0gbm8gYnVmZmVyTm9kZTtcbiAgICAgKiAtIGJ1ZmZlck5vZGUudHlwZSBpcyBub3QgUmVndWxhclNlbGVjdG9yIG9yIEFic29sdXRlUHNldWRvQ2xhc3MuXG4gICAgICovXG5cblxuICAgIGNvbnN0IHVwZGF0ZUJ1ZmZlck5vZGUgPSAoY29udGV4dCwgdG9rZW5WYWx1ZSkgPT4ge1xuICAgICAgY29uc3QgYnVmZmVyTm9kZSA9IGdldEJ1ZmZlck5vZGUoY29udGV4dCk7XG5cbiAgICAgIGlmIChidWZmZXJOb2RlID09PSBudWxsKSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcignTm8gYnVmZmVyTm9kZSB0byB1cGRhdGUnKTtcbiAgICAgIH1cblxuICAgICAgY29uc3QgdHlwZSA9IGJ1ZmZlck5vZGUudHlwZTtcblxuICAgICAgaWYgKHR5cGUgPT09IE5vZGVUeXBlLlJlZ3VsYXJTZWxlY3RvciB8fCB0eXBlID09PSBOb2RlVHlwZS5BYnNvbHV0ZVBzZXVkb0NsYXNzKSB7XG4gICAgICAgIGJ1ZmZlck5vZGUudmFsdWUgKz0gdG9rZW5WYWx1ZTtcbiAgICAgIH0gZWxzZSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcihcIlwiLmNvbmNhdChidWZmZXJOb2RlLnR5cGUsIFwiIG5vZGUgY2FuIG5vdCBiZSB1cGRhdGVkLiBPbmx5IFJlZ3VsYXJTZWxlY3RvciBhbmQgQWJzb2x1dGVQc2V1ZG9DbGFzcyBhcmUgc3VwcG9ydGVkXCIpKTsgLy8gZXNsaW50LWRpc2FibGUtbGluZSBtYXgtbGVuXG4gICAgICB9XG4gICAgfTtcbiAgICAvKipcbiAgICAgKiBBZGRzIFNlbGVjdG9yTGlzdCBub2RlIHRvIGNvbnRleHQuYXN0IGF0IHRoZSBzdGFydCBvZiBhc3QgY29sbGVjdGluZy5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBjb250ZXh0IFNlbGVjdG9yIHBhcnNlciBjb250ZXh0LlxuICAgICAqL1xuXG5cbiAgICBjb25zdCBhZGRTZWxlY3Rvckxpc3ROb2RlID0gY29udGV4dCA9PiB7XG4gICAgICBjb25zdCBzZWxlY3Rvckxpc3ROb2RlID0gbmV3IEFueVNlbGVjdG9yTm9kZShOb2RlVHlwZS5TZWxlY3Rvckxpc3QpO1xuICAgICAgY29udGV4dC5hc3QgPSBzZWxlY3Rvckxpc3ROb2RlO1xuICAgICAgY29udGV4dC5wYXRoVG9CdWZmZXJOb2RlLnB1c2goc2VsZWN0b3JMaXN0Tm9kZSk7XG4gICAgfTtcbiAgICAvKipcbiAgICAgKiBBZGRzIG5ldyBub2RlIHRvIGJ1ZmZlciBub2RlIGNoaWxkcmVuLlxuICAgICAqIE5ldyBhZGRlZCBub2RlIHdpbGwgYmUgY29uc2lkZXJlZCBhcyBidWZmZXIgbm9kZSBhZnRlciBpdC5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBjb250ZXh0IFNlbGVjdG9yIHBhcnNlciBjb250ZXh0LlxuICAgICAqIEBwYXJhbSB0eXBlIFR5cGUgb2Ygbm9kZSB0byBhZGQuXG4gICAgICogQHBhcmFtIHRva2VuVmFsdWUgT3B0aW9uYWwsIGRlZmF1bHRzIHRvIGAnJ2AsIHZhbHVlIG9mIHByb2Nlc3NpbmcgdG9rZW4uXG4gICAgICpcbiAgICAgKiBAdGhyb3dzIEFuIGVycm9yIGlmIG5vIGJ1ZmZlck5vZGUuXG4gICAgICovXG5cblxuICAgIGNvbnN0IGFkZEFzdE5vZGVCeVR5cGUgPSBmdW5jdGlvbiBhZGRBc3ROb2RlQnlUeXBlKGNvbnRleHQsIHR5cGUpIHtcbiAgICAgIGxldCB0b2tlblZhbHVlID0gYXJndW1lbnRzLmxlbmd0aCA+IDIgJiYgYXJndW1lbnRzWzJdICE9PSB1bmRlZmluZWQgPyBhcmd1bWVudHNbMl0gOiAnJztcbiAgICAgIGNvbnN0IGJ1ZmZlck5vZGUgPSBnZXRCdWZmZXJOb2RlKGNvbnRleHQpO1xuXG4gICAgICBpZiAoYnVmZmVyTm9kZSA9PT0gbnVsbCkge1xuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoJ05vIGJ1ZmZlciBub2RlJyk7XG4gICAgICB9XG5cbiAgICAgIGxldCBub2RlO1xuXG4gICAgICBpZiAodHlwZSA9PT0gTm9kZVR5cGUuUmVndWxhclNlbGVjdG9yKSB7XG4gICAgICAgIG5vZGUgPSBuZXcgUmVndWxhclNlbGVjdG9yTm9kZSh0b2tlblZhbHVlKTtcbiAgICAgIH0gZWxzZSBpZiAodHlwZSA9PT0gTm9kZVR5cGUuQWJzb2x1dGVQc2V1ZG9DbGFzcykge1xuICAgICAgICBub2RlID0gbmV3IEFic29sdXRlUHNldWRvQ2xhc3NOb2RlKHRva2VuVmFsdWUpO1xuICAgICAgfSBlbHNlIGlmICh0eXBlID09PSBOb2RlVHlwZS5SZWxhdGl2ZVBzZXVkb0NsYXNzKSB7XG4gICAgICAgIG5vZGUgPSBuZXcgUmVsYXRpdmVQc2V1ZG9DbGFzc05vZGUodG9rZW5WYWx1ZSk7XG4gICAgICB9IGVsc2Uge1xuICAgICAgICAvLyBTZWxlY3Rvckxpc3QgfHwgU2VsZWN0b3IgfHwgRXh0ZW5kZWRTZWxlY3RvclxuICAgICAgICBub2RlID0gbmV3IEFueVNlbGVjdG9yTm9kZSh0eXBlKTtcbiAgICAgIH1cblxuICAgICAgYnVmZmVyTm9kZS5hZGRDaGlsZChub2RlKTtcbiAgICAgIGNvbnRleHQucGF0aFRvQnVmZmVyTm9kZS5wdXNoKG5vZGUpO1xuICAgIH07XG4gICAgLyoqXG4gICAgICogVGhlIHZlcnkgYmVnaW5uaW5nIG9mIGFzdCBjb2xsZWN0aW5nLlxuICAgICAqXG4gICAgICogQHBhcmFtIGNvbnRleHQgU2VsZWN0b3IgcGFyc2VyIGNvbnRleHQuXG4gICAgICogQHBhcmFtIHRva2VuVmFsdWUgVmFsdWUgb2YgcmVndWxhciBzZWxlY3Rvci5cbiAgICAgKi9cblxuXG4gICAgY29uc3QgaW5pdEFzdCA9IChjb250ZXh0LCB0b2tlblZhbHVlKSA9PiB7XG4gICAgICBhZGRTZWxlY3Rvckxpc3ROb2RlKGNvbnRleHQpO1xuICAgICAgYWRkQXN0Tm9kZUJ5VHlwZShjb250ZXh0LCBOb2RlVHlwZS5TZWxlY3Rvcik7IC8vIFJlZ3VsYXJTZWxlY3RvciBub2RlIGlzIGFsd2F5cyB0aGUgZmlyc3QgY2hpbGQgb2YgU2VsZWN0b3Igbm9kZVxuXG4gICAgICBhZGRBc3ROb2RlQnlUeXBlKGNvbnRleHQsIE5vZGVUeXBlLlJlZ3VsYXJTZWxlY3RvciwgdG9rZW5WYWx1ZSk7XG4gICAgfTtcbiAgICAvKipcbiAgICAgKiBJbml0cyBzZWxlY3RvciBsaXN0IHN1YnRyZWUgZm9yIHJlbGF0aXZlIGV4dGVuZGVkIHBzZXVkby1jbGFzc2VzLCBlLmcuIDpoYXMoKSwgOm5vdCgpLlxuICAgICAqXG4gICAgICogQHBhcmFtIGNvbnRleHQgU2VsZWN0b3IgcGFyc2VyIGNvbnRleHQuXG4gICAgICogQHBhcmFtIHRva2VuVmFsdWUgT3B0aW9uYWwsIGRlZmF1bHRzIHRvIGAnJ2AsIHZhbHVlIG9mIGlubmVyIHJlZ3VsYXIgc2VsZWN0b3IuXG4gICAgICovXG5cblxuICAgIGNvbnN0IGluaXRSZWxhdGl2ZVN1YnRyZWUgPSBmdW5jdGlvbiBpbml0UmVsYXRpdmVTdWJ0cmVlKGNvbnRleHQpIHtcbiAgICAgIGxldCB0b2tlblZhbHVlID0gYXJndW1lbnRzLmxlbmd0aCA+IDEgJiYgYXJndW1lbnRzWzFdICE9PSB1bmRlZmluZWQgPyBhcmd1bWVudHNbMV0gOiAnJztcbiAgICAgIGFkZEFzdE5vZGVCeVR5cGUoY29udGV4dCwgTm9kZVR5cGUuU2VsZWN0b3JMaXN0KTtcbiAgICAgIGFkZEFzdE5vZGVCeVR5cGUoY29udGV4dCwgTm9kZVR5cGUuU2VsZWN0b3IpO1xuICAgICAgYWRkQXN0Tm9kZUJ5VHlwZShjb250ZXh0LCBOb2RlVHlwZS5SZWd1bGFyU2VsZWN0b3IsIHRva2VuVmFsdWUpO1xuICAgIH07XG4gICAgLyoqXG4gICAgICogR29lcyB0byBjbG9zZXN0IHBhcmVudCBzcGVjaWZpZWQgYnkgdHlwZS5cbiAgICAgKiBBY3R1YWxseSB1cGRhdGVzIHBhdGggdG8gYnVmZmVyIG5vZGUgZm9yIHByb3BlciBhc3QgY29sbGVjdGluZyBvZiBzZWxlY3RvcnMgd2hpbGUgcGFyc2luZy5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBjb250ZXh0IFNlbGVjdG9yIHBhcnNlciBjb250ZXh0LlxuICAgICAqIEBwYXJhbSBwYXJlbnRUeXBlIFR5cGUgb2YgbmVlZGVkIHBhcmVudCBub2RlIGluIGFzdC5cbiAgICAgKi9cblxuXG4gICAgY29uc3QgdXBUb0Nsb3Nlc3QgPSAoY29udGV4dCwgcGFyZW50VHlwZSkgPT4ge1xuICAgICAgZm9yIChsZXQgaSA9IGNvbnRleHQucGF0aFRvQnVmZmVyTm9kZS5sZW5ndGggLSAxOyBpID49IDA7IGkgLT0gMSkge1xuICAgICAgICBpZiAoY29udGV4dC5wYXRoVG9CdWZmZXJOb2RlW2ldLnR5cGUgPT09IHBhcmVudFR5cGUpIHtcbiAgICAgICAgICBjb250ZXh0LnBhdGhUb0J1ZmZlck5vZGUgPSBjb250ZXh0LnBhdGhUb0J1ZmZlck5vZGUuc2xpY2UoMCwgaSArIDEpO1xuICAgICAgICAgIGJyZWFrO1xuICAgICAgICB9XG4gICAgICB9XG4gICAgfTtcbiAgICAvKipcbiAgICAgKiBHZXRzIG5lZWRlZCBidWZmZXIgbm9kZSB1cGRhdGVkIGR1ZSB0byBjb21wbGV4IHNlbGVjdG9yIHBhcnNpbmcuXG4gICAgICpcbiAgICAgKiBAcGFyYW0gY29udGV4dCBTZWxlY3RvciBwYXJzZXIgY29udGV4dC5cbiAgICAgKlxuICAgICAqIEB0aHJvd3MgQW4gZXJyb3IgaWYgdGhlcmUgaXMgbm8gdXBwZXIgU2VsZWN0b3JOb2RlIGlzIGFzdC5cbiAgICAgKi9cblxuXG4gICAgY29uc3QgZ2V0VXBkYXRlZEJ1ZmZlck5vZGUgPSBjb250ZXh0ID0+IHtcbiAgICAgIHVwVG9DbG9zZXN0KGNvbnRleHQsIE5vZGVUeXBlLlNlbGVjdG9yKTtcbiAgICAgIGNvbnN0IHNlbGVjdG9yTm9kZSA9IGdldEJ1ZmZlck5vZGUoY29udGV4dCk7XG5cbiAgICAgIGlmICghc2VsZWN0b3JOb2RlKSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcignTm8gU2VsZWN0b3JOb2RlLCBpbXBvc3NpYmxlIHRvIGNvbnRpbnVlIHNlbGVjdG9yIHBhcnNpbmcgYnkgRXh0ZW5kZWRDc3MnKTtcbiAgICAgIH1cblxuICAgICAgY29uc3QgbGFzdFNlbGVjdG9yTm9kZUNoaWxkID0gZ2V0TGFzdChzZWxlY3Rvck5vZGUuY2hpbGRyZW4pO1xuICAgICAgY29uc3QgaGFzRXh0ZW5kZWQgPSBsYXN0U2VsZWN0b3JOb2RlQ2hpbGQudHlwZSA9PT0gTm9kZVR5cGUuRXh0ZW5kZWRTZWxlY3RvciAvLyBwYXJzZXIgcG9zaXRpb24gbWlnaHQgYmUgaW5zaWRlIHN0YW5kYXJkIHBzZXVkby1jbGFzcyBicmFja2V0cyB3aGljaCBoYXMgc3BhY2VcbiAgICAgIC8vIGUuZy4gJ2Rpdjpjb250YWlucygv0LAvKTpudGgtY2hpbGQoMTAwbiArIDIpJ1xuICAgICAgJiYgY29udGV4dC5zdGFuZGFyZFBzZXVkb0JyYWNrZXRzU3RhY2subGVuZ3RoID09PSAwO1xuICAgICAgY29uc3QgbGFzdEV4dGVuZGVkUHNldWRvTmFtZSA9IGhhc0V4dGVuZGVkICYmIGxhc3RTZWxlY3Rvck5vZGVDaGlsZC5jaGlsZHJlblswXS5uYW1lO1xuICAgICAgY29uc3QgaXNMYXN0RXh0ZW5kZWROYW1lUmVsYXRpdmUgPSBsYXN0RXh0ZW5kZWRQc2V1ZG9OYW1lICYmIFJFTEFUSVZFX1BTRVVET19DTEFTU0VTLmluY2x1ZGVzKGxhc3RFeHRlbmRlZFBzZXVkb05hbWUpO1xuICAgICAgY29uc3QgaXNMYXN0RXh0ZW5kZWROYW1lQWJzb2x1dGUgPSBsYXN0RXh0ZW5kZWRQc2V1ZG9OYW1lICYmIEFCU09MVVRFX1BTRVVET19DTEFTU0VTLmluY2x1ZGVzKGxhc3RFeHRlbmRlZFBzZXVkb05hbWUpO1xuICAgICAgY29uc3QgaGFzUmVsYXRpdmVFeHRlbmRlZCA9IGlzTGFzdEV4dGVuZGVkTmFtZVJlbGF0aXZlICYmIGNvbnRleHQuZXh0ZW5kZWRQc2V1ZG9CcmFja2V0c1N0YWNrLmxlbmd0aCA+IDAgJiYgY29udGV4dC5leHRlbmRlZFBzZXVkb0JyYWNrZXRzU3RhY2subGVuZ3RoID09PSBjb250ZXh0LmV4dGVuZGVkUHNldWRvTmFtZXNTdGFjay5sZW5ndGg7XG4gICAgICBjb25zdCBoYXNBYnNvbHV0ZUV4dGVuZGVkID0gaXNMYXN0RXh0ZW5kZWROYW1lQWJzb2x1dGUgJiYgbGFzdEV4dGVuZGVkUHNldWRvTmFtZSA9PT0gZ2V0TGFzdChjb250ZXh0LmV4dGVuZGVkUHNldWRvTmFtZXNTdGFjayk7XG4gICAgICBsZXQgbmV3TmVlZGVkQnVmZmVyTm9kZSA9IHNlbGVjdG9yTm9kZTtcblxuICAgICAgaWYgKGhhc1JlbGF0aXZlRXh0ZW5kZWQpIHtcbiAgICAgICAgLy8gcmV0dXJuIHJlbGF0aXZlIHNlbGVjdG9yIG5vZGUgdG8gdXBkYXRlIGxhdGVyXG4gICAgICAgIGNvbnRleHQucGF0aFRvQnVmZmVyTm9kZS5wdXNoKGxhc3RTZWxlY3Rvck5vZGVDaGlsZCk7XG4gICAgICAgIG5ld05lZWRlZEJ1ZmZlck5vZGUgPSBsYXN0U2VsZWN0b3JOb2RlQ2hpbGQuY2hpbGRyZW5bMF07XG4gICAgICB9IGVsc2UgaWYgKGhhc0Fic29sdXRlRXh0ZW5kZWQpIHtcbiAgICAgICAgLy8gcmV0dXJuIGFic29sdXRlIHNlbGVjdG9yIG5vZGUgdG8gdXBkYXRlIGxhdGVyXG4gICAgICAgIGNvbnRleHQucGF0aFRvQnVmZmVyTm9kZS5wdXNoKGxhc3RTZWxlY3Rvck5vZGVDaGlsZCk7XG4gICAgICAgIG5ld05lZWRlZEJ1ZmZlck5vZGUgPSBsYXN0U2VsZWN0b3JOb2RlQ2hpbGQuY2hpbGRyZW5bMF07XG4gICAgICB9IGVsc2UgaWYgKGhhc0V4dGVuZGVkKSB7XG4gICAgICAgIC8vIHJldHVybiBzZWxlY3RvciBub2RlIHRvIGFkZCBuZXcgcmVndWxhciBzZWxlY3RvciBub2RlIGxhdGVyXG4gICAgICAgIG5ld05lZWRlZEJ1ZmZlck5vZGUgPSBzZWxlY3Rvck5vZGU7XG4gICAgICB9IGVsc2Uge1xuICAgICAgICAvLyBvdGhlcndpc2UgcmV0dXJuIGxhc3QgcmVndWxhciBzZWxlY3RvciBub2RlIHRvIHVwZGF0ZSBsYXRlclxuICAgICAgICBuZXdOZWVkZWRCdWZmZXJOb2RlID0gZ2V0TGFzdFJlZ3VsYXJTZWxlY3Rvck5vZGUoY29udGV4dCk7XG4gICAgICB9XG5cbiAgICAgIGNvbnRleHQucGF0aFRvQnVmZmVyTm9kZS5wdXNoKG5ld05lZWRlZEJ1ZmZlck5vZGUpO1xuICAgICAgcmV0dXJuIG5ld05lZWRlZEJ1ZmZlck5vZGU7XG4gICAgfTtcbiAgICAvKipcbiAgICAgKiBDaGVja3MgdmFsdWVzIG9mIGZldyBuZXh0IHRva2VucyBvbiBjb2xvbiB0b2tlbiBgOmAgYW5kOlxuICAgICAqICAtIHVwZGF0ZXMgYnVmZmVyIG5vZGUgZm9yIGZvbGxvd2luZyBzdGFuZGFyZCBwc2V1ZG8tY2xhc3M7XG4gICAgICogIC0gYWRkcyBleHRlbmRlZCBzZWxlY3RvciBhc3Qgbm9kZSBmb3IgZm9sbG93aW5nIGV4dGVuZGVkIHBzZXVkby1jbGFzcztcbiAgICAgKiAgLSB2YWxpZGF0ZXMgc29tZSBjYXNlcyBvZiBgOnJlbW92ZSgpYCBhbmQgYDpoYXMoKWAgdXNhZ2UuXG4gICAgICpcbiAgICAgKiBAcGFyYW0gY29udGV4dCBTZWxlY3RvciBwYXJzZXIgY29udGV4dC5cbiAgICAgKiBAcGFyYW0gc2VsZWN0b3IgU2VsZWN0b3IuXG4gICAgICogQHBhcmFtIHRva2VuVmFsdWUgVmFsdWUgb2YgY3VycmVudCB0b2tlbi5cbiAgICAgKiBAcGFyYW0gbmV4dFRva2VuVmFsdWUgVmFsdWUgb2YgdG9rZW4gbmV4dCB0byBjdXJyZW50IG9uZS5cbiAgICAgKiBAcGFyYW0gbmV4dFRvTmV4dFRva2VuVmFsdWUgVmFsdWUgb2YgdG9rZW4gbmV4dCB0byBuZXh0IHRvIGN1cnJlbnQgb25lLlxuICAgICAqXG4gICAgICogQHRocm93cyBBbiBlcnJvciBvbiA6cmVtb3ZlKCkgcHNldWRvLWNsYXNzIGluIHNlbGVjdG9yXG4gICAgICogb3IgOmhhcygpIGluc2lkZSByZWd1bGFyIHBzZXVkbyBsaW1pdGF0aW9uLlxuICAgICAqL1xuXG5cbiAgICBjb25zdCBoYW5kbGVOZXh0VG9rZW5PbkNvbG9uID0gKGNvbnRleHQsIHNlbGVjdG9yLCB0b2tlblZhbHVlLCBuZXh0VG9rZW5WYWx1ZSwgbmV4dFRvTmV4dFRva2VuVmFsdWUpID0+IHtcbiAgICAgIGlmICghaXNTdXBwb3J0ZWRFeHRlbmRlZFBzZXVkbyhuZXh0VG9rZW5WYWx1ZS50b0xvd2VyQ2FzZSgpKSkge1xuICAgICAgICBpZiAobmV4dFRva2VuVmFsdWUudG9Mb3dlckNhc2UoKSA9PT0gUkVNT1ZFX1BTRVVET19NQVJLRVIpIHtcbiAgICAgICAgICAvLyA6cmVtb3ZlKCkgcHNldWRvLWNsYXNzIHNob3VsZCBiZSBoYW5kbGVkIGJlZm9yZVxuICAgICAgICAgIC8vIGFzIGl0IGlzIG5vdCBhYm91dCBlbGVtZW50IHNlbGVjdGluZyBidXQgYWN0aW9ucyB3aXRoIGVsZW1lbnRzXG4gICAgICAgICAgLy8gZS5nLiAnYm9keSA+IGRpdjplbXB0eTpyZW1vdmUoKSdcbiAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJTZWxlY3RvciBwYXJzZXIgZXJyb3I6IGludmFsaWQgOnJlbW92ZSgpIHBzZXVkby1jbGFzcyBpbiBzZWxlY3RvcjogJ1wiLmNvbmNhdChzZWxlY3RvciwgXCInXCIpKTsgLy8gZXNsaW50LWRpc2FibGUtbGluZSBtYXgtbGVuXG4gICAgICAgIH0gLy8gaWYgZm9sbG93aW5nIHRva2VuIGlzIG5vdCBhbiBleHRlbmRlZCBwc2V1ZG9cbiAgICAgICAgLy8gdGhlIGNvbG9uIHNob3VsZCBiZSBjb2xsZWN0ZWQgdG8gdmFsdWUgb2YgUmVndWxhclNlbGVjdG9yXG4gICAgICAgIC8vIGUuZy4gJy5lbnRyeV90ZXh0Om50aC1jaGlsZCgyKSdcblxuXG4gICAgICAgIHVwZGF0ZUJ1ZmZlck5vZGUoY29udGV4dCwgdG9rZW5WYWx1ZSk7IC8vIGNoZWNrIHRoZSB0b2tlbiBhZnRlciB0aGUgcHNldWRvIGFuZCBkbyBiYWxhbmNlIHBhcmVudGhlc2VzIGxhdGVyXG4gICAgICAgIC8vIG9ubHkgaWYgaXQgaXMgZnVuY3Rpb25hbCBwc2V1ZG8tY2xhc3MgKHN0YW5kYXJkIHdpdGggYnJhY2tldHMsIGUuZy4gJzpsYW5nKCknKS5cbiAgICAgICAgLy8gbm8gYnJhY2tldHMgYmFsYW5jZSBuZWVkZWQgZm9yIHN1Y2ggY2FzZSxcbiAgICAgICAgLy8gcGFyc2VyIHBvc2l0aW9uIGlzIG9uIGZpcnN0IGNvbG9uIGFmdGVyIHRoZSAnZGl2JzpcbiAgICAgICAgLy8gZS5nLiAnZGl2Omxhc3QtY2hpbGQ6aGFzKGJ1dHRvbi5wcml2YWN5LXBvbGljeV9fYnRuKSdcblxuICAgICAgICBpZiAobmV4dFRvTmV4dFRva2VuVmFsdWUgPT09IEJSQUNLRVRTLlBBUkVOVEhFU0VTLkxFRlQgLy8gbm8gYnJhY2tldHMgYmFsYW5jZSBuZWVkZWQgZm9yIHBhcmVudGhlc2VzIGluc2lkZSBhdHRyaWJ1dGUgdmFsdWVcbiAgICAgICAgLy8gZS5nLiAnYVtocmVmPVwiamF2YXNjcmlwdDp2b2lkKDApXCJdJyAgIDwtLSBwYXJzZXIgcG9zaXRpb24gaXMgb24gY29sb24gYDpgXG4gICAgICAgIC8vIGJlZm9yZSBgdm9pZGAgICAgICAgICAgIOKGkVxuICAgICAgICAmJiAhY29udGV4dC5pc0F0dHJpYnV0ZUJyYWNrZXRzT3Blbikge1xuICAgICAgICAgIGNvbnRleHQuc3RhbmRhcmRQc2V1ZG9OYW1lc1N0YWNrLnB1c2gobmV4dFRva2VuVmFsdWUpO1xuICAgICAgICB9XG4gICAgICB9IGVsc2Uge1xuICAgICAgICAvLyBpdCBpcyBzdXBwb3J0ZWQgZXh0ZW5kZWQgcHNldWRvLWNsYXNzLlxuICAgICAgICAvLyBEaXNhbGxvdyA6aGFzKCkgaW5zaWRlIHRoZSBwc2V1ZG9zIGFjY2VwdGluZyBvbmx5IGNvbXBvdW5kIHNlbGVjdG9yc1xuICAgICAgICAvLyBodHRwczovL2J1Z3MuY2hyb21pdW0ub3JnL3AvY2hyb21pdW0vaXNzdWVzL2RldGFpbD9pZD02NjkwNTgjYzU0IFsyXVxuICAgICAgICBpZiAoSEFTX1BTRVVET19DTEFTU19NQVJLRVJTLmluY2x1ZGVzKG5leHRUb2tlblZhbHVlKSAmJiBjb250ZXh0LnN0YW5kYXJkUHNldWRvTmFtZXNTdGFjay5sZW5ndGggPiAwKSB7XG4gICAgICAgICAgLy8gZXNsaW50LWRpc2FibGUtbmV4dC1saW5lIG1heC1sZW5cbiAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJVc2FnZSBvZiA6XCIuY29uY2F0KG5leHRUb2tlblZhbHVlLCBcIigpIHBzZXVkby1jbGFzcyBpcyBub3QgYWxsb3dlZCBpbnNpZGUgcmVndWxhciBwc2V1ZG86ICdcIikuY29uY2F0KGdldExhc3QoY29udGV4dC5zdGFuZGFyZFBzZXVkb05hbWVzU3RhY2spLCBcIidcIikpO1xuICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgIC8vIHN0b3AgUmVndWxhclNlbGVjdG9yIHZhbHVlIGNvbGxlY3RpbmdcbiAgICAgICAgICB1cFRvQ2xvc2VzdChjb250ZXh0LCBOb2RlVHlwZS5TZWxlY3Rvcik7IC8vIGFkZCBFeHRlbmRlZFNlbGVjdG9yIHRvIFNlbGVjdG9yIGNoaWxkcmVuXG5cbiAgICAgICAgICBhZGRBc3ROb2RlQnlUeXBlKGNvbnRleHQsIE5vZGVUeXBlLkV4dGVuZGVkU2VsZWN0b3IpO1xuICAgICAgICB9XG4gICAgICB9XG4gICAgfTtcbiAgICAvKipcbiAgICAgKiBQYXJzZXMgc2VsZWN0b3IgaW50byBhc3QgZm9yIGZvbGxvd2luZyBlbGVtZW50IHNlbGVjdGlvbi5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBzZWxlY3RvciBTZWxlY3RvciB0byBwYXJzZS5cbiAgICAgKlxuICAgICAqIEB0aHJvd3MgQW4gZXJyb3Igb24gaW52YWxpZCBzZWxlY3Rvci5cbiAgICAgKi9cblxuXG4gICAgY29uc3QgcGFyc2UkMSA9IHNlbGVjdG9yID0+IHtcbiAgICAgIHZhciBfYnVmZmVyTm9kZSwgX2J1ZmZlck5vZGUyLCBfYnVmZmVyTm9kZTMsIF9idWZmZXJOb2RlNCwgX2J1ZmZlck5vZGU1LCBfYnVmZmVyTm9kZTYsIF9idWZmZXJOb2RlNywgX2J1ZmZlck5vZGU4LCBfYnVmZmVyTm9kZTksIF9idWZmZXJOb2RlMTAsIF9idWZmZXJOb2RlMTEsIF9idWZmZXJOb2RlMTIsIF9idWZmZXJOb2RlMTMsIF9idWZmZXJOb2RlMTQsIF9idWZmZXJOb2RlMTUsIF9idWZmZXJOb2RlMTYsIF9idWZmZXJOb2RlMTcsIF9idWZmZXJOb2RlMTgsIF9idWZmZXJOb2RlMTksIF9idWZmZXJOb2RlMjA7XG5cbiAgICAgIGNvbnN0IHRva2VucyA9IHRva2VuaXplKHNlbGVjdG9yKTtcbiAgICAgIGNvbnN0IGNvbnRleHQgPSB7XG4gICAgICAgIGFzdDogbnVsbCxcbiAgICAgICAgcGF0aFRvQnVmZmVyTm9kZTogW10sXG4gICAgICAgIGV4dGVuZGVkUHNldWRvTmFtZXNTdGFjazogW10sXG4gICAgICAgIGV4dGVuZGVkUHNldWRvQnJhY2tldHNTdGFjazogW10sXG4gICAgICAgIHN0YW5kYXJkUHNldWRvTmFtZXNTdGFjazogW10sXG4gICAgICAgIHN0YW5kYXJkUHNldWRvQnJhY2tldHNTdGFjazogW10sXG4gICAgICAgIGlzQXR0cmlidXRlQnJhY2tldHNPcGVuOiBmYWxzZSxcbiAgICAgICAgaXNSZWdleHBPcGVuOiBmYWxzZVxuICAgICAgfTtcbiAgICAgIGxldCBpID0gMDtcblxuICAgICAgd2hpbGUgKGkgPCB0b2tlbnMubGVuZ3RoKSB7XG4gICAgICAgIGNvbnN0IHRva2VuID0gdG9rZW5zW2ldOyAvLyBUb2tlbiB0byBwcm9jZXNzXG5cbiAgICAgICAgY29uc3QgdG9rZW5UeXBlID0gdG9rZW4udHlwZSxcbiAgICAgICAgICAgICAgdG9rZW5WYWx1ZSA9IHRva2VuLnZhbHVlOyAvLyBuZWVkZWQgZm9yIFNQQUNFIGFuZCBDT0xPTiB0b2tlbnMgY2hlY2tpbmdcblxuICAgICAgICBjb25zdCBuZXh0VG9rZW4gPSB0b2tlbnNbaSArIDFdIHx8IFtdO1xuICAgICAgICBjb25zdCBuZXh0VG9rZW5UeXBlID0gbmV4dFRva2VuLnR5cGUsXG4gICAgICAgICAgICAgIG5leHRUb2tlblZhbHVlID0gbmV4dFRva2VuLnZhbHVlOyAvLyBuZWVkZWQgZm9yIGxpbWl0YXRpb25zXG4gICAgICAgIC8vIC0gOm5vdCgpIGFuZCA6aXMoKSByb290IGVsZW1lbnRcbiAgICAgICAgLy8gLSA6aGFzKCkgdXNhZ2VcbiAgICAgICAgLy8gLSB3aGl0ZSBzcGFjZSBiZWZvcmUgYW5kIGFmdGVyIHBzZXVkby1jbGFzcyBuYW1lXG5cbiAgICAgICAgY29uc3QgbmV4dFRvTmV4dFRva2VuID0gdG9rZW5zW2kgKyAyXSB8fCBbXTtcbiAgICAgICAgY29uc3QgbmV4dFRvTmV4dFRva2VuVmFsdWUgPSBuZXh0VG9OZXh0VG9rZW4udmFsdWU7IC8vIG5lZWRlZCBmb3IgQ09MT04gdG9rZW4gY2hlY2tpbmcgZm9yIG5vbmUtc3BlY2lmaWVkIHJlZ3VsYXIgc2VsZWN0b3IgYmVmb3JlIGV4dGVuZGVkIG9uZVxuICAgICAgICAvLyBlLmcuICdwLCA6aG92ZXInXG4gICAgICAgIC8vIG9yICAgJy5iYW5uZXIsIDpjb250YWlucyhhZHMpJ1xuXG4gICAgICAgIGNvbnN0IHByZXZpb3VzVG9rZW4gPSB0b2tlbnNbaSAtIDFdIHx8IFtdO1xuICAgICAgICBjb25zdCBwcmV2VG9rZW5UeXBlID0gcHJldmlvdXNUb2tlbi50eXBlLFxuICAgICAgICAgICAgICBwcmV2VG9rZW5WYWx1ZSA9IHByZXZpb3VzVG9rZW4udmFsdWU7IC8vIG5lZWRlZCBmb3IgcHJvcGVyIHBhcnNpbmcgb2YgcmVnZXhwIHBhdHRlcm4gYXJnXG4gICAgICAgIC8vIGUuZy4gJzptYXRjaGVzLWNzcyhiYWNrZ3JvdW5kLWltYWdlOiAvXnVybFxcKGh0dHBzOlxcL1xcL2V4YW1wbGVcXC5vcmdcXC8vKSdcblxuICAgICAgICBjb25zdCBwcmV2aW91c1RvUHJldmlvdXNUb2tlbiA9IHRva2Vuc1tpIC0gMl0gfHwgW107XG4gICAgICAgIGNvbnN0IHByZXZUb1ByZXZUb2tlblZhbHVlID0gcHJldmlvdXNUb1ByZXZpb3VzVG9rZW4udmFsdWU7XG4gICAgICAgIGxldCBidWZmZXJOb2RlID0gZ2V0QnVmZmVyTm9kZShjb250ZXh0KTtcblxuICAgICAgICBzd2l0Y2ggKHRva2VuVHlwZSkge1xuICAgICAgICAgIGNhc2UgVG9rZW5UeXBlLldvcmQ6XG4gICAgICAgICAgICBpZiAoYnVmZmVyTm9kZSA9PT0gbnVsbCkge1xuICAgICAgICAgICAgICAvLyB0aGVyZSBpcyBubyBidWZmZXIgbm9kZSBvbmx5IGluIG9uZSBjYXNlIOKAlCBubyBhc3QgY29sbGVjdGluZyBoYXMgYmVlbiBzdGFydGVkXG4gICAgICAgICAgICAgIGluaXRBc3QoY29udGV4dCwgdG9rZW5WYWx1ZSk7XG4gICAgICAgICAgICB9IGVsc2UgaWYgKGJ1ZmZlck5vZGUudHlwZSA9PT0gTm9kZVR5cGUuU2VsZWN0b3JMaXN0KSB7XG4gICAgICAgICAgICAgIC8vIGFkZCBuZXcgc2VsZWN0b3IgdG8gc2VsZWN0b3IgbGlzdFxuICAgICAgICAgICAgICBhZGRBc3ROb2RlQnlUeXBlKGNvbnRleHQsIE5vZGVUeXBlLlNlbGVjdG9yKTtcbiAgICAgICAgICAgICAgYWRkQXN0Tm9kZUJ5VHlwZShjb250ZXh0LCBOb2RlVHlwZS5SZWd1bGFyU2VsZWN0b3IsIHRva2VuVmFsdWUpO1xuICAgICAgICAgICAgfSBlbHNlIGlmIChidWZmZXJOb2RlLnR5cGUgPT09IE5vZGVUeXBlLlJlZ3VsYXJTZWxlY3Rvcikge1xuICAgICAgICAgICAgICB1cGRhdGVCdWZmZXJOb2RlKGNvbnRleHQsIHRva2VuVmFsdWUpO1xuICAgICAgICAgICAgfSBlbHNlIGlmIChidWZmZXJOb2RlLnR5cGUgPT09IE5vZGVUeXBlLkV4dGVuZGVkU2VsZWN0b3IpIHtcbiAgICAgICAgICAgICAgLy8gTm8gd2hpdGUgc3BhY2UgaXMgYWxsb3dlZCBiZXR3ZWVuIHRoZSBuYW1lIG9mIGV4dGVuZGVkIHBzZXVkby1jbGFzc1xuICAgICAgICAgICAgICAvLyBhbmQgaXRzIG9wZW5pbmcgcGFyZW50aGVzaXNcbiAgICAgICAgICAgICAgLy8gaHR0cHM6Ly93d3cudzMub3JnL1RSL3NlbGVjdG9ycy00LyNwc2V1ZG8tY2xhc3Nlc1xuICAgICAgICAgICAgICAvLyBlLmcuICdzcGFuOmNvbnRhaW5zICh0ZXh0KSdcbiAgICAgICAgICAgICAgaWYgKFdISVRFX1NQQUNFX0NIQVJBQ1RFUlMuaW5jbHVkZXMobmV4dFRva2VuVmFsdWUpICYmIG5leHRUb05leHRUb2tlblZhbHVlID09PSBCUkFDS0VUUy5QQVJFTlRIRVNFUy5MRUZUKSB7XG4gICAgICAgICAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiTm8gd2hpdGUgc3BhY2UgaXMgYWxsb3dlZCBiZWZvcmUgb3IgYWZ0ZXIgZXh0ZW5kZWQgcHNldWRvLWNsYXNzIG5hbWUgaW4gc2VsZWN0b3I6ICdcIi5jb25jYXQoc2VsZWN0b3IsIFwiJ1wiKSk7IC8vIGVzbGludC1kaXNhYmxlLWxpbmUgbWF4LWxlblxuICAgICAgICAgICAgICB9IC8vIHNhdmUgcHNldWRvLWNsYXNzIG5hbWUgZm9yIGJyYWNrZXRzIGJhbGFuY2UgY2hlY2tpbmdcblxuXG4gICAgICAgICAgICAgIGNvbnRleHQuZXh0ZW5kZWRQc2V1ZG9OYW1lc1N0YWNrLnB1c2godG9rZW5WYWx1ZS50b0xvd2VyQ2FzZSgpKTsgLy8gZXh0ZW5kZWQgcHNldWRvLWNsYXNzIG5hbWUgYXJlIHBhcnNlZCBpbiBsb3dlciBjYXNlXG4gICAgICAgICAgICAgIC8vIGFzIHRoZXkgc2hvdWxkIGJlIGNhc2UtaW5zZW5zaXRpdmVcbiAgICAgICAgICAgICAgLy8gaHR0cHM6Ly93d3cudzMub3JnL1RSL3NlbGVjdG9ycy00LyNwc2V1ZG8tY2xhc3Nlc1xuXG4gICAgICAgICAgICAgIGlmIChBQlNPTFVURV9QU0VVRE9fQ0xBU1NFUy5pbmNsdWRlcyh0b2tlblZhbHVlLnRvTG93ZXJDYXNlKCkpKSB7XG4gICAgICAgICAgICAgICAgYWRkQXN0Tm9kZUJ5VHlwZShjb250ZXh0LCBOb2RlVHlwZS5BYnNvbHV0ZVBzZXVkb0NsYXNzLCB0b2tlblZhbHVlLnRvTG93ZXJDYXNlKCkpO1xuICAgICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICAgIC8vIGlmIGl0IGlzIG5vdCBhYnNvbHV0ZSBwc2V1ZG8tY2xhc3MsIGl0IG11c3QgYmUgcmVsYXRpdmUgb25lXG4gICAgICAgICAgICAgICAgLy8gYWRkIFJlbGF0aXZlUHNldWRvQ2xhc3Mgd2l0aCB0b2tlblZhbHVlIGFzIHBzZXVkby1jbGFzcyBuYW1lIHRvIEV4dGVuZGVkU2VsZWN0b3IgY2hpbGRyZW5cbiAgICAgICAgICAgICAgICBhZGRBc3ROb2RlQnlUeXBlKGNvbnRleHQsIE5vZGVUeXBlLlJlbGF0aXZlUHNldWRvQ2xhc3MsIHRva2VuVmFsdWUudG9Mb3dlckNhc2UoKSk7XG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH0gZWxzZSBpZiAoYnVmZmVyTm9kZS50eXBlID09PSBOb2RlVHlwZS5BYnNvbHV0ZVBzZXVkb0NsYXNzKSB7XG4gICAgICAgICAgICAgIC8vIGNvbGxlY3QgYWJzb2x1dGUgcHNldWRvLWNsYXNzIGFyZ1xuICAgICAgICAgICAgICB1cGRhdGVCdWZmZXJOb2RlKGNvbnRleHQsIHRva2VuVmFsdWUpO1xuICAgICAgICAgICAgfSBlbHNlIGlmIChidWZmZXJOb2RlLnR5cGUgPT09IE5vZGVUeXBlLlJlbGF0aXZlUHNldWRvQ2xhc3MpIHtcbiAgICAgICAgICAgICAgaW5pdFJlbGF0aXZlU3VidHJlZShjb250ZXh0LCB0b2tlblZhbHVlKTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgYnJlYWs7XG5cbiAgICAgICAgICBjYXNlIFRva2VuVHlwZS5NYXJrOlxuICAgICAgICAgICAgc3dpdGNoICh0b2tlblZhbHVlKSB7XG4gICAgICAgICAgICAgIGNhc2UgQ09NTUE6XG4gICAgICAgICAgICAgICAgaWYgKCFidWZmZXJOb2RlIHx8IHR5cGVvZiBidWZmZXJOb2RlICE9PSAndW5kZWZpbmVkJyAmJiAhbmV4dFRva2VuVmFsdWUpIHtcbiAgICAgICAgICAgICAgICAgIC8vIGNvbnNpZGVyIHRoZSBzZWxlY3RvciBpcyBpbnZhbGlkIGlmIHRoZXJlIGlzIG5vIGJ1ZmZlck5vZGUgeWV0IChlLmcuICcsIGEnKVxuICAgICAgICAgICAgICAgICAgLy8gb3IgdGhlcmUgaXMgbm90aGluZyBhZnRlciB0aGUgY29tbWEgd2hpbGUgYnVmZmVyTm9kZSBpcyBkZWZpbmVkIChlLmcuICdkaXYsICcpXG4gICAgICAgICAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCInXCIuY29uY2F0KHNlbGVjdG9yLCBcIicgaXMgbm90IGEgdmFsaWQgc2VsZWN0b3JcIikpO1xuICAgICAgICAgICAgICAgIH0gZWxzZSBpZiAoYnVmZmVyTm9kZS50eXBlID09PSBOb2RlVHlwZS5SZWd1bGFyU2VsZWN0b3IpIHtcbiAgICAgICAgICAgICAgICAgIGlmIChjb250ZXh0LmlzQXR0cmlidXRlQnJhY2tldHNPcGVuKSB7XG4gICAgICAgICAgICAgICAgICAgIC8vIHRoZSBjb21tYSBtaWdodCBiZSBpbnNpZGUgZWxlbWVudCBhdHRyaWJ1dGUgdmFsdWVcbiAgICAgICAgICAgICAgICAgICAgLy8gZS5nLiAnZGl2W2RhdGEtY29tbWE9XCIwLDFcIl0nXG4gICAgICAgICAgICAgICAgICAgIHVwZGF0ZUJ1ZmZlck5vZGUoY29udGV4dCwgdG9rZW5WYWx1ZSk7XG4gICAgICAgICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICAgICAgICAvLyBuZXcgU2VsZWN0b3Igc2hvdWxkIGJlIGNvbGxlY3RlZCB0byB1cHBlciBTZWxlY3Rvckxpc3RcbiAgICAgICAgICAgICAgICAgICAgdXBUb0Nsb3Nlc3QoY29udGV4dCwgTm9kZVR5cGUuU2VsZWN0b3JMaXN0KTtcbiAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICB9IGVsc2UgaWYgKGJ1ZmZlck5vZGUudHlwZSA9PT0gTm9kZVR5cGUuQWJzb2x1dGVQc2V1ZG9DbGFzcykge1xuICAgICAgICAgICAgICAgICAgLy8gdGhlIGNvbW1hIGluc2lkZSBhcmcgb2YgYWJzb2x1dGUgZXh0ZW5kZWQgcHNldWRvXG4gICAgICAgICAgICAgICAgICAvLyBlLmcuICdkaXY6eHBhdGgoLy9oM1tjb250YWlucyh0ZXh0KCksXCJTaGFyZSBpdCFcIildLy4uKSdcbiAgICAgICAgICAgICAgICAgIHVwZGF0ZUJ1ZmZlck5vZGUoY29udGV4dCwgdG9rZW5WYWx1ZSk7XG4gICAgICAgICAgICAgICAgfSBlbHNlIGlmICgoKF9idWZmZXJOb2RlID0gYnVmZmVyTm9kZSkgPT09IG51bGwgfHwgX2J1ZmZlck5vZGUgPT09IHZvaWQgMCA/IHZvaWQgMCA6IF9idWZmZXJOb2RlLnR5cGUpID09PSBOb2RlVHlwZS5TZWxlY3Rvcikge1xuICAgICAgICAgICAgICAgICAgLy8gbmV3IFNlbGVjdG9yIHNob3VsZCBiZSBjb2xsZWN0ZWQgdG8gdXBwZXIgU2VsZWN0b3JMaXN0XG4gICAgICAgICAgICAgICAgICAvLyBpZiBwYXJzZXIgcG9zaXRpb24gaXMgb24gU2VsZWN0b3Igbm9kZVxuICAgICAgICAgICAgICAgICAgdXBUb0Nsb3Nlc3QoY29udGV4dCwgTm9kZVR5cGUuU2VsZWN0b3JMaXN0KTtcbiAgICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgICBicmVhaztcblxuICAgICAgICAgICAgICBjYXNlIFNQQUNFOlxuICAgICAgICAgICAgICAgIC8vIGl0IG1pZ2h0IGJlIGNvbXBsZXggc2VsZWN0b3Igd2l0aCBleHRlbmRlZCBwc2V1ZG8tY2xhc3MgaW5zaWRlIGl0XG4gICAgICAgICAgICAgICAgLy8gYW5kIHRoZSBzcGFjZSBpcyBiZXR3ZWVuIHRoYXQgY29tcGxleCBzZWxlY3RvciBhbmQgZm9sbG93aW5nIHJlZ3VsYXIgc2VsZWN0b3JcbiAgICAgICAgICAgICAgICAvLyBwYXJzZXIgcG9zaXRpb24gaXMgb24gYCBgIGJlZm9yZSBgc3BhbmAgbm93OlxuICAgICAgICAgICAgICAgIC8vIGUuZy4gJ2RpdjpoYXMoaW1nKS5iYW5uZXIgc3BhbidcbiAgICAgICAgICAgICAgICAvLyBzbyB3ZSBuZWVkIHRvIGNoZWNrIHdoZXRoZXIgdGhlIG5ldyBhc3Qgbm9kZSBzaG91bGQgYmUgYWRkZWQgKGV4YW1wbGUgYWJvdmUpXG4gICAgICAgICAgICAgICAgLy8gb3IgcHJldmlvdXMgcmVndWxhciBzZWxlY3RvciBub2RlIHNob3VsZCBiZSB1cGRhdGVkXG4gICAgICAgICAgICAgICAgaWYgKCgoX2J1ZmZlck5vZGUyID0gYnVmZmVyTm9kZSkgPT09IG51bGwgfHwgX2J1ZmZlck5vZGUyID09PSB2b2lkIDAgPyB2b2lkIDAgOiBfYnVmZmVyTm9kZTIudHlwZSkgPT09IE5vZGVUeXBlLlJlZ3VsYXJTZWxlY3RvciAvLyBubyBuZWVkIHRvIHVwZGF0ZSB0aGUgYnVmZmVyIG5vZGUgaWYgYXR0cmlidXRlIHZhbHVlIGlzIGJlaW5nIHBhcnNlZFxuICAgICAgICAgICAgICAgIC8vIGUuZy4gJ2Rpdjpub3QoW2lkXSlbc3R5bGU9XCJwb3NpdGlvbjogYWJzb2x1dGU7IHotaW5kZXg6IDEwMDAwO1wiXSdcbiAgICAgICAgICAgICAgICAvLyBwYXJzZXIgcG9zaXRpb24gaW5zaWRlIGF0dHJpYnV0ZSAgICDihpFcbiAgICAgICAgICAgICAgICAmJiAhY29udGV4dC5pc0F0dHJpYnV0ZUJyYWNrZXRzT3Blbikge1xuICAgICAgICAgICAgICAgICAgYnVmZmVyTm9kZSA9IGdldFVwZGF0ZWRCdWZmZXJOb2RlKGNvbnRleHQpO1xuICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgIGlmICgoKF9idWZmZXJOb2RlMyA9IGJ1ZmZlck5vZGUpID09PSBudWxsIHx8IF9idWZmZXJOb2RlMyA9PT0gdm9pZCAwID8gdm9pZCAwIDogX2J1ZmZlck5vZGUzLnR5cGUpID09PSBOb2RlVHlwZS5SZWd1bGFyU2VsZWN0b3IpIHtcbiAgICAgICAgICAgICAgICAgIC8vIHN0YW5kYXJkIHNlbGVjdG9ycyB3aXRoIHdoaXRlIHNwYWNlIGJldHdlZW4gY29sb24gYW5kIG5hbWUgb2YgcHNldWRvXG4gICAgICAgICAgICAgICAgICAvLyBhcmUgaW52YWxpZCBmb3IgbmF0aXZlIGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3JBbGwoKSBhbnl3YXksXG4gICAgICAgICAgICAgICAgICAvLyBzbyB0aHJvd2luZyB0aGUgZXJyb3IgaGVyZSBpcyBiZXR0ZXJcbiAgICAgICAgICAgICAgICAgIC8vIHRoYW4gcHJvcGVyIHBhcnNpbmcgb2YgaW52YWxpZCBzZWxlY3RvciBhbmQgcGFzc2luZyBpdCBmdXJ0aGVyLlxuICAgICAgICAgICAgICAgICAgLy8gZmlyc3Qgb2YgYWxsIGRvIG5vdCBjaGVjayBhdHRyaWJ1dGVzXG4gICAgICAgICAgICAgICAgICAvLyBlLmcuIGRpdltzdHlsZT1cInRleHQtYWxpZ246IGNlbnRlclwiXVxuICAgICAgICAgICAgICAgICAgaWYgKCFjb250ZXh0LmlzQXR0cmlidXRlQnJhY2tldHNPcGVuIC8vIGNoZWNrIHRoZSBzcGFjZSBhZnRlciB0aGUgY29sb24gYW5kIGJlZm9yZSB0aGUgcHNldWRvXG4gICAgICAgICAgICAgICAgICAvLyBlLmcuICcuYmxvY2s6IG50aC1jaGlsZCgyKVxuICAgICAgICAgICAgICAgICAgJiYgKHByZXZUb2tlblZhbHVlID09PSBDT0xPTiAmJiBuZXh0VG9rZW5UeXBlID09PSBUb2tlblR5cGUuV29yZCAvLyBvciBhZnRlciB0aGUgcHNldWRvIGFuZCBiZWZvcmUgdGhlIG9wZW5pbmcgcGFyZW50aGVzaXNcbiAgICAgICAgICAgICAgICAgIC8vIGUuZy4gJy5ibG9jazpudGgtY2hpbGQgKDIpXG4gICAgICAgICAgICAgICAgICB8fCBwcmV2VG9rZW5UeXBlID09PSBUb2tlblR5cGUuV29yZCAmJiBuZXh0VG9rZW5WYWx1ZSA9PT0gQlJBQ0tFVFMuUEFSRU5USEVTRVMuTEVGVCkpIHtcbiAgICAgICAgICAgICAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiJ1wiLmNvbmNhdChzZWxlY3RvciwgXCInIGlzIG5vdCBhIHZhbGlkIHNlbGVjdG9yXCIpKTtcbiAgICAgICAgICAgICAgICAgIH0gLy8gY29sbGVjdCBjdXJyZW50IHRva2VuVmFsdWUgdG8gdmFsdWUgb2YgUmVndWxhclNlbGVjdG9yXG4gICAgICAgICAgICAgICAgICAvLyBpZiBpdCBpcyB0aGUgbGFzdCB0b2tlbiBvciBzdGFuZGFyZCBzZWxlY3RvciBjb250aW51ZXMgYWZ0ZXIgdGhlIHNwYWNlLlxuICAgICAgICAgICAgICAgICAgLy8gb3RoZXJ3aXNlIGl0IHdpbGwgYmUgc2tpcHBlZFxuXG5cbiAgICAgICAgICAgICAgICAgIGlmICghbmV4dFRva2VuVmFsdWUgfHwgZG9lc1JlZ3VsYXJDb250aW51ZUFmdGVyU3BhY2UobmV4dFRva2VuVHlwZSwgbmV4dFRva2VuVmFsdWUpIC8vIHdlIGFsc28gc2hvdWxkIGNvbGxlY3Qgc3BhY2UgaW5zaWRlIGF0dHJpYnV0ZSB2YWx1ZVxuICAgICAgICAgICAgICAgICAgLy8gZS5nLiBgW29uY2xpY2tePVwid2luZG93Lm9wZW4gKCdodHRwczovL2V4YW1wbGUuY29tL3NoYXJlP3VybD1cIl1gXG4gICAgICAgICAgICAgICAgICAvLyBwYXJzZXIgcG9zaXRpb24gICAgICAgICAgICAg4oaRXG4gICAgICAgICAgICAgICAgICB8fCBjb250ZXh0LmlzQXR0cmlidXRlQnJhY2tldHNPcGVuKSB7XG4gICAgICAgICAgICAgICAgICAgIHVwZGF0ZUJ1ZmZlck5vZGUoY29udGV4dCwgdG9rZW5WYWx1ZSk7XG4gICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgaWYgKCgoX2J1ZmZlck5vZGU0ID0gYnVmZmVyTm9kZSkgPT09IG51bGwgfHwgX2J1ZmZlck5vZGU0ID09PSB2b2lkIDAgPyB2b2lkIDAgOiBfYnVmZmVyTm9kZTQudHlwZSkgPT09IE5vZGVUeXBlLkFic29sdXRlUHNldWRvQ2xhc3MpIHtcbiAgICAgICAgICAgICAgICAgIC8vIHNwYWNlIGluc2lkZSBleHRlbmRlZCBwc2V1ZG8tY2xhc3MgYXJnXG4gICAgICAgICAgICAgICAgICAvLyBlLmcuICdzcGFuOmNvbnRhaW5zKHNvbWUgdGV4dCknXG4gICAgICAgICAgICAgICAgICB1cGRhdGVCdWZmZXJOb2RlKGNvbnRleHQsIHRva2VuVmFsdWUpO1xuICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgIGlmICgoKF9idWZmZXJOb2RlNSA9IGJ1ZmZlck5vZGUpID09PSBudWxsIHx8IF9idWZmZXJOb2RlNSA9PT0gdm9pZCAwID8gdm9pZCAwIDogX2J1ZmZlck5vZGU1LnR5cGUpID09PSBOb2RlVHlwZS5SZWxhdGl2ZVBzZXVkb0NsYXNzKSB7XG4gICAgICAgICAgICAgICAgICAvLyBpbml0IHdpdGggZW1wdHkgdmFsdWUgUmVndWxhclNlbGVjdG9yXG4gICAgICAgICAgICAgICAgICAvLyBhcyB0aGUgc3BhY2UgaXMgbm90IG5lZWRlZCBmb3Igc2VsZWN0b3IgdmFsdWVcbiAgICAgICAgICAgICAgICAgIC8vIGUuZy4gJ3A6bm90KCAuY29udGVudCApJ1xuICAgICAgICAgICAgICAgICAgaW5pdFJlbGF0aXZlU3VidHJlZShjb250ZXh0KTtcbiAgICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgICBpZiAoKChfYnVmZmVyTm9kZTYgPSBidWZmZXJOb2RlKSA9PT0gbnVsbCB8fCBfYnVmZmVyTm9kZTYgPT09IHZvaWQgMCA/IHZvaWQgMCA6IF9idWZmZXJOb2RlNi50eXBlKSA9PT0gTm9kZVR5cGUuU2VsZWN0b3IpIHtcbiAgICAgICAgICAgICAgICAgIC8vIGRvIE5PVCBhZGQgUmVndWxhclNlbGVjdG9yIGlmIHBhcnNlciBwb3NpdGlvbiBvbiBzcGFjZSBCRUZPUkUgdGhlIGNvbW1hIGluIHNlbGVjdG9yIGxpc3RcbiAgICAgICAgICAgICAgICAgIC8vIGUuZy4gJy5ibG9jazpoYXMoPiBpbWcpICwgLmJhbm5lciknXG4gICAgICAgICAgICAgICAgICBpZiAobmV4dFRva2VuVmFsdWUgJiYgZG9lc1JlZ3VsYXJDb250aW51ZUFmdGVyU3BhY2UobmV4dFRva2VuVHlwZSwgbmV4dFRva2VuVmFsdWUpKSB7XG4gICAgICAgICAgICAgICAgICAgIC8vIHJlZ3VsYXIgc2VsZWN0b3IgbWlnaHQgYmUgYWZ0ZXIgdGhlIGV4dGVuZGVkIG9uZS5cbiAgICAgICAgICAgICAgICAgICAgLy8gZXh0cmEgc3BhY2UgYmVmb3JlIGNvbWJpbmF0b3Igb3Igc2VsZWN0b3Igc2hvdWxkIG5vdCBiZSBjb2xsZWN0ZWRcbiAgICAgICAgICAgICAgICAgICAgLy8gZS5nLiAnLmJhbm5lcjp1cHdhcmQoMikgLmJsb2NrJ1xuICAgICAgICAgICAgICAgICAgICAvLyAgICAgICcuYmFubmVyOnVwd2FyZCgyKSA+IC5ibG9jaydcbiAgICAgICAgICAgICAgICAgICAgLy8gc28gbm8gdG9rZW5WYWx1ZSBwYXNzZWQgdG8gYWRkQW55U2VsZWN0b3JOb2RlKClcbiAgICAgICAgICAgICAgICAgICAgYWRkQXN0Tm9kZUJ5VHlwZShjb250ZXh0LCBOb2RlVHlwZS5SZWd1bGFyU2VsZWN0b3IpO1xuICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgIGJyZWFrO1xuXG4gICAgICAgICAgICAgIGNhc2UgREVTQ0VOREFOVF9DT01CSU5BVE9SOlxuICAgICAgICAgICAgICBjYXNlIENISUxEX0NPTUJJTkFUT1I6XG4gICAgICAgICAgICAgIGNhc2UgTkVYVF9TSUJMSU5HX0NPTUJJTkFUT1I6XG4gICAgICAgICAgICAgIGNhc2UgU1VCU0VRVUVOVF9TSUJMSU5HX0NPTUJJTkFUT1I6XG4gICAgICAgICAgICAgIGNhc2UgU0VNSUNPTE9OOlxuICAgICAgICAgICAgICBjYXNlIFNMQVNIOlxuICAgICAgICAgICAgICBjYXNlIEJBQ0tTTEFTSDpcbiAgICAgICAgICAgICAgY2FzZSBTSU5HTEVfUVVPVEU6XG4gICAgICAgICAgICAgIGNhc2UgRE9VQkxFX1FVT1RFOlxuICAgICAgICAgICAgICBjYXNlIENBUkVUOlxuICAgICAgICAgICAgICBjYXNlIERPTExBUl9TSUdOOlxuICAgICAgICAgICAgICBjYXNlIEJSQUNLRVRTLkNVUkxZLkxFRlQ6XG4gICAgICAgICAgICAgIGNhc2UgQlJBQ0tFVFMuQ1VSTFkuUklHSFQ6XG4gICAgICAgICAgICAgIGNhc2UgQVNURVJJU0s6XG4gICAgICAgICAgICAgIGNhc2UgSURfTUFSS0VSOlxuICAgICAgICAgICAgICBjYXNlIENMQVNTX01BUktFUjpcbiAgICAgICAgICAgICAgY2FzZSBCUkFDS0VUUy5TUVVBUkUuTEVGVDpcbiAgICAgICAgICAgICAgICAvLyBpdCBtaWdodCBiZSBjb21wbGV4IHNlbGVjdG9yIHdpdGggZXh0ZW5kZWQgcHNldWRvLWNsYXNzIGluc2lkZSBpdFxuICAgICAgICAgICAgICAgIC8vIGFuZCB0aGUgc3BhY2UgaXMgYmV0d2VlbiB0aGF0IGNvbXBsZXggc2VsZWN0b3IgYW5kIGZvbGxvd2luZyByZWd1bGFyIHNlbGVjdG9yXG4gICAgICAgICAgICAgICAgLy8gZS5nLiAnZGl2OmhhcyhpbWcpLmJhbm5lcicgICAvLyBwYXJzZXIgcG9zaXRpb24gaXMgb24gYC5gIGJlZm9yZSBgYmFubmVyYCBub3dcbiAgICAgICAgICAgICAgICAvLyAgICAgICdkaXY6aGFzKGltZylbYXR0cl0nICAgIC8vIHBhcnNlciBwb3NpdGlvbiBpcyBvbiBgW2AgYmVmb3JlIGBhdHRyYCBub3dcbiAgICAgICAgICAgICAgICAvLyBzbyB3ZSBuZWVkIHRvIGNoZWNrIHdoZXRoZXIgdGhlIG5ldyBhc3Qgbm9kZSBzaG91bGQgYmUgYWRkZWQgKGV4YW1wbGUgYWJvdmUpXG4gICAgICAgICAgICAgICAgLy8gb3IgcHJldmlvdXMgcmVndWxhciBzZWxlY3RvciBub2RlIHNob3VsZCBiZSB1cGRhdGVkXG4gICAgICAgICAgICAgICAgaWYgKENPTUJJTkFUT1JTLmluY2x1ZGVzKHRva2VuVmFsdWUpKSB7XG4gICAgICAgICAgICAgICAgICBpZiAoYnVmZmVyTm9kZSA9PT0gbnVsbCkge1xuICAgICAgICAgICAgICAgICAgICAvLyBjYXNlcyB3aGVyZSBjb21iaW5hdG9yIGF0IHZlcnkgYmVnaW5uaW5nIG9mIGEgc2VsZWN0b3JcbiAgICAgICAgICAgICAgICAgICAgLy8gZS5nLiAnPiBkaXYnXG4gICAgICAgICAgICAgICAgICAgIC8vIG9yICAgJ34gLmJhbm5lcidcbiAgICAgICAgICAgICAgICAgICAgLy8gb3IgZXZlbiAnK2pzKG92ZXJsYXktYnVzdGVyKScgd2hpY2ggbm90IGEgc2VsZWN0b3IgYXQgYWxsXG4gICAgICAgICAgICAgICAgICAgIC8vIGJ1dCBtYXkgYmUgdmFsaWRhdGVkIGJ5IEZpbHRlckNvbXBpbGVyIHNvIGVycm9yIG1lc3NhZ2Ugc2hvdWxkIGJlIGFwcHJvcHJpYXRlXG4gICAgICAgICAgICAgICAgICAgIHRocm93IG5ldyBFcnJvcihcIidcIi5jb25jYXQoc2VsZWN0b3IsIFwiJyBpcyBub3QgYSB2YWxpZCBzZWxlY3RvclwiKSk7XG4gICAgICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgICAgIGJ1ZmZlck5vZGUgPSBnZXRVcGRhdGVkQnVmZmVyTm9kZShjb250ZXh0KTtcbiAgICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgICBpZiAoYnVmZmVyTm9kZSA9PT0gbnVsbCkge1xuICAgICAgICAgICAgICAgICAgLy8gbm8gYXN0IGNvbGxlY3RpbmcgaGFzIGJlZW4gc3RhcnRlZFxuICAgICAgICAgICAgICAgICAgaWYgKHRva2VuVmFsdWUgPT09IEFTVEVSSVNLICYmIG5leHRUb2tlblZhbHVlID09PSBDT0xPTiAmJiAobmV4dFRvTmV4dFRva2VuVmFsdWUgPT09IElTX1BTRVVET19DTEFTU19NQVJLRVIgfHwgbmV4dFRvTmV4dFRva2VuVmFsdWUgPT09IE5PVF9QU0VVRE9fQ0xBU1NfTUFSS0VSKSkge1xuICAgICAgICAgICAgICAgICAgICAvLyBsaW1pdCBhcHBseWluZyBvZiB3aWxkY2FyZCA6aXMoKSBhbmQgOm5vdCgpIHBzZXVkby1jbGFzcyBvbmx5IHRvIGh0bWwgY2hpbGRyZW5cbiAgICAgICAgICAgICAgICAgICAgLy8gYXMgd2UgY2hlY2sgZWxlbWVudCBwYXJlbnQgZm9yIHRoZW0gYW5kIHRoZXJlIGlzIG5vIHBhcmVudCBmb3IgaHRtbCxcbiAgICAgICAgICAgICAgICAgICAgLy8gZS5nLiAnKjppcygucGFnZSwgLm1haW4pID4gLmJhbm5lcidcbiAgICAgICAgICAgICAgICAgICAgLy8gb3IgICAnKjpub3Qoc3Bhbik6bm90KHApJ1xuICAgICAgICAgICAgICAgICAgICBpbml0QXN0KGNvbnRleHQsIElTX09SX05PVF9QU0VVRE9fU0VMRUNUSU5HX1JPT1QpO1xuICAgICAgICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgICAgICAgLy8gZS5nLiAnLmJhbm5lciA+IHAnXG4gICAgICAgICAgICAgICAgICAgIC8vIG9yICAgJyN0b3AgPiBkaXYuYWQnXG4gICAgICAgICAgICAgICAgICAgIC8vIG9yICAgJ1tjbGFzc11bc3R5bGVdW2F0dHJdJ1xuICAgICAgICAgICAgICAgICAgICBpbml0QXN0KGNvbnRleHQsIHRva2VuVmFsdWUpO1xuXG4gICAgICAgICAgICAgICAgICAgIGlmICh0b2tlblZhbHVlID09PSBCUkFDS0VUUy5TUVVBUkUuTEVGVCkge1xuICAgICAgICAgICAgICAgICAgICAgIC8vIGUuZy4gJ1tjbGFzc149XCJiYW5uZXItXCJdJ1xuICAgICAgICAgICAgICAgICAgICAgIGNvbnRleHQuaXNBdHRyaWJ1dGVCcmFja2V0c09wZW4gPSB0cnVlO1xuICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgfSBlbHNlIGlmIChidWZmZXJOb2RlLnR5cGUgPT09IE5vZGVUeXBlLlJlZ3VsYXJTZWxlY3Rvcikge1xuICAgICAgICAgICAgICAgICAgLy8gY29sbGVjdCB0aGUgbWFyayB0byB0aGUgdmFsdWUgb2YgUmVndWxhclNlbGVjdG9yIG5vZGVcbiAgICAgICAgICAgICAgICAgIHVwZGF0ZUJ1ZmZlck5vZGUoY29udGV4dCwgdG9rZW5WYWx1ZSk7XG5cbiAgICAgICAgICAgICAgICAgIGlmICh0b2tlblZhbHVlID09PSBCUkFDS0VUUy5TUVVBUkUuTEVGVCkge1xuICAgICAgICAgICAgICAgICAgICAvLyBuZWVkZWQgZm9yIHByb3BlciBoYW5kbGluZyBlbGVtZW50IGF0dHJpYnV0ZSB2YWx1ZSB3aXRoIGNvbW1hXG4gICAgICAgICAgICAgICAgICAgIC8vIGUuZy4gJ2RpdltkYXRhLWNvbW1hPVwiMCwxXCJdJ1xuICAgICAgICAgICAgICAgICAgICBjb250ZXh0LmlzQXR0cmlidXRlQnJhY2tldHNPcGVuID0gdHJ1ZTtcbiAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICB9IGVsc2UgaWYgKGJ1ZmZlck5vZGUudHlwZSA9PT0gTm9kZVR5cGUuQWJzb2x1dGVQc2V1ZG9DbGFzcykge1xuICAgICAgICAgICAgICAgICAgLy8gY29sbGVjdCB0aGUgbWFyayB0byB0aGUgYXJnIG9mIEFic29sdXRlUHNldWRvQ2xhc3Mgbm9kZVxuICAgICAgICAgICAgICAgICAgdXBkYXRlQnVmZmVyTm9kZShjb250ZXh0LCB0b2tlblZhbHVlKTtcblxuICAgICAgICAgICAgICAgICAgaWYgKCFidWZmZXJOb2RlLnZhbHVlKSB7XG4gICAgICAgICAgICAgICAgICAgIHRocm93IG5ldyBFcnJvcignYnVmZmVyTm9kZSBzaG91bGQgaGF2ZSB2YWx1ZSBieSBub3cnKTtcbiAgICAgICAgICAgICAgICAgIH0gLy8gJ2lzUmVnZXhwT3BlbicgZmxhZyBpcyBuZWVkZWQgZm9yIGJyYWNrZXRzIGJhbGFuY2luZyBpbnNpZGUgZXh0ZW5kZWQgcHNldWRvLWNsYXNzIGFyZ1xuXG5cbiAgICAgICAgICAgICAgICAgIGlmICh0b2tlblZhbHVlID09PSBTTEFTSCAmJiBjb250ZXh0LmV4dGVuZGVkUHNldWRvTmFtZXNTdGFjay5sZW5ndGggPiAwKSB7XG4gICAgICAgICAgICAgICAgICAgIGlmIChwcmV2VG9rZW5WYWx1ZSA9PT0gU0xBU0ggJiYgcHJldlRvUHJldlRva2VuVmFsdWUgPT09IEJBQ0tTTEFTSCkge1xuICAgICAgICAgICAgICAgICAgICAgIC8vIGl0IG1heSBiZSBzcGVjaWZpYyB1cmwgcmVnZXhwIHBhdHRlcm4gaW4gYXJnIG9mIHBzZXVkby1jbGFzc1xuICAgICAgICAgICAgICAgICAgICAgIC8vIGUuZy4gJzptYXRjaGVzLWNzcyhiYWNrZ3JvdW5kLWltYWdlOiAvXnVybFxcKGh0dHBzOlxcL1xcL2V4YW1wbGVcXC5vcmdcXC8vKSdcbiAgICAgICAgICAgICAgICAgICAgICAvLyBwYXJzZXIgcG9zaXRpb24gaXMgb24gZmluYWwgc2xhc2ggYmVmb3JlIGApYCAgICAgICAgICAgICAgICAgICAgICAgIOKGkVxuICAgICAgICAgICAgICAgICAgICAgIGNvbnRleHQuaXNSZWdleHBPcGVuID0gZmFsc2U7XG4gICAgICAgICAgICAgICAgICAgIH0gZWxzZSBpZiAocHJldlRva2VuVmFsdWUgIT09IEJBQ0tTTEFTSCkge1xuICAgICAgICAgICAgICAgICAgICAgIGlmIChpc1JlZ2V4cE9wZW5pbmcoY29udGV4dCwgcHJldlRva2VuVmFsdWUsIGJ1ZmZlck5vZGUudmFsdWUpKSB7XG4gICAgICAgICAgICAgICAgICAgICAgICBjb250ZXh0LmlzUmVnZXhwT3BlbiA9ICFjb250ZXh0LmlzUmVnZXhwT3BlbjtcbiAgICAgICAgICAgICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICAgICAgICAgICAgLy8gb3RoZXJ3aXNlIGZvcmNlIGBpc1JlZ2V4cE9wZW5gIGZsYWcgdG8gYGZhbHNlYFxuICAgICAgICAgICAgICAgICAgICAgICAgY29udGV4dC5pc1JlZ2V4cE9wZW4gPSBmYWxzZTtcbiAgICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICB9IGVsc2UgaWYgKGJ1ZmZlck5vZGUudHlwZSA9PT0gTm9kZVR5cGUuUmVsYXRpdmVQc2V1ZG9DbGFzcykge1xuICAgICAgICAgICAgICAgICAgLy8gYWRkIFNlbGVjdG9yTGlzdCB0byBjaGlsZHJlbiBvZiBSZWxhdGl2ZVBzZXVkb0NsYXNzIG5vZGVcbiAgICAgICAgICAgICAgICAgIGluaXRSZWxhdGl2ZVN1YnRyZWUoY29udGV4dCwgdG9rZW5WYWx1ZSk7XG5cbiAgICAgICAgICAgICAgICAgIGlmICh0b2tlblZhbHVlID09PSBCUkFDS0VUUy5TUVVBUkUuTEVGVCkge1xuICAgICAgICAgICAgICAgICAgICAvLyBiZXNpZGVzIG9mIGNyZWF0aW5nIHRoZSByZWxhdGl2ZSBzdWJ0cmVlXG4gICAgICAgICAgICAgICAgICAgIC8vIG9wZW5pbmcgc3F1YXJlIGJyYWNrZXQgbWVhbnMgc3RhcnQgb2YgYXR0cmlidXRlXG4gICAgICAgICAgICAgICAgICAgIC8vIGUuZy4gJ2Rpdjpub3QoW2NsYXNzPVwiY29udGVudFwiXSknXG4gICAgICAgICAgICAgICAgICAgIC8vICAgICAgJ2Rpdjpub3QoW2hyZWYqPVwid2luZG93LnByaW50KClcIl0pJ1xuICAgICAgICAgICAgICAgICAgICBjb250ZXh0LmlzQXR0cmlidXRlQnJhY2tldHNPcGVuID0gdHJ1ZTtcbiAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICB9IGVsc2UgaWYgKGJ1ZmZlck5vZGUudHlwZSA9PT0gTm9kZVR5cGUuU2VsZWN0b3IpIHtcbiAgICAgICAgICAgICAgICAgIC8vIGFmdGVyIHRoZSBleHRlbmRlZCBwc2V1ZG8gY2xvc2luZyBwYXJlbnRoZXNlc1xuICAgICAgICAgICAgICAgICAgLy8gcGFyc2VyIHBvc2l0aW9uIGlzIG9uIFNlbGVjdG9yIG5vZGVcbiAgICAgICAgICAgICAgICAgIC8vIGFuZCByZWd1bGFyIHNlbGVjdG9yIGNhbiBiZSBhZnRlciB0aGUgZXh0ZW5kZWQgb25lXG4gICAgICAgICAgICAgICAgICAvLyBlLmcuICcuYmFubmVyOnVwd2FyZCgyKT4gLmJsb2NrJ1xuICAgICAgICAgICAgICAgICAgLy8gb3IgICAnLmlubmVyOm50aC1hbmNlc3RvcigxKX4gLmJhbm5lcidcbiAgICAgICAgICAgICAgICAgIGlmIChDT01CSU5BVE9SUy5pbmNsdWRlcyh0b2tlblZhbHVlKSkge1xuICAgICAgICAgICAgICAgICAgICBhZGRBc3ROb2RlQnlUeXBlKGNvbnRleHQsIE5vZGVUeXBlLlJlZ3VsYXJTZWxlY3RvciwgdG9rZW5WYWx1ZSk7XG4gICAgICAgICAgICAgICAgICB9IGVsc2UgaWYgKCFjb250ZXh0LmlzUmVnZXhwT3Blbikge1xuICAgICAgICAgICAgICAgICAgICAvLyBpdCBtaWdodCBiZSBjb21wbGV4IHNlbGVjdG9yIHdpdGggZXh0ZW5kZWQgcHNldWRvLWNsYXNzIGluc2lkZSBpdC5cbiAgICAgICAgICAgICAgICAgICAgLy8gcGFyc2VyIHBvc2l0aW9uIGlzIG9uIGAuYCBub3c6XG4gICAgICAgICAgICAgICAgICAgIC8vIGUuZy4gJ2RpdjpoYXMoaW1nKS5iYW5uZXInXG4gICAgICAgICAgICAgICAgICAgIC8vIHNvIHdlIG5lZWQgdG8gZ2V0IGxhc3QgcmVndWxhciBzZWxlY3RvciBub2RlIGFuZCB1cGRhdGUgaXRzIHZhbHVlXG4gICAgICAgICAgICAgICAgICAgIGJ1ZmZlck5vZGUgPSBnZXRMYXN0UmVndWxhclNlbGVjdG9yTm9kZShjb250ZXh0KTtcbiAgICAgICAgICAgICAgICAgICAgdXBkYXRlQnVmZmVyTm9kZShjb250ZXh0LCB0b2tlblZhbHVlKTtcblxuICAgICAgICAgICAgICAgICAgICBpZiAodG9rZW5WYWx1ZSA9PT0gQlJBQ0tFVFMuU1FVQVJFLkxFRlQpIHtcbiAgICAgICAgICAgICAgICAgICAgICAvLyBoYW5kbGUgYXR0cmlidXRlIGluIGNvbXBvdW5kIHNlbGVjdG9yIGFmdGVyIGV4dGVuZGVkIHBzZXVkby1jbGFzc1xuICAgICAgICAgICAgICAgICAgICAgIC8vIGUuZy4gJ2Rpdjpub3QoLnRvcClbc3R5bGU9XCJ6LWluZGV4OiAxMDAwMDtcIl0nXG4gICAgICAgICAgICAgICAgICAgICAgLy8gcGFyc2VyIHBvc2l0aW9uICAgIOKGkVxuICAgICAgICAgICAgICAgICAgICAgIGNvbnRleHQuaXNBdHRyaWJ1dGVCcmFja2V0c09wZW4gPSB0cnVlO1xuICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgfSBlbHNlIGlmIChidWZmZXJOb2RlLnR5cGUgPT09IE5vZGVUeXBlLlNlbGVjdG9yTGlzdCkge1xuICAgICAgICAgICAgICAgICAgLy8gYWRkIFNlbGVjdG9yIHRvIFNlbGVjdG9yTGlzdFxuICAgICAgICAgICAgICAgICAgYWRkQXN0Tm9kZUJ5VHlwZShjb250ZXh0LCBOb2RlVHlwZS5TZWxlY3Rvcik7IC8vIGFuZCBSZWd1bGFyU2VsZWN0b3IgYXMgaXQgaXMgYWx3YXlzIHRoZSBmaXJzdCBjaGlsZCBvZiBTZWxlY3RvclxuXG4gICAgICAgICAgICAgICAgICBhZGRBc3ROb2RlQnlUeXBlKGNvbnRleHQsIE5vZGVUeXBlLlJlZ3VsYXJTZWxlY3RvciwgdG9rZW5WYWx1ZSk7XG5cbiAgICAgICAgICAgICAgICAgIGlmICh0b2tlblZhbHVlID09PSBCUkFDS0VUUy5TUVVBUkUuTEVGVCkge1xuICAgICAgICAgICAgICAgICAgICAvLyBoYW5kbGUgc2ltcGxlIGF0dHJpYnV0ZSBzZWxlY3RvciBpbiBzZWxlY3RvciBsaXN0XG4gICAgICAgICAgICAgICAgICAgIC8vIGUuZy4gJy5iYW5uZXIsIFtjbGFzc149XCJhZC1cIl0nXG4gICAgICAgICAgICAgICAgICAgIGNvbnRleHQuaXNBdHRyaWJ1dGVCcmFja2V0c09wZW4gPSB0cnVlO1xuICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgIGJyZWFrO1xuXG4gICAgICAgICAgICAgIGNhc2UgQlJBQ0tFVFMuU1FVQVJFLlJJR0hUOlxuICAgICAgICAgICAgICAgIGlmICgoKF9idWZmZXJOb2RlNyA9IGJ1ZmZlck5vZGUpID09PSBudWxsIHx8IF9idWZmZXJOb2RlNyA9PT0gdm9pZCAwID8gdm9pZCAwIDogX2J1ZmZlck5vZGU3LnR5cGUpID09PSBOb2RlVHlwZS5SZWd1bGFyU2VsZWN0b3IpIHtcbiAgICAgICAgICAgICAgICAgIC8vIG5lZWRlZCBmb3IgcHJvcGVyIHBhcnNpbmcgcmVndWxhciBzZWxlY3RvcnMgYWZ0ZXIgdGhlIGF0dHJpYnV0ZXMgd2l0aCBjb21tYVxuICAgICAgICAgICAgICAgICAgLy8gZS5nLiAnZGl2W2RhdGEtY29tbWE9XCIwLDFcIl0gPiBpbWcnXG4gICAgICAgICAgICAgICAgICAvLyBUT0RPOiBoYW5kbGUgYF1gIGluc2lkZSBhdHRyaWJ1dGUgdmFsdWVcbiAgICAgICAgICAgICAgICAgIC8vIGUuZy4gJ1tvbmNsaWNrXj1cInJldHVybiB0ZXN0Lm9uRXZlbnQoYXJndW1lbnRzWzBdfHx3aW5kb3cuZXZlbnQsXFwnXCJdJ1xuICAgICAgICAgICAgICAgICAgY29udGV4dC5pc0F0dHJpYnV0ZUJyYWNrZXRzT3BlbiA9IGZhbHNlOyAvLyBjb2xsZWN0IHRoZSBicmFja2V0IHRvIHRoZSB2YWx1ZSBvZiBSZWd1bGFyU2VsZWN0b3Igbm9kZVxuXG4gICAgICAgICAgICAgICAgICB1cGRhdGVCdWZmZXJOb2RlKGNvbnRleHQsIHRva2VuVmFsdWUpO1xuICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgIGlmICgoKF9idWZmZXJOb2RlOCA9IGJ1ZmZlck5vZGUpID09PSBudWxsIHx8IF9idWZmZXJOb2RlOCA9PT0gdm9pZCAwID8gdm9pZCAwIDogX2J1ZmZlck5vZGU4LnR5cGUpID09PSBOb2RlVHlwZS5BYnNvbHV0ZVBzZXVkb0NsYXNzKSB7XG4gICAgICAgICAgICAgICAgICAvLyA6eHBhdGgoKSBleHBlbmRlZCBwc2V1ZG8tY2xhc3MgYXJnIG1pZ2h0IGNvbnRhaW4gc3F1YXJlIGJyYWNrZXRcbiAgICAgICAgICAgICAgICAgIC8vIHNvIGl0IHNob3VsZCBiZSBjb2xsZWN0ZWRcbiAgICAgICAgICAgICAgICAgIC8vIGUuZy4gJ2Rpdjp4cGF0aCgvL2gzW2NvbnRhaW5zKHRleHQoKSxcIlNoYXJlIGl0IVwiKV0vLi4pJ1xuICAgICAgICAgICAgICAgICAgdXBkYXRlQnVmZmVyTm9kZShjb250ZXh0LCB0b2tlblZhbHVlKTtcbiAgICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgICBicmVhaztcblxuICAgICAgICAgICAgICBjYXNlIENPTE9OOlxuICAgICAgICAgICAgICAgIC8vIE5vIHdoaXRlIHNwYWNlIGlzIGFsbG93ZWQgYmV0d2VlbiB0aGUgY29sb24gYW5kIHRoZSBmb2xsb3dpbmcgbmFtZSBvZiB0aGUgcHNldWRvLWNsYXNzXG4gICAgICAgICAgICAgICAgLy8gaHR0cHM6Ly93d3cudzMub3JnL1RSL3NlbGVjdG9ycy00LyNwc2V1ZG8tY2xhc3Nlc1xuICAgICAgICAgICAgICAgIC8vIGUuZy4gJ3NwYW46IGNvbnRhaW5zKHRleHQpJ1xuICAgICAgICAgICAgICAgIGlmIChXSElURV9TUEFDRV9DSEFSQUNURVJTLmluY2x1ZGVzKG5leHRUb2tlblZhbHVlKSAmJiBTVVBQT1JURURfUFNFVURPX0NMQVNTRVMuaW5jbHVkZXMobmV4dFRvTmV4dFRva2VuVmFsdWUpKSB7XG4gICAgICAgICAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJObyB3aGl0ZSBzcGFjZSBpcyBhbGxvd2VkIGJlZm9yZSBvciBhZnRlciBleHRlbmRlZCBwc2V1ZG8tY2xhc3MgbmFtZSBpbiBzZWxlY3RvcjogJ1wiLmNvbmNhdChzZWxlY3RvciwgXCInXCIpKTsgLy8gZXNsaW50LWRpc2FibGUtbGluZSBtYXgtbGVuXG4gICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgaWYgKGJ1ZmZlck5vZGUgPT09IG51bGwpIHtcbiAgICAgICAgICAgICAgICAgIC8vIG5vIGFzdCBjb2xsZWN0aW5nIGhhcyBiZWVuIHN0YXJ0ZWRcbiAgICAgICAgICAgICAgICAgIGlmIChuZXh0VG9rZW5WYWx1ZSA9PT0gWFBBVEhfUFNFVURPX0NMQVNTX01BUktFUikge1xuICAgICAgICAgICAgICAgICAgICAvLyBsaW1pdCBhcHBseWluZyBvZiBcIm5ha2VkXCIgOnhwYXRoIHBzZXVkby1jbGFzc1xuICAgICAgICAgICAgICAgICAgICAvLyBodHRwczovL2dpdGh1Yi5jb20vQWRndWFyZFRlYW0vRXh0ZW5kZWRDc3MvaXNzdWVzLzExNVxuICAgICAgICAgICAgICAgICAgICBpbml0QXN0KGNvbnRleHQsIFhQQVRIX1BTRVVET19TRUxFQ1RJTkdfUk9PVCk7XG4gICAgICAgICAgICAgICAgICB9IGVsc2UgaWYgKG5leHRUb2tlblZhbHVlID09PSBJU19QU0VVRE9fQ0xBU1NfTUFSS0VSIHx8IG5leHRUb2tlblZhbHVlID09PSBOT1RfUFNFVURPX0NMQVNTX01BUktFUikge1xuICAgICAgICAgICAgICAgICAgICAvLyBwYXJlbnQgZWxlbWVudCBjaGVja2luZyBpcyB1c2VkIGZvciBleHRlbmRlZCBwc2V1ZG8tY2xhc3MgOmlzKCkgYW5kIDpub3QoKS5cbiAgICAgICAgICAgICAgICAgICAgLy8gYXMgdGhlcmUgaXMgbm8gcGFyZW50Tm9kZSBmb3Igcm9vdCBlbGVtZW50IChodG1sKVxuICAgICAgICAgICAgICAgICAgICAvLyBlbGVtZW50IHNlbGVjdGlvbiBzaG91bGQgYmUgbGltaXRlZCB0byBpdCdzIGNoaWxkcmVuLlxuICAgICAgICAgICAgICAgICAgICAvLyBlLmcuICc6aXMoLnBhZ2UsIC5tYWluKSA+IC5iYW5uZXInXG4gICAgICAgICAgICAgICAgICAgIC8vIG9yICAgJzpub3Qoc3Bhbik6bm90KHApJ1xuICAgICAgICAgICAgICAgICAgICBpbml0QXN0KGNvbnRleHQsIElTX09SX05PVF9QU0VVRE9fU0VMRUNUSU5HX1JPT1QpO1xuICAgICAgICAgICAgICAgICAgfSBlbHNlIGlmIChuZXh0VG9rZW5WYWx1ZSA9PT0gVVBXQVJEX1BTRVVET19DTEFTU19NQVJLRVIgfHwgbmV4dFRva2VuVmFsdWUgPT09IE5USF9BTkNFU1RPUl9QU0VVRE9fQ0xBU1NfTUFSS0VSKSB7XG4gICAgICAgICAgICAgICAgICAgIC8vIHNlbGVjdG9yIHNob3VsZCBiZSBzcGVjaWZpZWQgYmVmb3JlIDpudGgtYW5jZXN0b3IoKSBvciA6dXB3YXJkKClcbiAgICAgICAgICAgICAgICAgICAgLy8gZS5nLiAnOm50aC1hbmNlc3RvcigzKSdcbiAgICAgICAgICAgICAgICAgICAgLy8gb3IgICAnOnVwd2FyZChzcGFuKSdcbiAgICAgICAgICAgICAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiU2VsZWN0b3Igc2hvdWxkIGJlIHNwZWNpZmllZCBiZWZvcmUgOlwiLmNvbmNhdChuZXh0VG9rZW5WYWx1ZSwgXCIoKSBwc2V1ZG8tY2xhc3NcIikpOyAvLyBlc2xpbnQtZGlzYWJsZS1saW5lIG1heC1sZW5cbiAgICAgICAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgICAgICAgIC8vIG1ha2UgaXQgbW9yZSBvYnZpb3VzIGlmIHNlbGVjdG9yIHN0YXJ0cyB3aXRoIHBzZXVkbyB3aXRoIG5vIHRhZyBzcGVjaWZpZWRcbiAgICAgICAgICAgICAgICAgICAgLy8gZS5nLiAnOmhhcyhhKScgLT4gJyo6aGFzKGEpJ1xuICAgICAgICAgICAgICAgICAgICAvLyBvciAgICc6ZW1wdHknICAtPiAnKjplbXB0eSdcbiAgICAgICAgICAgICAgICAgICAgaW5pdEFzdChjb250ZXh0LCBBU1RFUklTSyk7XG4gICAgICAgICAgICAgICAgICB9IC8vIGJ1ZmZlck5vZGUgc2hvdWxkIGJlIHVwZGF0ZWQgZm9yIGZvbGxvd2luZyBjaGVja2luZ1xuXG5cbiAgICAgICAgICAgICAgICAgIGJ1ZmZlck5vZGUgPSBnZXRCdWZmZXJOb2RlKGNvbnRleHQpO1xuICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgIGlmICghYnVmZmVyTm9kZSkge1xuICAgICAgICAgICAgICAgICAgdGhyb3cgbmV3IEVycm9yKCdidWZmZXJOb2RlIGhhcyB0byBiZSBzcGVjaWZpZWQgYnkgbm93Jyk7XG4gICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgaWYgKGJ1ZmZlck5vZGUudHlwZSA9PT0gTm9kZVR5cGUuU2VsZWN0b3JMaXN0KSB7XG4gICAgICAgICAgICAgICAgICAvLyBidWZmZXJOb2RlIGlzIFNlbGVjdG9yTGlzdCBhZnRlciBjb21tYSBoYXMgYmVlbiBwYXJzZWQuXG4gICAgICAgICAgICAgICAgICAvLyBwYXJzZXIgcG9zaXRpb24gaXMgb24gY29sb24gbm93OlxuICAgICAgICAgICAgICAgICAgLy8gZS5nLiAnaW1nLDpub3QoLmNvbnRlbnQpJ1xuICAgICAgICAgICAgICAgICAgYWRkQXN0Tm9kZUJ5VHlwZShjb250ZXh0LCBOb2RlVHlwZS5TZWxlY3Rvcik7IC8vIGFkZCBlbXB0eSB2YWx1ZSBSZWd1bGFyU2VsZWN0b3IgYW55d2F5IGFzIGFueSBzZWxlY3RvciBzaG91bGQgc3RhcnQgd2l0aCBpdFxuICAgICAgICAgICAgICAgICAgLy8gYW5kIGNoZWNrIHByZXZpb3VzIHRva2VuIG9uIHRoZSBuZXh0IHN0ZXBcblxuICAgICAgICAgICAgICAgICAgYWRkQXN0Tm9kZUJ5VHlwZShjb250ZXh0LCBOb2RlVHlwZS5SZWd1bGFyU2VsZWN0b3IpOyAvLyBidWZmZXJOb2RlIHNob3VsZCBiZSB1cGRhdGVkIGZvciBmb2xsb3dpbmcgY2hlY2tpbmdcblxuICAgICAgICAgICAgICAgICAgYnVmZmVyTm9kZSA9IGdldEJ1ZmZlck5vZGUoY29udGV4dCk7XG4gICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgaWYgKCgoX2J1ZmZlck5vZGU5ID0gYnVmZmVyTm9kZSkgPT09IG51bGwgfHwgX2J1ZmZlck5vZGU5ID09PSB2b2lkIDAgPyB2b2lkIDAgOiBfYnVmZmVyTm9kZTkudHlwZSkgPT09IE5vZGVUeXBlLlJlZ3VsYXJTZWxlY3Rvcikge1xuICAgICAgICAgICAgICAgICAgLy8gaXQgY2FuIGJlIGV4dGVuZGVkIG9yIHN0YW5kYXJkIHBzZXVkb1xuICAgICAgICAgICAgICAgICAgLy8gZS5nLiAnI3NoYXJlLCA6Y29udGFpbnMoc2hhcmUgaXQpJ1xuICAgICAgICAgICAgICAgICAgLy8gb3IgICAnZGl2LDpob3ZlcidcbiAgICAgICAgICAgICAgICAgIC8vIG9mICAgJ2RpdjpoYXMoKzpjb250YWlucyh0ZXh0KSknICAvLyBwb3NpdGlvbiBpcyBhZnRlciAnKydcbiAgICAgICAgICAgICAgICAgIGlmIChDT01CSU5BVE9SUy5pbmNsdWRlcyhwcmV2VG9rZW5WYWx1ZSkgfHwgcHJldlRva2VuVmFsdWUgPT09IENPTU1BKSB7XG4gICAgICAgICAgICAgICAgICAgIC8vIGNhc2Ugd2l0aCBjb2xvbiBhdCB0aGUgc3RhcnQgb2Ygc3RyaW5nIC0gZS5nLiAnOmNvbnRhaW5zKHRleHQpJ1xuICAgICAgICAgICAgICAgICAgICAvLyBpcyBjb3ZlcmVkIGJ5ICdidWZmZXJOb2RlID09PSBudWxsJyBhYm92ZSBhdCBzdGFydCBvZiBDT0xPTiBjaGVja2luZ1xuICAgICAgICAgICAgICAgICAgICB1cGRhdGVCdWZmZXJOb2RlKGNvbnRleHQsIEFTVEVSSVNLKTtcbiAgICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgICAgaGFuZGxlTmV4dFRva2VuT25Db2xvbihjb250ZXh0LCBzZWxlY3RvciwgdG9rZW5WYWx1ZSwgbmV4dFRva2VuVmFsdWUsIG5leHRUb05leHRUb2tlblZhbHVlKTtcbiAgICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgICBpZiAoKChfYnVmZmVyTm9kZTEwID0gYnVmZmVyTm9kZSkgPT09IG51bGwgfHwgX2J1ZmZlck5vZGUxMCA9PT0gdm9pZCAwID8gdm9pZCAwIDogX2J1ZmZlck5vZGUxMC50eXBlKSA9PT0gTm9kZVR5cGUuU2VsZWN0b3IpIHtcbiAgICAgICAgICAgICAgICAgIC8vIGFmdGVyIHRoZSBleHRlbmRlZCBwc2V1ZG8gY2xvc2luZyBwYXJlbnRoZXNlc1xuICAgICAgICAgICAgICAgICAgLy8gcGFyc2VyIHBvc2l0aW9uIGlzIG9uIFNlbGVjdG9yIG5vZGVcbiAgICAgICAgICAgICAgICAgIC8vIGFuZCB0aGVyZSBpcyBtaWdodCBiZSBhbm90aGVyIGV4dGVuZGVkIHNlbGVjdG9yLlxuICAgICAgICAgICAgICAgICAgLy8gcGFyc2VyIHBvc2l0aW9uIGlzIG9uIGNvbG9uIGJlZm9yZSAndXB3YXJkJzpcbiAgICAgICAgICAgICAgICAgIC8vIGUuZy4gJ3A6Y29udGFpbnMoUFIpOnVwd2FyZCgyKSdcbiAgICAgICAgICAgICAgICAgIGlmIChpc1N1cHBvcnRlZEV4dGVuZGVkUHNldWRvKG5leHRUb2tlblZhbHVlLnRvTG93ZXJDYXNlKCkpKSB7XG4gICAgICAgICAgICAgICAgICAgIC8vIGlmIHN1cHBvcnRlZCBleHRlbmRlZCBwc2V1ZG8tY2xhc3MgaXMgbmV4dCB0byBjb2xvblxuICAgICAgICAgICAgICAgICAgICAvLyBhZGQgRXh0ZW5kZWRTZWxlY3RvciB0byBTZWxlY3RvciBjaGlsZHJlblxuICAgICAgICAgICAgICAgICAgICBhZGRBc3ROb2RlQnlUeXBlKGNvbnRleHQsIE5vZGVUeXBlLkV4dGVuZGVkU2VsZWN0b3IpO1xuICAgICAgICAgICAgICAgICAgfSBlbHNlIGlmIChuZXh0VG9rZW5WYWx1ZS50b0xvd2VyQ2FzZSgpID09PSBSRU1PVkVfUFNFVURPX01BUktFUikge1xuICAgICAgICAgICAgICAgICAgICAvLyA6cmVtb3ZlKCkgcHNldWRvLWNsYXNzIHNob3VsZCBiZSBoYW5kbGVkIGJlZm9yZVxuICAgICAgICAgICAgICAgICAgICAvLyBhcyBpdCBpcyBub3QgYWJvdXQgZWxlbWVudCBzZWxlY3RpbmcgYnV0IGFjdGlvbnMgd2l0aCBlbGVtZW50c1xuICAgICAgICAgICAgICAgICAgICAvLyBlLmcuICcjYmFubmVyOnVwd2FyZCgyKTpyZW1vdmUoKSdcbiAgICAgICAgICAgICAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiU2VsZWN0b3IgcGFyc2VyIGVycm9yOiBpbnZhbGlkIDpyZW1vdmUoKSBwc2V1ZG8tY2xhc3MgaW4gc2VsZWN0b3I6ICdcIi5jb25jYXQoc2VsZWN0b3IsIFwiJ1wiKSk7IC8vIGVzbGludC1kaXNhYmxlLWxpbmUgbWF4LWxlblxuICAgICAgICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgICAgICAgLy8gb3RoZXJ3aXNlIGl0IGlzIHN0YW5kYXJkIHBzZXVkbyBhZnRlciBleHRlbmRlZCBwc2V1ZG8tY2xhc3MgaW4gY29tcGxleCBzZWxlY3RvclxuICAgICAgICAgICAgICAgICAgICAvLyBhbmQgY29sb24gc2hvdWxkIGJlIGNvbGxlY3RlZCB0byB2YWx1ZSBvZiBwcmV2aW91cyBSZWd1bGFyU2VsZWN0b3JcbiAgICAgICAgICAgICAgICAgICAgLy8gZS5nLiAnYm9keSAqOm5vdChpbnB1dCk6OnNlbGVjdGlvbidcbiAgICAgICAgICAgICAgICAgICAgLy8gICAgICAnaW5wdXQ6bWF0Y2hlcy1jc3MocGFkZGluZzogMTApOmNoZWNrZWQnXG4gICAgICAgICAgICAgICAgICAgIGJ1ZmZlck5vZGUgPSBnZXRMYXN0UmVndWxhclNlbGVjdG9yTm9kZShjb250ZXh0KTtcbiAgICAgICAgICAgICAgICAgICAgaGFuZGxlTmV4dFRva2VuT25Db2xvbihjb250ZXh0LCBzZWxlY3RvciwgdG9rZW5WYWx1ZSwgbmV4dFRva2VuVHlwZSwgbmV4dFRvTmV4dFRva2VuVmFsdWUpOyAvLyBlc2xpbnQtZGlzYWJsZS1saW5lIG1heC1sZW5cbiAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgICBpZiAoKChfYnVmZmVyTm9kZTExID0gYnVmZmVyTm9kZSkgPT09IG51bGwgfHwgX2J1ZmZlck5vZGUxMSA9PT0gdm9pZCAwID8gdm9pZCAwIDogX2J1ZmZlck5vZGUxMS50eXBlKSA9PT0gTm9kZVR5cGUuQWJzb2x1dGVQc2V1ZG9DbGFzcykge1xuICAgICAgICAgICAgICAgICAgLy8gOnhwYXRoKCkgcHNldWRvLWNsYXNzIHNob3VsZCBiZSB0aGUgbGFzdCBvZiBleHRlbmRlZCBwc2V1ZG8tY2xhc3Nlc1xuICAgICAgICAgICAgICAgICAgaWYgKGJ1ZmZlck5vZGUubmFtZSA9PT0gWFBBVEhfUFNFVURPX0NMQVNTX01BUktFUiAmJiBTVVBQT1JURURfUFNFVURPX0NMQVNTRVMuaW5jbHVkZXMobmV4dFRva2VuLnZhbHVlKSAmJiBuZXh0VG9OZXh0VG9rZW4udmFsdWUgPT09IEJSQUNLRVRTLlBBUkVOVEhFU0VTLkxFRlQpIHtcbiAgICAgICAgICAgICAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiOnhwYXRoKCkgcHNldWRvLWNsYXNzIHNob3VsZCBiZSBhdCB0aGUgZW5kIG9mIHNlbGVjdG9yOiAnXCIuY29uY2F0KHNlbGVjdG9yLCBcIidcIikpOyAvLyBlc2xpbnQtZGlzYWJsZS1saW5lIG1heC1sZW5cbiAgICAgICAgICAgICAgICAgIH0gLy8gY29sbGVjdGluZyBhcmcgZm9yIGFic29sdXRlIHBzZXVkby1jbGFzc1xuICAgICAgICAgICAgICAgICAgLy8gZS5nLiAnZGl2Om1hdGNoZXMtY3NzKHdpZHRoOjQwMHB4KSdcblxuXG4gICAgICAgICAgICAgICAgICB1cGRhdGVCdWZmZXJOb2RlKGNvbnRleHQsIHRva2VuVmFsdWUpO1xuICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgIGlmICgoKF9idWZmZXJOb2RlMTIgPSBidWZmZXJOb2RlKSA9PT0gbnVsbCB8fCBfYnVmZmVyTm9kZTEyID09PSB2b2lkIDAgPyB2b2lkIDAgOiBfYnVmZmVyTm9kZTEyLnR5cGUpID09PSBOb2RlVHlwZS5SZWxhdGl2ZVBzZXVkb0NsYXNzKSB7XG4gICAgICAgICAgICAgICAgICAvLyBtYWtlIGl0IG1vcmUgb2J2aW91cyBpZiBzZWxlY3RvciBzdGFydHMgd2l0aCBwc2V1ZG8gd2l0aCBubyB0YWcgc3BlY2lmaWVkXG4gICAgICAgICAgICAgICAgICAvLyBwYXJzZXIgcG9zaXRpb24gaXMgb24gY29sb24gaW5zaWRlIDpoYXMoKSBhcmdcbiAgICAgICAgICAgICAgICAgIC8vIGUuZy4gJ2RpdjpoYXMoOmNvbnRhaW5zKHRleHQpKSdcbiAgICAgICAgICAgICAgICAgIC8vIG9yICAgJ2Rpdjpub3QoOmVtcHR5KSdcbiAgICAgICAgICAgICAgICAgIGluaXRSZWxhdGl2ZVN1YnRyZWUoY29udGV4dCwgQVNURVJJU0spO1xuXG4gICAgICAgICAgICAgICAgICBpZiAoIWlzU3VwcG9ydGVkRXh0ZW5kZWRQc2V1ZG8obmV4dFRva2VuVmFsdWUudG9Mb3dlckNhc2UoKSkpIHtcbiAgICAgICAgICAgICAgICAgICAgLy8gY29sbGVjdCB0aGUgY29sb24gdG8gdmFsdWUgb2YgUmVndWxhclNlbGVjdG9yXG4gICAgICAgICAgICAgICAgICAgIC8vIGUuZy4gJ2Rpdjpub3QoOmVtcHR5KSdcbiAgICAgICAgICAgICAgICAgICAgdXBkYXRlQnVmZmVyTm9kZShjb250ZXh0LCB0b2tlblZhbHVlKTsgLy8gcGFyZW50aGVzZXMgc2hvdWxkIGJlIGJhbGFuY2VkIG9ubHkgZm9yIGZ1bmN0aW9uYWwgcHNldWRvLWNsYXNzZXNcbiAgICAgICAgICAgICAgICAgICAgLy8gZS5nLiAnLnllbGxvdzpub3QoOm50aC1jaGlsZCgzKSknXG5cbiAgICAgICAgICAgICAgICAgICAgaWYgKG5leHRUb05leHRUb2tlblZhbHVlID09PSBCUkFDS0VUUy5QQVJFTlRIRVNFUy5MRUZUKSB7XG4gICAgICAgICAgICAgICAgICAgICAgY29udGV4dC5zdGFuZGFyZFBzZXVkb05hbWVzU3RhY2sucHVzaChuZXh0VG9rZW5WYWx1ZSk7XG4gICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgICAgICAgIC8vIGFkZCBFeHRlbmRlZFNlbGVjdG9yIHRvIFNlbGVjdG9yIGNoaWxkcmVuXG4gICAgICAgICAgICAgICAgICAgIC8vIGUuZy4gJ2RpdjpoYXMoOmNvbnRhaW5zKHRleHQpKSdcbiAgICAgICAgICAgICAgICAgICAgdXBUb0Nsb3Nlc3QoY29udGV4dCwgTm9kZVR5cGUuU2VsZWN0b3IpO1xuICAgICAgICAgICAgICAgICAgICBhZGRBc3ROb2RlQnlUeXBlKGNvbnRleHQsIE5vZGVUeXBlLkV4dGVuZGVkU2VsZWN0b3IpO1xuICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgIGJyZWFrO1xuXG4gICAgICAgICAgICAgIGNhc2UgQlJBQ0tFVFMuUEFSRU5USEVTRVMuTEVGVDpcbiAgICAgICAgICAgICAgICAvLyBzdGFydCBvZiBwc2V1ZG8tY2xhc3MgYXJnXG4gICAgICAgICAgICAgICAgaWYgKCgoX2J1ZmZlck5vZGUxMyA9IGJ1ZmZlck5vZGUpID09PSBudWxsIHx8IF9idWZmZXJOb2RlMTMgPT09IHZvaWQgMCA/IHZvaWQgMCA6IF9idWZmZXJOb2RlMTMudHlwZSkgPT09IE5vZGVUeXBlLkFic29sdXRlUHNldWRvQ2xhc3MpIHtcbiAgICAgICAgICAgICAgICAgIC8vIG5vIGJyYWNrZXRzIGJhbGFuY2luZyBuZWVkZWQgaW5zaWRlXG4gICAgICAgICAgICAgICAgICAvLyAxLiA6eHBhdGgoKSBleHRlbmRlZCBwc2V1ZG8tY2xhc3MgYXJnXG4gICAgICAgICAgICAgICAgICAvLyAyLiByZWdleHAgYXJnIGZvciBvdGhlciBleHRlbmRlZCBwc2V1ZG8tY2xhc3Nlc1xuICAgICAgICAgICAgICAgICAgaWYgKGJ1ZmZlck5vZGUubmFtZSAhPT0gWFBBVEhfUFNFVURPX0NMQVNTX01BUktFUiAmJiBjb250ZXh0LmlzUmVnZXhwT3Blbikge1xuICAgICAgICAgICAgICAgICAgICAvLyBpZiB0aGUgcGFyZW50aGVzZXMgaXMgZXNjYXBlZCBpdCBzaG91bGQgYmUgcGFydCBvZiByZWdleHBcbiAgICAgICAgICAgICAgICAgICAgLy8gY29sbGVjdCBpdCB0byBhcmcgb2YgQWJzb2x1dGVQc2V1ZG9DbGFzc1xuICAgICAgICAgICAgICAgICAgICAvLyBlLmcuICdkaXY6bWF0Y2hlcy1jc3MoYmFja2dyb3VuZC1pbWFnZTogL151cmxcXFxcKFwiZGF0YTppbWFnZVxcXFwvZ2lmO2Jhc2U2NC4rLyknXG4gICAgICAgICAgICAgICAgICAgIHVwZGF0ZUJ1ZmZlck5vZGUoY29udGV4dCwgdG9rZW5WYWx1ZSk7XG4gICAgICAgICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICAgICAgICAvLyBvdGhlcndpc2UgYnJhY2tldHMgc2hvdWxkIGJlIGJhbGFuY2VkXG4gICAgICAgICAgICAgICAgICAgIC8vIGUuZy4gJ2Rpdjp4cGF0aCgvL2gzW2NvbnRhaW5zKHRleHQoKSxcIlNoYXJlIGl0IVwiKV0vLi4pJ1xuICAgICAgICAgICAgICAgICAgICBjb250ZXh0LmV4dGVuZGVkUHNldWRvQnJhY2tldHNTdGFjay5wdXNoKHRva2VuVmFsdWUpOyAvLyBlc2xpbnQtZGlzYWJsZS1uZXh0LWxpbmUgbWF4LWxlblxuXG4gICAgICAgICAgICAgICAgICAgIGlmIChjb250ZXh0LmV4dGVuZGVkUHNldWRvQnJhY2tldHNTdGFjay5sZW5ndGggPiBjb250ZXh0LmV4dGVuZGVkUHNldWRvTmFtZXNTdGFjay5sZW5ndGgpIHtcbiAgICAgICAgICAgICAgICAgICAgICB1cGRhdGVCdWZmZXJOb2RlKGNvbnRleHQsIHRva2VuVmFsdWUpO1xuICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgaWYgKCgoX2J1ZmZlck5vZGUxNCA9IGJ1ZmZlck5vZGUpID09PSBudWxsIHx8IF9idWZmZXJOb2RlMTQgPT09IHZvaWQgMCA/IHZvaWQgMCA6IF9idWZmZXJOb2RlMTQudHlwZSkgPT09IE5vZGVUeXBlLlJlZ3VsYXJTZWxlY3Rvcikge1xuICAgICAgICAgICAgICAgICAgLy8gY29udGludWUgUmVndWxhclNlbGVjdG9yIHZhbHVlIGNvbGxlY3RpbmcgZm9yIHN0YW5kYXJkIHBzZXVkby1jbGFzc2VzXG4gICAgICAgICAgICAgICAgICAvLyBlLmcuICcuYmFubmVyOndoZXJlKGRpdiknXG4gICAgICAgICAgICAgICAgICBpZiAoY29udGV4dC5zdGFuZGFyZFBzZXVkb05hbWVzU3RhY2subGVuZ3RoID4gMCkge1xuICAgICAgICAgICAgICAgICAgICB1cGRhdGVCdWZmZXJOb2RlKGNvbnRleHQsIHRva2VuVmFsdWUpO1xuICAgICAgICAgICAgICAgICAgICBjb250ZXh0LnN0YW5kYXJkUHNldWRvQnJhY2tldHNTdGFjay5wdXNoKHRva2VuVmFsdWUpO1xuICAgICAgICAgICAgICAgICAgfSAvLyBwYXJlbnRoZXNlcyBpbnNpZGUgYXR0cmlidXRlIHZhbHVlIHNob3VsZCBiZSBwYXJ0IG9mIFJlZ3VsYXJTZWxlY3RvciB2YWx1ZVxuICAgICAgICAgICAgICAgICAgLy8gZS5nLiAnZGl2Om5vdChbaHJlZio9XCJ3aW5kb3cucHJpbnQoKVwiXSknICAgPC0tIHBhcnNlciBwb3NpdGlvblxuICAgICAgICAgICAgICAgICAgLy8gaXMgb24gdGhlIGAoYCBhZnRlciBgcHJpbnRgICAgICAgIOKGkVxuXG5cbiAgICAgICAgICAgICAgICAgIGlmIChjb250ZXh0LmlzQXR0cmlidXRlQnJhY2tldHNPcGVuKSB7XG4gICAgICAgICAgICAgICAgICAgIHVwZGF0ZUJ1ZmZlck5vZGUoY29udGV4dCwgdG9rZW5WYWx1ZSk7XG4gICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgaWYgKCgoX2J1ZmZlck5vZGUxNSA9IGJ1ZmZlck5vZGUpID09PSBudWxsIHx8IF9idWZmZXJOb2RlMTUgPT09IHZvaWQgMCA/IHZvaWQgMCA6IF9idWZmZXJOb2RlMTUudHlwZSkgPT09IE5vZGVUeXBlLlJlbGF0aXZlUHNldWRvQ2xhc3MpIHtcbiAgICAgICAgICAgICAgICAgIC8vIHNhdmUgb3BlbmluZyBicmFja2V0IGZvciBiYWxhbmNpbmdcbiAgICAgICAgICAgICAgICAgIC8vIGUuZy4gJ2Rpdjpub3QoKScgIC8vIHBvc2l0aW9uIGlzIG9uIGAoYFxuICAgICAgICAgICAgICAgICAgY29udGV4dC5leHRlbmRlZFBzZXVkb0JyYWNrZXRzU3RhY2sucHVzaCh0b2tlblZhbHVlKTtcbiAgICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgICBicmVhaztcblxuICAgICAgICAgICAgICBjYXNlIEJSQUNLRVRTLlBBUkVOVEhFU0VTLlJJR0hUOlxuICAgICAgICAgICAgICAgIGlmICgoKF9idWZmZXJOb2RlMTYgPSBidWZmZXJOb2RlKSA9PT0gbnVsbCB8fCBfYnVmZmVyTm9kZTE2ID09PSB2b2lkIDAgPyB2b2lkIDAgOiBfYnVmZmVyTm9kZTE2LnR5cGUpID09PSBOb2RlVHlwZS5BYnNvbHV0ZVBzZXVkb0NsYXNzKSB7XG4gICAgICAgICAgICAgICAgICAvLyBubyBicmFja2V0cyBiYWxhbmNpbmcgbmVlZGVkIGluc2lkZVxuICAgICAgICAgICAgICAgICAgLy8gMS4gOnhwYXRoKCkgZXh0ZW5kZWQgcHNldWRvLWNsYXNzIGFyZ1xuICAgICAgICAgICAgICAgICAgLy8gMi4gcmVnZXhwIGFyZyBmb3Igb3RoZXIgZXh0ZW5kZWQgcHNldWRvLWNsYXNzZXNcbiAgICAgICAgICAgICAgICAgIGlmIChidWZmZXJOb2RlLm5hbWUgIT09IFhQQVRIX1BTRVVET19DTEFTU19NQVJLRVIgJiYgY29udGV4dC5pc1JlZ2V4cE9wZW4pIHtcbiAgICAgICAgICAgICAgICAgICAgLy8gaWYgY2xvc2luZyBicmFja2V0IGlzIHBhcnQgb2YgcmVnZXhwXG4gICAgICAgICAgICAgICAgICAgIC8vIHNpbXBseSBzYXZlIGl0IHRvIHBzZXVkby1jbGFzcyBhcmdcbiAgICAgICAgICAgICAgICAgICAgdXBkYXRlQnVmZmVyTm9kZShjb250ZXh0LCB0b2tlblZhbHVlKTtcbiAgICAgICAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgICAgICAgIC8vIHJlbW92ZSBzdGFja2VkIG9wZW4gcGFyZW50aGVzZXMgZm9yIGJyYWNrZXRzIGJhbGFuY2VcbiAgICAgICAgICAgICAgICAgICAgLy8gZS5nLiAnaDM6Y29udGFpbnMoKEFkcykpJ1xuICAgICAgICAgICAgICAgICAgICAvLyBvciAgICdkaXY6eHBhdGgoLy9oM1tjb250YWlucyh0ZXh0KCksXCJTaGFyZSBpdCFcIildLy4uKSdcbiAgICAgICAgICAgICAgICAgICAgY29udGV4dC5leHRlbmRlZFBzZXVkb0JyYWNrZXRzU3RhY2sucG9wKCk7XG5cbiAgICAgICAgICAgICAgICAgICAgaWYgKGJ1ZmZlck5vZGUubmFtZSAhPT0gWFBBVEhfUFNFVURPX0NMQVNTX01BUktFUikge1xuICAgICAgICAgICAgICAgICAgICAgIC8vIGZvciBhbGwgb3RoZXIgYWJzb2x1dGUgcHNldWRvLWNsYXNzZXMgZXhjZXB0IDp4cGF0aCgpXG4gICAgICAgICAgICAgICAgICAgICAgLy8gcmVtb3ZlIHN0YWNrZWQgbmFtZSBvZiBleHRlbmRlZCBwc2V1ZG8tY2xhc3NcbiAgICAgICAgICAgICAgICAgICAgICBjb250ZXh0LmV4dGVuZGVkUHNldWRvTmFtZXNTdGFjay5wb3AoKTtcblxuICAgICAgICAgICAgICAgICAgICAgIGlmIChjb250ZXh0LmV4dGVuZGVkUHNldWRvQnJhY2tldHNTdGFjay5sZW5ndGggPiBjb250ZXh0LmV4dGVuZGVkUHNldWRvTmFtZXNTdGFjay5sZW5ndGgpIHtcbiAgICAgICAgICAgICAgICAgICAgICAgIC8vIGVzbGludC1kaXNhYmxlLWxpbmUgbWF4LWxlblxuICAgICAgICAgICAgICAgICAgICAgICAgLy8gaWYgYnJhY2tldHMgc3RhY2sgaXMgbm90IGVtcHR5IHlldCxcbiAgICAgICAgICAgICAgICAgICAgICAgIC8vIHNhdmUgdG9rZW5WYWx1ZSB0byBhcmcgb2YgQWJzb2x1dGVQc2V1ZG9DbGFzc1xuICAgICAgICAgICAgICAgICAgICAgICAgLy8gcGFyc2VyIHBvc2l0aW9uIG9uIGZpcnN0IGNsb3NpbmcgYnJhY2tldCBhZnRlciAnQWRzJzpcbiAgICAgICAgICAgICAgICAgICAgICAgIC8vIGUuZy4gJ2gzOmNvbnRhaW5zKChBZHMpKSdcbiAgICAgICAgICAgICAgICAgICAgICAgIHVwZGF0ZUJ1ZmZlck5vZGUoY29udGV4dCwgdG9rZW5WYWx1ZSk7XG4gICAgICAgICAgICAgICAgICAgICAgfSBlbHNlIGlmIChjb250ZXh0LmV4dGVuZGVkUHNldWRvQnJhY2tldHNTdGFjay5sZW5ndGggPj0gMCAmJiBjb250ZXh0LmV4dGVuZGVkUHNldWRvTmFtZXNTdGFjay5sZW5ndGggPj0gMCkge1xuICAgICAgICAgICAgICAgICAgICAgICAgLy8gYXNzdW1lIGl0IGlzIGNvbWJpbmVkIGV4dGVuZGVkIHBzZXVkby1jbGFzc2VzXG4gICAgICAgICAgICAgICAgICAgICAgICAvLyBwYXJzZXIgcG9zaXRpb24gb24gZmlyc3QgY2xvc2luZyBicmFja2V0IGFmdGVyICdhZHZlcnQnOlxuICAgICAgICAgICAgICAgICAgICAgICAgLy8gZS5nLiAnZGl2OmhhcyguYmFubmVyLCA6Y29udGFpbnMoYWR2ZXJ0KSknXG4gICAgICAgICAgICAgICAgICAgICAgICB1cFRvQ2xvc2VzdChjb250ZXh0LCBOb2RlVHlwZS5TZWxlY3Rvcik7XG4gICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICAgICAgICAgIC8vIGZvciA6eHBhdGgoKVxuICAgICAgICAgICAgICAgICAgICAgIGlmIChjb250ZXh0LmV4dGVuZGVkUHNldWRvQnJhY2tldHNTdGFjay5sZW5ndGggPCBjb250ZXh0LmV4dGVuZGVkUHNldWRvTmFtZXNTdGFjay5sZW5ndGgpIHtcbiAgICAgICAgICAgICAgICAgICAgICAgIC8vIGVzbGludC1kaXNhYmxlLWxpbmUgbWF4LWxlblxuICAgICAgICAgICAgICAgICAgICAgICAgLy8gcmVtb3ZlIHN0YWNrZWQgbmFtZSBvZiBleHRlbmRlZCBwc2V1ZG8tY2xhc3NcbiAgICAgICAgICAgICAgICAgICAgICAgIC8vIGlmIHRoZXJlIGFyZSBsZXNzIGJyYWNrZXRzIHRoYW4gcHNldWRvLWNsYXNzIG5hbWVzXG4gICAgICAgICAgICAgICAgICAgICAgICAvLyB3aXRoIG1lYW5zIGxhc3QgcmVtb3ZlcyBicmFja2V0IHdhcyBjbG9zaW5nIGZvciBwc2V1ZG8tY2xhc3NcbiAgICAgICAgICAgICAgICAgICAgICAgIGNvbnRleHQuZXh0ZW5kZWRQc2V1ZG9OYW1lc1N0YWNrLnBvcCgpO1xuICAgICAgICAgICAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgICAgICAgICAgICAvLyBvdGhlcndpc2UgdGhlIGJyYWNrZXQgaXMgcGFydCBvZiBhcmdcbiAgICAgICAgICAgICAgICAgICAgICAgIHVwZGF0ZUJ1ZmZlck5vZGUoY29udGV4dCwgdG9rZW5WYWx1ZSk7XG4gICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgaWYgKCgoX2J1ZmZlck5vZGUxNyA9IGJ1ZmZlck5vZGUpID09PSBudWxsIHx8IF9idWZmZXJOb2RlMTcgPT09IHZvaWQgMCA/IHZvaWQgMCA6IF9idWZmZXJOb2RlMTcudHlwZSkgPT09IE5vZGVUeXBlLlJlZ3VsYXJTZWxlY3Rvcikge1xuICAgICAgICAgICAgICAgICAgaWYgKGNvbnRleHQuaXNBdHRyaWJ1dGVCcmFja2V0c09wZW4pIHtcbiAgICAgICAgICAgICAgICAgICAgLy8gcGFyZW50aGVzZXMgaW5zaWRlIGF0dHJpYnV0ZSB2YWx1ZSBzaG91bGQgYmUgcGFydCBvZiBSZWd1bGFyU2VsZWN0b3IgdmFsdWVcbiAgICAgICAgICAgICAgICAgICAgLy8gZS5nLiAnZGl2Om5vdChbaHJlZio9XCJ3aW5kb3cucHJpbnQoKVwiXSknICAgPC0tIHBhcnNlciBwb3NpdGlvblxuICAgICAgICAgICAgICAgICAgICAvLyBpcyBvbiB0aGUgYClgIGFmdGVyIGBwcmludChgICAgICAgIOKGkVxuICAgICAgICAgICAgICAgICAgICB1cGRhdGVCdWZmZXJOb2RlKGNvbnRleHQsIHRva2VuVmFsdWUpO1xuICAgICAgICAgICAgICAgICAgfSBlbHNlIGlmIChjb250ZXh0LnN0YW5kYXJkUHNldWRvTmFtZXNTdGFjay5sZW5ndGggPiAwICYmIGNvbnRleHQuc3RhbmRhcmRQc2V1ZG9CcmFja2V0c1N0YWNrLmxlbmd0aCA+IDApIHtcbiAgICAgICAgICAgICAgICAgICAgLy8gc3RhbmRhcmQgcHNldWRvLWNsYXNzIHdhcyBwcm9jZXNzaW5nLlxuICAgICAgICAgICAgICAgICAgICAvLyBjb2xsZWN0IHRoZSBjbG9zaW5nIGJyYWNrZXQgdG8gdmFsdWUgb2YgUmVndWxhclNlbGVjdG9yXG4gICAgICAgICAgICAgICAgICAgIC8vIHBhcnNlciBwb3NpdGlvbiBpcyBvbiBicmFja2V0IGFmdGVyICdjbGFzcycgbm93OlxuICAgICAgICAgICAgICAgICAgICAvLyBlLmcuICdkaXY6d2hlcmUoLmNsYXNzKSdcbiAgICAgICAgICAgICAgICAgICAgdXBkYXRlQnVmZmVyTm9kZShjb250ZXh0LCB0b2tlblZhbHVlKTsgLy8gcmVtb3ZlIGJyYWNrZXQgYW5kIHBzZXVkbyBuYW1lIGZyb20gc3RhY2tzXG5cbiAgICAgICAgICAgICAgICAgICAgY29udGV4dC5zdGFuZGFyZFBzZXVkb0JyYWNrZXRzU3RhY2sucG9wKCk7XG4gICAgICAgICAgICAgICAgICAgIGNvbnN0IGxhc3RTdGFuZGFyZFBzZXVkbyA9IGNvbnRleHQuc3RhbmRhcmRQc2V1ZG9OYW1lc1N0YWNrLnBvcCgpO1xuXG4gICAgICAgICAgICAgICAgICAgIGlmICghbGFzdFN0YW5kYXJkUHNldWRvKSB7XG4gICAgICAgICAgICAgICAgICAgICAgLy8gc3RhbmRhcmQgcHNldWRvIHNob3VsZCBiZSBpbiBzdGFuZGFyZFBzZXVkb05hbWVzU3RhY2tcbiAgICAgICAgICAgICAgICAgICAgICAvLyBhcyByZWxhdGVkIHRvIHN0YW5kYXJkUHNldWRvQnJhY2tldHNTdGFja1xuICAgICAgICAgICAgICAgICAgICAgIHRocm93IG5ldyBFcnJvcihcIlBhcnNpbmcgZXJyb3IuIEludmFsaWQgc2VsZWN0b3I6IFwiLmNvbmNhdChzZWxlY3RvcikpO1xuICAgICAgICAgICAgICAgICAgICB9IC8vIERpc2FsbG93IDpoYXMoKSBhZnRlciByZWd1bGFyIHBzZXVkby1lbGVtZW50c1xuICAgICAgICAgICAgICAgICAgICAvLyBodHRwczovL2J1Z3MuY2hyb21pdW0ub3JnL3AvY2hyb21pdW0vaXNzdWVzL2RldGFpbD9pZD02NjkwNTgjYzU0IFszXVxuXG5cbiAgICAgICAgICAgICAgICAgICAgaWYgKE9iamVjdC52YWx1ZXMoUkVHVUxBUl9QU0VVRE9fRUxFTUVOVFMpLmluY2x1ZGVzKGxhc3RTdGFuZGFyZFBzZXVkbykgLy8gY2hlY2sgdG9rZW4gd2hpY2ggaXMgbmV4dCB0byBjbG9zaW5nIHBhcmVudGhlc2VzIGFuZCB0b2tlbiBhZnRlciBpdFxuICAgICAgICAgICAgICAgICAgICAvLyBwYXJzZXIgcG9zaXRpb24gaXMgb24gYnJhY2tldCBhZnRlciAnZm9vJyBub3c6XG4gICAgICAgICAgICAgICAgICAgIC8vIGUuZy4gJzo6cGFydChmb28pOmhhcyguYSknXG4gICAgICAgICAgICAgICAgICAgICYmIG5leHRUb2tlblZhbHVlID09PSBDT0xPTiAmJiBuZXh0VG9OZXh0VG9rZW5WYWx1ZSAmJiBIQVNfUFNFVURPX0NMQVNTX01BUktFUlMuaW5jbHVkZXMobmV4dFRvTmV4dFRva2VuVmFsdWUpKSB7XG4gICAgICAgICAgICAgICAgICAgICAgLy8gZXNsaW50LWRpc2FibGUtbmV4dC1saW5lIG1heC1sZW5cbiAgICAgICAgICAgICAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJVc2FnZSBvZiA6XCIuY29uY2F0KG5leHRUb05leHRUb2tlblZhbHVlLCBcIigpIHBzZXVkby1jbGFzcyBpcyBub3QgYWxsb3dlZCBhZnRlciBhbnkgcmVndWxhciBwc2V1ZG8tZWxlbWVudDogJ1wiKS5jb25jYXQobGFzdFN0YW5kYXJkUHNldWRvLCBcIidcIikpO1xuICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICAgICAgICAvLyBleHRlbmRlZCBwc2V1ZG8tY2xhc3Mgd2FzIHByb2Nlc3NpbmcuXG4gICAgICAgICAgICAgICAgICAgIC8vIGUuZy4gJ2RpdjpoYXMoaDMpJ1xuICAgICAgICAgICAgICAgICAgICAvLyByZW1vdmUgYnJhY2tldCBhbmQgcHNldWRvIG5hbWUgZnJvbSBzdGFja3NcbiAgICAgICAgICAgICAgICAgICAgY29udGV4dC5leHRlbmRlZFBzZXVkb0JyYWNrZXRzU3RhY2sucG9wKCk7XG4gICAgICAgICAgICAgICAgICAgIGNvbnRleHQuZXh0ZW5kZWRQc2V1ZG9OYW1lc1N0YWNrLnBvcCgpO1xuICAgICAgICAgICAgICAgICAgICB1cFRvQ2xvc2VzdChjb250ZXh0LCBOb2RlVHlwZS5FeHRlbmRlZFNlbGVjdG9yKTsgLy8gZ28gdG8gdXBwZXIgc2VsZWN0b3IgZm9yIHBvc3NpYmxlIHNlbGVjdG9yIGNvbnRpbnVhdGlvbiBhZnRlciBleHRlbmRlZCBwc2V1ZG8tY2xhc3NcbiAgICAgICAgICAgICAgICAgICAgLy8gZS5nLiAnZGl2OmhhcyhoMykgPiBpbWcnXG5cbiAgICAgICAgICAgICAgICAgICAgdXBUb0Nsb3Nlc3QoY29udGV4dCwgTm9kZVR5cGUuU2VsZWN0b3IpO1xuICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgIGlmICgoKF9idWZmZXJOb2RlMTggPSBidWZmZXJOb2RlKSA9PT0gbnVsbCB8fCBfYnVmZmVyTm9kZTE4ID09PSB2b2lkIDAgPyB2b2lkIDAgOiBfYnVmZmVyTm9kZTE4LnR5cGUpID09PSBOb2RlVHlwZS5TZWxlY3Rvcikge1xuICAgICAgICAgICAgICAgICAgLy8gYWZ0ZXIgaW5uZXIgZXh0ZW5kZWQgcHNldWRvLWNsYXNzIGJ1ZmZlck5vZGUgaXMgU2VsZWN0b3IuXG4gICAgICAgICAgICAgICAgICAvLyBwYXJzZXIgcG9zaXRpb24gaXMgb24gbGFzdCBicmFja2V0IG5vdzpcbiAgICAgICAgICAgICAgICAgIC8vIGUuZy4gJ2RpdjpoYXMoLmJhbm5lciwgOmNvbnRhaW5zKGFkcykpJ1xuICAgICAgICAgICAgICAgICAgY29udGV4dC5leHRlbmRlZFBzZXVkb0JyYWNrZXRzU3RhY2sucG9wKCk7XG4gICAgICAgICAgICAgICAgICBjb250ZXh0LmV4dGVuZGVkUHNldWRvTmFtZXNTdGFjay5wb3AoKTtcbiAgICAgICAgICAgICAgICAgIHVwVG9DbG9zZXN0KGNvbnRleHQsIE5vZGVUeXBlLkV4dGVuZGVkU2VsZWN0b3IpO1xuICAgICAgICAgICAgICAgICAgdXBUb0Nsb3Nlc3QoY29udGV4dCwgTm9kZVR5cGUuU2VsZWN0b3IpO1xuICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgIGlmICgoKF9idWZmZXJOb2RlMTkgPSBidWZmZXJOb2RlKSA9PT0gbnVsbCB8fCBfYnVmZmVyTm9kZTE5ID09PSB2b2lkIDAgPyB2b2lkIDAgOiBfYnVmZmVyTm9kZTE5LnR5cGUpID09PSBOb2RlVHlwZS5SZWxhdGl2ZVBzZXVkb0NsYXNzKSB7XG4gICAgICAgICAgICAgICAgICAvLyBzYXZlIG9wZW5pbmcgYnJhY2tldCBmb3IgYmFsYW5jaW5nXG4gICAgICAgICAgICAgICAgICAvLyBlLmcuICdkaXY6bm90KCknICAvLyBwb3NpdGlvbiBpcyBvbiBgKWBcbiAgICAgICAgICAgICAgICAgIC8vIGNvbnRleHQuZXh0ZW5kZWRQc2V1ZG9CcmFja2V0c1N0YWNrLnB1c2godG9rZW5WYWx1ZSk7XG4gICAgICAgICAgICAgICAgICBpZiAoY29udGV4dC5leHRlbmRlZFBzZXVkb05hbWVzU3RhY2subGVuZ3RoID4gMCAmJiBjb250ZXh0LmV4dGVuZGVkUHNldWRvQnJhY2tldHNTdGFjay5sZW5ndGggPiAwKSB7XG4gICAgICAgICAgICAgICAgICAgIGNvbnRleHQuZXh0ZW5kZWRQc2V1ZG9CcmFja2V0c1N0YWNrLnBvcCgpO1xuICAgICAgICAgICAgICAgICAgICBjb250ZXh0LmV4dGVuZGVkUHNldWRvTmFtZXNTdGFjay5wb3AoKTtcbiAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgICBicmVhaztcblxuICAgICAgICAgICAgICBjYXNlIExJTkVfRkVFRDpcbiAgICAgICAgICAgICAgY2FzZSBGT1JNX0ZFRUQ6XG4gICAgICAgICAgICAgIGNhc2UgQ0FSUklBR0VfUkVUVVJOOlxuICAgICAgICAgICAgICAgIC8vIHN1Y2ggY2hhcmFjdGVycyBhdCBzdGFydCBhbmQgZW5kIG9mIHNlbGVjdG9yIHNob3VsZCBiZSB0cmltbWVkXG4gICAgICAgICAgICAgICAgLy8gc28gaXMgdGhlcmUgaXMgb25lIHRoZW0gYW1vbmcgdG9rZW5zLCBpdCBpcyBub3QgdmFsaWQgc2VsZWN0b3JcbiAgICAgICAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCInXCIuY29uY2F0KHNlbGVjdG9yLCBcIicgaXMgbm90IGEgdmFsaWQgc2VsZWN0b3JcIikpO1xuXG4gICAgICAgICAgICAgIGNhc2UgVEFCOlxuICAgICAgICAgICAgICAgIC8vIGFsbG93IHRhYiBvbmx5IGluc2lkZSBhdHRyaWJ1dGUgdmFsdWVcbiAgICAgICAgICAgICAgICAvLyBhcyB0aGVyZSBhcmUgc3VjaCB2YWxpZCBydWxlcyBpbiBmaWx0ZXIgbGlzdHNcbiAgICAgICAgICAgICAgICAvLyBlLmcuICdkaXZbc3R5bGVePVwibWFyZ2luLXJpZ2h0OiBhdXRvO1x0dGV4dC1hbGlnbjogbGVmdDsnLFxuICAgICAgICAgICAgICAgIC8vIHBhcnNlciBwb3NpdGlvbiAgICAgICAgICAgICAgICAgICAgICDihpFcbiAgICAgICAgICAgICAgICBpZiAoKChfYnVmZmVyTm9kZTIwID0gYnVmZmVyTm9kZSkgPT09IG51bGwgfHwgX2J1ZmZlck5vZGUyMCA9PT0gdm9pZCAwID8gdm9pZCAwIDogX2J1ZmZlck5vZGUyMC50eXBlKSA9PT0gTm9kZVR5cGUuUmVndWxhclNlbGVjdG9yICYmIGNvbnRleHQuaXNBdHRyaWJ1dGVCcmFja2V0c09wZW4pIHtcbiAgICAgICAgICAgICAgICAgIHVwZGF0ZUJ1ZmZlck5vZGUoY29udGV4dCwgdG9rZW5WYWx1ZSk7XG4gICAgICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgICAgIC8vIG90aGVyd2lzZSBub3QgdmFsaWRcbiAgICAgICAgICAgICAgICAgIHRocm93IG5ldyBFcnJvcihcIidcIi5jb25jYXQoc2VsZWN0b3IsIFwiJyBpcyBub3QgYSB2YWxpZCBzZWxlY3RvclwiKSk7XG4gICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIGJyZWFrO1xuICAgICAgICAgIC8vIG5vIGRlZmF1bHQgc3RhdGVtZW50IGZvciBNYXJrcyBhcyB0aGV5IGFyZSBsaW1pdGVkIHRvIFNVUFBPUlRFRF9TRUxFQ1RPUl9NQVJLU1xuICAgICAgICAgIC8vIGFuZCBhbGwgb3RoZXIgc3ltYm9sIGNvbWJpbmF0aW9ucyBhcmUgdG9rZW5pemVkIGFzIFdvcmRcbiAgICAgICAgICAvLyBzbyBlcnJvciBmb3IgaW52YWxpZCBXb3JkIHdpbGwgYmUgdGhyb3duIGxhdGVyIHdoaWxlIGVsZW1lbnQgc2VsZWN0aW5nIGJ5IHBhcnNlZCBhc3RcblxuICAgICAgICAgIGRlZmF1bHQ6XG4gICAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJVbmtub3duIHR5cGUgb2YgdG9rZW46ICdcIi5jb25jYXQodG9rZW5WYWx1ZSwgXCInXCIpKTtcbiAgICAgICAgfVxuXG4gICAgICAgIGkgKz0gMTtcbiAgICAgIH1cblxuICAgICAgaWYgKGNvbnRleHQuYXN0ID09PSBudWxsKSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcihcIidcIi5jb25jYXQoc2VsZWN0b3IsIFwiJyBpcyBub3QgYSB2YWxpZCBzZWxlY3RvclwiKSk7XG4gICAgICB9XG5cbiAgICAgIGlmIChjb250ZXh0LmV4dGVuZGVkUHNldWRvTmFtZXNTdGFjay5sZW5ndGggPiAwIHx8IGNvbnRleHQuZXh0ZW5kZWRQc2V1ZG9CcmFja2V0c1N0YWNrLmxlbmd0aCA+IDApIHtcbiAgICAgICAgLy8gZXNsaW50LWRpc2FibGUtbmV4dC1saW5lIG1heC1sZW5cbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiVW5iYWxhbmNlZCBicmFja2V0cyBmb3IgZXh0ZW5kZWQgcHNldWRvLWNsYXNzOiAnXCIuY29uY2F0KGdldExhc3QoY29udGV4dC5leHRlbmRlZFBzZXVkb05hbWVzU3RhY2spLCBcIidcIikpO1xuICAgICAgfVxuXG4gICAgICBpZiAoY29udGV4dC5pc0F0dHJpYnV0ZUJyYWNrZXRzT3Blbikge1xuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJVbmJhbGFuY2VkIGF0dHJpYnV0ZSBicmFja2V0cyBpcyBzZWxlY3RvcjogJ1wiLmNvbmNhdChzZWxlY3RvciwgXCInXCIpKTtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIGNvbnRleHQuYXN0O1xuICAgIH07XG5cbiAgICBmdW5jdGlvbiBfYXJyYXlXaXRoSG9sZXMoYXJyKSB7XG4gICAgICBpZiAoQXJyYXkuaXNBcnJheShhcnIpKSByZXR1cm4gYXJyO1xuICAgIH1cblxuICAgIGZ1bmN0aW9uIF9pdGVyYWJsZVRvQXJyYXlMaW1pdChhcnIsIGkpIHtcbiAgICAgIHZhciBfaSA9IGFyciA9PSBudWxsID8gbnVsbCA6IHR5cGVvZiBTeW1ib2wgIT09IFwidW5kZWZpbmVkXCIgJiYgYXJyW1N5bWJvbC5pdGVyYXRvcl0gfHwgYXJyW1wiQEBpdGVyYXRvclwiXTtcblxuICAgICAgaWYgKF9pID09IG51bGwpIHJldHVybjtcbiAgICAgIHZhciBfYXJyID0gW107XG4gICAgICB2YXIgX24gPSB0cnVlO1xuICAgICAgdmFyIF9kID0gZmFsc2U7XG5cbiAgICAgIHZhciBfcywgX2U7XG5cbiAgICAgIHRyeSB7XG4gICAgICAgIGZvciAoX2kgPSBfaS5jYWxsKGFycik7ICEoX24gPSAoX3MgPSBfaS5uZXh0KCkpLmRvbmUpOyBfbiA9IHRydWUpIHtcbiAgICAgICAgICBfYXJyLnB1c2goX3MudmFsdWUpO1xuXG4gICAgICAgICAgaWYgKGkgJiYgX2Fyci5sZW5ndGggPT09IGkpIGJyZWFrO1xuICAgICAgICB9XG4gICAgICB9IGNhdGNoIChlcnIpIHtcbiAgICAgICAgX2QgPSB0cnVlO1xuICAgICAgICBfZSA9IGVycjtcbiAgICAgIH0gZmluYWxseSB7XG4gICAgICAgIHRyeSB7XG4gICAgICAgICAgaWYgKCFfbiAmJiBfaVtcInJldHVyblwiXSAhPSBudWxsKSBfaVtcInJldHVyblwiXSgpO1xuICAgICAgICB9IGZpbmFsbHkge1xuICAgICAgICAgIGlmIChfZCkgdGhyb3cgX2U7XG4gICAgICAgIH1cbiAgICAgIH1cblxuICAgICAgcmV0dXJuIF9hcnI7XG4gICAgfVxuXG4gICAgZnVuY3Rpb24gX2FycmF5TGlrZVRvQXJyYXkoYXJyLCBsZW4pIHtcbiAgICAgIGlmIChsZW4gPT0gbnVsbCB8fCBsZW4gPiBhcnIubGVuZ3RoKSBsZW4gPSBhcnIubGVuZ3RoO1xuXG4gICAgICBmb3IgKHZhciBpID0gMCwgYXJyMiA9IG5ldyBBcnJheShsZW4pOyBpIDwgbGVuOyBpKyspIHtcbiAgICAgICAgYXJyMltpXSA9IGFycltpXTtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIGFycjI7XG4gICAgfVxuXG4gICAgZnVuY3Rpb24gX3Vuc3VwcG9ydGVkSXRlcmFibGVUb0FycmF5KG8sIG1pbkxlbikge1xuICAgICAgaWYgKCFvKSByZXR1cm47XG4gICAgICBpZiAodHlwZW9mIG8gPT09IFwic3RyaW5nXCIpIHJldHVybiBfYXJyYXlMaWtlVG9BcnJheShvLCBtaW5MZW4pO1xuICAgICAgdmFyIG4gPSBPYmplY3QucHJvdG90eXBlLnRvU3RyaW5nLmNhbGwobykuc2xpY2UoOCwgLTEpO1xuICAgICAgaWYgKG4gPT09IFwiT2JqZWN0XCIgJiYgby5jb25zdHJ1Y3RvcikgbiA9IG8uY29uc3RydWN0b3IubmFtZTtcbiAgICAgIGlmIChuID09PSBcIk1hcFwiIHx8IG4gPT09IFwiU2V0XCIpIHJldHVybiBBcnJheS5mcm9tKG8pO1xuICAgICAgaWYgKG4gPT09IFwiQXJndW1lbnRzXCIgfHwgL14oPzpVaXxJKW50KD86OHwxNnwzMikoPzpDbGFtcGVkKT9BcnJheSQvLnRlc3QobikpIHJldHVybiBfYXJyYXlMaWtlVG9BcnJheShvLCBtaW5MZW4pO1xuICAgIH1cblxuICAgIGZ1bmN0aW9uIF9ub25JdGVyYWJsZVJlc3QoKSB7XG4gICAgICB0aHJvdyBuZXcgVHlwZUVycm9yKFwiSW52YWxpZCBhdHRlbXB0IHRvIGRlc3RydWN0dXJlIG5vbi1pdGVyYWJsZSBpbnN0YW5jZS5cXG5JbiBvcmRlciB0byBiZSBpdGVyYWJsZSwgbm9uLWFycmF5IG9iamVjdHMgbXVzdCBoYXZlIGEgW1N5bWJvbC5pdGVyYXRvcl0oKSBtZXRob2QuXCIpO1xuICAgIH1cblxuICAgIGZ1bmN0aW9uIF9zbGljZWRUb0FycmF5KGFyciwgaSkge1xuICAgICAgcmV0dXJuIF9hcnJheVdpdGhIb2xlcyhhcnIpIHx8IF9pdGVyYWJsZVRvQXJyYXlMaW1pdChhcnIsIGkpIHx8IF91bnN1cHBvcnRlZEl0ZXJhYmxlVG9BcnJheShhcnIsIGkpIHx8IF9ub25JdGVyYWJsZVJlc3QoKTtcbiAgICB9XG5cbiAgICAvKipcbiAgICAgKiBWYWxpZGF0ZXMgbnVtYmVyIGFyZyBmb3IgOm50aC1hbmNlc3RvcigpIGFuZCA6dXB3YXJkKCkgcHNldWRvLWNsYXNzZXMuXG4gICAgICpcbiAgICAgKiBAcGFyYW0gcmF3QXJnIFJhdyBhcmcgb2YgcHNldWRvLWNsYXNzLlxuICAgICAqIEBwYXJhbSBwc2V1ZG9OYW1lIFBzZXVkby1jbGFzcyBuYW1lLlxuICAgICAqXG4gICAgICogQHRocm93cyBBbiBlcnJvciBvbiBpbnZhbGlkIGByYXdBcmdgLlxuICAgICAqL1xuICAgIGNvbnN0IGdldFZhbGlkTnVtYmVyQW5jZXN0b3JBcmcgPSAocmF3QXJnLCBwc2V1ZG9OYW1lKSA9PiB7XG4gICAgICBjb25zdCBkZWVwID0gTnVtYmVyKHJhd0FyZyk7XG5cbiAgICAgIGlmIChOdW1iZXIuaXNOYU4oZGVlcCkgfHwgZGVlcCA8IDEgfHwgZGVlcCA+PSAyNTYpIHtcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiSW52YWxpZCBhcmd1bWVudCBvZiA6XCIuY29uY2F0KHBzZXVkb05hbWUsIFwiIHBzZXVkby1jbGFzczogJ1wiKS5jb25jYXQocmF3QXJnLCBcIidcIikpO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gZGVlcDtcbiAgICB9O1xuICAgIC8qKlxuICAgICAqIFJldHVybnMgbnRoIGFuY2VzdG9yIGJ5ICdkZWVwJyBudW1iZXIgYXJnIE9SIHVuZGVmaW5lZCBpZiBhbmNlc3RvciByYW5nZSBsaW1pdCBleGNlZWRlZC5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBkb21FbGVtZW50IERPTSBlbGVtZW50IHRvIGZpbmQgYW5jZXN0b3IgZm9yLlxuICAgICAqIEBwYXJhbSBudGggRGVwdGggdXAgdG8gbmVlZGVkIGFuY2VzdG9yLlxuICAgICAqIEBwYXJhbSBwc2V1ZG9OYW1lIFBzZXVkby1jbGFzcyBuYW1lLlxuICAgICAqXG4gICAgICogQHRocm93cyBBbiBlcnJvciBvbiBpbnZhbGlkIGBudGhgIGFyZy5cbiAgICAgKi9cblxuICAgIGNvbnN0IGdldE50aEFuY2VzdG9yID0gKGRvbUVsZW1lbnQsIG50aCwgcHNldWRvTmFtZSkgPT4ge1xuICAgICAgbGV0IGFuY2VzdG9yID0gbnVsbDtcbiAgICAgIGxldCBpID0gMDtcblxuICAgICAgd2hpbGUgKGkgPCBudGgpIHtcbiAgICAgICAgYW5jZXN0b3IgPSBkb21FbGVtZW50LnBhcmVudEVsZW1lbnQ7XG5cbiAgICAgICAgaWYgKCFhbmNlc3Rvcikge1xuICAgICAgICAgIHRocm93IG5ldyBFcnJvcihcIkFyZ3VtZW50IG9mIDpcIi5jb25jYXQocHNldWRvTmFtZSwgXCIoKSBwc2V1ZG8tY2xhc3MgaXMgdG9vIGJpZyBcXHUyMDE0ICdcIikuY29uY2F0KG50aCwgXCInLCBvdXQgb2YgRE9NIGVsZW1lbnRzIHJvb3QuXCIpKTsgLy8gZXNsaW50LWRpc2FibGUtbGluZSBtYXgtbGVuXG4gICAgICAgIH1cblxuICAgICAgICBkb21FbGVtZW50ID0gYW5jZXN0b3I7XG4gICAgICAgIGkgKz0gMTtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIGFuY2VzdG9yO1xuICAgIH07XG4gICAgLyoqXG4gICAgICogVmFsaWRhdGVzIHN0YW5kYXJkIENTUyBzZWxlY3Rvci5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBzZWxlY3RvciBTdGFuZGFyZCBzZWxlY3Rvci5cbiAgICAgKi9cblxuICAgIGNvbnN0IHZhbGlkYXRlU3RhbmRhcmRTZWxlY3RvciA9IHNlbGVjdG9yID0+IHtcbiAgICAgIGxldCBpc1ZhbGlkO1xuXG4gICAgICB0cnkge1xuICAgICAgICBkb2N1bWVudC5xdWVyeVNlbGVjdG9yQWxsKHNlbGVjdG9yKTtcbiAgICAgICAgaXNWYWxpZCA9IHRydWU7XG4gICAgICB9IGNhdGNoIChlKSB7XG4gICAgICAgIGlzVmFsaWQgPSBmYWxzZTtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIGlzVmFsaWQ7XG4gICAgfTtcblxuICAgIC8qKlxuICAgICAqIFdyYXBwZXIgdG8gcnVuIG1hdGNoZXIgYGNhbGxiYWNrYCB3aXRoIGBhcmdzYFxuICAgICAqIGFuZCB0aHJvdyBlcnJvciB3aXRoIGBlcnJvck1lc3NhZ2VgIGlmIGBjYWxsYmFja2AgcnVuIGZhaWxzLlxuICAgICAqXG4gICAgICogQHBhcmFtIGNhbGxiYWNrIE1hdGNoZXIgY2FsbGJhY2suXG4gICAgICogQHBhcmFtIGFyZ3NEYXRhIEFyZ3MgbmVlZGVkIGZvciBtYXRjaGVyIGNhbGxiYWNrLlxuICAgICAqIEBwYXJhbSBlcnJvck1lc3NhZ2UgRXJyb3IgbWVzc2FnZS5cbiAgICAgKlxuICAgICAqIEB0aHJvd3MgQW4gZXJyb3IgaWYgYGNhbGxiYWNrYCBmYWlscy5cbiAgICAgKi9cbiAgICBjb25zdCBtYXRjaGVyV3JhcHBlciA9IChjYWxsYmFjaywgYXJnc0RhdGEsIGVycm9yTWVzc2FnZSkgPT4ge1xuICAgICAgbGV0IGlzTWF0Y2hlZDtcblxuICAgICAgdHJ5IHtcbiAgICAgICAgaXNNYXRjaGVkID0gY2FsbGJhY2soYXJnc0RhdGEpO1xuICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICBsb2dnZXIuZXJyb3IoZSk7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcihlcnJvck1lc3NhZ2UpO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gaXNNYXRjaGVkO1xuICAgIH07XG4gICAgLyoqXG4gICAgICogR2VuZXJhdGVzIGNvbW1vbiBlcnJvciBtZXNzYWdlIHRvIHRocm93IHdoaWxlIG1hdGNoaW5nIGVsZW1lbnQgYHByb3BEZXNjYC5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBwcm9wRGVzYyBUZXh0IHRvIGRlc2NyaWJlIHdoYXQgZWxlbWVudCAncHJvcCcgcHNldWRvLWNsYXNzIGlzIHRyeWluZyB0byBtYXRjaC5cbiAgICAgKiBAcGFyYW0gcHNldWRvTmFtZSBQc2V1ZG8tY2xhc3MgbmFtZS5cbiAgICAgKiBAcGFyYW0gcHNldWRvQXJnIFBzZXVkby1jbGFzcyBhcmcuXG4gICAgICovXG5cblxuICAgIGNvbnN0IGdldEFic29sdXRlUHNldWRvRXJyb3IgPSAocHJvcERlc2MsIHBzZXVkb05hbWUsIHBzZXVkb0FyZykgPT4ge1xuICAgICAgcmV0dXJuIFwiXCIuY29uY2F0KE1BVENISU5HX0VMRU1FTlRfRVJST1JfUFJFRklYLCBcIiBcIikuY29uY2F0KHByb3BEZXNjLCBcIiwgbWF5IGJlIGludmFsaWQgOlwiKS5jb25jYXQocHNldWRvTmFtZSwgXCIoKSBwc2V1ZG8tY2xhc3MgYXJnOiAnXCIpLmNvbmNhdChwc2V1ZG9BcmcsIFwiJ1wiKTsgLy8gZXNsaW50LWRpc2FibGUtbGluZSBtYXgtbGVuXG4gICAgfTtcbiAgICAvKipcbiAgICAgKiBDaGVja3Mgd2hldGhlciB0aGUgZG9tRWxlbWVudCBpcyBtYXRjaGVkIGJ5IGFic29sdXRlIGV4dGVuZGVkIHBzZXVkby1jbGFzcyBhcmd1bWVudC5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBkb21FbGVtZW50IFBhZ2UgZWxlbWVudC5cbiAgICAgKiBAcGFyYW0gcHNldWRvTmFtZSBQc2V1ZG8tY2xhc3MgbmFtZS5cbiAgICAgKiBAcGFyYW0gcHNldWRvQXJnIFBzZXVkby1jbGFzcyBhcmcuXG4gICAgICpcbiAgICAgKiBAdGhyb3dzIEFuIGVycm9yIG9uIHVua25vd24gYWJzb2x1dGUgcHNldWRvLWNsYXNzLlxuICAgICAqL1xuXG5cbiAgICBjb25zdCBpc01hdGNoZWRCeUFic29sdXRlUHNldWRvID0gKGRvbUVsZW1lbnQsIHBzZXVkb05hbWUsIHBzZXVkb0FyZykgPT4ge1xuICAgICAgbGV0IGFyZ3NEYXRhO1xuICAgICAgbGV0IGVycm9yTWVzc2FnZTtcbiAgICAgIGxldCBjYWxsYmFjaztcblxuICAgICAgc3dpdGNoIChwc2V1ZG9OYW1lKSB7XG4gICAgICAgIGNhc2UgQ09OVEFJTlNfUFNFVURPOlxuICAgICAgICBjYXNlIEhBU19URVhUX1BTRVVETzpcbiAgICAgICAgY2FzZSBBQlBfQ09OVEFJTlNfUFNFVURPOlxuICAgICAgICAgIGNhbGxiYWNrID0gaXNUZXh0TWF0Y2hlZDtcbiAgICAgICAgICBhcmdzRGF0YSA9IHtcbiAgICAgICAgICAgIHBzZXVkb05hbWUsXG4gICAgICAgICAgICBwc2V1ZG9BcmcsXG4gICAgICAgICAgICBkb21FbGVtZW50XG4gICAgICAgICAgfTtcbiAgICAgICAgICBlcnJvck1lc3NhZ2UgPSBnZXRBYnNvbHV0ZVBzZXVkb0Vycm9yKCd0ZXh0IGNvbnRlbnQnLCBwc2V1ZG9OYW1lLCBwc2V1ZG9BcmcpO1xuICAgICAgICAgIGJyZWFrO1xuXG4gICAgICAgIGNhc2UgTUFUQ0hFU19DU1NfUFNFVURPOlxuICAgICAgICBjYXNlIE1BVENIRVNfQ1NTX0FGVEVSX1BTRVVETzpcbiAgICAgICAgY2FzZSBNQVRDSEVTX0NTU19CRUZPUkVfUFNFVURPOlxuICAgICAgICAgIGNhbGxiYWNrID0gaXNTdHlsZU1hdGNoZWQ7XG4gICAgICAgICAgYXJnc0RhdGEgPSB7XG4gICAgICAgICAgICBwc2V1ZG9OYW1lLFxuICAgICAgICAgICAgcHNldWRvQXJnLFxuICAgICAgICAgICAgZG9tRWxlbWVudFxuICAgICAgICAgIH07XG4gICAgICAgICAgZXJyb3JNZXNzYWdlID0gZ2V0QWJzb2x1dGVQc2V1ZG9FcnJvcignc3R5bGUnLCBwc2V1ZG9OYW1lLCBwc2V1ZG9BcmcpO1xuICAgICAgICAgIGJyZWFrO1xuXG4gICAgICAgIGNhc2UgTUFUQ0hFU19BVFRSX1BTRVVET19DTEFTU19NQVJLRVI6XG4gICAgICAgICAgY2FsbGJhY2sgPSBpc0F0dHJpYnV0ZU1hdGNoZWQ7XG4gICAgICAgICAgYXJnc0RhdGEgPSB7XG4gICAgICAgICAgICBkb21FbGVtZW50LFxuICAgICAgICAgICAgcHNldWRvTmFtZSxcbiAgICAgICAgICAgIHBzZXVkb0FyZ1xuICAgICAgICAgIH07XG4gICAgICAgICAgZXJyb3JNZXNzYWdlID0gZ2V0QWJzb2x1dGVQc2V1ZG9FcnJvcignYXR0cmlidXRlcycsIHBzZXVkb05hbWUsIHBzZXVkb0FyZyk7XG4gICAgICAgICAgYnJlYWs7XG5cbiAgICAgICAgY2FzZSBNQVRDSEVTX1BST1BFUlRZX1BTRVVET19DTEFTU19NQVJLRVI6XG4gICAgICAgICAgY2FsbGJhY2sgPSBpc1Byb3BlcnR5TWF0Y2hlZDtcbiAgICAgICAgICBhcmdzRGF0YSA9IHtcbiAgICAgICAgICAgIGRvbUVsZW1lbnQsXG4gICAgICAgICAgICBwc2V1ZG9OYW1lLFxuICAgICAgICAgICAgcHNldWRvQXJnXG4gICAgICAgICAgfTtcbiAgICAgICAgICBlcnJvck1lc3NhZ2UgPSBnZXRBYnNvbHV0ZVBzZXVkb0Vycm9yKCdwcm9wZXJ0aWVzJywgcHNldWRvTmFtZSwgcHNldWRvQXJnKTtcbiAgICAgICAgICBicmVhaztcblxuICAgICAgICBkZWZhdWx0OlxuICAgICAgICAgIHRocm93IG5ldyBFcnJvcihcIlVua25vd24gYWJzb2x1dGUgcHNldWRvLWNsYXNzIDpcIi5jb25jYXQocHNldWRvTmFtZSwgXCIoKVwiKSk7XG4gICAgICB9XG5cbiAgICAgIHJldHVybiBtYXRjaGVyV3JhcHBlcihjYWxsYmFjaywgYXJnc0RhdGEsIGVycm9yTWVzc2FnZSk7XG4gICAgfTtcbiAgICBjb25zdCBmaW5kQnlBYnNvbHV0ZVBzZXVkb1BzZXVkbyA9IHtcbiAgICAgIC8qKlxuICAgICAgICogR2V0cyBsaXN0IG9mIG50aCBhbmNlc3RvcnMgcmVsYXRpdmUgdG8gZXZlcnkgZG9tIG5vZGUgZnJvbSBkb21FbGVtZW50cyBsaXN0LlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSBkb21FbGVtZW50cyBET00gZWxlbWVudHMuXG4gICAgICAgKiBAcGFyYW0gcmF3UHNldWRvQXJnIE51bWJlciBhcmcgb2YgOm50aC1hbmNlc3RvcigpIG9yIDp1cHdhcmQoKSBwc2V1ZG8tY2xhc3MuXG4gICAgICAgKiBAcGFyYW0gcHNldWRvTmFtZSBQc2V1ZG8tY2xhc3MgbmFtZS5cbiAgICAgICAqL1xuICAgICAgbnRoQW5jZXN0b3I6IChkb21FbGVtZW50cywgcmF3UHNldWRvQXJnLCBwc2V1ZG9OYW1lKSA9PiB7XG4gICAgICAgIGNvbnN0IGRlZXAgPSBnZXRWYWxpZE51bWJlckFuY2VzdG9yQXJnKHJhd1BzZXVkb0FyZywgcHNldWRvTmFtZSk7XG4gICAgICAgIGNvbnN0IGFuY2VzdG9ycyA9IGRvbUVsZW1lbnRzLm1hcChkb21FbGVtZW50ID0+IHtcbiAgICAgICAgICBsZXQgYW5jZXN0b3IgPSBudWxsO1xuXG4gICAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgIGFuY2VzdG9yID0gZ2V0TnRoQW5jZXN0b3IoZG9tRWxlbWVudCwgZGVlcCwgcHNldWRvTmFtZSk7XG4gICAgICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICAgICAgbG9nZ2VyLmVycm9yKGUpO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIHJldHVybiBhbmNlc3RvcjtcbiAgICAgICAgfSkuZmlsdGVyKGlzSHRtbEVsZW1lbnQpO1xuICAgICAgICByZXR1cm4gYW5jZXN0b3JzO1xuICAgICAgfSxcblxuICAgICAgLyoqXG4gICAgICAgKiBHZXRzIGxpc3Qgb2YgZWxlbWVudHMgYnkgeHBhdGggZXhwcmVzc2lvbiwgZXZhbHVhdGVkIG9uIGV2ZXJ5IGRvbSBub2RlIGZyb20gZG9tRWxlbWVudHMgbGlzdC5cbiAgICAgICAqXG4gICAgICAgKiBAcGFyYW0gZG9tRWxlbWVudHMgRE9NIGVsZW1lbnRzLlxuICAgICAgICogQHBhcmFtIHJhd1BzZXVkb0FyZyBBcmcgb2YgOnhwYXRoKCkgcHNldWRvLWNsYXNzLlxuICAgICAgICovXG4gICAgICB4cGF0aDogKGRvbUVsZW1lbnRzLCByYXdQc2V1ZG9BcmcpID0+IHtcbiAgICAgICAgY29uc3QgZm91bmRFbGVtZW50cyA9IGRvbUVsZW1lbnRzLm1hcChkb21FbGVtZW50ID0+IHtcbiAgICAgICAgICBjb25zdCByZXN1bHQgPSBbXTtcbiAgICAgICAgICBsZXQgeHBhdGhSZXN1bHQ7XG5cbiAgICAgICAgICB0cnkge1xuICAgICAgICAgICAgeHBhdGhSZXN1bHQgPSBkb2N1bWVudC5ldmFsdWF0ZShyYXdQc2V1ZG9BcmcsIGRvbUVsZW1lbnQsIG51bGwsIHdpbmRvdy5YUGF0aFJlc3VsdC5VTk9SREVSRURfTk9ERV9JVEVSQVRPUl9UWVBFLCBudWxsKTtcbiAgICAgICAgICB9IGNhdGNoIChlKSB7XG4gICAgICAgICAgICBsb2dnZXIuZXJyb3IoZSk7XG4gICAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJJbnZhbGlkIGFyZ3VtZW50IG9mIDp4cGF0aCBwc2V1ZG8tY2xhc3M6ICdcIi5jb25jYXQocmF3UHNldWRvQXJnLCBcIidcIikpO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIGxldCBub2RlID0geHBhdGhSZXN1bHQuaXRlcmF0ZU5leHQoKTtcblxuICAgICAgICAgIHdoaWxlIChub2RlKSB7XG4gICAgICAgICAgICBpZiAoaXNIdG1sRWxlbWVudChub2RlKSkge1xuICAgICAgICAgICAgICByZXN1bHQucHVzaChub2RlKTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgbm9kZSA9IHhwYXRoUmVzdWx0Lml0ZXJhdGVOZXh0KCk7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgcmV0dXJuIHJlc3VsdDtcbiAgICAgICAgfSk7XG4gICAgICAgIHJldHVybiBmbGF0dGVuKGZvdW5kRWxlbWVudHMpO1xuICAgICAgfSxcblxuICAgICAgLyoqXG4gICAgICAgKiBHZXRzIGxpc3Qgb2YgY2xvc2VzdCBhbmNlc3RvcnMgcmVsYXRpdmUgdG8gZXZlcnkgZG9tIG5vZGUgZnJvbSBkb21FbGVtZW50cyBsaXN0LlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSBkb21FbGVtZW50cyBET00gZWxlbWVudHMuXG4gICAgICAgKiBAcGFyYW0gcmF3UHNldWRvQXJnIFN0YW5kYXJkIHNlbGVjdG9yIGFyZyBvZiA6dXB3YXJkKCkgcHNldWRvLWNsYXNzLlxuICAgICAgICpcbiAgICAgICAqIEB0aHJvd3MgQW4gZXJyb3IgaWYgYHJhd1BzZXVkb0FyZ2AgaXMgbm90IGEgdmFsaWQgc3RhbmRhcmQgc2VsZWN0b3IuXG4gICAgICAgKi9cbiAgICAgIHVwd2FyZDogKGRvbUVsZW1lbnRzLCByYXdQc2V1ZG9BcmcpID0+IHtcbiAgICAgICAgaWYgKCF2YWxpZGF0ZVN0YW5kYXJkU2VsZWN0b3IocmF3UHNldWRvQXJnKSkge1xuICAgICAgICAgIHRocm93IG5ldyBFcnJvcihcIkludmFsaWQgYXJndW1lbnQgb2YgOnVwd2FyZCBwc2V1ZG8tY2xhc3M6ICdcIi5jb25jYXQocmF3UHNldWRvQXJnLCBcIidcIikpO1xuICAgICAgICB9XG5cbiAgICAgICAgY29uc3QgY2xvc2VzdEFuY2VzdG9ycyA9IGRvbUVsZW1lbnRzLm1hcChkb21FbGVtZW50ID0+IHtcbiAgICAgICAgICAvLyBjbG9zZXN0IHRvIHBhcmVudCBlbGVtZW50IHNob3VsZCBiZSBmb3VuZFxuICAgICAgICAgIC8vIG90aGVyd2lzZSBgLmJhc2U6dXB3YXJkKC5iYXNlKWAgd2lsbCByZXR1cm4gaXRzZWxmIHRvbywgbm90IG9ubHkgYW5jZXN0b3JcbiAgICAgICAgICBjb25zdCBwYXJlbnQgPSBkb21FbGVtZW50LnBhcmVudEVsZW1lbnQ7XG5cbiAgICAgICAgICBpZiAoIXBhcmVudCkge1xuICAgICAgICAgICAgcmV0dXJuIG51bGw7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgcmV0dXJuIHBhcmVudC5jbG9zZXN0KHJhd1BzZXVkb0FyZyk7XG4gICAgICAgIH0pLmZpbHRlcihpc0h0bWxFbGVtZW50KTtcbiAgICAgICAgcmV0dXJuIGNsb3Nlc3RBbmNlc3RvcnM7XG4gICAgICB9XG4gICAgfTtcblxuICAgIC8qKlxuICAgICAqIENhbGN1bGF0ZWQgc2VsZWN0b3IgdGV4dCB3aGljaCBpcyBuZWVkZWQgdG8gOmhhcygpLCA6aWYtbm90KCksIDppcygpIGFuZCA6bm90KCkgcHNldWRvLWNsYXNzZXMuXG4gICAgICogQ29udGFpbnMgY2FsY3VsYXRlZCBwYXJ0IChkZXBlbmRzIG9uIHRoZSBwcm9jZXNzZWQgZWxlbWVudClcbiAgICAgKiBhbmQgdmFsdWUgb2YgUmVndWxhclNlbGVjdG9yIHdoaWNoIGlzIG5leHQgdG8gc2VsZWN0b3IgYnkuXG4gICAgICpcbiAgICAgKiBOYXRpdmUgRG9jdW1lbnQucXVlcnlTZWxlY3RvckFsbCgpIGRvZXMgbm90IHNlbGVjdCBleGFjdCBkZXNjZW5kYW50IGVsZW1lbnRzXG4gICAgICogYnV0IG1hdGNoIGFsbCBwYWdlIGVsZW1lbnRzIHNhdGlzZnlpbmcgdGhlIHNlbGVjdG9yLFxuICAgICAqIHNvIGV4dHJhIHNwZWNpZmljYXRpb24gaXMgbmVlZGVkIGZvciBwcm9wZXIgZGVzY2VuZGFudHMgc2VsZWN0aW9uXG4gICAgICogZS5nLiAnZGl2Omhhcyg+IGltZyknLlxuICAgICAqXG4gICAgICogSXRzIGNhbGN1bGF0aW9uIGRlcGVuZHMgb24gZXh0ZW5kZWQgc2VsZWN0b3IuXG4gICAgICovXG5cbiAgICAvKipcbiAgICAgKiBDaGVja3Mgd2hldGhlciB0aGUgZWxlbWVudCBoYXMgYWxsIHJlbGF0aXZlIGVsZW1lbnRzIHNwZWNpZmllZCBieSBwc2V1ZG8tY2xhc3MgYXJnLlxuICAgICAqIFVzZWQgZm9yIDpoYXMoKSBhbmQgOmlmLW5vdCgpIHBzZXVkby1jbGFzc2VzLlxuICAgICAqXG4gICAgICogQHBhcmFtIGFyZ3NEYXRhIFJlbGF0aXZlIHBzZXVkby1jbGFzcyBoZWxwZXJzIGFyZ3MgZGF0YS5cbiAgICAgKi9cbiAgICBjb25zdCBoYXNSZWxhdGl2ZXNCeVNlbGVjdG9yTGlzdCA9IGFyZ3NEYXRhID0+IHtcbiAgICAgIGNvbnN0IGVsZW1lbnQgPSBhcmdzRGF0YS5lbGVtZW50LFxuICAgICAgICAgICAgcmVsYXRpdmVTZWxlY3Rvckxpc3QgPSBhcmdzRGF0YS5yZWxhdGl2ZVNlbGVjdG9yTGlzdCxcbiAgICAgICAgICAgIHBzZXVkb05hbWUgPSBhcmdzRGF0YS5wc2V1ZG9OYW1lO1xuICAgICAgcmV0dXJuIHJlbGF0aXZlU2VsZWN0b3JMaXN0LmNoaWxkcmVuIC8vIEFycmF5LmV2ZXJ5KCkgaXMgdXNlZCBoZXJlIGFzIGVhY2ggU2VsZWN0b3Igbm9kZSBmcm9tIFNlbGVjdG9yTGlzdCBzaG91bGQgZXhpc3Qgb24gcGFnZVxuICAgICAgLmV2ZXJ5KHNlbGVjdG9yID0+IHtcbiAgICAgICAgdmFyIF9yZWxhdGl2ZVJlZ3VsYXJTZWxlYywgX3JlbGF0aXZlUmVndWxhclNlbGVjMjtcblxuICAgICAgICAvLyBzZWxlY3Rvckxpc3QuY2hpbGRyZW4gYWx3YXlzIHN0YXJ0cyB3aXRoIHJlZ3VsYXIgc2VsZWN0b3IgYXMgYW55IHNlbGVjdG9yIGdlbmVyYWxseVxuICAgICAgICBjb25zdCBfc2VsZWN0b3IkY2hpbGRyZW4gPSBfc2xpY2VkVG9BcnJheShzZWxlY3Rvci5jaGlsZHJlbiwgMSksXG4gICAgICAgICAgICAgIHJlbGF0aXZlUmVndWxhclNlbGVjdG9yID0gX3NlbGVjdG9yJGNoaWxkcmVuWzBdO1xuXG4gICAgICAgIGlmICghcmVsYXRpdmVSZWd1bGFyU2VsZWN0b3IpIHtcbiAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJSZWd1bGFyU2VsZWN0b3IgaXMgbWlzc2luZyBmb3IgOlwiLmNvbmNhdChwc2V1ZG9OYW1lLCBcIigpIHBzZXVkby1jbGFzc1wiKSk7XG4gICAgICAgIH1cblxuICAgICAgICBsZXQgc3BlY2lmaWVkU2VsZWN0b3IgPSAnJztcbiAgICAgICAgbGV0IHJvb3RFbGVtZW50ID0gbnVsbDtcblxuICAgICAgICBpZiAoKF9yZWxhdGl2ZVJlZ3VsYXJTZWxlYyA9IHJlbGF0aXZlUmVndWxhclNlbGVjdG9yLnZhbHVlKSAhPT0gbnVsbCAmJiBfcmVsYXRpdmVSZWd1bGFyU2VsZWMgIT09IHZvaWQgMCAmJiBfcmVsYXRpdmVSZWd1bGFyU2VsZWMuc3RhcnRzV2l0aChORVhUX1NJQkxJTkdfQ09NQklOQVRPUikgfHwgKF9yZWxhdGl2ZVJlZ3VsYXJTZWxlYzIgPSByZWxhdGl2ZVJlZ3VsYXJTZWxlY3Rvci52YWx1ZSkgIT09IG51bGwgJiYgX3JlbGF0aXZlUmVndWxhclNlbGVjMiAhPT0gdm9pZCAwICYmIF9yZWxhdGl2ZVJlZ3VsYXJTZWxlYzIuc3RhcnRzV2l0aChTVUJTRVFVRU5UX1NJQkxJTkdfQ09NQklOQVRPUikpIHtcbiAgICAgICAgICAvKipcbiAgICAgICAgICAgKiBGb3IgbWF0Y2hpbmcgdGhlIGVsZW1lbnQgYnkgXCJlbGVtZW50OmhhcygrIG5leHQtc2libGluZylcIiBhbmQgXCJlbGVtZW50Omhhcyh+IHNpYmxpbmcpXCJcbiAgICAgICAgICAgKiB3ZSBjaGVjayB3aGV0aGVyIHRoZSBlbGVtZW50J3MgcGFyZW50RWxlbWVudCBoYXMgc3BlY2lmaWMgZGlyZWN0IGNoaWxkIGNvbWJpbmF0aW9uLFxuICAgICAgICAgICAqIGUuZy4gJ2gxOmhhcygrIC5zaGFyZSknIC0+IGBoMU5vZGUucGFyZW50RWxlbWVudC5xdWVyeVNlbGVjdG9yQWxsKCc6c2NvcGUgPiBoMSArIC5zaGFyZScpYC5cbiAgICAgICAgICAgKlxuICAgICAgICAgICAqIEBzZWUge0BsaW5rIGh0dHBzOi8vd3d3LnczLm9yZy9UUi9zZWxlY3RvcnMtNC8jcmVsYXRpb25hbH1cbiAgICAgICAgICAgKi9cbiAgICAgICAgICByb290RWxlbWVudCA9IGVsZW1lbnQucGFyZW50RWxlbWVudDtcbiAgICAgICAgICBjb25zdCBlbGVtZW50U2VsZWN0b3JUZXh0ID0gZ2V0RWxlbWVudFNlbGVjdG9yRGVzYyhlbGVtZW50KTtcbiAgICAgICAgICBzcGVjaWZpZWRTZWxlY3RvciA9IFwiXCIuY29uY2F0KFNDT1BFX0NTU19QU0VVRE9fQ0xBU1MpLmNvbmNhdChDSElMRF9DT01CSU5BVE9SKS5jb25jYXQoZWxlbWVudFNlbGVjdG9yVGV4dCkuY29uY2F0KHJlbGF0aXZlUmVndWxhclNlbGVjdG9yLnZhbHVlKTsgLy8gZXNsaW50LWRpc2FibGUtbGluZSBtYXgtbGVuXG4gICAgICAgIH0gZWxzZSBpZiAocmVsYXRpdmVSZWd1bGFyU2VsZWN0b3IudmFsdWUgPT09IEFTVEVSSVNLKSB7XG4gICAgICAgICAgLyoqXG4gICAgICAgICAgICogOnNjb3BlIHNwZWNpZmljYXRpb24gaXMgbmVlZGVkIGZvciBwcm9wZXIgZGVzY2VuZGFudHMgc2VsZWN0aW9uXG4gICAgICAgICAgICogYXMgbmF0aXZlIGVsZW1lbnQucXVlcnlTZWxlY3RvckFsbCgpIGRvZXMgbm90IHNlbGVjdCBleGFjdCBlbGVtZW50IGRlc2NlbmRhbnRzXG4gICAgICAgICAgICogZS5nLiAnYTpoYXMoPiBpbWcpJyAtPiBgYU5vZGUucXVlcnlTZWxlY3RvckFsbCgnOnNjb3BlID4gaW1nJylgLlxuICAgICAgICAgICAqXG4gICAgICAgICAgICogRm9yICdhbnkgc2VsZWN0b3InIGFzIGFyZyBvZiByZWxhdGl2ZSBzaW1wbGljaXR5IHNob3VsZCBiZSBzZXQgZm9yIGFsbCBpbm5lciBlbGVtZW50c1xuICAgICAgICAgICAqIGUuZy4gJ2RpdjppZi1ub3QoKiknIC0+IGBkaXZOb2RlLnF1ZXJ5U2VsZWN0b3JBbGwoJzpzY29wZSAqJylgXG4gICAgICAgICAgICogd2hpY2ggbWVhbnMgZW1wdHkgZGl2IHdpdGggbm8gY2hpbGQgZWxlbWVudC5cbiAgICAgICAgICAgKi9cbiAgICAgICAgICByb290RWxlbWVudCA9IGVsZW1lbnQ7XG4gICAgICAgICAgc3BlY2lmaWVkU2VsZWN0b3IgPSBcIlwiLmNvbmNhdChTQ09QRV9DU1NfUFNFVURPX0NMQVNTKS5jb25jYXQoREVTQ0VOREFOVF9DT01CSU5BVE9SKS5jb25jYXQoQVNURVJJU0spO1xuICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgIC8qKlxuICAgICAgICAgICAqIEFzIGl0IGRlc2NyaWJlZCBhYm92ZSwgaW5uZXIgZWxlbWVudHMgc2hvdWxkIGJlIGZvdW5kIHVzaW5nIGA6c2NvcGVgIHBzZXVkby1jbGFzc1xuICAgICAgICAgICAqIGUuZy4gJ2E6aGFzKD4gaW1nKScgLT4gYGFOb2RlLnF1ZXJ5U2VsZWN0b3JBbGwoJzpzY29wZSA+IGltZycpYFxuICAgICAgICAgICAqIE9SICcuYmxvY2soZGl2ID4gc3BhbiknIC0+IGBibG9ja0NsYXNzTm9kZS5xdWVyeVNlbGVjdG9yQWxsKCc6c2NvcGUgZGl2ID4gc3BhbicpYC5cbiAgICAgICAgICAgKi9cbiAgICAgICAgICBzcGVjaWZpZWRTZWxlY3RvciA9IFwiXCIuY29uY2F0KFNDT1BFX0NTU19QU0VVRE9fQ0xBU1MpLmNvbmNhdChERVNDRU5EQU5UX0NPTUJJTkFUT1IpLmNvbmNhdChyZWxhdGl2ZVJlZ3VsYXJTZWxlY3Rvci52YWx1ZSk7IC8vIGVzbGludC1kaXNhYmxlLWxpbmUgbWF4LWxlblxuXG4gICAgICAgICAgcm9vdEVsZW1lbnQgPSBlbGVtZW50O1xuICAgICAgICB9XG5cbiAgICAgICAgaWYgKCFyb290RWxlbWVudCkge1xuICAgICAgICAgIHRocm93IG5ldyBFcnJvcihcIlNlbGVjdGlvbiBieSA6XCIuY29uY2F0KHBzZXVkb05hbWUsIFwiKCkgcHNldWRvLWNsYXNzIGlzIG5vdCBwb3NzaWJsZVwiKSk7XG4gICAgICAgIH1cblxuICAgICAgICBsZXQgcmVsYXRpdmVFbGVtZW50cztcblxuICAgICAgICB0cnkge1xuICAgICAgICAgIC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBAdHlwZXNjcmlwdC1lc2xpbnQvbm8tdXNlLWJlZm9yZS1kZWZpbmVcbiAgICAgICAgICByZWxhdGl2ZUVsZW1lbnRzID0gZ2V0RWxlbWVudHNGb3JTZWxlY3Rvck5vZGUoc2VsZWN0b3IsIHJvb3RFbGVtZW50LCBzcGVjaWZpZWRTZWxlY3Rvcik7XG4gICAgICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgICAgICBsb2dnZXIuZXJyb3IoZSk7IC8vIGZhaWwgZm9yIGludmFsaWQgc2VsZWN0b3JcblxuICAgICAgICAgIHRocm93IG5ldyBFcnJvcihcIkludmFsaWQgc2VsZWN0b3IgZm9yIDpcIi5jb25jYXQocHNldWRvTmFtZSwgXCIoKSBwc2V1ZG8tY2xhc3M6ICdcIikuY29uY2F0KHJlbGF0aXZlUmVndWxhclNlbGVjdG9yLnZhbHVlLCBcIidcIikpOyAvLyBlc2xpbnQtZGlzYWJsZS1saW5lIG1heC1sZW5cbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiByZWxhdGl2ZUVsZW1lbnRzLmxlbmd0aCA+IDA7XG4gICAgICB9KTtcbiAgICB9O1xuICAgIC8qKlxuICAgICAqIENoZWNrcyB3aGV0aGVyIHRoZSBlbGVtZW50IGlzIGFuIGFueSBlbGVtZW50IHNwZWNpZmllZCBieSBwc2V1ZG8tY2xhc3MgYXJnLlxuICAgICAqIFVzZWQgZm9yIDppcygpIHBzZXVkby1jbGFzcy5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBhcmdzRGF0YSBSZWxhdGl2ZSBwc2V1ZG8tY2xhc3MgaGVscGVycyBhcmdzIGRhdGEuXG4gICAgICovXG5cblxuICAgIGNvbnN0IGlzQW55RWxlbWVudEJ5U2VsZWN0b3JMaXN0ID0gYXJnc0RhdGEgPT4ge1xuICAgICAgY29uc3QgZWxlbWVudCA9IGFyZ3NEYXRhLmVsZW1lbnQsXG4gICAgICAgICAgICByZWxhdGl2ZVNlbGVjdG9yTGlzdCA9IGFyZ3NEYXRhLnJlbGF0aXZlU2VsZWN0b3JMaXN0LFxuICAgICAgICAgICAgcHNldWRvTmFtZSA9IGFyZ3NEYXRhLnBzZXVkb05hbWU7XG4gICAgICByZXR1cm4gcmVsYXRpdmVTZWxlY3Rvckxpc3QuY2hpbGRyZW4gLy8gQXJyYXkuc29tZSgpIGlzIHVzZWQgaGVyZSBhcyBhbnkgc2VsZWN0b3IgZnJvbSBzZWxlY3RvciBsaXN0IHNob3VsZCBleGlzdCBvbiBwYWdlXG4gICAgICAuc29tZShzZWxlY3RvciA9PiB7XG4gICAgICAgIC8vIHNlbGVjdG9yTGlzdC5jaGlsZHJlbiBhbHdheXMgc3RhcnRzIHdpdGggcmVndWxhciBzZWxlY3RvclxuICAgICAgICBjb25zdCBfc2VsZWN0b3IkY2hpbGRyZW4yID0gX3NsaWNlZFRvQXJyYXkoc2VsZWN0b3IuY2hpbGRyZW4sIDEpLFxuICAgICAgICAgICAgICByZWxhdGl2ZVJlZ3VsYXJTZWxlY3RvciA9IF9zZWxlY3RvciRjaGlsZHJlbjJbMF07XG5cbiAgICAgICAgaWYgKCFyZWxhdGl2ZVJlZ3VsYXJTZWxlY3Rvcikge1xuICAgICAgICAgIHRocm93IG5ldyBFcnJvcihcIlJlZ3VsYXJTZWxlY3RvciBpcyBtaXNzaW5nIGZvciA6XCIuY29uY2F0KHBzZXVkb05hbWUsIFwiKCkgcHNldWRvLWNsYXNzXCIpKTtcbiAgICAgICAgfVxuICAgICAgICAvKipcbiAgICAgICAgICogRm9yIGNoZWNraW5nIHRoZSBlbGVtZW50IGJ5ICdkaXY6aXMoLmJhbm5lciknXG4gICAgICAgICAqIHdlIGNoZWNrIHdoZXRoZXIgdGhlIGVsZW1lbnQncyBwYXJlbnRFbGVtZW50IGhhcyBhbnkgc3BlY2lmaWMgZGlyZWN0IGNoaWxkLlxuICAgICAgICAgKi9cblxuXG4gICAgICAgIGNvbnN0IHJvb3RFbGVtZW50ID0gZWxlbWVudC5wYXJlbnRFbGVtZW50O1xuXG4gICAgICAgIGlmICghcm9vdEVsZW1lbnQpIHtcbiAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJTZWxlY3Rpb24gYnkgOlwiLmNvbmNhdChwc2V1ZG9OYW1lLCBcIigpIHBzZXVkby1jbGFzcyBpcyBub3QgcG9zc2libGVcIikpO1xuICAgICAgICB9XG4gICAgICAgIC8qKlxuICAgICAgICAgKiBTbyB3ZSBjYWxjdWxhdGUgdGhlIGVsZW1lbnQgXCJkZXNjcmlwdGlvblwiIGJ5IGl0J3MgdGFnbmFtZSBhbmQgYXR0cmlidXRlcyBmb3IgdGFyZ2V0aW5nXG4gICAgICAgICAqIGFuZCB1c2UgaXQgdG8gc3BlY2lmeSB0aGUgc2VsZWN0aW9uXG4gICAgICAgICAqIGUuZy4gYGRpdjppcyguYmFubmVyKWAgLS0+IGBkaXZOb2RlLnBhcmVudEVsZW1lbnQucXVlcnlTZWxlY3RvckFsbCgnOnNjb3BlID4gLmJhbm5lcicpYC5cbiAgICAgICAgICovXG5cblxuICAgICAgICBjb25zdCBzcGVjaWZpZWRTZWxlY3RvciA9IFwiXCIuY29uY2F0KFNDT1BFX0NTU19QU0VVRE9fQ0xBU1MpLmNvbmNhdChDSElMRF9DT01CSU5BVE9SKS5jb25jYXQocmVsYXRpdmVSZWd1bGFyU2VsZWN0b3IudmFsdWUpOyAvLyBlc2xpbnQtZGlzYWJsZS1saW5lIG1heC1sZW5cblxuICAgICAgICBsZXQgYW55RWxlbWVudHM7XG5cbiAgICAgICAgdHJ5IHtcbiAgICAgICAgICAvLyBlc2xpbnQtZGlzYWJsZS1uZXh0LWxpbmUgQHR5cGVzY3JpcHQtZXNsaW50L25vLXVzZS1iZWZvcmUtZGVmaW5lXG4gICAgICAgICAgYW55RWxlbWVudHMgPSBnZXRFbGVtZW50c0ZvclNlbGVjdG9yTm9kZShzZWxlY3Rvciwgcm9vdEVsZW1lbnQsIHNwZWNpZmllZFNlbGVjdG9yKTtcbiAgICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICAgIC8vIGRvIG5vdCBmYWlsIG9uIGludmFsaWQgc2VsZWN0b3JzIGZvciA6aXMoKVxuICAgICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgICAgfSAvLyBUT0RPOiBmaWd1cmUgb3V0IGhvdyB0byBoYW5kbGUgY29tcGxleCBzZWxlY3RvcnMgd2l0aCBleHRlbmRlZCBwc2V1ZG8tY2xhc3Nlc1xuICAgICAgICAvLyAoY2hlY2sgcmVhZG1lIC0gZXh0ZW5kZWQtY3NzLWlzLWxpbWl0YXRpb25zKVxuICAgICAgICAvLyBiZWNhdXNlIGBlbGVtZW50YCBhbmQgYGFueUVsZW1lbnRzYCBtYXkgYmUgZnJvbSBkaWZmZXJlbnQgRE9NIGxldmVsc1xuXG5cbiAgICAgICAgcmV0dXJuIGFueUVsZW1lbnRzLmluY2x1ZGVzKGVsZW1lbnQpO1xuICAgICAgfSk7XG4gICAgfTtcbiAgICAvKipcbiAgICAgKiBDaGVja3Mgd2hldGhlciB0aGUgZWxlbWVudCBpcyBub3QgYW4gZWxlbWVudCBzcGVjaWZpZWQgYnkgcHNldWRvLWNsYXNzIGFyZy5cbiAgICAgKiBVc2VkIGZvciA6bm90KCkgcHNldWRvLWNsYXNzLlxuICAgICAqXG4gICAgICogQHBhcmFtIGFyZ3NEYXRhIFJlbGF0aXZlIHBzZXVkby1jbGFzcyBoZWxwZXJzIGFyZ3MgZGF0YS5cbiAgICAgKi9cblxuXG4gICAgY29uc3Qgbm90RWxlbWVudEJ5U2VsZWN0b3JMaXN0ID0gYXJnc0RhdGEgPT4ge1xuICAgICAgY29uc3QgZWxlbWVudCA9IGFyZ3NEYXRhLmVsZW1lbnQsXG4gICAgICAgICAgICByZWxhdGl2ZVNlbGVjdG9yTGlzdCA9IGFyZ3NEYXRhLnJlbGF0aXZlU2VsZWN0b3JMaXN0LFxuICAgICAgICAgICAgcHNldWRvTmFtZSA9IGFyZ3NEYXRhLnBzZXVkb05hbWU7XG4gICAgICByZXR1cm4gcmVsYXRpdmVTZWxlY3Rvckxpc3QuY2hpbGRyZW4gLy8gQXJyYXkuZXZlcnkoKSBpcyB1c2VkIGhlcmUgYXMgZWxlbWVudCBzaG91bGQgbm90IGJlIHNlbGVjdGVkIGJ5IGFueSBzZWxlY3RvciBmcm9tIHNlbGVjdG9yIGxpc3RcbiAgICAgIC5ldmVyeShzZWxlY3RvciA9PiB7XG4gICAgICAgIC8vIHNlbGVjdG9yTGlzdC5jaGlsZHJlbiBhbHdheXMgc3RhcnRzIHdpdGggcmVndWxhciBzZWxlY3RvclxuICAgICAgICBjb25zdCBfc2VsZWN0b3IkY2hpbGRyZW4zID0gX3NsaWNlZFRvQXJyYXkoc2VsZWN0b3IuY2hpbGRyZW4sIDEpLFxuICAgICAgICAgICAgICByZWxhdGl2ZVJlZ3VsYXJTZWxlY3RvciA9IF9zZWxlY3RvciRjaGlsZHJlbjNbMF07XG5cbiAgICAgICAgaWYgKCFyZWxhdGl2ZVJlZ3VsYXJTZWxlY3Rvcikge1xuICAgICAgICAgIHRocm93IG5ldyBFcnJvcihcIlJlZ3VsYXJTZWxlY3RvciBpcyBtaXNzaW5nIGZvciA6XCIuY29uY2F0KHBzZXVkb05hbWUsIFwiKCkgcHNldWRvLWNsYXNzXCIpKTtcbiAgICAgICAgfVxuICAgICAgICAvKipcbiAgICAgICAgICogRm9yIGNoZWNraW5nIHRoZSBlbGVtZW50IGJ5ICdkaXY6bm90KFtkYXRhPVwiY29udGVudFwiXSlcbiAgICAgICAgICogd2UgY2hlY2sgd2hldGhlciB0aGUgZWxlbWVudCdzIHBhcmVudEVsZW1lbnQgaGFzIGFueSBzcGVjaWZpYyBkaXJlY3QgY2hpbGQuXG4gICAgICAgICAqL1xuXG5cbiAgICAgICAgY29uc3Qgcm9vdEVsZW1lbnQgPSBlbGVtZW50LnBhcmVudEVsZW1lbnQ7XG5cbiAgICAgICAgaWYgKCFyb290RWxlbWVudCkge1xuICAgICAgICAgIHRocm93IG5ldyBFcnJvcihcIlNlbGVjdGlvbiBieSA6XCIuY29uY2F0KHBzZXVkb05hbWUsIFwiKCkgcHNldWRvLWNsYXNzIGlzIG5vdCBwb3NzaWJsZVwiKSk7XG4gICAgICAgIH1cbiAgICAgICAgLyoqXG4gICAgICAgICAqIFNvIHdlIGNhbGN1bGF0ZSB0aGUgZWxlbWVudCBcImRlc2NyaXB0aW9uXCIgYnkgaXQncyB0YWduYW1lIGFuZCBhdHRyaWJ1dGVzIGZvciB0YXJnZXRpbmdcbiAgICAgICAgICogYW5kIHVzZSBpdCB0byBzcGVjaWZ5IHRoZSBzZWxlY3Rpb25cbiAgICAgICAgICogZS5nLiBgZGl2Om5vdCguYmFubmVyKWAgLS0+IGBkaXZOb2RlLnBhcmVudEVsZW1lbnQucXVlcnlTZWxlY3RvckFsbCgnOnNjb3BlID4gLmJhbm5lcicpYC5cbiAgICAgICAgICovXG5cblxuICAgICAgICBjb25zdCBzcGVjaWZpZWRTZWxlY3RvciA9IFwiXCIuY29uY2F0KFNDT1BFX0NTU19QU0VVRE9fQ0xBU1MpLmNvbmNhdChDSElMRF9DT01CSU5BVE9SKS5jb25jYXQocmVsYXRpdmVSZWd1bGFyU2VsZWN0b3IudmFsdWUpOyAvLyBlc2xpbnQtZGlzYWJsZS1saW5lIG1heC1sZW5cblxuICAgICAgICBsZXQgYW55RWxlbWVudHM7XG5cbiAgICAgICAgdHJ5IHtcbiAgICAgICAgICAvLyBlc2xpbnQtZGlzYWJsZS1uZXh0LWxpbmUgQHR5cGVzY3JpcHQtZXNsaW50L25vLXVzZS1iZWZvcmUtZGVmaW5lXG4gICAgICAgICAgYW55RWxlbWVudHMgPSBnZXRFbGVtZW50c0ZvclNlbGVjdG9yTm9kZShzZWxlY3Rvciwgcm9vdEVsZW1lbnQsIHNwZWNpZmllZFNlbGVjdG9yKTtcbiAgICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICAgIC8vIGZhaWwgb24gaW52YWxpZCBzZWxlY3RvcnMgZm9yIDpub3QoKVxuICAgICAgICAgIGxvZ2dlci5lcnJvcihlKTtcbiAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJJbnZhbGlkIHNlbGVjdG9yIGZvciA6XCIuY29uY2F0KHBzZXVkb05hbWUsIFwiKCkgcHNldWRvLWNsYXNzOiAnXCIpLmNvbmNhdChyZWxhdGl2ZVJlZ3VsYXJTZWxlY3Rvci52YWx1ZSwgXCInXCIpKTsgLy8gZXNsaW50LWRpc2FibGUtbGluZSBtYXgtbGVuXG4gICAgICAgIH0gLy8gVE9ETzogZmlndXJlIG91dCBob3cgdG8gaGFuZGxlIHVwLWxvb2tpbmcgcHNldWRvLWNsYXNzZXMgaW5zaWRlIDpub3QoKVxuICAgICAgICAvLyAoY2hlY2sgcmVhZG1lIC0gZXh0ZW5kZWQtY3NzLW5vdC1saW1pdGF0aW9ucylcbiAgICAgICAgLy8gYmVjYXVzZSBgZWxlbWVudGAgYW5kIGBhbnlFbGVtZW50c2AgbWF5IGJlIGZyb20gZGlmZmVyZW50IERPTSBsZXZlbHNcblxuXG4gICAgICAgIHJldHVybiAhYW55RWxlbWVudHMuaW5jbHVkZXMoZWxlbWVudCk7XG4gICAgICB9KTtcbiAgICB9O1xuICAgIC8qKlxuICAgICAqIFNlbGVjdHMgZG9tIGVsZW1lbnRzIGJ5IHZhbHVlIG9mIFJlZ3VsYXJTZWxlY3Rvci5cbiAgICAgKlxuICAgICAqIEBwYXJhbSByZWd1bGFyU2VsZWN0b3JOb2RlIFJlZ3VsYXJTZWxlY3RvciBub2RlLlxuICAgICAqIEBwYXJhbSByb290IFJvb3QgRE9NIGVsZW1lbnQuXG4gICAgICogQHBhcmFtIHNwZWNpZmllZFNlbGVjdG9yIEBzZWUge0BsaW5rIFNwZWNpZmllZFNlbGVjdG9yfS5cbiAgICAgKlxuICAgICAqIEB0aHJvd3MgQW4gZXJyb3IgaWYgUmVndWxhclNlbGVjdG9yIGhhcyBubyB2YWx1ZVxuICAgICAqIG9yIFJlZ3VsYXJTZWxlY3Rvci52YWx1ZSBpcyBpbnZhbGlkIHNlbGVjdG9yLlxuICAgICAqL1xuXG5cbiAgICBjb25zdCBnZXRCeVJlZ3VsYXJTZWxlY3RvciA9IChyZWd1bGFyU2VsZWN0b3JOb2RlLCByb290LCBzcGVjaWZpZWRTZWxlY3RvcikgPT4ge1xuICAgICAgaWYgKCFyZWd1bGFyU2VsZWN0b3JOb2RlLnZhbHVlKSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcignUmVndWxhclNlbGVjdG9yIHZhbHVlIHNob3VsZCBiZSBzcGVjaWZpZWQnKTtcbiAgICAgIH1cblxuICAgICAgY29uc3Qgc2VsZWN0b3JUZXh0ID0gc3BlY2lmaWVkU2VsZWN0b3IgPyBzcGVjaWZpZWRTZWxlY3RvciA6IHJlZ3VsYXJTZWxlY3Rvck5vZGUudmFsdWU7XG4gICAgICBsZXQgc2VsZWN0ZWRFbGVtZW50cyA9IFtdO1xuXG4gICAgICB0cnkge1xuICAgICAgICBzZWxlY3RlZEVsZW1lbnRzID0gQXJyYXkuZnJvbShyb290LnF1ZXJ5U2VsZWN0b3JBbGwoc2VsZWN0b3JUZXh0KSk7XG4gICAgICB9IGNhdGNoIChlKSB7XG4gICAgICAgIC8vIGVzbGludC1kaXNhYmxlLWxpbmUgQHR5cGVzY3JpcHQtZXNsaW50L25vLWV4cGxpY2l0LWFueVxuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJFcnJvcjogdW5hYmxlIHRvIHNlbGVjdCBieSAnXCIuY29uY2F0KHNlbGVjdG9yVGV4dCwgXCInIFxcdTIwMTQgXCIpLmNvbmNhdChlLm1lc3NhZ2UpKTtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIHNlbGVjdGVkRWxlbWVudHM7XG4gICAgfTtcbiAgICAvKipcbiAgICAgKiBSZXR1cm5zIGxpc3Qgb2YgZG9tIGVsZW1lbnRzIGZpbHRlcmVkIG9yIHNlbGVjdGVkIGJ5IEV4dGVuZGVkU2VsZWN0b3Igbm9kZS5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBkb21FbGVtZW50cyBBcnJheSBvZiBET00gZWxlbWVudHMuXG4gICAgICogQHBhcmFtIGV4dGVuZGVkU2VsZWN0b3JOb2RlIEV4dGVuZGVkU2VsZWN0b3Igbm9kZS5cbiAgICAgKlxuICAgICAqIEB0aHJvd3MgQW4gZXJyb3Igb24gdW5rbm93biBwc2V1ZG8tY2xhc3MsXG4gICAgICogYWJzZW50IG9yIGludmFsaWQgYXJnIG9mIGV4dGVuZGVkIHBzZXVkby1jbGFzcywgZXRjLlxuICAgICAqIEByZXR1cm5zIEFycmF5IG9mIERPTSBlbGVtZW50cy5cbiAgICAgKi9cblxuICAgIGNvbnN0IGdldEJ5RXh0ZW5kZWRTZWxlY3RvciA9IChkb21FbGVtZW50cywgZXh0ZW5kZWRTZWxlY3Rvck5vZGUpID0+IHtcbiAgICAgIGxldCBmb3VuZEVsZW1lbnRzID0gW107XG4gICAgICBjb25zdCBwc2V1ZG9OYW1lID0gZXh0ZW5kZWRTZWxlY3Rvck5vZGUuY2hpbGRyZW5bMF0ubmFtZTtcblxuICAgICAgaWYgKCFwc2V1ZG9OYW1lKSB7XG4gICAgICAgIC8vIGV4dGVuZGVkIHBzZXVkby1jbGFzc2VzIHNob3VsZCBoYXZlIGEgbmFtZVxuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoJ0V4dGVuZGVkIHBzZXVkby1jbGFzcyBzaG91bGQgaGF2ZSBhIG5hbWUnKTtcbiAgICAgIH1cblxuICAgICAgaWYgKEFCU09MVVRFX1BTRVVET19DTEFTU0VTLmluY2x1ZGVzKHBzZXVkb05hbWUpKSB7XG4gICAgICAgIGNvbnN0IGFic29sdXRlUHNldWRvQXJnID0gZXh0ZW5kZWRTZWxlY3Rvck5vZGUuY2hpbGRyZW5bMF0udmFsdWU7XG5cbiAgICAgICAgaWYgKCFhYnNvbHV0ZVBzZXVkb0FyZykge1xuICAgICAgICAgIC8vIGFic29sdXRlIGV4dGVuZGVkIHBzZXVkby1jbGFzc2VzIHNob3VsZCBoYXZlIGFuIGFyZ3VtZW50XG4gICAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiTWlzc2luZyBhcmcgZm9yIDpcIi5jb25jYXQocHNldWRvTmFtZSwgXCIoKSBwc2V1ZG8tY2xhc3NcIikpO1xuICAgICAgICB9XG5cbiAgICAgICAgaWYgKHBzZXVkb05hbWUgPT09IE5USF9BTkNFU1RPUl9QU0VVRE9fQ0xBU1NfTUFSS0VSKSB7XG4gICAgICAgICAgLy8gOm50aC1hbmNlc3RvcigpXG4gICAgICAgICAgZm91bmRFbGVtZW50cyA9IGZpbmRCeUFic29sdXRlUHNldWRvUHNldWRvLm50aEFuY2VzdG9yKGRvbUVsZW1lbnRzLCBhYnNvbHV0ZVBzZXVkb0FyZywgcHNldWRvTmFtZSk7XG4gICAgICAgIH0gZWxzZSBpZiAocHNldWRvTmFtZSA9PT0gWFBBVEhfUFNFVURPX0NMQVNTX01BUktFUikge1xuICAgICAgICAgIC8vIDp4cGF0aCgpXG4gICAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgIGRvY3VtZW50LmNyZWF0ZUV4cHJlc3Npb24oYWJzb2x1dGVQc2V1ZG9BcmcsIG51bGwpO1xuICAgICAgICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgICAgICAgIHRocm93IG5ldyBFcnJvcihcIkludmFsaWQgYXJndW1lbnQgb2YgOlwiLmNvbmNhdChwc2V1ZG9OYW1lLCBcIigpIHBzZXVkby1jbGFzczogJ1wiKS5jb25jYXQoYWJzb2x1dGVQc2V1ZG9BcmcsIFwiJ1wiKSk7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgZm91bmRFbGVtZW50cyA9IGZpbmRCeUFic29sdXRlUHNldWRvUHNldWRvLnhwYXRoKGRvbUVsZW1lbnRzLCBhYnNvbHV0ZVBzZXVkb0FyZyk7XG4gICAgICAgIH0gZWxzZSBpZiAocHNldWRvTmFtZSA9PT0gVVBXQVJEX1BTRVVET19DTEFTU19NQVJLRVIpIHtcbiAgICAgICAgICAvLyA6dXB3YXJkKClcbiAgICAgICAgICBpZiAoTnVtYmVyLmlzTmFOKE51bWJlcihhYnNvbHV0ZVBzZXVkb0FyZykpKSB7XG4gICAgICAgICAgICAvLyBzbyBhcmcgaXMgc2VsZWN0b3IsIG5vdCBhIG51bWJlclxuICAgICAgICAgICAgZm91bmRFbGVtZW50cyA9IGZpbmRCeUFic29sdXRlUHNldWRvUHNldWRvLnVwd2FyZChkb21FbGVtZW50cywgYWJzb2x1dGVQc2V1ZG9BcmcpO1xuICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICBmb3VuZEVsZW1lbnRzID0gZmluZEJ5QWJzb2x1dGVQc2V1ZG9Qc2V1ZG8ubnRoQW5jZXN0b3IoZG9tRWxlbWVudHMsIGFic29sdXRlUHNldWRvQXJnLCBwc2V1ZG9OYW1lKTtcbiAgICAgICAgICB9XG4gICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgLy8gYWxsIG90aGVyIGFic29sdXRlIGV4dGVuZGVkIHBzZXVkby1jbGFzc2VzXG4gICAgICAgICAgLy8gZS5nLiBjb250YWlucywgbWF0Y2hlcy1hdHRyLCBldGMuXG4gICAgICAgICAgZm91bmRFbGVtZW50cyA9IGRvbUVsZW1lbnRzLmZpbHRlcihlbGVtZW50ID0+IHtcbiAgICAgICAgICAgIHJldHVybiBpc01hdGNoZWRCeUFic29sdXRlUHNldWRvKGVsZW1lbnQsIHBzZXVkb05hbWUsIGFic29sdXRlUHNldWRvQXJnKTtcbiAgICAgICAgICB9KTtcbiAgICAgICAgfVxuICAgICAgfSBlbHNlIGlmIChSRUxBVElWRV9QU0VVRE9fQ0xBU1NFUy5pbmNsdWRlcyhwc2V1ZG9OYW1lKSkge1xuICAgICAgICBjb25zdCByZWxhdGl2ZVNlbGVjdG9yTm9kZXMgPSBleHRlbmRlZFNlbGVjdG9yTm9kZS5jaGlsZHJlblswXS5jaGlsZHJlbjtcblxuICAgICAgICBpZiAocmVsYXRpdmVTZWxlY3Rvck5vZGVzLmxlbmd0aCA9PT0gMCkge1xuICAgICAgICAgIC8vIGV4dGVuZGVkIHJlbGF0aXZlIHBzZXVkby1jbGFzc2VzIHNob3VsZCBoYXZlIGFuIGFyZ3VtZW50IGFzIHdlbGxcbiAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJNaXNzaW5nIGFyZyBmb3IgOlwiLmNvbmNhdChwc2V1ZG9OYW1lLCBcIigpIHBzZXVkby1jbGFzc1wiKSk7XG4gICAgICAgIH1cblxuICAgICAgICBjb25zdCBfcmVsYXRpdmVTZWxlY3Rvck5vZGUgPSBfc2xpY2VkVG9BcnJheShyZWxhdGl2ZVNlbGVjdG9yTm9kZXMsIDEpLFxuICAgICAgICAgICAgICByZWxhdGl2ZVNlbGVjdG9yTGlzdCA9IF9yZWxhdGl2ZVNlbGVjdG9yTm9kZVswXTtcblxuICAgICAgICBsZXQgcmVsYXRpdmVQcmVkaWNhdGU7XG5cbiAgICAgICAgc3dpdGNoIChwc2V1ZG9OYW1lKSB7XG4gICAgICAgICAgY2FzZSBIQVNfUFNFVURPX0NMQVNTX01BUktFUjpcbiAgICAgICAgICBjYXNlIElGX1BTRVVET19DTEFTU19NQVJLRVI6XG4gICAgICAgICAgY2FzZSBBQlBfSEFTX1BTRVVET19DTEFTU19NQVJLRVI6XG4gICAgICAgICAgICByZWxhdGl2ZVByZWRpY2F0ZSA9IGVsZW1lbnQgPT4gaGFzUmVsYXRpdmVzQnlTZWxlY3Rvckxpc3Qoe1xuICAgICAgICAgICAgICBlbGVtZW50LFxuICAgICAgICAgICAgICByZWxhdGl2ZVNlbGVjdG9yTGlzdCxcbiAgICAgICAgICAgICAgcHNldWRvTmFtZVxuICAgICAgICAgICAgfSk7XG5cbiAgICAgICAgICAgIGJyZWFrO1xuXG4gICAgICAgICAgY2FzZSBJRl9OT1RfUFNFVURPX0NMQVNTX01BUktFUjpcbiAgICAgICAgICAgIHJlbGF0aXZlUHJlZGljYXRlID0gZWxlbWVudCA9PiAhaGFzUmVsYXRpdmVzQnlTZWxlY3Rvckxpc3Qoe1xuICAgICAgICAgICAgICBlbGVtZW50LFxuICAgICAgICAgICAgICByZWxhdGl2ZVNlbGVjdG9yTGlzdCxcbiAgICAgICAgICAgICAgcHNldWRvTmFtZVxuICAgICAgICAgICAgfSk7XG5cbiAgICAgICAgICAgIGJyZWFrO1xuXG4gICAgICAgICAgY2FzZSBJU19QU0VVRE9fQ0xBU1NfTUFSS0VSOlxuICAgICAgICAgICAgcmVsYXRpdmVQcmVkaWNhdGUgPSBlbGVtZW50ID0+IGlzQW55RWxlbWVudEJ5U2VsZWN0b3JMaXN0KHtcbiAgICAgICAgICAgICAgZWxlbWVudCxcbiAgICAgICAgICAgICAgcmVsYXRpdmVTZWxlY3Rvckxpc3QsXG4gICAgICAgICAgICAgIHBzZXVkb05hbWVcbiAgICAgICAgICAgIH0pO1xuXG4gICAgICAgICAgICBicmVhaztcblxuICAgICAgICAgIGNhc2UgTk9UX1BTRVVET19DTEFTU19NQVJLRVI6XG4gICAgICAgICAgICByZWxhdGl2ZVByZWRpY2F0ZSA9IGVsZW1lbnQgPT4gbm90RWxlbWVudEJ5U2VsZWN0b3JMaXN0KHtcbiAgICAgICAgICAgICAgZWxlbWVudCxcbiAgICAgICAgICAgICAgcmVsYXRpdmVTZWxlY3Rvckxpc3QsXG4gICAgICAgICAgICAgIHBzZXVkb05hbWVcbiAgICAgICAgICAgIH0pO1xuXG4gICAgICAgICAgICBicmVhaztcblxuICAgICAgICAgIGRlZmF1bHQ6XG4gICAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJVbmtub3duIHJlbGF0aXZlIHBzZXVkby1jbGFzczogJ1wiLmNvbmNhdChwc2V1ZG9OYW1lLCBcIidcIikpO1xuICAgICAgICB9XG5cbiAgICAgICAgZm91bmRFbGVtZW50cyA9IGRvbUVsZW1lbnRzLmZpbHRlcihyZWxhdGl2ZVByZWRpY2F0ZSk7XG4gICAgICB9IGVsc2Uge1xuICAgICAgICAvLyBleHRyYSBjaGVjayBpcyBwYXJzZXIgbWlzc2VkIHNvbWV0aGluZ1xuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJVbmtub3duIGV4dGVuZGVkIHBzZXVkby1jbGFzczogJ1wiLmNvbmNhdChwc2V1ZG9OYW1lLCBcIidcIikpO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gZm91bmRFbGVtZW50cztcbiAgICB9O1xuICAgIC8qKlxuICAgICAqIFJldHVybnMgbGlzdCBvZiBkb20gZWxlbWVudHMgd2hpY2ggaXMgc2VsZWN0ZWQgYnkgUmVndWxhclNlbGVjdG9yIHZhbHVlLlxuICAgICAqXG4gICAgICogQHBhcmFtIGRvbUVsZW1lbnRzIEFycmF5IG9mIERPTSBlbGVtZW50cy5cbiAgICAgKiBAcGFyYW0gcmVndWxhclNlbGVjdG9yTm9kZSBSZWd1bGFyU2VsZWN0b3Igbm9kZS5cbiAgICAgKlxuICAgICAqIEB0aHJvd3MgQW4gZXJyb3IgaWYgUmVndWxhclNlbGVjdG9yIGhhcyBub3QgdmFsdWUuXG4gICAgICogQHJldHVybnMgQXJyYXkgb2YgRE9NIGVsZW1lbnRzLlxuICAgICAqL1xuXG4gICAgY29uc3QgZ2V0QnlGb2xsb3dpbmdSZWd1bGFyU2VsZWN0b3IgPSAoZG9tRWxlbWVudHMsIHJlZ3VsYXJTZWxlY3Rvck5vZGUpID0+IHtcbiAgICAgIC8vIGFycmF5IG9mIGFycmF5cyBiZWNhdXNlIG9mIEFycmF5Lm1hcCgpIGxhdGVyXG4gICAgICBsZXQgZm91bmRFbGVtZW50cyA9IFtdO1xuICAgICAgY29uc3QgdmFsdWUgPSByZWd1bGFyU2VsZWN0b3JOb2RlLnZhbHVlO1xuXG4gICAgICBpZiAoIXZhbHVlKSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcignUmVndWxhclNlbGVjdG9yIHNob3VsZCBoYXZlIGEgdmFsdWUuJyk7XG4gICAgICB9XG5cbiAgICAgIGlmICh2YWx1ZS5zdGFydHNXaXRoKENISUxEX0NPTUJJTkFUT1IpKSB7XG4gICAgICAgIC8vIGUuZy4gZGl2Omhhcyg+IGltZykgPiAuYmFubmVyXG4gICAgICAgIGZvdW5kRWxlbWVudHMgPSBkb21FbGVtZW50cy5tYXAocm9vdCA9PiB7XG4gICAgICAgICAgY29uc3Qgc3BlY2lmaWVkU2VsZWN0b3IgPSBcIlwiLmNvbmNhdChTQ09QRV9DU1NfUFNFVURPX0NMQVNTKS5jb25jYXQodmFsdWUpO1xuICAgICAgICAgIHJldHVybiBnZXRCeVJlZ3VsYXJTZWxlY3RvcihyZWd1bGFyU2VsZWN0b3JOb2RlLCByb290LCBzcGVjaWZpZWRTZWxlY3Rvcik7XG4gICAgICAgIH0pO1xuICAgICAgfSBlbHNlIGlmICh2YWx1ZS5zdGFydHNXaXRoKE5FWFRfU0lCTElOR19DT01CSU5BVE9SKSB8fCB2YWx1ZS5zdGFydHNXaXRoKFNVQlNFUVVFTlRfU0lCTElOR19DT01CSU5BVE9SKSkge1xuICAgICAgICAvLyBlLmcuIGRpdjpoYXMoPiBpbWcpICsgLmJhbm5lclxuICAgICAgICAvLyBvciAgIGRpdjpoYXMoPiBpbWcpIH4gLmJhbm5lclxuICAgICAgICBmb3VuZEVsZW1lbnRzID0gZG9tRWxlbWVudHMubWFwKGVsZW1lbnQgPT4ge1xuICAgICAgICAgIGNvbnN0IHJvb3RFbGVtZW50ID0gZWxlbWVudC5wYXJlbnRFbGVtZW50O1xuXG4gICAgICAgICAgaWYgKCFyb290RWxlbWVudCkge1xuICAgICAgICAgICAgLy8gZG8gbm90IHRocm93IGVycm9yIGlmIHRoZXJlIGluIG5vIHBhcmVudCBmb3IgZWxlbWVudFxuICAgICAgICAgICAgLy8gZS5nLiAnKjpjb250YWlucyh0ZXh0KScgc2VsZWN0cyBgaHRtbGAgd2hpY2ggaGFzIG5vIHBhcmVudEVsZW1lbnRcbiAgICAgICAgICAgIHJldHVybiBbXTtcbiAgICAgICAgICB9XG5cbiAgICAgICAgICBjb25zdCBlbGVtZW50U2VsZWN0b3JUZXh0ID0gZ2V0RWxlbWVudFNlbGVjdG9yRGVzYyhlbGVtZW50KTtcbiAgICAgICAgICBjb25zdCBzcGVjaWZpZWRTZWxlY3RvciA9IFwiXCIuY29uY2F0KFNDT1BFX0NTU19QU0VVRE9fQ0xBU1MpLmNvbmNhdChDSElMRF9DT01CSU5BVE9SKS5jb25jYXQoZWxlbWVudFNlbGVjdG9yVGV4dCkuY29uY2F0KHZhbHVlKTsgLy8gZXNsaW50LWRpc2FibGUtbGluZSBtYXgtbGVuXG5cbiAgICAgICAgICBjb25zdCBzZWxlY3RlZCA9IGdldEJ5UmVndWxhclNlbGVjdG9yKHJlZ3VsYXJTZWxlY3Rvck5vZGUsIHJvb3RFbGVtZW50LCBzcGVjaWZpZWRTZWxlY3Rvcik7XG4gICAgICAgICAgcmV0dXJuIHNlbGVjdGVkO1xuICAgICAgICB9KTtcbiAgICAgIH0gZWxzZSB7XG4gICAgICAgIC8vIHNwYWNlLXNlcGFyYXRlZCByZWd1bGFyIHNlbGVjdG9yIGFmdGVyIGV4dGVuZGVkIG9uZVxuICAgICAgICAvLyBlLmcuIGRpdjpoYXMoPiBpbWcpIC5iYW5uZXJcbiAgICAgICAgZm91bmRFbGVtZW50cyA9IGRvbUVsZW1lbnRzLm1hcChyb290ID0+IHtcbiAgICAgICAgICBjb25zdCBzcGVjaWZpZWRTZWxlY3RvciA9IFwiXCIuY29uY2F0KFNDT1BFX0NTU19QU0VVRE9fQ0xBU1MpLmNvbmNhdChERVNDRU5EQU5UX0NPTUJJTkFUT1IpLmNvbmNhdChyZWd1bGFyU2VsZWN0b3JOb2RlLnZhbHVlKTsgLy8gZXNsaW50LWRpc2FibGUtbGluZSBtYXgtbGVuXG5cbiAgICAgICAgICByZXR1cm4gZ2V0QnlSZWd1bGFyU2VsZWN0b3IocmVndWxhclNlbGVjdG9yTm9kZSwgcm9vdCwgc3BlY2lmaWVkU2VsZWN0b3IpO1xuICAgICAgICB9KTtcbiAgICAgIH0gLy8gZm91bmRFbGVtZW50cyBzaG91bGQgYmUgZmxhdHRlbmVkXG4gICAgICAvLyBhcyBnZXRCeVJlZ3VsYXJTZWxlY3RvcigpIHJldHVybnMgZWxlbWVudHMgYXJyYXksIGFuZCBBcnJheS5tYXAoKSBjb2xsZWN0cyB0aGVtIHRvIGFycmF5XG5cblxuICAgICAgcmV0dXJuIGZsYXR0ZW4oZm91bmRFbGVtZW50cyk7XG4gICAgfTtcbiAgICAvKipcbiAgICAgKiBHZXRzIGVsZW1lbnRzIG5vZGVzIGZvciBTZWxlY3RvciBub2RlLlxuICAgICAqIEFzIGZhciBhcyBhbnkgc2VsZWN0b3IgYWx3YXlzIHN0YXJ0cyB3aXRoIHJlZ3VsYXIgcGFydCxcbiAgICAgKiBpdCBzZWxlY3RzIGJ5IFJlZ3VsYXJTZWxlY3RvciBmaXJzdCBhbmQgY2hlY2tzIGZvdW5kIGVsZW1lbnRzIGxhdGVyLlxuICAgICAqXG4gICAgICogUmVsYXRpdmUgcHNldWRvLWNsYXNzZXMgaGFzIGl0J3Mgb3duIHN1YnRyZWUgc28gZ2V0RWxlbWVudHNGb3JTZWxlY3Rvck5vZGUgaXMgY2FsbGVkIHJlY3Vyc2l2ZWx5LlxuICAgICAqXG4gICAgICogJ3NwZWNpZmllZFNlbGVjdG9yJyBpcyBuZWVkZWQgZm9yIDpoYXMoKSwgOmlzKCksIGFuZCA6bm90KCkgcHNldWRvLWNsYXNzZXNcbiAgICAgKiBhcyBuYXRpdmUgcXVlcnlTZWxlY3RvckFsbCgpIGRvZXMgbm90IHNlbGVjdCBleGFjdCBlbGVtZW50IGRlc2NlbmRhbnRzIGV2ZW4gaWYgaXQgaXMgY2FsbGVkIG9uICdkaXYnXG4gICAgICogZS5nLiAnOnNjb3BlJyBzcGVjaWZpY2F0aW9uIGlzIG5lZWRlZCBmb3IgcHJvcGVyIGRlc2NlbmRhbnRzIHNlbGVjdGlvbiBmb3IgJ2RpdjpoYXMoPiBpbWcpJy5cbiAgICAgKiBTbyB3ZSBjaGVjayBgZGl2Tm9kZS5xdWVyeVNlbGVjdG9yQWxsKCc6c2NvcGUgPiBpbWcnKS5sZW5ndGggPiAwYC5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBzZWxlY3Rvck5vZGUgU2VsZWN0b3Igbm9kZS5cbiAgICAgKiBAcGFyYW0gcm9vdCBSb290IERPTSBlbGVtZW50LlxuICAgICAqIEBwYXJhbSBzcGVjaWZpZWRTZWxlY3RvciBOZWVkZWQgZWxlbWVudCBzcGVjaWZpY2F0aW9uLlxuICAgICAqL1xuXG4gICAgY29uc3QgZ2V0RWxlbWVudHNGb3JTZWxlY3Rvck5vZGUgPSAoc2VsZWN0b3JOb2RlLCByb290LCBzcGVjaWZpZWRTZWxlY3RvcikgPT4ge1xuICAgICAgbGV0IHNlbGVjdGVkRWxlbWVudHMgPSBbXTtcbiAgICAgIGxldCBpID0gMDtcblxuICAgICAgd2hpbGUgKGkgPCBzZWxlY3Rvck5vZGUuY2hpbGRyZW4ubGVuZ3RoKSB7XG4gICAgICAgIGNvbnN0IHNlbGVjdG9yTm9kZUNoaWxkID0gc2VsZWN0b3JOb2RlLmNoaWxkcmVuW2ldO1xuXG4gICAgICAgIGlmIChpID09PSAwKSB7XG4gICAgICAgICAgLy8gYW55IHNlbGVjdG9yIGFsd2F5cyBzdGFydHMgd2l0aCByZWd1bGFyIHNlbGVjdG9yXG4gICAgICAgICAgc2VsZWN0ZWRFbGVtZW50cyA9IGdldEJ5UmVndWxhclNlbGVjdG9yKHNlbGVjdG9yTm9kZUNoaWxkLCByb290LCBzcGVjaWZpZWRTZWxlY3Rvcik7XG4gICAgICAgIH0gZWxzZSBpZiAoc2VsZWN0b3JOb2RlQ2hpbGQudHlwZSA9PT0gTm9kZVR5cGUuRXh0ZW5kZWRTZWxlY3Rvcikge1xuICAgICAgICAgIC8vIGZpbHRlciBwcmV2aW91c2x5IHNlbGVjdGVkIGVsZW1lbnRzIGJ5IG5leHQgc2VsZWN0b3Igbm9kZXNcbiAgICAgICAgICBzZWxlY3RlZEVsZW1lbnRzID0gZ2V0QnlFeHRlbmRlZFNlbGVjdG9yKHNlbGVjdGVkRWxlbWVudHMsIHNlbGVjdG9yTm9kZUNoaWxkKTtcbiAgICAgICAgfSBlbHNlIGlmIChzZWxlY3Rvck5vZGVDaGlsZC50eXBlID09PSBOb2RlVHlwZS5SZWd1bGFyU2VsZWN0b3IpIHtcbiAgICAgICAgICBzZWxlY3RlZEVsZW1lbnRzID0gZ2V0QnlGb2xsb3dpbmdSZWd1bGFyU2VsZWN0b3Ioc2VsZWN0ZWRFbGVtZW50cywgc2VsZWN0b3JOb2RlQ2hpbGQpO1xuICAgICAgICB9XG5cbiAgICAgICAgaSArPSAxO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gc2VsZWN0ZWRFbGVtZW50cztcbiAgICB9O1xuXG4gICAgLyoqXG4gICAgICogU2VsZWN0cyBlbGVtZW50cyBieSBhc3QuXG4gICAgICpcbiAgICAgKiBAcGFyYW0gYXN0IEFzdCBvZiBwYXJzZWQgc2VsZWN0b3IuXG4gICAgICogQHBhcmFtIGRvYyBEb2N1bWVudC5cbiAgICAgKi9cblxuICAgIGNvbnN0IHNlbGVjdEVsZW1lbnRzQnlBc3QgPSBmdW5jdGlvbiBzZWxlY3RFbGVtZW50c0J5QXN0KGFzdCkge1xuICAgICAgbGV0IGRvYyA9IGFyZ3VtZW50cy5sZW5ndGggPiAxICYmIGFyZ3VtZW50c1sxXSAhPT0gdW5kZWZpbmVkID8gYXJndW1lbnRzWzFdIDogZG9jdW1lbnQ7XG4gICAgICBjb25zdCBzZWxlY3RlZEVsZW1lbnRzID0gW107IC8vIGFzdCByb290IGlzIFNlbGVjdG9yTGlzdCBub2RlO1xuICAgICAgLy8gaXQgaGFzIFNlbGVjdG9yIG5vZGVzIGFzIGNoaWxkcmVuIHdoaWNoIHNob3VsZCBiZSBwcm9jZXNzZWQgc2VwYXJhdGVseVxuXG4gICAgICBhc3QuY2hpbGRyZW4uZm9yRWFjaChzZWxlY3Rvck5vZGUgPT4ge1xuICAgICAgICBzZWxlY3RlZEVsZW1lbnRzLnB1c2goLi4uZ2V0RWxlbWVudHNGb3JTZWxlY3Rvck5vZGUoc2VsZWN0b3JOb2RlLCBkb2MpKTtcbiAgICAgIH0pOyAvLyBzZWxlY3RlZEVsZW1lbnRzIHNob3VsZCBiZSBmbGF0dGVuZWQgYXMgaXQgaXMgYXJyYXkgb2YgYXJyYXlzIHdpdGggZWxlbWVudHNcblxuICAgICAgY29uc3QgdW5pcXVlRWxlbWVudHMgPSBbLi4ubmV3IFNldChmbGF0dGVuKHNlbGVjdGVkRWxlbWVudHMpKV07XG4gICAgICByZXR1cm4gdW5pcXVlRWxlbWVudHM7XG4gICAgfTtcbiAgICAvKipcbiAgICAgKiBDbGFzcyBvZiBFeHRDc3NEb2N1bWVudCBpcyBuZWVkZWQgZm9yIGNhY2hpbmcuXG4gICAgICogRm9yIG1ha2luZyBjYWNoZSByZWxhdGVkIHRvIGVhY2ggbmV3IGluc3RhbmNlIG9mIGNsYXNzLCBub3QgZ2xvYmFsLlxuICAgICAqL1xuXG4gICAgY2xhc3MgRXh0Q3NzRG9jdW1lbnQge1xuICAgICAgLyoqXG4gICAgICAgKiBDYWNoZSB3aXRoIHNlbGVjdG9ycyBhbmQgdGhlaXIgQVNUIHBhcnNpbmcgcmVzdWx0cy5cbiAgICAgICAqL1xuXG4gICAgICAvKipcbiAgICAgICAqIENyZWF0ZXMgbmV3IEV4dENzc0RvY3VtZW50IGFuZCBpbml0cyBuZXcgYGFzdENhY2hlYC5cbiAgICAgICAqL1xuICAgICAgY29uc3RydWN0b3IoKSB7XG4gICAgICAgIHRoaXMuYXN0Q2FjaGUgPSBuZXcgTWFwKCk7XG4gICAgICB9XG4gICAgICAvKipcbiAgICAgICAqIFNhdmVzIHNlbGVjdG9yIGFuZCBpdCdzIGFzdCB0byBjYWNoZS5cbiAgICAgICAqXG4gICAgICAgKiBAcGFyYW0gc2VsZWN0b3IgU3RhbmRhcmQgb3IgZXh0ZW5kZWQgc2VsZWN0b3IuXG4gICAgICAgKiBAcGFyYW0gYXN0IFNlbGVjdG9yIGFzdC5cbiAgICAgICAqL1xuXG5cbiAgICAgIHNhdmVBc3RUb0NhY2hlKHNlbGVjdG9yLCBhc3QpIHtcbiAgICAgICAgdGhpcy5hc3RDYWNoZS5zZXQoc2VsZWN0b3IsIGFzdCk7XG4gICAgICB9XG4gICAgICAvKipcbiAgICAgICAqIEdldHMgYXN0IGZyb20gY2FjaGUgZm9yIGdpdmVuIHNlbGVjdG9yLlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSBzZWxlY3RvciBTdGFuZGFyZCBvciBleHRlbmRlZCBzZWxlY3Rvci5cbiAgICAgICAqL1xuXG5cbiAgICAgIGdldEFzdEZyb21DYWNoZShzZWxlY3Rvcikge1xuICAgICAgICBjb25zdCBjYWNoZWRBc3QgPSB0aGlzLmFzdENhY2hlLmdldChzZWxlY3RvcikgfHwgbnVsbDtcbiAgICAgICAgcmV0dXJuIGNhY2hlZEFzdDtcbiAgICAgIH1cbiAgICAgIC8qKlxuICAgICAgICogR2V0cyBzZWxlY3RvciBhc3Q6XG4gICAgICAgKiAtIGlmIGNhY2hlZCBhc3QgZXhpc3RzIOKAlCByZXR1cm5zIGl0O1xuICAgICAgICogLSBpZiBubyBjYWNoZWQgYXN0IOKAlCBzYXZlcyBuZXdseSBwYXJzZWQgYXN0IHRvIGNhY2hlIGFuZCByZXR1cm5zIGl0LlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSBzZWxlY3RvciBTdGFuZGFyZCBvciBleHRlbmRlZCBzZWxlY3Rvci5cbiAgICAgICAqL1xuXG5cbiAgICAgIGdldFNlbGVjdG9yQXN0KHNlbGVjdG9yKSB7XG4gICAgICAgIGxldCBhc3QgPSB0aGlzLmdldEFzdEZyb21DYWNoZShzZWxlY3Rvcik7XG5cbiAgICAgICAgaWYgKCFhc3QpIHtcbiAgICAgICAgICBhc3QgPSBwYXJzZSQxKHNlbGVjdG9yKTtcbiAgICAgICAgfVxuXG4gICAgICAgIHRoaXMuc2F2ZUFzdFRvQ2FjaGUoc2VsZWN0b3IsIGFzdCk7XG4gICAgICAgIHJldHVybiBhc3Q7XG4gICAgICB9XG4gICAgICAvKipcbiAgICAgICAqIFNlbGVjdHMgZWxlbWVudHMgYnkgc2VsZWN0b3IuXG4gICAgICAgKlxuICAgICAgICogQHBhcmFtIHNlbGVjdG9yIFN0YW5kYXJkIG9yIGV4dGVuZGVkIHNlbGVjdG9yLlxuICAgICAgICovXG5cblxuICAgICAgcXVlcnlTZWxlY3RvckFsbChzZWxlY3Rvcikge1xuICAgICAgICBjb25zdCBhc3QgPSB0aGlzLmdldFNlbGVjdG9yQXN0KHNlbGVjdG9yKTtcbiAgICAgICAgcmV0dXJuIHNlbGVjdEVsZW1lbnRzQnlBc3QoYXN0KTtcbiAgICAgIH1cblxuICAgIH1cbiAgICBjb25zdCBleHRDc3NEb2N1bWVudCA9IG5ldyBFeHRDc3NEb2N1bWVudCgpO1xuXG4gICAgLyoqXG4gICAgICogQ2hlY2tzIHRoZSBwcmVzZW5jZSBvZiA6cmVtb3ZlKCkgcHNldWRvLWNsYXNzIGFuZCB2YWxpZGF0ZXMgaXQgd2hpbGUgcGFyc2luZyB0aGUgc2VsZWN0b3IgcGFydCBvZiBjc3MgcnVsZS5cbiAgICAgKlxuICAgICAqIEBwYXJhbSByYXdTZWxlY3RvciBTZWxlY3RvciB3aGljaCBtYXkgY29udGFpbiA6cmVtb3ZlKCkgcHNldWRvLWNsYXNzLlxuICAgICAqXG4gICAgICogQHRocm93cyBBbiBlcnJvciBvbiBpbnZhbGlkIDpyZW1vdmUoKSBwb3NpdGlvbi5cbiAgICAgKi9cbiAgICBjb25zdCBwYXJzZVJlbW92ZVNlbGVjdG9yID0gcmF3U2VsZWN0b3IgPT4ge1xuICAgICAgLyoqXG4gICAgICAgKiBObyBlcnJvciB3aWxsIGJlIHRocm93biBvbiBpbnZhbGlkIHNlbGVjdG9yIGFzIGl0IHdpbGwgYmUgdmFsaWRhdGVkIGxhdGVyXG4gICAgICAgKiBzbyBpdCdzIGJldHRlciB0byBleHBsaWNpdGx5IHNwZWNpZnkgJ2FueScgc2VsZWN0b3IgZm9yIDpyZW1vdmUoKSBwc2V1ZG8tY2xhc3MgYnkgJyonLFxuICAgICAgICogZS5nLiAnLmJhbm5lciA+ICo6cmVtb3ZlKCknIGluc3RlYWQgb2YgJy5iYW5uZXIgPiA6cmVtb3ZlKCknLlxuICAgICAgICovXG4gICAgICAvLyAnOnJlbW92ZSgpJ1xuICAgICAgY29uc3QgVkFMSURfUkVNT1ZFX01BUktFUiA9IFwiXCIuY29uY2F0KENPTE9OKS5jb25jYXQoUkVNT1ZFX1BTRVVET19NQVJLRVIpLmNvbmNhdChCUkFDS0VUUy5QQVJFTlRIRVNFUy5MRUZUKS5jb25jYXQoQlJBQ0tFVFMuUEFSRU5USEVTRVMuUklHSFQpOyAvLyBlc2xpbnQtZGlzYWJsZS1saW5lIG1heC1sZW5cbiAgICAgIC8vICc6cmVtb3ZlKCcgLSBuZWVkZWQgZm9yIHZhbGlkYXRpb24gcnVsZXMgbGlrZSAnZGl2OnJlbW92ZSgyKSdcblxuICAgICAgY29uc3QgSU5WQUxJRF9SRU1PVkVfTUFSS0VSID0gXCJcIi5jb25jYXQoQ09MT04pLmNvbmNhdChSRU1PVkVfUFNFVURPX01BUktFUikuY29uY2F0KEJSQUNLRVRTLlBBUkVOVEhFU0VTLkxFRlQpO1xuICAgICAgbGV0IHNlbGVjdG9yO1xuICAgICAgbGV0IHNob3VsZFJlbW92ZSA9IGZhbHNlO1xuICAgICAgY29uc3QgZmlyc3RJbmRleCA9IHJhd1NlbGVjdG9yLmluZGV4T2YoVkFMSURfUkVNT1ZFX01BUktFUik7XG5cbiAgICAgIGlmIChmaXJzdEluZGV4ID09PSAwKSB7XG4gICAgICAgIC8vIGUuZy4gJzpyZW1vdmUoKSdcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiXCIuY29uY2F0KFJFTU9WRV9FUlJPUl9QUkVGSVguTk9fVEFSR0VUX1NFTEVDVE9SLCBcIjogJ1wiKS5jb25jYXQocmF3U2VsZWN0b3IsIFwiJ1wiKSk7XG4gICAgICB9IGVsc2UgaWYgKGZpcnN0SW5kZXggPiAwKSB7XG4gICAgICAgIGlmIChmaXJzdEluZGV4ICE9PSByYXdTZWxlY3Rvci5sYXN0SW5kZXhPZihWQUxJRF9SRU1PVkVfTUFSS0VSKSkge1xuICAgICAgICAgIC8vIHJ1bGUgd2l0aCBtb3JlIHRoYW4gb25lIDpyZW1vdmUoKSBwc2V1ZG8tY2xhc3MgaXMgaW52YWxpZFxuICAgICAgICAgIC8vIGUuZy4gJy5ibG9jazpyZW1vdmUoKSA+IC5iYW5uZXI6cmVtb3ZlKCknXG4gICAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiXCIuY29uY2F0KFJFTU9WRV9FUlJPUl9QUkVGSVguTVVMVElQTEVfVVNBR0UsIFwiOiAnXCIpLmNvbmNhdChyYXdTZWxlY3RvciwgXCInXCIpKTtcbiAgICAgICAgfSBlbHNlIGlmIChmaXJzdEluZGV4ICsgVkFMSURfUkVNT1ZFX01BUktFUi5sZW5ndGggPCByYXdTZWxlY3Rvci5sZW5ndGgpIHtcbiAgICAgICAgICAvLyByZW1vdmUgcHNldWRvLWNsYXNzIHNob3VsZCBiZSBsYXN0IGluIHRoZSBydWxlXG4gICAgICAgICAgLy8gZS5nLiAnLmJsb2NrOnJlbW92ZSgpOnVwd2FyZCgyKSdcbiAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJcIi5jb25jYXQoUkVNT1ZFX0VSUk9SX1BSRUZJWC5JTlZBTElEX1BPU0lUSU9OLCBcIjogJ1wiKS5jb25jYXQocmF3U2VsZWN0b3IsIFwiJ1wiKSk7XG4gICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgLy8gdmFsaWQgOnJlbW92ZSgpIHBzZXVkby1jbGFzcyBwb3NpdGlvblxuICAgICAgICAgIHNlbGVjdG9yID0gcmF3U2VsZWN0b3Iuc3Vic3RyaW5nKDAsIGZpcnN0SW5kZXgpO1xuICAgICAgICAgIHNob3VsZFJlbW92ZSA9IHRydWU7XG4gICAgICAgIH1cbiAgICAgIH0gZWxzZSBpZiAocmF3U2VsZWN0b3IuaW5jbHVkZXMoSU5WQUxJRF9SRU1PVkVfTUFSS0VSKSkge1xuICAgICAgICAvLyBpdCBpcyBub3QgdmFsaWQgaWYgJzpyZW1vdmUoKScgaXMgYWJzZW50IGluIHJ1bGUgYnV0IGp1c3QgJzpyZW1vdmUoJyBpcyBwcmVzZW50XG4gICAgICAgIC8vIGUuZy4gJ2RpdjpyZW1vdmUoMCknXG4gICAgICAgIHRocm93IG5ldyBFcnJvcihcIlwiLmNvbmNhdChSRU1PVkVfRVJST1JfUFJFRklYLklOVkFMSURfUkVNT1ZFLCBcIjogJ1wiKS5jb25jYXQocmF3U2VsZWN0b3IsIFwiJ1wiKSk7XG4gICAgICB9IGVsc2Uge1xuICAgICAgICAvLyB0aGVyZSBpcyBubyA6cmVtb3ZlKCkgcHNldWRvLWNsYXNzIGlzIHJ1bGVcbiAgICAgICAgc2VsZWN0b3IgPSByYXdTZWxlY3RvcjtcbiAgICAgIH1cblxuICAgICAgY29uc3Qgc3R5bGVzT2ZTZWxlY3RvciA9IHNob3VsZFJlbW92ZSA/IFt7XG4gICAgICAgIHByb3BlcnR5OiBSRU1PVkVfUFNFVURPX01BUktFUixcbiAgICAgICAgdmFsdWU6IFN0cmluZyhzaG91bGRSZW1vdmUpXG4gICAgICB9XSA6IFtdO1xuICAgICAgcmV0dXJuIHtcbiAgICAgICAgc2VsZWN0b3IsXG4gICAgICAgIHN0eWxlc09mU2VsZWN0b3JcbiAgICAgIH07XG4gICAgfTtcblxuICAgIC8qKlxuICAgICAqIENvbnZlcnRzIGFycmF5IG9mIHBhaXJzIHRvIG9iamVjdC5cbiAgICAgKiBPYmplY3QuZnJvbUVudHJpZXMoKSBwb2x5ZmlsbCBiZWNhdXNlIGl0IGlzIG5vdCBzdXBwb3J0ZWQgYnkgb2xkIGJyb3dzZXJzLCBlLmcuIENocm9tZSA1NS5cbiAgICAgKlxuICAgICAqIEBzZWUge0BsaW5rIGh0dHBzOi8vY2FuaXVzZS5jb20vP3NlYXJjaD1PYmplY3QuZnJvbUVudHJpZXN9XG4gICAgICpcbiAgICAgKiBAcGFyYW0gZW50cmllcyBBcnJheSBvZiBwYWlycy5cbiAgICAgKi9cbiAgICBjb25zdCBnZXRPYmplY3RGcm9tRW50cmllcyA9IGVudHJpZXMgPT4ge1xuICAgICAgY29uc3QgaW5pdEFjYyA9IHt9O1xuICAgICAgY29uc3Qgb2JqZWN0ID0gZW50cmllcy5yZWR1Y2UoKGFjYywgZWwpID0+IHtcbiAgICAgICAgY29uc3Qga2V5ID0gZWxbMF07XG4gICAgICAgIGNvbnN0IHZhbHVlID0gZWxbMV07XG4gICAgICAgIGFjY1trZXldID0gdmFsdWU7XG4gICAgICAgIHJldHVybiBhY2M7XG4gICAgICB9LCBpbml0QWNjKTtcbiAgICAgIHJldHVybiBvYmplY3Q7XG4gICAgfTtcblxuICAgIGNvbnN0IERFQlVHX1BTRVVET19QUk9QRVJUWV9LRVkgPSAnZGVidWcnO1xuICAgIGNvbnN0IFJFR0VYUF9ERUNMQVJBVElPTl9FTkQgPSAvWzt9XS9nO1xuICAgIGNvbnN0IFJFR0VYUF9ERUNMQVJBVElPTl9ESVZJREVSID0gL1s7On1dL2c7XG4gICAgY29uc3QgUkVHRVhQX05PTl9XSElURVNQQUNFID0gL1xcUy9nOyAvLyBFeHRlbmRlZENzcyBkb2VzIG5vdCBzdXBwb3J0IGF0LXJ1bGVzXG4gICAgLy8gaHR0cHM6Ly9kZXZlbG9wZXIubW96aWxsYS5vcmcvZW4tVVMvZG9jcy9XZWIvQ1NTL0F0LXJ1bGVcblxuICAgIGNvbnN0IEFUX1JVTEVfTUFSS0VSID0gJ0AnO1xuXG4gICAgLyoqXG4gICAgICogSW5pdCB2YWx1ZSBmb3IgcmF3UnVsZURhdGEuXG4gICAgICovXG4gICAgY29uc3QgaW5pdFJhd1J1bGVEYXRhID0ge1xuICAgICAgc2VsZWN0b3I6ICcnXG4gICAgfTtcbiAgICAvKipcbiAgICAgKiBSZXNldHMgcnVsZSBkYXRhIGJ1ZmZlciB0byBpbml0IHZhbHVlIGFmdGVyIHJ1bGUgc3VjY2Vzc2Z1bGx5IGNvbGxlY3RlZC5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBjb250ZXh0IFN0eWxlc2hlZXQgcGFyc2VyIGNvbnRleHQuXG4gICAgICovXG5cbiAgICBjb25zdCByZXN0b3JlUnVsZUFjYyA9IGNvbnRleHQgPT4ge1xuICAgICAgY29udGV4dC5yYXdSdWxlRGF0YSA9IGluaXRSYXdSdWxlRGF0YTtcbiAgICB9O1xuICAgIC8qKlxuICAgICAqIFBhcnNlcyBjcm9wcGVkIHNlbGVjdG9yIHBhcnQgZm91bmQgYmVmb3JlIGB7YCBwcmV2aW91c2x5LlxuICAgICAqXG4gICAgICogQHBhcmFtIGNvbnRleHQgU3R5bGVzaGVldCBwYXJzZXIgY29udGV4dC5cbiAgICAgKiBAcGFyYW0gZXh0Q3NzRG9jIE5lZWRlZCBmb3IgY2FjaGluZyBvZiBzZWxlY3RvciBhc3QuXG4gICAgICpcbiAgICAgKiBAdGhyb3dzIEFuIGVycm9yIG9uIHVuc3VwcG9ydGVkIENTUyBmZWF0dXJlcywgZS5nLiBhdC1ydWxlcy5cbiAgICAgKi9cblxuXG4gICAgY29uc3QgcGFyc2VTZWxlY3RvclBhcnQgPSAoY29udGV4dCwgZXh0Q3NzRG9jKSA9PiB7XG4gICAgICBsZXQgc2VsZWN0b3IgPSBjb250ZXh0LnNlbGVjdG9yQnVmZmVyLnRyaW0oKTtcblxuICAgICAgaWYgKHNlbGVjdG9yLnN0YXJ0c1dpdGgoQVRfUlVMRV9NQVJLRVIpKSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcihcIkF0LXJ1bGVzIGFyZSBub3Qgc3VwcG9ydGVkOiAnXCIuY29uY2F0KHNlbGVjdG9yLCBcIicuXCIpKTtcbiAgICAgIH1cblxuICAgICAgbGV0IHJlbW92ZVNlbGVjdG9yRGF0YTtcblxuICAgICAgdHJ5IHtcbiAgICAgICAgcmVtb3ZlU2VsZWN0b3JEYXRhID0gcGFyc2VSZW1vdmVTZWxlY3RvcihzZWxlY3Rvcik7XG4gICAgICB9IGNhdGNoIChlKSB7XG4gICAgICAgIC8vIGVzbGludC1kaXNhYmxlLWxpbmUgQHR5cGVzY3JpcHQtZXNsaW50L25vLWV4cGxpY2l0LWFueVxuICAgICAgICBsb2dnZXIuZXJyb3IoZS5tZXNzYWdlKTtcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiXCIuY29uY2F0KFJFTU9WRV9FUlJPUl9QUkVGSVguSU5WQUxJRF9SRU1PVkUsIFwiOiAnXCIpLmNvbmNhdChzZWxlY3RvciwgXCInXCIpKTtcbiAgICAgIH1cblxuICAgICAgaWYgKGNvbnRleHQubmV4dEluZGV4ID09PSAtMSkge1xuICAgICAgICBpZiAoc2VsZWN0b3IgPT09IHJlbW92ZVNlbGVjdG9yRGF0YS5zZWxlY3Rvcikge1xuICAgICAgICAgIC8vIHJ1bGUgc2hvdWxkIGhhdmUgc3R5bGUgb3IgcHNldWRvLWNsYXNzIDpyZW1vdmUoKVxuICAgICAgICAgIHRocm93IG5ldyBFcnJvcihcIlwiLmNvbmNhdChTVFlMRVNIRUVUX0VSUk9SX1BSRUZJWC5OT19TVFlMRV9PUl9SRU1PVkUsIFwiOiAnXCIpLmNvbmNhdChjb250ZXh0LmNzc1RvUGFyc2UsIFwiJ1wiKSk7IC8vIGVzbGludC1kaXNhYmxlLWxpbmUgbWF4LWxlblxuICAgICAgICB9IC8vIHN0b3AgcGFyc2luZyBhcyB0aGVyZSBpcyBubyBzdHlsZSBkZWNsYXJhdGlvbiBhbmQgc2VsZWN0b3IgcGFyc2VkIGZpbmVcblxuXG4gICAgICAgIGNvbnRleHQuY3NzVG9QYXJzZSA9ICcnO1xuICAgICAgfVxuXG4gICAgICBsZXQgc3R5bGVzT2ZTZWxlY3RvciA9IFtdO1xuICAgICAgbGV0IHN1Y2Nlc3MgPSBmYWxzZTtcbiAgICAgIGxldCBhc3Q7XG5cbiAgICAgIHRyeSB7XG4gICAgICAgIHNlbGVjdG9yID0gcmVtb3ZlU2VsZWN0b3JEYXRhLnNlbGVjdG9yO1xuICAgICAgICBzdHlsZXNPZlNlbGVjdG9yID0gcmVtb3ZlU2VsZWN0b3JEYXRhLnN0eWxlc09mU2VsZWN0b3I7IC8vIHZhbGlkYXRlIGZvdW5kIHNlbGVjdG9yIGJ5IHBhcnNpbmcgaXQgdG8gYXN0XG4gICAgICAgIC8vIHNvIGlmIGl0IGlzIGludmFsaWQgZXJyb3Igd2lsbCBiZSB0aHJvd25cblxuICAgICAgICBhc3QgPSBleHRDc3NEb2MuZ2V0U2VsZWN0b3JBc3Qoc2VsZWN0b3IpO1xuICAgICAgICBzdWNjZXNzID0gdHJ1ZTtcbiAgICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgICAgLy8gZXNsaW50LWRpc2FibGUtbGluZSBAdHlwZXNjcmlwdC1lc2xpbnQvbm8tZXhwbGljaXQtYW55XG4gICAgICAgIHN1Y2Nlc3MgPSBmYWxzZTtcbiAgICAgIH1cblxuICAgICAgaWYgKGNvbnRleHQubmV4dEluZGV4ID4gMCkge1xuICAgICAgICAvLyBzbGljZSBmb3VuZCB2YWxpZCBzZWxlY3RvciBwYXJ0IG9mZlxuICAgICAgICAvLyBhbmQgcGFyc2UgcmVzdCBvZiBzdHlsZXNoZWV0IGxhdGVyXG4gICAgICAgIGNvbnRleHQuY3NzVG9QYXJzZSA9IGNvbnRleHQuY3NzVG9QYXJzZS5zbGljZShjb250ZXh0Lm5leHRJbmRleCk7XG4gICAgICB9XG5cbiAgICAgIHJldHVybiB7XG4gICAgICAgIHN1Y2Nlc3MsXG4gICAgICAgIHNlbGVjdG9yLFxuICAgICAgICBhc3QsXG4gICAgICAgIHN0eWxlc09mU2VsZWN0b3JcbiAgICAgIH07XG4gICAgfTtcbiAgICAvKipcbiAgICAgKiBSZWN1cnNpdmVseSBwYXJzZXMgc3R5bGUgZGVjbGFyYXRpb24gc3RyaW5nIGludG8gYFN0eWxlYHMuXG4gICAgICpcbiAgICAgKiBAcGFyYW0gY29udGV4dCBTdHlsZXNoZWV0IHBhcnNlciBjb250ZXh0LlxuICAgICAqIEBwYXJhbSBzdHlsZXMgQXJyYXkgb2Ygc3R5bGVzLlxuICAgICAqXG4gICAgICogQHRocm93cyBBbiBlcnJvciBvbiBpbnZhbGlkIHN0eWxlIGRlY2xhcmF0aW9uLlxuICAgICAqIEByZXR1cm5zIEEgbnVtYmVyIGluZGV4IG9mIHRoZSBuZXh0IGB9YCBpbiBgdGhpcy5jc3NUb1BhcnNlYC5cbiAgICAgKi9cblxuXG4gICAgY29uc3QgcGFyc2VVbnRpbENsb3NpbmdCcmFja2V0ID0gKGNvbnRleHQsIHN0eWxlcykgPT4ge1xuICAgICAgLy8gRXhwZWN0cyBcIjpcIiwgXCI7XCIsIGFuZCBcIn1cIi5cbiAgICAgIFJFR0VYUF9ERUNMQVJBVElPTl9ESVZJREVSLmxhc3RJbmRleCA9IGNvbnRleHQubmV4dEluZGV4O1xuICAgICAgbGV0IG1hdGNoID0gUkVHRVhQX0RFQ0xBUkFUSU9OX0RJVklERVIuZXhlYyhjb250ZXh0LmNzc1RvUGFyc2UpO1xuXG4gICAgICBpZiAobWF0Y2ggPT09IG51bGwpIHtcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiXCIuY29uY2F0KFNUWUxFU0hFRVRfRVJST1JfUFJFRklYLklOVkFMSURfU1RZTEUsIFwiOiAnXCIpLmNvbmNhdChjb250ZXh0LmNzc1RvUGFyc2UsIFwiJ1wiKSk7XG4gICAgICB9XG5cbiAgICAgIGxldCBtYXRjaFBvcyA9IG1hdGNoLmluZGV4O1xuICAgICAgbGV0IG1hdGNoZWQgPSBtYXRjaFswXTtcblxuICAgICAgaWYgKG1hdGNoZWQgPT09IEJSQUNLRVRTLkNVUkxZLlJJR0hUKSB7XG4gICAgICAgIGNvbnN0IGRlY2xhcmF0aW9uQ2h1bmsgPSBjb250ZXh0LmNzc1RvUGFyc2Uuc2xpY2UoY29udGV4dC5uZXh0SW5kZXgsIG1hdGNoUG9zKTtcblxuICAgICAgICBpZiAoZGVjbGFyYXRpb25DaHVuay50cmltKCkubGVuZ3RoID09PSAwKSB7XG4gICAgICAgICAgLy8gZW1wdHkgc3R5bGUgZGVjbGFyYXRpb25cbiAgICAgICAgICAvLyBlLmcuICdkaXYgeyB9J1xuICAgICAgICAgIGlmIChzdHlsZXMubGVuZ3RoID09PSAwKSB7XG4gICAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJcIi5jb25jYXQoU1RZTEVTSEVFVF9FUlJPUl9QUkVGSVguTk9fU1RZTEUsIFwiOiAnXCIpLmNvbmNhdChjb250ZXh0LmNzc1RvUGFyc2UsIFwiJ1wiKSk7XG4gICAgICAgICAgfSAvLyBlbHNlIHZhbGlkIHN0eWxlIHBhcnNlZCBiZWZvcmUgaXRcbiAgICAgICAgICAvLyBlLmcuICd7IGRpc3BsYXk6IG5vbmU7IH0nIC0tIHBvc2l0aW9uIGlzIGFmdGVyICc7J1xuXG4gICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgLy8gY2xvc2luZyBjdXJseSBicmFja2V0ICd9JyBpcyBtYXRjaGVkIGJlZm9yZSBjb2xvbiAnOidcbiAgICAgICAgICAvLyB0cmltbWVkIGRlY2xhcmF0aW9uQ2h1bmsgaXMgbm90IGEgc3BhY2UsIGJldHdlZW4gJzsnIGFuZCAnfScsXG4gICAgICAgICAgLy8gZS5nLiAndmlzaWJsZSB9JyBpbiBzdHlsZSAneyBkaXNwbGF5OiBub25lOyB2aXNpYmxlIH0nIGFmdGVyIHBhcnQgYmVmb3JlICc7JyBpcyBwYXJzZWRcbiAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJcIi5jb25jYXQoU1RZTEVTSEVFVF9FUlJPUl9QUkVGSVguSU5WQUxJRF9TVFlMRSwgXCI6ICdcIikuY29uY2F0KGNvbnRleHQuY3NzVG9QYXJzZSwgXCInXCIpKTtcbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiBtYXRjaFBvcztcbiAgICAgIH1cblxuICAgICAgaWYgKG1hdGNoZWQgPT09IENPTE9OKSB7XG4gICAgICAgIGNvbnN0IGNvbG9uSW5kZXggPSBtYXRjaFBvczsgLy8gRXhwZWN0cyBcIjtcIiBhbmQgXCJ9XCIuXG5cbiAgICAgICAgUkVHRVhQX0RFQ0xBUkFUSU9OX0VORC5sYXN0SW5kZXggPSBjb2xvbkluZGV4O1xuICAgICAgICBtYXRjaCA9IFJFR0VYUF9ERUNMQVJBVElPTl9FTkQuZXhlYyhjb250ZXh0LmNzc1RvUGFyc2UpO1xuXG4gICAgICAgIGlmIChtYXRjaCA9PT0gbnVsbCkge1xuICAgICAgICAgIHRocm93IG5ldyBFcnJvcihcIlwiLmNvbmNhdChTVFlMRVNIRUVUX0VSUk9SX1BSRUZJWC5VTkNMT1NFRF9TVFlMRSwgXCI6ICdcIikuY29uY2F0KGNvbnRleHQuY3NzVG9QYXJzZSwgXCInXCIpKTtcbiAgICAgICAgfVxuXG4gICAgICAgIG1hdGNoUG9zID0gbWF0Y2guaW5kZXg7XG4gICAgICAgIG1hdGNoZWQgPSBtYXRjaFswXTsgLy8gUG9wdWxhdGVzIHRoZSBgc3R5bGVNYXBgIGtleS12YWx1ZSBtYXAuXG5cbiAgICAgICAgY29uc3QgcHJvcGVydHkgPSBjb250ZXh0LmNzc1RvUGFyc2Uuc2xpY2UoY29udGV4dC5uZXh0SW5kZXgsIGNvbG9uSW5kZXgpLnRyaW0oKTtcblxuICAgICAgICBpZiAocHJvcGVydHkubGVuZ3RoID09PSAwKSB7XG4gICAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiXCIuY29uY2F0KFNUWUxFU0hFRVRfRVJST1JfUFJFRklYLk5PX1BST1BFUlRZLCBcIjogJ1wiKS5jb25jYXQoY29udGV4dC5jc3NUb1BhcnNlLCBcIidcIikpO1xuICAgICAgICB9XG5cbiAgICAgICAgY29uc3QgdmFsdWUgPSBjb250ZXh0LmNzc1RvUGFyc2Uuc2xpY2UoY29sb25JbmRleCArIDEsIG1hdGNoUG9zKS50cmltKCk7XG5cbiAgICAgICAgaWYgKHZhbHVlLmxlbmd0aCA9PT0gMCkge1xuICAgICAgICAgIHRocm93IG5ldyBFcnJvcihcIlwiLmNvbmNhdChTVFlMRVNIRUVUX0VSUk9SX1BSRUZJWC5OT19WQUxVRSwgXCI6ICdcIikuY29uY2F0KGNvbnRleHQuY3NzVG9QYXJzZSwgXCInXCIpKTtcbiAgICAgICAgfVxuXG4gICAgICAgIHN0eWxlcy5wdXNoKHtcbiAgICAgICAgICBwcm9wZXJ0eSxcbiAgICAgICAgICB2YWx1ZVxuICAgICAgICB9KTsgLy8gZmluaXNoIHN0eWxlIHBhcnNpbmcgaWYgJ30nIGlzIGZvdW5kXG4gICAgICAgIC8vIGUuZy4gJ3sgZGlzcGxheTogbm9uZSB9JyAtLSBubyAnOycgYXQgdGhlIGVuZCBvZiBkZWNsYXJhdGlvblxuXG4gICAgICAgIGlmIChtYXRjaGVkID09PSBCUkFDS0VUUy5DVVJMWS5SSUdIVCkge1xuICAgICAgICAgIHJldHVybiBtYXRjaFBvcztcbiAgICAgICAgfVxuICAgICAgfSAvLyBtYXRjaFBvcyBpcyB0aGUgcG9zaXRpb24gb2YgdGhlIG5leHQgJzsnXG4gICAgICAvLyBjcm9wICdjc3NUb1BhcnNlJyBhbmQgcmUtcnVuIHRoZSBsb29wXG5cblxuICAgICAgY29udGV4dC5jc3NUb1BhcnNlID0gY29udGV4dC5jc3NUb1BhcnNlLnNsaWNlKG1hdGNoUG9zICsgMSk7XG4gICAgICBjb250ZXh0Lm5leHRJbmRleCA9IDA7XG4gICAgICByZXR1cm4gcGFyc2VVbnRpbENsb3NpbmdCcmFja2V0KGNvbnRleHQsIHN0eWxlcyk7IC8vIFNob3VsZCBiZSBhIHN1YmplY3Qgb2YgdGFpbC1jYWxsIG9wdGltaXphdGlvbi5cbiAgICB9O1xuICAgIC8qKlxuICAgICAqIFBhcnNlcyBuZXh0IHN0eWxlIGRlY2xhcmF0aW9uIHBhcnQgaW4gc3R5bGVzaGVldC5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBjb250ZXh0IFN0eWxlc2hlZXQgcGFyc2VyIGNvbnRleHQuXG4gICAgICovXG5cblxuICAgIGNvbnN0IHBhcnNlTmV4dFN0eWxlID0gY29udGV4dCA9PiB7XG4gICAgICBjb25zdCBzdHlsZXMgPSBbXTtcbiAgICAgIGNvbnN0IHN0eWxlRW5kUG9zID0gcGFyc2VVbnRpbENsb3NpbmdCcmFja2V0KGNvbnRleHQsIHN0eWxlcyk7IC8vIGZpbmQgbmV4dCBydWxlIGFmdGVyIHRoZSBzdHlsZSBkZWNsYXJhdGlvblxuXG4gICAgICBSRUdFWFBfTk9OX1dISVRFU1BBQ0UubGFzdEluZGV4ID0gc3R5bGVFbmRQb3MgKyAxO1xuICAgICAgY29uc3QgbWF0Y2ggPSBSRUdFWFBfTk9OX1dISVRFU1BBQ0UuZXhlYyhjb250ZXh0LmNzc1RvUGFyc2UpO1xuXG4gICAgICBpZiAobWF0Y2ggPT09IG51bGwpIHtcbiAgICAgICAgY29udGV4dC5jc3NUb1BhcnNlID0gJyc7XG4gICAgICAgIHJldHVybiBzdHlsZXM7XG4gICAgICB9XG5cbiAgICAgIGNvbnN0IG1hdGNoUG9zID0gbWF0Y2guaW5kZXg7IC8vIGN1dCBvdXQgbWF0Y2hlZCBzdHlsZSBkZWNsYXJhdGlvbiBmb3IgcHJldmlvdXMgc2VsZWN0b3JcblxuICAgICAgY29udGV4dC5jc3NUb1BhcnNlID0gY29udGV4dC5jc3NUb1BhcnNlLnNsaWNlKG1hdGNoUG9zKTtcbiAgICAgIHJldHVybiBzdHlsZXM7XG4gICAgfTtcbiAgICAvKipcbiAgICAgKiBDaGVja3Mgd2hldGhlciB0aGUgJ3JlbW92ZScgcHJvcGVydHkgcG9zaXRpdmVseSBzZXQgaW4gc3R5bGVzXG4gICAgICogd2l0aCBvbmx5IG9uZSBwb3NpdGl2ZSB2YWx1ZSAtICd0cnVlJy5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBzdHlsZXMgQXJyYXkgb2Ygc3R5bGVzLlxuICAgICAqL1xuXG5cbiAgICBjb25zdCBpc1JlbW92ZVNldEluU3R5bGVzID0gc3R5bGVzID0+IHtcbiAgICAgIHJldHVybiBzdHlsZXMuc29tZShzID0+IHtcbiAgICAgICAgcmV0dXJuIHMucHJvcGVydHkgPT09IFJFTU9WRV9QU0VVRE9fTUFSS0VSICYmIHMudmFsdWUgPT09IFBTRVVET19QUk9QRVJUWV9QT1NJVElWRV9WQUxVRTtcbiAgICAgIH0pO1xuICAgIH07XG4gICAgLyoqXG4gICAgICogR2V0cyB2YWxpZCAnZGVidWcnIHByb3BlcnR5IHZhbHVlIHNldCBpbiBzdHlsZXNcbiAgICAgKiB3aGVyZSBwb3NzaWJsZSB2YWx1ZXMgYXJlICd0cnVlJyBhbmQgJ2dsb2JhbCcuXG4gICAgICpcbiAgICAgKiBAcGFyYW0gc3R5bGVzIEFycmF5IG9mIHN0eWxlcy5cbiAgICAgKi9cblxuXG4gICAgY29uc3QgZ2V0RGVidWdTdHlsZVZhbHVlID0gc3R5bGVzID0+IHtcbiAgICAgIGNvbnN0IGRlYnVnU3R5bGUgPSBzdHlsZXMuZmluZChzID0+IHtcbiAgICAgICAgcmV0dXJuIHMucHJvcGVydHkgPT09IERFQlVHX1BTRVVET19QUk9QRVJUWV9LRVk7XG4gICAgICB9KTtcbiAgICAgIHJldHVybiBkZWJ1Z1N0eWxlID09PSBudWxsIHx8IGRlYnVnU3R5bGUgPT09IHZvaWQgMCA/IHZvaWQgMCA6IGRlYnVnU3R5bGUudmFsdWU7XG4gICAgfTtcbiAgICAvKipcbiAgICAgKiBQcmVwYXJlcyBmaW5hbCBSdWxlRGF0YS5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBzZWxlY3RvciBTdHJpbmcgc2VsZWN0b3IuXG4gICAgICogQHBhcmFtIGFzdCBQYXJzZWQgYXN0LlxuICAgICAqIEBwYXJhbSByYXdTdHlsZXMgQXJyYXkgb2YgcHJldmlvdXNseSBjb2xsZWN0ZWQgc3R5bGVzIHdoaWNoIG1heSBjb250YWluICdyZW1vdmUnIGFuZCAnZGVidWcnLlxuICAgICAqL1xuXG5cbiAgICBjb25zdCBwcmVwYXJlUnVsZURhdGEgPSAoc2VsZWN0b3IsIGFzdCwgcmF3U3R5bGVzKSA9PiB7XG4gICAgICBjb25zdCBydWxlRGF0YSA9IHtcbiAgICAgICAgc2VsZWN0b3IsXG4gICAgICAgIGFzdFxuICAgICAgfTtcbiAgICAgIGNvbnN0IGRlYnVnVmFsdWUgPSBnZXREZWJ1Z1N0eWxlVmFsdWUocmF3U3R5bGVzKTtcbiAgICAgIGNvbnN0IHNob3VsZFJlbW92ZSA9IGlzUmVtb3ZlU2V0SW5TdHlsZXMocmF3U3R5bGVzKTtcbiAgICAgIGxldCBzdHlsZXMgPSByYXdTdHlsZXM7XG5cbiAgICAgIGlmIChkZWJ1Z1ZhbHVlKSB7XG4gICAgICAgIC8vIGdldCByaWQgb2YgJ2RlYnVnJyBmcm9tIHN0eWxlc1xuICAgICAgICBzdHlsZXMgPSByYXdTdHlsZXMuZmlsdGVyKHMgPT4gcy5wcm9wZXJ0eSAhPT0gREVCVUdfUFNFVURPX1BST1BFUlRZX0tFWSk7IC8vIGFuZCBzZXQgaXQgYXMgc2VwYXJhdGUgcHJvcGVydHkgb25seSBpZiBpdHMgdmFsdWUgaXMgdmFsaWRcbiAgICAgICAgLy8gd2hpY2ggaXMgJ3RydWUnIG9yICdnbG9iYWwnXG5cbiAgICAgICAgaWYgKGRlYnVnVmFsdWUgPT09IFBTRVVET19QUk9QRVJUWV9QT1NJVElWRV9WQUxVRSB8fCBkZWJ1Z1ZhbHVlID09PSBERUJVR19QU0VVRE9fUFJPUEVSVFlfR0xPQkFMX1ZBTFVFKSB7XG4gICAgICAgICAgcnVsZURhdGEuZGVidWcgPSBkZWJ1Z1ZhbHVlO1xuICAgICAgICB9XG4gICAgICB9XG5cbiAgICAgIGlmIChzaG91bGRSZW1vdmUpIHtcbiAgICAgICAgLy8gbm8gb3RoZXIgc3R5bGVzIGFyZSBuZWVkZWQgdG8gYXBwbHkgaWYgJ3JlbW92ZScgaXMgc2V0XG4gICAgICAgIHJ1bGVEYXRhLnN0eWxlID0ge1xuICAgICAgICAgIFtSRU1PVkVfUFNFVURPX01BUktFUl06IFBTRVVET19QUk9QRVJUWV9QT1NJVElWRV9WQUxVRVxuICAgICAgICB9O1xuICAgICAgfSBlbHNlIHtcbiAgICAgICAgLy8gb3RoZXJ3aXNlIGFsbCBzdHlsZXMgc2hvdWxkIGJlIGFwcGxpZWQuXG4gICAgICAgIC8vIGV2ZXJ5IHN0eWxlIHByb3BlcnR5IHdpbGwgYmUgdW5pcXVlIGJlY2F1c2Ugb2YgdGhlaXIgY29udmVydGluZyBpbnRvIG9iamVjdFxuICAgICAgICBpZiAoc3R5bGVzLmxlbmd0aCA+IDApIHtcbiAgICAgICAgICBjb25zdCBzdHlsZXNBc0VudHJpZXMgPSBzdHlsZXMubWFwKHN0eWxlID0+IHtcbiAgICAgICAgICAgIGNvbnN0IHByb3BlcnR5ID0gc3R5bGUucHJvcGVydHksXG4gICAgICAgICAgICAgICAgICB2YWx1ZSA9IHN0eWxlLnZhbHVlO1xuICAgICAgICAgICAgcmV0dXJuIFtwcm9wZXJ0eSwgdmFsdWVdO1xuICAgICAgICAgIH0pO1xuICAgICAgICAgIGNvbnN0IHByZXBhcmVkU3R5bGVEYXRhID0gZ2V0T2JqZWN0RnJvbUVudHJpZXMoc3R5bGVzQXNFbnRyaWVzKTtcbiAgICAgICAgICBydWxlRGF0YS5zdHlsZSA9IHByZXBhcmVkU3R5bGVEYXRhO1xuICAgICAgICB9XG4gICAgICB9XG5cbiAgICAgIHJldHVybiBydWxlRGF0YTtcbiAgICB9O1xuICAgIC8qKlxuICAgICAqIFNhdmVzIHJ1bGVzIGRhdGEgZm9yIHVuaXF1ZSBzZWxlY3RvcnMuXG4gICAgICpcbiAgICAgKiBAcGFyYW0gcmF3UmVzdWx0cyBQcmV2aW91c2x5IGNvbGxlY3RlZCByZXN1bHRzIG9mIHBhcnNpbmcuXG4gICAgICogQHBhcmFtIHJhd1J1bGVEYXRhIFBhcnNlZCBydWxlIGRhdGEuXG4gICAgICpcbiAgICAgKiBAdGhyb3dzIEFuIGVycm9yIGlmIHRoZXJlIGlzIG5vIHJhd1J1bGVEYXRhLnN0eWxlcyBvciByYXdSdWxlRGF0YS5hc3QuXG4gICAgICovXG5cbiAgICBjb25zdCBzYXZlVG9SYXdSZXN1bHRzID0gKHJhd1Jlc3VsdHMsIHJhd1J1bGVEYXRhKSA9PiB7XG4gICAgICBjb25zdCBzZWxlY3RvciA9IHJhd1J1bGVEYXRhLnNlbGVjdG9yLFxuICAgICAgICAgICAgYXN0ID0gcmF3UnVsZURhdGEuYXN0LFxuICAgICAgICAgICAgc3R5bGVzID0gcmF3UnVsZURhdGEuc3R5bGVzO1xuXG4gICAgICBpZiAoIXN0eWxlcykge1xuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJObyBzdHlsZSBkZWNsYXJhdGlvbiBmb3Igc2VsZWN0b3I6ICdcIi5jb25jYXQoc2VsZWN0b3IsIFwiJ1wiKSk7XG4gICAgICB9XG5cbiAgICAgIGlmICghYXN0KSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcihcIk5vIGFzdCBwYXJzZWQgZm9yIHNlbGVjdG9yOiAnXCIuY29uY2F0KHNlbGVjdG9yLCBcIidcIikpO1xuICAgICAgfVxuXG4gICAgICBjb25zdCBzdG9yZWRSdWxlRGF0YSA9IHJhd1Jlc3VsdHMuZ2V0KHNlbGVjdG9yKTtcblxuICAgICAgaWYgKCFzdG9yZWRSdWxlRGF0YSkge1xuICAgICAgICByYXdSZXN1bHRzLnNldChzZWxlY3Rvciwge1xuICAgICAgICAgIGFzdCxcbiAgICAgICAgICBzdHlsZXNcbiAgICAgICAgfSk7XG4gICAgICB9IGVsc2Uge1xuICAgICAgICBzdG9yZWRSdWxlRGF0YS5zdHlsZXMucHVzaCguLi5zdHlsZXMpO1xuICAgICAgfVxuICAgIH07XG4gICAgLyoqXG4gICAgICogUGFyc2VzIHN0eWxlc2hlZXQgb2YgcnVsZXMgaW50byBydWxlcyBkYXRhIG9iamVjdHMgKG5vbi1yZWN1cnNpdmVseSk6XG4gICAgICogMS4gSXRlcmF0ZXMgdGhyb3VnaCBzdHlsZXNoZWV0IHN0cmluZy5cbiAgICAgKiAyLiBGaW5kcyBmaXJzdCBge2Agd2hpY2ggY2FuIGJlIHN0eWxlIGRlY2xhcmF0aW9uIHN0YXJ0IG9yIHBhcnQgb2Ygc2VsZWN0b3IuXG4gICAgICogMy4gVmFsaWRhdGVzIGZvdW5kIHN0cmluZyBwYXJ0IHZpYSBzZWxlY3RvciBwYXJzZXI7IGFuZCBpZjpcbiAgICAgKiAgLSBpdCB0aHJvd3MgZXJyb3Ig4oCUIHNhdmVzIHN0cmluZyBwYXJ0IHRvIGJ1ZmZlciBhcyBwYXJ0IG9mIHNlbGVjdG9yLFxuICAgICAqICAgIHNsaWNlIG5leHQgc3R5bGVzaGVldCBwYXJ0IHRvIGB7YCBbMl0gYW5kIHZhbGlkYXRlcyBhZ2FpbiBbM107XG4gICAgICogIC0gbm8gZXJyb3Ig4oCUIHNhdmVzIGZvdW5kIHN0cmluZyBwYXJ0IGFzIHNlbGVjdG9yIGFuZCBzdGFydHMgdG8gcGFyc2Ugc3R5bGVzIChyZWN1cnNpdmVseSkuXG4gICAgICpcbiAgICAgKiBAcGFyYW0gcmF3U3R5bGVzaGVldCBSYXcgc3R5bGVzaGVldCBhcyBzdHJpbmcuXG4gICAgICogQHBhcmFtIGV4dENzc0RvYyBFeHRDc3NEb2N1bWVudCB3aGljaCB1c2VzIGNhY2hlIHdoaWxlIHNlbGVjdG9ycyBwYXJzaW5nLlxuICAgICAqIEB0aHJvd3MgQW4gZXJyb3Igb24gdW5zdXBwb3J0ZWQgQ1NTIGZlYXR1cmVzLCBlLmcuIGNvbW1lbnRzLCBvciBpbnZhbGlkIHN0eWxlc2hlZXQgc3ludGF4LlxuICAgICAqIEByZXR1cm5zIEFycmF5IG9mIHJ1bGVzIGRhdGEgd2hpY2ggY29udGFpbnM6XG4gICAgICogLSBzZWxlY3RvciBhcyBzdHJpbmc7XG4gICAgICogLSBhc3QgdG8gcXVlcnkgZWxlbWVudHMgYnk7XG4gICAgICogLSBtYXAgb2Ygc3R5bGVzIHRvIGFwcGx5LlxuICAgICAqL1xuXG5cbiAgICBjb25zdCBwYXJzZSA9IChyYXdTdHlsZXNoZWV0LCBleHRDc3NEb2MpID0+IHtcbiAgICAgIGNvbnN0IHN0eWxlc2hlZXQgPSByYXdTdHlsZXNoZWV0LnRyaW0oKTtcblxuICAgICAgaWYgKHN0eWxlc2hlZXQuaW5jbHVkZXMoXCJcIi5jb25jYXQoU0xBU0gpLmNvbmNhdChBU1RFUklTSykpICYmIHN0eWxlc2hlZXQuaW5jbHVkZXMoXCJcIi5jb25jYXQoQVNURVJJU0spLmNvbmNhdChTTEFTSCkpKSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcihcIlwiLmNvbmNhdChTVFlMRVNIRUVUX0VSUk9SX1BSRUZJWC5OT19DT01NRU5ULCBcIjogJ1wiKS5jb25jYXQoc3R5bGVzaGVldCwgXCInXCIpKTtcbiAgICAgIH1cblxuICAgICAgY29uc3QgY29udGV4dCA9IHtcbiAgICAgICAgLy8gYW55IHN0eWxlc2hlZXQgc2hvdWxkIHN0YXJ0IHdpdGggc2VsZWN0b3JcbiAgICAgICAgaXNTZWxlY3RvcjogdHJ1ZSxcbiAgICAgICAgLy8gaW5pdCB2YWx1ZSBvZiBwYXJzZXIgcG9zaXRpb25cbiAgICAgICAgbmV4dEluZGV4OiAwLFxuICAgICAgICAvLyBpbml0IHZhbHVlIG9mIGNzc1RvUGFyc2VcbiAgICAgICAgY3NzVG9QYXJzZTogc3R5bGVzaGVldCxcbiAgICAgICAgLy8gYnVmZmVyIGZvciBjb2xsZWN0aW5nIHNlbGVjdG9yIHBhcnRcbiAgICAgICAgc2VsZWN0b3JCdWZmZXI6ICcnLFxuICAgICAgICAvLyBhY2N1bXVsYXRvciBmb3IgcnVsZXNcbiAgICAgICAgcmF3UnVsZURhdGE6IGluaXRSYXdSdWxlRGF0YVxuICAgICAgfTtcbiAgICAgIGNvbnN0IHJhd1Jlc3VsdHMgPSBuZXcgTWFwKCk7XG4gICAgICBsZXQgc2VsZWN0b3JEYXRhOyAvLyBjb250ZXh0LmNzc1RvUGFyc2UgaXMgZ29pbmcgdG8gYmUgY3JvcHBlZCB3aGlsZSBpdHMgcGFyc2luZ1xuXG4gICAgICB3aGlsZSAoY29udGV4dC5jc3NUb1BhcnNlKSB7XG4gICAgICAgIGlmIChjb250ZXh0LmlzU2VsZWN0b3IpIHtcbiAgICAgICAgICAvLyBmaW5kIGluZGV4IG9mIGZpcnN0IG9wZW5pbmcgY3VybHkgYnJhY2tldFxuICAgICAgICAgIC8vIHdoaWNoIG1heSBtZWFuIHN0YXJ0IG9mIHN0eWxlIHBhcnQgYW5kIGVuZCBvZiBzZWxlY3RvciBvbmVcbiAgICAgICAgICBjb250ZXh0Lm5leHRJbmRleCA9IGNvbnRleHQuY3NzVG9QYXJzZS5pbmRleE9mKEJSQUNLRVRTLkNVUkxZLkxFRlQpOyAvLyBydWxlIHNob3VsZCBub3Qgc3RhcnQgd2l0aCBzdHlsZSwgc2VsZWN0b3IgaXMgcmVxdWlyZWRcbiAgICAgICAgICAvLyBlLmcuICd7IGRpc3BsYXk6IG5vbmU7IH0nXG5cbiAgICAgICAgICBpZiAoY29udGV4dC5zZWxlY3RvckJ1ZmZlci5sZW5ndGggPT09IDAgJiYgY29udGV4dC5uZXh0SW5kZXggPT09IDApIHtcbiAgICAgICAgICAgIHRocm93IG5ldyBFcnJvcihcIlwiLmNvbmNhdChTVFlMRVNIRUVUX0VSUk9SX1BSRUZJWC5OT19TRUxFQ1RPUiwgXCI6ICdcIikuY29uY2F0KGNvbnRleHQuY3NzVG9QYXJzZSwgXCInXCIpKTsgLy8gZXNsaW50LWRpc2FibGUtbGluZSBtYXgtbGVuXG4gICAgICAgICAgfVxuXG4gICAgICAgICAgaWYgKGNvbnRleHQubmV4dEluZGV4ID09PSAtMSkge1xuICAgICAgICAgICAgLy8gbm8gc3R5bGUgZGVjbGFyYXRpb24gaW4gcnVsZVxuICAgICAgICAgICAgLy8gYnV0IHJ1bGUgc3RpbGwgbWF5IGNvbnRhaW4gOnJlbW92ZSgpIHBzZXVkby1jbGFzc1xuICAgICAgICAgICAgY29udGV4dC5zZWxlY3RvckJ1ZmZlciA9IGNvbnRleHQuY3NzVG9QYXJzZTtcbiAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgLy8gY29sbGVjdCBzdHJpbmcgcGFydHMgYmVmb3JlIG9wZW5pbmcgY3VybHkgYnJhY2tldFxuICAgICAgICAgICAgLy8gdW50aWwgdmFsaWQgc2VsZWN0b3IgY29sbGVjdGVkXG4gICAgICAgICAgICBjb250ZXh0LnNlbGVjdG9yQnVmZmVyICs9IGNvbnRleHQuY3NzVG9QYXJzZS5zbGljZSgwLCBjb250ZXh0Lm5leHRJbmRleCk7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgc2VsZWN0b3JEYXRhID0gcGFyc2VTZWxlY3RvclBhcnQoY29udGV4dCwgZXh0Q3NzRG9jKTtcblxuICAgICAgICAgIGlmIChzZWxlY3RvckRhdGEuc3VjY2Vzcykge1xuICAgICAgICAgICAgLy8gc2VsZWN0b3Igc3VjY2Vzc2Z1bGx5IHBhcnNlZFxuICAgICAgICAgICAgY29udGV4dC5yYXdSdWxlRGF0YS5zZWxlY3RvciA9IHNlbGVjdG9yRGF0YS5zZWxlY3Rvci50cmltKCk7XG4gICAgICAgICAgICBjb250ZXh0LnJhd1J1bGVEYXRhLmFzdCA9IHNlbGVjdG9yRGF0YS5hc3Q7XG4gICAgICAgICAgICBjb250ZXh0LnJhd1J1bGVEYXRhLnN0eWxlcyA9IHNlbGVjdG9yRGF0YS5zdHlsZXNPZlNlbGVjdG9yO1xuICAgICAgICAgICAgY29udGV4dC5pc1NlbGVjdG9yID0gZmFsc2U7IC8vIHNhdmUgcnVsZSBkYXRhIGlmIHRoZXJlIGlzIG5vIHN0eWxlIGRlY2xhcmF0aW9uXG5cbiAgICAgICAgICAgIGlmIChjb250ZXh0Lm5leHRJbmRleCA9PT0gLTEpIHtcbiAgICAgICAgICAgICAgc2F2ZVRvUmF3UmVzdWx0cyhyYXdSZXN1bHRzLCBjb250ZXh0LnJhd1J1bGVEYXRhKTsgLy8gY2xlYW4gdXAgcnVsZUNvbnRleHRcblxuICAgICAgICAgICAgICByZXN0b3JlUnVsZUFjYyhjb250ZXh0KTtcbiAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgIC8vIHNraXAgdGhlIG9wZW5pbmcgY3VybHkgYnJhY2tldCBhdCB0aGUgc3RhcnQgb2Ygc3R5bGUgZGVjbGFyYXRpb24gcGFydFxuICAgICAgICAgICAgICBjb250ZXh0Lm5leHRJbmRleCA9IDE7XG4gICAgICAgICAgICAgIGNvbnRleHQuc2VsZWN0b3JCdWZmZXIgPSAnJztcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgLy8gaWYgc2VsZWN0b3Igd2FzIG5vdCBzdWNjZXNzZnVsbHkgcGFyc2VkIHBhcnNlU2VsZWN0b3JQYXJ0KCksIGNvbnRpbnVlIHN0eWxlc2hlZXQgcGFyc2luZzpcbiAgICAgICAgICAgIC8vIHNhdmUgdGhlIGZvdW5kIGJyYWNrZXQgdG8gYnVmZmVyIGFuZCBwcm9jZWVkIHRvIG5leHQgbG9vcCBpdGVyYXRpb25cbiAgICAgICAgICAgIGNvbnRleHQuc2VsZWN0b3JCdWZmZXIgKz0gQlJBQ0tFVFMuQ1VSTFkuTEVGVDsgLy8gZGVsZXRlIGB7YCBmcm9tIGNzc1RvUGFyc2VcblxuICAgICAgICAgICAgY29udGV4dC5jc3NUb1BhcnNlID0gY29udGV4dC5jc3NUb1BhcnNlLnNsaWNlKDEpO1xuICAgICAgICAgIH1cbiAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICB2YXIgX2NvbnRleHQkcmF3UnVsZURhdGEkO1xuXG4gICAgICAgICAgLy8gc3R5bGUgZGVjbGFyYXRpb24gc2hvdWxkIGJlIHBhcnNlZFxuICAgICAgICAgIGNvbnN0IHBhcnNlZFN0eWxlcyA9IHBhcnNlTmV4dFN0eWxlKGNvbnRleHQpOyAvLyBzdHlsZXMgY2FuIGJlIHBhcnNlZCBmcm9tIHNlbGVjdG9yIHBhcnQgaWYgaXQgaGFzIDpyZW1vdmUoKSBwc2V1ZG8tY2xhc3NcbiAgICAgICAgICAvLyBlLmcuICcuYmFubmVyOnJlbW92ZSgpIHsgZGVidWc6IHRydWU7IH0nXG5cbiAgICAgICAgICAoX2NvbnRleHQkcmF3UnVsZURhdGEkID0gY29udGV4dC5yYXdSdWxlRGF0YS5zdHlsZXMpID09PSBudWxsIHx8IF9jb250ZXh0JHJhd1J1bGVEYXRhJCA9PT0gdm9pZCAwID8gdm9pZCAwIDogX2NvbnRleHQkcmF3UnVsZURhdGEkLnB1c2goLi4ucGFyc2VkU3R5bGVzKTsgLy8gc2F2ZSBydWxlIGRhdGEgdG8gcmVzdWx0c1xuXG4gICAgICAgICAgc2F2ZVRvUmF3UmVzdWx0cyhyYXdSZXN1bHRzLCBjb250ZXh0LnJhd1J1bGVEYXRhKTtcbiAgICAgICAgICBjb250ZXh0Lm5leHRJbmRleCA9IDA7IC8vIGNsZWFuIHVwIHJ1bGVDb250ZXh0XG5cbiAgICAgICAgICByZXN0b3JlUnVsZUFjYyhjb250ZXh0KTsgLy8gcGFyc2UgbmV4dCBydWxlIHNlbGVjdG9yIGFmdGVyIHN0eWxlIHN1Y2Nlc3NmdWxseSBwYXJzZWRcblxuICAgICAgICAgIGNvbnRleHQuaXNTZWxlY3RvciA9IHRydWU7XG4gICAgICAgIH1cbiAgICAgIH1cblxuICAgICAgY29uc3QgcmVzdWx0cyA9IFtdO1xuICAgICAgcmF3UmVzdWx0cy5mb3JFYWNoKCh2YWx1ZSwga2V5KSA9PiB7XG4gICAgICAgIGNvbnN0IHNlbGVjdG9yID0ga2V5O1xuICAgICAgICBjb25zdCBhc3QgPSB2YWx1ZS5hc3QsXG4gICAgICAgICAgICAgIHJhd1N0eWxlcyA9IHZhbHVlLnN0eWxlcztcbiAgICAgICAgcmVzdWx0cy5wdXNoKHByZXBhcmVSdWxlRGF0YShzZWxlY3RvciwgYXN0LCByYXdTdHlsZXMpKTtcbiAgICAgIH0pO1xuICAgICAgcmV0dXJuIHJlc3VsdHM7XG4gICAgfTtcblxuICAgIC8qKlxuICAgICAqIENoZWNrcyB3aGV0aGVyIHBhc3NlZCBgYXJnYCBpcyBudW1iZXIgdHlwZS5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBhcmcgVmFsdWUgdG8gY2hlY2suXG4gICAgICovXG4gICAgY29uc3QgaXNOdW1iZXIgPSBhcmcgPT4ge1xuICAgICAgcmV0dXJuIHR5cGVvZiBhcmcgPT09ICdudW1iZXInICYmICFOdW1iZXIuaXNOYU4oYXJnKTtcbiAgICB9O1xuXG4gICAgY29uc3QgaXNTdXBwb3J0ZWQgPSB0eXBlb2Ygd2luZG93LnJlcXVlc3RBbmltYXRpb25GcmFtZSAhPT0gJ3VuZGVmaW5lZCc7XG4gICAgY29uc3QgdGltZW91dCA9IGlzU3VwcG9ydGVkID8gcmVxdWVzdEFuaW1hdGlvbkZyYW1lIDogd2luZG93LnNldFRpbWVvdXQ7XG4gICAgY29uc3QgZGVsZXRlVGltZW91dCA9IGlzU3VwcG9ydGVkID8gY2FuY2VsQW5pbWF0aW9uRnJhbWUgOiBjbGVhclRpbWVvdXQ7XG4gICAgY29uc3QgcGVyZiA9IGlzU3VwcG9ydGVkID8gcGVyZm9ybWFuY2UgOiBEYXRlO1xuICAgIGNvbnN0IERFRkFVTFRfVEhST1RUTEVfREVMQVlfTVMgPSAxNTA7XG5cbiAgICAvKipcbiAgICAgKiBUaGUgcHVycG9zZSBvZiBUaHJvdHRsZVdyYXBwZXIgaXMgdG8gdGhyb3R0bGUgY2FsbHMgb2YgdGhlIGZ1bmN0aW9uXG4gICAgICogdGhhdCBhcHBsaWVzIEV4dGVuZGVkQ3NzIHJ1bGVzLiBUaGUgcmVhc29uaW5nIGhlcmUgaXMgdGhhdCB0aGUgZnVuY3Rpb24gY2FsbHNcbiAgICAgKiBhcmUgdHJpZ2dlcmVkIGJ5IE11dGF0aW9uT2JzZXJ2ZXIgYW5kIHRoZXJlIG1heSBiZSBtYW55IG11dGF0aW9ucyBpbiBhIHNob3J0IHBlcmlvZCBvZiB0aW1lLlxuICAgICAqIFdlIGRvIG5vdCB3YW50IHRvIGFwcGx5IHJ1bGVzIG9uIGV2ZXJ5IG11dGF0aW9uIHNvIHdlIHVzZSB0aGlzIGhlbHBlciB0byBtYWtlIHN1cmVcbiAgICAgKiB0aGF0IHRoZXJlIGlzIG9ubHkgb25lIGNhbGwgaW4gdGhlIGdpdmVuIGFtb3VudCBvZiB0aW1lLlxuICAgICAqL1xuICAgIGNsYXNzIFRocm90dGxlV3JhcHBlciB7XG4gICAgICAvKipcbiAgICAgICAqIFRoZSBwcm92aWRlZCBjYWxsYmFjayBzaG91bGQgYmUgZXhlY3V0ZWQgdHdpY2UgaW4gdGhpcyB0aW1lIGZyYW1lOlxuICAgICAgICogdmVyeSBmaXJzdCB0aW1lIGFuZCBub3QgbW9yZSBvZnRlbiB0aGFuIHRocm90dGxlRGVsYXlNcyBmb3IgZnVydGhlciBleGVjdXRpb25zLlxuICAgICAgICpcbiAgICAgICAqIEBzZWUge0BsaW5rIFRocm90dGxlV3JhcHBlci5ydW59XG4gICAgICAgKi9cblxuICAgICAgLyoqXG4gICAgICAgKiBDcmVhdGVzIG5ldyBUaHJvdHRsZVdyYXBwZXIuXG4gICAgICAgKlxuICAgICAgICogQHBhcmFtIGNvbnRleHQgRXh0ZW5kZWRDc3MgY29udGV4dC5cbiAgICAgICAqIEBwYXJhbSBjYWxsYmFjayBUaGUgY2FsbGJhY2suXG4gICAgICAgKiBAcGFyYW0gdGhyb3R0bGVNcyBUaHJvdHRsZSBkZWxheSBpbiBtcy5cbiAgICAgICAqL1xuICAgICAgY29uc3RydWN0b3IoY29udGV4dCwgY2FsbGJhY2ssIHRocm90dGxlTXMpIHtcbiAgICAgICAgdGhpcy5jb250ZXh0ID0gY29udGV4dDtcbiAgICAgICAgdGhpcy5jYWxsYmFjayA9IGNhbGxiYWNrO1xuICAgICAgICB0aGlzLnRocm90dGxlRGVsYXlNcyA9IHRocm90dGxlTXMgfHwgREVGQVVMVF9USFJPVFRMRV9ERUxBWV9NUztcbiAgICAgICAgdGhpcy53cmFwcGVkQ2IgPSB0aGlzLndyYXBwZWRDYWxsYmFjay5iaW5kKHRoaXMpO1xuICAgICAgfVxuICAgICAgLyoqXG4gICAgICAgKiBXcmFwcyB0aGUgY2FsbGJhY2sgKHdoaWNoIHN1cHBvc2VkIHRvIGJlIGBhcHBseVJ1bGVzYCksXG4gICAgICAgKiBuZWVkZWQgdG8gdXBkYXRlIGBsYXN0UnVuVGltZWAgYW5kIGNsZWFuIHByZXZpb3VzIHRpbWVvdXRzIGZvciBwcm9wZXIgZXhlY3V0aW9uIG9mIHRoZSBjYWxsYmFjay5cbiAgICAgICAqXG4gICAgICAgKiBAcGFyYW0gdGltZXN0YW1wIFRpbWVzdGFtcC5cbiAgICAgICAqL1xuXG5cbiAgICAgIHdyYXBwZWRDYWxsYmFjayh0aW1lc3RhbXApIHtcbiAgICAgICAgdGhpcy5sYXN0UnVuVGltZSA9IGlzTnVtYmVyKHRpbWVzdGFtcCkgPyB0aW1lc3RhbXAgOiBwZXJmLm5vdygpOyAvLyBgdGltZW91dElkYCBjYW4gYmUgcmVxdWVzdEFuaW1hdGlvbkZyYW1lLXJlbGF0ZWRcbiAgICAgICAgLy8gc28gY2FuY2VsQW5pbWF0aW9uRnJhbWUoKSBhcyBkZWxldGVUaW1lb3V0KCkgbmVlZHMgdGhlIGFyZyB0byBiZSBkZWZpbmVkXG5cbiAgICAgICAgaWYgKHRoaXMudGltZW91dElkKSB7XG4gICAgICAgICAgZGVsZXRlVGltZW91dCh0aGlzLnRpbWVvdXRJZCk7XG4gICAgICAgICAgZGVsZXRlIHRoaXMudGltZW91dElkO1xuICAgICAgICB9XG5cbiAgICAgICAgY2xlYXJUaW1lb3V0KHRoaXMudGltZXJJZCk7XG4gICAgICAgIGRlbGV0ZSB0aGlzLnRpbWVySWQ7XG5cbiAgICAgICAgaWYgKHRoaXMuY2FsbGJhY2spIHtcbiAgICAgICAgICB0aGlzLmNhbGxiYWNrKHRoaXMuY29udGV4dCk7XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICAgIC8qKlxuICAgICAgICogSW5kaWNhdGVzIHdoZXRoZXIgdGhlcmUgaXMgYSBzY2hlZHVsZWQgY2FsbGJhY2suXG4gICAgICAgKi9cblxuXG4gICAgICBoYXNQZW5kaW5nQ2FsbGJhY2soKSB7XG4gICAgICAgIHJldHVybiBpc051bWJlcih0aGlzLnRpbWVvdXRJZCkgfHwgaXNOdW1iZXIodGhpcy50aW1lcklkKTtcbiAgICAgIH1cbiAgICAgIC8qKlxuICAgICAgICogU2NoZWR1bGVzIHRoZSBmdW5jdGlvbiB3aGljaCBhcHBsaWVzIEV4dGVuZGVkQ3NzIHJ1bGVzIGJlZm9yZSB0aGUgbmV4dCBhbmltYXRpb24gZnJhbWUuXG4gICAgICAgKlxuICAgICAgICogV3JhcHMgZnVuY3Rpb24gZXhlY3V0aW9uIGludG8gYHRpbWVvdXRgIOKAlCByZXF1ZXN0QW5pbWF0aW9uRnJhbWUgb3Igc2V0VGltZW91dC5cbiAgICAgICAqIEZvciB0aGUgZmlyc3QgdGltZSBydW5zIHRoZSBmdW5jdGlvbiB3aXRob3V0IGFueSBjb25kaXRpb24uXG4gICAgICAgKiBBcyBpdCBtYXkgYmUgdHJpZ2dlcmVkIGJ5IGFueSBtdXRhdGlvbiB3aGljaCBtYXkgb2NjdXIgdG9vIG9mdGVyLCB3ZSBsaW1pdCB0aGUgZnVuY3Rpb24gZXhlY3V0aW9uOlxuICAgICAgICogMS4gSWYgYGVsYXBzZWRUaW1lYCBzaW5jZSBsYXN0IGZ1bmN0aW9uIGV4ZWN1dGlvbiBpcyBsZXNzIHRoZW4gc2V0IGB0aHJvdHRsZURlbGF5TXNgLFxuICAgICAgICogbmV4dCBmdW5jdGlvbiBjYWxsIGlzIGhvbGQgdGlsbCB0aGUgZW5kIG9mIHRocm90dGxlIGludGVydmFsIChzdWJ0cmFjdGluZyBgZWxhcHNlZGAgZnJvbSBgdGhyb3R0bGVEZWxheU1zYCk7XG4gICAgICAgKiAyLiBEbyBub3RoaW5nIGlmIHRyaWdnZXJlZCBhZ2FpbiBidXQgZnVuY3Rpb24gY2FsbCB3aGljaCBpcyBvbiBob2xkIGhhcyBub3QgeWV0IHN0YXJ0ZWQgaXRzIGV4ZWN1dGlvbi5cbiAgICAgICAqL1xuXG5cbiAgICAgIHJ1bigpIHtcbiAgICAgICAgaWYgKHRoaXMuaGFzUGVuZGluZ0NhbGxiYWNrKCkpIHtcbiAgICAgICAgICAvLyB0aGVyZSBpcyBhIHBlbmRpbmcgZXhlY3V0aW9uIHNjaGVkdWxlZFxuICAgICAgICAgIHJldHVybjtcbiAgICAgICAgfVxuXG4gICAgICAgIGlmICh0eXBlb2YgdGhpcy5sYXN0UnVuVGltZSAhPT0gJ3VuZGVmaW5lZCcpIHtcbiAgICAgICAgICBjb25zdCBlbGFwc2VkVGltZSA9IHBlcmYubm93KCkgLSB0aGlzLmxhc3RSdW5UaW1lO1xuXG4gICAgICAgICAgaWYgKGVsYXBzZWRUaW1lIDwgdGhpcy50aHJvdHRsZURlbGF5TXMpIHtcbiAgICAgICAgICAgIHRoaXMudGltZXJJZCA9IHdpbmRvdy5zZXRUaW1lb3V0KHRoaXMud3JhcHBlZENiLCB0aGlzLnRocm90dGxlRGVsYXlNcyAtIGVsYXBzZWRUaW1lKTtcbiAgICAgICAgICAgIHJldHVybjtcbiAgICAgICAgICB9XG4gICAgICAgIH1cblxuICAgICAgICB0aGlzLnRpbWVvdXRJZCA9IHRpbWVvdXQodGhpcy53cmFwcGVkQ2IpO1xuICAgICAgfVxuICAgICAgLyoqXG4gICAgICAgKiBSZXR1cm5zIHRpbWVzdGFtcCBmb3IgJ25vdycuXG4gICAgICAgKi9cblxuXG4gICAgICBzdGF0aWMgbm93KCkge1xuICAgICAgICByZXR1cm4gcGVyZi5ub3coKTtcbiAgICAgIH1cblxuICAgIH1cblxuICAgIGNvbnN0IExBU1RfRVZFTlRfVElNRU9VVF9NUyA9IDEwO1xuICAgIGNvbnN0IElHTk9SRURfRVZFTlRTID0gWydtb3VzZW92ZXInLCAnbW91c2VsZWF2ZScsICdtb3VzZWVudGVyJywgJ21vdXNlb3V0J107XG4gICAgY29uc3QgU1VQUE9SVEVEX0VWRU5UUyA9IFsvLyBrZXlib2FyZCBldmVudHNcbiAgICAna2V5ZG93bicsICdrZXlwcmVzcycsICdrZXl1cCcsIC8vIG1vdXNlIGV2ZW50c1xuICAgICdhdXhjbGljaycsICdjbGljaycsICdjb250ZXh0bWVudScsICdkYmxjbGljaycsICdtb3VzZWRvd24nLCAnbW91c2VlbnRlcicsICdtb3VzZWxlYXZlJywgJ21vdXNlbW92ZScsICdtb3VzZW92ZXInLCAnbW91c2VvdXQnLCAnbW91c2V1cCcsICdwb2ludGVybG9ja2NoYW5nZScsICdwb2ludGVybG9ja2Vycm9yJywgJ3NlbGVjdCcsICd3aGVlbCddOyAvLyAnd2hlZWwnIGV2ZW50IG1ha2VzIHNjcm9sbGluZyBpbiBTYWZhcmkgdHdpdGNoeVxuICAgIC8vIGh0dHBzOi8vZ2l0aHViLmNvbS9BZGd1YXJkVGVhbS9FeHRlbmRlZENzcy9pc3N1ZXMvMTIwXG5cbiAgICBjb25zdCBTQUZBUklfUFJPQkxFTUFUSUNfRVZFTlRTID0gWyd3aGVlbCddO1xuICAgIC8qKlxuICAgICAqIFdlIHVzZSBFdmVudFRyYWNrZXIgdG8gdHJhY2sgdGhlIGV2ZW50IHRoYXQgaXMgbGlrZWx5IHRvIGNhdXNlIHRoZSBtdXRhdGlvbi5cbiAgICAgKiBUaGUgcHJvYmxlbSBpcyB0aGF0IHdlIGNhbm5vdCB1c2UgYHdpbmRvdy5ldmVudGAgZGlyZWN0bHkgZnJvbSB0aGUgbXV0YXRpb24gb2JzZXJ2ZXIgY2FsbFxuICAgICAqIGFzIHdlJ3JlIG5vdCBpbiB0aGUgZXZlbnQgaGFuZGxlciBjb250ZXh0IGFueW1vcmUuXG4gICAgICovXG5cbiAgICBjbGFzcyBFdmVudFRyYWNrZXIge1xuICAgICAgLyoqXG4gICAgICAgKiBDcmVhdGVzIG5ldyBFdmVudFRyYWNrZXIuXG4gICAgICAgKi9cbiAgICAgIGNvbnN0cnVjdG9yKCkge1xuICAgICAgICBfZGVmaW5lUHJvcGVydHkodGhpcywgXCJnZXRMYXN0RXZlbnRUeXBlXCIsICgpID0+IHRoaXMubGFzdEV2ZW50VHlwZSk7XG5cbiAgICAgICAgX2RlZmluZVByb3BlcnR5KHRoaXMsIFwiZ2V0VGltZVNpbmNlTGFzdEV2ZW50XCIsICgpID0+IHtcbiAgICAgICAgICBpZiAoIXRoaXMubGFzdEV2ZW50VGltZSkge1xuICAgICAgICAgICAgcmV0dXJuIG51bGw7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgcmV0dXJuIERhdGUubm93KCkgLSB0aGlzLmxhc3RFdmVudFRpbWU7XG4gICAgICAgIH0pO1xuXG4gICAgICAgIHRoaXMudHJhY2tlZEV2ZW50cyA9IGlzU2FmYXJpQnJvd3NlciA/IFNVUFBPUlRFRF9FVkVOVFMuZmlsdGVyKGV2ZW50ID0+ICFTQUZBUklfUFJPQkxFTUFUSUNfRVZFTlRTLmluY2x1ZGVzKGV2ZW50KSkgOiBTVVBQT1JURURfRVZFTlRTO1xuICAgICAgICB0aGlzLnRyYWNrZWRFdmVudHMuZm9yRWFjaChldmVudE5hbWUgPT4ge1xuICAgICAgICAgIGRvY3VtZW50LmRvY3VtZW50RWxlbWVudC5hZGRFdmVudExpc3RlbmVyKGV2ZW50TmFtZSwgdGhpcy50cmFja0V2ZW50LCB0cnVlKTtcbiAgICAgICAgfSk7XG4gICAgICB9XG4gICAgICAvKipcbiAgICAgICAqIENhbGxiYWNrIGZvciBldmVudCBsaXN0ZW5lciBmb3IgZXZlbnRzIHRyYWNraW5nLlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSBldmVudCBBbnkgZXZlbnQuXG4gICAgICAgKi9cblxuXG4gICAgICB0cmFja0V2ZW50KGV2ZW50KSB7XG4gICAgICAgIHRoaXMubGFzdEV2ZW50VHlwZSA9IGV2ZW50LnR5cGU7XG4gICAgICAgIHRoaXMubGFzdEV2ZW50VGltZSA9IERhdGUubm93KCk7XG4gICAgICB9XG5cbiAgICAgIC8qKlxuICAgICAgICogQ2hlY2tzIHdoZXRoZXIgdGhlIGxhc3QgY2F1Z2h0IGV2ZW50IHNob3VsZCBiZSBpZ25vcmVkLlxuICAgICAgICovXG4gICAgICBpc0lnbm9yZWRFdmVudFR5cGUoKSB7XG4gICAgICAgIGNvbnN0IGxhc3RFdmVudFR5cGUgPSB0aGlzLmdldExhc3RFdmVudFR5cGUoKTtcbiAgICAgICAgY29uc3Qgc2luY2VMYXN0RXZlbnRUaW1lID0gdGhpcy5nZXRUaW1lU2luY2VMYXN0RXZlbnQoKTtcbiAgICAgICAgcmV0dXJuICEhbGFzdEV2ZW50VHlwZSAmJiBJR05PUkVEX0VWRU5UUy5pbmNsdWRlcyhsYXN0RXZlbnRUeXBlKSAmJiAhIXNpbmNlTGFzdEV2ZW50VGltZSAmJiBzaW5jZUxhc3RFdmVudFRpbWUgPCBMQVNUX0VWRU5UX1RJTUVPVVRfTVM7XG4gICAgICB9XG4gICAgICAvKipcbiAgICAgICAqIFN0b3BzIGV2ZW50IHRyYWNraW5nIGJ5IHJlbW92aW5nIGV2ZW50IGxpc3RlbmVyLlxuICAgICAgICovXG5cblxuICAgICAgc3RvcFRyYWNraW5nKCkge1xuICAgICAgICB0aGlzLnRyYWNrZWRFdmVudHMuZm9yRWFjaChldmVudE5hbWUgPT4ge1xuICAgICAgICAgIGRvY3VtZW50LmRvY3VtZW50RWxlbWVudC5yZW1vdmVFdmVudExpc3RlbmVyKGV2ZW50TmFtZSwgdGhpcy50cmFja0V2ZW50LCB0cnVlKTtcbiAgICAgICAgfSk7XG4gICAgICB9XG5cbiAgICB9XG5cbiAgICBjb25zdCBpc0V2ZW50TGlzdGVuZXJTdXBwb3J0ZWQgPSB0eXBlb2Ygd2luZG93LmFkZEV2ZW50TGlzdGVuZXIgIT09ICd1bmRlZmluZWQnO1xuXG4gICAgY29uc3Qgb2JzZXJ2ZURvY3VtZW50ID0gKGNvbnRleHQsIGNhbGxiYWNrKSA9PiB7XG4gICAgICAvLyBXZSBhcmUgdHJ5aW5nIHRvIGxpbWl0IHRoZSBudW1iZXIgb2YgY2FsbGJhY2sgY2FsbHMgYnkgbm90IGNhbGxpbmcgaXQgb24gYWxsIGtpbmQgb2YgXCJob3ZlclwiIGV2ZW50cy5cbiAgICAgIC8vIFRoZSByYXRpb25hbGUgYmVoaW5kIHRoaXMgaXMgdGhhdCBcImhvdmVyXCIgZXZlbnRzIG9mdGVuIGNhdXNlIGF0dHJpYnV0ZXMgbW9kaWZpY2F0aW9uLFxuICAgICAgLy8gYnV0IHJlLWFwcGx5aW5nIGV4dENTUyBydWxlcyB3aWxsIGJlIHVzZWxlc3MgYXMgdGhlc2UgYXR0cmlidXRlIGNoYW5nZXMgYXJlIHVzdWFsbHkgdHJhbnNpZW50LlxuICAgICAgY29uc3Qgc2hvdWxkSWdub3JlTXV0YXRpb25zID0gbXV0YXRpb25zID0+IHtcbiAgICAgICAgLy8gaWdub3JlIGlmIGFsbCBtdXRhdGlvbnMgYXJlIGFib3V0IGF0dHJpYnV0ZXMgY2hhbmdlc1xuICAgICAgICByZXR1cm4gbXV0YXRpb25zLmV2ZXJ5KG0gPT4gbS50eXBlID09PSAnYXR0cmlidXRlcycpO1xuICAgICAgfTtcblxuICAgICAgaWYgKG5hdGl2ZXMuTXV0YXRpb25PYnNlcnZlcikge1xuICAgICAgICBjb250ZXh0LmRvbU11dGF0aW9uT2JzZXJ2ZXIgPSBuZXcgbmF0aXZlcy5NdXRhdGlvbk9ic2VydmVyKG11dGF0aW9ucyA9PiB7XG4gICAgICAgICAgaWYgKCFtdXRhdGlvbnMgfHwgbXV0YXRpb25zLmxlbmd0aCA9PT0gMCkge1xuICAgICAgICAgICAgcmV0dXJuO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIGNvbnN0IGV2ZW50VHJhY2tlciA9IG5ldyBFdmVudFRyYWNrZXIoKTtcblxuICAgICAgICAgIGlmIChldmVudFRyYWNrZXIuaXNJZ25vcmVkRXZlbnRUeXBlKCkgJiYgc2hvdWxkSWdub3JlTXV0YXRpb25zKG11dGF0aW9ucykpIHtcbiAgICAgICAgICAgIHJldHVybjtcbiAgICAgICAgICB9IC8vIHNhdmUgaW5zdGFuY2Ugb2YgRXZlbnRUcmFja2VyIHRvIGNvbnRleHRcbiAgICAgICAgICAvLyBmb3IgcmVtb3ZpbmcgaXRzIGV2ZW50IGxpc3RlbmVycyBvbiBkaXNjb25uZWN0RG9jdW1lbnQoKSB3aGlsZSBtYWluRGlzY29ubmVjdCgpXG5cblxuICAgICAgICAgIGNvbnRleHQuZXZlbnRUcmFja2VyID0gZXZlbnRUcmFja2VyO1xuICAgICAgICAgIGNhbGxiYWNrKCk7XG4gICAgICAgIH0pO1xuICAgICAgICBjb250ZXh0LmRvbU11dGF0aW9uT2JzZXJ2ZXIub2JzZXJ2ZShkb2N1bWVudCwge1xuICAgICAgICAgIGNoaWxkTGlzdDogdHJ1ZSxcbiAgICAgICAgICBzdWJ0cmVlOiB0cnVlLFxuICAgICAgICAgIGF0dHJpYnV0ZXM6IHRydWUsXG4gICAgICAgICAgYXR0cmlidXRlRmlsdGVyOiBbJ2lkJywgJ2NsYXNzJ11cbiAgICAgICAgfSk7XG4gICAgICB9IGVsc2UgaWYgKGlzRXZlbnRMaXN0ZW5lclN1cHBvcnRlZCkge1xuICAgICAgICBkb2N1bWVudC5hZGRFdmVudExpc3RlbmVyKCdET01Ob2RlSW5zZXJ0ZWQnLCBjYWxsYmFjaywgZmFsc2UpO1xuICAgICAgICBkb2N1bWVudC5hZGRFdmVudExpc3RlbmVyKCdET01Ob2RlUmVtb3ZlZCcsIGNhbGxiYWNrLCBmYWxzZSk7XG4gICAgICAgIGRvY3VtZW50LmFkZEV2ZW50TGlzdGVuZXIoJ0RPTUF0dHJNb2RpZmllZCcsIGNhbGxiYWNrLCBmYWxzZSk7XG4gICAgICB9XG4gICAgfTtcblxuICAgIGNvbnN0IGRpc2Nvbm5lY3REb2N1bWVudCA9IChjb250ZXh0LCBjYWxsYmFjaykgPT4ge1xuICAgICAgdmFyIF9jb250ZXh0JGV2ZW50VHJhY2tlcjtcblxuICAgICAgaWYgKGNvbnRleHQuZG9tTXV0YXRpb25PYnNlcnZlcikge1xuICAgICAgICBjb250ZXh0LmRvbU11dGF0aW9uT2JzZXJ2ZXIuZGlzY29ubmVjdCgpO1xuICAgICAgfSBlbHNlIGlmIChpc0V2ZW50TGlzdGVuZXJTdXBwb3J0ZWQpIHtcbiAgICAgICAgZG9jdW1lbnQucmVtb3ZlRXZlbnRMaXN0ZW5lcignRE9NTm9kZUluc2VydGVkJywgY2FsbGJhY2ssIGZhbHNlKTtcbiAgICAgICAgZG9jdW1lbnQucmVtb3ZlRXZlbnRMaXN0ZW5lcignRE9NTm9kZVJlbW92ZWQnLCBjYWxsYmFjaywgZmFsc2UpO1xuICAgICAgICBkb2N1bWVudC5yZW1vdmVFdmVudExpc3RlbmVyKCdET01BdHRyTW9kaWZpZWQnLCBjYWxsYmFjaywgZmFsc2UpO1xuICAgICAgfSAvLyBjbGVhbiB1cCBldmVudCBsaXN0ZW5lcnNcblxuXG4gICAgICAoX2NvbnRleHQkZXZlbnRUcmFja2VyID0gY29udGV4dC5ldmVudFRyYWNrZXIpID09PSBudWxsIHx8IF9jb250ZXh0JGV2ZW50VHJhY2tlciA9PT0gdm9pZCAwID8gdm9pZCAwIDogX2NvbnRleHQkZXZlbnRUcmFja2VyLnN0b3BUcmFja2luZygpO1xuICAgIH07XG5cbiAgICBjb25zdCBtYWluT2JzZXJ2ZSA9IChjb250ZXh0LCBtYWluQ2FsbGJhY2spID0+IHtcbiAgICAgIGlmIChjb250ZXh0LmlzRG9tT2JzZXJ2ZWQpIHtcbiAgICAgICAgcmV0dXJuO1xuICAgICAgfSAvLyBoYW5kbGUgZHluYW1pY2FsbHkgYWRkZWQgZWxlbWVudHNcblxuXG4gICAgICBjb250ZXh0LmlzRG9tT2JzZXJ2ZWQgPSB0cnVlO1xuICAgICAgb2JzZXJ2ZURvY3VtZW50KGNvbnRleHQsIG1haW5DYWxsYmFjayk7XG4gICAgfTtcbiAgICBjb25zdCBtYWluRGlzY29ubmVjdCA9IChjb250ZXh0LCBtYWluQ2FsbGJhY2spID0+IHtcbiAgICAgIGlmICghY29udGV4dC5pc0RvbU9ic2VydmVkKSB7XG4gICAgICAgIHJldHVybjtcbiAgICAgIH1cblxuICAgICAgY29udGV4dC5pc0RvbU9ic2VydmVkID0gZmFsc2U7XG4gICAgICBkaXNjb25uZWN0RG9jdW1lbnQoY29udGV4dCwgbWFpbkNhbGxiYWNrKTtcbiAgICB9O1xuXG4gICAgLyoqXG4gICAgICogUmVtb3ZlcyBhZmZlY3RlZEVsZW1lbnQubm9kZSBmcm9tIERPTS5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBjb250ZXh0IEV4dGVuZGVkQ3NzIGNvbnRleHQuXG4gICAgICogQHBhcmFtIGFmZmVjdGVkRWxlbWVudCBBZmZlY3RlZCBlbGVtZW50LlxuICAgICAqL1xuXG4gICAgY29uc3QgcmVtb3ZlRWxlbWVudCA9IChjb250ZXh0LCBhZmZlY3RlZEVsZW1lbnQpID0+IHtcbiAgICAgIGNvbnN0IG5vZGUgPSBhZmZlY3RlZEVsZW1lbnQubm9kZTtcbiAgICAgIGFmZmVjdGVkRWxlbWVudC5yZW1vdmVkID0gdHJ1ZTtcbiAgICAgIGNvbnN0IGVsZW1lbnRTZWxlY3RvciA9IGdldEVsZW1lbnRTZWxlY3RvclBhdGgobm9kZSk7IC8vIGNoZWNrIGlmIHRoZSBlbGVtZW50IGhhcyBiZWVuIGFscmVhZHkgcmVtb3ZlZCBlYXJsaWVyXG5cbiAgICAgIGNvbnN0IGVsZW1lbnRSZW1vdmFsc0NvdW50ZXIgPSBjb250ZXh0LnJlbW92YWxzU3RhdGlzdGljW2VsZW1lbnRTZWxlY3Rvcl0gfHwgMDsgLy8gaWYgcmVtb3ZhbHMgYXR0ZW1wdHMgaGFwcGVuZWQgbW9yZSB0aGFuIHNwZWNpZmllZCB3ZSBkbyBub3QgdHJ5IHRvIHJlbW92ZSBub2RlIGFnYWluXG5cbiAgICAgIGlmIChlbGVtZW50UmVtb3ZhbHNDb3VudGVyID4gTUFYX1NUWUxFX1BST1RFQ1RJT05fQ09VTlQpIHtcbiAgICAgICAgbG9nZ2VyLmVycm9yKFwiRXh0ZW5kZWRDc3M6IGluZmluaXRlIGxvb3AgcHJvdGVjdGlvbiBmb3Igc2VsZWN0b3I6ICdcIi5jb25jYXQoZWxlbWVudFNlbGVjdG9yLCBcIidcIikpO1xuICAgICAgICByZXR1cm47XG4gICAgICB9XG5cbiAgICAgIGlmIChub2RlLnBhcmVudEVsZW1lbnQpIHtcbiAgICAgICAgbm9kZS5wYXJlbnRFbGVtZW50LnJlbW92ZUNoaWxkKG5vZGUpO1xuICAgICAgICBjb250ZXh0LnJlbW92YWxzU3RhdGlzdGljW2VsZW1lbnRTZWxlY3Rvcl0gPSBlbGVtZW50UmVtb3ZhbHNDb3VudGVyICsgMTtcbiAgICAgIH1cbiAgICB9O1xuICAgIC8qKlxuICAgICAqIFNldHMgc3R5bGUgdG8gdGhlIHNwZWNpZmllZCBET00gbm9kZS5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBub2RlIERPTSBlbGVtZW50LlxuICAgICAqIEBwYXJhbSBzdHlsZSBTdHlsZSB0byBzZXQuXG4gICAgICovXG5cblxuICAgIGNvbnN0IHNldFN0eWxlVG9FbGVtZW50ID0gKG5vZGUsIHN0eWxlKSA9PiB7XG4gICAgICBpZiAoIShub2RlIGluc3RhbmNlb2YgSFRNTEVsZW1lbnQpKSB7XG4gICAgICAgIHJldHVybjtcbiAgICAgIH1cblxuICAgICAgT2JqZWN0LmtleXMoc3R5bGUpLmZvckVhY2gocHJvcCA9PiB7XG4gICAgICAgIC8vIEFwcGx5IHRoaXMgc3R5bGUgb25seSB0byBleGlzdGluZyBwcm9wZXJ0aWVzXG4gICAgICAgIC8vIFdlIGNhbid0IHVzZSBoYXNPd25Qcm9wZXJ0eSBoZXJlIChkb2VzIG5vdCB3b3JrIGluIEZGKVxuICAgICAgICBpZiAodHlwZW9mIG5vZGUuc3R5bGUuZ2V0UHJvcGVydHlWYWx1ZShwcm9wKSAhPT0gJ3VuZGVmaW5lZCcpIHtcbiAgICAgICAgICBsZXQgdmFsdWUgPSBzdHlsZVtwcm9wXTsgLy8gRmlyc3Qgd2Ugc2hvdWxkIHJlbW92ZSAhaW1wb3J0YW50IGF0dHJpYnV0ZSAob3IgaXQgd29uJ3QgYmUgYXBwbGllZCcpXG5cbiAgICAgICAgICB2YWx1ZSA9IHJlbW92ZVN1ZmZpeCh2YWx1ZS50cmltKCksICchaW1wb3J0YW50JykudHJpbSgpO1xuICAgICAgICAgIG5vZGUuc3R5bGUuc2V0UHJvcGVydHkocHJvcCwgdmFsdWUsICdpbXBvcnRhbnQnKTtcbiAgICAgICAgfVxuICAgICAgfSk7XG4gICAgfTtcbiAgICAvKipcbiAgICAgKiBBcHBsaWVzIHN0eWxlIHRvIHRoZSBzcGVjaWZpZWQgRE9NIG5vZGUuXG4gICAgICpcbiAgICAgKiBAcGFyYW0gY29udGV4dCBFeHRlbmRlZENzcyBjb250ZXh0LlxuICAgICAqIEBwYXJhbSBhZmZlY3RlZEVsZW1lbnQgT2JqZWN0IGNvbnRhaW5pbmcgRE9NIG5vZGUgYW5kIHJ1bGUgdG8gYmUgYXBwbGllZC5cbiAgICAgKlxuICAgICAqIEB0aHJvd3MgQW4gZXJyb3IgaWYgYWZmZWN0ZWRFbGVtZW50IGhhcyBubyBzdHlsZSB0byBhcHBseS5cbiAgICAgKi9cblxuICAgIGNvbnN0IGFwcGx5U3R5bGUgPSAoY29udGV4dCwgYWZmZWN0ZWRFbGVtZW50KSA9PiB7XG4gICAgICBpZiAoYWZmZWN0ZWRFbGVtZW50LnByb3RlY3Rpb25PYnNlcnZlcikge1xuICAgICAgICAvLyBzdHlsZSBpcyBhbHJlYWR5IGFwcGxpZWQgYW5kIHByb3RlY3RlZCBieSB0aGUgb2JzZXJ2ZXJcbiAgICAgICAgcmV0dXJuO1xuICAgICAgfVxuXG4gICAgICBpZiAoY29udGV4dC5iZWZvcmVTdHlsZUFwcGxpZWQpIHtcbiAgICAgICAgYWZmZWN0ZWRFbGVtZW50ID0gY29udGV4dC5iZWZvcmVTdHlsZUFwcGxpZWQoYWZmZWN0ZWRFbGVtZW50KTtcblxuICAgICAgICBpZiAoIWFmZmVjdGVkRWxlbWVudCkge1xuICAgICAgICAgIHJldHVybjtcbiAgICAgICAgfVxuICAgICAgfVxuXG4gICAgICBjb25zdCBfYWZmZWN0ZWRFbGVtZW50ID0gYWZmZWN0ZWRFbGVtZW50LFxuICAgICAgICAgICAgbm9kZSA9IF9hZmZlY3RlZEVsZW1lbnQubm9kZSxcbiAgICAgICAgICAgIHJ1bGVzID0gX2FmZmVjdGVkRWxlbWVudC5ydWxlcztcblxuICAgICAgZm9yIChsZXQgaSA9IDA7IGkgPCBydWxlcy5sZW5ndGg7IGkgKz0gMSkge1xuICAgICAgICBjb25zdCBfcnVsZXMkaSA9IHJ1bGVzW2ldLFxuICAgICAgICAgICAgICBzZWxlY3RvciA9IF9ydWxlcyRpLnNlbGVjdG9yLFxuICAgICAgICAgICAgICBzdHlsZSA9IF9ydWxlcyRpLnN0eWxlLFxuICAgICAgICAgICAgICBkZWJ1ZyA9IF9ydWxlcyRpLmRlYnVnOyAvLyBydWxlIG1heSBub3QgaGF2ZSBzdHlsZSB0byBhcHBseVxuICAgICAgICAvLyBlLmcuICdkaXY6aGFzKD4gYSkgeyBkZWJ1ZzogdHJ1ZSB9JyAtPiBtZWFucyBubyBzdHlsZSB0byBhcHBseSwgYW5kIGVuYWJsZSBkZWJ1ZyBtb2RlXG5cbiAgICAgICAgaWYgKHN0eWxlKSB7XG4gICAgICAgICAgaWYgKHN0eWxlW1JFTU9WRV9QU0VVRE9fTUFSS0VSXSA9PT0gUFNFVURPX1BST1BFUlRZX1BPU0lUSVZFX1ZBTFVFKSB7XG4gICAgICAgICAgICByZW1vdmVFbGVtZW50KGNvbnRleHQsIGFmZmVjdGVkRWxlbWVudCk7XG4gICAgICAgICAgICByZXR1cm47XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgc2V0U3R5bGVUb0VsZW1lbnQobm9kZSwgc3R5bGUpO1xuICAgICAgICB9IGVsc2UgaWYgKCFkZWJ1Zykge1xuICAgICAgICAgIC8vIGJ1dCBydWxlIHNob3VsZCBub3QgaGF2ZSBib3RoIHN0eWxlIGFuZCBkZWJ1ZyBwcm9wZXJ0aWVzXG4gICAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiTm8gc3R5bGUgZGVjbGFyYXRpb24gaW4gcnVsZSBmb3Igc2VsZWN0b3I6ICdcIi5jb25jYXQoc2VsZWN0b3IsIFwiJ1wiKSk7XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICB9O1xuICAgIC8qKlxuICAgICAqIFJldmVydHMgc3R5bGUgZm9yIHRoZSBhZmZlY3RlZCBvYmplY3QuXG4gICAgICpcbiAgICAgKiBAcGFyYW0gYWZmZWN0ZWRFbGVtZW50IEFmZmVjdGVkIGVsZW1lbnQuXG4gICAgICovXG5cbiAgICBjb25zdCByZXZlcnRTdHlsZSA9IGFmZmVjdGVkRWxlbWVudCA9PiB7XG4gICAgICBpZiAoYWZmZWN0ZWRFbGVtZW50LnByb3RlY3Rpb25PYnNlcnZlcikge1xuICAgICAgICBhZmZlY3RlZEVsZW1lbnQucHJvdGVjdGlvbk9ic2VydmVyLmRpc2Nvbm5lY3QoKTtcbiAgICAgIH1cblxuICAgICAgYWZmZWN0ZWRFbGVtZW50Lm5vZGUuc3R5bGUuY3NzVGV4dCA9IGFmZmVjdGVkRWxlbWVudC5vcmlnaW5hbFN0eWxlO1xuICAgIH07XG5cbiAgICAvKipcbiAgICAgKiBFeHRNdXRhdGlvbk9ic2VydmVyIGlzIGEgd3JhcHBlciBvdmVyIHJlZ3VsYXIgTXV0YXRpb25PYnNlcnZlciB3aXRoIG9uZSBhZGRpdGlvbmFsIGZ1bmN0aW9uOlxuICAgICAqIGl0IGtlZXBzIHRyYWNrIG9mIHRoZSBudW1iZXIgb2YgdGltZXMgd2UgY2FsbGVkIHRoZSBcIlByb3RlY3Rpb25DYWxsYmFja1wiLlxuICAgICAqXG4gICAgICogV2UgdXNlIGFuIGluc3RhbmNlIG9mIHRoaXMgdG8gbW9uaXRvciBzdHlsZXMgYWRkZWQgYnkgRXh0ZW5kZWRDc3NcbiAgICAgKiBhbmQgdG8gbWFrZSBzdXJlIHRoZXNlIHN0eWxlcyBhcmUgcmVjb3ZlcmVkIGlmIHRoZSBwYWdlIHNjcmlwdCBhdHRlbXB0cyB0byBtb2RpZnkgdGhlbS5cbiAgICAgKlxuICAgICAqIEhvd2V2ZXIsIHdlIHdhbnQgdG8gYXZvaWQgZW5kbGVzcyBsb29wcyBvZiBtb2RpZmljYXRpb24gaWYgdGhlIHBhZ2Ugc2NyaXB0IHJlcGVhdGVkbHkgbW9kaWZpZXMgdGhlIHN0eWxlcy5cbiAgICAgKiBTbyB3ZSBrZWVwIHRyYWNrIG9mIHRoZSBudW1iZXIgb2YgY2FsbHMgYW5kIG9ic2VydmUoKSBtYWtlcyBhIGRlY2lzaW9uXG4gICAgICogd2hldGhlciB0byBjb250aW51ZSByZWNvdmVyaW5nIHRoZSBzdHlsZXMgb3Igbm90LlxuICAgICAqL1xuXG4gICAgY2xhc3MgRXh0TXV0YXRpb25PYnNlcnZlciB7XG4gICAgICAvKipcbiAgICAgICAqIEV4dHJhIHByb3BlcnR5IGZvciBrZWVwaW5nICdzdHlsZSBmaXggY291bnRzJy5cbiAgICAgICAqL1xuXG4gICAgICAvKipcbiAgICAgICAqIENyZWF0ZXMgbmV3IEV4dE11dGF0aW9uT2JzZXJ2ZXIuXG4gICAgICAgKlxuICAgICAgICogQHBhcmFtIHByb3RlY3Rpb25DYWxsYmFjayBDYWxsYmFjayB3aGljaCBleGVjdXRpb24gc2hvdWxkIGJlIGNvdW50ZWQuXG4gICAgICAgKi9cbiAgICAgIGNvbnN0cnVjdG9yKHByb3RlY3Rpb25DYWxsYmFjaykge1xuICAgICAgICB0aGlzLnN0eWxlUHJvdGVjdGlvbkNvdW50ID0gMDtcbiAgICAgICAgdGhpcy5vYnNlcnZlciA9IG5ldyBuYXRpdmVzLk11dGF0aW9uT2JzZXJ2ZXIobXV0YXRpb25zID0+IHtcbiAgICAgICAgICBpZiAoIW11dGF0aW9ucy5sZW5ndGgpIHtcbiAgICAgICAgICAgIHJldHVybjtcbiAgICAgICAgICB9XG5cbiAgICAgICAgICB0aGlzLnN0eWxlUHJvdGVjdGlvbkNvdW50ICs9IDE7XG4gICAgICAgICAgcHJvdGVjdGlvbkNhbGxiYWNrKG11dGF0aW9ucywgdGhpcyk7XG4gICAgICAgIH0pO1xuICAgICAgfVxuICAgICAgLyoqXG4gICAgICAgKiBTdGFydHMgdG8gb2JzZXJ2ZSB0YXJnZXQgZWxlbWVudCxcbiAgICAgICAqIHByZXZlbnRzIGluZmluaXRlIGxvb3Agb2Ygb2JzZXJ2aW5nIGR1ZSB0byB0aGUgbGltaXRlZCBudW1iZXIgb2YgdGltZXMgb2YgY2FsbGJhY2sgcnVucy5cbiAgICAgICAqXG4gICAgICAgKiBAcGFyYW0gdGFyZ2V0IFRhcmdldCB0byBvYnNlcnZlLlxuICAgICAgICogQHBhcmFtIG9wdGlvbnMgTXV0YXRpb24gb2JzZXJ2ZXIgb3B0aW9ucy5cbiAgICAgICAqL1xuXG5cbiAgICAgIG9ic2VydmUodGFyZ2V0LCBvcHRpb25zKSB7XG4gICAgICAgIGlmICh0aGlzLnN0eWxlUHJvdGVjdGlvbkNvdW50IDwgTUFYX1NUWUxFX1BST1RFQ1RJT05fQ09VTlQpIHtcbiAgICAgICAgICB0aGlzLm9ic2VydmVyLm9ic2VydmUodGFyZ2V0LCBvcHRpb25zKTtcbiAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICBsb2dnZXIuZXJyb3IoJ0V4dGVuZGVkQ3NzOiBpbmZpbml0ZSBsb29wIHByb3RlY3Rpb24gZm9yIHN0eWxlJyk7XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICAgIC8qKlxuICAgICAgICogU3RvcHMgRXh0TXV0YXRpb25PYnNlcnZlciBmcm9tIG9ic2VydmluZyBhbnkgbXV0YXRpb25zLlxuICAgICAgICogVW50aWwgdGhlIGBvYnNlcnZlKClgIGlzIHVzZWQgYWdhaW4sIGBwcm90ZWN0aW9uQ2FsbGJhY2tgIHdpbGwgbm90IGJlIGludm9rZWQuXG4gICAgICAgKi9cblxuXG4gICAgICBkaXNjb25uZWN0KCkge1xuICAgICAgICB0aGlzLm9ic2VydmVyLmRpc2Nvbm5lY3QoKTtcbiAgICAgIH1cblxuICAgIH1cblxuICAgIGNvbnN0IFBST1RFQ1RJT05fT0JTRVJWRVJfT1BUSU9OUyA9IHtcbiAgICAgIGF0dHJpYnV0ZXM6IHRydWUsXG4gICAgICBhdHRyaWJ1dGVPbGRWYWx1ZTogdHJ1ZSxcbiAgICAgIGF0dHJpYnV0ZUZpbHRlcjogWydzdHlsZSddXG4gICAgfTtcbiAgICAvKipcbiAgICAgKiBDcmVhdGVzIE11dGF0aW9uT2JzZXJ2ZXIgcHJvdGVjdGlvbiBjYWxsYmFjay5cbiAgICAgKlxuICAgICAqIEBwYXJhbSBzdHlsZXMgU3R5bGVzIGRhdGEgb2JqZWN0LlxuICAgICAqL1xuXG4gICAgY29uc3QgY3JlYXRlUHJvdGVjdGlvbkNhbGxiYWNrID0gc3R5bGVzID0+IHtcbiAgICAgIGNvbnN0IHByb3RlY3Rpb25DYWxsYmFjayA9IChtdXRhdGlvbnMsIGV4dE9ic2VydmVyKSA9PiB7XG4gICAgICAgIGNvbnN0IHRhcmdldCA9IG11dGF0aW9uc1swXS50YXJnZXQ7XG4gICAgICAgIGV4dE9ic2VydmVyLmRpc2Nvbm5lY3QoKTtcbiAgICAgICAgc3R5bGVzLmZvckVhY2goc3R5bGUgPT4ge1xuICAgICAgICAgIHNldFN0eWxlVG9FbGVtZW50KHRhcmdldCwgc3R5bGUpO1xuICAgICAgICB9KTtcbiAgICAgICAgZXh0T2JzZXJ2ZXIub2JzZXJ2ZSh0YXJnZXQsIFBST1RFQ1RJT05fT0JTRVJWRVJfT1BUSU9OUyk7XG4gICAgICB9O1xuXG4gICAgICByZXR1cm4gcHJvdGVjdGlvbkNhbGxiYWNrO1xuICAgIH07XG4gICAgLyoqXG4gICAgICogU2V0cyB1cCBhIE11dGF0aW9uT2JzZXJ2ZXIgd2hpY2ggcHJvdGVjdHMgc3R5bGUgYXR0cmlidXRlcyBmcm9tIGNoYW5nZXMuXG4gICAgICpcbiAgICAgKiBAcGFyYW0gbm9kZSBET00gbm9kZS5cbiAgICAgKiBAcGFyYW0gcnVsZXMgUnVsZSBkYXRhIG9iamVjdHMuXG4gICAgICogQHJldHVybnMgTXV0YXRpb24gb2JzZXJ2ZXIgdXNlZCB0byBwcm90ZWN0IGF0dHJpYnV0ZSBvciBudWxsIGlmIHRoZXJlJ3Mgbm90aGluZyB0byBwcm90ZWN0LlxuICAgICAqL1xuXG5cbiAgICBjb25zdCBwcm90ZWN0U3R5bGVBdHRyaWJ1dGUgPSAobm9kZSwgcnVsZXMpID0+IHtcbiAgICAgIGlmICghbmF0aXZlcy5NdXRhdGlvbk9ic2VydmVyKSB7XG4gICAgICAgIHJldHVybiBudWxsO1xuICAgICAgfVxuXG4gICAgICBjb25zdCBzdHlsZXMgPSBbXTtcbiAgICAgIHJ1bGVzLmZvckVhY2gocnVsZURhdGEgPT4ge1xuICAgICAgICBjb25zdCBzdHlsZSA9IHJ1bGVEYXRhLnN0eWxlOyAvLyBzb21lIHJ1bGVzIG1pZ2h0IGhhdmUgb25seSBkZWJ1ZyBwcm9wZXJ0eSBpbiBzdHlsZSBkZWNsYXJhdGlvblxuICAgICAgICAvLyBlLmcuICdkaXY6aGFzKD4gYSkgeyBkZWJ1ZzogdHJ1ZSB9JyAtPiBwYXJzZWQgdG8gYm9vbGVhbiBgcnVsZURhdGEuZGVidWdgXG4gICAgICAgIC8vIHNvIG5vIHN0eWxlIGlzIGZpbmUsIGFuZCBoZXJlIHdlIHNob3VsZCBjb2xsZWN0IG9ubHkgdmFsaWQgc3R5bGVzIHRvIHByb3RlY3RcblxuICAgICAgICBpZiAoc3R5bGUpIHtcbiAgICAgICAgICBzdHlsZXMucHVzaChzdHlsZSk7XG4gICAgICAgIH1cbiAgICAgIH0pO1xuICAgICAgY29uc3QgcHJvdGVjdGlvbk9ic2VydmVyID0gbmV3IEV4dE11dGF0aW9uT2JzZXJ2ZXIoY3JlYXRlUHJvdGVjdGlvbkNhbGxiYWNrKHN0eWxlcykpO1xuICAgICAgcHJvdGVjdGlvbk9ic2VydmVyLm9ic2VydmUobm9kZSwgUFJPVEVDVElPTl9PQlNFUlZFUl9PUFRJT05TKTtcbiAgICAgIHJldHVybiBwcm90ZWN0aW9uT2JzZXJ2ZXI7XG4gICAgfTtcblxuICAgIGNvbnN0IFNUQVRTX0RFQ0lNQUxfRElHSVRTX0NPVU5UID0gNDtcblxuICAgIC8qKlxuICAgICAqIEEgaGVscGVyIGNsYXNzIGZvciBhcHBsaWVkIHJ1bGUgc3RhdHMuXG4gICAgICovXG4gICAgY2xhc3MgVGltaW5nU3RhdHMge1xuICAgICAgLyoqXG4gICAgICAgKiBDcmVhdGVzIG5ldyBUaW1pbmdTdGF0cy5cbiAgICAgICAqL1xuICAgICAgY29uc3RydWN0b3IoKSB7XG4gICAgICAgIHRoaXMuYXBwbGllc1RpbWluZ3MgPSBbXTtcbiAgICAgICAgdGhpcy5hcHBsaWVzQ291bnQgPSAwO1xuICAgICAgICB0aGlzLnRpbWluZ3NTdW0gPSAwO1xuICAgICAgICB0aGlzLm1lYW5UaW1pbmcgPSAwO1xuICAgICAgICB0aGlzLnNxdWFyZWRTdW0gPSAwO1xuICAgICAgICB0aGlzLnN0YW5kYXJkRGV2aWF0aW9uID0gMDtcbiAgICAgIH1cbiAgICAgIC8qKlxuICAgICAgICogT2JzZXJ2ZSB0YXJnZXQgZWxlbWVudCBhbmQgbWFyayBvYnNlcnZlciBhcyBhY3RpdmUuXG4gICAgICAgKlxuICAgICAgICogQHBhcmFtIGVsYXBzZWRUaW1lTXMgVGltZSBpbiBtcy5cbiAgICAgICAqL1xuXG5cbiAgICAgIHB1c2goZWxhcHNlZFRpbWVNcykge1xuICAgICAgICB0aGlzLmFwcGxpZXNUaW1pbmdzLnB1c2goZWxhcHNlZFRpbWVNcyk7XG4gICAgICAgIHRoaXMuYXBwbGllc0NvdW50ICs9IDE7XG4gICAgICAgIHRoaXMudGltaW5nc1N1bSArPSBlbGFwc2VkVGltZU1zO1xuICAgICAgICB0aGlzLm1lYW5UaW1pbmcgPSB0aGlzLnRpbWluZ3NTdW0gLyB0aGlzLmFwcGxpZXNDb3VudDtcbiAgICAgICAgdGhpcy5zcXVhcmVkU3VtICs9IGVsYXBzZWRUaW1lTXMgKiBlbGFwc2VkVGltZU1zO1xuICAgICAgICB0aGlzLnN0YW5kYXJkRGV2aWF0aW9uID0gTWF0aC5zcXJ0KHRoaXMuc3F1YXJlZFN1bSAvIHRoaXMuYXBwbGllc0NvdW50IC0gTWF0aC5wb3codGhpcy5tZWFuVGltaW5nLCAyKSk7XG4gICAgICB9XG5cbiAgICB9XG5cbiAgICAvKipcbiAgICAgKiBNYWtlcyB0aGUgdGltZXN0YW1wcyBtb3JlIHJlYWRhYmxlLlxuICAgICAqXG4gICAgICogQHBhcmFtIHRpbWVzdGFtcCBSYXcgdGltZXN0YW1wLlxuICAgICAqL1xuICAgIGNvbnN0IGJlYXV0aWZ5VGltaW5nTnVtYmVyID0gdGltZXN0YW1wID0+IHtcbiAgICAgIHJldHVybiBOdW1iZXIodGltZXN0YW1wLnRvRml4ZWQoU1RBVFNfREVDSU1BTF9ESUdJVFNfQ09VTlQpKTtcbiAgICB9O1xuICAgIC8qKlxuICAgICAqIEltcHJvdmVzIHRpbWluZyBzdGF0cyByZWFkYWJpbGl0eS5cbiAgICAgKlxuICAgICAqIEBwYXJhbSByYXdUaW1pbmdzIENvbGxlY3RlZCB0aW1pbmdzIHdpdGggcmF3IHRpbWVzdGFtcC5cbiAgICAgKi9cblxuXG4gICAgY29uc3QgYmVhdXRpZnlUaW1pbmdzID0gcmF3VGltaW5ncyA9PiB7XG4gICAgICByZXR1cm4ge1xuICAgICAgICBhcHBsaWVzVGltaW5nczogcmF3VGltaW5ncy5hcHBsaWVzVGltaW5ncy5tYXAodCA9PiBiZWF1dGlmeVRpbWluZ051bWJlcih0KSksXG4gICAgICAgIGFwcGxpZXNDb3VudDogYmVhdXRpZnlUaW1pbmdOdW1iZXIocmF3VGltaW5ncy5hcHBsaWVzQ291bnQpLFxuICAgICAgICB0aW1pbmdzU3VtOiBiZWF1dGlmeVRpbWluZ051bWJlcihyYXdUaW1pbmdzLnRpbWluZ3NTdW0pLFxuICAgICAgICBtZWFuVGltaW5nOiBiZWF1dGlmeVRpbWluZ051bWJlcihyYXdUaW1pbmdzLm1lYW5UaW1pbmcpLFxuICAgICAgICBzdGFuZGFyZERldmlhdGlvbjogYmVhdXRpZnlUaW1pbmdOdW1iZXIocmF3VGltaW5ncy5zdGFuZGFyZERldmlhdGlvbilcbiAgICAgIH07XG4gICAgfTtcbiAgICAvKipcbiAgICAgKiBQcmludHMgdGltaW5nIGluZm9ybWF0aW9uIGlmIGRlYnVnZ2luZyBtb2RlIGlzIGVuYWJsZWQuXG4gICAgICpcbiAgICAgKiBAcGFyYW0gY29udGV4dCBFeHRlbmRlZENzcyBjb250ZXh0LlxuICAgICAqL1xuXG5cbiAgICBjb25zdCBwcmludFRpbWluZ0luZm8gPSBjb250ZXh0ID0+IHtcbiAgICAgIGlmIChjb250ZXh0LmFyZVRpbWluZ3NQcmludGVkKSB7XG4gICAgICAgIHJldHVybjtcbiAgICAgIH1cblxuICAgICAgY29udGV4dC5hcmVUaW1pbmdzUHJpbnRlZCA9IHRydWU7XG4gICAgICBjb25zdCB0aW1pbmdzTG9nRGF0YSA9IHt9O1xuICAgICAgY29udGV4dC5wYXJzZWRSdWxlcy5mb3JFYWNoKHJ1bGVEYXRhID0+IHtcbiAgICAgICAgaWYgKHJ1bGVEYXRhLnRpbWluZ1N0YXRzKSB7XG4gICAgICAgICAgY29uc3Qgc2VsZWN0b3IgPSBydWxlRGF0YS5zZWxlY3RvcixcbiAgICAgICAgICAgICAgICBzdHlsZSA9IHJ1bGVEYXRhLnN0eWxlLFxuICAgICAgICAgICAgICAgIGRlYnVnID0gcnVsZURhdGEuZGVidWcsXG4gICAgICAgICAgICAgICAgbWF0Y2hlZEVsZW1lbnRzID0gcnVsZURhdGEubWF0Y2hlZEVsZW1lbnRzOyAvLyBzdHlsZSBkZWNsYXJhdGlvbiBmb3Igc29tZSBydWxlcyBpcyBwYXJzZWQgdG8gZGVidWcgcHJvcGVydHkgYW5kIG5vIHN0eWxlIHRvIGFwcGx5XG4gICAgICAgICAgLy8gZS5nLiAnZGl2Omhhcyg+IGEpIHsgZGVidWc6IHRydWUgfSdcblxuICAgICAgICAgIGlmICghc3R5bGUgJiYgIWRlYnVnKSB7XG4gICAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJSdWxlIHNob3VsZCBoYXZlIHN0eWxlIGRlY2xhcmF0aW9uIGZvciBzZWxlY3RvcjogJ1wiLmNvbmNhdChzZWxlY3RvciwgXCInXCIpKTtcbiAgICAgICAgICB9XG5cbiAgICAgICAgICBjb25zdCBzZWxlY3RvckRhdGEgPSB7XG4gICAgICAgICAgICBzZWxlY3RvclBhcnNlZDogc2VsZWN0b3IsXG4gICAgICAgICAgICB0aW1pbmdzOiBiZWF1dGlmeVRpbWluZ3MocnVsZURhdGEudGltaW5nU3RhdHMpXG4gICAgICAgICAgfTsgLy8gYHJ1bGVEYXRhLnN0eWxlYCBtYXkgY29udGFpbiBgcmVtb3ZlYCBwc2V1ZG8tcHJvcGVydHlcbiAgICAgICAgICAvLyBhbmQgbWFrZSBsb2dzIGxvb2sgYmV0dGVyXG5cbiAgICAgICAgICBpZiAoc3R5bGUgJiYgc3R5bGVbUkVNT1ZFX1BTRVVET19NQVJLRVJdID09PSBQU0VVRE9fUFJPUEVSVFlfUE9TSVRJVkVfVkFMVUUpIHtcbiAgICAgICAgICAgIHNlbGVjdG9yRGF0YS5yZW1vdmVkID0gdHJ1ZTsgLy8gbm8gbWF0Y2hlZEVsZW1lbnRzIGZvciBzdWNoIGNhc2UgYXMgdGhleSBhcmUgcmVtb3ZlZCBhZnRlciBFeHRlbmRlZENzcyBhcHBsaWVkXG4gICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIHNlbGVjdG9yRGF0YS5zdHlsZUFwcGxpZWQgPSBzdHlsZSB8fCBudWxsO1xuICAgICAgICAgICAgc2VsZWN0b3JEYXRhLm1hdGNoZWRFbGVtZW50cyA9IG1hdGNoZWRFbGVtZW50cztcbiAgICAgICAgICB9XG5cbiAgICAgICAgICB0aW1pbmdzTG9nRGF0YVtzZWxlY3Rvcl0gPSBzZWxlY3RvckRhdGE7XG4gICAgICAgIH1cbiAgICAgIH0pO1xuXG4gICAgICBpZiAoT2JqZWN0LmtleXModGltaW5nc0xvZ0RhdGEpLmxlbmd0aCA9PT0gMCkge1xuICAgICAgICByZXR1cm47XG4gICAgICB9IC8vIGFkZCBsb2NhdGlvbi5ocmVmIHRvIHRoZSBtZXNzYWdlIHRvIGRpc3Rpbmd1aXNoIGZyYW1lc1xuXG5cbiAgICAgIGxvZ2dlci5pbmZvKCdbRXh0ZW5kZWRDc3NdIFRpbWluZ3MgaW4gbWlsbGlzZWNvbmRzIGZvciAlbzpcXG4lbycsIHdpbmRvdy5sb2NhdGlvbi5ocmVmLCB0aW1pbmdzTG9nRGF0YSk7XG4gICAgfTtcblxuICAgIC8qKlxuICAgICAqIEZpbmRzIGFmZmVjdGVkRWxlbWVudCBvYmplY3QgZm9yIHRoZSBzcGVjaWZpZWQgRE9NIG5vZGUuXG4gICAgICpcbiAgICAgKiBAcGFyYW0gYWZmRWxlbWVudHMgQXJyYXkgb2YgYWZmZWN0ZWQgZWxlbWVudHMg4oCUIGNvbnRleHQuYWZmZWN0ZWRFbGVtZW50cy5cbiAgICAgKiBAcGFyYW0gZG9tTm9kZSBET00gbm9kZS5cbiAgICAgKiBAcmV0dXJucyBGb3VuZCBhZmZlY3RlZEVsZW1lbnQgb3IgdW5kZWZpbmVkLlxuICAgICAqL1xuXG4gICAgY29uc3QgZmluZEFmZmVjdGVkRWxlbWVudCA9IChhZmZFbGVtZW50cywgZG9tTm9kZSkgPT4ge1xuICAgICAgcmV0dXJuIGFmZkVsZW1lbnRzLmZpbmQoYWZmRWwgPT4gYWZmRWwubm9kZSA9PT0gZG9tTm9kZSk7XG4gICAgfTtcbiAgICAvKipcbiAgICAgKiBBcHBsaWVzIHNwZWNpZmllZCBydWxlIGFuZCByZXR1cm5zIGxpc3Qgb2YgZWxlbWVudHMgYWZmZWN0ZWQuXG4gICAgICpcbiAgICAgKiBAcGFyYW0gY29udGV4dCBFeHRlbmRlZENzcyBjb250ZXh0LlxuICAgICAqIEBwYXJhbSBydWxlRGF0YSBSdWxlIHRvIGFwcGx5LlxuICAgICAqIEByZXR1cm5zIExpc3Qgb2YgZWxlbWVudHMgYWZmZWN0ZWQgYnkgdGhlIHJ1bGUuXG4gICAgICovXG5cblxuICAgIGNvbnN0IGFwcGx5UnVsZSA9IChjb250ZXh0LCBydWxlRGF0YSkgPT4ge1xuICAgICAgLy8gZGVidWdnaW5nIG1vZGUgY2FuIGJlIGVuYWJsZWQgaW4gdHdvIHdheXM6XG4gICAgICAvLyAxLiBmb3Igc2VwYXJhdGUgcnVsZXMgLSBieSBgeyBkZWJ1ZzogdHJ1ZTsgfWBcbiAgICAgIC8vIDIuIGZvciBhbGwgcnVsZXMgc2ltdWx0YW5lb3VzbHkgYnk6XG4gICAgICAvLyAgIC0gYHsgZGVidWc6IGdsb2JhbDsgfWAgaW4gYW55IHJ1bGVcbiAgICAgIC8vICAgLSBwb3NpdGl2ZSBgZGVidWdgIHByb3BlcnR5IGluIEV4dENzc0NvbmZpZ3VyYXRpb25cbiAgICAgIGNvbnN0IGlzRGVidWdnaW5nTW9kZSA9ICEhcnVsZURhdGEuZGVidWcgfHwgY29udGV4dC5kZWJ1ZztcbiAgICAgIGxldCBzdGFydFRpbWU7XG5cbiAgICAgIGlmIChpc0RlYnVnZ2luZ01vZGUpIHtcbiAgICAgICAgc3RhcnRUaW1lID0gVGhyb3R0bGVXcmFwcGVyLm5vdygpO1xuICAgICAgfVxuXG4gICAgICBjb25zdCBhc3QgPSBydWxlRGF0YS5hc3Q7XG4gICAgICBjb25zdCBub2RlcyA9IHNlbGVjdEVsZW1lbnRzQnlBc3QoYXN0KTtcbiAgICAgIG5vZGVzLmZvckVhY2gobm9kZSA9PiB7XG4gICAgICAgIGxldCBhZmZlY3RlZEVsZW1lbnQgPSBmaW5kQWZmZWN0ZWRFbGVtZW50KGNvbnRleHQuYWZmZWN0ZWRFbGVtZW50cywgbm9kZSk7XG5cbiAgICAgICAgaWYgKGFmZmVjdGVkRWxlbWVudCkge1xuICAgICAgICAgIGFmZmVjdGVkRWxlbWVudC5ydWxlcy5wdXNoKHJ1bGVEYXRhKTtcbiAgICAgICAgICBhcHBseVN0eWxlKGNvbnRleHQsIGFmZmVjdGVkRWxlbWVudCk7XG4gICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgLy8gQXBwbHlpbmcgc3R5bGUgZmlyc3QgdGltZVxuICAgICAgICAgIGNvbnN0IG9yaWdpbmFsU3R5bGUgPSBub2RlLnN0eWxlLmNzc1RleHQ7XG4gICAgICAgICAgYWZmZWN0ZWRFbGVtZW50ID0ge1xuICAgICAgICAgICAgbm9kZSxcbiAgICAgICAgICAgIC8vIGFmZmVjdGVkIERPTSBub2RlXG4gICAgICAgICAgICBydWxlczogW3J1bGVEYXRhXSxcbiAgICAgICAgICAgIC8vIHJ1bGUgdG8gYmUgYXBwbGllZFxuICAgICAgICAgICAgb3JpZ2luYWxTdHlsZSxcbiAgICAgICAgICAgIC8vIG9yaWdpbmFsIG5vZGUgc3R5bGVcbiAgICAgICAgICAgIHByb3RlY3Rpb25PYnNlcnZlcjogbnVsbCAvLyBzdHlsZSBhdHRyaWJ1dGUgb2JzZXJ2ZXJcblxuICAgICAgICAgIH07XG4gICAgICAgICAgYXBwbHlTdHlsZShjb250ZXh0LCBhZmZlY3RlZEVsZW1lbnQpO1xuICAgICAgICAgIGNvbnRleHQuYWZmZWN0ZWRFbGVtZW50cy5wdXNoKGFmZmVjdGVkRWxlbWVudCk7XG4gICAgICAgIH1cbiAgICAgIH0pO1xuXG4gICAgICBpZiAoaXNEZWJ1Z2dpbmdNb2RlICYmIHN0YXJ0VGltZSkge1xuICAgICAgICBjb25zdCBlbGFwc2VkVGltZU1zID0gVGhyb3R0bGVXcmFwcGVyLm5vdygpIC0gc3RhcnRUaW1lO1xuXG4gICAgICAgIGlmICghcnVsZURhdGEudGltaW5nU3RhdHMpIHtcbiAgICAgICAgICBydWxlRGF0YS50aW1pbmdTdGF0cyA9IG5ldyBUaW1pbmdTdGF0cygpO1xuICAgICAgICB9XG5cbiAgICAgICAgcnVsZURhdGEudGltaW5nU3RhdHMucHVzaChlbGFwc2VkVGltZU1zKTtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIG5vZGVzO1xuICAgIH07XG4gICAgLyoqXG4gICAgICogQXBwbGllcyBmaWx0ZXJpbmcgcnVsZXMuXG4gICAgICpcbiAgICAgKiBAcGFyYW0gY29udGV4dCBFeHRlbmRlZENzcyBjb250ZXh0LlxuICAgICAqL1xuXG5cbiAgICBjb25zdCBhcHBseVJ1bGVzID0gY29udGV4dCA9PiB7XG4gICAgICBjb25zdCBuZXdTZWxlY3RlZEVsZW1lbnRzID0gW107IC8vIHNvbWUgcnVsZXMgY291bGQgbWFrZSBjYWxsIC0gc2VsZWN0b3IucXVlcnlTZWxlY3RvckFsbCgpIHRlbXBvcmFyaWx5IHRvIGNoYW5nZSBub2RlIGlkIGF0dHJpYnV0ZVxuICAgICAgLy8gdGhpcyBjYXVzZWQgTXV0YXRpb25PYnNlcnZlciB0byBjYWxsIHJlY3Vyc2l2ZWx5XG4gICAgICAvLyBodHRwczovL2dpdGh1Yi5jb20vQWRndWFyZFRlYW0vRXh0ZW5kZWRDc3MvaXNzdWVzLzgxXG5cbiAgICAgIG1haW5EaXNjb25uZWN0KGNvbnRleHQsIGNvbnRleHQubWFpbkNhbGxiYWNrKTtcbiAgICAgIGNvbnRleHQucGFyc2VkUnVsZXMuZm9yRWFjaChydWxlRGF0YSA9PiB7XG4gICAgICAgIGNvbnN0IG5vZGVzID0gYXBwbHlSdWxlKGNvbnRleHQsIHJ1bGVEYXRhKTtcbiAgICAgICAgQXJyYXkucHJvdG90eXBlLnB1c2guYXBwbHkobmV3U2VsZWN0ZWRFbGVtZW50cywgbm9kZXMpOyAvLyBzYXZlIG1hdGNoZWQgZWxlbWVudHMgdG8gcnVsZURhdGEgYXMgbGlua2VkIHRvIGFwcGxpZWQgcnVsZVxuICAgICAgICAvLyBvbmx5IGZvciBkZWJ1Z2dpbmcgcHVycG9zZXNcblxuICAgICAgICBpZiAocnVsZURhdGEuZGVidWcpIHtcbiAgICAgICAgICBydWxlRGF0YS5tYXRjaGVkRWxlbWVudHMgPSBub2RlcztcbiAgICAgICAgfVxuICAgICAgfSk7IC8vIE5vdyByZXZlcnQgc3R5bGVzIGZvciBlbGVtZW50cyB3aGljaCBhcmUgbm8gbW9yZSBhZmZlY3RlZFxuXG4gICAgICBsZXQgYWZmTGVuZ3RoID0gY29udGV4dC5hZmZlY3RlZEVsZW1lbnRzLmxlbmd0aDsgLy8gZG8gbm90aGluZyBpZiB0aGVyZSBpcyBubyBlbGVtZW50cyB0byBwcm9jZXNzXG5cbiAgICAgIHdoaWxlIChhZmZMZW5ndGgpIHtcbiAgICAgICAgY29uc3QgYWZmZWN0ZWRFbGVtZW50ID0gY29udGV4dC5hZmZlY3RlZEVsZW1lbnRzW2FmZkxlbmd0aCAtIDFdO1xuXG4gICAgICAgIGlmICghbmV3U2VsZWN0ZWRFbGVtZW50cy5pbmNsdWRlcyhhZmZlY3RlZEVsZW1lbnQubm9kZSkpIHtcbiAgICAgICAgICAvLyBUaW1lIHRvIHJldmVydCBzdHlsZVxuICAgICAgICAgIHJldmVydFN0eWxlKGFmZmVjdGVkRWxlbWVudCk7XG4gICAgICAgICAgY29udGV4dC5hZmZlY3RlZEVsZW1lbnRzLnNwbGljZShhZmZMZW5ndGggLSAxLCAxKTtcbiAgICAgICAgfSBlbHNlIGlmICghYWZmZWN0ZWRFbGVtZW50LnJlbW92ZWQpIHtcbiAgICAgICAgICAvLyBBZGQgc3R5bGUgcHJvdGVjdGlvbiBvYnNlcnZlclxuICAgICAgICAgIC8vIFByb3RlY3QgXCJzdHlsZVwiIGF0dHJpYnV0ZSBmcm9tIGNoYW5nZXNcbiAgICAgICAgICBpZiAoIWFmZmVjdGVkRWxlbWVudC5wcm90ZWN0aW9uT2JzZXJ2ZXIpIHtcbiAgICAgICAgICAgIGFmZmVjdGVkRWxlbWVudC5wcm90ZWN0aW9uT2JzZXJ2ZXIgPSBwcm90ZWN0U3R5bGVBdHRyaWJ1dGUoYWZmZWN0ZWRFbGVtZW50Lm5vZGUsIGFmZmVjdGVkRWxlbWVudC5ydWxlcyk7XG4gICAgICAgICAgfVxuICAgICAgICB9XG5cbiAgICAgICAgYWZmTGVuZ3RoIC09IDE7XG4gICAgICB9IC8vIEFmdGVyIHN0eWxlcyBhcmUgYXBwbGllZCB3ZSBjYW4gc3RhcnQgb2JzZXJ2ZSBhZ2FpblxuXG5cbiAgICAgIG1haW5PYnNlcnZlKGNvbnRleHQsIGNvbnRleHQubWFpbkNhbGxiYWNrKTtcbiAgICAgIHByaW50VGltaW5nSW5mbyhjb250ZXh0KTtcbiAgICB9O1xuXG4gICAgLyoqXG4gICAgICogVGhyb3R0bGUgdGltZW91dCBmb3IgVGhyb3R0bGVXcmFwcGVyIHRvIGV4ZWN1dGUgYXBwbHlSdWxlcygpLlxuICAgICAqL1xuXG4gICAgY29uc3QgQVBQTFlfUlVMRVNfREVMQVkgPSAxNTA7XG4gICAgLyoqXG4gICAgICogUmVzdWx0IG9mIHNlbGVjdG9yIHZhbGlkYXRpb24uXG4gICAgICovXG5cbiAgICAvKipcbiAgICAgKiBNYWluIGNsYXNzIG9mIEV4dGVuZGVkQ3NzIGxpYi5cbiAgICAgKlxuICAgICAqIFBhcnNlcyBjc3Mgc3R5bGVzaGVldCB3aXRoIGFueSBzZWxlY3RvcnMgKHBhc3NlZCB0byBpdHMgYXJndW1lbnQgYXMgc3R5bGVTaGVldCksXG4gICAgICogYW5kIGd1YXJhbnRlZSBpdHMgYXBwbHlpbmcgYXMgbXV0YXRpb24gb2JzZXJ2ZXIgaXMgdXNlZCB0byBwcmV2ZW50IHRoZSByZXN0eWxpbmcgb2YgbmVlZGVkIGVsZW1lbnRzIGJ5IG90aGVyIHNjcmlwdHMuXG4gICAgICogVGhpcyBzdHlsZSBwcm90ZWN0aW9uIGlzIGxpbWl0ZWQgdG8gNTAgdGltZXMgdG8gYXZvaWQgaW5maW5pdGUgbG9vcCAoTUFYX1NUWUxFX1BST1RFQ1RJT05fQ09VTlQpLlxuICAgICAqIE91ciBvd24gVGhyb3R0bGVXcmFwcGVyIGlzIHVzZWQgZm9yIHN0eWxlcyBhcHBseWluZyB0byBhdm9pZCB0b28gb2Z0ZW4gbGliIHJlYWN0aW9ucyBvbiBwYWdlIG11dGF0aW9ucy5cbiAgICAgKlxuICAgICAqIENvbnN0cnVjdG9yIGNyZWF0ZXMgdGhlIGluc3RhbmNlIG9mIGNsYXNzIHdoaWNoIHNob3VsZCBiZSBydW4gYmUgYGFwcGx5KClgIG1ldGhvZCB0byBhcHBseSB0aGUgcnVsZXMsXG4gICAgICogYW5kIHRoZSBhcHBseWluZyBjYW4gYmUgc3RvcHBlZCBieSBgZGlzcG9zZSgpYC5cbiAgICAgKlxuICAgICAqIENhbiBiZSB1c2VkIHRvIHNlbGVjdCBwYWdlIGVsZW1lbnRzIGJ5IHNlbGVjdG9yIHdpdGggYHF1ZXJ5KClgIG1ldGhvZCAoc2ltaWxhciB0byBgRG9jdW1lbnQucXVlcnlTZWxlY3RvckFsbCgpYCksXG4gICAgICogd2hpY2ggZG9lcyBub3QgcmVxdWlyZSBpbnN0YW5jZSBjcmVhdGluZy5cbiAgICAgKi9cbiAgICBjbGFzcyBFeHRlbmRlZENzcyB7XG4gICAgICAvKipcbiAgICAgICAqIENyZWF0ZXMgbmV3IEV4dGVuZGVkQ3NzLlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSBjb25maWd1cmF0aW9uIEV4dGVuZGVkQ3NzIGNvbmZpZ3VyYXRpb24uXG4gICAgICAgKi9cbiAgICAgIGNvbnN0cnVjdG9yKGNvbmZpZ3VyYXRpb24pIHtcbiAgICAgICAgaWYgKCFpc0Jyb3dzZXJTdXBwb3J0ZWQoKSkge1xuICAgICAgICAgIHRocm93IG5ldyBFcnJvcignQnJvd3NlciBpcyBub3Qgc3VwcG9ydGVkIGJ5IEV4dGVuZGVkQ3NzLicpO1xuICAgICAgICB9XG5cbiAgICAgICAgaWYgKCFjb25maWd1cmF0aW9uKSB7XG4gICAgICAgICAgdGhyb3cgbmV3IEVycm9yKCdFeHRlbmRlZENzcyBjb25maWd1cmF0aW9uIHNob3VsZCBiZSBwcm92aWRlZC4nKTtcbiAgICAgICAgfVxuXG4gICAgICAgIHRoaXMuY29udGV4dCA9IHtcbiAgICAgICAgICBiZWZvcmVTdHlsZUFwcGxpZWQ6IGNvbmZpZ3VyYXRpb24uYmVmb3JlU3R5bGVBcHBsaWVkLFxuICAgICAgICAgIGRlYnVnOiBmYWxzZSxcbiAgICAgICAgICBhZmZlY3RlZEVsZW1lbnRzOiBbXSxcbiAgICAgICAgICBpc0RvbU9ic2VydmVkOiBmYWxzZSxcbiAgICAgICAgICByZW1vdmFsc1N0YXRpc3RpYzoge30sXG4gICAgICAgICAgcGFyc2VkUnVsZXM6IHBhcnNlKGNvbmZpZ3VyYXRpb24uc3R5bGVTaGVldCwgZXh0Q3NzRG9jdW1lbnQpLFxuICAgICAgICAgIG1haW5DYWxsYmFjazogKCkgPT4ge31cbiAgICAgICAgfTsgLy8gdHJ1ZSBpZiBzZXQgaW4gY29uZmlndXJhdGlvblxuICAgICAgICAvLyBvciBhbnkgcnVsZSBpbiBzdHlsZVNoZWV0IGhhcyBgZGVidWc6IGdsb2JhbGBcblxuICAgICAgICB0aGlzLmNvbnRleHQuZGVidWcgPSBjb25maWd1cmF0aW9uLmRlYnVnIHx8IHRoaXMuY29udGV4dC5wYXJzZWRSdWxlcy5zb21lKHJ1bGVEYXRhID0+IHtcbiAgICAgICAgICByZXR1cm4gcnVsZURhdGEuZGVidWcgPT09IERFQlVHX1BTRVVET19QUk9QRVJUWV9HTE9CQUxfVkFMVUU7XG4gICAgICAgIH0pO1xuICAgICAgICB0aGlzLmFwcGx5UnVsZXNTY2hlZHVsZXIgPSBuZXcgVGhyb3R0bGVXcmFwcGVyKHRoaXMuY29udGV4dCwgYXBwbHlSdWxlcywgQVBQTFlfUlVMRVNfREVMQVkpO1xuICAgICAgICB0aGlzLmNvbnRleHQubWFpbkNhbGxiYWNrID0gdGhpcy5hcHBseVJ1bGVzU2NoZWR1bGVyLnJ1bi5iaW5kKHRoaXMuYXBwbHlSdWxlc1NjaGVkdWxlcik7XG5cbiAgICAgICAgaWYgKHRoaXMuY29udGV4dC5iZWZvcmVTdHlsZUFwcGxpZWQgJiYgdHlwZW9mIHRoaXMuY29udGV4dC5iZWZvcmVTdHlsZUFwcGxpZWQgIT09ICdmdW5jdGlvbicpIHtcbiAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJJbnZhbGlkIGNvbmZpZ3VyYXRpb24uIFR5cGUgb2YgJ2JlZm9yZVN0eWxlQXBwbGllZCcgc2hvdWxkIGJlIGEgZnVuY3Rpb24sIHJlY2VpdmVkOiAnXCIuY29uY2F0KHR5cGVvZiB0aGlzLmNvbnRleHQuYmVmb3JlU3R5bGVBcHBsaWVkLCBcIidcIikpOyAvLyBlc2xpbnQtZGlzYWJsZS1saW5lIG1heC1sZW5cbiAgICAgICAgfVxuXG4gICAgICAgIHRoaXMuYXBwbHlSdWxlc0NhbGxiYWNrTGlzdGVuZXIgPSAoKSA9PiB7XG4gICAgICAgICAgYXBwbHlSdWxlcyh0aGlzLmNvbnRleHQpO1xuICAgICAgICB9O1xuICAgICAgfVxuICAgICAgLyoqXG4gICAgICAgKiBBcHBsaWVzIHN0eWxlc2hlZXQgcnVsZXMgb24gcGFnZS5cbiAgICAgICAqL1xuXG5cbiAgICAgIGFwcGx5KCkge1xuICAgICAgICBhcHBseVJ1bGVzKHRoaXMuY29udGV4dCk7XG5cbiAgICAgICAgaWYgKGRvY3VtZW50LnJlYWR5U3RhdGUgIT09ICdjb21wbGV0ZScpIHtcbiAgICAgICAgICBkb2N1bWVudC5hZGRFdmVudExpc3RlbmVyKCdET01Db250ZW50TG9hZGVkJywgdGhpcy5hcHBseVJ1bGVzQ2FsbGJhY2tMaXN0ZW5lciwgZmFsc2UpO1xuICAgICAgICB9XG4gICAgICB9XG4gICAgICAvKipcbiAgICAgICAqIERpc3Bvc2VzIEV4dGVuZGVkQ3NzIGFuZCByZW1vdmVzIG91ciBzdHlsZXMgZnJvbSBtYXRjaGVkIGVsZW1lbnRzLlxuICAgICAgICovXG5cblxuICAgICAgZGlzcG9zZSgpIHtcbiAgICAgICAgbWFpbkRpc2Nvbm5lY3QodGhpcy5jb250ZXh0LCB0aGlzLmNvbnRleHQubWFpbkNhbGxiYWNrKTtcbiAgICAgICAgdGhpcy5jb250ZXh0LmFmZmVjdGVkRWxlbWVudHMuZm9yRWFjaChlbCA9PiB7XG4gICAgICAgICAgcmV2ZXJ0U3R5bGUoZWwpO1xuICAgICAgICB9KTtcbiAgICAgICAgZG9jdW1lbnQucmVtb3ZlRXZlbnRMaXN0ZW5lcignRE9NQ29udGVudExvYWRlZCcsIHRoaXMuYXBwbHlSdWxlc0NhbGxiYWNrTGlzdGVuZXIsIGZhbHNlKTtcbiAgICAgIH1cbiAgICAgIC8qKlxuICAgICAgICogRXhwb3NlZCBmb3IgdGVzdGluZyBwdXJwb3NlcyBvbmx5LlxuICAgICAgICovXG5cblxuICAgICAgZ2V0QWZmZWN0ZWRFbGVtZW50cygpIHtcbiAgICAgICAgcmV0dXJuIHRoaXMuY29udGV4dC5hZmZlY3RlZEVsZW1lbnRzO1xuICAgICAgfVxuICAgICAgLyoqXG4gICAgICAgKiBSZXR1cm5zIGEgbGlzdCBvZiB0aGUgZG9jdW1lbnQncyBlbGVtZW50cyB0aGF0IG1hdGNoIHRoZSBzcGVjaWZpZWQgc2VsZWN0b3IuXG4gICAgICAgKiBVc2VzIEV4dENzc0RvY3VtZW50LnF1ZXJ5U2VsZWN0b3JBbGwoKS5cbiAgICAgICAqXG4gICAgICAgKiBAcGFyYW0gc2VsZWN0b3IgU2VsZWN0b3IgdGV4dC5cbiAgICAgICAqIEBwYXJhbSBbbm9UaW1pbmc9dHJ1ZV0gSWYgdHJ1ZSDigJQgZG8gbm90IHByaW50IHRoZSB0aW1pbmdzIHRvIHRoZSBjb25zb2xlLlxuICAgICAgICpcbiAgICAgICAqIEB0aHJvd3MgQW4gZXJyb3IgaWYgc2VsZWN0b3IgaXMgbm90IHZhbGlkLlxuICAgICAgICogQHJldHVybnMgQSBsaXN0IG9mIGVsZW1lbnRzIHRoYXQgbWF0Y2ggdGhlIHNlbGVjdG9yLlxuICAgICAgICovXG5cblxuICAgICAgc3RhdGljIHF1ZXJ5KHNlbGVjdG9yKSB7XG4gICAgICAgIGxldCBub1RpbWluZyA9IGFyZ3VtZW50cy5sZW5ndGggPiAxICYmIGFyZ3VtZW50c1sxXSAhPT0gdW5kZWZpbmVkID8gYXJndW1lbnRzWzFdIDogdHJ1ZTtcblxuICAgICAgICBpZiAodHlwZW9mIHNlbGVjdG9yICE9PSAnc3RyaW5nJykge1xuICAgICAgICAgIHRocm93IG5ldyBFcnJvcignU2VsZWN0b3Igc2hvdWxkIGJlIGRlZmluZWQgYXMgYSBzdHJpbmcuJyk7XG4gICAgICAgIH1cblxuICAgICAgICBjb25zdCBzdGFydCA9IFRocm90dGxlV3JhcHBlci5ub3coKTtcblxuICAgICAgICB0cnkge1xuICAgICAgICAgIHJldHVybiBleHRDc3NEb2N1bWVudC5xdWVyeVNlbGVjdG9yQWxsKHNlbGVjdG9yKTtcbiAgICAgICAgfSBmaW5hbGx5IHtcbiAgICAgICAgICBjb25zdCBlbmQgPSBUaHJvdHRsZVdyYXBwZXIubm93KCk7XG5cbiAgICAgICAgICBpZiAoIW5vVGltaW5nKSB7XG4gICAgICAgICAgICBsb2dnZXIuaW5mbyhcIltFeHRlbmRlZENzc10gRWxhcHNlZDogXCIuY29uY2F0KE1hdGgucm91bmQoKGVuZCAtIHN0YXJ0KSAqIDEwMDApLCBcIiBcXHUwM0JDcy5cIikpO1xuICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgfVxuICAgICAgLyoqXG4gICAgICAgKiBWYWxpZGF0ZXMgc2VsZWN0b3IuXG4gICAgICAgKlxuICAgICAgICogQHBhcmFtIGlucHV0U2VsZWN0b3IgU2VsZWN0b3IgdGV4dCB0byB2YWxpZGF0ZS5cbiAgICAgICAqL1xuXG5cbiAgICAgIHN0YXRpYyB2YWxpZGF0ZShpbnB1dFNlbGVjdG9yKSB7XG4gICAgICAgIHRyeSB7XG4gICAgICAgICAgLy8gRXh0ZW5kZWRDc3MgaW4gZ2VuZXJhbCBzdXBwb3J0cyA6cmVtb3ZlKCkgaW4gc2VsZWN0b3JcbiAgICAgICAgICAvLyBidXQgRXh0ZW5kZWRDc3MucXVlcnkoKSBkb2VzIG5vdCBzdXBwb3J0IGl0IGFzIGl0IHNob3VsZCBiZSBwYXJzZWQgYnkgc3R5bGVzaGVldCBwYXJzZXIuXG4gICAgICAgICAgLy8gc28gZm9yIHZhbGlkYXRpb24gd2UgaGF2ZSB0byBoYW5kbGUgc2VsZWN0b3JzIHdpdGggYDpyZW1vdmUoKWAgaW4gaXRcbiAgICAgICAgICBjb25zdCBfcGFyc2VSZW1vdmVTZWxlY3RvciA9IHBhcnNlUmVtb3ZlU2VsZWN0b3IoaW5wdXRTZWxlY3RvciksXG4gICAgICAgICAgICAgICAgc2VsZWN0b3IgPSBfcGFyc2VSZW1vdmVTZWxlY3Rvci5zZWxlY3RvcjtcblxuICAgICAgICAgIEV4dGVuZGVkQ3NzLnF1ZXJ5KHNlbGVjdG9yKTtcbiAgICAgICAgICByZXR1cm4ge1xuICAgICAgICAgICAgb2s6IHRydWUsXG4gICAgICAgICAgICBlcnJvcjogbnVsbFxuICAgICAgICAgIH07XG4gICAgICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgICAgICAvLyBlc2xpbnQtZGlzYWJsZS1saW5lIEB0eXBlc2NyaXB0LWVzbGludC9uby1leHBsaWNpdC1hbnlcbiAgICAgICAgICAvLyBub3QgdmFsaWQgaW5wdXQgYHNlbGVjdG9yYCBzaG91bGQgYmUgbG9nZ2VkIGV2ZW50dWFsbHlcbiAgICAgICAgICBjb25zdCBlcnJvciA9IFwiU2VsZWN0b3IgaXMgbm90IHZhbGlkOiAnXCIuY29uY2F0KGlucHV0U2VsZWN0b3IsIFwiJyAtLSBcIikuY29uY2F0KGUubWVzc2FnZSk7XG4gICAgICAgICAgcmV0dXJuIHtcbiAgICAgICAgICAgIG9rOiBmYWxzZSxcbiAgICAgICAgICAgIGVycm9yXG4gICAgICAgICAgfTtcbiAgICAgICAgfVxuICAgICAgfVxuXG4gICAgfVxuXG4gICAgZXhwb3J0cy5FeHRlbmRlZENzcyA9IEV4dGVuZGVkQ3NzO1xuXG4gICAgT2JqZWN0LmRlZmluZVByb3BlcnR5KGV4cG9ydHMsICdfX2VzTW9kdWxlJywgeyB2YWx1ZTogdHJ1ZSB9KTtcblxufSkpO1xuIiwiZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24gX2FycmF5TGlrZVRvQXJyYXkoYXJyLCBsZW4pIHtcbiAgaWYgKGxlbiA9PSBudWxsIHx8IGxlbiA+IGFyci5sZW5ndGgpIGxlbiA9IGFyci5sZW5ndGg7XG5cbiAgZm9yICh2YXIgaSA9IDAsIGFycjIgPSBuZXcgQXJyYXkobGVuKTsgaSA8IGxlbjsgaSsrKSB7XG4gICAgYXJyMltpXSA9IGFycltpXTtcbiAgfVxuXG4gIHJldHVybiBhcnIyO1xufSIsImltcG9ydCBhcnJheUxpa2VUb0FycmF5IGZyb20gXCIuL2FycmF5TGlrZVRvQXJyYXkuanNcIjtcbmV4cG9ydCBkZWZhdWx0IGZ1bmN0aW9uIF9hcnJheVdpdGhvdXRIb2xlcyhhcnIpIHtcbiAgaWYgKEFycmF5LmlzQXJyYXkoYXJyKSkgcmV0dXJuIGFycmF5TGlrZVRvQXJyYXkoYXJyKTtcbn0iLCJmdW5jdGlvbiBhc3luY0dlbmVyYXRvclN0ZXAoZ2VuLCByZXNvbHZlLCByZWplY3QsIF9uZXh0LCBfdGhyb3csIGtleSwgYXJnKSB7XG4gIHRyeSB7XG4gICAgdmFyIGluZm8gPSBnZW5ba2V5XShhcmcpO1xuICAgIHZhciB2YWx1ZSA9IGluZm8udmFsdWU7XG4gIH0gY2F0Y2ggKGVycm9yKSB7XG4gICAgcmVqZWN0KGVycm9yKTtcbiAgICByZXR1cm47XG4gIH1cblxuICBpZiAoaW5mby5kb25lKSB7XG4gICAgcmVzb2x2ZSh2YWx1ZSk7XG4gIH0gZWxzZSB7XG4gICAgUHJvbWlzZS5yZXNvbHZlKHZhbHVlKS50aGVuKF9uZXh0LCBfdGhyb3cpO1xuICB9XG59XG5cbmV4cG9ydCBkZWZhdWx0IGZ1bmN0aW9uIF9hc3luY1RvR2VuZXJhdG9yKGZuKSB7XG4gIHJldHVybiBmdW5jdGlvbiAoKSB7XG4gICAgdmFyIHNlbGYgPSB0aGlzLFxuICAgICAgICBhcmdzID0gYXJndW1lbnRzO1xuICAgIHJldHVybiBuZXcgUHJvbWlzZShmdW5jdGlvbiAocmVzb2x2ZSwgcmVqZWN0KSB7XG4gICAgICB2YXIgZ2VuID0gZm4uYXBwbHkoc2VsZiwgYXJncyk7XG5cbiAgICAgIGZ1bmN0aW9uIF9uZXh0KHZhbHVlKSB7XG4gICAgICAgIGFzeW5jR2VuZXJhdG9yU3RlcChnZW4sIHJlc29sdmUsIHJlamVjdCwgX25leHQsIF90aHJvdywgXCJuZXh0XCIsIHZhbHVlKTtcbiAgICAgIH1cblxuICAgICAgZnVuY3Rpb24gX3Rocm93KGVycikge1xuICAgICAgICBhc3luY0dlbmVyYXRvclN0ZXAoZ2VuLCByZXNvbHZlLCByZWplY3QsIF9uZXh0LCBfdGhyb3csIFwidGhyb3dcIiwgZXJyKTtcbiAgICAgIH1cblxuICAgICAgX25leHQodW5kZWZpbmVkKTtcbiAgICB9KTtcbiAgfTtcbn0iLCJleHBvcnQgZGVmYXVsdCBmdW5jdGlvbiBfaXRlcmFibGVUb0FycmF5KGl0ZXIpIHtcbiAgaWYgKHR5cGVvZiBTeW1ib2wgIT09IFwidW5kZWZpbmVkXCIgJiYgaXRlcltTeW1ib2wuaXRlcmF0b3JdICE9IG51bGwgfHwgaXRlcltcIkBAaXRlcmF0b3JcIl0gIT0gbnVsbCkgcmV0dXJuIEFycmF5LmZyb20oaXRlcik7XG59IiwiZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24gX25vbkl0ZXJhYmxlU3ByZWFkKCkge1xuICB0aHJvdyBuZXcgVHlwZUVycm9yKFwiSW52YWxpZCBhdHRlbXB0IHRvIHNwcmVhZCBub24taXRlcmFibGUgaW5zdGFuY2UuXFxuSW4gb3JkZXIgdG8gYmUgaXRlcmFibGUsIG5vbi1hcnJheSBvYmplY3RzIG11c3QgaGF2ZSBhIFtTeW1ib2wuaXRlcmF0b3JdKCkgbWV0aG9kLlwiKTtcbn0iLCJpbXBvcnQgYXJyYXlXaXRob3V0SG9sZXMgZnJvbSBcIi4vYXJyYXlXaXRob3V0SG9sZXMuanNcIjtcbmltcG9ydCBpdGVyYWJsZVRvQXJyYXkgZnJvbSBcIi4vaXRlcmFibGVUb0FycmF5LmpzXCI7XG5pbXBvcnQgdW5zdXBwb3J0ZWRJdGVyYWJsZVRvQXJyYXkgZnJvbSBcIi4vdW5zdXBwb3J0ZWRJdGVyYWJsZVRvQXJyYXkuanNcIjtcbmltcG9ydCBub25JdGVyYWJsZVNwcmVhZCBmcm9tIFwiLi9ub25JdGVyYWJsZVNwcmVhZC5qc1wiO1xuZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24gX3RvQ29uc3VtYWJsZUFycmF5KGFycikge1xuICByZXR1cm4gYXJyYXlXaXRob3V0SG9sZXMoYXJyKSB8fCBpdGVyYWJsZVRvQXJyYXkoYXJyKSB8fCB1bnN1cHBvcnRlZEl0ZXJhYmxlVG9BcnJheShhcnIpIHx8IG5vbkl0ZXJhYmxlU3ByZWFkKCk7XG59IiwiaW1wb3J0IGFycmF5TGlrZVRvQXJyYXkgZnJvbSBcIi4vYXJyYXlMaWtlVG9BcnJheS5qc1wiO1xuZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24gX3Vuc3VwcG9ydGVkSXRlcmFibGVUb0FycmF5KG8sIG1pbkxlbikge1xuICBpZiAoIW8pIHJldHVybjtcbiAgaWYgKHR5cGVvZiBvID09PSBcInN0cmluZ1wiKSByZXR1cm4gYXJyYXlMaWtlVG9BcnJheShvLCBtaW5MZW4pO1xuICB2YXIgbiA9IE9iamVjdC5wcm90b3R5cGUudG9TdHJpbmcuY2FsbChvKS5zbGljZSg4LCAtMSk7XG4gIGlmIChuID09PSBcIk9iamVjdFwiICYmIG8uY29uc3RydWN0b3IpIG4gPSBvLmNvbnN0cnVjdG9yLm5hbWU7XG4gIGlmIChuID09PSBcIk1hcFwiIHx8IG4gPT09IFwiU2V0XCIpIHJldHVybiBBcnJheS5mcm9tKG8pO1xuICBpZiAobiA9PT0gXCJBcmd1bWVudHNcIiB8fCAvXig/OlVpfEkpbnQoPzo4fDE2fDMyKSg/OkNsYW1wZWQpP0FycmF5JC8udGVzdChuKSkgcmV0dXJuIGFycmF5TGlrZVRvQXJyYXkobywgbWluTGVuKTtcbn0iLCJtb2R1bGUuZXhwb3J0cyA9IHJlcXVpcmUoXCJyZWdlbmVyYXRvci1ydW50aW1lXCIpO1xuIiwiZXhwb3J0IGVudW0gTWVzc2FnZXNUb05hdGl2ZUFwcCB7XG4gICAgV3JpdGVJbk5hdGl2ZUxvZyA9ICd3cml0ZUluTmF0aXZlTG9nJyxcbiAgICBHZXRBZHZhbmNlZFJ1bGVzVGV4dCA9ICdnZXRfYWR2YW5jZWRfcnVsZXNfdGV4dCcsXG4gICAgR2V0SW5pdERhdGEgPSAnZ2V0X2luaXRfZGF0YScsXG4gICAgU2hvdWxkVXBkYXRlQWR2YW5jZWRSdWxlcyA9ICdzaG91bGRfdXBkYXRlX2FkdmFuY2VkX3J1bGVzJyxcbn1cblxuZXhwb3J0IGVudW0gTWVzc2FnZXNUb0JhY2tncm91bmRQYWdlIHtcbiAgICBPcGVuQXNzaXN0YW50ID0gJ29wZW5fYXNzaXN0YW50JyxcbiAgICBHZXRTY3JpcHRzQW5kU2VsZWN0b3JzID0gJ2dldF9zY3JpcHRzX2FuZF9zZWxlY3RvcnMnLFxuICAgIEFkZFJ1bGUgPSAnYWRkX3J1bGUnLFxuICAgIEdldFBvcHVwRGF0YSA9ICdnZXRfcG9wdXBfZGF0YScsXG4gICAgU2V0UGVybWlzc2lvbnNNb2RhbFZpZXdlZCA9ICdzZXRfcGVybWlzc2lvbnNfbW9kYWxfdmlld2VkJyxcbiAgICBTZXRQcm90ZWN0aW9uU3RhdHVzID0gJ3NldF9wcm90ZWN0aW9uX3N0YXR1cycsXG4gICAgRGVsZXRlVXNlclJ1bGVzQnlVcmwgPSAnZGVsZXRlX3VzZXJfcnVsZXNfYnlfdXJsJyxcbiAgICBSZXBvcnRQcm9ibGVtID0gJ3JlcG9ydF9wcm9ibGVtJyxcbiAgICBVcGdyYWRlQ2xpY2tlZCA9ICd1cGdyYWRlX2NsaWNrZWQnLFxuICAgIEVuYWJsZUFkdmFuY2VkQmxvY2tpbmcgPSAnZW5hYmxlX2FkdmFuY2VkX2Jsb2NraW5nJyxcbiAgICBFbmFibGVTYWZhcmlQcm90ZWN0aW9uID0gJ2VuYWJsZV9zYWZhcmlfcHJvdGVjdGlvbicsXG59XG5cbmV4cG9ydCBlbnVtIE1lc3NhZ2VzVG9Db250ZW50U2NyaXB0IHtcbiAgICBJbml0QXNzaXN0YW50ID0gJ2luaXRfYXNzaXN0YW50Jyxcbn1cblxuZXhwb3J0IGVudW0gQXBwZWFyYW5jZVRoZW1lIHtcbiAgICBTeXN0ZW0gPSAnc3lzdGVtJyxcbiAgICBEYXJrID0gJ2RhcmsnLFxuICAgIExpZ2h0ID0gJ2xpZ2h0Jyxcbn1cblxuZXhwb3J0IGNvbnN0IEFQUEVBUkFOQ0VfVEhFTUVfREVGQVVMVCA9IEFwcGVhcmFuY2VUaGVtZS5TeXN0ZW07XG5cbmV4cG9ydCBjb25zdCBXRUJfRVhURU5TSU9OX01PUkVfVVJMID0gJ2h0dHBzOi8vbGluay5hZHRpZHkub3JnL2ZvcndhcmQuaHRtbD9hY3Rpb249d2ViX2V4dGVuc2lvbl9tb3JlJmZyb209cG9wdXAmYXBwPWlvcyc7XG5cbmV4cG9ydCBlbnVtIFBsYXRmb3JtIHtcbiAgICBJUGFkID0gJ2lwYWQnLFxuICAgIElQaG9uZSA9ICdpcGhvbmUnLFxufVxuIiwiLyogZXNsaW50LWRpc2FibGUgbm8tY29uc29sZSAqL1xuaW1wb3J0IGJyb3dzZXIgZnJvbSAnd2ViZXh0ZW5zaW9uLXBvbHlmaWxsJztcbmltcG9ydCB7IEV4dGVuZGVkQ3NzIH0gZnJvbSAnQGFkZ3VhcmQvZXh0ZW5kZWQtY3NzJztcblxuaW1wb3J0IHsgTWVzc2FnZXNUb0JhY2tncm91bmRQYWdlIH0gZnJvbSAnLi4vY29tbW9uL2NvbnN0YW50cyc7XG5pbXBvcnQgeyBTZWxlY3RvcnNBbmRTY3JpcHRzIH0gZnJvbSAnLi4vY29tbW9uL2ludGVyZmFjZXMnO1xuXG4vKipcbiAqIExvZ3MgYSBtZXNzYWdlIGlmIHZlcmJvc2UgaXMgdHJ1ZVxuICpcbiAqIEBwYXJhbSB2ZXJib3NlXG4gKiBAcGFyYW0gbWVzc2FnZVxuICovXG5jb25zdCBsb2dNZXNzYWdlID0gKHZlcmJvc2U6IGJvb2xlYW4sIG1lc3NhZ2U6IHN0cmluZykgPT4ge1xuICAgIGlmICh2ZXJib3NlKSB7XG4gICAgICAgIGNvbnNvbGUubG9nKGAoQUcpICR7bWVzc2FnZX1gKTtcbiAgICB9XG59O1xuXG5jb25zdCBnZXRTZWxlY3RvcnNBbmRTY3JpcHRzID0gYXN5bmMgKCk6IFByb21pc2U8U2VsZWN0b3JzQW5kU2NyaXB0cyB8IG51bGw+ID0+IHtcbiAgICBjb25zdCByZXNwb25zZSA9IGF3YWl0IGJyb3dzZXIucnVudGltZS5zZW5kTWVzc2FnZSh7XG4gICAgICAgIHR5cGU6IE1lc3NhZ2VzVG9CYWNrZ3JvdW5kUGFnZS5HZXRTY3JpcHRzQW5kU2VsZWN0b3JzLFxuICAgICAgICBkYXRhOiB7XG4gICAgICAgICAgICB1cmw6IHdpbmRvdy5sb2NhdGlvbi5ocmVmLFxuICAgICAgICB9LFxuICAgIH0pO1xuXG4gICAgaWYgKHJlc3BvbnNlID09PSBudWxsKSB7XG4gICAgICAgIGNvbnNvbGUubG9nKCdBRzogbm8gc2NyaXB0cyBhbmQgc2VsZWN0b3JzIHJlY2VpdmVkJyk7XG4gICAgICAgIHJldHVybiBudWxsO1xuICAgIH1cblxuICAgIHJldHVybiByZXNwb25zZSBhcyBTZWxlY3RvcnNBbmRTY3JpcHRzO1xufTtcblxuLyoqXG4gKiBFeGVjdXRlIHNjcmlwdHMgaW4gYSBwYWdlIGNvbnRleHQgYW5kIGNsZWFudXAgaXRzZWxmIHdoZW4gZXhlY3V0aW9uIGNvbXBsZXRlc1xuICogQHBhcmFtIHNjcmlwdHMgU2NyaXB0cyBhcnJheSB0byBleGVjdXRlXG4gKi9cbmNvbnN0IGV4ZWN1dGVTY3JpcHRzID0gKHNjcmlwdHM6IHN0cmluZ1tdKSA9PiB7XG4gICAgLy8gV3JhcCB3aXRoIHRyeSBjYXRjaFxuICAgIGNvbnN0IHN0YXJ0ID0gJyggZnVuY3Rpb24gKCkgeyB0cnkgeyc7XG4gICAgY29uc3QgZW5kID0gXCJ9IGNhdGNoIChleCkgeyBjb25zb2xlLmVycm9yKCdFcnJvciBleGVjdXRpbmcgQUcganM6ICcgKyBleCk7IH0gfSkoKTtcIjtcblxuICAgIGNvbnN0IHVwZGF0ZWQgPSBbc3RhcnQsIC4uLnNjcmlwdHMsIGVuZF07XG5cbiAgICBjb25zdCBzY3JpcHRUYWcgPSBkb2N1bWVudC5jcmVhdGVFbGVtZW50KCdzY3JpcHQnKTtcbiAgICBzY3JpcHRUYWcuc2V0QXR0cmlidXRlKCd0eXBlJywgJ3RleHQvamF2YXNjcmlwdCcpO1xuICAgIHNjcmlwdFRhZy50ZXh0Q29udGVudCA9IHVwZGF0ZWQuam9pbignXFxyXFxuJyk7XG5cbiAgICBjb25zdCBwYXJlbnQgPSBkb2N1bWVudC5oZWFkIHx8IGRvY3VtZW50LmRvY3VtZW50RWxlbWVudDtcbiAgICBwYXJlbnQuYXBwZW5kQ2hpbGQoc2NyaXB0VGFnKTtcbiAgICBpZiAoc2NyaXB0VGFnLnBhcmVudE5vZGUpIHtcbiAgICAgICAgc2NyaXB0VGFnLnBhcmVudE5vZGUucmVtb3ZlQ2hpbGQoc2NyaXB0VGFnKTtcbiAgICB9XG59O1xuXG4vKipcbiAqIEFwcGxpZXMgSlMgaW5qZWN0aW9ucy5cbiAqIEBwYXJhbSBzY3JpcHRzIEFycmF5IHdpdGggSlMgc2NyaXB0c1xuICogQHBhcmFtIHZlcmJvc2UgbG9nZ2luZ1xuICovXG5jb25zdCBhcHBseVNjcmlwdHMgPSAoc2NyaXB0czogc3RyaW5nW10sIHZlcmJvc2U6IGJvb2xlYW4pID0+IHtcbiAgICBpZiAoIXNjcmlwdHMgfHwgc2NyaXB0cy5sZW5ndGggPT09IDApIHtcbiAgICAgICAgcmV0dXJuO1xuICAgIH1cblxuICAgIGxvZ01lc3NhZ2UodmVyYm9zZSwgYHNjcmlwdHMgbGVuZ3RoOiAke3NjcmlwdHMubGVuZ3RofWApO1xuICAgIGV4ZWN1dGVTY3JpcHRzKHNjcmlwdHMpO1xufTtcblxuLyoqXG4gKiBQcm90ZWN0cyBzcGVjaWZpZWQgc3R5bGUgZWxlbWVudCBmcm9tIGNoYW5nZXMgdG8gdGhlIGN1cnJlbnQgZG9jdW1lbnRcbiAqIEFkZCBhIG11dGF0aW9uIG9ic2VydmVyLCB3aGljaCBpcyBhZGRzIG91ciBydWxlcyBhZ2FpbiBpZiBpdCB3YXMgcmVtb3ZlZFxuICpcbiAqIEBwYXJhbSBwcm90ZWN0U3R5bGVFbCBwcm90ZWN0ZWQgc3R5bGUgZWxlbWVudFxuICovXG5jb25zdCBwcm90ZWN0U3R5bGVFbGVtZW50Q29udGVudCA9IChwcm90ZWN0U3R5bGVFbDogTm9kZSkgPT4ge1xuICAgIC8vIEB0cy1pZ25vcmVcbiAgICBjb25zdCBNdXRhdGlvbk9ic2VydmVyID0gd2luZG93Lk11dGF0aW9uT2JzZXJ2ZXIgfHwgd2luZG93LldlYktpdE11dGF0aW9uT2JzZXJ2ZXI7XG4gICAgaWYgKCFNdXRhdGlvbk9ic2VydmVyKSB7XG4gICAgICAgIHJldHVybjtcbiAgICB9XG4gICAgLyogb2JzZXJ2ZXIsIHdoaWNoIG9ic2VydmUgcHJvdGVjdFN0eWxlRWwgaW5uZXIgY2hhbmdlcywgd2l0aG91dCBkZWxldGluZyBzdHlsZUVsICovXG4gICAgY29uc3QgaW5uZXJPYnNlcnZlciA9IG5ldyBNdXRhdGlvbk9ic2VydmVyKCgobXV0YXRpb25zKSA9PiB7XG4gICAgICAgIGZvciAobGV0IGkgPSAwOyBpIDwgbXV0YXRpb25zLmxlbmd0aDsgaSArPSAxKSB7XG4gICAgICAgICAgICBjb25zdCBtID0gbXV0YXRpb25zW2ldO1xuICAgICAgICAgICAgLy8gQHRzLWlnbm9yZVxuICAgICAgICAgICAgaWYgKHByb3RlY3RTdHlsZUVsLmhhc0F0dHJpYnV0ZSgnbW9kJykgJiYgcHJvdGVjdFN0eWxlRWwuZ2V0QXR0cmlidXRlKCdtb2QnKSA9PT0gJ2lubmVyJykge1xuICAgICAgICAgICAgICAgIC8vIEB0cy1pZ25vcmVcbiAgICAgICAgICAgICAgICBwcm90ZWN0U3R5bGVFbC5yZW1vdmVBdHRyaWJ1dGUoJ21vZCcpO1xuICAgICAgICAgICAgICAgIGJyZWFrO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAvLyBAdHMtaWdub3JlXG4gICAgICAgICAgICBwcm90ZWN0U3R5bGVFbC5zZXRBdHRyaWJ1dGUoJ21vZCcsICdpbm5lcicpO1xuICAgICAgICAgICAgbGV0IGlzUHJvdGVjdFN0eWxlRWxNb2RpZmllZCA9IGZhbHNlO1xuXG4gICAgICAgICAgICAvKipcbiAgICAgICAgICAgICAqIGZ1cnRoZXIsIHRoZXJlIGFyZSB0d28gbXV0dWFsbHkgZXhjbHVzaXZlIHNpdHVhdGlvbnM6IGVpdGhlciB0aGVyZSB3ZXJlIGNoYW5nZXNcbiAgICAgICAgICAgICAqIHRoZSB0ZXh0IG9mIHByb3RlY3RTdHlsZUVsLCBlaXRoZXIgdGhlcmUgd2FzIHJlbW92ZXMgYSB3aG9sZSBjaGlsZCBcInRleHRcIlxuICAgICAgICAgICAgICogZWxlbWVudCBvZiBwcm90ZWN0U3R5bGVFbCB3ZSdsbCBwcm9jZXNzIGJvdGggb2YgdGhlbVxuICAgICAgICAgICAgICovXG4gICAgICAgICAgICBpZiAobS5yZW1vdmVkTm9kZXMubGVuZ3RoID4gMCkge1xuICAgICAgICAgICAgICAgIGZvciAobGV0IGogPSAwOyBqIDwgbS5yZW1vdmVkTm9kZXMubGVuZ3RoOyBqICs9IDEpIHtcbiAgICAgICAgICAgICAgICAgICAgaXNQcm90ZWN0U3R5bGVFbE1vZGlmaWVkID0gdHJ1ZTtcbiAgICAgICAgICAgICAgICAgICAgcHJvdGVjdFN0eWxlRWwuYXBwZW5kQ2hpbGQobS5yZW1vdmVkTm9kZXNbal0pO1xuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH0gZWxzZSBpZiAobS5vbGRWYWx1ZSkge1xuICAgICAgICAgICAgICAgIGlzUHJvdGVjdFN0eWxlRWxNb2RpZmllZCA9IHRydWU7XG4gICAgICAgICAgICAgICAgLy8gZXNsaW50LWRpc2FibGUtbmV4dC1saW5lIG5vLXBhcmFtLXJlYXNzaWduXG4gICAgICAgICAgICAgICAgcHJvdGVjdFN0eWxlRWwudGV4dENvbnRlbnQgPSBtLm9sZFZhbHVlO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICBpZiAoIWlzUHJvdGVjdFN0eWxlRWxNb2RpZmllZCkge1xuICAgICAgICAgICAgICAgIC8vIEB0cy1pZ25vcmVcbiAgICAgICAgICAgICAgICBwcm90ZWN0U3R5bGVFbC5yZW1vdmVBdHRyaWJ1dGUoJ21vZCcpO1xuICAgICAgICAgICAgfVxuICAgICAgICB9XG4gICAgfSkpO1xuXG4gICAgaW5uZXJPYnNlcnZlci5vYnNlcnZlKHByb3RlY3RTdHlsZUVsLCB7XG4gICAgICAgIGNoaWxkTGlzdDogdHJ1ZSxcbiAgICAgICAgY2hhcmFjdGVyRGF0YTogdHJ1ZSxcbiAgICAgICAgc3VidHJlZTogdHJ1ZSxcbiAgICAgICAgY2hhcmFjdGVyRGF0YU9sZFZhbHVlOiB0cnVlLFxuICAgIH0pO1xufTtcblxuLyoqXG4gKiBBcHBsaWVzIGNzcyBzdHlsZXNoZWV0XG4gKiBAcGFyYW0gc3R5bGVTZWxlY3RvcnMgQXJyYXkgb2Ygc3R5bGVzaGVldHMgb3Igc2VsZWN0b3JzXG4gKiBAcGFyYW0gdmVyYm9zZSBsb2dnaW5nXG4gKi9cbmNvbnN0IGFwcGx5Q3NzID0gKHN0eWxlU2VsZWN0b3JzOiBzdHJpbmdbXSwgdmVyYm9zZTogYm9vbGVhbikgPT4ge1xuICAgIGlmICghc3R5bGVTZWxlY3RvcnMgfHwgIXN0eWxlU2VsZWN0b3JzLmxlbmd0aCkge1xuICAgICAgICByZXR1cm47XG4gICAgfVxuXG4gICAgbG9nTWVzc2FnZSh2ZXJib3NlLCBgY3NzIGxlbmd0aDogJHtzdHlsZVNlbGVjdG9ycy5sZW5ndGh9YCk7XG5cbiAgICBjb25zdCBzdHlsZUVsZW1lbnQgPSBkb2N1bWVudC5jcmVhdGVFbGVtZW50KCdzdHlsZScpO1xuICAgIHN0eWxlRWxlbWVudC5zZXRBdHRyaWJ1dGUoJ3R5cGUnLCAndGV4dC9jc3MnKTtcbiAgICAoZG9jdW1lbnQuaGVhZCB8fCBkb2N1bWVudC5kb2N1bWVudEVsZW1lbnQpLmFwcGVuZENoaWxkKHN0eWxlRWxlbWVudCk7XG5cbiAgICBjb25zdCBzZWxlY3RvcnMgPSBzdHlsZVNlbGVjdG9ycy5tYXAoKHMpID0+IHMudHJpbSgpKTtcblxuICAgIHNlbGVjdG9ycy5mb3JFYWNoKChzZWxlY3RvcikgPT4ge1xuICAgICAgICB0cnkge1xuICAgICAgICAgICAgc3R5bGVFbGVtZW50LnNoZWV0Py5pbnNlcnRSdWxlKHNlbGVjdG9yKTtcbiAgICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICAgICAgbG9nTWVzc2FnZSh2ZXJib3NlLCBgV2FzIHVuYWJsZSB0byBpbmplY3Qgc2VsZWN0b3I6ICR7c2VsZWN0b3J9LCBkdWUgdG8gZXJyb3I6ICR7ZX1gKTtcbiAgICAgICAgfVxuICAgIH0pO1xuXG4gICAgcHJvdGVjdFN0eWxlRWxlbWVudENvbnRlbnQoc3R5bGVFbGVtZW50KTtcbn07XG5cbi8qKlxuICogQXBwbGllcyBFeHRlbmRlZCBDc3Mgc3R5bGVzaGVldFxuICpcbiAqIEBwYXJhbSBleHRlbmRlZENzcyBBcnJheSB3aXRoIEV4dGVuZGVkQ3NzIHN0eWxlc2hlZXRzXG4gKiBAcGFyYW0gdmVyYm9zZSBsb2dnaW5nXG4gKi9cbmNvbnN0IGFwcGx5RXh0ZW5kZWRDc3MgPSAoZXh0ZW5kZWRDc3M6IHN0cmluZ1tdLCB2ZXJib3NlOiBib29sZWFuKSA9PiB7XG4gICAgaWYgKCFleHRlbmRlZENzcyB8fCAhZXh0ZW5kZWRDc3MubGVuZ3RoKSB7XG4gICAgICAgIHJldHVybjtcbiAgICB9XG5cbiAgICBsb2dNZXNzYWdlKHZlcmJvc2UsIGBleHRlbmRlZCBjc3MgbGVuZ3RoOiAke2V4dGVuZGVkQ3NzLmxlbmd0aH1gKTtcbiAgICBjb25zdCBleHRDc3MgPSBuZXcgRXh0ZW5kZWRDc3Moe1xuICAgICAgICBzdHlsZVNoZWV0OiBleHRlbmRlZENzc1xuICAgICAgICAgICAgLmZpbHRlcigocykgPT4gcy5sZW5ndGggPiAwKVxuICAgICAgICAgICAgLm1hcCgocykgPT4gcy50cmltKCkpXG4gICAgICAgICAgICAubWFwKChzKSA9PiAoc1tzLmxlbmd0aCAtIDFdICE9PSAnfScgPyBgJHtzfSB7ZGlzcGxheTpub25lIWltcG9ydGFudDt9YCA6IHMpKVxuICAgICAgICAgICAgLmpvaW4oJ1xcbicpLFxuICAgIH0pO1xuICAgIGV4dENzcy5hcHBseSgpO1xufTtcblxuLyoqXG4gKiBBcHBsaWVzIGluamVjdGVkIHNjcmlwdCBhbmQgY3NzXG4gKlxuICogQHBhcmFtIHNlbGVjdG9yc0FuZFNjcmlwdHNcbiAqIEBwYXJhbSB2ZXJib3NlXG4gKi9cbmNvbnN0IGFwcGx5QWR2YW5jZWRCbG9ja2luZ0RhdGEgPSAoc2VsZWN0b3JzQW5kU2NyaXB0czogU2VsZWN0b3JzQW5kU2NyaXB0cywgdmVyYm9zZSA9IHRydWUpID0+IHtcbiAgICBsb2dNZXNzYWdlKHZlcmJvc2UsICdBcHBseWluZyBzY3JpcHRzIGFuZCBjc3MuLicpO1xuICAgIGxvZ01lc3NhZ2UodmVyYm9zZSwgYEZyYW1lIHVybDogJHt3aW5kb3cubG9jYXRpb24uaHJlZn1gKTtcblxuICAgIGFwcGx5U2NyaXB0cyhzZWxlY3RvcnNBbmRTY3JpcHRzLnNjcmlwdHMsIHZlcmJvc2UpO1xuICAgIGFwcGx5Q3NzKHNlbGVjdG9yc0FuZFNjcmlwdHMuY3NzSW5qZWN0LCB2ZXJib3NlKTtcbiAgICBhcHBseUV4dGVuZGVkQ3NzKHNlbGVjdG9yc0FuZFNjcmlwdHMuY3NzRXh0ZW5kZWQsIHZlcmJvc2UpO1xuXG4gICAgbG9nTWVzc2FnZSh2ZXJib3NlLCAnQXBwbHlpbmcgc2NyaXB0cyBhbmQgY3NzIC0gZG9uZScpO1xufTtcblxuY29uc3QgaW5pdCA9IGFzeW5jICgpID0+IHtcbiAgICBpZiAoZG9jdW1lbnQgaW5zdGFuY2VvZiBIVE1MRG9jdW1lbnQpIHtcbiAgICAgICAgaWYgKHdpbmRvdy5sb2NhdGlvbi5ocmVmICYmIHdpbmRvdy5sb2NhdGlvbi5ocmVmLmluZGV4T2YoJ2h0dHAnKSA9PT0gMCkge1xuICAgICAgICAgICAgY29uc3Qgc3RhcnRHZXR0aW5nU2NyaXB0cyA9IERhdGUubm93KCk7XG4gICAgICAgICAgICBsZXQgc2VsZWN0b3JzQW5kU2NyaXB0cztcbiAgICAgICAgICAgIHRyeSB7XG4gICAgICAgICAgICAgICAgc2VsZWN0b3JzQW5kU2NyaXB0cyA9IGF3YWl0IGdldFNlbGVjdG9yc0FuZFNjcmlwdHMoKTtcbiAgICAgICAgICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhlKTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgY29uc29sZS5sb2coYFRpbWUgdG8gZ2V0IHNlbGVjdG9ycyBhbmQgc2NyaXB0cyBmcm9tIG5hdGl2ZSBwYWdlIHRvIGNvbnRlbnQgc2NyaXB0OiAke0RhdGUubm93KCkgLSBzdGFydEdldHRpbmdTY3JpcHRzfSBtc2ApO1xuXG4gICAgICAgICAgICBpZiAoc2VsZWN0b3JzQW5kU2NyaXB0cykge1xuICAgICAgICAgICAgICAgIGFwcGx5QWR2YW5jZWRCbG9ja2luZ0RhdGEoc2VsZWN0b3JzQW5kU2NyaXB0cywgZmFsc2UpO1xuICAgICAgICAgICAgfVxuICAgICAgICB9XG4gICAgfVxufTtcblxuZXhwb3J0IGNvbnN0IGNvbnRlbnQgPSB7XG4gICAgaW5pdCxcbn07XG4iLCIvKipcbiAqIENvcHlyaWdodCAoYykgMjAxNC1wcmVzZW50LCBGYWNlYm9vaywgSW5jLlxuICpcbiAqIFRoaXMgc291cmNlIGNvZGUgaXMgbGljZW5zZWQgdW5kZXIgdGhlIE1JVCBsaWNlbnNlIGZvdW5kIGluIHRoZVxuICogTElDRU5TRSBmaWxlIGluIHRoZSByb290IGRpcmVjdG9yeSBvZiB0aGlzIHNvdXJjZSB0cmVlLlxuICovXG5cbnZhciBydW50aW1lID0gKGZ1bmN0aW9uIChleHBvcnRzKSB7XG4gIFwidXNlIHN0cmljdFwiO1xuXG4gIHZhciBPcCA9IE9iamVjdC5wcm90b3R5cGU7XG4gIHZhciBoYXNPd24gPSBPcC5oYXNPd25Qcm9wZXJ0eTtcbiAgdmFyIHVuZGVmaW5lZDsgLy8gTW9yZSBjb21wcmVzc2libGUgdGhhbiB2b2lkIDAuXG4gIHZhciAkU3ltYm9sID0gdHlwZW9mIFN5bWJvbCA9PT0gXCJmdW5jdGlvblwiID8gU3ltYm9sIDoge307XG4gIHZhciBpdGVyYXRvclN5bWJvbCA9ICRTeW1ib2wuaXRlcmF0b3IgfHwgXCJAQGl0ZXJhdG9yXCI7XG4gIHZhciBhc3luY0l0ZXJhdG9yU3ltYm9sID0gJFN5bWJvbC5hc3luY0l0ZXJhdG9yIHx8IFwiQEBhc3luY0l0ZXJhdG9yXCI7XG4gIHZhciB0b1N0cmluZ1RhZ1N5bWJvbCA9ICRTeW1ib2wudG9TdHJpbmdUYWcgfHwgXCJAQHRvU3RyaW5nVGFnXCI7XG5cbiAgZnVuY3Rpb24gZGVmaW5lKG9iaiwga2V5LCB2YWx1ZSkge1xuICAgIE9iamVjdC5kZWZpbmVQcm9wZXJ0eShvYmosIGtleSwge1xuICAgICAgdmFsdWU6IHZhbHVlLFxuICAgICAgZW51bWVyYWJsZTogdHJ1ZSxcbiAgICAgIGNvbmZpZ3VyYWJsZTogdHJ1ZSxcbiAgICAgIHdyaXRhYmxlOiB0cnVlXG4gICAgfSk7XG4gICAgcmV0dXJuIG9ialtrZXldO1xuICB9XG4gIHRyeSB7XG4gICAgLy8gSUUgOCBoYXMgYSBicm9rZW4gT2JqZWN0LmRlZmluZVByb3BlcnR5IHRoYXQgb25seSB3b3JrcyBvbiBET00gb2JqZWN0cy5cbiAgICBkZWZpbmUoe30sIFwiXCIpO1xuICB9IGNhdGNoIChlcnIpIHtcbiAgICBkZWZpbmUgPSBmdW5jdGlvbihvYmosIGtleSwgdmFsdWUpIHtcbiAgICAgIHJldHVybiBvYmpba2V5XSA9IHZhbHVlO1xuICAgIH07XG4gIH1cblxuICBmdW5jdGlvbiB3cmFwKGlubmVyRm4sIG91dGVyRm4sIHNlbGYsIHRyeUxvY3NMaXN0KSB7XG4gICAgLy8gSWYgb3V0ZXJGbiBwcm92aWRlZCBhbmQgb3V0ZXJGbi5wcm90b3R5cGUgaXMgYSBHZW5lcmF0b3IsIHRoZW4gb3V0ZXJGbi5wcm90b3R5cGUgaW5zdGFuY2VvZiBHZW5lcmF0b3IuXG4gICAgdmFyIHByb3RvR2VuZXJhdG9yID0gb3V0ZXJGbiAmJiBvdXRlckZuLnByb3RvdHlwZSBpbnN0YW5jZW9mIEdlbmVyYXRvciA/IG91dGVyRm4gOiBHZW5lcmF0b3I7XG4gICAgdmFyIGdlbmVyYXRvciA9IE9iamVjdC5jcmVhdGUocHJvdG9HZW5lcmF0b3IucHJvdG90eXBlKTtcbiAgICB2YXIgY29udGV4dCA9IG5ldyBDb250ZXh0KHRyeUxvY3NMaXN0IHx8IFtdKTtcblxuICAgIC8vIFRoZSAuX2ludm9rZSBtZXRob2QgdW5pZmllcyB0aGUgaW1wbGVtZW50YXRpb25zIG9mIHRoZSAubmV4dCxcbiAgICAvLyAudGhyb3csIGFuZCAucmV0dXJuIG1ldGhvZHMuXG4gICAgZ2VuZXJhdG9yLl9pbnZva2UgPSBtYWtlSW52b2tlTWV0aG9kKGlubmVyRm4sIHNlbGYsIGNvbnRleHQpO1xuXG4gICAgcmV0dXJuIGdlbmVyYXRvcjtcbiAgfVxuICBleHBvcnRzLndyYXAgPSB3cmFwO1xuXG4gIC8vIFRyeS9jYXRjaCBoZWxwZXIgdG8gbWluaW1pemUgZGVvcHRpbWl6YXRpb25zLiBSZXR1cm5zIGEgY29tcGxldGlvblxuICAvLyByZWNvcmQgbGlrZSBjb250ZXh0LnRyeUVudHJpZXNbaV0uY29tcGxldGlvbi4gVGhpcyBpbnRlcmZhY2UgY291bGRcbiAgLy8gaGF2ZSBiZWVuIChhbmQgd2FzIHByZXZpb3VzbHkpIGRlc2lnbmVkIHRvIHRha2UgYSBjbG9zdXJlIHRvIGJlXG4gIC8vIGludm9rZWQgd2l0aG91dCBhcmd1bWVudHMsIGJ1dCBpbiBhbGwgdGhlIGNhc2VzIHdlIGNhcmUgYWJvdXQgd2VcbiAgLy8gYWxyZWFkeSBoYXZlIGFuIGV4aXN0aW5nIG1ldGhvZCB3ZSB3YW50IHRvIGNhbGwsIHNvIHRoZXJlJ3Mgbm8gbmVlZFxuICAvLyB0byBjcmVhdGUgYSBuZXcgZnVuY3Rpb24gb2JqZWN0LiBXZSBjYW4gZXZlbiBnZXQgYXdheSB3aXRoIGFzc3VtaW5nXG4gIC8vIHRoZSBtZXRob2QgdGFrZXMgZXhhY3RseSBvbmUgYXJndW1lbnQsIHNpbmNlIHRoYXQgaGFwcGVucyB0byBiZSB0cnVlXG4gIC8vIGluIGV2ZXJ5IGNhc2UsIHNvIHdlIGRvbid0IGhhdmUgdG8gdG91Y2ggdGhlIGFyZ3VtZW50cyBvYmplY3QuIFRoZVxuICAvLyBvbmx5IGFkZGl0aW9uYWwgYWxsb2NhdGlvbiByZXF1aXJlZCBpcyB0aGUgY29tcGxldGlvbiByZWNvcmQsIHdoaWNoXG4gIC8vIGhhcyBhIHN0YWJsZSBzaGFwZSBhbmQgc28gaG9wZWZ1bGx5IHNob3VsZCBiZSBjaGVhcCB0byBhbGxvY2F0ZS5cbiAgZnVuY3Rpb24gdHJ5Q2F0Y2goZm4sIG9iaiwgYXJnKSB7XG4gICAgdHJ5IHtcbiAgICAgIHJldHVybiB7IHR5cGU6IFwibm9ybWFsXCIsIGFyZzogZm4uY2FsbChvYmosIGFyZykgfTtcbiAgICB9IGNhdGNoIChlcnIpIHtcbiAgICAgIHJldHVybiB7IHR5cGU6IFwidGhyb3dcIiwgYXJnOiBlcnIgfTtcbiAgICB9XG4gIH1cblxuICB2YXIgR2VuU3RhdGVTdXNwZW5kZWRTdGFydCA9IFwic3VzcGVuZGVkU3RhcnRcIjtcbiAgdmFyIEdlblN0YXRlU3VzcGVuZGVkWWllbGQgPSBcInN1c3BlbmRlZFlpZWxkXCI7XG4gIHZhciBHZW5TdGF0ZUV4ZWN1dGluZyA9IFwiZXhlY3V0aW5nXCI7XG4gIHZhciBHZW5TdGF0ZUNvbXBsZXRlZCA9IFwiY29tcGxldGVkXCI7XG5cbiAgLy8gUmV0dXJuaW5nIHRoaXMgb2JqZWN0IGZyb20gdGhlIGlubmVyRm4gaGFzIHRoZSBzYW1lIGVmZmVjdCBhc1xuICAvLyBicmVha2luZyBvdXQgb2YgdGhlIGRpc3BhdGNoIHN3aXRjaCBzdGF0ZW1lbnQuXG4gIHZhciBDb250aW51ZVNlbnRpbmVsID0ge307XG5cbiAgLy8gRHVtbXkgY29uc3RydWN0b3IgZnVuY3Rpb25zIHRoYXQgd2UgdXNlIGFzIHRoZSAuY29uc3RydWN0b3IgYW5kXG4gIC8vIC5jb25zdHJ1Y3Rvci5wcm90b3R5cGUgcHJvcGVydGllcyBmb3IgZnVuY3Rpb25zIHRoYXQgcmV0dXJuIEdlbmVyYXRvclxuICAvLyBvYmplY3RzLiBGb3IgZnVsbCBzcGVjIGNvbXBsaWFuY2UsIHlvdSBtYXkgd2lzaCB0byBjb25maWd1cmUgeW91clxuICAvLyBtaW5pZmllciBub3QgdG8gbWFuZ2xlIHRoZSBuYW1lcyBvZiB0aGVzZSB0d28gZnVuY3Rpb25zLlxuICBmdW5jdGlvbiBHZW5lcmF0b3IoKSB7fVxuICBmdW5jdGlvbiBHZW5lcmF0b3JGdW5jdGlvbigpIHt9XG4gIGZ1bmN0aW9uIEdlbmVyYXRvckZ1bmN0aW9uUHJvdG90eXBlKCkge31cblxuICAvLyBUaGlzIGlzIGEgcG9seWZpbGwgZm9yICVJdGVyYXRvclByb3RvdHlwZSUgZm9yIGVudmlyb25tZW50cyB0aGF0XG4gIC8vIGRvbid0IG5hdGl2ZWx5IHN1cHBvcnQgaXQuXG4gIHZhciBJdGVyYXRvclByb3RvdHlwZSA9IHt9O1xuICBJdGVyYXRvclByb3RvdHlwZVtpdGVyYXRvclN5bWJvbF0gPSBmdW5jdGlvbiAoKSB7XG4gICAgcmV0dXJuIHRoaXM7XG4gIH07XG5cbiAgdmFyIGdldFByb3RvID0gT2JqZWN0LmdldFByb3RvdHlwZU9mO1xuICB2YXIgTmF0aXZlSXRlcmF0b3JQcm90b3R5cGUgPSBnZXRQcm90byAmJiBnZXRQcm90byhnZXRQcm90byh2YWx1ZXMoW10pKSk7XG4gIGlmIChOYXRpdmVJdGVyYXRvclByb3RvdHlwZSAmJlxuICAgICAgTmF0aXZlSXRlcmF0b3JQcm90b3R5cGUgIT09IE9wICYmXG4gICAgICBoYXNPd24uY2FsbChOYXRpdmVJdGVyYXRvclByb3RvdHlwZSwgaXRlcmF0b3JTeW1ib2wpKSB7XG4gICAgLy8gVGhpcyBlbnZpcm9ubWVudCBoYXMgYSBuYXRpdmUgJUl0ZXJhdG9yUHJvdG90eXBlJTsgdXNlIGl0IGluc3RlYWRcbiAgICAvLyBvZiB0aGUgcG9seWZpbGwuXG4gICAgSXRlcmF0b3JQcm90b3R5cGUgPSBOYXRpdmVJdGVyYXRvclByb3RvdHlwZTtcbiAgfVxuXG4gIHZhciBHcCA9IEdlbmVyYXRvckZ1bmN0aW9uUHJvdG90eXBlLnByb3RvdHlwZSA9XG4gICAgR2VuZXJhdG9yLnByb3RvdHlwZSA9IE9iamVjdC5jcmVhdGUoSXRlcmF0b3JQcm90b3R5cGUpO1xuICBHZW5lcmF0b3JGdW5jdGlvbi5wcm90b3R5cGUgPSBHcC5jb25zdHJ1Y3RvciA9IEdlbmVyYXRvckZ1bmN0aW9uUHJvdG90eXBlO1xuICBHZW5lcmF0b3JGdW5jdGlvblByb3RvdHlwZS5jb25zdHJ1Y3RvciA9IEdlbmVyYXRvckZ1bmN0aW9uO1xuICBHZW5lcmF0b3JGdW5jdGlvbi5kaXNwbGF5TmFtZSA9IGRlZmluZShcbiAgICBHZW5lcmF0b3JGdW5jdGlvblByb3RvdHlwZSxcbiAgICB0b1N0cmluZ1RhZ1N5bWJvbCxcbiAgICBcIkdlbmVyYXRvckZ1bmN0aW9uXCJcbiAgKTtcblxuICAvLyBIZWxwZXIgZm9yIGRlZmluaW5nIHRoZSAubmV4dCwgLnRocm93LCBhbmQgLnJldHVybiBtZXRob2RzIG9mIHRoZVxuICAvLyBJdGVyYXRvciBpbnRlcmZhY2UgaW4gdGVybXMgb2YgYSBzaW5nbGUgLl9pbnZva2UgbWV0aG9kLlxuICBmdW5jdGlvbiBkZWZpbmVJdGVyYXRvck1ldGhvZHMocHJvdG90eXBlKSB7XG4gICAgW1wibmV4dFwiLCBcInRocm93XCIsIFwicmV0dXJuXCJdLmZvckVhY2goZnVuY3Rpb24obWV0aG9kKSB7XG4gICAgICBkZWZpbmUocHJvdG90eXBlLCBtZXRob2QsIGZ1bmN0aW9uKGFyZykge1xuICAgICAgICByZXR1cm4gdGhpcy5faW52b2tlKG1ldGhvZCwgYXJnKTtcbiAgICAgIH0pO1xuICAgIH0pO1xuICB9XG5cbiAgZXhwb3J0cy5pc0dlbmVyYXRvckZ1bmN0aW9uID0gZnVuY3Rpb24oZ2VuRnVuKSB7XG4gICAgdmFyIGN0b3IgPSB0eXBlb2YgZ2VuRnVuID09PSBcImZ1bmN0aW9uXCIgJiYgZ2VuRnVuLmNvbnN0cnVjdG9yO1xuICAgIHJldHVybiBjdG9yXG4gICAgICA/IGN0b3IgPT09IEdlbmVyYXRvckZ1bmN0aW9uIHx8XG4gICAgICAgIC8vIEZvciB0aGUgbmF0aXZlIEdlbmVyYXRvckZ1bmN0aW9uIGNvbnN0cnVjdG9yLCB0aGUgYmVzdCB3ZSBjYW5cbiAgICAgICAgLy8gZG8gaXMgdG8gY2hlY2sgaXRzIC5uYW1lIHByb3BlcnR5LlxuICAgICAgICAoY3Rvci5kaXNwbGF5TmFtZSB8fCBjdG9yLm5hbWUpID09PSBcIkdlbmVyYXRvckZ1bmN0aW9uXCJcbiAgICAgIDogZmFsc2U7XG4gIH07XG5cbiAgZXhwb3J0cy5tYXJrID0gZnVuY3Rpb24oZ2VuRnVuKSB7XG4gICAgaWYgKE9iamVjdC5zZXRQcm90b3R5cGVPZikge1xuICAgICAgT2JqZWN0LnNldFByb3RvdHlwZU9mKGdlbkZ1biwgR2VuZXJhdG9yRnVuY3Rpb25Qcm90b3R5cGUpO1xuICAgIH0gZWxzZSB7XG4gICAgICBnZW5GdW4uX19wcm90b19fID0gR2VuZXJhdG9yRnVuY3Rpb25Qcm90b3R5cGU7XG4gICAgICBkZWZpbmUoZ2VuRnVuLCB0b1N0cmluZ1RhZ1N5bWJvbCwgXCJHZW5lcmF0b3JGdW5jdGlvblwiKTtcbiAgICB9XG4gICAgZ2VuRnVuLnByb3RvdHlwZSA9IE9iamVjdC5jcmVhdGUoR3ApO1xuICAgIHJldHVybiBnZW5GdW47XG4gIH07XG5cbiAgLy8gV2l0aGluIHRoZSBib2R5IG9mIGFueSBhc3luYyBmdW5jdGlvbiwgYGF3YWl0IHhgIGlzIHRyYW5zZm9ybWVkIHRvXG4gIC8vIGB5aWVsZCByZWdlbmVyYXRvclJ1bnRpbWUuYXdyYXAoeClgLCBzbyB0aGF0IHRoZSBydW50aW1lIGNhbiB0ZXN0XG4gIC8vIGBoYXNPd24uY2FsbCh2YWx1ZSwgXCJfX2F3YWl0XCIpYCB0byBkZXRlcm1pbmUgaWYgdGhlIHlpZWxkZWQgdmFsdWUgaXNcbiAgLy8gbWVhbnQgdG8gYmUgYXdhaXRlZC5cbiAgZXhwb3J0cy5hd3JhcCA9IGZ1bmN0aW9uKGFyZykge1xuICAgIHJldHVybiB7IF9fYXdhaXQ6IGFyZyB9O1xuICB9O1xuXG4gIGZ1bmN0aW9uIEFzeW5jSXRlcmF0b3IoZ2VuZXJhdG9yLCBQcm9taXNlSW1wbCkge1xuICAgIGZ1bmN0aW9uIGludm9rZShtZXRob2QsIGFyZywgcmVzb2x2ZSwgcmVqZWN0KSB7XG4gICAgICB2YXIgcmVjb3JkID0gdHJ5Q2F0Y2goZ2VuZXJhdG9yW21ldGhvZF0sIGdlbmVyYXRvciwgYXJnKTtcbiAgICAgIGlmIChyZWNvcmQudHlwZSA9PT0gXCJ0aHJvd1wiKSB7XG4gICAgICAgIHJlamVjdChyZWNvcmQuYXJnKTtcbiAgICAgIH0gZWxzZSB7XG4gICAgICAgIHZhciByZXN1bHQgPSByZWNvcmQuYXJnO1xuICAgICAgICB2YXIgdmFsdWUgPSByZXN1bHQudmFsdWU7XG4gICAgICAgIGlmICh2YWx1ZSAmJlxuICAgICAgICAgICAgdHlwZW9mIHZhbHVlID09PSBcIm9iamVjdFwiICYmXG4gICAgICAgICAgICBoYXNPd24uY2FsbCh2YWx1ZSwgXCJfX2F3YWl0XCIpKSB7XG4gICAgICAgICAgcmV0dXJuIFByb21pc2VJbXBsLnJlc29sdmUodmFsdWUuX19hd2FpdCkudGhlbihmdW5jdGlvbih2YWx1ZSkge1xuICAgICAgICAgICAgaW52b2tlKFwibmV4dFwiLCB2YWx1ZSwgcmVzb2x2ZSwgcmVqZWN0KTtcbiAgICAgICAgICB9LCBmdW5jdGlvbihlcnIpIHtcbiAgICAgICAgICAgIGludm9rZShcInRocm93XCIsIGVyciwgcmVzb2x2ZSwgcmVqZWN0KTtcbiAgICAgICAgICB9KTtcbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiBQcm9taXNlSW1wbC5yZXNvbHZlKHZhbHVlKS50aGVuKGZ1bmN0aW9uKHVud3JhcHBlZCkge1xuICAgICAgICAgIC8vIFdoZW4gYSB5aWVsZGVkIFByb21pc2UgaXMgcmVzb2x2ZWQsIGl0cyBmaW5hbCB2YWx1ZSBiZWNvbWVzXG4gICAgICAgICAgLy8gdGhlIC52YWx1ZSBvZiB0aGUgUHJvbWlzZTx7dmFsdWUsZG9uZX0+IHJlc3VsdCBmb3IgdGhlXG4gICAgICAgICAgLy8gY3VycmVudCBpdGVyYXRpb24uXG4gICAgICAgICAgcmVzdWx0LnZhbHVlID0gdW53cmFwcGVkO1xuICAgICAgICAgIHJlc29sdmUocmVzdWx0KTtcbiAgICAgICAgfSwgZnVuY3Rpb24oZXJyb3IpIHtcbiAgICAgICAgICAvLyBJZiBhIHJlamVjdGVkIFByb21pc2Ugd2FzIHlpZWxkZWQsIHRocm93IHRoZSByZWplY3Rpb24gYmFja1xuICAgICAgICAgIC8vIGludG8gdGhlIGFzeW5jIGdlbmVyYXRvciBmdW5jdGlvbiBzbyBpdCBjYW4gYmUgaGFuZGxlZCB0aGVyZS5cbiAgICAgICAgICByZXR1cm4gaW52b2tlKFwidGhyb3dcIiwgZXJyb3IsIHJlc29sdmUsIHJlamVjdCk7XG4gICAgICAgIH0pO1xuICAgICAgfVxuICAgIH1cblxuICAgIHZhciBwcmV2aW91c1Byb21pc2U7XG5cbiAgICBmdW5jdGlvbiBlbnF1ZXVlKG1ldGhvZCwgYXJnKSB7XG4gICAgICBmdW5jdGlvbiBjYWxsSW52b2tlV2l0aE1ldGhvZEFuZEFyZygpIHtcbiAgICAgICAgcmV0dXJuIG5ldyBQcm9taXNlSW1wbChmdW5jdGlvbihyZXNvbHZlLCByZWplY3QpIHtcbiAgICAgICAgICBpbnZva2UobWV0aG9kLCBhcmcsIHJlc29sdmUsIHJlamVjdCk7XG4gICAgICAgIH0pO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gcHJldmlvdXNQcm9taXNlID1cbiAgICAgICAgLy8gSWYgZW5xdWV1ZSBoYXMgYmVlbiBjYWxsZWQgYmVmb3JlLCB0aGVuIHdlIHdhbnQgdG8gd2FpdCB1bnRpbFxuICAgICAgICAvLyBhbGwgcHJldmlvdXMgUHJvbWlzZXMgaGF2ZSBiZWVuIHJlc29sdmVkIGJlZm9yZSBjYWxsaW5nIGludm9rZSxcbiAgICAgICAgLy8gc28gdGhhdCByZXN1bHRzIGFyZSBhbHdheXMgZGVsaXZlcmVkIGluIHRoZSBjb3JyZWN0IG9yZGVyLiBJZlxuICAgICAgICAvLyBlbnF1ZXVlIGhhcyBub3QgYmVlbiBjYWxsZWQgYmVmb3JlLCB0aGVuIGl0IGlzIGltcG9ydGFudCB0b1xuICAgICAgICAvLyBjYWxsIGludm9rZSBpbW1lZGlhdGVseSwgd2l0aG91dCB3YWl0aW5nIG9uIGEgY2FsbGJhY2sgdG8gZmlyZSxcbiAgICAgICAgLy8gc28gdGhhdCB0aGUgYXN5bmMgZ2VuZXJhdG9yIGZ1bmN0aW9uIGhhcyB0aGUgb3Bwb3J0dW5pdHkgdG8gZG9cbiAgICAgICAgLy8gYW55IG5lY2Vzc2FyeSBzZXR1cCBpbiBhIHByZWRpY3RhYmxlIHdheS4gVGhpcyBwcmVkaWN0YWJpbGl0eVxuICAgICAgICAvLyBpcyB3aHkgdGhlIFByb21pc2UgY29uc3RydWN0b3Igc3luY2hyb25vdXNseSBpbnZva2VzIGl0c1xuICAgICAgICAvLyBleGVjdXRvciBjYWxsYmFjaywgYW5kIHdoeSBhc3luYyBmdW5jdGlvbnMgc3luY2hyb25vdXNseVxuICAgICAgICAvLyBleGVjdXRlIGNvZGUgYmVmb3JlIHRoZSBmaXJzdCBhd2FpdC4gU2luY2Ugd2UgaW1wbGVtZW50IHNpbXBsZVxuICAgICAgICAvLyBhc3luYyBmdW5jdGlvbnMgaW4gdGVybXMgb2YgYXN5bmMgZ2VuZXJhdG9ycywgaXQgaXMgZXNwZWNpYWxseVxuICAgICAgICAvLyBpbXBvcnRhbnQgdG8gZ2V0IHRoaXMgcmlnaHQsIGV2ZW4gdGhvdWdoIGl0IHJlcXVpcmVzIGNhcmUuXG4gICAgICAgIHByZXZpb3VzUHJvbWlzZSA/IHByZXZpb3VzUHJvbWlzZS50aGVuKFxuICAgICAgICAgIGNhbGxJbnZva2VXaXRoTWV0aG9kQW5kQXJnLFxuICAgICAgICAgIC8vIEF2b2lkIHByb3BhZ2F0aW5nIGZhaWx1cmVzIHRvIFByb21pc2VzIHJldHVybmVkIGJ5IGxhdGVyXG4gICAgICAgICAgLy8gaW52b2NhdGlvbnMgb2YgdGhlIGl0ZXJhdG9yLlxuICAgICAgICAgIGNhbGxJbnZva2VXaXRoTWV0aG9kQW5kQXJnXG4gICAgICAgICkgOiBjYWxsSW52b2tlV2l0aE1ldGhvZEFuZEFyZygpO1xuICAgIH1cblxuICAgIC8vIERlZmluZSB0aGUgdW5pZmllZCBoZWxwZXIgbWV0aG9kIHRoYXQgaXMgdXNlZCB0byBpbXBsZW1lbnQgLm5leHQsXG4gICAgLy8gLnRocm93LCBhbmQgLnJldHVybiAoc2VlIGRlZmluZUl0ZXJhdG9yTWV0aG9kcykuXG4gICAgdGhpcy5faW52b2tlID0gZW5xdWV1ZTtcbiAgfVxuXG4gIGRlZmluZUl0ZXJhdG9yTWV0aG9kcyhBc3luY0l0ZXJhdG9yLnByb3RvdHlwZSk7XG4gIEFzeW5jSXRlcmF0b3IucHJvdG90eXBlW2FzeW5jSXRlcmF0b3JTeW1ib2xdID0gZnVuY3Rpb24gKCkge1xuICAgIHJldHVybiB0aGlzO1xuICB9O1xuICBleHBvcnRzLkFzeW5jSXRlcmF0b3IgPSBBc3luY0l0ZXJhdG9yO1xuXG4gIC8vIE5vdGUgdGhhdCBzaW1wbGUgYXN5bmMgZnVuY3Rpb25zIGFyZSBpbXBsZW1lbnRlZCBvbiB0b3Agb2ZcbiAgLy8gQXN5bmNJdGVyYXRvciBvYmplY3RzOyB0aGV5IGp1c3QgcmV0dXJuIGEgUHJvbWlzZSBmb3IgdGhlIHZhbHVlIG9mXG4gIC8vIHRoZSBmaW5hbCByZXN1bHQgcHJvZHVjZWQgYnkgdGhlIGl0ZXJhdG9yLlxuICBleHBvcnRzLmFzeW5jID0gZnVuY3Rpb24oaW5uZXJGbiwgb3V0ZXJGbiwgc2VsZiwgdHJ5TG9jc0xpc3QsIFByb21pc2VJbXBsKSB7XG4gICAgaWYgKFByb21pc2VJbXBsID09PSB2b2lkIDApIFByb21pc2VJbXBsID0gUHJvbWlzZTtcblxuICAgIHZhciBpdGVyID0gbmV3IEFzeW5jSXRlcmF0b3IoXG4gICAgICB3cmFwKGlubmVyRm4sIG91dGVyRm4sIHNlbGYsIHRyeUxvY3NMaXN0KSxcbiAgICAgIFByb21pc2VJbXBsXG4gICAgKTtcblxuICAgIHJldHVybiBleHBvcnRzLmlzR2VuZXJhdG9yRnVuY3Rpb24ob3V0ZXJGbilcbiAgICAgID8gaXRlciAvLyBJZiBvdXRlckZuIGlzIGEgZ2VuZXJhdG9yLCByZXR1cm4gdGhlIGZ1bGwgaXRlcmF0b3IuXG4gICAgICA6IGl0ZXIubmV4dCgpLnRoZW4oZnVuY3Rpb24ocmVzdWx0KSB7XG4gICAgICAgICAgcmV0dXJuIHJlc3VsdC5kb25lID8gcmVzdWx0LnZhbHVlIDogaXRlci5uZXh0KCk7XG4gICAgICAgIH0pO1xuICB9O1xuXG4gIGZ1bmN0aW9uIG1ha2VJbnZva2VNZXRob2QoaW5uZXJGbiwgc2VsZiwgY29udGV4dCkge1xuICAgIHZhciBzdGF0ZSA9IEdlblN0YXRlU3VzcGVuZGVkU3RhcnQ7XG5cbiAgICByZXR1cm4gZnVuY3Rpb24gaW52b2tlKG1ldGhvZCwgYXJnKSB7XG4gICAgICBpZiAoc3RhdGUgPT09IEdlblN0YXRlRXhlY3V0aW5nKSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcihcIkdlbmVyYXRvciBpcyBhbHJlYWR5IHJ1bm5pbmdcIik7XG4gICAgICB9XG5cbiAgICAgIGlmIChzdGF0ZSA9PT0gR2VuU3RhdGVDb21wbGV0ZWQpIHtcbiAgICAgICAgaWYgKG1ldGhvZCA9PT0gXCJ0aHJvd1wiKSB7XG4gICAgICAgICAgdGhyb3cgYXJnO1xuICAgICAgICB9XG5cbiAgICAgICAgLy8gQmUgZm9yZ2l2aW5nLCBwZXIgMjUuMy4zLjMuMyBvZiB0aGUgc3BlYzpcbiAgICAgICAgLy8gaHR0cHM6Ly9wZW9wbGUubW96aWxsYS5vcmcvfmpvcmVuZG9yZmYvZXM2LWRyYWZ0Lmh0bWwjc2VjLWdlbmVyYXRvcnJlc3VtZVxuICAgICAgICByZXR1cm4gZG9uZVJlc3VsdCgpO1xuICAgICAgfVxuXG4gICAgICBjb250ZXh0Lm1ldGhvZCA9IG1ldGhvZDtcbiAgICAgIGNvbnRleHQuYXJnID0gYXJnO1xuXG4gICAgICB3aGlsZSAodHJ1ZSkge1xuICAgICAgICB2YXIgZGVsZWdhdGUgPSBjb250ZXh0LmRlbGVnYXRlO1xuICAgICAgICBpZiAoZGVsZWdhdGUpIHtcbiAgICAgICAgICB2YXIgZGVsZWdhdGVSZXN1bHQgPSBtYXliZUludm9rZURlbGVnYXRlKGRlbGVnYXRlLCBjb250ZXh0KTtcbiAgICAgICAgICBpZiAoZGVsZWdhdGVSZXN1bHQpIHtcbiAgICAgICAgICAgIGlmIChkZWxlZ2F0ZVJlc3VsdCA9PT0gQ29udGludWVTZW50aW5lbCkgY29udGludWU7XG4gICAgICAgICAgICByZXR1cm4gZGVsZWdhdGVSZXN1bHQ7XG4gICAgICAgICAgfVxuICAgICAgICB9XG5cbiAgICAgICAgaWYgKGNvbnRleHQubWV0aG9kID09PSBcIm5leHRcIikge1xuICAgICAgICAgIC8vIFNldHRpbmcgY29udGV4dC5fc2VudCBmb3IgbGVnYWN5IHN1cHBvcnQgb2YgQmFiZWwnc1xuICAgICAgICAgIC8vIGZ1bmN0aW9uLnNlbnQgaW1wbGVtZW50YXRpb24uXG4gICAgICAgICAgY29udGV4dC5zZW50ID0gY29udGV4dC5fc2VudCA9IGNvbnRleHQuYXJnO1xuXG4gICAgICAgIH0gZWxzZSBpZiAoY29udGV4dC5tZXRob2QgPT09IFwidGhyb3dcIikge1xuICAgICAgICAgIGlmIChzdGF0ZSA9PT0gR2VuU3RhdGVTdXNwZW5kZWRTdGFydCkge1xuICAgICAgICAgICAgc3RhdGUgPSBHZW5TdGF0ZUNvbXBsZXRlZDtcbiAgICAgICAgICAgIHRocm93IGNvbnRleHQuYXJnO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIGNvbnRleHQuZGlzcGF0Y2hFeGNlcHRpb24oY29udGV4dC5hcmcpO1xuXG4gICAgICAgIH0gZWxzZSBpZiAoY29udGV4dC5tZXRob2QgPT09IFwicmV0dXJuXCIpIHtcbiAgICAgICAgICBjb250ZXh0LmFicnVwdChcInJldHVyblwiLCBjb250ZXh0LmFyZyk7XG4gICAgICAgIH1cblxuICAgICAgICBzdGF0ZSA9IEdlblN0YXRlRXhlY3V0aW5nO1xuXG4gICAgICAgIHZhciByZWNvcmQgPSB0cnlDYXRjaChpbm5lckZuLCBzZWxmLCBjb250ZXh0KTtcbiAgICAgICAgaWYgKHJlY29yZC50eXBlID09PSBcIm5vcm1hbFwiKSB7XG4gICAgICAgICAgLy8gSWYgYW4gZXhjZXB0aW9uIGlzIHRocm93biBmcm9tIGlubmVyRm4sIHdlIGxlYXZlIHN0YXRlID09PVxuICAgICAgICAgIC8vIEdlblN0YXRlRXhlY3V0aW5nIGFuZCBsb29wIGJhY2sgZm9yIGFub3RoZXIgaW52b2NhdGlvbi5cbiAgICAgICAgICBzdGF0ZSA9IGNvbnRleHQuZG9uZVxuICAgICAgICAgICAgPyBHZW5TdGF0ZUNvbXBsZXRlZFxuICAgICAgICAgICAgOiBHZW5TdGF0ZVN1c3BlbmRlZFlpZWxkO1xuXG4gICAgICAgICAgaWYgKHJlY29yZC5hcmcgPT09IENvbnRpbnVlU2VudGluZWwpIHtcbiAgICAgICAgICAgIGNvbnRpbnVlO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIHJldHVybiB7XG4gICAgICAgICAgICB2YWx1ZTogcmVjb3JkLmFyZyxcbiAgICAgICAgICAgIGRvbmU6IGNvbnRleHQuZG9uZVxuICAgICAgICAgIH07XG5cbiAgICAgICAgfSBlbHNlIGlmIChyZWNvcmQudHlwZSA9PT0gXCJ0aHJvd1wiKSB7XG4gICAgICAgICAgc3RhdGUgPSBHZW5TdGF0ZUNvbXBsZXRlZDtcbiAgICAgICAgICAvLyBEaXNwYXRjaCB0aGUgZXhjZXB0aW9uIGJ5IGxvb3BpbmcgYmFjayBhcm91bmQgdG8gdGhlXG4gICAgICAgICAgLy8gY29udGV4dC5kaXNwYXRjaEV4Y2VwdGlvbihjb250ZXh0LmFyZykgY2FsbCBhYm92ZS5cbiAgICAgICAgICBjb250ZXh0Lm1ldGhvZCA9IFwidGhyb3dcIjtcbiAgICAgICAgICBjb250ZXh0LmFyZyA9IHJlY29yZC5hcmc7XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICB9O1xuICB9XG5cbiAgLy8gQ2FsbCBkZWxlZ2F0ZS5pdGVyYXRvcltjb250ZXh0Lm1ldGhvZF0oY29udGV4dC5hcmcpIGFuZCBoYW5kbGUgdGhlXG4gIC8vIHJlc3VsdCwgZWl0aGVyIGJ5IHJldHVybmluZyBhIHsgdmFsdWUsIGRvbmUgfSByZXN1bHQgZnJvbSB0aGVcbiAgLy8gZGVsZWdhdGUgaXRlcmF0b3IsIG9yIGJ5IG1vZGlmeWluZyBjb250ZXh0Lm1ldGhvZCBhbmQgY29udGV4dC5hcmcsXG4gIC8vIHNldHRpbmcgY29udGV4dC5kZWxlZ2F0ZSB0byBudWxsLCBhbmQgcmV0dXJuaW5nIHRoZSBDb250aW51ZVNlbnRpbmVsLlxuICBmdW5jdGlvbiBtYXliZUludm9rZURlbGVnYXRlKGRlbGVnYXRlLCBjb250ZXh0KSB7XG4gICAgdmFyIG1ldGhvZCA9IGRlbGVnYXRlLml0ZXJhdG9yW2NvbnRleHQubWV0aG9kXTtcbiAgICBpZiAobWV0aG9kID09PSB1bmRlZmluZWQpIHtcbiAgICAgIC8vIEEgLnRocm93IG9yIC5yZXR1cm4gd2hlbiB0aGUgZGVsZWdhdGUgaXRlcmF0b3IgaGFzIG5vIC50aHJvd1xuICAgICAgLy8gbWV0aG9kIGFsd2F5cyB0ZXJtaW5hdGVzIHRoZSB5aWVsZCogbG9vcC5cbiAgICAgIGNvbnRleHQuZGVsZWdhdGUgPSBudWxsO1xuXG4gICAgICBpZiAoY29udGV4dC5tZXRob2QgPT09IFwidGhyb3dcIikge1xuICAgICAgICAvLyBOb3RlOiBbXCJyZXR1cm5cIl0gbXVzdCBiZSB1c2VkIGZvciBFUzMgcGFyc2luZyBjb21wYXRpYmlsaXR5LlxuICAgICAgICBpZiAoZGVsZWdhdGUuaXRlcmF0b3JbXCJyZXR1cm5cIl0pIHtcbiAgICAgICAgICAvLyBJZiB0aGUgZGVsZWdhdGUgaXRlcmF0b3IgaGFzIGEgcmV0dXJuIG1ldGhvZCwgZ2l2ZSBpdCBhXG4gICAgICAgICAgLy8gY2hhbmNlIHRvIGNsZWFuIHVwLlxuICAgICAgICAgIGNvbnRleHQubWV0aG9kID0gXCJyZXR1cm5cIjtcbiAgICAgICAgICBjb250ZXh0LmFyZyA9IHVuZGVmaW5lZDtcbiAgICAgICAgICBtYXliZUludm9rZURlbGVnYXRlKGRlbGVnYXRlLCBjb250ZXh0KTtcblxuICAgICAgICAgIGlmIChjb250ZXh0Lm1ldGhvZCA9PT0gXCJ0aHJvd1wiKSB7XG4gICAgICAgICAgICAvLyBJZiBtYXliZUludm9rZURlbGVnYXRlKGNvbnRleHQpIGNoYW5nZWQgY29udGV4dC5tZXRob2QgZnJvbVxuICAgICAgICAgICAgLy8gXCJyZXR1cm5cIiB0byBcInRocm93XCIsIGxldCB0aGF0IG92ZXJyaWRlIHRoZSBUeXBlRXJyb3IgYmVsb3cuXG4gICAgICAgICAgICByZXR1cm4gQ29udGludWVTZW50aW5lbDtcbiAgICAgICAgICB9XG4gICAgICAgIH1cblxuICAgICAgICBjb250ZXh0Lm1ldGhvZCA9IFwidGhyb3dcIjtcbiAgICAgICAgY29udGV4dC5hcmcgPSBuZXcgVHlwZUVycm9yKFxuICAgICAgICAgIFwiVGhlIGl0ZXJhdG9yIGRvZXMgbm90IHByb3ZpZGUgYSAndGhyb3cnIG1ldGhvZFwiKTtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIENvbnRpbnVlU2VudGluZWw7XG4gICAgfVxuXG4gICAgdmFyIHJlY29yZCA9IHRyeUNhdGNoKG1ldGhvZCwgZGVsZWdhdGUuaXRlcmF0b3IsIGNvbnRleHQuYXJnKTtcblxuICAgIGlmIChyZWNvcmQudHlwZSA9PT0gXCJ0aHJvd1wiKSB7XG4gICAgICBjb250ZXh0Lm1ldGhvZCA9IFwidGhyb3dcIjtcbiAgICAgIGNvbnRleHQuYXJnID0gcmVjb3JkLmFyZztcbiAgICAgIGNvbnRleHQuZGVsZWdhdGUgPSBudWxsO1xuICAgICAgcmV0dXJuIENvbnRpbnVlU2VudGluZWw7XG4gICAgfVxuXG4gICAgdmFyIGluZm8gPSByZWNvcmQuYXJnO1xuXG4gICAgaWYgKCEgaW5mbykge1xuICAgICAgY29udGV4dC5tZXRob2QgPSBcInRocm93XCI7XG4gICAgICBjb250ZXh0LmFyZyA9IG5ldyBUeXBlRXJyb3IoXCJpdGVyYXRvciByZXN1bHQgaXMgbm90IGFuIG9iamVjdFwiKTtcbiAgICAgIGNvbnRleHQuZGVsZWdhdGUgPSBudWxsO1xuICAgICAgcmV0dXJuIENvbnRpbnVlU2VudGluZWw7XG4gICAgfVxuXG4gICAgaWYgKGluZm8uZG9uZSkge1xuICAgICAgLy8gQXNzaWduIHRoZSByZXN1bHQgb2YgdGhlIGZpbmlzaGVkIGRlbGVnYXRlIHRvIHRoZSB0ZW1wb3JhcnlcbiAgICAgIC8vIHZhcmlhYmxlIHNwZWNpZmllZCBieSBkZWxlZ2F0ZS5yZXN1bHROYW1lIChzZWUgZGVsZWdhdGVZaWVsZCkuXG4gICAgICBjb250ZXh0W2RlbGVnYXRlLnJlc3VsdE5hbWVdID0gaW5mby52YWx1ZTtcblxuICAgICAgLy8gUmVzdW1lIGV4ZWN1dGlvbiBhdCB0aGUgZGVzaXJlZCBsb2NhdGlvbiAoc2VlIGRlbGVnYXRlWWllbGQpLlxuICAgICAgY29udGV4dC5uZXh0ID0gZGVsZWdhdGUubmV4dExvYztcblxuICAgICAgLy8gSWYgY29udGV4dC5tZXRob2Qgd2FzIFwidGhyb3dcIiBidXQgdGhlIGRlbGVnYXRlIGhhbmRsZWQgdGhlXG4gICAgICAvLyBleGNlcHRpb24sIGxldCB0aGUgb3V0ZXIgZ2VuZXJhdG9yIHByb2NlZWQgbm9ybWFsbHkuIElmXG4gICAgICAvLyBjb250ZXh0Lm1ldGhvZCB3YXMgXCJuZXh0XCIsIGZvcmdldCBjb250ZXh0LmFyZyBzaW5jZSBpdCBoYXMgYmVlblxuICAgICAgLy8gXCJjb25zdW1lZFwiIGJ5IHRoZSBkZWxlZ2F0ZSBpdGVyYXRvci4gSWYgY29udGV4dC5tZXRob2Qgd2FzXG4gICAgICAvLyBcInJldHVyblwiLCBhbGxvdyB0aGUgb3JpZ2luYWwgLnJldHVybiBjYWxsIHRvIGNvbnRpbnVlIGluIHRoZVxuICAgICAgLy8gb3V0ZXIgZ2VuZXJhdG9yLlxuICAgICAgaWYgKGNvbnRleHQubWV0aG9kICE9PSBcInJldHVyblwiKSB7XG4gICAgICAgIGNvbnRleHQubWV0aG9kID0gXCJuZXh0XCI7XG4gICAgICAgIGNvbnRleHQuYXJnID0gdW5kZWZpbmVkO1xuICAgICAgfVxuXG4gICAgfSBlbHNlIHtcbiAgICAgIC8vIFJlLXlpZWxkIHRoZSByZXN1bHQgcmV0dXJuZWQgYnkgdGhlIGRlbGVnYXRlIG1ldGhvZC5cbiAgICAgIHJldHVybiBpbmZvO1xuICAgIH1cblxuICAgIC8vIFRoZSBkZWxlZ2F0ZSBpdGVyYXRvciBpcyBmaW5pc2hlZCwgc28gZm9yZ2V0IGl0IGFuZCBjb250aW51ZSB3aXRoXG4gICAgLy8gdGhlIG91dGVyIGdlbmVyYXRvci5cbiAgICBjb250ZXh0LmRlbGVnYXRlID0gbnVsbDtcbiAgICByZXR1cm4gQ29udGludWVTZW50aW5lbDtcbiAgfVxuXG4gIC8vIERlZmluZSBHZW5lcmF0b3IucHJvdG90eXBlLntuZXh0LHRocm93LHJldHVybn0gaW4gdGVybXMgb2YgdGhlXG4gIC8vIHVuaWZpZWQgLl9pbnZva2UgaGVscGVyIG1ldGhvZC5cbiAgZGVmaW5lSXRlcmF0b3JNZXRob2RzKEdwKTtcblxuICBkZWZpbmUoR3AsIHRvU3RyaW5nVGFnU3ltYm9sLCBcIkdlbmVyYXRvclwiKTtcblxuICAvLyBBIEdlbmVyYXRvciBzaG91bGQgYWx3YXlzIHJldHVybiBpdHNlbGYgYXMgdGhlIGl0ZXJhdG9yIG9iamVjdCB3aGVuIHRoZVxuICAvLyBAQGl0ZXJhdG9yIGZ1bmN0aW9uIGlzIGNhbGxlZCBvbiBpdC4gU29tZSBicm93c2VycycgaW1wbGVtZW50YXRpb25zIG9mIHRoZVxuICAvLyBpdGVyYXRvciBwcm90b3R5cGUgY2hhaW4gaW5jb3JyZWN0bHkgaW1wbGVtZW50IHRoaXMsIGNhdXNpbmcgdGhlIEdlbmVyYXRvclxuICAvLyBvYmplY3QgdG8gbm90IGJlIHJldHVybmVkIGZyb20gdGhpcyBjYWxsLiBUaGlzIGVuc3VyZXMgdGhhdCBkb2Vzbid0IGhhcHBlbi5cbiAgLy8gU2VlIGh0dHBzOi8vZ2l0aHViLmNvbS9mYWNlYm9vay9yZWdlbmVyYXRvci9pc3N1ZXMvMjc0IGZvciBtb3JlIGRldGFpbHMuXG4gIEdwW2l0ZXJhdG9yU3ltYm9sXSA9IGZ1bmN0aW9uKCkge1xuICAgIHJldHVybiB0aGlzO1xuICB9O1xuXG4gIEdwLnRvU3RyaW5nID0gZnVuY3Rpb24oKSB7XG4gICAgcmV0dXJuIFwiW29iamVjdCBHZW5lcmF0b3JdXCI7XG4gIH07XG5cbiAgZnVuY3Rpb24gcHVzaFRyeUVudHJ5KGxvY3MpIHtcbiAgICB2YXIgZW50cnkgPSB7IHRyeUxvYzogbG9jc1swXSB9O1xuXG4gICAgaWYgKDEgaW4gbG9jcykge1xuICAgICAgZW50cnkuY2F0Y2hMb2MgPSBsb2NzWzFdO1xuICAgIH1cblxuICAgIGlmICgyIGluIGxvY3MpIHtcbiAgICAgIGVudHJ5LmZpbmFsbHlMb2MgPSBsb2NzWzJdO1xuICAgICAgZW50cnkuYWZ0ZXJMb2MgPSBsb2NzWzNdO1xuICAgIH1cblxuICAgIHRoaXMudHJ5RW50cmllcy5wdXNoKGVudHJ5KTtcbiAgfVxuXG4gIGZ1bmN0aW9uIHJlc2V0VHJ5RW50cnkoZW50cnkpIHtcbiAgICB2YXIgcmVjb3JkID0gZW50cnkuY29tcGxldGlvbiB8fCB7fTtcbiAgICByZWNvcmQudHlwZSA9IFwibm9ybWFsXCI7XG4gICAgZGVsZXRlIHJlY29yZC5hcmc7XG4gICAgZW50cnkuY29tcGxldGlvbiA9IHJlY29yZDtcbiAgfVxuXG4gIGZ1bmN0aW9uIENvbnRleHQodHJ5TG9jc0xpc3QpIHtcbiAgICAvLyBUaGUgcm9vdCBlbnRyeSBvYmplY3QgKGVmZmVjdGl2ZWx5IGEgdHJ5IHN0YXRlbWVudCB3aXRob3V0IGEgY2F0Y2hcbiAgICAvLyBvciBhIGZpbmFsbHkgYmxvY2spIGdpdmVzIHVzIGEgcGxhY2UgdG8gc3RvcmUgdmFsdWVzIHRocm93biBmcm9tXG4gICAgLy8gbG9jYXRpb25zIHdoZXJlIHRoZXJlIGlzIG5vIGVuY2xvc2luZyB0cnkgc3RhdGVtZW50LlxuICAgIHRoaXMudHJ5RW50cmllcyA9IFt7IHRyeUxvYzogXCJyb290XCIgfV07XG4gICAgdHJ5TG9jc0xpc3QuZm9yRWFjaChwdXNoVHJ5RW50cnksIHRoaXMpO1xuICAgIHRoaXMucmVzZXQodHJ1ZSk7XG4gIH1cblxuICBleHBvcnRzLmtleXMgPSBmdW5jdGlvbihvYmplY3QpIHtcbiAgICB2YXIga2V5cyA9IFtdO1xuICAgIGZvciAodmFyIGtleSBpbiBvYmplY3QpIHtcbiAgICAgIGtleXMucHVzaChrZXkpO1xuICAgIH1cbiAgICBrZXlzLnJldmVyc2UoKTtcblxuICAgIC8vIFJhdGhlciB0aGFuIHJldHVybmluZyBhbiBvYmplY3Qgd2l0aCBhIG5leHQgbWV0aG9kLCB3ZSBrZWVwXG4gICAgLy8gdGhpbmdzIHNpbXBsZSBhbmQgcmV0dXJuIHRoZSBuZXh0IGZ1bmN0aW9uIGl0c2VsZi5cbiAgICByZXR1cm4gZnVuY3Rpb24gbmV4dCgpIHtcbiAgICAgIHdoaWxlIChrZXlzLmxlbmd0aCkge1xuICAgICAgICB2YXIga2V5ID0ga2V5cy5wb3AoKTtcbiAgICAgICAgaWYgKGtleSBpbiBvYmplY3QpIHtcbiAgICAgICAgICBuZXh0LnZhbHVlID0ga2V5O1xuICAgICAgICAgIG5leHQuZG9uZSA9IGZhbHNlO1xuICAgICAgICAgIHJldHVybiBuZXh0O1xuICAgICAgICB9XG4gICAgICB9XG5cbiAgICAgIC8vIFRvIGF2b2lkIGNyZWF0aW5nIGFuIGFkZGl0aW9uYWwgb2JqZWN0LCB3ZSBqdXN0IGhhbmcgdGhlIC52YWx1ZVxuICAgICAgLy8gYW5kIC5kb25lIHByb3BlcnRpZXMgb2ZmIHRoZSBuZXh0IGZ1bmN0aW9uIG9iamVjdCBpdHNlbGYuIFRoaXNcbiAgICAgIC8vIGFsc28gZW5zdXJlcyB0aGF0IHRoZSBtaW5pZmllciB3aWxsIG5vdCBhbm9ueW1pemUgdGhlIGZ1bmN0aW9uLlxuICAgICAgbmV4dC5kb25lID0gdHJ1ZTtcbiAgICAgIHJldHVybiBuZXh0O1xuICAgIH07XG4gIH07XG5cbiAgZnVuY3Rpb24gdmFsdWVzKGl0ZXJhYmxlKSB7XG4gICAgaWYgKGl0ZXJhYmxlKSB7XG4gICAgICB2YXIgaXRlcmF0b3JNZXRob2QgPSBpdGVyYWJsZVtpdGVyYXRvclN5bWJvbF07XG4gICAgICBpZiAoaXRlcmF0b3JNZXRob2QpIHtcbiAgICAgICAgcmV0dXJuIGl0ZXJhdG9yTWV0aG9kLmNhbGwoaXRlcmFibGUpO1xuICAgICAgfVxuXG4gICAgICBpZiAodHlwZW9mIGl0ZXJhYmxlLm5leHQgPT09IFwiZnVuY3Rpb25cIikge1xuICAgICAgICByZXR1cm4gaXRlcmFibGU7XG4gICAgICB9XG5cbiAgICAgIGlmICghaXNOYU4oaXRlcmFibGUubGVuZ3RoKSkge1xuICAgICAgICB2YXIgaSA9IC0xLCBuZXh0ID0gZnVuY3Rpb24gbmV4dCgpIHtcbiAgICAgICAgICB3aGlsZSAoKytpIDwgaXRlcmFibGUubGVuZ3RoKSB7XG4gICAgICAgICAgICBpZiAoaGFzT3duLmNhbGwoaXRlcmFibGUsIGkpKSB7XG4gICAgICAgICAgICAgIG5leHQudmFsdWUgPSBpdGVyYWJsZVtpXTtcbiAgICAgICAgICAgICAgbmV4dC5kb25lID0gZmFsc2U7XG4gICAgICAgICAgICAgIHJldHVybiBuZXh0O1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cblxuICAgICAgICAgIG5leHQudmFsdWUgPSB1bmRlZmluZWQ7XG4gICAgICAgICAgbmV4dC5kb25lID0gdHJ1ZTtcblxuICAgICAgICAgIHJldHVybiBuZXh0O1xuICAgICAgICB9O1xuXG4gICAgICAgIHJldHVybiBuZXh0Lm5leHQgPSBuZXh0O1xuICAgICAgfVxuICAgIH1cblxuICAgIC8vIFJldHVybiBhbiBpdGVyYXRvciB3aXRoIG5vIHZhbHVlcy5cbiAgICByZXR1cm4geyBuZXh0OiBkb25lUmVzdWx0IH07XG4gIH1cbiAgZXhwb3J0cy52YWx1ZXMgPSB2YWx1ZXM7XG5cbiAgZnVuY3Rpb24gZG9uZVJlc3VsdCgpIHtcbiAgICByZXR1cm4geyB2YWx1ZTogdW5kZWZpbmVkLCBkb25lOiB0cnVlIH07XG4gIH1cblxuICBDb250ZXh0LnByb3RvdHlwZSA9IHtcbiAgICBjb25zdHJ1Y3RvcjogQ29udGV4dCxcblxuICAgIHJlc2V0OiBmdW5jdGlvbihza2lwVGVtcFJlc2V0KSB7XG4gICAgICB0aGlzLnByZXYgPSAwO1xuICAgICAgdGhpcy5uZXh0ID0gMDtcbiAgICAgIC8vIFJlc2V0dGluZyBjb250ZXh0Ll9zZW50IGZvciBsZWdhY3kgc3VwcG9ydCBvZiBCYWJlbCdzXG4gICAgICAvLyBmdW5jdGlvbi5zZW50IGltcGxlbWVudGF0aW9uLlxuICAgICAgdGhpcy5zZW50ID0gdGhpcy5fc2VudCA9IHVuZGVmaW5lZDtcbiAgICAgIHRoaXMuZG9uZSA9IGZhbHNlO1xuICAgICAgdGhpcy5kZWxlZ2F0ZSA9IG51bGw7XG5cbiAgICAgIHRoaXMubWV0aG9kID0gXCJuZXh0XCI7XG4gICAgICB0aGlzLmFyZyA9IHVuZGVmaW5lZDtcblxuICAgICAgdGhpcy50cnlFbnRyaWVzLmZvckVhY2gocmVzZXRUcnlFbnRyeSk7XG5cbiAgICAgIGlmICghc2tpcFRlbXBSZXNldCkge1xuICAgICAgICBmb3IgKHZhciBuYW1lIGluIHRoaXMpIHtcbiAgICAgICAgICAvLyBOb3Qgc3VyZSBhYm91dCB0aGUgb3B0aW1hbCBvcmRlciBvZiB0aGVzZSBjb25kaXRpb25zOlxuICAgICAgICAgIGlmIChuYW1lLmNoYXJBdCgwKSA9PT0gXCJ0XCIgJiZcbiAgICAgICAgICAgICAgaGFzT3duLmNhbGwodGhpcywgbmFtZSkgJiZcbiAgICAgICAgICAgICAgIWlzTmFOKCtuYW1lLnNsaWNlKDEpKSkge1xuICAgICAgICAgICAgdGhpc1tuYW1lXSA9IHVuZGVmaW5lZDtcbiAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICB9LFxuXG4gICAgc3RvcDogZnVuY3Rpb24oKSB7XG4gICAgICB0aGlzLmRvbmUgPSB0cnVlO1xuXG4gICAgICB2YXIgcm9vdEVudHJ5ID0gdGhpcy50cnlFbnRyaWVzWzBdO1xuICAgICAgdmFyIHJvb3RSZWNvcmQgPSByb290RW50cnkuY29tcGxldGlvbjtcbiAgICAgIGlmIChyb290UmVjb3JkLnR5cGUgPT09IFwidGhyb3dcIikge1xuICAgICAgICB0aHJvdyByb290UmVjb3JkLmFyZztcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIHRoaXMucnZhbDtcbiAgICB9LFxuXG4gICAgZGlzcGF0Y2hFeGNlcHRpb246IGZ1bmN0aW9uKGV4Y2VwdGlvbikge1xuICAgICAgaWYgKHRoaXMuZG9uZSkge1xuICAgICAgICB0aHJvdyBleGNlcHRpb247XG4gICAgICB9XG5cbiAgICAgIHZhciBjb250ZXh0ID0gdGhpcztcbiAgICAgIGZ1bmN0aW9uIGhhbmRsZShsb2MsIGNhdWdodCkge1xuICAgICAgICByZWNvcmQudHlwZSA9IFwidGhyb3dcIjtcbiAgICAgICAgcmVjb3JkLmFyZyA9IGV4Y2VwdGlvbjtcbiAgICAgICAgY29udGV4dC5uZXh0ID0gbG9jO1xuXG4gICAgICAgIGlmIChjYXVnaHQpIHtcbiAgICAgICAgICAvLyBJZiB0aGUgZGlzcGF0Y2hlZCBleGNlcHRpb24gd2FzIGNhdWdodCBieSBhIGNhdGNoIGJsb2NrLFxuICAgICAgICAgIC8vIHRoZW4gbGV0IHRoYXQgY2F0Y2ggYmxvY2sgaGFuZGxlIHRoZSBleGNlcHRpb24gbm9ybWFsbHkuXG4gICAgICAgICAgY29udGV4dC5tZXRob2QgPSBcIm5leHRcIjtcbiAgICAgICAgICBjb250ZXh0LmFyZyA9IHVuZGVmaW5lZDtcbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiAhISBjYXVnaHQ7XG4gICAgICB9XG5cbiAgICAgIGZvciAodmFyIGkgPSB0aGlzLnRyeUVudHJpZXMubGVuZ3RoIC0gMTsgaSA+PSAwOyAtLWkpIHtcbiAgICAgICAgdmFyIGVudHJ5ID0gdGhpcy50cnlFbnRyaWVzW2ldO1xuICAgICAgICB2YXIgcmVjb3JkID0gZW50cnkuY29tcGxldGlvbjtcblxuICAgICAgICBpZiAoZW50cnkudHJ5TG9jID09PSBcInJvb3RcIikge1xuICAgICAgICAgIC8vIEV4Y2VwdGlvbiB0aHJvd24gb3V0c2lkZSBvZiBhbnkgdHJ5IGJsb2NrIHRoYXQgY291bGQgaGFuZGxlXG4gICAgICAgICAgLy8gaXQsIHNvIHNldCB0aGUgY29tcGxldGlvbiB2YWx1ZSBvZiB0aGUgZW50aXJlIGZ1bmN0aW9uIHRvXG4gICAgICAgICAgLy8gdGhyb3cgdGhlIGV4Y2VwdGlvbi5cbiAgICAgICAgICByZXR1cm4gaGFuZGxlKFwiZW5kXCIpO1xuICAgICAgICB9XG5cbiAgICAgICAgaWYgKGVudHJ5LnRyeUxvYyA8PSB0aGlzLnByZXYpIHtcbiAgICAgICAgICB2YXIgaGFzQ2F0Y2ggPSBoYXNPd24uY2FsbChlbnRyeSwgXCJjYXRjaExvY1wiKTtcbiAgICAgICAgICB2YXIgaGFzRmluYWxseSA9IGhhc093bi5jYWxsKGVudHJ5LCBcImZpbmFsbHlMb2NcIik7XG5cbiAgICAgICAgICBpZiAoaGFzQ2F0Y2ggJiYgaGFzRmluYWxseSkge1xuICAgICAgICAgICAgaWYgKHRoaXMucHJldiA8IGVudHJ5LmNhdGNoTG9jKSB7XG4gICAgICAgICAgICAgIHJldHVybiBoYW5kbGUoZW50cnkuY2F0Y2hMb2MsIHRydWUpO1xuICAgICAgICAgICAgfSBlbHNlIGlmICh0aGlzLnByZXYgPCBlbnRyeS5maW5hbGx5TG9jKSB7XG4gICAgICAgICAgICAgIHJldHVybiBoYW5kbGUoZW50cnkuZmluYWxseUxvYyk7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICB9IGVsc2UgaWYgKGhhc0NhdGNoKSB7XG4gICAgICAgICAgICBpZiAodGhpcy5wcmV2IDwgZW50cnkuY2F0Y2hMb2MpIHtcbiAgICAgICAgICAgICAgcmV0dXJuIGhhbmRsZShlbnRyeS5jYXRjaExvYywgdHJ1ZSk7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICB9IGVsc2UgaWYgKGhhc0ZpbmFsbHkpIHtcbiAgICAgICAgICAgIGlmICh0aGlzLnByZXYgPCBlbnRyeS5maW5hbGx5TG9jKSB7XG4gICAgICAgICAgICAgIHJldHVybiBoYW5kbGUoZW50cnkuZmluYWxseUxvYyk7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwidHJ5IHN0YXRlbWVudCB3aXRob3V0IGNhdGNoIG9yIGZpbmFsbHlcIik7XG4gICAgICAgICAgfVxuICAgICAgICB9XG4gICAgICB9XG4gICAgfSxcblxuICAgIGFicnVwdDogZnVuY3Rpb24odHlwZSwgYXJnKSB7XG4gICAgICBmb3IgKHZhciBpID0gdGhpcy50cnlFbnRyaWVzLmxlbmd0aCAtIDE7IGkgPj0gMDsgLS1pKSB7XG4gICAgICAgIHZhciBlbnRyeSA9IHRoaXMudHJ5RW50cmllc1tpXTtcbiAgICAgICAgaWYgKGVudHJ5LnRyeUxvYyA8PSB0aGlzLnByZXYgJiZcbiAgICAgICAgICAgIGhhc093bi5jYWxsKGVudHJ5LCBcImZpbmFsbHlMb2NcIikgJiZcbiAgICAgICAgICAgIHRoaXMucHJldiA8IGVudHJ5LmZpbmFsbHlMb2MpIHtcbiAgICAgICAgICB2YXIgZmluYWxseUVudHJ5ID0gZW50cnk7XG4gICAgICAgICAgYnJlYWs7XG4gICAgICAgIH1cbiAgICAgIH1cblxuICAgICAgaWYgKGZpbmFsbHlFbnRyeSAmJlxuICAgICAgICAgICh0eXBlID09PSBcImJyZWFrXCIgfHxcbiAgICAgICAgICAgdHlwZSA9PT0gXCJjb250aW51ZVwiKSAmJlxuICAgICAgICAgIGZpbmFsbHlFbnRyeS50cnlMb2MgPD0gYXJnICYmXG4gICAgICAgICAgYXJnIDw9IGZpbmFsbHlFbnRyeS5maW5hbGx5TG9jKSB7XG4gICAgICAgIC8vIElnbm9yZSB0aGUgZmluYWxseSBlbnRyeSBpZiBjb250cm9sIGlzIG5vdCBqdW1waW5nIHRvIGFcbiAgICAgICAgLy8gbG9jYXRpb24gb3V0c2lkZSB0aGUgdHJ5L2NhdGNoIGJsb2NrLlxuICAgICAgICBmaW5hbGx5RW50cnkgPSBudWxsO1xuICAgICAgfVxuXG4gICAgICB2YXIgcmVjb3JkID0gZmluYWxseUVudHJ5ID8gZmluYWxseUVudHJ5LmNvbXBsZXRpb24gOiB7fTtcbiAgICAgIHJlY29yZC50eXBlID0gdHlwZTtcbiAgICAgIHJlY29yZC5hcmcgPSBhcmc7XG5cbiAgICAgIGlmIChmaW5hbGx5RW50cnkpIHtcbiAgICAgICAgdGhpcy5tZXRob2QgPSBcIm5leHRcIjtcbiAgICAgICAgdGhpcy5uZXh0ID0gZmluYWxseUVudHJ5LmZpbmFsbHlMb2M7XG4gICAgICAgIHJldHVybiBDb250aW51ZVNlbnRpbmVsO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gdGhpcy5jb21wbGV0ZShyZWNvcmQpO1xuICAgIH0sXG5cbiAgICBjb21wbGV0ZTogZnVuY3Rpb24ocmVjb3JkLCBhZnRlckxvYykge1xuICAgICAgaWYgKHJlY29yZC50eXBlID09PSBcInRocm93XCIpIHtcbiAgICAgICAgdGhyb3cgcmVjb3JkLmFyZztcbiAgICAgIH1cblxuICAgICAgaWYgKHJlY29yZC50eXBlID09PSBcImJyZWFrXCIgfHxcbiAgICAgICAgICByZWNvcmQudHlwZSA9PT0gXCJjb250aW51ZVwiKSB7XG4gICAgICAgIHRoaXMubmV4dCA9IHJlY29yZC5hcmc7XG4gICAgICB9IGVsc2UgaWYgKHJlY29yZC50eXBlID09PSBcInJldHVyblwiKSB7XG4gICAgICAgIHRoaXMucnZhbCA9IHRoaXMuYXJnID0gcmVjb3JkLmFyZztcbiAgICAgICAgdGhpcy5tZXRob2QgPSBcInJldHVyblwiO1xuICAgICAgICB0aGlzLm5leHQgPSBcImVuZFwiO1xuICAgICAgfSBlbHNlIGlmIChyZWNvcmQudHlwZSA9PT0gXCJub3JtYWxcIiAmJiBhZnRlckxvYykge1xuICAgICAgICB0aGlzLm5leHQgPSBhZnRlckxvYztcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIENvbnRpbnVlU2VudGluZWw7XG4gICAgfSxcblxuICAgIGZpbmlzaDogZnVuY3Rpb24oZmluYWxseUxvYykge1xuICAgICAgZm9yICh2YXIgaSA9IHRoaXMudHJ5RW50cmllcy5sZW5ndGggLSAxOyBpID49IDA7IC0taSkge1xuICAgICAgICB2YXIgZW50cnkgPSB0aGlzLnRyeUVudHJpZXNbaV07XG4gICAgICAgIGlmIChlbnRyeS5maW5hbGx5TG9jID09PSBmaW5hbGx5TG9jKSB7XG4gICAgICAgICAgdGhpcy5jb21wbGV0ZShlbnRyeS5jb21wbGV0aW9uLCBlbnRyeS5hZnRlckxvYyk7XG4gICAgICAgICAgcmVzZXRUcnlFbnRyeShlbnRyeSk7XG4gICAgICAgICAgcmV0dXJuIENvbnRpbnVlU2VudGluZWw7XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICB9LFxuXG4gICAgXCJjYXRjaFwiOiBmdW5jdGlvbih0cnlMb2MpIHtcbiAgICAgIGZvciAodmFyIGkgPSB0aGlzLnRyeUVudHJpZXMubGVuZ3RoIC0gMTsgaSA+PSAwOyAtLWkpIHtcbiAgICAgICAgdmFyIGVudHJ5ID0gdGhpcy50cnlFbnRyaWVzW2ldO1xuICAgICAgICBpZiAoZW50cnkudHJ5TG9jID09PSB0cnlMb2MpIHtcbiAgICAgICAgICB2YXIgcmVjb3JkID0gZW50cnkuY29tcGxldGlvbjtcbiAgICAgICAgICBpZiAocmVjb3JkLnR5cGUgPT09IFwidGhyb3dcIikge1xuICAgICAgICAgICAgdmFyIHRocm93biA9IHJlY29yZC5hcmc7XG4gICAgICAgICAgICByZXNldFRyeUVudHJ5KGVudHJ5KTtcbiAgICAgICAgICB9XG4gICAgICAgICAgcmV0dXJuIHRocm93bjtcbiAgICAgICAgfVxuICAgICAgfVxuXG4gICAgICAvLyBUaGUgY29udGV4dC5jYXRjaCBtZXRob2QgbXVzdCBvbmx5IGJlIGNhbGxlZCB3aXRoIGEgbG9jYXRpb25cbiAgICAgIC8vIGFyZ3VtZW50IHRoYXQgY29ycmVzcG9uZHMgdG8gYSBrbm93biBjYXRjaCBibG9jay5cbiAgICAgIHRocm93IG5ldyBFcnJvcihcImlsbGVnYWwgY2F0Y2ggYXR0ZW1wdFwiKTtcbiAgICB9LFxuXG4gICAgZGVsZWdhdGVZaWVsZDogZnVuY3Rpb24oaXRlcmFibGUsIHJlc3VsdE5hbWUsIG5leHRMb2MpIHtcbiAgICAgIHRoaXMuZGVsZWdhdGUgPSB7XG4gICAgICAgIGl0ZXJhdG9yOiB2YWx1ZXMoaXRlcmFibGUpLFxuICAgICAgICByZXN1bHROYW1lOiByZXN1bHROYW1lLFxuICAgICAgICBuZXh0TG9jOiBuZXh0TG9jXG4gICAgICB9O1xuXG4gICAgICBpZiAodGhpcy5tZXRob2QgPT09IFwibmV4dFwiKSB7XG4gICAgICAgIC8vIERlbGliZXJhdGVseSBmb3JnZXQgdGhlIGxhc3Qgc2VudCB2YWx1ZSBzbyB0aGF0IHdlIGRvbid0XG4gICAgICAgIC8vIGFjY2lkZW50YWxseSBwYXNzIGl0IG9uIHRvIHRoZSBkZWxlZ2F0ZS5cbiAgICAgICAgdGhpcy5hcmcgPSB1bmRlZmluZWQ7XG4gICAgICB9XG5cbiAgICAgIHJldHVybiBDb250aW51ZVNlbnRpbmVsO1xuICAgIH1cbiAgfTtcblxuICAvLyBSZWdhcmRsZXNzIG9mIHdoZXRoZXIgdGhpcyBzY3JpcHQgaXMgZXhlY3V0aW5nIGFzIGEgQ29tbW9uSlMgbW9kdWxlXG4gIC8vIG9yIG5vdCwgcmV0dXJuIHRoZSBydW50aW1lIG9iamVjdCBzbyB0aGF0IHdlIGNhbiBkZWNsYXJlIHRoZSB2YXJpYWJsZVxuICAvLyByZWdlbmVyYXRvclJ1bnRpbWUgaW4gdGhlIG91dGVyIHNjb3BlLCB3aGljaCBhbGxvd3MgdGhpcyBtb2R1bGUgdG8gYmVcbiAgLy8gaW5qZWN0ZWQgZWFzaWx5IGJ5IGBiaW4vcmVnZW5lcmF0b3IgLS1pbmNsdWRlLXJ1bnRpbWUgc2NyaXB0LmpzYC5cbiAgcmV0dXJuIGV4cG9ydHM7XG5cbn0oXG4gIC8vIElmIHRoaXMgc2NyaXB0IGlzIGV4ZWN1dGluZyBhcyBhIENvbW1vbkpTIG1vZHVsZSwgdXNlIG1vZHVsZS5leHBvcnRzXG4gIC8vIGFzIHRoZSByZWdlbmVyYXRvclJ1bnRpbWUgbmFtZXNwYWNlLiBPdGhlcndpc2UgY3JlYXRlIGEgbmV3IGVtcHR5XG4gIC8vIG9iamVjdC4gRWl0aGVyIHdheSwgdGhlIHJlc3VsdGluZyBvYmplY3Qgd2lsbCBiZSB1c2VkIHRvIGluaXRpYWxpemVcbiAgLy8gdGhlIHJlZ2VuZXJhdG9yUnVudGltZSB2YXJpYWJsZSBhdCB0aGUgdG9wIG9mIHRoaXMgZmlsZS5cbiAgdHlwZW9mIG1vZHVsZSA9PT0gXCJvYmplY3RcIiA/IG1vZHVsZS5leHBvcnRzIDoge31cbikpO1xuXG50cnkge1xuICByZWdlbmVyYXRvclJ1bnRpbWUgPSBydW50aW1lO1xufSBjYXRjaCAoYWNjaWRlbnRhbFN0cmljdE1vZGUpIHtcbiAgLy8gVGhpcyBtb2R1bGUgc2hvdWxkIG5vdCBiZSBydW5uaW5nIGluIHN0cmljdCBtb2RlLCBzbyB0aGUgYWJvdmVcbiAgLy8gYXNzaWdubWVudCBzaG91bGQgYWx3YXlzIHdvcmsgdW5sZXNzIHNvbWV0aGluZyBpcyBtaXNjb25maWd1cmVkLiBKdXN0XG4gIC8vIGluIGNhc2UgcnVudGltZS5qcyBhY2NpZGVudGFsbHkgcnVucyBpbiBzdHJpY3QgbW9kZSwgd2UgY2FuIGVzY2FwZVxuICAvLyBzdHJpY3QgbW9kZSB1c2luZyBhIGdsb2JhbCBGdW5jdGlvbiBjYWxsLiBUaGlzIGNvdWxkIGNvbmNlaXZhYmx5IGZhaWxcbiAgLy8gaWYgYSBDb250ZW50IFNlY3VyaXR5IFBvbGljeSBmb3JiaWRzIHVzaW5nIEZ1bmN0aW9uLCBidXQgaW4gdGhhdCBjYXNlXG4gIC8vIHRoZSBwcm9wZXIgc29sdXRpb24gaXMgdG8gZml4IHRoZSBhY2NpZGVudGFsIHN0cmljdCBtb2RlIHByb2JsZW0uIElmXG4gIC8vIHlvdSd2ZSBtaXNjb25maWd1cmVkIHlvdXIgYnVuZGxlciB0byBmb3JjZSBzdHJpY3QgbW9kZSBhbmQgYXBwbGllZCBhXG4gIC8vIENTUCB0byBmb3JiaWQgRnVuY3Rpb24sIGFuZCB5b3UncmUgbm90IHdpbGxpbmcgdG8gZml4IGVpdGhlciBvZiB0aG9zZVxuICAvLyBwcm9ibGVtcywgcGxlYXNlIGRldGFpbCB5b3VyIHVuaXF1ZSBwcmVkaWNhbWVudCBpbiBhIEdpdEh1YiBpc3N1ZS5cbiAgRnVuY3Rpb24oXCJyXCIsIFwicmVnZW5lcmF0b3JSdW50aW1lID0gclwiKShydW50aW1lKTtcbn1cbiIsIihmdW5jdGlvbiAoZ2xvYmFsLCBmYWN0b3J5KSB7XG4gIGlmICh0eXBlb2YgZGVmaW5lID09PSBcImZ1bmN0aW9uXCIgJiYgZGVmaW5lLmFtZCkge1xuICAgIGRlZmluZShcIndlYmV4dGVuc2lvbi1wb2x5ZmlsbFwiLCBbXCJtb2R1bGVcIl0sIGZhY3RvcnkpO1xuICB9IGVsc2UgaWYgKHR5cGVvZiBleHBvcnRzICE9PSBcInVuZGVmaW5lZFwiKSB7XG4gICAgZmFjdG9yeShtb2R1bGUpO1xuICB9IGVsc2Uge1xuICAgIHZhciBtb2QgPSB7XG4gICAgICBleHBvcnRzOiB7fVxuICAgIH07XG4gICAgZmFjdG9yeShtb2QpO1xuICAgIGdsb2JhbC5icm93c2VyID0gbW9kLmV4cG9ydHM7XG4gIH1cbn0pKHR5cGVvZiBnbG9iYWxUaGlzICE9PSBcInVuZGVmaW5lZFwiID8gZ2xvYmFsVGhpcyA6IHR5cGVvZiBzZWxmICE9PSBcInVuZGVmaW5lZFwiID8gc2VsZiA6IHRoaXMsIGZ1bmN0aW9uIChtb2R1bGUpIHtcbiAgLyogd2ViZXh0ZW5zaW9uLXBvbHlmaWxsIC0gdjAuOC4wIC0gVHVlIEFwciAyMCAyMDIxIDExOjI3OjM4ICovXG5cbiAgLyogLSotIE1vZGU6IGluZGVudC10YWJzLW1vZGU6IG5pbDsganMtaW5kZW50LWxldmVsOiAyIC0qLSAqL1xuXG4gIC8qIHZpbTogc2V0IHN0cz0yIHN3PTIgZXQgdHc9ODA6ICovXG5cbiAgLyogVGhpcyBTb3VyY2UgQ29kZSBGb3JtIGlzIHN1YmplY3QgdG8gdGhlIHRlcm1zIG9mIHRoZSBNb3ppbGxhIFB1YmxpY1xuICAgKiBMaWNlbnNlLCB2LiAyLjAuIElmIGEgY29weSBvZiB0aGUgTVBMIHdhcyBub3QgZGlzdHJpYnV0ZWQgd2l0aCB0aGlzXG4gICAqIGZpbGUsIFlvdSBjYW4gb2J0YWluIG9uZSBhdCBodHRwOi8vbW96aWxsYS5vcmcvTVBMLzIuMC8uICovXG4gIFwidXNlIHN0cmljdFwiO1xuXG4gIGlmICh0eXBlb2YgYnJvd3NlciA9PT0gXCJ1bmRlZmluZWRcIiB8fCBPYmplY3QuZ2V0UHJvdG90eXBlT2YoYnJvd3NlcikgIT09IE9iamVjdC5wcm90b3R5cGUpIHtcbiAgICBjb25zdCBDSFJPTUVfU0VORF9NRVNTQUdFX0NBTExCQUNLX05PX1JFU1BPTlNFX01FU1NBR0UgPSBcIlRoZSBtZXNzYWdlIHBvcnQgY2xvc2VkIGJlZm9yZSBhIHJlc3BvbnNlIHdhcyByZWNlaXZlZC5cIjtcbiAgICBjb25zdCBTRU5EX1JFU1BPTlNFX0RFUFJFQ0FUSU9OX1dBUk5JTkcgPSBcIlJldHVybmluZyBhIFByb21pc2UgaXMgdGhlIHByZWZlcnJlZCB3YXkgdG8gc2VuZCBhIHJlcGx5IGZyb20gYW4gb25NZXNzYWdlL29uTWVzc2FnZUV4dGVybmFsIGxpc3RlbmVyLCBhcyB0aGUgc2VuZFJlc3BvbnNlIHdpbGwgYmUgcmVtb3ZlZCBmcm9tIHRoZSBzcGVjcyAoU2VlIGh0dHBzOi8vZGV2ZWxvcGVyLm1vemlsbGEub3JnL2RvY3MvTW96aWxsYS9BZGQtb25zL1dlYkV4dGVuc2lvbnMvQVBJL3J1bnRpbWUvb25NZXNzYWdlKVwiOyAvLyBXcmFwcGluZyB0aGUgYnVsayBvZiB0aGlzIHBvbHlmaWxsIGluIGEgb25lLXRpbWUtdXNlIGZ1bmN0aW9uIGlzIGEgbWlub3JcbiAgICAvLyBvcHRpbWl6YXRpb24gZm9yIEZpcmVmb3guIFNpbmNlIFNwaWRlcm1vbmtleSBkb2VzIG5vdCBmdWxseSBwYXJzZSB0aGVcbiAgICAvLyBjb250ZW50cyBvZiBhIGZ1bmN0aW9uIHVudGlsIHRoZSBmaXJzdCB0aW1lIGl0J3MgY2FsbGVkLCBhbmQgc2luY2UgaXQgd2lsbFxuICAgIC8vIG5ldmVyIGFjdHVhbGx5IG5lZWQgdG8gYmUgY2FsbGVkLCB0aGlzIGFsbG93cyB0aGUgcG9seWZpbGwgdG8gYmUgaW5jbHVkZWRcbiAgICAvLyBpbiBGaXJlZm94IG5lYXJseSBmb3IgZnJlZS5cblxuICAgIGNvbnN0IHdyYXBBUElzID0gZXh0ZW5zaW9uQVBJcyA9PiB7XG4gICAgICAvLyBOT1RFOiBhcGlNZXRhZGF0YSBpcyBhc3NvY2lhdGVkIHRvIHRoZSBjb250ZW50IG9mIHRoZSBhcGktbWV0YWRhdGEuanNvbiBmaWxlXG4gICAgICAvLyBhdCBidWlsZCB0aW1lIGJ5IHJlcGxhY2luZyB0aGUgZm9sbG93aW5nIFwiaW5jbHVkZVwiIHdpdGggdGhlIGNvbnRlbnQgb2YgdGhlXG4gICAgICAvLyBKU09OIGZpbGUuXG4gICAgICBjb25zdCBhcGlNZXRhZGF0YSA9IHtcbiAgICAgICAgXCJhbGFybXNcIjoge1xuICAgICAgICAgIFwiY2xlYXJcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJjbGVhckFsbFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldEFsbFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcImJvb2ttYXJrc1wiOiB7XG4gICAgICAgICAgXCJjcmVhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRDaGlsZHJlblwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFJlY2VudFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFN1YlRyZWVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRUcmVlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwibW92ZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMixcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAyXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZVRyZWVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZWFyY2hcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJ1cGRhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDIsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJicm93c2VyQWN0aW9uXCI6IHtcbiAgICAgICAgICBcImRpc2FibGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwiZmFsbGJhY2tUb05vQ2FsbGJhY2tcIjogdHJ1ZVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJlbmFibGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwiZmFsbGJhY2tUb05vQ2FsbGJhY2tcIjogdHJ1ZVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRCYWRnZUJhY2tncm91bmRDb2xvclwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldEJhZGdlVGV4dFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFBvcHVwXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0VGl0bGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJvcGVuUG9wdXBcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZXRCYWRnZUJhY2tncm91bmRDb2xvclwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJmYWxsYmFja1RvTm9DYWxsYmFja1wiOiB0cnVlXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNldEJhZGdlVGV4dFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJmYWxsYmFja1RvTm9DYWxsYmFja1wiOiB0cnVlXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNldEljb25cIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZXRQb3B1cFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJmYWxsYmFja1RvTm9DYWxsYmFja1wiOiB0cnVlXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNldFRpdGxlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDEsXG4gICAgICAgICAgICBcImZhbGxiYWNrVG9Ob0NhbGxiYWNrXCI6IHRydWVcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwiYnJvd3NpbmdEYXRhXCI6IHtcbiAgICAgICAgICBcInJlbW92ZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMixcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAyXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZUNhY2hlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicmVtb3ZlQ29va2llc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZURvd25sb2Fkc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZUZvcm1EYXRhXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicmVtb3ZlSGlzdG9yeVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZUxvY2FsU3RvcmFnZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZVBhc3N3b3Jkc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZVBsdWdpbkRhdGFcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZXR0aW5nc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcImNvbW1hbmRzXCI6IHtcbiAgICAgICAgICBcImdldEFsbFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcImNvbnRleHRNZW51c1wiOiB7XG4gICAgICAgICAgXCJyZW1vdmVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZW1vdmVBbGxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJ1cGRhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDIsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJjb29raWVzXCI6IHtcbiAgICAgICAgICBcImdldFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldEFsbFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldEFsbENvb2tpZVN0b3Jlc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNldFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcImRldnRvb2xzXCI6IHtcbiAgICAgICAgICBcImluc3BlY3RlZFdpbmRvd1wiOiB7XG4gICAgICAgICAgICBcImV2YWxcIjoge1xuICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDIsXG4gICAgICAgICAgICAgIFwic2luZ2xlQ2FsbGJhY2tBcmdcIjogZmFsc2VcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicGFuZWxzXCI6IHtcbiAgICAgICAgICAgIFwiY3JlYXRlXCI6IHtcbiAgICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDMsXG4gICAgICAgICAgICAgIFwibWF4QXJnc1wiOiAzLFxuICAgICAgICAgICAgICBcInNpbmdsZUNhbGxiYWNrQXJnXCI6IHRydWVcbiAgICAgICAgICAgIH0sXG4gICAgICAgICAgICBcImVsZW1lbnRzXCI6IHtcbiAgICAgICAgICAgICAgXCJjcmVhdGVTaWRlYmFyUGFuZVwiOiB7XG4gICAgICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJkb3dubG9hZHNcIjoge1xuICAgICAgICAgIFwiY2FuY2VsXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZG93bmxvYWRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJlcmFzZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldEZpbGVJY29uXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDJcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwib3BlblwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJmYWxsYmFja1RvTm9DYWxsYmFja1wiOiB0cnVlXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInBhdXNlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicmVtb3ZlRmlsZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlc3VtZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNlYXJjaFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNob3dcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwiZmFsbGJhY2tUb05vQ2FsbGJhY2tcIjogdHJ1ZVxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJleHRlbnNpb25cIjoge1xuICAgICAgICAgIFwiaXNBbGxvd2VkRmlsZVNjaGVtZUFjY2Vzc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImlzQWxsb3dlZEluY29nbml0b0FjY2Vzc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcImhpc3RvcnlcIjoge1xuICAgICAgICAgIFwiYWRkVXJsXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZGVsZXRlQWxsXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZGVsZXRlUmFuZ2VcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJkZWxldGVVcmxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRWaXNpdHNcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZWFyY2hcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJpMThuXCI6IHtcbiAgICAgICAgICBcImRldGVjdExhbmd1YWdlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0QWNjZXB0TGFuZ3VhZ2VzXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwiaWRlbnRpdHlcIjoge1xuICAgICAgICAgIFwibGF1bmNoV2ViQXV0aEZsb3dcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJpZGxlXCI6IHtcbiAgICAgICAgICBcInF1ZXJ5U3RhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJtYW5hZ2VtZW50XCI6IHtcbiAgICAgICAgICBcImdldFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldEFsbFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFNlbGZcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZXRFbmFibGVkXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAyLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDJcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwidW5pbnN0YWxsU2VsZlwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcIm5vdGlmaWNhdGlvbnNcIjoge1xuICAgICAgICAgIFwiY2xlYXJcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJjcmVhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRBbGxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRQZXJtaXNzaW9uTGV2ZWxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJ1cGRhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDIsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJwYWdlQWN0aW9uXCI6IHtcbiAgICAgICAgICBcImdldFBvcHVwXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0VGl0bGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJoaWRlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDEsXG4gICAgICAgICAgICBcImZhbGxiYWNrVG9Ob0NhbGxiYWNrXCI6IHRydWVcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2V0SWNvblwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNldFBvcHVwXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDEsXG4gICAgICAgICAgICBcImZhbGxiYWNrVG9Ob0NhbGxiYWNrXCI6IHRydWVcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2V0VGl0bGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwiZmFsbGJhY2tUb05vQ2FsbGJhY2tcIjogdHJ1ZVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzaG93XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDEsXG4gICAgICAgICAgICBcImZhbGxiYWNrVG9Ob0NhbGxiYWNrXCI6IHRydWVcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwicGVybWlzc2lvbnNcIjoge1xuICAgICAgICAgIFwiY29udGFpbnNcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRBbGxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZW1vdmVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZXF1ZXN0XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwicnVudGltZVwiOiB7XG4gICAgICAgICAgXCJnZXRCYWNrZ3JvdW5kUGFnZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFBsYXRmb3JtSW5mb1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcIm9wZW5PcHRpb25zUGFnZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlcXVlc3RVcGRhdGVDaGVja1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNlbmRNZXNzYWdlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDNcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2VuZE5hdGl2ZU1lc3NhZ2VcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDIsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZXRVbmluc3RhbGxVUkxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJzZXNzaW9uc1wiOiB7XG4gICAgICAgICAgXCJnZXREZXZpY2VzXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0UmVjZW50bHlDbG9zZWRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZXN0b3JlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwic3RvcmFnZVwiOiB7XG4gICAgICAgICAgXCJsb2NhbFwiOiB7XG4gICAgICAgICAgICBcImNsZWFyXCI6IHtcbiAgICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgICB9LFxuICAgICAgICAgICAgXCJnZXRcIjoge1xuICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICAgIH0sXG4gICAgICAgICAgICBcImdldEJ5dGVzSW5Vc2VcIjoge1xuICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICAgIH0sXG4gICAgICAgICAgICBcInJlbW92ZVwiOiB7XG4gICAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgICAgfSxcbiAgICAgICAgICAgIFwic2V0XCI6IHtcbiAgICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgICB9XG4gICAgICAgICAgfSxcbiAgICAgICAgICBcIm1hbmFnZWRcIjoge1xuICAgICAgICAgICAgXCJnZXRcIjoge1xuICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICAgIH0sXG4gICAgICAgICAgICBcImdldEJ5dGVzSW5Vc2VcIjoge1xuICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic3luY1wiOiB7XG4gICAgICAgICAgICBcImNsZWFyXCI6IHtcbiAgICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgICB9LFxuICAgICAgICAgICAgXCJnZXRcIjoge1xuICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICAgIH0sXG4gICAgICAgICAgICBcImdldEJ5dGVzSW5Vc2VcIjoge1xuICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICAgIH0sXG4gICAgICAgICAgICBcInJlbW92ZVwiOiB7XG4gICAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgICAgfSxcbiAgICAgICAgICAgIFwic2V0XCI6IHtcbiAgICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgICB9XG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcInRhYnNcIjoge1xuICAgICAgICAgIFwiY2FwdHVyZVZpc2libGVUYWJcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJjcmVhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJkZXRlY3RMYW5ndWFnZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImRpc2NhcmRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJkdXBsaWNhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJleGVjdXRlU2NyaXB0XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDJcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0Q3VycmVudFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFpvb21cIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRab29tU2V0dGluZ3NcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnb0JhY2tcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnb0ZvcndhcmRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJoaWdobGlnaHRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJpbnNlcnRDU1NcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJtb3ZlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAyLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDJcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicXVlcnlcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZWxvYWRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZW1vdmVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZW1vdmVDU1NcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZW5kTWVzc2FnZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMixcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAzXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNldFpvb21cIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZXRab29tU2V0dGluZ3NcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJ1cGRhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJ0b3BTaXRlc1wiOiB7XG4gICAgICAgICAgXCJnZXRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJ3ZWJOYXZpZ2F0aW9uXCI6IHtcbiAgICAgICAgICBcImdldEFsbEZyYW1lc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldEZyYW1lXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwid2ViUmVxdWVzdFwiOiB7XG4gICAgICAgICAgXCJoYW5kbGVyQmVoYXZpb3JDaGFuZ2VkXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwid2luZG93c1wiOiB7XG4gICAgICAgICAgXCJjcmVhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRBbGxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRDdXJyZW50XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0TGFzdEZvY3VzZWRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZW1vdmVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJ1cGRhdGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDIsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgfTtcblxuICAgICAgaWYgKE9iamVjdC5rZXlzKGFwaU1ldGFkYXRhKS5sZW5ndGggPT09IDApIHtcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiYXBpLW1ldGFkYXRhLmpzb24gaGFzIG5vdCBiZWVuIGluY2x1ZGVkIGluIGJyb3dzZXItcG9seWZpbGxcIik7XG4gICAgICB9XG4gICAgICAvKipcbiAgICAgICAqIEEgV2Vha01hcCBzdWJjbGFzcyB3aGljaCBjcmVhdGVzIGFuZCBzdG9yZXMgYSB2YWx1ZSBmb3IgYW55IGtleSB3aGljaCBkb2VzXG4gICAgICAgKiBub3QgZXhpc3Qgd2hlbiBhY2Nlc3NlZCwgYnV0IGJlaGF2ZXMgZXhhY3RseSBhcyBhbiBvcmRpbmFyeSBXZWFrTWFwXG4gICAgICAgKiBvdGhlcndpc2UuXG4gICAgICAgKlxuICAgICAgICogQHBhcmFtIHtmdW5jdGlvbn0gY3JlYXRlSXRlbVxuICAgICAgICogICAgICAgIEEgZnVuY3Rpb24gd2hpY2ggd2lsbCBiZSBjYWxsZWQgaW4gb3JkZXIgdG8gY3JlYXRlIHRoZSB2YWx1ZSBmb3IgYW55XG4gICAgICAgKiAgICAgICAga2V5IHdoaWNoIGRvZXMgbm90IGV4aXN0LCB0aGUgZmlyc3QgdGltZSBpdCBpcyBhY2Nlc3NlZC4gVGhlXG4gICAgICAgKiAgICAgICAgZnVuY3Rpb24gcmVjZWl2ZXMsIGFzIGl0cyBvbmx5IGFyZ3VtZW50LCB0aGUga2V5IGJlaW5nIGNyZWF0ZWQuXG4gICAgICAgKi9cblxuXG4gICAgICBjbGFzcyBEZWZhdWx0V2Vha01hcCBleHRlbmRzIFdlYWtNYXAge1xuICAgICAgICBjb25zdHJ1Y3RvcihjcmVhdGVJdGVtLCBpdGVtcyA9IHVuZGVmaW5lZCkge1xuICAgICAgICAgIHN1cGVyKGl0ZW1zKTtcbiAgICAgICAgICB0aGlzLmNyZWF0ZUl0ZW0gPSBjcmVhdGVJdGVtO1xuICAgICAgICB9XG5cbiAgICAgICAgZ2V0KGtleSkge1xuICAgICAgICAgIGlmICghdGhpcy5oYXMoa2V5KSkge1xuICAgICAgICAgICAgdGhpcy5zZXQoa2V5LCB0aGlzLmNyZWF0ZUl0ZW0oa2V5KSk7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgcmV0dXJuIHN1cGVyLmdldChrZXkpO1xuICAgICAgICB9XG5cbiAgICAgIH1cbiAgICAgIC8qKlxuICAgICAgICogUmV0dXJucyB0cnVlIGlmIHRoZSBnaXZlbiBvYmplY3QgaXMgYW4gb2JqZWN0IHdpdGggYSBgdGhlbmAgbWV0aG9kLCBhbmQgY2FuXG4gICAgICAgKiB0aGVyZWZvcmUgYmUgYXNzdW1lZCB0byBiZWhhdmUgYXMgYSBQcm9taXNlLlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSB7Kn0gdmFsdWUgVGhlIHZhbHVlIHRvIHRlc3QuXG4gICAgICAgKiBAcmV0dXJucyB7Ym9vbGVhbn0gVHJ1ZSBpZiB0aGUgdmFsdWUgaXMgdGhlbmFibGUuXG4gICAgICAgKi9cblxuXG4gICAgICBjb25zdCBpc1RoZW5hYmxlID0gdmFsdWUgPT4ge1xuICAgICAgICByZXR1cm4gdmFsdWUgJiYgdHlwZW9mIHZhbHVlID09PSBcIm9iamVjdFwiICYmIHR5cGVvZiB2YWx1ZS50aGVuID09PSBcImZ1bmN0aW9uXCI7XG4gICAgICB9O1xuICAgICAgLyoqXG4gICAgICAgKiBDcmVhdGVzIGFuZCByZXR1cm5zIGEgZnVuY3Rpb24gd2hpY2gsIHdoZW4gY2FsbGVkLCB3aWxsIHJlc29sdmUgb3IgcmVqZWN0XG4gICAgICAgKiB0aGUgZ2l2ZW4gcHJvbWlzZSBiYXNlZCBvbiBob3cgaXQgaXMgY2FsbGVkOlxuICAgICAgICpcbiAgICAgICAqIC0gSWYsIHdoZW4gY2FsbGVkLCBgY2hyb21lLnJ1bnRpbWUubGFzdEVycm9yYCBjb250YWlucyBhIG5vbi1udWxsIG9iamVjdCxcbiAgICAgICAqICAgdGhlIHByb21pc2UgaXMgcmVqZWN0ZWQgd2l0aCB0aGF0IHZhbHVlLlxuICAgICAgICogLSBJZiB0aGUgZnVuY3Rpb24gaXMgY2FsbGVkIHdpdGggZXhhY3RseSBvbmUgYXJndW1lbnQsIHRoZSBwcm9taXNlIGlzXG4gICAgICAgKiAgIHJlc29sdmVkIHRvIHRoYXQgdmFsdWUuXG4gICAgICAgKiAtIE90aGVyd2lzZSwgdGhlIHByb21pc2UgaXMgcmVzb2x2ZWQgdG8gYW4gYXJyYXkgY29udGFpbmluZyBhbGwgb2YgdGhlXG4gICAgICAgKiAgIGZ1bmN0aW9uJ3MgYXJndW1lbnRzLlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSB7b2JqZWN0fSBwcm9taXNlXG4gICAgICAgKiAgICAgICAgQW4gb2JqZWN0IGNvbnRhaW5pbmcgdGhlIHJlc29sdXRpb24gYW5kIHJlamVjdGlvbiBmdW5jdGlvbnMgb2YgYVxuICAgICAgICogICAgICAgIHByb21pc2UuXG4gICAgICAgKiBAcGFyYW0ge2Z1bmN0aW9ufSBwcm9taXNlLnJlc29sdmVcbiAgICAgICAqICAgICAgICBUaGUgcHJvbWlzZSdzIHJlc29sdXRpb24gZnVuY3Rpb24uXG4gICAgICAgKiBAcGFyYW0ge2Z1bmN0aW9ufSBwcm9taXNlLnJlamVjdFxuICAgICAgICogICAgICAgIFRoZSBwcm9taXNlJ3MgcmVqZWN0aW9uIGZ1bmN0aW9uLlxuICAgICAgICogQHBhcmFtIHtvYmplY3R9IG1ldGFkYXRhXG4gICAgICAgKiAgICAgICAgTWV0YWRhdGEgYWJvdXQgdGhlIHdyYXBwZWQgbWV0aG9kIHdoaWNoIGhhcyBjcmVhdGVkIHRoZSBjYWxsYmFjay5cbiAgICAgICAqIEBwYXJhbSB7Ym9vbGVhbn0gbWV0YWRhdGEuc2luZ2xlQ2FsbGJhY2tBcmdcbiAgICAgICAqICAgICAgICBXaGV0aGVyIG9yIG5vdCB0aGUgcHJvbWlzZSBpcyByZXNvbHZlZCB3aXRoIG9ubHkgdGhlIGZpcnN0XG4gICAgICAgKiAgICAgICAgYXJndW1lbnQgb2YgdGhlIGNhbGxiYWNrLCBhbHRlcm5hdGl2ZWx5IGFuIGFycmF5IG9mIGFsbCB0aGVcbiAgICAgICAqICAgICAgICBjYWxsYmFjayBhcmd1bWVudHMgaXMgcmVzb2x2ZWQuIEJ5IGRlZmF1bHQsIGlmIHRoZSBjYWxsYmFja1xuICAgICAgICogICAgICAgIGZ1bmN0aW9uIGlzIGludm9rZWQgd2l0aCBvbmx5IGEgc2luZ2xlIGFyZ3VtZW50LCB0aGF0IHdpbGwgYmVcbiAgICAgICAqICAgICAgICByZXNvbHZlZCB0byB0aGUgcHJvbWlzZSwgd2hpbGUgYWxsIGFyZ3VtZW50cyB3aWxsIGJlIHJlc29sdmVkIGFzXG4gICAgICAgKiAgICAgICAgYW4gYXJyYXkgaWYgbXVsdGlwbGUgYXJlIGdpdmVuLlxuICAgICAgICpcbiAgICAgICAqIEByZXR1cm5zIHtmdW5jdGlvbn1cbiAgICAgICAqICAgICAgICBUaGUgZ2VuZXJhdGVkIGNhbGxiYWNrIGZ1bmN0aW9uLlxuICAgICAgICovXG5cblxuICAgICAgY29uc3QgbWFrZUNhbGxiYWNrID0gKHByb21pc2UsIG1ldGFkYXRhKSA9PiB7XG4gICAgICAgIHJldHVybiAoLi4uY2FsbGJhY2tBcmdzKSA9PiB7XG4gICAgICAgICAgaWYgKGV4dGVuc2lvbkFQSXMucnVudGltZS5sYXN0RXJyb3IpIHtcbiAgICAgICAgICAgIHByb21pc2UucmVqZWN0KG5ldyBFcnJvcihleHRlbnNpb25BUElzLnJ1bnRpbWUubGFzdEVycm9yLm1lc3NhZ2UpKTtcbiAgICAgICAgICB9IGVsc2UgaWYgKG1ldGFkYXRhLnNpbmdsZUNhbGxiYWNrQXJnIHx8IGNhbGxiYWNrQXJncy5sZW5ndGggPD0gMSAmJiBtZXRhZGF0YS5zaW5nbGVDYWxsYmFja0FyZyAhPT0gZmFsc2UpIHtcbiAgICAgICAgICAgIHByb21pc2UucmVzb2x2ZShjYWxsYmFja0FyZ3NbMF0pO1xuICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICBwcm9taXNlLnJlc29sdmUoY2FsbGJhY2tBcmdzKTtcbiAgICAgICAgICB9XG4gICAgICAgIH07XG4gICAgICB9O1xuXG4gICAgICBjb25zdCBwbHVyYWxpemVBcmd1bWVudHMgPSBudW1BcmdzID0+IG51bUFyZ3MgPT0gMSA/IFwiYXJndW1lbnRcIiA6IFwiYXJndW1lbnRzXCI7XG4gICAgICAvKipcbiAgICAgICAqIENyZWF0ZXMgYSB3cmFwcGVyIGZ1bmN0aW9uIGZvciBhIG1ldGhvZCB3aXRoIHRoZSBnaXZlbiBuYW1lIGFuZCBtZXRhZGF0YS5cbiAgICAgICAqXG4gICAgICAgKiBAcGFyYW0ge3N0cmluZ30gbmFtZVxuICAgICAgICogICAgICAgIFRoZSBuYW1lIG9mIHRoZSBtZXRob2Qgd2hpY2ggaXMgYmVpbmcgd3JhcHBlZC5cbiAgICAgICAqIEBwYXJhbSB7b2JqZWN0fSBtZXRhZGF0YVxuICAgICAgICogICAgICAgIE1ldGFkYXRhIGFib3V0IHRoZSBtZXRob2QgYmVpbmcgd3JhcHBlZC5cbiAgICAgICAqIEBwYXJhbSB7aW50ZWdlcn0gbWV0YWRhdGEubWluQXJnc1xuICAgICAgICogICAgICAgIFRoZSBtaW5pbXVtIG51bWJlciBvZiBhcmd1bWVudHMgd2hpY2ggbXVzdCBiZSBwYXNzZWQgdG8gdGhlXG4gICAgICAgKiAgICAgICAgZnVuY3Rpb24uIElmIGNhbGxlZCB3aXRoIGZld2VyIHRoYW4gdGhpcyBudW1iZXIgb2YgYXJndW1lbnRzLCB0aGVcbiAgICAgICAqICAgICAgICB3cmFwcGVyIHdpbGwgcmFpc2UgYW4gZXhjZXB0aW9uLlxuICAgICAgICogQHBhcmFtIHtpbnRlZ2VyfSBtZXRhZGF0YS5tYXhBcmdzXG4gICAgICAgKiAgICAgICAgVGhlIG1heGltdW0gbnVtYmVyIG9mIGFyZ3VtZW50cyB3aGljaCBtYXkgYmUgcGFzc2VkIHRvIHRoZVxuICAgICAgICogICAgICAgIGZ1bmN0aW9uLiBJZiBjYWxsZWQgd2l0aCBtb3JlIHRoYW4gdGhpcyBudW1iZXIgb2YgYXJndW1lbnRzLCB0aGVcbiAgICAgICAqICAgICAgICB3cmFwcGVyIHdpbGwgcmFpc2UgYW4gZXhjZXB0aW9uLlxuICAgICAgICogQHBhcmFtIHtib29sZWFufSBtZXRhZGF0YS5zaW5nbGVDYWxsYmFja0FyZ1xuICAgICAgICogICAgICAgIFdoZXRoZXIgb3Igbm90IHRoZSBwcm9taXNlIGlzIHJlc29sdmVkIHdpdGggb25seSB0aGUgZmlyc3RcbiAgICAgICAqICAgICAgICBhcmd1bWVudCBvZiB0aGUgY2FsbGJhY2ssIGFsdGVybmF0aXZlbHkgYW4gYXJyYXkgb2YgYWxsIHRoZVxuICAgICAgICogICAgICAgIGNhbGxiYWNrIGFyZ3VtZW50cyBpcyByZXNvbHZlZC4gQnkgZGVmYXVsdCwgaWYgdGhlIGNhbGxiYWNrXG4gICAgICAgKiAgICAgICAgZnVuY3Rpb24gaXMgaW52b2tlZCB3aXRoIG9ubHkgYSBzaW5nbGUgYXJndW1lbnQsIHRoYXQgd2lsbCBiZVxuICAgICAgICogICAgICAgIHJlc29sdmVkIHRvIHRoZSBwcm9taXNlLCB3aGlsZSBhbGwgYXJndW1lbnRzIHdpbGwgYmUgcmVzb2x2ZWQgYXNcbiAgICAgICAqICAgICAgICBhbiBhcnJheSBpZiBtdWx0aXBsZSBhcmUgZ2l2ZW4uXG4gICAgICAgKlxuICAgICAgICogQHJldHVybnMge2Z1bmN0aW9uKG9iamVjdCwgLi4uKil9XG4gICAgICAgKiAgICAgICBUaGUgZ2VuZXJhdGVkIHdyYXBwZXIgZnVuY3Rpb24uXG4gICAgICAgKi9cblxuXG4gICAgICBjb25zdCB3cmFwQXN5bmNGdW5jdGlvbiA9IChuYW1lLCBtZXRhZGF0YSkgPT4ge1xuICAgICAgICByZXR1cm4gZnVuY3Rpb24gYXN5bmNGdW5jdGlvbldyYXBwZXIodGFyZ2V0LCAuLi5hcmdzKSB7XG4gICAgICAgICAgaWYgKGFyZ3MubGVuZ3RoIDwgbWV0YWRhdGEubWluQXJncykge1xuICAgICAgICAgICAgdGhyb3cgbmV3IEVycm9yKGBFeHBlY3RlZCBhdCBsZWFzdCAke21ldGFkYXRhLm1pbkFyZ3N9ICR7cGx1cmFsaXplQXJndW1lbnRzKG1ldGFkYXRhLm1pbkFyZ3MpfSBmb3IgJHtuYW1lfSgpLCBnb3QgJHthcmdzLmxlbmd0aH1gKTtcbiAgICAgICAgICB9XG5cbiAgICAgICAgICBpZiAoYXJncy5sZW5ndGggPiBtZXRhZGF0YS5tYXhBcmdzKSB7XG4gICAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoYEV4cGVjdGVkIGF0IG1vc3QgJHttZXRhZGF0YS5tYXhBcmdzfSAke3BsdXJhbGl6ZUFyZ3VtZW50cyhtZXRhZGF0YS5tYXhBcmdzKX0gZm9yICR7bmFtZX0oKSwgZ290ICR7YXJncy5sZW5ndGh9YCk7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgcmV0dXJuIG5ldyBQcm9taXNlKChyZXNvbHZlLCByZWplY3QpID0+IHtcbiAgICAgICAgICAgIGlmIChtZXRhZGF0YS5mYWxsYmFja1RvTm9DYWxsYmFjaykge1xuICAgICAgICAgICAgICAvLyBUaGlzIEFQSSBtZXRob2QgaGFzIGN1cnJlbnRseSBubyBjYWxsYmFjayBvbiBDaHJvbWUsIGJ1dCBpdCByZXR1cm4gYSBwcm9taXNlIG9uIEZpcmVmb3gsXG4gICAgICAgICAgICAgIC8vIGFuZCBzbyB0aGUgcG9seWZpbGwgd2lsbCB0cnkgdG8gY2FsbCBpdCB3aXRoIGEgY2FsbGJhY2sgZmlyc3QsIGFuZCBpdCB3aWxsIGZhbGxiYWNrXG4gICAgICAgICAgICAgIC8vIHRvIG5vdCBwYXNzaW5nIHRoZSBjYWxsYmFjayBpZiB0aGUgZmlyc3QgY2FsbCBmYWlscy5cbiAgICAgICAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgICAgICB0YXJnZXRbbmFtZV0oLi4uYXJncywgbWFrZUNhbGxiYWNrKHtcbiAgICAgICAgICAgICAgICAgIHJlc29sdmUsXG4gICAgICAgICAgICAgICAgICByZWplY3RcbiAgICAgICAgICAgICAgICB9LCBtZXRhZGF0YSkpO1xuICAgICAgICAgICAgICB9IGNhdGNoIChjYkVycm9yKSB7XG4gICAgICAgICAgICAgICAgY29uc29sZS53YXJuKGAke25hbWV9IEFQSSBtZXRob2QgZG9lc24ndCBzZWVtIHRvIHN1cHBvcnQgdGhlIGNhbGxiYWNrIHBhcmFtZXRlciwgYCArIFwiZmFsbGluZyBiYWNrIHRvIGNhbGwgaXQgd2l0aG91dCBhIGNhbGxiYWNrOiBcIiwgY2JFcnJvcik7XG4gICAgICAgICAgICAgICAgdGFyZ2V0W25hbWVdKC4uLmFyZ3MpOyAvLyBVcGRhdGUgdGhlIEFQSSBtZXRob2QgbWV0YWRhdGEsIHNvIHRoYXQgdGhlIG5leHQgQVBJIGNhbGxzIHdpbGwgbm90IHRyeSB0b1xuICAgICAgICAgICAgICAgIC8vIHVzZSB0aGUgdW5zdXBwb3J0ZWQgY2FsbGJhY2sgYW55bW9yZS5cblxuICAgICAgICAgICAgICAgIG1ldGFkYXRhLmZhbGxiYWNrVG9Ob0NhbGxiYWNrID0gZmFsc2U7XG4gICAgICAgICAgICAgICAgbWV0YWRhdGEubm9DYWxsYmFjayA9IHRydWU7XG4gICAgICAgICAgICAgICAgcmVzb2x2ZSgpO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9IGVsc2UgaWYgKG1ldGFkYXRhLm5vQ2FsbGJhY2spIHtcbiAgICAgICAgICAgICAgdGFyZ2V0W25hbWVdKC4uLmFyZ3MpO1xuICAgICAgICAgICAgICByZXNvbHZlKCk7XG4gICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICB0YXJnZXRbbmFtZV0oLi4uYXJncywgbWFrZUNhbGxiYWNrKHtcbiAgICAgICAgICAgICAgICByZXNvbHZlLFxuICAgICAgICAgICAgICAgIHJlamVjdFxuICAgICAgICAgICAgICB9LCBtZXRhZGF0YSkpO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH0pO1xuICAgICAgICB9O1xuICAgICAgfTtcbiAgICAgIC8qKlxuICAgICAgICogV3JhcHMgYW4gZXhpc3RpbmcgbWV0aG9kIG9mIHRoZSB0YXJnZXQgb2JqZWN0LCBzbyB0aGF0IGNhbGxzIHRvIGl0IGFyZVxuICAgICAgICogaW50ZXJjZXB0ZWQgYnkgdGhlIGdpdmVuIHdyYXBwZXIgZnVuY3Rpb24uIFRoZSB3cmFwcGVyIGZ1bmN0aW9uIHJlY2VpdmVzLFxuICAgICAgICogYXMgaXRzIGZpcnN0IGFyZ3VtZW50LCB0aGUgb3JpZ2luYWwgYHRhcmdldGAgb2JqZWN0LCBmb2xsb3dlZCBieSBlYWNoIG9mXG4gICAgICAgKiB0aGUgYXJndW1lbnRzIHBhc3NlZCB0byB0aGUgb3JpZ2luYWwgbWV0aG9kLlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSB7b2JqZWN0fSB0YXJnZXRcbiAgICAgICAqICAgICAgICBUaGUgb3JpZ2luYWwgdGFyZ2V0IG9iamVjdCB0aGF0IHRoZSB3cmFwcGVkIG1ldGhvZCBiZWxvbmdzIHRvLlxuICAgICAgICogQHBhcmFtIHtmdW5jdGlvbn0gbWV0aG9kXG4gICAgICAgKiAgICAgICAgVGhlIG1ldGhvZCBiZWluZyB3cmFwcGVkLiBUaGlzIGlzIHVzZWQgYXMgdGhlIHRhcmdldCBvZiB0aGUgUHJveHlcbiAgICAgICAqICAgICAgICBvYmplY3Qgd2hpY2ggaXMgY3JlYXRlZCB0byB3cmFwIHRoZSBtZXRob2QuXG4gICAgICAgKiBAcGFyYW0ge2Z1bmN0aW9ufSB3cmFwcGVyXG4gICAgICAgKiAgICAgICAgVGhlIHdyYXBwZXIgZnVuY3Rpb24gd2hpY2ggaXMgY2FsbGVkIGluIHBsYWNlIG9mIGEgZGlyZWN0IGludm9jYXRpb25cbiAgICAgICAqICAgICAgICBvZiB0aGUgd3JhcHBlZCBtZXRob2QuXG4gICAgICAgKlxuICAgICAgICogQHJldHVybnMge1Byb3h5PGZ1bmN0aW9uPn1cbiAgICAgICAqICAgICAgICBBIFByb3h5IG9iamVjdCBmb3IgdGhlIGdpdmVuIG1ldGhvZCwgd2hpY2ggaW52b2tlcyB0aGUgZ2l2ZW4gd3JhcHBlclxuICAgICAgICogICAgICAgIG1ldGhvZCBpbiBpdHMgcGxhY2UuXG4gICAgICAgKi9cblxuXG4gICAgICBjb25zdCB3cmFwTWV0aG9kID0gKHRhcmdldCwgbWV0aG9kLCB3cmFwcGVyKSA9PiB7XG4gICAgICAgIHJldHVybiBuZXcgUHJveHkobWV0aG9kLCB7XG4gICAgICAgICAgYXBwbHkodGFyZ2V0TWV0aG9kLCB0aGlzT2JqLCBhcmdzKSB7XG4gICAgICAgICAgICByZXR1cm4gd3JhcHBlci5jYWxsKHRoaXNPYmosIHRhcmdldCwgLi4uYXJncyk7XG4gICAgICAgICAgfVxuXG4gICAgICAgIH0pO1xuICAgICAgfTtcblxuICAgICAgbGV0IGhhc093blByb3BlcnR5ID0gRnVuY3Rpb24uY2FsbC5iaW5kKE9iamVjdC5wcm90b3R5cGUuaGFzT3duUHJvcGVydHkpO1xuICAgICAgLyoqXG4gICAgICAgKiBXcmFwcyBhbiBvYmplY3QgaW4gYSBQcm94eSB3aGljaCBpbnRlcmNlcHRzIGFuZCB3cmFwcyBjZXJ0YWluIG1ldGhvZHNcbiAgICAgICAqIGJhc2VkIG9uIHRoZSBnaXZlbiBgd3JhcHBlcnNgIGFuZCBgbWV0YWRhdGFgIG9iamVjdHMuXG4gICAgICAgKlxuICAgICAgICogQHBhcmFtIHtvYmplY3R9IHRhcmdldFxuICAgICAgICogICAgICAgIFRoZSB0YXJnZXQgb2JqZWN0IHRvIHdyYXAuXG4gICAgICAgKlxuICAgICAgICogQHBhcmFtIHtvYmplY3R9IFt3cmFwcGVycyA9IHt9XVxuICAgICAgICogICAgICAgIEFuIG9iamVjdCB0cmVlIGNvbnRhaW5pbmcgd3JhcHBlciBmdW5jdGlvbnMgZm9yIHNwZWNpYWwgY2FzZXMuIEFueVxuICAgICAgICogICAgICAgIGZ1bmN0aW9uIHByZXNlbnQgaW4gdGhpcyBvYmplY3QgdHJlZSBpcyBjYWxsZWQgaW4gcGxhY2Ugb2YgdGhlXG4gICAgICAgKiAgICAgICAgbWV0aG9kIGluIHRoZSBzYW1lIGxvY2F0aW9uIGluIHRoZSBgdGFyZ2V0YCBvYmplY3QgdHJlZS4gVGhlc2VcbiAgICAgICAqICAgICAgICB3cmFwcGVyIG1ldGhvZHMgYXJlIGludm9rZWQgYXMgZGVzY3JpYmVkIGluIHtAc2VlIHdyYXBNZXRob2R9LlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSB7b2JqZWN0fSBbbWV0YWRhdGEgPSB7fV1cbiAgICAgICAqICAgICAgICBBbiBvYmplY3QgdHJlZSBjb250YWluaW5nIG1ldGFkYXRhIHVzZWQgdG8gYXV0b21hdGljYWxseSBnZW5lcmF0ZVxuICAgICAgICogICAgICAgIFByb21pc2UtYmFzZWQgd3JhcHBlciBmdW5jdGlvbnMgZm9yIGFzeW5jaHJvbm91cy4gQW55IGZ1bmN0aW9uIGluXG4gICAgICAgKiAgICAgICAgdGhlIGB0YXJnZXRgIG9iamVjdCB0cmVlIHdoaWNoIGhhcyBhIGNvcnJlc3BvbmRpbmcgbWV0YWRhdGEgb2JqZWN0XG4gICAgICAgKiAgICAgICAgaW4gdGhlIHNhbWUgbG9jYXRpb24gaW4gdGhlIGBtZXRhZGF0YWAgdHJlZSBpcyByZXBsYWNlZCB3aXRoIGFuXG4gICAgICAgKiAgICAgICAgYXV0b21hdGljYWxseS1nZW5lcmF0ZWQgd3JhcHBlciBmdW5jdGlvbiwgYXMgZGVzY3JpYmVkIGluXG4gICAgICAgKiAgICAgICAge0BzZWUgd3JhcEFzeW5jRnVuY3Rpb259XG4gICAgICAgKlxuICAgICAgICogQHJldHVybnMge1Byb3h5PG9iamVjdD59XG4gICAgICAgKi9cblxuICAgICAgY29uc3Qgd3JhcE9iamVjdCA9ICh0YXJnZXQsIHdyYXBwZXJzID0ge30sIG1ldGFkYXRhID0ge30pID0+IHtcbiAgICAgICAgbGV0IGNhY2hlID0gT2JqZWN0LmNyZWF0ZShudWxsKTtcbiAgICAgICAgbGV0IGhhbmRsZXJzID0ge1xuICAgICAgICAgIGhhcyhwcm94eVRhcmdldCwgcHJvcCkge1xuICAgICAgICAgICAgcmV0dXJuIHByb3AgaW4gdGFyZ2V0IHx8IHByb3AgaW4gY2FjaGU7XG4gICAgICAgICAgfSxcblxuICAgICAgICAgIGdldChwcm94eVRhcmdldCwgcHJvcCwgcmVjZWl2ZXIpIHtcbiAgICAgICAgICAgIGlmIChwcm9wIGluIGNhY2hlKSB7XG4gICAgICAgICAgICAgIHJldHVybiBjYWNoZVtwcm9wXTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgaWYgKCEocHJvcCBpbiB0YXJnZXQpKSB7XG4gICAgICAgICAgICAgIHJldHVybiB1bmRlZmluZWQ7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIGxldCB2YWx1ZSA9IHRhcmdldFtwcm9wXTtcblxuICAgICAgICAgICAgaWYgKHR5cGVvZiB2YWx1ZSA9PT0gXCJmdW5jdGlvblwiKSB7XG4gICAgICAgICAgICAgIC8vIFRoaXMgaXMgYSBtZXRob2Qgb24gdGhlIHVuZGVybHlpbmcgb2JqZWN0LiBDaGVjayBpZiB3ZSBuZWVkIHRvIGRvXG4gICAgICAgICAgICAgIC8vIGFueSB3cmFwcGluZy5cbiAgICAgICAgICAgICAgaWYgKHR5cGVvZiB3cmFwcGVyc1twcm9wXSA9PT0gXCJmdW5jdGlvblwiKSB7XG4gICAgICAgICAgICAgICAgLy8gV2UgaGF2ZSBhIHNwZWNpYWwtY2FzZSB3cmFwcGVyIGZvciB0aGlzIG1ldGhvZC5cbiAgICAgICAgICAgICAgICB2YWx1ZSA9IHdyYXBNZXRob2QodGFyZ2V0LCB0YXJnZXRbcHJvcF0sIHdyYXBwZXJzW3Byb3BdKTtcbiAgICAgICAgICAgICAgfSBlbHNlIGlmIChoYXNPd25Qcm9wZXJ0eShtZXRhZGF0YSwgcHJvcCkpIHtcbiAgICAgICAgICAgICAgICAvLyBUaGlzIGlzIGFuIGFzeW5jIG1ldGhvZCB0aGF0IHdlIGhhdmUgbWV0YWRhdGEgZm9yLiBDcmVhdGUgYVxuICAgICAgICAgICAgICAgIC8vIFByb21pc2Ugd3JhcHBlciBmb3IgaXQuXG4gICAgICAgICAgICAgICAgbGV0IHdyYXBwZXIgPSB3cmFwQXN5bmNGdW5jdGlvbihwcm9wLCBtZXRhZGF0YVtwcm9wXSk7XG4gICAgICAgICAgICAgICAgdmFsdWUgPSB3cmFwTWV0aG9kKHRhcmdldCwgdGFyZ2V0W3Byb3BdLCB3cmFwcGVyKTtcbiAgICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgICAvLyBUaGlzIGlzIGEgbWV0aG9kIHRoYXQgd2UgZG9uJ3Qga25vdyBvciBjYXJlIGFib3V0LiBSZXR1cm4gdGhlXG4gICAgICAgICAgICAgICAgLy8gb3JpZ2luYWwgbWV0aG9kLCBib3VuZCB0byB0aGUgdW5kZXJseWluZyBvYmplY3QuXG4gICAgICAgICAgICAgICAgdmFsdWUgPSB2YWx1ZS5iaW5kKHRhcmdldCk7XG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH0gZWxzZSBpZiAodHlwZW9mIHZhbHVlID09PSBcIm9iamVjdFwiICYmIHZhbHVlICE9PSBudWxsICYmIChoYXNPd25Qcm9wZXJ0eSh3cmFwcGVycywgcHJvcCkgfHwgaGFzT3duUHJvcGVydHkobWV0YWRhdGEsIHByb3ApKSkge1xuICAgICAgICAgICAgICAvLyBUaGlzIGlzIGFuIG9iamVjdCB0aGF0IHdlIG5lZWQgdG8gZG8gc29tZSB3cmFwcGluZyBmb3IgdGhlIGNoaWxkcmVuXG4gICAgICAgICAgICAgIC8vIG9mLiBDcmVhdGUgYSBzdWItb2JqZWN0IHdyYXBwZXIgZm9yIGl0IHdpdGggdGhlIGFwcHJvcHJpYXRlIGNoaWxkXG4gICAgICAgICAgICAgIC8vIG1ldGFkYXRhLlxuICAgICAgICAgICAgICB2YWx1ZSA9IHdyYXBPYmplY3QodmFsdWUsIHdyYXBwZXJzW3Byb3BdLCBtZXRhZGF0YVtwcm9wXSk7XG4gICAgICAgICAgICB9IGVsc2UgaWYgKGhhc093blByb3BlcnR5KG1ldGFkYXRhLCBcIipcIikpIHtcbiAgICAgICAgICAgICAgLy8gV3JhcCBhbGwgcHJvcGVydGllcyBpbiAqIG5hbWVzcGFjZS5cbiAgICAgICAgICAgICAgdmFsdWUgPSB3cmFwT2JqZWN0KHZhbHVlLCB3cmFwcGVyc1twcm9wXSwgbWV0YWRhdGFbXCIqXCJdKTtcbiAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgIC8vIFdlIGRvbid0IG5lZWQgdG8gZG8gYW55IHdyYXBwaW5nIGZvciB0aGlzIHByb3BlcnR5LFxuICAgICAgICAgICAgICAvLyBzbyBqdXN0IGZvcndhcmQgYWxsIGFjY2VzcyB0byB0aGUgdW5kZXJseWluZyBvYmplY3QuXG4gICAgICAgICAgICAgIE9iamVjdC5kZWZpbmVQcm9wZXJ0eShjYWNoZSwgcHJvcCwge1xuICAgICAgICAgICAgICAgIGNvbmZpZ3VyYWJsZTogdHJ1ZSxcbiAgICAgICAgICAgICAgICBlbnVtZXJhYmxlOiB0cnVlLFxuXG4gICAgICAgICAgICAgICAgZ2V0KCkge1xuICAgICAgICAgICAgICAgICAgcmV0dXJuIHRhcmdldFtwcm9wXTtcbiAgICAgICAgICAgICAgICB9LFxuXG4gICAgICAgICAgICAgICAgc2V0KHZhbHVlKSB7XG4gICAgICAgICAgICAgICAgICB0YXJnZXRbcHJvcF0gPSB2YWx1ZTtcbiAgICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgfSk7XG4gICAgICAgICAgICAgIHJldHVybiB2YWx1ZTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgY2FjaGVbcHJvcF0gPSB2YWx1ZTtcbiAgICAgICAgICAgIHJldHVybiB2YWx1ZTtcbiAgICAgICAgICB9LFxuXG4gICAgICAgICAgc2V0KHByb3h5VGFyZ2V0LCBwcm9wLCB2YWx1ZSwgcmVjZWl2ZXIpIHtcbiAgICAgICAgICAgIGlmIChwcm9wIGluIGNhY2hlKSB7XG4gICAgICAgICAgICAgIGNhY2hlW3Byb3BdID0gdmFsdWU7XG4gICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICB0YXJnZXRbcHJvcF0gPSB2YWx1ZTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgcmV0dXJuIHRydWU7XG4gICAgICAgICAgfSxcblxuICAgICAgICAgIGRlZmluZVByb3BlcnR5KHByb3h5VGFyZ2V0LCBwcm9wLCBkZXNjKSB7XG4gICAgICAgICAgICByZXR1cm4gUmVmbGVjdC5kZWZpbmVQcm9wZXJ0eShjYWNoZSwgcHJvcCwgZGVzYyk7XG4gICAgICAgICAgfSxcblxuICAgICAgICAgIGRlbGV0ZVByb3BlcnR5KHByb3h5VGFyZ2V0LCBwcm9wKSB7XG4gICAgICAgICAgICByZXR1cm4gUmVmbGVjdC5kZWxldGVQcm9wZXJ0eShjYWNoZSwgcHJvcCk7XG4gICAgICAgICAgfVxuXG4gICAgICAgIH07IC8vIFBlciBjb250cmFjdCBvZiB0aGUgUHJveHkgQVBJLCB0aGUgXCJnZXRcIiBwcm94eSBoYW5kbGVyIG11c3QgcmV0dXJuIHRoZVxuICAgICAgICAvLyBvcmlnaW5hbCB2YWx1ZSBvZiB0aGUgdGFyZ2V0IGlmIHRoYXQgdmFsdWUgaXMgZGVjbGFyZWQgcmVhZC1vbmx5IGFuZFxuICAgICAgICAvLyBub24tY29uZmlndXJhYmxlLiBGb3IgdGhpcyByZWFzb24sIHdlIGNyZWF0ZSBhbiBvYmplY3Qgd2l0aCB0aGVcbiAgICAgICAgLy8gcHJvdG90eXBlIHNldCB0byBgdGFyZ2V0YCBpbnN0ZWFkIG9mIHVzaW5nIGB0YXJnZXRgIGRpcmVjdGx5LlxuICAgICAgICAvLyBPdGhlcndpc2Ugd2UgY2Fubm90IHJldHVybiBhIGN1c3RvbSBvYmplY3QgZm9yIEFQSXMgdGhhdFxuICAgICAgICAvLyBhcmUgZGVjbGFyZWQgcmVhZC1vbmx5IGFuZCBub24tY29uZmlndXJhYmxlLCBzdWNoIGFzIGBjaHJvbWUuZGV2dG9vbHNgLlxuICAgICAgICAvL1xuICAgICAgICAvLyBUaGUgcHJveHkgaGFuZGxlcnMgdGhlbXNlbHZlcyB3aWxsIHN0aWxsIHVzZSB0aGUgb3JpZ2luYWwgYHRhcmdldGBcbiAgICAgICAgLy8gaW5zdGVhZCBvZiB0aGUgYHByb3h5VGFyZ2V0YCwgc28gdGhhdCB0aGUgbWV0aG9kcyBhbmQgcHJvcGVydGllcyBhcmVcbiAgICAgICAgLy8gZGVyZWZlcmVuY2VkIHZpYSB0aGUgb3JpZ2luYWwgdGFyZ2V0cy5cblxuICAgICAgICBsZXQgcHJveHlUYXJnZXQgPSBPYmplY3QuY3JlYXRlKHRhcmdldCk7XG4gICAgICAgIHJldHVybiBuZXcgUHJveHkocHJveHlUYXJnZXQsIGhhbmRsZXJzKTtcbiAgICAgIH07XG4gICAgICAvKipcbiAgICAgICAqIENyZWF0ZXMgYSBzZXQgb2Ygd3JhcHBlciBmdW5jdGlvbnMgZm9yIGFuIGV2ZW50IG9iamVjdCwgd2hpY2ggaGFuZGxlc1xuICAgICAgICogd3JhcHBpbmcgb2YgbGlzdGVuZXIgZnVuY3Rpb25zIHRoYXQgdGhvc2UgbWVzc2FnZXMgYXJlIHBhc3NlZC5cbiAgICAgICAqXG4gICAgICAgKiBBIHNpbmdsZSB3cmFwcGVyIGlzIGNyZWF0ZWQgZm9yIGVhY2ggbGlzdGVuZXIgZnVuY3Rpb24sIGFuZCBzdG9yZWQgaW4gYVxuICAgICAgICogbWFwLiBTdWJzZXF1ZW50IGNhbGxzIHRvIGBhZGRMaXN0ZW5lcmAsIGBoYXNMaXN0ZW5lcmAsIG9yIGByZW1vdmVMaXN0ZW5lcmBcbiAgICAgICAqIHJldHJpZXZlIHRoZSBvcmlnaW5hbCB3cmFwcGVyLCBzbyB0aGF0ICBhdHRlbXB0cyB0byByZW1vdmUgYVxuICAgICAgICogcHJldmlvdXNseS1hZGRlZCBsaXN0ZW5lciB3b3JrIGFzIGV4cGVjdGVkLlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSB7RGVmYXVsdFdlYWtNYXA8ZnVuY3Rpb24sIGZ1bmN0aW9uPn0gd3JhcHBlck1hcFxuICAgICAgICogICAgICAgIEEgRGVmYXVsdFdlYWtNYXAgb2JqZWN0IHdoaWNoIHdpbGwgY3JlYXRlIHRoZSBhcHByb3ByaWF0ZSB3cmFwcGVyXG4gICAgICAgKiAgICAgICAgZm9yIGEgZ2l2ZW4gbGlzdGVuZXIgZnVuY3Rpb24gd2hlbiBvbmUgZG9lcyBub3QgZXhpc3QsIGFuZCByZXRyaWV2ZVxuICAgICAgICogICAgICAgIGFuIGV4aXN0aW5nIG9uZSB3aGVuIGl0IGRvZXMuXG4gICAgICAgKlxuICAgICAgICogQHJldHVybnMge29iamVjdH1cbiAgICAgICAqL1xuXG5cbiAgICAgIGNvbnN0IHdyYXBFdmVudCA9IHdyYXBwZXJNYXAgPT4gKHtcbiAgICAgICAgYWRkTGlzdGVuZXIodGFyZ2V0LCBsaXN0ZW5lciwgLi4uYXJncykge1xuICAgICAgICAgIHRhcmdldC5hZGRMaXN0ZW5lcih3cmFwcGVyTWFwLmdldChsaXN0ZW5lciksIC4uLmFyZ3MpO1xuICAgICAgICB9LFxuXG4gICAgICAgIGhhc0xpc3RlbmVyKHRhcmdldCwgbGlzdGVuZXIpIHtcbiAgICAgICAgICByZXR1cm4gdGFyZ2V0Lmhhc0xpc3RlbmVyKHdyYXBwZXJNYXAuZ2V0KGxpc3RlbmVyKSk7XG4gICAgICAgIH0sXG5cbiAgICAgICAgcmVtb3ZlTGlzdGVuZXIodGFyZ2V0LCBsaXN0ZW5lcikge1xuICAgICAgICAgIHRhcmdldC5yZW1vdmVMaXN0ZW5lcih3cmFwcGVyTWFwLmdldChsaXN0ZW5lcikpO1xuICAgICAgICB9XG5cbiAgICAgIH0pO1xuXG4gICAgICBjb25zdCBvblJlcXVlc3RGaW5pc2hlZFdyYXBwZXJzID0gbmV3IERlZmF1bHRXZWFrTWFwKGxpc3RlbmVyID0+IHtcbiAgICAgICAgaWYgKHR5cGVvZiBsaXN0ZW5lciAhPT0gXCJmdW5jdGlvblwiKSB7XG4gICAgICAgICAgcmV0dXJuIGxpc3RlbmVyO1xuICAgICAgICB9XG4gICAgICAgIC8qKlxuICAgICAgICAgKiBXcmFwcyBhbiBvblJlcXVlc3RGaW5pc2hlZCBsaXN0ZW5lciBmdW5jdGlvbiBzbyB0aGF0IGl0IHdpbGwgcmV0dXJuIGFcbiAgICAgICAgICogYGdldENvbnRlbnQoKWAgcHJvcGVydHkgd2hpY2ggcmV0dXJucyBhIGBQcm9taXNlYCByYXRoZXIgdGhhbiB1c2luZyBhXG4gICAgICAgICAqIGNhbGxiYWNrIEFQSS5cbiAgICAgICAgICpcbiAgICAgICAgICogQHBhcmFtIHtvYmplY3R9IHJlcVxuICAgICAgICAgKiAgICAgICAgVGhlIEhBUiBlbnRyeSBvYmplY3QgcmVwcmVzZW50aW5nIHRoZSBuZXR3b3JrIHJlcXVlc3QuXG4gICAgICAgICAqL1xuXG5cbiAgICAgICAgcmV0dXJuIGZ1bmN0aW9uIG9uUmVxdWVzdEZpbmlzaGVkKHJlcSkge1xuICAgICAgICAgIGNvbnN0IHdyYXBwZWRSZXEgPSB3cmFwT2JqZWN0KHJlcSwge31cbiAgICAgICAgICAvKiB3cmFwcGVycyAqL1xuICAgICAgICAgICwge1xuICAgICAgICAgICAgZ2V0Q29udGVudDoge1xuICAgICAgICAgICAgICBtaW5BcmdzOiAwLFxuICAgICAgICAgICAgICBtYXhBcmdzOiAwXG4gICAgICAgICAgICB9XG4gICAgICAgICAgfSk7XG4gICAgICAgICAgbGlzdGVuZXIod3JhcHBlZFJlcSk7XG4gICAgICAgIH07XG4gICAgICB9KTsgLy8gS2VlcCB0cmFjayBpZiB0aGUgZGVwcmVjYXRpb24gd2FybmluZyBoYXMgYmVlbiBsb2dnZWQgYXQgbGVhc3Qgb25jZS5cblxuICAgICAgbGV0IGxvZ2dlZFNlbmRSZXNwb25zZURlcHJlY2F0aW9uV2FybmluZyA9IGZhbHNlO1xuICAgICAgY29uc3Qgb25NZXNzYWdlV3JhcHBlcnMgPSBuZXcgRGVmYXVsdFdlYWtNYXAobGlzdGVuZXIgPT4ge1xuICAgICAgICBpZiAodHlwZW9mIGxpc3RlbmVyICE9PSBcImZ1bmN0aW9uXCIpIHtcbiAgICAgICAgICByZXR1cm4gbGlzdGVuZXI7XG4gICAgICAgIH1cbiAgICAgICAgLyoqXG4gICAgICAgICAqIFdyYXBzIGEgbWVzc2FnZSBsaXN0ZW5lciBmdW5jdGlvbiBzbyB0aGF0IGl0IG1heSBzZW5kIHJlc3BvbnNlcyBiYXNlZCBvblxuICAgICAgICAgKiBpdHMgcmV0dXJuIHZhbHVlLCByYXRoZXIgdGhhbiBieSByZXR1cm5pbmcgYSBzZW50aW5lbCB2YWx1ZSBhbmQgY2FsbGluZyBhXG4gICAgICAgICAqIGNhbGxiYWNrLiBJZiB0aGUgbGlzdGVuZXIgZnVuY3Rpb24gcmV0dXJucyBhIFByb21pc2UsIHRoZSByZXNwb25zZSBpc1xuICAgICAgICAgKiBzZW50IHdoZW4gdGhlIHByb21pc2UgZWl0aGVyIHJlc29sdmVzIG9yIHJlamVjdHMuXG4gICAgICAgICAqXG4gICAgICAgICAqIEBwYXJhbSB7Kn0gbWVzc2FnZVxuICAgICAgICAgKiAgICAgICAgVGhlIG1lc3NhZ2Ugc2VudCBieSB0aGUgb3RoZXIgZW5kIG9mIHRoZSBjaGFubmVsLlxuICAgICAgICAgKiBAcGFyYW0ge29iamVjdH0gc2VuZGVyXG4gICAgICAgICAqICAgICAgICBEZXRhaWxzIGFib3V0IHRoZSBzZW5kZXIgb2YgdGhlIG1lc3NhZ2UuXG4gICAgICAgICAqIEBwYXJhbSB7ZnVuY3Rpb24oKil9IHNlbmRSZXNwb25zZVxuICAgICAgICAgKiAgICAgICAgQSBjYWxsYmFjayB3aGljaCwgd2hlbiBjYWxsZWQgd2l0aCBhbiBhcmJpdHJhcnkgYXJndW1lbnQsIHNlbmRzXG4gICAgICAgICAqICAgICAgICB0aGF0IHZhbHVlIGFzIGEgcmVzcG9uc2UuXG4gICAgICAgICAqIEByZXR1cm5zIHtib29sZWFufVxuICAgICAgICAgKiAgICAgICAgVHJ1ZSBpZiB0aGUgd3JhcHBlZCBsaXN0ZW5lciByZXR1cm5lZCBhIFByb21pc2UsIHdoaWNoIHdpbGwgbGF0ZXJcbiAgICAgICAgICogICAgICAgIHlpZWxkIGEgcmVzcG9uc2UuIEZhbHNlIG90aGVyd2lzZS5cbiAgICAgICAgICovXG5cblxuICAgICAgICByZXR1cm4gZnVuY3Rpb24gb25NZXNzYWdlKG1lc3NhZ2UsIHNlbmRlciwgc2VuZFJlc3BvbnNlKSB7XG4gICAgICAgICAgbGV0IGRpZENhbGxTZW5kUmVzcG9uc2UgPSBmYWxzZTtcbiAgICAgICAgICBsZXQgd3JhcHBlZFNlbmRSZXNwb25zZTtcbiAgICAgICAgICBsZXQgc2VuZFJlc3BvbnNlUHJvbWlzZSA9IG5ldyBQcm9taXNlKHJlc29sdmUgPT4ge1xuICAgICAgICAgICAgd3JhcHBlZFNlbmRSZXNwb25zZSA9IGZ1bmN0aW9uIChyZXNwb25zZSkge1xuICAgICAgICAgICAgICBpZiAoIWxvZ2dlZFNlbmRSZXNwb25zZURlcHJlY2F0aW9uV2FybmluZykge1xuICAgICAgICAgICAgICAgIGNvbnNvbGUud2FybihTRU5EX1JFU1BPTlNFX0RFUFJFQ0FUSU9OX1dBUk5JTkcsIG5ldyBFcnJvcigpLnN0YWNrKTtcbiAgICAgICAgICAgICAgICBsb2dnZWRTZW5kUmVzcG9uc2VEZXByZWNhdGlvbldhcm5pbmcgPSB0cnVlO1xuICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgZGlkQ2FsbFNlbmRSZXNwb25zZSA9IHRydWU7XG4gICAgICAgICAgICAgIHJlc29sdmUocmVzcG9uc2UpO1xuICAgICAgICAgICAgfTtcbiAgICAgICAgICB9KTtcbiAgICAgICAgICBsZXQgcmVzdWx0O1xuXG4gICAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgIHJlc3VsdCA9IGxpc3RlbmVyKG1lc3NhZ2UsIHNlbmRlciwgd3JhcHBlZFNlbmRSZXNwb25zZSk7XG4gICAgICAgICAgfSBjYXRjaCAoZXJyKSB7XG4gICAgICAgICAgICByZXN1bHQgPSBQcm9taXNlLnJlamVjdChlcnIpO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIGNvbnN0IGlzUmVzdWx0VGhlbmFibGUgPSByZXN1bHQgIT09IHRydWUgJiYgaXNUaGVuYWJsZShyZXN1bHQpOyAvLyBJZiB0aGUgbGlzdGVuZXIgZGlkbid0IHJldHVybmVkIHRydWUgb3IgYSBQcm9taXNlLCBvciBjYWxsZWRcbiAgICAgICAgICAvLyB3cmFwcGVkU2VuZFJlc3BvbnNlIHN5bmNocm9ub3VzbHksIHdlIGNhbiBleGl0IGVhcmxpZXJcbiAgICAgICAgICAvLyBiZWNhdXNlIHRoZXJlIHdpbGwgYmUgbm8gcmVzcG9uc2Ugc2VudCBmcm9tIHRoaXMgbGlzdGVuZXIuXG5cbiAgICAgICAgICBpZiAocmVzdWx0ICE9PSB0cnVlICYmICFpc1Jlc3VsdFRoZW5hYmxlICYmICFkaWRDYWxsU2VuZFJlc3BvbnNlKSB7XG4gICAgICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICAgICAgfSAvLyBBIHNtYWxsIGhlbHBlciB0byBzZW5kIHRoZSBtZXNzYWdlIGlmIHRoZSBwcm9taXNlIHJlc29sdmVzXG4gICAgICAgICAgLy8gYW5kIGFuIGVycm9yIGlmIHRoZSBwcm9taXNlIHJlamVjdHMgKGEgd3JhcHBlZCBzZW5kTWVzc2FnZSBoYXNcbiAgICAgICAgICAvLyB0byB0cmFuc2xhdGUgdGhlIG1lc3NhZ2UgaW50byBhIHJlc29sdmVkIHByb21pc2Ugb3IgYSByZWplY3RlZFxuICAgICAgICAgIC8vIHByb21pc2UpLlxuXG5cbiAgICAgICAgICBjb25zdCBzZW5kUHJvbWlzZWRSZXN1bHQgPSBwcm9taXNlID0+IHtcbiAgICAgICAgICAgIHByb21pc2UudGhlbihtc2cgPT4ge1xuICAgICAgICAgICAgICAvLyBzZW5kIHRoZSBtZXNzYWdlIHZhbHVlLlxuICAgICAgICAgICAgICBzZW5kUmVzcG9uc2UobXNnKTtcbiAgICAgICAgICAgIH0sIGVycm9yID0+IHtcbiAgICAgICAgICAgICAgLy8gU2VuZCBhIEpTT04gcmVwcmVzZW50YXRpb24gb2YgdGhlIGVycm9yIGlmIHRoZSByZWplY3RlZCB2YWx1ZVxuICAgICAgICAgICAgICAvLyBpcyBhbiBpbnN0YW5jZSBvZiBlcnJvciwgb3IgdGhlIG9iamVjdCBpdHNlbGYgb3RoZXJ3aXNlLlxuICAgICAgICAgICAgICBsZXQgbWVzc2FnZTtcblxuICAgICAgICAgICAgICBpZiAoZXJyb3IgJiYgKGVycm9yIGluc3RhbmNlb2YgRXJyb3IgfHwgdHlwZW9mIGVycm9yLm1lc3NhZ2UgPT09IFwic3RyaW5nXCIpKSB7XG4gICAgICAgICAgICAgICAgbWVzc2FnZSA9IGVycm9yLm1lc3NhZ2U7XG4gICAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgICAgbWVzc2FnZSA9IFwiQW4gdW5leHBlY3RlZCBlcnJvciBvY2N1cnJlZFwiO1xuICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgc2VuZFJlc3BvbnNlKHtcbiAgICAgICAgICAgICAgICBfX21veldlYkV4dGVuc2lvblBvbHlmaWxsUmVqZWN0X186IHRydWUsXG4gICAgICAgICAgICAgICAgbWVzc2FnZVxuICAgICAgICAgICAgICB9KTtcbiAgICAgICAgICAgIH0pLmNhdGNoKGVyciA9PiB7XG4gICAgICAgICAgICAgIC8vIFByaW50IGFuIGVycm9yIG9uIHRoZSBjb25zb2xlIGlmIHVuYWJsZSB0byBzZW5kIHRoZSByZXNwb25zZS5cbiAgICAgICAgICAgICAgY29uc29sZS5lcnJvcihcIkZhaWxlZCB0byBzZW5kIG9uTWVzc2FnZSByZWplY3RlZCByZXBseVwiLCBlcnIpO1xuICAgICAgICAgICAgfSk7XG4gICAgICAgICAgfTsgLy8gSWYgdGhlIGxpc3RlbmVyIHJldHVybmVkIGEgUHJvbWlzZSwgc2VuZCB0aGUgcmVzb2x2ZWQgdmFsdWUgYXMgYVxuICAgICAgICAgIC8vIHJlc3VsdCwgb3RoZXJ3aXNlIHdhaXQgdGhlIHByb21pc2UgcmVsYXRlZCB0byB0aGUgd3JhcHBlZFNlbmRSZXNwb25zZVxuICAgICAgICAgIC8vIGNhbGxiYWNrIHRvIHJlc29sdmUgYW5kIHNlbmQgaXQgYXMgYSByZXNwb25zZS5cblxuXG4gICAgICAgICAgaWYgKGlzUmVzdWx0VGhlbmFibGUpIHtcbiAgICAgICAgICAgIHNlbmRQcm9taXNlZFJlc3VsdChyZXN1bHQpO1xuICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICBzZW5kUHJvbWlzZWRSZXN1bHQoc2VuZFJlc3BvbnNlUHJvbWlzZSk7XG4gICAgICAgICAgfSAvLyBMZXQgQ2hyb21lIGtub3cgdGhhdCB0aGUgbGlzdGVuZXIgaXMgcmVwbHlpbmcuXG5cblxuICAgICAgICAgIHJldHVybiB0cnVlO1xuICAgICAgICB9O1xuICAgICAgfSk7XG5cbiAgICAgIGNvbnN0IHdyYXBwZWRTZW5kTWVzc2FnZUNhbGxiYWNrID0gKHtcbiAgICAgICAgcmVqZWN0LFxuICAgICAgICByZXNvbHZlXG4gICAgICB9LCByZXBseSkgPT4ge1xuICAgICAgICBpZiAoZXh0ZW5zaW9uQVBJcy5ydW50aW1lLmxhc3RFcnJvcikge1xuICAgICAgICAgIC8vIERldGVjdCB3aGVuIG5vbmUgb2YgdGhlIGxpc3RlbmVycyByZXBsaWVkIHRvIHRoZSBzZW5kTWVzc2FnZSBjYWxsIGFuZCByZXNvbHZlXG4gICAgICAgICAgLy8gdGhlIHByb21pc2UgdG8gdW5kZWZpbmVkIGFzIGluIEZpcmVmb3guXG4gICAgICAgICAgLy8gU2VlIGh0dHBzOi8vZ2l0aHViLmNvbS9tb3ppbGxhL3dlYmV4dGVuc2lvbi1wb2x5ZmlsbC9pc3N1ZXMvMTMwXG4gICAgICAgICAgaWYgKGV4dGVuc2lvbkFQSXMucnVudGltZS5sYXN0RXJyb3IubWVzc2FnZSA9PT0gQ0hST01FX1NFTkRfTUVTU0FHRV9DQUxMQkFDS19OT19SRVNQT05TRV9NRVNTQUdFKSB7XG4gICAgICAgICAgICByZXNvbHZlKCk7XG4gICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIHJlamVjdChuZXcgRXJyb3IoZXh0ZW5zaW9uQVBJcy5ydW50aW1lLmxhc3RFcnJvci5tZXNzYWdlKSk7XG4gICAgICAgICAgfVxuICAgICAgICB9IGVsc2UgaWYgKHJlcGx5ICYmIHJlcGx5Ll9fbW96V2ViRXh0ZW5zaW9uUG9seWZpbGxSZWplY3RfXykge1xuICAgICAgICAgIC8vIENvbnZlcnQgYmFjayB0aGUgSlNPTiByZXByZXNlbnRhdGlvbiBvZiB0aGUgZXJyb3IgaW50b1xuICAgICAgICAgIC8vIGFuIEVycm9yIGluc3RhbmNlLlxuICAgICAgICAgIHJlamVjdChuZXcgRXJyb3IocmVwbHkubWVzc2FnZSkpO1xuICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgIHJlc29sdmUocmVwbHkpO1xuICAgICAgICB9XG4gICAgICB9O1xuXG4gICAgICBjb25zdCB3cmFwcGVkU2VuZE1lc3NhZ2UgPSAobmFtZSwgbWV0YWRhdGEsIGFwaU5hbWVzcGFjZU9iaiwgLi4uYXJncykgPT4ge1xuICAgICAgICBpZiAoYXJncy5sZW5ndGggPCBtZXRhZGF0YS5taW5BcmdzKSB7XG4gICAgICAgICAgdGhyb3cgbmV3IEVycm9yKGBFeHBlY3RlZCBhdCBsZWFzdCAke21ldGFkYXRhLm1pbkFyZ3N9ICR7cGx1cmFsaXplQXJndW1lbnRzKG1ldGFkYXRhLm1pbkFyZ3MpfSBmb3IgJHtuYW1lfSgpLCBnb3QgJHthcmdzLmxlbmd0aH1gKTtcbiAgICAgICAgfVxuXG4gICAgICAgIGlmIChhcmdzLmxlbmd0aCA+IG1ldGFkYXRhLm1heEFyZ3MpIHtcbiAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoYEV4cGVjdGVkIGF0IG1vc3QgJHttZXRhZGF0YS5tYXhBcmdzfSAke3BsdXJhbGl6ZUFyZ3VtZW50cyhtZXRhZGF0YS5tYXhBcmdzKX0gZm9yICR7bmFtZX0oKSwgZ290ICR7YXJncy5sZW5ndGh9YCk7XG4gICAgICAgIH1cblxuICAgICAgICByZXR1cm4gbmV3IFByb21pc2UoKHJlc29sdmUsIHJlamVjdCkgPT4ge1xuICAgICAgICAgIGNvbnN0IHdyYXBwZWRDYiA9IHdyYXBwZWRTZW5kTWVzc2FnZUNhbGxiYWNrLmJpbmQobnVsbCwge1xuICAgICAgICAgICAgcmVzb2x2ZSxcbiAgICAgICAgICAgIHJlamVjdFxuICAgICAgICAgIH0pO1xuICAgICAgICAgIGFyZ3MucHVzaCh3cmFwcGVkQ2IpO1xuICAgICAgICAgIGFwaU5hbWVzcGFjZU9iai5zZW5kTWVzc2FnZSguLi5hcmdzKTtcbiAgICAgICAgfSk7XG4gICAgICB9O1xuXG4gICAgICBjb25zdCBzdGF0aWNXcmFwcGVycyA9IHtcbiAgICAgICAgZGV2dG9vbHM6IHtcbiAgICAgICAgICBuZXR3b3JrOiB7XG4gICAgICAgICAgICBvblJlcXVlc3RGaW5pc2hlZDogd3JhcEV2ZW50KG9uUmVxdWVzdEZpbmlzaGVkV3JhcHBlcnMpXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBydW50aW1lOiB7XG4gICAgICAgICAgb25NZXNzYWdlOiB3cmFwRXZlbnQob25NZXNzYWdlV3JhcHBlcnMpLFxuICAgICAgICAgIG9uTWVzc2FnZUV4dGVybmFsOiB3cmFwRXZlbnQob25NZXNzYWdlV3JhcHBlcnMpLFxuICAgICAgICAgIHNlbmRNZXNzYWdlOiB3cmFwcGVkU2VuZE1lc3NhZ2UuYmluZChudWxsLCBcInNlbmRNZXNzYWdlXCIsIHtcbiAgICAgICAgICAgIG1pbkFyZ3M6IDEsXG4gICAgICAgICAgICBtYXhBcmdzOiAzXG4gICAgICAgICAgfSlcbiAgICAgICAgfSxcbiAgICAgICAgdGFiczoge1xuICAgICAgICAgIHNlbmRNZXNzYWdlOiB3cmFwcGVkU2VuZE1lc3NhZ2UuYmluZChudWxsLCBcInNlbmRNZXNzYWdlXCIsIHtcbiAgICAgICAgICAgIG1pbkFyZ3M6IDIsXG4gICAgICAgICAgICBtYXhBcmdzOiAzXG4gICAgICAgICAgfSlcbiAgICAgICAgfVxuICAgICAgfTtcbiAgICAgIGNvbnN0IHNldHRpbmdNZXRhZGF0YSA9IHtcbiAgICAgICAgY2xlYXI6IHtcbiAgICAgICAgICBtaW5BcmdzOiAxLFxuICAgICAgICAgIG1heEFyZ3M6IDFcbiAgICAgICAgfSxcbiAgICAgICAgZ2V0OiB7XG4gICAgICAgICAgbWluQXJnczogMSxcbiAgICAgICAgICBtYXhBcmdzOiAxXG4gICAgICAgIH0sXG4gICAgICAgIHNldDoge1xuICAgICAgICAgIG1pbkFyZ3M6IDEsXG4gICAgICAgICAgbWF4QXJnczogMVxuICAgICAgICB9XG4gICAgICB9O1xuICAgICAgYXBpTWV0YWRhdGEucHJpdmFjeSA9IHtcbiAgICAgICAgbmV0d29yazoge1xuICAgICAgICAgIFwiKlwiOiBzZXR0aW5nTWV0YWRhdGFcbiAgICAgICAgfSxcbiAgICAgICAgc2VydmljZXM6IHtcbiAgICAgICAgICBcIipcIjogc2V0dGluZ01ldGFkYXRhXG4gICAgICAgIH0sXG4gICAgICAgIHdlYnNpdGVzOiB7XG4gICAgICAgICAgXCIqXCI6IHNldHRpbmdNZXRhZGF0YVxuICAgICAgICB9XG4gICAgICB9O1xuICAgICAgcmV0dXJuIHdyYXBPYmplY3QoZXh0ZW5zaW9uQVBJcywgc3RhdGljV3JhcHBlcnMsIGFwaU1ldGFkYXRhKTtcbiAgICB9O1xuXG4gICAgaWYgKHR5cGVvZiBjaHJvbWUgIT0gXCJvYmplY3RcIiB8fCAhY2hyb21lIHx8ICFjaHJvbWUucnVudGltZSB8fCAhY2hyb21lLnJ1bnRpbWUuaWQpIHtcbiAgICAgIHRocm93IG5ldyBFcnJvcihcIlRoaXMgc2NyaXB0IHNob3VsZCBvbmx5IGJlIGxvYWRlZCBpbiBhIGJyb3dzZXIgZXh0ZW5zaW9uLlwiKTtcbiAgICB9IC8vIFRoZSBidWlsZCBwcm9jZXNzIGFkZHMgYSBVTUQgd3JhcHBlciBhcm91bmQgdGhpcyBmaWxlLCB3aGljaCBtYWtlcyB0aGVcbiAgICAvLyBgbW9kdWxlYCB2YXJpYWJsZSBhdmFpbGFibGUuXG5cblxuICAgIG1vZHVsZS5leHBvcnRzID0gd3JhcEFQSXMoY2hyb21lKTtcbiAgfSBlbHNlIHtcbiAgICBtb2R1bGUuZXhwb3J0cyA9IGJyb3dzZXI7XG4gIH1cbn0pO1xuLy8jIHNvdXJjZU1hcHBpbmdVUkw9YnJvd3Nlci1wb2x5ZmlsbC5qcy5tYXBcbiIsIi8vIFRoZSBtb2R1bGUgY2FjaGVcbnZhciBfX3dlYnBhY2tfbW9kdWxlX2NhY2hlX18gPSB7fTtcblxuLy8gVGhlIHJlcXVpcmUgZnVuY3Rpb25cbmZ1bmN0aW9uIF9fd2VicGFja19yZXF1aXJlX18obW9kdWxlSWQpIHtcblx0Ly8gQ2hlY2sgaWYgbW9kdWxlIGlzIGluIGNhY2hlXG5cdHZhciBjYWNoZWRNb2R1bGUgPSBfX3dlYnBhY2tfbW9kdWxlX2NhY2hlX19bbW9kdWxlSWRdO1xuXHRpZiAoY2FjaGVkTW9kdWxlICE9PSB1bmRlZmluZWQpIHtcblx0XHRyZXR1cm4gY2FjaGVkTW9kdWxlLmV4cG9ydHM7XG5cdH1cblx0Ly8gQ3JlYXRlIGEgbmV3IG1vZHVsZSAoYW5kIHB1dCBpdCBpbnRvIHRoZSBjYWNoZSlcblx0dmFyIG1vZHVsZSA9IF9fd2VicGFja19tb2R1bGVfY2FjaGVfX1ttb2R1bGVJZF0gPSB7XG5cdFx0Ly8gbm8gbW9kdWxlLmlkIG5lZWRlZFxuXHRcdC8vIG5vIG1vZHVsZS5sb2FkZWQgbmVlZGVkXG5cdFx0ZXhwb3J0czoge31cblx0fTtcblxuXHQvLyBFeGVjdXRlIHRoZSBtb2R1bGUgZnVuY3Rpb25cblx0X193ZWJwYWNrX21vZHVsZXNfX1ttb2R1bGVJZF0uY2FsbChtb2R1bGUuZXhwb3J0cywgbW9kdWxlLCBtb2R1bGUuZXhwb3J0cywgX193ZWJwYWNrX3JlcXVpcmVfXyk7XG5cblx0Ly8gUmV0dXJuIHRoZSBleHBvcnRzIG9mIHRoZSBtb2R1bGVcblx0cmV0dXJuIG1vZHVsZS5leHBvcnRzO1xufVxuXG4iLCIvLyBnZXREZWZhdWx0RXhwb3J0IGZ1bmN0aW9uIGZvciBjb21wYXRpYmlsaXR5IHdpdGggbm9uLWhhcm1vbnkgbW9kdWxlc1xuX193ZWJwYWNrX3JlcXVpcmVfXy5uID0gKG1vZHVsZSkgPT4ge1xuXHR2YXIgZ2V0dGVyID0gbW9kdWxlICYmIG1vZHVsZS5fX2VzTW9kdWxlID9cblx0XHQoKSA9PiAobW9kdWxlWydkZWZhdWx0J10pIDpcblx0XHQoKSA9PiAobW9kdWxlKTtcblx0X193ZWJwYWNrX3JlcXVpcmVfXy5kKGdldHRlciwgeyBhOiBnZXR0ZXIgfSk7XG5cdHJldHVybiBnZXR0ZXI7XG59OyIsIi8vIGRlZmluZSBnZXR0ZXIgZnVuY3Rpb25zIGZvciBoYXJtb255IGV4cG9ydHNcbl9fd2VicGFja19yZXF1aXJlX18uZCA9IChleHBvcnRzLCBkZWZpbml0aW9uKSA9PiB7XG5cdGZvcih2YXIga2V5IGluIGRlZmluaXRpb24pIHtcblx0XHRpZihfX3dlYnBhY2tfcmVxdWlyZV9fLm8oZGVmaW5pdGlvbiwga2V5KSAmJiAhX193ZWJwYWNrX3JlcXVpcmVfXy5vKGV4cG9ydHMsIGtleSkpIHtcblx0XHRcdE9iamVjdC5kZWZpbmVQcm9wZXJ0eShleHBvcnRzLCBrZXksIHsgZW51bWVyYWJsZTogdHJ1ZSwgZ2V0OiBkZWZpbml0aW9uW2tleV0gfSk7XG5cdFx0fVxuXHR9XG59OyIsIl9fd2VicGFja19yZXF1aXJlX18ubyA9IChvYmosIHByb3ApID0+IChPYmplY3QucHJvdG90eXBlLmhhc093blByb3BlcnR5LmNhbGwob2JqLCBwcm9wKSkiLCIvLyBkZWZpbmUgX19lc01vZHVsZSBvbiBleHBvcnRzXG5fX3dlYnBhY2tfcmVxdWlyZV9fLnIgPSAoZXhwb3J0cykgPT4ge1xuXHRpZih0eXBlb2YgU3ltYm9sICE9PSAndW5kZWZpbmVkJyAmJiBTeW1ib2wudG9TdHJpbmdUYWcpIHtcblx0XHRPYmplY3QuZGVmaW5lUHJvcGVydHkoZXhwb3J0cywgU3ltYm9sLnRvU3RyaW5nVGFnLCB7IHZhbHVlOiAnTW9kdWxlJyB9KTtcblx0fVxuXHRPYmplY3QuZGVmaW5lUHJvcGVydHkoZXhwb3J0cywgJ19fZXNNb2R1bGUnLCB7IHZhbHVlOiB0cnVlIH0pO1xufTsiLCJpbXBvcnQgeyBjb250ZW50IH0gZnJvbSAnLi4vLi4vcGFnZXMvY29udGVudCc7XG5cbmNvbnRlbnQuaW5pdCgpO1xuIl0sInNvdXJjZVJvb3QiOiIifQ==