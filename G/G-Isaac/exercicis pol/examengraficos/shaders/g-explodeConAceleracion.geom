// simple geometry shader

// these lines enable the geometry shader support.
#version 120
#extension GL_EXT_geometry_shader4 : enable
uniform float time;
const vec3 a = vec3(0.0, -9.8, 0.0);
uniform float speed;
varying in vec3 normal[];

void main( void ) {
	float t = mod(time, 3.0);
	vec4 center = (gl_PositionIn[0] + gl_PositionIn[1] + gl_PositionIn[2])/3.0;
	
	vec3 v0 = speed * center.xyz;
	vec4 trans = vec4(v0*t+0.5*a*t*t, 0.0);
	for(int i = 0 ; i < gl_VerticesIn ; i++ ) {
		gl_FrontColor  = gl_FrontColorIn[i];
		gl_Position = gl_ModelViewProjectionMatrix*(gl_PositionIn[i]+trans);
		//gl_TexCoord[0] = gl_TexCoordIn  [ i ][ 0 ];
		EmitVertex();
	}
}
