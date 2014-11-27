// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;
uniform int n;

void main()
{
	if (mod(ceil(gl_FragCoord.y), n) != 0) discard;
	else gl_FragColor = gl_Color;
}
