//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

function Assistant(){
  (function() {

    /* At this point we include all libraries, because action extension script doesn't allow loading local resources. */
    /*LOAD_LIBRARY_HERE*/

   adguardAssistant().start(null, function(ruleText){

                          settings = window.AdguardAssistant_settings;
                          acceptUrlScheme = (typeof settings !== 'undefined' && typeof settings.urlScheme !== 'undefined') ? settings.urlScheme : "adguard";

                           var item = acceptUrlScheme + '://add/' + encodeURIComponent(ruleText);
                           document.location = item;
                          });

  })();
}

function DestroyAssistant(){
    var scriptId = 'adguard-assistant-destroy-script';
    var script = document.getElementById(scriptId);
    if (script){ script.remove();}
      script = document.createElement('script');
      script.id = scriptId;
      script.appendChild(document.createTextNode('(function() {try { window.AdguardAssistantDestroy(); } catch (e) { }  })();'));
     document.head.appendChild(script);
}

/**************************************************************/

var lastErrorEventHandler = null;
function injectScript(fn) {
  var scriptId = 'adguard-assistant-script';
  var script = document.getElementById(scriptId);
  if (script){ script.remove();}
    script = document.createElement('script');
    script.id = scriptId;
    script.appendChild(document.createTextNode('(' + fn + ')();'));

   document.head.appendChild(script);
}

var ExtensionJavaScriptClass = function() {};

ExtensionJavaScriptClass.prototype = {

  run: function(arguments) {

    injectScript(function(){
      var elem  = document.createElement('div');
      elem.id = "adguard-assistant-checkInject";
      elem.style.display = 'none';
      document.body.appendChild(elem);
    });

    var injectScriptSupported = document.getElementById('adguard-assistant-checkInject') ? true : false;

    // Destroy Assistant if was injected before
    if (injectScriptSupported) {
        // try {
        //
        //     window.AdguardAssistantDestroy();
        // } catch (e) {
        //
        // }
        DestroyAssistant();
    }

    arguments.completionFunction(
      {"urlString": document.location.href,
    'injectScriptSupported': injectScriptSupported});
  },

  finalize: function(arguments) {
    if (arguments["needReload"])
    document.location.reload();
    else if (arguments["blockElement"]){
        var settings = arguments['settings'];
        if (settings) {
            settings = 'function(){window.window.AdguardAssistant_settings = '+JSON.stringify(settings)+';}';
            injectScript(settings);
        }
      injectScript(Assistant);
    }
  }

};

// The JavaScript file must contain a global object named "ExtensionPreprocessingJS".
var ExtensionPreprocessingJS = new ExtensionJavaScriptClass;
