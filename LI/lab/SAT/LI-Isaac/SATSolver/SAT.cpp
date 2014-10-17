#include <iostream>
#include <stdlib.h>
#include <algorithm>
#include <vector>
using namespace std;

#define UNDEF -1
#define TRUE 1
#define FALSE 0


struct clau {
	vector<int> pos;
	vector<int> neg;
};

uint numVars;
uint numClauses;
vector<vector<int> > clauses;
vector<int> model;
vector<int> modelStack;
uint indexOfNextLitToPropagate;
uint decisionLevel;

// Guarda, per cada literal, en quines clàusules apareix negat i en quines no
vector<clau> visit;

// Guarda, per cada literal, el nombre de clàusules on apareix i el seu valor [1..numVars]
vector<pair<int,int> > apareix;

// Guarda el punt a partir del qual haurem de prendre la següent decisió
uint iter;

void readClauses( ){
  // Skip comments
  char c = cin.get();
  while (c == 'c') {
    while (c != '\n') c = cin.get();
    c = cin.get();
  }
  // Read "cnf numVars numClauses"
  string aux;
  cin >> aux >> numVars >> numClauses;
  clauses.resize(numClauses);
  visit.resize(numVars+1);
  apareix.resize(numVars+1, pair<int,int>(0, 0));
  // Read clauses
  for (uint i = 0; i < numClauses; ++i) {
    int lit;
    while (cin >> lit and lit != 0) {
  		clauses[i].push_back(lit);
  		apareix[abs(lit)].second = abs(lit);

  		// Incrementem el nombre d'aparicions del literal
  		++apareix[abs(lit)].first;

  		// Mirem si el literal és positiu o negatiu a la clàusula
  		if (lit > 0) visit[lit].pos.push_back(i);
  		else visit[-lit].neg.push_back(i);
  	}
  }
}


int currentValueInModel(int lit){
  if (lit >= 0) return model[lit];
  else {
    if (model[-lit] == UNDEF) return UNDEF;
    else return 1 - model[-lit];
  }
}


void setLiteralToTrue(int lit){
  modelStack.push_back(lit);
  if (lit > 0) model[lit] = TRUE;
  else model[-lit] = FALSE;
}


bool propagateGivesConflict ( ) {
  int lastLitUndef;
  while ( indexOfNextLitToPropagate < modelStack.size() ) {

    ++indexOfNextLitToPropagate;
    int a = modelStack[indexOfNextLitToPropagate-1];	// a = última decisió
    int lim;

    cout << "\nmodelStack: ";
    for (int i = 0; i < modelStack.size(); ++i){
      cout << modelStack[i] << " ";
    }
    cout << endl << endl;
    cout << "____ultima decision: " <<  a << endl;

    if (a > 0) lim = visit[abs(a)].neg.size();	// Si és positiu només hem de mirar on apareix negatiu
    else lim = visit[abs(a)].pos.size();		// Viceversa

    // iteramos sobre el vector de clausulas según su signo y literal (dentro de visit)
    for (uint i = 0; i < lim; ++i) {
      bool someLitTrue = false;
      int numUndefs = 0;
      lastLitUndef = 0;
      // n == la clausula donde aparece dentro del vector de cláusulas positivas o negativas
      int n;
      if (a > 0) n = visit[abs(a)].neg[i];
      else n = visit[abs(a)].pos[i];

      // Per cada clàusula on el literal està negat, mirem el valor total de la clàusula
      // iteramos dentro de la clausula
      for (uint k = 0; not someLitTrue and k < clauses[n].size(); ++k) {
    		int val = currentValueInModel(clauses[n][k]);
    		if (val == TRUE) someLitTrue = true;
    		else if (val == UNDEF) {
    		  ++numUndefs;
    		  lastLitUndef = clauses[n][k];
    		}
    	}

      if (not someLitTrue and numUndefs == 0) return true; // conflict! all lits false
      else if (not someLitTrue and numUndefs == 1) setLiteralToTrue(lastLitUndef);
    }
  }
  return false;
}


void backtrack(){
  uint i = modelStack.size() -1;
  int lit = 0;
  while (modelStack[i] != 0){ // 0 is the DL mark
    lit = modelStack[i];
    model[abs(lit)] = UNDEF;
    modelStack.pop_back();
    --i;
  }
  // at this point, lit is the last decision
  modelStack.pop_back(); // remove the DL mark
  --decisionLevel;
  iter = numVars-decisionLevel;
  cout << "____BACKTRACK: iter is now: " <<  iter << endl;
  indexOfNextLitToPropagate = modelStack.size();
  setLiteralToTrue(-lit);  // reverse last decision
}


// Per prendre una decisió, donem preferència als literals que apareixen en més clàusules
int getNextDecisionLiteral() {
  for (int i = iter; i >= 1; --i) {
	  if (model[apareix[i].second] == UNDEF) {
		  iter = i-1;
      cout << "__NextDecisionLiteral:" << apareix[i].second << endl;
      cout << "____iter is now: " <<  iter << endl;
		  return apareix[i].second;
	  }
  }
  return 0;
}


void checkmodel(){
  for (int i = 0; i < numClauses; ++i){
    bool someTrue = false;
    for (int j = 0; not someTrue and j < clauses[i].size(); ++j) {
      someTrue = (currentValueInModel(clauses[i][j]) == TRUE);
    }
    if (not someTrue) {
      cout << "Error in model, clause is not satisfied:";
      for (int j = 0; j < clauses[i].size(); ++j) cout << clauses[i][j] << " ";
      cout << endl;
      exit(1);
    }
  }
}


int main(){
  readClauses(); // reads numVars, numClauses and clauses
  sort(apareix.begin(),apareix.end());
  cout << "\napareix: ";
  for (int i = 0; i < apareix.size(); ++i){
    cout << apareix[i].first << ":" << apareix[i].second << " ";
  }
  cout << endl << endl;
  model.resize(numVars+1,UNDEF);
  indexOfNextLitToPropagate = 0;
  decisionLevel = 0;
  iter = numVars;
  // Take care of initial unit clauses, if any
  for (uint i = 0; i < numClauses; ++i) {
    if (clauses[i].size() == 1) {
      int lit = clauses[i][0];
      int val = currentValueInModel(lit);
      if (val == FALSE) {cout << "UNSATISFIABLE" << endl; return 10;}
      else if (val == UNDEF) setLiteralToTrue(lit);
    }
  }

  // DPLL algorithm
  while (true) {
    while (propagateGivesConflict()) {
      if ( decisionLevel == 0) { cout << "UNSATISFIABLE" << endl; return 10; }
      backtrack();
    }
    int decisionLit = getNextDecisionLiteral();
    if (decisionLit == 0) { checkmodel(); cout << "SATISFIABLE" << endl; return 20; }
    // start new decision level:
    modelStack.push_back(0);  // push mark indicating new DL
    ++indexOfNextLitToPropagate;
    ++decisionLevel;
    setLiteralToTrue(decisionLit);    // now push decisionLit on top of the mark
  }
}
