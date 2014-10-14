// simple geometry shader

// these lines enable the geometry shader support.
#version 120
#extension GL_EXT_geometry_shader4 : enable

varying in vec4 pos[3];
varying in vec3 norm[3];
uniform float time;
const float speed = 1.2;
const float angSpeed = 8.0;
/*12*/
void main( void )
{
	vec4 tnorm = vec4((norm[0]+norm[1]+norm[2])/3, 0.0);
	vec4 tpos = vec4(((pos[0]+pos[1]+pos[2])/3).xyz, 0.0);
	for( int i = 0 ; i < gl_VerticesIn ; i++ )
	{
		float ang = angSpeed*time;
		gl_FrontColor  = gl_FrontColorIn[ i ];
		vec4 posGir = gl_PositionIn  [ i ] - tpos;
		posGir = vec4(posGir.x*cos(ang) + posGir.y*sin(ang),
					posGir.x*-sin(ang) + posGir.y*cos(ang),
					posGir.z, 1.0);

		gl_Position    = gl_ModelViewProjectionMatrix * 
                      ((posGir + tpos) + tnorm*time*speed);
		
		gl_TexCoord[0] = gl_TexCoordIn  [ i ][ 0 ];
		EmitVertex();
	}
	EndPrimitive();
}
