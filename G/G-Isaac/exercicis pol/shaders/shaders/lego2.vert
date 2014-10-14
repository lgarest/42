// simple vertex shader

varying vec4 pos;
varying vec4 posicio; 
varying vec3 normal;

uniform bool world;

void main()
{
	pos = gl_Vertex;
	posicio = gl_Vertex;
	normal = gl_Normal;

	gl_Position    = gl_ModelViewProjectionMatrix * gl_Vertex;
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = 	gl_MultiTexCoord0;
	
}
