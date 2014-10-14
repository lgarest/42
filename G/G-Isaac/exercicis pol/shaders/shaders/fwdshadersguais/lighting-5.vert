// simple vertex shader

varying vec3 N, V, L;

uniform bool world;

void main()
{
	gl_Position    = gl_ModelViewProjectionMatrix * gl_Vertex;
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
	if(world) {
		N = gl_Normal;
		V = (gl_ModelViewMatrixInverse * vec4(0,0,0,1)).xyz - gl_Vertex.xyz;
		L = (gl_ModelViewMatrixInverse * gl_LightSource[0].position).xyz - gl_Vertex.xyz;
	}
	else {
		N = gl_NormalMatrix * gl_Normal;
		V = - (gl_ModelViewMatrix * gl_Vertex).xyz;
		L = (gl_LightSource[0].position - (gl_ModelViewMatrix * gl_Vertex)).xyz;
	}

}
