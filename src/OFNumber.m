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

#include <stdlib.h>

#include <math.h>

#import "OFNumber.h"
#import "OFString.h"
#import "OFXMLElement.h"
#import "OFXMLAttribute.h"
#import "OFDataArray.h"

#import "OFInvalidArgumentException.h"
#import "OFInvalidFormatException.h"
#import "OFOutOfRangeException.h"

#import "autorelease.h"
#import "macros.h"

#define RETURN_AS(t)							\
	switch (_type) {						\
	case OF_NUMBER_BOOL:						\
		return (t)_value.bool_;					\
	case OF_NUMBER_CHAR:						\
		return (t)_value.schar;					\
	case OF_NUMBER_SHORT:						\
		return (t)_value.sshort;				\
	case OF_NUMBER_INT:						\
		return (t)_value.sint;					\
	case OF_NUMBER_LONG:						\
		return (t)_value.slong;					\
	case OF_NUMBER_LONGLONG:					\
		return (t)_value.slonglong;				\
	case OF_NUMBER_UCHAR:						\
		return (t)_value.uchar;					\
	case OF_NUMBER_USHORT:						\
		return (t)_value.ushort;				\
	case OF_NUMBER_UINT:						\
		return (t)_value.uint;					\
	case OF_NUMBER_ULONG:						\
		return (t)_value.ulong;					\
	case OF_NUMBER_ULONGLONG:					\
		return (t)_value.ulonglong;				\
	case OF_NUMBER_INT8:						\
		return (t)_value.int8;					\
	case OF_NUMBER_INT16:						\
		return (t)_value.int16;					\
	case OF_NUMBER_INT32:						\
		return (t)_value.int32;					\
	case OF_NUMBER_INT64:						\
		return (t)_value.int64;					\
	case OF_NUMBER_UINT8:						\
		return (t)_value.uint8;					\
	case OF_NUMBER_UINT16:						\
		return (t)_value.uint16;				\
	case OF_NUMBER_UINT32:						\
		return (t)_value.uint32;				\
	case OF_NUMBER_UINT64:						\
		return (t)_value.uint64;				\
	case OF_NUMBER_SIZE:						\
		return (t)_value.size;					\
	case OF_NUMBER_SSIZE:						\
		return (t)_value.ssize;					\
	case OF_NUMBER_INTMAX:						\
		return (t)_value.intmax;				\
	case OF_NUMBER_UINTMAX:						\
		return (t)_value.uintmax;				\
	case OF_NUMBER_PTRDIFF:						\
		return (t)_value.ptrdiff;				\
	case OF_NUMBER_INTPTR:						\
		return (t)_value.intptr;				\
	case OF_NUMBER_UINTPTR:						\
		return (t)_value.uintptr;				\
	case OF_NUMBER_FLOAT:						\
		return (t)_value.float_;				\
	case OF_NUMBER_DOUBLE:						\
		return (t)_value.double_;				\
	default:							\
		@throw [OFInvalidFormatException			\
		    exceptionWithClass: [self class]];			\
	}
#define CALCULATE(o, n)							\
	switch (_type) {						\
	case OF_NUMBER_BOOL:						\
		return [OFNumber numberWithBool:			\
		    _value.bool_ o [n boolValue]];			\
	case OF_NUMBER_CHAR:						\
		return [OFNumber numberWithChar:			\
		    _value.schar o [n charValue]];			\
	case OF_NUMBER_SHORT:						\
		return [OFNumber numberWithShort:			\
		    _value.sshort o [n shortValue]];			\
	case OF_NUMBER_INT:						\
		return [OFNumber numberWithInt:				\
		    _value.sint o [n intValue]];			\
	case OF_NUMBER_LONG:						\
		return [OFNumber numberWithLong:			\
		    _value.slong o [n longValue]];			\
	case OF_NUMBER_LONGLONG:					\
		return [OFNumber numberWithLongLong:			\
		    _value.slonglong o [n longLongValue]];		\
	case OF_NUMBER_UCHAR:						\
		return [OFNumber numberWithUnsignedChar:		\
		    _value.uchar o [n unsignedCharValue]];		\
	case OF_NUMBER_USHORT:						\
		return [OFNumber numberWithUnsignedShort:		\
		    _value.ushort o [n unsignedShortValue]];		\
	case OF_NUMBER_UINT:						\
		return [OFNumber numberWithUnsignedInt:			\
		    _value.uint o [n unsignedIntValue]];		\
	case OF_NUMBER_ULONG:						\
		return [OFNumber numberWithUnsignedLong:		\
		    _value.ulong o [n unsignedLongValue]];		\
	case OF_NUMBER_ULONGLONG:					\
		return [OFNumber numberWithUnsignedLongLong:		\
		    _value.ulonglong o [n unsignedLongLongValue]];	\
	case OF_NUMBER_INT8:						\
		return [OFNumber numberWithInt8:			\
		    _value.int8 o [n int8Value]];			\
	case OF_NUMBER_INT16:						\
		return [OFNumber numberWithInt16:			\
		    _value.int16 o [n int16Value]];			\
	case OF_NUMBER_INT32:						\
		return [OFNumber numberWithInt32:			\
		    _value.int32 o [n int32Value]];			\
	case OF_NUMBER_INT64:						\
		return [OFNumber numberWithInt64:			\
		    _value.int64 o [n int64Value]];			\
	case OF_NUMBER_UINT8:						\
		return [OFNumber numberWithUInt8:			\
		    _value.uint8 o [n uInt8Value]];			\
	case OF_NUMBER_UINT16:						\
		return [OFNumber numberWithUInt16:			\
		    _value.uint16 o [n uInt16Value]];			\
	case OF_NUMBER_UINT32:						\
		return [OFNumber numberWithUInt32:			\
		    _value.uint32 o [n uInt32Value]];			\
	case OF_NUMBER_UINT64:						\
		return [OFNumber numberWithUInt64:			\
		    _value.uint64 o [n uInt64Value]];			\
	case OF_NUMBER_SIZE:						\
		return [OFNumber numberWithSize:			\
		    _value.size o [n sizeValue]];			\
	case OF_NUMBER_SSIZE:						\
		return [OFNumber numberWithSSize:			\
		    _value.ssize o [n sSizeValue]];			\
	case OF_NUMBER_INTMAX:						\
		return [OFNumber numberWithIntMax:			\
		    _value.intmax o [n intMaxValue]];			\
	case OF_NUMBER_UINTMAX:						\
		return [OFNumber numberWithUIntMax:			\
		    _value.uintmax o [n uIntMaxValue]];			\
	case OF_NUMBER_PTRDIFF:						\
		return [OFNumber numberWithPtrDiff:			\
		    _value.ptrdiff o [n ptrDiffValue]];			\
	case OF_NUMBER_INTPTR:						\
		return [OFNumber numberWithIntPtr:			\
		    _value.intptr o [n intPtrValue]];			\
	case OF_NUMBER_UINTPTR:						\
		return [OFNumber numberWithUIntPtr:			\
		    _value.uintptr o [n uIntPtrValue]];			\
	case OF_NUMBER_FLOAT:						\
		return [OFNumber numberWithFloat:			\
		    _value.float_ o [n floatValue]];			\
	case OF_NUMBER_DOUBLE:						\
		return [OFNumber numberWithDouble:			\
		    _value.double_ o [n doubleValue]];			\
	default:							\
		@throw [OFInvalidFormatException			\
		    exceptionWithClass: [self class]];			\
	}
