/*
 * Copyright (c) 2008, 2009, 2010, 2011
 *   Jonathan Schleifer <js@webkeks.org>
 *
 * All rights reserved.
 *
 * This file is part of ObjFW. It may be distributed under the terms of the
 * Q Public License 1.0, which can be found in the file LICENSE.QPL included in
 * the packaging of this file.
 *
 * Alternatively, it may be distributed under the terms of the GNU General
 * Public License, either version 2 or 3, which can be found in the file
 * LICENSE.GPLv2 or LICENSE.GPLv3 respectively included in the packaging of this
 * file.
 */

#include <stdio.h>
#include <stdarg.h>
#include <inttypes.h>

#import "OFObject.h"

typedef uint32_t of_unichar_t;

/**
 * \brief The encoding of a string.
 */
typedef enum of_string_encoding_t {
	OF_STRING_ENCODING_UTF_8,
	OF_STRING_ENCODING_ISO_8859_1,
	OF_STRING_ENCODING_ISO_8859_15,
	OF_STRING_ENCODING_WINDOWS_1252
} of_string_encoding_t;

#ifdef __cplusplus
extern "C" {
#endif
extern int of_string_check_utf8(const char*, size_t);
extern size_t of_string_unicode_to_utf8(of_unichar_t, char*);
extern size_t of_string_utf8_to_unicode(const char*, size_t, of_unichar_t*);
extern size_t of_string_position_to_index(const char*, size_t);
extern size_t of_string_index_to_position(const char*, size_t, size_t);
#ifdef __cplusplus
}
#endif

@class OFArray;
@class OFURL;

/**
 * \brief A class for handling strings.
 */
@interface OFString: OFObject <OFCopying, OFMutableCopying, OFComparing>
{
	char   *string;
	size_t length;
	BOOL   isUTF8;
}

/**
 * \return A new autoreleased OFString
 */
+ string;

/**
 * Creates a new OFString from a UTF-8 encoded C string.
 *
 * \param str A UTF-8 encoded C string to initialize the OFString with
 * \return A new autoreleased OFString
 */
+ stringWithCString: (const char*)str;

/**
 * Creates a new OFString from a C string with the specified encoding.
 *
 * \param str A C string to initialize the OFString with
 * \param encoding The encoding of the C string
 * \return A new autoreleased OFString
 */
+ stringWithCString: (const char*)str
	   encoding: (of_string_encoding_t)encoding;

/**
 * Creates a new OFString from a C string with the specified encoding and
 * length.
 *
 * \param str A C string to initialize the OFString with
 * \param encoding The encoding of the C string
 * \param len The length of the C string
 * \return A new autoreleased OFString
 */
+ stringWithCString: (const char*)str
	   encoding: (of_string_encoding_t)encoding
	     length: (size_t)len;

/**
 * Creates a new OFString from a UTF-8 encoded C string with the specified
 * length.
 *
 * \param str A UTF-8 encoded C string to initialize the OFString with
 * \param len The length of the UTF-8 encoded C string
 * \return A new autoreleased OFString
 */
+ stringWithCString: (const char*)str
	     length: (size_t)len;

/**
 * Creates a new OFString from a format string.
 * See printf for the format syntax.
 *
 * \param fmt A string used as format to initialize the OFString
 * \return A new autoreleased OFString
 */
+ stringWithFormat: (OFString*)fmt, ...;

/**
 * Creates a new OFString containing the constructed specified path.
 *
 * \param first The first component of the path
 * \return A new autoreleased OFString
 */
+ stringWithPath: (OFString*)first, ...;

/**
 * Creates a new OFString from another string.
 *
 * \param str A string to initialize the OFString with
 * \return A new autoreleased OFString
 */
+ stringWithString: (OFString*)str;

/**
 * Creates a new OFString with the contents of the specified UTF-8 encoded file.
 *
 * \param path The path to the file
 * \return A new autoreleased OFString
 */
+ stringWithContentsOfFile: (OFString*)path;

/**
 * Creates a new OFString with the contents of the specified file in the
 * specified encoding.
 *
 * \param path The path to the file
 * \param encoding The encoding of the file
 * \return A new autoreleased OFString
 */
+ stringWithContentsOfFile: (OFString*)path
		  encoding: (of_string_encoding_t)encoding;

