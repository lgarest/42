// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;
uniform bool world;

varying vec3 Nobs;
varying vec3 Vobs;
varying vec3 Lobs;

varying vec3 Nworld;
varying vec3 Vworld;
varying vec3 Lworld;

vec4 light(vec3 N, vec3 V, vec3 L){
	N=normalize(N);
	V=normalize(V);
	L=normalize(L);
	vec3 R = normalize( 2.0*dot(N,L)*N-L );
	float NdotL = max( 0.0, dot( N,L ) );
	float RdotV = max( 0.0, dot( R,V ) );
	float Idiff = NdotL;
	float Ispec = pow( RdotV, gl_FrontMaterial.shininess );
	return gl_FrontMaterial.emission +
	gl_FrontMaterial.ambient * gl_LightModel.ambient +
	gl_FrontMaterial.ambient * gl_LightSource[0].ambient +
	gl_FrontMaterial.diffuse * gl_LightSource[0].diffuse * Idiff+
	gl_FrontMaterial.specular * gl_LightSource[0].specular * Ispec;
}

void main()
{
	if (world){
		gl_FragColor = light(Nworld, Vworld, Lworld);
	}
	else{
		gl_FragColor = light(Nobs, Vobs, Lobs);
	}
}