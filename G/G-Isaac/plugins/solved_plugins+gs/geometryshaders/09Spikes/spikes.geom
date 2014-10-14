// simple geometry shader

// these lines enable the geometry shader support.
#version 120
#extension GL_EXT_geometry_shader4 : enable

uniform float disp;

void main( void )
{


	vec3 cara1 = gl_PositionIn[1].xyz - gl_PositionIn[0].xyz;
	vec3 cara2 = gl_PositionIn[2].xyz - gl_PositionIn[0].xyz;
    vec3 normal = normalize(cross(cara1,cara2));

	vec4 center = ((gl_PositionIn[0] + gl_PositionIn[1] + gl_PositionIn[2])/3.0);
	vec4 center_Tex = ((gl_TexCoordIn[0][0] + gl_TexCoordIn[1][0] + gl_TexCoordIn[2][0])/3.0);

	vec4 desplacament = vec4((normal*disp),0.0);
	center = (center-desplacament);

	gl_FrontColor  = gl_FrontColorIn[ 0 ];
	gl_Position    = gl_PositionIn  [ 0 ];
//	gl_TexCoord[0] = gl_TexCoordIn  [ 0 ][ 0 ];
	EmitVertex();
	gl_FrontColor  = gl_FrontColorIn[ 1 ];
	gl_Position    = gl_PositionIn  [ 1 ];
//	gl_TexCoord[0] = gl_TexCoordIn  [ 1 ][ 0 ];
	EmitVertex();
	gl_FrontColor  = vec4(1.0,1.0,1.0,0.0);
	gl_Position    = center;
	gl_TexCoord[0] = center_Tex;
	EmitVertex();
	EndPrimitive();

	gl_FrontColor  = gl_FrontColorIn[ 2 ];
	gl_Position    = gl_PositionIn  [ 2 ];
//	gl_TexCoord[0] = gl_TexCoordIn  [ 2 ][ 0 ];
	EmitVertex();
	gl_FrontColor  = vec4(1.0,1.0,1.0,0.0);
	gl_Position    = center;
//	gl_TexCoord[0] = center_Tex;
	EmitVertex();
	gl_FrontColor  = gl_FrontColorIn[ 0 ];
	gl_Position    = gl_PositionIn  [ 0 ];
//	gl_TexCoord[0] = gl_TexCoordIn  [ 0 ][ 0 ];
	EmitVertex();
	EndPrimitive();

	gl_FrontColor  = gl_FrontColorIn[ 1 ];
	gl_Position    = gl_PositionIn  [ 1 ];
//	gl_TexCoord[0] = gl_TexCoordIn  [ 1 ][ 0 ];
	EmitVertex();
	gl_FrontColor  = gl_FrontColorIn[ 2 ];
	gl_Position    = gl_PositionIn  [ 2 ];
//	gl_TexCoord[0] = gl_TexCoordIn  [ 2 ][ 0 ];
	EmitVertex();
	gl_FrontColor  = vec4(1.0,1.0,1.0,0.0);
	gl_Position    = center;
//	gl_TexCoord[0] = center_Tex;
	EmitVertex();
	EndPrimitive();
}