/**
 * Creates a new OFString with the contents of the specified URL, assuming
 * UTF-8 encoding.
 *
 * \param url The URL to the contents for the string
 * \return A new autoreleased OFString
 */
+ stringWithContentsOfURL: (OFURL*)url;

/**
 * Creates a new OFString with the contents of the specified URL in the
 * specified encoding.
 *
 * \param url The URL to the contents for the string
 * \param encoding The encoding to assume
 * \return A new autoreleased OFString
 */
+ stringWithContentsOfURL: (OFURL*)url
		 encoding: (of_string_encoding_t)encoding;

/**
 * Initializes an already allocated OFString from a UTF-8 encoded C string.
 *
 * \param str A UTF-8 encoded C string to initialize the OFString with
 * \return An initialized OFString
 */
- initWithCString: (const char*)str;

/**
 * Initializes an already allocated OFString from a C string with the specified
 * encoding.
 *
 * \param str A C string to initialize the OFString with
 * \param encoding The encoding of the C string
 * \return An initialized OFString
 */
- initWithCString: (const char*)str
	 encoding: (of_string_encoding_t)encoding;

/**
 * Initializes an already allocated OFString from a C string with the specified
 * encoding and length.
 *
 * \param str A C string to initialize the OFString with
 * \param encoding The encoding of the C string
 * \param len The length of the C string
 * \return An initialized OFString
 */
- initWithCString: (const char*)str
	 encoding: (of_string_encoding_t)encoding
	   length: (size_t)len;

/**
 * Initializes an already allocated OFString from a UTF-8 encoded C string with
 * the specified length.
 *
 * \param str A UTF-8 encoded C string to initialize the OFString with
 * \param len The length of the UTF-8 encoded C string
 * \return An initialized OFString
 */
- initWithCString: (const char*)str
	   length: (size_t)len;

/**
 * Initializes an already allocated OFString with a format string.
 * See printf for the format syntax.
 *
 * \param fmt A string used as format to initialize the OFString
 * \return An initialized OFString
 */
- initWithFormat: (OFString*)fmt, ...;

/**
 * Initializes an already allocated OFString with a format string.
 * See printf for the format syntax.
 *
 * \param fmt A string used as format to initialize the OFString
 * \param args The arguments used in the format string
 * \return An initialized OFString
 */
- initWithFormat: (OFString*)fmt
       arguments: (va_list)args;

/**
 * Initializes an already allocated OFString with the constructed specified
 * path.
 *
 * \param first The first component of the path
 * \return A new autoreleased OFString
 */
- initWithPath: (OFString*)first, ...;

/**
 * Initializes an already allocated OFString with the constructed specified
 * path.
 *
 * \param first The first component of the path
 * \param args A va_list with the other components of the path
 * \return A new autoreleased OFString
 */
- initWithPath: (OFString*)first
     arguments: (va_list)args;

/**
 * Initializes an already allocated OFString with another string.
 *
 * \param str A string to initialize the OFString with
 * \return An initialized OFString
 */
- initWithString: (OFString*)str;

/**
 * Initializes an already allocated OFString with the contents of the specified
 * file in the specified encoding.
 *
 * \param path The path to the file
 * \return An initialized OFString
 */
- initWithContentsOfFile: (OFString*)path;

/**
 * Initializes an already allocated OFString with the contents of the specified
 * file in the specified encoding.
 *
 * \param path The path to the file
 * \param encoding The encoding of the file
 * \return An initialized OFString
 */
- initWithContentsOfFile: (OFString*)path
		encoding: (of_string_encoding_t)encoding;

/**
 * Initializes an already allocated OFString with the contents of the specified
 * URL, assuming UTF-8 encoding.
 *
 * \param url The URL to the contents for the string
 * \return An initialized OFString
 */
- initWithContentsOfURL: (OFURL*)url;

/**
 * Initializes an already allocated OFString with the contents of the specified
 * URL in the specified encoding.
 *
 * \param url The URL to the contents for the string
 * \param encoding The encoding to assume
 * \return An initialized OFString
 */
- initWithContentsOfURL: (OFURL*)url
	       encoding: (of_string_encoding_t)encoding;

/**
 * \return The OFString as a UTF-8 encoded C string
 */
- (const char*)cString;

/**
 * \return The length of the string in Unicode characters
 */
- (size_t)length;

/**
 * \return The length of the string which cString would return
 */
- (size_t)cStringLength;

/// \cond internal
- (BOOL)isUTF8;
/// \endcond

