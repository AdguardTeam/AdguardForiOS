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

#define TOP_BOUNSE_LIMIT                    -5
#define SEARCH_BAR_BUTTONS_SIZE             95.0f
#define WIDTH_CHANGE_KEY                    @"frame"

#define EDITED_TEXT_FONT                    [UIFont systemFontOfSize:[UIFont systemFontSize]]
#define EDITED_TEXT_COLOR                   [UIColor blackColor]
#define SELECTION_COLOR_FIND                [self.editorTextView.tintColor colorWithAlphaComponent:0.2f]
#define SELECTION_COLOR_ERROR               [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.2f]

#define FILTER_RULE_SYNTAX_LINK             @"https://kb.adguard.com/general/how-to-create-your-own-ad-filters"

/////////////////////////////////////////////////////////////////////
#pragma mark - UITextView (insets)

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
    
    BOOL _keyboardHidden;
    
    NSString *_currentSearchString;
    
    AETESelectionType _currentSelectionType;
    NSRange _currentTextSelection;
    NSArray <UIView *> *_currentSelectionMarkers;
    
    id _observer;
    
    NSString *_textForEditing;
    NSAttributedString *_attributedTextForEditing;
    
    BOOL _editting;
    BOOL _loadingStatusHandler;
    
    UIKeyboardType _keyboardType;
}

static NSMutableParagraphStyle *_defaultParagraph;
static NSDictionary *_editAttrs;

+ (void)initialize {
    
    if (self == [AEUICustomTextEditorController class]) {
        _defaultParagraph = [NSMutableParagraphStyle new];
        [_defaultParagraph setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
        _defaultParagraph.firstLineHeadIndent = 0.0f;
        _defaultParagraph.headIndent = 10.0f;
        //        _defaultParagraph.paragraphSpacing = 3.0f;
        
        _editAttrs = @{
                       NSFontAttributeName: EDITED_TEXT_FONT,
                       NSForegroundColorAttributeName: EDITED_TEXT_COLOR,
                       NSParagraphStyleAttributeName: _defaultParagraph
                       };
    }
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _loadingStatusHandler = NO;
        _keyboardType = UIKeyboardTypeDefault;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setLoadingStatus:_loadingStatusHandler];
    [self setShowFilterRules:_showFilterRules];
    
    _editting = NO;

    self.editorTextView.font = EDITED_TEXT_FONT;
    self.editorTextView.textStorage.delegate = self;
    self.editorTextView.keyboardType = _keyboardType;
    
    [self registerForKeyboardNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];

    
    _keyboardHidden = YES;
    _currentSelectionType = AETESelectionTypeFind;
    _currentTextSelection = NSMakeRange(NSNotFound, 0);

    self.placeholderLabel.text = self.textForPlaceholder;
    
    [self.view addObserver:self forKeyPath:WIDTH_CHANGE_KEY options:(NSKeyValueObservingOptionNew) context:NULL];
    
    // tunning accessibility
    self.editorTextView.accessibilityHint = self.textForPlaceholder;
    self.placeholderLabel.isAccessibilityElement = NO;
    
    if (UIAccessibilityIsVoiceOverRunning()) {
        //turns off search functionality
        self.searchToolBar.hidden = YES;
    }
    //---
    
    [self resetTextWithSizeToFit:YES];
    
    ASSIGN_WEAK(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        ASSIGN_STRONG(self);
        if (USE_STRONG(self).delegate && [USE_STRONG(self).delegate respondsToSelector:@selector(editorDidLoad:)]) {
            
            [USE_STRONG(self).delegate editorDidLoad:USE_STRONG(self)];
        }
    });
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

+ (NSParagraphStyle *)defaultParagraph {
    
    return _defaultParagraph;
}

+ (NSDictionary *)defaultTextAttributes {
    
    return _editAttrs;
}


/////////////////////////////////////////////////////////////////////
#pragma mark Public Methods

- (void)setLoadingStatus:(BOOL)loading {
    
    _loadingStatusHandler = loading;
    
    if (loading) {
        [self.loadingActivity startAnimating];
    }
    else {
        [self.loadingActivity stopAnimating];
    }
    self.editorTextView.editable = ! loading;
    self.editorTextView.hidden = loading;
    
    [self setControlsByLoadingAndTextExists];
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    
    _keyboardType = keyboardType;
    
    self.editorTextView.keyboardType = _keyboardType;
}

