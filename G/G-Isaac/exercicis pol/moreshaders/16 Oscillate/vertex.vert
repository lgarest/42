// simple vertex shader

uniform float time;
uniform bool eyespace;

varying vec3 normal3;

varying float distancia;
float PI = 3.1415;

void main()
{
	float A;
	normal3 = gl_NormalMatrix*gl_Normal;
	if (eyespace){
		vec4 newvertex = gl_ModelViewProjectionMatrix*gl_Vertex;
		distancia = newvertex.y*sin(2.0*PI*time);
		gl_Position = gl_ModelViewProjectionMatrix*(gl_Vertex + (distancia*vec4(normal3,0.0)));
	}
	else{
		A = gl_Vertex.y;
		distancia = A*sin(2.0*PI*time);
		gl_Position = gl_ModelViewProjectionMatrix*(gl_Vertex + (distancia*vec4(normal3,0.0)));
	}
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}