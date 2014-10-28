varying vec3 Vobs, Nobs;

void main () {
	vec3 auxVobs = normalize(Vobs);
	vec3 auxNobs = normalize(Nobs);
    vec3 L = gl_LightSource[0].position.xyz - Vobs; // L 
	L = normalize(L);
	vec3 ambient = gl_LightSource[0].ambient.rgb;
	vec3 diffuse = gl_LightSource[0].diffuse.rgb;
	vec3 specular = gl_LightSource[0].specular.rgb;
	vec3 ambientmaterial = gl_FrontMaterial.ambient.rgb;
	vec3 diffusematerial = gl_FrontMaterial.diffuse.rgb;
	vec3 specularmaterial = gl_FrontMaterial.specular.rgb;
	
	vec4 mambient;
	mambient.r = (gl_LightModel.ambient.r + ambient.r) * ambientmaterial.r;
	mambient.g = (gl_LightModel.ambient.g + ambient.g) * ambientmaterial.g;
	mambient.b = (gl_LightModel.ambient.b + ambient.b) * ambientmaterial.b;
	float NL = max(0.0,dot(auxNobs, L));
    
	vec4  mdiffuse;
	mdiffuse.r = diffuse.r * diffusematerial.r;
	mdiffuse.g = diffuse.g * diffusematerial.g;
	mdiffuse.b = diffuse.b * diffusematerial.b;
	vec4 difussetotal = mdiffuse*NL;

	float escalar = 2.0 * NL;
	vec3 robs = escalar*auxNobs;
	robs = robs-L;
	robs = normalize(robs);
	float s = gl_FrontMaterial.shininess;
	float escalarrv = max (0.0, dot(robs, -auxVobs));
	float escalarrvs = pow(escalarrv,s);
	
	vec4 speculartot;
	speculartot.r = specular.r * specularmaterial.r * escalarrvs;
	speculartot.g = specular.g * specularmaterial.g * escalarrvs;
	speculartot.b = specular.b * specularmaterial.b * escalarrvs;
	gl_FragColor = mambient+difussetotal+speculartot;
}
