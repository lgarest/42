#ifndef _FRAMERATE_H
#define _FRAMERATE_H

#include "effectinterface.h"
#include <QElapsedTimer>

class Framerate: public QObject, public EffectInterface
{
    Q_OBJECT
    Q_INTERFACES(EffectInterface)
    
    QElapsedTimer timer;
    
  public:
    void preFrame();
    void postFrame();
};
#endif