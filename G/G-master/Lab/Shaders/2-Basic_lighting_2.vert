// simple vertex shader
varying vec3 new_vector;

void main()
{
	gl_Position    = gl_ModelViewProjectionMatrix * gl_Vertex;
    // gl_NormalMatrix ->  de "object space" a "eye space"
    // gl_Normal -> vector normal del vértice
	new_vector = gl_NormalMatrix * gl_Normal;
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
