// simple vertex shader

varying vec4 pos;

void main()
{
	pos = gl_Vertex;
	gl_Position    = gl_Vertex;
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
