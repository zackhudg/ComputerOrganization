#include <stdio.h>

int main( int argc, char** argv ) {

	// ****************************
	// TODO: Code your solution
	// ***************************
	
	char word[101];
	int length = 1;
	char current;

	printf("Please enter a string (minimum 4 characters): ");
	scanf("%s", word);

	while(length < 5){
		current = word[0];
		while(current != '\0'){
			length++;
			current = word[length-1];
		}
		if(length < 5){
			printf("len(%s) < 4 characters, please retry: ", word);
			scanf("%s", word);
			length = 1;
		} 
	} 

	char replace = 'y';
	printf("Replace a character in \"%s\" (y/n): ", word);
	scanf(" %c", &replace);

	if(replace == 'y'){
		printf("What character do you want to replace: ");
		scanf(" %c", &replace);

		char newchar;
		printf("What is the replacement character: ");
		scanf(" %c", &newchar);

		for(int i = 0; i<length; i++){
			if(word[i]==replace){
				word[i] = newchar;
			}
		}
	}

	int boolean = 0;
	for(int i = 0; i< length/2; i++){
		if(word[i] != word[length-2-i]){
			boolean = 1;
		}
	}

	if(boolean == 0){
		printf("\"%s\" is a palindrome\n", word);
	}else{
		printf("\"%s\" is not a palindrome\n", word);
	}
	

} // end main function