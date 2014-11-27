// simple vertex shader


varying vec3 normal;
varying vec4 posicio; 

void main()
{
	posicio = gl_Vertex;
	normal = gl_Normal;	
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
