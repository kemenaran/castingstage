//
//  WindowController.h
//  RayTracer
//
//  Created by Kemenaran on 9/17/09.
//  Copyright 2009 Isep. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RayTracer;

@interface CSWindowController : NSWindowController {
	IBOutlet RayTracer* rayTracer;
	IBOutlet NSImageView* imageView;
	IBOutlet NSComboBox*  sceneItemType;
	IBOutlet NSArrayController* sceneController;
	IBOutlet NSComboBox* lightItemType;
	IBOutlet NSArrayController* lightsController;
	IBOutlet NSDrawer* sceneDrawer;
	IBOutlet NSDrawer* settingsDrawer;
	IBOutlet bool isComputing;
	IBOutlet NSButton* previewButton;
}
@property(readonly) RayTracer* rayTracer;
@property bool isComputing;

- (void) windowDidLoad;
- (IBAction)toggleSettingsDrawer:(id)sender;
- (IBAction)toggleSceneDrawer:(id)sender;
- (IBAction)changeSceneItemType:(id)sender;
- (IBAction)changeLightItemType:(id)sender;
- (IBAction) renderPicture:(id)sender;
- (IBAction) renderPreview:(id)sender;

- (void)runRendering:(bool)isPreview;

@end
