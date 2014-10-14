// simple geometry shader

// these lines enable the geometry shader support.
#version 330 compatibility

in vec3 vNormal[3];
out vec3 gNormal;
in vec4 vColor[3];
out vec4 gColor;

void main( void )
{
	for( int i = 0 ; i < gl_in.length(); i++ )
	{
		gColor = vColor[i];
		gNormal = vNormal[i];
		gl_Position    = gl_in[i].gl_Position;
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		EmitVertex();
	}
	EndPrimitive();
	for(int i = 0; i < gl_in.length(); i++)
	{
		gColor  = vec4(0.0,0.0,0.0,0.0);
		gNormal = vNormal[i];
		gl_Position    =  gl_in[i].gl_Position;
		gl_Position.y = -2;
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		EmitVertex();
	}
}
