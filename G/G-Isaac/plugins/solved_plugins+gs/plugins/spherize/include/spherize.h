#ifndef _SPHERIZE_H
#define _SPHERIZE_H

#include "effectinterface.h"
#include <QElapsedTimer>
#include <QGLShader>
#include <QGLShaderProgram>

class Spherize: public QObject, public EffectInterface
{
    Q_OBJECT
    Q_INTERFACES(EffectInterface)
    
  public:
    void onPluginLoad();
    void preFrame();
    void postFrame();

  private:
    QGLShaderProgram* program;
    QGLShader* vs;
    QElapsedTimer timer;

};
#endif