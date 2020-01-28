/**
 * AdGuard -> Safari Content Blocker converter
 * Version 4.2.4
 * License: https://github.com/AdguardTeam/SafariContentBlockerConverterCompiler/blob/master/LICENSE
 */

/**
* The main conversion function that is called from the iOS app
* 
* @param {} rules Rules to convert
* @param {*} limit Max number of rules
* @param {*} optimize True if we should apply additional optimization
* @param {*} advancedBlocking True if we need advanced blocking json
*/
var jsonFromFilters = (function () {

    /**
     * Define window dummy object
     */
    if (typeof window === 'undefined') {
        var window = Object.create(null);
    }

/**
 * Start of the dependencies content 
 */
/** start of adguard.js */
/**
 * Global adguard object
 */
const adguard = (function () { // jshint ignore:line
    return {
        rules: {}
    };
})();
/** end of adguard.js */
/** start of punycode.js */
/*! http://mths.be/punycode v1.3.0 by @mathias */
;(function(root) {

	/**
	 * The `punycode` object.
	 * @name punycode
	 * @type Object
	 */
	var punycode,

		/** Highest positive signed 32-bit float value */
		maxInt = 2147483647, // aka. 0x7FFFFFFF or 2^31-1

		/** Bootstring parameters */
		base = 36,
		tMin = 1,
		tMax = 26,
		skew = 38,
		damp = 700,
		initialBias = 72,
		initialN = 128, // 0x80
		delimiter = '-', // '\x2D'

		/** Regular expressions */
		regexPunycode = /^xn--/,
		regexNonASCII = /[^\x20-\x7E]/, // unprintable ASCII chars + non-ASCII chars
		regexSeparators = /[\x2E\u3002\uFF0E\uFF61]/g, // RFC 3490 separators

		/** Error messages */
		errors = {
			'overflow': 'Overflow: input needs wider integers to process',
			'not-basic': 'Illegal input >= 0x80 (not a basic code point)',
			'invalid-input': 'Invalid input'
		},

		/** Convenience shortcuts */
		baseMinusTMin = base - tMin,
		floor = Math.floor,
		stringFromCharCode = String.fromCharCode,

		/** Temporary variable */
		key;

	/*--------------------------------------------------------------------------*/

	/**
	 * A generic error utility function.
	 * @private
	 * @param {String} type The error type.
	 * @returns {Error} Throws a `RangeError` with the applicable error message.
	 */
	function error(type) {
		throw RangeError(errors[type]);
	}

	/**
	 * A generic `Array#map` utility function.
	 * @private
	 * @param {Array} array The array to iterate over.
	 * @param {Function} callback The function that gets called for every array
	 * item.
	 * @returns {Array} A new array of values returned by the callback function.
	 */
	function map(array, fn) {
		var length = array.length;
		var result = [];
		while (length--) {
			result[length] = fn(array[length]);
		}
		return result;
	}

	/**
	 * A simple `Array#map`-like wrapper to work with domain name strings or email
	 * addresses.
	 * @private
	 * @param {String} domain The domain name or email address.
	 * @param {Function} callback The function that gets called for every
	 * character.
	 * @returns {Array} A new string of characters returned by the callback
	 * function.
	 */
	function mapDomain(string, fn) {
		var labels = string.split(regexSeparators);
		// Note: each label could still contain `@` in the case of an email address.
		return map(labels, function(label) {
			var parts = label.split('@');
			return map(parts, fn).join('@');
		}).join('.');
	}

	/**
	 * Creates an array containing the numeric code points of each Unicode
	 * character in the string. While JavaScript uses UCS-2 internally,
	 * this function will convert a pair of surrogate halves (each of which
	 * UCS-2 exposes as separate characters) into a single code point,
	 * matching UTF-16.
	 * @see `punycode.ucs2.encode`
	 * @see <http://mathiasbynens.be/notes/javascript-encoding>
	 * @memberOf punycode.ucs2
	 * @name decode
	 * @param {String} string The Unicode input string (UCS-2).
	 * @returns {Array} The new array of code points.
	 */
	function ucs2decode(string) {
		var output = [],
			counter = 0,
			length = string.length,
			value,
			extra;
		while (counter < length) {
			value = string.charCodeAt(counter++);
			if (value >= 0xD800 && value <= 0xDBFF && counter < length) {
				// high surrogate, and there is a next character
				extra = string.charCodeAt(counter++);
				if ((extra & 0xFC00) == 0xDC00) { // low surrogate
					output.push(((value & 0x3FF) << 10) + (extra & 0x3FF) + 0x10000);
				} else {
					// unmatched surrogate; only append this code unit, in case the next
					// code unit is the high surrogate of a surrogate pair
					output.push(value);
					counter--;
				}
			} else {
				output.push(value);
			}
		}
		return output;
	}

	/**
	 * Creates a string based on an array of numeric code points.
	 * @see `punycode.ucs2.decode`
	 * @memberOf punycode.ucs2
	 * @name encode
	 * @param {Array} codePoints The array of numeric code points.
	 * @returns {String} The new Unicode string (UCS-2).
	 */
	function ucs2encode(array) {
		return map(array, function(value) {
			var output = '';
			if (value > 0xFFFF) {
				value -= 0x10000;
				output += stringFromCharCode(value >>> 10 & 0x3FF | 0xD800);
				value = 0xDC00 | value & 0x3FF;
			}
			output += stringFromCharCode(value);
			return output;
		}).join('');
	}

	/**
	 * Converts a basic code point into a digit/integer.
	 * @see `digitToBasic()`
	 * @private
	 * @param {Number} codePoint The basic numeric code point value.
	 * @returns {Number} The numeric value of a basic code point (for use in
	 * representing integers) in the range `0` to `base - 1`, or `base` if
	 * the code point does not represent a value.
	 */
	function basicToDigit(codePoint) {
		if (codePoint - 48 < 10) {
			return codePoint - 22;
		}
		if (codePoint - 65 < 26) {
			return codePoint - 65;
		}
		if (codePoint - 97 < 26) {
			return codePoint - 97;
		}
		return base;
	}

	/**
	 * Converts a digit/integer into a basic code point.
	 * @see `basicToDigit()`
	 * @private
	 * @param {Number} digit The numeric value of a basic code point.
	 * @returns {Number} The basic code point whose value (when used for
	 * representing integers) is `digit`, which needs to be in the range
	 * `0` to `base - 1`. If `flag` is non-zero, the uppercase form is
	 * used; else, the lowercase form is used. The behavior is undefined
	 * if `flag` is non-zero and `digit` has no uppercase form.
	 */
	function digitToBasic(digit, flag) {
		//  0..25 map to ASCII a..z or A..Z
		// 26..35 map to ASCII 0..9
		return digit + 22 + 75 * (digit < 26) - ((flag != 0) << 5);
	}

	/**
	 * Bias adaptation function as per section 3.4 of RFC 3492.
	 * http://tools.ietf.org/html/rfc3492#section-3.4
	 * @private
	 */
	function adapt(delta, numPoints, firstTime) {
		var k = 0;
		delta = firstTime ? floor(delta / damp) : delta >> 1;
		delta += floor(delta / numPoints);
		for (/* no initialization */; delta > baseMinusTMin * tMax >> 1; k += base) {
			delta = floor(delta / baseMinusTMin);
		}
		return floor(k + (baseMinusTMin + 1) * delta / (delta + skew));
	}

	/**
	 * Converts a Punycode string of ASCII-only symbols to a string of Unicode
	 * symbols.
	 * @memberOf punycode
	 * @param {String} input The Punycode string of ASCII-only symbols.
	 * @returns {String} The resulting string of Unicode symbols.
	 */
	function decode(input) {
		// Don't use UCS-2
		var output = [],
			inputLength = input.length,
			out,
			i = 0,
			n = initialN,
			bias = initialBias,
			basic,
			j,
			index,
			oldi,
			w,
			k,
			digit,
			t,
			/** Cached calculation results */
			baseMinusT;

		// Handle the basic code points: let `basic` be the number of input code
		// points before the last delimiter, or `0` if there is none, then copy
		// the first basic code points to the output.

		basic = input.lastIndexOf(delimiter);
		if (basic < 0) {
			basic = 0;
		}

		for (j = 0; j < basic; ++j) {
			// if it's not a basic code point
			if (input.charCodeAt(j) >= 0x80) {
				error('not-basic');
			}
			output.push(input.charCodeAt(j));
		}

		// Main decoding loop: start just after the last delimiter if any basic code
		// points were copied; start at the beginning otherwise.

		for (index = basic > 0 ? basic + 1 : 0; index < inputLength; /* no final expression */) {

			// `index` is the index of the next character to be consumed.
			// Decode a generalized variable-length integer into `delta`,
			// which gets added to `i`. The overflow checking is easier
			// if we increase `i` as we go, then subtract off its starting
			// value at the end to obtain `delta`.
			for (oldi = i, w = 1, k = base; /* no condition */; k += base) {

				if (index >= inputLength) {
					error('invalid-input');
				}

				digit = basicToDigit(input.charCodeAt(index++));

				if (digit >= base || digit > floor((maxInt - i) / w)) {
					error('overflow');
				}

				i += digit * w;
				t = k <= bias ? tMin : (k >= bias + tMax ? tMax : k - bias);

				if (digit < t) {
					break;
				}

				baseMinusT = base - t;
				if (w > floor(maxInt / baseMinusT)) {
					error('overflow');
				}

				w *= baseMinusT;

			}

			out = output.length + 1;
			bias = adapt(i - oldi, out, oldi == 0);

			// `i` was supposed to wrap around from `out` to `0`,
			// incrementing `n` each time, so we'll fix that now:
			if (floor(i / out) > maxInt - n) {
				error('overflow');
			}

			n += floor(i / out);
			i %= out;

			// Insert `n` at position `i` of the output
			output.splice(i++, 0, n);

		}

		return ucs2encode(output);
	}

	/**
	 * Converts a string of Unicode symbols (e.g. a domain name label) to a
	 * Punycode string of ASCII-only symbols.
	 * @memberOf punycode
	 * @param {String} input The string of Unicode symbols.
	 * @returns {String} The resulting Punycode string of ASCII-only symbols.
	 */
	function encode(input) {
		var n,
			delta,
			handledCPCount,
			basicLength,
			bias,
			j,
			m,
			q,
			k,
			t,
			currentValue,
			output = [],
			/** `inputLength` will hold the number of code points in `input`. */
			inputLength,
			/** Cached calculation results */
			handledCPCountPlusOne,
			baseMinusT,
			qMinusT;

		// Convert the input in UCS-2 to Unicode
		input = ucs2decode(input);

		// Cache the length
		inputLength = input.length;

		// Initialize the state
		n = initialN;
		delta = 0;
		bias = initialBias;

		// Handle the basic code points
		for (j = 0; j < inputLength; ++j) {
			currentValue = input[j];
			if (currentValue < 0x80) {
				output.push(stringFromCharCode(currentValue));
			}
		}

		handledCPCount = basicLength = output.length;

		// `handledCPCount` is the number of code points that have been handled;
		// `basicLength` is the number of basic code points.

		// Finish the basic string - if it is not empty - with a delimiter
		if (basicLength) {
			output.push(delimiter);
		}

		// Main encoding loop:
		while (handledCPCount < inputLength) {

			// All non-basic code points < n have been handled already. Find the next
			// larger one:
			for (m = maxInt, j = 0; j < inputLength; ++j) {
				currentValue = input[j];
				if (currentValue >= n && currentValue < m) {
					m = currentValue;
				}
			}

			// Increase `delta` enough to advance the decoder's <n,i> state to <m,0>,
			// but guard against overflow
			handledCPCountPlusOne = handledCPCount + 1;
			if (m - n > floor((maxInt - delta) / handledCPCountPlusOne)) {
				error('overflow');
			}

			delta += (m - n) * handledCPCountPlusOne;
			n = m;

			for (j = 0; j < inputLength; ++j) {
				currentValue = input[j];

				if (currentValue < n && ++delta > maxInt) {
					error('overflow');
				}

				if (currentValue == n) {
					// Represent delta as a generalized variable-length integer
					for (q = delta, k = base; /* no condition */; k += base) {
						t = k <= bias ? tMin : (k >= bias + tMax ? tMax : k - bias);
						if (q < t) {
							break;
						}
						qMinusT = q - t;
						baseMinusT = base - t;
						output.push(
							stringFromCharCode(digitToBasic(t + qMinusT % baseMinusT, 0))
						);
						q = floor(qMinusT / baseMinusT);
					}

					output.push(stringFromCharCode(digitToBasic(q, 0)));
					bias = adapt(delta, handledCPCountPlusOne, handledCPCount == basicLength);
					delta = 0;
					++handledCPCount;
				}
			}

			++delta;
			++n;

		}
		return output.join('');
	}

	/**
	 * Converts a Punycode string representing a domain name or an email address
	 * to Unicode. Only the Punycoded parts of the input will be converted, i.e.
	 * it doesn't matter if you call it on a string that has already been
	 * converted to Unicode.
	 * @memberOf punycode
	 * @param {String} input The Punycoded domain name or email address to
	 * convert to Unicode.
	 * @returns {String} The Unicode representation of the given Punycode
	 * string.
	 */
	function toUnicode(input) {
		return mapDomain(input, function(string) {
			return regexPunycode.test(string)
				? decode(string.slice(4).toLowerCase())
				: string;
		});
	}

	/**
	 * Converts a Unicode string representing a domain name or an email address to
	 * Punycode. Only the non-ASCII parts of the domain name will be converted,
	 * i.e. it doesn't matter if you call it with a domain that's already in
	 * ASCII.
	 * @memberOf punycode
	 * @param {String} input The domain name or email address to convert, as a
	 * Unicode string.
	 * @returns {String} The Punycode representation of the given domain name or
	 * email address.
	 */
	function toASCII(input) {
		return mapDomain(input, function(string) {
			return regexNonASCII.test(string)
				? 'xn--' + encode(string)
				: string;
		});
	}

	/*--------------------------------------------------------------------------*/

	/** Define the public API */
	punycode = {
		/**
		 * A string representing the current Punycode.js version number.
		 * @memberOf punycode
		 * @type String
		 */
		'version': '1.3.0',
		/**
		 * An object of methods to convert from JavaScript's internal character
		 * representation (UCS-2) to Unicode code points, and back.
		 * @see <http://mathiasbynens.be/notes/javascript-encoding>
		 * @memberOf punycode
		 * @type Object
		 */
		'ucs2': {
			'decode': ucs2decode,
			'encode': ucs2encode
		},
		'decode': decode,
		'encode': encode,
		'toASCII': toASCII,
		'toUnicode': toUnicode
	};

    // Changed the way punycode is exposed
	root.punycode = punycode;
}(window));
/** end of punycode.js */
/** start of common.js */
/**
 * Utilities namespace
 */
adguard.utils = (function () {

    return {
        strings: null,
        collections: null,
        StopWatch: null
    };

})();

/**
 * Util class for work with strings
 */
(function (api) {

    if (!String.prototype.endsWith) {
        String.prototype.endsWith = function (suffix) { // jshint ignore:line
            const index = this.lastIndexOf(suffix);
            return index !== -1 && index === this.length - suffix.length;
        };
    }

    //noinspection UnnecessaryLocalVariableJS
    const StringUtils = {

        isEmpty: function (str) {
            return !str || str.trim().length === 0;
        },

        startWith: function (str, prefix) {
            return str && str.indexOf(prefix) === 0;
        },

        endsWith: function (str, postfix) {
            return str.endsWith(postfix);
        },

        substringAfter: function (str, separator) {
            if (!str) {
                return str;
            }
            const index = str.indexOf(separator);
            return index < 0 ? "" : str.substring(index + separator.length);
        },

        substringBefore: function (str, separator) {
            if (!str || !separator) {
                return str;
            }
            const index = str.indexOf(separator);
            return index < 0 ? str : str.substring(0, index);
        },

        contains: function (str, searchString) {
            return str && str.indexOf(searchString) >= 0;
        },

        containsIgnoreCase: function (str, searchString) {
            return str && searchString && str.toUpperCase().indexOf(searchString.toUpperCase()) >= 0;
        },

        replaceAll: function (str, find, replace) {
            if (!str) {
                return str;
            }
            return str.split(find).join(replace);
        },

        join: function (array, separator, startIndex, endIndex) {
            if (!array) {
                return null;
            }
            if (!startIndex) {
                startIndex = 0;
            }
            if (!endIndex) {
                endIndex = array.length;
            }
            if (startIndex >= endIndex) {
                return "";
            }
            const buf = [];
            for (let i = startIndex; i < endIndex; i++) {
                buf.push(array[i]);
            }
            return buf.join(separator);
        },

        /**
         * Get string before regexp first match
         * @param {string} str
         * @param {RegExp} rx
         */
        getBeforeRegExp: function (str, rx) {
            let index = str.search(rx);
            return str.substring(0, index);
        },

        /**
         * Look for any symbol from "chars" array starting at "start" index or from the start of the string
         *
         * @param str   String to search
         * @param chars Chars to search for
         * @param start Start index (optional, inclusive)
         * @return int Index of the element found or null
         */
        indexOfAny: function (str, chars, start) {

            start = start || 0;

            if (typeof str === 'string' && str.length <= start) {
                return -1;
            }

            for (let i = start; i < str.length; i++) {
                const c = str.charAt(i);
                if (chars.indexOf(c) > -1) {
                    return i;
                }
            }

            return -1;
        },

        /**
         * Splits string by a delimiter, ignoring escaped delimiters
         * @param str               String to split
         * @param delimiter         Delimiter
         * @param escapeCharacter   Escape character
         * @param preserveAllTokens If true - preserve empty entries.
         */
        splitByDelimiterWithEscapeCharacter: function (str, delimiter, escapeCharacter, preserveAllTokens) {

            const parts = [];

            if (adguard.utils.strings.isEmpty(str)) {
                return parts;
            }

            let sb = [];
            for (let i = 0; i < str.length; i++) {

                const c = str.charAt(i);

                if (c === delimiter) {
                    if (i === 0) { // jshint ignore:line
                        // Ignore
                    } else if (str.charAt(i - 1) === escapeCharacter) {
                        sb.splice(sb.length - 1, 1);
                        sb.push(c);
                    } else {
                        if (preserveAllTokens || sb.length > 0) {
                            const part = sb.join('');
                            parts.push(part);
                            sb = [];
                        }
                    }
                } else {
                    sb.push(c);
                }
            }

            if (preserveAllTokens || sb.length > 0) {
                parts.push(sb.join(''));
            }

            return parts;
        }
    };

    api.strings = StringUtils;

})(adguard.utils);

/**
 * Util class for work with collections
 */
(function (api) {

    //noinspection UnnecessaryLocalVariableJS
    const CollectionUtils = {

        /**
         * Find element in array by property
         * @param array
         * @param property
         * @param value
         * @returns {*}
         */
        find: function (array, property, value) {
            if (typeof array.find === 'function') {
                return array.find(function (a) {
                    return a[property] === value;
                });
            }
            for (let i = 0; i < array.length; i++) {
                const elem = array[i];
                if (elem[property] === value) {
                    return elem;
                }
            }
            return null;
        },

        /**
         * Checks if specified object is array
         * We don't use instanceof because it is too slow: http://jsperf.com/instanceof-performance/2
         * @param obj Object
         */
        isArray: Array.isArray || function (obj) {
            return '' + obj === '[object Array]';
        }
    };

    api.collections = CollectionUtils;

})(adguard.utils);

/**
 * Simple time measurement utils
 */
(function (api) {

    const StopWatch = function (name) {
        this.name = name;
    };

    StopWatch.prototype = {

        start: function () {
            this.startTime = Date.now();
        },

        stop: function () {
            this.stopTime = Date.now();
        },

        print: function () {
            const elapsed = this.stopTime - this.startTime;
            console.log(this.name + "[elapsed: " + elapsed + " ms]");
        }
    };

    api.StopWatch = StopWatch;

})(adguard.utils);
/** end of common.js */
/** start of url.js */
(function (api, global) {

    /**
     * Helper methods to work with URLs
     */
    const UrlUtils = {

        toPunyCode: function (domain) {
            if (!domain) {
                return "";
            }
            if (/^[\x00-\x7F]+$/.test(domain)) {
                return domain;
            }
            return global.punycode.toASCII(domain);
        },

        /**
         * Checks all domains from domainNames with isDomainOrSubDomain
         * @param domainNameToCheck Domain name to check
         * @param domainNames List of domain names
         * @returns boolean true if there is suitable domain in domainNames
         */
        isDomainOrSubDomainOfAny: function (domainNameToCheck, domainNames) {
            if (!domainNames || domainNames.length === 0) {
                return false;
            }

            for (let i = 0; i < domainNames.length; i++) {
                if (this.isDomainOrSubDomain(domainNameToCheck, domainNames[i])) {
                    return true;
                }
            }

            return false;
        },

        /**
         * Checks if the specified domain is a sub-domain of equal to domainName
         *
         * @param domainNameToCheck Domain name to check
         * @param domainName        Domain name
         * @returns boolean true if there is suitable domain in domainNames
         */
        isDomainOrSubDomain: function (domainNameToCheck, domainName) {
            // Double endsWith check is memory optimization
            // Works in android, not sure if it makes sense here
            return domainName === domainNameToCheck ||
                api.strings.endsWith(domainNameToCheck, domainName) &&
                api.strings.endsWith(domainNameToCheck, "." + domainName);
        }
    };

    api.url = UrlUtils;

})(adguard.utils, window);
/** end of url.js */
/** start of log.js */
/**
 * Simple logger with log levels
 */
adguard.console = (function () {

    // Redefine if you need it
    const CURRENT_LEVEL = "INFO";

    const LEVELS = {
        ERROR: 1,
        WARN: 2,
        INFO: 3,
        DEBUG: 4
    };

    /**
     * Pretty-print javascript error
     */
    const errorToString = function (error) {
        return error.toString() + "\nStack trace:\n" + error.stack;
    };

    /**
     * Prints log message
     */
    const print = function (level, method, args) {
        //check log level
        if (LEVELS[CURRENT_LEVEL] < LEVELS[level]) {
            return;
        }
        if (!args || args.length === 0 || !args[0]) {
            return;
        }

        const str = args[0] + "";
        args = Array.prototype.slice.call(args, 1);
        let formatted = str.replace(/{(\d+)}/g, function (match, number) {

            if (typeof args[number] !== "undefined") {
                let value = args[number];
                if (value instanceof Error) {
                    value = errorToString(value);
                } else if (value && value.message) {
                    value = value.message;
                }
                return value;
            }

            return match;
        });

        const now = new Date();
        formatted = now.toISOString() + ": " + formatted;
        console[method](formatted);
    };

    /**
     * Expose public API
     */
    return {
        debug: function () {
            print("DEBUG", "log", arguments);
        },

        info: function () {
            print("INFO", "info", arguments);
        },

        warn: function () {
            print("WARN", "info", arguments);
        },

        error: function () {
            print("ERROR", "error", arguments);
        }
    };
})();
/** end of log.js */
/** start of tld-list.js */
(function (api) {

    /**
     * Popular top level domains list
     *
     * @type {[*]}
     */
    const TOP_LEVEL_DOMAINS_LIST = [
        'com',
        'org',
        'ru',
        'net',
        'de',
        'com.br',
        'ir',
        'co.uk',
        'pl',
        'it',
        'com.au',
        'fr',
        'info',
        'in',
        'cz',
        'es',
        'io',
        'jp',
        'ro',
        'nl',
        'gr',
        'co',
        'ca',
        'eu',
        'ch',
        'com.tw',
        'se',
        'sk',
        'hu',
        'me',
        'co.za',
        'no',
        'tv',
        'dk',
        'at',
        'co.jp',
        'edu',
        'be',
        'cn',
        'co.kr',
        'com.ar',
        'com.ua',
        'cl',
        'biz',
        'xyz',
        'com.mx',
        'fi',
        'us',
        'vn',
        'pt',
        'com.tr',
        'club',
        'ie',
        'pro',
        'online',
        'co.in',
        'ua',
        'org.uk',
        'cc',
        'az',
        'by',
        'mx',
        'tw',
        'co.il',
        'gov.in',
        'com.cn',
        'kz',
        'bg',
        'lt',
        'site',
        'su',
        'hr',
        'org.br',
        'gov',
        'com.pl',
        'co.nz',
        'si',
        'top',
        'ac.in',
        'com.hk',
        'com.sg',
        'rs',
        'com.co',
        'kr',
        'co.id',
        'pw',
        'uz',
        'com.my',
        'ae',
        'nic.in',
        'com.vn',
        'hk',
        'org.au',
        'tk',
        'lv',
        'live',
        'to',
        'mobi',
        'gov.cn',
    ];

    api.TOP_LEVEL_DOMAINS_LIST = TOP_LEVEL_DOMAINS_LIST;

})(adguard.utils);
/** end of tld-list.js */
/** start of simple-regex.js */
(function (api) {

    'use strict';

    /**
     * Helper class for creating regular expression from a simple wildcard-syntax used in basic filters
     */
    api.SimpleRegex = (function () {

        /**
         * Improved regular expression instead of UrlFilterRule.REGEXP_START_URL (||)
         * Please note, that this regular expression matches only ONE level of subdomains
         * Using ([a-z0-9-.]+\\.)? instead increases memory usage by 10Mb
         */
        const URL_FILTER_REGEXP_START_URL = "^[htpsw]+:\\/\\/([a-z0-9-]+\\.)?";
        /** Simplified separator (to fix an issue with $ restriction - it can be only in the end of regexp) */
        const URL_FILTER_REGEXP_SEPARATOR = "[/:&?]?";

        // Constants
        const regexConfiguration = {
            maskStartUrl: "||",
            maskPipe: "|",
            maskSeparator: "^",
            maskAnySymbol: "*",

            regexAnySymbol: ".*",
            regexSeparator: URL_FILTER_REGEXP_SEPARATOR,
            regexStartUrl: URL_FILTER_REGEXP_START_URL,
            regexStartString: "^",
            regexEndString: "$"
        };

        // https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/regexp
        // should be escaped . * + ? ^ $ { } ( ) | [ ] / \
        // except of * | ^
        const specials = [
            '.', '+', '?', '$', '{', '}', '(', ')', '[', ']', '\\', '/'
        ];
        const specialsRegex = new RegExp('[' + specials.join('\\') + ']', 'g');

        /**
         * Escapes regular expression string
         */
        const escapeRegExp = str => str.replace(specialsRegex, "\\$&");

        /**
         * Checks if string "str" starts with the specified "prefix"
         */
        const startsWith = (str, prefix) => str && str.indexOf(prefix) === 0;

        /**
         * Checks if string "str" ends with the specified "postfix"
         */
        const endsWith = (str, postfix) => {
            if (!str || !postfix) {
                return false;
            }

            if (str.endsWith) {
                return str.endsWith(postfix);
            }
            const t = String(postfix);
            const index = str.lastIndexOf(t);
            return index >= 0 && index === str.length - t.length;
        };

        /**
         * Replaces all occurencies of a string "find" with "replace" str;
         */
        const replaceAll = (str, find, replace) => {
            if (!str) {
                return str;
            }
            return str.split(find).join(replace);
        };


        /**
         * Creates regex
         */
        const createRegexText = str => {
            if (str === regexConfiguration.maskStartUrl ||
                str === regexConfiguration.maskPipe ||
                str === regexConfiguration.maskAnySymbol) {
                return regexConfiguration.regexAnySymbol;
            }

            let regex = escapeRegExp(str);

            if (startsWith(regex, regexConfiguration.maskStartUrl)) {
                regex = regex.substring(0, regexConfiguration.maskStartUrl.length) +
                    replaceAll(regex.substring(regexConfiguration.maskStartUrl.length, regex.length - 1), "\|", "\\|") +
                    regex.substring(regex.length - 1);
            } else if (startsWith(regex, regexConfiguration.maskPipe)) {
                regex = regex.substring(0, regexConfiguration.maskPipe.length) +
                    replaceAll(regex.substring(regexConfiguration.maskPipe.length, regex.length - 1), "\|", "\\|") +
                    regex.substring(regex.length - 1);
            } else {
                regex = replaceAll(regex.substring(0, regex.length - 1), "\|", "\\|") +
                    regex.substring(regex.length - 1);
            }

            // Replacing special url masks
            regex = replaceAll(regex, regexConfiguration.maskAnySymbol, regexConfiguration.regexAnySymbol);
            regex = replaceAll(regex, regexConfiguration.maskSeparator, regexConfiguration.regexSeparator);

            if (startsWith(regex, regexConfiguration.maskStartUrl)) {
                regex = regexConfiguration.regexStartUrl + regex.substring(regexConfiguration.maskStartUrl.length);
            } else if (startsWith(regex, regexConfiguration.maskPipe)) {
                regex = regexConfiguration.regexStartString + regex.substring(regexConfiguration.maskPipe.length);
            }
            if (endsWith(regex, regexConfiguration.maskPipe)) {
                regex = regex.substring(0, regex.length - 1) + regexConfiguration.regexEndString;
            }

            return regex;
        };

        // EXPOSE
        return {
            // Function for creating regex
            createRegexText: createRegexText,

            // Configuration used for the transformation
            regexConfiguration: regexConfiguration
        };
    })();

})(adguard.rules);
/** end of simple-regex.js */
/** start of base-filter-rule.js */
(function (adguard, api) {

    'use strict';

    /**
     * Base class for all filter rules
     */
    const FilterRule = function (text) {
        this.ruleText = text;
    };

    FilterRule.prototype = {

        /**
         * Loads $domain option.
         * http://adguard.com/en/filterrules.html#hideRulesDomainRestrictions
         * http://adguard.com/en/filterrules.html#advanced
         *
         * @param domains List of domains. Examples: "example.com|test.com" or "example.com,test.com"
         */
        loadDomains: function (domains) {

            if (adguard.utils.strings.isEmpty(domains)) {
                return;
            }

            let permittedDomains = null;
            let restrictedDomains = null;

            let parts = domains.split(/[,|]/);
            try {
                for (let i = 0; i < parts.length; i++) {
                    const domain = parts[i];
                    let domainName;
                    if (adguard.utils.strings.startWith(domain, "~")) {
                        domainName = adguard.utils.url.toPunyCode(domain.substring(1).trim());
                        if (!adguard.utils.strings.isEmpty(domainName)) {
                            if (restrictedDomains === null) {
                                restrictedDomains = [];
                            }
                            restrictedDomains.push(domainName);
                        }
                    } else {
                        domainName = adguard.utils.url.toPunyCode(domain.trim());
                        if (!adguard.utils.strings.isEmpty(domainName)) {
                            if (permittedDomains === null) {
                                permittedDomains = [];
                            }
                            permittedDomains.push(domainName);
                        }
                    }
                }
            } catch (ex) {
                adguard.console.error("Error load domains from {0}, cause {1}", domains, ex);
            }

            this.setPermittedDomains(permittedDomains);
            this.setRestrictedDomains(restrictedDomains);
        },

        setPermittedDomains: function (permittedDomains) {
            if (!permittedDomains || permittedDomains.length === 0) {
                delete this.permittedDomain;
                delete this.permittedDomains;
                return;
            }
            if (permittedDomains.length > 1) {
                this.permittedDomains = permittedDomains;
                delete this.permittedDomain;
            } else {
                this.permittedDomain = permittedDomains[0];
                delete this.permittedDomains;
            }
        },

        setRestrictedDomains: function (restrictedDomains) {
            if (!restrictedDomains || restrictedDomains.length === 0) {
                delete this.restrictedDomain;
                delete this.restrictedDomains;
                return;
            }
            if (restrictedDomains.length > 1) {
                this.restrictedDomains = restrictedDomains;
                delete this.restrictedDomain;
            } else {
                this.restrictedDomain = restrictedDomains[0];
                delete this.restrictedDomains;
            }
        },

        /**
         * @returns boolean true if rule has permitted domains
         */
        hasPermittedDomains: function () {
            return (this.permittedDomain || (this.permittedDomains && this.permittedDomains.length > 0));
        },

        /**
         * Checks if rule could be applied to the specified domain name
         *
         * @param domainName Domain name
         * @returns boolean true if rule is permitted
         */
        isPermitted: function (domainName) {
            if (!domainName) { return false; }

            if (this.restrictedDomain && adguard.utils.url.isDomainOrSubDomain(domainName, this.restrictedDomain)) {
                return false;
            }

            if (this.restrictedDomains && adguard.utils.url.isDomainOrSubDomainOfAny(domainName, this.restrictedDomains)) {
                return false;
            }

            if (this.hasPermittedDomains()) {
                if (this.permittedDomain && adguard.utils.url.isDomainOrSubDomain(domainName, this.permittedDomain)) {
                    return true;
                }

                return adguard.utils.url.isDomainOrSubDomainOfAny(domainName, this.permittedDomains);
            }

            return true;
        }
    };

    /**
     * Checks if the specified string starts with a substr at the specified index
     *
     * @param str        String to check
     * @param startIndex Index to start checking from
     * @param substr     Substring to check
     * @return boolean true if it does start
     */
    function startsAtIndexWith(str, startIndex, substr) {

        if (str.length - startIndex < substr.length) {
            return false;
        }

        for (let i = 0; i < substr.length; i++) {
            if (str.charAt(startIndex + i) !== substr.charAt(i)) {
                return false;
            }
        }

        return true;
    }

    /**
     * Finds CSS rule marker in the rule text
     *
     * @param ruleText        rule text to check
     * @param markers         a list of markers to check (IMPORTANT: sorted by length desc)
     * @param firstMarkerChar first character of the marker we're looking for
     * @return rule marker found
     */
    FilterRule.findRuleMarker = function (ruleText, markers, firstMarkerChar) {

        const startIndex = ruleText.indexOf(firstMarkerChar);
        if (startIndex === -1) {
            return null;
        }

        for (let i = 0; i < markers.length; i++) {
            const marker = markers[i];
            if (startsAtIndexWith(ruleText, startIndex, marker)) {
                return marker;
            }
        }

        return null;
    };

    /**
     * urlencodes rule text.
     * We need this function because of this issue:
     * https://github.com/AdguardTeam/AdguardBrowserExtension/issues/34
     */
    FilterRule.escapeRule = function (ruleText) {
        return encodeURIComponent(ruleText).replace(/'/g, "%27");
    };

    FilterRule.PARAMETER_START = "[";
    FilterRule.PARAMETER_END = "]";
    FilterRule.MASK_WHITE_LIST = "@@";
    FilterRule.MASK_CSS_RULE = "##";
    FilterRule.MASK_CSS_EXCEPTION_RULE = "#@#";
    FilterRule.MASK_CSS_INJECT_RULE = "#$#";
    FilterRule.MASK_CSS_EXCEPTION_INJECT_RULE = "#@$#";
    FilterRule.MASK_CSS_EXTENDED_CSS_RULE = "#?#";
    FilterRule.MASK_CSS_EXCEPTION_EXTENDED_CSS_RULE = "#@?#";
    FilterRule.MASK_CSS_INJECT_EXTENDED_CSS_RULE = "#$?#";
    FilterRule.MASK_CSS_EXCEPTION_INJECT_EXTENDED_CSS_RULE = "#@$?#";
    FilterRule.MASK_SCRIPT_RULE = "#%#";
    FilterRule.MASK_SCRIPT_EXCEPTION_RULE = "#@%#";
    FilterRule.MASK_JS_RULE = "%%";
    FilterRule.MASK_CONTENT_RULE = "$$";
    FilterRule.MASK_CONTENT_EXCEPTION_RULE = "$@$";
    FilterRule.MASK_BANNER_RULE = "++";
    FilterRule.MASK_CONFIGURATION_RULE = "~~";
    FilterRule.COMMENT = "!";
    FilterRule.EQUAL = "=";
    FilterRule.COMA_DELIMITER = ",";
    FilterRule.LINE_DELIMITER = "|";
    FilterRule.NOT_MARK = "~";
    FilterRule.OLD_INJECT_RULES = "adg_start_style_inject";

    api.FilterRule = FilterRule;

})(adguard, adguard.rules);
/** end of base-filter-rule.js */
/** start of rule-converter.js */
/**
 * This source file and tests are copied from https://github.com/AdguardTeam/AdguardBrowserExtension/blob/master/Extension/lib/filter/rule-converter.js
 * and https://github.com/AdguardTeam/AdguardBrowserExtension/blob/master/Extension/tests/rule-converter/test-rule-converter.js
 */

(function (adguard, api) {
    const stringUtils = adguard.utils.strings;
    /**
     * AdGuard scriptlet mask
     */
        // eslint-disable-next-line no-template-curly-in-string
    const ADGUARD_SCRIPTLET_MASK = '${domains}#%#//scriptlet(${args})';

    /**
     * AdGuard scriptlet exception mask
     */
        // eslint-disable-next-line no-template-curly-in-string
    const ADGUARD_SCRIPTLET_EXCEPTION_MASK = '${domains}#@%#//scriptlet(${args})';

    /**
     * uBlock scriptlet rule mask
     */
    const UBO_SCRIPTLET_MASK_REG = /##script\:inject|#@?#\s*\+js/;
    const UBO_SCRIPTLET_MASK_1 = '##+js';
    const UBO_SCRIPTLET_MASK_2 = '##script:inject';
    const UBO_SCRIPTLET_EXCEPTION_MASK_1 = '#@#+js';
    const UBO_SCRIPTLET_EXCEPTION_MASK_2 = '#@#script:inject';
    const UBO_SCRIPT_TAG_MASK = '##^script';
    /**
     * AdBlock Plus snippet rule mask
     */
    const ABP_SCRIPTLET_MASK = '#$#';
    const ABP_SCRIPTLET_EXCEPTION_MASK = '#@$#';

    /**
     * AdGuard CSS rule mask
     */
    const ADG_CSS_MASK_REG = /#@?\$#.+?\s*\{.*\}\s*$/g;

    /**
     * Return array of strings separated by space which not in quotes
     * @param {string} str
     */
    function getSentences(str) {
        const reg = /'.*?'|".*?"|\S+/g;
        return str.match(reg);
    }

    /**
     * Returns substring enclosed in the widest braces
     * @param {string} str
     */
    function getStringInBraces(str) {
        const firstIndex = str.indexOf('(');
        const lastIndex = str.lastIndexOf(')');
        return str.substring(firstIndex + 1, lastIndex);
    }

    /**
     * Wrap str in double qoutes and replaces single quotes if need
     * @param {string} str
     */
    function wrapInDoubleQuotes(str) {
        if (str[0] === '\'' && str[str.length - 1] === '\'') {
            str = str.substring(1, str.length - 1);
            str = str.replace(/\"/g, '\\"');
        } else if (str[0] === '"' && str[str.length - 1] === '"') {
            str = str.substring(1, str.length - 1);
            str = str.replace(/\'/g, '\\\'');
        }
        return `"${str}"`;
    }


    /**
     * Replace string with data by placeholders
     * @param {string} str
     * @param {Object} data where keys is placeholdes names
     */
    function replacePlaceholders(str, data) {
        return Object.keys(data).reduce((acc, key) => {
            const reg = new RegExp(`\\$\\{${key}\\}`, 'g');
            acc = acc.replace(reg, data[key]);
            return acc;
        }, str);
    }

    /**
     * Convert string of UBO scriptlet rule to AdGuard scritlet rule
     * @param {string} rule UBO scriptlet rule
     */
    function convertUboScriptletRule(rule) {
        const domains = stringUtils.getBeforeRegExp(rule, UBO_SCRIPTLET_MASK_REG);
        const mask = rule.match(UBO_SCRIPTLET_MASK_REG)[0];
        let template;
        if (mask.indexOf('@') > -1) {
            template = ADGUARD_SCRIPTLET_EXCEPTION_MASK;
        } else {
            template = ADGUARD_SCRIPTLET_MASK;
        }
        const args = getStringInBraces(rule)
            .split(/, /g)
            .map((arg, index) => (index === 0 ? `ubo-${arg}` : arg))
            .map(arg => wrapInDoubleQuotes(arg))
            .join(', ');

        return replacePlaceholders(
            template,
            { domains, args }
        );
    }

    /**
     * Convert string of ABP scriptlet rule to AdGuard scritlet rule
     * @param {string} rule UBO scriptlet rule
     */
    function convertAbpSnippetRule(rule) {
        const SEMICOLON_DIVIDER = /;(?=(?:(?:[^"]*"){2})*[^"]*$)/g;
        const mask = rule.indexOf(ABP_SCRIPTLET_MASK) > -1
            ? ABP_SCRIPTLET_MASK
            : ABP_SCRIPTLET_EXCEPTION_MASK;
        const template = mask === ABP_SCRIPTLET_MASK
            ? ADGUARD_SCRIPTLET_MASK
            : ADGUARD_SCRIPTLET_EXCEPTION_MASK;
        const domains = stringUtils.substringBefore(rule, mask);
        const args = stringUtils.substringAfter(rule, mask);
        return args.split(SEMICOLON_DIVIDER)
            .map(args => getSentences(args)
                .filter(arg => arg)
                .map((arg, index) => (index === 0 ? `abp-${arg}` : arg))
                .map(arg => wrapInDoubleQuotes(arg))
                .join(', '))
            .map(args => replacePlaceholders(template, { domains, args }));
    }

    /**
     * Check is uBO scriptlet rule
     * @param {string} rule rule text
     */
    function isUboScriptletRule(rule) {
        return (
                rule.indexOf(UBO_SCRIPTLET_MASK_1) > -1
                || rule.indexOf(UBO_SCRIPTLET_MASK_2) > -1
                || rule.indexOf(UBO_SCRIPTLET_EXCEPTION_MASK_1) > -1
                || rule.indexOf(UBO_SCRIPTLET_EXCEPTION_MASK_2) > -1
            )
            && UBO_SCRIPTLET_MASK_REG.test(rule);
    }

    /**
     * Check is AdBlock Plus snippet
     * @param {string} rule rule text
     */
    function isAbpSnippetRule(rule) {
        return (
                rule.indexOf(ABP_SCRIPTLET_MASK) > -1
                || rule.indexOf(ABP_SCRIPTLET_EXCEPTION_MASK) > -1
            ) && rule.search(ADG_CSS_MASK_REG) === -1;
    }

    /**
     * Converts UBO Script rule
     * @param {string} ruleText rule text
     * @returns {string} converted rule
     */
    function convertUboScriptTagRule(ruleText) {
        if (ruleText.indexOf(UBO_SCRIPT_TAG_MASK) === -1) {
            return null;
        }

        // We convert only one case ##^script:has-text at now
        const uboHasTextRule = ':has-text';
        const adgScriptTag = '$$script';
        const uboScriptTag = '##^script';

        const isRegExp = str => str[0] === '/' && str[str.length - 1] === '/';

        const match = ruleText.split(uboHasTextRule);
        if (match.length === 1) {
            return null;
        }

        const domains = match[0].replace(uboScriptTag, '');
        const rules = [];
        for (let i = 1; i < match.length; i += 1) {
            const attr = match[i].slice(1, -1);
            if (isRegExp(attr)) {
                rules.push(`${domains}${uboScriptTag}${uboHasTextRule}(${attr})`);
            } else {
                rules.push(`${domains}${adgScriptTag}[tag-content="${attr}"]`);
            }
        }

        return rules;
    }

    /**
     * Returns false or converted rule
     *
     * Example:
     * "example.com##h1:style(background-color: blue !important)"
     * -> "example.com##h1 {background-color: blue !important}"
     *
     * @param {string} ruleText - rule text to check if should be checked and if necessary converted
     * @return {string|boolean} - converted rule text or false
     */
    function convertUboCssStyleRule(ruleText) {
        const UBO_CSS_RULE_MARKERS = {
            MASK_CSS_RULE: '##',
            MASK_CSS_EXCEPTION_RULE: '#@#',
            MASK_CSS_EXTENDED_CSS_RULE: '#?#',
            MASK_CSS_EXCEPTION_EXTENDED_CSS_RULE: '#@?#',
        };

        const CSS_TO_INJECT_PAIRS = {
            [UBO_CSS_RULE_MARKERS.MASK_CSS_RULE]: '#$#',
            [UBO_CSS_RULE_MARKERS.MASK_CSS_EXCEPTION_RULE]: '#@$#',
            [UBO_CSS_RULE_MARKERS.MASK_CSS_EXTENDED_CSS_RULE]: '#$?#',
            [UBO_CSS_RULE_MARKERS.MASK_CSS_EXCEPTION_EXTENDED_CSS_RULE]: '#@$?#',
        };

        const RULE_MARKER_FIRST_CHAR = '#';

        const UBO_CSS_STYLE_PSEUDO_CLASS = ':style(';

        const uboMarkers = Object.keys(UBO_CSS_RULE_MARKERS).map(key => UBO_CSS_RULE_MARKERS[key]);

        const mask = api.FilterRule.findRuleMarker(
            ruleText,
            uboMarkers,
            RULE_MARKER_FIRST_CHAR
        );
        if (!mask) {
            return null;
        }
        const maskIndex = ruleText.indexOf(mask);
        const cssContent = ruleText.substring(maskIndex + mask.length);
        const shouldConvert = cssContent.indexOf(UBO_CSS_STYLE_PSEUDO_CLASS) > -1;
        if (!shouldConvert) {
            return null;
        }

        const domainsPart = ruleText.substring(0, maskIndex);
        const regex = /:style\s*\(\s*(\S+.*\S)\s*\)/;
        const subst = ' { $1 }';
        const convertedCssContent = cssContent.replace(regex, subst);
        if (convertedCssContent === cssContent) {
            throw new Error(`Empty :style pseudo class: ${cssContent}`);
        }
        return domainsPart + CSS_TO_INJECT_PAIRS[mask] + convertedCssContent;
    }

    /**
     * Converts abp rule into ag rule
     * e.g.
     * from:    "||example.org^$rewrite=abp-resource:blank-mp3"
     * to:      "||example.org^$redirect:blank-mp3"
     * @param {string} rule
     * @returns {string|null}
     */
    function convertAbpRedirectRule(rule) {
        const ABP_REDIRECT_KEYWORD = 'rewrite=abp-resource:';
        const AG_REDIRECT_KEYWORD = 'redirect=';
        if (!rule.includes(ABP_REDIRECT_KEYWORD)) {
            return null;
        }
        return rule.replace(ABP_REDIRECT_KEYWORD, AG_REDIRECT_KEYWORD);
    }

    function convertOptions(rule) {
        const OPTIONS_DELIMITER = '$';
        const ESCAPE_CHARACTER = '\\';
        const NAME_VALUE_SPLITTER = '=';
        const EMPTY_OPTION = 'empty';
        const MP4_OPTION = 'mp4';
        const CSP_OPTION = 'csp';
        const INLINE_SCRIPT_OPTION = 'inline-script';
        const INLINE_FONT_OPTION = 'inline-font';
        const MEDIA_OPTION = 'media';
        const ALL_OPTION = 'all';
        const POPUP_OPTION = 'popup';
        const DOCUMENT_OPTION = 'document';

        /* eslint-disable max-len */
        const conversionMap = {
            [EMPTY_OPTION]: 'redirect=nooptext',
            [MP4_OPTION]: 'redirect=noopmp4-1s',
            [INLINE_SCRIPT_OPTION]: `${CSP_OPTION}=script-src 'self' 'unsafe-eval' http: https: data: blob: mediastream: filesystem:`,
            [INLINE_FONT_OPTION]: `${CSP_OPTION}=font-src 'self' 'unsafe-eval' http: https: data: blob: mediastream: filesystem:`,
        };
        /* eslint-enable max-len */

        let options;
        let domainPart;

        // Start looking from the prev to the last symbol
        // If dollar sign is the last symbol - we simply ignore it.
        for (let i = (rule.length - 2); i >= 0; i -= 1) {
            const currChar = rule.charAt(i);
            if (currChar !== OPTIONS_DELIMITER) {
                continue;
            }
            if (i > 0 && rule.charAt(i - 1) !== ESCAPE_CHARACTER) {
                domainPart = rule.substring(0, i);
                options = rule.substring(i + 1);
                // Options delimiter was found, doing nothing
                break;
            }
        }
        if (!options) {
            return null;
        }
        const optionsParts = options.split(',');
        let optionsConverted = false;

        let updatedOptionsParts = optionsParts.map((optionsPart) => {
            let convertedOptionsPart = conversionMap[optionsPart];

            // if option is $mp4, than it should go with $media option together
            // https://github.com/AdguardTeam/AdguardBrowserExtension/issues/1452
            if (optionsPart === MP4_OPTION) {
                // check if media is not already among options
                if (!optionsParts.some(option => option === MEDIA_OPTION)) {
                    convertedOptionsPart = `${convertedOptionsPart},media`;
                }
            }

            if (convertedOptionsPart) {
                optionsConverted = true;
                return convertedOptionsPart;
            }

            return optionsPart;
        });

        // if has more than one csp modifiers, we merge them into one;
        const cspParts = updatedOptionsParts.filter(optionsPart => stringUtils.startWith(optionsPart, CSP_OPTION));

        if (cspParts.length > 1) {
            const allButCsp = updatedOptionsParts
                .filter(optionsPart => !stringUtils.startWith(optionsPart, CSP_OPTION));

            const cspValues = cspParts.map((cspPart) => {
                // eslint-disable-next-line no-unused-vars
                const [_, value] = cspPart.split(NAME_VALUE_SPLITTER);
                return value;
            });

            const updatedCspOption = `${CSP_OPTION}${NAME_VALUE_SPLITTER}${cspValues.join('; ')}`;
            updatedOptionsParts = allButCsp.concat(updatedCspOption);
        }

        // options without all modifier
        const hasAllOption = updatedOptionsParts.indexOf(ALL_OPTION) > -1;

        if (hasAllOption) {
            const allOptionReplacers = [
                DOCUMENT_OPTION,
                POPUP_OPTION,
                INLINE_SCRIPT_OPTION,
                INLINE_FONT_OPTION,
            ];
            return allOptionReplacers.map((replacer) => {
                // remove replacer and all option from the list
                const optionsButAllAndReplacer = updatedOptionsParts
                    .filter(option => !(option === replacer || option === ALL_OPTION));

                // try get converted values, used for INLINE_SCRIPT_OPTION, INLINE_FONT_OPTION
                const convertedReplacer = conversionMap[replacer] || replacer;

                // add replacer to the list of options
                const updatedOptionsString = [convertedReplacer, ...optionsButAllAndReplacer].join(',');

                // create a new rule
                return `${domainPart}\$${updatedOptionsString}`;
            });
        }

        if (optionsConverted) {
            const updatedOptions = updatedOptionsParts.join(',');
            return `${domainPart}\$${updatedOptions}`;
        }

        return null;
    }

    /**
     * Checks if rule text is comment e.g. !!example.org##+js(set-constant.js, test, false)
     * @param {string} rule
     * @return {boolean}
     */
    const isComment = rule => stringUtils.startWith(rule, api.FilterRule.COMMENT);

    /**
     * Convert external scriptlet rule to AdGuard scriptlet syntax
     * @param {string} rule convert rule
     */
    function convertRule(rule) {
        if (isComment(rule)) {
            return rule;
        }
        if (isUboScriptletRule(rule)) {
            return convertUboScriptletRule(rule);
        }
        if (isAbpSnippetRule(rule)) {
            return convertAbpSnippetRule(rule);
        }

        const uboScriptRule = convertUboScriptTagRule(rule);
        if (uboScriptRule) {
            return uboScriptRule;
        }

        const uboCssStyleRule = convertUboCssStyleRule(rule);
        if (uboCssStyleRule) {
            return uboCssStyleRule;
        }

        // Convert abp redirect rule
        const abpRedirectRule = convertAbpRedirectRule(rule);
        if (abpRedirectRule) {
            return abpRedirectRule;
        }

        // Convert options
        const ruleWithConvertedOptions = convertOptions(rule);
        if (ruleWithConvertedOptions) {
            return ruleWithConvertedOptions;
        }

        return rule;
    }

    api.ruleConverter = { convertRule };
})(adguard, adguard.rules);
/** end of rule-converter.js */
/** start of filter-rule-builder.js */
(function (adguard, api) {

    'use strict';

    /**
     * Filters unsupported rules from third-party sources
     *
     * @param ruleText
     */
    const filterUnsupportedRules = function (ruleText) {
        // uBO HTML filters
        if (ruleText.includes('##^')) {
            return false;
        }

        return true;
    };

    /**
     * Method that parses rule text and creates object of a suitable class.
     *
     * @param ruleText Rule text
     * @returns Filter rule object.
     */
    const _createRule = function (ruleText) {

        ruleText = ruleText ? ruleText.trim() : null;
        if (!ruleText) {
            return null;
        }
        const rule = null;
        try {

            const StringUtils = adguard.utils.strings;

            if (StringUtils.startWith(ruleText, api.FilterRule.COMMENT) ||
                StringUtils.contains(ruleText, api.FilterRule.OLD_INJECT_RULES) ||
                StringUtils.contains(ruleText, api.FilterRule.MASK_CONTENT_RULE) ||
                StringUtils.contains(ruleText, api.FilterRule.MASK_CONTENT_EXCEPTION_RULE) ||
                StringUtils.contains(ruleText, api.FilterRule.MASK_JS_RULE)) {
                // Empty or comment, ignore
                // Content rules are not supported
                return null;
            }

            if (!filterUnsupportedRules(ruleText)) {
                return null;
            }

            if (StringUtils.startWith(ruleText, api.FilterRule.MASK_WHITE_LIST)) {
                return new api.UrlFilterRule(ruleText);
            }

            if (api.FilterRule.findRuleMarker(ruleText, api.CssFilterRule.RULE_MARKERS, api.CssFilterRule.RULE_MARKER_FIRST_CHAR)) {
                return new api.CssFilterRule(ruleText);
            }

            if (api.FilterRule.findRuleMarker(ruleText, api.ScriptFilterRule.RULE_MARKERS, api.ScriptFilterRule.RULE_MARKER_FIRST_CHAR)) {
                return api.ScriptletRule.isAdguardScriptletRule(ruleText)
                    ? new api.ScriptletRule(ruleText)
                    : new api.ScriptFilterRule(ruleText);
            }

            return new api.UrlFilterRule(ruleText);
        } catch (ex) {
            adguard.console.warn("Cannot create rule: {1}, cause {2}", ruleText, ex);
        }

        return null;
    };

    /**
     * Convert rules to AdGuard syntax and create rule
     *
     * @param {string} ruleText Rule text
     * @returns Filter rule object. Either UrlFilterRule or CssFilterRule or ScriptFilterRule.
     */
    const createRule = (ruleText) => {
        let conversionResult = null;
        try {
            conversionResult = api.ruleConverter.convertRule(ruleText);
        } catch (ex) {
            adguard.console.debug('Cannot convert rule: {1}, cause {2}', ruleText, ex);
        }

        if (!conversionResult) {
            return null;
        }

        if (Array.isArray(conversionResult)) {
            const rules = conversionResult
                .map(rt => _createRule(rt))
                .filter(rule => rule !== null);

            // composite rule shouldn't be with without rules inside it
            if (rules.length === 0) {
                return null;
            }

            return new api.CompositeRule(ruleText, rules);
        }
        const rule = _createRule(conversionResult);
        if (conversionResult !== ruleText) {
            rule.ruleText = ruleText;
            rule.convertedRuleText = conversionResult;
        }

        return rule;
    };

    api.builder = {
        createRule: createRule
    };

})(adguard, adguard.rules);
/** end of filter-rule-builder.js */
/** start of css-filter-rule.js */
(function (adguard, api) {

    'use strict';

    /**
     * CSS rule.
     *
     * Read here for details:
     * http://adguard.com/en/filterrules.html#hideRules
     * http://adguard.com/en/filterrules.html#cssInjection
     */
    const CssFilterRule = (function () {

        /**
         * Tries to convert CSS injections rules from uBlock syntax to our own
         * https://github.com/AdguardTeam/AdguardForAndroid/issues/701
         *
         * @param pseudoClass :style pseudo class
         * @param cssContent  CSS content
         * @return String CSS content if it is a :style rule or null otherwise
         */
        const convertCssInjectionRule = function (pseudoClass, cssContent) {

            const selector = cssContent.substring(0, pseudoClass.nameStartIndex);
            const styleStart = pseudoClass.nameStartIndex + pseudoClass.name.length + 1;
            const styleEnd = cssContent.length - 1;

            if (styleEnd <= styleStart) {
                throw new Error("Empty :style pseudo class: " + cssContent);
            }

            const style = cssContent.substring(styleStart, styleEnd);

            if (adguard.utils.strings.isEmpty(selector) || adguard.utils.strings.isEmpty(style)) {
                throw new Error("Wrong :style pseudo-element syntax: " + cssContent);
            }

            return selector + " { " + style + " }";
        };

        /**
         * Parses first pseudo class from the specified CSS selector
         *
         * @param selector
         * @returns {*} first PseudoClass found or null
         */
        const parsePseudoClass = function (selector) {
            let beginIndex = 0;
            let nameStartIndex = -1;
            let squareBracketIndex = 0;

            while (squareBracketIndex >= 0) {
                nameStartIndex = selector.indexOf(':', beginIndex);
                if (nameStartIndex < 0) {
                    return null;
                }

                if (nameStartIndex > 0 && selector.charAt(nameStartIndex - 1) === '\\') {
                    // Escaped colon character
                    return null;
                }

                squareBracketIndex = selector.indexOf("[", beginIndex);
                while (squareBracketIndex >= 0) {
                    if (nameStartIndex > squareBracketIndex) {
                        const squareEndBracketIndex = selector.indexOf("]", squareBracketIndex + 1);
                        beginIndex = squareEndBracketIndex + 1;
                        if (nameStartIndex < squareEndBracketIndex) {
                            // Means that colon character is somewhere inside attribute selector
                            // Something like a[src^="http://domain.com"]
                            break;
                        }

                        if (squareEndBracketIndex > 0) {
                            squareBracketIndex = selector.indexOf("[", beginIndex);
                        } else {
                            // bad rule, example: a[src="http:
                            return null;
                        }
                    } else {
                        squareBracketIndex = -1;
                        break;
                    }
                }
            }

            let nameEndIndex = adguard.utils.strings.indexOfAny(selector, [' ', '\t', '>', '(', '[', '.', '#', ':', '+', '~', '"', "'"], nameStartIndex + 1);
            if (nameEndIndex < 0) {
                nameEndIndex = selector.length;
            }

            const name = selector.substring(nameStartIndex, nameEndIndex);
            if (name.length <= 1) {
                // Either empty name or a pseudo element (like ::content)
                return null;
            }

            return {
                name: name,
                nameStartIndex: nameStartIndex,
                nameEndIndex: nameEndIndex
            };
        };

        return function (rule) {

            api.FilterRule.call(this, rule);

            let mask = api.FilterRule.findRuleMarker(rule, CssFilterRule.RULE_MARKERS, CssFilterRule.RULE_MARKER_FIRST_CHAR);
            if (!mask) {
                throw new Error("ruleText does not contain a CSS rule marker: " + rule);
            }

            let isInjectRule = CssFilterRule.INJECT_MARKERS.indexOf(mask) !== -1;
            this.whiteListRule = CssFilterRule.WHITELIST_MARKERS.indexOf(mask) !== -1;
            let isExtendedCss = CssFilterRule.EXTCSS_MARKERS.indexOf(mask) !== -1;

            const indexOfMask = rule.indexOf(mask);
            if (indexOfMask > 0) {
                // domains are specified, parsing
                const domains = rule.substring(0, indexOfMask);
                this.loadDomains(domains);
            }

            let cssContent = rule.substring(indexOfMask + mask.length);

            if (!isInjectRule) {
                // We need this for two things:
                // 1. Convert uBlock-style CSS injection rules
                // 2. Validate pseudo-classes
                // https://github.com/AdguardTeam/AdguardForAndroid/issues/701
                const pseudoClass = parsePseudoClass(cssContent);
                if (pseudoClass !== null && ":style" === pseudoClass.name) {
                    isInjectRule = true;
                    cssContent = convertCssInjectionRule(pseudoClass, cssContent);
                } else if (pseudoClass !== null) {
                    if (CssFilterRule.SUPPORTED_PSEUDO_CLASSES.indexOf(pseudoClass.name) < 0) {
                        throw new Error("Unknown pseudo class: " + cssContent);
                    }
                }
            }

            if (isInjectRule) {
                // Simple validation for css injection rules
                if (!/{.+}/.test(cssContent)) {
                    throw new Error("Invalid css injection rule, no style presented: " + rule);
                }
            }

            // Extended CSS selectors support
            // https://github.com/AdguardTeam/ExtendedCss
            for (let i = 0; i < CssFilterRule.EXTENDED_CSS_MARKERS.length; i++) {
                if (cssContent.indexOf(CssFilterRule.EXTENDED_CSS_MARKERS[i]) >= 0) {
                    isExtendedCss = true;
                }
            }

            this.isInjectRule = isInjectRule;
            this.extendedCss = isExtendedCss;
            this.cssSelector = cssContent;
        };
    })();

    CssFilterRule.prototype = Object.create(api.FilterRule.prototype);

    /**
     * The problem with pseudo-classes is that any unknown pseudo-class makes browser ignore the whole CSS rule,
     * which contains a lot more selectors. So, if CSS selector contains a pseudo-class, we should try to validate it.
     * <p>
     * One more problem with pseudo-classes is that they are actively used in uBlock, hence it may mess AG styles.
     */
    CssFilterRule.SUPPORTED_PSEUDO_CLASSES = [":active",
        ":checked", ":contains", ":disabled", ":empty", ":enabled", ":first-child", ":first-of-type",
        ":focus", ":has", ":has-text", ":hover", ":if", ":if-not", ":in-range", ":invalid", ":lang",
        ":last-child", ":last-of-type", ":link", ":matches-css", ":matches-css-before", ":matches-css-after",
        ":not", ":nth-child", ":nth-last-child", ":nth-last-of-type", ":nth-of-type",
        ":only-child", ":only-of-type", ":optional", ":out-of-range", ":properties", ":read-only",
        ":read-write", ":required", ":root", ":target", ":valid", ":visited",
        ":-abp-has", ":-abp-contains", ":-abp-properties"];

    /**
     * The problem with it is that ":has" and ":contains" pseudo classes are not a valid pseudo classes,
     * hence using it may break old versions of AG.
     */
    CssFilterRule.EXTENDED_CSS_MARKERS = ["[-ext-has=", "[-ext-contains=", "[-ext-has-text=", "[-ext-matches-css=",
        "[-ext-matches-css-before=", "[-ext-matches-css-after=", ":has(", ":has-text(", ":contains(",
        ":matches-css(", ":matches-css-before(", ":matches-css-after(", ":-abp-has(", ":-abp-contains(",
        ":if(", ":if-not(", ":properties(", ":-abp-properties("];

    /**
     * All CSS rules markers start with this character
     */
    CssFilterRule.RULE_MARKER_FIRST_CHAR = '#';

    /**
     * CSS rule markers
     */
    CssFilterRule.RULE_MARKERS = [
        api.FilterRule.MASK_CSS_EXCEPTION_INJECT_EXTENDED_CSS_RULE,
        api.FilterRule.MASK_CSS_INJECT_EXTENDED_CSS_RULE,
        api.FilterRule.MASK_CSS_EXCEPTION_INJECT_RULE,
        api.FilterRule.MASK_CSS_INJECT_RULE,
        api.FilterRule.MASK_CSS_EXCEPTION_EXTENDED_CSS_RULE,
        api.FilterRule.MASK_CSS_EXTENDED_CSS_RULE,
        api.FilterRule.MASK_CSS_EXCEPTION_RULE,
        api.FilterRule.MASK_CSS_RULE
    ];

    /**
     * Masks indicating whitelist exception rules
     */
    CssFilterRule.WHITELIST_MARKERS = [
        api.FilterRule.MASK_CSS_EXCEPTION_RULE, api.FilterRule.MASK_CSS_EXCEPTION_INJECT_RULE,
        api.FilterRule.MASK_CSS_EXCEPTION_EXTENDED_CSS_RULE, api.FilterRule.MASK_CSS_EXCEPTION_INJECT_EXTENDED_CSS_RULE];

    /**
     * Masks indicating extended css rules
     */
    CssFilterRule.EXTCSS_MARKERS = [
        api.FilterRule.MASK_CSS_EXCEPTION_INJECT_EXTENDED_CSS_RULE, api.FilterRule.MASK_CSS_INJECT_EXTENDED_CSS_RULE,
        api.FilterRule.MASK_CSS_EXCEPTION_EXTENDED_CSS_RULE, api.FilterRule.MASK_CSS_EXTENDED_CSS_RULE];

    /**
     * Masks indicating inject css rules
     */
    CssFilterRule.INJECT_MARKERS = [
        api.FilterRule.MASK_CSS_EXCEPTION_INJECT_EXTENDED_CSS_RULE, api.FilterRule.MASK_CSS_INJECT_EXTENDED_CSS_RULE,
        api.FilterRule.MASK_CSS_EXCEPTION_INJECT_RULE, api.FilterRule.MASK_CSS_INJECT_RULE];

    api.CssFilterRule = CssFilterRule;

})(adguard, adguard.rules);
/** end of css-filter-rule.js */
/** start of url-filter-rule.js */
(function (adguard, api) {

    'use strict';

    const ESCAPE_CHARACTER = '\\';

    /**
     * Searches for domain name in rule text and transforms it to punycode if needed.
     *
     * @param ruleText Rule text
     * @returns {string} Transformed rule text
     */
    function getAsciiDomainRule(ruleText) {
        try {
            if (/^[\x00-\x7F]+$/.test(ruleText)) {
                return ruleText;
            }

            let domain = parseRuleDomain(ruleText, true);
            if (!domain) {
                return "";
            }

            //In case of one domain
            return adguard.utils.strings.replaceAll(ruleText, domain, adguard.utils.url.toPunyCode(domain));
        } catch (ex) {
            adguard.console.error("Error getAsciiDomainRule from {0}, cause {1}", ruleText, ex);
            return "";
        }
    }

    /**
     * Searches for domain name in rule text.
     *
     * @param ruleText Rule text
     * @param parseOptions Flag to parse rule options
     * @returns {?string} domain name
     */
    function parseRuleDomain(ruleText, parseOptions) {
        try {
            let i;
            const startsWith = ["http://www.", "https://www.", "http://", "https://", "||", "//"];
            const contains = ["/", "^"];
            let startIndex = parseOptions ? -1 : 0;

            for (i = 0; i < startsWith.length; i++) {
                const start = startsWith[i];
                if (adguard.utils.strings.startWith(ruleText, start)) {
                    startIndex = start.length;
                    break;
                }
            }

            if (parseOptions) {
                //exclusive for domain
                const exceptRule = "domain=";
                const domainIndex = ruleText.indexOf(exceptRule);
                if (domainIndex > -1 && ruleText.indexOf("$") > -1) {
                    startIndex = domainIndex + exceptRule.length;
                }

                if (startIndex === -1) {
                    //Domain is not found in rule options, so we continue a normal way
                    startIndex = 0;
                }
            }

            let symbolIndex = -1;
            for (i = 0; i < contains.length; i++) {
                const contain = contains[i];
                const index = ruleText.indexOf(contain, startIndex);
                if (index >= 0) {
                    symbolIndex = index;
                    break;
                }
            }

            return symbolIndex === -1 ? ruleText.substring(startIndex) : ruleText.substring(startIndex, symbolIndex);
        } catch (ex) {
            adguard.console.error("Error parsing domain from {0}, cause {1}", ruleText, ex);
            return null;
        }
    }

    /**
     * Parse rule text
     * @param ruleText
     * @returns {{urlRuleText: *, options: *, whiteListRule: *}}
     * @private
     */
    function parseRuleText(ruleText) {

        let urlRuleText = ruleText;
        let whiteListRule = null;
        let options = null;

        let startIndex = 0;

        if (adguard.utils.strings.startWith(urlRuleText, api.FilterRule.MASK_WHITE_LIST)) {
            startIndex = api.FilterRule.MASK_WHITE_LIST.length;
            urlRuleText = urlRuleText.substring(startIndex);
            whiteListRule = true;
        }

        let parseOptions = true;
        /**
         * https://github.com/AdguardTeam/AdguardBrowserExtension/issues/517
         * regexp rule may contain dollar sign which also is options delimiter
         */
        // Added check for replacement rule, because maybe problem with rules for example /.*/$replace=/hello/bug/

        if (adguard.utils.strings.startWith(urlRuleText, api.UrlFilterRule.MASK_REGEX_RULE) &&
            adguard.utils.strings.endsWith(urlRuleText, api.UrlFilterRule.MASK_REGEX_RULE) &&
            !adguard.utils.strings.contains(urlRuleText, api.UrlFilterRule.REPLACE_OPTION + '=')) {

            parseOptions = false;
        }

        if (parseOptions) {
            let foundEscaped = false;
            // Start looking from the prev to the last symbol
            // If dollar sign is the last symbol - we simply ignore it.
            for (let i = (ruleText.length - 2); i >= startIndex; i--) {
                const c = ruleText.charAt(i);
                if (c === UrlFilterRule.OPTIONS_DELIMITER) {
                    if (i > 0 && ruleText.charAt(i - 1) === ESCAPE_CHARACTER) {
                        foundEscaped = true;
                    } else {
                        urlRuleText = ruleText.substring(startIndex, i);
                        options = ruleText.substring(i + 1);

                        if (foundEscaped) {
                            // Find and replace escaped options delimiter
                            options = options.replace(ESCAPE_CHARACTER + UrlFilterRule.OPTIONS_DELIMITER, UrlFilterRule.OPTIONS_DELIMITER);
                        }

                        // Options delimiter was found, doing nothing
                        break;
                    }
                }
            }
        }

        // Transform to punycode
        urlRuleText = getAsciiDomainRule(urlRuleText);

        return {
            urlRuleText: urlRuleText,
            options: options,
            whiteListRule: whiteListRule
        };
    }

    /**
     * Validates CSP rule
     * @param rule Rule with $CSP modifier
     */
    function validateCspRule(rule) {

        /**
         * https://github.com/AdguardTeam/AdguardBrowserExtension/issues/685
         * CSP directive may be empty in case of whitelist rule, it means to disable all $csp rules matching the whitelist rule
         */
        if (!rule.whiteListRule && !rule.cspDirective) {
            throw 'Invalid $CSP rule: CSP directive must not be empty';
        }

        if (rule.cspDirective) {

            /**
             * https://github.com/AdguardTeam/AdguardBrowserExtension/issues/685#issue-228287090
             * Forbids report-to and report-uri directives
             */
            const cspDirective = rule.cspDirective.toLowerCase();
            if (cspDirective.indexOf('report-uri') >= 0 ||
                cspDirective.indexOf('report-to') >= 0) {

                throw 'Forbidden CSP directive: ' + cspDirective;
            }
        }
    }

    /**
     * Check if the specified options mask contains the given option
     * @param options Options
     * @param option Option
     */
    function containsOption(options, option) {
        return options !== null &&
            (options & option) === option; // jshint ignore:line
    }

    /**
     * Rule for blocking requests to URLs.
     * Read here for details:
     * http://adguard.com/en/filterrules.html#baseRules
     */
    let UrlFilterRule = function (rule) {

        api.FilterRule.call(this, rule);

        // Content type masks
        this.permittedContentType = UrlFilterRule.contentTypes.ALL;
        this.restrictedContentType = 0;
        // Rule options
        this.enabledOptions = null;
        this.disabledOptions = null;

        // Parse rule text
        const parseResult = parseRuleText(rule);

        // Exception rule flag
        if (parseResult.whiteListRule) {
            this.whiteListRule = true;
        }

        // Load options
        if (parseResult.options) {
            this._loadOptions(parseResult.options);
        }

        const urlRuleText = parseResult.urlRuleText;

        this.isRegexRule = adguard.utils.strings.startWith(urlRuleText, UrlFilterRule.MASK_REGEX_RULE) &&
            adguard.utils.strings.endsWith(urlRuleText, UrlFilterRule.MASK_REGEX_RULE) ||
            urlRuleText === '' ||
            urlRuleText === UrlFilterRule.MASK_ANY_SYMBOL;

        if (this.isRegexRule) {
            this.urlRegExpSource = urlRuleText.substring(UrlFilterRule.MASK_REGEX_RULE.length, urlRuleText.length - UrlFilterRule.MASK_REGEX_RULE.length);

            // Pre compile regex rules
            let regexp = this.getUrlRegExp();
            if (!regexp) {
                throw 'Illegal regexp rule';
            }

            if (UrlFilterRule.REGEXP_ANY_SYMBOL === regexp && !this.hasPermittedDomains()) {
                // Rule matches everything and does not have any domain restriction
                throw ("Too wide basic rule: " + urlRuleText);
            }
        }

        if (this.isCspRule()) {
            validateCspRule(this);
        }
    };

    UrlFilterRule.prototype = Object.create(api.FilterRule.prototype);

    // Lazy regexp source create
    UrlFilterRule.prototype.getUrlRegExpSource = function () {
        if (!this.urlRegExpSource) {
            //parse rule text
            const parseResult = parseRuleText(this.ruleText);
            // Creating regex source
            this.urlRegExpSource = api.SimpleRegex.createRegexText(parseResult.urlRuleText);
        }
        return this.urlRegExpSource;
    };

    /**
     * $replace modifier.
     * Learn more about this modifier syntax here:
     * https://github.com/AdguardTeam/AdguardForWindows/issues/591
     *
     * @return Parsed $replace modifier
     */
    UrlFilterRule.prototype.getReplace = function () {
        return this.replace;
    };

    /**
     * Lazy regexp creation
     *
     * @return {RegExp}
     */
    UrlFilterRule.prototype.getUrlRegExp = function () {
        //check already compiled but not successful
        if (this.wrongUrlRegExp) {
            return null;
        }

        if (!this.urlRegExp) {
            let urlRegExpSource = this.getUrlRegExpSource();
            try {
                if (!urlRegExpSource || UrlFilterRule.MASK_ANY_SYMBOL === urlRegExpSource) {
                    // Match any symbol
                    this.urlRegExp = new RegExp(UrlFilterRule.REGEXP_ANY_SYMBOL);
                } else {
                    this.urlRegExp = new RegExp(urlRegExpSource, this.isMatchCase() ? "" : "i");
                }

                delete this.urlRegExpSource;
            } catch (ex) {
                //malformed regexp
                adguard.console.error('Error create regexp from {0}', urlRegExpSource);
                this.wrongUrlRegExp = true;
                return null;
            }
        }

        return this.urlRegExp;
    };

    /**
     * Lazy getter for url rule text ( uses in safari content blocker)
     */
    UrlFilterRule.prototype.getUrlRuleText = function () {
        if (!this.urlRuleText) {
            this.urlRuleText = parseRuleText(this.ruleText).urlRuleText;
        }
        return this.urlRuleText;
    };

    /**
     * There are two exceptions for domain permitting in url blocking rules.
     * White list rules must fire when request has no referrer.
     * Also rules without third-party option should fire.
     *
     * @param domainName
     * @returns {*}
     */
    UrlFilterRule.prototype.isPermitted = function (domainName) {

        if (!domainName) {
            let hasPermittedDomains = this.hasPermittedDomains();

            // For white list rules to fire when request has no referrer
            if (this.whiteListRule && !hasPermittedDomains) {
                return true;
            }

            // Also firing rules when there's no constraint on ThirdParty-FirstParty type
            if (!this.isCheckThirdParty() && !hasPermittedDomains) {
                return true;
            }
        }

        return api.FilterRule.prototype.isPermitted.call(this, domainName);
    };

    /**
     * Checks if request matches rule's content type constraints
     *
     * @param contentTypeMask Request content types mask
     * @return {boolean} true if request matches this content type
     */
    UrlFilterRule.prototype.checkContentTypeMask = function (contentTypeMask) {

        if (this.permittedContentType === UrlFilterRule.contentTypes.ALL &&
            this.restrictedContentType === 0) {
            // Rule does not contain any constraint
            return true;
        }

        // Checking that either all content types are permitted or request content type is in the permitted list
        const matchesPermitted = this.permittedContentType === UrlFilterRule.contentTypes.ALL ||
            (this.permittedContentType & contentTypeMask) !== 0; // jshint ignore:line

        // Checking that either no content types are restricted or request content type is not in the restricted list
        const notMatchesRestricted = this.restrictedContentType === 0 ||
            (this.restrictedContentType & contentTypeMask) === 0; // jshint ignore:line

        return matchesPermitted && notMatchesRestricted;
    };

    /**
     * Checks if specified option is enabled
     *
     * @param option Option to check
     * @return {boolean} true if enabled
     */
    UrlFilterRule.prototype.isOptionEnabled = function (option) {
        return containsOption(this.enabledOptions, option);
    };

    /**
     * Checks if specified option is disabled
     *
     * @param option Option to check
     * @return {boolean} true if disabled
     */
    UrlFilterRule.prototype.isOptionDisabled = function (option) {
        return containsOption(this.disabledOptions, option);
    };

    /**
     * True if this filter should check if request is third- or first-party.
     *
     * @return {boolean} True if we should check third party property
     */
    UrlFilterRule.prototype.isCheckThirdParty = function () {
        return this.isOptionEnabled(UrlFilterRule.options.THIRD_PARTY) ||
            this.isOptionDisabled(UrlFilterRule.options.THIRD_PARTY);
    };

    /**
     * If true - filter is only applied to requests from
     * a different origin that the currently viewed page.
     *
     * @return {boolean} If true - filter third-party requests only
     */
    UrlFilterRule.prototype.isThirdParty = function () {
        if (this.isOptionEnabled(UrlFilterRule.options.THIRD_PARTY)) {
            return true;
        }
        if (this.isOptionDisabled(UrlFilterRule.options.THIRD_PARTY)) {
            return false;
        }
        return false;
    };

    /**
     * Checks if the specified rule contains all document level options
     * @returns {boolean} If true - contains $jsinject, $elemhide and $urlblock options
     */
    UrlFilterRule.prototype.isDocumentWhiteList = function () {
        return this.isOptionEnabled(UrlFilterRule.options.DOCUMENT_WHITELIST);
    };

    /**
     * If rule is case sensitive returns true
     *
     * @return {boolean} true if rule is case sensitive
     */
    UrlFilterRule.prototype.isMatchCase = function () {
        return this.isOptionEnabled(UrlFilterRule.options.MATCH_CASE);
    };

    /**
     * If BlockPopups is true, than window should be closed
     *
     * @return {boolean} true if window should be closed
     */
    UrlFilterRule.prototype.isBlockPopups = function () {
        return this.isOptionEnabled(UrlFilterRule.options.BLOCK_POPUPS);
    };

    /**
     * @returns {boolean} true if this rule is csp
     */
    UrlFilterRule.prototype.isCspRule = function () {
        return this.isOptionEnabled(UrlFilterRule.options.CSP_RULE);
    };

    /**
     * @returns {boolean} If rule is bad-filter returns true
     */
    UrlFilterRule.prototype.isBadFilter = function () {
        return !!this.badFilter;
    };

    /**
     * Loads rule options
     * @param options Options string
     * @private
     */
    UrlFilterRule.prototype._loadOptions = function (options) {

        const optionsParts = adguard.utils.strings.splitByDelimiterWithEscapeCharacter(options, api.FilterRule.COMA_DELIMITER, ESCAPE_CHARACTER, false);

        for (let i = 0; i < optionsParts.length; i++) {
            const option = optionsParts[i];
            const optionsKeyValue = option.split(api.FilterRule.EQUAL);
            let optionName = optionsKeyValue[0];

            switch (optionName) {
                case UrlFilterRule.DOMAIN_OPTION:
                    if (optionsKeyValue.length > 1) {
                        let domains = optionsKeyValue[1];
                        if (optionsKeyValue.length > 2) {
                            domains = optionsKeyValue.slice(1).join(api.FilterRule.EQUAL);
                        }
                        // Load domain option
                        this.loadDomains(domains);
                    }
                    break;
                case UrlFilterRule.THIRD_PARTY_OPTION:
                    this._setUrlFilterRuleOption(UrlFilterRule.options.THIRD_PARTY, true);
                    break;
                case api.FilterRule.NOT_MARK + UrlFilterRule.THIRD_PARTY_OPTION:
                    this._setUrlFilterRuleOption(UrlFilterRule.options.THIRD_PARTY, false);
                    break;
                case UrlFilterRule.MATCH_CASE_OPTION:
                    this._setUrlFilterRuleOption(UrlFilterRule.options.MATCH_CASE, true);
                    break;
                case UrlFilterRule.IMPORTANT_OPTION:
                    this.isImportant = true;
                    break;
                case api.FilterRule.NOT_MARK + UrlFilterRule.IMPORTANT_OPTION:
                    this.isImportant = false;
                    break;
                case UrlFilterRule.ELEMHIDE_OPTION:
                    this._setUrlFilterRuleOption(UrlFilterRule.options.ELEMHIDE, true);
                    break;
                case UrlFilterRule.GENERICHIDE_OPTION:
                    this._setUrlFilterRuleOption(UrlFilterRule.options.GENERICHIDE, true);
                    break;
                case UrlFilterRule.JSINJECT_OPTION:
                    this._setUrlFilterRuleOption(UrlFilterRule.options.JSINJECT, true);
                    break;
                case UrlFilterRule.CONTENT_OPTION:
                    this._setUrlFilterRuleOption(UrlFilterRule.options.CONTENT, true);
                    break;
                case UrlFilterRule.URLBLOCK_OPTION:
                    this._setUrlFilterRuleOption(UrlFilterRule.options.URLBLOCK, true);
                    break;
                case UrlFilterRule.GENERICBLOCK_OPTION:
                    this._setUrlFilterRuleOption(UrlFilterRule.options.GENERICBLOCK, true);
                    break;
                case UrlFilterRule.DOCUMENT_OPTION:
                    this._setUrlFilterRuleOption(UrlFilterRule.options.DOCUMENT_WHITELIST, true);
                    break;
                case UrlFilterRule.POPUP_OPTION:
                    this._setUrlFilterRuleOption(UrlFilterRule.options.BLOCK_POPUPS, true);
                    break;
                case UrlFilterRule.EMPTY_OPTION:
                    this._setUrlFilterRuleOption(UrlFilterRule.options.EMPTY_RESPONSE, true);
                    break;
                case UrlFilterRule.CSP_OPTION:
                    this._setUrlFilterRuleOption(UrlFilterRule.options.CSP_RULE, true);
                    if (optionsKeyValue.length > 1) {
                        this.cspDirective = optionsKeyValue[1];
                    }
                    break;
                case UrlFilterRule.REPLACE_OPTION:
                    throw 'Unknown option: REPLACE';
                    break;
                case UrlFilterRule.BADFILTER_OPTION:
                    this.badFilter = this.ruleText
                        .replace(UrlFilterRule.OPTIONS_DELIMITER + UrlFilterRule.BADFILTER_OPTION + api.FilterRule.COMA_DELIMITER, UrlFilterRule.OPTIONS_DELIMITER)
                        .replace(api.FilterRule.COMA_DELIMITER + UrlFilterRule.BADFILTER_OPTION, '')
                        .replace(UrlFilterRule.OPTIONS_DELIMITER + UrlFilterRule.BADFILTER_OPTION, '');
                    break;
                default:
                    optionName = optionName.toUpperCase();

                    /**
                     * Convert $object-subrequest modifier to UrlFilterRule.contentTypes.OBJECT_SUBREQUEST
                     */
                    if (optionName === 'OBJECT-SUBREQUEST') {
                        optionName = 'OBJECT_SUBREQUEST';
                    } else if (optionName === '~OBJECT-SUBREQUEST') {
                        optionName = '~OBJECT_SUBREQUEST';
                    }

                    if (optionName in UrlFilterRule.contentTypes) {
                        this._appendPermittedContentType(UrlFilterRule.contentTypes[optionName]);
                    } else if (optionName[0] === api.FilterRule.NOT_MARK && optionName.substring(1) in UrlFilterRule.contentTypes) {
                        this._appendRestrictedContentType(UrlFilterRule.contentTypes[optionName.substring(1)]);
                    } else if (optionName in UrlFilterRule.ignoreOptions) {
                        // Ignore others
                    } else {
                        throw 'Unknown option: ' + optionName;
                    }
            }
        }

        // Rules of this types can be applied to documents only
        // $jsinject, $elemhide, $urlblock, $genericblock, $generichide and $content for whitelist rules.
        // $popup - for url blocking
        if (this.isOptionEnabled(UrlFilterRule.options.JSINJECT) ||
            this.isOptionEnabled(UrlFilterRule.options.ELEMHIDE) ||
            this.isOptionEnabled(UrlFilterRule.options.CONTENT) ||
            this.isOptionEnabled(UrlFilterRule.options.URLBLOCK) ||
            this.isOptionEnabled(UrlFilterRule.options.BLOCK_POPUPS) ||
            this.isOptionEnabled(UrlFilterRule.options.GENERICBLOCK) ||
            this.isOptionEnabled(UrlFilterRule.options.GENERICHIDE)) {

            this.permittedContentType = UrlFilterRule.contentTypes.DOCUMENT;
        }
    };

    /**
     * Appends new content type value to permitted list (depending on the current permitted content types)
     *
     * @param contentType Content type to append
     */
    UrlFilterRule.prototype._appendPermittedContentType = function (contentType) {
        if (this.permittedContentType === UrlFilterRule.contentTypes.ALL) {
            this.permittedContentType = contentType;
        } else {
            this.permittedContentType |= contentType; // jshint ignore:line
        }
    };

    /**
     * Appends new content type to restricted list (depending on the current restricted content types)
     *
     * @param contentType Content type to append
     */
    UrlFilterRule.prototype._appendRestrictedContentType = function (contentType) {
        if (this.restrictedContentType === 0) {
            this.restrictedContentType = contentType;
        } else {
            this.restrictedContentType |= contentType; // jshint ignore:line
        }
    };

    /**
     * Sets UrlFilterRuleOption
     *
     * @param option  Option
     * @param enabled Enabled or not
     */
    UrlFilterRule.prototype._setUrlFilterRuleOption = function (option, enabled) {

        if (enabled) {

            if ((this.whiteListRule && containsOption(UrlFilterRule.options.BLACKLIST_OPTIONS, option)) ||
                !this.whiteListRule && containsOption(UrlFilterRule.options.WHITELIST_OPTIONS, option)) {

                throw option + ' cannot be applied to this type of rule';
            }

            if (this.enabledOptions === null) {
                this.enabledOptions = option;
            } else {
                this.enabledOptions |= option; // jshint ignore:line
            }
        } else {
            if (this.disabledOptions === null) {
                this.disabledOptions = option;
            } else {
                this.disabledOptions |= option; // jshint ignore:line
            }
        }
    };

    UrlFilterRule.OPTIONS_DELIMITER = "$";
    UrlFilterRule.DOMAIN_OPTION = "domain";
    UrlFilterRule.THIRD_PARTY_OPTION = "third-party";
    UrlFilterRule.MATCH_CASE_OPTION = "match-case";
    UrlFilterRule.DOCUMENT_OPTION = "document";
    UrlFilterRule.ELEMHIDE_OPTION = "elemhide";
    UrlFilterRule.GENERICHIDE_OPTION = "generichide";
    UrlFilterRule.URLBLOCK_OPTION = "urlblock";
    UrlFilterRule.GENERICBLOCK_OPTION = "genericblock";
    UrlFilterRule.JSINJECT_OPTION = "jsinject";
    UrlFilterRule.CONTENT_OPTION = "content";
    UrlFilterRule.POPUP_OPTION = "popup";
    UrlFilterRule.IMPORTANT_OPTION = "important";
    UrlFilterRule.MASK_REGEX_RULE = "/";
    UrlFilterRule.MASK_ANY_SYMBOL = "*";
    UrlFilterRule.REGEXP_ANY_SYMBOL = ".*";
    UrlFilterRule.EMPTY_OPTION = "empty";
    UrlFilterRule.REPLACE_OPTION = "replace"; // Extension doesn't support replace rules, $replace option is here only for correctly parsing
    UrlFilterRule.CSP_OPTION = "csp";
    UrlFilterRule.BADFILTER_OPTION = "badfilter";

    UrlFilterRule.contentTypes = {

        // jshint ignore:start
        OTHER: 1 << 0,
        SCRIPT: 1 << 1,
        IMAGE: 1 << 2,
        STYLESHEET: 1 << 3,
        OBJECT: 1 << 4,
        SUBDOCUMENT: 1 << 5,
        XMLHTTPREQUEST: 1 << 6,
        OBJECT_SUBREQUEST: 1 << 7,
        MEDIA: 1 << 8,
        FONT: 1 << 9,
        WEBSOCKET: 1 << 10,
        WEBRTC: 1 << 11,
        DOCUMENT: 1 << 12,
        // jshint ignore:end
    };

    // https://code.google.com/p/chromium/issues/detail?id=410382
    UrlFilterRule.contentTypes.OBJECT_SUBREQUEST = UrlFilterRule.contentTypes.OBJECT;

    UrlFilterRule.contentTypes.ALL = 0;
    for (let key in UrlFilterRule.contentTypes) {
        if (UrlFilterRule.contentTypes.hasOwnProperty(key)) {
            UrlFilterRule.contentTypes.ALL |= UrlFilterRule.contentTypes[key]; // jshint ignore:line
        }
    }

    UrlFilterRule.options = {

        // jshint ignore:start

        /**
         * $elemhide modifier.
         * it makes sense to use this parameter for exceptions only.
         * It prohibits element hiding rules on pages affected by the current rule.
         * Element hiding rules will be described below.
         */
        ELEMHIDE: 1 << 0,

        /**
         * limitation on third-party and own requests.
         * If the third-party parameter is used, the rule is applied only to requests
         * coming from external sources. Similarly, ~third-party restricts the rule
         * to requests from the same source that the page comes from. Let’s use an example.
         * The ||domain.com$third-party rule is applied to all sites, except domain.com
         * itself. If we rewrite it as ||domain.com$~third-party, it will be applied
         * only to domain.com, but will not work on other sites.
         */
        THIRD_PARTY: 1 << 1,

        /**
         * If this option is enabled, Adguard won't apply generic CSS rules to the web page.
         */
        GENERICHIDE: 1 << 2,

        /**
         * If this option is enabled, Adguard won't apply generic UrlFilter rules to the web page.
         */
        GENERICBLOCK: 1 << 3,

        /**
         * it makes sense to use this parameter for exceptions only.
         * It prohibits the injection of javascript code to web pages.
         * Javascript code is added for blocking banners by size and for
         * the proper operation of Adguard Assistant
         */
        JSINJECT: 1 << 4,

        /**
         * It makes sense to use this parameter for exceptions only.
         * It prohibits the blocking of requests from pages
         * affected by the current rule.
         */
        URLBLOCK: 1 << 5,  // This attribute is only for exception rules. If true - do not use urlblocking rules for urls where referrer satisfies this rule.

        /**
         * it makes sense to use this parameter for exceptions only.
         * It prohibits HTML filtration rules on pages affected by the current rule.
         * HTML filtration rules will be described below.
         */
        CONTENT: 1 << 6,

        /**
         * For any address matching a&nbsp;blocking rule with this option
         * Adguard will try to&nbsp;automatically close the browser tab.
         */
        BLOCK_POPUPS: 1 << 7,

        /**
         * For any address matching blocking rule with this option
         * Adguard will return internal redirect response (307)
         */
        EMPTY_RESPONSE: 1 << 8,

        /**
         * defines a rule applied only to addresses with exact letter case matches.
         * For example, /BannerAd.gif$match-case will block http://example.com/BannerAd.gif,
         * but not http://example.com/bannerad.gif.
         * By default, the letter case is not matched.
         */
        MATCH_CASE: 1 << 9,

        /**
         * defines a CSP rule
         * For example, ||xpanama.net^$third-party,csp=connect-src 'none'
         */
        CSP_RULE: 1 << 10

        // jshint ignore:end
    };

    /**
     * These options can be applied to whitelist rules only
     */
    UrlFilterRule.options.WHITELIST_OPTIONS =
        UrlFilterRule.options.ELEMHIDE | UrlFilterRule.options.JSINJECT | UrlFilterRule.options.CONTENT | UrlFilterRule.options.GENERICHIDE | UrlFilterRule.options.GENERICBLOCK; // jshint ignore:line

    /**
     * These options can be applied to blacklist rules only
     */
    UrlFilterRule.options.BLACKLIST_OPTIONS = UrlFilterRule.options.EMPTY_RESPONSE;

    /**
     * These options define a document whitelisted rule
     */
    UrlFilterRule.options.DOCUMENT_WHITELIST =
        UrlFilterRule.options.ELEMHIDE | UrlFilterRule.options.URLBLOCK | UrlFilterRule.options.JSINJECT | UrlFilterRule.options.CONTENT; // jshint ignore:line

    UrlFilterRule.ignoreOptions = {
        // Deprecated modifiers
        'BACKGROUND': true,
        '~BACKGROUND': true,
        // Specific to desktop version (can be ignored)
        'EXTENSION': true,
        '~EXTENSION': true,
        // Unused modifiers
        'COLLAPSE': true,
        '~COLLAPSE': true,
        '~DOCUMENT': true
    };

    api.UrlFilterRule = UrlFilterRule;

})(adguard, adguard.rules);
/** end of url-filter-rule.js */
/** start of script-filter-rule.js */
(function (adguard, api) {

    'use strict';

    /**
     * JS injection rule:
     * http://adguard.com/en/filterrules.html#javascriptInjection
     */
    const ScriptFilterRule = function (rule) {

        api.FilterRule.call(this, rule);

        this.script = null;
        this.whiteListRule = adguard.utils.strings.contains(rule, api.FilterRule.MASK_SCRIPT_EXCEPTION_RULE);
        const mask = this.whiteListRule ? api.FilterRule.MASK_SCRIPT_EXCEPTION_RULE : api.FilterRule.MASK_SCRIPT_RULE;

        const indexOfMask = rule.indexOf(mask);
        if (indexOfMask > 0) {
            // domains are specified, parsing
            const domains = rule.substring(0, indexOfMask);
            this.loadDomains(domains);
        }

        this.script = rule.substring(indexOfMask + mask.length);
    };

    ScriptFilterRule.prototype = Object.create(api.FilterRule.prototype);

    /**
     * All content rules markers start with this character
     */
    ScriptFilterRule.RULE_MARKER_FIRST_CHAR = '#';

    /**
     * Content rule markers
     */
    ScriptFilterRule.RULE_MARKERS = [
        api.FilterRule.MASK_SCRIPT_EXCEPTION_RULE,
        api.FilterRule.MASK_SCRIPT_RULE
    ];

    api.ScriptFilterRule = ScriptFilterRule;

})(adguard, adguard.rules);
/** end of script-filter-rule.js */
/** start of scriptlet-rule.js */
(function (adguard, api) {
    const stringUtils = adguard.utils.strings;

    /**
     * AdGuard scriptlet rule mask
     */
    const ADG_SCRIPTLET_MASK = '//scriptlet';

    /**
     * Helper to accumulate an array of strings char by char
     */
    function wordSaver() {
        let str = '';
        let strs = [];
        const saveSymb = (s) => str += s;
        const saveStr = () => {
            strs.push(str);
            str = '';
        };
        const getAll = () => [...strs];
        return { saveSymb, saveStr, getAll };
    };

    /**
     * Iterate over iterable argument and evaluate current state with transitions
     * @param {string} init first transition name
     * @param {Array|Collection|string} iterable
     * @param {Object} transitions transtion functions
     * @param {any} args arguments which should be passed to transition functions
     */
    function iterateWithTransitions(iterable, transitions, init, args) {
        let state = init || Object.keys(transitions)[0];
        for (let i = 0; i < iterable.length; i++) {
            state = transitions[state](iterable, i, args);
        }
        return state;
    }

    /**
     * Parse and validate scriptlet rule
     * @param {*} ruleText
     * @returns {{name: string, args: Array<string>}}
     */
    function parseRule(ruleText) {
        ruleText = stringUtils.substringAfter(ruleText, ADG_SCRIPTLET_MASK);
        /**
         * Transition names
         */
        const TRANSITION = {
            OPENED: 'opened',
            PARAM: 'param',
            CLOSED: 'closed',
        };

        /**
         * Transition function: the current index position in start, end or between params
         * @param {string} rule
         * @param {number} index
         * @param {Object} Object
         * @property {Object} Object.sep contains prop symb with current separator char
         */
        const opened = (rule, index, { sep }) => {
            const char = rule[index];
            switch (char) {
                case ' ':
                case '(':
                case ',':
                    return TRANSITION.OPENED;
                case '\'':
                case '"':
                    sep.symb = char;
                    return TRANSITION.PARAM
                case ')':
                    return index === rule.length - 1
                        ? TRANSITION.CLOSED
                        : TRANSITION.OPENED;
            };
        };
        /**
         * Transition function: the current index position inside param
         * @param {string} rule
         * @param {number} index
         * @param {Object} Object
         * @property {Object} Object.sep contains prop `symb` with current separator char
         * @property {Object} Object.saver helper which allow to save strings by car by char
         */
        const param = (rule, index, { saver, sep }) => {
            const char = rule[index];
            switch (char) {
                case '\'':
                case '"':
                    const before = rule[index - 1];
                    if (char === sep.symb && before !== '\\') {
                        sep.symb = null;
                        saver.saveStr();
                        return TRANSITION.OPENED;
                    }
                default:
                    saver.saveSymb(char);
                    return TRANSITION.PARAM;
            }
        };
        const transitions = {
            [TRANSITION.OPENED]: opened,
            [TRANSITION.PARAM]: param,
            [TRANSITION.CLOSED]: () => { }
        };
        const sep = { symb: null };
        const saver = wordSaver();
        const state = iterateWithTransitions(ruleText, transitions, TRANSITION.OPENED, { sep, saver });
        if (state !== 'closed') {
            throw new Error(`Invalid scriptlet rule ${ruleText}`);
        }

        const args = saver.getAll();
        return {
            name: args[0],
            args: args.slice(1)
        };
    }


    /**
     * JS Scriplet rule constructor
     * @constructor ScriptletRule
     * @property {string} ruleText
     */
    function ScriptletRule(ruleText) {
        this.ruleText = ruleText;
        this.whiteListRule = ruleText.includes(api.FilterRule.MASK_SCRIPT_EXCEPTION_RULE);
        const mask = this.whiteListRule
            ? api.FilterRule.MASK_SCRIPT_EXCEPTION_RULE
            : api.FilterRule.MASK_SCRIPT_RULE;
        const domain = adguard.utils.strings.substringBefore(ruleText, mask);
        domain && this.loadDomains(domain);
        const parseResult = parseRule(ruleText);
        this.scriptlet = parseResult.name;
        this.scriptletParam =  JSON.stringify(parseResult);
    };

    /**
     * Check is AdGuard scriptlet rule
     * @static
     */
    ScriptletRule.isAdguardScriptletRule = rule => rule.indexOf(ADG_SCRIPTLET_MASK) > -1;

    /**
     * Extends BaseFilterRule
     */
    ScriptletRule.prototype = Object.create(api.FilterRule.prototype);
    ScriptletRule.prototype.constructor = ScriptletRule;

    /**
     * @static ScriptletRule
     */
    api.ScriptletRule = ScriptletRule;

})(adguard, adguard.rules);
/** end of scriptlet-rule.js */
/** start of composite-rule.js */
(function (api) {

    /**
     * This rule may contain a list of rules generated from one complex ruleText
     * @constructor
     *
     * @example
     * input
     * ABP snippet rule
     * `example.org#$#hide-if-has-and-matches-style someSelector; hide-if-contains someSelector2`
     *
     * output
     * Adguard scriptlet rules
     * `example.org#%#//scriptlet("hide-if-has-and-matches-style", "someSelector")`
     * `example.org#%#//scriptlet("hide-if-contains", "someSelector2")`
     *
     */
    function CompositeRule(ruleText, rules) {
        this.ruleText = ruleText;
        this.rules = rules;
    };

    /**
     * @static ScriptletRule
     */
    api.CompositeRule = CompositeRule;

})(adguard.rules);
/** end of composite-rule.js */
/** start of converter.js */
/**
 * Converts URLs in the AdGuard format to the format supported by Safari
 * https://webkit.org/blog/3476/content-blockers-first-look/
 */
const SafariContentBlockerConverter = (() =>{

    /**
     * Safari content blocking format rules converter.
     */
    const CONVERTER_VERSION = '4.2.4';
    // Max number of CSS selectors per rule (look at compactCssRules function)
    const MAX_SELECTORS_PER_WIDE_RULE = 250;

    /**
     * It's important to mention why do we need these regular expressions.
     * The thing is that on iOS it is crucial to use regexes as simple as possible.
     * Otherwise, Safari takes too much memory on compiling a content blocker, and iOS simply kills the process.
     *
     * Angry users are here:
     * https://github.com/AdguardTeam/AdguardForiOS/issues/550
     */
    const ANY_URL_TEMPLATES = ['||*', '', '*', '|*'];
    const URL_FILTER_ANY_URL = "^[htpsw]+:\\/\\/";
    const URL_FILTER_WS_ANY_URL = "^wss?:\\/\\/";
    /**
     * Using .* for the css-display-none rules trigger.url-filter.
     * Please note, that this is important to use ".*" for this kind of rules, otherwise performance is degraded:
     * https://github.com/AdguardTeam/AdguardForiOS/issues/662
     */
    const URL_FILTER_CSS_RULES = ".*";
    const URL_FILTER_SCRIPT_RULES = ".*";
    const URL_FILTER_SCRIPTLET_RULES = ".*";
    /**
     * In some cases URL_FILTER_ANY_URL doesn't work for domain-specific url exceptions
     * https://github.com/AdguardTeam/AdGuardForSafari/issues/285
     */
    const URL_FILTER_URL_RULES_EXCEPTIONS = ".*";

    /**
     * Converter implementation.
     *
     * @type {{convertCssFilterRule, convertUrlFilterRule, isSingleOption}}
     */
    const AGRuleConverter = (() =>{

        /**
         * Parses rule domains to collections
         *
         * @param rule
         * @param included
         * @param excluded
         */
        const parseDomains = (rule, included, excluded) => {
            let domain, domains, iDomains;

            if (rule.permittedDomain) {
                domain = adguard.utils.url.toPunyCode(rule.permittedDomain.toLowerCase());
                included.push(domain);
            } else if (rule.permittedDomains) {
                domains = rule.permittedDomains;
                iDomains = domains.length;
                while (iDomains--) {
                    if (domains[iDomains] !== "") {
                        domain = domains[iDomains];
                        domain = adguard.utils.url.toPunyCode(domain.toLowerCase());
                        included.push(domain);
                    }
                }
            }

            if (rule.restrictedDomain) {
                domain = adguard.utils.url.toPunyCode(rule.restrictedDomain.toLowerCase());
                excluded.push(domain);
            } else if (rule.restrictedDomains) {
                domains = rule.restrictedDomains;
                iDomains = domains.length;
                while (iDomains--) {
                    domain = domains[iDomains];
                    if (domain) {
                        domain = adguard.utils.url.toPunyCode(domain.toLowerCase());
                        excluded.push(domain);
                    }
                }
            }
        };

        /**
         * Adds load-type specification
         *
         * @param trigger
         * @param rule
         */
        const addThirdParty = (trigger, rule) => {
            if (rule.isCheckThirdParty()) {
                trigger["load-type"] = rule.isThirdParty() ? ["third-party"] : ["first-party"];
            }
        };

        /**
         * Adds case-sensitive specification
         *
         * @param trigger
         * @param rule
         */
        const addMatchCase = (trigger, rule) => {
            if (rule.isMatchCase()) {
                trigger["url-filter-is-case-sensitive"] = true;
            }
        };

        /**
         * Writes domains specification
         *
         * @param included
         * @param excluded
         * @param trigger
         */
        const writeDomainOptions = (included, excluded, trigger) => {
            if (included.length > 0 && excluded.length > 0) {
                throw new Error('Safari does not support both permitted and restricted domains');
            }

            if (included.length > 0) {
                trigger["if-domain"] = included;
            }
            if (excluded.length > 0) {
                trigger["unless-domain"] = excluded;
            }
        };

        /**
         * As a limited solution to support wildcard in tld, as there is no support for wildcards in "if-domain" property in CB
         * we are going to use a list of popular domains.
         * https://github.com/AdguardTeam/AdGuardForSafari/issues/248
         *
         * @param domains
         */
        const resolveTopLevelDomainWildcards = (domains) => {
            let arr = [...domains];
            domains.length = 0;
            arr.forEach(d => {
                if (d.endsWith('.*')) {
                    adguard.utils.TOP_LEVEL_DOMAINS_LIST.forEach(tld => {
                        const domain = d.substring(0, d.length - 2);
                        domains.push(`${domain}.${tld}`);
                    });
                } else {
                    domains.push(d);
                }
            });
        };

        /**
         * Adds domains specification
         *
         * @param trigger
         * @param rule
         */
        const addDomainOptions = (trigger, rule) => {
            const included = [];
            const excluded = [];
            parseDomains(rule, included, excluded);
            resolveTopLevelDomainWildcards(included);
            resolveTopLevelDomainWildcards(excluded);
            writeDomainOptions(included, excluded, trigger);
        };

        /**
         * Adds whitelist flag
         *
         * @param rule
         * @param result
         */
        const setWhiteList = (rule, result) => {
            if (rule.whiteListRule && rule.whiteListRule === true) {
                result.action.type = "ignore-previous-rules";
            }
        };

        /**
         * Checks if contentType matches rule's content type constraints
         *
         * @param rule
         * @param contentType
         * @return {boolean}
         */
        const hasContentType = (rule, contentType) => rule.checkContentTypeMask(contentType);

        /**
         * Checks if rule is specified content type
         *
         * @param rule
         * @param contentType
         * @return {boolean}
         */
        const isContentType = (rule, contentType) => rule.permittedContentType === contentType;

        /**
         * If rule has the only one specified option
         *
         * @param rule
         * @param option
         * @return {boolean}
         */
        const isSingleOption = (rule, option) => rule.enabledOptions === option;

        /**
         * Adds resource type specification
         *
         * @param rule
         * @param result
         */
        const addResourceType = (rule, result) => {
            let types = [];

            const contentTypes = adguard.rules.UrlFilterRule.contentTypes;

            if (rule.permittedContentType === contentTypes.ALL &&
                rule.restrictedContentType === 0) {
                // Safari does not support all other default content types, like subdocument etc.
                // So we can use default safari content types instead.
                return;
            }
            if (hasContentType(rule, contentTypes.IMAGE)) {
                types.push("image");
            }
            if (hasContentType(rule, contentTypes.STYLESHEET)) {
                types.push("style-sheet");
            }
            if (hasContentType(rule, contentTypes.SCRIPT)) {
                types.push("script");
            }
            if (hasContentType(rule, contentTypes.MEDIA)) {
                types.push("media");
            }
            if (hasContentType(rule, contentTypes.XMLHTTPREQUEST) ||
                hasContentType(rule, contentTypes.OTHER) ||
                hasContentType(rule, contentTypes.WEBSOCKET)) {
                types.push("raw");
            }
            if (hasContentType(rule, contentTypes.FONT)) {
                types.push("font");
            }
            if (hasContentType(rule, contentTypes.SUBDOCUMENT)) {
                types.push("document");
            }
            if (rule.isBlockPopups()) {
                // Ignore other in case of $popup modifier
                types = ["popup"];
            }

            // Not supported modificators
            if (isContentType(rule, contentTypes.OBJECT)) {
                throw new Error('$object content type is not yet supported');
            }
            if (isContentType(rule, contentTypes.OBJECT_SUBREQUEST)) {
                throw new Error('$object_subrequest content type is not yet supported');
            }
            if (isContentType(rule, contentTypes.WEBRTC)) {
                throw new Error('$webrtc content type is not yet supported');
            }
            if (rule.getReplace()) {
                throw new Error('$replace rules are ignored.');
            }

            if (types.length > 0) {
                result.trigger["resource-type"] = types;
            }

            //TODO: Add restricted content types?
        };

        /**
         * Creates a regular expression that will be used in the trigger["url-filter"].
         * This method transforms
         *
         * @param {*} urlFilterRule UrlFilterRule object
         */
        const createUrlFilterString = urlFilterRule =>{
            const urlRuleText = urlFilterRule.getUrlRuleText();
            const isWebSocket = (urlFilterRule.permittedContentType === adguard.rules.UrlFilterRule.contentTypes.WEBSOCKET);

            // Use a single standard regex for rules that are supposed to match every URL
            if (ANY_URL_TEMPLATES.indexOf(urlRuleText) >= 0) {
                return isWebSocket ? URL_FILTER_WS_ANY_URL : URL_FILTER_ANY_URL;
            }

            if (urlFilterRule.isRegexRule && urlFilterRule.urlRegExp) {
                return urlFilterRule.urlRegExp.source;
            }

            let urlRegExpSource = urlFilterRule.getUrlRegExpSource();

            if (!urlRegExpSource) {
                // Rule with empty regexp
                return URL_FILTER_ANY_URL;
            }

            // Prepending WebSocket protocol to resolve this:
            // https://github.com/AdguardTeam/AdguardBrowserExtension/issues/957
            if (isWebSocket &&
                urlRegExpSource.indexOf("^") !== 0 &&
                urlRegExpSource.indexOf("ws") !== 0) {
                return URL_FILTER_WS_ANY_URL + ".*" + urlRegExpSource;
            }

            return urlRegExpSource;
        };

        /**
         * Parses rule domain from text
         *
         * @param ruleText
         * @return {*}
         */
        const parseRuleDomain = ruleText => {
            try {
                let i;
                const startsWith = ["http://www.", "https://www.", "http://", "https://", "||", "//"];
                const contains = ["/", "^"];
                let startIndex = 0;

                for (i = 0; i < startsWith.length; i++) {
                    const start = startsWith[i];
                    if (adguard.utils.strings.startWith(ruleText, start)) {
                        startIndex = start.length;
                        break;
                    }
                }

                //exclusive for domain
                const exceptRule = "domain=";
                const domainIndex = ruleText.indexOf(exceptRule);
                if (domainIndex > -1 && ruleText.indexOf("$") > -1) {
                    startIndex = domainIndex + exceptRule.length;
                }

                if (startIndex === -1) {
                    return null;
                }

                let symbolIndex = -1;
                for (i = 0; i < contains.length; i++) {
                    const contain = contains[i];
                    const index = ruleText.indexOf(contain, startIndex);
                    if (index >= 0) {
                        symbolIndex = index;
                        break;
                    }
                }

                const domain = symbolIndex === -1 ? ruleText.substring(startIndex) : ruleText.substring(startIndex, symbolIndex);
                const path = symbolIndex === -1 ? null : ruleText.substring(symbolIndex);

                if (!/^[a-zA-Z0-9][a-zA-Z0-9-.]*[a-zA-Z0-9]\.[a-zA-Z-]{2,}$/.test(domain)) {
                    // Not a valid domain name, ignore it
                    return null;
                }

                return {
                    domain: adguard.utils.url.toPunyCode(domain).toLowerCase(),
                    path: path
                };

            } catch (ex) {
                adguard.console.error("Error parsing domain from {0}, cause {1}", ruleText, ex);
                return null;
            }
        };

        /**
         * Converts css filter rule
         *
         * @param rule
         * @return {*}
         */
        const convertCssFilterRule = rule => {
            const result = {
                trigger: {
                    "url-filter": URL_FILTER_CSS_RULES
                    // https://github.com/AdguardTeam/AdguardBrowserExtension/issues/153#issuecomment-263067779
                    //,"resource-type": [ "document" ]
                },
                action: {}
            };

            if (rule.extendedCss || (rule.isInjectRule && rule.isInjectRule === true)) {
                result.action.type = "css";
                result.action.css = rule.cssSelector;
            } else {
                result.action.type = "css-display-none";
                result.action.selector = rule.cssSelector;
            }

            setWhiteList(rule, result);
            addDomainOptions(result.trigger, rule);

            validateCssFilterRule(result);

            return result;
        };

        /**
         * Validates url blocking rule and discards rules considered dangerous or invalid.
         *
         * @param rule
         */
        const validateCssFilterRule = rule => {
            if (rule.action.type === "css" &&
                rule.action.css.includes("url(")) {
                throw new Error("Urls are not allowed in css styles");
            }
        };

        /**
         * Validates url blocking rule and discards rules considered dangerous or invalid.
         */
        const validateUrlBlockingRule = rule => {

            if (rule.action.type === "block" &&
                rule.trigger["resource-type"] &&
                rule.trigger["resource-type"].indexOf("document") >= 0 &&
                !rule.trigger["if-domain"] &&
                (!rule.trigger["load-type"] || rule.trigger["load-type"].indexOf("third-party") === -1)) {
                // Due to https://github.com/AdguardTeam/AdguardBrowserExtension/issues/145
                throw new Error("Document blocking rules are allowed only along with third-party or if-domain modifiers");
            }
        };

        /**
         *
         * @param rule
         * @param result
         */
        const checkWhiteListExceptions = (rule, result) => {

            function isDocumentRule(r) {
                return r.isDocumentWhiteList();
            }

            function isUrlBlockRule(r) {
                return isSingleOption(r, adguard.rules.UrlFilterRule.options.URLBLOCK) ||
                    isSingleOption(r, adguard.rules.UrlFilterRule.options.GENERICBLOCK);
            }

            function isCssExceptionRule(r) {
                return isSingleOption(r, adguard.rules.UrlFilterRule.options.GENERICHIDE) ||
                    isSingleOption(r, adguard.rules.UrlFilterRule.options.ELEMHIDE);
            }

            if (rule.whiteListRule && rule.whiteListRule === true) {

                const documentRule = isDocumentRule(rule);

                if (documentRule || isUrlBlockRule(rule) || isCssExceptionRule(rule)) {
                    if (documentRule) {
                        //http://jira.performix.ru/browse/AG-8715
                        delete result.trigger["resource-type"];
                    }

                    const parseDomainResult = parseRuleDomain(rule.getUrlRuleText());

                    if (parseDomainResult !== null &&
                        parseDomainResult.path !== null &&
                        parseDomainResult.path !== "^" &&
                        parseDomainResult.path !== "/") {
                        // http://jira.performix.ru/browse/AG-8664
                        adguard.console.debug('Whitelist special warning for rule: ' + rule.ruleText);

                        return;
                    }

                    if (parseDomainResult === null || parseDomainResult.domain === null) {
                        adguard.console.debug('Error parse domain from rule: ' + rule.ruleText);
                        return;
                    }

                    const domain = parseDomainResult.domain;

                    const included = [];
                    const excluded = [];

                    included.push(domain);
                    resolveTopLevelDomainWildcards(included);
                    resolveTopLevelDomainWildcards(excluded);
                    writeDomainOptions(included, excluded, result.trigger);

                    result.trigger["url-filter"] = URL_FILTER_URL_RULES_EXCEPTIONS;
                    delete result.trigger["resource-type"];
                }
            }
        };

        /**
         * Safari doesn't support some regular expressions
         *
         * @param regExp
         */
        const validateRegExp = regExp => {
            // Safari doesn't support {digit} in regular expressions
            if (regExp.match(/\{[0-9,]+\}/g)) {
                throw new Error("Safari doesn't support '{digit}' in regular expressions");
            }

            // Safari doesn't support | in regular expressions
            if (regExp.match(/[^\\]+\|+\S*/g)) {
                throw new Error("Safari doesn't support '|' in regular expressions");
            }

            // Safari doesn't support non-ASCII characters in regular expressions
            if (regExp.match(/[^\x00-\x7F]/g)) {
                throw new Error("Safari doesn't support non-ASCII characters in regular expressions");
            }

            // Safari doesn't support negative lookahead (?!...) in regular expressions
            if (regExp.match(/\(\?!.*\)/g)) {
                throw new Error("Safari doesn't support negative lookahead in regular expressions");
            }


            // Safari doesn't support metacharacters in regular expressions
            if (regExp.match(/[^\\]\\[bBdDfnrsStvwW]/g)) {
                throw new Error("Safari doesn't support metacharacters in regular expressions");
            }
        };

        /**
         * Converts url filter rule
         *
         * @param rule
         * @return {*}
         */
        const convertUrlFilterRule = rule => {

            if (rule.isCspRule()) {
                // CSP rules are not supported
                throw new Error("CSP rules are not supported");
            }

            const urlFilter = createUrlFilterString(rule);

            validateRegExp(urlFilter);

            const result = {
                trigger: {
                    "url-filter": urlFilter
                },
                action: {
                    type: "block"
                }
            };

            setWhiteList(rule, result);
            addResourceType(rule, result);
            addThirdParty(result.trigger, rule);
            addMatchCase(result.trigger, rule);
            addDomainOptions(result.trigger, rule);

            // Check whitelist exceptions
            checkWhiteListExceptions(rule, result);

            // Validate the rule
            validateUrlBlockingRule(result);

            return result;
        };

        /**
         * Converts script rule
         *
         * @param rule
         */
        const convertScriptFilterRule = rule => {
            const result = {
                trigger: {
                    "url-filter": URL_FILTER_SCRIPT_RULES
                },
                action: {
                    type: "script",
                    script: rule.script
                }
            };

            setWhiteList(rule, result);
            addDomainOptions(result.trigger, rule);

            return result;
        };

        /**
         * Converts scriptlet rule
         *
         * @param rule
         */
        const convertScriptletRule = rule => {
            const result = {
                trigger: {
                    "url-filter": URL_FILTER_SCRIPTLET_RULES
                },
                action: {
                    type: "scriptlet",
                    scriptlet: rule.scriptlet,
                    scriptletParam: rule.scriptletParam
                }
            };

            setWhiteList(rule, result);
            addDomainOptions(result.trigger, rule);

            return result;
        };

        // Expose AGRuleConverter API
        return {
            convertCssFilterRule,
            convertUrlFilterRule,
            convertScriptFilterRule,
            convertScriptletRule,
            isSingleOption
        }
    })();

    /**
     * Add converter version message
     *
     * @private
     */
    const printVersionMessage = () =>{
        adguard.console.info('Safari Content Blocker Converter v' + CONVERTER_VERSION);
    };

    /**
     * Converts ruleText string to Safari format
     * Used in iOS.
     *
     * @param ruleText string
     * @param errors array
     * @returns {*}
     */
    const convertLine = (ruleText, errors) => {
        try {
            return convertAGRuleToCB(parseAGRule(ruleText, errors));
        } catch (ex) {
            let message = 'Error converting rule from: ' + ruleText + ' cause:\n' + ex;
            message = ruleText + '\r\n' + message + '\r\n';
            adguard.console.debug(message);

            if (errors) {
                errors.push(message);
            }

            return null;
        }
    };

    /**
     * Creates AG rule form text
     *
     * @param ruleText
     * @param errors
     */
    const parseAGRule = (ruleText, errors) => {
        try {
            if (ruleText === null ||
                ruleText === '' ||
                ruleText.indexOf('!') === 0 ||
                ruleText.indexOf(' ') === 0 ||
                ruleText.indexOf(' - ') > 0) {
                return null;
            }

            const agRule = adguard.rules.builder.createRule(ruleText);
            if (agRule === null) {
                throw new Error('Cannot create rule from: ' + ruleText);
            }

            return agRule;
        } catch (ex) {
            let message = 'Error creating rule from: ' + ruleText + ' cause:\n' + ex;
            message = ruleText + '\r\n' + message + '\r\n';
            adguard.console.debug(message);

            if (errors) {
                errors.push(message);
            }

            return null;
        }
    };

    /**
     * Converts rule to Safari format
     *
     * @param rule AG rule object
     * @returns {*}
     */
    const convertAGRuleToCB = rule => {
        if (rule === null) {
            throw new Error('Invalid argument rule');
        }

        let result;
        if (rule instanceof adguard.rules.CssFilterRule) {
            result = AGRuleConverter.convertCssFilterRule(rule);
        } else if (rule instanceof adguard.rules.UrlFilterRule) {
            result = AGRuleConverter.convertUrlFilterRule(rule);
        } else if (rule instanceof adguard.rules.ScriptFilterRule) {
            result = AGRuleConverter.convertScriptFilterRule(rule);
        } else if (rule instanceof adguard.rules.ScriptletRule) {
            result = AGRuleConverter.convertScriptletRule(rule);
        } else {
            throw new Error('Rule is not supported: ' + rule);
        }

        return result;
    };

    /**
     * Converts rule to Safari format
     *
     * @param rule AG rule object
     * @param errors array
     * @returns {*}
     */
    const convertAGRule = (rule, errors) => {
        try {
            return convertAGRuleToCB(rule);
        } catch (ex) {
            const message = 'Error converting rule from: ' +
                ((rule && rule.ruleText) ? rule.ruleText : rule) +
                ' cause:\n' + ex + '\r\n';
            adguard.console.debug(message);

            if (errors) {
                errors.push(message);
            }

            return null;
        }
    };

    /**
     * Converts array to map object
     *
     * @param array
     * @param prop
     * @param prop2
     * @returns {null}
     * @private
     */
    const arrayToMap = (array, prop, prop2) => {
        const map = Object.create(null);
        for (let i = 0; i < array.length; i++) {
            const el = array[i];
            const property = el[prop][prop2];
            if (!(property in map)) {
                map[property] = [];
            }
            map[property].push(el);
        }
        return map;
    };

    /**
     * Updates if-domain and unless-domain fields.
     * Adds wildcard to every rule
     *
     * @private
     */
    const applyDomainWildcards = rules => {
        const addWildcard = array =>{
            if (!array || !array.length) {
                return;
            }

            for (let i = 0; i < array.length; i++) {
                if (!array[i].startsWith('*')) {
                    array[i] = "*" + array[i];
                }
            }
        };

        rules.forEach(rule =>{
            if (rule.trigger) {
                addWildcard(rule.trigger["if-domain"]);
                addWildcard(rule.trigger["unless-domain"]);
            }
        });
    };

    /**
     * Apply exceptions
     * http://jira.performix.ru/browse/AG-8710
     *
     * @param blockingItems
     * @param exceptions
     * @param actionValue action value (selector, script, css)
     * @private
     */
    const applyActionExceptions = (blockingItems, exceptions, actionValue) => {
        adguard.console.info(`Applying ${exceptions.length} ${actionValue} exceptions`);

        /**
         * Adds exception domain to the specified rule.
         * First it checks if rule has if-domain restriction.
         * If so - it may be that domain is redundant.
         */
        const pushExceptionDomain = (domain, rule) => {
            const permittedDomains = rule.trigger["if-domain"];
            if (permittedDomains && permittedDomains.length) {

                // First check that domain is not redundant
                let applicable = permittedDomains.some(permitted => domain.indexOf(permitted) >= 0);

                if (!applicable) {
                    return;
                }
            }

            let ruleRestrictedDomains = rule.trigger["unless-domain"];
            if (!ruleRestrictedDomains) {
                ruleRestrictedDomains = [];
                rule.trigger["unless-domain"] = ruleRestrictedDomains;
            }

            ruleRestrictedDomains.push(domain);
        };

        const rulesMap = arrayToMap(blockingItems, 'action', actionValue);
        const exceptionRulesMap = arrayToMap(exceptions, 'action', actionValue);

        let exceptionsAppliedCount = 0;
        let exceptionsErrorsCount = 0;

        let selectorRules, selectorExceptions;
        const iterator = exc =>{
            selectorRules.forEach(rule =>{
                const exceptionDomains = exc.trigger['if-domain'];
                if (exceptionDomains && exceptionDomains.length > 0) {
                    exceptionDomains.forEach(domain =>{
                        pushExceptionDomain(domain, rule);
                    });
                }
            });

            exceptionsAppliedCount++;
        };

        for (let selector in exceptionRulesMap) { // jshint ignore:line
            selectorRules = rulesMap[selector];
            selectorExceptions = exceptionRulesMap[selector];

            if (selectorRules && selectorExceptions) {
                selectorExceptions.forEach(iterator);
            }
        }

        const result = [];
        blockingItems.forEach(r =>{
            if (r.trigger["if-domain"] && (r.trigger["if-domain"].length > 0) &&
                r.trigger["unless-domain"] && (r.trigger["unless-domain"].length > 0)) {
                adguard.console.debug('Safari does not support permitted and restricted domains in one rule');
                adguard.console.debug(JSON.stringify(r));
                exceptionsErrorsCount++;
            } else {
                result.push(r);
            }
        });

        adguard.console.info(`Exceptions ${actionValue} applied: ${exceptionsAppliedCount}`);
        adguard.console.info(`Exceptions ${actionValue} errors: ${exceptionsErrorsCount}`);
        return result;
    };

    /**
     * Compacts wide CSS rules
     * @param cssBlocking unsorted css elemhide rules
     * @return {*} an object with two properties: cssBlockingWide and cssBlockingDomainSensitive
     */
    const compactCssRules = cssBlocking =>{
        adguard.console.info('Trying to compact ' + cssBlocking.length + ' elemhide rules');

        const cssBlockingWide = [];
        const cssBlockingDomainSensitive = [];
        const cssBlockingGenericDomainSensitive = [];

        let wideSelectors = [];
        const addWideRule = () =>{
            if (!wideSelectors.length) {
                // Nothing to add
                return;
            }

            const rule = {
                trigger: {
                    "url-filter": URL_FILTER_CSS_RULES
                    // https://github.com/AdguardTeam/AdguardBrowserExtension/issues/153#issuecomment-263067779
                    //,"resource-type": [ "document" ]
                },
                action: {
                    type: "css-display-none",
                    selector: wideSelectors.join(', ')
                }
            };
            cssBlockingWide.push(rule);
        };

        for (let i = 0; i < cssBlocking.length; i++) {

            let rule = cssBlocking[i];
            if (rule.trigger['if-domain']) {
                cssBlockingDomainSensitive.push(rule);
            } else if (rule.trigger['unless-domain']) {
                cssBlockingGenericDomainSensitive.push(rule);
            } else {
                wideSelectors.push(rule.action.selector);
                if (wideSelectors.length >= MAX_SELECTORS_PER_WIDE_RULE) {
                    addWideRule();
                    wideSelectors = [];
                }
            }
        }
        addWideRule();

        adguard.console.info('Compacted result: wide=' + cssBlockingWide.length + ' domainSensitive=' + cssBlockingDomainSensitive.length);
        return {
            cssBlockingWide: cssBlockingWide,
            cssBlockingDomainSensitive: cssBlockingDomainSensitive,
            cssBlockingGenericDomainSensitive: cssBlockingGenericDomainSensitive
        };
    };

    /**
     * Creates rule objects from string and parses bad-filter exceptions
     *
     * @param rules
     * @param errors
     * @return {{agRules: Array, badFilterExceptions: Array}}
     */
    const parseAGRules = (rules, errors) => {
        const agRules = [];

        // $badfilter rules
        const badFilterExceptions = [];

        for (let j = 0; j < rules.length; j++) {
            let rule;

            if (rules[j] !== null && rules[j].ruleText) {
                rule = rules[j];
            } else {
                rule = parseAGRule(rules[j], errors);
            }

            if (rule) {
                if (rule.isBadFilter && rule.isBadFilter()) {
                    badFilterExceptions.push(rule.badFilter);
                } else {
                    if (rule instanceof adguard.rules.CompositeRule) {
                        rule.rules.forEach(r => agRules.push(r));
                    } else {
                        agRules.push(rule);
                    }
                }
            }
        }

        return {
            agRules,
            badFilterExceptions
        }
    };

    /**
     * Converts array of rules to JSON
     *
     * @param rules array of strings or AG rules objects
     * @param optimize if true - ignore slow rules
     * @param advancedBlocking if true - convert advanced blocking rules (script and extended css)
     * @return {*} content blocker object with converted rules grouped by type
     */
    const convertLines = (rules, optimize, advancedBlocking) =>{
        adguard.console.info('Converting ' + rules.length + ' rules. Optimize=' + optimize);

        const contentBlocker = {
            // Elemhide rules (##) - wide generic rules
            cssBlockingWide: [],
            // Elemhide rules (##) - generic domain sensitive
            cssBlockingGenericDomainSensitive: [],
            // Generic hide exceptions
            cssBlockingGenericHideExceptions: [],
            // Elemhide rules (##) with domain restrictions
            cssBlockingDomainSensitive: [],
            // Elemhide exceptions ($elemhide)
            cssElemhide: [],
            // Url blocking rules
            urlBlocking: [],
            // Other exceptions
            other: [],
            // $important url blocking rules
            important: [],
            // $important url blocking exceptions
            importantExceptions: [],
            // Document url blocking exceptions
            documentExceptions: [],
            // Script rules (#%#)
            script: [],
            // JsInject exception ($jsinject)
            scriptJsInjectExceptions: [],
            // Extended css rules:
            // Extended css Elemhide rules (##) - wide generic rules
            extendedCssBlockingWide: [],
            // Extended css Elemhide rules (##) - generic domain sensitive
            extendedCssBlockingGenericDomainSensitive: [],
            // Elemhide rules (##) with domain restrictions
            extendedCssBlockingDomainSensitive: [],
            // Scriptlet rules (#%#//scriptlet)
            scriptlets: [],
            // Errors
            errors: []
        };

        // Elemhide rules (##)
        let cssBlocking = [];
        // Elemhide exceptions (#@#)
        const cssExceptions = [];
        // Extended css Elemhide rules (##)
        let extendedCssBlocking = [];
        // Cosmetic css exceptions (#@$#)
        const cosmeticCssExceptions = [];

        // Script rules (#%#)
        let scriptRules = [];
        const scriptExceptionRules = [];

        // Scriptlets
        let scriptlets = [];
        const scriptletsExceptions = [];

        const parsedRules = parseAGRules(rules, contentBlocker.errors);

        let i = 0;
        const len = parsedRules.agRules.length;
        for (; i < len; i++) {
            const agRule = parsedRules.agRules[i];
            if (parsedRules.badFilterExceptions.indexOf(agRule.ruleText) >= 0) {
                // Removed with bad-filter
                adguard.console.info('Rule ' + agRule.ruleText + ' removed with a $badfilter modifier');
                continue;
            }

            const item = convertAGRule(parsedRules.agRules[i], contentBlocker.errors);

            if (item !== null && item !== '') {
                if (item.action === null || item.action === '') {
                    continue;
                }

                if (item.action.type === 'block') {
                    // Url blocking rules
                    if (agRule.isImportant) {
                        contentBlocker.important.push(item);
                    } else {
                        contentBlocker.urlBlocking.push(item);
                    }
                } else if (item.action.type === 'css-display-none') {
                    cssBlocking.push(item);
                } else if (item.action.type === 'css') {
                    extendedCssBlocking.push(item);
                } else if (item.action.type === 'script') {
                    scriptRules.push(item);
                } else if (item.action.type === 'ignore-previous-rules' && agRule.script) {
                    // #@%# rules
                    scriptExceptionRules.push(item);
                } else if (item.action.type === 'scriptlet') {
                    scriptlets.push(item);
                } else if (item.action.type === 'ignore-previous-rules' && agRule.scriptlet) {
                    // #@%#//scriptlet
                    scriptletsExceptions.push(item);
                } else if (item.action.type === 'ignore-previous-rules' &&
                    (item.action.selector && item.action.selector !== '')) {
                    // #@# rules
                    cssExceptions.push(item);
                } else if (item.action.type === 'ignore-previous-rules' &&
                    (item.action.css && item.action.css !== '')) {
                    cosmeticCssExceptions.push(item);
                } else if (item.action.type === 'ignore-previous-rules' &&
                    AGRuleConverter.isSingleOption(agRule, adguard.rules.UrlFilterRule.options.GENERICHIDE)) {
                    contentBlocker.cssBlockingGenericHideExceptions.push(item);
                } else if (item.action.type === 'ignore-previous-rules' &&
                    AGRuleConverter.isSingleOption(agRule, adguard.rules.UrlFilterRule.options.ELEMHIDE)) {
                    // elemhide rules
                    contentBlocker.cssElemhide.push(item);
                } else if (item.action.type === 'ignore-previous-rules' &&
                    AGRuleConverter.isSingleOption(agRule, adguard.rules.UrlFilterRule.options.JSINJECT)) {
                    // jsinject rules
                    contentBlocker.scriptJsInjectExceptions.push(item);
                } else {
                    // other exceptions
                    if (agRule.isImportant) {
                        contentBlocker.importantExceptions.push(item);
                    } else if (agRule.isDocumentWhiteList && agRule.isDocumentWhiteList()) {
                        contentBlocker.documentExceptions.push(item);
                    } else {
                        contentBlocker.other.push(item);
                    }
                }
            }
        }

        // Applying CSS exceptions
        cssBlocking = applyActionExceptions(cssBlocking, cssExceptions, 'selector');
        const cssCompact = compactCssRules(cssBlocking);
        if (!optimize) {
            contentBlocker.cssBlockingWide = cssCompact.cssBlockingWide;
        }
        contentBlocker.cssBlockingGenericDomainSensitive = cssCompact.cssBlockingGenericDomainSensitive;
        contentBlocker.cssBlockingDomainSensitive = cssCompact.cssBlockingDomainSensitive;

        if (advancedBlocking) {
            // Applying CSS exceptions for extended css rules
            extendedCssBlocking = applyActionExceptions(extendedCssBlocking, cssExceptions.concat(cosmeticCssExceptions), 'selector');
            const extendedCssCompact = compactCssRules(extendedCssBlocking);
            if (!optimize) {
                contentBlocker.extendedCssBlockingWide = extendedCssCompact.cssBlockingWide;
            }
            contentBlocker.extendedCssBlockingGenericDomainSensitive = extendedCssCompact.cssBlockingGenericDomainSensitive;
            contentBlocker.extendedCssBlockingDomainSensitive = extendedCssCompact.cssBlockingDomainSensitive;

            // Applying script exceptions
            scriptRules = applyActionExceptions(scriptRules, scriptExceptionRules, 'script');
            contentBlocker.script = scriptRules;

            scriptlets = applyActionExceptions(scriptlets, scriptletsExceptions, 'scriptlet');
            contentBlocker.scriptlets = scriptlets;
        }

        const convertedCount = rules.length - contentBlocker.errors.length;
        let message = 'Rules converted: ' + convertedCount + ' (' + contentBlocker.errors.length + ' errors)';
        message += '\nBasic rules: ' + contentBlocker.urlBlocking.length;
        message += '\nBasic important rules: ' + contentBlocker.important.length;
        message += '\nElemhide rules (wide): ' + contentBlocker.cssBlockingWide.length;
        message += '\nElemhide rules (generic domain sensitive): ' + contentBlocker.cssBlockingGenericDomainSensitive.length;
        message += '\nExceptions Elemhide (wide): ' + contentBlocker.cssBlockingGenericHideExceptions.length;
        message += '\nElemhide rules (domain-sensitive): ' + contentBlocker.cssBlockingDomainSensitive.length;
        message += '\nScript rules: ' + contentBlocker.script.length;
        message += '\nScriptlets rules: ' + contentBlocker.scriptlets.length;
        message += '\nExtended Css Elemhide rules (wide): ' + contentBlocker.extendedCssBlockingWide.length;
        message += '\nExtended Css Elemhide rules (generic domain sensitive): ' + contentBlocker.extendedCssBlockingGenericDomainSensitive.length;
        message += '\nExtended Css Elemhide rules (domain-sensitive): ' + contentBlocker.extendedCssBlockingDomainSensitive.length;
        message += '\nExceptions (elemhide): ' + contentBlocker.cssElemhide.length;
        message += '\nExceptions (important): ' + contentBlocker.importantExceptions.length;
        message += '\nExceptions (document): ' + contentBlocker.documentExceptions.length;
        message += '\nExceptions (jsinject): ' + contentBlocker.scriptJsInjectExceptions.length;
        message += '\nExceptions (other): ' + contentBlocker.other.length;
        adguard.console.info(message);

        return contentBlocker;
    };

    /**
     * Creates result object
     *
     * @param contentBlocker
     * @param limit
     * @param advancedBlocking
     * @return {{totalConvertedCount: Number, convertedCount: Number, errorsCount: Number, overLimit: boolean, converted, advancedBlocking}}
     */
    const createConversionResult = (contentBlocker, limit, advancedBlocking) =>{
        let overLimit = false;
        let converted = [];
        converted = converted.concat(contentBlocker.cssBlockingWide);
        converted = converted.concat(contentBlocker.cssBlockingGenericDomainSensitive);
        converted = converted.concat(contentBlocker.cssBlockingGenericHideExceptions);
        converted = converted.concat(contentBlocker.cssBlockingDomainSensitive);
        converted = converted.concat(contentBlocker.cssElemhide);
        converted = converted.concat(contentBlocker.urlBlocking);
        converted = converted.concat(contentBlocker.other);
        converted = converted.concat(contentBlocker.important);
        converted = converted.concat(contentBlocker.importantExceptions);
        converted = converted.concat(contentBlocker.documentExceptions);

        const convertedLength = converted.length;

        if (limit && limit > 0 && converted.length > limit) {
            const message = '' + limit + ' limit is achieved. Next rules will be ignored.';
            contentBlocker.errors.push(message);
            adguard.console.error(message);
            overLimit = true;
            converted = converted.slice(0, limit);
        }

        applyDomainWildcards(converted);
        adguard.console.info('Content blocker length: ' + converted.length);

        const result = {
            totalConvertedCount: convertedLength,
            convertedCount: converted.length,
            errorsCount: contentBlocker.errors.length,
            overLimit: overLimit,
            converted: JSON.stringify(converted, null, "\t")
        };

        if (advancedBlocking) {
            let advancedBlocker = [];
            advancedBlocker = advancedBlocker.concat(contentBlocker.script);
            advancedBlocker = advancedBlocker.concat(contentBlocker.scriptlets);
            advancedBlocker = advancedBlocker.concat(contentBlocker.scriptJsInjectExceptions);
            advancedBlocker = advancedBlocker.concat(contentBlocker.extendedCssBlockingWide);
            advancedBlocker = advancedBlocker.concat(contentBlocker.extendedCssBlockingGenericDomainSensitive);
            advancedBlocker = advancedBlocker.concat(contentBlocker.cssBlockingGenericHideExceptions);
            advancedBlocker = advancedBlocker.concat(contentBlocker.extendedCssBlockingDomainSensitive);
            advancedBlocker = advancedBlocker.concat(contentBlocker.cssElemhide);
            advancedBlocker = advancedBlocker.concat(contentBlocker.other);
            advancedBlocker = advancedBlocker.concat(contentBlocker.importantExceptions);
            advancedBlocker = advancedBlocker.concat(contentBlocker.documentExceptions);

            applyDomainWildcards(advancedBlocker);
            adguard.console.info('Advanced Blocking length: ' + advancedBlocker.length);

            result.advancedBlocking = JSON.stringify(advancedBlocker, null, "\t");
            result.advancedBlockingConvertedCount = advancedBlocker.length;
        }

        return result;
    };

    /**
     * Converts array of rule texts or AG rules to JSON
     *
     * @param rules array of strings
     * @param limit over that limit rules will be ignored
     * @param optimize if true - "wide" rules will be ignored
     * @param advancedBlocking if true - advanced blocking json will be included
     */
    const convertArray = (rules, limit, optimize, advancedBlocking) =>{
        printVersionMessage();

        try {
            if (rules === null) {
                adguard.console.error('Invalid argument rules');
                return null;
            }

            if (rules.length === 0) {
                adguard.console.info('No rules presented for conversion');
                return null;
            }

            const contentBlocker = convertLines(rules, !!optimize, advancedBlocking);
            return createConversionResult(contentBlocker, limit, advancedBlocking);
        } catch (e) {
            adguard.console.error('Unexpected error: ' + e);
        }
    };

    // Expose SafariContentBlockerConverter API
    return {
        convertArray: convertArray
    }
})();
/** end of converter.js */

/**
 * End of the dependencies content 
 */

    return function (rules, limit, optimize, advancedBlocking) {
        try {
            return SafariContentBlockerConverter.convertArray(rules, limit, optimize, advancedBlocking);
        } catch (ex) {
            console.log('Unexpected error: ' + ex);
        }
    };
})();

// expose to node
if (module && module.exports) {
    module.exports.jsonFromFilters = jsonFromFilters;
}