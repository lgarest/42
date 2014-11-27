// simple vertex shader
uniform float time;

void main()
{
	gl_Position    = gl_ModelViewProjectionMatrix * gl_Vertex;
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0 + time*0.1;
	//gl_TexCoord[0].s = gl_MultiTexCoord0.s + .... y seria lo mismo para la .t
}
