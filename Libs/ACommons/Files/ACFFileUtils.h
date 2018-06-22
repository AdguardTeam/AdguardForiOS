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

@interface ACFFileUtils : NSObject

/// Returns UTF-8 encoding that is default for file content.
+ (NSStringEncoding)defaultFileEncoding;

/// Gets last write time for the file.
+ (NSDate *)fileLastWriteTimeForUrl:(NSURL *)pathUrl;

/// Gets created time for the URL.
+ (NSDate *)fileCreatedTimeForUrl:(NSURL *)pathUrl;

/// Reads file content quetly.
/// Returns nil if nothing has been read.
/// Opens file in UTF-8 encoding. ([ACFFileUtils defaultHttpEncoding])
+ (NSData *)readQuetlyForUrl:(NSURL *)pathUrl;

/// Writes quetly text to the specified file
/// Opens file from UTF-8 encoding. ([ACFFileUtils defaultHttpEncoding])
+ (void)writeQuetly:(NSString *)text toFile:(NSURL *)pathUrl;

/// Creates file or changes it's last updated time
+ (void)touchForUrl:(NSURL *)pathUrl;

/// Deletes file or directory on the path.
+ (BOOL)deleteQuetlyForUrl:(NSURL *)pathUrl;

/// Returns MD5 file checksum or nil if error
/// @warning may not work, source from internet
+ (NSString *)fileChecksum:(NSURL *)fileUrl;

/// Checks if file is older than specified date
+ (BOOL)isFile:(NSURL *)pathUrl olderThan:(NSDate *)dateTime;

/**
    Finds file by name in specified directory including subdirectories.
 
    @param fileName         Filename for search. May be wildcard pattern.
    @param directoryToScan  The location of the directory that defines start point of search.
    @param level            Level of nesting. Set to 0 for infinity.
 
    @return                 Array of NSURL objects that point to files. 
                            If files not found returns empty array.
 */
+ (NSArray *)findFileByName:(NSString *)fileName inDirectory:(NSURL *)directoryToScan level:(NSUInteger)level;

/**
    Finds file Url by name in specified directory including subdirectories.
 
    @param fileName         Filename or folder for search. May be wildcard pattern.
    @param directoryToScan  The location of the directory that defines start point of search.
    @param level            Level of nesting. Set to 0 for infinity.
    @param ignoreDirectory  Not include in returned array Url for directory.

    @return                 Array of NSURL objects that point to files. 
                            If files not found returns empty array.
 */
+ (NSArray *)findUrlByName:(NSString *)fileName inDirectory:(NSURL *)directoryToScan level:(NSUInteger)level ignoreDirectory:(BOOL)ignoreDirectory;

@end
