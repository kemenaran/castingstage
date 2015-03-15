## Description

CastingStage is a simple raytracing engine made using Cocoa.
It intends to be lean and mean, easy to use, and to showcase
several Mac OS X technologies, such as bindings, CoreData,
Grand Central Dispatch, and so on.

You can view some Screenshots or download the application
(requires Mac OS 10.6 for now, Leopard support coming soon).

![screenshot](https://cloud.githubusercontent.com/assets/179923/6655566/0b1e4d98-cb03-11e4-869e-fc5f6237fbb8.png)

## Current features

* Basic primitives handling (spheres and planes)
* Reflection and refraction
* Point and area lights
* Depth-of-field effect
* Quick preview of scenes
* Anti-aliasing
* Document-based application: save and open scenes
* Export rendering in various formats
* Demonstration scenes included 

## Future features

* Use of CoreData with Undo support
* Multi-threading that doesn't leak memory
* Image resizing 

## Why 10.6 only ?

Because this project began as a way to experiment new Snow Leopard technologies,
like Grand Central Dispatch and C-blocks for the multi-threading.

I could backport the GCD code, using NSOperation rather that C-blocks, which
would make it work under Mac OS 10.5, and still retains the benefits of GCD
under 10.6 ; this is probably what will happen as soon as I'll find the time to do it. 
