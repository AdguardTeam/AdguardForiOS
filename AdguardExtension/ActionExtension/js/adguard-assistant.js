/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015,2016 Performix LLC. All rights reserved.

    Adguard for iOS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Adguard for iOS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
 */

/**
* Adguard Assistant
*/
var AdguardAssistant = (function (api, $, elemSelector, ruleConstructor) {

  // PRIVATE FIELDS

  var acceptUrlScheme; //Url scheme for redirecting to Adguard app

  var uiId          = 'adguard-assistant-dialog'
    , cssId         = 'adguard-assistant-css'
    , mainButtunsId = 'adguard-assistant-main-buttons'
    , ignoreClass   = elemSelector.ignoreClassName()
      ;

  var uiHandler; // Main UI element
  var UI_BORDER_WIDTH = 1; // Base border width of the main UI element
  var UI_BORDER_RADIUS = 3; // Base border radius of the main UI element
  var zoomHandler; // Element for setting zoom factor

  var mainButtons; // Main buttons element
  var plusButton; // Plus button element
  var minusButton; // Minus button element
  var acceptButton; // Accept button element
  var previewButton; // Preview button element
  var cancelButton; // Reset button element
  var selectedElements = []; // Selected elements stack

  var previewState = false;

  var zoomFactor = 1;

  //--- renderer vars ---
  var R_BORDER_WIDTH = 2;
  var R_BORDER_PADDING = 2;
  var R_BOTTOM_HEIGHT = 12;
  var selectionLayout = null;
  var selectionLayoutBottom = null;

  // PRIVATE METHODS

  var eventHandlers = {

    doAccept: function(e){
      api.close();
      var len = selectedElements.length;
      if (len) {
        var item = selectedElements[len - 1];
        var item = ruleConstructor.constructRuleText(item,{'url': document.URL, 'ruleType': 'CSS'});
        if (item) {
          item = acceptUrlScheme + '://add/' + encodeURIComponent(item);
          document.location = item;
        }
      }
    },
    doPreview: function(e){
      var len = selectedElements.length;
      if (len) {
        previewState = true;
        var item = selectedElements[len - 1];
        elemSelector.reset();
        showElement(item,false);
        setMainButtons();
      }
    },
    doPlus: function(e){
      var len = selectedElements.length;
      if (len) {
        var item = selectedElements[len - 1];
        if (item.parentNode && item.parentNode.tagName !== 'BODY') {
          item = item.parentNode;
          elemSelector.selectElement(item);
          selectedElements.push(item);
          setMainButtons();
        }
      }
    },
    doMinus: function(e){
      var len = selectedElements.length;
      if (len > 1) {
        selectedElements.pop();
        var item = selectedElements[len - 2];
        elemSelector.selectElement(item);
        setMainButtons();
      }
    },
    doCancel: function(e){
      if (previewState) {
        var len = selectedElements.length;
        if (len) {
          previewState = false;
          var item = selectedElements[len - 1];
          showElement(item,true);
          elemSelector.selectElement(item);
          setMainButtons();
        }
      }
      else if (selectedElements.length) {
        api.reset();
      }
      else {
        api.close();
      }
    },

    //-------
    onZoom: function(e){
      // var _width = document.documentElement.clientWidth;
      var _width = (window.orientation == 0 || window.orientation == 180) ? window.screen.availWidth : window.screen.availHeight;
      zoomFactor = window.innerWidth/_width;

       zoomHandler.style.zoom = ''+zoomFactor;

      var value = (UI_BORDER_WIDTH * zoomFactor);
      if (value < 0.5) {
          value = 0.5;
      }
      uiHandler.style.borderWidth = value + 'px';
      value = (UI_BORDER_RADIUS * zoomFactor);
      uiHandler.style.borderRadius = value + 'px';

    uiHandler.style.top = (window.pageYOffset + window.innerHeight) - (50 * zoomFactor) + 'px';
    uiHandler.style.left = (window.pageXOffset + (window.innerWidth/2)) + 'px';

      if (!previewState) {

          var len = selectedElements.length;
          if (len) {
            var item = selectedElements[len - 1];
            elemSelector.selectElement(item);
          }
      }
    }
  };

  var selectionRenderer = {
      init: function(){

          if (!selectionLayout) {

              selectionLayout = $('<div/>').addClass('adguard-sg-layout').hide();
              selectionLayoutBottom = $('<div/>').addClass('adguard-sg-layout-bottom');
              selectionLayoutBottom.get(0).textContent = '&nbsp;';
              selectionLayout.get(0).appendChild(selectionLayoutBottom.get(0));
              document.body.appendChild(selectionLayout.get(0));
          }
      },

      finalize: function(){

          if (selectionLayout && selectionLayout.get(0)) {
              var parent = selectionLayout.get(0).parentNode;

              if (parent) {
                  parent.removeChild(selectionLayout.get(0));
              }
          }

          selectionLayout = selectionLayoutBottom = null;
      },

      add: function (element) {
        this.remove();

        if (!(element && selectionLayout)) {
          return;
        }

        var px = function(v){return (v + 'px');};

        var rect = element.getBoundingClientRect();
        var startingPointRect = document.body.getBoundingClientRect();
        var
            top = rect.top - startingPointRect.top,
            left = rect.left - startingPointRect.left,
            width = element.offsetWidth,
            height = element.offsetHeight,
            border = R_BORDER_WIDTH * zoomFactor,
            bottomHeight = R_BOTTOM_HEIGHT * zoomFactor;

            if (border < 0.5) {
                border = 0.5;
            }
            if (bottomHeight < 3) {
                bottomHeight = 3;
            }

        selectionLayout.css('border-width', px(border))
        .css('top', px(top - R_BORDER_PADDING))
        .css('left', px(left - R_BORDER_PADDING))
        .css('width', px(width + R_BORDER_PADDING * 2))
        .css('height', px(height + R_BORDER_PADDING * 2 + bottomHeight));

        selectionLayoutBottom.css('line-height', px(bottomHeight))
        .css('font-size', px(bottomHeight));

        if (element.parentNode) {
            selectionLayoutBottom.get(0).textContent =  element.parentNode.tagName.toLowerCase() + ' ' + element.tagName.toLowerCase();
        } else {
            selectionLayoutBottom.get(0).textContent =  element.tagName.toLowerCase();
        }

        selectionLayout.show();
      },

      remove: function () {
          if (selectionLayout) {
              selectionLayout.hide();
          }
      },

      BORDER_CLASS: "sg_selected"
  };

  var addCSS = function(){
    try {
      var elem = document.getElementById(cssId);
      if (elem){ elem.remove();}
      /* At this point we include selector css, because action extension script doesn't allow loading local resources. */
      elem = document.createElement('style');
      elem.id = cssId;
      elem.innerHTML = "/*LOAD_CSS_HERE*/\
      ";
      elem = document.head.appendChild(elem);
      return (elem != undefined);
    } catch (e) {
        return false;
    }
  };

  var addButtons = function(titles){
    try {
      uiHandler = document.getElementById(uiId);
      if (uiHandler) {uiHandler.remove();}
      uiHandler = document.createElement('div');
      uiHandler.id = uiId;
      $(uiHandler).addClass(ignoreClass);
      $(window).on("resize", eventHandlers.onZoom, true);
      $(window).on("scroll", eventHandlers.onZoom, true);
      $(window).on("orientationchange", eventHandlers.onZoom, true);

      zoomHandler = document.createElement('div');
      $(zoomHandler).addClass(ignoreClass + ' adguard-assistant-zoom');
      uiHandler.appendChild(zoomHandler);

      mainButtons = document.createElement('div');
      mainButtons.id = mainButtunsId;
      $(mainButtons).addClass(ignoreClass);

//------------
      acceptButton = document.createElement('div');
      acceptButton.id = "adguard-button-accept";
      acceptButton.innerHTML = "&nbsp;";
      acceptButton.title = titles["accept"];
      $(acceptButton).addClass(ignoreClass + ' adguard-assistant-button enabled');
      $(acceptButton).on("click",eventHandlers.doAccept);
      mainButtons.appendChild(acceptButton);

      previewButton = document.createElement('div');
      previewButton.id = "adguard-button-preview";
      previewButton.innerHTML = "&nbsp;";
      previewButton.title = titles["preview"];
      $(previewButton).addClass(ignoreClass + ' adguard-assistant-button');
      mainButtons.appendChild(previewButton);

      plusButton = document.createElement('div');
      plusButton.id = "adguard-button-plus";
      plusButton.innerHTML = "&nbsp;";
      plusButton.title = titles["plus"];
      $(plusButton).addClass(ignoreClass + ' adguard-assistant-button');
      mainButtons.appendChild(plusButton);

      minusButton = document.createElement('div');
      minusButton.id = "adguard-button-minus";
      minusButton.innerHTML = "&nbsp;";
      minusButton.title = titles["minus"];
      $(minusButton).addClass(ignoreClass + ' adguard-assistant-button');
      mainButtons.appendChild(minusButton);

      zoomHandler.appendChild(mainButtons);
//-------
      cancelButton = document.createElement('div');
      cancelButton.id = "adguard-button-cancel";
      cancelButton.innerHTML = "&nbsp;";
      cancelButton.title = titles["cancel"];
      $(cancelButton).addClass(ignoreClass + ' adguard-assistant-button enabled');
      $(cancelButton).on("click",eventHandlers.doCancel);
      zoomHandler.appendChild(cancelButton);

      eventHandlers.onZoom();

      if (!document.body.appendChild(uiHandler)) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  };

  var removeButtons = function(){

    $(acceptButton).off("click",eventHandlers.doAccept);
    $(previewButton).off("click",eventHandlers.doPreview);
    $(cancelButton).off("click",eventHandlers.doCancel);
    $(plusButton).off("click", eventHandlers.doPlus);
    $(minusButton).off("click", eventHandlers.doMinus);
    mainButtons = null;
    plusButton = null;
    minusButton = null;
    acceptButton = null;
    previewButton = null;
    cancelButton = null;

    $(window).off("resize", eventHandlers.onZoom);
    $(window).off("scroll", eventHandlers.onZoom);
    $(window).off("orientationchange", eventHandlers.onZoom);
    uiHandler = null;
    var elem = $('#' + uiId).get(0);
    if (elem) {
      elem.remove();
    }
  };

  var removeCSS = function(){

    elem = $('#' + cssId).get(0);
    if (elem) {
      elem.remove();
    }
  };

  var setMainButtons = function(){
      var len = selectedElements.length;
      if (len) {
        var item = selectedElements[len - 1];

        $(mainButtons).addClass('enabled');

        if (previewState) {
          $(previewButton).removeClass('enabled');
          $(previewButton).off('click', eventHandlers.doPreview);
        }
        else {
          $(previewButton).addClass('enabled');
          $(previewButton).on('click', eventHandlers.doPreview);
        }

        if (previewState || (item.parentNode && item.parentNode.tagName && item.parentNode.tagName === 'BODY')) {
          $(plusButton).removeClass('enabled');
          $(plusButton).off('click', eventHandlers.doPlus);
        }
        else{
          $(plusButton).addClass('enabled');
          $(plusButton).on('click', eventHandlers.doPlus);
        }

        if (!previewState && len > 1) {
          $(minusButton).addClass('enabled');
          $(minusButton).on('click', eventHandlers.doMinus);
        }
        else{
          $(minusButton).removeClass('enabled');
          $(minusButton).off('click', eventHandlers.doMinus);
        }
      }
      else{

        $(mainButtons).removeClass('enabled');

        $(previewButton).removeClass('enabled');
        $(previewButton).off('click', eventHandlers.doPreview);

        $(plusButton).removeClass('enabled');
        $(plusButton).off('click', eventHandlers.doPlus);
        $(minusButton).removeClass('enabled');
        $(minusButton).off('click', eventHandlers.doMinus);
      }
  };

  var showElement = function(element, show){

      if (show) {
        if (element.adguardDisplayStyleHolder) {
          element.style.display = element.adguardDisplayStyleHolder;
          delete element.adguardDisplayStyleHolder;
        }
        else {
          element.style.removeProperty('display');
        }
      }
      else {
        var oldValue = element.style.display;
        if (oldValue) {
          element.adguardDisplayStyleHolder = oldValue;
        }
        element.style.display = 'none';
      }
  }

  var selectElementHandler = function(element){
    elemSelector.selectElement(element);
    selectedElements = [element];
    setMainButtons();
  };

  // PUBLIC API
  api.init = function (settings) {
    // default vaules
    i18n = (typeof settings !== 'undefined' && typeof settings.i18n !== 'undefined') ? settings.i18n : {'buttons':{'plus':'+', 'minus':'-', 'accept':'Accept', 'cancel': 'Cancel', 'preview': 'Preview'}};

    //set accept url scheme
    acceptUrlScheme = (typeof settings !== 'undefined' && typeof settings.urlScheme !== 'undefined') ? settings.urlScheme : "adguard";

    api.close();
    // elemSelector.init(function(element){
    //   selectElementHandler.call(AdguardAssistant, element);
    // });

    elemSelector.init(selectElementHandler, selectionRenderer);
    // elemSelector.init(selectElementHandler);

    if (!addCSS()) {
      throw "(Init) Can't add css styles to page.";
    }
    if (!addButtons(i18n['buttons'])) {
      throw "(Init) Can't add contol buttons to page.";
    }
  };

  api.close = function(){

    elemSelector.close();
    removeButtons();
    removeCSS();
  };

  api.reset = function(){

    elemSelector.close();
    elemSelector.init(selectElementHandler, selectionRenderer);
    // elemSelector.init(selectElementHandler);
    selectedElements = [];
    setMainButtons();
  };

  return api;

})(AdguardAssistant || {}, balalaika, AdguardSelectorLib, AdguardRulesConstructorLib);
