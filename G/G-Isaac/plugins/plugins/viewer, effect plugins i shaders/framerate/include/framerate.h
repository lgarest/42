#ifndef _FRAMERATE_H  
#define _FRAMERATE_H

#include "effectinterface.h"

class FrameRate : public QObject, public EffectInterface
 {
     Q_OBJECT
     Q_INTERFACES(EffectInterface)

 public:
    void preFrame();
    void postFrame();

 private:
 	QElapsedTimer timer;
 	
 };
 
 #endif
 
 
