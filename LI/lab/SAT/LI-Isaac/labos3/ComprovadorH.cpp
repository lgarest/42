#include <iostream>
#include <vector>
#include <string>
#define DIES 5
#define HORES_DIA 12
using namespace std;

struct app {
	int assig, prof, aul;
};

vector<vector<int> > hora;
vector<int> nHores;
vector<int> profe;
vector<int> aula;
vector<vector<int> > curs;
vector<vector<app> > vec;
vector<vector<int> > prohib;
int num_cursos;

void read() {
    int num_assigs, num_profes;
    cin >> num_assigs >> num_cursos >> num_profes;

    hora = vector<vector<int> >(DIES*HORES_DIA,vector<int>(1,-1));	//hora -> assig
    profe = vector<int>(num_assigs,-1);		//assig -> profe
    aula = vector<int>(num_assigs,-1);		//assig -> aula
    vec = vector<vector<app> >(DIES*HORES_DIA,vector<app>(1));	//a cada hora quines assignatures (amb profe i aula)
    curs = vector<vector<int> >(DIES*HORES_DIA,vector<int>(1,-1));	//curs que té classe cada hora
    prohib = vector<vector<int> >(num_profes,vector<int>(1,-1));	//hores prohibides per cada profe
    nHores = vector<int>(num_assigs,0);	//nombre d'hores de cada assignatura

    string s;
    int as;
    int val;
    while (cin >> s) {
		if (s == "Assig") {
		    cin >> as;
		    --as;
		    cin >> s >> val;
		    if (s == "Hora") {
				if (hora[val-1][0] == -1) hora[val-1][0] = as;
				else hora[val-1].push_back(as);
		    }
		    else if (s == "Profe")
				profe[as] = val;
		    else if (s == "Aula")
				aula[as] = val;
		}		
		else if (s == "Curs") {
			int c, h;
			cin >> c >> s >> h;
			if (curs[h-1][0] == -1) curs[h-1][0] = c;
			else curs[h-1].push_back(c);
		}
		else if (s == "Profe") {
			int p, n;
		    cin >> p >> s >> n;
		    prohib[p-1][0] = n;
		    while (cin >> n and n != -1) {
		    	prohib[p-1].push_back(n);
		    }
		}
		else if (s == "Assig-Hores") {
			cin >> as >> val;
			--as;
			nHores[as] = val;
		}
    }
}

void write_hores(int h) {
    if (h < 10) cout << h << ":00  |";
    else cout << h << ":00 |";
}

void write_dies() {
    cout << "          ";
    cout << "Dilluns      ";
    cout << "Dimarts     ";
    cout << "Dimecres      ";
    cout << "Dijous      ";
    cout << "Divendres" << endl;
}

int digits(int a) {
    int d = 0;
    while(a > 0) {
	++d;
	a /= 10;
    }
    return d;
}

void write() {
    write_dies();
    
    for (int i=0; i<HORES_DIA; ++i) {
		cout << "-------";
		for (int m=0; m<DIES; ++m) cout << "-------------";
		cout << endl;
		
		if (i == HORES_DIA-1) write_hores(19);
		else write_hores(((i+1)%HORES_DIA)+7);
		
		for (int j=0; j<DIES; ++j) {
		    cout << " ";
		    int k = j*HORES_DIA + i;
		    int lletres = 0;
		    if (hora[k][0] != -1) {
			cout << hora[k][0]+1;
			lletres += digits(hora[k][0]+1);
			for (int r=1; r<hora[k].size(); ++r) {
			    cout << "," << hora[k][r]+1;
			    lletres += digits(hora[k][r]+1)+1;
			}
			for (int l=0; l<(11-lletres); ++l) cout << " ";
			cout << "|";
		    }
		    else cout << "           |";
		}
		cout << endl;
    }
    
    cout << endl << "===================================";
    cout << "=====================================" << endl;
    cout << endl << "Assignatura --> Profe, Aula" << endl;
    for (int i=0; i<profe.size(); ++i) {
		cout << i+1 << " --> " << profe[i] << ", " << aula[i] << endl;
    }
}

// cada assignatura té les hores que toquen per setmana
bool total_hores() {
	for (int i=0; i<nHores.size(); ++i) {
		int total = nHores[i];
		for (int j=0; j<HORES_DIA*DIES; ++j) {
			for (int k=0; k<hora[j].size(); ++k) {
				if (i == hora[j][k]) --total;
			}
		}
		if (total > 0) {
			cout << "L'assignatura " << i+1 << " fa menys hores de les que hauria de fer" << endl;
			return false;
		}
		if (total < 0) {
			cout << "L'assignatura " << i+1 << " fa mes hores de les que hauria de fer" << endl;
			return false;
		}
	}
	return true;
}

