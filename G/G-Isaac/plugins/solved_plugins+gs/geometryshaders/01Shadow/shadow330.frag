// simple fragment shader

// 'time' contains seconds since the program was linked.
#version 330 compatibility

uniform float time;

in vec4 gColor;
in vec3 gNormal;

void main()
{
	gl_FragColor = gColor * gNormal.z;
}
