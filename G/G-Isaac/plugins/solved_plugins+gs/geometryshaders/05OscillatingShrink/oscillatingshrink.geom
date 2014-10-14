// simple geometry shader

// these lines enable the geometry shader support.
#version 120
#extension GL_EXT_geometry_shader4 : enable

uniform float speed;
uniform float time;

const float PI = 3.1415;

void main( void )
{
	//float time = 0.2;
	float temps = mod(time,(2.0/speed));
	if(temps >= 0 && temps < (1.0/speed)){
		if (gl_PrimitiveIDIn%2 == 0){
			for( int i = 0 ; i < gl_VerticesIn ; i++ )
			{
				gl_FrontColor  = gl_FrontColorIn[ i ];
				gl_Position    = gl_PositionIn  [ i ];
				gl_TexCoord[0] = gl_TexCoordIn  [ i ][ 0 ];
				EmitVertex();
			}
		}
		else{
			vec4 center = ( gl_PositionIn[0] + gl_PositionIn[1] + gl_PositionIn[2])/3.0;
			float st = fract(time*speed);
			float pes = sin(st/0.25);
			for( int i = 0 ; i < gl_VerticesIn ; i++ )
			{
				gl_FrontColor  = gl_FrontColorIn[ i ];
				gl_Position    = vec4((gl_PositionIn  [ i ]*pes)+(center*(1-pes)));
				gl_TexCoord[0] = gl_TexCoordIn  [ i ][ 0 ];
				EmitVertex();
			}
		}
	}
	else{
		if (gl_PrimitiveIDIn%2 == 1){
			for( int i = 0 ; i < gl_VerticesIn ; i++ )
			{
				gl_FrontColor  = gl_FrontColorIn[ i ];
				gl_Position    = gl_PositionIn  [ i ];
				gl_TexCoord[0] = gl_TexCoordIn  [ i ][ 0 ];
				EmitVertex();
			}
		}
		else{
			vec4 center = ( gl_PositionIn[0] + gl_PositionIn[1] + gl_PositionIn[2])/3.0;
			float st = fract(time*speed);
			float pes = sin(st/0.25);
			for( int i = 0 ; i < gl_VerticesIn ; i++ )
			{
				gl_FrontColor  = gl_FrontColorIn[ i ];
				gl_Position    = vec4((gl_PositionIn  [ i ]*pes)+(center*(1-pes)));
				gl_TexCoord[0] = gl_TexCoordIn  [ i ][ 0 ];
				EmitVertex();
			}
		}
	}
}
