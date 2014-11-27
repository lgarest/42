uniform float tiles;
uniform sampler2D sampler;

void main()
{
	gl_Position    = gl_ModelViewProjectionMatrix * gl_Vertex;
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
	gl_TexCoord[0].s *= tiles;
	gl_TexCoord[0].t *= tiles;
}
