//
//  RayTracer+Archiver.m
//  RayTracer
//
//  Created by Kemenaran on 9/17/09.
//  Copyright 2009 Isep. All rights reserved.
//

#import "RayTracer+Archiver.h"


@implementation RayTracer (RayTracer_Archiver)

- (id) initWithCoder:(NSCoder*)coder {
	self = [super init];
	
	// Decoding
    size = [coder decodeSizeForKey:@"RTsize"];
	viewport.origin = [coder decodePointForKey:@"RTviewport.origin"];
	viewport.size = [coder decodeSizeForKey:@"RTviewport.size"];
	backgroundColor = [coder decodeObjectForKey:@"RTbackgroundColor"];
	maxDepth = [coder decodeIntForKey:@"RTmaxDepth"];
	colorSpace = [coder decodeObjectForKey:@"RTcolorSpace"];
	resolutionFactor = [coder decodeFloatForKey:@"RTresolutionFactor"];
	
	depthOfFieldEnabled = [coder decodeBoolForKey:@"RTdepthOfFieldEnabled"];
	aperture = [coder decodeFloatForKey:@"RTaperture"];
	focalDistance = [coder decodeFloatForKey:@"RTfocalDistance"];
	depthSamples = [coder decodeIntForKey:@"RTdepthSamples"];
	
	scene = [coder decodeObjectForKey:@"RTscene"];
	lights = [coder decodeObjectForKey:@"RTlights"];
	
	// Other initializations
	image = [[NSImage alloc] initWithSize:NSMakeSize(size.width, size.height)];
	
    return self;	
}

- (void) encodeWithCoder:(NSCoder*)coder {
	// Do not [super encodeWithCoder:coder] : NSObject does not support it.
	
	[coder encodeSize:size forKey:@"RTsize"];
	[coder encodePoint:viewport.origin forKey:@"RTviewport.origin"];
	[coder encodeSize:viewport.size forKey:@"RTviewport.size"];
	[coder encodeObject:backgroundColor forKey:@"RTbackgroundColor"];
	[coder encodeInt:maxDepth forKey:@"RTmaxDepth"];
	[coder encodeObject:colorSpace forKey:@"RTcolorSpace"];
	[coder encodeFloat:resolutionFactor forKey:@"RTresolutionFactor"];
	
	[coder encodeBool:depthOfFieldEnabled forKey:@"RTdepthOfFieldEnabled"];
	[coder encodeFloat:aperture forKey:@"RTaperture"];
	[coder encodeFloat:focalDistance forKey:@"RTfocalDistance"];
	[coder encodeInt:depthSamples forKey:@"RTdepthSamples"];
	
	[coder encodeObject:scene forKey:@"RTscene"];
	[coder encodeObject:lights forKey:@"RTlights"];

}

@end
