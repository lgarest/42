// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;
uniform int N;

void main()
{
	float s = fract(gl_TexCoord[0].s*16.0);
	float t = fract(gl_TexCoord[0].t*16.0);
	if ((s >= 0.45 && s <= 0.55) ||
		(t >= 0.45 && t <= 0.55)) gl_FragColor = vec4(1.0,0.0,0.0,0.0);
	else discard;
}
