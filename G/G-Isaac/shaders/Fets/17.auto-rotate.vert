// simple vertex shader
uniform float time;

void main()
{
	float angl = time*0.5;
	vec3 rot = mat3(
			cos(angl), 0.0, 	-sin(angl),
			0.0,		1.0,	0.0, 
			sin(angl),	0.0,	cos(angl))*vec3(gl_Vertex);
	
	gl_Position    = gl_ModelViewProjectionMatrix * vec4(rot,1.0);
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
