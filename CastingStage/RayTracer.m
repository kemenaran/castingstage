//
//  RayTracer.m
//  Untitled
//
//  Created by Kemenaran on 8/26/09.
//  Copyright 2009 Isep. All rights reserved.
//
#import "RayTracer.h"
#import "Ray.h"
#import "ScenePrimitives.h"
#import "Lightning.h"
//#import "GrandCentral.h"

#define IMAGE_DIST 2.0
#define EPSILON 0.005  // Prercentage of ray shortening
#define NO_LIGHT -1


@implementation RayTracer

@synthesize image, progression, size, viewport, backgroundColor, maxDepth, scene, lights, resolutionFactor;
@synthesize depthOfFieldEnabled, depthSamples, focalDistance, aperture;

- (id) init
{
	if (self = [super init]) {
		size = NSMakeSize(400.0, 400.0);
		viewport = NSMakeRect(-1, -1, 2, 2);
		image = [[NSImage alloc] initWithSize:NSMakeSize(size.width, size.height)];
		
		colorSpace = [NSColorSpace genericRGBColorSpace];
		backgroundColor = [[NSColor blackColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		errorColor      = [[NSColor greenColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		
		maxDepth = 3;
		resolutionFactor = 1;
		
		depthOfFieldEnabled = false;
		depthSamples = 16;
		focalDistance = 20;
		aperture = 0.1;
		
		scene = [NSMutableArray arrayWithCapacity:10];
		lights = [NSMutableArray arrayWithCapacity:5];
		
		// Init random generator
		srandom(time(0));
	}
	
	return self;
}

/** Convert coordinates */
- (vector3) convertPointFromBitmap:(vector3)aPoint {
	vector3 newPoint;
	
	newPoint.x =  (double)(viewport.size.width / size.width)   * aPoint.x + viewport.origin.x;
	newPoint.y =  -(double)(viewport.size.height / size.height) * aPoint.y - viewport.origin.y;
	newPoint.z =  aPoint.z;
	
	return newPoint;
}

/** Find the intersection of a ray and the focal plane */
- (Plane*) focalPlaneFromOrigin:(Ray)eye
{
	vector3 screenCenter;
	Ray fakeRay;
	Plane* fplane;
	
	// Find the center of the screen
	screenCenter = PointFromDistance(eye, IMAGE_DIST);
	
	// Create a fake ray from the eye to the center of the screen
	fakeRay.origin = eye.origin;
	fakeRay.direction = NormalizeVector(SubstractVector(screenCenter, fakeRay.origin));
	
	//The focal place is at FOCAL_DIST from the screen
	fplane = [[Plane alloc] init];
	[fplane setOrigin:PointFromDistance(fakeRay, IMAGE_DIST + focalDistance)];
	[fplane setNormalv:MakeVector(0, 0, -1)];
	
	return fplane;
}

/** Main entry point */
- (void) compute
{
	NSUInteger realWidth, realHeight;
	NSBitmapImageRep* bitmap;
	uint bytesPerRow;
	Ray eye;
	Plane* focalPlane;
	float progressionStep;
	
	// Set picture resolution
	realWidth = size.width * resolutionFactor;
	realHeight = size.height * resolutionFactor;
	bytesPerRow = (4 * realWidth);
	
	// Setup progression
	[self setProgression: 0];
	progressionStep = 1.0 / realHeight;
	
	// Create bitmap data
	bitmap = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
													 pixelsWide:realWidth
													 pixelsHigh:realHeight
												  bitsPerSample:8
												samplesPerPixel:4
													   hasAlpha:YES
													   isPlanar:NO
												 colorSpaceName:NSCalibratedRGBColorSpace
												   bitmapFormat:0
													bytesPerRow:bytesPerRow
												   bitsPerPixel:32];
	// Generic data
	eye.origin = MakeVector(0, 0, 0);
	eye.direction = MakeVector(0, 0, 1);
	focalPlane = [self focalPlaneFromOrigin:eye];
	NSGarbageCollector *collector = [NSGarbageCollector defaultCollector];
	
	// Cast rays from the source
#ifdef GRAND_CENTRAL
	int batchSize = 1;
	dispatch_apply(realHeight / batchSize, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^(size_t hd){
		for(int h = hd; h < hd + batchSize; h++) {
#else
	for(int h = 0; h < realHeight; h++) {
#endif		
		Ray ray;
		ray.origin = eye.origin;

		for (int w = 0; w < realWidth; w++) {
			vector3 direction = MakeVector(w / resolutionFactor, h / resolutionFactor, IMAGE_DIST);
			ray.direction = NormalizeVector([self convertPointFromBitmap:direction]);
			ray.refractionIndice = 1;
			
			// Cast ray
			if (depthOfFieldEnabled) {
				// Cast multiple depth-of-field rays
				[bitmap setColor:[self castLensRay:ray
										 fromPoint:[self convertPointFromBitmap:direction]
										 withFocal:focalPlane
										   atDepth:0] atX:w y:h];
				
			} else {
				// Cast single ray without depth-of-field
				[bitmap setColor:[self castRay:ray atDepth:0] atX:w y:h];
			}
			
		}
		
		[self setProgression:[self progression] + progressionStep];
		
		[collector collectIfNeeded];
	}
#ifdef GRAND_CENTRAL	
	});
	[collector collectIfNeeded];
#endif	
	
	// Create a new image with the representation
	NSImage* newImage;
	if (resolutionFactor > 1)
		newImage = [[NSImage alloc] initWithSize:NSMakeSize(realWidth, realHeight)];
	else
		newImage = [[NSImage alloc] initWithSize:size];

	[newImage addRepresentation:bitmap];
	
	// Change the image
	[self willChangeValueForKey:@"image"];
	image = newImage;
	[self didChangeValueForKey:@"image"];
}

- (Primitive*) intersectionOfRay:(Ray)theRay withObjects:(NSArray*)theScene atDistance:(double*)outT;
{
	double t, nearestIntersection = INFINITY;
	Primitive* nearestObject = nil;
	
	// Test intersection for each object in the scene
	for(id object in theScene) {
		t = [object intersectsWithRay:theRay];
		if (t != INFINITY) {
			if (t < nearestIntersection) {
				nearestIntersection = t;
				nearestObject = object;
			}
		}
	}
	
	if (outT != NULL)
		*outT = nearestIntersection;
	
	return nearestObject;
}

/** Cast several rays to generate a depth-of-field effect */
- (NSColor*) castLensRay:(Ray)theRay
				   fromPoint:(vector3)imagePoint
				   withFocal:(Plane*)focalPlane
				   atDepth:(NSUInteger)depth
{
	double t;
	float d, theta;
	float r = 0, g = 0, b = 0;
	vector3 focalPoint, randomPoint;
	Ray randomRay;
	NSColor* result;
	
	// Find the intersection of *this* ray and the focal plane
	t = [focalPlane intersectsWithRay:theRay];
	focalPoint = PointFromDistance(theRay, t);
	
	// Now we start averaging around the focal point
	for (int i = 0; i < depthSamples; i++) {
		
		// Find a random point on an unit circle
		d = (float)random()/RAND_MAX * (aperture / 2);
		theta = (float)random()/RAND_MAX * 2 * pi;
		randomPoint.x = sqrt(d) * cos(theta);
		randomPoint.y = sqrt(d) * sin(theta);
		randomPoint.z = 0;
		
		// Build a random ray around the imagePoint
		randomRay.origin = AddVector(imagePoint, randomPoint);
		randomRay.direction = NormalizeVector(SubstractVector(focalPoint, randomRay.origin));
		
		// Now we shoot the ray
		result = [self castRay:randomRay atDepth:0];
		
		// … and store the result for future averaging
		r += [result redComponent];
		g += [result greenComponent];
		b += [result blueComponent];
	}
	
	// Do the average of the results, and return the color
	return [NSColor colorWithCalibratedRed: r / depthSamples
									 green: g / depthSamples
									  blue: b / depthSamples
									 alpha:1];
}

/** Cast a single ray (without depth-of-field effect) */
 - (NSColor*) castRay:(Ray)theRay atDepth:(NSUInteger)depth
{
	vector3 lightRayPoint;
	Primitive *nearestObject;
	double t, lightAngle;
	
	// Simple tree-pruning	
	if (depth >= maxDepth)
		return backgroundColor;
	
	
	// Test intersection for each object in the scene
	nearestObject = [self intersectionOfRay:theRay withObjects:scene atDistance:&t];
	
	// If we didn't had any intersection, return background color
	if (nearestObject == nil)
		return backgroundColor;
	
	// We fucked up : we're probably inside the primitive.
	if (t < EPSILON)
		return errorColor;
	
	vector3 intersectionPoint = PointFromDistance(theRay, t);
	
	// Create the lightning equation
	Lightning* lightning = [[Lightning alloc] init];
	[lightning setColorSpace:colorSpace];
	[lightning setDiffuseColor:[nearestObject color]];
	
	// Enumerate lights
	for (Light* someLight in lights) {
		for (PointLight* aLight in [someLight lightPoints]) {
			
			// Displace the ray's origin, to be sure we're not in the primitive
			//lightRayPoint = PointFromDistance(theRay, t);
			//lightRayPoint = PointFromDistance(theRay, (1 - EPSILON) * t);
			lightRayPoint = AddVector(intersectionPoint, MultiplyByScalar([nearestObject normalAtPoint:intersectionPoint], EPSILON));
			
			// Add the light if it is visible
			lightAngle = [self angleOfLight:aLight atPoint:lightRayPoint ofObject:nearestObject];
			if (lightAngle != NO_LIGHT)
				[lightning addLight:aLight atAngle:lightAngle];
		}
	}
	
	// Compute reflecting ray
	if ([nearestObject reflection] > 0) {
		Ray specularRay = [nearestObject reflectionFromRay:theRay atPoint:PointFromDistance(theRay, (1 - EPSILON) * t)];
		[lightning setReflection:[nearestObject reflection]];
		
		// *Cast ray*
		[lightning setReflectionColor:[self castRay:specularRay
											atDepth:depth+1]];
	}
	
	// Compute refracting ray
	if ([nearestObject refraction] > 0) {
		Ray refractionRay = [nearestObject refractionFromRay:theRay atPoint:PointFromDistance(theRay, (1 + EPSILON) * t)];
		[lightning setRefraction:[nearestObject refraction]];
		
		// *Cast ray*
		[lightning setRefractionColor:[self castRay:refractionRay
											atDepth:depth+1]];
	}
		
	return [lightning compute];
}

/** Naïve method to tell if a point is lighten by a specific lightsource */
- (double) angleOfLight:(PointLight*)theLight atPoint:(vector3)thePoint ofObject:(Primitive*)theObject
{
	double t, lightDotProduct;
	Ray shadowRay;
	
	shadowRay.origin = thePoint;
	shadowRay.direction = NormalizeVector(SubstractVector([theLight position], shadowRay.origin));
	
	// Cast ray	
	[self intersectionOfRay:shadowRay withObjects:scene atDistance:&t];
	
	// If we have a visible light…
	double d = Distance(thePoint, [theLight position]);
	if (d < t) {
		
		vector3 normalv = [theObject normalAtPoint:thePoint];
		lightDotProduct = DotProduct(shadowRay.direction, normalv);
		
		// If we are facing the light…
		if (lightDotProduct > 0)
			return acos(lightDotProduct);
	}
	
	return NO_LIGHT;
}

@end
