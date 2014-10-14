#include "animateVertices.h"
#include "glwidget.h"

void AnimateVertices::onPluginLoad()
{
    QString prog_src = "vec4 normal; vec4 dist; uniform float time; void main(){ normal = vec4(gl_Normal.x, gl_Normal.y, gl_Normal.z,0.0); dist = gl_Vertex + (normal * 0.1 * abs(sin(time*1))); gl_Position = gl_ModelViewProjectionMatrix * dist; gl_FrontColor = gl_Color*normal.z; gl_TexCoord[0] = gl_MultiTexCoord0;}";
	// "uniform float time;

	// void main() {
	// 	float pi = 3.141592654;
	// 	float d = 0.1*sin(time*2.0*pi);
	// 	vec3 trans = gl_Normal*d + vec3(gl_Vertex);
	// 	gl_Position    = gl_ModelViewProjectionMatrix*vec4(trans,1.0);
	// 	gl_FrontColor  = vec4((gl_NormalMatrix * gl_Normal).z);;
	// 	gl_TexCoord[0] = gl_MultiTexCoord0;
	// }"
    prog = new QGLShader(QGLShader::Fragment, this);
	prog->compileSourceCode(prog_src);
	program = new QGLShaderProgram(this);
	program->addShader(prog);
	program->link();

}

void AnimateVertices::preFrame()
{
	program->bind();
	program->setUniformValue("time",time);
	// program->setUniformValue("A",0.1);
	// program->setUniformValue("F",1);
}

void AnimateVertices::postFrame()
{
    program->release();
}

Q_EXPORT_PLUGIN2(animateVertices, AnimateVertices)  // plugin name, plugin class
