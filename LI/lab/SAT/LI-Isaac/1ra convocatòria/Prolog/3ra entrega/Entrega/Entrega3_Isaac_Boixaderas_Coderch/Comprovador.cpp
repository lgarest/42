#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <vector>
#define EQUIPS 10
#define FILE "partits.txt"
#define RESTRIC "excepcions.pl"
using namespace std;


vector<vector<int> > v((EQUIPS-1)*2); // vector de la mida del total de jornades
vector<vector<int> > rest(5); // vector de restriccions


/* Llegeix el fitxer on s'especifica com juguen els equips (la sortida del picosat) */
void llegir_entrada();

/* Llegeix el fitxer on s'especifica les restriccions (obligatori casa, etc.) */
void llegir_restriccions();

/* En una mateixa jornada un equip no pot jugar més d'una vegada  */
bool noRepeatJornada();

/* Un equip només pot jugar dues vegades contra un altre equip (una a casa i l'altra a fora) 
	També comprova que per a cada partit hi hagi una tornada */
bool noRepeatPartit();

/* Retorna true si l'equip eq juga a casa la jornada jor, false altrament */
bool casa(int eq, int jor);

/* Cap equip pot jugar 3 vegades seguides a fora o a casa */
bool noTripiticions();

/* Comprova si es compleixen les restriccions de nocasa especificades al fitxer */
bool noCasa();

/* Comprova si es compleixen les restriccions de nofuera especificades al fitxer */
bool noFora();

/* Comprova si es compleixen les restriccions de norepes especificades al fitxer */
bool noRepes();

/* Comprova si es compleixen les restriccions de nopartido especificades al fitxer */
bool noPartit();

/* Comprova si es compleixen les restriccions de sipartido especificades al fitxer */
bool siPartit();


int main() {
	llegir_entrada();
	llegir_restriccions();
	if (noRepeatJornada()) cout << "Correcte noRepeatJornada" << endl;
	if (noRepeatPartit()) cout << "Correcte noRepeatPartit" << endl;
	if (noTripiticions()) cout << "Correcte noTripiticions" << endl;
	if (noCasa()) cout << "Correcte noCasa" << endl;
	if (noFora()) cout << "Correcte noFora" << endl;
	if (noRepes()) cout << "Correcte noRepes" << endl;
	if (noPartit()) cout << "Correcte noPartit" << endl;
	if (siPartit()) cout << "Correcte siPartit" << endl;
	return 0;
}


bool noRepeatJornada() {
	for (int i = 0; i < v.size(); ++i) {
		for (int j = 0; j < v[i].size(); ++j) {
			for (int k = j+1; k < v[i].size(); ++k) {
				if (v[i][j] == v[i][k]) {
					cout << "Problema noRepeatJornada equip "
					     << j+1 << " jornada " << i+1 << endl;
					return false;
				}
			}
		}
	}
	return true;
}


bool noRepeatPartit() {
	int count;
	for (int i = 0; i < v.size(); ++i) {
		for (int j = 0; j < v[i].size()-1; j = j+2) {
			pair<int,int> p1 = make_pair(v[i][j], v[i][j+1]);
			pair<int,int> p2 = make_pair(v[i][j+1], v[i][j]);

			int first = j+2;
			count = 0;
			int tri1 = 0, tri2 = 0;
			for (int i2 = i; i2 < v.size(); ++i2) {
				for (int k = first; k < v[i2].size()-1; k = k+2) {
					// Repeticions equip1 vs equip2 i viceversa
					pair<int,int> p3 = make_pair(v[i2][k], v[i2][k+1]);
					if (p3 == p1) {
						cout << "Problema noRepeatPartit equips " << p1.first
							 << " i " << p1.second << " jornada " << i2+1 << endl;
						return false;
					}
					if (p3 == p2) ++count;
					if (count == 2) {
						cout << "Problema noRepeatPartit, no tornada equips "
							 << p3.first << " i " << p3.second << " jornada "
							 << i2+1 << endl;
						return false;
					}
				}
				first = 0;
			}
		}
		if (count == 0 and i < v.size()/2) return false;
	}
	return true;
}


bool noTripiticions() {
	int count1 = 0, count2 = 0;
	for (int eq = 1; eq <= EQUIPS; ++eq) {
		for (int i = 1; i < v.size()-1; ++i) {
			if (casa(eq,i) and casa(eq,i+1)) {
				count2 = 0;
				++count1;
			}
			else if (!casa(eq,i) and !casa(eq,i+1)) {
				count1 = 0;
				++count2;
			}
			else count1 = count2 = 0;
			if (count1 == 2 or count2 == 2) {
				cout << "Problema noTripiticions"
					 << " equips " << eq << " i " << i
					 << " jornada " << i+1 << endl;
				return false;
			}
		}
	}
	return true;
}


