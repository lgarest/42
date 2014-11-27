// simple vertex shader

varying vec3 N;

void main()
{
	gl_Position    = gl_ModelViewProjectionMatrix * gl_Vertex;
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
	N = gl_NormalMatrix * gl_Normal;
}
