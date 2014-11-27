// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;

void main()
{
	int n = 8;
	float s = gl_TexCoord[0].s*n;
	float t = gl_TexCoord[0].t*n;
	if (mod(s, 2) > 1 && mod(t, 2) > 1) gl_FragColor = vec4(255, 255, 255, 0);
	else if (mod(s, 2) <= 1 && mod(t, 2) <= 1) gl_FragColor = vec4(255, 255, 255, 0);
	else gl_FragColor = vec4(0, 0, 0, 0);
}
