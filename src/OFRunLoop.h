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

#import "OFObject.h"
#import "OFStream.h"
#import "OFTCPSocket.h"

@class OFSortedList;
#ifdef OF_HAVE_THREADS
@class OFMutex;
#endif
@class OFTimer;
@class OFMutableDictionary;
@class OFStreamObserver;

/*!
 * @brief A class providing a run loop for the application and its processes.
 */
@interface OFRunLoop: OFObject
{
	OFSortedList *_timersQueue;
#ifdef OF_HAVE_THREADS
	OFMutex *_timersQueueLock;
#endif
	OFStreamObserver *_streamObserver;
	OFMutableDictionary *_readQueues;
	volatile bool _running;
}

/*!
 * @brief Returns the main run loop.
 *
 * @return The main run loop
 */
+ (OFRunLoop*)mainRunLoop;

/*!
 * @brief Returns the run loop for the current thread.
 *
 * @return The run loop for the current thread
 */
+ (OFRunLoop*)currentRunLoop;

+ (void)OF_setMainRunLoop: (OFRunLoop*)runLoop;
+ (void)OF_addAsyncReadForStream: (OFStream*)stream
			  buffer: (void*)buffer
			  length: (size_t)length
			  target: (id)target
			selector: (SEL)selector;
+ (void)OF_addAsyncReadForStream: (OFStream*)stream
			  buffer: (void*)buffer
		     exactLength: (size_t)length
			  target: (id)target
			selector: (SEL)selector;
+ (void)OF_addAsyncReadLineForStream: (OFStream*)stream
			    encoding: (of_string_encoding_t)encoding
			      target: (id)target
			    selector: (SEL)selector;
+ (void)OF_addAsyncAcceptForTCPSocket: (OFTCPSocket*)socket
			       target: (id)target
			     selector: (SEL)selector;
#ifdef OF_HAVE_BLOCKS
+ (void)OF_addAsyncReadForStream: (OFStream*)stream
			  buffer: (void*)buffer
			  length: (size_t)length
			   block: (of_stream_async_read_block_t)block;
+ (void)OF_addAsyncReadForStream: (OFStream*)stream
			  buffer: (void*)buffer
		     exactLength: (size_t)length
			   block: (of_stream_async_read_block_t)block;
+ (void)OF_addAsyncReadLineForStream: (OFStream*)stream
			    encoding: (of_string_encoding_t)encoding
			       block: (of_stream_async_read_line_block_t)block;
+ (void)OF_addAsyncAcceptForTCPSocket: (OFTCPSocket*)socket
				block: (of_tcpsocket_async_accept_block_t)block;
#endif
+ (void)OF_cancelAsyncRequestsForStream: (OFStream*)stream;

/*!
 * @brief Adds an OFTimer to the run loop.
 *
 * @param timer The timer to add
 */
- (void)addTimer: (OFTimer*)timer;

- (void)OF_removeTimer: (OFTimer*)timer;

/*!
 * @brief Starts the run loop.
 */
- (void)run;

/*!
 * @brief Stops the run loop. If there is still an operation being executed, it
 *	  is finished before the run loop stops.
 */
- (void)stop;
@end
