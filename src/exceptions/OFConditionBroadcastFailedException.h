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

@class OFCondition;

/*!
 * @brief An exception indicating broadcasting a condition failed.
 */
@interface OFConditionBroadcastFailedException: OFException
{
	OFCondition *_condition;
}

#ifdef OF_HAVE_PROPERTIES
@property (readonly, retain, nonatomic) OFCondition *condition;
#endif

/*!
 * @brief Returns a new, autoreleased condition broadcast failed exception.
 *
 * @param class_ The class of the object which caused the exception
 * @param condition The condition which could not be broadcasted
 * @return A new, autoreleased condition broadcast failed exception
 */
+ (instancetype)exceptionWithClass: (Class)class_
			 condition: (OFCondition*)condition;

/*!
 * @brief Initializes an already allocated condition broadcast failed exception.
 *
 * @param class_ The class of the object which caused the exception
 * @param condition The condition which could not be broadcasted
 * @return An initialized condition broadcast failed exception
 */
- initWithClass: (Class)class_
      condition: (OFCondition*)condition;

/*!
 * @brief Returns the condition which could not be broadcasted.
 *
 * @return The condition which could not be broadcasted
 */
- (OFCondition*)condition;
@end