#define CALCULATE2(o, n)						\
	switch (_type) {						\
	case OF_NUMBER_BOOL:						\
		return [OFNumber numberWithBool:			\
		    _value.bool_ o [n boolValue]];			\
	case OF_NUMBER_CHAR:						\
		return [OFNumber numberWithChar:			\
		    _value.schar o [n charValue]];			\
	case OF_NUMBER_SHORT:						\
		return [OFNumber numberWithShort:			\
		    _value.sshort o [n shortValue]];			\
	case OF_NUMBER_INT:						\
		return [OFNumber numberWithInt:				\
		    _value.sint o [n intValue]];			\
	case OF_NUMBER_LONG:						\
		return [OFNumber numberWithLong:			\
		    _value.slong o [n longValue]];			\
	case OF_NUMBER_LONGLONG:					\
		return [OFNumber numberWithLongLong:			\
		    _value.slonglong o [n longLongValue]];		\
	case OF_NUMBER_UCHAR:						\
		return [OFNumber numberWithUnsignedChar:		\
		    _value.uchar o [n unsignedCharValue]];		\
	case OF_NUMBER_USHORT:						\
		return [OFNumber numberWithUnsignedShort:		\
		    _value.ushort o [n unsignedShortValue]];		\
	case OF_NUMBER_UINT:						\
		return [OFNumber numberWithUnsignedInt:			\
		    _value.uint o [n unsignedIntValue]];		\
	case OF_NUMBER_ULONG:						\
		return [OFNumber numberWithUnsignedLong:		\
		    _value.ulong o [n unsignedLongValue]];		\
	case OF_NUMBER_ULONGLONG:					\
		return [OFNumber numberWithUnsignedLongLong:		\
		    _value.ulonglong o [n unsignedLongLongValue]];	\
	case OF_NUMBER_INT8:						\
		return [OFNumber numberWithInt8:			\
		    _value.int8 o [n int8Value]];			\
	case OF_NUMBER_INT16:						\
		return [OFNumber numberWithInt16:			\
		    _value.int16 o [n int16Value]];			\
	case OF_NUMBER_INT32:						\
		return [OFNumber numberWithInt32:			\
		    _value.int32 o [n int32Value]];			\
	case OF_NUMBER_INT64:						\
		return [OFNumber numberWithInt64:			\
		    _value.int64 o [n int64Value]];			\
	case OF_NUMBER_UINT8:						\
		return [OFNumber numberWithUInt8:			\
		    _value.uint8 o [n uInt8Value]];			\
	case OF_NUMBER_UINT16:						\
		return [OFNumber numberWithUInt16:			\
		    _value.uint16 o [n uInt16Value]];			\
	case OF_NUMBER_UINT32:						\
		return [OFNumber numberWithUInt32:			\
		    _value.uint32 o [n uInt32Value]];			\
	case OF_NUMBER_UINT64:						\
		return [OFNumber numberWithUInt64:			\
		    _value.uint64 o [n uInt64Value]];			\
	case OF_NUMBER_SIZE:						\
		return [OFNumber numberWithSize:			\
		    _value.size o [n sizeValue]];			\
	case OF_NUMBER_SSIZE:						\
		return [OFNumber numberWithSSize:			\
		    _value.ssize o [n sSizeValue]];			\
	case OF_NUMBER_INTMAX:						\
		return [OFNumber numberWithIntMax:			\
		    _value.intmax o [n intMaxValue]];			\
	case OF_NUMBER_UINTMAX:						\
		return [OFNumber numberWithUIntMax:			\
		    _value.uintmax o [n uIntMaxValue]];			\
	case OF_NUMBER_PTRDIFF:						\
		return [OFNumber numberWithPtrDiff:			\
		    _value.ptrdiff o [n ptrDiffValue]];			\
	case OF_NUMBER_INTPTR:						\
		return [OFNumber numberWithIntPtr:			\
		    _value.intptr o [n intPtrValue]];			\
	case OF_NUMBER_UINTPTR:						\
		return [OFNumber numberWithUIntPtr:			\
		    _value.uintptr o [n uIntPtrValue]];			\
	case OF_NUMBER_FLOAT:						\
	case OF_NUMBER_DOUBLE:						\
		@throw [OFInvalidArgumentException			\
		    exceptionWithClass: [self class]			\
			      selector: _cmd];				\
	default:							\
		@throw [OFInvalidFormatException			\
		    exceptionWithClass: [self class]];			\
	}
