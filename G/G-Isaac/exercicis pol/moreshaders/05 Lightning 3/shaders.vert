// simple vertex shader

varying vec4 Vobs;
varying vec3 Nobs;

void main()
{
	Vobs    = (gl_ModelViewMatrix * gl_Vertex);
	Nobs = (gl_NormalMatrix * gl_Normal);
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
	//gl_FrontColor  = gl_FrontMaterial.emission + amb;
	//gl_FrontColor  = gl_FrontMaterial.emission + (amb+diff);
	//gl_FrontColor  = (gl_FrontMaterial.emission + (amb+diff+spec));
	//gl_TexCoord[0] = gl_MultiTexCoord0;
}
