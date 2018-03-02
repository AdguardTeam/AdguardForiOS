//
//  CHCSVParser.h
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

#import <Foundation/Foundation.h>

#ifndef NS_DESIGNATED_INITIALIZER
#define NS_DESIGNATED_INITIALIZER
#endif

#ifndef CHCSV_DEPRECATED
#define CHCSV_DEPRECATED(...) __attribute__((deprecated("" #__VA_ARGS__)))
#endif

extern NSString * const CHCSVErrorDomain;

typedef NS_ENUM(NSInteger, CHCSVErrorCode) {
    /**
     *  Indicates that a delimited file is incorrectly formatted.
     *  For example, perhaps a double quote is in the wrong position.
     */
    CHCSVErrorCodeInvalidFormat = 1,
    
    /**
     *  When using @c CHCSVParserOptionsUsesFirstLineAsKeys, all of the lines in the file
     *  must have the same number of fields. If they do not, parsing is aborted and this error is returned.
     */
    CHCSVErrorCodeIncorrectNumberOfFields,
};

@class CHCSVParser;
@protocol CHCSVParserDelegate <NSObject>

@optional

/**
 *  Indicates that the parser has started parsing the stream
 *
 *  @param parser The @c CHCSVParser instance
 */
- (void)parserDidBeginDocument:(CHCSVParser *)parser;

/**
 *  Indicates that the parser has successfully finished parsing the stream
 *
 *  This method is not invoked if any error is encountered
 *
 *  @param parser The @c CHCSVParser instance
 */
- (void)parserDidEndDocument:(CHCSVParser *)parser;

/**
 *  Indicates the parser has started parsing a line
 *
 *  @param parser       The @c CHCSVParser instance
 *  @param recordNumber The 1-based number of the record
 */
- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber;

/**
 *  Indicates the parser has finished parsing a line
 *
 *  @param parser       The @c CHCSVParser instance
 *  @param recordNumber The 1-based number of the record
 */
- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber;

/**
 *  Indicates the parser has parsed a field on the current line
 *
 *  @param parser     The @c CHCSVParser instance
 *  @param field      The parsed string. If configured to do so, this string may be sanitized and trimmed
 *  @param fieldIndex The 0-based index of the field within the current record
 */
- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex;

/**
 *  Indicates the parser has encountered a comment
 *
 *  This method is only invoked if @c CHCSVParser.recognizesComments is @c YES
 *
 *  @param parser  The @c CHCSVParser instance
 *  @param comment The parsed comment
 */
- (void)parser:(CHCSVParser *)parser didReadComment:(NSString *)comment;

/**
 *  Indicates the parser encounter an error while parsing
 *
 *  @param parser The @c CHCSVParser instance
 *  @param error  The @c NSError instance
 */
