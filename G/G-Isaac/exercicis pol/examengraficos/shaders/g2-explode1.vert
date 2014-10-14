// simple vertex shader
varying out vec3 normal;

void main()
{
	gl_Position    = gl_Vertex;
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
	normal = gl_Normal;
}
