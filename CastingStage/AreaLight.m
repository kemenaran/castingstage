//
//  AreaLight.m
//  RayTracer
//
//  Created by Kemenaran on 9/20/09.
//  Copyright 2009 Isep. All rights reserved.
//

#import "AreaLight.h"
#import "PointLight.h"
#import <math.h>

@implementation AreaLight

@synthesize position, radius, samples;

- (id) init
{
	if (self = [super init]) {
		radius = 1;
		samples = 5;
	}
	return self;
}

- (id) initWithIntensity:(float)theIntensity
				position:(vector3)thePosition
				  radius:(float)theRadius
				 samples:(NSInteger)theSamples
{
	if (self = [self init]) {
		intensity = theIntensity;
		position = thePosition;
		radius = theRadius;
		samples = theSamples;
	}
	
	return self;
}

- (id) copyWithZone:(NSZone *)zone {
	AreaLight* copy = [super copyWithZone:zone];
	[copy setPosition:position];
	[copy setRadius:radius];
	return copy;
}

- (id) initWithCoder:(NSCoder*)coder {
	
	self = [super initWithCoder:coder];
	
	// Decoding
    position.x = [coder decodeDoubleForKey:@"RTposition.x"];
	position.y = [coder decodeDoubleForKey:@"RTposition.y"];
	position.z = [coder decodeDoubleForKey:@"RTposition.z"];
	
	radius = [coder decodeFloatForKey:@"RTradius"];
	samples = [coder decodeIntForKey:@"RTsamples"]; 
	
	return self;	
}

- (void) encodeWithCoder:(NSCoder*)coder {
	[super encodeWithCoder:coder];
	
	// Encoding
	[coder encodeDouble:position.x forKey:@"RTposition.x"];
	[coder encodeDouble:position.y forKey:@"RTposition.y"];
	[coder encodeDouble:position.z forKey:@"RTposition.z"];
	
	[coder encodeFloat:radius forKey:@"RTradius"];
	[coder encodeInt:samples forKey:@"RTsamples"];
}

- (NSArray*) lightPoints
{
	float u, v, z, theta, phi;
	vector3 samplePosition;
	NSMutableArray* lightPoints = [NSMutableArray arrayWithCapacity:samples];
	
	for (int i = 0; i < samples; i++) {
		// Randomize
		u = (float)random()/RAND_MAX;
		v = (float)random()/RAND_MAX;
		
		z = 2.0 * radius * u  - radius;
		phi = 2 * pi * v;
		theta = asin(z/radius);
		
		// Convert to cartesian
		samplePosition.x = radius * cos(theta) * cos(phi);
		samplePosition.y = radius * cos(theta) * sin(phi);
		samplePosition.z = radius * sin(theta);
		
		// Set back the origin of the light
		samplePosition = AddVector(samplePosition, position);
		
		// Get points on the sphere
		[lightPoints addObject:[[PointLight alloc] initWithIntensity:(intensity/(float)samples) position:samplePosition]];
		
	}
	
	return lightPoints;
}

@end
