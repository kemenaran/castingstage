//
//  PointToStringTransformer.h
//  RayTracer
//
//  Created by Kemenaran on 9/15/09.
//  Copyright 2009 Isep. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PointToStringTransformer : NSValueTransformer {

}

+ (Class)transformedValueClass;
+ (BOOL)allowsReverseTransformation;
- (id)transformedValue:(id)value;

@end
