// simple vertex shader
	
	varying vec3 N;
	varying vec3 Vobs;

void main()
{
	N = gl_NormalMatrix*gl_Normal;
	N = normalize(N);
	

	//Ma = gl_LightModel.ambient

	

	Vobs = vec3(gl_ModelViewMatrix*gl_Vertex);

	

	gl_Position    = gl_ModelViewProjectionMatrix * gl_Vertex;
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
