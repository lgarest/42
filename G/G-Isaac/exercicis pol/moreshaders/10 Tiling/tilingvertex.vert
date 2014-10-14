// simple vertex shader

uniform int tiles;

void main()
{
	tiles = 8;
	gl_Position    = gl_ModelViewProjectionMatrix * gl_Vertex;
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0*tiles;
}
