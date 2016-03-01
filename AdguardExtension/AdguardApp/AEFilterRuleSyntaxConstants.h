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
#ifndef AEFilterRuleSyntaxConstants_h
#define AEFilterRuleSyntaxConstants_h



#define PARAMETER_START                 @"["
#define PARAMETER_END                   @"]"
#define MASK_REGEX_RULE                 @"/"
#define MASK_WHITE_LIST                 @"@@"
#define MASK_CONTENT_RULE               @"$$"
#define MASK_CONTENT_EXCEPTION_RULE     @"$@$"
#define MASK_CSS_RULE                   @"##"
#define MASK_CSS_EXCEPTION_RULE         @"#@#"
#define MASK_CSS_INJECT_RULE            @"#$#"
#define MASK_CSS_INJECT_EXCEPTION_RULE  @"#@$#"
#define MASK_SCRIPT_RULE                @"#%#"
#define MASK_SCRIPT_EXCEPTION_RULE      @"#@%#"
#define MASK_OBSOLETE_SCRIPT_INJECTION  @"###adg_start_script_inject"
#define COMMENT                         @"!"
#define EQUAL                           @"="
#define COMA_DELIMITER                  @","
#define LINE_DELIMITER                  @"|"
#define NOT_MARK                        @"~"

#define AFRU_OPTIONS_DELIMITER          @"$"
#define AFRU_DOMAIN_OPTION              @"domain"
#define AFRU_THIRD_PARTY_OPTION         @"third-party"
#define AFRU_MATCH_CASE_OPTION          @"match-case"
#define AFRU_DOCUMENT_OPTION            @"document"
#define AFRU_ELEMHIDE_OPTION            @"elemhide"
#define AFRU_URLBLOCK_OPTION            @"urlblock"
#define AFRU_JSINJECT_OPTION            @"jsinject"
#define AFRU_CONTENT_OPTION             @"content"
#define AFRU_SCRIPT_OPTION              @"jscript" //TODO: may be depricated
#define AFRU_POPUP_OPTION               @"popup"
#define AFRU_REPLACE_WITH_MP4_OPTION    @"mp4"
#define AFRU_EMPTY_OPTION               @"empty"

// content type filtering
#define AFRU_AD_SCRIPT_OPTION           @"script"
#define AFRU_AD_IMAGE_OPTION            @"image"
#define AFRU_AD_STYLESHEET_OPTION       @"stylesheet"
#define AFRU_AD_OBJECT_OPTION           @"object"
#define AFRU_AD_XMLHTTPREQUEST_OPTION   @"xmlhttprequest"
#define AFRU_AD_SUBDOCUMENT_OPTION      @"subdocument"
#define AFRU_AD_OBJECTSUBREQUEST_OPTION @"object-subrequest" //TODO: may be depricated

#define AFRU_MASK_START_URL             @"||"
#define AFRU_MASK_PIPE                  @"|"
#define AFRU_MASK_ANY_SYMBOL            @"*"
#define AFRU_MASK_SEPARATOR             @"^"
#define AFRU_REGEXP_START_URL           @"^https?://([a-z0-9-_.]+\\.)?"
#define AFRU_REGEXP_ANY_SYMBOL          @".*"
#define AFRU_REGEXP_START_STRING        @"^"
#define AFRU_REGEXP_SEPARATOR           @"([^ a-zA-Z0-9.%]|$)"
#define AFRU_REGEXP_END_STRING          @"$"

#endif /* AEFilterRuleSyntaxConstants_h */
