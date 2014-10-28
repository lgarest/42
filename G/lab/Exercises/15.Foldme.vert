// simple vertex shader
uniform float time;

void main()
{
	gl_TexCoord[0] = gl_MultiTexCoord0;
	// el angulo rotado va determinado por el tiempo y la textura
	float phi = -time*gl_TexCoord[0].s;
    // la nueva posición es la matriz rotación por su posición anterior
	vec3 rot = mat3(
			cos(phi), 0.0, 	-sin(phi),
			0.0,		1.0,	0.0, 
			sin(phi),	0.0,	cos(phi)) * gl_Vertex.xyz;
	
	gl_Position    = gl_ModelViewProjectionMatrix * vec4(rot,1.0);
	gl_FrontColor  = vec4(0.0,0.0,1.0,1.0);
}
