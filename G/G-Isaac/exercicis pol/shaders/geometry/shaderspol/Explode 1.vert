// simple vertex shader

varying vec4 pos;
varying vec3 norm;

void main()
{
	gl_Position    = gl_Vertex;
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
	pos = gl_Vertex;
	norm = normalize(gl_Normal);
}
