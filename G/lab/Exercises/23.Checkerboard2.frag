// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;
uniform float N;

void main()
{
	float s = floor(gl_TexCoord[0].s*N);
	float t = floor(gl_TexCoord[0].t*N);
	float oddevens = floor(mod(s,2.0));
	float oddevent = floor(mod(t,2.0));
	if ((oddevens == 0.0 && oddevent == 0.0) || (oddevens == 1.0 && oddevent == 1.0)) gl_FragColor = vec4(0.0,0.0,0.0,1.0);
	else gl_FragColor = vec4(1.0,1.0,1.0,1.0);
}
