// simple geometry shader

// these lines enable the geometry shader support.
#version 330 compatibility

in vec3 vNormal[3];
out vec3 gNormal;
in vec4 vColor[3];
out vec4 gColor;
uniform float time;

uniform float speed; // eg. 2.5 (glass.obj)

layout(triangles) in;
layout(triangle_strip,max_vertices=3) out;

void main( void )
{
	float t = time;//mod(time, 3.0); // repeat every 3 seconds
	vec3 n = vec3(( vNormal[0] + vNormal[1] + vNormal[2])/3.0);
	float st = speed *t;
	vec4 trans = vec4(n.x*st,n.y*st,n.z*st,1.0);
	for( int i = 0 ; i < gl_in.length(); i++ )
	{
		gNormal = vNormal[i];
		gColor = vColor[i];
		gl_Position = gl_ModelViewProjectionMatrix * (gl_in[i].gl_Position + trans);
		EmitVertex();
	}
}