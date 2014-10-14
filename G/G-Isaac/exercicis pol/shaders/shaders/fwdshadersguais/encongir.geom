// simple geometry shader

// these lines enable the geometry shader support.
#version 120
#extension GL_EXT_geometry_shader4 : enable

void main( void )
{
	vec4 media = vec4(0,0,0,0);

	for( int i = 0 ; i < gl_VerticesIn ; i++ ) {
		media += gl_PositionIn[ i ];

	}
	media /= gl_VerticesIn;
	for( int i = 0 ; i < gl_VerticesIn ; i++ )
	{
		gl_FrontColor  = gl_FrontColorIn[ i ];
		gl_Position    = (media + gl_PositionIn  [ i ])/2;
		gl_TexCoord[0] = gl_TexCoordIn  [ i ][ 0 ];
		EmitVertex();
	}
}
