uniform float time;
uniform float F;
uniform float A;

void main()
{	
	float pi = 3.141592654;
	gl_TexCoord[0] = gl_MultiTexCoord0;
	float d = A*sin(time*2.0*pi*F + 2.0*pi*gl_TexCoord[0].s*F);
	vec3 animate = gl_Normal*d + gl_Vertex.xyz;
	gl_Position = gl_ModelViewProjectionMatrix * vec4(animate, 1.0);
	gl_FrontColor  =  vec4((gl_NormalMatrix * gl_Normal).z);

}