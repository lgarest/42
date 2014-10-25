/* Author: Luis García Estrades
  SubGroup: 13 */

#header
<<
#include <string>
#include <iostream>
#include <map>
#include <stdlib.h>
#include <time.h>

using namespace std;

// struct to store information about tokens
typedef struct {
  string kind;
  string text;
} Attrib;

// function to fill token information (predeclaration)
void zzcr_attr(Attrib *attr, int type, char *text);

// fields for AST nodes
#define AST_FIELDS string kind; string text;
#include "ast.h"

// macro to create a new AST node (and function predeclaration)
#define zzcr_ast(as,attr,ttype,textt) as=createASTnode(attr,ttype,textt)
AST* createASTnode(Attrib* attr,int ttype, char *textt);
>>

<<
#include <cstdlib>
#include <cmath>

//global structures
AST *root;

//stores the position of the robot in 2D coordinates
pair <int,int> finalposition;


// function to fill token information
void zzcr_attr(Attrib *attr, int type, char *text) {
  if (type == ID) {
    attr->kind = "id";
    attr->text = text;
  }
  else {
    attr->kind = text;
    attr->text = "";
  }
}


// function to create a new AST node
AST* createASTnode(Attrib* attr, int type, char* text) {
  AST* as = new AST;
  as->kind = attr->kind;
  as->text = attr->text;
  as->right = NULL;
  as->down = NULL;
  return as;
}


/// create a new "list" AST node with one element
AST* createASTlist(AST *child) {
 AST *as=new AST;
 as->kind="list";
 as->right=NULL;
 as->down=child;
 return as;
}


AST *findTask(string id) {
  AST *n = root->down->right->right->down;
  while (n != NULL and (n->down->text != id)) n = n->right;
  if (n == NULL) {cout << "NOT FOUND: " << id << " " << endl;}
  return n->down->right;
}

/// get nth child of a tree. Count starts at 0.
/// if no such child, returns NULL
AST* child(AST *a,int n) {
AST *c=a->down;
for (int i=0; c!=NULL && i<n; i++) c=c->right;
return c;
}


/// print AST, recursively, with indentation
void ASTPrintIndent(AST *a,string s)
{
  if (a==NULL) return;

  cout<<a->kind;
  if (a->text!="") cout<<"("<<a->text<<")";
  cout<<endl;

  AST *i = a->down;
  while (i!=NULL && i->right!=NULL) {
    cout<<s+"  \\__";
    ASTPrintIndent(i,s+"  |"+string(i->kind.size()+i->text.size(),' '));
    i=i->right;
  }

  if (i!=NULL) {
      cout<<s+"  \\__";
      ASTPrintIndent(i,s+"   "+string(i->kind.size()+i->text.size(),' '));
      i=i->right;
  }
}


/// print AST
void ASTPrint(AST *a)
{
  while (a!=NULL) {
    cout<<" ";
    ASTPrintIndent(a,"");
    a=a->right;
  }
}


bool SenseProx() { return (rand() % 2) == 0; }


int SenseLight() { return rand() % 100; }

//////////////////////////////////////////////////////////////////////////////
// AUXILIAR FUNCTIONS
//////////////////////////////////////////////////////////////////////////////

void lookForPatterns(AST *node); // function prototype


/* FUNCTION: movePos
 This function changes the robot coords depending on the direction and its value
 - parameters:
    - node (pointer): it points to the first child of the instruction. */
void movePos(AST *node){
  if (node->down->kind == "right")
    finalposition.first += atoi(node->down->right->kind.c_str());
  else if (node->down->kind == "left")
    finalposition.first -= atoi(node->down->right->kind.c_str());
  else if (node->down->kind == "up")
    finalposition.second += atoi(node->down->right->kind.c_str());
  else finalposition.second -= atoi(node->down->right->kind.c_str());
}


/* FUNCTION: evaluateChild
 This function evaluates the conditions of an if, they can be nested.
 - parameters:
    - node (pointer): it points to the current child to be evaluated. */
