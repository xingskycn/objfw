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

#import "OFUnboundNamespaceException.h"
#import "OFString.h"

#import "common.h"

@implementation OFUnboundNamespaceException
+ (instancetype)exceptionWithClass: (Class)class
			 namespace: (OFString*)namespace
{
	return [[[self alloc] initWithClass: class
				  namespace: namespace] autorelease];
}

+ (instancetype)exceptionWithClass: (Class)class
			    prefix: (OFString*)prefix
{
	return [[[self alloc] initWithClass: class
				     prefix: prefix] autorelease];
}

- initWithClass: (Class)class
{
	@try {
		[self doesNotRecognizeSelector: _cmd];
	} @catch (id e) {
		[self release];
		@throw e;
	}

	abort();
}

- initWithClass: (Class)class
      namespace: (OFString*)namespace
{
	self = [super initWithClass: class];

	@try {
		_namespace = [namespace copy];
	} @catch (id e) {
		[self release];
		@throw e;
	}

	return self;
}

- initWithClass: (Class)class
	 prefix: (OFString*)prefix
{
	self = [super initWithClass: class];

	@try {
		_prefix = [prefix copy];
	} @catch (id e) {
		[self release];
		@throw e;
	}

	return self;
}

- (void)dealloc
{
	[_namespace release];
	[_prefix release];

	[super dealloc];
}

- (OFString*)description
{
	if (_namespace != nil)
		return [OFString stringWithFormat:
		    @"The namespace %@ is not bound in class %@", _namespace,
		    _inClass];
	else if (_prefix != nil)
		return [OFString stringWithFormat:
		    @"The prefix %@ is not bound to any namespace in class %@",
		    _prefix, _inClass];
	else
		return [OFString stringWithFormat:
		    @"A namespace or prefix is not bound in class %@",
		    _inClass];
}

- (OFString*)namespace
{
	OF_GETTER(_namespace, false)
}

- (OFString*)prefix
{
	OF_GETTER(_prefix, false)
}
@end
