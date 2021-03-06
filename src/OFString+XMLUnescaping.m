/*
 * Copyright (c) 2008, 2009, 2010, 2011, 2012, 2013
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

#include "config.h"

#include <string.h>

#import "OFString.h"

#import "OFInvalidEncodingException.h"

#import "autorelease.h"
#import "macros.h"

int _OFString_XMLUnescaping_reference;

static OF_INLINE OFString*
parse_numeric_entity(const char *entity, size_t length)
{
	of_unichar_t c;
	size_t i;
	char buffer[5];

	if (length == 1 || *entity != '#')
		return nil;

	c = 0;
	entity++;
	length--;

	if (entity[0] == 'x') {
		if (length == 1)
			return nil;

		entity++;
		length--;

		for (i = 0; i < length; i++) {
			if (entity[i] >= '0' && entity[i] <= '9')
				c = (c << 4) | (entity[i] - '0');
			else if (entity[i] >= 'A' && entity[i] <= 'F')
				c = (c << 4) | (entity[i] - 'A' + 10);
			else if (entity[i] >= 'a' && entity[i] <= 'f')
				c = (c << 4) | (entity[i] - 'a' + 10);
			else
				return nil;
		}
	} else {
		for (i = 0; i < length; i++) {
			if (entity[i] >= '0' && entity[i] <= '9')
				c = (c * 10) + (entity[i] - '0');
			else
				return nil;
		}
	}

	if ((i = of_string_utf8_encode(c, buffer)) == 0)
		return nil;
	buffer[i] = 0;

	return [OFString stringWithUTF8String: buffer
				       length: i];
}

@implementation OFString (XMLUnescaping)
- (OFString*)stringByXMLUnescaping
{
	return [self stringByXMLUnescapingWithDelegate: nil];
}

- (OFString*)stringByXMLUnescapingWithDelegate:
    (id <OFStringXMLUnescapingDelegate>)delegate
{
	const char *string;
	size_t i, last, length;
	bool inEntity;
	OFMutableString *ret;

	string = [self UTF8String];
	length = [self UTF8StringLength];

	ret = [OFMutableString string];

	last = 0;
	inEntity = false;

	for (i = 0; i < length; i++) {
		if (!inEntity && string[i] == '&') {
			[ret appendUTF8String: string + last
				       length: i - last];

			last = i + 1;
			inEntity = true;
		} else if (inEntity && string[i] == ';') {
			const char *entity = string + last;
			size_t entityLength = i - last;

			if (entityLength == 2 && !memcmp(entity, "lt", 2))
				[ret appendCString: "<"
					  encoding: OF_STRING_ENCODING_ASCII
					    length: 1];
			else if (entityLength == 2 && !memcmp(entity, "gt", 2))
				[ret appendCString: ">"
					  encoding: OF_STRING_ENCODING_ASCII
					    length: 1];
			else if (entityLength == 4 &&
			    !memcmp(entity, "quot", 4))
				[ret appendCString: "\""
					  encoding: OF_STRING_ENCODING_ASCII
					    length: 1];
			else if (entityLength == 4 &&
			    !memcmp(entity, "apos", 4))
				[ret appendCString: "'"
					  encoding: OF_STRING_ENCODING_ASCII
					    length: 1];
			else if (entityLength == 3 && !memcmp(entity, "amp", 3))
				[ret appendCString: "&"
					  encoding: OF_STRING_ENCODING_ASCII
					    length: 1];
			else if (entity[0] == '#') {
				void *pool;
				OFString *tmp;

				pool = objc_autoreleasePoolPush();
				tmp = parse_numeric_entity(entity,
				    entityLength);

				if (tmp == nil)
					@throw [OFInvalidEncodingException
					    exceptionWithClass: [self class]];

				[ret appendString: tmp];
				objc_autoreleasePoolPop(pool);
			} else if (delegate != nil) {
				void *pool;
				OFString *n, *tmp;

				pool = objc_autoreleasePoolPush();

				n = [OFString
				    stringWithUTF8String: entity
						  length: entityLength];
				tmp =	  [delegate string: self
				containsUnknownEntityNamed: n];

				if (tmp == nil)
					@throw [OFInvalidEncodingException
					    exceptionWithClass: [self class]];

				[ret appendString: tmp];
				objc_autoreleasePoolPop(pool);
			} else
				@throw [OFInvalidEncodingException
				    exceptionWithClass: [self class]];

			last = i + 1;
			inEntity = false;
		}
	}

	if (inEntity)
		@throw [OFInvalidEncodingException
		    exceptionWithClass: [self class]];

	[ret appendUTF8String: string + last
		       length: i - last];

	[ret makeImmutable];

	return ret;
}

#ifdef OF_HAVE_BLOCKS
- (OFString*)stringByXMLUnescapingWithBlock:
    (of_string_xml_unescaping_block_t)block
{
	const char *string;
	size_t i, last, length;
	bool inEntity;
	OFMutableString *ret;

	string = [self UTF8String];
	length = [self UTF8StringLength];

	ret = [OFMutableString string];

	last = 0;
	inEntity = false;

	for (i = 0; i < length; i++) {
		if (!inEntity && string[i] == '&') {
			[ret appendUTF8String: string + last
				       length: i - last];

			last = i + 1;
			inEntity = true;
		} else if (inEntity && string[i] == ';') {
			const char *entity = string + last;
			size_t entityLength = i - last;

			if (entityLength == 2 && !memcmp(entity, "lt", 2))
				[ret appendCString: "<"
					  encoding: OF_STRING_ENCODING_ASCII
					    length: 1];
			else if (entityLength == 2 && !memcmp(entity, "gt", 2))
				[ret appendCString: ">"
					  encoding: OF_STRING_ENCODING_ASCII
					    length: 1];
			else if (entityLength == 4 &&
			    !memcmp(entity, "quot", 4))
				[ret appendCString: "\""
					  encoding: OF_STRING_ENCODING_ASCII
					    length: 1];
			else if (entityLength == 4 &&
			    !memcmp(entity, "apos", 4))
				[ret appendCString: "'"
					  encoding: OF_STRING_ENCODING_ASCII
					    length: 1];
			else if (entityLength == 3 && !memcmp(entity, "amp", 3))
				[ret appendCString: "&"
					  encoding: OF_STRING_ENCODING_ASCII
					    length: 1];
			else if (entity[0] == '#') {
				void *pool;
				OFString *tmp;

				pool = objc_autoreleasePoolPush();
				tmp = parse_numeric_entity(entity,
				    entityLength);

				if (tmp == nil)
					@throw [OFInvalidEncodingException
					    exceptionWithClass: [self class]];

				[ret appendString: tmp];
				objc_autoreleasePoolPop(pool);
			} else {
				void *pool;
				OFString *entityString, *tmp;

				pool = objc_autoreleasePoolPush();

				entityString = [OFString
				    stringWithUTF8String: entity
						  length: entityLength];
				tmp = block(self, entityString);

				if (tmp == nil)
					@throw [OFInvalidEncodingException
					    exceptionWithClass: [self class]];

				[ret appendString: tmp];
				objc_autoreleasePoolPop(pool);
			}

			last = i + 1;
			inEntity = false;
		}
	}

	if (inEntity)
		@throw [OFInvalidEncodingException
		    exceptionWithClass: [self class]];

	[ret appendUTF8String: string + last
		       length: i - last];

	[ret makeImmutable];

	return ret;
}
#endif
@end
