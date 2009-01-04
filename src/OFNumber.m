/*
 * Copyright (c) 2008
 *   Jonathan Schleifer <js@webkeks.org>
 *
 * All rights reserved.
 *
 * This file is part of libobjfw. It may be distributed under the terms of the
 * Q Public License 1.0, which can be found in the file LICENSE included in
 * the packaging of this file.
 */

#import "OFNumber.h"
#import "OFExceptions.h"

#define RETURN_AS(t)							      \
	switch (type) {							      \
	case OF_NUMBER_CHAR:						      \
		return (t)value.char_;					      \
	case OF_NUMBER_SHORT:						      \
		return (t)value.short_;					      \
	case OF_NUMBER_INT:						      \
		return (t)value.int_;					      \
	case OF_NUMBER_LONG:						      \
		return (t)value.long_;					      \
	case OF_NUMBER_UCHAR:						      \
		return (t)value.uchar;					      \
	case OF_NUMBER_USHORT:						      \
		return (t)value.ushort;					      \
	case OF_NUMBER_UINT:						      \
		return (t)value.uint;					      \
	case OF_NUMBER_ULONG:						      \
		return (t)value.ulong;					      \
	case OF_NUMBER_INT8:						      \
		return (t)value.int8;					      \
	case OF_NUMBER_INT16:						      \
		return (t)value.int16;					      \
	case OF_NUMBER_INT32:						      \
		return (t)value.int32;					      \
	case OF_NUMBER_INT64:						      \
		return (t)value.int64;					      \
	case OF_NUMBER_UINT8:						      \
		return (t)value.uint8;					      \
	case OF_NUMBER_UINT16:						      \
		return (t)value.uint16;					      \
	case OF_NUMBER_UINT32:						      \
		return (t)value.uint32;					      \
	case OF_NUMBER_UINT64:						      \
		return (t)value.uint64;					      \
	case OF_NUMBER_SIZE:						      \
		return (t)value.size;					      \
	case OF_NUMBER_SSIZE:						      \
		return (t)value.ssize;					      \
	case OF_NUMBER_PTRDIFF:						      \
		return (t)value.ptrdiff;				      \
	case OF_NUMBER_INTPTR:						      \
		return (t)value.intptr;					      \
	case OF_NUMBER_FLOAT:						      \
		return (t)value.float_;					      \
	case OF_NUMBER_DOUBLE:						      \
		return (t)value.double_;				      \
	case OF_NUMBER_LONG_DOUBLE:					      \
		return (t)value.longdouble;				      \
	default:							      \
		@throw [OFInvalidFormatException newWithClass: [self class]]; \
									      \
		/* Make gcc happy */					      \
		return 0;						      \
	}

@implementation OFNumber
+ newWithChar: (char)char_
{
	return [[self alloc] initWithChar: char_];
}

+ newWithShort: (short)short_
{
	return [[self alloc] initWithShort: short_];
}

+ newWithInt: (int)int_
{
	return [[self alloc] initWithInt: int_];
}

+ newWithLong: (long)long_
{
	return [[self alloc] initWithLong: long_];
}

+ newWithUChar: (unsigned char)uchar
{
	return [[self alloc] initWithUChar: uchar];
}

+ newWithUShort: (unsigned short)ushort
{
	return [[self alloc] initWithUShort: ushort];
}

+ newWithUInt: (unsigned int)uint
{
	return [[self alloc] initWithUInt: uint];
}

+ newWithULong: (unsigned long)ulong
{
	return [[self alloc] initWithULong: ulong];
}

+ newWithInt8: (int8_t)int8
{
	return [[self alloc] initWithInt8: int8];
}

+ newWithInt16: (int16_t)int16
{
	return [[self alloc] initWithInt16: int16];
}

+ newWithInt32: (int32_t)int32
{
	return [[self alloc] initWithInt32: int32];
}

+ newWithInt64: (int64_t)int64
{
	return [[self alloc] initWithInt64: int64];
}

+ newWithUInt8: (uint8_t)uint8
{
	return [[self alloc] initWithUInt8: uint8];
}

+ newWithUInt16: (uint16_t)uint16
{
	return [[self alloc] initWithUInt16: uint16];
}

+ newWithUInt32: (uint32_t)uint32
{
	return [[self alloc] initWithUInt32: uint32];
}

+ newWithUInt64: (uint64_t)uint64
{
	return [[self alloc] initWithUInt64: uint64];
}

+ newWithSize: (size_t)size
{
	return [[self alloc] initWithSize: size];
}

+ newWithSSize: (ssize_t)ssize
{
	return [[self alloc] initWithSSize: ssize];
}

+ newWithPtrDiff: (ptrdiff_t)ptrdiff
{
	return [[self alloc] initWithPtrDiff: ptrdiff];
}

+ newWithIntPtr: (intptr_t)intptr
{
	return [[self alloc] initWithIntPtr: intptr];
}

+ newWithFloat: (float)float_
{
	return [[self alloc] initWithFloat: float_];
}

+ newWithDouble: (double)double_
{
	return [[self alloc] initWithDouble: double_];
}

+ newWithLongDouble: (long double)longdouble
{
	return [[self alloc] initWithLongDouble: longdouble];
}

- initWithChar: (char)char_
{
	if ((self = [super init])) {
		value.char_ = char_;
		type = OF_NUMBER_CHAR;
	}

	return self;
}

- initWithShort: (short)short_
{
	if ((self = [super init])) {
		value.short_ = short_;
		type = OF_NUMBER_SHORT;
	}

	return self;
}

