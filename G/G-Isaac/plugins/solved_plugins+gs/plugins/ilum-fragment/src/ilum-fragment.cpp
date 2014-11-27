#include "glwidget.h"
#include "ilum-fragment.h"
#include <iostream>

  void IlumFragment::onPluginLoad(){
    QString vs_src = "varying vec4 Vobs; varying vec3 Nobs; void main() { Vobs = (gl_ModelViewMatrix * gl_Vertex); Nobs = (gl_NormalMatrix * gl_Normal); gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex; }";
    QString fs_src = "varying vec4 Vobs; varying vec3 Nobs; void main() { vec4 vecl = (gl_LightSource[0].position - (Vobs)); vecl = normalize(vecl); vec4 amb = gl_FrontMaterial.ambient*(gl_LightModel.ambient + gl_LightSource[0].ambient); vec4 diff = gl_FrontMaterial.diffuse*gl_LightSource[0].diffuse; diff *= (max (0.0,dot (vecl,Nobs))); vec4 vecv = vec4(0,0,1,0); vec4 vech = (vecl + vecv); vech = vech/(sqrt ((vech.x*vech.x) + (vech.y*vech.y) + (vech.z*vech.z))); float especular = (max(0.0,dot (Nobs,vech))); float intensity = pow(especular,gl_FrontMaterial.shininess); vec4 spec = gl_FrontMaterial.specular*gl_LightSource[0].specular*intensity; gl_FragColor = (gl_FrontMaterial.emission + (amb+diff+spec)); }";
    
    vs = new QGLShader(QGLShader::Vertex, this);
    vs->compileSourceCode(vs_src);
    
    fs = new QGLShader(QGLShader::Fragment, this);
    fs->compileSourceCode(fs_src);
    program = new QGLShaderProgram(this);
    program->addShader(vs);
    program->addShader(fs);
    program->link();
  }
  void IlumFragment::preFrame(){
    program->bind();
  }
  void IlumFragment::postFrame() {
    program->release();
  }
Q_EXPORT_PLUGIN2(ilum-fragment, IlumFragment) // plugin name, class name