// simple vertex shader
//para que funcionen las texturas, lo compilas habiendo quitado el 
//checkbox de "use GLSL Program" de la pesta�a scene, una vez compilado
// cargas una textura, y vuelves a darle al checkbox y palante
uniform float time;
uniform float Freq;
uniform float Ampl;
void main()
{

	
	gl_Vertex = gl_Vertex + ((Freq/Ampl)*time);
	
	gl_Position    = gl_ModelViewProjectionMatrix * gl_Vertex;
	gl_FrontColor  = vec4((gl_NormalMatrix * gl_Normal).z);
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
