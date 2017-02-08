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


#import "APUIDomainListController.h"
#import "ACommons/ACLang.h"
#import "ACommons/ACSystem.h"
#import "APVPNManager.h"

#define TOP_BOUNSE_LIMIT                    -5
#define SEARCH_BAR_BUTTONS_SIZE             95.0f
#define WIDTH_CHANGE_KEY                    @"frame"


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
#pragma mark - APUIDomainListController

@implementation APUIDomainListController {
    
    BOOL _searchBarHidden;
    BOOL _keyboardHidden;
    CGFloat _searchBarTopConstraintValue;
    
    NSString *_currentSearchString;
    NSRange _currentTextSelection;
    UIView *_currentSelectionMarker;
    
    id _observer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self registerForKeyboardNotifications];
    [self attachToNotifications];
    
    _searchBarTopConstraintValue = self.seachToolBarConstraint.constant;
    _searchBarHidden = _keyboardHidden = YES;
    _currentTextSelection = NSMakeRange(NSNotFound, 0);

    [self.domainsTextView setText:self.textForEditing];
    
    [self.view addObserver:self forKeyPath:WIDTH_CHANGE_KEY options:(NSKeyValueObservingOptionNew) context:NULL];
    
    // Ebanuty code. This is required for correcting issue with wrong height of the UITextView content.
    [self.domainsTextView sizeToFit];
    [self.domainsTextView setScrollEnabled:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self.domainsTextView setContentOffset:
         CGPointMake(- self.domainsTextView.contentInset.left, - self.domainsTextView.contentInset.top)];
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

/////////////////////////////////////////////////////////////////////
#pragma mark Actions

- (IBAction)clickDone:(id)sender {

//    UIEdgeInsets insets = self.domainsTextView.contentInset;
//    CGPoint offset = self.domainsTextView.contentOffset;
//    CGSize size = self.domainsTextView.contentSize;
//    
//    NSLog(@"Content inset: %@, offset: %@, size: %@", NSStringFromUIEdgeInsets(insets), NSStringFromCGPoint(offset), NSStringFromCGSize(size));
//    return;
    if (self.done(self.domainsTextView.text)) {
        
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

- (void)textViewDidBeginEditing:(UITextView *)textView {

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
                    self.doneButton.enabled = YES;
                }
            }
            return NO;
        }
        
        self.doneButton.enabled = YES;
        return YES;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {


    [self.searchToolBar setNeedsUpdateConstraints];
    [self.searchToolBar setNeedsLayout];

    CGFloat absoluteTopVal = ABS(_searchBarTopConstraintValue);
    CGFloat topValue = _searchBarHidden ? TOP_BOUNSE_LIMIT : _searchBarTopConstraintValue;
    
    if (decelerate) {
        [self.searchBar resignFirstResponder];
    }

    if(scrollView.contentOffset.y < topValue)
    {
        
        _searchBarHidden = NO;
        self.seachToolBarConstraint.constant = 0.0f;
        self.searchBarItem.width = self.view.frame.size.width - SEARCH_BAR_BUTTONS_SIZE;
        [UIView animateWithDuration:0.1 animations:^{
            
            UIEdgeInsets insets = UIEdgeInsetsMake(absoluteTopVal, 0, 0, 0);
            self.domainsTextView.contentInset = insets;
            self.domainsTextView.scrollIndicatorInsets = insets;
            [self.view layoutIfNeeded];
        }];
        [self.searchBar becomeFirstResponder];
        
    } else {

        _searchBarHidden = YES;
        [self.searchBar resignFirstResponder];
        
        self.seachToolBarConstraint.constant = _searchBarTopConstraintValue;
        [UIView animateWithDuration:0.1 animations:^{
            
            UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
            self.domainsTextView.contentInset = insets;
            self.domainsTextView.scrollIndicatorInsets = insets;
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
    self.domainsTextView.contentInset = contentInsets;
    self.domainsTextView.scrollIndicatorInsets = contentInsets;
    
    if ([self.domainsTextView isFirstResponder]) {
        
        [self.domainsTextView scrollRangeToVisible:self.domainsTextView.selectedRange animated:YES];
    }
    else {
        
        [self updateSelectionOnTextView];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    CGFloat topValue = _searchBarHidden ? TOP_BOUNSE_LIMIT : ABS(_searchBarTopConstraintValue);
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(topValue, 0.0, 0.0, 0.0);
    self.domainsTextView.contentInset = contentInsets;
    self.domainsTextView.scrollIndicatorInsets = contentInsets;
}

- (void)selectFirst {

    NSUInteger len = self.domainsTextView.text.length;
    if ([NSString isNullOrEmpty:_currentSearchString] || _currentSearchString.length > len) {
        return;
    }
    _currentTextSelection = [self.domainsTextView.text rangeOfString:_currentSearchString options:NSCaseInsensitiveSearch];
    
    if (_currentTextSelection.location == NSNotFound) {
        return;
    }

    [self updateSelectionOnTextView];
}

- (void)selectNext {
    
    NSUInteger len = self.domainsTextView.text.length;
    if ([NSString isNullOrEmpty:_currentSearchString] || _currentSearchString.length > len) {
        return;
    }
    NSUInteger location = (_currentTextSelection.location == NSNotFound ? 0 : _currentTextSelection.location) + _currentTextSelection.length;
    NSRange searchRange = NSMakeRange(location, len - location);
    
    _currentTextSelection = [self.domainsTextView.text rangeOfString:_currentSearchString options:NSCaseInsensitiveSearch range:searchRange];
    
    if (_currentTextSelection.location == NSNotFound) {
        [self selectFirst];
        return;
    }
    
    [self updateSelectionOnTextView];
}

- (void)selectPrev {
    
    NSUInteger len = self.domainsTextView.text.length;
    if ([NSString isNullOrEmpty:_currentSearchString] || _currentSearchString.length > len) {
        return;
    }
    NSRange searchRange = NSMakeRange(0, (_currentTextSelection.location
                                       && _currentTextSelection.location != NSNotFound)
                                      ? _currentTextSelection.location
                                      : len);
    
    _currentTextSelection = [self.domainsTextView.text rangeOfString:_currentSearchString
                                                             options:(NSCaseInsensitiveSearch | NSBackwardsSearch)
                                                               range:searchRange];
    
    if (_currentTextSelection.location == NSNotFound && searchRange.length < len) {
        searchRange = NSMakeRange(0, len);
        _currentTextSelection = [self.domainsTextView.text rangeOfString:_currentSearchString
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
    
    CGRect rect = [self.domainsTextView scrollRangeToVisible:_currentTextSelection animated:YES];
    
    if (_currentTextSelection.length == 0) {
        _currentSelectionMarker.hidden = YES;
        return;
    }
    
    if (_currentSelectionMarker == nil) {
        
        _currentSelectionMarker = [[UIView alloc] initWithFrame:rect];
        _currentSelectionMarker.backgroundColor = [self.domainsTextView.tintColor colorWithAlphaComponent:0.2f];
        _currentSelectionMarker.layer.cornerRadius = 3.0f;
        _currentSelectionMarker.userInteractionEnabled = NO;
        [self.domainsTextView addSubview:_currentSelectionMarker];
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
