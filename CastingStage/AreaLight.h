//
//  AreaLight.h
//  RayTracer
//
//  Created by Kemenaran on 9/20/09.
//  Copyright 2009 Isep. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Light.h"
#import "vector3.h"

@interface AreaLight : Light {
	vector3 position;
	float radius;
	NSInteger samples;
}
@property vector3 position;
@property float radius;
@property NSInteger samples;

- (id) init;
- (id) initWithIntensity:(float)theIntensity
				position:(vector3)thePosition
				  radius:(float)theRadius
				 samples:(NSInteger)theSamples;
- (id) copyWithZone:(NSZone *)zone;

// NSCoding compilance
- (id)initWithCoder:(NSCoder*)coder;
- (void)encodeWithCoder:(NSCoder*)coder;

@end
