// simple vertex shader
uniform float time;

void main()
{
	gl_TexCoord[0] = gl_MultiTexCoord0;
	float angl = -time*gl_TexCoord[0].s;
	vec3 rot = mat3(
			cos(angl), 0.0, 	-sin(angl),
			0.0,		1.0,	0.0, 
			sin(angl),	0.0,	cos(angl))*gl_Vertex.xyz;
	
	gl_Position    = gl_ModelViewProjectionMatrix * vec4(rot,1.0);
	gl_FrontColor  = vec4(0.0,0.0,1.0,1.0);
}
