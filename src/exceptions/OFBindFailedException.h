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

#import "OFException.h"

@class OFTCPSocket;

/**
 * \brief An exception indicating that binding a socket failed.
 */
@interface OFBindFailedException: OFException
{
	OFTCPSocket *socket;
	OFString    *host;
	uint16_t    port;
	int	    errNo;
}

#ifdef OF_HAVE_PROPERTIES
@property (readonly, nonatomic) OFTCPSocket *socket;
@property (readonly, nonatomic) OFString *host;
@property (readonly) uint16_t port;
@property (readonly) int errNo;
#endif

/**
 * \param class_ The class of the object which caused the exception
 * \param socket The socket which could not be bound
 * \param host The host on which binding failed
 * \param port The port on which binding failed
 * \return A new bind failed exception
 */
+ newWithClass: (Class)class_
	socket: (OFTCPSocket*)socket
	  host: (OFString*)host
	  port: (uint16_t)port;

/**
 * Initializes an already allocated bind failed exception.
 *
 * \param class_ The class of the object which caused the exception
 * \param socket The socket which could not be bound
 * \param host The host on which binding failed
 * \param port The port on which binding failed
 * \return An initialized bind failed exception
 */
- initWithClass: (Class)class_
	 socket: (OFTCPSocket*)socket
	   host: (OFString*)host
	   port: (uint16_t)port;

/**
 * \return The socket which could not be bound
 */
- (OFTCPSocket*)socket;

/**
 * \return The host on which binding failed
 */
- (OFString*)host;

/**
 * \return The port on which binding failed
 */
- (uint16_t)port;

/**
 * \return The errno from when the exception was created
 */
- (int)errNo;
@end
