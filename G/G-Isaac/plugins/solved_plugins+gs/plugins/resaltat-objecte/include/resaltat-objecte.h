#ifndef _RESALTAT_OBJECTE_H
#define _RESALTAT_OBJECTE_H

#include "effectinterface.h"
#include <QElapsedTimer>
#include <QGLShader>
#include <QGLShaderProgram>

class ResaltatObjecte: public QObject, public EffectInterface
{
    Q_OBJECT
    Q_INTERFACES(EffectInterface)
    
  public:
    //void preFrame();
    void postFrame();

  private:

};
#endif