#define CALCULATE3(o)							\
	switch (_type) {						\
	case OF_NUMBER_BOOL:						\
		return [OFNumber numberWithBool: _value.bool_ o];	\
	case OF_NUMBER_CHAR:						\
		return [OFNumber numberWithChar: _value.schar o];	\
	case OF_NUMBER_SHORT:						\
		return [OFNumber numberWithShort: _value.sshort o];	\
	case OF_NUMBER_INT:						\
		return [OFNumber numberWithInt: _value.sint o];		\
	case OF_NUMBER_LONG:						\
		return [OFNumber numberWithLong: _value.slong o];	\
	case OF_NUMBER_LONGLONG:					\
		return [OFNumber numberWithLongLong:			\
		    _value.slonglong o];				\
	case OF_NUMBER_UCHAR:						\
		return [OFNumber numberWithUnsignedChar:		\
		    _value.uchar o];					\
	case OF_NUMBER_USHORT:						\
		return [OFNumber numberWithUnsignedShort:		\
		    _value.ushort o];					\
	case OF_NUMBER_UINT:						\
		return [OFNumber numberWithUnsignedInt: _value.uint o];	\
	case OF_NUMBER_ULONG:						\
		return [OFNumber numberWithUnsignedLong:		\
		    _value.ulong o];					\
	case OF_NUMBER_ULONGLONG:					\
		return [OFNumber numberWithUnsignedLongLong:		\
		    _value.ulonglong o];				\
	case OF_NUMBER_INT8:						\
		return [OFNumber numberWithInt8: _value.int8 o];	\
	case OF_NUMBER_INT16:						\
		return [OFNumber numberWithInt16: _value.int16 o];	\
	case OF_NUMBER_INT32:						\
		return [OFNumber numberWithInt32: _value.int32 o];	\
	case OF_NUMBER_INT64:						\
		return [OFNumber numberWithInt64: _value.int64 o];	\
	case OF_NUMBER_UINT8:						\
		return [OFNumber numberWithUInt8: _value.uint8 o];	\
	case OF_NUMBER_UINT16:						\
		return [OFNumber numberWithUInt16: _value.uint16 o];	\
	case OF_NUMBER_UINT32:						\
		return [OFNumber numberWithUInt32: _value.uint32 o];	\
	case OF_NUMBER_UINT64:						\
		return [OFNumber numberWithUInt64: _value.uint64 o];	\
	case OF_NUMBER_SIZE:						\
		return [OFNumber numberWithSize: _value.size o];	\
	case OF_NUMBER_SSIZE:						\
		return [OFNumber numberWithSSize: _value.ssize o];	\
	case OF_NUMBER_INTMAX:						\
		return [OFNumber numberWithIntMax: _value.intmax o];	\
	case OF_NUMBER_UINTMAX:						\
		return [OFNumber numberWithUIntMax: _value.uintmax o];	\
	case OF_NUMBER_PTRDIFF:						\
		return [OFNumber numberWithPtrDiff: _value.ptrdiff o];	\
	case OF_NUMBER_INTPTR:						\
		return [OFNumber numberWithIntPtr: _value.intptr o];	\
	case OF_NUMBER_UINTPTR:						\
		return [OFNumber numberWithUIntPtr: _value.uintptr o];	\
	case OF_NUMBER_FLOAT:						\
		return [OFNumber numberWithFloat: _value.float_ o];	\
	case OF_NUMBER_DOUBLE:						\
		return [OFNumber numberWithDouble: _value.double_ o];	\
	default:							\
		@throw [OFInvalidFormatException			\
		    exceptionWithClass: [self class]];			\
	}

@implementation OFNumber
+ (instancetype)numberWithBool: (bool)bool_
{
	return [[[self alloc] initWithBool: bool_] autorelease];
}

+ (instancetype)numberWithChar: (signed char)schar
{
	return [[[self alloc] initWithChar: schar] autorelease];
}

+ (instancetype)numberWithShort: (signed short)sshort
{
	return [[[self alloc] initWithShort: sshort] autorelease];
}

+ (instancetype)numberWithInt: (signed int)sint
{
	return [[[self alloc] initWithInt: sint] autorelease];
}

+ (instancetype)numberWithLong: (signed long)slong
{
	return [[[self alloc] initWithLong: slong] autorelease];
}

+ (instancetype)numberWithLongLong: (signed long long)slonglong
{
	return [[[self alloc] initWithLongLong: slonglong] autorelease];
}

+ (instancetype)numberWithUnsignedChar: (unsigned char)uchar
{
	return [[[self alloc] initWithUnsignedChar: uchar] autorelease];
}

+ (instancetype)numberWithUnsignedShort: (unsigned short)ushort
{
	return [[[self alloc] initWithUnsignedShort: ushort] autorelease];
}

+ (instancetype)numberWithUnsignedInt: (unsigned int)uint
{
	return [[[self alloc] initWithUnsignedInt: uint] autorelease];
}

+ (instancetype)numberWithUnsignedLong: (unsigned long)ulong
{
	return [[[self alloc] initWithUnsignedLong: ulong] autorelease];
}

+ (instancetype)numberWithUnsignedLongLong: (unsigned long long)ulonglong
{
	return [[[self alloc] initWithUnsignedLongLong: ulonglong] autorelease];
}

+ (instancetype)numberWithInt8: (int8_t)int8
{
	return [[[self alloc] initWithInt8: int8] autorelease];
}

+ (instancetype)numberWithInt16: (int16_t)int16
{
	return [[[self alloc] initWithInt16: int16] autorelease];
}

+ (instancetype)numberWithInt32: (int32_t)int32
{
	return [[[self alloc] initWithInt32: int32] autorelease];
}

+ (instancetype)numberWithInt64: (int64_t)int64
{
	return [[[self alloc] initWithInt64: int64] autorelease];
}

+ (instancetype)numberWithUInt8: (uint8_t)uint8
{
	return [[[self alloc] initWithUInt8: uint8] autorelease];
}

