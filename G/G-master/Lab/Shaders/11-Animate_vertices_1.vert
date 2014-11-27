uniform float time;
uniform float A;
uniform float F;

void main()
{	
	float pi = 3.141592654;
	vec3 animate = gl_Normal*(A*sin(time*2.0*pi*F)) + vec3(gl_Vertex);
	gl_Position = gl_ModelViewProjectionMatrix * vec4(animate, 1.0);
	gl_FrontColor  =  vec4((gl_NormalMatrix * gl_Normal).z);
	gl_TexCoord[0] = gl_MultiTexCoord0;
}