//
//  CHCSVParser.m
//  CHCSVParser
/**
 Copyright (c) 2014 Dave DeLong
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 **/

#import "CHCSVParser.h"

#if !__has_feature(objc_arc)
#error CHCSVParser requires ARC.  If the rest of your project is non-ARC, add the "-fobjc-arc" compiler flag for this file.
#endif

NSString *const CHCSVErrorDomain = @"com.davedelong.csv";

#define CHUNK_SIZE 512
#define DOUBLE_QUOTE '"'
#define COMMA ','
#define OCTOTHORPE '#'
#define EQUAL '='
#define BACKSLASH '\\'
#define NULLCHAR '\0'

@interface CHCSVParser ()
@property (assign) NSUInteger totalBytesRead;
@end

@implementation CHCSVParser {
    NSInputStream *_stream;
    NSStringEncoding _streamEncoding;
    NSMutableData *_stringBuffer;
    NSMutableString *_string;
    NSCharacterSet *_validFieldCharacters;
    
    NSUInteger _nextIndex;
    
    NSInteger _fieldIndex;
    NSRange _fieldRange;
    NSMutableString *_sanitizedField;
    
    unichar _delimiter;
    
    NSError *_error;
    
    NSUInteger _currentRecord;
    BOOL _cancelled;
}

- (id)initWithCSVString:(NSString *)csv {
    return [self initWithDelimitedString:csv delimiter:COMMA];
}

