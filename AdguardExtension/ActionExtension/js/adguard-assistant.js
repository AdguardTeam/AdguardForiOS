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

  var uiId          = 'adguard-assistant-dialog'
    , cssId         = 'adguard-assistant-css'
    , mainButtunsId = 'adguard-assistant-main-buttons'
      ;

  var uiHandler; // Main UI element
  var mainButtons; // Main buttons element
  var plusButton; // Plus button element
  var minusButton; // Minus button element
  var acceptButton; // Accept button element
  var previewButton; // Preview button element
  var cancelButton; // Reset button element
  var selectedElements = []; // Selected elements stack

  var previewState = false;

  // PRIVATE METHODS

  var eventHandlers = {

    doAccept: function(e){
      console.log('doAccept');
      api.close();
      var len = selectedElements.length;
      if (len) {
        var item = selectedElements[len - 1];
        var item = ruleConstructor.constructRuleText(item,{'domain': document.domain});
        if (item) {
          item = 'adguard://add/' + encodeURIComponent(item);
          console.info('Open URL in Adguard:' + item);
          document.location = item;
          console.log('test');
        }
      }
    },
    doPreview: function(e){
      console.log('doPreview');
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
      console.log('doPlus');
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
      console.log('doMinus');
      var len = selectedElements.length;
      if (len > 1) {
        selectedElements.pop();
        var item = selectedElements[len - 1];
        elemSelector.selectElement(item);
        setMainButtons();
      }
    },
    doCancel: function(e){
      console.log('doCancel');
      if (previewState) {
        console.log('doCancel cancel preview');
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
        console.log('doCancel reset');
        api.reset();
      }
      else {
        console.log('doCancel close');
        api.close();
      }
    },

    //-------
    onZoom: function(e){
      console.log('onZoom: window.innerWidth='+ window.innerWidth+' document.documentElement.clientWidth='+document.documentElement.clientWidth);
      // var _width = document.documentElement.clientWidth;
      var _width = window.orientation == 0 ? window.screen.availWidth : window.screen.availHeight;
      var zoomFactor = window.innerWidth/_width;
      console.log('Zoom factor:'+zoomFactor);
      uiHandler.style.zoom = ''+zoomFactor;
      uiHandler.style.top = (window.pageYOffset + window.innerHeight)/zoomFactor - 50 + 'px';
      uiHandler.style.left = (window.pageXOffset + (window.innerWidth/2))/zoomFactor + 'px';
    }
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
      debugger;
      uiHandler = document.getElementById(uiId);
      if (uiHandler) {uiHandler.remove();}
      uiHandler = document.createElement('div');
      uiHandler.id = uiId;
      $(window).on("resize", eventHandlers.onZoom, true);
      $(window).on("scroll", eventHandlers.onZoom, true);

      mainButtons = document.createElement('div');
      mainButtons.id = mainButtunsId;

//------------
      acceptButton = document.createElement('div');
      acceptButton.id = "adguard-button-accept";
      acceptButton.innerHTML = "&nbsp;";
      acceptButton.title = titles["accept"];
      $(acceptButton).addClass('adguard-assistant-button enabled');
      $(acceptButton).on("click",eventHandlers.doAccept);
      mainButtons.appendChild(acceptButton);

      previewButton = document.createElement('div');
      previewButton.id = "adguard-button-preview";
      previewButton.innerHTML = "&nbsp;";
      previewButton.title = titles["preview"];
      $(previewButton).addClass('adguard-assistant-button');
      mainButtons.appendChild(previewButton);

      plusButton = document.createElement('div');
      plusButton.id = "adguard-button-plus";
      plusButton.innerHTML = "&nbsp;";
      plusButton.title = titles["plus"];
      $(plusButton).addClass('adguard-assistant-button');
      mainButtons.appendChild(plusButton);

      minusButton = document.createElement('div');
      minusButton.id = "adguard-button-minus";
      minusButton.innerHTML = "&nbsp;";
      minusButton.title = titles["minus"];
      $(minusButton).addClass('adguard-assistant-button');
      mainButtons.appendChild(minusButton);

      uiHandler.appendChild(mainButtons);
//-------
      cancelButton = document.createElement('div');
      cancelButton.id = "adguard-button-cancel";
      cancelButton.innerHTML = "&nbsp;";
      cancelButton.title = titles["cancel"];
      $(cancelButton).addClass('adguard-assistant-button enabled');
      $(cancelButton).on("click",eventHandlers.doCancel);
      uiHandler.appendChild(cancelButton);

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

    $(window).off("resize", eventHandlers.onZoom, true);
    $(window).off("scroll", eventHandlers.onZoom, true);
    uiHandler = 0;
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

        console.log("setMenuButtons item.parentNode:" + item.parentNode + " item.parentNode.tagName:" + item.parentNode.tagName);
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
    console.warn('Element selected:' + element);
    selectedElements = [element];
    setMainButtons();
  };

  // PUBLIC API
  api.init = function (i18n) {
    // default vaules
    i18n = typeof i18n !== 'undefined' ? i18n : {'buttons':{'plus':'+', 'minus':'-', 'accept':'Accept', 'cancel': 'Cancel'}};

    api.close();
    console.info('Adguard Assistant Init');
    // elemSelector.init(function(element){
    //   selectElementHandler.call(AdguardAssistant, element);
    // });

    elemSelector.init(selectElementHandler);

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

    elemSelector.reset();
    selectedElements = [];
    setMainButtons();
  };

  return api;

})(AdguardAssistant || {}, balalaika, AdguardSelectorLib, AdguardRulesConstructorLib);
