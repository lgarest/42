// simple vertex shader

void main()
{
	vec3 vertex = normalize(gl_Vertex.xyz);
	gl_Position    = gl_ModelViewProjectionMatrix * vec4(vertex.xyz,gl_Vertex.w);
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
