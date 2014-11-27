// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;
uniform sampler2D sampler;
void main()
{
	gl_FragColor =  gl_Color;
}
