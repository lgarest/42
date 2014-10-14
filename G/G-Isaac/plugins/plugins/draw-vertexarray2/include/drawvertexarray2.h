#ifndef _DRAWVERTEXARRAY2_H
#define _DRAWVERTEXARRAY2_H

#include "drawinterface.h"

 class DrawVertexArray2 : public QObject, public DrawInterface
 {
     Q_OBJECT
     Q_INTERFACES(DrawInterface)

 public:
     void drawScene();
 };
 
 #endif
 
 
