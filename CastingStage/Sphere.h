//
//  Sphere.h
//  Untitled
//
//  Created by Kemenaran on 8/26/09.
//  Copyright 2009 Isep. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Primitive.h"
#import "Ray.h"

@interface Sphere : Primitive {
	vector3 origin;
	double radius;
}
@property vector3 origin;
@property double radius;

- (id) initWithCenter:(vector3)theCenter radius:(double)theRadius color:(NSColor*)theColor reflection:(float)theReflection;
- (double) intersectsWithRay:(Ray)ray;

// NSCoding compilance
- (id)initWithCoder:(NSCoder*)coder;
- (void)encodeWithCoder:(NSCoder*)coder;

@end
