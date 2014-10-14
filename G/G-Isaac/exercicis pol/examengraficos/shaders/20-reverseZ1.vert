// simple vertex shader

void main()
{
	gl_Position    = gl_ModelViewProjectionMatrix * gl_Vertex;
	gl_Position.z = -1*gl_Position.z;
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