+ (instancetype)numberWithUInt16: (uint16_t)uint16
{
	return [[[self alloc] initWithUInt16: uint16] autorelease];
}

+ (instancetype)numberWithUInt32: (uint32_t)uint32
{
	return [[[self alloc] initWithUInt32: uint32] autorelease];
}

+ (instancetype)numberWithUInt64: (uint64_t)uint64
{
	return [[[self alloc] initWithUInt64: uint64] autorelease];
}

+ (instancetype)numberWithSize: (size_t)size
{
	return [[[self alloc] initWithSize: size] autorelease];
}

+ (instancetype)numberWithSSize: (ssize_t)ssize
{
	return [[[self alloc] initWithSSize: ssize] autorelease];
}

+ (instancetype)numberWithIntMax: (intmax_t)intmax
{
	return [[[self alloc] initWithIntMax: intmax] autorelease];
}

+ (instancetype)numberWithUIntMax: (uintmax_t)uintmax
{
	return [[[self alloc] initWithUIntMax: uintmax] autorelease];
}

+ (instancetype)numberWithPtrDiff: (ptrdiff_t)ptrdiff
{
	return [[[self alloc] initWithPtrDiff: ptrdiff] autorelease];
}

+ (instancetype)numberWithIntPtr: (intptr_t)intptr
{
	return [[[self alloc] initWithIntPtr: intptr] autorelease];
}

+ (instancetype)numberWithUIntPtr: (uintptr_t)uintptr
{
	return [[[self alloc] initWithUIntPtr: uintptr] autorelease];
}

+ (instancetype)numberWithFloat: (float)float_
{
	return [[[self alloc] initWithFloat: float_] autorelease];
}

+ (instancetype)numberWithDouble: (double)double_
{
	return [[[self alloc] initWithDouble: double_] autorelease];
}

- init
{
	@try {
		[self doesNotRecognizeSelector: _cmd];
	} @catch (id e) {
		[self release];
		@throw e;
	}

	abort();
}

- initWithBool: (bool)bool_
{
	self = [super init];

	_value.bool_ = bool_;
	_type = OF_NUMBER_BOOL;

	return self;
}

- initWithChar: (signed char)schar
{
	self = [super init];

	_value.schar = schar;
	_type = OF_NUMBER_CHAR;

	return self;
}

- initWithShort: (signed short)sshort
{
	self = [super init];

	_value.sshort = sshort;
	_type = OF_NUMBER_SHORT;

	return self;
}

- initWithInt: (signed int)sint
{
	self = [super init];

	_value.sint = sint;
	_type = OF_NUMBER_INT;

	return self;
}

- initWithLong: (signed long)slong
{
	self = [super init];

	_value.slong = slong;
	_type = OF_NUMBER_LONG;

	return self;
}

- initWithLongLong: (signed long long)slonglong
{
	self = [super init];

	_value.slonglong = slonglong;
	_type = OF_NUMBER_LONGLONG;

	return self;
}

- initWithUnsignedChar: (unsigned char)uchar
{
	self = [super init];

	_value.uchar = uchar;
	_type = OF_NUMBER_UCHAR;

	return self;
}

- initWithUnsignedShort: (unsigned short)ushort
{
	self = [super init];

	_value.ushort = ushort;
	_type = OF_NUMBER_USHORT;

	return self;
}

- initWithUnsignedInt: (unsigned int)uint
{
	self = [super init];

	_value.uint = uint;
	_type = OF_NUMBER_UINT;

	return self;
}

- initWithUnsignedLong: (unsigned long)ulong
{
	self = [super init];

	_value.ulong = ulong;
	_type = OF_NUMBER_ULONG;

	return self;
}

- initWithUnsignedLongLong: (unsigned long long)ulonglong
{
	self = [super init];

	_value.ulonglong = ulonglong;
	_type = OF_NUMBER_ULONGLONG;

	return self;
}

- initWithInt8: (int8_t)int8
{
	self = [super init];

	_value.int8 = int8;
	_type = OF_NUMBER_INT8;

	return self;
}

- initWithInt16: (int16_t)int16
{
	self = [super init];

	_value.int16 = int16;
	_type = OF_NUMBER_INT16;

	return self;
}

- initWithInt32: (int32_t)int32
{
	self = [super init];

	_value.int32 = int32;
	_type = OF_NUMBER_INT32;

	return self;
}

- initWithInt64: (int64_t)int64
{
	self = [super init];

	_value.int64 = int64;
	_type = OF_NUMBER_INT64;

	return self;
}

- initWithUInt8: (uint8_t)uint8
{
	self = [super init];

	_value.uint8 = uint8;
	_type = OF_NUMBER_UINT8;

	return self;
}

- initWithUInt16: (uint16_t)uint16
{
	self = [super init];

	_value.uint16 = uint16;
	_type = OF_NUMBER_UINT16;

	return self;
}

- initWithUInt32: (uint32_t)uint32
{
	self = [super init];

	_value.uint32 = uint32;
	_type = OF_NUMBER_UINT32;

	return self;
}

- initWithUInt64: (uint64_t)uint64
{
	self = [super init];

	_value.uint64 = uint64;
	_type = OF_NUMBER_UINT64;

	return self;
}

- initWithSize: (size_t)size
{
	self = [super init];

	_value.size = size;
	_type = OF_NUMBER_SIZE;

	return self;
}

- initWithSSize: (ssize_t)ssize
{
	self = [super init];

	_value.ssize = ssize;
	_type = OF_NUMBER_SSIZE;

	return self;
}

- initWithIntMax: (intmax_t)intmax
{
	self = [super init];

	_value.intmax = intmax;
	_type = OF_NUMBER_INTMAX;

	return self;
}

- initWithUIntMax: (uintmax_t)uintmax
{
	self = [super init];

	_value.uintmax = uintmax;
	_type = OF_NUMBER_UINTMAX;

	return self;
}

- initWithPtrDiff: (ptrdiff_t)ptrdiff
{
	self = [super init];

	_value.ptrdiff = ptrdiff;
	_type = OF_NUMBER_PTRDIFF;

	return self;
}

