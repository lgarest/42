uniform float time;
varying vec3 new_vector;

void main()
{
	gl_FragColor = gl_Color * new_vector.z;
}
