//
//  PointLight.h
//  RayTracer
//
//  Created by Kemenaran on 8/29/09.
//  Copyright 2009 Isep. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Light.h"
#import "Ray.h"

@interface PointLight : Light {
	vector3 position;
	NSArray* lightPoints;
}
@property vector3 position;

- (id) initWithIntensity:(float)theIntensity position:(vector3)thePosition;
- (id) copyWithZone:(NSZone *)zone;

// NSCoding compilance
- (id)initWithCoder:(NSCoder*)coder;
- (void)encodeWithCoder:(NSCoder*)coder;

@end
