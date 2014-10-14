// simple vertex shader

uniform float minY;
uniform float maxY;

void main()
{
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
	vec4 r = vec4(255.0, 0.0, 0.0, 0.0);
	vec4 b = vec4(0.0, 0.0, 255.0, 0.0);
	vec4 prop = mix (r, b, gl_Vertex.y);
	//vec4 propFrac = fract(mix(r, b, gl_Vertex.y));
	//float r = prop;
	//float b = 255-prop;
	//if (gl_Vertex.y > -0.9) gl_FrontColor = vec4(255, 0, 0, 0);
	//else gl_FrontColor = vec4(0, 255, 0, 0);
	gl_FrontColor = prop;
	//mix(r, b, gl_Position.y); 
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
