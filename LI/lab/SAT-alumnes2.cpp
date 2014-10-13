#include <iostream>
#include <stdlib.h>
#include <algorithm>
#include <vector>
using namespace std;

#define UNDEF -1
#define TRUE 1
#define FALSE 0

uint numVars;
uint numClauses;
vector<vector<int> > clauses; // stores the clausules
vector<int> model; // stores the model found
vector<int> modelStack;
uint indexOfNextLitToPropagate;
uint decisionLevel;

struct key
	//Stores for a literal in which clauses appears with a positive value and in which with negative
{
	vector<int> p;
	vector<int> n;
};

// for each literal indicates in which clauses appears as positive and in which ones as negative
vector<key> appearsInClause;

// for each literal measures the # of apparitions and its value [1..numVars]
// [_[2:2] [5:2] [6:2] [1:1] [3:1] [4:1] [0:0]_]
vector<pair<int,int> > litCounter;
uint decisionPoint;

void printAppearsInClause(){
	for (int i = 0; i < appearsInClause.size(); ++i){
		cout << i << "*" << endl << "    +: ";
		for (int j = 0; j < appearsInClause[i].p.size(); ++j)
			cout << appearsInClause[i].p[j] << " ";
		cout << endl << "    -: ";
		for (int j = 0; j < appearsInClause[i].n.size(); ++j)
			cout << appearsInClause[i].n[j] << " ";
		cout << endl;
	}
}

void readClauses()
	// Reads the # variables, # of clausules and the clausules themselves
{
	// cout << "** readClauses" << endl;
	// Skip comments
	char c = cin.get();
	while (c == 'c') {while (c != '\n') c = cin.get(); c = cin.get();}
	// Read "cnf numVars numClauses"
	string aux;
	cin >> aux >> numVars >> numClauses;
	clauses.resize(numClauses);
	appearsInClause.resize(numVars + 1);
	litCounter.resize(numVars + 1, pair<int, int>(0, 0));
	// Read clauses
	for (uint i = 0; i < numClauses; ++i) {
		int lit;
		while (cin >> lit and lit != 0){
			clauses[i].push_back(lit);

			// we store the literal
			litCounter[abs(lit)].first = abs(lit);
			// increment # of apparitions of the literal
			litCounter[abs(lit)].second++;

			// store the apparition of the literal in the clausule in the visit vector
			if (lit > 0) appearsInClause[lit].p.push_back(i);
			else appearsInClause[-lit].n.push_back(i);
		}
	}
	// for (int i = 0; i < clauses.size(); ++i){
	//   for (int j = 0; j < clauses[i].size(); ++j)
	//     cout << clauses[i][j] << ' ';
	//   cout << endl;
	// }
	printAppearsInClause();
}




int currentValueInModel(int lit)
// SAME
// Returns the value of the literal inside the model
{
	if (lit >= 0) return model[lit];
	else {
		if (model[-lit] == UNDEF) return UNDEF;
		else return 1 - model[-lit];
	}
}


void setLiteralToTrue(int lit)
// SAME
{
	modelStack.push_back(lit);
	if (lit > 0) model[lit] = TRUE;
	else model[-lit] = FALSE;
	// cout << "modelStack:" << endl;
	// for (int i = 0; i < modelStack.size(); ++i) cout << modelStack[i] << endl;
	// cout << "model:" << endl;
	// for (int i = 0; i < model.size(); ++i) cout << model[i] << endl;
}


