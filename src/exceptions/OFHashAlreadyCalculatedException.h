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

#import "OFException.h"
#import "OFHash.h"

/*!
 * @brief An exception indicating that the hash has already been calculated.
 */
@interface OFHashAlreadyCalculatedException: OFException
{
	id <OFHash> _hashObject;
}

#ifdef OF_HAVE_PROPERTIES
@property (readonly, retain, nonatomic) id <OFHash> hashObject;
#endif

/*!
 * @brief Creates a new, autoreleased hash already calculated exception.
 *
 * @param class_ The class of the object which caused the exception
 * @param hashObject The hash which has already been calculated
 * @return A new, autoreleased hash already calculated exception
 */
+ (instancetype)exceptionWithClass: (Class)class_
			      hash: (id <OFHash>)hashObject;

/*!
 * @brief Initializes an already allocated hash already calculated exception.
 *
 * @param class_ The class of the object which caused the exception
 * @param hashObject The hash which has already been calculated
 * @return An initialized hash already calculated exception
 */
- initWithClass: (Class)class_
	   hash: (id <OFHash>)hashObject;

/*!
 * @brief Returns the hash which has already been calculated.
 *
 * @return The hash which has already been calculated
 */
- (id <OFHash>)hashObject;
@end
