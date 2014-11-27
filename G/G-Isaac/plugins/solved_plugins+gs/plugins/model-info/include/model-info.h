#ifndef _MODEL_INFO_H
#define _MODEL_INFO_H

#include "effectinterface.h"
#include <QElapsedTimer>

class ModelInfo: public QObject, public EffectInterface
{
    Q_OBJECT
    Q_INTERFACES(EffectInterface)
    
  public:
    void preFrame();
    void postFrame();
};
#endif