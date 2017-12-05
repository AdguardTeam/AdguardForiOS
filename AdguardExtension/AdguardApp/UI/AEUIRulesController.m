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
#import "AEUIRulesController.h"
#import "ACommons/ACLang.h"
#import "ASDFilterObjects.h"
#import "AESAntibanner.h"
#import "AEService.h"
#import "AEUIFilterRuleObject.h"
#import "AEUIUtils.h"

/////////////////////////////////////////////////////////////////////
#pragma mark - AEUIRulesController

@implementation AEUIRulesController{
    
    NSString *_ruleTextHolderForAddRuleCommand;
}

/////////////////////////////////////////////////////////////////////
#pragma mark - Public methods

+ (AEUIRulesController *)createUserFilterControllerWithSegue:(UIStoryboardSegue *)segue
                             ruleTextHolderForAddRuleCommand:(NSString *)ruleTextHolderForAddRuleCommand{
    
    
    AEUICustomTextEditorController *rulesList = segue.destinationViewController;
    
    rulesList.attributedTextForPlaceholder = [[NSAttributedString alloc] initWithString: NSLocalizedString(@"Enter your custom rules here, separated by line breaks.",
                                                                                                           @"(AEUIMainController) Main screen -> Safari Content Blocking -> User Filter. This is the text shown when the User Filter is empty.")];
    
    rulesList.navigationItem.title = NSLocalizedString(@"User Filter", @"(AEUIMainController) Main screen -> Safari Content Blocking -> User Filter. The title of the screen.");
    
    rulesList.showFilterRules = YES;
    
    [rulesList setLoadingStatus:YES];
    
    AEUIRulesController *result = [AEUIRulesController new];
    
    result->_ruleTextHolderForAddRuleCommand = ruleTextHolderForAddRuleCommand;
    
    ASSIGN_WEAK(result);
    rulesList.done = ^BOOL(AEUICustomTextEditorController *editor, NSString *text) {
        
        NSMutableArray *rules = [NSMutableArray array];
        @autoreleasepool {
            
            NSMutableCharacterSet *delimCharSet;
            
            delimCharSet = [NSMutableCharacterSet newlineCharacterSet];
            
            for (NSString *item in  [text componentsSeparatedByCharactersInSet:delimCharSet]) {
                
                if (item.length) {
                    ASDFilterRule *rule = [[ASDFilterRule alloc] initWithText:item enabled:YES];
                    if (rule) {
                        [rules addObject:rule];
                    }
                }
            }
        }
        
        @autoreleasepool {
            
            [[[AEService singleton] antibanner] beginTransaction];
            [AEUIUtils replaceUserFilterRules:rules withController:editor completionBlock:^{
                
                //Success
                ASSIGN_STRONG(result);
                [[[AEService singleton] antibanner] endTransaction];
                
                [editor setLoadingStatus:YES];
                [USE_STRONG(result) reloadUserFilterDataForEditorController:editor];
                
            } rollbackBlock:^(NSError *error) {
                //Failure
                [[[AEService singleton] antibanner] rollbackTransaction];
                
                if (error.code == AES_ERROR_UNSUPPORTED_RULE ) {
                    
                    ASDFilterRule *rule = error.userInfo[AESUserInfoRuleObject];
                    if (rule) {
                        [editor selectWithType:AETESelectionTypeError text:rule.ruleText];
                    }
                }
                
            }];
        }
        
        return NO;
    };
    
    rulesList.auxiliaryObject = result;
    rulesList.delegate = result;
    
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
    
    ASSIGN_WEAK(self);
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                       @autoreleasepool {
                           
                           //create attributed text with all rules
                           NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]
                                                                        initWithString:@""
                                                                        attributes:AEUICustomTextEditorController.defaultTextAttributes];
                           
                           NSArray *rules = [[[AEService singleton] antibanner]
                                             rulesForFilter:@(ASDF_USER_FILTER_ID)];
                           NSAttributedString *newline = [[NSAttributedString alloc] initWithString:@"\n"
                                                                                         attributes:AEUICustomTextEditorController.defaultTextAttributes];
                           AEUIFilterRuleObject *obj;
                           for (ASDFilterRule *item in rules) {
                               
                               obj = [[AEUIFilterRuleObject alloc]
                                      initWithRule:item];
                               if (obj) {
                                   [attributedText appendAttributedString:obj.attributeRuteText];
                                   [attributedText appendAttributedString:newline];
                               }
                           }
                           
                           dispatch_async(dispatch_get_main_queue(), ^{
                               
                               ASSIGN_STRONG(self);
                               if ([NSString isNullOrEmpty:USE_STRONG(self)->_ruleTextHolderForAddRuleCommand]) {
                                   // assign attributed text with all rules
                                   editor.attributedTextForEditing = attributedText;
                               }
                               else {
                                   // if this is launch from AG Assistent
                                   
                                   NSAttributedString *obj = [[NSAttributedString alloc] initWithString:USE_STRONG(self)->_ruleTextHolderForAddRuleCommand
                                                                                             attributes:AEUICustomTextEditorController.defaultTextAttributes];
                                   if (obj) {
                                       
                                       [attributedText appendAttributedString:obj];
                                       [attributedText appendAttributedString:newline];
                                   }
                                   
                                   // assign attributed text with all rules
                                   editor.attributedTextForEditing = attributedText;
                                   
                                   self->_ruleTextHolderForAddRuleCommand = nil;
                                   
                                   // scroll to bottom
                                   NSRange bottom = NSMakeRange(attributedText.length - 1, 1);
                                   [editor.editorTextView scrollRangeToVisible:bottom];
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       [editor clickDone:editor.doneButton];
                                   });

                               }
                               
                           });
                       }
                   });
    
}

@end