- (UIKeyboardType)keyboardType {
    
    return _keyboardType;
}

- (NSString *)textForEditing {
    return _textForEditing;
}
- (void)setTextForEditing:(NSString *)textForEditing {
    
    _textForEditing = textForEditing;
    [self resetTextWithSizeToFit:NO];
    [self setLoadingStatus:NO];
}

- (NSAttributedString *)attributedTextForEditing {
    return _attributedTextForEditing;
}
- (void)setAttributedTextForEditing:(NSAttributedString *)attributedTextForEditing {
    
    _attributedTextForEditing = attributedTextForEditing;
    [self resetTextWithSizeToFit:NO];
    [self setLoadingStatus:NO];
}

- (BOOL)selectWithType:(AETESelectionType)selectionType text:(NSString *)text {
    
    _currentSearchString = text;
    _currentTextSelection = NSMakeRange(NSNotFound, 0);
    _currentSelectionType = selectionType;
    [self updateSelectionOnTextView];
    
    NSUInteger len = self.editorTextView.text.length;
    if ([NSString isNullOrEmpty:text] || text.length > len) {
        return NO;
    }
    
    
    
    _currentTextSelection = [self.editorTextView.text rangeOfString:_currentSearchString options:NSCaseInsensitiveSearch];
    
    if (_currentTextSelection.location == NSNotFound) {
        return NO;
    }
    
    
    [self updateSelectionOnTextView];

    return YES;
}

- (void)setShowFilterRules:(BOOL)showFilterRules {
    _showFilterRules = showFilterRules;
    
    if(self.showFilterRules){
        self.rulesButton.enabled = YES;
        self.rulesButton.tintColor = nil;
    }
    else {
        self.rulesButton.enabled = NO;
        self.rulesButton.tintColor = [UIColor clearColor];
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark Actions

- (IBAction)clickDone:(id)sender {

    self.doneButton.enabled = NO;
    
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

- (IBAction)clickClearAll:(id)sender {
    
    _textForEditing = nil;
    _attributedTextForEditing = nil;
    [self resetTextWithSizeToFit:NO];
    //
    [self textViewDidChange:self.editorTextView];
}

- (IBAction)clickRules:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:FILTER_RULE_SYNTAX_LINK]];
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
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    _editting = NO;
}

// For supporting of the URL insertion.
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    @autoreleasepool {
        
        [textView setScrollEnabled:YES];
        
        if (self.replaceText) {
            return self.replaceText(text, textView, range);
        }
        
        return YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView{

    self.doneButton.enabled = YES;
    [self hideSelectionMarkers];
    [self setControlsByLoadingAndTextExists];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self selectWithType:AETESelectionTypeFind text:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    _currentSearchString = searchBar.text;
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    
    [self hideSelectionMarkers];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // tunning accessibility
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification,
                                    self.editorTextView);
    //-------------
    
    ASSIGN_WEAK(self);
    dispatch_async(dispatch_get_main_queue(), ^{

        ASSIGN_STRONG(self);
        if (USE_STRONG(self).delegate && [USE_STRONG(self).delegate respondsToSelector:@selector(editorDidAppear:)]) {
            [USE_STRONG(self).delegate editorDidAppear:USE_STRONG(self)];
        }
    });
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

- (void)resetTextWithSizeToFit:(BOOL)sizeToFit {
    
    if (self.editorTextView == nil) {
        return;
    }
    
    _editting = NO;
    self.doneButton.enabled = NO;
    
    NSString *checkString;
    
    CGPoint offset = CGPointMake(- self.editorTextView.contentInset.left, - self.editorTextView.contentInset.top);
    
    if (! CGPointEqualToPoint(offset, self.editorTextView.contentOffset)) {
        
        offset = self.editorTextView.contentOffset;
    }
    
    if (self.attributedTextForEditing) {
        
        [self.editorTextView setAttributedText:self.attributedTextForEditing];
        checkString = self.attributedTextForEditing.string;
    }
    else {
        
        [self.editorTextView setText:self.textForEditing];
        checkString = self.textForEditing;
    }
    
    [self setControlsByLoadingAndTextExists];
    
    if (![NSString isNullOrEmpty:checkString]) {
        
        // Ebanuty code. This is required for correcting issue with wrong height of the UITextView content.
        if (sizeToFit) {
            [self.editorTextView sizeToFit];
        }
        [self.editorTextView setScrollEnabled:YES];
        //------
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.editorTextView setContentOffset:offset];
        });
    }
    
}

