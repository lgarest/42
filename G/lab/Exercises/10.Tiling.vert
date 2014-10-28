// simple vertex shader
uniform float tiles;
varying vec2 texture_Coords;

void main(){
	gl_Position    = gl_ModelViewProjectionMatrix * gl_Vertex;
	// color del vértice es el vector resultante de multiplicar
	// su normal por las matriz de obj -> eye 
	gl_FrontColor  = vec4((gl_NormalMatrix * gl_Normal).z);
	gl_TexCoord[0] = gl_MultiTexCoord0 * tiles;
}
