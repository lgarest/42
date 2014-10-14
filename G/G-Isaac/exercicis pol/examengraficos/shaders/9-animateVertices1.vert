// wave.vert - moves vertices along the normals

// time contains the seconds sind the progam was linked.
uniform float time;
uniform float A;
uniform float F;

//
// entry point.
//
void main( void )
{
	vec3 v = gl_Vertex.xyz + gl_Normal * A * sin(time/F);
	// transform the attributes.
	gl_Position = gl_ModelViewProjectionMatrix * vec4( v, 1.0 );
	gl_FrontColor = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}

