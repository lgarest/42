// simple vertex shader

uniform int tiles;

uniform float A;
uniform float F;
uniform float time;

varying vec4 vertex;
varying vec4 normal;

varying vec4 distancia;
float PI = 3.14;

void main()
{
	//normals = gl_NormalMatrix*gl_Normal;
	normal = vec4(gl_Normal.x,gl_Normal.y,gl_Normal.z,0);
	distancia = gl_Vertex + (normal *(abs(sin(time*PI*F)*A)));
	vertex = vec4 (distancia.xyz,1.0);
	gl_Position    = gl_ModelViewProjectionMatrix * vertex;
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0*tiles;
}
