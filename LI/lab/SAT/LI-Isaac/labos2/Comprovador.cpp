#include <iostream>
#include <vector>
#include <string>
#include <math.h>
#define N 9
using namespace std;

vector<vector<int> > m(N,vector<int>(N));
vector<bool> vert(N,false);
vector<bool> hori(N,false);

void llegir() {
	char c;
	int i = 0;
	int j = 0;

	while (cin >> c) {
		if (c >= '1' and c <= 'N') {
			m[i][j] = c - '0';
			++j;
			if (j == N) {
				j = 0;
				++i;
			}
		}
	}
}

bool comprovaRectes() {
	for (int i = 0; i < N; ++i) {
		for (int j = 0; j < N; ++j) {
			if (vert[m[i][j]-1]) return false;
			vert[m[i][j]-1] = true;
			if (hori[m[i][j]-1]) return false;
			hori[m[i][j]-1] = true;
		}
		vert = vector<bool>(N,false);
		hori = vector<bool>(N,false);
	}
	return true;
}

bool comprovaQuadres() {
	int n = sqrt(N);
	for (int i = 0; i < n; ++i) {
		for (int j = 0; j < n; ++j) {
			for (int k = i*n; k < i*n+n; ++k) {
				for (int f = j*n; f < j*n+n; ++f) {
					if (vert[m[k][f]-1]) return false;
					vert[m[k][f]-1] = true;
				}
			}
			vert = vector<bool>(N,false);
		}
	}
	return true;
}

int main() {
	llegir();
	
	bool b = comprovaRectes();
	if (b) b = comprovaQuadres();
	if (b) cout << "Sudoku correcte" << endl;
	else cout << "Sudoku incorrecte" << endl;
}