/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015 Performix LLC. All rights reserved.

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
      contole.log('doAccept');
      document.location = 'adguard://add/';
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
      $(elem).addClass(elemSelector.ignoreClassName());
      var button = document.createElement('button');
      button.innerHTML = '<svg width="60px" height="60px" viewBox="0 0 60 60" version="1.1"      xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"      xmlns:sketch="http://www.bohemiancoding.com/sketch/ns"> <title>Accept</title>      <defs></defs> <g id="Assistant" stroke="none" stroke-width="1" fill="none"      fill-rule="evenodd" sketch:type="MSPage"> <g id="Accept"      sketch:type="MSArtboardGroup" fill="#000000"> <g id="symbol"      sketch:type="MSLayerGroup" transform="translate(5.750000, 4.500000)"> <path      d="M23.3765718,33.4582294 L38.8,12.36805 C37.6698101,11.4486726      36.6792354,12.0971543 36.1331788,12.599548 L36.113275,12.6012734      L23.253399,26.1742409 L18.4072556,20.2582468 C16.0958183,17.5487147      12.9536135,19.6155166 12.2194805,20.161334 L23.3765718,33.4582294" id="Fill-4"      sketch:type="MSShapeGroup"></path> <path d="M4.15714286,8.32377634      C10.0949848,5.67963804 17.3960876,4.13528678 24.1861478,4.13528678      C30.976208,4.13528678 38.2775992,5.67963804 44.2168831,8.32377634      C44.0568218,17.1522077 42.3546924,33.2624231 24.1861478,45.2375312      C6.01818,33.2629971 4.31633897,17.1516337 4.15714286,8.32377634 Z      M7.43092146e-06,5.76745293 C7.43092146e-06,14.3326045 -0.103862999,35.6703708      24.2494248,50.25 C48.6030012,35.6703708 48.4999964,14.3326045      48.4999964,5.76745293 C40.9722755,1.80126985 31.829658,0 24.2494248,0      C16.6697688,0 7.52715124,1.80126985 7.43092146e-06,5.76745293 Z" id="Fill-1"      sketch:type="MSShapeGroup"></path> </g> </g> </g> </svg>';
      button.addEventListener('click', eventHandlers.doAccept);
      $(button).addClass(elemSelector.ignoreClassName());
      $(button).addClass('adguard-assistant-button');
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

    if (!addCSS()) {
      throw "(Init) Can't add css styles to page.";
    }
    if (!addButtons(i18n['buttons'])) {
      throw "(Init) Can't add contol buttons to page.";
    }

    elemSelector.close();
    elemSelector.init(function(element) {
      console.log('Element selected:' + element);
    });

  };

  return api;

})(AdguardAssistant || {}, balalaika, AdguardSelectorLib, AdguardRulesConstructorLib);
