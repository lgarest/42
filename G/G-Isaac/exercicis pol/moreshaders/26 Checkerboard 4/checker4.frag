// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;

uniform int N;

void main()
{
	float as = gl_TexCoord[0].s*N;
	float at = gl_TexCoord[0].t*N;
	if (fract(as) <= 0.1 || fract(at) <= 0.10) gl_FragColor = vec4(0.0,0.0,0.0,1.0);
	else discard;
}
