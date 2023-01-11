#include <stdio.h>
#include <math.h>

int main( int argc, char** argv ) {

	// -------------------------------------
	// TODO: Put your solution here
	//
	// See assignment for instructions and 
	// input/output formatting.
	//
	// Please remember help is available 
	// (TA, LAs, or instructor)
	// -------------------------------------
	int shape;
	
	printf("Please select a 2D shape(1 = circle, 2 = rectangle, 3 = triangle): ");
	scanf("%d", &shape);
	
	float area;

	if(shape == 1){
		float radius;
		printf("You selected a circle, please enter the radius: ");
		scanf("%f", &radius);
		area = M_PI * radius * radius;
		printf("The area of your circle is: %.1f\n", area);
	}else if(shape == 2){
		float length;
		float width;
		printf("You selected a rectangle, please enter the length: ");
		scanf("%f", &length);
		printf("You selected a rectangle, please enter the width: ");
		scanf("%f", &width);
		area = length * width;
		printf("The area of your rectangle is: %.1f\n", area);
	}else if(shape == 3){
		float base;
		float height;
		printf("You selected a triangle, please enter the base: ");
		scanf("%f", &base);
		printf("You selected a triangle, please enter the height: ");
		scanf("%f", &height);
		area = .5 * base * height;
		printf("The area of your triangle is: %.1f\n", area);
	}

}