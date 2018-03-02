/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015-2017 Performix LLC. All rights reserved.
 
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

#import <UIKit/UIKit.h>

typedef enum {
    
    AETESelectionTypeFind = 0,
    AETESelectionTypeError
} AETESelectionType;

@class AEUICustomTextEditorController;

/////////////////////////////////////////////////////////////////////
#pragma mark - UITextView (insets)

@interface UITextView (insets)

// Scrolls to visible range, eventually considering insets
- (CGRect)scrollRangeToVisible:(NSRange)range animated:(BOOL)animated;

// Returns visible rect, eventually considering insets
- (CGRect)visibleRectConsideringInsets;

- (UITextRange *)textRangeFromNSRange:(NSRange)range;

@end

/////////////////////////////////////////////////////////////////////
#pragma mark - AEUICustomTextEditorControllerDelegate Protocol

@protocol AEUICustomTextEditorControllerDelegate <NSObject>

@optional
- (void)editorDidLoad:(AEUICustomTextEditorController *)editor;
- (void)editorDidAppear:(AEUICustomTextEditorController *)editor;
- (void)editor:(AEUICustomTextEditorController *)editor toggleInvertedSwitchOn:(BOOL) on;

@end

/////////////////////////////////////////////////////////////////////
#pragma mark - AEUICustomTextEditorController

@interface AEUICustomTextEditorController  : UIViewController <UITextViewDelegate, UISearchBarDelegate, NSTextStorageDelegate>

/**
 Default paragraph style suitable for list of rules or domains.
 */
@property (readonly, class) NSParagraphStyle *defaultParagraph;
/**
 Default text attributes (for NSAttributedString) suitable for list of rules or domains.
 */
@property (readonly, class) NSDictionary *defaultTextAttributes;


/**
 Property for storing auxiliary object, 
 which may make control or hold state, if need it.
 */
@property (strong) id auxiliaryObject;

@property (weak, nonatomic) id<AEUICustomTextEditorControllerDelegate> delegate;

/**
 Block of the code, which will be performed when user press the Done key.
 */
@property (nonatomic, copy) BOOL (^done)(AEUICustomTextEditorController *editor, NSString *text);
/**
 Block of the code, which will be performed when user change the text in editor text view.
 */
@property (nonatomic, copy) BOOL (^replaceText)(NSString *text, UITextView *textView, NSRange range);

/**
 Set this property for changing keyboard type to other than default. 
 */
@property (nonatomic) UIKeyboardType    keyboardType;
/**
 Initial text, which will be edited.
 */
@property (nonatomic) NSString *textForEditing;
/**
 Initial attributed text, which will be edited.
 This property has priority above `textForEditing`.
 */
@property (nonatomic) NSAttributedString *attributedTextForEditing;
/**
 Text for placeholder, ie when textview is empty.
 */
@property (nonatomic) NSAttributedString *attributedTextForPlaceholder;
/**
 show/hide filter rules button
 default NO;
 */
@property (nonatomic) BOOL showFilterRules;

/**
 Performs visual selection of the text in editor view if it will find.

 @return Returns YES if text was found and selection was performed.
 */
- (BOOL)selectWithType:(AETESelectionType)selectionType text:(NSString *)text;
/**
 Sets loading status

 @param loading If YES, then loading indicatior is activated.
 */
- (void)setLoadingStatus:(BOOL)loading;

/////////////////////////////////////////////////////////////////////
#pragma mark Outlets

@property (weak, nonatomic) IBOutlet UIView *searchToolBar;
@property (weak, nonatomic) IBOutlet UITextView *editorTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivity;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearAllButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rulesButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *prevButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

/////////////////////////////////////////////////////////////////////
#pragma mark Actions

- (IBAction)clickDone:(id)sender;
- (IBAction)clickSearchNext:(id)sender;
- (IBAction)clickSearchPrev:(id)sender;
- (IBAction)clickClearAll:(id)sender;

@end
