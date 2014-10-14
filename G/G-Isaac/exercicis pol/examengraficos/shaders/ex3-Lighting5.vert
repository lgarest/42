// simple vertex shader
uniform bool world;
varying vec3 normal;
varying vec4 position;

void main()
{
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
	gl_TexCoord[0] = gl_MultiTexCoord0;
	gl_FrontColor = gl_Color;
	if (world) {
		position = gl_Vertex;
		normal = gl_Normal;
	}
	else {
		position = gl_Position;
		normal  = gl_NormalMatrix * gl_Normal;
	}
}
