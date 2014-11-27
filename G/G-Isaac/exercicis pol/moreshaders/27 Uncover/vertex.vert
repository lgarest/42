// simple vertex shader

varying vec3 fragment;

void main()
{
	gl_Position    = gl_ModelViewProjectionMatrix * gl_Vertex;
	fragment = (gl_Position.xyz/gl_Position.w);
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
