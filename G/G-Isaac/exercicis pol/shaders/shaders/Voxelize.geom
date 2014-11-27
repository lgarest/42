// simple geometry shader

// these lines enable the geometry shader support.
#version 120
#extension GL_EXT_geometry_shader4 : enable

varying in vec4 pos[3];
const float steps = 0.02;

/*10*/
void main( void )
{
	vec4 centre = vec4(((pos[0]+pos[1]+pos[2])/3).xyz, 0.0);

	vec4 ttpos;
	for( int i = 0 ; i < /*gl_VerticesIn*/4 ; i++ )
	{
		//gl_Position    = gl_ModelViewProjectionMatrix * 
        //              (gl_PositionIn  [ i ]);
			 if (i == 0)ttpos = vec4(centre.x+0.5*steps, centre.y+0.5*steps, centre.z+0.5*steps, 1.0);
		else if (i == 1)ttpos = vec4(centre.x-0.5*steps, centre.y+0.5*steps, centre.z+0.5*steps, 1.0);
		else if (i == 2)ttpos = vec4(centre.x-0.5*steps, centre.y-0.5*steps, centre.z+0.5*steps, 1.0);
		else if (i == 3)ttpos = vec4(centre.x+0.5*steps, centre.y-0.5*steps, centre.z+0.5*steps, 1.0);
		
		gl_Position    = gl_ModelViewProjectionMatrix * ttpos;

		gl_TexCoord[0] = gl_TexCoordIn  [ 0 ][ 0 ];
		EmitVertex();
	}
	/*for( int i = 0 ; i < 4 ; i++ )
	{
			 if (i == 0)ttpos = vec4(centre.x+0.5*steps, centre.y+0.5*steps, centre.z-0.5*steps, 1.0);
		else if (i == 1)ttpos = vec4(centre.x-0.5*steps, centre.y+0.5*steps, centre.z-0.5*steps, 1.0);
		else if (i == 2)ttpos = vec4(centre.x-0.5*steps, centre.y-0.5*steps, centre.z-0.5*steps, 1.0);
		else if (i == 3)ttpos = vec4(centre.x+0.5*steps, centre.y-0.5*steps, centre.z-0.5*steps, 1.0);
		
		gl_Position    = gl_ModelViewProjectionMatrix * ttpos;

		gl_TexCoord[0] = gl_TexCoordIn  [ 0 ][ 0 ];
		EmitVertex();
	}*/
	EndPrimitive();

}
