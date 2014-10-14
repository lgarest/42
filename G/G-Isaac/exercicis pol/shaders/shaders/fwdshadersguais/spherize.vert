// simple vertex shader

void main()
{
	vec3 vn = normalize(gl_Vertex.xyz);
	gl_Position    = gl_ModelViewProjectionMatrix * vec4(vn.xyz,1);
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
