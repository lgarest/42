// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;

void main()
{
	float s = fract(gl_TexCoord[0].s);
	float a = 1.0/9.0;
	vec3 col;
	if ((s >= 0.0*a && s < 1.0*a) ||
		(s >= 2.0*a && s < 3.0*a) ||
		(s >= 4.0*a && s < 5.0*a) ||
		(s >= 6.0*a && s < 7.0*a) ||
		(s >= 8.0*a && s < 9.0*a)) col = vec3(1.0,1.0,0.0);
	else col = vec3(1.0,0.0,0.0);
	gl_FragColor = vec4(col,gl_Color.a);
}
