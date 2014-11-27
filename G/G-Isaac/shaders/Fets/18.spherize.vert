// simple vertex shader

void main()
{
	vec3 n = normalize(gl_Vertex.xyz);
	gl_Position = gl_ModelViewProjectionMatrix * vec4(n,gl_Vertex.w);
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
