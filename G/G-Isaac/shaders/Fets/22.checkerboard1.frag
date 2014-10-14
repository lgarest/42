// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;

void main()
{
	float s = floor(gl_TexCoord[0].s*8.0);
	float t = floor(gl_TexCoord[0].t*8.0);
	float oddevens = floor(mod(s,2.0));
	float oddevent = floor(mod(t,2.0));
	if ((oddevens == 0.0 && oddevent == 0.0) || (oddevens == 1.0 && oddevent == 1.0)) gl_FragColor = vec4(0.0,0.0,0.0,1.0);
	else gl_FragColor = vec4(1.0,1.0,1.0,1.0);
}
