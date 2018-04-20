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
#import <Foundation/Foundation.h>

/////////////////////////////////////////////////////////////////////
#pragma mark - ACLRunController
/////////////////////////////////////////////////////////////////////

typedef enum {
    ACLJCInitState = 0,
    ACLJCExecuteState,
    ACLJCStopState,
    ACLJCCancelSate
    
} ACLJobControllerState;


/**
 
 *  Helper class for controlling states of processes.
 *  May be used for controlling execution of GCD queue.
 *  You may set state of this object from different threads.

    Example of usage.
    You create ACLJobController object before running of process, 
    which may long executed. Set state of that object to ACLJCExecuteState by calling start method. 
    Then run that process. In code of long process you may check state of ACLJobController. 
    If that state equal to ACLJCCancelSate, you may cancel execution that process.
    
    In that time, in main thread, if user pressed cancel button, 
    you may set state of the ACLJobController object to ACLJCCancelSate by calling cancel method.
 */
@interface ACLJobController  : NSObject

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////

/**
    Current status of receiver.
 */
@property ACLJobControllerState state;

/**
    Setting state of receiver to ACLRCExecuteState.
    Status will be changed if current state is ACLRCInitState.
 */
- (void)start;

/**
    Setting state of receiver to ACLRCStopState.
    Status will be changed if current state is ACLRCExecuteState.
 */
- (void)stop;

/**
    Setting state of receiver to ACLRCCancelSate.
    Status will be changed if current state is ACLRCExecuteState.
 */
- (void)cancel;

@end