bool propagateGivesConflict()
	// Returns if the propagation gives conflict
{
	int lastUndefLit;
	while ( indexOfNextLitToPropagate < modelStack.size() ) {
		cout << "\nmodelStack: ";
		for (int i = 0; i < modelStack.size(); ++i) cout << modelStack[i] << " ";
		cout << endl;
		++indexOfNextLitToPropagate;
		// last decision taken
		int lastDecision = modelStack[indexOfNextLitToPropagate - 1];
		int n;

		// if the last decision is positive we only have to look where it appears as a negative value
		if (lastDecision > 0) n = appearsInClause[abs(lastDecision)].n.size();
		// if the last decision is negative we only have to look where it appears as a positive value
		else n = appearsInClause[abs(lastDecision)].p.size();
		cout << "____n: " <<  n << endl;

		// iterates over positive or negative clausules
		for (uint i = 0; i < n; ++i) {
			bool someLitTrue = false;
			int numUndefs = 0;
			int lastLitUndef = 0;

			int m;
	      	if (lastDecision > 0) m = appearsInClause[abs(lastDecision)].n[i];
	      	else m = appearsInClause[abs(lastDecision)].p[i];
	      	cout << "____m: " <<  m << endl;

	      	// For each clausule where the literal is negated, we look the value of the clausule
			for (uint k = 0; not someLitTrue and k < clauses[m].size(); ++k){
				int val = currentValueInModel(clauses[m][k]);
				if (val == TRUE) someLitTrue = true;
				else if (val == UNDEF){
				 	++numUndefs;
				 	lastLitUndef = clauses[m][k];
				}
			}

			if (not someLitTrue and numUndefs == 0)
				{return true; // conflict! all lits false
					cout << "Return TRUE" << endl;}
			else if (not someLitTrue and numUndefs == 1) setLiteralToTrue(lastLitUndef);
		}
	}
	cout << "Return FALSE" << endl;
	return false;
}


// backtrack func
void backtrack(){
	cout << "** backtrack" << endl;
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
	indexOfNextLitToPropagate = modelStack.size();
	setLiteralToTrue(-lit);  // reverse last decision
}


int getNextDecisionLiteral()
	// Heuristic for finding the next decision literal
	// Preference given to literals with more appearances
{
	for (uint i = 1; i <= numVars; ++i) // stupid heuristic:
		if (model[i] == UNDEF) return i;  // returns first UNDEF var, positively

	return 0; // reurns 0 when all literals are defined
}

void checkmodel()
// SAME
// checks if the model is correct
{
	for (int i = 0; i < numClauses; ++i){
		bool someTrue = false;
		for (int j = 0; not someTrue and j < clauses[i].size(); ++j)
			someTrue = (currentValueInModel(clauses[i][j]) == TRUE);
		if (not someTrue) {
			cout << "Error in model, clause is not satisfied:";
			for (int j = 0; j < clauses[i].size(); ++j) cout << clauses[i][j] << " ";
			cout << endl;
			exit(1);
		}
	}
}

bool cmp(pair<int, int> a, pair<int, int> b)
	// sorts by the second value of the pair
{
	if (a.second > b.second) return true;
	return false;
}

int main(){
	readClauses(); // reads numVars, numClauses and clauses
	// we sort the literals by its # of apparitions
	sort(litCounter.begin(), litCounter.end(), cmp);
	cout << "litCounter:" << endl;
	for (int i = 0; i < litCounter.size(); ++i) cout << litCounter[i].first << ":" << litCounter[i].second << "  ";
	cout << endl;
	model.resize(numVars+1,UNDEF);
	indexOfNextLitToPropagate = 0;
	decisionLevel = 0;
	decisionPoint = 0;

	// Take care of initial unit clauses, if any
	for (uint i = 0; i < numClauses; ++i)
		if (clauses[i].size() == 1) {
			int lit = clauses[i][0];
			int val = currentValueInModel(lit);
			if (val == FALSE) {cout << "UNSATISFIABLE" << endl; return 10;}
			else if (val == UNDEF) setLiteralToTrue(lit);
		}

	// DPLL algorithm
	// Davis-Putnam-Loveland-Logemann
	while (true) {
		while ( propagateGivesConflict() ) {
			cout << endl<<"__" << endl;
			// si hemos vuelto al principio
			if ( decisionLevel == 0) {cout << "UNSATISFIABLE" << endl; return 10; }
			backtrack(); // o backjump
		}

		int decisionLit = getNextDecisionLiteral();
		cout <<"____DECISIONLIT: " <<decisionLit << endl;
		if (decisionLit == 0) { checkmodel(); cout << "SATISFIABLE" << endl;
			// for (int i = 0; i < model.size(); ++i){
			//   cout << i <<":" <<model[i] << " ";
			// }
			return 20;
		}
		// start new decision level:
		modelStack.push_back(0);  // push mark indicating new DL
		++indexOfNextLitToPropagate;
		++decisionLevel;
		setLiteralToTrue(decisionLit);    // now push decisionLit on top of the mark
	}
}