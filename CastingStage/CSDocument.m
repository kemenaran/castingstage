//
//  CSDocument.m
//  RayTracer
//
//  Created by Kemenaran on 9/17/09.
//  Copyright 2009 Isep. All rights reserved.
//

#import "CSDocument.h"
#import "RayTracer.h"
#import "CSWindowController.h"

@implementation CSDocument

@synthesize rayTracer;


#pragma mark Init

- (id) init
{
	if (self = [super init]) {
		rayTracer = [[RayTracer alloc] init];
	}
	
	return self;
}

- (void)makeWindowControllers
{
	CSWindowController* windowController = [[CSWindowController alloc] initWithWindowNibName:@"RayTracer"];
	
	[self addWindowController:windowController];
}


#pragma mark Document reading and writing

/** Exclude native files from the Export dialog */
- (NSArray *)writableTypesForSaveOperation:(NSSaveOperationType)saveOperation
{
	NSArray* originalResults = [super writableTypesForSaveOperation:saveOperation];
	
	if (saveOperation == NSSaveToOperation) {
		NSPredicate* notNative = [NSPredicate predicateWithBlock:
								   ^(id evaluatedObject, NSDictionary *bindings) {
									   if ([CSDocument isNativeType:(NSString*) evaluatedObject] == YES)
										   return NO;
									   else
										   return YES;
								   }];
		return [originalResults filteredArrayUsingPredicate:notNative];
	} else
		return originalResults;
}

/* Save documents */
- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
	NSMutableData* data = nil;
	
	if ([typeName isEqualToString:@"CastingStage Document"]) {
		
		NSKeyedArchiver *archiver;
		
		// Prepare the archiver
		data = [NSMutableData data];
		archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
		[archiver setOutputFormat:NSPropertyListXMLFormat_v1_0];
		
		// Encode the object
		[archiver encodeObject:rayTracer forKey:@"CSrayTracer"];
		
		// Done - return the data
		[archiver finishEncoding];
    }
	
	// We have a picture type
	else {
		NSBitmapImageRep* img = [[[rayTracer image] representations] objectAtIndex: 0];
	
		// Save PNG picture
		if ([typeName isEqualToString:@"PNG"])
			data = (NSMutableData*) [img representationUsingType:NSPNGFileType properties:nil];
		
		// Save JPEG picture
		else if ([typeName isEqualToString:@"JPEG"])
			data = (NSMutableData*) [img representationUsingType:NSJPEGFileType properties:nil];
		
		else {
			// Error: no valid save type found
			if (outError)
				*outError = [[NSError alloc] initWithDomain:NSCocoaErrorDomain
													   code:NSFileWriteUnsupportedSchemeError
												   userInfo:nil];
		}
	}
		
		
	return data;
}

/* Read document */
- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
	NSKeyedUnarchiver *unarchiver;
	
	if ([typeName isEqualToString:@"CastingStage Document"]) {
		// Prepare the unarchiver
		unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		
		// Decode data
		rayTracer = [unarchiver decodeObjectForKey:@"CSrayTracer"];
		
		// Done
		[unarchiver finishDecoding];
	}
	
	else {
		// Error: no valid save type found
		if (outError)
			*outError = [[NSError alloc] initWithDomain:NSCocoaErrorDomain
												   code:NSFileReadUnsupportedSchemeError
											   userInfo:nil];
	}
	
    return YES;
}

@end
