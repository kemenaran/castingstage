//
//  Ray.h
//  Untitled
//
//  Created by Kemenaran on 8/26/09.
//  Copyright 2009 Isep. All rights reserved.
//
#include "vector3.h"

typedef struct _Ray {
	vector3 origin;
	vector3 direction;
	float refractionIndice;
} Ray;

vector3 PointFromDistance(Ray ray, double t);