- (instancetype)initWithDelimitedString:(NSString *)string delimiter:(unichar)delimiter {
    NSInputStream *stream = [NSInputStream inputStreamWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    return [self initWithInputStream:stream usedEncoding:NULL delimiter:delimiter];
}

- (instancetype)initWithContentsOfCSVURL:(NSURL *)csvURL {
    return [self initWithContentsOfDelimitedURL:csvURL delimiter:COMMA];
}

- (instancetype)initWithContentsOfDelimitedURL:(NSURL *)URL delimiter:(unichar)delimiter {
    NSInputStream *stream = [NSInputStream inputStreamWithURL:URL];
    return [self initWithInputStream:stream usedEncoding:NULL delimiter:delimiter];
}

- (id)initWithInputStream:(NSInputStream *)stream usedEncoding:(NSStringEncoding *)encoding delimiter:(unichar)delimiter {
    NSParameterAssert(stream);
    NSParameterAssert(delimiter);
    NSAssert([[NSCharacterSet newlineCharacterSet] characterIsMember:delimiter] == NO, @"The field delimiter may not be a newline");
    NSAssert(delimiter != DOUBLE_QUOTE, @"The field delimiter may not be a double quote");
    
    self = [super init];
    if (self) {
        _stream = stream;
        [_stream open];
        
        _stringBuffer = [[NSMutableData alloc] init];
        _string = [[NSMutableString alloc] init];
        
        _delimiter = delimiter;
        
        _nextIndex = 0;
        _recognizesComments = NO;
        _recognizesBackslashesAsEscapes = NO;
        _sanitizesFields = NO;
        _sanitizedField = [[NSMutableString alloc] init];
        _trimsWhitespace = NO;
        _recognizesLeadingEqualSign = NO;
        
        NSMutableCharacterSet *m = [[NSCharacterSet newlineCharacterSet] mutableCopy];
        NSString *invalid = [NSString stringWithFormat:@"%c%C", DOUBLE_QUOTE, _delimiter];
        [m addCharactersInString:invalid];
        _validFieldCharacters = [m invertedSet];
        
        if (encoding == NULL || *encoding == 0) {
            // we need to determine the encoding
            [self _sniffEncoding];
            if (encoding) {
                *encoding = _streamEncoding;
            }
        } else {
            _streamEncoding = *encoding;
        }
    }
    return self;
}

- (void)dealloc {
    [_stream close];
}

#pragma mark -

- (void)setRecognizesBackslashesAsEscapes:(BOOL)recognizesBackslashesAsEscapes {
    _recognizesBackslashesAsEscapes = recognizesBackslashesAsEscapes;
    if (_delimiter == BACKSLASH && _recognizesBackslashesAsEscapes) {
        [NSException raise:NSInternalInconsistencyException format:@"Cannot recognize backslashes as escapes when using '\\' as the delimiter"];
    }
}

- (void)setRecognizesComments:(BOOL)recognizesComments {
    _recognizesComments = recognizesComments;
    if (_delimiter == OCTOTHORPE && _recognizesComments) {
        [NSException raise:NSInternalInconsistencyException format:@"Cannot recognize comments when using '#' as the delimiter"];
    }
}

- (void)setRecognizesLeadingEqualSign:(BOOL)recognizesLeadingEqualSign {
    _recognizesLeadingEqualSign = recognizesLeadingEqualSign;
    if (_delimiter == EQUAL && _recognizesLeadingEqualSign) {
        [NSException raise:NSInternalInconsistencyException format:@"Cannot recognize leading equal sign when using '=' as the delimiter"];
    }
}

#pragma mark -

- (void)_sniffEncoding {
    NSStringEncoding encoding = NSUTF8StringEncoding;
    
    uint8_t bytes[CHUNK_SIZE];
    NSInteger readLength = [_stream read:bytes maxLength:CHUNK_SIZE];
    if (readLength > 0 && readLength <= CHUNK_SIZE) {
        [_stringBuffer appendBytes:bytes length:readLength];
        [self setTotalBytesRead:[self totalBytesRead] + readLength];
        
        NSInteger bomLength = 0;
        
        if (readLength > 3 && bytes[0] == 0x00 && bytes[1] == 0x00 && bytes[2] == 0xFE && bytes[3] == 0xFF) {
            encoding = NSUTF32BigEndianStringEncoding;
            bomLength = 4;
        } else if (readLength > 3 && bytes[0] == 0xFF && bytes[1] == 0xFE && bytes[2] == 0x00 && bytes[3] == 0x00) {
            encoding = NSUTF32LittleEndianStringEncoding;
            bomLength = 4;
        } else if (readLength > 3 && bytes[0] == 0x1B && bytes[1] == 0x24 && bytes[2] == 0x29 && bytes[3] == 0x43) {
            encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISO_2022_KR);
            bomLength = 4;
        } else if (readLength > 1 && bytes[0] == 0xFE && bytes[1] == 0xFF) {
            encoding = NSUTF16BigEndianStringEncoding;
            bomLength = 2;
        } else if (readLength > 1 && bytes[0] == 0xFF && bytes[1] == 0xFE) {
            encoding = NSUTF16LittleEndianStringEncoding;
            bomLength = 2;
        } else if (readLength > 2 && bytes[0] == 0xEF && bytes[1] == 0xBB && bytes[2] == 0xBF) {
            encoding = NSUTF8StringEncoding;
            bomLength = 3;
        } else {
            NSString *bufferAsUTF8 = nil;
            
            for (NSInteger triedLength = 0; triedLength < 4; ++triedLength) {
                bufferAsUTF8 = [[NSString alloc] initWithBytes:bytes length:readLength-triedLength encoding:NSUTF8StringEncoding];
                if (bufferAsUTF8 != nil) {
                    break;
                }
            }
            
            if (bufferAsUTF8 != nil) {
                encoding = NSUTF8StringEncoding;
            } else {
                NSLog(@"unable to determine stream encoding; assuming MacOSRoman");
                encoding = NSMacOSRomanStringEncoding;
            }
        }
        
        if (bomLength > 0) {
            [_stringBuffer replaceBytesInRange:NSMakeRange(0, bomLength) withBytes:NULL length:0];
        }
    }
    _streamEncoding = encoding;
}

- (void)_loadMoreIfNecessary {
    NSUInteger stringLength = [_string length];
    NSUInteger reloadPortion = stringLength / 3;
    if (reloadPortion < 10) { reloadPortion = 10; }
    
    if (_nextIndex+reloadPortion >= stringLength && [_stream hasBytesAvailable]) {
        // read more from the stream
        uint8_t buffer[CHUNK_SIZE];
        NSInteger readBytes = [_stream read:buffer maxLength:CHUNK_SIZE];
        if (readBytes > 0) {
            // append it to the buffer
            [_stringBuffer appendBytes:buffer length:readBytes];
            [self setTotalBytesRead:[self totalBytesRead] + readBytes];
        }
    }
    
    if ([_stringBuffer length] > 0) {
        // try to turn the next portion of the buffer into a string
        NSUInteger readLength = [_stringBuffer length];
        while (readLength > 0) {
            NSString *readString = [[NSString alloc] initWithBytes:[_stringBuffer bytes] length:readLength encoding:_streamEncoding];
            if (readString == nil) {
                readLength--;
            } else {
                [_string appendString:readString];
                break;
            }
        };
        
        [_stringBuffer replaceBytesInRange:NSMakeRange(0, readLength) withBytes:NULL length:0];
    }
}

