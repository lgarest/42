varying float s, t; 
void main()
{
	vec3 N = normalize(gl_NormalMatrix * gl_Normal);
	vec4 L = normalize( - (gl_ModelViewMatrix * gl_Vertex) ); 
	vec3 R = normalize(2.0 * dot(N,L.xyz) * N - L.xyz); 
	s = (R.x / (2.0 * N.z) + 1.0) / 2.0;
	t = (R.y / (2.0 * N.z) + 1.0) / 2.0; 
	gl_Position    = gl_ModelViewProjectionMatrix * gl_Vertex; 
	gl_FrontColor  = vec4(N.z);
	gl_TexCoord[0] = gl_MultiTexCoord0;
}