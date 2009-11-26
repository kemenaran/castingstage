//
//  RayTracer.h
//  Untitled
//
//  Created by Kemenaran on 8/26/09.
//  Copyright 2009 Isep. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "Ray.h"


@class PointLight, Primitive, Plane;

@interface RayTracer : NSObject {
	// Output data
	NSImage* image;
	float progression;
	
	// Scene
	NSMutableArray* scene;
	NSMutableArray* lights;
	NSRect   viewport;
	
	// Depth-of-field
	bool      depthOfFieldEnabled;
	float     aperture;
	float     focalDistance;
	NSInteger depthSamples;
	
	// Settings
	float resolutionFactor;
	NSSize   size;
	NSColorSpace* colorSpace;
	NSColor* backgroundColor;
	NSColor* errorColor;
	NSInteger maxDepth;
}

@property(readonly) NSImage* image;
@property float     progression;

@property(copy)		NSMutableArray* scene;
@property(copy)		NSMutableArray* lights;
@property           NSRect   viewport;

@property bool  depthOfFieldEnabled;
@property float aperture;
@property float focalDistance;
@property NSInteger depthSamples;

@property float	    resolutionFactor;
@property           NSSize   size;
@property(copy)     NSColor* backgroundColor;
@property			NSInteger maxDepth;

- (id)init;
- (void) compute;
- (NSColor*) castLensRay:(Ray)theRay
			   fromPoint:(vector3)imagePoint
			   withFocal:(Plane*)focalPlane
				 atDepth:(NSUInteger)depth;
- (NSColor*) castRay:(Ray)theRay atDepth:(NSUInteger)depth;
- (double) angleOfLight:(PointLight*)theLight atPoint:(vector3)thePoint ofObject:(Primitive*)theObject;

@end
