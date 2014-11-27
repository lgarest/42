// simple vertex shader

//uniform gl_LightSourceParameters gl_LightSource[1];
//uniform gl_MaterialParameters gl_FrontMaterial;
//uniform gl_MaterialParameters gl_BackMaterial;
vec4 amb;
vec4 diff;
vec4 spec;
vec3 vecn3;
vec4 vecl;
vec4 vech;
vec4 vecv;
float intensity;

vec4 Vobs;
vec3 Nobs;

void main()
{
	Vobs    = (gl_ModelViewMatrix * gl_Vertex);
	Nobs = (gl_NormalMatrix * gl_Normal);
	vecl = (gl_LightSource[0].position - (Vobs));
	vecl = normalize(vecl);
	amb = gl_FrontMaterial.ambient*(gl_LightModel.ambient + gl_LightSource[0].ambient);
	diff = gl_FrontMaterial.diffuse*gl_LightSource[0].diffuse;
	diff *= (max (0.0,dot (vecl,Nobs)));
	vecv = vec4(0,0,1,0);
	vech = (vecl + vecv);
	vech = vech/(sqrt ((vech.x*vech.x) + (vech.y*vech.y) + (vech.z*vech.z)));
	float especular = (max(0.0,dot (Nobs,vech)));
	intensity = pow(especular,gl_FrontMaterial.shininess);
	spec = gl_FrontMaterial.specular*gl_LightSource[0].specular*intensity;
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
	//gl_FrontColor  = gl_FrontMaterial.emission + amb;
	//gl_FrontColor  = gl_FrontMaterial.emission + (amb+diff);
	gl_FrontColor  = (gl_FrontMaterial.emission + (amb+diff+spec));
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
