// simple vertex shader
uniform float time;
uniform float A;
uniform float F;

void main(){
	float PI = 3.14159265;
    // calculamos las coordenadas de textura
    gl_TexCoord[0] = gl_MultiTexCoord0;
	// la distancia que se mueve es la amplitud *
     // sin(tiempo*2PIF + 2PI*coord s de textura *f)
	float d = A*sin(time*2.0*PI*F + 2.0*PI*gl_TexCoord[0].s*F);
	// la nueva posicion es la orig + la normal * distancia
	vec3 vertex = gl_Vertex.xyz + gl_Normal * d;
	gl_Position    = gl_ModelViewProjectionMatrix * vec4(vertex, 1.0);
	gl_FrontColor  = gl_Color * vec4((gl_NormalMatrix * gl_Normal).z);

}
