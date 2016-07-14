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
 #import "AESharedResources.h"
*/
#import "APSharedResources.h"
#import "AESharedResources.h"
#import "ACommons/ACLang.h"

#define DNS_LOG_RECORD_FILE         @"dns-log-records.dat"

/////////////////////////////////////////////////////////////////////
#pragma mark - APSharedResources

@implementation APSharedResources

/////////////////////////////////////////////////////////////////////
#pragma mark Initialize

static NSString *_dnsLogRecordsPath;
static NSFileHandle *_readDnsLogHandler;
static NSFileHandle *_writeDnsLogHandler;

+ (void)initialize{
    
    if (self == [AESharedResources class]) {
        _dnsLogRecordsPath = [[[AESharedResources sharedResuorcesURL] path] stringByAppendingPathComponent:DNS_LOG_RECORD_FILE];
    
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark Class methods

+ (NSArray <APDnsLogRecord *> *)beginReadDnsLog{

    [_readDnsLogHandler seekToFileOffset:0];
    return [self nextReadDnsLog];
}

+ (NSArray<APDnsLogRecord *> *)nextReadDnsLog {

    NSMutableArray *result = [NSMutableArray new];

    NSData *data;
    ACLFileLocker *locker = [[ACLFileLocker alloc] initWithPath:_dnsLogRecordsPath];
    if ([locker lock]) {

        data = [_readDnsLogHandler readDataToEndOfFile];

        [locker unlock];
    }

    if (data.length) {

        NSInteger size = data.length;
        u_int16_t len = 1;
        Byte *buf = (Byte *)data.bytes;

        while (size > 0 && len) {

            len = *(u_int16_t *)buf;
            if (len > 0) {
                buf += 2;
                size -= 2;

                if (len > size) {
                    //error
                    len = 0;
                    break;
                }
                NSData *recordData = [NSData dataWithBytes:buf length:len];
                if (recordData) {
                    buf += len;
                    size -= len;

                    APDnsLogRecord *record = [NSKeyedUnarchiver unarchiveObjectWithData:recordData];
                    if (record) {
                        [result addObject:record];
                    }
                }
            }
        }
    }

    return result;
}

+ (void)removeDnsLog{
    
    [self initWriteDnsLogHandler];
    
    [_writeDnsLogHandler truncateFileAtOffset:0];
}

+ (void)writeToDnsLogRecords:(NSArray<APDnsLogRecord *> *)logRecords {

    [self initWriteDnsLogHandler];

    NSMutableData *dataForWrite = [NSMutableData new];

    u_int16_t len;
    for (APDnsLogRecord *item in logRecords) {

        NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:item];
        if (archive) {

            len = (u_int16_t)archive.length;
            if (len) {

                [dataForWrite appendBytes:&len length:2];
                [dataForWrite appendData:archive];
            }
        }
    }

    if (dataForWrite.length) {
        
        ACLFileLocker *locker = [[ACLFileLocker alloc] initWithPath:_dnsLogRecordsPath];
        if ([locker lock]) {

            [_writeDnsLogHandler writeData:dataForWrite];
            [_writeDnsLogHandler synchronizeFile];

            [locker unlock];
        }
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark Private methods

+ (void)initWriteDnsLogHandler {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _writeDnsLogHandler = [NSFileHandle fileHandleForWritingAtPath:_dnsLogRecordsPath];
        if (_writeDnsLogHandler) {
            [_writeDnsLogHandler seekToEndOfFile];
        }
    });
}

+ (void)initReadDnsLogHandler {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _readDnsLogHandler = [NSFileHandle fileHandleForReadingAtPath:_dnsLogRecordsPath];
    });
}

@end

