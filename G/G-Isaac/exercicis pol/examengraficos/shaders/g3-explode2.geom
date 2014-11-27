// simple geometry shader

// these lines enable the geometry shader support.
#version 120
#extension GL_EXT_geometry_shader4 : enable
uniform float time;
varying in vec3 normal[];

void main( void ) {
	float t = mod(time, 5.0);
	vec3 gNormal = (normal[0] + normal[1] + normal[2])/3.0;
	//vec4 centro = (gl_PositionIn[0] + gl_PositionIn[1] + gl_PositionIn)/3.0;
	vec4 trans = vec4(speed*t*gNormal, 0.0);
	for(int i = 0 ; i < gl_VerticesIn ; i++ ) {
		gl_FrontColor  = gl_FrontColorIn[i];
		vec4 newPosition = rotateAroundZ(t*angSpeed, gl_PositionIn[i]);
		gl_Position = gl_ModelViewProjectionMatrix*(newPosition+trans);
		//gl_TexCoord[0] = gl_TexCoordIn  [ i ][ 0 ];
		EmitVertex();
	}
}
