// simple geometry shader

// these lines enable the geometry shader support.
#version 330 compatibility

in vec3 vNormal[3];
out vec3 gNormal;
in vec4 vColor[3];
out vec4 gColor;
uniform float time;

uniform float speed;
uniform float angSpeed;

layout(triangles) in;
layout(triangle_strip,max_vertices=3) out;

void main( void )
{
	float t = time;//mod(time, 3.0); // repeat every 3 seconds
	vec3 n = ( vNormal[0] + vNormal[1] + vNormal[2])/3.0;
	float st = speed *t;
	vec4 trans = vec4(n.x*st,n.y*st,n.z*st,1.0);
	vec4 center = ( gl_in[0].gl_Position + gl_in[1].gl_Position + gl_in[2].gl_Position)/3.0;
	for( int i = 0 ; i < gl_in.length(); i++ )
	{
		gNormal = vNormal[i];
		gColor = vColor[i];
		vec4 vert = (gl_in[i].gl_Position);
		float angle = time*angSpeed;
		float c = cos(angle);
		float s = sin(angle);
		float d = 1.0-cos(angle);
		float x = center.x;
		float y = center.y;
		float z = center.z;
		mat4 TranslationMatrix = mat4(1.0, 			0.0, 0.0, trans.x,
							    0.0, 			1.0, 0.0, trans.y,
							    0.0, 			0.0, 1.0, trans.z,
							     0.0,           0.0, 0.0, 1.0 );
		mat4 RotationMatrixZ = mat4(((x*x*d)+c), ((x*y*d) - (z*s)),((x*z*d)+(y*s)), 0.0,
			        		     (y*x*d)+(z*s), (y*y*d)+c, (y*z*d) - (x*s), 0.0,
							    (x*z*d)-y*s, (y*z*d)+(x*s), (z*z*d)+c, 0.0,
							     0.0,           0.0, 0.0, 1.0 );
		vert *= (RotationMatrixZ*TranslationMatrix);
		gl_Position = gl_ModelViewProjectionMatrix * vert;
		EmitVertex();
	}
}