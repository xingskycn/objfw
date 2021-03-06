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

@class OFHTTPRequest;
@class OFHTTPRequestReply;

/*!
 * @brief An exception indicating that a HTTP request failed.
 */
@interface OFHTTPRequestFailedException: OFException
{
	OFHTTPRequest *_request;
	OFHTTPRequestReply *_reply;
}

#ifdef OF_HAVE_PROPERTIES
@property (readonly, retain, nonatomic) OFHTTPRequest *request;
@property (readonly, retain, nonatomic) OFHTTPRequestReply *reply;
#endif

/*!
 * @brief Creates a new, autoreleased HTTP request failed exception.
 *
 * @param class_ The class of the object which caused the exception
 * @param request The HTTP request which failed
 * @param reply The reply of the failed HTTP request
 * @return A new, autoreleased HTTP request failed exception
 */
+ (instancetype)exceptionWithClass: (Class)class_
			   request: (OFHTTPRequest*)request
			     reply: (OFHTTPRequestReply*)reply;

/*!
 * @brief Initializes an already allocated HTTP request failed exception.
 *
 * @param class_ The class of the object which caused the exception
 * @param request The HTTP request which failed
 * @param reply The reply of the failed HTTP request
 * @return A new HTTP request failed exception
 */
- initWithClass: (Class)class_
	request: (OFHTTPRequest*)request
	  reply: (OFHTTPRequestReply*)reply;

/*!
 * @brief Returns the HTTP request which failed.
 *
 * @return The HTTP request which failed
 */
- (OFHTTPRequest*)request;

/*!
 * @brief Returns the reply of the failed HTTP request.
 *
 * @return The reply of the failed HTTP request
 */
- (OFHTTPRequestReply*)reply;
@end
