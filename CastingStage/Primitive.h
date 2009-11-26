//
//  Primitive.h
//  RayTracer
//
//  Created by Kemenaran on 8/26/09.
//  Copyright 2009 Isep. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Ray.h"

@interface Primitive : NSObject {
	NSColor* color;
	float reflection;
	float refraction;
	float refractionIndice;
}
@property(copy) NSColor* color;
@property float reflection;
@property float refraction;
@property float refractionIndice;

- (id) initWithColor:(NSColor*)theColor reflection:(float)theReflection;
- (id) initWithColor:(NSColor*)theColor reflection:(float)theReflection refraction:(float)theRefraction indice:(float)theIndice;
- (id) init;
- (id)initWithCoder:(NSCoder*)coder;
- (void)encodeWithCoder:(NSCoder*)coder;
- (vector3) normalAtPoint:(vector3)aPoint;
- (double) intersectsWithRay:(Ray)ray;
- (Ray) reflectionFromRay:(Ray)ray atPoint:(vector3)aPoint;
- (Ray) refractionFromRay:(Ray)ray atPoint:(vector3)aPoint;

// NSCoding compilance
- (id)initWithCoder:(NSCoder*)coder;
- (void)encodeWithCoder:(NSCoder*)coder;

@end
