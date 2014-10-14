// simple vertex shader

void main()
{
	
	vec3 Ke = gl_FrontMaterial.emission.rgb;
	vec3 Ka = gl_FrontMaterial.ambient.rgb;
	vec3 Kd = gl_FrontMaterial.diffuse.rgb;
	vec3 Ks = gl_FrontMaterial.specular.rgb;
	float s = gl_FrontMaterial.shininess;
	vec3 Ma = gl_LightModel.ambient.rgb;
	vec3 Ia = gl_LightSource[0].ambient.rgb;
	vec3 Id = gl_LightSource[0].diffuse.rgb;
	vec3 Is = gl_LightSource[0].specular.rgb;
	vec3 N = gl_NormalMatrix*gl_Normal;
	vec3 Vobs = vec3(gl_ModelViewMatrix*gl_Vertex);
	vec3 L = gl_LightSource[0].position.xyz - (Vobs);
	L = normalize(L);
	vec3 V = vec3(0.0, 0.0, 1.0);
	V = normalize(V);
	vec3 H = V + L;
	H = normalize(H);

	vec3 emi = Ke;
	vec3 amb = Ka*(Ma+Ia);
	vec3 dif = Kd*Id*(max(0.0,dot(N,L)));
	vec3 spe = Ks*Is*pow(max(0.0,dot(N,H)),s);
	
	gl_Position    = gl_ModelViewProjectionMatrix * gl_Vertex;
	gl_FrontColor  = vec4(emi+amb+dif+spe,1.0);
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
