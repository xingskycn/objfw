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

@class OFThread;

/*!
 * @brief An exception indicating that starting a thread failed.
 */
@interface OFThreadStartFailedException: OFException
{
	OFThread *_thread;
}

#ifdef OF_HAVE_PROPERTIES
@property (readonly, retain, nonatomic) OFThread *thread;
#endif

/*!
 * @brief Creates a new, autoreleased thread start failed exception.
 *
 * @param class_ The class of the object which caused the exception
 * @param thread The thread which could not be started
 * @return A new, autoreleased thread start failed exception
 */
+ (instancetype)exceptionWithClass: (Class)class_
			    thread: (OFThread*)thread;

/*!
 * @brief Initializes an already allocated thread start failed exception.
 *
 * @param class_ The class of the object which caused the exception
 * @param thread The thread which could not be started
 * @return An initialized thread start failed exception
 */
- initWithClass: (Class)class_
	 thread: (OFThread*)thread;

/*!
 * @brief Returns the thread which could not be started.
 *
 * @return The thread which could not be started
 */
- (OFThread*)thread;
@end
