// simple geometry shader

// these lines enable the geometry shader support.
#version 120
#extension GL_EXT_geometry_shader4 : enable

varying in vec4 pos[3];
varying in vec3 norm[3];
uniform float time;
const float speed = 1.2;
/*11*/
void main( void )
{
	vec4 tnorm = vec4((norm[0]+norm[1]+norm[2])/3, 0.0);
	for( int i = 0 ; i < gl_VerticesIn ; i++ )
	{
		gl_FrontColor  = gl_FrontColorIn[ i ];
		gl_Position    = gl_ModelViewProjectionMatrix * 
                      (gl_PositionIn  [ i ]+tnorm*time*speed);
		//gl_Position.y -= 2;
		gl_TexCoord[0] = gl_TexCoordIn  [ i ][ 0 ];
		EmitVertex();
	}
	EndPrimitive();
}
