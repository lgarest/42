#ifndef _PINTAT_VBO_FLAT_H
#define _PINTAT_VBO_FLAT_H

#include "drawinterface.h"
#include "point.h"
#include <vector>

using namespace std;

 class PintatVboFlat : public QObject, public DrawInterface
 {
     Q_OBJECT
     Q_INTERFACES(DrawInterface)

 public:
     vector< vector <Point> > objspunts;
     vector< vector <Point> > objsnormals;
     vector< vector <int> > objsindexs;
     void drawScene();
     void onPluginLoad();
     void onObjectAdd();
 };
 
 #endif
 
 