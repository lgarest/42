// simple vertex shader
uniform float time;
varying vec2 textCoord;
uniform float speed; 

void main()
{
	speed = 0.1;
	gl_Position    = gl_ModelViewProjectionMatrix * gl_Vertex;
	gl_FrontColor  = vec4((gl_NormalMatrix * gl_Normal).z);
	gl_TexCoord[0] = gl_MultiTexCoord0;
	textCoord = gl_TexCoord[0].st;
	textCoord.st -= time*speed;
}
