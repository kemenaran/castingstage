//
//  Lightning.m
//  RayTracer
//
//  Created by Kemenaran on 8/27/09.
//  Copyright 2009 Isep. All rights reserved.
//

#import "Lightning.h"
#import "Light.h"
#import <math.h>

@implementation Lightning

@synthesize diffuseColor, reflection, reflectionColor;
@synthesize refraction, refractionColor, colorSpace;

- (id) init
{
	if (self = [super init]) {
		lights = [NSMutableDictionary dictionaryWithCapacity:5];
		colorSpace = [NSColorSpace genericRGBColorSpace];
		reflectionColor = [NSColor greenColor];
		refractionColor = [NSColor greenColor];
		
		white  = [[NSColor whiteColor] colorUsingColorSpace:colorSpace];
		black  = [[NSColor blackColor] colorUsingColorSpace:colorSpace];
	}
	
	return self;
}

- (void) addLight:(Light*)theLight atAngle:(double)theAngle
{
	[lights setObject:[NSNumber numberWithDouble:theAngle] forKey:theLight];
}

- (void) clearLights
{
	[lights removeAllObjects];
}

- (NSColor*) compute
{
	NSColor *color, *surface;
	double c1;
	
	diffuseColor    = [diffuseColor    colorUsingColorSpace:colorSpace];
	reflectionColor = [reflectionColor colorUsingColorSpace:colorSpace];
	refractionColor = [refractionColor colorUsingColorSpace:colorSpace];
	
	// Weighted sum of reflection and refraction
	if (reflection == 0 && refraction == 0) {
		// Unused anyway
		color = white;
	} else {
		if (reflection > refraction || refraction == 0) {
			c1 = refraction / reflection;
		} else {
			c1 = 1 - (reflection / refraction);
		}
	
		color = [self blendedColor:reflectionColor withFraction:c1 ofColor:refractionColor];
	}
	
	// Shadows
	float lightIntensity = 0;
	for (Light* aLight in lights)
		lightIntensity += [aLight intensity] * cos([[lights objectForKey:aLight] doubleValue]);
	// Normalize lightIntensity in [0,1] using atan()
	lightIntensity = 2*atan(lightIntensity)/pi;
	
	// Blend shadow with surface
	surface = [self blendedColor:diffuseColor withFraction:(1 - lightIntensity) ofColor:black];
	
	// Blend weighted reflection+refraction with shadow+surface
	return [self blendedColor:surface withFraction:MIN(1, reflection + refraction) ofColor:color];
}

- (NSColor*) blendedColor:(NSColor*)theColor withFraction:(CGFloat)theFraction ofColor:(NSColor*)theOtherColor
{
	NSColor* selfColor, *secondColor;
	float r, ir;
	r = theFraction;
	ir = 1 - theFraction;
	
	selfColor = [theColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	secondColor = [theOtherColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	
	
	
	return  [NSColor colorWithCalibratedRed:ir*[selfColor redComponent] + r*[secondColor redComponent]
											green:ir*[selfColor greenComponent] + r*[secondColor greenComponent]
											 blue:ir*[selfColor blueComponent] + r*[secondColor blueComponent]
											alpha:1];
				   
}

@end











