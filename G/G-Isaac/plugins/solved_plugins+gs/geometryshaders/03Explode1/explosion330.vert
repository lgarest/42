// simple vertex shader

#version 330 compatibility

out vec3 vNormal;
out vec4 vColor;

void main()
{
	gl_Position    = gl_Vertex;
	vColor  = gl_Color;
	vNormal = gl_Normal;
}
