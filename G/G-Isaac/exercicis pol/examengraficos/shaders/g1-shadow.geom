// simple geometry shader

// these lines enable the geometry shader support.
#version 120
#extension GL_EXT_geometry_shader4 : enable

void main( void ) {
	for(int i = 0 ; i < gl_VerticesIn ; i++ ) {
		gl_FrontColor  = gl_FrontColorIn[i];
		gl_Position = gl_ModelViewProjectionMatrix*(gl_PositionIn[i]);
		//gl_TexCoord[0] = gl_TexCoordIn  [ i ][ 0 ];
		EmitVertex();
	}
	EndPrimitive();
	for(int i = 0 ; i < gl_VerticesIn ; i++ ) {
		gl_FrontColor = (0, 0, 0, 0);
		vec4 newPosition = gl_PositionIn[i];
		gl_Position = gl_ModelViewProjectionMatrix*(newPosition);
		gl_Position.y = -2.0;
		EmitVertex();
	}
}
