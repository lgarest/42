// simple vertex shader
uniform float minY ;
uniform float maxY ;
void main()
{
	vec4 yellow = vec4(1,1,0,1);
	vec4 green = vec4(0,1,0,1);
	vec4 cyan = vec4(0,1,1,1);
	vec4 red = vec4(1,0,0,1);
	vec4 blue = vec4(0,0,1,1);
	
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
	float normal = (gl_Vertex.y-minY)/(maxY-minY);
	normal = normal*4.0;
	if (normal == 4.0) gl_FrontColor = blue;
	else if (normal == 0.0) gl_FrontColor = red;
	else if(normal < 4.0 && normal > 3.0) gl_FrontColor = mix(cyan,blue,fract(normal));
 	else if(normal > 2.0 && normal <= 3.0) gl_FrontColor = mix(green, cyan,fract(normal));
	else if(normal > 1.0 && normal <= 2.0) gl_FrontColor = mix(yellow, green,fract(normal));
	else if(normal > 0.0 && normal <= 1.0) gl_FrontColor = mix(red, yellow,fract(normal));
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