- (void)_advance {
    [self _loadMoreIfNecessary];
    _nextIndex++;
}

- (unichar)_peekCharacter {
    [self _loadMoreIfNecessary];
    if (_nextIndex >= [_string length]) { return NULLCHAR; }
    
    return [_string characterAtIndex:_nextIndex];
}

- (unichar)_peekPeekCharacter {
    [self _loadMoreIfNecessary];
    NSUInteger nextNextIndex = _nextIndex+1;
    if (nextNextIndex >= [_string length]) { return NULLCHAR; }
    
    return [_string characterAtIndex:nextNextIndex];
}

#pragma mark -

- (void)parse {
    @autoreleasepool {
        [self _beginDocument];
        
        _currentRecord = 0;
        while ([self _parseRecord]) {
            ; // yep;
        }
        
        if (_error != nil) {
            [self _error];
        } else {
            [self _endDocument];
        }
    }
}

- (void)cancelParsing {
    _cancelled = YES;
}

- (BOOL)_parseRecord {
    while ([self _peekCharacter] == OCTOTHORPE && _recognizesComments) {
        [self _parseComment];
    }
    
    if ([self _peekCharacter] != NULLCHAR) {
        @autoreleasepool {
            [self _beginRecord];
            while (1) {
                if (![self _parseField]) {
                    break;
                }
                if (![self _parseDelimiter]) {
                    break;
                }
            }
            [self _endRecord];
        }
    }
    
    BOOL followedByNewline = [self _parseNewline];
    return (followedByNewline && _error == nil && [self _peekCharacter] != NULLCHAR);
}

- (BOOL)_parseNewline {
    if (_cancelled) { return NO; }
    
    NSUInteger charCount = 0;
    while ([[NSCharacterSet newlineCharacterSet] characterIsMember:[self _peekCharacter]]) {
        charCount++;
        [self _advance];
    }
    return (charCount > 0);
}

- (BOOL)_parseComment {
    [self _advance]; // consume the octothorpe
    
    NSCharacterSet *newlines = [NSCharacterSet newlineCharacterSet];
    
    [self _beginComment];
    BOOL isBackslashEscaped = NO;
    while (1) {
        if (isBackslashEscaped == NO) {
            unichar next = [self _peekCharacter];
            if (next == BACKSLASH && _recognizesBackslashesAsEscapes) {
                isBackslashEscaped = YES;
                [self _advance];
            } else if ([newlines characterIsMember:next] == NO && next != NULLCHAR) {
                [self _advance];
            } else {
                // it's a newline
                break;
            }
        } else {
            isBackslashEscaped = YES;
            [self _advance];
        }
    }
    [self _endComment];
    
    return [self _parseNewline];
}

- (void)_parseFieldWhitespace {
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
    while ([self _peekCharacter] != NULLCHAR &&
           [whitespace characterIsMember:[self _peekCharacter]] &&
           [self _peekCharacter] != _delimiter) {
        
        if (_trimsWhitespace == NO) {
            [_sanitizedField appendFormat:@"%C", [self _peekCharacter]];
            // if we're sanitizing fields, then these characters would be stripped (because they're not appended to _sanitizedField)
        }
        [self _advance];
    }
}