- (void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error;

@end

@interface CHCSVParser : NSObject

/**
 *  The delegate for the @c CHCSVParser
 */
@property (assign) id<CHCSVParserDelegate> delegate;

/**
 *  If @c YES, then the parser will removing surrounding double quotes and will unescape characters.
 *  The default value is @c NO.
 *  @warning Do not mutate this property after parsing has begun
 */
@property (nonatomic, assign) BOOL sanitizesFields;

/**
 *  If @c YES, then the parser will trim whitespace around fields. If @c sanitizesFields is also @c YES,
 *  then the sanitized field is also trimmed. The default value is @c NO.
 *  @warning Do not mutate this property after parsing has begun
 */
@property (nonatomic, assign) BOOL trimsWhitespace;

/**
 *  If @c YES, then the parser will allow special characters (delimiter, newline, quote, etc)
 *  to be escaped within a field using a backslash character. The default value is @c NO.
 *  @warning Do not mutate this property after parsing has begun
 */
@property (nonatomic, assign) BOOL recognizesBackslashesAsEscapes;

/**
 *  If @c YES, then the parser will interpret any field that begins with an octothorpe as a comment.
 *  Comments are terminated using an unescaped newline character. The default value is @c NO.
 *  @warning Do not mutate this property after parsing has begun
 */
@property (nonatomic, assign) BOOL recognizesComments;

/**
 *  If @c YES, then quoted fields may begin with an equal sign.
 *  Some programs produce fields with a leading equal sign to indicate that the contents must be represented exactly.
 *  The default value is @c NO.
 *  @warning Do not mutate this property after parsing has begun
 */
@property (nonatomic, assign) BOOL recognizesLeadingEqualSign;

/**
 *  The number of bytes that have been read from the input stream so far
 *
 *  This property is key-value observable.
 */
@property (readonly) NSUInteger totalBytesRead;


/**
 * This method is unavailable, because there is nothing supplied to parse.
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 *  The designated initializer
 *
 *  @param stream    The @c NSInputStream from which bytes will be read and parsed. Must not be @c nil
 *  @param encoding  A pointer to an @c NSStringEncoding. If non-nil, this will be filled in with the encoding used to parse the stream
 *  @param delimiter The delimiter character to be used when parsing the stream. Must not be @c nil, and may not be the double quote character
 *
 *  @return a @c CHCSVParser instance, or @c nil if initialization failed
 */
- (instancetype)initWithInputStream:(NSInputStream *)stream usedEncoding:(inout NSStringEncoding *)encoding delimiter:(unichar)delimiter NS_DESIGNATED_INITIALIZER;

/**
 *  An initializer to parse a CSV string
 *
 *  Internally it calls the designated initializer and provides a stream of the UTF8 representation of the string as well as the comma delimiter.
 *
 *  @param csv The @c NSString to parse. Must not be @c nil
 *
 *  @return a @c CHCSVParser instance, or @c nil if initialization failed
 */
- (instancetype)initWithCSVString:(NSString *)csv;

/**
 *  An initializer to parse a delimited string
 *
 *  Internally it calls the designated initializer and provides a stream of the UTF8 representation of the string as well as the provided delimiter.
 *
 *  @param string The @c NSString to parse. Must not be @c nil
 *  @param delimiter The delimiter character to be used when parsing the string. Must not be @c nil, and may not be the double quote character
 *
 *  @return a @c CHCSVParser instance, or @c nil if initialization failed
 */
- (instancetype)initWithDelimitedString:(NSString *)string delimiter:(unichar)delimiter;

/**
 *  An initializer to parse the contents of URL
 *
 *  Internally it calls the designated initializer and provides a stream to the URL as well as the comma delimiter.
 *  The parser attempts to infer the encoding from the stream.
 *
 *  @param csvURL The @c NSURL to the CSV file
 *
 *  @return a @c CHCSVParser instance, or @c nil if initialization failed
 */
- (instancetype)initWithContentsOfCSVURL:(NSURL *)csvURL;

/**
 *  An initializer to parse the contents of URL
 *
 *  Internally it calls the designated initializer and provides a stream to the URL as well as the provided delimiter.
 *  The parser attempts to infer the encoding from the stream.
 *
 *  @param URL       The @c NSURL to the delimited file
 *  @param delimiter The delimiter character to be used when parsing the string. Must not be @c nil, and may not be the double quote character
 *
 *  @return a @c CHCSVParser instance, or @c nil if initialization failed
 */
- (instancetype)initWithContentsOfDelimitedURL:(NSURL *)URL delimiter:(unichar)delimiter;

/**
 *  Instruct the parser to begin parsing
 *
 *  You should not invoke this method more than once.
 */
- (void)parse;

/**
 *  Instruct the parser to abort parsing
 *
 *  Invoking this method after parsing has completed has no effect.
 */
- (void)cancelParsing;

@end

@interface CHCSVWriter : NSObject

/**
 * This method is unavailable, because there is no way to extract the written CSV.
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 *  Initializes a @c CHCSVWriter to write to the provided file path. Assumes @c NSUTF8Encoding and the comma delimiter
 *
 *  @param path The path to the CSV file
 *
 *  @return a @c CHCSVWriter instance, or @c nil if initialization failed
 */
- (instancetype)initForWritingToCSVFile:(NSString *)path;

/**
 *  The designated initializer
 *
 *  @param stream    The @c NSOutputStream to which bytes will be written. 
 *  If you wish to append to an existing file, you can provide an @c NSOutputStream that is set to append to the target file
 *  @param encoding  The byte encoding to use when writing strings to the stream
 *  @param delimiter The field delimiter to use during writing
 *
 *  @return a @c CHCSVWriter instance, or @c nil if initialization failed
 */
- (instancetype)initWithOutputStream:(NSOutputStream *)stream encoding:(NSStringEncoding)encoding delimiter:(unichar)delimiter NS_DESIGNATED_INITIALIZER;

/**
 *  Write a field to the output stream
 *
 *  If necessary, this will also write a delimiter to the stream as well. This method takes care of all escaping.
 *
 *  @param field The object to be written to the stream
 *  If you provide an object that is not an @c NSString, its @c description will be written to the stream.
 */
- (void)writeField:(id)field;

/**
 *  Write a newline character to the output stream
 */
- (void)finishLine;

/**
 *  Write a series of fields to the stream as a new line
 *
 *  If another line is already in progress, it is terminated and a new line is begun.
 *  This method iteratively invokes @c writeField:, followed by @c finishLine.
 *
 *  @param fields A sequence of fields to be written
 */
- (void)writeLineOfFields:(id<NSFastEnumeration>)fields;

/**
 *  Write the contents of an @c NSDictionary as a new line
 *
 *  @param dictionary The @c NSDictionary whose values will be written to the output stream.
 *  Values will be written in the order specified by the first line of fields written to the stream.
 *  If no lines have been written yet, this method will throw an exception.
 */
- (void)writeLineWithDictionary:(NSDictionary *)dictionary;

/**
 *  Write a comment to the stream
 *
 *  If another line is already in progress, it is terminated and a new line is begun.
 *  The new line will be started with the octothorpe (#) character, followed by the comment.
 *  The comment is terminated using @c finishLine
 *
 *  @param comment The comment to be written to the stream
 */
- (void)writeComment:(NSString *)comment;

/**
 *  Closes the output stream.
 *  You do not have to invoke this method yourself, as it is invoked during deallocation.
 */
- (void)closeStream;

@end

#pragma mark - Convenience Categories

typedef NS_OPTIONS(NSUInteger, CHCSVParserOptions) {
    /**
     *  Allow backslash to escape special characters.
     *  If you specify this option, you may not use a backslash as the delimiter.
     *  @see CHCSVParser.recognizesBackslashesAsEscapes
     */
    CHCSVParserOptionsRecognizesBackslashesAsEscapes = 1 << 0,
    /**
     *  Cleans the field before reporting it.
     *  @see CHCSVParser.sanitizesFields
     */
    CHCSVParserOptionsSanitizesFields = 1 << 1,
    /**
     *  Fields that begin with a "#" will be reported as comments.
     *  If you specify this option, you may not use an octothorpe as the delimiter.
     *  @see CHCSVParser.recognizesComments
     */
    CHCSVParserOptionsRecognizesComments = 1 << 2,
    /**
     *  Trims whitespace around a field.
     *  @see CHCSVParser.trimsWhitespace
     */
    CHCSVParserOptionsTrimsWhitespace = 1 << 3,
    /**
     *  When you specify this option, instead of getting an Array of Arrays of Strings,
     *  you get an Array of @c CHCSVOrderedDictionary instances.
     *  If the file only contains a single line, then an empty array is returned.
     */
    CHCSVParserOptionsUsesFirstLineAsKeys = 1 << 4,
    /**
     *  Some delimited files contain fields that begin with a leading equal sign,
     *  to indicate that the contents should not be summarized or re-interpreted.
     *  (For example, to remove insignificant digits)
     *  If you specify this option, you may not use an equal sign as the delimiter.
     *  @see CHCSVParser.recognizesLeadingEqualSign
     *  @link http://edoceo.com/utilitas/csv-file-format
     */
    CHCSVParserOptionsRecognizesLeadingEqualSign = 1 << 5
};

/**
 *  An @c NSDictionary subclass that maintains a strong ordering of its key-value pairs
 */
@interface CHCSVOrderedDictionary : NSDictionary

- (instancetype)initWithObjects:(NSArray *)objects forKeys:(NSArray *)keys NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (id)objectAtIndex:(NSUInteger)idx;

@end

@interface NSArray (CHCSVAdditions)

/**
 *  A convenience constructor to parse a CSV file
 *
 *  @param fileURL The @c NSURL to the CSV file
 *
 *  @return An @c NSArray of @c NSArrays of @c NSStrings, if parsing succeeds; @c nil otherwise
 */
+ (instancetype)arrayWithContentsOfCSVURL:(NSURL *)fileURL;

/**
 *  A convenience constructor to parse a CSV file
 *
 *  @param fileURL The @c NSURL to the CSV file
 *  @param options A bitwise-OR of @c CHCSVParserOptions to control how parsing should occur
 *
 *  @return An @c NSArray of @c NSArrays of @c NSStrings, if parsing succeeds; @c nil otherwise
 */
+ (instancetype)arrayWithContentsOfCSVURL:(NSURL *)fileURL options:(CHCSVParserOptions)options;

/**
 *  A convenience constructor to parse a delimited file
 *
 *  @param fileURL   The @c NSURL to the delimited file
 *  @param delimiter The delimiter used in the file
 *
 *  @return An @c NSArray of @c NSArrays of @c NSStrings, if parsing succeeds; @c nil otherwise
 */
+ (instancetype)arrayWithContentsOfDelimitedURL:(NSURL *)fileURL delimiter:(unichar)delimiter;

/**
 *  A convenience constructor to parse a delimited file
 *
 *  @param fileURL   The @c NSURL to the delimited file
 *  @param options   A bitwise-OR of @c CHCSVParserOptions to control how parsing should occur
 *  @param delimiter The delimiter used in the file
 *
 *  @return An @c NSArray of @c NSArrays of @c NSStrings, if parsing succeeds; @c nil otherwise
 */
+ (instancetype)arrayWithContentsOfDelimitedURL:(NSURL *)fileURL options:(CHCSVParserOptions)options delimiter:(unichar)delimiter;

/**
 *  A convenience constructor to parse a delimited file
 *
 *  @param fileURL   The @c NSURL to the delimited file
 *  @param options   A bitwise-OR of @c CHCSVParserOptions to control how parsing should occur
 *  @param delimiter The delimiter used in the file
 *  @param error     A pointer to an @c NSError*, which will be filled in if parsing fails
 *
 *  @return An @c NSArray of @c NSArrays of @c NSStrings, if parsing succeeds; @c nil otherwise.
 */
+ (instancetype)arrayWithContentsOfDelimitedURL:(NSURL *)fileURL options:(CHCSVParserOptions)options delimiter:(unichar)delimiter error:(NSError *__autoreleasing *)error;

/**
 *  If the receiver is an @c NSArray of @c NSArrays of objects, this will turn it into a comma-delimited string
 *  Returns the string of CSV, if writing succeeds; @c nil otherwise.
 */
- (NSString *)CSVString;

@end

@interface NSString (CHCSVAdditions)

/**
 *  Parses the receiver as a comma-delimited string
 *  @return An @c NSArray of @c NSArrays of @c NSStrings, if parsing succeeds; @c nil otherwise.
 */
@property (nonatomic, readonly) NSArray *CSVComponents;

/**
 *  Parses the receiver as a comma-delimited string
 *
 *  @param options A bitwise-OR of @c CHCSVParserOptions to control how parsing should occur
 *
 *  @return An @c NSArray of @c NSArrays of @c NSStrings, if parsing succeeds; @c nil otherwise.
 */
- (NSArray *)CSVComponentsWithOptions:(CHCSVParserOptions)options;

/**
 *  Parses the receiver as a delimited string
 *
 *  @param delimiter The delimiter used in the string
 *
 *  @return An @c NSArray of @c NSArrays of @c NSStrings, if parsing succeeds; @c nil otherwise.
 */
- (NSArray *)componentsSeparatedByDelimiter:(unichar)delimiter;

/**
 *  Parses the receiver as a delimited string
 *
 *  @param delimiter The delimiter used in the string
 *  @param options   A bitwise-OR of @c CHCSVParserOptions to control how parsing should occur
 *
 *  @return An @c NSArray of @c NSArrays of @c NSStrings, if parsing succeeds; @c nil otherwise.
 */
- (NSArray *)componentsSeparatedByDelimiter:(unichar)delimiter options:(CHCSVParserOptions)options;

/**
 *  Parses the receiver as a delimited string
 *
 *  @param delimiter The delimiter used in the string
 *  @param options   A bitwise-OR of @c CHCSVParserOptions to control how parsing should occur
 *  @param error     A pointer to an @c NSError*, which will be filled in if parsing fails
 *
 *  @return An @c NSArray of @c NSArrays of @c NSStrings, if parsing succeeds; @c nil otherwise.
 */
- (NSArray *)componentsSeparatedByDelimiter:(unichar)delimiter options:(CHCSVParserOptions)options error:(NSError *__autoreleasing *)error;

@end

#pragma mark - Deprecated stuff

/**
 * These methods have been deprecated, but are preserved here for source compatibility.
 * They will be removed in the future.
 */

@interface CHCSVParser (Deprecated)

@property (nonatomic, assign) BOOL stripsLeadingAndTrailingWhitespace CHCSV_DEPRECATED(@"use .trimsWhitespace instead"); // default is NO

- (instancetype)initWithCSVString:(NSString *)csv delimiter:(unichar)delimiter CHCSV_DEPRECATED("use -initWithDelimitedString:delimiter: instead");
- (instancetype)initWithContentsOfCSVFile:(NSString *)csvFilePath CHCSV_DEPRECATED("use -initWithContentsOfCSVURL: instead");
- (instancetype)initWithContentsOfCSVFile:(NSString *)csvFilePath delimiter:(unichar)delimiter CHCSV_DEPRECATED("use -initWithContentsOfDelimitedURL:delimiter: instead");

@end

@interface NSArray (CHCSVAdditions_Deprecated)

+ (instancetype)arrayWithContentsOfCSVFile:(NSString *)csvFilePath CHCSV_DEPRECATED("Use +arrayWithContentsOfCSVURL: instead");
+ (instancetype)arrayWithContentsOfCSVFile:(NSString *)csvFilePath delimiter:(unichar)delimiter CHCSV_DEPRECATED("Use +arrayWithContentsOfDelimitedURL:delimiter: instead");
+ (instancetype)arrayWithContentsOfCSVFile:(NSString *)csvFilePath options:(CHCSVParserOptions)options CHCSV_DEPRECATED("Use +arrayWithContentsOfCSVURL:options: instead");
+ (instancetype)arrayWithContentsOfCSVFile:(NSString *)csvFilePath options:(CHCSVParserOptions)options delimiter:(unichar)delimiter CHCSV_DEPRECATED("Use +arrayWithContentsOfDelimitedURL:options:delimiter: instead");
+ (instancetype)arrayWithContentsOfCSVFile:(NSString *)csvFilePath options:(CHCSVParserOptions)options delimiter:(unichar)delimiter error:(NSError *__autoreleasing *)error CHCSV_DEPRECATED("Use +arrayWithContentsOfDelimitedURL:options:delimiter:error: instead");

@end

@interface NSString (CHCSVAdditions_Deprecated)

- (NSArray *)CSVComponentsWithDelimiter:(unichar)delimiter CHCSV_DEPRECATED("Use -componentsSeparatedByDelimiter: instead");
- (NSArray *)CSVComponentsWithOptions:(CHCSVParserOptions)options delimiter:(unichar)delimiter CHCSV_DEPRECATED("Use -componentsSeparatedByDelimiter:options: instead");
- (NSArray *)CSVComponentsWithOptions:(CHCSVParserOptions)options delimiter:(unichar)delimiter error:(NSError *__autoreleasing *)error CHCSV_DEPRECATED("Use -componentsSeparatedByDelimiter:options:error: instead");

@end
