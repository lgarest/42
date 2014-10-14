#ifndef _ANIMATEVERTICES_H  
#define _ANIMATEVERTICES_H

#include "effectinterface.h"
#include "QGLShader"
#include "QGLShaderProgram"

class AnimateVertices : public QObject, public EffectInterface
 {
     Q_OBJECT
     Q_INTERFACES(EffectInterface)

 public:
 	void onPluginLoad();
 	void preFrame();
    void postFrame();

 private:
 	QGLShaderProgram* program;
 	QGLShader* prog;
 };
 
 #endif
 
 
