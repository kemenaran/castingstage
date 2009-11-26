//
//  Primitive.m
//  RayTracer
//
//  Created by Kemenaran on 8/26/09.
//  Copyright 2009 Isep. All rights reserved.
//

#import "Primitive.h"

@implementation Primitive

@synthesize color, reflection, refraction, refractionIndice;

- (id) initWithColor:(NSColor*)theColor reflection:(float)theReflection refraction:(float)theRefraction indice:(float)theIndice
{
	if (self = [super init]) {
		color  = theColor; 
		reflection = theReflection;
		refraction = theRefraction;
		refractionIndice = theIndice;
	}
	
	return self;
}

- (id) initWithColor:(NSColor*)theColor reflection:(float)theReflection
{
	return [self initWithColor:theColor reflection:theReflection refraction:0 indice:1];
}

- (id) init
{
	return [self initWithColor:[NSColor redColor] reflection:0 refraction:0 indice:1];
}

- (id) initWithCoder:(NSCoder*)coder {
	
	self = [super init];
	
	// Decoding
	color = [coder decodeObjectForKey:@"RTcolor"];
	reflection = [coder decodeFloatForKey:@"RTreflection"];
	refraction = [coder decodeFloatForKey:@"RTrefraction"];
	refractionIndice = [coder decodeFloatForKey:@"RTrefractionIndice"];
	
    return self;	
}

- (void) encodeWithCoder:(NSCoder*)coder {
	// Do not [super encodeWithCoder:coder] : NSObject does not support it.
	
	[coder encodeObject:color forKey:@"RTcolor"];
	[coder encodeFloat:reflection forKey:@"RTreflection"];
	[coder encodeFloat:refraction forKey:@"RTrefraction"];
	[coder encodeFloat:refractionIndice forKey:@"RTrefractionIndice"];
}

- (vector3) normalAtPoint:(vector3)aPoint
{
	NSLog(@"Primitive::intersects: is mean to be overriden, and not called directly.");
	
	vector3 err;
	err.x = 0xDEADBEEF;
	err.y = 0xDEADBEEF;
	err.z = 0xDEADBEEF;
	return err;
}

- (double) intersectsWithRay:(Ray)ray
{
	NSLog(@"Primitive::intersects: is mean to be overriden, and not called directly.");
	return FALSE;
}

- (Ray) reflectionFromRay:(Ray)ray atPoint:(vector3)aPoint;
{
	Ray reflectedRay;
	
	vector3 normalv = [self normalAtPoint:aPoint];
	double Vpar = DotProduct(MultiplyByScalar(ray.direction, 2), normalv);
	
	reflectedRay.origin = aPoint;
	reflectedRay.direction = SubstractVector(ray.direction, MultiplyByScalar(normalv, Vpar));
	reflectedRay.refractionIndice = ray.refractionIndice;
	
	return reflectedRay;
}

- (Ray) refractionFromRay:(Ray)ray atPoint:(vector3)aPoint
{
	Ray refractedRay;
	vector3 N, V;
	double n, n1, n2, c1, c2;
	
	n1 = ray.refractionIndice;
	N = [self normalAtPoint:aPoint];
	V = ray.direction;
	n2 = refractionIndice;
	
	n = n1 / n2;
	c1 = -DotProduct(N, V);
	c2 = sqrt(1 - n*n * (1 - c1*c1));
	
	refractedRay.origin = aPoint;
	refractedRay.direction = AddVector(
									MultiplyByScalar(V, n),
									MultiplyByScalar(N, (n * c1 - c2))); 
	refractedRay.refractionIndice = n2;
	
	return refractedRay;
}

@end
