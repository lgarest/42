// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;

uniform sampler2D textLego;

void main()
{
	gl_FragColor = texture2D(textLego, gl_TexCoord[0].st);
}