/**
 * Compares the OFString to another OFString without caring about the case.
 *
 * \param str A string to compare with
 * \return An of_comparison_result_t
 */
- (of_comparison_result_t)caseInsensitiveCompare: (OFString*)str;

/**
 * \param index The index of the Unicode character to return
 * \return The Unicode character at the specified index
 */
- (of_unichar_t)characterAtIndex: (size_t)index;

/**
 * \param str The string to search
 * \return The index of the first occurrence of the string or SIZE_MAX if it
 *	   was not found
 */
- (size_t)indexOfFirstOccurrenceOfString: (OFString*)str;

/**
 * \param str The string to search
 * \return The index of the last occurrence of the string or SIZE_MAX if it
 *	   was not found
 */
- (size_t)indexOfLastOccurrenceOfString: (OFString*)str;

/**
 * \param str The string to search
 * \return Whether the string contains the specified string
 */
- (BOOL)containsString: (OFString*)str;

/**
 * \param start The index where the substring starts
 * \param end The index where the substring ends.
 *	      This points BEHIND the last character!
 * \return The substring as a new autoreleased OFString
 */
- (OFString*)substringFromIndex: (size_t)start
			toIndex: (size_t)end;

/**
 * \param range The range of the substring
 * \return The substring as a new autoreleased OFString
 */
- (OFString*)substringWithRange: (of_range_t)range;

/**
 * Creates a new string by appending another string.
 *
 * \param str The string to append
 * \return A new autoreleased OFString with the specified string appended
 */
- (OFString*)stringByAppendingString: (OFString*)str;

/**
 * Creates a new string by deleting leading whitespaces.
 *
 * \return A new autoreleased OFString with leading whitespaces deleted
 */
- (OFString*)stringByDeletingLeadingWhitespaces;

/**
 * Creates a new string by deleting trailing whitespaces.
 *
 * \return A new autoreleased OFString with trailing whitespaces deleted
 */
- (OFString*)stringByDeletingTrailingWhitespaces;

/**
 * Creates a new string by deleting leading and trailing whitespaces.
 *
 * \return A new autoreleased OFString with leading and trailing whitespaces
 *	   deleted
 */
- (OFString*)stringByDeletingLeadingAndTrailingWhitespaces;

/**
 * Checks whether the string has the specified prefix.
 *
 * \param prefix The prefix to check for
 * \return A boolean whether the string has the specified prefix
 */
- (BOOL)hasPrefix: (OFString*)prefix;

/**
 * Checks whether the string has the specified suffix.
 *
 * \param suffix The suffix to check for
 * \return A boolean whether the string has the specified suffix
 */
- (BOOL)hasSuffix: (OFString*)suffix;

/**
 * Splits an OFString into an OFArray of OFStrings.
 *
 * \param delimiter The delimiter for splitting
 * \return An autoreleased OFArray with the splitted string
 */
- (OFArray*)componentsSeparatedByString: (OFString*)delimiter;

/**
 * \return The components of the path
 */
- (OFArray*)pathComponents;

/**
 * \return The last component of the path
 */
- (OFString*)lastPathComponent;

/**
 * \return The directory name of the path
 */
- (OFString*)stringByDeletingLastPathComponent;

/**
 * Returns the decimal value of the string as an intmax_t or throws an
 * OFInvalidEncoding exception if the string contains any non-number characters.
 *
 * \return An intmax_t with the value of the string
 */
- (intmax_t)decimalValue;

/**
 * Returns the hexadecimal value of the string as an intmax_t or throws an
 * OFInvalidEncoding exception if the string contains any non-number characters.
 *
 * \return A uintmax_t with the value of the string
 */
- (uintmax_t)hexadecimalValue;

/**
 * Returns the string as an array of of_unichar_t. The result needs to be
 * free()'d by the caller, as the memory is not marked as belonging to the
 * object.
 *
 * \return The string as an array of Unicode characters
 */
- (of_unichar_t*)unicodeString;

/**
 * Writes the string into the specified file using UTF-8 encoding.
 *
 * \param path The path of the file to write to
 */
- (void)writeToFile: (OFString*)path;
@end

#import "OFConstantString.h"
#import "OFMutableString.h"
#import "OFString+Hashing.h"
#import "OFString+URLEncoding.h"
#import "OFString+XMLEscaping.h"
#import "OFString+XMLUnescaping.h"