bool casa(int eq, int jor) {
	for (int j = 0; j < v[0].size()-1; j = j+2) {
		if (v[jor-1][j] == eq) return true;
	}
	return false;
}


bool noCasa() {
	for (int i = 0; i < rest[0].size(); i = i+2) {
		if (casa(rest[0][i],rest[0][i+1])) {
			cout << "Problema noCasa equip " << rest[0][i] << " jornada "
				 << rest[0][i+1] << endl;
			return false;
		}
	}
	return true;
}


bool noFora() {
	for (int i = 0; i < rest[1].size(); i = i+2) {
		if (!casa(rest[1][i],rest[1][i+1])) {
			cout << "Problema noFora equip " << rest[1][i] << " jornada "
				 << rest[1][i+1] << endl;
			return false;
		}
	}
	return true;
}


bool noRepes() {
	for (int i = 0; i < rest[2].size(); i = i+2) {
		for (int j = 1; j <= EQUIPS; ++j) {
			if (!casa(j,rest[2][i]) and !casa(j,rest[2][i+1])) {
				cout << "Problema noRepes equip " << j << " jornades "
					 << rest[2][i] << " i " << rest[2][i+1] << endl;
				return false;
			}
			if (casa(j,rest[2][i]) and casa(j,rest[2][i+1])) {
				cout << "Problema noRepes equip " << j << " jornades "
				 << rest[2][i] << " i " << rest[2][i+1] << endl;
				return false;
			}
		}
	}
	return true;
}


bool noPartit() {
	for (int i = 0; i < rest[3].size(); i = i+3) {
		for (int j = 0; j < v[0].size(); j = j+2) {
			int a = rest[3][i+2];
			if (v[a-1][j] == rest[3][i] and 
				v[a-1][j+1] == rest[3][i+1]) {
				cout << "Problema noPartit entre equips "
					 << rest[3][i] << " i " << rest[3][i+1] << endl;
				return false;
			}
			if (v[a-1][j+1] == rest[3][i] and 
				v[a-1][j] == rest[3][i+1]) {
				cout << "Problema noPartit entre equips "
					 << rest[3][i] << " i " << rest[3][i+1] << endl;
				return false;
			}
		}
	}
	return true;
}


bool siPartit() {
	bool correcte = false;
	for (int i = 0; i < rest[4].size(); i = i+3) {
		int a = rest[4][i+2];
		for (int j = 0; j < v[0].size(); j = j+2) {
			if (v[a-1][j] == rest[4][i] and 
				v[a-1][j+1] == rest[4][i+1]) {
				correcte = true;
			}
			if (v[a-1][j+1] == rest[4][i] and 
				v[a-1][j] == rest[4][i+1]) {
				correcte = true;
			}
		}
		if (!correcte) {
			cout << "Problema siPartit entre equips "
				 << rest[4][i] << " i " << rest[4][i+1]
				 << " jornada " << a << endl;
			return false;
		}
		else correcte = false;
	}
	return true;
}


void llegir_entrada() {
	ifstream file;
	string line;
	file.open (FILE, ifstream::in);
    while(getline(file,line)) {
	    stringstream line2(line);
	    string value;

	    int i = 0;
		int  val;

	    while(getline(line2,value,',')) {
			istringstream ss(value);
			ss >> val;
	        if (i == 0) i = val;
	        else {
		    	v[i-1].push_back(val);
	        }
	    }
	}
}


void llegir_restriccions() {
	ifstream file;
	string line;
	file.open (RESTRIC, ifstream::in);
    while(getline(file,line)) {
	    stringstream line2(line);
	    string value;

	    int i;
	    int  val;
	    bool primer = true;

	    while(getline(line2,value,',')) {
			istringstream ss(value);
			ss >> val;
	        if (primer) {
	        	i = val;
	        	primer = false;
	        }
	        else {
		    	rest[i].push_back(val);
	        }
	    }
	}
}


void escriu(vector<vector<int> > a) {
	for (int i = 0; i < a.size(); ++i) {
		for (int j = 0; j < a[i].size(); ++j) {
			cout << a[i][j] << " ";
		}
		cout << endl;
	}
}