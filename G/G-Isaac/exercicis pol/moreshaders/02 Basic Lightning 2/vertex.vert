// simple vertex shader

varying vec3 normal;

void main()
{
	
	normal = gl_NormalMatrix * gl_Normal;
	gl_Position    = gl_ModelViewProjectionMatrix * gl_Vertex;
	gl_FrontColor  = gl_Color * normal.z;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