- (BOOL)_parseField {
    if (_cancelled) { return NO; }
    
    BOOL parsedField = NO;
    [self _beginField];
    
    // consume leading whitespace
    [self _parseFieldWhitespace];
    
    if ([self _peekCharacter] == DOUBLE_QUOTE) {
        parsedField = [self _parseEscapedField];
    } else if (_recognizesLeadingEqualSign && [self _peekCharacter] == EQUAL && [self _peekPeekCharacter] == DOUBLE_QUOTE) {
        [self _advance]; // consume the equal sign
        parsedField = [self _parseEscapedField];
    } else {
        parsedField = [self _parseUnescapedField];
        if (_trimsWhitespace) {
            NSString *trimmedString = [_sanitizedField stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [_sanitizedField setString:trimmedString];
        }
    }
    
    if (parsedField) {
        // consume trailing whitespace
        [self _parseFieldWhitespace];
        [self _endField];
    }
    return parsedField;
}

- (BOOL)_parseEscapedField {
    [self _advance]; // consume the opening double quote
    
    NSCharacterSet *newlines = [NSCharacterSet newlineCharacterSet];
    BOOL isBackslashEscaped = NO;
    while (1) {
        unichar next = [self _peekCharacter];
        if (next == NULLCHAR) { break; }
        
        if (isBackslashEscaped == NO) {
            if (next == BACKSLASH && _recognizesBackslashesAsEscapes) {
                isBackslashEscaped = YES;
                [self _advance]; // consume the backslash
            } else if ([_validFieldCharacters characterIsMember:next] ||
                       [newlines characterIsMember:next] ||
                       next == _delimiter) {
                [_sanitizedField appendFormat:@"%C", next];
                [self _advance];
            } else if (next == DOUBLE_QUOTE && [self _peekPeekCharacter] == DOUBLE_QUOTE) {
                [_sanitizedField appendFormat:@"%C", next];
                [self _advance];
                [self _advance];
            } else {
                // not valid, or it's not a doubled double quote
                break;
            }
        } else {
            [_sanitizedField appendFormat:@"%C", next];
            isBackslashEscaped = NO;
            [self _advance];
        }
    }
    
    if ([self _peekCharacter] == DOUBLE_QUOTE) {
        [self _advance];
        return YES;
    }
    
    return NO;
}

- (BOOL)_parseUnescapedField {
    
    NSCharacterSet *newlines = [NSCharacterSet newlineCharacterSet];
    BOOL isBackslashEscaped = NO;
    while (1) {
        unichar next = [self _peekCharacter];
        if (next == NULLCHAR) { break; }
        
        if (isBackslashEscaped == NO) {
            if (next == BACKSLASH && _recognizesBackslashesAsEscapes) {
                isBackslashEscaped = YES;
                [self _advance];
            } else if ([newlines characterIsMember:next] == YES || next == _delimiter) {
                break;
            } else {
                [_sanitizedField appendFormat:@"%C", next];
                [self _advance];
            }
        } else {
            isBackslashEscaped = NO;
            [_sanitizedField appendFormat:@"%C", next];
            [self _advance];
        }
    }
    
    return YES;
}

- (BOOL)_parseDelimiter {
    unichar next = [self _peekCharacter];
    if (next == _delimiter) {
        [self _advance];
        return YES;
    }
    if (next != NULLCHAR && [[NSCharacterSet newlineCharacterSet] characterIsMember:next] == NO) {
        NSString *description = [NSString stringWithFormat:@"Unexpected delimiter. Expected '%C' (0x%X), but got '%C' (0x%X)", _delimiter, _delimiter, [self _peekCharacter], [self _peekCharacter]];
        _error = [[NSError alloc] initWithDomain:CHCSVErrorDomain code:CHCSVErrorCodeInvalidFormat userInfo:@{NSLocalizedDescriptionKey : description}];
    }
    return NO;
}

- (void)_beginDocument {
    if ([_delegate respondsToSelector:@selector(parserDidBeginDocument:)]) {
        [_delegate parserDidBeginDocument:self];
    }
}

- (void)_endDocument {
    if ([_delegate respondsToSelector:@selector(parserDidEndDocument:)]) {
        [_delegate parserDidEndDocument:self];
    }
}

- (void)_beginRecord {
    if (_cancelled) { return; }
    
    _fieldIndex = 0;
    _currentRecord++;
    if ([_delegate respondsToSelector:@selector(parser:didBeginLine:)]) {
        [_delegate parser:self didBeginLine:_currentRecord];
    }
}

- (void)_endRecord {
    if (_cancelled) { return; }
    
    if ([_delegate respondsToSelector:@selector(parser:didEndLine:)]) {
        [_delegate parser:self didEndLine:_currentRecord];
    }
}

- (void)_beginField {
    if (_cancelled) { return; }
    
    [_sanitizedField setString:@""];
    _fieldRange.location = _nextIndex;
}

- (void)_endField {
    if (_cancelled) { return; }
    
    _fieldRange.length = (_nextIndex - _fieldRange.location);
    NSString *field = nil;
    
    if (_sanitizesFields) {
        field = [_sanitizedField copy];
    } else {
        field = [_string substringWithRange:_fieldRange];
        if (_trimsWhitespace) {
            field = [field stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
    }
    
    if ([_delegate respondsToSelector:@selector(parser:didReadField:atIndex:)]) {
        [_delegate parser:self didReadField:field atIndex:_fieldIndex];
    }
    
    [_string replaceCharactersInRange:NSMakeRange(0, NSMaxRange(_fieldRange)) withString:@""];
    _nextIndex = 0;
    _fieldIndex++;
}

- (void)_beginComment {
    if (_cancelled) { return; }
    
    _fieldRange.location = _nextIndex;
}

- (void)_endComment {
    if (_cancelled) { return; }
    
    _fieldRange.length = (_nextIndex - _fieldRange.location);
    if ([_delegate respondsToSelector:@selector(parser:didReadComment:)]) {
        NSString *comment = [_string substringWithRange:_fieldRange];
        [_delegate parser:self didReadComment:comment];
    }
    
    [_string replaceCharactersInRange:NSMakeRange(0, NSMaxRange(_fieldRange)) withString:@""];
    _nextIndex = 0;
}

- (void)_error {
    if (_cancelled) { return; }
    
    if ([_delegate respondsToSelector:@selector(parser:didFailWithError:)]) {
        [_delegate parser:self didFailWithError:_error];
    }
}

@end

@implementation CHCSVWriter {
    NSOutputStream *_stream;
    NSStringEncoding _streamEncoding;
    
    NSData *_delimiter;
    NSData *_bom;
    NSCharacterSet *_illegalCharacters;
    
    NSUInteger _currentLine;
    NSUInteger _currentField;
    NSMutableArray *_firstLineKeys;
}

- (instancetype)initForWritingToCSVFile:(NSString *)path {
    NSOutputStream *stream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    return [self initWithOutputStream:stream encoding:NSUTF8StringEncoding delimiter:COMMA];
}

- (instancetype)initWithOutputStream:(NSOutputStream *)stream encoding:(NSStringEncoding)encoding delimiter:(unichar)delimiter {
    self = [super init];
    if (self) {
        _stream = stream;
        _streamEncoding = encoding;
        
        if ([_stream streamStatus] == NSStreamStatusNotOpen) {
            [_stream open];
        }
        
        NSData *a = [@"a" dataUsingEncoding:_streamEncoding];
        NSData *aa = [@"aa" dataUsingEncoding:_streamEncoding];
        if ([a length] * 2 != [aa length]) {
            NSUInteger characterLength = [aa length] - [a length];
            _bom = [a subdataWithRange:NSMakeRange(0, [a length] - characterLength)];
            [self _writeData:_bom];
        }
        
        NSString *delimiterString = [NSString stringWithFormat:@"%C", delimiter];
        NSData *delimiterData = [delimiterString dataUsingEncoding:_streamEncoding];
        if ([_bom length] > 0) {
            _delimiter = [delimiterData subdataWithRange:NSMakeRange([_bom length], [delimiterData length] - [_bom length])];
        } else {
            _delimiter = delimiterData;
        }
        
        NSMutableCharacterSet *illegalCharacters = [[NSCharacterSet newlineCharacterSet] mutableCopy];
        [illegalCharacters addCharactersInString:delimiterString];
        [illegalCharacters addCharactersInString:@"\""];
        _illegalCharacters = [illegalCharacters copy];
        
        _firstLineKeys = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
    [self closeStream];
}

- (void)_writeData:(NSData *)data {
    if ([data length] > 0) {
        const void *bytes = [data bytes];
        [_stream write:bytes maxLength:[data length]];
    }
}

- (void)_writeString:(NSString *)string {
    NSData *stringData = [string dataUsingEncoding:_streamEncoding];
    if ([_bom length] > 0) {
        stringData = [stringData subdataWithRange:NSMakeRange([_bom length], [stringData length] - [_bom length])];
    }
    [self _writeData:stringData];
}

- (void)_writeDelimiter {
    [self _writeData:_delimiter];
}

- (void)writeField:(id)field {
    if (_currentField > 0) {
        [self _writeDelimiter];
    }
    
    if (_currentLine == 0) {
        [_firstLineKeys addObject:field];
    }
    
    NSString *string = field ? [field description] : @"";
    
    if ([string rangeOfCharacterFromSet:_illegalCharacters].location != NSNotFound) {
        // replace double quotes with double double quotes
        string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@"\"\""];
        // surround in double quotes
        string = [NSString stringWithFormat:@"\"%@\"", string];
    }
    [self _writeString:string];
    _currentField++;
}

- (void)finishLine {
    [self _writeString:@"\n"];
    _currentField = 0;
    _currentLine++;
}

- (void)_finishLineIfNecessary {
    if (_currentField != 0) {
        [self finishLine];
    }
}

- (void)writeLineOfFields:(id<NSFastEnumeration>)fields {
    [self _finishLineIfNecessary];
    
    for (id field in fields) {
        [self writeField:field];
    }
    [self finishLine];
}

- (void)writeLineWithDictionary:(NSDictionary *)dictionary {
    if (_currentLine == 0) {
        [NSException raise:NSInternalInconsistencyException format:@"Cannot write a dictionary unless a line of keys has already been given"];
    }
    
    [self _finishLineIfNecessary];
    
    for (id key in _firstLineKeys) {
        id value = [dictionary objectForKey:key];
        [self writeField:value];
    }
    [self finishLine];
}

- (void)writeComment:(NSString *)comment {
    [self _finishLineIfNecessary];
    
    NSArray *lines = [comment componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for (NSString *line in lines) {
        NSString *commented = [NSString stringWithFormat:@"#%@\n", line];
        [self _writeString:commented];
    }
}

- (void)closeStream {
    [_stream close];
    _stream = nil;
}

@end

#pragma mark - Convenience Categories

@interface _CHCSVAggregator : NSObject <CHCSVParserDelegate>

@property (strong) NSMutableArray *lines;
@property (strong) NSError *error;

@property (strong) NSMutableArray *currentLine;

@end

@implementation _CHCSVAggregator

- (void)parserDidBeginDocument:(CHCSVParser *)parser {
    self.lines = [[NSMutableArray alloc] init];
}

- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber {
    self.currentLine = [[NSMutableArray alloc] init];
}

- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber {
    [self.lines addObject:self.currentLine];
    self.currentLine = nil;
}

- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex {
    [self.currentLine addObject:field];
}

- (void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error {
    self.error = error;
    self.lines = nil;
}

@end

@interface _CHCSVKeyedAggregator : _CHCSVAggregator

@property (strong) NSArray *firstLine;

@end

@implementation _CHCSVKeyedAggregator

- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber {
    if (self.firstLine == nil) {
        self.firstLine = self.currentLine;
    } else if (self.currentLine.count == self.firstLine.count) {
        CHCSVOrderedDictionary *line = [[CHCSVOrderedDictionary alloc] initWithObjects:self.currentLine
                                                                               forKeys:self.firstLine];
        [self.lines addObject:line];
    } else {
        [parser cancelParsing];
        self.error = [NSError errorWithDomain:CHCSVErrorDomain code:CHCSVErrorCodeIncorrectNumberOfFields userInfo:nil];
    }
    self.currentLine = nil;
}

@end

NSArray *_CHCSVParserParse(NSInputStream *inputStream, CHCSVParserOptions options, unichar delimiter, NSError *__autoreleasing *error);
NSArray *_CHCSVParserParse(NSInputStream *inputStream, CHCSVParserOptions options, unichar delimiter, NSError *__autoreleasing *error) {
    CHCSVParser *parser = [[CHCSVParser alloc] initWithInputStream:inputStream usedEncoding:nil delimiter:delimiter];
    
    BOOL usesFirstLineAsKeys = !!(options & CHCSVParserOptionsUsesFirstLineAsKeys);
    _CHCSVAggregator *aggregator = usesFirstLineAsKeys ? [[_CHCSVKeyedAggregator alloc] init] : [[_CHCSVAggregator alloc] init];
    parser.delegate = aggregator;
    
    parser.recognizesBackslashesAsEscapes = !!(options & CHCSVParserOptionsRecognizesBackslashesAsEscapes);
    parser.sanitizesFields = !!(options & CHCSVParserOptionsSanitizesFields);
    parser.recognizesComments = !!(options & CHCSVParserOptionsRecognizesComments);
    parser.trimsWhitespace = !!(options & CHCSVParserOptionsTrimsWhitespace);
    parser.recognizesLeadingEqualSign = !!(options & CHCSVParserOptionsRecognizesLeadingEqualSign);
    
    [parser parse];
    
    if (aggregator.error != nil) {
        if (error) {
            *error = aggregator.error;
        }
        return nil;
    } else {
        return aggregator.lines;
    }
}

@implementation NSArray (CHCSVAdditions)

+ (instancetype)arrayWithContentsOfCSVURL:(NSURL *)fileURL {
    return [self arrayWithContentsOfDelimitedURL:fileURL options:0 delimiter:COMMA error:nil];
}

+ (instancetype)arrayWithContentsOfDelimitedURL:(NSURL *)fileURL delimiter:(unichar)delimiter {
    return [self arrayWithContentsOfDelimitedURL:fileURL options:0 delimiter:delimiter error:nil];
}

+ (instancetype)arrayWithContentsOfCSVURL:(NSURL *)fileURL options:(CHCSVParserOptions)options {
    return [self arrayWithContentsOfDelimitedURL:fileURL options:options delimiter:COMMA error:nil];
}

+ (instancetype)arrayWithContentsOfDelimitedURL:(NSURL *)fileURL options:(CHCSVParserOptions)options delimiter:(unichar)delimiter {
    return [self arrayWithContentsOfDelimitedURL:fileURL options:options delimiter:delimiter error:nil];
}

+ (instancetype)arrayWithContentsOfDelimitedURL:(NSURL *)fileURL options:(CHCSVParserOptions)options delimiter:(unichar)delimiter error:(NSError *__autoreleasing *)error {
    NSParameterAssert(fileURL);
    NSInputStream *stream = [NSInputStream inputStreamWithURL:fileURL];
    
    return _CHCSVParserParse(stream, options, delimiter, error);
}

- (NSString *)CSVString {
    NSOutputStream *output = [NSOutputStream outputStreamToMemory];
    CHCSVWriter *writer = [[CHCSVWriter alloc] initWithOutputStream:output encoding:NSUTF8StringEncoding delimiter:COMMA];
    for (id object in self) {
        if ([object conformsToProtocol:@protocol(NSFastEnumeration)]) {
            [writer writeLineOfFields:object];
        }
    }
    [writer closeStream];
    
    NSData *buffer = [output propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    return [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
}

@end

@implementation NSString (CHCSVAdditions)

- (NSArray *)CSVComponents {
    return [self componentsSeparatedByDelimiter:COMMA options:0 error:nil];
}

- (NSArray *)CSVComponentsWithOptions:(CHCSVParserOptions)options {
    return [self componentsSeparatedByDelimiter:COMMA options:options error:nil];
}

- (NSArray *)componentsSeparatedByDelimiter:(unichar)delimiter {
    return [self componentsSeparatedByDelimiter:delimiter options:0 error:nil];
}

- (NSArray *)componentsSeparatedByDelimiter:(unichar)delimiter options:(CHCSVParserOptions)options {
    return [self componentsSeparatedByDelimiter:delimiter options:options error:nil];
}

- (NSArray *)componentsSeparatedByDelimiter:(unichar)delimiter options:(CHCSVParserOptions)options error:(NSError *__autoreleasing *)error {
    NSData *csvData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSInputStream *stream = [NSInputStream inputStreamWithData:csvData];
    
    return _CHCSVParserParse(stream, options, delimiter, error);
}

@end

@implementation CHCSVOrderedDictionary {
    NSArray *_keys;
    NSArray *_values;
    NSDictionary *_dictionary;
}

- (instancetype)initWithObjects:(NSArray *)objects forKeys:(NSArray *)keys {
    self = [super init];
    if (self) {
        _keys = keys.copy;
        _values = objects.copy;
        _dictionary = [NSDictionary dictionaryWithObjects:_values forKeys:_keys];
    }
    return self;
}

- (instancetype)initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    return [self initWithObjects:[NSArray arrayWithObjects:objects count:cnt]
                         forKeys:[NSArray arrayWithObjects:keys count:cnt]];
}

- (instancetype)init {
    return [self initWithObjects:@[] forKeys:@[]];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [super initWithCoder:aDecoder];
}

- (NSArray *)allKeys {
    return _keys;
}

- (NSArray *)allValues {
    return _values;
}

- (NSUInteger)count {
    return _dictionary.count;
}

- (id)objectForKey:(id)aKey {
    return [_dictionary objectForKey:aKey];
}

- (NSEnumerator *)keyEnumerator {
    return _keys.objectEnumerator;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len {
    return [_keys countByEnumeratingWithState:state objects:buffer count:len];
}

- (id)objectAtIndex:(NSUInteger)idx {
    id key = [_keys objectAtIndex:idx];
    return [self objectForKey:key];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return [self objectAtIndex:idx];
}

- (NSUInteger)hash {
    return _dictionary.hash;
}

- (BOOL)isEqual:(CHCSVOrderedDictionary *)object {
    if ([super isEqual:object] && [object isKindOfClass:[CHCSVOrderedDictionary class]]) {
        // we've determined that from a dictionary POV, they're equal
        // now we need to test for key ordering
        return [object->_keys isEqual:_keys];
    }
    
    return NO;
}

@end

#pragma mark - Deprecated methods

@implementation CHCSVParser (Deprecated)

- (id)initWithCSVString:(NSString *)csv delimiter:(unichar)delimiter {
    return [self initWithDelimitedString:csv delimiter:delimiter];
}

- (id)initWithContentsOfCSVFile:(NSString *)csvFilePath {
    return [self initWithContentsOfCSVURL:[NSURL fileURLWithPath:csvFilePath]];
}

- (id)initWithContentsOfCSVFile:(NSString *)csvFilePath delimiter:(unichar)delimiter {
    return [self initWithContentsOfDelimitedURL:[NSURL fileURLWithPath:csvFilePath] delimiter:delimiter];
}

- (void)setStripsLeadingAndTrailingWhitespace:(BOOL)stripsLeadingAndTrailingWhitespace {
    self.trimsWhitespace = stripsLeadingAndTrailingWhitespace;
}

- (BOOL)stripsLeadingAndTrailingWhitespace {
    return self.trimsWhitespace;
}

@end

@implementation NSArray (CHCSVAdditions_Deprecated)

+ (instancetype)arrayWithContentsOfCSVFile:(NSString *)csvFilePath {
    return [self arrayWithContentsOfDelimitedURL:[NSURL fileURLWithPath:csvFilePath] options:0 delimiter:COMMA error:nil];
}

+ (instancetype)arrayWithContentsOfCSVFile:(NSString *)csvFilePath delimiter:(unichar)delimiter {
    return [self arrayWithContentsOfDelimitedURL:[NSURL fileURLWithPath:csvFilePath] options:0 delimiter:delimiter error:nil];
}

+ (instancetype)arrayWithContentsOfCSVFile:(NSString *)csvFilePath options:(CHCSVParserOptions)options {
    return [self arrayWithContentsOfDelimitedURL:[NSURL fileURLWithPath:csvFilePath] options:options delimiter:COMMA error:nil];
}

+ (instancetype)arrayWithContentsOfCSVFile:(NSString *)csvFilePath options:(CHCSVParserOptions)options delimiter:(unichar)delimiter {
    return [self arrayWithContentsOfDelimitedURL:[NSURL fileURLWithPath:csvFilePath] options:options delimiter:delimiter error:nil];
}

+ (instancetype)arrayWithContentsOfCSVFile:(NSString *)csvFilePath options:(CHCSVParserOptions)options delimiter:(unichar)delimiter error:(NSError *__autoreleasing *)error {
    return [self arrayWithContentsOfDelimitedURL:[NSURL fileURLWithPath:csvFilePath] options:options delimiter:delimiter error:error];
}

@end

@implementation NSString (CHCSVAdditions_Deprecated)

- (NSArray *)CSVComponentsWithDelimiter:(unichar)delimiter {
    return [self componentsSeparatedByDelimiter:delimiter options:0 error:nil];
}

- (NSArray *)CSVComponentsWithOptions:(CHCSVParserOptions)options delimiter:(unichar)delimiter {
    return [self componentsSeparatedByDelimiter:delimiter options:options error:nil];
}

- (NSArray *)CSVComponentsWithOptions:(CHCSVParserOptions)options delimiter:(unichar)delimiter error:(NSError *__autoreleasing *)error {
    return [self componentsSeparatedByDelimiter:delimiter options:options error:error];
}

@end