- (void)setControlsByLoadingAndTextExists {
    
    if (_loadingStatusHandler) {
        
        self.placeholderLabel.hidden = YES;
        self.clearAllButton.enabled = NO;
        self.searchBarItem.enabled = NO;
        self.searchBarNext.enabled = NO;
        self.searchBarPrevious.enabled = NO;
        
        return;
    }
    
    BOOL result = ! [NSString isNullOrEmpty:self.editorTextView.text];
    self.placeholderLabel.hidden = result;
    self.clearAllButton.enabled = result;
    self.searchBarItem.enabled = result;
    self.searchBarNext.enabled = result;
    self.searchBarPrevious.enabled = result;
    
    if (!result) {
        
        self.searchBar.text = nil;
        _currentSearchString = nil;

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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.editorTextView.contentInset = contentInsets;
    self.editorTextView.scrollIndicatorInsets = contentInsets;
    
    if ([self.editorTextView isFirstResponder]) {
        
        [self.editorTextView scrollRangeToVisible:self.editorTextView.selectedRange animated:YES];
    }
    else {
        
//        [self updateSelectionOnTextView];
    }
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
 
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.editorTextView.contentInset = contentInsets;
    self.editorTextView.scrollIndicatorInsets = contentInsets;
  
}

- (void)appDidBecomeActive:(NSNotification *)aNotification {
    
    ASSIGN_WEAK(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        ASSIGN_STRONG(self);
        if (USE_STRONG(self).delegate && [USE_STRONG(self).delegate respondsToSelector:@selector(editorDidAppear:)]) {
            [USE_STRONG(self).delegate editorDidAppear:USE_STRONG(self)];
        }
    });

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
        [self selectWithType:AETESelectionTypeFind text:_currentSearchString];
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
        [self hideSelectionMarkers];
        return;
    }
    
    if (_currentTextSelection.length == 0) {
        [self hideSelectionMarkers];
        return;
    }
    
    self.editorTextView.selectedRange = NSMakeRange(_currentTextSelection.location + _currentTextSelection.length, 0);
    
    [self.editorTextView scrollRangeToVisible:_currentTextSelection animated:YES];

    // tunning accessibility
    if (UIAccessibilityIsVoiceOverRunning()) {

        [self.editorTextView becomeFirstResponder];
        return;
    }
    //--------
    
    NSArray <UITextSelectionRect *> *textRects = [self.editorTextView
                         selectionRectsForRange:[self.editorTextView textRangeFromNSRange:_currentTextSelection]];
    
    
    if (_currentSelectionMarkers == nil) {
        
        _currentSelectionMarkers = @[
                                     [[UIView alloc] initWithFrame:CGRectZero],
                                     [[UIView alloc] initWithFrame:CGRectZero],
                                     [[UIView alloc] initWithFrame:CGRectZero]
                                     ];
        for (UIView *markerView in _currentSelectionMarkers) {
            
            markerView.layer.cornerRadius = 3.0f;
            markerView.userInteractionEnabled = NO;
            [self.editorTextView addSubview:markerView];
        }
    }
    
    for (NSInteger i=0; i < _currentSelectionMarkers.count; i++) {
        if (textRects.count > i) {
            
            UIView *_currentSelectionMarker = _currentSelectionMarkers[i];
            [_currentSelectionMarker setFrame:textRects[i].rect];
            switch (_currentSelectionType) {
                case AETESelectionTypeError:
                    _currentSelectionMarker.backgroundColor = SELECTION_COLOR_ERROR;
                    break;
                    
                default:
                    _currentSelectionMarker.backgroundColor = SELECTION_COLOR_FIND;
                    break;
            }
            _currentSelectionMarker.hidden = NO;
        }
        else {
            _currentSelectionMarkers[i].hidden = YES;
        }
    }
}

- (void)hideSelectionMarkers {
    
    [_currentSelectionMarkers setValue:@(YES) forKey:@"hidden"];
}
@end
