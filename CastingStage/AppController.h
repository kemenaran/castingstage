//
//  MainController.h
//  Untitled
//
//  Created by Kemenaran on 8/26/09.
//  Copyright 2009 Isep. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppController : NSObject {
}

+ (void) initialize;

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)theApplication;
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication;

@end
