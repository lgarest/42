uniform float time;
varying vec3 pos;

void main(){
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
	pos = gl_Position.xyz / gl_Position.w;
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
