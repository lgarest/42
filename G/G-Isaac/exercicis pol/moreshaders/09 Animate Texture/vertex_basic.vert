// simple vertex shader

uniform float time;
uniform float speed;

void main()
{
	gl_Position    = gl_ModelViewProjectionMatrix * gl_Vertex;
	gl_FrontColor  = vec4((gl_NormalMatrix*gl_Normal).z);
	gl_TexCoord[0] = gl_MultiTexCoord0;
	gl_TexCoord[0].s += (speed*time);
	gl_TexCoord[0].t += (speed*time);
	gl_MultiTexCoord0 = gl_TexCoord[0];
}
