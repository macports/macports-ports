--- Frameworks/AIUtilities Framework/NDRunLoopMessenger.h.orig	2005-04-03 19:18:52.000000000 -0400
+++ Frameworks/AIUtilities Framework/NDRunLoopMessenger.h	2005-04-03 19:18:56.000000000 -0400
@@ -9,20 +9,6 @@
 #import <Cocoa/Cocoa.h>
 
 /*!
-	@const kSendMessageException
-	@abstract <tt>NDRunLoopMessenger</tt> exception
-	@discussion An exception that can be thrown when sending a message by means of <tt>NDRunLoopMessenger</tt>. This includes any messages forwarded by the proxy returned from the methods <tt>target:</tt> and <tt>target:withResult:</tt>.
- */
-extern NSString		* kSendMessageException;
-
-/*!
- 	@const kConnectionDoesNotExistsException
-	@abstract <tt>NDRunLoopMessenger</tt> exception
-	@discussion An exception that can be thrown when sending a message by means of <tt>NDRunLoopMessenger</tt>. This includes any messages forwarded by the proxy returned from the methods <tt>target:</tt> and <tt>target:withResult:</tt>.
-  */
-extern NSString		* kConnectionDoesNotExistsException;
-
-/*!
 	@class NDRunLoopMessenger
 	@abstract Class to provide thread intercommunication
 	@discussion A light weight version of distributed objects that only works between threads within the same process. <tt>NDRunLoopMessenger</tt> works by only passing the address of a <tt>NSInvocation</tt>  object through a run loop port, this is all that is needed since the object is already within the same process memory space. This means that all the parameters do not need to be serialized. Results are returned simply by waiting on a lock for a message result to be put into the <tt>NSInvocation</tt>.
