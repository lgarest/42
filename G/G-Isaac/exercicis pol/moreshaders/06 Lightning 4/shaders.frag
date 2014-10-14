// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;

vec4 amb;
vec4 diff;
vec4 spec;
vec3 vecn3;
vec4 vecl;
vec4 vech;
vec4 vecv;
float intensity;
vec3 Rvec;

varying vec4 Vobs;
varying vec3 Nobs;

void main()
{
	vecl = (gl_LightSource[0].position - (Vobs));
	vecl = normalize(vecl);
	amb = gl_FrontMaterial.ambient*(gl_LightModel.ambient + gl_LightSource[0].ambient);
	diff = gl_FrontMaterial.diffuse*gl_LightSource[0].diffuse;
	diff *= (max (0.0,dot (vecl,Nobs)));
	vecv = vec4(0,0,1,0);
	vech = (vecl + vecv);
	vech = vech/(sqrt ((vech.x*vech.x) + (vech.y*vech.y) + (vech.z*vech.z)));
	
	Rvec = 2*(max(0.0,dot(Nobs,vecl)))*Nobs;
	Rvec -= vecl;
	Rvec = normalize(Rvec);

	float especular = (max(0.0,dot (Rvec,vecv)));
	intensity = pow(especular,gl_FrontMaterial.shininess);
	spec = gl_FrontMaterial.specular*gl_LightSource[0].specular*intensity;
	gl_FragColor = (gl_FrontMaterial.emission + (amb+diff+spec));
}
