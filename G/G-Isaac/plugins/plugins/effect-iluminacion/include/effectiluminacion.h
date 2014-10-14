#ifndef _EFFECTILUMINACION_H
#define _EFFECTILUMINACION_H

#include "effectinterface.h"

 class EffectIluminacion : public QObject, public EffectInterface
 {
     Q_OBJECT
     Q_INTERFACES(EffectInterface)

 public:
     void preFrame();
     void postFrame();
 };
 
 #endif
 
 
