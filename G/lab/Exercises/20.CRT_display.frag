// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;

uniform int n;

void main()
{
	gl_FragColor = gl_Color;
	if (mod(floor(gl_FragCoord.y),n) != 0.0) discard;
}
