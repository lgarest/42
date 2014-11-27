#ifndef _DRAWVERTEXARRAY_H
#define _DRAWVERTEXARRAY_H

#include "drawinterface.h"

 class DrawVertexArray : public QObject, public DrawInterface
 {
     Q_OBJECT
     Q_INTERFACES(DrawInterface)

 public:
     void drawScene();
 };
 
 #endif
 
 