- initWithIntPtr: (intptr_t)intptr
{
	self = [super init];

	_value.intptr = intptr;
	_type = OF_NUMBER_INTPTR;

	return self;
}

- initWithUIntPtr: (uintptr_t)uintptr
{
	self = [super init];

	_value.uintptr = uintptr;
	_type = OF_NUMBER_UINTPTR;

	return self;
}

- initWithFloat: (float)float_
{
	self = [super init];

	_value.float_ = float_;
	_type = OF_NUMBER_FLOAT;

	return self;
}

- initWithDouble: (double)double_
{
	self = [super init];

	_value.double_ = double_;
	_type = OF_NUMBER_DOUBLE;

	return self;
}

- initWithSerialization: (OFXMLElement*)element
{
	self = [super init];

	@try {
		void *pool = objc_autoreleasePoolPush();
		OFString *typeString;

		if (![[element name] isEqual: [self className]] ||
		    ![[element namespace] isEqual: OF_SERIALIZATION_NS])
			@throw [OFInvalidArgumentException
			    exceptionWithClass: [self class]
				      selector: _cmd];

		typeString = [[element attributeForName: @"type"] stringValue];

		if ([typeString isEqual: @"boolean"]) {
			_type = OF_NUMBER_BOOL;

			if ([[element stringValue] isEqual: @"true"])
				_value.bool_ = true;
			else if ([[element stringValue] isEqual: @"false"])
				_value.bool_ = false;
			else
				@throw [OFInvalidArgumentException
				    exceptionWithClass: [self class]
					      selector: _cmd];
		} else if ([typeString isEqual: @"unsigned"]) {
			/*
			 * FIXME: This will fail if the value is bigger than
			 *	  INTMAX_MAX!
			 */
			_type = OF_NUMBER_UINTMAX;
			_value.uintmax = [element decimalValue];
		} else if ([typeString isEqual: @"signed"]) {
			_type = OF_NUMBER_INTMAX;
			_value.intmax = [element decimalValue];
		} else if ([typeString isEqual: @"float"]) {
			union {
				float f;
				uint32_t u;
			} f;

			f.u = (uint32_t)[element hexadecimalValue];

			_type = OF_NUMBER_FLOAT;
			_value.float_ = f.f;
		} else if ([typeString isEqual: @"double"]) {
			union {
				double d;
				uint64_t u;
			} d;

			d.u = (uint64_t)[element hexadecimalValue];

			_type = OF_NUMBER_DOUBLE;
			_value.double_ = d.d;
		} else
			@throw [OFInvalidArgumentException
			    exceptionWithClass: [self class]
				      selector: _cmd];

		objc_autoreleasePoolPop(pool);
	} @catch (id e) {
		[self release];
		@throw e;
	}

	return self;
}

- (of_number_type_t)type
{
	return _type;
}

- (bool)boolValue
{
	RETURN_AS(bool)
}

- (signed char)charValue
{
	RETURN_AS(signed char)
}

- (signed short)shortValue
{
	RETURN_AS(signed short)
}

- (signed int)intValue
{
	RETURN_AS(signed int)
}

- (signed long)longValue
{
	RETURN_AS(signed long)
}

- (signed long long)longLongValue
{
	RETURN_AS(signed long long)
}

- (unsigned char)unsignedCharValue
{
	RETURN_AS(unsigned char)
}

- (unsigned short)unsignedShortValue
{
	RETURN_AS(unsigned short)
}

- (unsigned int)unsignedIntValue
{
	RETURN_AS(unsigned int)
}

- (unsigned long)unsignedLongValue
{
	RETURN_AS(unsigned long)
}

- (unsigned long long)unsignedLongLongValue
{
	RETURN_AS(unsigned long long)
}

- (int8_t)int8Value
{
	RETURN_AS(int8_t)
}

- (int16_t)int16Value
{
	RETURN_AS(int16_t)
}

- (int32_t)int32Value
{
	RETURN_AS(int32_t)
}

- (int64_t)int64Value
{
	RETURN_AS(int64_t)
}

- (uint8_t)uInt8Value
{
	RETURN_AS(uint8_t)
}

- (uint16_t)uInt16Value
{
	RETURN_AS(uint16_t)
}

- (uint32_t)uInt32Value
{
	RETURN_AS(uint32_t)
}

- (uint64_t)uInt64Value
{
	RETURN_AS(uint64_t)
}

- (size_t)sizeValue
{
	RETURN_AS(size_t)
}

- (ssize_t)sSizeValue
{
	RETURN_AS(ssize_t)
}

- (intmax_t)intMaxValue
{
	RETURN_AS(intmax_t)
}

- (uintmax_t)uIntMaxValue
{
	RETURN_AS(uintmax_t)
}

- (ptrdiff_t)ptrDiffValue
{
	RETURN_AS(ptrdiff_t)
}

- (intptr_t)intPtrValue
{
	RETURN_AS(intptr_t)
}

- (uintptr_t)uIntPtrValue
{
	RETURN_AS(uintptr_t)
}

- (float)floatValue
{
	RETURN_AS(float)
}

- (double)doubleValue
{
	RETURN_AS(double)
}

- (bool)isEqual: (id)object
{
	OFNumber *number;

	if (![object isKindOfClass: [OFNumber class]])
		return false;

	number = object;

	if (_type & OF_NUMBER_FLOAT || number->_type & OF_NUMBER_FLOAT)
		return ([number doubleValue] == [self doubleValue]);

	if (_type & OF_NUMBER_SIGNED || number->_type & OF_NUMBER_SIGNED)
		return ([number intMaxValue] == [self intMaxValue]);

	return ([number uIntMaxValue] == [self uIntMaxValue]);
}

