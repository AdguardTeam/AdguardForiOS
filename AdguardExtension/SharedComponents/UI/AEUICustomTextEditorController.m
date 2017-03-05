/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015-2016 Performix LLC. All rights reserved.
 
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


#import "AEUICustomTextEditorController.h"
#import "ACommons/ACLang.h"
#import "ACommons/ACSystem.h"
#import "APVPNManager.h"

#define TOP_BOUNSE_LIMIT                    -5
#define SEARCH_BAR_BUTTONS_SIZE             95.0f
#define WIDTH_CHANGE_KEY                    @"frame"

#define EDITED_TEXT_FONT                    [UIFont systemFontOfSize:[UIFont systemFontSize]]
#define EDITED_TEXT_COLOR                   [UIColor blackColor]

/////////////////////////////////////////////////////////////////////
#pragma mark - AEUITextStorage

@interface AEUITextStorage : NSTextStorage
@end

@implementation AEUITextStorage{
    NSMutableAttributedString *_imp;
    NSDictionary *_editAttrs;
}

- (id)init {
    self = [super init];
    
    if (self) {
        _imp = [NSMutableAttributedString new];
        _editAttrs = @{
                       NSFontAttributeName: EDITED_TEXT_FONT,
                       NSForegroundColorAttributeName: EDITED_TEXT_COLOR
                       };
    }
    
    return self;
}


