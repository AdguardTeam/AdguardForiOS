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
#import "ACFFileUtils.h"
#import "ACLang.h"
#import <stdint.h>
#import <stdio.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CommonCrypto/CommonDigest.h>

// In bytes
#define FILE_HASH_DEFAULT_CHUNK_SIZE_FOR_READING_DATA 4096


@implementation ACFFileUtils

/// Returns UTF-8 encoding that is default for file contentю
+ (NSStringEncoding)defaultFileEncoding
{
    return NSUTF8StringEncoding;
}

/// Gets last write time for the file.
// Old name - GetFileLastWriteTime
+ (NSDate *)fileLastWriteTimeForUrl:(NSURL *)pathUrl
{
    NSDate *result;
    NSError *err;
    NSDictionary *attrs;
    
    if ([pathUrl isFileURL]){
        attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:[pathUrl path] error:&err];
        if (err)
            DDLogWarn(@"Error getting time for file %@: %@", pathUrl, [err localizedDescription]);
        else
            result = [attrs fileModificationDate];
    }
    
    return result ? result : [NSDate distantFuture];
}

/// Gets created time for the URL.
+ (NSDate *)fileCreatedTimeForUrl:(NSURL *)pathUrl
{
    NSDate *result;
    NSError *err;
    NSDictionary *attrs;
    
    if ([pathUrl isFileURL]){
        attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:[pathUrl path] error:&err];
        if (err)
            DDLogWarn(@"Error getting time for file %@: %@", pathUrl, [err localizedDescription]);
        else
            result = [attrs fileCreationDate];
    }
    
    return result ? result : [NSDate distantFuture];
}


/// Reads file content quetly.
/// Returns nil if nothing has been read.
/// Opens file in UTF-8 encoding. ([ACFFileUtils defaultHttpEncoding])
// Old name - ReadQuetly
+ (NSData *)readQuetlyForUrl:(NSURL *)pathUrl
{
    
    if (![pathUrl isFileURL])
        return  nil;
    
    NSError *err;
    NSData *result = [NSData dataWithContentsOfURL:pathUrl options:NSDataReadingUncached error:&err];
    
    if (err) {
        
        DDLogWarn(@"Error reading file %@: %@", pathUrl, [err localizedDescription]);
        return nil;
    }
    
    return result;
    
}

/// Writes quetly text to the specified file
/// Save file from UTF-8 encoding. ([ACFFileUtils defaultHttpEncoding])
+ (void)writeQuetly:(NSString *)text toFile:(NSURL *)pathUrl
{
    if (!text) return;
    if (![pathUrl isFileURL]) return;
    
    NSError *err;
    
    if (![text writeToURL:pathUrl atomically:YES encoding:[ACFFileUtils defaultFileEncoding] error:&err])
        DDLogWarn(@"Error writing to file %@: %@", pathUrl, [err localizedDescription]);
}

/// Creates file or changes it's last updated time
// Old name - Touch
+ (void)touchForUrl:(NSURL *)pathUrl
{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([pathUrl isFileURL] && [pathUrl checkResourceIsReachableAndReturnError:nil]) {
        
        NSError *err;
        if (![manager setAttributes:@{NSFileModificationDate: [NSDate date]} ofItemAtPath:pathUrl.path error:&err])
            DDLogWarn(@"Error touching file %@: %@", pathUrl, [err localizedDescription]);
    }
    else{
        
        if (![manager createFileAtPath:pathUrl.path contents:[NSData data] attributes:nil])
            DDLogWarn(@"Error touching file %@: Can't create empty file.", pathUrl);
    }
    
}

/// Deletes file or directory on the path.
// Old name - DeleteQuetly
+ (BOOL)deleteQuetlyForUrl:(NSURL *)pathUrl
{
    if (![pathUrl isFileURL]) return NO;
    
    NSError *err;
    BOOL result = [[NSFileManager defaultManager] removeItemAtURL:pathUrl error:&err];
    if (!result)
        DDLogWarn(@"Error deleting %@: %@", pathUrl, [err localizedDescription]);
    
    return result;
}

