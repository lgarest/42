#ifndef _LIGHTING_H
#define _LIGHTING_H

#include "effectinterface.h"
#include <QElapsedTimer>
#include <QGLShader>
#include <QGLShaderProgram>

class Lighting: public QObject, public EffectInterface
{
    Q_OBJECT
    Q_INTERFACES(EffectInterface)
    
  public:
    void onPluginLoad();
    void preFrame();
    void postFrame();

  private:
    QGLShaderProgram* program;

};
#endif