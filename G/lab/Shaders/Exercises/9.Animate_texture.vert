// simple vertex shader
uniform float time;
varying vec2 new_textureCoords;
uniform float speed;

void main()
{
	gl_Position    = gl_ModelViewProjectionMatrix * gl_Vertex;
	gl_FrontColor  = vec4((gl_NormalMatrix * gl_Normal).z);
	gl_TexCoord[0] = gl_MultiTexCoord0;
	new_textureCoords = gl_TexCoord[0].st;
	new_textureCoords.s += time*speed;
//	textCoord.t -= 2.0*(time*speed);
}
