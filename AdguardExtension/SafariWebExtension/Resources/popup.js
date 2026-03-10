/******/ (() => { // webpackBootstrap
/******/ 	var __webpack_modules__ = ({

/***/ 7757:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

module.exports = __webpack_require__(5666);


/***/ }),

/***/ 9669:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

module.exports = __webpack_require__(1609);

/***/ }),

/***/ 5448:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

"use strict";


var utils = __webpack_require__(4867);
var settle = __webpack_require__(6026);
var cookies = __webpack_require__(4372);
var buildURL = __webpack_require__(5327);
var buildFullPath = __webpack_require__(4097);
var parseHeaders = __webpack_require__(4109);
var isURLSameOrigin = __webpack_require__(7985);
var createError = __webpack_require__(5061);

module.exports = function xhrAdapter(config) {
  return new Promise(function dispatchXhrRequest(resolve, reject) {
    var requestData = config.data;
    var requestHeaders = config.headers;

    if (utils.isFormData(requestData)) {
      delete requestHeaders['Content-Type']; // Let the browser set it
    }

    var request = new XMLHttpRequest();

    // HTTP basic authentication
    if (config.auth) {
      var username = config.auth.username || '';
      var password = config.auth.password ? unescape(encodeURIComponent(config.auth.password)) : '';
      requestHeaders.Authorization = 'Basic ' + btoa(username + ':' + password);
    }

    var fullPath = buildFullPath(config.baseURL, config.url);
    request.open(config.method.toUpperCase(), buildURL(fullPath, config.params, config.paramsSerializer), true);

    // Set the request timeout in MS
    request.timeout = config.timeout;

    // Listen for ready state
    request.onreadystatechange = function handleLoad() {
      if (!request || request.readyState !== 4) {
        return;
      }

      // The request errored out and we didn't get a response, this will be
      // handled by onerror instead
      // With one exception: request that using file: protocol, most browsers
      // will return status as 0 even though it's a successful request
      if (request.status === 0 && !(request.responseURL && request.responseURL.indexOf('file:') === 0)) {
        return;
      }

      // Prepare the response
      var responseHeaders = 'getAllResponseHeaders' in request ? parseHeaders(request.getAllResponseHeaders()) : null;
      var responseData = !config.responseType || config.responseType === 'text' ? request.responseText : request.response;
      var response = {
        data: responseData,
        status: request.status,
        statusText: request.statusText,
        headers: responseHeaders,
        config: config,
        request: request
      };

      settle(resolve, reject, response);

      // Clean up request
      request = null;
    };

    // Handle browser request cancellation (as opposed to a manual cancellation)
    request.onabort = function handleAbort() {
      if (!request) {
        return;
      }

      reject(createError('Request aborted', config, 'ECONNABORTED', request));

      // Clean up request
      request = null;
    };

    // Handle low level network errors
    request.onerror = function handleError() {
      // Real errors are hidden from us by the browser
      // onerror should only fire if it's a network error
      reject(createError('Network Error', config, null, request));

      // Clean up request
      request = null;
    };

    // Handle timeout
    request.ontimeout = function handleTimeout() {
      var timeoutErrorMessage = 'timeout of ' + config.timeout + 'ms exceeded';
      if (config.timeoutErrorMessage) {
        timeoutErrorMessage = config.timeoutErrorMessage;
      }
      reject(createError(timeoutErrorMessage, config, 'ECONNABORTED',
        request));

      // Clean up request
      request = null;
    };

    // Add xsrf header
    // This is only done if running in a standard browser environment.
    // Specifically not if we're in a web worker, or react-native.
    if (utils.isStandardBrowserEnv()) {
      // Add xsrf header
      var xsrfValue = (config.withCredentials || isURLSameOrigin(fullPath)) && config.xsrfCookieName ?
        cookies.read(config.xsrfCookieName) :
        undefined;

      if (xsrfValue) {
        requestHeaders[config.xsrfHeaderName] = xsrfValue;
      }
    }

    // Add headers to the request
    if ('setRequestHeader' in request) {
      utils.forEach(requestHeaders, function setRequestHeader(val, key) {
        if (typeof requestData === 'undefined' && key.toLowerCase() === 'content-type') {
          // Remove Content-Type if data is undefined
          delete requestHeaders[key];
        } else {
          // Otherwise add header to the request
          request.setRequestHeader(key, val);
        }
      });
    }

    // Add withCredentials to request if needed
    if (!utils.isUndefined(config.withCredentials)) {
      request.withCredentials = !!config.withCredentials;
    }

    // Add responseType to request if needed
    if (config.responseType) {
      try {
        request.responseType = config.responseType;
      } catch (e) {
        // Expected DOMException thrown by browsers not compatible XMLHttpRequest Level 2.
        // But, this can be suppressed for 'json' type as it can be parsed by default 'transformResponse' function.
        if (config.responseType !== 'json') {
          throw e;
        }
      }
    }

    // Handle progress if needed
    if (typeof config.onDownloadProgress === 'function') {
      request.addEventListener('progress', config.onDownloadProgress);
    }

    // Not all browsers support upload events
    if (typeof config.onUploadProgress === 'function' && request.upload) {
      request.upload.addEventListener('progress', config.onUploadProgress);
    }

    if (config.cancelToken) {
      // Handle cancellation
      config.cancelToken.promise.then(function onCanceled(cancel) {
        if (!request) {
          return;
        }

        request.abort();
        reject(cancel);
        // Clean up request
        request = null;
      });
    }

    if (!requestData) {
      requestData = null;
    }

    // Send the request
    request.send(requestData);
  });
};


/***/ }),

/***/ 1609:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

"use strict";


var utils = __webpack_require__(4867);
var bind = __webpack_require__(1849);
var Axios = __webpack_require__(321);
var mergeConfig = __webpack_require__(7185);
var defaults = __webpack_require__(5655);

/**
 * Create an instance of Axios
 *
 * @param {Object} defaultConfig The default config for the instance
 * @return {Axios} A new instance of Axios
 */
function createInstance(defaultConfig) {
  var context = new Axios(defaultConfig);
  var instance = bind(Axios.prototype.request, context);

  // Copy axios.prototype to instance
  utils.extend(instance, Axios.prototype, context);

  // Copy context to instance
  utils.extend(instance, context);

  return instance;
}

// Create the default instance to be exported
var axios = createInstance(defaults);

// Expose Axios class to allow class inheritance
axios.Axios = Axios;

// Factory for creating new instances
axios.create = function create(instanceConfig) {
  return createInstance(mergeConfig(axios.defaults, instanceConfig));
};

// Expose Cancel & CancelToken
axios.Cancel = __webpack_require__(5263);
axios.CancelToken = __webpack_require__(4972);
axios.isCancel = __webpack_require__(6502);

// Expose all/spread
axios.all = function all(promises) {
  return Promise.all(promises);
};
axios.spread = __webpack_require__(8713);

// Expose isAxiosError
axios.isAxiosError = __webpack_require__(6268);

module.exports = axios;

// Allow use of default import syntax in TypeScript
module.exports["default"] = axios;


/***/ }),

/***/ 5263:
/***/ ((module) => {

"use strict";


/**
 * A `Cancel` is an object that is thrown when an operation is canceled.
 *
 * @class
 * @param {string=} message The message.
 */
function Cancel(message) {
  this.message = message;
}

Cancel.prototype.toString = function toString() {
  return 'Cancel' + (this.message ? ': ' + this.message : '');
};

Cancel.prototype.__CANCEL__ = true;

module.exports = Cancel;


/***/ }),

/***/ 4972:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

"use strict";


var Cancel = __webpack_require__(5263);

/**
 * A `CancelToken` is an object that can be used to request cancellation of an operation.
 *
 * @class
 * @param {Function} executor The executor function.
 */
function CancelToken(executor) {
  if (typeof executor !== 'function') {
    throw new TypeError('executor must be a function.');
  }

  var resolvePromise;
  this.promise = new Promise(function promiseExecutor(resolve) {
    resolvePromise = resolve;
  });

  var token = this;
  executor(function cancel(message) {
    if (token.reason) {
      // Cancellation has already been requested
      return;
    }

    token.reason = new Cancel(message);
    resolvePromise(token.reason);
  });
}

/**
 * Throws a `Cancel` if cancellation has been requested.
 */
CancelToken.prototype.throwIfRequested = function throwIfRequested() {
  if (this.reason) {
    throw this.reason;
  }
};

/**
 * Returns an object that contains a new `CancelToken` and a function that, when called,
 * cancels the `CancelToken`.
 */
CancelToken.source = function source() {
  var cancel;
  var token = new CancelToken(function executor(c) {
    cancel = c;
  });
  return {
    token: token,
    cancel: cancel
  };
};

module.exports = CancelToken;


/***/ }),

/***/ 6502:
/***/ ((module) => {

"use strict";


module.exports = function isCancel(value) {
  return !!(value && value.__CANCEL__);
};


/***/ }),

/***/ 321:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

"use strict";


var utils = __webpack_require__(4867);
var buildURL = __webpack_require__(5327);
var InterceptorManager = __webpack_require__(782);
var dispatchRequest = __webpack_require__(3572);
var mergeConfig = __webpack_require__(7185);

/**
 * Create a new instance of Axios
 *
 * @param {Object} instanceConfig The default config for the instance
 */
function Axios(instanceConfig) {
  this.defaults = instanceConfig;
  this.interceptors = {
    request: new InterceptorManager(),
    response: new InterceptorManager()
  };
}

/**
 * Dispatch a request
 *
 * @param {Object} config The config specific for this request (merged with this.defaults)
 */
Axios.prototype.request = function request(config) {
  /*eslint no-param-reassign:0*/
  // Allow for axios('example/url'[, config]) a la fetch API
  if (typeof config === 'string') {
    config = arguments[1] || {};
    config.url = arguments[0];
  } else {
    config = config || {};
  }

  config = mergeConfig(this.defaults, config);

  // Set config.method
  if (config.method) {
    config.method = config.method.toLowerCase();
  } else if (this.defaults.method) {
    config.method = this.defaults.method.toLowerCase();
  } else {
    config.method = 'get';
  }

  // Hook up interceptors middleware
  var chain = [dispatchRequest, undefined];
  var promise = Promise.resolve(config);

  this.interceptors.request.forEach(function unshiftRequestInterceptors(interceptor) {
    chain.unshift(interceptor.fulfilled, interceptor.rejected);
  });

  this.interceptors.response.forEach(function pushResponseInterceptors(interceptor) {
    chain.push(interceptor.fulfilled, interceptor.rejected);
  });

  while (chain.length) {
    promise = promise.then(chain.shift(), chain.shift());
  }

  return promise;
};

Axios.prototype.getUri = function getUri(config) {
  config = mergeConfig(this.defaults, config);
  return buildURL(config.url, config.params, config.paramsSerializer).replace(/^\?/, '');
};

// Provide aliases for supported request methods
utils.forEach(['delete', 'get', 'head', 'options'], function forEachMethodNoData(method) {
  /*eslint func-names:0*/
  Axios.prototype[method] = function(url, config) {
    return this.request(mergeConfig(config || {}, {
      method: method,
      url: url,
      data: (config || {}).data
    }));
  };
});

utils.forEach(['post', 'put', 'patch'], function forEachMethodWithData(method) {
  /*eslint func-names:0*/
  Axios.prototype[method] = function(url, data, config) {
    return this.request(mergeConfig(config || {}, {
      method: method,
      url: url,
      data: data
    }));
  };
});

module.exports = Axios;


/***/ }),

/***/ 782:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

"use strict";


var utils = __webpack_require__(4867);

function InterceptorManager() {
  this.handlers = [];
}

/**
 * Add a new interceptor to the stack
 *
 * @param {Function} fulfilled The function to handle `then` for a `Promise`
 * @param {Function} rejected The function to handle `reject` for a `Promise`
 *
 * @return {Number} An ID used to remove interceptor later
 */
InterceptorManager.prototype.use = function use(fulfilled, rejected) {
  this.handlers.push({
    fulfilled: fulfilled,
    rejected: rejected
  });
  return this.handlers.length - 1;
};

/**
 * Remove an interceptor from the stack
 *
 * @param {Number} id The ID that was returned by `use`
 */
InterceptorManager.prototype.eject = function eject(id) {
  if (this.handlers[id]) {
    this.handlers[id] = null;
  }
};

/**
 * Iterate over all the registered interceptors
 *
 * This method is particularly useful for skipping over any
 * interceptors that may have become `null` calling `eject`.
 *
 * @param {Function} fn The function to call for each interceptor
 */
InterceptorManager.prototype.forEach = function forEach(fn) {
  utils.forEach(this.handlers, function forEachHandler(h) {
    if (h !== null) {
      fn(h);
    }
  });
};

module.exports = InterceptorManager;


/***/ }),

/***/ 4097:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

"use strict";


var isAbsoluteURL = __webpack_require__(1793);
var combineURLs = __webpack_require__(7303);

/**
 * Creates a new URL by combining the baseURL with the requestedURL,
 * only when the requestedURL is not already an absolute URL.
 * If the requestURL is absolute, this function returns the requestedURL untouched.
 *
 * @param {string} baseURL The base URL
 * @param {string} requestedURL Absolute or relative URL to combine
 * @returns {string} The combined full path
 */
module.exports = function buildFullPath(baseURL, requestedURL) {
  if (baseURL && !isAbsoluteURL(requestedURL)) {
    return combineURLs(baseURL, requestedURL);
  }
  return requestedURL;
};


/***/ }),

/***/ 5061:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

"use strict";


var enhanceError = __webpack_require__(481);

/**
 * Create an Error with the specified message, config, error code, request and response.
 *
 * @param {string} message The error message.
 * @param {Object} config The config.
 * @param {string} [code] The error code (for example, 'ECONNABORTED').
 * @param {Object} [request] The request.
 * @param {Object} [response] The response.
 * @returns {Error} The created error.
 */
module.exports = function createError(message, config, code, request, response) {
  var error = new Error(message);
  return enhanceError(error, config, code, request, response);
};


/***/ }),

/***/ 3572:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

"use strict";


var utils = __webpack_require__(4867);
var transformData = __webpack_require__(8527);
var isCancel = __webpack_require__(6502);
var defaults = __webpack_require__(5655);

/**
 * Throws a `Cancel` if cancellation has been requested.
 */
function throwIfCancellationRequested(config) {
  if (config.cancelToken) {
    config.cancelToken.throwIfRequested();
  }
}

/**
 * Dispatch a request to the server using the configured adapter.
 *
 * @param {object} config The config that is to be used for the request
 * @returns {Promise} The Promise to be fulfilled
 */
module.exports = function dispatchRequest(config) {
  throwIfCancellationRequested(config);

  // Ensure headers exist
  config.headers = config.headers || {};

  // Transform request data
  config.data = transformData(
    config.data,
    config.headers,
    config.transformRequest
  );

  // Flatten headers
  config.headers = utils.merge(
    config.headers.common || {},
    config.headers[config.method] || {},
    config.headers
  );

  utils.forEach(
    ['delete', 'get', 'head', 'post', 'put', 'patch', 'common'],
    function cleanHeaderConfig(method) {
      delete config.headers[method];
    }
  );

  var adapter = config.adapter || defaults.adapter;

  return adapter(config).then(function onAdapterResolution(response) {
    throwIfCancellationRequested(config);

    // Transform response data
    response.data = transformData(
      response.data,
      response.headers,
      config.transformResponse
    );

    return response;
  }, function onAdapterRejection(reason) {
    if (!isCancel(reason)) {
      throwIfCancellationRequested(config);

      // Transform response data
      if (reason && reason.response) {
        reason.response.data = transformData(
          reason.response.data,
          reason.response.headers,
          config.transformResponse
        );
      }
    }

    return Promise.reject(reason);
  });
};


/***/ }),

/***/ 481:
/***/ ((module) => {

"use strict";


/**
 * Update an Error with the specified config, error code, and response.
 *
 * @param {Error} error The error to update.
 * @param {Object} config The config.
 * @param {string} [code] The error code (for example, 'ECONNABORTED').
 * @param {Object} [request] The request.
 * @param {Object} [response] The response.
 * @returns {Error} The error.
 */
module.exports = function enhanceError(error, config, code, request, response) {
  error.config = config;
  if (code) {
    error.code = code;
  }

  error.request = request;
  error.response = response;
  error.isAxiosError = true;

  error.toJSON = function toJSON() {
    return {
      // Standard
      message: this.message,
      name: this.name,
      // Microsoft
      description: this.description,
      number: this.number,
      // Mozilla
      fileName: this.fileName,
      lineNumber: this.lineNumber,
      columnNumber: this.columnNumber,
      stack: this.stack,
      // Axios
      config: this.config,
      code: this.code
    };
  };
  return error;
};


/***/ }),

/***/ 7185:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

"use strict";


var utils = __webpack_require__(4867);

/**
 * Config-specific merge-function which creates a new config-object
 * by merging two configuration objects together.
 *
 * @param {Object} config1
 * @param {Object} config2
 * @returns {Object} New object resulting from merging config2 to config1
 */
module.exports = function mergeConfig(config1, config2) {
  // eslint-disable-next-line no-param-reassign
  config2 = config2 || {};
  var config = {};

  var valueFromConfig2Keys = ['url', 'method', 'data'];
  var mergeDeepPropertiesKeys = ['headers', 'auth', 'proxy', 'params'];
  var defaultToConfig2Keys = [
    'baseURL', 'transformRequest', 'transformResponse', 'paramsSerializer',
    'timeout', 'timeoutMessage', 'withCredentials', 'adapter', 'responseType', 'xsrfCookieName',
    'xsrfHeaderName', 'onUploadProgress', 'onDownloadProgress', 'decompress',
    'maxContentLength', 'maxBodyLength', 'maxRedirects', 'transport', 'httpAgent',
    'httpsAgent', 'cancelToken', 'socketPath', 'responseEncoding'
  ];
  var directMergeKeys = ['validateStatus'];

  function getMergedValue(target, source) {
    if (utils.isPlainObject(target) && utils.isPlainObject(source)) {
      return utils.merge(target, source);
    } else if (utils.isPlainObject(source)) {
      return utils.merge({}, source);
    } else if (utils.isArray(source)) {
      return source.slice();
    }
    return source;
  }

  function mergeDeepProperties(prop) {
    if (!utils.isUndefined(config2[prop])) {
      config[prop] = getMergedValue(config1[prop], config2[prop]);
    } else if (!utils.isUndefined(config1[prop])) {
      config[prop] = getMergedValue(undefined, config1[prop]);
    }
  }

  utils.forEach(valueFromConfig2Keys, function valueFromConfig2(prop) {
    if (!utils.isUndefined(config2[prop])) {
      config[prop] = getMergedValue(undefined, config2[prop]);
    }
  });

  utils.forEach(mergeDeepPropertiesKeys, mergeDeepProperties);

  utils.forEach(defaultToConfig2Keys, function defaultToConfig2(prop) {
    if (!utils.isUndefined(config2[prop])) {
      config[prop] = getMergedValue(undefined, config2[prop]);
    } else if (!utils.isUndefined(config1[prop])) {
      config[prop] = getMergedValue(undefined, config1[prop]);
    }
  });

  utils.forEach(directMergeKeys, function merge(prop) {
    if (prop in config2) {
      config[prop] = getMergedValue(config1[prop], config2[prop]);
    } else if (prop in config1) {
      config[prop] = getMergedValue(undefined, config1[prop]);
    }
  });

  var axiosKeys = valueFromConfig2Keys
    .concat(mergeDeepPropertiesKeys)
    .concat(defaultToConfig2Keys)
    .concat(directMergeKeys);

  var otherKeys = Object
    .keys(config1)
    .concat(Object.keys(config2))
    .filter(function filterAxiosKeys(key) {
      return axiosKeys.indexOf(key) === -1;
    });

  utils.forEach(otherKeys, mergeDeepProperties);

  return config;
};


/***/ }),

/***/ 6026:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

"use strict";


var createError = __webpack_require__(5061);

/**
 * Resolve or reject a Promise based on response status.
 *
 * @param {Function} resolve A function that resolves the promise.
 * @param {Function} reject A function that rejects the promise.
 * @param {object} response The response.
 */
module.exports = function settle(resolve, reject, response) {
  var validateStatus = response.config.validateStatus;
  if (!response.status || !validateStatus || validateStatus(response.status)) {
    resolve(response);
  } else {
    reject(createError(
      'Request failed with status code ' + response.status,
      response.config,
      null,
      response.request,
      response
    ));
  }
};


/***/ }),

/***/ 8527:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

"use strict";


var utils = __webpack_require__(4867);

/**
 * Transform the data for a request or a response
 *
 * @param {Object|String} data The data to be transformed
 * @param {Array} headers The headers for the request or response
 * @param {Array|Function} fns A single function or Array of functions
 * @returns {*} The resulting transformed data
 */
module.exports = function transformData(data, headers, fns) {
  /*eslint no-param-reassign:0*/
  utils.forEach(fns, function transform(fn) {
    data = fn(data, headers);
  });

  return data;
};


/***/ }),

/***/ 5655:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

"use strict";


var utils = __webpack_require__(4867);
var normalizeHeaderName = __webpack_require__(6016);

var DEFAULT_CONTENT_TYPE = {
  'Content-Type': 'application/x-www-form-urlencoded'
};

function setContentTypeIfUnset(headers, value) {
  if (!utils.isUndefined(headers) && utils.isUndefined(headers['Content-Type'])) {
    headers['Content-Type'] = value;
  }
}

function getDefaultAdapter() {
  var adapter;
  if (typeof XMLHttpRequest !== 'undefined') {
    // For browsers use XHR adapter
    adapter = __webpack_require__(5448);
  } else if (typeof process !== 'undefined' && Object.prototype.toString.call(process) === '[object process]') {
    // For node use HTTP adapter
    adapter = __webpack_require__(5448);
  }
  return adapter;
}

var defaults = {
  adapter: getDefaultAdapter(),

  transformRequest: [function transformRequest(data, headers) {
    normalizeHeaderName(headers, 'Accept');
    normalizeHeaderName(headers, 'Content-Type');
    if (utils.isFormData(data) ||
      utils.isArrayBuffer(data) ||
      utils.isBuffer(data) ||
      utils.isStream(data) ||
      utils.isFile(data) ||
      utils.isBlob(data)
    ) {
      return data;
    }
    if (utils.isArrayBufferView(data)) {
      return data.buffer;
    }
    if (utils.isURLSearchParams(data)) {
      setContentTypeIfUnset(headers, 'application/x-www-form-urlencoded;charset=utf-8');
      return data.toString();
    }
    if (utils.isObject(data)) {
      setContentTypeIfUnset(headers, 'application/json;charset=utf-8');
      return JSON.stringify(data);
    }
    return data;
  }],

  transformResponse: [function transformResponse(data) {
    /*eslint no-param-reassign:0*/
    if (typeof data === 'string') {
      try {
        data = JSON.parse(data);
      } catch (e) { /* Ignore */ }
    }
    return data;
  }],

  /**
   * A timeout in milliseconds to abort a request. If set to 0 (default) a
   * timeout is not created.
   */
  timeout: 0,

  xsrfCookieName: 'XSRF-TOKEN',
  xsrfHeaderName: 'X-XSRF-TOKEN',

  maxContentLength: -1,
  maxBodyLength: -1,

  validateStatus: function validateStatus(status) {
    return status >= 200 && status < 300;
  }
};

defaults.headers = {
  common: {
    'Accept': 'application/json, text/plain, */*'
  }
};

utils.forEach(['delete', 'get', 'head'], function forEachMethodNoData(method) {
  defaults.headers[method] = {};
});

utils.forEach(['post', 'put', 'patch'], function forEachMethodWithData(method) {
  defaults.headers[method] = utils.merge(DEFAULT_CONTENT_TYPE);
});

module.exports = defaults;


/***/ }),

/***/ 1849:
/***/ ((module) => {

"use strict";


module.exports = function bind(fn, thisArg) {
  return function wrap() {
    var args = new Array(arguments.length);
    for (var i = 0; i < args.length; i++) {
      args[i] = arguments[i];
    }
    return fn.apply(thisArg, args);
  };
};


/***/ }),

/***/ 5327:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

"use strict";


var utils = __webpack_require__(4867);

function encode(val) {
  return encodeURIComponent(val).
    replace(/%3A/gi, ':').
    replace(/%24/g, '$').
    replace(/%2C/gi, ',').
    replace(/%20/g, '+').
    replace(/%5B/gi, '[').
    replace(/%5D/gi, ']');
}

/**
 * Build a URL by appending params to the end
 *
 * @param {string} url The base of the url (e.g., http://www.google.com)
 * @param {object} [params] The params to be appended
 * @returns {string} The formatted url
 */
module.exports = function buildURL(url, params, paramsSerializer) {
  /*eslint no-param-reassign:0*/
  if (!params) {
    return url;
  }

  var serializedParams;
  if (paramsSerializer) {
    serializedParams = paramsSerializer(params);
  } else if (utils.isURLSearchParams(params)) {
    serializedParams = params.toString();
  } else {
    var parts = [];

    utils.forEach(params, function serialize(val, key) {
      if (val === null || typeof val === 'undefined') {
        return;
      }

      if (utils.isArray(val)) {
        key = key + '[]';
      } else {
        val = [val];
      }

      utils.forEach(val, function parseValue(v) {
        if (utils.isDate(v)) {
          v = v.toISOString();
        } else if (utils.isObject(v)) {
          v = JSON.stringify(v);
        }
        parts.push(encode(key) + '=' + encode(v));
      });
    });

    serializedParams = parts.join('&');
  }

  if (serializedParams) {
    var hashmarkIndex = url.indexOf('#');
    if (hashmarkIndex !== -1) {
      url = url.slice(0, hashmarkIndex);
    }

    url += (url.indexOf('?') === -1 ? '?' : '&') + serializedParams;
  }

  return url;
};


/***/ }),

/***/ 7303:
/***/ ((module) => {

"use strict";


/**
 * Creates a new URL by combining the specified URLs
 *
 * @param {string} baseURL The base URL
 * @param {string} relativeURL The relative URL
 * @returns {string} The combined URL
 */
module.exports = function combineURLs(baseURL, relativeURL) {
  return relativeURL
    ? baseURL.replace(/\/+$/, '') + '/' + relativeURL.replace(/^\/+/, '')
    : baseURL;
};


/***/ }),

/***/ 4372:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

"use strict";


var utils = __webpack_require__(4867);

module.exports = (
  utils.isStandardBrowserEnv() ?

  // Standard browser envs support document.cookie
    (function standardBrowserEnv() {
      return {
        write: function write(name, value, expires, path, domain, secure) {
          var cookie = [];
          cookie.push(name + '=' + encodeURIComponent(value));

          if (utils.isNumber(expires)) {
            cookie.push('expires=' + new Date(expires).toGMTString());
          }

          if (utils.isString(path)) {
            cookie.push('path=' + path);
          }

          if (utils.isString(domain)) {
            cookie.push('domain=' + domain);
          }

          if (secure === true) {
            cookie.push('secure');
          }

          document.cookie = cookie.join('; ');
        },

        read: function read(name) {
          var match = document.cookie.match(new RegExp('(^|;\\s*)(' + name + ')=([^;]*)'));
          return (match ? decodeURIComponent(match[3]) : null);
        },

        remove: function remove(name) {
          this.write(name, '', Date.now() - 86400000);
        }
      };
    })() :

  // Non standard browser env (web workers, react-native) lack needed support.
    (function nonStandardBrowserEnv() {
      return {
        write: function write() {},
        read: function read() { return null; },
        remove: function remove() {}
      };
    })()
);


/***/ }),

/***/ 1793:
/***/ ((module) => {

"use strict";


/**
 * Determines whether the specified URL is absolute
 *
 * @param {string} url The URL to test
 * @returns {boolean} True if the specified URL is absolute, otherwise false
 */
module.exports = function isAbsoluteURL(url) {
  // A URL is considered absolute if it begins with "<scheme>://" or "//" (protocol-relative URL).
  // RFC 3986 defines scheme name as a sequence of characters beginning with a letter and followed
  // by any combination of letters, digits, plus, period, or hyphen.
  return /^([a-z][a-z\d\+\-\.]*:)?\/\//i.test(url);
};


/***/ }),

/***/ 6268:
/***/ ((module) => {

"use strict";


/**
 * Determines whether the payload is an error thrown by Axios
 *
 * @param {*} payload The value to test
 * @returns {boolean} True if the payload is an error thrown by Axios, otherwise false
 */
module.exports = function isAxiosError(payload) {
  return (typeof payload === 'object') && (payload.isAxiosError === true);
};


/***/ }),

/***/ 7985:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

"use strict";


var utils = __webpack_require__(4867);

module.exports = (
  utils.isStandardBrowserEnv() ?

  // Standard browser envs have full support of the APIs needed to test
  // whether the request URL is of the same origin as current location.
    (function standardBrowserEnv() {
      var msie = /(msie|trident)/i.test(navigator.userAgent);
      var urlParsingNode = document.createElement('a');
      var originURL;

      /**
    * Parse a URL to discover it's components
    *
    * @param {String} url The URL to be parsed
    * @returns {Object}
    */
      function resolveURL(url) {
        var href = url;

        if (msie) {
        // IE needs attribute set twice to normalize properties
          urlParsingNode.setAttribute('href', href);
          href = urlParsingNode.href;
        }

        urlParsingNode.setAttribute('href', href);

        // urlParsingNode provides the UrlUtils interface - http://url.spec.whatwg.org/#urlutils
        return {
          href: urlParsingNode.href,
          protocol: urlParsingNode.protocol ? urlParsingNode.protocol.replace(/:$/, '') : '',
          host: urlParsingNode.host,
          search: urlParsingNode.search ? urlParsingNode.search.replace(/^\?/, '') : '',
          hash: urlParsingNode.hash ? urlParsingNode.hash.replace(/^#/, '') : '',
          hostname: urlParsingNode.hostname,
          port: urlParsingNode.port,
          pathname: (urlParsingNode.pathname.charAt(0) === '/') ?
            urlParsingNode.pathname :
            '/' + urlParsingNode.pathname
        };
      }

      originURL = resolveURL(window.location.href);

      /**
    * Determine if a URL shares the same origin as the current location
    *
    * @param {String} requestURL The URL to test
    * @returns {boolean} True if URL shares the same origin, otherwise false
    */
      return function isURLSameOrigin(requestURL) {
        var parsed = (utils.isString(requestURL)) ? resolveURL(requestURL) : requestURL;
        return (parsed.protocol === originURL.protocol &&
            parsed.host === originURL.host);
      };
    })() :

  // Non standard browser envs (web workers, react-native) lack needed support.
    (function nonStandardBrowserEnv() {
      return function isURLSameOrigin() {
        return true;
      };
    })()
);


/***/ }),

/***/ 6016:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

"use strict";


var utils = __webpack_require__(4867);

module.exports = function normalizeHeaderName(headers, normalizedName) {
  utils.forEach(headers, function processHeader(value, name) {
    if (name !== normalizedName && name.toUpperCase() === normalizedName.toUpperCase()) {
      headers[normalizedName] = value;
      delete headers[name];
    }
  });
};


/***/ }),

/***/ 4109:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

"use strict";


var utils = __webpack_require__(4867);

// Headers whose duplicates are ignored by node
// c.f. https://nodejs.org/api/http.html#http_message_headers
var ignoreDuplicateOf = [
  'age', 'authorization', 'content-length', 'content-type', 'etag',
  'expires', 'from', 'host', 'if-modified-since', 'if-unmodified-since',
  'last-modified', 'location', 'max-forwards', 'proxy-authorization',
  'referer', 'retry-after', 'user-agent'
];

/**
 * Parse headers into an object
 *
 * ```
 * Date: Wed, 27 Aug 2014 08:58:49 GMT
 * Content-Type: application/json
 * Connection: keep-alive
 * Transfer-Encoding: chunked
 * ```
 *
 * @param {String} headers Headers needing to be parsed
 * @returns {Object} Headers parsed into an object
 */
module.exports = function parseHeaders(headers) {
  var parsed = {};
  var key;
  var val;
  var i;

  if (!headers) { return parsed; }

  utils.forEach(headers.split('\n'), function parser(line) {
    i = line.indexOf(':');
    key = utils.trim(line.substr(0, i)).toLowerCase();
    val = utils.trim(line.substr(i + 1));

    if (key) {
      if (parsed[key] && ignoreDuplicateOf.indexOf(key) >= 0) {
        return;
      }
      if (key === 'set-cookie') {
        parsed[key] = (parsed[key] ? parsed[key] : []).concat([val]);
      } else {
        parsed[key] = parsed[key] ? parsed[key] + ', ' + val : val;
      }
    }
  });

  return parsed;
};


/***/ }),

/***/ 8713:
/***/ ((module) => {

"use strict";


/**
 * Syntactic sugar for invoking a function and expanding an array for arguments.
 *
 * Common use case would be to use `Function.prototype.apply`.
 *
 *  ```js
 *  function f(x, y, z) {}
 *  var args = [1, 2, 3];
 *  f.apply(null, args);
 *  ```
 *
 * With `spread` this example can be re-written.
 *
 *  ```js
 *  spread(function(x, y, z) {})([1, 2, 3]);
 *  ```
 *
 * @param {Function} callback
 * @returns {Function}
 */
module.exports = function spread(callback) {
  return function wrap(arr) {
    return callback.apply(null, arr);
  };
};


/***/ }),

/***/ 4867:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

"use strict";


var bind = __webpack_require__(1849);

/*global toString:true*/

// utils is a library of generic helper functions non-specific to axios

var toString = Object.prototype.toString;

/**
 * Determine if a value is an Array
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if value is an Array, otherwise false
 */
function isArray(val) {
  return toString.call(val) === '[object Array]';
}

/**
 * Determine if a value is undefined
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if the value is undefined, otherwise false
 */
function isUndefined(val) {
  return typeof val === 'undefined';
}

/**
 * Determine if a value is a Buffer
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if value is a Buffer, otherwise false
 */
function isBuffer(val) {
  return val !== null && !isUndefined(val) && val.constructor !== null && !isUndefined(val.constructor)
    && typeof val.constructor.isBuffer === 'function' && val.constructor.isBuffer(val);
}

/**
 * Determine if a value is an ArrayBuffer
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if value is an ArrayBuffer, otherwise false
 */
function isArrayBuffer(val) {
  return toString.call(val) === '[object ArrayBuffer]';
}

/**
 * Determine if a value is a FormData
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if value is an FormData, otherwise false
 */
function isFormData(val) {
  return (typeof FormData !== 'undefined') && (val instanceof FormData);
}

/**
 * Determine if a value is a view on an ArrayBuffer
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if value is a view on an ArrayBuffer, otherwise false
 */
function isArrayBufferView(val) {
  var result;
  if ((typeof ArrayBuffer !== 'undefined') && (ArrayBuffer.isView)) {
    result = ArrayBuffer.isView(val);
  } else {
    result = (val) && (val.buffer) && (val.buffer instanceof ArrayBuffer);
  }
  return result;
}

/**
 * Determine if a value is a String
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if value is a String, otherwise false
 */
function isString(val) {
  return typeof val === 'string';
}

/**
 * Determine if a value is a Number
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if value is a Number, otherwise false
 */
function isNumber(val) {
  return typeof val === 'number';
}

/**
 * Determine if a value is an Object
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if value is an Object, otherwise false
 */
function isObject(val) {
  return val !== null && typeof val === 'object';
}

/**
 * Determine if a value is a plain Object
 *
 * @param {Object} val The value to test
 * @return {boolean} True if value is a plain Object, otherwise false
 */
function isPlainObject(val) {
  if (toString.call(val) !== '[object Object]') {
    return false;
  }

  var prototype = Object.getPrototypeOf(val);
  return prototype === null || prototype === Object.prototype;
}

/**
 * Determine if a value is a Date
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if value is a Date, otherwise false
 */
function isDate(val) {
  return toString.call(val) === '[object Date]';
}

/**
 * Determine if a value is a File
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if value is a File, otherwise false
 */
function isFile(val) {
  return toString.call(val) === '[object File]';
}

/**
 * Determine if a value is a Blob
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if value is a Blob, otherwise false
 */
function isBlob(val) {
  return toString.call(val) === '[object Blob]';
}

/**
 * Determine if a value is a Function
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if value is a Function, otherwise false
 */
function isFunction(val) {
  return toString.call(val) === '[object Function]';
}

/**
 * Determine if a value is a Stream
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if value is a Stream, otherwise false
 */
function isStream(val) {
  return isObject(val) && isFunction(val.pipe);
}

/**
 * Determine if a value is a URLSearchParams object
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if value is a URLSearchParams object, otherwise false
 */
function isURLSearchParams(val) {
  return typeof URLSearchParams !== 'undefined' && val instanceof URLSearchParams;
}

/**
 * Trim excess whitespace off the beginning and end of a string
 *
 * @param {String} str The String to trim
 * @returns {String} The String freed of excess whitespace
 */
function trim(str) {
  return str.replace(/^\s*/, '').replace(/\s*$/, '');
}

/**
 * Determine if we're running in a standard browser environment
 *
 * This allows axios to run in a web worker, and react-native.
 * Both environments support XMLHttpRequest, but not fully standard globals.
 *
 * web workers:
 *  typeof window -> undefined
 *  typeof document -> undefined
 *
 * react-native:
 *  navigator.product -> 'ReactNative'
 * nativescript
 *  navigator.product -> 'NativeScript' or 'NS'
 */
function isStandardBrowserEnv() {
  if (typeof navigator !== 'undefined' && (navigator.product === 'ReactNative' ||
                                           navigator.product === 'NativeScript' ||
                                           navigator.product === 'NS')) {
    return false;
  }
  return (
    typeof window !== 'undefined' &&
    typeof document !== 'undefined'
  );
}

/**
 * Iterate over an Array or an Object invoking a function for each item.
 *
 * If `obj` is an Array callback will be called passing
 * the value, index, and complete array for each item.
 *
 * If 'obj' is an Object callback will be called passing
 * the value, key, and complete object for each property.
 *
 * @param {Object|Array} obj The object to iterate
 * @param {Function} fn The callback to invoke for each item
 */
function forEach(obj, fn) {
  // Don't bother if no value provided
  if (obj === null || typeof obj === 'undefined') {
    return;
  }

  // Force an array if not already something iterable
  if (typeof obj !== 'object') {
    /*eslint no-param-reassign:0*/
    obj = [obj];
  }

  if (isArray(obj)) {
    // Iterate over array values
    for (var i = 0, l = obj.length; i < l; i++) {
      fn.call(null, obj[i], i, obj);
    }
  } else {
    // Iterate over object keys
    for (var key in obj) {
      if (Object.prototype.hasOwnProperty.call(obj, key)) {
        fn.call(null, obj[key], key, obj);
      }
    }
  }
}

/**
 * Accepts varargs expecting each argument to be an object, then
 * immutably merges the properties of each object and returns result.
 *
 * When multiple objects contain the same key the later object in
 * the arguments list will take precedence.
 *
 * Example:
 *
 * ```js
 * var result = merge({foo: 123}, {foo: 456});
 * console.log(result.foo); // outputs 456
 * ```
 *
 * @param {Object} obj1 Object to merge
 * @returns {Object} Result of all merge properties
 */
function merge(/* obj1, obj2, obj3, ... */) {
  var result = {};
  function assignValue(val, key) {
    if (isPlainObject(result[key]) && isPlainObject(val)) {
      result[key] = merge(result[key], val);
    } else if (isPlainObject(val)) {
      result[key] = merge({}, val);
    } else if (isArray(val)) {
      result[key] = val.slice();
    } else {
      result[key] = val;
    }
  }

  for (var i = 0, l = arguments.length; i < l; i++) {
    forEach(arguments[i], assignValue);
  }
  return result;
}

/**
 * Extends object a by mutably adding to it the properties of object b.
 *
 * @param {Object} a The object to be extended
 * @param {Object} b The object to copy properties from
 * @param {Object} thisArg The object to bind function to
 * @return {Object} The resulting value of object a
 */
function extend(a, b, thisArg) {
  forEach(b, function assignValue(val, key) {
    if (thisArg && typeof val === 'function') {
      a[key] = bind(val, thisArg);
    } else {
      a[key] = val;
    }
  });
  return a;
}

/**
 * Remove byte order marker. This catches EF BB BF (the UTF-8 BOM)
 *
 * @param {string} content with BOM
 * @return {string} content value without BOM
 */
function stripBOM(content) {
  if (content.charCodeAt(0) === 0xFEFF) {
    content = content.slice(1);
  }
  return content;
}

module.exports = {
  isArray: isArray,
  isArrayBuffer: isArrayBuffer,
  isBuffer: isBuffer,
  isFormData: isFormData,
  isArrayBufferView: isArrayBufferView,
  isString: isString,
  isNumber: isNumber,
  isObject: isObject,
  isPlainObject: isPlainObject,
  isUndefined: isUndefined,
  isDate: isDate,
  isFile: isFile,
  isBlob: isBlob,
  isFunction: isFunction,
  isStream: isStream,
  isURLSearchParams: isURLSearchParams,
  isStandardBrowserEnv: isStandardBrowserEnv,
  forEach: forEach,
  merge: merge,
  extend: extend,
  trim: trim,
  stripBOM: stripBOM
};


/***/ }),

/***/ 4184:
/***/ ((module, exports) => {

var __WEBPACK_AMD_DEFINE_ARRAY__, __WEBPACK_AMD_DEFINE_RESULT__;/*!
  Copyright (c) 2018 Jed Watson.
  Licensed under the MIT License (MIT), see
  http://jedwatson.github.io/classnames
*/
/* global define */

(function () {
	'use strict';

	var hasOwn = {}.hasOwnProperty;

	function classNames() {
		var classes = [];

		for (var i = 0; i < arguments.length; i++) {
			var arg = arguments[i];
			if (!arg) continue;

			var argType = typeof arg;

			if (argType === 'string' || argType === 'number') {
				classes.push(arg);
			} else if (Array.isArray(arg)) {
				if (arg.length) {
					var inner = classNames.apply(null, arg);
					if (inner) {
						classes.push(inner);
					}
				}
			} else if (argType === 'object') {
				if (arg.toString === Object.prototype.toString) {
					for (var key in arg) {
						if (hasOwn.call(arg, key) && arg[key]) {
							classes.push(key);
						}
					}
				} else {
					classes.push(arg.toString());
				}
			}
		}

		return classes.join(' ');
	}

	if ( true && module.exports) {
		classNames.default = classNames;
		module.exports = classNames;
	} else if (true) {
		// register as 'classnames', consistent with npm package name
		!(__WEBPACK_AMD_DEFINE_ARRAY__ = [], __WEBPACK_AMD_DEFINE_RESULT__ = (function () {
			return classNames;
		}).apply(exports, __WEBPACK_AMD_DEFINE_ARRAY__),
		__WEBPACK_AMD_DEFINE_RESULT__ !== undefined && (module.exports = __WEBPACK_AMD_DEFINE_RESULT__));
	} else {}
}());


/***/ }),

/***/ 3281:
/***/ ((module, __webpack_exports__, __webpack_require__) => {

"use strict";
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "Z": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony import */ var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(3645);
/* harmony import */ var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(_node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__);
// Imports

var ___CSS_LOADER_EXPORT___ = _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default()(function(i){return i[1]});
// Module
___CSS_LOADER_EXPORT___.push([module.id, ".icons {\n    display: none;\n}\n\n.icon {\n    display: inline-block;\n    vertical-align: middle;\n    width: 24px;\n    height: 24px;\n    flex-shrink: 0;\n}\n\n.icon--gray400 {\n        color: var(--gray400);\n    }\n\n.icon--green {\n        color: var(--green);\n    }\n\n.icon--red {\n        color: var(--red);\n    }\n\n.icon--yellow {\n        color: var(--yellow);\n    }\n\n.icon--disable {\n        filter: grayscale(1);\n    }\n", ""]);
// Exports
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = (___CSS_LOADER_EXPORT___);


/***/ }),

/***/ 8280:
/***/ ((module, __webpack_exports__, __webpack_require__) => {

"use strict";
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "Z": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony import */ var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(3645);
/* harmony import */ var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(_node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__);
// Imports

var ___CSS_LOADER_EXPORT___ = _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default()(function(i){return i[1]});
// Module
___CSS_LOADER_EXPORT___.push([module.id, ".action {\n    cursor: pointer;\n    display: flex;\n    align-items: center;\n    width: 100%;\n    min-height: 60px;\n    overflow: hidden;\n    padding: 0 16px;\n    transition: background-color var(--t3);\n}\n\n    .action-label {\n        display: block;\n    }\n\n    .action--disable {\n        opacity: 0.4;\n        pointer-events: none;\n    }\n\n.action:focus,\n    .action:active {\n        background-color: var(--gray100);\n    }\n\n.action__icon {\n        flex-shrink: 0;\n        margin-right: 16px;\n        border-radius: 100%;\n        overflow: hidden;\n    }\n\n.action__title,\n    .action__description {\n        overflow: hidden;\n        text-overflow: ellipsis;\n        white-space: nowrap;\n    }\n\n.action__title {\n        line-height: 19px;\n        font-size: 16px;\n    }\n\n.action__title--bold {\n            font-weight: 700;\n        }\n\n.action__title--light {\n            font-weight: 400;\n            font-size: 14px;\n        }\n\n.action__description {\n        line-height: 17px;\n    }\n\n.action__description--yellow {\n            color: var(--yellow);\n        }\n\n.action__description--gray {\n            color: var(--gray700);\n        }\n\n.action__description--green {\n            color: var(--green);\n        }\n\n.action__checkbox {\n        position: absolute;\n        cursor: pointer;\n        right: 47px\n    }\n\n.action__checkbox:after {\n            content: \"\";\n            position: absolute;\n            left: -6px;\n            top: -6px;\n            width: 48px;\n            height: 28px;\n            background-color: var(--gray700);\n            border-radius: 16px;\n        }\n\n.action__checkbox:before {\n            content: \"\";\n            width: 26px;\n            height: 26px;\n            background-color: var(--white);\n            z-index: 1;\n            border-radius: 100%;\n            position: absolute;\n            left: -5px;\n            top: -5px;\n        }\n\n.action__checkbox:checked:after {\n                background-color: var(--green);\n            }\n\n.action__checkbox:checked:before {\n                left: 15px;\n            }\n\n.action__details {\n        min-width: 0;\n        padding-right: 16px\n    }\n", ""]);
// Exports
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = (___CSS_LOADER_EXPORT___);


/***/ }),

/***/ 2788:
/***/ ((module, __webpack_exports__, __webpack_require__) => {

"use strict";
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "Z": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony import */ var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(3645);
/* harmony import */ var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(_node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__);
// Imports

var ___CSS_LOADER_EXPORT___ = _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default()(function(i){return i[1]});
// Module
___CSS_LOADER_EXPORT___.push([module.id, ".actions > * {\n        border-bottom: 1px solid var(--gray100)\n    }\n    .actions > *:last-child {\n            border-bottom: 0;\n        }\n    .actions__control {\n        flex-shrink: 0;\n        padding: 0;\n        margin-left: auto;\n    }\n", ""]);
// Exports
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = (___CSS_LOADER_EXPORT___);


/***/ }),

/***/ 3437:
/***/ ((module, __webpack_exports__, __webpack_require__) => {

"use strict";
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "Z": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony import */ var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(3645);
/* harmony import */ var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(_node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__);
// Imports

var ___CSS_LOADER_EXPORT___ = _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default()(function(i){return i[1]});
// Module
___CSS_LOADER_EXPORT___.push([module.id, ".button {\n    display: inline-block;\n    cursor: pointer;\n    text-decoration: none;\n    border: 1px solid transparent;\n    outline: none;\n    background-color: transparent;\n    border-radius: 8px;\n    text-align: center\n}\n.button:hover,\n    .button:focus,\n    .button:active {\n        background-color: transparent;\n    }\n.button--green {\n        color: #fff;\n        background-color: var(--green);\n        transition: background-color var(--t3)\n    }\n.button--green:hover,\n        .button--green:focus,\n        .button--green:active {\n            background-color: var(--green-hover);\n        }\n.button--l {\n        font-size: 16px;\n        height: 40px;\n    }\n.button--bottom {\n        margin-top: 16px;\n    }\n.button--roll {\n        margin-top: auto;\n        border: 0;\n        border-radius: 0;\n        box-shadow: 0 -1px 0 0 var(--gray100);\n        text-align: center;\n        height: 26px;\n        display: flex;\n        align-content: center;\n        justify-content: center;\n        width: 100%;\n        transform: translateY(11px);\n    }\n", ""]);
// Exports
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = (___CSS_LOADER_EXPORT___);


/***/ }),

/***/ 2199:
/***/ ((module, __webpack_exports__, __webpack_require__) => {

"use strict";
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "Z": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony import */ var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(3645);
/* harmony import */ var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(_node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__);
// Imports

var ___CSS_LOADER_EXPORT___ = _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default()(function(i){return i[1]});
// Module
___CSS_LOADER_EXPORT___.push([module.id, ".loader {\n    position: fixed;\n    z-index: 10;\n    left: 0;\n    top: 0;\n    padding: 12px 16px;\n    width: 100%;\n    height: 100%;\n    background-color: var(--white);\n}\n\n    .loader__inner {\n        height: 100%;\n        display: flex;\n        flex-direction: column;\n        justify-content: center;\n    }\n\n    .loader__item {\n        width: 100%;\n        border-radius: 8px;\n        height: 42px;\n        margin: 6px 0;\n        background-color: var(--gray100);\n    }\n", ""]);
// Exports
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = (___CSS_LOADER_EXPORT___);


/***/ }),

/***/ 7883:
/***/ ((module, __webpack_exports__, __webpack_require__) => {

"use strict";
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "Z": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony import */ var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(3645);
/* harmony import */ var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(_node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__);
// Imports

var ___CSS_LOADER_EXPORT___ = _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default()(function(i){return i[1]});
// Module
___CSS_LOADER_EXPORT___.push([module.id, ".modal {\n    position: fixed;\n    z-index: 10;\n    left: 0;\n    top: 0;\n    padding: 8px;\n    width: 100%;\n    min-height: 100%;\n    height: 100%;\n    background-color: var(--white);\n}\n\n    .modal__inner {\n        position: relative;\n        width: 100%;\n        height: 100%;\n        border-radius: 8px;\n        padding: 40px 13px 17px;\n        background-color: var(--gray100);\n        text-align: center;\n        display: flex;\n        justify-content: center;\n        flex-direction: column\n    }\n\n    .modal__inner .button {\n            flex-shrink: 0;\n        }\n\n    .modal__close {\n        position: absolute;\n        border: 0;\n        background-color: transparent;\n        padding: 0;\n        top: 8px;\n        right: 8px;\n        cursor: pointer;\n    }\n\n    .modal__title {\n        font-size: 20px;\n        font-weight: bold;\n        margin-bottom: 4px;\n    }\n", ""]);
// Exports
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = (___CSS_LOADER_EXPORT___);


/***/ }),

/***/ 3241:
/***/ ((module, __webpack_exports__, __webpack_require__) => {

"use strict";
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "Z": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony import */ var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(3645);
/* harmony import */ var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(_node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__);
// Imports

var ___CSS_LOADER_EXPORT___ = _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default()(function(i){return i[1]});
// Module
___CSS_LOADER_EXPORT___.push([module.id, ".protection-off {\n    padding-top: 15px;\n}\n\n    .protection-off__item {\n        display: flex;\n        text-align: left;\n        justify-content: flex-start;\n        align-items: center;\n        margin-bottom: 19px;\n    }\n\n    .protection-off__item :last-child {\n            margin-bottom: 0;\n        }\n\n    .protection-off__info {\n        padding-left: 10px;\n        font-size: 16px;\n        line-height: 21px;\n    }\n", ""]);
// Exports
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = (___CSS_LOADER_EXPORT___);


/***/ }),

/***/ 8524:
/***/ ((module, __webpack_exports__, __webpack_require__) => {

"use strict";
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "Z": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony import */ var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(3645);
/* harmony import */ var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(_node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__);
// Imports

var ___CSS_LOADER_EXPORT___ = _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default()(function(i){return i[1]});
// Module
___CSS_LOADER_EXPORT___.push([module.id, ":root {\n    --t3: 0.3s ease;\n\n    --white: #ffffff;\n    --green: #67b279;\n    --green-hover: #4d995f;\n    --red: #bf4829;\n    --yellow: #d58500;\n    --gray-base: #4d4d4d;\n    --gray100: #f3f3f3;\n    --gray400: #a4a4a4;\n    --gray700: #888888\n}\n\n@media (prefers-color-scheme: dark) {\n\n:root {\n        --white: #000;\n        --gray-base: #F3F3F3;\n        --gray100: #131313\n}\n    }\n\n.light-mode {\n    --white: #fff;\n    --gray-base: #4d4d4d;\n    --gray100: #f3f3f3;\n}\n\n.dark-mode {\n    --white: #000;\n    --gray-base: #F3F3F3;\n    --gray100: #131313;\n}\n\n* {\n    box-sizing: border-box;\n}\n\nhtml, body {\n    margin: 0;\n    font-size: 14px;\n    color: #4d4d4d;\n    color: var(--gray-base);\n    background-color: #ffffff;\n    background-color: var(--white);\n}\n\nbody {\n    font-family: -apple-system, BlinkMacSystemFont, sans-serif;\n}\n\ninput:is([type=\"button\"],\n[type=\"submit\"],\n[type=\"reset\"]),\ninput[type=\"file\"]::file-selector-button,\nbutton {\n    font-size: 14px;\n    font-family: -apple-system, BlinkMacSystemFont, sans-serif;\n}\n\n.popup {\n    display: flex;\n    flex-direction: column;\n    min-width: 320px;\n    min-height: 280px;\n    padding: 11px 0;\n}\n\na {\n    text-decoration: underline\n}\n\n.bold {\n    font-weight: bold;\n}\n\n.link {\n    color: #67b279;\n    color: var(--green);\n    white-space: nowrap;\n    cursor: pointer;\n}\n", ""]);
// Exports
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = (___CSS_LOADER_EXPORT___);


/***/ }),

/***/ 7117:
/***/ ((module, __webpack_exports__, __webpack_require__) => {

"use strict";
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "Z": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony import */ var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(3645);
/* harmony import */ var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(_node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__);
// Imports

var ___CSS_LOADER_EXPORT___ = _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default()(function(i){return i[1]});
// Module
___CSS_LOADER_EXPORT___.push([module.id, ".support {\n    padding: 24px 18px;\n}\n\n    .support--swipe {\n        max-width: 240px;\n    }\n\n    .support__title {\n        font-size: 20px;\n        line-height: 23px;\n        margin-bottom: 16px;\n        font-weight: 500;\n    }\n\n    .support__description {\n        font-weight: 400;\n        color: var(--gray700);\n        margin-bottom: 16px;\n    }\n\n    .support__link {\n        background: none!important;\n        border: none;\n        padding: 0!important;\n        text-decoration: underline;\n        cursor: pointer;\n        font-weight: 400;\n        color: var(--green);\n    }\n", ""]);
// Exports
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = (___CSS_LOADER_EXPORT___);


/***/ }),

/***/ 710:
/***/ ((module, __webpack_exports__, __webpack_require__) => {

"use strict";
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "Z": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/* harmony import */ var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(3645);
/* harmony import */ var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(_node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__);
// Imports

var ___CSS_LOADER_EXPORT___ = _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default()(function(i){return i[1]});
// Module
___CSS_LOADER_EXPORT___.push([module.id, ".switcher {\n    cursor: pointer;\n    -webkit-tap-highlight-color: rgba(0, 0, 0, 0)\n}\n.switcher:focus,\n    .switcher:active {\n        background-color: transparent;\n    }\n.switcher__inner {\n        display: inline-block;\n        position: relative;\n        width: 48px;\n        height: 28px;\n        background-color: var(--gray700);\n        border-radius: 16px\n    }\n.switcher__inner:before {\n            content: \"\";\n            width: 26px;\n            height: 26px;\n            background-color: #fff;\n            z-index: 1;\n            border-radius: 100%;\n            position: absolute;\n            left: 1px;\n            top: 1px;\n        }\n.switcher__checkbox {\n        position: absolute;\n        opacity: 0\n    }\n.switcher__checkbox:checked + .switcher__inner {\n                background-color: var(--green)\n            }\n.switcher__checkbox:checked + .switcher__inner:before {\n                    left: 21px;\n                }\n", ""]);
// Exports
/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = (___CSS_LOADER_EXPORT___);


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
module.exports = function (cssWithMappingToString) {
  var list = []; // return the list of modules as css string

  list.toString = function toString() {
    return this.map(function (item) {
      var content = cssWithMappingToString(item);

      if (item[2]) {
        return "@media ".concat(item[2], " {").concat(content, "}");
      }

      return content;
    }).join("");
  }; // import a list of modules into the list
  // eslint-disable-next-line func-names


  list.i = function (modules, mediaQuery, dedupe) {
    if (typeof modules === "string") {
      // eslint-disable-next-line no-param-reassign
      modules = [[null, modules, ""]];
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

/***/ }),

/***/ 2705:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

var root = __webpack_require__(5639);

/** Built-in value references. */
var Symbol = root.Symbol;

module.exports = Symbol;


/***/ }),

/***/ 4239:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

var Symbol = __webpack_require__(2705),
    getRawTag = __webpack_require__(9607),
    objectToString = __webpack_require__(2333);

/** `Object#toString` result references. */
var nullTag = '[object Null]',
    undefinedTag = '[object Undefined]';

/** Built-in value references. */
var symToStringTag = Symbol ? Symbol.toStringTag : undefined;

/**
 * The base implementation of `getTag` without fallbacks for buggy environments.
 *
 * @private
 * @param {*} value The value to query.
 * @returns {string} Returns the `toStringTag`.
 */
function baseGetTag(value) {
  if (value == null) {
    return value === undefined ? undefinedTag : nullTag;
  }
  return (symToStringTag && symToStringTag in Object(value))
    ? getRawTag(value)
    : objectToString(value);
}

module.exports = baseGetTag;


/***/ }),

/***/ 7561:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

var trimmedEndIndex = __webpack_require__(7990);

/** Used to match leading whitespace. */
var reTrimStart = /^\s+/;

/**
 * The base implementation of `_.trim`.
 *
 * @private
 * @param {string} string The string to trim.
 * @returns {string} Returns the trimmed string.
 */
function baseTrim(string) {
  return string
    ? string.slice(0, trimmedEndIndex(string) + 1).replace(reTrimStart, '')
    : string;
}

module.exports = baseTrim;


/***/ }),

/***/ 1957:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

/** Detect free variable `global` from Node.js. */
var freeGlobal = typeof __webpack_require__.g == 'object' && __webpack_require__.g && __webpack_require__.g.Object === Object && __webpack_require__.g;

module.exports = freeGlobal;


/***/ }),

/***/ 9607:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

var Symbol = __webpack_require__(2705);

/** Used for built-in method references. */
var objectProto = Object.prototype;

/** Used to check objects for own properties. */
var hasOwnProperty = objectProto.hasOwnProperty;

/**
 * Used to resolve the
 * [`toStringTag`](http://ecma-international.org/ecma-262/7.0/#sec-object.prototype.tostring)
 * of values.
 */
var nativeObjectToString = objectProto.toString;

/** Built-in value references. */
var symToStringTag = Symbol ? Symbol.toStringTag : undefined;

/**
 * A specialized version of `baseGetTag` which ignores `Symbol.toStringTag` values.
 *
 * @private
 * @param {*} value The value to query.
 * @returns {string} Returns the raw `toStringTag`.
 */
function getRawTag(value) {
  var isOwn = hasOwnProperty.call(value, symToStringTag),
      tag = value[symToStringTag];

  try {
    value[symToStringTag] = undefined;
    var unmasked = true;
  } catch (e) {}

  var result = nativeObjectToString.call(value);
  if (unmasked) {
    if (isOwn) {
      value[symToStringTag] = tag;
    } else {
      delete value[symToStringTag];
    }
  }
  return result;
}

module.exports = getRawTag;


/***/ }),

/***/ 2333:
/***/ ((module) => {

/** Used for built-in method references. */
var objectProto = Object.prototype;

/**
 * Used to resolve the
 * [`toStringTag`](http://ecma-international.org/ecma-262/7.0/#sec-object.prototype.tostring)
 * of values.
 */
var nativeObjectToString = objectProto.toString;

/**
 * Converts `value` to a string using `Object.prototype.toString`.
 *
 * @private
 * @param {*} value The value to convert.
 * @returns {string} Returns the converted string.
 */
function objectToString(value) {
  return nativeObjectToString.call(value);
}

module.exports = objectToString;


/***/ }),

/***/ 5639:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

var freeGlobal = __webpack_require__(1957);

/** Detect free variable `self`. */
var freeSelf = typeof self == 'object' && self && self.Object === Object && self;

/** Used as a reference to the global object. */
var root = freeGlobal || freeSelf || Function('return this')();

module.exports = root;


/***/ }),

/***/ 7990:
/***/ ((module) => {

/** Used to match a single whitespace character. */
var reWhitespace = /\s/;

/**
 * Used by `_.trim` and `_.trimEnd` to get the index of the last non-whitespace
 * character of `string`.
 *
 * @private
 * @param {string} string The string to inspect.
 * @returns {number} Returns the index of the last non-whitespace character.
 */
function trimmedEndIndex(string) {
  var index = string.length;

  while (index-- && reWhitespace.test(string.charAt(index))) {}
  return index;
}

module.exports = trimmedEndIndex;


/***/ }),

/***/ 3279:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

var isObject = __webpack_require__(3218),
    now = __webpack_require__(7771),
    toNumber = __webpack_require__(4841);

/** Error message constants. */
var FUNC_ERROR_TEXT = 'Expected a function';

/* Built-in method references for those with the same name as other `lodash` methods. */
var nativeMax = Math.max,
    nativeMin = Math.min;

/**
 * Creates a debounced function that delays invoking `func` until after `wait`
 * milliseconds have elapsed since the last time the debounced function was
 * invoked. The debounced function comes with a `cancel` method to cancel
 * delayed `func` invocations and a `flush` method to immediately invoke them.
 * Provide `options` to indicate whether `func` should be invoked on the
 * leading and/or trailing edge of the `wait` timeout. The `func` is invoked
 * with the last arguments provided to the debounced function. Subsequent
 * calls to the debounced function return the result of the last `func`
 * invocation.
 *
 * **Note:** If `leading` and `trailing` options are `true`, `func` is
 * invoked on the trailing edge of the timeout only if the debounced function
 * is invoked more than once during the `wait` timeout.
 *
 * If `wait` is `0` and `leading` is `false`, `func` invocation is deferred
 * until to the next tick, similar to `setTimeout` with a timeout of `0`.
 *
 * See [David Corbacho's article](https://css-tricks.com/debouncing-throttling-explained-examples/)
 * for details over the differences between `_.debounce` and `_.throttle`.
 *
 * @static
 * @memberOf _
 * @since 0.1.0
 * @category Function
 * @param {Function} func The function to debounce.
 * @param {number} [wait=0] The number of milliseconds to delay.
 * @param {Object} [options={}] The options object.
 * @param {boolean} [options.leading=false]
 *  Specify invoking on the leading edge of the timeout.
 * @param {number} [options.maxWait]
 *  The maximum time `func` is allowed to be delayed before it's invoked.
 * @param {boolean} [options.trailing=true]
 *  Specify invoking on the trailing edge of the timeout.
 * @returns {Function} Returns the new debounced function.
 * @example
 *
 * // Avoid costly calculations while the window size is in flux.
 * jQuery(window).on('resize', _.debounce(calculateLayout, 150));
 *
 * // Invoke `sendMail` when clicked, debouncing subsequent calls.
 * jQuery(element).on('click', _.debounce(sendMail, 300, {
 *   'leading': true,
 *   'trailing': false
 * }));
 *
 * // Ensure `batchLog` is invoked once after 1 second of debounced calls.
 * var debounced = _.debounce(batchLog, 250, { 'maxWait': 1000 });
 * var source = new EventSource('/stream');
 * jQuery(source).on('message', debounced);
 *
 * // Cancel the trailing debounced invocation.
 * jQuery(window).on('popstate', debounced.cancel);
 */
function debounce(func, wait, options) {
  var lastArgs,
      lastThis,
      maxWait,
      result,
      timerId,
      lastCallTime,
      lastInvokeTime = 0,
      leading = false,
      maxing = false,
      trailing = true;

  if (typeof func != 'function') {
    throw new TypeError(FUNC_ERROR_TEXT);
  }
  wait = toNumber(wait) || 0;
  if (isObject(options)) {
    leading = !!options.leading;
    maxing = 'maxWait' in options;
    maxWait = maxing ? nativeMax(toNumber(options.maxWait) || 0, wait) : maxWait;
    trailing = 'trailing' in options ? !!options.trailing : trailing;
  }

  function invokeFunc(time) {
    var args = lastArgs,
        thisArg = lastThis;

    lastArgs = lastThis = undefined;
    lastInvokeTime = time;
    result = func.apply(thisArg, args);
    return result;
  }

  function leadingEdge(time) {
    // Reset any `maxWait` timer.
    lastInvokeTime = time;
    // Start the timer for the trailing edge.
    timerId = setTimeout(timerExpired, wait);
    // Invoke the leading edge.
    return leading ? invokeFunc(time) : result;
  }

  function remainingWait(time) {
    var timeSinceLastCall = time - lastCallTime,
        timeSinceLastInvoke = time - lastInvokeTime,
        timeWaiting = wait - timeSinceLastCall;

    return maxing
      ? nativeMin(timeWaiting, maxWait - timeSinceLastInvoke)
      : timeWaiting;
  }

  function shouldInvoke(time) {
    var timeSinceLastCall = time - lastCallTime,
        timeSinceLastInvoke = time - lastInvokeTime;

    // Either this is the first call, activity has stopped and we're at the
    // trailing edge, the system time has gone backwards and we're treating
    // it as the trailing edge, or we've hit the `maxWait` limit.
    return (lastCallTime === undefined || (timeSinceLastCall >= wait) ||
      (timeSinceLastCall < 0) || (maxing && timeSinceLastInvoke >= maxWait));
  }

  function timerExpired() {
    var time = now();
    if (shouldInvoke(time)) {
      return trailingEdge(time);
    }
    // Restart the timer.
    timerId = setTimeout(timerExpired, remainingWait(time));
  }

  function trailingEdge(time) {
    timerId = undefined;

    // Only invoke if we have `lastArgs` which means `func` has been
    // debounced at least once.
    if (trailing && lastArgs) {
      return invokeFunc(time);
    }
    lastArgs = lastThis = undefined;
    return result;
  }

  function cancel() {
    if (timerId !== undefined) {
      clearTimeout(timerId);
    }
    lastInvokeTime = 0;
    lastArgs = lastCallTime = lastThis = timerId = undefined;
  }

  function flush() {
    return timerId === undefined ? result : trailingEdge(now());
  }

  function debounced() {
    var time = now(),
        isInvoking = shouldInvoke(time);

    lastArgs = arguments;
    lastThis = this;
    lastCallTime = time;

    if (isInvoking) {
      if (timerId === undefined) {
        return leadingEdge(lastCallTime);
      }
      if (maxing) {
        // Handle invocations in a tight loop.
        clearTimeout(timerId);
        timerId = setTimeout(timerExpired, wait);
        return invokeFunc(lastCallTime);
      }
    }
    if (timerId === undefined) {
      timerId = setTimeout(timerExpired, wait);
    }
    return result;
  }
  debounced.cancel = cancel;
  debounced.flush = flush;
  return debounced;
}

module.exports = debounce;


/***/ }),

/***/ 3218:
/***/ ((module) => {

/**
 * Checks if `value` is the
 * [language type](http://www.ecma-international.org/ecma-262/7.0/#sec-ecmascript-language-types)
 * of `Object`. (e.g. arrays, functions, objects, regexes, `new Number(0)`, and `new String('')`)
 *
 * @static
 * @memberOf _
 * @since 0.1.0
 * @category Lang
 * @param {*} value The value to check.
 * @returns {boolean} Returns `true` if `value` is an object, else `false`.
 * @example
 *
 * _.isObject({});
 * // => true
 *
 * _.isObject([1, 2, 3]);
 * // => true
 *
 * _.isObject(_.noop);
 * // => true
 *
 * _.isObject(null);
 * // => false
 */
function isObject(value) {
  var type = typeof value;
  return value != null && (type == 'object' || type == 'function');
}

module.exports = isObject;


/***/ }),

/***/ 7005:
/***/ ((module) => {

/**
 * Checks if `value` is object-like. A value is object-like if it's not `null`
 * and has a `typeof` result of "object".
 *
 * @static
 * @memberOf _
 * @since 4.0.0
 * @category Lang
 * @param {*} value The value to check.
 * @returns {boolean} Returns `true` if `value` is object-like, else `false`.
 * @example
 *
 * _.isObjectLike({});
 * // => true
 *
 * _.isObjectLike([1, 2, 3]);
 * // => true
 *
 * _.isObjectLike(_.noop);
 * // => false
 *
 * _.isObjectLike(null);
 * // => false
 */
function isObjectLike(value) {
  return value != null && typeof value == 'object';
}

module.exports = isObjectLike;


/***/ }),

/***/ 3448:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

var baseGetTag = __webpack_require__(4239),
    isObjectLike = __webpack_require__(7005);

/** `Object#toString` result references. */
var symbolTag = '[object Symbol]';

/**
 * Checks if `value` is classified as a `Symbol` primitive or object.
 *
 * @static
 * @memberOf _
 * @since 4.0.0
 * @category Lang
 * @param {*} value The value to check.
 * @returns {boolean} Returns `true` if `value` is a symbol, else `false`.
 * @example
 *
 * _.isSymbol(Symbol.iterator);
 * // => true
 *
 * _.isSymbol('abc');
 * // => false
 */
function isSymbol(value) {
  return typeof value == 'symbol' ||
    (isObjectLike(value) && baseGetTag(value) == symbolTag);
}

module.exports = isSymbol;


/***/ }),

/***/ 7771:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

var root = __webpack_require__(5639);

/**
 * Gets the timestamp of the number of milliseconds that have elapsed since
 * the Unix epoch (1 January 1970 00:00:00 UTC).
 *
 * @static
 * @memberOf _
 * @since 2.4.0
 * @category Date
 * @returns {number} Returns the timestamp.
 * @example
 *
 * _.defer(function(stamp) {
 *   console.log(_.now() - stamp);
 * }, _.now());
 * // => Logs the number of milliseconds it took for the deferred invocation.
 */
var now = function() {
  return root.Date.now();
};

module.exports = now;


/***/ }),

/***/ 3493:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

var debounce = __webpack_require__(3279),
    isObject = __webpack_require__(3218);

/** Error message constants. */
var FUNC_ERROR_TEXT = 'Expected a function';

/**
 * Creates a throttled function that only invokes `func` at most once per
 * every `wait` milliseconds. The throttled function comes with a `cancel`
 * method to cancel delayed `func` invocations and a `flush` method to
 * immediately invoke them. Provide `options` to indicate whether `func`
 * should be invoked on the leading and/or trailing edge of the `wait`
 * timeout. The `func` is invoked with the last arguments provided to the
 * throttled function. Subsequent calls to the throttled function return the
 * result of the last `func` invocation.
 *
 * **Note:** If `leading` and `trailing` options are `true`, `func` is
 * invoked on the trailing edge of the timeout only if the throttled function
 * is invoked more than once during the `wait` timeout.
 *
 * If `wait` is `0` and `leading` is `false`, `func` invocation is deferred
 * until to the next tick, similar to `setTimeout` with a timeout of `0`.
 *
 * See [David Corbacho's article](https://css-tricks.com/debouncing-throttling-explained-examples/)
 * for details over the differences between `_.throttle` and `_.debounce`.
 *
 * @static
 * @memberOf _
 * @since 0.1.0
 * @category Function
 * @param {Function} func The function to throttle.
 * @param {number} [wait=0] The number of milliseconds to throttle invocations to.
 * @param {Object} [options={}] The options object.
 * @param {boolean} [options.leading=true]
 *  Specify invoking on the leading edge of the timeout.
 * @param {boolean} [options.trailing=true]
 *  Specify invoking on the trailing edge of the timeout.
 * @returns {Function} Returns the new throttled function.
 * @example
 *
 * // Avoid excessively updating the position while scrolling.
 * jQuery(window).on('scroll', _.throttle(updatePosition, 100));
 *
 * // Invoke `renewToken` when the click event is fired, but not more than once every 5 minutes.
 * var throttled = _.throttle(renewToken, 300000, { 'trailing': false });
 * jQuery(element).on('click', throttled);
 *
 * // Cancel the trailing throttled invocation.
 * jQuery(window).on('popstate', throttled.cancel);
 */
function throttle(func, wait, options) {
  var leading = true,
      trailing = true;

  if (typeof func != 'function') {
    throw new TypeError(FUNC_ERROR_TEXT);
  }
  if (isObject(options)) {
    leading = 'leading' in options ? !!options.leading : leading;
    trailing = 'trailing' in options ? !!options.trailing : trailing;
  }
  return debounce(func, wait, {
    'leading': leading,
    'maxWait': wait,
    'trailing': trailing
  });
}

module.exports = throttle;


/***/ }),

/***/ 4841:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

var baseTrim = __webpack_require__(7561),
    isObject = __webpack_require__(3218),
    isSymbol = __webpack_require__(3448);

/** Used as references for various `Number` constants. */
var NAN = 0 / 0;

/** Used to detect bad signed hexadecimal string values. */
var reIsBadHex = /^[-+]0x[0-9a-f]+$/i;

/** Used to detect binary string values. */
var reIsBinary = /^0b[01]+$/i;

/** Used to detect octal string values. */
var reIsOctal = /^0o[0-7]+$/i;

/** Built-in method references without a dependency on `root`. */
var freeParseInt = parseInt;

/**
 * Converts `value` to a number.
 *
 * @static
 * @memberOf _
 * @since 4.0.0
 * @category Lang
 * @param {*} value The value to process.
 * @returns {number} Returns the number.
 * @example
 *
 * _.toNumber(3.2);
 * // => 3.2
 *
 * _.toNumber(Number.MIN_VALUE);
 * // => 5e-324
 *
 * _.toNumber(Infinity);
 * // => Infinity
 *
 * _.toNumber('3.2');
 * // => 3.2
 */
function toNumber(value) {
  if (typeof value == 'number') {
    return value;
  }
  if (isSymbol(value)) {
    return NAN;
  }
  if (isObject(value)) {
    var other = typeof value.valueOf == 'function' ? value.valueOf() : value;
    value = isObject(other) ? (other + '') : other;
  }
  if (typeof value != 'string') {
    return value === 0 ? value : +value;
  }
  value = baseTrim(value);
  var isBinary = reIsBinary.test(value);
  return (isBinary || reIsOctal.test(value))
    ? freeParseInt(value.slice(2), isBinary ? 2 : 8)
    : (reIsBadHex.test(value) ? NAN : +value);
}

module.exports = toNumber;


/***/ }),

/***/ 7418:
/***/ ((module) => {

"use strict";
/*
object-assign
(c) Sindre Sorhus
@license MIT
*/


/* eslint-disable no-unused-vars */
var getOwnPropertySymbols = Object.getOwnPropertySymbols;
var hasOwnProperty = Object.prototype.hasOwnProperty;
var propIsEnumerable = Object.prototype.propertyIsEnumerable;

function toObject(val) {
	if (val === null || val === undefined) {
		throw new TypeError('Object.assign cannot be called with null or undefined');
	}

	return Object(val);
}

function shouldUseNative() {
	try {
		if (!Object.assign) {
			return false;
		}

		// Detect buggy property enumeration order in older V8 versions.

		// https://bugs.chromium.org/p/v8/issues/detail?id=4118
		var test1 = new String('abc');  // eslint-disable-line no-new-wrappers
		test1[5] = 'de';
		if (Object.getOwnPropertyNames(test1)[0] === '5') {
			return false;
		}

		// https://bugs.chromium.org/p/v8/issues/detail?id=3056
		var test2 = {};
		for (var i = 0; i < 10; i++) {
			test2['_' + String.fromCharCode(i)] = i;
		}
		var order2 = Object.getOwnPropertyNames(test2).map(function (n) {
			return test2[n];
		});
		if (order2.join('') !== '0123456789') {
			return false;
		}

		// https://bugs.chromium.org/p/v8/issues/detail?id=3056
		var test3 = {};
		'abcdefghijklmnopqrst'.split('').forEach(function (letter) {
			test3[letter] = letter;
		});
		if (Object.keys(Object.assign({}, test3)).join('') !==
				'abcdefghijklmnopqrst') {
			return false;
		}

		return true;
	} catch (err) {
		// We don't expect any of the above to throw, but better to be safe.
		return false;
	}
}

module.exports = shouldUseNative() ? Object.assign : function (target, source) {
	var from;
	var to = toObject(target);
	var symbols;

	for (var s = 1; s < arguments.length; s++) {
		from = Object(arguments[s]);

		for (var key in from) {
			if (hasOwnProperty.call(from, key)) {
				to[key] = from[key];
			}
		}

		if (getOwnPropertySymbols) {
			symbols = getOwnPropertySymbols(from);
			for (var i = 0; i < symbols.length; i++) {
				if (propIsEnumerable.call(from, symbols[i])) {
					to[symbols[i]] = from[symbols[i]];
				}
			}
		}
	}

	return to;
};


/***/ }),

/***/ 4448:
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {

"use strict";
/** @license React v17.0.2
 * react-dom.production.min.js
 *
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */
/*
 Modernizr 3.0.0pre (Custom Build) | MIT
*/
var aa=__webpack_require__(7294),m=__webpack_require__(7418),r=__webpack_require__(3840);function y(a){for(var b="https://reactjs.org/docs/error-decoder.html?invariant="+a,c=1;c<arguments.length;c++)b+="&args[]="+encodeURIComponent(arguments[c]);return"Minified React error #"+a+"; visit "+b+" for the full message or use the non-minified dev environment for full errors and additional helpful warnings."}if(!aa)throw Error(y(227));var ba=new Set,ca={};function da(a,b){ea(a,b);ea(a+"Capture",b)}
function ea(a,b){ca[a]=b;for(a=0;a<b.length;a++)ba.add(b[a])}
var fa=!("undefined"===typeof window||"undefined"===typeof window.document||"undefined"===typeof window.document.createElement),ha=/^[:A-Z_a-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD][:A-Z_a-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD\-.0-9\u00B7\u0300-\u036F\u203F-\u2040]*$/,ia=Object.prototype.hasOwnProperty,
ja={},ka={};function la(a){if(ia.call(ka,a))return!0;if(ia.call(ja,a))return!1;if(ha.test(a))return ka[a]=!0;ja[a]=!0;return!1}function ma(a,b,c,d){if(null!==c&&0===c.type)return!1;switch(typeof b){case "function":case "symbol":return!0;case "boolean":if(d)return!1;if(null!==c)return!c.acceptsBooleans;a=a.toLowerCase().slice(0,5);return"data-"!==a&&"aria-"!==a;default:return!1}}
function na(a,b,c,d){if(null===b||"undefined"===typeof b||ma(a,b,c,d))return!0;if(d)return!1;if(null!==c)switch(c.type){case 3:return!b;case 4:return!1===b;case 5:return isNaN(b);case 6:return isNaN(b)||1>b}return!1}function B(a,b,c,d,e,f,g){this.acceptsBooleans=2===b||3===b||4===b;this.attributeName=d;this.attributeNamespace=e;this.mustUseProperty=c;this.propertyName=a;this.type=b;this.sanitizeURL=f;this.removeEmptyString=g}var D={};
"children dangerouslySetInnerHTML defaultValue defaultChecked innerHTML suppressContentEditableWarning suppressHydrationWarning style".split(" ").forEach(function(a){D[a]=new B(a,0,!1,a,null,!1,!1)});[["acceptCharset","accept-charset"],["className","class"],["htmlFor","for"],["httpEquiv","http-equiv"]].forEach(function(a){var b=a[0];D[b]=new B(b,1,!1,a[1],null,!1,!1)});["contentEditable","draggable","spellCheck","value"].forEach(function(a){D[a]=new B(a,2,!1,a.toLowerCase(),null,!1,!1)});
["autoReverse","externalResourcesRequired","focusable","preserveAlpha"].forEach(function(a){D[a]=new B(a,2,!1,a,null,!1,!1)});"allowFullScreen async autoFocus autoPlay controls default defer disabled disablePictureInPicture disableRemotePlayback formNoValidate hidden loop noModule noValidate open playsInline readOnly required reversed scoped seamless itemScope".split(" ").forEach(function(a){D[a]=new B(a,3,!1,a.toLowerCase(),null,!1,!1)});
["checked","multiple","muted","selected"].forEach(function(a){D[a]=new B(a,3,!0,a,null,!1,!1)});["capture","download"].forEach(function(a){D[a]=new B(a,4,!1,a,null,!1,!1)});["cols","rows","size","span"].forEach(function(a){D[a]=new B(a,6,!1,a,null,!1,!1)});["rowSpan","start"].forEach(function(a){D[a]=new B(a,5,!1,a.toLowerCase(),null,!1,!1)});var oa=/[\-:]([a-z])/g;function pa(a){return a[1].toUpperCase()}
"accent-height alignment-baseline arabic-form baseline-shift cap-height clip-path clip-rule color-interpolation color-interpolation-filters color-profile color-rendering dominant-baseline enable-background fill-opacity fill-rule flood-color flood-opacity font-family font-size font-size-adjust font-stretch font-style font-variant font-weight glyph-name glyph-orientation-horizontal glyph-orientation-vertical horiz-adv-x horiz-origin-x image-rendering letter-spacing lighting-color marker-end marker-mid marker-start overline-position overline-thickness paint-order panose-1 pointer-events rendering-intent shape-rendering stop-color stop-opacity strikethrough-position strikethrough-thickness stroke-dasharray stroke-dashoffset stroke-linecap stroke-linejoin stroke-miterlimit stroke-opacity stroke-width text-anchor text-decoration text-rendering underline-position underline-thickness unicode-bidi unicode-range units-per-em v-alphabetic v-hanging v-ideographic v-mathematical vector-effect vert-adv-y vert-origin-x vert-origin-y word-spacing writing-mode xmlns:xlink x-height".split(" ").forEach(function(a){var b=a.replace(oa,
pa);D[b]=new B(b,1,!1,a,null,!1,!1)});"xlink:actuate xlink:arcrole xlink:role xlink:show xlink:title xlink:type".split(" ").forEach(function(a){var b=a.replace(oa,pa);D[b]=new B(b,1,!1,a,"http://www.w3.org/1999/xlink",!1,!1)});["xml:base","xml:lang","xml:space"].forEach(function(a){var b=a.replace(oa,pa);D[b]=new B(b,1,!1,a,"http://www.w3.org/XML/1998/namespace",!1,!1)});["tabIndex","crossOrigin"].forEach(function(a){D[a]=new B(a,1,!1,a.toLowerCase(),null,!1,!1)});
D.xlinkHref=new B("xlinkHref",1,!1,"xlink:href","http://www.w3.org/1999/xlink",!0,!1);["src","href","action","formAction"].forEach(function(a){D[a]=new B(a,1,!1,a.toLowerCase(),null,!0,!0)});
function qa(a,b,c,d){var e=D.hasOwnProperty(b)?D[b]:null;var f=null!==e?0===e.type:d?!1:!(2<b.length)||"o"!==b[0]&&"O"!==b[0]||"n"!==b[1]&&"N"!==b[1]?!1:!0;f||(na(b,c,e,d)&&(c=null),d||null===e?la(b)&&(null===c?a.removeAttribute(b):a.setAttribute(b,""+c)):e.mustUseProperty?a[e.propertyName]=null===c?3===e.type?!1:"":c:(b=e.attributeName,d=e.attributeNamespace,null===c?a.removeAttribute(b):(e=e.type,c=3===e||4===e&&!0===c?"":""+c,d?a.setAttributeNS(d,b,c):a.setAttribute(b,c))))}
var ra=aa.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED,sa=60103,ta=60106,ua=60107,wa=60108,xa=60114,ya=60109,za=60110,Aa=60112,Ba=60113,Ca=60120,Da=60115,Ea=60116,Fa=60121,Ga=60128,Ha=60129,Ia=60130,Ja=60131;
if("function"===typeof Symbol&&Symbol.for){var E=Symbol.for;sa=E("react.element");ta=E("react.portal");ua=E("react.fragment");wa=E("react.strict_mode");xa=E("react.profiler");ya=E("react.provider");za=E("react.context");Aa=E("react.forward_ref");Ba=E("react.suspense");Ca=E("react.suspense_list");Da=E("react.memo");Ea=E("react.lazy");Fa=E("react.block");E("react.scope");Ga=E("react.opaque.id");Ha=E("react.debug_trace_mode");Ia=E("react.offscreen");Ja=E("react.legacy_hidden")}
var Ka="function"===typeof Symbol&&Symbol.iterator;function La(a){if(null===a||"object"!==typeof a)return null;a=Ka&&a[Ka]||a["@@iterator"];return"function"===typeof a?a:null}var Ma;function Na(a){if(void 0===Ma)try{throw Error();}catch(c){var b=c.stack.trim().match(/\n( *(at )?)/);Ma=b&&b[1]||""}return"\n"+Ma+a}var Oa=!1;
function Pa(a,b){if(!a||Oa)return"";Oa=!0;var c=Error.prepareStackTrace;Error.prepareStackTrace=void 0;try{if(b)if(b=function(){throw Error();},Object.defineProperty(b.prototype,"props",{set:function(){throw Error();}}),"object"===typeof Reflect&&Reflect.construct){try{Reflect.construct(b,[])}catch(k){var d=k}Reflect.construct(a,[],b)}else{try{b.call()}catch(k){d=k}a.call(b.prototype)}else{try{throw Error();}catch(k){d=k}a()}}catch(k){if(k&&d&&"string"===typeof k.stack){for(var e=k.stack.split("\n"),
f=d.stack.split("\n"),g=e.length-1,h=f.length-1;1<=g&&0<=h&&e[g]!==f[h];)h--;for(;1<=g&&0<=h;g--,h--)if(e[g]!==f[h]){if(1!==g||1!==h){do if(g--,h--,0>h||e[g]!==f[h])return"\n"+e[g].replace(" at new "," at ");while(1<=g&&0<=h)}break}}}finally{Oa=!1,Error.prepareStackTrace=c}return(a=a?a.displayName||a.name:"")?Na(a):""}
function Qa(a){switch(a.tag){case 5:return Na(a.type);case 16:return Na("Lazy");case 13:return Na("Suspense");case 19:return Na("SuspenseList");case 0:case 2:case 15:return a=Pa(a.type,!1),a;case 11:return a=Pa(a.type.render,!1),a;case 22:return a=Pa(a.type._render,!1),a;case 1:return a=Pa(a.type,!0),a;default:return""}}
function Ra(a){if(null==a)return null;if("function"===typeof a)return a.displayName||a.name||null;if("string"===typeof a)return a;switch(a){case ua:return"Fragment";case ta:return"Portal";case xa:return"Profiler";case wa:return"StrictMode";case Ba:return"Suspense";case Ca:return"SuspenseList"}if("object"===typeof a)switch(a.$$typeof){case za:return(a.displayName||"Context")+".Consumer";case ya:return(a._context.displayName||"Context")+".Provider";case Aa:var b=a.render;b=b.displayName||b.name||"";
return a.displayName||(""!==b?"ForwardRef("+b+")":"ForwardRef");case Da:return Ra(a.type);case Fa:return Ra(a._render);case Ea:b=a._payload;a=a._init;try{return Ra(a(b))}catch(c){}}return null}function Sa(a){switch(typeof a){case "boolean":case "number":case "object":case "string":case "undefined":return a;default:return""}}function Ta(a){var b=a.type;return(a=a.nodeName)&&"input"===a.toLowerCase()&&("checkbox"===b||"radio"===b)}
function Ua(a){var b=Ta(a)?"checked":"value",c=Object.getOwnPropertyDescriptor(a.constructor.prototype,b),d=""+a[b];if(!a.hasOwnProperty(b)&&"undefined"!==typeof c&&"function"===typeof c.get&&"function"===typeof c.set){var e=c.get,f=c.set;Object.defineProperty(a,b,{configurable:!0,get:function(){return e.call(this)},set:function(a){d=""+a;f.call(this,a)}});Object.defineProperty(a,b,{enumerable:c.enumerable});return{getValue:function(){return d},setValue:function(a){d=""+a},stopTracking:function(){a._valueTracker=
null;delete a[b]}}}}function Va(a){a._valueTracker||(a._valueTracker=Ua(a))}function Wa(a){if(!a)return!1;var b=a._valueTracker;if(!b)return!0;var c=b.getValue();var d="";a&&(d=Ta(a)?a.checked?"true":"false":a.value);a=d;return a!==c?(b.setValue(a),!0):!1}function Xa(a){a=a||("undefined"!==typeof document?document:void 0);if("undefined"===typeof a)return null;try{return a.activeElement||a.body}catch(b){return a.body}}
function Ya(a,b){var c=b.checked;return m({},b,{defaultChecked:void 0,defaultValue:void 0,value:void 0,checked:null!=c?c:a._wrapperState.initialChecked})}function Za(a,b){var c=null==b.defaultValue?"":b.defaultValue,d=null!=b.checked?b.checked:b.defaultChecked;c=Sa(null!=b.value?b.value:c);a._wrapperState={initialChecked:d,initialValue:c,controlled:"checkbox"===b.type||"radio"===b.type?null!=b.checked:null!=b.value}}function $a(a,b){b=b.checked;null!=b&&qa(a,"checked",b,!1)}
function ab(a,b){$a(a,b);var c=Sa(b.value),d=b.type;if(null!=c)if("number"===d){if(0===c&&""===a.value||a.value!=c)a.value=""+c}else a.value!==""+c&&(a.value=""+c);else if("submit"===d||"reset"===d){a.removeAttribute("value");return}b.hasOwnProperty("value")?bb(a,b.type,c):b.hasOwnProperty("defaultValue")&&bb(a,b.type,Sa(b.defaultValue));null==b.checked&&null!=b.defaultChecked&&(a.defaultChecked=!!b.defaultChecked)}
function cb(a,b,c){if(b.hasOwnProperty("value")||b.hasOwnProperty("defaultValue")){var d=b.type;if(!("submit"!==d&&"reset"!==d||void 0!==b.value&&null!==b.value))return;b=""+a._wrapperState.initialValue;c||b===a.value||(a.value=b);a.defaultValue=b}c=a.name;""!==c&&(a.name="");a.defaultChecked=!!a._wrapperState.initialChecked;""!==c&&(a.name=c)}
function bb(a,b,c){if("number"!==b||Xa(a.ownerDocument)!==a)null==c?a.defaultValue=""+a._wrapperState.initialValue:a.defaultValue!==""+c&&(a.defaultValue=""+c)}function db(a){var b="";aa.Children.forEach(a,function(a){null!=a&&(b+=a)});return b}function eb(a,b){a=m({children:void 0},b);if(b=db(b.children))a.children=b;return a}
function fb(a,b,c,d){a=a.options;if(b){b={};for(var e=0;e<c.length;e++)b["$"+c[e]]=!0;for(c=0;c<a.length;c++)e=b.hasOwnProperty("$"+a[c].value),a[c].selected!==e&&(a[c].selected=e),e&&d&&(a[c].defaultSelected=!0)}else{c=""+Sa(c);b=null;for(e=0;e<a.length;e++){if(a[e].value===c){a[e].selected=!0;d&&(a[e].defaultSelected=!0);return}null!==b||a[e].disabled||(b=a[e])}null!==b&&(b.selected=!0)}}
function gb(a,b){if(null!=b.dangerouslySetInnerHTML)throw Error(y(91));return m({},b,{value:void 0,defaultValue:void 0,children:""+a._wrapperState.initialValue})}function hb(a,b){var c=b.value;if(null==c){c=b.children;b=b.defaultValue;if(null!=c){if(null!=b)throw Error(y(92));if(Array.isArray(c)){if(!(1>=c.length))throw Error(y(93));c=c[0]}b=c}null==b&&(b="");c=b}a._wrapperState={initialValue:Sa(c)}}
function ib(a,b){var c=Sa(b.value),d=Sa(b.defaultValue);null!=c&&(c=""+c,c!==a.value&&(a.value=c),null==b.defaultValue&&a.defaultValue!==c&&(a.defaultValue=c));null!=d&&(a.defaultValue=""+d)}function jb(a){var b=a.textContent;b===a._wrapperState.initialValue&&""!==b&&null!==b&&(a.value=b)}var kb={html:"http://www.w3.org/1999/xhtml",mathml:"http://www.w3.org/1998/Math/MathML",svg:"http://www.w3.org/2000/svg"};
function lb(a){switch(a){case "svg":return"http://www.w3.org/2000/svg";case "math":return"http://www.w3.org/1998/Math/MathML";default:return"http://www.w3.org/1999/xhtml"}}function mb(a,b){return null==a||"http://www.w3.org/1999/xhtml"===a?lb(b):"http://www.w3.org/2000/svg"===a&&"foreignObject"===b?"http://www.w3.org/1999/xhtml":a}
var nb,ob=function(a){return"undefined"!==typeof MSApp&&MSApp.execUnsafeLocalFunction?function(b,c,d,e){MSApp.execUnsafeLocalFunction(function(){return a(b,c,d,e)})}:a}(function(a,b){if(a.namespaceURI!==kb.svg||"innerHTML"in a)a.innerHTML=b;else{nb=nb||document.createElement("div");nb.innerHTML="<svg>"+b.valueOf().toString()+"</svg>";for(b=nb.firstChild;a.firstChild;)a.removeChild(a.firstChild);for(;b.firstChild;)a.appendChild(b.firstChild)}});
function pb(a,b){if(b){var c=a.firstChild;if(c&&c===a.lastChild&&3===c.nodeType){c.nodeValue=b;return}}a.textContent=b}
var qb={animationIterationCount:!0,borderImageOutset:!0,borderImageSlice:!0,borderImageWidth:!0,boxFlex:!0,boxFlexGroup:!0,boxOrdinalGroup:!0,columnCount:!0,columns:!0,flex:!0,flexGrow:!0,flexPositive:!0,flexShrink:!0,flexNegative:!0,flexOrder:!0,gridArea:!0,gridRow:!0,gridRowEnd:!0,gridRowSpan:!0,gridRowStart:!0,gridColumn:!0,gridColumnEnd:!0,gridColumnSpan:!0,gridColumnStart:!0,fontWeight:!0,lineClamp:!0,lineHeight:!0,opacity:!0,order:!0,orphans:!0,tabSize:!0,widows:!0,zIndex:!0,zoom:!0,fillOpacity:!0,
floodOpacity:!0,stopOpacity:!0,strokeDasharray:!0,strokeDashoffset:!0,strokeMiterlimit:!0,strokeOpacity:!0,strokeWidth:!0},rb=["Webkit","ms","Moz","O"];Object.keys(qb).forEach(function(a){rb.forEach(function(b){b=b+a.charAt(0).toUpperCase()+a.substring(1);qb[b]=qb[a]})});function sb(a,b,c){return null==b||"boolean"===typeof b||""===b?"":c||"number"!==typeof b||0===b||qb.hasOwnProperty(a)&&qb[a]?(""+b).trim():b+"px"}
function tb(a,b){a=a.style;for(var c in b)if(b.hasOwnProperty(c)){var d=0===c.indexOf("--"),e=sb(c,b[c],d);"float"===c&&(c="cssFloat");d?a.setProperty(c,e):a[c]=e}}var ub=m({menuitem:!0},{area:!0,base:!0,br:!0,col:!0,embed:!0,hr:!0,img:!0,input:!0,keygen:!0,link:!0,meta:!0,param:!0,source:!0,track:!0,wbr:!0});
function vb(a,b){if(b){if(ub[a]&&(null!=b.children||null!=b.dangerouslySetInnerHTML))throw Error(y(137,a));if(null!=b.dangerouslySetInnerHTML){if(null!=b.children)throw Error(y(60));if(!("object"===typeof b.dangerouslySetInnerHTML&&"__html"in b.dangerouslySetInnerHTML))throw Error(y(61));}if(null!=b.style&&"object"!==typeof b.style)throw Error(y(62));}}
function wb(a,b){if(-1===a.indexOf("-"))return"string"===typeof b.is;switch(a){case "annotation-xml":case "color-profile":case "font-face":case "font-face-src":case "font-face-uri":case "font-face-format":case "font-face-name":case "missing-glyph":return!1;default:return!0}}function xb(a){a=a.target||a.srcElement||window;a.correspondingUseElement&&(a=a.correspondingUseElement);return 3===a.nodeType?a.parentNode:a}var yb=null,zb=null,Ab=null;
function Bb(a){if(a=Cb(a)){if("function"!==typeof yb)throw Error(y(280));var b=a.stateNode;b&&(b=Db(b),yb(a.stateNode,a.type,b))}}function Eb(a){zb?Ab?Ab.push(a):Ab=[a]:zb=a}function Fb(){if(zb){var a=zb,b=Ab;Ab=zb=null;Bb(a);if(b)for(a=0;a<b.length;a++)Bb(b[a])}}function Gb(a,b){return a(b)}function Hb(a,b,c,d,e){return a(b,c,d,e)}function Ib(){}var Jb=Gb,Kb=!1,Lb=!1;function Mb(){if(null!==zb||null!==Ab)Ib(),Fb()}
function Nb(a,b,c){if(Lb)return a(b,c);Lb=!0;try{return Jb(a,b,c)}finally{Lb=!1,Mb()}}
function Ob(a,b){var c=a.stateNode;if(null===c)return null;var d=Db(c);if(null===d)return null;c=d[b];a:switch(b){case "onClick":case "onClickCapture":case "onDoubleClick":case "onDoubleClickCapture":case "onMouseDown":case "onMouseDownCapture":case "onMouseMove":case "onMouseMoveCapture":case "onMouseUp":case "onMouseUpCapture":case "onMouseEnter":(d=!d.disabled)||(a=a.type,d=!("button"===a||"input"===a||"select"===a||"textarea"===a));a=!d;break a;default:a=!1}if(a)return null;if(c&&"function"!==
typeof c)throw Error(y(231,b,typeof c));return c}var Pb=!1;if(fa)try{var Qb={};Object.defineProperty(Qb,"passive",{get:function(){Pb=!0}});window.addEventListener("test",Qb,Qb);window.removeEventListener("test",Qb,Qb)}catch(a){Pb=!1}function Rb(a,b,c,d,e,f,g,h,k){var l=Array.prototype.slice.call(arguments,3);try{b.apply(c,l)}catch(n){this.onError(n)}}var Sb=!1,Tb=null,Ub=!1,Vb=null,Wb={onError:function(a){Sb=!0;Tb=a}};function Xb(a,b,c,d,e,f,g,h,k){Sb=!1;Tb=null;Rb.apply(Wb,arguments)}
function Yb(a,b,c,d,e,f,g,h,k){Xb.apply(this,arguments);if(Sb){if(Sb){var l=Tb;Sb=!1;Tb=null}else throw Error(y(198));Ub||(Ub=!0,Vb=l)}}function Zb(a){var b=a,c=a;if(a.alternate)for(;b.return;)b=b.return;else{a=b;do b=a,0!==(b.flags&1026)&&(c=b.return),a=b.return;while(a)}return 3===b.tag?c:null}function $b(a){if(13===a.tag){var b=a.memoizedState;null===b&&(a=a.alternate,null!==a&&(b=a.memoizedState));if(null!==b)return b.dehydrated}return null}function ac(a){if(Zb(a)!==a)throw Error(y(188));}
function bc(a){var b=a.alternate;if(!b){b=Zb(a);if(null===b)throw Error(y(188));return b!==a?null:a}for(var c=a,d=b;;){var e=c.return;if(null===e)break;var f=e.alternate;if(null===f){d=e.return;if(null!==d){c=d;continue}break}if(e.child===f.child){for(f=e.child;f;){if(f===c)return ac(e),a;if(f===d)return ac(e),b;f=f.sibling}throw Error(y(188));}if(c.return!==d.return)c=e,d=f;else{for(var g=!1,h=e.child;h;){if(h===c){g=!0;c=e;d=f;break}if(h===d){g=!0;d=e;c=f;break}h=h.sibling}if(!g){for(h=f.child;h;){if(h===
c){g=!0;c=f;d=e;break}if(h===d){g=!0;d=f;c=e;break}h=h.sibling}if(!g)throw Error(y(189));}}if(c.alternate!==d)throw Error(y(190));}if(3!==c.tag)throw Error(y(188));return c.stateNode.current===c?a:b}function cc(a){a=bc(a);if(!a)return null;for(var b=a;;){if(5===b.tag||6===b.tag)return b;if(b.child)b.child.return=b,b=b.child;else{if(b===a)break;for(;!b.sibling;){if(!b.return||b.return===a)return null;b=b.return}b.sibling.return=b.return;b=b.sibling}}return null}
function dc(a,b){for(var c=a.alternate;null!==b;){if(b===a||b===c)return!0;b=b.return}return!1}var ec,fc,gc,hc,ic=!1,jc=[],kc=null,lc=null,mc=null,nc=new Map,oc=new Map,pc=[],qc="mousedown mouseup touchcancel touchend touchstart auxclick dblclick pointercancel pointerdown pointerup dragend dragstart drop compositionend compositionstart keydown keypress keyup input textInput copy cut paste click change contextmenu reset submit".split(" ");
function rc(a,b,c,d,e){return{blockedOn:a,domEventName:b,eventSystemFlags:c|16,nativeEvent:e,targetContainers:[d]}}function sc(a,b){switch(a){case "focusin":case "focusout":kc=null;break;case "dragenter":case "dragleave":lc=null;break;case "mouseover":case "mouseout":mc=null;break;case "pointerover":case "pointerout":nc.delete(b.pointerId);break;case "gotpointercapture":case "lostpointercapture":oc.delete(b.pointerId)}}
function tc(a,b,c,d,e,f){if(null===a||a.nativeEvent!==f)return a=rc(b,c,d,e,f),null!==b&&(b=Cb(b),null!==b&&fc(b)),a;a.eventSystemFlags|=d;b=a.targetContainers;null!==e&&-1===b.indexOf(e)&&b.push(e);return a}
function uc(a,b,c,d,e){switch(b){case "focusin":return kc=tc(kc,a,b,c,d,e),!0;case "dragenter":return lc=tc(lc,a,b,c,d,e),!0;case "mouseover":return mc=tc(mc,a,b,c,d,e),!0;case "pointerover":var f=e.pointerId;nc.set(f,tc(nc.get(f)||null,a,b,c,d,e));return!0;case "gotpointercapture":return f=e.pointerId,oc.set(f,tc(oc.get(f)||null,a,b,c,d,e)),!0}return!1}
function vc(a){var b=wc(a.target);if(null!==b){var c=Zb(b);if(null!==c)if(b=c.tag,13===b){if(b=$b(c),null!==b){a.blockedOn=b;hc(a.lanePriority,function(){r.unstable_runWithPriority(a.priority,function(){gc(c)})});return}}else if(3===b&&c.stateNode.hydrate){a.blockedOn=3===c.tag?c.stateNode.containerInfo:null;return}}a.blockedOn=null}
function xc(a){if(null!==a.blockedOn)return!1;for(var b=a.targetContainers;0<b.length;){var c=yc(a.domEventName,a.eventSystemFlags,b[0],a.nativeEvent);if(null!==c)return b=Cb(c),null!==b&&fc(b),a.blockedOn=c,!1;b.shift()}return!0}function zc(a,b,c){xc(a)&&c.delete(b)}
function Ac(){for(ic=!1;0<jc.length;){var a=jc[0];if(null!==a.blockedOn){a=Cb(a.blockedOn);null!==a&&ec(a);break}for(var b=a.targetContainers;0<b.length;){var c=yc(a.domEventName,a.eventSystemFlags,b[0],a.nativeEvent);if(null!==c){a.blockedOn=c;break}b.shift()}null===a.blockedOn&&jc.shift()}null!==kc&&xc(kc)&&(kc=null);null!==lc&&xc(lc)&&(lc=null);null!==mc&&xc(mc)&&(mc=null);nc.forEach(zc);oc.forEach(zc)}
function Bc(a,b){a.blockedOn===b&&(a.blockedOn=null,ic||(ic=!0,r.unstable_scheduleCallback(r.unstable_NormalPriority,Ac)))}
function Cc(a){function b(b){return Bc(b,a)}if(0<jc.length){Bc(jc[0],a);for(var c=1;c<jc.length;c++){var d=jc[c];d.blockedOn===a&&(d.blockedOn=null)}}null!==kc&&Bc(kc,a);null!==lc&&Bc(lc,a);null!==mc&&Bc(mc,a);nc.forEach(b);oc.forEach(b);for(c=0;c<pc.length;c++)d=pc[c],d.blockedOn===a&&(d.blockedOn=null);for(;0<pc.length&&(c=pc[0],null===c.blockedOn);)vc(c),null===c.blockedOn&&pc.shift()}
function Dc(a,b){var c={};c[a.toLowerCase()]=b.toLowerCase();c["Webkit"+a]="webkit"+b;c["Moz"+a]="moz"+b;return c}var Ec={animationend:Dc("Animation","AnimationEnd"),animationiteration:Dc("Animation","AnimationIteration"),animationstart:Dc("Animation","AnimationStart"),transitionend:Dc("Transition","TransitionEnd")},Fc={},Gc={};
fa&&(Gc=document.createElement("div").style,"AnimationEvent"in window||(delete Ec.animationend.animation,delete Ec.animationiteration.animation,delete Ec.animationstart.animation),"TransitionEvent"in window||delete Ec.transitionend.transition);function Hc(a){if(Fc[a])return Fc[a];if(!Ec[a])return a;var b=Ec[a],c;for(c in b)if(b.hasOwnProperty(c)&&c in Gc)return Fc[a]=b[c];return a}
var Ic=Hc("animationend"),Jc=Hc("animationiteration"),Kc=Hc("animationstart"),Lc=Hc("transitionend"),Mc=new Map,Nc=new Map,Oc=["abort","abort",Ic,"animationEnd",Jc,"animationIteration",Kc,"animationStart","canplay","canPlay","canplaythrough","canPlayThrough","durationchange","durationChange","emptied","emptied","encrypted","encrypted","ended","ended","error","error","gotpointercapture","gotPointerCapture","load","load","loadeddata","loadedData","loadedmetadata","loadedMetadata","loadstart","loadStart",
"lostpointercapture","lostPointerCapture","playing","playing","progress","progress","seeking","seeking","stalled","stalled","suspend","suspend","timeupdate","timeUpdate",Lc,"transitionEnd","waiting","waiting"];function Pc(a,b){for(var c=0;c<a.length;c+=2){var d=a[c],e=a[c+1];e="on"+(e[0].toUpperCase()+e.slice(1));Nc.set(d,b);Mc.set(d,e);da(e,[d])}}var Qc=r.unstable_now;Qc();var F=8;
function Rc(a){if(0!==(1&a))return F=15,1;if(0!==(2&a))return F=14,2;if(0!==(4&a))return F=13,4;var b=24&a;if(0!==b)return F=12,b;if(0!==(a&32))return F=11,32;b=192&a;if(0!==b)return F=10,b;if(0!==(a&256))return F=9,256;b=3584&a;if(0!==b)return F=8,b;if(0!==(a&4096))return F=7,4096;b=4186112&a;if(0!==b)return F=6,b;b=62914560&a;if(0!==b)return F=5,b;if(a&67108864)return F=4,67108864;if(0!==(a&134217728))return F=3,134217728;b=805306368&a;if(0!==b)return F=2,b;if(0!==(1073741824&a))return F=1,1073741824;
F=8;return a}function Sc(a){switch(a){case 99:return 15;case 98:return 10;case 97:case 96:return 8;case 95:return 2;default:return 0}}function Tc(a){switch(a){case 15:case 14:return 99;case 13:case 12:case 11:case 10:return 98;case 9:case 8:case 7:case 6:case 4:case 5:return 97;case 3:case 2:case 1:return 95;case 0:return 90;default:throw Error(y(358,a));}}
function Uc(a,b){var c=a.pendingLanes;if(0===c)return F=0;var d=0,e=0,f=a.expiredLanes,g=a.suspendedLanes,h=a.pingedLanes;if(0!==f)d=f,e=F=15;else if(f=c&134217727,0!==f){var k=f&~g;0!==k?(d=Rc(k),e=F):(h&=f,0!==h&&(d=Rc(h),e=F))}else f=c&~g,0!==f?(d=Rc(f),e=F):0!==h&&(d=Rc(h),e=F);if(0===d)return 0;d=31-Vc(d);d=c&((0>d?0:1<<d)<<1)-1;if(0!==b&&b!==d&&0===(b&g)){Rc(b);if(e<=F)return b;F=e}b=a.entangledLanes;if(0!==b)for(a=a.entanglements,b&=d;0<b;)c=31-Vc(b),e=1<<c,d|=a[c],b&=~e;return d}
function Wc(a){a=a.pendingLanes&-1073741825;return 0!==a?a:a&1073741824?1073741824:0}function Xc(a,b){switch(a){case 15:return 1;case 14:return 2;case 12:return a=Yc(24&~b),0===a?Xc(10,b):a;case 10:return a=Yc(192&~b),0===a?Xc(8,b):a;case 8:return a=Yc(3584&~b),0===a&&(a=Yc(4186112&~b),0===a&&(a=512)),a;case 2:return b=Yc(805306368&~b),0===b&&(b=268435456),b}throw Error(y(358,a));}function Yc(a){return a&-a}function Zc(a){for(var b=[],c=0;31>c;c++)b.push(a);return b}
function $c(a,b,c){a.pendingLanes|=b;var d=b-1;a.suspendedLanes&=d;a.pingedLanes&=d;a=a.eventTimes;b=31-Vc(b);a[b]=c}var Vc=Math.clz32?Math.clz32:ad,bd=Math.log,cd=Math.LN2;function ad(a){return 0===a?32:31-(bd(a)/cd|0)|0}var dd=r.unstable_UserBlockingPriority,ed=r.unstable_runWithPriority,fd=!0;function gd(a,b,c,d){Kb||Ib();var e=hd,f=Kb;Kb=!0;try{Hb(e,a,b,c,d)}finally{(Kb=f)||Mb()}}function id(a,b,c,d){ed(dd,hd.bind(null,a,b,c,d))}
function hd(a,b,c,d){if(fd){var e;if((e=0===(b&4))&&0<jc.length&&-1<qc.indexOf(a))a=rc(null,a,b,c,d),jc.push(a);else{var f=yc(a,b,c,d);if(null===f)e&&sc(a,d);else{if(e){if(-1<qc.indexOf(a)){a=rc(f,a,b,c,d);jc.push(a);return}if(uc(f,a,b,c,d))return;sc(a,d)}jd(a,b,d,null,c)}}}}
function yc(a,b,c,d){var e=xb(d);e=wc(e);if(null!==e){var f=Zb(e);if(null===f)e=null;else{var g=f.tag;if(13===g){e=$b(f);if(null!==e)return e;e=null}else if(3===g){if(f.stateNode.hydrate)return 3===f.tag?f.stateNode.containerInfo:null;e=null}else f!==e&&(e=null)}}jd(a,b,d,e,c);return null}var kd=null,ld=null,md=null;
function nd(){if(md)return md;var a,b=ld,c=b.length,d,e="value"in kd?kd.value:kd.textContent,f=e.length;for(a=0;a<c&&b[a]===e[a];a++);var g=c-a;for(d=1;d<=g&&b[c-d]===e[f-d];d++);return md=e.slice(a,1<d?1-d:void 0)}function od(a){var b=a.keyCode;"charCode"in a?(a=a.charCode,0===a&&13===b&&(a=13)):a=b;10===a&&(a=13);return 32<=a||13===a?a:0}function pd(){return!0}function qd(){return!1}
function rd(a){function b(b,d,e,f,g){this._reactName=b;this._targetInst=e;this.type=d;this.nativeEvent=f;this.target=g;this.currentTarget=null;for(var c in a)a.hasOwnProperty(c)&&(b=a[c],this[c]=b?b(f):f[c]);this.isDefaultPrevented=(null!=f.defaultPrevented?f.defaultPrevented:!1===f.returnValue)?pd:qd;this.isPropagationStopped=qd;return this}m(b.prototype,{preventDefault:function(){this.defaultPrevented=!0;var a=this.nativeEvent;a&&(a.preventDefault?a.preventDefault():"unknown"!==typeof a.returnValue&&
(a.returnValue=!1),this.isDefaultPrevented=pd)},stopPropagation:function(){var a=this.nativeEvent;a&&(a.stopPropagation?a.stopPropagation():"unknown"!==typeof a.cancelBubble&&(a.cancelBubble=!0),this.isPropagationStopped=pd)},persist:function(){},isPersistent:pd});return b}
var sd={eventPhase:0,bubbles:0,cancelable:0,timeStamp:function(a){return a.timeStamp||Date.now()},defaultPrevented:0,isTrusted:0},td=rd(sd),ud=m({},sd,{view:0,detail:0}),vd=rd(ud),wd,xd,yd,Ad=m({},ud,{screenX:0,screenY:0,clientX:0,clientY:0,pageX:0,pageY:0,ctrlKey:0,shiftKey:0,altKey:0,metaKey:0,getModifierState:zd,button:0,buttons:0,relatedTarget:function(a){return void 0===a.relatedTarget?a.fromElement===a.srcElement?a.toElement:a.fromElement:a.relatedTarget},movementX:function(a){if("movementX"in
a)return a.movementX;a!==yd&&(yd&&"mousemove"===a.type?(wd=a.screenX-yd.screenX,xd=a.screenY-yd.screenY):xd=wd=0,yd=a);return wd},movementY:function(a){return"movementY"in a?a.movementY:xd}}),Bd=rd(Ad),Cd=m({},Ad,{dataTransfer:0}),Dd=rd(Cd),Ed=m({},ud,{relatedTarget:0}),Fd=rd(Ed),Gd=m({},sd,{animationName:0,elapsedTime:0,pseudoElement:0}),Hd=rd(Gd),Id=m({},sd,{clipboardData:function(a){return"clipboardData"in a?a.clipboardData:window.clipboardData}}),Jd=rd(Id),Kd=m({},sd,{data:0}),Ld=rd(Kd),Md={Esc:"Escape",
Spacebar:" ",Left:"ArrowLeft",Up:"ArrowUp",Right:"ArrowRight",Down:"ArrowDown",Del:"Delete",Win:"OS",Menu:"ContextMenu",Apps:"ContextMenu",Scroll:"ScrollLock",MozPrintableKey:"Unidentified"},Nd={8:"Backspace",9:"Tab",12:"Clear",13:"Enter",16:"Shift",17:"Control",18:"Alt",19:"Pause",20:"CapsLock",27:"Escape",32:" ",33:"PageUp",34:"PageDown",35:"End",36:"Home",37:"ArrowLeft",38:"ArrowUp",39:"ArrowRight",40:"ArrowDown",45:"Insert",46:"Delete",112:"F1",113:"F2",114:"F3",115:"F4",116:"F5",117:"F6",118:"F7",
119:"F8",120:"F9",121:"F10",122:"F11",123:"F12",144:"NumLock",145:"ScrollLock",224:"Meta"},Od={Alt:"altKey",Control:"ctrlKey",Meta:"metaKey",Shift:"shiftKey"};function Pd(a){var b=this.nativeEvent;return b.getModifierState?b.getModifierState(a):(a=Od[a])?!!b[a]:!1}function zd(){return Pd}
var Qd=m({},ud,{key:function(a){if(a.key){var b=Md[a.key]||a.key;if("Unidentified"!==b)return b}return"keypress"===a.type?(a=od(a),13===a?"Enter":String.fromCharCode(a)):"keydown"===a.type||"keyup"===a.type?Nd[a.keyCode]||"Unidentified":""},code:0,location:0,ctrlKey:0,shiftKey:0,altKey:0,metaKey:0,repeat:0,locale:0,getModifierState:zd,charCode:function(a){return"keypress"===a.type?od(a):0},keyCode:function(a){return"keydown"===a.type||"keyup"===a.type?a.keyCode:0},which:function(a){return"keypress"===
a.type?od(a):"keydown"===a.type||"keyup"===a.type?a.keyCode:0}}),Rd=rd(Qd),Sd=m({},Ad,{pointerId:0,width:0,height:0,pressure:0,tangentialPressure:0,tiltX:0,tiltY:0,twist:0,pointerType:0,isPrimary:0}),Td=rd(Sd),Ud=m({},ud,{touches:0,targetTouches:0,changedTouches:0,altKey:0,metaKey:0,ctrlKey:0,shiftKey:0,getModifierState:zd}),Vd=rd(Ud),Wd=m({},sd,{propertyName:0,elapsedTime:0,pseudoElement:0}),Xd=rd(Wd),Yd=m({},Ad,{deltaX:function(a){return"deltaX"in a?a.deltaX:"wheelDeltaX"in a?-a.wheelDeltaX:0},
deltaY:function(a){return"deltaY"in a?a.deltaY:"wheelDeltaY"in a?-a.wheelDeltaY:"wheelDelta"in a?-a.wheelDelta:0},deltaZ:0,deltaMode:0}),Zd=rd(Yd),$d=[9,13,27,32],ae=fa&&"CompositionEvent"in window,be=null;fa&&"documentMode"in document&&(be=document.documentMode);var ce=fa&&"TextEvent"in window&&!be,de=fa&&(!ae||be&&8<be&&11>=be),ee=String.fromCharCode(32),fe=!1;
function ge(a,b){switch(a){case "keyup":return-1!==$d.indexOf(b.keyCode);case "keydown":return 229!==b.keyCode;case "keypress":case "mousedown":case "focusout":return!0;default:return!1}}function he(a){a=a.detail;return"object"===typeof a&&"data"in a?a.data:null}var ie=!1;function je(a,b){switch(a){case "compositionend":return he(b);case "keypress":if(32!==b.which)return null;fe=!0;return ee;case "textInput":return a=b.data,a===ee&&fe?null:a;default:return null}}
function ke(a,b){if(ie)return"compositionend"===a||!ae&&ge(a,b)?(a=nd(),md=ld=kd=null,ie=!1,a):null;switch(a){case "paste":return null;case "keypress":if(!(b.ctrlKey||b.altKey||b.metaKey)||b.ctrlKey&&b.altKey){if(b.char&&1<b.char.length)return b.char;if(b.which)return String.fromCharCode(b.which)}return null;case "compositionend":return de&&"ko"!==b.locale?null:b.data;default:return null}}
var le={color:!0,date:!0,datetime:!0,"datetime-local":!0,email:!0,month:!0,number:!0,password:!0,range:!0,search:!0,tel:!0,text:!0,time:!0,url:!0,week:!0};function me(a){var b=a&&a.nodeName&&a.nodeName.toLowerCase();return"input"===b?!!le[a.type]:"textarea"===b?!0:!1}function ne(a,b,c,d){Eb(d);b=oe(b,"onChange");0<b.length&&(c=new td("onChange","change",null,c,d),a.push({event:c,listeners:b}))}var pe=null,qe=null;function re(a){se(a,0)}function te(a){var b=ue(a);if(Wa(b))return a}
function ve(a,b){if("change"===a)return b}var we=!1;if(fa){var xe;if(fa){var ye="oninput"in document;if(!ye){var ze=document.createElement("div");ze.setAttribute("oninput","return;");ye="function"===typeof ze.oninput}xe=ye}else xe=!1;we=xe&&(!document.documentMode||9<document.documentMode)}function Ae(){pe&&(pe.detachEvent("onpropertychange",Be),qe=pe=null)}function Be(a){if("value"===a.propertyName&&te(qe)){var b=[];ne(b,qe,a,xb(a));a=re;if(Kb)a(b);else{Kb=!0;try{Gb(a,b)}finally{Kb=!1,Mb()}}}}
function Ce(a,b,c){"focusin"===a?(Ae(),pe=b,qe=c,pe.attachEvent("onpropertychange",Be)):"focusout"===a&&Ae()}function De(a){if("selectionchange"===a||"keyup"===a||"keydown"===a)return te(qe)}function Ee(a,b){if("click"===a)return te(b)}function Fe(a,b){if("input"===a||"change"===a)return te(b)}function Ge(a,b){return a===b&&(0!==a||1/a===1/b)||a!==a&&b!==b}var He="function"===typeof Object.is?Object.is:Ge,Ie=Object.prototype.hasOwnProperty;
function Je(a,b){if(He(a,b))return!0;if("object"!==typeof a||null===a||"object"!==typeof b||null===b)return!1;var c=Object.keys(a),d=Object.keys(b);if(c.length!==d.length)return!1;for(d=0;d<c.length;d++)if(!Ie.call(b,c[d])||!He(a[c[d]],b[c[d]]))return!1;return!0}function Ke(a){for(;a&&a.firstChild;)a=a.firstChild;return a}
function Le(a,b){var c=Ke(a);a=0;for(var d;c;){if(3===c.nodeType){d=a+c.textContent.length;if(a<=b&&d>=b)return{node:c,offset:b-a};a=d}a:{for(;c;){if(c.nextSibling){c=c.nextSibling;break a}c=c.parentNode}c=void 0}c=Ke(c)}}function Me(a,b){return a&&b?a===b?!0:a&&3===a.nodeType?!1:b&&3===b.nodeType?Me(a,b.parentNode):"contains"in a?a.contains(b):a.compareDocumentPosition?!!(a.compareDocumentPosition(b)&16):!1:!1}
function Ne(){for(var a=window,b=Xa();b instanceof a.HTMLIFrameElement;){try{var c="string"===typeof b.contentWindow.location.href}catch(d){c=!1}if(c)a=b.contentWindow;else break;b=Xa(a.document)}return b}function Oe(a){var b=a&&a.nodeName&&a.nodeName.toLowerCase();return b&&("input"===b&&("text"===a.type||"search"===a.type||"tel"===a.type||"url"===a.type||"password"===a.type)||"textarea"===b||"true"===a.contentEditable)}
var Pe=fa&&"documentMode"in document&&11>=document.documentMode,Qe=null,Re=null,Se=null,Te=!1;
function Ue(a,b,c){var d=c.window===c?c.document:9===c.nodeType?c:c.ownerDocument;Te||null==Qe||Qe!==Xa(d)||(d=Qe,"selectionStart"in d&&Oe(d)?d={start:d.selectionStart,end:d.selectionEnd}:(d=(d.ownerDocument&&d.ownerDocument.defaultView||window).getSelection(),d={anchorNode:d.anchorNode,anchorOffset:d.anchorOffset,focusNode:d.focusNode,focusOffset:d.focusOffset}),Se&&Je(Se,d)||(Se=d,d=oe(Re,"onSelect"),0<d.length&&(b=new td("onSelect","select",null,b,c),a.push({event:b,listeners:d}),b.target=Qe)))}
Pc("cancel cancel click click close close contextmenu contextMenu copy copy cut cut auxclick auxClick dblclick doubleClick dragend dragEnd dragstart dragStart drop drop focusin focus focusout blur input input invalid invalid keydown keyDown keypress keyPress keyup keyUp mousedown mouseDown mouseup mouseUp paste paste pause pause play play pointercancel pointerCancel pointerdown pointerDown pointerup pointerUp ratechange rateChange reset reset seeked seeked submit submit touchcancel touchCancel touchend touchEnd touchstart touchStart volumechange volumeChange".split(" "),
0);Pc("drag drag dragenter dragEnter dragexit dragExit dragleave dragLeave dragover dragOver mousemove mouseMove mouseout mouseOut mouseover mouseOver pointermove pointerMove pointerout pointerOut pointerover pointerOver scroll scroll toggle toggle touchmove touchMove wheel wheel".split(" "),1);Pc(Oc,2);for(var Ve="change selectionchange textInput compositionstart compositionend compositionupdate".split(" "),We=0;We<Ve.length;We++)Nc.set(Ve[We],0);ea("onMouseEnter",["mouseout","mouseover"]);
ea("onMouseLeave",["mouseout","mouseover"]);ea("onPointerEnter",["pointerout","pointerover"]);ea("onPointerLeave",["pointerout","pointerover"]);da("onChange","change click focusin focusout input keydown keyup selectionchange".split(" "));da("onSelect","focusout contextmenu dragend focusin keydown keyup mousedown mouseup selectionchange".split(" "));da("onBeforeInput",["compositionend","keypress","textInput","paste"]);da("onCompositionEnd","compositionend focusout keydown keypress keyup mousedown".split(" "));
da("onCompositionStart","compositionstart focusout keydown keypress keyup mousedown".split(" "));da("onCompositionUpdate","compositionupdate focusout keydown keypress keyup mousedown".split(" "));var Xe="abort canplay canplaythrough durationchange emptied encrypted ended error loadeddata loadedmetadata loadstart pause play playing progress ratechange seeked seeking stalled suspend timeupdate volumechange waiting".split(" "),Ye=new Set("cancel close invalid load scroll toggle".split(" ").concat(Xe));
function Ze(a,b,c){var d=a.type||"unknown-event";a.currentTarget=c;Yb(d,b,void 0,a);a.currentTarget=null}
function se(a,b){b=0!==(b&4);for(var c=0;c<a.length;c++){var d=a[c],e=d.event;d=d.listeners;a:{var f=void 0;if(b)for(var g=d.length-1;0<=g;g--){var h=d[g],k=h.instance,l=h.currentTarget;h=h.listener;if(k!==f&&e.isPropagationStopped())break a;Ze(e,h,l);f=k}else for(g=0;g<d.length;g++){h=d[g];k=h.instance;l=h.currentTarget;h=h.listener;if(k!==f&&e.isPropagationStopped())break a;Ze(e,h,l);f=k}}}if(Ub)throw a=Vb,Ub=!1,Vb=null,a;}
function G(a,b){var c=$e(b),d=a+"__bubble";c.has(d)||(af(b,a,2,!1),c.add(d))}var bf="_reactListening"+Math.random().toString(36).slice(2);function cf(a){a[bf]||(a[bf]=!0,ba.forEach(function(b){Ye.has(b)||df(b,!1,a,null);df(b,!0,a,null)}))}
function df(a,b,c,d){var e=4<arguments.length&&void 0!==arguments[4]?arguments[4]:0,f=c;"selectionchange"===a&&9!==c.nodeType&&(f=c.ownerDocument);if(null!==d&&!b&&Ye.has(a)){if("scroll"!==a)return;e|=2;f=d}var g=$e(f),h=a+"__"+(b?"capture":"bubble");g.has(h)||(b&&(e|=4),af(f,a,e,b),g.add(h))}
function af(a,b,c,d){var e=Nc.get(b);switch(void 0===e?2:e){case 0:e=gd;break;case 1:e=id;break;default:e=hd}c=e.bind(null,b,c,a);e=void 0;!Pb||"touchstart"!==b&&"touchmove"!==b&&"wheel"!==b||(e=!0);d?void 0!==e?a.addEventListener(b,c,{capture:!0,passive:e}):a.addEventListener(b,c,!0):void 0!==e?a.addEventListener(b,c,{passive:e}):a.addEventListener(b,c,!1)}
function jd(a,b,c,d,e){var f=d;if(0===(b&1)&&0===(b&2)&&null!==d)a:for(;;){if(null===d)return;var g=d.tag;if(3===g||4===g){var h=d.stateNode.containerInfo;if(h===e||8===h.nodeType&&h.parentNode===e)break;if(4===g)for(g=d.return;null!==g;){var k=g.tag;if(3===k||4===k)if(k=g.stateNode.containerInfo,k===e||8===k.nodeType&&k.parentNode===e)return;g=g.return}for(;null!==h;){g=wc(h);if(null===g)return;k=g.tag;if(5===k||6===k){d=f=g;continue a}h=h.parentNode}}d=d.return}Nb(function(){var d=f,e=xb(c),g=[];
a:{var h=Mc.get(a);if(void 0!==h){var k=td,x=a;switch(a){case "keypress":if(0===od(c))break a;case "keydown":case "keyup":k=Rd;break;case "focusin":x="focus";k=Fd;break;case "focusout":x="blur";k=Fd;break;case "beforeblur":case "afterblur":k=Fd;break;case "click":if(2===c.button)break a;case "auxclick":case "dblclick":case "mousedown":case "mousemove":case "mouseup":case "mouseout":case "mouseover":case "contextmenu":k=Bd;break;case "drag":case "dragend":case "dragenter":case "dragexit":case "dragleave":case "dragover":case "dragstart":case "drop":k=
Dd;break;case "touchcancel":case "touchend":case "touchmove":case "touchstart":k=Vd;break;case Ic:case Jc:case Kc:k=Hd;break;case Lc:k=Xd;break;case "scroll":k=vd;break;case "wheel":k=Zd;break;case "copy":case "cut":case "paste":k=Jd;break;case "gotpointercapture":case "lostpointercapture":case "pointercancel":case "pointerdown":case "pointermove":case "pointerout":case "pointerover":case "pointerup":k=Td}var w=0!==(b&4),z=!w&&"scroll"===a,u=w?null!==h?h+"Capture":null:h;w=[];for(var t=d,q;null!==
t;){q=t;var v=q.stateNode;5===q.tag&&null!==v&&(q=v,null!==u&&(v=Ob(t,u),null!=v&&w.push(ef(t,v,q))));if(z)break;t=t.return}0<w.length&&(h=new k(h,x,null,c,e),g.push({event:h,listeners:w}))}}if(0===(b&7)){a:{h="mouseover"===a||"pointerover"===a;k="mouseout"===a||"pointerout"===a;if(h&&0===(b&16)&&(x=c.relatedTarget||c.fromElement)&&(wc(x)||x[ff]))break a;if(k||h){h=e.window===e?e:(h=e.ownerDocument)?h.defaultView||h.parentWindow:window;if(k){if(x=c.relatedTarget||c.toElement,k=d,x=x?wc(x):null,null!==
x&&(z=Zb(x),x!==z||5!==x.tag&&6!==x.tag))x=null}else k=null,x=d;if(k!==x){w=Bd;v="onMouseLeave";u="onMouseEnter";t="mouse";if("pointerout"===a||"pointerover"===a)w=Td,v="onPointerLeave",u="onPointerEnter",t="pointer";z=null==k?h:ue(k);q=null==x?h:ue(x);h=new w(v,t+"leave",k,c,e);h.target=z;h.relatedTarget=q;v=null;wc(e)===d&&(w=new w(u,t+"enter",x,c,e),w.target=q,w.relatedTarget=z,v=w);z=v;if(k&&x)b:{w=k;u=x;t=0;for(q=w;q;q=gf(q))t++;q=0;for(v=u;v;v=gf(v))q++;for(;0<t-q;)w=gf(w),t--;for(;0<q-t;)u=
gf(u),q--;for(;t--;){if(w===u||null!==u&&w===u.alternate)break b;w=gf(w);u=gf(u)}w=null}else w=null;null!==k&&hf(g,h,k,w,!1);null!==x&&null!==z&&hf(g,z,x,w,!0)}}}a:{h=d?ue(d):window;k=h.nodeName&&h.nodeName.toLowerCase();if("select"===k||"input"===k&&"file"===h.type)var J=ve;else if(me(h))if(we)J=Fe;else{J=De;var K=Ce}else(k=h.nodeName)&&"input"===k.toLowerCase()&&("checkbox"===h.type||"radio"===h.type)&&(J=Ee);if(J&&(J=J(a,d))){ne(g,J,c,e);break a}K&&K(a,h,d);"focusout"===a&&(K=h._wrapperState)&&
K.controlled&&"number"===h.type&&bb(h,"number",h.value)}K=d?ue(d):window;switch(a){case "focusin":if(me(K)||"true"===K.contentEditable)Qe=K,Re=d,Se=null;break;case "focusout":Se=Re=Qe=null;break;case "mousedown":Te=!0;break;case "contextmenu":case "mouseup":case "dragend":Te=!1;Ue(g,c,e);break;case "selectionchange":if(Pe)break;case "keydown":case "keyup":Ue(g,c,e)}var Q;if(ae)b:{switch(a){case "compositionstart":var L="onCompositionStart";break b;case "compositionend":L="onCompositionEnd";break b;
case "compositionupdate":L="onCompositionUpdate";break b}L=void 0}else ie?ge(a,c)&&(L="onCompositionEnd"):"keydown"===a&&229===c.keyCode&&(L="onCompositionStart");L&&(de&&"ko"!==c.locale&&(ie||"onCompositionStart"!==L?"onCompositionEnd"===L&&ie&&(Q=nd()):(kd=e,ld="value"in kd?kd.value:kd.textContent,ie=!0)),K=oe(d,L),0<K.length&&(L=new Ld(L,a,null,c,e),g.push({event:L,listeners:K}),Q?L.data=Q:(Q=he(c),null!==Q&&(L.data=Q))));if(Q=ce?je(a,c):ke(a,c))d=oe(d,"onBeforeInput"),0<d.length&&(e=new Ld("onBeforeInput",
"beforeinput",null,c,e),g.push({event:e,listeners:d}),e.data=Q)}se(g,b)})}function ef(a,b,c){return{instance:a,listener:b,currentTarget:c}}function oe(a,b){for(var c=b+"Capture",d=[];null!==a;){var e=a,f=e.stateNode;5===e.tag&&null!==f&&(e=f,f=Ob(a,c),null!=f&&d.unshift(ef(a,f,e)),f=Ob(a,b),null!=f&&d.push(ef(a,f,e)));a=a.return}return d}function gf(a){if(null===a)return null;do a=a.return;while(a&&5!==a.tag);return a?a:null}
function hf(a,b,c,d,e){for(var f=b._reactName,g=[];null!==c&&c!==d;){var h=c,k=h.alternate,l=h.stateNode;if(null!==k&&k===d)break;5===h.tag&&null!==l&&(h=l,e?(k=Ob(c,f),null!=k&&g.unshift(ef(c,k,h))):e||(k=Ob(c,f),null!=k&&g.push(ef(c,k,h))));c=c.return}0!==g.length&&a.push({event:b,listeners:g})}function jf(){}var kf=null,lf=null;function mf(a,b){switch(a){case "button":case "input":case "select":case "textarea":return!!b.autoFocus}return!1}
function nf(a,b){return"textarea"===a||"option"===a||"noscript"===a||"string"===typeof b.children||"number"===typeof b.children||"object"===typeof b.dangerouslySetInnerHTML&&null!==b.dangerouslySetInnerHTML&&null!=b.dangerouslySetInnerHTML.__html}var of="function"===typeof setTimeout?setTimeout:void 0,pf="function"===typeof clearTimeout?clearTimeout:void 0;function qf(a){1===a.nodeType?a.textContent="":9===a.nodeType&&(a=a.body,null!=a&&(a.textContent=""))}
function rf(a){for(;null!=a;a=a.nextSibling){var b=a.nodeType;if(1===b||3===b)break}return a}function sf(a){a=a.previousSibling;for(var b=0;a;){if(8===a.nodeType){var c=a.data;if("$"===c||"$!"===c||"$?"===c){if(0===b)return a;b--}else"/$"===c&&b++}a=a.previousSibling}return null}var tf=0;function uf(a){return{$$typeof:Ga,toString:a,valueOf:a}}var vf=Math.random().toString(36).slice(2),wf="__reactFiber$"+vf,xf="__reactProps$"+vf,ff="__reactContainer$"+vf,yf="__reactEvents$"+vf;
function wc(a){var b=a[wf];if(b)return b;for(var c=a.parentNode;c;){if(b=c[ff]||c[wf]){c=b.alternate;if(null!==b.child||null!==c&&null!==c.child)for(a=sf(a);null!==a;){if(c=a[wf])return c;a=sf(a)}return b}a=c;c=a.parentNode}return null}function Cb(a){a=a[wf]||a[ff];return!a||5!==a.tag&&6!==a.tag&&13!==a.tag&&3!==a.tag?null:a}function ue(a){if(5===a.tag||6===a.tag)return a.stateNode;throw Error(y(33));}function Db(a){return a[xf]||null}
function $e(a){var b=a[yf];void 0===b&&(b=a[yf]=new Set);return b}var zf=[],Af=-1;function Bf(a){return{current:a}}function H(a){0>Af||(a.current=zf[Af],zf[Af]=null,Af--)}function I(a,b){Af++;zf[Af]=a.current;a.current=b}var Cf={},M=Bf(Cf),N=Bf(!1),Df=Cf;
function Ef(a,b){var c=a.type.contextTypes;if(!c)return Cf;var d=a.stateNode;if(d&&d.__reactInternalMemoizedUnmaskedChildContext===b)return d.__reactInternalMemoizedMaskedChildContext;var e={},f;for(f in c)e[f]=b[f];d&&(a=a.stateNode,a.__reactInternalMemoizedUnmaskedChildContext=b,a.__reactInternalMemoizedMaskedChildContext=e);return e}function Ff(a){a=a.childContextTypes;return null!==a&&void 0!==a}function Gf(){H(N);H(M)}function Hf(a,b,c){if(M.current!==Cf)throw Error(y(168));I(M,b);I(N,c)}
function If(a,b,c){var d=a.stateNode;a=b.childContextTypes;if("function"!==typeof d.getChildContext)return c;d=d.getChildContext();for(var e in d)if(!(e in a))throw Error(y(108,Ra(b)||"Unknown",e));return m({},c,d)}function Jf(a){a=(a=a.stateNode)&&a.__reactInternalMemoizedMergedChildContext||Cf;Df=M.current;I(M,a);I(N,N.current);return!0}function Kf(a,b,c){var d=a.stateNode;if(!d)throw Error(y(169));c?(a=If(a,b,Df),d.__reactInternalMemoizedMergedChildContext=a,H(N),H(M),I(M,a)):H(N);I(N,c)}
var Lf=null,Mf=null,Nf=r.unstable_runWithPriority,Of=r.unstable_scheduleCallback,Pf=r.unstable_cancelCallback,Qf=r.unstable_shouldYield,Rf=r.unstable_requestPaint,Sf=r.unstable_now,Tf=r.unstable_getCurrentPriorityLevel,Uf=r.unstable_ImmediatePriority,Vf=r.unstable_UserBlockingPriority,Wf=r.unstable_NormalPriority,Xf=r.unstable_LowPriority,Yf=r.unstable_IdlePriority,Zf={},$f=void 0!==Rf?Rf:function(){},ag=null,bg=null,cg=!1,dg=Sf(),O=1E4>dg?Sf:function(){return Sf()-dg};
function eg(){switch(Tf()){case Uf:return 99;case Vf:return 98;case Wf:return 97;case Xf:return 96;case Yf:return 95;default:throw Error(y(332));}}function fg(a){switch(a){case 99:return Uf;case 98:return Vf;case 97:return Wf;case 96:return Xf;case 95:return Yf;default:throw Error(y(332));}}function gg(a,b){a=fg(a);return Nf(a,b)}function hg(a,b,c){a=fg(a);return Of(a,b,c)}function ig(){if(null!==bg){var a=bg;bg=null;Pf(a)}jg()}
function jg(){if(!cg&&null!==ag){cg=!0;var a=0;try{var b=ag;gg(99,function(){for(;a<b.length;a++){var c=b[a];do c=c(!0);while(null!==c)}});ag=null}catch(c){throw null!==ag&&(ag=ag.slice(a+1)),Of(Uf,ig),c;}finally{cg=!1}}}var kg=ra.ReactCurrentBatchConfig;function lg(a,b){if(a&&a.defaultProps){b=m({},b);a=a.defaultProps;for(var c in a)void 0===b[c]&&(b[c]=a[c]);return b}return b}var mg=Bf(null),ng=null,og=null,pg=null;function qg(){pg=og=ng=null}
function rg(a){var b=mg.current;H(mg);a.type._context._currentValue=b}function sg(a,b){for(;null!==a;){var c=a.alternate;if((a.childLanes&b)===b)if(null===c||(c.childLanes&b)===b)break;else c.childLanes|=b;else a.childLanes|=b,null!==c&&(c.childLanes|=b);a=a.return}}function tg(a,b){ng=a;pg=og=null;a=a.dependencies;null!==a&&null!==a.firstContext&&(0!==(a.lanes&b)&&(ug=!0),a.firstContext=null)}
function vg(a,b){if(pg!==a&&!1!==b&&0!==b){if("number"!==typeof b||1073741823===b)pg=a,b=1073741823;b={context:a,observedBits:b,next:null};if(null===og){if(null===ng)throw Error(y(308));og=b;ng.dependencies={lanes:0,firstContext:b,responders:null}}else og=og.next=b}return a._currentValue}var wg=!1;function xg(a){a.updateQueue={baseState:a.memoizedState,firstBaseUpdate:null,lastBaseUpdate:null,shared:{pending:null},effects:null}}
function yg(a,b){a=a.updateQueue;b.updateQueue===a&&(b.updateQueue={baseState:a.baseState,firstBaseUpdate:a.firstBaseUpdate,lastBaseUpdate:a.lastBaseUpdate,shared:a.shared,effects:a.effects})}function zg(a,b){return{eventTime:a,lane:b,tag:0,payload:null,callback:null,next:null}}function Ag(a,b){a=a.updateQueue;if(null!==a){a=a.shared;var c=a.pending;null===c?b.next=b:(b.next=c.next,c.next=b);a.pending=b}}
function Bg(a,b){var c=a.updateQueue,d=a.alternate;if(null!==d&&(d=d.updateQueue,c===d)){var e=null,f=null;c=c.firstBaseUpdate;if(null!==c){do{var g={eventTime:c.eventTime,lane:c.lane,tag:c.tag,payload:c.payload,callback:c.callback,next:null};null===f?e=f=g:f=f.next=g;c=c.next}while(null!==c);null===f?e=f=b:f=f.next=b}else e=f=b;c={baseState:d.baseState,firstBaseUpdate:e,lastBaseUpdate:f,shared:d.shared,effects:d.effects};a.updateQueue=c;return}a=c.lastBaseUpdate;null===a?c.firstBaseUpdate=b:a.next=
b;c.lastBaseUpdate=b}
function Cg(a,b,c,d){var e=a.updateQueue;wg=!1;var f=e.firstBaseUpdate,g=e.lastBaseUpdate,h=e.shared.pending;if(null!==h){e.shared.pending=null;var k=h,l=k.next;k.next=null;null===g?f=l:g.next=l;g=k;var n=a.alternate;if(null!==n){n=n.updateQueue;var A=n.lastBaseUpdate;A!==g&&(null===A?n.firstBaseUpdate=l:A.next=l,n.lastBaseUpdate=k)}}if(null!==f){A=e.baseState;g=0;n=l=k=null;do{h=f.lane;var p=f.eventTime;if((d&h)===h){null!==n&&(n=n.next={eventTime:p,lane:0,tag:f.tag,payload:f.payload,callback:f.callback,
next:null});a:{var C=a,x=f;h=b;p=c;switch(x.tag){case 1:C=x.payload;if("function"===typeof C){A=C.call(p,A,h);break a}A=C;break a;case 3:C.flags=C.flags&-4097|64;case 0:C=x.payload;h="function"===typeof C?C.call(p,A,h):C;if(null===h||void 0===h)break a;A=m({},A,h);break a;case 2:wg=!0}}null!==f.callback&&(a.flags|=32,h=e.effects,null===h?e.effects=[f]:h.push(f))}else p={eventTime:p,lane:h,tag:f.tag,payload:f.payload,callback:f.callback,next:null},null===n?(l=n=p,k=A):n=n.next=p,g|=h;f=f.next;if(null===
f)if(h=e.shared.pending,null===h)break;else f=h.next,h.next=null,e.lastBaseUpdate=h,e.shared.pending=null}while(1);null===n&&(k=A);e.baseState=k;e.firstBaseUpdate=l;e.lastBaseUpdate=n;Dg|=g;a.lanes=g;a.memoizedState=A}}function Eg(a,b,c){a=b.effects;b.effects=null;if(null!==a)for(b=0;b<a.length;b++){var d=a[b],e=d.callback;if(null!==e){d.callback=null;d=c;if("function"!==typeof e)throw Error(y(191,e));e.call(d)}}}var Fg=(new aa.Component).refs;
function Gg(a,b,c,d){b=a.memoizedState;c=c(d,b);c=null===c||void 0===c?b:m({},b,c);a.memoizedState=c;0===a.lanes&&(a.updateQueue.baseState=c)}
var Kg={isMounted:function(a){return(a=a._reactInternals)?Zb(a)===a:!1},enqueueSetState:function(a,b,c){a=a._reactInternals;var d=Hg(),e=Ig(a),f=zg(d,e);f.payload=b;void 0!==c&&null!==c&&(f.callback=c);Ag(a,f);Jg(a,e,d)},enqueueReplaceState:function(a,b,c){a=a._reactInternals;var d=Hg(),e=Ig(a),f=zg(d,e);f.tag=1;f.payload=b;void 0!==c&&null!==c&&(f.callback=c);Ag(a,f);Jg(a,e,d)},enqueueForceUpdate:function(a,b){a=a._reactInternals;var c=Hg(),d=Ig(a),e=zg(c,d);e.tag=2;void 0!==b&&null!==b&&(e.callback=
b);Ag(a,e);Jg(a,d,c)}};function Lg(a,b,c,d,e,f,g){a=a.stateNode;return"function"===typeof a.shouldComponentUpdate?a.shouldComponentUpdate(d,f,g):b.prototype&&b.prototype.isPureReactComponent?!Je(c,d)||!Je(e,f):!0}
function Mg(a,b,c){var d=!1,e=Cf;var f=b.contextType;"object"===typeof f&&null!==f?f=vg(f):(e=Ff(b)?Df:M.current,d=b.contextTypes,f=(d=null!==d&&void 0!==d)?Ef(a,e):Cf);b=new b(c,f);a.memoizedState=null!==b.state&&void 0!==b.state?b.state:null;b.updater=Kg;a.stateNode=b;b._reactInternals=a;d&&(a=a.stateNode,a.__reactInternalMemoizedUnmaskedChildContext=e,a.__reactInternalMemoizedMaskedChildContext=f);return b}
function Ng(a,b,c,d){a=b.state;"function"===typeof b.componentWillReceiveProps&&b.componentWillReceiveProps(c,d);"function"===typeof b.UNSAFE_componentWillReceiveProps&&b.UNSAFE_componentWillReceiveProps(c,d);b.state!==a&&Kg.enqueueReplaceState(b,b.state,null)}
function Og(a,b,c,d){var e=a.stateNode;e.props=c;e.state=a.memoizedState;e.refs=Fg;xg(a);var f=b.contextType;"object"===typeof f&&null!==f?e.context=vg(f):(f=Ff(b)?Df:M.current,e.context=Ef(a,f));Cg(a,c,e,d);e.state=a.memoizedState;f=b.getDerivedStateFromProps;"function"===typeof f&&(Gg(a,b,f,c),e.state=a.memoizedState);"function"===typeof b.getDerivedStateFromProps||"function"===typeof e.getSnapshotBeforeUpdate||"function"!==typeof e.UNSAFE_componentWillMount&&"function"!==typeof e.componentWillMount||
(b=e.state,"function"===typeof e.componentWillMount&&e.componentWillMount(),"function"===typeof e.UNSAFE_componentWillMount&&e.UNSAFE_componentWillMount(),b!==e.state&&Kg.enqueueReplaceState(e,e.state,null),Cg(a,c,e,d),e.state=a.memoizedState);"function"===typeof e.componentDidMount&&(a.flags|=4)}var Pg=Array.isArray;
function Qg(a,b,c){a=c.ref;if(null!==a&&"function"!==typeof a&&"object"!==typeof a){if(c._owner){c=c._owner;if(c){if(1!==c.tag)throw Error(y(309));var d=c.stateNode}if(!d)throw Error(y(147,a));var e=""+a;if(null!==b&&null!==b.ref&&"function"===typeof b.ref&&b.ref._stringRef===e)return b.ref;b=function(a){var b=d.refs;b===Fg&&(b=d.refs={});null===a?delete b[e]:b[e]=a};b._stringRef=e;return b}if("string"!==typeof a)throw Error(y(284));if(!c._owner)throw Error(y(290,a));}return a}
function Rg(a,b){if("textarea"!==a.type)throw Error(y(31,"[object Object]"===Object.prototype.toString.call(b)?"object with keys {"+Object.keys(b).join(", ")+"}":b));}
function Sg(a){function b(b,c){if(a){var d=b.lastEffect;null!==d?(d.nextEffect=c,b.lastEffect=c):b.firstEffect=b.lastEffect=c;c.nextEffect=null;c.flags=8}}function c(c,d){if(!a)return null;for(;null!==d;)b(c,d),d=d.sibling;return null}function d(a,b){for(a=new Map;null!==b;)null!==b.key?a.set(b.key,b):a.set(b.index,b),b=b.sibling;return a}function e(a,b){a=Tg(a,b);a.index=0;a.sibling=null;return a}function f(b,c,d){b.index=d;if(!a)return c;d=b.alternate;if(null!==d)return d=d.index,d<c?(b.flags=2,
c):d;b.flags=2;return c}function g(b){a&&null===b.alternate&&(b.flags=2);return b}function h(a,b,c,d){if(null===b||6!==b.tag)return b=Ug(c,a.mode,d),b.return=a,b;b=e(b,c);b.return=a;return b}function k(a,b,c,d){if(null!==b&&b.elementType===c.type)return d=e(b,c.props),d.ref=Qg(a,b,c),d.return=a,d;d=Vg(c.type,c.key,c.props,null,a.mode,d);d.ref=Qg(a,b,c);d.return=a;return d}function l(a,b,c,d){if(null===b||4!==b.tag||b.stateNode.containerInfo!==c.containerInfo||b.stateNode.implementation!==c.implementation)return b=
Wg(c,a.mode,d),b.return=a,b;b=e(b,c.children||[]);b.return=a;return b}function n(a,b,c,d,f){if(null===b||7!==b.tag)return b=Xg(c,a.mode,d,f),b.return=a,b;b=e(b,c);b.return=a;return b}function A(a,b,c){if("string"===typeof b||"number"===typeof b)return b=Ug(""+b,a.mode,c),b.return=a,b;if("object"===typeof b&&null!==b){switch(b.$$typeof){case sa:return c=Vg(b.type,b.key,b.props,null,a.mode,c),c.ref=Qg(a,null,b),c.return=a,c;case ta:return b=Wg(b,a.mode,c),b.return=a,b}if(Pg(b)||La(b))return b=Xg(b,
a.mode,c,null),b.return=a,b;Rg(a,b)}return null}function p(a,b,c,d){var e=null!==b?b.key:null;if("string"===typeof c||"number"===typeof c)return null!==e?null:h(a,b,""+c,d);if("object"===typeof c&&null!==c){switch(c.$$typeof){case sa:return c.key===e?c.type===ua?n(a,b,c.props.children,d,e):k(a,b,c,d):null;case ta:return c.key===e?l(a,b,c,d):null}if(Pg(c)||La(c))return null!==e?null:n(a,b,c,d,null);Rg(a,c)}return null}function C(a,b,c,d,e){if("string"===typeof d||"number"===typeof d)return a=a.get(c)||
null,h(b,a,""+d,e);if("object"===typeof d&&null!==d){switch(d.$$typeof){case sa:return a=a.get(null===d.key?c:d.key)||null,d.type===ua?n(b,a,d.props.children,e,d.key):k(b,a,d,e);case ta:return a=a.get(null===d.key?c:d.key)||null,l(b,a,d,e)}if(Pg(d)||La(d))return a=a.get(c)||null,n(b,a,d,e,null);Rg(b,d)}return null}function x(e,g,h,k){for(var l=null,t=null,u=g,z=g=0,q=null;null!==u&&z<h.length;z++){u.index>z?(q=u,u=null):q=u.sibling;var n=p(e,u,h[z],k);if(null===n){null===u&&(u=q);break}a&&u&&null===
n.alternate&&b(e,u);g=f(n,g,z);null===t?l=n:t.sibling=n;t=n;u=q}if(z===h.length)return c(e,u),l;if(null===u){for(;z<h.length;z++)u=A(e,h[z],k),null!==u&&(g=f(u,g,z),null===t?l=u:t.sibling=u,t=u);return l}for(u=d(e,u);z<h.length;z++)q=C(u,e,z,h[z],k),null!==q&&(a&&null!==q.alternate&&u.delete(null===q.key?z:q.key),g=f(q,g,z),null===t?l=q:t.sibling=q,t=q);a&&u.forEach(function(a){return b(e,a)});return l}function w(e,g,h,k){var l=La(h);if("function"!==typeof l)throw Error(y(150));h=l.call(h);if(null==
h)throw Error(y(151));for(var t=l=null,u=g,z=g=0,q=null,n=h.next();null!==u&&!n.done;z++,n=h.next()){u.index>z?(q=u,u=null):q=u.sibling;var w=p(e,u,n.value,k);if(null===w){null===u&&(u=q);break}a&&u&&null===w.alternate&&b(e,u);g=f(w,g,z);null===t?l=w:t.sibling=w;t=w;u=q}if(n.done)return c(e,u),l;if(null===u){for(;!n.done;z++,n=h.next())n=A(e,n.value,k),null!==n&&(g=f(n,g,z),null===t?l=n:t.sibling=n,t=n);return l}for(u=d(e,u);!n.done;z++,n=h.next())n=C(u,e,z,n.value,k),null!==n&&(a&&null!==n.alternate&&
u.delete(null===n.key?z:n.key),g=f(n,g,z),null===t?l=n:t.sibling=n,t=n);a&&u.forEach(function(a){return b(e,a)});return l}return function(a,d,f,h){var k="object"===typeof f&&null!==f&&f.type===ua&&null===f.key;k&&(f=f.props.children);var l="object"===typeof f&&null!==f;if(l)switch(f.$$typeof){case sa:a:{l=f.key;for(k=d;null!==k;){if(k.key===l){switch(k.tag){case 7:if(f.type===ua){c(a,k.sibling);d=e(k,f.props.children);d.return=a;a=d;break a}break;default:if(k.elementType===f.type){c(a,k.sibling);
d=e(k,f.props);d.ref=Qg(a,k,f);d.return=a;a=d;break a}}c(a,k);break}else b(a,k);k=k.sibling}f.type===ua?(d=Xg(f.props.children,a.mode,h,f.key),d.return=a,a=d):(h=Vg(f.type,f.key,f.props,null,a.mode,h),h.ref=Qg(a,d,f),h.return=a,a=h)}return g(a);case ta:a:{for(k=f.key;null!==d;){if(d.key===k)if(4===d.tag&&d.stateNode.containerInfo===f.containerInfo&&d.stateNode.implementation===f.implementation){c(a,d.sibling);d=e(d,f.children||[]);d.return=a;a=d;break a}else{c(a,d);break}else b(a,d);d=d.sibling}d=
Wg(f,a.mode,h);d.return=a;a=d}return g(a)}if("string"===typeof f||"number"===typeof f)return f=""+f,null!==d&&6===d.tag?(c(a,d.sibling),d=e(d,f),d.return=a,a=d):(c(a,d),d=Ug(f,a.mode,h),d.return=a,a=d),g(a);if(Pg(f))return x(a,d,f,h);if(La(f))return w(a,d,f,h);l&&Rg(a,f);if("undefined"===typeof f&&!k)switch(a.tag){case 1:case 22:case 0:case 11:case 15:throw Error(y(152,Ra(a.type)||"Component"));}return c(a,d)}}var Yg=Sg(!0),Zg=Sg(!1),$g={},ah=Bf($g),bh=Bf($g),ch=Bf($g);
function dh(a){if(a===$g)throw Error(y(174));return a}function eh(a,b){I(ch,b);I(bh,a);I(ah,$g);a=b.nodeType;switch(a){case 9:case 11:b=(b=b.documentElement)?b.namespaceURI:mb(null,"");break;default:a=8===a?b.parentNode:b,b=a.namespaceURI||null,a=a.tagName,b=mb(b,a)}H(ah);I(ah,b)}function fh(){H(ah);H(bh);H(ch)}function gh(a){dh(ch.current);var b=dh(ah.current);var c=mb(b,a.type);b!==c&&(I(bh,a),I(ah,c))}function hh(a){bh.current===a&&(H(ah),H(bh))}var P=Bf(0);
function ih(a){for(var b=a;null!==b;){if(13===b.tag){var c=b.memoizedState;if(null!==c&&(c=c.dehydrated,null===c||"$?"===c.data||"$!"===c.data))return b}else if(19===b.tag&&void 0!==b.memoizedProps.revealOrder){if(0!==(b.flags&64))return b}else if(null!==b.child){b.child.return=b;b=b.child;continue}if(b===a)break;for(;null===b.sibling;){if(null===b.return||b.return===a)return null;b=b.return}b.sibling.return=b.return;b=b.sibling}return null}var jh=null,kh=null,lh=!1;
function mh(a,b){var c=nh(5,null,null,0);c.elementType="DELETED";c.type="DELETED";c.stateNode=b;c.return=a;c.flags=8;null!==a.lastEffect?(a.lastEffect.nextEffect=c,a.lastEffect=c):a.firstEffect=a.lastEffect=c}function oh(a,b){switch(a.tag){case 5:var c=a.type;b=1!==b.nodeType||c.toLowerCase()!==b.nodeName.toLowerCase()?null:b;return null!==b?(a.stateNode=b,!0):!1;case 6:return b=""===a.pendingProps||3!==b.nodeType?null:b,null!==b?(a.stateNode=b,!0):!1;case 13:return!1;default:return!1}}
function ph(a){if(lh){var b=kh;if(b){var c=b;if(!oh(a,b)){b=rf(c.nextSibling);if(!b||!oh(a,b)){a.flags=a.flags&-1025|2;lh=!1;jh=a;return}mh(jh,c)}jh=a;kh=rf(b.firstChild)}else a.flags=a.flags&-1025|2,lh=!1,jh=a}}function qh(a){for(a=a.return;null!==a&&5!==a.tag&&3!==a.tag&&13!==a.tag;)a=a.return;jh=a}
function rh(a){if(a!==jh)return!1;if(!lh)return qh(a),lh=!0,!1;var b=a.type;if(5!==a.tag||"head"!==b&&"body"!==b&&!nf(b,a.memoizedProps))for(b=kh;b;)mh(a,b),b=rf(b.nextSibling);qh(a);if(13===a.tag){a=a.memoizedState;a=null!==a?a.dehydrated:null;if(!a)throw Error(y(317));a:{a=a.nextSibling;for(b=0;a;){if(8===a.nodeType){var c=a.data;if("/$"===c){if(0===b){kh=rf(a.nextSibling);break a}b--}else"$"!==c&&"$!"!==c&&"$?"!==c||b++}a=a.nextSibling}kh=null}}else kh=jh?rf(a.stateNode.nextSibling):null;return!0}
function sh(){kh=jh=null;lh=!1}var th=[];function uh(){for(var a=0;a<th.length;a++)th[a]._workInProgressVersionPrimary=null;th.length=0}var vh=ra.ReactCurrentDispatcher,wh=ra.ReactCurrentBatchConfig,xh=0,R=null,S=null,T=null,yh=!1,zh=!1;function Ah(){throw Error(y(321));}function Bh(a,b){if(null===b)return!1;for(var c=0;c<b.length&&c<a.length;c++)if(!He(a[c],b[c]))return!1;return!0}
function Ch(a,b,c,d,e,f){xh=f;R=b;b.memoizedState=null;b.updateQueue=null;b.lanes=0;vh.current=null===a||null===a.memoizedState?Dh:Eh;a=c(d,e);if(zh){f=0;do{zh=!1;if(!(25>f))throw Error(y(301));f+=1;T=S=null;b.updateQueue=null;vh.current=Fh;a=c(d,e)}while(zh)}vh.current=Gh;b=null!==S&&null!==S.next;xh=0;T=S=R=null;yh=!1;if(b)throw Error(y(300));return a}function Hh(){var a={memoizedState:null,baseState:null,baseQueue:null,queue:null,next:null};null===T?R.memoizedState=T=a:T=T.next=a;return T}
function Ih(){if(null===S){var a=R.alternate;a=null!==a?a.memoizedState:null}else a=S.next;var b=null===T?R.memoizedState:T.next;if(null!==b)T=b,S=a;else{if(null===a)throw Error(y(310));S=a;a={memoizedState:S.memoizedState,baseState:S.baseState,baseQueue:S.baseQueue,queue:S.queue,next:null};null===T?R.memoizedState=T=a:T=T.next=a}return T}function Jh(a,b){return"function"===typeof b?b(a):b}
function Kh(a){var b=Ih(),c=b.queue;if(null===c)throw Error(y(311));c.lastRenderedReducer=a;var d=S,e=d.baseQueue,f=c.pending;if(null!==f){if(null!==e){var g=e.next;e.next=f.next;f.next=g}d.baseQueue=e=f;c.pending=null}if(null!==e){e=e.next;d=d.baseState;var h=g=f=null,k=e;do{var l=k.lane;if((xh&l)===l)null!==h&&(h=h.next={lane:0,action:k.action,eagerReducer:k.eagerReducer,eagerState:k.eagerState,next:null}),d=k.eagerReducer===a?k.eagerState:a(d,k.action);else{var n={lane:l,action:k.action,eagerReducer:k.eagerReducer,
eagerState:k.eagerState,next:null};null===h?(g=h=n,f=d):h=h.next=n;R.lanes|=l;Dg|=l}k=k.next}while(null!==k&&k!==e);null===h?f=d:h.next=g;He(d,b.memoizedState)||(ug=!0);b.memoizedState=d;b.baseState=f;b.baseQueue=h;c.lastRenderedState=d}return[b.memoizedState,c.dispatch]}
function Lh(a){var b=Ih(),c=b.queue;if(null===c)throw Error(y(311));c.lastRenderedReducer=a;var d=c.dispatch,e=c.pending,f=b.memoizedState;if(null!==e){c.pending=null;var g=e=e.next;do f=a(f,g.action),g=g.next;while(g!==e);He(f,b.memoizedState)||(ug=!0);b.memoizedState=f;null===b.baseQueue&&(b.baseState=f);c.lastRenderedState=f}return[f,d]}
function Mh(a,b,c){var d=b._getVersion;d=d(b._source);var e=b._workInProgressVersionPrimary;if(null!==e)a=e===d;else if(a=a.mutableReadLanes,a=(xh&a)===a)b._workInProgressVersionPrimary=d,th.push(b);if(a)return c(b._source);th.push(b);throw Error(y(350));}
function Nh(a,b,c,d){var e=U;if(null===e)throw Error(y(349));var f=b._getVersion,g=f(b._source),h=vh.current,k=h.useState(function(){return Mh(e,b,c)}),l=k[1],n=k[0];k=T;var A=a.memoizedState,p=A.refs,C=p.getSnapshot,x=A.source;A=A.subscribe;var w=R;a.memoizedState={refs:p,source:b,subscribe:d};h.useEffect(function(){p.getSnapshot=c;p.setSnapshot=l;var a=f(b._source);if(!He(g,a)){a=c(b._source);He(n,a)||(l(a),a=Ig(w),e.mutableReadLanes|=a&e.pendingLanes);a=e.mutableReadLanes;e.entangledLanes|=a;for(var d=
e.entanglements,h=a;0<h;){var k=31-Vc(h),v=1<<k;d[k]|=a;h&=~v}}},[c,b,d]);h.useEffect(function(){return d(b._source,function(){var a=p.getSnapshot,c=p.setSnapshot;try{c(a(b._source));var d=Ig(w);e.mutableReadLanes|=d&e.pendingLanes}catch(q){c(function(){throw q;})}})},[b,d]);He(C,c)&&He(x,b)&&He(A,d)||(a={pending:null,dispatch:null,lastRenderedReducer:Jh,lastRenderedState:n},a.dispatch=l=Oh.bind(null,R,a),k.queue=a,k.baseQueue=null,n=Mh(e,b,c),k.memoizedState=k.baseState=n);return n}
function Ph(a,b,c){var d=Ih();return Nh(d,a,b,c)}function Qh(a){var b=Hh();"function"===typeof a&&(a=a());b.memoizedState=b.baseState=a;a=b.queue={pending:null,dispatch:null,lastRenderedReducer:Jh,lastRenderedState:a};a=a.dispatch=Oh.bind(null,R,a);return[b.memoizedState,a]}
function Rh(a,b,c,d){a={tag:a,create:b,destroy:c,deps:d,next:null};b=R.updateQueue;null===b?(b={lastEffect:null},R.updateQueue=b,b.lastEffect=a.next=a):(c=b.lastEffect,null===c?b.lastEffect=a.next=a:(d=c.next,c.next=a,a.next=d,b.lastEffect=a));return a}function Sh(a){var b=Hh();a={current:a};return b.memoizedState=a}function Th(){return Ih().memoizedState}function Uh(a,b,c,d){var e=Hh();R.flags|=a;e.memoizedState=Rh(1|b,c,void 0,void 0===d?null:d)}
function Vh(a,b,c,d){var e=Ih();d=void 0===d?null:d;var f=void 0;if(null!==S){var g=S.memoizedState;f=g.destroy;if(null!==d&&Bh(d,g.deps)){Rh(b,c,f,d);return}}R.flags|=a;e.memoizedState=Rh(1|b,c,f,d)}function Wh(a,b){return Uh(516,4,a,b)}function Xh(a,b){return Vh(516,4,a,b)}function Yh(a,b){return Vh(4,2,a,b)}function Zh(a,b){if("function"===typeof b)return a=a(),b(a),function(){b(null)};if(null!==b&&void 0!==b)return a=a(),b.current=a,function(){b.current=null}}
function $h(a,b,c){c=null!==c&&void 0!==c?c.concat([a]):null;return Vh(4,2,Zh.bind(null,b,a),c)}function ai(){}function bi(a,b){var c=Ih();b=void 0===b?null:b;var d=c.memoizedState;if(null!==d&&null!==b&&Bh(b,d[1]))return d[0];c.memoizedState=[a,b];return a}function ci(a,b){var c=Ih();b=void 0===b?null:b;var d=c.memoizedState;if(null!==d&&null!==b&&Bh(b,d[1]))return d[0];a=a();c.memoizedState=[a,b];return a}
function di(a,b){var c=eg();gg(98>c?98:c,function(){a(!0)});gg(97<c?97:c,function(){var c=wh.transition;wh.transition=1;try{a(!1),b()}finally{wh.transition=c}})}
function Oh(a,b,c){var d=Hg(),e=Ig(a),f={lane:e,action:c,eagerReducer:null,eagerState:null,next:null},g=b.pending;null===g?f.next=f:(f.next=g.next,g.next=f);b.pending=f;g=a.alternate;if(a===R||null!==g&&g===R)zh=yh=!0;else{if(0===a.lanes&&(null===g||0===g.lanes)&&(g=b.lastRenderedReducer,null!==g))try{var h=b.lastRenderedState,k=g(h,c);f.eagerReducer=g;f.eagerState=k;if(He(k,h))return}catch(l){}finally{}Jg(a,e,d)}}
var Gh={readContext:vg,useCallback:Ah,useContext:Ah,useEffect:Ah,useImperativeHandle:Ah,useLayoutEffect:Ah,useMemo:Ah,useReducer:Ah,useRef:Ah,useState:Ah,useDebugValue:Ah,useDeferredValue:Ah,useTransition:Ah,useMutableSource:Ah,useOpaqueIdentifier:Ah,unstable_isNewReconciler:!1},Dh={readContext:vg,useCallback:function(a,b){Hh().memoizedState=[a,void 0===b?null:b];return a},useContext:vg,useEffect:Wh,useImperativeHandle:function(a,b,c){c=null!==c&&void 0!==c?c.concat([a]):null;return Uh(4,2,Zh.bind(null,
b,a),c)},useLayoutEffect:function(a,b){return Uh(4,2,a,b)},useMemo:function(a,b){var c=Hh();b=void 0===b?null:b;a=a();c.memoizedState=[a,b];return a},useReducer:function(a,b,c){var d=Hh();b=void 0!==c?c(b):b;d.memoizedState=d.baseState=b;a=d.queue={pending:null,dispatch:null,lastRenderedReducer:a,lastRenderedState:b};a=a.dispatch=Oh.bind(null,R,a);return[d.memoizedState,a]},useRef:Sh,useState:Qh,useDebugValue:ai,useDeferredValue:function(a){var b=Qh(a),c=b[0],d=b[1];Wh(function(){var b=wh.transition;
wh.transition=1;try{d(a)}finally{wh.transition=b}},[a]);return c},useTransition:function(){var a=Qh(!1),b=a[0];a=di.bind(null,a[1]);Sh(a);return[a,b]},useMutableSource:function(a,b,c){var d=Hh();d.memoizedState={refs:{getSnapshot:b,setSnapshot:null},source:a,subscribe:c};return Nh(d,a,b,c)},useOpaqueIdentifier:function(){if(lh){var a=!1,b=uf(function(){a||(a=!0,c("r:"+(tf++).toString(36)));throw Error(y(355));}),c=Qh(b)[1];0===(R.mode&2)&&(R.flags|=516,Rh(5,function(){c("r:"+(tf++).toString(36))},
void 0,null));return b}b="r:"+(tf++).toString(36);Qh(b);return b},unstable_isNewReconciler:!1},Eh={readContext:vg,useCallback:bi,useContext:vg,useEffect:Xh,useImperativeHandle:$h,useLayoutEffect:Yh,useMemo:ci,useReducer:Kh,useRef:Th,useState:function(){return Kh(Jh)},useDebugValue:ai,useDeferredValue:function(a){var b=Kh(Jh),c=b[0],d=b[1];Xh(function(){var b=wh.transition;wh.transition=1;try{d(a)}finally{wh.transition=b}},[a]);return c},useTransition:function(){var a=Kh(Jh)[0];return[Th().current,
a]},useMutableSource:Ph,useOpaqueIdentifier:function(){return Kh(Jh)[0]},unstable_isNewReconciler:!1},Fh={readContext:vg,useCallback:bi,useContext:vg,useEffect:Xh,useImperativeHandle:$h,useLayoutEffect:Yh,useMemo:ci,useReducer:Lh,useRef:Th,useState:function(){return Lh(Jh)},useDebugValue:ai,useDeferredValue:function(a){var b=Lh(Jh),c=b[0],d=b[1];Xh(function(){var b=wh.transition;wh.transition=1;try{d(a)}finally{wh.transition=b}},[a]);return c},useTransition:function(){var a=Lh(Jh)[0];return[Th().current,
a]},useMutableSource:Ph,useOpaqueIdentifier:function(){return Lh(Jh)[0]},unstable_isNewReconciler:!1},ei=ra.ReactCurrentOwner,ug=!1;function fi(a,b,c,d){b.child=null===a?Zg(b,null,c,d):Yg(b,a.child,c,d)}function gi(a,b,c,d,e){c=c.render;var f=b.ref;tg(b,e);d=Ch(a,b,c,d,f,e);if(null!==a&&!ug)return b.updateQueue=a.updateQueue,b.flags&=-517,a.lanes&=~e,hi(a,b,e);b.flags|=1;fi(a,b,d,e);return b.child}
function ii(a,b,c,d,e,f){if(null===a){var g=c.type;if("function"===typeof g&&!ji(g)&&void 0===g.defaultProps&&null===c.compare&&void 0===c.defaultProps)return b.tag=15,b.type=g,ki(a,b,g,d,e,f);a=Vg(c.type,null,d,b,b.mode,f);a.ref=b.ref;a.return=b;return b.child=a}g=a.child;if(0===(e&f)&&(e=g.memoizedProps,c=c.compare,c=null!==c?c:Je,c(e,d)&&a.ref===b.ref))return hi(a,b,f);b.flags|=1;a=Tg(g,d);a.ref=b.ref;a.return=b;return b.child=a}
function ki(a,b,c,d,e,f){if(null!==a&&Je(a.memoizedProps,d)&&a.ref===b.ref)if(ug=!1,0!==(f&e))0!==(a.flags&16384)&&(ug=!0);else return b.lanes=a.lanes,hi(a,b,f);return li(a,b,c,d,f)}
function mi(a,b,c){var d=b.pendingProps,e=d.children,f=null!==a?a.memoizedState:null;if("hidden"===d.mode||"unstable-defer-without-hiding"===d.mode)if(0===(b.mode&4))b.memoizedState={baseLanes:0},ni(b,c);else if(0!==(c&1073741824))b.memoizedState={baseLanes:0},ni(b,null!==f?f.baseLanes:c);else return a=null!==f?f.baseLanes|c:c,b.lanes=b.childLanes=1073741824,b.memoizedState={baseLanes:a},ni(b,a),null;else null!==f?(d=f.baseLanes|c,b.memoizedState=null):d=c,ni(b,d);fi(a,b,e,c);return b.child}
function oi(a,b){var c=b.ref;if(null===a&&null!==c||null!==a&&a.ref!==c)b.flags|=128}function li(a,b,c,d,e){var f=Ff(c)?Df:M.current;f=Ef(b,f);tg(b,e);c=Ch(a,b,c,d,f,e);if(null!==a&&!ug)return b.updateQueue=a.updateQueue,b.flags&=-517,a.lanes&=~e,hi(a,b,e);b.flags|=1;fi(a,b,c,e);return b.child}
function pi(a,b,c,d,e){if(Ff(c)){var f=!0;Jf(b)}else f=!1;tg(b,e);if(null===b.stateNode)null!==a&&(a.alternate=null,b.alternate=null,b.flags|=2),Mg(b,c,d),Og(b,c,d,e),d=!0;else if(null===a){var g=b.stateNode,h=b.memoizedProps;g.props=h;var k=g.context,l=c.contextType;"object"===typeof l&&null!==l?l=vg(l):(l=Ff(c)?Df:M.current,l=Ef(b,l));var n=c.getDerivedStateFromProps,A="function"===typeof n||"function"===typeof g.getSnapshotBeforeUpdate;A||"function"!==typeof g.UNSAFE_componentWillReceiveProps&&
"function"!==typeof g.componentWillReceiveProps||(h!==d||k!==l)&&Ng(b,g,d,l);wg=!1;var p=b.memoizedState;g.state=p;Cg(b,d,g,e);k=b.memoizedState;h!==d||p!==k||N.current||wg?("function"===typeof n&&(Gg(b,c,n,d),k=b.memoizedState),(h=wg||Lg(b,c,h,d,p,k,l))?(A||"function"!==typeof g.UNSAFE_componentWillMount&&"function"!==typeof g.componentWillMount||("function"===typeof g.componentWillMount&&g.componentWillMount(),"function"===typeof g.UNSAFE_componentWillMount&&g.UNSAFE_componentWillMount()),"function"===
typeof g.componentDidMount&&(b.flags|=4)):("function"===typeof g.componentDidMount&&(b.flags|=4),b.memoizedProps=d,b.memoizedState=k),g.props=d,g.state=k,g.context=l,d=h):("function"===typeof g.componentDidMount&&(b.flags|=4),d=!1)}else{g=b.stateNode;yg(a,b);h=b.memoizedProps;l=b.type===b.elementType?h:lg(b.type,h);g.props=l;A=b.pendingProps;p=g.context;k=c.contextType;"object"===typeof k&&null!==k?k=vg(k):(k=Ff(c)?Df:M.current,k=Ef(b,k));var C=c.getDerivedStateFromProps;(n="function"===typeof C||
"function"===typeof g.getSnapshotBeforeUpdate)||"function"!==typeof g.UNSAFE_componentWillReceiveProps&&"function"!==typeof g.componentWillReceiveProps||(h!==A||p!==k)&&Ng(b,g,d,k);wg=!1;p=b.memoizedState;g.state=p;Cg(b,d,g,e);var x=b.memoizedState;h!==A||p!==x||N.current||wg?("function"===typeof C&&(Gg(b,c,C,d),x=b.memoizedState),(l=wg||Lg(b,c,l,d,p,x,k))?(n||"function"!==typeof g.UNSAFE_componentWillUpdate&&"function"!==typeof g.componentWillUpdate||("function"===typeof g.componentWillUpdate&&g.componentWillUpdate(d,
x,k),"function"===typeof g.UNSAFE_componentWillUpdate&&g.UNSAFE_componentWillUpdate(d,x,k)),"function"===typeof g.componentDidUpdate&&(b.flags|=4),"function"===typeof g.getSnapshotBeforeUpdate&&(b.flags|=256)):("function"!==typeof g.componentDidUpdate||h===a.memoizedProps&&p===a.memoizedState||(b.flags|=4),"function"!==typeof g.getSnapshotBeforeUpdate||h===a.memoizedProps&&p===a.memoizedState||(b.flags|=256),b.memoizedProps=d,b.memoizedState=x),g.props=d,g.state=x,g.context=k,d=l):("function"!==typeof g.componentDidUpdate||
h===a.memoizedProps&&p===a.memoizedState||(b.flags|=4),"function"!==typeof g.getSnapshotBeforeUpdate||h===a.memoizedProps&&p===a.memoizedState||(b.flags|=256),d=!1)}return qi(a,b,c,d,f,e)}
function qi(a,b,c,d,e,f){oi(a,b);var g=0!==(b.flags&64);if(!d&&!g)return e&&Kf(b,c,!1),hi(a,b,f);d=b.stateNode;ei.current=b;var h=g&&"function"!==typeof c.getDerivedStateFromError?null:d.render();b.flags|=1;null!==a&&g?(b.child=Yg(b,a.child,null,f),b.child=Yg(b,null,h,f)):fi(a,b,h,f);b.memoizedState=d.state;e&&Kf(b,c,!0);return b.child}function ri(a){var b=a.stateNode;b.pendingContext?Hf(a,b.pendingContext,b.pendingContext!==b.context):b.context&&Hf(a,b.context,!1);eh(a,b.containerInfo)}
var si={dehydrated:null,retryLane:0};
function ti(a,b,c){var d=b.pendingProps,e=P.current,f=!1,g;(g=0!==(b.flags&64))||(g=null!==a&&null===a.memoizedState?!1:0!==(e&2));g?(f=!0,b.flags&=-65):null!==a&&null===a.memoizedState||void 0===d.fallback||!0===d.unstable_avoidThisFallback||(e|=1);I(P,e&1);if(null===a){void 0!==d.fallback&&ph(b);a=d.children;e=d.fallback;if(f)return a=ui(b,a,e,c),b.child.memoizedState={baseLanes:c},b.memoizedState=si,a;if("number"===typeof d.unstable_expectedLoadTime)return a=ui(b,a,e,c),b.child.memoizedState={baseLanes:c},
b.memoizedState=si,b.lanes=33554432,a;c=vi({mode:"visible",children:a},b.mode,c,null);c.return=b;return b.child=c}if(null!==a.memoizedState){if(f)return d=wi(a,b,d.children,d.fallback,c),f=b.child,e=a.child.memoizedState,f.memoizedState=null===e?{baseLanes:c}:{baseLanes:e.baseLanes|c},f.childLanes=a.childLanes&~c,b.memoizedState=si,d;c=xi(a,b,d.children,c);b.memoizedState=null;return c}if(f)return d=wi(a,b,d.children,d.fallback,c),f=b.child,e=a.child.memoizedState,f.memoizedState=null===e?{baseLanes:c}:
{baseLanes:e.baseLanes|c},f.childLanes=a.childLanes&~c,b.memoizedState=si,d;c=xi(a,b,d.children,c);b.memoizedState=null;return c}function ui(a,b,c,d){var e=a.mode,f=a.child;b={mode:"hidden",children:b};0===(e&2)&&null!==f?(f.childLanes=0,f.pendingProps=b):f=vi(b,e,0,null);c=Xg(c,e,d,null);f.return=a;c.return=a;f.sibling=c;a.child=f;return c}
function xi(a,b,c,d){var e=a.child;a=e.sibling;c=Tg(e,{mode:"visible",children:c});0===(b.mode&2)&&(c.lanes=d);c.return=b;c.sibling=null;null!==a&&(a.nextEffect=null,a.flags=8,b.firstEffect=b.lastEffect=a);return b.child=c}
function wi(a,b,c,d,e){var f=b.mode,g=a.child;a=g.sibling;var h={mode:"hidden",children:c};0===(f&2)&&b.child!==g?(c=b.child,c.childLanes=0,c.pendingProps=h,g=c.lastEffect,null!==g?(b.firstEffect=c.firstEffect,b.lastEffect=g,g.nextEffect=null):b.firstEffect=b.lastEffect=null):c=Tg(g,h);null!==a?d=Tg(a,d):(d=Xg(d,f,e,null),d.flags|=2);d.return=b;c.return=b;c.sibling=d;b.child=c;return d}function yi(a,b){a.lanes|=b;var c=a.alternate;null!==c&&(c.lanes|=b);sg(a.return,b)}
function zi(a,b,c,d,e,f){var g=a.memoizedState;null===g?a.memoizedState={isBackwards:b,rendering:null,renderingStartTime:0,last:d,tail:c,tailMode:e,lastEffect:f}:(g.isBackwards=b,g.rendering=null,g.renderingStartTime=0,g.last=d,g.tail=c,g.tailMode=e,g.lastEffect=f)}
function Ai(a,b,c){var d=b.pendingProps,e=d.revealOrder,f=d.tail;fi(a,b,d.children,c);d=P.current;if(0!==(d&2))d=d&1|2,b.flags|=64;else{if(null!==a&&0!==(a.flags&64))a:for(a=b.child;null!==a;){if(13===a.tag)null!==a.memoizedState&&yi(a,c);else if(19===a.tag)yi(a,c);else if(null!==a.child){a.child.return=a;a=a.child;continue}if(a===b)break a;for(;null===a.sibling;){if(null===a.return||a.return===b)break a;a=a.return}a.sibling.return=a.return;a=a.sibling}d&=1}I(P,d);if(0===(b.mode&2))b.memoizedState=
null;else switch(e){case "forwards":c=b.child;for(e=null;null!==c;)a=c.alternate,null!==a&&null===ih(a)&&(e=c),c=c.sibling;c=e;null===c?(e=b.child,b.child=null):(e=c.sibling,c.sibling=null);zi(b,!1,e,c,f,b.lastEffect);break;case "backwards":c=null;e=b.child;for(b.child=null;null!==e;){a=e.alternate;if(null!==a&&null===ih(a)){b.child=e;break}a=e.sibling;e.sibling=c;c=e;e=a}zi(b,!0,c,null,f,b.lastEffect);break;case "together":zi(b,!1,null,null,void 0,b.lastEffect);break;default:b.memoizedState=null}return b.child}
function hi(a,b,c){null!==a&&(b.dependencies=a.dependencies);Dg|=b.lanes;if(0!==(c&b.childLanes)){if(null!==a&&b.child!==a.child)throw Error(y(153));if(null!==b.child){a=b.child;c=Tg(a,a.pendingProps);b.child=c;for(c.return=b;null!==a.sibling;)a=a.sibling,c=c.sibling=Tg(a,a.pendingProps),c.return=b;c.sibling=null}return b.child}return null}var Bi,Ci,Di,Ei;
Bi=function(a,b){for(var c=b.child;null!==c;){if(5===c.tag||6===c.tag)a.appendChild(c.stateNode);else if(4!==c.tag&&null!==c.child){c.child.return=c;c=c.child;continue}if(c===b)break;for(;null===c.sibling;){if(null===c.return||c.return===b)return;c=c.return}c.sibling.return=c.return;c=c.sibling}};Ci=function(){};
Di=function(a,b,c,d){var e=a.memoizedProps;if(e!==d){a=b.stateNode;dh(ah.current);var f=null;switch(c){case "input":e=Ya(a,e);d=Ya(a,d);f=[];break;case "option":e=eb(a,e);d=eb(a,d);f=[];break;case "select":e=m({},e,{value:void 0});d=m({},d,{value:void 0});f=[];break;case "textarea":e=gb(a,e);d=gb(a,d);f=[];break;default:"function"!==typeof e.onClick&&"function"===typeof d.onClick&&(a.onclick=jf)}vb(c,d);var g;c=null;for(l in e)if(!d.hasOwnProperty(l)&&e.hasOwnProperty(l)&&null!=e[l])if("style"===
l){var h=e[l];for(g in h)h.hasOwnProperty(g)&&(c||(c={}),c[g]="")}else"dangerouslySetInnerHTML"!==l&&"children"!==l&&"suppressContentEditableWarning"!==l&&"suppressHydrationWarning"!==l&&"autoFocus"!==l&&(ca.hasOwnProperty(l)?f||(f=[]):(f=f||[]).push(l,null));for(l in d){var k=d[l];h=null!=e?e[l]:void 0;if(d.hasOwnProperty(l)&&k!==h&&(null!=k||null!=h))if("style"===l)if(h){for(g in h)!h.hasOwnProperty(g)||k&&k.hasOwnProperty(g)||(c||(c={}),c[g]="");for(g in k)k.hasOwnProperty(g)&&h[g]!==k[g]&&(c||
(c={}),c[g]=k[g])}else c||(f||(f=[]),f.push(l,c)),c=k;else"dangerouslySetInnerHTML"===l?(k=k?k.__html:void 0,h=h?h.__html:void 0,null!=k&&h!==k&&(f=f||[]).push(l,k)):"children"===l?"string"!==typeof k&&"number"!==typeof k||(f=f||[]).push(l,""+k):"suppressContentEditableWarning"!==l&&"suppressHydrationWarning"!==l&&(ca.hasOwnProperty(l)?(null!=k&&"onScroll"===l&&G("scroll",a),f||h===k||(f=[])):"object"===typeof k&&null!==k&&k.$$typeof===Ga?k.toString():(f=f||[]).push(l,k))}c&&(f=f||[]).push("style",
c);var l=f;if(b.updateQueue=l)b.flags|=4}};Ei=function(a,b,c,d){c!==d&&(b.flags|=4)};function Fi(a,b){if(!lh)switch(a.tailMode){case "hidden":b=a.tail;for(var c=null;null!==b;)null!==b.alternate&&(c=b),b=b.sibling;null===c?a.tail=null:c.sibling=null;break;case "collapsed":c=a.tail;for(var d=null;null!==c;)null!==c.alternate&&(d=c),c=c.sibling;null===d?b||null===a.tail?a.tail=null:a.tail.sibling=null:d.sibling=null}}
function Gi(a,b,c){var d=b.pendingProps;switch(b.tag){case 2:case 16:case 15:case 0:case 11:case 7:case 8:case 12:case 9:case 14:return null;case 1:return Ff(b.type)&&Gf(),null;case 3:fh();H(N);H(M);uh();d=b.stateNode;d.pendingContext&&(d.context=d.pendingContext,d.pendingContext=null);if(null===a||null===a.child)rh(b)?b.flags|=4:d.hydrate||(b.flags|=256);Ci(b);return null;case 5:hh(b);var e=dh(ch.current);c=b.type;if(null!==a&&null!=b.stateNode)Di(a,b,c,d,e),a.ref!==b.ref&&(b.flags|=128);else{if(!d){if(null===
b.stateNode)throw Error(y(166));return null}a=dh(ah.current);if(rh(b)){d=b.stateNode;c=b.type;var f=b.memoizedProps;d[wf]=b;d[xf]=f;switch(c){case "dialog":G("cancel",d);G("close",d);break;case "iframe":case "object":case "embed":G("load",d);break;case "video":case "audio":for(a=0;a<Xe.length;a++)G(Xe[a],d);break;case "source":G("error",d);break;case "img":case "image":case "link":G("error",d);G("load",d);break;case "details":G("toggle",d);break;case "input":Za(d,f);G("invalid",d);break;case "select":d._wrapperState=
{wasMultiple:!!f.multiple};G("invalid",d);break;case "textarea":hb(d,f),G("invalid",d)}vb(c,f);a=null;for(var g in f)f.hasOwnProperty(g)&&(e=f[g],"children"===g?"string"===typeof e?d.textContent!==e&&(a=["children",e]):"number"===typeof e&&d.textContent!==""+e&&(a=["children",""+e]):ca.hasOwnProperty(g)&&null!=e&&"onScroll"===g&&G("scroll",d));switch(c){case "input":Va(d);cb(d,f,!0);break;case "textarea":Va(d);jb(d);break;case "select":case "option":break;default:"function"===typeof f.onClick&&(d.onclick=
jf)}d=a;b.updateQueue=d;null!==d&&(b.flags|=4)}else{g=9===e.nodeType?e:e.ownerDocument;a===kb.html&&(a=lb(c));a===kb.html?"script"===c?(a=g.createElement("div"),a.innerHTML="<script>\x3c/script>",a=a.removeChild(a.firstChild)):"string"===typeof d.is?a=g.createElement(c,{is:d.is}):(a=g.createElement(c),"select"===c&&(g=a,d.multiple?g.multiple=!0:d.size&&(g.size=d.size))):a=g.createElementNS(a,c);a[wf]=b;a[xf]=d;Bi(a,b,!1,!1);b.stateNode=a;g=wb(c,d);switch(c){case "dialog":G("cancel",a);G("close",a);
e=d;break;case "iframe":case "object":case "embed":G("load",a);e=d;break;case "video":case "audio":for(e=0;e<Xe.length;e++)G(Xe[e],a);e=d;break;case "source":G("error",a);e=d;break;case "img":case "image":case "link":G("error",a);G("load",a);e=d;break;case "details":G("toggle",a);e=d;break;case "input":Za(a,d);e=Ya(a,d);G("invalid",a);break;case "option":e=eb(a,d);break;case "select":a._wrapperState={wasMultiple:!!d.multiple};e=m({},d,{value:void 0});G("invalid",a);break;case "textarea":hb(a,d);e=
gb(a,d);G("invalid",a);break;default:e=d}vb(c,e);var h=e;for(f in h)if(h.hasOwnProperty(f)){var k=h[f];"style"===f?tb(a,k):"dangerouslySetInnerHTML"===f?(k=k?k.__html:void 0,null!=k&&ob(a,k)):"children"===f?"string"===typeof k?("textarea"!==c||""!==k)&&pb(a,k):"number"===typeof k&&pb(a,""+k):"suppressContentEditableWarning"!==f&&"suppressHydrationWarning"!==f&&"autoFocus"!==f&&(ca.hasOwnProperty(f)?null!=k&&"onScroll"===f&&G("scroll",a):null!=k&&qa(a,f,k,g))}switch(c){case "input":Va(a);cb(a,d,!1);
break;case "textarea":Va(a);jb(a);break;case "option":null!=d.value&&a.setAttribute("value",""+Sa(d.value));break;case "select":a.multiple=!!d.multiple;f=d.value;null!=f?fb(a,!!d.multiple,f,!1):null!=d.defaultValue&&fb(a,!!d.multiple,d.defaultValue,!0);break;default:"function"===typeof e.onClick&&(a.onclick=jf)}mf(c,d)&&(b.flags|=4)}null!==b.ref&&(b.flags|=128)}return null;case 6:if(a&&null!=b.stateNode)Ei(a,b,a.memoizedProps,d);else{if("string"!==typeof d&&null===b.stateNode)throw Error(y(166));
c=dh(ch.current);dh(ah.current);rh(b)?(d=b.stateNode,c=b.memoizedProps,d[wf]=b,d.nodeValue!==c&&(b.flags|=4)):(d=(9===c.nodeType?c:c.ownerDocument).createTextNode(d),d[wf]=b,b.stateNode=d)}return null;case 13:H(P);d=b.memoizedState;if(0!==(b.flags&64))return b.lanes=c,b;d=null!==d;c=!1;null===a?void 0!==b.memoizedProps.fallback&&rh(b):c=null!==a.memoizedState;if(d&&!c&&0!==(b.mode&2))if(null===a&&!0!==b.memoizedProps.unstable_avoidThisFallback||0!==(P.current&1))0===V&&(V=3);else{if(0===V||3===V)V=
4;null===U||0===(Dg&134217727)&&0===(Hi&134217727)||Ii(U,W)}if(d||c)b.flags|=4;return null;case 4:return fh(),Ci(b),null===a&&cf(b.stateNode.containerInfo),null;case 10:return rg(b),null;case 17:return Ff(b.type)&&Gf(),null;case 19:H(P);d=b.memoizedState;if(null===d)return null;f=0!==(b.flags&64);g=d.rendering;if(null===g)if(f)Fi(d,!1);else{if(0!==V||null!==a&&0!==(a.flags&64))for(a=b.child;null!==a;){g=ih(a);if(null!==g){b.flags|=64;Fi(d,!1);f=g.updateQueue;null!==f&&(b.updateQueue=f,b.flags|=4);
null===d.lastEffect&&(b.firstEffect=null);b.lastEffect=d.lastEffect;d=c;for(c=b.child;null!==c;)f=c,a=d,f.flags&=2,f.nextEffect=null,f.firstEffect=null,f.lastEffect=null,g=f.alternate,null===g?(f.childLanes=0,f.lanes=a,f.child=null,f.memoizedProps=null,f.memoizedState=null,f.updateQueue=null,f.dependencies=null,f.stateNode=null):(f.childLanes=g.childLanes,f.lanes=g.lanes,f.child=g.child,f.memoizedProps=g.memoizedProps,f.memoizedState=g.memoizedState,f.updateQueue=g.updateQueue,f.type=g.type,a=g.dependencies,
f.dependencies=null===a?null:{lanes:a.lanes,firstContext:a.firstContext}),c=c.sibling;I(P,P.current&1|2);return b.child}a=a.sibling}null!==d.tail&&O()>Ji&&(b.flags|=64,f=!0,Fi(d,!1),b.lanes=33554432)}else{if(!f)if(a=ih(g),null!==a){if(b.flags|=64,f=!0,c=a.updateQueue,null!==c&&(b.updateQueue=c,b.flags|=4),Fi(d,!0),null===d.tail&&"hidden"===d.tailMode&&!g.alternate&&!lh)return b=b.lastEffect=d.lastEffect,null!==b&&(b.nextEffect=null),null}else 2*O()-d.renderingStartTime>Ji&&1073741824!==c&&(b.flags|=
64,f=!0,Fi(d,!1),b.lanes=33554432);d.isBackwards?(g.sibling=b.child,b.child=g):(c=d.last,null!==c?c.sibling=g:b.child=g,d.last=g)}return null!==d.tail?(c=d.tail,d.rendering=c,d.tail=c.sibling,d.lastEffect=b.lastEffect,d.renderingStartTime=O(),c.sibling=null,b=P.current,I(P,f?b&1|2:b&1),c):null;case 23:case 24:return Ki(),null!==a&&null!==a.memoizedState!==(null!==b.memoizedState)&&"unstable-defer-without-hiding"!==d.mode&&(b.flags|=4),null}throw Error(y(156,b.tag));}
function Li(a){switch(a.tag){case 1:Ff(a.type)&&Gf();var b=a.flags;return b&4096?(a.flags=b&-4097|64,a):null;case 3:fh();H(N);H(M);uh();b=a.flags;if(0!==(b&64))throw Error(y(285));a.flags=b&-4097|64;return a;case 5:return hh(a),null;case 13:return H(P),b=a.flags,b&4096?(a.flags=b&-4097|64,a):null;case 19:return H(P),null;case 4:return fh(),null;case 10:return rg(a),null;case 23:case 24:return Ki(),null;default:return null}}
function Mi(a,b){try{var c="",d=b;do c+=Qa(d),d=d.return;while(d);var e=c}catch(f){e="\nError generating stack: "+f.message+"\n"+f.stack}return{value:a,source:b,stack:e}}function Ni(a,b){try{console.error(b.value)}catch(c){setTimeout(function(){throw c;})}}var Oi="function"===typeof WeakMap?WeakMap:Map;function Pi(a,b,c){c=zg(-1,c);c.tag=3;c.payload={element:null};var d=b.value;c.callback=function(){Qi||(Qi=!0,Ri=d);Ni(a,b)};return c}
function Si(a,b,c){c=zg(-1,c);c.tag=3;var d=a.type.getDerivedStateFromError;if("function"===typeof d){var e=b.value;c.payload=function(){Ni(a,b);return d(e)}}var f=a.stateNode;null!==f&&"function"===typeof f.componentDidCatch&&(c.callback=function(){"function"!==typeof d&&(null===Ti?Ti=new Set([this]):Ti.add(this),Ni(a,b));var c=b.stack;this.componentDidCatch(b.value,{componentStack:null!==c?c:""})});return c}var Ui="function"===typeof WeakSet?WeakSet:Set;
function Vi(a){var b=a.ref;if(null!==b)if("function"===typeof b)try{b(null)}catch(c){Wi(a,c)}else b.current=null}function Xi(a,b){switch(b.tag){case 0:case 11:case 15:case 22:return;case 1:if(b.flags&256&&null!==a){var c=a.memoizedProps,d=a.memoizedState;a=b.stateNode;b=a.getSnapshotBeforeUpdate(b.elementType===b.type?c:lg(b.type,c),d);a.__reactInternalSnapshotBeforeUpdate=b}return;case 3:b.flags&256&&qf(b.stateNode.containerInfo);return;case 5:case 6:case 4:case 17:return}throw Error(y(163));}
function Yi(a,b,c){switch(c.tag){case 0:case 11:case 15:case 22:b=c.updateQueue;b=null!==b?b.lastEffect:null;if(null!==b){a=b=b.next;do{if(3===(a.tag&3)){var d=a.create;a.destroy=d()}a=a.next}while(a!==b)}b=c.updateQueue;b=null!==b?b.lastEffect:null;if(null!==b){a=b=b.next;do{var e=a;d=e.next;e=e.tag;0!==(e&4)&&0!==(e&1)&&(Zi(c,a),$i(c,a));a=d}while(a!==b)}return;case 1:a=c.stateNode;c.flags&4&&(null===b?a.componentDidMount():(d=c.elementType===c.type?b.memoizedProps:lg(c.type,b.memoizedProps),a.componentDidUpdate(d,
b.memoizedState,a.__reactInternalSnapshotBeforeUpdate)));b=c.updateQueue;null!==b&&Eg(c,b,a);return;case 3:b=c.updateQueue;if(null!==b){a=null;if(null!==c.child)switch(c.child.tag){case 5:a=c.child.stateNode;break;case 1:a=c.child.stateNode}Eg(c,b,a)}return;case 5:a=c.stateNode;null===b&&c.flags&4&&mf(c.type,c.memoizedProps)&&a.focus();return;case 6:return;case 4:return;case 12:return;case 13:null===c.memoizedState&&(c=c.alternate,null!==c&&(c=c.memoizedState,null!==c&&(c=c.dehydrated,null!==c&&Cc(c))));
return;case 19:case 17:case 20:case 21:case 23:case 24:return}throw Error(y(163));}
function aj(a,b){for(var c=a;;){if(5===c.tag){var d=c.stateNode;if(b)d=d.style,"function"===typeof d.setProperty?d.setProperty("display","none","important"):d.display="none";else{d=c.stateNode;var e=c.memoizedProps.style;e=void 0!==e&&null!==e&&e.hasOwnProperty("display")?e.display:null;d.style.display=sb("display",e)}}else if(6===c.tag)c.stateNode.nodeValue=b?"":c.memoizedProps;else if((23!==c.tag&&24!==c.tag||null===c.memoizedState||c===a)&&null!==c.child){c.child.return=c;c=c.child;continue}if(c===
a)break;for(;null===c.sibling;){if(null===c.return||c.return===a)return;c=c.return}c.sibling.return=c.return;c=c.sibling}}
function bj(a,b){if(Mf&&"function"===typeof Mf.onCommitFiberUnmount)try{Mf.onCommitFiberUnmount(Lf,b)}catch(f){}switch(b.tag){case 0:case 11:case 14:case 15:case 22:a=b.updateQueue;if(null!==a&&(a=a.lastEffect,null!==a)){var c=a=a.next;do{var d=c,e=d.destroy;d=d.tag;if(void 0!==e)if(0!==(d&4))Zi(b,c);else{d=b;try{e()}catch(f){Wi(d,f)}}c=c.next}while(c!==a)}break;case 1:Vi(b);a=b.stateNode;if("function"===typeof a.componentWillUnmount)try{a.props=b.memoizedProps,a.state=b.memoizedState,a.componentWillUnmount()}catch(f){Wi(b,
f)}break;case 5:Vi(b);break;case 4:cj(a,b)}}function dj(a){a.alternate=null;a.child=null;a.dependencies=null;a.firstEffect=null;a.lastEffect=null;a.memoizedProps=null;a.memoizedState=null;a.pendingProps=null;a.return=null;a.updateQueue=null}function ej(a){return 5===a.tag||3===a.tag||4===a.tag}
function fj(a){a:{for(var b=a.return;null!==b;){if(ej(b))break a;b=b.return}throw Error(y(160));}var c=b;b=c.stateNode;switch(c.tag){case 5:var d=!1;break;case 3:b=b.containerInfo;d=!0;break;case 4:b=b.containerInfo;d=!0;break;default:throw Error(y(161));}c.flags&16&&(pb(b,""),c.flags&=-17);a:b:for(c=a;;){for(;null===c.sibling;){if(null===c.return||ej(c.return)){c=null;break a}c=c.return}c.sibling.return=c.return;for(c=c.sibling;5!==c.tag&&6!==c.tag&&18!==c.tag;){if(c.flags&2)continue b;if(null===
c.child||4===c.tag)continue b;else c.child.return=c,c=c.child}if(!(c.flags&2)){c=c.stateNode;break a}}d?gj(a,c,b):hj(a,c,b)}
function gj(a,b,c){var d=a.tag,e=5===d||6===d;if(e)a=e?a.stateNode:a.stateNode.instance,b?8===c.nodeType?c.parentNode.insertBefore(a,b):c.insertBefore(a,b):(8===c.nodeType?(b=c.parentNode,b.insertBefore(a,c)):(b=c,b.appendChild(a)),c=c._reactRootContainer,null!==c&&void 0!==c||null!==b.onclick||(b.onclick=jf));else if(4!==d&&(a=a.child,null!==a))for(gj(a,b,c),a=a.sibling;null!==a;)gj(a,b,c),a=a.sibling}
function hj(a,b,c){var d=a.tag,e=5===d||6===d;if(e)a=e?a.stateNode:a.stateNode.instance,b?c.insertBefore(a,b):c.appendChild(a);else if(4!==d&&(a=a.child,null!==a))for(hj(a,b,c),a=a.sibling;null!==a;)hj(a,b,c),a=a.sibling}
function cj(a,b){for(var c=b,d=!1,e,f;;){if(!d){d=c.return;a:for(;;){if(null===d)throw Error(y(160));e=d.stateNode;switch(d.tag){case 5:f=!1;break a;case 3:e=e.containerInfo;f=!0;break a;case 4:e=e.containerInfo;f=!0;break a}d=d.return}d=!0}if(5===c.tag||6===c.tag){a:for(var g=a,h=c,k=h;;)if(bj(g,k),null!==k.child&&4!==k.tag)k.child.return=k,k=k.child;else{if(k===h)break a;for(;null===k.sibling;){if(null===k.return||k.return===h)break a;k=k.return}k.sibling.return=k.return;k=k.sibling}f?(g=e,h=c.stateNode,
8===g.nodeType?g.parentNode.removeChild(h):g.removeChild(h)):e.removeChild(c.stateNode)}else if(4===c.tag){if(null!==c.child){e=c.stateNode.containerInfo;f=!0;c.child.return=c;c=c.child;continue}}else if(bj(a,c),null!==c.child){c.child.return=c;c=c.child;continue}if(c===b)break;for(;null===c.sibling;){if(null===c.return||c.return===b)return;c=c.return;4===c.tag&&(d=!1)}c.sibling.return=c.return;c=c.sibling}}
function ij(a,b){switch(b.tag){case 0:case 11:case 14:case 15:case 22:var c=b.updateQueue;c=null!==c?c.lastEffect:null;if(null!==c){var d=c=c.next;do 3===(d.tag&3)&&(a=d.destroy,d.destroy=void 0,void 0!==a&&a()),d=d.next;while(d!==c)}return;case 1:return;case 5:c=b.stateNode;if(null!=c){d=b.memoizedProps;var e=null!==a?a.memoizedProps:d;a=b.type;var f=b.updateQueue;b.updateQueue=null;if(null!==f){c[xf]=d;"input"===a&&"radio"===d.type&&null!=d.name&&$a(c,d);wb(a,e);b=wb(a,d);for(e=0;e<f.length;e+=
2){var g=f[e],h=f[e+1];"style"===g?tb(c,h):"dangerouslySetInnerHTML"===g?ob(c,h):"children"===g?pb(c,h):qa(c,g,h,b)}switch(a){case "input":ab(c,d);break;case "textarea":ib(c,d);break;case "select":a=c._wrapperState.wasMultiple,c._wrapperState.wasMultiple=!!d.multiple,f=d.value,null!=f?fb(c,!!d.multiple,f,!1):a!==!!d.multiple&&(null!=d.defaultValue?fb(c,!!d.multiple,d.defaultValue,!0):fb(c,!!d.multiple,d.multiple?[]:"",!1))}}}return;case 6:if(null===b.stateNode)throw Error(y(162));b.stateNode.nodeValue=
b.memoizedProps;return;case 3:c=b.stateNode;c.hydrate&&(c.hydrate=!1,Cc(c.containerInfo));return;case 12:return;case 13:null!==b.memoizedState&&(jj=O(),aj(b.child,!0));kj(b);return;case 19:kj(b);return;case 17:return;case 23:case 24:aj(b,null!==b.memoizedState);return}throw Error(y(163));}function kj(a){var b=a.updateQueue;if(null!==b){a.updateQueue=null;var c=a.stateNode;null===c&&(c=a.stateNode=new Ui);b.forEach(function(b){var d=lj.bind(null,a,b);c.has(b)||(c.add(b),b.then(d,d))})}}
function mj(a,b){return null!==a&&(a=a.memoizedState,null===a||null!==a.dehydrated)?(b=b.memoizedState,null!==b&&null===b.dehydrated):!1}var nj=Math.ceil,oj=ra.ReactCurrentDispatcher,pj=ra.ReactCurrentOwner,X=0,U=null,Y=null,W=0,qj=0,rj=Bf(0),V=0,sj=null,tj=0,Dg=0,Hi=0,uj=0,vj=null,jj=0,Ji=Infinity;function wj(){Ji=O()+500}var Z=null,Qi=!1,Ri=null,Ti=null,xj=!1,yj=null,zj=90,Aj=[],Bj=[],Cj=null,Dj=0,Ej=null,Fj=-1,Gj=0,Hj=0,Ij=null,Jj=!1;function Hg(){return 0!==(X&48)?O():-1!==Fj?Fj:Fj=O()}
function Ig(a){a=a.mode;if(0===(a&2))return 1;if(0===(a&4))return 99===eg()?1:2;0===Gj&&(Gj=tj);if(0!==kg.transition){0!==Hj&&(Hj=null!==vj?vj.pendingLanes:0);a=Gj;var b=4186112&~Hj;b&=-b;0===b&&(a=4186112&~a,b=a&-a,0===b&&(b=8192));return b}a=eg();0!==(X&4)&&98===a?a=Xc(12,Gj):(a=Sc(a),a=Xc(a,Gj));return a}
function Jg(a,b,c){if(50<Dj)throw Dj=0,Ej=null,Error(y(185));a=Kj(a,b);if(null===a)return null;$c(a,b,c);a===U&&(Hi|=b,4===V&&Ii(a,W));var d=eg();1===b?0!==(X&8)&&0===(X&48)?Lj(a):(Mj(a,c),0===X&&(wj(),ig())):(0===(X&4)||98!==d&&99!==d||(null===Cj?Cj=new Set([a]):Cj.add(a)),Mj(a,c));vj=a}function Kj(a,b){a.lanes|=b;var c=a.alternate;null!==c&&(c.lanes|=b);c=a;for(a=a.return;null!==a;)a.childLanes|=b,c=a.alternate,null!==c&&(c.childLanes|=b),c=a,a=a.return;return 3===c.tag?c.stateNode:null}
function Mj(a,b){for(var c=a.callbackNode,d=a.suspendedLanes,e=a.pingedLanes,f=a.expirationTimes,g=a.pendingLanes;0<g;){var h=31-Vc(g),k=1<<h,l=f[h];if(-1===l){if(0===(k&d)||0!==(k&e)){l=b;Rc(k);var n=F;f[h]=10<=n?l+250:6<=n?l+5E3:-1}}else l<=b&&(a.expiredLanes|=k);g&=~k}d=Uc(a,a===U?W:0);b=F;if(0===d)null!==c&&(c!==Zf&&Pf(c),a.callbackNode=null,a.callbackPriority=0);else{if(null!==c){if(a.callbackPriority===b)return;c!==Zf&&Pf(c)}15===b?(c=Lj.bind(null,a),null===ag?(ag=[c],bg=Of(Uf,jg)):ag.push(c),
c=Zf):14===b?c=hg(99,Lj.bind(null,a)):(c=Tc(b),c=hg(c,Nj.bind(null,a)));a.callbackPriority=b;a.callbackNode=c}}
function Nj(a){Fj=-1;Hj=Gj=0;if(0!==(X&48))throw Error(y(327));var b=a.callbackNode;if(Oj()&&a.callbackNode!==b)return null;var c=Uc(a,a===U?W:0);if(0===c)return null;var d=c;var e=X;X|=16;var f=Pj();if(U!==a||W!==d)wj(),Qj(a,d);do try{Rj();break}catch(h){Sj(a,h)}while(1);qg();oj.current=f;X=e;null!==Y?d=0:(U=null,W=0,d=V);if(0!==(tj&Hi))Qj(a,0);else if(0!==d){2===d&&(X|=64,a.hydrate&&(a.hydrate=!1,qf(a.containerInfo)),c=Wc(a),0!==c&&(d=Tj(a,c)));if(1===d)throw b=sj,Qj(a,0),Ii(a,c),Mj(a,O()),b;a.finishedWork=
a.current.alternate;a.finishedLanes=c;switch(d){case 0:case 1:throw Error(y(345));case 2:Uj(a);break;case 3:Ii(a,c);if((c&62914560)===c&&(d=jj+500-O(),10<d)){if(0!==Uc(a,0))break;e=a.suspendedLanes;if((e&c)!==c){Hg();a.pingedLanes|=a.suspendedLanes&e;break}a.timeoutHandle=of(Uj.bind(null,a),d);break}Uj(a);break;case 4:Ii(a,c);if((c&4186112)===c)break;d=a.eventTimes;for(e=-1;0<c;){var g=31-Vc(c);f=1<<g;g=d[g];g>e&&(e=g);c&=~f}c=e;c=O()-c;c=(120>c?120:480>c?480:1080>c?1080:1920>c?1920:3E3>c?3E3:4320>
c?4320:1960*nj(c/1960))-c;if(10<c){a.timeoutHandle=of(Uj.bind(null,a),c);break}Uj(a);break;case 5:Uj(a);break;default:throw Error(y(329));}}Mj(a,O());return a.callbackNode===b?Nj.bind(null,a):null}function Ii(a,b){b&=~uj;b&=~Hi;a.suspendedLanes|=b;a.pingedLanes&=~b;for(a=a.expirationTimes;0<b;){var c=31-Vc(b),d=1<<c;a[c]=-1;b&=~d}}
function Lj(a){if(0!==(X&48))throw Error(y(327));Oj();if(a===U&&0!==(a.expiredLanes&W)){var b=W;var c=Tj(a,b);0!==(tj&Hi)&&(b=Uc(a,b),c=Tj(a,b))}else b=Uc(a,0),c=Tj(a,b);0!==a.tag&&2===c&&(X|=64,a.hydrate&&(a.hydrate=!1,qf(a.containerInfo)),b=Wc(a),0!==b&&(c=Tj(a,b)));if(1===c)throw c=sj,Qj(a,0),Ii(a,b),Mj(a,O()),c;a.finishedWork=a.current.alternate;a.finishedLanes=b;Uj(a);Mj(a,O());return null}
function Vj(){if(null!==Cj){var a=Cj;Cj=null;a.forEach(function(a){a.expiredLanes|=24&a.pendingLanes;Mj(a,O())})}ig()}function Wj(a,b){var c=X;X|=1;try{return a(b)}finally{X=c,0===X&&(wj(),ig())}}function Xj(a,b){var c=X;X&=-2;X|=8;try{return a(b)}finally{X=c,0===X&&(wj(),ig())}}function ni(a,b){I(rj,qj);qj|=b;tj|=b}function Ki(){qj=rj.current;H(rj)}
function Qj(a,b){a.finishedWork=null;a.finishedLanes=0;var c=a.timeoutHandle;-1!==c&&(a.timeoutHandle=-1,pf(c));if(null!==Y)for(c=Y.return;null!==c;){var d=c;switch(d.tag){case 1:d=d.type.childContextTypes;null!==d&&void 0!==d&&Gf();break;case 3:fh();H(N);H(M);uh();break;case 5:hh(d);break;case 4:fh();break;case 13:H(P);break;case 19:H(P);break;case 10:rg(d);break;case 23:case 24:Ki()}c=c.return}U=a;Y=Tg(a.current,null);W=qj=tj=b;V=0;sj=null;uj=Hi=Dg=0}
function Sj(a,b){do{var c=Y;try{qg();vh.current=Gh;if(yh){for(var d=R.memoizedState;null!==d;){var e=d.queue;null!==e&&(e.pending=null);d=d.next}yh=!1}xh=0;T=S=R=null;zh=!1;pj.current=null;if(null===c||null===c.return){V=1;sj=b;Y=null;break}a:{var f=a,g=c.return,h=c,k=b;b=W;h.flags|=2048;h.firstEffect=h.lastEffect=null;if(null!==k&&"object"===typeof k&&"function"===typeof k.then){var l=k;if(0===(h.mode&2)){var n=h.alternate;n?(h.updateQueue=n.updateQueue,h.memoizedState=n.memoizedState,h.lanes=n.lanes):
(h.updateQueue=null,h.memoizedState=null)}var A=0!==(P.current&1),p=g;do{var C;if(C=13===p.tag){var x=p.memoizedState;if(null!==x)C=null!==x.dehydrated?!0:!1;else{var w=p.memoizedProps;C=void 0===w.fallback?!1:!0!==w.unstable_avoidThisFallback?!0:A?!1:!0}}if(C){var z=p.updateQueue;if(null===z){var u=new Set;u.add(l);p.updateQueue=u}else z.add(l);if(0===(p.mode&2)){p.flags|=64;h.flags|=16384;h.flags&=-2981;if(1===h.tag)if(null===h.alternate)h.tag=17;else{var t=zg(-1,1);t.tag=2;Ag(h,t)}h.lanes|=1;break a}k=
void 0;h=b;var q=f.pingCache;null===q?(q=f.pingCache=new Oi,k=new Set,q.set(l,k)):(k=q.get(l),void 0===k&&(k=new Set,q.set(l,k)));if(!k.has(h)){k.add(h);var v=Yj.bind(null,f,l,h);l.then(v,v)}p.flags|=4096;p.lanes=b;break a}p=p.return}while(null!==p);k=Error((Ra(h.type)||"A React component")+" suspended while rendering, but no fallback UI was specified.\n\nAdd a <Suspense fallback=...> component higher in the tree to provide a loading indicator or placeholder to display.")}5!==V&&(V=2);k=Mi(k,h);p=
g;do{switch(p.tag){case 3:f=k;p.flags|=4096;b&=-b;p.lanes|=b;var J=Pi(p,f,b);Bg(p,J);break a;case 1:f=k;var K=p.type,Q=p.stateNode;if(0===(p.flags&64)&&("function"===typeof K.getDerivedStateFromError||null!==Q&&"function"===typeof Q.componentDidCatch&&(null===Ti||!Ti.has(Q)))){p.flags|=4096;b&=-b;p.lanes|=b;var L=Si(p,f,b);Bg(p,L);break a}}p=p.return}while(null!==p)}Zj(c)}catch(va){b=va;Y===c&&null!==c&&(Y=c=c.return);continue}break}while(1)}
function Pj(){var a=oj.current;oj.current=Gh;return null===a?Gh:a}function Tj(a,b){var c=X;X|=16;var d=Pj();U===a&&W===b||Qj(a,b);do try{ak();break}catch(e){Sj(a,e)}while(1);qg();X=c;oj.current=d;if(null!==Y)throw Error(y(261));U=null;W=0;return V}function ak(){for(;null!==Y;)bk(Y)}function Rj(){for(;null!==Y&&!Qf();)bk(Y)}function bk(a){var b=ck(a.alternate,a,qj);a.memoizedProps=a.pendingProps;null===b?Zj(a):Y=b;pj.current=null}
function Zj(a){var b=a;do{var c=b.alternate;a=b.return;if(0===(b.flags&2048)){c=Gi(c,b,qj);if(null!==c){Y=c;return}c=b;if(24!==c.tag&&23!==c.tag||null===c.memoizedState||0!==(qj&1073741824)||0===(c.mode&4)){for(var d=0,e=c.child;null!==e;)d|=e.lanes|e.childLanes,e=e.sibling;c.childLanes=d}null!==a&&0===(a.flags&2048)&&(null===a.firstEffect&&(a.firstEffect=b.firstEffect),null!==b.lastEffect&&(null!==a.lastEffect&&(a.lastEffect.nextEffect=b.firstEffect),a.lastEffect=b.lastEffect),1<b.flags&&(null!==
a.lastEffect?a.lastEffect.nextEffect=b:a.firstEffect=b,a.lastEffect=b))}else{c=Li(b);if(null!==c){c.flags&=2047;Y=c;return}null!==a&&(a.firstEffect=a.lastEffect=null,a.flags|=2048)}b=b.sibling;if(null!==b){Y=b;return}Y=b=a}while(null!==b);0===V&&(V=5)}function Uj(a){var b=eg();gg(99,dk.bind(null,a,b));return null}
function dk(a,b){do Oj();while(null!==yj);if(0!==(X&48))throw Error(y(327));var c=a.finishedWork;if(null===c)return null;a.finishedWork=null;a.finishedLanes=0;if(c===a.current)throw Error(y(177));a.callbackNode=null;var d=c.lanes|c.childLanes,e=d,f=a.pendingLanes&~e;a.pendingLanes=e;a.suspendedLanes=0;a.pingedLanes=0;a.expiredLanes&=e;a.mutableReadLanes&=e;a.entangledLanes&=e;e=a.entanglements;for(var g=a.eventTimes,h=a.expirationTimes;0<f;){var k=31-Vc(f),l=1<<k;e[k]=0;g[k]=-1;h[k]=-1;f&=~l}null!==
Cj&&0===(d&24)&&Cj.has(a)&&Cj.delete(a);a===U&&(Y=U=null,W=0);1<c.flags?null!==c.lastEffect?(c.lastEffect.nextEffect=c,d=c.firstEffect):d=c:d=c.firstEffect;if(null!==d){e=X;X|=32;pj.current=null;kf=fd;g=Ne();if(Oe(g)){if("selectionStart"in g)h={start:g.selectionStart,end:g.selectionEnd};else a:if(h=(h=g.ownerDocument)&&h.defaultView||window,(l=h.getSelection&&h.getSelection())&&0!==l.rangeCount){h=l.anchorNode;f=l.anchorOffset;k=l.focusNode;l=l.focusOffset;try{h.nodeType,k.nodeType}catch(va){h=null;
break a}var n=0,A=-1,p=-1,C=0,x=0,w=g,z=null;b:for(;;){for(var u;;){w!==h||0!==f&&3!==w.nodeType||(A=n+f);w!==k||0!==l&&3!==w.nodeType||(p=n+l);3===w.nodeType&&(n+=w.nodeValue.length);if(null===(u=w.firstChild))break;z=w;w=u}for(;;){if(w===g)break b;z===h&&++C===f&&(A=n);z===k&&++x===l&&(p=n);if(null!==(u=w.nextSibling))break;w=z;z=w.parentNode}w=u}h=-1===A||-1===p?null:{start:A,end:p}}else h=null;h=h||{start:0,end:0}}else h=null;lf={focusedElem:g,selectionRange:h};fd=!1;Ij=null;Jj=!1;Z=d;do try{ek()}catch(va){if(null===
Z)throw Error(y(330));Wi(Z,va);Z=Z.nextEffect}while(null!==Z);Ij=null;Z=d;do try{for(g=a;null!==Z;){var t=Z.flags;t&16&&pb(Z.stateNode,"");if(t&128){var q=Z.alternate;if(null!==q){var v=q.ref;null!==v&&("function"===typeof v?v(null):v.current=null)}}switch(t&1038){case 2:fj(Z);Z.flags&=-3;break;case 6:fj(Z);Z.flags&=-3;ij(Z.alternate,Z);break;case 1024:Z.flags&=-1025;break;case 1028:Z.flags&=-1025;ij(Z.alternate,Z);break;case 4:ij(Z.alternate,Z);break;case 8:h=Z;cj(g,h);var J=h.alternate;dj(h);null!==
J&&dj(J)}Z=Z.nextEffect}}catch(va){if(null===Z)throw Error(y(330));Wi(Z,va);Z=Z.nextEffect}while(null!==Z);v=lf;q=Ne();t=v.focusedElem;g=v.selectionRange;if(q!==t&&t&&t.ownerDocument&&Me(t.ownerDocument.documentElement,t)){null!==g&&Oe(t)&&(q=g.start,v=g.end,void 0===v&&(v=q),"selectionStart"in t?(t.selectionStart=q,t.selectionEnd=Math.min(v,t.value.length)):(v=(q=t.ownerDocument||document)&&q.defaultView||window,v.getSelection&&(v=v.getSelection(),h=t.textContent.length,J=Math.min(g.start,h),g=void 0===
g.end?J:Math.min(g.end,h),!v.extend&&J>g&&(h=g,g=J,J=h),h=Le(t,J),f=Le(t,g),h&&f&&(1!==v.rangeCount||v.anchorNode!==h.node||v.anchorOffset!==h.offset||v.focusNode!==f.node||v.focusOffset!==f.offset)&&(q=q.createRange(),q.setStart(h.node,h.offset),v.removeAllRanges(),J>g?(v.addRange(q),v.extend(f.node,f.offset)):(q.setEnd(f.node,f.offset),v.addRange(q))))));q=[];for(v=t;v=v.parentNode;)1===v.nodeType&&q.push({element:v,left:v.scrollLeft,top:v.scrollTop});"function"===typeof t.focus&&t.focus();for(t=
0;t<q.length;t++)v=q[t],v.element.scrollLeft=v.left,v.element.scrollTop=v.top}fd=!!kf;lf=kf=null;a.current=c;Z=d;do try{for(t=a;null!==Z;){var K=Z.flags;K&36&&Yi(t,Z.alternate,Z);if(K&128){q=void 0;var Q=Z.ref;if(null!==Q){var L=Z.stateNode;switch(Z.tag){case 5:q=L;break;default:q=L}"function"===typeof Q?Q(q):Q.current=q}}Z=Z.nextEffect}}catch(va){if(null===Z)throw Error(y(330));Wi(Z,va);Z=Z.nextEffect}while(null!==Z);Z=null;$f();X=e}else a.current=c;if(xj)xj=!1,yj=a,zj=b;else for(Z=d;null!==Z;)b=
Z.nextEffect,Z.nextEffect=null,Z.flags&8&&(K=Z,K.sibling=null,K.stateNode=null),Z=b;d=a.pendingLanes;0===d&&(Ti=null);1===d?a===Ej?Dj++:(Dj=0,Ej=a):Dj=0;c=c.stateNode;if(Mf&&"function"===typeof Mf.onCommitFiberRoot)try{Mf.onCommitFiberRoot(Lf,c,void 0,64===(c.current.flags&64))}catch(va){}Mj(a,O());if(Qi)throw Qi=!1,a=Ri,Ri=null,a;if(0!==(X&8))return null;ig();return null}
function ek(){for(;null!==Z;){var a=Z.alternate;Jj||null===Ij||(0!==(Z.flags&8)?dc(Z,Ij)&&(Jj=!0):13===Z.tag&&mj(a,Z)&&dc(Z,Ij)&&(Jj=!0));var b=Z.flags;0!==(b&256)&&Xi(a,Z);0===(b&512)||xj||(xj=!0,hg(97,function(){Oj();return null}));Z=Z.nextEffect}}function Oj(){if(90!==zj){var a=97<zj?97:zj;zj=90;return gg(a,fk)}return!1}function $i(a,b){Aj.push(b,a);xj||(xj=!0,hg(97,function(){Oj();return null}))}function Zi(a,b){Bj.push(b,a);xj||(xj=!0,hg(97,function(){Oj();return null}))}
function fk(){if(null===yj)return!1;var a=yj;yj=null;if(0!==(X&48))throw Error(y(331));var b=X;X|=32;var c=Bj;Bj=[];for(var d=0;d<c.length;d+=2){var e=c[d],f=c[d+1],g=e.destroy;e.destroy=void 0;if("function"===typeof g)try{g()}catch(k){if(null===f)throw Error(y(330));Wi(f,k)}}c=Aj;Aj=[];for(d=0;d<c.length;d+=2){e=c[d];f=c[d+1];try{var h=e.create;e.destroy=h()}catch(k){if(null===f)throw Error(y(330));Wi(f,k)}}for(h=a.current.firstEffect;null!==h;)a=h.nextEffect,h.nextEffect=null,h.flags&8&&(h.sibling=
null,h.stateNode=null),h=a;X=b;ig();return!0}function gk(a,b,c){b=Mi(c,b);b=Pi(a,b,1);Ag(a,b);b=Hg();a=Kj(a,1);null!==a&&($c(a,1,b),Mj(a,b))}
function Wi(a,b){if(3===a.tag)gk(a,a,b);else for(var c=a.return;null!==c;){if(3===c.tag){gk(c,a,b);break}else if(1===c.tag){var d=c.stateNode;if("function"===typeof c.type.getDerivedStateFromError||"function"===typeof d.componentDidCatch&&(null===Ti||!Ti.has(d))){a=Mi(b,a);var e=Si(c,a,1);Ag(c,e);e=Hg();c=Kj(c,1);if(null!==c)$c(c,1,e),Mj(c,e);else if("function"===typeof d.componentDidCatch&&(null===Ti||!Ti.has(d)))try{d.componentDidCatch(b,a)}catch(f){}break}}c=c.return}}
function Yj(a,b,c){var d=a.pingCache;null!==d&&d.delete(b);b=Hg();a.pingedLanes|=a.suspendedLanes&c;U===a&&(W&c)===c&&(4===V||3===V&&(W&62914560)===W&&500>O()-jj?Qj(a,0):uj|=c);Mj(a,b)}function lj(a,b){var c=a.stateNode;null!==c&&c.delete(b);b=0;0===b&&(b=a.mode,0===(b&2)?b=1:0===(b&4)?b=99===eg()?1:2:(0===Gj&&(Gj=tj),b=Yc(62914560&~Gj),0===b&&(b=4194304)));c=Hg();a=Kj(a,b);null!==a&&($c(a,b,c),Mj(a,c))}var ck;
ck=function(a,b,c){var d=b.lanes;if(null!==a)if(a.memoizedProps!==b.pendingProps||N.current)ug=!0;else if(0!==(c&d))ug=0!==(a.flags&16384)?!0:!1;else{ug=!1;switch(b.tag){case 3:ri(b);sh();break;case 5:gh(b);break;case 1:Ff(b.type)&&Jf(b);break;case 4:eh(b,b.stateNode.containerInfo);break;case 10:d=b.memoizedProps.value;var e=b.type._context;I(mg,e._currentValue);e._currentValue=d;break;case 13:if(null!==b.memoizedState){if(0!==(c&b.child.childLanes))return ti(a,b,c);I(P,P.current&1);b=hi(a,b,c);return null!==
b?b.sibling:null}I(P,P.current&1);break;case 19:d=0!==(c&b.childLanes);if(0!==(a.flags&64)){if(d)return Ai(a,b,c);b.flags|=64}e=b.memoizedState;null!==e&&(e.rendering=null,e.tail=null,e.lastEffect=null);I(P,P.current);if(d)break;else return null;case 23:case 24:return b.lanes=0,mi(a,b,c)}return hi(a,b,c)}else ug=!1;b.lanes=0;switch(b.tag){case 2:d=b.type;null!==a&&(a.alternate=null,b.alternate=null,b.flags|=2);a=b.pendingProps;e=Ef(b,M.current);tg(b,c);e=Ch(null,b,d,a,e,c);b.flags|=1;if("object"===
typeof e&&null!==e&&"function"===typeof e.render&&void 0===e.$$typeof){b.tag=1;b.memoizedState=null;b.updateQueue=null;if(Ff(d)){var f=!0;Jf(b)}else f=!1;b.memoizedState=null!==e.state&&void 0!==e.state?e.state:null;xg(b);var g=d.getDerivedStateFromProps;"function"===typeof g&&Gg(b,d,g,a);e.updater=Kg;b.stateNode=e;e._reactInternals=b;Og(b,d,a,c);b=qi(null,b,d,!0,f,c)}else b.tag=0,fi(null,b,e,c),b=b.child;return b;case 16:e=b.elementType;a:{null!==a&&(a.alternate=null,b.alternate=null,b.flags|=2);
a=b.pendingProps;f=e._init;e=f(e._payload);b.type=e;f=b.tag=hk(e);a=lg(e,a);switch(f){case 0:b=li(null,b,e,a,c);break a;case 1:b=pi(null,b,e,a,c);break a;case 11:b=gi(null,b,e,a,c);break a;case 14:b=ii(null,b,e,lg(e.type,a),d,c);break a}throw Error(y(306,e,""));}return b;case 0:return d=b.type,e=b.pendingProps,e=b.elementType===d?e:lg(d,e),li(a,b,d,e,c);case 1:return d=b.type,e=b.pendingProps,e=b.elementType===d?e:lg(d,e),pi(a,b,d,e,c);case 3:ri(b);d=b.updateQueue;if(null===a||null===d)throw Error(y(282));
d=b.pendingProps;e=b.memoizedState;e=null!==e?e.element:null;yg(a,b);Cg(b,d,null,c);d=b.memoizedState.element;if(d===e)sh(),b=hi(a,b,c);else{e=b.stateNode;if(f=e.hydrate)kh=rf(b.stateNode.containerInfo.firstChild),jh=b,f=lh=!0;if(f){a=e.mutableSourceEagerHydrationData;if(null!=a)for(e=0;e<a.length;e+=2)f=a[e],f._workInProgressVersionPrimary=a[e+1],th.push(f);c=Zg(b,null,d,c);for(b.child=c;c;)c.flags=c.flags&-3|1024,c=c.sibling}else fi(a,b,d,c),sh();b=b.child}return b;case 5:return gh(b),null===a&&
ph(b),d=b.type,e=b.pendingProps,f=null!==a?a.memoizedProps:null,g=e.children,nf(d,e)?g=null:null!==f&&nf(d,f)&&(b.flags|=16),oi(a,b),fi(a,b,g,c),b.child;case 6:return null===a&&ph(b),null;case 13:return ti(a,b,c);case 4:return eh(b,b.stateNode.containerInfo),d=b.pendingProps,null===a?b.child=Yg(b,null,d,c):fi(a,b,d,c),b.child;case 11:return d=b.type,e=b.pendingProps,e=b.elementType===d?e:lg(d,e),gi(a,b,d,e,c);case 7:return fi(a,b,b.pendingProps,c),b.child;case 8:return fi(a,b,b.pendingProps.children,
c),b.child;case 12:return fi(a,b,b.pendingProps.children,c),b.child;case 10:a:{d=b.type._context;e=b.pendingProps;g=b.memoizedProps;f=e.value;var h=b.type._context;I(mg,h._currentValue);h._currentValue=f;if(null!==g)if(h=g.value,f=He(h,f)?0:("function"===typeof d._calculateChangedBits?d._calculateChangedBits(h,f):1073741823)|0,0===f){if(g.children===e.children&&!N.current){b=hi(a,b,c);break a}}else for(h=b.child,null!==h&&(h.return=b);null!==h;){var k=h.dependencies;if(null!==k){g=h.child;for(var l=
k.firstContext;null!==l;){if(l.context===d&&0!==(l.observedBits&f)){1===h.tag&&(l=zg(-1,c&-c),l.tag=2,Ag(h,l));h.lanes|=c;l=h.alternate;null!==l&&(l.lanes|=c);sg(h.return,c);k.lanes|=c;break}l=l.next}}else g=10===h.tag?h.type===b.type?null:h.child:h.child;if(null!==g)g.return=h;else for(g=h;null!==g;){if(g===b){g=null;break}h=g.sibling;if(null!==h){h.return=g.return;g=h;break}g=g.return}h=g}fi(a,b,e.children,c);b=b.child}return b;case 9:return e=b.type,f=b.pendingProps,d=f.children,tg(b,c),e=vg(e,
f.unstable_observedBits),d=d(e),b.flags|=1,fi(a,b,d,c),b.child;case 14:return e=b.type,f=lg(e,b.pendingProps),f=lg(e.type,f),ii(a,b,e,f,d,c);case 15:return ki(a,b,b.type,b.pendingProps,d,c);case 17:return d=b.type,e=b.pendingProps,e=b.elementType===d?e:lg(d,e),null!==a&&(a.alternate=null,b.alternate=null,b.flags|=2),b.tag=1,Ff(d)?(a=!0,Jf(b)):a=!1,tg(b,c),Mg(b,d,e),Og(b,d,e,c),qi(null,b,d,!0,a,c);case 19:return Ai(a,b,c);case 23:return mi(a,b,c);case 24:return mi(a,b,c)}throw Error(y(156,b.tag));
};function ik(a,b,c,d){this.tag=a;this.key=c;this.sibling=this.child=this.return=this.stateNode=this.type=this.elementType=null;this.index=0;this.ref=null;this.pendingProps=b;this.dependencies=this.memoizedState=this.updateQueue=this.memoizedProps=null;this.mode=d;this.flags=0;this.lastEffect=this.firstEffect=this.nextEffect=null;this.childLanes=this.lanes=0;this.alternate=null}function nh(a,b,c,d){return new ik(a,b,c,d)}function ji(a){a=a.prototype;return!(!a||!a.isReactComponent)}
function hk(a){if("function"===typeof a)return ji(a)?1:0;if(void 0!==a&&null!==a){a=a.$$typeof;if(a===Aa)return 11;if(a===Da)return 14}return 2}
function Tg(a,b){var c=a.alternate;null===c?(c=nh(a.tag,b,a.key,a.mode),c.elementType=a.elementType,c.type=a.type,c.stateNode=a.stateNode,c.alternate=a,a.alternate=c):(c.pendingProps=b,c.type=a.type,c.flags=0,c.nextEffect=null,c.firstEffect=null,c.lastEffect=null);c.childLanes=a.childLanes;c.lanes=a.lanes;c.child=a.child;c.memoizedProps=a.memoizedProps;c.memoizedState=a.memoizedState;c.updateQueue=a.updateQueue;b=a.dependencies;c.dependencies=null===b?null:{lanes:b.lanes,firstContext:b.firstContext};
c.sibling=a.sibling;c.index=a.index;c.ref=a.ref;return c}
function Vg(a,b,c,d,e,f){var g=2;d=a;if("function"===typeof a)ji(a)&&(g=1);else if("string"===typeof a)g=5;else a:switch(a){case ua:return Xg(c.children,e,f,b);case Ha:g=8;e|=16;break;case wa:g=8;e|=1;break;case xa:return a=nh(12,c,b,e|8),a.elementType=xa,a.type=xa,a.lanes=f,a;case Ba:return a=nh(13,c,b,e),a.type=Ba,a.elementType=Ba,a.lanes=f,a;case Ca:return a=nh(19,c,b,e),a.elementType=Ca,a.lanes=f,a;case Ia:return vi(c,e,f,b);case Ja:return a=nh(24,c,b,e),a.elementType=Ja,a.lanes=f,a;default:if("object"===
typeof a&&null!==a)switch(a.$$typeof){case ya:g=10;break a;case za:g=9;break a;case Aa:g=11;break a;case Da:g=14;break a;case Ea:g=16;d=null;break a;case Fa:g=22;break a}throw Error(y(130,null==a?a:typeof a,""));}b=nh(g,c,b,e);b.elementType=a;b.type=d;b.lanes=f;return b}function Xg(a,b,c,d){a=nh(7,a,d,b);a.lanes=c;return a}function vi(a,b,c,d){a=nh(23,a,d,b);a.elementType=Ia;a.lanes=c;return a}function Ug(a,b,c){a=nh(6,a,null,b);a.lanes=c;return a}
function Wg(a,b,c){b=nh(4,null!==a.children?a.children:[],a.key,b);b.lanes=c;b.stateNode={containerInfo:a.containerInfo,pendingChildren:null,implementation:a.implementation};return b}
function jk(a,b,c){this.tag=b;this.containerInfo=a;this.finishedWork=this.pingCache=this.current=this.pendingChildren=null;this.timeoutHandle=-1;this.pendingContext=this.context=null;this.hydrate=c;this.callbackNode=null;this.callbackPriority=0;this.eventTimes=Zc(0);this.expirationTimes=Zc(-1);this.entangledLanes=this.finishedLanes=this.mutableReadLanes=this.expiredLanes=this.pingedLanes=this.suspendedLanes=this.pendingLanes=0;this.entanglements=Zc(0);this.mutableSourceEagerHydrationData=null}
function kk(a,b,c){var d=3<arguments.length&&void 0!==arguments[3]?arguments[3]:null;return{$$typeof:ta,key:null==d?null:""+d,children:a,containerInfo:b,implementation:c}}
function lk(a,b,c,d){var e=b.current,f=Hg(),g=Ig(e);a:if(c){c=c._reactInternals;b:{if(Zb(c)!==c||1!==c.tag)throw Error(y(170));var h=c;do{switch(h.tag){case 3:h=h.stateNode.context;break b;case 1:if(Ff(h.type)){h=h.stateNode.__reactInternalMemoizedMergedChildContext;break b}}h=h.return}while(null!==h);throw Error(y(171));}if(1===c.tag){var k=c.type;if(Ff(k)){c=If(c,k,h);break a}}c=h}else c=Cf;null===b.context?b.context=c:b.pendingContext=c;b=zg(f,g);b.payload={element:a};d=void 0===d?null:d;null!==
d&&(b.callback=d);Ag(e,b);Jg(e,g,f);return g}function mk(a){a=a.current;if(!a.child)return null;switch(a.child.tag){case 5:return a.child.stateNode;default:return a.child.stateNode}}function nk(a,b){a=a.memoizedState;if(null!==a&&null!==a.dehydrated){var c=a.retryLane;a.retryLane=0!==c&&c<b?c:b}}function ok(a,b){nk(a,b);(a=a.alternate)&&nk(a,b)}function pk(){return null}
function qk(a,b,c){var d=null!=c&&null!=c.hydrationOptions&&c.hydrationOptions.mutableSources||null;c=new jk(a,b,null!=c&&!0===c.hydrate);b=nh(3,null,null,2===b?7:1===b?3:0);c.current=b;b.stateNode=c;xg(b);a[ff]=c.current;cf(8===a.nodeType?a.parentNode:a);if(d)for(a=0;a<d.length;a++){b=d[a];var e=b._getVersion;e=e(b._source);null==c.mutableSourceEagerHydrationData?c.mutableSourceEagerHydrationData=[b,e]:c.mutableSourceEagerHydrationData.push(b,e)}this._internalRoot=c}
qk.prototype.render=function(a){lk(a,this._internalRoot,null,null)};qk.prototype.unmount=function(){var a=this._internalRoot,b=a.containerInfo;lk(null,a,null,function(){b[ff]=null})};function rk(a){return!(!a||1!==a.nodeType&&9!==a.nodeType&&11!==a.nodeType&&(8!==a.nodeType||" react-mount-point-unstable "!==a.nodeValue))}
function sk(a,b){b||(b=a?9===a.nodeType?a.documentElement:a.firstChild:null,b=!(!b||1!==b.nodeType||!b.hasAttribute("data-reactroot")));if(!b)for(var c;c=a.lastChild;)a.removeChild(c);return new qk(a,0,b?{hydrate:!0}:void 0)}
function tk(a,b,c,d,e){var f=c._reactRootContainer;if(f){var g=f._internalRoot;if("function"===typeof e){var h=e;e=function(){var a=mk(g);h.call(a)}}lk(b,g,a,e)}else{f=c._reactRootContainer=sk(c,d);g=f._internalRoot;if("function"===typeof e){var k=e;e=function(){var a=mk(g);k.call(a)}}Xj(function(){lk(b,g,a,e)})}return mk(g)}ec=function(a){if(13===a.tag){var b=Hg();Jg(a,4,b);ok(a,4)}};fc=function(a){if(13===a.tag){var b=Hg();Jg(a,67108864,b);ok(a,67108864)}};
gc=function(a){if(13===a.tag){var b=Hg(),c=Ig(a);Jg(a,c,b);ok(a,c)}};hc=function(a,b){return b()};
yb=function(a,b,c){switch(b){case "input":ab(a,c);b=c.name;if("radio"===c.type&&null!=b){for(c=a;c.parentNode;)c=c.parentNode;c=c.querySelectorAll("input[name="+JSON.stringify(""+b)+'][type="radio"]');for(b=0;b<c.length;b++){var d=c[b];if(d!==a&&d.form===a.form){var e=Db(d);if(!e)throw Error(y(90));Wa(d);ab(d,e)}}}break;case "textarea":ib(a,c);break;case "select":b=c.value,null!=b&&fb(a,!!c.multiple,b,!1)}};Gb=Wj;
Hb=function(a,b,c,d,e){var f=X;X|=4;try{return gg(98,a.bind(null,b,c,d,e))}finally{X=f,0===X&&(wj(),ig())}};Ib=function(){0===(X&49)&&(Vj(),Oj())};Jb=function(a,b){var c=X;X|=2;try{return a(b)}finally{X=c,0===X&&(wj(),ig())}};function uk(a,b){var c=2<arguments.length&&void 0!==arguments[2]?arguments[2]:null;if(!rk(b))throw Error(y(200));return kk(a,b,null,c)}var vk={Events:[Cb,ue,Db,Eb,Fb,Oj,{current:!1}]},wk={findFiberByHostInstance:wc,bundleType:0,version:"17.0.2",rendererPackageName:"react-dom"};
var xk={bundleType:wk.bundleType,version:wk.version,rendererPackageName:wk.rendererPackageName,rendererConfig:wk.rendererConfig,overrideHookState:null,overrideHookStateDeletePath:null,overrideHookStateRenamePath:null,overrideProps:null,overridePropsDeletePath:null,overridePropsRenamePath:null,setSuspenseHandler:null,scheduleUpdate:null,currentDispatcherRef:ra.ReactCurrentDispatcher,findHostInstanceByFiber:function(a){a=cc(a);return null===a?null:a.stateNode},findFiberByHostInstance:wk.findFiberByHostInstance||
pk,findHostInstancesForRefresh:null,scheduleRefresh:null,scheduleRoot:null,setRefreshHandler:null,getCurrentFiber:null};if("undefined"!==typeof __REACT_DEVTOOLS_GLOBAL_HOOK__){var yk=__REACT_DEVTOOLS_GLOBAL_HOOK__;if(!yk.isDisabled&&yk.supportsFiber)try{Lf=yk.inject(xk),Mf=yk}catch(a){}}exports.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED=vk;exports.createPortal=uk;
exports.findDOMNode=function(a){if(null==a)return null;if(1===a.nodeType)return a;var b=a._reactInternals;if(void 0===b){if("function"===typeof a.render)throw Error(y(188));throw Error(y(268,Object.keys(a)));}a=cc(b);a=null===a?null:a.stateNode;return a};exports.flushSync=function(a,b){var c=X;if(0!==(c&48))return a(b);X|=1;try{if(a)return gg(99,a.bind(null,b))}finally{X=c,ig()}};exports.hydrate=function(a,b,c){if(!rk(b))throw Error(y(200));return tk(null,a,b,!0,c)};
exports.render=function(a,b,c){if(!rk(b))throw Error(y(200));return tk(null,a,b,!1,c)};exports.unmountComponentAtNode=function(a){if(!rk(a))throw Error(y(40));return a._reactRootContainer?(Xj(function(){tk(null,null,a,!1,function(){a._reactRootContainer=null;a[ff]=null})}),!0):!1};exports.unstable_batchedUpdates=Wj;exports.unstable_createPortal=function(a,b){return uk(a,b,2<arguments.length&&void 0!==arguments[2]?arguments[2]:null)};
exports.unstable_renderSubtreeIntoContainer=function(a,b,c,d){if(!rk(c))throw Error(y(200));if(null==a||void 0===a._reactInternals)throw Error(y(38));return tk(a,b,c,!1,d)};exports.version="17.0.2";


/***/ }),

/***/ 3935:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

"use strict";


function checkDCE() {
  /* global __REACT_DEVTOOLS_GLOBAL_HOOK__ */
  if (
    typeof __REACT_DEVTOOLS_GLOBAL_HOOK__ === 'undefined' ||
    typeof __REACT_DEVTOOLS_GLOBAL_HOOK__.checkDCE !== 'function'
  ) {
    return;
  }
  if (false) {}
  try {
    // Verify that the code above has been dead code eliminated (DCE'd).
    __REACT_DEVTOOLS_GLOBAL_HOOK__.checkDCE(checkDCE);
  } catch (err) {
    // DevTools shouldn't crash React, no matter what.
    // We should still report in case we break this code.
    console.error(err);
  }
}

if (true) {
  // DCE check should happen before ReactDOM bundle executes so that
  // DevTools can report bad minification during injection.
  checkDCE();
  module.exports = __webpack_require__(4448);
} else {}


/***/ }),

/***/ 2408:
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {

"use strict";
/** @license React v17.0.2
 * react.production.min.js
 *
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */
var l=__webpack_require__(7418),n=60103,p=60106;exports.Fragment=60107;exports.StrictMode=60108;exports.Profiler=60114;var q=60109,r=60110,t=60112;exports.Suspense=60113;var u=60115,v=60116;
if("function"===typeof Symbol&&Symbol.for){var w=Symbol.for;n=w("react.element");p=w("react.portal");exports.Fragment=w("react.fragment");exports.StrictMode=w("react.strict_mode");exports.Profiler=w("react.profiler");q=w("react.provider");r=w("react.context");t=w("react.forward_ref");exports.Suspense=w("react.suspense");u=w("react.memo");v=w("react.lazy")}var x="function"===typeof Symbol&&Symbol.iterator;
function y(a){if(null===a||"object"!==typeof a)return null;a=x&&a[x]||a["@@iterator"];return"function"===typeof a?a:null}function z(a){for(var b="https://reactjs.org/docs/error-decoder.html?invariant="+a,c=1;c<arguments.length;c++)b+="&args[]="+encodeURIComponent(arguments[c]);return"Minified React error #"+a+"; visit "+b+" for the full message or use the non-minified dev environment for full errors and additional helpful warnings."}
var A={isMounted:function(){return!1},enqueueForceUpdate:function(){},enqueueReplaceState:function(){},enqueueSetState:function(){}},B={};function C(a,b,c){this.props=a;this.context=b;this.refs=B;this.updater=c||A}C.prototype.isReactComponent={};C.prototype.setState=function(a,b){if("object"!==typeof a&&"function"!==typeof a&&null!=a)throw Error(z(85));this.updater.enqueueSetState(this,a,b,"setState")};C.prototype.forceUpdate=function(a){this.updater.enqueueForceUpdate(this,a,"forceUpdate")};
function D(){}D.prototype=C.prototype;function E(a,b,c){this.props=a;this.context=b;this.refs=B;this.updater=c||A}var F=E.prototype=new D;F.constructor=E;l(F,C.prototype);F.isPureReactComponent=!0;var G={current:null},H=Object.prototype.hasOwnProperty,I={key:!0,ref:!0,__self:!0,__source:!0};
function J(a,b,c){var e,d={},k=null,h=null;if(null!=b)for(e in void 0!==b.ref&&(h=b.ref),void 0!==b.key&&(k=""+b.key),b)H.call(b,e)&&!I.hasOwnProperty(e)&&(d[e]=b[e]);var g=arguments.length-2;if(1===g)d.children=c;else if(1<g){for(var f=Array(g),m=0;m<g;m++)f[m]=arguments[m+2];d.children=f}if(a&&a.defaultProps)for(e in g=a.defaultProps,g)void 0===d[e]&&(d[e]=g[e]);return{$$typeof:n,type:a,key:k,ref:h,props:d,_owner:G.current}}
function K(a,b){return{$$typeof:n,type:a.type,key:b,ref:a.ref,props:a.props,_owner:a._owner}}function L(a){return"object"===typeof a&&null!==a&&a.$$typeof===n}function escape(a){var b={"=":"=0",":":"=2"};return"$"+a.replace(/[=:]/g,function(a){return b[a]})}var M=/\/+/g;function N(a,b){return"object"===typeof a&&null!==a&&null!=a.key?escape(""+a.key):b.toString(36)}
function O(a,b,c,e,d){var k=typeof a;if("undefined"===k||"boolean"===k)a=null;var h=!1;if(null===a)h=!0;else switch(k){case "string":case "number":h=!0;break;case "object":switch(a.$$typeof){case n:case p:h=!0}}if(h)return h=a,d=d(h),a=""===e?"."+N(h,0):e,Array.isArray(d)?(c="",null!=a&&(c=a.replace(M,"$&/")+"/"),O(d,b,c,"",function(a){return a})):null!=d&&(L(d)&&(d=K(d,c+(!d.key||h&&h.key===d.key?"":(""+d.key).replace(M,"$&/")+"/")+a)),b.push(d)),1;h=0;e=""===e?".":e+":";if(Array.isArray(a))for(var g=
0;g<a.length;g++){k=a[g];var f=e+N(k,g);h+=O(k,b,c,f,d)}else if(f=y(a),"function"===typeof f)for(a=f.call(a),g=0;!(k=a.next()).done;)k=k.value,f=e+N(k,g++),h+=O(k,b,c,f,d);else if("object"===k)throw b=""+a,Error(z(31,"[object Object]"===b?"object with keys {"+Object.keys(a).join(", ")+"}":b));return h}function P(a,b,c){if(null==a)return a;var e=[],d=0;O(a,e,"","",function(a){return b.call(c,a,d++)});return e}
function Q(a){if(-1===a._status){var b=a._result;b=b();a._status=0;a._result=b;b.then(function(b){0===a._status&&(b=b.default,a._status=1,a._result=b)},function(b){0===a._status&&(a._status=2,a._result=b)})}if(1===a._status)return a._result;throw a._result;}var R={current:null};function S(){var a=R.current;if(null===a)throw Error(z(321));return a}var T={ReactCurrentDispatcher:R,ReactCurrentBatchConfig:{transition:0},ReactCurrentOwner:G,IsSomeRendererActing:{current:!1},assign:l};
exports.Children={map:P,forEach:function(a,b,c){P(a,function(){b.apply(this,arguments)},c)},count:function(a){var b=0;P(a,function(){b++});return b},toArray:function(a){return P(a,function(a){return a})||[]},only:function(a){if(!L(a))throw Error(z(143));return a}};exports.Component=C;exports.PureComponent=E;exports.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED=T;
exports.cloneElement=function(a,b,c){if(null===a||void 0===a)throw Error(z(267,a));var e=l({},a.props),d=a.key,k=a.ref,h=a._owner;if(null!=b){void 0!==b.ref&&(k=b.ref,h=G.current);void 0!==b.key&&(d=""+b.key);if(a.type&&a.type.defaultProps)var g=a.type.defaultProps;for(f in b)H.call(b,f)&&!I.hasOwnProperty(f)&&(e[f]=void 0===b[f]&&void 0!==g?g[f]:b[f])}var f=arguments.length-2;if(1===f)e.children=c;else if(1<f){g=Array(f);for(var m=0;m<f;m++)g[m]=arguments[m+2];e.children=g}return{$$typeof:n,type:a.type,
key:d,ref:k,props:e,_owner:h}};exports.createContext=function(a,b){void 0===b&&(b=null);a={$$typeof:r,_calculateChangedBits:b,_currentValue:a,_currentValue2:a,_threadCount:0,Provider:null,Consumer:null};a.Provider={$$typeof:q,_context:a};return a.Consumer=a};exports.createElement=J;exports.createFactory=function(a){var b=J.bind(null,a);b.type=a;return b};exports.createRef=function(){return{current:null}};exports.forwardRef=function(a){return{$$typeof:t,render:a}};exports.isValidElement=L;
exports.lazy=function(a){return{$$typeof:v,_payload:{_status:-1,_result:a},_init:Q}};exports.memo=function(a,b){return{$$typeof:u,type:a,compare:void 0===b?null:b}};exports.useCallback=function(a,b){return S().useCallback(a,b)};exports.useContext=function(a,b){return S().useContext(a,b)};exports.useDebugValue=function(){};exports.useEffect=function(a,b){return S().useEffect(a,b)};exports.useImperativeHandle=function(a,b,c){return S().useImperativeHandle(a,b,c)};
exports.useLayoutEffect=function(a,b){return S().useLayoutEffect(a,b)};exports.useMemo=function(a,b){return S().useMemo(a,b)};exports.useReducer=function(a,b,c){return S().useReducer(a,b,c)};exports.useRef=function(a){return S().useRef(a)};exports.useState=function(a){return S().useState(a)};exports.version="17.0.2";


/***/ }),

/***/ 7294:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

"use strict";


if (true) {
  module.exports = __webpack_require__(2408);
} else {}


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

/***/ 53:
/***/ ((__unused_webpack_module, exports) => {

"use strict";
/** @license React v0.20.2
 * scheduler.production.min.js
 *
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */
var f,g,h,k;if("object"===typeof performance&&"function"===typeof performance.now){var l=performance;exports.unstable_now=function(){return l.now()}}else{var p=Date,q=p.now();exports.unstable_now=function(){return p.now()-q}}
if("undefined"===typeof window||"function"!==typeof MessageChannel){var t=null,u=null,w=function(){if(null!==t)try{var a=exports.unstable_now();t(!0,a);t=null}catch(b){throw setTimeout(w,0),b;}};f=function(a){null!==t?setTimeout(f,0,a):(t=a,setTimeout(w,0))};g=function(a,b){u=setTimeout(a,b)};h=function(){clearTimeout(u)};exports.unstable_shouldYield=function(){return!1};k=exports.unstable_forceFrameRate=function(){}}else{var x=window.setTimeout,y=window.clearTimeout;if("undefined"!==typeof console){var z=
window.cancelAnimationFrame;"function"!==typeof window.requestAnimationFrame&&console.error("This browser doesn't support requestAnimationFrame. Make sure that you load a polyfill in older browsers. https://reactjs.org/link/react-polyfills");"function"!==typeof z&&console.error("This browser doesn't support cancelAnimationFrame. Make sure that you load a polyfill in older browsers. https://reactjs.org/link/react-polyfills")}var A=!1,B=null,C=-1,D=5,E=0;exports.unstable_shouldYield=function(){return exports.unstable_now()>=
E};k=function(){};exports.unstable_forceFrameRate=function(a){0>a||125<a?console.error("forceFrameRate takes a positive int between 0 and 125, forcing frame rates higher than 125 fps is not supported"):D=0<a?Math.floor(1E3/a):5};var F=new MessageChannel,G=F.port2;F.port1.onmessage=function(){if(null!==B){var a=exports.unstable_now();E=a+D;try{B(!0,a)?G.postMessage(null):(A=!1,B=null)}catch(b){throw G.postMessage(null),b;}}else A=!1};f=function(a){B=a;A||(A=!0,G.postMessage(null))};g=function(a,b){C=
x(function(){a(exports.unstable_now())},b)};h=function(){y(C);C=-1}}function H(a,b){var c=a.length;a.push(b);a:for(;;){var d=c-1>>>1,e=a[d];if(void 0!==e&&0<I(e,b))a[d]=b,a[c]=e,c=d;else break a}}function J(a){a=a[0];return void 0===a?null:a}
function K(a){var b=a[0];if(void 0!==b){var c=a.pop();if(c!==b){a[0]=c;a:for(var d=0,e=a.length;d<e;){var m=2*(d+1)-1,n=a[m],v=m+1,r=a[v];if(void 0!==n&&0>I(n,c))void 0!==r&&0>I(r,n)?(a[d]=r,a[v]=c,d=v):(a[d]=n,a[m]=c,d=m);else if(void 0!==r&&0>I(r,c))a[d]=r,a[v]=c,d=v;else break a}}return b}return null}function I(a,b){var c=a.sortIndex-b.sortIndex;return 0!==c?c:a.id-b.id}var L=[],M=[],N=1,O=null,P=3,Q=!1,R=!1,S=!1;
function T(a){for(var b=J(M);null!==b;){if(null===b.callback)K(M);else if(b.startTime<=a)K(M),b.sortIndex=b.expirationTime,H(L,b);else break;b=J(M)}}function U(a){S=!1;T(a);if(!R)if(null!==J(L))R=!0,f(V);else{var b=J(M);null!==b&&g(U,b.startTime-a)}}
function V(a,b){R=!1;S&&(S=!1,h());Q=!0;var c=P;try{T(b);for(O=J(L);null!==O&&(!(O.expirationTime>b)||a&&!exports.unstable_shouldYield());){var d=O.callback;if("function"===typeof d){O.callback=null;P=O.priorityLevel;var e=d(O.expirationTime<=b);b=exports.unstable_now();"function"===typeof e?O.callback=e:O===J(L)&&K(L);T(b)}else K(L);O=J(L)}if(null!==O)var m=!0;else{var n=J(M);null!==n&&g(U,n.startTime-b);m=!1}return m}finally{O=null,P=c,Q=!1}}var W=k;exports.unstable_IdlePriority=5;
exports.unstable_ImmediatePriority=1;exports.unstable_LowPriority=4;exports.unstable_NormalPriority=3;exports.unstable_Profiling=null;exports.unstable_UserBlockingPriority=2;exports.unstable_cancelCallback=function(a){a.callback=null};exports.unstable_continueExecution=function(){R||Q||(R=!0,f(V))};exports.unstable_getCurrentPriorityLevel=function(){return P};exports.unstable_getFirstCallbackNode=function(){return J(L)};
exports.unstable_next=function(a){switch(P){case 1:case 2:case 3:var b=3;break;default:b=P}var c=P;P=b;try{return a()}finally{P=c}};exports.unstable_pauseExecution=function(){};exports.unstable_requestPaint=W;exports.unstable_runWithPriority=function(a,b){switch(a){case 1:case 2:case 3:case 4:case 5:break;default:a=3}var c=P;P=a;try{return b()}finally{P=c}};
exports.unstable_scheduleCallback=function(a,b,c){var d=exports.unstable_now();"object"===typeof c&&null!==c?(c=c.delay,c="number"===typeof c&&0<c?d+c:d):c=d;switch(a){case 1:var e=-1;break;case 2:e=250;break;case 5:e=1073741823;break;case 4:e=1E4;break;default:e=5E3}e=c+e;a={id:N++,callback:b,priorityLevel:a,startTime:c,expirationTime:e,sortIndex:-1};c>d?(a.sortIndex=c,H(M,a),null===J(L)&&a===J(M)&&(S?h():S=!0,g(U,c-d))):(a.sortIndex=e,H(L,a),R||Q||(R=!0,f(V)));return a};
exports.unstable_wrapCallback=function(a){var b=P;return function(){var c=P;P=b;try{return a.apply(this,arguments)}finally{P=c}}};


/***/ }),

/***/ 3840:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

"use strict";


if (true) {
  module.exports = __webpack_require__(53);
} else {}


/***/ }),

/***/ 3379:
/***/ ((module) => {

"use strict";


var stylesInDom = [];

function getIndexByIdentifier(identifier) {
  var result = -1;

  for (var i = 0; i < stylesInDom.length; i++) {
    if (stylesInDom[i].identifier === identifier) {
      result = i;
      break;
    }
  }

  return result;
}

function modulesToDom(list, options) {
  var idCountMap = {};
  var identifiers = [];

  for (var i = 0; i < list.length; i++) {
    var item = list[i];
    var id = options.base ? item[0] + options.base : item[0];
    var count = idCountMap[id] || 0;
    var identifier = "".concat(id, " ").concat(count);
    idCountMap[id] = count + 1;
    var index = getIndexByIdentifier(identifier);
    var obj = {
      css: item[1],
      media: item[2],
      sourceMap: item[3]
    };

    if (index !== -1) {
      stylesInDom[index].references++;
      stylesInDom[index].updater(obj);
    } else {
      stylesInDom.push({
        identifier: identifier,
        updater: addStyle(obj, options),
        references: 1
      });
    }

    identifiers.push(identifier);
  }

  return identifiers;
}

function addStyle(obj, options) {
  var api = options.domAPI(options);
  api.update(obj);
  return function updateStyle(newObj) {
    if (newObj) {
      if (newObj.css === obj.css && newObj.media === obj.media && newObj.sourceMap === obj.sourceMap) {
        return;
      }

      api.update(obj = newObj);
    } else {
      api.remove();
    }
  };
}

module.exports = function (list, options) {
  options = options || {};
  list = list || [];
  var lastIdentifiers = modulesToDom(list, options);
  return function update(newList) {
    newList = newList || [];

    for (var i = 0; i < lastIdentifiers.length; i++) {
      var identifier = lastIdentifiers[i];
      var index = getIndexByIdentifier(identifier);
      stylesInDom[index].references--;
    }

    var newLastIdentifiers = modulesToDom(newList, options);

    for (var _i = 0; _i < lastIdentifiers.length; _i++) {
      var _identifier = lastIdentifiers[_i];

      var _index = getIndexByIdentifier(_identifier);

      if (stylesInDom[_index].references === 0) {
        stylesInDom[_index].updater();

        stylesInDom.splice(_index, 1);
      }
    }

    lastIdentifiers = newLastIdentifiers;
  };
};

/***/ }),

/***/ 569:
/***/ ((module) => {

"use strict";


var memo = {};
/* istanbul ignore next  */

function getTarget(target) {
  if (typeof memo[target] === "undefined") {
    var styleTarget = document.querySelector(target); // Special case to return head of iframe instead of iframe itself

    if (window.HTMLIFrameElement && styleTarget instanceof window.HTMLIFrameElement) {
      try {
        // This will throw an exception if access to iframe is blocked
        // due to cross-origin restrictions
        styleTarget = styleTarget.contentDocument.head;
      } catch (e) {
        // istanbul ignore next
        styleTarget = null;
      }
    }

    memo[target] = styleTarget;
  }

  return memo[target];
}
/* istanbul ignore next  */


function insertBySelector(insert, style) {
  var target = getTarget(insert);

  if (!target) {
    throw new Error("Couldn't find a style target. This probably means that the value for the 'insert' parameter is invalid.");
  }

  target.appendChild(style);
}

module.exports = insertBySelector;

/***/ }),

/***/ 9216:
/***/ ((module) => {

"use strict";


/* istanbul ignore next  */
function insertStyleElement(options) {
  var style = document.createElement("style");
  options.setAttributes(style, options.attributes);
  options.insert(style);
  return style;
}

module.exports = insertStyleElement;

/***/ }),

/***/ 3565:
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

"use strict";


/* istanbul ignore next  */
function setAttributesWithoutAttributes(style) {
  var nonce =  true ? __webpack_require__.nc : 0;

  if (nonce) {
    style.setAttribute("nonce", nonce);
  }
}

module.exports = setAttributesWithoutAttributes;

/***/ }),

/***/ 7795:
/***/ ((module) => {

"use strict";


/* istanbul ignore next  */
function apply(style, options, obj) {
  var css = obj.css;
  var media = obj.media;
  var sourceMap = obj.sourceMap;

  if (media) {
    style.setAttribute("media", media);
  } else {
    style.removeAttribute("media");
  }

  if (sourceMap && typeof btoa !== "undefined") {
    css += "\n/*# sourceMappingURL=data:application/json;base64,".concat(btoa(unescape(encodeURIComponent(JSON.stringify(sourceMap)))), " */");
  } // For old IE

  /* istanbul ignore if  */


  options.styleTagTransform(css, style);
}

function removeStyleElement(style) {
  // istanbul ignore if
  if (style.parentNode === null) {
    return false;
  }

  style.parentNode.removeChild(style);
}
/* istanbul ignore next  */


function domAPI(options) {
  var style = options.insertStyleElement(options);
  return {
    update: function update(obj) {
      apply(style, options, obj);
    },
    remove: function remove() {
      removeStyleElement(style);
    }
  };
}

module.exports = domAPI;

/***/ }),

/***/ 4589:
/***/ ((module) => {

"use strict";


/* istanbul ignore next  */
function styleTagTransform(css, style) {
  if (style.styleSheet) {
    style.styleSheet.cssText = css;
  } else {
    while (style.firstChild) {
      style.removeChild(style.firstChild);
    }

    style.appendChild(document.createTextNode(css));
  }
}

module.exports = styleTagTransform;

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
/******/ 			id: moduleId,
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
/******/ 	/* webpack/runtime/nonce */
/******/ 	(() => {
/******/ 		__webpack_require__.nc = undefined;
/******/ 	})();
/******/ 	
/************************************************************************/
var __webpack_exports__ = {};
// This entry need to be wrapped in an IIFE because it need to be in strict mode.
(() => {
"use strict";

// EXTERNAL MODULE: ./node_modules/react/index.js
var react = __webpack_require__(7294);
// EXTERNAL MODULE: ./node_modules/react-dom/index.js
var react_dom = __webpack_require__(3935);
;// CONCATENATED MODULE: ./node_modules/@babel/runtime/helpers/esm/arrayWithHoles.js
function _arrayWithHoles(arr) {
  if (Array.isArray(arr)) return arr;
}
;// CONCATENATED MODULE: ./node_modules/@babel/runtime/helpers/esm/iterableToArrayLimit.js
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
;// CONCATENATED MODULE: ./node_modules/@babel/runtime/helpers/esm/arrayLikeToArray.js
function _arrayLikeToArray(arr, len) {
  if (len == null || len > arr.length) len = arr.length;

  for (var i = 0, arr2 = new Array(len); i < len; i++) {
    arr2[i] = arr[i];
  }

  return arr2;
}
;// CONCATENATED MODULE: ./node_modules/@babel/runtime/helpers/esm/unsupportedIterableToArray.js

function _unsupportedIterableToArray(o, minLen) {
  if (!o) return;
  if (typeof o === "string") return _arrayLikeToArray(o, minLen);
  var n = Object.prototype.toString.call(o).slice(8, -1);
  if (n === "Object" && o.constructor) n = o.constructor.name;
  if (n === "Map" || n === "Set") return Array.from(o);
  if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen);
}
;// CONCATENATED MODULE: ./node_modules/@babel/runtime/helpers/esm/nonIterableRest.js
function _nonIterableRest() {
  throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.");
}
;// CONCATENATED MODULE: ./node_modules/@babel/runtime/helpers/esm/slicedToArray.js




function _slicedToArray(arr, i) {
  return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest();
}
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
;// CONCATENATED MODULE: ./node_modules/@babel/runtime/helpers/esm/initializerDefineProperty.js
function _initializerDefineProperty(target, property, descriptor, context) {
  if (!descriptor) return;
  Object.defineProperty(target, property, {
    enumerable: descriptor.enumerable,
    configurable: descriptor.configurable,
    writable: descriptor.writable,
    value: descriptor.initializer ? descriptor.initializer.call(context) : void 0
  });
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
;// CONCATENATED MODULE: ./node_modules/@babel/runtime/helpers/esm/applyDecoratedDescriptor.js
function _applyDecoratedDescriptor(target, property, decorators, descriptor, context) {
  var desc = {};
  Object.keys(descriptor).forEach(function (key) {
    desc[key] = descriptor[key];
  });
  desc.enumerable = !!desc.enumerable;
  desc.configurable = !!desc.configurable;

  if ('value' in desc || desc.initializer) {
    desc.writable = true;
  }

  desc = decorators.slice().reverse().reduce(function (desc, decorator) {
    return decorator(target, property, desc) || desc;
  }, desc);

  if (context && desc.initializer !== void 0) {
    desc.value = desc.initializer ? desc.initializer.call(context) : void 0;
    desc.initializer = undefined;
  }

  if (desc.initializer === void 0) {
    Object.defineProperty(target, property, desc);
    desc = null;
  }

  return desc;
}
// EXTERNAL MODULE: ./node_modules/@babel/runtime/regenerator/index.js
var regenerator = __webpack_require__(7757);
var regenerator_default = /*#__PURE__*/__webpack_require__.n(regenerator);
// EXTERNAL MODULE: ./node_modules/webextension-polyfill/dist/browser-polyfill.js
var browser_polyfill = __webpack_require__(3150);
var browser_polyfill_default = /*#__PURE__*/__webpack_require__.n(browser_polyfill);
;// CONCATENATED MODULE: ./node_modules/mobx/dist/mobx.esm.js
var niceErrors = {
  0: "Invalid value for configuration 'enforceActions', expected 'never', 'always' or 'observed'",
  1: function _(annotationType, key) {
    return "Cannot apply '" + annotationType + "' to '" + key.toString() + "': Field not found.";
  },

  /*
  2(prop) {
      return `invalid decorator for '${prop.toString()}'`
  },
  3(prop) {
      return `Cannot decorate '${prop.toString()}': action can only be used on properties with a function value.`
  },
  4(prop) {
      return `Cannot decorate '${prop.toString()}': computed can only be used on getter properties.`
  },
  */
  5: "'keys()' can only be used on observable objects, arrays, sets and maps",
  6: "'values()' can only be used on observable objects, arrays, sets and maps",
  7: "'entries()' can only be used on observable objects, arrays and maps",
  8: "'set()' can only be used on observable objects, arrays and maps",
  9: "'remove()' can only be used on observable objects, arrays and maps",
  10: "'has()' can only be used on observable objects, arrays and maps",
  11: "'get()' can only be used on observable objects, arrays and maps",
  12: "Invalid annotation",
  13: "Dynamic observable objects cannot be frozen",
  14: "Intercept handlers should return nothing or a change object",
  15: "Observable arrays cannot be frozen",
  16: "Modification exception: the internal structure of an observable array was changed.",
  17: function _(index, length) {
    return "[mobx.array] Index out of bounds, " + index + " is larger than " + length;
  },
  18: "mobx.map requires Map polyfill for the current browser. Check babel-polyfill or core-js/es6/map.js",
  19: function _(other) {
    return "Cannot initialize from classes that inherit from Map: " + other.constructor.name;
  },
  20: function _(other) {
    return "Cannot initialize map from " + other;
  },
  21: function _(dataStructure) {
    return "Cannot convert to map from '" + dataStructure + "'";
  },
  22: "mobx.set requires Set polyfill for the current browser. Check babel-polyfill or core-js/es6/set.js",
  23: "It is not possible to get index atoms from arrays",
  24: function _(thing) {
    return "Cannot obtain administration from " + thing;
  },
  25: function _(property, name) {
    return "the entry '" + property + "' does not exist in the observable map '" + name + "'";
  },
  26: "please specify a property",
  27: function _(property, name) {
    return "no observable property '" + property.toString() + "' found on the observable object '" + name + "'";
  },
  28: function _(thing) {
    return "Cannot obtain atom from " + thing;
  },
  29: "Expecting some object",
  30: "invalid action stack. did you forget to finish an action?",
  31: "missing option for computed: get",
  32: function _(name, derivation) {
    return "Cycle detected in computation " + name + ": " + derivation;
  },
  33: function _(name) {
    return "The setter of computed value '" + name + "' is trying to update itself. Did you intend to update an _observable_ value, instead of the computed property?";
  },
  34: function _(name) {
    return "[ComputedValue '" + name + "'] It is not possible to assign a new value to a computed value.";
  },
  35: "There are multiple, different versions of MobX active. Make sure MobX is loaded only once or use `configure({ isolateGlobalState: true })`",
  36: "isolateGlobalState should be called before MobX is running any reactions",
  37: function _(method) {
    return "[mobx] `observableArray." + method + "()` mutates the array in-place, which is not allowed inside a derivation. Use `array.slice()." + method + "()` instead";
  },
  38: "'ownKeys()' can only be used on observable objects",
  39: "'defineProperty()' can only be used on observable objects"
};
var errors =  false ? 0 : {};
function die(error) {
  for (var _len = arguments.length, args = new Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
    args[_key - 1] = arguments[_key];
  }

  if (false) { var e; }

  throw new Error(typeof error === "number" ? "[MobX] minified error nr: " + error + (args.length ? " " + args.map(String).join(",") : "") + ". Find the full error at: https://github.com/mobxjs/mobx/blob/main/packages/mobx/src/errors.ts" : "[MobX] " + error);
}

var mockGlobal = {};
function getGlobal() {
  if (typeof globalThis !== "undefined") {
    return globalThis;
  }

  if (typeof window !== "undefined") {
    return window;
  }

  if (typeof __webpack_require__.g !== "undefined") {
    return __webpack_require__.g;
  }

  if (typeof self !== "undefined") {
    return self;
  }

  return mockGlobal;
}

var mobx_esm_assign = Object.assign;
var getDescriptor = Object.getOwnPropertyDescriptor;
var defineProperty = Object.defineProperty;
var objectPrototype = Object.prototype;
var EMPTY_ARRAY = [];
Object.freeze(EMPTY_ARRAY);
var EMPTY_OBJECT = {};
Object.freeze(EMPTY_OBJECT);
var hasProxy = typeof Proxy !== "undefined";
var plainObjectString = /*#__PURE__*/Object.toString();
function assertProxies() {
  if (!hasProxy) {
    die( false ? 0 : "Proxy not available");
  }
}
function warnAboutProxyRequirement(msg) {
  if (false) {}
}
function getNextId() {
  return ++globalState.mobxGuid;
}
/**
 * Makes sure that the provided function is invoked at most once.
 */

function once(func) {
  var invoked = false;
  return function () {
    if (invoked) return;
    invoked = true;
    return func.apply(this, arguments);
  };
}
var noop = function noop() {};
function isFunction(fn) {
  return typeof fn === "function";
}
function isStringish(value) {
  var t = typeof value;

  switch (t) {
    case "string":
    case "symbol":
    case "number":
      return true;
  }

  return false;
}
function isObject(value) {
  return value !== null && typeof value === "object";
}
function isPlainObject(value) {
  var _proto$constructor;

  if (!isObject(value)) return false;
  var proto = Object.getPrototypeOf(value);
  if (proto == null) return true;
  return ((_proto$constructor = proto.constructor) == null ? void 0 : _proto$constructor.toString()) === plainObjectString;
} // https://stackoverflow.com/a/37865170

function isGenerator(obj) {
  var constructor = obj == null ? void 0 : obj.constructor;
  if (!constructor) return false;
  if ("GeneratorFunction" === constructor.name || "GeneratorFunction" === constructor.displayName) return true;
  return false;
}
function addHiddenProp(object, propName, value) {
  defineProperty(object, propName, {
    enumerable: false,
    writable: true,
    configurable: true,
    value: value
  });
}
function addHiddenFinalProp(object, propName, value) {
  defineProperty(object, propName, {
    enumerable: false,
    writable: false,
    configurable: true,
    value: value
  });
}
function createInstanceofPredicate(name, theClass) {
  var propName = "isMobX" + name;
  theClass.prototype[propName] = true;
  return function (x) {
    return isObject(x) && x[propName] === true;
  };
}
function isES6Map(thing) {
  return thing instanceof Map;
}
function isES6Set(thing) {
  return thing instanceof Set;
}
var hasGetOwnPropertySymbols = typeof Object.getOwnPropertySymbols !== "undefined";
/**
 * Returns the following: own enumerable keys and symbols.
 */

function getPlainObjectKeys(object) {
  var keys = Object.keys(object); // Not supported in IE, so there are not going to be symbol props anyway...

  if (!hasGetOwnPropertySymbols) return keys;
  var symbols = Object.getOwnPropertySymbols(object);
  if (!symbols.length) return keys;
  return [].concat(keys, symbols.filter(function (s) {
    return objectPrototype.propertyIsEnumerable.call(object, s);
  }));
} // From Immer utils
// Returns all own keys, including non-enumerable and symbolic

var ownKeys = typeof Reflect !== "undefined" && Reflect.ownKeys ? Reflect.ownKeys : hasGetOwnPropertySymbols ? function (obj) {
  return Object.getOwnPropertyNames(obj).concat(Object.getOwnPropertySymbols(obj));
} :
/* istanbul ignore next */
Object.getOwnPropertyNames;
function stringifyKey(key) {
  if (typeof key === "string") return key;
  if (typeof key === "symbol") return key.toString();
  return new String(key).toString();
}
function toPrimitive(value) {
  return value === null ? null : typeof value === "object" ? "" + value : value;
}
function hasProp(target, prop) {
  return objectPrototype.hasOwnProperty.call(target, prop);
} // From Immer utils

var getOwnPropertyDescriptors = Object.getOwnPropertyDescriptors || function getOwnPropertyDescriptors(target) {
  // Polyfill needed for Hermes and IE, see https://github.com/facebook/hermes/issues/274
  var res = {}; // Note: without polyfill for ownKeys, symbols won't be picked up

  ownKeys(target).forEach(function (key) {
    res[key] = getDescriptor(target, key);
  });
  return res;
};

function mobx_esm_defineProperties(target, props) {
  for (var i = 0; i < props.length; i++) {
    var descriptor = props[i];
    descriptor.enumerable = descriptor.enumerable || false;
    descriptor.configurable = true;
    if ("value" in descriptor) descriptor.writable = true;
    Object.defineProperty(target, descriptor.key, descriptor);
  }
}

function mobx_esm_createClass(Constructor, protoProps, staticProps) {
  if (protoProps) mobx_esm_defineProperties(Constructor.prototype, protoProps);
  if (staticProps) mobx_esm_defineProperties(Constructor, staticProps);
  return Constructor;
}

function _extends() {
  _extends = Object.assign || function (target) {
    for (var i = 1; i < arguments.length; i++) {
      var source = arguments[i];

      for (var key in source) {
        if (Object.prototype.hasOwnProperty.call(source, key)) {
          target[key] = source[key];
        }
      }
    }

    return target;
  };

  return _extends.apply(this, arguments);
}

function _inheritsLoose(subClass, superClass) {
  subClass.prototype = Object.create(superClass.prototype);
  subClass.prototype.constructor = subClass;
  subClass.__proto__ = superClass;
}

function _assertThisInitialized(self) {
  if (self === void 0) {
    throw new ReferenceError("this hasn't been initialised - super() hasn't been called");
  }

  return self;
}

function mobx_esm_unsupportedIterableToArray(o, minLen) {
  if (!o) return;
  if (typeof o === "string") return mobx_esm_arrayLikeToArray(o, minLen);
  var n = Object.prototype.toString.call(o).slice(8, -1);
  if (n === "Object" && o.constructor) n = o.constructor.name;
  if (n === "Map" || n === "Set") return Array.from(o);
  if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return mobx_esm_arrayLikeToArray(o, minLen);
}

function mobx_esm_arrayLikeToArray(arr, len) {
  if (len == null || len > arr.length) len = arr.length;

  for (var i = 0, arr2 = new Array(len); i < len; i++) arr2[i] = arr[i];

  return arr2;
}

function _createForOfIteratorHelperLoose(o, allowArrayLike) {
  var it;

  if (typeof Symbol === "undefined" || o[Symbol.iterator] == null) {
    if (Array.isArray(o) || (it = mobx_esm_unsupportedIterableToArray(o)) || allowArrayLike && o && typeof o.length === "number") {
      if (it) o = it;
      var i = 0;
      return function () {
        if (i >= o.length) return {
          done: true
        };
        return {
          done: false,
          value: o[i++]
        };
      };
    }

    throw new TypeError("Invalid attempt to iterate non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.");
  }

  it = o[Symbol.iterator]();
  return it.next.bind(it);
}

var storedAnnotationsSymbol = /*#__PURE__*/Symbol("mobx-stored-annotations");
/**
 * Creates a function that acts as
 * - decorator
 * - annotation object
 */

function createDecoratorAnnotation(annotation) {
  function decorator(target, property) {
    storeAnnotation(target, property, annotation);
  }

  return Object.assign(decorator, annotation);
}
/**
 * Stores annotation to prototype,
 * so it can be inspected later by `makeObservable` called from constructor
 */

function storeAnnotation(prototype, key, annotation) {
  if (!hasProp(prototype, storedAnnotationsSymbol)) {
    addHiddenProp(prototype, storedAnnotationsSymbol, _extends({}, prototype[storedAnnotationsSymbol]));
  } // @override must override something


  if (false) { var fieldName; } // Cannot re-decorate


  assertNotDecorated(prototype, annotation, key); // Ignore override

  if (!isOverride(annotation)) {
    prototype[storedAnnotationsSymbol][key] = annotation;
  }
}

function assertNotDecorated(prototype, annotation, key) {
  if (false) { var requestedAnnotationType, currentAnnotationType, fieldName; }
}
/**
 * Collects annotations from prototypes and stores them on target (instance)
 */


function collectStoredAnnotations(target) {
  if (!hasProp(target, storedAnnotationsSymbol)) {
    if (false) {} // We need a copy as we will remove annotation from the list once it's applied.


    addHiddenProp(target, storedAnnotationsSymbol, _extends({}, target[storedAnnotationsSymbol]));
  }

  return target[storedAnnotationsSymbol];
}

var $mobx = /*#__PURE__*/Symbol("mobx administration");
var Atom = /*#__PURE__*/function () {
  // for effective unobserving. BaseAtom has true, for extra optimization, so its onBecomeUnobserved never gets called, because it's not needed

  /**
   * Create a new atom. For debugging purposes it is recommended to give it a name.
   * The onBecomeObserved and onBecomeUnobserved callbacks can be used for resource management.
   */
  function Atom(name_) {
    if (name_ === void 0) {
      name_ =  false ? 0 : "Atom";
    }

    this.name_ = void 0;
    this.isPendingUnobservation_ = false;
    this.isBeingObserved_ = false;
    this.observers_ = new Set();
    this.diffValue_ = 0;
    this.lastAccessedBy_ = 0;
    this.lowestObserverState_ = IDerivationState_.NOT_TRACKING_;
    this.onBOL = void 0;
    this.onBUOL = void 0;
    this.name_ = name_;
  } // onBecomeObservedListeners


  var _proto = Atom.prototype;

  _proto.onBO = function onBO() {
    if (this.onBOL) {
      this.onBOL.forEach(function (listener) {
        return listener();
      });
    }
  };

  _proto.onBUO = function onBUO() {
    if (this.onBUOL) {
      this.onBUOL.forEach(function (listener) {
        return listener();
      });
    }
  }
  /**
   * Invoke this method to notify mobx that your atom has been used somehow.
   * Returns true if there is currently a reactive context.
   */
  ;

  _proto.reportObserved = function reportObserved$1() {
    return reportObserved(this);
  }
  /**
   * Invoke this method _after_ this method has changed to signal mobx that all its observers should invalidate.
   */
  ;

  _proto.reportChanged = function reportChanged() {
    startBatch();
    propagateChanged(this);
    endBatch();
  };

  _proto.toString = function toString() {
    return this.name_;
  };

  return Atom;
}();
var isAtom = /*#__PURE__*/createInstanceofPredicate("Atom", Atom);
function createAtom(name, onBecomeObservedHandler, onBecomeUnobservedHandler) {
  if (onBecomeObservedHandler === void 0) {
    onBecomeObservedHandler = noop;
  }

  if (onBecomeUnobservedHandler === void 0) {
    onBecomeUnobservedHandler = noop;
  }

  var atom = new Atom(name); // default `noop` listener will not initialize the hook Set

  if (onBecomeObservedHandler !== noop) {
    onBecomeObserved(atom, onBecomeObservedHandler);
  }

  if (onBecomeUnobservedHandler !== noop) {
    onBecomeUnobserved(atom, onBecomeUnobservedHandler);
  }

  return atom;
}

function identityComparer(a, b) {
  return a === b;
}

function structuralComparer(a, b) {
  return deepEqual(a, b);
}

function shallowComparer(a, b) {
  return deepEqual(a, b, 1);
}

function defaultComparer(a, b) {
  if (Object.is) return Object.is(a, b);
  return a === b ? a !== 0 || 1 / a === 1 / b : a !== a && b !== b;
}

var comparer = {
  identity: identityComparer,
  structural: structuralComparer,
  "default": defaultComparer,
  shallow: shallowComparer
};

function deepEnhancer(v, _, name) {
  // it is an observable already, done
  if (isObservable(v)) return v; // something that can be converted and mutated?

  if (Array.isArray(v)) return mobx_esm_observable.array(v, {
    name: name
  });
  if (isPlainObject(v)) return mobx_esm_observable.object(v, undefined, {
    name: name
  });
  if (isES6Map(v)) return mobx_esm_observable.map(v, {
    name: name
  });
  if (isES6Set(v)) return mobx_esm_observable.set(v, {
    name: name
  });

  if (typeof v === "function" && !isAction(v) && !isFlow(v)) {
    if (isGenerator(v)) {
      return flow(v);
    } else {
      return autoAction(name, v);
    }
  }

  return v;
}
function shallowEnhancer(v, _, name) {
  if (v === undefined || v === null) return v;
  if (isObservableObject(v) || isObservableArray(v) || isObservableMap(v) || isObservableSet(v)) return v;
  if (Array.isArray(v)) return mobx_esm_observable.array(v, {
    name: name,
    deep: false
  });
  if (isPlainObject(v)) return mobx_esm_observable.object(v, undefined, {
    name: name,
    deep: false
  });
  if (isES6Map(v)) return mobx_esm_observable.map(v, {
    name: name,
    deep: false
  });
  if (isES6Set(v)) return mobx_esm_observable.set(v, {
    name: name,
    deep: false
  });
  if (false) {}
}
function referenceEnhancer(newValue) {
  // never turn into an observable
  return newValue;
}
function refStructEnhancer(v, oldValue) {
  if (false) {}
  if (deepEqual(v, oldValue)) return oldValue;
  return v;
}

var OVERRIDE = "override";
var override = /*#__PURE__*/createDecoratorAnnotation({
  annotationType_: OVERRIDE,
  make_: make_,
  extend_: extend_
});
function isOverride(annotation) {
  return annotation.annotationType_ === OVERRIDE;
}

function make_(adm, key) {
  // Must not be plain object
  if (false) {} // Must override something


  if (false) {}

  return 0
  /* Cancel */
  ;
}

function extend_(adm, key, descriptor, proxyTrap) {
  die("'" + this.annotationType_ + "' can only be used with 'makeObservable'");
}

function createActionAnnotation(name, options) {
  return {
    annotationType_: name,
    options_: options,
    make_: make_$1,
    extend_: extend_$1
  };
}

function make_$1(adm, key, descriptor, source) {
  var _this$options_;

  // bound
  if ((_this$options_ = this.options_) == null ? void 0 : _this$options_.bound) {
    return this.extend_(adm, key, descriptor, false) === null ? 0
    /* Cancel */
    : 1
    /* Break */
    ;
  } // own


  if (source === adm.target_) {
    return this.extend_(adm, key, descriptor, false) === null ? 0
    /* Cancel */
    : 2
    /* Continue */
    ;
  } // prototype


  if (isAction(descriptor.value)) {
    // A prototype could have been annotated already by other constructor,
    // rest of the proto chain must be annotated already
    return 1
    /* Break */
    ;
  }

  var actionDescriptor = createActionDescriptor(adm, this, key, descriptor, false);
  defineProperty(source, key, actionDescriptor);
  return 2
  /* Continue */
  ;
}

function extend_$1(adm, key, descriptor, proxyTrap) {
  var actionDescriptor = createActionDescriptor(adm, this, key, descriptor);
  return adm.defineProperty_(key, actionDescriptor, proxyTrap);
}

function assertActionDescriptor(adm, _ref, key, _ref2) {
  var annotationType_ = _ref.annotationType_;
  var value = _ref2.value;

  if (false) {}
}

function createActionDescriptor(adm, annotation, key, descriptor, // provides ability to disable safeDescriptors for prototypes
safeDescriptors) {
  var _annotation$options_, _annotation$options_$, _annotation$options_2, _annotation$options_$2, _annotation$options_3;

  if (safeDescriptors === void 0) {
    safeDescriptors = globalState.safeDescriptors;
  }

  assertActionDescriptor(adm, annotation, key, descriptor);
  var value = descriptor.value;

  if ((_annotation$options_ = annotation.options_) == null ? void 0 : _annotation$options_.bound) {
    var _adm$proxy_;

    value = value.bind((_adm$proxy_ = adm.proxy_) != null ? _adm$proxy_ : adm.target_);
  }

  return {
    value: createAction((_annotation$options_$ = (_annotation$options_2 = annotation.options_) == null ? void 0 : _annotation$options_2.name) != null ? _annotation$options_$ : key.toString(), value, (_annotation$options_$2 = (_annotation$options_3 = annotation.options_) == null ? void 0 : _annotation$options_3.autoAction) != null ? _annotation$options_$2 : false),
    // Non-configurable for classes
    // prevents accidental field redefinition in subclass
    configurable: safeDescriptors ? adm.isPlainObject_ : true,
    // https://github.com/mobxjs/mobx/pull/2641#issuecomment-737292058
    enumerable: false,
    // Non-obsevable, therefore non-writable
    // Also prevents rewriting in subclass constructor
    writable: safeDescriptors ? false : true
  };
}

function createFlowAnnotation(name, options) {
  return {
    annotationType_: name,
    options_: options,
    make_: make_$2,
    extend_: extend_$2
  };
}

function make_$2(adm, key, descriptor, source) {
  var _this$options_;

  // own
  if (source === adm.target_) {
    return this.extend_(adm, key, descriptor, false) === null ? 0
    /* Cancel */
    : 2
    /* Continue */
    ;
  } // prototype
  // bound - must annotate protos to support super.flow()


  if (((_this$options_ = this.options_) == null ? void 0 : _this$options_.bound) && !isFlow(adm.target_[key])) {
    if (this.extend_(adm, key, descriptor, false) === null) return 0
    /* Cancel */
    ;
  }

  if (isFlow(descriptor.value)) {
    // A prototype could have been annotated already by other constructor,
    // rest of the proto chain must be annotated already
    return 1
    /* Break */
    ;
  }

  var flowDescriptor = createFlowDescriptor(adm, this, key, descriptor, false, false);
  defineProperty(source, key, flowDescriptor);
  return 2
  /* Continue */
  ;
}

function extend_$2(adm, key, descriptor, proxyTrap) {
  var _this$options_2;

  var flowDescriptor = createFlowDescriptor(adm, this, key, descriptor, (_this$options_2 = this.options_) == null ? void 0 : _this$options_2.bound);
  return adm.defineProperty_(key, flowDescriptor, proxyTrap);
}

function assertFlowDescriptor(adm, _ref, key, _ref2) {
  var annotationType_ = _ref.annotationType_;
  var value = _ref2.value;

  if (false) {}
}

function createFlowDescriptor(adm, annotation, key, descriptor, bound, // provides ability to disable safeDescriptors for prototypes
safeDescriptors) {
  if (safeDescriptors === void 0) {
    safeDescriptors = globalState.safeDescriptors;
  }

  assertFlowDescriptor(adm, annotation, key, descriptor);
  var value = descriptor.value;

  if (bound) {
    var _adm$proxy_;

    value = value.bind((_adm$proxy_ = adm.proxy_) != null ? _adm$proxy_ : adm.target_);
  }

  return {
    value: flow(value),
    // Non-configurable for classes
    // prevents accidental field redefinition in subclass
    configurable: safeDescriptors ? adm.isPlainObject_ : true,
    // https://github.com/mobxjs/mobx/pull/2641#issuecomment-737292058
    enumerable: false,
    // Non-obsevable, therefore non-writable
    // Also prevents rewriting in subclass constructor
    writable: safeDescriptors ? false : true
  };
}

function createComputedAnnotation(name, options) {
  return {
    annotationType_: name,
    options_: options,
    make_: make_$3,
    extend_: extend_$3
  };
}

function make_$3(adm, key, descriptor) {
  return this.extend_(adm, key, descriptor, false) === null ? 0
  /* Cancel */
  : 1
  /* Break */
  ;
}

function extend_$3(adm, key, descriptor, proxyTrap) {
  assertComputedDescriptor(adm, this, key, descriptor);
  return adm.defineComputedProperty_(key, _extends({}, this.options_, {
    get: descriptor.get,
    set: descriptor.set
  }), proxyTrap);
}

function assertComputedDescriptor(adm, _ref, key, _ref2) {
  var annotationType_ = _ref.annotationType_;
  var get = _ref2.get;

  if (false) {}
}

function createObservableAnnotation(name, options) {
  return {
    annotationType_: name,
    options_: options,
    make_: make_$4,
    extend_: extend_$4
  };
}

function make_$4(adm, key, descriptor) {
  return this.extend_(adm, key, descriptor, false) === null ? 0
  /* Cancel */
  : 1
  /* Break */
  ;
}

function extend_$4(adm, key, descriptor, proxyTrap) {
  var _this$options_$enhanc, _this$options_;

  assertObservableDescriptor(adm, this, key, descriptor);
  return adm.defineObservableProperty_(key, descriptor.value, (_this$options_$enhanc = (_this$options_ = this.options_) == null ? void 0 : _this$options_.enhancer) != null ? _this$options_$enhanc : deepEnhancer, proxyTrap);
}

function assertObservableDescriptor(adm, _ref, key, descriptor) {
  var annotationType_ = _ref.annotationType_;

  if (false) {}
}

var AUTO = "true";
var autoAnnotation = /*#__PURE__*/createAutoAnnotation();
function createAutoAnnotation(options) {
  return {
    annotationType_: AUTO,
    options_: options,
    make_: make_$5,
    extend_: extend_$5
  };
}

function make_$5(adm, key, descriptor, source) {
  var _this$options_3, _this$options_4;

  // getter -> computed
  if (descriptor.get) {
    return computed.make_(adm, key, descriptor, source);
  } // lone setter -> action setter


  if (descriptor.set) {
    // TODO make action applicable to setter and delegate to action.make_
    var set = createAction(key.toString(), descriptor.set); // own

    if (source === adm.target_) {
      return adm.defineProperty_(key, {
        configurable: globalState.safeDescriptors ? adm.isPlainObject_ : true,
        set: set
      }) === null ? 0
      /* Cancel */
      : 2
      /* Continue */
      ;
    } // proto


    defineProperty(source, key, {
      configurable: true,
      set: set
    });
    return 2
    /* Continue */
    ;
  } // function on proto -> autoAction/flow


  if (source !== adm.target_ && typeof descriptor.value === "function") {
    var _this$options_2;

    if (isGenerator(descriptor.value)) {
      var _this$options_;

      var flowAnnotation = ((_this$options_ = this.options_) == null ? void 0 : _this$options_.autoBind) ? flow.bound : flow;
      return flowAnnotation.make_(adm, key, descriptor, source);
    }

    var actionAnnotation = ((_this$options_2 = this.options_) == null ? void 0 : _this$options_2.autoBind) ? autoAction.bound : autoAction;
    return actionAnnotation.make_(adm, key, descriptor, source);
  } // other -> observable
  // Copy props from proto as well, see test:
  // "decorate should work with Object.create"


  var observableAnnotation = ((_this$options_3 = this.options_) == null ? void 0 : _this$options_3.deep) === false ? mobx_esm_observable.ref : mobx_esm_observable; // if function respect autoBind option

  if (typeof descriptor.value === "function" && ((_this$options_4 = this.options_) == null ? void 0 : _this$options_4.autoBind)) {
    var _adm$proxy_;

    descriptor.value = descriptor.value.bind((_adm$proxy_ = adm.proxy_) != null ? _adm$proxy_ : adm.target_);
  }

  return observableAnnotation.make_(adm, key, descriptor, source);
}

function extend_$5(adm, key, descriptor, proxyTrap) {
  var _this$options_5, _this$options_6;

  // getter -> computed
  if (descriptor.get) {
    return computed.extend_(adm, key, descriptor, proxyTrap);
  } // lone setter -> action setter


  if (descriptor.set) {
    // TODO make action applicable to setter and delegate to action.extend_
    return adm.defineProperty_(key, {
      configurable: globalState.safeDescriptors ? adm.isPlainObject_ : true,
      set: createAction(key.toString(), descriptor.set)
    }, proxyTrap);
  } // other -> observable
  // if function respect autoBind option


  if (typeof descriptor.value === "function" && ((_this$options_5 = this.options_) == null ? void 0 : _this$options_5.autoBind)) {
    var _adm$proxy_2;

    descriptor.value = descriptor.value.bind((_adm$proxy_2 = adm.proxy_) != null ? _adm$proxy_2 : adm.target_);
  }

  var observableAnnotation = ((_this$options_6 = this.options_) == null ? void 0 : _this$options_6.deep) === false ? mobx_esm_observable.ref : mobx_esm_observable;
  return observableAnnotation.extend_(adm, key, descriptor, proxyTrap);
}

var OBSERVABLE = "observable";
var OBSERVABLE_REF = "observable.ref";
var OBSERVABLE_SHALLOW = "observable.shallow";
var OBSERVABLE_STRUCT = "observable.struct"; // Predefined bags of create observable options, to avoid allocating temporarily option objects
// in the majority of cases

var defaultCreateObservableOptions = {
  deep: true,
  name: undefined,
  defaultDecorator: undefined,
  proxy: true
};
Object.freeze(defaultCreateObservableOptions);
function asCreateObservableOptions(thing) {
  return thing || defaultCreateObservableOptions;
}
var observableAnnotation = /*#__PURE__*/createObservableAnnotation(OBSERVABLE);
var observableRefAnnotation = /*#__PURE__*/createObservableAnnotation(OBSERVABLE_REF, {
  enhancer: referenceEnhancer
});
var observableShallowAnnotation = /*#__PURE__*/createObservableAnnotation(OBSERVABLE_SHALLOW, {
  enhancer: shallowEnhancer
});
var observableStructAnnotation = /*#__PURE__*/createObservableAnnotation(OBSERVABLE_STRUCT, {
  enhancer: refStructEnhancer
});
var observableDecoratorAnnotation = /*#__PURE__*/createDecoratorAnnotation(observableAnnotation);
function getEnhancerFromOptions(options) {
  return options.deep === true ? deepEnhancer : options.deep === false ? referenceEnhancer : getEnhancerFromAnnotation(options.defaultDecorator);
}
function getAnnotationFromOptions(options) {
  var _options$defaultDecor;

  return options ? (_options$defaultDecor = options.defaultDecorator) != null ? _options$defaultDecor : createAutoAnnotation(options) : undefined;
}
function getEnhancerFromAnnotation(annotation) {
  var _annotation$options_$, _annotation$options_;

  return !annotation ? deepEnhancer : (_annotation$options_$ = (_annotation$options_ = annotation.options_) == null ? void 0 : _annotation$options_.enhancer) != null ? _annotation$options_$ : deepEnhancer;
}
/**
 * Turns an object, array or function into a reactive structure.
 * @param v the value which should become observable.
 */

function createObservable(v, arg2, arg3) {
  // @observable someProp;
  if (isStringish(arg2)) {
    storeAnnotation(v, arg2, observableAnnotation);
    return;
  } // already observable - ignore


  if (isObservable(v)) return v; // plain object

  if (isPlainObject(v)) return mobx_esm_observable.object(v, arg2, arg3); // Array

  if (Array.isArray(v)) return mobx_esm_observable.array(v, arg2); // Map

  if (isES6Map(v)) return mobx_esm_observable.map(v, arg2); // Set

  if (isES6Set(v)) return mobx_esm_observable.set(v, arg2); // other object - ignore

  if (typeof v === "object" && v !== null) return v; // anything else

  return mobx_esm_observable.box(v, arg2);
}

Object.assign(createObservable, observableDecoratorAnnotation);
var observableFactories = {
  box: function box(value, options) {
    var o = asCreateObservableOptions(options);
    return new ObservableValue(value, getEnhancerFromOptions(o), o.name, true, o.equals);
  },
  array: function array(initialValues, options) {
    var o = asCreateObservableOptions(options);
    return (globalState.useProxies === false || o.proxy === false ? createLegacyArray : createObservableArray)(initialValues, getEnhancerFromOptions(o), o.name);
  },
  map: function map(initialValues, options) {
    var o = asCreateObservableOptions(options);
    return new ObservableMap(initialValues, getEnhancerFromOptions(o), o.name);
  },
  set: function set(initialValues, options) {
    var o = asCreateObservableOptions(options);
    return new ObservableSet(initialValues, getEnhancerFromOptions(o), o.name);
  },
  object: function object(props, decorators, options) {
    return extendObservable(globalState.useProxies === false || (options == null ? void 0 : options.proxy) === false ? asObservableObject({}, options) : asDynamicObservableObject({}, options), props, decorators);
  },
  ref: /*#__PURE__*/createDecoratorAnnotation(observableRefAnnotation),
  shallow: /*#__PURE__*/createDecoratorAnnotation(observableShallowAnnotation),
  deep: observableDecoratorAnnotation,
  struct: /*#__PURE__*/createDecoratorAnnotation(observableStructAnnotation)
}; // eslint-disable-next-line

var mobx_esm_observable = /*#__PURE__*/mobx_esm_assign(createObservable, observableFactories);

var COMPUTED = "computed";
var COMPUTED_STRUCT = "computed.struct";
var computedAnnotation = /*#__PURE__*/createComputedAnnotation(COMPUTED);
var computedStructAnnotation = /*#__PURE__*/createComputedAnnotation(COMPUTED_STRUCT, {
  equals: comparer.structural
});
/**
 * Decorator for class properties: @computed get value() { return expr; }.
 * For legacy purposes also invokable as ES5 observable created: `computed(() => expr)`;
 */

var computed = function computed(arg1, arg2) {
  if (isStringish(arg2)) {
    // @computed
    return storeAnnotation(arg1, arg2, computedAnnotation);
  }

  if (isPlainObject(arg1)) {
    // @computed({ options })
    return createDecoratorAnnotation(createComputedAnnotation(COMPUTED, arg1));
  } // computed(expr, options?)


  if (false) {}

  var opts = isPlainObject(arg2) ? arg2 : {};
  opts.get = arg1;
  opts.name || (opts.name = arg1.name || "");
  /* for generated name */

  return new ComputedValue(opts);
};
Object.assign(computed, computedAnnotation);
computed.struct = /*#__PURE__*/createDecoratorAnnotation(computedStructAnnotation);

var _getDescriptor$config, _getDescriptor;
// mobx versions

var currentActionId = 0;
var nextActionId = 1;
var isFunctionNameConfigurable = (_getDescriptor$config = (_getDescriptor = /*#__PURE__*/getDescriptor(function () {}, "name")) == null ? void 0 : _getDescriptor.configurable) != null ? _getDescriptor$config : false; // we can safely recycle this object

var tmpNameDescriptor = {
  value: "action",
  configurable: true,
  writable: false,
  enumerable: false
};
function createAction(actionName, fn, autoAction, ref) {
  if (autoAction === void 0) {
    autoAction = false;
  }

  if (false) {}

  function res() {
    return executeAction(actionName, autoAction, fn, ref || this, arguments);
  }

  res.isMobxAction = true;

  if (isFunctionNameConfigurable) {
    tmpNameDescriptor.value = actionName;
    Object.defineProperty(res, "name", tmpNameDescriptor);
  }

  return res;
}
function executeAction(actionName, canRunAsDerivation, fn, scope, args) {
  var runInfo = _startAction(actionName, canRunAsDerivation, scope, args);

  try {
    return fn.apply(scope, args);
  } catch (err) {
    runInfo.error_ = err;
    throw err;
  } finally {
    _endAction(runInfo);
  }
}
function _startAction(actionName, canRunAsDerivation, // true for autoAction
scope, args) {
  var notifySpy_ =  false && 0;
  var startTime_ = 0;

  if (false) { var flattenedArgs; }

  var prevDerivation_ = globalState.trackingDerivation;
  var runAsAction = !canRunAsDerivation || !prevDerivation_;
  startBatch();
  var prevAllowStateChanges_ = globalState.allowStateChanges; // by default preserve previous allow

  if (runAsAction) {
    untrackedStart();
    prevAllowStateChanges_ = allowStateChangesStart(true);
  }

  var prevAllowStateReads_ = allowStateReadsStart(true);
  var runInfo = {
    runAsAction_: runAsAction,
    prevDerivation_: prevDerivation_,
    prevAllowStateChanges_: prevAllowStateChanges_,
    prevAllowStateReads_: prevAllowStateReads_,
    notifySpy_: notifySpy_,
    startTime_: startTime_,
    actionId_: nextActionId++,
    parentActionId_: currentActionId
  };
  currentActionId = runInfo.actionId_;
  return runInfo;
}
function _endAction(runInfo) {
  if (currentActionId !== runInfo.actionId_) {
    die(30);
  }

  currentActionId = runInfo.parentActionId_;

  if (runInfo.error_ !== undefined) {
    globalState.suppressReactionErrors = true;
  }

  allowStateChangesEnd(runInfo.prevAllowStateChanges_);
  allowStateReadsEnd(runInfo.prevAllowStateReads_);
  endBatch();
  if (runInfo.runAsAction_) untrackedEnd(runInfo.prevDerivation_);

  if (false) {}

  globalState.suppressReactionErrors = false;
}
function allowStateChanges(allowStateChanges, func) {
  var prev = allowStateChangesStart(allowStateChanges);

  try {
    return func();
  } finally {
    allowStateChangesEnd(prev);
  }
}
function allowStateChangesStart(allowStateChanges) {
  var prev = globalState.allowStateChanges;
  globalState.allowStateChanges = allowStateChanges;
  return prev;
}
function allowStateChangesEnd(prev) {
  globalState.allowStateChanges = prev;
}

var _Symbol$toPrimitive;
var CREATE = "create";
_Symbol$toPrimitive = Symbol.toPrimitive;
var ObservableValue = /*#__PURE__*/function (_Atom) {
  _inheritsLoose(ObservableValue, _Atom);

  function ObservableValue(value, enhancer, name_, notifySpy, equals) {
    var _this;

    if (name_ === void 0) {
      name_ =  false ? 0 : "ObservableValue";
    }

    if (notifySpy === void 0) {
      notifySpy = true;
    }

    if (equals === void 0) {
      equals = comparer["default"];
    }

    _this = _Atom.call(this, name_) || this;
    _this.enhancer = void 0;
    _this.name_ = void 0;
    _this.equals = void 0;
    _this.hasUnreportedChange_ = false;
    _this.interceptors_ = void 0;
    _this.changeListeners_ = void 0;
    _this.value_ = void 0;
    _this.dehancer = void 0;
    _this.enhancer = enhancer;
    _this.name_ = name_;
    _this.equals = equals;
    _this.value_ = enhancer(value, undefined, name_);

    if (false) {}

    return _this;
  }

  var _proto = ObservableValue.prototype;

  _proto.dehanceValue = function dehanceValue(value) {
    if (this.dehancer !== undefined) return this.dehancer(value);
    return value;
  };

  _proto.set = function set(newValue) {
    var oldValue = this.value_;
    newValue = this.prepareNewValue_(newValue);

    if (newValue !== globalState.UNCHANGED) {
      var notifySpy = isSpyEnabled();

      if (false) {}

      this.setNewValue_(newValue);
      if (false) {}
    }
  };

  _proto.prepareNewValue_ = function prepareNewValue_(newValue) {
    checkIfStateModificationsAreAllowed(this);

    if (hasInterceptors(this)) {
      var change = interceptChange(this, {
        object: this,
        type: UPDATE,
        newValue: newValue
      });
      if (!change) return globalState.UNCHANGED;
      newValue = change.newValue;
    } // apply modifier


    newValue = this.enhancer(newValue, this.value_, this.name_);
    return this.equals(this.value_, newValue) ? globalState.UNCHANGED : newValue;
  };

  _proto.setNewValue_ = function setNewValue_(newValue) {
    var oldValue = this.value_;
    this.value_ = newValue;
    this.reportChanged();

    if (hasListeners(this)) {
      notifyListeners(this, {
        type: UPDATE,
        object: this,
        newValue: newValue,
        oldValue: oldValue
      });
    }
  };

  _proto.get = function get() {
    this.reportObserved();
    return this.dehanceValue(this.value_);
  };

  _proto.intercept_ = function intercept_(handler) {
    return registerInterceptor(this, handler);
  };

  _proto.observe_ = function observe_(listener, fireImmediately) {
    if (fireImmediately) listener({
      observableKind: "value",
      debugObjectName: this.name_,
      object: this,
      type: UPDATE,
      newValue: this.value_,
      oldValue: undefined
    });
    return registerListener(this, listener);
  };

  _proto.raw = function raw() {
    // used by MST ot get undehanced value
    return this.value_;
  };

  _proto.toJSON = function toJSON() {
    return this.get();
  };

  _proto.toString = function toString() {
    return this.name_ + "[" + this.value_ + "]";
  };

  _proto.valueOf = function valueOf() {
    return toPrimitive(this.get());
  };

  _proto[_Symbol$toPrimitive] = function () {
    return this.valueOf();
  };

  return ObservableValue;
}(Atom);
var isObservableValue = /*#__PURE__*/(/* unused pure expression or super */ null && (createInstanceofPredicate("ObservableValue", ObservableValue)));

var _Symbol$toPrimitive$1;
/**
 * A node in the state dependency root that observes other nodes, and can be observed itself.
 *
 * ComputedValue will remember the result of the computation for the duration of the batch, or
 * while being observed.
 *
 * During this time it will recompute only when one of its direct dependencies changed,
 * but only when it is being accessed with `ComputedValue.get()`.
 *
 * Implementation description:
 * 1. First time it's being accessed it will compute and remember result
 *    give back remembered result until 2. happens
 * 2. First time any deep dependency change, propagate POSSIBLY_STALE to all observers, wait for 3.
 * 3. When it's being accessed, recompute if any shallow dependency changed.
 *    if result changed: propagate STALE to all observers, that were POSSIBLY_STALE from the last step.
 *    go to step 2. either way
 *
 * If at any point it's outside batch and it isn't observed: reset everything and go to 1.
 */

_Symbol$toPrimitive$1 = Symbol.toPrimitive;
var ComputedValue = /*#__PURE__*/function () {
  // nodes we are looking at. Our value depends on these nodes
  // during tracking it's an array with new observed observers
  // to check for cycles
  // N.B: unminified as it is used by MST

  /**
   * Create a new computed value based on a function expression.
   *
   * The `name` property is for debug purposes only.
   *
   * The `equals` property specifies the comparer function to use to determine if a newly produced
   * value differs from the previous value. Two comparers are provided in the library; `defaultComparer`
   * compares based on identity comparison (===), and `structuralComparer` deeply compares the structure.
   * Structural comparison can be convenient if you always produce a new aggregated object and
   * don't want to notify observers if it is structurally the same.
   * This is useful for working with vectors, mouse coordinates etc.
   */
  function ComputedValue(options) {
    this.dependenciesState_ = IDerivationState_.NOT_TRACKING_;
    this.observing_ = [];
    this.newObserving_ = null;
    this.isBeingObserved_ = false;
    this.isPendingUnobservation_ = false;
    this.observers_ = new Set();
    this.diffValue_ = 0;
    this.runId_ = 0;
    this.lastAccessedBy_ = 0;
    this.lowestObserverState_ = IDerivationState_.UP_TO_DATE_;
    this.unboundDepsCount_ = 0;
    this.value_ = new CaughtException(null);
    this.name_ = void 0;
    this.triggeredBy_ = void 0;
    this.isComputing_ = false;
    this.isRunningSetter_ = false;
    this.derivation = void 0;
    this.setter_ = void 0;
    this.isTracing_ = TraceMode.NONE;
    this.scope_ = void 0;
    this.equals_ = void 0;
    this.requiresReaction_ = void 0;
    this.keepAlive_ = void 0;
    this.onBOL = void 0;
    this.onBUOL = void 0;
    if (!options.get) die(31);
    this.derivation = options.get;
    this.name_ = options.name || ( false ? 0 : "ComputedValue");

    if (options.set) {
      this.setter_ = createAction( false ? 0 : "ComputedValue-setter", options.set);
    }

    this.equals_ = options.equals || (options.compareStructural || options.struct ? comparer.structural : comparer["default"]);
    this.scope_ = options.context;
    this.requiresReaction_ = !!options.requiresReaction;
    this.keepAlive_ = !!options.keepAlive;
  }

  var _proto = ComputedValue.prototype;

  _proto.onBecomeStale_ = function onBecomeStale_() {
    propagateMaybeChanged(this);
  };

  _proto.onBO = function onBO() {
    if (this.onBOL) {
      this.onBOL.forEach(function (listener) {
        return listener();
      });
    }
  };

  _proto.onBUO = function onBUO() {
    if (this.onBUOL) {
      this.onBUOL.forEach(function (listener) {
        return listener();
      });
    }
  }
  /**
   * Returns the current value of this computed value.
   * Will evaluate its computation first if needed.
   */
  ;

  _proto.get = function get() {
    if (this.isComputing_) die(32, this.name_, this.derivation);

    if (globalState.inBatch === 0 && // !globalState.trackingDerivatpion &&
    this.observers_.size === 0 && !this.keepAlive_) {
      if (shouldCompute(this)) {
        this.warnAboutUntrackedRead_();
        startBatch(); // See perf test 'computed memoization'

        this.value_ = this.computeValue_(false);
        endBatch();
      }
    } else {
      reportObserved(this);

      if (shouldCompute(this)) {
        var prevTrackingContext = globalState.trackingContext;
        if (this.keepAlive_ && !prevTrackingContext) globalState.trackingContext = this;
        if (this.trackAndCompute()) propagateChangeConfirmed(this);
        globalState.trackingContext = prevTrackingContext;
      }
    }

    var result = this.value_;
    if (isCaughtException(result)) throw result.cause;
    return result;
  };

  _proto.set = function set(value) {
    if (this.setter_) {
      if (this.isRunningSetter_) die(33, this.name_);
      this.isRunningSetter_ = true;

      try {
        this.setter_.call(this.scope_, value);
      } finally {
        this.isRunningSetter_ = false;
      }
    } else die(34, this.name_);
  };

  _proto.trackAndCompute = function trackAndCompute() {
    // N.B: unminified as it is used by MST
    var oldValue = this.value_;
    var wasSuspended =
    /* see #1208 */
    this.dependenciesState_ === IDerivationState_.NOT_TRACKING_;
    var newValue = this.computeValue_(true);

    if (false) {}

    var changed = wasSuspended || isCaughtException(oldValue) || isCaughtException(newValue) || !this.equals_(oldValue, newValue);

    if (changed) {
      this.value_ = newValue;
    }

    return changed;
  };

  _proto.computeValue_ = function computeValue_(track) {
    this.isComputing_ = true; // don't allow state changes during computation

    var prev = allowStateChangesStart(false);
    var res;

    if (track) {
      res = trackDerivedFunction(this, this.derivation, this.scope_);
    } else {
      if (globalState.disableErrorBoundaries === true) {
        res = this.derivation.call(this.scope_);
      } else {
        try {
          res = this.derivation.call(this.scope_);
        } catch (e) {
          res = new CaughtException(e);
        }
      }
    }

    allowStateChangesEnd(prev);
    this.isComputing_ = false;
    return res;
  };

  _proto.suspend_ = function suspend_() {
    if (!this.keepAlive_) {
      clearObserving(this);
      this.value_ = undefined; // don't hold on to computed value!

      if (false) {}
    }
  };

  _proto.observe_ = function observe_(listener, fireImmediately) {
    var _this = this;

    var firstTime = true;
    var prevValue = undefined;
    return autorun(function () {
      // TODO: why is this in a different place than the spyReport() function? in all other observables it's called in the same place
      var newValue = _this.get();

      if (!firstTime || fireImmediately) {
        var prevU = untrackedStart();
        listener({
          observableKind: "computed",
          debugObjectName: _this.name_,
          type: UPDATE,
          object: _this,
          newValue: newValue,
          oldValue: prevValue
        });
        untrackedEnd(prevU);
      }

      firstTime = false;
      prevValue = newValue;
    });
  };

  _proto.warnAboutUntrackedRead_ = function warnAboutUntrackedRead_() {
    if (true) return;

    if (this.isTracing_ !== TraceMode.NONE) {
      console.log("[mobx.trace] Computed value '" + this.name_ + "' is being read outside a reactive context. Doing a full recompute.");
    }

    if (globalState.computedRequiresReaction || this.requiresReaction_) {
      console.warn("[mobx] Computed value '" + this.name_ + "' is being read outside a reactive context. Doing a full recompute.");
    }
  };

  _proto.toString = function toString() {
    return this.name_ + "[" + this.derivation.toString() + "]";
  };

  _proto.valueOf = function valueOf() {
    return toPrimitive(this.get());
  };

  _proto[_Symbol$toPrimitive$1] = function () {
    return this.valueOf();
  };

  return ComputedValue;
}();
var isComputedValue = /*#__PURE__*/createInstanceofPredicate("ComputedValue", ComputedValue);

var IDerivationState_;

(function (IDerivationState_) {
  // before being run or (outside batch and not being observed)
  // at this point derivation is not holding any data about dependency tree
  IDerivationState_[IDerivationState_["NOT_TRACKING_"] = -1] = "NOT_TRACKING_"; // no shallow dependency changed since last computation
  // won't recalculate derivation
  // this is what makes mobx fast

  IDerivationState_[IDerivationState_["UP_TO_DATE_"] = 0] = "UP_TO_DATE_"; // some deep dependency changed, but don't know if shallow dependency changed
  // will require to check first if UP_TO_DATE or POSSIBLY_STALE
  // currently only ComputedValue will propagate POSSIBLY_STALE
  //
  // having this state is second big optimization:
  // don't have to recompute on every dependency change, but only when it's needed

  IDerivationState_[IDerivationState_["POSSIBLY_STALE_"] = 1] = "POSSIBLY_STALE_"; // A shallow dependency has changed since last computation and the derivation
  // will need to recompute when it's needed next.

  IDerivationState_[IDerivationState_["STALE_"] = 2] = "STALE_";
})(IDerivationState_ || (IDerivationState_ = {}));

var TraceMode;

(function (TraceMode) {
  TraceMode[TraceMode["NONE"] = 0] = "NONE";
  TraceMode[TraceMode["LOG"] = 1] = "LOG";
  TraceMode[TraceMode["BREAK"] = 2] = "BREAK";
})(TraceMode || (TraceMode = {}));

var CaughtException = function CaughtException(cause) {
  this.cause = void 0;
  this.cause = cause; // Empty
};
function isCaughtException(e) {
  return e instanceof CaughtException;
}
/**
 * Finds out whether any dependency of the derivation has actually changed.
 * If dependenciesState is 1 then it will recalculate dependencies,
 * if any dependency changed it will propagate it by changing dependenciesState to 2.
 *
 * By iterating over the dependencies in the same order that they were reported and
 * stopping on the first change, all the recalculations are only called for ComputedValues
 * that will be tracked by derivation. That is because we assume that if the first x
 * dependencies of the derivation doesn't change then the derivation should run the same way
 * up until accessing x-th dependency.
 */

function shouldCompute(derivation) {
  switch (derivation.dependenciesState_) {
    case IDerivationState_.UP_TO_DATE_:
      return false;

    case IDerivationState_.NOT_TRACKING_:
    case IDerivationState_.STALE_:
      return true;

    case IDerivationState_.POSSIBLY_STALE_:
      {
        // state propagation can occur outside of action/reactive context #2195
        var prevAllowStateReads = allowStateReadsStart(true);
        var prevUntracked = untrackedStart(); // no need for those computeds to be reported, they will be picked up in trackDerivedFunction.

        var obs = derivation.observing_,
            l = obs.length;

        for (var i = 0; i < l; i++) {
          var obj = obs[i];

          if (isComputedValue(obj)) {
            if (globalState.disableErrorBoundaries) {
              obj.get();
            } else {
              try {
                obj.get();
              } catch (e) {
                // we are not interested in the value *or* exception at this moment, but if there is one, notify all
                untrackedEnd(prevUntracked);
                allowStateReadsEnd(prevAllowStateReads);
                return true;
              }
            } // if ComputedValue `obj` actually changed it will be computed and propagated to its observers.
            // and `derivation` is an observer of `obj`
            // invariantShouldCompute(derivation)


            if (derivation.dependenciesState_ === IDerivationState_.STALE_) {
              untrackedEnd(prevUntracked);
              allowStateReadsEnd(prevAllowStateReads);
              return true;
            }
          }
        }

        changeDependenciesStateTo0(derivation);
        untrackedEnd(prevUntracked);
        allowStateReadsEnd(prevAllowStateReads);
        return false;
      }
  }
}
function isComputingDerivation() {
  return globalState.trackingDerivation !== null; // filter out actions inside computations
}
function checkIfStateModificationsAreAllowed(atom) {
  if (true) {
    return;
  }

  var hasObservers = atom.observers_.size > 0; // Should not be possible to change observed state outside strict mode, except during initialization, see #563

  if (!globalState.allowStateChanges && (hasObservers || globalState.enforceActions === "always")) console.warn("[MobX] " + (globalState.enforceActions ? "Since strict-mode is enabled, changing (observed) observable values without using an action is not allowed. Tried to modify: " : "Side effects like changing state are not allowed at this point. Are you trying to modify state from, for example, a computed value or the render function of a React component? You can wrap side effects in 'runInAction' (or decorate functions with 'action') if needed. Tried to modify: ") + atom.name_);
}
function checkIfStateReadsAreAllowed(observable) {
  if (false) {}
}
/**
 * Executes the provided function `f` and tracks which observables are being accessed.
 * The tracking information is stored on the `derivation` object and the derivation is registered
 * as observer of any of the accessed observables.
 */

function trackDerivedFunction(derivation, f, context) {
  var prevAllowStateReads = allowStateReadsStart(true); // pre allocate array allocation + room for variation in deps
  // array will be trimmed by bindDependencies

  changeDependenciesStateTo0(derivation);
  derivation.newObserving_ = new Array(derivation.observing_.length + 100);
  derivation.unboundDepsCount_ = 0;
  derivation.runId_ = ++globalState.runId;
  var prevTracking = globalState.trackingDerivation;
  globalState.trackingDerivation = derivation;
  globalState.inBatch++;
  var result;

  if (globalState.disableErrorBoundaries === true) {
    result = f.call(context);
  } else {
    try {
      result = f.call(context);
    } catch (e) {
      result = new CaughtException(e);
    }
  }

  globalState.inBatch--;
  globalState.trackingDerivation = prevTracking;
  bindDependencies(derivation);
  warnAboutDerivationWithoutDependencies(derivation);
  allowStateReadsEnd(prevAllowStateReads);
  return result;
}

function warnAboutDerivationWithoutDependencies(derivation) {
  if (true) return;
  if (derivation.observing_.length !== 0) return;

  if (globalState.reactionRequiresObservable || derivation.requiresObservable_) {
    console.warn("[mobx] Derivation '" + derivation.name_ + "' is created/updated without reading any observable value.");
  }
}
/**
 * diffs newObserving with observing.
 * update observing to be newObserving with unique observables
 * notify observers that become observed/unobserved
 */


function bindDependencies(derivation) {
  // invariant(derivation.dependenciesState !== IDerivationState.NOT_TRACKING, "INTERNAL ERROR bindDependencies expects derivation.dependenciesState !== -1");
  var prevObserving = derivation.observing_;
  var observing = derivation.observing_ = derivation.newObserving_;
  var lowestNewObservingDerivationState = IDerivationState_.UP_TO_DATE_; // Go through all new observables and check diffValue: (this list can contain duplicates):
  //   0: first occurrence, change to 1 and keep it
  //   1: extra occurrence, drop it

  var i0 = 0,
      l = derivation.unboundDepsCount_;

  for (var i = 0; i < l; i++) {
    var dep = observing[i];

    if (dep.diffValue_ === 0) {
      dep.diffValue_ = 1;
      if (i0 !== i) observing[i0] = dep;
      i0++;
    } // Upcast is 'safe' here, because if dep is IObservable, `dependenciesState` will be undefined,
    // not hitting the condition


    if (dep.dependenciesState_ > lowestNewObservingDerivationState) {
      lowestNewObservingDerivationState = dep.dependenciesState_;
    }
  }

  observing.length = i0;
  derivation.newObserving_ = null; // newObserving shouldn't be needed outside tracking (statement moved down to work around FF bug, see #614)
  // Go through all old observables and check diffValue: (it is unique after last bindDependencies)
  //   0: it's not in new observables, unobserve it
  //   1: it keeps being observed, don't want to notify it. change to 0

  l = prevObserving.length;

  while (l--) {
    var _dep = prevObserving[l];

    if (_dep.diffValue_ === 0) {
      removeObserver(_dep, derivation);
    }

    _dep.diffValue_ = 0;
  } // Go through all new observables and check diffValue: (now it should be unique)
  //   0: it was set to 0 in last loop. don't need to do anything.
  //   1: it wasn't observed, let's observe it. set back to 0


  while (i0--) {
    var _dep2 = observing[i0];

    if (_dep2.diffValue_ === 1) {
      _dep2.diffValue_ = 0;
      addObserver(_dep2, derivation);
    }
  } // Some new observed derivations may become stale during this derivation computation
  // so they have had no chance to propagate staleness (#916)


  if (lowestNewObservingDerivationState !== IDerivationState_.UP_TO_DATE_) {
    derivation.dependenciesState_ = lowestNewObservingDerivationState;
    derivation.onBecomeStale_();
  }
}

function clearObserving(derivation) {
  // invariant(globalState.inBatch > 0, "INTERNAL ERROR clearObserving should be called only inside batch");
  var obs = derivation.observing_;
  derivation.observing_ = [];
  var i = obs.length;

  while (i--) {
    removeObserver(obs[i], derivation);
  }

  derivation.dependenciesState_ = IDerivationState_.NOT_TRACKING_;
}
function untracked(action) {
  var prev = untrackedStart();

  try {
    return action();
  } finally {
    untrackedEnd(prev);
  }
}
function untrackedStart() {
  var prev = globalState.trackingDerivation;
  globalState.trackingDerivation = null;
  return prev;
}
function untrackedEnd(prev) {
  globalState.trackingDerivation = prev;
}
function allowStateReadsStart(allowStateReads) {
  var prev = globalState.allowStateReads;
  globalState.allowStateReads = allowStateReads;
  return prev;
}
function allowStateReadsEnd(prev) {
  globalState.allowStateReads = prev;
}
/**
 * needed to keep `lowestObserverState` correct. when changing from (2 or 1) to 0
 *
 */

function changeDependenciesStateTo0(derivation) {
  if (derivation.dependenciesState_ === IDerivationState_.UP_TO_DATE_) return;
  derivation.dependenciesState_ = IDerivationState_.UP_TO_DATE_;
  var obs = derivation.observing_;
  var i = obs.length;

  while (i--) {
    obs[i].lowestObserverState_ = IDerivationState_.UP_TO_DATE_;
  }
}

/**
 * These values will persist if global state is reset
 */

var persistentKeys = (/* unused pure expression or super */ null && (["mobxGuid", "spyListeners", "enforceActions", "computedRequiresReaction", "reactionRequiresObservable", "observableRequiresReaction", "allowStateReads", "disableErrorBoundaries", "runId", "UNCHANGED", "useProxies"]));
var MobXGlobals = function MobXGlobals() {
  this.version = 6;
  this.UNCHANGED = {};
  this.trackingDerivation = null;
  this.trackingContext = null;
  this.runId = 0;
  this.mobxGuid = 0;
  this.inBatch = 0;
  this.pendingUnobservations = [];
  this.pendingReactions = [];
  this.isRunningReactions = false;
  this.allowStateChanges = false;
  this.allowStateReads = true;
  this.enforceActions = true;
  this.spyListeners = [];
  this.globalReactionErrorHandlers = [];
  this.computedRequiresReaction = false;
  this.reactionRequiresObservable = false;
  this.observableRequiresReaction = false;
  this.disableErrorBoundaries = false;
  this.suppressReactionErrors = false;
  this.useProxies = true;
  this.verifyProxies = false;
  this.safeDescriptors = true;
};
var canMergeGlobalState = true;
var isolateCalled = false;
var globalState = /*#__PURE__*/function () {
  var global = /*#__PURE__*/getGlobal();
  if (global.__mobxInstanceCount > 0 && !global.__mobxGlobals) canMergeGlobalState = false;
  if (global.__mobxGlobals && global.__mobxGlobals.version !== new MobXGlobals().version) canMergeGlobalState = false;

  if (!canMergeGlobalState) {
    setTimeout(function () {
      if (!isolateCalled) {
        die(35);
      }
    }, 1);
    return new MobXGlobals();
  } else if (global.__mobxGlobals) {
    global.__mobxInstanceCount += 1;
    if (!global.__mobxGlobals.UNCHANGED) global.__mobxGlobals.UNCHANGED = {}; // make merge backward compatible

    return global.__mobxGlobals;
  } else {
    global.__mobxInstanceCount = 1;
    return global.__mobxGlobals = /*#__PURE__*/new MobXGlobals();
  }
}();
function isolateGlobalState() {
  if (globalState.pendingReactions.length || globalState.inBatch || globalState.isRunningReactions) die(36);
  isolateCalled = true;

  if (canMergeGlobalState) {
    var global = getGlobal();
    if (--global.__mobxInstanceCount === 0) global.__mobxGlobals = undefined;
    globalState = new MobXGlobals();
  }
}
function getGlobalState() {
  return globalState;
}
/**
 * For testing purposes only; this will break the internal state of existing observables,
 * but can be used to get back at a stable state after throwing errors
 */

function resetGlobalState() {
  var defaultGlobals = new MobXGlobals();

  for (var key in defaultGlobals) {
    if (persistentKeys.indexOf(key) === -1) globalState[key] = defaultGlobals[key];
  }

  globalState.allowStateChanges = !globalState.enforceActions;
}

function hasObservers(observable) {
  return observable.observers_ && observable.observers_.size > 0;
}
function getObservers(observable) {
  return observable.observers_;
} // function invariantObservers(observable: IObservable) {
//     const list = observable.observers
//     const map = observable.observersIndexes
//     const l = list.length
//     for (let i = 0; i < l; i++) {
//         const id = list[i].__mapid
//         if (i) {
//             invariant(map[id] === i, "INTERNAL ERROR maps derivation.__mapid to index in list") // for performance
//         } else {
//             invariant(!(id in map), "INTERNAL ERROR observer on index 0 shouldn't be held in map.") // for performance
//         }
//     }
//     invariant(
//         list.length === 0 || Object.keys(map).length === list.length - 1,
//         "INTERNAL ERROR there is no junk in map"
//     )
// }

function addObserver(observable, node) {
  // invariant(node.dependenciesState !== -1, "INTERNAL ERROR, can add only dependenciesState !== -1");
  // invariant(observable._observers.indexOf(node) === -1, "INTERNAL ERROR add already added node");
  // invariantObservers(observable);
  observable.observers_.add(node);
  if (observable.lowestObserverState_ > node.dependenciesState_) observable.lowestObserverState_ = node.dependenciesState_; // invariantObservers(observable);
  // invariant(observable._observers.indexOf(node) !== -1, "INTERNAL ERROR didn't add node");
}
function removeObserver(observable, node) {
  // invariant(globalState.inBatch > 0, "INTERNAL ERROR, remove should be called only inside batch");
  // invariant(observable._observers.indexOf(node) !== -1, "INTERNAL ERROR remove already removed node");
  // invariantObservers(observable);
  observable.observers_["delete"](node);

  if (observable.observers_.size === 0) {
    // deleting last observer
    queueForUnobservation(observable);
  } // invariantObservers(observable);
  // invariant(observable._observers.indexOf(node) === -1, "INTERNAL ERROR remove already removed node2");

}
function queueForUnobservation(observable) {
  if (observable.isPendingUnobservation_ === false) {
    // invariant(observable._observers.length === 0, "INTERNAL ERROR, should only queue for unobservation unobserved observables");
    observable.isPendingUnobservation_ = true;
    globalState.pendingUnobservations.push(observable);
  }
}
/**
 * Batch starts a transaction, at least for purposes of memoizing ComputedValues when nothing else does.
 * During a batch `onBecomeUnobserved` will be called at most once per observable.
 * Avoids unnecessary recalculations.
 */

function startBatch() {
  globalState.inBatch++;
}
function endBatch() {
  if (--globalState.inBatch === 0) {
    runReactions(); // the batch is actually about to finish, all unobserving should happen here.

    var list = globalState.pendingUnobservations;

    for (var i = 0; i < list.length; i++) {
      var observable = list[i];
      observable.isPendingUnobservation_ = false;

      if (observable.observers_.size === 0) {
        if (observable.isBeingObserved_) {
          // if this observable had reactive observers, trigger the hooks
          observable.isBeingObserved_ = false;
          observable.onBUO();
        }

        if (observable instanceof ComputedValue) {
          // computed values are automatically teared down when the last observer leaves
          // this process happens recursively, this computed might be the last observabe of another, etc..
          observable.suspend_();
        }
      }
    }

    globalState.pendingUnobservations = [];
  }
}
function reportObserved(observable) {
  checkIfStateReadsAreAllowed(observable);
  var derivation = globalState.trackingDerivation;

  if (derivation !== null) {
    /**
     * Simple optimization, give each derivation run an unique id (runId)
     * Check if last time this observable was accessed the same runId is used
     * if this is the case, the relation is already known
     */
    if (derivation.runId_ !== observable.lastAccessedBy_) {
      observable.lastAccessedBy_ = derivation.runId_; // Tried storing newObserving, or observing, or both as Set, but performance didn't come close...

      derivation.newObserving_[derivation.unboundDepsCount_++] = observable;

      if (!observable.isBeingObserved_ && globalState.trackingContext) {
        observable.isBeingObserved_ = true;
        observable.onBO();
      }
    }

    return true;
  } else if (observable.observers_.size === 0 && globalState.inBatch > 0) {
    queueForUnobservation(observable);
  }

  return false;
} // function invariantLOS(observable: IObservable, msg: string) {
//     // it's expensive so better not run it in produciton. but temporarily helpful for testing
//     const min = getObservers(observable).reduce((a, b) => Math.min(a, b.dependenciesState), 2)
//     if (min >= observable.lowestObserverState) return // <- the only assumption about `lowestObserverState`
//     throw new Error(
//         "lowestObserverState is wrong for " +
//             msg +
//             " because " +
//             min +
//             " < " +
//             observable.lowestObserverState
//     )
// }

/**
 * NOTE: current propagation mechanism will in case of self reruning autoruns behave unexpectedly
 * It will propagate changes to observers from previous run
 * It's hard or maybe impossible (with reasonable perf) to get it right with current approach
 * Hopefully self reruning autoruns aren't a feature people should depend on
 * Also most basic use cases should be ok
 */
// Called by Atom when its value changes

function propagateChanged(observable) {
  // invariantLOS(observable, "changed start");
  if (observable.lowestObserverState_ === IDerivationState_.STALE_) return;
  observable.lowestObserverState_ = IDerivationState_.STALE_; // Ideally we use for..of here, but the downcompiled version is really slow...

  observable.observers_.forEach(function (d) {
    if (d.dependenciesState_ === IDerivationState_.UP_TO_DATE_) {
      if (false) {}

      d.onBecomeStale_();
    }

    d.dependenciesState_ = IDerivationState_.STALE_;
  }); // invariantLOS(observable, "changed end");
} // Called by ComputedValue when it recalculate and its value changed

function propagateChangeConfirmed(observable) {
  // invariantLOS(observable, "confirmed start");
  if (observable.lowestObserverState_ === IDerivationState_.STALE_) return;
  observable.lowestObserverState_ = IDerivationState_.STALE_;
  observable.observers_.forEach(function (d) {
    if (d.dependenciesState_ === IDerivationState_.POSSIBLY_STALE_) {
      d.dependenciesState_ = IDerivationState_.STALE_;

      if (false) {}
    } else if (d.dependenciesState_ === IDerivationState_.UP_TO_DATE_ // this happens during computing of `d`, just keep lowestObserverState up to date.
    ) {
        observable.lowestObserverState_ = IDerivationState_.UP_TO_DATE_;
      }
  }); // invariantLOS(observable, "confirmed end");
} // Used by computed when its dependency changed, but we don't wan't to immediately recompute.

function propagateMaybeChanged(observable) {
  // invariantLOS(observable, "maybe start");
  if (observable.lowestObserverState_ !== IDerivationState_.UP_TO_DATE_) return;
  observable.lowestObserverState_ = IDerivationState_.POSSIBLY_STALE_;
  observable.observers_.forEach(function (d) {
    if (d.dependenciesState_ === IDerivationState_.UP_TO_DATE_) {
      d.dependenciesState_ = IDerivationState_.POSSIBLY_STALE_;
      d.onBecomeStale_();
    }
  }); // invariantLOS(observable, "maybe end");
}

function logTraceInfo(derivation, observable) {
  console.log("[mobx.trace] '" + derivation.name_ + "' is invalidated due to a change in: '" + observable.name_ + "'");

  if (derivation.isTracing_ === TraceMode.BREAK) {
    var lines = [];
    printDepTree(getDependencyTree(derivation), lines, 1); // prettier-ignore

    new Function("debugger;\n/*\nTracing '" + derivation.name_ + "'\n\nYou are entering this break point because derivation '" + derivation.name_ + "' is being traced and '" + observable.name_ + "' is now forcing it to update.\nJust follow the stacktrace you should now see in the devtools to see precisely what piece of your code is causing this update\nThe stackframe you are looking for is at least ~6-8 stack-frames up.\n\n" + (derivation instanceof ComputedValue ? derivation.derivation.toString().replace(/[*]\//g, "/") : "") + "\n\nThe dependencies for this derivation are:\n\n" + lines.join("\n") + "\n*/\n    ")();
  }
}

function printDepTree(tree, lines, depth) {
  if (lines.length >= 1000) {
    lines.push("(and many more)");
    return;
  }

  lines.push("" + new Array(depth).join("\t") + tree.name); // MWE: not the fastest, but the easiest way :)

  if (tree.dependencies) tree.dependencies.forEach(function (child) {
    return printDepTree(child, lines, depth + 1);
  });
}

var Reaction = /*#__PURE__*/function () {
  // nodes we are looking at. Our value depends on these nodes
  function Reaction(name_, onInvalidate_, errorHandler_, requiresObservable_) {
    if (name_ === void 0) {
      name_ =  false ? 0 : "Reaction";
    }

    if (requiresObservable_ === void 0) {
      requiresObservable_ = false;
    }

    this.name_ = void 0;
    this.onInvalidate_ = void 0;
    this.errorHandler_ = void 0;
    this.requiresObservable_ = void 0;
    this.observing_ = [];
    this.newObserving_ = [];
    this.dependenciesState_ = IDerivationState_.NOT_TRACKING_;
    this.diffValue_ = 0;
    this.runId_ = 0;
    this.unboundDepsCount_ = 0;
    this.isDisposed_ = false;
    this.isScheduled_ = false;
    this.isTrackPending_ = false;
    this.isRunning_ = false;
    this.isTracing_ = TraceMode.NONE;
    this.name_ = name_;
    this.onInvalidate_ = onInvalidate_;
    this.errorHandler_ = errorHandler_;
    this.requiresObservable_ = requiresObservable_;
  }

  var _proto = Reaction.prototype;

  _proto.onBecomeStale_ = function onBecomeStale_() {
    this.schedule_();
  };

  _proto.schedule_ = function schedule_() {
    if (!this.isScheduled_) {
      this.isScheduled_ = true;
      globalState.pendingReactions.push(this);
      runReactions();
    }
  };

  _proto.isScheduled = function isScheduled() {
    return this.isScheduled_;
  }
  /**
   * internal, use schedule() if you intend to kick off a reaction
   */
  ;

  _proto.runReaction_ = function runReaction_() {
    if (!this.isDisposed_) {
      startBatch();
      this.isScheduled_ = false;
      var prev = globalState.trackingContext;
      globalState.trackingContext = this;

      if (shouldCompute(this)) {
        this.isTrackPending_ = true;

        try {
          this.onInvalidate_();

          if (false) {}
        } catch (e) {
          this.reportExceptionInDerivation_(e);
        }
      }

      globalState.trackingContext = prev;
      endBatch();
    }
  };

  _proto.track = function track(fn) {
    if (this.isDisposed_) {
      return; // console.warn("Reaction already disposed") // Note: Not a warning / error in mobx 4 either
    }

    startBatch();
    var notify = isSpyEnabled();
    var startTime;

    if (false) {}

    this.isRunning_ = true;
    var prevReaction = globalState.trackingContext; // reactions could create reactions...

    globalState.trackingContext = this;
    var result = trackDerivedFunction(this, fn, undefined);
    globalState.trackingContext = prevReaction;
    this.isRunning_ = false;
    this.isTrackPending_ = false;

    if (this.isDisposed_) {
      // disposed during last run. Clean up everything that was bound after the dispose call.
      clearObserving(this);
    }

    if (isCaughtException(result)) this.reportExceptionInDerivation_(result.cause);

    if (false) {}

    endBatch();
  };

  _proto.reportExceptionInDerivation_ = function reportExceptionInDerivation_(error) {
    var _this = this;

    if (this.errorHandler_) {
      this.errorHandler_(error, this);
      return;
    }

    if (globalState.disableErrorBoundaries) throw error;
    var message =  false ? 0 : "[mobx] uncaught error in '" + this + "'";

    if (!globalState.suppressReactionErrors) {
      console.error(message, error);
      /** If debugging brought you here, please, read the above message :-). Tnx! */
    } else if (false) {} // prettier-ignore


    if (false) {}

    globalState.globalReactionErrorHandlers.forEach(function (f) {
      return f(error, _this);
    });
  };

  _proto.dispose = function dispose() {
    if (!this.isDisposed_) {
      this.isDisposed_ = true;

      if (!this.isRunning_) {
        // if disposed while running, clean up later. Maybe not optimal, but rare case
        startBatch();
        clearObserving(this);
        endBatch();
      }
    }
  };

  _proto.getDisposer_ = function getDisposer_() {
    var r = this.dispose.bind(this);
    r[$mobx] = this;
    return r;
  };

  _proto.toString = function toString() {
    return "Reaction[" + this.name_ + "]";
  };

  _proto.trace = function trace$1(enterBreakPoint) {
    if (enterBreakPoint === void 0) {
      enterBreakPoint = false;
    }

    trace(this, enterBreakPoint);
  };

  return Reaction;
}();
function onReactionError(handler) {
  globalState.globalReactionErrorHandlers.push(handler);
  return function () {
    var idx = globalState.globalReactionErrorHandlers.indexOf(handler);
    if (idx >= 0) globalState.globalReactionErrorHandlers.splice(idx, 1);
  };
}
/**
 * Magic number alert!
 * Defines within how many times a reaction is allowed to re-trigger itself
 * until it is assumed that this is gonna be a never ending loop...
 */

var MAX_REACTION_ITERATIONS = 100;

var reactionScheduler = function reactionScheduler(f) {
  return f();
};

function runReactions() {
  // Trampolining, if runReactions are already running, new reactions will be picked up
  if (globalState.inBatch > 0 || globalState.isRunningReactions) return;
  reactionScheduler(runReactionsHelper);
}

function runReactionsHelper() {
  globalState.isRunningReactions = true;
  var allReactions = globalState.pendingReactions;
  var iterations = 0; // While running reactions, new reactions might be triggered.
  // Hence we work with two variables and check whether
  // we converge to no remaining reactions after a while.

  while (allReactions.length > 0) {
    if (++iterations === MAX_REACTION_ITERATIONS) {
      console.error( false ? 0 : "[mobx] cycle in reaction: " + allReactions[0]);
      allReactions.splice(0); // clear reactions
    }

    var remainingReactions = allReactions.splice(0);

    for (var i = 0, l = remainingReactions.length; i < l; i++) {
      remainingReactions[i].runReaction_();
    }
  }

  globalState.isRunningReactions = false;
}

var isReaction = /*#__PURE__*/createInstanceofPredicate("Reaction", Reaction);
function setReactionScheduler(fn) {
  var baseScheduler = reactionScheduler;

  reactionScheduler = function reactionScheduler(f) {
    return fn(function () {
      return baseScheduler(f);
    });
  };
}

function isSpyEnabled() {
  return  false && 0;
}
function spyReport(event) {
  if (true) return; // dead code elimination can do the rest

  if (!globalState.spyListeners.length) return;
  var listeners = globalState.spyListeners;

  for (var i = 0, l = listeners.length; i < l; i++) {
    listeners[i](event);
  }
}
function spyReportStart(event) {
  if (true) return;

  var change = _extends({}, event, {
    spyReportStart: true
  });

  spyReport(change);
}
var END_EVENT = {
  type: "report-end",
  spyReportEnd: true
};
function spyReportEnd(change) {
  if (true) return;
  if (change) spyReport(_extends({}, change, {
    type: "report-end",
    spyReportEnd: true
  }));else spyReport(END_EVENT);
}
function spy(listener) {
  if (true) {
    console.warn("[mobx.spy] Is a no-op in production builds");
    return function () {};
  } else {}
}

var ACTION = "action";
var ACTION_BOUND = "action.bound";
var AUTOACTION = "autoAction";
var AUTOACTION_BOUND = "autoAction.bound";
var DEFAULT_ACTION_NAME = "<unnamed action>";
var actionAnnotation = /*#__PURE__*/createActionAnnotation(ACTION);
var actionBoundAnnotation = /*#__PURE__*/createActionAnnotation(ACTION_BOUND, {
  bound: true
});
var autoActionAnnotation = /*#__PURE__*/createActionAnnotation(AUTOACTION, {
  autoAction: true
});
var autoActionBoundAnnotation = /*#__PURE__*/createActionAnnotation(AUTOACTION_BOUND, {
  autoAction: true,
  bound: true
});

function createActionFactory(autoAction) {
  var res = function action(arg1, arg2) {
    // action(fn() {})
    if (isFunction(arg1)) return createAction(arg1.name || DEFAULT_ACTION_NAME, arg1, autoAction); // action("name", fn() {})

    if (isFunction(arg2)) return createAction(arg1, arg2, autoAction); // @action

    if (isStringish(arg2)) {
      return storeAnnotation(arg1, arg2, autoAction ? autoActionAnnotation : actionAnnotation);
    } // action("name") & @action("name")


    if (isStringish(arg1)) {
      return createDecoratorAnnotation(createActionAnnotation(autoAction ? AUTOACTION : ACTION, {
        name: arg1,
        autoAction: autoAction
      }));
    }

    if (false) {}
  };

  return res;
}

var action = /*#__PURE__*/createActionFactory(false);
Object.assign(action, actionAnnotation);
var autoAction = /*#__PURE__*/createActionFactory(true);
Object.assign(autoAction, autoActionAnnotation);
action.bound = /*#__PURE__*/createDecoratorAnnotation(actionBoundAnnotation);
autoAction.bound = /*#__PURE__*/createDecoratorAnnotation(autoActionBoundAnnotation);
function mobx_esm_runInAction(fn) {
  return executeAction(fn.name || DEFAULT_ACTION_NAME, false, fn, this, undefined);
}
function isAction(thing) {
  return isFunction(thing) && thing.isMobxAction === true;
}

/**
 * Creates a named reactive view and keeps it alive, so that the view is always
 * updated if one of the dependencies changes, even when the view is not further used by something else.
 * @param view The reactive view
 * @returns disposer function, which can be used to stop the view from being updated in the future.
 */

function autorun(view, opts) {
  var _opts$name, _opts;

  if (opts === void 0) {
    opts = EMPTY_OBJECT;
  }

  if (false) {}

  var name = (_opts$name = (_opts = opts) == null ? void 0 : _opts.name) != null ? _opts$name :  false ? 0 : "Autorun";
  var runSync = !opts.scheduler && !opts.delay;
  var reaction;

  if (runSync) {
    // normal autorun
    reaction = new Reaction(name, function () {
      this.track(reactionRunner);
    }, opts.onError, opts.requiresObservable);
  } else {
    var scheduler = createSchedulerFromOptions(opts); // debounced autorun

    var isScheduled = false;
    reaction = new Reaction(name, function () {
      if (!isScheduled) {
        isScheduled = true;
        scheduler(function () {
          isScheduled = false;
          if (!reaction.isDisposed_) reaction.track(reactionRunner);
        });
      }
    }, opts.onError, opts.requiresObservable);
  }

  function reactionRunner() {
    view(reaction);
  }

  reaction.schedule_();
  return reaction.getDisposer_();
}

var run = function run(f) {
  return f();
};

function createSchedulerFromOptions(opts) {
  return opts.scheduler ? opts.scheduler : opts.delay ? function (f) {
    return setTimeout(f, opts.delay);
  } : run;
}

function reaction(expression, effect, opts) {
  var _opts$name2;

  if (opts === void 0) {
    opts = EMPTY_OBJECT;
  }

  if (false) {}

  var name = (_opts$name2 = opts.name) != null ? _opts$name2 :  false ? 0 : "Reaction";
  var effectAction = action(name, opts.onError ? wrapErrorHandler(opts.onError, effect) : effect);
  var runSync = !opts.scheduler && !opts.delay;
  var scheduler = createSchedulerFromOptions(opts);
  var firstTime = true;
  var isScheduled = false;
  var value;
  var oldValue = undefined; // only an issue with fireImmediately

  var equals = opts.compareStructural ? comparer.structural : opts.equals || comparer["default"];
  var r = new Reaction(name, function () {
    if (firstTime || runSync) {
      reactionRunner();
    } else if (!isScheduled) {
      isScheduled = true;
      scheduler(reactionRunner);
    }
  }, opts.onError, opts.requiresObservable);

  function reactionRunner() {
    isScheduled = false;
    if (r.isDisposed_) return;
    var changed = false;
    r.track(function () {
      var nextValue = allowStateChanges(false, function () {
        return expression(r);
      });
      changed = firstTime || !equals(value, nextValue);
      oldValue = value;
      value = nextValue;
    });
    if (firstTime && opts.fireImmediately) effectAction(value, oldValue, r);else if (!firstTime && changed) effectAction(value, oldValue, r);
    firstTime = false;
  }

  r.schedule_();
  return r.getDisposer_();
}

function wrapErrorHandler(errorHandler, baseFn) {
  return function () {
    try {
      return baseFn.apply(this, arguments);
    } catch (e) {
      errorHandler.call(this, e);
    }
  };
}

var ON_BECOME_OBSERVED = "onBO";
var ON_BECOME_UNOBSERVED = "onBUO";
function onBecomeObserved(thing, arg2, arg3) {
  return interceptHook(ON_BECOME_OBSERVED, thing, arg2, arg3);
}
function onBecomeUnobserved(thing, arg2, arg3) {
  return interceptHook(ON_BECOME_UNOBSERVED, thing, arg2, arg3);
}

function interceptHook(hook, thing, arg2, arg3) {
  var atom = typeof arg3 === "function" ? getAtom(thing, arg2) : getAtom(thing);
  var cb = isFunction(arg3) ? arg3 : arg2;
  var listenersKey = hook + "L";

  if (atom[listenersKey]) {
    atom[listenersKey].add(cb);
  } else {
    atom[listenersKey] = new Set([cb]);
  }

  return function () {
    var hookListeners = atom[listenersKey];

    if (hookListeners) {
      hookListeners["delete"](cb);

      if (hookListeners.size === 0) {
        delete atom[listenersKey];
      }
    }
  };
}

var NEVER = "never";
var ALWAYS = "always";
var OBSERVED = "observed"; // const IF_AVAILABLE = "ifavailable"

function configure(options) {
  if (options.isolateGlobalState === true) {
    isolateGlobalState();
  }

  var useProxies = options.useProxies,
      enforceActions = options.enforceActions;

  if (useProxies !== undefined) {
    globalState.useProxies = useProxies === ALWAYS ? true : useProxies === NEVER ? false : typeof Proxy !== "undefined";
  }

  if (useProxies === "ifavailable") globalState.verifyProxies = true;

  if (enforceActions !== undefined) {
    var ea = enforceActions === ALWAYS ? ALWAYS : enforceActions === OBSERVED;
    globalState.enforceActions = ea;
    globalState.allowStateChanges = ea === true || ea === ALWAYS ? false : true;
  }
  ["computedRequiresReaction", "reactionRequiresObservable", "observableRequiresReaction", "disableErrorBoundaries", "safeDescriptors"].forEach(function (key) {
    if (key in options) globalState[key] = !!options[key];
  });
  globalState.allowStateReads = !globalState.observableRequiresReaction;

  if (false) {}

  if (options.reactionScheduler) {
    setReactionScheduler(options.reactionScheduler);
  }
}

function extendObservable(target, properties, annotations, options) {
  if (false) {} // Pull descriptors first, so we don't have to deal with props added by administration ($mobx)


  var descriptors = getOwnPropertyDescriptors(properties);
  var adm = asObservableObject(target, options)[$mobx];
  startBatch();

  try {
    ownKeys(descriptors).forEach(function (key) {
      adm.extend_(key, descriptors[key], // must pass "undefined" for { key: undefined }
      !annotations ? true : key in annotations ? annotations[key] : true);
    });
  } finally {
    endBatch();
  }

  return target;
}

function getDependencyTree(thing, property) {
  return nodeToDependencyTree(getAtom(thing, property));
}

function nodeToDependencyTree(node) {
  var result = {
    name: node.name_
  };
  if (node.observing_ && node.observing_.length > 0) result.dependencies = unique(node.observing_).map(nodeToDependencyTree);
  return result;
}

function getObserverTree(thing, property) {
  return nodeToObserverTree(getAtom(thing, property));
}

function nodeToObserverTree(node) {
  var result = {
    name: node.name_
  };
  if (hasObservers(node)) result.observers = Array.from(getObservers(node)).map(nodeToObserverTree);
  return result;
}

function unique(list) {
  return Array.from(new Set(list));
}

var generatorId = 0;
function FlowCancellationError() {
  this.message = "FLOW_CANCELLED";
}
FlowCancellationError.prototype = /*#__PURE__*/Object.create(Error.prototype);
function isFlowCancellationError(error) {
  return error instanceof FlowCancellationError;
}
var flowAnnotation = /*#__PURE__*/createFlowAnnotation("flow");
var flowBoundAnnotation = /*#__PURE__*/createFlowAnnotation("flow.bound", {
  bound: true
});
var flow = /*#__PURE__*/Object.assign(function flow(arg1, arg2) {
  // @flow
  if (isStringish(arg2)) {
    return storeAnnotation(arg1, arg2, flowAnnotation);
  } // flow(fn)


  if (false) {}
  var generator = arg1;
  var name = generator.name || "<unnamed flow>"; // Implementation based on https://github.com/tj/co/blob/master/index.js

  var res = function res() {
    var ctx = this;
    var args = arguments;
    var runId = ++generatorId;
    var gen = action(name + " - runid: " + runId + " - init", generator).apply(ctx, args);
    var rejector;
    var pendingPromise = undefined;
    var promise = new Promise(function (resolve, reject) {
      var stepId = 0;
      rejector = reject;

      function onFulfilled(res) {
        pendingPromise = undefined;
        var ret;

        try {
          ret = action(name + " - runid: " + runId + " - yield " + stepId++, gen.next).call(gen, res);
        } catch (e) {
          return reject(e);
        }

        next(ret);
      }

      function onRejected(err) {
        pendingPromise = undefined;
        var ret;

        try {
          ret = action(name + " - runid: " + runId + " - yield " + stepId++, gen["throw"]).call(gen, err);
        } catch (e) {
          return reject(e);
        }

        next(ret);
      }

      function next(ret) {
        if (isFunction(ret == null ? void 0 : ret.then)) {
          // an async iterator
          ret.then(next, reject);
          return;
        }

        if (ret.done) return resolve(ret.value);
        pendingPromise = Promise.resolve(ret.value);
        return pendingPromise.then(onFulfilled, onRejected);
      }

      onFulfilled(undefined); // kick off the process
    });
    promise.cancel = action(name + " - runid: " + runId + " - cancel", function () {
      try {
        if (pendingPromise) cancelPromise(pendingPromise); // Finally block can return (or yield) stuff..

        var _res = gen["return"](undefined); // eat anything that promise would do, it's cancelled!


        var yieldedPromise = Promise.resolve(_res.value);
        yieldedPromise.then(noop, noop);
        cancelPromise(yieldedPromise); // maybe it can be cancelled :)
        // reject our original promise

        rejector(new FlowCancellationError());
      } catch (e) {
        rejector(e); // there could be a throwing finally block
      }
    });
    return promise;
  };

  res.isMobXFlow = true;
  return res;
}, flowAnnotation);
flow.bound = /*#__PURE__*/createDecoratorAnnotation(flowBoundAnnotation);

function cancelPromise(promise) {
  if (isFunction(promise.cancel)) promise.cancel();
}

function flowResult(result) {
  return result; // just tricking TypeScript :)
}
function isFlow(fn) {
  return (fn == null ? void 0 : fn.isMobXFlow) === true;
}

function interceptReads(thing, propOrHandler, handler) {
  var target;

  if (isObservableMap(thing) || isObservableArray(thing) || isObservableValue(thing)) {
    target = getAdministration(thing);
  } else if (isObservableObject(thing)) {
    if (false) {}
    target = getAdministration(thing, propOrHandler);
  } else if (false) {}

  if (false) {}
  target.dehancer = typeof propOrHandler === "function" ? propOrHandler : handler;
  return function () {
    target.dehancer = undefined;
  };
}

function intercept(thing, propOrHandler, handler) {
  if (isFunction(handler)) return interceptProperty(thing, propOrHandler, handler);else return interceptInterceptable(thing, propOrHandler);
}

function interceptInterceptable(thing, handler) {
  return getAdministration(thing).intercept_(handler);
}

function interceptProperty(thing, property, handler) {
  return getAdministration(thing, property).intercept_(handler);
}

function _isComputed(value, property) {
  if (property !== undefined) {
    if (isObservableObject(value) === false) return false;
    if (!value[$mobx].values_.has(property)) return false;
    var atom = getAtom(value, property);
    return isComputedValue(atom);
  }

  return isComputedValue(value);
}
function isComputed(value) {
  if (false) {}
  return _isComputed(value);
}
function isComputedProp(value, propName) {
  if (false) {}
  return _isComputed(value, propName);
}

function _isObservable(value, property) {
  if (!value) return false;

  if (property !== undefined) {
    if (false) {}

    if (isObservableObject(value)) {
      return value[$mobx].values_.has(property);
    }

    return false;
  } // For first check, see #701


  return isObservableObject(value) || !!value[$mobx] || isAtom(value) || isReaction(value) || isComputedValue(value);
}

function isObservable(value) {
  if (false) {}
  return _isObservable(value);
}
function isObservableProp(value, propName) {
  if (false) {}
  return _isObservable(value, propName);
}

function keys(obj) {
  if (isObservableObject(obj)) {
    return obj[$mobx].keys_();
  }

  if (isObservableMap(obj) || isObservableSet(obj)) {
    return Array.from(obj.keys());
  }

  if (isObservableArray(obj)) {
    return obj.map(function (_, index) {
      return index;
    });
  }

  die(5);
}
function values(obj) {
  if (isObservableObject(obj)) {
    return keys(obj).map(function (key) {
      return obj[key];
    });
  }

  if (isObservableMap(obj)) {
    return keys(obj).map(function (key) {
      return obj.get(key);
    });
  }

  if (isObservableSet(obj)) {
    return Array.from(obj.values());
  }

  if (isObservableArray(obj)) {
    return obj.slice();
  }

  die(6);
}
function entries(obj) {
  if (isObservableObject(obj)) {
    return keys(obj).map(function (key) {
      return [key, obj[key]];
    });
  }

  if (isObservableMap(obj)) {
    return keys(obj).map(function (key) {
      return [key, obj.get(key)];
    });
  }

  if (isObservableSet(obj)) {
    return Array.from(obj.entries());
  }

  if (isObservableArray(obj)) {
    return obj.map(function (key, index) {
      return [index, key];
    });
  }

  die(7);
}
function set(obj, key, value) {
  if (arguments.length === 2 && !isObservableSet(obj)) {
    startBatch();
    var _values = key;

    try {
      for (var _key in _values) {
        set(obj, _key, _values[_key]);
      }
    } finally {
      endBatch();
    }

    return;
  }

  if (isObservableObject(obj)) {
    obj[$mobx].set_(key, value);
  } else if (isObservableMap(obj)) {
    obj.set(key, value);
  } else if (isObservableSet(obj)) {
    obj.add(key);
  } else if (isObservableArray(obj)) {
    if (typeof key !== "number") key = parseInt(key, 10);
    if (key < 0) die("Invalid index: '" + key + "'");
    startBatch();
    if (key >= obj.length) obj.length = key + 1;
    obj[key] = value;
    endBatch();
  } else die(8);
}
function remove(obj, key) {
  if (isObservableObject(obj)) {
    obj[$mobx].delete_(key);
  } else if (isObservableMap(obj)) {
    obj["delete"](key);
  } else if (isObservableSet(obj)) {
    obj["delete"](key);
  } else if (isObservableArray(obj)) {
    if (typeof key !== "number") key = parseInt(key, 10);
    obj.splice(key, 1);
  } else {
    die(9);
  }
}
function has(obj, key) {
  if (isObservableObject(obj)) {
    return obj[$mobx].has_(key);
  } else if (isObservableMap(obj)) {
    return obj.has(key);
  } else if (isObservableSet(obj)) {
    return obj.has(key);
  } else if (isObservableArray(obj)) {
    return key >= 0 && key < obj.length;
  }

  die(10);
}
function get(obj, key) {
  if (!has(obj, key)) return undefined;

  if (isObservableObject(obj)) {
    return obj[$mobx].get_(key);
  } else if (isObservableMap(obj)) {
    return obj.get(key);
  } else if (isObservableArray(obj)) {
    return obj[key];
  }

  die(11);
}
function apiDefineProperty(obj, key, descriptor) {
  if (isObservableObject(obj)) {
    return obj[$mobx].defineProperty_(key, descriptor);
  }

  die(39);
}
function apiOwnKeys(obj) {
  if (isObservableObject(obj)) {
    return obj[$mobx].ownKeys_();
  }

  die(38);
}

function observe(thing, propOrCb, cbOrFire, fireImmediately) {
  if (isFunction(cbOrFire)) return observeObservableProperty(thing, propOrCb, cbOrFire, fireImmediately);else return observeObservable(thing, propOrCb, cbOrFire);
}

function observeObservable(thing, listener, fireImmediately) {
  return getAdministration(thing).observe_(listener, fireImmediately);
}

function observeObservableProperty(thing, property, listener, fireImmediately) {
  return getAdministration(thing, property).observe_(listener, fireImmediately);
}

function cache(map, key, value) {
  map.set(key, value);
  return value;
}

function toJSHelper(source, __alreadySeen) {
  if (source == null || typeof source !== "object" || source instanceof Date || !isObservable(source)) return source;
  if (isObservableValue(source) || isComputedValue(source)) return toJSHelper(source.get(), __alreadySeen);

  if (__alreadySeen.has(source)) {
    return __alreadySeen.get(source);
  }

  if (isObservableArray(source)) {
    var res = cache(__alreadySeen, source, new Array(source.length));
    source.forEach(function (value, idx) {
      res[idx] = toJSHelper(value, __alreadySeen);
    });
    return res;
  }

  if (isObservableSet(source)) {
    var _res = cache(__alreadySeen, source, new Set());

    source.forEach(function (value) {
      _res.add(toJSHelper(value, __alreadySeen));
    });
    return _res;
  }

  if (isObservableMap(source)) {
    var _res2 = cache(__alreadySeen, source, new Map());

    source.forEach(function (value, key) {
      _res2.set(key, toJSHelper(value, __alreadySeen));
    });
    return _res2;
  } else {
    // must be observable object
    var _res3 = cache(__alreadySeen, source, {});

    apiOwnKeys(source).forEach(function (key) {
      if (objectPrototype.propertyIsEnumerable.call(source, key)) {
        _res3[key] = toJSHelper(source[key], __alreadySeen);
      }
    });
    return _res3;
  }
}
/**
 * Basically, a deep clone, so that no reactive property will exist anymore.
 */


function toJS(source, options) {
  if (false) {}
  return toJSHelper(source, new Map());
}

function trace() {
  if (true) die("trace() is not available in production builds");
  var enterBreakPoint = false;

  for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
    args[_key] = arguments[_key];
  }

  if (typeof args[args.length - 1] === "boolean") enterBreakPoint = args.pop();
  var derivation = getAtomFromArgs(args);

  if (!derivation) {
    return die("'trace(break?)' can only be used inside a tracked computed value or a Reaction. Consider passing in the computed value or reaction explicitly");
  }

  if (derivation.isTracing_ === TraceMode.NONE) {
    console.log("[mobx.trace] '" + derivation.name_ + "' tracing enabled");
  }

  derivation.isTracing_ = enterBreakPoint ? TraceMode.BREAK : TraceMode.LOG;
}

function getAtomFromArgs(args) {
  switch (args.length) {
    case 0:
      return globalState.trackingDerivation;

    case 1:
      return getAtom(args[0]);

    case 2:
      return getAtom(args[0], args[1]);
  }
}

/**
 * During a transaction no views are updated until the end of the transaction.
 * The transaction will be run synchronously nonetheless.
 *
 * @param action a function that updates some reactive state
 * @returns any value that was returned by the 'action' parameter.
 */

function transaction(action, thisArg) {
  if (thisArg === void 0) {
    thisArg = undefined;
  }

  startBatch();

  try {
    return action.apply(thisArg);
  } finally {
    endBatch();
  }
}

function when(predicate, arg1, arg2) {
  if (arguments.length === 1 || arg1 && typeof arg1 === "object") return whenPromise(predicate, arg1);
  return _when(predicate, arg1, arg2 || {});
}

function _when(predicate, effect, opts) {
  var timeoutHandle;

  if (typeof opts.timeout === "number") {
    var error = new Error("WHEN_TIMEOUT");
    timeoutHandle = setTimeout(function () {
      if (!disposer[$mobx].isDisposed_) {
        disposer();
        if (opts.onError) opts.onError(error);else throw error;
      }
    }, opts.timeout);
  }

  opts.name =  false ? 0 : "When";
  var effectAction = createAction( false ? 0 : "When-effect", effect); // eslint-disable-next-line

  var disposer = autorun(function (r) {
    // predicate should not change state
    var cond = allowStateChanges(false, predicate);

    if (cond) {
      r.dispose();
      if (timeoutHandle) clearTimeout(timeoutHandle);
      effectAction();
    }
  }, opts);
  return disposer;
}

function whenPromise(predicate, opts) {
  if (false) {}
  var cancel;
  var res = new Promise(function (resolve, reject) {
    var disposer = _when(predicate, resolve, _extends({}, opts, {
      onError: reject
    }));

    cancel = function cancel() {
      disposer();
      reject("WHEN_CANCELLED");
    };
  });
  res.cancel = cancel;
  return res;
}

function getAdm(target) {
  return target[$mobx];
} // Optimization: we don't need the intermediate objects and could have a completely custom administration for DynamicObjects,
// and skip either the internal values map, or the base object with its property descriptors!


var objectProxyTraps = {
  has: function has(target, name) {
    if (false) {}
    return getAdm(target).has_(name);
  },
  get: function get(target, name) {
    return getAdm(target).get_(name);
  },
  set: function set(target, name, value) {
    var _getAdm$set_;

    if (!isStringish(name)) return false;

    if (false) {} // null (intercepted) -> true (success)


    return (_getAdm$set_ = getAdm(target).set_(name, value, true)) != null ? _getAdm$set_ : true;
  },
  deleteProperty: function deleteProperty(target, name) {
    var _getAdm$delete_;

    if (false) {}

    if (!isStringish(name)) return false; // null (intercepted) -> true (success)

    return (_getAdm$delete_ = getAdm(target).delete_(name, true)) != null ? _getAdm$delete_ : true;
  },
  defineProperty: function defineProperty(target, name, descriptor) {
    var _getAdm$definePropert;

    if (false) {} // null (intercepted) -> true (success)


    return (_getAdm$definePropert = getAdm(target).defineProperty_(name, descriptor)) != null ? _getAdm$definePropert : true;
  },
  ownKeys: function ownKeys(target) {
    if (false) {}
    return getAdm(target).ownKeys_();
  },
  preventExtensions: function preventExtensions(target) {
    die(13);
  }
};
function asDynamicObservableObject(target, options) {
  var _target$$mobx, _target$$mobx$proxy_;

  assertProxies();
  target = asObservableObject(target, options);
  return (_target$$mobx$proxy_ = (_target$$mobx = target[$mobx]).proxy_) != null ? _target$$mobx$proxy_ : _target$$mobx.proxy_ = new Proxy(target, objectProxyTraps);
}

function hasInterceptors(interceptable) {
  return interceptable.interceptors_ !== undefined && interceptable.interceptors_.length > 0;
}
function registerInterceptor(interceptable, handler) {
  var interceptors = interceptable.interceptors_ || (interceptable.interceptors_ = []);
  interceptors.push(handler);
  return once(function () {
    var idx = interceptors.indexOf(handler);
    if (idx !== -1) interceptors.splice(idx, 1);
  });
}
function interceptChange(interceptable, change) {
  var prevU = untrackedStart();

  try {
    // Interceptor can modify the array, copy it to avoid concurrent modification, see #1950
    var interceptors = [].concat(interceptable.interceptors_ || []);

    for (var i = 0, l = interceptors.length; i < l; i++) {
      change = interceptors[i](change);
      if (change && !change.type) die(14);
      if (!change) break;
    }

    return change;
  } finally {
    untrackedEnd(prevU);
  }
}

function hasListeners(listenable) {
  return listenable.changeListeners_ !== undefined && listenable.changeListeners_.length > 0;
}
function registerListener(listenable, handler) {
  var listeners = listenable.changeListeners_ || (listenable.changeListeners_ = []);
  listeners.push(handler);
  return once(function () {
    var idx = listeners.indexOf(handler);
    if (idx !== -1) listeners.splice(idx, 1);
  });
}
function notifyListeners(listenable, change) {
  var prevU = untrackedStart();
  var listeners = listenable.changeListeners_;
  if (!listeners) return;
  listeners = listeners.slice();

  for (var i = 0, l = listeners.length; i < l; i++) {
    listeners[i](change);
  }

  untrackedEnd(prevU);
}

function makeObservable(target, annotations, options) {
  var adm = asObservableObject(target, options)[$mobx];
  startBatch();

  try {
    var _annotations;

    // Default to decorators
    (_annotations = annotations) != null ? _annotations : annotations = collectStoredAnnotations(target); // Annotate

    ownKeys(annotations).forEach(function (key) {
      return adm.make_(key, annotations[key]);
    });
  } finally {
    endBatch();
  }

  return target;
} // proto[keysSymbol] = new Set<PropertyKey>()

var keysSymbol = /*#__PURE__*/(/* unused pure expression or super */ null && (Symbol("mobx-keys")));
function makeAutoObservable(target, overrides, options) {
  if (false) {} // Optimization: avoid visiting protos
  // Assumes that annotation.make_/.extend_ works the same for plain objects


  if (isPlainObject(target)) {
    return extendObservable(target, target, overrides, options);
  }

  var adm = asObservableObject(target, options)[$mobx]; // Optimization: cache keys on proto
  // Assumes makeAutoObservable can be called only once per object and can't be used in subclass

  if (!target[keysSymbol]) {
    var proto = Object.getPrototypeOf(target);
    var keys = new Set([].concat(ownKeys(target), ownKeys(proto)));
    keys["delete"]("constructor");
    keys["delete"]($mobx);
    addHiddenProp(proto, keysSymbol, keys);
  }

  startBatch();

  try {
    target[keysSymbol].forEach(function (key) {
      return adm.make_(key, // must pass "undefined" for { key: undefined }
      !overrides ? true : key in overrides ? overrides[key] : true);
    });
  } finally {
    endBatch();
  }

  return target;
}

var SPLICE = "splice";
var UPDATE = "update";
var MAX_SPLICE_SIZE = 10000; // See e.g. https://github.com/mobxjs/mobx/issues/859

var arrayTraps = {
  get: function get(target, name) {
    var adm = target[$mobx];
    if (name === $mobx) return adm;
    if (name === "length") return adm.getArrayLength_();

    if (typeof name === "string" && !isNaN(name)) {
      return adm.get_(parseInt(name));
    }

    if (hasProp(arrayExtensions, name)) {
      return arrayExtensions[name];
    }

    return target[name];
  },
  set: function set(target, name, value) {
    var adm = target[$mobx];

    if (name === "length") {
      adm.setArrayLength_(value);
    }

    if (typeof name === "symbol" || isNaN(name)) {
      target[name] = value;
    } else {
      // numeric string
      adm.set_(parseInt(name), value);
    }

    return true;
  },
  preventExtensions: function preventExtensions() {
    die(15);
  }
};
var ObservableArrayAdministration = /*#__PURE__*/function () {
  // this is the prop that gets proxied, so can't replace it!
  function ObservableArrayAdministration(name, enhancer, owned_, legacyMode_) {
    if (name === void 0) {
      name =  false ? 0 : "ObservableArray";
    }

    this.owned_ = void 0;
    this.legacyMode_ = void 0;
    this.atom_ = void 0;
    this.values_ = [];
    this.interceptors_ = void 0;
    this.changeListeners_ = void 0;
    this.enhancer_ = void 0;
    this.dehancer = void 0;
    this.proxy_ = void 0;
    this.lastKnownLength_ = 0;
    this.owned_ = owned_;
    this.legacyMode_ = legacyMode_;
    this.atom_ = new Atom(name);

    this.enhancer_ = function (newV, oldV) {
      return enhancer(newV, oldV,  false ? 0 : "ObservableArray[..]");
    };
  }

  var _proto = ObservableArrayAdministration.prototype;

  _proto.dehanceValue_ = function dehanceValue_(value) {
    if (this.dehancer !== undefined) return this.dehancer(value);
    return value;
  };

  _proto.dehanceValues_ = function dehanceValues_(values) {
    if (this.dehancer !== undefined && values.length > 0) return values.map(this.dehancer);
    return values;
  };

  _proto.intercept_ = function intercept_(handler) {
    return registerInterceptor(this, handler);
  };

  _proto.observe_ = function observe_(listener, fireImmediately) {
    if (fireImmediately === void 0) {
      fireImmediately = false;
    }

    if (fireImmediately) {
      listener({
        observableKind: "array",
        object: this.proxy_,
        debugObjectName: this.atom_.name_,
        type: "splice",
        index: 0,
        added: this.values_.slice(),
        addedCount: this.values_.length,
        removed: [],
        removedCount: 0
      });
    }

    return registerListener(this, listener);
  };

  _proto.getArrayLength_ = function getArrayLength_() {
    this.atom_.reportObserved();
    return this.values_.length;
  };

  _proto.setArrayLength_ = function setArrayLength_(newLength) {
    if (typeof newLength !== "number" || newLength < 0) die("Out of range: " + newLength);
    var currentLength = this.values_.length;
    if (newLength === currentLength) return;else if (newLength > currentLength) {
      var newItems = new Array(newLength - currentLength);

      for (var i = 0; i < newLength - currentLength; i++) {
        newItems[i] = undefined;
      } // No Array.fill everywhere...


      this.spliceWithArray_(currentLength, 0, newItems);
    } else this.spliceWithArray_(newLength, currentLength - newLength);
  };

  _proto.updateArrayLength_ = function updateArrayLength_(oldLength, delta) {
    if (oldLength !== this.lastKnownLength_) die(16);
    this.lastKnownLength_ += delta;
    if (this.legacyMode_ && delta > 0) reserveArrayBuffer(oldLength + delta + 1);
  };

  _proto.spliceWithArray_ = function spliceWithArray_(index, deleteCount, newItems) {
    var _this = this;

    checkIfStateModificationsAreAllowed(this.atom_);
    var length = this.values_.length;
    if (index === undefined) index = 0;else if (index > length) index = length;else if (index < 0) index = Math.max(0, length + index);
    if (arguments.length === 1) deleteCount = length - index;else if (deleteCount === undefined || deleteCount === null) deleteCount = 0;else deleteCount = Math.max(0, Math.min(deleteCount, length - index));
    if (newItems === undefined) newItems = EMPTY_ARRAY;

    if (hasInterceptors(this)) {
      var change = interceptChange(this, {
        object: this.proxy_,
        type: SPLICE,
        index: index,
        removedCount: deleteCount,
        added: newItems
      });
      if (!change) return EMPTY_ARRAY;
      deleteCount = change.removedCount;
      newItems = change.added;
    }

    newItems = newItems.length === 0 ? newItems : newItems.map(function (v) {
      return _this.enhancer_(v, undefined);
    });

    if (this.legacyMode_ || "production" !== "production") {
      var lengthDelta = newItems.length - deleteCount;
      this.updateArrayLength_(length, lengthDelta); // checks if internal array wasn't modified
    }

    var res = this.spliceItemsIntoValues_(index, deleteCount, newItems);
    if (deleteCount !== 0 || newItems.length !== 0) this.notifyArraySplice_(index, newItems, res);
    return this.dehanceValues_(res);
  };

  _proto.spliceItemsIntoValues_ = function spliceItemsIntoValues_(index, deleteCount, newItems) {
    if (newItems.length < MAX_SPLICE_SIZE) {
      var _this$values_;

      return (_this$values_ = this.values_).splice.apply(_this$values_, [index, deleteCount].concat(newItems));
    } else {
      var res = this.values_.slice(index, index + deleteCount);
      var oldItems = this.values_.slice(index + deleteCount);
      this.values_.length = index + newItems.length - deleteCount;

      for (var i = 0; i < newItems.length; i++) {
        this.values_[index + i] = newItems[i];
      }

      for (var _i = 0; _i < oldItems.length; _i++) {
        this.values_[index + newItems.length + _i] = oldItems[_i];
      }

      return res;
    }
  };

  _proto.notifyArrayChildUpdate_ = function notifyArrayChildUpdate_(index, newValue, oldValue) {
    var notifySpy = !this.owned_ && isSpyEnabled();
    var notify = hasListeners(this);
    var change = notify || notifySpy ? {
      observableKind: "array",
      object: this.proxy_,
      type: UPDATE,
      debugObjectName: this.atom_.name_,
      index: index,
      newValue: newValue,
      oldValue: oldValue
    } : null; // The reason why this is on right hand side here (and not above), is this way the uglifier will drop it, but it won't
    // cause any runtime overhead in development mode without NODE_ENV set, unless spying is enabled

    if (false) {}
    this.atom_.reportChanged();
    if (notify) notifyListeners(this, change);
    if (false) {}
  };

  _proto.notifyArraySplice_ = function notifyArraySplice_(index, added, removed) {
    var notifySpy = !this.owned_ && isSpyEnabled();
    var notify = hasListeners(this);
    var change = notify || notifySpy ? {
      observableKind: "array",
      object: this.proxy_,
      debugObjectName: this.atom_.name_,
      type: SPLICE,
      index: index,
      removed: removed,
      added: added,
      removedCount: removed.length,
      addedCount: added.length
    } : null;
    if (false) {}
    this.atom_.reportChanged(); // conform: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/observe

    if (notify) notifyListeners(this, change);
    if (false) {}
  };

  _proto.get_ = function get_(index) {
    if (index < this.values_.length) {
      this.atom_.reportObserved();
      return this.dehanceValue_(this.values_[index]);
    }

    console.warn( false ? 0 : "[mobx.array] Attempt to read an array index (" + index + ") that is out of bounds (" + this.values_.length + "). Please check length first. Out of bound indices will not be tracked by MobX");
  };

  _proto.set_ = function set_(index, newValue) {
    var values = this.values_;

    if (index < values.length) {
      // update at index in range
      checkIfStateModificationsAreAllowed(this.atom_);
      var oldValue = values[index];

      if (hasInterceptors(this)) {
        var change = interceptChange(this, {
          type: UPDATE,
          object: this.proxy_,
          index: index,
          newValue: newValue
        });
        if (!change) return;
        newValue = change.newValue;
      }

      newValue = this.enhancer_(newValue, oldValue);
      var changed = newValue !== oldValue;

      if (changed) {
        values[index] = newValue;
        this.notifyArrayChildUpdate_(index, newValue, oldValue);
      }
    } else if (index === values.length) {
      // add a new item
      this.spliceWithArray_(index, 0, [newValue]);
    } else {
      // out of bounds
      die(17, index, values.length);
    }
  };

  return ObservableArrayAdministration;
}();
function createObservableArray(initialValues, enhancer, name, owned) {
  if (name === void 0) {
    name =  false ? 0 : "ObservableArray";
  }

  if (owned === void 0) {
    owned = false;
  }

  assertProxies();
  var adm = new ObservableArrayAdministration(name, enhancer, owned, false);
  addHiddenFinalProp(adm.values_, $mobx, adm);
  var proxy = new Proxy(adm.values_, arrayTraps);
  adm.proxy_ = proxy;

  if (initialValues && initialValues.length) {
    var prev = allowStateChangesStart(true);
    adm.spliceWithArray_(0, 0, initialValues);
    allowStateChangesEnd(prev);
  }

  return proxy;
} // eslint-disable-next-line

var arrayExtensions = {
  clear: function clear() {
    return this.splice(0);
  },
  replace: function replace(newItems) {
    var adm = this[$mobx];
    return adm.spliceWithArray_(0, adm.values_.length, newItems);
  },
  // Used by JSON.stringify
  toJSON: function toJSON() {
    return this.slice();
  },

  /*
   * functions that do alter the internal structure of the array, (based on lib.es6.d.ts)
   * since these functions alter the inner structure of the array, the have side effects.
   * Because the have side effects, they should not be used in computed function,
   * and for that reason the do not call dependencyState.notifyObserved
   */
  splice: function splice(index, deleteCount) {
    for (var _len = arguments.length, newItems = new Array(_len > 2 ? _len - 2 : 0), _key = 2; _key < _len; _key++) {
      newItems[_key - 2] = arguments[_key];
    }

    var adm = this[$mobx];

    switch (arguments.length) {
      case 0:
        return [];

      case 1:
        return adm.spliceWithArray_(index);

      case 2:
        return adm.spliceWithArray_(index, deleteCount);
    }

    return adm.spliceWithArray_(index, deleteCount, newItems);
  },
  spliceWithArray: function spliceWithArray(index, deleteCount, newItems) {
    return this[$mobx].spliceWithArray_(index, deleteCount, newItems);
  },
  push: function push() {
    var adm = this[$mobx];

    for (var _len2 = arguments.length, items = new Array(_len2), _key2 = 0; _key2 < _len2; _key2++) {
      items[_key2] = arguments[_key2];
    }

    adm.spliceWithArray_(adm.values_.length, 0, items);
    return adm.values_.length;
  },
  pop: function pop() {
    return this.splice(Math.max(this[$mobx].values_.length - 1, 0), 1)[0];
  },
  shift: function shift() {
    return this.splice(0, 1)[0];
  },
  unshift: function unshift() {
    var adm = this[$mobx];

    for (var _len3 = arguments.length, items = new Array(_len3), _key3 = 0; _key3 < _len3; _key3++) {
      items[_key3] = arguments[_key3];
    }

    adm.spliceWithArray_(0, 0, items);
    return adm.values_.length;
  },
  reverse: function reverse() {
    // reverse by default mutates in place before returning the result
    // which makes it both a 'derivation' and a 'mutation'.
    if (globalState.trackingDerivation) {
      die(37, "reverse");
    }

    this.replace(this.slice().reverse());
    return this;
  },
  sort: function sort() {
    // sort by default mutates in place before returning the result
    // which goes against all good practices. Let's not change the array in place!
    if (globalState.trackingDerivation) {
      die(37, "sort");
    }

    var copy = this.slice();
    copy.sort.apply(copy, arguments);
    this.replace(copy);
    return this;
  },
  remove: function remove(value) {
    var adm = this[$mobx];
    var idx = adm.dehanceValues_(adm.values_).indexOf(value);

    if (idx > -1) {
      this.splice(idx, 1);
      return true;
    }

    return false;
  }
};
/**
 * Wrap function from prototype
 * Without this, everything works as well, but this works
 * faster as everything works on unproxied values
 */

addArrayExtension("concat", simpleFunc);
addArrayExtension("flat", simpleFunc);
addArrayExtension("includes", simpleFunc);
addArrayExtension("indexOf", simpleFunc);
addArrayExtension("join", simpleFunc);
addArrayExtension("lastIndexOf", simpleFunc);
addArrayExtension("slice", simpleFunc);
addArrayExtension("toString", simpleFunc);
addArrayExtension("toLocaleString", simpleFunc); // map

addArrayExtension("every", mapLikeFunc);
addArrayExtension("filter", mapLikeFunc);
addArrayExtension("find", mapLikeFunc);
addArrayExtension("findIndex", mapLikeFunc);
addArrayExtension("flatMap", mapLikeFunc);
addArrayExtension("forEach", mapLikeFunc);
addArrayExtension("map", mapLikeFunc);
addArrayExtension("some", mapLikeFunc); // reduce

addArrayExtension("reduce", reduceLikeFunc);
addArrayExtension("reduceRight", reduceLikeFunc);

function addArrayExtension(funcName, funcFactory) {
  if (typeof Array.prototype[funcName] === "function") {
    arrayExtensions[funcName] = funcFactory(funcName);
  }
} // Report and delegate to dehanced array


function simpleFunc(funcName) {
  return function () {
    var adm = this[$mobx];
    adm.atom_.reportObserved();
    var dehancedValues = adm.dehanceValues_(adm.values_);
    return dehancedValues[funcName].apply(dehancedValues, arguments);
  };
} // Make sure callbacks recieve correct array arg #2326


function mapLikeFunc(funcName) {
  return function (callback, thisArg) {
    var _this2 = this;

    var adm = this[$mobx];
    adm.atom_.reportObserved();
    var dehancedValues = adm.dehanceValues_(adm.values_);
    return dehancedValues[funcName](function (element, index) {
      return callback.call(thisArg, element, index, _this2);
    });
  };
} // Make sure callbacks recieve correct array arg #2326


function reduceLikeFunc(funcName) {
  return function () {
    var _this3 = this;

    var adm = this[$mobx];
    adm.atom_.reportObserved();
    var dehancedValues = adm.dehanceValues_(adm.values_); // #2432 - reduce behavior depends on arguments.length

    var callback = arguments[0];

    arguments[0] = function (accumulator, currentValue, index) {
      return callback(accumulator, currentValue, index, _this3);
    };

    return dehancedValues[funcName].apply(dehancedValues, arguments);
  };
}

var isObservableArrayAdministration = /*#__PURE__*/createInstanceofPredicate("ObservableArrayAdministration", ObservableArrayAdministration);
function isObservableArray(thing) {
  return isObject(thing) && isObservableArrayAdministration(thing[$mobx]);
}

var _Symbol$iterator, _Symbol$toStringTag;
var ObservableMapMarker = {};
var ADD = "add";
var DELETE = "delete"; // just extend Map? See also https://gist.github.com/nestharus/13b4d74f2ef4a2f4357dbd3fc23c1e54
// But: https://github.com/mobxjs/mobx/issues/1556

_Symbol$iterator = Symbol.iterator;
_Symbol$toStringTag = Symbol.toStringTag;
var ObservableMap = /*#__PURE__*/function () {
  // hasMap, not hashMap >-).
  function ObservableMap(initialData, enhancer_, name_) {
    if (enhancer_ === void 0) {
      enhancer_ = deepEnhancer;
    }

    if (name_ === void 0) {
      name_ =  false ? 0 : "ObservableMap";
    }

    this.enhancer_ = void 0;
    this.name_ = void 0;
    this[$mobx] = ObservableMapMarker;
    this.data_ = void 0;
    this.hasMap_ = void 0;
    this.keysAtom_ = void 0;
    this.interceptors_ = void 0;
    this.changeListeners_ = void 0;
    this.dehancer = void 0;
    this.enhancer_ = enhancer_;
    this.name_ = name_;

    if (!isFunction(Map)) {
      die(18);
    }

    this.keysAtom_ = createAtom( false ? 0 : "ObservableMap.keys()");
    this.data_ = new Map();
    this.hasMap_ = new Map();
    this.merge(initialData);
  }

  var _proto = ObservableMap.prototype;

  _proto.has_ = function has_(key) {
    return this.data_.has(key);
  };

  _proto.has = function has(key) {
    var _this = this;

    if (!globalState.trackingDerivation) return this.has_(key);
    var entry = this.hasMap_.get(key);

    if (!entry) {
      var newEntry = entry = new ObservableValue(this.has_(key), referenceEnhancer,  false ? 0 : "ObservableMap.key?", false);
      this.hasMap_.set(key, newEntry);
      onBecomeUnobserved(newEntry, function () {
        return _this.hasMap_["delete"](key);
      });
    }

    return entry.get();
  };

  _proto.set = function set(key, value) {
    var hasKey = this.has_(key);

    if (hasInterceptors(this)) {
      var change = interceptChange(this, {
        type: hasKey ? UPDATE : ADD,
        object: this,
        newValue: value,
        name: key
      });
      if (!change) return this;
      value = change.newValue;
    }

    if (hasKey) {
      this.updateValue_(key, value);
    } else {
      this.addValue_(key, value);
    }

    return this;
  };

  _proto["delete"] = function _delete(key) {
    var _this2 = this;

    checkIfStateModificationsAreAllowed(this.keysAtom_);

    if (hasInterceptors(this)) {
      var change = interceptChange(this, {
        type: DELETE,
        object: this,
        name: key
      });
      if (!change) return false;
    }

    if (this.has_(key)) {
      var notifySpy = isSpyEnabled();
      var notify = hasListeners(this);

      var _change = notify || notifySpy ? {
        observableKind: "map",
        debugObjectName: this.name_,
        type: DELETE,
        object: this,
        oldValue: this.data_.get(key).value_,
        name: key
      } : null;

      if (false) {}
      transaction(function () {
        _this2.keysAtom_.reportChanged();

        _this2.updateHasMapEntry_(key, false);

        var observable = _this2.data_.get(key);

        observable.setNewValue_(undefined);

        _this2.data_["delete"](key);
      });
      if (notify) notifyListeners(this, _change);
      if (false) {}
      return true;
    }

    return false;
  };

  _proto.updateHasMapEntry_ = function updateHasMapEntry_(key, value) {
    var entry = this.hasMap_.get(key);

    if (entry) {
      entry.setNewValue_(value);
    }
  };

  _proto.updateValue_ = function updateValue_(key, newValue) {
    var observable = this.data_.get(key);
    newValue = observable.prepareNewValue_(newValue);

    if (newValue !== globalState.UNCHANGED) {
      var notifySpy = isSpyEnabled();
      var notify = hasListeners(this);
      var change = notify || notifySpy ? {
        observableKind: "map",
        debugObjectName: this.name_,
        type: UPDATE,
        object: this,
        oldValue: observable.value_,
        name: key,
        newValue: newValue
      } : null;
      if (false) {}
      observable.setNewValue_(newValue);
      if (notify) notifyListeners(this, change);
      if (false) {}
    }
  };

  _proto.addValue_ = function addValue_(key, newValue) {
    var _this3 = this;

    checkIfStateModificationsAreAllowed(this.keysAtom_);
    transaction(function () {
      var observable = new ObservableValue(newValue, _this3.enhancer_,  false ? 0 : "ObservableMap.key", false);

      _this3.data_.set(key, observable);

      newValue = observable.value_; // value might have been changed

      _this3.updateHasMapEntry_(key, true);

      _this3.keysAtom_.reportChanged();
    });
    var notifySpy = isSpyEnabled();
    var notify = hasListeners(this);
    var change = notify || notifySpy ? {
      observableKind: "map",
      debugObjectName: this.name_,
      type: ADD,
      object: this,
      name: key,
      newValue: newValue
    } : null;
    if (false) {}
    if (notify) notifyListeners(this, change);
    if (false) {}
  };

  _proto.get = function get(key) {
    if (this.has(key)) return this.dehanceValue_(this.data_.get(key).get());
    return this.dehanceValue_(undefined);
  };

  _proto.dehanceValue_ = function dehanceValue_(value) {
    if (this.dehancer !== undefined) {
      return this.dehancer(value);
    }

    return value;
  };

  _proto.keys = function keys() {
    this.keysAtom_.reportObserved();
    return this.data_.keys();
  };

  _proto.values = function values() {
    var self = this;
    var keys = this.keys();
    return makeIterable({
      next: function next() {
        var _keys$next = keys.next(),
            done = _keys$next.done,
            value = _keys$next.value;

        return {
          done: done,
          value: done ? undefined : self.get(value)
        };
      }
    });
  };

  _proto.entries = function entries() {
    var self = this;
    var keys = this.keys();
    return makeIterable({
      next: function next() {
        var _keys$next2 = keys.next(),
            done = _keys$next2.done,
            value = _keys$next2.value;

        return {
          done: done,
          value: done ? undefined : [value, self.get(value)]
        };
      }
    });
  };

  _proto[_Symbol$iterator] = function () {
    return this.entries();
  };

  _proto.forEach = function forEach(callback, thisArg) {
    for (var _iterator = _createForOfIteratorHelperLoose(this), _step; !(_step = _iterator()).done;) {
      var _step$value = _step.value,
          key = _step$value[0],
          value = _step$value[1];
      callback.call(thisArg, value, key, this);
    }
  }
  /** Merge another object into this object, returns this. */
  ;

  _proto.merge = function merge(other) {
    var _this4 = this;

    if (isObservableMap(other)) {
      other = new Map(other);
    }

    transaction(function () {
      if (isPlainObject(other)) getPlainObjectKeys(other).forEach(function (key) {
        return _this4.set(key, other[key]);
      });else if (Array.isArray(other)) other.forEach(function (_ref) {
        var key = _ref[0],
            value = _ref[1];
        return _this4.set(key, value);
      });else if (isES6Map(other)) {
        if (other.constructor !== Map) die(19, other);
        other.forEach(function (value, key) {
          return _this4.set(key, value);
        });
      } else if (other !== null && other !== undefined) die(20, other);
    });
    return this;
  };

  _proto.clear = function clear() {
    var _this5 = this;

    transaction(function () {
      untracked(function () {
        for (var _iterator2 = _createForOfIteratorHelperLoose(_this5.keys()), _step2; !(_step2 = _iterator2()).done;) {
          var key = _step2.value;

          _this5["delete"](key);
        }
      });
    });
  };

  _proto.replace = function replace(values) {
    var _this6 = this;

    // Implementation requirements:
    // - respect ordering of replacement map
    // - allow interceptors to run and potentially prevent individual operations
    // - don't recreate observables that already exist in original map (so we don't destroy existing subscriptions)
    // - don't _keysAtom.reportChanged if the keys of resulting map are indentical (order matters!)
    // - note that result map may differ from replacement map due to the interceptors
    transaction(function () {
      // Convert to map so we can do quick key lookups
      var replacementMap = convertToMap(values);
      var orderedData = new Map(); // Used for optimization

      var keysReportChangedCalled = false; // Delete keys that don't exist in replacement map
      // if the key deletion is prevented by interceptor
      // add entry at the beginning of the result map

      for (var _iterator3 = _createForOfIteratorHelperLoose(_this6.data_.keys()), _step3; !(_step3 = _iterator3()).done;) {
        var key = _step3.value;

        // Concurrently iterating/deleting keys
        // iterator should handle this correctly
        if (!replacementMap.has(key)) {
          var deleted = _this6["delete"](key); // Was the key removed?


          if (deleted) {
            // _keysAtom.reportChanged() was already called
            keysReportChangedCalled = true;
          } else {
            // Delete prevented by interceptor
            var value = _this6.data_.get(key);

            orderedData.set(key, value);
          }
        }
      } // Merge entries


      for (var _iterator4 = _createForOfIteratorHelperLoose(replacementMap.entries()), _step4; !(_step4 = _iterator4()).done;) {
        var _step4$value = _step4.value,
            _key = _step4$value[0],
            _value = _step4$value[1];

        // We will want to know whether a new key is added
        var keyExisted = _this6.data_.has(_key); // Add or update value


        _this6.set(_key, _value); // The addition could have been prevent by interceptor


        if (_this6.data_.has(_key)) {
          // The update could have been prevented by interceptor
          // and also we want to preserve existing values
          // so use value from _data map (instead of replacement map)
          var _value2 = _this6.data_.get(_key);

          orderedData.set(_key, _value2); // Was a new key added?

          if (!keyExisted) {
            // _keysAtom.reportChanged() was already called
            keysReportChangedCalled = true;
          }
        }
      } // Check for possible key order change


      if (!keysReportChangedCalled) {
        if (_this6.data_.size !== orderedData.size) {
          // If size differs, keys are definitely modified
          _this6.keysAtom_.reportChanged();
        } else {
          var iter1 = _this6.data_.keys();

          var iter2 = orderedData.keys();
          var next1 = iter1.next();
          var next2 = iter2.next();

          while (!next1.done) {
            if (next1.value !== next2.value) {
              _this6.keysAtom_.reportChanged();

              break;
            }

            next1 = iter1.next();
            next2 = iter2.next();
          }
        }
      } // Use correctly ordered map


      _this6.data_ = orderedData;
    });
    return this;
  };

  _proto.toString = function toString() {
    return "[object ObservableMap]";
  };

  _proto.toJSON = function toJSON() {
    return Array.from(this);
  };

  /**
   * Observes this object. Triggers for the events 'add', 'update' and 'delete'.
   * See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/observe
   * for callback details
   */
  _proto.observe_ = function observe_(listener, fireImmediately) {
    if (false) {}
    return registerListener(this, listener);
  };

  _proto.intercept_ = function intercept_(handler) {
    return registerInterceptor(this, handler);
  };

  mobx_esm_createClass(ObservableMap, [{
    key: "size",
    get: function get() {
      this.keysAtom_.reportObserved();
      return this.data_.size;
    }
  }, {
    key: _Symbol$toStringTag,
    get: function get() {
      return "Map";
    }
  }]);

  return ObservableMap;
}(); // eslint-disable-next-line

var isObservableMap = /*#__PURE__*/createInstanceofPredicate("ObservableMap", ObservableMap);

function convertToMap(dataStructure) {
  if (isES6Map(dataStructure) || isObservableMap(dataStructure)) {
    return dataStructure;
  } else if (Array.isArray(dataStructure)) {
    return new Map(dataStructure);
  } else if (isPlainObject(dataStructure)) {
    var map = new Map();

    for (var key in dataStructure) {
      map.set(key, dataStructure[key]);
    }

    return map;
  } else {
    return die(21, dataStructure);
  }
}

var _Symbol$iterator$1, _Symbol$toStringTag$1;
var ObservableSetMarker = {};
_Symbol$iterator$1 = Symbol.iterator;
_Symbol$toStringTag$1 = Symbol.toStringTag;
var ObservableSet = /*#__PURE__*/function () {
  function ObservableSet(initialData, enhancer, name_) {
    if (enhancer === void 0) {
      enhancer = deepEnhancer;
    }

    if (name_ === void 0) {
      name_ =  false ? 0 : "ObservableSet";
    }

    this.name_ = void 0;
    this[$mobx] = ObservableSetMarker;
    this.data_ = new Set();
    this.atom_ = void 0;
    this.changeListeners_ = void 0;
    this.interceptors_ = void 0;
    this.dehancer = void 0;
    this.enhancer_ = void 0;
    this.name_ = name_;

    if (!isFunction(Set)) {
      die(22);
    }

    this.atom_ = createAtom(this.name_);

    this.enhancer_ = function (newV, oldV) {
      return enhancer(newV, oldV, name_);
    };

    if (initialData) {
      this.replace(initialData);
    }
  }

  var _proto = ObservableSet.prototype;

  _proto.dehanceValue_ = function dehanceValue_(value) {
    if (this.dehancer !== undefined) {
      return this.dehancer(value);
    }

    return value;
  };

  _proto.clear = function clear() {
    var _this = this;

    transaction(function () {
      untracked(function () {
        for (var _iterator = _createForOfIteratorHelperLoose(_this.data_.values()), _step; !(_step = _iterator()).done;) {
          var value = _step.value;

          _this["delete"](value);
        }
      });
    });
  };

  _proto.forEach = function forEach(callbackFn, thisArg) {
    for (var _iterator2 = _createForOfIteratorHelperLoose(this), _step2; !(_step2 = _iterator2()).done;) {
      var value = _step2.value;
      callbackFn.call(thisArg, value, value, this);
    }
  };

  _proto.add = function add(value) {
    var _this2 = this;

    checkIfStateModificationsAreAllowed(this.atom_);

    if (hasInterceptors(this)) {
      var change = interceptChange(this, {
        type: ADD,
        object: this,
        newValue: value
      });
      if (!change) return this; // ideally, value = change.value would be done here, so that values can be
      // changed by interceptor. Same applies for other Set and Map api's.
    }

    if (!this.has(value)) {
      transaction(function () {
        _this2.data_.add(_this2.enhancer_(value, undefined));

        _this2.atom_.reportChanged();
      });
      var notifySpy =  false && 0;
      var notify = hasListeners(this);

      var _change = notify || notifySpy ? {
        observableKind: "set",
        debugObjectName: this.name_,
        type: ADD,
        object: this,
        newValue: value
      } : null;

      if (notifySpy && "production" !== "production") {}
      if (notify) notifyListeners(this, _change);
      if (notifySpy && "production" !== "production") {}
    }

    return this;
  };

  _proto["delete"] = function _delete(value) {
    var _this3 = this;

    if (hasInterceptors(this)) {
      var change = interceptChange(this, {
        type: DELETE,
        object: this,
        oldValue: value
      });
      if (!change) return false;
    }

    if (this.has(value)) {
      var notifySpy =  false && 0;
      var notify = hasListeners(this);

      var _change2 = notify || notifySpy ? {
        observableKind: "set",
        debugObjectName: this.name_,
        type: DELETE,
        object: this,
        oldValue: value
      } : null;

      if (notifySpy && "production" !== "production") {}
      transaction(function () {
        _this3.atom_.reportChanged();

        _this3.data_["delete"](value);
      });
      if (notify) notifyListeners(this, _change2);
      if (notifySpy && "production" !== "production") {}
      return true;
    }

    return false;
  };

  _proto.has = function has(value) {
    this.atom_.reportObserved();
    return this.data_.has(this.dehanceValue_(value));
  };

  _proto.entries = function entries() {
    var nextIndex = 0;
    var keys = Array.from(this.keys());
    var values = Array.from(this.values());
    return makeIterable({
      next: function next() {
        var index = nextIndex;
        nextIndex += 1;
        return index < values.length ? {
          value: [keys[index], values[index]],
          done: false
        } : {
          done: true
        };
      }
    });
  };

  _proto.keys = function keys() {
    return this.values();
  };

  _proto.values = function values() {
    this.atom_.reportObserved();
    var self = this;
    var nextIndex = 0;
    var observableValues = Array.from(this.data_.values());
    return makeIterable({
      next: function next() {
        return nextIndex < observableValues.length ? {
          value: self.dehanceValue_(observableValues[nextIndex++]),
          done: false
        } : {
          done: true
        };
      }
    });
  };

  _proto.replace = function replace(other) {
    var _this4 = this;

    if (isObservableSet(other)) {
      other = new Set(other);
    }

    transaction(function () {
      if (Array.isArray(other)) {
        _this4.clear();

        other.forEach(function (value) {
          return _this4.add(value);
        });
      } else if (isES6Set(other)) {
        _this4.clear();

        other.forEach(function (value) {
          return _this4.add(value);
        });
      } else if (other !== null && other !== undefined) {
        die("Cannot initialize set from " + other);
      }
    });
    return this;
  };

  _proto.observe_ = function observe_(listener, fireImmediately) {
    // ... 'fireImmediately' could also be true?
    if (false) {}
    return registerListener(this, listener);
  };

  _proto.intercept_ = function intercept_(handler) {
    return registerInterceptor(this, handler);
  };

  _proto.toJSON = function toJSON() {
    return Array.from(this);
  };

  _proto.toString = function toString() {
    return "[object ObservableSet]";
  };

  _proto[_Symbol$iterator$1] = function () {
    return this.values();
  };

  mobx_esm_createClass(ObservableSet, [{
    key: "size",
    get: function get() {
      this.atom_.reportObserved();
      return this.data_.size;
    }
  }, {
    key: _Symbol$toStringTag$1,
    get: function get() {
      return "Set";
    }
  }]);

  return ObservableSet;
}(); // eslint-disable-next-line

var isObservableSet = /*#__PURE__*/createInstanceofPredicate("ObservableSet", ObservableSet);

var descriptorCache = /*#__PURE__*/Object.create(null);
var REMOVE = "remove";
var ObservableObjectAdministration = /*#__PURE__*/function () {
  function ObservableObjectAdministration(target_, values_, name_, // Used anytime annotation is not explicitely provided
  defaultAnnotation_) {
    if (values_ === void 0) {
      values_ = new Map();
    }

    if (defaultAnnotation_ === void 0) {
      defaultAnnotation_ = autoAnnotation;
    }

    this.target_ = void 0;
    this.values_ = void 0;
    this.name_ = void 0;
    this.defaultAnnotation_ = void 0;
    this.keysAtom_ = void 0;
    this.changeListeners_ = void 0;
    this.interceptors_ = void 0;
    this.proxy_ = void 0;
    this.isPlainObject_ = void 0;
    this.appliedAnnotations_ = void 0;
    this.pendingKeys_ = void 0;
    this.target_ = target_;
    this.values_ = values_;
    this.name_ = name_;
    this.defaultAnnotation_ = defaultAnnotation_;
    this.keysAtom_ = new Atom( false ? 0 : "ObservableObject.keys"); // Optimization: we use this frequently

    this.isPlainObject_ = isPlainObject(this.target_);

    if (false) {}

    if (false) {}
  }

  var _proto = ObservableObjectAdministration.prototype;

  _proto.getObservablePropValue_ = function getObservablePropValue_(key) {
    return this.values_.get(key).get();
  };

  _proto.setObservablePropValue_ = function setObservablePropValue_(key, newValue) {
    var observable = this.values_.get(key);

    if (observable instanceof ComputedValue) {
      observable.set(newValue);
      return true;
    } // intercept


    if (hasInterceptors(this)) {
      var change = interceptChange(this, {
        type: UPDATE,
        object: this.proxy_ || this.target_,
        name: key,
        newValue: newValue
      });
      if (!change) return null;
      newValue = change.newValue;
    }

    newValue = observable.prepareNewValue_(newValue); // notify spy & observers

    if (newValue !== globalState.UNCHANGED) {
      var notify = hasListeners(this);
      var notifySpy =  false && 0;

      var _change = notify || notifySpy ? {
        type: UPDATE,
        observableKind: "object",
        debugObjectName: this.name_,
        object: this.proxy_ || this.target_,
        oldValue: observable.value_,
        name: key,
        newValue: newValue
      } : null;

      if (false) {}
      observable.setNewValue_(newValue);
      if (notify) notifyListeners(this, _change);
      if (false) {}
    }

    return true;
  };

  _proto.get_ = function get_(key) {
    if (globalState.trackingDerivation && !hasProp(this.target_, key)) {
      // Key doesn't exist yet, subscribe for it in case it's added later
      this.has_(key);
    }

    return this.target_[key];
  }
  /**
   * @param {PropertyKey} key
   * @param {any} value
   * @param {Annotation|boolean} annotation true - use default annotation, false - copy as is
   * @param {boolean} proxyTrap whether it's called from proxy trap
   * @returns {boolean|null} true on success, false on failure (proxyTrap + non-configurable), null when cancelled by interceptor
   */
  ;

  _proto.set_ = function set_(key, value, proxyTrap) {
    if (proxyTrap === void 0) {
      proxyTrap = false;
    }

    // Don't use .has(key) - we care about own
    if (hasProp(this.target_, key)) {
      // Existing prop
      if (this.values_.has(key)) {
        // Observable (can be intercepted)
        return this.setObservablePropValue_(key, value);
      } else if (proxyTrap) {
        // Non-observable - proxy
        return Reflect.set(this.target_, key, value);
      } else {
        // Non-observable
        this.target_[key] = value;
        return true;
      }
    } else {
      // New prop
      return this.extend_(key, {
        value: value,
        enumerable: true,
        writable: true,
        configurable: true
      }, this.defaultAnnotation_, proxyTrap);
    }
  } // Trap for "in"
  ;

  _proto.has_ = function has_(key) {
    if (!globalState.trackingDerivation) {
      // Skip key subscription outside derivation
      return key in this.target_;
    }

    this.pendingKeys_ || (this.pendingKeys_ = new Map());
    var entry = this.pendingKeys_.get(key);

    if (!entry) {
      entry = new ObservableValue(key in this.target_, referenceEnhancer,  false ? 0 : "ObservableObject.key?", false);
      this.pendingKeys_.set(key, entry);
    }

    return entry.get();
  }
  /**
   * @param {PropertyKey} key
   * @param {Annotation|boolean} annotation true - use default annotation, false - ignore prop
   */
  ;

  _proto.make_ = function make_(key, annotation) {
    if (annotation === true) {
      annotation = this.defaultAnnotation_;
    }

    if (annotation === false) {
      return;
    }

    assertAnnotable(this, annotation, key);

    if (!(key in this.target_)) {
      var _this$target_$storedA;

      // Throw on missing key, except for decorators:
      // Decorator annotations are collected from whole prototype chain.
      // When called from super() some props may not exist yet.
      // However we don't have to worry about missing prop,
      // because the decorator must have been applied to something.
      if ((_this$target_$storedA = this.target_[storedAnnotationsSymbol]) == null ? void 0 : _this$target_$storedA[key]) {
        return; // will be annotated by subclass constructor
      } else {
        die(1, annotation.annotationType_, this.name_ + "." + key.toString());
      }
    }

    var source = this.target_;

    while (source && source !== objectPrototype) {
      var descriptor = getDescriptor(source, key);

      if (descriptor) {
        var outcome = annotation.make_(this, key, descriptor, source);
        if (outcome === 0
        /* Cancel */
        ) return;
        if (outcome === 1
        /* Break */
        ) break;
      }

      source = Object.getPrototypeOf(source);
    }

    recordAnnotationApplied(this, annotation, key);
  }
  /**
   * @param {PropertyKey} key
   * @param {PropertyDescriptor} descriptor
   * @param {Annotation|boolean} annotation true - use default annotation, false - copy as is
   * @param {boolean} proxyTrap whether it's called from proxy trap
   * @returns {boolean|null} true on success, false on failure (proxyTrap + non-configurable), null when cancelled by interceptor
   */
  ;

  _proto.extend_ = function extend_(key, descriptor, annotation, proxyTrap) {
    if (proxyTrap === void 0) {
      proxyTrap = false;
    }

    if (annotation === true) {
      annotation = this.defaultAnnotation_;
    }

    if (annotation === false) {
      return this.defineProperty_(key, descriptor, proxyTrap);
    }

    assertAnnotable(this, annotation, key);
    var outcome = annotation.extend_(this, key, descriptor, proxyTrap);

    if (outcome) {
      recordAnnotationApplied(this, annotation, key);
    }

    return outcome;
  }
  /**
   * @param {PropertyKey} key
   * @param {PropertyDescriptor} descriptor
   * @param {boolean} proxyTrap whether it's called from proxy trap
   * @returns {boolean|null} true on success, false on failure (proxyTrap + non-configurable), null when cancelled by interceptor
   */
  ;

  _proto.defineProperty_ = function defineProperty_(key, descriptor, proxyTrap) {
    if (proxyTrap === void 0) {
      proxyTrap = false;
    }

    try {
      startBatch(); // Delete

      var deleteOutcome = this.delete_(key);

      if (!deleteOutcome) {
        // Failure or intercepted
        return deleteOutcome;
      } // ADD interceptor


      if (hasInterceptors(this)) {
        var change = interceptChange(this, {
          object: this.proxy_ || this.target_,
          name: key,
          type: ADD,
          newValue: descriptor.value
        });
        if (!change) return null;
        var newValue = change.newValue;

        if (descriptor.value !== newValue) {
          descriptor = _extends({}, descriptor, {
            value: newValue
          });
        }
      } // Define


      if (proxyTrap) {
        if (!Reflect.defineProperty(this.target_, key, descriptor)) {
          return false;
        }
      } else {
        defineProperty(this.target_, key, descriptor);
      } // Notify


      this.notifyPropertyAddition_(key, descriptor.value);
    } finally {
      endBatch();
    }

    return true;
  } // If original descriptor becomes relevant, move this to annotation directly
  ;

  _proto.defineObservableProperty_ = function defineObservableProperty_(key, value, enhancer, proxyTrap) {
    if (proxyTrap === void 0) {
      proxyTrap = false;
    }

    try {
      startBatch(); // Delete

      var deleteOutcome = this.delete_(key);

      if (!deleteOutcome) {
        // Failure or intercepted
        return deleteOutcome;
      } // ADD interceptor


      if (hasInterceptors(this)) {
        var change = interceptChange(this, {
          object: this.proxy_ || this.target_,
          name: key,
          type: ADD,
          newValue: value
        });
        if (!change) return null;
        value = change.newValue;
      }

      var cachedDescriptor = getCachedObservablePropDescriptor(key);
      var descriptor = {
        configurable: globalState.safeDescriptors ? this.isPlainObject_ : true,
        enumerable: true,
        get: cachedDescriptor.get,
        set: cachedDescriptor.set
      }; // Define

      if (proxyTrap) {
        if (!Reflect.defineProperty(this.target_, key, descriptor)) {
          return false;
        }
      } else {
        defineProperty(this.target_, key, descriptor);
      }

      var observable = new ObservableValue(value, enhancer,  false ? 0 : "ObservableObject.key", false);
      this.values_.set(key, observable); // Notify (value possibly changed by ObservableValue)

      this.notifyPropertyAddition_(key, observable.value_);
    } finally {
      endBatch();
    }

    return true;
  } // If original descriptor becomes relevant, move this to annotation directly
  ;

  _proto.defineComputedProperty_ = function defineComputedProperty_(key, options, proxyTrap) {
    if (proxyTrap === void 0) {
      proxyTrap = false;
    }

    try {
      startBatch(); // Delete

      var deleteOutcome = this.delete_(key);

      if (!deleteOutcome) {
        // Failure or intercepted
        return deleteOutcome;
      } // ADD interceptor


      if (hasInterceptors(this)) {
        var change = interceptChange(this, {
          object: this.proxy_ || this.target_,
          name: key,
          type: ADD,
          newValue: undefined
        });
        if (!change) return null;
      }

      options.name || (options.name =  false ? 0 : "ObservableObject.key");
      options.context = this.proxy_ || this.target_;
      var cachedDescriptor = getCachedObservablePropDescriptor(key);
      var descriptor = {
        configurable: globalState.safeDescriptors ? this.isPlainObject_ : true,
        enumerable: false,
        get: cachedDescriptor.get,
        set: cachedDescriptor.set
      }; // Define

      if (proxyTrap) {
        if (!Reflect.defineProperty(this.target_, key, descriptor)) {
          return false;
        }
      } else {
        defineProperty(this.target_, key, descriptor);
      }

      this.values_.set(key, new ComputedValue(options)); // Notify

      this.notifyPropertyAddition_(key, undefined);
    } finally {
      endBatch();
    }

    return true;
  }
  /**
   * @param {PropertyKey} key
   * @param {PropertyDescriptor} descriptor
   * @param {boolean} proxyTrap whether it's called from proxy trap
   * @returns {boolean|null} true on success, false on failure (proxyTrap + non-configurable), null when cancelled by interceptor
   */
  ;

  _proto.delete_ = function delete_(key, proxyTrap) {
    if (proxyTrap === void 0) {
      proxyTrap = false;
    }

    // No such prop
    if (!hasProp(this.target_, key)) {
      return true;
    } // Intercept


    if (hasInterceptors(this)) {
      var change = interceptChange(this, {
        object: this.proxy_ || this.target_,
        name: key,
        type: REMOVE
      }); // Cancelled

      if (!change) return null;
    } // Delete


    try {
      var _this$pendingKeys_, _this$pendingKeys_$ge;

      startBatch();
      var notify = hasListeners(this);
      var notifySpy =  false && 0;
      var observable = this.values_.get(key); // Value needed for spies/listeners

      var value = undefined; // Optimization: don't pull the value unless we will need it

      if (!observable && (notify || notifySpy)) {
        var _getDescriptor;

        value = (_getDescriptor = getDescriptor(this.target_, key)) == null ? void 0 : _getDescriptor.value;
      } // delete prop (do first, may fail)


      if (proxyTrap) {
        if (!Reflect.deleteProperty(this.target_, key)) {
          return false;
        }
      } else {
        delete this.target_[key];
      } // Allow re-annotating this field


      if (false) {} // Clear observable


      if (observable) {
        this.values_["delete"](key); // for computed, value is undefined

        if (observable instanceof ObservableValue) {
          value = observable.value_;
        } // Notify: autorun(() => obj[key]), see #1796


        propagateChanged(observable);
      } // Notify "keys/entries/values" observers


      this.keysAtom_.reportChanged(); // Notify "has" observers
      // "in" as it may still exist in proto

      (_this$pendingKeys_ = this.pendingKeys_) == null ? void 0 : (_this$pendingKeys_$ge = _this$pendingKeys_.get(key)) == null ? void 0 : _this$pendingKeys_$ge.set(key in this.target_); // Notify spies/listeners

      if (notify || notifySpy) {
        var _change2 = {
          type: REMOVE,
          observableKind: "object",
          object: this.proxy_ || this.target_,
          debugObjectName: this.name_,
          oldValue: value,
          name: key
        };
        if (false) {}
        if (notify) notifyListeners(this, _change2);
        if (false) {}
      }
    } finally {
      endBatch();
    }

    return true;
  }
  /**
   * Observes this object. Triggers for the events 'add', 'update' and 'delete'.
   * See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/observe
   * for callback details
   */
  ;

  _proto.observe_ = function observe_(callback, fireImmediately) {
    if (false) {}
    return registerListener(this, callback);
  };

  _proto.intercept_ = function intercept_(handler) {
    return registerInterceptor(this, handler);
  };

  _proto.notifyPropertyAddition_ = function notifyPropertyAddition_(key, value) {
    var _this$pendingKeys_2, _this$pendingKeys_2$g;

    var notify = hasListeners(this);
    var notifySpy =  false && 0;

    if (notify || notifySpy) {
      var change = notify || notifySpy ? {
        type: ADD,
        observableKind: "object",
        debugObjectName: this.name_,
        object: this.proxy_ || this.target_,
        name: key,
        newValue: value
      } : null;
      if (false) {}
      if (notify) notifyListeners(this, change);
      if (false) {}
    }

    (_this$pendingKeys_2 = this.pendingKeys_) == null ? void 0 : (_this$pendingKeys_2$g = _this$pendingKeys_2.get(key)) == null ? void 0 : _this$pendingKeys_2$g.set(true); // Notify "keys/entries/values" observers

    this.keysAtom_.reportChanged();
  };

  _proto.ownKeys_ = function ownKeys_() {
    this.keysAtom_.reportObserved();
    return ownKeys(this.target_);
  };

  _proto.keys_ = function keys_() {
    // Returns enumerable && own, but unfortunately keysAtom will report on ANY key change.
    // There is no way to distinguish between Object.keys(object) and Reflect.ownKeys(object) - both are handled by ownKeys trap.
    // We can either over-report in Object.keys(object) or under-report in Reflect.ownKeys(object)
    // We choose to over-report in Object.keys(object), because:
    // - typically it's used with simple data objects
    // - when symbolic/non-enumerable keys are relevant Reflect.ownKeys works as expected
    this.keysAtom_.reportObserved();
    return Object.keys(this.target_);
  };

  return ObservableObjectAdministration;
}();
function asObservableObject(target, options) {
  var _options$name;

  if (false) {}

  if (hasProp(target, $mobx)) {
    if (false) {}

    return target;
  }

  if (false) {}
  var name = (_options$name = options == null ? void 0 : options.name) != null ? _options$name :  false ? 0 : "ObservableObject";
  var adm = new ObservableObjectAdministration(target, new Map(), String(name), getAnnotationFromOptions(options));
  addHiddenProp(target, $mobx, adm);
  return target;
}
var isObservableObjectAdministration = /*#__PURE__*/createInstanceofPredicate("ObservableObjectAdministration", ObservableObjectAdministration);

function getCachedObservablePropDescriptor(key) {
  return descriptorCache[key] || (descriptorCache[key] = {
    get: function get() {
      return this[$mobx].getObservablePropValue_(key);
    },
    set: function set(value) {
      return this[$mobx].setObservablePropValue_(key, value);
    }
  });
}

function isObservableObject(thing) {
  if (isObject(thing)) {
    return isObservableObjectAdministration(thing[$mobx]);
  }

  return false;
}
function recordAnnotationApplied(adm, annotation, key) {
  var _adm$target_$storedAn;

  if (false) {} // Remove applied decorator annotation so we don't try to apply it again in subclass constructor


  (_adm$target_$storedAn = adm.target_[storedAnnotationsSymbol]) == null ? true : delete _adm$target_$storedAn[key];
}

function assertAnnotable(adm, annotation, key) {
  // Valid annotation
  if (false) {}
  /*
  // Configurable, not sealed, not frozen
  // Possibly not needed, just a little better error then the one thrown by engine.
  // Cases where this would be useful the most (subclass field initializer) are not interceptable by this.
  if (__DEV__) {
      const configurable = getDescriptor(adm.target_, key)?.configurable
      const frozen = Object.isFrozen(adm.target_)
      const sealed = Object.isSealed(adm.target_)
      if (!configurable || frozen || sealed) {
          const fieldName = `${adm.name_}.${key.toString()}`
          const requestedAnnotationType = annotation.annotationType_
          let error = `Cannot apply '${requestedAnnotationType}' to '${fieldName}':`
          if (frozen) {
              error += `\nObject is frozen.`
          }
          if (sealed) {
              error += `\nObject is sealed.`
          }
          if (!configurable) {
              error += `\nproperty is not configurable.`
              // Mention only if caused by us to avoid confusion
              if (hasProp(adm.appliedAnnotations!, key)) {
                  error += `\nTo prevent accidental re-definition of a field by a subclass, `
                  error += `all annotated fields of non-plain objects (classes) are not configurable.`
              }
          }
          die(error)
      }
  }
  */
  // Not annotated


  if (false) { var requestedAnnotationType, currentAnnotationType, fieldName; }
}

/**
 * This array buffer contains two lists of properties, so that all arrays
 * can recycle their property definitions, which significantly improves performance of creating
 * properties on the fly.
 */

var OBSERVABLE_ARRAY_BUFFER_SIZE = 0; // Typescript workaround to make sure ObservableArray extends Array

var StubArray = function StubArray() {};

function inherit(ctor, proto) {
  if (Object.setPrototypeOf) {
    Object.setPrototypeOf(ctor.prototype, proto);
  } else if (ctor.prototype.__proto__ !== undefined) {
    ctor.prototype.__proto__ = proto;
  } else {
    ctor.prototype = proto;
  }
}

inherit(StubArray, Array.prototype); // Weex proto freeze protection was here,
// but it is unclear why the hack is need as MobX never changed the prototype
// anyway, so removed it in V6

var LegacyObservableArray = /*#__PURE__*/function (_StubArray) {
  _inheritsLoose(LegacyObservableArray, _StubArray);

  function LegacyObservableArray(initialValues, enhancer, name, owned) {
    var _this;

    if (name === void 0) {
      name =  false ? 0 : "ObservableArray";
    }

    if (owned === void 0) {
      owned = false;
    }

    _this = _StubArray.call(this) || this;
    var adm = new ObservableArrayAdministration(name, enhancer, owned, true);
    adm.proxy_ = _assertThisInitialized(_this);
    addHiddenFinalProp(_assertThisInitialized(_this), $mobx, adm);

    if (initialValues && initialValues.length) {
      var prev = allowStateChangesStart(true); // @ts-ignore

      _this.spliceWithArray(0, 0, initialValues);

      allowStateChangesEnd(prev);
    }

    return _this;
  }

  var _proto = LegacyObservableArray.prototype;

  _proto.concat = function concat() {
    this[$mobx].atom_.reportObserved();

    for (var _len = arguments.length, arrays = new Array(_len), _key = 0; _key < _len; _key++) {
      arrays[_key] = arguments[_key];
    }

    return Array.prototype.concat.apply(this.slice(), //@ts-ignore
    arrays.map(function (a) {
      return isObservableArray(a) ? a.slice() : a;
    }));
  };

  _proto[Symbol.iterator] = function () {
    var self = this;
    var nextIndex = 0;
    return makeIterable({
      next: function next() {
        // @ts-ignore
        return nextIndex < self.length ? {
          value: self[nextIndex++],
          done: false
        } : {
          done: true,
          value: undefined
        };
      }
    });
  };

  mobx_esm_createClass(LegacyObservableArray, [{
    key: "length",
    get: function get() {
      return this[$mobx].getArrayLength_();
    },
    set: function set(newLength) {
      this[$mobx].setArrayLength_(newLength);
    }
  }, {
    key: Symbol.toStringTag,
    get: function get() {
      return "Array";
    }
  }]);

  return LegacyObservableArray;
}(StubArray);

Object.entries(arrayExtensions).forEach(function (_ref) {
  var prop = _ref[0],
      fn = _ref[1];
  if (prop !== "concat") addHiddenProp(LegacyObservableArray.prototype, prop, fn);
});

function createArrayEntryDescriptor(index) {
  return {
    enumerable: false,
    configurable: true,
    get: function get() {
      return this[$mobx].get_(index);
    },
    set: function set(value) {
      this[$mobx].set_(index, value);
    }
  };
}

function createArrayBufferItem(index) {
  defineProperty(LegacyObservableArray.prototype, "" + index, createArrayEntryDescriptor(index));
}

function reserveArrayBuffer(max) {
  if (max > OBSERVABLE_ARRAY_BUFFER_SIZE) {
    for (var index = OBSERVABLE_ARRAY_BUFFER_SIZE; index < max + 100; index++) {
      createArrayBufferItem(index);
    }

    OBSERVABLE_ARRAY_BUFFER_SIZE = max;
  }
}
reserveArrayBuffer(1000);
function createLegacyArray(initialValues, enhancer, name) {
  return new LegacyObservableArray(initialValues, enhancer, name);
}

function getAtom(thing, property) {
  if (typeof thing === "object" && thing !== null) {
    if (isObservableArray(thing)) {
      if (property !== undefined) die(23);
      return thing[$mobx].atom_;
    }

    if (isObservableSet(thing)) {
      return thing[$mobx];
    }

    if (isObservableMap(thing)) {
      if (property === undefined) return thing.keysAtom_;
      var observable = thing.data_.get(property) || thing.hasMap_.get(property);
      if (!observable) die(25, property, getDebugName(thing));
      return observable;
    }

    if (isObservableObject(thing)) {
      if (!property) return die(26);

      var _observable = thing[$mobx].values_.get(property);

      if (!_observable) die(27, property, getDebugName(thing));
      return _observable;
    }

    if (isAtom(thing) || isComputedValue(thing) || isReaction(thing)) {
      return thing;
    }
  } else if (isFunction(thing)) {
    if (isReaction(thing[$mobx])) {
      // disposer function
      return thing[$mobx];
    }
  }

  die(28);
}
function getAdministration(thing, property) {
  if (!thing) die(29);
  if (property !== undefined) return getAdministration(getAtom(thing, property));
  if (isAtom(thing) || isComputedValue(thing) || isReaction(thing)) return thing;
  if (isObservableMap(thing) || isObservableSet(thing)) return thing;
  if (thing[$mobx]) return thing[$mobx];
  die(24, thing);
}
function getDebugName(thing, property) {
  var named;

  if (property !== undefined) {
    named = getAtom(thing, property);
  } else if (isAction(thing)) {
    return thing.name;
  } else if (isObservableObject(thing) || isObservableMap(thing) || isObservableSet(thing)) {
    named = getAdministration(thing);
  } else {
    // valid for arrays as well
    named = getAtom(thing);
  }

  return named.name_;
}

var mobx_esm_toString = objectPrototype.toString;
function deepEqual(a, b, depth) {
  if (depth === void 0) {
    depth = -1;
  }

  return eq(a, b, depth);
} // Copied from https://github.com/jashkenas/underscore/blob/5c237a7c682fb68fd5378203f0bf22dce1624854/underscore.js#L1186-L1289
// Internal recursive comparison function for `isEqual`.

function eq(a, b, depth, aStack, bStack) {
  // Identical objects are equal. `0 === -0`, but they aren't identical.
  // See the [Harmony `egal` proposal](http://wiki.ecmascript.org/doku.php?id=harmony:egal).
  if (a === b) return a !== 0 || 1 / a === 1 / b; // `null` or `undefined` only equal to itself (strict comparison).

  if (a == null || b == null) return false; // `NaN`s are equivalent, but non-reflexive.

  if (a !== a) return b !== b; // Exhaust primitive checks

  var type = typeof a;
  if (!isFunction(type) && type !== "object" && typeof b != "object") return false; // Compare `[[Class]]` names.

  var className = mobx_esm_toString.call(a);
  if (className !== mobx_esm_toString.call(b)) return false;

  switch (className) {
    // Strings, numbers, regular expressions, dates, and booleans are compared by value.
    case "[object RegExp]": // RegExps are coerced to strings for comparison (Note: '' + /a/i === '/a/i')

    case "[object String]":
      // Primitives and their corresponding object wrappers are equivalent; thus, `"5"` is
      // equivalent to `new String("5")`.
      return "" + a === "" + b;

    case "[object Number]":
      // `NaN`s are equivalent, but non-reflexive.
      // Object(NaN) is equivalent to NaN.
      if (+a !== +a) return +b !== +b; // An `egal` comparison is performed for other numeric values.

      return +a === 0 ? 1 / +a === 1 / b : +a === +b;

    case "[object Date]":
    case "[object Boolean]":
      // Coerce dates and booleans to numeric primitive values. Dates are compared by their
      // millisecond representations. Note that invalid dates with millisecond representations
      // of `NaN` are not equivalent.
      return +a === +b;

    case "[object Symbol]":
      return typeof Symbol !== "undefined" && Symbol.valueOf.call(a) === Symbol.valueOf.call(b);

    case "[object Map]":
    case "[object Set]":
      // Maps and Sets are unwrapped to arrays of entry-pairs, adding an incidental level.
      // Hide this extra level by increasing the depth.
      if (depth >= 0) {
        depth++;
      }

      break;
  } // Unwrap any wrapped objects.


  a = unwrap(a);
  b = unwrap(b);
  var areArrays = className === "[object Array]";

  if (!areArrays) {
    if (typeof a != "object" || typeof b != "object") return false; // Objects with different constructors are not equivalent, but `Object`s or `Array`s
    // from different frames are.

    var aCtor = a.constructor,
        bCtor = b.constructor;

    if (aCtor !== bCtor && !(isFunction(aCtor) && aCtor instanceof aCtor && isFunction(bCtor) && bCtor instanceof bCtor) && "constructor" in a && "constructor" in b) {
      return false;
    }
  }

  if (depth === 0) {
    return false;
  } else if (depth < 0) {
    depth = -1;
  } // Assume equality for cyclic structures. The algorithm for detecting cyclic
  // structures is adapted from ES 5.1 section 15.12.3, abstract operation `JO`.
  // Initializing stack of traversed objects.
  // It's done here since we only need them for objects and arrays comparison.


  aStack = aStack || [];
  bStack = bStack || [];
  var length = aStack.length;

  while (length--) {
    // Linear search. Performance is inversely proportional to the number of
    // unique nested structures.
    if (aStack[length] === a) return bStack[length] === b;
  } // Add the first object to the stack of traversed objects.


  aStack.push(a);
  bStack.push(b); // Recursively compare objects and arrays.

  if (areArrays) {
    // Compare array lengths to determine if a deep comparison is necessary.
    length = a.length;
    if (length !== b.length) return false; // Deep compare the contents, ignoring non-numeric properties.

    while (length--) {
      if (!eq(a[length], b[length], depth - 1, aStack, bStack)) return false;
    }
  } else {
    // Deep compare objects.
    var keys = Object.keys(a);
    var key;
    length = keys.length; // Ensure that both objects contain the same number of properties before comparing deep equality.

    if (Object.keys(b).length !== length) return false;

    while (length--) {
      // Deep compare each member
      key = keys[length];
      if (!(hasProp(b, key) && eq(a[key], b[key], depth - 1, aStack, bStack))) return false;
    }
  } // Remove the first object from the stack of traversed objects.


  aStack.pop();
  bStack.pop();
  return true;
}

function unwrap(a) {
  if (isObservableArray(a)) return a.slice();
  if (isES6Map(a) || isObservableMap(a)) return Array.from(a.entries());
  if (isES6Set(a) || isObservableSet(a)) return Array.from(a.entries());
  return a;
}

function makeIterable(iterator) {
  iterator[Symbol.iterator] = getSelf;
  return iterator;
}

function getSelf() {
  return this;
}

function isAnnotation(thing) {
  return (// Can be function
    thing instanceof Object && typeof thing.annotationType_ === "string" && isFunction(thing.make_) && isFunction(thing.extend_)
  );
}

/**
 * (c) Michel Weststrate 2015 - 2020
 * MIT Licensed
 *
 * Welcome to the mobx sources! To get an global overview of how MobX internally works,
 * this is a good place to start:
 * https://medium.com/@mweststrate/becoming-fully-reactive-an-in-depth-explanation-of-mobservable-55995262a254#.xvbh6qd74
 *
 * Source folders:
 * ===============
 *
 * - api/     Most of the public static methods exposed by the module can be found here.
 * - core/    Implementation of the MobX algorithm; atoms, derivations, reactions, dependency trees, optimizations. Cool stuff can be found here.
 * - types/   All the magic that is need to have observable objects, arrays and values is in this folder. Including the modifiers like `asFlat`.
 * - utils/   Utility stuff.
 *
 */
["Symbol", "Map", "Set"].forEach(function (m) {
  var g = getGlobal();

  if (typeof g[m] === "undefined") {
    die("MobX requires global '" + m + "' to be available or polyfilled");
  }
});

if (typeof __MOBX_DEVTOOLS_GLOBAL_HOOK__ === "object") {
  // See: https://github.com/andykog/mobx-devtools/
  __MOBX_DEVTOOLS_GLOBAL_HOOK__.injectMobx({
    spy: spy,
    extras: {
      getDebugName: getDebugName
    },
    $mobx: $mobx
  });
}


//# sourceMappingURL=mobx.esm.js.map

;// CONCATENATED MODULE: ./src/pages/common/utils/url.ts
/**
 * Returns hostname from url.
 * Uses `URL` constructor to get hostname.
 *
 * Needed for getting correct cosmetic result for the current page,
 * e.g. used by getEngineCosmeticResult().
 *
 * @see {@link https://github.com/AdguardTeam/AdguardForiOS/issues/1897}
 *
 * @param url Url to get hostname from.
 * @returns Hostname.
 */
var getHostname = function getHostname(url) {
  var _URL = new URL(url),
      hostname = _URL.hostname;

  return hostname;
};
/**
 * Crops `www.` from the beginning of the hostname if it exists.
 * Otherwise returns hostname as is.
 *
 * @param hostname Hostname to crop.
 * @returns Cropped domain.
 */

var getCroppedDomain = function getCroppedDomain(hostname) {
  return hostname.startsWith('www.') ? hostname.substring(4) : hostname;
};
/**
 * Returns domain name from url.
 * Uses `URL` constructor to get domain.
 *
 * Strips `www.` from the beginning of the domain if it exists,
 * e.g. used for disabling and enabling protection on the current site (allowlist).
 *
 * @param url Url to get domain from.
 * @returns Domain name.
 */

var getDomain = function getDomain(url) {
  var hostname = getHostname(url);
  return getCroppedDomain(hostname);
};
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
;// CONCATENATED MODULE: ./src/pages/common/messenger/Messenger.ts







var Messenger = /*#__PURE__*/function () {
  function Messenger() {
    var _this = this;

    _classCallCheck(this, Messenger);

    this.getPopupData = function (url) {
      return _this.sendMessage(MessagesToBackgroundPage.GetPopupData, {
        url: url
      });
    };

    this.setPermissionsModalViewed = function () {
      return _this.sendMessage(MessagesToBackgroundPage.SetPermissionsModalViewed);
    };

    this.setProtectionStatus = function (protectionStatus, url) {
      return _this.sendMessage(MessagesToBackgroundPage.SetProtectionStatus, {
        enabled: protectionStatus,
        url: url
      });
    };

    this.enableSafariProtection = function (url) {
      return _this.sendMessage(MessagesToBackgroundPage.EnableSafariProtection, {
        url: url
      });
    };

    this.deleteUserRules = function (url) {
      return _this.sendMessage(MessagesToBackgroundPage.DeleteUserRulesByUrl, {
        url: url
      });
    };

    this.reportProblem = function (url) {
      return _this.sendMessage(MessagesToBackgroundPage.ReportProblem, {
        url: url
      });
    };

    this.handleUpgrade = function () {
      return _this.sendMessage(MessagesToBackgroundPage.UpgradeClicked);
    };

    this.enableAdvancedBlocking = function () {
      return _this.sendMessage(MessagesToBackgroundPage.EnableAdvancedBlocking);
    };
  }

  _createClass(Messenger, [{
    key: "sendMessage",
    value: // eslint-disable-next-line class-methods-use-this
    function () {
      var _sendMessage = _asyncToGenerator( /*#__PURE__*/regenerator_default().mark(function _callee(type, data) {
        var message, response;
        return regenerator_default().wrap(function _callee$(_context) {
          while (1) switch (_context.prev = _context.next) {
            case 0:
              message = {
                type: type
              };

              if (data) {
                message.data = data;
              }

              log_log.debug('Request message:', message);
              _context.next = 5;
              return browser_polyfill_default().runtime.sendMessage(message);

            case 5:
              response = _context.sent;

              if (response) {
                log_log.debug('On message:', message);
                log_log.debug('Received response:', response);
              }

              return _context.abrupt("return", response);

            case 8:
            case "end":
              return _context.stop();
          }
        }, _callee);
      }));

      function sendMessage(_x, _x2) {
        return _sendMessage.apply(this, arguments);
      }

      return sendMessage;
    }()
  }]);

  return Messenger;
}();
;// CONCATENATED MODULE: ./src/pages/common/messenger/index.ts

var messenger = new Messenger();
// EXTERNAL MODULE: ./node_modules/axios/index.js
var axios = __webpack_require__(9669);
var axios_default = /*#__PURE__*/__webpack_require__.n(axios);
;// CONCATENATED MODULE: ./src/pages/popup/image-utils.ts





var FALLBACK_ICON_COLOR = '67b279';

var toDataUrl = /*#__PURE__*/function () {
  var _ref = _asyncToGenerator( /*#__PURE__*/regenerator_default().mark(function _callee(url) {
    var response;
    return regenerator_default().wrap(function _callee$(_context) {
      while (1) switch (_context.prev = _context.next) {
        case 0:
          _context.next = 2;
          return axios_default()(url, {
            responseType: 'blob'
          });

        case 2:
          response = _context.sent;
          return _context.abrupt("return", new Promise(function (resolve, reject) {
            var reader = new FileReader();

            reader.onloadend = function () {
              return resolve(reader.result);
            };

            reader.onerror = reject;
            reader.readAsDataURL(response.data);
          }));

        case 4:
        case "end":
          return _context.stop();
      }
    }, _callee);
  }));

  return function toDataUrl(_x) {
    return _ref.apply(this, arguments);
  };
}();

var getFaviconDataUrl = /*#__PURE__*/function () {
  var _ref2 = _asyncToGenerator( /*#__PURE__*/regenerator_default().mark(function _callee3(url) {
    var domain, ADGUARD_FAVICON_SERVICE_URL, favIconUrl, TIMEOUT_MS, timeoutPromise, toDataUrlPromise;
    return regenerator_default().wrap(function _callee3$(_context3) {
      while (1) switch (_context3.prev = _context3.next) {
        case 0:
          if (url) {
            _context3.next = 2;
            break;
          }

          return _context3.abrupt("return", null);

        case 2:
          domain = getDomain(url);

          if (domain) {
            _context3.next = 5;
            break;
          }

          return _context3.abrupt("return", null);

        case 5:
          // eslint-disable-next-line max-len
          ADGUARD_FAVICON_SERVICE_URL = "https://icons.adguard.org/icon?fallback_icon_color=".concat(FALLBACK_ICON_COLOR, "&domain=");
          favIconUrl = "".concat(ADGUARD_FAVICON_SERVICE_URL).concat(domain);
          TIMEOUT_MS = 1000;
          timeoutPromise = new Promise(function (resolve) {
            setTimeout(function () {
              resolve(null);
            }, TIMEOUT_MS);
          }); // eslint-disable-next-line @typescript-eslint/no-shadow

          toDataUrlPromise = /*#__PURE__*/function () {
            var _ref3 = _asyncToGenerator( /*#__PURE__*/regenerator_default().mark(function _callee2(favIconUrl) {
              var result;
              return regenerator_default().wrap(function _callee2$(_context2) {
                while (1) switch (_context2.prev = _context2.next) {
                  case 0:
                    _context2.prev = 0;
                    _context2.next = 3;
                    return toDataUrl(favIconUrl);

                  case 3:
                    result = _context2.sent;
                    return _context2.abrupt("return", result);

                  case 7:
                    _context2.prev = 7;
                    _context2.t0 = _context2["catch"](0);
                    log_log.error('Unable to get favicon data url', _context2.t0);
                    return _context2.abrupt("return", null);

                  case 11:
                  case "end":
                    return _context2.stop();
                }
              }, _callee2, null, [[0, 7]]);
            }));

            return function toDataUrlPromise(_x3) {
              return _ref3.apply(this, arguments);
            };
          }();

          _context3.next = 12;
          return Promise.race([timeoutPromise, toDataUrlPromise(favIconUrl)]);

        case 12:
          return _context3.abrupt("return", _context3.sent);

        case 13:
        case "end":
          return _context3.stop();
      }
    }, _callee3);
  }));

  return function getFaviconDataUrl(_x2) {
    return _ref2.apply(this, arguments);
  };
}();
;// CONCATENATED MODULE: ./src/pages/popup/constants.ts
var SiteStatus;

(function (SiteStatus) {
  SiteStatus["ProtectionStarting"] = "ProtectionStarting";
  SiteStatus["ProtectionEnabled"] = "ProtectionEnabled";
  SiteStatus["ProtectionDisabled"] = "ProtectionDisabled";
  SiteStatus["Allowlisted"] = "Allowlisted";
  SiteStatus["AllowlistedInverted"] = "AllowlistedInverted";
  SiteStatus["BasicOnly"] = "BasicOnly";
})(SiteStatus || (SiteStatus = {}));
;// CONCATENATED MODULE: ./src/pages/popup/stores/PopupStore.ts








var _class, _descriptor, _descriptor2, _descriptor3, _descriptor4, _descriptor5, _descriptor6, _descriptor7, _descriptor8, _descriptor9, _descriptor10, _descriptor11, _descriptor12, _descriptor13, _descriptor14, _descriptor15, _descriptor16, _descriptor17, _descriptor18, _descriptor19, _descriptor20, _descriptor21, _descriptor22;









 // Do not allow property change outside of store actions

configure({
  enforceActions: 'observed'
});
var PopupDataLoadingState;

(function (PopupDataLoadingState) {
  PopupDataLoadingState["Idle"] = "Idle";
  PopupDataLoadingState["Loading"] = "Loading";
  PopupDataLoadingState["Done"] = "Done";
})(PopupDataLoadingState || (PopupDataLoadingState = {}));

var PopupStore = (_class = /*#__PURE__*/function () {
  function PopupStore() {
    _classCallCheck(this, PopupStore);

    _initializerDefineProperty(this, "popupDataLoadingState", _descriptor, this);

    _initializerDefineProperty(this, "currentSiteStatus", _descriptor2, this);

    _initializerDefineProperty(this, "currentSiteUrl", _descriptor3, this);

    _initializerDefineProperty(this, "currentSiteFaviconDataUrl", _descriptor4, this);

    _initializerDefineProperty(this, "permissionsModalViewed", _descriptor5, this);

    _initializerDefineProperty(this, "allSitesAllowed", _descriptor6, this);

    _initializerDefineProperty(this, "protectionEnabled", _descriptor7, this);

    _initializerDefineProperty(this, "safariProtectionEnabled", _descriptor8, this);

    _initializerDefineProperty(this, "hasUserRules", _descriptor9, this);

    _initializerDefineProperty(this, "upgradeModalVisible", _descriptor10, this);

    _initializerDefineProperty(this, "isFullscreen", _descriptor11, this);

    _initializerDefineProperty(this, "protectionModalVisible", _descriptor12, this);

    _initializerDefineProperty(this, "contentBlockersEnabled", _descriptor13, this);

    _initializerDefineProperty(this, "appearanceTheme", _descriptor14, this);

    _initializerDefineProperty(this, "advancedBlockingEnabled", _descriptor15, this);

    _initializerDefineProperty(this, "allowlistInverted", _descriptor16, this);

    _initializerDefineProperty(this, "advancedBlockingModalVisible", _descriptor17, this);

    _initializerDefineProperty(this, "platform", _descriptor18, this);

    _initializerDefineProperty(this, "popupExpanded", _descriptor19, this);

    /**
     * Flag variable
     * - true means that app is premium (user bought it),
     * - false means that app is free
     */
    _initializerDefineProperty(this, "premiumApp", _descriptor20, this);

    _initializerDefineProperty(this, "getPopupData", _descriptor21, this);

    _initializerDefineProperty(this, "setPermissionsModalViewed", _descriptor22, this);

    makeObservable(this);
  }

  _createClass(PopupStore, [{
    key: "currentSiteDomain",
    get: function get() {
      if (!this.currentSiteUrl) {
        return '';
      }

      return getDomain(this.currentSiteUrl);
    }
  }, {
    key: "toggleProtection",
    value: function () {
      var _toggleProtection = _asyncToGenerator( /*#__PURE__*/regenerator_default().mark(function _callee() {
        var _this = this;

        var prevState;
        return regenerator_default().wrap(function _callee$(_context) {
          while (1) switch (_context.prev = _context.next) {
            case 0:
              if (!(!this.currentSiteUrl || !this.currentSiteDomain)) {
                _context.next = 2;
                break;
              }

              return _context.abrupt("return");

            case 2:
              prevState = this.protectionEnabled;
              this.protectionEnabled = !this.protectionEnabled;
              _context.prev = 4;
              _context.next = 7;
              return messenger.setProtectionStatus(this.protectionEnabled, this.currentSiteUrl);

            case 7:
              _context.next = 12;
              break;

            case 9:
              _context.prev = 9;
              _context.t0 = _context["catch"](4);
              mobx_esm_runInAction(function () {
                _this.protectionEnabled = prevState;
              });

            case 12:
            case "end":
              return _context.stop();
          }
        }, _callee, this, [[4, 9]]);
      }));

      function toggleProtection() {
        return _toggleProtection.apply(this, arguments);
      }

      return toggleProtection;
    }()
  }, {
    key: "deleteUserRules",
    value: function () {
      var _deleteUserRules = _asyncToGenerator( /*#__PURE__*/regenerator_default().mark(function _callee2() {
        return regenerator_default().wrap(function _callee2$(_context2) {
          while (1) switch (_context2.prev = _context2.next) {
            case 0:
              if (!this.currentSiteUrl) {
                _context2.next = 3;
                break;
              }

              _context2.next = 3;
              return messenger.deleteUserRules(this.currentSiteUrl);

            case 3:
            case "end":
              return _context2.stop();
          }
        }, _callee2, this);
      }));

      function deleteUserRules() {
        return _deleteUserRules.apply(this, arguments);
      }

      return deleteUserRules;
    }()
  }, {
    key: "showUpgradeModal",
    value: function showUpgradeModal() {
      this.upgradeModalVisible = true;
    }
  }, {
    key: "hideUpgradeModal",
    value: function hideUpgradeModal() {
      this.upgradeModalVisible = false;
    }
  }, {
    key: "showAdvancedBlockingDisabledModal",
    value: function showAdvancedBlockingDisabledModal() {
      this.advancedBlockingModalVisible = true;
    }
  }, {
    key: "hideAdvancedBlockingModal",
    value: function hideAdvancedBlockingModal() {
      this.advancedBlockingModalVisible = false;
    }
  }, {
    key: "setFullscreen",
    value: function setFullscreen(isFullscreen) {
      this.isFullscreen = isFullscreen;
    }
  }, {
    key: "setProtectionModalVisibleState",
    value: function setProtectionModalVisibleState(state) {
      this.protectionModalVisible = state;
    }
  }, {
    key: "enableSafariProtection",
    value: function () {
      var _enableSafariProtection = _asyncToGenerator( /*#__PURE__*/regenerator_default().mark(function _callee3() {
        return regenerator_default().wrap(function _callee3$(_context3) {
          while (1) switch (_context3.prev = _context3.next) {
            case 0:
              if (this.currentSiteUrl) {
                _context3.next = 2;
                break;
              }

              return _context3.abrupt("return");

            case 2:
              _context3.next = 4;
              return messenger.enableSafariProtection(this.currentSiteUrl);

            case 4:
            case "end":
              return _context3.stop();
          }
        }, _callee3, this);
      }));

      function enableSafariProtection() {
        return _enableSafariProtection.apply(this, arguments);
      }

      return enableSafariProtection;
    }()
  }, {
    key: "togglePopupExpanded",
    value: function togglePopupExpanded() {
      this.popupExpanded = !this.popupExpanded;
    }
  }]);

  return PopupStore;
}(), (_descriptor = _applyDecoratedDescriptor(_class.prototype, "popupDataLoadingState", [mobx_esm_observable], {
  configurable: true,
  enumerable: true,
  writable: true,
  initializer: function initializer() {
    return PopupDataLoadingState.Idle;
  }
}), _descriptor2 = _applyDecoratedDescriptor(_class.prototype, "currentSiteStatus", [mobx_esm_observable], {
  configurable: true,
  enumerable: true,
  writable: true,
  initializer: function initializer() {
    return SiteStatus.ProtectionEnabled;
  }
}), _descriptor3 = _applyDecoratedDescriptor(_class.prototype, "currentSiteUrl", [mobx_esm_observable], {
  configurable: true,
  enumerable: true,
  writable: true,
  initializer: null
}), _descriptor4 = _applyDecoratedDescriptor(_class.prototype, "currentSiteFaviconDataUrl", [mobx_esm_observable], {
  configurable: true,
  enumerable: true,
  writable: true,
  initializer: null
}), _descriptor5 = _applyDecoratedDescriptor(_class.prototype, "permissionsModalViewed", [mobx_esm_observable], {
  configurable: true,
  enumerable: true,
  writable: true,
  initializer: null
}), _descriptor6 = _applyDecoratedDescriptor(_class.prototype, "allSitesAllowed", [mobx_esm_observable], {
  configurable: true,
  enumerable: true,
  writable: true,
  initializer: null
}), _descriptor7 = _applyDecoratedDescriptor(_class.prototype, "protectionEnabled", [mobx_esm_observable], {
  configurable: true,
  enumerable: true,
  writable: true,
  initializer: function initializer() {
    return false;
  }
}), _descriptor8 = _applyDecoratedDescriptor(_class.prototype, "safariProtectionEnabled", [mobx_esm_observable], {
  configurable: true,
  enumerable: true,
  writable: true,
  initializer: function initializer() {
    return false;
  }
}), _descriptor9 = _applyDecoratedDescriptor(_class.prototype, "hasUserRules", [mobx_esm_observable], {
  configurable: true,
  enumerable: true,
  writable: true,
  initializer: function initializer() {
    return false;
  }
}), _descriptor10 = _applyDecoratedDescriptor(_class.prototype, "upgradeModalVisible", [mobx_esm_observable], {
  configurable: true,
  enumerable: true,
  writable: true,
  initializer: function initializer() {
    return false;
  }
}), _descriptor11 = _applyDecoratedDescriptor(_class.prototype, "isFullscreen", [mobx_esm_observable], {
  configurable: true,
  enumerable: true,
  writable: true,
  initializer: function initializer() {
    return false;
  }
}), _descriptor12 = _applyDecoratedDescriptor(_class.prototype, "protectionModalVisible", [mobx_esm_observable], {
  configurable: true,
  enumerable: true,
  writable: true,
  initializer: function initializer() {
    return false;
  }
}), _descriptor13 = _applyDecoratedDescriptor(_class.prototype, "contentBlockersEnabled", [mobx_esm_observable], {
  configurable: true,
  enumerable: true,
  writable: true,
  initializer: function initializer() {
    return false;
  }
}), _descriptor14 = _applyDecoratedDescriptor(_class.prototype, "appearanceTheme", [mobx_esm_observable], {
  configurable: true,
  enumerable: true,
  writable: true,
  initializer: null
}), _descriptor15 = _applyDecoratedDescriptor(_class.prototype, "advancedBlockingEnabled", [mobx_esm_observable], {
  configurable: true,
  enumerable: true,
  writable: true,
  initializer: function initializer() {
    return false;
  }
}), _descriptor16 = _applyDecoratedDescriptor(_class.prototype, "allowlistInverted", [mobx_esm_observable], {
  configurable: true,
  enumerable: true,
  writable: true,
  initializer: function initializer() {
    return false;
  }
}), _descriptor17 = _applyDecoratedDescriptor(_class.prototype, "advancedBlockingModalVisible", [mobx_esm_observable], {
  configurable: true,
  enumerable: true,
  writable: true,
  initializer: function initializer() {
    return false;
  }
}), _descriptor18 = _applyDecoratedDescriptor(_class.prototype, "platform", [mobx_esm_observable], {
  configurable: true,
  enumerable: true,
  writable: true,
  initializer: function initializer() {
    return Platform.IPhone;
  }
}), _descriptor19 = _applyDecoratedDescriptor(_class.prototype, "popupExpanded", [mobx_esm_observable], {
  configurable: true,
  enumerable: true,
  writable: true,
  initializer: function initializer() {
    return false;
  }
}), _descriptor20 = _applyDecoratedDescriptor(_class.prototype, "premiumApp", [mobx_esm_observable], {
  configurable: true,
  enumerable: true,
  writable: true,
  initializer: function initializer() {
    return false;
  }
}), _descriptor21 = _applyDecoratedDescriptor(_class.prototype, "getPopupData", [action], {
  configurable: true,
  enumerable: true,
  writable: true,
  initializer: function initializer() {
    var _this2 = this;

    return /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regenerator_default().mark(function _callee4() {
      var _yield$browser$tabs$q, _yield$browser$tabs$q2, currentTab, _yield$Promise$all, _yield$Promise$all2, popupData, currentSiteFaviconDataUrl;

      return regenerator_default().wrap(function _callee4$(_context4) {
        while (1) switch (_context4.prev = _context4.next) {
          case 0:
            _this2.popupDataLoadingState = PopupDataLoadingState.Loading;
            _context4.next = 3;
            return browser_polyfill_default().tabs.query({
              active: true,
              currentWindow: true
            });

          case 3:
            _yield$browser$tabs$q = _context4.sent;
            _yield$browser$tabs$q2 = _slicedToArray(_yield$browser$tabs$q, 1);
            currentTab = _yield$browser$tabs$q2[0];
            _context4.next = 8;
            return Promise.all([messenger.getPopupData(currentTab.url), getFaviconDataUrl(currentTab.url)]);

          case 8:
            _yield$Promise$all = _context4.sent;
            _yield$Promise$all2 = _slicedToArray(_yield$Promise$all, 2);
            popupData = _yield$Promise$all2[0];
            currentSiteFaviconDataUrl = _yield$Promise$all2[1];
            mobx_esm_runInAction(function () {
              _this2.popupDataLoadingState = PopupDataLoadingState.Done;
              _this2.currentSiteUrl = currentTab.url;

              if (currentSiteFaviconDataUrl) {
                _this2.currentSiteFaviconDataUrl = currentSiteFaviconDataUrl;
              }

              var data = popupData;
              _this2.permissionsModalViewed = data.permissionsModalViewed;
              _this2.allSitesAllowed = data.allSitesAllowed;
              _this2.protectionEnabled = data.protectionEnabled;
              _this2.safariProtectionEnabled = data.safariProtectionEnabled;
              _this2.hasUserRules = data.hasUserRules;
              _this2.premiumApp = data.premiumApp;
              _this2.contentBlockersEnabled = data.contentBlockersEnabled;
              _this2.protectionModalVisible = !data.contentBlockersEnabled;
              _this2.appearanceTheme = data.appearanceTheme;
              _this2.advancedBlockingEnabled = data.advancedBlockingEnabled;
              _this2.allowlistInverted = data.allowlistInverted;
              _this2.platform = data.platform;
            });

          case 13:
          case "end":
            return _context4.stop();
        }
      }, _callee4);
    }));
  }
}), _descriptor22 = _applyDecoratedDescriptor(_class.prototype, "setPermissionsModalViewed", [action], {
  configurable: true,
  enumerable: true,
  writable: true,
  initializer: function initializer() {
    var _this3 = this;

    return /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regenerator_default().mark(function _callee5() {
      return regenerator_default().wrap(function _callee5$(_context5) {
        while (1) switch (_context5.prev = _context5.next) {
          case 0:
            _context5.next = 2;
            return messenger.setPermissionsModalViewed();

          case 2:
            mobx_esm_runInAction(function () {
              _this3.permissionsModalViewed = true;
            });

          case 3:
          case "end":
            return _context5.stop();
        }
      }, _callee5);
    }));
  }
}), _applyDecoratedDescriptor(_class.prototype, "currentSiteDomain", [computed], Object.getOwnPropertyDescriptor(_class.prototype, "currentSiteDomain"), _class.prototype), _applyDecoratedDescriptor(_class.prototype, "toggleProtection", [action], Object.getOwnPropertyDescriptor(_class.prototype, "toggleProtection"), _class.prototype), _applyDecoratedDescriptor(_class.prototype, "deleteUserRules", [action], Object.getOwnPropertyDescriptor(_class.prototype, "deleteUserRules"), _class.prototype), _applyDecoratedDescriptor(_class.prototype, "showUpgradeModal", [action], Object.getOwnPropertyDescriptor(_class.prototype, "showUpgradeModal"), _class.prototype), _applyDecoratedDescriptor(_class.prototype, "hideUpgradeModal", [action], Object.getOwnPropertyDescriptor(_class.prototype, "hideUpgradeModal"), _class.prototype), _applyDecoratedDescriptor(_class.prototype, "showAdvancedBlockingDisabledModal", [action], Object.getOwnPropertyDescriptor(_class.prototype, "showAdvancedBlockingDisabledModal"), _class.prototype), _applyDecoratedDescriptor(_class.prototype, "hideAdvancedBlockingModal", [action], Object.getOwnPropertyDescriptor(_class.prototype, "hideAdvancedBlockingModal"), _class.prototype), _applyDecoratedDescriptor(_class.prototype, "setFullscreen", [action], Object.getOwnPropertyDescriptor(_class.prototype, "setFullscreen"), _class.prototype), _applyDecoratedDescriptor(_class.prototype, "setProtectionModalVisibleState", [action], Object.getOwnPropertyDescriptor(_class.prototype, "setProtectionModalVisibleState"), _class.prototype), _applyDecoratedDescriptor(_class.prototype, "enableSafariProtection", [action], Object.getOwnPropertyDescriptor(_class.prototype, "enableSafariProtection"), _class.prototype), _applyDecoratedDescriptor(_class.prototype, "togglePopupExpanded", [action], Object.getOwnPropertyDescriptor(_class.prototype, "togglePopupExpanded"), _class.prototype)), _class);
var popupStoreValue = new PopupStore();
var PopupStoreContext = /*#__PURE__*/(0,react.createContext)(popupStoreValue);
var popupStore = PopupStoreContext;
;// CONCATENATED MODULE: ./node_modules/mobx-react-lite/es/utils/assertEnvironment.js


if (!react.useState) {
    throw new Error("mobx-react-lite requires React with Hooks support");
}
if (!makeObservable) {
    throw new Error("mobx-react-lite@3 requires mobx at least version 6 to be available");
}
//# sourceMappingURL=assertEnvironment.js.map
;// CONCATENATED MODULE: ./node_modules/mobx-react-lite/es/utils/reactBatchedUpdates.js

//# sourceMappingURL=reactBatchedUpdates.js.map
;// CONCATENATED MODULE: ./node_modules/mobx-react-lite/es/utils/observerBatching.js

function defaultNoopBatch(callback) {
    callback();
}
function observerBatching(reactionScheduler) {
    if (!reactionScheduler) {
        reactionScheduler = defaultNoopBatch;
        if (false) {}
    }
    configure({ reactionScheduler: reactionScheduler });
}
var isObserverBatched = function () {
    if (false) {}
    return true;
};
//# sourceMappingURL=observerBatching.js.map
;// CONCATENATED MODULE: ./node_modules/mobx-react-lite/es/utils/utils.js
var __read = (undefined && undefined.__read) || function (o, n) {
    var m = typeof Symbol === "function" && o[Symbol.iterator];
    if (!m) return o;
    var i = m.call(o), r, ar = [], e;
    try {
        while ((n === void 0 || n-- > 0) && !(r = i.next()).done) ar.push(r.value);
    }
    catch (error) { e = { error: error }; }
    finally {
        try {
            if (r && !r.done && (m = i["return"])) m.call(i);
        }
        finally { if (e) throw e.error; }
    }
    return ar;
};

var utils_EMPTY_ARRAY = [];
function useForceUpdate() {
    var _a = __read((0,react.useState)(0), 2), setTick = _a[1];
    var update = (0,react.useCallback)(function () {
        setTick(function (tick) { return tick + 1; });
    }, utils_EMPTY_ARRAY);
    return update;
}
var deprecatedMessages = (/* unused pure expression or super */ null && ([]));
function useDeprecated(msg) {
    if (!deprecatedMessages.includes(msg)) {
        deprecatedMessages.push(msg);
        console.warn(msg);
    }
}
//# sourceMappingURL=utils.js.map
;// CONCATENATED MODULE: ./node_modules/mobx-react-lite/es/utils/printDebugValue.js

function printDebugValue(v) {
    return getDependencyTree(v);
}
//# sourceMappingURL=printDebugValue.js.map
;// CONCATENATED MODULE: ./node_modules/mobx-react-lite/es/utils/FinalizationRegistryWrapper.js
var FinalizationRegistryLocal = typeof FinalizationRegistry === "undefined" ? undefined : FinalizationRegistry;

//# sourceMappingURL=FinalizationRegistryWrapper.js.map
;// CONCATENATED MODULE: ./node_modules/mobx-react-lite/es/utils/reactionCleanupTrackingCommon.js
function createTrackingData(reaction) {
    var trackingData = {
        reaction: reaction,
        mounted: false,
        changedBeforeMount: false,
        cleanAt: Date.now() + CLEANUP_LEAKED_REACTIONS_AFTER_MILLIS
    };
    return trackingData;
}
/**
 * The minimum time before we'll clean up a Reaction created in a render
 * for a component that hasn't managed to run its effects. This needs to
 * be big enough to ensure that a component won't turn up and have its
 * effects run without being re-rendered.
 */
var CLEANUP_LEAKED_REACTIONS_AFTER_MILLIS = 10000;
/**
 * The frequency with which we'll check for leaked reactions.
 */
var CLEANUP_TIMER_LOOP_MILLIS = 10000;
//# sourceMappingURL=reactionCleanupTrackingCommon.js.map
;// CONCATENATED MODULE: ./node_modules/mobx-react-lite/es/utils/createReactionCleanupTrackingUsingFinalizationRegister.js

/**
 * FinalizationRegistry-based uncommitted reaction cleanup
 */
function createReactionCleanupTrackingUsingFinalizationRegister(FinalizationRegistry) {
    var cleanupTokenToReactionTrackingMap = new Map();
    var globalCleanupTokensCounter = 1;
    var registry = new FinalizationRegistry(function cleanupFunction(token) {
        var trackedReaction = cleanupTokenToReactionTrackingMap.get(token);
        if (trackedReaction) {
            trackedReaction.reaction.dispose();
            cleanupTokenToReactionTrackingMap.delete(token);
        }
    });
    return {
        addReactionToTrack: function (reactionTrackingRef, reaction, objectRetainedByReact) {
            var token = globalCleanupTokensCounter++;
            registry.register(objectRetainedByReact, token, reactionTrackingRef);
            reactionTrackingRef.current = createTrackingData(reaction);
            reactionTrackingRef.current.finalizationRegistryCleanupToken = token;
            cleanupTokenToReactionTrackingMap.set(token, reactionTrackingRef.current);
            return reactionTrackingRef.current;
        },
        recordReactionAsCommitted: function (reactionRef) {
            registry.unregister(reactionRef);
            if (reactionRef.current && reactionRef.current.finalizationRegistryCleanupToken) {
                cleanupTokenToReactionTrackingMap.delete(reactionRef.current.finalizationRegistryCleanupToken);
            }
        },
        forceCleanupTimerToRunNowForTests: function () {
            // When FinalizationRegistry in use, this this is no-op
        },
        resetCleanupScheduleForTests: function () {
            // When FinalizationRegistry in use, this this is no-op
        }
    };
}
//# sourceMappingURL=createReactionCleanupTrackingUsingFinalizationRegister.js.map
;// CONCATENATED MODULE: ./node_modules/mobx-react-lite/es/utils/createTimerBasedReactionCleanupTracking.js
var __values = (undefined && undefined.__values) || function(o) {
    var s = typeof Symbol === "function" && Symbol.iterator, m = s && o[s], i = 0;
    if (m) return m.call(o);
    if (o && typeof o.length === "number") return {
        next: function () {
            if (o && i >= o.length) o = void 0;
            return { value: o && o[i++], done: !o };
        }
    };
    throw new TypeError(s ? "Object is not iterable." : "Symbol.iterator is not defined.");
};

/**
 * timers, gc-style, uncommitted reaction cleanup
 */
function createTimerBasedReactionCleanupTracking() {
    /**
     * Reactions created by components that have yet to be fully mounted.
     */
    var uncommittedReactionRefs = new Set();
    /**
     * Latest 'uncommitted reactions' cleanup timer handle.
     */
    var reactionCleanupHandle;
    /* istanbul ignore next */
    /**
     * Only to be used by test functions; do not export outside of mobx-react-lite
     */
    function forceCleanupTimerToRunNowForTests() {
        // This allows us to control the execution of the cleanup timer
        // to force it to run at awkward times in unit tests.
        if (reactionCleanupHandle) {
            clearTimeout(reactionCleanupHandle);
            cleanUncommittedReactions();
        }
    }
    /* istanbul ignore next */
    function resetCleanupScheduleForTests() {
        var e_1, _a;
        if (uncommittedReactionRefs.size > 0) {
            try {
                for (var uncommittedReactionRefs_1 = __values(uncommittedReactionRefs), uncommittedReactionRefs_1_1 = uncommittedReactionRefs_1.next(); !uncommittedReactionRefs_1_1.done; uncommittedReactionRefs_1_1 = uncommittedReactionRefs_1.next()) {
                    var ref = uncommittedReactionRefs_1_1.value;
                    var tracking = ref.current;
                    if (tracking) {
                        tracking.reaction.dispose();
                        ref.current = null;
                    }
                }
            }
            catch (e_1_1) { e_1 = { error: e_1_1 }; }
            finally {
                try {
                    if (uncommittedReactionRefs_1_1 && !uncommittedReactionRefs_1_1.done && (_a = uncommittedReactionRefs_1.return)) _a.call(uncommittedReactionRefs_1);
                }
                finally { if (e_1) throw e_1.error; }
            }
            uncommittedReactionRefs.clear();
        }
        if (reactionCleanupHandle) {
            clearTimeout(reactionCleanupHandle);
            reactionCleanupHandle = undefined;
        }
    }
    function ensureCleanupTimerRunning() {
        if (reactionCleanupHandle === undefined) {
            reactionCleanupHandle = setTimeout(cleanUncommittedReactions, CLEANUP_TIMER_LOOP_MILLIS);
        }
    }
    function scheduleCleanupOfReactionIfLeaked(ref) {
        uncommittedReactionRefs.add(ref);
        ensureCleanupTimerRunning();
    }
    function recordReactionAsCommitted(reactionRef) {
        uncommittedReactionRefs.delete(reactionRef);
    }
    /**
     * Run by the cleanup timer to dispose any outstanding reactions
     */
    function cleanUncommittedReactions() {
        reactionCleanupHandle = undefined;
        // Loop through all the candidate leaked reactions; those older
        // than CLEANUP_LEAKED_REACTIONS_AFTER_MILLIS get tidied.
        var now = Date.now();
        uncommittedReactionRefs.forEach(function (ref) {
            var tracking = ref.current;
            if (tracking) {
                if (now >= tracking.cleanAt) {
                    // It's time to tidy up this leaked reaction.
                    tracking.reaction.dispose();
                    ref.current = null;
                    uncommittedReactionRefs.delete(ref);
                }
            }
        });
        if (uncommittedReactionRefs.size > 0) {
            // We've just finished a round of cleanups but there are still
            // some leak candidates outstanding.
            ensureCleanupTimerRunning();
        }
    }
    return {
        addReactionToTrack: function (reactionTrackingRef, reaction, 
        /**
         * On timer based implementation we don't really need this object,
         * but we keep the same api
         */
        objectRetainedByReact) {
            reactionTrackingRef.current = createTrackingData(reaction);
            scheduleCleanupOfReactionIfLeaked(reactionTrackingRef);
            return reactionTrackingRef.current;
        },
        recordReactionAsCommitted: recordReactionAsCommitted,
        forceCleanupTimerToRunNowForTests: forceCleanupTimerToRunNowForTests,
        resetCleanupScheduleForTests: resetCleanupScheduleForTests
    };
}
//# sourceMappingURL=createTimerBasedReactionCleanupTracking.js.map
;// CONCATENATED MODULE: ./node_modules/mobx-react-lite/es/utils/reactionCleanupTracking.js



var _a = FinalizationRegistryLocal
    ? createReactionCleanupTrackingUsingFinalizationRegister(FinalizationRegistryLocal)
    : createTimerBasedReactionCleanupTracking(), addReactionToTrack = _a.addReactionToTrack, recordReactionAsCommitted = _a.recordReactionAsCommitted, resetCleanupScheduleForTests = _a.resetCleanupScheduleForTests, forceCleanupTimerToRunNowForTests = _a.forceCleanupTimerToRunNowForTests;

//# sourceMappingURL=reactionCleanupTracking.js.map
;// CONCATENATED MODULE: ./node_modules/mobx-react-lite/es/staticRendering.js
var globalIsUsingStaticRendering = false;
function staticRendering_enableStaticRendering(enable) {
    globalIsUsingStaticRendering = enable;
}
function isUsingStaticRendering() {
    return globalIsUsingStaticRendering;
}
//# sourceMappingURL=staticRendering.js.map
;// CONCATENATED MODULE: ./node_modules/mobx-react-lite/es/useObserver.js
var useObserver_read = (undefined && undefined.__read) || function (o, n) {
    var m = typeof Symbol === "function" && o[Symbol.iterator];
    if (!m) return o;
    var i = m.call(o), r, ar = [], e;
    try {
        while ((n === void 0 || n-- > 0) && !(r = i.next()).done) ar.push(r.value);
    }
    catch (error) { e = { error: error }; }
    finally {
        try {
            if (r && !r.done && (m = i["return"])) m.call(i);
        }
        finally { if (e) throw e.error; }
    }
    return ar;
};






function observerComponentNameFor(baseComponentName) {
    return "observer" + baseComponentName;
}
/**
 * We use class to make it easier to detect in heap snapshots by name
 */
var ObjectToBeRetainedByReact = /** @class */ (function () {
    function ObjectToBeRetainedByReact() {
    }
    return ObjectToBeRetainedByReact;
}());
function useObserver(fn, baseComponentName) {
    if (baseComponentName === void 0) { baseComponentName = "observed"; }
    if (isUsingStaticRendering()) {
        return fn();
    }
    var _a = useObserver_read(react.useState(new ObjectToBeRetainedByReact()), 1), objectRetainedByReact = _a[0];
    var forceUpdate = useForceUpdate();
    // StrictMode/ConcurrentMode/Suspense may mean that our component is
    // rendered and abandoned multiple times, so we need to track leaked
    // Reactions.
    var reactionTrackingRef = react.useRef(null);
    if (!reactionTrackingRef.current) {
        // First render for this component (or first time since a previous
        // reaction from an abandoned render was disposed).
        var newReaction = new Reaction(observerComponentNameFor(baseComponentName), function () {
            // Observable has changed, meaning we want to re-render
            // BUT if we're a component that hasn't yet got to the useEffect()
            // stage, we might be a component that _started_ to render, but
            // got dropped, and we don't want to make state changes then.
            // (It triggers warnings in StrictMode, for a start.)
            if (trackingData_1.mounted) {
                // We have reached useEffect(), so we're mounted, and can trigger an update
                forceUpdate();
            }
            else {
                // We haven't yet reached useEffect(), so we'll need to trigger a re-render
                // when (and if) useEffect() arrives.
                trackingData_1.changedBeforeMount = true;
            }
        });
        var trackingData_1 = addReactionToTrack(reactionTrackingRef, newReaction, objectRetainedByReact);
    }
    var reaction = reactionTrackingRef.current.reaction;
    react.useDebugValue(reaction, printDebugValue);
    react.useEffect(function () {
        // Called on first mount only
        recordReactionAsCommitted(reactionTrackingRef);
        if (reactionTrackingRef.current) {
            // Great. We've already got our reaction from our render;
            // all we need to do is to record that it's now mounted,
            // to allow future observable changes to trigger re-renders
            reactionTrackingRef.current.mounted = true;
            // Got a change before first mount, force an update
            if (reactionTrackingRef.current.changedBeforeMount) {
                reactionTrackingRef.current.changedBeforeMount = false;
                forceUpdate();
            }
        }
        else {
            // The reaction we set up in our render has been disposed.
            // This can be due to bad timings of renderings, e.g. our
            // component was paused for a _very_ long time, and our
            // reaction got cleaned up
            // Re-create the reaction
            reactionTrackingRef.current = {
                reaction: new Reaction(observerComponentNameFor(baseComponentName), function () {
                    // We've definitely already been mounted at this point
                    forceUpdate();
                }),
                mounted: true,
                changedBeforeMount: false,
                cleanAt: Infinity
            };
            forceUpdate();
        }
        return function () {
            reactionTrackingRef.current.reaction.dispose();
            reactionTrackingRef.current = null;
        };
    }, []);
    // render the original component, but have the
    // reaction track the observables, so that rendering
    // can be invalidated (see above) once a dependency changes
    var rendering;
    var exception;
    reaction.track(function () {
        try {
            rendering = fn();
        }
        catch (e) {
            exception = e;
        }
    });
    if (exception) {
        throw exception; // re-throw any exceptions caught during rendering
    }
    return rendering;
}
//# sourceMappingURL=useObserver.js.map
;// CONCATENATED MODULE: ./node_modules/mobx-react-lite/es/observer.js
var __assign = (undefined && undefined.__assign) || function () {
    __assign = Object.assign || function(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
            s = arguments[i];
            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
                t[p] = s[p];
        }
        return t;
    };
    return __assign.apply(this, arguments);
};



// n.b. base case is not used for actual typings or exported in the typing files
function observer(baseComponent, options) {
    // The working of observer is explained step by step in this talk: https://www.youtube.com/watch?v=cPF4iBedoF0&feature=youtu.be&t=1307
    if (isUsingStaticRendering()) {
        return baseComponent;
    }
    var realOptions = __assign({ forwardRef: false }, options);
    var baseComponentName = baseComponent.displayName || baseComponent.name;
    var wrappedComponent = function (props, ref) {
        return useObserver(function () { return baseComponent(props, ref); }, baseComponentName);
    };
    wrappedComponent.displayName = baseComponentName;
    // memo; we are not interested in deep updates
    // in props; we assume that if deep objects are changed,
    // this is in observables, which would have been tracked anyway
    var memoComponent;
    if (realOptions.forwardRef) {
        // we have to use forwardRef here because:
        // 1. it cannot go before memo, only after it
        // 2. forwardRef converts the function into an actual component, so we can't let the baseComponent do it
        //    since it wouldn't be a callable function anymore
        memoComponent = (0,react.memo)((0,react.forwardRef)(wrappedComponent));
    }
    else {
        memoComponent = (0,react.memo)(wrappedComponent);
    }
    copyStaticProperties(baseComponent, memoComponent);
    memoComponent.displayName = baseComponentName;
    return memoComponent;
}
// based on https://github.com/mridgway/hoist-non-react-statics/blob/master/src/index.js
var hoistBlackList = {
    $$typeof: true,
    render: true,
    compare: true,
    type: true
};
function copyStaticProperties(base, target) {
    Object.keys(base).forEach(function (key) {
        if (!hoistBlackList[key]) {
            Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(base, key));
        }
    });
}
//# sourceMappingURL=observer.js.map
;// CONCATENATED MODULE: ./node_modules/mobx-react-lite/es/ObserverComponent.js

function ObserverComponent(_a) {
    var children = _a.children, render = _a.render;
    var component = children || render;
    if (typeof component !== "function") {
        return null;
    }
    return useObserver(component);
}
if (false) {}
ObserverComponent.displayName = "Observer";

function ObserverPropsCheck(props, key, componentName, location, propFullName) {
    var extraKey = key === "children" ? "render" : "children";
    var hasProp = typeof props[key] === "function";
    var hasExtraProp = typeof props[extraKey] === "function";
    if (hasProp && hasExtraProp) {
        return new Error("MobX Observer: Do not use children and render in the same time in`" + componentName);
    }
    if (hasProp || hasExtraProp) {
        return null;
    }
    return new Error("Invalid prop `" +
        propFullName +
        "` of type `" +
        typeof props[key] +
        "` supplied to" +
        " `" +
        componentName +
        "`, expected `function`.");
}
//# sourceMappingURL=ObserverComponent.js.map
;// CONCATENATED MODULE: ./node_modules/mobx-react-lite/es/useLocalObservable.js


function useLocalObservable(initializer, annotations) {
    return useState(function () { return observable(initializer(), annotations, { autoBind: true }); })[0];
}
//# sourceMappingURL=useLocalObservable.js.map
;// CONCATENATED MODULE: ./node_modules/mobx-react-lite/es/useAsObservableSource.js
var useAsObservableSource_read = (undefined && undefined.__read) || function (o, n) {
    var m = typeof Symbol === "function" && o[Symbol.iterator];
    if (!m) return o;
    var i = m.call(o), r, ar = [], e;
    try {
        while ((n === void 0 || n-- > 0) && !(r = i.next()).done) ar.push(r.value);
    }
    catch (error) { e = { error: error }; }
    finally {
        try {
            if (r && !r.done && (m = i["return"])) m.call(i);
        }
        finally { if (e) throw e.error; }
    }
    return ar;
};



function useAsObservableSource_useAsObservableSource(current) {
    if (false)
        {}
    var _a = useAsObservableSource_read(useState(function () { return observable(current, {}, { deep: false }); }), 1), res = _a[0];
    runInAction(function () {
        Object.assign(res, current);
    });
    return res;
}
//# sourceMappingURL=useAsObservableSource.js.map
;// CONCATENATED MODULE: ./node_modules/mobx-react-lite/es/useLocalStore.js




function useLocalStore(initializer, current) {
    if (false)
        {}
    var source = current && useAsObservableSource(current);
    return useState(function () { return observable(initializer(source), undefined, { autoBind: true }); })[0];
}
//# sourceMappingURL=useLocalStore.js.map
;// CONCATENATED MODULE: ./node_modules/mobx-react-lite/es/index.js






observerBatching(react_dom.unstable_batchedUpdates);







function es_useObserver(fn, baseComponentName) {
    if (baseComponentName === void 0) { baseComponentName = "observed"; }
    if (false) {}
    return useObserverOriginal(fn, baseComponentName);
}

function useStaticRendering(enable) {
    if (false) {}
    enableStaticRendering(enable);
}
//# sourceMappingURL=index.js.map
;// CONCATENATED MODULE: ./node_modules/mobx-react/dist/mobxreact.esm.js





var symbolId = 0;

function createSymbol(name) {
  if (typeof Symbol === "function") {
    return Symbol(name);
  }

  var symbol = "__$mobx-react " + name + " (" + symbolId + ")";
  symbolId++;
  return symbol;
}

var createdSymbols = {};
function newSymbol(name) {
  if (!createdSymbols[name]) {
    createdSymbols[name] = createSymbol(name);
  }

  return createdSymbols[name];
}
function shallowEqual(objA, objB) {
  //From: https://github.com/facebook/fbjs/blob/c69904a511b900266935168223063dd8772dfc40/packages/fbjs/src/core/shallowEqual.js
  if (is(objA, objB)) return true;

  if (typeof objA !== "object" || objA === null || typeof objB !== "object" || objB === null) {
    return false;
  }

  var keysA = Object.keys(objA);
  var keysB = Object.keys(objB);
  if (keysA.length !== keysB.length) return false;

  for (var i = 0; i < keysA.length; i++) {
    if (!Object.hasOwnProperty.call(objB, keysA[i]) || !is(objA[keysA[i]], objB[keysA[i]])) {
      return false;
    }
  }

  return true;
}

function is(x, y) {
  // From: https://github.com/facebook/fbjs/blob/c69904a511b900266935168223063dd8772dfc40/packages/fbjs/src/core/shallowEqual.js
  if (x === y) {
    return x !== 0 || 1 / x === 1 / y;
  } else {
    return x !== x && y !== y;
  }
} // based on https://github.com/mridgway/hoist-non-react-statics/blob/master/src/index.js


var mobxreact_esm_hoistBlackList = {
  $$typeof: 1,
  render: 1,
  compare: 1,
  type: 1,
  childContextTypes: 1,
  contextType: 1,
  contextTypes: 1,
  defaultProps: 1,
  getDefaultProps: 1,
  getDerivedStateFromError: 1,
  getDerivedStateFromProps: 1,
  mixins: 1,
  displayName: 1,
  propTypes: 1
};
function mobxreact_esm_copyStaticProperties(base, target) {
  var protoProps = Object.getOwnPropertyNames(Object.getPrototypeOf(base));
  Object.getOwnPropertyNames(base).forEach(function (key) {
    if (!mobxreact_esm_hoistBlackList[key] && protoProps.indexOf(key) === -1) {
      Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(base, key));
    }
  });
}
/**
 * Helper to set `prop` to `this` as non-enumerable (hidden prop)
 * @param target
 * @param prop
 * @param value
 */

function setHiddenProp(target, prop, value) {
  if (!Object.hasOwnProperty.call(target, prop)) {
    Object.defineProperty(target, prop, {
      enumerable: false,
      configurable: true,
      writable: true,
      value: value
    });
  } else {
    target[prop] = value;
  }
}
/**
 * Utilities for patching componentWillUnmount, to make sure @disposeOnUnmount works correctly icm with user defined hooks
 * and the handler provided by mobx-react
 */

var mobxMixins = /*#__PURE__*/newSymbol("patchMixins");
var mobxPatchedDefinition = /*#__PURE__*/newSymbol("patchedDefinition");

function getMixins(target, methodName) {
  var mixins = target[mobxMixins] = target[mobxMixins] || {};
  var methodMixins = mixins[methodName] = mixins[methodName] || {};
  methodMixins.locks = methodMixins.locks || 0;
  methodMixins.methods = methodMixins.methods || [];
  return methodMixins;
}

function wrapper(realMethod, mixins) {
  var _this = this;

  for (var _len = arguments.length, args = new Array(_len > 2 ? _len - 2 : 0), _key = 2; _key < _len; _key++) {
    args[_key - 2] = arguments[_key];
  }

  // locks are used to ensure that mixins are invoked only once per invocation, even on recursive calls
  mixins.locks++;

  try {
    var retVal;

    if (realMethod !== undefined && realMethod !== null) {
      retVal = realMethod.apply(this, args);
    }

    return retVal;
  } finally {
    mixins.locks--;

    if (mixins.locks === 0) {
      mixins.methods.forEach(function (mx) {
        mx.apply(_this, args);
      });
    }
  }
}

function wrapFunction(realMethod, mixins) {
  var fn = function fn() {
    for (var _len2 = arguments.length, args = new Array(_len2), _key2 = 0; _key2 < _len2; _key2++) {
      args[_key2] = arguments[_key2];
    }

    wrapper.call.apply(wrapper, [this, realMethod, mixins].concat(args));
  };

  return fn;
}

function patch(target, methodName, mixinMethod) {
  var mixins = getMixins(target, methodName);

  if (mixins.methods.indexOf(mixinMethod) < 0) {
    mixins.methods.push(mixinMethod);
  }

  var oldDefinition = Object.getOwnPropertyDescriptor(target, methodName);

  if (oldDefinition && oldDefinition[mobxPatchedDefinition]) {
    // already patched definition, do not repatch
    return;
  }

  var originalMethod = target[methodName];
  var newDefinition = createDefinition(target, methodName, oldDefinition ? oldDefinition.enumerable : undefined, mixins, originalMethod);
  Object.defineProperty(target, methodName, newDefinition);
}

function createDefinition(target, methodName, enumerable, mixins, originalMethod) {
  var _ref;

  var wrappedFunc = wrapFunction(originalMethod, mixins);
  return _ref = {}, _ref[mobxPatchedDefinition] = true, _ref.get = function get() {
    return wrappedFunc;
  }, _ref.set = function set(value) {
    if (this === target) {
      wrappedFunc = wrapFunction(value, mixins);
    } else {
      // when it is an instance of the prototype/a child prototype patch that particular case again separately
      // since we need to store separate values depending on wether it is the actual instance, the prototype, etc
      // e.g. the method for super might not be the same as the method for the prototype which might be not the same
      // as the method for the instance
      var newDefinition = createDefinition(this, methodName, enumerable, mixins, value);
      Object.defineProperty(this, methodName, newDefinition);
    }
  }, _ref.configurable = true, _ref.enumerable = enumerable, _ref;
}

var mobxAdminProperty = $mobx || "$mobx";
var mobxObserverProperty = /*#__PURE__*/newSymbol("isMobXReactObserver");
var mobxIsUnmounted = /*#__PURE__*/newSymbol("isUnmounted");
var skipRenderKey = /*#__PURE__*/newSymbol("skipRender");
var isForcingUpdateKey = /*#__PURE__*/newSymbol("isForcingUpdate");
function makeClassComponentObserver(componentClass) {
  var target = componentClass.prototype;

  if (componentClass[mobxObserverProperty]) {
    var displayName = getDisplayName(target);
    console.warn("The provided component class (" + displayName + ") \n                has already been declared as an observer component.");
  } else {
    componentClass[mobxObserverProperty] = true;
  }

  if (target.componentWillReact) throw new Error("The componentWillReact life-cycle event is no longer supported");

  if (componentClass["__proto__"] !== react.PureComponent) {
    if (!target.shouldComponentUpdate) target.shouldComponentUpdate = observerSCU;else if (target.shouldComponentUpdate !== observerSCU) // n.b. unequal check, instead of existence check, as @observer might be on superclass as well
      throw new Error("It is not allowed to use shouldComponentUpdate in observer based components.");
  } // this.props and this.state are made observable, just to make sure @computed fields that
  // are defined inside the component, and which rely on state or props, re-compute if state or props change
  // (otherwise the computed wouldn't update and become stale on props change, since props are not observable)
  // However, this solution is not without it's own problems: https://github.com/mobxjs/mobx-react/issues?utf8=%E2%9C%93&q=is%3Aissue+label%3Aobservable-props-or-not+


  makeObservableProp(target, "props");
  makeObservableProp(target, "state");
  var baseRender = target.render;

  target.render = function () {
    return makeComponentReactive.call(this, baseRender);
  };

  patch(target, "componentWillUnmount", function () {
    var _this$render$mobxAdmi;

    if (isUsingStaticRendering() === true) return;
    (_this$render$mobxAdmi = this.render[mobxAdminProperty]) == null ? void 0 : _this$render$mobxAdmi.dispose();
    this[mobxIsUnmounted] = true;

    if (!this.render[mobxAdminProperty]) {
      // Render may have been hot-swapped and/or overriden by a subclass.
      var _displayName = getDisplayName(this);

      console.warn("The reactive render of an observer class component (" + _displayName + ") \n                was overriden after MobX attached. This may result in a memory leak if the \n                overriden reactive render was not properly disposed.");
    }
  });
  return componentClass;
} // Generates a friendly name for debugging

function getDisplayName(comp) {
  return comp.displayName || comp.name || comp.constructor && (comp.constructor.displayName || comp.constructor.name) || "<component>";
}

function makeComponentReactive(render) {
  var _this = this;

  if (isUsingStaticRendering() === true) return render.call(this);
  /**
   * If props are shallowly modified, react will render anyway,
   * so atom.reportChanged() should not result in yet another re-render
   */

  setHiddenProp(this, skipRenderKey, false);
  /**
   * forceUpdate will re-assign this.props. We don't want that to cause a loop,
   * so detect these changes
   */

  setHiddenProp(this, isForcingUpdateKey, false);
  var initialName = getDisplayName(this);
  var baseRender = render.bind(this);
  var isRenderingPending = false;
  var reaction = new Reaction(initialName + ".render()", function () {
    if (!isRenderingPending) {
      // N.B. Getting here *before mounting* means that a component constructor has side effects (see the relevant test in misc.js)
      // This unidiomatic React usage but React will correctly warn about this so we continue as usual
      // See #85 / Pull #44
      isRenderingPending = true;

      if (_this[mobxIsUnmounted] !== true) {
        var hasError = true;

        try {
          setHiddenProp(_this, isForcingUpdateKey, true);
          if (!_this[skipRenderKey]) react.Component.prototype.forceUpdate.call(_this);
          hasError = false;
        } finally {
          setHiddenProp(_this, isForcingUpdateKey, false);
          if (hasError) reaction.dispose();
        }
      }
    }
  });
  reaction["reactComponent"] = this;
  reactiveRender[mobxAdminProperty] = reaction;
  this.render = reactiveRender;

  function reactiveRender() {
    isRenderingPending = false;
    var exception = undefined;
    var rendering = undefined;
    reaction.track(function () {
      try {
        rendering = allowStateChanges(false, baseRender);
      } catch (e) {
        exception = e;
      }
    });

    if (exception) {
      throw exception;
    }

    return rendering;
  }

  return reactiveRender.call(this);
}

function observerSCU(nextProps, nextState) {
  if (isUsingStaticRendering()) {
    console.warn("[mobx-react] It seems that a re-rendering of a React component is triggered while in static (server-side) mode. Please make sure components are rendered only once server-side.");
  } // update on any state changes (as is the default)


  if (this.state !== nextState) {
    return true;
  } // update if props are shallowly not equal, inspired by PureRenderMixin
  // we could return just 'false' here, and avoid the `skipRender` checks etc
  // however, it is nicer if lifecycle events are triggered like usually,
  // so we return true here if props are shallowly modified.


  return !shallowEqual(this.props, nextProps);
}

function makeObservableProp(target, propName) {
  var valueHolderKey = newSymbol("reactProp_" + propName + "_valueHolder");
  var atomHolderKey = newSymbol("reactProp_" + propName + "_atomHolder");

  function getAtom() {
    if (!this[atomHolderKey]) {
      setHiddenProp(this, atomHolderKey, createAtom("reactive " + propName));
    }

    return this[atomHolderKey];
  }

  Object.defineProperty(target, propName, {
    configurable: true,
    enumerable: true,
    get: function get() {
      var prevReadState = false;

      if (allowStateReadsStart && allowStateReadsEnd) {
        prevReadState = allowStateReadsStart(true);
      }

      getAtom.call(this).reportObserved();

      if (allowStateReadsStart && allowStateReadsEnd) {
        allowStateReadsEnd(prevReadState);
      }

      return this[valueHolderKey];
    },
    set: function set(v) {
      if (!this[isForcingUpdateKey] && !shallowEqual(this[valueHolderKey], v)) {
        setHiddenProp(this, valueHolderKey, v);
        setHiddenProp(this, skipRenderKey, true);
        getAtom.call(this).reportChanged();
        setHiddenProp(this, skipRenderKey, false);
      } else {
        setHiddenProp(this, valueHolderKey, v);
      }
    }
  });
}

var hasSymbol = typeof Symbol === "function" && Symbol["for"]; // Using react-is had some issues (and operates on elements, not on types), see #608 / #609

var ReactForwardRefSymbol = hasSymbol ? /*#__PURE__*/Symbol["for"]("react.forward_ref") : typeof react.forwardRef === "function" && /*#__PURE__*/(0,react.forwardRef)(function (props) {
  return null;
})["$$typeof"];
var ReactMemoSymbol = hasSymbol ? /*#__PURE__*/Symbol["for"]("react.memo") : typeof react.memo === "function" && /*#__PURE__*/(0,react.memo)(function (props) {
  return null;
})["$$typeof"];
/**
 * Observer function / decorator
 */

function mobxreact_esm_observer(component) {
  if (component["isMobxInjector"] === true) {
    console.warn("Mobx observer: You are trying to use 'observer' on a component that already has 'inject'. Please apply 'observer' before applying 'inject'");
  }

  if (ReactMemoSymbol && component["$$typeof"] === ReactMemoSymbol) {
    throw new Error("Mobx observer: You are trying to use 'observer' on a function component wrapped in either another observer or 'React.memo'. The observer already applies 'React.memo' for you.");
  } // Unwrap forward refs into `<Observer>` component
  // we need to unwrap the render, because it is the inner render that needs to be tracked,
  // not the ForwardRef HoC


  if (ReactForwardRefSymbol && component["$$typeof"] === ReactForwardRefSymbol) {
    var baseRender = component["render"];
    if (typeof baseRender !== "function") throw new Error("render property of ForwardRef was not a function");
    return (0,react.forwardRef)(function ObserverForwardRef() {
      var args = arguments;
      return (0,react.createElement)(ObserverComponent, null, function () {
        return baseRender.apply(undefined, args);
      });
    });
  } // Function component


  if (typeof component === "function" && (!component.prototype || !component.prototype.render) && !component["isReactClass"] && !Object.prototype.isPrototypeOf.call(react.Component, component)) {
    return observer(component);
  }

  return makeClassComponentObserver(component);
}

function mobxreact_esm_extends() {
  mobxreact_esm_extends = Object.assign || function (target) {
    for (var i = 1; i < arguments.length; i++) {
      var source = arguments[i];

      for (var key in source) {
        if (Object.prototype.hasOwnProperty.call(source, key)) {
          target[key] = source[key];
        }
      }
    }

    return target;
  };

  return mobxreact_esm_extends.apply(this, arguments);
}

function _objectWithoutPropertiesLoose(source, excluded) {
  if (source == null) return {};
  var target = {};
  var sourceKeys = Object.keys(source);
  var key, i;

  for (i = 0; i < sourceKeys.length; i++) {
    key = sourceKeys[i];
    if (excluded.indexOf(key) >= 0) continue;
    target[key] = source[key];
  }

  return target;
}

var MobXProviderContext = /*#__PURE__*/react.createContext({});
function Provider(props) {
  var children = props.children,
      stores = _objectWithoutPropertiesLoose(props, ["children"]);

  var parentValue = react.useContext(MobXProviderContext);
  var mutableProviderRef = react.useRef(mobxreact_esm_extends({}, parentValue, stores));
  var value = mutableProviderRef.current;

  if (false) { var newValue; }

  return react.createElement(MobXProviderContext.Provider, {
    value: value
  }, children);
}
Provider.displayName = "MobXProvider";

/**
 * Store Injection
 */

function createStoreInjector(grabStoresFn, component, injectNames, makeReactive) {
  // Support forward refs
  var Injector = React__default.forwardRef(function (props, ref) {
    var newProps = mobxreact_esm_extends({}, props);

    var context = React__default.useContext(MobXProviderContext);
    Object.assign(newProps, grabStoresFn(context || {}, newProps) || {});

    if (ref) {
      newProps.ref = ref;
    }

    return React__default.createElement(component, newProps);
  });
  if (makeReactive) Injector = mobxreact_esm_observer(Injector);
  Injector["isMobxInjector"] = true; // assigned late to suppress observer warning
  // Static fields from component should be visible on the generated Injector

  mobxreact_esm_copyStaticProperties(component, Injector);
  Injector["wrappedComponent"] = component;
  Injector.displayName = getInjectName(component, injectNames);
  return Injector;
}

function getInjectName(component, injectNames) {
  var displayName;
  var componentName = component.displayName || component.name || component.constructor && component.constructor.name || "Component";
  if (injectNames) displayName = "inject-with-" + injectNames + "(" + componentName + ")";else displayName = "inject(" + componentName + ")";
  return displayName;
}

function grabStoresByName(storeNames) {
  return function (baseStores, nextProps) {
    storeNames.forEach(function (storeName) {
      if (storeName in nextProps // prefer props over stores
      ) return;
      if (!(storeName in baseStores)) throw new Error("MobX injector: Store '" + storeName + "' is not available! Make sure it is provided by some Provider");
      nextProps[storeName] = baseStores[storeName];
    });
    return nextProps;
  };
}
/**
 * higher order component that injects stores to a child.
 * takes either a varargs list of strings, which are stores read from the context,
 * or a function that manually maps the available stores from the context to props:
 * storesToProps(mobxStores, props, context) => newProps
 */


function inject() {
  for (var _len = arguments.length, storeNames = new Array(_len), _key = 0; _key < _len; _key++) {
    storeNames[_key] = arguments[_key];
  }

  if (typeof arguments[0] === "function") {
    var grabStoresFn = arguments[0];
    return function (componentClass) {
      return createStoreInjector(grabStoresFn, componentClass, grabStoresFn.name, true);
    };
  } else {
    return function (componentClass) {
      return createStoreInjector(grabStoresByName(storeNames), componentClass, storeNames.join("-"), false);
    };
  }
}

var protoStoreKey = /*#__PURE__*/(/* unused pure expression or super */ null && (newSymbol("disposeOnUnmountProto")));
var instStoreKey = /*#__PURE__*/(/* unused pure expression or super */ null && (newSymbol("disposeOnUnmountInst")));

function runDisposersOnWillUnmount() {
  var _this = this;
  [].concat(this[protoStoreKey] || [], this[instStoreKey] || []).forEach(function (propKeyOrFunction) {
    var prop = typeof propKeyOrFunction === "string" ? _this[propKeyOrFunction] : propKeyOrFunction;

    if (prop !== undefined && prop !== null) {
      if (Array.isArray(prop)) prop.map(function (f) {
        return f();
      });else prop();
    }
  });
}

function disposeOnUnmount(target, propertyKeyOrFunction) {
  if (Array.isArray(propertyKeyOrFunction)) {
    return propertyKeyOrFunction.map(function (fn) {
      return disposeOnUnmount(target, fn);
    });
  }

  var c = Object.getPrototypeOf(target).constructor;
  var c2 = Object.getPrototypeOf(target.constructor); // Special case for react-hot-loader

  var c3 = Object.getPrototypeOf(Object.getPrototypeOf(target));

  if (!(c === React__default.Component || c === React__default.PureComponent || c2 === React__default.Component || c2 === React__default.PureComponent || c3 === React__default.Component || c3 === React__default.PureComponent)) {
    throw new Error("[mobx-react] disposeOnUnmount only supports direct subclasses of React.Component or React.PureComponent.");
  }

  if (typeof propertyKeyOrFunction !== "string" && typeof propertyKeyOrFunction !== "function" && !Array.isArray(propertyKeyOrFunction)) {
    throw new Error("[mobx-react] disposeOnUnmount only works if the parameter is either a property key or a function.");
  } // decorator's target is the prototype, so it doesn't have any instance properties like props


  var isDecorator = typeof propertyKeyOrFunction === "string"; // add property key / function we want run (disposed) to the store

  var componentWasAlreadyModified = !!target[protoStoreKey] || !!target[instStoreKey];
  var store = isDecorator ? // decorators are added to the prototype store
  target[protoStoreKey] || (target[protoStoreKey] = []) : // functions are added to the instance store
  target[instStoreKey] || (target[instStoreKey] = []);
  store.push(propertyKeyOrFunction); // tweak the component class componentWillUnmount if not done already

  if (!componentWasAlreadyModified) {
    patch(target, "componentWillUnmount", runDisposersOnWillUnmount);
  } // return the disposer as is if invoked as a non decorator


  if (typeof propertyKeyOrFunction !== "string") {
    return propertyKeyOrFunction;
  }
}

function createChainableTypeChecker(validator) {
  function checkType(isRequired, props, propName, componentName, location, propFullName) {
    for (var _len = arguments.length, rest = new Array(_len > 6 ? _len - 6 : 0), _key = 6; _key < _len; _key++) {
      rest[_key - 6] = arguments[_key];
    }

    return untracked(function () {
      componentName = componentName || "<<anonymous>>";
      propFullName = propFullName || propName;

      if (props[propName] == null) {
        if (isRequired) {
          var actual = props[propName] === null ? "null" : "undefined";
          return new Error("The " + location + " `" + propFullName + "` is marked as required " + "in `" + componentName + "`, but its value is `" + actual + "`.");
        }

        return null;
      } else {
        // @ts-ignore rest arg is necessary for some React internals - fails tests otherwise
        return validator.apply(void 0, [props, propName, componentName, location, propFullName].concat(rest));
      }
    });
  }

  var chainedCheckType = checkType.bind(null, false); // Add isRequired to satisfy Requirable

  chainedCheckType.isRequired = checkType.bind(null, true);
  return chainedCheckType;
} // Copied from React.PropTypes


function isSymbol(propType, propValue) {
  // Native Symbol.
  if (propType === "symbol") {
    return true;
  } // 19.4.3.5 Symbol.prototype[@@toStringTag] === 'Symbol'


  if (propValue["@@toStringTag"] === "Symbol") {
    return true;
  } // Fallback for non-spec compliant Symbols which are polyfilled.


  if (typeof Symbol === "function" && propValue instanceof Symbol) {
    return true;
  }

  return false;
} // Copied from React.PropTypes


function getPropType(propValue) {
  var propType = typeof propValue;

  if (Array.isArray(propValue)) {
    return "array";
  }

  if (propValue instanceof RegExp) {
    // Old webkits (at least until Android 4.0) return 'function' rather than
    // 'object' for typeof a RegExp. We'll normalize this here so that /bla/
    // passes PropTypes.object.
    return "object";
  }

  if (isSymbol(propType, propValue)) {
    return "symbol";
  }

  return propType;
} // This handles more types than `getPropType`. Only used for error messages.
// Copied from React.PropTypes


function getPreciseType(propValue) {
  var propType = getPropType(propValue);

  if (propType === "object") {
    if (propValue instanceof Date) {
      return "date";
    } else if (propValue instanceof RegExp) {
      return "regexp";
    }
  }

  return propType;
}

function createObservableTypeCheckerCreator(allowNativeType, mobxType) {
  return createChainableTypeChecker(function (props, propName, componentName, location, propFullName) {
    return untracked(function () {
      if (allowNativeType) {
        if (getPropType(props[propName]) === mobxType.toLowerCase()) return null;
      }

      var mobxChecker;

      switch (mobxType) {
        case "Array":
          mobxChecker = isObservableArray;
          break;

        case "Object":
          mobxChecker = isObservableObject;
          break;

        case "Map":
          mobxChecker = isObservableMap;
          break;

        default:
          throw new Error("Unexpected mobxType: " + mobxType);
      }

      var propValue = props[propName];

      if (!mobxChecker(propValue)) {
        var preciseType = getPreciseType(propValue);
        var nativeTypeExpectationMessage = allowNativeType ? " or javascript `" + mobxType.toLowerCase() + "`" : "";
        return new Error("Invalid prop `" + propFullName + "` of type `" + preciseType + "` supplied to" + " `" + componentName + "`, expected `mobx.Observable" + mobxType + "`" + nativeTypeExpectationMessage + ".");
      }

      return null;
    });
  });
}

function createObservableArrayOfTypeChecker(allowNativeType, typeChecker) {
  return createChainableTypeChecker(function (props, propName, componentName, location, propFullName) {
    for (var _len2 = arguments.length, rest = new Array(_len2 > 5 ? _len2 - 5 : 0), _key2 = 5; _key2 < _len2; _key2++) {
      rest[_key2 - 5] = arguments[_key2];
    }

    return untracked(function () {
      if (typeof typeChecker !== "function") {
        return new Error("Property `" + propFullName + "` of component `" + componentName + "` has " + "invalid PropType notation.");
      } else {
        var error = createObservableTypeCheckerCreator(allowNativeType, "Array")(props, propName, componentName, location, propFullName);
        if (error instanceof Error) return error;
        var propValue = props[propName];

        for (var i = 0; i < propValue.length; i++) {
          error = typeChecker.apply(void 0, [propValue, i, componentName, location, propFullName + "[" + i + "]"].concat(rest));
          if (error instanceof Error) return error;
        }

        return null;
      }
    });
  });
}

var observableArray = /*#__PURE__*/createObservableTypeCheckerCreator(false, "Array");
var observableArrayOf = /*#__PURE__*/createObservableArrayOfTypeChecker.bind(null, false);
var observableMap = /*#__PURE__*/createObservableTypeCheckerCreator(false, "Map");
var observableObject = /*#__PURE__*/createObservableTypeCheckerCreator(false, "Object");
var arrayOrObservableArray = /*#__PURE__*/createObservableTypeCheckerCreator(true, "Array");
var arrayOrObservableArrayOf = /*#__PURE__*/createObservableArrayOfTypeChecker.bind(null, true);
var objectOrObservableObject = /*#__PURE__*/createObservableTypeCheckerCreator(true, "Object");
var PropTypes = {
  observableArray: observableArray,
  observableArrayOf: observableArrayOf,
  observableMap: observableMap,
  observableObject: observableObject,
  arrayOrObservableArray: arrayOrObservableArray,
  arrayOrObservableArrayOf: arrayOrObservableArrayOf,
  objectOrObservableObject: objectOrObservableObject
};

if (!react.Component) throw new Error("mobx-react requires React to be available");
if (!mobx_esm_observable) throw new Error("mobx-react requires mobx to be available");


//# sourceMappingURL=mobxreact.esm.js.map

// EXTERNAL MODULE: ./node_modules/style-loader/dist/runtime/injectStylesIntoStyleTag.js
var injectStylesIntoStyleTag = __webpack_require__(3379);
var injectStylesIntoStyleTag_default = /*#__PURE__*/__webpack_require__.n(injectStylesIntoStyleTag);
// EXTERNAL MODULE: ./node_modules/style-loader/dist/runtime/styleDomAPI.js
var styleDomAPI = __webpack_require__(7795);
var styleDomAPI_default = /*#__PURE__*/__webpack_require__.n(styleDomAPI);
// EXTERNAL MODULE: ./node_modules/style-loader/dist/runtime/insertBySelector.js
var insertBySelector = __webpack_require__(569);
var insertBySelector_default = /*#__PURE__*/__webpack_require__.n(insertBySelector);
// EXTERNAL MODULE: ./node_modules/style-loader/dist/runtime/setAttributesWithoutAttributes.js
var setAttributesWithoutAttributes = __webpack_require__(3565);
var setAttributesWithoutAttributes_default = /*#__PURE__*/__webpack_require__.n(setAttributesWithoutAttributes);
// EXTERNAL MODULE: ./node_modules/style-loader/dist/runtime/insertStyleElement.js
var insertStyleElement = __webpack_require__(9216);
var insertStyleElement_default = /*#__PURE__*/__webpack_require__.n(insertStyleElement);
// EXTERNAL MODULE: ./node_modules/style-loader/dist/runtime/styleTagTransform.js
var styleTagTransform = __webpack_require__(4589);
var styleTagTransform_default = /*#__PURE__*/__webpack_require__.n(styleTagTransform);
// EXTERNAL MODULE: ./node_modules/css-loader/dist/cjs.js!./node_modules/postcss-loader/dist/cjs.js!./src/pages/common/ui/Icons/icons.pcss
var icons = __webpack_require__(3281);
;// CONCATENATED MODULE: ./src/pages/common/ui/Icons/icons.pcss

      
      
      
      
      
      
      
      
      

var options = {};

options.styleTagTransform = (styleTagTransform_default());
options.setAttributes = (setAttributesWithoutAttributes_default());

      options.insert = insertBySelector_default().bind(null, "head");
    
options.domAPI = (styleDomAPI_default());
options.insertStyleElement = (insertStyleElement_default());

var update = injectStylesIntoStyleTag_default()(icons/* default */.Z, options);




       /* harmony default export */ const Icons_icons = (icons/* default */.Z && icons/* default.locals */.Z.locals ? icons/* default.locals */.Z.locals : undefined);

;// CONCATENATED MODULE: ./src/pages/common/ui/Icons/Icons.tsx



/* eslint-disable max-len */
var Icons = function Icons() {
  return /*#__PURE__*/react.createElement("svg", {
    xmlns: "http://www.w3.org/2000/svg",
    className: "icons"
  }, /*#__PURE__*/react.createElement("symbol", {
    id: "delete",
    viewBox: "0 0 24 24",
    fill: "none"
  }, /*#__PURE__*/react.createElement("path", {
    fillRule: "evenodd",
    clipRule: "evenodd",
    d: "M7 9H17L16.2367 19.0755C16.1972 19.597 15.7625 20 15.2396 20H8.76044C8.23746 20 7.80281 19.597 7.7633 19.0755L7 9Z",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  }), /*#__PURE__*/react.createElement("path", {
    d: "M6 6.5H18",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  }), /*#__PURE__*/react.createElement("path", {
    d: "M14 6V4L10 4V6",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  }), /*#__PURE__*/react.createElement("path", {
    fillRule: "evenodd",
    clipRule: "evenodd",
    d: "M13.5 12V17V12Z",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  }), /*#__PURE__*/react.createElement("path", {
    fillRule: "evenodd",
    clipRule: "evenodd",
    d: "M10.5 12V17V12Z",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  })), /*#__PURE__*/react.createElement("symbol", {
    id: "aim",
    viewBox: "0 0 24 24",
    fill: "none"
  }, /*#__PURE__*/react.createElement("path", {
    fillRule: "evenodd",
    clipRule: "evenodd",
    d: "M11.9997 9.27271C10.4935 9.27271 9.27246 10.4937 9.27246 12C9.27246 13.5062 10.4935 14.7273 11.9997 14.7273C13.506 14.7273 14.727 13.5062 14.727 12C14.7252 10.4945 13.5052 9.27447 11.9997 9.27271Z",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  }), /*#__PURE__*/react.createElement("path", {
    fillRule: "evenodd",
    clipRule: "evenodd",
    d: "M12 3C7.02944 3 3 7.02944 3 12C3 16.9706 7.02944 21 12 21C16.9706 21 21 16.9706 21 12C20.9942 7.03185 16.9682 3.00581 12 3Z",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  }), /*#__PURE__*/react.createElement("path", {
    d: "M2 12H6",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  }), /*#__PURE__*/react.createElement("path", {
    d: "M18 12H22",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  }), /*#__PURE__*/react.createElement("path", {
    d: "M12 2V6",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  }), /*#__PURE__*/react.createElement("path", {
    d: "M12 18V22",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  })), /*#__PURE__*/react.createElement("symbol", {
    id: "cross",
    viewBox: "0 0 24 24",
    fill: "none"
  }, /*#__PURE__*/react.createElement("path", {
    d: "M6.42857 6.42857L17.6043 17.6043",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round"
  }), /*#__PURE__*/react.createElement("path", {
    d: "M6.42871 17.5714L17.6045 6.39563",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round"
  })), /*#__PURE__*/react.createElement("symbol", {
    id: "info",
    viewBox: "0 0 24 24",
    fill: "none"
  }, /*#__PURE__*/react.createElement("circle", {
    cx: "12",
    cy: "12",
    r: "9",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  }), /*#__PURE__*/react.createElement("path", {
    d: "M12 16V10",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  }), /*#__PURE__*/react.createElement("path", {
    d: "M11.997 7.59552C12.009 7.59745 11.997 7.40446 11.997 7.40446",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  })), /*#__PURE__*/react.createElement("symbol", {
    id: "switcher",
    viewBox: "0 0 24 15"
  }, /*#__PURE__*/react.createElement("g", {
    id: "Slide"
  }, /*#__PURE__*/react.createElement("rect", {
    id: "Shape",
    width: "24",
    height: "15",
    rx: "7.5",
    transform: "matrix(-1 0 0 1 24 0)",
    fill: "#67B279"
  }), /*#__PURE__*/react.createElement("circle", {
    id: "Oval",
    r: "6.25",
    transform: "matrix(-1 0 0 1 16.5 7.5)",
    fill: "white",
    stroke: "#E5E5E5",
    strokeWidth: "0.5"
  }))), /*#__PURE__*/react.createElement("symbol", {
    id: "safari",
    viewBox: "0 0 24 24"
  }, /*#__PURE__*/react.createElement("g", {
    id: "safari-3"
  }, /*#__PURE__*/react.createElement("circle", {
    id: "Oval",
    cx: "11.9994",
    cy: "11.9994",
    r: "11.9994",
    fill: "#DBDBDA"
  }), /*#__PURE__*/react.createElement("circle", {
    id: "Oval_2",
    cx: "11.9993",
    cy: "11.9993",
    r: "11.0994",
    fill: "#2C93DD"
  }), /*#__PURE__*/react.createElement("g", {
    id: "Group"
  }, /*#__PURE__*/react.createElement("path", {
    id: "Path",
    d: "M12.0185 3.59978C11.9435 3.59978 11.8779 3.54355 11.8779 3.46856V1.50927C11.8779 1.43427 11.9435 1.37805 12.0185 1.37805C12.0935 1.37805 12.1591 1.43427 12.1591 1.50927V3.46856C12.1498 3.54355 12.0935 3.59978 12.0185 3.59978Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_2",
    d: "M12.9559 2.54978C12.8809 2.54039 12.8247 2.48417 12.8247 2.40918L12.8903 1.53728C12.8996 1.46239 12.9653 1.40607 13.0403 1.41545C13.1153 1.42484 13.1715 1.48116 13.1715 1.55615L13.1059 2.42795C13.0965 2.50294 13.0309 2.55917 12.9559 2.54988V2.54978Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_3",
    d: "M13.6591 3.76849C13.5841 3.74972 13.5372 3.68411 13.5466 3.60911L13.931 1.68728C13.9497 1.61238 14.0154 1.56545 14.0903 1.58422C14.1653 1.60299 14.2122 1.6686 14.2028 1.7436L13.8184 3.66543C13.809 3.73095 13.734 3.77788 13.659 3.76849H13.6591Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_4",
    d: "M14.7838 2.9248C14.7477 2.9161 14.7166 2.89343 14.6972 2.86178C14.6779 2.83012 14.672 2.79208 14.6807 2.75603L14.9151 1.9124C14.9337 1.8374 15.0087 1.79985 15.0837 1.81863C15.1587 1.8374 15.2057 1.9124 15.1869 1.98739L14.9525 2.83112C14.9337 2.90602 14.8587 2.94357 14.7838 2.9248Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_5",
    d: "M15.2434 4.24668C15.1684 4.21852 15.1403 4.13414 15.1684 4.06853L15.9183 2.25924C15.9464 2.19363 16.0309 2.15608 16.0964 2.19363C16.1715 2.22169 16.1997 2.30617 16.1715 2.37168L15.4215 4.18098C15.3935 4.24668 15.309 4.28413 15.2435 4.24668H15.2434Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_6",
    d: "M16.5087 3.64674C16.443 3.6092 16.4148 3.5342 16.443 3.46859L16.8368 2.69057C16.8742 2.62486 16.9492 2.5967 17.0243 2.63425C17.0899 2.6718 17.118 2.74679 17.0899 2.8123L16.6961 3.59043C16.6586 3.65603 16.5836 3.68429 16.5086 3.64674H16.5087Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_7",
    d: "M16.6964 5.03411C16.6308 4.98728 16.612 4.9029 16.6588 4.84667L17.7463 3.22482C17.7838 3.15921 17.8682 3.14982 17.9337 3.18737C17.9995 3.23421 18.0181 3.31859 17.9713 3.37481L16.8838 4.99667C16.8464 5.06227 16.762 5.08105 16.6964 5.03411Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_8",
    d: "M18.0649 4.68732C18.0087 4.64038 17.99 4.556 18.0368 4.49978L18.5805 3.81543C18.6274 3.7593 18.7118 3.74982 18.768 3.79675C18.8243 3.84359 18.843 3.92797 18.796 3.98419L18.2524 4.66854C18.2056 4.72477 18.1212 4.73415 18.065 4.68732H18.0649Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_9",
    d: "M17.9714 6.09343C17.9151 6.03721 17.9151 5.95282 17.9714 5.90589L19.3587 4.5279C19.4151 4.47167 19.4994 4.48096 19.5463 4.5279C19.5931 4.57473 19.6025 4.6685 19.5463 4.71534L18.1683 6.09343C18.112 6.14965 18.0276 6.14965 17.9714 6.09343Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_10",
    d: "M19.3773 6.01837C19.3305 5.96215 19.3305 5.87777 19.3867 5.83084L20.0523 5.26841C20.1085 5.22158 20.1929 5.23087 20.2398 5.28719C20.2866 5.34341 20.2866 5.42779 20.2304 5.47463L19.5648 6.03715C19.5085 6.08398 19.4241 6.0746 19.3773 6.01837Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_11",
    d: "M19.0026 7.36832C18.9557 7.30271 18.9745 7.21833 19.0401 7.18078L20.6713 6.09339C20.7369 6.05584 20.8212 6.07461 20.8587 6.13093C20.9056 6.19654 20.8869 6.28093 20.8212 6.31837L19.1901 7.40577C19.1338 7.44332 19.0494 7.42454 19.0026 7.36832Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_12",
    d: "M20.3995 7.56525C20.362 7.49955 20.3807 7.41526 20.4463 7.37771L21.2057 6.94651C21.2713 6.90896 21.3557 6.93712 21.3931 7.00264C21.4307 7.06834 21.4119 7.15263 21.3463 7.19017L20.587 7.62148C20.5213 7.65892 20.437 7.63086 20.3994 7.56516L20.3995 7.56525Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_13",
    d: "M19.7709 8.812C19.7429 8.73701 19.7709 8.66201 19.8459 8.63395L21.6552 7.88399C21.7208 7.85583 21.8052 7.89328 21.8333 7.95888C21.8614 8.03388 21.8333 8.10888 21.7583 8.13694L19.9491 8.8869C19.8834 8.91506 19.7991 8.8869 19.7709 8.812Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_14",
    d: "M21.0928 9.28076C21.0647 9.20567 21.1022 9.13077 21.1772 9.10261L22.0021 8.83069C22.0678 8.80262 22.1521 8.84946 22.1709 8.91507C22.199 8.99007 22.1615 9.06506 22.0865 9.09322L21.2616 9.36514C21.196 9.39321 21.121 9.35576 21.0928 9.28066V9.28076Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_15",
    d: "M20.2493 10.3964C20.2305 10.3214 20.2773 10.2464 20.3523 10.237L22.2742 9.86204C22.3491 9.84327 22.4148 9.89949 22.4334 9.97449C22.4522 10.0495 22.4054 10.1245 22.3304 10.1339L20.4085 10.5088C20.3335 10.5182 20.2586 10.4714 20.2492 10.3964H20.2493Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_16",
    d: "M21.4494 11.1182C21.44 11.0432 21.4869 10.9776 21.5619 10.9682L22.4243 10.865C22.4993 10.8557 22.565 10.912 22.5743 10.9869C22.5837 11.0619 22.5368 11.1276 22.4618 11.1369L21.5993 11.24C21.5337 11.2494 21.4587 11.1932 21.4493 11.1182H21.4494Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_17",
    d: "M20.3994 12.0274C20.3994 11.9525 20.4555 11.8868 20.5306 11.8868H22.4899C22.5649 11.8868 22.6211 11.9525 22.6211 12.0274C22.6211 12.1024 22.5649 12.1681 22.4899 12.1681H20.5306C20.4556 12.1681 20.3994 12.1024 20.3994 12.0274Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_18",
    d: "M21.44 12.9742C21.4493 12.8992 21.5056 12.843 21.5806 12.843L22.4525 12.9086C22.5274 12.918 22.5837 12.9836 22.5743 13.0586C22.565 13.1336 22.5087 13.1898 22.4337 13.1898L21.5619 13.1242C21.4963 13.1148 21.4399 13.0492 21.4399 12.9742H21.44Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_19",
    d: "M20.2307 13.6587C20.2495 13.5837 20.3151 13.5368 20.3901 13.5463L22.3118 13.9306C22.3868 13.9493 22.4337 14.0149 22.415 14.0899C22.3962 14.1649 22.3306 14.2118 22.2556 14.2024L20.3337 13.8181C20.2681 13.8087 20.2213 13.7337 20.2307 13.6587Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_20",
    d: "M21.0742 14.7836C21.0829 14.7476 21.1055 14.7165 21.1372 14.6971C21.1688 14.6778 21.2068 14.6718 21.2429 14.6805L22.0866 14.9148C22.1616 14.9336 22.199 15.0087 22.1804 15.0836C22.1717 15.1197 22.149 15.1508 22.1174 15.1702C22.0857 15.1895 22.0476 15.1955 22.0116 15.1867L21.1679 14.9524C21.0929 14.9336 21.0554 14.8586 21.0741 14.7836H21.0742Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_21",
    d: "M19.7524 15.2335C19.7805 15.1585 19.865 15.1304 19.9305 15.1585L21.7399 15.9085C21.8055 15.9366 21.8429 16.021 21.8149 16.0866C21.7867 16.1616 21.7023 16.1897 21.6367 16.1616L19.8274 15.4117C19.7524 15.3836 19.7243 15.2991 19.7524 15.2336V15.2335Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_22",
    d: "M20.3615 16.4991C20.3991 16.4335 20.474 16.4053 20.5396 16.4335L21.3177 16.8272C21.3833 16.8553 21.4115 16.9397 21.374 17.0147C21.3365 17.0803 21.2615 17.1085 21.1959 17.0803L20.4179 16.6866C20.3522 16.6491 20.324 16.5647 20.3615 16.4991Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_23",
    d: "M18.9835 16.6773C19.0305 16.6117 19.1055 16.5929 19.1711 16.6398L20.8022 17.7273C20.8678 17.7647 20.8772 17.8492 20.8397 17.9147C20.7928 17.9804 20.7178 17.9991 20.6522 17.9523L19.0211 16.8648C18.9555 16.8179 18.9367 16.7335 18.9835 16.6773Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_24",
    d: "M19.3303 18.0366C19.3772 17.9803 19.4615 17.9616 19.5178 18.0086L20.2021 18.5428C20.2583 18.5897 20.2677 18.674 20.2209 18.7304C20.1741 18.7865 20.0897 18.8054 20.0333 18.7584L19.349 18.2241C19.2929 18.1772 19.2834 18.0929 19.3303 18.0366Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_25",
    d: "M17.9336 17.9428C17.9899 17.8866 18.0743 17.8866 18.1211 17.9428L19.5085 19.3208C19.5648 19.3771 19.5554 19.4615 19.5085 19.5083C19.4524 19.5646 19.3679 19.5646 19.321 19.5083L17.9336 18.1303C17.8867 18.0834 17.8867 17.9896 17.9336 17.9428Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_26",
    d: "M18.018 19.3396C18.0743 19.2927 18.1586 19.2927 18.2055 19.349L18.7774 20.0052C18.8242 20.0615 18.8149 20.1459 18.7586 20.1927C18.7024 20.2395 18.618 20.2395 18.5711 20.1833L17.9992 19.5271C17.9524 19.4803 17.9618 19.3959 18.018 19.3396Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_27",
    d: "M16.6679 18.9834C16.7335 18.9366 16.8179 18.9553 16.8555 19.0209L17.9428 20.6427C17.9803 20.7083 17.9615 20.7927 17.9053 20.8302C17.8397 20.8771 17.7553 20.8583 17.7178 20.7927L16.6304 19.1708C16.5928 19.1053 16.6116 19.0208 16.6678 18.9834H16.6679Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_28",
    d: "M16.4712 20.3708C16.5369 20.3333 16.6212 20.3521 16.6587 20.4177L17.09 21.177C17.1274 21.2426 17.0993 21.327 17.0337 21.3645C16.9681 21.402 16.8837 21.3833 16.8462 21.3176L16.415 20.5583C16.3869 20.4927 16.4056 20.4083 16.4711 20.3709L16.4712 20.3708Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_29",
    d: "M15.2245 19.752C15.2995 19.724 15.3745 19.752 15.4027 19.8177L16.162 21.6269C16.1901 21.6926 16.1526 21.7769 16.087 21.805C16.0214 21.8332 15.937 21.805 15.909 21.7394L15.1496 19.9302C15.1215 19.8645 15.1589 19.7802 15.2245 19.752Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_30",
    d: "M14.765 21.0833C14.8401 21.0552 14.915 21.0927 14.9431 21.1677L15.2151 21.9926C15.2431 22.0582 15.1963 22.1426 15.1307 22.1614C15.0557 22.1895 14.9807 22.152 14.9526 22.077L14.6807 21.2521C14.6526 21.1864 14.6901 21.1114 14.7651 21.0833H14.765Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_31",
    d: "M13.6592 20.2302C13.7341 20.2114 13.8092 20.2583 13.8185 20.3333L14.2123 22.2551C14.231 22.33 14.1747 22.3957 14.0997 22.4144C14.0248 22.4332 13.9497 22.3863 13.9404 22.3113L13.5466 20.3895C13.5373 20.3239 13.5841 20.2489 13.6591 20.2301L13.6592 20.2302Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_32",
    d: "M12.9466 21.4488C13.0216 21.4394 13.0872 21.4864 13.106 21.5614L13.2184 22.4238C13.2278 22.4988 13.1716 22.5644 13.0965 22.5738C13.0216 22.5832 12.956 22.5363 12.9372 22.4613L12.8248 21.5988C12.8154 21.5238 12.8716 21.4582 12.9466 21.4488Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_33",
    d: "M11.9809 20.3989C12.0559 20.3989 12.1215 20.4552 12.1215 20.5302V22.4894C12.1215 22.5644 12.0559 22.6207 11.9809 22.6207C11.9059 22.6207 11.8403 22.5644 11.8403 22.4894V20.5302C11.8497 20.4552 11.9059 20.3989 11.9809 20.3989Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_34",
    d: "M11.0432 21.4489C11.1182 21.4583 11.1745 21.5145 11.1745 21.5895L11.1088 22.4614C11.0996 22.5364 11.0339 22.5926 10.9589 22.5833C10.8839 22.5738 10.8276 22.5176 10.8276 22.4426L10.8932 21.5707C10.9026 21.4958 10.9682 21.4395 11.0432 21.4489Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_35",
    d: "M10.3403 20.2302C10.4153 20.2489 10.4622 20.3145 10.4528 20.3895L10.0684 22.3113C10.0497 22.3863 9.98404 22.4332 9.90905 22.4144C9.83405 22.3957 9.78722 22.3301 9.7966 22.255L10.181 20.3333C10.1904 20.2677 10.2654 20.2208 10.3403 20.2302Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_36",
    d: "M9.21557 21.0738C9.29066 21.0926 9.3375 21.1676 9.31872 21.2426L9.08435 22.0863C9.06567 22.1613 8.99067 22.1988 8.91568 22.1801C8.8796 22.1714 8.84845 22.1488 8.8291 22.1171C8.80975 22.0855 8.80379 22.0474 8.81252 22.0113L9.0469 21.1676C9.06567 21.0926 9.14067 21.0552 9.21566 21.0738H9.21557Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_37",
    d: "M8.75593 19.7521C8.83093 19.7802 8.85899 19.8645 8.83093 19.9302L8.08097 21.7394C8.0529 21.8052 7.96842 21.8426 7.90291 21.8052C7.83721 21.7676 7.79966 21.6926 7.82782 21.627L8.57778 19.8177C8.60584 19.7521 8.69032 19.7146 8.75584 19.7521H8.75593Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_38",
    d: "M7.49056 20.352C7.55617 20.3895 7.58424 20.4645 7.55617 20.5301L7.16242 21.3082C7.12487 21.3738 7.04988 21.402 6.97488 21.3644C6.90927 21.327 6.88121 21.252 6.90927 21.1864L7.30312 20.4083C7.34057 20.3426 7.41557 20.3145 7.49056 20.352Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_39",
    d: "M7.30289 18.9647C7.3685 19.0115 7.38727 19.0959 7.34044 19.1521L6.25294 20.774C6.21549 20.8395 6.13102 20.8489 6.0655 20.8114C5.99989 20.7645 5.98112 20.6802 6.02796 20.6239L7.11545 19.0021C7.1529 18.9365 7.23728 18.9178 7.30289 18.9646V18.9647Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_40",
    d: "M5.93446 19.3115C5.99077 19.3584 6.00945 19.4427 5.96262 19.499L5.41887 20.1833C5.37203 20.2395 5.28765 20.2489 5.23143 20.2021C5.1752 20.1553 5.15643 20.0709 5.20336 20.0145L5.74701 19.3302C5.79385 19.2741 5.87823 19.2646 5.93446 19.3115Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_41",
    d: "M6.0282 17.9054C6.08442 17.9615 6.08442 18.046 6.0282 18.0928L4.64082 19.4708C4.5845 19.5272 4.50021 19.5178 4.45328 19.4708C4.40644 19.424 4.39705 19.3302 4.45328 19.2834L5.83127 17.9054C5.88759 17.8491 5.97197 17.8491 6.0282 17.9054Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_42",
    d: "M4.62212 17.9803C4.66896 18.0365 4.66896 18.1209 4.61274 18.1678L3.94716 18.7303C3.89094 18.7771 3.80655 18.7678 3.75962 18.7115C3.71278 18.6552 3.71278 18.5709 3.76901 18.524L4.43459 17.9616C4.4909 17.9146 4.57519 17.924 4.62212 17.9803Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_43",
    d: "M4.99695 16.6303C5.04379 16.696 5.02502 16.7803 4.95941 16.8178L3.32826 17.9053C3.26265 17.9428 3.17827 17.924 3.14082 17.8678C3.09389 17.8022 3.11266 17.7178 3.17827 17.6803L4.80951 16.5929C4.86583 16.5554 4.95012 16.5741 4.99705 16.6303H4.99695Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_44",
    d: "M3.60017 16.4335C3.63771 16.4991 3.61894 16.5835 3.55333 16.6211L2.79398 17.0523C2.72837 17.0897 2.64399 17.0616 2.60654 16.996C2.569 16.9304 2.58777 16.846 2.65338 16.8085L3.41273 16.3773C3.47834 16.3397 3.56272 16.3679 3.60027 16.4335H3.60017Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_45",
    d: "M4.22833 15.1867C4.25639 15.2617 4.22833 15.3367 4.15334 15.3648L2.34404 16.1148C2.27843 16.1429 2.19405 16.1055 2.16599 16.0398C2.13783 15.9648 2.16599 15.8898 2.24098 15.8617L4.05028 15.1117C4.11589 15.0837 4.20027 15.1117 4.22833 15.1867Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_46",
    d: "M2.90626 14.718C2.93433 14.793 2.89688 14.868 2.82188 14.896L1.99692 15.1679C1.93132 15.196 1.84693 15.1492 1.82816 15.0836C1.8001 15.0086 1.83755 14.9336 1.91254 14.9055L2.7375 14.6336C2.80311 14.6055 2.8781 14.643 2.90626 14.718Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_47",
    d: "M3.74994 13.6025C3.76862 13.6775 3.72178 13.7525 3.64679 13.7619L1.72495 14.1368C1.64996 14.1556 1.58435 14.0993 1.56567 14.0243C1.5469 13.9493 1.59373 13.8743 1.66873 13.8649L3.59056 13.4899C3.66556 13.4806 3.74056 13.5275 3.74985 13.6025H3.74994Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_48",
    d: "M2.54996 12.8806C2.55925 12.9555 2.51242 13.0213 2.43742 13.0306L1.57501 13.1337C1.49992 13.1431 1.43431 13.0869 1.42502 13.0118C1.41563 12.9369 1.46247 12.8713 1.53747 12.8618L2.39997 12.7587C2.46558 12.7493 2.54058 12.8056 2.54996 12.8806Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_49",
    d: "M3.60005 11.9712C3.60005 12.0463 3.54392 12.1119 3.46883 12.1119H1.50964C1.43464 12.1119 1.37842 12.0463 1.37842 11.9713C1.37842 11.8963 1.43464 11.8306 1.50964 11.8306H3.46892C3.54392 11.8306 3.60024 11.8963 3.60024 11.9713L3.60005 11.9712Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_50",
    d: "M2.55975 11.0244C2.55026 11.0994 2.49404 11.1557 2.41904 11.1557L1.54715 11.09C1.47225 11.0807 1.41603 11.0151 1.42532 10.9401C1.43471 10.8651 1.49103 10.8088 1.56602 10.8088L2.43782 10.8744C2.50343 10.8838 2.55975 10.9494 2.55975 11.0244Z",
    fill: "#E2E2E2"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_51",
    d: "M3.76898 10.34C3.75021 10.415 3.6846 10.4619 3.6096 10.4526L1.68786 10.0588C1.61287 10.04 1.56593 9.97442 1.58471 9.89943C1.60348 9.82443 1.66909 9.7775 1.74409 9.78698L3.66592 10.1713C3.73153 10.19 3.77837 10.265 3.76898 10.34Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_52",
    d: "M2.92498 9.21518C2.91629 9.25124 2.89362 9.28236 2.86196 9.30169C2.83031 9.32103 2.79226 9.32698 2.75622 9.31824L1.91248 9.08386C1.83749 9.06509 1.80004 8.99009 1.81872 8.9151C1.82741 8.87904 1.85008 8.84792 1.88173 8.82858C1.91339 8.80925 1.95143 8.8033 1.98748 8.81204L2.83121 9.04641C2.90621 9.06509 2.94366 9.14009 2.92498 9.21508V9.21518Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_53",
    d: "M4.24716 8.76524C4.21909 8.84014 4.13461 8.8683 4.0691 8.84014L2.25971 8.09018C2.1941 8.06212 2.15665 7.97773 2.18471 7.91213C2.21287 7.83713 2.29726 7.80897 2.36287 7.83713L4.17216 8.58709C4.24716 8.61515 4.27532 8.69954 4.24716 8.76515V8.76524Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_54",
    d: "M3.63762 7.49954C3.60017 7.56515 3.52517 7.59331 3.45956 7.56515L2.68144 7.17149C2.61583 7.14333 2.58767 7.05895 2.62522 6.98396C2.66267 6.91835 2.73766 6.89019 2.80327 6.91835L3.5813 7.3121C3.647 7.34955 3.67516 7.43403 3.63762 7.49954Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_55",
    d: "M5.01561 7.32146C4.96878 7.38716 4.89378 7.40594 4.82817 7.359L3.20632 6.281C3.14081 6.24345 3.13142 6.15907 3.16887 6.09346C3.20642 6.02785 3.2908 6.00907 3.35641 6.05591L4.98755 7.1434C5.04377 7.18095 5.06255 7.26533 5.01561 7.32146Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_56",
    d: "M4.66859 5.96215C4.62176 6.01838 4.53737 6.03715 4.48115 5.99022L3.7968 5.45595C3.74058 5.40902 3.73119 5.32464 3.77803 5.26841C3.82486 5.21219 3.90924 5.19342 3.96556 5.24035L4.64982 5.77461C4.70614 5.82155 4.71553 5.90583 4.66859 5.96215Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_57",
    d: "M6.06574 6.05587C6.00962 6.11219 5.92514 6.11219 5.8783 6.05587L4.48163 4.67788C4.42541 4.62165 4.4347 4.53727 4.48163 4.49034C4.53786 4.43421 4.62224 4.43421 4.66907 4.49034L6.05655 5.86843C6.11277 5.91526 6.11277 6.00903 6.06594 6.05597L6.06574 6.05587Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_58",
    d: "M5.98127 4.65911C5.92505 4.70604 5.84066 4.70604 5.79373 4.64972L5.22183 3.99353C5.17509 3.93731 5.18438 3.85293 5.2407 3.80609C5.29682 3.75916 5.3813 3.75916 5.42814 3.81538L6.00004 4.47167C6.04688 4.5185 6.03749 4.60289 5.98127 4.65911Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_59",
    d: "M7.3312 5.01542C7.26559 5.06226 7.18121 5.04348 7.14366 4.97787L6.04688 3.35602C6.00934 3.29041 6.02811 3.20603 6.08433 3.16858C6.14994 3.12174 6.23432 3.14052 6.27187 3.20613L7.35927 4.82788C7.4062 4.89349 7.38743 4.97787 7.3312 5.01532V5.01542Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_60",
    d: "M7.52809 3.62793C7.46249 3.66538 7.3781 3.6467 7.34065 3.58109L6.90935 2.82174C6.8719 2.75613 6.89997 2.67175 6.96567 2.63421C7.03128 2.59676 7.11566 2.61543 7.15311 2.68114L7.58432 3.44039C7.61248 3.506 7.5937 3.59038 7.52819 3.62793H7.52809Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_61",
    d: "M8.77495 4.24673C8.70005 4.27479 8.62496 4.24673 8.59689 4.18112L7.83755 2.37172C7.80948 2.30612 7.84693 2.22173 7.91254 2.19357C7.98754 2.16551 8.06253 2.19357 8.0906 2.25918L8.84995 4.06848C8.87811 4.13409 8.84066 4.21847 8.77495 4.24653V4.24673Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_62",
    d: "M9.23416 2.91553C9.15916 2.94359 9.08416 2.90604 9.0561 2.83114L8.78418 2.00609C8.75612 1.94048 8.80295 1.8561 8.86856 1.83742C8.93417 1.81865 9.01855 1.84681 9.04662 1.9218L9.31854 2.74676C9.3466 2.81237 9.30915 2.88737 9.23416 2.91543V2.91553Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_63",
    d: "M10.3405 3.7685C10.2655 3.78727 10.1905 3.74043 10.1811 3.66534L9.78733 1.7436C9.76856 1.66861 9.82488 1.603 9.89978 1.58422C9.97487 1.56545 10.0498 1.61229 10.0592 1.68738L10.453 3.60922C10.4623 3.67473 10.4155 3.74972 10.3405 3.7685Z",
    fill: "#F3F3F3"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_64",
    d: "M11.0526 2.54984C10.9776 2.55922 10.912 2.51239 10.8933 2.43739L10.7808 1.57489C10.7714 1.49989 10.8276 1.43428 10.9027 1.4249C10.9776 1.41551 11.0432 1.46244 11.062 1.53744L11.1745 2.39985C11.1839 2.47484 11.1276 2.54045 11.0526 2.54984Z",
    fill: "#F3F3F3"
  })), /*#__PURE__*/react.createElement("path", {
    id: "Path_65",
    d: "M19.5834 4.41541L10.7339 10.7057L13.3588 13.3118L19.5834 4.41541",
    fill: "#CD151E"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_66",
    d: "M10.7432 10.687L12.065 11.99L19.5833 4.41541L10.7432 10.687Z",
    fill: "#FA5153"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_67",
    d: "M10.7432 10.687L13.3681 13.293L4.51855 19.5834L10.7432 10.6869V10.687Z",
    fill: "#ACACAC"
  }), /*#__PURE__*/react.createElement("path", {
    id: "Path_68",
    d: "M4.51855 19.5834L12.065 11.99L10.7431 10.6869L4.51855 19.5834Z",
    fill: "#EEEEEE"
  }))), /*#__PURE__*/react.createElement("symbol", {
    id: "settings",
    viewBox: "0 0 24 24",
    fill: "none"
  }, /*#__PURE__*/react.createElement("path", {
    fillRule: "evenodd",
    clipRule: "evenodd",
    d: "M15.6326 0C18.042 0 19.2464 0 20.5434 0.41C21.9594 0.9254 23.0746 2.0406 23.59 3.4566C24 4.7534 24 5.9582 24 8.3674V15.6326C24 18.042 24 19.2464 23.59 20.5434C23.0746 21.9594 21.9594 23.0746 20.5434 23.5898C19.2464 24 18.042 24 15.6326 24H8.3674C5.958 24 4.7534 24 3.4566 23.5898C2.0406 23.0746 0.9254 21.9594 0.41 20.5434C0 19.2464 0 18.042 0 15.6326V8.3674C0 5.9582 0 4.7534 0.41 3.4566C0.9254 2.0406 2.0406 0.9254 3.4566 0.41C4.7534 0 5.958 0 8.3674 0H15.6326Z",
    fill: "#C0C4C9"
  }), /*#__PURE__*/react.createElement("circle", {
    cx: "12.0001",
    cy: "12",
    r: "10.4",
    fill: "#2E2E30"
  }), /*#__PURE__*/react.createElement("g", {
    filter: "url(#filter0_d)"
  }, /*#__PURE__*/react.createElement("path", {
    fillRule: "evenodd",
    clipRule: "evenodd",
    d: "M12.7881 6.4704C12.7606 6.46652 12.733 6.46286 12.7055 6.4594L12.6413 5.69824C12.6214 5.46259 12.5589 5.45867 12.5013 5.686L12.3146 6.42394C12.2253 6.41895 12.1363 6.41611 12.0476 6.41539L11.8909 5.66669C11.8424 5.43522 11.7799 5.43895 11.7505 5.67159L11.6552 6.42596C11.5632 6.43168 11.4717 6.43966 11.3807 6.44986L11.1475 5.7246C11.0751 5.49947 11.0133 5.50971 11.0084 5.74415L10.9924 6.50734C10.9046 6.52353 10.8174 6.54179 10.7309 6.56208L10.4107 5.86983C10.3114 5.6552 10.2513 5.67289 10.275 5.90619L10.3521 6.66516C10.267 6.69159 10.1826 6.72001 10.0991 6.75039L9.69623 6.10134C9.57152 5.9004 9.51403 5.92529 9.56598 6.15396L9.73491 6.89748C9.65356 6.93372 9.57316 6.97185 9.49378 7.01183L9.01417 6.41587C8.86591 6.23163 8.81188 6.26334 8.89132 6.48397L9.14936 7.20069C9.07285 7.24619 8.99746 7.29348 8.92325 7.34251L8.37415 6.80901C8.20454 6.64421 8.15478 6.68227 8.26051 6.89157L8.60336 7.57029C8.53043 7.62615 8.45886 7.68379 8.38873 7.74317L7.78994 7.2724C7.60403 7.12624 7.55853 7.16928 7.68556 7.36639L8.09835 8.00692C8.0344 8.06921 7.9719 8.13306 7.91091 8.19842L7.25993 7.80456C7.05759 7.68215 7.01767 7.73042 7.16777 7.91058L7.65382 8.49394C7.59746 8.5635 7.5427 8.63448 7.48962 8.70685L6.79665 8.39579C6.5809 8.29894 6.54716 8.35172 6.7181 8.51225L7.26951 9.03005C7.22162 9.10598 7.17547 9.1832 7.13113 9.26168L6.40663 9.03776C6.18069 8.96793 6.15363 9.02443 6.34286 9.16292L6.95114 9.60811C6.91249 9.68934 6.87572 9.77173 6.84087 9.85523L6.09539 9.72144C5.86262 9.67967 5.84265 9.73904 6.04734 9.85344L6.70341 10.2201C6.67377 10.308 6.6462 10.397 6.62078 10.487L5.86968 10.4322C5.63382 10.415 5.62016 10.4761 5.8357 10.5685L6.52801 10.8652C6.50957 10.9535 6.49315 11.0426 6.47881 11.1326L5.72733 11.1697C5.49113 11.1814 5.48503 11.2437 5.71021 11.3091L6.43074 11.5185C6.42255 11.6095 6.4166 11.7004 6.41285 11.7908L5.67333 11.9189C5.44031 11.9593 5.44185 12.0219 5.67333 12.0594L6.41021 12.1787C6.41277 12.2705 6.41758 12.3619 6.4246 12.4527L5.70844 12.6693C5.48208 12.7377 5.49124 12.7997 5.72556 12.8087L6.46781 12.8372C6.48168 12.931 6.4979 13.0242 6.51643 13.1166L5.83203 13.4047C5.61406 13.4964 5.62965 13.5571 5.86363 13.5415L6.60537 13.4923C6.62977 13.5814 6.65633 13.6697 6.68501 13.7572L6.04199 14.1258C5.83683 14.2434 5.85969 14.3018 6.09003 14.2578L6.81766 14.119C6.8525 14.2048 6.88944 14.2896 6.9284 14.3734L6.33589 14.817C6.14659 14.9588 6.17639 15.0139 6.39966 14.9422L7.10257 14.7165C7.14738 14.7978 7.19417 14.8778 7.24289 14.9567L6.7096 15.4686C6.53898 15.6323 6.57528 15.6834 6.78815 15.585L7.45586 15.2765C7.51005 15.3521 7.5661 15.4264 7.62396 15.4993L7.15786 16.0713C7.00848 16.2546 7.05072 16.3008 7.25002 16.1773L7.87255 15.7913C7.93719 15.8622 8.00368 15.9315 8.07194 15.999L7.67115 16.6121C7.54175 16.8101 7.5886 16.8516 7.77388 16.7079L8.35287 16.2588C8.42378 16.32 8.4963 16.3795 8.57037 16.4372L8.24811 17.0929C8.14379 17.3051 8.19536 17.3407 8.36175 17.1755L8.87935 16.6614C8.95725 16.714 9.03662 16.7647 9.1174 16.8134L8.87798 17.5019C8.8003 17.7253 8.85582 17.7543 9.00084 17.57L9.45021 16.999C9.53398 17.042 9.61907 17.083 9.70541 17.1219L9.55188 17.8335C9.50201 18.0647 9.56065 18.0867 9.68212 17.8861L10.0575 17.2662C10.1459 17.299 10.2354 17.3296 10.326 17.358L10.2603 18.0829C10.239 18.3184 10.2999 18.3331 10.396 18.1192L10.6925 17.4594C10.7866 17.4821 10.8817 17.5024 10.9777 17.5203L10.9882 18.2446C10.9916 18.4811 11.0537 18.4894 11.1269 18.2666L11.3535 17.5775C11.4482 17.5887 11.5426 17.5974 11.6367 17.6038L11.7353 18.321C11.7675 18.5553 11.8301 18.5559 11.8757 18.3259L12.0161 17.6166C12.1116 17.6166 12.2066 17.6141 12.3012 17.6093L12.4862 18.3083C12.5467 18.5369 12.609 18.5299 12.6261 18.296L12.6789 17.577C12.7738 17.5657 12.8681 17.5519 12.9616 17.5358L13.2303 18.2067C13.3183 18.4262 13.3792 18.4117 13.3677 18.1775L13.3326 17.4587C13.4254 17.4361 13.5174 17.4112 13.6085 17.3839L13.9573 18.0176C14.0713 18.2248 14.13 18.203 14.0901 17.9719L13.9677 17.2632C14.0594 17.2289 14.15 17.1922 14.2395 17.1532L14.6513 17.7451C14.7863 17.9392 14.8425 17.9114 14.7786 17.6857L14.5818 16.9903C14.6663 16.9465 14.7497 16.9005 14.8318 16.8525L15.3136 17.391C15.4713 17.5672 15.5236 17.5327 15.4327 17.3165L15.1526 16.6502C15.2312 16.5968 15.3085 16.5414 15.3843 16.4842L15.9293 16.9609C16.1073 17.1165 16.155 17.0759 16.0385 16.8725L15.6793 16.2453C15.751 16.1831 15.8212 16.1191 15.8897 16.0533L16.4898 16.4608C16.6854 16.5936 16.7278 16.5475 16.5874 16.3598L16.1546 15.7813C16.2184 15.7112 16.2804 15.6394 16.3407 15.566L16.9871 15.8978C17.1975 16.0058 17.234 15.9549 17.0717 15.7857L16.5717 15.2643C16.6281 15.1852 16.6825 15.1045 16.7349 15.0223L17.4105 15.284C17.6311 15.3694 17.662 15.315 17.4829 15.1636L16.9281 14.6948C16.9733 14.612 17.0164 14.5278 17.0575 14.4423L17.762 14.6202C17.9913 14.6781 18.0154 14.6203 17.8192 14.4919L17.2105 14.0936C17.2452 14.0063 17.2779 13.9179 17.3084 13.8283L18.0325 13.9194C18.2671 13.949 18.284 13.8886 18.0735 13.7851L17.4191 13.4631C17.4431 13.3728 17.465 13.2815 17.4847 13.1893L18.218 13.1915C18.4545 13.1923 18.4639 13.1303 18.2424 13.0532L17.5518 12.8127L17.5542 12.7953C17.5669 12.7055 17.5773 12.6158 17.5855 12.5265L18.3146 12.4521C18.5498 12.4281 18.5527 12.3655 18.3244 12.312L17.6078 12.1439C17.6101 12.0503 17.61 11.9571 17.6076 11.8643L18.3244 11.7011C18.5549 11.6486 18.5501 11.5861 18.317 11.5608L17.5844 11.4812C17.5756 11.3884 17.5645 11.2961 17.5511 11.2044L18.2451 10.9541C18.4676 10.8739 18.4552 10.8125 18.2207 10.8158L17.4824 10.8261C17.4627 10.7354 17.4408 10.6455 17.4167 10.5563L18.078 10.2218C18.289 10.1151 18.2692 10.0557 18.0369 10.0875L17.3033 10.188C17.2731 10.1008 17.2408 10.0145 17.2064 9.92914L17.8253 9.51446C18.0217 9.38281 17.9949 9.32623 17.7681 9.38613L17.0499 9.57591C17.0087 9.49097 16.9653 9.40715 16.92 9.32453L17.4923 8.84724C17.6739 8.69578 17.6413 8.64232 17.4221 8.72559L16.722 8.99155C16.6727 8.91479 16.6215 8.83925 16.5685 8.76501L17.0809 8.21889C17.2427 8.04642 17.2038 7.99734 16.9964 8.1067L16.3323 8.45683C16.2746 8.3867 16.2152 8.31795 16.1542 8.25065L16.598 7.64368C16.7376 7.45278 16.693 7.4088 16.5004 7.54263L15.883 7.97177C15.8177 7.90913 15.7509 7.84802 15.6825 7.78851L16.0503 7.12972C16.1656 6.92323 16.1159 6.88502 15.9411 7.04132L15.38 7.54306C15.308 7.48873 15.2346 7.43606 15.1599 7.38512L15.4456 6.68426C15.5348 6.46526 15.4809 6.43338 15.3264 6.60982L14.8301 7.17683C14.7501 7.13017 14.6688 7.08541 14.5862 7.04261L14.7967 6.31693C14.8626 6.08981 14.8056 6.06374 14.6705 6.25536L14.2333 6.87514C14.1511 6.83966 14.0679 6.80605 13.9836 6.77438L14.1045 6.02567C14.1422 5.79221 14.0825 5.77328 13.9717 5.97994L13.6126 6.64968C13.5272 6.62428 13.4409 6.60083 13.3537 6.57937L13.3826 5.81847C13.3916 5.58215 13.33 5.57064 13.2452 5.78926L12.97 6.49895C12.9097 6.48849 12.8491 6.47897 12.7881 6.4704ZM11.3597 16.5553C13.8755 16.9089 16.2016 15.156 16.5551 12.6403C16.9087 10.1245 15.1559 7.7984 12.6401 7.44483C10.1243 7.09126 7.79823 8.84408 7.44466 11.3599C7.09109 13.8756 8.84391 16.2017 11.3597 16.5553Z",
    fill: "#AFB0B3"
  })), /*#__PURE__*/react.createElement("path", {
    fillRule: "evenodd",
    clipRule: "evenodd",
    d: "M11.86 3.60114C11.9066 3.60038 11.9533 3.59999 12 3.59999C12.1058 3.59999 12.2111 3.60195 12.3159 3.60582L12.5433 2.63614C12.6227 2.29787 12.7154 2.30207 12.751 2.65066L12.8522 3.64269C13.0043 3.65801 13.1552 3.6774 13.3048 3.70073L13.6487 2.76611C13.7687 2.44003 13.8602 2.4555 13.8531 2.80583L13.8327 3.8005C13.9819 3.83371 14.1296 3.87088 14.2757 3.9119L14.731 3.02611C14.8898 2.71709 14.9788 2.7436 14.929 3.09044L14.7877 4.07364C14.935 4.12542 15.0803 4.18118 15.2237 4.2408L15.7667 3.41093C15.957 3.1202 16.0427 3.15586 15.9569 3.4956L15.7126 4.46288C15.8494 4.53038 15.9841 4.6015 16.1165 4.6761L16.7578 3.91729C16.9821 3.65192 17.0628 3.69776 16.9362 4.02451L16.576 4.95462C16.7036 5.03769 16.8288 5.12413 16.9515 5.21382L17.6819 4.53752C17.9369 4.30145 18.0114 4.35679 17.846 4.66568L17.3752 5.54467C17.492 5.64206 17.6062 5.74255 17.7175 5.84604L18.5261 5.26287C18.8079 5.05963 18.8752 5.12364 18.6733 5.41007L18.0994 6.2244C18.204 6.33476 18.3055 6.44795 18.404 6.56385L19.2785 6.08315C19.5829 5.91577 19.6419 5.9875 19.4066 6.24719L18.7389 6.98434C18.8317 7.10886 18.9212 7.23605 19.0071 7.36576L19.9225 6.98097C20.2428 6.84634 20.294 6.92383 20.0329 7.15751L19.2894 7.82284C19.3651 7.95469 19.4374 8.08878 19.506 8.22501L20.4616 7.95463C20.7959 7.86003 20.8372 7.94318 20.5496 8.14329L19.7321 8.71201C19.7917 8.85187 19.8476 8.99368 19.8996 9.13732L20.8816 8.98533C21.2249 8.93218 21.2558 9.01974 20.9459 9.1833L20.0662 9.64765C20.1086 9.79343 20.1472 9.94086 20.1819 10.0898L21.1765 10.0586C21.5238 10.0477 21.5437 10.1383 21.2162 10.2629L20.2866 10.6165C20.3114 10.766 20.3322 10.9168 20.349 11.0688L21.3422 11.1592C21.6882 11.1907 21.697 11.2831 21.3568 11.3669L20.3909 11.6046C20.397 11.7356 20.4 11.8675 20.4 12C20.4 12.0236 20.3999 12.0471 20.3997 12.0706L21.3748 12.2637C21.7157 12.3312 21.7147 12.424 21.3676 12.4717L20.3784 12.6077C20.3675 12.7603 20.3525 12.9117 20.3335 13.0619L21.278 13.3724C21.608 13.4809 21.5958 13.573 21.2454 13.578L20.2493 13.5924C20.2205 13.7426 20.1877 13.8914 20.1509 14.0386V14.0386L21.0505 14.4619C21.3648 14.6098 21.3414 14.6997 20.9931 14.662L20.0044 14.5551C19.9579 14.7007 19.9076 14.8446 19.8536 14.9866L20.6955 15.5168C20.9895 15.7019 20.9553 15.7883 20.6141 15.7084L19.6466 15.482C19.5819 15.6238 19.5134 15.7636 19.4411 15.9011L20.2203 16.5143C20.4933 16.7292 20.4503 16.8115 20.1194 16.6964L19.1762 16.3684C19.0968 16.4985 19.014 16.6262 18.928 16.7515L19.628 17.4565C19.8728 17.7031 19.8201 17.7795 19.5057 17.6249L18.6096 17.1845C18.5156 17.3042 18.4185 17.4212 18.3183 17.5355L18.9283 18.322C19.1412 18.5965 19.0796 18.6659 18.7863 18.4742L17.9511 17.9283C17.8438 18.036 17.7337 18.1408 17.6207 18.2425L18.1309 19.0985C18.3088 19.3969 18.2392 19.4583 17.9714 19.2323L17.2101 18.5895C17.0909 18.6838 16.9691 18.775 16.8448 18.8629L17.2471 19.7751C17.3873 20.093 17.3107 20.1454 17.0725 19.8884L16.3964 19.159C16.2642 19.2404 16.1295 19.3182 15.9925 19.3924L16.2957 20.3369C16.4019 20.6678 16.3203 20.7119 16.1102 20.4314L15.5122 19.6328C15.3741 19.6964 15.2341 19.7564 15.0921 19.8126L15.2781 20.7875C15.3432 21.1288 15.2568 21.1627 15.0825 20.8587L14.5868 19.9942C14.4423 20.0409 14.2962 20.0838 14.1484 20.1228L14.2142 21.1144C14.2372 21.4611 14.1473 21.4841 14.0114 21.1612L13.6249 20.243V20.243C13.4762 20.2721 13.3261 20.2973 13.1747 20.3185L13.1191 21.3129C13.0997 21.6598 13.0076 21.6718 12.912 21.3347L12.6403 20.376C12.4895 20.3873 12.3377 20.3947 12.1848 20.398L12.0081 21.3803C11.9465 21.7223 11.8537 21.723 11.7999 21.3767L11.6471 20.3927C11.4911 20.3863 11.3361 20.3756 11.1823 20.3607L10.9051 21.3148C10.8081 21.6485 10.7157 21.6394 10.6985 21.2895L10.6492 20.292C10.4983 20.2676 10.3488 20.2392 10.2008 20.2068L9.80935 21.12C9.67247 21.4393 9.58187 21.4191 9.60737 21.0696L9.6799 20.0755C9.53306 20.0334 9.38787 19.9874 9.24444 19.9376L8.74437 20.7967C8.56959 21.097 8.48214 21.0659 8.55003 20.7221L8.74299 19.7452C8.60237 19.686 8.4637 19.6231 8.3271 19.5566L7.72514 20.3496C7.51507 20.6263 7.43205 20.5848 7.54134 20.2518L7.85184 19.306C7.71945 19.2306 7.58931 19.1518 7.46155 19.0696H7.46155L6.76601 19.7848C6.52378 20.0339 6.44645 19.9825 6.59549 19.6654L7.01893 18.7645C6.89387 18.6722 6.77146 18.5766 6.65184 18.4777L5.8878 19.1143C5.62086 19.3367 5.54932 19.2775 5.73069 18.9777L6.24837 18.122C6.13767 18.018 6.0298 17.911 5.92488 17.8011L5.08785 18.3405C4.7958 18.5287 4.732 18.4613 4.94856 18.1858L5.56593 17.4005C5.46823 17.2842 5.37363 17.1653 5.28225 17.0438L4.38517 17.4774C4.07235 17.6286 4.01725 17.5539 4.26577 17.3069L4.97296 16.6039C4.88961 16.477 4.8096 16.3476 4.73306 16.216L3.78964 16.5371C3.46073 16.6491 3.41514 16.5682 3.69191 16.3533L4.47798 15.743C4.41021 15.607 4.34601 15.469 4.28552 15.329L3.30967 15.5329C2.96956 15.6039 2.93418 15.5181 3.23507 15.3385L4.08841 14.8293C4.03619 14.6833 3.9879 14.5354 3.94366 14.3858L2.95591 14.4861C2.61024 14.5212 2.58401 14.4321 2.90203 14.285L3.80799 13.8659C3.77448 13.7181 3.74486 13.5689 3.71925 13.4183L2.72471 13.3974C2.37734 13.3901 2.36217 13.2985 2.69574 13.1913L3.64616 12.8856C3.63041 12.7353 3.61862 12.5838 3.6109 12.4312L2.6241 12.289C2.28021 12.2394 2.27631 12.1467 2.62047 12.0809L3.60069 11.8934C3.60259 11.7406 3.60857 11.5888 3.61852 11.4381L2.6555 11.1764C2.32021 11.0853 2.32764 10.9928 2.67726 10.9694L3.67102 10.9029C3.69121 10.7481 3.71562 10.5946 3.74412 10.4426L3.74412 10.4426L2.81862 10.0836C2.49469 9.95795 2.51175 9.8667 2.8619 9.87998L3.86009 9.91785C3.89783 9.76987 3.93949 9.62346 3.98497 9.47874L3.10988 9.0095C2.80367 8.8453 2.83173 8.75681 3.17765 8.81267L4.16246 8.9717C4.21749 8.82938 4.27628 8.68895 4.33871 8.5505L3.52634 7.97741C3.24243 7.77712 3.28106 7.69271 3.61759 7.79031L4.57521 8.06804C4.64663 7.93346 4.7216 7.80106 4.79999 7.67095L4.06214 7.00188C3.80476 6.76849 3.85339 6.68942 4.17552 6.8273L5.09202 7.2196C5.17869 7.09459 5.26866 6.97205 5.36181 6.85211L5.36182 6.85211L4.70976 6.09666C4.48273 5.83364 4.54064 5.76108 4.84356 5.93719L5.70507 6.43805C5.80792 6.32174 5.91394 6.2083 6.02299 6.09787L5.45557 5.28141C5.25729 4.9961 5.32246 4.93 5.60532 5.13681L6.41297 5.72734C6.52634 5.62628 6.64247 5.52826 6.76123 5.43339L6.29722 4.55328C6.13518 4.24593 6.20793 4.18826 6.46347 4.428L7.19184 5.11134C7.31632 5.02429 7.44328 4.94053 7.57257 4.86018L7.21923 3.92994C7.09586 3.60514 7.17509 3.55676 7.39951 3.82586L8.03786 4.59129L8.03786 4.59129C8.17178 4.51952 8.30787 4.45128 8.446 4.38668L8.20863 3.42019C8.12576 3.08277 8.2103 3.04441 8.40025 3.33885L8.93962 4.17492C9.08105 4.11957 9.22435 4.06793 9.36939 4.02015L9.25149 3.03121C9.21036 2.6862 9.29894 2.65843 9.45159 2.97383L9.88467 3.8686C10.0346 3.82969 10.1862 3.79483 10.3394 3.76412L10.3255 2.77172C10.3207 2.42431 10.4117 2.40595 10.5305 2.73557L10.8694 3.67543C11.0194 3.65526 11.1706 3.63904 11.3229 3.62689L11.4304 2.63802C11.4679 2.29261 11.5605 2.28547 11.6383 2.62713L11.86 3.60114ZM13.0199 11.518C12.5788 11.5032 12.0367 11.1121 11.8182 10.7304L9.27362 6.323C8.99923 5.84347 9.31324 5.30629 9.73534 5.06259C10.0181 4.89931 10.956 4.6016 12.1983 4.6026C15.6917 4.69448 18.582 7.20741 19.253 10.5251C19.3134 11.0802 18.8418 11.5246 18.3431 11.5171L13.0199 11.518ZM8.4529 6.7669L11.0843 11.291C11.2991 11.6763 11.2877 12.3719 11.0664 12.7519L8.52176 17.1593C8.24366 17.6367 7.5535 17.6906 7.1314 17.4469C6.85059 17.2848 6.13213 16.6297 5.51475 15.5667C4.93175 14.5089 4.60003 13.2932 4.60003 12C4.60003 9.81858 5.53941 7.86818 7.04104 6.51381C7.52623 6.24272 8.20009 6.31352 8.4529 6.7669ZM19.1731 13.4178C19.1731 12.9304 18.7992 12.4554 18.2467 12.4533H13.1575C12.7177 12.4516 12.1744 12.7572 11.9482 13.1359L9.34588 17.6768C9.06165 18.1525 9.28777 18.7552 9.83938 19.0179C10.6702 19.4672 12.8287 19.45 14.4881 18.9713C15.7617 18.5167 16.8742 17.723 17.7169 16.699C18.8274 15.2929 19.1731 13.8357 19.1731 13.4178ZM12 12.4C12.2209 12.4 12.4 12.2209 12.4 12C12.4 11.7791 12.2209 11.6 12 11.6C11.7791 11.6 11.6 11.7791 11.6 12C11.6 12.2209 11.7791 12.4 12 12.4Z",
    fill: "#C3C4C6"
  }), /*#__PURE__*/react.createElement("defs", null, /*#__PURE__*/react.createElement("filter", {
    id: "filter0_d",
    x: "3.65869",
    y: "3.65869",
    width: "16.6827",
    height: "16.6827",
    filterUnits: "userSpaceOnUse",
    colorInterpolationFilters: "sRGB"
  }, /*#__PURE__*/react.createElement("feFlood", {
    floodOpacity: "0",
    result: "BackgroundImageFix"
  }), /*#__PURE__*/react.createElement("feColorMatrix", {
    "in": "SourceAlpha",
    type: "matrix",
    values: "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0",
    result: "hardAlpha"
  }), /*#__PURE__*/react.createElement("feOffset", null), /*#__PURE__*/react.createElement("feGaussianBlur", {
    stdDeviation: "0.5"
  }), /*#__PURE__*/react.createElement("feColorMatrix", {
    type: "matrix",
    values: "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.2 0"
  }), /*#__PURE__*/react.createElement("feBlend", {
    mode: "normal",
    in2: "BackgroundImageFix",
    result: "effect1_dropShadow"
  }), /*#__PURE__*/react.createElement("feBlend", {
    mode: "normal",
    "in": "SourceGraphic",
    in2: "effect1_dropShadow",
    result: "shape"
  })))), /*#__PURE__*/react.createElement("symbol", {
    id: "compass",
    viewBox: "0 0 24 24",
    fill: "none"
  }, /*#__PURE__*/react.createElement("circle", {
    cx: "12",
    cy: "12",
    r: "9",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  }), /*#__PURE__*/react.createElement("path", {
    d: "M9 15L15 9",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round"
  }), /*#__PURE__*/react.createElement("path", {
    d: "M11 11L13 13",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round"
  }), /*#__PURE__*/react.createElement("path", {
    d: "M12.5 10.5L13.5 11.5",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round"
  }), /*#__PURE__*/react.createElement("path", {
    d: "M10.5 12.5L11.5 13.5",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round"
  })), /*#__PURE__*/react.createElement("symbol", {
    id: "network",
    viewBox: "0 0 24 24",
    fill: "none"
  }, /*#__PURE__*/react.createElement("path", {
    fillRule: "evenodd",
    clipRule: "evenodd",
    d: "M12 21C16.9706 21 21 16.9706 21 12C21 7.02944 16.9706 3 12 3C7.02944 3 3 7.02944 3 12C3 16.9706 7.02944 21 12 21Z",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  }), /*#__PURE__*/react.createElement("path", {
    d: "M14.5001 3.5C14.7747 4.66688 14.9927 5.83376 15.1542 7.00065",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  }), /*#__PURE__*/react.createElement("path", {
    d: "M19.0002 7C17.7516 7.35674 16.503 7.61803 15.2544 7.78387C15.4181 9.18865 15.5002 10.5943 15.5002 12C15.5002 13.406 15.4181 14.812 15.2539 16.218C16.5017 16.3817 17.7509 16.6431 19.0002 17",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  }), /*#__PURE__*/react.createElement("path", {
    d: "M15.1541 17.0004C14.9926 18.1669 14.7747 19.3335 14.5002 20.5",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  }), /*#__PURE__*/react.createElement("path", {
    d: "M9.49982 20.5C9.22533 19.3335 9.00736 18.1669 8.84589 17.0004",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  }), /*#__PURE__*/react.createElement("path", {
    d: "M5 17C6.24891 16.6432 7.49781 16.3818 8.74672 16.216C8.58208 14.812 8.5 13.406 8.5 12C8.5 10.5943 8.58205 9.18865 8.74614 7.78297C7.49781 7.61816 6.24891 7.35683 5 7V7",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  }), /*#__PURE__*/react.createElement("path", {
    d: "M8.84582 7.00065C9.0073 5.83376 9.22533 4.66688 9.49989 3.5V3.5",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  }), /*#__PURE__*/react.createElement("path", {
    d: "M9.50098 16.1275C10.3341 16.0425 11.1673 16 12.0004 16C12.8335 16 13.6667 16.0425 14.4998 16.1275",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  }), /*#__PURE__*/react.createElement("path", {
    d: "M14.4998 7.87253C13.6667 7.95753 12.8335 8.00003 12.0004 8.00003C11.1673 8.00003 10.3341 7.95753 9.50098 7.87253",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  }), /*#__PURE__*/react.createElement("path", {
    d: "M3 12H21",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  })), /*#__PURE__*/react.createElement("symbol", {
    id: "faq",
    viewBox: "0 0 24 24",
    fill: "none",
    xmlns: "http://www.w3.org/2000/svg"
  }, /*#__PURE__*/react.createElement("g", {
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  }, /*#__PURE__*/react.createElement("path", {
    clipRule: "evenodd",
    d: "M12 20.5a8.5 8.5 0 1 0 0-17 8.5 8.5 0 0 0 0 17Z"
  }), /*#__PURE__*/react.createElement("path", {
    d: "M10 9.303c.02-.821 1.002-1.526 2.004-1.526s1.6.39 2.004 1.223c.31.703.006 1.546-1.069 2.28-.87.557-1.143 1.133-1.143 2.179M11.796 15.895c.012.002 0-.19 0-.19"
  }))), /*#__PURE__*/react.createElement("symbol", {
    id: "arrow",
    viewBox: "0 0 24 24",
    fill: "none",
    xmlns: "http://www.w3.org/2000/svg"
  }, /*#__PURE__*/react.createElement("path", {
    d: "M8.03516 10.9305L11.9647 14.9997L16.0339 11.0702",
    stroke: "#A4A4A4",
    strokeWidth: "1.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  })));
};
/* eslint-enable max-len */
;// CONCATENATED MODULE: ./src/pages/common/ui/Icons/index.ts

// EXTERNAL MODULE: ./node_modules/lodash/throttle.js
var throttle = __webpack_require__(3493);
var throttle_default = /*#__PURE__*/__webpack_require__.n(throttle);
;// CONCATENATED MODULE: ./src/pages/common/hooks/useAppearanceTheme.ts



var useAppearanceTheme = function useAppearanceTheme(appearanceTheme) {
  (0,react.useLayoutEffect)(function () {
    var STORAGE_KEY = 'appearance_theme';
    var DARK_THEME_CLASS = 'dark-mode';
    var LIGHT_THEME_CLASS = 'light-mode';
    var SET_TO_STORAGE_TIMEOUT = 500;
    var throttledSetToStorage = throttle_default()(function (mode) {
      localStorage.setItem(STORAGE_KEY, mode);
    }, SET_TO_STORAGE_TIMEOUT);
    var theme = appearanceTheme;

    if (!theme) {
      var storedTheme = localStorage.getItem(STORAGE_KEY);

      if (storedTheme && Object.values(AppearanceTheme).includes(storedTheme)) {
        theme = storedTheme;
      } else {
        theme = APPEARANCE_THEME_DEFAULT;
      }
    } else {
      if (!Object.values(AppearanceTheme).includes(theme)) {
        theme = APPEARANCE_THEME_DEFAULT;
      }

      throttledSetToStorage(theme);
    }

    switch (theme) {
      case AppearanceTheme.Dark:
        {
          document.documentElement.classList.add(DARK_THEME_CLASS);
          document.documentElement.classList.remove(LIGHT_THEME_CLASS);
          break;
        }

      case AppearanceTheme.Light:
        {
          document.documentElement.classList.add(LIGHT_THEME_CLASS);
          document.documentElement.classList.remove(DARK_THEME_CLASS);
          break;
        }

      case AppearanceTheme.System:
        {
          document.documentElement.classList.remove(DARK_THEME_CLASS);
          document.documentElement.classList.remove(LIGHT_THEME_CLASS);
          break;
        }

      default:
        throw new Error("Impossible theme value: ".concat(theme));
    }
  }, [appearanceTheme]);
};
;// CONCATENATED MODULE: ./node_modules/@adguard/translate/dist/index.esm.js
function index_esm_defineProperty(obj, key, value) {
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

function index_esm_classCallCheck(instance, Constructor) {
  if (!(instance instanceof Constructor)) {
    throw new TypeError("Cannot call a class as a function");
  }
}

function index_esm_defineProperties(target, props) {
  for (var i = 0; i < props.length; i++) {
    var descriptor = props[i];
    descriptor.enumerable = descriptor.enumerable || false;
    descriptor.configurable = true;
    if ("value" in descriptor) descriptor.writable = true;
    Object.defineProperty(target, descriptor.key, descriptor);
  }
}

function index_esm_createClass(Constructor, protoProps, staticProps) {
  if (protoProps) index_esm_defineProperties(Constructor.prototype, protoProps);
  if (staticProps) index_esm_defineProperties(Constructor, staticProps);
  return Constructor;
}

function index_esm_arrayLikeToArray(arr, len) {
  if (len == null || len > arr.length) len = arr.length;

  for (var i = 0, arr2 = new Array(len); i < len; i++) {
    arr2[i] = arr[i];
  }

  return arr2;
}

function _arrayWithoutHoles(arr) {
  if (Array.isArray(arr)) return index_esm_arrayLikeToArray(arr);
}

function _iterableToArray(iter) {
  if (typeof Symbol !== "undefined" && Symbol.iterator in Object(iter)) return Array.from(iter);
}

function index_esm_unsupportedIterableToArray(o, minLen) {
  if (!o) return;
  if (typeof o === "string") return index_esm_arrayLikeToArray(o, minLen);
  var n = Object.prototype.toString.call(o).slice(8, -1);
  if (n === "Object" && o.constructor) n = o.constructor.name;
  if (n === "Map" || n === "Set") return Array.from(o);
  if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return index_esm_arrayLikeToArray(o, minLen);
}

function _nonIterableSpread() {
  throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.");
}

function _toConsumableArray(arr) {
  return _arrayWithoutHoles(arr) || _iterableToArray(arr) || index_esm_unsupportedIterableToArray(arr) || _nonIterableSpread();
}

var NODE_TYPES;

(function (NODE_TYPES) {
  NODE_TYPES["PLACEHOLDER"] = "placeholder";
  NODE_TYPES["TEXT"] = "text";
  NODE_TYPES["TAG"] = "tag";
  NODE_TYPES["VOID_TAG"] = "void_tag";
})(NODE_TYPES || (NODE_TYPES = {}));

var isTextNode = function isTextNode(node) {
  return node.type === NODE_TYPES.TEXT;
};
var isTagNode = function isTagNode(node) {
  return node.type === NODE_TYPES.TAG;
};
var isPlaceholderNode = function isPlaceholderNode(node) {
  return node.type === NODE_TYPES.PLACEHOLDER;
};
var isVoidTagNode = function isVoidTagNode(node) {
  return node.type === NODE_TYPES.VOID_TAG;
};
var placeholderNode = function placeholderNode(value) {
  return {
    type: NODE_TYPES.PLACEHOLDER,
    value: value
  };
};
var textNode = function textNode(str) {
  return {
    type: NODE_TYPES.TEXT,
    value: str
  };
};
var tagNode = function tagNode(tagName, children) {
  var value = tagName.trim();
  return {
    type: NODE_TYPES.TAG,
    value: value,
    children: children
  };
};
var voidTagNode = function voidTagNode(tagName) {
  var value = tagName.trim();
  return {
    type: NODE_TYPES.VOID_TAG,
    value: value
  };
};
/**
 * Checks if target is node
 * @param target
 */

var isNode = function isNode(target) {
  if (typeof target === 'string') {
    return false;
  }

  return !!target.type;
};

var STATE;

(function (STATE) {
  /**
   * Parser function switches to the text state when parses simple text,
   * or content between open and close tags
   */
  STATE["TEXT"] = "text";
  /**
   * Parser function switches to the tag state when meets open tag brace ("<"), and switches back,
   * when meets closing tag brace (">")
   */

  STATE["TAG"] = "tag";
  /**
   * Parser function switches to the placeholder state when meets in the text
   * open placeholders brace ("{") and switches back to the text state,
   * when meets close placeholder brace ("}")
   */

  STATE["PLACEHOLDER"] = "placeholder";
})(STATE || (STATE = {}));

var CONTROL_CHARS = {
  TAG_OPEN_BRACE: '<',
  TAG_CLOSE_BRACE: '>',
  CLOSING_TAG_MARK: '/',
  PLACEHOLDER_MARK: '%'
};
/**
 * Checks if text length is enough to create text node
 * If text node created, then if stack is not empty it is pushed into stack,
 * otherwise into result
 * @param context
 */

var createTextNodeIfPossible = function createTextNodeIfPossible(context) {
  var text = context.text;

  if (text.length > 0) {
    var node = textNode(text);

    if (context.stack.length > 0) {
      context.stack.push(node);
    } else {
      context.result.push(node);
    }
  }

  context.text = '';
};
/**
 * Checks if lastFromStack tag has any attributes
 * @param lastFromStack
 */


var hasAttributes = function hasAttributes(lastFromStack) {
  // e.g. "a class" or "a href='#'"
  var tagStrParts = lastFromStack.split(' ');
  return tagStrParts.length > 1;
};
/**
 * Handles text state
 */


var textStateHandler = function textStateHandler(context) {
  var currChar = context.currChar,
      currIdx = context.currIdx; // switches to the tag state

  if (currChar === CONTROL_CHARS.TAG_OPEN_BRACE) {
    context.lastTextStateChangeIdx = currIdx;
    return STATE.TAG;
  } // switches to the placeholder state


  if (currChar === CONTROL_CHARS.PLACEHOLDER_MARK) {
    context.lastTextStateChangeIdx = currIdx;
    return STATE.PLACEHOLDER;
  } // remains in the text state


  context.text += currChar;
  return STATE.TEXT;
};
/**
 * Handles placeholder state
 * @param context
 */


var placeholderStateHandler = function placeholderStateHandler(context) {
  var currChar = context.currChar,
      currIdx = context.currIdx,
      lastTextStateChangeIdx = context.lastTextStateChangeIdx,
      placeholder = context.placeholder,
      stack = context.stack,
      result = context.result,
      str = context.str;

  if (currChar === CONTROL_CHARS.PLACEHOLDER_MARK) {
    // if distance between current index and last state change equal to 1,
    // it means that placeholder mark was escaped by itself e.g. "%%",
    // so we return to the text state
    if (currIdx - lastTextStateChangeIdx === 1) {
      context.text += str.substring(lastTextStateChangeIdx, currIdx);
      return STATE.TEXT;
    }

    createTextNodeIfPossible(context);
    var node = placeholderNode(placeholder); // push node to the appropriate stack

    if (stack.length > 0) {
      stack.push(node);
    } else {
      result.push(node);
    }

    context.placeholder = '';
    return STATE.TEXT;
  }

  context.placeholder += currChar;
  return STATE.PLACEHOLDER;
};
/**
 * Switches current state to the tag state and returns tag state handler
 */


var tagStateHandler = function tagStateHandler(context) {
  var currChar = context.currChar,
      text = context.text,
      stack = context.stack,
      result = context.result,
      lastTextStateChangeIdx = context.lastTextStateChangeIdx,
      currIdx = context.currIdx,
      str = context.str;
  var tag = context.tag; // if found tag end ">"

  if (currChar === CONTROL_CHARS.TAG_CLOSE_BRACE) {
    // if the tag is close tag e.g. </a>
    if (tag.indexOf(CONTROL_CHARS.CLOSING_TAG_MARK) === 0) {
      // remove slash from tag
      tag = tag.substring(1);
      var children = [];

      if (text.length > 0) {
        children.push(textNode(text));
        context.text = '';
      }

      var pairTagFound = false; // looking for the pair to the close tag

      while (!pairTagFound && stack.length > 0) {
        var lastFromStack = stack.pop(); // if tag from stack equal to close tag

        if (lastFromStack === tag) {
          // create tag node
          var node = tagNode(tag, children); // and add it to the appropriate stack

          if (stack.length > 0) {
            stack.push(node);
          } else {
            result.push(node);
          }

          children = [];
          pairTagFound = true;
        } else if (isNode(lastFromStack)) {
          // add nodes between close tag and open tag to the children
          children.unshift(lastFromStack);
        } else {
          if (typeof lastFromStack === 'string' && hasAttributes(lastFromStack)) {
            throw new Error("Tags in string should not have attributes: ".concat(str));
          } else {
            throw new Error("String has unbalanced tags: ".concat(str));
          }
        }

        if (stack.length === 0 && children.length > 0) {
          throw new Error("String has unbalanced tags: ".concat(str));
        }
      }

      context.tag = '';
      return STATE.TEXT;
    } // if the tag is void tag e.g. <img/>


    if (tag.lastIndexOf(CONTROL_CHARS.CLOSING_TAG_MARK) === tag.length - 1) {
      tag = tag.substring(0, tag.length - 1);
      createTextNodeIfPossible(context);

      var _node = voidTagNode(tag); // add node to the appropriate stack


      if (stack.length > 0) {
        stack.push(_node);
      } else {
        result.push(_node);
      }

      context.tag = '';
      return STATE.TEXT;
    }

    createTextNodeIfPossible(context);
    stack.push(tag);
    context.tag = '';
    return STATE.TEXT;
  } // If we meet open tag "<" it means that we wrongly moved into tag state


  if (currChar === CONTROL_CHARS.TAG_OPEN_BRACE) {
    context.text += str.substring(lastTextStateChangeIdx, currIdx);
    context.lastTextStateChangeIdx = currIdx;
    context.tag = '';
    return STATE.TAG;
  }

  context.tag += currChar;
  return STATE.TAG;
};
/**
 * Parses string into AST (abstract syntax tree) and returns it
 * e.g.
 * parse("String to <a>translate</a>") ->
 * ```
 *      [
 *           { type: 'text', value: 'String to ' },
 *           { type: 'tag', value: 'a', children: [{ type: 'text', value: 'translate' }] }
 *      ];
 * ```
 * Empty string is parsed into empty AST (abstract syntax tree): "[]"
 * If founds unbalanced tags, it throws error about it
 *
 * @param {string} str - message in simplified ICU like syntax without plural support
 */


var parser = function parser() {
  var _STATE_HANDLERS;

  var str = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : '';
  var context = {
    /**
     * Stack is used to keep and search nested tag nodes
     */
    stack: [],

    /**
     * Result is stack where function allocates nodes
     */
    result: [],

    /**
     * Current char index
     */
    currIdx: 0,

    /**
     * Saves index of the last state change from the text state,
     * used to restore parsed text if we moved into other state wrongly
     */
    lastTextStateChangeIdx: 0,

    /**
     * Accumulated tag value
     */
    tag: '',

    /**
     * Accumulated text value
     */
    text: '',

    /**
     * Accumulated placeholder value
     */
    placeholder: '',

    /**
     * Parsed string
     */
    str: str
  };
  var STATE_HANDLERS = (_STATE_HANDLERS = {}, index_esm_defineProperty(_STATE_HANDLERS, STATE.TEXT, textStateHandler), index_esm_defineProperty(_STATE_HANDLERS, STATE.PLACEHOLDER, placeholderStateHandler), index_esm_defineProperty(_STATE_HANDLERS, STATE.TAG, tagStateHandler), _STATE_HANDLERS); // Start from text state

  var currentState = STATE.TEXT;

  while (context.currIdx < str.length) {
    context.currChar = str[context.currIdx];
    var currentStateHandler = STATE_HANDLERS[currentState];
    currentState = currentStateHandler(context);
    context.currIdx += 1;
  }

  var result = context.result,
      text = context.text,
      stack = context.stack,
      lastTextStateChangeIdx = context.lastTextStateChangeIdx; // Means that tag or placeholder nodes were not closed, so we consider them as text

  if (currentState !== STATE.TEXT) {
    var restText = str.substring(lastTextStateChangeIdx);

    if ((restText + text).length > 0) {
      result.push(textNode(text + restText));
    }
  } else {
    // eslint-disable-next-line no-lonely-if
    if (text.length > 0) {
      result.push(textNode(text));
    }
  }

  if (stack.length > 0) {
    throw new Error("String has unbalanced tags: ".concat(context.str));
  }

  return result;
};

function index_esm_ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { index_esm_ownKeys(Object(source), true).forEach(function (key) { index_esm_defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { index_esm_ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }
/**
 * Helper functions used by default to assemble strings from tag nodes
 * @param tagName
 * @param children
 */

var createStringElement = function createStringElement(tagName, children) {
  if (children) {
    return "<".concat(tagName, ">").concat(children, "</").concat(tagName, ">");
  }

  return "<".concat(tagName, "/>");
};
/**
 * Creates map with default values for tag converters
 */


var createDefaultValues = function createDefaultValues() {
  return {
    p: function p(children) {
      return createStringElement('p', children);
    },
    b: function b(children) {
      return createStringElement('b', children);
    },
    strong: function strong(children) {
      return createStringElement('strong', children);
    },
    tt: function tt(children) {
      return createStringElement('tt', children);
    },
    s: function s(children) {
      return createStringElement('s', children);
    },
    i: function i(children) {
      return createStringElement('i', children);
    }
  };
};
/**
 * This function accepts an AST (abstract syntax tree) which is a result
 * of the parser function call, and converts tree nodes into array of strings replacing node
 * values with provided values.
 * Values is a map with functions or strings, where each key is related to placeholder value
 * or tag value
 * e.g.
 * string "text <tag>tag text</tag> %placeholder%" is parsed into next AST
 *
 *      [
 *          { type: 'text', value: 'text ' },
 *          {
 *              type: 'tag',
 *              value: 'tag',
 *              children: [{ type: 'text', value: 'tag text' }],
 *          },
 *          { type: 'text', value: ' ' },
 *          { type: 'placeholder', value: 'placeholder' }
 *      ];
 *
 * this AST after format and next values
 *
 *      {
 *          // here used template strings, but it can be react components as well
 *          tag: (chunks) => `<b>${chunks}</b>`,
 *          placeholder: 'placeholder text'
 *      }
 *
 * will return next array
 *
 * [ 'text ', '<b>tag text</b>', ' ', 'placeholder text' ]
 *
 * as you can see, <tag> was replaced by <b>, and placeholder was replaced by placeholder text
 *
 * @param ast - AST (abstract syntax tree)
 * @param values
 */


var format = function format() {
  var ast = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];
  var values = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : {};
  var result = [];

  var tmplValues = _objectSpread(_objectSpread({}, createDefaultValues()), values);

  var i = 0;

  while (i < ast.length) {
    var currentNode = ast[i]; // if current node is text node, there is nothing to change, append value to the result

    if (isTextNode(currentNode)) {
      result.push(currentNode.value);
    } else if (isTagNode(currentNode)) {
      var children = _toConsumableArray(format(currentNode.children, tmplValues));

      var value = tmplValues[currentNode.value];

      if (value) {
        // TODO consider using strong typing
        if (typeof value === 'function') {
          result.push(value(children.join('')));
        } else {
          result.push(value);
        }
      } else {
        throw new Error("Value ".concat(currentNode.value, " wasn't provided"));
      }
    } else if (isVoidTagNode(currentNode)) {
      var _value = tmplValues[currentNode.value]; // TODO consider using strong typing

      if (_value && typeof _value === 'string') {
        result.push(_value);
      } else {
        throw new Error("Value ".concat(currentNode.value, " wasn't provided"));
      }
    } else if (isPlaceholderNode(currentNode)) {
      var _value2 = tmplValues[currentNode.value]; // TODO consider using strong typing

      if (_value2 && typeof _value2 === 'string') {
        result.push(_value2);
      } else {
        throw new Error("Value ".concat(currentNode.value, " wasn't provided"));
      }
    }

    i += 1;
  }

  return result;
};
/**
 * Function gets AST (abstract syntax tree) or string and formats messages,
 * replacing values accordingly
 * e.g.
 *      const message = formatter('<a>some text</a>', {
 *          a: (chunks) => `<a href="#">${chunks}</a>`,
 *      });
 *      console.log(message); // ['<a href="#">some text</a>']
 * @param message
 * @param [values]
 */


var formatter = function formatter(message, values) {
  var ast = parser(message);
  var preparedValues = {}; // convert values to strings if not a function

  if (values) {
    Object.keys(values).forEach(function (key) {
      var value = values[key]; // TODO consider using strong typing

      if (typeof value === 'function') {
        preparedValues[key] = value;
      } else {
        preparedValues[key] = String(value);
      }
    });
  }

  return format(ast, preparedValues);
};

var _pluralFormsCount;

var AvailableLocales;

(function (AvailableLocales) {
  AvailableLocales["az"] = "az";
  AvailableLocales["bo"] = "bo";
  AvailableLocales["dz"] = "dz";
  AvailableLocales["id"] = "id";
  AvailableLocales["ja"] = "ja";
  AvailableLocales["jv"] = "jv";
  AvailableLocales["ka"] = "ka";
  AvailableLocales["km"] = "km";
  AvailableLocales["kn"] = "kn";
  AvailableLocales["ko"] = "ko";
  AvailableLocales["ms"] = "ms";
  AvailableLocales["th"] = "th";
  AvailableLocales["tr"] = "tr";
  AvailableLocales["vi"] = "vi";
  AvailableLocales["zh"] = "zh";
  AvailableLocales["zh_cn"] = "zh_cn";
  AvailableLocales["zh_tw"] = "zh_tw";
  AvailableLocales["af"] = "af";
  AvailableLocales["bn"] = "bn";
  AvailableLocales["bg"] = "bg";
  AvailableLocales["ca"] = "ca";
  AvailableLocales["da"] = "da";
  AvailableLocales["de"] = "de";
  AvailableLocales["el"] = "el";
  AvailableLocales["en"] = "en";
  AvailableLocales["eo"] = "eo";
  AvailableLocales["es"] = "es";
  AvailableLocales["et"] = "et";
  AvailableLocales["eu"] = "eu";
  AvailableLocales["fa"] = "fa";
  AvailableLocales["fi"] = "fi";
  AvailableLocales["fo"] = "fo";
  AvailableLocales["fur"] = "fur";
  AvailableLocales["fy"] = "fy";
  AvailableLocales["gl"] = "gl";
  AvailableLocales["gu"] = "gu";
  AvailableLocales["ha"] = "ha";
  AvailableLocales["he"] = "he";
  AvailableLocales["hu"] = "hu";
  AvailableLocales["is"] = "is";
  AvailableLocales["it"] = "it";
  AvailableLocales["ku"] = "ku";
  AvailableLocales["lb"] = "lb";
  AvailableLocales["ml"] = "ml";
  AvailableLocales["mn"] = "mn";
  AvailableLocales["mr"] = "mr";
  AvailableLocales["nah"] = "nah";
  AvailableLocales["nb"] = "nb";
  AvailableLocales["ne"] = "ne";
  AvailableLocales["nl"] = "nl";
  AvailableLocales["nn"] = "nn";
  AvailableLocales["no"] = "no";
  AvailableLocales["oc"] = "oc";
  AvailableLocales["om"] = "om";
  AvailableLocales["or"] = "or";
  AvailableLocales["pa"] = "pa";
  AvailableLocales["pap"] = "pap";
  AvailableLocales["ps"] = "ps";
  AvailableLocales["pt"] = "pt";
  AvailableLocales["pt_pt"] = "pt_pt";
  AvailableLocales["pt_br"] = "pt_br";
  AvailableLocales["so"] = "so";
  AvailableLocales["sq"] = "sq";
  AvailableLocales["sv"] = "sv";
  AvailableLocales["sw"] = "sw";
  AvailableLocales["ta"] = "ta";
  AvailableLocales["te"] = "te";
  AvailableLocales["tk"] = "tk";
  AvailableLocales["ur"] = "ur";
  AvailableLocales["zu"] = "zu";
  AvailableLocales["am"] = "am";
  AvailableLocales["bh"] = "bh";
  AvailableLocales["fil"] = "fil";
  AvailableLocales["fr"] = "fr";
  AvailableLocales["gun"] = "gun";
  AvailableLocales["hi"] = "hi";
  AvailableLocales["hy"] = "hy";
  AvailableLocales["ln"] = "ln";
  AvailableLocales["mg"] = "mg";
  AvailableLocales["nso"] = "nso";
  AvailableLocales["xbr"] = "xbr";
  AvailableLocales["ti"] = "ti";
  AvailableLocales["wa"] = "wa";
  AvailableLocales["be"] = "be";
  AvailableLocales["bs"] = "bs";
  AvailableLocales["hr"] = "hr";
  AvailableLocales["ru"] = "ru";
  AvailableLocales["sr"] = "sr";
  AvailableLocales["uk"] = "uk";
  AvailableLocales["cs"] = "cs";
  AvailableLocales["sk"] = "sk";
  AvailableLocales["ga"] = "ga";
  AvailableLocales["lt"] = "lt";
  AvailableLocales["sl"] = "sl";
  AvailableLocales["mk"] = "mk";
  AvailableLocales["mt"] = "mt";
  AvailableLocales["lv"] = "lv";
  AvailableLocales["pl"] = "pl";
  AvailableLocales["cy"] = "cy";
  AvailableLocales["ro"] = "ro";
  AvailableLocales["ar"] = "ar";
  AvailableLocales["sr_latn"] = "sr_latn";
})(AvailableLocales || (AvailableLocales = {}));

var getPluralFormId = function getPluralFormId(locale, number) {
  var _supportedForms;

  if (number === 0) {
    return 0;
  }

  var slavNum = number % 10 === 1 && number % 100 !== 11 ? 1 : number % 10 >= 2 && number % 10 <= 4 && (number % 100 < 10 || number % 100 >= 20) ? 2 : 3;
  var supportedForms = (_supportedForms = {}, index_esm_defineProperty(_supportedForms, AvailableLocales.az, 1), index_esm_defineProperty(_supportedForms, AvailableLocales.bo, 1), index_esm_defineProperty(_supportedForms, AvailableLocales.dz, 1), index_esm_defineProperty(_supportedForms, AvailableLocales.id, 1), index_esm_defineProperty(_supportedForms, AvailableLocales.ja, 1), index_esm_defineProperty(_supportedForms, AvailableLocales.jv, 1), index_esm_defineProperty(_supportedForms, AvailableLocales.ka, 1), index_esm_defineProperty(_supportedForms, AvailableLocales.km, 1), index_esm_defineProperty(_supportedForms, AvailableLocales.kn, 1), index_esm_defineProperty(_supportedForms, AvailableLocales.ko, 1), index_esm_defineProperty(_supportedForms, AvailableLocales.ms, 1), index_esm_defineProperty(_supportedForms, AvailableLocales.th, 1), index_esm_defineProperty(_supportedForms, AvailableLocales.tr, 1), index_esm_defineProperty(_supportedForms, AvailableLocales.vi, 1), index_esm_defineProperty(_supportedForms, AvailableLocales.zh, 1), index_esm_defineProperty(_supportedForms, AvailableLocales.zh_tw, 1), index_esm_defineProperty(_supportedForms, AvailableLocales.zh_cn, 1), index_esm_defineProperty(_supportedForms, AvailableLocales.af, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.bn, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.bg, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.ca, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.da, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.de, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.el, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.en, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.eo, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.es, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.et, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.eu, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.fa, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.fi, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.fo, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.fur, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.fy, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.gl, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.gu, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.ha, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.he, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.hu, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.is, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.it, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.ku, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.lb, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.ml, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.mn, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.mr, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.nah, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.nb, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.ne, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.nl, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.nn, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.no, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.oc, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.om, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.or, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.pa, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.pap, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.ps, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.pt, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.pt_pt, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.pt_br, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.so, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.sq, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.sv, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.sw, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.ta, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.te, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.tk, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.ur, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.zu, number === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.am, number === 0 || number === 1 ? 0 : 1), index_esm_defineProperty(_supportedForms, AvailableLocales.bh, number === 0 || number === 1 ? 0 : 1), index_esm_defineProperty(_supportedForms, AvailableLocales.fil, number === 0 || number === 1 ? 0 : 1), index_esm_defineProperty(_supportedForms, AvailableLocales.fr, number === 0 || number >= 2 ? 2 : 1), index_esm_defineProperty(_supportedForms, AvailableLocales.gun, number === 0 || number === 1 ? 0 : 1), index_esm_defineProperty(_supportedForms, AvailableLocales.hi, number === 0 || number === 1 ? 0 : 1), index_esm_defineProperty(_supportedForms, AvailableLocales.hy, number === 0 || number === 1 ? 0 : 1), index_esm_defineProperty(_supportedForms, AvailableLocales.ln, number === 0 || number === 1 ? 0 : 1), index_esm_defineProperty(_supportedForms, AvailableLocales.mg, number === 0 || number === 1 ? 0 : 1), index_esm_defineProperty(_supportedForms, AvailableLocales.nso, number === 0 || number === 1 ? 0 : 1), index_esm_defineProperty(_supportedForms, AvailableLocales.xbr, number === 0 || number === 1 ? 0 : 1), index_esm_defineProperty(_supportedForms, AvailableLocales.ti, number === 0 || number === 1 ? 0 : 1), index_esm_defineProperty(_supportedForms, AvailableLocales.wa, number === 0 || number === 1 ? 0 : 1), index_esm_defineProperty(_supportedForms, AvailableLocales.be, slavNum), index_esm_defineProperty(_supportedForms, AvailableLocales.bs, slavNum), index_esm_defineProperty(_supportedForms, AvailableLocales.hr, slavNum), index_esm_defineProperty(_supportedForms, AvailableLocales.ru, slavNum), index_esm_defineProperty(_supportedForms, AvailableLocales.sr, slavNum), index_esm_defineProperty(_supportedForms, AvailableLocales.sr_latn, slavNum), index_esm_defineProperty(_supportedForms, AvailableLocales.uk, slavNum), index_esm_defineProperty(_supportedForms, AvailableLocales.cs, number === 1 ? 1 : number >= 2 && number <= 4 ? 2 : 3), index_esm_defineProperty(_supportedForms, AvailableLocales.sk, number === 1 ? 1 : number >= 2 && number <= 4 ? 2 : 3), index_esm_defineProperty(_supportedForms, AvailableLocales.ga, number === 1 ? 1 : number === 2 ? 2 : 3), index_esm_defineProperty(_supportedForms, AvailableLocales.lt, number % 10 === 1 && number % 100 !== 11 ? 1 : number % 10 >= 2 && (number % 100 < 10 || number % 100 >= 20) ? 2 : 3), index_esm_defineProperty(_supportedForms, AvailableLocales.sl, number % 100 === 1 ? 1 : number % 100 === 2 ? 2 : number % 100 === 3 || number % 100 === 4 ? 3 : 4), index_esm_defineProperty(_supportedForms, AvailableLocales.mk, number % 10 === 1 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.mt, number === 1 ? 1 : number === 0 || number % 100 > 1 && number % 100 < 11 ? 2 : number % 100 > 10 && number % 100 < 20 ? 3 : 4), index_esm_defineProperty(_supportedForms, AvailableLocales.lv, number === 0 ? 0 : number % 10 === 1 && number % 100 !== 11 ? 1 : 2), index_esm_defineProperty(_supportedForms, AvailableLocales.pl, number === 1 ? 1 : number % 10 >= 2 && number % 10 <= 4 && (number % 100 < 12 || number % 100 > 14) ? 2 : 3), index_esm_defineProperty(_supportedForms, AvailableLocales.cy, number === 1 ? 0 : number === 2 ? 1 : number === 8 || number === 11 ? 2 : 3), index_esm_defineProperty(_supportedForms, AvailableLocales.ro, number === 1 ? 1 : number === 1 || number % 100 > 0 && number % 100 < 20 ? 2 : 3), index_esm_defineProperty(_supportedForms, AvailableLocales.ar, number === 0 ? 0 : number === 1 ? 1 : number === 2 ? 2 : number % 100 >= 3 && number % 100 <= 10 ? 3 : number % 100 >= 11 && number % 100 <= 99 ? 4 : 5), _supportedForms);
  return supportedForms[locale];
};

var pluralFormsCount = (_pluralFormsCount = {}, index_esm_defineProperty(_pluralFormsCount, AvailableLocales.az, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.bo, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.dz, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.id, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.ja, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.jv, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.ka, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.km, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.kn, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.ko, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.ms, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.th, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.tr, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.vi, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.zh, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.zh_cn, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.zh_tw, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.af, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.bn, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.bg, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.ca, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.da, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.de, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.el, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.en, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.eo, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.es, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.et, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.eu, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.fa, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.fi, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.fo, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.fur, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.fy, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.gl, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.gu, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.ha, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.he, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.hu, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.is, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.it, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.ku, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.lb, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.ml, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.mn, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.mr, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.nah, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.nb, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.ne, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.nl, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.nn, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.no, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.oc, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.om, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.or, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.pa, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.pap, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.ps, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.pt, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.pt_pt, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.pt_br, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.so, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.sq, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.sv, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.sw, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.ta, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.te, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.tk, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.ur, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.zu, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.am, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.bh, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.fil, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.fr, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.gun, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.hi, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.hy, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.ln, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.mg, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.nso, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.xbr, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.ti, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.wa, 2), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.be, 4), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.bs, 4), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.hr, 4), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.ru, 4), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.sr, 4), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.sr_latn, 4), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.uk, 4), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.cs, 4), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.sk, 4), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.ga, 4), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.lt, 4), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.sl, 5), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.mk, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.mt, 5), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.lv, 3), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.pl, 4), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.cy, 4), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.ro, 4), index_esm_defineProperty(_pluralFormsCount, AvailableLocales.ar, 6), _pluralFormsCount);
var PLURAL_STRING_DELIMITER = '|';
/**
 * Returns string plural forms which are separated by `|`.
 *
 * @param str Message.
 *
 * @returns Array of plural forms.
 */

var getForms = function getForms(str) {
  return str.split(PLURAL_STRING_DELIMITER);
};
/**
 * Checks whether the string has correct number of plural forms.
 *
 * @param str Translated string.
 * @param locale Locale.
 * @param key Optional, base key.
 *
 * @throws Error if the number of plural forms is incorrect.
 */

var checkForms = function checkForms(str, locale, key) {
  var givenCount = getForms(str).length;
  var requiredCount = pluralFormsCount[locale];

  if (givenCount !== requiredCount) {
    var prefix = typeof key !== 'undefined' ? "Invalid plural string \"".concat(key, "\" for locale '").concat(locale, "'") : "Invalid plural string for locale '".concat(locale, "'");
    throw new Error("".concat(prefix, ": required ").concat(requiredCount, ", given ").concat(givenCount, " in string \"").concat(str, "\""));
  }
};
/**
 * Checks whether plural forms are present in base string
 * by checking the presence of the vertical bar `|`.
 *
 * @param baseStr Base string.
 *
 * @returns True if `baseStr` contains `|`, false otherwise.
 */


var hasPluralForm = function hasPluralForm(baseStr) {
  return baseStr.includes(PLURAL_STRING_DELIMITER);
};
/**
 * Checks if plural forms are valid.
 *
 * @param targetStr Translated message with plural forms.
 * @param locale Locale.
 * @param key Optional, message key, used for clearer log message.
 *
 * @returns True if plural forms are valid, false otherwise.
 */

var isPluralFormValid = function isPluralFormValid(targetStr, locale, key) {
  try {
    checkForms(targetStr, locale, key);
    return true;
  } catch (error) {
    return false;
  }
};
/**
 * Returns plural form corresponding to number
 * @param str
 * @param number
 * @param locale - current locale
 * @param key - message key
 */

var getForm = function getForm(str, number, locale, key) {
  checkForms(str, locale, key);
  var forms = getForms(str);
  var currentForm = getPluralFormId(locale, number);
  return forms[currentForm].trim();
};

function ownKeys$1(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread$1(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys$1(Object(source), true).forEach(function (key) { index_esm_defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys$1(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

var defaultMessageConstructor = function defaultMessageConstructor(formatted) {
  return formatted.join('');
};

var Translator = /*#__PURE__*/function () {
  function Translator(i18n, // eslint-disable-next-line @typescript-eslint/no-explicit-any
  messageConstructor, values) {
    index_esm_classCallCheck(this, Translator);

    this.i18n = i18n;
    this.messageConstructor = messageConstructor || defaultMessageConstructor;
    this.values = values || {};
  }
  /**
   * Retrieves message and translates it, substituting parameters where necessary
   * @param key - translation message key
   * @param params - values used to substitute placeholders and tags
   */


  index_esm_createClass(Translator, [{
    key: "getMessage",
    value: function getMessage(key) {
      var params = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : {};
      var message = this.i18n.getMessage(key);

      if (!message) {
        message = this.i18n.getBaseMessage(key);

        if (!message) {
          throw new Error("Was unable to find message for key: \"".concat(key, "\""));
        }
      }

      var formatted = formatter(message, _objectSpread$1(_objectSpread$1({}, this.values), params));
      return this.messageConstructor(formatted);
    }
    /**
     * Retrieves correct plural form and translates it
     * @param key - translation message key
     * @param number - plural form number
     * @param params - values used to substitute placeholders or tags if necessary,
     * if params has "count" property it will be overridden by number (plural form number)
     */

  }, {
    key: "getPlural",
    value: function getPlural(key, number) {
      var params = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : {};
      var message = this.i18n.getMessage(key);
      var language = this.i18n.getUILanguage();

      if (!message) {
        message = this.i18n.getBaseMessage(key);

        if (!message) {
          throw new Error("Was unable to find message for key: \"".concat(key, "\""));
        }

        language = this.i18n.getBaseUILanguage();
      }

      var form = getForm(message, number, language, key);
      var formatted = formatter(form, _objectSpread$1(_objectSpread$1(_objectSpread$1({}, this.values), params), {}, {
        count: number
      }));
      return this.messageConstructor(formatted);
    }
  }]);

  return Translator;
}();

function ownKeys$2(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread$2(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys$2(Object(source), true).forEach(function (key) { index_esm_defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys$2(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }
/**
 * Creates translation function for strings used in the React components
 * We do not import React directly, because translator module can be used
 * in the modules without React too
 *
 * e.g.
 * const translateReact = createReactTranslator(getMessage, React);
 * in locales folder you should have messages.json file
 * ```
 * message:
 *     "popup_auth_agreement_consent": {
 *          "message": "You agree to our <eula>EULA</eula>",
 *      },
 * ```
 *
 * this message can be retrieved and translated into react components next way:
 *
 * const component = translateReact('popup_auth_agreement_consent', {
 *          eula: (chunks) => (
 *              <button
 *                  className="auth__privacy-link"
 *                  onClick={handleEulaClick}
 *              >
 *                  {chunks}
 *              </button>
 *          ),
 *       });
 *
 * Note how functions in the values argument can be used with handlers
 *
 * @param i18n - object with methods which get translated message by key and return current locale
 * @param React - instance of react library
 */

var createReactTranslator = function createReactTranslator(i18n, react, defaults) {
  /**
   * Helps to build nodes without values
   *
   * @param tagName
   * @param children
   */
  var createReactElement = function createReactElement(tagName, children) {
    if (children) {
      return react.createElement(tagName, null, react.Children.toArray(children));
    }

    return react.createElement(tagName, null);
  };
  /**
   * Function creates default values to be used if user didn't provide function values for tags
   */


  var createDefaultValues = function createDefaultValues() {
    // eslint-disable-next-line @typescript-eslint/ban-types
    var externalDefaults = {};

    if (defaults) {
      defaults.tags.forEach(function (t) {
        externalDefaults[t.key] = function (children) {
          return createReactElement(t.createdTag, children);
        };
      });
    }

    if (defaults !== null && defaults !== void 0 && defaults.override) {
      return externalDefaults;
    }

    return _objectSpread$2({
      p: function p(children) {
        return createReactElement('p', children);
      },
      b: function b(children) {
        return createReactElement('b', children);
      },
      strong: function strong(children) {
        return createReactElement('strong', children);
      },
      tt: function tt(children) {
        return createReactElement('tt', children);
      },
      s: function s(children) {
        return createReactElement('s', children);
      },
      i: function i(children) {
        return createReactElement('i', children);
      }
    }, externalDefaults);
  };

  var reactMessageConstructor = function reactMessageConstructor(formatted) {
    var reactChildren = react.Children.toArray(formatted); // if there is only strings in the array we join them

    if (reactChildren.every(function (child) {
      return typeof child === 'string';
    })) {
      return reactChildren.join('');
    }

    return reactChildren;
  };

  var defaultValues = createDefaultValues();
  return new Translator(i18n, reactMessageConstructor, defaultValues);
};

var r,
    f;

function A(n, l) {
  return l = l || [], null == n || "boolean" == typeof n || (Array.isArray(n) ? n.some(function (n) {
    A(n, l);
  }) : l.push(n)), l;
}

r = "function" == typeof Promise ? Promise.prototype.then.bind(Promise.resolve()) : setTimeout, f = 0;

function ownKeys$3(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread$3(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys$3(Object(source), true).forEach(function (key) { index_esm_defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys$3(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }
/**
 * Creates translation function for strings used in the Preact components
 * We do not import Preact directly, because translator module can be used
 * in the modules without Preact too
 *
 * e.g.
 * const translatePreact = createPreactTranslator(getMessage, Preact);
 * in locales folder you should have messages.json file
 * ```
 * message:
 *     "popup_auth_agreement_consent": {
 *          "message": "You agree to our <eula>EULA</eula>",
 *      },
 * ```
 *
 * this message can be retrieved and translated into preact components next way:
 *
 * const component = translatePreact('popup_auth_agreement_consent', {
 *          eula: (chunks) => (
 *              <button
 *                  className="auth__privacy-link"
 *                  onClick={handleEulaClick}
 *              >
 *                  {chunks}
 *              </button>
 *          ),
 *       });
 *
 * Note how functions in the values argument can be used with handlers
 *
 * @param i18n - object with methods which get translated message by key and return current locale
 * @param Preact - instance of preact library
 */

var createPreactTranslator = function createPreactTranslator(i18n, preact, defaults) {
  /**
   * Helps to build nodes without values
   *
   * @param tagName
   * @param children
   */
  var createPreactElement = function createPreactElement(tagName, children) {
    if (children) {
      return preact.createElement(tagName, null, A(children));
    }

    return preact.createElement(tagName, null);
  };
  /**
   * Function creates default values to be used if user didn't provide function values for tags
   */


  var createDefaultValues = function createDefaultValues() {
    // eslint-disable-next-line @typescript-eslint/ban-types
    var externalDefaults = {};

    if (defaults) {
      defaults.tags.forEach(function (t) {
        externalDefaults[t.key] = function (children) {
          return createPreactElement(t.createdTag, children);
        };
      });
    }

    if (defaults !== null && defaults !== void 0 && defaults.override) {
      return externalDefaults;
    }

    return _objectSpread$3({
      p: function p(children) {
        return createPreactElement('p', children);
      },
      b: function b(children) {
        return createPreactElement('b', children);
      },
      strong: function strong(children) {
        return createPreactElement('strong', children);
      },
      tt: function tt(children) {
        return createPreactElement('tt', children);
      },
      s: function s(children) {
        return createPreactElement('s', children);
      },
      i: function i(children) {
        return createPreactElement('i', children);
      }
    }, externalDefaults);
  };

  var preactMessageConstructor = function preactMessageConstructor(formatted) {
    var preactChildren = A(formatted); // if there is only strings in the array we join them

    if (preactChildren.every(function (child) {
      return typeof child === 'string';
    })) {
      return preactChildren.join('');
    }

    return preactChildren;
  };

  var defaultValues = createDefaultValues();
  return new Translator(i18n, preactMessageConstructor, defaultValues);
};

/**
 * Creates translator instance strings, by default for simple strings
 * @param i18n - function which returns translated message by key
 * @param messageConstructor - function that will collect messages
 * @param values - map with default values for tag converters
 */

var createTranslator = function createTranslator(i18n, messageConstructor, values) {
  return new Translator(i18n, messageConstructor, values);
};

var translate = {
  createTranslator: createTranslator,
  createReactTranslator: createReactTranslator,
  createPreactTranslator: createPreactTranslator
};

function index_esm_typeof(obj) {
  "@babel/helpers - typeof";

  if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") {
    index_esm_typeof = function _typeof(obj) {
      return typeof obj;
    };
  } else {
    index_esm_typeof = function _typeof(obj) {
      return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj;
    };
  }

  return index_esm_typeof(obj);
}

/**
 * Compares two AST (abstract syntax tree) structures,
 * view tests for examples
 * @param baseAst
 * @param targetAst
 */

var areAstStructuresSame = function areAstStructuresSame(baseAst, targetAst) {
  var textNodeFilter = function textNodeFilter(node) {
    return !isTextNode(node);
  };

  var filteredBaseAst = baseAst.filter(textNodeFilter);
  var filteredTargetAst = targetAst.filter(textNodeFilter); // if AST structures have different lengths, they are not equal

  if (filteredBaseAst.length !== filteredTargetAst.length) {
    return false;
  }

  var _loop = function _loop(i) {
    var baseNode = filteredBaseAst[i];
    var targetNode = filteredTargetAst.find(function (node) {
      return node.type === baseNode.type && node.value === baseNode.value;
    });

    if (!targetNode) {
      return {
        v: false
      };
    }

    if (targetNode.children && baseNode.children) {
      var areChildrenSame = areAstStructuresSame(baseNode.children, targetNode.children);

      if (!areChildrenSame) {
        return {
          v: false
        };
      }
    }
  };

  for (var i = 0; i < filteredBaseAst.length; i += 1) {
    var _ret = _loop(i);

    if (index_esm_typeof(_ret) === "object") return _ret.v;
  }

  return true;
};
/**
 * Validates translation against base string by AST (abstract syntax tree) structure.
 *
 * @param baseMessage Base message.
 * @param translatedMessage Translated message.
 * @param locale Locale of `translatedMessage`.
 *
 * @returns True if translated message is valid, false otherwise:
 * - if base message has no plural forms, it will return true if AST structures are same;
 * - if base message has plural forms, first of all
 *   the function checks if the number of plural forms is correct for the `locale`,
 *   and then it validates AST plural forms structures for base and translated messages.
 *
 * @throws Error for invalid tags in base or translated messages,
 * or if translated message has invalid plural forms.
 */


var isTranslationValid = function isTranslationValid(baseMessage, translatedMessage, locale) {
  if (hasPluralForm(baseMessage)) {
    var isPluralFormsValid = isPluralFormValid(translatedMessage, locale);

    if (!isPluralFormsValid) {
      throw new Error('Invalid plural forms');
    }

    var baseForms = getForms(baseMessage);
    var translatedForms = getForms(translatedMessage); // check a zero form structures of base and translated messages

    if (!isTranslationValid(baseForms[0], translatedForms[0], locale)) {
      return false;
    } // and check other forms structures of translated messages against the first form of base message


    for (var i = 1; i < translatedForms.length; i += 1) {
      if (!isTranslationValid(baseForms[1], translatedForms[i], locale)) {
        return false;
      }
    } // if no errors, return true after all checks


    return true;
  }

  var baseMessageAst = parser(baseMessage);
  var translatedMessageAst = parser(translatedMessage);
  return areAstStructuresSame(baseMessageAst, translatedMessageAst);
};
var validator = {
  isTranslationValid: isTranslationValid,
  isPluralFormValid: isPluralFormValid
};



;// CONCATENATED MODULE: ./src/pages/common/translators/i18n.ts

var i18n = {
  getMessage: (browser_polyfill_default()).i18n.getMessage,
  getUILanguage: (browser_polyfill_default()).i18n.getUILanguage,
  getBaseMessage: function getBaseMessage(key) {
    return key;
  },
  getBaseUILanguage: function getBaseUILanguage() {
    return 'en';
  }
};
;// CONCATENATED MODULE: ./src/pages/common/translators/translator.ts


/**
 * Retrieves localised message by key, formats it and converts into string
 */

var translator = translate.createTranslator(i18n);
// EXTERNAL MODULE: ./node_modules/classnames/index.js
var classnames = __webpack_require__(4184);
var classnames_default = /*#__PURE__*/__webpack_require__.n(classnames);
;// CONCATENATED MODULE: ./src/pages/popup/components/ui/Icon.tsx


var Icon = function Icon(_ref) {
  var iconId = _ref.iconId,
      className = _ref.className,
      color = _ref.color;
  var iconClass = classnames_default()('icon', color && "icon--".concat(color), className);
  return /*#__PURE__*/react.createElement("svg", {
    className: iconClass
  }, /*#__PURE__*/react.createElement("use", {
    xlinkHref: "#".concat(iconId)
  }));
};
// EXTERNAL MODULE: ./node_modules/css-loader/dist/cjs.js!./node_modules/postcss-loader/dist/cjs.js!./src/pages/popup/components/Actions/Action/action.pcss
var Action_action = __webpack_require__(8280);
;// CONCATENATED MODULE: ./src/pages/popup/components/Actions/Action/action.pcss

      
      
      
      
      
      
      
      
      

var action_options = {};

action_options.styleTagTransform = (styleTagTransform_default());
action_options.setAttributes = (setAttributesWithoutAttributes_default());

      action_options.insert = insertBySelector_default().bind(null, "head");
    
action_options.domAPI = (styleDomAPI_default());
action_options.insertStyleElement = (insertStyleElement_default());

var action_update = injectStylesIntoStyleTag_default()(Action_action/* default */.Z, action_options);




       /* harmony default export */ const Actions_Action_action = (Action_action/* default */.Z && Action_action/* default.locals */.Z.locals ? Action_action/* default.locals */.Z.locals : undefined);

;// CONCATENATED MODULE: ./src/pages/popup/components/Actions/Action/Action.tsx
/* eslint-disable jsx-a11y/click-events-have-key-events, jsx-a11y/no-static-element-interactions */




var Action = function Action(_ref) {
  var iconId = _ref.iconId,
      iconColor = _ref.iconColor,
      iconDataUrl = _ref.iconDataUrl,
      title = _ref.title,
      titleMod = _ref.titleMod,
      description = _ref.description,
      descriptionMod = _ref.descriptionMod,
      onClick = _ref.onClick,
      children = _ref.children,
      disable = _ref.disable,
      _ref$iconEnabled = _ref.iconEnabled,
      iconEnabled = _ref$iconEnabled === void 0 ? true : _ref$iconEnabled;
  var actionClass = classnames_default()('action', disable && 'action--disable');
  var titleClass = classnames_default()('action__title', titleMod && "action__title--".concat(titleMod));
  var descriptionClass = classnames_default()('action__description', descriptionMod && "action__description--".concat(descriptionMod));

  var handleClick = function handleClick(e) {
    if (onClick) {
      e.preventDefault();
      onClick();
    }
  };

  var iconClassname = classnames_default()('icon', {
    'icon--disable': !iconEnabled
  });
  var icon;

  if (iconDataUrl) {
    icon = /*#__PURE__*/react.createElement("img", {
      className: iconClassname,
      src: iconDataUrl,
      alt: "favicon"
    });
  } else {
    icon = /*#__PURE__*/react.createElement(Icon, {
      className: iconClassname,
      iconId: iconId,
      color: iconColor
    });
  }

  return /*#__PURE__*/react.createElement("div", {
    className: actionClass,
    onClick: handleClick
  }, /*#__PURE__*/react.createElement("div", {
    className: "action__icon"
  }, icon), /*#__PURE__*/react.createElement("div", {
    className: "action__details"
  }, /*#__PURE__*/react.createElement("div", {
    className: titleClass
  }, title), description && /*#__PURE__*/react.createElement("div", {
    className: descriptionClass
  }, description)), children);
};
;// CONCATENATED MODULE: ./src/pages/popup/components/Actions/Action/index.ts

// EXTERNAL MODULE: ./node_modules/css-loader/dist/cjs.js!./node_modules/postcss-loader/dist/cjs.js!./src/pages/popup/components/Switcher/switcher.pcss
var switcher = __webpack_require__(710);
;// CONCATENATED MODULE: ./src/pages/popup/components/Switcher/switcher.pcss

      
      
      
      
      
      
      
      
      

var switcher_options = {};

switcher_options.styleTagTransform = (styleTagTransform_default());
switcher_options.setAttributes = (setAttributesWithoutAttributes_default());

      switcher_options.insert = insertBySelector_default().bind(null, "head");
    
switcher_options.domAPI = (styleDomAPI_default());
switcher_options.insertStyleElement = (insertStyleElement_default());

var switcher_update = injectStylesIntoStyleTag_default()(switcher/* default */.Z, switcher_options);




       /* harmony default export */ const Switcher_switcher = (switcher/* default */.Z && switcher/* default.locals */.Z.locals ? switcher/* default.locals */.Z.locals : undefined);

;// CONCATENATED MODULE: ./src/pages/popup/components/Switcher/Switcher.tsx
/* eslint-disable jsx-a11y/label-has-associated-control */


var Switcher = function Switcher(_ref) {
  var onChange = _ref.onChange,
      enabled = _ref.enabled;
  return /*#__PURE__*/react.createElement("label", {
    className: "switcher"
  }, /*#__PURE__*/react.createElement("input", {
    className: "switcher__checkbox",
    type: "checkbox",
    onChange: onChange,
    checked: enabled
  }), /*#__PURE__*/react.createElement("div", {
    className: "switcher__inner"
  }));
};
;// CONCATENATED MODULE: ./src/pages/popup/components/Switcher/index.ts

// EXTERNAL MODULE: ./node_modules/css-loader/dist/cjs.js!./node_modules/postcss-loader/dist/cjs.js!./src/pages/popup/components/Button/button.pcss
var Button_button = __webpack_require__(3437);
;// CONCATENATED MODULE: ./src/pages/popup/components/Button/button.pcss

      
      
      
      
      
      
      
      
      

var button_options = {};

button_options.styleTagTransform = (styleTagTransform_default());
button_options.setAttributes = (setAttributesWithoutAttributes_default());

      button_options.insert = insertBySelector_default().bind(null, "head");
    
button_options.domAPI = (styleDomAPI_default());
button_options.insertStyleElement = (insertStyleElement_default());

var button_update = injectStylesIntoStyleTag_default()(Button_button/* default */.Z, button_options);




       /* harmony default export */ const components_Button_button = (Button_button/* default */.Z && Button_button/* default.locals */.Z.locals ? Button_button/* default.locals */.Z.locals : undefined);

;// CONCATENATED MODULE: ./src/pages/popup/components/Button/Button.tsx



var Button = function Button(_ref) {
  var onClick = _ref.onClick,
      children = _ref.children,
      classNames = _ref.classNames;
  var buttonClass = classnames_default()('button', classNames);

  var handleClick = function handleClick(e) {
    e.preventDefault();
    onClick();
  };

  return /*#__PURE__*/react.createElement("button", {
    type: "button",
    className: buttonClass,
    onClick: handleClick
  }, children);
};
;// CONCATENATED MODULE: ./src/pages/popup/components/Button/index.ts

;// CONCATENATED MODULE: ./src/pages/popup/components/Actions/ProtectionToggle/ProtectionToggle.tsx










var ProtectionToggle = mobxreact_esm_observer(function () {
  var store = (0,react.useContext)(popupStore);

  var toggleProtection = /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regenerator_default().mark(function _callee() {
      return regenerator_default().wrap(function _callee$(_context) {
        while (1) switch (_context.prev = _context.next) {
          case 0:
            _context.next = 2;
            return store.toggleProtection();

          case 2:
            window.close();

          case 3:
          case "end":
            return _context.stop();
        }
      }, _callee);
    }));

    return function toggleProtection() {
      return _ref.apply(this, arguments);
    };
  }();

  var description = store.protectionEnabled ? translator.getMessage('popup_action_safari_protection_description_enabled_for_site') : translator.getMessage('popup_action_safari_protection_description_disabled_for_site');
  var descriptionColor = 'gray';
  var iconEnabled = true; // Hide this element for the case when we're dealing with a secure page
  // and content blockers are enabled.

  var hide = !store.currentSiteDomain && store.contentBlockersEnabled;

  if (hide) {
    return null;
  }

  var button;

  if (!store.contentBlockersEnabled) {
    description = translator.getMessage('popup_action_safari_protection_description_disabled');
    descriptionColor = 'yellow';
    iconEnabled = false;

    var handleInfoTouch = function handleInfoTouch() {
      store.setProtectionModalVisibleState(true);
    };

    button = /*#__PURE__*/react.createElement(Button, {
      onClick: handleInfoTouch,
      classNames: "actions__control"
    }, /*#__PURE__*/react.createElement(Icon, {
      color: "yellow",
      iconId: "info"
    }));
  } else if (!store.safariProtectionEnabled) {
    description = translator.getMessage('popup_action_safari_protection_description_disabled');
    descriptionColor = 'yellow';
    iconEnabled = false;

    var handleEnableSafariProtection = /*#__PURE__*/function () {
      var _ref2 = _asyncToGenerator( /*#__PURE__*/regenerator_default().mark(function _callee2() {
        return regenerator_default().wrap(function _callee2$(_context2) {
          while (1) switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return store.enableSafariProtection();

            case 2:
              window.close();

            case 3:
            case "end":
              return _context2.stop();
          }
        }, _callee2);
      }));

      return function handleEnableSafariProtection() {
        return _ref2.apply(this, arguments);
      };
    }();

    button = /*#__PURE__*/react.createElement("div", {
      className: "actions__control"
    }, /*#__PURE__*/react.createElement(Switcher, {
      onChange: handleEnableSafariProtection,
      enabled: store.safariProtectionEnabled
    }));
  } else {
    iconEnabled = store.protectionEnabled;
    button = /*#__PURE__*/react.createElement("div", {
      className: "actions__control"
    }, /*#__PURE__*/react.createElement(Switcher, {
      onChange: toggleProtection,
      enabled: store.protectionEnabled
    }));
  }

  return (
    /*#__PURE__*/
    // eslint-disable-next-line jsx-a11y/label-has-associated-control
    react.createElement("label", {
      className: "action-label"
    }, /*#__PURE__*/react.createElement(Action, {
      iconId: "compass",
      iconColor: "green",
      title: translator.getMessage('popup_action_safari_protection_title'),
      titleMod: "light",
      description: description,
      descriptionMod: descriptionColor,
      iconEnabled: iconEnabled
    }, button))
  );
});
;// CONCATENATED MODULE: ./src/pages/popup/components/Actions/ProtectionToggle/index.ts

;// CONCATENATED MODULE: ./src/pages/popup/components/Actions/DeleteUserRules/DeleteUserRules.tsx







var DeleteUserRules = mobxreact_esm_observer(function () {
  var store = (0,react.useContext)(popupStore);
  var currentSiteDomain = store.currentSiteDomain,
      hasUserRules = store.hasUserRules,
      protectionEnabled = store.protectionEnabled,
      contentBlockersEnabled = store.contentBlockersEnabled;

  if (!currentSiteDomain) {
    // This is a secure page, we cannot add user rules here.
    return null;
  }

  if (!hasUserRules || !protectionEnabled || !contentBlockersEnabled) {
    return null;
  }

  var handleClick = /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regenerator_default().mark(function _callee() {
      return regenerator_default().wrap(function _callee$(_context) {
        while (1) switch (_context.prev = _context.next) {
          case 0:
            _context.next = 2;
            return store.deleteUserRules();

          case 2:
            window.close();

          case 3:
          case "end":
            return _context.stop();
        }
      }, _callee);
    }));

    return function handleClick() {
      return _ref.apply(this, arguments);
    };
  }();

  return /*#__PURE__*/react.createElement(Action, {
    iconId: "delete",
    iconColor: "red",
    onClick: handleClick,
    title: translator.getMessage('popup_action_delete_user_rules')
  });
});
;// CONCATENATED MODULE: ./src/pages/popup/components/Actions/DeleteUserRules/index.ts

;// CONCATENATED MODULE: ./node_modules/@babel/runtime/helpers/esm/defineProperty.js
function defineProperty_defineProperty(obj, key, value) {
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
;// CONCATENATED MODULE: ./src/pages/popup/components/Actions/CurrentSite/CurrentSite.tsx










var SiteStatusesMessages = defineProperty_defineProperty(defineProperty_defineProperty(defineProperty_defineProperty(defineProperty_defineProperty(defineProperty_defineProperty(defineProperty_defineProperty({}, SiteStatus.ProtectionStarting, translator.getMessage('popup_action_current_site_desc_starting')), SiteStatus.ProtectionEnabled, translator.getMessage('popup_action_current_site_status_desc_enabled')), SiteStatus.ProtectionDisabled, translator.getMessage('popup_action_current_site_status_desc_disabled')), SiteStatus.Allowlisted, translator.getMessage('popup_action_current_site_desc_allowlisted')), SiteStatus.AllowlistedInverted, translator.getMessage('popup_action_current_site_desc_allowlisted_inverted')), SiteStatus.BasicOnly, translator.getMessage('popup_action_current_site_desc_basic_only'));

var CurrentSite = mobxreact_esm_observer(function () {
  var store = (0,react.useContext)(popupStore);
  var description = SiteStatusesMessages[SiteStatus.ProtectionEnabled];
  var descriptionColor = 'gray';
  var iconEnabled = true;
  var websiteTitle = store.currentSiteDomain;

  if (!websiteTitle) {
    // We're dealing with a Secure page where nothing can be blocked.
    // TODO: Make it localizable in the next update.
    websiteTitle = 'Secure page';
    iconEnabled = false;
  }

  if (!store.premiumApp || !store.advancedBlockingEnabled) {
    description = SiteStatusesMessages[SiteStatus.BasicOnly];
    descriptionColor = 'yellow';
  }

  if (!store.protectionEnabled && !!store.currentSiteDomain) {
    description = SiteStatusesMessages[SiteStatus.Allowlisted];
    descriptionColor = 'green';
    iconEnabled = false;
  }

  if (store.allowlistInverted) {
    if (store.protectionEnabled) {
      description = SiteStatusesMessages[SiteStatus.AllowlistedInverted];
      descriptionColor = 'green';
      iconEnabled = true;
    } else {
      description = SiteStatusesMessages[SiteStatus.ProtectionDisabled];
      descriptionColor = 'gray';
      iconEnabled = false;
    }
  }

  if (!store.contentBlockersEnabled || !store.safariProtectionEnabled) {
    description = SiteStatusesMessages[SiteStatus.ProtectionDisabled];
    descriptionColor = 'yellow';
    iconEnabled = false;
  }

  var determineHandlerAndIcon = function determineHandlerAndIcon() {
    var showAttentionButton = !store.premiumApp || !store.advancedBlockingEnabled && store.safariProtectionEnabled;

    var noopHandler = function noopHandler() {};

    var button;
    var handler;

    if (showAttentionButton) {
      if (!store.advancedBlockingEnabled) {
        handler = function handler() {
          store.showAdvancedBlockingDisabledModal();
        };
      }

      if (!store.premiumApp) {
        handler = function handler() {
          store.showUpgradeModal();
        };
      }

      if (handler) {
        button = /*#__PURE__*/react.createElement(Button, {
          onClick: handler,
          classNames: "actions__control"
        }, /*#__PURE__*/react.createElement(Icon, {
          color: "yellow",
          iconId: "info"
        }));
      }
    }

    if (!store.contentBlockersEnabled) {
      button = undefined;
      handler = noopHandler;
    }

    return {
      button: button,
      handler: handler || noopHandler
    };
  };

  return /*#__PURE__*/react.createElement(Action, {
    iconId: "network",
    iconColor: "gray400",
    iconDataUrl: store.currentSiteFaviconDataUrl,
    title: websiteTitle,
    titleMod: "bold",
    description: description,
    descriptionMod: descriptionColor,
    onClick: determineHandlerAndIcon().handler,
    iconEnabled: iconEnabled
  }, determineHandlerAndIcon().button);
});
;// CONCATENATED MODULE: ./src/pages/popup/components/Actions/CurrentSite/index.ts

;// CONCATENATED MODULE: ./src/pages/popup/components/Actions/BlockElement/BlockElement.tsx











var handleBlock = /*#__PURE__*/function () {
  var _ref = _asyncToGenerator( /*#__PURE__*/regenerator_default().mark(function _callee() {
    var _yield$browser$tabs$q, _yield$browser$tabs$q2, currentTab;

    return regenerator_default().wrap(function _callee$(_context) {
      while (1) switch (_context.prev = _context.next) {
        case 0:
          _context.next = 2;
          return browser_polyfill_default().tabs.query({
            active: true,
            currentWindow: true
          });

        case 2:
          _yield$browser$tabs$q = _context.sent;
          _yield$browser$tabs$q2 = _slicedToArray(_yield$browser$tabs$q, 1);
          currentTab = _yield$browser$tabs$q2[0];
          _context.next = 7;
          return browser_polyfill_default().runtime.sendMessage({
            type: MessagesToBackgroundPage.OpenAssistant,
            data: {
              tabId: currentTab.id
            }
          });

        case 7:
          window.close();

        case 8:
        case "end":
          return _context.stop();
      }
    }, _callee);
  }));

  return function handleBlock() {
    return _ref.apply(this, arguments);
  };
}();

var BlockElement = mobxreact_esm_observer(function () {
  var store = (0,react.useContext)(popupStore);
  var show = true;
  var disabled = false;

  if (!store.protectionEnabled) {
    show = false;
  }

  if (!store.contentBlockersEnabled || !store.currentSiteDomain) {
    show = true;
    disabled = true;
  }

  if (!show) {
    return null;
  }

  return /*#__PURE__*/react.createElement(Action, {
    iconId: "aim",
    iconColor: "red",
    title: translator.getMessage('popup_action_block_element'),
    onClick: handleBlock,
    disable: disabled
  });
});
;// CONCATENATED MODULE: ./src/pages/popup/components/Actions/BlockElement/index.ts

;// CONCATENATED MODULE: ./src/pages/popup/components/Actions/Permissions/Permissions.tsx











var Permissions = mobxreact_esm_observer(function () {
  var store = (0,react.useContext)(popupStore);

  var handleClick = /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regenerator_default().mark(function _callee() {
      return regenerator_default().wrap(function _callee$(_context) {
        while (1) switch (_context.prev = _context.next) {
          case 0:
            _context.next = 2;
            return browser_polyfill_default().tabs.create({
              url: WEB_EXTENSION_MORE_URL
            });

          case 2:
          case "end":
            return _context.stop();
        }
      }, _callee);
    }));

    return function handleClick() {
      return _ref.apply(this, arguments);
    };
  }();

  if (store.allSitesAllowed) {
    return null;
  }

  return /*#__PURE__*/react.createElement(Action, {
    iconId: "info",
    iconColor: "yellow",
    onClick: handleClick,
    title: translator.getMessage('popup_action_insufficient_permissions')
  }, /*#__PURE__*/react.createElement(Button, {
    onClick: function onClick() {},
    classNames: "actions__control"
  }, /*#__PURE__*/react.createElement(Icon, {
    color: "gray400",
    iconId: "faq"
  })));
});
;// CONCATENATED MODULE: ./src/pages/popup/components/Actions/Permissions/index.ts

// EXTERNAL MODULE: ./node_modules/css-loader/dist/cjs.js!./node_modules/postcss-loader/dist/cjs.js!./src/pages/popup/components/Actions/actions.pcss
var actions = __webpack_require__(2788);
;// CONCATENATED MODULE: ./src/pages/popup/components/Actions/actions.pcss

      
      
      
      
      
      
      
      
      

var actions_options = {};

actions_options.styleTagTransform = (styleTagTransform_default());
actions_options.setAttributes = (setAttributesWithoutAttributes_default());

      actions_options.insert = insertBySelector_default().bind(null, "head");
    
actions_options.domAPI = (styleDomAPI_default());
actions_options.insertStyleElement = (insertStyleElement_default());

var actions_update = injectStylesIntoStyleTag_default()(actions/* default */.Z, actions_options);




       /* harmony default export */ const Actions_actions = (actions/* default */.Z && actions/* default.locals */.Z.locals ? actions/* default.locals */.Z.locals : undefined);

;// CONCATENATED MODULE: ./src/pages/popup/components/Actions/Actions.tsx








var Actions = mobxreact_esm_observer(function () {
  return /*#__PURE__*/react.createElement("div", {
    className: "actions"
  }, /*#__PURE__*/react.createElement(CurrentSite, null), /*#__PURE__*/react.createElement(ProtectionToggle, null), /*#__PURE__*/react.createElement(BlockElement, null), /*#__PURE__*/react.createElement(Permissions, null), /*#__PURE__*/react.createElement(DeleteUserRules, null));
});
;// CONCATENATED MODULE: ./src/pages/popup/components/Actions/index.ts

// EXTERNAL MODULE: ./node_modules/css-loader/dist/cjs.js!./node_modules/postcss-loader/dist/cjs.js!./src/pages/popup/components/Modals/Modal/modal.pcss
var modal = __webpack_require__(7883);
;// CONCATENATED MODULE: ./src/pages/popup/components/Modals/Modal/modal.pcss

      
      
      
      
      
      
      
      
      

var modal_options = {};

modal_options.styleTagTransform = (styleTagTransform_default());
modal_options.setAttributes = (setAttributesWithoutAttributes_default());

      modal_options.insert = insertBySelector_default().bind(null, "head");
    
modal_options.domAPI = (styleDomAPI_default());
modal_options.insertStyleElement = (insertStyleElement_default());

var modal_update = injectStylesIntoStyleTag_default()(modal/* default */.Z, modal_options);




       /* harmony default export */ const Modal_modal = (modal/* default */.Z && modal/* default.locals */.Z.locals ? modal/* default.locals */.Z.locals : undefined);

;// CONCATENATED MODULE: ./src/pages/popup/components/Modals/Modal/Modal.tsx




var Modal = function Modal(_ref) {
  var title = _ref.title,
      description = _ref.description,
      close = _ref.close,
      children = _ref.children;
  return /*#__PURE__*/react.createElement("div", {
    className: "modal"
  }, /*#__PURE__*/react.createElement("div", {
    className: "modal__inner"
  }, /*#__PURE__*/react.createElement(Button, {
    onClick: close,
    classNames: "modal__close"
  }, /*#__PURE__*/react.createElement(Icon, {
    color: "gray400",
    iconId: "cross"
  })), /*#__PURE__*/react.createElement("div", {
    className: "modal__title"
  }, title), /*#__PURE__*/react.createElement("div", {
    className: "modal__description"
  }, description), children));
};
;// CONCATENATED MODULE: ./src/pages/popup/components/Modals/Modal/index.ts

;// CONCATENATED MODULE: ./src/pages/common/translators/reactTranslator.ts



/**
 * Retrieves localised messages by key, formats and converts into react components or string
 */

var reactTranslator = translate.createReactTranslator(i18n, react);
;// CONCATENATED MODULE: ./src/pages/popup/components/Modals/SitesAllowedModal/SitesAllowedModal.tsx












var SitesAllowedModal_link = function link(text) {
  var handleClick = /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regenerator_default().mark(function _callee() {
      return regenerator_default().wrap(function _callee$(_context) {
        while (1) switch (_context.prev = _context.next) {
          case 0:
            _context.next = 2;
            return browser_polyfill_default().tabs.create({
              url: WEB_EXTENSION_MORE_URL
            });

          case 2:
          case "end":
            return _context.stop();
        }
      }, _callee);
    }));

    return function handleClick() {
      return _ref.apply(this, arguments);
    };
  }();

  return (
    /*#__PURE__*/
    // eslint-disable-next-line max-len
    // eslint-disable-next-line jsx-a11y/no-static-element-interactions,jsx-a11y/anchor-is-valid,jsx-a11y/click-events-have-key-events
    react.createElement("a", {
      onClick: handleClick,
      className: "link"
    }, text)
  );
};

var CONTENT_MAP = {
  allowed: {
    title: translator.getMessage('popup_modal_all_sites_allowed_title'),
    desc: translator.getMessage('popup_modal_all_sites_allowed_desc'),
    button: translator.getMessage('popup_modal_all_sites_allowed_button')
  },
  notAllowed: {
    title: translator.getMessage('popup_modal_not_all_sites_allowed_title'),
    desc: reactTranslator.getMessage('popup_modal_not_all_sites_allowed_desc', {
      a: SitesAllowedModal_link
    }),
    button: translator.getMessage('popup_modal_not_all_sites_allowed_button')
  }
};
var SitesAllowedModal = mobxreact_esm_observer(function () {
  var store = (0,react.useContext)(popupStore);
  var content = store.allSitesAllowed ? CONTENT_MAP.allowed : CONTENT_MAP.notAllowed;

  var setPermissionsModalViewed = /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regenerator_default().mark(function _callee2() {
      return regenerator_default().wrap(function _callee2$(_context2) {
        while (1) switch (_context2.prev = _context2.next) {
          case 0:
            _context2.next = 2;
            return store.setPermissionsModalViewed();

          case 2:
          case "end":
            return _context2.stop();
        }
      }, _callee2);
    }));

    return function setPermissionsModalViewed() {
      return _ref2.apply(this, arguments);
    };
  }();

  return /*#__PURE__*/react.createElement(Modal, {
    title: content.title,
    description: content.desc,
    close: setPermissionsModalViewed
  }, /*#__PURE__*/react.createElement(Button, {
    onClick: setPermissionsModalViewed,
    classNames: "button--green button--l button--bottom"
  }, content.button));
});
;// CONCATENATED MODULE: ./src/pages/popup/components/Modals/SitesAllowedModal/index.ts

;// CONCATENATED MODULE: ./src/pages/popup/components/Modals/UpgradeModal/UpgradeModal.tsx









var UpgradeModal = mobxreact_esm_observer(function () {
  var store = (0,react.useContext)(popupStore);

  var handleClose = function handleClose() {
    store.hideUpgradeModal();
  };

  var handleClick = /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regenerator_default().mark(function _callee() {
      return regenerator_default().wrap(function _callee$(_context) {
        while (1) switch (_context.prev = _context.next) {
          case 0:
            _context.next = 2;
            return messenger.handleUpgrade();

          case 2:
            window.close();

          case 3:
          case "end":
            return _context.stop();
        }
      }, _callee);
    }));

    return function handleClick() {
      return _ref.apply(this, arguments);
    };
  }();

  return /*#__PURE__*/react.createElement(Modal, {
    title: translator.getMessage('popup_modal_title_free'),
    description: translator.getMessage('popup_modal_desc_free'),
    close: handleClose
  }, /*#__PURE__*/react.createElement(Button, {
    onClick: handleClick,
    classNames: "button--green button--l button--bottom"
  }, translator.getMessage('popup_modal_btn_free')));
});
;// CONCATENATED MODULE: ./src/pages/popup/components/Modals/UpgradeModal/index.ts

;// CONCATENATED MODULE: ./src/pages/popup/components/ui/formatting/boldText.tsx

var boldText = function boldText(text) {
  return /*#__PURE__*/react.createElement("span", {
    className: "bold"
  }, text);
};
;// CONCATENATED MODULE: ./src/pages/popup/components/ui/formatting/index.ts

// EXTERNAL MODULE: ./node_modules/css-loader/dist/cjs.js!./node_modules/postcss-loader/dist/cjs.js!./src/pages/popup/components/Modals/ProtectionModal/protection-modal.pcss
var protection_modal = __webpack_require__(3241);
;// CONCATENATED MODULE: ./src/pages/popup/components/Modals/ProtectionModal/protection-modal.pcss

      
      
      
      
      
      
      
      
      

var protection_modal_options = {};

protection_modal_options.styleTagTransform = (styleTagTransform_default());
protection_modal_options.setAttributes = (setAttributesWithoutAttributes_default());

      protection_modal_options.insert = insertBySelector_default().bind(null, "head");
    
protection_modal_options.domAPI = (styleDomAPI_default());
protection_modal_options.insertStyleElement = (insertStyleElement_default());

var protection_modal_update = injectStylesIntoStyleTag_default()(protection_modal/* default */.Z, protection_modal_options);




       /* harmony default export */ const ProtectionModal_protection_modal = (protection_modal/* default */.Z && protection_modal/* default.locals */.Z.locals ? protection_modal/* default.locals */.Z.locals : undefined);

;// CONCATENATED MODULE: ./src/pages/popup/components/Modals/ProtectionModal/ProtectionModal.tsx









var ProtectionModal = mobxreact_esm_observer(function () {
  var store = (0,react.useContext)(popupStore);

  var handleClose = function handleClose() {
    store.setProtectionModalVisibleState(false);
  };

  return /*#__PURE__*/react.createElement(Modal, {
    title: translator.getMessage('modal_protection_off_title'),
    close: handleClose
  }, /*#__PURE__*/react.createElement("div", {
    className: "protection-off"
  }, /*#__PURE__*/react.createElement("div", {
    className: "protection-off__item"
  }, /*#__PURE__*/react.createElement(Icon, {
    iconId: "settings"
  }), /*#__PURE__*/react.createElement("div", {
    className: "protection-off__info"
  }, reactTranslator.getMessage('modal_protection_off_settings', {
    b: boldText
  }))), /*#__PURE__*/react.createElement("div", {
    className: "protection-off__item"
  }, /*#__PURE__*/react.createElement(Icon, {
    iconId: "safari"
  }), /*#__PURE__*/react.createElement("div", {
    className: "protection-off__info"
  }, reactTranslator.getMessage('modal_protection_off_extensions', {
    b: boldText
  }))), /*#__PURE__*/react.createElement("div", {
    className: "protection-off__item"
  }, /*#__PURE__*/react.createElement(Icon, {
    iconId: "switcher"
  }), /*#__PURE__*/react.createElement("div", {
    className: "protection-off__info"
  }, reactTranslator.getMessage('modal_protection_off_switch', {
    b: boldText
  })))));
});
;// CONCATENATED MODULE: ./src/pages/popup/components/Modals/ProtectionModal/index.ts

;// CONCATENATED MODULE: ./src/pages/popup/components/Modals/AdvancedBlockingModal/AdvancedBlockingModal.tsx












var AdvancedBlockingModal = mobxreact_esm_observer(function () {
  var store = (0,react.useContext)(popupStore);

  var handleClose = function handleClose() {
    store.hideAdvancedBlockingModal();
  };

  var handleClick = /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regenerator_default().mark(function _callee() {
      return regenerator_default().wrap(function _callee$(_context) {
        while (1) switch (_context.prev = _context.next) {
          case 0:
            _context.next = 2;
            return messenger.enableAdvancedBlocking();

          case 2:
            window.close();

          case 3:
          case "end":
            return _context.stop();
        }
      }, _callee);
    }));

    return function handleClick() {
      return _ref.apply(this, arguments);
    };
  }();

  var ReadMoreLink = function ReadMoreLink(text) {
    var handleReadMoreClick = /*#__PURE__*/function () {
      var _ref2 = _asyncToGenerator( /*#__PURE__*/regenerator_default().mark(function _callee2() {
        return regenerator_default().wrap(function _callee2$(_context2) {
          while (1) switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return browser_polyfill_default().tabs.create({
                url: WEB_EXTENSION_MORE_URL
              });

            case 2:
            case "end":
              return _context2.stop();
          }
        }, _callee2);
      }));

      return function handleReadMoreClick() {
        return _ref2.apply(this, arguments);
      };
    }();

    return (
      /*#__PURE__*/
      // eslint-disable-next-line max-len
      // eslint-disable-next-line jsx-a11y/no-static-element-interactions,jsx-a11y/anchor-is-valid,jsx-a11y/click-events-have-key-events
      react.createElement("a", {
        onClick: handleReadMoreClick,
        className: "link"
      }, text)
    );
  };

  return /*#__PURE__*/react.createElement(Modal, {
    title: translator.getMessage('popup_modal_advanced_blocking_disabled_title') // eslint-disable-next-line max-len
    ,
    description: reactTranslator.getMessage('popup_modal_advanced_blocking_disabled_description', {
      a: ReadMoreLink
    }),
    close: handleClose
  }, /*#__PURE__*/react.createElement(Button, {
    onClick: handleClick,
    classNames: "button--green button--l button--bottom"
  }, translator.getMessage('popup_modal_advanced_blocking_disabled_button')));
});
;// CONCATENATED MODULE: ./src/pages/popup/components/Modals/AdvancedBlockingModal/index.ts

;// CONCATENATED MODULE: ./src/pages/popup/components/Modals/Modals.tsx







var Modals = mobxreact_esm_observer(function () {
  var store = (0,react.useContext)(popupStore);

  if (!store.permissionsModalViewed) {
    return /*#__PURE__*/react.createElement(SitesAllowedModal, null);
  }

  if (store.upgradeModalVisible) {
    return /*#__PURE__*/react.createElement(UpgradeModal, null);
  }

  if (store.advancedBlockingModalVisible) {
    return /*#__PURE__*/react.createElement(AdvancedBlockingModal, null);
  }

  if (store.protectionModalVisible) {
    return /*#__PURE__*/react.createElement(ProtectionModal, null);
  }

  return null;
});
;// CONCATENATED MODULE: ./src/pages/popup/components/Modals/index.ts

// EXTERNAL MODULE: ./node_modules/css-loader/dist/cjs.js!./node_modules/postcss-loader/dist/cjs.js!./src/pages/popup/components/Support/support.pcss
var support = __webpack_require__(7117);
;// CONCATENATED MODULE: ./src/pages/popup/components/Support/support.pcss

      
      
      
      
      
      
      
      
      

var support_options = {};

support_options.styleTagTransform = (styleTagTransform_default());
support_options.setAttributes = (setAttributesWithoutAttributes_default());

      support_options.insert = insertBySelector_default().bind(null, "head");
    
support_options.domAPI = (styleDomAPI_default());
support_options.insertStyleElement = (insertStyleElement_default());

var support_update = injectStylesIntoStyleTag_default()(support/* default */.Z, support_options);




       /* harmony default export */ const Support_support = (support/* default */.Z && support/* default.locals */.Z.locals ? support/* default.locals */.Z.locals : undefined);

;// CONCATENATED MODULE: ./src/pages/popup/components/Support/Support.tsx









var Support = mobxreact_esm_observer(function () {
  var store = (0,react.useContext)(popupStore);
  var supportMap = {
    protectionDisabled: {
      desc: translator.getMessage('popup_protection_disabled_support_desc')
    },
    popupFullscreen: {
      title: translator.getMessage('popup_fullscreen_support_title'),
      desc: translator.getMessage('popup_fullscreen_support_desc'),
      "class": 'support--swipe'
    }
  };
  var supportType = null;
  var protectionDisabledVisible = !store.protectionEnabled && store.contentBlockersEnabled;

  if (protectionDisabledVisible) {
    supportType = supportMap.protectionDisabled;
  } else if (store.isFullscreen || store.popupExpanded) {
    supportType = supportMap.popupFullscreen;
  }

  if (!supportType) {
    return null;
  }

  var supportClass = classnames_default()('support', supportType["class"]);

  var handleReportTouch = /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regenerator_default().mark(function _callee(e) {
      return regenerator_default().wrap(function _callee$(_context) {
        while (1) switch (_context.prev = _context.next) {
          case 0:
            e.preventDefault();
            _context.next = 3;
            return messenger.reportProblem(store.currentSiteUrl);

          case 3:
            window.close();

          case 4:
          case "end":
            return _context.stop();
        }
      }, _callee);
    }));

    return function handleReportTouch(_x) {
      return _ref.apply(this, arguments);
    };
  }();

  return /*#__PURE__*/react.createElement("div", {
    className: supportClass
  }, supportType.title && /*#__PURE__*/react.createElement("div", {
    className: "support__title"
  }, supportType.title), /*#__PURE__*/react.createElement("div", {
    className: "support__description"
  }, supportType.desc), /*#__PURE__*/react.createElement("button", {
    type: "button",
    className: "support__link",
    onClick: handleReportTouch
  }, translator.getMessage('popup_support_button_text')));
});
;// CONCATENATED MODULE: ./src/pages/popup/components/Support/index.ts

// EXTERNAL MODULE: ./node_modules/css-loader/dist/cjs.js!./node_modules/postcss-loader/dist/cjs.js!./src/pages/popup/components/Loader/loader.pcss
var loader = __webpack_require__(2199);
;// CONCATENATED MODULE: ./src/pages/popup/components/Loader/loader.pcss

      
      
      
      
      
      
      
      
      

var loader_options = {};

loader_options.styleTagTransform = (styleTagTransform_default());
loader_options.setAttributes = (setAttributesWithoutAttributes_default());

      loader_options.insert = insertBySelector_default().bind(null, "head");
    
loader_options.domAPI = (styleDomAPI_default());
loader_options.insertStyleElement = (insertStyleElement_default());

var loader_update = injectStylesIntoStyleTag_default()(loader/* default */.Z, loader_options);




       /* harmony default export */ const Loader_loader = (loader/* default */.Z && loader/* default.locals */.Z.locals ? loader/* default.locals */.Z.locals : undefined);

;// CONCATENATED MODULE: ./src/pages/popup/components/Loader/Loader.tsx




var Loader = mobxreact_esm_observer(function () {
  var store = (0,react.useContext)(popupStore);

  if (store.popupDataLoadingState !== PopupDataLoadingState.Loading) {
    return null;
  }

  return /*#__PURE__*/react.createElement("div", {
    className: "loader"
  }, /*#__PURE__*/react.createElement("div", {
    className: "loader__inner"
  }, /*#__PURE__*/react.createElement("div", {
    className: "loader__item"
  }), /*#__PURE__*/react.createElement("div", {
    className: "loader__item"
  }), /*#__PURE__*/react.createElement("div", {
    className: "loader__item"
  }), /*#__PURE__*/react.createElement("div", {
    className: "loader__item"
  })));
});
;// CONCATENATED MODULE: ./src/pages/popup/components/Loader/index.ts

;// CONCATENATED MODULE: ./src/pages/popup/components/ExpandButton/ExpandButton.tsx






var ExpandButton = mobxreact_esm_observer(function () {
  var store = (0,react.useContext)(popupStore);
  var siteAllowlisted = store.allowlistInverted ? store.protectionEnabled : !store.protectionEnabled;

  if (store.platform !== Platform.IPad // hide button after popup is expanded because safari doesn't allow to shrink it back
  || store.popupExpanded // when site is allowlisted we show support info without expanding popup
  || siteAllowlisted) {
    return null;
  }

  var handleExpandClick = function handleExpandClick() {
    store.togglePopupExpanded();
  };

  return /*#__PURE__*/react.createElement(Button, {
    onClick: handleExpandClick,
    classNames: "button--roll"
  }, /*#__PURE__*/react.createElement(Icon, {
    iconId: "arrow"
  }));
});
;// CONCATENATED MODULE: ./src/pages/popup/components/ExpandButton/index.ts

;// CONCATENATED MODULE: ./src/pages/popup/hooks/useFullscreen.ts


var isAboutHalfSize = function isAboutHalfSize(fullSize, size) {
  var HALF_SIZE_MIN_RATIO = 0.4;
  var HALF_SIZE_MAX_RATIO = 0.6;
  var ratio = size / fullSize;
  return ratio > HALF_SIZE_MIN_RATIO && ratio < HALF_SIZE_MAX_RATIO;
};

var useFullscreen = function useFullscreen(cb) {
  var requestRef = (0,react.useRef)();
  (0,react.useEffect)(function () {
    var min = 0;
    var max = 0;

    var resizeHandler = function resizeHandler() {
      var FULLSCREEN_RATIO = 1.6;
      var currentHeight = window.innerHeight;
      var screenHeight = window.screen.height;

      if (!min && isAboutHalfSize(screenHeight, currentHeight)) {
        min = currentHeight;
      } else if (currentHeight < min) {
        min = currentHeight;
      } else {
        max = currentHeight;
      }

      if (max && min && max / min > FULLSCREEN_RATIO) {
        cb(true);
      } else {
        cb(false);
      }

      requestRef.current = requestAnimationFrame(resizeHandler);
    };
    /**
     * window.onresize event doesn't fire reliable on real device, during swipes
     * that is why we use here requestAnimationFrame
     */


    requestRef.current = requestAnimationFrame(resizeHandler);
    return function () {
      if (requestRef.current !== undefined) {
        cancelAnimationFrame(requestRef.current);
      }
    };
  }, []);
};
// EXTERNAL MODULE: ./node_modules/css-loader/dist/cjs.js!./node_modules/postcss-loader/dist/cjs.js!./src/pages/popup/components/Popup/popup.pcss
var popup = __webpack_require__(8524);
;// CONCATENATED MODULE: ./src/pages/popup/components/Popup/popup.pcss

      
      
      
      
      
      
      
      
      

var popup_options = {};

popup_options.styleTagTransform = (styleTagTransform_default());
popup_options.setAttributes = (setAttributesWithoutAttributes_default());

      popup_options.insert = insertBySelector_default().bind(null, "head");
    
popup_options.domAPI = (styleDomAPI_default());
popup_options.insertStyleElement = (insertStyleElement_default());

var popup_update = injectStylesIntoStyleTag_default()(popup/* default */.Z, popup_options);




       /* harmony default export */ const Popup_popup = (popup/* default */.Z && popup/* default.locals */.Z.locals ? popup/* default.locals */.Z.locals : undefined);

;// CONCATENATED MODULE: ./src/pages/popup/components/Popup/Popup.tsx















var Popup = mobxreact_esm_observer(function () {
  var store = (0,react.useContext)(popupStore);
  (0,react.useEffect)(function () {
    _asyncToGenerator( /*#__PURE__*/regenerator_default().mark(function _callee() {
      return regenerator_default().wrap(function _callee$(_context) {
        while (1) switch (_context.prev = _context.next) {
          case 0:
            _context.prev = 0;
            _context.next = 3;
            return store.getPopupData();

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
    }))();
  }, []);
  useAppearanceTheme(store.appearanceTheme);
  useFullscreen(function (isFullscreen) {
    store.setFullscreen(isFullscreen);
  });
  return /*#__PURE__*/react.createElement("div", {
    className: "popup"
  }, /*#__PURE__*/react.createElement(Icons, null), /*#__PURE__*/react.createElement(Modals, null), /*#__PURE__*/react.createElement(Actions, null), /*#__PURE__*/react.createElement(Support, null), /*#__PURE__*/react.createElement(ExpandButton, null), /*#__PURE__*/react.createElement(Loader, null));
});
;// CONCATENATED MODULE: ./src/pages/popup/components/Popup/index.ts

;// CONCATENATED MODULE: ./src/pages/popup/index.tsx





var init = function init() {
  react_dom.render( /*#__PURE__*/react.createElement(PopupStoreContext.Provider, {
    value: popupStoreValue
  }, /*#__PURE__*/react.createElement(Popup, null)), document.getElementById('root'));
};

var popup_popup = {
  init: init
};
;// CONCATENATED MODULE: ./src/targets/popup/index.ts

popup_popup.init();
})();

/******/ })()
;