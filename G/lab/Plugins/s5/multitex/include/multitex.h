#ifndef _MULTITEX_H
#define _MULTITEX_H

#include <QGLShader>
#include <QGLShaderProgram>
#include "effectinterface.h"

class Multitex : public QObject, public EffectInterface
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
    GLuint textureId0, textureId1;
 };
 
 #endif
