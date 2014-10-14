#ifndef _FRAMERATE_H  
#define _FRAMERATE_H

#include <QElapsedTimer>
#include "effectinterface.h"

class FrameRate : public QObject, public EffectInterface
 {
     Q_OBJECT
     Q_INTERFACES(EffectInterface)

 public:
	QElapsedTimer timer;
    void preFrame();
    void postFrame();
 	
 };
 
 #endif
 
 
