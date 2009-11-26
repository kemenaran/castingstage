//
//  Light.h
//  RayTracer
//
//  Created by Kemenaran on 8/29/09.
//  Copyright 2009 Isep. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Light : NSObject {
	float intensity;
}
@property float intensity;

- (id) initWithIntensity:(float)theIntensity;
- (id) init;
- (id) copyWithZone:(NSZone *)zone;

// NSCoding compilance
- (id)initWithCoder:(NSCoder*)coder;
- (void)encodeWithCoder:(NSCoder*)coder;
- (NSArray*) lightPoints;

@end
