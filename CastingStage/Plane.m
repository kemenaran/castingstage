//
//  Plane.m
//  RayTracer
//
//  Created by Kemenaran on 9/7/09.
//  Copyright 2009 Isep. All rights reserved.
//

#import "Plane.h"
#import "Ray.h"

@implementation Plane

@synthesize origin, normalv;

- (id) initWithOrigin:(vector3)theOrigin normal:(vector3)theNormal color:(NSColor*)theColor reflection:(float)theReflection
{
	if (self = [super initWithColor:theColor reflection:theReflection]) {
		origin = theOrigin;
		normalv = NormalizeVector(theNormal);
	}
	
	return self;
}

- (id) initWithCoder:(NSCoder*)coder {
	
	self = [super initWithCoder:coder];
	
	// Decoding
    origin.x = [coder decodeDoubleForKey:@"RTorigin.x"];
	origin.y = [coder decodeDoubleForKey:@"RTorigin.y"];
	origin.z = [coder decodeDoubleForKey:@"RTorigin.z"];
	
	normalv.x = [coder decodeDoubleForKey:@"RTnormalv.x"];
	normalv.y = [coder decodeDoubleForKey:@"RTnormalv.y"];
	normalv.z = [coder decodeDoubleForKey:@"RTnormalv.z"];
	
    return self;	
}

- (void) encodeWithCoder:(NSCoder*)coder {
	[super encodeWithCoder:coder];
	
	// Encoding
	[coder encodeDouble:origin.x forKey:@"RTorigin.x"];
	[coder encodeDouble:origin.y forKey:@"RTorigin.y"];
	[coder encodeDouble:origin.z forKey:@"RTorigin.z"];
	
	[coder encodeDouble:normalv.x forKey:@"RTnormalv.x"];
	[coder encodeDouble:normalv.y forKey:@"RTnormalv.y"];
	[coder encodeDouble:normalv.z forKey:@"RTnormalv.z"];
}

- (void) setNormalv:(vector3)theNormal
{
	normalv = NormalizeVector(theNormal);
}

- (vector3) normalAtPoint:(vector3)aPoint
{
	return normalv;
}

- (double) intersectsWithRay:(Ray)ray
{	
	double numerator, denominator, d, t;
	
	d = -DotProduct(normalv, origin);
	numerator = -d - DotProduct(ray.origin, normalv);
	denominator = DotProduct(normalv, ray.direction);
	
	if (numerator == 0 || denominator >= 0 || (t = (numerator / denominator)) < 0)
		return INFINITY;
	else
		return t;
}



@end
