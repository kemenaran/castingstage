//
//  SceneTest.m
//  RayTracer
//
//  Created by Kemenaran on 8/30/09.
//  Copyright 2009 Isep. All rights reserved.
//
#import <SenTestingKit/SenTestCase.h>

#import "SceneTest.h"
#import "Ray.h"
#import "Sphere.h"

@implementation SceneTest

- (void) setUp
{
	/*
	 STAssertNotNil(a1, description, ...)
	 STAssertTrue(expression, description, ...)
	 STAssertFalse(expression, description, ...)
	 STAssertEqualObjects(a1, a2, description, ...)
	 STAssertEquals(a1, a2, description, ...)
	 STAssertThrows(expression, description, ...)
	 STAssertNoThrow(expression, description, ...)
	 STFail(description, ...)
	 */
}

- (void) testSphere
{
	Sphere* s;
	vector3 origin = MakeVector(2, 2, 2);
	double radius = 1;
	
	// Test [Sphere initWithCenter: radius: color: albedo:
	s = [[Sphere alloc] initWithCenter:origin radius:radius color:[NSColor blueColor] albedo:0.9];
	STAssertNotNil(s, @"Cannot create the Sphere");
	STAssertEquals([s origin].x, origin.x, @"Sphere origin conservation");
	STAssertEquals([s origin].y, origin.y, @"Sphere origin conservation");
	STAssertEquals([s origin].z, origin.z, @"Sphere origin conservation");
	STAssertEquals([s radius], radius, @"Sphere radius conservation");
	
	// Test [Sphere normalAtPoint:]
	vector3 normalPoint = MakeVector(1, 1, 1);
	vector3 normalv = NormalizeVector(MakeVector(-1, -1, -1));
	STAssertTrue(VectorEquals([s normalAtPoint:normalPoint], normalv), @"[Sphere normalAtPoint:] failed.");
}

- (void) testSphereRay
{
	Sphere* s;
	Ray ray;
	vector3 origin = MakeVector(0, 2, 2);
	vector3 intersectionPoint;
	double radius = 1;
	
	s = [[Sphere alloc] initWithCenter:origin radius:radius color:[NSColor blueColor] albedo:0.9];
	
	// Test [Sphere intersects: atPoint:]
	ray.origin = MakeVector(0, 2, 0);
	ray.direction = NormalizeVector(MakeVector(0, 0, 1));
	STAssertTrue([s intersects:ray atPoint:&intersectionPoint], @"Intersection result test");
	STAssertTrue(VectorEquals(intersectionPoint, MakeVector(0, 2, 1)), @"Intersection point test");
	
	// Test again
	ray.origin = MakeVector(0, 0, 2);
	ray.direction = NormalizeVector(MakeVector(0, 1, 0));
	STAssertTrue([s intersects:ray atPoint:&intersectionPoint], @"Intersection result test");
	STAssertTrue(VectorEquals(intersectionPoint, MakeVector(0, 1, 2)), @"Intersection point test");
}

- (void) testReflection
{
	Sphere* s;
	Ray ray, reflection;
	vector3 origin = MakeVector(0, 2, 2);
	vector3 intersectionPoint;
	double radius = 1;
	
	s = [[Sphere alloc] initWithCenter:origin radius:radius color:[NSColor blueColor] albedo:0.9];
	
	// Test [Sphere intersects: atPoint:]
	ray.origin = MakeVector(0, 3, 0);
	ray.direction = MakeVector(0, 0, 1);
	STAssertTrue([s intersects:ray atPoint:&intersectionPoint], @"Intersection result test");
	//STAssertTrue(VectorEquals(intersectionPoint, MakeVector(0, 2, 1)), @"Intersection point test");
	
	// Test normal
	vector3 normalv = [s normalAtPoint:intersectionPoint];
	vector3 expectedNormal = NormalizeVector(MakeVector(0, 1, 0));
	STAssertTrue(VectorEquals(normalv, expectedNormal), @"dummy");
	
	// Test reflection
	reflection = [s reflectionFromRay:ray atPoint:intersectionPoint];
	STAssertTrue(VectorEquals(reflection.origin, intersectionPoint), @"dummy");
	STAssertTrue(VectorEquals(reflection.direction, MakeVector(0, 0, 1)), @"dummy");
}

- (void) testReflectionAgain
{
	Sphere* s;
	Ray ray, reflection;
	vector3 origin = MakeVector(0, 2, 2);
	vector3 intersectionPoint;
	double radius = 1;
	
	s = [[Sphere alloc] initWithCenter:origin radius:radius color:[NSColor blueColor] albedo:0.9];
	
	// Test [Sphere intersects: atPoint:]
	ray.origin = MakeVector(0, 2, 0);
	ray.direction = MakeVector(0, 0, 1);
	STAssertTrue([s intersects:ray atPoint:&intersectionPoint], @"Intersection result test");
	
	// Test normal
	vector3 normalv = [s normalAtPoint:intersectionPoint];
	vector3 expectedNormal = NormalizeVector(MakeVector(0, 0, -1));
	STAssertTrue(VectorEquals(normalv, expectedNormal), @"dummy");
	
	// Test reflection
	reflection = [s reflectionFromRay:ray atPoint:intersectionPoint];
	STAssertTrue(VectorEquals(reflection.origin, intersectionPoint), @"dummy");
	STAssertTrue(VectorEquals(reflection.direction, MakeVector(0, 0, -1)), @"dummy");
}

- (void) testReflection3
{
	Sphere* s;
	Ray ray, reflection;
	vector3 origin = MakeVector(0, 2, 2);
	vector3 intersectionPoint;
	double radius = 1;
	
	s = [[Sphere alloc] initWithCenter:origin radius:radius color:[NSColor blueColor] albedo:0.9];
	
	// Test [Sphere intersects: atPoint:]
	ray.origin = MakeVector(0, 2.6, 0);
	ray.direction = MakeVector(0, 0, 1);
	STAssertTrue([s intersects:ray atPoint:&intersectionPoint], @"Intersection result test");
	
	// Test normal
	vector3 normalv = [s normalAtPoint:intersectionPoint];
	vector3 expectedNormal = NormalizeVector(MakeVector(0, 0, -1));
	//STAssertTrue(VectorEquals(normalv, expectedNormal), @"dummy");
	
	// Test reflection
	reflection = [s reflectionFromRay:ray atPoint:intersectionPoint];
	//STAssertTrue(VectorEquals(reflection.origin, intersectionPoint), @"dummy");
	//STAssertTrue(VectorEquals(reflection.direction, MakeVector(0, 0, -1)), @"dummy");
	
	// Test reflected intersection
	STAssertFalse([s intersects:reflection atPoint:&intersectionPoint], @"dummy");
}



- (void) tearDown
{
}

@end
