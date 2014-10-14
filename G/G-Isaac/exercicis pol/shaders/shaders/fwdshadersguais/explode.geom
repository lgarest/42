// simple geometry shader

// these lines enable the geometry shader support.
#version 120
#extension GL_EXT_geometry_shader4 : enable

varying in vec3 N[];

uniform float time;

void main( void )
{	
	vec3 Ni = vec3(0,0,0);
	for( int i = 0 ; i < gl_VerticesIn ; i++ ) {
		Ni += N[i];
	}
	Ni = normalize(Ni);
	for( int i = 0 ; i < gl_VerticesIn ; i++ )
	{
		gl_FrontColor  = gl_FrontColorIn[ i ];
		gl_Position    = gl_PositionIn  [ i ]+vec4(Ni,0)*1*(log(time+1));
		gl_Position.y -= time*time;
		if(gl_Position.y < -2) gl_Position.y = -2+3*(abs(sin(gl_Position.y+2)/abs(gl_Position.y)));
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] = gl_TexCoordIn  [ i ][ 0 ];
		EmitVertex();
	}
}
