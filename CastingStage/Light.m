//
//  Light.m
//  RayTracer
//
//  Created by Kemenaran on 8/29/09.
//  Copyright 2009 Isep. All rights reserved.
//

#import "Light.h"


@implementation Light

@synthesize intensity;

- (id) initWithIntensity:(float)theIntensity;
{
	if (self = [super init]) {
		intensity = theIntensity;
	}
	
	return self;
}

- (id) init
{
	return [self initWithIntensity:1];
}

- (id) copyWithZone:(NSZone *)zone {
	Light* copy = [[[self class] allocWithZone:zone] init];
	[copy setIntensity:intensity];
	return copy;
}

- (id) initWithCoder:(NSCoder*)coder {
	self = [super init];
	
	// Decoding
    intensity = [coder decodeFloatForKey:@"RTintensity"];
	
    return self;	
}

- (void) encodeWithCoder:(NSCoder*)coder {
	
	// Encoding
	[coder encodeFloat:intensity forKey:@"RTintensity"];
	
}

- (NSArray*) lightPoints
{
	NSLog(@"Warning: Intended to be overriden in subclasses.");
	return nil;
}


@end
