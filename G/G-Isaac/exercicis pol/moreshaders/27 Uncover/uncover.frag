// simple fragment shader

// 'time' contains seconds since the program was linked.

varying vec3 fragment;
uniform float time;
uniform float aux;

void main()
{
	if (2.0*((fragment.x+1.0)/(2.00)) <= aux) gl_FragColor = vec4(0.0,0.0,1.0,0.0);
	else discard;
}
