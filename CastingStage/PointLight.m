//
//  PointLight.m
//  RayTracer
//
//  Created by Kemenaran on 8/29/09.
//  Copyright 2009 Isep. All rights reserved.
//

#import "PointLight.h"


@implementation PointLight

@synthesize position;

- (id) initWithIntensity:(float)theIntensity position:(vector3)thePosition
{
	if (self = [super initWithIntensity:theIntensity]) {
		position = thePosition;
	}
	
	return self;
}

- (id) copyWithZone:(NSZone *)zone {
	PointLight* copy = [super copyWithZone:zone];
	[copy setPosition:position];
	return self;
}


- (id) initWithCoder:(NSCoder*)coder {
	
	self = [super initWithCoder:coder];
	
	// Decoding
    position.x = [coder decodeDoubleForKey:@"RTposition.x"];
	position.y = [coder decodeDoubleForKey:@"RTposition.y"];
	position.z = [coder decodeDoubleForKey:@"RTposition.z"];
	
	return self;	
}

- (void) encodeWithCoder:(NSCoder*)coder {
	[super encodeWithCoder:coder];
	
	// Encoding
	[coder encodeDouble:position.x forKey:@"RTposition.x"];
	[coder encodeDouble:position.y forKey:@"RTposition.y"];
	[coder encodeDouble:position.z forKey:@"RTposition.z"];
}

- (NSArray*) lightPoints
{
	// A cached version would indeed be better
	//if (lightPoints == nil)
		lightPoints = [NSArray arrayWithObject:self];
	
	return lightPoints;
}


@end
