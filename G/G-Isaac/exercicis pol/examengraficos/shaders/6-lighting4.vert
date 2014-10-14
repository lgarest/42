// simple vertex shader

varying vec3 normal;
varying vec4 position;

void main()
{
	gl_Position    = gl_ModelViewProjectionMatrix * gl_Vertex;
	position = gl_Position;
	gl_TexCoord[0] = gl_MultiTexCoord0;
	normal  = gl_NormalMatrix * gl_Normal;
	gl_FrontColor = gl_Color;
}