bool evaluateChild(AST *node){
  if(node->kind == ">" or node->kind == "=="){
    if(node->down->kind == "sensorlight" or node->down->right->kind == "sensorlight"){
      // light sensor case '>' or '=='
      int cn1,cn2;

      if(node->down->kind == "sensorlight"){
        // if the first term is "sensorlight"
        cn1 = SenseLight(); // lightsensor value
        cn2 = atoi(node->down->right->kind.c_str()); // value to compare
      }else{
        // the second term is "sensorlight"
        cn1 = atoi(node->down->kind.c_str()); // value to compare
        cn2 = SenseLight(); // lightsensor value
      }
      if (node->kind == ">") return cn1 > cn2;
      return cn1 == cn2;
    }
    else if(node->down->kind == "sensorprox" or node->down->right->kind == "sensorprox" ){
      // proximity sensor case '=='
      int cn1 = SenseProx(); // proximitysensor value 0 or 1
      string cn2 = node->down->kind; // value to compare
      int aux = 0; // aux defaults to OFF

      if(node->down->kind == "sensorprox") cn2 = node->down->right->kind;
      if(cn2 == "ON") aux = 1;
      return aux == cn1;
    }
  }
  else if(node->kind == "AND" or node->kind == "OR"){
    // recursive call evaluating its children
    bool c1 = evaluateChild(node->down);
    bool c2 = evaluateChild(node->down->right);
    if (node->kind == "AND") return c1 and c2;
    return c1 or c2;
  }
}


/* FUNCTION: evaluateIf
 This function evaluates the conditions of an if and executes the nested instructions in case of a true value.
 - parameters:
    - node (pointer): it points to the if node. */
void evaluateIf(AST *node){
  if(node->down != NULL and evaluateChild(node->down))
    lookForPatterns(node->down->right);
}


/* FUNCTION: lookForPatterns
 This function finds patterns in instructions and executes them recursively.
 - parameters:
    - node (pointer): it points to the current instruction node. */
void lookForPatterns(AST *node){
  if (node == NULL) return; // basic case
  if (node->kind == "move")
    movePos(node); // calculation of the new position
  else if (node->kind == "ops" and node->down != NULL)
    lookForPatterns(node->down); // iteration over the instructions in the list
  else if (node->kind == "if")
    evaluateIf(node); // evaluation of the if
  else if (node->kind == "exec")
    lookForPatterns(findTask(node->down->text)); // find the task and execute its code
  else if (node->kind == "list" and node->down != NULL)
    lookForPatterns(node->down); // children call
  if (node->right != NULL) lookForPatterns(node->right); // recursive call
}


/* FUNCTION: findNewPosition
 This function finds the new position of the robot. It iterates over all the relevant program instructions.*/
void findNewPosition(){
  // we read the initial position values
  finalposition.first = atoi(root->down->down->kind.c_str());
  finalposition.second = atoi(root->down->down->right->kind.c_str());
  lookForPatterns(root->down->right->down); // call of the function with the first instruction
  cout << "finalposition: (" << finalposition.first << ", " <<finalposition.second << ")\n";
}


//////////////////////////////////////////////////////////////////////////////
// MAIN FUNCTION
//////////////////////////////////////////////////////////////////////////////
int main() {
  srand (time(NULL));
  root = NULL;
  ANTLR(roomba(&root), stdin);
  ASTPrint(root);
  findNewPosition();
}
>>

//////////////////////////////////////////////////////////////////////////////
// TOKENS AND GRAMMAR DECLARATION
//////////////////////////////////////////////////////////////////////////////
#lexclass START
#token NUM "[0-9]+"
#token AND "AND"
#token OR "OR"
#token STARTC "startcleaning"
#token ENDC "endcleaning"


#token SPACE "[\ \n]" << zzskip();>>
#token POS "position"

#token UP "up"
#token DOWN "down"
#token RIGHT "right"
#token LEFT "left"
#token ON "ON"
#token OFF "OFF"
#token OCL "\["
#token CCL "\]"
#token COMMA ","
#token COMP "=="
#token GT ">"

#token EXE "exec"
#token OPS "ops"
#token FLUSH "flush"
#token IF "if"
#token THEN "then"
#token MOV "move"
#token TASK "TASK"
#token ETASK "ENDTASK"

#token SENP "sensorprox"
#token SENL "sensorlight"


#token ID "[a-zA-Z][a-zA-Z0-9]*"

roomba: position STARTC! linstr ENDC! tasks <<#0=createASTlist(_sibling);>> ;

position: POS^ NUM NUM;
linstr: list  <<#0=createASTlist(_sibling);>> ;
list: (instr)*;

instr: exe | ops | flush | conditional | move;

exe: EXE^ ID;
ops: OPS^ OCL! (instr (COMMA! instr)* | ) CCL!;
flush: FLUSH^ NUM;
conditional: IF^ cond THEN! instr;
move: MOV^ (UP | DOWN | RIGHT | LEFT) NUM;

cond: expr((AND^|OR^) expr)*;

expr: term1 (GT^|COMP^) (NUM|ON|OFF);
term1: SENP | SENL;

tasks: (task)*  <<#0=createASTlist(_sibling);>> ;
task: TASK^ (ID linstr | ) ETASK!;
