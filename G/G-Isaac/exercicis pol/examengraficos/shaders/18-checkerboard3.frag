// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;
uniform int N;

void main()
{
	float s = gl_TexCoord[0].s*N;
	float t = gl_TexCoord[0].t*N;
	if (mod(s, 2) >= 0.9 && (mod(s, 2) <= 1.1)) gl_FragColor = vec4(0, 0, 0, 0);
	else if (mod(t, 2) >= 0.9 && (mod(t, 2) <= 1.1)) gl_FragColor = vec4(0, 0, 0, 0);
	else gl_FragColor = vec4(255, 255, 255, 0);
}
