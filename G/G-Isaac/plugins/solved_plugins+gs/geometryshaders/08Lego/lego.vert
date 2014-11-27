// simple vertex shader

varying vec4 pos;
varying vec3 normal;

void main()
{
	pos = gl_Vertex;
	normal = gl_NormalMatrix*gl_Normal;
	gl_Position    = gl_Vertex;
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}

