//
//  MainController.m
//  Untitled
//
//  Created by Kemenaran on 8/26/09.
//  Copyright 2009 Isep. All rights reserved.
//

#import "AppController.h"
#import "PointToStringTransformer.h"

@implementation AppController

+ (void) initialize
{
	[NSValueTransformer setValueTransformer:[[PointToStringTransformer alloc] init] forName:@"PointToStringTransformer"];
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)theApplication
{
    return NO;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
	return NO;
}

@end
