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
#import "ACLExecuteBlockDelayed.h"
////////////////////////////////////////////////////////////////////
#pragma mark - ACLExecuteBlockDelayed
/////////////////////////////////////////////////////////////////////

@implementation ACLExecuteBlockDelayed

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

-(id)initWithTimeout:(NSTimeInterval)interval leeway:(NSTimeInterval)leeway queue:(dispatch_queue_t)queue block:(dispatch_block_t)block{

    self = [super init]; // [super _init_];
    if (self)
    {
        
        _workQueue = queue;
        _interval = interval;
        _leeway = leeway;
        _block = block;
    }
    
    return self;
}

- (void)dealloc{
    
    [self stopUpdateTimer];
    _workQueue = nil;
    _block = nil;
}

/////////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////////

- (void)executeOnceAfterCalm{
    
    if (!_updateTimer){

        [self defineUpdateTimer];
        dispatch_resume(_updateTimer);
    }
    
    dispatch_source_set_timer(_updateTimer,
                              dispatch_time(DISPATCH_TIME_NOW, _interval * NSEC_PER_SEC),
                              _interval * NSEC_PER_SEC,
                              _leeway * NSEC_PER_SEC);
}

- (void)executeOnceForInterval{
    
    if (!_updateTimer){
        
        [self defineUpdateTimer];
        dispatch_resume(_updateTimer);

        dispatch_source_set_timer(_updateTimer,
                                  dispatch_time(DISPATCH_TIME_NOW, _interval * NSEC_PER_SEC),
                                  _interval * NSEC_PER_SEC,
                                  _leeway * NSEC_PER_SEC);
    }
}

- (void)executeNow {
    
    __weak __typeof__(self) wSelf = self;
    
    dispatch_async(_workQueue, ^{
        
        __typeof__(self) sSelf = wSelf;
        
        if (sSelf == nil) {
            return;
        }
        
        [sSelf stopUpdateTimer];
        sSelf->_block();
    });
}

/////////////////////////////////////////////////////////////////////////
#pragma mark Private Methods
/////////////////////////////////////////////////////////////////////////

- (void)stopUpdateTimer{
    
    if (_updateTimer) {
        
        dispatch_source_cancel(_updateTimer);
        
#if !OS_OBJECT_USE_OBJC
        dispatch_release(_updateTimer);
#endif
        _updateTimer = nil;
    }
    
}
- (void)defineUpdateTimer {
    
    _updateTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _workQueue);
    
    __weak __typeof__(self) wSelf = self;
    
    dispatch_source_set_event_handler(_updateTimer, ^{
        
        __typeof__(self) sSelf = wSelf;
        
        if (sSelf == nil) {
            return;
        }
        
        [sSelf stopUpdateTimer];
        sSelf->_block();
    });
}

@end
