// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;

uniform int N;

void main()
{
	float a = 1.0/9.0;
	float as = gl_TexCoord[0].s;
	if ((fract(as) >= 0 && fract(as) < a) || (fract(as) >= a*2 && fract(as) < a*3) || (fract(as) >= a*4 && fract(as) < a*5) || (fract(as) >= a*6 && fract(as) < a*7) || (fract(as) >= a*8 && fract(as) < a*9)) gl_FragColor = vec4(1.0,1.0,0.0,1.0);
	else gl_FragColor = vec4(1.0,0.0,0.0,1.0);
}
