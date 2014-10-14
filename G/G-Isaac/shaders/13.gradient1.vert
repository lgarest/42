// simple vertex shader
uniform float maxY;
uniform float minY;

void main()
{
	vec4 blue = vec4(0.0, 0.0, 1.0, 1.0);
	vec4 cian = vec4(0.0, 1.0, 1.0, 1.0);
	vec4 green = vec4(0.0, 1.0, 0.0, 1.0);
	vec4 yellow = vec4(1.0, 1.0, 0.0, 1.0);
	vec4 red = vec4(1.0, 0.0, 0.0, 1.0);
	float acty = (gl_ModelViewProjectionMatrix*gl_Vertex).y;
	vec4 color;
	
	// 0.2 per part
	float fact = abs(acty);
	if (acty > 0.0)
		color = mix(green,blue,fact);
	else if (acty < 0.0)
		color = mix(green,red,fact);


	gl_Position    = gl_ModelViewProjectionMatrix * gl_Vertex;
	gl_FrontColor  = color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
