#ifndef _ILUM_FRAGMENT_H
#define _ILUM_FRAGMENT_H

#include "effectinterface.h"
#include <QElapsedTimer>
#include <QGLShader>
#include <QGLShaderProgram>

class IlumFragment: public QObject, public EffectInterface
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
    QGLShader* fs;

};
#endif