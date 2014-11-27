// simple vertex shader
	varying vec3 normal;
void main()
{
	gl_Position    = gl_ModelViewProjectionMatrix * gl_Vertex;
	normal = gl_NormalMatrix*gl_Normal;
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
