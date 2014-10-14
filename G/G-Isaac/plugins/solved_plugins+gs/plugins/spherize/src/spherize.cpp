#include "glwidget.h"
#include "spherize.h"
#include <iostream>

  void Spherize::onPluginLoad(){
    QString vs_src = "void main() { vec3 vertex = normalize(gl_Vertex.xyz); gl_Position = gl_ModelViewProjectionMatrix * vec4(vertex.xyz,gl_Vertex.w); gl_FrontColor  = vec4(1.0,0.0,0.0,0.0); gl_TexCoord[0] = gl_MultiTexCoord0; }";
    vs = new QGLShader(QGLShader::Vertex, this);
    vs->compileSourceCode(vs_src);
    program = new QGLShaderProgram(this);
    program->addShader(vs);
    program->link();
  }
  void Spherize::preFrame(){
    program->bind();
  }
  void Spherize::postFrame() {
    program->release();
  }
Q_EXPORT_PLUGIN2(spherize, Spherize) // plugin name, class name