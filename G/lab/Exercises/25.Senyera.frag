uniform float time;

void main(){
	float s = fract(gl_TexCoord[0].s);
	float a = 1.0/9.0;

	vec3 yellow = vec3(1.0,1.0,0.0);
	vec3 red = vec3(1.0,0.0,0.0);
	vec3 color = red;

	if ((s >= 0.0*a && s < 1.0*a) ||
		(s >= 2.0*a && s < 3.0*a) ||
		(s >= 4.0*a && s < 5.0*a) ||
		(s >= 6.0*a && s < 7.0*a) ||
		(s >= 8.0*a && s < 9.0*a)) color = yellow;
	gl_FragColor = vec4(color, gl_Color.a);
}