- (NSString *)string{
    
    return _imp.string;
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range{
    return [_imp attributesAtIndex:location effectiveRange:range];
}


- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str {
    [_imp replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters range:range changeInLength:(NSInteger)str.length - (NSInteger)range.length];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range {
    [_imp setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
}

- (void)processEditing
{
    NSRange paragaphRange = [self.string paragraphRangeForRange: self.editedRange];
    [self setAttributes:_editAttrs range:paragaphRange];
    
    [super processEditing];
}



@end

/////////////////////////////////////////////////////////////////////
#pragma mark - UITextView (insets)

@interface UITextView (insets)

// Scrolls to visible range, eventually considering insets
- (CGRect)scrollRangeToVisible:(NSRange)range animated:(BOOL)animated;

// Returns visible rect, eventually considering insets
- (CGRect)visibleRectConsideringInsets;

- (UITextRange *)textRangeFromNSRange:(NSRange)range;

@end

@implementation UITextView (insets)

// Scrolls to visible range, eventually considering insets
- (CGRect)scrollRangeToVisible:(NSRange)range animated:(BOOL)animated{
    // Calculates rect for range
    UITextRange *textRange = [self textRangeFromNSRange:range];
    CGRect rect = [self firstRectForRange:textRange];
    
    rect.size.width = rect.size.width ?: 5.0f;
    rect.size.height = rect.size.height ?: 5.0f;
    
    // Scrolls to visible rect
    // Gets bounds and calculates visible rect
    CGRect visibleRect = [self visibleRectConsideringInsets];
    
    // Do not scroll if rect is on screen
    if (!CGRectContainsRect(visibleRect, rect))
    {
        [self scrollRectToVisible:rect animated:animated];
    }
    
    return rect;
}

// Returns visible rect, eventually considering insets
- (CGRect)visibleRectConsideringInsets
{
    UIEdgeInsets contentInset = self.contentInset;
    CGRect visibleRect = self.bounds;
    visibleRect.origin.x += contentInset.left;
    visibleRect.origin.y += contentInset.top;
    visibleRect.size.width -= (contentInset.left + contentInset.right);
    visibleRect.size.height -= (contentInset.top + contentInset.bottom);
    return visibleRect;
}

- (UITextRange *)textRangeFromNSRange:(NSRange)range {
    
    UITextPosition *startPosition = [self positionFromPosition:self.beginningOfDocument offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:startPosition offset:range.length];
    return [self textRangeFromPosition:startPosition toPosition:endPosition];
}

@end

/////////////////////////////////////////////////////////////////////
#pragma mark - AEUICustomTextEditorController

@implementation AEUICustomTextEditorController {
    
    BOOL _searchBarHidden;
    BOOL _keyboardHidden;
    CGFloat _searchBarTopConstraintValue;
    
    NSString *_currentSearchString;
    NSRange _currentTextSelection;
    UIView *_currentSelectionMarker;
    
    id _observer;
    
    NSString *_textForEditing;
    NSAttributedString *_attributedTextForEditing;
    
    NSDictionary *_editAttrs;
    BOOL _editting;
//    AEUITextStorage *_textStorage;
//    NSLayoutManager *_layoutManager;
}

- (void)viewDidLoad {
    
//    NSTextStorage *originStorage = self.editorTextView.textStorage;
//    [originStorage removeLayoutManager:self.editorTextView.layoutManager];
//    
//    _textStorage = [AEUITextStorage new];
//    [_textStorage addLayoutManager:self.editorTextView.layoutManager];
//    
//    self.editorTextView.layoutManager.textStorage = _textStorage;
//    [self.editorTextView.textContainer replaceLayoutManager:_layoutManager];
    
    [super viewDidLoad];
    
    _editting = NO;
    _editAttrs = @{
                   NSFontAttributeName: EDITED_TEXT_FONT,
                   NSForegroundColorAttributeName: EDITED_TEXT_COLOR
                   };

    self.editorTextView.textStorage.delegate = self;
    
    [self registerForKeyboardNotifications];
    [self attachToNotifications];

    
    _searchBarTopConstraintValue = self.seachToolBarConstraint.constant;
    _searchBarHidden = _keyboardHidden = YES;
    _currentTextSelection = NSMakeRange(NSNotFound, 0);

    self.placeholderLabel.text = self.textForPlaceholder;
    
    [self.view addObserver:self forKeyPath:WIDTH_CHANGE_KEY options:(NSKeyValueObservingOptionNew) context:NULL];
    
    // tunning accessibility
    self.editorTextView.accessibilityHint = self.textForPlaceholder;
    self.placeholderLabel.isAccessibilityElement = NO;
    if (UIAccessibilityIsVoiceOverRunning()) {
        [self scrollViewDidEndDragging:self.editorTextView willDecelerate:NO];
    }
    //---
 
    [self resetText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [self.view removeObserver:self forKeyPath:WIDTH_CHANGE_KEY];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (_observer) {
        [[NSNotificationCenter defaultCenter] removeObserver:_observer];
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark Public Methods

- (NSString *)textForEditing {
    return _textForEditing;
}
- (void)setTextForEditing:(NSString *)textForEditing {
    
    _textForEditing = textForEditing;
    [self resetText];
}

- (NSAttributedString *)attributedTextForEditing {
    return _attributedTextForEditing;
}
- (void)setAttributedTextForEditing:(NSAttributedString *)attributedTextForEditing {
    
    _attributedTextForEditing = attributedTextForEditing;
    [self resetText];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Actions

- (IBAction)clickDone:(id)sender {

//    UIEdgeInsets insets = self.editorTextView.contentInset;
//    CGPoint offset = self.editorTextView.contentOffset;
//    CGSize size = self.editorTextView.contentSize;
//    
//    NSLog(@"Content inset: %@, offset: %@, size: %@", NSStringFromUIEdgeInsets(insets), NSStringFromCGPoint(offset), NSStringFromCGSize(size));
//    return;
    if (self.done(self, self.editorTextView.text)) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)clickSearchNext:(id)sender {
    
    [self selectNext];
}

- (IBAction)clickSearchPrev:(id)sender {
    
    [self selectPrev];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Delegate Methods

- (void)textStorage:(NSTextStorage *)textStorage
  didProcessEditing:(NSTextStorageEditActions)editedMask
              range:(NSRange)editedRange
     changeInLength:(NSInteger)delta {
    
    if (_editting) {
        [textStorage setAttributes:_editAttrs range:editedRange];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {

    _editting = YES;
    _currentTextSelection = NSMakeRange(NSNotFound, 0);
    _currentSelectionMarker.hidden = YES;
}

// For supporting of the URL insertion and enabling of the Done button.
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    @autoreleasepool {
        
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
    }
}

- (void)textViewDidChange:(UITextView *)textView{

    self.doneButton.enabled = YES;
    self.placeholderLabel.hidden = ! [NSString isNullOrEmpty:textView.text];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {


    [self.searchToolBar setNeedsUpdateConstraints];
    [self.searchToolBar setNeedsLayout];

    CGFloat absoluteTopVal = ABS(_searchBarTopConstraintValue);
    CGFloat topValue = _searchBarHidden ? TOP_BOUNSE_LIMIT : _searchBarTopConstraintValue;
    
    if (decelerate) {
        [self.searchBar resignFirstResponder];
    }

    if(scrollView.contentOffset.y < topValue || UIAccessibilityIsVoiceOverRunning())
    {
        
        _searchBarHidden = NO;
        self.seachToolBarConstraint.constant = 0.0f;
        self.searchBarItem.width = self.view.frame.size.width - SEARCH_BAR_BUTTONS_SIZE;
        [UIView animateWithDuration:0.1 animations:^{
            
            UIEdgeInsets insets = UIEdgeInsetsMake(absoluteTopVal, 0, 0, 0);
            self.editorTextView.contentInset = insets;
            self.editorTextView.scrollIndicatorInsets = insets;
            [self.view layoutIfNeeded];
        }];
        
        if (! UIAccessibilityIsVoiceOverRunning()) {
            [self.searchBar becomeFirstResponder];
        }
        
    } else {

        _searchBarHidden = YES;
        [self.searchBar resignFirstResponder];
        
        self.seachToolBarConstraint.constant = _searchBarTopConstraintValue;
        [UIView animateWithDuration:0.1 animations:^{
            
            UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
            self.editorTextView.contentInset = insets;
            self.editorTextView.scrollIndicatorInsets = insets;
            [self.view layoutIfNeeded];
        }];
        
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    _currentSearchString = searchBar.text;
    [self selectFirst];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    _currentSearchString = searchBar.text;
}


/////////////////////////////////////////////////////////////////////
#pragma mark Observing values

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

    if (object == self.view && [keyPath isEqualToString:WIDTH_CHANGE_KEY]) {
        self.searchBarItem.width = self.view.frame.size.width - SEARCH_BAR_BUTTONS_SIZE;
        [self.searchToolBar setNeedsLayout];
        
        return;
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Helper Methods (Private)

- (void)resetText {
    
    if (self.editorTextView == nil) {
        return;
    }
    
    _editting = NO;
    
    NSString *checkString;
    
    if (self.attributedTextForEditing) {
        
        [self.editorTextView setAttributedText:self.attributedTextForEditing];
        checkString = self.attributedTextForEditing.string;
    }
    else {
        
        [self.editorTextView setText:self.textForEditing];
        checkString = self.textForEditing;
    }
    
    if ([NSString isNullOrEmpty:checkString]) {
        
        self.placeholderLabel.hidden = NO;
    }
    else {
        self.placeholderLabel.hidden = YES;
        
        // Ebanuty code. This is required for correcting issue with wrong height of the UITextView content.
        [self.editorTextView sizeToFit];
        [self.editorTextView setScrollEnabled:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.editorTextView setContentOffset:
             CGPointMake(- self.editorTextView.contentInset.left, - self.editorTextView.contentInset.top)];
        });
    }
    
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGFloat topValue = _searchBarHidden ? TOP_BOUNSE_LIMIT : ABS(_searchBarTopConstraintValue);
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(topValue, 0.0, kbSize.height, 0.0);
    self.editorTextView.contentInset = contentInsets;
    self.editorTextView.scrollIndicatorInsets = contentInsets;
    
    if ([self.editorTextView isFirstResponder]) {
        
        [self.editorTextView scrollRangeToVisible:self.editorTextView.selectedRange animated:YES];
    }
    else {
        
        [self updateSelectionOnTextView];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    CGFloat topValue = _searchBarHidden ? TOP_BOUNSE_LIMIT : ABS(_searchBarTopConstraintValue);
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(topValue, 0.0, 0.0, 0.0);
    self.editorTextView.contentInset = contentInsets;
    self.editorTextView.scrollIndicatorInsets = contentInsets;
}

- (void)selectFirst {

    NSUInteger len = self.editorTextView.text.length;
    if ([NSString isNullOrEmpty:_currentSearchString] || _currentSearchString.length > len) {
        return;
    }
    _currentTextSelection = [self.editorTextView.text rangeOfString:_currentSearchString options:NSCaseInsensitiveSearch];
    
    if (_currentTextSelection.location == NSNotFound) {
        return;
    }

    [self updateSelectionOnTextView];
}

- (void)selectNext {
    
    NSUInteger len = self.editorTextView.text.length;
    if ([NSString isNullOrEmpty:_currentSearchString] || _currentSearchString.length > len) {
        return;
    }
    NSUInteger location = (_currentTextSelection.location == NSNotFound ? 0 : _currentTextSelection.location) + _currentTextSelection.length;
    NSRange searchRange = NSMakeRange(location, len - location);
    
    _currentTextSelection = [self.editorTextView.text rangeOfString:_currentSearchString options:NSCaseInsensitiveSearch range:searchRange];
    
    if (_currentTextSelection.location == NSNotFound) {
        [self selectFirst];
        return;
    }
    
    [self updateSelectionOnTextView];
}

- (void)selectPrev {
    
    NSUInteger len = self.editorTextView.text.length;
    if ([NSString isNullOrEmpty:_currentSearchString] || _currentSearchString.length > len) {
        return;
    }
    NSRange searchRange = NSMakeRange(0, (_currentTextSelection.location
                                       && _currentTextSelection.location != NSNotFound)
                                      ? _currentTextSelection.location
                                      : len);
    
    _currentTextSelection = [self.editorTextView.text rangeOfString:_currentSearchString
                                                             options:(NSCaseInsensitiveSearch | NSBackwardsSearch)
                                                               range:searchRange];
    
    if (_currentTextSelection.location == NSNotFound && searchRange.length < len) {
        searchRange = NSMakeRange(0, len);
        _currentTextSelection = [self.editorTextView.text rangeOfString:_currentSearchString
                                                                 options:(NSCaseInsensitiveSearch | NSBackwardsSearch)
                                                                   range:searchRange];
        if (_currentTextSelection.location == NSNotFound) {
            
            return;
        }
    }
    
    [self updateSelectionOnTextView];
}

- (void)updateSelectionOnTextView {
    
    if (_currentTextSelection.location == NSNotFound) {
        _currentSelectionMarker.hidden = YES;
        return;
    }
    
    CGRect rect = [self.editorTextView scrollRangeToVisible:_currentTextSelection animated:YES];
    
    if (_currentTextSelection.length == 0) {
        _currentSelectionMarker.hidden = YES;
        return;
    }
    
    if (_currentSelectionMarker == nil) {
        
        _currentSelectionMarker = [[UIView alloc] initWithFrame:rect];
        _currentSelectionMarker.backgroundColor = [self.editorTextView.tintColor colorWithAlphaComponent:0.2f];
        _currentSelectionMarker.layer.cornerRadius = 3.0f;
        _currentSelectionMarker.userInteractionEnabled = NO;
        [self.editorTextView addSubview:_currentSelectionMarker];
    }
    else {
        [_currentSelectionMarker setFrame:rect];
    }
    _currentSelectionMarker.hidden = NO;
}

- (void)attachToNotifications{
    
    _observer = [[NSNotificationCenter defaultCenter]
                 addObserverForName:APVpnChangedNotification
                 object: nil
                 queue:nil
                 usingBlock:^(NSNotification *_Nonnull note) {
                     
                     // When configuration is changed
                     
                     [self updateStatuses];
                 }];
}

- (void)updateStatuses{
    APVPNManager *manager = [APVPNManager singleton];
    
    if (manager.lastError) {
        [ACSSystemUtils
         showSimpleAlertForController:self
         withTitle:NSLocalizedString(@"Error",
                                     @"(APUIAdguardDNSCon"
                                     @"troller) PRO "
                                     @"version. Alert "
                                     @"title. On error.")
         message:manager.lastError.localizedDescription];
    }
}

@end
