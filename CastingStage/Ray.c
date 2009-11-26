/*
 *  Ray.c
 *  RayTracer
 *
 *  Created by Kemenaran on 9/27/09.
 *  Copyright 2009 Isep. All rights reserved.
 *
 */

#include "Ray.h"

vector3 PointFromDistance(Ray ray, double t)
{
	vector3 point;
	
	point.x = ray.origin.x + ray.direction.x * t;
	point.y = ray.origin.y + ray.direction.y * t;
	point.z = ray.origin.z + ray.direction.z * t;
	
	return point;
}