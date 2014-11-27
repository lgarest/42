// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;

in vec4 gColor;

void main()
{
	gl_FragColor = gColor;
}
