
/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © Adguard Software Limited. All rights reserved.

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

#import "AEUIWhitelistController.h"
#import "ACommons/ACLang.h"
#import "ASDFilterObjects.h"
#import "AESAntibanner.h"
#import "AEService.h"
#import "AEWhitelistDomainObject.h"
#import "AEInvertedWhitelistDomainsObject.h"
#import "AEUICustomTextEditorController.h"
#import "AEUIUtils.h"
#import "AESharedResources.h"

/////////////////////////////////////////////////////////////////////
#pragma mark - AEUIWhitelistController

@implementation AEUIWhitelistController

- (id)init {
    
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Public methods

+ (AEUIWhitelistController *)createWhitelistControllerWithSegue:(UIStoryboardSegue *)segue {
    
    
    AEUICustomTextEditorController *domainList = segue.destinationViewController;
    
    NSMutableAttributedString* placeholderText;
    
    if([AESharedResources.sharedDefaults boolForKey:AEDefaultsInvertedWhitelist]) {
        
        placeholderText = [[NSMutableAttributedString alloc] initWithString:
                           ACLocalizedString(@"inverted_whitelist_hint", @"(AEUIMainController) Main screen -> Safari Content Blocking -> Inverted Whitelist. This is the text shown when the whitelist is empty.")];
        
        NSString* boldSubstring = ACLocalizedString(@"inverted_whitelist_hint_bold_part", @"Main screen -> Safari Content Blocking -> Inverted Whitelist. This is part of inverted whitelist hint string that should be heighlighted in bold");
        
        if(boldSubstring.length) {
            
            NSRange range = [placeholderText.string rangeOfString:boldSubstring];
            if(range.length) {
                
                [placeholderText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:range];
            }
        }
    }
    else {
        
        placeholderText = [[NSMutableAttributedString alloc] initWithString:
                           ACLocalizedString(@"whitelist_hint", @"(AEUIMainController) Main screen -> Safari Content Blocking -> Whitelist. This is the text shown when the whitelist is empty.")];
    }
    domainList.attributedTextForPlaceholder = placeholderText;
    
    domainList.navigationItem.title = ACLocalizedString(@"whitelist_title", @"(AEUIMainController) Main screen -> Safari Content Blocking -> Whitelist. The title of the screen.");
    domainList.keyboardType = UIKeyboardTypeURL;
    
    AEUIWhitelistController *result = [AEUIWhitelistController new];
    
    ASSIGN_WEAK(result);
    domainList.done = ^BOOL(AEUICustomTextEditorController *editor, NSString *text) {

        NSMutableArray <ASDFilterRule *> *rules = [NSMutableArray array];
        AEInvertedWhitelistDomainsObject *invertedObj;
        
        BOOL inverted = [AESharedResources.sharedDefaults boolForKey:AEDefaultsInvertedWhitelist];
        
        @autoreleasepool {
            
            NSMutableCharacterSet *delimCharSet;
            
            delimCharSet = [NSMutableCharacterSet newlineCharacterSet];
            [delimCharSet addCharactersInString:@", "];
            
            NSMutableArray* domains = [NSMutableArray new];
            [[text componentsSeparatedByCharactersInSet:delimCharSet] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if(obj.length)
                    [domains addObject:obj];
            }];
            

            if(inverted) {
                
                invertedObj = [[AEInvertedWhitelistDomainsObject alloc] initWithDomains:domains];
            }
            else {
                
                for (NSString *item in domains) {
                    
                    AEWhitelistDomainObject *obj = [[AEWhitelistDomainObject alloc] initWithDomain:item];
                    if (obj) {
                        [rules addObject:obj.rule];
                    }
                }
            }
        }
        
        @autoreleasepool {
            
            AESharedResources *res = [AESharedResources new];
            
            NSMutableArray *oldRules;
            AEInvertedWhitelistDomainsObject* oldInverterdObject;
            
            if(inverted) {
                oldInverterdObject = res.invertedWhitelistContentBlockingObject;
                res.invertedWhitelistContentBlockingObject = invertedObj;
            }
            else {
                
                oldRules = res.whitelistContentBlockingRules;
                res.whitelistContentBlockingRules = rules;
            }
            
            [AEUIUtils invalidateJsonWithController:editor completionBlock:^{
                
                //Success
                ASSIGN_STRONG(result);
                
                [editor setLoadingStatus:YES];
                [USE_STRONG(result) reloadUserFilterDataForEditorController:editor];
                
            } rollbackBlock:^{
                
                //Failure
                if(inverted) {
                    res.invertedWhitelistContentBlockingObject = oldInverterdObject;
                }
                else {
                    res.whitelistContentBlockingRules = oldRules;
                }
                
            }];
        }
        
        return NO;
    };
    
    domainList.replaceText = ^BOOL(NSString *text, UITextView *textView, NSRange range) {
        
        if ([text contains:@"/"]) {
            if (text.length > 1) {
                
                NSURL *url = [NSURL URLWithString:text];
                text = [[url hostWithPort] stringByAppendingString:@"\n"];
                if (text) {
                    
                    [textView replaceRange:[textView textRangeFromNSRange:range] withText:text];
                }
            }
            return NO;
        }
        
        return YES;
        
    };

    domainList.auxiliaryObject = result;
    domainList.delegate = result;
    
    [domainList setLoadingStatus:YES];
    
    return result;
}
/////////////////////////////////////////////////////////////////////
#pragma mark Delegates