- initWithInt: (int)int_
{
	if ((self = [super init])) {
		value.int_ = int_;
		type = OF_NUMBER_INT;
	}

	return self;
}

- initWithLong: (long)long_
{
	if ((self = [super init])) {
		value.long_ = long_;
		type = OF_NUMBER_LONG;
	}

	return self;
}

- initWithUChar: (unsigned char)uchar
{
	if ((self = [super init])) {
		value.uchar = uchar;
		type = OF_NUMBER_UCHAR;
	}

	return self;
}

- initWithUShort: (unsigned short)ushort
{
	if ((self = [super init])) {
		value.ushort = ushort;
		type = OF_NUMBER_USHORT;
	}

	return self;
}

- initWithUInt: (unsigned int)uint
{
	if ((self = [super init])) {
		value.uint = uint;
		type = OF_NUMBER_UINT;
	}

	return self;
}

- initWithULong: (unsigned long)ulong
{
	if ((self = [super init])) {
		value.ulong = ulong;
		type = OF_NUMBER_ULONG;
	}

	return self;
}

- initWithInt8: (int8_t)int8
{
	if ((self = [super init])) {
		value.int8 = int8;
		type = OF_NUMBER_INT8;
	}

	return self;
}

- initWithInt16: (int16_t)int16
{
	if ((self = [super init])) {
		value.int16 = int16;
		type = OF_NUMBER_INT16;
	}

	return self;
}

- initWithInt32: (int32_t)int32
{
	if ((self = [super init])) {
		value.int32 = int32;
		type = OF_NUMBER_INT32;
	}

	return self;
}

- initWithInt64: (int64_t)int64
{
	if ((self = [super init])) {
		value.int64 = int64;
		type = OF_NUMBER_INT64;
	}

	return self;
}

- initWithUInt8: (uint8_t)uint8
{
	if ((self = [super init])) {
		value.uint8 = uint8;
		type = OF_NUMBER_UINT8;
	}

	return self;
}

- initWithUInt16: (uint16_t)uint16
{
	if ((self = [super init])) {
		value.uint16 = uint16;
		type = OF_NUMBER_UINT16;
	}

	return self;
}

- initWithUInt32: (uint32_t)uint32
{
	if ((self = [super init])) {
		value.uint32 = uint32;
		type = OF_NUMBER_UINT32;
	}

	return self;
}

- initWithUInt64: (uint64_t)uint64
{
	if ((self = [super init])) {
		value.uint64 = uint64;
		type = OF_NUMBER_UINT64;
	}

	return self;
}

- initWithSize: (size_t)size
{
	if ((self = [super init])) {
		value.size = size;
		type = OF_NUMBER_SIZE;
	}

	return self;
}

- initWithSSize: (ssize_t)ssize
{
	if ((self = [super init])) {
		value.ssize = ssize;
		type = OF_NUMBER_SSIZE;
	}

	return self;
}

- initWithPtrDiff: (ptrdiff_t)ptrdiff
{
	if ((self = [super init])) {
		value.ptrdiff = ptrdiff;
		type = OF_NUMBER_PTRDIFF;
	}

	return self;
}

- initWithIntPtr: (intptr_t)intptr
{
	if ((self = [super init])) {
		value.intptr = intptr;
		type = OF_NUMBER_INTPTR;
	}

	return self;
}

- initWithFloat: (float)float_
{
	if ((self = [super init])) {
		value.float_ = float_;
		type = OF_NUMBER_FLOAT;
	}

	return self;
}

- initWithDouble: (double)double_
{
	if ((self = [super init])) {
		value.double_ = double_;
		type = OF_NUMBER_DOUBLE;
	}

	return self;
}

- initWithLongDouble: (long double)longdouble
{
	if ((self = [super init])) {
		value.longdouble = longdouble;
		type = OF_NUMBER_LONG_DOUBLE;
	}

	return self;
}

- (enum of_number_type)type
{
	return type;
}

- (char)asChar
{
	RETURN_AS(char)
}

- (short)asShort
{
	RETURN_AS(short)
}

- (int)asInt
{
	RETURN_AS(int)
}

- (long)asLong
{
	RETURN_AS(long)
}

- (unsigned char)asUChar
{
	RETURN_AS(unsigned char)
}

- (unsigned short)asUShort
{
	RETURN_AS(unsigned short)
}

- (unsigned int)asUInt
{
	RETURN_AS(unsigned int)
}

- (unsigned long)asULong
{
	RETURN_AS(unsigned long)
}

- (int8_t)asInt8
{
	RETURN_AS(int8_t)
}

- (int16_t)asInt16
{
	RETURN_AS(int16_t)
}

- (int32_t)asInt32
{
	RETURN_AS(int32_t)
}

- (int64_t)asInt64
{
	RETURN_AS(int64_t)
}

- (uint8_t)asUInt8
{
	RETURN_AS(uint8_t)
}

- (uint16_t)asUInt16
{
	RETURN_AS(uint16_t)
}

- (uint32_t)asUInt32
{
	RETURN_AS(uint32_t)
}

- (uint64_t)asUInt64
{
	RETURN_AS(uint64_t)
}

- (size_t)asSize
{
	RETURN_AS(size_t)
}

- (ssize_t)asSSize
{
	RETURN_AS(ssize_t)
}

- (ptrdiff_t)asPtrDiff
{
	RETURN_AS(ptrdiff_t)
}

- (intptr_t)asIntPtr
{
	RETURN_AS(intptr_t)
}

- (float)asFloat
{
	RETURN_AS(float)
}

- (double)asDouble
{
	RETURN_AS(double)
}

- (long double)asLongDouble
{
	RETURN_AS(long double)
}
@end