- (of_comparison_result_t)compare: (id <OFComparing>)object
{
	OFNumber *number;

	if (![object isKindOfClass: [OFNumber class]])
		@throw [OFInvalidArgumentException
		    exceptionWithClass: [self class]
			      selector: _cmd];

	number = (OFNumber*)object;

	if (_type & OF_NUMBER_FLOAT || number->_type & OF_NUMBER_FLOAT) {
		double double1 = [self doubleValue];
		double double2 = [number doubleValue];

		if (double1 > double2)
			return OF_ORDERED_DESCENDING;
		if (double1 < double2)
			return OF_ORDERED_ASCENDING;

		return OF_ORDERED_SAME;
	} else if (_type & OF_NUMBER_SIGNED ||
	    number->_type & OF_NUMBER_SIGNED) {
		intmax_t int1 = [self intMaxValue];
		intmax_t int2 = [number intMaxValue];

		if (int1 > int2)
			return OF_ORDERED_DESCENDING;
		if (int1 < int2)
			return OF_ORDERED_ASCENDING;

		return OF_ORDERED_SAME;
	} else {
		uintmax_t uint1 = [self uIntMaxValue];
		uintmax_t uint2 = [number uIntMaxValue];

		if (uint1 > uint2)
			return OF_ORDERED_DESCENDING;
		if (uint1 < uint2)
			return OF_ORDERED_ASCENDING;

		return OF_ORDERED_SAME;
	}
}

- (uint32_t)hash
{
	of_number_type_t type = _type;
	uint32_t hash;

	/* Do we really need signed to represent this number? */
	if (type & OF_NUMBER_SIGNED && [self intMaxValue] >= 0)
		type &= ~OF_NUMBER_SIGNED;

	/* Do we really need floating point to represent this number? */
	if (type & OF_NUMBER_FLOAT) {
		double v = [self doubleValue];

		if (v < 0) {
			if (v == [self intMaxValue]) {
				type &= ~OF_NUMBER_FLOAT;
				type |= OF_NUMBER_SIGNED;
			}
		} else {
			if (v == [self uIntMaxValue])
				type &= ~OF_NUMBER_FLOAT;
		}
	}

	OF_HASH_INIT(hash);

	if (type & OF_NUMBER_FLOAT) {
		union {
			double d;
			uint8_t b[sizeof(double)];
		} d;
		uint_fast8_t i;

		d.d = OF_BSWAP_DOUBLE_IF_BE([self doubleValue]);

		for (i = 0; i < sizeof(double); i++)
			OF_HASH_ADD(hash, d.b[i]);
	} else if (type & OF_NUMBER_SIGNED) {
		intmax_t v = [self intMaxValue] * -1;

		while (v != 0) {
			OF_HASH_ADD(hash, v & 0xFF);
			v >>= 8;
		}

		OF_HASH_ADD(hash, 1);
	} else {
		uintmax_t v = [self uIntMaxValue];

		while (v != 0) {
			OF_HASH_ADD(hash, v & 0xFF);
			v >>= 8;
		}
	}

	OF_HASH_FINALIZE(hash);

	return hash;
}

- (OFNumber*)numberByAddingNumber: (OFNumber*)num
{
	CALCULATE(+, num)
}

- (OFNumber*)numberBySubtractingNumber: (OFNumber*)num
{
	CALCULATE(-, num)
}

- (OFNumber*)numberByMultiplyingWithNumber: (OFNumber*)num
{
	CALCULATE(*, num)
}

- (OFNumber*)numberByDividingWithNumber: (OFNumber*)num
{
	CALCULATE(/, num)
}

- (OFNumber*)numberByANDingWithNumber: (OFNumber*)num
{
	CALCULATE2(&, num)
}

- (OFNumber*)numberByORingWithNumber: (OFNumber*)num
{
	CALCULATE2(|, num)
}

- (OFNumber*)numberByXORingWithNumber: (OFNumber*)num
{
	CALCULATE2(^, num)
}

- (OFNumber*)numberByShiftingLeftWithNumber: (OFNumber*)num
{
	CALCULATE2(<<, num)
}

- (OFNumber*)numberByShiftingRightWithNumber: (OFNumber*)num
{
	CALCULATE2(>>, num)
}

- (OFNumber*)numberByIncreasing
{
	CALCULATE3(+ 1)
}

- (OFNumber*)numberByDecreasing
{
	CALCULATE3(- 1)
}

