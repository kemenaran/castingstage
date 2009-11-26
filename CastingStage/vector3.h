/*
 *  vector3.h
 *  RayTracer
 *
 *  Created by Kemenaran on 9/11/09.
 *  Copyright 2009 Isep. All rights reserved.
 *
 */
#include <stdbool.h>

typedef struct _vector {
	double x;
	double y;
	double z;
} vector3;

vector3 MakeVector(double x, double y, double z);
double Distance(vector3 u, vector3 v);
double DotProduct(vector3 u, vector3 v);
vector3 AddVector(vector3 u, vector3 v);
vector3 SubstractVector(vector3 u, vector3 v);
bool VectorEquals(vector3 u, vector3 v);
vector3 MultiplyByScalar(vector3 u, double n);
vector3 NormalizeVector(vector3 v);