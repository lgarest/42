// simple vertex shader
uniform float time;

void main()
{

	gl_TexCoord[0] = gl_MultiTexCoord0;
	float pi = 3.141592654;
	float d = 0.1*sin(time*2.0*pi+2.0*pi*gl_TexCoord[0].s);
	vec3 trans = gl_Normal*d + vec3(gl_Vertex);
	gl_Position    = gl_ModelViewProjectionMatrix*vec4(trans,1.0);
	gl_FrontColor  = gl_Color;
}
