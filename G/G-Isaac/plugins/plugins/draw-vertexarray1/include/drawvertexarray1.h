#ifndef _DRAWVERTEXARRAY1_H
#define _DRAWVERTEXARRAY1_H

#include "drawinterface.h"

 class DrawVertexArray1 : public QObject, public DrawInterface
 {
     Q_OBJECT
     Q_INTERFACES(DrawInterface)

 public:
     void drawScene();
 };
 
 #endif
 
 
