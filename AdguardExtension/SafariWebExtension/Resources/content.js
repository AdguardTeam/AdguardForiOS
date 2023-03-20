/******/ (() => { // webpackBootstrap
/******/ 	var __webpack_modules__ = ({

/***/ "./node_modules/@adguard/extended-css/dist/extended-css.esm.js":
/*!*********************************************************************!*\
  !*** ./node_modules/@adguard/extended-css/dist/extended-css.esm.js ***!
  \*********************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "ExtendedCss": () => (/* binding */ ExtendedCss)
/* harmony export */ });
/**
 * @adguard/extended-css - v2.0.51 - Thu Feb 16 2023
 * https://github.com/AdguardTeam/ExtendedCss#homepage
 * Copyright (c) 2023 AdGuard. Licensed GPL-3.0
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
   *
   * @returns True if scheduled callback exists.
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
   *
   * @returns Timestamp.
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
    startTime = ThrottleWrapper.now();
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
      logger.error('Browser is not supported by ExtendedCss');
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
      parsedRules: [],
      mainCallback: () => {}
    }; // at least 'styleSheet' or 'cssRules' should be provided

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
    this.applyRulesScheduler = new ThrottleWrapper(this.context, applyRules, APPLY_RULES_DELAY);
    this.context.mainCallback = this.applyRulesScheduler.run.bind(this.applyRulesScheduler);

    if (this.context.beforeStyleApplied && typeof this.context.beforeStyleApplied !== 'function') {
      // eslint-disable-next-line max-len
      throw new Error(`Invalid configuration. Type of 'beforeStyleApplied' should be a function, received: '${typeof this.context.beforeStyleApplied}'`);
    }

    this.applyRulesCallbackListener = () => {
      applyRules(this.context);
    };
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
    mainDisconnect(this.context, this.context.mainCallback);
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

    const start = ThrottleWrapper.now();

    try {
      return extCssDocument.querySelectorAll(selector);
    } finally {
      const end = ThrottleWrapper.now();

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
      ExtendedCss.query(selector);
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
/* harmony import */ var _adguard_extended_css__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! @adguard/extended-css */ "./node_modules/@adguard/extended-css/dist/extended-css.esm.js");
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
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIndlYnBhY2s6Ly9hZHZhbmNlZC1hZGJsb2NrZXItd2ViLWV4dGVuc2lvbi8uL25vZGVfbW9kdWxlcy9AYWRndWFyZC9leHRlbmRlZC1jc3MvZGlzdC9leHRlbmRlZC1jc3MuZXNtLmpzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vbm9kZV9tb2R1bGVzL0BiYWJlbC9ydW50aW1lL2hlbHBlcnMvZXNtL2FycmF5TGlrZVRvQXJyYXkuanMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vLi9ub2RlX21vZHVsZXMvQGJhYmVsL3J1bnRpbWUvaGVscGVycy9lc20vYXJyYXlXaXRob3V0SG9sZXMuanMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vLi9ub2RlX21vZHVsZXMvQGJhYmVsL3J1bnRpbWUvaGVscGVycy9lc20vYXN5bmNUb0dlbmVyYXRvci5qcyIsIndlYnBhY2s6Ly9hZHZhbmNlZC1hZGJsb2NrZXItd2ViLWV4dGVuc2lvbi8uL25vZGVfbW9kdWxlcy9AYmFiZWwvcnVudGltZS9oZWxwZXJzL2VzbS9pdGVyYWJsZVRvQXJyYXkuanMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vLi9ub2RlX21vZHVsZXMvQGJhYmVsL3J1bnRpbWUvaGVscGVycy9lc20vbm9uSXRlcmFibGVTcHJlYWQuanMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vLi9ub2RlX21vZHVsZXMvQGJhYmVsL3J1bnRpbWUvaGVscGVycy9lc20vdG9Db25zdW1hYmxlQXJyYXkuanMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vLi9ub2RlX21vZHVsZXMvQGJhYmVsL3J1bnRpbWUvaGVscGVycy9lc20vdW5zdXBwb3J0ZWRJdGVyYWJsZVRvQXJyYXkuanMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vLi9ub2RlX21vZHVsZXMvQGJhYmVsL3J1bnRpbWUvcmVnZW5lcmF0b3IvaW5kZXguanMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vLi9zcmMvcGFnZXMvY29tbW9uL2NvbnN0YW50cy50cyIsIndlYnBhY2s6Ly9hZHZhbmNlZC1hZGJsb2NrZXItd2ViLWV4dGVuc2lvbi8uL3NyYy9wYWdlcy9jb250ZW50L2NvbnRlbnQudHMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vLi9ub2RlX21vZHVsZXMvcmVnZW5lcmF0b3ItcnVudGltZS9ydW50aW1lLmpzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uLy4vbm9kZV9tb2R1bGVzL3dlYmV4dGVuc2lvbi1wb2x5ZmlsbC9kaXN0L2Jyb3dzZXItcG9seWZpbGwuanMiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vd2VicGFjay9ib290c3RyYXAiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vd2VicGFjay9ydW50aW1lL2NvbXBhdCBnZXQgZGVmYXVsdCBleHBvcnQiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vd2VicGFjay9ydW50aW1lL2RlZmluZSBwcm9wZXJ0eSBnZXR0ZXJzIiwid2VicGFjazovL2FkdmFuY2VkLWFkYmxvY2tlci13ZWItZXh0ZW5zaW9uL3dlYnBhY2svcnVudGltZS9oYXNPd25Qcm9wZXJ0eSBzaG9ydGhhbmQiLCJ3ZWJwYWNrOi8vYWR2YW5jZWQtYWRibG9ja2VyLXdlYi1leHRlbnNpb24vd2VicGFjay9ydW50aW1lL21ha2UgbmFtZXNwYWNlIG9iamVjdCIsIndlYnBhY2s6Ly9hZHZhbmNlZC1hZGJsb2NrZXItd2ViLWV4dGVuc2lvbi8uL3NyYy90YXJnZXRzL2NvbnRlbnQvaW5kZXgudHMiXSwibmFtZXMiOlsiTWVzc2FnZXNUb05hdGl2ZUFwcCIsIk1lc3NhZ2VzVG9CYWNrZ3JvdW5kUGFnZSIsIk1lc3NhZ2VzVG9Db250ZW50U2NyaXB0IiwiQXBwZWFyYW5jZVRoZW1lIiwiQVBQRUFSQU5DRV9USEVNRV9ERUZBVUxUIiwiU3lzdGVtIiwiV0VCX0VYVEVOU0lPTl9NT1JFX1VSTCIsIlBsYXRmb3JtIiwibG9nTWVzc2FnZSIsInZlcmJvc2UiLCJtZXNzYWdlIiwiY29uc29sZSIsImxvZyIsImdldFNlbGVjdG9yc0FuZFNjcmlwdHMiLCJicm93c2VyIiwidHlwZSIsImRhdGEiLCJ1cmwiLCJ3aW5kb3ciLCJsb2NhdGlvbiIsImhyZWYiLCJyZXNwb25zZSIsImV4ZWN1dGVTY3JpcHRzIiwic2NyaXB0cyIsInN0YXJ0IiwiZW5kIiwidXBkYXRlZCIsInNjcmlwdFRhZyIsImRvY3VtZW50IiwiY3JlYXRlRWxlbWVudCIsInNldEF0dHJpYnV0ZSIsInRleHRDb250ZW50Iiwiam9pbiIsInBhcmVudCIsImhlYWQiLCJkb2N1bWVudEVsZW1lbnQiLCJhcHBlbmRDaGlsZCIsInBhcmVudE5vZGUiLCJyZW1vdmVDaGlsZCIsImFwcGx5U2NyaXB0cyIsImxlbmd0aCIsInByb3RlY3RTdHlsZUVsZW1lbnRDb250ZW50IiwicHJvdGVjdFN0eWxlRWwiLCJNdXRhdGlvbk9ic2VydmVyIiwiV2ViS2l0TXV0YXRpb25PYnNlcnZlciIsImlubmVyT2JzZXJ2ZXIiLCJtdXRhdGlvbnMiLCJpIiwibSIsImhhc0F0dHJpYnV0ZSIsImdldEF0dHJpYnV0ZSIsInJlbW92ZUF0dHJpYnV0ZSIsImlzUHJvdGVjdFN0eWxlRWxNb2RpZmllZCIsInJlbW92ZWROb2RlcyIsImoiLCJvbGRWYWx1ZSIsIm9ic2VydmUiLCJjaGlsZExpc3QiLCJjaGFyYWN0ZXJEYXRhIiwic3VidHJlZSIsImNoYXJhY3RlckRhdGFPbGRWYWx1ZSIsImFwcGx5Q3NzIiwic3R5bGVTZWxlY3RvcnMiLCJzdHlsZUVsZW1lbnQiLCJzZWxlY3RvcnMiLCJtYXAiLCJzIiwidHJpbSIsImZvckVhY2giLCJzZWxlY3RvciIsInNoZWV0IiwiaW5zZXJ0UnVsZSIsImUiLCJhcHBseUV4dGVuZGVkQ3NzIiwiZXh0ZW5kZWRDc3MiLCJleHRDc3MiLCJFeHRlbmRlZENzcyIsInN0eWxlU2hlZXQiLCJmaWx0ZXIiLCJhcHBseSIsImFwcGx5QWR2YW5jZWRCbG9ja2luZ0RhdGEiLCJzZWxlY3RvcnNBbmRTY3JpcHRzIiwiY3NzSW5qZWN0IiwiY3NzRXh0ZW5kZWQiLCJpbml0IiwiSFRNTERvY3VtZW50IiwiaW5kZXhPZiIsInN0YXJ0R2V0dGluZ1NjcmlwdHMiLCJEYXRlIiwibm93IiwiY29udGVudCJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7Ozs7QUFBQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxLQUFLO0FBQ0wsR0FBRztBQUNIO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7O0FBRUE7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtB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QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVMsRUFBRTs7QUFFWDtBQUNBLE9BQU87OztBQUdQO0FBQ0E7QUFDQTtBQUNBLE9BQU87QUFDUDtBQUNBLEtBQUs7OztBQUdMO0FBQ0EsR0FBRyxFQUFFOztBQUVMO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsS0FBSztBQUNMOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLEtBQUs7QUFDTDtBQUNBO0FBQ0EsR0FBRzs7O0FBR0g7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBLG9FQUFvRSxNQUFNO0FBQzFFOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUEsK0RBQStELDZCQUE2QjtBQUM1Rjs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBLEdBQUc7QUFDSDtBQUNBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTtBQUNBOztBQUVBO0FBQ0EsMERBQTBELGdCQUFnQjtBQUMxRSxtREFBbUQsNEJBQTRCLGtCQUFrQixXQUFXO0FBQzVHLEdBQUc7OztBQUdIO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0EsR0FBRztBQUNIO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUdBLG9FQUFvRTs7QUFFcEU7QUFDQTtBQUNBO0FBQ0EsbUhBQW1IO0FBQ25IOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EseUJBQXlCLHdCQUF3QixzQ0FBc0Msb0JBQW9CO0FBQzNHOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0EseUJBQXlCLHdCQUF3QixzQ0FBc0MsV0FBVztBQUNsRzs7QUFFQTtBQUNBO0FBQ0EsR0FBRztBQUNIOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsR0FBRzs7O0FBR0g7QUFDQSwrREFBK0Q7O0FBRS9ELG9IQUFvSDtBQUNwSDtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLEtBQUs7QUFDTDs7O0FBR0EseUJBQXlCLHdCQUF3QjtBQUNqRCxHQUFHO0FBQ0g7QUFDQTs7O0FBR0E7QUFDQTtBQUNBLEdBQUc7QUFDSDs7O0FBR0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLEdBQUc7OztBQUdIO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxHQUFHO0FBQ0g7OztBQUdBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQSxHQUFHO0FBQ0g7O0FBRUE7QUFDQTtBQUNBO0FBQ0EsR0FBRztBQUNIO0FBQ0EsdUJBQXVCLGdCQUFnQjtBQUN2QztBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0EsR0FBRztBQUNIO0FBQ0EsR0FBRztBQUNIO0FBQ0EsR0FBRztBQUNIO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBLDJDQUEyQzs7QUFFM0M7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBLG1EQUFtRCxRQUFRO0FBQzNEOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsS0FBSztBQUNMO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsR0FBRztBQUNIO0FBQ0E7QUFDQSxHQUFHO0FBQ0g7QUFDQTtBQUNBLEdBQUc7OztBQUdIO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0Esa0VBQWtFLFNBQVM7QUFDM0U7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLHlCQUF5QixtQ0FBbUMsS0FBSyxTQUFTO0FBQzFFLEtBQUs7QUFDTDtBQUNBOzs7QUFHQSwwQ0FBMEM7QUFDMUM7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsR0FBRztBQUNIO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxtQ0FBbUMsZUFBZSx5REFBeUQsMENBQTBDO0FB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akg7O0FBRUE7QUFDQSxtRUFBbUUsU0FBUztBQUM1RTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLEdBQUc7QUFDSDs7O0FBR0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLGVBQWUsVUFBVSxJQUFJLGdDQUFnQztBQUM3RCxHQUFHO0FBQ0g7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBLGtCQUFrQjtBQUNsQjs7QUFFQTtBQUNBOztBQUVBO0FBQ0Esc0JBQXNCLE1BQU07QUFDNUI7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBLGtDQUFrQyxJQUFJO0FBQ3RDOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLEdBQUc7O0FBRUg7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBLEdBQUc7QUFDSDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUEsd0NBQXdDO0FBQ3hDO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBLEdBQUc7QUFDSDtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBLGlEQUFpRCxFQUFFO0FBQ25EO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FB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QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLEdBQUc7O0FBRUg7QUFDQSwyREFBMkQsU0FBUztBQUNwRTs7QUFFQTtBQUNBLG9EQUFvRCxTQUFTO0FBQzdEOztBQUVBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsS0FBSztBQUNMLEdBQUc7QUFDSDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLEdBQUc7QUFDSDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0E7QUFDQTtBQUNBLEdBQUc7QUFDSDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsR0FBRzs7QUFFSDtBQUNBLDJEQUEyRCxTQUFTO0FBQ3BFOztBQUVBO0FBQ0EsOERBQThELFNBQVM7QUFDdkU7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBLDZFQUE2RTtBQUM3RTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsYUFBYTtBQUNiOztBQUVBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLEdBQUc7QUFDSDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBLE9BQU87QUFDUDtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNB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UztBQUNUOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBLDJCQUEyQjtBQUMzQjtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7O0FBRUEsU0FBUztBQUNUO0FBQ0E7O0FBRUE7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQSxvQ0FBb0MsY0FBYztBQUNsRDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNB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QUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsYUFBYTtBQUNiO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLGFBQWE7QUFDYjtBQUNBO0FBQ0E7QUFDQSxhQUFhO0FBQ2I7QUFDQTtBQUNBO0FBQ0EsYUFBYTtBQUNiO0FBQ0E7QUFDQTtBQUNBLGFBQWE7QUFDYjtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLGFBQWE7QUFDYjtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLGFBQWE7QUFDYjtBQUNBO0FBQ0E7QUFDQSxhQUFhO0FBQ2I7QUFDQTtBQUNBO0FBQ0EsYUFBYTtBQUNiO0FBQ0E7QUFDQTtBQUNBLGFBQWE7QUFDYjtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsaUJBQWlCLFNBQVM7QUFDMUI7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsaUJBQWlCLEVBQUU7QUFDbkIsbUJBQW1CLFFB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LGNBQWM7V0FDN0QsRTs7Ozs7Ozs7Ozs7OztBQ05BO0FBRUFNLHdEQUFBLEciLCJmaWxlIjoiY29udGVudC5qcyIsInNvdXJjZXNDb250ZW50IjpbIi8qKlxuICogQGFkZ3VhcmQvZXh0ZW5kZWQtY3NzIC0gdjIuMC41MSAtIFRodSBGZWIgMTYgMjAyM1xuICogaHR0cHM6Ly9naXRodWIuY29tL0FkZ3VhcmRUZWFtL0V4dGVuZGVkQ3NzI2hvbWVwYWdlXG4gKiBDb3B5cmlnaHQgKGMpIDIwMjMgQWRHdWFyZC4gTGljZW5zZWQgR1BMLTMuMFxuICovXG5mdW5jdGlvbiBfZGVmaW5lUHJvcGVydHkob2JqLCBrZXksIHZhbHVlKSB7XG4gIGlmIChrZXkgaW4gb2JqKSB7XG4gICAgT2JqZWN0LmRlZmluZVByb3BlcnR5KG9iaiwga2V5LCB7XG4gICAgICB2YWx1ZTogdmFsdWUsXG4gICAgICBlbnVtZXJhYmxlOiB0cnVlLFxuICAgICAgY29uZmlndXJhYmxlOiB0cnVlLFxuICAgICAgd3JpdGFibGU6IHRydWVcbiAgICB9KTtcbiAgfSBlbHNlIHtcbiAgICBvYmpba2V5XSA9IHZhbHVlO1xuICB9XG5cbiAgcmV0dXJuIG9iajtcbn1cblxuLyoqXG4gKiBQb3NzaWJsZSBhc3Qgbm9kZSB0eXBlcy5cbiAqXG4gKiBJTVBPUlRBTlQ6IGl0IGlzIHVzZWQgYXMgJ2NvbnN0JyBpbnN0ZWFkIG9mICdlbnVtJyB0byBhdm9pZCBzaWRlIGVmZmVjdHNcbiAqIGR1cmluZyBFeHRlbmRlZENzcyBpbXBvcnQgaW50byBvdGhlciBsaWJyYXJpZXMuXG4gKi9cbmNvbnN0IE5PREUgPSB7XG4gIFNFTEVDVE9SX0xJU1Q6ICdTZWxlY3Rvckxpc3QnLFxuICBTRUxFQ1RPUjogJ1NlbGVjdG9yJyxcbiAgUkVHVUxBUl9TRUxFQ1RPUjogJ1JlZ3VsYXJTZWxlY3RvcicsXG4gIEVYVEVOREVEX1NFTEVDVE9SOiAnRXh0ZW5kZWRTZWxlY3RvcicsXG4gIEFCU09MVVRFX1BTRVVET19DTEFTUzogJ0Fic29sdXRlUHNldWRvQ2xhc3MnLFxuICBSRUxBVElWRV9QU0VVRE9fQ0xBU1M6ICdSZWxhdGl2ZVBzZXVkb0NsYXNzJ1xufTtcblxuLyoqXG4gKiBDbGFzcyBuZWVkZWQgZm9yIGNyZWF0aW5nIGFzdCBub2RlcyB3aGlsZSBzZWxlY3RvciBwYXJzaW5nLlxuICogVXNlZCBmb3IgU2VsZWN0b3JMaXN0LCBTZWxlY3RvciwgRXh0ZW5kZWRTZWxlY3Rvci5cbiAqL1xuY2xhc3MgQW55U2VsZWN0b3JOb2RlIHtcbiAgLyoqXG4gICAqIENyZWF0ZXMgbmV3IGFzdCBub2RlLlxuICAgKlxuICAgKiBAcGFyYW0gdHlwZSBBc3Qgbm9kZSB0eXBlLlxuICAgKi9cbiAgY29uc3RydWN0b3IodHlwZSkge1xuICAgIF9kZWZpbmVQcm9wZXJ0eSh0aGlzLCBcImNoaWxkcmVuXCIsIFtdKTtcblxuICAgIHRoaXMudHlwZSA9IHR5cGU7XG4gIH1cbiAgLyoqXG4gICAqIEFkZHMgY2hpbGQgbm9kZSB0byBjaGlsZHJlbiBhcnJheS5cbiAgICpcbiAgICogQHBhcmFtIGNoaWxkIEFzdCBub2RlLlxuICAgKi9cblxuXG4gIGFkZENoaWxkKGNoaWxkKSB7XG4gICAgdGhpcy5jaGlsZHJlbi5wdXNoKGNoaWxkKTtcbiAgfVxuXG59XG4vKipcbiAqIENsYXNzIG5lZWRlZCBmb3IgY3JlYXRpbmcgUmVndWxhclNlbGVjdG9yIGFzdCBub2RlIHdoaWxlIHNlbGVjdG9yIHBhcnNpbmcuXG4gKi9cblxuY2xhc3MgUmVndWxhclNlbGVjdG9yTm9kZSBleHRlbmRzIEFueVNlbGVjdG9yTm9kZSB7XG4gIC8qKlxuICAgKiBDcmVhdGVzIFJlZ3VsYXJTZWxlY3RvciBhc3Qgbm9kZS5cbiAgICpcbiAgICogQHBhcmFtIHZhbHVlIFZhbHVlIG9mIFJlZ3VsYXJTZWxlY3RvciBub2RlLlxuICAgKi9cbiAgY29uc3RydWN0b3IodmFsdWUpIHtcbiAgICBzdXBlcihOT0RFLlJFR1VMQVJfU0VMRUNUT1IpO1xuICAgIHRoaXMudmFsdWUgPSB2YWx1ZTtcbiAgfVxuXG59XG4vKipcbiAqIENsYXNzIG5lZWRlZCBmb3IgY3JlYXRpbmcgUmVsYXRpdmVQc2V1ZG9DbGFzcyBhc3Qgbm9kZSB3aGlsZSBzZWxlY3RvciBwYXJzaW5nLlxuICovXG5cbmNsYXNzIFJlbGF0aXZlUHNldWRvQ2xhc3NOb2RlIGV4dGVuZHMgQW55U2VsZWN0b3JOb2RlIHtcbiAgLyoqXG4gICAqIENyZWF0ZXMgUmVndWxhclNlbGVjdG9yIGFzdCBub2RlLlxuICAgKlxuICAgKiBAcGFyYW0gbmFtZSBOYW1lIG9mIFJlbGF0aXZlUHNldWRvQ2xhc3Mgbm9kZS5cbiAgICovXG4gIGNvbnN0cnVjdG9yKG5hbWUpIHtcbiAgICBzdXBlcihOT0RFLlJFTEFUSVZFX1BTRVVET19DTEFTUyk7XG4gICAgdGhpcy5uYW1lID0gbmFtZTtcbiAgfVxuXG59XG4vKipcbiAqIENsYXNzIG5lZWRlZCBmb3IgY3JlYXRpbmcgQWJzb2x1dGVQc2V1ZG9DbGFzcyBhc3Qgbm9kZSB3aGlsZSBzZWxlY3RvciBwYXJzaW5nLlxuICovXG5cbmNsYXNzIEFic29sdXRlUHNldWRvQ2xhc3NOb2RlIGV4dGVuZHMgQW55U2VsZWN0b3JOb2RlIHtcbiAgLyoqXG4gICAqIENyZWF0ZXMgQWJzb2x1dGVQc2V1ZG9DbGFzcyBhc3Qgbm9kZS5cbiAgICpcbiAgICogQHBhcmFtIG5hbWUgTmFtZSBvZiBBYnNvbHV0ZVBzZXVkb0NsYXNzIG5vZGUuXG4gICAqL1xuICBjb25zdHJ1Y3RvcihuYW1lKSB7XG4gICAgc3VwZXIoTk9ERS5BQlNPTFVURV9QU0VVRE9fQ0xBU1MpO1xuXG4gICAgX2RlZmluZVByb3BlcnR5KHRoaXMsIFwidmFsdWVcIiwgJycpO1xuXG4gICAgdGhpcy5uYW1lID0gbmFtZTtcbiAgfVxuXG59XG4vKiBlc2xpbnQtZGlzYWJsZSBqc2RvYy9yZXF1aXJlLWRlc2NyaXB0aW9uLWNvbXBsZXRlLXNlbnRlbmNlICovXG5cbi8qKlxuICogUm9vdCBub2RlLlxuICpcbiAqIFNlbGVjdG9yTGlzdFxuICogICA6IFNlbGVjdG9yXG4gKiAgICAgLi4uXG4gKiAgIDtcbiAqL1xuXG4vKipcbiAqIFNlbGVjdG9yIG5vZGUuXG4gKlxuICogU2VsZWN0b3JcbiAqICAgOiBSZWd1bGFyU2VsZWN0b3JcbiAqICAgfCBFeHRlbmRlZFNlbGVjdG9yXG4gKiAgICAgLi4uXG4gKiAgIDtcbiAqL1xuXG4vKipcbiAqIFJlZ3VsYXIgc2VsZWN0b3Igbm9kZS5cbiAqIEl0IGNhbiBiZSBzZWxlY3RlZCBieSBxdWVyeVNlbGVjdG9yQWxsKCkuXG4gKlxuICogUmVndWxhclNlbGVjdG9yXG4gKiAgIDogdHlwZVxuICogICA6IHZhbHVlXG4gKiAgIDtcbiAqL1xuXG4vKipcbiAqIEV4dGVuZGVkIHNlbGVjdG9yIG5vZGUuXG4gKlxuICogRXh0ZW5kZWRTZWxlY3RvclxuICogICA6IEFic29sdXRlUHNldWRvQ2xhc3NcbiAqICAgfCBSZWxhdGl2ZVBzZXVkb0NsYXNzXG4gKiAgIDtcbiAqL1xuXG4vKipcbiAqIEFic29sdXRlIGV4dGVuZGVkIHBzZXVkby1jbGFzcyBub2RlLFxuICogaS5lLiBub25lLXNlbGVjdG9yIGFyZ3MuXG4gKlxuICogQWJzb2x1dGVQc2V1ZG9DbGFzc1xuICogICA6IHR5cGVcbiAqICAgOiBuYW1lXG4gKiAgIDogdmFsdWVcbiAqICAgO1xuICovXG5cbi8qKlxuICogUmVsYXRpdmUgZXh0ZW5kZWQgcHNldWRvLWNsYXNzIG5vZGVcbiAqIGkuZS4gc2VsZWN0b3IgYXMgYXJnLlxuICpcbiAqIFJlbGF0aXZlUHNldWRvQ2xhc3NcbiAqICAgOiB0eXBlXG4gKiAgIDogbmFtZVxuICogICA6IFNlbGVjdG9yTGlzdFxuICogICA7XG4gKi9cbi8vXG4vLyAgYXN0IGV4YW1wbGVcbi8vXG4vLyAgZGl2LmJhbm5lciA+IGRpdjpoYXMoc3BhbiwgcCksIGEgaW1nLmFkXG4vL1xuLy8gIFNlbGVjdG9yTGlzdCAtIGRpdi5iYW5uZXIgPiBkaXY6aGFzKHNwYW4sIHApLCBhIGltZy5hZFxuLy8gICAgICBTZWxlY3RvciAtIGRpdi5iYW5uZXIgPiBkaXY6aGFzKHNwYW4sIHApXG4vLyAgICAgICAgICBSZWd1bGFyU2VsZWN0b3IgLSBkaXYuYmFubmVyID4gZGl2XG4vLyAgICAgICAgICBFeHRlbmRlZFNlbGVjdG9yIC0gOmhhcyhzcGFuLCBwKVxuLy8gICAgICAgICAgICAgIFBzZXVkb0NsYXNzU2VsZWN0b3IgLSA6aGFzXG4vLyAgICAgICAgICAgICAgU2VsZWN0b3JMaXN0IC0gc3BhbiwgcFxuLy8gICAgICAgICAgICAgICAgICBTZWxlY3RvciAtIHNwYW5cbi8vICAgICAgICAgICAgICAgICAgICAgIFJlZ3VsYXJTZWxlY3RvciAtIHNwYW5cbi8vICAgICAgICAgICAgICAgICAgU2VsZWN0b3IgLSBwXG4vLyAgICAgICAgICAgICAgICAgICAgICBSZWd1bGFyU2VsZWN0b3IgLSBwXG4vLyAgICAgIFNlbGVjdG9yIC0gYSBpbWcuYWRcbi8vICAgICAgICAgIFJlZ3VsYXJTZWxlY3RvciAtIGEgaW1nLmFkXG4vL1xuXG5jb25zdCBMRUZUX1NRVUFSRV9CUkFDS0VUID0gJ1snO1xuY29uc3QgUklHSFRfU1FVQVJFX0JSQUNLRVQgPSAnXSc7XG5jb25zdCBMRUZUX1BBUkVOVEhFU0lTID0gJygnO1xuY29uc3QgUklHSFRfUEFSRU5USEVTSVMgPSAnKSc7XG5jb25zdCBMRUZUX0NVUkxZX0JSQUNLRVQgPSAneyc7XG5jb25zdCBSSUdIVF9DVVJMWV9CUkFDS0VUID0gJ30nO1xuY29uc3QgQlJBQ0tFVCA9IHtcbiAgU1FVQVJFOiB7XG4gICAgTEVGVDogTEVGVF9TUVVBUkVfQlJBQ0tFVCxcbiAgICBSSUdIVDogUklHSFRfU1FVQVJFX0JSQUNLRVRcbiAgfSxcbiAgUEFSRU5USEVTRVM6IHtcbiAgICBMRUZUOiBMRUZUX1BBUkVOVEhFU0lTLFxuICAgIFJJR0hUOiBSSUdIVF9QQVJFTlRIRVNJU1xuICB9LFxuICBDVVJMWToge1xuICAgIExFRlQ6IExFRlRfQ1VSTFlfQlJBQ0tFVCxcbiAgICBSSUdIVDogUklHSFRfQ1VSTFlfQlJBQ0tFVFxuICB9XG59O1xuY29uc3QgU0xBU0ggPSAnLyc7XG5jb25zdCBCQUNLU0xBU0ggPSAnXFxcXCc7XG5jb25zdCBTUEFDRSA9ICcgJztcbmNvbnN0IENPTU1BID0gJywnO1xuY29uc3QgRE9UID0gJy4nO1xuY29uc3QgU0VNSUNPTE9OID0gJzsnO1xuY29uc3QgQ09MT04gPSAnOic7XG5jb25zdCBTSU5HTEVfUVVPVEUgPSAnXFwnJztcbmNvbnN0IERPVUJMRV9RVU9URSA9ICdcIic7IC8vIGRvIG5vdCBjb25zaWRlciBoeXBoZW4gYC1gIGFzIHNlcGFyYXRlZCBtYXJrXG4vLyB0byBhdm9pZCBwc2V1ZG8tY2xhc3MgbmFtZXMgc3BsaXR0aW5nXG4vLyBlLmcuICdtYXRjaGVzLWNzcycgb3IgJ2lmLW5vdCdcblxuY29uc3QgQ0FSRVQgPSAnXic7XG5jb25zdCBET0xMQVJfU0lHTiA9ICckJztcbmNvbnN0IEVRVUFMX1NJR04gPSAnPSc7XG5jb25zdCBUQUIgPSAnXFx0JztcbmNvbnN0IENBUlJJQUdFX1JFVFVSTiA9ICdcXHInO1xuY29uc3QgTElORV9GRUVEID0gJ1xcbic7XG5jb25zdCBGT1JNX0ZFRUQgPSAnXFxmJztcbmNvbnN0IFdISVRFX1NQQUNFX0NIQVJBQ1RFUlMgPSBbU1BBQ0UsIFRBQiwgQ0FSUklBR0VfUkVUVVJOLCBMSU5FX0ZFRUQsIEZPUk1fRkVFRF07IC8vIGZvciB1bml2ZXJzYWwgc2VsZWN0b3IgYW5kIGF0dHJpYnV0ZXNcblxuY29uc3QgQVNURVJJU0sgPSAnKic7XG5jb25zdCBJRF9NQVJLRVIgPSAnIyc7XG5jb25zdCBDTEFTU19NQVJLRVIgPSBET1Q7XG5jb25zdCBERVNDRU5EQU5UX0NPTUJJTkFUT1IgPSBTUEFDRTtcbmNvbnN0IENISUxEX0NPTUJJTkFUT1IgPSAnPic7XG5jb25zdCBORVhUX1NJQkxJTkdfQ09NQklOQVRPUiA9ICcrJztcbmNvbnN0IFNVQlNFUVVFTlRfU0lCTElOR19DT01CSU5BVE9SID0gJ34nO1xuY29uc3QgQ09NQklOQVRPUlMgPSBbREVTQ0VOREFOVF9DT01CSU5BVE9SLCBDSElMRF9DT01CSU5BVE9SLCBORVhUX1NJQkxJTkdfQ09NQklOQVRPUiwgU1VCU0VRVUVOVF9TSUJMSU5HX0NPTUJJTkFUT1JdO1xuY29uc3QgU1VQUE9SVEVEX1NFTEVDVE9SX01BUktTID0gW0xFRlRfU1FVQVJFX0JSQUNLRVQsIFJJR0hUX1NRVUFSRV9CUkFDS0VULCBMRUZUX1BBUkVOVEhFU0lTLCBSSUdIVF9QQVJFTlRIRVNJUywgTEVGVF9DVVJMWV9CUkFDS0VULCBSSUdIVF9DVVJMWV9CUkFDS0VULCBTTEFTSCwgQkFDS1NMQVNILCBTRU1JQ09MT04sIENPTE9OLCBDT01NQSwgU0lOR0xFX1FVT1RFLCBET1VCTEVfUVVPVEUsIENBUkVULCBET0xMQVJfU0lHTiwgQVNURVJJU0ssIElEX01BUktFUiwgQ0xBU1NfTUFSS0VSLCBERVNDRU5EQU5UX0NPTUJJTkFUT1IsIENISUxEX0NPTUJJTkFUT1IsIE5FWFRfU0lCTElOR19DT01CSU5BVE9SLCBTVUJTRVFVRU5UX1NJQkxJTkdfQ09NQklOQVRPUiwgVEFCLCBDQVJSSUFHRV9SRVRVUk4sIExJTkVfRkVFRCwgRk9STV9GRUVEXTtcbmNvbnN0IFNVUFBPUlRFRF9TVFlMRV9ERUNMQVJBVElPTl9NQVJLUyA9IFsvLyBkaXZpZGVyIGJldHdlZW4gcHJvcGVydHkgYW5kIHZhbHVlIGluIGRlY2xhcmF0aW9uXG5DT0xPTiwgLy8gZGl2aWRlciBiZXR3ZWVuIGRlY2xhcmF0aW9uc1xuU0VNSUNPTE9OLCAvLyBzb21ldGltZXMgaXMgbmVlZGVkIGZvciB2YWx1ZSB3cmFwcGluZ1xuLy8gZS5nLiAnY29udGVudDogXCItXCInXG5TSU5HTEVfUVVPVEUsIERPVUJMRV9RVU9URSwgLy8gbmVlZGVkIGZvciBxdW90ZSBlc2NhcGluZyBpbnNpZGUgdGhlIHNhbWUtdHlwZSBxdW90ZXNcbkJBQ0tTTEFTSCwgLy8gd2hpdGVzcGFjZXNcblNQQUNFLCBUQUIsIENBUlJJQUdFX1JFVFVSTiwgTElORV9GRUVELCBGT1JNX0ZFRURdOyAvLyBhYnNvbHV0ZTpcblxuY29uc3QgQ09OVEFJTlNfUFNFVURPID0gJ2NvbnRhaW5zJztcbmNvbnN0IEhBU19URVhUX1BTRVVETyA9ICdoYXMtdGV4dCc7XG5jb25zdCBBQlBfQ09OVEFJTlNfUFNFVURPID0gJy1hYnAtY29udGFpbnMnO1xuY29uc3QgTUFUQ0hFU19DU1NfUFNFVURPID0gJ21hdGNoZXMtY3NzJztcbmNvbnN0IE1BVENIRVNfQ1NTX0JFRk9SRV9QU0VVRE8gPSAnbWF0Y2hlcy1jc3MtYmVmb3JlJztcbmNvbnN0IE1BVENIRVNfQ1NTX0FGVEVSX1BTRVVETyA9ICdtYXRjaGVzLWNzcy1hZnRlcic7XG5jb25zdCBNQVRDSEVTX0FUVFJfUFNFVURPX0NMQVNTX01BUktFUiA9ICdtYXRjaGVzLWF0dHInO1xuY29uc3QgTUFUQ0hFU19QUk9QRVJUWV9QU0VVRE9fQ0xBU1NfTUFSS0VSID0gJ21hdGNoZXMtcHJvcGVydHknO1xuY29uc3QgWFBBVEhfUFNFVURPX0NMQVNTX01BUktFUiA9ICd4cGF0aCc7XG5jb25zdCBOVEhfQU5DRVNUT1JfUFNFVURPX0NMQVNTX01BUktFUiA9ICdudGgtYW5jZXN0b3InO1xuY29uc3QgQ09OVEFJTlNfUFNFVURPX05BTUVTID0gW0NPTlRBSU5TX1BTRVVETywgSEFTX1RFWFRfUFNFVURPLCBBQlBfQ09OVEFJTlNfUFNFVURPXTtcbi8qKlxuICogUHNldWRvLWNsYXNzIDp1cHdhcmQoKSBjYW4gZ2V0IG51bWJlciBvciBzZWxlY3RvciBhcmdcbiAqIGFuZCBpZiB0aGUgYXJnIGlzIHNlbGVjdG9yIGl0IHNob3VsZCBiZSBzdGFuZGFyZCwgbm90IGV4dGVuZGVkXG4gKiBzbyA6dXB3YXJkIHBzZXVkby1jbGFzcyBpcyBhbHdheXMgYWJzb2x1dGUuXG4gKi9cblxuY29uc3QgVVBXQVJEX1BTRVVET19DTEFTU19NQVJLRVIgPSAndXB3YXJkJztcbi8qKlxuICogUHNldWRvLWNsYXNzIGA6cmVtb3ZlKClgIGFuZCBwc2V1ZG8tcHJvcGVydHkgYHJlbW92ZWBcbiAqIGFyZSB1c2VkIGZvciBlbGVtZW50IGFjdGlvbnMsIG5vdCBmb3IgZWxlbWVudCBzZWxlY3RpbmcuXG4gKlxuICogU2VsZWN0b3IgdGV4dCBzaG91bGQgbm90IGNvbnRhaW4gdGhlIHBzZXVkby1jbGFzc1xuICogc28gc2VsZWN0b3IgcGFyc2VyIHNob3VsZCBjb25zaWRlciBpdCBhcyBpbnZhbGlkXG4gKiBhbmQgYm90aCBhcmUgaGFuZGxlZCBieSBzdHlsZXNoZWV0IHBhcnNlci5cbiAqL1xuXG5jb25zdCBSRU1PVkVfUFNFVURPX01BUktFUiA9ICdyZW1vdmUnOyAvLyByZWxhdGl2ZTpcblxuY29uc3QgSEFTX1BTRVVET19DTEFTU19NQVJLRVIgPSAnaGFzJztcbmNvbnN0IEFCUF9IQVNfUFNFVURPX0NMQVNTX01BUktFUiA9ICctYWJwLWhhcyc7XG5jb25zdCBIQVNfUFNFVURPX0NMQVNTX01BUktFUlMgPSBbSEFTX1BTRVVET19DTEFTU19NQVJLRVIsIEFCUF9IQVNfUFNFVURPX0NMQVNTX01BUktFUl07XG5jb25zdCBJU19QU0VVRE9fQ0xBU1NfTUFSS0VSID0gJ2lzJztcbmNvbnN0IE5PVF9QU0VVRE9fQ0xBU1NfTUFSS0VSID0gJ25vdCc7XG5jb25zdCBBQlNPTFVURV9QU0VVRE9fQ0xBU1NFUyA9IFtDT05UQUlOU19QU0VVRE8sIEhBU19URVhUX1BTRVVETywgQUJQX0NPTlRBSU5TX1BTRVVETywgTUFUQ0hFU19DU1NfUFNFVURPLCBNQVRDSEVTX0NTU19CRUZPUkVfUFNFVURPLCBNQVRDSEVTX0NTU19BRlRFUl9QU0VVRE8sIE1BVENIRVNfQVRUUl9QU0VVRE9fQ0xBU1NfTUFSS0VSLCBNQVRDSEVTX1BST1BFUlRZX1BTRVVET19DTEFTU19NQVJLRVIsIFhQQVRIX1BTRVVET19DTEFTU19NQVJLRVIsIE5USF9BTkNFU1RPUl9QU0VVRE9fQ0xBU1NfTUFSS0VSLCBVUFdBUkRfUFNFVURPX0NMQVNTX01BUktFUl07XG5jb25zdCBSRUxBVElWRV9QU0VVRE9fQ0xBU1NFUyA9IFsuLi5IQVNfUFNFVURPX0NMQVNTX01BUktFUlMsIElTX1BTRVVET19DTEFTU19NQVJLRVIsIE5PVF9QU0VVRE9fQ0xBU1NfTUFSS0VSXTtcbmNvbnN0IFNVUFBPUlRFRF9QU0VVRE9fQ0xBU1NFUyA9IFsuLi5BQlNPTFVURV9QU0VVRE9fQ0xBU1NFUywgLi4uUkVMQVRJVkVfUFNFVURPX0NMQVNTRVNdOyAvLyB0aGVzZSBwc2V1ZG8tY2xhc3NlcyBzaG91bGQgYmUgcGFydCBvZiBSZWd1bGFyU2VsZWN0b3IgdmFsdWVcbi8vIGlmIGl0cyBhcmcgZG9lcyBub3QgY29udGFpbiBleHRlbmRlZCBzZWxlY3RvcnMuXG4vLyB0aGUgYXN0IHdpbGwgYmUgY2hlY2tlZCBhZnRlciB0aGUgc2VsZWN0b3IgaXMgY29tcGxldGVseSBwYXJzZWRcblxuY29uc3QgT1BUSU1JWkFUSU9OX1BTRVVET19DTEFTU0VTID0gW05PVF9QU0VVRE9fQ0xBU1NfTUFSS0VSLCBJU19QU0VVRE9fQ0xBU1NfTUFSS0VSXTtcbi8qKlxuICogJzpzY29wZScgaXMgdXNlZCBmb3IgZXh0ZW5kZWQgcHNldWRvLWNsYXNzIDpoYXMoKSwgaWYtbm90KCksIDppcygpIGFuZCA6bm90KCkuXG4gKi9cblxuY29uc3QgU0NPUEVfQ1NTX1BTRVVET19DTEFTUyA9ICc6c2NvcGUnO1xuLyoqXG4gKiAnOmFmdGVyJyBhbmQgJzpiZWZvcmUnIGFyZSBuZWVkZWQgZm9yIDptYXRjaGVzLWNzcygpIHBzZXVkby1jbGFzc1xuICogYWxsIG90aGVyIGFyZSBuZWVkZWQgZm9yIDpoYXMoKSBsaW1pdGF0aW9uIGFmdGVyIHJlZ3VsYXIgcHNldWRvLWVsZW1lbnRzLlxuICpcbiAqIEBzZWUge0BsaW5rIGh0dHBzOi8vYnVncy5jaHJvbWl1bS5vcmcvcC9jaHJvbWl1bS9pc3N1ZXMvZGV0YWlsP2lkPTY2OTA1OCNjNTR9IFtjYXNlIDNdXG4gKi9cblxuY29uc3QgUkVHVUxBUl9QU0VVRE9fRUxFTUVOVFMgPSB7XG4gIEFGVEVSOiAnYWZ0ZXInLFxuICBCQUNLRFJPUDogJ2JhY2tkcm9wJyxcbiAgQkVGT1JFOiAnYmVmb3JlJyxcbiAgQ1VFOiAnY3VlJyxcbiAgQ1VFX1JFR0lPTjogJ2N1ZS1yZWdpb24nLFxuICBGSVJTVF9MRVRURVI6ICdmaXJzdC1sZXR0ZXInLFxuICBGSVJTVF9MSU5FOiAnZmlyc3QtbGluZScsXG4gIEZJTEVfU0VMRUNUSU9OX0JVVFRPTjogJ2ZpbGUtc2VsZWN0b3ItYnV0dG9uJyxcbiAgR1JBTU1BUl9FUlJPUjogJ2dyYW1tYXItZXJyb3InLFxuICBNQVJLRVI6ICdtYXJrZXInLFxuICBQQVJUOiAncGFydCcsXG4gIFBMQUNFSE9MREVSOiAncGxhY2Vob2xkZXInLFxuICBTRUxFQ1RJT046ICdzZWxlY3Rpb24nLFxuICBTTE9UVEVEOiAnc2xvdHRlZCcsXG4gIFNQRUxMSU5HX0VSUk9SOiAnc3BlbGxpbmctZXJyb3InLFxuICBUQVJHRVRfVEVYVDogJ3RhcmdldC10ZXh0J1xufTsgLy8gRXh0ZW5kZWRDc3MgZG9lcyBub3Qgc3VwcG9ydCBhdC1ydWxlc1xuLy8gaHR0cHM6Ly9kZXZlbG9wZXIubW96aWxsYS5vcmcvZW4tVVMvZG9jcy9XZWIvQ1NTL0F0LXJ1bGVcblxuY29uc3QgQVRfUlVMRV9NQVJLRVIgPSAnQCc7XG5jb25zdCBDT05URU5UX0NTU19QUk9QRVJUWSA9ICdjb250ZW50JztcbmNvbnN0IFBTRVVET19QUk9QRVJUWV9QT1NJVElWRV9WQUxVRSA9ICd0cnVlJztcbmNvbnN0IERFQlVHX1BTRVVET19QUk9QRVJUWV9HTE9CQUxfVkFMVUUgPSAnZ2xvYmFsJztcbmNvbnN0IE5PX1NFTEVDVE9SX0VSUk9SX1BSRUZJWCA9ICdTZWxlY3RvciBzaG91bGQgYmUgZGVmaW5lZCc7XG5jb25zdCBTVFlMRV9FUlJPUl9QUkVGSVggPSB7XG4gIE5PX1NUWUxFOiAnTm8gc3R5bGUgZGVjbGFyYXRpb24gZm91bmQnLFxuICBOT19TRUxFQ1RPUjogYCR7Tk9fU0VMRUNUT1JfRVJST1JfUFJFRklYfSBiZWZvcmUgc3R5bGUgZGVjbGFyYXRpb24gaW4gc3R5bGVzaGVldGAsXG4gIElOVkFMSURfU1RZTEU6ICdJbnZhbGlkIHN0eWxlIGRlY2xhcmF0aW9uJyxcbiAgVU5DTE9TRURfU1RZTEU6ICdVbmNsb3NlZCBzdHlsZSBkZWNsYXJhdGlvbicsXG4gIE5PX1BST1BFUlRZOiAnTWlzc2luZyBzdHlsZSBwcm9wZXJ0eSBpbiBkZWNsYXJhdGlvbicsXG4gIE5PX1ZBTFVFOiAnTWlzc2luZyBzdHlsZSB2YWx1ZSBpbiBkZWNsYXJhdGlvbicsXG4gIE5PX1NUWUxFX09SX1JFTU9WRTogJ1N0eWxlIHNob3VsZCBiZSBkZWNsYXJlZCBvciA6cmVtb3ZlKCkgcHNldWRvLWNsYXNzIHNob3VsZCB1c2VkJyxcbiAgTk9fQ09NTUVOVDogJ0NvbW1lbnRzIGFyZSBub3Qgc3VwcG9ydGVkJ1xufTtcbmNvbnN0IE5PX0FUX1JVTEVfRVJST1JfUFJFRklYID0gJ0F0LXJ1bGVzIGFyZSBub3Qgc3VwcG9ydGVkJztcbmNvbnN0IFJFTU9WRV9FUlJPUl9QUkVGSVggPSB7XG4gIElOVkFMSURfUkVNT1ZFOiAnSW52YWxpZCA6cmVtb3ZlKCkgcHNldWRvLWNsYXNzIGluIHNlbGVjdG9yJyxcbiAgTk9fVEFSR0VUX1NFTEVDVE9SOiBgJHtOT19TRUxFQ1RPUl9FUlJPUl9QUkVGSVh9IGJlZm9yZSA6cmVtb3ZlKCkgcHNldWRvLWNsYXNzYCxcbiAgTVVMVElQTEVfVVNBR0U6ICdQc2V1ZG8tY2xhc3MgOnJlbW92ZSgpIGFwcGVhcnMgbW9yZSB0aGFuIG9uY2UgaW4gc2VsZWN0b3InLFxuICBJTlZBTElEX1BPU0lUSU9OOiAnUHNldWRvLWNsYXNzIDpyZW1vdmUoKSBzaG91bGQgYmUgYXQgdGhlIGVuZCBvZiBzZWxlY3Rvcidcbn07XG5jb25zdCBNQVRDSElOR19FTEVNRU5UX0VSUk9SX1BSRUZJWCA9ICdFcnJvciB3aGlsZSBtYXRjaGluZyBlbGVtZW50JztcbmNvbnN0IE1BWF9TVFlMRV9QUk9URUNUSU9OX0NPVU5UID0gNTA7XG5cbi8qKlxuICogUmVnZXhwIHRoYXQgbWF0Y2hlcyBiYWNrd2FyZCBjb21wYXRpYmxlIHN5bnRheGVzLlxuICovXG5cbmNvbnN0IFJFR0VYUF9WQUxJRF9PTERfU1lOVEFYID0gL1xcWy0oPzpleHQpLShbYS16LV9dKyk9KFtcIiddKSgoPzooPz0oXFxcXD8pKVxcNC4pKj8pXFwyXFxdL2c7XG4vKipcbiAqIE1hcmtlciBmb3IgY2hlY2tpbmcgaW52YWxpZCBzZWxlY3RvciBhZnRlciBvbGQtc3ludGF4IG5vcm1hbGl6aW5nIGJ5IHNlbGVjdG9yIGNvbnZlcnRlci5cbiAqL1xuXG5jb25zdCBJTlZBTElEX09MRF9TWU5UQVhfTUFSS0VSID0gJ1stZXh0LSc7XG4vKipcbiAqIENvbXBsZXggcmVwbGFjZW1lbnQgZnVuY3Rpb24uXG4gKiBVbmRvIHF1b3RlIGVzY2FwaW5nIGluc2lkZSBvZiBhbiBleHRlbmRlZCBzZWxlY3Rvci5cbiAqXG4gKiBAcGFyYW0gbWF0Y2ggICAgIFdob2xlIG1hdGNoZWQgc3RyaW5nLlxuICogQHBhcmFtIG5hbWUgICAgICBHcm91cCAxLlxuICogQHBhcmFtIHF1b3RlQ2hhciBHcm91cCAyLlxuICogQHBhcmFtIHJhd1ZhbHVlICBHcm91cCAzLlxuICpcbiAqIEByZXR1cm5zIENvbnZlcnRlZCBzdHJpbmcuXG4gKi9cblxuY29uc3QgZXZhbHVhdGVNYXRjaCA9IChtYXRjaCwgbmFtZSwgcXVvdGVDaGFyLCByYXdWYWx1ZSkgPT4ge1xuICAvLyBVbmVzY2FwZSBxdW90ZXNcbiAgY29uc3QgcmUgPSBuZXcgUmVnRXhwKGAoW15cXFxcXFxcXF18XilcXFxcXFxcXCR7cXVvdGVDaGFyfWAsICdnJyk7XG4gIGNvbnN0IHZhbHVlID0gcmF3VmFsdWUucmVwbGFjZShyZSwgYCQxJHtxdW90ZUNoYXJ9YCk7XG4gIHJldHVybiBgOiR7bmFtZX0oJHt2YWx1ZX0pYDtcbn07IC8vICc6c2NvcGUnIHBzZXVkbyBtYXkgYmUgYXQgc3RhcnQgb2YgOmhhcygpIGFyZ3VtZW50XG4vLyBidXQgRXh0Q3NzRG9jdW1lbnQucXVlcnlTZWxlY3RvckFsbCgpIGFscmVhZHkgdXNlIGl0IGZvciBzZWxlY3RpbmcgZXhhY3QgZWxlbWVudCBkZXNjZW5kYW50c1xuXG5cbmNvbnN0IFNDT1BFX01BUktFUl9SRUdFWFAgPSAvXFwoOnNjb3BlID4vZztcbmNvbnN0IFNDT1BFX1JFUExBQ0VSID0gJyg+JztcbmNvbnN0IE1BVENIRVNfQ1NTX1BTRVVET19FTEVNRU5UX1JFR0VYUCA9IC8oOm1hdGNoZXMtY3NzKS0oYmVmb3JlfGFmdGVyKVxcKC9nO1xuXG5jb25zdCBjb252ZXJ0TWF0Y2hlc0NzcyA9IChtYXRjaCwgZXh0ZW5kZWRQc2V1ZG9DbGFzcywgcmVndWxhclBzZXVkb0VsZW1lbnQpID0+IHtcbiAgLy8gJzptYXRjaGVzLWNzcy1iZWZvcmUoJyAgLS0+ICAnOm1hdGNoZXMtY3NzKGJlZm9yZSwgJ1xuICAvLyAnOm1hdGNoZXMtY3NzLWFmdGVyKCcgICAtLT4gICc6bWF0Y2hlcy1jc3MoYWZ0ZXIsICdcbiAgcmV0dXJuIGAke2V4dGVuZGVkUHNldWRvQ2xhc3N9JHtCUkFDS0VULlBBUkVOVEhFU0VTLkxFRlR9JHtyZWd1bGFyUHNldWRvRWxlbWVudH0ke0NPTU1BfWA7XG59O1xuLyoqXG4gKiBIYW5kbGVzIG9sZCBzeW50YXggYW5kIDpzY29wZSBpbnNpZGUgOmhhcygpLlxuICpcbiAqIEBwYXJhbSBzZWxlY3RvciBUcmltbWVkIHNlbGVjdG9yIHRvIG5vcm1hbGl6ZS5cbiAqXG4gKiBAcmV0dXJucyBOb3JtYWxpemVkIHNlbGVjdG9yLlxuICogQHRocm93cyBBbiBlcnJvciBvbiBpbnZhbGlkIG9sZCBleHRlbmRlZCBzeW50YXggc2VsZWN0b3IuXG4gKi9cblxuXG5jb25zdCBub3JtYWxpemUgPSBzZWxlY3RvciA9PiB7XG4gIGNvbnN0IG5vcm1hbGl6ZWRTZWxlY3RvciA9IHNlbGVjdG9yLnJlcGxhY2UoUkVHRVhQX1ZBTElEX09MRF9TWU5UQVgsIGV2YWx1YXRlTWF0Y2gpLnJlcGxhY2UoU0NPUEVfTUFSS0VSX1JFR0VYUCwgU0NPUEVfUkVQTEFDRVIpLnJlcGxhY2UoTUFUQ0hFU19DU1NfUFNFVURPX0VMRU1FTlRfUkVHRVhQLCBjb252ZXJ0TWF0Y2hlc0Nzcyk7IC8vIHZhbGlkYXRlIG9sZCBzeW50YXggYWZ0ZXIgbm9ybWFsaXppbmdcbiAgLy8gZS5nLiAnWy1leHQtbWF0Y2hlcy1jc3MtYmVmb3JlPVxcJ2NvbnRlbnQ6ICAvXltBLVpdW2Etel0nXG5cbiAgaWYgKG5vcm1hbGl6ZWRTZWxlY3Rvci5pbmNsdWRlcyhJTlZBTElEX09MRF9TWU5UQVhfTUFSS0VSKSkge1xuICAgIHRocm93IG5ldyBFcnJvcihgSW52YWxpZCBleHRlbmRlZC1jc3Mgb2xkIHN5bnRheCBzZWxlY3RvcjogJyR7c2VsZWN0b3J9J2ApO1xuICB9XG5cbiAgcmV0dXJuIG5vcm1hbGl6ZWRTZWxlY3Rvcjtcbn07XG4vKipcbiAqIFByZXBhcmVzIHRoZSByYXdTZWxlY3RvciBiZWZvcmUgdG9rZW5pemF0aW9uOlxuICogMS4gVHJpbXMgaXQuXG4gKiAyLiBDb252ZXJ0cyBvbGQgc3ludGF4IGBbLWV4dC1wc2V1ZG8tY2xhc3M9XCIuLi5cIl1gIHRvIG5ldyBvbmUgYDpwc2V1ZG8tY2xhc3MoLi4uKWAuXG4gKiAzLiBIYW5kbGVzIDpzY29wZSBwc2V1ZG8gaW5zaWRlIDpoYXMoKSBwc2V1ZG8tY2xhc3MgYXJnLlxuICpcbiAqIEBwYXJhbSByYXdTZWxlY3RvciBTZWxlY3RvciB3aXRoIG5vIHN0eWxlIGRlY2xhcmF0aW9uLlxuICogQHJldHVybnMgUHJlcGFyZWQgc2VsZWN0b3Igd2l0aCBubyBzdHlsZSBkZWNsYXJhdGlvbi5cbiAqL1xuXG5cbmNvbnN0IGNvbnZlcnQgPSByYXdTZWxlY3RvciA9PiB7XG4gIGNvbnN0IHRyaW1tZWRTZWxlY3RvciA9IHJhd1NlbGVjdG9yLnRyaW0oKTtcbiAgcmV0dXJuIG5vcm1hbGl6ZSh0cmltbWVkU2VsZWN0b3IpO1xufTtcblxuLyoqXG4gKiBQb3NzaWJsZSB0b2tlbiB0eXBlcy5cbiAqXG4gKiBJTVBPUlRBTlQ6IGl0IGlzIHVzZWQgYXMgJ2NvbnN0JyBpbnN0ZWFkIG9mICdlbnVtJyB0byBhdm9pZCBzaWRlIGVmZmVjdHNcbiAqIGR1cmluZyBFeHRlbmRlZENzcyBpbXBvcnQgaW50byBvdGhlciBsaWJyYXJpZXMuXG4gKi9cbmNvbnN0IFRPS0VOX1RZUEUgPSB7XG4gIE1BUks6ICdtYXJrJyxcbiAgV09SRDogJ3dvcmQnXG59O1xuXG4vKipcbiAqIFNwbGl0cyBgaW5wdXRgIHN0cmluZyBpbnRvIHRva2Vucy5cbiAqXG4gKiBAcGFyYW0gaW5wdXQgSW5wdXQgc3RyaW5nIHRvIHRva2VuaXplLlxuICogQHBhcmFtIHN1cHBvcnRlZE1hcmtzIEFycmF5IG9mIHN1cHBvcnRlZCBtYXJrcyB0byBjb25zaWRlcmVkIGFzIGBUT0tFTl9UWVBFLk1BUktgO1xuICogYWxsIG90aGVyIHdpbGwgYmUgY29uc2lkZXJlZCBhcyBgVE9LRU5fVFlQRS5XT1JEYC5cbiAqXG4gKiBAcmV0dXJucyBBcnJheSBvZiB0b2tlbnMuXG4gKi9cbmNvbnN0IHRva2VuaXplID0gKGlucHV0LCBzdXBwb3J0ZWRNYXJrcykgPT4ge1xuICAvLyBidWZmZXIgaXMgbmVlZGVkIGZvciB3b3JkcyBjb2xsZWN0aW5nIHdoaWxlIGl0ZXJhdGluZ1xuICBsZXQgd29yZEJ1ZmZlciA9ICcnOyAvLyByZXN1bHQgY29sbGVjdGlvblxuXG4gIGNvbnN0IHRva2VucyA9IFtdO1xuICBjb25zdCBzZWxlY3RvclN5bWJvbHMgPSBpbnB1dC5zcGxpdCgnJyk7IC8vIGl0ZXJhdGUgdGhyb3VnaCBzZWxlY3RvciBjaGFycyBhbmQgY29sbGVjdCB0b2tlbnNcblxuICBzZWxlY3RvclN5bWJvbHMuZm9yRWFjaChzeW1ib2wgPT4ge1xuICAgIGlmIChzdXBwb3J0ZWRNYXJrcy5pbmNsdWRlcyhzeW1ib2wpKSB7XG4gICAgICAvLyBpZiBhbnl0aGluZyB3YXMgY29sbGVjdGVkIHRvIHRoZSBidWZmZXIgYmVmb3JlXG4gICAgICBpZiAod29yZEJ1ZmZlci5sZW5ndGggPiAwKSB7XG4gICAgICAgIC8vIG5vdyBpdCBpcyB0aW1lIHRvIHN0b3AgYnVmZmVyIGNvbGxlY3RpbmcgYW5kIHNhdmUgaXMgYXMgXCJ3b3JkXCJcbiAgICAgICAgdG9rZW5zLnB1c2goe1xuICAgICAgICAgIHR5cGU6IFRPS0VOX1RZUEUuV09SRCxcbiAgICAgICAgICB2YWx1ZTogd29yZEJ1ZmZlclxuICAgICAgICB9KTsgLy8gcmVzZXQgdGhlIGJ1ZmZlclxuXG4gICAgICAgIHdvcmRCdWZmZXIgPSAnJztcbiAgICAgIH0gLy8gc2F2ZSBjdXJyZW50IHN5bWJvbCBhcyBcIm1hcmtcIlxuXG5cbiAgICAgIHRva2Vucy5wdXNoKHtcbiAgICAgICAgdHlwZTogVE9LRU5fVFlQRS5NQVJLLFxuICAgICAgICB2YWx1ZTogc3ltYm9sXG4gICAgICB9KTtcbiAgICAgIHJldHVybjtcbiAgICB9IC8vIG90aGVyd2lzZSBjb2xsZWN0IHN5bWJvbCB0byB0aGUgYnVmZmVyXG5cblxuICAgIHdvcmRCdWZmZXIgKz0gc3ltYm9sO1xuICB9KTsgLy8gc2F2ZSB0aGUgbGFzdCBjb2xsZWN0ZWQgd29yZFxuXG4gIGlmICh3b3JkQnVmZmVyLmxlbmd0aCA+IDApIHtcbiAgICB0b2tlbnMucHVzaCh7XG4gICAgICB0eXBlOiBUT0tFTl9UWVBFLldPUkQsXG4gICAgICB2YWx1ZTogd29yZEJ1ZmZlclxuICAgIH0pO1xuICB9XG5cbiAgcmV0dXJuIHRva2Vucztcbn07XG5cbi8qKlxuICogUHJlcGFyZXMgYHJhd1NlbGVjdG9yYCBhbmQgc3BsaXRzIGl0IGludG8gdG9rZW5zLlxuICpcbiAqIEBwYXJhbSByYXdTZWxlY3RvciBSYXcgY3NzIHNlbGVjdG9yLlxuICpcbiAqIEByZXR1cm5zIEFycmF5IG9mIHRva2VucyBzdXBwb3J0ZWQgZm9yIHNlbGVjdG9yLlxuICovXG5cbmNvbnN0IHRva2VuaXplU2VsZWN0b3IgPSByYXdTZWxlY3RvciA9PiB7XG4gIGNvbnN0IHNlbGVjdG9yID0gY29udmVydChyYXdTZWxlY3Rvcik7XG4gIHJldHVybiB0b2tlbml6ZShzZWxlY3RvciwgU1VQUE9SVEVEX1NFTEVDVE9SX01BUktTKTtcbn07XG4vKipcbiAqIFNwbGl0cyBgYXR0cmlidXRlYCBpbnRvIHRva2Vucy5cbiAqXG4gKiBAcGFyYW0gYXR0cmlidXRlIElucHV0IGF0dHJpYnV0ZS5cbiAqXG4gKiBAcmV0dXJucyBBcnJheSBvZiB0b2tlbnMgc3VwcG9ydGVkIGZvciBhdHRyaWJ1dGUuXG4gKi9cblxuY29uc3QgdG9rZW5pemVBdHRyaWJ1dGUgPSBhdHRyaWJ1dGUgPT4ge1xuICAvLyBlcXVhbCBzaWdoIGA9YCBpbiBhdHRyaWJ1dGUgaXMgY29uc2lkZXJlZCBhcyBgVE9LRU5fVFlQRS5NQVJLYFxuICByZXR1cm4gdG9rZW5pemUoYXR0cmlidXRlLCBbLi4uU1VQUE9SVEVEX1NFTEVDVE9SX01BUktTLCBFUVVBTF9TSUdOXSk7XG59O1xuXG4vKipcbiAqIFNvbWUgYnJvd3NlcnMgZG8gbm90IHN1cHBvcnQgQXJyYXkucHJvdG90eXBlLmZsYXQoKVxuICogZS5nLiBPcGVyYSA0MiB3aGljaCBpcyB1c2VkIGZvciBicm93c2Vyc3RhY2sgdGVzdHMuXG4gKlxuICogQHNlZSB7QGxpbmsgaHR0cHM6Ly9kZXZlbG9wZXIubW96aWxsYS5vcmcvZW4tVVMvZG9jcy9XZWIvSmF2YVNjcmlwdC9SZWZlcmVuY2UvR2xvYmFsX09iamVjdHMvQXJyYXkvZmxhdH1cbiAqXG4gKiBAcGFyYW0gaW5wdXQgQXJyYXkgbmVlZGVkIHRvIGJlIGZsYXR0ZW4uXG4gKlxuICogQHJldHVybnMgRmxhdHRlbiBhcnJheS5cbiAqIEB0aHJvd3MgQW4gZXJyb3IgaWYgYXJyYXkgY2Fubm90IGJlIGZsYXR0ZW4uXG4gKi9cbmNvbnN0IGZsYXR0ZW4gPSBpbnB1dCA9PiB7XG4gIGNvbnN0IHN0YWNrID0gW107XG4gIGlucHV0LmZvckVhY2goZWwgPT4gc3RhY2sucHVzaChlbCkpO1xuICBjb25zdCByZXMgPSBbXTtcblxuICB3aGlsZSAoc3RhY2subGVuZ3RoKSB7XG4gICAgLy8gcG9wIHZhbHVlIGZyb20gc3RhY2tcbiAgICBjb25zdCBuZXh0ID0gc3RhY2sucG9wKCk7XG5cbiAgICBpZiAoIW5leHQpIHtcbiAgICAgIHRocm93IG5ldyBFcnJvcignVW5hYmxlIHRvIG1ha2UgYXJyYXkgZmxhdCcpO1xuICAgIH1cblxuICAgIGlmIChBcnJheS5pc0FycmF5KG5leHQpKSB7XG4gICAgICAvLyBwdXNoIGJhY2sgYXJyYXkgaXRlbXMsIHdvbid0IG1vZGlmeSB0aGUgb3JpZ2luYWwgaW5wdXRcbiAgICAgIG5leHQuZm9yRWFjaChlbCA9PiBzdGFjay5wdXNoKGVsKSk7XG4gICAgfSBlbHNlIHtcbiAgICAgIHJlcy5wdXNoKG5leHQpO1xuICAgIH1cbiAgfSAvLyByZXZlcnNlIHRvIHJlc3RvcmUgaW5wdXQgb3JkZXJcblxuXG4gIHJldHVybiByZXMucmV2ZXJzZSgpO1xufTtcbi8qKlxuICogUmV0dXJucyBmaXJzdCBpdGVtIGZyb20gYGFycmF5YC5cbiAqXG4gKiBAcGFyYW0gYXJyYXkgSW5wdXQgYXJyYXkuXG4gKlxuICogQHJldHVybnMgRmlyc3QgYXJyYXkgaXRlbSwgb3IgYHVuZGVmaW5lZGAgaWYgdGhlcmUgaXMgbm8gc3VjaCBpdGVtLlxuICovXG5cbmNvbnN0IGdldEZpcnN0ID0gYXJyYXkgPT4ge1xuICByZXR1cm4gYXJyYXlbMF07XG59O1xuLyoqXG4gKiBSZXR1cm5zIGxhc3QgaXRlbSBmcm9tIGFycmF5LlxuICpcbiAqIEBwYXJhbSBhcnJheSBJbnB1dCBhcnJheS5cbiAqXG4gKiBAcmV0dXJucyBMYXN0IGFycmF5IGl0ZW0sIG9yIGB1bmRlZmluZWRgIGlmIHRoZXJlIGlzIG5vIHN1Y2ggaXRlbS5cbiAqL1xuXG5jb25zdCBnZXRMYXN0ID0gYXJyYXkgPT4ge1xuICByZXR1cm4gYXJyYXlbYXJyYXkubGVuZ3RoIC0gMV07XG59O1xuLyoqXG4gKiBSZXR1cm5zIGFycmF5IGl0ZW0gd2hpY2ggaXMgcHJldmlvdXMgdG8gdGhlIGxhc3Qgb25lXG4gKiBlLmcuIGZvciBgWzUsIDYsIDcsIDhdYCByZXR1cm5zIGA3YC5cbiAqXG4gKiBAcGFyYW0gYXJyYXkgSW5wdXQgYXJyYXkuXG4gKlxuICogQHJldHVybnMgUHJldmlvdXMgdG8gbGFzdCBhcnJheSBpdGVtLCBvciBgdW5kZWZpbmVkYCBpZiB0aGVyZSBpcyBubyBzdWNoIGl0ZW0uXG4gKi9cblxuY29uc3QgZ2V0UHJldlRvTGFzdCA9IGFycmF5ID0+IHtcbiAgcmV0dXJuIGFycmF5W2FycmF5Lmxlbmd0aCAtIDJdO1xufTtcbi8qKlxuICogVGFrZXMgYXJyYXkgb2YgYXN0IG5vZGUgYGNoaWxkcmVuYCBhbmQgcmV0dXJucyB0aGUgY2hpbGQgYnkgdGhlIGBpbmRleGAuXG4gKlxuICogQHBhcmFtIGFycmF5IEFycmF5IG9mIGFzdCBub2RlIGNoaWxkcmVuLlxuICogQHBhcmFtIGluZGV4IEluZGV4IG9mIG5lZWRlZCBjaGlsZCBpbiB0aGUgYXJyYXkuXG4gKiBAcGFyYW0gZXJyb3JNZXNzYWdlIE9wdGlvbmFsIGVycm9yIG1lc3NhZ2UgdG8gdGhyb3cuXG4gKlxuICogQHJldHVybnMgQXJyYXkgaXRlbSBhdCBgaW5kZXhgIHBvc2l0aW9uLlxuICogQHRocm93cyBBbiBlcnJvciBpZiB0aGVyZSBpcyBubyBjaGlsZCB3aXRoIHNwZWNpZmllZCBgaW5kZXhgIGluIGFycmF5LlxuICovXG5cbmNvbnN0IGdldEl0ZW1CeUluZGV4ID0gKGFycmF5LCBpbmRleCwgZXJyb3JNZXNzYWdlKSA9PiB7XG4gIGNvbnN0IGluZGV4Q2hpbGQgPSBhcnJheVtpbmRleF07XG5cbiAgaWYgKCFpbmRleENoaWxkKSB7XG4gICAgdGhyb3cgbmV3IEVycm9yKGVycm9yTWVzc2FnZSB8fCBgTm8gYXJyYXkgaXRlbSBmb3VuZCBieSBpbmRleCAke2luZGV4fWApO1xuICB9XG5cbiAgcmV0dXJuIGluZGV4Q2hpbGQ7XG59O1xuXG5jb25zdCBOT19SRUdVTEFSX1NFTEVDVE9SX0VSUk9SID0gJ0F0IGxlYXN0IG9uZSBvZiBTZWxlY3RvciBub2RlIGNoaWxkcmVuIHNob3VsZCBiZSBSZWd1bGFyU2VsZWN0b3InO1xuLyoqXG4gKiBDaGVja3Mgd2hldGhlciB0aGUgdHlwZSBvZiBgYXN0Tm9kZWAgaXMgU2VsZWN0b3JMaXN0LlxuICpcbiAqIEBwYXJhbSBhc3ROb2RlIEFzdCBub2RlLlxuICpcbiAqIEByZXR1cm5zIFRydWUgaWYgYXN0Tm9kZS50eXBlID09PSBTZWxlY3Rvckxpc3QuXG4gKi9cblxuY29uc3QgaXNTZWxlY3Rvckxpc3ROb2RlID0gYXN0Tm9kZSA9PiB7XG4gIHJldHVybiAoYXN0Tm9kZSA9PT0gbnVsbCB8fCBhc3ROb2RlID09PSB2b2lkIDAgPyB2b2lkIDAgOiBhc3ROb2RlLnR5cGUpID09PSBOT0RFLlNFTEVDVE9SX0xJU1Q7XG59O1xuLyoqXG4gKiBDaGVja3Mgd2hldGhlciB0aGUgdHlwZSBvZiBgYXN0Tm9kZWAgaXMgU2VsZWN0b3IuXG4gKlxuICogQHBhcmFtIGFzdE5vZGUgQXN0IG5vZGUuXG4gKlxuICogQHJldHVybnMgVHJ1ZSBpZiBhc3ROb2RlLnR5cGUgPT09IFNlbGVjdG9yLlxuICovXG5cbmNvbnN0IGlzU2VsZWN0b3JOb2RlID0gYXN0Tm9kZSA9PiB7XG4gIHJldHVybiAoYXN0Tm9kZSA9PT0gbnVsbCB8fCBhc3ROb2RlID09PSB2b2lkIDAgPyB2b2lkIDAgOiBhc3ROb2RlLnR5cGUpID09PSBOT0RFLlNFTEVDVE9SO1xufTtcbi8qKlxuICogQ2hlY2tzIHdoZXRoZXIgdGhlIHR5cGUgb2YgYGFzdE5vZGVgIGlzIFJlZ3VsYXJTZWxlY3Rvci5cbiAqXG4gKiBAcGFyYW0gYXN0Tm9kZSBBc3Qgbm9kZS5cbiAqXG4gKiBAcmV0dXJucyBUcnVlIGlmIGFzdE5vZGUudHlwZSA9PT0gUmVndWxhclNlbGVjdG9yLlxuICovXG5cbmNvbnN0IGlzUmVndWxhclNlbGVjdG9yTm9kZSA9IGFzdE5vZGUgPT4ge1xuICByZXR1cm4gKGFzdE5vZGUgPT09IG51bGwgfHwgYXN0Tm9kZSA9PT0gdm9pZCAwID8gdm9pZCAwIDogYXN0Tm9kZS50eXBlKSA9PT0gTk9ERS5SRUdVTEFSX1NFTEVDVE9SO1xufTtcbi8qKlxuICogQ2hlY2tzIHdoZXRoZXIgdGhlIHR5cGUgb2YgYGFzdE5vZGVgIGlzIEV4dGVuZGVkU2VsZWN0b3IuXG4gKlxuICogQHBhcmFtIGFzdE5vZGUgQXN0IG5vZGUuXG4gKlxuICogQHJldHVybnMgVHJ1ZSBpZiBhc3ROb2RlLnR5cGUgPT09IEV4dGVuZGVkU2VsZWN0b3IuXG4gKi9cblxuY29uc3QgaXNFeHRlbmRlZFNlbGVjdG9yTm9kZSA9IGFzdE5vZGUgPT4ge1xuICByZXR1cm4gYXN0Tm9kZS50eXBlID09PSBOT0RFLkVYVEVOREVEX1NFTEVDVE9SO1xufTtcbi8qKlxuICogQ2hlY2tzIHdoZXRoZXIgdGhlIHR5cGUgb2YgYGFzdE5vZGVgIGlzIEFic29sdXRlUHNldWRvQ2xhc3MuXG4gKlxuICogQHBhcmFtIGFzdE5vZGUgQXN0IG5vZGUuXG4gKlxuICogQHJldHVybnMgVHJ1ZSBpZiBhc3ROb2RlLnR5cGUgPT09IEFic29sdXRlUHNldWRvQ2xhc3MuXG4gKi9cblxuY29uc3QgaXNBYnNvbHV0ZVBzZXVkb0NsYXNzTm9kZSA9IGFzdE5vZGUgPT4ge1xuICByZXR1cm4gKGFzdE5vZGUgPT09IG51bGwgfHwgYXN0Tm9kZSA9PT0gdm9pZCAwID8gdm9pZCAwIDogYXN0Tm9kZS50eXBlKSA9PT0gTk9ERS5BQlNPTFVURV9QU0VVRE9fQ0xBU1M7XG59O1xuLyoqXG4gKiBDaGVja3Mgd2hldGhlciB0aGUgdHlwZSBvZiBgYXN0Tm9kZWAgaXMgUmVsYXRpdmVQc2V1ZG9DbGFzcy5cbiAqXG4gKiBAcGFyYW0gYXN0Tm9kZSBBc3Qgbm9kZS5cbiAqXG4gKiBAcmV0dXJucyBUcnVlIGlmIGFzdE5vZGUudHlwZSA9PT0gUmVsYXRpdmVQc2V1ZG9DbGFzcy5cbiAqL1xuXG5jb25zdCBpc1JlbGF0aXZlUHNldWRvQ2xhc3NOb2RlID0gYXN0Tm9kZSA9PiB7XG4gIHJldHVybiAoYXN0Tm9kZSA9PT0gbnVsbCB8fCBhc3ROb2RlID09PSB2b2lkIDAgPyB2b2lkIDAgOiBhc3ROb2RlLnR5cGUpID09PSBOT0RFLlJFTEFUSVZFX1BTRVVET19DTEFTUztcbn07XG4vKipcbiAqIFJldHVybnMgbmFtZSBvZiBgYXN0Tm9kZWAuXG4gKlxuICogQHBhcmFtIGFzdE5vZGUgQWJzb2x1dGVQc2V1ZG9DbGFzcyBvciBSZWxhdGl2ZVBzZXVkb0NsYXNzIG5vZGUuXG4gKlxuICogQHJldHVybnMgTmFtZSBvZiBgYXN0Tm9kZWAuXG4gKiBAdGhyb3dzIEFuIGVycm9yIG9uIHVuc3VwcG9ydGVkIGFzdCBub2RlIG9yIG5vIG5hbWUgZm91bmQuXG4gKi9cblxuY29uc3QgZ2V0Tm9kZU5hbWUgPSBhc3ROb2RlID0+IHtcbiAgaWYgKGFzdE5vZGUgPT09IG51bGwpIHtcbiAgICB0aHJvdyBuZXcgRXJyb3IoJ0FzdCBub2RlIHNob3VsZCBiZSBkZWZpbmVkJyk7XG4gIH1cblxuICBpZiAoIWlzQWJzb2x1dGVQc2V1ZG9DbGFzc05vZGUoYXN0Tm9kZSkgJiYgIWlzUmVsYXRpdmVQc2V1ZG9DbGFzc05vZGUoYXN0Tm9kZSkpIHtcbiAgICB0aHJvdyBuZXcgRXJyb3IoJ09ubHkgQWJzb2x1dGVQc2V1ZG9DbGFzcyBvciBSZWxhdGl2ZVBzZXVkb0NsYXNzIGFzdCBub2RlIGNhbiBoYXZlIGEgbmFtZScpO1xuICB9XG5cbiAgaWYgKCFhc3ROb2RlLm5hbWUpIHtcbiAgICB0aHJvdyBuZXcgRXJyb3IoJ0V4dGVuZGVkIHBzZXVkby1jbGFzcyBzaG91bGQgaGF2ZSBhIG5hbWUnKTtcbiAgfVxuXG4gIHJldHVybiBhc3ROb2RlLm5hbWU7XG59O1xuLyoqXG4gKiBSZXR1cm5zIHZhbHVlIG9mIGBhc3ROb2RlYC5cbiAqXG4gKiBAcGFyYW0gYXN0Tm9kZSBSZWd1bGFyU2VsZWN0b3Igb3IgQWJzb2x1dGVQc2V1ZG9DbGFzcyBub2RlLlxuICogQHBhcmFtIGVycm9yTWVzc2FnZSBPcHRpb25hbCBlcnJvciBtZXNzYWdlIGlmIG5vIHZhbHVlIGZvdW5kLlxuICpcbiAqIEByZXR1cm5zIFZhbHVlIG9mIGBhc3ROb2RlYC5cbiAqIEB0aHJvd3MgQW4gZXJyb3Igb24gdW5zdXBwb3J0ZWQgYXN0IG5vZGUgb3Igbm8gdmFsdWUgZm91bmQuXG4gKi9cblxuY29uc3QgZ2V0Tm9kZVZhbHVlID0gKGFzdE5vZGUsIGVycm9yTWVzc2FnZSkgPT4ge1xuICBpZiAoYXN0Tm9kZSA9PT0gbnVsbCkge1xuICAgIHRocm93IG5ldyBFcnJvcignQXN0IG5vZGUgc2hvdWxkIGJlIGRlZmluZWQnKTtcbiAgfVxuXG4gIGlmICghaXNSZWd1bGFyU2VsZWN0b3JOb2RlKGFzdE5vZGUpICYmICFpc0Fic29sdXRlUHNldWRvQ2xhc3NOb2RlKGFzdE5vZGUpKSB7XG4gICAgdGhyb3cgbmV3IEVycm9yKCdPbmx5IFJlZ3VsYXJTZWxlY3RvciBvdCBBYnNvbHV0ZVBzZXVkb0NsYXNzIGFzdCBub2RlIGNhbiBoYXZlIGEgdmFsdWUnKTtcbiAgfVxuXG4gIGlmICghYXN0Tm9kZS52YWx1ZSkge1xuICAgIHRocm93IG5ldyBFcnJvcihlcnJvck1lc3NhZ2UgfHwgJ0FzdCBSZWd1bGFyU2VsZWN0b3Igb3QgQWJzb2x1dGVQc2V1ZG9DbGFzcyBub2RlIHNob3VsZCBoYXZlIGEgdmFsdWUnKTtcbiAgfVxuXG4gIHJldHVybiBhc3ROb2RlLnZhbHVlO1xufTtcbi8qKlxuICogUmV0dXJucyBvbmx5IFJlZ3VsYXJTZWxlY3RvciBub2RlcyBmcm9tIGBjaGlsZHJlbmAuXG4gKlxuICogQHBhcmFtIGNoaWxkcmVuIEFycmF5IG9mIGFzdCBub2RlIGNoaWxkcmVuLlxuICpcbiAqIEByZXR1cm5zIEFycmF5IG9mIFJlZ3VsYXJTZWxlY3RvciBub2Rlcy5cbiAqL1xuXG5jb25zdCBnZXRSZWd1bGFyU2VsZWN0b3JOb2RlcyA9IGNoaWxkcmVuID0+IHtcbiAgcmV0dXJuIGNoaWxkcmVuLmZpbHRlcihpc1JlZ3VsYXJTZWxlY3Rvck5vZGUpO1xufTtcbi8qKlxuICogUmV0dXJucyB0aGUgZmlyc3QgUmVndWxhclNlbGVjdG9yIG5vZGUgZnJvbSBgY2hpbGRyZW5gLlxuICpcbiAqIEBwYXJhbSBjaGlsZHJlbiBBcnJheSBvZiBhc3Qgbm9kZSBjaGlsZHJlbi5cbiAqIEBwYXJhbSBlcnJvck1lc3NhZ2UgT3B0aW9uYWwgZXJyb3IgbWVzc2FnZSBpZiBubyB2YWx1ZSBmb3VuZC5cbiAqXG4gKiBAcmV0dXJucyBBc3QgUmVndWxhclNlbGVjdG9yIG5vZGUuXG4gKiBAdGhyb3dzIEFuIGVycm9yIGlmIG5vIFJlZ3VsYXJTZWxlY3RvciBub2RlIGZvdW5kLlxuICovXG5cblxuY29uc3QgZ2V0Rmlyc3RSZWd1bGFyQ2hpbGQgPSAoY2hpbGRyZW4sIGVycm9yTWVzc2FnZSkgPT4ge1xuICBjb25zdCByZWd1bGFyU2VsZWN0b3JOb2RlcyA9IGdldFJlZ3VsYXJTZWxlY3Rvck5vZGVzKGNoaWxkcmVuKTtcbiAgY29uc3QgZmlyc3RSZWd1bGFyU2VsZWN0b3JOb2RlID0gZ2V0Rmlyc3QocmVndWxhclNlbGVjdG9yTm9kZXMpO1xuXG4gIGlmICghZmlyc3RSZWd1bGFyU2VsZWN0b3JOb2RlKSB7XG4gICAgdGhyb3cgbmV3IEVycm9yKGVycm9yTWVzc2FnZSB8fCBOT19SRUdVTEFSX1NFTEVDVE9SX0VSUk9SKTtcbiAgfVxuXG4gIHJldHVybiBmaXJzdFJlZ3VsYXJTZWxlY3Rvck5vZGU7XG59O1xuLyoqXG4gKiBSZXR1cm5zIHRoZSBsYXN0IFJlZ3VsYXJTZWxlY3RvciBub2RlIGZyb20gYGNoaWxkcmVuYC5cbiAqXG4gKiBAcGFyYW0gY2hpbGRyZW4gQXJyYXkgb2YgYXN0IG5vZGUgY2hpbGRyZW4uXG4gKlxuICogQHJldHVybnMgQXN0IFJlZ3VsYXJTZWxlY3RvciBub2RlLlxuICogQHRocm93cyBBbiBlcnJvciBpZiBubyBSZWd1bGFyU2VsZWN0b3Igbm9kZSBmb3VuZC5cbiAqL1xuXG5jb25zdCBnZXRMYXN0UmVndWxhckNoaWxkID0gY2hpbGRyZW4gPT4ge1xuICBjb25zdCByZWd1bGFyU2VsZWN0b3JOb2RlcyA9IGdldFJlZ3VsYXJTZWxlY3Rvck5vZGVzKGNoaWxkcmVuKTtcbiAgY29uc3QgbGFzdFJlZ3VsYXJTZWxlY3Rvck5vZGUgPSBnZXRMYXN0KHJlZ3VsYXJTZWxlY3Rvck5vZGVzKTtcblxuICBpZiAoIWxhc3RSZWd1bGFyU2VsZWN0b3JOb2RlKSB7XG4gICAgdGhyb3cgbmV3IEVycm9yKE5PX1JFR1VMQVJfU0VMRUNUT1JfRVJST1IpO1xuICB9XG5cbiAgcmV0dXJuIGxhc3RSZWd1bGFyU2VsZWN0b3JOb2RlO1xufTtcbi8qKlxuICogUmV0dXJucyB0aGUgb25seSBjaGlsZCBvZiBgbm9kZWAuXG4gKlxuICogQHBhcmFtIG5vZGUgQXN0IG5vZGUuXG4gKiBAcGFyYW0gZXJyb3JNZXNzYWdlIEVycm9yIG1lc3NhZ2UuXG4gKlxuICogQHJldHVybnMgVGhlIG9ubHkgY2hpbGQgb2YgYXN0IG5vZGUuXG4gKiBAdGhyb3dzIEFuIGVycm9yIGlmIG5vbmUgb3IgbW9yZSB0aGFuIG9uZSBjaGlsZCBmb3VuZC5cbiAqL1xuXG5jb25zdCBnZXROb2RlT25seUNoaWxkID0gKG5vZGUsIGVycm9yTWVzc2FnZSkgPT4ge1xuICBpZiAobm9kZS5jaGlsZHJlbi5sZW5ndGggIT09IDEpIHtcbiAgICB0aHJvdyBuZXcgRXJyb3IoZXJyb3JNZXNzYWdlKTtcbiAgfVxuXG4gIGNvbnN0IG9ubHlDaGlsZCA9IGdldEZpcnN0KG5vZGUuY2hpbGRyZW4pO1xuXG4gIGlmICghb25seUNoaWxkKSB7XG4gICAgdGhyb3cgbmV3IEVycm9yKGVycm9yTWVzc2FnZSk7XG4gIH1cblxuICByZXR1cm4gb25seUNoaWxkO1xufTtcbi8qKlxuICogVGFrZXMgRXh0ZW5kZWRTZWxlY3RvciBub2RlIGFuZCByZXR1cm5zIGl0cyBvbmx5IGNoaWxkLlxuICpcbiAqIEBwYXJhbSBleHRlbmRlZFNlbGVjdG9yTm9kZSBFeHRlbmRlZFNlbGVjdG9yIGFzdCBub2RlLlxuICpcbiAqIEByZXR1cm5zIEFic29sdXRlUHNldWRvQ2xhc3Mgb3IgUmVsYXRpdmVQc2V1ZG9DbGFzcy5cbiAqIEB0aHJvd3MgQW4gZXJyb3IgaWYgdGhlcmUgaXMgbm8gc3BlY2lmaWMgcHNldWRvLWNsYXNzIGFzdCBub2RlLlxuICovXG5cbmNvbnN0IGdldFBzZXVkb0NsYXNzTm9kZSA9IGV4dGVuZGVkU2VsZWN0b3JOb2RlID0+IHtcbiAgcmV0dXJuIGdldE5vZGVPbmx5Q2hpbGQoZXh0ZW5kZWRTZWxlY3Rvck5vZGUsICdFeHRlbmRlZCBzZWxlY3RvciBzaG91bGQgYmUgc3BlY2lmaWVkJyk7XG59O1xuLyoqXG4gKiBUYWtlcyBSZWxhdGl2ZVBzZXVkb0NsYXNzIG5vZGUgYW5kIHJldHVybnMgaXRzIG9ubHkgY2hpbGRcbiAqIHdoaWNoIGlzIHJlbGF0aXZlIFNlbGVjdG9yTGlzdCBub2RlLlxuICpcbiAqIEBwYXJhbSBwc2V1ZG9DbGFzc05vZGUgUmVsYXRpdmVQc2V1ZG9DbGFzcy5cbiAqXG4gKiBAcmV0dXJucyBSZWxhdGl2ZSBTZWxlY3Rvckxpc3Qgbm9kZS5cbiAqIEB0aHJvd3MgQW4gZXJyb3IgaWYgbm8gc2VsZWN0b3IgbGlzdCBmb3VuZC5cbiAqL1xuXG5jb25zdCBnZXRSZWxhdGl2ZVNlbGVjdG9yTGlzdE5vZGUgPSBwc2V1ZG9DbGFzc05vZGUgPT4ge1xuICBpZiAoIWlzUmVsYXRpdmVQc2V1ZG9DbGFzc05vZGUocHNldWRvQ2xhc3NOb2RlKSkge1xuICAgIHRocm93IG5ldyBFcnJvcignT25seSBSZWxhdGl2ZVBzZXVkb0NsYXNzIG5vZGUgY2FuIGhhdmUgcmVsYXRpdmUgU2VsZWN0b3JMaXN0IG5vZGUgYXMgY2hpbGQnKTtcbiAgfVxuXG4gIHJldHVybiBnZXROb2RlT25seUNoaWxkKHBzZXVkb0NsYXNzTm9kZSwgYE1pc3NpbmcgYXJnIGZvciA6JHtnZXROb2RlTmFtZShwc2V1ZG9DbGFzc05vZGUpfSgpIHBzZXVkby1jbGFzc2ApO1xufTtcblxuY29uc3QgQVRUUklCVVRFX0NBU0VfSU5TRU5TSVRJVkVfRkxBRyA9ICdpJztcbi8qKlxuICogTGltaXRlZCBsaXN0IG9mIGF2YWlsYWJsZSBzeW1ib2xzIGJlZm9yZSBzbGFzaCBgL2BcbiAqIHRvIGNoZWNrIHdoZXRoZXIgaXQgaXMgdmFsaWQgcmVnZXhwIHBhdHRlcm4gb3BlbmluZy5cbiAqL1xuXG5jb25zdCBQT1NTSUJMRV9NQVJLU19CRUZPUkVfUkVHRVhQID0ge1xuICBDT01NT046IFsvLyBlLmcuICc6bWF0Y2hlcy1hdHRyKC9kYXRhLS8pJ1xuICBCUkFDS0VULlBBUkVOVEhFU0VTLkxFRlQsIC8vIGUuZy4gYDptYXRjaGVzLWF0dHIoJy9kYXRhLS8nKWBcbiAgU0lOR0xFX1FVT1RFLCAvLyBlLmcuICc6bWF0Y2hlcy1hdHRyKFwiL2RhdGEtL1wiKSdcbiAgRE9VQkxFX1FVT1RFLCAvLyBlLmcuICc6bWF0Y2hlcy1hdHRyKGNoZWNrPS9kYXRhLXYtLyknXG4gIEVRVUFMX1NJR04sIC8vIGUuZy4gJzptYXRjaGVzLXByb3BlcnR5KGlubmVyLi9fdGVzdC89bnVsbCknXG4gIERPVCwgLy8gZS5nLiAnOm1hdGNoZXMtY3NzKGhlaWdodDovMjBweC8pJ1xuICBDT0xPTiwgLy8gJzptYXRjaGVzLWNzcy1hZnRlciggY29udGVudCAgOiAgIC8oXFxcXGQrXFxcXHMpKm1lLyAgKSdcbiAgU1BBQ0VdLFxuICBDT05UQUlOUzogWy8vIGUuZy4gJzpjb250YWlucygvdGV4dC8pJ1xuICBCUkFDS0VULlBBUkVOVEhFU0VTLkxFRlQsIC8vIGUuZy4gYDpjb250YWlucygnL3RleHQvJylgXG4gIFNJTkdMRV9RVU9URSwgLy8gZS5nLiAnOmNvbnRhaW5zKFwiL3RleHQvXCIpJ1xuICBET1VCTEVfUVVPVEVdXG59O1xuLyoqXG4gKiBDaGVja3Mgd2hldGhlciB0aGUgcGFzc2VkIHRva2VuIGlzIHN1cHBvcnRlZCBleHRlbmRlZCBwc2V1ZG8tY2xhc3MuXG4gKlxuICogQHBhcmFtIHRva2VuVmFsdWUgVG9rZW4gdmFsdWUgdG8gY2hlY2suXG4gKlxuICogQHJldHVybnMgVHJ1ZSBpZiBgdG9rZW5WYWx1ZWAgaXMgb25lIG9mIHN1cHBvcnRlZCBleHRlbmRlZCBwc2V1ZG8tY2xhc3MgbmFtZXMuXG4gKi9cblxuY29uc3QgaXNTdXBwb3J0ZWRQc2V1ZG9DbGFzcyA9IHRva2VuVmFsdWUgPT4ge1xuICByZXR1cm4gU1VQUE9SVEVEX1BTRVVET19DTEFTU0VTLmluY2x1ZGVzKHRva2VuVmFsdWUpO1xufTtcbi8qKlxuICogQ2hlY2tzIHdoZXRoZXIgdGhlIHBhc3NlZCBwc2V1ZG8tY2xhc3MgYG5hbWVgIHNob3VsZCBiZSBvcHRpbWl6ZWQsXG4gKiBpLmUuIDpub3QoKSBhbmQgOmlzKCkuXG4gKlxuICogQHBhcmFtIG5hbWUgUHNldWRvLWNsYXNzIG5hbWUuXG4gKlxuICogQHJldHVybnMgVHJ1ZSBpZiBgbmFtZWAgaXMgb25lIGlmIHBzZXVkby1jbGFzcyB3aGljaCBzaG91bGQgYmUgb3B0aW1pemVkLlxuICovXG5cbmNvbnN0IGlzT3B0aW1pemF0aW9uUHNldWRvQ2xhc3MgPSBuYW1lID0+IHtcbiAgcmV0dXJuIE9QVElNSVpBVElPTl9QU0VVRE9fQ0xBU1NFUy5pbmNsdWRlcyhuYW1lKTtcbn07XG4vKipcbiAqIENoZWNrcyB3aGV0aGVyIG5leHQgdG8gXCJzcGFjZVwiIHRva2VuIGlzIGEgY29udGludWF0aW9uIG9mIHJlZ3VsYXIgc2VsZWN0b3IgYmVpbmcgcHJvY2Vzc2VkLlxuICpcbiAqIEBwYXJhbSBuZXh0VG9rZW5UeXBlIFR5cGUgb2YgdG9rZW4gbmV4dCB0byBjdXJyZW50IG9uZS5cbiAqIEBwYXJhbSBuZXh0VG9rZW5WYWx1ZSBWYWx1ZSBvZiB0b2tlbiBuZXh0IHRvIGN1cnJlbnQgb25lLlxuICpcbiAqIEByZXR1cm5zIFRydWUgaWYgbmV4dCB0b2tlbiBzZWVtcyB0byBiZSBhIHBhcnQgb2YgY3VycmVudCByZWd1bGFyIHNlbGVjdG9yLlxuICovXG5cbmNvbnN0IGRvZXNSZWd1bGFyQ29udGludWVBZnRlclNwYWNlID0gKG5leHRUb2tlblR5cGUsIG5leHRUb2tlblZhbHVlKSA9PiB7XG4gIC8vIHJlZ3VsYXIgc2VsZWN0b3IgZG9lcyBub3QgY29udGludWVzIGFmdGVyIHRoZSBjdXJyZW50IHRva2VuXG4gIGlmICghbmV4dFRva2VuVHlwZSB8fCAhbmV4dFRva2VuVmFsdWUpIHtcbiAgICByZXR1cm4gZmFsc2U7XG4gIH1cblxuICByZXR1cm4gQ09NQklOQVRPUlMuaW5jbHVkZXMobmV4dFRva2VuVmFsdWUpIHx8IG5leHRUb2tlblR5cGUgPT09IFRPS0VOX1RZUEUuV09SRCAvLyBlLmcuICcjbWFpbiAqOmhhcyg+IC5hZCknXG4gIHx8IG5leHRUb2tlblZhbHVlID09PSBBU1RFUklTSyB8fCBuZXh0VG9rZW5WYWx1ZSA9PT0gSURfTUFSS0VSIHx8IG5leHRUb2tlblZhbHVlID09PSBDTEFTU19NQVJLRVIgLy8gZS5nLiAnZGl2IDp3aGVyZSguY29udGVudCknXG4gIHx8IG5leHRUb2tlblZhbHVlID09PSBDT0xPTiAvLyBlLmcuIFwiZGl2W2NsYXNzKj0nICddXCJcbiAgfHwgbmV4dFRva2VuVmFsdWUgPT09IFNJTkdMRV9RVU9URSAvLyBlLmcuICdkaXZbY2xhc3MqPVwiIFwiXSdcbiAgfHwgbmV4dFRva2VuVmFsdWUgPT09IERPVUJMRV9RVU9URSB8fCBuZXh0VG9rZW5WYWx1ZSA9PT0gQlJBQ0tFVC5TUVVBUkUuTEVGVDtcbn07XG4vKipcbiAqIENoZWNrcyB3aGV0aGVyIHRoZSByZWdleHAgcGF0dGVybiBmb3IgcHNldWRvLWNsYXNzIGFyZyBzdGFydHMuXG4gKiBOZWVkZWQgZm9yIGBjb250ZXh0LmlzUmVnZXhwT3BlbmAgZmxhZy5cbiAqXG4gKiBAcGFyYW0gY29udGV4dCBTZWxlY3RvciBwYXJzZXIgY29udGV4dC5cbiAqIEBwYXJhbSBwcmV2VG9rZW5WYWx1ZSBWYWx1ZSBvZiBwcmV2aW91cyB0b2tlbi5cbiAqIEBwYXJhbSBidWZmZXJOb2RlVmFsdWUgVmFsdWUgb2YgYnVmZmVyTm9kZS5cbiAqXG4gKiBAcmV0dXJucyBUcnVlIGlmIGN1cnJlbnQgdG9rZW4gc2VlbXMgdG8gYmUgYSBzdGFydCBvZiByZWdleHAgcHNldWRvLWNsYXNzIGFyZyBwYXR0ZXJuLlxuICogQHRocm93cyBBbiBlcnJvciBvbiBpbnZhbGlkIHJlZ2V4cCBwYXR0ZXJuLlxuICovXG5cbmNvbnN0IGlzUmVnZXhwT3BlbmluZyA9IChjb250ZXh0LCBwcmV2VG9rZW5WYWx1ZSwgYnVmZmVyTm9kZVZhbHVlKSA9PiB7XG4gIGNvbnN0IGxhc3RFeHRlbmRlZFBzZXVkb0NsYXNzTmFtZSA9IGdldExhc3QoY29udGV4dC5leHRlbmRlZFBzZXVkb05hbWVzU3RhY2spO1xuXG4gIGlmICghbGFzdEV4dGVuZGVkUHNldWRvQ2xhc3NOYW1lKSB7XG4gICAgdGhyb3cgbmV3IEVycm9yKCdSZWdleHAgcGF0dGVybiBhbGxvd2VkIG9ubHkgaW4gYXJnIG9mIGV4dGVuZGVkIHBzZXVkby1jbGFzcycpO1xuICB9IC8vIGZvciByZWdleHAgcGF0dGVucyB0aGUgc2xhc2ggc2hvdWxkIG5vdCBiZSBlc2NhcGVkXG4gIC8vIGNvbnN0IGlzUmVnZXhwUGF0dGVyblNsYXNoID0gcHJldlRva2VuVmFsdWUgIT09IEJBQ0tTTEFTSDtcbiAgLy8gcmVnZXhwIHBhdHRlcm4gY2FuIGJlIHNldCBhcyBhcmcgb2YgcHNldWRvLWNsYXNzXG4gIC8vIHdoaWNoIG1lYW5zIGxpbWl0ZWQgbGlzdCBvZiBhdmFpbGFibGUgc3ltYm9scyBiZWZvcmUgc2xhc2ggYC9gO1xuICAvLyBmb3IgOmNvbnRhaW5zKCkgcHNldWRvLWNsYXNzIHJlZ2V4cCBwYXR0ZXJuIHNob3VsZCBiZSBhdCB0aGUgYmVnaW5uaW5nIG9mIGFyZ1xuXG5cbiAgaWYgKENPTlRBSU5TX1BTRVVET19OQU1FUy5pbmNsdWRlcyhsYXN0RXh0ZW5kZWRQc2V1ZG9DbGFzc05hbWUpKSB7XG4gICAgcmV0dXJuIFBPU1NJQkxFX01BUktTX0JFRk9SRV9SRUdFWFAuQ09OVEFJTlMuaW5jbHVkZXMocHJldlRva2VuVmFsdWUpO1xuICB9XG5cbiAgaWYgKHByZXZUb2tlblZhbHVlID09PSBTTEFTSCAmJiBsYXN0RXh0ZW5kZWRQc2V1ZG9DbGFzc05hbWUgIT09IFhQQVRIX1BTRVVET19DTEFTU19NQVJLRVIpIHtcbiAgICBjb25zdCByYXdBcmdEZXNjID0gYnVmZmVyTm9kZVZhbHVlID8gYGluIGFyZyBwYXJ0OiAnJHtidWZmZXJOb2RlVmFsdWV9J2AgOiAnYXJnJztcbiAgICB0aHJvdyBuZXcgRXJyb3IoYEludmFsaWQgcmVnZXhwIHBhdHRlcm4gZm9yIDoke2xhc3RFeHRlbmRlZFBzZXVkb0NsYXNzTmFtZX0oKSBwc2V1ZG8tY2xhc3MgJHtyYXdBcmdEZXNjfWApO1xuICB9IC8vIGZvciBvdGhlciBwc2V1ZG8tY2xhc3NlcyByZWdleHAgcGF0dGVybiBjYW4gYmUgZWl0aGVyIHRoZSB3aG9sZSBhcmcgb3IgaXRzIHBhcnRcblxuXG4gIHJldHVybiBQT1NTSUJMRV9NQVJLU19CRUZPUkVfUkVHRVhQLkNPTU1PTi5pbmNsdWRlcyhwcmV2VG9rZW5WYWx1ZSk7XG59O1xuLyoqXG4gKiBDaGVja3Mgd2hldGhlciB0aGUgYXR0cmlidXRlIHN0YXJ0cy5cbiAqXG4gKiBAcGFyYW0gdG9rZW5WYWx1ZSBWYWx1ZSBvZiBjdXJyZW50IHRva2VuLlxuICogQHBhcmFtIHByZXZUb2tlblZhbHVlIFByZXZpb3VzIHRva2VuIHZhbHVlLlxuICpcbiAqIEByZXR1cm5zIFRydWUgaWYgY29tYmluYXRpb24gb2YgY3VycmVudCBhbmQgcHJldmlvdXMgdG9rZW4gc2VlbXMgdG8gYmUgKiphIHN0YXJ0Kiogb2YgYXR0cmlidXRlLlxuICovXG5cbmNvbnN0IGlzQXR0cmlidXRlT3BlbmluZyA9ICh0b2tlblZhbHVlLCBwcmV2VG9rZW5WYWx1ZSkgPT4ge1xuICByZXR1cm4gdG9rZW5WYWx1ZSA9PT0gQlJBQ0tFVC5TUVVBUkUuTEVGVCAmJiBwcmV2VG9rZW5WYWx1ZSAhPT0gQkFDS1NMQVNIO1xufTtcbi8qKlxuICogQ2hlY2tzIHdoZXRoZXIgdGhlIGF0dHJpYnV0ZSBlbmRzLlxuICpcbiAqIEBwYXJhbSBjb250ZXh0IFNlbGVjdG9yIHBhcnNlciBjb250ZXh0LlxuICpcbiAqIEByZXR1cm5zIFRydWUgaWYgY29tYmluYXRpb24gb2YgY3VycmVudCBhbmQgcHJldmlvdXMgdG9rZW4gc2VlbXMgdG8gYmUgKiphbiBlbmQqKiBvZiBhdHRyaWJ1dGUuXG4gKiBAdGhyb3dzIEFuIGVycm9yIG9uIGludmFsaWQgYXR0cmlidXRlLlxuICovXG5cbmNvbnN0IGlzQXR0cmlidXRlQ2xvc2luZyA9IGNvbnRleHQgPT4ge1xuICB2YXIgX2dldFByZXZUb0xhc3Q7XG5cbiAgaWYgKCFjb250ZXh0LmlzQXR0cmlidXRlQnJhY2tldHNPcGVuKSB7XG4gICAgcmV0dXJuIGZhbHNlO1xuICB9IC8vIHZhbGlkIGF0dHJpYnV0ZXMgbWF5IGhhdmUgZXh0cmEgc3BhY2VzIGluc2lkZS5cbiAgLy8gd2UgZ2V0IHJpZCBvZiB0aGVtIGp1c3QgdG8gc2ltcGxpZnkgdGhlIGNoZWNraW5nIGFuZCB0aGV5IGFyZSBza2lwcGVkIG9ubHkgaGVyZTpcbiAgLy8gICAtIHNwYWNlcyB3aWxsIGJlIGNvbGxlY3RlZCB0byB0aGUgYXN0IHdpdGggc3BhY2VzIGFzIHRoZXkgd2VyZSBkZWNsYXJlZCBpcyBzZWxlY3RvclxuICAvLyAgIC0gZXh0cmEgc3BhY2VzIGluIGF0dHJpYnV0ZSBhcmUgbm90IHJlbGV2YW50IHRvIGF0dHJpYnV0ZSBzeW50YXggdmFsaWRpdHlcbiAgLy8gICAgIGUuZy4gJ2FbIHRpdGxlIF0nIGlzIHRoZSBzYW1lIGFzICdhW3RpdGxlXSdcbiAgLy8gICAgICAgICAgJ2RpdltzdHlsZSAqPSBcIk1BUkdJTlwiIGldJyBpcyB0aGUgc2FtZSBhcyAnZGl2W3N0eWxlKj1cIk1BUkdJTlwiaV0nXG5cblxuICBjb25zdCBub1NwYWNlQXR0ciA9IGNvbnRleHQuYXR0cmlidXRlQnVmZmVyLnNwbGl0KFNQQUNFKS5qb2luKCcnKTsgLy8gdG9rZW5pemUgdGhlIHByZXBhcmVkIGF0dHJpYnV0ZSBzdHJpbmdcblxuICBjb25zdCBhdHRyVG9rZW5zID0gdG9rZW5pemVBdHRyaWJ1dGUobm9TcGFjZUF0dHIpO1xuICBjb25zdCBmaXJzdEF0dHJUb2tlbiA9IGdldEZpcnN0KGF0dHJUb2tlbnMpO1xuICBjb25zdCBmaXJzdEF0dHJUb2tlblR5cGUgPSBmaXJzdEF0dHJUb2tlbiA9PT0gbnVsbCB8fCBmaXJzdEF0dHJUb2tlbiA9PT0gdm9pZCAwID8gdm9pZCAwIDogZmlyc3RBdHRyVG9rZW4udHlwZTtcbiAgY29uc3QgZmlyc3RBdHRyVG9rZW5WYWx1ZSA9IGZpcnN0QXR0clRva2VuID09PSBudWxsIHx8IGZpcnN0QXR0clRva2VuID09PSB2b2lkIDAgPyB2b2lkIDAgOiBmaXJzdEF0dHJUb2tlbi52YWx1ZTsgLy8gc2lnbmFsIGFuIGVycm9yIG9uIGFueSBtYXJrLXR5cGUgdG9rZW4gZXhjZXB0IGJhY2tzbGFzaFxuICAvLyBlLmcuICdbPVwibWFyZ2luXCJdJ1xuXG4gIGlmIChmaXJzdEF0dHJUb2tlblR5cGUgPT09IFRPS0VOX1RZUEUuTUFSSyAvLyBiYWNrc2xhc2ggaXMgYWxsb3dlZCBhdCBzdGFydCBvZiBhdHRyaWJ1dGVcbiAgLy8gZS5nLiAnW1xcXFw6ZGF0YS1zZXJ2aWNlLXNsb3RdJ1xuICAmJiBmaXJzdEF0dHJUb2tlblZhbHVlICE9PSBCQUNLU0xBU0gpIHtcbiAgICAvLyBlc2xpbnQtZGlzYWJsZS1uZXh0LWxpbmUgbWF4LWxlblxuICAgIHRocm93IG5ldyBFcnJvcihgJ1ske2NvbnRleHQuYXR0cmlidXRlQnVmZmVyfV0nIGlzIG5vdCBhIHZhbGlkIGF0dHJpYnV0ZSBkdWUgdG8gJyR7Zmlyc3RBdHRyVG9rZW5WYWx1ZX0nIGF0IHN0YXJ0IG9mIGl0YCk7XG4gIH1cblxuICBjb25zdCBsYXN0QXR0clRva2VuID0gZ2V0TGFzdChhdHRyVG9rZW5zKTtcbiAgY29uc3QgbGFzdEF0dHJUb2tlblR5cGUgPSBsYXN0QXR0clRva2VuID09PSBudWxsIHx8IGxhc3RBdHRyVG9rZW4gPT09IHZvaWQgMCA/IHZvaWQgMCA6IGxhc3RBdHRyVG9rZW4udHlwZTtcbiAgY29uc3QgbGFzdEF0dHJUb2tlblZhbHVlID0gbGFzdEF0dHJUb2tlbiA9PT0gbnVsbCB8fCBsYXN0QXR0clRva2VuID09PSB2b2lkIDAgPyB2b2lkIDAgOiBsYXN0QXR0clRva2VuLnZhbHVlO1xuXG4gIGlmIChsYXN0QXR0clRva2VuVmFsdWUgPT09IEVRVUFMX1NJR04pIHtcbiAgICAvLyBlLmcuICdbc3R5bGU9XSdcbiAgICB0aHJvdyBuZXcgRXJyb3IoYCdbJHtjb250ZXh0LmF0dHJpYnV0ZUJ1ZmZlcn1dJyBpcyBub3QgYSB2YWxpZCBhdHRyaWJ1dGUgZHVlIHRvICcke0VRVUFMX1NJR059J2ApO1xuICB9XG5cbiAgY29uc3QgZXF1YWxTaWduSW5kZXggPSBhdHRyVG9rZW5zLmZpbmRJbmRleCh0b2tlbiA9PiB7XG4gICAgcmV0dXJuIHRva2VuLnR5cGUgPT09IFRPS0VOX1RZUEUuTUFSSyAmJiB0b2tlbi52YWx1ZSA9PT0gRVFVQUxfU0lHTjtcbiAgfSk7XG4gIGNvbnN0IHByZXZUb0xhc3RBdHRyVG9rZW5WYWx1ZSA9IChfZ2V0UHJldlRvTGFzdCA9IGdldFByZXZUb0xhc3QoYXR0clRva2VucykpID09PSBudWxsIHx8IF9nZXRQcmV2VG9MYXN0ID09PSB2b2lkIDAgPyB2b2lkIDAgOiBfZ2V0UHJldlRvTGFzdC52YWx1ZTtcblxuICBpZiAoZXF1YWxTaWduSW5kZXggPT09IC0xKSB7XG4gICAgLy8gaWYgdGhlcmUgaXMgbm8gJz0nIGluc2lkZSBhdHRyaWJ1dGUsXG4gICAgLy8gaXQgbXVzdCBiZSBqdXN0IGF0dHJpYnV0ZSBuYW1lIHdoaWNoIG1lYW5zIHRoZSB3b3JkLXR5cGUgdG9rZW4gYmVmb3JlIGNsb3NpbmcgYnJhY2tldFxuICAgIC8vIGUuZy4gJ2RpdltzdHlsZV0nXG4gICAgaWYgKGxhc3RBdHRyVG9rZW5UeXBlID09PSBUT0tFTl9UWVBFLldPUkQpIHtcbiAgICAgIHJldHVybiB0cnVlO1xuICAgIH1cblxuICAgIHJldHVybiBwcmV2VG9MYXN0QXR0clRva2VuVmFsdWUgPT09IEJBQ0tTTEFTSCAvLyBzb21lIHdlaXJkIGF0dHJpYnV0ZSBhcmUgdmFsaWQgdG9vXG4gICAgLy8gZS5nLiAnW2NsYXNzXFxcXFwiYWRzLWFydGljbGVcXFxcXCJdJ1xuICAgICYmIChsYXN0QXR0clRva2VuVmFsdWUgPT09IERPVUJMRV9RVU9URSAvLyBlLmcuIFwiW2NsYXNzXFxcXCdhZHMtYXJ0aWNsZVxcXFwnXVwiXG4gICAgfHwgbGFzdEF0dHJUb2tlblZhbHVlID09PSBTSU5HTEVfUVVPVEUpO1xuICB9IC8vIGdldCB0aGUgdmFsdWUgb2YgdG9rZW4gbmV4dCB0byBgPWBcblxuXG4gIGNvbnN0IG5leHRUb0VxdWFsU2lnblRva2VuID0gZ2V0SXRlbUJ5SW5kZXgoYXR0clRva2VucywgZXF1YWxTaWduSW5kZXggKyAxKTtcbiAgY29uc3QgbmV4dFRvRXF1YWxTaWduVG9rZW5WYWx1ZSA9IG5leHRUb0VxdWFsU2lnblRva2VuLnZhbHVlOyAvLyBjaGVjayB3aGV0aGVyIHRoZSBhdHRyaWJ1dGUgdmFsdWUgd3JhcHBlciBpbiBxdW90ZXNcblxuICBjb25zdCBpc0F0dHJWYWx1ZVF1b3RlID0gbmV4dFRvRXF1YWxTaWduVG9rZW5WYWx1ZSA9PT0gU0lOR0xFX1FVT1RFIHx8IG5leHRUb0VxdWFsU2lnblRva2VuVmFsdWUgPT09IERPVUJMRV9RVU9URTsgLy8gZm9yIG5vIHF1b3RlcyBhZnRlciBgPWAgdGhlIGxhc3QgdG9rZW4gYmVmb3JlIGBdYCBzaG91bGQgYmUgYSB3b3JkLXR5cGUgb25lXG4gIC8vIGUuZy4gJ2RpdltzdHlsZSo9bWFyZ2luXSdcbiAgLy8gICAgICAnZGl2W3N0eWxlKj1NQVJHSU4gaV0nXG5cbiAgaWYgKCFpc0F0dHJWYWx1ZVF1b3RlKSB7XG4gICAgaWYgKGxhc3RBdHRyVG9rZW5UeXBlID09PSBUT0tFTl9UWVBFLldPUkQpIHtcbiAgICAgIHJldHVybiB0cnVlO1xuICAgIH0gLy8gb3RoZXJ3aXNlIHNpZ25hbCBhbiBlcnJvclxuICAgIC8vIGUuZy4gJ3RhYmxlW3N0eWxlKj1ib3JkZXI6IDBweFwiXSdcblxuXG4gICAgdGhyb3cgbmV3IEVycm9yKGAnWyR7Y29udGV4dC5hdHRyaWJ1dGVCdWZmZXJ9XScgaXMgbm90IGEgdmFsaWQgYXR0cmlidXRlYCk7XG4gIH0gLy8gb3RoZXJ3aXNlIGlmIHF1b3RlcyBmb3IgdmFsdWUgYXJlIHByZXNlbnRcbiAgLy8gdGhlIGxhc3QgdG9rZW4gYmVmb3JlIGBdYCBjYW4gc3RpbGwgYmUgd29yZC10eXBlIHRva2VuXG4gIC8vIGUuZy4gJ2RpdltzdHlsZSo9XCJNQVJHSU5cIiBpXSdcblxuXG4gIGlmIChsYXN0QXR0clRva2VuVHlwZSA9PT0gVE9LRU5fVFlQRS5XT1JEICYmIChsYXN0QXR0clRva2VuVmFsdWUgPT09IG51bGwgfHwgbGFzdEF0dHJUb2tlblZhbHVlID09PSB2b2lkIDAgPyB2b2lkIDAgOiBsYXN0QXR0clRva2VuVmFsdWUudG9Mb2NhbGVMb3dlckNhc2UoKSkgPT09IEFUVFJJQlVURV9DQVNFX0lOU0VOU0lUSVZFX0ZMQUcpIHtcbiAgICByZXR1cm4gcHJldlRvTGFzdEF0dHJUb2tlblZhbHVlID09PSBuZXh0VG9FcXVhbFNpZ25Ub2tlblZhbHVlO1xuICB9IC8vIGV2ZW50dWFsbHkgaWYgdGhlcmUgaXMgcXVvdGVzIGZvciBhdHRyaWJ1dGUgdmFsdWUgYW5kIGxhc3QgdG9rZW4gaXMgbm90IGEgd29yZCxcbiAgLy8gdGhlIGNsb3NpbmcgbWFyayBzaG91bGQgYmUgdGhlIHNhbWUgcXVvdGUgYXMgb3BlbmluZyBvbmVcblxuXG4gIHJldHVybiBsYXN0QXR0clRva2VuVmFsdWUgPT09IG5leHRUb0VxdWFsU2lnblRva2VuVmFsdWU7XG59O1xuLyoqXG4gKiBDaGVja3Mgd2hldGhlciB0aGUgYHRva2VuVmFsdWVgIGlzIGEgd2hpdGVzcGFjZSBjaGFyYWN0ZXIuXG4gKlxuICogQHBhcmFtIHRva2VuVmFsdWUgVG9rZW4gdmFsdWUuXG4gKlxuICogQHJldHVybnMgVHJ1ZSBpZiBgdG9rZW5WYWx1ZWAgaXMgYSB3aGl0ZXNwYWNlIGNoYXJhY3Rlci5cbiAqL1xuXG5jb25zdCBpc1doaXRlU3BhY2VDaGFyID0gdG9rZW5WYWx1ZSA9PiB7XG4gIGlmICghdG9rZW5WYWx1ZSkge1xuICAgIHJldHVybiBmYWxzZTtcbiAgfVxuXG4gIHJldHVybiBXSElURV9TUEFDRV9DSEFSQUNURVJTLmluY2x1ZGVzKHRva2VuVmFsdWUpO1xufTtcblxuLyoqXG4gKiBDaGVja3Mgd2hldGhlciB0aGUgcGFzc2VkIGBzdHJgIGlzIGEgbmFtZSBvZiBzdXBwb3J0ZWQgYWJzb2x1dGUgZXh0ZW5kZWQgcHNldWRvLWNsYXNzLFxuICogZS5nLiA6Y29udGFpbnMoKSwgOm1hdGNoZXMtY3NzKCkgZXRjLlxuICpcbiAqIEBwYXJhbSBzdHIgVG9rZW4gdmFsdWUgdG8gY2hlY2suXG4gKlxuICogQHJldHVybnMgVHJ1ZSBpZiBgc3RyYCBpcyBvbmUgb2YgYWJzb2x1dGUgZXh0ZW5kZWQgcHNldWRvLWNsYXNzIG5hbWVzLlxuICovXG5cbmNvbnN0IGlzQWJzb2x1dGVQc2V1ZG9DbGFzcyA9IHN0ciA9PiB7XG4gIHJldHVybiBBQlNPTFVURV9QU0VVRE9fQ0xBU1NFUy5pbmNsdWRlcyhzdHIpO1xufTtcbi8qKlxuICogQ2hlY2tzIHdoZXRoZXIgdGhlIHBhc3NlZCBgc3RyYCBpcyBhIG5hbWUgb2Ygc3VwcG9ydGVkIHJlbGF0aXZlIGV4dGVuZGVkIHBzZXVkby1jbGFzcyxcbiAqIGUuZy4gOmhhcygpLCA6bm90KCkgZXRjLlxuICpcbiAqIEBwYXJhbSBzdHIgVG9rZW4gdmFsdWUgdG8gY2hlY2suXG4gKlxuICogQHJldHVybnMgVHJ1ZSBpZiBgc3RyYCBpcyBvbmUgb2YgcmVsYXRpdmUgZXh0ZW5kZWQgcHNldWRvLWNsYXNzIG5hbWVzLlxuICovXG5cbmNvbnN0IGlzUmVsYXRpdmVQc2V1ZG9DbGFzcyA9IHN0ciA9PiB7XG4gIHJldHVybiBSRUxBVElWRV9QU0VVRE9fQ0xBU1NFUy5pbmNsdWRlcyhzdHIpO1xufTtcblxuLyoqXG4gKiBSZXR1cm5zIHRoZSBub2RlIHdoaWNoIGlzIGJlaW5nIGNvbGxlY3RlZFxuICogb3IgbnVsbCBpZiB0aGVyZSBpcyBubyBzdWNoIG9uZS5cbiAqXG4gKiBAcGFyYW0gY29udGV4dCBTZWxlY3RvciBwYXJzZXIgY29udGV4dC5cbiAqXG4gKiBAcmV0dXJucyBCdWZmZXIgbm9kZSBvciBudWxsLlxuICovXG5cbmNvbnN0IGdldEJ1ZmZlck5vZGUgPSBjb250ZXh0ID0+IHtcbiAgaWYgKGNvbnRleHQucGF0aFRvQnVmZmVyTm9kZS5sZW5ndGggPT09IDApIHtcbiAgICByZXR1cm4gbnVsbDtcbiAgfSAvLyBidWZmZXIgbm9kZSBpcyBhbHdheXMgdGhlIGxhc3QgaW4gdGhlIHBhdGhUb0J1ZmZlck5vZGUgc3RhY2tcblxuXG4gIHJldHVybiBnZXRMYXN0KGNvbnRleHQucGF0aFRvQnVmZmVyTm9kZSkgfHwgbnVsbDtcbn07XG4vKipcbiAqIFJldHVybnMgdGhlIHBhcmVudCBub2RlIHRvIHRoZSAnYnVmZmVyIG5vZGUnIOKAlCB3aGljaCBpcyB0aGUgb25lIGJlaW5nIGNvbGxlY3RlZCDigJRcbiAqIG9yIG51bGwgaWYgdGhlcmUgaXMgbm8gc3VjaCBvbmUuXG4gKlxuICogQHBhcmFtIGNvbnRleHQgU2VsZWN0b3IgcGFyc2VyIGNvbnRleHQuXG4gKlxuICogQHJldHVybnMgUGFyZW50IG5vZGUgb2YgYnVmZmVyIG5vZGUgb3IgbnVsbC5cbiAqL1xuXG5jb25zdCBnZXRCdWZmZXJOb2RlUGFyZW50ID0gY29udGV4dCA9PiB7XG4gIC8vIGF0IGxlYXN0IHR3byBub2RlcyBzaG91bGQgZXhpc3Qg4oCUIHRoZSBidWZmZXIgbm9kZSBhbmQgaXRzIHBhcmVudFxuICAvLyBvdGhlcndpc2UgcmV0dXJuIG51bGxcbiAgaWYgKGNvbnRleHQucGF0aFRvQnVmZmVyTm9kZS5sZW5ndGggPCAyKSB7XG4gICAgcmV0dXJuIG51bGw7XG4gIH0gLy8gc2luY2UgdGhlIGJ1ZmZlciBub2RlIGlzIGFsd2F5cyB0aGUgbGFzdCBpbiB0aGUgcGF0aFRvQnVmZmVyTm9kZSBzdGFja1xuICAvLyBpdHMgcGFyZW50IGlzIHByZXZpb3VzIHRvIGl0IGluIHRoZSBzdGFja1xuXG5cbiAgcmV0dXJuIGdldFByZXZUb0xhc3QoY29udGV4dC5wYXRoVG9CdWZmZXJOb2RlKSB8fCBudWxsO1xufTtcbi8qKlxuICogUmV0dXJucyBsYXN0IFJlZ3VsYXJTZWxlY3RvciBhc3Qgbm9kZS5cbiAqIE5lZWRlZCBmb3IgcGFyc2luZyBvZiB0aGUgY29tcGxleCBzZWxlY3RvciB3aXRoIGV4dGVuZGVkIHBzZXVkby1jbGFzcyBpbnNpZGUgaXQuXG4gKlxuICogQHBhcmFtIGNvbnRleHQgU2VsZWN0b3IgcGFyc2VyIGNvbnRleHQuXG4gKlxuICogQHJldHVybnMgQXN0IFJlZ3VsYXJTZWxlY3RvciBub2RlLlxuICogQHRocm93cyBBbiBlcnJvciBpZjpcbiAqIC0gYnVmZmVyTm9kZSBpcyBhYnNlbnQ7XG4gKiAtIHR5cGUgb2YgYnVmZmVyTm9kZSBpcyB1bnN1cHBvcnRlZDtcbiAqIC0gbm8gUmVndWxhclNlbGVjdG9yIGluIGJ1ZmZlck5vZGUuXG4gKi9cblxuY29uc3QgZ2V0Q29udGV4dExhc3RSZWd1bGFyU2VsZWN0b3JOb2RlID0gY29udGV4dCA9PiB7XG4gIGNvbnN0IGJ1ZmZlck5vZGUgPSBnZXRCdWZmZXJOb2RlKGNvbnRleHQpO1xuXG4gIGlmICghYnVmZmVyTm9kZSkge1xuICAgIHRocm93IG5ldyBFcnJvcignTm8gYnVmZmVyTm9kZSBmb3VuZCcpO1xuICB9XG5cbiAgaWYgKCFpc1NlbGVjdG9yTm9kZShidWZmZXJOb2RlKSkge1xuICAgIHRocm93IG5ldyBFcnJvcignVW5zdXBwb3J0ZWQgYnVmZmVyTm9kZSB0eXBlJyk7XG4gIH1cblxuICBjb25zdCBsYXN0UmVndWxhclNlbGVjdG9yTm9kZSA9IGdldExhc3RSZWd1bGFyQ2hpbGQoYnVmZmVyTm9kZS5jaGlsZHJlbik7XG4gIGNvbnRleHQucGF0aFRvQnVmZmVyTm9kZS5wdXNoKGxhc3RSZWd1bGFyU2VsZWN0b3JOb2RlKTtcbiAgcmV0dXJuIGxhc3RSZWd1bGFyU2VsZWN0b3JOb2RlO1xufTtcbi8qKlxuICogVXBkYXRlcyBuZWVkZWQgYnVmZmVyIG5vZGUgdmFsdWUgd2hpbGUgdG9rZW5zIGl0ZXJhdGluZy5cbiAqIEZvciBSZWd1bGFyU2VsZWN0b3IgYWxzbyBjb2xsZWN0cyB0b2tlbiB2YWx1ZXMgdG8gY29udGV4dC5hdHRyaWJ1dGVCdWZmZXJcbiAqIGZvciBwcm9wZXIgYXR0cmlidXRlIHBhcnNpbmcuXG4gKlxuICogQHBhcmFtIGNvbnRleHQgU2VsZWN0b3IgcGFyc2VyIGNvbnRleHQuXG4gKiBAcGFyYW0gdG9rZW5WYWx1ZSBWYWx1ZSBvZiBjdXJyZW50IHRva2VuLlxuICpcbiAqIEB0aHJvd3MgQW4gZXJyb3IgaWY6XG4gKiAtIG5vIGJ1ZmZlck5vZGU7XG4gKiAtIGJ1ZmZlck5vZGUudHlwZSBpcyBub3QgUmVndWxhclNlbGVjdG9yIG9yIEFic29sdXRlUHNldWRvQ2xhc3MuXG4gKi9cblxuY29uc3QgdXBkYXRlQnVmZmVyTm9kZSA9IChjb250ZXh0LCB0b2tlblZhbHVlKSA9PiB7XG4gIGNvbnN0IGJ1ZmZlck5vZGUgPSBnZXRCdWZmZXJOb2RlKGNvbnRleHQpO1xuXG4gIGlmIChidWZmZXJOb2RlID09PSBudWxsKSB7XG4gICAgdGhyb3cgbmV3IEVycm9yKCdObyBidWZmZXJOb2RlIHRvIHVwZGF0ZScpO1xuICB9XG5cbiAgaWYgKGlzQWJzb2x1dGVQc2V1ZG9DbGFzc05vZGUoYnVmZmVyTm9kZSkpIHtcbiAgICBidWZmZXJOb2RlLnZhbHVlICs9IHRva2VuVmFsdWU7XG4gIH0gZWxzZSBpZiAoaXNSZWd1bGFyU2VsZWN0b3JOb2RlKGJ1ZmZlck5vZGUpKSB7XG4gICAgYnVmZmVyTm9kZS52YWx1ZSArPSB0b2tlblZhbHVlO1xuXG4gICAgaWYgKGNvbnRleHQuaXNBdHRyaWJ1dGVCcmFja2V0c09wZW4pIHtcbiAgICAgIGNvbnRleHQuYXR0cmlidXRlQnVmZmVyICs9IHRva2VuVmFsdWU7XG4gICAgfVxuICB9IGVsc2Uge1xuICAgIC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBtYXgtbGVuXG4gICAgdGhyb3cgbmV3IEVycm9yKGAke2J1ZmZlck5vZGUudHlwZX0gbm9kZSBjYW5ub3QgYmUgdXBkYXRlZC4gT25seSBSZWd1bGFyU2VsZWN0b3IgYW5kIEFic29sdXRlUHNldWRvQ2xhc3MgYXJlIHN1cHBvcnRlZGApO1xuICB9XG59O1xuLyoqXG4gKiBBZGRzIFNlbGVjdG9yTGlzdCBub2RlIHRvIGNvbnRleHQuYXN0IGF0IHRoZSBzdGFydCBvZiBhc3QgY29sbGVjdGluZy5cbiAqXG4gKiBAcGFyYW0gY29udGV4dCBTZWxlY3RvciBwYXJzZXIgY29udGV4dC5cbiAqL1xuXG5jb25zdCBhZGRTZWxlY3Rvckxpc3ROb2RlID0gY29udGV4dCA9PiB7XG4gIGNvbnN0IHNlbGVjdG9yTGlzdE5vZGUgPSBuZXcgQW55U2VsZWN0b3JOb2RlKE5PREUuU0VMRUNUT1JfTElTVCk7XG4gIGNvbnRleHQuYXN0ID0gc2VsZWN0b3JMaXN0Tm9kZTtcbiAgY29udGV4dC5wYXRoVG9CdWZmZXJOb2RlLnB1c2goc2VsZWN0b3JMaXN0Tm9kZSk7XG59O1xuLyoqXG4gKiBBZGRzIG5ldyBub2RlIHRvIGJ1ZmZlciBub2RlIGNoaWxkcmVuLlxuICogTmV3IGFkZGVkIG5vZGUgd2lsbCBiZSBjb25zaWRlcmVkIGFzIGJ1ZmZlciBub2RlIGFmdGVyIGl0LlxuICpcbiAqIEBwYXJhbSBjb250ZXh0IFNlbGVjdG9yIHBhcnNlciBjb250ZXh0LlxuICogQHBhcmFtIHR5cGUgVHlwZSBvZiBub2RlIHRvIGFkZC5cbiAqIEBwYXJhbSB0b2tlblZhbHVlIE9wdGlvbmFsLCBkZWZhdWx0cyB0byBgJydgLCB2YWx1ZSBvZiBwcm9jZXNzaW5nIHRva2VuLlxuICpcbiAqIEB0aHJvd3MgQW4gZXJyb3IgaWYgbm8gYnVmZmVyTm9kZS5cbiAqL1xuXG5jb25zdCBhZGRBc3ROb2RlQnlUeXBlID0gZnVuY3Rpb24gKGNvbnRleHQsIHR5cGUpIHtcbiAgbGV0IHRva2VuVmFsdWUgPSBhcmd1bWVudHMubGVuZ3RoID4gMiAmJiBhcmd1bWVudHNbMl0gIT09IHVuZGVmaW5lZCA/IGFyZ3VtZW50c1syXSA6ICcnO1xuICBjb25zdCBidWZmZXJOb2RlID0gZ2V0QnVmZmVyTm9kZShjb250ZXh0KTtcblxuICBpZiAoYnVmZmVyTm9kZSA9PT0gbnVsbCkge1xuICAgIHRocm93IG5ldyBFcnJvcignTm8gYnVmZmVyIG5vZGUnKTtcbiAgfVxuXG4gIGxldCBub2RlO1xuXG4gIGlmICh0eXBlID09PSBOT0RFLlJFR1VMQVJfU0VMRUNUT1IpIHtcbiAgICBub2RlID0gbmV3IFJlZ3VsYXJTZWxlY3Rvck5vZGUodG9rZW5WYWx1ZSk7XG4gIH0gZWxzZSBpZiAodHlwZSA9PT0gTk9ERS5BQlNPTFVURV9QU0VVRE9fQ0xBU1MpIHtcbiAgICBub2RlID0gbmV3IEFic29sdXRlUHNldWRvQ2xhc3NOb2RlKHRva2VuVmFsdWUpO1xuICB9IGVsc2UgaWYgKHR5cGUgPT09IE5PREUuUkVMQVRJVkVfUFNFVURPX0NMQVNTKSB7XG4gICAgbm9kZSA9IG5ldyBSZWxhdGl2ZVBzZXVkb0NsYXNzTm9kZSh0b2tlblZhbHVlKTtcbiAgfSBlbHNlIHtcbiAgICAvLyBTZWxlY3Rvckxpc3QgfHwgU2VsZWN0b3IgfHwgRXh0ZW5kZWRTZWxlY3RvclxuICAgIG5vZGUgPSBuZXcgQW55U2VsZWN0b3JOb2RlKHR5cGUpO1xuICB9XG5cbiAgYnVmZmVyTm9kZS5hZGRDaGlsZChub2RlKTtcbiAgY29udGV4dC5wYXRoVG9CdWZmZXJOb2RlLnB1c2gobm9kZSk7XG59O1xuLyoqXG4gKiBUaGUgdmVyeSBiZWdpbm5pbmcgb2YgYXN0IGNvbGxlY3RpbmcuXG4gKlxuICogQHBhcmFtIGNvbnRleHQgU2VsZWN0b3IgcGFyc2VyIGNvbnRleHQuXG4gKiBAcGFyYW0gdG9rZW5WYWx1ZSBWYWx1ZSBvZiByZWd1bGFyIHNlbGVjdG9yLlxuICovXG5cbmNvbnN0IGluaXRBc3QgPSAoY29udGV4dCwgdG9rZW5WYWx1ZSkgPT4ge1xuICBhZGRTZWxlY3Rvckxpc3ROb2RlKGNvbnRleHQpO1xuICBhZGRBc3ROb2RlQnlUeXBlKGNvbnRleHQsIE5PREUuU0VMRUNUT1IpOyAvLyBSZWd1bGFyU2VsZWN0b3Igbm9kZSBpcyBhbHdheXMgdGhlIGZpcnN0IGNoaWxkIG9mIFNlbGVjdG9yIG5vZGVcblxuICBhZGRBc3ROb2RlQnlUeXBlKGNvbnRleHQsIE5PREUuUkVHVUxBUl9TRUxFQ1RPUiwgdG9rZW5WYWx1ZSk7XG59O1xuLyoqXG4gKiBJbml0cyBzZWxlY3RvciBsaXN0IHN1YnRyZWUgZm9yIHJlbGF0aXZlIGV4dGVuZGVkIHBzZXVkby1jbGFzc2VzLCBlLmcuIDpoYXMoKSwgOm5vdCgpLlxuICpcbiAqIEBwYXJhbSBjb250ZXh0IFNlbGVjdG9yIHBhcnNlciBjb250ZXh0LlxuICogQHBhcmFtIHRva2VuVmFsdWUgT3B0aW9uYWwsIGRlZmF1bHRzIHRvIGAnJ2AsIHZhbHVlIG9mIGlubmVyIHJlZ3VsYXIgc2VsZWN0b3IuXG4gKi9cblxuY29uc3QgaW5pdFJlbGF0aXZlU3VidHJlZSA9IGZ1bmN0aW9uIChjb250ZXh0KSB7XG4gIGxldCB0b2tlblZhbHVlID0gYXJndW1lbnRzLmxlbmd0aCA+IDEgJiYgYXJndW1lbnRzWzFdICE9PSB1bmRlZmluZWQgPyBhcmd1bWVudHNbMV0gOiAnJztcbiAgYWRkQXN0Tm9kZUJ5VHlwZShjb250ZXh0LCBOT0RFLlNFTEVDVE9SX0xJU1QpO1xuICBhZGRBc3ROb2RlQnlUeXBlKGNvbnRleHQsIE5PREUuU0VMRUNUT1IpO1xuICBhZGRBc3ROb2RlQnlUeXBlKGNvbnRleHQsIE5PREUuUkVHVUxBUl9TRUxFQ1RPUiwgdG9rZW5WYWx1ZSk7XG59O1xuLyoqXG4gKiBHb2VzIHRvIGNsb3Nlc3QgcGFyZW50IHNwZWNpZmllZCBieSB0eXBlLlxuICogQWN0dWFsbHkgdXBkYXRlcyBwYXRoIHRvIGJ1ZmZlciBub2RlIGZvciBwcm9wZXIgYXN0IGNvbGxlY3Rpbmcgb2Ygc2VsZWN0b3JzIHdoaWxlIHBhcnNpbmcuXG4gKlxuICogQHBhcmFtIGNvbnRleHQgU2VsZWN0b3IgcGFyc2VyIGNvbnRleHQuXG4gKiBAcGFyYW0gcGFyZW50VHlwZSBUeXBlIG9mIG5lZWRlZCBwYXJlbnQgbm9kZSBpbiBhc3QuXG4gKi9cblxuY29uc3QgdXBUb0Nsb3Nlc3QgPSAoY29udGV4dCwgcGFyZW50VHlwZSkgPT4ge1xuICBmb3IgKGxldCBpID0gY29udGV4dC5wYXRoVG9CdWZmZXJOb2RlLmxlbmd0aCAtIDE7IGkgPj0gMDsgaSAtPSAxKSB7XG4gICAgdmFyIF9jb250ZXh0JHBhdGhUb0J1ZmZlcjtcblxuICAgIGlmICgoKF9jb250ZXh0JHBhdGhUb0J1ZmZlciA9IGNvbnRleHQucGF0aFRvQnVmZmVyTm9kZVtpXSkgPT09IG51bGwgfHwgX2NvbnRleHQkcGF0aFRvQnVmZmVyID09PSB2b2lkIDAgPyB2b2lkIDAgOiBfY29udGV4dCRwYXRoVG9CdWZmZXIudHlwZSkgPT09IHBhcmVudFR5cGUpIHtcbiAgICAgIGNvbnRleHQucGF0aFRvQnVmZmVyTm9kZSA9IGNvbnRleHQucGF0aFRvQnVmZmVyTm9kZS5zbGljZSgwLCBpICsgMSk7XG4gICAgICBicmVhaztcbiAgICB9XG4gIH1cbn07XG4vKipcbiAqIFJldHVybnMgbmVlZGVkIGJ1ZmZlciBub2RlIHVwZGF0ZWQgZHVlIHRvIGNvbXBsZXggc2VsZWN0b3IgcGFyc2luZy5cbiAqXG4gKiBAcGFyYW0gY29udGV4dCBTZWxlY3RvciBwYXJzZXIgY29udGV4dC5cbiAqXG4gKiBAcmV0dXJucyBBc3Qgbm9kZSBmb3IgZm9sbG93aW5nIHNlbGVjdG9yIHBhcnNpbmcuXG4gKiBAdGhyb3dzIEFuIGVycm9yIGlmIHRoZXJlIGlzIG5vIHVwcGVyIFNlbGVjdG9yTm9kZSBpcyBhc3QuXG4gKi9cblxuY29uc3QgZ2V0VXBkYXRlZEJ1ZmZlck5vZGUgPSBjb250ZXh0ID0+IHtcbiAgLy8gaXQgbWF5IGhhcHBlbiBkdXJpbmcgdGhlIHBhcnNpbmcgb2Ygc2VsZWN0b3IgbGlzdFxuICAvLyB3aGljaCBpcyBhbiBhcmd1bWVudCBvZiByZWxhdGl2ZSBwc2V1ZG8tY2xhc3NcbiAgLy8gZS5nLiAnLmJhbm5lcjpoYXMofnNwYW4sIH5wKSdcbiAgLy8gcGFyc2VyIHBvc2l0aW9uIGlzIGhlcmUgIOKGkVxuICAvLyBzbyBpZiBhZnRlciB0aGUgY29tbWEgdGhlIGJ1ZmZlciBub2RlIHR5cGUgaXMgU2VsZWN0b3JMaXN0IGFuZCBwYXJlbnQgdHlwZSBpcyBSZWxhdGl2ZVBzZXVkb0NsYXNzXG4gIC8vIHdlIHNob3VsZCBzaW1wbHkgcmV0dXJuIHRoZSBjdXJyZW50IGJ1ZmZlciBub2RlXG4gIGNvbnN0IGJ1ZmZlck5vZGUgPSBnZXRCdWZmZXJOb2RlKGNvbnRleHQpO1xuXG4gIGlmIChidWZmZXJOb2RlICYmIGlzU2VsZWN0b3JMaXN0Tm9kZShidWZmZXJOb2RlKSAmJiBpc1JlbGF0aXZlUHNldWRvQ2xhc3NOb2RlKGdldEJ1ZmZlck5vZGVQYXJlbnQoY29udGV4dCkpKSB7XG4gICAgcmV0dXJuIGJ1ZmZlck5vZGU7XG4gIH1cblxuICB1cFRvQ2xvc2VzdChjb250ZXh0LCBOT0RFLlNFTEVDVE9SKTtcbiAgY29uc3Qgc2VsZWN0b3JOb2RlID0gZ2V0QnVmZmVyTm9kZShjb250ZXh0KTtcblxuICBpZiAoIXNlbGVjdG9yTm9kZSkge1xuICAgIHRocm93IG5ldyBFcnJvcignTm8gU2VsZWN0b3JOb2RlLCBpbXBvc3NpYmxlIHRvIGNvbnRpbnVlIHNlbGVjdG9yIHBhcnNpbmcgYnkgRXh0ZW5kZWRDc3MnKTtcbiAgfVxuXG4gIGNvbnN0IGxhc3RTZWxlY3Rvck5vZGVDaGlsZCA9IGdldExhc3Qoc2VsZWN0b3JOb2RlLmNoaWxkcmVuKTtcbiAgY29uc3QgaGFzRXh0ZW5kZWQgPSBsYXN0U2VsZWN0b3JOb2RlQ2hpbGQgJiYgaXNFeHRlbmRlZFNlbGVjdG9yTm9kZShsYXN0U2VsZWN0b3JOb2RlQ2hpbGQpIC8vIHBhcnNlciBwb3NpdGlvbiBtaWdodCBiZSBpbnNpZGUgc3RhbmRhcmQgcHNldWRvLWNsYXNzIGJyYWNrZXRzIHdoaWNoIGhhcyBzcGFjZVxuICAvLyBlLmcuICdkaXY6Y29udGFpbnMoL9CwLyk6bnRoLWNoaWxkKDEwMG4gKyAyKSdcbiAgJiYgY29udGV4dC5zdGFuZGFyZFBzZXVkb0JyYWNrZXRzU3RhY2subGVuZ3RoID09PSAwO1xuICBjb25zdCBzdXBwb3NlZFBzZXVkb0NsYXNzTm9kZSA9IGhhc0V4dGVuZGVkICYmIGdldEZpcnN0KGxhc3RTZWxlY3Rvck5vZGVDaGlsZC5jaGlsZHJlbik7XG4gIGxldCBuZXdOZWVkZWRCdWZmZXJOb2RlID0gc2VsZWN0b3JOb2RlO1xuXG4gIGlmIChzdXBwb3NlZFBzZXVkb0NsYXNzTm9kZSkge1xuICAgIC8vIG5hbWUgb2YgcHNldWRvLWNsYXNzIGZvciBsYXN0IGV4dGVuZGVkLW5vZGUgY2hpbGQgZm9yIFNlbGVjdG9yIG5vZGVcbiAgICBjb25zdCBsYXN0RXh0ZW5kZWRQc2V1ZG9OYW1lID0gaGFzRXh0ZW5kZWQgJiYgc3VwcG9zZWRQc2V1ZG9DbGFzc05vZGUubmFtZTtcbiAgICBjb25zdCBpc0xhc3RFeHRlbmRlZE5hbWVSZWxhdGl2ZSA9IGxhc3RFeHRlbmRlZFBzZXVkb05hbWUgJiYgaXNSZWxhdGl2ZVBzZXVkb0NsYXNzKGxhc3RFeHRlbmRlZFBzZXVkb05hbWUpO1xuICAgIGNvbnN0IGlzTGFzdEV4dGVuZGVkTmFtZUFic29sdXRlID0gbGFzdEV4dGVuZGVkUHNldWRvTmFtZSAmJiBpc0Fic29sdXRlUHNldWRvQ2xhc3MobGFzdEV4dGVuZGVkUHNldWRvTmFtZSk7XG4gICAgY29uc3QgaGFzUmVsYXRpdmVFeHRlbmRlZCA9IGlzTGFzdEV4dGVuZGVkTmFtZVJlbGF0aXZlICYmIGNvbnRleHQuZXh0ZW5kZWRQc2V1ZG9CcmFja2V0c1N0YWNrLmxlbmd0aCA+IDAgJiYgY29udGV4dC5leHRlbmRlZFBzZXVkb0JyYWNrZXRzU3RhY2subGVuZ3RoID09PSBjb250ZXh0LmV4dGVuZGVkUHNldWRvTmFtZXNTdGFjay5sZW5ndGg7XG4gICAgY29uc3QgaGFzQWJzb2x1dGVFeHRlbmRlZCA9IGlzTGFzdEV4dGVuZGVkTmFtZUFic29sdXRlICYmIGxhc3RFeHRlbmRlZFBzZXVkb05hbWUgPT09IGdldExhc3QoY29udGV4dC5leHRlbmRlZFBzZXVkb05hbWVzU3RhY2spO1xuXG4gICAgaWYgKGhhc1JlbGF0aXZlRXh0ZW5kZWQpIHtcbiAgICAgIC8vIHJldHVybiByZWxhdGl2ZSBzZWxlY3RvciBub2RlIHRvIHVwZGF0ZSBsYXRlclxuICAgICAgY29udGV4dC5wYXRoVG9CdWZmZXJOb2RlLnB1c2gobGFzdFNlbGVjdG9yTm9kZUNoaWxkKTtcbiAgICAgIG5ld05lZWRlZEJ1ZmZlck5vZGUgPSBzdXBwb3NlZFBzZXVkb0NsYXNzTm9kZTtcbiAgICB9IGVsc2UgaWYgKGhhc0Fic29sdXRlRXh0ZW5kZWQpIHtcbiAgICAgIC8vIHJldHVybiBhYnNvbHV0ZSBzZWxlY3RvciBub2RlIHRvIHVwZGF0ZSBsYXRlclxuICAgICAgY29udGV4dC5wYXRoVG9CdWZmZXJOb2RlLnB1c2gobGFzdFNlbGVjdG9yTm9kZUNoaWxkKTtcbiAgICAgIG5ld05lZWRlZEJ1ZmZlck5vZGUgPSBzdXBwb3NlZFBzZXVkb0NsYXNzTm9kZTtcbiAgICB9XG4gIH0gZWxzZSBpZiAoaGFzRXh0ZW5kZWQpIHtcbiAgICAvLyByZXR1cm4gc2VsZWN0b3Igbm9kZSB0byBhZGQgbmV3IHJlZ3VsYXIgc2VsZWN0b3Igbm9kZSBsYXRlclxuICAgIG5ld05lZWRlZEJ1ZmZlck5vZGUgPSBzZWxlY3Rvck5vZGU7XG4gIH0gZWxzZSB7XG4gICAgLy8gb3RoZXJ3aXNlIHJldHVybiBsYXN0IHJlZ3VsYXIgc2VsZWN0b3Igbm9kZSB0byB1cGRhdGUgbGF0ZXJcbiAgICBuZXdOZWVkZWRCdWZmZXJOb2RlID0gZ2V0Q29udGV4dExhc3RSZWd1bGFyU2VsZWN0b3JOb2RlKGNvbnRleHQpO1xuICB9IC8vIHVwZGF0ZSB0aGUgcGF0aCB0byBidWZmZXIgbm9kZSBwcm9wZXJseVxuXG5cbiAgY29udGV4dC5wYXRoVG9CdWZmZXJOb2RlLnB1c2gobmV3TmVlZGVkQnVmZmVyTm9kZSk7XG4gIHJldHVybiBuZXdOZWVkZWRCdWZmZXJOb2RlO1xufTtcbi8qKlxuICogQ2hlY2tzIHZhbHVlcyBvZiBmZXcgbmV4dCB0b2tlbnMgb24gY29sb24gdG9rZW4gYDpgIGFuZDpcbiAqICAtIHVwZGF0ZXMgYnVmZmVyIG5vZGUgZm9yIGZvbGxvd2luZyBzdGFuZGFyZCBwc2V1ZG8tY2xhc3M7XG4gKiAgLSBhZGRzIGV4dGVuZGVkIHNlbGVjdG9yIGFzdCBub2RlIGZvciBmb2xsb3dpbmcgZXh0ZW5kZWQgcHNldWRvLWNsYXNzO1xuICogIC0gdmFsaWRhdGVzIHNvbWUgY2FzZXMgb2YgYDpyZW1vdmUoKWAgYW5kIGA6aGFzKClgIHVzYWdlLlxuICpcbiAqIEBwYXJhbSBjb250ZXh0IFNlbGVjdG9yIHBhcnNlciBjb250ZXh0LlxuICogQHBhcmFtIHNlbGVjdG9yIFNlbGVjdG9yLlxuICogQHBhcmFtIHRva2VuVmFsdWUgVmFsdWUgb2YgY3VycmVudCB0b2tlbi5cbiAqIEBwYXJhbSBuZXh0VG9rZW5WYWx1ZSBWYWx1ZSBvZiB0b2tlbiBuZXh0IHRvIGN1cnJlbnQgb25lLlxuICogQHBhcmFtIG5leHRUb05leHRUb2tlblZhbHVlIFZhbHVlIG9mIHRva2VuIG5leHQgdG8gbmV4dCB0byBjdXJyZW50IG9uZS5cbiAqXG4gKiBAdGhyb3dzIEFuIGVycm9yIG9uIDpyZW1vdmUoKSBwc2V1ZG8tY2xhc3MgaW4gc2VsZWN0b3JcbiAqIG9yIDpoYXMoKSBpbnNpZGUgcmVndWxhciBwc2V1ZG8gbGltaXRhdGlvbi5cbiAqL1xuXG5jb25zdCBoYW5kbGVOZXh0VG9rZW5PbkNvbG9uID0gKGNvbnRleHQsIHNlbGVjdG9yLCB0b2tlblZhbHVlLCBuZXh0VG9rZW5WYWx1ZSwgbmV4dFRvTmV4dFRva2VuVmFsdWUpID0+IHtcbiAgaWYgKCFuZXh0VG9rZW5WYWx1ZSkge1xuICAgIHRocm93IG5ldyBFcnJvcihgSW52YWxpZCBjb2xvbiAnOicgYXQgdGhlIGVuZCBvZiBzZWxlY3RvcjogJyR7c2VsZWN0b3J9J2ApO1xuICB9XG5cbiAgaWYgKCFpc1N1cHBvcnRlZFBzZXVkb0NsYXNzKG5leHRUb2tlblZhbHVlLnRvTG93ZXJDYXNlKCkpKSB7XG4gICAgaWYgKG5leHRUb2tlblZhbHVlLnRvTG93ZXJDYXNlKCkgPT09IFJFTU9WRV9QU0VVRE9fTUFSS0VSKSB7XG4gICAgICAvLyA6cmVtb3ZlKCkgcHNldWRvLWNsYXNzIHNob3VsZCBiZSBoYW5kbGVkIGJlZm9yZVxuICAgICAgLy8gYXMgaXQgaXMgbm90IGFib3V0IGVsZW1lbnQgc2VsZWN0aW5nIGJ1dCBhY3Rpb25zIHdpdGggZWxlbWVudHNcbiAgICAgIC8vIGUuZy4gJ2JvZHkgPiBkaXY6ZW1wdHk6cmVtb3ZlKCknXG4gICAgICB0aHJvdyBuZXcgRXJyb3IoYCR7UkVNT1ZFX0VSUk9SX1BSRUZJWC5JTlZBTElEX1JFTU9WRX06ICcke3NlbGVjdG9yfSdgKTtcbiAgICB9IC8vIGlmIGZvbGxvd2luZyB0b2tlbiBpcyBub3QgYW4gZXh0ZW5kZWQgcHNldWRvXG4gICAgLy8gdGhlIGNvbG9uIHNob3VsZCBiZSBjb2xsZWN0ZWQgdG8gdmFsdWUgb2YgUmVndWxhclNlbGVjdG9yXG4gICAgLy8gZS5nLiAnLmVudHJ5X3RleHQ6bnRoLWNoaWxkKDIpJ1xuXG5cbiAgICB1cGRhdGVCdWZmZXJOb2RlKGNvbnRleHQsIHRva2VuVmFsdWUpOyAvLyBjaGVjayB0aGUgdG9rZW4gYWZ0ZXIgdGhlIHBzZXVkbyBhbmQgZG8gYmFsYW5jZSBwYXJlbnRoZXNlcyBsYXRlclxuICAgIC8vIG9ubHkgaWYgaXQgaXMgZnVuY3Rpb25hbCBwc2V1ZG8tY2xhc3MgKHN0YW5kYXJkIHdpdGggYnJhY2tldHMsIGUuZy4gJzpsYW5nKCknKS5cbiAgICAvLyBubyBicmFja2V0cyBiYWxhbmNlIG5lZWRlZCBmb3Igc3VjaCBjYXNlLFxuICAgIC8vIHBhcnNlciBwb3NpdGlvbiBpcyBvbiBmaXJzdCBjb2xvbiBhZnRlciB0aGUgJ2Rpdic6XG4gICAgLy8gZS5nLiAnZGl2Omxhc3QtY2hpbGQ6aGFzKGJ1dHRvbi5wcml2YWN5LXBvbGljeV9fYnRuKSdcblxuICAgIGlmIChuZXh0VG9OZXh0VG9rZW5WYWx1ZSAmJiBuZXh0VG9OZXh0VG9rZW5WYWx1ZSA9PT0gQlJBQ0tFVC5QQVJFTlRIRVNFUy5MRUZUIC8vIG5vIGJyYWNrZXRzIGJhbGFuY2UgbmVlZGVkIGZvciBwYXJlbnRoZXNlcyBpbnNpZGUgYXR0cmlidXRlIHZhbHVlXG4gICAgLy8gZS5nLiAnYVtocmVmPVwiamF2YXNjcmlwdDp2b2lkKDApXCJdJyAgIDwtLSBwYXJzZXIgcG9zaXRpb24gaXMgb24gY29sb24gYDpgXG4gICAgLy8gYmVmb3JlIGB2b2lkYCAgICAgICAgICAg4oaRXG4gICAgJiYgIWNvbnRleHQuaXNBdHRyaWJ1dGVCcmFja2V0c09wZW4pIHtcbiAgICAgIGNvbnRleHQuc3RhbmRhcmRQc2V1ZG9OYW1lc1N0YWNrLnB1c2gobmV4dFRva2VuVmFsdWUpO1xuICAgIH1cbiAgfSBlbHNlIHtcbiAgICAvLyBpdCBpcyBzdXBwb3J0ZWQgZXh0ZW5kZWQgcHNldWRvLWNsYXNzLlxuICAgIC8vIERpc2FsbG93IDpoYXMoKSBpbnNpZGUgdGhlIHBzZXVkb3MgYWNjZXB0aW5nIG9ubHkgY29tcG91bmQgc2VsZWN0b3JzXG4gICAgLy8gaHR0cHM6Ly9idWdzLmNocm9taXVtLm9yZy9wL2Nocm9taXVtL2lzc3Vlcy9kZXRhaWw/aWQ9NjY5MDU4I2M1NCBbMl1cbiAgICBpZiAoSEFTX1BTRVVET19DTEFTU19NQVJLRVJTLmluY2x1ZGVzKG5leHRUb2tlblZhbHVlKSAmJiBjb250ZXh0LnN0YW5kYXJkUHNldWRvTmFtZXNTdGFjay5sZW5ndGggPiAwKSB7XG4gICAgICAvLyBlc2xpbnQtZGlzYWJsZS1uZXh0LWxpbmUgbWF4LWxlblxuICAgICAgdGhyb3cgbmV3IEVycm9yKGBVc2FnZSBvZiA6JHtuZXh0VG9rZW5WYWx1ZX0oKSBwc2V1ZG8tY2xhc3MgaXMgbm90IGFsbG93ZWQgaW5zaWRlIHJlZ3VsYXIgcHNldWRvOiAnJHtnZXRMYXN0KGNvbnRleHQuc3RhbmRhcmRQc2V1ZG9OYW1lc1N0YWNrKX0nYCk7XG4gICAgfSBlbHNlIHtcbiAgICAgIC8vIHN0b3AgUmVndWxhclNlbGVjdG9yIHZhbHVlIGNvbGxlY3RpbmdcbiAgICAgIHVwVG9DbG9zZXN0KGNvbnRleHQsIE5PREUuU0VMRUNUT1IpOyAvLyBhZGQgRXh0ZW5kZWRTZWxlY3RvciB0byBTZWxlY3RvciBjaGlsZHJlblxuXG4gICAgICBhZGRBc3ROb2RlQnlUeXBlKGNvbnRleHQsIE5PREUuRVhURU5ERURfU0VMRUNUT1IpO1xuICAgIH1cbiAgfVxufTtcblxuLy8gZS5nLiAnOmlzKC5wYWdlLCAubWFpbikgPiAuYmFubmVyJyBvciAnKjpub3Qoc3Bhbik6bm90KHApJ1xuXG5jb25zdCBJU19PUl9OT1RfUFNFVURPX1NFTEVDVElOR19ST09UID0gYGh0bWwgJHtBU1RFUklTS31gO1xuLyoqXG4gKiBDaGVja3MgaWYgdGhlcmUgYXJlIGFueSBFeHRlbmRlZFNlbGVjdG9yIG5vZGUgaW4gc2VsZWN0b3IgbGlzdC5cbiAqXG4gKiBAcGFyYW0gc2VsZWN0b3JMaXN0IEFzdCBTZWxlY3Rvckxpc3Qgbm9kZS5cbiAqXG4gKiBAcmV0dXJucyBUcnVlIGlmIGBzZWxlY3Rvckxpc3RgIGhhcyBhbnkgaW5uZXIgRXh0ZW5kZWRTZWxlY3RvciBub2RlLlxuICovXG5cbmNvbnN0IGhhc0V4dGVuZGVkU2VsZWN0b3IgPSBzZWxlY3Rvckxpc3QgPT4ge1xuICByZXR1cm4gc2VsZWN0b3JMaXN0LmNoaWxkcmVuLnNvbWUoc2VsZWN0b3JOb2RlID0+IHtcbiAgICByZXR1cm4gc2VsZWN0b3JOb2RlLmNoaWxkcmVuLnNvbWUoc2VsZWN0b3JOb2RlQ2hpbGQgPT4ge1xuICAgICAgcmV0dXJuIGlzRXh0ZW5kZWRTZWxlY3Rvck5vZGUoc2VsZWN0b3JOb2RlQ2hpbGQpO1xuICAgIH0pO1xuICB9KTtcbn07XG4vKipcbiAqIENvbnZlcnRzIHNlbGVjdG9yIGxpc3Qgb2YgUmVndWxhclNlbGVjdG9yIG5vZGVzIHRvIHN0cmluZy5cbiAqXG4gKiBAcGFyYW0gc2VsZWN0b3JMaXN0IEFzdCBTZWxlY3Rvckxpc3Qgbm9kZS5cbiAqXG4gKiBAcmV0dXJucyBTdHJpbmcgcmVwcmVzZW50YXRpb24gZm9yIHNlbGVjdG9yIGxpc3Qgb2YgcmVndWxhciBzZWxlY3RvcnMuXG4gKi9cblxuXG5jb25zdCBzZWxlY3Rvckxpc3RPZlJlZ3VsYXJzVG9TdHJpbmcgPSBzZWxlY3Rvckxpc3QgPT4ge1xuICAvLyBpZiB0aGVyZSBpcyBubyBFeHRlbmRlZFNlbGVjdG9yIGluIHJlbGF0aXZlIFNlbGVjdG9yTGlzdFxuICAvLyBpdCBtZWFucyB0aGF0IGVhY2ggU2VsZWN0b3Igbm9kZSBoYXMgc2luZ2xlIGNoaWxkIOKAlCBSZWd1bGFyU2VsZWN0b3Igbm9kZVxuICAvLyBhbmQgdGhlaXIgdmFsdWVzIHNob3VsZCBiZSBjb21iaW5lZCB0byBzdHJpbmdcbiAgY29uc3Qgc3RhbmRhcmRDc3NTZWxlY3RvcnMgPSBzZWxlY3Rvckxpc3QuY2hpbGRyZW4ubWFwKHNlbGVjdG9yTm9kZSA9PiB7XG4gICAgY29uc3Qgc2VsZWN0b3JPbmx5Q2hpbGQgPSBnZXROb2RlT25seUNoaWxkKHNlbGVjdG9yTm9kZSwgJ0FzdCBTZWxlY3RvciBub2RlIHNob3VsZCBoYXZlIFJlZ3VsYXJTZWxlY3RvciBub2RlJyk7XG4gICAgcmV0dXJuIGdldE5vZGVWYWx1ZShzZWxlY3Rvck9ubHlDaGlsZCk7XG4gIH0pO1xuICByZXR1cm4gc3RhbmRhcmRDc3NTZWxlY3RvcnMuam9pbihgJHtDT01NQX0ke1NQQUNFfWApO1xufTtcbi8qKlxuICogVXBkYXRlcyBjaGlsZHJlbiBvZiBgbm9kZWAgcmVwbGFjaW5nIHRoZW0gd2l0aCBgbmV3Q2hpbGRyZW5gLlxuICogSW1wb3J0YW50OiBtb2RpZmllcyBpbnB1dCBgbm9kZWAgd2hpY2ggaXMgcGFzc2VkIGJ5IHJlZmVyZW5jZS5cbiAqXG4gKiBAcGFyYW0gbm9kZSBBc3Qgbm9kZSB0byB1cGRhdGUuXG4gKiBAcGFyYW0gbmV3Q2hpbGRyZW4gQXJyYXkgb2YgbmV3IGNoaWxkcmVuIGZvciBhc3Qgbm9kZS5cbiAqXG4gKiBAcmV0dXJucyBVcGRhdGVkIGFzdCBub2RlLlxuICovXG5cblxuY29uc3QgdXBkYXRlTm9kZUNoaWxkcmVuID0gKG5vZGUsIG5ld0NoaWxkcmVuKSA9PiB7XG4gIG5vZGUuY2hpbGRyZW4gPSBuZXdDaGlsZHJlbjtcbiAgcmV0dXJuIG5vZGU7XG59O1xuLyoqXG4gKiBSZWN1cnNpdmVseSBjaGVja3Mgd2hldGhlciB0aGUgRXh0ZW5kZWRTZWxlY3RvciBub2RlIHNob3VsZCBiZSBvcHRpbWl6ZWQuXG4gKiBJdCBoYXMgdG8gYmUgcmVjdXJzaXZlIGJlY2F1c2UgUmVsYXRpdmVQc2V1ZG9DbGFzcyBoYXMgaW5uZXIgU2VsZWN0b3JMaXN0IG5vZGUuXG4gKlxuICogQHBhcmFtIGN1cnJFeHRlbmRlZFNlbGVjdG9yTm9kZSBBc3QgRXh0ZW5kZWRTZWxlY3RvciBub2RlLlxuICpcbiAqIEByZXR1cm5zIFRydWUgaXMgRXh0ZW5kZWRTZWxlY3RvciBzaG91bGQgYmUgb3B0aW1pemVkLlxuICovXG5cblxuY29uc3Qgc2hvdWxkT3B0aW1pemVFeHRlbmRlZFNlbGVjdG9yID0gY3VyckV4dGVuZGVkU2VsZWN0b3JOb2RlID0+IHtcbiAgaWYgKGN1cnJFeHRlbmRlZFNlbGVjdG9yTm9kZSA9PT0gbnVsbCkge1xuICAgIHJldHVybiBmYWxzZTtcbiAgfVxuXG4gIGNvbnN0IGV4dGVuZGVkUHNldWRvQ2xhc3NOb2RlID0gZ2V0UHNldWRvQ2xhc3NOb2RlKGN1cnJFeHRlbmRlZFNlbGVjdG9yTm9kZSk7XG4gIGNvbnN0IHBzZXVkb05hbWUgPSBnZXROb2RlTmFtZShleHRlbmRlZFBzZXVkb0NsYXNzTm9kZSk7XG5cbiAgaWYgKGlzQWJzb2x1dGVQc2V1ZG9DbGFzcyhwc2V1ZG9OYW1lKSkge1xuICAgIHJldHVybiBmYWxzZTtcbiAgfVxuXG4gIGNvbnN0IHJlbGF0aXZlU2VsZWN0b3JMaXN0ID0gZ2V0UmVsYXRpdmVTZWxlY3Rvckxpc3ROb2RlKGV4dGVuZGVkUHNldWRvQ2xhc3NOb2RlKTtcbiAgY29uc3QgaW5uZXJTZWxlY3Rvck5vZGVzID0gcmVsYXRpdmVTZWxlY3Rvckxpc3QuY2hpbGRyZW47IC8vIHNpbXBsZSBjaGVja2luZyBmb3Igc3RhbmRhcmQgc2VsZWN0b3JzIGluIGFyZyBvZiA6bm90KCkgb3IgOmlzKCkgcHNldWRvLWNsYXNzXG4gIC8vIGUuZy4gJ2RpdiA+ICo6aXMoZGl2LCBhLCBzcGFuKSdcblxuICBpZiAoaXNPcHRpbWl6YXRpb25Qc2V1ZG9DbGFzcyhwc2V1ZG9OYW1lKSkge1xuICAgIGNvbnN0IGFyZUFsbFNlbGVjdG9yTm9kZUNoaWxkcmVuUmVndWxhciA9IGlubmVyU2VsZWN0b3JOb2Rlcy5ldmVyeShzZWxlY3Rvck5vZGUgPT4ge1xuICAgICAgdHJ5IHtcbiAgICAgICAgY29uc3Qgc2VsZWN0b3JPbmx5Q2hpbGQgPSBnZXROb2RlT25seUNoaWxkKHNlbGVjdG9yTm9kZSwgJ1NlbGVjdG9yIG5vZGUgc2hvdWxkIGhhdmUgUmVndWxhclNlbGVjdG9yJyk7IC8vIGl0IG1lYW5zIHRoYXQgdGhlIG9ubHkgY2hpbGQgaXMgUmVndWxhclNlbGVjdG9yIGFuZCBpdCBjYW4gYmUgb3B0aW1pemVkXG5cbiAgICAgICAgcmV0dXJuIGlzUmVndWxhclNlbGVjdG9yTm9kZShzZWxlY3Rvck9ubHlDaGlsZCk7XG4gICAgICB9IGNhdGNoIChlKSB7XG4gICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgIH1cbiAgICB9KTtcblxuICAgIGlmIChhcmVBbGxTZWxlY3Rvck5vZGVDaGlsZHJlblJlZ3VsYXIpIHtcbiAgICAgIHJldHVybiB0cnVlO1xuICAgIH1cbiAgfSAvLyBmb3Igb3RoZXIgZXh0ZW5kZWQgcHNldWRvLWNsYXNzZXMgdGhhbiA6bm90KCkgYW5kIDppcygpXG5cblxuICByZXR1cm4gaW5uZXJTZWxlY3Rvck5vZGVzLnNvbWUoc2VsZWN0b3JOb2RlID0+IHtcbiAgICByZXR1cm4gc2VsZWN0b3JOb2RlLmNoaWxkcmVuLnNvbWUoc2VsZWN0b3JOb2RlQ2hpbGQgPT4ge1xuICAgICAgaWYgKCFpc0V4dGVuZGVkU2VsZWN0b3JOb2RlKHNlbGVjdG9yTm9kZUNoaWxkKSkge1xuICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICB9IC8vIGNoZWNrIGlubmVyIEV4dGVuZGVkU2VsZWN0b3IgcmVjdXJzaXZlbHlcbiAgICAgIC8vIGUuZy4gJ2RpdjpoYXMoKjpub3QoLmhlYWRlcikpJ1xuXG5cbiAgICAgIHJldHVybiBzaG91bGRPcHRpbWl6ZUV4dGVuZGVkU2VsZWN0b3Ioc2VsZWN0b3JOb2RlQ2hpbGQpO1xuICAgIH0pO1xuICB9KTtcbn07XG4vKipcbiAqIFJldHVybnMgb3B0aW1pemVkIEV4dGVuZGVkU2VsZWN0b3Igbm9kZSBpZiBpdCBjYW4gYmUgb3B0aW1pemVkXG4gKiBvciBudWxsIGlmIEV4dGVuZGVkU2VsZWN0b3IgaXMgZnVsbHkgb3B0aW1pemVkIHdoaWxlIGZ1bmN0aW9uIGV4ZWN1dGlvblxuICogd2hpY2ggbWVhbnMgdGhhdCB2YWx1ZSBvZiBgcHJldlJlZ3VsYXJTZWxlY3Rvck5vZGVgIGlzIHVwZGF0ZWQuXG4gKlxuICogQHBhcmFtIGN1cnJFeHRlbmRlZFNlbGVjdG9yTm9kZSBDdXJyZW50IEV4dGVuZGVkU2VsZWN0b3Igbm9kZSB0byBvcHRpbWl6ZS5cbiAqIEBwYXJhbSBwcmV2UmVndWxhclNlbGVjdG9yTm9kZSBQcmV2aW91cyBSZWd1bGFyU2VsZWN0b3Igbm9kZS5cbiAqXG4gKiBAcmV0dXJucyBBc3Qgbm9kZSBvciBudWxsLlxuICovXG5cblxuY29uc3QgZ2V0T3B0aW1pemVkRXh0ZW5kZWRTZWxlY3RvciA9IChjdXJyRXh0ZW5kZWRTZWxlY3Rvck5vZGUsIHByZXZSZWd1bGFyU2VsZWN0b3JOb2RlKSA9PiB7XG4gIGlmICghY3VyckV4dGVuZGVkU2VsZWN0b3JOb2RlKSB7XG4gICAgcmV0dXJuIG51bGw7XG4gIH1cblxuICBjb25zdCBleHRlbmRlZFBzZXVkb0NsYXNzTm9kZSA9IGdldFBzZXVkb0NsYXNzTm9kZShjdXJyRXh0ZW5kZWRTZWxlY3Rvck5vZGUpO1xuICBjb25zdCByZWxhdGl2ZVNlbGVjdG9yTGlzdCA9IGdldFJlbGF0aXZlU2VsZWN0b3JMaXN0Tm9kZShleHRlbmRlZFBzZXVkb0NsYXNzTm9kZSk7XG4gIGNvbnN0IGhhc0lubmVyRXh0ZW5kZWRTZWxlY3RvciA9IGhhc0V4dGVuZGVkU2VsZWN0b3IocmVsYXRpdmVTZWxlY3Rvckxpc3QpO1xuXG4gIGlmICghaGFzSW5uZXJFeHRlbmRlZFNlbGVjdG9yKSB7XG4gICAgLy8gaWYgdGhlcmUgaXMgbm8gZXh0ZW5kZWQgc2VsZWN0b3JzIGZvciA6bm90KCkgb3IgOmlzKClcbiAgICAvLyBlLmcuICdkaXY6bm90KC5jb250ZW50LCAubWFpbiknXG4gICAgY29uc3QgcmVsYXRpdmVTZWxlY3Rvckxpc3RTdHIgPSBzZWxlY3Rvckxpc3RPZlJlZ3VsYXJzVG9TdHJpbmcocmVsYXRpdmVTZWxlY3Rvckxpc3QpO1xuICAgIGNvbnN0IHBzZXVkb05hbWUgPSBnZXROb2RlTmFtZShleHRlbmRlZFBzZXVkb0NsYXNzTm9kZSk7IC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBtYXgtbGVuXG5cbiAgICBjb25zdCBvcHRpbWl6ZWRFeHRlbmRlZFN0ciA9IGAke0NPTE9OfSR7cHNldWRvTmFtZX0ke0JSQUNLRVQuUEFSRU5USEVTRVMuTEVGVH0ke3JlbGF0aXZlU2VsZWN0b3JMaXN0U3RyfSR7QlJBQ0tFVC5QQVJFTlRIRVNFUy5SSUdIVH1gO1xuICAgIHByZXZSZWd1bGFyU2VsZWN0b3JOb2RlLnZhbHVlID0gYCR7Z2V0Tm9kZVZhbHVlKHByZXZSZWd1bGFyU2VsZWN0b3JOb2RlKX0ke29wdGltaXplZEV4dGVuZGVkU3RyfWA7XG4gICAgcmV0dXJuIG51bGw7XG4gIH0gLy8gZXNsaW50LWRpc2FibGUtbmV4dC1saW5lIEB0eXBlc2NyaXB0LWVzbGludC9uby11c2UtYmVmb3JlLWRlZmluZVxuXG5cbiAgY29uc3Qgb3B0aW1pemVkUmVsYXRpdmVTZWxlY3Rvckxpc3QgPSBvcHRpbWl6ZVNlbGVjdG9yTGlzdE5vZGUocmVsYXRpdmVTZWxlY3Rvckxpc3QpO1xuICBjb25zdCBvcHRpbWl6ZWRFeHRlbmRlZFBzZXVkb0NsYXNzTm9kZSA9IHVwZGF0ZU5vZGVDaGlsZHJlbihleHRlbmRlZFBzZXVkb0NsYXNzTm9kZSwgW29wdGltaXplZFJlbGF0aXZlU2VsZWN0b3JMaXN0XSk7XG4gIHJldHVybiB1cGRhdGVOb2RlQ2hpbGRyZW4oY3VyckV4dGVuZGVkU2VsZWN0b3JOb2RlLCBbb3B0aW1pemVkRXh0ZW5kZWRQc2V1ZG9DbGFzc05vZGVdKTtcbn07XG4vKipcbiAqIENvbWJpbmVzIHZhbHVlcyBvZiBgcHJldmlvdXNgIGFuZCBgY3VycmVudGAgUmVndWxhclNlbGVjdG9yIG5vZGVzLlxuICogSXQgbWF5IGhhcHBlbiBkdXJpbmcgdGhlIG9wdGltaXphdGlvbiB3aGVuIEV4dGVuZGVkU2VsZWN0b3IgYmV0d2VlbiBSZWd1bGFyU2VsZWN0b3Igbm9kZSB3YXMgb3B0aW1pemVkLlxuICpcbiAqIEBwYXJhbSBjdXJyZW50IEN1cnJlbnQgUmVndWxhclNlbGVjdG9yIG5vZGUuXG4gKiBAcGFyYW0gcHJldmlvdXMgUHJldmlvdXMgUmVndWxhclNlbGVjdG9yIG5vZGUuXG4gKi9cblxuXG5jb25zdCBvcHRpbWl6ZUN1cnJlbnRSZWd1bGFyU2VsZWN0b3IgPSAoY3VycmVudCwgcHJldmlvdXMpID0+IHtcbiAgcHJldmlvdXMudmFsdWUgPSBgJHtnZXROb2RlVmFsdWUocHJldmlvdXMpfSR7U1BBQ0V9JHtnZXROb2RlVmFsdWUoY3VycmVudCl9YDtcbn07XG4vKipcbiAqIE9wdGltaXplcyBhc3QgU2VsZWN0b3Igbm9kZS5cbiAqXG4gKiBAcGFyYW0gc2VsZWN0b3JOb2RlIEFzdCBTZWxlY3RvciBub2RlLlxuICpcbiAqIEByZXR1cm5zIE9wdGltaXplZCBhc3Qgbm9kZS5cbiAqIEB0aHJvd3MgQW4gZXJyb3Igd2hpbGUgY29sbGVjdGluZyBvcHRpbWl6ZWQgbm9kZXMuXG4gKi9cblxuXG5jb25zdCBvcHRpbWl6ZVNlbGVjdG9yTm9kZSA9IHNlbGVjdG9yTm9kZSA9PiB7XG4gIC8vIG5vbi1vcHRpbWl6ZWQgbGlzdCBvZiBTZWxlY3Rvck5vZGUgY2hpbGRyZW5cbiAgY29uc3QgcmF3U2VsZWN0b3JOb2RlQ2hpbGRyZW4gPSBzZWxlY3Rvck5vZGUuY2hpbGRyZW47IC8vIGZvciBjb2xsZWN0aW5nIG9wdGltaXplZCBjaGlsZHJlbiBsaXN0XG5cbiAgY29uc3Qgb3B0aW1pemVkQ2hpbGRyZW5MaXN0ID0gW107XG4gIGxldCBjdXJyZW50SW5kZXggPSAwOyAvLyBpdGVyYXRlIHRocm91Z2ggYWxsIGNoaWxkcmVuIGluIG5vbi1vcHRpbWl6ZWQgYXN0IFNlbGVjdG9yIG5vZGVcblxuICB3aGlsZSAoY3VycmVudEluZGV4IDwgcmF3U2VsZWN0b3JOb2RlQ2hpbGRyZW4ubGVuZ3RoKSB7XG4gICAgY29uc3QgY3VycmVudENoaWxkID0gZ2V0SXRlbUJ5SW5kZXgocmF3U2VsZWN0b3JOb2RlQ2hpbGRyZW4sIGN1cnJlbnRJbmRleCwgJ2N1cnJlbnRDaGlsZCBzaG91bGQgYmUgc3BlY2lmaWVkJyk7IC8vIG5vIG5lZWQgdG8gb3B0aW1pemUgdGhlIHZlcnkgZmlyc3QgY2hpbGQgd2hpY2ggaXMgYWx3YXlzIFJlZ3VsYXJTZWxlY3RvciBub2RlXG5cbiAgICBpZiAoY3VycmVudEluZGV4ID09PSAwKSB7XG4gICAgICBvcHRpbWl6ZWRDaGlsZHJlbkxpc3QucHVzaChjdXJyZW50Q2hpbGQpO1xuICAgIH0gZWxzZSB7XG4gICAgICBjb25zdCBwcmV2UmVndWxhckNoaWxkID0gZ2V0TGFzdFJlZ3VsYXJDaGlsZChvcHRpbWl6ZWRDaGlsZHJlbkxpc3QpO1xuXG4gICAgICBpZiAoaXNFeHRlbmRlZFNlbGVjdG9yTm9kZShjdXJyZW50Q2hpbGQpKSB7XG4gICAgICAgIC8vIHN0YXJ0IGNoZWNraW5nIHdpdGggcG9pbnQgaXMgbnVsbFxuICAgICAgICBsZXQgb3B0aW1pemVkRXh0ZW5kZWRTZWxlY3RvciA9IG51bGw7IC8vIGNoZWNrIHdoZXRoZXIgdGhlIG9wdGltaXphdGlvbiBpcyBuZWVkZWRcblxuICAgICAgICBsZXQgaXNPcHRpbWl6YXRpb25OZWVkZWQgPSBzaG91bGRPcHRpbWl6ZUV4dGVuZGVkU2VsZWN0b3IoY3VycmVudENoaWxkKTsgLy8gdXBkYXRlIG9wdGltaXplZEV4dGVuZGVkU2VsZWN0b3Igc28gaXQgY2FuIGJlIG9wdGltaXplZCByZWN1cnNpdmVseVxuICAgICAgICAvLyBpLmUuIGBnZXRPcHRpbWl6ZWRFeHRlbmRlZFNlbGVjdG9yKG9wdGltaXplZEV4dGVuZGVkU2VsZWN0b3IpYCBiZWxvd1xuXG4gICAgICAgIG9wdGltaXplZEV4dGVuZGVkU2VsZWN0b3IgPSBjdXJyZW50Q2hpbGQ7XG5cbiAgICAgICAgd2hpbGUgKGlzT3B0aW1pemF0aW9uTmVlZGVkKSB7XG4gICAgICAgICAgLy8gcmVjdXJzaXZlbHkgb3B0aW1pemUgRXh0ZW5kZWRTZWxlY3RvciB1bnRpbCBubyBvcHRpbWl6YXRpb24gbmVlZGVkXG4gICAgICAgICAgLy8gZS5nLiBkaXYgPiAqOmlzKC5iYW5uZXI6bm90KC5ibG9jaykpXG4gICAgICAgICAgb3B0aW1pemVkRXh0ZW5kZWRTZWxlY3RvciA9IGdldE9wdGltaXplZEV4dGVuZGVkU2VsZWN0b3Iob3B0aW1pemVkRXh0ZW5kZWRTZWxlY3RvciwgcHJldlJlZ3VsYXJDaGlsZCk7XG4gICAgICAgICAgaXNPcHRpbWl6YXRpb25OZWVkZWQgPSBzaG91bGRPcHRpbWl6ZUV4dGVuZGVkU2VsZWN0b3Iob3B0aW1pemVkRXh0ZW5kZWRTZWxlY3Rvcik7XG4gICAgICAgIH0gLy8gaWYgaXQgd2FzIHNpbXBsZSA6bm90KCkgb2YgOmlzKCkgd2l0aCBzdGFuZGFyZCBzZWxlY3RvciBhcmdcbiAgICAgICAgLy8gZS5nLiAnZGl2Om5vdChbY2xhc3NdW2lkXSknXG4gICAgICAgIC8vIG9yICAgJy5tYWluID4gKjppcyhbZGF0YS1sb2FkZWRdLCAuYmFubmVyKSdcbiAgICAgICAgLy8gYWZ0ZXIgdGhlIG9wdGltaXphdGlvbiB0aGUgRXh0ZW5kZWRTZWxlY3RvciBub2RlIGJlY29tZSBwYXJ0IG9mIFJlZ3VsYXJTZWxlY3RvclxuICAgICAgICAvLyBzbyBub3RoaW5nIHRvIHNhdmUgZXZlbnR1YWxseVxuICAgICAgICAvLyBvdGhlcndpc2UgdGhlIG9wdGltaXplZCBFeHRlbmRlZFNlbGVjdG9yIHNob3VsZCBiZSBzYXZlZFxuICAgICAgICAvLyBlLmcuICdkaXY6aGFzKDpub3QoW2NsYXNzXSkpJ1xuXG5cbiAgICAgICAgaWYgKG9wdGltaXplZEV4dGVuZGVkU2VsZWN0b3IgIT09IG51bGwpIHtcbiAgICAgICAgICBvcHRpbWl6ZWRDaGlsZHJlbkxpc3QucHVzaChvcHRpbWl6ZWRFeHRlbmRlZFNlbGVjdG9yKTsgLy8gaWYgb3B0aW1pemF0aW9uIGlzIG5vdCBuZWVkZWRcblxuICAgICAgICAgIGNvbnN0IG9wdGltaXplZFBzZXVkb0NsYXNzID0gZ2V0UHNldWRvQ2xhc3NOb2RlKG9wdGltaXplZEV4dGVuZGVkU2VsZWN0b3IpO1xuICAgICAgICAgIGNvbnN0IG9wdGltaXplZFBzZXVkb05hbWUgPSBnZXROb2RlTmFtZShvcHRpbWl6ZWRQc2V1ZG9DbGFzcyk7IC8vIHBhcmVudCBlbGVtZW50IGNoZWNraW5nIGlzIHVzZWQgdG8gYXBwbHkgOmlzKCkgYW5kIDpub3QoKSBwc2V1ZG8tY2xhc3NlcyBhcyBleHRlbmRlZC5cbiAgICAgICAgICAvLyBhcyB0aGVyZSBpcyBubyBwYXJlbnROb2RlIGZvciByb290IGVsZW1lbnQgKGh0bWwpXG4gICAgICAgICAgLy8gc28gZWxlbWVudCBzZWxlY3Rpb24gc2hvdWxkIGJlIGxpbWl0ZWQgdG8gaXQncyBjaGlsZHJlblxuICAgICAgICAgIC8vIGUuZy4gJyo6aXMoOmhhcygucGFnZSkpJyAtPiAnaHRtbCAqOmlzKGhhcygucGFnZSkpJ1xuICAgICAgICAgIC8vIG9yICAgJyo6bm90KDpoYXMoc3BhbikpJyAtPiAnaHRtbCAqOm5vdCg6aGFzKHNwYW4pKSdcblxuICAgICAgICAgIGlmIChnZXROb2RlVmFsdWUocHJldlJlZ3VsYXJDaGlsZCkgPT09IEFTVEVSSVNLICYmIGlzT3B0aW1pemF0aW9uUHNldWRvQ2xhc3Mob3B0aW1pemVkUHNldWRvTmFtZSkpIHtcbiAgICAgICAgICAgIHByZXZSZWd1bGFyQ2hpbGQudmFsdWUgPSBJU19PUl9OT1RfUFNFVURPX1NFTEVDVElOR19ST09UO1xuICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgfSBlbHNlIGlmIChpc1JlZ3VsYXJTZWxlY3Rvck5vZGUoY3VycmVudENoaWxkKSkge1xuICAgICAgICAvLyBpbiBub24tb3B0aW1pemVkIGFzdCwgUmVndWxhclNlbGVjdG9yIG5vZGUgbWF5IGZvbGxvdyBFeHRlbmRlZFNlbGVjdG9yIHdoaWNoIHNob3VsZCBiZSBvcHRpbWl6ZWRcbiAgICAgICAgLy8gZm9yIGV4YW1wbGUsIGZvciAnZGl2Om5vdCguY29udGVudCkgPiAuYmFubmVyJyBzY2hlbWF0aWNhbGx5IGl0IGxvb2tzIGxpa2VcbiAgICAgICAgLy8gbm9uLW9wdGltaXplZCBhc3Q6IFtcbiAgICAgICAgLy8gICAxLiBSZWd1bGFyU2VsZWN0b3I6ICdkaXYnXG4gICAgICAgIC8vICAgMi4gRXh0ZW5kZWRTZWxlY3RvcjogJ25vdCguY29udGVudCknXG4gICAgICAgIC8vICAgMy4gUmVndWxhclNlbGVjdG9yOiAnPiAuYmFubmVyJ1xuICAgICAgICAvLyBdXG4gICAgICAgIC8vIHdoaWNoIGFmdGVyIHRoZSBFeHRlbmRlZFNlbGVjdG9yIGxvb2tzIGxpa2VcbiAgICAgICAgLy8gcGFydGx5IG9wdGltaXplZCBhc3Q6IFtcbiAgICAgICAgLy8gICAxLiBSZWd1bGFyU2VsZWN0b3I6ICdkaXY6bm90KC5jb250ZW50KSdcbiAgICAgICAgLy8gICAyLiBSZWd1bGFyU2VsZWN0b3I6ICc+IC5iYW5uZXInXG4gICAgICAgIC8vIF1cbiAgICAgICAgLy8gc28gc2Vjb25kIFJlZ3VsYXJTZWxlY3RvciB2YWx1ZSBzaG91bGQgYmUgY29tYmluZWQgd2l0aCBmaXJzdCBvbmVcbiAgICAgICAgLy8gb3B0aW1pemVkIGFzdDogW1xuICAgICAgICAvLyAgIDEuIFJlZ3VsYXJTZWxlY3RvcjogJ2Rpdjpub3QoLmNvbnRlbnQpID4gLmJhbm5lcidcbiAgICAgICAgLy8gXVxuICAgICAgICAvLyBoZXJlIHdlIGNoZWNrICoqY2hpbGRyZW4gb2Ygc2VsZWN0b3JOb2RlKiogYWZ0ZXIgcHJldmlvdXMgb3B0aW1pemF0aW9uIGlmIGl0IHdhc1xuICAgICAgICBjb25zdCBsYXN0T3B0aW1pemVkQ2hpbGQgPSBnZXRMYXN0KG9wdGltaXplZENoaWxkcmVuTGlzdCkgfHwgbnVsbDtcblxuICAgICAgICBpZiAoaXNSZWd1bGFyU2VsZWN0b3JOb2RlKGxhc3RPcHRpbWl6ZWRDaGlsZCkpIHtcbiAgICAgICAgICBvcHRpbWl6ZUN1cnJlbnRSZWd1bGFyU2VsZWN0b3IoY3VycmVudENoaWxkLCBwcmV2UmVndWxhckNoaWxkKTtcbiAgICAgICAgfVxuICAgICAgfVxuICAgIH1cblxuICAgIGN1cnJlbnRJbmRleCArPSAxO1xuICB9XG5cbiAgcmV0dXJuIHVwZGF0ZU5vZGVDaGlsZHJlbihzZWxlY3Rvck5vZGUsIG9wdGltaXplZENoaWxkcmVuTGlzdCk7XG59O1xuLyoqXG4gKiBPcHRpbWl6ZXMgYXN0IFNlbGVjdG9yTGlzdCBub2RlLlxuICpcbiAqIEBwYXJhbSBzZWxlY3Rvckxpc3ROb2RlIFNlbGVjdG9yTGlzdCBub2RlLlxuICpcbiAqIEByZXR1cm5zIE9wdGltaXplZCBhc3Qgbm9kZS5cbiAqL1xuXG5cbmNvbnN0IG9wdGltaXplU2VsZWN0b3JMaXN0Tm9kZSA9IHNlbGVjdG9yTGlzdE5vZGUgPT4ge1xuICByZXR1cm4gdXBkYXRlTm9kZUNoaWxkcmVuKHNlbGVjdG9yTGlzdE5vZGUsIHNlbGVjdG9yTGlzdE5vZGUuY2hpbGRyZW4ubWFwKHMgPT4gb3B0aW1pemVTZWxlY3Rvck5vZGUocykpKTtcbn07XG4vKipcbiAqIE9wdGltaXplcyBhc3Q6XG4gKiBJZiBhcmcgb2YgOm5vdCgpIGFuZCA6aXMoKSBwc2V1ZG8tY2xhc3NlcyBkb2VzIG5vdCBjb250YWluIGV4dGVuZGVkIHNlbGVjdG9ycyxcbiAqIG5hdGl2ZSBEb2N1bWVudC5xdWVyeVNlbGVjdG9yQWxsKCkgY2FuIGJlIHVzZWQgdG8gcXVlcnkgZWxlbWVudHMuXG4gKiBJdCBtZWFucyB0aGF0IEV4dGVuZGVkU2VsZWN0b3IgYXN0IG5vZGVzIGNhbiBiZSByZW1vdmVkXG4gKiBhbmQgdmFsdWUgb2YgcmVsZXZhbnQgUmVndWxhclNlbGVjdG9yIG5vZGUgc2hvdWxkIGJlIHVwZGF0ZWQgYWNjb3JkaW5nbHkuXG4gKlxuICogQHBhcmFtIGFzdCBOb24tb3B0aW1pemVkIGFzdC5cbiAqXG4gKiBAcmV0dXJucyBPcHRpbWl6ZWQgYXN0LlxuICovXG5cblxuY29uc3Qgb3B0aW1pemVBc3QgPSBhc3QgPT4ge1xuICAvLyBhc3QgaXMgYmFzaWNhbGx5IHRoZSBzZWxlY3RvciBsaXN0IG9mIHNlbGVjdG9yc1xuICByZXR1cm4gb3B0aW1pemVTZWxlY3Rvckxpc3ROb2RlKGFzdCk7XG59O1xuXG4vLyBodHRwczovL2dpdGh1Yi5jb20vQWRndWFyZFRlYW0vRXh0ZW5kZWRDc3MvaXNzdWVzLzExNVxuXG5jb25zdCBYUEFUSF9QU0VVRE9fU0VMRUNUSU5HX1JPT1QgPSAnYm9keSc7XG5jb25zdCBOT19XSElURVNQQUNFX0VSUk9SX1BSRUZJWCA9ICdObyB3aGl0ZSBzcGFjZSBpcyBhbGxvd2VkIGJlZm9yZSBvciBhZnRlciBleHRlbmRlZCBwc2V1ZG8tY2xhc3MgbmFtZSBpbiBzZWxlY3Rvcic7XG4vKipcbiAqIFBhcnNlcyBzZWxlY3RvciBpbnRvIGFzdCBmb3IgZm9sbG93aW5nIGVsZW1lbnQgc2VsZWN0aW9uLlxuICpcbiAqIEBwYXJhbSBzZWxlY3RvciBTZWxlY3RvciB0byBwYXJzZS5cbiAqXG4gKiBAcmV0dXJucyBQYXJzZWQgYXN0LlxuICogQHRocm93cyBBbiBlcnJvciBvbiBpbnZhbGlkIHNlbGVjdG9yLlxuICovXG5cbmNvbnN0IHBhcnNlID0gc2VsZWN0b3IgPT4ge1xuICBjb25zdCB0b2tlbnMgPSB0b2tlbml6ZVNlbGVjdG9yKHNlbGVjdG9yKTtcbiAgY29uc3QgY29udGV4dCA9IHtcbiAgICBhc3Q6IG51bGwsXG4gICAgcGF0aFRvQnVmZmVyTm9kZTogW10sXG4gICAgZXh0ZW5kZWRQc2V1ZG9OYW1lc1N0YWNrOiBbXSxcbiAgICBleHRlbmRlZFBzZXVkb0JyYWNrZXRzU3RhY2s6IFtdLFxuICAgIHN0YW5kYXJkUHNldWRvTmFtZXNTdGFjazogW10sXG4gICAgc3RhbmRhcmRQc2V1ZG9CcmFja2V0c1N0YWNrOiBbXSxcbiAgICBpc0F0dHJpYnV0ZUJyYWNrZXRzT3BlbjogZmFsc2UsXG4gICAgYXR0cmlidXRlQnVmZmVyOiAnJyxcbiAgICBpc1JlZ2V4cE9wZW46IGZhbHNlLFxuICAgIHNob3VsZE9wdGltaXplOiBmYWxzZVxuICB9O1xuICBsZXQgaSA9IDA7XG5cbiAgd2hpbGUgKGkgPCB0b2tlbnMubGVuZ3RoKSB7XG4gICAgY29uc3QgdG9rZW4gPSB0b2tlbnNbaV07XG5cbiAgICBpZiAoIXRva2VuKSB7XG4gICAgICBicmVhaztcbiAgICB9IC8vIFRva2VuIHRvIHByb2Nlc3NcblxuXG4gICAgY29uc3Qge1xuICAgICAgdHlwZTogdG9rZW5UeXBlLFxuICAgICAgdmFsdWU6IHRva2VuVmFsdWVcbiAgICB9ID0gdG9rZW47IC8vIG5lZWRlZCBmb3IgU1BBQ0UgYW5kIENPTE9OIHRva2VucyBjaGVja2luZ1xuXG4gICAgY29uc3QgbmV4dFRva2VuID0gdG9rZW5zW2kgKyAxXTtcbiAgICBjb25zdCBuZXh0VG9rZW5UeXBlID0gbmV4dFRva2VuID09PSBudWxsIHx8IG5leHRUb2tlbiA9PT0gdm9pZCAwID8gdm9pZCAwIDogbmV4dFRva2VuLnR5cGU7XG4gICAgY29uc3QgbmV4dFRva2VuVmFsdWUgPSBuZXh0VG9rZW4gPT09IG51bGwgfHwgbmV4dFRva2VuID09PSB2b2lkIDAgPyB2b2lkIDAgOiBuZXh0VG9rZW4udmFsdWU7IC8vIG5lZWRlZCBmb3IgbGltaXRhdGlvbnNcbiAgICAvLyAtIDpub3QoKSBhbmQgOmlzKCkgcm9vdCBlbGVtZW50XG4gICAgLy8gLSA6aGFzKCkgdXNhZ2VcbiAgICAvLyAtIHdoaXRlIHNwYWNlIGJlZm9yZSBhbmQgYWZ0ZXIgcHNldWRvLWNsYXNzIG5hbWVcblxuICAgIGNvbnN0IG5leHRUb05leHRUb2tlbiA9IHRva2Vuc1tpICsgMl07XG4gICAgY29uc3QgbmV4dFRvTmV4dFRva2VuVmFsdWUgPSBuZXh0VG9OZXh0VG9rZW4gPT09IG51bGwgfHwgbmV4dFRvTmV4dFRva2VuID09PSB2b2lkIDAgPyB2b2lkIDAgOiBuZXh0VG9OZXh0VG9rZW4udmFsdWU7IC8vIG5lZWRlZCBmb3IgQ09MT04gdG9rZW4gY2hlY2tpbmcgZm9yIG5vbmUtc3BlY2lmaWVkIHJlZ3VsYXIgc2VsZWN0b3IgYmVmb3JlIGV4dGVuZGVkIG9uZVxuICAgIC8vIGUuZy4gJ3AsIDpob3ZlcidcbiAgICAvLyBvciAgICcuYmFubmVyLCA6Y29udGFpbnMoYWRzKSdcblxuICAgIGNvbnN0IHByZXZpb3VzVG9rZW4gPSB0b2tlbnNbaSAtIDFdO1xuICAgIGNvbnN0IHByZXZUb2tlblR5cGUgPSBwcmV2aW91c1Rva2VuID09PSBudWxsIHx8IHByZXZpb3VzVG9rZW4gPT09IHZvaWQgMCA/IHZvaWQgMCA6IHByZXZpb3VzVG9rZW4udHlwZTtcbiAgICBjb25zdCBwcmV2VG9rZW5WYWx1ZSA9IHByZXZpb3VzVG9rZW4gPT09IG51bGwgfHwgcHJldmlvdXNUb2tlbiA9PT0gdm9pZCAwID8gdm9pZCAwIDogcHJldmlvdXNUb2tlbi52YWx1ZTsgLy8gbmVlZGVkIGZvciBwcm9wZXIgcGFyc2luZyBvZiByZWdleHAgcGF0dGVybiBhcmdcbiAgICAvLyBlLmcuICc6bWF0Y2hlcy1jc3MoYmFja2dyb3VuZC1pbWFnZTogL151cmxcXChodHRwczpcXC9cXC9leGFtcGxlXFwub3JnXFwvLyknXG5cbiAgICBjb25zdCBwcmV2aW91c1RvUHJldmlvdXNUb2tlbiA9IHRva2Vuc1tpIC0gMl07XG4gICAgY29uc3QgcHJldlRvUHJldlRva2VuVmFsdWUgPSBwcmV2aW91c1RvUHJldmlvdXNUb2tlbiA9PT0gbnVsbCB8fCBwcmV2aW91c1RvUHJldmlvdXNUb2tlbiA9PT0gdm9pZCAwID8gdm9pZCAwIDogcHJldmlvdXNUb1ByZXZpb3VzVG9rZW4udmFsdWU7XG4gICAgbGV0IGJ1ZmZlck5vZGUgPSBnZXRCdWZmZXJOb2RlKGNvbnRleHQpO1xuXG4gICAgc3dpdGNoICh0b2tlblR5cGUpIHtcbiAgICAgIGNhc2UgVE9LRU5fVFlQRS5XT1JEOlxuICAgICAgICBpZiAoYnVmZmVyTm9kZSA9PT0gbnVsbCkge1xuICAgICAgICAgIC8vIHRoZXJlIGlzIG5vIGJ1ZmZlciBub2RlIG9ubHkgaW4gb25lIGNhc2Ug4oCUIG5vIGFzdCBjb2xsZWN0aW5nIGhhcyBiZWVuIHN0YXJ0ZWRcbiAgICAgICAgICBpbml0QXN0KGNvbnRleHQsIHRva2VuVmFsdWUpO1xuICAgICAgICB9IGVsc2UgaWYgKGlzU2VsZWN0b3JMaXN0Tm9kZShidWZmZXJOb2RlKSkge1xuICAgICAgICAgIC8vIGFkZCBuZXcgc2VsZWN0b3IgdG8gc2VsZWN0b3IgbGlzdFxuICAgICAgICAgIGFkZEFzdE5vZGVCeVR5cGUoY29udGV4dCwgTk9ERS5TRUxFQ1RPUik7XG4gICAgICAgICAgYWRkQXN0Tm9kZUJ5VHlwZShjb250ZXh0LCBOT0RFLlJFR1VMQVJfU0VMRUNUT1IsIHRva2VuVmFsdWUpO1xuICAgICAgICB9IGVsc2UgaWYgKGlzUmVndWxhclNlbGVjdG9yTm9kZShidWZmZXJOb2RlKSkge1xuICAgICAgICAgIHVwZGF0ZUJ1ZmZlck5vZGUoY29udGV4dCwgdG9rZW5WYWx1ZSk7XG4gICAgICAgIH0gZWxzZSBpZiAoaXNFeHRlbmRlZFNlbGVjdG9yTm9kZShidWZmZXJOb2RlKSkge1xuICAgICAgICAgIC8vIE5vIHdoaXRlIHNwYWNlIGlzIGFsbG93ZWQgYmV0d2VlbiB0aGUgbmFtZSBvZiBleHRlbmRlZCBwc2V1ZG8tY2xhc3NcbiAgICAgICAgICAvLyBhbmQgaXRzIG9wZW5pbmcgcGFyZW50aGVzaXNcbiAgICAgICAgICAvLyBodHRwczovL3d3dy53My5vcmcvVFIvc2VsZWN0b3JzLTQvI3BzZXVkby1jbGFzc2VzXG4gICAgICAgICAgLy8gZS5nLiAnc3Bhbjpjb250YWlucyAodGV4dCknXG4gICAgICAgICAgaWYgKGlzV2hpdGVTcGFjZUNoYXIobmV4dFRva2VuVmFsdWUpICYmIG5leHRUb05leHRUb2tlblZhbHVlID09PSBCUkFDS0VULlBBUkVOVEhFU0VTLkxFRlQpIHtcbiAgICAgICAgICAgIHRocm93IG5ldyBFcnJvcihgJHtOT19XSElURVNQQUNFX0VSUk9SX1BSRUZJWH06ICcke3NlbGVjdG9yfSdgKTtcbiAgICAgICAgICB9XG5cbiAgICAgICAgICBjb25zdCBsb3dlckNhc2VUb2tlblZhbHVlID0gdG9rZW5WYWx1ZS50b0xvd2VyQ2FzZSgpOyAvLyBzYXZlIHBzZXVkby1jbGFzcyBuYW1lIGZvciBicmFja2V0cyBiYWxhbmNlIGNoZWNraW5nXG5cbiAgICAgICAgICBjb250ZXh0LmV4dGVuZGVkUHNldWRvTmFtZXNTdGFjay5wdXNoKGxvd2VyQ2FzZVRva2VuVmFsdWUpOyAvLyBleHRlbmRlZCBwc2V1ZG8tY2xhc3MgbmFtZSBhcmUgcGFyc2VkIGluIGxvd2VyIGNhc2VcbiAgICAgICAgICAvLyBhcyB0aGV5IHNob3VsZCBiZSBjYXNlLWluc2Vuc2l0aXZlXG4gICAgICAgICAgLy8gaHR0cHM6Ly93d3cudzMub3JnL1RSL3NlbGVjdG9ycy00LyNwc2V1ZG8tY2xhc3Nlc1xuXG4gICAgICAgICAgaWYgKGlzQWJzb2x1dGVQc2V1ZG9DbGFzcyhsb3dlckNhc2VUb2tlblZhbHVlKSkge1xuICAgICAgICAgICAgYWRkQXN0Tm9kZUJ5VHlwZShjb250ZXh0LCBOT0RFLkFCU09MVVRFX1BTRVVET19DTEFTUywgbG93ZXJDYXNlVG9rZW5WYWx1ZSk7XG4gICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIC8vIGlmIGl0IGlzIG5vdCBhYnNvbHV0ZSBwc2V1ZG8tY2xhc3MsIGl0IG11c3QgYmUgcmVsYXRpdmUgb25lXG4gICAgICAgICAgICAvLyBhZGQgUmVsYXRpdmVQc2V1ZG9DbGFzcyB3aXRoIHRva2VuVmFsdWUgYXMgcHNldWRvLWNsYXNzIG5hbWUgdG8gRXh0ZW5kZWRTZWxlY3RvciBjaGlsZHJlblxuICAgICAgICAgICAgYWRkQXN0Tm9kZUJ5VHlwZShjb250ZXh0LCBOT0RFLlJFTEFUSVZFX1BTRVVET19DTEFTUywgbG93ZXJDYXNlVG9rZW5WYWx1ZSk7IC8vIGZvciA6bm90KCkgYW5kIDppcygpIHBzZXVkby1jbGFzc2VzIHBhcnNlZCBhc3Qgc2hvdWxkIGJlIG9wdGltaXplZCBsYXRlclxuXG4gICAgICAgICAgICBpZiAoaXNPcHRpbWl6YXRpb25Qc2V1ZG9DbGFzcyhsb3dlckNhc2VUb2tlblZhbHVlKSkge1xuICAgICAgICAgICAgICBjb250ZXh0LnNob3VsZE9wdGltaXplID0gdHJ1ZTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9XG4gICAgICAgIH0gZWxzZSBpZiAoaXNBYnNvbHV0ZVBzZXVkb0NsYXNzTm9kZShidWZmZXJOb2RlKSkge1xuICAgICAgICAgIC8vIGNvbGxlY3QgYWJzb2x1dGUgcHNldWRvLWNsYXNzIGFyZ1xuICAgICAgICAgIHVwZGF0ZUJ1ZmZlck5vZGUoY29udGV4dCwgdG9rZW5WYWx1ZSk7XG4gICAgICAgIH0gZWxzZSBpZiAoaXNSZWxhdGl2ZVBzZXVkb0NsYXNzTm9kZShidWZmZXJOb2RlKSkge1xuICAgICAgICAgIGluaXRSZWxhdGl2ZVN1YnRyZWUoY29udGV4dCwgdG9rZW5WYWx1ZSk7XG4gICAgICAgIH1cblxuICAgICAgICBicmVhaztcblxuICAgICAgY2FzZSBUT0tFTl9UWVBFLk1BUks6XG4gICAgICAgIHN3aXRjaCAodG9rZW5WYWx1ZSkge1xuICAgICAgICAgIGNhc2UgQ09NTUE6XG4gICAgICAgICAgICBpZiAoIWJ1ZmZlck5vZGUgfHwgdHlwZW9mIGJ1ZmZlck5vZGUgIT09ICd1bmRlZmluZWQnICYmICFuZXh0VG9rZW5WYWx1ZSkge1xuICAgICAgICAgICAgICAvLyBjb25zaWRlciB0aGUgc2VsZWN0b3IgaXMgaW52YWxpZCBpZiB0aGVyZSBpcyBubyBidWZmZXJOb2RlIHlldCAoZS5nLiAnLCBhJylcbiAgICAgICAgICAgICAgLy8gb3IgdGhlcmUgaXMgbm90aGluZyBhZnRlciB0aGUgY29tbWEgd2hpbGUgYnVmZmVyTm9kZSBpcyBkZWZpbmVkIChlLmcuICdkaXYsICcpXG4gICAgICAgICAgICAgIHRocm93IG5ldyBFcnJvcihgJyR7c2VsZWN0b3J9JyBpcyBub3QgYSB2YWxpZCBzZWxlY3RvcmApO1xuICAgICAgICAgICAgfSBlbHNlIGlmIChpc1JlZ3VsYXJTZWxlY3Rvck5vZGUoYnVmZmVyTm9kZSkpIHtcbiAgICAgICAgICAgICAgaWYgKGNvbnRleHQuaXNBdHRyaWJ1dGVCcmFja2V0c09wZW4pIHtcbiAgICAgICAgICAgICAgICAvLyB0aGUgY29tbWEgbWlnaHQgYmUgaW5zaWRlIGVsZW1lbnQgYXR0cmlidXRlIHZhbHVlXG4gICAgICAgICAgICAgICAgLy8gZS5nLiAnZGl2W2RhdGEtY29tbWE9XCIwLDFcIl0nXG4gICAgICAgICAgICAgICAgdXBkYXRlQnVmZmVyTm9kZShjb250ZXh0LCB0b2tlblZhbHVlKTtcbiAgICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgICAvLyBuZXcgU2VsZWN0b3Igc2hvdWxkIGJlIGNvbGxlY3RlZCB0byB1cHBlciBTZWxlY3Rvckxpc3RcbiAgICAgICAgICAgICAgICB1cFRvQ2xvc2VzdChjb250ZXh0LCBOT0RFLlNFTEVDVE9SX0xJU1QpO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9IGVsc2UgaWYgKGlzQWJzb2x1dGVQc2V1ZG9DbGFzc05vZGUoYnVmZmVyTm9kZSkpIHtcbiAgICAgICAgICAgICAgLy8gdGhlIGNvbW1hIGluc2lkZSBhcmcgb2YgYWJzb2x1dGUgZXh0ZW5kZWQgcHNldWRvXG4gICAgICAgICAgICAgIC8vIGUuZy4gJ2Rpdjp4cGF0aCgvL2gzW2NvbnRhaW5zKHRleHQoKSxcIlNoYXJlIGl0IVwiKV0vLi4pJ1xuICAgICAgICAgICAgICB1cGRhdGVCdWZmZXJOb2RlKGNvbnRleHQsIHRva2VuVmFsdWUpO1xuICAgICAgICAgICAgfSBlbHNlIGlmIChpc1NlbGVjdG9yTm9kZShidWZmZXJOb2RlKSkge1xuICAgICAgICAgICAgICAvLyBuZXcgU2VsZWN0b3Igc2hvdWxkIGJlIGNvbGxlY3RlZCB0byB1cHBlciBTZWxlY3Rvckxpc3RcbiAgICAgICAgICAgICAgLy8gaWYgcGFyc2VyIHBvc2l0aW9uIGlzIG9uIFNlbGVjdG9yIG5vZGVcbiAgICAgICAgICAgICAgdXBUb0Nsb3Nlc3QoY29udGV4dCwgTk9ERS5TRUxFQ1RPUl9MSVNUKTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgYnJlYWs7XG5cbiAgICAgICAgICBjYXNlIFNQQUNFOlxuICAgICAgICAgICAgLy8gaXQgbWlnaHQgYmUgY29tcGxleCBzZWxlY3RvciB3aXRoIGV4dGVuZGVkIHBzZXVkby1jbGFzcyBpbnNpZGUgaXRcbiAgICAgICAgICAgIC8vIGFuZCB0aGUgc3BhY2UgaXMgYmV0d2VlbiB0aGF0IGNvbXBsZXggc2VsZWN0b3IgYW5kIGZvbGxvd2luZyByZWd1bGFyIHNlbGVjdG9yXG4gICAgICAgICAgICAvLyBwYXJzZXIgcG9zaXRpb24gaXMgb24gYCBgIGJlZm9yZSBgc3BhbmAgbm93OlxuICAgICAgICAgICAgLy8gZS5nLiAnZGl2OmhhcyhpbWcpLmJhbm5lciBzcGFuJ1xuICAgICAgICAgICAgLy8gc28gd2UgbmVlZCB0byBjaGVjayB3aGV0aGVyIHRoZSBuZXcgYXN0IG5vZGUgc2hvdWxkIGJlIGFkZGVkIChleGFtcGxlIGFib3ZlKVxuICAgICAgICAgICAgLy8gb3IgcHJldmlvdXMgcmVndWxhciBzZWxlY3RvciBub2RlIHNob3VsZCBiZSB1cGRhdGVkXG4gICAgICAgICAgICBpZiAoaXNSZWd1bGFyU2VsZWN0b3JOb2RlKGJ1ZmZlck5vZGUpIC8vIG5vIG5lZWQgdG8gdXBkYXRlIHRoZSBidWZmZXIgbm9kZSBpZiBhdHRyaWJ1dGUgdmFsdWUgaXMgYmVpbmcgcGFyc2VkXG4gICAgICAgICAgICAvLyBlLmcuICdkaXY6bm90KFtpZF0pW3N0eWxlPVwicG9zaXRpb246IGFic29sdXRlOyB6LWluZGV4OiAxMDAwMDtcIl0nXG4gICAgICAgICAgICAvLyBwYXJzZXIgcG9zaXRpb24gaW5zaWRlIGF0dHJpYnV0ZSAgICDihpFcbiAgICAgICAgICAgICYmICFjb250ZXh0LmlzQXR0cmlidXRlQnJhY2tldHNPcGVuKSB7XG4gICAgICAgICAgICAgIGJ1ZmZlck5vZGUgPSBnZXRVcGRhdGVkQnVmZmVyTm9kZShjb250ZXh0KTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgaWYgKGlzUmVndWxhclNlbGVjdG9yTm9kZShidWZmZXJOb2RlKSkge1xuICAgICAgICAgICAgICAvLyBzdGFuZGFyZCBzZWxlY3RvcnMgd2l0aCB3aGl0ZSBzcGFjZSBiZXR3ZWVuIGNvbG9uIGFuZCBuYW1lIG9mIHBzZXVkb1xuICAgICAgICAgICAgICAvLyBhcmUgaW52YWxpZCBmb3IgbmF0aXZlIGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3JBbGwoKSBhbnl3YXksXG4gICAgICAgICAgICAgIC8vIHNvIHRocm93aW5nIHRoZSBlcnJvciBoZXJlIGlzIGJldHRlclxuICAgICAgICAgICAgICAvLyB0aGFuIHByb3BlciBwYXJzaW5nIG9mIGludmFsaWQgc2VsZWN0b3IgYW5kIHBhc3NpbmcgaXQgZnVydGhlci5cbiAgICAgICAgICAgICAgLy8gZmlyc3Qgb2YgYWxsIGRvIG5vdCBjaGVjayBhdHRyaWJ1dGVzXG4gICAgICAgICAgICAgIC8vIGUuZy4gZGl2W3N0eWxlPVwidGV4dC1hbGlnbjogY2VudGVyXCJdXG4gICAgICAgICAgICAgIGlmICghY29udGV4dC5pc0F0dHJpYnV0ZUJyYWNrZXRzT3BlbiAvLyBjaGVjayB0aGUgc3BhY2UgYWZ0ZXIgdGhlIGNvbG9uIGFuZCBiZWZvcmUgdGhlIHBzZXVkb1xuICAgICAgICAgICAgICAvLyBlLmcuICcuYmxvY2s6IG50aC1jaGlsZCgyKVxuICAgICAgICAgICAgICAmJiAocHJldlRva2VuVmFsdWUgPT09IENPTE9OICYmIG5leHRUb2tlblR5cGUgPT09IFRPS0VOX1RZUEUuV09SRCAvLyBvciBhZnRlciB0aGUgcHNldWRvIGFuZCBiZWZvcmUgdGhlIG9wZW5pbmcgcGFyZW50aGVzaXNcbiAgICAgICAgICAgICAgLy8gZS5nLiAnLmJsb2NrOm50aC1jaGlsZCAoMilcbiAgICAgICAgICAgICAgfHwgcHJldlRva2VuVHlwZSA9PT0gVE9LRU5fVFlQRS5XT1JEICYmIG5leHRUb2tlblZhbHVlID09PSBCUkFDS0VULlBBUkVOVEhFU0VTLkxFRlQpKSB7XG4gICAgICAgICAgICAgICAgdGhyb3cgbmV3IEVycm9yKGAnJHtzZWxlY3Rvcn0nIGlzIG5vdCBhIHZhbGlkIHNlbGVjdG9yYCk7XG4gICAgICAgICAgICAgIH0gLy8gY29sbGVjdCBjdXJyZW50IHRva2VuVmFsdWUgdG8gdmFsdWUgb2YgUmVndWxhclNlbGVjdG9yXG4gICAgICAgICAgICAgIC8vIGlmIGl0IGlzIHRoZSBsYXN0IHRva2VuIG9yIHN0YW5kYXJkIHNlbGVjdG9yIGNvbnRpbnVlcyBhZnRlciB0aGUgc3BhY2UuXG4gICAgICAgICAgICAgIC8vIG90aGVyd2lzZSBpdCB3aWxsIGJlIHNraXBwZWRcblxuXG4gICAgICAgICAgICAgIGlmICghbmV4dFRva2VuVmFsdWUgfHwgZG9lc1JlZ3VsYXJDb250aW51ZUFmdGVyU3BhY2UobmV4dFRva2VuVHlwZSwgbmV4dFRva2VuVmFsdWUpIC8vIHdlIGFsc28gc2hvdWxkIGNvbGxlY3Qgc3BhY2UgaW5zaWRlIGF0dHJpYnV0ZSB2YWx1ZVxuICAgICAgICAgICAgICAvLyBlLmcuIGBbb25jbGlja149XCJ3aW5kb3cub3BlbiAoJ2h0dHBzOi8vZXhhbXBsZS5jb20vc2hhcmU/dXJsPVwiXWBcbiAgICAgICAgICAgICAgLy8gcGFyc2VyIHBvc2l0aW9uICAgICAgICAgICAgIOKGkVxuICAgICAgICAgICAgICB8fCBjb250ZXh0LmlzQXR0cmlidXRlQnJhY2tldHNPcGVuKSB7XG4gICAgICAgICAgICAgICAgdXBkYXRlQnVmZmVyTm9kZShjb250ZXh0LCB0b2tlblZhbHVlKTtcbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICBpZiAoaXNBYnNvbHV0ZVBzZXVkb0NsYXNzTm9kZShidWZmZXJOb2RlKSkge1xuICAgICAgICAgICAgICAvLyBzcGFjZSBpbnNpZGUgZXh0ZW5kZWQgcHNldWRvLWNsYXNzIGFyZ1xuICAgICAgICAgICAgICAvLyBlLmcuICdzcGFuOmNvbnRhaW5zKHNvbWUgdGV4dCknXG4gICAgICAgICAgICAgIHVwZGF0ZUJ1ZmZlck5vZGUoY29udGV4dCwgdG9rZW5WYWx1ZSk7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIGlmIChpc1JlbGF0aXZlUHNldWRvQ2xhc3NOb2RlKGJ1ZmZlck5vZGUpKSB7XG4gICAgICAgICAgICAgIC8vIGluaXQgd2l0aCBlbXB0eSB2YWx1ZSBSZWd1bGFyU2VsZWN0b3JcbiAgICAgICAgICAgICAgLy8gYXMgdGhlIHNwYWNlIGlzIG5vdCBuZWVkZWQgZm9yIHNlbGVjdG9yIHZhbHVlXG4gICAgICAgICAgICAgIC8vIGUuZy4gJ3A6bm90KCAuY29udGVudCApJ1xuICAgICAgICAgICAgICBpbml0UmVsYXRpdmVTdWJ0cmVlKGNvbnRleHQpO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICBpZiAoaXNTZWxlY3Rvck5vZGUoYnVmZmVyTm9kZSkpIHtcbiAgICAgICAgICAgICAgLy8gZG8gTk9UIGFkZCBSZWd1bGFyU2VsZWN0b3IgaWYgcGFyc2VyIHBvc2l0aW9uIG9uIHNwYWNlIEJFRk9SRSB0aGUgY29tbWEgaW4gc2VsZWN0b3IgbGlzdFxuICAgICAgICAgICAgICAvLyBlLmcuICcuYmxvY2s6aGFzKD4gaW1nKSAsIC5iYW5uZXIpJ1xuICAgICAgICAgICAgICBpZiAoZG9lc1JlZ3VsYXJDb250aW51ZUFmdGVyU3BhY2UobmV4dFRva2VuVHlwZSwgbmV4dFRva2VuVmFsdWUpKSB7XG4gICAgICAgICAgICAgICAgLy8gcmVndWxhciBzZWxlY3RvciBtaWdodCBiZSBhZnRlciB0aGUgZXh0ZW5kZWQgb25lLlxuICAgICAgICAgICAgICAgIC8vIGV4dHJhIHNwYWNlIGJlZm9yZSBjb21iaW5hdG9yIG9yIHNlbGVjdG9yIHNob3VsZCBub3QgYmUgY29sbGVjdGVkXG4gICAgICAgICAgICAgICAgLy8gZS5nLiAnLmJhbm5lcjp1cHdhcmQoMikgLmJsb2NrJ1xuICAgICAgICAgICAgICAgIC8vICAgICAgJy5iYW5uZXI6dXB3YXJkKDIpID4gLmJsb2NrJ1xuICAgICAgICAgICAgICAgIC8vIHNvIG5vIHRva2VuVmFsdWUgcGFzc2VkIHRvIGFkZEFueVNlbGVjdG9yTm9kZSgpXG4gICAgICAgICAgICAgICAgYWRkQXN0Tm9kZUJ5VHlwZShjb250ZXh0LCBOT0RFLlJFR1VMQVJfU0VMRUNUT1IpO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIGJyZWFrO1xuXG4gICAgICAgICAgY2FzZSBERVNDRU5EQU5UX0NPTUJJTkFUT1I6XG4gICAgICAgICAgY2FzZSBDSElMRF9DT01CSU5BVE9SOlxuICAgICAgICAgIGNhc2UgTkVYVF9TSUJMSU5HX0NPTUJJTkFUT1I6XG4gICAgICAgICAgY2FzZSBTVUJTRVFVRU5UX1NJQkxJTkdfQ09NQklOQVRPUjpcbiAgICAgICAgICBjYXNlIFNFTUlDT0xPTjpcbiAgICAgICAgICBjYXNlIFNMQVNIOlxuICAgICAgICAgIGNhc2UgQkFDS1NMQVNIOlxuICAgICAgICAgIGNhc2UgU0lOR0xFX1FVT1RFOlxuICAgICAgICAgIGNhc2UgRE9VQkxFX1FVT1RFOlxuICAgICAgICAgIGNhc2UgQ0FSRVQ6XG4gICAgICAgICAgY2FzZSBET0xMQVJfU0lHTjpcbiAgICAgICAgICBjYXNlIEJSQUNLRVQuQ1VSTFkuTEVGVDpcbiAgICAgICAgICBjYXNlIEJSQUNLRVQuQ1VSTFkuUklHSFQ6XG4gICAgICAgICAgY2FzZSBBU1RFUklTSzpcbiAgICAgICAgICBjYXNlIElEX01BUktFUjpcbiAgICAgICAgICBjYXNlIENMQVNTX01BUktFUjpcbiAgICAgICAgICBjYXNlIEJSQUNLRVQuU1FVQVJFLkxFRlQ6XG4gICAgICAgICAgICAvLyBpdCBtaWdodCBiZSBjb21wbGV4IHNlbGVjdG9yIHdpdGggZXh0ZW5kZWQgcHNldWRvLWNsYXNzIGluc2lkZSBpdFxuICAgICAgICAgICAgLy8gYW5kIHRoZSBzcGFjZSBpcyBiZXR3ZWVuIHRoYXQgY29tcGxleCBzZWxlY3RvciBhbmQgZm9sbG93aW5nIHJlZ3VsYXIgc2VsZWN0b3JcbiAgICAgICAgICAgIC8vIGUuZy4gJ2RpdjpoYXMoaW1nKS5iYW5uZXInICAgLy8gcGFyc2VyIHBvc2l0aW9uIGlzIG9uIGAuYCBiZWZvcmUgYGJhbm5lcmAgbm93XG4gICAgICAgICAgICAvLyAgICAgICdkaXY6aGFzKGltZylbYXR0cl0nICAgIC8vIHBhcnNlciBwb3NpdGlvbiBpcyBvbiBgW2AgYmVmb3JlIGBhdHRyYCBub3dcbiAgICAgICAgICAgIC8vIHNvIHdlIG5lZWQgdG8gY2hlY2sgd2hldGhlciB0aGUgbmV3IGFzdCBub2RlIHNob3VsZCBiZSBhZGRlZCAoZXhhbXBsZSBhYm92ZSlcbiAgICAgICAgICAgIC8vIG9yIHByZXZpb3VzIHJlZ3VsYXIgc2VsZWN0b3Igbm9kZSBzaG91bGQgYmUgdXBkYXRlZFxuICAgICAgICAgICAgaWYgKENPTUJJTkFUT1JTLmluY2x1ZGVzKHRva2VuVmFsdWUpKSB7XG4gICAgICAgICAgICAgIGlmIChidWZmZXJOb2RlID09PSBudWxsKSB7XG4gICAgICAgICAgICAgICAgLy8gY2FzZXMgd2hlcmUgY29tYmluYXRvciBhdCB2ZXJ5IGJlZ2lubmluZyBvZiBhIHNlbGVjdG9yXG4gICAgICAgICAgICAgICAgLy8gZS5nLiAnPiBkaXYnXG4gICAgICAgICAgICAgICAgLy8gb3IgICAnfiAuYmFubmVyJ1xuICAgICAgICAgICAgICAgIC8vIG9yIGV2ZW4gJytqcyhvdmVybGF5LWJ1c3RlciknIHdoaWNoIG5vdCBhIHNlbGVjdG9yIGF0IGFsbFxuICAgICAgICAgICAgICAgIC8vIGJ1dCBtYXkgYmUgdmFsaWRhdGVkIGJ5IEZpbHRlckNvbXBpbGVyIHNvIGVycm9yIG1lc3NhZ2Ugc2hvdWxkIGJlIGFwcHJvcHJpYXRlXG4gICAgICAgICAgICAgICAgdGhyb3cgbmV3IEVycm9yKGAnJHtzZWxlY3Rvcn0nIGlzIG5vdCBhIHZhbGlkIHNlbGVjdG9yYCk7XG4gICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICBidWZmZXJOb2RlID0gZ2V0VXBkYXRlZEJ1ZmZlck5vZGUoY29udGV4dCk7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIGlmIChidWZmZXJOb2RlID09PSBudWxsKSB7XG4gICAgICAgICAgICAgIC8vIG5vIGFzdCBjb2xsZWN0aW5nIGhhcyBiZWVuIHN0YXJ0ZWRcbiAgICAgICAgICAgICAgLy8gZS5nLiAnLmJhbm5lciA+IHAnXG4gICAgICAgICAgICAgIC8vIG9yICAgJyN0b3AgPiBkaXYuYWQnXG4gICAgICAgICAgICAgIC8vIG9yICAgJ1tjbGFzc11bc3R5bGVdW2F0dHJdJ1xuICAgICAgICAgICAgICAvLyBvciAgICcqOm5vdChzcGFuKSdcbiAgICAgICAgICAgICAgaW5pdEFzdChjb250ZXh0LCB0b2tlblZhbHVlKTtcblxuICAgICAgICAgICAgICBpZiAoaXNBdHRyaWJ1dGVPcGVuaW5nKHRva2VuVmFsdWUsIHByZXZUb2tlblZhbHVlKSkge1xuICAgICAgICAgICAgICAgIC8vIGUuZy4gJ1tjbGFzc149XCJiYW5uZXItXCJdJ1xuICAgICAgICAgICAgICAgIGNvbnRleHQuaXNBdHRyaWJ1dGVCcmFja2V0c09wZW4gPSB0cnVlO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9IGVsc2UgaWYgKGlzUmVndWxhclNlbGVjdG9yTm9kZShidWZmZXJOb2RlKSkge1xuICAgICAgICAgICAgICBpZiAodG9rZW5WYWx1ZSA9PT0gQlJBQ0tFVC5DVVJMWS5MRUZUICYmICEoY29udGV4dC5pc0F0dHJpYnV0ZUJyYWNrZXRzT3BlbiB8fCBjb250ZXh0LmlzUmVnZXhwT3BlbikpIHtcbiAgICAgICAgICAgICAgICAvLyBlLmcuICdkaXYgeyBjb250ZW50OiBcIidcbiAgICAgICAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoYCcke3NlbGVjdG9yfScgaXMgbm90IGEgdmFsaWQgc2VsZWN0b3JgKTtcbiAgICAgICAgICAgICAgfSAvLyBjb2xsZWN0IHRoZSBtYXJrIHRvIHRoZSB2YWx1ZSBvZiBSZWd1bGFyU2VsZWN0b3Igbm9kZVxuXG5cbiAgICAgICAgICAgICAgdXBkYXRlQnVmZmVyTm9kZShjb250ZXh0LCB0b2tlblZhbHVlKTtcblxuICAgICAgICAgICAgICBpZiAoaXNBdHRyaWJ1dGVPcGVuaW5nKHRva2VuVmFsdWUsIHByZXZUb2tlblZhbHVlKSkge1xuICAgICAgICAgICAgICAgIC8vIG5lZWRlZCBmb3IgcHJvcGVyIGhhbmRsaW5nIGVsZW1lbnQgYXR0cmlidXRlIHZhbHVlIHdpdGggY29tbWFcbiAgICAgICAgICAgICAgICAvLyBlLmcuICdkaXZbZGF0YS1jb21tYT1cIjAsMVwiXSdcbiAgICAgICAgICAgICAgICBjb250ZXh0LmlzQXR0cmlidXRlQnJhY2tldHNPcGVuID0gdHJ1ZTtcbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfSBlbHNlIGlmIChpc0Fic29sdXRlUHNldWRvQ2xhc3NOb2RlKGJ1ZmZlck5vZGUpKSB7XG4gICAgICAgICAgICAgIC8vIGNvbGxlY3QgdGhlIG1hcmsgdG8gdGhlIGFyZyBvZiBBYnNvbHV0ZVBzZXVkb0NsYXNzIG5vZGVcbiAgICAgICAgICAgICAgdXBkYXRlQnVmZmVyTm9kZShjb250ZXh0LCB0b2tlblZhbHVlKTsgLy8gJ2lzUmVnZXhwT3BlbicgZmxhZyBpcyBuZWVkZWQgZm9yIGJyYWNrZXRzIGJhbGFuY2luZyBpbnNpZGUgZXh0ZW5kZWQgcHNldWRvLWNsYXNzIGFyZ1xuXG4gICAgICAgICAgICAgIGlmICh0b2tlblZhbHVlID09PSBTTEFTSCAmJiBjb250ZXh0LmV4dGVuZGVkUHNldWRvTmFtZXNTdGFjay5sZW5ndGggPiAwKSB7XG4gICAgICAgICAgICAgICAgaWYgKHByZXZUb2tlblZhbHVlID09PSBTTEFTSCAmJiBwcmV2VG9QcmV2VG9rZW5WYWx1ZSA9PT0gQkFDS1NMQVNIKSB7XG4gICAgICAgICAgICAgICAgICAvLyBpdCBtYXkgYmUgc3BlY2lmaWMgdXJsIHJlZ2V4cCBwYXR0ZXJuIGluIGFyZyBvZiBwc2V1ZG8tY2xhc3NcbiAgICAgICAgICAgICAgICAgIC8vIGUuZy4gJzptYXRjaGVzLWNzcyhiYWNrZ3JvdW5kLWltYWdlOiAvXnVybFxcKGh0dHBzOlxcL1xcL2V4YW1wbGVcXC5vcmdcXC8vKSdcbiAgICAgICAgICAgICAgICAgIC8vIHBhcnNlciBwb3NpdGlvbiBpcyBvbiBmaW5hbCBzbGFzaCBiZWZvcmUgYClgICAgICAgICAgICAgICAgICAgICAgICAg4oaRXG4gICAgICAgICAgICAgICAgICBjb250ZXh0LmlzUmVnZXhwT3BlbiA9IGZhbHNlO1xuICAgICAgICAgICAgICAgIH0gZWxzZSBpZiAocHJldlRva2VuVmFsdWUgJiYgcHJldlRva2VuVmFsdWUgIT09IEJBQ0tTTEFTSCkge1xuICAgICAgICAgICAgICAgICAgaWYgKGlzUmVnZXhwT3BlbmluZyhjb250ZXh0LCBwcmV2VG9rZW5WYWx1ZSwgZ2V0Tm9kZVZhbHVlKGJ1ZmZlck5vZGUpKSkge1xuICAgICAgICAgICAgICAgICAgICBjb250ZXh0LmlzUmVnZXhwT3BlbiA9ICFjb250ZXh0LmlzUmVnZXhwT3BlbjtcbiAgICAgICAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgICAgICAgIC8vIG90aGVyd2lzZSBmb3JjZSBgaXNSZWdleHBPcGVuYCBmbGFnIHRvIGBmYWxzZWBcbiAgICAgICAgICAgICAgICAgICAgY29udGV4dC5pc1JlZ2V4cE9wZW4gPSBmYWxzZTtcbiAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH0gZWxzZSBpZiAoaXNSZWxhdGl2ZVBzZXVkb0NsYXNzTm9kZShidWZmZXJOb2RlKSkge1xuICAgICAgICAgICAgICAvLyBhZGQgU2VsZWN0b3JMaXN0IHRvIGNoaWxkcmVuIG9mIFJlbGF0aXZlUHNldWRvQ2xhc3Mgbm9kZVxuICAgICAgICAgICAgICBpbml0UmVsYXRpdmVTdWJ0cmVlKGNvbnRleHQsIHRva2VuVmFsdWUpO1xuXG4gICAgICAgICAgICAgIGlmIChpc0F0dHJpYnV0ZU9wZW5pbmcodG9rZW5WYWx1ZSwgcHJldlRva2VuVmFsdWUpKSB7XG4gICAgICAgICAgICAgICAgLy8gYmVzaWRlcyBvZiBjcmVhdGluZyB0aGUgcmVsYXRpdmUgc3VidHJlZVxuICAgICAgICAgICAgICAgIC8vIG9wZW5pbmcgc3F1YXJlIGJyYWNrZXQgbWVhbnMgc3RhcnQgb2YgYXR0cmlidXRlXG4gICAgICAgICAgICAgICAgLy8gZS5nLiAnZGl2Om5vdChbY2xhc3M9XCJjb250ZW50XCJdKSdcbiAgICAgICAgICAgICAgICAvLyAgICAgICdkaXY6bm90KFtocmVmKj1cIndpbmRvdy5wcmludCgpXCJdKSdcbiAgICAgICAgICAgICAgICBjb250ZXh0LmlzQXR0cmlidXRlQnJhY2tldHNPcGVuID0gdHJ1ZTtcbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfSBlbHNlIGlmIChpc1NlbGVjdG9yTm9kZShidWZmZXJOb2RlKSkge1xuICAgICAgICAgICAgICAvLyBhZnRlciB0aGUgZXh0ZW5kZWQgcHNldWRvIGNsb3NpbmcgcGFyZW50aGVzZXNcbiAgICAgICAgICAgICAgLy8gcGFyc2VyIHBvc2l0aW9uIGlzIG9uIFNlbGVjdG9yIG5vZGVcbiAgICAgICAgICAgICAgLy8gYW5kIHJlZ3VsYXIgc2VsZWN0b3IgY2FuIGJlIGFmdGVyIHRoZSBleHRlbmRlZCBvbmVcbiAgICAgICAgICAgICAgLy8gZS5nLiAnLmJhbm5lcjp1cHdhcmQoMik+IC5ibG9jaydcbiAgICAgICAgICAgICAgLy8gb3IgICAnLmlubmVyOm50aC1hbmNlc3RvcigxKX4gLmJhbm5lcidcbiAgICAgICAgICAgICAgaWYgKENPTUJJTkFUT1JTLmluY2x1ZGVzKHRva2VuVmFsdWUpKSB7XG4gICAgICAgICAgICAgICAgYWRkQXN0Tm9kZUJ5VHlwZShjb250ZXh0LCBOT0RFLlJFR1VMQVJfU0VMRUNUT1IsIHRva2VuVmFsdWUpO1xuICAgICAgICAgICAgICB9IGVsc2UgaWYgKCFjb250ZXh0LmlzUmVnZXhwT3Blbikge1xuICAgICAgICAgICAgICAgIC8vIGl0IG1pZ2h0IGJlIGNvbXBsZXggc2VsZWN0b3Igd2l0aCBleHRlbmRlZCBwc2V1ZG8tY2xhc3MgaW5zaWRlIGl0LlxuICAgICAgICAgICAgICAgIC8vIHBhcnNlciBwb3NpdGlvbiBpcyBvbiBgLmAgbm93OlxuICAgICAgICAgICAgICAgIC8vIGUuZy4gJ2RpdjpoYXMoaW1nKS5iYW5uZXInXG4gICAgICAgICAgICAgICAgLy8gc28gd2UgbmVlZCB0byBnZXQgbGFzdCByZWd1bGFyIHNlbGVjdG9yIG5vZGUgYW5kIHVwZGF0ZSBpdHMgdmFsdWVcbiAgICAgICAgICAgICAgICBidWZmZXJOb2RlID0gZ2V0Q29udGV4dExhc3RSZWd1bGFyU2VsZWN0b3JOb2RlKGNvbnRleHQpO1xuICAgICAgICAgICAgICAgIHVwZGF0ZUJ1ZmZlck5vZGUoY29udGV4dCwgdG9rZW5WYWx1ZSk7XG5cbiAgICAgICAgICAgICAgICBpZiAoaXNBdHRyaWJ1dGVPcGVuaW5nKHRva2VuVmFsdWUsIHByZXZUb2tlblZhbHVlKSkge1xuICAgICAgICAgICAgICAgICAgLy8gaGFuZGxlIGF0dHJpYnV0ZSBpbiBjb21wb3VuZCBzZWxlY3RvciBhZnRlciBleHRlbmRlZCBwc2V1ZG8tY2xhc3NcbiAgICAgICAgICAgICAgICAgIC8vIGUuZy4gJ2Rpdjpub3QoLnRvcClbc3R5bGU9XCJ6LWluZGV4OiAxMDAwMDtcIl0nXG4gICAgICAgICAgICAgICAgICAvLyBwYXJzZXIgcG9zaXRpb24gICAg4oaRXG4gICAgICAgICAgICAgICAgICBjb250ZXh0LmlzQXR0cmlidXRlQnJhY2tldHNPcGVuID0gdHJ1ZTtcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH0gZWxzZSBpZiAoaXNTZWxlY3Rvckxpc3ROb2RlKGJ1ZmZlck5vZGUpKSB7XG4gICAgICAgICAgICAgIC8vIGFkZCBTZWxlY3RvciB0byBTZWxlY3Rvckxpc3RcbiAgICAgICAgICAgICAgYWRkQXN0Tm9kZUJ5VHlwZShjb250ZXh0LCBOT0RFLlNFTEVDVE9SKTsgLy8gYW5kIFJlZ3VsYXJTZWxlY3RvciBhcyBpdCBpcyBhbHdheXMgdGhlIGZpcnN0IGNoaWxkIG9mIFNlbGVjdG9yXG5cbiAgICAgICAgICAgICAgYWRkQXN0Tm9kZUJ5VHlwZShjb250ZXh0LCBOT0RFLlJFR1VMQVJfU0VMRUNUT1IsIHRva2VuVmFsdWUpO1xuXG4gICAgICAgICAgICAgIGlmIChpc0F0dHJpYnV0ZU9wZW5pbmcodG9rZW5WYWx1ZSwgcHJldlRva2VuVmFsdWUpKSB7XG4gICAgICAgICAgICAgICAgLy8gaGFuZGxlIHNpbXBsZSBhdHRyaWJ1dGUgc2VsZWN0b3IgaW4gc2VsZWN0b3IgbGlzdFxuICAgICAgICAgICAgICAgIC8vIGUuZy4gJy5iYW5uZXIsIFtjbGFzc149XCJhZC1cIl0nXG4gICAgICAgICAgICAgICAgY29udGV4dC5pc0F0dHJpYnV0ZUJyYWNrZXRzT3BlbiA9IHRydWU7XG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgYnJlYWs7XG5cbiAgICAgICAgICBjYXNlIEJSQUNLRVQuU1FVQVJFLlJJR0hUOlxuICAgICAgICAgICAgaWYgKGlzUmVndWxhclNlbGVjdG9yTm9kZShidWZmZXJOb2RlKSkge1xuICAgICAgICAgICAgICAvLyB1bmVzY2FwZWQgYF1gIGluIHJlZ3VsYXIgc2VsZWN0b3IgYWxsb3dlZCBvbmx5IGluc2lkZSBhdHRyaWJ1dGUgdmFsdWVcbiAgICAgICAgICAgICAgaWYgKCFjb250ZXh0LmlzQXR0cmlidXRlQnJhY2tldHNPcGVuICYmIHByZXZUb2tlblZhbHVlICE9PSBCQUNLU0xBU0gpIHtcbiAgICAgICAgICAgICAgICAvLyBlLmcuICdkaXZdJ1xuICAgICAgICAgICAgICAgIC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBtYXgtbGVuXG4gICAgICAgICAgICAgICAgdGhyb3cgbmV3IEVycm9yKGAnJHtzZWxlY3Rvcn0nIGlzIG5vdCBhIHZhbGlkIHNlbGVjdG9yIGR1ZSB0byAnJHt0b2tlblZhbHVlfScgYWZ0ZXIgJyR7Z2V0Tm9kZVZhbHVlKGJ1ZmZlck5vZGUpfSdgKTtcbiAgICAgICAgICAgICAgfSAvLyBuZWVkZWQgZm9yIHByb3BlciBwYXJzaW5nIHJlZ3VsYXIgc2VsZWN0b3JzIGFmdGVyIHRoZSBhdHRyaWJ1dGVzIHdpdGggY29tbWFcbiAgICAgICAgICAgICAgLy8gZS5nLiAnZGl2W2RhdGEtY29tbWE9XCIwLDFcIl0gPiBpbWcnXG5cblxuICAgICAgICAgICAgICBpZiAoaXNBdHRyaWJ1dGVDbG9zaW5nKGNvbnRleHQpKSB7XG4gICAgICAgICAgICAgICAgY29udGV4dC5pc0F0dHJpYnV0ZUJyYWNrZXRzT3BlbiA9IGZhbHNlOyAvLyByZXNldCBhdHRyaWJ1dGUgYnVmZmVyIG9uIGNsb3NpbmcgYF1gXG5cbiAgICAgICAgICAgICAgICBjb250ZXh0LmF0dHJpYnV0ZUJ1ZmZlciA9ICcnO1xuICAgICAgICAgICAgICB9IC8vIGNvbGxlY3QgdGhlIGJyYWNrZXQgdG8gdGhlIHZhbHVlIG9mIFJlZ3VsYXJTZWxlY3RvciBub2RlXG5cblxuICAgICAgICAgICAgICB1cGRhdGVCdWZmZXJOb2RlKGNvbnRleHQsIHRva2VuVmFsdWUpO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICBpZiAoaXNBYnNvbHV0ZVBzZXVkb0NsYXNzTm9kZShidWZmZXJOb2RlKSkge1xuICAgICAgICAgICAgICAvLyA6eHBhdGgoKSBleHBlbmRlZCBwc2V1ZG8tY2xhc3MgYXJnIG1pZ2h0IGNvbnRhaW4gc3F1YXJlIGJyYWNrZXRcbiAgICAgICAgICAgICAgLy8gc28gaXQgc2hvdWxkIGJlIGNvbGxlY3RlZFxuICAgICAgICAgICAgICAvLyBlLmcuICdkaXY6eHBhdGgoLy9oM1tjb250YWlucyh0ZXh0KCksXCJTaGFyZSBpdCFcIildLy4uKSdcbiAgICAgICAgICAgICAgdXBkYXRlQnVmZmVyTm9kZShjb250ZXh0LCB0b2tlblZhbHVlKTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgYnJlYWs7XG5cbiAgICAgICAgICBjYXNlIENPTE9OOlxuICAgICAgICAgICAgLy8gTm8gd2hpdGUgc3BhY2UgaXMgYWxsb3dlZCBiZXR3ZWVuIHRoZSBjb2xvbiBhbmQgdGhlIGZvbGxvd2luZyBuYW1lIG9mIHRoZSBwc2V1ZG8tY2xhc3NcbiAgICAgICAgICAgIC8vIGh0dHBzOi8vd3d3LnczLm9yZy9UUi9zZWxlY3RvcnMtNC8jcHNldWRvLWNsYXNzZXNcbiAgICAgICAgICAgIC8vIGUuZy4gJ3NwYW46IGNvbnRhaW5zKHRleHQpJ1xuICAgICAgICAgICAgaWYgKGlzV2hpdGVTcGFjZUNoYXIobmV4dFRva2VuVmFsdWUpICYmIG5leHRUb05leHRUb2tlblZhbHVlICYmIFNVUFBPUlRFRF9QU0VVRE9fQ0xBU1NFUy5pbmNsdWRlcyhuZXh0VG9OZXh0VG9rZW5WYWx1ZSkpIHtcbiAgICAgICAgICAgICAgdGhyb3cgbmV3IEVycm9yKGAke05PX1dISVRFU1BBQ0VfRVJST1JfUFJFRklYfTogJyR7c2VsZWN0b3J9J2ApO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICBpZiAoYnVmZmVyTm9kZSA9PT0gbnVsbCkge1xuICAgICAgICAgICAgICAvLyBubyBhc3QgY29sbGVjdGluZyBoYXMgYmVlbiBzdGFydGVkXG4gICAgICAgICAgICAgIGlmIChuZXh0VG9rZW5WYWx1ZSA9PT0gWFBBVEhfUFNFVURPX0NMQVNTX01BUktFUikge1xuICAgICAgICAgICAgICAgIC8vIGxpbWl0IGFwcGx5aW5nIG9mIFwibmFrZWRcIiA6eHBhdGggcHNldWRvLWNsYXNzXG4gICAgICAgICAgICAgICAgLy8gaHR0cHM6Ly9naXRodWIuY29tL0FkZ3VhcmRUZWFtL0V4dGVuZGVkQ3NzL2lzc3Vlcy8xMTVcbiAgICAgICAgICAgICAgICBpbml0QXN0KGNvbnRleHQsIFhQQVRIX1BTRVVET19TRUxFQ1RJTkdfUk9PVCk7XG4gICAgICAgICAgICAgIH0gZWxzZSBpZiAobmV4dFRva2VuVmFsdWUgPT09IFVQV0FSRF9QU0VVRE9fQ0xBU1NfTUFSS0VSIHx8IG5leHRUb2tlblZhbHVlID09PSBOVEhfQU5DRVNUT1JfUFNFVURPX0NMQVNTX01BUktFUikge1xuICAgICAgICAgICAgICAgIC8vIHNlbGVjdG9yIHNob3VsZCBiZSBzcGVjaWZpZWQgYmVmb3JlIDpudGgtYW5jZXN0b3IoKSBvciA6dXB3YXJkKClcbiAgICAgICAgICAgICAgICAvLyBlLmcuICc6bnRoLWFuY2VzdG9yKDMpJ1xuICAgICAgICAgICAgICAgIC8vIG9yICAgJzp1cHdhcmQoc3BhbiknXG4gICAgICAgICAgICAgICAgdGhyb3cgbmV3IEVycm9yKGAke05PX1NFTEVDVE9SX0VSUk9SX1BSRUZJWH0gYmVmb3JlIDoke25leHRUb2tlblZhbHVlfSgpIHBzZXVkby1jbGFzc2ApO1xuICAgICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICAgIC8vIG1ha2UgaXQgbW9yZSBvYnZpb3VzIGlmIHNlbGVjdG9yIHN0YXJ0cyB3aXRoIHBzZXVkbyB3aXRoIG5vIHRhZyBzcGVjaWZpZWRcbiAgICAgICAgICAgICAgICAvLyBlLmcuICc6aGFzKGEpJyAtPiAnKjpoYXMoYSknXG4gICAgICAgICAgICAgICAgLy8gb3IgICAnOmVtcHR5JyAgLT4gJyo6ZW1wdHknXG4gICAgICAgICAgICAgICAgaW5pdEFzdChjb250ZXh0LCBBU1RFUklTSyk7XG4gICAgICAgICAgICAgIH0gLy8gYnVmZmVyTm9kZSBzaG91bGQgYmUgdXBkYXRlZCBmb3IgZm9sbG93aW5nIGNoZWNraW5nXG5cblxuICAgICAgICAgICAgICBidWZmZXJOb2RlID0gZ2V0QnVmZmVyTm9kZShjb250ZXh0KTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgaWYgKGlzU2VsZWN0b3JMaXN0Tm9kZShidWZmZXJOb2RlKSkge1xuICAgICAgICAgICAgICAvLyBidWZmZXJOb2RlIGlzIFNlbGVjdG9yTGlzdCBhZnRlciBjb21tYSBoYXMgYmVlbiBwYXJzZWQuXG4gICAgICAgICAgICAgIC8vIHBhcnNlciBwb3NpdGlvbiBpcyBvbiBjb2xvbiBub3c6XG4gICAgICAgICAgICAgIC8vIGUuZy4gJ2ltZyw6bm90KC5jb250ZW50KSdcbiAgICAgICAgICAgICAgYWRkQXN0Tm9kZUJ5VHlwZShjb250ZXh0LCBOT0RFLlNFTEVDVE9SKTsgLy8gYWRkIGVtcHR5IHZhbHVlIFJlZ3VsYXJTZWxlY3RvciBhbnl3YXkgYXMgYW55IHNlbGVjdG9yIHNob3VsZCBzdGFydCB3aXRoIGl0XG4gICAgICAgICAgICAgIC8vIGFuZCBjaGVjayBwcmV2aW91cyB0b2tlbiBvbiB0aGUgbmV4dCBzdGVwXG5cbiAgICAgICAgICAgICAgYWRkQXN0Tm9kZUJ5VHlwZShjb250ZXh0LCBOT0RFLlJFR1VMQVJfU0VMRUNUT1IpOyAvLyBidWZmZXJOb2RlIHNob3VsZCBiZSB1cGRhdGVkIGZvciBmb2xsb3dpbmcgY2hlY2tpbmdcblxuICAgICAgICAgICAgICBidWZmZXJOb2RlID0gZ2V0QnVmZmVyTm9kZShjb250ZXh0KTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgaWYgKGlzUmVndWxhclNlbGVjdG9yTm9kZShidWZmZXJOb2RlKSkge1xuICAgICAgICAgICAgICAvLyBpdCBjYW4gYmUgZXh0ZW5kZWQgb3Igc3RhbmRhcmQgcHNldWRvXG4gICAgICAgICAgICAgIC8vIGUuZy4gJyNzaGFyZSwgOmNvbnRhaW5zKHNoYXJlIGl0KSdcbiAgICAgICAgICAgICAgLy8gb3IgICAnZGl2LDpob3ZlcidcbiAgICAgICAgICAgICAgLy8gb2YgICAnZGl2OmhhcygrOmNvbnRhaW5zKHRleHQpKScgIC8vIHBvc2l0aW9uIGlzIGFmdGVyICcrJ1xuICAgICAgICAgICAgICBpZiAocHJldlRva2VuVmFsdWUgJiYgQ09NQklOQVRPUlMuaW5jbHVkZXMocHJldlRva2VuVmFsdWUpIHx8IHByZXZUb2tlblZhbHVlID09PSBDT01NQSkge1xuICAgICAgICAgICAgICAgIC8vIGNhc2Ugd2l0aCBjb2xvbiBhdCB0aGUgc3RhcnQgb2Ygc3RyaW5nIC0gZS5nLiAnOmNvbnRhaW5zKHRleHQpJ1xuICAgICAgICAgICAgICAgIC8vIGlzIGNvdmVyZWQgYnkgJ2J1ZmZlck5vZGUgPT09IG51bGwnIGFib3ZlIGF0IHN0YXJ0IG9mIENPTE9OIGNoZWNraW5nXG4gICAgICAgICAgICAgICAgdXBkYXRlQnVmZmVyTm9kZShjb250ZXh0LCBBU1RFUklTSyk7XG4gICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICBoYW5kbGVOZXh0VG9rZW5PbkNvbG9uKGNvbnRleHQsIHNlbGVjdG9yLCB0b2tlblZhbHVlLCBuZXh0VG9rZW5WYWx1ZSwgbmV4dFRvTmV4dFRva2VuVmFsdWUpO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICBpZiAoaXNTZWxlY3Rvck5vZGUoYnVmZmVyTm9kZSkpIHtcbiAgICAgICAgICAgICAgLy8gZS5nLiAnZGl2OmNvbnRhaW5zKHRleHQpOidcbiAgICAgICAgICAgICAgaWYgKCFuZXh0VG9rZW5WYWx1ZSkge1xuICAgICAgICAgICAgICAgIHRocm93IG5ldyBFcnJvcihgSW52YWxpZCBjb2xvbiAnOicgYXQgdGhlIGVuZCBvZiBzZWxlY3RvcjogJyR7c2VsZWN0b3J9J2ApO1xuICAgICAgICAgICAgICB9IC8vIGFmdGVyIHRoZSBleHRlbmRlZCBwc2V1ZG8gY2xvc2luZyBwYXJlbnRoZXNlc1xuICAgICAgICAgICAgICAvLyBwYXJzZXIgcG9zaXRpb24gaXMgb24gU2VsZWN0b3Igbm9kZVxuICAgICAgICAgICAgICAvLyBhbmQgdGhlcmUgaXMgbWlnaHQgYmUgYW5vdGhlciBleHRlbmRlZCBzZWxlY3Rvci5cbiAgICAgICAgICAgICAgLy8gcGFyc2VyIHBvc2l0aW9uIGlzIG9uIGNvbG9uIGJlZm9yZSAndXB3YXJkJzpcbiAgICAgICAgICAgICAgLy8gZS5nLiAncDpjb250YWlucyhQUik6dXB3YXJkKDIpJ1xuXG5cbiAgICAgICAgICAgICAgaWYgKGlzU3VwcG9ydGVkUHNldWRvQ2xhc3MobmV4dFRva2VuVmFsdWUudG9Mb3dlckNhc2UoKSkpIHtcbiAgICAgICAgICAgICAgICAvLyBpZiBzdXBwb3J0ZWQgZXh0ZW5kZWQgcHNldWRvLWNsYXNzIGlzIG5leHQgdG8gY29sb25cbiAgICAgICAgICAgICAgICAvLyBhZGQgRXh0ZW5kZWRTZWxlY3RvciB0byBTZWxlY3RvciBjaGlsZHJlblxuICAgICAgICAgICAgICAgIGFkZEFzdE5vZGVCeVR5cGUoY29udGV4dCwgTk9ERS5FWFRFTkRFRF9TRUxFQ1RPUik7XG4gICAgICAgICAgICAgIH0gZWxzZSBpZiAobmV4dFRva2VuVmFsdWUudG9Mb3dlckNhc2UoKSA9PT0gUkVNT1ZFX1BTRVVET19NQVJLRVIpIHtcbiAgICAgICAgICAgICAgICAvLyA6cmVtb3ZlKCkgcHNldWRvLWNsYXNzIHNob3VsZCBiZSBoYW5kbGVkIGJlZm9yZVxuICAgICAgICAgICAgICAgIC8vIGFzIGl0IGlzIG5vdCBhYm91dCBlbGVtZW50IHNlbGVjdGluZyBidXQgYWN0aW9ucyB3aXRoIGVsZW1lbnRzXG4gICAgICAgICAgICAgICAgLy8gZS5nLiAnI2Jhbm5lcjp1cHdhcmQoMik6cmVtb3ZlKCknXG4gICAgICAgICAgICAgICAgdGhyb3cgbmV3IEVycm9yKGAke1JFTU9WRV9FUlJPUl9QUkVGSVguSU5WQUxJRF9SRU1PVkV9OiAnJHtzZWxlY3Rvcn0nYCk7XG4gICAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgICAgLy8gb3RoZXJ3aXNlIGl0IGlzIHN0YW5kYXJkIHBzZXVkbyBhZnRlciBleHRlbmRlZCBwc2V1ZG8tY2xhc3MgaW4gY29tcGxleCBzZWxlY3RvclxuICAgICAgICAgICAgICAgIC8vIGFuZCBjb2xvbiBzaG91bGQgYmUgY29sbGVjdGVkIHRvIHZhbHVlIG9mIHByZXZpb3VzIFJlZ3VsYXJTZWxlY3RvclxuICAgICAgICAgICAgICAgIC8vIGUuZy4gJ2JvZHkgKjpub3QoaW5wdXQpOjpzZWxlY3Rpb24nXG4gICAgICAgICAgICAgICAgLy8gICAgICAnaW5wdXQ6bWF0Y2hlcy1jc3MocGFkZGluZzogMTApOmNoZWNrZWQnXG4gICAgICAgICAgICAgICAgYnVmZmVyTm9kZSA9IGdldENvbnRleHRMYXN0UmVndWxhclNlbGVjdG9yTm9kZShjb250ZXh0KTtcbiAgICAgICAgICAgICAgICBoYW5kbGVOZXh0VG9rZW5PbkNvbG9uKGNvbnRleHQsIHNlbGVjdG9yLCB0b2tlblZhbHVlLCBuZXh0VG9rZW5UeXBlLCBuZXh0VG9OZXh0VG9rZW5WYWx1ZSk7XG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgaWYgKGlzQWJzb2x1dGVQc2V1ZG9DbGFzc05vZGUoYnVmZmVyTm9kZSkpIHtcbiAgICAgICAgICAgICAgLy8gOnhwYXRoKCkgcHNldWRvLWNsYXNzIHNob3VsZCBiZSB0aGUgbGFzdCBvZiBleHRlbmRlZCBwc2V1ZG8tY2xhc3Nlc1xuICAgICAgICAgICAgICBpZiAoZ2V0Tm9kZU5hbWUoYnVmZmVyTm9kZSkgPT09IFhQQVRIX1BTRVVET19DTEFTU19NQVJLRVIgJiYgbmV4dFRva2VuVmFsdWUgJiYgU1VQUE9SVEVEX1BTRVVET19DTEFTU0VTLmluY2x1ZGVzKG5leHRUb2tlblZhbHVlKSAmJiBuZXh0VG9OZXh0VG9rZW5WYWx1ZSA9PT0gQlJBQ0tFVC5QQVJFTlRIRVNFUy5MRUZUKSB7XG4gICAgICAgICAgICAgICAgdGhyb3cgbmV3IEVycm9yKGA6eHBhdGgoKSBwc2V1ZG8tY2xhc3Mgc2hvdWxkIGJlIHRoZSBsYXN0IGluIHNlbGVjdG9yOiAnJHtzZWxlY3Rvcn0nYCk7XG4gICAgICAgICAgICAgIH0gLy8gY29sbGVjdGluZyBhcmcgZm9yIGFic29sdXRlIHBzZXVkby1jbGFzc1xuICAgICAgICAgICAgICAvLyBlLmcuICdkaXY6bWF0Y2hlcy1jc3Mod2lkdGg6NDAwcHgpJ1xuXG5cbiAgICAgICAgICAgICAgdXBkYXRlQnVmZmVyTm9kZShjb250ZXh0LCB0b2tlblZhbHVlKTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgaWYgKGlzUmVsYXRpdmVQc2V1ZG9DbGFzc05vZGUoYnVmZmVyTm9kZSkpIHtcbiAgICAgICAgICAgICAgaWYgKCFuZXh0VG9rZW5WYWx1ZSkge1xuICAgICAgICAgICAgICAgIC8vIGUuZy4gJ2RpdjpoYXMoOidcbiAgICAgICAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoYEludmFsaWQgcHNldWRvLWNsYXNzIGFyZyBhdCB0aGUgZW5kIG9mIHNlbGVjdG9yOiAnJHtzZWxlY3Rvcn0nYCk7XG4gICAgICAgICAgICAgIH0gLy8gbWFrZSBpdCBtb3JlIG9idmlvdXMgaWYgc2VsZWN0b3Igc3RhcnRzIHdpdGggcHNldWRvIHdpdGggbm8gdGFnIHNwZWNpZmllZFxuICAgICAgICAgICAgICAvLyBwYXJzZXIgcG9zaXRpb24gaXMgb24gY29sb24gaW5zaWRlIDpoYXMoKSBhcmdcbiAgICAgICAgICAgICAgLy8gZS5nLiAnZGl2Omhhcyg6Y29udGFpbnModGV4dCkpJ1xuICAgICAgICAgICAgICAvLyBvciAgICdkaXY6bm90KDplbXB0eSknXG5cblxuICAgICAgICAgICAgICBpbml0UmVsYXRpdmVTdWJ0cmVlKGNvbnRleHQsIEFTVEVSSVNLKTtcblxuICAgICAgICAgICAgICBpZiAoIWlzU3VwcG9ydGVkUHNldWRvQ2xhc3MobmV4dFRva2VuVmFsdWUudG9Mb3dlckNhc2UoKSkpIHtcbiAgICAgICAgICAgICAgICAvLyBjb2xsZWN0IHRoZSBjb2xvbiB0byB2YWx1ZSBvZiBSZWd1bGFyU2VsZWN0b3JcbiAgICAgICAgICAgICAgICAvLyBlLmcuICdkaXY6bm90KDplbXB0eSknXG4gICAgICAgICAgICAgICAgdXBkYXRlQnVmZmVyTm9kZShjb250ZXh0LCB0b2tlblZhbHVlKTsgLy8gcGFyZW50aGVzZXMgc2hvdWxkIGJlIGJhbGFuY2VkIG9ubHkgZm9yIGZ1bmN0aW9uYWwgcHNldWRvLWNsYXNzZXNcbiAgICAgICAgICAgICAgICAvLyBlLmcuICcueWVsbG93Om5vdCg6bnRoLWNoaWxkKDMpKSdcblxuICAgICAgICAgICAgICAgIGlmIChuZXh0VG9OZXh0VG9rZW5WYWx1ZSA9PT0gQlJBQ0tFVC5QQVJFTlRIRVNFUy5MRUZUKSB7XG4gICAgICAgICAgICAgICAgICBjb250ZXh0LnN0YW5kYXJkUHNldWRvTmFtZXNTdGFjay5wdXNoKG5leHRUb2tlblZhbHVlKTtcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgICAgLy8gYWRkIEV4dGVuZGVkU2VsZWN0b3IgdG8gU2VsZWN0b3IgY2hpbGRyZW5cbiAgICAgICAgICAgICAgICAvLyBlLmcuICdkaXY6aGFzKDpjb250YWlucyh0ZXh0KSknXG4gICAgICAgICAgICAgICAgdXBUb0Nsb3Nlc3QoY29udGV4dCwgTk9ERS5TRUxFQ1RPUik7XG4gICAgICAgICAgICAgICAgYWRkQXN0Tm9kZUJ5VHlwZShjb250ZXh0LCBOT0RFLkVYVEVOREVEX1NFTEVDVE9SKTtcbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICBicmVhaztcblxuICAgICAgICAgIGNhc2UgQlJBQ0tFVC5QQVJFTlRIRVNFUy5MRUZUOlxuICAgICAgICAgICAgLy8gc3RhcnQgb2YgcHNldWRvLWNsYXNzIGFyZ1xuICAgICAgICAgICAgaWYgKGlzQWJzb2x1dGVQc2V1ZG9DbGFzc05vZGUoYnVmZmVyTm9kZSkpIHtcbiAgICAgICAgICAgICAgLy8gbm8gYnJhY2tldHMgYmFsYW5jaW5nIG5lZWRlZCBpbnNpZGVcbiAgICAgICAgICAgICAgLy8gMS4gOnhwYXRoKCkgZXh0ZW5kZWQgcHNldWRvLWNsYXNzIGFyZ1xuICAgICAgICAgICAgICAvLyAyLiByZWdleHAgYXJnIGZvciBvdGhlciBleHRlbmRlZCBwc2V1ZG8tY2xhc3Nlc1xuICAgICAgICAgICAgICBpZiAoZ2V0Tm9kZU5hbWUoYnVmZmVyTm9kZSkgIT09IFhQQVRIX1BTRVVET19DTEFTU19NQVJLRVIgJiYgY29udGV4dC5pc1JlZ2V4cE9wZW4pIHtcbiAgICAgICAgICAgICAgICAvLyBpZiB0aGUgcGFyZW50aGVzZXMgaXMgZXNjYXBlZCBpdCBzaG91bGQgYmUgcGFydCBvZiByZWdleHBcbiAgICAgICAgICAgICAgICAvLyBjb2xsZWN0IGl0IHRvIGFyZyBvZiBBYnNvbHV0ZVBzZXVkb0NsYXNzXG4gICAgICAgICAgICAgICAgLy8gZS5nLiAnZGl2Om1hdGNoZXMtY3NzKGJhY2tncm91bmQtaW1hZ2U6IC9edXJsXFxcXChcImRhdGE6aW1hZ2VcXFxcL2dpZjtiYXNlNjQuKy8pJ1xuICAgICAgICAgICAgICAgIHVwZGF0ZUJ1ZmZlck5vZGUoY29udGV4dCwgdG9rZW5WYWx1ZSk7XG4gICAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgICAgLy8gb3RoZXJ3aXNlIGJyYWNrZXRzIHNob3VsZCBiZSBiYWxhbmNlZFxuICAgICAgICAgICAgICAgIC8vIGUuZy4gJ2Rpdjp4cGF0aCgvL2gzW2NvbnRhaW5zKHRleHQoKSxcIlNoYXJlIGl0IVwiKV0vLi4pJ1xuICAgICAgICAgICAgICAgIGNvbnRleHQuZXh0ZW5kZWRQc2V1ZG9CcmFja2V0c1N0YWNrLnB1c2godG9rZW5WYWx1ZSk7IC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBtYXgtbGVuXG5cbiAgICAgICAgICAgICAgICBpZiAoY29udGV4dC5leHRlbmRlZFBzZXVkb0JyYWNrZXRzU3RhY2subGVuZ3RoID4gY29udGV4dC5leHRlbmRlZFBzZXVkb05hbWVzU3RhY2subGVuZ3RoKSB7XG4gICAgICAgICAgICAgICAgICB1cGRhdGVCdWZmZXJOb2RlKGNvbnRleHQsIHRva2VuVmFsdWUpO1xuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICBpZiAoaXNSZWd1bGFyU2VsZWN0b3JOb2RlKGJ1ZmZlck5vZGUpKSB7XG4gICAgICAgICAgICAgIC8vIGNvbnRpbnVlIFJlZ3VsYXJTZWxlY3RvciB2YWx1ZSBjb2xsZWN0aW5nIGZvciBzdGFuZGFyZCBwc2V1ZG8tY2xhc3Nlc1xuICAgICAgICAgICAgICAvLyBlLmcuICcuYmFubmVyOndoZXJlKGRpdiknXG4gICAgICAgICAgICAgIGlmIChjb250ZXh0LnN0YW5kYXJkUHNldWRvTmFtZXNTdGFjay5sZW5ndGggPiAwKSB7XG4gICAgICAgICAgICAgICAgdXBkYXRlQnVmZmVyTm9kZShjb250ZXh0LCB0b2tlblZhbHVlKTtcbiAgICAgICAgICAgICAgICBjb250ZXh0LnN0YW5kYXJkUHNldWRvQnJhY2tldHNTdGFjay5wdXNoKHRva2VuVmFsdWUpO1xuICAgICAgICAgICAgICB9IC8vIHBhcmVudGhlc2VzIGluc2lkZSBhdHRyaWJ1dGUgdmFsdWUgc2hvdWxkIGJlIHBhcnQgb2YgUmVndWxhclNlbGVjdG9yIHZhbHVlXG4gICAgICAgICAgICAgIC8vIGUuZy4gJ2Rpdjpub3QoW2hyZWYqPVwid2luZG93LnByaW50KClcIl0pJyAgIDwtLSBwYXJzZXIgcG9zaXRpb25cbiAgICAgICAgICAgICAgLy8gaXMgb24gdGhlIGAoYCBhZnRlciBgcHJpbnRgICAgICAgIOKGkVxuXG5cbiAgICAgICAgICAgICAgaWYgKGNvbnRleHQuaXNBdHRyaWJ1dGVCcmFja2V0c09wZW4pIHtcbiAgICAgICAgICAgICAgICB1cGRhdGVCdWZmZXJOb2RlKGNvbnRleHQsIHRva2VuVmFsdWUpO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIGlmIChpc1JlbGF0aXZlUHNldWRvQ2xhc3NOb2RlKGJ1ZmZlck5vZGUpKSB7XG4gICAgICAgICAgICAgIC8vIHNhdmUgb3BlbmluZyBicmFja2V0IGZvciBiYWxhbmNpbmdcbiAgICAgICAgICAgICAgLy8gZS5nLiAnZGl2Om5vdCgpJyAgLy8gcG9zaXRpb24gaXMgb24gYChgXG4gICAgICAgICAgICAgIGNvbnRleHQuZXh0ZW5kZWRQc2V1ZG9CcmFja2V0c1N0YWNrLnB1c2godG9rZW5WYWx1ZSk7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIGJyZWFrO1xuXG4gICAgICAgICAgY2FzZSBCUkFDS0VULlBBUkVOVEhFU0VTLlJJR0hUOlxuICAgICAgICAgICAgaWYgKGlzQWJzb2x1dGVQc2V1ZG9DbGFzc05vZGUoYnVmZmVyTm9kZSkpIHtcbiAgICAgICAgICAgICAgLy8gbm8gYnJhY2tldHMgYmFsYW5jaW5nIG5lZWRlZCBpbnNpZGVcbiAgICAgICAgICAgICAgLy8gMS4gOnhwYXRoKCkgZXh0ZW5kZWQgcHNldWRvLWNsYXNzIGFyZ1xuICAgICAgICAgICAgICAvLyAyLiByZWdleHAgYXJnIGZvciBvdGhlciBleHRlbmRlZCBwc2V1ZG8tY2xhc3Nlc1xuICAgICAgICAgICAgICBpZiAoZ2V0Tm9kZU5hbWUoYnVmZmVyTm9kZSkgIT09IFhQQVRIX1BTRVVET19DTEFTU19NQVJLRVIgJiYgY29udGV4dC5pc1JlZ2V4cE9wZW4pIHtcbiAgICAgICAgICAgICAgICAvLyBpZiBjbG9zaW5nIGJyYWNrZXQgaXMgcGFydCBvZiByZWdleHBcbiAgICAgICAgICAgICAgICAvLyBzaW1wbHkgc2F2ZSBpdCB0byBwc2V1ZG8tY2xhc3MgYXJnXG4gICAgICAgICAgICAgICAgdXBkYXRlQnVmZmVyTm9kZShjb250ZXh0LCB0b2tlblZhbHVlKTtcbiAgICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgICAvLyByZW1vdmUgc3RhY2tlZCBvcGVuIHBhcmVudGhlc2VzIGZvciBicmFja2V0cyBiYWxhbmNlXG4gICAgICAgICAgICAgICAgLy8gZS5nLiAnaDM6Y29udGFpbnMoKEFkcykpJ1xuICAgICAgICAgICAgICAgIC8vIG9yICAgJ2Rpdjp4cGF0aCgvL2gzW2NvbnRhaW5zKHRleHQoKSxcIlNoYXJlIGl0IVwiKV0vLi4pJ1xuICAgICAgICAgICAgICAgIGNvbnRleHQuZXh0ZW5kZWRQc2V1ZG9CcmFja2V0c1N0YWNrLnBvcCgpO1xuXG4gICAgICAgICAgICAgICAgaWYgKGdldE5vZGVOYW1lKGJ1ZmZlck5vZGUpICE9PSBYUEFUSF9QU0VVRE9fQ0xBU1NfTUFSS0VSKSB7XG4gICAgICAgICAgICAgICAgICAvLyBmb3IgYWxsIG90aGVyIGFic29sdXRlIHBzZXVkby1jbGFzc2VzIGV4Y2VwdCA6eHBhdGgoKVxuICAgICAgICAgICAgICAgICAgLy8gcmVtb3ZlIHN0YWNrZWQgbmFtZSBvZiBleHRlbmRlZCBwc2V1ZG8tY2xhc3NcbiAgICAgICAgICAgICAgICAgIGNvbnRleHQuZXh0ZW5kZWRQc2V1ZG9OYW1lc1N0YWNrLnBvcCgpOyAvLyBlc2xpbnQtZGlzYWJsZS1uZXh0LWxpbmUgbWF4LWxlblxuXG4gICAgICAgICAgICAgICAgICBpZiAoY29udGV4dC5leHRlbmRlZFBzZXVkb0JyYWNrZXRzU3RhY2subGVuZ3RoID4gY29udGV4dC5leHRlbmRlZFBzZXVkb05hbWVzU3RhY2subGVuZ3RoKSB7XG4gICAgICAgICAgICAgICAgICAgIC8vIGlmIGJyYWNrZXRzIHN0YWNrIGlzIG5vdCBlbXB0eSB5ZXQsXG4gICAgICAgICAgICAgICAgICAgIC8vIHNhdmUgdG9rZW5WYWx1ZSB0byBhcmcgb2YgQWJzb2x1dGVQc2V1ZG9DbGFzc1xuICAgICAgICAgICAgICAgICAgICAvLyBwYXJzZXIgcG9zaXRpb24gb24gZmlyc3QgY2xvc2luZyBicmFja2V0IGFmdGVyICdBZHMnOlxuICAgICAgICAgICAgICAgICAgICAvLyBlLmcuICdoMzpjb250YWlucygoQWRzKSknXG4gICAgICAgICAgICAgICAgICAgIHVwZGF0ZUJ1ZmZlck5vZGUoY29udGV4dCwgdG9rZW5WYWx1ZSk7XG4gICAgICAgICAgICAgICAgICB9IGVsc2UgaWYgKGNvbnRleHQuZXh0ZW5kZWRQc2V1ZG9CcmFja2V0c1N0YWNrLmxlbmd0aCA+PSAwICYmIGNvbnRleHQuZXh0ZW5kZWRQc2V1ZG9OYW1lc1N0YWNrLmxlbmd0aCA+PSAwKSB7XG4gICAgICAgICAgICAgICAgICAgIC8vIGFzc3VtZSBpdCBpcyBjb21iaW5lZCBleHRlbmRlZCBwc2V1ZG8tY2xhc3Nlc1xuICAgICAgICAgICAgICAgICAgICAvLyBwYXJzZXIgcG9zaXRpb24gb24gZmlyc3QgY2xvc2luZyBicmFja2V0IGFmdGVyICdhZHZlcnQnOlxuICAgICAgICAgICAgICAgICAgICAvLyBlLmcuICdkaXY6aGFzKC5iYW5uZXIsIDpjb250YWlucyhhZHZlcnQpKSdcbiAgICAgICAgICAgICAgICAgICAgdXBUb0Nsb3Nlc3QoY29udGV4dCwgTk9ERS5TRUxFQ1RPUik7XG4gICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgICAgIC8vIGZvciA6eHBhdGgoKVxuICAgICAgICAgICAgICAgICAgLy8gZXNsaW50LWRpc2FibGUtbmV4dC1saW5lIG1heC1sZW5cbiAgICAgICAgICAgICAgICAgIGlmIChjb250ZXh0LmV4dGVuZGVkUHNldWRvQnJhY2tldHNTdGFjay5sZW5ndGggPCBjb250ZXh0LmV4dGVuZGVkUHNldWRvTmFtZXNTdGFjay5sZW5ndGgpIHtcbiAgICAgICAgICAgICAgICAgICAgLy8gcmVtb3ZlIHN0YWNrZWQgbmFtZSBvZiBleHRlbmRlZCBwc2V1ZG8tY2xhc3NcbiAgICAgICAgICAgICAgICAgICAgLy8gaWYgdGhlcmUgYXJlIGxlc3MgYnJhY2tldHMgdGhhbiBwc2V1ZG8tY2xhc3MgbmFtZXNcbiAgICAgICAgICAgICAgICAgICAgLy8gd2l0aCBtZWFucyBsYXN0IHJlbW92ZXMgYnJhY2tldCB3YXMgY2xvc2luZyBmb3IgcHNldWRvLWNsYXNzXG4gICAgICAgICAgICAgICAgICAgIGNvbnRleHQuZXh0ZW5kZWRQc2V1ZG9OYW1lc1N0YWNrLnBvcCgpO1xuICAgICAgICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgICAgICAgLy8gb3RoZXJ3aXNlIHRoZSBicmFja2V0IGlzIHBhcnQgb2YgYXJnXG4gICAgICAgICAgICAgICAgICAgIHVwZGF0ZUJ1ZmZlck5vZGUoY29udGV4dCwgdG9rZW5WYWx1ZSk7XG4gICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIGlmIChpc1JlZ3VsYXJTZWxlY3Rvck5vZGUoYnVmZmVyTm9kZSkpIHtcbiAgICAgICAgICAgICAgaWYgKGNvbnRleHQuaXNBdHRyaWJ1dGVCcmFja2V0c09wZW4pIHtcbiAgICAgICAgICAgICAgICAvLyBwYXJlbnRoZXNlcyBpbnNpZGUgYXR0cmlidXRlIHZhbHVlIHNob3VsZCBiZSBwYXJ0IG9mIFJlZ3VsYXJTZWxlY3RvciB2YWx1ZVxuICAgICAgICAgICAgICAgIC8vIGUuZy4gJ2Rpdjpub3QoW2hyZWYqPVwid2luZG93LnByaW50KClcIl0pJyAgIDwtLSBwYXJzZXIgcG9zaXRpb25cbiAgICAgICAgICAgICAgICAvLyBpcyBvbiB0aGUgYClgIGFmdGVyIGBwcmludChgICAgICAgIOKGkVxuICAgICAgICAgICAgICAgIHVwZGF0ZUJ1ZmZlck5vZGUoY29udGV4dCwgdG9rZW5WYWx1ZSk7XG4gICAgICAgICAgICAgIH0gZWxzZSBpZiAoY29udGV4dC5zdGFuZGFyZFBzZXVkb05hbWVzU3RhY2subGVuZ3RoID4gMCAmJiBjb250ZXh0LnN0YW5kYXJkUHNldWRvQnJhY2tldHNTdGFjay5sZW5ndGggPiAwKSB7XG4gICAgICAgICAgICAgICAgLy8gc3RhbmRhcmQgcHNldWRvLWNsYXNzIHdhcyBwcm9jZXNzaW5nLlxuICAgICAgICAgICAgICAgIC8vIGNvbGxlY3QgdGhlIGNsb3NpbmcgYnJhY2tldCB0byB2YWx1ZSBvZiBSZWd1bGFyU2VsZWN0b3JcbiAgICAgICAgICAgICAgICAvLyBwYXJzZXIgcG9zaXRpb24gaXMgb24gYnJhY2tldCBhZnRlciAnY2xhc3MnIG5vdzpcbiAgICAgICAgICAgICAgICAvLyBlLmcuICdkaXY6d2hlcmUoLmNsYXNzKSdcbiAgICAgICAgICAgICAgICB1cGRhdGVCdWZmZXJOb2RlKGNvbnRleHQsIHRva2VuVmFsdWUpOyAvLyByZW1vdmUgYnJhY2tldCBhbmQgcHNldWRvIG5hbWUgZnJvbSBzdGFja3NcblxuICAgICAgICAgICAgICAgIGNvbnRleHQuc3RhbmRhcmRQc2V1ZG9CcmFja2V0c1N0YWNrLnBvcCgpO1xuICAgICAgICAgICAgICAgIGNvbnN0IGxhc3RTdGFuZGFyZFBzZXVkbyA9IGNvbnRleHQuc3RhbmRhcmRQc2V1ZG9OYW1lc1N0YWNrLnBvcCgpO1xuXG4gICAgICAgICAgICAgICAgaWYgKCFsYXN0U3RhbmRhcmRQc2V1ZG8pIHtcbiAgICAgICAgICAgICAgICAgIC8vIHN0YW5kYXJkIHBzZXVkbyBzaG91bGQgYmUgaW4gc3RhbmRhcmRQc2V1ZG9OYW1lc1N0YWNrXG4gICAgICAgICAgICAgICAgICAvLyBhcyByZWxhdGVkIHRvIHN0YW5kYXJkUHNldWRvQnJhY2tldHNTdGFja1xuICAgICAgICAgICAgICAgICAgdGhyb3cgbmV3IEVycm9yKGBQYXJzaW5nIGVycm9yLiBJbnZhbGlkIHNlbGVjdG9yOiAke3NlbGVjdG9yfWApO1xuICAgICAgICAgICAgICAgIH0gLy8gRGlzYWxsb3cgOmhhcygpIGFmdGVyIHJlZ3VsYXIgcHNldWRvLWVsZW1lbnRzXG4gICAgICAgICAgICAgICAgLy8gaHR0cHM6Ly9idWdzLmNocm9taXVtLm9yZy9wL2Nocm9taXVtL2lzc3Vlcy9kZXRhaWw/aWQ9NjY5MDU4I2M1NCBbM11cblxuXG4gICAgICAgICAgICAgICAgaWYgKE9iamVjdC52YWx1ZXMoUkVHVUxBUl9QU0VVRE9fRUxFTUVOVFMpLmluY2x1ZGVzKGxhc3RTdGFuZGFyZFBzZXVkbykgLy8gY2hlY2sgdG9rZW4gd2hpY2ggaXMgbmV4dCB0byBjbG9zaW5nIHBhcmVudGhlc2VzIGFuZCB0b2tlbiBhZnRlciBpdFxuICAgICAgICAgICAgICAgIC8vIHBhcnNlciBwb3NpdGlvbiBpcyBvbiBicmFja2V0IGFmdGVyICdmb28nIG5vdzpcbiAgICAgICAgICAgICAgICAvLyBlLmcuICc6OnBhcnQoZm9vKTpoYXMoLmEpJ1xuICAgICAgICAgICAgICAgICYmIG5leHRUb2tlblZhbHVlID09PSBDT0xPTiAmJiBuZXh0VG9OZXh0VG9rZW5WYWx1ZSAmJiBIQVNfUFNFVURPX0NMQVNTX01BUktFUlMuaW5jbHVkZXMobmV4dFRvTmV4dFRva2VuVmFsdWUpKSB7XG4gICAgICAgICAgICAgICAgICAvLyBlc2xpbnQtZGlzYWJsZS1uZXh0LWxpbmUgbWF4LWxlblxuICAgICAgICAgICAgICAgICAgdGhyb3cgbmV3IEVycm9yKGBVc2FnZSBvZiA6JHtuZXh0VG9OZXh0VG9rZW5WYWx1ZX0oKSBwc2V1ZG8tY2xhc3MgaXMgbm90IGFsbG93ZWQgYWZ0ZXIgYW55IHJlZ3VsYXIgcHNldWRvLWVsZW1lbnQ6ICcke2xhc3RTdGFuZGFyZFBzZXVkb30nYCk7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICAgIC8vIGV4dGVuZGVkIHBzZXVkby1jbGFzcyB3YXMgcHJvY2Vzc2luZy5cbiAgICAgICAgICAgICAgICAvLyBlLmcuICdkaXY6aGFzKGgzKSdcbiAgICAgICAgICAgICAgICAvLyByZW1vdmUgYnJhY2tldCBhbmQgcHNldWRvIG5hbWUgZnJvbSBzdGFja3NcbiAgICAgICAgICAgICAgICBjb250ZXh0LmV4dGVuZGVkUHNldWRvQnJhY2tldHNTdGFjay5wb3AoKTtcbiAgICAgICAgICAgICAgICBjb250ZXh0LmV4dGVuZGVkUHNldWRvTmFtZXNTdGFjay5wb3AoKTtcbiAgICAgICAgICAgICAgICB1cFRvQ2xvc2VzdChjb250ZXh0LCBOT0RFLkVYVEVOREVEX1NFTEVDVE9SKTsgLy8gZ28gdG8gdXBwZXIgc2VsZWN0b3IgZm9yIHBvc3NpYmxlIHNlbGVjdG9yIGNvbnRpbnVhdGlvbiBhZnRlciBleHRlbmRlZCBwc2V1ZG8tY2xhc3NcbiAgICAgICAgICAgICAgICAvLyBlLmcuICdkaXY6aGFzKGgzKSA+IGltZydcblxuICAgICAgICAgICAgICAgIHVwVG9DbG9zZXN0KGNvbnRleHQsIE5PREUuU0VMRUNUT1IpO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIGlmIChpc1NlbGVjdG9yTm9kZShidWZmZXJOb2RlKSkge1xuICAgICAgICAgICAgICAvLyBhZnRlciBpbm5lciBleHRlbmRlZCBwc2V1ZG8tY2xhc3MgYnVmZmVyTm9kZSBpcyBTZWxlY3Rvci5cbiAgICAgICAgICAgICAgLy8gcGFyc2VyIHBvc2l0aW9uIGlzIG9uIGxhc3QgYnJhY2tldCBub3c6XG4gICAgICAgICAgICAgIC8vIGUuZy4gJ2RpdjpoYXMoLmJhbm5lciwgOmNvbnRhaW5zKGFkcykpJ1xuICAgICAgICAgICAgICBjb250ZXh0LmV4dGVuZGVkUHNldWRvQnJhY2tldHNTdGFjay5wb3AoKTtcbiAgICAgICAgICAgICAgY29udGV4dC5leHRlbmRlZFBzZXVkb05hbWVzU3RhY2sucG9wKCk7XG4gICAgICAgICAgICAgIHVwVG9DbG9zZXN0KGNvbnRleHQsIE5PREUuRVhURU5ERURfU0VMRUNUT1IpO1xuICAgICAgICAgICAgICB1cFRvQ2xvc2VzdChjb250ZXh0LCBOT0RFLlNFTEVDVE9SKTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgaWYgKGlzUmVsYXRpdmVQc2V1ZG9DbGFzc05vZGUoYnVmZmVyTm9kZSkpIHtcbiAgICAgICAgICAgICAgLy8gc2F2ZSBvcGVuaW5nIGJyYWNrZXQgZm9yIGJhbGFuY2luZ1xuICAgICAgICAgICAgICAvLyBlLmcuICdkaXY6bm90KCknICAvLyBwb3NpdGlvbiBpcyBvbiBgKWBcbiAgICAgICAgICAgICAgLy8gY29udGV4dC5leHRlbmRlZFBzZXVkb0JyYWNrZXRzU3RhY2sucHVzaCh0b2tlblZhbHVlKTtcbiAgICAgICAgICAgICAgaWYgKGNvbnRleHQuZXh0ZW5kZWRQc2V1ZG9OYW1lc1N0YWNrLmxlbmd0aCA+IDAgJiYgY29udGV4dC5leHRlbmRlZFBzZXVkb0JyYWNrZXRzU3RhY2subGVuZ3RoID4gMCkge1xuICAgICAgICAgICAgICAgIGNvbnRleHQuZXh0ZW5kZWRQc2V1ZG9CcmFja2V0c1N0YWNrLnBvcCgpO1xuICAgICAgICAgICAgICAgIGNvbnRleHQuZXh0ZW5kZWRQc2V1ZG9OYW1lc1N0YWNrLnBvcCgpO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIGJyZWFrO1xuXG4gICAgICAgICAgY2FzZSBMSU5FX0ZFRUQ6XG4gICAgICAgICAgY2FzZSBGT1JNX0ZFRUQ6XG4gICAgICAgICAgY2FzZSBDQVJSSUFHRV9SRVRVUk46XG4gICAgICAgICAgICAvLyBzdWNoIGNoYXJhY3RlcnMgYXQgc3RhcnQgYW5kIGVuZCBvZiBzZWxlY3RvciBzaG91bGQgYmUgdHJpbW1lZFxuICAgICAgICAgICAgLy8gc28gaXMgdGhlcmUgaXMgb25lIHRoZW0gYW1vbmcgdG9rZW5zLCBpdCBpcyBub3QgdmFsaWQgc2VsZWN0b3JcbiAgICAgICAgICAgIHRocm93IG5ldyBFcnJvcihgJyR7c2VsZWN0b3J9JyBpcyBub3QgYSB2YWxpZCBzZWxlY3RvcmApO1xuXG4gICAgICAgICAgY2FzZSBUQUI6XG4gICAgICAgICAgICAvLyBhbGxvdyB0YWIgb25seSBpbnNpZGUgYXR0cmlidXRlIHZhbHVlXG4gICAgICAgICAgICAvLyBhcyB0aGVyZSBhcmUgc3VjaCB2YWxpZCBydWxlcyBpbiBmaWx0ZXIgbGlzdHNcbiAgICAgICAgICAgIC8vIGUuZy4gJ2RpdltzdHlsZV49XCJtYXJnaW4tcmlnaHQ6IGF1dG87XHR0ZXh0LWFsaWduOiBsZWZ0OycsXG4gICAgICAgICAgICAvLyBwYXJzZXIgcG9zaXRpb24gICAgICAgICAgICAgICAgICAgICAg4oaRXG4gICAgICAgICAgICBpZiAoaXNSZWd1bGFyU2VsZWN0b3JOb2RlKGJ1ZmZlck5vZGUpICYmIGNvbnRleHQuaXNBdHRyaWJ1dGVCcmFja2V0c09wZW4pIHtcbiAgICAgICAgICAgICAgdXBkYXRlQnVmZmVyTm9kZShjb250ZXh0LCB0b2tlblZhbHVlKTtcbiAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgIC8vIG90aGVyd2lzZSBub3QgdmFsaWRcbiAgICAgICAgICAgICAgdGhyb3cgbmV3IEVycm9yKGAnJHtzZWxlY3Rvcn0nIGlzIG5vdCBhIHZhbGlkIHNlbGVjdG9yYCk7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgfVxuXG4gICAgICAgIGJyZWFrO1xuICAgICAgLy8gbm8gZGVmYXVsdCBzdGF0ZW1lbnQgZm9yIE1hcmtzIGFzIHRoZXkgYXJlIGxpbWl0ZWQgdG8gU1VQUE9SVEVEX1NFTEVDVE9SX01BUktTXG4gICAgICAvLyBhbmQgYWxsIG90aGVyIHN5bWJvbCBjb21iaW5hdGlvbnMgYXJlIHRva2VuaXplZCBhcyBXb3JkXG4gICAgICAvLyBzbyBlcnJvciBmb3IgaW52YWxpZCBXb3JkIHdpbGwgYmUgdGhyb3duIGxhdGVyIHdoaWxlIGVsZW1lbnQgc2VsZWN0aW5nIGJ5IHBhcnNlZCBhc3RcblxuICAgICAgZGVmYXVsdDpcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKGBVbmtub3duIHR5cGUgb2YgdG9rZW46ICcke3Rva2VuVmFsdWV9J2ApO1xuICAgIH1cblxuICAgIGkgKz0gMTtcbiAgfVxuXG4gIGlmIChjb250ZXh0LmFzdCA9PT0gbnVsbCkge1xuICAgIHRocm93IG5ldyBFcnJvcihgJyR7c2VsZWN0b3J9JyBpcyBub3QgYSB2YWxpZCBzZWxlY3RvcmApO1xuICB9XG5cbiAgaWYgKGNvbnRleHQuZXh0ZW5kZWRQc2V1ZG9OYW1lc1N0YWNrLmxlbmd0aCA+IDAgfHwgY29udGV4dC5leHRlbmRlZFBzZXVkb0JyYWNrZXRzU3RhY2subGVuZ3RoID4gMCkge1xuICAgIC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBtYXgtbGVuXG4gICAgdGhyb3cgbmV3IEVycm9yKGBVbmJhbGFuY2VkIGJyYWNrZXRzIGZvciBleHRlbmRlZCBwc2V1ZG8tY2xhc3M6ICcke2dldExhc3QoY29udGV4dC5leHRlbmRlZFBzZXVkb05hbWVzU3RhY2spfSdgKTtcbiAgfVxuXG4gIGlmIChjb250ZXh0LmlzQXR0cmlidXRlQnJhY2tldHNPcGVuKSB7XG4gICAgdGhyb3cgbmV3IEVycm9yKGBVbmJhbGFuY2VkIGF0dHJpYnV0ZSBicmFja2V0cyBpbiBzZWxlY3RvcjogJyR7c2VsZWN0b3J9J2ApO1xuICB9XG5cbiAgcmV0dXJuIGNvbnRleHQuc2hvdWxkT3B0aW1pemUgPyBvcHRpbWl6ZUFzdChjb250ZXh0LmFzdCkgOiBjb250ZXh0LmFzdDtcbn07XG5cbmNvbnN0IG5hdGl2ZXMgPSB7XG4gIE11dGF0aW9uT2JzZXJ2ZXI6IHdpbmRvdy5NdXRhdGlvbk9ic2VydmVyIHx8IHdpbmRvdy5XZWJLaXRNdXRhdGlvbk9ic2VydmVyXG59O1xuLyoqXG4gKiBDbGFzcyBOYXRpdmVUZXh0Q29udGVudCBpcyBuZWVkZWQgdG8gaW50ZXJjZXB0IGFuZCBzYXZlIHRoZSBuYXRpdmUgTm9kZSB0ZXh0Q29udGVudCBnZXR0ZXJcbiAqIGZvciBwcm9wZXIgd29yayBvZiA6Y29udGFpbnMoKSBwc2V1ZG8tY2xhc3MgYXMgaXQgbWF5IGJlIG1vY2tlZC5cbiAqXG4gKiBAc2VlIHtAbGluayBodHRwczovL2dpdGh1Yi5jb20vQWRndWFyZFRlYW0vRXh0ZW5kZWRDc3MvaXNzdWVzLzEyN31cbiAqL1xuXG5jbGFzcyBOYXRpdmVUZXh0Q29udGVudCB7XG4gIC8qKlxuICAgKiBOYXRpdmUgTm9kZS5cbiAgICovXG5cbiAgLyoqXG4gICAqIE5hdGl2ZSBOb2RlIHRleHRDb250ZW50IGdldHRlci5cbiAgICovXG5cbiAgLyoqXG4gICAqIFN0b3JlcyBuYXRpdmUgbm9kZS5cbiAgICovXG4gIGNvbnN0cnVjdG9yKCkge1xuICAgIHRoaXMubmF0aXZlTm9kZSA9IHdpbmRvdy5Ob2RlIHx8IE5vZGU7XG4gIH1cbiAgLyoqXG4gICAqIFNldHMgbmF0aXZlIE5vZGUgdGV4dENvbnRleHQgZ2V0dGVyIHRvIGBnZXR0ZXJgIGNsYXNzIGZpZWxkLlxuICAgKi9cblxuXG4gIHNldEdldHRlcigpIHtcbiAgICB2YXIgX09iamVjdCRnZXRPd25Qcm9wZXJ0O1xuXG4gICAgdGhpcy5nZXR0ZXIgPSAoX09iamVjdCRnZXRPd25Qcm9wZXJ0ID0gT2JqZWN0LmdldE93blByb3BlcnR5RGVzY3JpcHRvcih0aGlzLm5hdGl2ZU5vZGUucHJvdG90eXBlLCAndGV4dENvbnRlbnQnKSkgPT09IG51bGwgfHwgX09iamVjdCRnZXRPd25Qcm9wZXJ0ID09PSB2b2lkIDAgPyB2b2lkIDAgOiBfT2JqZWN0JGdldE93blByb3BlcnQuZ2V0O1xuICB9XG5cbn1cbmNvbnN0IG5hdGl2ZVRleHRDb250ZW50ID0gbmV3IE5hdGl2ZVRleHRDb250ZW50KCk7XG5cbi8qKlxuICogUmV0dXJucyB0ZXh0Q29udGVudCBvZiBwYXNzZWQgZG9tRWxlbWVudC5cbiAqXG4gKiBAcGFyYW0gZG9tRWxlbWVudCBET00gZWxlbWVudC5cbiAqXG4gKiBAcmV0dXJucyBET00gZWxlbWVudCB0ZXh0Q29udGVudC5cbiAqL1xuXG5jb25zdCBnZXROb2RlVGV4dENvbnRlbnQgPSBkb21FbGVtZW50ID0+IHtcbiAgaWYgKG5hdGl2ZVRleHRDb250ZW50LmdldHRlcikge1xuICAgIHJldHVybiBuYXRpdmVUZXh0Q29udGVudC5nZXR0ZXIuYXBwbHkoZG9tRWxlbWVudCk7XG4gIH0gLy8gaWYgRXh0ZW5kZWRDc3MuaW5pdCgpIGhhcyBub3QgYmVlbiBleGVjdXRlZCBhbmQgdGhlcmUgaXMgbm8gbm9kZVRleHRDb250ZW50R2V0dGVyLFxuICAvLyB1c2Ugc2ltcGxlIGFwcHJvYWNoLCBlc3BlY2lhbGx5IHdoZW4gaW5pdCgpIGlzIG5vdCByZWFsbHkgbmVlZGVkLCBlLmcuIGxvY2FsIHRlc3RzXG5cblxuICByZXR1cm4gZG9tRWxlbWVudC50ZXh0Q29udGVudCB8fCAnJztcbn07XG4vKipcbiAqIFJldHVybnMgZWxlbWVudCBzZWxlY3RvciB0ZXh0IGJhc2VkIG9uIGl0J3MgdGFnTmFtZSBhbmQgYXR0cmlidXRlcy5cbiAqXG4gKiBAcGFyYW0gZWxlbWVudCBET00gZWxlbWVudC5cbiAqXG4gKiBAcmV0dXJucyBTdHJpbmcgcmVwcmVzZW50YXRpb24gb2YgYGVsZW1lbnRgLlxuICovXG5cbmNvbnN0IGdldEVsZW1lbnRTZWxlY3RvckRlc2MgPSBlbGVtZW50ID0+IHtcbiAgbGV0IHNlbGVjdG9yVGV4dCA9IGVsZW1lbnQudGFnTmFtZS50b0xvd2VyQ2FzZSgpO1xuICBzZWxlY3RvclRleHQgKz0gQXJyYXkuZnJvbShlbGVtZW50LmF0dHJpYnV0ZXMpLm1hcChhdHRyID0+IHtcbiAgICByZXR1cm4gYFske2F0dHIubmFtZX09XCIke2VsZW1lbnQuZ2V0QXR0cmlidXRlKGF0dHIubmFtZSl9XCJdYDtcbiAgfSkuam9pbignJyk7XG4gIHJldHVybiBzZWxlY3RvclRleHQ7XG59O1xuLyoqXG4gKiBSZXR1cm5zIHBhdGggdG8gYSBET00gZWxlbWVudCBhcyBhIHNlbGVjdG9yIHN0cmluZy5cbiAqXG4gKiBAcGFyYW0gaW5wdXRFbCBJbnB1dCBlbGVtZW50LlxuICpcbiAqIEByZXR1cm5zIFN0cmluZyBwYXRoIHRvIGEgRE9NIGVsZW1lbnQuXG4gKiBAdGhyb3dzIEFuIGVycm9yIGlmIGBpbnB1dEVsYCBpbiBub3QgaW5zdGFuY2Ugb2YgYEVsZW1lbnRgLlxuICovXG5cbmNvbnN0IGdldEVsZW1lbnRTZWxlY3RvclBhdGggPSBpbnB1dEVsID0+IHtcbiAgaWYgKCEoaW5wdXRFbCBpbnN0YW5jZW9mIEVsZW1lbnQpKSB7XG4gICAgdGhyb3cgbmV3IEVycm9yKCdGdW5jdGlvbiByZWNlaXZlZCBhcmd1bWVudCB3aXRoIHdyb25nIHR5cGUnKTtcbiAgfVxuXG4gIGxldCBlbDtcbiAgZWwgPSBpbnB1dEVsO1xuICBjb25zdCBwYXRoID0gW107IC8vIHdlIG5lZWQgdG8gY2hlY2sgJyEhZWwnIGZpcnN0IGJlY2F1c2UgaXQgaXMgcG9zc2libGVcbiAgLy8gdGhhdCBzb21lIGFuY2VzdG9yIG9mIHRoZSBpbnB1dEVsIHdhcyByZW1vdmVkIGJlZm9yZSBpdFxuXG4gIHdoaWxlICghIWVsICYmIGVsLm5vZGVUeXBlID09PSBOb2RlLkVMRU1FTlRfTk9ERSkge1xuICAgIGxldCBzZWxlY3RvciA9IGVsLm5vZGVOYW1lLnRvTG93ZXJDYXNlKCk7XG5cbiAgICBpZiAoZWwuaWQgJiYgdHlwZW9mIGVsLmlkID09PSAnc3RyaW5nJykge1xuICAgICAgc2VsZWN0b3IgKz0gYCMke2VsLmlkfWA7XG4gICAgICBwYXRoLnVuc2hpZnQoc2VsZWN0b3IpO1xuICAgICAgYnJlYWs7XG4gICAgfVxuXG4gICAgbGV0IHNpYmxpbmcgPSBlbDtcbiAgICBsZXQgbnRoID0gMTtcblxuICAgIHdoaWxlIChzaWJsaW5nLnByZXZpb3VzRWxlbWVudFNpYmxpbmcpIHtcbiAgICAgIHNpYmxpbmcgPSBzaWJsaW5nLnByZXZpb3VzRWxlbWVudFNpYmxpbmc7XG5cbiAgICAgIGlmIChzaWJsaW5nLm5vZGVUeXBlID09PSBOb2RlLkVMRU1FTlRfTk9ERSAmJiBzaWJsaW5nLm5vZGVOYW1lLnRvTG93ZXJDYXNlKCkgPT09IHNlbGVjdG9yKSB7XG4gICAgICAgIG50aCArPSAxO1xuICAgICAgfVxuICAgIH1cblxuICAgIGlmIChudGggIT09IDEpIHtcbiAgICAgIHNlbGVjdG9yICs9IGA6bnRoLW9mLXR5cGUoJHtudGh9KWA7XG4gICAgfVxuXG4gICAgcGF0aC51bnNoaWZ0KHNlbGVjdG9yKTtcbiAgICBlbCA9IGVsLnBhcmVudEVsZW1lbnQ7XG4gIH1cblxuICByZXR1cm4gcGF0aC5qb2luKCcgPiAnKTtcbn07XG4vKipcbiAqIENoZWNrcyB3aGV0aGVyIHRoZSBlbGVtZW50IGlzIGluc3RhbmNlIG9mIEhUTUxFbGVtZW50LlxuICpcbiAqIEBwYXJhbSBlbGVtZW50IEVsZW1lbnQgdG8gY2hlY2suXG4gKlxuICogQHJldHVybnMgVHJ1ZSBpZiBgZWxlbWVudGAgaXMgSFRNTEVsZW1lbnQuXG4gKi9cblxuY29uc3QgaXNIdG1sRWxlbWVudCA9IGVsZW1lbnQgPT4ge1xuICByZXR1cm4gZWxlbWVudCBpbnN0YW5jZW9mIEhUTUxFbGVtZW50O1xufTtcbi8qKlxuICogVGFrZXMgYGVsZW1lbnRgIGFuZCByZXR1cm5zIGl0cyBwYXJlbnQgZWxlbWVudC5cbiAqXG4gKiBAcGFyYW0gZWxlbWVudCBFbGVtZW50LlxuICogQHBhcmFtIGVycm9yTWVzc2FnZSBPcHRpb25hbCBlcnJvciBtZXNzYWdlIHRvIHRocm93LlxuICpcbiAqIEByZXR1cm5zIFBhcmVudCBvZiBgZWxlbWVudGAuXG4gKiBAdGhyb3dzIEFuIGVycm9yIGlmIGVsZW1lbnQgaGFzIG5vIHBhcmVudCBlbGVtZW50LlxuICovXG5cbmNvbnN0IGdldFBhcmVudCA9IChlbGVtZW50LCBlcnJvck1lc3NhZ2UpID0+IHtcbiAgY29uc3Qge1xuICAgIHBhcmVudEVsZW1lbnRcbiAgfSA9IGVsZW1lbnQ7XG5cbiAgaWYgKCFwYXJlbnRFbGVtZW50KSB7XG4gICAgdGhyb3cgbmV3IEVycm9yKGVycm9yTWVzc2FnZSB8fCAnRWxlbWVudCBkb2VzIG5vIGhhdmUgcGFyZW50IGVsZW1lbnQnKTtcbiAgfVxuXG4gIHJldHVybiBwYXJlbnRFbGVtZW50O1xufTtcblxuLyoqXG4gKiBDaGVja3Mgd2hldGhlciB0aGUgYGVycm9yYCBoYXMgYG1lc3NhZ2VgIHByb3BlcnR5IHdoaWNoIHR5cGUgaXMgc3RyaW5nLlxuICpcbiAqIEBwYXJhbSBlcnJvciBFcnJvciBvYmplY3QuXG4gKlxuICogQHJldHVybnMgVHJ1ZSBpZiBgZXJyb3JgIGhhcyBtZXNzYWdlLlxuICovXG5jb25zdCBpc0Vycm9yV2l0aE1lc3NhZ2UgPSBlcnJvciA9PiB7XG4gIHJldHVybiB0eXBlb2YgZXJyb3IgPT09ICdvYmplY3QnICYmIGVycm9yICE9PSBudWxsICYmICdtZXNzYWdlJyBpbiBlcnJvciAmJiB0eXBlb2YgZXJyb3IubWVzc2FnZSA9PT0gJ3N0cmluZyc7XG59O1xuLyoqXG4gKiBDb252ZXJ0cyBgbWF5YmVFcnJvcmAgdG8gZXJyb3Igb2JqZWN0IHdpdGggbWVzc2FnZS5cbiAqXG4gKiBAcGFyYW0gbWF5YmVFcnJvciBQb3NzaWJsZSBlcnJvci5cbiAqXG4gKiBAcmV0dXJucyBFcnJvciBvYmplY3Qgd2l0aCBkZWZpbmVkIGBtZXNzYWdlYCBwcm9wZXJ0eS5cbiAqL1xuXG5cbmNvbnN0IHRvRXJyb3JXaXRoTWVzc2FnZSA9IG1heWJlRXJyb3IgPT4ge1xuICBpZiAoaXNFcnJvcldpdGhNZXNzYWdlKG1heWJlRXJyb3IpKSB7XG4gICAgcmV0dXJuIG1heWJlRXJyb3I7XG4gIH1cblxuICB0cnkge1xuICAgIHJldHVybiBuZXcgRXJyb3IoSlNPTi5zdHJpbmdpZnkobWF5YmVFcnJvcikpO1xuICB9IGNhdGNoIHtcbiAgICAvLyBmYWxsYmFjayBpbiBjYXNlIGlmIHRoZXJlIGlzIGFuIGVycm9yIGhhcHBlbmVkIGR1cmluZyB0aGUgbWF5YmVFcnJvciBzdHJpbmdpZnlpbmdcbiAgICAvLyBsaWtlIHdpdGggY2lyY3VsYXIgcmVmZXJlbmNlcyBmb3IgZXhhbXBsZVxuICAgIHJldHVybiBuZXcgRXJyb3IoU3RyaW5nKG1heWJlRXJyb3IpKTtcbiAgfVxufTtcbi8qKlxuICogUmV0dXJucyBlcnJvciBtZXNzYWdlIGZyb20gYGVycm9yYC5cbiAqIE1heSBiZSBoZWxwZnVsIHRvIGhhbmRsZSBjYXVnaHQgZXJyb3JzLlxuICpcbiAqIEBwYXJhbSBlcnJvciBFcnJvciBvYmplY3QuXG4gKlxuICogQHJldHVybnMgTWVzc2FnZSBvZiBgZXJyb3JgLlxuICovXG5cblxuY29uc3QgZ2V0RXJyb3JNZXNzYWdlID0gZXJyb3IgPT4ge1xuICByZXR1cm4gdG9FcnJvcldpdGhNZXNzYWdlKGVycm9yKS5tZXNzYWdlO1xufTtcblxuY29uc3QgbG9nZ2VyID0ge1xuICAvKipcbiAgICogU2FmZSBjb25zb2xlLmVycm9yIHZlcnNpb24uXG4gICAqL1xuICBlcnJvcjogdHlwZW9mIGNvbnNvbGUgIT09ICd1bmRlZmluZWQnICYmIGNvbnNvbGUuZXJyb3IgJiYgY29uc29sZS5lcnJvci5iaW5kID8gY29uc29sZS5lcnJvci5iaW5kKHdpbmRvdy5jb25zb2xlKSA6IGNvbnNvbGUuZXJyb3IsXG5cbiAgLyoqXG4gICAqIFNhZmUgY29uc29sZS5pbmZvIHZlcnNpb24uXG4gICAqL1xuICBpbmZvOiB0eXBlb2YgY29uc29sZSAhPT0gJ3VuZGVmaW5lZCcgJiYgY29uc29sZS5pbmZvICYmIGNvbnNvbGUuaW5mby5iaW5kID8gY29uc29sZS5pbmZvLmJpbmQod2luZG93LmNvbnNvbGUpIDogY29uc29sZS5pbmZvXG59O1xuXG4vKipcbiAqIFJldHVybnMgc3RyaW5nIHdpdGhvdXQgc3VmZml4LlxuICpcbiAqIEBwYXJhbSBzdHIgSW5wdXQgc3RyaW5nLlxuICogQHBhcmFtIHN1ZmZpeCBOZWVkZWQgdG8gcmVtb3ZlLlxuICpcbiAqIEByZXR1cm5zIFN0cmluZyB3aXRob3V0IHN1ZmZpeC5cbiAqL1xuXG5jb25zdCByZW1vdmVTdWZmaXggPSAoc3RyLCBzdWZmaXgpID0+IHtcbiAgY29uc3QgaW5kZXggPSBzdHIuaW5kZXhPZihzdWZmaXgsIHN0ci5sZW5ndGggLSBzdWZmaXgubGVuZ3RoKTtcblxuICBpZiAoaW5kZXggPj0gMCkge1xuICAgIHJldHVybiBzdHIuc3Vic3RyaW5nKDAsIGluZGV4KTtcbiAgfVxuXG4gIHJldHVybiBzdHI7XG59O1xuLyoqXG4gKiBSZXBsYWNlcyBhbGwgYHBhdHRlcm5gcyB3aXRoIGByZXBsYWNlbWVudGAgaW4gYGlucHV0YCBzdHJpbmcuXG4gKiBTdHJpbmcucmVwbGFjZUFsbCgpIHBvbHlmaWxsIGJlY2F1c2UgaXQgaXMgbm90IHN1cHBvcnRlZCBieSBvbGQgYnJvd3NlcnMsIGUuZy4gQ2hyb21lIDU1LlxuICpcbiAqIEBzZWUge0BsaW5rIGh0dHBzOi8vY2FuaXVzZS5jb20vP3NlYXJjaD1TdHJpbmcucmVwbGFjZUFsbH1cbiAqXG4gKiBAcGFyYW0gaW5wdXQgSW5wdXQgc3RyaW5nIHRvIHByb2Nlc3MuXG4gKiBAcGFyYW0gcGF0dGVybiBGaW5kIGluIHRoZSBpbnB1dCBzdHJpbmcuXG4gKiBAcGFyYW0gcmVwbGFjZW1lbnQgUmVwbGFjZSB0aGUgcGF0dGVybiB3aXRoLlxuICpcbiAqIEByZXR1cm5zIE1vZGlmaWVkIHN0cmluZy5cbiAqL1xuXG5jb25zdCByZXBsYWNlQWxsID0gKGlucHV0LCBwYXR0ZXJuLCByZXBsYWNlbWVudCkgPT4ge1xuICBpZiAoIWlucHV0KSB7XG4gICAgcmV0dXJuIGlucHV0O1xuICB9XG5cbiAgcmV0dXJuIGlucHV0LnNwbGl0KHBhdHRlcm4pLmpvaW4ocmVwbGFjZW1lbnQpO1xufTtcbi8qKlxuICogQ29udmVydHMgc3RyaW5nIHBhdHRlcm4gdG8gcmVndWxhciBleHByZXNzaW9uLlxuICpcbiAqIEBwYXJhbSBzdHIgU3RyaW5nIHRvIGNvbnZlcnQuXG4gKlxuICogQHJldHVybnMgUmVndWxhciBleHByZXNzaW9uIGNvbnZlcnRlZCBmcm9tIHBhdHRlcm4gYHN0cmAuXG4gKi9cblxuY29uc3QgdG9SZWdFeHAgPSBzdHIgPT4ge1xuICBpZiAoc3RyLnN0YXJ0c1dpdGgoU0xBU0gpICYmIHN0ci5lbmRzV2l0aChTTEFTSCkpIHtcbiAgICByZXR1cm4gbmV3IFJlZ0V4cChzdHIuc2xpY2UoMSwgLTEpKTtcbiAgfVxuXG4gIGNvbnN0IGVzY2FwZWQgPSBzdHIucmVwbGFjZSgvWy4qKz9eJHt9KCl8W1xcXVxcXFxdL2csICdcXFxcJCYnKTtcbiAgcmV0dXJuIG5ldyBSZWdFeHAoZXNjYXBlZCk7XG59O1xuLyoqXG4gKiBDb252ZXJ0cyBhbnkgc2ltcGxlIHR5cGUgdmFsdWUgdG8gc3RyaW5nIHR5cGUsXG4gKiBlLmcuIGB1bmRlZmluZWRgIC0+IGAndW5kZWZpbmVkJ2AuXG4gKlxuICogQHBhcmFtIHZhbHVlIEFueSB0eXBlIHZhbHVlLlxuICpcbiAqIEByZXR1cm5zIFN0cmluZyByZXByZXNlbnRhdGlvbiBvZiBgdmFsdWVgLlxuICovXG5cbmNvbnN0IGNvbnZlcnRUeXBlSW50b1N0cmluZyA9IHZhbHVlID0+IHtcbiAgbGV0IG91dHB1dDtcblxuICBzd2l0Y2ggKHZhbHVlKSB7XG4gICAgY2FzZSB1bmRlZmluZWQ6XG4gICAgICBvdXRwdXQgPSAndW5kZWZpbmVkJztcbiAgICAgIGJyZWFrO1xuXG4gICAgY2FzZSBudWxsOlxuICAgICAgb3V0cHV0ID0gJ251bGwnO1xuICAgICAgYnJlYWs7XG5cbiAgICBkZWZhdWx0OlxuICAgICAgb3V0cHV0ID0gdmFsdWUudG9TdHJpbmcoKTtcbiAgfVxuXG4gIHJldHVybiBvdXRwdXQ7XG59O1xuLyoqXG4gKiBDb252ZXJ0cyBpbnN0YW5jZSBvZiBzdHJpbmcgdmFsdWUgaW50byBvdGhlciBzaW1wbGUgdHlwZXMsXG4gKiBlLmcuIGAnbnVsbCdgIC0+IGBudWxsYCwgYCd0cnVlJ2AgLT4gYHRydWVgLlxuICpcbiAqIEBwYXJhbSB2YWx1ZSBTdHJpbmctdHlwZSB2YWx1ZS5cbiAqXG4gKiBAcmV0dXJucyBJdHMgb3duIHR5cGUgcmVwcmVzZW50YXRpb24gb2Ygc3RyaW5nLXR5cGUgYHZhbHVlYC5cbiAqL1xuXG5jb25zdCBjb252ZXJ0VHlwZUZyb21TdHJpbmcgPSB2YWx1ZSA9PiB7XG4gIGNvbnN0IG51bVZhbHVlID0gTnVtYmVyKHZhbHVlKTtcbiAgbGV0IG91dHB1dDtcblxuICBpZiAoIU51bWJlci5pc05hTihudW1WYWx1ZSkpIHtcbiAgICBvdXRwdXQgPSBudW1WYWx1ZTtcbiAgfSBlbHNlIHtcbiAgICBzd2l0Y2ggKHZhbHVlKSB7XG4gICAgICBjYXNlICd1bmRlZmluZWQnOlxuICAgICAgICBvdXRwdXQgPSB1bmRlZmluZWQ7XG4gICAgICAgIGJyZWFrO1xuXG4gICAgICBjYXNlICdudWxsJzpcbiAgICAgICAgb3V0cHV0ID0gbnVsbDtcbiAgICAgICAgYnJlYWs7XG5cbiAgICAgIGNhc2UgJ3RydWUnOlxuICAgICAgICBvdXRwdXQgPSB0cnVlO1xuICAgICAgICBicmVhaztcblxuICAgICAgY2FzZSAnZmFsc2UnOlxuICAgICAgICBvdXRwdXQgPSBmYWxzZTtcbiAgICAgICAgYnJlYWs7XG5cbiAgICAgIGRlZmF1bHQ6XG4gICAgICAgIG91dHB1dCA9IHZhbHVlO1xuICAgIH1cbiAgfVxuXG4gIHJldHVybiBvdXRwdXQ7XG59O1xuXG5jb25zdCBTQUZBUklfVVNFUl9BR0VOVF9SRUdFWFAgPSAvXFxzVmVyc2lvblxcLyhcXGR7Mn1cXC5cXGQpKC4rXFxzfFxccykoU2FmYXJpKVxcLy87XG5jb25zdCBpc1NhZmFyaUJyb3dzZXIgPSBTQUZBUklfVVNFUl9BR0VOVF9SRUdFWFAudGVzdChuYXZpZ2F0b3IudXNlckFnZW50KTtcbi8qKlxuICogQ2hlY2tzIHdoZXRoZXIgdGhlIGJyb3dzZXIgdXNlckFnZW50IGlzIHN1cHBvcnRlZC5cbiAqXG4gKiBAcGFyYW0gdXNlckFnZW50IFVzZXIgYWdlbnQgb2YgYnJvd3Nlci5cbiAqXG4gKiBAcmV0dXJucyBGYWxzZSBvbmx5IGZvciBJbnRlcm5ldCBFeHBsb3Jlci5cbiAqL1xuXG5jb25zdCBpc1VzZXJBZ2VudFN1cHBvcnRlZCA9IHVzZXJBZ2VudCA9PiB7XG4gIC8vIGRvIG5vdCBzdXBwb3J0IEludGVybmV0IEV4cGxvcmVyXG4gIGlmICh1c2VyQWdlbnQuaW5jbHVkZXMoJ01TSUUnKSB8fCB1c2VyQWdlbnQuaW5jbHVkZXMoJ1RyaWRlbnQvJykpIHtcbiAgICByZXR1cm4gZmFsc2U7XG4gIH1cblxuICByZXR1cm4gdHJ1ZTtcbn07XG4vKipcbiAqIENoZWNrcyB3aGV0aGVyIHRoZSBjdXJyZW50IGJyb3dzZXIgaXMgc3VwcG9ydGVkLlxuICpcbiAqIEByZXR1cm5zIEZhbHNlIGZvciBJbnRlcm5ldCBFeHBsb3Jlciwgb3RoZXJ3aXNlIHRydWUuXG4gKi9cblxuY29uc3QgaXNCcm93c2VyU3VwcG9ydGVkID0gKCkgPT4ge1xuICByZXR1cm4gaXNVc2VyQWdlbnRTdXBwb3J0ZWQobmF2aWdhdG9yLnVzZXJBZ2VudCk7XG59O1xuXG4vKipcbiAqIENTU19QUk9QRVJUWSBpcyBuZWVkZWQgZm9yIHN0eWxlIHZhbHVlcyBub3JtYWxpemF0aW9uLlxuICpcbiAqIElNUE9SVEFOVDogaXQgaXMgdXNlZCBhcyAnY29uc3QnIGluc3RlYWQgb2YgJ2VudW0nIHRvIGF2b2lkIHNpZGUgZWZmZWN0c1xuICogZHVyaW5nIEV4dGVuZGVkQ3NzIGltcG9ydCBpbnRvIG90aGVyIGxpYnJhcmllcy5cbiAqL1xuXG5jb25zdCBDU1NfUFJPUEVSVFkgPSB7XG4gIEJBQ0tHUk9VTkQ6ICdiYWNrZ3JvdW5kJyxcbiAgQkFDS0dST1VORF9JTUFHRTogJ2JhY2tncm91bmQtaW1hZ2UnLFxuICBDT05URU5UOiAnY29udGVudCcsXG4gIE9QQUNJVFk6ICdvcGFjaXR5J1xufTtcbmNvbnN0IFJFR0VYUF9BTllfU1lNQk9MID0gJy4qJztcbmNvbnN0IFJFR0VYUF9XSVRIX0ZMQUdTX1JFR0VYUCA9IC9eXFxzKlxcLy4qXFwvW2dtaXN1eV0qXFxzKiQvO1xuXG4vKipcbiAqIFJlbW92ZXMgcXVvdGVzIGZvciBzcGVjaWZpZWQgY29udGVudCB2YWx1ZS5cbiAqXG4gKiBGb3IgZXhhbXBsZSwgY29udGVudCBzdHlsZSBkZWNsYXJhdGlvbiB3aXRoIGA6OmJlZm9yZWAgY2FuIGJlIHNldCBhcyAnLScgKGUuZy4gdW5vcmRlcmVkIGxpc3QpXG4gKiB3aGljaCBkaXNwbGF5ZWQgYXMgc2ltcGxlIGRhc2ggYC1gIHdpdGggbm8gcXVvdGVzLlxuICogQnV0IENTU1N0eWxlRGVjbGFyYXRpb24uZ2V0UHJvcGVydHlWYWx1ZSgnY29udGVudCcpIHdpbGwgcmV0dXJuIHZhbHVlXG4gKiB3cmFwcGVkIGludG8gcXVvdGVzLCBlLmcuICdcIi1cIicsIHdoaWNoIHNob3VsZCBiZSByZW1vdmVkXG4gKiBiZWNhdXNlIGZpbHRlcnMgbWFpbnRhaW5lcnMgZG9lcyBub3QgdXNlIGFueSBxdW90ZXMgaW4gcmVhbCBydWxlcy5cbiAqXG4gKiBAcGFyYW0gc3RyIElucHV0IHN0cmluZy5cbiAqXG4gKiBAcmV0dXJucyBTdHJpbmcgd2l0aCBubyBxdW90ZXMgZm9yIGNvbnRlbnQgdmFsdWUuXG4gKi9cbmNvbnN0IHJlbW92ZUNvbnRlbnRRdW90ZXMgPSBzdHIgPT4ge1xuICByZXR1cm4gc3RyLnJlcGxhY2UoL14oW1wiJ10pKFtcXHNcXFNdKilcXDEkLywgJyQyJyk7XG59O1xuLyoqXG4gKiBBZGRzIHF1b3RlcyBmb3Igc3BlY2lmaWVkIGJhY2tncm91bmQgdXJsIHZhbHVlLlxuICpcbiAqIElmIGJhY2tncm91bmQtaW1hZ2UgaXMgc3BlY2lmaWVkICoqd2l0aG91dCoqIHF1b3RlczpcbiAqIGUuZy4gJ2JhY2tncm91bmQ6IHVybChkYXRhOmltYWdlL2dpZjtiYXNlNjQsUjBsR09EbGhBUUE3KScuXG4gKlxuICogQ1NTU3R5bGVEZWNsYXJhdGlvbi5nZXRQcm9wZXJ0eVZhbHVlKCdiYWNrZ3JvdW5kLWltYWdlJykgbWF5IHJldHVybiB2YWx1ZSAqKndpdGgqKiBxdW90ZXM6XG4gKiBlLmcuICdiYWNrZ3JvdW5kOiB1cmwoXCJkYXRhOmltYWdlL2dpZjtiYXNlNjQsUjBsR09EbGhBUUE3XCIpJy5cbiAqXG4gKiBTbyB3ZSBhZGQgcXVvdGVzIGZvciBjb21wYXRpYmlsaXR5IHNpbmNlIGZpbHRlcnMgbWFpbnRhaW5lcnMgbWlnaHQgdXNlIHF1b3RlcyBpbiByZWFsIHJ1bGVzLlxuICpcbiAqIEBwYXJhbSBzdHIgSW5wdXQgc3RyaW5nLlxuICpcbiAqIEByZXR1cm5zIFN0cmluZyB3aXRoIHVuaWZpZWQgcXVvdGVzIGZvciBiYWNrZ3JvdW5kIHVybCB2YWx1ZS5cbiAqL1xuXG5cbmNvbnN0IGFkZFVybFByb3BlcnR5UXVvdGVzID0gc3RyID0+IHtcbiAgaWYgKCFzdHIuaW5jbHVkZXMoJ3VybChcIicpKSB7XG4gICAgY29uc3QgcmUgPSAvdXJsXFwoKC4qPylcXCkvZztcbiAgICByZXR1cm4gc3RyLnJlcGxhY2UocmUsICd1cmwoXCIkMVwiKScpO1xuICB9XG5cbiAgcmV0dXJuIHN0cjtcbn07XG4vKipcbiAqIEFkZHMgcXVvdGVzIHRvIHVybCBhcmcgZm9yIGNvbnNpc3RlbnQgcHJvcGVydHkgdmFsdWUgbWF0Y2hpbmcuXG4gKi9cblxuXG5jb25zdCBhZGRVcmxRdW90ZXNUbyA9IHtcbiAgcmVnZXhwQXJnOiBzdHIgPT4ge1xuICAgIC8vIGUuZy4gL151cmxcXFxcKFthLXpdezR9OlthLXpdezV9L1xuICAgIC8vIG9yIC9edXJsXFxcXChkYXRhXFxcXDpcXFxcaW1hZ2VcXFxcL2dpZjtiYXNlNjQuKy9cbiAgICBjb25zdCByZSA9IC8oXFxeKT91cmwoXFxcXCk/XFxcXFxcKChcXHd8XFxbXFx3KS9nO1xuICAgIHJldHVybiBzdHIucmVwbGFjZShyZSwgJyQxdXJsJDJcXFxcKFxcXFxcIj8kMycpO1xuICB9LFxuICBub25lUmVnZXhwQXJnOiBhZGRVcmxQcm9wZXJ0eVF1b3Rlc1xufTtcbi8qKlxuICogRXNjYXBlcyByZWd1bGFyIGV4cHJlc3Npb24gc3RyaW5nLlxuICpcbiAqIEBzZWUge0BsaW5rIGh0dHBzOi8vZGV2ZWxvcGVyLm1vemlsbGEub3JnL2VuL0phdmFTY3JpcHQvUmVmZXJlbmNlL0dsb2JhbF9PYmplY3RzL3JlZ2V4cH1cbiAqXG4gKiBAcGFyYW0gc3RyIElucHV0IHN0cmluZy5cbiAqXG4gKiBAcmV0dXJucyBFc2NhcGVkIHJlZ3VsYXIgZXhwcmVzc2lvbiBzdHJpbmcuXG4gKi9cblxuY29uc3QgZXNjYXBlUmVnRXhwID0gc3RyID0+IHtcbiAgLy8gc2hvdWxkIGJlIGVzY2FwZWQgLiAqICsgPyBeICQgeyB9ICggKSB8IFsgXSAvIFxcXG4gIC8vIGV4Y2VwdCBvZiAqIHwgXlxuICBjb25zdCBzcGVjaWFscyA9IFsnLicsICcrJywgJz8nLCAnJCcsICd7JywgJ30nLCAnKCcsICcpJywgJ1snLCAnXScsICdcXFxcJywgJy8nXTtcbiAgY29uc3Qgc3BlY2lhbHNSZWdleCA9IG5ldyBSZWdFeHAoYFske3NwZWNpYWxzLmpvaW4oJ1xcXFwnKX1dYCwgJ2cnKTtcbiAgcmV0dXJuIHN0ci5yZXBsYWNlKHNwZWNpYWxzUmVnZXgsICdcXFxcJCYnKTtcbn07XG4vKipcbiAqIENvbnZlcnRzIDptYXRjaGVzLWNzcygpIGFyZyBwcm9wZXJ0eSB2YWx1ZSBtYXRjaCB0byByZWdleHAuXG4gKlxuICogQHBhcmFtIHJhd1ZhbHVlIFN0eWxlIG1hdGNoIHZhbHVlIHBhdHRlcm4uXG4gKlxuICogQHJldHVybnMgQXJnIG9mIDptYXRjaGVzLWNzcygpIGNvbnZlcnRlZCB0byByZWd1bGFyIGV4cHJlc3Npb24uXG4gKi9cblxuXG5jb25zdCBjb252ZXJ0U3R5bGVNYXRjaFZhbHVlVG9SZWdleHAgPSByYXdWYWx1ZSA9PiB7XG4gIGxldCB2YWx1ZTtcblxuICBpZiAocmF3VmFsdWUuc3RhcnRzV2l0aChTTEFTSCkgJiYgcmF3VmFsdWUuZW5kc1dpdGgoU0xBU0gpKSB7XG4gICAgLy8gRm9yIHJlZ2V4IHBhdHRlcm5zIGRvdWJsZSBxdW90ZXMgYFwiYCBhbmQgYmFja3NsYXNoZXMgYFxcYCBzaG91bGQgYmUgZXNjYXBlZFxuICAgIHZhbHVlID0gYWRkVXJsUXVvdGVzVG8ucmVnZXhwQXJnKHJhd1ZhbHVlKTtcbiAgICB2YWx1ZSA9IHZhbHVlLnNsaWNlKDEsIC0xKTtcbiAgfSBlbHNlIHtcbiAgICAvLyBGb3Igbm9uLXJlZ2V4IHBhdHRlcm5zIHBhcmVudGhlc2VzIGAoYCBgKWAgYW5kIHNxdWFyZSBicmFja2V0cyBgW2AgYF1gXG4gICAgLy8gc2hvdWxkIGJlIHVuZXNjYXBlZCwgYmVjYXVzZSB0aGVpciBlc2NhcGluZyBpbiBmaWx0ZXIgcnVsZXMgaXMgcmVxdWlyZWRcbiAgICB2YWx1ZSA9IGFkZFVybFF1b3Rlc1RvLm5vbmVSZWdleHBBcmcocmF3VmFsdWUpO1xuICAgIHZhbHVlID0gdmFsdWUucmVwbGFjZSgvXFxcXChbXFxcXCgpW1xcXVwiXSkvZywgJyQxJyk7XG4gICAgdmFsdWUgPSBlc2NhcGVSZWdFeHAodmFsdWUpOyAvLyBlLmcuIGRpdjptYXRjaGVzLWNzcyhiYWNrZ3JvdW5kLWltYWdlOiB1cmwoZGF0YToqKSlcblxuICAgIHZhbHVlID0gcmVwbGFjZUFsbCh2YWx1ZSwgQVNURVJJU0ssIFJFR0VYUF9BTllfU1lNQk9MKTtcbiAgfVxuXG4gIHJldHVybiBuZXcgUmVnRXhwKHZhbHVlLCAnaScpO1xufTtcbi8qKlxuICogTWFrZXMgc29tZSBwcm9wZXJ0aWVzIHZhbHVlcyBjb21wYXRpYmxlLlxuICpcbiAqIEBwYXJhbSBwcm9wZXJ0eU5hbWUgTmFtZSBvZiBzdHlsZSBwcm9wZXJ0eS5cbiAqIEBwYXJhbSBwcm9wZXJ0eVZhbHVlIFZhbHVlIG9mIHN0eWxlIHByb3BlcnR5LlxuICpcbiAqIEByZXR1cm5zIE5vcm1hbGl6ZWQgdmFsdWVzIGZvciBzb21lIENTUyBwcm9wZXJ0aWVzLlxuICovXG5cblxuY29uc3Qgbm9ybWFsaXplUHJvcGVydHlWYWx1ZSA9IChwcm9wZXJ0eU5hbWUsIHByb3BlcnR5VmFsdWUpID0+IHtcbiAgbGV0IG5vcm1hbGl6ZWQgPSAnJztcblxuICBzd2l0Y2ggKHByb3BlcnR5TmFtZSkge1xuICAgIGNhc2UgQ1NTX1BST1BFUlRZLkJBQ0tHUk9VTkQ6XG4gICAgY2FzZSBDU1NfUFJPUEVSVFkuQkFDS0dST1VORF9JTUFHRTpcbiAgICAgIC8vIHNvbWV0aW1lcyB1cmwgcHJvcGVydHkgZG9lcyBub3QgaGF2ZSBxdW90ZXNcbiAgICAgIC8vIHNvIHdlIGFkZCB0aGVtIGZvciBjb25zaXN0ZW50IG1hdGNoaW5nXG4gICAgICBub3JtYWxpemVkID0gYWRkVXJsUHJvcGVydHlRdW90ZXMocHJvcGVydHlWYWx1ZSk7XG4gICAgICBicmVhaztcblxuICAgIGNhc2UgQ1NTX1BST1BFUlRZLkNPTlRFTlQ6XG4gICAgICBub3JtYWxpemVkID0gcmVtb3ZlQ29udGVudFF1b3Rlcyhwcm9wZXJ0eVZhbHVlKTtcbiAgICAgIGJyZWFrO1xuXG4gICAgY2FzZSBDU1NfUFJPUEVSVFkuT1BBQ0lUWTpcbiAgICAgIC8vIGh0dHBzOi8vYnVncy53ZWJraXQub3JnL3Nob3dfYnVnLmNnaT9pZD05MzQ0NVxuICAgICAgbm9ybWFsaXplZCA9IGlzU2FmYXJpQnJvd3NlciA/IChNYXRoLnJvdW5kKHBhcnNlRmxvYXQocHJvcGVydHlWYWx1ZSkgKiAxMDApIC8gMTAwKS50b1N0cmluZygpIDogcHJvcGVydHlWYWx1ZTtcbiAgICAgIGJyZWFrO1xuXG4gICAgZGVmYXVsdDpcbiAgICAgIG5vcm1hbGl6ZWQgPSBwcm9wZXJ0eVZhbHVlO1xuICB9XG5cbiAgcmV0dXJuIG5vcm1hbGl6ZWQ7XG59O1xuLyoqXG4gKiBSZXR1cm5zIGRvbUVsZW1lbnQgc3R5bGUgcHJvcGVydHkgdmFsdWVcbiAqIGJ5IGNzcyBwcm9wZXJ0eSBuYW1lIGFuZCBzdGFuZGFyZCBwc2V1ZG8tZWxlbWVudC5cbiAqXG4gKiBAcGFyYW0gZG9tRWxlbWVudCBET00gZWxlbWVudC5cbiAqIEBwYXJhbSBwcm9wZXJ0eU5hbWUgQ1NTIHByb3BlcnR5IG5hbWUuXG4gKiBAcGFyYW0gcmVndWxhclBzZXVkb0VsZW1lbnQgU3RhbmRhcmQgcHNldWRvLWVsZW1lbnQg4oCUICc6OmJlZm9yZScsICc6OmFmdGVyJyBldGMuXG4gKlxuICogQHJldHVybnMgU3RyaW5nIGNvbnRhaW5pbmcgdGhlIHZhbHVlIG9mIGEgc3BlY2lmaWVkIENTUyBwcm9wZXJ0eS5cbiAqL1xuXG5cbmNvbnN0IGdldENvbXB1dGVkU3R5bGVQcm9wZXJ0eVZhbHVlID0gKGRvbUVsZW1lbnQsIHByb3BlcnR5TmFtZSwgcmVndWxhclBzZXVkb0VsZW1lbnQpID0+IHtcbiAgY29uc3Qgc3R5bGUgPSB3aW5kb3cuZ2V0Q29tcHV0ZWRTdHlsZShkb21FbGVtZW50LCByZWd1bGFyUHNldWRvRWxlbWVudCk7XG4gIGNvbnN0IHByb3BlcnR5VmFsdWUgPSBzdHlsZS5nZXRQcm9wZXJ0eVZhbHVlKHByb3BlcnR5TmFtZSk7XG4gIHJldHVybiBub3JtYWxpemVQcm9wZXJ0eVZhbHVlKHByb3BlcnR5TmFtZSwgcHJvcGVydHlWYWx1ZSk7XG59O1xuXG4vKipcbiAqIFBhcnNlcyBhcmcgb2YgYWJzb2x1dGUgcHNldWRvLWNsYXNzIGludG8gJ25hbWUnIGFuZCAndmFsdWUnIGlmIHNldC5cbiAqXG4gKiBVc2VkIGZvciA6bWF0Y2hlcy1jc3MoKSAtIHdpdGggQ09MT04gYXMgc2VwYXJhdG9yLFxuICogZm9yIDptYXRjaGVzLWF0dHIoKSBhbmQgOm1hdGNoZXMtcHJvcGVydHkoKSAtIHdpdGggRVFVQUxfU0lHTiBhcyBzZXBhcmF0b3IuXG4gKlxuICogQHBhcmFtIHBzZXVkb0FyZyBBcmcgb2YgcHNldWRvLWNsYXNzLlxuICogQHBhcmFtIHNlcGFyYXRvciBEaXZpZGVyIHN5bWJvbC5cbiAqXG4gKiBAcmV0dXJucyBQYXJzZWQgJ21hdGNoZXMnIHBzZXVkby1jbGFzcyBhcmcgZGF0YS5cbiAqL1xuY29uc3QgZ2V0UHNldWRvQXJnRGF0YSA9IChwc2V1ZG9BcmcsIHNlcGFyYXRvcikgPT4ge1xuICBjb25zdCBpbmRleCA9IHBzZXVkb0FyZy5pbmRleE9mKHNlcGFyYXRvcik7XG4gIGxldCBuYW1lO1xuICBsZXQgdmFsdWU7XG5cbiAgaWYgKGluZGV4ID4gLTEpIHtcbiAgICBuYW1lID0gcHNldWRvQXJnLnN1YnN0cmluZygwLCBpbmRleCkudHJpbSgpO1xuICAgIHZhbHVlID0gcHNldWRvQXJnLnN1YnN0cmluZyhpbmRleCArIDEpLnRyaW0oKTtcbiAgfSBlbHNlIHtcbiAgICBuYW1lID0gcHNldWRvQXJnO1xuICB9XG5cbiAgcmV0dXJuIHtcbiAgICBuYW1lLFxuICAgIHZhbHVlXG4gIH07XG59O1xuXG4vKipcbiAqIFBhcnNlcyA6bWF0Y2hlcy1jc3MoKSBwc2V1ZG8tY2xhc3MgYXJnXG4gKiB3aGVyZSByZWd1bGFyIHBzZXVkby1lbGVtZW50IGNhbiBiZSBhIHBhcnQgb2YgYXJnXG4gKiBlLmcuICdkaXY6bWF0Y2hlcy1jc3MoYmVmb3JlLCBjb2xvcjogcmdiKDI1NSwgMjU1LCAyNTUpKScgICAgPC0tIG9ic29sZXRlIGA6bWF0Y2hlcy1jc3MtYmVmb3JlKClgLlxuICpcbiAqIEBwYXJhbSBwc2V1ZG9OYW1lIFBzZXVkby1jbGFzcyBuYW1lLlxuICogQHBhcmFtIHJhd0FyZyBQc2V1ZG8tY2xhc3MgYXJnLlxuICpcbiAqIEByZXR1cm5zIFBhcnNlZCA6bWF0Y2hlcy1jc3MoKSBwc2V1ZG8tY2xhc3MgYXJnIGRhdGEuXG4gKiBAdGhyb3dzIEFuIGVycm9yIG9uIGludmFsaWQgYHJhd0FyZ2AuXG4gKi9cbmNvbnN0IHBhcnNlU3R5bGVNYXRjaEFyZyA9IChwc2V1ZG9OYW1lLCByYXdBcmcpID0+IHtcbiAgY29uc3Qge1xuICAgIG5hbWUsXG4gICAgdmFsdWVcbiAgfSA9IGdldFBzZXVkb0FyZ0RhdGEocmF3QXJnLCBDT01NQSk7XG4gIGxldCByZWd1bGFyUHNldWRvRWxlbWVudCA9IG5hbWU7XG4gIGxldCBzdHlsZU1hdGNoQXJnID0gdmFsdWU7IC8vIGNoZWNrIHdoZXRoZXIgdGhlIHN0cmluZyBwYXJ0IGJlZm9yZSB0aGUgc2VwYXJhdG9yIGlzIHZhbGlkIHJlZ3VsYXIgcHNldWRvLWVsZW1lbnQsXG4gIC8vIG90aGVyd2lzZSBgcmVndWxhclBzZXVkb0VsZW1lbnRgIGlzIG51bGwsIGFuZCBgc3R5bGVNYXRjaEFyZ2AgaXMgcmF3QXJnXG5cbiAgaWYgKCFPYmplY3QudmFsdWVzKFJFR1VMQVJfUFNFVURPX0VMRU1FTlRTKS5pbmNsdWRlcyhuYW1lKSkge1xuICAgIHJlZ3VsYXJQc2V1ZG9FbGVtZW50ID0gbnVsbDtcbiAgICBzdHlsZU1hdGNoQXJnID0gcmF3QXJnO1xuICB9XG5cbiAgaWYgKCFzdHlsZU1hdGNoQXJnKSB7XG4gICAgdGhyb3cgbmV3IEVycm9yKGBSZXF1aXJlZCBzdHlsZSBwcm9wZXJ0eSBhcmd1bWVudCBwYXJ0IGlzIG1pc3NpbmcgaW4gOiR7cHNldWRvTmFtZX0oKSBhcmc6ICcke3Jhd0FyZ30nYCk7XG4gIH0gLy8gaWYgcmVndWxhclBzZXVkb0VsZW1lbnQgaXMgbm90IGBudWxsYFxuXG5cbiAgaWYgKHJlZ3VsYXJQc2V1ZG9FbGVtZW50KSB7XG4gICAgLy8gcHNldWRvLWVsZW1lbnQgc2hvdWxkIGhhdmUgdHdvIGNvbG9uIG1hcmtzIGZvciBXaW5kb3cuZ2V0Q29tcHV0ZWRTdHlsZSgpIGR1ZSB0byB0aGUgc3ludGF4OlxuICAgIC8vIGh0dHBzOi8vd3d3LnczLm9yZy9UUi9zZWxlY3RvcnMtNC8jcHNldWRvLWVsZW1lbnQtc3ludGF4XG4gICAgLy8gJzptYXRjaGVzLWNzcyhiZWZvcmUsIGNvbnRlbnQ6IGFkcyknIC0+PiAnOjpiZWZvcmUnXG4gICAgcmVndWxhclBzZXVkb0VsZW1lbnQgPSBgJHtDT0xPTn0ke0NPTE9OfSR7cmVndWxhclBzZXVkb0VsZW1lbnR9YDtcbiAgfVxuXG4gIHJldHVybiB7XG4gICAgcmVndWxhclBzZXVkb0VsZW1lbnQsXG4gICAgc3R5bGVNYXRjaEFyZ1xuICB9O1xufTtcbi8qKlxuICogQ2hlY2tzIHdoZXRoZXIgdGhlIGRvbUVsZW1lbnQgaXMgbWF0Y2hlZCBieSA6bWF0Y2hlcy1jc3MoKSBhcmcuXG4gKlxuICogQHBhcmFtIGFyZ3NEYXRhIFBzZXVkby1jbGFzcyBuYW1lLCBhcmcsIGFuZCBkb20gZWxlbWVudCB0byBjaGVjay5cbiAqXG4gQHJldHVybnMgVHJ1ZSBpZiBET00gZWxlbWVudCBpcyBtYXRjaGVkLlxuICogQHRocm93cyBBbiBlcnJvciBvbiBpbnZhbGlkIHBzZXVkby1jbGFzcyBhcmcuXG4gKi9cblxuXG5jb25zdCBpc1N0eWxlTWF0Y2hlZCA9IGFyZ3NEYXRhID0+IHtcbiAgY29uc3Qge1xuICAgIHBzZXVkb05hbWUsXG4gICAgcHNldWRvQXJnLFxuICAgIGRvbUVsZW1lbnRcbiAgfSA9IGFyZ3NEYXRhO1xuICBjb25zdCB7XG4gICAgcmVndWxhclBzZXVkb0VsZW1lbnQsXG4gICAgc3R5bGVNYXRjaEFyZ1xuICB9ID0gcGFyc2VTdHlsZU1hdGNoQXJnKHBzZXVkb05hbWUsIHBzZXVkb0FyZyk7XG4gIGNvbnN0IHtcbiAgICBuYW1lOiBtYXRjaE5hbWUsXG4gICAgdmFsdWU6IG1hdGNoVmFsdWVcbiAgfSA9IGdldFBzZXVkb0FyZ0RhdGEoc3R5bGVNYXRjaEFyZywgQ09MT04pO1xuXG4gIGlmICghbWF0Y2hOYW1lIHx8ICFtYXRjaFZhbHVlKSB7XG4gICAgdGhyb3cgbmV3IEVycm9yKGBSZXF1aXJlZCBwcm9wZXJ0eSBuYW1lIG9yIHZhbHVlIGlzIG1pc3NpbmcgaW4gOiR7cHNldWRvTmFtZX0oKSBhcmc6ICcke3N0eWxlTWF0Y2hBcmd9J2ApO1xuICB9XG5cbiAgbGV0IHZhbHVlUmVnZXhwO1xuXG4gIHRyeSB7XG4gICAgdmFsdWVSZWdleHAgPSBjb252ZXJ0U3R5bGVNYXRjaFZhbHVlVG9SZWdleHAobWF0Y2hWYWx1ZSk7XG4gIH0gY2F0Y2ggKGUpIHtcbiAgICBsb2dnZXIuZXJyb3IoZ2V0RXJyb3JNZXNzYWdlKGUpKTtcbiAgICB0aHJvdyBuZXcgRXJyb3IoYEludmFsaWQgYXJndW1lbnQgb2YgOiR7cHNldWRvTmFtZX0oKSBwc2V1ZG8tY2xhc3M6ICcke3N0eWxlTWF0Y2hBcmd9J2ApO1xuICB9XG5cbiAgY29uc3QgdmFsdWUgPSBnZXRDb21wdXRlZFN0eWxlUHJvcGVydHlWYWx1ZShkb21FbGVtZW50LCBtYXRjaE5hbWUsIHJlZ3VsYXJQc2V1ZG9FbGVtZW50KTtcbiAgcmV0dXJuIHZhbHVlUmVnZXhwICYmIHZhbHVlUmVnZXhwLnRlc3QodmFsdWUpO1xufTtcbi8qKlxuICogVmFsaWRhdGVzIHN0cmluZyBhcmcgZm9yIDptYXRjaGVzLWF0dHIoKSBhbmQgOm1hdGNoZXMtcHJvcGVydHkoKS5cbiAqXG4gKiBAcGFyYW0gYXJnIFBzZXVkby1jbGFzcyBhcmcuXG4gKlxuICogQHJldHVybnMgVHJ1ZSBpZiAnbWF0Y2hlcycgcHNldWRvLWNsYXNzIHN0cmluZyBhcmcgaXMgdmFsaWQuXG4gKi9cblxuY29uc3QgdmFsaWRhdGVTdHJNYXRjaGVyQXJnID0gYXJnID0+IHtcbiAgaWYgKGFyZy5pbmNsdWRlcyhTTEFTSCkpIHtcbiAgICByZXR1cm4gZmFsc2U7XG4gIH1cblxuICBpZiAoIS9eW1xcdy1dKyQvLnRlc3QoYXJnKSkge1xuICAgIHJldHVybiBmYWxzZTtcbiAgfVxuXG4gIHJldHVybiB0cnVlO1xufTtcbi8qKlxuICogUmV0dXJucyB2YWxpZCBhcmcgZm9yIDptYXRjaGVzLWF0dHIoKSBhbmQgOm1hdGNoZXItcHJvcGVydHkoKS5cbiAqXG4gKiBAcGFyYW0gcmF3QXJnIEFyZyBwYXR0ZXJuLlxuICogQHBhcmFtIFtpc1dpbGRjYXJkQWxsb3dlZD1mYWxzZV0gRmxhZyBmb3Igd2lsZGNhcmQgKGAqYCkgdXNpbmcgYXMgcHNldWRvLWNsYXNzIGFyZy5cbiAqXG4gKiBAcmV0dXJucyBWYWxpZCBhcmcgZm9yIDptYXRjaGVzLWF0dHIoKSBhbmQgOm1hdGNoZXItcHJvcGVydHkoKS5cbiAqIEB0aHJvd3MgQW4gZXJyb3Igb24gaW52YWxpZCBgcmF3QXJnYC5cbiAqL1xuXG5cbmNvbnN0IGdldFZhbGlkTWF0Y2hlckFyZyA9IGZ1bmN0aW9uIChyYXdBcmcpIHtcbiAgbGV0IGlzV2lsZGNhcmRBbGxvd2VkID0gYXJndW1lbnRzLmxlbmd0aCA+IDEgJiYgYXJndW1lbnRzWzFdICE9PSB1bmRlZmluZWQgPyBhcmd1bWVudHNbMV0gOiBmYWxzZTtcbiAgLy8gaWYgcmF3QXJnIGlzIG1pc3NpbmcgZm9yIHBzZXVkby1jbGFzc1xuICAvLyBlLmcuIDptYXRjaGVzLWF0dHIoKVxuICAvLyBlcnJvciB3aWxsIGJlIHRocm93biBiZWZvcmUgZ2V0VmFsaWRNYXRjaGVyQXJnKCkgaXMgY2FsbGVkOlxuICAvLyBuYW1lIG9yIGFyZyBpcyBtaXNzaW5nIGluIEFic29sdXRlUHNldWRvQ2xhc3NcbiAgbGV0IGFyZztcblxuICBpZiAocmF3QXJnLmxlbmd0aCA+IDEgJiYgcmF3QXJnLnN0YXJ0c1dpdGgoRE9VQkxFX1FVT1RFKSAmJiByYXdBcmcuZW5kc1dpdGgoRE9VQkxFX1FVT1RFKSkge1xuICAgIHJhd0FyZyA9IHJhd0FyZy5zbGljZSgxLCAtMSk7XG4gIH1cblxuICBpZiAocmF3QXJnID09PSAnJykge1xuICAgIC8vIGUuZy4gOm1hdGNoZXMtcHJvcGVydHkoXCJcIilcbiAgICB0aHJvdyBuZXcgRXJyb3IoJ0FyZ3VtZW50IHNob3VsZCBiZSBzcGVjaWZpZWQuIEVtcHR5IGFyZyBpcyBpbnZhbGlkLicpO1xuICB9XG5cbiAgaWYgKHJhd0FyZy5zdGFydHNXaXRoKFNMQVNIKSAmJiByYXdBcmcuZW5kc1dpdGgoU0xBU0gpKSB7XG4gICAgLy8gZS5nLiA6bWF0Y2hlcy1wcm9wZXJ0eShcIi8vXCIpXG4gICAgaWYgKHJhd0FyZy5sZW5ndGggPiAyKSB7XG4gICAgICBhcmcgPSB0b1JlZ0V4cChyYXdBcmcpO1xuICAgIH0gZWxzZSB7XG4gICAgICB0aHJvdyBuZXcgRXJyb3IoYEludmFsaWQgcmVnZXhwOiAnJHtyYXdBcmd9J2ApO1xuICAgIH1cbiAgfSBlbHNlIGlmIChyYXdBcmcuaW5jbHVkZXMoQVNURVJJU0spKSB7XG4gICAgaWYgKHJhd0FyZyA9PT0gQVNURVJJU0sgJiYgIWlzV2lsZGNhcmRBbGxvd2VkKSB7XG4gICAgICAvLyBlLmcuIDptYXRjaGVzLWF0dHIoKilcbiAgICAgIHRocm93IG5ldyBFcnJvcihgQXJndW1lbnQgc2hvdWxkIGJlIG1vcmUgc3BlY2lmaWMgdGhhbiAke3Jhd0FyZ31gKTtcbiAgICB9XG5cbiAgICBhcmcgPSByZXBsYWNlQWxsKHJhd0FyZywgQVNURVJJU0ssIFJFR0VYUF9BTllfU1lNQk9MKTtcbiAgICBhcmcgPSBuZXcgUmVnRXhwKGFyZyk7XG4gIH0gZWxzZSB7XG4gICAgaWYgKCF2YWxpZGF0ZVN0ck1hdGNoZXJBcmcocmF3QXJnKSkge1xuICAgICAgdGhyb3cgbmV3IEVycm9yKGBJbnZhbGlkIGFyZ3VtZW50OiAnJHtyYXdBcmd9J2ApO1xuICAgIH1cblxuICAgIGFyZyA9IHJhd0FyZztcbiAgfVxuXG4gIHJldHVybiBhcmc7XG59O1xuXG4vKipcbiAqIFBhcnNlcyBwc2V1ZG8tY2xhc3MgYXJndW1lbnQgYW5kIHJldHVybnMgcGFyc2VkIGRhdGEuXG4gKlxuICogQHBhcmFtIHBzZXVkb05hbWUgRXh0ZW5kZWQgcHNldWRvLWNsYXNzIG5hbWUuXG4gKiBAcGFyYW0gcHNldWRvQXJnIEV4dGVuZGVkIHBzZXVkby1jbGFzcyBhcmd1bWVudC5cbiAqXG4gKiBAcmV0dXJucyBQYXJzZWQgcHNldWRvLWNsYXNzIGFyZ3VtZW50IGRhdGEuXG4gKiBAdGhyb3dzIEFuIGVycm9yIGlmIGF0dHJpYnV0ZSBuYW1lIGlzIG1pc3NpbmcgaW4gcHNldWRvLWNsYXNzIGFyZy5cbiAqL1xuY29uc3QgZ2V0UmF3TWF0Y2hpbmdEYXRhID0gKHBzZXVkb05hbWUsIHBzZXVkb0FyZykgPT4ge1xuICBjb25zdCB7XG4gICAgbmFtZTogcmF3TmFtZSxcbiAgICB2YWx1ZTogcmF3VmFsdWVcbiAgfSA9IGdldFBzZXVkb0FyZ0RhdGEocHNldWRvQXJnLCBFUVVBTF9TSUdOKTtcblxuICBpZiAoIXJhd05hbWUpIHtcbiAgICB0aHJvdyBuZXcgRXJyb3IoYFJlcXVpcmVkIGF0dHJpYnV0ZSBuYW1lIGlzIG1pc3NpbmcgaW4gOiR7cHNldWRvTmFtZX0gYXJnOiAke3BzZXVkb0FyZ31gKTtcbiAgfVxuXG4gIHJldHVybiB7XG4gICAgcmF3TmFtZSxcbiAgICByYXdWYWx1ZVxuICB9O1xufTtcbi8qKlxuICogQ2hlY2tzIHdoZXRoZXIgdGhlIGRvbUVsZW1lbnQgaXMgbWF0Y2hlZCBieSA6bWF0Y2hlcy1hdHRyKCkgYXJnLlxuICpcbiAqIEBwYXJhbSBhcmdzRGF0YSBQc2V1ZG8tY2xhc3MgbmFtZSwgYXJnLCBhbmQgZG9tIGVsZW1lbnQgdG8gY2hlY2suXG4gKlxuIEByZXR1cm5zIFRydWUgaWYgRE9NIGVsZW1lbnQgaXMgbWF0Y2hlZC5cbiAqIEB0aHJvd3MgQW4gZXJyb3Igb24gaW52YWxpZCBhcmcgb2YgcHNldWRvLWNsYXNzLlxuICovXG5cbmNvbnN0IGlzQXR0cmlidXRlTWF0Y2hlZCA9IGFyZ3NEYXRhID0+IHtcbiAgY29uc3Qge1xuICAgIHBzZXVkb05hbWUsXG4gICAgcHNldWRvQXJnLFxuICAgIGRvbUVsZW1lbnRcbiAgfSA9IGFyZ3NEYXRhO1xuICBjb25zdCBlbGVtZW50QXR0cmlidXRlcyA9IGRvbUVsZW1lbnQuYXR0cmlidXRlczsgLy8gbm8gbWF0Y2ggaWYgZG9tIGVsZW1lbnQgaGFzIG5vIGF0dHJpYnV0ZXNcblxuICBpZiAoZWxlbWVudEF0dHJpYnV0ZXMubGVuZ3RoID09PSAwKSB7XG4gICAgcmV0dXJuIGZhbHNlO1xuICB9XG5cbiAgY29uc3Qge1xuICAgIHJhd05hbWU6IHJhd0F0dHJOYW1lLFxuICAgIHJhd1ZhbHVlOiByYXdBdHRyVmFsdWVcbiAgfSA9IGdldFJhd01hdGNoaW5nRGF0YShwc2V1ZG9OYW1lLCBwc2V1ZG9BcmcpO1xuICBsZXQgYXR0ck5hbWVNYXRjaDtcblxuICB0cnkge1xuICAgIGF0dHJOYW1lTWF0Y2ggPSBnZXRWYWxpZE1hdGNoZXJBcmcocmF3QXR0ck5hbWUpO1xuICB9IGNhdGNoIChlKSB7XG4gICAgY29uc3QgZXJyb3JNZXNzYWdlID0gZ2V0RXJyb3JNZXNzYWdlKGUpO1xuICAgIGxvZ2dlci5lcnJvcihlcnJvck1lc3NhZ2UpO1xuICAgIHRocm93IG5ldyBTeW50YXhFcnJvcihlcnJvck1lc3NhZ2UpO1xuICB9XG5cbiAgbGV0IGlzTWF0Y2hlZCA9IGZhbHNlO1xuICBsZXQgaSA9IDA7XG5cbiAgd2hpbGUgKGkgPCBlbGVtZW50QXR0cmlidXRlcy5sZW5ndGggJiYgIWlzTWF0Y2hlZCkge1xuICAgIGNvbnN0IGF0dHIgPSBlbGVtZW50QXR0cmlidXRlc1tpXTtcblxuICAgIGlmICghYXR0cikge1xuICAgICAgYnJlYWs7XG4gICAgfVxuXG4gICAgY29uc3QgaXNOYW1lTWF0Y2hlZCA9IGF0dHJOYW1lTWF0Y2ggaW5zdGFuY2VvZiBSZWdFeHAgPyBhdHRyTmFtZU1hdGNoLnRlc3QoYXR0ci5uYW1lKSA6IGF0dHJOYW1lTWF0Y2ggPT09IGF0dHIubmFtZTtcblxuICAgIGlmICghcmF3QXR0clZhbHVlKSB7XG4gICAgICAvLyBmb3IgcnVsZXMgd2l0aCBubyBhdHRyaWJ1dGUgdmFsdWUgc3BlY2lmaWVkXG4gICAgICAvLyBlLmcuIDptYXRjaGVzLWF0dHIoXCIvcmVnZXgvXCIpIG9yIDptYXRjaGVzLWF0dHIoXCJhdHRyLW5hbWVcIilcbiAgICAgIGlzTWF0Y2hlZCA9IGlzTmFtZU1hdGNoZWQ7XG4gICAgfSBlbHNlIHtcbiAgICAgIGxldCBhdHRyVmFsdWVNYXRjaDtcblxuICAgICAgdHJ5IHtcbiAgICAgICAgYXR0clZhbHVlTWF0Y2ggPSBnZXRWYWxpZE1hdGNoZXJBcmcocmF3QXR0clZhbHVlKTtcbiAgICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgICAgY29uc3QgZXJyb3JNZXNzYWdlID0gZ2V0RXJyb3JNZXNzYWdlKGUpO1xuICAgICAgICBsb2dnZXIuZXJyb3IoZXJyb3JNZXNzYWdlKTtcbiAgICAgICAgdGhyb3cgbmV3IFN5bnRheEVycm9yKGVycm9yTWVzc2FnZSk7XG4gICAgICB9XG5cbiAgICAgIGNvbnN0IGlzVmFsdWVNYXRjaGVkID0gYXR0clZhbHVlTWF0Y2ggaW5zdGFuY2VvZiBSZWdFeHAgPyBhdHRyVmFsdWVNYXRjaC50ZXN0KGF0dHIudmFsdWUpIDogYXR0clZhbHVlTWF0Y2ggPT09IGF0dHIudmFsdWU7XG4gICAgICBpc01hdGNoZWQgPSBpc05hbWVNYXRjaGVkICYmIGlzVmFsdWVNYXRjaGVkO1xuICAgIH1cblxuICAgIGkgKz0gMTtcbiAgfVxuXG4gIHJldHVybiBpc01hdGNoZWQ7XG59O1xuLyoqXG4gKiBQYXJzZXMgcmF3IDptYXRjaGVzLXByb3BlcnR5KCkgYXJnIHdoaWNoIG1heSBiZSBjaGFpbiBvZiBwcm9wZXJ0aWVzLlxuICpcbiAqIEBwYXJhbSBpbnB1dCBBcmd1bWVudCBvZiA6bWF0Y2hlcy1wcm9wZXJ0eSgpLlxuICpcbiAqIEByZXR1cm5zIEFyZyBvZiA6bWF0Y2hlcy1wcm9wZXJ0eSgpIGFzIGFycmF5IG9mIHN0cmluZ3Mgb3IgcmVndWxhciBleHByZXNzaW9ucy5cbiAqIEB0aHJvd3MgQW4gZXJyb3Igb24gaW52YWxpZCBjaGFpbi5cbiAqL1xuXG5jb25zdCBwYXJzZVJhd1Byb3BDaGFpbiA9IGlucHV0ID0+IHtcbiAgaWYgKGlucHV0Lmxlbmd0aCA+IDEgJiYgaW5wdXQuc3RhcnRzV2l0aChET1VCTEVfUVVPVEUpICYmIGlucHV0LmVuZHNXaXRoKERPVUJMRV9RVU9URSkpIHtcbiAgICBpbnB1dCA9IGlucHV0LnNsaWNlKDEsIC0xKTtcbiAgfVxuXG4gIGNvbnN0IGNoYWluQ2h1bmtzID0gaW5wdXQuc3BsaXQoRE9UKTtcbiAgY29uc3QgY2hhaW5QYXR0ZXJucyA9IFtdO1xuICBsZXQgcGF0dGVybkJ1ZmZlciA9ICcnO1xuICBsZXQgaXNSZWdleHBQYXR0ZXJuID0gZmFsc2U7XG4gIGxldCBpID0gMDtcblxuICB3aGlsZSAoaSA8IGNoYWluQ2h1bmtzLmxlbmd0aCkge1xuICAgIGNvbnN0IGNodW5rID0gZ2V0SXRlbUJ5SW5kZXgoY2hhaW5DaHVua3MsIGksIGBJbnZhbGlkIHBzZXVkby1jbGFzcyBhcmc6ICcke2lucHV0fSdgKTtcblxuICAgIGlmIChjaHVuay5zdGFydHNXaXRoKFNMQVNIKSAmJiBjaHVuay5lbmRzV2l0aChTTEFTSCkgJiYgY2h1bmsubGVuZ3RoID4gMikge1xuICAgICAgLy8gcmVnZXhwIHBhdHRlcm4gd2l0aCBubyBkb3QgaW4gaXQsIGUuZy4gL3Byb3BOYW1lL1xuICAgICAgY2hhaW5QYXR0ZXJucy5wdXNoKGNodW5rKTtcbiAgICB9IGVsc2UgaWYgKGNodW5rLnN0YXJ0c1dpdGgoU0xBU0gpKSB7XG4gICAgICAvLyBpZiBjaHVuayBpcyBhIHN0YXJ0IG9mIHJlZ2V4cCBwYXR0ZXJuXG4gICAgICBpc1JlZ2V4cFBhdHRlcm4gPSB0cnVlO1xuICAgICAgcGF0dGVybkJ1ZmZlciArPSBjaHVuaztcbiAgICB9IGVsc2UgaWYgKGNodW5rLmVuZHNXaXRoKFNMQVNIKSkge1xuICAgICAgaXNSZWdleHBQYXR0ZXJuID0gZmFsc2U7IC8vIHJlc3RvcmUgZG90IHJlbW92ZWQgd2hpbGUgc3BsaXR0aW5nXG4gICAgICAvLyBlLmcuIHRlc3RQcm9wLi8uezEsNX0vXG5cbiAgICAgIHBhdHRlcm5CdWZmZXIgKz0gYC4ke2NodW5rfWA7XG4gICAgICBjaGFpblBhdHRlcm5zLnB1c2gocGF0dGVybkJ1ZmZlcik7XG4gICAgICBwYXR0ZXJuQnVmZmVyID0gJyc7XG4gICAgfSBlbHNlIHtcbiAgICAgIC8vIGlmIHRoZXJlIGFyZSBmZXcgZG90cyBpbiByZWdleHAgcGF0dGVyblxuICAgICAgLy8gc28gY2h1bmsgbWlnaHQgYmUgaW4gdGhlIG1pZGRsZSBvZiBpdFxuICAgICAgaWYgKGlzUmVnZXhwUGF0dGVybikge1xuICAgICAgICBwYXR0ZXJuQnVmZmVyICs9IGNodW5rO1xuICAgICAgfSBlbHNlIHtcbiAgICAgICAgLy8gb3RoZXJ3aXNlIGl0IGlzIHN0cmluZyBwYXR0ZXJuXG4gICAgICAgIGNoYWluUGF0dGVybnMucHVzaChjaHVuayk7XG4gICAgICB9XG4gICAgfVxuXG4gICAgaSArPSAxO1xuICB9XG5cbiAgaWYgKHBhdHRlcm5CdWZmZXIubGVuZ3RoID4gMCkge1xuICAgIHRocm93IG5ldyBFcnJvcihgSW52YWxpZCByZWdleHAgcHJvcGVydHkgcGF0dGVybiAnJHtpbnB1dH0nYCk7XG4gIH1cblxuICBjb25zdCBjaGFpbk1hdGNoUGF0dGVybnMgPSBjaGFpblBhdHRlcm5zLm1hcChwYXR0ZXJuID0+IHtcbiAgICBpZiAocGF0dGVybi5sZW5ndGggPT09IDApIHtcbiAgICAgIC8vIGUuZy4gJy5wcm9wLmlkJyBvciAnbmVzdGVkLi50ZXN0J1xuICAgICAgdGhyb3cgbmV3IEVycm9yKGBFbXB0eSBwYXR0ZXJuICcke3BhdHRlcm59JyBpcyBpbnZhbGlkIGluIGNoYWluICcke2lucHV0fSdgKTtcbiAgICB9XG5cbiAgICBsZXQgdmFsaWRQYXR0ZXJuO1xuXG4gICAgdHJ5IHtcbiAgICAgIHZhbGlkUGF0dGVybiA9IGdldFZhbGlkTWF0Y2hlckFyZyhwYXR0ZXJuLCB0cnVlKTtcbiAgICB9IGNhdGNoIChlKSB7XG4gICAgICBsb2dnZXIuZXJyb3IoZ2V0RXJyb3JNZXNzYWdlKGUpKTtcbiAgICAgIHRocm93IG5ldyBFcnJvcihgSW52YWxpZCBwcm9wZXJ0eSBwYXR0ZXJuICcke3BhdHRlcm59JyBpbiBwcm9wZXJ0eSBjaGFpbiAnJHtpbnB1dH0nYCk7XG4gICAgfVxuXG4gICAgcmV0dXJuIHZhbGlkUGF0dGVybjtcbiAgfSk7XG4gIHJldHVybiBjaGFpbk1hdGNoUGF0dGVybnM7XG59O1xuXG4vKipcbiAqIENoZWNrcyBpZiB0aGUgcHJvcGVydHkgZXhpc3RzIGluIHRoZSBiYXNlIG9iamVjdCAocmVjdXJzaXZlbHkpLlxuICpcbiAqIEBwYXJhbSBiYXNlIEVsZW1lbnQgdG8gY2hlY2suXG4gKiBAcGFyYW0gY2hhaW4gQXJyYXkgb2Ygb2JqZWN0cyAtIHBhcnNlZCBzdHJpbmcgcHJvcGVydHkgY2hhaW4uXG4gKiBAcGFyYW0gW291dHB1dD1bXV0gUmVzdWx0IGFjYy5cbiAqXG4gKiBAcmV0dXJucyBBcnJheSBvZiBwYXJzZWQgZGF0YSDigJQgcmVwcmVzZW50YXRpb24gb2YgYGJhc2VgLXJlbGF0ZWQgYGNoYWluYC5cbiAqL1xuY29uc3QgZmlsdGVyUm9vdHNCeVJlZ2V4cENoYWluID0gZnVuY3Rpb24gKGJhc2UsIGNoYWluKSB7XG4gIGxldCBvdXRwdXQgPSBhcmd1bWVudHMubGVuZ3RoID4gMiAmJiBhcmd1bWVudHNbMl0gIT09IHVuZGVmaW5lZCA/IGFyZ3VtZW50c1syXSA6IFtdO1xuICBjb25zdCB0ZW1wUHJvcCA9IGdldEZpcnN0KGNoYWluKTtcblxuICBpZiAoY2hhaW4ubGVuZ3RoID09PSAxKSB7XG4gICAgbGV0IGtleTtcblxuICAgIGZvciAoa2V5IGluIGJhc2UpIHtcbiAgICAgIGlmICh0ZW1wUHJvcCBpbnN0YW5jZW9mIFJlZ0V4cCkge1xuICAgICAgICBpZiAodGVtcFByb3AudGVzdChrZXkpKSB7XG4gICAgICAgICAgb3V0cHV0LnB1c2goe1xuICAgICAgICAgICAgYmFzZSxcbiAgICAgICAgICAgIHByb3A6IGtleSxcbiAgICAgICAgICAgIHZhbHVlOiBiYXNlW2tleV1cbiAgICAgICAgICB9KTtcbiAgICAgICAgfVxuICAgICAgfSBlbHNlIGlmICh0ZW1wUHJvcCA9PT0ga2V5KSB7XG4gICAgICAgIG91dHB1dC5wdXNoKHtcbiAgICAgICAgICBiYXNlLFxuICAgICAgICAgIHByb3A6IHRlbXBQcm9wLFxuICAgICAgICAgIHZhbHVlOiBiYXNlW2tleV1cbiAgICAgICAgfSk7XG4gICAgICB9XG4gICAgfVxuXG4gICAgcmV0dXJuIG91dHB1dDtcbiAgfSAvLyBpZiB0aGVyZSBpcyBhIHJlZ2V4cCBwcm9wIGluIGlucHV0IGNoYWluXG4gIC8vIGUuZy4gJ3VuaXQuL15hZC4rLy5zcmMnIGZvciAndW5pdC5hZC0xZ2YyLnNyYyB1bml0LmFkLWZnZDM0LnNyYycpLFxuICAvLyBldmVyeSBiYXNlIGtleXMgc2hvdWxkIGJlIHRlc3RlZCBieSByZWdleHAgYW5kIGl0IGNhbiBiZSBtb3JlIHRoYXQgb25lIHJlc3VsdHNcblxuXG4gIGlmICh0ZW1wUHJvcCBpbnN0YW5jZW9mIFJlZ0V4cCkge1xuICAgIGNvbnN0IG5leHRQcm9wID0gY2hhaW4uc2xpY2UoMSk7XG4gICAgY29uc3QgYmFzZUtleXMgPSBbXTtcblxuICAgIGZvciAoY29uc3Qga2V5IGluIGJhc2UpIHtcbiAgICAgIGlmICh0ZW1wUHJvcC50ZXN0KGtleSkpIHtcbiAgICAgICAgYmFzZUtleXMucHVzaChrZXkpO1xuICAgICAgfVxuICAgIH1cblxuICAgIGJhc2VLZXlzLmZvckVhY2goa2V5ID0+IHtcbiAgICAgIHZhciBfT2JqZWN0JGdldE93blByb3BlcnQ7XG5cbiAgICAgIGNvbnN0IGl0ZW0gPSAoX09iamVjdCRnZXRPd25Qcm9wZXJ0ID0gT2JqZWN0LmdldE93blByb3BlcnR5RGVzY3JpcHRvcihiYXNlLCBrZXkpKSA9PT0gbnVsbCB8fCBfT2JqZWN0JGdldE93blByb3BlcnQgPT09IHZvaWQgMCA/IHZvaWQgMCA6IF9PYmplY3QkZ2V0T3duUHJvcGVydC52YWx1ZTtcbiAgICAgIGZpbHRlclJvb3RzQnlSZWdleHBDaGFpbihpdGVtLCBuZXh0UHJvcCwgb3V0cHV0KTtcbiAgICB9KTtcbiAgfVxuXG4gIGlmIChiYXNlICYmIHR5cGVvZiB0ZW1wUHJvcCA9PT0gJ3N0cmluZycpIHtcbiAgICB2YXIgX09iamVjdCRnZXRPd25Qcm9wZXJ0MjtcblxuICAgIGNvbnN0IG5leHRCYXNlID0gKF9PYmplY3QkZ2V0T3duUHJvcGVydDIgPSBPYmplY3QuZ2V0T3duUHJvcGVydHlEZXNjcmlwdG9yKGJhc2UsIHRlbXBQcm9wKSkgPT09IG51bGwgfHwgX09iamVjdCRnZXRPd25Qcm9wZXJ0MiA9PT0gdm9pZCAwID8gdm9pZCAwIDogX09iamVjdCRnZXRPd25Qcm9wZXJ0Mi52YWx1ZTtcbiAgICBjaGFpbiA9IGNoYWluLnNsaWNlKDEpO1xuXG4gICAgaWYgKG5leHRCYXNlICE9PSB1bmRlZmluZWQpIHtcbiAgICAgIGZpbHRlclJvb3RzQnlSZWdleHBDaGFpbihuZXh0QmFzZSwgY2hhaW4sIG91dHB1dCk7XG4gICAgfVxuICB9XG5cbiAgcmV0dXJuIG91dHB1dDtcbn07XG4vKipcbiAqIENoZWNrcyB3aGV0aGVyIHRoZSBkb21FbGVtZW50IGlzIG1hdGNoZWQgYnkgOm1hdGNoZXMtcHJvcGVydHkoKSBhcmcuXG4gKlxuICogQHBhcmFtIGFyZ3NEYXRhIFBzZXVkby1jbGFzcyBuYW1lLCBhcmcsIGFuZCBkb20gZWxlbWVudCB0byBjaGVjay5cbiAqXG4gQHJldHVybnMgVHJ1ZSBpZiBET00gZWxlbWVudCBpcyBtYXRjaGVkLlxuICogQHRocm93cyBBbiBlcnJvciBvbiBpbnZhbGlkIHByb3AgaW4gY2hhaW4uXG4gKi9cblxuXG5jb25zdCBpc1Byb3BlcnR5TWF0Y2hlZCA9IGFyZ3NEYXRhID0+IHtcbiAgY29uc3Qge1xuICAgIHBzZXVkb05hbWUsXG4gICAgcHNldWRvQXJnLFxuICAgIGRvbUVsZW1lbnRcbiAgfSA9IGFyZ3NEYXRhO1xuICBjb25zdCB7XG4gICAgcmF3TmFtZTogcmF3UHJvcGVydHlOYW1lLFxuICAgIHJhd1ZhbHVlOiByYXdQcm9wZXJ0eVZhbHVlXG4gIH0gPSBnZXRSYXdNYXRjaGluZ0RhdGEocHNldWRvTmFtZSwgcHNldWRvQXJnKTsgLy8gY2hhaW5lZCBwcm9wZXJ0eSBuYW1lIGNhbm5vdCBpbmNsdWRlICcvJyBvciAnLidcbiAgLy8gc28gcmVnZXggcHJvcCBuYW1lcyB3aXRoIHN1Y2ggZXNjYXBlZCBjaGFyYWN0ZXJzIGFyZSBpbnZhbGlkXG5cbiAgaWYgKHJhd1Byb3BlcnR5TmFtZS5pbmNsdWRlcygnXFxcXC8nKSB8fCByYXdQcm9wZXJ0eU5hbWUuaW5jbHVkZXMoJ1xcXFwuJykpIHtcbiAgICB0aHJvdyBuZXcgRXJyb3IoYEludmFsaWQgOiR7cHNldWRvTmFtZX0gbmFtZSBwYXR0ZXJuOiAke3Jhd1Byb3BlcnR5TmFtZX1gKTtcbiAgfVxuXG4gIGxldCBwcm9wQ2hhaW5NYXRjaGVzO1xuXG4gIHRyeSB7XG4gICAgcHJvcENoYWluTWF0Y2hlcyA9IHBhcnNlUmF3UHJvcENoYWluKHJhd1Byb3BlcnR5TmFtZSk7XG4gIH0gY2F0Y2ggKGUpIHtcbiAgICBjb25zdCBlcnJvck1lc3NhZ2UgPSBnZXRFcnJvck1lc3NhZ2UoZSk7XG4gICAgbG9nZ2VyLmVycm9yKGVycm9yTWVzc2FnZSk7XG4gICAgdGhyb3cgbmV3IFN5bnRheEVycm9yKGVycm9yTWVzc2FnZSk7XG4gIH1cblxuICBjb25zdCBvd25lck9iakFyciA9IGZpbHRlclJvb3RzQnlSZWdleHBDaGFpbihkb21FbGVtZW50LCBwcm9wQ2hhaW5NYXRjaGVzKTtcblxuICBpZiAob3duZXJPYmpBcnIubGVuZ3RoID09PSAwKSB7XG4gICAgcmV0dXJuIGZhbHNlO1xuICB9XG5cbiAgbGV0IGlzTWF0Y2hlZCA9IHRydWU7XG5cbiAgaWYgKHJhd1Byb3BlcnR5VmFsdWUpIHtcbiAgICBsZXQgcHJvcFZhbHVlTWF0Y2g7XG5cbiAgICB0cnkge1xuICAgICAgcHJvcFZhbHVlTWF0Y2ggPSBnZXRWYWxpZE1hdGNoZXJBcmcocmF3UHJvcGVydHlWYWx1ZSk7XG4gICAgfSBjYXRjaCAoZSkge1xuICAgICAgY29uc3QgZXJyb3JNZXNzYWdlID0gZ2V0RXJyb3JNZXNzYWdlKGUpO1xuICAgICAgbG9nZ2VyLmVycm9yKGVycm9yTWVzc2FnZSk7XG4gICAgICB0aHJvdyBuZXcgU3ludGF4RXJyb3IoZXJyb3JNZXNzYWdlKTtcbiAgICB9XG5cbiAgICBpZiAocHJvcFZhbHVlTWF0Y2gpIHtcbiAgICAgIGZvciAobGV0IGkgPSAwOyBpIDwgb3duZXJPYmpBcnIubGVuZ3RoOyBpICs9IDEpIHtcbiAgICAgICAgdmFyIF9vd25lck9iakFyciRpO1xuXG4gICAgICAgIGNvbnN0IHJlYWxWYWx1ZSA9IChfb3duZXJPYmpBcnIkaSA9IG93bmVyT2JqQXJyW2ldKSA9PT0gbnVsbCB8fCBfb3duZXJPYmpBcnIkaSA9PT0gdm9pZCAwID8gdm9pZCAwIDogX293bmVyT2JqQXJyJGkudmFsdWU7XG5cbiAgICAgICAgaWYgKHByb3BWYWx1ZU1hdGNoIGluc3RhbmNlb2YgUmVnRXhwKSB7XG4gICAgICAgICAgaXNNYXRjaGVkID0gcHJvcFZhbHVlTWF0Y2gudGVzdChjb252ZXJ0VHlwZUludG9TdHJpbmcocmVhbFZhbHVlKSk7XG4gICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgLy8gaGFuZGxlICdudWxsJyBhbmQgJ3VuZGVmaW5lZCcgcHJvcGVydHkgdmFsdWVzIHNldCBhcyBzdHJpbmdcbiAgICAgICAgICBpZiAocmVhbFZhbHVlID09PSAnbnVsbCcgfHwgcmVhbFZhbHVlID09PSAndW5kZWZpbmVkJykge1xuICAgICAgICAgICAgaXNNYXRjaGVkID0gcHJvcFZhbHVlTWF0Y2ggPT09IHJlYWxWYWx1ZTtcbiAgICAgICAgICAgIGJyZWFrO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIGlzTWF0Y2hlZCA9IGNvbnZlcnRUeXBlRnJvbVN0cmluZyhwcm9wVmFsdWVNYXRjaCkgPT09IHJlYWxWYWx1ZTtcbiAgICAgICAgfVxuXG4gICAgICAgIGlmIChpc01hdGNoZWQpIHtcbiAgICAgICAgICBicmVhaztcbiAgICAgICAgfVxuICAgICAgfVxuICAgIH1cbiAgfVxuXG4gIHJldHVybiBpc01hdGNoZWQ7XG59O1xuLyoqXG4gKiBDaGVja3Mgd2hldGhlciB0aGUgdGV4dENvbnRlbnQgaXMgbWF0Y2hlZCBieSA6Y29udGFpbnMgYXJnLlxuICpcbiAqIEBwYXJhbSBhcmdzRGF0YSBQc2V1ZG8tY2xhc3MgbmFtZSwgYXJnLCBhbmQgZG9tIGVsZW1lbnQgdG8gY2hlY2suXG4gKlxuIEByZXR1cm5zIFRydWUgaWYgRE9NIGVsZW1lbnQgaXMgbWF0Y2hlZC5cbiAqIEB0aHJvd3MgQW4gZXJyb3Igb24gaW52YWxpZCBhcmcgb2YgcHNldWRvLWNsYXNzLlxuICovXG5cbmNvbnN0IGlzVGV4dE1hdGNoZWQgPSBhcmdzRGF0YSA9PiB7XG4gIGNvbnN0IHtcbiAgICBwc2V1ZG9OYW1lLFxuICAgIHBzZXVkb0FyZyxcbiAgICBkb21FbGVtZW50XG4gIH0gPSBhcmdzRGF0YTtcbiAgY29uc3QgdGV4dENvbnRlbnQgPSBnZXROb2RlVGV4dENvbnRlbnQoZG9tRWxlbWVudCk7XG4gIGxldCBpc1RleHRDb250ZW50TWF0Y2hlZDtcbiAgbGV0IHBzZXVkb0FyZ1RvTWF0Y2ggPSBwc2V1ZG9Bcmc7XG5cbiAgaWYgKHBzZXVkb0FyZ1RvTWF0Y2guc3RhcnRzV2l0aChTTEFTSCkgJiYgUkVHRVhQX1dJVEhfRkxBR1NfUkVHRVhQLnRlc3QocHNldWRvQXJnVG9NYXRjaCkpIHtcbiAgICAvLyByZWdleHAgYXJnXG4gICAgY29uc3QgZmxhZ3NJbmRleCA9IHBzZXVkb0FyZ1RvTWF0Y2gubGFzdEluZGV4T2YoJy8nKTtcbiAgICBjb25zdCBmbGFnc1N0ciA9IHBzZXVkb0FyZ1RvTWF0Y2guc3Vic3RyaW5nKGZsYWdzSW5kZXggKyAxKTtcbiAgICBwc2V1ZG9BcmdUb01hdGNoID0gcHNldWRvQXJnVG9NYXRjaC5zdWJzdHJpbmcoMCwgZmxhZ3NJbmRleCArIDEpLnNsaWNlKDEsIC0xKS5yZXBsYWNlKC9cXFxcKFtcXFxcXCJdKS9nLCAnJDEnKTtcbiAgICBsZXQgcmVnZXg7XG5cbiAgICB0cnkge1xuICAgICAgcmVnZXggPSBuZXcgUmVnRXhwKHBzZXVkb0FyZ1RvTWF0Y2gsIGZsYWdzU3RyKTtcbiAgICB9IGNhdGNoIChlKSB7XG4gICAgICB0aHJvdyBuZXcgRXJyb3IoYEludmFsaWQgYXJndW1lbnQgb2YgOiR7cHNldWRvTmFtZX0oKSBwc2V1ZG8tY2xhc3M6ICR7cHNldWRvQXJnfWApO1xuICAgIH1cblxuICAgIGlzVGV4dENvbnRlbnRNYXRjaGVkID0gcmVnZXgudGVzdCh0ZXh0Q29udGVudCk7XG4gIH0gZWxzZSB7XG4gICAgLy8gbm9uZS1yZWdleHAgYXJnXG4gICAgcHNldWRvQXJnVG9NYXRjaCA9IHBzZXVkb0FyZ1RvTWF0Y2gucmVwbGFjZSgvXFxcXChbXFxcXCgpW1xcXVwiXSkvZywgJyQxJyk7XG4gICAgaXNUZXh0Q29udGVudE1hdGNoZWQgPSB0ZXh0Q29udGVudC5pbmNsdWRlcyhwc2V1ZG9BcmdUb01hdGNoKTtcbiAgfVxuXG4gIHJldHVybiBpc1RleHRDb250ZW50TWF0Y2hlZDtcbn07XG5cbi8qKlxuICogVmFsaWRhdGVzIG51bWJlciBhcmcgZm9yIDpudGgtYW5jZXN0b3IoKSBhbmQgOnVwd2FyZCgpIHBzZXVkby1jbGFzc2VzLlxuICpcbiAqIEBwYXJhbSByYXdBcmcgUmF3IGFyZyBvZiBwc2V1ZG8tY2xhc3MuXG4gKiBAcGFyYW0gcHNldWRvTmFtZSBQc2V1ZG8tY2xhc3MgbmFtZS5cbiAqXG4gKiBAcmV0dXJucyBWYWxpZCBudW1iZXIgYXJnIGZvciA6bnRoLWFuY2VzdG9yKCkgYW5kIDp1cHdhcmQoKS5cbiAqIEB0aHJvd3MgQW4gZXJyb3Igb24gaW52YWxpZCBgcmF3QXJnYC5cbiAqL1xuY29uc3QgZ2V0VmFsaWROdW1iZXJBbmNlc3RvckFyZyA9IChyYXdBcmcsIHBzZXVkb05hbWUpID0+IHtcbiAgY29uc3QgZGVlcCA9IE51bWJlcihyYXdBcmcpO1xuXG4gIGlmIChOdW1iZXIuaXNOYU4oZGVlcCkgfHwgZGVlcCA8IDEgfHwgZGVlcCA+PSAyNTYpIHtcbiAgICB0aHJvdyBuZXcgRXJyb3IoYEludmFsaWQgYXJndW1lbnQgb2YgOiR7cHNldWRvTmFtZX0gcHNldWRvLWNsYXNzOiAnJHtyYXdBcmd9J2ApO1xuICB9XG5cbiAgcmV0dXJuIGRlZXA7XG59O1xuLyoqXG4gKiBSZXR1cm5zIG50aCBhbmNlc3RvciBieSAnZGVlcCcgbnVtYmVyIGFyZyBPUiB1bmRlZmluZWQgaWYgYW5jZXN0b3IgcmFuZ2UgbGltaXQgZXhjZWVkZWQuXG4gKlxuICogQHBhcmFtIGRvbUVsZW1lbnQgRE9NIGVsZW1lbnQgdG8gZmluZCBhbmNlc3RvciBmb3IuXG4gKiBAcGFyYW0gbnRoIERlcHRoIHVwIHRvIG5lZWRlZCBhbmNlc3Rvci5cbiAqIEBwYXJhbSBwc2V1ZG9OYW1lIFBzZXVkby1jbGFzcyBuYW1lLlxuICpcbiAqIEByZXR1cm5zIEFuY2VzdG9yIGVsZW1lbnQgZm91bmQgaW4gRE9NLCBvciBudWxsIGlmIG5vdCBmb3VuZC5cbiAqIEB0aHJvd3MgQW4gZXJyb3Igb24gaW52YWxpZCBgbnRoYCBhcmcuXG4gKi9cblxuY29uc3QgZ2V0TnRoQW5jZXN0b3IgPSAoZG9tRWxlbWVudCwgbnRoLCBwc2V1ZG9OYW1lKSA9PiB7XG4gIGxldCBhbmNlc3RvciA9IG51bGw7XG4gIGxldCBpID0gMDtcblxuICB3aGlsZSAoaSA8IG50aCkge1xuICAgIGFuY2VzdG9yID0gZG9tRWxlbWVudC5wYXJlbnRFbGVtZW50O1xuXG4gICAgaWYgKCFhbmNlc3Rvcikge1xuICAgICAgdGhyb3cgbmV3IEVycm9yKGBPdXQgb2YgRE9NOiBBcmd1bWVudCBvZiA6JHtwc2V1ZG9OYW1lfSgpIHBzZXVkby1jbGFzcyBpcyB0b28gYmlnIOKAlCAnJHtudGh9Jy5gKTtcbiAgICB9XG5cbiAgICBkb21FbGVtZW50ID0gYW5jZXN0b3I7XG4gICAgaSArPSAxO1xuICB9XG5cbiAgcmV0dXJuIGFuY2VzdG9yO1xufTtcbi8qKlxuICogVmFsaWRhdGVzIHN0YW5kYXJkIENTUyBzZWxlY3Rvci5cbiAqXG4gKiBAcGFyYW0gc2VsZWN0b3IgU3RhbmRhcmQgc2VsZWN0b3IuXG4gKlxuICogQHJldHVybnMgVHJ1ZSBpZiBzdGFuZGFyZCBDU1Mgc2VsZWN0b3IgaXMgdmFsaWQuXG4gKi9cblxuY29uc3QgdmFsaWRhdGVTdGFuZGFyZFNlbGVjdG9yID0gc2VsZWN0b3IgPT4ge1xuICBsZXQgaXNWYWxpZDtcblxuICB0cnkge1xuICAgIGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3JBbGwoc2VsZWN0b3IpO1xuICAgIGlzVmFsaWQgPSB0cnVlO1xuICB9IGNhdGNoIChlKSB7XG4gICAgaXNWYWxpZCA9IGZhbHNlO1xuICB9XG5cbiAgcmV0dXJuIGlzVmFsaWQ7XG59O1xuXG4vKipcbiAqIFdyYXBwZXIgdG8gcnVuIG1hdGNoZXIgYGNhbGxiYWNrYCB3aXRoIGBhcmdzYFxuICogYW5kIHRocm93IGVycm9yIHdpdGggYGVycm9yTWVzc2FnZWAgaWYgYGNhbGxiYWNrYCBydW4gZmFpbHMuXG4gKlxuICogQHBhcmFtIGNhbGxiYWNrIE1hdGNoZXIgY2FsbGJhY2suXG4gKiBAcGFyYW0gYXJnc0RhdGEgQXJncyBuZWVkZWQgZm9yIG1hdGNoZXIgY2FsbGJhY2suXG4gKiBAcGFyYW0gZXJyb3JNZXNzYWdlIEVycm9yIG1lc3NhZ2UuXG4gKlxuICogQHJldHVybnMgVHJ1ZSBpZiBgY2FsbGJhY2tgIHJldHVybnMgdHJ1ZS5cbiAqIEB0aHJvd3MgQW4gZXJyb3IgaWYgYGNhbGxiYWNrYCBmYWlscy5cbiAqL1xuY29uc3QgbWF0Y2hlcldyYXBwZXIgPSAoY2FsbGJhY2ssIGFyZ3NEYXRhLCBlcnJvck1lc3NhZ2UpID0+IHtcbiAgbGV0IGlzTWF0Y2hlZDtcblxuICB0cnkge1xuICAgIGlzTWF0Y2hlZCA9IGNhbGxiYWNrKGFyZ3NEYXRhKTtcbiAgfSBjYXRjaCAoZSkge1xuICAgIGxvZ2dlci5lcnJvcihnZXRFcnJvck1lc3NhZ2UoZSkpO1xuICAgIHRocm93IG5ldyBFcnJvcihlcnJvck1lc3NhZ2UpO1xuICB9XG5cbiAgcmV0dXJuIGlzTWF0Y2hlZDtcbn07XG4vKipcbiAqIEdlbmVyYXRlcyBjb21tb24gZXJyb3IgbWVzc2FnZSB0byB0aHJvdyB3aGlsZSBtYXRjaGluZyBlbGVtZW50IGBwcm9wRGVzY2AuXG4gKlxuICogQHBhcmFtIHByb3BEZXNjIFRleHQgdG8gZGVzY3JpYmUgd2hhdCBlbGVtZW50ICdwcm9wJyBwc2V1ZG8tY2xhc3MgaXMgdHJ5aW5nIHRvIG1hdGNoLlxuICogQHBhcmFtIHBzZXVkb05hbWUgUHNldWRvLWNsYXNzIG5hbWUuXG4gKiBAcGFyYW0gcHNldWRvQXJnIFBzZXVkby1jbGFzcyBhcmcuXG4gKlxuICogQHJldHVybnMgR2VuZXJhdGVkIGVycm9yIG1lc3NhZ2Ugc3RyaW5nLlxuICovXG5cblxuY29uc3QgZ2V0QWJzb2x1dGVQc2V1ZG9FcnJvciA9IChwcm9wRGVzYywgcHNldWRvTmFtZSwgcHNldWRvQXJnKSA9PiB7XG4gIC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBtYXgtbGVuXG4gIHJldHVybiBgJHtNQVRDSElOR19FTEVNRU5UX0VSUk9SX1BSRUZJWH0gJHtwcm9wRGVzY30sIG1heSBiZSBpbnZhbGlkIDoke3BzZXVkb05hbWV9KCkgcHNldWRvLWNsYXNzIGFyZzogJyR7cHNldWRvQXJnfSdgO1xufTtcbi8qKlxuICogQ2hlY2tzIHdoZXRoZXIgdGhlIGRvbUVsZW1lbnQgaXMgbWF0Y2hlZCBieSBhYnNvbHV0ZSBleHRlbmRlZCBwc2V1ZG8tY2xhc3MgYXJndW1lbnQuXG4gKlxuICogQHBhcmFtIGRvbUVsZW1lbnQgUGFnZSBlbGVtZW50LlxuICogQHBhcmFtIHBzZXVkb05hbWUgUHNldWRvLWNsYXNzIG5hbWUuXG4gKiBAcGFyYW0gcHNldWRvQXJnIFBzZXVkby1jbGFzcyBhcmcuXG4gKlxuICogQHJldHVybnMgVHJ1ZSBpZiBgZG9tRWxlbWVudGAgaXMgbWF0Y2hlZCBieSBhYnNvbHV0ZSBwc2V1ZG8tY2xhc3MuXG4gKiBAdGhyb3dzIEFuIGVycm9yIG9uIHVua25vd24gYWJzb2x1dGUgcHNldWRvLWNsYXNzLlxuICovXG5cblxuY29uc3QgaXNNYXRjaGVkQnlBYnNvbHV0ZVBzZXVkbyA9IChkb21FbGVtZW50LCBwc2V1ZG9OYW1lLCBwc2V1ZG9BcmcpID0+IHtcbiAgbGV0IGFyZ3NEYXRhO1xuICBsZXQgZXJyb3JNZXNzYWdlO1xuICBsZXQgY2FsbGJhY2s7XG5cbiAgc3dpdGNoIChwc2V1ZG9OYW1lKSB7XG4gICAgY2FzZSBDT05UQUlOU19QU0VVRE86XG4gICAgY2FzZSBIQVNfVEVYVF9QU0VVRE86XG4gICAgY2FzZSBBQlBfQ09OVEFJTlNfUFNFVURPOlxuICAgICAgY2FsbGJhY2sgPSBpc1RleHRNYXRjaGVkO1xuICAgICAgYXJnc0RhdGEgPSB7XG4gICAgICAgIHBzZXVkb05hbWUsXG4gICAgICAgIHBzZXVkb0FyZyxcbiAgICAgICAgZG9tRWxlbWVudFxuICAgICAgfTtcbiAgICAgIGVycm9yTWVzc2FnZSA9IGdldEFic29sdXRlUHNldWRvRXJyb3IoJ3RleHQgY29udGVudCcsIHBzZXVkb05hbWUsIHBzZXVkb0FyZyk7XG4gICAgICBicmVhaztcblxuICAgIGNhc2UgTUFUQ0hFU19DU1NfUFNFVURPOlxuICAgIGNhc2UgTUFUQ0hFU19DU1NfQUZURVJfUFNFVURPOlxuICAgIGNhc2UgTUFUQ0hFU19DU1NfQkVGT1JFX1BTRVVETzpcbiAgICAgIGNhbGxiYWNrID0gaXNTdHlsZU1hdGNoZWQ7XG4gICAgICBhcmdzRGF0YSA9IHtcbiAgICAgICAgcHNldWRvTmFtZSxcbiAgICAgICAgcHNldWRvQXJnLFxuICAgICAgICBkb21FbGVtZW50XG4gICAgICB9O1xuICAgICAgZXJyb3JNZXNzYWdlID0gZ2V0QWJzb2x1dGVQc2V1ZG9FcnJvcignc3R5bGUnLCBwc2V1ZG9OYW1lLCBwc2V1ZG9BcmcpO1xuICAgICAgYnJlYWs7XG5cbiAgICBjYXNlIE1BVENIRVNfQVRUUl9QU0VVRE9fQ0xBU1NfTUFSS0VSOlxuICAgICAgY2FsbGJhY2sgPSBpc0F0dHJpYnV0ZU1hdGNoZWQ7XG4gICAgICBhcmdzRGF0YSA9IHtcbiAgICAgICAgZG9tRWxlbWVudCxcbiAgICAgICAgcHNldWRvTmFtZSxcbiAgICAgICAgcHNldWRvQXJnXG4gICAgICB9O1xuICAgICAgZXJyb3JNZXNzYWdlID0gZ2V0QWJzb2x1dGVQc2V1ZG9FcnJvcignYXR0cmlidXRlcycsIHBzZXVkb05hbWUsIHBzZXVkb0FyZyk7XG4gICAgICBicmVhaztcblxuICAgIGNhc2UgTUFUQ0hFU19QUk9QRVJUWV9QU0VVRE9fQ0xBU1NfTUFSS0VSOlxuICAgICAgY2FsbGJhY2sgPSBpc1Byb3BlcnR5TWF0Y2hlZDtcbiAgICAgIGFyZ3NEYXRhID0ge1xuICAgICAgICBkb21FbGVtZW50LFxuICAgICAgICBwc2V1ZG9OYW1lLFxuICAgICAgICBwc2V1ZG9BcmdcbiAgICAgIH07XG4gICAgICBlcnJvck1lc3NhZ2UgPSBnZXRBYnNvbHV0ZVBzZXVkb0Vycm9yKCdwcm9wZXJ0aWVzJywgcHNldWRvTmFtZSwgcHNldWRvQXJnKTtcbiAgICAgIGJyZWFrO1xuXG4gICAgZGVmYXVsdDpcbiAgICAgIHRocm93IG5ldyBFcnJvcihgVW5rbm93biBhYnNvbHV0ZSBwc2V1ZG8tY2xhc3MgOiR7cHNldWRvTmFtZX0oKWApO1xuICB9XG5cbiAgcmV0dXJuIG1hdGNoZXJXcmFwcGVyKGNhbGxiYWNrLCBhcmdzRGF0YSwgZXJyb3JNZXNzYWdlKTtcbn07XG5jb25zdCBmaW5kQnlBYnNvbHV0ZVBzZXVkb1BzZXVkbyA9IHtcbiAgLyoqXG4gICAqIFJldHVybnMgbGlzdCBvZiBudGggYW5jZXN0b3JzIHJlbGF0aXZlIHRvIGV2ZXJ5IGRvbSBub2RlIGZyb20gZG9tRWxlbWVudHMgbGlzdC5cbiAgICpcbiAgICogQHBhcmFtIGRvbUVsZW1lbnRzIERPTSBlbGVtZW50cy5cbiAgICogQHBhcmFtIHJhd1BzZXVkb0FyZyBOdW1iZXIgYXJnIG9mIDpudGgtYW5jZXN0b3IoKSBvciA6dXB3YXJkKCkgcHNldWRvLWNsYXNzLlxuICAgKiBAcGFyYW0gcHNldWRvTmFtZSBQc2V1ZG8tY2xhc3MgbmFtZS5cbiAgICpcbiAgICogQHJldHVybnMgQXJyYXkgb2YgYW5jZXN0b3IgRE9NIGVsZW1lbnRzLlxuICAgKi9cbiAgbnRoQW5jZXN0b3I6IChkb21FbGVtZW50cywgcmF3UHNldWRvQXJnLCBwc2V1ZG9OYW1lKSA9PiB7XG4gICAgY29uc3QgZGVlcCA9IGdldFZhbGlkTnVtYmVyQW5jZXN0b3JBcmcocmF3UHNldWRvQXJnLCBwc2V1ZG9OYW1lKTtcbiAgICBjb25zdCBhbmNlc3RvcnMgPSBkb21FbGVtZW50cy5tYXAoZG9tRWxlbWVudCA9PiB7XG4gICAgICBsZXQgYW5jZXN0b3IgPSBudWxsO1xuXG4gICAgICB0cnkge1xuICAgICAgICBhbmNlc3RvciA9IGdldE50aEFuY2VzdG9yKGRvbUVsZW1lbnQsIGRlZXAsIHBzZXVkb05hbWUpO1xuICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICBsb2dnZXIuZXJyb3IoZ2V0RXJyb3JNZXNzYWdlKGUpKTtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIGFuY2VzdG9yO1xuICAgIH0pLmZpbHRlcihpc0h0bWxFbGVtZW50KTtcbiAgICByZXR1cm4gYW5jZXN0b3JzO1xuICB9LFxuXG4gIC8qKlxuICAgKiBSZXR1cm5zIGxpc3Qgb2YgZWxlbWVudHMgYnkgeHBhdGggZXhwcmVzc2lvbiwgZXZhbHVhdGVkIG9uIGV2ZXJ5IGRvbSBub2RlIGZyb20gZG9tRWxlbWVudHMgbGlzdC5cbiAgICpcbiAgICogQHBhcmFtIGRvbUVsZW1lbnRzIERPTSBlbGVtZW50cy5cbiAgICogQHBhcmFtIHJhd1BzZXVkb0FyZyBBcmcgb2YgOnhwYXRoKCkgcHNldWRvLWNsYXNzLlxuICAgKlxuICAgKiBAcmV0dXJucyBBcnJheSBvZiBET00gZWxlbWVudHMgbWF0Y2hlZCBieSB4cGF0aCBleHByZXNzaW9uLlxuICAgKi9cbiAgeHBhdGg6IChkb21FbGVtZW50cywgcmF3UHNldWRvQXJnKSA9PiB7XG4gICAgY29uc3QgZm91bmRFbGVtZW50cyA9IGRvbUVsZW1lbnRzLm1hcChkb21FbGVtZW50ID0+IHtcbiAgICAgIGNvbnN0IHJlc3VsdCA9IFtdO1xuICAgICAgbGV0IHhwYXRoUmVzdWx0O1xuXG4gICAgICB0cnkge1xuICAgICAgICB4cGF0aFJlc3VsdCA9IGRvY3VtZW50LmV2YWx1YXRlKHJhd1BzZXVkb0FyZywgZG9tRWxlbWVudCwgbnVsbCwgd2luZG93LlhQYXRoUmVzdWx0LlVOT1JERVJFRF9OT0RFX0lURVJBVE9SX1RZUEUsIG51bGwpO1xuICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICBsb2dnZXIuZXJyb3IoZ2V0RXJyb3JNZXNzYWdlKGUpKTtcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKGBJbnZhbGlkIGFyZ3VtZW50IG9mIDp4cGF0aCgpIHBzZXVkby1jbGFzczogJyR7cmF3UHNldWRvQXJnfSdgKTtcbiAgICAgIH1cblxuICAgICAgbGV0IG5vZGUgPSB4cGF0aFJlc3VsdC5pdGVyYXRlTmV4dCgpO1xuXG4gICAgICB3aGlsZSAobm9kZSkge1xuICAgICAgICBpZiAoaXNIdG1sRWxlbWVudChub2RlKSkge1xuICAgICAgICAgIHJlc3VsdC5wdXNoKG5vZGUpO1xuICAgICAgICB9XG5cbiAgICAgICAgbm9kZSA9IHhwYXRoUmVzdWx0Lml0ZXJhdGVOZXh0KCk7XG4gICAgICB9XG5cbiAgICAgIHJldHVybiByZXN1bHQ7XG4gICAgfSk7XG4gICAgcmV0dXJuIGZsYXR0ZW4oZm91bmRFbGVtZW50cyk7XG4gIH0sXG5cbiAgLyoqXG4gICAqIFJldHVybnMgbGlzdCBvZiBjbG9zZXN0IGFuY2VzdG9ycyByZWxhdGl2ZSB0byBldmVyeSBkb20gbm9kZSBmcm9tIGRvbUVsZW1lbnRzIGxpc3QuXG4gICAqXG4gICAqIEBwYXJhbSBkb21FbGVtZW50cyBET00gZWxlbWVudHMuXG4gICAqIEBwYXJhbSByYXdQc2V1ZG9BcmcgU3RhbmRhcmQgc2VsZWN0b3IgYXJnIG9mIDp1cHdhcmQoKSBwc2V1ZG8tY2xhc3MuXG4gICAqXG4gICAqIEByZXR1cm5zIEFycmF5IG9mIGNsb3Nlc3QgYW5jZXN0b3IgRE9NIGVsZW1lbnRzLlxuICAgKiBAdGhyb3dzIEFuIGVycm9yIGlmIGByYXdQc2V1ZG9BcmdgIGlzIG5vdCBhIHZhbGlkIHN0YW5kYXJkIHNlbGVjdG9yLlxuICAgKi9cbiAgdXB3YXJkOiAoZG9tRWxlbWVudHMsIHJhd1BzZXVkb0FyZykgPT4ge1xuICAgIGlmICghdmFsaWRhdGVTdGFuZGFyZFNlbGVjdG9yKHJhd1BzZXVkb0FyZykpIHtcbiAgICAgIHRocm93IG5ldyBFcnJvcihgSW52YWxpZCBhcmd1bWVudCBvZiA6dXB3YXJkIHBzZXVkby1jbGFzczogJyR7cmF3UHNldWRvQXJnfSdgKTtcbiAgICB9XG5cbiAgICBjb25zdCBjbG9zZXN0QW5jZXN0b3JzID0gZG9tRWxlbWVudHMubWFwKGRvbUVsZW1lbnQgPT4ge1xuICAgICAgLy8gY2xvc2VzdCB0byBwYXJlbnQgZWxlbWVudCBzaG91bGQgYmUgZm91bmRcbiAgICAgIC8vIG90aGVyd2lzZSBgLmJhc2U6dXB3YXJkKC5iYXNlKWAgd2lsbCByZXR1cm4gaXRzZWxmIHRvbywgbm90IG9ubHkgYW5jZXN0b3JcbiAgICAgIGNvbnN0IHBhcmVudCA9IGRvbUVsZW1lbnQucGFyZW50RWxlbWVudDtcblxuICAgICAgaWYgKCFwYXJlbnQpIHtcbiAgICAgICAgcmV0dXJuIG51bGw7XG4gICAgICB9XG5cbiAgICAgIHJldHVybiBwYXJlbnQuY2xvc2VzdChyYXdQc2V1ZG9BcmcpO1xuICAgIH0pLmZpbHRlcihpc0h0bWxFbGVtZW50KTtcbiAgICByZXR1cm4gY2xvc2VzdEFuY2VzdG9ycztcbiAgfVxufTtcblxuLyoqXG4gKiBDYWxjdWxhdGVkIHNlbGVjdG9yIHRleHQgd2hpY2ggaXMgbmVlZGVkIHRvIDpoYXMoKSwgOmlzKCkgYW5kIDpub3QoKSBwc2V1ZG8tY2xhc3Nlcy5cbiAqIENvbnRhaW5zIGNhbGN1bGF0ZWQgcGFydCAoZGVwZW5kcyBvbiB0aGUgcHJvY2Vzc2VkIGVsZW1lbnQpXG4gKiBhbmQgdmFsdWUgb2YgUmVndWxhclNlbGVjdG9yIHdoaWNoIGlzIG5leHQgdG8gc2VsZWN0b3IgYnkuXG4gKlxuICogTmF0aXZlIERvY3VtZW50LnF1ZXJ5U2VsZWN0b3JBbGwoKSBkb2VzIG5vdCBzZWxlY3QgZXhhY3QgZGVzY2VuZGFudCBlbGVtZW50c1xuICogYnV0IG1hdGNoIGFsbCBwYWdlIGVsZW1lbnRzIHNhdGlzZnlpbmcgdGhlIHNlbGVjdG9yLFxuICogc28gZXh0cmEgc3BlY2lmaWNhdGlvbiBpcyBuZWVkZWQgZm9yIHByb3BlciBkZXNjZW5kYW50cyBzZWxlY3Rpb25cbiAqIGUuZy4gJ2RpdjpoYXMoPiBpbWcpJy5cbiAqXG4gKiBJdHMgY2FsY3VsYXRpb24gZGVwZW5kcyBvbiBleHRlbmRlZCBzZWxlY3Rvci5cbiAqL1xuXG4vKipcbiAqIENvbWJpbmVkIGA6c2NvcGVgIHBzZXVkby1jbGFzcyBhbmQgKipjaGlsZCoqIGNvbWJpbmF0b3Ig4oCUIGA6c2NvcGU+YC5cbiAqL1xuY29uc3Qgc2NvcGVEaXJlY3RDaGlsZHJlbiA9IGAke1NDT1BFX0NTU19QU0VVRE9fQ0xBU1N9JHtDSElMRF9DT01CSU5BVE9SfWA7XG4vKipcbiAqIENvbWJpbmVkIGA6c2NvcGVgIHBzZXVkby1jbGFzcyBhbmQgKipkZXNjZW5kYW50KiogY29tYmluYXRvciDigJQgYDpzY29wZSBgLlxuICovXG5cbmNvbnN0IHNjb3BlQW55Q2hpbGRyZW4gPSBgJHtTQ09QRV9DU1NfUFNFVURPX0NMQVNTfSR7REVTQ0VOREFOVF9DT01CSU5BVE9SfWA7XG4vKipcbiAqIFR5cGUgZm9yIHJlbGF0aXZlIHBzZXVkby1jbGFzcyBoZWxwZXJzIGFyZ3MuXG4gKi9cblxuLyoqXG4gKiBSZXR1cm5zIHRoZSBmaXJzdCBvZiBSZWd1bGFyU2VsZWN0b3IgY2hpbGQgbm9kZSBmb3IgYHNlbGVjdG9yTm9kZWAuXG4gKlxuICogQHBhcmFtIHNlbGVjdG9yTm9kZSBBc3QgU2VsZWN0b3Igbm9kZS5cbiAqIEBwYXJhbSBwc2V1ZG9OYW1lIE5hbWUgb2YgcmVsYXRpdmUgcHNldWRvLWNsYXNzLlxuICpcbiAqIEByZXR1cm5zIEFzdCBSZWd1bGFyU2VsZWN0b3Igbm9kZS5cbiAqL1xuY29uc3QgZ2V0Rmlyc3RJbm5lclJlZ3VsYXJDaGlsZCA9IChzZWxlY3Rvck5vZGUsIHBzZXVkb05hbWUpID0+IHtcbiAgcmV0dXJuIGdldEZpcnN0UmVndWxhckNoaWxkKHNlbGVjdG9yTm9kZS5jaGlsZHJlbiwgYFJlZ3VsYXJTZWxlY3RvciBpcyBtaXNzaW5nIGZvciA6JHtwc2V1ZG9OYW1lfSgpIHBzZXVkby1jbGFzc2ApO1xufTsgLy8gVE9ETzogZml4IGZvciA8Zm9yZ2l2aW5nLXJlbGF0aXZlLXNlbGVjdG9yLWxpc3Q+XG4vLyBodHRwczovL2dpdGh1Yi5jb20vQWRndWFyZFRlYW0vRXh0ZW5kZWRDc3MvaXNzdWVzLzE1NFxuXG4vKipcbiAqIENoZWNrcyB3aGV0aGVyIHRoZSBlbGVtZW50IGhhcyBhbGwgcmVsYXRpdmUgZWxlbWVudHMgc3BlY2lmaWVkIGJ5IHBzZXVkby1jbGFzcyBhcmcuXG4gKiBVc2VkIGZvciA6aGFzKCkgcHNldWRvLWNsYXNzLlxuICpcbiAqIEBwYXJhbSBhcmdzRGF0YSBSZWxhdGl2ZSBwc2V1ZG8tY2xhc3MgaGVscGVycyBhcmdzIGRhdGEuXG4gKlxuICogQHJldHVybnMgVHJ1ZSBpZiAqKmFsbCBzZWxlY3RvcnMqKiBmcm9tIGFyZ3NEYXRhLnJlbGF0aXZlU2VsZWN0b3JMaXN0IGlzICoqbWF0Y2hlZCoqIGZvciBhcmdzRGF0YS5lbGVtZW50LlxuICovXG5cblxuY29uc3QgaGFzUmVsYXRpdmVzQnlTZWxlY3Rvckxpc3QgPSBhcmdzRGF0YSA9PiB7XG4gIGNvbnN0IHtcbiAgICBlbGVtZW50LFxuICAgIHJlbGF0aXZlU2VsZWN0b3JMaXN0LFxuICAgIHBzZXVkb05hbWVcbiAgfSA9IGFyZ3NEYXRhO1xuICByZXR1cm4gcmVsYXRpdmVTZWxlY3Rvckxpc3QuY2hpbGRyZW4gLy8gQXJyYXkuZXZlcnkoKSBpcyB1c2VkIGhlcmUgYXMgZWFjaCBTZWxlY3RvciBub2RlIGZyb20gU2VsZWN0b3JMaXN0IHNob3VsZCBleGlzdCBvbiBwYWdlXG4gIC5ldmVyeShzZWxlY3Rvck5vZGUgPT4ge1xuICAgIC8vIHNlbGVjdG9yTGlzdC5jaGlsZHJlbiBhbHdheXMgc3RhcnRzIHdpdGggcmVndWxhciBzZWxlY3RvciBhcyBhbnkgc2VsZWN0b3IgZ2VuZXJhbGx5XG4gICAgY29uc3QgcmVsYXRpdmVSZWd1bGFyU2VsZWN0b3IgPSBnZXRGaXJzdElubmVyUmVndWxhckNoaWxkKHNlbGVjdG9yTm9kZSwgcHNldWRvTmFtZSk7XG4gICAgbGV0IHNwZWNpZmllZFNlbGVjdG9yID0gJyc7XG4gICAgbGV0IHJvb3RFbGVtZW50ID0gbnVsbDtcbiAgICBjb25zdCByZWd1bGFyU2VsZWN0b3IgPSBnZXROb2RlVmFsdWUocmVsYXRpdmVSZWd1bGFyU2VsZWN0b3IpO1xuXG4gICAgaWYgKHJlZ3VsYXJTZWxlY3Rvci5zdGFydHNXaXRoKE5FWFRfU0lCTElOR19DT01CSU5BVE9SKSB8fCByZWd1bGFyU2VsZWN0b3Iuc3RhcnRzV2l0aChTVUJTRVFVRU5UX1NJQkxJTkdfQ09NQklOQVRPUikpIHtcbiAgICAgIC8qKlxuICAgICAgICogRm9yIG1hdGNoaW5nIHRoZSBlbGVtZW50IGJ5IFwiZWxlbWVudDpoYXMoKyBuZXh0LXNpYmxpbmcpXCIgYW5kIFwiZWxlbWVudDpoYXMofiBzaWJsaW5nKVwiXG4gICAgICAgKiB3ZSBjaGVjayB3aGV0aGVyIHRoZSBlbGVtZW50J3MgcGFyZW50RWxlbWVudCBoYXMgc3BlY2lmaWMgZGlyZWN0IGNoaWxkIGNvbWJpbmF0aW9uLFxuICAgICAgICogZS5nLiAnaDE6aGFzKCsgLnNoYXJlKScgLT4gYGgxTm9kZS5wYXJlbnRFbGVtZW50LnF1ZXJ5U2VsZWN0b3JBbGwoJzpzY29wZSA+IGgxICsgLnNoYXJlJylgLlxuICAgICAgICpcbiAgICAgICAqIEBzZWUge0BsaW5rIGh0dHBzOi8vd3d3LnczLm9yZy9UUi9zZWxlY3RvcnMtNC8jcmVsYXRpb25hbH1cbiAgICAgICAqL1xuICAgICAgcm9vdEVsZW1lbnQgPSBlbGVtZW50LnBhcmVudEVsZW1lbnQ7XG4gICAgICBjb25zdCBlbGVtZW50U2VsZWN0b3JUZXh0ID0gZ2V0RWxlbWVudFNlbGVjdG9yRGVzYyhlbGVtZW50KTtcbiAgICAgIHNwZWNpZmllZFNlbGVjdG9yID0gYCR7c2NvcGVEaXJlY3RDaGlsZHJlbn0ke2VsZW1lbnRTZWxlY3RvclRleHR9JHtyZWd1bGFyU2VsZWN0b3J9YDtcbiAgICB9IGVsc2UgaWYgKHJlZ3VsYXJTZWxlY3RvciA9PT0gQVNURVJJU0spIHtcbiAgICAgIC8qKlxuICAgICAgICogOnNjb3BlIHNwZWNpZmljYXRpb24gaXMgbmVlZGVkIGZvciBwcm9wZXIgZGVzY2VuZGFudHMgc2VsZWN0aW9uXG4gICAgICAgKiBhcyBuYXRpdmUgZWxlbWVudC5xdWVyeVNlbGVjdG9yQWxsKCkgZG9lcyBub3Qgc2VsZWN0IGV4YWN0IGVsZW1lbnQgZGVzY2VuZGFudHNcbiAgICAgICAqIGUuZy4gJ2E6aGFzKD4gaW1nKScgLT4gYGFOb2RlLnF1ZXJ5U2VsZWN0b3JBbGwoJzpzY29wZSA+IGltZycpYC5cbiAgICAgICAqXG4gICAgICAgKiBGb3IgJ2FueSBzZWxlY3RvcicgYXMgYXJnIG9mIHJlbGF0aXZlIHNpbXBsaWNpdHkgc2hvdWxkIGJlIHNldCBmb3IgYWxsIGlubmVyIGVsZW1lbnRzXG4gICAgICAgKiBlLmcuICdkaXY6aGFzKCopJyAtPiBgZGl2Tm9kZS5xdWVyeVNlbGVjdG9yQWxsKCc6c2NvcGUgKicpYFxuICAgICAgICogd2hpY2ggbWVhbnMgZW1wdHkgZGl2IHdpdGggbm8gY2hpbGQgZWxlbWVudC5cbiAgICAgICAqL1xuICAgICAgcm9vdEVsZW1lbnQgPSBlbGVtZW50O1xuICAgICAgc3BlY2lmaWVkU2VsZWN0b3IgPSBgJHtzY29wZUFueUNoaWxkcmVufSR7QVNURVJJU0t9YDtcbiAgICB9IGVsc2Uge1xuICAgICAgLyoqXG4gICAgICAgKiBBcyBpdCBkZXNjcmliZWQgYWJvdmUsIGlubmVyIGVsZW1lbnRzIHNob3VsZCBiZSBmb3VuZCB1c2luZyBgOnNjb3BlYCBwc2V1ZG8tY2xhc3NcbiAgICAgICAqIGUuZy4gJ2E6aGFzKD4gaW1nKScgLT4gYGFOb2RlLnF1ZXJ5U2VsZWN0b3JBbGwoJzpzY29wZSA+IGltZycpYFxuICAgICAgICogT1IgJy5ibG9jayhkaXYgPiBzcGFuKScgLT4gYGJsb2NrQ2xhc3NOb2RlLnF1ZXJ5U2VsZWN0b3JBbGwoJzpzY29wZSBkaXYgPiBzcGFuJylgLlxuICAgICAgICovXG4gICAgICBzcGVjaWZpZWRTZWxlY3RvciA9IGAke3Njb3BlQW55Q2hpbGRyZW59JHtyZWd1bGFyU2VsZWN0b3J9YDtcbiAgICAgIHJvb3RFbGVtZW50ID0gZWxlbWVudDtcbiAgICB9XG5cbiAgICBpZiAoIXJvb3RFbGVtZW50KSB7XG4gICAgICB0aHJvdyBuZXcgRXJyb3IoYFNlbGVjdGlvbiBieSA6JHtwc2V1ZG9OYW1lfSgpIHBzZXVkby1jbGFzcyBpcyBub3QgcG9zc2libGVgKTtcbiAgICB9XG5cbiAgICBsZXQgcmVsYXRpdmVFbGVtZW50cztcblxuICAgIHRyeSB7XG4gICAgICAvLyBlc2xpbnQtZGlzYWJsZS1uZXh0LWxpbmUgQHR5cGVzY3JpcHQtZXNsaW50L25vLXVzZS1iZWZvcmUtZGVmaW5lXG4gICAgICByZWxhdGl2ZUVsZW1lbnRzID0gZ2V0RWxlbWVudHNGb3JTZWxlY3Rvck5vZGUoc2VsZWN0b3JOb2RlLCByb290RWxlbWVudCwgc3BlY2lmaWVkU2VsZWN0b3IpO1xuICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgIGxvZ2dlci5lcnJvcihnZXRFcnJvck1lc3NhZ2UoZSkpOyAvLyBmYWlsIGZvciBpbnZhbGlkIHNlbGVjdG9yXG5cbiAgICAgIHRocm93IG5ldyBFcnJvcihgSW52YWxpZCBzZWxlY3RvciBmb3IgOiR7cHNldWRvTmFtZX0oKSBwc2V1ZG8tY2xhc3M6ICcke3JlZ3VsYXJTZWxlY3Rvcn0nYCk7XG4gICAgfVxuXG4gICAgcmV0dXJuIHJlbGF0aXZlRWxlbWVudHMubGVuZ3RoID4gMDtcbiAgfSk7XG59O1xuLyoqXG4gKiBDaGVja3Mgd2hldGhlciB0aGUgZWxlbWVudCBpcyBhbiBhbnkgZWxlbWVudCBzcGVjaWZpZWQgYnkgcHNldWRvLWNsYXNzIGFyZy5cbiAqIFVzZWQgZm9yIDppcygpIHBzZXVkby1jbGFzcy5cbiAqXG4gKiBAcGFyYW0gYXJnc0RhdGEgUmVsYXRpdmUgcHNldWRvLWNsYXNzIGhlbHBlcnMgYXJncyBkYXRhLlxuICpcbiAqIEByZXR1cm5zIFRydWUgaWYgKiphbnkgc2VsZWN0b3IqKiBmcm9tIGFyZ3NEYXRhLnJlbGF0aXZlU2VsZWN0b3JMaXN0IGlzICoqbWF0Y2hlZCoqIGZvciBhcmdzRGF0YS5lbGVtZW50LlxuICovXG5cblxuY29uc3QgaXNBbnlFbGVtZW50QnlTZWxlY3Rvckxpc3QgPSBhcmdzRGF0YSA9PiB7XG4gIGNvbnN0IHtcbiAgICBlbGVtZW50LFxuICAgIHJlbGF0aXZlU2VsZWN0b3JMaXN0LFxuICAgIHBzZXVkb05hbWVcbiAgfSA9IGFyZ3NEYXRhO1xuICByZXR1cm4gcmVsYXRpdmVTZWxlY3Rvckxpc3QuY2hpbGRyZW4gLy8gQXJyYXkuc29tZSgpIGlzIHVzZWQgaGVyZSBhcyBhbnkgc2VsZWN0b3IgZnJvbSBzZWxlY3RvciBsaXN0IHNob3VsZCBleGlzdCBvbiBwYWdlXG4gIC5zb21lKHNlbGVjdG9yTm9kZSA9PiB7XG4gICAgLy8gc2VsZWN0b3JMaXN0LmNoaWxkcmVuIGFsd2F5cyBzdGFydHMgd2l0aCByZWd1bGFyIHNlbGVjdG9yXG4gICAgY29uc3QgcmVsYXRpdmVSZWd1bGFyU2VsZWN0b3IgPSBnZXRGaXJzdElubmVyUmVndWxhckNoaWxkKHNlbGVjdG9yTm9kZSwgcHNldWRvTmFtZSk7XG4gICAgLyoqXG4gICAgICogRm9yIGNoZWNraW5nIHRoZSBlbGVtZW50IGJ5ICdkaXY6aXMoLmJhbm5lciknXG4gICAgICogd2UgY2hlY2sgd2hldGhlciB0aGUgZWxlbWVudCdzIHBhcmVudEVsZW1lbnQgaGFzIGFueSBzcGVjaWZpYyBkaXJlY3QgY2hpbGQuXG4gICAgICovXG5cbiAgICBjb25zdCByb290RWxlbWVudCA9IGdldFBhcmVudChlbGVtZW50LCBgU2VsZWN0aW9uIGJ5IDoke3BzZXVkb05hbWV9KCkgcHNldWRvLWNsYXNzIGlzIG5vdCBwb3NzaWJsZWApO1xuICAgIC8qKlxuICAgICAqIFNvIHdlIGNhbGN1bGF0ZSB0aGUgZWxlbWVudCBcImRlc2NyaXB0aW9uXCIgYnkgaXQncyB0YWduYW1lIGFuZCBhdHRyaWJ1dGVzIGZvciB0YXJnZXRpbmdcbiAgICAgKiBhbmQgdXNlIGl0IHRvIHNwZWNpZnkgdGhlIHNlbGVjdGlvblxuICAgICAqIGUuZy4gYGRpdjppcyguYmFubmVyKWAgLS0+IGBkaXZOb2RlLnBhcmVudEVsZW1lbnQucXVlcnlTZWxlY3RvckFsbCgnOnNjb3BlID4gLmJhbm5lcicpYC5cbiAgICAgKi9cblxuICAgIGNvbnN0IHNwZWNpZmllZFNlbGVjdG9yID0gYCR7c2NvcGVEaXJlY3RDaGlsZHJlbn0ke2dldE5vZGVWYWx1ZShyZWxhdGl2ZVJlZ3VsYXJTZWxlY3Rvcil9YDtcbiAgICBsZXQgYW55RWxlbWVudHM7XG5cbiAgICB0cnkge1xuICAgICAgLy8gZXNsaW50LWRpc2FibGUtbmV4dC1saW5lIEB0eXBlc2NyaXB0LWVzbGludC9uby11c2UtYmVmb3JlLWRlZmluZVxuICAgICAgYW55RWxlbWVudHMgPSBnZXRFbGVtZW50c0ZvclNlbGVjdG9yTm9kZShzZWxlY3Rvck5vZGUsIHJvb3RFbGVtZW50LCBzcGVjaWZpZWRTZWxlY3Rvcik7XG4gICAgfSBjYXRjaCAoZSkge1xuICAgICAgLy8gZG8gbm90IGZhaWwgb24gaW52YWxpZCBzZWxlY3RvcnMgZm9yIDppcygpXG4gICAgICByZXR1cm4gZmFsc2U7XG4gICAgfSAvLyBUT0RPOiBmaWd1cmUgb3V0IGhvdyB0byBoYW5kbGUgY29tcGxleCBzZWxlY3RvcnMgd2l0aCBleHRlbmRlZCBwc2V1ZG8tY2xhc3Nlc1xuICAgIC8vIChjaGVjayByZWFkbWUgLSBleHRlbmRlZC1jc3MtaXMtbGltaXRhdGlvbnMpXG4gICAgLy8gYmVjYXVzZSBgZWxlbWVudGAgYW5kIGBhbnlFbGVtZW50c2AgbWF5IGJlIGZyb20gZGlmZmVyZW50IERPTSBsZXZlbHNcblxuXG4gICAgcmV0dXJuIGFueUVsZW1lbnRzLmluY2x1ZGVzKGVsZW1lbnQpO1xuICB9KTtcbn07XG4vKipcbiAqIENoZWNrcyB3aGV0aGVyIHRoZSBlbGVtZW50IGlzIG5vdCBhbiBlbGVtZW50IHNwZWNpZmllZCBieSBwc2V1ZG8tY2xhc3MgYXJnLlxuICogVXNlZCBmb3IgOm5vdCgpIHBzZXVkby1jbGFzcy5cbiAqXG4gKiBAcGFyYW0gYXJnc0RhdGEgUmVsYXRpdmUgcHNldWRvLWNsYXNzIGhlbHBlcnMgYXJncyBkYXRhLlxuICpcbiAqIEByZXR1cm5zIFRydWUgaWYgKiphbnkgc2VsZWN0b3IqKiBmcm9tIGFyZ3NEYXRhLnJlbGF0aXZlU2VsZWN0b3JMaXN0IGlzICoqbm90IG1hdGNoZWQqKiBmb3IgYXJnc0RhdGEuZWxlbWVudC5cbiAqL1xuXG5cbmNvbnN0IG5vdEVsZW1lbnRCeVNlbGVjdG9yTGlzdCA9IGFyZ3NEYXRhID0+IHtcbiAgY29uc3Qge1xuICAgIGVsZW1lbnQsXG4gICAgcmVsYXRpdmVTZWxlY3Rvckxpc3QsXG4gICAgcHNldWRvTmFtZVxuICB9ID0gYXJnc0RhdGE7XG4gIHJldHVybiByZWxhdGl2ZVNlbGVjdG9yTGlzdC5jaGlsZHJlbiAvLyBBcnJheS5ldmVyeSgpIGlzIHVzZWQgaGVyZSBhcyBlbGVtZW50IHNob3VsZCBub3QgYmUgc2VsZWN0ZWQgYnkgYW55IHNlbGVjdG9yIGZyb20gc2VsZWN0b3IgbGlzdFxuICAuZXZlcnkoc2VsZWN0b3JOb2RlID0+IHtcbiAgICAvLyBzZWxlY3Rvckxpc3QuY2hpbGRyZW4gYWx3YXlzIHN0YXJ0cyB3aXRoIHJlZ3VsYXIgc2VsZWN0b3JcbiAgICBjb25zdCByZWxhdGl2ZVJlZ3VsYXJTZWxlY3RvciA9IGdldEZpcnN0SW5uZXJSZWd1bGFyQ2hpbGQoc2VsZWN0b3JOb2RlLCBwc2V1ZG9OYW1lKTtcbiAgICAvKipcbiAgICAgKiBGb3IgY2hlY2tpbmcgdGhlIGVsZW1lbnQgYnkgJ2Rpdjpub3QoW2RhdGE9XCJjb250ZW50XCJdKVxuICAgICAqIHdlIGNoZWNrIHdoZXRoZXIgdGhlIGVsZW1lbnQncyBwYXJlbnRFbGVtZW50IGhhcyBhbnkgc3BlY2lmaWMgZGlyZWN0IGNoaWxkLlxuICAgICAqL1xuXG4gICAgY29uc3Qgcm9vdEVsZW1lbnQgPSBnZXRQYXJlbnQoZWxlbWVudCwgYFNlbGVjdGlvbiBieSA6JHtwc2V1ZG9OYW1lfSgpIHBzZXVkby1jbGFzcyBpcyBub3QgcG9zc2libGVgKTtcbiAgICAvKipcbiAgICAgKiBTbyB3ZSBjYWxjdWxhdGUgdGhlIGVsZW1lbnQgXCJkZXNjcmlwdGlvblwiIGJ5IGl0J3MgdGFnbmFtZSBhbmQgYXR0cmlidXRlcyBmb3IgdGFyZ2V0aW5nXG4gICAgICogYW5kIHVzZSBpdCB0byBzcGVjaWZ5IHRoZSBzZWxlY3Rpb25cbiAgICAgKiBlLmcuIGBkaXY6bm90KC5iYW5uZXIpYCAtLT4gYGRpdk5vZGUucGFyZW50RWxlbWVudC5xdWVyeVNlbGVjdG9yQWxsKCc6c2NvcGUgPiAuYmFubmVyJylgLlxuICAgICAqL1xuXG4gICAgY29uc3Qgc3BlY2lmaWVkU2VsZWN0b3IgPSBgJHtzY29wZURpcmVjdENoaWxkcmVufSR7Z2V0Tm9kZVZhbHVlKHJlbGF0aXZlUmVndWxhclNlbGVjdG9yKX1gO1xuICAgIGxldCBhbnlFbGVtZW50cztcblxuICAgIHRyeSB7XG4gICAgICAvLyBlc2xpbnQtZGlzYWJsZS1uZXh0LWxpbmUgQHR5cGVzY3JpcHQtZXNsaW50L25vLXVzZS1iZWZvcmUtZGVmaW5lXG4gICAgICBhbnlFbGVtZW50cyA9IGdldEVsZW1lbnRzRm9yU2VsZWN0b3JOb2RlKHNlbGVjdG9yTm9kZSwgcm9vdEVsZW1lbnQsIHNwZWNpZmllZFNlbGVjdG9yKTtcbiAgICB9IGNhdGNoIChlKSB7XG4gICAgICAvLyBmYWlsIG9uIGludmFsaWQgc2VsZWN0b3JzIGZvciA6bm90KClcbiAgICAgIGxvZ2dlci5lcnJvcihnZXRFcnJvck1lc3NhZ2UoZSkpOyAvLyBlc2xpbnQtZGlzYWJsZS1uZXh0LWxpbmUgbWF4LWxlblxuXG4gICAgICB0aHJvdyBuZXcgRXJyb3IoYEludmFsaWQgc2VsZWN0b3IgZm9yIDoke3BzZXVkb05hbWV9KCkgcHNldWRvLWNsYXNzOiAnJHtnZXROb2RlVmFsdWUocmVsYXRpdmVSZWd1bGFyU2VsZWN0b3IpfSdgKTtcbiAgICB9IC8vIFRPRE86IGZpZ3VyZSBvdXQgaG93IHRvIGhhbmRsZSB1cC1sb29raW5nIHBzZXVkby1jbGFzc2VzIGluc2lkZSA6bm90KClcbiAgICAvLyAoY2hlY2sgcmVhZG1lIC0gZXh0ZW5kZWQtY3NzLW5vdC1saW1pdGF0aW9ucylcbiAgICAvLyBiZWNhdXNlIGBlbGVtZW50YCBhbmQgYGFueUVsZW1lbnRzYCBtYXkgYmUgZnJvbSBkaWZmZXJlbnQgRE9NIGxldmVsc1xuXG5cbiAgICByZXR1cm4gIWFueUVsZW1lbnRzLmluY2x1ZGVzKGVsZW1lbnQpO1xuICB9KTtcbn07XG4vKipcbiAqIFNlbGVjdHMgZG9tIGVsZW1lbnRzIGJ5IHZhbHVlIG9mIFJlZ3VsYXJTZWxlY3Rvci5cbiAqXG4gKiBAcGFyYW0gcmVndWxhclNlbGVjdG9yTm9kZSBSZWd1bGFyU2VsZWN0b3Igbm9kZS5cbiAqIEBwYXJhbSByb290IFJvb3QgRE9NIGVsZW1lbnQuXG4gKiBAcGFyYW0gc3BlY2lmaWVkU2VsZWN0b3IgQHNlZSB7QGxpbmsgU3BlY2lmaWVkU2VsZWN0b3J9LlxuICpcbiAqIEByZXR1cm5zIEFycmF5IG9mIERPTSBlbGVtZW50cy5cbiAqIEB0aHJvd3MgQW4gZXJyb3IgaWYgUmVndWxhclNlbGVjdG9yIG5vZGUgdmFsdWUgaXMgYW4gaW52YWxpZCBzZWxlY3Rvci5cbiAqL1xuXG5cbmNvbnN0IGdldEJ5UmVndWxhclNlbGVjdG9yID0gKHJlZ3VsYXJTZWxlY3Rvck5vZGUsIHJvb3QsIHNwZWNpZmllZFNlbGVjdG9yKSA9PiB7XG4gIGNvbnN0IHNlbGVjdG9yVGV4dCA9IHNwZWNpZmllZFNlbGVjdG9yID8gc3BlY2lmaWVkU2VsZWN0b3IgOiBnZXROb2RlVmFsdWUocmVndWxhclNlbGVjdG9yTm9kZSk7XG4gIGxldCBzZWxlY3RlZEVsZW1lbnRzID0gW107XG5cbiAgdHJ5IHtcbiAgICBzZWxlY3RlZEVsZW1lbnRzID0gQXJyYXkuZnJvbShyb290LnF1ZXJ5U2VsZWN0b3JBbGwoc2VsZWN0b3JUZXh0KSk7XG4gIH0gY2F0Y2ggKGUpIHtcbiAgICB0aHJvdyBuZXcgRXJyb3IoYEVycm9yOiB1bmFibGUgdG8gc2VsZWN0IGJ5ICcke3NlbGVjdG9yVGV4dH0nIOKAlCAke2dldEVycm9yTWVzc2FnZShlKX1gKTtcbiAgfVxuXG4gIHJldHVybiBzZWxlY3RlZEVsZW1lbnRzO1xufTtcbi8qKlxuICogUmV0dXJucyBsaXN0IG9mIGRvbSBlbGVtZW50cyBmaWx0ZXJlZCBvciBzZWxlY3RlZCBieSBFeHRlbmRlZFNlbGVjdG9yIG5vZGUuXG4gKlxuICogQHBhcmFtIGRvbUVsZW1lbnRzIEFycmF5IG9mIERPTSBlbGVtZW50cy5cbiAqIEBwYXJhbSBleHRlbmRlZFNlbGVjdG9yTm9kZSBFeHRlbmRlZFNlbGVjdG9yIG5vZGUuXG4gKlxuICogQHJldHVybnMgQXJyYXkgb2YgRE9NIGVsZW1lbnRzLlxuICogQHRocm93cyBBbiBlcnJvciBvbiB1bmtub3duIHBzZXVkby1jbGFzcyxcbiAqIGFic2VudCBvciBpbnZhbGlkIGFyZyBvZiBleHRlbmRlZCBwc2V1ZG8tY2xhc3MsIGV0Yy5cbiAqL1xuXG5jb25zdCBnZXRCeUV4dGVuZGVkU2VsZWN0b3IgPSAoZG9tRWxlbWVudHMsIGV4dGVuZGVkU2VsZWN0b3JOb2RlKSA9PiB7XG4gIGxldCBmb3VuZEVsZW1lbnRzID0gW107XG4gIGNvbnN0IGV4dGVuZGVkUHNldWRvQ2xhc3NOb2RlID0gZ2V0UHNldWRvQ2xhc3NOb2RlKGV4dGVuZGVkU2VsZWN0b3JOb2RlKTtcbiAgY29uc3QgcHNldWRvTmFtZSA9IGdldE5vZGVOYW1lKGV4dGVuZGVkUHNldWRvQ2xhc3NOb2RlKTtcblxuICBpZiAoaXNBYnNvbHV0ZVBzZXVkb0NsYXNzKHBzZXVkb05hbWUpKSB7XG4gICAgLy8gYWJzb2x1dGUgZXh0ZW5kZWQgcHNldWRvLWNsYXNzZXMgc2hvdWxkIGhhdmUgYW4gYXJndW1lbnRcbiAgICBjb25zdCBhYnNvbHV0ZVBzZXVkb0FyZyA9IGdldE5vZGVWYWx1ZShleHRlbmRlZFBzZXVkb0NsYXNzTm9kZSwgYE1pc3NpbmcgYXJnIGZvciA6JHtwc2V1ZG9OYW1lfSgpIHBzZXVkby1jbGFzc2ApO1xuXG4gICAgaWYgKHBzZXVkb05hbWUgPT09IE5USF9BTkNFU1RPUl9QU0VVRE9fQ0xBU1NfTUFSS0VSKSB7XG4gICAgICAvLyA6bnRoLWFuY2VzdG9yKClcbiAgICAgIGZvdW5kRWxlbWVudHMgPSBmaW5kQnlBYnNvbHV0ZVBzZXVkb1BzZXVkby5udGhBbmNlc3Rvcihkb21FbGVtZW50cywgYWJzb2x1dGVQc2V1ZG9BcmcsIHBzZXVkb05hbWUpO1xuICAgIH0gZWxzZSBpZiAocHNldWRvTmFtZSA9PT0gWFBBVEhfUFNFVURPX0NMQVNTX01BUktFUikge1xuICAgICAgLy8gOnhwYXRoKClcbiAgICAgIHRyeSB7XG4gICAgICAgIGRvY3VtZW50LmNyZWF0ZUV4cHJlc3Npb24oYWJzb2x1dGVQc2V1ZG9BcmcsIG51bGwpO1xuICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoYEludmFsaWQgYXJndW1lbnQgb2YgOiR7cHNldWRvTmFtZX0oKSBwc2V1ZG8tY2xhc3M6ICcke2Fic29sdXRlUHNldWRvQXJnfSdgKTtcbiAgICAgIH1cblxuICAgICAgZm91bmRFbGVtZW50cyA9IGZpbmRCeUFic29sdXRlUHNldWRvUHNldWRvLnhwYXRoKGRvbUVsZW1lbnRzLCBhYnNvbHV0ZVBzZXVkb0FyZyk7XG4gICAgfSBlbHNlIGlmIChwc2V1ZG9OYW1lID09PSBVUFdBUkRfUFNFVURPX0NMQVNTX01BUktFUikge1xuICAgICAgLy8gOnVwd2FyZCgpXG4gICAgICBpZiAoTnVtYmVyLmlzTmFOKE51bWJlcihhYnNvbHV0ZVBzZXVkb0FyZykpKSB7XG4gICAgICAgIC8vIHNvIGFyZyBpcyBzZWxlY3Rvciwgbm90IGEgbnVtYmVyXG4gICAgICAgIGZvdW5kRWxlbWVudHMgPSBmaW5kQnlBYnNvbHV0ZVBzZXVkb1BzZXVkby51cHdhcmQoZG9tRWxlbWVudHMsIGFic29sdXRlUHNldWRvQXJnKTtcbiAgICAgIH0gZWxzZSB7XG4gICAgICAgIGZvdW5kRWxlbWVudHMgPSBmaW5kQnlBYnNvbHV0ZVBzZXVkb1BzZXVkby5udGhBbmNlc3Rvcihkb21FbGVtZW50cywgYWJzb2x1dGVQc2V1ZG9BcmcsIHBzZXVkb05hbWUpO1xuICAgICAgfVxuICAgIH0gZWxzZSB7XG4gICAgICAvLyBhbGwgb3RoZXIgYWJzb2x1dGUgZXh0ZW5kZWQgcHNldWRvLWNsYXNzZXNcbiAgICAgIC8vIGUuZy4gY29udGFpbnMsIG1hdGNoZXMtYXR0ciwgZXRjLlxuICAgICAgZm91bmRFbGVtZW50cyA9IGRvbUVsZW1lbnRzLmZpbHRlcihlbGVtZW50ID0+IHtcbiAgICAgICAgcmV0dXJuIGlzTWF0Y2hlZEJ5QWJzb2x1dGVQc2V1ZG8oZWxlbWVudCwgcHNldWRvTmFtZSwgYWJzb2x1dGVQc2V1ZG9BcmcpO1xuICAgICAgfSk7XG4gICAgfVxuICB9IGVsc2UgaWYgKGlzUmVsYXRpdmVQc2V1ZG9DbGFzcyhwc2V1ZG9OYW1lKSkge1xuICAgIGNvbnN0IHJlbGF0aXZlU2VsZWN0b3JMaXN0ID0gZ2V0UmVsYXRpdmVTZWxlY3Rvckxpc3ROb2RlKGV4dGVuZGVkUHNldWRvQ2xhc3NOb2RlKTtcbiAgICBsZXQgcmVsYXRpdmVQcmVkaWNhdGU7XG5cbiAgICBzd2l0Y2ggKHBzZXVkb05hbWUpIHtcbiAgICAgIGNhc2UgSEFTX1BTRVVET19DTEFTU19NQVJLRVI6XG4gICAgICBjYXNlIEFCUF9IQVNfUFNFVURPX0NMQVNTX01BUktFUjpcbiAgICAgICAgcmVsYXRpdmVQcmVkaWNhdGUgPSBlbGVtZW50ID0+IGhhc1JlbGF0aXZlc0J5U2VsZWN0b3JMaXN0KHtcbiAgICAgICAgICBlbGVtZW50LFxuICAgICAgICAgIHJlbGF0aXZlU2VsZWN0b3JMaXN0LFxuICAgICAgICAgIHBzZXVkb05hbWVcbiAgICAgICAgfSk7XG5cbiAgICAgICAgYnJlYWs7XG5cbiAgICAgIGNhc2UgSVNfUFNFVURPX0NMQVNTX01BUktFUjpcbiAgICAgICAgcmVsYXRpdmVQcmVkaWNhdGUgPSBlbGVtZW50ID0+IGlzQW55RWxlbWVudEJ5U2VsZWN0b3JMaXN0KHtcbiAgICAgICAgICBlbGVtZW50LFxuICAgICAgICAgIHJlbGF0aXZlU2VsZWN0b3JMaXN0LFxuICAgICAgICAgIHBzZXVkb05hbWVcbiAgICAgICAgfSk7XG5cbiAgICAgICAgYnJlYWs7XG5cbiAgICAgIGNhc2UgTk9UX1BTRVVET19DTEFTU19NQVJLRVI6XG4gICAgICAgIHJlbGF0aXZlUHJlZGljYXRlID0gZWxlbWVudCA9PiBub3RFbGVtZW50QnlTZWxlY3Rvckxpc3Qoe1xuICAgICAgICAgIGVsZW1lbnQsXG4gICAgICAgICAgcmVsYXRpdmVTZWxlY3Rvckxpc3QsXG4gICAgICAgICAgcHNldWRvTmFtZVxuICAgICAgICB9KTtcblxuICAgICAgICBicmVhaztcblxuICAgICAgZGVmYXVsdDpcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKGBVbmtub3duIHJlbGF0aXZlIHBzZXVkby1jbGFzczogJyR7cHNldWRvTmFtZX0nYCk7XG4gICAgfVxuXG4gICAgZm91bmRFbGVtZW50cyA9IGRvbUVsZW1lbnRzLmZpbHRlcihyZWxhdGl2ZVByZWRpY2F0ZSk7XG4gIH0gZWxzZSB7XG4gICAgLy8gZXh0cmEgY2hlY2sgaXMgcGFyc2VyIG1pc3NlZCBzb21ldGhpbmdcbiAgICB0aHJvdyBuZXcgRXJyb3IoYFVua25vd24gZXh0ZW5kZWQgcHNldWRvLWNsYXNzOiAnJHtwc2V1ZG9OYW1lfSdgKTtcbiAgfVxuXG4gIHJldHVybiBmb3VuZEVsZW1lbnRzO1xufTtcbi8qKlxuICogUmV0dXJucyBsaXN0IG9mIGRvbSBlbGVtZW50cyB3aGljaCBpcyBzZWxlY3RlZCBieSBSZWd1bGFyU2VsZWN0b3IgdmFsdWUuXG4gKlxuICogQHBhcmFtIGRvbUVsZW1lbnRzIEFycmF5IG9mIERPTSBlbGVtZW50cy5cbiAqIEBwYXJhbSByZWd1bGFyU2VsZWN0b3JOb2RlIFJlZ3VsYXJTZWxlY3RvciBub2RlLlxuICpcbiAqIEByZXR1cm5zIEFycmF5IG9mIERPTSBlbGVtZW50cy5cbiAqIEB0aHJvd3MgQW4gZXJyb3IgaWYgUmVndWxhclNlbGVjdG9yIGhhcyBub3QgdmFsdWUuXG4gKi9cblxuY29uc3QgZ2V0QnlGb2xsb3dpbmdSZWd1bGFyU2VsZWN0b3IgPSAoZG9tRWxlbWVudHMsIHJlZ3VsYXJTZWxlY3Rvck5vZGUpID0+IHtcbiAgLy8gYXJyYXkgb2YgYXJyYXlzIGJlY2F1c2Ugb2YgQXJyYXkubWFwKCkgbGF0ZXJcbiAgbGV0IGZvdW5kRWxlbWVudHMgPSBbXTtcbiAgY29uc3QgdmFsdWUgPSBnZXROb2RlVmFsdWUocmVndWxhclNlbGVjdG9yTm9kZSk7XG5cbiAgaWYgKHZhbHVlLnN0YXJ0c1dpdGgoQ0hJTERfQ09NQklOQVRPUikpIHtcbiAgICAvLyBlLmcuIGRpdjpoYXMoPiBpbWcpID4gLmJhbm5lclxuICAgIGZvdW5kRWxlbWVudHMgPSBkb21FbGVtZW50cy5tYXAocm9vdCA9PiB7XG4gICAgICBjb25zdCBzcGVjaWZpZWRTZWxlY3RvciA9IGAke1NDT1BFX0NTU19QU0VVRE9fQ0xBU1N9JHt2YWx1ZX1gO1xuICAgICAgcmV0dXJuIGdldEJ5UmVndWxhclNlbGVjdG9yKHJlZ3VsYXJTZWxlY3Rvck5vZGUsIHJvb3QsIHNwZWNpZmllZFNlbGVjdG9yKTtcbiAgICB9KTtcbiAgfSBlbHNlIGlmICh2YWx1ZS5zdGFydHNXaXRoKE5FWFRfU0lCTElOR19DT01CSU5BVE9SKSB8fCB2YWx1ZS5zdGFydHNXaXRoKFNVQlNFUVVFTlRfU0lCTElOR19DT01CSU5BVE9SKSkge1xuICAgIC8vIGUuZy4gZGl2Omhhcyg+IGltZykgKyAuYmFubmVyXG4gICAgLy8gb3IgICBkaXY6aGFzKD4gaW1nKSB+IC5iYW5uZXJcbiAgICBmb3VuZEVsZW1lbnRzID0gZG9tRWxlbWVudHMubWFwKGVsZW1lbnQgPT4ge1xuICAgICAgY29uc3Qgcm9vdEVsZW1lbnQgPSBlbGVtZW50LnBhcmVudEVsZW1lbnQ7XG5cbiAgICAgIGlmICghcm9vdEVsZW1lbnQpIHtcbiAgICAgICAgLy8gZG8gbm90IHRocm93IGVycm9yIGlmIHRoZXJlIGluIG5vIHBhcmVudCBmb3IgZWxlbWVudFxuICAgICAgICAvLyBlLmcuICcqOmNvbnRhaW5zKHRleHQpJyBzZWxlY3RzIGBodG1sYCB3aGljaCBoYXMgbm8gcGFyZW50RWxlbWVudFxuICAgICAgICByZXR1cm4gW107XG4gICAgICB9XG5cbiAgICAgIGNvbnN0IGVsZW1lbnRTZWxlY3RvclRleHQgPSBnZXRFbGVtZW50U2VsZWN0b3JEZXNjKGVsZW1lbnQpO1xuICAgICAgY29uc3Qgc3BlY2lmaWVkU2VsZWN0b3IgPSBgJHtzY29wZURpcmVjdENoaWxkcmVufSR7ZWxlbWVudFNlbGVjdG9yVGV4dH0ke3ZhbHVlfWA7XG4gICAgICBjb25zdCBzZWxlY3RlZCA9IGdldEJ5UmVndWxhclNlbGVjdG9yKHJlZ3VsYXJTZWxlY3Rvck5vZGUsIHJvb3RFbGVtZW50LCBzcGVjaWZpZWRTZWxlY3Rvcik7XG4gICAgICByZXR1cm4gc2VsZWN0ZWQ7XG4gICAgfSk7XG4gIH0gZWxzZSB7XG4gICAgLy8gc3BhY2Utc2VwYXJhdGVkIHJlZ3VsYXIgc2VsZWN0b3IgYWZ0ZXIgZXh0ZW5kZWQgb25lXG4gICAgLy8gZS5nLiBkaXY6aGFzKD4gaW1nKSAuYmFubmVyXG4gICAgZm91bmRFbGVtZW50cyA9IGRvbUVsZW1lbnRzLm1hcChyb290ID0+IHtcbiAgICAgIGNvbnN0IHNwZWNpZmllZFNlbGVjdG9yID0gYCR7c2NvcGVBbnlDaGlsZHJlbn0ke2dldE5vZGVWYWx1ZShyZWd1bGFyU2VsZWN0b3JOb2RlKX1gO1xuICAgICAgcmV0dXJuIGdldEJ5UmVndWxhclNlbGVjdG9yKHJlZ3VsYXJTZWxlY3Rvck5vZGUsIHJvb3QsIHNwZWNpZmllZFNlbGVjdG9yKTtcbiAgICB9KTtcbiAgfSAvLyBmb3VuZEVsZW1lbnRzIHNob3VsZCBiZSBmbGF0dGVuZWRcbiAgLy8gYXMgZ2V0QnlSZWd1bGFyU2VsZWN0b3IoKSByZXR1cm5zIGVsZW1lbnRzIGFycmF5LCBhbmQgQXJyYXkubWFwKCkgY29sbGVjdHMgdGhlbSB0byBhcnJheVxuXG5cbiAgcmV0dXJuIGZsYXR0ZW4oZm91bmRFbGVtZW50cyk7XG59O1xuLyoqXG4gKiBSZXR1cm5zIGVsZW1lbnRzIG5vZGVzIGZvciBTZWxlY3RvciBub2RlLlxuICogQXMgZmFyIGFzIGFueSBzZWxlY3RvciBhbHdheXMgc3RhcnRzIHdpdGggcmVndWxhciBwYXJ0LFxuICogaXQgc2VsZWN0cyBieSBSZWd1bGFyU2VsZWN0b3IgZmlyc3QgYW5kIGNoZWNrcyBmb3VuZCBlbGVtZW50cyBsYXRlci5cbiAqXG4gKiBSZWxhdGl2ZSBwc2V1ZG8tY2xhc3NlcyBoYXMgaXQncyBvd24gc3VidHJlZSBzbyBnZXRFbGVtZW50c0ZvclNlbGVjdG9yTm9kZSBpcyBjYWxsZWQgcmVjdXJzaXZlbHkuXG4gKlxuICogJ3NwZWNpZmllZFNlbGVjdG9yJyBpcyBuZWVkZWQgZm9yIDpoYXMoKSwgOmlzKCksIGFuZCA6bm90KCkgcHNldWRvLWNsYXNzZXNcbiAqIGFzIG5hdGl2ZSBxdWVyeVNlbGVjdG9yQWxsKCkgZG9lcyBub3Qgc2VsZWN0IGV4YWN0IGVsZW1lbnQgZGVzY2VuZGFudHMgZXZlbiBpZiBpdCBpcyBjYWxsZWQgb24gJ2RpdidcbiAqIGUuZy4gJzpzY29wZScgc3BlY2lmaWNhdGlvbiBpcyBuZWVkZWQgZm9yIHByb3BlciBkZXNjZW5kYW50cyBzZWxlY3Rpb24gZm9yICdkaXY6aGFzKD4gaW1nKScuXG4gKiBTbyB3ZSBjaGVjayBgZGl2Tm9kZS5xdWVyeVNlbGVjdG9yQWxsKCc6c2NvcGUgPiBpbWcnKS5sZW5ndGggPiAwYC5cbiAqXG4gKiBAcGFyYW0gc2VsZWN0b3JOb2RlIFNlbGVjdG9yIG5vZGUuXG4gKiBAcGFyYW0gcm9vdCBSb290IERPTSBlbGVtZW50LlxuICogQHBhcmFtIHNwZWNpZmllZFNlbGVjdG9yIE5lZWRlZCBlbGVtZW50IHNwZWNpZmljYXRpb24uXG4gKlxuICogQHJldHVybnMgQXJyYXkgb2YgRE9NIGVsZW1lbnRzLlxuICogQHRocm93cyBBbiBlcnJvciBpZiB0aGVyZSBpcyBubyBzZWxlY3Rvck5vZGVDaGlsZC5cbiAqL1xuXG5jb25zdCBnZXRFbGVtZW50c0ZvclNlbGVjdG9yTm9kZSA9IChzZWxlY3Rvck5vZGUsIHJvb3QsIHNwZWNpZmllZFNlbGVjdG9yKSA9PiB7XG4gIGxldCBzZWxlY3RlZEVsZW1lbnRzID0gW107XG4gIGxldCBpID0gMDtcblxuICB3aGlsZSAoaSA8IHNlbGVjdG9yTm9kZS5jaGlsZHJlbi5sZW5ndGgpIHtcbiAgICBjb25zdCBzZWxlY3Rvck5vZGVDaGlsZCA9IGdldEl0ZW1CeUluZGV4KHNlbGVjdG9yTm9kZS5jaGlsZHJlbiwgaSwgJ3NlbGVjdG9yTm9kZUNoaWxkIHNob3VsZCBiZSBzcGVjaWZpZWQnKTtcblxuICAgIGlmIChpID09PSAwKSB7XG4gICAgICAvLyBhbnkgc2VsZWN0b3IgYWx3YXlzIHN0YXJ0cyB3aXRoIHJlZ3VsYXIgc2VsZWN0b3JcbiAgICAgIHNlbGVjdGVkRWxlbWVudHMgPSBnZXRCeVJlZ3VsYXJTZWxlY3RvcihzZWxlY3Rvck5vZGVDaGlsZCwgcm9vdCwgc3BlY2lmaWVkU2VsZWN0b3IpO1xuICAgIH0gZWxzZSBpZiAoaXNFeHRlbmRlZFNlbGVjdG9yTm9kZShzZWxlY3Rvck5vZGVDaGlsZCkpIHtcbiAgICAgIC8vIGZpbHRlciBwcmV2aW91c2x5IHNlbGVjdGVkIGVsZW1lbnRzIGJ5IG5leHQgc2VsZWN0b3Igbm9kZXNcbiAgICAgIHNlbGVjdGVkRWxlbWVudHMgPSBnZXRCeUV4dGVuZGVkU2VsZWN0b3Ioc2VsZWN0ZWRFbGVtZW50cywgc2VsZWN0b3JOb2RlQ2hpbGQpO1xuICAgIH0gZWxzZSBpZiAoaXNSZWd1bGFyU2VsZWN0b3JOb2RlKHNlbGVjdG9yTm9kZUNoaWxkKSkge1xuICAgICAgc2VsZWN0ZWRFbGVtZW50cyA9IGdldEJ5Rm9sbG93aW5nUmVndWxhclNlbGVjdG9yKHNlbGVjdGVkRWxlbWVudHMsIHNlbGVjdG9yTm9kZUNoaWxkKTtcbiAgICB9XG5cbiAgICBpICs9IDE7XG4gIH1cblxuICByZXR1cm4gc2VsZWN0ZWRFbGVtZW50cztcbn07XG5cbi8qKlxuICogU2VsZWN0cyBlbGVtZW50cyBieSBhc3QuXG4gKlxuICogQHBhcmFtIGFzdCBBc3Qgb2YgcGFyc2VkIHNlbGVjdG9yLlxuICogQHBhcmFtIGRvYyBEb2N1bWVudC5cbiAqXG4gKiBAcmV0dXJucyBBcnJheSBvZiBET00gZWxlbWVudHMuXG4gKi9cblxuY29uc3Qgc2VsZWN0RWxlbWVudHNCeUFzdCA9IGZ1bmN0aW9uIChhc3QpIHtcbiAgbGV0IGRvYyA9IGFyZ3VtZW50cy5sZW5ndGggPiAxICYmIGFyZ3VtZW50c1sxXSAhPT0gdW5kZWZpbmVkID8gYXJndW1lbnRzWzFdIDogZG9jdW1lbnQ7XG4gIGNvbnN0IHNlbGVjdGVkRWxlbWVudHMgPSBbXTsgLy8gYXN0IHJvb3QgaXMgU2VsZWN0b3JMaXN0IG5vZGU7XG4gIC8vIGl0IGhhcyBTZWxlY3RvciBub2RlcyBhcyBjaGlsZHJlbiB3aGljaCBzaG91bGQgYmUgcHJvY2Vzc2VkIHNlcGFyYXRlbHlcblxuICBhc3QuY2hpbGRyZW4uZm9yRWFjaChzZWxlY3Rvck5vZGUgPT4ge1xuICAgIHNlbGVjdGVkRWxlbWVudHMucHVzaCguLi5nZXRFbGVtZW50c0ZvclNlbGVjdG9yTm9kZShzZWxlY3Rvck5vZGUsIGRvYykpO1xuICB9KTsgLy8gc2VsZWN0ZWRFbGVtZW50cyBzaG91bGQgYmUgZmxhdHRlbmVkIGFzIGl0IGlzIGFycmF5IG9mIGFycmF5cyB3aXRoIGVsZW1lbnRzXG5cbiAgY29uc3QgdW5pcXVlRWxlbWVudHMgPSBbLi4ubmV3IFNldChmbGF0dGVuKHNlbGVjdGVkRWxlbWVudHMpKV07XG4gIHJldHVybiB1bmlxdWVFbGVtZW50cztcbn07XG4vKipcbiAqIENsYXNzIG9mIEV4dENzc0RvY3VtZW50IGlzIG5lZWRlZCBmb3IgY2FjaGluZy5cbiAqIEZvciBtYWtpbmcgY2FjaGUgcmVsYXRlZCB0byBlYWNoIG5ldyBpbnN0YW5jZSBvZiBjbGFzcywgbm90IGdsb2JhbC5cbiAqL1xuXG5jbGFzcyBFeHRDc3NEb2N1bWVudCB7XG4gIC8qKlxuICAgKiBDYWNoZSB3aXRoIHNlbGVjdG9ycyBhbmQgdGhlaXIgQVNUIHBhcnNpbmcgcmVzdWx0cy5cbiAgICovXG5cbiAgLyoqXG4gICAqIENyZWF0ZXMgbmV3IEV4dENzc0RvY3VtZW50IGFuZCBpbml0cyBuZXcgYGFzdENhY2hlYC5cbiAgICovXG4gIGNvbnN0cnVjdG9yKCkge1xuICAgIHRoaXMuYXN0Q2FjaGUgPSBuZXcgTWFwKCk7XG4gIH1cbiAgLyoqXG4gICAqIFNhdmVzIHNlbGVjdG9yIGFuZCBpdCdzIGFzdCB0byBjYWNoZS5cbiAgICpcbiAgICogQHBhcmFtIHNlbGVjdG9yIFN0YW5kYXJkIG9yIGV4dGVuZGVkIHNlbGVjdG9yLlxuICAgKiBAcGFyYW0gYXN0IFNlbGVjdG9yIGFzdC5cbiAgICovXG5cblxuICBzYXZlQXN0VG9DYWNoZShzZWxlY3RvciwgYXN0KSB7XG4gICAgdGhpcy5hc3RDYWNoZS5zZXQoc2VsZWN0b3IsIGFzdCk7XG4gIH1cbiAgLyoqXG4gICAqIFJldHVybnMgYXN0IGZyb20gY2FjaGUgZm9yIGdpdmVuIHNlbGVjdG9yLlxuICAgKlxuICAgKiBAcGFyYW0gc2VsZWN0b3IgU3RhbmRhcmQgb3IgZXh0ZW5kZWQgc2VsZWN0b3IuXG4gICAqXG4gICAqIEByZXR1cm5zIFByZXZpb3VzbHkgcGFyc2VkIGFzdCBmb3VuZCBpbiBjYWNoZSwgb3IgbnVsbCBpZiBub3QgZm91bmQuXG4gICAqL1xuXG5cbiAgZ2V0QXN0RnJvbUNhY2hlKHNlbGVjdG9yKSB7XG4gICAgY29uc3QgY2FjaGVkQXN0ID0gdGhpcy5hc3RDYWNoZS5nZXQoc2VsZWN0b3IpIHx8IG51bGw7XG4gICAgcmV0dXJuIGNhY2hlZEFzdDtcbiAgfVxuICAvKipcbiAgICogUmV0dXJucyBzZWxlY3RvciBhc3Q6XG4gICAqIC0gaWYgY2FjaGVkIGFzdCBleGlzdHMg4oCUIHJldHVybnMgaXQ7XG4gICAqIC0gaWYgbm8gY2FjaGVkIGFzdCDigJQgc2F2ZXMgbmV3bHkgcGFyc2VkIGFzdCB0byBjYWNoZSBhbmQgcmV0dXJucyBpdC5cbiAgICpcbiAgICogQHBhcmFtIHNlbGVjdG9yIFN0YW5kYXJkIG9yIGV4dGVuZGVkIHNlbGVjdG9yLlxuICAgKlxuICAgKiBAcmV0dXJucyBBc3QgZm9yIGBzZWxlY3RvcmAuXG4gICAqL1xuXG5cbiAgZ2V0U2VsZWN0b3JBc3Qoc2VsZWN0b3IpIHtcbiAgICBsZXQgYXN0ID0gdGhpcy5nZXRBc3RGcm9tQ2FjaGUoc2VsZWN0b3IpO1xuXG4gICAgaWYgKCFhc3QpIHtcbiAgICAgIGFzdCA9IHBhcnNlKHNlbGVjdG9yKTtcbiAgICB9XG5cbiAgICB0aGlzLnNhdmVBc3RUb0NhY2hlKHNlbGVjdG9yLCBhc3QpO1xuICAgIHJldHVybiBhc3Q7XG4gIH1cbiAgLyoqXG4gICAqIFNlbGVjdHMgZWxlbWVudHMgYnkgc2VsZWN0b3IuXG4gICAqXG4gICAqIEBwYXJhbSBzZWxlY3RvciBTdGFuZGFyZCBvciBleHRlbmRlZCBzZWxlY3Rvci5cbiAgICpcbiAgICogQHJldHVybnMgQXJyYXkgb2YgRE9NIGVsZW1lbnRzLlxuICAgKi9cblxuXG4gIHF1ZXJ5U2VsZWN0b3JBbGwoc2VsZWN0b3IpIHtcbiAgICBjb25zdCBhc3QgPSB0aGlzLmdldFNlbGVjdG9yQXN0KHNlbGVjdG9yKTtcbiAgICByZXR1cm4gc2VsZWN0RWxlbWVudHNCeUFzdChhc3QpO1xuICB9XG5cbn1cbmNvbnN0IGV4dENzc0RvY3VtZW50ID0gbmV3IEV4dENzc0RvY3VtZW50KCk7XG5cbi8qKlxuICogQ29udmVydHMgYXJyYXkgb2YgYGVudHJpZXNgIHRvIG9iamVjdC5cbiAqIE9iamVjdC5mcm9tRW50cmllcygpIHBvbHlmaWxsIGJlY2F1c2UgaXQgaXMgbm90IHN1cHBvcnRlZCBieSBvbGQgYnJvd3NlcnMsIGUuZy4gQ2hyb21lIDU1LlxuICogT25seSBmaXJzdCB0d28gZWxlbWVudHMgb2YgYGVudHJpZXNgIGFycmF5IG1hdHRlciwgb3RoZXIgd2lsbCBiZSBza2lwcGVkIHNpbGVudGx5LlxuICpcbiAqIEBzZWUge0BsaW5rIGh0dHBzOi8vY2FuaXVzZS5jb20vP3NlYXJjaD1PYmplY3QuZnJvbUVudHJpZXN9XG4gKlxuICogQHBhcmFtIGVudHJpZXMgQXJyYXkgb2YgcGFpcnMuXG4gKlxuICogQHJldHVybnMgT2JqZWN0IGNvbnZlcnRlZCBmcm9tIGBlbnRyaWVzYC5cbiAqL1xuY29uc3QgZ2V0T2JqZWN0RnJvbUVudHJpZXMgPSBlbnRyaWVzID0+IHtcbiAgY29uc3Qgb2JqZWN0ID0ge307XG4gIGVudHJpZXMuZm9yRWFjaChlbCA9PiB7XG4gICAgY29uc3QgW2tleSwgdmFsdWVdID0gZWw7XG4gICAgb2JqZWN0W2tleV0gPSB2YWx1ZTtcbiAgfSk7XG4gIHJldHVybiBvYmplY3Q7XG59O1xuXG5jb25zdCBERUJVR19QU0VVRE9fUFJPUEVSVFlfS0VZID0gJ2RlYnVnJztcbi8qKlxuICogQ2hlY2tzIHRoZSBwcmVzZW5jZSBvZiA6cmVtb3ZlKCkgcHNldWRvLWNsYXNzIGFuZCB2YWxpZGF0ZXMgaXQgd2hpbGUgcGFyc2luZyB0aGUgc2VsZWN0b3IgcGFydCBvZiBjc3MgcnVsZS5cbiAqXG4gKiBAcGFyYW0gcmF3U2VsZWN0b3IgU2VsZWN0b3Igd2hpY2ggbWF5IGNvbnRhaW4gOnJlbW92ZSgpIHBzZXVkby1jbGFzcy5cbiAqXG4gKiBAcmV0dXJucyBQYXJzZWQgc2VsZWN0b3IgZGF0YSB3aXRoIHNlbGVjdG9yIGFuZCBzdHlsZXMuXG4gKiBAdGhyb3dzIEFuIGVycm9yIG9uIGludmFsaWQgOnJlbW92ZSgpIHBvc2l0aW9uLlxuICovXG5cbmNvbnN0IHBhcnNlUmVtb3ZlU2VsZWN0b3IgPSByYXdTZWxlY3RvciA9PiB7XG4gIC8qKlxuICAgKiBObyBlcnJvciB3aWxsIGJlIHRocm93biBvbiBpbnZhbGlkIHNlbGVjdG9yIGFzIGl0IHdpbGwgYmUgdmFsaWRhdGVkIGxhdGVyXG4gICAqIHNvIGl0J3MgYmV0dGVyIHRvIGV4cGxpY2l0bHkgc3BlY2lmeSAnYW55JyBzZWxlY3RvciBmb3IgOnJlbW92ZSgpIHBzZXVkby1jbGFzcyBieSAnKicsXG4gICAqIGUuZy4gJy5iYW5uZXIgPiAqOnJlbW92ZSgpJyBpbnN0ZWFkIG9mICcuYmFubmVyID4gOnJlbW92ZSgpJy5cbiAgICovXG4gIC8vICc6cmVtb3ZlKCknXG4gIC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBtYXgtbGVuXG4gIGNvbnN0IFZBTElEX1JFTU9WRV9NQVJLRVIgPSBgJHtDT0xPTn0ke1JFTU9WRV9QU0VVRE9fTUFSS0VSfSR7QlJBQ0tFVC5QQVJFTlRIRVNFUy5MRUZUfSR7QlJBQ0tFVC5QQVJFTlRIRVNFUy5SSUdIVH1gOyAvLyAnOnJlbW92ZSgnIC0gbmVlZGVkIGZvciB2YWxpZGF0aW9uIHJ1bGVzIGxpa2UgJ2RpdjpyZW1vdmUoMiknXG5cbiAgY29uc3QgSU5WQUxJRF9SRU1PVkVfTUFSS0VSID0gYCR7Q09MT059JHtSRU1PVkVfUFNFVURPX01BUktFUn0ke0JSQUNLRVQuUEFSRU5USEVTRVMuTEVGVH1gO1xuICBsZXQgc2VsZWN0b3I7XG4gIGxldCBzaG91bGRSZW1vdmUgPSBmYWxzZTtcbiAgY29uc3QgZmlyc3RJbmRleCA9IHJhd1NlbGVjdG9yLmluZGV4T2YoVkFMSURfUkVNT1ZFX01BUktFUik7XG5cbiAgaWYgKGZpcnN0SW5kZXggPT09IDApIHtcbiAgICAvLyBlLmcuICc6cmVtb3ZlKCknXG4gICAgdGhyb3cgbmV3IEVycm9yKGAke1JFTU9WRV9FUlJPUl9QUkVGSVguTk9fVEFSR0VUX1NFTEVDVE9SfTogJyR7cmF3U2VsZWN0b3J9J2ApO1xuICB9IGVsc2UgaWYgKGZpcnN0SW5kZXggPiAwKSB7XG4gICAgaWYgKGZpcnN0SW5kZXggIT09IHJhd1NlbGVjdG9yLmxhc3RJbmRleE9mKFZBTElEX1JFTU9WRV9NQVJLRVIpKSB7XG4gICAgICAvLyBydWxlIHdpdGggbW9yZSB0aGFuIG9uZSA6cmVtb3ZlKCkgcHNldWRvLWNsYXNzIGlzIGludmFsaWRcbiAgICAgIC8vIGUuZy4gJy5ibG9jazpyZW1vdmUoKSA+IC5iYW5uZXI6cmVtb3ZlKCknXG4gICAgICB0aHJvdyBuZXcgRXJyb3IoYCR7UkVNT1ZFX0VSUk9SX1BSRUZJWC5NVUxUSVBMRV9VU0FHRX06ICcke3Jhd1NlbGVjdG9yfSdgKTtcbiAgICB9IGVsc2UgaWYgKGZpcnN0SW5kZXggKyBWQUxJRF9SRU1PVkVfTUFSS0VSLmxlbmd0aCA8IHJhd1NlbGVjdG9yLmxlbmd0aCkge1xuICAgICAgLy8gcmVtb3ZlIHBzZXVkby1jbGFzcyBzaG91bGQgYmUgbGFzdCBpbiB0aGUgcnVsZVxuICAgICAgLy8gZS5nLiAnLmJsb2NrOnJlbW92ZSgpOnVwd2FyZCgyKSdcbiAgICAgIHRocm93IG5ldyBFcnJvcihgJHtSRU1PVkVfRVJST1JfUFJFRklYLklOVkFMSURfUE9TSVRJT059OiAnJHtyYXdTZWxlY3Rvcn0nYCk7XG4gICAgfSBlbHNlIHtcbiAgICAgIC8vIHZhbGlkIDpyZW1vdmUoKSBwc2V1ZG8tY2xhc3MgcG9zaXRpb25cbiAgICAgIHNlbGVjdG9yID0gcmF3U2VsZWN0b3Iuc3Vic3RyaW5nKDAsIGZpcnN0SW5kZXgpO1xuICAgICAgc2hvdWxkUmVtb3ZlID0gdHJ1ZTtcbiAgICB9XG4gIH0gZWxzZSBpZiAocmF3U2VsZWN0b3IuaW5jbHVkZXMoSU5WQUxJRF9SRU1PVkVfTUFSS0VSKSkge1xuICAgIC8vIGl0IGlzIG5vdCB2YWxpZCBpZiAnOnJlbW92ZSgpJyBpcyBhYnNlbnQgaW4gcnVsZSBidXQganVzdCAnOnJlbW92ZSgnIGlzIHByZXNlbnRcbiAgICAvLyBlLmcuICdkaXY6cmVtb3ZlKDApJ1xuICAgIHRocm93IG5ldyBFcnJvcihgJHtSRU1PVkVfRVJST1JfUFJFRklYLklOVkFMSURfUkVNT1ZFfTogJyR7cmF3U2VsZWN0b3J9J2ApO1xuICB9IGVsc2Uge1xuICAgIC8vIHRoZXJlIGlzIG5vIDpyZW1vdmUoKSBwc2V1ZG8tY2xhc3MgaW4gcnVsZVxuICAgIHNlbGVjdG9yID0gcmF3U2VsZWN0b3I7XG4gIH1cblxuICBjb25zdCBzdHlsZXNPZlNlbGVjdG9yID0gc2hvdWxkUmVtb3ZlID8gW3tcbiAgICBwcm9wZXJ0eTogUkVNT1ZFX1BTRVVET19NQVJLRVIsXG4gICAgdmFsdWU6IFBTRVVET19QUk9QRVJUWV9QT1NJVElWRV9WQUxVRVxuICB9XSA6IFtdO1xuICByZXR1cm4ge1xuICAgIHNlbGVjdG9yLFxuICAgIHN0eWxlc09mU2VsZWN0b3JcbiAgfTtcbn07XG4vKipcbiAqIFBhcnNlcyBjcm9wcGVkIHNlbGVjdG9yIHBhcnQgZm91bmQgYmVmb3JlIGB7YC5cbiAqXG4gKiBAcGFyYW0gc2VsZWN0b3JCdWZmZXIgQnVmZmVyZWQgc2VsZWN0b3IgdG8gcGFyc2UuXG4gKiBAcGFyYW0gZXh0Q3NzRG9jIE5lZWRlZCBmb3IgY2FjaGluZyBvZiBzZWxlY3RvciBhc3QuXG4gKlxuICogQHJldHVybnMgUGFyc2VkIHZhbGlkYXRpb24gZGF0YSBmb3IgY3JvcHBlZCBwYXJ0IG9mIHN0eWxlc2hlZXQgd2hpY2ggbWF5IGJlIGEgc2VsZWN0b3IuXG4gKiBAdGhyb3dzIEFuIGVycm9yIG9uIHVuc3VwcG9ydGVkIENTUyBmZWF0dXJlcywgZS5nLiBhdC1ydWxlcy5cbiAqL1xuXG5jb25zdCBwYXJzZVNlbGVjdG9yUnVsZVBhcnQgPSAoc2VsZWN0b3JCdWZmZXIsIGV4dENzc0RvYykgPT4ge1xuICBsZXQgc2VsZWN0b3IgPSBzZWxlY3RvckJ1ZmZlci50cmltKCk7XG5cbiAgaWYgKHNlbGVjdG9yLnN0YXJ0c1dpdGgoQVRfUlVMRV9NQVJLRVIpKSB7XG4gICAgdGhyb3cgbmV3IEVycm9yKGAke05PX0FUX1JVTEVfRVJST1JfUFJFRklYfTogJyR7c2VsZWN0b3J9Jy5gKTtcbiAgfVxuXG4gIGxldCByZW1vdmVTZWxlY3RvckRhdGE7XG5cbiAgdHJ5IHtcbiAgICByZW1vdmVTZWxlY3RvckRhdGEgPSBwYXJzZVJlbW92ZVNlbGVjdG9yKHNlbGVjdG9yKTtcbiAgfSBjYXRjaCAoZSkge1xuICAgIGxvZ2dlci5lcnJvcihnZXRFcnJvck1lc3NhZ2UoZSkpO1xuICAgIHRocm93IG5ldyBFcnJvcihgJHtSRU1PVkVfRVJST1JfUFJFRklYLklOVkFMSURfUkVNT1ZFfTogJyR7c2VsZWN0b3J9J2ApO1xuICB9XG5cbiAgbGV0IHN0eWxlc09mU2VsZWN0b3IgPSBbXTtcbiAgbGV0IHN1Y2Nlc3MgPSBmYWxzZTtcbiAgbGV0IGFzdDtcblxuICB0cnkge1xuICAgIHNlbGVjdG9yID0gcmVtb3ZlU2VsZWN0b3JEYXRhLnNlbGVjdG9yO1xuICAgIHN0eWxlc09mU2VsZWN0b3IgPSByZW1vdmVTZWxlY3RvckRhdGEuc3R5bGVzT2ZTZWxlY3RvcjsgLy8gdmFsaWRhdGUgZm91bmQgc2VsZWN0b3IgYnkgcGFyc2luZyBpdCB0byBhc3RcbiAgICAvLyBzbyBpZiBpdCBpcyBpbnZhbGlkIGVycm9yIHdpbGwgYmUgdGhyb3duXG5cbiAgICBhc3QgPSBleHRDc3NEb2MuZ2V0U2VsZWN0b3JBc3Qoc2VsZWN0b3IpO1xuICAgIHN1Y2Nlc3MgPSB0cnVlO1xuICB9IGNhdGNoIChlKSB7XG4gICAgc3VjY2VzcyA9IGZhbHNlO1xuICB9XG5cbiAgcmV0dXJuIHtcbiAgICBzdWNjZXNzLFxuICAgIHNlbGVjdG9yLFxuICAgIGFzdCxcbiAgICBzdHlsZXNPZlNlbGVjdG9yXG4gIH07XG59O1xuLyoqXG4gKiBDcmVhdGVzIGEgbWFwIGZvciBzdG9yaW5nIHJhdyByZXN1bHRzIG9mIGNzcyBydWxlcyBwYXJzaW5nLlxuICogVXNlZCBmb3IgbWVyZ2luZyBzdHlsZXMgZm9yIHNhbWUgc2VsZWN0b3IuXG4gKlxuICogQHJldHVybnMgTWFwIHdoZXJlICoqa2V5KiogaXMgYHNlbGVjdG9yYFxuICogYW5kICoqdmFsdWUqKiBpcyBvYmplY3Qgd2l0aCBgYXN0YCBhbmQgYHN0eWxlc2AuXG4gKi9cblxuY29uc3QgY3JlYXRlUmF3UmVzdWx0c01hcCA9ICgpID0+IHtcbiAgcmV0dXJuIG5ldyBNYXAoKTtcbn07XG4vKipcbiAqIFNhdmVzIHJ1bGVzIGRhdGEgZm9yIHVuaXF1ZSBzZWxlY3RvcnMuXG4gKlxuICogQHBhcmFtIHJhd1Jlc3VsdHMgUHJldmlvdXNseSBjb2xsZWN0ZWQgcmVzdWx0cyBvZiBwYXJzaW5nLlxuICogQHBhcmFtIHJhd1J1bGVEYXRhIFBhcnNlZCBydWxlIGRhdGEuXG4gKlxuICogQHRocm93cyBBbiBlcnJvciBpZiB0aGVyZSBpcyBubyByYXdSdWxlRGF0YS5zdHlsZXMgb3IgcmF3UnVsZURhdGEuYXN0LlxuICovXG5cbmNvbnN0IHNhdmVUb1Jhd1Jlc3VsdHMgPSAocmF3UmVzdWx0cywgcmF3UnVsZURhdGEpID0+IHtcbiAgY29uc3Qge1xuICAgIHNlbGVjdG9yLFxuICAgIGFzdCxcbiAgICByYXdTdHlsZXNcbiAgfSA9IHJhd1J1bGVEYXRhO1xuXG4gIGlmICghcmF3U3R5bGVzKSB7XG4gICAgdGhyb3cgbmV3IEVycm9yKGBObyBzdHlsZSBkZWNsYXJhdGlvbiBmb3Igc2VsZWN0b3I6ICcke3NlbGVjdG9yfSdgKTtcbiAgfVxuXG4gIGlmICghYXN0KSB7XG4gICAgdGhyb3cgbmV3IEVycm9yKGBObyBhc3QgcGFyc2VkIGZvciBzZWxlY3RvcjogJyR7c2VsZWN0b3J9J2ApO1xuICB9XG5cbiAgY29uc3Qgc3RvcmVkUnVsZURhdGEgPSByYXdSZXN1bHRzLmdldChzZWxlY3Rvcik7XG5cbiAgaWYgKCFzdG9yZWRSdWxlRGF0YSkge1xuICAgIHJhd1Jlc3VsdHMuc2V0KHNlbGVjdG9yLCB7XG4gICAgICBhc3QsXG4gICAgICBzdHlsZXM6IHJhd1N0eWxlc1xuICAgIH0pO1xuICB9IGVsc2Uge1xuICAgIHN0b3JlZFJ1bGVEYXRhLnN0eWxlcy5wdXNoKC4uLnJhd1N0eWxlcyk7XG4gIH1cbn07XG4vKipcbiAqIENoZWNrcyB3aGV0aGVyIHRoZSAncmVtb3ZlJyBwcm9wZXJ0eSBwb3NpdGl2ZWx5IHNldCBpbiBzdHlsZXNcbiAqIHdpdGggb25seSBvbmUgcG9zaXRpdmUgdmFsdWUgLSAndHJ1ZScuXG4gKlxuICogQHBhcmFtIHN0eWxlcyBBcnJheSBvZiBzdHlsZXMuXG4gKlxuICogQHJldHVybnMgVHJ1ZSBpZiB0aGVyZSBpcyAncmVtb3ZlJyBwcm9wZXJ0eSB3aXRoICd0cnVlJyB2YWx1ZSBpbiBgc3R5bGVzYC5cbiAqL1xuXG5jb25zdCBpc1JlbW92ZVNldEluU3R5bGVzID0gc3R5bGVzID0+IHtcbiAgcmV0dXJuIHN0eWxlcy5zb21lKHMgPT4ge1xuICAgIHJldHVybiBzLnByb3BlcnR5ID09PSBSRU1PVkVfUFNFVURPX01BUktFUiAmJiBzLnZhbHVlID09PSBQU0VVRE9fUFJPUEVSVFlfUE9TSVRJVkVfVkFMVUU7XG4gIH0pO1xufTtcbi8qKlxuICogUmV0dXJucyAnZGVidWcnIHByb3BlcnR5IHZhbHVlIHdoaWNoIGlzIHNldCBpbiBzdHlsZXMuXG4gKlxuICogQHBhcmFtIHN0eWxlcyBBcnJheSBvZiBzdHlsZXMuXG4gKlxuICogQHJldHVybnMgVmFsdWUgb2YgJ2RlYnVnJyBwcm9wZXJ0eSBpZiBpdCBpcyBzZXQgaW4gYHN0eWxlc2AsXG4gKiBvciBgdW5kZWZpbmVkYCBpZiB0aGUgcHJvcGVydHkgaXMgbm90IGZvdW5kLlxuICovXG5cblxuY29uc3QgZ2V0RGVidWdTdHlsZVZhbHVlID0gc3R5bGVzID0+IHtcbiAgY29uc3QgZGVidWdTdHlsZSA9IHN0eWxlcy5maW5kKHMgPT4ge1xuICAgIHJldHVybiBzLnByb3BlcnR5ID09PSBERUJVR19QU0VVRE9fUFJPUEVSVFlfS0VZO1xuICB9KTtcbiAgcmV0dXJuIGRlYnVnU3R5bGUgPT09IG51bGwgfHwgZGVidWdTdHlsZSA9PT0gdm9pZCAwID8gdm9pZCAwIDogZGVidWdTdHlsZS52YWx1ZTtcbn07XG4vKipcbiAqIFByZXBhcmVzIGZpbmFsIFJ1bGVEYXRhLlxuICogSGFuZGxlcyBgZGVidWdgIGFuZCBgcmVtb3ZlYCBpbiByYXcgcnVsZSBkYXRhIHN0eWxlcy5cbiAqXG4gKiBAcGFyYW0gcmF3UnVsZURhdGEgUmF3IGRhdGEgb2Ygc2VsZWN0b3IgY3NzIHJ1bGUgcGFyc2luZy5cbiAqXG4gKiBAcmV0dXJucyBQYXJzZWQgRXh0ZW5kZWRDc3MgcnVsZSBkYXRhLlxuICogQHRocm93cyBBbiBlcnJvciBpZiByYXdSdWxlRGF0YS5hc3Qgb3IgcmF3UnVsZURhdGEucmF3U3R5bGVzIG5vdCBkZWZpbmVkLlxuICovXG5cblxuY29uc3QgcHJlcGFyZVJ1bGVEYXRhID0gcmF3UnVsZURhdGEgPT4ge1xuICBjb25zdCB7XG4gICAgc2VsZWN0b3IsXG4gICAgYXN0LFxuICAgIHJhd1N0eWxlc1xuICB9ID0gcmF3UnVsZURhdGE7XG5cbiAgaWYgKCFhc3QpIHtcbiAgICB0aHJvdyBuZXcgRXJyb3IoYEFTVCBzaG91bGQgYmUgcGFyc2VkIGZvciBzZWxlY3RvcjogJyR7c2VsZWN0b3J9J2ApO1xuICB9XG5cbiAgaWYgKCFyYXdTdHlsZXMpIHtcbiAgICB0aHJvdyBuZXcgRXJyb3IoYFN0eWxlcyBzaG91bGQgYmUgcGFyc2VkIGZvciBzZWxlY3RvcjogJyR7c2VsZWN0b3J9J2ApO1xuICB9XG5cbiAgY29uc3QgcnVsZURhdGEgPSB7XG4gICAgc2VsZWN0b3IsXG4gICAgYXN0XG4gIH07XG4gIGNvbnN0IGRlYnVnVmFsdWUgPSBnZXREZWJ1Z1N0eWxlVmFsdWUocmF3U3R5bGVzKTtcbiAgY29uc3Qgc2hvdWxkUmVtb3ZlID0gaXNSZW1vdmVTZXRJblN0eWxlcyhyYXdTdHlsZXMpO1xuICBsZXQgc3R5bGVzID0gcmF3U3R5bGVzO1xuXG4gIGlmIChkZWJ1Z1ZhbHVlKSB7XG4gICAgLy8gZ2V0IHJpZCBvZiAnZGVidWcnIGZyb20gc3R5bGVzXG4gICAgc3R5bGVzID0gcmF3U3R5bGVzLmZpbHRlcihzID0+IHMucHJvcGVydHkgIT09IERFQlVHX1BTRVVET19QUk9QRVJUWV9LRVkpOyAvLyBhbmQgc2V0IGl0IGFzIHNlcGFyYXRlIHByb3BlcnR5IG9ubHkgaWYgaXRzIHZhbHVlIGlzIHZhbGlkXG4gICAgLy8gd2hpY2ggaXMgJ3RydWUnIG9yICdnbG9iYWwnXG5cbiAgICBpZiAoZGVidWdWYWx1ZSA9PT0gUFNFVURPX1BST1BFUlRZX1BPU0lUSVZFX1ZBTFVFIHx8IGRlYnVnVmFsdWUgPT09IERFQlVHX1BTRVVET19QUk9QRVJUWV9HTE9CQUxfVkFMVUUpIHtcbiAgICAgIHJ1bGVEYXRhLmRlYnVnID0gZGVidWdWYWx1ZTtcbiAgICB9XG4gIH1cblxuICBpZiAoc2hvdWxkUmVtb3ZlKSB7XG4gICAgLy8gbm8gb3RoZXIgc3R5bGVzIGFyZSBuZWVkZWQgdG8gYXBwbHkgaWYgJ3JlbW92ZScgaXMgc2V0XG4gICAgcnVsZURhdGEuc3R5bGUgPSB7XG4gICAgICBbUkVNT1ZFX1BTRVVET19NQVJLRVJdOiBQU0VVRE9fUFJPUEVSVFlfUE9TSVRJVkVfVkFMVUVcbiAgICB9O1xuICAgIC8qKlxuICAgICAqICdjb250ZW50JyBwcm9wZXJ0eSBpcyBuZWVkZWQgZm9yIEV4dENzc0NvbmZpZ3VyYXRpb24uYmVmb3JlU3R5bGVBcHBsaWVkKCkuXG4gICAgICpcbiAgICAgKiBAc2VlIHtAbGluayBCZWZvcmVTdHlsZUFwcGxpZWRDYWxsYmFja31cbiAgICAgKi9cblxuICAgIGNvbnN0IGNvbnRlbnRTdHlsZSA9IHN0eWxlcy5maW5kKHMgPT4gcy5wcm9wZXJ0eSA9PT0gQ09OVEVOVF9DU1NfUFJPUEVSVFkpO1xuXG4gICAgaWYgKGNvbnRlbnRTdHlsZSkge1xuICAgICAgcnVsZURhdGEuc3R5bGVbQ09OVEVOVF9DU1NfUFJPUEVSVFldID0gY29udGVudFN0eWxlLnZhbHVlO1xuICAgIH1cbiAgfSBlbHNlIHtcbiAgICAvLyBvdGhlcndpc2UgYWxsIHN0eWxlcyBzaG91bGQgYmUgYXBwbGllZC5cbiAgICAvLyBldmVyeSBzdHlsZSBwcm9wZXJ0eSB3aWxsIGJlIHVuaXF1ZSBiZWNhdXNlIG9mIHRoZWlyIGNvbnZlcnRpbmcgaW50byBvYmplY3RcbiAgICBpZiAoc3R5bGVzLmxlbmd0aCA+IDApIHtcbiAgICAgIGNvbnN0IHN0eWxlc0FzRW50cmllcyA9IHN0eWxlcy5tYXAoc3R5bGUgPT4ge1xuICAgICAgICBjb25zdCB7XG4gICAgICAgICAgcHJvcGVydHksXG4gICAgICAgICAgdmFsdWVcbiAgICAgICAgfSA9IHN0eWxlO1xuICAgICAgICByZXR1cm4gW3Byb3BlcnR5LCB2YWx1ZV07XG4gICAgICB9KTtcbiAgICAgIGNvbnN0IHByZXBhcmVkU3R5bGVEYXRhID0gZ2V0T2JqZWN0RnJvbUVudHJpZXMoc3R5bGVzQXNFbnRyaWVzKTtcbiAgICAgIHJ1bGVEYXRhLnN0eWxlID0gcHJlcGFyZWRTdHlsZURhdGE7XG4gICAgfVxuICB9XG5cbiAgcmV0dXJuIHJ1bGVEYXRhO1xufTtcbi8qKlxuICogQ29tYmluZXMgcHJldmlvdXNseSBwYXJzZWQgY3NzIHJ1bGVzIGRhdGEgb2JqZWN0c1xuICogaW50byBydWxlcyB3aGljaCBhcmUgcmVhZHkgdG8gYXBwbHkuXG4gKlxuICogQHBhcmFtIHJhd1Jlc3VsdHMgUHJldmlvdXNseSBwYXJzZWQgY3NzIHJ1bGVzIGRhdGEgb2JqZWN0cy5cbiAqXG4gKiBAcmV0dXJucyBQYXJzZWQgRXh0ZW5kZWRDc3MgcnVsZSBkYXRhLlxuICovXG5cbmNvbnN0IGNvbWJpbmVSdWxlc0RhdGEgPSByYXdSZXN1bHRzID0+IHtcbiAgY29uc3QgcmVzdWx0cyA9IFtdO1xuICByYXdSZXN1bHRzLmZvckVhY2goKHZhbHVlLCBrZXkpID0+IHtcbiAgICBjb25zdCBzZWxlY3RvciA9IGtleTtcbiAgICBjb25zdCB7XG4gICAgICBhc3QsXG4gICAgICBzdHlsZXM6IHJhd1N0eWxlc1xuICAgIH0gPSB2YWx1ZTtcbiAgICByZXN1bHRzLnB1c2gocHJlcGFyZVJ1bGVEYXRhKHtcbiAgICAgIHNlbGVjdG9yLFxuICAgICAgYXN0LFxuICAgICAgcmF3U3R5bGVzXG4gICAgfSkpO1xuICB9KTtcbiAgcmV0dXJuIHJlc3VsdHM7XG59O1xuXG4vKipcbiAqIFRyaW1zIGByYXdTdHlsZWAgYW5kIHNwbGl0cyBpdCBpbnRvIHRva2Vucy5cbiAqXG4gKiBAcGFyYW0gcmF3U3R5bGUgU3R5bGUgZGVjbGFyYXRpb24gYmxvY2sgY29udGVudCBpbnNpZGUgY3VybHkgYnJhY2tldCDigJQgYHtgIGFuZCBgfWAg4oCUXG4gKiBjYW4gYmUgYSBzaW5nbGUgc3R5bGUgZGVjbGFyYXRpb24gb3IgYSBsaXN0IG9mIGRlY2xhcmF0aW9ucy5cbiAqXG4gKiBAcmV0dXJucyBBcnJheSBvZiB0b2tlbnMgc3VwcG9ydGVkIGZvciBzdHlsZSBkZWNsYXJhdGlvbiBibG9jay5cbiAqL1xuXG5jb25zdCB0b2tlbml6ZVN0eWxlQmxvY2sgPSByYXdTdHlsZSA9PiB7XG4gIGNvbnN0IHN0eWxlRGVjbGFyYXRpb24gPSByYXdTdHlsZS50cmltKCk7XG4gIHJldHVybiB0b2tlbml6ZShzdHlsZURlY2xhcmF0aW9uLCBTVVBQT1JURURfU1RZTEVfREVDTEFSQVRJT05fTUFSS1MpO1xufTtcblxuLyoqXG4gKiBEZXNjcmliZXMgcG9zc2libGUgc3R5bGUgZGVjbGFyYXRpb24gcGFydHMuXG4gKlxuICogSU1QT1JUQU5UOiBpdCBpcyB1c2VkIGFzICdjb25zdCcgaW5zdGVhZCBvZiAnZW51bScgdG8gYXZvaWQgc2lkZSBlZmZlY3RzXG4gKiBkdXJpbmcgRXh0ZW5kZWRDc3MgaW1wb3J0IGludG8gb3RoZXIgbGlicmFyaWVzLlxuICovXG5cbmNvbnN0IERFQ0xBUkFUSU9OX1BBUlQgPSB7XG4gIFBST1BFUlRZOiAncHJvcGVydHknLFxuICBWQUxVRTogJ3ZhbHVlJ1xufTtcblxuLyoqXG4gKiBDaGVja3Mgd2hldGhlciB0aGUgcXVvdGVzIGhhcyBiZWVuIG9wZW5lZCBmb3Igc3R5bGUgdmFsdWUuXG4gKlxuICogQHBhcmFtIGNvbnRleHQgU3R5bGUgYmxvY2sgcGFyc2VyIGNvbnRleHQuXG4gKlxuICogQHJldHVybnMgVHJ1ZSBpZiBzdHlsZSB2YWx1ZSBoYXMgYWxyZWFkeSBvcGVuZWQgcXVvdGVzLlxuICovXG5jb25zdCBpc1ZhbHVlUXVvdGVzT3BlbiA9IGNvbnRleHQgPT4ge1xuICByZXR1cm4gY29udGV4dC5idWZmZXJWYWx1ZSAhPT0gJycgJiYgY29udGV4dC52YWx1ZVF1b3RlTWFyayAhPT0gbnVsbDtcbn07XG4vKipcbiAqIFNhdmVzIHBhcnNlZCBwcm9wZXJ0eSBhbmQgdmFsdWUgdG8gY29sbGVjdGlvbiBvZiBwYXJzZWQgc3R5bGVzLlxuICogUHJ1bmVzIGNvbnRleHQgYnVmZmVycyBmb3IgcHJvcGVydHkgYW5kIHZhbHVlLlxuICpcbiAqIEBwYXJhbSBjb250ZXh0IFN0eWxlIGJsb2NrIHBhcnNlciBjb250ZXh0LlxuICovXG5cblxuY29uc3QgY29sbGVjdFN0eWxlID0gY29udGV4dCA9PiB7XG4gIGNvbnRleHQuc3R5bGVzLnB1c2goe1xuICAgIHByb3BlcnR5OiBjb250ZXh0LmJ1ZmZlclByb3BlcnR5LnRyaW0oKSxcbiAgICB2YWx1ZTogY29udGV4dC5idWZmZXJWYWx1ZS50cmltKClcbiAgfSk7IC8vIHJlc2V0IGJ1ZmZlcnNcblxuICBjb250ZXh0LmJ1ZmZlclByb3BlcnR5ID0gJyc7XG4gIGNvbnRleHQuYnVmZmVyVmFsdWUgPSAnJztcbn07XG4vKipcbiAqIEhhbmRsZXMgdG9rZW4gd2hpY2ggaXMgc3VwcG9zZWQgdG8gYmUgYSBwYXJ0IG9mIHN0eWxlICoqcHJvcGVydHkqKi5cbiAqXG4gKiBAcGFyYW0gY29udGV4dCBTdHlsZSBibG9jayBwYXJzZXIgY29udGV4dC5cbiAqIEBwYXJhbSBzdHlsZUJsb2NrIFdob2xlIHN0eWxlIGJsb2NrIHdoaWNoIGlzIGJlaW5nIHBhcnNlZC5cbiAqIEBwYXJhbSB0b2tlbiBDdXJyZW50IHRva2VuLlxuICpcbiAqIEB0aHJvd3MgQW4gZXJyb3Igb24gaW52YWxpZCB0b2tlbi5cbiAqL1xuXG5cbmNvbnN0IHByb2Nlc3NQcm9wZXJ0eVRva2VuID0gKGNvbnRleHQsIHN0eWxlQmxvY2ssIHRva2VuKSA9PiB7XG4gIGNvbnN0IHtcbiAgICB2YWx1ZTogdG9rZW5WYWx1ZVxuICB9ID0gdG9rZW47XG5cbiAgc3dpdGNoICh0b2tlbi50eXBlKSB7XG4gICAgY2FzZSBUT0tFTl9UWVBFLldPUkQ6XG4gICAgICBpZiAoY29udGV4dC5idWZmZXJQcm9wZXJ0eS5sZW5ndGggPiAwKSB7XG4gICAgICAgIC8vIGUuZy4gJ3BhZGRpbmcgdG9wOiAwOycgLSBjdXJyZW50IHRva2VuVmFsdWUgaXMgJ3RvcCcgd2hpY2ggaXMgbm90IHZhbGlkXG4gICAgICAgIHRocm93IG5ldyBFcnJvcihgSW52YWxpZCBzdHlsZSBwcm9wZXJ0eSBpbiBzdHlsZSBibG9jazogJyR7c3R5bGVCbG9ja30nYCk7XG4gICAgICB9XG5cbiAgICAgIGNvbnRleHQuYnVmZmVyUHJvcGVydHkgKz0gdG9rZW5WYWx1ZTtcbiAgICAgIGJyZWFrO1xuXG4gICAgY2FzZSBUT0tFTl9UWVBFLk1BUks6XG4gICAgICAvLyBvbmx5IGNvbG9uIGFuZCB3aGl0ZXNwYWNlcyBhcmUgYWxsb3dlZCB3aGlsZSBzdHlsZSBwcm9wZXJ0eSBwYXJzaW5nXG4gICAgICBpZiAodG9rZW5WYWx1ZSA9PT0gQ09MT04pIHtcbiAgICAgICAgaWYgKGNvbnRleHQuYnVmZmVyUHJvcGVydHkudHJpbSgpLmxlbmd0aCA9PT0gMCkge1xuICAgICAgICAgIC8vIGUuZy4gc3VjaCBzdHlsZSBibG9jazogJ3sgOiBub25lOyB9J1xuICAgICAgICAgIHRocm93IG5ldyBFcnJvcihgTWlzc2luZyBzdHlsZSBwcm9wZXJ0eSBiZWZvcmUgJzonIGluIHN0eWxlIGJsb2NrOiAnJHtzdHlsZUJsb2NrfSdgKTtcbiAgICAgICAgfSAvLyB0aGUgcHJvcGVydHkgc3VjY2Vzc2Z1bGx5IGNvbGxlY3RlZFxuXG5cbiAgICAgICAgY29udGV4dC5idWZmZXJQcm9wZXJ0eSA9IGNvbnRleHQuYnVmZmVyUHJvcGVydHkudHJpbSgpOyAvLyBwcmVwYXJlIGZvciB2YWx1ZSBjb2xsZWN0aW5nXG5cbiAgICAgICAgY29udGV4dC5wcm9jZXNzaW5nID0gREVDTEFSQVRJT05fUEFSVC5WQUxVRTsgLy8gdGhlIHByb3BlcnR5IGJ1ZmZlciBzaGFsbCBiZSByZXNldCBhZnRlciB0aGUgdmFsdWUgaXMgc3VjY2Vzc2Z1bGx5IGNvbGxlY3RlZFxuICAgICAgfSBlbHNlIGlmIChXSElURV9TUEFDRV9DSEFSQUNURVJTLmluY2x1ZGVzKHRva2VuVmFsdWUpKSA7IGVsc2Uge1xuICAgICAgICAvLyBpZiBhZnRlciB0aGUgcHJvcGVydHkgdGhlcmUgaXMgYW55dGhpbmcgb3RoZXIgdGhhbiAnOicgZXhjZXB0IHdoaXRlc3BhY2UsIHRoaXMgaXMgYSBwYXJzZSBlcnJvclxuICAgICAgICAvLyBodHRwczovL3d3dy53My5vcmcvVFIvY3NzLXN5bnRheC0zLyNjb25zdW1lLWRlY2xhcmF0aW9uXG4gICAgICAgIHRocm93IG5ldyBFcnJvcihgSW52YWxpZCBzdHlsZSBkZWNsYXJhdGlvbiBpbiBzdHlsZSBibG9jazogJyR7c3R5bGVCbG9ja30nYCk7XG4gICAgICB9XG5cbiAgICAgIGJyZWFrO1xuXG4gICAgZGVmYXVsdDpcbiAgICAgIHRocm93IG5ldyBFcnJvcihgVW5zdXBwb3J0ZWQgc3R5bGUgcHJvcGVydHkgY2hhcmFjdGVyOiAnJHt0b2tlblZhbHVlfScgaW4gc3R5bGUgYmxvY2s6ICcke3N0eWxlQmxvY2t9J2ApO1xuICB9XG59O1xuLyoqXG4gKiBIYW5kbGVzIHRva2VuIHdoaWNoIGlzIHN1cHBvc2VkIHRvIGJlIGEgcGFydCBvZiBzdHlsZSAqKnZhbHVlKiouXG4gKlxuICogQHBhcmFtIGNvbnRleHQgU3R5bGUgYmxvY2sgcGFyc2VyIGNvbnRleHQuXG4gKiBAcGFyYW0gc3R5bGVCbG9jayBXaG9sZSBzdHlsZSBibG9jayB3aGljaCBpcyBiZWluZyBwYXJzZWQuXG4gKiBAcGFyYW0gdG9rZW4gQ3VycmVudCB0b2tlbi5cbiAqXG4gKiBAdGhyb3dzIEFuIGVycm9yIG9uIGludmFsaWQgdG9rZW4uXG4gKi9cblxuXG5jb25zdCBwcm9jZXNzVmFsdWVUb2tlbiA9IChjb250ZXh0LCBzdHlsZUJsb2NrLCB0b2tlbikgPT4ge1xuICBjb25zdCB7XG4gICAgdmFsdWU6IHRva2VuVmFsdWVcbiAgfSA9IHRva2VuO1xuXG4gIGlmICh0b2tlbi50eXBlID09PSBUT0tFTl9UWVBFLldPUkQpIHtcbiAgICAvLyBzaW1wbHkgY29sbGVjdCB0byBidWZmZXJcbiAgICBjb250ZXh0LmJ1ZmZlclZhbHVlICs9IHRva2VuVmFsdWU7XG4gIH0gZWxzZSB7XG4gICAgLy8gb3RoZXJ3aXNlIGNoZWNrIHRoZSBtYXJrXG4gICAgc3dpdGNoICh0b2tlblZhbHVlKSB7XG4gICAgICBjYXNlIENPTE9OOlxuICAgICAgICAvLyB0aGUgJzonIGNoYXJhY3RlciBpbnNpZGUgb2YgdGhlIHZhbHVlIHNob3VsZCBiZSBpbnNpZGUgb2YgcXVvdGVzXG4gICAgICAgIC8vIG90aGVyd2lzZSB0aGUgdmFsdWUgaXMgbm90IHZhbGlkXG4gICAgICAgIC8vIGUuZy4gJ2NvbnRlbnQ6IGRpc3BsYXk6IG5vbmUnXG4gICAgICAgIC8vIHBhcnNlciBpcyBoZXJlICAgICAgICDihpFcbiAgICAgICAgaWYgKCFpc1ZhbHVlUXVvdGVzT3Blbihjb250ZXh0KSkge1xuICAgICAgICAgIC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBtYXgtbGVuXG4gICAgICAgICAgdGhyb3cgbmV3IEVycm9yKGBJbnZhbGlkIHN0eWxlIHZhbHVlIGZvciBwcm9wZXJ0eSAnJHtjb250ZXh0LmJ1ZmZlclByb3BlcnR5fScgaW4gc3R5bGUgYmxvY2s6ICcke3N0eWxlQmxvY2t9J2ApO1xuICAgICAgICB9IC8vIGNvbGxlY3QgdGhlIGNvbG9uIGluc2lkZSBxdW90ZXNcbiAgICAgICAgLy8gZS5nLiAnY29udGVudDogXCJ0ZXN0OjEyM1wiJ1xuICAgICAgICAvLyBwYXJzZXIgaXMgaGVyZSAgICAgIOKGkVxuXG5cbiAgICAgICAgY29udGV4dC5idWZmZXJWYWx1ZSArPSB0b2tlblZhbHVlO1xuICAgICAgICBicmVhaztcblxuICAgICAgY2FzZSBTRU1JQ09MT046XG4gICAgICAgIGlmIChpc1ZhbHVlUXVvdGVzT3Blbihjb250ZXh0KSkge1xuICAgICAgICAgIC8vICc7JyBpbnNpZGUgcXVvdGVzIGlzIHBhcnQgb2Ygc3R5bGUgdmFsdWVcbiAgICAgICAgICAvLyBlLmcuICdjb250ZW50OiBcInRlc3Q7XCInXG4gICAgICAgICAgY29udGV4dC5idWZmZXJWYWx1ZSArPSB0b2tlblZhbHVlO1xuICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgIC8vIG90aGVyd2lzZSB0aGUgdmFsdWUgaXMgc3VjY2Vzc2Z1bGx5IGNvbGxlY3RlZFxuICAgICAgICAgIC8vIHNhdmUgcGFyc2VkIHN0eWxlXG4gICAgICAgICAgY29sbGVjdFN0eWxlKGNvbnRleHQpOyAvLyBwcmVwYXJlIGZvciB2YWx1ZSBjb2xsZWN0aW5nXG5cbiAgICAgICAgICBjb250ZXh0LnByb2Nlc3NpbmcgPSBERUNMQVJBVElPTl9QQVJULlBST1BFUlRZO1xuICAgICAgICB9XG5cbiAgICAgICAgYnJlYWs7XG5cbiAgICAgIGNhc2UgU0lOR0xFX1FVT1RFOlxuICAgICAgY2FzZSBET1VCTEVfUVVPVEU6XG4gICAgICAgIC8vIGlmIHF1b3RlcyBhcmUgbm90IG9wZW5cbiAgICAgICAgaWYgKGNvbnRleHQudmFsdWVRdW90ZU1hcmsgPT09IG51bGwpIHtcbiAgICAgICAgICAvLyBzYXZlIHRoZSBvcGVuaW5nIHF1b3RlIG1hcmsgZm9yIGxhdGVyIGNvbXBhcmlzb25cbiAgICAgICAgICBjb250ZXh0LnZhbHVlUXVvdGVNYXJrID0gdG9rZW5WYWx1ZTtcbiAgICAgICAgfSBlbHNlIGlmICghY29udGV4dC5idWZmZXJWYWx1ZS5lbmRzV2l0aChCQUNLU0xBU0gpIC8vIG90aGVyd2lzZSBhIHF1b3RlIGFwcGVhcmVkIGluIHRoZSB2YWx1ZSBlYXJsaWVyLFxuICAgICAgICAvLyBhbmQgbm9uLWVzY2FwZWQgcXVvdGUgc2hvdWxkIGJlIGNoZWNrZWQgd2hldGhlciBpdCBpcyBhIGNsb3NpbmcgcXVvdGVcbiAgICAgICAgJiYgY29udGV4dC52YWx1ZVF1b3RlTWFyayA9PT0gdG9rZW5WYWx1ZSkge1xuICAgICAgICAgIGNvbnRleHQudmFsdWVRdW90ZU1hcmsgPSBudWxsO1xuICAgICAgICB9IC8vIGFsd2F5cyBzYXZlIHRoZSBxdW90ZSB0byB0aGUgYnVmZmVyXG4gICAgICAgIC8vIGJ1dCBhZnRlciB0aGUgY29udGV4dC5idWZmZXJWYWx1ZSBpcyBjaGVja2VkIGZvciBCQUNLU0xBU0ggYWJvdmVcbiAgICAgICAgLy8gZS5nLiAnY29udGVudDogXCJ0ZXN0OjEyM1wiJ1xuICAgICAgICAvLyAgICAgICdjb250ZW50OiBcIlxcXCJcIidcblxuXG4gICAgICAgIGNvbnRleHQuYnVmZmVyVmFsdWUgKz0gdG9rZW5WYWx1ZTtcbiAgICAgICAgYnJlYWs7XG5cbiAgICAgIGNhc2UgQkFDS1NMQVNIOlxuICAgICAgICBpZiAoIWlzVmFsdWVRdW90ZXNPcGVuKGNvbnRleHQpKSB7XG4gICAgICAgICAgLy8gZXNsaW50LWRpc2FibGUtbmV4dC1saW5lIG1heC1sZW5cbiAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoYEludmFsaWQgc3R5bGUgdmFsdWUgZm9yIHByb3BlcnR5ICcke2NvbnRleHQuYnVmZmVyUHJvcGVydHl9JyBpbiBzdHlsZSBibG9jazogJyR7c3R5bGVCbG9ja30nYCk7XG4gICAgICAgIH0gLy8gY29sbGVjdCB0aGUgYmFja3NsYXNoIGluc2lkZSBxdW90ZXNcbiAgICAgICAgLy8gZS5nLiAnIGNvbnRlbnQ6IFwiXFxcIlwiICdcbiAgICAgICAgLy8gcGFyc2VyIGlzIGhlcmUgICDihpFcblxuXG4gICAgICAgIGNvbnRleHQuYnVmZmVyVmFsdWUgKz0gdG9rZW5WYWx1ZTtcbiAgICAgICAgYnJlYWs7XG5cbiAgICAgIGNhc2UgU1BBQ0U6XG4gICAgICBjYXNlIFRBQjpcbiAgICAgIGNhc2UgQ0FSUklBR0VfUkVUVVJOOlxuICAgICAgY2FzZSBMSU5FX0ZFRUQ6XG4gICAgICBjYXNlIEZPUk1fRkVFRDpcbiAgICAgICAgLy8gd2hpdGVzcGFjZSBzaG91bGQgYmUgY29sbGVjdGVkIG9ubHkgaWYgdGhlIHZhbHVlIGNvbGxlY3Rpbmcgc3RhcnRlZFxuICAgICAgICAvLyB3aGljaCBtZWFucyBpbnNpZGUgb2YgdGhlIHZhbHVlXG4gICAgICAgIC8vIGUuZy4gJ3dpZHRoOiAxMDAlICFpbXBvcnRhbnQnXG4gICAgICAgIC8vIHBhcnNlciBpcyBoZXJlICAg4oaRXG4gICAgICAgIGlmIChjb250ZXh0LmJ1ZmZlclZhbHVlLmxlbmd0aCA+IDApIHtcbiAgICAgICAgICBjb250ZXh0LmJ1ZmZlclZhbHVlICs9IHRva2VuVmFsdWU7XG4gICAgICAgIH0gLy8gb3RoZXJ3aXNlIGl0IGNhbiBiZSBvbWl0dGVkXG4gICAgICAgIC8vIGUuZy4gJ3dpZHRoOiAgMTAwJSAhaW1wb3J0YW50J1xuICAgICAgICAvLyBoZXJlICAgICAgICDihpFcblxuXG4gICAgICAgIGJyZWFrO1xuXG4gICAgICBkZWZhdWx0OlxuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoYFVua25vd24gc3R5bGUgZGVjbGFyYXRpb24gdG9rZW46ICcke3Rva2VuVmFsdWV9J2ApO1xuICAgIH1cbiAgfVxufTtcbi8qKlxuICogUGFyc2VzIGNzcyBydWxlIHN0eWxlIGJsb2NrLlxuICpcbiAqIEBwYXJhbSByYXdTdHlsZUJsb2NrIFN0eWxlIGJsb2NrIHRvIHBhcnNlLlxuICpcbiAqIEByZXR1cm5zIEFycmF5IG9mIHN0eWxlIGRlY2xhcmF0aW9ucy5cbiAqIEB0aHJvd3MgQW4gZXJyb3Igb24gaW52YWxpZCBzdHlsZSBibG9jay5cbiAqL1xuXG5cbmNvbnN0IHBhcnNlU3R5bGVCbG9jayA9IHJhd1N0eWxlQmxvY2sgPT4ge1xuICBjb25zdCBzdHlsZUJsb2NrID0gcmF3U3R5bGVCbG9jay50cmltKCk7XG4gIGNvbnN0IHRva2VucyA9IHRva2VuaXplU3R5bGVCbG9jayhzdHlsZUJsb2NrKTtcbiAgY29uc3QgY29udGV4dCA9IHtcbiAgICAvLyBzdHlsZSBkZWNsYXJhdGlvbiBwYXJzaW5nIGFsd2F5cyBzdGFydHMgd2l0aCAncHJvcGVydHknXG4gICAgcHJvY2Vzc2luZzogREVDTEFSQVRJT05fUEFSVC5QUk9QRVJUWSxcbiAgICBzdHlsZXM6IFtdLFxuICAgIGJ1ZmZlclByb3BlcnR5OiAnJyxcbiAgICBidWZmZXJWYWx1ZTogJycsXG4gICAgdmFsdWVRdW90ZU1hcms6IG51bGxcbiAgfTtcbiAgbGV0IGkgPSAwO1xuXG4gIHdoaWxlIChpIDwgdG9rZW5zLmxlbmd0aCkge1xuICAgIGNvbnN0IHRva2VuID0gdG9rZW5zW2ldO1xuXG4gICAgaWYgKCF0b2tlbikge1xuICAgICAgYnJlYWs7XG4gICAgfVxuXG4gICAgaWYgKGNvbnRleHQucHJvY2Vzc2luZyA9PT0gREVDTEFSQVRJT05fUEFSVC5QUk9QRVJUWSkge1xuICAgICAgcHJvY2Vzc1Byb3BlcnR5VG9rZW4oY29udGV4dCwgc3R5bGVCbG9jaywgdG9rZW4pO1xuICAgIH0gZWxzZSBpZiAoY29udGV4dC5wcm9jZXNzaW5nID09PSBERUNMQVJBVElPTl9QQVJULlZBTFVFKSB7XG4gICAgICBwcm9jZXNzVmFsdWVUb2tlbihjb250ZXh0LCBzdHlsZUJsb2NrLCB0b2tlbik7XG4gICAgfSBlbHNlIHtcbiAgICAgIHRocm93IG5ldyBFcnJvcignU3R5bGUgZGVjbGFyYXRpb24gcGFyc2luZyBmYWlsZWQnKTtcbiAgICB9XG5cbiAgICBpICs9IDE7XG4gIH0gLy8gdW5iYWxhbmNlZCB2YWx1ZSBxdW90ZXNcbiAgLy8gZS5nLiAnY29udGVudDogXCJ0ZXN0fSAnXG5cblxuICBpZiAoaXNWYWx1ZVF1b3Rlc09wZW4oY29udGV4dCkpIHtcbiAgICB0aHJvdyBuZXcgRXJyb3IoYFVuYmFsYW5jZWQgc3R5bGUgZGVjbGFyYXRpb24gcXVvdGVzIGluIHN0eWxlIGJsb2NrOiAnJHtzdHlsZUJsb2NrfSdgKTtcbiAgfSAvLyBjb2xsZWN0ZWQgcHJvcGVydHkgYW5kIHZhbHVlIGhhdmUgbm90IGJlZW4gc2F2ZWQgdG8gc3R5bGVzO1xuICAvLyBpdCBpcyBwb3NzaWJsZSBmb3Igc3R5bGUgYmxvY2sgd2l0aCBubyBzZW1pY29sb24gYXQgdGhlIGVuZFxuICAvLyBlLmcuIHN1Y2ggc3R5bGUgYmxvY2s6ICd7IGRpc3BsYXk6IG5vbmUgfSdcblxuXG4gIGlmIChjb250ZXh0LmJ1ZmZlclByb3BlcnR5Lmxlbmd0aCA+IDApIHtcbiAgICBpZiAoY29udGV4dC5idWZmZXJWYWx1ZS5sZW5ndGggPT09IDApIHtcbiAgICAgIC8vIGUuZy4gc3VjaCBzdHlsZSBibG9ja3M6XG4gICAgICAvLyAgICd7IGRpc3BsYXk6ICB9J1xuICAgICAgLy8gICAneyByZW1vdmUgfSdcbiAgICAgIC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBtYXgtbGVuXG4gICAgICB0aHJvdyBuZXcgRXJyb3IoYE1pc3Npbmcgc3R5bGUgdmFsdWUgZm9yIHByb3BlcnR5ICcke2NvbnRleHQuYnVmZmVyUHJvcGVydHl9JyBpbiBzdHlsZSBibG9jayAnJHtzdHlsZUJsb2NrfSdgKTtcbiAgICB9XG5cbiAgICBjb2xsZWN0U3R5bGUoY29udGV4dCk7XG4gIH0gLy8gcnVsZSB3aXRoIGVtcHR5IHN0eWxlIGJsb2NrXG4gIC8vIGUuZy4gJ2RpdiB7IH0nXG5cblxuICBpZiAoY29udGV4dC5zdHlsZXMubGVuZ3RoID09PSAwKSB7XG4gICAgdGhyb3cgbmV3IEVycm9yKFNUWUxFX0VSUk9SX1BSRUZJWC5OT19TVFlMRSk7XG4gIH1cblxuICByZXR1cm4gY29udGV4dC5zdHlsZXM7XG59O1xuXG4vKipcbiAqIFJldHVybnMgYXJyYXkgb2YgcG9zaXRpb25zIG9mIGB7YCBpbiBgY3NzUnVsZWAuXG4gKlxuICogQHBhcmFtIGNzc1J1bGUgQ1NTIHJ1bGUuXG4gKlxuICogQHJldHVybnMgQXJyYXkgb2YgbGVmdCBjdXJseSBicmFja2V0IGluZGV4ZXMuXG4gKi9cblxuY29uc3QgZ2V0TGVmdEN1cmx5QnJhY2tldEluZGV4ZXMgPSBjc3NSdWxlID0+IHtcbiAgY29uc3QgaW5kZXhlcyA9IFtdO1xuXG4gIGZvciAobGV0IGkgPSAwOyBpIDwgY3NzUnVsZS5sZW5ndGg7IGkgKz0gMSkge1xuICAgIGlmIChjc3NSdWxlW2ldID09PSBCUkFDS0VULkNVUkxZLkxFRlQpIHtcbiAgICAgIGluZGV4ZXMucHVzaChpKTtcbiAgICB9XG4gIH1cblxuICByZXR1cm4gaW5kZXhlcztcbn07IC8vIFRPRE86IHVzZSBgZXh0Q3NzRG9jYCBmb3IgY2FjaGluZyBvZiBzdHlsZSBibG9jayBwYXJzZXIgcmVzdWx0c1xuXG4vKipcbiAqIFBhcnNlcyBDU1MgcnVsZSBpbnRvIHJ1bGVzIGRhdGEgb2JqZWN0OlxuICogMS4gRmluZCB0aGUgbGFzdCBge2AgbWFyayBpbiB0aGUgcnVsZVxuICogICAgd2hpY2ggc3VwcG9zZWQgdG8gYmUgYSBkaXZpZGVyIGJldHdlZW4gc2VsZWN0b3IgYW5kIHN0eWxlIGJsb2NrLlxuICogMi4gVmFsaWRhdGVzIGZvdW5kIHN0cmluZyBwYXJ0IGJlZm9yZSB0aGUgYHtgIHZpYSBzZWxlY3RvciBwYXJzZXI7IGFuZCBpZjpcbiAqICAtIHBhcnNpbmcgZmFpbGVkIOKAkyBnZXQgdGhlIHByZXZpb3VzIGB7YCBpbiB0aGUgcnVsZSxcbiAqICAgIGFuZCB2YWxpZGF0ZXMgYSBuZXcgcnVsZSBwYXJ0IGFnYWluIFsyXTtcbiAqICAtIHBhcnNpbmcgc3VjY2Vzc2Z1bCDigJQgc2F2ZXMgYSBmb3VuZCBydWxlIHBhcnQgYXMgc2VsZWN0b3IgYW5kIHBhcnNlcyB0aGUgc3R5bGUgYmxvY2suXG4gKlxuICogQHBhcmFtIHJhd0Nzc1J1bGUgU2luZ2xlIENTUyBydWxlIHRvIHBhcnNlLlxuICogQHBhcmFtIGV4dENzc0RvYyBFeHRDc3NEb2N1bWVudCB3aGljaCBpcyB1c2VkIGZvciBzZWxlY3RvciBhc3QgY2FjaGluZy5cbiAqXG4gKiBAcmV0dXJucyBBcnJheSBvZiBydWxlcyBkYXRhIHdoaWNoIGNvbnRhaW5zOlxuICogICAtIHNlbGVjdG9yIGFzIHN0cmluZztcbiAqICAgLSBhc3QgdG8gcXVlcnkgZWxlbWVudHMgYnk7XG4gKiAgIC0gbWFwIG9mIHN0eWxlcyB0byBhcHBseS5cbiAqIEB0aHJvd3MgQW4gZXJyb3Igb24gaW52YWxpZCBjc3MgcnVsZSBzeW50YXg6XG4gKiAgIC0gdW5zdXBwb3J0ZWQgQ1NTIGZlYXR1cmVzIOKAkyBjb21tZW50cyBhbmQgYXQtcnVsZXNcbiAqICAgLSBpbnZhbGlkIHNlbGVjdG9yIG9yIHN0eWxlIGJsb2NrLlxuICovXG5cblxuY29uc3QgcGFyc2VSdWxlID0gKHJhd0Nzc1J1bGUsIGV4dENzc0RvYykgPT4ge1xuICB2YXIgX3Jhd1J1bGVEYXRhJHNlbGVjdG9yO1xuXG4gIGNvbnN0IGNzc1J1bGUgPSByYXdDc3NSdWxlLnRyaW0oKTtcblxuICBpZiAoY3NzUnVsZS5pbmNsdWRlcyhgJHtTTEFTSH0ke0FTVEVSSVNLfWApICYmIGNzc1J1bGUuaW5jbHVkZXMoYCR7QVNURVJJU0t9JHtTTEFTSH1gKSkge1xuICAgIHRocm93IG5ldyBFcnJvcihTVFlMRV9FUlJPUl9QUkVGSVguTk9fQ09NTUVOVCk7XG4gIH1cblxuICBjb25zdCBsZWZ0Q3VybHlCcmFja2V0SW5kZXhlcyA9IGdldExlZnRDdXJseUJyYWNrZXRJbmRleGVzKGNzc1J1bGUpOyAvLyBydWxlIHdpdGggc3R5bGUgYmxvY2sgYnV0IG5vIHNlbGVjdG9yXG4gIC8vIGUuZy4gJ3sgZGlzcGxheTogbm9uZTsgfSdcblxuICBpZiAoZ2V0Rmlyc3QobGVmdEN1cmx5QnJhY2tldEluZGV4ZXMpID09PSAwKSB7XG4gICAgdGhyb3cgbmV3IEVycm9yKE5PX1NFTEVDVE9SX0VSUk9SX1BSRUZJWCk7XG4gIH1cblxuICBsZXQgc2VsZWN0b3JEYXRhOyAvLyBpZiBydWxlIGhhcyBge2AgYnV0IHRoZXJlIGlzIG5vIGB9YFxuXG4gIGlmIChsZWZ0Q3VybHlCcmFja2V0SW5kZXhlcy5sZW5ndGggPiAwICYmICFjc3NSdWxlLmluY2x1ZGVzKEJSQUNLRVQuQ1VSTFkuUklHSFQpKSB7XG4gICAgdGhyb3cgbmV3IEVycm9yKGAke1NUWUxFX0VSUk9SX1BSRUZJWC5OT19TVFlMRX0gT1IgJHtTVFlMRV9FUlJPUl9QUkVGSVguVU5DTE9TRURfU1RZTEV9YCk7XG4gIH1cblxuICBpZiAoIC8vIGlmIHJ1bGUgaGFzIG5vIGB7YFxuICBsZWZ0Q3VybHlCcmFja2V0SW5kZXhlcy5sZW5ndGggPT09IDAgLy8gb3IgYH1gXG4gIHx8ICFjc3NSdWxlLmluY2x1ZGVzKEJSQUNLRVQuQ1VSTFkuUklHSFQpKSB7XG4gICAgdHJ5IHtcbiAgICAgIC8vIHRoZSB3aG9sZSBjc3MgcnVsZSBjb25zaWRlcmVkIGFzIFwic2VsZWN0b3IgcGFydFwiXG4gICAgICAvLyB3aGljaCBtYXkgY29udGFpbiA6cmVtb3ZlKCkgcHNldWRvLWNsYXNzXG4gICAgICBzZWxlY3RvckRhdGEgPSBwYXJzZVNlbGVjdG9yUnVsZVBhcnQoY3NzUnVsZSwgZXh0Q3NzRG9jKTtcblxuICAgICAgaWYgKHNlbGVjdG9yRGF0YS5zdWNjZXNzKSB7XG4gICAgICAgIHZhciBfc2VsZWN0b3JEYXRhJHN0eWxlc087XG5cbiAgICAgICAgLy8gcnVsZSB3aXRoIG5vIHN0eWxlIGJsb2NrIGhhcyB2YWxpZCA6cmVtb3ZlKCkgcHNldWRvLWNsYXNzXG4gICAgICAgIC8vIHdoaWNoIGlzIHBhcnNlZCBpbnRvIFwic3R5bGVzXCJcbiAgICAgICAgLy8gZS5nLiAnZGl2OnJlbW92ZSgpJ1xuICAgICAgICAvLyBidXQgYWxzbyBpdCBjYW4gYmUganVzdCBzZWxlY3RvciB3aXRoIG5vIHN0eWxlc1xuICAgICAgICAvLyBlLmcuICdkaXYnXG4gICAgICAgIC8vIHdoaWNoIHNob3VsZCBub3QgYmUgY29uc2lkZXJlZCBhcyB2YWxpZCBjc3MgcnVsZVxuICAgICAgICBpZiAoKChfc2VsZWN0b3JEYXRhJHN0eWxlc08gPSBzZWxlY3RvckRhdGEuc3R5bGVzT2ZTZWxlY3RvcikgPT09IG51bGwgfHwgX3NlbGVjdG9yRGF0YSRzdHlsZXNPID09PSB2b2lkIDAgPyB2b2lkIDAgOiBfc2VsZWN0b3JEYXRhJHN0eWxlc08ubGVuZ3RoKSA9PT0gMCkge1xuICAgICAgICAgIHRocm93IG5ldyBFcnJvcihTVFlMRV9FUlJPUl9QUkVGSVguTk9fU1RZTEVfT1JfUkVNT1ZFKTtcbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiB7XG4gICAgICAgICAgc2VsZWN0b3I6IHNlbGVjdG9yRGF0YS5zZWxlY3Rvci50cmltKCksXG4gICAgICAgICAgYXN0OiBzZWxlY3RvckRhdGEuYXN0LFxuICAgICAgICAgIHJhd1N0eWxlczogc2VsZWN0b3JEYXRhLnN0eWxlc09mU2VsZWN0b3JcbiAgICAgICAgfTtcbiAgICAgIH0gZWxzZSB7XG4gICAgICAgIC8vIG5vdCB2YWxpZCBzZWxlY3RvclxuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoJ0ludmFsaWQgc2VsZWN0b3InKTtcbiAgICAgIH1cbiAgICB9IGNhdGNoIChlKSB7XG4gICAgICB0aHJvdyBuZXcgRXJyb3IoZ2V0RXJyb3JNZXNzYWdlKGUpKTtcbiAgICB9XG4gIH1cblxuICBsZXQgc2VsZWN0b3JCdWZmZXI7XG4gIGxldCBzdHlsZUJsb2NrQnVmZmVyO1xuICBjb25zdCByYXdSdWxlRGF0YSA9IHtcbiAgICBzZWxlY3RvcjogJydcbiAgfTsgLy8gY3NzIHJ1bGUgc2hvdWxkIGJlIHBhcnNlZCBmcm9tIGl0cyBlbmRcblxuICBmb3IgKGxldCBpID0gbGVmdEN1cmx5QnJhY2tldEluZGV4ZXMubGVuZ3RoIC0gMTsgaSA+IC0xOyBpIC09IDEpIHtcbiAgICBjb25zdCBpbmRleCA9IGxlZnRDdXJseUJyYWNrZXRJbmRleGVzW2ldO1xuXG4gICAgaWYgKCFpbmRleCkge1xuICAgICAgdGhyb3cgbmV3IEVycm9yKGBJbXBvc3NpYmxlIHRvIGNvbnRpbnVlLCBubyAneycgdG8gcHJvY2VzcyBmb3IgcnVsZTogJyR7Y3NzUnVsZX0nYCk7XG4gICAgfSAvLyBzZWxlY3RvciBpcyBiZWZvcmUgYHtgLCBzdHlsZSBibG9jayBpcyBhZnRlciBpdFxuXG5cbiAgICBzZWxlY3RvckJ1ZmZlciA9IGNzc1J1bGUuc2xpY2UoMCwgaW5kZXgpOyAvLyBza2lwIGN1cmx5IGJyYWNrZXRzXG5cbiAgICBzdHlsZUJsb2NrQnVmZmVyID0gY3NzUnVsZS5zbGljZShpbmRleCArIDEsIGNzc1J1bGUubGVuZ3RoIC0gMSk7XG4gICAgc2VsZWN0b3JEYXRhID0gcGFyc2VTZWxlY3RvclJ1bGVQYXJ0KHNlbGVjdG9yQnVmZmVyLCBleHRDc3NEb2MpO1xuXG4gICAgaWYgKHNlbGVjdG9yRGF0YS5zdWNjZXNzKSB7XG4gICAgICB2YXIgX3Jhd1J1bGVEYXRhJHJhd1N0eWxlO1xuXG4gICAgICAvLyBzZWxlY3RvciBzdWNjZXNzZnVsbHkgcGFyc2VkXG4gICAgICByYXdSdWxlRGF0YS5zZWxlY3RvciA9IHNlbGVjdG9yRGF0YS5zZWxlY3Rvci50cmltKCk7XG4gICAgICByYXdSdWxlRGF0YS5hc3QgPSBzZWxlY3RvckRhdGEuYXN0O1xuICAgICAgcmF3UnVsZURhdGEucmF3U3R5bGVzID0gc2VsZWN0b3JEYXRhLnN0eWxlc09mU2VsZWN0b3I7IC8vIHN0eWxlIGJsb2NrIHNob3VsZCBiZSBwYXJzZWRcbiAgICAgIC8vIFRPRE86IGFkZCBjYWNoZSBmb3Igc3R5bGUgYmxvY2sgcGFyc2luZ1xuXG4gICAgICBjb25zdCBwYXJzZWRTdHlsZXMgPSBwYXJzZVN0eWxlQmxvY2soc3R5bGVCbG9ja0J1ZmZlcik7XG4gICAgICAoX3Jhd1J1bGVEYXRhJHJhd1N0eWxlID0gcmF3UnVsZURhdGEucmF3U3R5bGVzKSA9PT0gbnVsbCB8fCBfcmF3UnVsZURhdGEkcmF3U3R5bGUgPT09IHZvaWQgMCA/IHZvaWQgMCA6IF9yYXdSdWxlRGF0YSRyYXdTdHlsZS5wdXNoKC4uLnBhcnNlZFN0eWxlcyk7IC8vIHN0b3AgcnVsZSBwYXJzaW5nXG5cbiAgICAgIGJyZWFrO1xuICAgIH0gZWxzZSB7XG4gICAgICAvLyBpZiBzZWxlY3RvciB3YXMgbm90IHBhcnNlZCBzdWNjZXNzZnVsbHlcbiAgICAgIC8vIGNvbnRpbnVlIHdpdGggbmV4dCBpbmRleCBvZiBge2BcbiAgICAgIGNvbnRpbnVlO1xuICAgIH1cbiAgfVxuXG4gIGlmICgoKF9yYXdSdWxlRGF0YSRzZWxlY3RvciA9IHJhd1J1bGVEYXRhLnNlbGVjdG9yKSA9PT0gbnVsbCB8fCBfcmF3UnVsZURhdGEkc2VsZWN0b3IgPT09IHZvaWQgMCA/IHZvaWQgMCA6IF9yYXdSdWxlRGF0YSRzZWxlY3Rvci5sZW5ndGgpID09PSAwKSB7XG4gICAgLy8gc2tpcCB0aGUgcnVsZSBhcyBzZWxlY3RvclxuICAgIHRocm93IG5ldyBFcnJvcignU2VsZWN0b3IgaW4gbm90IHZhbGlkJyk7XG4gIH1cblxuICByZXR1cm4gcmF3UnVsZURhdGE7XG59O1xuLyoqXG4gKiBQYXJzZXMgYXJyYXkgb2YgQ1NTIHJ1bGVzIGludG8gYXJyYXkgb2YgcnVsZXMgZGF0YSBvYmplY3RzLlxuICogSW52YWxpZCBydWxlcyBhcmUgc2tpcHBlZCBhbmQgbm90IGFwcGxpZWQsXG4gKiBhbmQgdGhlIGVycm9ycyBhcmUgbG9nZ2VkLlxuICpcbiAqIEBwYXJhbSByYXdDc3NSdWxlcyBBcnJheSBvZiBydWxlcyB0byBwYXJzZS5cbiAqIEBwYXJhbSBleHRDc3NEb2MgTmVlZGVkIGZvciBzZWxlY3RvciBhc3QgY2FjaGluZy5cbiAqXG4gKiBAcmV0dXJucyBBcnJheSBvZiBwYXJzZWQgdmFsaWQgcnVsZXMgZGF0YS5cbiAqL1xuXG5jb25zdCBwYXJzZVJ1bGVzID0gKHJhd0Nzc1J1bGVzLCBleHRDc3NEb2MpID0+IHtcbiAgY29uc3QgcmF3UmVzdWx0cyA9IGNyZWF0ZVJhd1Jlc3VsdHNNYXAoKTtcbiAgY29uc3Qgd2FybmluZ3MgPSBbXTsgLy8gdHJpbSBhbGwgcnVsZXMgYW5kIGZpbmQgdW5pcXVlIG9uZXNcblxuICBjb25zdCB1bmlxdWVSdWxlcyA9IFsuLi5uZXcgU2V0KHJhd0Nzc1J1bGVzLm1hcChyID0+IHIudHJpbSgpKSldO1xuICB1bmlxdWVSdWxlcy5mb3JFYWNoKHJ1bGUgPT4ge1xuICAgIHRyeSB7XG4gICAgICBzYXZlVG9SYXdSZXN1bHRzKHJhd1Jlc3VsdHMsIHBhcnNlUnVsZShydWxlLCBleHRDc3NEb2MpKTtcbiAgICB9IGNhdGNoIChlKSB7XG4gICAgICAvLyBza2lwIHRoZSBpbnZhbGlkIHJ1bGVcbiAgICAgIGNvbnN0IGVycm9yTWVzc2FnZSA9IGdldEVycm9yTWVzc2FnZShlKTtcbiAgICAgIHdhcm5pbmdzLnB1c2goYCcke3J1bGV9JyAtIGVycm9yOiAnJHtlcnJvck1lc3NhZ2V9J2ApO1xuICAgIH1cbiAgfSk7IC8vIGxvZyBpbmZvIGFib3V0IHNraXBwZWQgaW52YWxpZCBydWxlc1xuXG4gIGlmICh3YXJuaW5ncy5sZW5ndGggPiAwKSB7XG4gICAgbG9nZ2VyLmluZm8oYEludmFsaWQgcnVsZXM6XFxuICAke3dhcm5pbmdzLmpvaW4oJ1xcbiAgJyl9YCk7XG4gIH1cblxuICByZXR1cm4gY29tYmluZVJ1bGVzRGF0YShyYXdSZXN1bHRzKTtcbn07XG5cbmNvbnN0IFJFR0VYUF9ERUNMQVJBVElPTl9FTkQgPSAvWzt9XS9nO1xuY29uc3QgUkVHRVhQX0RFQ0xBUkFUSU9OX0RJVklERVIgPSAvWzs6fV0vZztcbmNvbnN0IFJFR0VYUF9OT05fV0hJVEVTUEFDRSA9IC9cXFMvZztcbi8qKlxuICogSW50ZXJmYWNlIGZvciBzdHlsZXNoZWV0IHBhcnNlciBjb250ZXh0LlxuICovXG5cbi8qKlxuICogUmVzZXRzIHJ1bGUgZGF0YSBidWZmZXIgdG8gaW5pdCB2YWx1ZSBhZnRlciBydWxlIHN1Y2Nlc3NmdWxseSBjb2xsZWN0ZWQuXG4gKlxuICogQHBhcmFtIGNvbnRleHQgU3R5bGVzaGVldCBwYXJzZXIgY29udGV4dC5cbiAqL1xuY29uc3QgcmVzdG9yZVJ1bGVBY2MgPSBjb250ZXh0ID0+IHtcbiAgY29udGV4dC5yYXdSdWxlRGF0YSA9IHtcbiAgICBzZWxlY3RvcjogJydcbiAgfTtcbn07XG4vKipcbiAqIFBhcnNlcyBjcm9wcGVkIHNlbGVjdG9yIHBhcnQgZm91bmQgYmVmb3JlIGB7YCBwcmV2aW91c2x5LlxuICpcbiAqIEBwYXJhbSBjb250ZXh0IFN0eWxlc2hlZXQgcGFyc2VyIGNvbnRleHQuXG4gKiBAcGFyYW0gZXh0Q3NzRG9jIE5lZWRlZCBmb3IgY2FjaGluZyBvZiBzZWxlY3RvciBhc3QuXG4gKlxuICogQHJldHVybnMgUGFyc2VkIHZhbGlkYXRpb24gZGF0YSBmb3IgY3JvcHBlZCBwYXJ0IG9mIHN0eWxlc2hlZXQgd2hpY2ggbWF5IGJlIGEgc2VsZWN0b3IuXG4gKiBAdGhyb3dzIEFuIGVycm9yIG9uIHVuc3VwcG9ydGVkIENTUyBmZWF0dXJlcywgZS5nLiBhdC1ydWxlcy5cbiAqL1xuXG5cbmNvbnN0IHBhcnNlU2VsZWN0b3JQYXJ0ID0gKGNvbnRleHQsIGV4dENzc0RvYykgPT4ge1xuICBsZXQgc2VsZWN0b3IgPSBjb250ZXh0LnNlbGVjdG9yQnVmZmVyLnRyaW0oKTtcblxuICBpZiAoc2VsZWN0b3Iuc3RhcnRzV2l0aChBVF9SVUxFX01BUktFUikpIHtcbiAgICB0aHJvdyBuZXcgRXJyb3IoYCR7Tk9fQVRfUlVMRV9FUlJPUl9QUkVGSVh9OiAnJHtzZWxlY3Rvcn0nLmApO1xuICB9XG5cbiAgbGV0IHJlbW92ZVNlbGVjdG9yRGF0YTtcblxuICB0cnkge1xuICAgIHJlbW92ZVNlbGVjdG9yRGF0YSA9IHBhcnNlUmVtb3ZlU2VsZWN0b3Ioc2VsZWN0b3IpO1xuICB9IGNhdGNoIChlKSB7XG4gICAgbG9nZ2VyLmVycm9yKGdldEVycm9yTWVzc2FnZShlKSk7XG4gICAgdGhyb3cgbmV3IEVycm9yKGAke1JFTU9WRV9FUlJPUl9QUkVGSVguSU5WQUxJRF9SRU1PVkV9OiAnJHtzZWxlY3Rvcn0nYCk7XG4gIH1cblxuICBpZiAoY29udGV4dC5uZXh0SW5kZXggPT09IC0xKSB7XG4gICAgaWYgKHNlbGVjdG9yID09PSByZW1vdmVTZWxlY3RvckRhdGEuc2VsZWN0b3IpIHtcbiAgICAgIC8vIHJ1bGUgc2hvdWxkIGhhdmUgc3R5bGUgb3IgcHNldWRvLWNsYXNzIDpyZW1vdmUoKVxuICAgICAgdGhyb3cgbmV3IEVycm9yKGAke1NUWUxFX0VSUk9SX1BSRUZJWC5OT19TVFlMRV9PUl9SRU1PVkV9OiAnJHtjb250ZXh0LmNzc1RvUGFyc2V9J2ApO1xuICAgIH0gLy8gc3RvcCBwYXJzaW5nIGFzIHRoZXJlIGlzIG5vIHN0eWxlIGRlY2xhcmF0aW9uIGFuZCBzZWxlY3RvciBwYXJzZWQgZmluZVxuXG5cbiAgICBjb250ZXh0LmNzc1RvUGFyc2UgPSAnJztcbiAgfVxuXG4gIGxldCBzdHlsZXNPZlNlbGVjdG9yID0gW107XG4gIGxldCBzdWNjZXNzID0gZmFsc2U7XG4gIGxldCBhc3Q7XG5cbiAgdHJ5IHtcbiAgICBzZWxlY3RvciA9IHJlbW92ZVNlbGVjdG9yRGF0YS5zZWxlY3RvcjtcbiAgICBzdHlsZXNPZlNlbGVjdG9yID0gcmVtb3ZlU2VsZWN0b3JEYXRhLnN0eWxlc09mU2VsZWN0b3I7IC8vIHZhbGlkYXRlIGZvdW5kIHNlbGVjdG9yIGJ5IHBhcnNpbmcgaXQgdG8gYXN0XG4gICAgLy8gc28gaWYgaXQgaXMgaW52YWxpZCBlcnJvciB3aWxsIGJlIHRocm93blxuXG4gICAgYXN0ID0gZXh0Q3NzRG9jLmdldFNlbGVjdG9yQXN0KHNlbGVjdG9yKTtcbiAgICBzdWNjZXNzID0gdHJ1ZTtcbiAgfSBjYXRjaCAoZSkge1xuICAgIHN1Y2Nlc3MgPSBmYWxzZTtcbiAgfVxuXG4gIGlmIChjb250ZXh0Lm5leHRJbmRleCA+IDApIHtcbiAgICAvLyBzbGljZSBmb3VuZCB2YWxpZCBzZWxlY3RvciBwYXJ0IG9mZlxuICAgIC8vIGFuZCBwYXJzZSByZXN0IG9mIHN0eWxlc2hlZXQgbGF0ZXJcbiAgICBjb250ZXh0LmNzc1RvUGFyc2UgPSBjb250ZXh0LmNzc1RvUGFyc2Uuc2xpY2UoY29udGV4dC5uZXh0SW5kZXgpO1xuICB9XG5cbiAgcmV0dXJuIHtcbiAgICBzdWNjZXNzLFxuICAgIHNlbGVjdG9yLFxuICAgIGFzdCxcbiAgICBzdHlsZXNPZlNlbGVjdG9yXG4gIH07XG59O1xuLyoqXG4gKiBSZWN1cnNpdmVseSBwYXJzZXMgc3R5bGUgZGVjbGFyYXRpb24gc3RyaW5nIGludG8gYFN0eWxlYHMuXG4gKlxuICogQHBhcmFtIGNvbnRleHQgU3R5bGVzaGVldCBwYXJzZXIgY29udGV4dC5cbiAqIEBwYXJhbSBzdHlsZXMgQXJyYXkgb2Ygc3R5bGVzLlxuICpcbiAqIEB0aHJvd3MgQW4gZXJyb3Igb24gaW52YWxpZCBzdHlsZSBkZWNsYXJhdGlvbi5cbiAqIEByZXR1cm5zIEEgbnVtYmVyIGluZGV4IG9mIHRoZSBuZXh0IGB9YCBpbiBgdGhpcy5jc3NUb1BhcnNlYC5cbiAqL1xuXG5cbmNvbnN0IHBhcnNlVW50aWxDbG9zaW5nQnJhY2tldCA9IChjb250ZXh0LCBzdHlsZXMpID0+IHtcbiAgLy8gRXhwZWN0cyBcIjpcIiwgXCI7XCIsIGFuZCBcIn1cIi5cbiAgUkVHRVhQX0RFQ0xBUkFUSU9OX0RJVklERVIubGFzdEluZGV4ID0gY29udGV4dC5uZXh0SW5kZXg7XG4gIGxldCBtYXRjaCA9IFJFR0VYUF9ERUNMQVJBVElPTl9ESVZJREVSLmV4ZWMoY29udGV4dC5jc3NUb1BhcnNlKTtcblxuICBpZiAobWF0Y2ggPT09IG51bGwpIHtcbiAgICB0aHJvdyBuZXcgRXJyb3IoYCR7U1RZTEVfRVJST1JfUFJFRklYLklOVkFMSURfU1RZTEV9OiAnJHtjb250ZXh0LmNzc1RvUGFyc2V9J2ApO1xuICB9XG5cbiAgbGV0IG1hdGNoUG9zID0gbWF0Y2guaW5kZXg7XG4gIGxldCBtYXRjaGVkID0gbWF0Y2hbMF07XG5cbiAgaWYgKG1hdGNoZWQgPT09IEJSQUNLRVQuQ1VSTFkuUklHSFQpIHtcbiAgICBjb25zdCBkZWNsYXJhdGlvbkNodW5rID0gY29udGV4dC5jc3NUb1BhcnNlLnNsaWNlKGNvbnRleHQubmV4dEluZGV4LCBtYXRjaFBvcyk7XG5cbiAgICBpZiAoZGVjbGFyYXRpb25DaHVuay50cmltKCkubGVuZ3RoID09PSAwKSB7XG4gICAgICAvLyBlbXB0eSBzdHlsZSBkZWNsYXJhdGlvblxuICAgICAgLy8gZS5nLiAnZGl2IHsgfSdcbiAgICAgIGlmIChzdHlsZXMubGVuZ3RoID09PSAwKSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcihgJHtTVFlMRV9FUlJPUl9QUkVGSVguTk9fU1RZTEV9OiAnJHtjb250ZXh0LmNzc1RvUGFyc2V9J2ApO1xuICAgICAgfSAvLyBlbHNlIHZhbGlkIHN0eWxlIHBhcnNlZCBiZWZvcmUgaXRcbiAgICAgIC8vIGUuZy4gJ3sgZGlzcGxheTogbm9uZTsgfScgLS0gcG9zaXRpb24gaXMgYWZ0ZXIgJzsnXG5cbiAgICB9IGVsc2Uge1xuICAgICAgLy8gY2xvc2luZyBjdXJseSBicmFja2V0ICd9JyBpcyBtYXRjaGVkIGJlZm9yZSBjb2xvbiAnOidcbiAgICAgIC8vIHRyaW1tZWQgZGVjbGFyYXRpb25DaHVuayBpcyBub3QgYSBzcGFjZSwgYmV0d2VlbiAnOycgYW5kICd9JyxcbiAgICAgIC8vIGUuZy4gJ3Zpc2libGUgfScgaW4gc3R5bGUgJ3sgZGlzcGxheTogbm9uZTsgdmlzaWJsZSB9JyBhZnRlciBwYXJ0IGJlZm9yZSAnOycgaXMgcGFyc2VkXG4gICAgICB0aHJvdyBuZXcgRXJyb3IoYCR7U1RZTEVfRVJST1JfUFJFRklYLklOVkFMSURfU1RZTEV9OiAnJHtjb250ZXh0LmNzc1RvUGFyc2V9J2ApO1xuICAgIH1cblxuICAgIHJldHVybiBtYXRjaFBvcztcbiAgfVxuXG4gIGlmIChtYXRjaGVkID09PSBDT0xPTikge1xuICAgIGNvbnN0IGNvbG9uSW5kZXggPSBtYXRjaFBvczsgLy8gRXhwZWN0cyBcIjtcIiBhbmQgXCJ9XCIuXG5cbiAgICBSRUdFWFBfREVDTEFSQVRJT05fRU5ELmxhc3RJbmRleCA9IGNvbG9uSW5kZXg7XG4gICAgbWF0Y2ggPSBSRUdFWFBfREVDTEFSQVRJT05fRU5ELmV4ZWMoY29udGV4dC5jc3NUb1BhcnNlKTtcblxuICAgIGlmIChtYXRjaCA9PT0gbnVsbCkge1xuICAgICAgdGhyb3cgbmV3IEVycm9yKGAke1NUWUxFX0VSUk9SX1BSRUZJWC5VTkNMT1NFRF9TVFlMRX06ICcke2NvbnRleHQuY3NzVG9QYXJzZX0nYCk7XG4gICAgfVxuXG4gICAgbWF0Y2hQb3MgPSBtYXRjaC5pbmRleDtcbiAgICBtYXRjaGVkID0gbWF0Y2hbMF07IC8vIFBvcHVsYXRlcyB0aGUgYHN0eWxlTWFwYCBrZXktdmFsdWUgbWFwLlxuXG4gICAgY29uc3QgcHJvcGVydHkgPSBjb250ZXh0LmNzc1RvUGFyc2Uuc2xpY2UoY29udGV4dC5uZXh0SW5kZXgsIGNvbG9uSW5kZXgpLnRyaW0oKTtcblxuICAgIGlmIChwcm9wZXJ0eS5sZW5ndGggPT09IDApIHtcbiAgICAgIHRocm93IG5ldyBFcnJvcihgJHtTVFlMRV9FUlJPUl9QUkVGSVguTk9fUFJPUEVSVFl9OiAnJHtjb250ZXh0LmNzc1RvUGFyc2V9J2ApO1xuICAgIH1cblxuICAgIGNvbnN0IHZhbHVlID0gY29udGV4dC5jc3NUb1BhcnNlLnNsaWNlKGNvbG9uSW5kZXggKyAxLCBtYXRjaFBvcykudHJpbSgpO1xuXG4gICAgaWYgKHZhbHVlLmxlbmd0aCA9PT0gMCkge1xuICAgICAgdGhyb3cgbmV3IEVycm9yKGAke1NUWUxFX0VSUk9SX1BSRUZJWC5OT19WQUxVRX06ICcke2NvbnRleHQuY3NzVG9QYXJzZX0nYCk7XG4gICAgfVxuXG4gICAgc3R5bGVzLnB1c2goe1xuICAgICAgcHJvcGVydHksXG4gICAgICB2YWx1ZVxuICAgIH0pOyAvLyBmaW5pc2ggc3R5bGUgcGFyc2luZyBpZiAnfScgaXMgZm91bmRcbiAgICAvLyBlLmcuICd7IGRpc3BsYXk6IG5vbmUgfScgLS0gbm8gJzsnIGF0IHRoZSBlbmQgb2YgZGVjbGFyYXRpb25cblxuICAgIGlmIChtYXRjaGVkID09PSBCUkFDS0VULkNVUkxZLlJJR0hUKSB7XG4gICAgICByZXR1cm4gbWF0Y2hQb3M7XG4gICAgfVxuICB9IC8vIG1hdGNoUG9zIGlzIHRoZSBwb3NpdGlvbiBvZiB0aGUgbmV4dCAnOydcbiAgLy8gY3JvcCAnY3NzVG9QYXJzZScgYW5kIHJlLXJ1biB0aGUgbG9vcFxuXG5cbiAgY29udGV4dC5jc3NUb1BhcnNlID0gY29udGV4dC5jc3NUb1BhcnNlLnNsaWNlKG1hdGNoUG9zICsgMSk7XG4gIGNvbnRleHQubmV4dEluZGV4ID0gMDtcbiAgcmV0dXJuIHBhcnNlVW50aWxDbG9zaW5nQnJhY2tldChjb250ZXh0LCBzdHlsZXMpOyAvLyBTaG91bGQgYmUgYSBzdWJqZWN0IG9mIHRhaWwtY2FsbCBvcHRpbWl6YXRpb24uXG59O1xuLyoqXG4gKiBQYXJzZXMgbmV4dCBzdHlsZSBkZWNsYXJhdGlvbiBwYXJ0IGluIHN0eWxlc2hlZXQuXG4gKlxuICogQHBhcmFtIGNvbnRleHQgU3R5bGVzaGVldCBwYXJzZXIgY29udGV4dC5cbiAqXG4gKiBAcmV0dXJucyBBcnJheSBvZiBzdHlsZSBkYXRhIG9iamVjdHMuXG4gKi9cblxuXG5jb25zdCBwYXJzZU5leHRTdHlsZSA9IGNvbnRleHQgPT4ge1xuICBjb25zdCBzdHlsZXMgPSBbXTtcbiAgY29uc3Qgc3R5bGVFbmRQb3MgPSBwYXJzZVVudGlsQ2xvc2luZ0JyYWNrZXQoY29udGV4dCwgc3R5bGVzKTsgLy8gZmluZCBuZXh0IHJ1bGUgYWZ0ZXIgdGhlIHN0eWxlIGRlY2xhcmF0aW9uXG5cbiAgUkVHRVhQX05PTl9XSElURVNQQUNFLmxhc3RJbmRleCA9IHN0eWxlRW5kUG9zICsgMTtcbiAgY29uc3QgbWF0Y2ggPSBSRUdFWFBfTk9OX1dISVRFU1BBQ0UuZXhlYyhjb250ZXh0LmNzc1RvUGFyc2UpO1xuXG4gIGlmIChtYXRjaCA9PT0gbnVsbCkge1xuICAgIGNvbnRleHQuY3NzVG9QYXJzZSA9ICcnO1xuICAgIHJldHVybiBzdHlsZXM7XG4gIH1cblxuICBjb25zdCBtYXRjaFBvcyA9IG1hdGNoLmluZGV4OyAvLyBjdXQgb3V0IG1hdGNoZWQgc3R5bGUgZGVjbGFyYXRpb24gZm9yIHByZXZpb3VzIHNlbGVjdG9yXG5cbiAgY29udGV4dC5jc3NUb1BhcnNlID0gY29udGV4dC5jc3NUb1BhcnNlLnNsaWNlKG1hdGNoUG9zKTtcbiAgcmV0dXJuIHN0eWxlcztcbn07XG4vKipcbiAqIFBhcnNlcyBzdHlsZXNoZWV0IG9mIHJ1bGVzIGludG8gcnVsZXMgZGF0YSBvYmplY3RzIChub24tcmVjdXJzaXZlbHkpOlxuICogMS4gSXRlcmF0ZXMgdGhyb3VnaCBzdHlsZXNoZWV0IHN0cmluZy5cbiAqIDIuIEZpbmRzIGZpcnN0IGB7YCB3aGljaCBjYW4gYmUgc3R5bGUgZGVjbGFyYXRpb24gc3RhcnQgb3IgcGFydCBvZiBzZWxlY3Rvci5cbiAqIDMuIFZhbGlkYXRlcyBmb3VuZCBzdHJpbmcgcGFydCB2aWEgc2VsZWN0b3IgcGFyc2VyOyBhbmQgaWY6XG4gKiAgLSBpdCB0aHJvd3MgZXJyb3Ig4oCUIHNhdmVzIHN0cmluZyBwYXJ0IHRvIGJ1ZmZlciBhcyBwYXJ0IG9mIHNlbGVjdG9yLFxuICogICAgc2xpY2UgbmV4dCBzdHlsZXNoZWV0IHBhcnQgdG8gYHtgIFsyXSBhbmQgdmFsaWRhdGVzIGFnYWluIFszXTtcbiAqICAtIG5vIGVycm9yIOKAlCBzYXZlcyBmb3VuZCBzdHJpbmcgcGFydCBhcyBzZWxlY3RvciBhbmQgc3RhcnRzIHRvIHBhcnNlIHN0eWxlcyAocmVjdXJzaXZlbHkpLlxuICpcbiAqIEBwYXJhbSByYXdTdHlsZXNoZWV0IFJhdyBzdHlsZXNoZWV0IGFzIHN0cmluZy5cbiAqIEBwYXJhbSBleHRDc3NEb2MgRXh0Q3NzRG9jdW1lbnQgd2hpY2ggdXNlcyBjYWNoZSB3aGlsZSBzZWxlY3RvcnMgcGFyc2luZy5cbiAqIEB0aHJvd3MgQW4gZXJyb3Igb24gdW5zdXBwb3J0ZWQgQ1NTIGZlYXR1cmVzLCBlLmcuIGNvbW1lbnRzIG9yIGludmFsaWQgc3R5bGVzaGVldCBzeW50YXguXG4gKiBAcmV0dXJucyBBcnJheSBvZiBydWxlcyBkYXRhIHdoaWNoIGNvbnRhaW5zOlxuICogLSBzZWxlY3RvciBhcyBzdHJpbmc7XG4gKiAtIGFzdCB0byBxdWVyeSBlbGVtZW50cyBieTtcbiAqIC0gbWFwIG9mIHN0eWxlcyB0byBhcHBseS5cbiAqL1xuXG5cbmNvbnN0IHBhcnNlU3R5bGVzaGVldCA9IChyYXdTdHlsZXNoZWV0LCBleHRDc3NEb2MpID0+IHtcbiAgY29uc3Qgc3R5bGVzaGVldCA9IHJhd1N0eWxlc2hlZXQudHJpbSgpO1xuXG4gIGlmIChzdHlsZXNoZWV0LmluY2x1ZGVzKGAke1NMQVNIfSR7QVNURVJJU0t9YCkgJiYgc3R5bGVzaGVldC5pbmNsdWRlcyhgJHtBU1RFUklTS30ke1NMQVNIfWApKSB7XG4gICAgdGhyb3cgbmV3IEVycm9yKGAke1NUWUxFX0VSUk9SX1BSRUZJWC5OT19DT01NRU5UfSBpbiBzdHlsZXNoZWV0OiAnJHtzdHlsZXNoZWV0fSdgKTtcbiAgfVxuXG4gIGNvbnN0IGNvbnRleHQgPSB7XG4gICAgLy8gYW55IHN0eWxlc2hlZXQgc2hvdWxkIHN0YXJ0IHdpdGggc2VsZWN0b3JcbiAgICBpc1NlbGVjdG9yOiB0cnVlLFxuICAgIC8vIGluaXQgdmFsdWUgb2YgcGFyc2VyIHBvc2l0aW9uXG4gICAgbmV4dEluZGV4OiAwLFxuICAgIC8vIGluaXQgdmFsdWUgb2YgY3NzVG9QYXJzZVxuICAgIGNzc1RvUGFyc2U6IHN0eWxlc2hlZXQsXG4gICAgLy8gYnVmZmVyIGZvciBjb2xsZWN0aW5nIHNlbGVjdG9yIHBhcnRcbiAgICBzZWxlY3RvckJ1ZmZlcjogJycsXG4gICAgLy8gYWNjdW11bGF0b3IgZm9yIHJ1bGVzXG4gICAgcmF3UnVsZURhdGE6IHtcbiAgICAgIHNlbGVjdG9yOiAnJ1xuICAgIH1cbiAgfTtcbiAgY29uc3QgcmF3UmVzdWx0cyA9IGNyZWF0ZVJhd1Jlc3VsdHNNYXAoKTtcbiAgbGV0IHNlbGVjdG9yRGF0YTsgLy8gY29udGV4dC5jc3NUb1BhcnNlIGlzIGdvaW5nIHRvIGJlIGNyb3BwZWQgd2hpbGUgaXRzIHBhcnNpbmdcblxuICB3aGlsZSAoY29udGV4dC5jc3NUb1BhcnNlKSB7XG4gICAgaWYgKGNvbnRleHQuaXNTZWxlY3Rvcikge1xuICAgICAgLy8gZmluZCBpbmRleCBvZiBmaXJzdCBvcGVuaW5nIGN1cmx5IGJyYWNrZXRcbiAgICAgIC8vIHdoaWNoIG1heSBtZWFuIHN0YXJ0IG9mIHN0eWxlIHBhcnQgYW5kIGVuZCBvZiBzZWxlY3RvciBvbmVcbiAgICAgIGNvbnRleHQubmV4dEluZGV4ID0gY29udGV4dC5jc3NUb1BhcnNlLmluZGV4T2YoQlJBQ0tFVC5DVVJMWS5MRUZUKTsgLy8gcnVsZSBzaG91bGQgbm90IHN0YXJ0IHdpdGggc3R5bGUsIHNlbGVjdG9yIGlzIHJlcXVpcmVkXG4gICAgICAvLyBlLmcuICd7IGRpc3BsYXk6IG5vbmU7IH0nXG5cbiAgICAgIGlmIChjb250ZXh0LnNlbGVjdG9yQnVmZmVyLmxlbmd0aCA9PT0gMCAmJiBjb250ZXh0Lm5leHRJbmRleCA9PT0gMCkge1xuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoYCR7U1RZTEVfRVJST1JfUFJFRklYLk5PX1NFTEVDVE9SfTogJyR7Y29udGV4dC5jc3NUb1BhcnNlfSdgKTtcbiAgICAgIH1cblxuICAgICAgaWYgKGNvbnRleHQubmV4dEluZGV4ID09PSAtMSkge1xuICAgICAgICAvLyBubyBzdHlsZSBkZWNsYXJhdGlvbiBpbiBydWxlXG4gICAgICAgIC8vIGJ1dCBydWxlIHN0aWxsIG1heSBjb250YWluIDpyZW1vdmUoKSBwc2V1ZG8tY2xhc3NcbiAgICAgICAgY29udGV4dC5zZWxlY3RvckJ1ZmZlciA9IGNvbnRleHQuY3NzVG9QYXJzZTtcbiAgICAgIH0gZWxzZSB7XG4gICAgICAgIC8vIGNvbGxlY3Qgc3RyaW5nIHBhcnRzIGJlZm9yZSBvcGVuaW5nIGN1cmx5IGJyYWNrZXRcbiAgICAgICAgLy8gdW50aWwgdmFsaWQgc2VsZWN0b3IgY29sbGVjdGVkXG4gICAgICAgIGNvbnRleHQuc2VsZWN0b3JCdWZmZXIgKz0gY29udGV4dC5jc3NUb1BhcnNlLnNsaWNlKDAsIGNvbnRleHQubmV4dEluZGV4KTtcbiAgICAgIH1cblxuICAgICAgc2VsZWN0b3JEYXRhID0gcGFyc2VTZWxlY3RvclBhcnQoY29udGV4dCwgZXh0Q3NzRG9jKTtcblxuICAgICAgaWYgKHNlbGVjdG9yRGF0YS5zdWNjZXNzKSB7XG4gICAgICAgIC8vIHNlbGVjdG9yIHN1Y2Nlc3NmdWxseSBwYXJzZWRcbiAgICAgICAgY29udGV4dC5yYXdSdWxlRGF0YS5zZWxlY3RvciA9IHNlbGVjdG9yRGF0YS5zZWxlY3Rvci50cmltKCk7XG4gICAgICAgIGNvbnRleHQucmF3UnVsZURhdGEuYXN0ID0gc2VsZWN0b3JEYXRhLmFzdDtcbiAgICAgICAgY29udGV4dC5yYXdSdWxlRGF0YS5yYXdTdHlsZXMgPSBzZWxlY3RvckRhdGEuc3R5bGVzT2ZTZWxlY3RvcjtcbiAgICAgICAgY29udGV4dC5pc1NlbGVjdG9yID0gZmFsc2U7IC8vIHNhdmUgcnVsZSBkYXRhIGlmIHRoZXJlIGlzIG5vIHN0eWxlIGRlY2xhcmF0aW9uXG5cbiAgICAgICAgaWYgKGNvbnRleHQubmV4dEluZGV4ID09PSAtMSkge1xuICAgICAgICAgIHNhdmVUb1Jhd1Jlc3VsdHMocmF3UmVzdWx0cywgY29udGV4dC5yYXdSdWxlRGF0YSk7IC8vIGNsZWFuIHVwIHJ1bGVDb250ZXh0XG5cbiAgICAgICAgICByZXN0b3JlUnVsZUFjYyhjb250ZXh0KTtcbiAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAvLyBza2lwIHRoZSBvcGVuaW5nIGN1cmx5IGJyYWNrZXQgYXQgdGhlIHN0YXJ0IG9mIHN0eWxlIGRlY2xhcmF0aW9uIHBhcnRcbiAgICAgICAgICBjb250ZXh0Lm5leHRJbmRleCA9IDE7XG4gICAgICAgICAgY29udGV4dC5zZWxlY3RvckJ1ZmZlciA9ICcnO1xuICAgICAgICB9XG4gICAgICB9IGVsc2Uge1xuICAgICAgICAvLyBpZiBzZWxlY3RvciB3YXMgbm90IHN1Y2Nlc3NmdWxseSBwYXJzZWQgcGFyc2VTZWxlY3RvclBhcnQoKSwgY29udGludWUgc3R5bGVzaGVldCBwYXJzaW5nOlxuICAgICAgICAvLyBzYXZlIHRoZSBmb3VuZCBicmFja2V0IHRvIGJ1ZmZlciBhbmQgcHJvY2VlZCB0byBuZXh0IGxvb3AgaXRlcmF0aW9uXG4gICAgICAgIGNvbnRleHQuc2VsZWN0b3JCdWZmZXIgKz0gQlJBQ0tFVC5DVVJMWS5MRUZUOyAvLyBkZWxldGUgYHtgIGZyb20gY3NzVG9QYXJzZVxuXG4gICAgICAgIGNvbnRleHQuY3NzVG9QYXJzZSA9IGNvbnRleHQuY3NzVG9QYXJzZS5zbGljZSgxKTtcbiAgICAgIH1cbiAgICB9IGVsc2Uge1xuICAgICAgdmFyIF9jb250ZXh0JHJhd1J1bGVEYXRhJDtcblxuICAgICAgLy8gc3R5bGUgZGVjbGFyYXRpb24gc2hvdWxkIGJlIHBhcnNlZFxuICAgICAgY29uc3QgcGFyc2VkU3R5bGVzID0gcGFyc2VOZXh0U3R5bGUoY29udGV4dCk7IC8vIHN0eWxlcyBjYW4gYmUgcGFyc2VkIGZyb20gc2VsZWN0b3IgcGFydCBpZiBpdCBoYXMgOnJlbW92ZSgpIHBzZXVkby1jbGFzc1xuICAgICAgLy8gZS5nLiAnLmJhbm5lcjpyZW1vdmUoKSB7IGRlYnVnOiB0cnVlOyB9J1xuXG4gICAgICAoX2NvbnRleHQkcmF3UnVsZURhdGEkID0gY29udGV4dC5yYXdSdWxlRGF0YS5yYXdTdHlsZXMpID09PSBudWxsIHx8IF9jb250ZXh0JHJhd1J1bGVEYXRhJCA9PT0gdm9pZCAwID8gdm9pZCAwIDogX2NvbnRleHQkcmF3UnVsZURhdGEkLnB1c2goLi4ucGFyc2VkU3R5bGVzKTsgLy8gc2F2ZSBydWxlIGRhdGEgdG8gcmVzdWx0c1xuXG4gICAgICBzYXZlVG9SYXdSZXN1bHRzKHJhd1Jlc3VsdHMsIGNvbnRleHQucmF3UnVsZURhdGEpO1xuICAgICAgY29udGV4dC5uZXh0SW5kZXggPSAwOyAvLyBjbGVhbiB1cCBydWxlQ29udGV4dFxuXG4gICAgICByZXN0b3JlUnVsZUFjYyhjb250ZXh0KTsgLy8gcGFyc2UgbmV4dCBydWxlIHNlbGVjdG9yIGFmdGVyIHN0eWxlIHN1Y2Nlc3NmdWxseSBwYXJzZWRcblxuICAgICAgY29udGV4dC5pc1NlbGVjdG9yID0gdHJ1ZTtcbiAgICB9XG4gIH1cblxuICByZXR1cm4gY29tYmluZVJ1bGVzRGF0YShyYXdSZXN1bHRzKTtcbn07XG5cbi8qKlxuICogQ2hlY2tzIHdoZXRoZXIgcGFzc2VkIGBhcmdgIGlzIG51bWJlciB0eXBlLlxuICpcbiAqIEBwYXJhbSBhcmcgVmFsdWUgdG8gY2hlY2suXG4gKlxuICogQHJldHVybnMgVHJ1ZSBpZiBgYXJnYCBpcyBudW1iZXIgYW5kIG5vdCBOYU4uXG4gKi9cbmNvbnN0IGlzTnVtYmVyID0gYXJnID0+IHtcbiAgcmV0dXJuIHR5cGVvZiBhcmcgPT09ICdudW1iZXInICYmICFOdW1iZXIuaXNOYU4oYXJnKTtcbn07XG5cbmNvbnN0IGlzU3VwcG9ydGVkID0gdHlwZW9mIHdpbmRvdy5yZXF1ZXN0QW5pbWF0aW9uRnJhbWUgIT09ICd1bmRlZmluZWQnO1xuY29uc3QgdGltZW91dCA9IGlzU3VwcG9ydGVkID8gcmVxdWVzdEFuaW1hdGlvbkZyYW1lIDogd2luZG93LnNldFRpbWVvdXQ7XG5jb25zdCBkZWxldGVUaW1lb3V0ID0gaXNTdXBwb3J0ZWQgPyBjYW5jZWxBbmltYXRpb25GcmFtZSA6IGNsZWFyVGltZW91dDtcbmNvbnN0IHBlcmYgPSBpc1N1cHBvcnRlZCA/IHBlcmZvcm1hbmNlIDogRGF0ZTtcbmNvbnN0IERFRkFVTFRfVEhST1RUTEVfREVMQVlfTVMgPSAxNTA7XG5cbi8qKlxuICogVGhlIHB1cnBvc2Ugb2YgVGhyb3R0bGVXcmFwcGVyIGlzIHRvIHRocm90dGxlIGNhbGxzIG9mIHRoZSBmdW5jdGlvblxuICogdGhhdCBhcHBsaWVzIEV4dGVuZGVkQ3NzIHJ1bGVzLiBUaGUgcmVhc29uaW5nIGhlcmUgaXMgdGhhdCB0aGUgZnVuY3Rpb24gY2FsbHNcbiAqIGFyZSB0cmlnZ2VyZWQgYnkgTXV0YXRpb25PYnNlcnZlciBhbmQgdGhlcmUgbWF5IGJlIG1hbnkgbXV0YXRpb25zIGluIGEgc2hvcnQgcGVyaW9kIG9mIHRpbWUuXG4gKiBXZSBkbyBub3Qgd2FudCB0byBhcHBseSBydWxlcyBvbiBldmVyeSBtdXRhdGlvbiBzbyB3ZSB1c2UgdGhpcyBoZWxwZXIgdG8gbWFrZSBzdXJlXG4gKiB0aGF0IHRoZXJlIGlzIG9ubHkgb25lIGNhbGwgaW4gdGhlIGdpdmVuIGFtb3VudCBvZiB0aW1lLlxuICovXG5jbGFzcyBUaHJvdHRsZVdyYXBwZXIge1xuICAvKipcbiAgICogVGhlIHByb3ZpZGVkIGNhbGxiYWNrIHNob3VsZCBiZSBleGVjdXRlZCB0d2ljZSBpbiB0aGlzIHRpbWUgZnJhbWU6XG4gICAqIHZlcnkgZmlyc3QgdGltZSBhbmQgbm90IG1vcmUgb2Z0ZW4gdGhhbiB0aHJvdHRsZURlbGF5TXMgZm9yIGZ1cnRoZXIgZXhlY3V0aW9ucy5cbiAgICpcbiAgICogQHNlZSB7QGxpbmsgVGhyb3R0bGVXcmFwcGVyLnJ1bn1cbiAgICovXG5cbiAgLyoqXG4gICAqIENyZWF0ZXMgbmV3IFRocm90dGxlV3JhcHBlci5cbiAgICpcbiAgICogQHBhcmFtIGNvbnRleHQgRXh0ZW5kZWRDc3MgY29udGV4dC5cbiAgICogQHBhcmFtIGNhbGxiYWNrIFRoZSBjYWxsYmFjay5cbiAgICogQHBhcmFtIHRocm90dGxlTXMgVGhyb3R0bGUgZGVsYXkgaW4gbXMuXG4gICAqL1xuICBjb25zdHJ1Y3Rvcihjb250ZXh0LCBjYWxsYmFjaywgdGhyb3R0bGVNcykge1xuICAgIHRoaXMuY29udGV4dCA9IGNvbnRleHQ7XG4gICAgdGhpcy5jYWxsYmFjayA9IGNhbGxiYWNrO1xuICAgIHRoaXMudGhyb3R0bGVEZWxheU1zID0gdGhyb3R0bGVNcyB8fCBERUZBVUxUX1RIUk9UVExFX0RFTEFZX01TO1xuICAgIHRoaXMud3JhcHBlZENiID0gdGhpcy53cmFwcGVkQ2FsbGJhY2suYmluZCh0aGlzKTtcbiAgfVxuICAvKipcbiAgICogV3JhcHMgdGhlIGNhbGxiYWNrICh3aGljaCBzdXBwb3NlZCB0byBiZSBgYXBwbHlSdWxlc2ApLFxuICAgKiBuZWVkZWQgdG8gdXBkYXRlIGBsYXN0UnVuVGltZWAgYW5kIGNsZWFuIHByZXZpb3VzIHRpbWVvdXRzIGZvciBwcm9wZXIgZXhlY3V0aW9uIG9mIHRoZSBjYWxsYmFjay5cbiAgICpcbiAgICogQHBhcmFtIHRpbWVzdGFtcCBUaW1lc3RhbXAuXG4gICAqL1xuXG5cbiAgd3JhcHBlZENhbGxiYWNrKHRpbWVzdGFtcCkge1xuICAgIHRoaXMubGFzdFJ1blRpbWUgPSBpc051bWJlcih0aW1lc3RhbXApID8gdGltZXN0YW1wIDogcGVyZi5ub3coKTsgLy8gYHRpbWVvdXRJZGAgY2FuIGJlIHJlcXVlc3RBbmltYXRpb25GcmFtZS1yZWxhdGVkXG4gICAgLy8gc28gY2FuY2VsQW5pbWF0aW9uRnJhbWUoKSBhcyBkZWxldGVUaW1lb3V0KCkgbmVlZHMgdGhlIGFyZyB0byBiZSBkZWZpbmVkXG5cbiAgICBpZiAodGhpcy50aW1lb3V0SWQpIHtcbiAgICAgIGRlbGV0ZVRpbWVvdXQodGhpcy50aW1lb3V0SWQpO1xuICAgICAgZGVsZXRlIHRoaXMudGltZW91dElkO1xuICAgIH1cblxuICAgIGNsZWFyVGltZW91dCh0aGlzLnRpbWVySWQpO1xuICAgIGRlbGV0ZSB0aGlzLnRpbWVySWQ7XG5cbiAgICBpZiAodGhpcy5jYWxsYmFjaykge1xuICAgICAgdGhpcy5jYWxsYmFjayh0aGlzLmNvbnRleHQpO1xuICAgIH1cbiAgfVxuICAvKipcbiAgICogSW5kaWNhdGVzIHdoZXRoZXIgdGhlcmUgaXMgYSBzY2hlZHVsZWQgY2FsbGJhY2suXG4gICAqXG4gICAqIEByZXR1cm5zIFRydWUgaWYgc2NoZWR1bGVkIGNhbGxiYWNrIGV4aXN0cy5cbiAgICovXG5cblxuICBoYXNQZW5kaW5nQ2FsbGJhY2soKSB7XG4gICAgcmV0dXJuIGlzTnVtYmVyKHRoaXMudGltZW91dElkKSB8fCBpc051bWJlcih0aGlzLnRpbWVySWQpO1xuICB9XG4gIC8qKlxuICAgKiBTY2hlZHVsZXMgdGhlIGZ1bmN0aW9uIHdoaWNoIGFwcGxpZXMgRXh0ZW5kZWRDc3MgcnVsZXMgYmVmb3JlIHRoZSBuZXh0IGFuaW1hdGlvbiBmcmFtZS5cbiAgICpcbiAgICogV3JhcHMgZnVuY3Rpb24gZXhlY3V0aW9uIGludG8gYHRpbWVvdXRgIOKAlCByZXF1ZXN0QW5pbWF0aW9uRnJhbWUgb3Igc2V0VGltZW91dC5cbiAgICogRm9yIHRoZSBmaXJzdCB0aW1lIHJ1bnMgdGhlIGZ1bmN0aW9uIHdpdGhvdXQgYW55IGNvbmRpdGlvbi5cbiAgICogQXMgaXQgbWF5IGJlIHRyaWdnZXJlZCBieSBhbnkgbXV0YXRpb24gd2hpY2ggbWF5IG9jY3VyIHRvbyBvZnRlciwgd2UgbGltaXQgdGhlIGZ1bmN0aW9uIGV4ZWN1dGlvbjpcbiAgICogMS4gSWYgYGVsYXBzZWRUaW1lYCBzaW5jZSBsYXN0IGZ1bmN0aW9uIGV4ZWN1dGlvbiBpcyBsZXNzIHRoZW4gc2V0IGB0aHJvdHRsZURlbGF5TXNgLFxuICAgKiBuZXh0IGZ1bmN0aW9uIGNhbGwgaXMgaG9sZCB0aWxsIHRoZSBlbmQgb2YgdGhyb3R0bGUgaW50ZXJ2YWwgKHN1YnRyYWN0aW5nIGBlbGFwc2VkYCBmcm9tIGB0aHJvdHRsZURlbGF5TXNgKTtcbiAgICogMi4gRG8gbm90aGluZyBpZiB0cmlnZ2VyZWQgYWdhaW4gYnV0IGZ1bmN0aW9uIGNhbGwgd2hpY2ggaXMgb24gaG9sZCBoYXMgbm90IHlldCBzdGFydGVkIGl0cyBleGVjdXRpb24uXG4gICAqL1xuXG5cbiAgcnVuKCkge1xuICAgIGlmICh0aGlzLmhhc1BlbmRpbmdDYWxsYmFjaygpKSB7XG4gICAgICAvLyB0aGVyZSBpcyBhIHBlbmRpbmcgZXhlY3V0aW9uIHNjaGVkdWxlZFxuICAgICAgcmV0dXJuO1xuICAgIH1cblxuICAgIGlmICh0eXBlb2YgdGhpcy5sYXN0UnVuVGltZSAhPT0gJ3VuZGVmaW5lZCcpIHtcbiAgICAgIGNvbnN0IGVsYXBzZWRUaW1lID0gcGVyZi5ub3coKSAtIHRoaXMubGFzdFJ1blRpbWU7XG5cbiAgICAgIGlmIChlbGFwc2VkVGltZSA8IHRoaXMudGhyb3R0bGVEZWxheU1zKSB7XG4gICAgICAgIHRoaXMudGltZXJJZCA9IHdpbmRvdy5zZXRUaW1lb3V0KHRoaXMud3JhcHBlZENiLCB0aGlzLnRocm90dGxlRGVsYXlNcyAtIGVsYXBzZWRUaW1lKTtcbiAgICAgICAgcmV0dXJuO1xuICAgICAgfVxuICAgIH1cblxuICAgIHRoaXMudGltZW91dElkID0gdGltZW91dCh0aGlzLndyYXBwZWRDYik7XG4gIH1cbiAgLyoqXG4gICAqIFJldHVybnMgdGltZXN0YW1wIGZvciAnbm93Jy5cbiAgICpcbiAgICogQHJldHVybnMgVGltZXN0YW1wLlxuICAgKi9cblxuXG4gIHN0YXRpYyBub3coKSB7XG4gICAgcmV0dXJuIHBlcmYubm93KCk7XG4gIH1cblxufVxuXG5jb25zdCBMQVNUX0VWRU5UX1RJTUVPVVRfTVMgPSAxMDtcbmNvbnN0IElHTk9SRURfRVZFTlRTID0gWydtb3VzZW92ZXInLCAnbW91c2VsZWF2ZScsICdtb3VzZWVudGVyJywgJ21vdXNlb3V0J107XG5jb25zdCBTVVBQT1JURURfRVZFTlRTID0gWy8vIGtleWJvYXJkIGV2ZW50c1xuJ2tleWRvd24nLCAna2V5cHJlc3MnLCAna2V5dXAnLCAvLyBtb3VzZSBldmVudHNcbidhdXhjbGljaycsICdjbGljaycsICdjb250ZXh0bWVudScsICdkYmxjbGljaycsICdtb3VzZWRvd24nLCAnbW91c2VlbnRlcicsICdtb3VzZWxlYXZlJywgJ21vdXNlbW92ZScsICdtb3VzZW92ZXInLCAnbW91c2VvdXQnLCAnbW91c2V1cCcsICdwb2ludGVybG9ja2NoYW5nZScsICdwb2ludGVybG9ja2Vycm9yJywgJ3NlbGVjdCcsICd3aGVlbCddOyAvLyAnd2hlZWwnIGV2ZW50IG1ha2VzIHNjcm9sbGluZyBpbiBTYWZhcmkgdHdpdGNoeVxuLy8gaHR0cHM6Ly9naXRodWIuY29tL0FkZ3VhcmRUZWFtL0V4dGVuZGVkQ3NzL2lzc3Vlcy8xMjBcblxuY29uc3QgU0FGQVJJX1BST0JMRU1BVElDX0VWRU5UUyA9IFsnd2hlZWwnXTtcbi8qKlxuICogV2UgdXNlIEV2ZW50VHJhY2tlciB0byB0cmFjayB0aGUgZXZlbnQgdGhhdCBpcyBsaWtlbHkgdG8gY2F1c2UgdGhlIG11dGF0aW9uLlxuICogVGhlIHByb2JsZW0gaXMgdGhhdCB3ZSBjYW5ub3QgdXNlIGB3aW5kb3cuZXZlbnRgIGRpcmVjdGx5IGZyb20gdGhlIG11dGF0aW9uIG9ic2VydmVyIGNhbGxcbiAqIGFzIHdlJ3JlIG5vdCBpbiB0aGUgZXZlbnQgaGFuZGxlciBjb250ZXh0IGFueW1vcmUuXG4gKi9cblxuY2xhc3MgRXZlbnRUcmFja2VyIHtcbiAgLyoqXG4gICAqIENyZWF0ZXMgbmV3IEV2ZW50VHJhY2tlci5cbiAgICovXG4gIGNvbnN0cnVjdG9yKCkge1xuICAgIF9kZWZpbmVQcm9wZXJ0eSh0aGlzLCBcImdldExhc3RFdmVudFR5cGVcIiwgKCkgPT4gdGhpcy5sYXN0RXZlbnRUeXBlKTtcblxuICAgIF9kZWZpbmVQcm9wZXJ0eSh0aGlzLCBcImdldFRpbWVTaW5jZUxhc3RFdmVudFwiLCAoKSA9PiB7XG4gICAgICBpZiAoIXRoaXMubGFzdEV2ZW50VGltZSkge1xuICAgICAgICByZXR1cm4gbnVsbDtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIERhdGUubm93KCkgLSB0aGlzLmxhc3RFdmVudFRpbWU7XG4gICAgfSk7XG5cbiAgICB0aGlzLnRyYWNrZWRFdmVudHMgPSBpc1NhZmFyaUJyb3dzZXIgPyBTVVBQT1JURURfRVZFTlRTLmZpbHRlcihldmVudCA9PiAhU0FGQVJJX1BST0JMRU1BVElDX0VWRU5UUy5pbmNsdWRlcyhldmVudCkpIDogU1VQUE9SVEVEX0VWRU5UUztcbiAgICB0aGlzLnRyYWNrZWRFdmVudHMuZm9yRWFjaChldmVudE5hbWUgPT4ge1xuICAgICAgZG9jdW1lbnQuZG9jdW1lbnRFbGVtZW50LmFkZEV2ZW50TGlzdGVuZXIoZXZlbnROYW1lLCB0aGlzLnRyYWNrRXZlbnQsIHRydWUpO1xuICAgIH0pO1xuICB9XG4gIC8qKlxuICAgKiBDYWxsYmFjayBmb3IgZXZlbnQgbGlzdGVuZXIgZm9yIGV2ZW50cyB0cmFja2luZy5cbiAgICpcbiAgICogQHBhcmFtIGV2ZW50IEFueSBldmVudC5cbiAgICovXG5cblxuICB0cmFja0V2ZW50KGV2ZW50KSB7XG4gICAgdGhpcy5sYXN0RXZlbnRUeXBlID0gZXZlbnQudHlwZTtcbiAgICB0aGlzLmxhc3RFdmVudFRpbWUgPSBEYXRlLm5vdygpO1xuICB9XG5cbiAgLyoqXG4gICAqIENoZWNrcyB3aGV0aGVyIHRoZSBsYXN0IGNhdWdodCBldmVudCBzaG91bGQgYmUgaWdub3JlZC5cbiAgICpcbiAgICogQHJldHVybnMgVHJ1ZSBpZiBldmVudCBzaG91bGQgYmUgaWdub3JlZC5cbiAgICovXG4gIGlzSWdub3JlZEV2ZW50VHlwZSgpIHtcbiAgICBjb25zdCBsYXN0RXZlbnRUeXBlID0gdGhpcy5nZXRMYXN0RXZlbnRUeXBlKCk7XG4gICAgY29uc3Qgc2luY2VMYXN0RXZlbnRUaW1lID0gdGhpcy5nZXRUaW1lU2luY2VMYXN0RXZlbnQoKTtcbiAgICByZXR1cm4gISFsYXN0RXZlbnRUeXBlICYmIElHTk9SRURfRVZFTlRTLmluY2x1ZGVzKGxhc3RFdmVudFR5cGUpICYmICEhc2luY2VMYXN0RXZlbnRUaW1lICYmIHNpbmNlTGFzdEV2ZW50VGltZSA8IExBU1RfRVZFTlRfVElNRU9VVF9NUztcbiAgfVxuICAvKipcbiAgICogU3RvcHMgZXZlbnQgdHJhY2tpbmcgYnkgcmVtb3ZpbmcgZXZlbnQgbGlzdGVuZXIuXG4gICAqL1xuXG5cbiAgc3RvcFRyYWNraW5nKCkge1xuICAgIHRoaXMudHJhY2tlZEV2ZW50cy5mb3JFYWNoKGV2ZW50TmFtZSA9PiB7XG4gICAgICBkb2N1bWVudC5kb2N1bWVudEVsZW1lbnQucmVtb3ZlRXZlbnRMaXN0ZW5lcihldmVudE5hbWUsIHRoaXMudHJhY2tFdmVudCwgdHJ1ZSk7XG4gICAgfSk7XG4gIH1cblxufVxuXG5jb25zdCBpc0V2ZW50TGlzdGVuZXJTdXBwb3J0ZWQgPSB0eXBlb2Ygd2luZG93LmFkZEV2ZW50TGlzdGVuZXIgIT09ICd1bmRlZmluZWQnO1xuXG5jb25zdCBvYnNlcnZlRG9jdW1lbnQgPSAoY29udGV4dCwgY2FsbGJhY2spID0+IHtcbiAgLy8gV2UgYXJlIHRyeWluZyB0byBsaW1pdCB0aGUgbnVtYmVyIG9mIGNhbGxiYWNrIGNhbGxzIGJ5IG5vdCBjYWxsaW5nIGl0IG9uIGFsbCBraW5kIG9mIFwiaG92ZXJcIiBldmVudHMuXG4gIC8vIFRoZSByYXRpb25hbGUgYmVoaW5kIHRoaXMgaXMgdGhhdCBcImhvdmVyXCIgZXZlbnRzIG9mdGVuIGNhdXNlIGF0dHJpYnV0ZXMgbW9kaWZpY2F0aW9uLFxuICAvLyBidXQgcmUtYXBwbHlpbmcgZXh0Q1NTIHJ1bGVzIHdpbGwgYmUgdXNlbGVzcyBhcyB0aGVzZSBhdHRyaWJ1dGUgY2hhbmdlcyBhcmUgdXN1YWxseSB0cmFuc2llbnQuXG4gIGNvbnN0IHNob3VsZElnbm9yZU11dGF0aW9ucyA9IG11dGF0aW9ucyA9PiB7XG4gICAgLy8gaWdub3JlIGlmIGFsbCBtdXRhdGlvbnMgYXJlIGFib3V0IGF0dHJpYnV0ZXMgY2hhbmdlc1xuICAgIHJldHVybiBtdXRhdGlvbnMuZXZlcnkobSA9PiBtLnR5cGUgPT09ICdhdHRyaWJ1dGVzJyk7XG4gIH07XG5cbiAgaWYgKG5hdGl2ZXMuTXV0YXRpb25PYnNlcnZlcikge1xuICAgIGNvbnRleHQuZG9tTXV0YXRpb25PYnNlcnZlciA9IG5ldyBuYXRpdmVzLk11dGF0aW9uT2JzZXJ2ZXIobXV0YXRpb25zID0+IHtcbiAgICAgIGlmICghbXV0YXRpb25zIHx8IG11dGF0aW9ucy5sZW5ndGggPT09IDApIHtcbiAgICAgICAgcmV0dXJuO1xuICAgICAgfVxuXG4gICAgICBjb25zdCBldmVudFRyYWNrZXIgPSBuZXcgRXZlbnRUcmFja2VyKCk7XG5cbiAgICAgIGlmIChldmVudFRyYWNrZXIuaXNJZ25vcmVkRXZlbnRUeXBlKCkgJiYgc2hvdWxkSWdub3JlTXV0YXRpb25zKG11dGF0aW9ucykpIHtcbiAgICAgICAgcmV0dXJuO1xuICAgICAgfSAvLyBzYXZlIGluc3RhbmNlIG9mIEV2ZW50VHJhY2tlciB0byBjb250ZXh0XG4gICAgICAvLyBmb3IgcmVtb3ZpbmcgaXRzIGV2ZW50IGxpc3RlbmVycyBvbiBkaXNjb25uZWN0RG9jdW1lbnQoKSB3aGlsZSBtYWluRGlzY29ubmVjdCgpXG5cblxuICAgICAgY29udGV4dC5ldmVudFRyYWNrZXIgPSBldmVudFRyYWNrZXI7XG4gICAgICBjYWxsYmFjaygpO1xuICAgIH0pO1xuICAgIGNvbnRleHQuZG9tTXV0YXRpb25PYnNlcnZlci5vYnNlcnZlKGRvY3VtZW50LCB7XG4gICAgICBjaGlsZExpc3Q6IHRydWUsXG4gICAgICBzdWJ0cmVlOiB0cnVlLFxuICAgICAgYXR0cmlidXRlczogdHJ1ZSxcbiAgICAgIGF0dHJpYnV0ZUZpbHRlcjogWydpZCcsICdjbGFzcyddXG4gICAgfSk7XG4gIH0gZWxzZSBpZiAoaXNFdmVudExpc3RlbmVyU3VwcG9ydGVkKSB7XG4gICAgZG9jdW1lbnQuYWRkRXZlbnRMaXN0ZW5lcignRE9NTm9kZUluc2VydGVkJywgY2FsbGJhY2ssIGZhbHNlKTtcbiAgICBkb2N1bWVudC5hZGRFdmVudExpc3RlbmVyKCdET01Ob2RlUmVtb3ZlZCcsIGNhbGxiYWNrLCBmYWxzZSk7XG4gICAgZG9jdW1lbnQuYWRkRXZlbnRMaXN0ZW5lcignRE9NQXR0ck1vZGlmaWVkJywgY2FsbGJhY2ssIGZhbHNlKTtcbiAgfVxufTtcblxuY29uc3QgZGlzY29ubmVjdERvY3VtZW50ID0gKGNvbnRleHQsIGNhbGxiYWNrKSA9PiB7XG4gIHZhciBfY29udGV4dCRldmVudFRyYWNrZXI7XG5cbiAgaWYgKGNvbnRleHQuZG9tTXV0YXRpb25PYnNlcnZlcikge1xuICAgIGNvbnRleHQuZG9tTXV0YXRpb25PYnNlcnZlci5kaXNjb25uZWN0KCk7XG4gIH0gZWxzZSBpZiAoaXNFdmVudExpc3RlbmVyU3VwcG9ydGVkKSB7XG4gICAgZG9jdW1lbnQucmVtb3ZlRXZlbnRMaXN0ZW5lcignRE9NTm9kZUluc2VydGVkJywgY2FsbGJhY2ssIGZhbHNlKTtcbiAgICBkb2N1bWVudC5yZW1vdmVFdmVudExpc3RlbmVyKCdET01Ob2RlUmVtb3ZlZCcsIGNhbGxiYWNrLCBmYWxzZSk7XG4gICAgZG9jdW1lbnQucmVtb3ZlRXZlbnRMaXN0ZW5lcignRE9NQXR0ck1vZGlmaWVkJywgY2FsbGJhY2ssIGZhbHNlKTtcbiAgfSAvLyBjbGVhbiB1cCBldmVudCBsaXN0ZW5lcnNcblxuXG4gIChfY29udGV4dCRldmVudFRyYWNrZXIgPSBjb250ZXh0LmV2ZW50VHJhY2tlcikgPT09IG51bGwgfHwgX2NvbnRleHQkZXZlbnRUcmFja2VyID09PSB2b2lkIDAgPyB2b2lkIDAgOiBfY29udGV4dCRldmVudFRyYWNrZXIuc3RvcFRyYWNraW5nKCk7XG59O1xuXG5jb25zdCBtYWluT2JzZXJ2ZSA9IChjb250ZXh0LCBtYWluQ2FsbGJhY2spID0+IHtcbiAgaWYgKGNvbnRleHQuaXNEb21PYnNlcnZlZCkge1xuICAgIHJldHVybjtcbiAgfSAvLyBoYW5kbGUgZHluYW1pY2FsbHkgYWRkZWQgZWxlbWVudHNcblxuXG4gIGNvbnRleHQuaXNEb21PYnNlcnZlZCA9IHRydWU7XG4gIG9ic2VydmVEb2N1bWVudChjb250ZXh0LCBtYWluQ2FsbGJhY2spO1xufTtcbmNvbnN0IG1haW5EaXNjb25uZWN0ID0gKGNvbnRleHQsIG1haW5DYWxsYmFjaykgPT4ge1xuICBpZiAoIWNvbnRleHQuaXNEb21PYnNlcnZlZCkge1xuICAgIHJldHVybjtcbiAgfVxuXG4gIGNvbnRleHQuaXNEb21PYnNlcnZlZCA9IGZhbHNlO1xuICBkaXNjb25uZWN0RG9jdW1lbnQoY29udGV4dCwgbWFpbkNhbGxiYWNrKTtcbn07XG5cbmNvbnN0IENPTlRFTlRfQVRUUl9QUkVGSVhfUkVHRVhQID0gL14oXCJ8JylhZGd1YXJkLis/Lztcbi8qKlxuICogUmVtb3ZlcyBhZmZlY3RlZEVsZW1lbnQubm9kZSBmcm9tIERPTS5cbiAqXG4gKiBAcGFyYW0gY29udGV4dCBFeHRlbmRlZENzcyBjb250ZXh0LlxuICogQHBhcmFtIGFmZmVjdGVkRWxlbWVudCBBZmZlY3RlZCBlbGVtZW50LlxuICovXG5cbmNvbnN0IHJlbW92ZUVsZW1lbnQgPSAoY29udGV4dCwgYWZmZWN0ZWRFbGVtZW50KSA9PiB7XG4gIGNvbnN0IHtcbiAgICBub2RlXG4gIH0gPSBhZmZlY3RlZEVsZW1lbnQ7XG4gIGFmZmVjdGVkRWxlbWVudC5yZW1vdmVkID0gdHJ1ZTtcbiAgY29uc3QgZWxlbWVudFNlbGVjdG9yID0gZ2V0RWxlbWVudFNlbGVjdG9yUGF0aChub2RlKTsgLy8gY2hlY2sgaWYgdGhlIGVsZW1lbnQgaGFzIGJlZW4gYWxyZWFkeSByZW1vdmVkIGVhcmxpZXJcblxuICBjb25zdCBlbGVtZW50UmVtb3ZhbHNDb3VudGVyID0gY29udGV4dC5yZW1vdmFsc1N0YXRpc3RpY1tlbGVtZW50U2VsZWN0b3JdIHx8IDA7IC8vIGlmIHJlbW92YWxzIGF0dGVtcHRzIGhhcHBlbmVkIG1vcmUgdGhhbiBzcGVjaWZpZWQgd2UgZG8gbm90IHRyeSB0byByZW1vdmUgbm9kZSBhZ2FpblxuXG4gIGlmIChlbGVtZW50UmVtb3ZhbHNDb3VudGVyID4gTUFYX1NUWUxFX1BST1RFQ1RJT05fQ09VTlQpIHtcbiAgICBsb2dnZXIuZXJyb3IoYEV4dGVuZGVkQ3NzOiBpbmZpbml0ZSBsb29wIHByb3RlY3Rpb24gZm9yIHNlbGVjdG9yOiAnJHtlbGVtZW50U2VsZWN0b3J9J2ApO1xuICAgIHJldHVybjtcbiAgfVxuXG4gIGlmIChub2RlLnBhcmVudEVsZW1lbnQpIHtcbiAgICBub2RlLnBhcmVudEVsZW1lbnQucmVtb3ZlQ2hpbGQobm9kZSk7XG4gICAgY29udGV4dC5yZW1vdmFsc1N0YXRpc3RpY1tlbGVtZW50U2VsZWN0b3JdID0gZWxlbWVudFJlbW92YWxzQ291bnRlciArIDE7XG4gIH1cbn07XG4vKipcbiAqIFNldHMgc3R5bGUgdG8gdGhlIHNwZWNpZmllZCBET00gbm9kZS5cbiAqXG4gKiBAcGFyYW0gbm9kZSBET00gZWxlbWVudC5cbiAqIEBwYXJhbSBzdHlsZSBTdHlsZSB0byBzZXQuXG4gKi9cblxuXG5jb25zdCBzZXRTdHlsZVRvRWxlbWVudCA9IChub2RlLCBzdHlsZSkgPT4ge1xuICBpZiAoIShub2RlIGluc3RhbmNlb2YgSFRNTEVsZW1lbnQpKSB7XG4gICAgcmV0dXJuO1xuICB9XG5cbiAgT2JqZWN0LmtleXMoc3R5bGUpLmZvckVhY2gocHJvcCA9PiB7XG4gICAgLy8gQXBwbHkgdGhpcyBzdHlsZSBvbmx5IHRvIGV4aXN0aW5nIHByb3BlcnRpZXNcbiAgICAvLyBXZSBjYW5ub3QgdXNlIGhhc093blByb3BlcnR5IGhlcmUgKGRvZXMgbm90IHdvcmsgaW4gRkYpXG4gICAgaWYgKHR5cGVvZiBub2RlLnN0eWxlLmdldFByb3BlcnR5VmFsdWUocHJvcC50b1N0cmluZygpKSAhPT0gJ3VuZGVmaW5lZCcpIHtcbiAgICAgIGxldCB2YWx1ZSA9IHN0eWxlW3Byb3BdO1xuXG4gICAgICBpZiAoIXZhbHVlKSB7XG4gICAgICAgIHJldHVybjtcbiAgICAgIH0gLy8gZG8gbm90IGFwcGx5ICdjb250ZW50JyBzdHlsZSBnaXZlbiBieSB0c3VybGZpbHRlclxuICAgICAgLy8gd2hpY2ggaXMgbmVlZGVkIG9ubHkgZm9yIEJlZm9yZVN0eWxlQXBwbGllZENhbGxiYWNrXG5cblxuICAgICAgaWYgKHByb3AgPT09IENPTlRFTlRfQ1NTX1BST1BFUlRZICYmIHZhbHVlLm1hdGNoKENPTlRFTlRfQVRUUl9QUkVGSVhfUkVHRVhQKSkge1xuICAgICAgICByZXR1cm47XG4gICAgICB9IC8vIEZpcnN0IHdlIHNob3VsZCByZW1vdmUgIWltcG9ydGFudCBhdHRyaWJ1dGUgKG9yIGl0IHdvbid0IGJlIGFwcGxpZWQnKVxuXG5cbiAgICAgIHZhbHVlID0gcmVtb3ZlU3VmZml4KHZhbHVlLnRyaW0oKSwgJyFpbXBvcnRhbnQnKS50cmltKCk7XG4gICAgICBub2RlLnN0eWxlLnNldFByb3BlcnR5KHByb3AsIHZhbHVlLCAnaW1wb3J0YW50Jyk7XG4gICAgfVxuICB9KTtcbn07XG4vKipcbiAqIENoZWNrcyB0aGUgcmVxdWlyZWQgcHJvcGVydGllcyBvZiBgYWZmZWN0ZWRFbGVtZW50YFxuICogKipiZWZvcmUqKiBgYmVmb3JlU3R5bGVBcHBsaWVkKClgIGV4ZWN1dGlvbi5cbiAqXG4gKiBAcGFyYW0gYWZmZWN0ZWRFbGVtZW50IEFmZmVjdGVkIGVsZW1lbnQuXG4gKlxuICogQHJldHVybnMgRmFsc2UgaWYgdGhlcmUgaXMgbm8gYG5vZGVgIG9yIGBydWxlc2BcbiAqIG9yIGBydWxlc2AgaXMgbm90IGFuIGFycmF5LlxuICovXG5cbmNvbnN0IGlzSUFmZmVjdGVkRWxlbWVudCA9IGFmZmVjdGVkRWxlbWVudCA9PiB7XG4gIHJldHVybiAnbm9kZScgaW4gYWZmZWN0ZWRFbGVtZW50ICYmICdydWxlcycgaW4gYWZmZWN0ZWRFbGVtZW50ICYmIGFmZmVjdGVkRWxlbWVudC5ydWxlcyBpbnN0YW5jZW9mIEFycmF5O1xufTtcbi8qKlxuICogQ2hlY2tzIHRoZSByZXF1aXJlZCBwcm9wZXJ0aWVzIG9mIGBhZmZlY3RlZEVsZW1lbnRgXG4gKiAqKmFmdGVyKiogYGJlZm9yZVN0eWxlQXBwbGllZCgpYCBleGVjdXRpb24uXG4gKiBUaGVzZSBwcm9wZXJ0aWVzIGFyZSBuZWVkZWQgZm9yIHByb3BlciBpbnRlcm5hbCB1c2FnZS5cbiAqXG4gKiBAcGFyYW0gYWZmZWN0ZWRFbGVtZW50IEFmZmVjdGVkIGVsZW1lbnQuXG4gKlxuICogQHJldHVybnMgRmFsc2UgaWYgdGhlcmUgaXMgbm8gYG5vZGVgIG9yIGBydWxlc2BcbiAqIG9yIGBydWxlc2AgaXMgbm90IGFuIGFycmF5LlxuICovXG5cblxuY29uc3QgaXNBZmZlY3RlZEVsZW1lbnQgPSBhZmZlY3RlZEVsZW1lbnQgPT4ge1xuICByZXR1cm4gJ25vZGUnIGluIGFmZmVjdGVkRWxlbWVudCAmJiAnb3JpZ2luYWxTdHlsZScgaW4gYWZmZWN0ZWRFbGVtZW50ICYmICdydWxlcycgaW4gYWZmZWN0ZWRFbGVtZW50ICYmIGFmZmVjdGVkRWxlbWVudC5ydWxlcyBpbnN0YW5jZW9mIEFycmF5O1xufTtcbi8qKlxuICogQXBwbGllcyBzdHlsZSB0byB0aGUgc3BlY2lmaWVkIERPTSBub2RlLlxuICpcbiAqIEBwYXJhbSBjb250ZXh0IEV4dGVuZGVkQ3NzIGNvbnRleHQuXG4gKiBAcGFyYW0gcmF3QWZmZWN0ZWRFbGVtZW50IE9iamVjdCBjb250YWluaW5nIERPTSBub2RlIGFuZCBydWxlIHRvIGJlIGFwcGxpZWQuXG4gKlxuICogQHRocm93cyBBbiBlcnJvciBpZiBhZmZlY3RlZEVsZW1lbnQgaGFzIG5vIHN0eWxlIHRvIGFwcGx5LlxuICovXG5cblxuY29uc3QgYXBwbHlTdHlsZSA9IChjb250ZXh0LCByYXdBZmZlY3RlZEVsZW1lbnQpID0+IHtcbiAgaWYgKHJhd0FmZmVjdGVkRWxlbWVudC5wcm90ZWN0aW9uT2JzZXJ2ZXIpIHtcbiAgICAvLyBzdHlsZSBpcyBhbHJlYWR5IGFwcGxpZWQgYW5kIHByb3RlY3RlZCBieSB0aGUgb2JzZXJ2ZXJcbiAgICByZXR1cm47XG4gIH1cblxuICBsZXQgYWZmZWN0ZWRFbGVtZW50O1xuXG4gIGlmIChjb250ZXh0LmJlZm9yZVN0eWxlQXBwbGllZCkge1xuICAgIGlmICghaXNJQWZmZWN0ZWRFbGVtZW50KHJhd0FmZmVjdGVkRWxlbWVudCkpIHtcbiAgICAgIHRocm93IG5ldyBFcnJvcihcIlJldHVybmVkIElBZmZlY3RlZEVsZW1lbnQgc2hvdWxkIGhhdmUgJ25vZGUnIGFuZCAncnVsZXMnIHByb3BlcnRpZXNcIik7XG4gICAgfVxuXG4gICAgYWZmZWN0ZWRFbGVtZW50ID0gY29udGV4dC5iZWZvcmVTdHlsZUFwcGxpZWQocmF3QWZmZWN0ZWRFbGVtZW50KTtcblxuICAgIGlmICghYWZmZWN0ZWRFbGVtZW50KSB7XG4gICAgICB0aHJvdyBuZXcgRXJyb3IoXCJDYWxsYmFjayAnYmVmb3JlU3R5bGVBcHBsaWVkJyBzaG91bGQgcmV0dXJuIElBZmZlY3RlZEVsZW1lbnRcIik7XG4gICAgfVxuICB9IGVsc2Uge1xuICAgIGFmZmVjdGVkRWxlbWVudCA9IHJhd0FmZmVjdGVkRWxlbWVudDtcbiAgfVxuXG4gIGlmICghaXNBZmZlY3RlZEVsZW1lbnQoYWZmZWN0ZWRFbGVtZW50KSkge1xuICAgIHRocm93IG5ldyBFcnJvcihcIlJldHVybmVkIElBZmZlY3RlZEVsZW1lbnQgc2hvdWxkIGhhdmUgJ25vZGUnIGFuZCAncnVsZXMnIHByb3BlcnRpZXNcIik7XG4gIH1cblxuICBjb25zdCB7XG4gICAgbm9kZSxcbiAgICBydWxlc1xuICB9ID0gYWZmZWN0ZWRFbGVtZW50O1xuXG4gIGZvciAobGV0IGkgPSAwOyBpIDwgcnVsZXMubGVuZ3RoOyBpICs9IDEpIHtcbiAgICBjb25zdCBydWxlID0gcnVsZXNbaV07XG4gICAgY29uc3Qgc2VsZWN0b3IgPSBydWxlID09PSBudWxsIHx8IHJ1bGUgPT09IHZvaWQgMCA/IHZvaWQgMCA6IHJ1bGUuc2VsZWN0b3I7XG4gICAgY29uc3Qgc3R5bGUgPSBydWxlID09PSBudWxsIHx8IHJ1bGUgPT09IHZvaWQgMCA/IHZvaWQgMCA6IHJ1bGUuc3R5bGU7XG4gICAgY29uc3QgZGVidWcgPSBydWxlID09PSBudWxsIHx8IHJ1bGUgPT09IHZvaWQgMCA/IHZvaWQgMCA6IHJ1bGUuZGVidWc7IC8vIHJ1bGUgbWF5IG5vdCBoYXZlIHN0eWxlIHRvIGFwcGx5XG4gICAgLy8gZS5nLiAnZGl2Omhhcyg+IGEpIHsgZGVidWc6IHRydWUgfScgLT4gbWVhbnMgbm8gc3R5bGUgdG8gYXBwbHksIGFuZCBlbmFibGUgZGVidWcgbW9kZVxuXG4gICAgaWYgKHN0eWxlKSB7XG4gICAgICBpZiAoc3R5bGVbUkVNT1ZFX1BTRVVET19NQVJLRVJdID09PSBQU0VVRE9fUFJPUEVSVFlfUE9TSVRJVkVfVkFMVUUpIHtcbiAgICAgICAgcmVtb3ZlRWxlbWVudChjb250ZXh0LCBhZmZlY3RlZEVsZW1lbnQpO1xuICAgICAgICByZXR1cm47XG4gICAgICB9XG5cbiAgICAgIHNldFN0eWxlVG9FbGVtZW50KG5vZGUsIHN0eWxlKTtcbiAgICB9IGVsc2UgaWYgKCFkZWJ1Zykge1xuICAgICAgLy8gYnV0IHJ1bGUgc2hvdWxkIG5vdCBoYXZlIGJvdGggc3R5bGUgYW5kIGRlYnVnIHByb3BlcnRpZXNcbiAgICAgIHRocm93IG5ldyBFcnJvcihgTm8gc3R5bGUgZGVjbGFyYXRpb24gaW4gcnVsZSBmb3Igc2VsZWN0b3I6ICcke3NlbGVjdG9yfSdgKTtcbiAgICB9XG4gIH1cbn07XG4vKipcbiAqIFJldmVydHMgc3R5bGUgZm9yIHRoZSBhZmZlY3RlZCBvYmplY3QuXG4gKlxuICogQHBhcmFtIGFmZmVjdGVkRWxlbWVudCBBZmZlY3RlZCBlbGVtZW50LlxuICovXG5cbmNvbnN0IHJldmVydFN0eWxlID0gYWZmZWN0ZWRFbGVtZW50ID0+IHtcbiAgaWYgKGFmZmVjdGVkRWxlbWVudC5wcm90ZWN0aW9uT2JzZXJ2ZXIpIHtcbiAgICBhZmZlY3RlZEVsZW1lbnQucHJvdGVjdGlvbk9ic2VydmVyLmRpc2Nvbm5lY3QoKTtcbiAgfVxuXG4gIGFmZmVjdGVkRWxlbWVudC5ub2RlLnN0eWxlLmNzc1RleHQgPSBhZmZlY3RlZEVsZW1lbnQub3JpZ2luYWxTdHlsZTtcbn07XG5cbi8qKlxuICogRXh0TXV0YXRpb25PYnNlcnZlciBpcyBhIHdyYXBwZXIgb3ZlciByZWd1bGFyIE11dGF0aW9uT2JzZXJ2ZXIgd2l0aCBvbmUgYWRkaXRpb25hbCBmdW5jdGlvbjpcbiAqIGl0IGtlZXBzIHRyYWNrIG9mIHRoZSBudW1iZXIgb2YgdGltZXMgd2UgY2FsbGVkIHRoZSBcIlByb3RlY3Rpb25DYWxsYmFja1wiLlxuICpcbiAqIFdlIHVzZSBhbiBpbnN0YW5jZSBvZiB0aGlzIHRvIG1vbml0b3Igc3R5bGVzIGFkZGVkIGJ5IEV4dGVuZGVkQ3NzXG4gKiBhbmQgdG8gbWFrZSBzdXJlIHRoZXNlIHN0eWxlcyBhcmUgcmVjb3ZlcmVkIGlmIHRoZSBwYWdlIHNjcmlwdCBhdHRlbXB0cyB0byBtb2RpZnkgdGhlbS5cbiAqXG4gKiBIb3dldmVyLCB3ZSB3YW50IHRvIGF2b2lkIGVuZGxlc3MgbG9vcHMgb2YgbW9kaWZpY2F0aW9uIGlmIHRoZSBwYWdlIHNjcmlwdCByZXBlYXRlZGx5IG1vZGlmaWVzIHRoZSBzdHlsZXMuXG4gKiBTbyB3ZSBrZWVwIHRyYWNrIG9mIHRoZSBudW1iZXIgb2YgY2FsbHMgYW5kIG9ic2VydmUoKSBtYWtlcyBhIGRlY2lzaW9uXG4gKiB3aGV0aGVyIHRvIGNvbnRpbnVlIHJlY292ZXJpbmcgdGhlIHN0eWxlcyBvciBub3QuXG4gKi9cblxuY2xhc3MgRXh0TXV0YXRpb25PYnNlcnZlciB7XG4gIC8qKlxuICAgKiBFeHRyYSBwcm9wZXJ0eSBmb3Iga2VlcGluZyAnc3R5bGUgZml4IGNvdW50cycuXG4gICAqL1xuXG4gIC8qKlxuICAgKiBDcmVhdGVzIG5ldyBFeHRNdXRhdGlvbk9ic2VydmVyLlxuICAgKlxuICAgKiBAcGFyYW0gcHJvdGVjdGlvbkNhbGxiYWNrIENhbGxiYWNrIHdoaWNoIGV4ZWN1dGlvbiBzaG91bGQgYmUgY291bnRlZC5cbiAgICovXG4gIGNvbnN0cnVjdG9yKHByb3RlY3Rpb25DYWxsYmFjaykge1xuICAgIHRoaXMuc3R5bGVQcm90ZWN0aW9uQ291bnQgPSAwO1xuICAgIHRoaXMub2JzZXJ2ZXIgPSBuZXcgbmF0aXZlcy5NdXRhdGlvbk9ic2VydmVyKG11dGF0aW9ucyA9PiB7XG4gICAgICBpZiAoIW11dGF0aW9ucy5sZW5ndGgpIHtcbiAgICAgICAgcmV0dXJuO1xuICAgICAgfVxuXG4gICAgICB0aGlzLnN0eWxlUHJvdGVjdGlvbkNvdW50ICs9IDE7XG4gICAgICBwcm90ZWN0aW9uQ2FsbGJhY2sobXV0YXRpb25zLCB0aGlzKTtcbiAgICB9KTtcbiAgfVxuICAvKipcbiAgICogU3RhcnRzIHRvIG9ic2VydmUgdGFyZ2V0IGVsZW1lbnQsXG4gICAqIHByZXZlbnRzIGluZmluaXRlIGxvb3Agb2Ygb2JzZXJ2aW5nIGR1ZSB0byB0aGUgbGltaXRlZCBudW1iZXIgb2YgdGltZXMgb2YgY2FsbGJhY2sgcnVucy5cbiAgICpcbiAgICogQHBhcmFtIHRhcmdldCBUYXJnZXQgdG8gb2JzZXJ2ZS5cbiAgICogQHBhcmFtIG9wdGlvbnMgTXV0YXRpb24gb2JzZXJ2ZXIgb3B0aW9ucy5cbiAgICovXG5cblxuICBvYnNlcnZlKHRhcmdldCwgb3B0aW9ucykge1xuICAgIGlmICh0aGlzLnN0eWxlUHJvdGVjdGlvbkNvdW50IDwgTUFYX1NUWUxFX1BST1RFQ1RJT05fQ09VTlQpIHtcbiAgICAgIHRoaXMub2JzZXJ2ZXIub2JzZXJ2ZSh0YXJnZXQsIG9wdGlvbnMpO1xuICAgIH0gZWxzZSB7XG4gICAgICBsb2dnZXIuZXJyb3IoJ0V4dGVuZGVkQ3NzOiBpbmZpbml0ZSBsb29wIHByb3RlY3Rpb24gZm9yIHN0eWxlJyk7XG4gICAgfVxuICB9XG4gIC8qKlxuICAgKiBTdG9wcyBFeHRNdXRhdGlvbk9ic2VydmVyIGZyb20gb2JzZXJ2aW5nIGFueSBtdXRhdGlvbnMuXG4gICAqIFVudGlsIHRoZSBgb2JzZXJ2ZSgpYCBpcyB1c2VkIGFnYWluLCBgcHJvdGVjdGlvbkNhbGxiYWNrYCB3aWxsIG5vdCBiZSBpbnZva2VkLlxuICAgKi9cblxuXG4gIGRpc2Nvbm5lY3QoKSB7XG4gICAgdGhpcy5vYnNlcnZlci5kaXNjb25uZWN0KCk7XG4gIH1cblxufVxuXG5jb25zdCBQUk9URUNUSU9OX09CU0VSVkVSX09QVElPTlMgPSB7XG4gIGF0dHJpYnV0ZXM6IHRydWUsXG4gIGF0dHJpYnV0ZU9sZFZhbHVlOiB0cnVlLFxuICBhdHRyaWJ1dGVGaWx0ZXI6IFsnc3R5bGUnXVxufTtcbi8qKlxuICogQ3JlYXRlcyBNdXRhdGlvbk9ic2VydmVyIHByb3RlY3Rpb24gY2FsbGJhY2suXG4gKlxuICogQHBhcmFtIHN0eWxlcyBTdHlsZXMgZGF0YSBvYmplY3QuXG4gKlxuICogQHJldHVybnMgQ2FsbGJhY2sgZm9yIHN0eWxlcyBwcm90ZWN0aW9uLlxuICovXG5cbmNvbnN0IGNyZWF0ZVByb3RlY3Rpb25DYWxsYmFjayA9IHN0eWxlcyA9PiB7XG4gIGNvbnN0IHByb3RlY3Rpb25DYWxsYmFjayA9IChtdXRhdGlvbnMsIGV4dE9ic2VydmVyKSA9PiB7XG4gICAgaWYgKCFtdXRhdGlvbnNbMF0pIHtcbiAgICAgIHJldHVybjtcbiAgICB9XG5cbiAgICBjb25zdCB7XG4gICAgICB0YXJnZXRcbiAgICB9ID0gbXV0YXRpb25zWzBdO1xuICAgIGV4dE9ic2VydmVyLmRpc2Nvbm5lY3QoKTtcbiAgICBzdHlsZXMuZm9yRWFjaChzdHlsZSA9PiB7XG4gICAgICBzZXRTdHlsZVRvRWxlbWVudCh0YXJnZXQsIHN0eWxlKTtcbiAgICB9KTtcbiAgICBleHRPYnNlcnZlci5vYnNlcnZlKHRhcmdldCwgUFJPVEVDVElPTl9PQlNFUlZFUl9PUFRJT05TKTtcbiAgfTtcblxuICByZXR1cm4gcHJvdGVjdGlvbkNhbGxiYWNrO1xufTtcbi8qKlxuICogU2V0cyB1cCBhIE11dGF0aW9uT2JzZXJ2ZXIgd2hpY2ggcHJvdGVjdHMgc3R5bGUgYXR0cmlidXRlcyBmcm9tIGNoYW5nZXMuXG4gKlxuICogQHBhcmFtIG5vZGUgRE9NIG5vZGUuXG4gKiBAcGFyYW0gcnVsZXMgUnVsZSBkYXRhIG9iamVjdHMuXG4gKiBAcmV0dXJucyBNdXRhdGlvbiBvYnNlcnZlciB1c2VkIHRvIHByb3RlY3QgYXR0cmlidXRlIG9yIG51bGwgaWYgdGhlcmUncyBub3RoaW5nIHRvIHByb3RlY3QuXG4gKi9cblxuXG5jb25zdCBwcm90ZWN0U3R5bGVBdHRyaWJ1dGUgPSAobm9kZSwgcnVsZXMpID0+IHtcbiAgaWYgKCFuYXRpdmVzLk11dGF0aW9uT2JzZXJ2ZXIpIHtcbiAgICByZXR1cm4gbnVsbDtcbiAgfVxuXG4gIGNvbnN0IHN0eWxlcyA9IFtdO1xuICBydWxlcy5mb3JFYWNoKHJ1bGVEYXRhID0+IHtcbiAgICBjb25zdCB7XG4gICAgICBzdHlsZVxuICAgIH0gPSBydWxlRGF0YTsgLy8gc29tZSBydWxlcyBtaWdodCBoYXZlIG9ubHkgZGVidWcgcHJvcGVydHkgaW4gc3R5bGUgZGVjbGFyYXRpb25cbiAgICAvLyBlLmcuICdkaXY6aGFzKD4gYSkgeyBkZWJ1ZzogdHJ1ZSB9JyAtPiBwYXJzZWQgdG8gYm9vbGVhbiBgcnVsZURhdGEuZGVidWdgXG4gICAgLy8gc28gbm8gc3R5bGUgaXMgZmluZSwgYW5kIGhlcmUgd2Ugc2hvdWxkIGNvbGxlY3Qgb25seSB2YWxpZCBzdHlsZXMgdG8gcHJvdGVjdFxuXG4gICAgaWYgKHN0eWxlKSB7XG4gICAgICBzdHlsZXMucHVzaChzdHlsZSk7XG4gICAgfVxuICB9KTtcbiAgY29uc3QgcHJvdGVjdGlvbk9ic2VydmVyID0gbmV3IEV4dE11dGF0aW9uT2JzZXJ2ZXIoY3JlYXRlUHJvdGVjdGlvbkNhbGxiYWNrKHN0eWxlcykpO1xuICBwcm90ZWN0aW9uT2JzZXJ2ZXIub2JzZXJ2ZShub2RlLCBQUk9URUNUSU9OX09CU0VSVkVSX09QVElPTlMpO1xuICByZXR1cm4gcHJvdGVjdGlvbk9ic2VydmVyO1xufTtcblxuY29uc3QgU1RBVFNfREVDSU1BTF9ESUdJVFNfQ09VTlQgPSA0O1xuXG4vKipcbiAqIEEgaGVscGVyIGNsYXNzIGZvciBhcHBsaWVkIHJ1bGUgc3RhdHMuXG4gKi9cbmNsYXNzIFRpbWluZ1N0YXRzIHtcbiAgLyoqXG4gICAqIENyZWF0ZXMgbmV3IFRpbWluZ1N0YXRzLlxuICAgKi9cbiAgY29uc3RydWN0b3IoKSB7XG4gICAgdGhpcy5hcHBsaWVzVGltaW5ncyA9IFtdO1xuICAgIHRoaXMuYXBwbGllc0NvdW50ID0gMDtcbiAgICB0aGlzLnRpbWluZ3NTdW0gPSAwO1xuICAgIHRoaXMubWVhblRpbWluZyA9IDA7XG4gICAgdGhpcy5zcXVhcmVkU3VtID0gMDtcbiAgICB0aGlzLnN0YW5kYXJkRGV2aWF0aW9uID0gMDtcbiAgfVxuICAvKipcbiAgICogT2JzZXJ2ZSB0YXJnZXQgZWxlbWVudCBhbmQgbWFyayBvYnNlcnZlciBhcyBhY3RpdmUuXG4gICAqXG4gICAqIEBwYXJhbSBlbGFwc2VkVGltZU1zIFRpbWUgaW4gbXMuXG4gICAqL1xuXG5cbiAgcHVzaChlbGFwc2VkVGltZU1zKSB7XG4gICAgdGhpcy5hcHBsaWVzVGltaW5ncy5wdXNoKGVsYXBzZWRUaW1lTXMpO1xuICAgIHRoaXMuYXBwbGllc0NvdW50ICs9IDE7XG4gICAgdGhpcy50aW1pbmdzU3VtICs9IGVsYXBzZWRUaW1lTXM7XG4gICAgdGhpcy5tZWFuVGltaW5nID0gdGhpcy50aW1pbmdzU3VtIC8gdGhpcy5hcHBsaWVzQ291bnQ7XG4gICAgdGhpcy5zcXVhcmVkU3VtICs9IGVsYXBzZWRUaW1lTXMgKiBlbGFwc2VkVGltZU1zO1xuICAgIHRoaXMuc3RhbmRhcmREZXZpYXRpb24gPSBNYXRoLnNxcnQodGhpcy5zcXVhcmVkU3VtIC8gdGhpcy5hcHBsaWVzQ291bnQgLSBNYXRoLnBvdyh0aGlzLm1lYW5UaW1pbmcsIDIpKTtcbiAgfVxuXG59XG5cbi8qKlxuICogTWFrZXMgdGhlIHRpbWVzdGFtcHMgbW9yZSByZWFkYWJsZS5cbiAqXG4gKiBAcGFyYW0gdGltZXN0YW1wIFJhdyB0aW1lc3RhbXAuXG4gKlxuICogQHJldHVybnMgRmluZS1sb29raW5nIHRpbWVzdGFtcHMuXG4gKi9cbmNvbnN0IGJlYXV0aWZ5VGltaW5nTnVtYmVyID0gdGltZXN0YW1wID0+IHtcbiAgcmV0dXJuIE51bWJlcih0aW1lc3RhbXAudG9GaXhlZChTVEFUU19ERUNJTUFMX0RJR0lUU19DT1VOVCkpO1xufTtcbi8qKlxuICogSW1wcm92ZXMgdGltaW5nIHN0YXRzIHJlYWRhYmlsaXR5LlxuICpcbiAqIEBwYXJhbSByYXdUaW1pbmdzIENvbGxlY3RlZCB0aW1pbmdzIHdpdGggcmF3IHRpbWVzdGFtcC5cbiAqXG4gKiBAcmV0dXJucyBGaW5lLWxvb2tpbmcgdGltaW5nIHN0YXRzLlxuICovXG5cblxuY29uc3QgYmVhdXRpZnlUaW1pbmdzID0gcmF3VGltaW5ncyA9PiB7XG4gIHJldHVybiB7XG4gICAgYXBwbGllc1RpbWluZ3M6IHJhd1RpbWluZ3MuYXBwbGllc1RpbWluZ3MubWFwKHQgPT4gYmVhdXRpZnlUaW1pbmdOdW1iZXIodCkpLFxuICAgIGFwcGxpZXNDb3VudDogYmVhdXRpZnlUaW1pbmdOdW1iZXIocmF3VGltaW5ncy5hcHBsaWVzQ291bnQpLFxuICAgIHRpbWluZ3NTdW06IGJlYXV0aWZ5VGltaW5nTnVtYmVyKHJhd1RpbWluZ3MudGltaW5nc1N1bSksXG4gICAgbWVhblRpbWluZzogYmVhdXRpZnlUaW1pbmdOdW1iZXIocmF3VGltaW5ncy5tZWFuVGltaW5nKSxcbiAgICBzdGFuZGFyZERldmlhdGlvbjogYmVhdXRpZnlUaW1pbmdOdW1iZXIocmF3VGltaW5ncy5zdGFuZGFyZERldmlhdGlvbilcbiAgfTtcbn07XG4vKipcbiAqIFByaW50cyB0aW1pbmcgaW5mb3JtYXRpb24gaWYgZGVidWdnaW5nIG1vZGUgaXMgZW5hYmxlZC5cbiAqXG4gKiBAcGFyYW0gY29udGV4dCBFeHRlbmRlZENzcyBjb250ZXh0LlxuICovXG5cblxuY29uc3QgcHJpbnRUaW1pbmdJbmZvID0gY29udGV4dCA9PiB7XG4gIGlmIChjb250ZXh0LmFyZVRpbWluZ3NQcmludGVkKSB7XG4gICAgcmV0dXJuO1xuICB9XG5cbiAgY29udGV4dC5hcmVUaW1pbmdzUHJpbnRlZCA9IHRydWU7XG4gIGNvbnN0IHRpbWluZ3NMb2dEYXRhID0ge307XG4gIGNvbnRleHQucGFyc2VkUnVsZXMuZm9yRWFjaChydWxlRGF0YSA9PiB7XG4gICAgaWYgKHJ1bGVEYXRhLnRpbWluZ1N0YXRzKSB7XG4gICAgICBjb25zdCB7XG4gICAgICAgIHNlbGVjdG9yLFxuICAgICAgICBzdHlsZSxcbiAgICAgICAgZGVidWcsXG4gICAgICAgIG1hdGNoZWRFbGVtZW50c1xuICAgICAgfSA9IHJ1bGVEYXRhOyAvLyBzdHlsZSBkZWNsYXJhdGlvbiBmb3Igc29tZSBydWxlcyBpcyBwYXJzZWQgdG8gZGVidWcgcHJvcGVydHkgYW5kIG5vIHN0eWxlIHRvIGFwcGx5XG4gICAgICAvLyBlLmcuICdkaXY6aGFzKD4gYSkgeyBkZWJ1ZzogdHJ1ZSB9J1xuXG4gICAgICBpZiAoIXN0eWxlICYmICFkZWJ1Zykge1xuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoYFJ1bGUgc2hvdWxkIGhhdmUgc3R5bGUgZGVjbGFyYXRpb24gZm9yIHNlbGVjdG9yOiAnJHtzZWxlY3Rvcn0nYCk7XG4gICAgICB9XG5cbiAgICAgIGNvbnN0IHNlbGVjdG9yRGF0YSA9IHtcbiAgICAgICAgc2VsZWN0b3JQYXJzZWQ6IHNlbGVjdG9yLFxuICAgICAgICB0aW1pbmdzOiBiZWF1dGlmeVRpbWluZ3MocnVsZURhdGEudGltaW5nU3RhdHMpXG4gICAgICB9OyAvLyBgcnVsZURhdGEuc3R5bGVgIG1heSBjb250YWluIGByZW1vdmVgIHBzZXVkby1wcm9wZXJ0eVxuICAgICAgLy8gYW5kIG1ha2UgbG9ncyBsb29rIGJldHRlclxuXG4gICAgICBpZiAoc3R5bGUgJiYgc3R5bGVbUkVNT1ZFX1BTRVVET19NQVJLRVJdID09PSBQU0VVRE9fUFJPUEVSVFlfUE9TSVRJVkVfVkFMVUUpIHtcbiAgICAgICAgc2VsZWN0b3JEYXRhLnJlbW92ZWQgPSB0cnVlOyAvLyBubyBtYXRjaGVkRWxlbWVudHMgZm9yIHN1Y2ggY2FzZSBhcyB0aGV5IGFyZSByZW1vdmVkIGFmdGVyIEV4dGVuZGVkQ3NzIGFwcGxpZWRcbiAgICAgIH0gZWxzZSB7XG4gICAgICAgIHNlbGVjdG9yRGF0YS5zdHlsZUFwcGxpZWQgPSBzdHlsZSB8fCBudWxsO1xuICAgICAgICBzZWxlY3RvckRhdGEubWF0Y2hlZEVsZW1lbnRzID0gbWF0Y2hlZEVsZW1lbnRzO1xuICAgICAgfVxuXG4gICAgICB0aW1pbmdzTG9nRGF0YVtzZWxlY3Rvcl0gPSBzZWxlY3RvckRhdGE7XG4gICAgfVxuICB9KTtcblxuICBpZiAoT2JqZWN0LmtleXModGltaW5nc0xvZ0RhdGEpLmxlbmd0aCA9PT0gMCkge1xuICAgIHJldHVybjtcbiAgfSAvLyBhZGQgbG9jYXRpb24uaHJlZiB0byB0aGUgbWVzc2FnZSB0byBkaXN0aW5ndWlzaCBmcmFtZXNcblxuXG4gIGxvZ2dlci5pbmZvKCdbRXh0ZW5kZWRDc3NdIFRpbWluZ3MgaW4gbWlsbGlzZWNvbmRzIGZvciAlbzpcXG4lbycsIHdpbmRvdy5sb2NhdGlvbi5ocmVmLCB0aW1pbmdzTG9nRGF0YSk7XG59O1xuXG4vKipcbiAqIEZpbmRzIGFmZmVjdGVkRWxlbWVudCBvYmplY3QgZm9yIHRoZSBzcGVjaWZpZWQgRE9NIG5vZGUuXG4gKlxuICogQHBhcmFtIGFmZkVsZW1lbnRzIEFycmF5IG9mIGFmZmVjdGVkIGVsZW1lbnRzIOKAlCBjb250ZXh0LmFmZmVjdGVkRWxlbWVudHMuXG4gKiBAcGFyYW0gZG9tTm9kZSBET00gbm9kZS5cbiAqIEByZXR1cm5zIEZvdW5kIGFmZmVjdGVkRWxlbWVudCBvciB1bmRlZmluZWQuXG4gKi9cblxuY29uc3QgZmluZEFmZmVjdGVkRWxlbWVudCA9IChhZmZFbGVtZW50cywgZG9tTm9kZSkgPT4ge1xuICByZXR1cm4gYWZmRWxlbWVudHMuZmluZChhZmZFbCA9PiBhZmZFbC5ub2RlID09PSBkb21Ob2RlKTtcbn07XG4vKipcbiAqIEFwcGxpZXMgc3BlY2lmaWVkIHJ1bGUgYW5kIHJldHVybnMgbGlzdCBvZiBlbGVtZW50cyBhZmZlY3RlZC5cbiAqXG4gKiBAcGFyYW0gY29udGV4dCBFeHRlbmRlZENzcyBjb250ZXh0LlxuICogQHBhcmFtIHJ1bGVEYXRhIFJ1bGUgdG8gYXBwbHkuXG4gKiBAcmV0dXJucyBMaXN0IG9mIGVsZW1lbnRzIGFmZmVjdGVkIGJ5IHRoZSBydWxlLlxuICovXG5cblxuY29uc3QgYXBwbHlSdWxlID0gKGNvbnRleHQsIHJ1bGVEYXRhKSA9PiB7XG4gIC8vIGRlYnVnZ2luZyBtb2RlIGNhbiBiZSBlbmFibGVkIGluIHR3byB3YXlzOlxuICAvLyAxLiBmb3Igc2VwYXJhdGUgcnVsZXMgLSBieSBgeyBkZWJ1ZzogdHJ1ZTsgfWBcbiAgLy8gMi4gZm9yIGFsbCBydWxlcyBzaW11bHRhbmVvdXNseSBieTpcbiAgLy8gICAtIGB7IGRlYnVnOiBnbG9iYWw7IH1gIGluIGFueSBydWxlXG4gIC8vICAgLSBwb3NpdGl2ZSBgZGVidWdgIHByb3BlcnR5IGluIEV4dENzc0NvbmZpZ3VyYXRpb25cbiAgY29uc3QgaXNEZWJ1Z2dpbmdNb2RlID0gISFydWxlRGF0YS5kZWJ1ZyB8fCBjb250ZXh0LmRlYnVnO1xuICBsZXQgc3RhcnRUaW1lO1xuXG4gIGlmIChpc0RlYnVnZ2luZ01vZGUpIHtcbiAgICBzdGFydFRpbWUgPSBUaHJvdHRsZVdyYXBwZXIubm93KCk7XG4gIH1cblxuICBjb25zdCB7XG4gICAgYXN0XG4gIH0gPSBydWxlRGF0YTtcbiAgY29uc3Qgbm9kZXMgPSBbXTsgLy8gc2VsZWN0b3IgY2FuIGJlIHN1Y2Nlc3NmdWxseSBwYXJzZXIgaW50byBhc3Qgd2l0aCBubyBlcnJvclxuICAvLyBidXQgaXRzIGFwcGx5aW5nIGJ5IG5hdGl2ZSBEb2N1bWVudC5xdWVyeVNlbGVjdG9yQWxsKCkgc3RpbGwgbWF5IHRocm93IGFuIGVycm9yXG4gIC8vIGUuZy4gJ2RpdlsuLmJhbm5lcl0nXG5cbiAgdHJ5IHtcbiAgICBub2Rlcy5wdXNoKC4uLnNlbGVjdEVsZW1lbnRzQnlBc3QoYXN0KSk7XG4gIH0gY2F0Y2ggKGUpIHtcbiAgICAvLyBsb2cgdGhlIGVycm9yIG9ubHkgaW4gZGVidWcgbW9kZVxuICAgIGlmIChjb250ZXh0LmRlYnVnKSB7XG4gICAgICBsb2dnZXIuZXJyb3IoZ2V0RXJyb3JNZXNzYWdlKGUpKTtcbiAgICB9XG4gIH1cblxuICBub2Rlcy5mb3JFYWNoKG5vZGUgPT4ge1xuICAgIGxldCBhZmZlY3RlZEVsZW1lbnQgPSBmaW5kQWZmZWN0ZWRFbGVtZW50KGNvbnRleHQuYWZmZWN0ZWRFbGVtZW50cywgbm9kZSk7XG5cbiAgICBpZiAoYWZmZWN0ZWRFbGVtZW50KSB7XG4gICAgICBhZmZlY3RlZEVsZW1lbnQucnVsZXMucHVzaChydWxlRGF0YSk7XG4gICAgICBhcHBseVN0eWxlKGNvbnRleHQsIGFmZmVjdGVkRWxlbWVudCk7XG4gICAgfSBlbHNlIHtcbiAgICAgIC8vIEFwcGx5aW5nIHN0eWxlIGZpcnN0IHRpbWVcbiAgICAgIGNvbnN0IG9yaWdpbmFsU3R5bGUgPSBub2RlLnN0eWxlLmNzc1RleHQ7XG4gICAgICBhZmZlY3RlZEVsZW1lbnQgPSB7XG4gICAgICAgIG5vZGUsXG4gICAgICAgIC8vIGFmZmVjdGVkIERPTSBub2RlXG4gICAgICAgIHJ1bGVzOiBbcnVsZURhdGFdLFxuICAgICAgICAvLyBydWxlIHRvIGJlIGFwcGxpZWRcbiAgICAgICAgb3JpZ2luYWxTdHlsZSxcbiAgICAgICAgLy8gb3JpZ2luYWwgbm9kZSBzdHlsZVxuICAgICAgICBwcm90ZWN0aW9uT2JzZXJ2ZXI6IG51bGwgLy8gc3R5bGUgYXR0cmlidXRlIG9ic2VydmVyXG5cbiAgICAgIH07XG4gICAgICBhcHBseVN0eWxlKGNvbnRleHQsIGFmZmVjdGVkRWxlbWVudCk7XG4gICAgICBjb250ZXh0LmFmZmVjdGVkRWxlbWVudHMucHVzaChhZmZlY3RlZEVsZW1lbnQpO1xuICAgIH1cbiAgfSk7XG5cbiAgaWYgKGlzRGVidWdnaW5nTW9kZSAmJiBzdGFydFRpbWUpIHtcbiAgICBjb25zdCBlbGFwc2VkVGltZU1zID0gVGhyb3R0bGVXcmFwcGVyLm5vdygpIC0gc3RhcnRUaW1lO1xuXG4gICAgaWYgKCFydWxlRGF0YS50aW1pbmdTdGF0cykge1xuICAgICAgcnVsZURhdGEudGltaW5nU3RhdHMgPSBuZXcgVGltaW5nU3RhdHMoKTtcbiAgICB9XG5cbiAgICBydWxlRGF0YS50aW1pbmdTdGF0cy5wdXNoKGVsYXBzZWRUaW1lTXMpO1xuICB9XG5cbiAgcmV0dXJuIG5vZGVzO1xufTtcbi8qKlxuICogQXBwbGllcyBmaWx0ZXJpbmcgcnVsZXMuXG4gKlxuICogQHBhcmFtIGNvbnRleHQgRXh0ZW5kZWRDc3MgY29udGV4dC5cbiAqL1xuXG5cbmNvbnN0IGFwcGx5UnVsZXMgPSBjb250ZXh0ID0+IHtcbiAgY29uc3QgbmV3U2VsZWN0ZWRFbGVtZW50cyA9IFtdOyAvLyBzb21lIHJ1bGVzIGNvdWxkIG1ha2UgY2FsbCAtIHNlbGVjdG9yLnF1ZXJ5U2VsZWN0b3JBbGwoKSB0ZW1wb3JhcmlseSB0byBjaGFuZ2Ugbm9kZSBpZCBhdHRyaWJ1dGVcbiAgLy8gdGhpcyBjYXVzZWQgTXV0YXRpb25PYnNlcnZlciB0byBjYWxsIHJlY3Vyc2l2ZWx5XG4gIC8vIGh0dHBzOi8vZ2l0aHViLmNvbS9BZGd1YXJkVGVhbS9FeHRlbmRlZENzcy9pc3N1ZXMvODFcblxuICBtYWluRGlzY29ubmVjdChjb250ZXh0LCBjb250ZXh0Lm1haW5DYWxsYmFjayk7XG4gIGNvbnRleHQucGFyc2VkUnVsZXMuZm9yRWFjaChydWxlRGF0YSA9PiB7XG4gICAgY29uc3Qgbm9kZXMgPSBhcHBseVJ1bGUoY29udGV4dCwgcnVsZURhdGEpO1xuICAgIEFycmF5LnByb3RvdHlwZS5wdXNoLmFwcGx5KG5ld1NlbGVjdGVkRWxlbWVudHMsIG5vZGVzKTsgLy8gc2F2ZSBtYXRjaGVkIGVsZW1lbnRzIHRvIHJ1bGVEYXRhIGFzIGxpbmtlZCB0byBhcHBsaWVkIHJ1bGVcbiAgICAvLyBvbmx5IGZvciBkZWJ1Z2dpbmcgcHVycG9zZXNcblxuICAgIGlmIChydWxlRGF0YS5kZWJ1Zykge1xuICAgICAgcnVsZURhdGEubWF0Y2hlZEVsZW1lbnRzID0gbm9kZXM7XG4gICAgfVxuICB9KTsgLy8gTm93IHJldmVydCBzdHlsZXMgZm9yIGVsZW1lbnRzIHdoaWNoIGFyZSBubyBtb3JlIGFmZmVjdGVkXG5cbiAgbGV0IGFmZkxlbmd0aCA9IGNvbnRleHQuYWZmZWN0ZWRFbGVtZW50cy5sZW5ndGg7IC8vIGRvIG5vdGhpbmcgaWYgdGhlcmUgaXMgbm8gZWxlbWVudHMgdG8gcHJvY2Vzc1xuXG4gIHdoaWxlIChhZmZMZW5ndGgpIHtcbiAgICBjb25zdCBhZmZlY3RlZEVsZW1lbnQgPSBjb250ZXh0LmFmZmVjdGVkRWxlbWVudHNbYWZmTGVuZ3RoIC0gMV07XG5cbiAgICBpZiAoIWFmZmVjdGVkRWxlbWVudCkge1xuICAgICAgYnJlYWs7XG4gICAgfVxuXG4gICAgaWYgKCFuZXdTZWxlY3RlZEVsZW1lbnRzLmluY2x1ZGVzKGFmZmVjdGVkRWxlbWVudC5ub2RlKSkge1xuICAgICAgLy8gVGltZSB0byByZXZlcnQgc3R5bGVcbiAgICAgIHJldmVydFN0eWxlKGFmZmVjdGVkRWxlbWVudCk7XG4gICAgICBjb250ZXh0LmFmZmVjdGVkRWxlbWVudHMuc3BsaWNlKGFmZkxlbmd0aCAtIDEsIDEpO1xuICAgIH0gZWxzZSBpZiAoIWFmZmVjdGVkRWxlbWVudC5yZW1vdmVkKSB7XG4gICAgICAvLyBBZGQgc3R5bGUgcHJvdGVjdGlvbiBvYnNlcnZlclxuICAgICAgLy8gUHJvdGVjdCBcInN0eWxlXCIgYXR0cmlidXRlIGZyb20gY2hhbmdlc1xuICAgICAgaWYgKCFhZmZlY3RlZEVsZW1lbnQucHJvdGVjdGlvbk9ic2VydmVyKSB7XG4gICAgICAgIGFmZmVjdGVkRWxlbWVudC5wcm90ZWN0aW9uT2JzZXJ2ZXIgPSBwcm90ZWN0U3R5bGVBdHRyaWJ1dGUoYWZmZWN0ZWRFbGVtZW50Lm5vZGUsIGFmZmVjdGVkRWxlbWVudC5ydWxlcyk7XG4gICAgICB9XG4gICAgfVxuXG4gICAgYWZmTGVuZ3RoIC09IDE7XG4gIH0gLy8gQWZ0ZXIgc3R5bGVzIGFyZSBhcHBsaWVkIHdlIGNhbiBzdGFydCBvYnNlcnZlIGFnYWluXG5cblxuICBtYWluT2JzZXJ2ZShjb250ZXh0LCBjb250ZXh0Lm1haW5DYWxsYmFjayk7XG4gIHByaW50VGltaW5nSW5mbyhjb250ZXh0KTtcbn07XG5cbi8qKlxuICogVGhyb3R0bGUgdGltZW91dCBmb3IgVGhyb3R0bGVXcmFwcGVyIHRvIGV4ZWN1dGUgYXBwbHlSdWxlcygpLlxuICovXG5cbmNvbnN0IEFQUExZX1JVTEVTX0RFTEFZID0gMTUwO1xuLyoqXG4gKiBSZXN1bHQgb2Ygc2VsZWN0b3IgdmFsaWRhdGlvbi5cbiAqL1xuXG4vKipcbiAqIE1haW4gY2xhc3Mgb2YgRXh0ZW5kZWRDc3MgbGliLlxuICpcbiAqIFBhcnNlcyBjc3Mgc3R5bGVzaGVldCB3aXRoIGFueSBzZWxlY3RvcnMgKHBhc3NlZCB0byBpdHMgYXJndW1lbnQgYXMgc3R5bGVTaGVldCksXG4gKiBhbmQgZ3VhcmFudGVlIGl0cyBhcHBseWluZyBhcyBtdXRhdGlvbiBvYnNlcnZlciBpcyB1c2VkIHRvIHByZXZlbnQgdGhlIHJlc3R5bGluZyBvZiBuZWVkZWQgZWxlbWVudHMgYnkgb3RoZXIgc2NyaXB0cy5cbiAqIFRoaXMgc3R5bGUgcHJvdGVjdGlvbiBpcyBsaW1pdGVkIHRvIDUwIHRpbWVzIHRvIGF2b2lkIGluZmluaXRlIGxvb3AgKE1BWF9TVFlMRV9QUk9URUNUSU9OX0NPVU5UKS5cbiAqIE91ciBvd24gVGhyb3R0bGVXcmFwcGVyIGlzIHVzZWQgZm9yIHN0eWxlcyBhcHBseWluZyB0byBhdm9pZCB0b28gb2Z0ZW4gbGliIHJlYWN0aW9ucyBvbiBwYWdlIG11dGF0aW9ucy5cbiAqXG4gKiBDb25zdHJ1Y3RvciBjcmVhdGVzIHRoZSBpbnN0YW5jZSBvZiBjbGFzcyB3aGljaCBzaG91bGQgYmUgcnVuIGJlIGBhcHBseSgpYCBtZXRob2QgdG8gYXBwbHkgdGhlIHJ1bGVzLFxuICogYW5kIHRoZSBhcHBseWluZyBjYW4gYmUgc3RvcHBlZCBieSBgZGlzcG9zZSgpYC5cbiAqXG4gKiBDYW4gYmUgdXNlZCB0byBzZWxlY3QgcGFnZSBlbGVtZW50cyBieSBzZWxlY3RvciB3aXRoIGBxdWVyeSgpYCBtZXRob2QgKHNpbWlsYXIgdG8gYERvY3VtZW50LnF1ZXJ5U2VsZWN0b3JBbGwoKWApLFxuICogd2hpY2ggZG9lcyBub3QgcmVxdWlyZSBpbnN0YW5jZSBjcmVhdGluZy5cbiAqL1xuY2xhc3MgRXh0ZW5kZWRDc3Mge1xuICAvKipcbiAgICogQ3JlYXRlcyBuZXcgRXh0ZW5kZWRDc3MuXG4gICAqXG4gICAqIEBwYXJhbSBjb25maWd1cmF0aW9uIEV4dGVuZGVkQ3NzIGNvbmZpZ3VyYXRpb24uXG4gICAqL1xuICBjb25zdHJ1Y3Rvcihjb25maWd1cmF0aW9uKSB7XG4gICAgaWYgKCFpc0Jyb3dzZXJTdXBwb3J0ZWQoKSkge1xuICAgICAgbG9nZ2VyLmVycm9yKCdCcm93c2VyIGlzIG5vdCBzdXBwb3J0ZWQgYnkgRXh0ZW5kZWRDc3MnKTtcbiAgICB9XG5cbiAgICBpZiAoIWNvbmZpZ3VyYXRpb24pIHtcbiAgICAgIHRocm93IG5ldyBFcnJvcignRXh0ZW5kZWRDc3MgY29uZmlndXJhdGlvbiBzaG91bGQgYmUgcHJvdmlkZWQuJyk7XG4gICAgfVxuXG4gICAgdGhpcy5jb250ZXh0ID0ge1xuICAgICAgYmVmb3JlU3R5bGVBcHBsaWVkOiBjb25maWd1cmF0aW9uLmJlZm9yZVN0eWxlQXBwbGllZCxcbiAgICAgIGRlYnVnOiBmYWxzZSxcbiAgICAgIGFmZmVjdGVkRWxlbWVudHM6IFtdLFxuICAgICAgaXNEb21PYnNlcnZlZDogZmFsc2UsXG4gICAgICByZW1vdmFsc1N0YXRpc3RpYzoge30sXG4gICAgICBwYXJzZWRSdWxlczogW10sXG4gICAgICBtYWluQ2FsbGJhY2s6ICgpID0+IHt9XG4gICAgfTsgLy8gYXQgbGVhc3QgJ3N0eWxlU2hlZXQnIG9yICdjc3NSdWxlcycgc2hvdWxkIGJlIHByb3ZpZGVkXG5cbiAgICBpZiAoIWNvbmZpZ3VyYXRpb24uc3R5bGVTaGVldCAmJiAhY29uZmlndXJhdGlvbi5jc3NSdWxlcykge1xuICAgICAgdGhyb3cgbmV3IEVycm9yKFwiRXh0ZW5kZWRDc3MgY29uZmlndXJhdGlvbiBzaG91bGQgaGF2ZSAnc3R5bGVTaGVldCcgb3IgJ2Nzc1J1bGVzJyBkZWZpbmVkLlwiKTtcbiAgICB9IC8vICdzdHlsZVNoZWV0JyBhbmQgJ2Nzc1J1bGVzJyBhcmUgb3B0aW9uYWxcbiAgICAvLyBhbmQgYm90aCBjYW4gYmUgcHJvdmlkZWQgYXQgdGhlIHNhbWUgdGltZVxuICAgIC8vIHNvIGJvdGggc2hvdWxkIGJlIHBhcnNlZCBhbmQgYXBwbGllZCBpbiBzdWNoIGNhc2VcblxuXG4gICAgaWYgKGNvbmZpZ3VyYXRpb24uc3R5bGVTaGVldCkge1xuICAgICAgLy8gc3R5bGVzaGVldCBwYXJzaW5nIGNhbiBmYWlsIG9uIHNvbWUgaW52YWxpZCBzZWxlY3RvcnNcbiAgICAgIHRyeSB7XG4gICAgICAgIHRoaXMuY29udGV4dC5wYXJzZWRSdWxlcy5wdXNoKC4uLnBhcnNlU3R5bGVzaGVldChjb25maWd1cmF0aW9uLnN0eWxlU2hlZXQsIGV4dENzc0RvY3VtZW50KSk7XG4gICAgICB9IGNhdGNoIChlKSB7XG4gICAgICAgIC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBtYXgtbGVuXG4gICAgICAgIHRocm93IG5ldyBFcnJvcihgUGFzcyB0aGUgcnVsZXMgYXMgY29uZmlndXJhdGlvbi5jc3NSdWxlcyBzaW5jZSBjb25maWd1cmF0aW9uLnN0eWxlU2hlZXQgY2Fubm90IGJlIHBhcnNlZCBiZWNhdXNlIG9mOiAnJHtnZXRFcnJvck1lc3NhZ2UoZSl9J2ApO1xuICAgICAgfVxuICAgIH1cblxuICAgIGlmIChjb25maWd1cmF0aW9uLmNzc1J1bGVzKSB7XG4gICAgICB0aGlzLmNvbnRleHQucGFyc2VkUnVsZXMucHVzaCguLi5wYXJzZVJ1bGVzKGNvbmZpZ3VyYXRpb24uY3NzUnVsZXMsIGV4dENzc0RvY3VtZW50KSk7XG4gICAgfSAvLyB0cnVlIGlmIHNldCBpbiBjb25maWd1cmF0aW9uXG4gICAgLy8gb3IgYW55IHJ1bGUgaW4gc3R5bGVTaGVldCBoYXMgYGRlYnVnOiBnbG9iYWxgXG5cblxuICAgIHRoaXMuY29udGV4dC5kZWJ1ZyA9IGNvbmZpZ3VyYXRpb24uZGVidWcgfHwgdGhpcy5jb250ZXh0LnBhcnNlZFJ1bGVzLnNvbWUocnVsZURhdGEgPT4ge1xuICAgICAgcmV0dXJuIHJ1bGVEYXRhLmRlYnVnID09PSBERUJVR19QU0VVRE9fUFJPUEVSVFlfR0xPQkFMX1ZBTFVFO1xuICAgIH0pO1xuICAgIHRoaXMuYXBwbHlSdWxlc1NjaGVkdWxlciA9IG5ldyBUaHJvdHRsZVdyYXBwZXIodGhpcy5jb250ZXh0LCBhcHBseVJ1bGVzLCBBUFBMWV9SVUxFU19ERUxBWSk7XG4gICAgdGhpcy5jb250ZXh0Lm1haW5DYWxsYmFjayA9IHRoaXMuYXBwbHlSdWxlc1NjaGVkdWxlci5ydW4uYmluZCh0aGlzLmFwcGx5UnVsZXNTY2hlZHVsZXIpO1xuXG4gICAgaWYgKHRoaXMuY29udGV4dC5iZWZvcmVTdHlsZUFwcGxpZWQgJiYgdHlwZW9mIHRoaXMuY29udGV4dC5iZWZvcmVTdHlsZUFwcGxpZWQgIT09ICdmdW5jdGlvbicpIHtcbiAgICAgIC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBtYXgtbGVuXG4gICAgICB0aHJvdyBuZXcgRXJyb3IoYEludmFsaWQgY29uZmlndXJhdGlvbi4gVHlwZSBvZiAnYmVmb3JlU3R5bGVBcHBsaWVkJyBzaG91bGQgYmUgYSBmdW5jdGlvbiwgcmVjZWl2ZWQ6ICcke3R5cGVvZiB0aGlzLmNvbnRleHQuYmVmb3JlU3R5bGVBcHBsaWVkfSdgKTtcbiAgICB9XG5cbiAgICB0aGlzLmFwcGx5UnVsZXNDYWxsYmFja0xpc3RlbmVyID0gKCkgPT4ge1xuICAgICAgYXBwbHlSdWxlcyh0aGlzLmNvbnRleHQpO1xuICAgIH07XG4gIH1cbiAgLyoqXG4gICAqIEluaXRpYWxpemVzIEV4dGVuZGVkQ3NzLlxuICAgKlxuICAgKiBTaG91bGQgYmUgZXhlY3V0ZWQgb24gcGFnZSBBU0FQLFxuICAgKiBvdGhlcndpc2UgdGhlIDpjb250YWlucygpIHBzZXVkby1jbGFzcyBtYXkgd29yayBpbmNvcnJlY3RseS5cbiAgICovXG5cblxuICBpbml0KCkge1xuICAgIC8qKlxuICAgICAqIE5hdGl2ZSBOb2RlIHRleHRDb250ZW50IGdldHRlciBtdXN0IGJlIGludGVyY2VwdGVkIGFzIHNvb24gYXMgcG9zc2libGUsXG4gICAgICogYW5kIHN0b3JlZCBhcyBpdCBpcyBuZWVkZWQgZm9yIHByb3BlciB3b3JrIG9mIDpjb250YWlucygpIHBzZXVkby1jbGFzc1xuICAgICAqIGJlY2F1c2UgRE9NIE5vZGUgcHJvdG90eXBlICd0ZXh0Q29udGVudCcgcHJvcGVydHkgbWF5IGJlIG1vY2tlZC5cbiAgICAgKlxuICAgICAqIEBzZWUge0BsaW5rIGh0dHBzOi8vZ2l0aHViLmNvbS9BZGd1YXJkVGVhbS9FeHRlbmRlZENzcy9pc3N1ZXMvMTI3fVxuICAgICAqL1xuICAgIG5hdGl2ZVRleHRDb250ZW50LnNldEdldHRlcigpO1xuICB9XG4gIC8qKlxuICAgKiBBcHBsaWVzIHN0eWxlc2hlZXQgcnVsZXMgb24gcGFnZS5cbiAgICovXG5cblxuICBhcHBseSgpIHtcbiAgICBhcHBseVJ1bGVzKHRoaXMuY29udGV4dCk7XG5cbiAgICBpZiAoZG9jdW1lbnQucmVhZHlTdGF0ZSAhPT0gJ2NvbXBsZXRlJykge1xuICAgICAgZG9jdW1lbnQuYWRkRXZlbnRMaXN0ZW5lcignRE9NQ29udGVudExvYWRlZCcsIHRoaXMuYXBwbHlSdWxlc0NhbGxiYWNrTGlzdGVuZXIsIGZhbHNlKTtcbiAgICB9XG4gIH1cbiAgLyoqXG4gICAqIERpc3Bvc2VzIEV4dGVuZGVkQ3NzIGFuZCByZW1vdmVzIG91ciBzdHlsZXMgZnJvbSBtYXRjaGVkIGVsZW1lbnRzLlxuICAgKi9cblxuXG4gIGRpc3Bvc2UoKSB7XG4gICAgbWFpbkRpc2Nvbm5lY3QodGhpcy5jb250ZXh0LCB0aGlzLmNvbnRleHQubWFpbkNhbGxiYWNrKTtcbiAgICB0aGlzLmNvbnRleHQuYWZmZWN0ZWRFbGVtZW50cy5mb3JFYWNoKGVsID0+IHtcbiAgICAgIHJldmVydFN0eWxlKGVsKTtcbiAgICB9KTtcbiAgICBkb2N1bWVudC5yZW1vdmVFdmVudExpc3RlbmVyKCdET01Db250ZW50TG9hZGVkJywgdGhpcy5hcHBseVJ1bGVzQ2FsbGJhY2tMaXN0ZW5lciwgZmFsc2UpO1xuICB9XG4gIC8qKlxuICAgKiBFeHBvc2VkIGZvciB0ZXN0aW5nIHB1cnBvc2VzIG9ubHkuXG4gICAqXG4gICAqIEByZXR1cm5zIEFycmF5IG9mIEFmZmVjdGVkRWxlbWVudCBkYXRhIG9iamVjdHMuXG4gICAqL1xuXG5cbiAgZ2V0QWZmZWN0ZWRFbGVtZW50cygpIHtcbiAgICByZXR1cm4gdGhpcy5jb250ZXh0LmFmZmVjdGVkRWxlbWVudHM7XG4gIH1cbiAgLyoqXG4gICAqIFJldHVybnMgYSBsaXN0IG9mIHRoZSBkb2N1bWVudCdzIGVsZW1lbnRzIHRoYXQgbWF0Y2ggdGhlIHNwZWNpZmllZCBzZWxlY3Rvci5cbiAgICogVXNlcyBFeHRDc3NEb2N1bWVudC5xdWVyeVNlbGVjdG9yQWxsKCkuXG4gICAqXG4gICAqIEBwYXJhbSBzZWxlY3RvciBTZWxlY3RvciB0ZXh0LlxuICAgKiBAcGFyYW0gW25vVGltaW5nPXRydWVdIElmIHRydWUg4oCUIGRvIG5vdCBwcmludCB0aGUgdGltaW5ncyB0byB0aGUgY29uc29sZS5cbiAgICpcbiAgICogQHRocm93cyBBbiBlcnJvciBpZiBzZWxlY3RvciBpcyBub3QgdmFsaWQuXG4gICAqIEByZXR1cm5zIEEgbGlzdCBvZiBlbGVtZW50cyB0aGF0IG1hdGNoIHRoZSBzZWxlY3Rvci5cbiAgICovXG5cblxuICBzdGF0aWMgcXVlcnkoc2VsZWN0b3IpIHtcbiAgICBsZXQgbm9UaW1pbmcgPSBhcmd1bWVudHMubGVuZ3RoID4gMSAmJiBhcmd1bWVudHNbMV0gIT09IHVuZGVmaW5lZCA/IGFyZ3VtZW50c1sxXSA6IHRydWU7XG5cbiAgICBpZiAodHlwZW9mIHNlbGVjdG9yICE9PSAnc3RyaW5nJykge1xuICAgICAgdGhyb3cgbmV3IEVycm9yKCdTZWxlY3RvciBzaG91bGQgYmUgZGVmaW5lZCBhcyBhIHN0cmluZy4nKTtcbiAgICB9XG5cbiAgICBjb25zdCBzdGFydCA9IFRocm90dGxlV3JhcHBlci5ub3coKTtcblxuICAgIHRyeSB7XG4gICAgICByZXR1cm4gZXh0Q3NzRG9jdW1lbnQucXVlcnlTZWxlY3RvckFsbChzZWxlY3Rvcik7XG4gICAgfSBmaW5hbGx5IHtcbiAgICAgIGNvbnN0IGVuZCA9IFRocm90dGxlV3JhcHBlci5ub3coKTtcblxuICAgICAgaWYgKCFub1RpbWluZykge1xuICAgICAgICBsb2dnZXIuaW5mbyhgW0V4dGVuZGVkQ3NzXSBFbGFwc2VkOiAke01hdGgucm91bmQoKGVuZCAtIHN0YXJ0KSAqIDEwMDApfSDOvHMuYCk7XG4gICAgICB9XG4gICAgfVxuICB9XG4gIC8qKlxuICAgKiBWYWxpZGF0ZXMgc2VsZWN0b3IuXG4gICAqXG4gICAqIEBwYXJhbSBpbnB1dFNlbGVjdG9yIFNlbGVjdG9yIHRleHQgdG8gdmFsaWRhdGUuXG4gICAqXG4gICAqIEByZXR1cm5zIFJlc3VsdCBvZiBzZWxlY3RvciB2YWxpZGF0aW9uLlxuICAgKi9cblxuXG4gIHN0YXRpYyB2YWxpZGF0ZShpbnB1dFNlbGVjdG9yKSB7XG4gICAgdHJ5IHtcbiAgICAgIC8vIEV4dGVuZGVkQ3NzIGluIGdlbmVyYWwgc3VwcG9ydHMgOnJlbW92ZSgpIGluIHNlbGVjdG9yXG4gICAgICAvLyBidXQgRXh0ZW5kZWRDc3MucXVlcnkoKSBkb2VzIG5vdCBzdXBwb3J0IGl0IGFzIGl0IHNob3VsZCBiZSBwYXJzZWQgYnkgc3R5bGVzaGVldCBwYXJzZXIuXG4gICAgICAvLyBzbyBmb3IgdmFsaWRhdGlvbiB3ZSBoYXZlIHRvIGhhbmRsZSBzZWxlY3RvcnMgd2l0aCBgOnJlbW92ZSgpYCBpbiBpdFxuICAgICAgY29uc3Qge1xuICAgICAgICBzZWxlY3RvclxuICAgICAgfSA9IHBhcnNlUmVtb3ZlU2VsZWN0b3IoaW5wdXRTZWxlY3Rvcik7XG4gICAgICBFeHRlbmRlZENzcy5xdWVyeShzZWxlY3Rvcik7XG4gICAgICByZXR1cm4ge1xuICAgICAgICBvazogdHJ1ZSxcbiAgICAgICAgZXJyb3I6IG51bGxcbiAgICAgIH07XG4gICAgfSBjYXRjaCAoZSkge1xuICAgICAgLy8gbm90IHZhbGlkIGlucHV0IGBzZWxlY3RvcmAgc2hvdWxkIGJlIGxvZ2dlZCBldmVudHVhbGx5XG4gICAgICBjb25zdCBlcnJvciA9IGBFcnJvcjogSW52YWxpZCBzZWxlY3RvcjogJyR7aW5wdXRTZWxlY3Rvcn0nIC0tICR7Z2V0RXJyb3JNZXNzYWdlKGUpfWA7XG4gICAgICByZXR1cm4ge1xuICAgICAgICBvazogZmFsc2UsXG4gICAgICAgIGVycm9yXG4gICAgICB9O1xuICAgIH1cbiAgfVxuXG59XG5cbmV4cG9ydCB7IEV4dGVuZGVkQ3NzIH07XG4iLCJleHBvcnQgZGVmYXVsdCBmdW5jdGlvbiBfYXJyYXlMaWtlVG9BcnJheShhcnIsIGxlbikge1xuICBpZiAobGVuID09IG51bGwgfHwgbGVuID4gYXJyLmxlbmd0aCkgbGVuID0gYXJyLmxlbmd0aDtcblxuICBmb3IgKHZhciBpID0gMCwgYXJyMiA9IG5ldyBBcnJheShsZW4pOyBpIDwgbGVuOyBpKyspIHtcbiAgICBhcnIyW2ldID0gYXJyW2ldO1xuICB9XG5cbiAgcmV0dXJuIGFycjI7XG59IiwiaW1wb3J0IGFycmF5TGlrZVRvQXJyYXkgZnJvbSBcIi4vYXJyYXlMaWtlVG9BcnJheS5qc1wiO1xuZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24gX2FycmF5V2l0aG91dEhvbGVzKGFycikge1xuICBpZiAoQXJyYXkuaXNBcnJheShhcnIpKSByZXR1cm4gYXJyYXlMaWtlVG9BcnJheShhcnIpO1xufSIsImZ1bmN0aW9uIGFzeW5jR2VuZXJhdG9yU3RlcChnZW4sIHJlc29sdmUsIHJlamVjdCwgX25leHQsIF90aHJvdywga2V5LCBhcmcpIHtcbiAgdHJ5IHtcbiAgICB2YXIgaW5mbyA9IGdlbltrZXldKGFyZyk7XG4gICAgdmFyIHZhbHVlID0gaW5mby52YWx1ZTtcbiAgfSBjYXRjaCAoZXJyb3IpIHtcbiAgICByZWplY3QoZXJyb3IpO1xuICAgIHJldHVybjtcbiAgfVxuXG4gIGlmIChpbmZvLmRvbmUpIHtcbiAgICByZXNvbHZlKHZhbHVlKTtcbiAgfSBlbHNlIHtcbiAgICBQcm9taXNlLnJlc29sdmUodmFsdWUpLnRoZW4oX25leHQsIF90aHJvdyk7XG4gIH1cbn1cblxuZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24gX2FzeW5jVG9HZW5lcmF0b3IoZm4pIHtcbiAgcmV0dXJuIGZ1bmN0aW9uICgpIHtcbiAgICB2YXIgc2VsZiA9IHRoaXMsXG4gICAgICAgIGFyZ3MgPSBhcmd1bWVudHM7XG4gICAgcmV0dXJuIG5ldyBQcm9taXNlKGZ1bmN0aW9uIChyZXNvbHZlLCByZWplY3QpIHtcbiAgICAgIHZhciBnZW4gPSBmbi5hcHBseShzZWxmLCBhcmdzKTtcblxuICAgICAgZnVuY3Rpb24gX25leHQodmFsdWUpIHtcbiAgICAgICAgYXN5bmNHZW5lcmF0b3JTdGVwKGdlbiwgcmVzb2x2ZSwgcmVqZWN0LCBfbmV4dCwgX3Rocm93LCBcIm5leHRcIiwgdmFsdWUpO1xuICAgICAgfVxuXG4gICAgICBmdW5jdGlvbiBfdGhyb3coZXJyKSB7XG4gICAgICAgIGFzeW5jR2VuZXJhdG9yU3RlcChnZW4sIHJlc29sdmUsIHJlamVjdCwgX25leHQsIF90aHJvdywgXCJ0aHJvd1wiLCBlcnIpO1xuICAgICAgfVxuXG4gICAgICBfbmV4dCh1bmRlZmluZWQpO1xuICAgIH0pO1xuICB9O1xufSIsImV4cG9ydCBkZWZhdWx0IGZ1bmN0aW9uIF9pdGVyYWJsZVRvQXJyYXkoaXRlcikge1xuICBpZiAodHlwZW9mIFN5bWJvbCAhPT0gXCJ1bmRlZmluZWRcIiAmJiBpdGVyW1N5bWJvbC5pdGVyYXRvcl0gIT0gbnVsbCB8fCBpdGVyW1wiQEBpdGVyYXRvclwiXSAhPSBudWxsKSByZXR1cm4gQXJyYXkuZnJvbShpdGVyKTtcbn0iLCJleHBvcnQgZGVmYXVsdCBmdW5jdGlvbiBfbm9uSXRlcmFibGVTcHJlYWQoKSB7XG4gIHRocm93IG5ldyBUeXBlRXJyb3IoXCJJbnZhbGlkIGF0dGVtcHQgdG8gc3ByZWFkIG5vbi1pdGVyYWJsZSBpbnN0YW5jZS5cXG5JbiBvcmRlciB0byBiZSBpdGVyYWJsZSwgbm9uLWFycmF5IG9iamVjdHMgbXVzdCBoYXZlIGEgW1N5bWJvbC5pdGVyYXRvcl0oKSBtZXRob2QuXCIpO1xufSIsImltcG9ydCBhcnJheVdpdGhvdXRIb2xlcyBmcm9tIFwiLi9hcnJheVdpdGhvdXRIb2xlcy5qc1wiO1xuaW1wb3J0IGl0ZXJhYmxlVG9BcnJheSBmcm9tIFwiLi9pdGVyYWJsZVRvQXJyYXkuanNcIjtcbmltcG9ydCB1bnN1cHBvcnRlZEl0ZXJhYmxlVG9BcnJheSBmcm9tIFwiLi91bnN1cHBvcnRlZEl0ZXJhYmxlVG9BcnJheS5qc1wiO1xuaW1wb3J0IG5vbkl0ZXJhYmxlU3ByZWFkIGZyb20gXCIuL25vbkl0ZXJhYmxlU3ByZWFkLmpzXCI7XG5leHBvcnQgZGVmYXVsdCBmdW5jdGlvbiBfdG9Db25zdW1hYmxlQXJyYXkoYXJyKSB7XG4gIHJldHVybiBhcnJheVdpdGhvdXRIb2xlcyhhcnIpIHx8IGl0ZXJhYmxlVG9BcnJheShhcnIpIHx8IHVuc3VwcG9ydGVkSXRlcmFibGVUb0FycmF5KGFycikgfHwgbm9uSXRlcmFibGVTcHJlYWQoKTtcbn0iLCJpbXBvcnQgYXJyYXlMaWtlVG9BcnJheSBmcm9tIFwiLi9hcnJheUxpa2VUb0FycmF5LmpzXCI7XG5leHBvcnQgZGVmYXVsdCBmdW5jdGlvbiBfdW5zdXBwb3J0ZWRJdGVyYWJsZVRvQXJyYXkobywgbWluTGVuKSB7XG4gIGlmICghbykgcmV0dXJuO1xuICBpZiAodHlwZW9mIG8gPT09IFwic3RyaW5nXCIpIHJldHVybiBhcnJheUxpa2VUb0FycmF5KG8sIG1pbkxlbik7XG4gIHZhciBuID0gT2JqZWN0LnByb3RvdHlwZS50b1N0cmluZy5jYWxsKG8pLnNsaWNlKDgsIC0xKTtcbiAgaWYgKG4gPT09IFwiT2JqZWN0XCIgJiYgby5jb25zdHJ1Y3RvcikgbiA9IG8uY29uc3RydWN0b3IubmFtZTtcbiAgaWYgKG4gPT09IFwiTWFwXCIgfHwgbiA9PT0gXCJTZXRcIikgcmV0dXJuIEFycmF5LmZyb20obyk7XG4gIGlmIChuID09PSBcIkFyZ3VtZW50c1wiIHx8IC9eKD86VWl8SSludCg/Ojh8MTZ8MzIpKD86Q2xhbXBlZCk/QXJyYXkkLy50ZXN0KG4pKSByZXR1cm4gYXJyYXlMaWtlVG9BcnJheShvLCBtaW5MZW4pO1xufSIsIm1vZHVsZS5leHBvcnRzID0gcmVxdWlyZShcInJlZ2VuZXJhdG9yLXJ1bnRpbWVcIik7XG4iLCJleHBvcnQgZW51bSBNZXNzYWdlc1RvTmF0aXZlQXBwIHtcbiAgICBXcml0ZUluTmF0aXZlTG9nID0gJ3dyaXRlSW5OYXRpdmVMb2cnLFxuICAgIEdldEFkdmFuY2VkUnVsZXNUZXh0ID0gJ2dldF9hZHZhbmNlZF9ydWxlc190ZXh0JyxcbiAgICBHZXRJbml0RGF0YSA9ICdnZXRfaW5pdF9kYXRhJyxcbiAgICBTaG91bGRVcGRhdGVBZHZhbmNlZFJ1bGVzID0gJ3Nob3VsZF91cGRhdGVfYWR2YW5jZWRfcnVsZXMnLFxufVxuXG5leHBvcnQgZW51bSBNZXNzYWdlc1RvQmFja2dyb3VuZFBhZ2Uge1xuICAgIE9wZW5Bc3Npc3RhbnQgPSAnb3Blbl9hc3Npc3RhbnQnLFxuICAgIEdldFNjcmlwdHNBbmRTZWxlY3RvcnMgPSAnZ2V0X3NjcmlwdHNfYW5kX3NlbGVjdG9ycycsXG4gICAgQWRkUnVsZSA9ICdhZGRfcnVsZScsXG4gICAgR2V0UG9wdXBEYXRhID0gJ2dldF9wb3B1cF9kYXRhJyxcbiAgICBTZXRQZXJtaXNzaW9uc01vZGFsVmlld2VkID0gJ3NldF9wZXJtaXNzaW9uc19tb2RhbF92aWV3ZWQnLFxuICAgIFNldFByb3RlY3Rpb25TdGF0dXMgPSAnc2V0X3Byb3RlY3Rpb25fc3RhdHVzJyxcbiAgICBEZWxldGVVc2VyUnVsZXNCeVVybCA9ICdkZWxldGVfdXNlcl9ydWxlc19ieV91cmwnLFxuICAgIFJlcG9ydFByb2JsZW0gPSAncmVwb3J0X3Byb2JsZW0nLFxuICAgIFVwZ3JhZGVDbGlja2VkID0gJ3VwZ3JhZGVfY2xpY2tlZCcsXG4gICAgRW5hYmxlQWR2YW5jZWRCbG9ja2luZyA9ICdlbmFibGVfYWR2YW5jZWRfYmxvY2tpbmcnLFxuICAgIEVuYWJsZVNhZmFyaVByb3RlY3Rpb24gPSAnZW5hYmxlX3NhZmFyaV9wcm90ZWN0aW9uJyxcbn1cblxuZXhwb3J0IGVudW0gTWVzc2FnZXNUb0NvbnRlbnRTY3JpcHQge1xuICAgIEluaXRBc3Npc3RhbnQgPSAnaW5pdF9hc3Npc3RhbnQnLFxufVxuXG5leHBvcnQgZW51bSBBcHBlYXJhbmNlVGhlbWUge1xuICAgIFN5c3RlbSA9ICdzeXN0ZW0nLFxuICAgIERhcmsgPSAnZGFyaycsXG4gICAgTGlnaHQgPSAnbGlnaHQnLFxufVxuXG5leHBvcnQgY29uc3QgQVBQRUFSQU5DRV9USEVNRV9ERUZBVUxUID0gQXBwZWFyYW5jZVRoZW1lLlN5c3RlbTtcblxuZXhwb3J0IGNvbnN0IFdFQl9FWFRFTlNJT05fTU9SRV9VUkwgPSAnaHR0cHM6Ly9saW5rLmFkdGlkeS5vcmcvZm9yd2FyZC5odG1sP2FjdGlvbj13ZWJfZXh0ZW5zaW9uX21vcmUmZnJvbT1wb3B1cCZhcHA9aW9zJztcblxuZXhwb3J0IGVudW0gUGxhdGZvcm0ge1xuICAgIElQYWQgPSAnaXBhZCcsXG4gICAgSVBob25lID0gJ2lwaG9uZScsXG59XG4iLCIvKiBlc2xpbnQtZGlzYWJsZSBuby1jb25zb2xlICovXG5pbXBvcnQgYnJvd3NlciBmcm9tICd3ZWJleHRlbnNpb24tcG9seWZpbGwnO1xuaW1wb3J0IHsgRXh0ZW5kZWRDc3MgfSBmcm9tICdAYWRndWFyZC9leHRlbmRlZC1jc3MnO1xuXG5pbXBvcnQgeyBNZXNzYWdlc1RvQmFja2dyb3VuZFBhZ2UgfSBmcm9tICcuLi9jb21tb24vY29uc3RhbnRzJztcbmltcG9ydCB7IFNlbGVjdG9yc0FuZFNjcmlwdHMgfSBmcm9tICcuLi9jb21tb24vaW50ZXJmYWNlcyc7XG5cbi8qKlxuICogTG9ncyBhIG1lc3NhZ2UgaWYgdmVyYm9zZSBpcyB0cnVlXG4gKlxuICogQHBhcmFtIHZlcmJvc2VcbiAqIEBwYXJhbSBtZXNzYWdlXG4gKi9cbmNvbnN0IGxvZ01lc3NhZ2UgPSAodmVyYm9zZTogYm9vbGVhbiwgbWVzc2FnZTogc3RyaW5nKSA9PiB7XG4gICAgaWYgKHZlcmJvc2UpIHtcbiAgICAgICAgY29uc29sZS5sb2coYChBRykgJHttZXNzYWdlfWApO1xuICAgIH1cbn07XG5cbmNvbnN0IGdldFNlbGVjdG9yc0FuZFNjcmlwdHMgPSBhc3luYyAoKTogUHJvbWlzZTxTZWxlY3RvcnNBbmRTY3JpcHRzIHwgbnVsbD4gPT4ge1xuICAgIGNvbnN0IHJlc3BvbnNlID0gYXdhaXQgYnJvd3Nlci5ydW50aW1lLnNlbmRNZXNzYWdlKHtcbiAgICAgICAgdHlwZTogTWVzc2FnZXNUb0JhY2tncm91bmRQYWdlLkdldFNjcmlwdHNBbmRTZWxlY3RvcnMsXG4gICAgICAgIGRhdGE6IHtcbiAgICAgICAgICAgIHVybDogd2luZG93LmxvY2F0aW9uLmhyZWYsXG4gICAgICAgIH0sXG4gICAgfSk7XG5cbiAgICBpZiAocmVzcG9uc2UgPT09IG51bGwpIHtcbiAgICAgICAgY29uc29sZS5sb2coJ0FHOiBubyBzY3JpcHRzIGFuZCBzZWxlY3RvcnMgcmVjZWl2ZWQnKTtcbiAgICAgICAgcmV0dXJuIG51bGw7XG4gICAgfVxuXG4gICAgcmV0dXJuIHJlc3BvbnNlIGFzIFNlbGVjdG9yc0FuZFNjcmlwdHM7XG59O1xuXG4vKipcbiAqIEV4ZWN1dGUgc2NyaXB0cyBpbiBhIHBhZ2UgY29udGV4dCBhbmQgY2xlYW51cCBpdHNlbGYgd2hlbiBleGVjdXRpb24gY29tcGxldGVzXG4gKiBAcGFyYW0gc2NyaXB0cyBTY3JpcHRzIGFycmF5IHRvIGV4ZWN1dGVcbiAqL1xuY29uc3QgZXhlY3V0ZVNjcmlwdHMgPSAoc2NyaXB0czogc3RyaW5nW10pID0+IHtcbiAgICAvLyBXcmFwIHdpdGggdHJ5IGNhdGNoXG4gICAgY29uc3Qgc3RhcnQgPSAnKCBmdW5jdGlvbiAoKSB7IHRyeSB7JztcbiAgICBjb25zdCBlbmQgPSBcIn0gY2F0Y2ggKGV4KSB7IGNvbnNvbGUuZXJyb3IoJ0Vycm9yIGV4ZWN1dGluZyBBRyBqczogJyArIGV4KTsgfSB9KSgpO1wiO1xuXG4gICAgY29uc3QgdXBkYXRlZCA9IFtzdGFydCwgLi4uc2NyaXB0cywgZW5kXTtcblxuICAgIGNvbnN0IHNjcmlwdFRhZyA9IGRvY3VtZW50LmNyZWF0ZUVsZW1lbnQoJ3NjcmlwdCcpO1xuICAgIHNjcmlwdFRhZy5zZXRBdHRyaWJ1dGUoJ3R5cGUnLCAndGV4dC9qYXZhc2NyaXB0Jyk7XG4gICAgc2NyaXB0VGFnLnRleHRDb250ZW50ID0gdXBkYXRlZC5qb2luKCdcXHJcXG4nKTtcblxuICAgIGNvbnN0IHBhcmVudCA9IGRvY3VtZW50LmhlYWQgfHwgZG9jdW1lbnQuZG9jdW1lbnRFbGVtZW50O1xuICAgIHBhcmVudC5hcHBlbmRDaGlsZChzY3JpcHRUYWcpO1xuICAgIGlmIChzY3JpcHRUYWcucGFyZW50Tm9kZSkge1xuICAgICAgICBzY3JpcHRUYWcucGFyZW50Tm9kZS5yZW1vdmVDaGlsZChzY3JpcHRUYWcpO1xuICAgIH1cbn07XG5cbi8qKlxuICogQXBwbGllcyBKUyBpbmplY3Rpb25zLlxuICogQHBhcmFtIHNjcmlwdHMgQXJyYXkgd2l0aCBKUyBzY3JpcHRzXG4gKiBAcGFyYW0gdmVyYm9zZSBsb2dnaW5nXG4gKi9cbmNvbnN0IGFwcGx5U2NyaXB0cyA9IChzY3JpcHRzOiBzdHJpbmdbXSwgdmVyYm9zZTogYm9vbGVhbikgPT4ge1xuICAgIGlmICghc2NyaXB0cyB8fCBzY3JpcHRzLmxlbmd0aCA9PT0gMCkge1xuICAgICAgICByZXR1cm47XG4gICAgfVxuXG4gICAgbG9nTWVzc2FnZSh2ZXJib3NlLCBgc2NyaXB0cyBsZW5ndGg6ICR7c2NyaXB0cy5sZW5ndGh9YCk7XG4gICAgZXhlY3V0ZVNjcmlwdHMoc2NyaXB0cyk7XG59O1xuXG4vKipcbiAqIFByb3RlY3RzIHNwZWNpZmllZCBzdHlsZSBlbGVtZW50IGZyb20gY2hhbmdlcyB0byB0aGUgY3VycmVudCBkb2N1bWVudFxuICogQWRkIGEgbXV0YXRpb24gb2JzZXJ2ZXIsIHdoaWNoIGlzIGFkZHMgb3VyIHJ1bGVzIGFnYWluIGlmIGl0IHdhcyByZW1vdmVkXG4gKlxuICogQHBhcmFtIHByb3RlY3RTdHlsZUVsIHByb3RlY3RlZCBzdHlsZSBlbGVtZW50XG4gKi9cbmNvbnN0IHByb3RlY3RTdHlsZUVsZW1lbnRDb250ZW50ID0gKHByb3RlY3RTdHlsZUVsOiBOb2RlKSA9PiB7XG4gICAgLy8gQHRzLWlnbm9yZVxuICAgIGNvbnN0IE11dGF0aW9uT2JzZXJ2ZXIgPSB3aW5kb3cuTXV0YXRpb25PYnNlcnZlciB8fCB3aW5kb3cuV2ViS2l0TXV0YXRpb25PYnNlcnZlcjtcbiAgICBpZiAoIU11dGF0aW9uT2JzZXJ2ZXIpIHtcbiAgICAgICAgcmV0dXJuO1xuICAgIH1cbiAgICAvKiBvYnNlcnZlciwgd2hpY2ggb2JzZXJ2ZSBwcm90ZWN0U3R5bGVFbCBpbm5lciBjaGFuZ2VzLCB3aXRob3V0IGRlbGV0aW5nIHN0eWxlRWwgKi9cbiAgICBjb25zdCBpbm5lck9ic2VydmVyID0gbmV3IE11dGF0aW9uT2JzZXJ2ZXIoKChtdXRhdGlvbnMpID0+IHtcbiAgICAgICAgZm9yIChsZXQgaSA9IDA7IGkgPCBtdXRhdGlvbnMubGVuZ3RoOyBpICs9IDEpIHtcbiAgICAgICAgICAgIGNvbnN0IG0gPSBtdXRhdGlvbnNbaV07XG4gICAgICAgICAgICAvLyBAdHMtaWdub3JlXG4gICAgICAgICAgICBpZiAocHJvdGVjdFN0eWxlRWwuaGFzQXR0cmlidXRlKCdtb2QnKSAmJiBwcm90ZWN0U3R5bGVFbC5nZXRBdHRyaWJ1dGUoJ21vZCcpID09PSAnaW5uZXInKSB7XG4gICAgICAgICAgICAgICAgLy8gQHRzLWlnbm9yZVxuICAgICAgICAgICAgICAgIHByb3RlY3RTdHlsZUVsLnJlbW92ZUF0dHJpYnV0ZSgnbW9kJyk7XG4gICAgICAgICAgICAgICAgYnJlYWs7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIC8vIEB0cy1pZ25vcmVcbiAgICAgICAgICAgIHByb3RlY3RTdHlsZUVsLnNldEF0dHJpYnV0ZSgnbW9kJywgJ2lubmVyJyk7XG4gICAgICAgICAgICBsZXQgaXNQcm90ZWN0U3R5bGVFbE1vZGlmaWVkID0gZmFsc2U7XG5cbiAgICAgICAgICAgIC8qKlxuICAgICAgICAgICAgICogZnVydGhlciwgdGhlcmUgYXJlIHR3byBtdXR1YWxseSBleGNsdXNpdmUgc2l0dWF0aW9uczogZWl0aGVyIHRoZXJlIHdlcmUgY2hhbmdlc1xuICAgICAgICAgICAgICogdGhlIHRleHQgb2YgcHJvdGVjdFN0eWxlRWwsIGVpdGhlciB0aGVyZSB3YXMgcmVtb3ZlcyBhIHdob2xlIGNoaWxkIFwidGV4dFwiXG4gICAgICAgICAgICAgKiBlbGVtZW50IG9mIHByb3RlY3RTdHlsZUVsIHdlJ2xsIHByb2Nlc3MgYm90aCBvZiB0aGVtXG4gICAgICAgICAgICAgKi9cbiAgICAgICAgICAgIGlmIChtLnJlbW92ZWROb2Rlcy5sZW5ndGggPiAwKSB7XG4gICAgICAgICAgICAgICAgZm9yIChsZXQgaiA9IDA7IGogPCBtLnJlbW92ZWROb2Rlcy5sZW5ndGg7IGogKz0gMSkge1xuICAgICAgICAgICAgICAgICAgICBpc1Byb3RlY3RTdHlsZUVsTW9kaWZpZWQgPSB0cnVlO1xuICAgICAgICAgICAgICAgICAgICBwcm90ZWN0U3R5bGVFbC5hcHBlbmRDaGlsZChtLnJlbW92ZWROb2Rlc1tqXSk7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfSBlbHNlIGlmIChtLm9sZFZhbHVlKSB7XG4gICAgICAgICAgICAgICAgaXNQcm90ZWN0U3R5bGVFbE1vZGlmaWVkID0gdHJ1ZTtcbiAgICAgICAgICAgICAgICAvLyBlc2xpbnQtZGlzYWJsZS1uZXh0LWxpbmUgbm8tcGFyYW0tcmVhc3NpZ25cbiAgICAgICAgICAgICAgICBwcm90ZWN0U3R5bGVFbC50ZXh0Q29udGVudCA9IG0ub2xkVmFsdWU7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIGlmICghaXNQcm90ZWN0U3R5bGVFbE1vZGlmaWVkKSB7XG4gICAgICAgICAgICAgICAgLy8gQHRzLWlnbm9yZVxuICAgICAgICAgICAgICAgIHByb3RlY3RTdHlsZUVsLnJlbW92ZUF0dHJpYnV0ZSgnbW9kJyk7XG4gICAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICB9KSk7XG5cbiAgICBpbm5lck9ic2VydmVyLm9ic2VydmUocHJvdGVjdFN0eWxlRWwsIHtcbiAgICAgICAgY2hpbGRMaXN0OiB0cnVlLFxuICAgICAgICBjaGFyYWN0ZXJEYXRhOiB0cnVlLFxuICAgICAgICBzdWJ0cmVlOiB0cnVlLFxuICAgICAgICBjaGFyYWN0ZXJEYXRhT2xkVmFsdWU6IHRydWUsXG4gICAgfSk7XG59O1xuXG4vKipcbiAqIEFwcGxpZXMgY3NzIHN0eWxlc2hlZXRcbiAqIEBwYXJhbSBzdHlsZVNlbGVjdG9ycyBBcnJheSBvZiBzdHlsZXNoZWV0cyBvciBzZWxlY3RvcnNcbiAqIEBwYXJhbSB2ZXJib3NlIGxvZ2dpbmdcbiAqL1xuY29uc3QgYXBwbHlDc3MgPSAoc3R5bGVTZWxlY3RvcnM6IHN0cmluZ1tdLCB2ZXJib3NlOiBib29sZWFuKSA9PiB7XG4gICAgaWYgKCFzdHlsZVNlbGVjdG9ycyB8fCAhc3R5bGVTZWxlY3RvcnMubGVuZ3RoKSB7XG4gICAgICAgIHJldHVybjtcbiAgICB9XG5cbiAgICBsb2dNZXNzYWdlKHZlcmJvc2UsIGBjc3MgbGVuZ3RoOiAke3N0eWxlU2VsZWN0b3JzLmxlbmd0aH1gKTtcblxuICAgIGNvbnN0IHN0eWxlRWxlbWVudCA9IGRvY3VtZW50LmNyZWF0ZUVsZW1lbnQoJ3N0eWxlJyk7XG4gICAgc3R5bGVFbGVtZW50LnNldEF0dHJpYnV0ZSgndHlwZScsICd0ZXh0L2NzcycpO1xuICAgIChkb2N1bWVudC5oZWFkIHx8IGRvY3VtZW50LmRvY3VtZW50RWxlbWVudCkuYXBwZW5kQ2hpbGQoc3R5bGVFbGVtZW50KTtcblxuICAgIGNvbnN0IHNlbGVjdG9ycyA9IHN0eWxlU2VsZWN0b3JzLm1hcCgocykgPT4gcy50cmltKCkpO1xuXG4gICAgc2VsZWN0b3JzLmZvckVhY2goKHNlbGVjdG9yKSA9PiB7XG4gICAgICAgIHRyeSB7XG4gICAgICAgICAgICBzdHlsZUVsZW1lbnQuc2hlZXQ/Lmluc2VydFJ1bGUoc2VsZWN0b3IpO1xuICAgICAgICB9IGNhdGNoIChlKSB7XG4gICAgICAgICAgICBsb2dNZXNzYWdlKHZlcmJvc2UsIGBXYXMgdW5hYmxlIHRvIGluamVjdCBzZWxlY3RvcjogJHtzZWxlY3Rvcn0sIGR1ZSB0byBlcnJvcjogJHtlfWApO1xuICAgICAgICB9XG4gICAgfSk7XG5cbiAgICBwcm90ZWN0U3R5bGVFbGVtZW50Q29udGVudChzdHlsZUVsZW1lbnQpO1xufTtcblxuLyoqXG4gKiBBcHBsaWVzIEV4dGVuZGVkIENzcyBzdHlsZXNoZWV0XG4gKlxuICogQHBhcmFtIGV4dGVuZGVkQ3NzIEFycmF5IHdpdGggRXh0ZW5kZWRDc3Mgc3R5bGVzaGVldHNcbiAqIEBwYXJhbSB2ZXJib3NlIGxvZ2dpbmdcbiAqL1xuY29uc3QgYXBwbHlFeHRlbmRlZENzcyA9IChleHRlbmRlZENzczogc3RyaW5nW10sIHZlcmJvc2U6IGJvb2xlYW4pID0+IHtcbiAgICBpZiAoIWV4dGVuZGVkQ3NzIHx8ICFleHRlbmRlZENzcy5sZW5ndGgpIHtcbiAgICAgICAgcmV0dXJuO1xuICAgIH1cblxuICAgIGxvZ01lc3NhZ2UodmVyYm9zZSwgYGV4dGVuZGVkIGNzcyBsZW5ndGg6ICR7ZXh0ZW5kZWRDc3MubGVuZ3RofWApO1xuICAgIGNvbnN0IGV4dENzcyA9IG5ldyBFeHRlbmRlZENzcyh7XG4gICAgICAgIHN0eWxlU2hlZXQ6IGV4dGVuZGVkQ3NzXG4gICAgICAgICAgICAuZmlsdGVyKChzKSA9PiBzLmxlbmd0aCA+IDApXG4gICAgICAgICAgICAubWFwKChzKSA9PiBzLnRyaW0oKSlcbiAgICAgICAgICAgIC5tYXAoKHMpID0+IChzW3MubGVuZ3RoIC0gMV0gIT09ICd9JyA/IGAke3N9IHtkaXNwbGF5Om5vbmUhaW1wb3J0YW50O31gIDogcykpXG4gICAgICAgICAgICAuam9pbignXFxuJyksXG4gICAgfSk7XG4gICAgZXh0Q3NzLmFwcGx5KCk7XG59O1xuXG4vKipcbiAqIEFwcGxpZXMgaW5qZWN0ZWQgc2NyaXB0IGFuZCBjc3NcbiAqXG4gKiBAcGFyYW0gc2VsZWN0b3JzQW5kU2NyaXB0c1xuICogQHBhcmFtIHZlcmJvc2VcbiAqL1xuY29uc3QgYXBwbHlBZHZhbmNlZEJsb2NraW5nRGF0YSA9IChzZWxlY3RvcnNBbmRTY3JpcHRzOiBTZWxlY3RvcnNBbmRTY3JpcHRzLCB2ZXJib3NlID0gdHJ1ZSkgPT4ge1xuICAgIGxvZ01lc3NhZ2UodmVyYm9zZSwgJ0FwcGx5aW5nIHNjcmlwdHMgYW5kIGNzcy4uJyk7XG4gICAgbG9nTWVzc2FnZSh2ZXJib3NlLCBgRnJhbWUgdXJsOiAke3dpbmRvdy5sb2NhdGlvbi5ocmVmfWApO1xuXG4gICAgYXBwbHlTY3JpcHRzKHNlbGVjdG9yc0FuZFNjcmlwdHMuc2NyaXB0cywgdmVyYm9zZSk7XG4gICAgYXBwbHlDc3Moc2VsZWN0b3JzQW5kU2NyaXB0cy5jc3NJbmplY3QsIHZlcmJvc2UpO1xuICAgIGFwcGx5RXh0ZW5kZWRDc3Moc2VsZWN0b3JzQW5kU2NyaXB0cy5jc3NFeHRlbmRlZCwgdmVyYm9zZSk7XG5cbiAgICBsb2dNZXNzYWdlKHZlcmJvc2UsICdBcHBseWluZyBzY3JpcHRzIGFuZCBjc3MgLSBkb25lJyk7XG59O1xuXG5jb25zdCBpbml0ID0gYXN5bmMgKCkgPT4ge1xuICAgIGlmIChkb2N1bWVudCBpbnN0YW5jZW9mIEhUTUxEb2N1bWVudCkge1xuICAgICAgICBpZiAod2luZG93LmxvY2F0aW9uLmhyZWYgJiYgd2luZG93LmxvY2F0aW9uLmhyZWYuaW5kZXhPZignaHR0cCcpID09PSAwKSB7XG4gICAgICAgICAgICBjb25zdCBzdGFydEdldHRpbmdTY3JpcHRzID0gRGF0ZS5ub3coKTtcbiAgICAgICAgICAgIGxldCBzZWxlY3RvcnNBbmRTY3JpcHRzO1xuICAgICAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgICAgICBzZWxlY3RvcnNBbmRTY3JpcHRzID0gYXdhaXQgZ2V0U2VsZWN0b3JzQW5kU2NyaXB0cygpO1xuICAgICAgICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKGUpO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICBjb25zb2xlLmxvZyhgVGltZSB0byBnZXQgc2VsZWN0b3JzIGFuZCBzY3JpcHRzIGZyb20gbmF0aXZlIHBhZ2UgdG8gY29udGVudCBzY3JpcHQ6ICR7RGF0ZS5ub3coKSAtIHN0YXJ0R2V0dGluZ1NjcmlwdHN9IG1zYCk7XG5cbiAgICAgICAgICAgIGlmIChzZWxlY3RvcnNBbmRTY3JpcHRzKSB7XG4gICAgICAgICAgICAgICAgYXBwbHlBZHZhbmNlZEJsb2NraW5nRGF0YShzZWxlY3RvcnNBbmRTY3JpcHRzLCBmYWxzZSk7XG4gICAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICB9XG59O1xuXG5leHBvcnQgY29uc3QgY29udGVudCA9IHtcbiAgICBpbml0LFxufTtcbiIsIi8qKlxuICogQ29weXJpZ2h0IChjKSAyMDE0LXByZXNlbnQsIEZhY2Vib29rLCBJbmMuXG4gKlxuICogVGhpcyBzb3VyY2UgY29kZSBpcyBsaWNlbnNlZCB1bmRlciB0aGUgTUlUIGxpY2Vuc2UgZm91bmQgaW4gdGhlXG4gKiBMSUNFTlNFIGZpbGUgaW4gdGhlIHJvb3QgZGlyZWN0b3J5IG9mIHRoaXMgc291cmNlIHRyZWUuXG4gKi9cblxudmFyIHJ1bnRpbWUgPSAoZnVuY3Rpb24gKGV4cG9ydHMpIHtcbiAgXCJ1c2Ugc3RyaWN0XCI7XG5cbiAgdmFyIE9wID0gT2JqZWN0LnByb3RvdHlwZTtcbiAgdmFyIGhhc093biA9IE9wLmhhc093blByb3BlcnR5O1xuICB2YXIgdW5kZWZpbmVkOyAvLyBNb3JlIGNvbXByZXNzaWJsZSB0aGFuIHZvaWQgMC5cbiAgdmFyICRTeW1ib2wgPSB0eXBlb2YgU3ltYm9sID09PSBcImZ1bmN0aW9uXCIgPyBTeW1ib2wgOiB7fTtcbiAgdmFyIGl0ZXJhdG9yU3ltYm9sID0gJFN5bWJvbC5pdGVyYXRvciB8fCBcIkBAaXRlcmF0b3JcIjtcbiAgdmFyIGFzeW5jSXRlcmF0b3JTeW1ib2wgPSAkU3ltYm9sLmFzeW5jSXRlcmF0b3IgfHwgXCJAQGFzeW5jSXRlcmF0b3JcIjtcbiAgdmFyIHRvU3RyaW5nVGFnU3ltYm9sID0gJFN5bWJvbC50b1N0cmluZ1RhZyB8fCBcIkBAdG9TdHJpbmdUYWdcIjtcblxuICBmdW5jdGlvbiBkZWZpbmUob2JqLCBrZXksIHZhbHVlKSB7XG4gICAgT2JqZWN0LmRlZmluZVByb3BlcnR5KG9iaiwga2V5LCB7XG4gICAgICB2YWx1ZTogdmFsdWUsXG4gICAgICBlbnVtZXJhYmxlOiB0cnVlLFxuICAgICAgY29uZmlndXJhYmxlOiB0cnVlLFxuICAgICAgd3JpdGFibGU6IHRydWVcbiAgICB9KTtcbiAgICByZXR1cm4gb2JqW2tleV07XG4gIH1cbiAgdHJ5IHtcbiAgICAvLyBJRSA4IGhhcyBhIGJyb2tlbiBPYmplY3QuZGVmaW5lUHJvcGVydHkgdGhhdCBvbmx5IHdvcmtzIG9uIERPTSBvYmplY3RzLlxuICAgIGRlZmluZSh7fSwgXCJcIik7XG4gIH0gY2F0Y2ggKGVycikge1xuICAgIGRlZmluZSA9IGZ1bmN0aW9uKG9iaiwga2V5LCB2YWx1ZSkge1xuICAgICAgcmV0dXJuIG9ialtrZXldID0gdmFsdWU7XG4gICAgfTtcbiAgfVxuXG4gIGZ1bmN0aW9uIHdyYXAoaW5uZXJGbiwgb3V0ZXJGbiwgc2VsZiwgdHJ5TG9jc0xpc3QpIHtcbiAgICAvLyBJZiBvdXRlckZuIHByb3ZpZGVkIGFuZCBvdXRlckZuLnByb3RvdHlwZSBpcyBhIEdlbmVyYXRvciwgdGhlbiBvdXRlckZuLnByb3RvdHlwZSBpbnN0YW5jZW9mIEdlbmVyYXRvci5cbiAgICB2YXIgcHJvdG9HZW5lcmF0b3IgPSBvdXRlckZuICYmIG91dGVyRm4ucHJvdG90eXBlIGluc3RhbmNlb2YgR2VuZXJhdG9yID8gb3V0ZXJGbiA6IEdlbmVyYXRvcjtcbiAgICB2YXIgZ2VuZXJhdG9yID0gT2JqZWN0LmNyZWF0ZShwcm90b0dlbmVyYXRvci5wcm90b3R5cGUpO1xuICAgIHZhciBjb250ZXh0ID0gbmV3IENvbnRleHQodHJ5TG9jc0xpc3QgfHwgW10pO1xuXG4gICAgLy8gVGhlIC5faW52b2tlIG1ldGhvZCB1bmlmaWVzIHRoZSBpbXBsZW1lbnRhdGlvbnMgb2YgdGhlIC5uZXh0LFxuICAgIC8vIC50aHJvdywgYW5kIC5yZXR1cm4gbWV0aG9kcy5cbiAgICBnZW5lcmF0b3IuX2ludm9rZSA9IG1ha2VJbnZva2VNZXRob2QoaW5uZXJGbiwgc2VsZiwgY29udGV4dCk7XG5cbiAgICByZXR1cm4gZ2VuZXJhdG9yO1xuICB9XG4gIGV4cG9ydHMud3JhcCA9IHdyYXA7XG5cbiAgLy8gVHJ5L2NhdGNoIGhlbHBlciB0byBtaW5pbWl6ZSBkZW9wdGltaXphdGlvbnMuIFJldHVybnMgYSBjb21wbGV0aW9uXG4gIC8vIHJlY29yZCBsaWtlIGNvbnRleHQudHJ5RW50cmllc1tpXS5jb21wbGV0aW9uLiBUaGlzIGludGVyZmFjZSBjb3VsZFxuICAvLyBoYXZlIGJlZW4gKGFuZCB3YXMgcHJldmlvdXNseSkgZGVzaWduZWQgdG8gdGFrZSBhIGNsb3N1cmUgdG8gYmVcbiAgLy8gaW52b2tlZCB3aXRob3V0IGFyZ3VtZW50cywgYnV0IGluIGFsbCB0aGUgY2FzZXMgd2UgY2FyZSBhYm91dCB3ZVxuICAvLyBhbHJlYWR5IGhhdmUgYW4gZXhpc3RpbmcgbWV0aG9kIHdlIHdhbnQgdG8gY2FsbCwgc28gdGhlcmUncyBubyBuZWVkXG4gIC8vIHRvIGNyZWF0ZSBhIG5ldyBmdW5jdGlvbiBvYmplY3QuIFdlIGNhbiBldmVuIGdldCBhd2F5IHdpdGggYXNzdW1pbmdcbiAgLy8gdGhlIG1ldGhvZCB0YWtlcyBleGFjdGx5IG9uZSBhcmd1bWVudCwgc2luY2UgdGhhdCBoYXBwZW5zIHRvIGJlIHRydWVcbiAgLy8gaW4gZXZlcnkgY2FzZSwgc28gd2UgZG9uJ3QgaGF2ZSB0byB0b3VjaCB0aGUgYXJndW1lbnRzIG9iamVjdC4gVGhlXG4gIC8vIG9ubHkgYWRkaXRpb25hbCBhbGxvY2F0aW9uIHJlcXVpcmVkIGlzIHRoZSBjb21wbGV0aW9uIHJlY29yZCwgd2hpY2hcbiAgLy8gaGFzIGEgc3RhYmxlIHNoYXBlIGFuZCBzbyBob3BlZnVsbHkgc2hvdWxkIGJlIGNoZWFwIHRvIGFsbG9jYXRlLlxuICBmdW5jdGlvbiB0cnlDYXRjaChmbiwgb2JqLCBhcmcpIHtcbiAgICB0cnkge1xuICAgICAgcmV0dXJuIHsgdHlwZTogXCJub3JtYWxcIiwgYXJnOiBmbi5jYWxsKG9iaiwgYXJnKSB9O1xuICAgIH0gY2F0Y2ggKGVycikge1xuICAgICAgcmV0dXJuIHsgdHlwZTogXCJ0aHJvd1wiLCBhcmc6IGVyciB9O1xuICAgIH1cbiAgfVxuXG4gIHZhciBHZW5TdGF0ZVN1c3BlbmRlZFN0YXJ0ID0gXCJzdXNwZW5kZWRTdGFydFwiO1xuICB2YXIgR2VuU3RhdGVTdXNwZW5kZWRZaWVsZCA9IFwic3VzcGVuZGVkWWllbGRcIjtcbiAgdmFyIEdlblN0YXRlRXhlY3V0aW5nID0gXCJleGVjdXRpbmdcIjtcbiAgdmFyIEdlblN0YXRlQ29tcGxldGVkID0gXCJjb21wbGV0ZWRcIjtcblxuICAvLyBSZXR1cm5pbmcgdGhpcyBvYmplY3QgZnJvbSB0aGUgaW5uZXJGbiBoYXMgdGhlIHNhbWUgZWZmZWN0IGFzXG4gIC8vIGJyZWFraW5nIG91dCBvZiB0aGUgZGlzcGF0Y2ggc3dpdGNoIHN0YXRlbWVudC5cbiAgdmFyIENvbnRpbnVlU2VudGluZWwgPSB7fTtcblxuICAvLyBEdW1teSBjb25zdHJ1Y3RvciBmdW5jdGlvbnMgdGhhdCB3ZSB1c2UgYXMgdGhlIC5jb25zdHJ1Y3RvciBhbmRcbiAgLy8gLmNvbnN0cnVjdG9yLnByb3RvdHlwZSBwcm9wZXJ0aWVzIGZvciBmdW5jdGlvbnMgdGhhdCByZXR1cm4gR2VuZXJhdG9yXG4gIC8vIG9iamVjdHMuIEZvciBmdWxsIHNwZWMgY29tcGxpYW5jZSwgeW91IG1heSB3aXNoIHRvIGNvbmZpZ3VyZSB5b3VyXG4gIC8vIG1pbmlmaWVyIG5vdCB0byBtYW5nbGUgdGhlIG5hbWVzIG9mIHRoZXNlIHR3byBmdW5jdGlvbnMuXG4gIGZ1bmN0aW9uIEdlbmVyYXRvcigpIHt9XG4gIGZ1bmN0aW9uIEdlbmVyYXRvckZ1bmN0aW9uKCkge31cbiAgZnVuY3Rpb24gR2VuZXJhdG9yRnVuY3Rpb25Qcm90b3R5cGUoKSB7fVxuXG4gIC8vIFRoaXMgaXMgYSBwb2x5ZmlsbCBmb3IgJUl0ZXJhdG9yUHJvdG90eXBlJSBmb3IgZW52aXJvbm1lbnRzIHRoYXRcbiAgLy8gZG9uJ3QgbmF0aXZlbHkgc3VwcG9ydCBpdC5cbiAgdmFyIEl0ZXJhdG9yUHJvdG90eXBlID0ge307XG4gIEl0ZXJhdG9yUHJvdG90eXBlW2l0ZXJhdG9yU3ltYm9sXSA9IGZ1bmN0aW9uICgpIHtcbiAgICByZXR1cm4gdGhpcztcbiAgfTtcblxuICB2YXIgZ2V0UHJvdG8gPSBPYmplY3QuZ2V0UHJvdG90eXBlT2Y7XG4gIHZhciBOYXRpdmVJdGVyYXRvclByb3RvdHlwZSA9IGdldFByb3RvICYmIGdldFByb3RvKGdldFByb3RvKHZhbHVlcyhbXSkpKTtcbiAgaWYgKE5hdGl2ZUl0ZXJhdG9yUHJvdG90eXBlICYmXG4gICAgICBOYXRpdmVJdGVyYXRvclByb3RvdHlwZSAhPT0gT3AgJiZcbiAgICAgIGhhc093bi5jYWxsKE5hdGl2ZUl0ZXJhdG9yUHJvdG90eXBlLCBpdGVyYXRvclN5bWJvbCkpIHtcbiAgICAvLyBUaGlzIGVudmlyb25tZW50IGhhcyBhIG5hdGl2ZSAlSXRlcmF0b3JQcm90b3R5cGUlOyB1c2UgaXQgaW5zdGVhZFxuICAgIC8vIG9mIHRoZSBwb2x5ZmlsbC5cbiAgICBJdGVyYXRvclByb3RvdHlwZSA9IE5hdGl2ZUl0ZXJhdG9yUHJvdG90eXBlO1xuICB9XG5cbiAgdmFyIEdwID0gR2VuZXJhdG9yRnVuY3Rpb25Qcm90b3R5cGUucHJvdG90eXBlID1cbiAgICBHZW5lcmF0b3IucHJvdG90eXBlID0gT2JqZWN0LmNyZWF0ZShJdGVyYXRvclByb3RvdHlwZSk7XG4gIEdlbmVyYXRvckZ1bmN0aW9uLnByb3RvdHlwZSA9IEdwLmNvbnN0cnVjdG9yID0gR2VuZXJhdG9yRnVuY3Rpb25Qcm90b3R5cGU7XG4gIEdlbmVyYXRvckZ1bmN0aW9uUHJvdG90eXBlLmNvbnN0cnVjdG9yID0gR2VuZXJhdG9yRnVuY3Rpb247XG4gIEdlbmVyYXRvckZ1bmN0aW9uLmRpc3BsYXlOYW1lID0gZGVmaW5lKFxuICAgIEdlbmVyYXRvckZ1bmN0aW9uUHJvdG90eXBlLFxuICAgIHRvU3RyaW5nVGFnU3ltYm9sLFxuICAgIFwiR2VuZXJhdG9yRnVuY3Rpb25cIlxuICApO1xuXG4gIC8vIEhlbHBlciBmb3IgZGVmaW5pbmcgdGhlIC5uZXh0LCAudGhyb3csIGFuZCAucmV0dXJuIG1ldGhvZHMgb2YgdGhlXG4gIC8vIEl0ZXJhdG9yIGludGVyZmFjZSBpbiB0ZXJtcyBvZiBhIHNpbmdsZSAuX2ludm9rZSBtZXRob2QuXG4gIGZ1bmN0aW9uIGRlZmluZUl0ZXJhdG9yTWV0aG9kcyhwcm90b3R5cGUpIHtcbiAgICBbXCJuZXh0XCIsIFwidGhyb3dcIiwgXCJyZXR1cm5cIl0uZm9yRWFjaChmdW5jdGlvbihtZXRob2QpIHtcbiAgICAgIGRlZmluZShwcm90b3R5cGUsIG1ldGhvZCwgZnVuY3Rpb24oYXJnKSB7XG4gICAgICAgIHJldHVybiB0aGlzLl9pbnZva2UobWV0aG9kLCBhcmcpO1xuICAgICAgfSk7XG4gICAgfSk7XG4gIH1cblxuICBleHBvcnRzLmlzR2VuZXJhdG9yRnVuY3Rpb24gPSBmdW5jdGlvbihnZW5GdW4pIHtcbiAgICB2YXIgY3RvciA9IHR5cGVvZiBnZW5GdW4gPT09IFwiZnVuY3Rpb25cIiAmJiBnZW5GdW4uY29uc3RydWN0b3I7XG4gICAgcmV0dXJuIGN0b3JcbiAgICAgID8gY3RvciA9PT0gR2VuZXJhdG9yRnVuY3Rpb24gfHxcbiAgICAgICAgLy8gRm9yIHRoZSBuYXRpdmUgR2VuZXJhdG9yRnVuY3Rpb24gY29uc3RydWN0b3IsIHRoZSBiZXN0IHdlIGNhblxuICAgICAgICAvLyBkbyBpcyB0byBjaGVjayBpdHMgLm5hbWUgcHJvcGVydHkuXG4gICAgICAgIChjdG9yLmRpc3BsYXlOYW1lIHx8IGN0b3IubmFtZSkgPT09IFwiR2VuZXJhdG9yRnVuY3Rpb25cIlxuICAgICAgOiBmYWxzZTtcbiAgfTtcblxuICBleHBvcnRzLm1hcmsgPSBmdW5jdGlvbihnZW5GdW4pIHtcbiAgICBpZiAoT2JqZWN0LnNldFByb3RvdHlwZU9mKSB7XG4gICAgICBPYmplY3Quc2V0UHJvdG90eXBlT2YoZ2VuRnVuLCBHZW5lcmF0b3JGdW5jdGlvblByb3RvdHlwZSk7XG4gICAgfSBlbHNlIHtcbiAgICAgIGdlbkZ1bi5fX3Byb3RvX18gPSBHZW5lcmF0b3JGdW5jdGlvblByb3RvdHlwZTtcbiAgICAgIGRlZmluZShnZW5GdW4sIHRvU3RyaW5nVGFnU3ltYm9sLCBcIkdlbmVyYXRvckZ1bmN0aW9uXCIpO1xuICAgIH1cbiAgICBnZW5GdW4ucHJvdG90eXBlID0gT2JqZWN0LmNyZWF0ZShHcCk7XG4gICAgcmV0dXJuIGdlbkZ1bjtcbiAgfTtcblxuICAvLyBXaXRoaW4gdGhlIGJvZHkgb2YgYW55IGFzeW5jIGZ1bmN0aW9uLCBgYXdhaXQgeGAgaXMgdHJhbnNmb3JtZWQgdG9cbiAgLy8gYHlpZWxkIHJlZ2VuZXJhdG9yUnVudGltZS5hd3JhcCh4KWAsIHNvIHRoYXQgdGhlIHJ1bnRpbWUgY2FuIHRlc3RcbiAgLy8gYGhhc093bi5jYWxsKHZhbHVlLCBcIl9fYXdhaXRcIilgIHRvIGRldGVybWluZSBpZiB0aGUgeWllbGRlZCB2YWx1ZSBpc1xuICAvLyBtZWFudCB0byBiZSBhd2FpdGVkLlxuICBleHBvcnRzLmF3cmFwID0gZnVuY3Rpb24oYXJnKSB7XG4gICAgcmV0dXJuIHsgX19hd2FpdDogYXJnIH07XG4gIH07XG5cbiAgZnVuY3Rpb24gQXN5bmNJdGVyYXRvcihnZW5lcmF0b3IsIFByb21pc2VJbXBsKSB7XG4gICAgZnVuY3Rpb24gaW52b2tlKG1ldGhvZCwgYXJnLCByZXNvbHZlLCByZWplY3QpIHtcbiAgICAgIHZhciByZWNvcmQgPSB0cnlDYXRjaChnZW5lcmF0b3JbbWV0aG9kXSwgZ2VuZXJhdG9yLCBhcmcpO1xuICAgICAgaWYgKHJlY29yZC50eXBlID09PSBcInRocm93XCIpIHtcbiAgICAgICAgcmVqZWN0KHJlY29yZC5hcmcpO1xuICAgICAgfSBlbHNlIHtcbiAgICAgICAgdmFyIHJlc3VsdCA9IHJlY29yZC5hcmc7XG4gICAgICAgIHZhciB2YWx1ZSA9IHJlc3VsdC52YWx1ZTtcbiAgICAgICAgaWYgKHZhbHVlICYmXG4gICAgICAgICAgICB0eXBlb2YgdmFsdWUgPT09IFwib2JqZWN0XCIgJiZcbiAgICAgICAgICAgIGhhc093bi5jYWxsKHZhbHVlLCBcIl9fYXdhaXRcIikpIHtcbiAgICAgICAgICByZXR1cm4gUHJvbWlzZUltcGwucmVzb2x2ZSh2YWx1ZS5fX2F3YWl0KS50aGVuKGZ1bmN0aW9uKHZhbHVlKSB7XG4gICAgICAgICAgICBpbnZva2UoXCJuZXh0XCIsIHZhbHVlLCByZXNvbHZlLCByZWplY3QpO1xuICAgICAgICAgIH0sIGZ1bmN0aW9uKGVycikge1xuICAgICAgICAgICAgaW52b2tlKFwidGhyb3dcIiwgZXJyLCByZXNvbHZlLCByZWplY3QpO1xuICAgICAgICAgIH0pO1xuICAgICAgICB9XG5cbiAgICAgICAgcmV0dXJuIFByb21pc2VJbXBsLnJlc29sdmUodmFsdWUpLnRoZW4oZnVuY3Rpb24odW53cmFwcGVkKSB7XG4gICAgICAgICAgLy8gV2hlbiBhIHlpZWxkZWQgUHJvbWlzZSBpcyByZXNvbHZlZCwgaXRzIGZpbmFsIHZhbHVlIGJlY29tZXNcbiAgICAgICAgICAvLyB0aGUgLnZhbHVlIG9mIHRoZSBQcm9taXNlPHt2YWx1ZSxkb25lfT4gcmVzdWx0IGZvciB0aGVcbiAgICAgICAgICAvLyBjdXJyZW50IGl0ZXJhdGlvbi5cbiAgICAgICAgICByZXN1bHQudmFsdWUgPSB1bndyYXBwZWQ7XG4gICAgICAgICAgcmVzb2x2ZShyZXN1bHQpO1xuICAgICAgICB9LCBmdW5jdGlvbihlcnJvcikge1xuICAgICAgICAgIC8vIElmIGEgcmVqZWN0ZWQgUHJvbWlzZSB3YXMgeWllbGRlZCwgdGhyb3cgdGhlIHJlamVjdGlvbiBiYWNrXG4gICAgICAgICAgLy8gaW50byB0aGUgYXN5bmMgZ2VuZXJhdG9yIGZ1bmN0aW9uIHNvIGl0IGNhbiBiZSBoYW5kbGVkIHRoZXJlLlxuICAgICAgICAgIHJldHVybiBpbnZva2UoXCJ0aHJvd1wiLCBlcnJvciwgcmVzb2x2ZSwgcmVqZWN0KTtcbiAgICAgICAgfSk7XG4gICAgICB9XG4gICAgfVxuXG4gICAgdmFyIHByZXZpb3VzUHJvbWlzZTtcblxuICAgIGZ1bmN0aW9uIGVucXVldWUobWV0aG9kLCBhcmcpIHtcbiAgICAgIGZ1bmN0aW9uIGNhbGxJbnZva2VXaXRoTWV0aG9kQW5kQXJnKCkge1xuICAgICAgICByZXR1cm4gbmV3IFByb21pc2VJbXBsKGZ1bmN0aW9uKHJlc29sdmUsIHJlamVjdCkge1xuICAgICAgICAgIGludm9rZShtZXRob2QsIGFyZywgcmVzb2x2ZSwgcmVqZWN0KTtcbiAgICAgICAgfSk7XG4gICAgICB9XG5cbiAgICAgIHJldHVybiBwcmV2aW91c1Byb21pc2UgPVxuICAgICAgICAvLyBJZiBlbnF1ZXVlIGhhcyBiZWVuIGNhbGxlZCBiZWZvcmUsIHRoZW4gd2Ugd2FudCB0byB3YWl0IHVudGlsXG4gICAgICAgIC8vIGFsbCBwcmV2aW91cyBQcm9taXNlcyBoYXZlIGJlZW4gcmVzb2x2ZWQgYmVmb3JlIGNhbGxpbmcgaW52b2tlLFxuICAgICAgICAvLyBzbyB0aGF0IHJlc3VsdHMgYXJlIGFsd2F5cyBkZWxpdmVyZWQgaW4gdGhlIGNvcnJlY3Qgb3JkZXIuIElmXG4gICAgICAgIC8vIGVucXVldWUgaGFzIG5vdCBiZWVuIGNhbGxlZCBiZWZvcmUsIHRoZW4gaXQgaXMgaW1wb3J0YW50IHRvXG4gICAgICAgIC8vIGNhbGwgaW52b2tlIGltbWVkaWF0ZWx5LCB3aXRob3V0IHdhaXRpbmcgb24gYSBjYWxsYmFjayB0byBmaXJlLFxuICAgICAgICAvLyBzbyB0aGF0IHRoZSBhc3luYyBnZW5lcmF0b3IgZnVuY3Rpb24gaGFzIHRoZSBvcHBvcnR1bml0eSB0byBkb1xuICAgICAgICAvLyBhbnkgbmVjZXNzYXJ5IHNldHVwIGluIGEgcHJlZGljdGFibGUgd2F5LiBUaGlzIHByZWRpY3RhYmlsaXR5XG4gICAgICAgIC8vIGlzIHdoeSB0aGUgUHJvbWlzZSBjb25zdHJ1Y3RvciBzeW5jaHJvbm91c2x5IGludm9rZXMgaXRzXG4gICAgICAgIC8vIGV4ZWN1dG9yIGNhbGxiYWNrLCBhbmQgd2h5IGFzeW5jIGZ1bmN0aW9ucyBzeW5jaHJvbm91c2x5XG4gICAgICAgIC8vIGV4ZWN1dGUgY29kZSBiZWZvcmUgdGhlIGZpcnN0IGF3YWl0LiBTaW5jZSB3ZSBpbXBsZW1lbnQgc2ltcGxlXG4gICAgICAgIC8vIGFzeW5jIGZ1bmN0aW9ucyBpbiB0ZXJtcyBvZiBhc3luYyBnZW5lcmF0b3JzLCBpdCBpcyBlc3BlY2lhbGx5XG4gICAgICAgIC8vIGltcG9ydGFudCB0byBnZXQgdGhpcyByaWdodCwgZXZlbiB0aG91Z2ggaXQgcmVxdWlyZXMgY2FyZS5cbiAgICAgICAgcHJldmlvdXNQcm9taXNlID8gcHJldmlvdXNQcm9taXNlLnRoZW4oXG4gICAgICAgICAgY2FsbEludm9rZVdpdGhNZXRob2RBbmRBcmcsXG4gICAgICAgICAgLy8gQXZvaWQgcHJvcGFnYXRpbmcgZmFpbHVyZXMgdG8gUHJvbWlzZXMgcmV0dXJuZWQgYnkgbGF0ZXJcbiAgICAgICAgICAvLyBpbnZvY2F0aW9ucyBvZiB0aGUgaXRlcmF0b3IuXG4gICAgICAgICAgY2FsbEludm9rZVdpdGhNZXRob2RBbmRBcmdcbiAgICAgICAgKSA6IGNhbGxJbnZva2VXaXRoTWV0aG9kQW5kQXJnKCk7XG4gICAgfVxuXG4gICAgLy8gRGVmaW5lIHRoZSB1bmlmaWVkIGhlbHBlciBtZXRob2QgdGhhdCBpcyB1c2VkIHRvIGltcGxlbWVudCAubmV4dCxcbiAgICAvLyAudGhyb3csIGFuZCAucmV0dXJuIChzZWUgZGVmaW5lSXRlcmF0b3JNZXRob2RzKS5cbiAgICB0aGlzLl9pbnZva2UgPSBlbnF1ZXVlO1xuICB9XG5cbiAgZGVmaW5lSXRlcmF0b3JNZXRob2RzKEFzeW5jSXRlcmF0b3IucHJvdG90eXBlKTtcbiAgQXN5bmNJdGVyYXRvci5wcm90b3R5cGVbYXN5bmNJdGVyYXRvclN5bWJvbF0gPSBmdW5jdGlvbiAoKSB7XG4gICAgcmV0dXJuIHRoaXM7XG4gIH07XG4gIGV4cG9ydHMuQXN5bmNJdGVyYXRvciA9IEFzeW5jSXRlcmF0b3I7XG5cbiAgLy8gTm90ZSB0aGF0IHNpbXBsZSBhc3luYyBmdW5jdGlvbnMgYXJlIGltcGxlbWVudGVkIG9uIHRvcCBvZlxuICAvLyBBc3luY0l0ZXJhdG9yIG9iamVjdHM7IHRoZXkganVzdCByZXR1cm4gYSBQcm9taXNlIGZvciB0aGUgdmFsdWUgb2ZcbiAgLy8gdGhlIGZpbmFsIHJlc3VsdCBwcm9kdWNlZCBieSB0aGUgaXRlcmF0b3IuXG4gIGV4cG9ydHMuYXN5bmMgPSBmdW5jdGlvbihpbm5lckZuLCBvdXRlckZuLCBzZWxmLCB0cnlMb2NzTGlzdCwgUHJvbWlzZUltcGwpIHtcbiAgICBpZiAoUHJvbWlzZUltcGwgPT09IHZvaWQgMCkgUHJvbWlzZUltcGwgPSBQcm9taXNlO1xuXG4gICAgdmFyIGl0ZXIgPSBuZXcgQXN5bmNJdGVyYXRvcihcbiAgICAgIHdyYXAoaW5uZXJGbiwgb3V0ZXJGbiwgc2VsZiwgdHJ5TG9jc0xpc3QpLFxuICAgICAgUHJvbWlzZUltcGxcbiAgICApO1xuXG4gICAgcmV0dXJuIGV4cG9ydHMuaXNHZW5lcmF0b3JGdW5jdGlvbihvdXRlckZuKVxuICAgICAgPyBpdGVyIC8vIElmIG91dGVyRm4gaXMgYSBnZW5lcmF0b3IsIHJldHVybiB0aGUgZnVsbCBpdGVyYXRvci5cbiAgICAgIDogaXRlci5uZXh0KCkudGhlbihmdW5jdGlvbihyZXN1bHQpIHtcbiAgICAgICAgICByZXR1cm4gcmVzdWx0LmRvbmUgPyByZXN1bHQudmFsdWUgOiBpdGVyLm5leHQoKTtcbiAgICAgICAgfSk7XG4gIH07XG5cbiAgZnVuY3Rpb24gbWFrZUludm9rZU1ldGhvZChpbm5lckZuLCBzZWxmLCBjb250ZXh0KSB7XG4gICAgdmFyIHN0YXRlID0gR2VuU3RhdGVTdXNwZW5kZWRTdGFydDtcblxuICAgIHJldHVybiBmdW5jdGlvbiBpbnZva2UobWV0aG9kLCBhcmcpIHtcbiAgICAgIGlmIChzdGF0ZSA9PT0gR2VuU3RhdGVFeGVjdXRpbmcpIHtcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiR2VuZXJhdG9yIGlzIGFscmVhZHkgcnVubmluZ1wiKTtcbiAgICAgIH1cblxuICAgICAgaWYgKHN0YXRlID09PSBHZW5TdGF0ZUNvbXBsZXRlZCkge1xuICAgICAgICBpZiAobWV0aG9kID09PSBcInRocm93XCIpIHtcbiAgICAgICAgICB0aHJvdyBhcmc7XG4gICAgICAgIH1cblxuICAgICAgICAvLyBCZSBmb3JnaXZpbmcsIHBlciAyNS4zLjMuMy4zIG9mIHRoZSBzcGVjOlxuICAgICAgICAvLyBodHRwczovL3Blb3BsZS5tb3ppbGxhLm9yZy9+am9yZW5kb3JmZi9lczYtZHJhZnQuaHRtbCNzZWMtZ2VuZXJhdG9ycmVzdW1lXG4gICAgICAgIHJldHVybiBkb25lUmVzdWx0KCk7XG4gICAgICB9XG5cbiAgICAgIGNvbnRleHQubWV0aG9kID0gbWV0aG9kO1xuICAgICAgY29udGV4dC5hcmcgPSBhcmc7XG5cbiAgICAgIHdoaWxlICh0cnVlKSB7XG4gICAgICAgIHZhciBkZWxlZ2F0ZSA9IGNvbnRleHQuZGVsZWdhdGU7XG4gICAgICAgIGlmIChkZWxlZ2F0ZSkge1xuICAgICAgICAgIHZhciBkZWxlZ2F0ZVJlc3VsdCA9IG1heWJlSW52b2tlRGVsZWdhdGUoZGVsZWdhdGUsIGNvbnRleHQpO1xuICAgICAgICAgIGlmIChkZWxlZ2F0ZVJlc3VsdCkge1xuICAgICAgICAgICAgaWYgKGRlbGVnYXRlUmVzdWx0ID09PSBDb250aW51ZVNlbnRpbmVsKSBjb250aW51ZTtcbiAgICAgICAgICAgIHJldHVybiBkZWxlZ2F0ZVJlc3VsdDtcbiAgICAgICAgICB9XG4gICAgICAgIH1cblxuICAgICAgICBpZiAoY29udGV4dC5tZXRob2QgPT09IFwibmV4dFwiKSB7XG4gICAgICAgICAgLy8gU2V0dGluZyBjb250ZXh0Ll9zZW50IGZvciBsZWdhY3kgc3VwcG9ydCBvZiBCYWJlbCdzXG4gICAgICAgICAgLy8gZnVuY3Rpb24uc2VudCBpbXBsZW1lbnRhdGlvbi5cbiAgICAgICAgICBjb250ZXh0LnNlbnQgPSBjb250ZXh0Ll9zZW50ID0gY29udGV4dC5hcmc7XG5cbiAgICAgICAgfSBlbHNlIGlmIChjb250ZXh0Lm1ldGhvZCA9PT0gXCJ0aHJvd1wiKSB7XG4gICAgICAgICAgaWYgKHN0YXRlID09PSBHZW5TdGF0ZVN1c3BlbmRlZFN0YXJ0KSB7XG4gICAgICAgICAgICBzdGF0ZSA9IEdlblN0YXRlQ29tcGxldGVkO1xuICAgICAgICAgICAgdGhyb3cgY29udGV4dC5hcmc7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgY29udGV4dC5kaXNwYXRjaEV4Y2VwdGlvbihjb250ZXh0LmFyZyk7XG5cbiAgICAgICAgfSBlbHNlIGlmIChjb250ZXh0Lm1ldGhvZCA9PT0gXCJyZXR1cm5cIikge1xuICAgICAgICAgIGNvbnRleHQuYWJydXB0KFwicmV0dXJuXCIsIGNvbnRleHQuYXJnKTtcbiAgICAgICAgfVxuXG4gICAgICAgIHN0YXRlID0gR2VuU3RhdGVFeGVjdXRpbmc7XG5cbiAgICAgICAgdmFyIHJlY29yZCA9IHRyeUNhdGNoKGlubmVyRm4sIHNlbGYsIGNvbnRleHQpO1xuICAgICAgICBpZiAocmVjb3JkLnR5cGUgPT09IFwibm9ybWFsXCIpIHtcbiAgICAgICAgICAvLyBJZiBhbiBleGNlcHRpb24gaXMgdGhyb3duIGZyb20gaW5uZXJGbiwgd2UgbGVhdmUgc3RhdGUgPT09XG4gICAgICAgICAgLy8gR2VuU3RhdGVFeGVjdXRpbmcgYW5kIGxvb3AgYmFjayBmb3IgYW5vdGhlciBpbnZvY2F0aW9uLlxuICAgICAgICAgIHN0YXRlID0gY29udGV4dC5kb25lXG4gICAgICAgICAgICA/IEdlblN0YXRlQ29tcGxldGVkXG4gICAgICAgICAgICA6IEdlblN0YXRlU3VzcGVuZGVkWWllbGQ7XG5cbiAgICAgICAgICBpZiAocmVjb3JkLmFyZyA9PT0gQ29udGludWVTZW50aW5lbCkge1xuICAgICAgICAgICAgY29udGludWU7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgcmV0dXJuIHtcbiAgICAgICAgICAgIHZhbHVlOiByZWNvcmQuYXJnLFxuICAgICAgICAgICAgZG9uZTogY29udGV4dC5kb25lXG4gICAgICAgICAgfTtcblxuICAgICAgICB9IGVsc2UgaWYgKHJlY29yZC50eXBlID09PSBcInRocm93XCIpIHtcbiAgICAgICAgICBzdGF0ZSA9IEdlblN0YXRlQ29tcGxldGVkO1xuICAgICAgICAgIC8vIERpc3BhdGNoIHRoZSBleGNlcHRpb24gYnkgbG9vcGluZyBiYWNrIGFyb3VuZCB0byB0aGVcbiAgICAgICAgICAvLyBjb250ZXh0LmRpc3BhdGNoRXhjZXB0aW9uKGNvbnRleHQuYXJnKSBjYWxsIGFib3ZlLlxuICAgICAgICAgIGNvbnRleHQubWV0aG9kID0gXCJ0aHJvd1wiO1xuICAgICAgICAgIGNvbnRleHQuYXJnID0gcmVjb3JkLmFyZztcbiAgICAgICAgfVxuICAgICAgfVxuICAgIH07XG4gIH1cblxuICAvLyBDYWxsIGRlbGVnYXRlLml0ZXJhdG9yW2NvbnRleHQubWV0aG9kXShjb250ZXh0LmFyZykgYW5kIGhhbmRsZSB0aGVcbiAgLy8gcmVzdWx0LCBlaXRoZXIgYnkgcmV0dXJuaW5nIGEgeyB2YWx1ZSwgZG9uZSB9IHJlc3VsdCBmcm9tIHRoZVxuICAvLyBkZWxlZ2F0ZSBpdGVyYXRvciwgb3IgYnkgbW9kaWZ5aW5nIGNvbnRleHQubWV0aG9kIGFuZCBjb250ZXh0LmFyZyxcbiAgLy8gc2V0dGluZyBjb250ZXh0LmRlbGVnYXRlIHRvIG51bGwsIGFuZCByZXR1cm5pbmcgdGhlIENvbnRpbnVlU2VudGluZWwuXG4gIGZ1bmN0aW9uIG1heWJlSW52b2tlRGVsZWdhdGUoZGVsZWdhdGUsIGNvbnRleHQpIHtcbiAgICB2YXIgbWV0aG9kID0gZGVsZWdhdGUuaXRlcmF0b3JbY29udGV4dC5tZXRob2RdO1xuICAgIGlmIChtZXRob2QgPT09IHVuZGVmaW5lZCkge1xuICAgICAgLy8gQSAudGhyb3cgb3IgLnJldHVybiB3aGVuIHRoZSBkZWxlZ2F0ZSBpdGVyYXRvciBoYXMgbm8gLnRocm93XG4gICAgICAvLyBtZXRob2QgYWx3YXlzIHRlcm1pbmF0ZXMgdGhlIHlpZWxkKiBsb29wLlxuICAgICAgY29udGV4dC5kZWxlZ2F0ZSA9IG51bGw7XG5cbiAgICAgIGlmIChjb250ZXh0Lm1ldGhvZCA9PT0gXCJ0aHJvd1wiKSB7XG4gICAgICAgIC8vIE5vdGU6IFtcInJldHVyblwiXSBtdXN0IGJlIHVzZWQgZm9yIEVTMyBwYXJzaW5nIGNvbXBhdGliaWxpdHkuXG4gICAgICAgIGlmIChkZWxlZ2F0ZS5pdGVyYXRvcltcInJldHVyblwiXSkge1xuICAgICAgICAgIC8vIElmIHRoZSBkZWxlZ2F0ZSBpdGVyYXRvciBoYXMgYSByZXR1cm4gbWV0aG9kLCBnaXZlIGl0IGFcbiAgICAgICAgICAvLyBjaGFuY2UgdG8gY2xlYW4gdXAuXG4gICAgICAgICAgY29udGV4dC5tZXRob2QgPSBcInJldHVyblwiO1xuICAgICAgICAgIGNvbnRleHQuYXJnID0gdW5kZWZpbmVkO1xuICAgICAgICAgIG1heWJlSW52b2tlRGVsZWdhdGUoZGVsZWdhdGUsIGNvbnRleHQpO1xuXG4gICAgICAgICAgaWYgKGNvbnRleHQubWV0aG9kID09PSBcInRocm93XCIpIHtcbiAgICAgICAgICAgIC8vIElmIG1heWJlSW52b2tlRGVsZWdhdGUoY29udGV4dCkgY2hhbmdlZCBjb250ZXh0Lm1ldGhvZCBmcm9tXG4gICAgICAgICAgICAvLyBcInJldHVyblwiIHRvIFwidGhyb3dcIiwgbGV0IHRoYXQgb3ZlcnJpZGUgdGhlIFR5cGVFcnJvciBiZWxvdy5cbiAgICAgICAgICAgIHJldHVybiBDb250aW51ZVNlbnRpbmVsO1xuICAgICAgICAgIH1cbiAgICAgICAgfVxuXG4gICAgICAgIGNvbnRleHQubWV0aG9kID0gXCJ0aHJvd1wiO1xuICAgICAgICBjb250ZXh0LmFyZyA9IG5ldyBUeXBlRXJyb3IoXG4gICAgICAgICAgXCJUaGUgaXRlcmF0b3IgZG9lcyBub3QgcHJvdmlkZSBhICd0aHJvdycgbWV0aG9kXCIpO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gQ29udGludWVTZW50aW5lbDtcbiAgICB9XG5cbiAgICB2YXIgcmVjb3JkID0gdHJ5Q2F0Y2gobWV0aG9kLCBkZWxlZ2F0ZS5pdGVyYXRvciwgY29udGV4dC5hcmcpO1xuXG4gICAgaWYgKHJlY29yZC50eXBlID09PSBcInRocm93XCIpIHtcbiAgICAgIGNvbnRleHQubWV0aG9kID0gXCJ0aHJvd1wiO1xuICAgICAgY29udGV4dC5hcmcgPSByZWNvcmQuYXJnO1xuICAgICAgY29udGV4dC5kZWxlZ2F0ZSA9IG51bGw7XG4gICAgICByZXR1cm4gQ29udGludWVTZW50aW5lbDtcbiAgICB9XG5cbiAgICB2YXIgaW5mbyA9IHJlY29yZC5hcmc7XG5cbiAgICBpZiAoISBpbmZvKSB7XG4gICAgICBjb250ZXh0Lm1ldGhvZCA9IFwidGhyb3dcIjtcbiAgICAgIGNvbnRleHQuYXJnID0gbmV3IFR5cGVFcnJvcihcIml0ZXJhdG9yIHJlc3VsdCBpcyBub3QgYW4gb2JqZWN0XCIpO1xuICAgICAgY29udGV4dC5kZWxlZ2F0ZSA9IG51bGw7XG4gICAgICByZXR1cm4gQ29udGludWVTZW50aW5lbDtcbiAgICB9XG5cbiAgICBpZiAoaW5mby5kb25lKSB7XG4gICAgICAvLyBBc3NpZ24gdGhlIHJlc3VsdCBvZiB0aGUgZmluaXNoZWQgZGVsZWdhdGUgdG8gdGhlIHRlbXBvcmFyeVxuICAgICAgLy8gdmFyaWFibGUgc3BlY2lmaWVkIGJ5IGRlbGVnYXRlLnJlc3VsdE5hbWUgKHNlZSBkZWxlZ2F0ZVlpZWxkKS5cbiAgICAgIGNvbnRleHRbZGVsZWdhdGUucmVzdWx0TmFtZV0gPSBpbmZvLnZhbHVlO1xuXG4gICAgICAvLyBSZXN1bWUgZXhlY3V0aW9uIGF0IHRoZSBkZXNpcmVkIGxvY2F0aW9uIChzZWUgZGVsZWdhdGVZaWVsZCkuXG4gICAgICBjb250ZXh0Lm5leHQgPSBkZWxlZ2F0ZS5uZXh0TG9jO1xuXG4gICAgICAvLyBJZiBjb250ZXh0Lm1ldGhvZCB3YXMgXCJ0aHJvd1wiIGJ1dCB0aGUgZGVsZWdhdGUgaGFuZGxlZCB0aGVcbiAgICAgIC8vIGV4Y2VwdGlvbiwgbGV0IHRoZSBvdXRlciBnZW5lcmF0b3IgcHJvY2VlZCBub3JtYWxseS4gSWZcbiAgICAgIC8vIGNvbnRleHQubWV0aG9kIHdhcyBcIm5leHRcIiwgZm9yZ2V0IGNvbnRleHQuYXJnIHNpbmNlIGl0IGhhcyBiZWVuXG4gICAgICAvLyBcImNvbnN1bWVkXCIgYnkgdGhlIGRlbGVnYXRlIGl0ZXJhdG9yLiBJZiBjb250ZXh0Lm1ldGhvZCB3YXNcbiAgICAgIC8vIFwicmV0dXJuXCIsIGFsbG93IHRoZSBvcmlnaW5hbCAucmV0dXJuIGNhbGwgdG8gY29udGludWUgaW4gdGhlXG4gICAgICAvLyBvdXRlciBnZW5lcmF0b3IuXG4gICAgICBpZiAoY29udGV4dC5tZXRob2QgIT09IFwicmV0dXJuXCIpIHtcbiAgICAgICAgY29udGV4dC5tZXRob2QgPSBcIm5leHRcIjtcbiAgICAgICAgY29udGV4dC5hcmcgPSB1bmRlZmluZWQ7XG4gICAgICB9XG5cbiAgICB9IGVsc2Uge1xuICAgICAgLy8gUmUteWllbGQgdGhlIHJlc3VsdCByZXR1cm5lZCBieSB0aGUgZGVsZWdhdGUgbWV0aG9kLlxuICAgICAgcmV0dXJuIGluZm87XG4gICAgfVxuXG4gICAgLy8gVGhlIGRlbGVnYXRlIGl0ZXJhdG9yIGlzIGZpbmlzaGVkLCBzbyBmb3JnZXQgaXQgYW5kIGNvbnRpbnVlIHdpdGhcbiAgICAvLyB0aGUgb3V0ZXIgZ2VuZXJhdG9yLlxuICAgIGNvbnRleHQuZGVsZWdhdGUgPSBudWxsO1xuICAgIHJldHVybiBDb250aW51ZVNlbnRpbmVsO1xuICB9XG5cbiAgLy8gRGVmaW5lIEdlbmVyYXRvci5wcm90b3R5cGUue25leHQsdGhyb3cscmV0dXJufSBpbiB0ZXJtcyBvZiB0aGVcbiAgLy8gdW5pZmllZCAuX2ludm9rZSBoZWxwZXIgbWV0aG9kLlxuICBkZWZpbmVJdGVyYXRvck1ldGhvZHMoR3ApO1xuXG4gIGRlZmluZShHcCwgdG9TdHJpbmdUYWdTeW1ib2wsIFwiR2VuZXJhdG9yXCIpO1xuXG4gIC8vIEEgR2VuZXJhdG9yIHNob3VsZCBhbHdheXMgcmV0dXJuIGl0c2VsZiBhcyB0aGUgaXRlcmF0b3Igb2JqZWN0IHdoZW4gdGhlXG4gIC8vIEBAaXRlcmF0b3IgZnVuY3Rpb24gaXMgY2FsbGVkIG9uIGl0LiBTb21lIGJyb3dzZXJzJyBpbXBsZW1lbnRhdGlvbnMgb2YgdGhlXG4gIC8vIGl0ZXJhdG9yIHByb3RvdHlwZSBjaGFpbiBpbmNvcnJlY3RseSBpbXBsZW1lbnQgdGhpcywgY2F1c2luZyB0aGUgR2VuZXJhdG9yXG4gIC8vIG9iamVjdCB0byBub3QgYmUgcmV0dXJuZWQgZnJvbSB0aGlzIGNhbGwuIFRoaXMgZW5zdXJlcyB0aGF0IGRvZXNuJ3QgaGFwcGVuLlxuICAvLyBTZWUgaHR0cHM6Ly9naXRodWIuY29tL2ZhY2Vib29rL3JlZ2VuZXJhdG9yL2lzc3Vlcy8yNzQgZm9yIG1vcmUgZGV0YWlscy5cbiAgR3BbaXRlcmF0b3JTeW1ib2xdID0gZnVuY3Rpb24oKSB7XG4gICAgcmV0dXJuIHRoaXM7XG4gIH07XG5cbiAgR3AudG9TdHJpbmcgPSBmdW5jdGlvbigpIHtcbiAgICByZXR1cm4gXCJbb2JqZWN0IEdlbmVyYXRvcl1cIjtcbiAgfTtcblxuICBmdW5jdGlvbiBwdXNoVHJ5RW50cnkobG9jcykge1xuICAgIHZhciBlbnRyeSA9IHsgdHJ5TG9jOiBsb2NzWzBdIH07XG5cbiAgICBpZiAoMSBpbiBsb2NzKSB7XG4gICAgICBlbnRyeS5jYXRjaExvYyA9IGxvY3NbMV07XG4gICAgfVxuXG4gICAgaWYgKDIgaW4gbG9jcykge1xuICAgICAgZW50cnkuZmluYWxseUxvYyA9IGxvY3NbMl07XG4gICAgICBlbnRyeS5hZnRlckxvYyA9IGxvY3NbM107XG4gICAgfVxuXG4gICAgdGhpcy50cnlFbnRyaWVzLnB1c2goZW50cnkpO1xuICB9XG5cbiAgZnVuY3Rpb24gcmVzZXRUcnlFbnRyeShlbnRyeSkge1xuICAgIHZhciByZWNvcmQgPSBlbnRyeS5jb21wbGV0aW9uIHx8IHt9O1xuICAgIHJlY29yZC50eXBlID0gXCJub3JtYWxcIjtcbiAgICBkZWxldGUgcmVjb3JkLmFyZztcbiAgICBlbnRyeS5jb21wbGV0aW9uID0gcmVjb3JkO1xuICB9XG5cbiAgZnVuY3Rpb24gQ29udGV4dCh0cnlMb2NzTGlzdCkge1xuICAgIC8vIFRoZSByb290IGVudHJ5IG9iamVjdCAoZWZmZWN0aXZlbHkgYSB0cnkgc3RhdGVtZW50IHdpdGhvdXQgYSBjYXRjaFxuICAgIC8vIG9yIGEgZmluYWxseSBibG9jaykgZ2l2ZXMgdXMgYSBwbGFjZSB0byBzdG9yZSB2YWx1ZXMgdGhyb3duIGZyb21cbiAgICAvLyBsb2NhdGlvbnMgd2hlcmUgdGhlcmUgaXMgbm8gZW5jbG9zaW5nIHRyeSBzdGF0ZW1lbnQuXG4gICAgdGhpcy50cnlFbnRyaWVzID0gW3sgdHJ5TG9jOiBcInJvb3RcIiB9XTtcbiAgICB0cnlMb2NzTGlzdC5mb3JFYWNoKHB1c2hUcnlFbnRyeSwgdGhpcyk7XG4gICAgdGhpcy5yZXNldCh0cnVlKTtcbiAgfVxuXG4gIGV4cG9ydHMua2V5cyA9IGZ1bmN0aW9uKG9iamVjdCkge1xuICAgIHZhciBrZXlzID0gW107XG4gICAgZm9yICh2YXIga2V5IGluIG9iamVjdCkge1xuICAgICAga2V5cy5wdXNoKGtleSk7XG4gICAgfVxuICAgIGtleXMucmV2ZXJzZSgpO1xuXG4gICAgLy8gUmF0aGVyIHRoYW4gcmV0dXJuaW5nIGFuIG9iamVjdCB3aXRoIGEgbmV4dCBtZXRob2QsIHdlIGtlZXBcbiAgICAvLyB0aGluZ3Mgc2ltcGxlIGFuZCByZXR1cm4gdGhlIG5leHQgZnVuY3Rpb24gaXRzZWxmLlxuICAgIHJldHVybiBmdW5jdGlvbiBuZXh0KCkge1xuICAgICAgd2hpbGUgKGtleXMubGVuZ3RoKSB7XG4gICAgICAgIHZhciBrZXkgPSBrZXlzLnBvcCgpO1xuICAgICAgICBpZiAoa2V5IGluIG9iamVjdCkge1xuICAgICAgICAgIG5leHQudmFsdWUgPSBrZXk7XG4gICAgICAgICAgbmV4dC5kb25lID0gZmFsc2U7XG4gICAgICAgICAgcmV0dXJuIG5leHQ7XG4gICAgICAgIH1cbiAgICAgIH1cblxuICAgICAgLy8gVG8gYXZvaWQgY3JlYXRpbmcgYW4gYWRkaXRpb25hbCBvYmplY3QsIHdlIGp1c3QgaGFuZyB0aGUgLnZhbHVlXG4gICAgICAvLyBhbmQgLmRvbmUgcHJvcGVydGllcyBvZmYgdGhlIG5leHQgZnVuY3Rpb24gb2JqZWN0IGl0c2VsZi4gVGhpc1xuICAgICAgLy8gYWxzbyBlbnN1cmVzIHRoYXQgdGhlIG1pbmlmaWVyIHdpbGwgbm90IGFub255bWl6ZSB0aGUgZnVuY3Rpb24uXG4gICAgICBuZXh0LmRvbmUgPSB0cnVlO1xuICAgICAgcmV0dXJuIG5leHQ7XG4gICAgfTtcbiAgfTtcblxuICBmdW5jdGlvbiB2YWx1ZXMoaXRlcmFibGUpIHtcbiAgICBpZiAoaXRlcmFibGUpIHtcbiAgICAgIHZhciBpdGVyYXRvck1ldGhvZCA9IGl0ZXJhYmxlW2l0ZXJhdG9yU3ltYm9sXTtcbiAgICAgIGlmIChpdGVyYXRvck1ldGhvZCkge1xuICAgICAgICByZXR1cm4gaXRlcmF0b3JNZXRob2QuY2FsbChpdGVyYWJsZSk7XG4gICAgICB9XG5cbiAgICAgIGlmICh0eXBlb2YgaXRlcmFibGUubmV4dCA9PT0gXCJmdW5jdGlvblwiKSB7XG4gICAgICAgIHJldHVybiBpdGVyYWJsZTtcbiAgICAgIH1cblxuICAgICAgaWYgKCFpc05hTihpdGVyYWJsZS5sZW5ndGgpKSB7XG4gICAgICAgIHZhciBpID0gLTEsIG5leHQgPSBmdW5jdGlvbiBuZXh0KCkge1xuICAgICAgICAgIHdoaWxlICgrK2kgPCBpdGVyYWJsZS5sZW5ndGgpIHtcbiAgICAgICAgICAgIGlmIChoYXNPd24uY2FsbChpdGVyYWJsZSwgaSkpIHtcbiAgICAgICAgICAgICAgbmV4dC52YWx1ZSA9IGl0ZXJhYmxlW2ldO1xuICAgICAgICAgICAgICBuZXh0LmRvbmUgPSBmYWxzZTtcbiAgICAgICAgICAgICAgcmV0dXJuIG5leHQ7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgbmV4dC52YWx1ZSA9IHVuZGVmaW5lZDtcbiAgICAgICAgICBuZXh0LmRvbmUgPSB0cnVlO1xuXG4gICAgICAgICAgcmV0dXJuIG5leHQ7XG4gICAgICAgIH07XG5cbiAgICAgICAgcmV0dXJuIG5leHQubmV4dCA9IG5leHQ7XG4gICAgICB9XG4gICAgfVxuXG4gICAgLy8gUmV0dXJuIGFuIGl0ZXJhdG9yIHdpdGggbm8gdmFsdWVzLlxuICAgIHJldHVybiB7IG5leHQ6IGRvbmVSZXN1bHQgfTtcbiAgfVxuICBleHBvcnRzLnZhbHVlcyA9IHZhbHVlcztcblxuICBmdW5jdGlvbiBkb25lUmVzdWx0KCkge1xuICAgIHJldHVybiB7IHZhbHVlOiB1bmRlZmluZWQsIGRvbmU6IHRydWUgfTtcbiAgfVxuXG4gIENvbnRleHQucHJvdG90eXBlID0ge1xuICAgIGNvbnN0cnVjdG9yOiBDb250ZXh0LFxuXG4gICAgcmVzZXQ6IGZ1bmN0aW9uKHNraXBUZW1wUmVzZXQpIHtcbiAgICAgIHRoaXMucHJldiA9IDA7XG4gICAgICB0aGlzLm5leHQgPSAwO1xuICAgICAgLy8gUmVzZXR0aW5nIGNvbnRleHQuX3NlbnQgZm9yIGxlZ2FjeSBzdXBwb3J0IG9mIEJhYmVsJ3NcbiAgICAgIC8vIGZ1bmN0aW9uLnNlbnQgaW1wbGVtZW50YXRpb24uXG4gICAgICB0aGlzLnNlbnQgPSB0aGlzLl9zZW50ID0gdW5kZWZpbmVkO1xuICAgICAgdGhpcy5kb25lID0gZmFsc2U7XG4gICAgICB0aGlzLmRlbGVnYXRlID0gbnVsbDtcblxuICAgICAgdGhpcy5tZXRob2QgPSBcIm5leHRcIjtcbiAgICAgIHRoaXMuYXJnID0gdW5kZWZpbmVkO1xuXG4gICAgICB0aGlzLnRyeUVudHJpZXMuZm9yRWFjaChyZXNldFRyeUVudHJ5KTtcblxuICAgICAgaWYgKCFza2lwVGVtcFJlc2V0KSB7XG4gICAgICAgIGZvciAodmFyIG5hbWUgaW4gdGhpcykge1xuICAgICAgICAgIC8vIE5vdCBzdXJlIGFib3V0IHRoZSBvcHRpbWFsIG9yZGVyIG9mIHRoZXNlIGNvbmRpdGlvbnM6XG4gICAgICAgICAgaWYgKG5hbWUuY2hhckF0KDApID09PSBcInRcIiAmJlxuICAgICAgICAgICAgICBoYXNPd24uY2FsbCh0aGlzLCBuYW1lKSAmJlxuICAgICAgICAgICAgICAhaXNOYU4oK25hbWUuc2xpY2UoMSkpKSB7XG4gICAgICAgICAgICB0aGlzW25hbWVdID0gdW5kZWZpbmVkO1xuICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgfVxuICAgIH0sXG5cbiAgICBzdG9wOiBmdW5jdGlvbigpIHtcbiAgICAgIHRoaXMuZG9uZSA9IHRydWU7XG5cbiAgICAgIHZhciByb290RW50cnkgPSB0aGlzLnRyeUVudHJpZXNbMF07XG4gICAgICB2YXIgcm9vdFJlY29yZCA9IHJvb3RFbnRyeS5jb21wbGV0aW9uO1xuICAgICAgaWYgKHJvb3RSZWNvcmQudHlwZSA9PT0gXCJ0aHJvd1wiKSB7XG4gICAgICAgIHRocm93IHJvb3RSZWNvcmQuYXJnO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gdGhpcy5ydmFsO1xuICAgIH0sXG5cbiAgICBkaXNwYXRjaEV4Y2VwdGlvbjogZnVuY3Rpb24oZXhjZXB0aW9uKSB7XG4gICAgICBpZiAodGhpcy5kb25lKSB7XG4gICAgICAgIHRocm93IGV4Y2VwdGlvbjtcbiAgICAgIH1cblxuICAgICAgdmFyIGNvbnRleHQgPSB0aGlzO1xuICAgICAgZnVuY3Rpb24gaGFuZGxlKGxvYywgY2F1Z2h0KSB7XG4gICAgICAgIHJlY29yZC50eXBlID0gXCJ0aHJvd1wiO1xuICAgICAgICByZWNvcmQuYXJnID0gZXhjZXB0aW9uO1xuICAgICAgICBjb250ZXh0Lm5leHQgPSBsb2M7XG5cbiAgICAgICAgaWYgKGNhdWdodCkge1xuICAgICAgICAgIC8vIElmIHRoZSBkaXNwYXRjaGVkIGV4Y2VwdGlvbiB3YXMgY2F1Z2h0IGJ5IGEgY2F0Y2ggYmxvY2ssXG4gICAgICAgICAgLy8gdGhlbiBsZXQgdGhhdCBjYXRjaCBibG9jayBoYW5kbGUgdGhlIGV4Y2VwdGlvbiBub3JtYWxseS5cbiAgICAgICAgICBjb250ZXh0Lm1ldGhvZCA9IFwibmV4dFwiO1xuICAgICAgICAgIGNvbnRleHQuYXJnID0gdW5kZWZpbmVkO1xuICAgICAgICB9XG5cbiAgICAgICAgcmV0dXJuICEhIGNhdWdodDtcbiAgICAgIH1cblxuICAgICAgZm9yICh2YXIgaSA9IHRoaXMudHJ5RW50cmllcy5sZW5ndGggLSAxOyBpID49IDA7IC0taSkge1xuICAgICAgICB2YXIgZW50cnkgPSB0aGlzLnRyeUVudHJpZXNbaV07XG4gICAgICAgIHZhciByZWNvcmQgPSBlbnRyeS5jb21wbGV0aW9uO1xuXG4gICAgICAgIGlmIChlbnRyeS50cnlMb2MgPT09IFwicm9vdFwiKSB7XG4gICAgICAgICAgLy8gRXhjZXB0aW9uIHRocm93biBvdXRzaWRlIG9mIGFueSB0cnkgYmxvY2sgdGhhdCBjb3VsZCBoYW5kbGVcbiAgICAgICAgICAvLyBpdCwgc28gc2V0IHRoZSBjb21wbGV0aW9uIHZhbHVlIG9mIHRoZSBlbnRpcmUgZnVuY3Rpb24gdG9cbiAgICAgICAgICAvLyB0aHJvdyB0aGUgZXhjZXB0aW9uLlxuICAgICAgICAgIHJldHVybiBoYW5kbGUoXCJlbmRcIik7XG4gICAgICAgIH1cblxuICAgICAgICBpZiAoZW50cnkudHJ5TG9jIDw9IHRoaXMucHJldikge1xuICAgICAgICAgIHZhciBoYXNDYXRjaCA9IGhhc093bi5jYWxsKGVudHJ5LCBcImNhdGNoTG9jXCIpO1xuICAgICAgICAgIHZhciBoYXNGaW5hbGx5ID0gaGFzT3duLmNhbGwoZW50cnksIFwiZmluYWxseUxvY1wiKTtcblxuICAgICAgICAgIGlmIChoYXNDYXRjaCAmJiBoYXNGaW5hbGx5KSB7XG4gICAgICAgICAgICBpZiAodGhpcy5wcmV2IDwgZW50cnkuY2F0Y2hMb2MpIHtcbiAgICAgICAgICAgICAgcmV0dXJuIGhhbmRsZShlbnRyeS5jYXRjaExvYywgdHJ1ZSk7XG4gICAgICAgICAgICB9IGVsc2UgaWYgKHRoaXMucHJldiA8IGVudHJ5LmZpbmFsbHlMb2MpIHtcbiAgICAgICAgICAgICAgcmV0dXJuIGhhbmRsZShlbnRyeS5maW5hbGx5TG9jKTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgIH0gZWxzZSBpZiAoaGFzQ2F0Y2gpIHtcbiAgICAgICAgICAgIGlmICh0aGlzLnByZXYgPCBlbnRyeS5jYXRjaExvYykge1xuICAgICAgICAgICAgICByZXR1cm4gaGFuZGxlKGVudHJ5LmNhdGNoTG9jLCB0cnVlKTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgIH0gZWxzZSBpZiAoaGFzRmluYWxseSkge1xuICAgICAgICAgICAgaWYgKHRoaXMucHJldiA8IGVudHJ5LmZpbmFsbHlMb2MpIHtcbiAgICAgICAgICAgICAgcmV0dXJuIGhhbmRsZShlbnRyeS5maW5hbGx5TG9jKTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJ0cnkgc3RhdGVtZW50IHdpdGhvdXQgY2F0Y2ggb3IgZmluYWxseVwiKTtcbiAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICB9LFxuXG4gICAgYWJydXB0OiBmdW5jdGlvbih0eXBlLCBhcmcpIHtcbiAgICAgIGZvciAodmFyIGkgPSB0aGlzLnRyeUVudHJpZXMubGVuZ3RoIC0gMTsgaSA+PSAwOyAtLWkpIHtcbiAgICAgICAgdmFyIGVudHJ5ID0gdGhpcy50cnlFbnRyaWVzW2ldO1xuICAgICAgICBpZiAoZW50cnkudHJ5TG9jIDw9IHRoaXMucHJldiAmJlxuICAgICAgICAgICAgaGFzT3duLmNhbGwoZW50cnksIFwiZmluYWxseUxvY1wiKSAmJlxuICAgICAgICAgICAgdGhpcy5wcmV2IDwgZW50cnkuZmluYWxseUxvYykge1xuICAgICAgICAgIHZhciBmaW5hbGx5RW50cnkgPSBlbnRyeTtcbiAgICAgICAgICBicmVhaztcbiAgICAgICAgfVxuICAgICAgfVxuXG4gICAgICBpZiAoZmluYWxseUVudHJ5ICYmXG4gICAgICAgICAgKHR5cGUgPT09IFwiYnJlYWtcIiB8fFxuICAgICAgICAgICB0eXBlID09PSBcImNvbnRpbnVlXCIpICYmXG4gICAgICAgICAgZmluYWxseUVudHJ5LnRyeUxvYyA8PSBhcmcgJiZcbiAgICAgICAgICBhcmcgPD0gZmluYWxseUVudHJ5LmZpbmFsbHlMb2MpIHtcbiAgICAgICAgLy8gSWdub3JlIHRoZSBmaW5hbGx5IGVudHJ5IGlmIGNvbnRyb2wgaXMgbm90IGp1bXBpbmcgdG8gYVxuICAgICAgICAvLyBsb2NhdGlvbiBvdXRzaWRlIHRoZSB0cnkvY2F0Y2ggYmxvY2suXG4gICAgICAgIGZpbmFsbHlFbnRyeSA9IG51bGw7XG4gICAgICB9XG5cbiAgICAgIHZhciByZWNvcmQgPSBmaW5hbGx5RW50cnkgPyBmaW5hbGx5RW50cnkuY29tcGxldGlvbiA6IHt9O1xuICAgICAgcmVjb3JkLnR5cGUgPSB0eXBlO1xuICAgICAgcmVjb3JkLmFyZyA9IGFyZztcblxuICAgICAgaWYgKGZpbmFsbHlFbnRyeSkge1xuICAgICAgICB0aGlzLm1ldGhvZCA9IFwibmV4dFwiO1xuICAgICAgICB0aGlzLm5leHQgPSBmaW5hbGx5RW50cnkuZmluYWxseUxvYztcbiAgICAgICAgcmV0dXJuIENvbnRpbnVlU2VudGluZWw7XG4gICAgICB9XG5cbiAgICAgIHJldHVybiB0aGlzLmNvbXBsZXRlKHJlY29yZCk7XG4gICAgfSxcblxuICAgIGNvbXBsZXRlOiBmdW5jdGlvbihyZWNvcmQsIGFmdGVyTG9jKSB7XG4gICAgICBpZiAocmVjb3JkLnR5cGUgPT09IFwidGhyb3dcIikge1xuICAgICAgICB0aHJvdyByZWNvcmQuYXJnO1xuICAgICAgfVxuXG4gICAgICBpZiAocmVjb3JkLnR5cGUgPT09IFwiYnJlYWtcIiB8fFxuICAgICAgICAgIHJlY29yZC50eXBlID09PSBcImNvbnRpbnVlXCIpIHtcbiAgICAgICAgdGhpcy5uZXh0ID0gcmVjb3JkLmFyZztcbiAgICAgIH0gZWxzZSBpZiAocmVjb3JkLnR5cGUgPT09IFwicmV0dXJuXCIpIHtcbiAgICAgICAgdGhpcy5ydmFsID0gdGhpcy5hcmcgPSByZWNvcmQuYXJnO1xuICAgICAgICB0aGlzLm1ldGhvZCA9IFwicmV0dXJuXCI7XG4gICAgICAgIHRoaXMubmV4dCA9IFwiZW5kXCI7XG4gICAgICB9IGVsc2UgaWYgKHJlY29yZC50eXBlID09PSBcIm5vcm1hbFwiICYmIGFmdGVyTG9jKSB7XG4gICAgICAgIHRoaXMubmV4dCA9IGFmdGVyTG9jO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gQ29udGludWVTZW50aW5lbDtcbiAgICB9LFxuXG4gICAgZmluaXNoOiBmdW5jdGlvbihmaW5hbGx5TG9jKSB7XG4gICAgICBmb3IgKHZhciBpID0gdGhpcy50cnlFbnRyaWVzLmxlbmd0aCAtIDE7IGkgPj0gMDsgLS1pKSB7XG4gICAgICAgIHZhciBlbnRyeSA9IHRoaXMudHJ5RW50cmllc1tpXTtcbiAgICAgICAgaWYgKGVudHJ5LmZpbmFsbHlMb2MgPT09IGZpbmFsbHlMb2MpIHtcbiAgICAgICAgICB0aGlzLmNvbXBsZXRlKGVudHJ5LmNvbXBsZXRpb24sIGVudHJ5LmFmdGVyTG9jKTtcbiAgICAgICAgICByZXNldFRyeUVudHJ5KGVudHJ5KTtcbiAgICAgICAgICByZXR1cm4gQ29udGludWVTZW50aW5lbDtcbiAgICAgICAgfVxuICAgICAgfVxuICAgIH0sXG5cbiAgICBcImNhdGNoXCI6IGZ1bmN0aW9uKHRyeUxvYykge1xuICAgICAgZm9yICh2YXIgaSA9IHRoaXMudHJ5RW50cmllcy5sZW5ndGggLSAxOyBpID49IDA7IC0taSkge1xuICAgICAgICB2YXIgZW50cnkgPSB0aGlzLnRyeUVudHJpZXNbaV07XG4gICAgICAgIGlmIChlbnRyeS50cnlMb2MgPT09IHRyeUxvYykge1xuICAgICAgICAgIHZhciByZWNvcmQgPSBlbnRyeS5jb21wbGV0aW9uO1xuICAgICAgICAgIGlmIChyZWNvcmQudHlwZSA9PT0gXCJ0aHJvd1wiKSB7XG4gICAgICAgICAgICB2YXIgdGhyb3duID0gcmVjb3JkLmFyZztcbiAgICAgICAgICAgIHJlc2V0VHJ5RW50cnkoZW50cnkpO1xuICAgICAgICAgIH1cbiAgICAgICAgICByZXR1cm4gdGhyb3duO1xuICAgICAgICB9XG4gICAgICB9XG5cbiAgICAgIC8vIFRoZSBjb250ZXh0LmNhdGNoIG1ldGhvZCBtdXN0IG9ubHkgYmUgY2FsbGVkIHdpdGggYSBsb2NhdGlvblxuICAgICAgLy8gYXJndW1lbnQgdGhhdCBjb3JyZXNwb25kcyB0byBhIGtub3duIGNhdGNoIGJsb2NrLlxuICAgICAgdGhyb3cgbmV3IEVycm9yKFwiaWxsZWdhbCBjYXRjaCBhdHRlbXB0XCIpO1xuICAgIH0sXG5cbiAgICBkZWxlZ2F0ZVlpZWxkOiBmdW5jdGlvbihpdGVyYWJsZSwgcmVzdWx0TmFtZSwgbmV4dExvYykge1xuICAgICAgdGhpcy5kZWxlZ2F0ZSA9IHtcbiAgICAgICAgaXRlcmF0b3I6IHZhbHVlcyhpdGVyYWJsZSksXG4gICAgICAgIHJlc3VsdE5hbWU6IHJlc3VsdE5hbWUsXG4gICAgICAgIG5leHRMb2M6IG5leHRMb2NcbiAgICAgIH07XG5cbiAgICAgIGlmICh0aGlzLm1ldGhvZCA9PT0gXCJuZXh0XCIpIHtcbiAgICAgICAgLy8gRGVsaWJlcmF0ZWx5IGZvcmdldCB0aGUgbGFzdCBzZW50IHZhbHVlIHNvIHRoYXQgd2UgZG9uJ3RcbiAgICAgICAgLy8gYWNjaWRlbnRhbGx5IHBhc3MgaXQgb24gdG8gdGhlIGRlbGVnYXRlLlxuICAgICAgICB0aGlzLmFyZyA9IHVuZGVmaW5lZDtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIENvbnRpbnVlU2VudGluZWw7XG4gICAgfVxuICB9O1xuXG4gIC8vIFJlZ2FyZGxlc3Mgb2Ygd2hldGhlciB0aGlzIHNjcmlwdCBpcyBleGVjdXRpbmcgYXMgYSBDb21tb25KUyBtb2R1bGVcbiAgLy8gb3Igbm90LCByZXR1cm4gdGhlIHJ1bnRpbWUgb2JqZWN0IHNvIHRoYXQgd2UgY2FuIGRlY2xhcmUgdGhlIHZhcmlhYmxlXG4gIC8vIHJlZ2VuZXJhdG9yUnVudGltZSBpbiB0aGUgb3V0ZXIgc2NvcGUsIHdoaWNoIGFsbG93cyB0aGlzIG1vZHVsZSB0byBiZVxuICAvLyBpbmplY3RlZCBlYXNpbHkgYnkgYGJpbi9yZWdlbmVyYXRvciAtLWluY2x1ZGUtcnVudGltZSBzY3JpcHQuanNgLlxuICByZXR1cm4gZXhwb3J0cztcblxufShcbiAgLy8gSWYgdGhpcyBzY3JpcHQgaXMgZXhlY3V0aW5nIGFzIGEgQ29tbW9uSlMgbW9kdWxlLCB1c2UgbW9kdWxlLmV4cG9ydHNcbiAgLy8gYXMgdGhlIHJlZ2VuZXJhdG9yUnVudGltZSBuYW1lc3BhY2UuIE90aGVyd2lzZSBjcmVhdGUgYSBuZXcgZW1wdHlcbiAgLy8gb2JqZWN0LiBFaXRoZXIgd2F5LCB0aGUgcmVzdWx0aW5nIG9iamVjdCB3aWxsIGJlIHVzZWQgdG8gaW5pdGlhbGl6ZVxuICAvLyB0aGUgcmVnZW5lcmF0b3JSdW50aW1lIHZhcmlhYmxlIGF0IHRoZSB0b3Agb2YgdGhpcyBmaWxlLlxuICB0eXBlb2YgbW9kdWxlID09PSBcIm9iamVjdFwiID8gbW9kdWxlLmV4cG9ydHMgOiB7fVxuKSk7XG5cbnRyeSB7XG4gIHJlZ2VuZXJhdG9yUnVudGltZSA9IHJ1bnRpbWU7XG59IGNhdGNoIChhY2NpZGVudGFsU3RyaWN0TW9kZSkge1xuICAvLyBUaGlzIG1vZHVsZSBzaG91bGQgbm90IGJlIHJ1bm5pbmcgaW4gc3RyaWN0IG1vZGUsIHNvIHRoZSBhYm92ZVxuICAvLyBhc3NpZ25tZW50IHNob3VsZCBhbHdheXMgd29yayB1bmxlc3Mgc29tZXRoaW5nIGlzIG1pc2NvbmZpZ3VyZWQuIEp1c3RcbiAgLy8gaW4gY2FzZSBydW50aW1lLmpzIGFjY2lkZW50YWxseSBydW5zIGluIHN0cmljdCBtb2RlLCB3ZSBjYW4gZXNjYXBlXG4gIC8vIHN0cmljdCBtb2RlIHVzaW5nIGEgZ2xvYmFsIEZ1bmN0aW9uIGNhbGwuIFRoaXMgY291bGQgY29uY2VpdmFibHkgZmFpbFxuICAvLyBpZiBhIENvbnRlbnQgU2VjdXJpdHkgUG9saWN5IGZvcmJpZHMgdXNpbmcgRnVuY3Rpb24sIGJ1dCBpbiB0aGF0IGNhc2VcbiAgLy8gdGhlIHByb3BlciBzb2x1dGlvbiBpcyB0byBmaXggdGhlIGFjY2lkZW50YWwgc3RyaWN0IG1vZGUgcHJvYmxlbS4gSWZcbiAgLy8geW91J3ZlIG1pc2NvbmZpZ3VyZWQgeW91ciBidW5kbGVyIHRvIGZvcmNlIHN0cmljdCBtb2RlIGFuZCBhcHBsaWVkIGFcbiAgLy8gQ1NQIHRvIGZvcmJpZCBGdW5jdGlvbiwgYW5kIHlvdSdyZSBub3Qgd2lsbGluZyB0byBmaXggZWl0aGVyIG9mIHRob3NlXG4gIC8vIHByb2JsZW1zLCBwbGVhc2UgZGV0YWlsIHlvdXIgdW5pcXVlIHByZWRpY2FtZW50IGluIGEgR2l0SHViIGlzc3VlLlxuICBGdW5jdGlvbihcInJcIiwgXCJyZWdlbmVyYXRvclJ1bnRpbWUgPSByXCIpKHJ1bnRpbWUpO1xufVxuIiwiKGZ1bmN0aW9uIChnbG9iYWwsIGZhY3RvcnkpIHtcbiAgaWYgKHR5cGVvZiBkZWZpbmUgPT09IFwiZnVuY3Rpb25cIiAmJiBkZWZpbmUuYW1kKSB7XG4gICAgZGVmaW5lKFwid2ViZXh0ZW5zaW9uLXBvbHlmaWxsXCIsIFtcIm1vZHVsZVwiXSwgZmFjdG9yeSk7XG4gIH0gZWxzZSBpZiAodHlwZW9mIGV4cG9ydHMgIT09IFwidW5kZWZpbmVkXCIpIHtcbiAgICBmYWN0b3J5KG1vZHVsZSk7XG4gIH0gZWxzZSB7XG4gICAgdmFyIG1vZCA9IHtcbiAgICAgIGV4cG9ydHM6IHt9XG4gICAgfTtcbiAgICBmYWN0b3J5KG1vZCk7XG4gICAgZ2xvYmFsLmJyb3dzZXIgPSBtb2QuZXhwb3J0cztcbiAgfVxufSkodHlwZW9mIGdsb2JhbFRoaXMgIT09IFwidW5kZWZpbmVkXCIgPyBnbG9iYWxUaGlzIDogdHlwZW9mIHNlbGYgIT09IFwidW5kZWZpbmVkXCIgPyBzZWxmIDogdGhpcywgZnVuY3Rpb24gKG1vZHVsZSkge1xuICAvKiB3ZWJleHRlbnNpb24tcG9seWZpbGwgLSB2MC44LjAgLSBUdWUgQXByIDIwIDIwMjEgMTE6Mjc6MzggKi9cblxuICAvKiAtKi0gTW9kZTogaW5kZW50LXRhYnMtbW9kZTogbmlsOyBqcy1pbmRlbnQtbGV2ZWw6IDIgLSotICovXG5cbiAgLyogdmltOiBzZXQgc3RzPTIgc3c9MiBldCB0dz04MDogKi9cblxuICAvKiBUaGlzIFNvdXJjZSBDb2RlIEZvcm0gaXMgc3ViamVjdCB0byB0aGUgdGVybXMgb2YgdGhlIE1vemlsbGEgUHVibGljXG4gICAqIExpY2Vuc2UsIHYuIDIuMC4gSWYgYSBjb3B5IG9mIHRoZSBNUEwgd2FzIG5vdCBkaXN0cmlidXRlZCB3aXRoIHRoaXNcbiAgICogZmlsZSwgWW91IGNhbiBvYnRhaW4gb25lIGF0IGh0dHA6Ly9tb3ppbGxhLm9yZy9NUEwvMi4wLy4gKi9cbiAgXCJ1c2Ugc3RyaWN0XCI7XG5cbiAgaWYgKHR5cGVvZiBicm93c2VyID09PSBcInVuZGVmaW5lZFwiIHx8IE9iamVjdC5nZXRQcm90b3R5cGVPZihicm93c2VyKSAhPT0gT2JqZWN0LnByb3RvdHlwZSkge1xuICAgIGNvbnN0IENIUk9NRV9TRU5EX01FU1NBR0VfQ0FMTEJBQ0tfTk9fUkVTUE9OU0VfTUVTU0FHRSA9IFwiVGhlIG1lc3NhZ2UgcG9ydCBjbG9zZWQgYmVmb3JlIGEgcmVzcG9uc2Ugd2FzIHJlY2VpdmVkLlwiO1xuICAgIGNvbnN0IFNFTkRfUkVTUE9OU0VfREVQUkVDQVRJT05fV0FSTklORyA9IFwiUmV0dXJuaW5nIGEgUHJvbWlzZSBpcyB0aGUgcHJlZmVycmVkIHdheSB0byBzZW5kIGEgcmVwbHkgZnJvbSBhbiBvbk1lc3NhZ2Uvb25NZXNzYWdlRXh0ZXJuYWwgbGlzdGVuZXIsIGFzIHRoZSBzZW5kUmVzcG9uc2Ugd2lsbCBiZSByZW1vdmVkIGZyb20gdGhlIHNwZWNzIChTZWUgaHR0cHM6Ly9kZXZlbG9wZXIubW96aWxsYS5vcmcvZG9jcy9Nb3ppbGxhL0FkZC1vbnMvV2ViRXh0ZW5zaW9ucy9BUEkvcnVudGltZS9vbk1lc3NhZ2UpXCI7IC8vIFdyYXBwaW5nIHRoZSBidWxrIG9mIHRoaXMgcG9seWZpbGwgaW4gYSBvbmUtdGltZS11c2UgZnVuY3Rpb24gaXMgYSBtaW5vclxuICAgIC8vIG9wdGltaXphdGlvbiBmb3IgRmlyZWZveC4gU2luY2UgU3BpZGVybW9ua2V5IGRvZXMgbm90IGZ1bGx5IHBhcnNlIHRoZVxuICAgIC8vIGNvbnRlbnRzIG9mIGEgZnVuY3Rpb24gdW50aWwgdGhlIGZpcnN0IHRpbWUgaXQncyBjYWxsZWQsIGFuZCBzaW5jZSBpdCB3aWxsXG4gICAgLy8gbmV2ZXIgYWN0dWFsbHkgbmVlZCB0byBiZSBjYWxsZWQsIHRoaXMgYWxsb3dzIHRoZSBwb2x5ZmlsbCB0byBiZSBpbmNsdWRlZFxuICAgIC8vIGluIEZpcmVmb3ggbmVhcmx5IGZvciBmcmVlLlxuXG4gICAgY29uc3Qgd3JhcEFQSXMgPSBleHRlbnNpb25BUElzID0+IHtcbiAgICAgIC8vIE5PVEU6IGFwaU1ldGFkYXRhIGlzIGFzc29jaWF0ZWQgdG8gdGhlIGNvbnRlbnQgb2YgdGhlIGFwaS1tZXRhZGF0YS5qc29uIGZpbGVcbiAgICAgIC8vIGF0IGJ1aWxkIHRpbWUgYnkgcmVwbGFjaW5nIHRoZSBmb2xsb3dpbmcgXCJpbmNsdWRlXCIgd2l0aCB0aGUgY29udGVudCBvZiB0aGVcbiAgICAgIC8vIEpTT04gZmlsZS5cbiAgICAgIGNvbnN0IGFwaU1ldGFkYXRhID0ge1xuICAgICAgICBcImFsYXJtc1wiOiB7XG4gICAgICAgICAgXCJjbGVhclwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImNsZWFyQWxsXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0QWxsXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwiYm9va21hcmtzXCI6IHtcbiAgICAgICAgICBcImNyZWF0ZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldENoaWxkcmVuXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0UmVjZW50XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0U3ViVHJlZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFRyZWVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJtb3ZlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAyLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDJcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicmVtb3ZlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicmVtb3ZlVHJlZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNlYXJjaFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInVwZGF0ZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMixcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAyXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcImJyb3dzZXJBY3Rpb25cIjoge1xuICAgICAgICAgIFwiZGlzYWJsZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJmYWxsYmFja1RvTm9DYWxsYmFja1wiOiB0cnVlXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImVuYWJsZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJmYWxsYmFja1RvTm9DYWxsYmFja1wiOiB0cnVlXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldEJhZGdlQmFja2dyb3VuZENvbG9yXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0QmFkZ2VUZXh0XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0UG9wdXBcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRUaXRsZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcIm9wZW5Qb3B1cFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNldEJhZGdlQmFja2dyb3VuZENvbG9yXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDEsXG4gICAgICAgICAgICBcImZhbGxiYWNrVG9Ob0NhbGxiYWNrXCI6IHRydWVcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2V0QmFkZ2VUZXh0XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDEsXG4gICAgICAgICAgICBcImZhbGxiYWNrVG9Ob0NhbGxiYWNrXCI6IHRydWVcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2V0SWNvblwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNldFBvcHVwXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDEsXG4gICAgICAgICAgICBcImZhbGxiYWNrVG9Ob0NhbGxiYWNrXCI6IHRydWVcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2V0VGl0bGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwiZmFsbGJhY2tUb05vQ2FsbGJhY2tcIjogdHJ1ZVxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJicm93c2luZ0RhdGFcIjoge1xuICAgICAgICAgIFwicmVtb3ZlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAyLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDJcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicmVtb3ZlQ2FjaGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZW1vdmVDb29raWVzXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicmVtb3ZlRG93bmxvYWRzXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicmVtb3ZlRm9ybURhdGFcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZW1vdmVIaXN0b3J5XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicmVtb3ZlTG9jYWxTdG9yYWdlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicmVtb3ZlUGFzc3dvcmRzXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicmVtb3ZlUGx1Z2luRGF0YVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNldHRpbmdzXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwiY29tbWFuZHNcIjoge1xuICAgICAgICAgIFwiZ2V0QWxsXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwiY29udGV4dE1lbnVzXCI6IHtcbiAgICAgICAgICBcInJlbW92ZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZUFsbFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInVwZGF0ZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMixcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAyXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcImNvb2tpZXNcIjoge1xuICAgICAgICAgIFwiZ2V0XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0QWxsXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0QWxsQ29va2llU3RvcmVzXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicmVtb3ZlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2V0XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwiZGV2dG9vbHNcIjoge1xuICAgICAgICAgIFwiaW5zcGVjdGVkV2luZG93XCI6IHtcbiAgICAgICAgICAgIFwiZXZhbFwiOiB7XG4gICAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgICBcIm1heEFyZ3NcIjogMixcbiAgICAgICAgICAgICAgXCJzaW5nbGVDYWxsYmFja0FyZ1wiOiBmYWxzZVxuICAgICAgICAgICAgfVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJwYW5lbHNcIjoge1xuICAgICAgICAgICAgXCJjcmVhdGVcIjoge1xuICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMyxcbiAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDMsXG4gICAgICAgICAgICAgIFwic2luZ2xlQ2FsbGJhY2tBcmdcIjogdHJ1ZVxuICAgICAgICAgICAgfSxcbiAgICAgICAgICAgIFwiZWxlbWVudHNcIjoge1xuICAgICAgICAgICAgICBcImNyZWF0ZVNpZGViYXJQYW5lXCI6IHtcbiAgICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcImRvd25sb2Fkc1wiOiB7XG4gICAgICAgICAgXCJjYW5jZWxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJkb3dubG9hZFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImVyYXNlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0RmlsZUljb25cIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJvcGVuXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDEsXG4gICAgICAgICAgICBcImZhbGxiYWNrVG9Ob0NhbGxiYWNrXCI6IHRydWVcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicGF1c2VcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJyZW1vdmVGaWxlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicmVzdW1lXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2VhcmNoXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2hvd1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJmYWxsYmFja1RvTm9DYWxsYmFja1wiOiB0cnVlXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcImV4dGVuc2lvblwiOiB7XG4gICAgICAgICAgXCJpc0FsbG93ZWRGaWxlU2NoZW1lQWNjZXNzXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiaXNBbGxvd2VkSW5jb2duaXRvQWNjZXNzXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwiaGlzdG9yeVwiOiB7XG4gICAgICAgICAgXCJhZGRVcmxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJkZWxldGVBbGxcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJkZWxldGVSYW5nZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImRlbGV0ZVVybFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFZpc2l0c1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNlYXJjaFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcImkxOG5cIjoge1xuICAgICAgICAgIFwiZGV0ZWN0TGFuZ3VhZ2VcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRBY2NlcHRMYW5ndWFnZXNcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJpZGVudGl0eVwiOiB7XG4gICAgICAgICAgXCJsYXVuY2hXZWJBdXRoRmxvd1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcImlkbGVcIjoge1xuICAgICAgICAgIFwicXVlcnlTdGF0ZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcIm1hbmFnZW1lbnRcIjoge1xuICAgICAgICAgIFwiZ2V0XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0QWxsXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0U2VsZlwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNldEVuYWJsZWRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDIsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJ1bmluc3RhbGxTZWxmXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwibm90aWZpY2F0aW9uc1wiOiB7XG4gICAgICAgICAgXCJjbGVhclwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImNyZWF0ZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAyXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldEFsbFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFBlcm1pc3Npb25MZXZlbFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInVwZGF0ZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMixcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAyXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcInBhZ2VBY3Rpb25cIjoge1xuICAgICAgICAgIFwiZ2V0UG9wdXBcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRUaXRsZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImhpZGVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwiZmFsbGJhY2tUb05vQ2FsbGJhY2tcIjogdHJ1ZVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZXRJY29uXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2V0UG9wdXBcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwiZmFsbGJhY2tUb05vQ2FsbGJhY2tcIjogdHJ1ZVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZXRUaXRsZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJmYWxsYmFja1RvTm9DYWxsYmFja1wiOiB0cnVlXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNob3dcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwiZmFsbGJhY2tUb05vQ2FsbGJhY2tcIjogdHJ1ZVxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJwZXJtaXNzaW9uc1wiOiB7XG4gICAgICAgICAgXCJjb250YWluc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldEFsbFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlcXVlc3RcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJydW50aW1lXCI6IHtcbiAgICAgICAgICBcImdldEJhY2tncm91bmRQYWdlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0UGxhdGZvcm1JbmZvXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwib3Blbk9wdGlvbnNQYWdlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwicmVxdWVzdFVwZGF0ZUNoZWNrXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2VuZE1lc3NhZ2VcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogM1xuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzZW5kTmF0aXZlTWVzc2FnZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMixcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAyXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNldFVuaW5zdGFsbFVSTFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcInNlc3Npb25zXCI6IHtcbiAgICAgICAgICBcImdldERldmljZXNcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRSZWNlbnRseUNsb3NlZFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlc3RvcmVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJzdG9yYWdlXCI6IHtcbiAgICAgICAgICBcImxvY2FsXCI6IHtcbiAgICAgICAgICAgIFwiY2xlYXJcIjoge1xuICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICAgIH0sXG4gICAgICAgICAgICBcImdldFwiOiB7XG4gICAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgICAgfSxcbiAgICAgICAgICAgIFwiZ2V0Qnl0ZXNJblVzZVwiOiB7XG4gICAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgICAgfSxcbiAgICAgICAgICAgIFwicmVtb3ZlXCI6IHtcbiAgICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgICB9LFxuICAgICAgICAgICAgXCJzZXRcIjoge1xuICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9LFxuICAgICAgICAgIFwibWFuYWdlZFwiOiB7XG4gICAgICAgICAgICBcImdldFwiOiB7XG4gICAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgICAgfSxcbiAgICAgICAgICAgIFwiZ2V0Qnl0ZXNJblVzZVwiOiB7XG4gICAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgICAgfVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJzeW5jXCI6IHtcbiAgICAgICAgICAgIFwiY2xlYXJcIjoge1xuICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICAgIH0sXG4gICAgICAgICAgICBcImdldFwiOiB7XG4gICAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgICAgfSxcbiAgICAgICAgICAgIFwiZ2V0Qnl0ZXNJblVzZVwiOiB7XG4gICAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgICAgfSxcbiAgICAgICAgICAgIFwicmVtb3ZlXCI6IHtcbiAgICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgICB9LFxuICAgICAgICAgICAgXCJzZXRcIjoge1xuICAgICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIFwidGFic1wiOiB7XG4gICAgICAgICAgXCJjYXB0dXJlVmlzaWJsZVRhYlwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAyXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImNyZWF0ZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImRldGVjdExhbmd1YWdlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZGlzY2FyZFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImR1cGxpY2F0ZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImV4ZWN1dGVTY3JpcHRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRDdXJyZW50XCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAwLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDBcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0Wm9vbVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFpvb21TZXR0aW5nc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdvQmFja1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdvRm9yd2FyZFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImhpZ2hsaWdodFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImluc2VydENTU1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAyXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcIm1vdmVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDIsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMlxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJxdWVyeVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbG9hZFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAyXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZUNTU1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAyXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNlbmRNZXNzYWdlXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAyLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDNcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwic2V0Wm9vbVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAyXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInNldFpvb21TZXR0aW5nc1wiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAyXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInVwZGF0ZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAyXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcInRvcFNpdGVzXCI6IHtcbiAgICAgICAgICBcImdldFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAwXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICBcIndlYk5hdmlnYXRpb25cIjoge1xuICAgICAgICAgIFwiZ2V0QWxsRnJhbWVzXCI6IHtcbiAgICAgICAgICAgIFwibWluQXJnc1wiOiAxLFxuICAgICAgICAgICAgXCJtYXhBcmdzXCI6IDFcbiAgICAgICAgICB9LFxuICAgICAgICAgIFwiZ2V0RnJhbWVcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDEsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJ3ZWJSZXF1ZXN0XCI6IHtcbiAgICAgICAgICBcImhhbmRsZXJCZWhhdmlvckNoYW5nZWRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMFxuICAgICAgICAgIH1cbiAgICAgICAgfSxcbiAgICAgICAgXCJ3aW5kb3dzXCI6IHtcbiAgICAgICAgICBcImNyZWF0ZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAyXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldEFsbFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcImdldEN1cnJlbnRcIjoge1xuICAgICAgICAgICAgXCJtaW5BcmdzXCI6IDAsXG4gICAgICAgICAgICBcIm1heEFyZ3NcIjogMVxuICAgICAgICAgIH0sXG4gICAgICAgICAgXCJnZXRMYXN0Rm9jdXNlZFwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMCxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInJlbW92ZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMSxcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAxXG4gICAgICAgICAgfSxcbiAgICAgICAgICBcInVwZGF0ZVwiOiB7XG4gICAgICAgICAgICBcIm1pbkFyZ3NcIjogMixcbiAgICAgICAgICAgIFwibWF4QXJnc1wiOiAyXG4gICAgICAgICAgfVxuICAgICAgICB9XG4gICAgICB9O1xuXG4gICAgICBpZiAoT2JqZWN0LmtleXMoYXBpTWV0YWRhdGEpLmxlbmd0aCA9PT0gMCkge1xuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJhcGktbWV0YWRhdGEuanNvbiBoYXMgbm90IGJlZW4gaW5jbHVkZWQgaW4gYnJvd3Nlci1wb2x5ZmlsbFwiKTtcbiAgICAgIH1cbiAgICAgIC8qKlxuICAgICAgICogQSBXZWFrTWFwIHN1YmNsYXNzIHdoaWNoIGNyZWF0ZXMgYW5kIHN0b3JlcyBhIHZhbHVlIGZvciBhbnkga2V5IHdoaWNoIGRvZXNcbiAgICAgICAqIG5vdCBleGlzdCB3aGVuIGFjY2Vzc2VkLCBidXQgYmVoYXZlcyBleGFjdGx5IGFzIGFuIG9yZGluYXJ5IFdlYWtNYXBcbiAgICAgICAqIG90aGVyd2lzZS5cbiAgICAgICAqXG4gICAgICAgKiBAcGFyYW0ge2Z1bmN0aW9ufSBjcmVhdGVJdGVtXG4gICAgICAgKiAgICAgICAgQSBmdW5jdGlvbiB3aGljaCB3aWxsIGJlIGNhbGxlZCBpbiBvcmRlciB0byBjcmVhdGUgdGhlIHZhbHVlIGZvciBhbnlcbiAgICAgICAqICAgICAgICBrZXkgd2hpY2ggZG9lcyBub3QgZXhpc3QsIHRoZSBmaXJzdCB0aW1lIGl0IGlzIGFjY2Vzc2VkLiBUaGVcbiAgICAgICAqICAgICAgICBmdW5jdGlvbiByZWNlaXZlcywgYXMgaXRzIG9ubHkgYXJndW1lbnQsIHRoZSBrZXkgYmVpbmcgY3JlYXRlZC5cbiAgICAgICAqL1xuXG5cbiAgICAgIGNsYXNzIERlZmF1bHRXZWFrTWFwIGV4dGVuZHMgV2Vha01hcCB7XG4gICAgICAgIGNvbnN0cnVjdG9yKGNyZWF0ZUl0ZW0sIGl0ZW1zID0gdW5kZWZpbmVkKSB7XG4gICAgICAgICAgc3VwZXIoaXRlbXMpO1xuICAgICAgICAgIHRoaXMuY3JlYXRlSXRlbSA9IGNyZWF0ZUl0ZW07XG4gICAgICAgIH1cblxuICAgICAgICBnZXQoa2V5KSB7XG4gICAgICAgICAgaWYgKCF0aGlzLmhhcyhrZXkpKSB7XG4gICAgICAgICAgICB0aGlzLnNldChrZXksIHRoaXMuY3JlYXRlSXRlbShrZXkpKTtcbiAgICAgICAgICB9XG5cbiAgICAgICAgICByZXR1cm4gc3VwZXIuZ2V0KGtleSk7XG4gICAgICAgIH1cblxuICAgICAgfVxuICAgICAgLyoqXG4gICAgICAgKiBSZXR1cm5zIHRydWUgaWYgdGhlIGdpdmVuIG9iamVjdCBpcyBhbiBvYmplY3Qgd2l0aCBhIGB0aGVuYCBtZXRob2QsIGFuZCBjYW5cbiAgICAgICAqIHRoZXJlZm9yZSBiZSBhc3N1bWVkIHRvIGJlaGF2ZSBhcyBhIFByb21pc2UuXG4gICAgICAgKlxuICAgICAgICogQHBhcmFtIHsqfSB2YWx1ZSBUaGUgdmFsdWUgdG8gdGVzdC5cbiAgICAgICAqIEByZXR1cm5zIHtib29sZWFufSBUcnVlIGlmIHRoZSB2YWx1ZSBpcyB0aGVuYWJsZS5cbiAgICAgICAqL1xuXG5cbiAgICAgIGNvbnN0IGlzVGhlbmFibGUgPSB2YWx1ZSA9PiB7XG4gICAgICAgIHJldHVybiB2YWx1ZSAmJiB0eXBlb2YgdmFsdWUgPT09IFwib2JqZWN0XCIgJiYgdHlwZW9mIHZhbHVlLnRoZW4gPT09IFwiZnVuY3Rpb25cIjtcbiAgICAgIH07XG4gICAgICAvKipcbiAgICAgICAqIENyZWF0ZXMgYW5kIHJldHVybnMgYSBmdW5jdGlvbiB3aGljaCwgd2hlbiBjYWxsZWQsIHdpbGwgcmVzb2x2ZSBvciByZWplY3RcbiAgICAgICAqIHRoZSBnaXZlbiBwcm9taXNlIGJhc2VkIG9uIGhvdyBpdCBpcyBjYWxsZWQ6XG4gICAgICAgKlxuICAgICAgICogLSBJZiwgd2hlbiBjYWxsZWQsIGBjaHJvbWUucnVudGltZS5sYXN0RXJyb3JgIGNvbnRhaW5zIGEgbm9uLW51bGwgb2JqZWN0LFxuICAgICAgICogICB0aGUgcHJvbWlzZSBpcyByZWplY3RlZCB3aXRoIHRoYXQgdmFsdWUuXG4gICAgICAgKiAtIElmIHRoZSBmdW5jdGlvbiBpcyBjYWxsZWQgd2l0aCBleGFjdGx5IG9uZSBhcmd1bWVudCwgdGhlIHByb21pc2UgaXNcbiAgICAgICAqICAgcmVzb2x2ZWQgdG8gdGhhdCB2YWx1ZS5cbiAgICAgICAqIC0gT3RoZXJ3aXNlLCB0aGUgcHJvbWlzZSBpcyByZXNvbHZlZCB0byBhbiBhcnJheSBjb250YWluaW5nIGFsbCBvZiB0aGVcbiAgICAgICAqICAgZnVuY3Rpb24ncyBhcmd1bWVudHMuXG4gICAgICAgKlxuICAgICAgICogQHBhcmFtIHtvYmplY3R9IHByb21pc2VcbiAgICAgICAqICAgICAgICBBbiBvYmplY3QgY29udGFpbmluZyB0aGUgcmVzb2x1dGlvbiBhbmQgcmVqZWN0aW9uIGZ1bmN0aW9ucyBvZiBhXG4gICAgICAgKiAgICAgICAgcHJvbWlzZS5cbiAgICAgICAqIEBwYXJhbSB7ZnVuY3Rpb259IHByb21pc2UucmVzb2x2ZVxuICAgICAgICogICAgICAgIFRoZSBwcm9taXNlJ3MgcmVzb2x1dGlvbiBmdW5jdGlvbi5cbiAgICAgICAqIEBwYXJhbSB7ZnVuY3Rpb259IHByb21pc2UucmVqZWN0XG4gICAgICAgKiAgICAgICAgVGhlIHByb21pc2UncyByZWplY3Rpb24gZnVuY3Rpb24uXG4gICAgICAgKiBAcGFyYW0ge29iamVjdH0gbWV0YWRhdGFcbiAgICAgICAqICAgICAgICBNZXRhZGF0YSBhYm91dCB0aGUgd3JhcHBlZCBtZXRob2Qgd2hpY2ggaGFzIGNyZWF0ZWQgdGhlIGNhbGxiYWNrLlxuICAgICAgICogQHBhcmFtIHtib29sZWFufSBtZXRhZGF0YS5zaW5nbGVDYWxsYmFja0FyZ1xuICAgICAgICogICAgICAgIFdoZXRoZXIgb3Igbm90IHRoZSBwcm9taXNlIGlzIHJlc29sdmVkIHdpdGggb25seSB0aGUgZmlyc3RcbiAgICAgICAqICAgICAgICBhcmd1bWVudCBvZiB0aGUgY2FsbGJhY2ssIGFsdGVybmF0aXZlbHkgYW4gYXJyYXkgb2YgYWxsIHRoZVxuICAgICAgICogICAgICAgIGNhbGxiYWNrIGFyZ3VtZW50cyBpcyByZXNvbHZlZC4gQnkgZGVmYXVsdCwgaWYgdGhlIGNhbGxiYWNrXG4gICAgICAgKiAgICAgICAgZnVuY3Rpb24gaXMgaW52b2tlZCB3aXRoIG9ubHkgYSBzaW5nbGUgYXJndW1lbnQsIHRoYXQgd2lsbCBiZVxuICAgICAgICogICAgICAgIHJlc29sdmVkIHRvIHRoZSBwcm9taXNlLCB3aGlsZSBhbGwgYXJndW1lbnRzIHdpbGwgYmUgcmVzb2x2ZWQgYXNcbiAgICAgICAqICAgICAgICBhbiBhcnJheSBpZiBtdWx0aXBsZSBhcmUgZ2l2ZW4uXG4gICAgICAgKlxuICAgICAgICogQHJldHVybnMge2Z1bmN0aW9ufVxuICAgICAgICogICAgICAgIFRoZSBnZW5lcmF0ZWQgY2FsbGJhY2sgZnVuY3Rpb24uXG4gICAgICAgKi9cblxuXG4gICAgICBjb25zdCBtYWtlQ2FsbGJhY2sgPSAocHJvbWlzZSwgbWV0YWRhdGEpID0+IHtcbiAgICAgICAgcmV0dXJuICguLi5jYWxsYmFja0FyZ3MpID0+IHtcbiAgICAgICAgICBpZiAoZXh0ZW5zaW9uQVBJcy5ydW50aW1lLmxhc3RFcnJvcikge1xuICAgICAgICAgICAgcHJvbWlzZS5yZWplY3QobmV3IEVycm9yKGV4dGVuc2lvbkFQSXMucnVudGltZS5sYXN0RXJyb3IubWVzc2FnZSkpO1xuICAgICAgICAgIH0gZWxzZSBpZiAobWV0YWRhdGEuc2luZ2xlQ2FsbGJhY2tBcmcgfHwgY2FsbGJhY2tBcmdzLmxlbmd0aCA8PSAxICYmIG1ldGFkYXRhLnNpbmdsZUNhbGxiYWNrQXJnICE9PSBmYWxzZSkge1xuICAgICAgICAgICAgcHJvbWlzZS5yZXNvbHZlKGNhbGxiYWNrQXJnc1swXSk7XG4gICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIHByb21pc2UucmVzb2x2ZShjYWxsYmFja0FyZ3MpO1xuICAgICAgICAgIH1cbiAgICAgICAgfTtcbiAgICAgIH07XG5cbiAgICAgIGNvbnN0IHBsdXJhbGl6ZUFyZ3VtZW50cyA9IG51bUFyZ3MgPT4gbnVtQXJncyA9PSAxID8gXCJhcmd1bWVudFwiIDogXCJhcmd1bWVudHNcIjtcbiAgICAgIC8qKlxuICAgICAgICogQ3JlYXRlcyBhIHdyYXBwZXIgZnVuY3Rpb24gZm9yIGEgbWV0aG9kIHdpdGggdGhlIGdpdmVuIG5hbWUgYW5kIG1ldGFkYXRhLlxuICAgICAgICpcbiAgICAgICAqIEBwYXJhbSB7c3RyaW5nfSBuYW1lXG4gICAgICAgKiAgICAgICAgVGhlIG5hbWUgb2YgdGhlIG1ldGhvZCB3aGljaCBpcyBiZWluZyB3cmFwcGVkLlxuICAgICAgICogQHBhcmFtIHtvYmplY3R9IG1ldGFkYXRhXG4gICAgICAgKiAgICAgICAgTWV0YWRhdGEgYWJvdXQgdGhlIG1ldGhvZCBiZWluZyB3cmFwcGVkLlxuICAgICAgICogQHBhcmFtIHtpbnRlZ2VyfSBtZXRhZGF0YS5taW5BcmdzXG4gICAgICAgKiAgICAgICAgVGhlIG1pbmltdW0gbnVtYmVyIG9mIGFyZ3VtZW50cyB3aGljaCBtdXN0IGJlIHBhc3NlZCB0byB0aGVcbiAgICAgICAqICAgICAgICBmdW5jdGlvbi4gSWYgY2FsbGVkIHdpdGggZmV3ZXIgdGhhbiB0aGlzIG51bWJlciBvZiBhcmd1bWVudHMsIHRoZVxuICAgICAgICogICAgICAgIHdyYXBwZXIgd2lsbCByYWlzZSBhbiBleGNlcHRpb24uXG4gICAgICAgKiBAcGFyYW0ge2ludGVnZXJ9IG1ldGFkYXRhLm1heEFyZ3NcbiAgICAgICAqICAgICAgICBUaGUgbWF4aW11bSBudW1iZXIgb2YgYXJndW1lbnRzIHdoaWNoIG1heSBiZSBwYXNzZWQgdG8gdGhlXG4gICAgICAgKiAgICAgICAgZnVuY3Rpb24uIElmIGNhbGxlZCB3aXRoIG1vcmUgdGhhbiB0aGlzIG51bWJlciBvZiBhcmd1bWVudHMsIHRoZVxuICAgICAgICogICAgICAgIHdyYXBwZXIgd2lsbCByYWlzZSBhbiBleGNlcHRpb24uXG4gICAgICAgKiBAcGFyYW0ge2Jvb2xlYW59IG1ldGFkYXRhLnNpbmdsZUNhbGxiYWNrQXJnXG4gICAgICAgKiAgICAgICAgV2hldGhlciBvciBub3QgdGhlIHByb21pc2UgaXMgcmVzb2x2ZWQgd2l0aCBvbmx5IHRoZSBmaXJzdFxuICAgICAgICogICAgICAgIGFyZ3VtZW50IG9mIHRoZSBjYWxsYmFjaywgYWx0ZXJuYXRpdmVseSBhbiBhcnJheSBvZiBhbGwgdGhlXG4gICAgICAgKiAgICAgICAgY2FsbGJhY2sgYXJndW1lbnRzIGlzIHJlc29sdmVkLiBCeSBkZWZhdWx0LCBpZiB0aGUgY2FsbGJhY2tcbiAgICAgICAqICAgICAgICBmdW5jdGlvbiBpcyBpbnZva2VkIHdpdGggb25seSBhIHNpbmdsZSBhcmd1bWVudCwgdGhhdCB3aWxsIGJlXG4gICAgICAgKiAgICAgICAgcmVzb2x2ZWQgdG8gdGhlIHByb21pc2UsIHdoaWxlIGFsbCBhcmd1bWVudHMgd2lsbCBiZSByZXNvbHZlZCBhc1xuICAgICAgICogICAgICAgIGFuIGFycmF5IGlmIG11bHRpcGxlIGFyZSBnaXZlbi5cbiAgICAgICAqXG4gICAgICAgKiBAcmV0dXJucyB7ZnVuY3Rpb24ob2JqZWN0LCAuLi4qKX1cbiAgICAgICAqICAgICAgIFRoZSBnZW5lcmF0ZWQgd3JhcHBlciBmdW5jdGlvbi5cbiAgICAgICAqL1xuXG5cbiAgICAgIGNvbnN0IHdyYXBBc3luY0Z1bmN0aW9uID0gKG5hbWUsIG1ldGFkYXRhKSA9PiB7XG4gICAgICAgIHJldHVybiBmdW5jdGlvbiBhc3luY0Z1bmN0aW9uV3JhcHBlcih0YXJnZXQsIC4uLmFyZ3MpIHtcbiAgICAgICAgICBpZiAoYXJncy5sZW5ndGggPCBtZXRhZGF0YS5taW5BcmdzKSB7XG4gICAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoYEV4cGVjdGVkIGF0IGxlYXN0ICR7bWV0YWRhdGEubWluQXJnc30gJHtwbHVyYWxpemVBcmd1bWVudHMobWV0YWRhdGEubWluQXJncyl9IGZvciAke25hbWV9KCksIGdvdCAke2FyZ3MubGVuZ3RofWApO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIGlmIChhcmdzLmxlbmd0aCA+IG1ldGFkYXRhLm1heEFyZ3MpIHtcbiAgICAgICAgICAgIHRocm93IG5ldyBFcnJvcihgRXhwZWN0ZWQgYXQgbW9zdCAke21ldGFkYXRhLm1heEFyZ3N9ICR7cGx1cmFsaXplQXJndW1lbnRzKG1ldGFkYXRhLm1heEFyZ3MpfSBmb3IgJHtuYW1lfSgpLCBnb3QgJHthcmdzLmxlbmd0aH1gKTtcbiAgICAgICAgICB9XG5cbiAgICAgICAgICByZXR1cm4gbmV3IFByb21pc2UoKHJlc29sdmUsIHJlamVjdCkgPT4ge1xuICAgICAgICAgICAgaWYgKG1ldGFkYXRhLmZhbGxiYWNrVG9Ob0NhbGxiYWNrKSB7XG4gICAgICAgICAgICAgIC8vIFRoaXMgQVBJIG1ldGhvZCBoYXMgY3VycmVudGx5IG5vIGNhbGxiYWNrIG9uIENocm9tZSwgYnV0IGl0IHJldHVybiBhIHByb21pc2Ugb24gRmlyZWZveCxcbiAgICAgICAgICAgICAgLy8gYW5kIHNvIHRoZSBwb2x5ZmlsbCB3aWxsIHRyeSB0byBjYWxsIGl0IHdpdGggYSBjYWxsYmFjayBmaXJzdCwgYW5kIGl0IHdpbGwgZmFsbGJhY2tcbiAgICAgICAgICAgICAgLy8gdG8gbm90IHBhc3NpbmcgdGhlIGNhbGxiYWNrIGlmIHRoZSBmaXJzdCBjYWxsIGZhaWxzLlxuICAgICAgICAgICAgICB0cnkge1xuICAgICAgICAgICAgICAgIHRhcmdldFtuYW1lXSguLi5hcmdzLCBtYWtlQ2FsbGJhY2soe1xuICAgICAgICAgICAgICAgICAgcmVzb2x2ZSxcbiAgICAgICAgICAgICAgICAgIHJlamVjdFxuICAgICAgICAgICAgICAgIH0sIG1ldGFkYXRhKSk7XG4gICAgICAgICAgICAgIH0gY2F0Y2ggKGNiRXJyb3IpIHtcbiAgICAgICAgICAgICAgICBjb25zb2xlLndhcm4oYCR7bmFtZX0gQVBJIG1ldGhvZCBkb2Vzbid0IHNlZW0gdG8gc3VwcG9ydCB0aGUgY2FsbGJhY2sgcGFyYW1ldGVyLCBgICsgXCJmYWxsaW5nIGJhY2sgdG8gY2FsbCBpdCB3aXRob3V0IGEgY2FsbGJhY2s6IFwiLCBjYkVycm9yKTtcbiAgICAgICAgICAgICAgICB0YXJnZXRbbmFtZV0oLi4uYXJncyk7IC8vIFVwZGF0ZSB0aGUgQVBJIG1ldGhvZCBtZXRhZGF0YSwgc28gdGhhdCB0aGUgbmV4dCBBUEkgY2FsbHMgd2lsbCBub3QgdHJ5IHRvXG4gICAgICAgICAgICAgICAgLy8gdXNlIHRoZSB1bnN1cHBvcnRlZCBjYWxsYmFjayBhbnltb3JlLlxuXG4gICAgICAgICAgICAgICAgbWV0YWRhdGEuZmFsbGJhY2tUb05vQ2FsbGJhY2sgPSBmYWxzZTtcbiAgICAgICAgICAgICAgICBtZXRhZGF0YS5ub0NhbGxiYWNrID0gdHJ1ZTtcbiAgICAgICAgICAgICAgICByZXNvbHZlKCk7XG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH0gZWxzZSBpZiAobWV0YWRhdGEubm9DYWxsYmFjaykge1xuICAgICAgICAgICAgICB0YXJnZXRbbmFtZV0oLi4uYXJncyk7XG4gICAgICAgICAgICAgIHJlc29sdmUoKTtcbiAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgIHRhcmdldFtuYW1lXSguLi5hcmdzLCBtYWtlQ2FsbGJhY2soe1xuICAgICAgICAgICAgICAgIHJlc29sdmUsXG4gICAgICAgICAgICAgICAgcmVqZWN0XG4gICAgICAgICAgICAgIH0sIG1ldGFkYXRhKSk7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfSk7XG4gICAgICAgIH07XG4gICAgICB9O1xuICAgICAgLyoqXG4gICAgICAgKiBXcmFwcyBhbiBleGlzdGluZyBtZXRob2Qgb2YgdGhlIHRhcmdldCBvYmplY3QsIHNvIHRoYXQgY2FsbHMgdG8gaXQgYXJlXG4gICAgICAgKiBpbnRlcmNlcHRlZCBieSB0aGUgZ2l2ZW4gd3JhcHBlciBmdW5jdGlvbi4gVGhlIHdyYXBwZXIgZnVuY3Rpb24gcmVjZWl2ZXMsXG4gICAgICAgKiBhcyBpdHMgZmlyc3QgYXJndW1lbnQsIHRoZSBvcmlnaW5hbCBgdGFyZ2V0YCBvYmplY3QsIGZvbGxvd2VkIGJ5IGVhY2ggb2ZcbiAgICAgICAqIHRoZSBhcmd1bWVudHMgcGFzc2VkIHRvIHRoZSBvcmlnaW5hbCBtZXRob2QuXG4gICAgICAgKlxuICAgICAgICogQHBhcmFtIHtvYmplY3R9IHRhcmdldFxuICAgICAgICogICAgICAgIFRoZSBvcmlnaW5hbCB0YXJnZXQgb2JqZWN0IHRoYXQgdGhlIHdyYXBwZWQgbWV0aG9kIGJlbG9uZ3MgdG8uXG4gICAgICAgKiBAcGFyYW0ge2Z1bmN0aW9ufSBtZXRob2RcbiAgICAgICAqICAgICAgICBUaGUgbWV0aG9kIGJlaW5nIHdyYXBwZWQuIFRoaXMgaXMgdXNlZCBhcyB0aGUgdGFyZ2V0IG9mIHRoZSBQcm94eVxuICAgICAgICogICAgICAgIG9iamVjdCB3aGljaCBpcyBjcmVhdGVkIHRvIHdyYXAgdGhlIG1ldGhvZC5cbiAgICAgICAqIEBwYXJhbSB7ZnVuY3Rpb259IHdyYXBwZXJcbiAgICAgICAqICAgICAgICBUaGUgd3JhcHBlciBmdW5jdGlvbiB3aGljaCBpcyBjYWxsZWQgaW4gcGxhY2Ugb2YgYSBkaXJlY3QgaW52b2NhdGlvblxuICAgICAgICogICAgICAgIG9mIHRoZSB3cmFwcGVkIG1ldGhvZC5cbiAgICAgICAqXG4gICAgICAgKiBAcmV0dXJucyB7UHJveHk8ZnVuY3Rpb24+fVxuICAgICAgICogICAgICAgIEEgUHJveHkgb2JqZWN0IGZvciB0aGUgZ2l2ZW4gbWV0aG9kLCB3aGljaCBpbnZva2VzIHRoZSBnaXZlbiB3cmFwcGVyXG4gICAgICAgKiAgICAgICAgbWV0aG9kIGluIGl0cyBwbGFjZS5cbiAgICAgICAqL1xuXG5cbiAgICAgIGNvbnN0IHdyYXBNZXRob2QgPSAodGFyZ2V0LCBtZXRob2QsIHdyYXBwZXIpID0+IHtcbiAgICAgICAgcmV0dXJuIG5ldyBQcm94eShtZXRob2QsIHtcbiAgICAgICAgICBhcHBseSh0YXJnZXRNZXRob2QsIHRoaXNPYmosIGFyZ3MpIHtcbiAgICAgICAgICAgIHJldHVybiB3cmFwcGVyLmNhbGwodGhpc09iaiwgdGFyZ2V0LCAuLi5hcmdzKTtcbiAgICAgICAgICB9XG5cbiAgICAgICAgfSk7XG4gICAgICB9O1xuXG4gICAgICBsZXQgaGFzT3duUHJvcGVydHkgPSBGdW5jdGlvbi5jYWxsLmJpbmQoT2JqZWN0LnByb3RvdHlwZS5oYXNPd25Qcm9wZXJ0eSk7XG4gICAgICAvKipcbiAgICAgICAqIFdyYXBzIGFuIG9iamVjdCBpbiBhIFByb3h5IHdoaWNoIGludGVyY2VwdHMgYW5kIHdyYXBzIGNlcnRhaW4gbWV0aG9kc1xuICAgICAgICogYmFzZWQgb24gdGhlIGdpdmVuIGB3cmFwcGVyc2AgYW5kIGBtZXRhZGF0YWAgb2JqZWN0cy5cbiAgICAgICAqXG4gICAgICAgKiBAcGFyYW0ge29iamVjdH0gdGFyZ2V0XG4gICAgICAgKiAgICAgICAgVGhlIHRhcmdldCBvYmplY3QgdG8gd3JhcC5cbiAgICAgICAqXG4gICAgICAgKiBAcGFyYW0ge29iamVjdH0gW3dyYXBwZXJzID0ge31dXG4gICAgICAgKiAgICAgICAgQW4gb2JqZWN0IHRyZWUgY29udGFpbmluZyB3cmFwcGVyIGZ1bmN0aW9ucyBmb3Igc3BlY2lhbCBjYXNlcy4gQW55XG4gICAgICAgKiAgICAgICAgZnVuY3Rpb24gcHJlc2VudCBpbiB0aGlzIG9iamVjdCB0cmVlIGlzIGNhbGxlZCBpbiBwbGFjZSBvZiB0aGVcbiAgICAgICAqICAgICAgICBtZXRob2QgaW4gdGhlIHNhbWUgbG9jYXRpb24gaW4gdGhlIGB0YXJnZXRgIG9iamVjdCB0cmVlLiBUaGVzZVxuICAgICAgICogICAgICAgIHdyYXBwZXIgbWV0aG9kcyBhcmUgaW52b2tlZCBhcyBkZXNjcmliZWQgaW4ge0BzZWUgd3JhcE1ldGhvZH0uXG4gICAgICAgKlxuICAgICAgICogQHBhcmFtIHtvYmplY3R9IFttZXRhZGF0YSA9IHt9XVxuICAgICAgICogICAgICAgIEFuIG9iamVjdCB0cmVlIGNvbnRhaW5pbmcgbWV0YWRhdGEgdXNlZCB0byBhdXRvbWF0aWNhbGx5IGdlbmVyYXRlXG4gICAgICAgKiAgICAgICAgUHJvbWlzZS1iYXNlZCB3cmFwcGVyIGZ1bmN0aW9ucyBmb3IgYXN5bmNocm9ub3VzLiBBbnkgZnVuY3Rpb24gaW5cbiAgICAgICAqICAgICAgICB0aGUgYHRhcmdldGAgb2JqZWN0IHRyZWUgd2hpY2ggaGFzIGEgY29ycmVzcG9uZGluZyBtZXRhZGF0YSBvYmplY3RcbiAgICAgICAqICAgICAgICBpbiB0aGUgc2FtZSBsb2NhdGlvbiBpbiB0aGUgYG1ldGFkYXRhYCB0cmVlIGlzIHJlcGxhY2VkIHdpdGggYW5cbiAgICAgICAqICAgICAgICBhdXRvbWF0aWNhbGx5LWdlbmVyYXRlZCB3cmFwcGVyIGZ1bmN0aW9uLCBhcyBkZXNjcmliZWQgaW5cbiAgICAgICAqICAgICAgICB7QHNlZSB3cmFwQXN5bmNGdW5jdGlvbn1cbiAgICAgICAqXG4gICAgICAgKiBAcmV0dXJucyB7UHJveHk8b2JqZWN0Pn1cbiAgICAgICAqL1xuXG4gICAgICBjb25zdCB3cmFwT2JqZWN0ID0gKHRhcmdldCwgd3JhcHBlcnMgPSB7fSwgbWV0YWRhdGEgPSB7fSkgPT4ge1xuICAgICAgICBsZXQgY2FjaGUgPSBPYmplY3QuY3JlYXRlKG51bGwpO1xuICAgICAgICBsZXQgaGFuZGxlcnMgPSB7XG4gICAgICAgICAgaGFzKHByb3h5VGFyZ2V0LCBwcm9wKSB7XG4gICAgICAgICAgICByZXR1cm4gcHJvcCBpbiB0YXJnZXQgfHwgcHJvcCBpbiBjYWNoZTtcbiAgICAgICAgICB9LFxuXG4gICAgICAgICAgZ2V0KHByb3h5VGFyZ2V0LCBwcm9wLCByZWNlaXZlcikge1xuICAgICAgICAgICAgaWYgKHByb3AgaW4gY2FjaGUpIHtcbiAgICAgICAgICAgICAgcmV0dXJuIGNhY2hlW3Byb3BdO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICBpZiAoIShwcm9wIGluIHRhcmdldCkpIHtcbiAgICAgICAgICAgICAgcmV0dXJuIHVuZGVmaW5lZDtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgbGV0IHZhbHVlID0gdGFyZ2V0W3Byb3BdO1xuXG4gICAgICAgICAgICBpZiAodHlwZW9mIHZhbHVlID09PSBcImZ1bmN0aW9uXCIpIHtcbiAgICAgICAgICAgICAgLy8gVGhpcyBpcyBhIG1ldGhvZCBvbiB0aGUgdW5kZXJseWluZyBvYmplY3QuIENoZWNrIGlmIHdlIG5lZWQgdG8gZG9cbiAgICAgICAgICAgICAgLy8gYW55IHdyYXBwaW5nLlxuICAgICAgICAgICAgICBpZiAodHlwZW9mIHdyYXBwZXJzW3Byb3BdID09PSBcImZ1bmN0aW9uXCIpIHtcbiAgICAgICAgICAgICAgICAvLyBXZSBoYXZlIGEgc3BlY2lhbC1jYXNlIHdyYXBwZXIgZm9yIHRoaXMgbWV0aG9kLlxuICAgICAgICAgICAgICAgIHZhbHVlID0gd3JhcE1ldGhvZCh0YXJnZXQsIHRhcmdldFtwcm9wXSwgd3JhcHBlcnNbcHJvcF0pO1xuICAgICAgICAgICAgICB9IGVsc2UgaWYgKGhhc093blByb3BlcnR5KG1ldGFkYXRhLCBwcm9wKSkge1xuICAgICAgICAgICAgICAgIC8vIFRoaXMgaXMgYW4gYXN5bmMgbWV0aG9kIHRoYXQgd2UgaGF2ZSBtZXRhZGF0YSBmb3IuIENyZWF0ZSBhXG4gICAgICAgICAgICAgICAgLy8gUHJvbWlzZSB3cmFwcGVyIGZvciBpdC5cbiAgICAgICAgICAgICAgICBsZXQgd3JhcHBlciA9IHdyYXBBc3luY0Z1bmN0aW9uKHByb3AsIG1ldGFkYXRhW3Byb3BdKTtcbiAgICAgICAgICAgICAgICB2YWx1ZSA9IHdyYXBNZXRob2QodGFyZ2V0LCB0YXJnZXRbcHJvcF0sIHdyYXBwZXIpO1xuICAgICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICAgIC8vIFRoaXMgaXMgYSBtZXRob2QgdGhhdCB3ZSBkb24ndCBrbm93IG9yIGNhcmUgYWJvdXQuIFJldHVybiB0aGVcbiAgICAgICAgICAgICAgICAvLyBvcmlnaW5hbCBtZXRob2QsIGJvdW5kIHRvIHRoZSB1bmRlcmx5aW5nIG9iamVjdC5cbiAgICAgICAgICAgICAgICB2YWx1ZSA9IHZhbHVlLmJpbmQodGFyZ2V0KTtcbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfSBlbHNlIGlmICh0eXBlb2YgdmFsdWUgPT09IFwib2JqZWN0XCIgJiYgdmFsdWUgIT09IG51bGwgJiYgKGhhc093blByb3BlcnR5KHdyYXBwZXJzLCBwcm9wKSB8fCBoYXNPd25Qcm9wZXJ0eShtZXRhZGF0YSwgcHJvcCkpKSB7XG4gICAgICAgICAgICAgIC8vIFRoaXMgaXMgYW4gb2JqZWN0IHRoYXQgd2UgbmVlZCB0byBkbyBzb21lIHdyYXBwaW5nIGZvciB0aGUgY2hpbGRyZW5cbiAgICAgICAgICAgICAgLy8gb2YuIENyZWF0ZSBhIHN1Yi1vYmplY3Qgd3JhcHBlciBmb3IgaXQgd2l0aCB0aGUgYXBwcm9wcmlhdGUgY2hpbGRcbiAgICAgICAgICAgICAgLy8gbWV0YWRhdGEuXG4gICAgICAgICAgICAgIHZhbHVlID0gd3JhcE9iamVjdCh2YWx1ZSwgd3JhcHBlcnNbcHJvcF0sIG1ldGFkYXRhW3Byb3BdKTtcbiAgICAgICAgICAgIH0gZWxzZSBpZiAoaGFzT3duUHJvcGVydHkobWV0YWRhdGEsIFwiKlwiKSkge1xuICAgICAgICAgICAgICAvLyBXcmFwIGFsbCBwcm9wZXJ0aWVzIGluICogbmFtZXNwYWNlLlxuICAgICAgICAgICAgICB2YWx1ZSA9IHdyYXBPYmplY3QodmFsdWUsIHdyYXBwZXJzW3Byb3BdLCBtZXRhZGF0YVtcIipcIl0pO1xuICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgLy8gV2UgZG9uJ3QgbmVlZCB0byBkbyBhbnkgd3JhcHBpbmcgZm9yIHRoaXMgcHJvcGVydHksXG4gICAgICAgICAgICAgIC8vIHNvIGp1c3QgZm9yd2FyZCBhbGwgYWNjZXNzIHRvIHRoZSB1bmRlcmx5aW5nIG9iamVjdC5cbiAgICAgICAgICAgICAgT2JqZWN0LmRlZmluZVByb3BlcnR5KGNhY2hlLCBwcm9wLCB7XG4gICAgICAgICAgICAgICAgY29uZmlndXJhYmxlOiB0cnVlLFxuICAgICAgICAgICAgICAgIGVudW1lcmFibGU6IHRydWUsXG5cbiAgICAgICAgICAgICAgICBnZXQoKSB7XG4gICAgICAgICAgICAgICAgICByZXR1cm4gdGFyZ2V0W3Byb3BdO1xuICAgICAgICAgICAgICAgIH0sXG5cbiAgICAgICAgICAgICAgICBzZXQodmFsdWUpIHtcbiAgICAgICAgICAgICAgICAgIHRhcmdldFtwcm9wXSA9IHZhbHVlO1xuICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICB9KTtcbiAgICAgICAgICAgICAgcmV0dXJuIHZhbHVlO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICBjYWNoZVtwcm9wXSA9IHZhbHVlO1xuICAgICAgICAgICAgcmV0dXJuIHZhbHVlO1xuICAgICAgICAgIH0sXG5cbiAgICAgICAgICBzZXQocHJveHlUYXJnZXQsIHByb3AsIHZhbHVlLCByZWNlaXZlcikge1xuICAgICAgICAgICAgaWYgKHByb3AgaW4gY2FjaGUpIHtcbiAgICAgICAgICAgICAgY2FjaGVbcHJvcF0gPSB2YWx1ZTtcbiAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgIHRhcmdldFtwcm9wXSA9IHZhbHVlO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICByZXR1cm4gdHJ1ZTtcbiAgICAgICAgICB9LFxuXG4gICAgICAgICAgZGVmaW5lUHJvcGVydHkocHJveHlUYXJnZXQsIHByb3AsIGRlc2MpIHtcbiAgICAgICAgICAgIHJldHVybiBSZWZsZWN0LmRlZmluZVByb3BlcnR5KGNhY2hlLCBwcm9wLCBkZXNjKTtcbiAgICAgICAgICB9LFxuXG4gICAgICAgICAgZGVsZXRlUHJvcGVydHkocHJveHlUYXJnZXQsIHByb3ApIHtcbiAgICAgICAgICAgIHJldHVybiBSZWZsZWN0LmRlbGV0ZVByb3BlcnR5KGNhY2hlLCBwcm9wKTtcbiAgICAgICAgICB9XG5cbiAgICAgICAgfTsgLy8gUGVyIGNvbnRyYWN0IG9mIHRoZSBQcm94eSBBUEksIHRoZSBcImdldFwiIHByb3h5IGhhbmRsZXIgbXVzdCByZXR1cm4gdGhlXG4gICAgICAgIC8vIG9yaWdpbmFsIHZhbHVlIG9mIHRoZSB0YXJnZXQgaWYgdGhhdCB2YWx1ZSBpcyBkZWNsYXJlZCByZWFkLW9ubHkgYW5kXG4gICAgICAgIC8vIG5vbi1jb25maWd1cmFibGUuIEZvciB0aGlzIHJlYXNvbiwgd2UgY3JlYXRlIGFuIG9iamVjdCB3aXRoIHRoZVxuICAgICAgICAvLyBwcm90b3R5cGUgc2V0IHRvIGB0YXJnZXRgIGluc3RlYWQgb2YgdXNpbmcgYHRhcmdldGAgZGlyZWN0bHkuXG4gICAgICAgIC8vIE90aGVyd2lzZSB3ZSBjYW5ub3QgcmV0dXJuIGEgY3VzdG9tIG9iamVjdCBmb3IgQVBJcyB0aGF0XG4gICAgICAgIC8vIGFyZSBkZWNsYXJlZCByZWFkLW9ubHkgYW5kIG5vbi1jb25maWd1cmFibGUsIHN1Y2ggYXMgYGNocm9tZS5kZXZ0b29sc2AuXG4gICAgICAgIC8vXG4gICAgICAgIC8vIFRoZSBwcm94eSBoYW5kbGVycyB0aGVtc2VsdmVzIHdpbGwgc3RpbGwgdXNlIHRoZSBvcmlnaW5hbCBgdGFyZ2V0YFxuICAgICAgICAvLyBpbnN0ZWFkIG9mIHRoZSBgcHJveHlUYXJnZXRgLCBzbyB0aGF0IHRoZSBtZXRob2RzIGFuZCBwcm9wZXJ0aWVzIGFyZVxuICAgICAgICAvLyBkZXJlZmVyZW5jZWQgdmlhIHRoZSBvcmlnaW5hbCB0YXJnZXRzLlxuXG4gICAgICAgIGxldCBwcm94eVRhcmdldCA9IE9iamVjdC5jcmVhdGUodGFyZ2V0KTtcbiAgICAgICAgcmV0dXJuIG5ldyBQcm94eShwcm94eVRhcmdldCwgaGFuZGxlcnMpO1xuICAgICAgfTtcbiAgICAgIC8qKlxuICAgICAgICogQ3JlYXRlcyBhIHNldCBvZiB3cmFwcGVyIGZ1bmN0aW9ucyBmb3IgYW4gZXZlbnQgb2JqZWN0LCB3aGljaCBoYW5kbGVzXG4gICAgICAgKiB3cmFwcGluZyBvZiBsaXN0ZW5lciBmdW5jdGlvbnMgdGhhdCB0aG9zZSBtZXNzYWdlcyBhcmUgcGFzc2VkLlxuICAgICAgICpcbiAgICAgICAqIEEgc2luZ2xlIHdyYXBwZXIgaXMgY3JlYXRlZCBmb3IgZWFjaCBsaXN0ZW5lciBmdW5jdGlvbiwgYW5kIHN0b3JlZCBpbiBhXG4gICAgICAgKiBtYXAuIFN1YnNlcXVlbnQgY2FsbHMgdG8gYGFkZExpc3RlbmVyYCwgYGhhc0xpc3RlbmVyYCwgb3IgYHJlbW92ZUxpc3RlbmVyYFxuICAgICAgICogcmV0cmlldmUgdGhlIG9yaWdpbmFsIHdyYXBwZXIsIHNvIHRoYXQgIGF0dGVtcHRzIHRvIHJlbW92ZSBhXG4gICAgICAgKiBwcmV2aW91c2x5LWFkZGVkIGxpc3RlbmVyIHdvcmsgYXMgZXhwZWN0ZWQuXG4gICAgICAgKlxuICAgICAgICogQHBhcmFtIHtEZWZhdWx0V2Vha01hcDxmdW5jdGlvbiwgZnVuY3Rpb24+fSB3cmFwcGVyTWFwXG4gICAgICAgKiAgICAgICAgQSBEZWZhdWx0V2Vha01hcCBvYmplY3Qgd2hpY2ggd2lsbCBjcmVhdGUgdGhlIGFwcHJvcHJpYXRlIHdyYXBwZXJcbiAgICAgICAqICAgICAgICBmb3IgYSBnaXZlbiBsaXN0ZW5lciBmdW5jdGlvbiB3aGVuIG9uZSBkb2VzIG5vdCBleGlzdCwgYW5kIHJldHJpZXZlXG4gICAgICAgKiAgICAgICAgYW4gZXhpc3Rpbmcgb25lIHdoZW4gaXQgZG9lcy5cbiAgICAgICAqXG4gICAgICAgKiBAcmV0dXJucyB7b2JqZWN0fVxuICAgICAgICovXG5cblxuICAgICAgY29uc3Qgd3JhcEV2ZW50ID0gd3JhcHBlck1hcCA9PiAoe1xuICAgICAgICBhZGRMaXN0ZW5lcih0YXJnZXQsIGxpc3RlbmVyLCAuLi5hcmdzKSB7XG4gICAgICAgICAgdGFyZ2V0LmFkZExpc3RlbmVyKHdyYXBwZXJNYXAuZ2V0KGxpc3RlbmVyKSwgLi4uYXJncyk7XG4gICAgICAgIH0sXG5cbiAgICAgICAgaGFzTGlzdGVuZXIodGFyZ2V0LCBsaXN0ZW5lcikge1xuICAgICAgICAgIHJldHVybiB0YXJnZXQuaGFzTGlzdGVuZXIod3JhcHBlck1hcC5nZXQobGlzdGVuZXIpKTtcbiAgICAgICAgfSxcblxuICAgICAgICByZW1vdmVMaXN0ZW5lcih0YXJnZXQsIGxpc3RlbmVyKSB7XG4gICAgICAgICAgdGFyZ2V0LnJlbW92ZUxpc3RlbmVyKHdyYXBwZXJNYXAuZ2V0KGxpc3RlbmVyKSk7XG4gICAgICAgIH1cblxuICAgICAgfSk7XG5cbiAgICAgIGNvbnN0IG9uUmVxdWVzdEZpbmlzaGVkV3JhcHBlcnMgPSBuZXcgRGVmYXVsdFdlYWtNYXAobGlzdGVuZXIgPT4ge1xuICAgICAgICBpZiAodHlwZW9mIGxpc3RlbmVyICE9PSBcImZ1bmN0aW9uXCIpIHtcbiAgICAgICAgICByZXR1cm4gbGlzdGVuZXI7XG4gICAgICAgIH1cbiAgICAgICAgLyoqXG4gICAgICAgICAqIFdyYXBzIGFuIG9uUmVxdWVzdEZpbmlzaGVkIGxpc3RlbmVyIGZ1bmN0aW9uIHNvIHRoYXQgaXQgd2lsbCByZXR1cm4gYVxuICAgICAgICAgKiBgZ2V0Q29udGVudCgpYCBwcm9wZXJ0eSB3aGljaCByZXR1cm5zIGEgYFByb21pc2VgIHJhdGhlciB0aGFuIHVzaW5nIGFcbiAgICAgICAgICogY2FsbGJhY2sgQVBJLlxuICAgICAgICAgKlxuICAgICAgICAgKiBAcGFyYW0ge29iamVjdH0gcmVxXG4gICAgICAgICAqICAgICAgICBUaGUgSEFSIGVudHJ5IG9iamVjdCByZXByZXNlbnRpbmcgdGhlIG5ldHdvcmsgcmVxdWVzdC5cbiAgICAgICAgICovXG5cblxuICAgICAgICByZXR1cm4gZnVuY3Rpb24gb25SZXF1ZXN0RmluaXNoZWQocmVxKSB7XG4gICAgICAgICAgY29uc3Qgd3JhcHBlZFJlcSA9IHdyYXBPYmplY3QocmVxLCB7fVxuICAgICAgICAgIC8qIHdyYXBwZXJzICovXG4gICAgICAgICAgLCB7XG4gICAgICAgICAgICBnZXRDb250ZW50OiB7XG4gICAgICAgICAgICAgIG1pbkFyZ3M6IDAsXG4gICAgICAgICAgICAgIG1heEFyZ3M6IDBcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9KTtcbiAgICAgICAgICBsaXN0ZW5lcih3cmFwcGVkUmVxKTtcbiAgICAgICAgfTtcbiAgICAgIH0pOyAvLyBLZWVwIHRyYWNrIGlmIHRoZSBkZXByZWNhdGlvbiB3YXJuaW5nIGhhcyBiZWVuIGxvZ2dlZCBhdCBsZWFzdCBvbmNlLlxuXG4gICAgICBsZXQgbG9nZ2VkU2VuZFJlc3BvbnNlRGVwcmVjYXRpb25XYXJuaW5nID0gZmFsc2U7XG4gICAgICBjb25zdCBvbk1lc3NhZ2VXcmFwcGVycyA9IG5ldyBEZWZhdWx0V2Vha01hcChsaXN0ZW5lciA9PiB7XG4gICAgICAgIGlmICh0eXBlb2YgbGlzdGVuZXIgIT09IFwiZnVuY3Rpb25cIikge1xuICAgICAgICAgIHJldHVybiBsaXN0ZW5lcjtcbiAgICAgICAgfVxuICAgICAgICAvKipcbiAgICAgICAgICogV3JhcHMgYSBtZXNzYWdlIGxpc3RlbmVyIGZ1bmN0aW9uIHNvIHRoYXQgaXQgbWF5IHNlbmQgcmVzcG9uc2VzIGJhc2VkIG9uXG4gICAgICAgICAqIGl0cyByZXR1cm4gdmFsdWUsIHJhdGhlciB0aGFuIGJ5IHJldHVybmluZyBhIHNlbnRpbmVsIHZhbHVlIGFuZCBjYWxsaW5nIGFcbiAgICAgICAgICogY2FsbGJhY2suIElmIHRoZSBsaXN0ZW5lciBmdW5jdGlvbiByZXR1cm5zIGEgUHJvbWlzZSwgdGhlIHJlc3BvbnNlIGlzXG4gICAgICAgICAqIHNlbnQgd2hlbiB0aGUgcHJvbWlzZSBlaXRoZXIgcmVzb2x2ZXMgb3IgcmVqZWN0cy5cbiAgICAgICAgICpcbiAgICAgICAgICogQHBhcmFtIHsqfSBtZXNzYWdlXG4gICAgICAgICAqICAgICAgICBUaGUgbWVzc2FnZSBzZW50IGJ5IHRoZSBvdGhlciBlbmQgb2YgdGhlIGNoYW5uZWwuXG4gICAgICAgICAqIEBwYXJhbSB7b2JqZWN0fSBzZW5kZXJcbiAgICAgICAgICogICAgICAgIERldGFpbHMgYWJvdXQgdGhlIHNlbmRlciBvZiB0aGUgbWVzc2FnZS5cbiAgICAgICAgICogQHBhcmFtIHtmdW5jdGlvbigqKX0gc2VuZFJlc3BvbnNlXG4gICAgICAgICAqICAgICAgICBBIGNhbGxiYWNrIHdoaWNoLCB3aGVuIGNhbGxlZCB3aXRoIGFuIGFyYml0cmFyeSBhcmd1bWVudCwgc2VuZHNcbiAgICAgICAgICogICAgICAgIHRoYXQgdmFsdWUgYXMgYSByZXNwb25zZS5cbiAgICAgICAgICogQHJldHVybnMge2Jvb2xlYW59XG4gICAgICAgICAqICAgICAgICBUcnVlIGlmIHRoZSB3cmFwcGVkIGxpc3RlbmVyIHJldHVybmVkIGEgUHJvbWlzZSwgd2hpY2ggd2lsbCBsYXRlclxuICAgICAgICAgKiAgICAgICAgeWllbGQgYSByZXNwb25zZS4gRmFsc2Ugb3RoZXJ3aXNlLlxuICAgICAgICAgKi9cblxuXG4gICAgICAgIHJldHVybiBmdW5jdGlvbiBvbk1lc3NhZ2UobWVzc2FnZSwgc2VuZGVyLCBzZW5kUmVzcG9uc2UpIHtcbiAgICAgICAgICBsZXQgZGlkQ2FsbFNlbmRSZXNwb25zZSA9IGZhbHNlO1xuICAgICAgICAgIGxldCB3cmFwcGVkU2VuZFJlc3BvbnNlO1xuICAgICAgICAgIGxldCBzZW5kUmVzcG9uc2VQcm9taXNlID0gbmV3IFByb21pc2UocmVzb2x2ZSA9PiB7XG4gICAgICAgICAgICB3cmFwcGVkU2VuZFJlc3BvbnNlID0gZnVuY3Rpb24gKHJlc3BvbnNlKSB7XG4gICAgICAgICAgICAgIGlmICghbG9nZ2VkU2VuZFJlc3BvbnNlRGVwcmVjYXRpb25XYXJuaW5nKSB7XG4gICAgICAgICAgICAgICAgY29uc29sZS53YXJuKFNFTkRfUkVTUE9OU0VfREVQUkVDQVRJT05fV0FSTklORywgbmV3IEVycm9yKCkuc3RhY2spO1xuICAgICAgICAgICAgICAgIGxvZ2dlZFNlbmRSZXNwb25zZURlcHJlY2F0aW9uV2FybmluZyA9IHRydWU7XG4gICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICBkaWRDYWxsU2VuZFJlc3BvbnNlID0gdHJ1ZTtcbiAgICAgICAgICAgICAgcmVzb2x2ZShyZXNwb25zZSk7XG4gICAgICAgICAgICB9O1xuICAgICAgICAgIH0pO1xuICAgICAgICAgIGxldCByZXN1bHQ7XG5cbiAgICAgICAgICB0cnkge1xuICAgICAgICAgICAgcmVzdWx0ID0gbGlzdGVuZXIobWVzc2FnZSwgc2VuZGVyLCB3cmFwcGVkU2VuZFJlc3BvbnNlKTtcbiAgICAgICAgICB9IGNhdGNoIChlcnIpIHtcbiAgICAgICAgICAgIHJlc3VsdCA9IFByb21pc2UucmVqZWN0KGVycik7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgY29uc3QgaXNSZXN1bHRUaGVuYWJsZSA9IHJlc3VsdCAhPT0gdHJ1ZSAmJiBpc1RoZW5hYmxlKHJlc3VsdCk7IC8vIElmIHRoZSBsaXN0ZW5lciBkaWRuJ3QgcmV0dXJuZWQgdHJ1ZSBvciBhIFByb21pc2UsIG9yIGNhbGxlZFxuICAgICAgICAgIC8vIHdyYXBwZWRTZW5kUmVzcG9uc2Ugc3luY2hyb25vdXNseSwgd2UgY2FuIGV4aXQgZWFybGllclxuICAgICAgICAgIC8vIGJlY2F1c2UgdGhlcmUgd2lsbCBiZSBubyByZXNwb25zZSBzZW50IGZyb20gdGhpcyBsaXN0ZW5lci5cblxuICAgICAgICAgIGlmIChyZXN1bHQgIT09IHRydWUgJiYgIWlzUmVzdWx0VGhlbmFibGUgJiYgIWRpZENhbGxTZW5kUmVzcG9uc2UpIHtcbiAgICAgICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgICAgICB9IC8vIEEgc21hbGwgaGVscGVyIHRvIHNlbmQgdGhlIG1lc3NhZ2UgaWYgdGhlIHByb21pc2UgcmVzb2x2ZXNcbiAgICAgICAgICAvLyBhbmQgYW4gZXJyb3IgaWYgdGhlIHByb21pc2UgcmVqZWN0cyAoYSB3cmFwcGVkIHNlbmRNZXNzYWdlIGhhc1xuICAgICAgICAgIC8vIHRvIHRyYW5zbGF0ZSB0aGUgbWVzc2FnZSBpbnRvIGEgcmVzb2x2ZWQgcHJvbWlzZSBvciBhIHJlamVjdGVkXG4gICAgICAgICAgLy8gcHJvbWlzZSkuXG5cblxuICAgICAgICAgIGNvbnN0IHNlbmRQcm9taXNlZFJlc3VsdCA9IHByb21pc2UgPT4ge1xuICAgICAgICAgICAgcHJvbWlzZS50aGVuKG1zZyA9PiB7XG4gICAgICAgICAgICAgIC8vIHNlbmQgdGhlIG1lc3NhZ2UgdmFsdWUuXG4gICAgICAgICAgICAgIHNlbmRSZXNwb25zZShtc2cpO1xuICAgICAgICAgICAgfSwgZXJyb3IgPT4ge1xuICAgICAgICAgICAgICAvLyBTZW5kIGEgSlNPTiByZXByZXNlbnRhdGlvbiBvZiB0aGUgZXJyb3IgaWYgdGhlIHJlamVjdGVkIHZhbHVlXG4gICAgICAgICAgICAgIC8vIGlzIGFuIGluc3RhbmNlIG9mIGVycm9yLCBvciB0aGUgb2JqZWN0IGl0c2VsZiBvdGhlcndpc2UuXG4gICAgICAgICAgICAgIGxldCBtZXNzYWdlO1xuXG4gICAgICAgICAgICAgIGlmIChlcnJvciAmJiAoZXJyb3IgaW5zdGFuY2VvZiBFcnJvciB8fCB0eXBlb2YgZXJyb3IubWVzc2FnZSA9PT0gXCJzdHJpbmdcIikpIHtcbiAgICAgICAgICAgICAgICBtZXNzYWdlID0gZXJyb3IubWVzc2FnZTtcbiAgICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgICBtZXNzYWdlID0gXCJBbiB1bmV4cGVjdGVkIGVycm9yIG9jY3VycmVkXCI7XG4gICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICBzZW5kUmVzcG9uc2Uoe1xuICAgICAgICAgICAgICAgIF9fbW96V2ViRXh0ZW5zaW9uUG9seWZpbGxSZWplY3RfXzogdHJ1ZSxcbiAgICAgICAgICAgICAgICBtZXNzYWdlXG4gICAgICAgICAgICAgIH0pO1xuICAgICAgICAgICAgfSkuY2F0Y2goZXJyID0+IHtcbiAgICAgICAgICAgICAgLy8gUHJpbnQgYW4gZXJyb3Igb24gdGhlIGNvbnNvbGUgaWYgdW5hYmxlIHRvIHNlbmQgdGhlIHJlc3BvbnNlLlxuICAgICAgICAgICAgICBjb25zb2xlLmVycm9yKFwiRmFpbGVkIHRvIHNlbmQgb25NZXNzYWdlIHJlamVjdGVkIHJlcGx5XCIsIGVycik7XG4gICAgICAgICAgICB9KTtcbiAgICAgICAgICB9OyAvLyBJZiB0aGUgbGlzdGVuZXIgcmV0dXJuZWQgYSBQcm9taXNlLCBzZW5kIHRoZSByZXNvbHZlZCB2YWx1ZSBhcyBhXG4gICAgICAgICAgLy8gcmVzdWx0LCBvdGhlcndpc2Ugd2FpdCB0aGUgcHJvbWlzZSByZWxhdGVkIHRvIHRoZSB3cmFwcGVkU2VuZFJlc3BvbnNlXG4gICAgICAgICAgLy8gY2FsbGJhY2sgdG8gcmVzb2x2ZSBhbmQgc2VuZCBpdCBhcyBhIHJlc3BvbnNlLlxuXG5cbiAgICAgICAgICBpZiAoaXNSZXN1bHRUaGVuYWJsZSkge1xuICAgICAgICAgICAgc2VuZFByb21pc2VkUmVzdWx0KHJlc3VsdCk7XG4gICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIHNlbmRQcm9taXNlZFJlc3VsdChzZW5kUmVzcG9uc2VQcm9taXNlKTtcbiAgICAgICAgICB9IC8vIExldCBDaHJvbWUga25vdyB0aGF0IHRoZSBsaXN0ZW5lciBpcyByZXBseWluZy5cblxuXG4gICAgICAgICAgcmV0dXJuIHRydWU7XG4gICAgICAgIH07XG4gICAgICB9KTtcblxuICAgICAgY29uc3Qgd3JhcHBlZFNlbmRNZXNzYWdlQ2FsbGJhY2sgPSAoe1xuICAgICAgICByZWplY3QsXG4gICAgICAgIHJlc29sdmVcbiAgICAgIH0sIHJlcGx5KSA9PiB7XG4gICAgICAgIGlmIChleHRlbnNpb25BUElzLnJ1bnRpbWUubGFzdEVycm9yKSB7XG4gICAgICAgICAgLy8gRGV0ZWN0IHdoZW4gbm9uZSBvZiB0aGUgbGlzdGVuZXJzIHJlcGxpZWQgdG8gdGhlIHNlbmRNZXNzYWdlIGNhbGwgYW5kIHJlc29sdmVcbiAgICAgICAgICAvLyB0aGUgcHJvbWlzZSB0byB1bmRlZmluZWQgYXMgaW4gRmlyZWZveC5cbiAgICAgICAgICAvLyBTZWUgaHR0cHM6Ly9naXRodWIuY29tL21vemlsbGEvd2ViZXh0ZW5zaW9uLXBvbHlmaWxsL2lzc3Vlcy8xMzBcbiAgICAgICAgICBpZiAoZXh0ZW5zaW9uQVBJcy5ydW50aW1lLmxhc3RFcnJvci5tZXNzYWdlID09PSBDSFJPTUVfU0VORF9NRVNTQUdFX0NBTExCQUNLX05PX1JFU1BPTlNFX01FU1NBR0UpIHtcbiAgICAgICAgICAgIHJlc29sdmUoKTtcbiAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgcmVqZWN0KG5ldyBFcnJvcihleHRlbnNpb25BUElzLnJ1bnRpbWUubGFzdEVycm9yLm1lc3NhZ2UpKTtcbiAgICAgICAgICB9XG4gICAgICAgIH0gZWxzZSBpZiAocmVwbHkgJiYgcmVwbHkuX19tb3pXZWJFeHRlbnNpb25Qb2x5ZmlsbFJlamVjdF9fKSB7XG4gICAgICAgICAgLy8gQ29udmVydCBiYWNrIHRoZSBKU09OIHJlcHJlc2VudGF0aW9uIG9mIHRoZSBlcnJvciBpbnRvXG4gICAgICAgICAgLy8gYW4gRXJyb3IgaW5zdGFuY2UuXG4gICAgICAgICAgcmVqZWN0KG5ldyBFcnJvcihyZXBseS5tZXNzYWdlKSk7XG4gICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgcmVzb2x2ZShyZXBseSk7XG4gICAgICAgIH1cbiAgICAgIH07XG5cbiAgICAgIGNvbnN0IHdyYXBwZWRTZW5kTWVzc2FnZSA9IChuYW1lLCBtZXRhZGF0YSwgYXBpTmFtZXNwYWNlT2JqLCAuLi5hcmdzKSA9PiB7XG4gICAgICAgIGlmIChhcmdzLmxlbmd0aCA8IG1ldGFkYXRhLm1pbkFyZ3MpIHtcbiAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoYEV4cGVjdGVkIGF0IGxlYXN0ICR7bWV0YWRhdGEubWluQXJnc30gJHtwbHVyYWxpemVBcmd1bWVudHMobWV0YWRhdGEubWluQXJncyl9IGZvciAke25hbWV9KCksIGdvdCAke2FyZ3MubGVuZ3RofWApO1xuICAgICAgICB9XG5cbiAgICAgICAgaWYgKGFyZ3MubGVuZ3RoID4gbWV0YWRhdGEubWF4QXJncykge1xuICAgICAgICAgIHRocm93IG5ldyBFcnJvcihgRXhwZWN0ZWQgYXQgbW9zdCAke21ldGFkYXRhLm1heEFyZ3N9ICR7cGx1cmFsaXplQXJndW1lbnRzKG1ldGFkYXRhLm1heEFyZ3MpfSBmb3IgJHtuYW1lfSgpLCBnb3QgJHthcmdzLmxlbmd0aH1gKTtcbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiBuZXcgUHJvbWlzZSgocmVzb2x2ZSwgcmVqZWN0KSA9PiB7XG4gICAgICAgICAgY29uc3Qgd3JhcHBlZENiID0gd3JhcHBlZFNlbmRNZXNzYWdlQ2FsbGJhY2suYmluZChudWxsLCB7XG4gICAgICAgICAgICByZXNvbHZlLFxuICAgICAgICAgICAgcmVqZWN0XG4gICAgICAgICAgfSk7XG4gICAgICAgICAgYXJncy5wdXNoKHdyYXBwZWRDYik7XG4gICAgICAgICAgYXBpTmFtZXNwYWNlT2JqLnNlbmRNZXNzYWdlKC4uLmFyZ3MpO1xuICAgICAgICB9KTtcbiAgICAgIH07XG5cbiAgICAgIGNvbnN0IHN0YXRpY1dyYXBwZXJzID0ge1xuICAgICAgICBkZXZ0b29sczoge1xuICAgICAgICAgIG5ldHdvcms6IHtcbiAgICAgICAgICAgIG9uUmVxdWVzdEZpbmlzaGVkOiB3cmFwRXZlbnQob25SZXF1ZXN0RmluaXNoZWRXcmFwcGVycylcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIHJ1bnRpbWU6IHtcbiAgICAgICAgICBvbk1lc3NhZ2U6IHdyYXBFdmVudChvbk1lc3NhZ2VXcmFwcGVycyksXG4gICAgICAgICAgb25NZXNzYWdlRXh0ZXJuYWw6IHdyYXBFdmVudChvbk1lc3NhZ2VXcmFwcGVycyksXG4gICAgICAgICAgc2VuZE1lc3NhZ2U6IHdyYXBwZWRTZW5kTWVzc2FnZS5iaW5kKG51bGwsIFwic2VuZE1lc3NhZ2VcIiwge1xuICAgICAgICAgICAgbWluQXJnczogMSxcbiAgICAgICAgICAgIG1heEFyZ3M6IDNcbiAgICAgICAgICB9KVxuICAgICAgICB9LFxuICAgICAgICB0YWJzOiB7XG4gICAgICAgICAgc2VuZE1lc3NhZ2U6IHdyYXBwZWRTZW5kTWVzc2FnZS5iaW5kKG51bGwsIFwic2VuZE1lc3NhZ2VcIiwge1xuICAgICAgICAgICAgbWluQXJnczogMixcbiAgICAgICAgICAgIG1heEFyZ3M6IDNcbiAgICAgICAgICB9KVxuICAgICAgICB9XG4gICAgICB9O1xuICAgICAgY29uc3Qgc2V0dGluZ01ldGFkYXRhID0ge1xuICAgICAgICBjbGVhcjoge1xuICAgICAgICAgIG1pbkFyZ3M6IDEsXG4gICAgICAgICAgbWF4QXJnczogMVxuICAgICAgICB9LFxuICAgICAgICBnZXQ6IHtcbiAgICAgICAgICBtaW5BcmdzOiAxLFxuICAgICAgICAgIG1heEFyZ3M6IDFcbiAgICAgICAgfSxcbiAgICAgICAgc2V0OiB7XG4gICAgICAgICAgbWluQXJnczogMSxcbiAgICAgICAgICBtYXhBcmdzOiAxXG4gICAgICAgIH1cbiAgICAgIH07XG4gICAgICBhcGlNZXRhZGF0YS5wcml2YWN5ID0ge1xuICAgICAgICBuZXR3b3JrOiB7XG4gICAgICAgICAgXCIqXCI6IHNldHRpbmdNZXRhZGF0YVxuICAgICAgICB9LFxuICAgICAgICBzZXJ2aWNlczoge1xuICAgICAgICAgIFwiKlwiOiBzZXR0aW5nTWV0YWRhdGFcbiAgICAgICAgfSxcbiAgICAgICAgd2Vic2l0ZXM6IHtcbiAgICAgICAgICBcIipcIjogc2V0dGluZ01ldGFkYXRhXG4gICAgICAgIH1cbiAgICAgIH07XG4gICAgICByZXR1cm4gd3JhcE9iamVjdChleHRlbnNpb25BUElzLCBzdGF0aWNXcmFwcGVycywgYXBpTWV0YWRhdGEpO1xuICAgIH07XG5cbiAgICBpZiAodHlwZW9mIGNocm9tZSAhPSBcIm9iamVjdFwiIHx8ICFjaHJvbWUgfHwgIWNocm9tZS5ydW50aW1lIHx8ICFjaHJvbWUucnVudGltZS5pZCkge1xuICAgICAgdGhyb3cgbmV3IEVycm9yKFwiVGhpcyBzY3JpcHQgc2hvdWxkIG9ubHkgYmUgbG9hZGVkIGluIGEgYnJvd3NlciBleHRlbnNpb24uXCIpO1xuICAgIH0gLy8gVGhlIGJ1aWxkIHByb2Nlc3MgYWRkcyBhIFVNRCB3cmFwcGVyIGFyb3VuZCB0aGlzIGZpbGUsIHdoaWNoIG1ha2VzIHRoZVxuICAgIC8vIGBtb2R1bGVgIHZhcmlhYmxlIGF2YWlsYWJsZS5cblxuXG4gICAgbW9kdWxlLmV4cG9ydHMgPSB3cmFwQVBJcyhjaHJvbWUpO1xuICB9IGVsc2Uge1xuICAgIG1vZHVsZS5leHBvcnRzID0gYnJvd3NlcjtcbiAgfVxufSk7XG4vLyMgc291cmNlTWFwcGluZ1VSTD1icm93c2VyLXBvbHlmaWxsLmpzLm1hcFxuIiwiLy8gVGhlIG1vZHVsZSBjYWNoZVxudmFyIF9fd2VicGFja19tb2R1bGVfY2FjaGVfXyA9IHt9O1xuXG4vLyBUaGUgcmVxdWlyZSBmdW5jdGlvblxuZnVuY3Rpb24gX193ZWJwYWNrX3JlcXVpcmVfXyhtb2R1bGVJZCkge1xuXHQvLyBDaGVjayBpZiBtb2R1bGUgaXMgaW4gY2FjaGVcblx0dmFyIGNhY2hlZE1vZHVsZSA9IF9fd2VicGFja19tb2R1bGVfY2FjaGVfX1ttb2R1bGVJZF07XG5cdGlmIChjYWNoZWRNb2R1bGUgIT09IHVuZGVmaW5lZCkge1xuXHRcdHJldHVybiBjYWNoZWRNb2R1bGUuZXhwb3J0cztcblx0fVxuXHQvLyBDcmVhdGUgYSBuZXcgbW9kdWxlIChhbmQgcHV0IGl0IGludG8gdGhlIGNhY2hlKVxuXHR2YXIgbW9kdWxlID0gX193ZWJwYWNrX21vZHVsZV9jYWNoZV9fW21vZHVsZUlkXSA9IHtcblx0XHQvLyBubyBtb2R1bGUuaWQgbmVlZGVkXG5cdFx0Ly8gbm8gbW9kdWxlLmxvYWRlZCBuZWVkZWRcblx0XHRleHBvcnRzOiB7fVxuXHR9O1xuXG5cdC8vIEV4ZWN1dGUgdGhlIG1vZHVsZSBmdW5jdGlvblxuXHRfX3dlYnBhY2tfbW9kdWxlc19fW21vZHVsZUlkXS5jYWxsKG1vZHVsZS5leHBvcnRzLCBtb2R1bGUsIG1vZHVsZS5leHBvcnRzLCBfX3dlYnBhY2tfcmVxdWlyZV9fKTtcblxuXHQvLyBSZXR1cm4gdGhlIGV4cG9ydHMgb2YgdGhlIG1vZHVsZVxuXHRyZXR1cm4gbW9kdWxlLmV4cG9ydHM7XG59XG5cbiIsIi8vIGdldERlZmF1bHRFeHBvcnQgZnVuY3Rpb24gZm9yIGNvbXBhdGliaWxpdHkgd2l0aCBub24taGFybW9ueSBtb2R1bGVzXG5fX3dlYnBhY2tfcmVxdWlyZV9fLm4gPSAobW9kdWxlKSA9PiB7XG5cdHZhciBnZXR0ZXIgPSBtb2R1bGUgJiYgbW9kdWxlLl9fZXNNb2R1bGUgP1xuXHRcdCgpID0+IChtb2R1bGVbJ2RlZmF1bHQnXSkgOlxuXHRcdCgpID0+IChtb2R1bGUpO1xuXHRfX3dlYnBhY2tfcmVxdWlyZV9fLmQoZ2V0dGVyLCB7IGE6IGdldHRlciB9KTtcblx0cmV0dXJuIGdldHRlcjtcbn07IiwiLy8gZGVmaW5lIGdldHRlciBmdW5jdGlvbnMgZm9yIGhhcm1vbnkgZXhwb3J0c1xuX193ZWJwYWNrX3JlcXVpcmVfXy5kID0gKGV4cG9ydHMsIGRlZmluaXRpb24pID0+IHtcblx0Zm9yKHZhciBrZXkgaW4gZGVmaW5pdGlvbikge1xuXHRcdGlmKF9fd2VicGFja19yZXF1aXJlX18ubyhkZWZpbml0aW9uLCBrZXkpICYmICFfX3dlYnBhY2tfcmVxdWlyZV9fLm8oZXhwb3J0cywga2V5KSkge1xuXHRcdFx0T2JqZWN0LmRlZmluZVByb3BlcnR5KGV4cG9ydHMsIGtleSwgeyBlbnVtZXJhYmxlOiB0cnVlLCBnZXQ6IGRlZmluaXRpb25ba2V5XSB9KTtcblx0XHR9XG5cdH1cbn07IiwiX193ZWJwYWNrX3JlcXVpcmVfXy5vID0gKG9iaiwgcHJvcCkgPT4gKE9iamVjdC5wcm90b3R5cGUuaGFzT3duUHJvcGVydHkuY2FsbChvYmosIHByb3ApKSIsIi8vIGRlZmluZSBfX2VzTW9kdWxlIG9uIGV4cG9ydHNcbl9fd2VicGFja19yZXF1aXJlX18uciA9IChleHBvcnRzKSA9PiB7XG5cdGlmKHR5cGVvZiBTeW1ib2wgIT09ICd1bmRlZmluZWQnICYmIFN5bWJvbC50b1N0cmluZ1RhZykge1xuXHRcdE9iamVjdC5kZWZpbmVQcm9wZXJ0eShleHBvcnRzLCBTeW1ib2wudG9TdHJpbmdUYWcsIHsgdmFsdWU6ICdNb2R1bGUnIH0pO1xuXHR9XG5cdE9iamVjdC5kZWZpbmVQcm9wZXJ0eShleHBvcnRzLCAnX19lc01vZHVsZScsIHsgdmFsdWU6IHRydWUgfSk7XG59OyIsImltcG9ydCB7IGNvbnRlbnQgfSBmcm9tICcuLi8uLi9wYWdlcy9jb250ZW50JztcblxuY29udGVudC5pbml0KCk7XG4iXSwic291cmNlUm9vdCI6IiJ9