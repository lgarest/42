#include "glwidget.h"
#include "animate-vertices.h"
#include <iostream>

  void AnimateVertices::onPluginLoad(){
    timer.start();
    vs = new QGLShader(QGLShader::Vertex, this);
    //QString vs_src = "uniform float A; uniform float F; uniform float time; void main(){ vec4 normal = vec4(gl_Normal.xyz,0.0); vec4 vertex = gl_Vertex + (normal *(sin(time*1)*0.1),0.0); gl_Position = gl_ModelViewProjectionMatrix * vertex; gl_FrontColor = vec4(1.0,0.0,0.0,0.0); gl_TexCoord[0] = gl_MultiTexCoord0;}";
    QString vs_src = "vec4 normal; vec4 dist; uniform float time; void main(){ normal = vec4(gl_Normal.x, gl_Normal.y, gl_Normal.z,0.0); dist = gl_Vertex + (normal * 0.1 * abs(sin(time*1))); gl_Position = gl_ModelViewProjectionMatrix * dist; gl_FrontColor = gl_Color*normal.z; gl_TexCoord[0] = gl_MultiTexCoord0;}";
    vs->compileSourceCode(vs_src);
    program = new QGLShaderProgram(this);
    program->addShader(vs);
    program->link();
  }
  void AnimateVertices::preFrame(){
    float time = timer.elapsed();
    program->bind();
    program->setUniformValue("A",(GLfloat) 0.1);
    program->setUniformValue("F",1);
    program->setUniformValue("time",time);
  }
  void AnimateVertices::postFrame() {
    program->release();
  }
Q_EXPORT_PLUGIN2(animate-vertices, AnimateVertices) // plugin name, class name