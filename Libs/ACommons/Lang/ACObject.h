//
//  ACObject.h
//
//  Created by Roman Sokolov on 21.07.14.
//  Copyright (c) 2014 Roman Sokolov. All rights reserved.
//

#import <Foundation/Foundation.h>

/////////////////////////////////////////////////////////////////////
#pragma mark - ACDObject
/////////////////////////////////////////////////////////////////////

/**
    Base class for objects, which can archive their properties. 
    You must inherit from this class if you create object of data model.
    Also supports not deep copying of the object.
 */
@interface ACObject : NSObject <NSSecureCoding, NSCopying>

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

+ (NSArray *)propertyNamesArray;

@end
