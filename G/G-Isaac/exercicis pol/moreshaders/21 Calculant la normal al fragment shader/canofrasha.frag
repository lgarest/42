// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;
varying vec3 Vobs;

void main()
{
	vec3 dFx = dFdx(Vobs);
	vec3 dFy = dFdy(Vobs);
	vec3 normal = normalize(cross(dFx,dFy));
	gl_FragColor = gl_Color*normal.z;
}
