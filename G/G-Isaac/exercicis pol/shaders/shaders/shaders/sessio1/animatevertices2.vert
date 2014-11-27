// simple vertex shader

uniform float A = 0.1;
uniform float time;
uniform float F = 1.0;
const float PI = 3.14159;
void main()
{
    vec2 textura = gl_MultiTexCoord0.xy;
	float t = sin(F*time+2*PI*gl_Vertex.y)*A;
	vec4 Vertex2 = gl_Vertex + vec4(t*gl_Normal,0.0);
	gl_Position    = gl_ModelViewProjectionMatrix * Vertex2;
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
