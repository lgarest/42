#version 330 compatibility

// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;

uniform sampler2D sampl;
void main()
{
	gl_FragColor = texture2D(sampl, gl_TexCoord[0].st);
}
