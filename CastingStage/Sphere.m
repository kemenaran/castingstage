//
//  Sphere.m
//  Untitled
//
//  Created by Kemenaran on 8/26/09.
//  Copyright 2009 Isep. All rights reserved.
//

#import "Sphere.h"
#import "Ray.h"

@implementation Sphere

@synthesize origin, radius;

- (id) initWithCenter:(vector3)theCenter radius:(double)theRadius color:(NSColor*)theColor reflection:(float)theReflection
{
	if (self = [super initWithColor:theColor reflection:theReflection]) {
		origin = theCenter;
		radius = theRadius;
	}
	
	return self;
}

- (id) initWithCoder:(NSCoder*)coder {
	
	self = [super initWithCoder:coder];
	
	// Decoding
    origin.x = [coder decodeDoubleForKey:@"RTorigin.x"];
	origin.y = [coder decodeDoubleForKey:@"RTorigin.y"];
	origin.z = [coder decodeDoubleForKey:@"RTorigin.z"];
	
	radius = [coder decodeDoubleForKey:@"RTradius"];
	
    return self;	
}

- (void) encodeWithCoder:(NSCoder*)coder {
	[super encodeWithCoder:coder];
	
	// Encoding
	[coder encodeDouble:origin.x forKey:@"RTorigin.x"];
	[coder encodeDouble:origin.y forKey:@"RTorigin.y"];
	[coder encodeDouble:origin.z forKey:@"RTorigin.z"];
	
	[coder encodeDouble:radius forKey:@"RTradius"];
}

- (vector3) normalAtPoint:(vector3)aPoint
{
	vector3 normalv;
	normalv.x = aPoint.x - origin.x;
	normalv.y = aPoint.y - origin.y;
	normalv.z = aPoint.z - origin.z;
	return NormalizeVector(normalv);
}

- (double) intersectsWithRay:(Ray)ray
{	
	double t, v, discriminant;
	vector3 cp;
	
	cp = SubstractVector(origin, ray.origin);
	v = DotProduct(cp, NormalizeVector(ray.direction));
	discriminant = (radius * radius) - (DotProduct(cp, cp) - v*v);
	
	if (discriminant < 0)
		return INFINITY;
	else {
		t = v - sqrt(discriminant);
		if (t < 0)
			return INFINITY;
		else
			return t;
	}
}

@end
