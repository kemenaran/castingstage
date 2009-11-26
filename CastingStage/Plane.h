//
//  Plane.h
//  RayTracer
//
//  Created by Kemenaran on 9/7/09.
//  Copyright 2009 Isep. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Primitive.h"
#import "Ray.h"

@interface Plane : Primitive {
	vector3 origin;
	vector3 normalv;
}
@property vector3 origin;
@property vector3 normalv;

- (id) initWithOrigin:(vector3)theOrigin normal:(vector3)theNormal color:(NSColor*)theColor reflection:(float)theReflection;
- (vector3) normalAtPoint:(vector3)aPoint;
- (double) intersectsWithRay:(Ray)ray;

// NSCoding compilance
- (id)initWithCoder:(NSCoder*)coder;
- (void)encodeWithCoder:(NSCoder*)coder;

@end
