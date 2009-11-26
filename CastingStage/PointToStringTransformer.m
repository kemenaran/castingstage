//
//  PointToStringTransformer.m
//  RayTracer
//
//  Created by Kemenaran on 9/15/09.
//  Copyright 2009 Isep. All rights reserved.
//

#import "PointToStringTransformer.h"
#import "vector3.h"

@implementation PointToStringTransformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
	vector3 point;
	[value getValue:&point];
	
	return [NSString stringWithFormat:@"{%.0f,%.0f,%.0f}", point.x, point.y, point.z];
}

- (id)reverseTransformedValue:(id)value
{
	vector3 point;
	sscanf([value cString], "{%lf,%lf,%lf}", &(point.x), &(point.y), &(point.z));
	
	return [NSValue value:&point withObjCType:@encode(vector3)];
}

@end
