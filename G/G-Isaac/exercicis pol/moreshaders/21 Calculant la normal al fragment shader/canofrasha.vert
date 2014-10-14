// simple vertex shader

varying vec3 Vobs;

void main()
{
	Vobs = gl_ModelViewMatrix * gl_Vertex;
	gl_Position    = gl_ModelViewProjectionMatrix * gl_Vertex;
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
