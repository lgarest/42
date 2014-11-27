// simple geometry shader

// these lines enable the geometry shader support.
#version 120
#extension GL_EXT_geometry_shader4 : enable

void main( void )
{

vec4 posicio;

	if(gl_PrimitiveIDIn == 0) {
		int pos = 4;
		for( int i = 0 ; i < gl_VerticesIn ; i++ )
		{
			if(i == 0) posicio = vec4(pos, -2.1, pos, 1.0);
			else if(i==1)  posicio = vec4(-pos, -2.1, pos, 1.0);
			else posicio = vec4(-pos, -2.1, -pos, 1.0);
			gl_FrontColor  =  vec4(1.0,0.0,1.0,1.0);
			gl_Position    = gl_ModelViewProjectionMatrix*posicio;
			gl_TexCoord[0] = gl_TexCoordIn  [ i ][ 0 ];
			EmitVertex();
		
		}
	EndPrimitive();

		for( int i = 0 ; i < gl_VerticesIn ; i++ )
		{
			if(i == 0) posicio = vec4(pos, -2.1, -pos, 1.0);
			else if(i==1) posicio = vec4(-pos, -2.1, -pos, 1.0);
			else posicio = vec4(pos, -2.1, pos, 1.0);
			gl_FrontColor  =  vec4(1.0,0.0,1.0,1.0);
			gl_Position    = gl_ModelViewProjectionMatrix*posicio;
			gl_TexCoord[0] = gl_TexCoordIn  [ i ][ 0 ];
			EmitVertex();
		
		}
	EndPrimitive();

	}

	//lo recibimos en object space y lo queremmos en clipping
	for( int i = 0 ; i < gl_VerticesIn ; i++ )
	{
		gl_FrontColor  = gl_FrontColorIn[ i ];
		gl_Position    = gl_ModelViewProjectionMatrix*gl_PositionIn  [ i ];
		gl_TexCoord[0] = gl_TexCoordIn  [ i ][ 0 ];
		EmitVertex();
		
	}
	EndPrimitive();

for( int i = 0 ; i < gl_VerticesIn ; i++ )
	{
		vec4 posicio = vec4(gl_PositionIn[i].x, -2.0, gl_PositionIn[i].z, 1.0);
		
		gl_FrontColor  = vec4(0.0,0.0,0.0,1.0);
		gl_Position    = gl_ModelViewProjectionMatrix*posicio;
		gl_TexCoord[0] = gl_TexCoordIn  [ i ][ 0 ];
		EmitVertex();
	}
	
	EndPrimitive();


	

	
}
