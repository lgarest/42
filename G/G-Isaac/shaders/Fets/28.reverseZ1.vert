// simple vertex shader

void main()
{
	vec4 clip    = gl_ModelViewProjectionMatrix * gl_Vertex;
	clip.z = -clip.z;
	gl_Position = clip;
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
