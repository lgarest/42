#ifndef _PINTAT_VA_FLAT_H
#define _PINTAT_VA_FLAT_H

#include "drawinterface.h"
#include "point.h"
#include <vector>

using namespace std;

 class PintatVaFlat : public QObject, public DrawInterface
 {
     Q_OBJECT
     Q_INTERFACES(DrawInterface)

 public:
     vector<Point> punts;
     vector<Point> normals;
     void drawScene();
     void onPluginLoad();
     void ObjectAdd();
 };
 
 #endif
 
 