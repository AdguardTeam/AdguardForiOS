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
#import "ACLFileLocker.h"

/////////////////////////////////////////////////////////////////////
#pragma mark - ACLFileLocker
/////////////////////////////////////////////////////////////////////

@interface ACLFileLocker()

@end

@implementation ACLFileLocker

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

- (id)initWithPath:(NSString *)path{
    
    self = [super init]; // [super _init_];
    if (self)
    {
        _path = path;
        _fileDescriptor = -1;
        _locked = NO;
        
    }
    
    return self;
}

- (void)dealloc{
    
    if (_fileDescriptor >= 0){
        
        if (_locked)
            flock(_fileDescriptor, LOCK_UN);
        
        close(_fileDescriptor);
    }
}
/////////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////////

- (BOOL)lock{
    
    @synchronized(self){
        
        if (_locked)
            return YES;
            
        if ([self open]) {

            if (flock(_fileDescriptor, LOCK_EX | LOCK_NB) == 0){
                
                _locked = YES;
                return YES;
            }
        }
        
        return NO;
    }
}

- (BOOL)waitLock{
    
    @synchronized(self){
        
        if (_locked)
            return YES;
        
        if ([self open]) {
            
            if (flock(_fileDescriptor, LOCK_EX ) == 0){
                
                _locked = YES;
                return YES;
            }
        }
        
        return NO;
    }
}

- (BOOL)unlock{
    
    @synchronized(self){
        
        if (!_locked)
            return YES;
        
        if (_fileDescriptor >= 0 && flock(_fileDescriptor, LOCK_UN ) == 0){
            
            _locked = NO;
            return YES;
        }
        
        return NO;
    }
}

////////////////////////////////////////////////////////////////////////////
#pragma mark Private Methods
////////////////////////////////////////////////////////////////////////////

- (BOOL)open{
    
    if (_fileDescriptor < 0) {
        _fileDescriptor = open([_path UTF8String], (O_CREAT | O_RDWR), (S_IRUSR | S_IWUSR));
        if (_fileDescriptor < 0)
            return NO;
    }

    return YES;
}

@end
