//
//  APCAppDelegate.m
//  TestMac
//
//  Created by Du Song on 11-10-22.
//  Copyright (c) 2011年 FreeWheel Inc. All rights reserved.
//

#import "APCAppDelegate.h"
#import <CoreServices/CoreServices.h>

@implementation APCAppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	NSError *error = nil;
	NSString *s = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.iana.org/robots.txt"] encoding:NSUTF8StringEncoding error:&error];
	NSLog(@"Loaded %@ error %@", s, error);

	exit(0);
}

@end
