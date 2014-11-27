/* rotate.vert - some vector rotation functions */

// time contains the seconds since the program was linked.
uniform float time;
uniform float speed;

vec4 rotateAroundY( float angle, vec4 v )
{
	float sa = sin( angle );
	float ca = cos( angle );

	return vec4( sa*v.z + ca*v.x,   v.y,
				 ca*v.z - sa*v.x,   v.w );
}

void main( void )
{
	gl_FrontColor = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
	gl_Position = gl_ModelViewProjectionMatrix * rotateAroundY( time*speed, gl_Vertex );
}

