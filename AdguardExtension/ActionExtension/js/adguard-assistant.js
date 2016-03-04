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

  var name = '';

  // PRIVATE METHODS

  var eventHandlers = {

    doAccept: function(e){
      console.log('doAccept');
      document.location = 'adguard://add/';
    },
    doCancel: function(e){
      console.log('doCancel');
      elemSelector.reset();
    }
  };

  var addCSS = function(){
    try {
      var name = 'adguard-assistant-css';

      var elem = document.getElementById(name);
      if (elem){ elem.remove();}
      /* At this point we include selector css, because action extension script doesn't allow loading local resources. */
      elem = document.createElement('style');
      elem.id = name;
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
      var result = false;
      var name = 'adguard-assistant-dialog';

      var elem = document.getElementById(name);
      if (elem) {elem.remove();}
      elem = document.createElement('div');
      elem.id = name;

      var button = document.createElement('div');
      button.id = "adguard-button-cancel";
      button.innerHTML = "&nbsp;";
      $(button).addClass('adguard-assistant-button');
      $(button).on("click",eventHandlers.doCancel);
      elem.appendChild(button);

      if (!document.body.appendChild(elem)) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  };

  // PUBLIC API
  api.init = function (i18n) {
    // default vaules
    i18n = typeof i18n !== 'undefined' ? i18n : {'buttons':{'plus':'+', 'minus':'-', 'accept':'accept'}};

    elemSelector.close();
    elemSelector.init(function(element) {
      console.log('Element selected:' + element);
    });

    if (!addCSS()) {
      throw "(Init) Can't add css styles to page.";
    }
    if (!addButtons(i18n['buttons'])) {
      throw "(Init) Can't add contol buttons to page.";
    }
  };

  return api;

})(AdguardAssistant || {}, balalaika, AdguardSelectorLib, AdguardRulesConstructorLib);
