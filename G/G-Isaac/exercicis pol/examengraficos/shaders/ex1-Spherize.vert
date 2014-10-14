// simple vertex shader

void main()
{
	gl_Position    = gl_ModelViewProjectionMatrix * vec4(normalize(gl_Vertex.xyz), 1);
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
