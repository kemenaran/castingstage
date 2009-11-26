/*
 *  vector3.c
 *  RayTracer
 *
 *  Created by Kemenaran on 9/11/09.
 *  Copyright 2009 Isep. All rights reserved.
 *
 */
#include "vector3.h"
#include <math.h>

vector3 MakeVector(double x, double y, double z)
{
	vector3 result;
	result.x = x;
	result.y = y;
	result.z = z;
	return result;
}

double Distance(vector3 u, vector3 v)
{
	return sqrt((v.x - u.x)*(v.x - u.x) + (v.y - u.y)*(v.y - u.y) + (v.z - u.z)*(v.z - u.z));
}

double DotProduct(vector3 u, vector3 v)
{
	return u.x*v.x + u.y*v.y + u.z*v.z;
}

vector3 AddVector(vector3 u, vector3 v)
{
	u.x += v.x;
	u.y += v.y;
	u.z += v.z;
	return u;
}

vector3 SubstractVector(vector3 u, vector3 v)
{
	u.x -= v.x;
	u.y -= v.y;
	u.z -= v.z;
	return u;
}

bool VectorEquals(vector3 u, vector3 v)
{
	return u.x == v.x && u.y == v.y && u.z == v.z;
}

vector3 MultiplyByScalar(vector3 u, double n)
{
	u.x *= n;
	u.y *= n;
	u.z *= n;
	
	return u;
}

vector3 NormalizeVector(vector3 v)
{
	// Multipliying is faster than dividing - so we compute the inverse directly
	double normCoef = 1/sqrt((v.x * v.x) + (v.y * v.y) + (v.z * v.z));
	
	v = MultiplyByScalar(v, normCoef);
	
	return v;
}