// restriccions sobre cursos
bool cursos() {
	bool ret = true;
	for (int i=0; i<5; ++i) {
		vector<bool> te_curs(num_cursos,false);
		vector<int>  hores_dia(num_cursos,0);
		for (int j=i*HORES_DIA; j<((i+1)*HORES_DIA); ++j) {
			if (curs[j][0] != -1) {
				for (int k=0; k<curs[j].size(); ++k) {
					int c = curs[j][k]-1;
					++hores_dia[c];
					// no té més de 6 hores al dia per curs
					if (hores_dia[c] == 7) {
						cout << "El curs " << c+1 << " te mes de 6 hores el dia " << i+1 << endl;
						ret = false;
					}

					// no té hores separades per curs
					if (not te_curs[c]) te_curs[c] = true;
					else if (curs[j-1][k] == -1) {
						cout << "El curs " << c+1 << " te hores lliures el dia " << i+1 << endl;
						ret = false;
					}
				}
			}
		}
	}
	return ret;
}

// hores prohibides dels professors es compleixen
bool hores_prohibides() {
	bool ret = true;
	for (int i=0; i<prohib.size(); ++i) {
		if (prohib[i][0] != -1) {
			for (int j=0; j<prohib[i].size(); ++j) {
				int h = prohib[i][j];
				for (int k=0; k<vec[h-1].size(); ++k) {
					if (i+1 == vec[h-1][k].prof) {
						cout << "El professor " << i+1;
						cout << " esta fent classe a l'hora prohibida " << h << endl;
						ret = false;
					}
				}
			}
		}
	}
	return ret;
}

// Una assignatura pot tenir com a màxim una hora els dies que té classe
bool una_hora_dia() {
	bool ret = true;
	for (int i=0; i<5; ++i) {
		for (int j=0; j<vec[i].size(); ++j) {
			for (int k=i*HORES_DIA; k<((i+1)*HORES_DIA); ++k) {
				if (vec[k][0].assig != -1) {
					for (int r=k+1; r<=((i+1)*12)-1; ++r) {
						if (vec[k][j].assig == vec[r][j].assig) {
							cout << "L'assignatura " << vec[k][j].assig+1;
							cout << " te mes d'una hora al dia " << i+1 << endl;
							ret = false;
						}
					}
				}
			}
		}
	}
	return ret;
}

// una aula no està ocupada més d'una vegada a la mateixa hora
// i un profe no pot fer més d'una classe al mateix temps
bool aules_i_profes() {
	bool ret = true;
	for (int i=0; i<vec.size(); ++i) {
		// assignatures que es fan a l'hora 'i'
		if (vec[i][0].assig != -1) {
			for (int j=0; j<vec[i].size(); ++j) {
				for (int k=j+1; k<vec[i].size(); ++k) {
					// un profe té classe al mateix temps
					if (vec[i][j].prof == vec[i][k].prof) {
						cout << "El profe " << vec[i][j].prof << " te dues classes a les " << i+1 << endl;
						ret = false;
					}
					// una mateixa aula està ocuapda per dues
					// assignatures al mateix temps
					if (vec[i][j].aul == vec[i][k].aul) {
						cout << "L'aula " << vec[i][j].aul << " te dues classes a les " << i+1 << endl;
						ret = false;
					}
				}
			}
		}
	}
	return ret;
}


void init_vec() {
	for (int i=0; i<hora.size(); ++i) {
		// assignatures que es fan a l'hora i
		for (int j=0; j<hora[i].size(); ++j) {
			app a;
			a.assig = hora[i][j];
			if (a.assig != -1) {
				a.prof = profe[a.assig];
				a.aul = aula[a.assig];
			}
			else {
				a.prof = a.aul = -1;
			}
			if (j == 0) vec[i][0] = a;
			else vec[i].push_back(a);
		}
	}
}


int main() {
    read();
    init_vec();
    bool a = aules_i_profes();
    bool b = una_hora_dia();
    bool c = cursos();
    bool d = hores_prohibides();
    bool e = total_hores();
    if (a and b and c and d and e) 
    	cout << "HORARI CORRECTE!" << endl << endl;
    else 
    	cout << "HORARI INCORRECTE!" << endl << endl;
    write();
}