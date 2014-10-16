#include <iostream>
#include <stdlib.h>
#include <algorithm>
#include <vector>
#include <time.h>
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
uint decisions;
uint propagations;

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
uint decisionIterator;

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

void printModelStack(){
	cout << "\nmodelStack: ";
	for (int i = 0; i < modelStack.size(); ++i) cout << modelStack[i] << " ";
	cout << endl;
}

void printLitCounter(){
	cout << "litCounter:" << endl;
	for (int i = 0; i < litCounter.size(); ++i)
		cout << litCounter[i].first << ":" << litCounter[i].second << "  ";
	cout << endl;
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
	// printAppearsInClause();
}




int currentValueInModel(int lit)
// Returns the value of the literal inside the model
{
	if (lit >= 0) return model[lit];
	else {
		if (model[-lit] == UNDEF) return UNDEF;
		else return 1 - model[-lit];
	}
}


void setLiteralToTrue(int lit)
{
	modelStack.push_back(lit);
	if (lit > 0) model[lit] = TRUE;
	else model[-lit] = FALSE;
}


bool propagateGivesConflict()
// Returns if the propagation gives conflict
{
	int lastUndefLit;
	while ( indexOfNextLitToPropagate < modelStack.size() ) {
		++indexOfNextLitToPropagate;
		// last decision taken
		int lastDecision = modelStack[indexOfNextLitToPropagate - 1];

		// clausesVectorSize == the size of the vector that includes in which clauses the lit appears (as a negative or positive value)
		int clausesVectorSize;

		// if the last decision is positive we only have to look where it appears as a negative value
		if (lastDecision > 0) clausesVectorSize = appearsInClause[abs(lastDecision)].n.size();

		// if the last decision is negative we only have to look where it appears as a positive value
		else clausesVectorSize = appearsInClause[abs(lastDecision)].p.size();

		// iterates over the positive or negative clausules vector
		for (uint i = 0; i < clausesVectorSize; ++i) {
			bool someLitTrue = false;
			int numUndefs = 0;
			int lastLitUndef = 0;

			// clauseIter == iterates over the positive or negative clauses vector where the lit appears
			int clauseIter;
	      	if (lastDecision > 0)
	      		clauseIter = appearsInClause[abs(lastDecision)].n[i];
	      	else clauseIter = appearsInClause[abs(lastDecision)].p[i];

	      	// For each clausule where the literal is negated, we look the value of the clausule
	      	int posornegClausesSize = clauses[clauseIter].size();
			for (uint k = 0; not someLitTrue and k < posornegClausesSize; ++k){
				int val = currentValueInModel(clauses[clauseIter][k]);
				if (val == TRUE) someLitTrue = true;
				else if (val == UNDEF){
				 	++numUndefs;
				 	lastLitUndef = clauses[clauseIter][k];
				}
			}

			if (not someLitTrue and numUndefs == 0)
				return true; // conflict! all lits false
			else if (not someLitTrue and numUndefs == 1)
				setLiteralToTrue(lastLitUndef);
				++propagations;
		}
	}
	return false;
}


// backtrack func
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
	// decrement the iterator of the litCounter vector to get the next decision literal
	--decisionIterator;
	indexOfNextLitToPropagate = modelStack.size();
	setLiteralToTrue(-lit);  // reverse last decision
}


int getNextDecisionLiteral()
	// Heuristic for finding the next decision literal
	// Preference given to literals with more appearances
{
	for (uint i = 0; i < numVars; ++i){
		if (model[litCounter[i].first] == UNDEF){
			decisionIterator++;
			return litCounter[i].first;
		}
	}
	return 0; // reurns 0 when all literals are defined
}

void checkmodel()
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
	clock_t tStart = clock();
	readClauses(); // reads numVars, numClauses and clauses themselves
	// we sort the literals by its # of apparitions
	sort(litCounter.begin(), litCounter.end(), cmp);
	model.resize(numVars+1,UNDEF);
	indexOfNextLitToPropagate = 0;
	decisionLevel = 0;
	decisionIterator = 0;
	decisions = 0;
	propagations = 0;

	// Take care of initial unit clauses, if any
	for (uint i = 0; i < numClauses; ++i)
		if (clauses[i].size() == 1) {
			int lit = clauses[i][0];
			int val = currentValueInModel(lit);
			if (val == FALSE) {
				double timer = (double) (clock() - tStart)/CLOCKS_PER_SEC;
				cout << timer << " " << propagations << " " << decisions/timer << "UNSATISFIABLE" << endl;
				return 10;}
			else if (val == UNDEF) setLiteralToTrue(lit);
		}

	// DPLL algorithm
	// Davis-Putnam-Loveland-Logemann
	while (true) {
		while ( propagateGivesConflict() ) {
			// si hemos vuelto al principio
			if ( decisionLevel == 0) {
				double timer = (double) (clock() - tStart)/CLOCKS_PER_SEC;
				cout << timer << " " << propagations << " " << decisions/timer << "UNSATISFIABLE" << endl;
				return 10;
			}
			backtrack(); // o backjump
		}

		int decisionLit = getNextDecisionLiteral();
		if (decisionLit == 0) {
			checkmodel();
			double timer = (double) (clock() - tStart)/CLOCKS_PER_SEC;
			cout << timer << " " << propagations << " " << decisions/timer << "SATISFIABLE" << endl;
			return 20;
		}
		// start new decision level:
		modelStack.push_back(0);  // push mark indicating new DL
		++indexOfNextLitToPropagate;
		++decisionLevel;
		++decisions;
		setLiteralToTrue(decisionLit);    // now push decisionLit on top of the mark
	}
}