- (void)editorDidAppear:(AEUICustomTextEditorController *)editor {
    
    //    if ([NSString isNullOrEmpty:self->_ruleTextHolderForAddRuleCommand]) {
    
    [editor setLoadingStatus:YES];
    [self reloadUserFilterDataForEditorController:editor];
    //    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark Private methods


- (void)reloadUserFilterDataForEditorController:(AEUICustomTextEditorController *)editor {
    
    BOOL inverted = [AESharedResources.sharedDefaults boolForKey:AEDefaultsInvertedWhitelist];
    
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                       @autoreleasepool {
                      
                           //create attributed text with all rules
                           NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]
                                                                        initWithString:@""
                                                                        attributes:AEUICustomTextEditorController.defaultTextAttributes];
                           
                           AESharedResources *resources = [AESharedResources new];
                           
                           NSMutableArray *rules;
                           if(inverted) {
                               AEInvertedWhitelistDomainsObject *obj = resources.invertedWhitelistContentBlockingObject;
                               
                               if(obj) {
                                   ASDFilterRule* rule = obj.rule;
                                   if(rule)
                                       rules = [NSMutableArray arrayWithObject:rule];
                               }
                               else {
                                   rules = [NSMutableArray new];
                               }
                               
                               NSAttributedString *newline = [[NSAttributedString alloc] initWithString:@"\n"
                                                                                             attributes:AEUICustomTextEditorController.defaultTextAttributes];
                               
                               for(NSString* domain in obj.domains) {
                                   NSAttributedString *attrDomain = [[NSAttributedString alloc] initWithString:domain
                                                                                                    attributes:AEUICustomTextEditorController.defaultTextAttributes];
                                   [attributedText appendAttributedString:attrDomain];
                                   [attributedText appendAttributedString:newline];
                               }
                           }
                           else {
                               rules = resources.whitelistContentBlockingRules;
                               
                               NSAttributedString *newline = [[NSAttributedString alloc] initWithString:@"\n"
                                                                                             attributes:AEUICustomTextEditorController.defaultTextAttributes];
                               
                               AEWhitelistDomainObject *obj;
                               
                               for (ASDFilterRule *item in rules) {
                                   
                                   obj = [[AEWhitelistDomainObject alloc]
                                          initWithRule:item];
                                   if (obj) {
                                       
                                       NSAttributedString *attrDomain = [[NSAttributedString alloc] initWithString:obj.domain
                                                                                                        attributes:AEUICustomTextEditorController.defaultTextAttributes];
                                       [attributedText appendAttributedString:attrDomain];
                                       [attributedText appendAttributedString:newline];
                                   }
                               }
                           }
                           
                           
                           
                           dispatch_async(dispatch_get_main_queue(), ^{
                               
                                   // assign attributed text with all rules
                                   editor.attributedTextForEditing = attributedText;
                           });
                       }
                   });
    
}

@end