- (OFNumber*)remainderOfDivisionWithNumber: (OFNumber*)number
{
	switch (_type) {
	case OF_NUMBER_BOOL:
		return [OFNumber numberWithBool:
		    _value.bool_ % [number boolValue]];
	case OF_NUMBER_CHAR:
		return [OFNumber numberWithChar:
		    _value.schar % [number charValue]];
	case OF_NUMBER_SHORT:
		return [OFNumber numberWithShort:
		    _value.sshort % [number shortValue]];
	case OF_NUMBER_INT:
		return [OFNumber numberWithInt:
		    _value.sint % [number intValue]];
	case OF_NUMBER_LONG:
		return [OFNumber numberWithLong:
		    _value.slong % [number longValue]];
	case OF_NUMBER_LONGLONG:
		return [OFNumber numberWithLongLong:
		    _value.slonglong % [number longLongValue]];
	case OF_NUMBER_UCHAR:
		return [OFNumber numberWithUnsignedChar:
		    _value.uchar % [number unsignedCharValue]];
	case OF_NUMBER_USHORT:
		return [OFNumber numberWithUnsignedShort:
		    _value.ushort % [number unsignedShortValue]];
	case OF_NUMBER_UINT:
		return [OFNumber numberWithUnsignedInt:
		    _value.uint % [number unsignedIntValue]];
	case OF_NUMBER_ULONG:
		return [OFNumber numberWithUnsignedLong:
		    _value.ulong % [number unsignedLongValue]];
	case OF_NUMBER_ULONGLONG:
		return [OFNumber numberWithUnsignedLongLong:
		    _value.ulonglong % [number unsignedLongLongValue]];
	case OF_NUMBER_INT8:
		return [OFNumber numberWithInt8:
		    _value.int8 % [number int8Value]];
	case OF_NUMBER_INT16:
		return [OFNumber numberWithInt16:
		    _value.int16 % [number int16Value]];
	case OF_NUMBER_INT32:
		return [OFNumber numberWithInt32:
		    _value.int32 % [number int32Value]];
	case OF_NUMBER_INT64:
		return [OFNumber numberWithInt64:
		    _value.int64 % [number int64Value]];
	case OF_NUMBER_UINT8:
		return [OFNumber numberWithUInt8:
		    _value.uint8 % [number uInt8Value]];
	case OF_NUMBER_UINT16:
		return [OFNumber numberWithUInt16:
		    _value.uint16 % [number uInt16Value]];
	case OF_NUMBER_UINT32:
		return [OFNumber numberWithUInt32:
		    _value.uint32 % [number uInt32Value]];
	case OF_NUMBER_UINT64:
		return [OFNumber numberWithUInt64:
		    _value.uint64 % [number uInt64Value]];
	case OF_NUMBER_SIZE:
		return [OFNumber numberWithSize:
		    _value.size % [number sizeValue]];
	case OF_NUMBER_SSIZE:
		return [OFNumber numberWithSSize:
		    _value.ssize % [number sSizeValue]];
	case OF_NUMBER_INTMAX:
		return [OFNumber numberWithIntMax:
		    _value.intmax % [number intMaxValue]];
	case OF_NUMBER_UINTMAX:
		return [OFNumber numberWithUIntMax:
		    _value.uintmax % [number uIntMaxValue]];
	case OF_NUMBER_PTRDIFF:
		return [OFNumber numberWithPtrDiff:
		    _value.ptrdiff % [number ptrDiffValue]];
	case OF_NUMBER_INTPTR:
		return [OFNumber numberWithIntPtr:
		    _value.intptr % [number intPtrValue]];
	case OF_NUMBER_UINTPTR:
		return [OFNumber numberWithUIntPtr:
		    _value.uintptr % [number uIntPtrValue]];
	case OF_NUMBER_FLOAT:
		return [OFNumber numberWithFloat:
		    fmodf(_value.float_, [number floatValue])];
	case OF_NUMBER_DOUBLE:
		return [OFNumber numberWithDouble:
		    fmod(_value.double_, [number doubleValue])];
	default:
		@throw [OFInvalidFormatException
		    exceptionWithClass: [self class]];
	}
}

- copy
{
	return [self retain];
}

- (OFString*)description
{
	OFMutableString *ret;

	switch (_type) {
	case OF_NUMBER_BOOL:
		return (_value.bool_ ? @"true" : @"false");
	case OF_NUMBER_UCHAR:
	case OF_NUMBER_USHORT:
	case OF_NUMBER_UINT:
	case OF_NUMBER_ULONG:
	case OF_NUMBER_ULONGLONG:
	case OF_NUMBER_UINT8:
	case OF_NUMBER_UINT16:
	case OF_NUMBER_UINT32:
	case OF_NUMBER_UINT64:
	case OF_NUMBER_SIZE:
	case OF_NUMBER_UINTMAX:
	case OF_NUMBER_UINTPTR:
		return [OFString stringWithFormat: @"%ju", [self uIntMaxValue]];
	case OF_NUMBER_CHAR:
	case OF_NUMBER_SHORT:
	case OF_NUMBER_INT:
	case OF_NUMBER_LONG:
	case OF_NUMBER_LONGLONG:
	case OF_NUMBER_INT8:
	case OF_NUMBER_INT16:
	case OF_NUMBER_INT32:
	case OF_NUMBER_INT64:
	case OF_NUMBER_SSIZE:
	case OF_NUMBER_INTMAX:
	case OF_NUMBER_PTRDIFF:
	case OF_NUMBER_INTPTR:
		return [OFString stringWithFormat: @"%jd", [self intMaxValue]];
	case OF_NUMBER_FLOAT:
		ret = [OFMutableString stringWithFormat: @"%g", _value.float_];

		if (![ret containsString: @"."])
			[ret appendString: @".0"];

		[ret makeImmutable];

		return ret;
	case OF_NUMBER_DOUBLE:
		ret = [OFMutableString stringWithFormat: @"%lg",
							 _value.double_];

		if (![ret containsString: @"."])
			[ret appendString: @".0"];

		[ret makeImmutable];

		return ret;
	default:
		@throw [OFInvalidFormatException
		    exceptionWithClass: [self class]];
	}
}

- (OFXMLElement*)XMLElementBySerializing
{
	void *pool = objc_autoreleasePoolPush();
	OFXMLElement *element;

	element = [OFXMLElement elementWithName: [self className]
				      namespace: OF_SERIALIZATION_NS
				    stringValue: [self description]];

	switch (_type) {
	case OF_NUMBER_BOOL:
		[element addAttributeWithName: @"type"
				  stringValue: @"boolean"];
		break;
	case OF_NUMBER_UCHAR:
	case OF_NUMBER_USHORT:
	case OF_NUMBER_UINT:
	case OF_NUMBER_ULONG:
	case OF_NUMBER_ULONGLONG:
	case OF_NUMBER_UINT8:
	case OF_NUMBER_UINT16:
	case OF_NUMBER_UINT32:
	case OF_NUMBER_UINT64:
	case OF_NUMBER_SIZE:
	case OF_NUMBER_UINTMAX:
	case OF_NUMBER_UINTPTR:
		[element addAttributeWithName: @"type"
				  stringValue: @"unsigned"];
		break;
	case OF_NUMBER_CHAR:
	case OF_NUMBER_SHORT:
	case OF_NUMBER_INT:
	case OF_NUMBER_LONG:
	case OF_NUMBER_LONGLONG:
	case OF_NUMBER_INT8:
	case OF_NUMBER_INT16:
	case OF_NUMBER_INT32:
	case OF_NUMBER_INT64:
	case OF_NUMBER_SSIZE:
	case OF_NUMBER_INTMAX:
	case OF_NUMBER_PTRDIFF:
	case OF_NUMBER_INTPTR:;
		[element addAttributeWithName: @"type"
				  stringValue: @"signed"];
		break;
	case OF_NUMBER_FLOAT:;
		union {
			float f;
			uint32_t u;
		} f;

		f.f = _value.float_;

		[element addAttributeWithName: @"type"
				  stringValue: @"float"];
		[element setStringValue:
		    [OFString stringWithFormat: @"%08" PRIx32, f.u]];

		break;
	case OF_NUMBER_DOUBLE:;
		union {
			double d;
			uint64_t u;
		} d;

		d.d = _value.double_;

		[element addAttributeWithName: @"type"
				  stringValue: @"double"];
		[element setStringValue:
		    [OFString stringWithFormat: @"%016" PRIx64, d.u]];

		break;
	default:
		@throw [OFInvalidFormatException
		    exceptionWithClass: [self class]];
	}

	[element retain];

	objc_autoreleasePoolPop(pool);

	return [element autorelease];
}

