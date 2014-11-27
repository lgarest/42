uniform float speed;
uniform float time;

void main()
{
	vec4 rot = gl_Vertex;
	rot.x = gl_Vertex.x*cos(time*speed*2*3.14159)+gl_Vertex.z*sin(time*speed*2*3.14159);
	rot.z = -gl_Vertex.x*sin(time*speed*2*3.14159)+gl_Vertex.z*cos(time*speed*2*3.14159);

	gl_Position    = gl_ModelViewProjectionMatrix * rot;
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
