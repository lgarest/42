// simple vertex shader

void main()
{
	gl_Position    = gl_ModelViewProjectionMatrix * gl_Vertex;
	vec3 matriu = gl_NormalMatrix * gl_Normal;
	gl_FrontColor  = gl_Color * matriu.z;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}