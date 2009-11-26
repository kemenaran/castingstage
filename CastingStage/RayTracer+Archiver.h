//
//  RayTracer+Archiver.h
//  RayTracer
//
//  Created by Kemenaran on 9/17/09.
//  Copyright 2009 Isep. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RayTracer.h"

@interface RayTracer (RayTracer_Archiver)

- (id)initWithCoder:(NSCoder*)coder;
- (void)encodeWithCoder:(NSCoder*)coder;

@end
