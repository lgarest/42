#include <iostream>
using namespace std;

void print_totes() {
	cout << "[";
	for (int i = 0; i < 9; ++i) {
		cout << endl;
		cout << "[";
		for (int j = 1; j <= 9; ++j) {
			char c = 65+i;
			if (j == 9) cout << c << j;
			else cout << c << j << ",";
		}
		if (i == 8) cout << "]";
		else cout << "],";
	}
	cout << "].";
}

void print_fils() {
	cout << endl << "% Files" << endl;
	for (int i = 0; i < 9; ++i) {
		cout << "all_different([";
		for (int j = 1; j <= 9; ++j) {
			if (j == 9) cout << (char)(i+65) << j;
			else cout << (char)(i+65) << j << ",";
		}
		cout << "])," << endl;
	}
}

void print_cols() {
	cout << endl << "% Columnes" << endl;
	for (int i = 1; i <= 9; ++i) {
		cout << "all_different([";
		for (int j = 0; j < 9; ++j) {
			if (j == 8) cout << (char)(j+65) << i;
			else cout << (char)(j+65) << i << ",";
		}
		cout << "])," << endl;
	}
}

/*void print_quads() {
	cout << endl << "% quadrats" << endl;
	for (int i = 0; i < 9; ++i) {
		cout << "all_different([";
		for (int j = 0; j < 9; ++j) {
			for (int ii = )


		}
		cout << "])," << endl;
	}
}*/

void num2var() {
	cout << endl << endl;
	for (int i = 1; i <= 9; ++i) {
		for (int j = 1; j <= 9; ++j) {
			cout << "eqVar(" << i << "," << j << ",K):- "
				 << (char)(64+i) << j << " = K." << endl;
		}
	}
}

int main() {
	print_totes();
	cout << endl;
	print_fils();
	cout << endl;
	print_cols();
	cout << endl;
	num2var();
}