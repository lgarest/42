#include "effectiluminacion.h"
#include "glwidget.h"
#include <iostream>
#include <QGLShaderProgram>

void EffectIluminacion::preFrame()
{
	QGLShaderProgram program(/*context*/);
	program.addShaderFromSourceCode(QGLShader::Vertex,
		"varying vec3 normal;\n"
		"varying vec4 position;\n"
		"void main(void)\n"
		"{\n"
		"   gl_Position    = gl_ModelViewProjectionMatrix * gl_Vertex;\n"
		"	position = gl_Position;\n"
		"	gl_TexCoord[0] = gl_MultiTexCoord0;\n"
		"	normal  = gl_NormalMatrix * gl_Normal;\n"
		"	gl_FrontColor = gl_Color;\n"
		"}");

	program.addShaderFromSourceCode(QGLShader::Fragment,
		"varying vec3 normal;\n"
		"varying vec4 position;\n"
		"vec4 light(vec3 N, vec3 V, vec3 L) {\n"
		"	N=normalize(N); V=normalize(V); L=normalize(L);\n"
		"	vec3 R = normalize( 2.0*dot(N,L)*N-L );\n"
		"	float NdotL = max( 0.0, dot( N,L ) );\n"
		"	float RdotV = max( 0.0, dot( R,V ) );\n"
		"	float Idiff = NdotL;\n"
		"	float Ispec = pow( RdotV, gl_FrontMaterial.shininess );\n"
		"	return\n"
		"	gl_FrontMaterial.emission +\n"
		"	gl_FrontMaterial.ambient * gl_LightModel.ambient +\n"
		"	gl_FrontMaterial.ambient * gl_LightSource[0].ambient +\n"
		"	gl_FrontMaterial.diffuse * gl_LightSource[0].diffuse * Idiff+\n"
		"	gl_FrontMaterial.specular * gl_LightSource[0].specular * Ispec;\n"
		"}\n"

		"void main(void) {\n"
		"	vec4 LightPos = gl_ModelViewProjectionMatrix * gl_LightSource[0].position;\n"
		"	vec4 L = LightPos - position;//Vector unitari cap a la font de llum;\n"
		"	vec3 V = vec3(0,0,1) - position.xyz;\n"
		"	gl_FragColor = light(normal, V, L.xyz);\n"
		"}\n");

	program.link();
	program.bind();

	//int normalLocation = program.varyingLocation("normal");
	//int positionLocation = program.varyingLocation("position");
}

void EffectIluminacion::postFrame()
{
	QGLShaderProgram program(/*context*/);
	program.removeAllShaders();
}

Q_EXPORT_PLUGIN2(effectiluminacion, EffectIluminacion)   // plugin name, plugin class
