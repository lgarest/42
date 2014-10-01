uniform float time;
varying vec3 matriu;

void main()
{
	gl_FragColor = gl_Color * matriu.z;
}
