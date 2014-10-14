// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;
varying vec3 normal;
varying vec4 position;

vec4 light(vec3 N, vec3 V, vec3 L) {
	N=normalize(N); V=normalize(V); L=normalize(L);
	//vec3 R = normalize( 2.0*dot(N,L)*N-L );
	vec3 H = normalize(V+L);
	float NdotL = max( 0.0, dot( N,L ) );
	float NdotH = max( 0.0, dot( N,H ) );
	float Idiff = NdotL;
	float Ispec = pow( NdotH, gl_FrontMaterial.shininess );
	return
	gl_FrontMaterial.emission +
	gl_FrontMaterial.ambient * gl_LightModel.ambient +
	gl_FrontMaterial.ambient * gl_LightSource[0].ambient +
	gl_FrontMaterial.diffuse * gl_LightSource[0].diffuse * Idiff+
	gl_FrontMaterial.specular * gl_LightSource[0].specular * Ispec;
}

void main()
{
	vec4 LightPos = gl_ModelViewProjectionMatrix * gl_LightSource[0].position;
	vec4 L = LightPos - position;//Vector unitari cap a la font de llum;
	vec3 V = vec3(0,0,1) - position.xyz;
	gl_FragColor = light(normal, V, L.xyz);
}
