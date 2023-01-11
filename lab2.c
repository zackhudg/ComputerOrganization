#include <stdio.h>

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

	int arrayLength = 0;

	while(arrayLength < 2 || arrayLength > 10){
		printf("Please enter the array size (between 2 and 10): ");
		scanf("%d", &arrayLength);
	}

	int array[arrayLength];
	
	for(int i = 0; i<arrayLength; i++){
		printf("Please enter the value for array[%d]: ", i);
		scanf("%d", &array[i]);
	}

	int temp;
	for(int i = 0; i<arrayLength-1; i++){
		for(int j = 0; j<arrayLength-1-i; j++){
			if(array[j+1] < array[j]){
				temp = array[j];
				array[j] = array[j+1];
				array[j+1] = temp;
			}
		}
	}

	printf("The array values sorted in non-decreasing order are: ");
	for(int i = 0; i < arrayLength-1; i++){
		printf("%d, ", array[i]);
	}
	printf("%d\n", array[arrayLength-1]);

}