/// Returns MD5 file checksum or nil if error
/// @warning may not work, source from internet
// Old name - GetFileChecksum
+ (NSString *)fileChecksum:(NSURL *)fileUrl
{
    // Declare needed variables
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    
    if (![fileUrl isFileURL])
        [[NSException argumentException:@"fileUrl"] raise];
    
    @try {
        
    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            (__bridge CFURLRef)fileUrl);
    if (!readStream) return nil;
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) return nil;
    
    // Initialize the hash object
    CC_MD5_CTX hashObject;
    CC_MD5_Init(&hashObject);
    
    // Feed the data to the hash object
    bool hasMoreData = true;
    while (hasMoreData) {
        uint8_t buffer[FILE_HASH_DEFAULT_CHUNK_SIZE_FOR_READING_DATA];
        CFIndex readBytesCount = CFReadStreamRead(readStream,
                                                  (UInt8 *)buffer,
                                                  (CFIndex)sizeof(buffer));
        if (readBytesCount == -1) break;
        if (readBytesCount == 0) {
            hasMoreData = false;
            continue;
        }
        CC_MD5_Update(&hashObject,
                      (const void *)buffer,
                      (CC_LONG)readBytesCount);
    }
    
    // Check if the read operation succeeded
    didSucceed = !hasMoreData;
    
    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    
    // Abort if the read operation failed
    if (!didSucceed) return nil;
    
    // Compute the string result
    char hash[2 * sizeof(digest) + 1];
    for (size_t i = 0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault,
                                       (const char *)hash,
                                       kCFStringEncodingUTF8);
    
    }
    @finally {

        if (readStream) {
            CFReadStreamClose(readStream);
            CFRelease(readStream);
        }
    }
    
    return (__bridge_transfer NSString *)result;
}

+ (BOOL)isFile:(NSURL *)pathUrl olderThan:(NSDate *)dateTime
{
    if (!dateTime) return NO;
        
    return [[ACFFileUtils fileLastWriteTimeForUrl:pathUrl] compare:dateTime] != NSOrderedDescending;
}

+ (NSArray *)findFileByName:(NSString *)fileName inDirectory:(NSURL *)directoryToScan level:(NSUInteger)level{
    
    return [ACFFileUtils findUrlByName:fileName inDirectory:directoryToScan level:level ignoreDirectory:YES];
}


+ (NSArray *)findUrlByName:(NSString *)fileName inDirectory:(NSURL *)directoryToScan level:(NSUInteger)level ignoreDirectory:(BOOL)ignoreDirectory{
    
    if (!fileName)
        [[NSException argumentException:@"fileName"] raise];
    
    if (!directoryToScan)
        [[NSException argumentException:@"directoryToScan"] raise];
    
    //Create wildcard
    ACLWildcard *pattern = [ACLWildcard wildcard:fileName];
    
    // Create a local file manager instance
    NSFileManager *localFileManager=[[NSFileManager alloc] init];
    
    // Enumerate the directory (specified elsewhere in your code)
    // Request the two properties the method uses, name and isDirectory
    // Ignore hidden files
    // The errorHandler: parameter is set to nil. Typically you'd want to present a panel
    NSDirectoryEnumerator *dirEnumerator = [localFileManager enumeratorAtURL:directoryToScan
                                                  includingPropertiesForKeys:@[NSURLNameKey, NSURLIsDirectoryKey]
                                                                     options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                errorHandler:nil];
    
    // An array to store the all the enumerated file names in
    NSMutableArray *theArray=[NSMutableArray array];
    
    // Enumerate the dirEnumerator results, each value is stored in allURLs
    for (NSURL *theURL in dirEnumerator) {
        
        // Retrieve the file name. From NSURLNameKey, cached during the enumeration.
        NSString *name;
        [theURL getResourceValue:&name forKey:NSURLNameKey error:NULL];
        
        // Retrieve whether a directory. From NSURLIsDirectoryKey, also
        // cached during the enumeration.
        NSNumber *isDirectory = @(0);
        if (ignoreDirectory) {
            [theURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
        }

        // Ignore sublevels
        if ( level && level <= [dirEnumerator level] && [isDirectory boolValue])
            [dirEnumerator skipDescendants];
        
        else{
            
            // Add full path for non directories
            if (![isDirectory boolValue] && ([name isEqualToString:fileName] || [pattern matchWildcard:name]))
                [theArray addObject:theURL];
        }
    }

    return theArray;
}
@end