- (OFString*)JSONRepresentation
{
	double doubleValue;

	if (_type == OF_NUMBER_BOOL)
		return (_value.bool_ ? @"true" : @"false");

	doubleValue = [self doubleValue];
	if (isinf(doubleValue)) {
		if (doubleValue > 0)
			return @"Infinity";
		else
			return @"-Infinity";
	}

	return [self description];
}

- (OFDataArray*)binaryPackRepresentation
{
	OFDataArray *data;

	if (_type == OF_NUMBER_BOOL) {
		uint8_t type;

		data = [OFDataArray dataArrayWithItemSize: 1
						 capacity: 1];

		if (_value.bool_)
			type = 0xC3;
		else
			type = 0xC2;

		[data addItem: &type];
	} else if (_type == OF_NUMBER_FLOAT) {
		uint8_t type = 0xCA;
		float tmp = OF_BSWAP_FLOAT_IF_LE(_value.float_);

		data = [OFDataArray dataArrayWithItemSize: 1
						 capacity: 5];

		[data addItem: &type];
		[data addItems: &tmp
			 count: sizeof(tmp)];
	} else if (_type == OF_NUMBER_DOUBLE) {
		uint8_t type = 0xCB;
		double tmp = OF_BSWAP_DOUBLE_IF_LE(_value.double_);

		data = [OFDataArray dataArrayWithItemSize: 1
						 capacity: 9];

		[data addItem: &type];
		[data addItems: &tmp
			 count: sizeof(tmp)];
	} else if (_type & OF_NUMBER_SIGNED) {
		intmax_t value = [self intMaxValue];

		if (value >= -32 && value < 0) {
			uint8_t tmp = 0xE0 | ((uint8_t)(value - 32) & 0x1F);

			data = [OFDataArray dataArrayWithItemSize: 1
							 capacity: 1];

			[data addItem: &tmp];
		} else if (value >= INT8_MIN && value <= INT8_MAX) {
			uint8_t type = 0xD0;
			int8_t tmp = (int8_t)value;

			data = [OFDataArray dataArrayWithItemSize: 1
							 capacity: 2];

			[data addItem: &type];
			[data addItem: &tmp];
		} else if (value >= INT16_MIN && value <= INT16_MAX) {
			uint8_t type = 0xD1;
			int16_t tmp = OF_BSWAP16_IF_LE((int16_t)value);

			data = [OFDataArray dataArrayWithItemSize: 1
							 capacity: 3];

			[data addItem: &type];
			[data addItems: &tmp
				 count: sizeof(tmp)];
		} else if (value >= INT32_MIN && value <= INT32_MAX) {
			uint8_t type = 0xD2;
			int32_t tmp = OF_BSWAP32_IF_LE((int32_t)value);

			data = [OFDataArray dataArrayWithItemSize: 1
							 capacity: 5];

			[data addItem: &type];
			[data addItems: &tmp
				 count: sizeof(tmp)];
		} else if (value >= INT64_MIN && value <= INT64_MAX) {
			uint8_t type = 0xD3;
			int64_t tmp = OF_BSWAP64_IF_LE((int64_t)value);

			data = [OFDataArray dataArrayWithItemSize: 1
							 capacity: 9];

			[data addItem: &type];
			[data addItems: &tmp
				 count: sizeof(tmp)];
		} else
			@throw [OFOutOfRangeException
			    exceptionWithClass: [self class]];
	} else {
		uintmax_t value = [self uIntMaxValue];

		if (value <= 127) {
			uint8_t tmp = ((uint8_t)value & 0x7F);

			data = [OFDataArray dataArrayWithItemSize: 1
							 capacity: 1];

			[data addItem: &tmp];
		} else if (value <= UINT8_MAX) {
			uint8_t type = 0xCC;
			uint8_t tmp = (uint8_t)value;

			data = [OFDataArray dataArrayWithItemSize: 1
							 capacity: 2];

			[data addItem: &type];
			[data addItem: &tmp];
		} else if (value <= UINT16_MAX) {
			uint8_t type = 0xCD;
			uint16_t tmp = OF_BSWAP16_IF_LE((uint16_t)value);

			data = [OFDataArray dataArrayWithItemSize: 1
							 capacity: 3];

			[data addItem: &type];
			[data addItems: &tmp
				 count: sizeof(tmp)];
		} else if (value <= UINT32_MAX) {
			uint8_t type = 0xCE;
			uint32_t tmp = OF_BSWAP32_IF_LE((uint32_t)value);

			data = [OFDataArray dataArrayWithItemSize: 1
							 capacity: 5];

			[data addItem: &type];
			[data addItems: &tmp
				 count: sizeof(tmp)];
		} else if (value <= UINT64_MAX) {
			uint8_t type = 0xCF;
			uint64_t tmp = OF_BSWAP64_IF_LE((uint64_t)value);

			data = [OFDataArray dataArrayWithItemSize: 1
							 capacity: 9];

			[data addItem: &type];
			[data addItems: &tmp
				 count: sizeof(tmp)];
		} else
			@throw [OFOutOfRangeException
			    exceptionWithClass: [self class]];
	}

	return data;
}
@end
