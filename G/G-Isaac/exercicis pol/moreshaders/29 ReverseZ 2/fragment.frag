// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;

void main()
{
	gl_FragDepth = gl_FragCoord.z *-1.0 +1.0;
	gl_FragColor = gl_Color;
}
