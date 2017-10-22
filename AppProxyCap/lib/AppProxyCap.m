//
//  AppProxyCap.m
//  AppProxyCap
//
//  Created by Du Song on 11-10-22.
//  Copyright (c) 2011年 FreeWheel Inc. All rights reserved.
//

#import "AppProxyCap.h"
#import "interpose.h"
#include <SystemConfiguration/SCDynamicStore.h> 
#include <SystemConfiguration/SCSchemaDefinitions.h> 

@implementation AppProxyCap

typedef CFDictionaryRef (*_SCDynamicStoreCopyProxies) (SCDynamicStoreRef store);
static _SCDynamicStoreCopyProxies origin_SCDynamicStoreCopyProxies;

/*
typedef Boolean (* _CFReadStreamOpen) (CFReadStreamRef stream);
static _CFReadStreamOpen origin_CFReadStreamOpen;
 
typedef CFReadStreamRef (*_CFReadStreamCreate) (CFAllocatorRef alloc, const void *callbacks, void *info);
typedef CFReadStreamRef (*_CFReadStreamCreateForHTTPRequest) (CFAllocatorRef alloc, CFHTTPMessageRef request);
typedef CFReadStreamRef (*_CFReadStreamCreateForStreamedHTTPRequest) (CFAllocatorRef alloc, CFHTTPMessageRef requestHeaders, CFReadStreamRef requestBody);
extern _CFReadStreamCreate CFReadStreamCreate;
static _CFReadStreamCreateForHTTPRequest origin_CFReadStreamCreateForHTTPRequest;
static _CFReadStreamCreateForStreamedHTTPRequest origin_CFReadStreamCreateForStreamedHTTPRequest;
static _CFReadStreamCreate origin_CFReadStreamCreate;

static void proxify(CFReadStreamRef ref) {
if (!ref || !proxyType || !proxySetting) return;
CFReadStreamSetProperty(ref, proxyType, proxySetting);
NSLog(@"Proxify");
}

static Boolean new_CFReadStreamOpen(CFReadStreamRef stream) {
proxify(stream);
return origin_CFReadStreamOpen(stream);
}
 
static CFReadStreamRef new_CFReadStreamCreate(CFAllocatorRef alloc, const void *callbacks, void *info) {
CFReadStreamRef ref = origin_CFReadStreamCreate(alloc, callbacks, info);
proxify(ref);
return ref;
}

static CFReadStreamRef new_CFReadStreamCreateForHTTPRequest(CFAllocatorRef alloc, CFHTTPMessageRef request){
CFReadStreamRef ref = origin_CFReadStreamCreateForHTTPRequest(alloc, request);
proxify(ref);
return ref;
}

static CFReadStreamRef new_CFReadStreamCreateForStreamedHTTPRequest(CFAllocatorRef alloc, CFHTTPMessageRef requestHeaders, CFReadStreamRef requestBody) {
CFReadStreamRef ref = origin_CFReadStreamCreateForStreamedHTTPRequest(alloc, requestHeaders, requestBody);
proxify(ref);
return ref;
}
static CFStringRef proxyType = NULL;
static NSMutableDictionary *proxySetting = NULL;
*/
static bool activated = NO;
static NSDictionary *proxyPref = NULL;
extern CFDictionaryRef SCDynamicStoreCopyProxies (SCDynamicStoreRef store);
static CFDictionaryRef new_SCDynamicStoreCopyProxies (SCDynamicStoreRef store) {
	if (!activated || !proxyPref) 
		return origin_SCDynamicStoreCopyProxies(store);
	NSLog(@"AppProxyCap: proxify configuration applied: %@", proxyPref);
	return CFDictionaryCreateCopy(NULL, (CFDictionaryRef)proxyPref);
}

+ (void) activate {
	if (activated) return;
	activated = YES;
	/*
	origin_CFReadStreamCreate = (_CFReadStreamCreate) &CFReadStreamCreate;
	origin_CFReadStreamCreateForHTTPRequest = &CFReadStreamCreateForHTTPRequest;
	origin_CFReadStreamCreateForStreamedHTTPRequest = &CFReadStreamCreateForStreamedHTTPRequest;
	if (!interpose("_CFReadStreamCreateForHTTPRequest", new_CFReadStreamCreateForHTTPRequest)) NSLog(@"error override _CFReadStreamCreateForHTTPRequest");
	if (!interpose("_CFReadStreamCreateForStreamedHTTPRequest", new_CFReadStreamCreateForStreamedHTTPRequest)) NSLog(@"error override _CFReadStreamCreateForStreamedHTTPRequest");
	if (!interpose("_CFReadStreamCreate", new_CFReadStreamCreate)) NSLog(@"error override _CFReadStreamCreate");
	origin_CFReadStreamOpen = &CFReadStreamOpen;
	if (!interpose("_CFReadStreamOpen", new_CFReadStreamOpen)) NSLog(@"error override _CFReadStreamCreate");
	 */
	origin_SCDynamicStoreCopyProxies = &SCDynamicStoreCopyProxies;
	if (!interpose("_SCDynamicStoreCopyProxies", new_SCDynamicStoreCopyProxies)) NSLog(@"AppProxyCap: error override _SCDynamicStoreCopyProxies");
}

+(void)setNoProxy {
    [proxyPref release];
    proxyPref = NULL;
}

+(void)setPACURL:(NSString *)pacURL {
	[proxyPref release];
    proxyPref = [[NSDictionary dictionaryWithObjectsAndKeys:
                  [NSNumber numberWithInt:1], @"ProxyAutoConfigEnable",
                  pacURL, @"ProxyAutoConfigURLString",
                  nil] retain];
    
}

+ (void) setProxy:(AppProxyType)type Host:(NSString *)host Port:(int)port {
	[proxyPref release];
	switch (type) {
		case AppProxy_HTTP:
			proxyPref = [[NSDictionary dictionaryWithObjectsAndKeys:
							//[NSNumber numberWithInt:1], @"HTTPProxyType",
							//[NSNumber numberWithInt:0], @"ProxyAutoConfigEnable",
							[NSNumber numberWithInt:1], @"HTTPEnable",
							host, @"HTTPProxy",
							[NSNumber numberWithInt:port], @"HTTPPort",
							[NSNumber numberWithInt:1], @"HTTPSEnable",
							host, @"HTTPSProxy",
							[NSNumber numberWithInt:port], @"HTTPSPort",
							nil] retain];
			/*
			proxyType = kCFStreamPropertyHTTPProxy;
			proxySetting = [NSMutableDictionary dictionaryWithObjectsAndKeys:
												host, kCFStreamPropertyHTTPProxyHost,
												[NSNumber numberWithInt:port], kCFStreamPropertyHTTPProxyPort,
												host, kCFStreamPropertyHTTPSProxyHost,
												[NSNumber numberWithInt:port], kCFStreamPropertyHTTPSProxyPort,
												nil];
			 */ 
			break;
        case AppProxy_SOCKS:
			proxyPref = [[NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInt:1], @"SOCKSEnable",
                          host, @"SOCKSProxy",
                          [NSNumber numberWithInt:port], @"SOCKSPort",
                          nil] retain];
            break;
            
			
		default:
			/*
			proxyType = NULL;
			proxySetting = NULL;
			 */
			proxyPref = NULL;
			break;
	}
}

@end
