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

#define TOP_BOUNSE_LIMIT                    -5
#define SEARCH_BAR_BUTTONS_SIZE             95.0f
#define WIDTH_CHANGE_KEY                    @"frame"


@interface UITextView (insets)

// Scrolls to visible range, eventually considering insets
- (void)scrollRangeToVisible:(NSRange)range consideringInsets:(BOOL)considerInsets;

// Scrolls to visible rect, eventually considering insets
- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated consideringInsets:(BOOL)considerInsets;

// Returns visible rect, eventually considering insets
- (CGRect)visibleRectConsideringInsets:(BOOL)considerInsets;

@end

@implementation UITextView (insets)

// Scrolls to visible range, eventually considering insets
- (void)scrollRangeToVisible:(NSRange)range consideringInsets:(BOOL)considerInsets
{
    if (considerInsets && (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1))
    {
        // Calculates rect for range
        UITextPosition *startPosition = [self positionFromPosition:self.beginningOfDocument offset:range.location];
        UITextPosition *endPosition = [self positionFromPosition:startPosition offset:range.length];
        UITextRange *textRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
        CGRect rect = [self firstRectForRange:textRange];
        
        // Scrolls to visible rect
        [self scrollRectToVisible:rect animated:YES consideringInsets:YES];
    }
    else
        [self scrollRangeToVisible:range];
}

// Scrolls to visible rect, eventually considering insets
- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated consideringInsets:(BOOL)considerInsets
{
    if (considerInsets && (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1))
    {
        // Gets bounds and calculates visible rect
        CGRect bounds = self.bounds;
        UIEdgeInsets contentInset = self.contentInset;
        CGRect visibleRect = [self visibleRectConsideringInsets:YES];
        
        // Do not scroll if rect is on screen
        if (!CGRectContainsRect(visibleRect, rect))
        {
            CGPoint contentOffset = self.contentOffset;
            // Calculates new contentOffset
            if (rect.origin.y < visibleRect.origin.y)
                // rect precedes bounds, scroll up
                contentOffset.y = rect.origin.y - contentInset.top;
            else
                // rect follows bounds, scroll down
                contentOffset.y = rect.origin.y + contentInset.bottom + rect.size.height - bounds.size.height;
            [self setContentOffset:contentOffset animated:animated];
        }
    }
    else
        [self scrollRectToVisible:rect animated:animated];
}

// Returns visible rect, eventually considering insets
- (CGRect)visibleRectConsideringInsets:(BOOL)considerInsets
{
    CGRect bounds = self.bounds;
    if (considerInsets)
    {
        UIEdgeInsets contentInset = self.contentInset;
        CGRect visibleRect = self.bounds;
        visibleRect.origin.x += contentInset.left;
        visibleRect.origin.y += contentInset.top;
        visibleRect.size.width -= (contentInset.left + contentInset.right);
        visibleRect.size.height -= (contentInset.top + contentInset.bottom);
        return visibleRect;
    }
    return bounds;
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardDidChangeFrameWithNotification:)
     name:UIKeyboardDidChangeFrameNotification
     object:nil];
    
    _searchBarTopConstraintValue = self.seachToolBarConstraint.constant;
    _searchBarHidden = _keyboardHidden = YES;
    _currentTextSelection = NSMakeRange(0, 0);

    self.domainsTextView.text = self.textForEditing;
    
    [self.view addObserver:self forKeyPath:WIDTH_CHANGE_KEY options:(NSKeyValueObservingOptionNew) context:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [self.view removeObserver:self forKeyPath:WIDTH_CHANGE_KEY];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Actions

- (IBAction)clickDone:(id)sender {

    UIEdgeInsets insets = self.domainsTextView.contentInset;
    return;
    self.done(self.domainsTextView.text);
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickSearchNext:(id)sender {
    
    [self selectNext];
}

- (IBAction)clickSearchPrev:(id)sender {
    
    [self selectPrev];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Delegate Methods

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

- (void)keyboardDidChangeFrameWithNotification:(NSNotification *)notification {
    
    CGRect rect = [self.domainsTextView convertRect:[notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    CGFloat keyboardHeight = rect.size.height;
    
    BOOL keyboardHidden = (keyboardHeight == 0);
    
    if (keyboardHidden == _keyboardHidden) {
        return;
    }
    
    NSLog(@"asfdasdasdasd: %f", keyboardHeight);

    _keyboardHidden = keyboardHidden;
    
    CGFloat topVal = _searchBarHidden ? 0.0 :ABS(_searchBarTopConstraintValue);

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(topVal, 0.0, keyboardHeight, 0.0);
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
        _currentTextSelection = NSMakeRange(0, 0);
        return;
    }

    [self updateSelectionOnTextView];
}

- (void)selectNext {
    
    NSUInteger len = self.domainsTextView.text.length;
    if ([NSString isNullOrEmpty:_currentSearchString] || _currentSearchString.length > len) {
        return;
    }
    NSUInteger location = _currentTextSelection.location + _currentTextSelection.length;
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
    NSRange searchRange = NSMakeRange(0, _currentTextSelection.location ?: len);
    
    _currentTextSelection = [self.domainsTextView.text rangeOfString:_currentSearchString
                                                             options:(NSCaseInsensitiveSearch | NSBackwardsSearch)
                                                               range:searchRange];
    
    if (_currentTextSelection.location == NSNotFound && searchRange.length < len) {
        searchRange = NSMakeRange(0, len);
        _currentTextSelection = [self.domainsTextView.text rangeOfString:_currentSearchString
                                                                 options:(NSCaseInsensitiveSearch | NSBackwardsSearch)
                                                                   range:searchRange];
        if (_currentTextSelection.location == NSNotFound) {
            
            _currentTextSelection = NSMakeRange(0, 0);
            return;
        }
    }
    
    [self updateSelectionOnTextView];
}

- (void)updateSelectionOnTextView {
    
    if (![self.domainsTextView isFirstResponder]) {
        
        [self.domainsTextView becomeFirstResponder];
    }
    self.domainsTextView.selectedRange = _currentTextSelection;
//    dispatch_async(dispatch_get_main_queue(), ^{
        [self.domainsTextView scrollRangeToVisible:_currentTextSelection consideringInsets:YES];
//    });

}

@end
