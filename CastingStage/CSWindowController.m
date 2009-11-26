//
//  WindowController.m
//  RayTracer
//
//  Created by Kemenaran on 9/17/09.
//  Copyright 2009 Isep. All rights reserved.
//

#import "CSWindowController.h"
#import "RayTracer.h"
#import "ScenePrimitives.h"
#import "GrandCentral.h"

@implementation CSWindowController

@synthesize rayTracer, isComputing;

- (void) windowDidLoad
{
	// Ensure that the Scene Controller has the proper Object Class
	[sceneItemType selectItemAtIndex:0];
	[self changeSceneItemType:self];
	
	// Open the drawer
	//[self toggleSceneDrawer:self];
}

- (IBAction)toggleSettingsDrawer:(id)sender
{
	[sceneDrawer close:self];
	[settingsDrawer toggle:self];
}

- (IBAction)toggleSceneDrawer:(id)sender
{
	[settingsDrawer close:self];
	[sceneDrawer toggle:self];
}

- (IBAction) renderPicture:(id)sender
{
	[self runRendering:NO];
}

- (IBAction) renderPreview:(id)sender
{
	[self runRendering:YES];
}

- (void)runRendering:(bool)isPreview
{
	float oldres;
	RayTracer* rt = [[self document] rayTracer];
	[self setIsComputing:true];
	
	if (isPreview) {
		oldres = [rt resolutionFactor];
		[rt setResolutionFactor:0.5];
	}
	
#ifdef GRAND_CENTRAL
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
#endif
		[rt compute];
#ifdef GRAND_CENTRAL
		dispatch_async(dispatch_get_main_queue(), ^{
#endif
			[imageView setImage:[rt image]];
			
			if (isPreview)
				[rt setResolutionFactor:oldres];
			[self setIsComputing:false];
			
#ifdef GRAND_CENTRAL
		});
	});
#endif
}

- (void)changeSceneItemType:(id)sender
{
	NSString* objectType = [sceneItemType objectValueOfSelectedItem];
	[sceneController setObjectClass:NSClassFromString(objectType)];
}

- (void)changeLightItemType:(id)sender
{
	NSString* objectType = [lightItemType objectValueOfSelectedItem];
	[lightsController setObjectClass:NSClassFromString(objectType)];
}


@end
