//
//  CSDocument.h
//  RayTracer
//
//  Created by Kemenaran on 9/17/09.
//  Copyright 2009 Isep. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RayTracer;

@interface CSDocument : NSDocument {
	RayTracer* rayTracer;
}
@property(readonly) RayTracer* rayTracer;

@end
