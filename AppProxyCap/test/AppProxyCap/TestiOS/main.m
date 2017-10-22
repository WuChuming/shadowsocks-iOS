//
//  main.m
//  TestiOS
//
//  Created by Du Song on 11-10-23.
//  Copyright (c) 2011年 FreeWheel Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "APCAppDelegate.h"
#import "AppProxyCap.h"

int main(int argc, char *argv[])
{
	@autoreleasepool {
		[AppProxyCap activate];
		[AppProxyCap setProxy:AppProxy_HTTP Host:@"192.168.1.4" Port:8086];
	    return UIApplicationMain(argc, argv, nil, NSStringFromClass([APCAppDelegate class]));
	}
}
