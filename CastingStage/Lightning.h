//
//  Lightning.h
//  RayTracer
//
//  Created by Kemenaran on 8/27/09.
//  Copyright 2009 Isep. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Light;

@interface Lightning : NSObject {
	NSMutableDictionary* lights;
	NSColor* diffuseColor;
	float    reflection;
	NSColor* reflectionColor;
	float    refraction;
	NSColor* refractionColor;
	NSColorSpace* colorSpace;
	
	NSColor* white;
	NSColor* black;
}
@property(copy) NSColor* diffuseColor;
@property float reflection;
@property(copy) NSColor* reflectionColor;
@property float refraction;
@property(copy) NSColor* refractionColor;
@property NSColorSpace* colorSpace;

- (id) init;
- (void) addLight:(Light*)theLight atAngle:(double)theAngle;
- (void) clearLights;
- (NSColor*) compute;
- (NSColor*) blendedColor:(NSColor*)theColor withFraction:(CGFloat)theFraction ofColor:(NSColor*)theOtherColor;

@end
