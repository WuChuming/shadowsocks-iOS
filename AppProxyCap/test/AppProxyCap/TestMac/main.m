//
//  main.m
//  TestMac
//
//  Created by Du Song on 11-10-22.
//  Copyright (c) 2011年 FreeWheel Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppProxyCap.h"

int main(int argc, char *argv[])
{
	[AppProxyCap activate];
	[AppProxyCap setProxy:AppProxy_HTTP Host:@"127.0.0.1" Port:8086];
	return NSApplicationMain(argc, (const char **)argv);
}
