// simple vertex shader
uniform float time;
uniform float A;
uniform float F;

void main(){
	// el nuevo vector es la posicion del vértice más su normal
	// * la amplitud * sinusoidal del tiempo/frecuencia
	vec3 v = gl_Vertex.xyz + gl_Normal * A * sin(time/F);
	//
	gl_Position    = gl_ModelViewProjectionMatrix * vec4(v,1.0);
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
