#include <iostream>
#include <stdlib.h>
#include <stdio.h>
using namespace std;

int factorial(long double n, long double& result) {
	if (n != 1) {
		result *= n-1;
		factorial(n-1,result);
	}
}

int main(int argc, char* argv[]) {
	if (argc != 2) {
		cout << "Usage: ./f Number" << endl;
		exit(0);
	}
	long double n;
	/*for (int i = 1; i <= atoi(argv[1]); ++i) {
		n = i;
		factorial(n,n);
		cout << i << "! = " << n << endl;
	}*/
	n = atoi(argv[1]);
	factorial(n,n);
	cout << atoi(argv[1]) << "! = " << n << endl;
	return 0;
}
