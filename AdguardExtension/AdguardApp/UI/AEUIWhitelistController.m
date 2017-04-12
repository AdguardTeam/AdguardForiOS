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

#import "AEUIWhitelistController.h"
#import "ACommons/ACLang.h"
#import "ASDFilterObjects.h"
#import "AESAntibanner.h"
#import "AEService.h"
#import "AEWhitelistDomainObject.h"
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
    
    domainList.textForPlaceholder = NSLocalizedString(@"Enter the domain names here (separated by spaces, commas or line breaks) which Adguard will disable filtering in Safari for.", @"(AEUIMainController) Main screen -> Safari Content Blocking -> Whitelist. This is the text shown when the whitelist is empty.");
    
    domainList.navigationItem.title = NSLocalizedString(@"Whitelist", @"(AEUIMainController) Main screen -> Safari Content Blocking -> Whitelist. The title of the screen.");
    domainList.keyboardType = UIKeyboardTypeURL;
    
    AEUIWhitelistController *result = [AEUIWhitelistController new];
    
    ASSIGN_WEAK(result);
    domainList.done = ^BOOL(AEUICustomTextEditorController *editor, NSString *text) {
        
        NSMutableArray <ASDFilterRule *> *rules = [NSMutableArray array];

        @autoreleasepool {
            
            NSMutableCharacterSet *delimCharSet;
            
            delimCharSet = [NSMutableCharacterSet newlineCharacterSet];
            [delimCharSet addCharactersInString:@", "];

            for (NSString *item in  [text componentsSeparatedByCharactersInSet:delimCharSet]) {
                
                if (item.length) {
                    AEWhitelistDomainObject *obj = [[AEWhitelistDomainObject alloc] initWithDomain:item];
                    if (obj) {
                        [rules addObject:obj.rule];
                    }
                }
            }
        }
        
        @autoreleasepool {
            
            AESharedResources *res = [AESharedResources new];
            
            NSMutableArray *oldRules = res.whitelistContentBlockingRules;
            
            res.whitelistContentBlockingRules = rules;
            
            [AEUIUtils invalidateJsonWithController:editor completionBlock:^{
                
                //Success
                ASSIGN_STRONG(result);
                
                [editor setLoadingStatus:YES];
                [USE_STRONG(result) reloadUserFilterDataForEditorController:editor];
                
            } rollbackBlock:^{
                
                //Failure
                res.whitelistContentBlockingRules = oldRules;
                
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
    
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                       @autoreleasepool {
                      
                           //create attributed text with all rules
                           NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]
                                                                        initWithString:@""
                                                                        attributes:AEUICustomTextEditorController.defaultTextAttributes];
                           
                           AESharedResources *resources = [AESharedResources new];
                           
                           NSMutableArray *rules = resources.whitelistContentBlockingRules;
                           
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
                           
                           dispatch_async(dispatch_get_main_queue(), ^{
                               
                                   // assign attributed text with all rules
                                   editor.attributedTextForEditing = attributedText;
                           });
                       }
                   });
    
}

@end

