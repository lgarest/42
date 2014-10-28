// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;
uniform float N;

void main()
{
	float s = fract(gl_TexCoord[0].s*N);
	float t = fract(gl_TexCoord[0].t*N);
	
	if ((s >= 0.45 && s <= 0.55) ||
		(t >= 0.45 && t <= 0.55)) gl_FragColor = vec4(0.0,0.0,0.0,1.0);
	else gl_FragColor = vec4(0.5,0.5,0.5,1.0);
}
