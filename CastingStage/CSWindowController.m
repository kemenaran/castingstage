//
//  WindowController.m
//  RayTracer
//
//  Created by Kemenaran on 9/17/09.
//  Copyright 2009 Isep. All rights reserved.
//

#import "CSWindowController.h"
#import "CSDocument.h"
#import "RayTracer.h"
#import "ScenePrimitives.h"
#import "GrandCentral.h"

@implementation CSWindowController

@synthesize isComputing;


#pragma mark Initialisation

- (void) windowDidLoad
{
	// Ensure that the Scene Controller has the proper Object Class
	[sceneItemType selectItemAtIndex:0];
	[self changeSceneItemType:self];
	
	// We want to be notified when the rendering imageview is resized
	/*[imageView setPostsFrameChangedNotifications:YES];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(imageViewResized:)
												 name:NSViewBoundsDidChangeNotification
											   object:imageView];*/
	
	// Open the drawer
	//[self toggleSceneDrawer:self];
}

- (RayTracer*) rayTracer
{
	// Retrieve the raytracer instance of the associated document
	return [(CSDocument*)[self document] rayTracer];
}


#pragma mark UI control

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

- (IBAction)toggleInspector:(id)sender
{
	if ([inspector isVisible])
		[inspector orderOut:self];
	else
		[inspector orderFront:self];
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


#pragma mark Rendering

- (IBAction) renderPicture:(id)sender
{
	[self startRendering:NO];
}

- (IBAction) renderPreview:(id)sender
{
	[self startRendering:YES];
}

- (void)startRendering:(bool)isPreview
{
	// The UI should not allow to start a rendering when another one is running.
	// In case it does, ignore the action.
	if (isComputing) {
		NSLog(@"Warning: Cannot start a rendering while another is currently running.");
		return;
	} else {
		[self setIsComputing:true];
	}
	
	float oldres;
	RayTracer* rt = [self rayTracer];
	
	// Set RayTracer size
	CGFloat dimension = MIN([imageView bounds].size.width, [imageView bounds].size.height);
	[rt setSize:NSMakeSize(dimension, dimension)];
	
	// Set Raytracer settings
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



@end
