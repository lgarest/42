// simple vertex shader

uniform float speed;
uniform float time;

float PI = 3.14159;

void main()
{
	vec4 vertex = gl_Vertex;
	vertex.x = gl_Vertex.x*cos(time*speed*2*PI)+gl_Vertex.z*sin(time*speed*2*PI);
	vertex.z = -gl_Vertex.x*sin(time*speed*2*PI)+gl_Vertex.z*cos(time*speed*2*PI);
	gl_Position    = gl_ModelViewProjectionMatrix * vertex;
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
