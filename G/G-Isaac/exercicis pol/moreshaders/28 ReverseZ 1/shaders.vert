// simple vertex shader

void main()
{
	vec4 vertex = gl_ModelViewProjectionMatrix*gl_Vertex;
	vertex.z = vertex.z *-1;
	gl_Position    = vertex;
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
