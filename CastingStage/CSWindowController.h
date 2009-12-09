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
	IBOutlet NSImageView* imageView;
	IBOutlet NSComboBox*  sceneItemType;
	IBOutlet NSArrayController* sceneController;
	IBOutlet NSComboBox* lightItemType;
	IBOutlet NSArrayController* lightsController;
	IBOutlet NSDrawer* sceneDrawer;
	IBOutlet NSDrawer* settingsDrawer;
	IBOutlet bool isComputing;
	IBOutlet NSButton* previewButton;
	IBOutlet NSPanel* inspector;
}
@property bool isComputing;
@property(readonly) RayTracer* rayTracer;

- (IBAction)toggleInspector:(id)sender;
- (IBAction)toggleSettingsDrawer:(id)sender;
- (IBAction)toggleSceneDrawer:(id)sender;
- (IBAction)changeSceneItemType:(id)sender;
- (IBAction)changeLightItemType:(id)sender;
- (IBAction) renderPicture:(id)sender;
- (IBAction) renderPreview:(id)sender;

- (void)startRendering:(bool)isPreview;

@end
