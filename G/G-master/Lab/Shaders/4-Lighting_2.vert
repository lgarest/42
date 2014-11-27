void main()
{
	gl_Position    = gl_ModelViewProjectionMatrix * gl_Vertex;
	vec4 Ke = gl_FrontMaterial.emission;
	vec4 Ka = gl_FrontMaterial.ambient;
	vec4 Kd = gl_FrontMaterial.diffuse;
	vec4 Ks = gl_FrontMaterial.specular;
	float s = gl_FrontMaterial.shininess;
	vec4 Ma = gl_LightModel.ambient;
	vec4 Ia = gl_LightSource[0].ambient;
	vec4 Id = gl_LightSource[0].diffuse;
	vec4 Is = gl_LightSource[0].specular;
	vec3 N = normalize(gl_NormalMatrix * gl_Normal);
	vec4 L = normalize(gl_LightSource[0].position - gl_ModelViewMatrix * gl_Vertex);
	vec3 V = vec3(0.,0.,1.); 
	vec3 R = (2.0*dot(N,L.xyz)*N)-L.xyz;
	gl_FrontColor  = Ke + Ka*(Ma+Ia) + Kd*Id*(max(0.0, dot(N, L.xyz))) + Ks*Is*pow((max(0.0, dot(R, V))), s);
	gl_TexCoord[0] = gl_MultiTexCoord0;
}