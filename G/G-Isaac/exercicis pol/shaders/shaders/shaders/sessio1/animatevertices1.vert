// simple vertex shader

uniform float A = 0.1;
uniform float time;
uniform float F = 1;
void main()
{
	float t = sin(F*time)*A;
	vec4 Vertex2 = gl_Vertex + vec4(t*gl_Normal,0.0);
	gl_Position    = gl_ModelViewProjectionMatrix * Vertex2;
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
