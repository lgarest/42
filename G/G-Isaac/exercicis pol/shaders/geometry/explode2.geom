// simple geometry shader

// these lines enable the geometry shader support.
#version 120
#extension GL_EXT_geometry_shader4 : enable
varying in vec4 posicio[3];
varying in vec3 normal[3];
uniform float time;
const float speed = 1.2;
const float angSpeed = 8.0;
void main( void )
{
	vec4 n = vec4(((normal[0]+normal[1]+normal[2])/3), 0.0);
	for( int i = 0 ; i < gl_VerticesIn ; i++ )
	{
		gl_FrontColor  = gl_FrontColorIn[ i ];
		posicio[ i ].x = posicio[ i ].x * cos(angSpeed*time) + posicio[ i ].x *sin(angSpeed*time)
		posicio[ i ].y = -posicio[ i ]. 
		gl_Position    = gl_ModelViewProjectionMatrix*
		(posicio  [ i ]+time*n*speed);
		gl_TexCoord[0] = gl_TexCoordIn  [ i ][ 0 ];
		EmitVertex();
	}
}
