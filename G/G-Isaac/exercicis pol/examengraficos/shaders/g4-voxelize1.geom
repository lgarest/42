// simple geometry shader

// these lines enable the geometry shader support.
#version 120
#extension GL_EXT_geometry_shader4 : enable
uniform float step;
varying in vec3 normal[];

void main( void ) {
	vec3 gNormal = (normal[0] + normal[1] + normal[2])/3.0;
	vec4 center = ((gl_PositionIn[0] + gl_PositionIn[1] + gl_PositionIn[2])/3.0);
	float size = step/2;
	/*vec4 newPos1 = (center.x-size, center.y-size, center.z+size, center.w);
	vec4 newPos1;
	newPos1.x = center.x-size;
	newPos1.y = center.y-size;
	newPos1.z = center.z+size
	newPos1.w = center.w;
	vec4 newPos2 = (center.x+size, center.y-size, center.z+size, center.w);
	vec4 newPos3 = (center.x-size, center.y+size, center.z+size, center.w);
	vec4 newPos4 = (center.x+size, center.y+size, center.z+size, center.w);*/
	/*for(int i = 0 ; i < gl_VerticesIn ; i++ ) {
		gl_FrontColor  = gl_FrontColorIn[i];
		gl_Position = gl_ModelViewProjectionMatrix*(gl_PositionIn[i]-step);
		//gl_TexCoord[0] = gl_TexCoordIn  [ i ][ 0 ];
		EmitVertex();
	}*/
	gl_FrontColor  = gl_FrontColorIn[0];
	gl_Position = gl_ModelViewProjectionMatrix*(vec4(center.x+size, center.y-size, center.z+size, center.w));
	EmitVertex();
	gl_FrontColor  = gl_FrontColorIn[0];
	gl_Position = gl_ModelViewProjectionMatrix*(vec4(center.x+size, center.y-size, center.z+size, center.w));
	EmitVertex();
	gl_FrontColor  = gl_FrontColorIn[0];
	gl_Position = gl_ModelViewProjectionMatrix*(vec4(center.x-size, center.y+size, center.z+size, center.w));
	EmitVertex();
	gl_FrontColor  = gl_FrontColorIn[0];
	gl_Position = gl_ModelViewProjectionMatrix*(vec4(center.x+size, center.y+size, center.z+size, center.w));
	EmitVertex();
	gl_FrontColor  = gl_FrontColorIn[0];
	gl_Position = gl_ModelViewProjectionMatrix*(vec4(center.x+size, center.y-size, center.z+size, center.w));
	EmitVertex();
	EndPrimitive();
}
