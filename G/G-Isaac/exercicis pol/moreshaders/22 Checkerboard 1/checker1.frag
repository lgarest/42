// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;

void main()
{
	int s = mod(gl_TexCoord[0].s*8,8);
	int t = mod(gl_TexCoord[0].t*8,8);
	int oddevens = mod(s,2.0);
	int oddevent = mod(t,2.0);
	if ((oddevens == 0 && oddevent == 0) || (oddevens == 1 && oddevent == 1)) gl_FragColor = vec4(0.0,0.0,0.0,1.0);
	else gl_FragColor = vec4(0.5,0.5,0.5,1.0);
}
